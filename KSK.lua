do
  local lfwm_7e97626092df4313 = "LFWM1_XFYgxFhwlXshNr89c7mk9e7UnYTV0AVw"
  if false then error(lfwm_7e97626092df4313) end
end




local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local Stats = game:GetService("Stats")
local HS = game:GetService("HttpService")


do
    local genv = (type(getgenv) == "function" and getgenv()) or nil
    local function adopt(name)
        if _G[name] ~= nil then return end
        local value = rawget(_G, name)
        if value == nil and genv then value = rawget(genv, name) end
        if value == nil and syn then value = rawget(syn, name) or rawget(syn, "get" .. name) end
        if value ~= nil then _G[name] = value end
    end
    for _, name in ipairs({"request", "http_request", "getconnections", "getcustomasset", "getsynasset", "isfile", "readfile", "writefile", "delfile", "fireproximityprompt"}) do
        adopt(name)
    end
end

request = request or http_request or (type(getgenv) == "function" and (getgenv().request or getgenv().http_request)) or (syn and syn.request)
local player = Players.LocalPlayer


local M = {}

local INTRO_AUDIO_FILE = "KINGNASIRDANCEBUENAVIDAMALAFAMA(SLOWED&REVERB).mp3"
local INTRO_AUDIO_URL = "https://files.manuscdn.com/user_upload_by_module/session_file/310519663891813390/ttKHYemCuQyPnQsB.mp3"
local INTRO_AUDIO_START = 25
local introSoundInstance = nil


M.INTRO_MUSIC_OPTIONS = {
    {name="King Nasir (intro anterior)", file="KINGNASIRDANCEBUENAVIDAMALAFAMA(SLOWED&REVERB).mp3", url="https://files.manuscdn.com/user_upload_by_module/session_file/310519663891813390/ttKHYemCuQyPnQsB.mp3", start=25},
    {name="Blue Bands", file="S1NXY_IntroSong_BlueBands.mp3", url="https://files.catbox.moe/mzvrir.mp3", start=0},
    {name="Legacy", file="S1NXY_IntroSong_Legacy.mp3", url="https://files.catbox.moe/siru6c.mp3", start=0},
    {name="Tesla", file="S1NXY_IntroSong_Tesla.mp3", url="https://files.catbox.moe/n85fch.mp3", start=0},
    {name="paznerknacker", file="S1NXY_IntroSong_Paznerknacker.mp3", url="https://files.catbox.moe/izcvhm.mp3", start=0},
    {name="Pure Cocaine", file="S1NXY_IntroSong_PureCocaine.mp3", url="https://files.catbox.moe/dvjtjk.mp3", start=0},
    {name="nuts", file="S1NXY_IntroSong_Nuts.mp3", url="https://files.catbox.moe/iyw1cb.mp3", start=0},
    {name="Gelato", file="S1NXY_IntroSong_Gelato.mp3", url="https://files.catbox.moe/zf2z42.mp3", start=0},
    {name="FREAKED OUT", file="S1NXY_IntroSong_FreakedOut.mp3", url="https://files.catbox.moe/dyt2ja.mp3", start=0},
    {name="Scam Likely", file="S1NXY_IntroSong_ScamLikely.mp3", url="https://files.catbox.moe/pr85mz.mp3", start=0},
    {name="No intro music", silent=true},
}
M.INTRO_MUSIC_NAMES = {}
for _, option in ipairs(M.INTRO_MUSIC_OPTIONS) do table.insert(M.INTRO_MUSIC_NAMES, option.name) end

M.SONG_OPTIONS = {
    {title="Tuff Song", url="https://files.catbox.moe/rvf2vy.mp3", file="tuffsong.mp3", volume=0.75},
    {title="orula", url="https://files.catbox.moe/v20ko9.mp3", file="friosong.mp3", volume=0.85},
    {title="X.O.X.O", url="https://files.catbox.moe/jghp0f.mp3", file="xoxosong.mp3", volume=0.75},
    {title="beretta", url="https://file.garden/algLafWA1jk8WMfK/Beretta%20-%20video%20oficial(MP3_160K).mp3", file="overseer_beretta_filegarden.mp3", volume=0.75, startAt=10},
    {title="to the O", url="https://file.garden/algLafWA1jk8WMfK/King%20Von%20-%20Took%20Her%20To%20The%20O%20(Lyrics)(MP3_160K).mp3", file="overseer_to_the_o_filegarden.mp3", volume=0.75, startAt=0},
    {title="LAJA", url="https://file.garden/algLafWA1jk8WMfK/LAJA%20-%20NADIE%20TA%20FRIO%20(Letra)(MP3_160K).mp3", file="overseer_laja_nadie_ta_frio_filegarden.mp3", volume=0.75, startAt=0},
    {title="HORA 0", url="https://file.garden/algLafWA1jk8WMfK/Myke%20Towers%20-%20HORA%20CERO%20(Lyrics)(MP3_160K).mp3", file="overseer_hora_0_filegarden.mp3", volume=0.75, startAt=0},
    {title="Lucid Dreams", url="https://file.garden/algLafWA1jk8WMfK/Lucid%20Dreams%20-%20Clean%20-%20Juice%20WRLD(MP3_160K).mp3", file="overseer_lucid_dreams_filegarden.mp3", volume=0.75, startAt=0},
}
M.SONG_NAMES = {}
for _, option in ipairs(M.SONG_OPTIONS) do table.insert(M.SONG_NAMES, option.title) end
M.songChoice = 1

local function getLocalAssetLoader()
    return (type(getcustomasset) == "function" and getcustomasset)
        or (type(getsynasset) == "function" and getsynasset)
end

local function downloadLocalAsset(url, fileName)
    if type(isfile) ~= "function" or type(writefile) ~= "function" then return false end
    if isfile(fileName) then return true end
    local ok, data = pcall(function()
        local req = request or http_request or (syn and syn.request)
        if req then
            local response = req({Url = url, Method = "GET"})
            if response and (response.Body or response.body) then
                return response.Body or response.body
            end
        end
        if game and game.HttpGet then return game:HttpGet(url) end
    end)
    if ok and type(data) == "string" and #data > 0 then
        local wrote = pcall(function() writefile(fileName, data) end)
        return wrote and isfile(fileName)
    end
    return false
end

local function getSelectedIntroMusic()
    local idx = math.clamp(tonumber(M.introSongChoice) or 1, 1, #M.INTRO_MUSIC_OPTIONS)
    M.introSongChoice = idx
    return M.INTRO_MUSIC_OPTIONS[idx]
end

local function playLocalIntroSound()
    if not M or M.introSoundEnabled == false then return nil end
    local option = getSelectedIntroMusic()
    if not option or option.silent then return nil end
    local assetLoader = getLocalAssetLoader()
    local assetId = nil
    if assetLoader and type(isfile) == "function" then
        downloadLocalAsset(option.url, option.file)
        if isfile(option.file) then
            local ok, id = pcall(assetLoader, option.file)
            if ok and id then assetId = id end
        end
    end
    if not assetId then
        
        assetId = "rbxassetid://120267378058133"
    end
    local s = nil
    pcall(function()
        if introSoundInstance then introSoundInstance:Destroy() end
        s = Instance.new("Sound")
        s.Name = "S1NXY_IntroMusic"
        s.SoundId = assetId
        s.Volume = 0.65
        s.Looped = false
        s.Parent = SoundService
        introSoundInstance = s
        if not s.IsLoaded then s.Loaded:Wait() end
        s:Play()
        local startTime = option.start or (assetId == "rbxassetid://120267378058133" and 10 or 0)
        if startTime > 0 then
            task.spawn(function()
                for i=1,5 do
                    if not s or not s.Parent then break end
                    s.TimePosition = startTime
                    if math.abs(s.TimePosition - startTime) < 0.5 then break end
                    task.wait(0.1)
                end
            end)
        end
    end)
    return s
end

local function stopLocalIntroSound()
    if introSoundInstance then
        pcall(function() introSoundInstance:Stop(); introSoundInstance:Destroy() end)
        introSoundInstance = nil
    end
end

function M.previewIntroMusic()
    stopLocalIntroSound()
    playLocalIntroSound()
    task.delay(8, function()
        if introSoundInstance then stopLocalIntroSound() end
    end)
end

local songSoundInstance = nil
local songEndedConnection = nil
local songPaused = false
local jukeboxLoopEnabled = false
local jukeboxVolume = 0.75

local function stopSongSound()
    if songEndedConnection then pcall(function() songEndedConnection:Disconnect() end); songEndedConnection = nil end
    if songSoundInstance then
        pcall(function() songSoundInstance:Stop(); songSoundInstance:Destroy() end)
        songSoundInstance = nil
    end
    songPaused = false
end

local function getSelectedSong()
    if #M.SONG_OPTIONS == 0 then return nil end
    local idx = math.clamp(tonumber(M.songChoice) or 1, 1, #M.SONG_OPTIONS)
    M.songChoice = idx
    return M.SONG_OPTIONS[idx]
end

local function playSongAt(index)
    if #M.SONG_OPTIONS == 0 then return end
    M.songChoice = math.clamp(tonumber(index) or 1, 1, #M.SONG_OPTIONS)
    local option = getSelectedSong()
    if not option then return end
    local assetLoader = getLocalAssetLoader()
    if not assetLoader or type(isfile) ~= "function" then return end
    stopSongSound()
    downloadLocalAsset(option.url, option.file)
    if not isfile(option.file) then return end
    local ok, assetId = pcall(assetLoader, option.file)
    if not ok or not assetId then return end
    local s = Instance.new("Sound")
    s.Name = "SelectedMusic"
    s.SoundId = assetId
    s.Volume = jukeboxVolume or option.volume or 0.75
    s.Looped = jukeboxLoopEnabled == true
    s.Parent = SoundService
    songSoundInstance = s
    songEndedConnection = s.Ended:Connect(function()
        if songSoundInstance == s then
            local nextIndex = (M.songChoice % #M.SONG_OPTIONS) + 1
            playSongAt(nextIndex)
        end
    end)
    if not s.IsLoaded then s.Loaded:Wait() end
    pcall(function() s:Play() end)
    if option.startAt and option.startAt > 0 then
        task.spawn(function()
            for i=1,5 do
                if not s or not s.Parent then break end
                s.TimePosition = option.startAt
                if math.abs(s.TimePosition - option.startAt) < 0.5 then break end
                task.wait(0.1)
            end
        end)
    end
    songPaused = false
end

function M.selectSong(index)
    local idx = tonumber(index) or 1
    if idx == M.songChoice and songSoundInstance then
        if songPaused then
            pcall(function() songSoundInstance:Resume() end)
            songPaused = false
        else
            pcall(function() songSoundInstance:Pause() end)
            songPaused = true
        end
    else
        playSongAt(idx)
    end
end

function M.toggleSongPause()
    if not songSoundInstance then
        playSongAt(M.songChoice)
    elseif songPaused then
        pcall(function() songSoundInstance:Resume() end)
        songPaused = false
    else
        pcall(function() songSoundInstance:Pause() end)
        songPaused = true
    end
end
function M.jukeboxNext()
    if #M.SONG_OPTIONS == 0 then return end
    M.selectSong((M.songChoice % #M.SONG_OPTIONS) + 1)
end
function M.jukeboxPrevious()
    if #M.SONG_OPTIONS == 0 then return end
    M.selectSong(((M.songChoice - 2) % #M.SONG_OPTIONS) + 1)
end
function M.jukeboxSetVolume(value)
    jukeboxVolume = math.clamp(tonumber(value) or jukeboxVolume or 0.75, 0, 1.2)
    if songSoundInstance then songSoundInstance.Volume = jukeboxVolume end
end
function M.jukeboxToggleLoop()
    jukeboxLoopEnabled = not jukeboxLoopEnabled
    if songSoundInstance then songSoundInstance.Looped = jukeboxLoopEnabled end
    return jukeboxLoopEnabled
end




M.introSoundEnabled = true
M.introSongChoice = 1
M.introGUIEnabled = true
M.resetOnDeathEnabled = false
M.resetOnMedusaEnabled = false
if isfile and isfile("CherryConfig.json") then
    local ok, data = pcall(function() return HS:JSONDecode(readfile("CherryConfig.json")) end)
    if ok and type(data) == "table" then
        if data.introSoundEnabled ~= nil then M.introSoundEnabled = data.introSoundEnabled end
        if data.introSongChoice then M.introSongChoice = data.introSongChoice end
        if data.introGUIEnabled ~= nil then M.introGUIEnabled = data.introGUIEnabled end
        if type(data.Theme) == "string" then M._savedTheme = data.Theme end
        if type(data.colorScheme) == "string" then M._savedTheme = data.colorScheme end
    end
end


local introGuiStates = {}
local function showAceIntro()
    local introParent = player:WaitForChild("PlayerGui")
    local origSize = (M.mainFrame and M.mainFrame.Size) or UDim2.fromOffset(356, 536)
    local introFinished = false
    local introGui
    local function hideScriptGuis()
        local prefixes = {"S1NXY", "Movee", "Cherry", "K7", "Vanta", "Ace", "S1NXYStatus"}
        for _, obj in ipairs(introParent:GetChildren()) do
            if obj:IsA("ScreenGui") and obj.Name ~= "S1NXY_AdaptIntro" then
                local hide = false
                for _, prefix in ipairs(prefixes) do
                    if obj.Name:sub(1, #prefix) == prefix then hide = true break end
                end
                if hide then
                    introGuiStates[obj] = obj.Enabled
                    obj.Enabled = false
                end
            end
        end
    end
    local function restoreScriptGuis()
        for obj, enabled in pairs(introGuiStates) do
            if obj and obj.Parent then obj.Enabled = enabled end
        end
        introGuiStates = {}
    end
    M._introActive = true
    pcall(playLocalIntroSound)
    hideScriptGuis()
    if M.mainFrame then M.mainFrame.Visible = false; M.mainFrame.Size = UDim2.new(0,0,0,0) end
    if M._minPill then M._minPill.Visible = false end
    if M.mobGuiRef then M.mobGuiRef.Enabled = false end
    if M.cleanToggleGui then M.cleanToggleGui.Enabled = false end
    if M.statusGui then M.statusGui.Enabled = false end
    if M.headIndicator and M.headIndicator.bb then M.headIndicator.bb.Enabled = false end
    local old = introParent:FindFirstChild("S1NXY_AdaptIntro")
    if old then pcall(function() old:Destroy() end) end
    introGui = Instance.new("ScreenGui")
    introGui.Name = "S1NXY_AdaptIntro"
    introGui.IgnoreGuiInset = true
    introGui.ResetOnSpawn = false
    introGui.DisplayOrder = 1000
    introGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    introGui.Parent = introParent
    local intro = Instance.new("Frame")
    intro.Name = "S1NXYIntro"
    intro.Size = UDim2.fromScale(1,1)
    intro.BackgroundColor3 = Color3.fromRGB(5,5,8)
    intro.BackgroundTransparency = 0.5
    intro.BorderSizePixel = 0
    intro.ZIndex = 1000
    intro.Parent = introGui
    local chainStage = Instance.new("Frame")
    chainStage.Name = "ChainSpearStage"
    chainStage.AnchorPoint = Vector2.new(0.5,0.5)
    chainStage.Position = UDim2.new(0.5,0,0.5,0)
    chainStage.Size = UDim2.new(0.64,0,0.64,0)
    chainStage.BackgroundTransparency = 1
    chainStage.ZIndex = 1000
    chainStage.Parent = intro
    Instance.new("UIAspectRatioConstraint", chainStage)
    local sizeConstraint = Instance.new("UISizeConstraint", chainStage)
    sizeConstraint.MinSize = Vector2.new(200,200)
    sizeConstraint.MaxSize = Vector2.new(280,280)
    local rotorData = {-1094.822,-1095.4,-1095.978,-1096.515,-1097.052,-1097.548,-1098.004,-1098.419,-1098.794,-1099.128,-1099.421}
    for i, rotation in ipairs(rotorData) do
        local rotor = Instance.new("Frame")
        rotor.Name = "ChainSpearRotor" .. i
        rotor.AnchorPoint = Vector2.new(0.5,0.5)
        rotor.Position = UDim2.new(0.5,0,0.5,0)
        rotor.Size = UDim2.fromScale(1,1)
        rotor.BackgroundTransparency = 1
        rotor.Rotation = rotation
        rotor.ZIndex = 1000
        rotor.Parent = chainStage
        local trail = Instance.new("ImageLabel")
        trail.Name = "ChainSpearTrail" .. i
        trail.AnchorPoint = Vector2.new(0.73,0.02)
        trail.Position = UDim2.new(0.5,0,0.5,0)
        trail.Size = UDim2.new(0.553,0,0.829,0)
        trail.BackgroundTransparency = 1
        trail.Image = "rbxassetid://118963313877514"
        trail.ImageColor3 = Color3.fromRGB(205,215,235)
        trail.ImageTransparency = 0.998
        trail.ScaleType = Enum.ScaleType.Fit
        trail.ZIndex = 1000
        trail.Parent = rotor
        task.delay((i-1)*0.035, function()
            if trail.Parent then TweenService:Create(trail,TweenInfo.new(0.45),{ImageTransparency=0.12}):Play() end
        end)
        task.spawn(function()
            local speed = 0.38 + i*0.045
            while introGui and introGui.Parent and rotor.Parent do
                rotor.Rotation = rotor.Rotation + speed
                RunService.Heartbeat:Wait()
            end
        end)
    end
    local introLogo = Instance.new("TextLabel")
    introLogo.Name = "IntroBanner"
    introLogo.AnchorPoint = Vector2.new(0.5,0.5)
    introLogo.Position = UDim2.new(0.5,0,0.50,0)
    introLogo.Size = UDim2.new(0.34,0,0,70)
    introLogo.BackgroundTransparency = 1
    introLogo.Text = "S1NXY"
    introLogo.TextColor3 = Color3.fromRGB(255,255,255)
    introLogo.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    introLogo.TextStrokeTransparency = 0.18
    introLogo.TextSize = 42
    introLogo.Font = Enum.Font.GothamBlack
    introLogo.ZIndex = 1002
    introLogo.Parent = intro
    local tapAnywhere = Instance.new("TextLabel")
    tapAnywhere.AnchorPoint = Vector2.new(0.5,0.5)
    tapAnywhere.Position = UDim2.new(0.5,0,0.50,48)
    tapAnywhere.Size = UDim2.new(0.7,0,0,20)
    tapAnywhere.BackgroundTransparency = 1
    tapAnywhere.Text = "TAP ANYWHERE TO SKIP"
    tapAnywhere.TextColor3 = Color3.fromRGB(255,255,255)
    tapAnywhere.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    tapAnywhere.TextStrokeTransparency = 0.2
    tapAnywhere.TextSize = 11
    tapAnywhere.Font = Enum.Font.GothamBlack
    tapAnywhere.ZIndex = 1003
    tapAnywhere.Parent = intro
    local discordInvite = tapAnywhere:Clone()
    discordInvite.Position = UDim2.new(0.5,0,0.50,68)
    discordInvite.Text = "discord.gg/2qxZf837f"
    discordInvite.TextSize = 10
    discordInvite.Parent = intro
    local function finishIntro()
        if introFinished then return end
        introFinished = true
        M._introActive = false
        pcall(stopLocalIntroSound)
        TweenService:Create(intro,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
        for _,obj in ipairs(chainStage:GetDescendants()) do
            if obj:IsA("ImageLabel") then TweenService:Create(obj,TweenInfo.new(0.25),{ImageTransparency=1}):Play() end
        end
        TweenService:Create(introLogo,TweenInfo.new(0.25),{TextTransparency=1,TextStrokeTransparency=1}):Play()
        TweenService:Create(tapAnywhere,TweenInfo.new(0.25),{TextTransparency=1,TextStrokeTransparency=1}):Play()
        TweenService:Create(discordInvite,TweenInfo.new(0.25),{TextTransparency=1,TextStrokeTransparency=1}):Play()
        task.delay(0.35,function()
            if introGui then introGui:Destroy() end
            restoreScriptGuis()
            if M.mainFrame then M.mainFrame.Size = origSize; M.mainFrame.Visible = M.menuOpen == true end
            if M._minPill then M._minPill.Visible = M.menuOpen ~= true end
            if M.mobGuiRef then M.mobGuiRef.Enabled = true end
            if M.cleanToggleGui then M.cleanToggleGui.Enabled = true end
            if M.statusGui then M.statusGui.Enabled = true end
            if M.headIndicator and M.headIndicator.bb then M.headIndicator.bb.Enabled = true end
        end)
    end
    local tapCatcher = Instance.new("TextButton")
    tapCatcher.Size = UDim2.fromScale(1,1)
    tapCatcher.BackgroundTransparency = 1
    tapCatcher.Text = ""
    tapCatcher.AutoButtonColor = false
    tapCatcher.ZIndex = 1004
    tapCatcher.Parent = intro
    tapCatcher.MouseButton1Click:Connect(finishIntro)
    task.spawn(function()
        while not introFinished and tapAnywhere.Parent do
            TweenService:Create(tapAnywhere,TweenInfo.new(0.65),{TextTransparency=0.48}):Play(); task.wait(0.65)
            if introFinished then break end
            TweenService:Create(tapAnywhere,TweenInfo.new(0.65),{TextTransparency=0}):Play(); task.wait(0.65)
        end
    end)
    
end

task.spawn(showAceIntro)



M.CANDY_SKY_TAG = "MoveeSkyTheme"
M.currentSkyTheme = "Night"
M.CANDY_SKY_PRESETS = {
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
M.SkyOrder = {"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}

local function candyColor(rgb) return Color3.fromRGB(rgb[1],rgb[2],rgb[3]) end
function M.CandyApplyCustomSky(mode)
    for _,child in ipairs(Lighting:GetChildren()) do if child:GetAttribute(M.CANDY_SKY_TAG) then pcall(function() child:Destroy() end) end end
    local terrain=workspace:FindFirstChildOfClass("Terrain")
    if terrain then for _,child in ipairs(terrain:GetChildren()) do if child:GetAttribute(M.CANDY_SKY_TAG) then pcall(function() child:Destroy() end) end end end
    local preset=M.CANDY_SKY_PRESETS[mode]
    if not preset or preset.kind=="off" then Lighting.ClockTime=14;Lighting.Brightness=2;Lighting.OutdoorAmbient=Color3.fromRGB(127,127,127);Lighting.Ambient=Color3.fromRGB(127,127,127);Lighting.FogEnd=100000;Lighting.GlobalShadows=true;return end
    Lighting.FogStart=0;Lighting.FogEnd=100000;Lighting.FogColor=Color3.fromRGB(200,200,200);Lighting.ColorShift_Top=Color3.fromRGB(0,0,0);Lighting.ColorShift_Bottom=Color3.fromRGB(0,0,0);Lighting.GlobalShadows=true
    Lighting.ClockTime=preset.clock or 14;Lighting.Brightness=preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient=candyColor(preset.outAmb) end
    if preset.ambient then Lighting.Ambient=candyColor(preset.ambient) end
    if preset.sky then
        local skyInst=Instance.new("Sky");skyInst:SetAttribute(M.CANDY_SKY_TAG,true)
        if preset.sky.stars then skyInst.StarCount=preset.sky.stars end
        if preset.sky.moon then skyInst.MoonAngularSize=preset.sky.moon end
        if preset.sky.sun then skyInst.SunAngularSize=preset.sky.sun end
        if preset.sky.moonTex then skyInst.MoonTextureId="rbxasset://sky/moon.jpg" end
        skyInst.Parent=Lighting
    end
    if preset.atm then
        local atm=Instance.new("Atmosphere");atm:SetAttribute(M.CANDY_SKY_TAG,true)
        atm.Density=preset.atm.dens or 0.3;atm.Color=candyColor(preset.atm.color);atm.Decay=candyColor(preset.atm.decay);atm.Glare=preset.atm.glare or 1;atm.Haze=preset.atm.haze or 1;atm.Parent=Lighting
    end
    if preset.clouds and terrain then
        local clouds=Instance.new("Clouds");clouds:SetAttribute(M.CANDY_SKY_TAG,true)
        clouds.Cover=preset.clouds.cover or 0.5;clouds.Density=preset.clouds.dens or 0.5;clouds.Color=candyColor(preset.clouds.color);clouds.Parent=terrain
    end
end




M.PACKS = {
    ["Adidas Sports"] = {
        WalkAnim = 18537392113,
        RunAnim  = 18537384940,
        JumpAnim = 18537380791,
        FallAnim = 18537367238,
        SwimIdle = 18537387180,
        Swim     = 18537389531,
        Animation1 = 18537376492,
        Animation2 = 18537371272,
        ClimbAnim = 18537363391,
    },
    ["Adidas Community"] = {
        WalkAnim = 122150855457006,
        RunAnim  = 82598234841035,
        JumpAnim = 75290611992385,
        FallAnim = 98600215928904,
        SwimIdle = 109346520324160,
        Swim     = 133308483266208,
        Animation1 = 122257458498464,
        Animation2 = 102357151005774,
        ClimbAnim = 88763136693023,
    },
    ["Adidas Aura"] = {
        WalkAnim = 83842218823011,
        RunAnim  = 118320322718866,
        JumpAnim = 109996626521204,
        FallAnim = 95603166884636,
        SwimIdle = 94922130551805,
        Swim     = 134530128383903,
        Animation1 = 110211186840347,
        Animation2 = 114191137265065,
        ClimbAnim = 97824616490448,
    },
    ["Wicked Popular"] = {
        WalkAnim = 92072849924640,
        RunAnim = 72301599441680,
        JumpAnim = 104325245285198,
        FallAnim = 121152442762481,
        Animation1 = 118832222982049,
        ClimbAnim = 131326830509784,
        SwimIdle = 113199415118199,
        Swim = 99384245425157,
        Animation2 = 76049494037641,
    },
    Elder = {
        WalkAnim = 10921111375,
        RunAnim  = 10921104374,
        JumpAnim = 10921107367,
        FallAnim = 10921105765,
        SwimIdle = 10921110146,
        Swim     = 10921108971,
        ClimbAnim = 10921100400,
        Animation1 = 10921101664,
        Animation2 = 10921102574,
    },
    Zombie = {
        WalkAnim = 10921355261,
        RunAnim  = 616163682,
        JumpAnim = 10921351278,
        FallAnim = 10921350320,
        SwimIdle = 10921353442,
        Swim     = 10921352344,
        Animation1 = 10921344533,
        Animation2 = 10921345304,
        ClimbAnim = 10921343576,
    },
    Mage = {
        WalkAnim = 10921152678,
        RunAnim  = 10921148209,
        JumpAnim = 10921149743,
        FallAnim = 10921148939,
        SwimIdle = 10921151661,
        Swim     = 10921150788,
        ClimbAnim = 10921143404,
        Animation1 = 10921144709,
        Animation2 = 10921145797,
    },
    ["Catwalk Glam"] = {
        WalkAnim = 109168724482748,
        RunAnim  = 81024476153754,
        JumpAnim = 116936326516985,
        FallAnim = 92294537340807,
        SwimIdle = 98854111361360,
        Swim     = 134591743181628,
        ClimbAnim = 119377220967554,
        Animation1 = 133806214992291,
        Animation2 = 94970088341563,
    },
    Astronaut = {
        WalkAnim = 10921046031,
        RunAnim  = 10921039308,
        JumpAnim = 10921042494,
        FallAnim = 10921040576,
        SwimIdle = 10921045006,
        Swim     = 10921044000,
        ClimbAnim = 10921032124,
        Animation1 = 10921034824,
        Animation2 = 10921036806,
    },
    ['Wicked "Dancing Through Life"'] = {
        WalkAnim = 73718308412641,
        RunAnim  = 135515454877967,
        JumpAnim = 78508480717326,
        FallAnim = 78147885297412,
        SwimIdle = 129183123083281,
        Swim     = 110657013921774,
        ClimbAnim = 129447497744818,
        Animation1 = 92849173543269,
        Animation2 = 132238900951109,
    },
    Werewolf = {
        WalkAnim = 10921342074,
        RunAnim  = 10921336997,
        JumpAnim = nil,
        FallAnim = 10921337907,
        SwimIdle = 10921341319,
        Swim     = 10921340419,
        ClimbAnim = 10921329322,
        Animation1 = 10921330408,
        Animation2 = 10921333667,
    },
    Superhero = {
        WalkAnim = 10921298616,
        RunAnim  = 10921291831,
        JumpAnim = 10921294559,
        FallAnim = 10921293373,
        SwimIdle = 10921297391,
        Swim     = 10921295495,
        ClimbAnim = 10921286911,
        Animation1 = 10921288909,
        Animation2 = 10921290167,
    },
    Toy = {
        WalkAnim = 10921312010,
        RunAnim  = 10921306285,
        JumpAnim = 10921308158,
        FallAnim = 10921307241,
        SwimIdle = 10921310341,
        Swim     = 10921309319,
        ClimbAnim = 10921300839,
        Animation1 = 10921301576,
        Animation2 = nil,
    },
    ["No Boundaries"] = {
        WalkAnim = 18747074203,
        RunAnim  = 18747070484,
        JumpAnim = 18747069148,
        FallAnim = 18747062535,
        SwimIdle = 18747071682,
        Swim     = 18747073181,
        ClimbAnim = 18747060903,
        Animation1 = 18747067405,
        Animation2 = 18747063918,
    },
    NFL = {
        WalkAnim = 110358958299415,
        RunAnim  = 117333533048078,
        JumpAnim = 119846112151352,
        FallAnim = 129773241321032,
        SwimIdle = 79090109939093,
        Swim     = 132697394189921,
        ClimbAnim = 134630013742019,
        Animation1 = 92080889861410,
        Animation2 = 74451233229259,
    },
    ["Amazon Unboxed"] = {
        WalkAnim = 90478085024465,
        RunAnim  = 134824450619865,
        JumpAnim = 121454505477205,
        FallAnim = 94788218468396,
        SwimIdle = 129126268464847,
        Swim     = 105962919001086,
        ClimbAnim = 121145883950231,
        Animation1 = 98281136301627,
        Animation2 = nil,
    },
    Vampire = {
        WalkAnim = 10921326949,
        RunAnim  = 10921320299,
        JumpAnim = 10921322186,
        FallAnim = 10921321317,
        SwimIdle = 10921325443,
        Swim     = 10921324408,
        ClimbAnim = 10921314188,
        Animation1 = 10921315373,
        Animation2 = nil,
    },
    Ninja = {
        Run=656118852, Walk=656121766, Jump=656117878, Fall=656115606,
        Swim=656119721, SwimIdle=656121397, Climb=656114359,
        Idle={656117400,656118341,886742569}
    },
    Robot = {
        Run=616091570, Walk=616095330, Jump=616090535, Fall=616087089,
        Swim=616092998, SwimIdle=616094091, Climb=616086039,
        Idle={616088211,616089559,885531463}
    },
    Levitation = {
        Run=616010382, Walk=616013216, Jump=616008936, Fall=616005863,
        Swim=616011509, SwimIdle=616012453, Climb=616003713,
        Idle={616006778,616008087,886862142}
    },
    Stylish = {
        Run=616140816, Walk=616146177, Jump=616139451, Fall=616134815,
        Swim=616143378, SwimIdle=616144772, Climb=616133594,
        Idle={616136790,616138447,886888594}
    },
    Bubbly = {
        Run=910025107, Walk=910034870, Jump=910016857, Fall=910001910,
        Swim=910028158, SwimIdle=910030921, Climb=909997997,
        Idle={910004836,910009958,1018536639}
    },
    Cartoon = {
        Run=742638842, Walk=742640026, Jump=742637942, Fall=742637151,
        Swim=742639220, SwimIdle=742639812, Climb=742636889,
        Idle={742637544,742638445,885477856}
    },
}
M.animPack = "Adidas Sports"
M.animPackEnabled = true
M.savedAnimate = nil




M.headlessEnabled = false
M.korbloxEnabled = false

local HEADLESS_MESH_ID = "rbxassetid://1095708"
local KORBLOX_MESH_ID = "rbxassetid://101851696"
local KORBLOX_TEXTURE_ID = "rbxassetid://101851254"
local DARK_GREY_COLOR = Color3.fromRGB(64, 64, 64)

local function removeFace(head)
    local face = head:FindFirstChild("face")
    if face then face:Destroy() end
end

function M.applyHeadlessToChar(char, enabled)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    if enabled then
        head.Transparency = 1
        head.CanCollide = false
        removeFace(head)

        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("SpecialMesh") and child.MeshId == HEADLESS_MESH_ID then
                child:Destroy()
            end
        end

        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = HEADLESS_MESH_ID
        mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
        mesh.Name = "HeadlessMesh"
        mesh.Parent = head

        head:GetPropertyChangedSignal("Transparency"):Connect(function()
            if head.Transparency ~= 1 then
                head.Transparency = 1
            end
        end)
        head.ChildAdded:Connect(function(child)
            if child.Name == "face" and child:IsA("Decal") then
                child:Destroy()
            end
        end)
    else
        head.Transparency = 0
        head.CanCollide = true
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("SpecialMesh") and child.Name == "HeadlessMesh" then
                child:Destroy()
            end
        end
        removeFace(head)
    end
end

function M.applyKorbloxToChar(char, enabled)
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if enabled then
        if humanoid.RigType == Enum.HumanoidRigType.R6 then
            local rightLeg = char:FindFirstChild("Right Leg")
            if rightLeg then
                for _, child in ipairs(rightLeg:GetChildren()) do
                    if child:IsA("SpecialMesh") or child:IsA("CharacterMesh") then
                        child:Destroy()
                    end
                end
                rightLeg.Color = DARK_GREY_COLOR
                rightLeg:GetPropertyChangedSignal("Color"):Connect(function()
                    if rightLeg.Color ~= DARK_GREY_COLOR then
                        rightLeg.Color = DARK_GREY_COLOR
                    end
                end)
                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = KORBLOX_MESH_ID
                mesh.TextureId = KORBLOX_TEXTURE_ID
                mesh.Scale = Vector3.new(1, 1, 1)
                mesh.Name = "KorbloxMesh"
                mesh.Parent = rightLeg
            end
        elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
            local rightUpperLeg = char:FindFirstChild("RightUpperLeg")
            if rightUpperLeg then
                rightUpperLeg.Transparency = 1
                local rightLowerLeg = char:FindFirstChild("RightLowerLeg")
                local rightFoot = char:FindFirstChild("RightFoot")
                if rightLowerLeg then rightLowerLeg.Transparency = 1 end
                if rightFoot then rightFoot.Transparency = 1 end

                local oldKorblox = char:FindFirstChild("KorbloxLeg")
                if oldKorblox then oldKorblox:Destroy() end

                local korbloxLeg = Instance.new("Part")
                korbloxLeg.Name = "KorbloxLeg"
                korbloxLeg.Size = Vector3.new(1, 2, 1)
                korbloxLeg.Anchored = false
                korbloxLeg.CanCollide = false
                korbloxLeg.Color = DARK_GREY_COLOR
                korbloxLeg.Parent = char

                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = KORBLOX_MESH_ID
                mesh.TextureId = KORBLOX_TEXTURE_ID
                mesh.Scale = Vector3.new(1, 1, 1)
                mesh.Name = "KorbloxMesh"
                mesh.Parent = korbloxLeg

                local weld = Instance.new("Weld")
                weld.Part0 = rightUpperLeg
                weld.Part1 = korbloxLeg
                weld.C0 = CFrame.new(0, -0.8, 0)
                weld.Name = "KorbloxWeld"
                weld.Parent = korbloxLeg
            end
        end
    else
        if humanoid.RigType == Enum.HumanoidRigType.R6 then
            local rightLeg = char:FindFirstChild("Right Leg")
            if rightLeg then
                for _, child in ipairs(rightLeg:GetChildren()) do
                    if child:IsA("SpecialMesh") and child.Name == "KorbloxMesh" then
                        child:Destroy()
                    end
                end
                rightLeg.Color = Color3.fromRGB(255, 255, 255)
            end
        elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
            local rightUpperLeg = char:FindFirstChild("RightUpperLeg")
            if rightUpperLeg then
                rightUpperLeg.Transparency = 0
                local rightLowerLeg = char:FindFirstChild("RightLowerLeg")
                local rightFoot = char:FindFirstChild("RightFoot")
                if rightLowerLeg then rightLowerLeg.Transparency = 0 end
                if rightFoot then rightFoot.Transparency = 0 end
                local korbloxLeg = char:FindFirstChild("KorbloxLeg")
                if korbloxLeg then korbloxLeg:Destroy() end
            end
        end
    end
end

function M.applyCharterToChar(char)
    if not char then return end
    M.applyHeadlessToChar(char, M.headlessEnabled)
    M.applyKorbloxToChar(char, M.korbloxEnabled)
end

player.CharacterAdded:Connect(function(char)
    task.wait(0.15)
    M.applyCharterToChar(char)
end)

RunService.Heartbeat:Connect(function()
    local char = player.Character
    if char then
        M.applyCharterToChar(char)
    end
end)






M.speed7UP = {
    normal = 60,
    carry = 30,
    lagger = 10.1,
    laggerCarry = 15,
}

function M.get7UPSpeedProfile()
    return {
        normal = tonumber(M.NS) or M.speed7UP.normal,
        carry = tonumber(M.CS) or M.speed7UP.carry,
        lagger = tonumber(M.LAGGER_SPEED) or M.speed7UP.lagger,
        laggerCarry = tonumber(M.LAGGER_CARRY_SPEED) or M.speed7UP.laggerCarry,
    }
end

function M.apply7UPSpeedProfile()
    local profile = M.get7UPSpeedProfile()
    M.NS = profile.normal
    M.CS = profile.carry
    M.LAGGER_SPEED = profile.lagger
    M.LAGGER_CARRY_SPEED = profile.laggerCarry
    return profile
end




M.NS = 60
M.CS = 30
M.LAGGER_SPEED = 10.1
M.LAGGER_CARRY_SPEED = 32
M.BRAINROT_CARRY_SPEED = 32
M.speedMethod = "Velocity"
M.speedMethodList = {
    "Velocity", "AssemblyLinearVelocity", "Velocity Lerp", "AssemblyLinearVelocity Lerp",
    "CFrame", "CFrame Lerp", "Hyper CFrame", "Anchored CFrame", "PivotTo", "Model PivotTo", "Tween CFrame",
    "WalkSpeed", "Humanoid Move", "Humanoid MoveTo",
    "BodyVelocity", "BodyPosition", "BodyForce", "BodyThrust",
    "LinearVelocity", "VectorForce", "AlignPosition",
    "ApplyImpulse", "RocketPropulsion",
}
M.hyperMult = 4
M._lastSpeedMethod = nil
M._speedHRP = nil
M._anchoredBySpeed = nil
M._bodyVel = nil
M._bodyPosition = nil
M._bodyForce = nil
M._bodyThrust = nil
M._linearVel = nil
M._vectorForce = nil
M._alignPos = nil
M._rocket = nil
M._rocketTarget = nil
M._attLinVel = nil
M._attVecForce = nil
M._attAlign = nil
M._speedTween = nil
M.carrySpeedActive = false
M.laggerModeEnabled = false
M.laggerCarryActive = false

M.antiRagdollEnabled = false
M.antiRagdollMode = "Splatter"
M.infJumpEnabled = false
M.infJumpMode = "manual"
M.medusaCounterEnabled = false
M.autoMedusaEnabled = false
M.autoMedusaConn = nil
M.autoMedusaRange = 15
M.autoMedusaLastUsed = 0
M.autoMedusaEquipPending = false
M.batCounterEnabled = false
M.unwalkEnabled = false
M.medusaDebounce = false
M.medusaLastUsed = 0
M.dropActive = false
M.autoLeftEnabled = false
M.autoRightEnabled = false
M.autoBatEnabled = false
M.autoSwingEnabled = true
M.autoMoveSwingEnabled = false
M.autoMoveSwingInterval = 0.3
M._alSwingDebounce = false
M._arSwingDebounce = false
M.antiLagEnabled = false
M.ANTI_LAG_BOOST = 2.5
M.antiFlingEnabled = false
M.antiFlingConn = nil
M.saturatedColorsEnabled = false
M.saturatedColorFx = nil
M.saturatedBloomFx = nil
M.saturatedAtmosphereFx = nil
M.saturatedSunRaysFx = nil
M.saturatedDofFx = nil
M.saturatedPulseConn = nil

M.removeAccessoriesEnabled = false
M.antiLagDescConn = nil
M.stretchRezEnabled = false
M.stretchRezConn = nil
M.unwalkSavedAnimate = nil
M._anyKeyListening = false
M.autoTPEnabled = false
M.autoTPHeight = 20
M.autoTPConn = nil
M.guiTransparencyEnabled = false
M.mobileButtonsEnabled = true
M.mobileButtonsLocked = false
M.mobileButtonsSize = 100
M.circleButtonsEnabled = false
M.selectiveNoclipEnabled = false
M._selectiveNoclipChanged = {}
M._selectiveNoclipConn = nil
M.aadEnabled = false
M.aadConn = nil
M.aadVersion = "V2"
M.mobBtnRefs = {}
M.mobGuiRef = nil
M.fovValue = 80
M.fovOptions = {80,120,180}
M.fovIndex = 1
M.laggerModePillRef = nil
M.carryModePillRef = nil
M.autoSwitchSpeedEnabled = false
M.autoTurnOffSpeedEnabled = false
M.autoSwitchLaggerSpeedEnabled = false
M.AUTO_SWITCH_THRESHOLD = 25
M._autoSwitchSpeedConn = nil
M.customFontSelected = "None"
M._fontOrig = {}
M._fontConn = nil
M._fontMy = nil
M.FONT_NAMES = {"None", "Coding Font", "Summer", "Beachy", "Scary", "Bangers"}
M.mobBtnTransparencyEnabled = false
M.perButtonDragEnabled = true
M.antiKickEnabled = false
M.brainrotDetected = false

M._brainrotReleaseReason = nil
M._brainrotHoldConn = nil
M._brainrotHealthConn = nil
M._brainrotCharacterConn = nil
M._brainrotLastHealth = nil
M._brainrotTrackedTool = nil
M._brainrotReleaseWindow = 0
M._brainrotBackpackConn = nil
M.safeModeEnabled = false
M.mirrorTPDownEnabled = false
M.mirrorTPPreviousY = {}
M.mirrorTPLastTeleport = 0
M.MIRROR_TP_DROP_THRESHOLD = 3
M.MIRROR_TP_DOWN_Y = -7.00
M.activeBatBillboard = nil
M.activeMedusaBillboard = nil
M.ragdollGuiEnabled = true
M.persistentRagdollGui = nil
M.uiLocked = false
M.holdInfJumpConn = nil
M.DROP_ASCEND_DURATION = 0.2
M.DROP_ASCEND_SPEED = 150
M.bypassAimbotEnabled = false
M.batV2Enabled = false
M.batV2Conn = nil
M._batV2PreviousAutoRotate = nil
M._batV2SwingCooldown = false
M.bypassAimbotConn = nil
M._bypassGodConn = nil
M._bypassGodHealthConn = nil
M._bypassGodDiedConn = nil
M._bypassGodCharConn = nil
M.bypassPrevAutoRotate = nil
M.bypassHitCD = false
M.bypassSwingCD = 0.35
M.bypassHitDist = 8
M._bypassTarget = nil

M.stealMode = "V1"
M.stealBarSize = 300
M.grabScale = 1.0
M.stealBarPosition = nil
M.stealBarColorName = "Red"
M.stealBarColor = Color3.fromRGB(255, 45, 55)
M.STEAL_BAR_COLORS = {
    Red = Color3.fromRGB(255, 45, 55), Blue = Color3.fromRGB(70, 145, 255),
    Green = Color3.fromRGB(65, 220, 125), Purple = Color3.fromRGB(185, 100, 255),
    Yellow = Color3.fromRGB(255, 210, 65), White = Color3.fromRGB(245, 245, 245),
}
M.stealBarBackgroundName = "Black"
M.stealBarBackgroundColorName = "Black"
M.STEAL_BAR_BACKGROUND_COLORS = {
    Black = Color3.fromRGB(0, 0, 0), Blue = Color3.fromRGB(55, 125, 235),
    Cyan = Color3.fromRGB(20, 190, 225), White = Color3.fromRGB(235, 235, 240),
    Green = Color3.fromRGB(35, 195, 115), Gray = Color3.fromRGB(170, 172, 180),
    Purple = Color3.fromRGB(165, 100, 235), Orange = Color3.fromRGB(245, 125, 35),
    Pink = Color3.fromRGB(235, 80, 160), Lavender = Color3.fromRGB(195, 145, 240),
    Red = Color3.fromRGB(75, 8, 18), Yellow = Color3.fromRGB(235, 195, 55),
}
M.STEAL_BAR_BACKGROUNDS = {
    Black = {Color = Color3.fromRGB(0, 0, 0), Transparency = 0.82},
    Dark = {Color = Color3.fromRGB(12, 12, 18), Transparency = 0.12},
    Red = {Color = Color3.fromRGB(45, 5, 10), Transparency = 0.12},
    Purple = {Color = Color3.fromRGB(24, 10, 38), Transparency = 0.12},
    Transparent = {Color = Color3.fromRGB(0, 0, 0), Transparency = 1},
}
M.Steal = {
    AutoStealEnabled = false,
    StealRadius = 63,
    StealDuration = 1.4,
    HoldMin = 1.3,
    EntryDelay = 0.3,
    Cooldown = 0.05,
    PrimeRange = 80,
    StopTime = 0.35,
}
M.V3 = {
    enabled = false,
    conn = nil,
    progress = 0,
    lastInRange = 0,
    currentUid = nil,
    holding = false,
    holdPrompt = nil,
    cooldownUntil = 0,
}
M.autoRadiusEnabled = false
function M.getAutoRadius()
    local radius = math.clamp((tonumber(M.NS) or 60) + 1, 1, 500)
    return math.floor(radius * 10 + 0.5) / 10
end
function M.getActiveStealRadius()
    if M.stealMode == "Semi" or M.stealMode == "V2" then
        return math.min(tonumber(M.Semi.radius) or 10, 10)
    end
    return M.autoRadiusEnabled and M.getAutoRadius() or M.Steal.StealRadius
end
M.Semi = {
    enabled = false,
    holdMin = 1.3,
    holdMax = 2.6,
    entryDelay = 0.3,
    cooldown = 0.05,
    primeRange = 80,
    radius = 10,
    conn = nil,
    scanThread = nil,
    plotSync = {caches = {}, connections = {}},
    animals = {},
    promptCache = {},
    internalCache = {},
    state = {active = false, startTime = 0, phase = "idle", label = "", lastResult = "", lastResultTime = 0},
    plots = nil,
    syncReady = false,
}
M.isStealing = false
M.stealStartTime = 0
M.stealConn = nil
M.progressConn = nil
M.animalCache = {}
M.promptCache = {}
M.stealCache = {}
M.espList = {}
M.pingPopupActive = false
M.pingPopupGui = nil
M.pingCycleTimer = nil
M.Conns = {autoSteal=nil, antiRag=nil, batCounter=nil, anchor={}}
M._persistentConns = {}
M.alConn = nil
M.arConn = nil
M.alPhase = 1
M.arPhase = 1
M.aimbotConn = nil
M.lastMoveDir = Vector3.new(0,0,0)
M.batCounterDebounce = false
M.speedLabel = nil


M.KB = {
    DropBrainrot={kb=nil,gp=nil},
    AutoLeft={kb=nil,gp=nil},
    AutoRight={kb=nil,gp=nil},
    AutoBat={kb=nil,gp=nil},
    TPFloor={kb=nil,gp=nil},
    GuiHide={kb=nil,gp=nil},
    SpeedToggle={kb=nil,gp=nil},
    LaggerToggle={kb=nil,gp=nil},
    BypassAimbot={kb=nil,gp=nil},
    BatV2={kb=nil,gp=nil},
    AutoGrab={kb=nil,gp=nil},
    AutoMedusa={kb=nil,gp=nil},
    ESPPlayer={kb=nil,gp=nil},
    AntiAnti={kb=Enum.KeyCode.Delete,gp=nil},
}
M.AP_L1 = Vector3.new(-476.47,-6.28,92.73)
M.AP_L2 = Vector3.new(-483.12,-4.95,94.81)
M.AP_R1 = Vector3.new(-476.16,-6.52,25.62)
M.AP_R2 = Vector3.new(-483.06,-5.03,25.48)
M.MEDUSA_COOLDOWN = 25
M.BAT_COUNTER_SLAP_LIST = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
M.fovConn = nil
M.defLightBrightness = nil
M.defLightClock = nil
M.defLightAmbient = nil
M.mainFrame = nil
M.normalBox = nil
M.carryBox = nil
M.laggerBox = nil
M.radInput = nil
M.autoTPHeightBox = nil
M.durationBox = nil
M.modeValLbl = nil
M.setInstaGrab = nil
M.setInfJumpVisual = nil
M.setAntiRagVisual = nil
M.setMedusaVisual = nil
M.setAutoMedusaVisual = nil
M.setUnwalkVisual = nil
M.setAntiLagVisual = nil
M.setAutoSwingVisual = nil
M.setTranspVisual = nil
M.setLockVisual = nil
M.setMobVisual = nil
M.setCircleBtnsVisual = nil
M.antiKickSetVisual = nil
M.autoLeftSetVisual = nil
M.autoRightSetVisual = nil
M.autoBatSetVisual = nil
M.setAutoTPVisual = nil
M.setStretchRezVisual = nil
M.setBypassVisual = nil
M.setBatV2Visual = nil
M._autoSwitchWasSteal = false

M.MOB_POS_FILE = "moveeduels_btnpos.json"
M.MOVE_KEYS = {
    [Enum.KeyCode.W]=true,
    [Enum.KeyCode.A]=true,
    [Enum.KeyCode.S]=true,
    [Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,
    [Enum.KeyCode.Left]=true,
    [Enum.KeyCode.Down]=true,
    [Enum.KeyCode.Right]=true
}

M.showPlayerSpeeds = false
M.playerSpeedGuis = {}
M.playerSpeedUpdateConn = nil
M.removeAccEnabled = false
M.removeAccConn = nil
M.removedAccessories = {}
M.uiScale = 0.50
if UIS.TouchEnabled and not UIS.KeyboardEnabled then
    M.uiScale = 0.50
end
M.uiScaleSliderRef = nil
M.uiScaleLabelRef = nil
M.uiScaleBoxRef = nil
M.lineESPEnabled = false
M.speedESPEnabled = false
M.perfectHitEnabled = false
M.tpBatSureHitEnabled = false
M.hardHitEnabled = false
M.hardHitRadius = 10
M.antiDieEnabled = false
M.hitboxBoxEnabled = false
M.menuOpen = false
M.openButtonPosition = nil
M.menuPosition = nil

M.statusGui = nil
M.statusFill = nil
M.statusPctLbl = nil
M.statusRadiusLbl = nil
M.statusDot = nil
M.statusMain = nil
M.statusFpsLbl = nil




function M.addShimmerToLabel(lbl,color1,color2)
    local gr=Instance.new("UIGradient",lbl)
    gr.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,color1 or Color3.fromRGB(100,100,100)),ColorSequenceKeypoint.new(0.5,color2 or Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,color1 or Color3.fromRGB(100,100,100))})
    gr.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.3,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(1,0.3,0)})
    return gr
end

function M.applyFOV()
    if M.fovConn then M.fovConn:Disconnect() end
    M.fovConn=RunService.RenderStepped:Connect(function() local cam=workspace.CurrentCamera;if cam then cam.FieldOfView=M.fovValue end end)
end




M.ragdollTimerThread = nil
M.ragdollTimerRemaining = 0
M.isRagdollActive = false

function M.setHeadIndicatorRagdollVisible(active)
    if not M.headIndicator then return end
    if M.headIndicator.speed then
        M.headIndicator.speed.Visible = not active
    end
    if M.headIndicator.ragdollTimer then
        M.headIndicator.ragdollTimer.Visible = active
    end
end

M.headIndicatorReadyToken = 0
function M.updateRagdollTimer(duration)
    if M.ragdollTimerThread then
        task.cancel(M.ragdollTimerThread)
        M.ragdollTimerThread = nil
    end
    M.headIndicatorReadyToken = (M.headIndicatorReadyToken or 0) + 1
    local readyToken = M.headIndicatorReadyToken
    if duration <= 0 then
        M.isRagdollActive = false
        if M.headIndicator and M.headIndicator.ragdollTimer then
            M.headIndicator.ragdollTimer.Text = "RAGDOLL: READY"
        end
        M.setHeadIndicatorRagdollVisible(true)
        task.delay(0.35, function()
            if M.headIndicatorReadyToken == readyToken and not M.isRagdollActive then
                M.setHeadIndicatorRagdollVisible(false)
            end
        end)
        return
    end
    M.isRagdollActive = true
    M.setHeadIndicatorRagdollVisible(true)
    local startTime = tick()
    M.ragdollTimerRemaining = duration
    M.ragdollTimerThread = task.spawn(function()
        while M.isRagdollActive and M.ragdollTimerRemaining > 0 do
            local elapsed = tick() - startTime
            local remaining = math.max(0, duration - elapsed)
            M.ragdollTimerRemaining = remaining
            if M.headIndicator and M.headIndicator.ragdollTimer then
                M.headIndicator.ragdollTimer.Text = string.format("RAGDOLL: %.1fs", remaining)
            end
            if remaining <= 0 then
                M.isRagdollActive = false
                if M.headIndicator and M.headIndicator.ragdollTimer then
                    M.headIndicator.ragdollTimer.Text = "RAGDOLL: READY"
                end
                M.setHeadIndicatorRagdollVisible(true)
                task.delay(0.35, function()
                    if M.headIndicatorReadyToken == readyToken and not M.isRagdollActive then
                        M.setHeadIndicatorRagdollVisible(false)
                    end
                end)
                break
            end
            task.wait(0.05)
        end
        M.ragdollTimerThread = nil
    end)
end

function M.onHumanoidStateChanged(old,new)
    local char=player.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid");if not hum then return end
    local isRag=(new==Enum.HumanoidStateType.Physics or new==Enum.HumanoidStateType.Ragdoll or new==Enum.HumanoidStateType.FallingDown)
    if isRag and not hum.PlatformStand then
        M.updateRagdollTimer(2.6)
    end
end

function M.onMedusaStateChanged()
    local char=player.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum and hum.PlatformStand then
        
        if M._brainrotIsHeld and M._brainrotIsHeld() and M._brainrotEnemyHasWeapon("medusa") then
            M._brainrotAllowRelease("medusa")
        end
        M.updateRagdollTimer(4.5)
    end
end

function M.setupRagdollTriggers()
    local char=player.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.StateChanged:Connect(M.onHumanoidStateChanged)
        hum:GetPropertyChangedSignal("PlatformStand"):Connect(M.onMedusaStateChanged)
    end
end




function M.waitForAnimate(char)
    for _ = 1, 40 do
        local a = char:FindFirstChild("Animate")
        if a and a:FindFirstChild("idle") and a:FindFirstChild("run") and a:FindFirstChild("walk") then
            return a
        end
        task.wait(0.1)
    end
    return nil
end

function M.setAnim(animObj, id)
    if animObj and id then
        animObj.AnimationId = "rbxassetid://" .. tostring(id)
    end
end

function M.stopAllTracks(hum)
    if not hum then return end
    for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
        pcall(function() t:Stop(0) end)
    end
end

function M.ensureAnim(folder, name)
    if not folder then return nil end
    local a = folder:FindFirstChild(name)
    if not a then
        a = Instance.new("Animation")
        a.Name = name
        a.Parent = folder
    end
    return a
end

function M.ensureIdleSlots(idleFolder, n)
    if not idleFolder then return end
    n = n or 2
    for i=1,n do
        M.ensureAnim(idleFolder, "Animation" .. i)
    end
end

function M.pick(pack, ...)
    for i = 1, select("#", ...) do
        local k = select(i, ...)
        local v = pack[k]
        if v ~= nil then return v end
    end
    return nil
end

function M.saveOriginalAnimate(char)
    if not char then return end
    if M.savedAnimate then return end
    local animate = char:FindFirstChild("Animate")
    if animate then
        M.savedAnimate = animate:Clone()
    end
end

function M.restoreOriginalAnimate(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        M.stopAllTracks(hum)
    end
    local currentAnimate = char:FindFirstChild("Animate")
    if currentAnimate then
        currentAnimate:Destroy()
    end
    if M.savedAnimate then
        local newAnimate = M.savedAnimate:Clone()
        newAnimate.Parent = char
        newAnimate.Disabled = true
        task.wait(0.06)
        newAnimate.Disabled = false
    end
end

function M.resetAnimations(char)
    if not char then return end
    M.restoreOriginalAnimate(char)
end

local applyingAnim = false
function M.applyAnimPack(packName)
    if not M.animPackEnabled then
        local char = player.Character
        if char then
            M.resetAnimations(char)
        end
        return false
    end
    if applyingAnim then return false end
    applyingAnim = true

    local pack = M.PACKS[packName]
    if not pack then
        applyingAnim = false
        return false
    end

    local char = player.Character or player.CharacterAdded:Wait()
    M.saveOriginalAnimate(char)

    local animate = M.waitForAnimate(char)
    if not animate then
        applyingAnim = false
        return false
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    M.stopAllTracks(hum)

    local runObj   = M.ensureAnim(animate:FindFirstChild("run"),   "RunAnim")
    local walkObj  = M.ensureAnim(animate:FindFirstChild("walk"),  "WalkAnim")
    local jumpObj  = M.ensureAnim(animate:FindFirstChild("jump"),  "JumpAnim")
    local fallObj  = M.ensureAnim(animate:FindFirstChild("fall"),  "FallAnim")
    local climbObj = M.ensureAnim(animate:FindFirstChild("climb"), "ClimbAnim")
    local swimObj  = M.ensureAnim(animate:FindFirstChild("swim"),     "Swim")
    local swimIdleObj = M.ensureAnim(animate:FindFirstChild("swimidle"), "SwimIdle")
    local idleFolder = animate:FindFirstChild("idle")

    M.setAnim(walkObj,  M.pick(pack, "WalkAnim", "Walk"))
    M.setAnim(runObj,   M.pick(pack, "RunAnim", "Run"))
    M.setAnim(jumpObj,  M.pick(pack, "JumpAnim", "Jump"))
    M.setAnim(fallObj,  M.pick(pack, "FallAnim", "Fall"))
    M.setAnim(climbObj, M.pick(pack, "ClimbAnim", "Climb"))
    M.setAnim(swimObj,      M.pick(pack, "Swim"))
    M.setAnim(swimIdleObj,  M.pick(pack, "SwimIdle") or M.pick(pack, "Swim"))

    if idleFolder then
        local a1 = M.pick(pack, "Animation1")
        local a2 = M.pick(pack, "Animation2")
        if a1 or a2 then
            M.ensureIdleSlots(idleFolder, 2)
            local id1 = a1 or a2
            local id2 = a2 or a1 or id1
            M.setAnim(idleFolder:FindFirstChild("Animation1"), id1)
            M.setAnim(idleFolder:FindFirstChild("Animation2"), id2)
        elseif pack.Idle and #pack.Idle > 0 then
            M.ensureIdleSlots(idleFolder, math.max(2, #pack.Idle))
            M.setAnim(idleFolder:FindFirstChild("Animation1"), pack.Idle[1])
            M.setAnim(idleFolder:FindFirstChild("Animation2"), pack.Idle[2] or pack.Idle[1])
            for i = 3, #pack.Idle do
                local a = idleFolder:FindFirstChild("Animation" .. i)
                if a then M.setAnim(a, pack.Idle[i]) end
            end
        end
    end

    animate.Disabled = true
    task.wait(0.06)
    animate.Disabled = false

    if hum then
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.Landed)
            task.wait(0.03)
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end

    M.animPack = packName
    applyingAnim = false
    return true
end




function M.createPlayerSpeedGui(plr)
    if plr == player then return end
    if M.playerSpeedGuis[plr] then return end
    local char = plr.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local old = head:FindFirstChild("MoveePlayerSpeedBB")
    if old then old:Destroy() end
    local bb = Instance.new("BillboardGui")
    bb.Name = "MoveePlayerSpeedBB"
    bb.Size = UDim2.new(0, 80, 0, 24)
    bb.StudsOffset = Vector3.new(0, 2.2, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = head
    bb.Parent = head
    local label = Instance.new("TextLabel", bb)
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = "0"
    label.TextColor3 = CHERRY_ACCENT or Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.TextStrokeTransparency = 0
    M.addShimmerToLabel(label, CHERRY_ACCENT or Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255))
    local conn
    conn = char.AncestryChanged:Connect(function(_, parent)
        if not parent then
            M.removePlayerSpeedGui(plr)
            if conn then conn:Disconnect() end
        end
    end)
    M.playerSpeedGuis[plr] = {gui = bb, label = label, conn = conn}
end

function M.removePlayerSpeedGui(plr)
    local data = M.playerSpeedGuis[plr]
    if data then
        if data.conn then data.conn:Disconnect() end
        if data.gui then data.gui:Destroy() end
        M.playerSpeedGuis[plr] = nil
    end
end

function M.updatePlayerSpeed(plr)
    if not M.showPlayerSpeeds then return end
    local data = M.playerSpeedGuis[plr]
    if not data then return end
    local char = plr.Character
    if not char then M.removePlayerSpeedGui(plr); return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local speed = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude
    data.label.Text = string.format("%.1f", speed)
end

function M.updateAllPlayerSpeeds()
    for plr, _ in pairs(M.playerSpeedGuis) do M.updatePlayerSpeed(plr) end
end

function M.startPlayerSpeedUpdates()
    if M.playerSpeedUpdateConn then return end
    M.playerSpeedUpdateConn = RunService.Heartbeat:Connect(function() M.updateAllPlayerSpeeds() end)
end

function M.stopPlayerSpeedUpdates()
    if M.playerSpeedUpdateConn then M.playerSpeedUpdateConn:Disconnect(); M.playerSpeedUpdateConn = nil end
end

function M.togglePlayerSpeeds(on)
    M.showPlayerSpeeds = on
    if on then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then M.createPlayerSpeedGui(plr) end
        end
        M.startPlayerSpeedUpdates()
    else
        for plr, _ in pairs(M.playerSpeedGuis) do M.removePlayerSpeedGui(plr) end
        M.stopPlayerSpeedUpdates()
    end
end




M.playerESPList = {}
M.espPlayerEnabled = false
M.playerESPViewportGui = nil

local function removeLegacyPlayerESP()
    
    local containers = {}
    local playerGui = player:FindFirstChildOfClass("PlayerGui")
    if playerGui then table.insert(containers, playerGui) end
    local coreGui = game:GetService("CoreGui")
    if coreGui then table.insert(containers, coreGui) end
    for _, container in ipairs(containers) do
        for _, item in ipairs(container:GetDescendants()) do
            if item:IsA("BillboardGui") and item.Name == "S1NXY_PlayerESP" then
                pcall(function() item:Destroy() end)
            end
        end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        local char = plr.Character
        if char then
            for _, item in ipairs(char:GetDescendants()) do
                if item:IsA("BillboardGui") and item.Name == "S1NXY_PlayerESP" then
                    pcall(function() item:Destroy() end)
                end
            end
        end
    end
end

local function ensurePlayerESPViewportGui()
    if M.playerESPViewportGui and M.playerESPViewportGui.Parent then
        return M.playerESPViewportGui
    end
    local playerGui = player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui")
    local old = playerGui:FindFirstChild("S1NXY_PlayerESP_Screen")
    if old then pcall(function() old:Destroy() end) end
    removeLegacyPlayerESP()
    local gui = Instance.new("ScreenGui")
    gui.Name = "S1NXY_PlayerESP_Screen"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 110
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = playerGui
    M.playerESPViewportGui = gui
    return gui
end

local function destroyPlayerPhotoESP(plr)
    local data = M.playerESPList[plr]
    if not data then return end
    pcall(function() if data.gui then data.gui:Destroy() end end)
    if data.connection then pcall(function() data.connection:Disconnect() end) end
    M.playerESPList[plr] = nil
end

local function loadPlayerProfilePhoto(plr, imageLabel)
    task.spawn(function()
        local ok, image = pcall(function()
            local content = Players:GetUserThumbnailAsync(
                plr.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size150x150
            )
            return content
        end)
        if ok and image and imageLabel and imageLabel.Parent then
            imageLabel.Image = image
        end
    end)
end

local function createPlayerPhotoESP(plr, char)
    local gui = Instance.new("ImageLabel")
    gui.Name = "S1NXY_PlayerESP"
    gui.Size = UDim2.fromOffset(52, 52)
    gui.AnchorPoint = Vector2.new(0.5, 0.5)
    gui.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    gui.BackgroundTransparency = 0.15
    gui.BorderSizePixel = 0
    gui.ScaleType = Enum.ScaleType.Crop
    gui.Visible = false
    gui.ZIndex = 5
    gui.Parent = ensurePlayerESPViewportGui()

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = gui

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 0, 0)
    stroke.Thickness = 2
    stroke.Parent = gui

    loadPlayerProfilePhoto(plr, gui)
    local connection = plr.CharacterAdded:Connect(function()
        destroyPlayerPhotoESP(plr)
    end)
    return {gui = gui, character = char, connection = connection}
end

function M.updatePlayerESP()
    if not M.espPlayerEnabled then return end
    removeLegacyPlayerESP()
    local camera = workspace.CurrentCamera
    if not camera then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local head = char and char:FindFirstChild("Head")
            local data = M.playerESPList[plr]
            local active = M.espPlayerEnabled and char and hum and head and hum.Health > 0

            if active then
                if data and (data.character ~= char or not data.gui or not data.gui.Parent) then
                    destroyPlayerPhotoESP(plr)
                    data = nil
                end
                if not data then
                    data = createPlayerPhotoESP(plr, char)
                    M.playerESPList[plr] = data
                end
                local screenPoint, visible = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 4.2, 0))
                data.gui.Visible = visible and screenPoint.Z > 0
                if data.gui.Visible then
                    data.gui.Position = UDim2.fromOffset(screenPoint.X, screenPoint.Y)
                end
            elseif data then
                data.gui.Visible = false
            end
        end
    end
end

Players.PlayerRemoving:Connect(function(plr)
    destroyPlayerPhotoESP(plr)
end)

RunService.RenderStepped:Connect(function()
    
    if M.espPlayerEnabled == true then
        M.updatePlayerESP()
    end
end)

function M.addESP(plr)
    if plr == player then return end
    if M.espList[plr] then return end
    local char = plr.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local nameBB = Instance.new("BillboardGui")
    nameBB.Size = UDim2.new(0, 120, 0, 30)
    nameBB.StudsOffset = Vector3.new(0, 2.8, 0)
    nameBB.AlwaysOnTop = true
    nameBB.Adornee = head
    nameBB.Parent = head
    local nameLbl = Instance.new("TextLabel", nameBB)
    nameLbl.Size = UDim2.new(1,0,1,0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = plr.Name
    nameLbl.TextColor3 = Color3.fromRGB(255,255,255)
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextScaled = true
    nameLbl.TextStrokeTransparency = 0
    nameLbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)

    local highlight = Instance.new("Highlight")
    highlight.Adornee = char
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 0.3
    highlight.OutlineColor = Color3.fromRGB(255,255,255)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char

    M.espList[plr] = {nameBB = nameBB, highlight = highlight}
end

function M.removeESP(plr)
    local data = M.espList[plr]
    if data then
        if data.nameBB then data.nameBB:Destroy() end
        if data.highlight then data.highlight:Destroy() end
        M.espList[plr] = nil
    end
end

function M.clearESP()
    for plr, _ in pairs(M.espList) do M.removeESP(plr) end
end

function M.setupHeadIndicator(char)
    local head=char:WaitForChild("Head",5);if not head then return end
    if head:FindFirstChild("MoveeHeadIndicator") then head.MoveeHeadIndicator:Destroy() end
    local bb=Instance.new("BillboardGui",head)
    bb.Name="MoveeHeadIndicator"
    bb.Size=UDim2.new(0,250,0,90)
    bb.StudsOffset=Vector3.new(0,3.5,0)
    bb.Adornee=head
    bb.AlwaysOnTop=true
    bb.Enabled=true
    bb.MaxDistance=1000
    bb.LightInfluence=0
    bb.Parent=head

    local accent = CHERRY_ACCENT or Color3.fromRGB(255,255,255)

    local ragdollLbl=Instance.new("TextLabel",bb)
    ragdollLbl.Name="RagdollTimer"
    ragdollLbl.Size=UDim2.new(1,0,0.33,0)
    ragdollLbl.Position=UDim2.new(0,0,0,0)
    ragdollLbl.BackgroundTransparency=1
    ragdollLbl.Text="RAGDOLL: READY"
    ragdollLbl.Visible=false
    ragdollLbl.TextColor3=accent
    ragdollLbl.Font=Enum.Font.GothamBold
    ragdollLbl.TextScaled=true
    ragdollLbl.TextStrokeTransparency=0

    local discordLbl=Instance.new("TextLabel",bb)
    discordLbl.Name="Discord"
    discordLbl.Size=UDim2.new(1,0,0.30,0)
    discordLbl.Position=UDim2.new(0,0,0.30,0)
    discordLbl.BackgroundTransparency=1
    discordLbl.Text="discord.gg/DYWaPdZvZ"
    discordLbl.TextColor3=accent
    discordLbl.Font=Enum.Font.GothamBold
    discordLbl.TextScaled=true
    discordLbl.TextStrokeTransparency=0

    local div = Instance.new("Frame", bb)
    div.Name = "Divider"
    div.Size = UDim2.new(0.72, 0, 0, 2)
    div.Position = UDim2.new(0.14, 0, 0.635, 0)
    div.BackgroundColor3 = accent
    div.BackgroundTransparency = 0.15
    div.BorderSizePixel = 0
    div.ZIndex = 2
    local divCorner = Instance.new("UICorner", div)
    divCorner.CornerRadius = UDim.new(1, 0)

    local speedLbl=Instance.new("TextLabel",bb)
    speedLbl.Name="Speed"
    speedLbl.Size=UDim2.new(1,0,0.30,0)
    speedLbl.Position=UDim2.new(0,0,0.66,0)
    speedLbl.BackgroundTransparency=1
    speedLbl.Text="SPEED: 0.0"
    speedLbl.Visible=true
    speedLbl.TextColor3=accent
    speedLbl.Font=Enum.Font.GothamBold
    speedLbl.TextScaled=true
    speedLbl.TextStrokeTransparency=0

    M.headIndicator = {bb=bb, discord=discordLbl, speed=speedLbl, ragdollTimer=ragdollLbl, divider=div}
    M.setHeadIndicatorRagdollVisible(M.isRagdollActive == true)
    M.updateHeadTheme()
end

function M.updateHeadTheme()
    if not M.headIndicator then return end
    local accent = UI_ACCENT or CHERRY_ACCENT or Color3.fromRGB(255,255,255)
    if M.headIndicator.discord then
        M.headIndicator.discord.TextColor3 = accent
    end
    if M.headIndicator.speed then
        M.headIndicator.speed.TextColor3 = accent
    end
    if M.headIndicator.ragdollTimer then
        M.headIndicator.ragdollTimer.TextColor3 = accent
    end
    if M.headIndicator.divider then
        M.headIndicator.divider.BackgroundColor3 = accent
    end
end

local speedUpdateConn = nil
function M.startHeadSpeedUpdates()
    if speedUpdateConn then return end
    speedUpdateConn = RunService.Heartbeat:Connect(function()
        local char = player.Character
        if char and M.headIndicator then
            -- La intro es el único momento en que el BillboardGui debe estar oculto.
            -- Esto también lo recupera si Insta Reset o el respawn lo dejaron deshabilitado.
            if M.headIndicator.bb then
                M.headIndicator.bb.Enabled = (M._introActive ~= true)
            end
            if not M.isRagdollActive then
                M.setHeadIndicatorRagdollVisible(false)
            end
            if M.headIndicator.speed then
            local displaySpeed
            if M.autoLeftEnabled or M.autoRightEnabled then
                displaySpeed = M.NS
            else
                displaySpeed = M.getActiveMoveSpeed()
            end
                M.headIndicator.speed.Text = string.format("SPEED: %.1f", displaySpeed)
            end
        end
    end)
end

function M.stopHeadSpeedUpdates()
    if speedUpdateConn then
        speedUpdateConn:Disconnect()
        speedUpdateConn = nil
    end
end




M.PING_WARNING_THRESHOLD = 145

function M.stopPingMonitor()
    M.pingMonitorToken = (M.pingMonitorToken or 0) + 1
    M.pingMonitorRunning = false
end

function M.getCurrentPingMs()
    local ok, ping = pcall(function()
        if player and player.GetNetworkPing then
            return player:GetNetworkPing() * 1000
        end
    end)
    if ok and type(ping) == "number" and ping >= 0 then
        return math.floor(ping + 0.5)
    end

    local fallbackOk, value = pcall(function()
        local item = Stats.Network.ServerStatsItem["Data Ping"]
        return item and item:GetValueString() or ""
    end)
    if fallbackOk and type(value) == "string" then
        local number = tonumber(string.match(value, "%d+%.?%d*"))
        if number then return math.floor(number + 0.5) end
    end
    return nil
end

function M.hidePingAlert()
    if M.pingAlert then
        M.pingAlert.Visible = false
    end
end

function M.startPingMonitor()
    M.stopPingMonitor()
    M.pingMonitorRunning = true
    local token = M.pingMonitorToken
    task.spawn(function()
        while M.pingMonitorRunning and M.pingMonitorToken == token do
            local ping = M.getCurrentPingMs()
            local alert = M.pingAlert
            if alert and alert.Parent then
                if M._introActive == true and ping and ping > M.PING_WARNING_THRESHOLD then
                    alert.Text = "TU PING +145 🥵"
                    alert.Visible = true
                    alert.TextTransparency = 0
                    alert.BackgroundTransparency = 0.12
                else
                    alert.Visible = false
                end
            end
            task.wait(1)
        end
    end)
end




function M.buildStatusUI()
    M.stopPingMonitor()
    if M.statusRenderConn then pcall(function() M.statusRenderConn:Disconnect() end); M.statusRenderConn = nil end
    if M.statusGui then pcall(function() M.statusGui:Destroy() end); M.statusGui = nil end

    local gui = Instance.new("ScreenGui")
    gui.Name = "StealProgressWindow"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 5
    do
        local ok = false
        if gethui then
            ok = pcall(function() gui.Parent = gethui() end)
        elseif syn and syn.protect_gui then
            ok = pcall(function()
                syn.protect_gui(gui)
                gui.Parent = game:GetService("CoreGui")
            end)
        end
        if not ok then gui.Parent = player:WaitForChild("PlayerGui") end
    end
    for _, v in ipairs(gui.Parent:GetChildren()) do
        if v ~= gui and v:IsA("ScreenGui") and (v.Name == gui.Name or v.Name == "S1NXYStatusUI" or v.Name == "K7_StatusUI") then
            pcall(function() v:Destroy() end)
        end
    end

    local accent = M.stealBarColor or UI_ACCENT or CHERRY_ACCENT or Color3.fromRGB(255,255,255)
    local barFrame = Instance.new("Frame")
    barFrame.Name = "StealBar"
    barFrame.Size = UDim2.new(0, 340, 0, 40)
    local saved = M.stealBarPosition
    barFrame.Position = saved and UDim2.new(saved.xScale, saved.xOffset, saved.yScale, saved.yOffset) or UDim2.new(0.5, -170, 1, -56)
    barFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    barFrame.BackgroundTransparency = 0.15
    barFrame.BorderSizePixel = 0
    barFrame.Active = true
    barFrame.ClipsDescendants = true
    barFrame.Visible = M.Steal.AutoStealEnabled == true
    barFrame.ZIndex = 10
    barFrame.Parent = gui
    Instance.new("UICorner", barFrame).CornerRadius = UDim.new(1, 0)
    local frameStroke = Instance.new("UIStroke", barFrame)
    frameStroke.Color = accent
    frameStroke.Thickness = 2
    frameStroke.Transparency = 0.15

    local dragStart, startPos, dragging, dragInput
    local function savePosition()
        local p = barFrame.Position
        M.stealBarPosition = {xScale=p.X.Scale, xOffset=p.X.Offset, yScale=p.Y.Scale, yOffset=p.Y.Offset}
        pcall(function() if M.saveConfig then M.saveConfig() end end)
    end
    barFrame.InputBegan:Connect(function(input)
        if M.uiLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = barFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false; savePosition() end end)
        end
    end)
    barFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UIS.InputChanged:Connect(function(input)
        if M.uiLocked then dragging = false end
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            barFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local track = Instance.new("Frame", barFrame)
    track.Name = "Track"
    track.Size = UDim2.new(0, 220, 0, 28)
    track.Position = UDim2.new(0, 6, 0.5, -14)
    track.BackgroundColor3 = Color3.fromRGB(20,20,25)
    track.BackgroundTransparency = 0.2
    track.BorderSizePixel = 0
    track.ClipsDescendants = true
    track.ZIndex = 11
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local trackStroke = Instance.new("UIStroke", track)
    trackStroke.Color = accent
    trackStroke.Thickness = 1.5
    trackStroke.Transparency = 0.3

    local fill = Instance.new("Frame", track)
    fill.Name = "Fill"
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = accent
    fill.BackgroundTransparency = 0.15
    fill.BorderSizePixel = 0
    fill.ZIndex = 12
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    M.statusFill = fill

    local glow = Instance.new("Frame", fill)
    glow.Size = UDim2.new(1, 0, 1, 0)
    glow.BackgroundColor3 = Color3.fromRGB(255,255,255)
    glow.BackgroundTransparency = 0.85
    glow.BorderSizePixel = 0
    glow.ZIndex = 13
    Instance.new("UICorner", glow).CornerRadius = UDim.new(1, 0)

    local stealLabel = Instance.new("TextLabel", track)
    stealLabel.Size = UDim2.new(0, 60, 1, 0)
    stealLabel.Position = UDim2.new(0, 10, 0, 0)
    stealLabel.BackgroundTransparency = 1
    stealLabel.Text = "STEAL"
    stealLabel.TextColor3 = Color3.fromRGB(255,255,255)
    stealLabel.Font = Enum.Font.GothamBlack
    stealLabel.TextSize = 12
    stealLabel.TextXAlignment = Enum.TextXAlignment.Left
    stealLabel.ZIndex = 14

    local pct = Instance.new("TextLabel", track)
    pct.Name = "ProgressPercent"
    pct.Size = UDim2.new(1, -80, 1, 0)
    pct.Position = UDim2.new(0, 70, 0, 0)
    pct.BackgroundTransparency = 1
    pct.Text = "0%"
    pct.TextColor3 = Color3.fromRGB(255,255,255)
    pct.Font = Enum.Font.GothamBold
    pct.TextSize = 11
    pct.TextXAlignment = Enum.TextXAlignment.Right
    pct.ZIndex = 14
    M.statusPctLbl = pct
    M.statusBarPctLbl = nil

    local divider = Instance.new("Frame", barFrame)
    divider.Size = UDim2.new(0, 1, 0, 20)
    divider.Position = UDim2.new(0, 232, 0.5, -10)
    divider.BackgroundColor3 = accent
    divider.BackgroundTransparency = 0.4
    divider.BorderSizePixel = 0
    divider.ZIndex = 12

    local range = Instance.new("TextLabel", barFrame)
    range.Name = "RangeLabel"
    range.Size = UDim2.new(0, 100, 1, 0)
    range.Position = UDim2.new(0, 238, 0, 0)
    range.BackgroundTransparency = 1
    range.Text = string.format("RANGE %.2g", M.Steal.StealRadius)
    range.TextColor3 = Color3.fromRGB(200,200,200)
    range.Font = Enum.Font.GothamBold
    range.TextSize = 9
    range.TextXAlignment = Enum.TextXAlignment.Center
    range.ZIndex = 14
    M.statusRadiusLbl = range
    M.statusDot = nil
    M.statusFpsLbl = range
    M.statusRadiusMarker = nil
    M.statusRadiusMarkerLbl = nil
    M.updateRadiusMarker = function()
        if M.statusRadiusLbl then M.statusRadiusLbl.Text = string.format("RANGE %.2g", M.Steal.StealRadius) end
    end
    M.statusGui = gui
    M.statusMain = barFrame
    M.statusRenderConn = RunService.RenderStepped:Connect(function()
        if not barFrame.Parent then return end
        barFrame.Visible = M.Steal.AutoStealEnabled == true
        if not M.Steal.AutoStealEnabled then fill.Size = UDim2.new(0,0,1,0); pct.Text = "0%" end
        range.Text = string.format("RANGE %.2g", M.Steal.StealRadius)
    end)
    pcall(function() M.applyStealBarTheme(accent) end)
    M.startPingMonitor()
end

function M.buildStatusUI_chapo_unused()
    M.stopPingMonitor()
    if M.statusRenderConn then pcall(function() M.statusRenderConn:Disconnect() end); M.statusRenderConn = nil end
    if M.statusGui then pcall(function() M.statusGui:Destroy() end); M.statusGui = nil end

    local gui = Instance.new("ScreenGui")
    gui.Name = "StealProgressWindow"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 5
    local parentGui = nil
    if gethui then pcall(function() parentGui = gethui() end) end
    if not parentGui then parentGui = player:WaitForChild("PlayerGui") end
    gui.Parent = parentGui

    local pingAlert = Instance.new("TextLabel")
    pingAlert.Name = "PingWarning"
    pingAlert.AnchorPoint = Vector2.new(0.5, 0)
    pingAlert.Position = UDim2.new(0.5, 0, 0.08, 0)
    pingAlert.Size = UDim2.new(0, 250, 0, 34)
    pingAlert.BackgroundColor3 = Color3.fromRGB(70, 5, 12)
    pingAlert.BackgroundTransparency = 0.12
    pingAlert.BorderSizePixel = 0
    pingAlert.Visible = false
    pingAlert.ZIndex = 20
    pingAlert.Font = Enum.Font.GothamBold
    pingAlert.Text = "TU PING +145 🥵"
    pingAlert.TextColor3 = Color3.fromRGB(255, 92, 105)
    pingAlert.TextSize = 14
    pingAlert.TextStrokeColor3 = Color3.fromRGB(30, 0, 4)
    pingAlert.TextStrokeTransparency = 0.35
    pingAlert.Parent = gui
    Instance.new("UICorner", pingAlert).CornerRadius = UDim.new(0, 10)
    local pingStroke = Instance.new("UIStroke")
    pingStroke.Color = Color3.fromRGB(255, 45, 65)
    pingStroke.Thickness = 1.5
    pingStroke.Transparency = 0.15
    pingStroke.Parent = pingAlert
    M.pingAlert = pingAlert

    local barW = math.clamp(tonumber(M.stealBarSize) or 280, 100, 600)
    local frame = Instance.new("Frame")
    frame.Name = "AutoStealBar"
    frame.Size = UDim2.new(0, barW, 0, 38)
    local saved = M.stealBarPosition
    frame.Position = saved and UDim2.new(saved.xScale, saved.xOffset, saved.yScale, saved.yOffset) or UDim2.new(0.5, -math.floor(barW / 2), 1, -58)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.18
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.ClipsDescendants = true
    frame.Visible = M.Steal.AutoStealEnabled == true
    frame.Parent = gui
    local grabScaleRef = Instance.new("UIScale")
    grabScaleRef.Name = "GrabScale"
    grabScaleRef.Scale = math.clamp(tonumber(M.grabScale) or 1, 0.5, 2)
    grabScaleRef.Parent = frame
    M.grabScaleRef = grabScaleRef
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

    local bg = Instance.new("ImageLabel", frame)
    bg.Name = "AutoStealBackground"
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundTransparency = 1
    bg.BorderSizePixel = 0
    bg.Visible = true
    local grabBgUrl = "https://files.manuscdn.com/user_upload_by_module/session_file/310519663891813390/atcmxLYGUaZsQzLM.JPG"
    local grabBgFile = "AutoGrabBackground.JPG"
    local grabBgAsset = "rbxassetid://103842508538630"
    pcall(function()
        local assetLoader = getcustomasset or getsynasset
        local httpGet = function(url)
            if game.HttpGet then return game:HttpGet(url) end
            local req = request or http_request or (syn and syn.request)
            if req then
                local response = req({Url = url, Method = "GET"})
                return response.Body or response.body
            end
        end
        if assetLoader and writefile and isfile and httpGet then
            if not isfile(grabBgFile) then
                local bytes = httpGet(grabBgUrl)
                if bytes and #bytes > 0 then writefile(grabBgFile, bytes) end
            end
            if isfile(grabBgFile) then
                grabBgAsset = assetLoader(grabBgFile)
            end
        end
    end)
    bg.Image = grabBgAsset
    bg.ImageTransparency = 0
    bg.ScaleType = Enum.ScaleType.Crop
    bg.ZIndex = 2
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(125, 125, 130)
    stroke.Thickness = 1.2
    stroke.Transparency = 0.15

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(0, 72, 0, 20)
    title.Position = UDim2.new(0, 10, 0, 2)
    title.BackgroundTransparency = 1
    title.Text = "AUTO STEAL"
    title.TextColor3 = Color3.fromRGB(225, 225, 225)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 10
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 3

    local pct = Instance.new("TextLabel", frame)
    pct.Name = "ProgressText"
    pct.Size = UDim2.new(0, 110, 0, 20)
    pct.Position = UDim2.new(0.5, -55, 0, 2)
    pct.BackgroundTransparency = 1
    pct.Text = M.Steal.AutoStealEnabled and "READY" or "IDLE"
    pct.TextColor3 = Color3.fromRGB(190, 190, 195)
    pct.Font = Enum.Font.GothamBlack
    pct.TextSize = 10
    pct.TextXAlignment = Enum.TextXAlignment.Center
    pct.ZIndex = 3
    M.statusPctLbl = pct

    local range = Instance.new("TextLabel", frame)
    range.Name = "RangeLabel"
    range.Size = UDim2.new(0, 76, 0, 20)
    range.Position = UDim2.new(1, -84, 0, 2)
    range.BackgroundTransparency = 1
    range.Text = string.format("RANGE %.2g", M.Steal.StealRadius)
    range.TextColor3 = Color3.fromRGB(165, 165, 170)
    range.Font = Enum.Font.GothamBold
    range.TextSize = 9
    range.TextXAlignment = Enum.TextXAlignment.Right
    range.ZIndex = 3
    M.statusRadiusLbl = range

    local track = Instance.new("Frame", frame)
    track.Name = "Track"
    track.Size = UDim2.new(1, -20, 0, 8)
    track.Position = UDim2.new(0, 10, 1, -12)
    track.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
    track.BorderSizePixel = 0
    track.ZIndex = 3
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", track)
    fill.Name = "Fill"
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(155, 155, 160)
    fill.BorderSizePixel = 0
    fill.ZIndex = 4
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    M.statusFill = fill
    M.statusBarPctLbl = nil

    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    local function savePosition()
        local p = frame.Position
        M.stealBarPosition = {xScale = p.X.Scale, xOffset = p.X.Offset, yScale = p.Y.Scale, yOffset = p.Y.Offset}
        pcall(function() if M.saveConfig then M.saveConfig() end end)
    end
    frame.InputBegan:Connect(function(input)
        if M.uiLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false; savePosition() end end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UIS.InputChanged:Connect(function(input)
        if M.uiLocked then dragging = false end
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    M.statusGui = gui
    M.statusMain = frame
    M.statusDot = nil
    M.statusFpsLbl = nil
    M.statusRadiusMarker = nil
    M.statusRadiusMarkerLbl = nil
    M.updateRadiusMarker = function()
        if M.statusRadiusLbl then M.statusRadiusLbl.Text = string.format("RANGE %.2g", M.Steal.StealRadius) end
    end
    M.statusRenderConn = RunService.RenderStepped:Connect(function()
        if not frame.Parent then return end
        frame.Visible = M.Steal.AutoStealEnabled == true
        if not M.Steal.AutoStealEnabled then
            fill.Size = UDim2.new(0, 0, 1, 0)
            pct.Text = "IDLE"
            return
        end
        if M.isStealing then
            local progress = math.clamp((tick() - (M.stealStartTime or tick())) / math.max(tonumber(M.Steal.StealDuration) or 2.0, 0.05), 0, 1)
            fill.Size = UDim2.new(progress, 0, 1, 0)
            pct.Text = M.autoStealPhase == "waitingRange" and "WAITING RANGE" or "STEALING"
        elseif M.autoStealLastResult and tick() - M.autoStealLastResult < 1.2 then
            fill.Size = UDim2.new(1, 0, 1, 0)
            pct.Text = M.autoStealPhase == "success" and "SUCCESS" or "FAILED"
        else
            fill.Size = UDim2.new(0, 0, 1, 0)
            pct.Text = "READY"
        end
        range.Text = string.format("RANGE %.2g", M.Steal.StealRadius)
    end)
    pcall(function() M.applyStealBarTheme(Color3.fromRGB(155, 155, 160)) end)
    M.startPingMonitor()
end

function M.updateStealProgress(progress, label)
    progress = math.clamp(progress or 0, 0, 1)
    local pct = math.floor(progress * 100 + 0.5)
    local col = M.stealBarColor or UI_ACCENT or CHERRY_ACCENT or Color3.fromRGB(255, 255, 255)
    if M.statusFill then
        M.statusFill.Size = UDim2.fromScale(progress, 1)
        M.statusFill.BackgroundColor3 = col
    end
    if M.statusPctLbl then
        if type(label) == "string" and label ~= "" then
            M.statusPctLbl.Text = label
        elseif progress > 0 then
            M.statusPctLbl.Text = pct .. "%"
        else
            local ready = M.Steal and M.Steal.AutoStealEnabled
            M.statusPctLbl.Text = ready and "READY" or "IDLE"
        end
    end
    if M.statusBarPctLbl then
        M.statusBarPctLbl.Text = string.format("%d%%", pct)
    end
    if M.statusDot then
        M.statusDot.BackgroundColor3 = col
    end
end

function M.updateStatusRadius()
    if M.statusRadiusLbl then
        M.statusRadiusLbl.Text = "Radius: " .. tostring(M.getActiveStealRadius())
    end
    if M.updateRadiusMarker then
        M.updateRadiusMarker()
    end
end




if not fireproximityprompt then
    fireproximityprompt = function(prompt)
        pcall(function()
            prompt:InputHoldBegin()
            task.wait(0.05)
            prompt:InputHoldEnd()
        end)
    end
end

local function visIsMyPlot(plotName)
    local plots = workspace:FindFirstChild("Plots")
    local plot = plots and plots:FindFirstChild(plotName)
    local sign = plot and plot:FindFirstChild("PlotSign")
    local yourBase = sign and sign:FindFirstChild("YourBase")
    return yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled == true or false
end

local function visFindNearestPrompt()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local plots = workspace:FindFirstChild("Plots")
    if not root or not plots then return nil, nil end
    local nearestPrompt, nearestDistance, nearestName = nil, math.huge, nil
    local radius = 63 
    for _, plot in ipairs(plots:GetChildren()) do
        if not visIsMyPlot(plot.Name) then
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                for _, pod in ipairs(pods:GetChildren()) do
                    local base = pod:FindFirstChild("Base")
                    local spawn = base and base:FindFirstChild("Spawn")
                    if spawn then
                        local distance = (spawn.Position - root.Position).Magnitude
                        if distance < nearestDistance and distance <= radius then
                            local attachment = spawn:FindFirstChild("PromptAttachment")
                            local prompt = nil
                            if attachment then
                                for _, child in ipairs(attachment:GetChildren()) do
                                    if child:IsA("ProximityPrompt") and (not child.ActionText or child.ActionText:find("Steal")) then
                                        prompt = child
                                        break
                                    end
                                end
                            end
                            if not prompt then
                                for _, child in ipairs(spawn:GetDescendants()) do
                                    if child:IsA("ProximityPrompt") and (not child.ActionText or child.ActionText:find("Steal")) then
                                        prompt = child
                                        break
                                    end
                                end
                            end
                            if prompt then
                                nearestPrompt, nearestDistance, nearestName = prompt, distance, pod.Name
                            end
                        end
                    end
                end
            end
        end
    end
    return nearestPrompt, nearestName
end

local function visExecuteSteal(prompt, podName)
    if M.isStealing or not prompt or not prompt.Parent then return end
    local data = M.stealCache[prompt]
    if not data then
        data = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}
        pcall(function()
            if type(getconnections) == "function" then
                local holds = getconnections(prompt.PromptButtonHoldBegan)
                for _, connection in ipairs(holds or {}) do
                    if type(connection.Function) == "function" then table.insert(data.holdCallbacks, connection.Function) end
                end
                local triggers = getconnections(prompt.Triggered)
                for _, connection in ipairs(triggers or {}) do
                    if type(connection.Function) == "function" then table.insert(data.triggerCallbacks, connection.Function) end
                end
            end
        end)
        M.stealCache[prompt] = data
    end
    if not data.ready then return end
    data.ready = false
    M.isStealing = true
    M.autoStealPhase = "holding"
    M.stealStartTime = tick()
    local duration = math.max(tonumber(M.Steal.StealDuration) or 1.3, 0.05)
    local directFallback = #data.holdCallbacks == 0 and #data.triggerCallbacks == 0
    for _, fn in ipairs(data.holdCallbacks) do task.spawn(function() pcall(fn) end) end
    task.spawn(function()
        local startTime = tick()
        while M.isStealing and M.Steal.AutoStealEnabled and tick() - startTime < duration do
            if not prompt.Parent then break end
            M.updateStealProgress(math.clamp((tick() - startTime) / duration, 0, 1), "STEALING")
            task.wait()
        end
        local success = M.isStealing and M.Steal.AutoStealEnabled and prompt.Parent ~= nil
        if success then
            pcall(function()
                for _, fn in ipairs(data.triggerCallbacks) do task.spawn(function() pcall(fn) end) end
                local remote = game:GetService("ReplicatedStorage"):FindFirstChild("StealAnimal")
                if remote and podName then remote:FireServer(podName) end
                if directFallback and fireproximityprompt then fireproximityprompt(prompt) end
            end)
            M.autoStealPhase = "success"
            M.autoStealLastResult = tick()
            M.updateStealProgress(1, "SUCCESS")
        else
            M.autoStealPhase = "failed"
            M.autoStealLastResult = tick()
            M.updateStealProgress(0, "FAILED")
        end
        task.wait(0.05)
        data.ready = true
        M.isStealing = false
        M.updateStealProgress(0)
    end)
end

function M.startAutoStealVis()
    if M.stealConn then pcall(function() M.stealConn:Disconnect() end) end
    M.Steal.AutoStealEnabled = true
    M.stealConn = RunService.Heartbeat:Connect(function()
        if not M.Steal.AutoStealEnabled or M.isStealing then return end
        local prompt, podName = visFindNearestPrompt()
        if prompt then visExecuteSteal(prompt, podName) end
    end)
    if M.statusGui then M.statusGui.Enabled = true end
end

function M.stopAutoStealVis()
    M.Steal.AutoStealEnabled = false
    M.isStealing = false
    if M.stealConn then pcall(function() M.stealConn:Disconnect() end); M.stealConn = nil end
    if M.progressConn then pcall(function() M.progressConn:Disconnect() end); M.progressConn = nil end
    M.updateStealProgress(0)
end




do
    local A = M.Semi
    if A.conn then pcall(function() A.conn:Disconnect() end); A.conn = nil end
    A.enabled = false
    A.holdMin = tonumber(A.holdMin) or 1.3
    A.holdMax = tonumber(A.holdMax) or 2.6
    A.entryDelay = tonumber(A.entryDelay) or 0.3
    A.cooldown = tonumber(A.cooldown) or 0.05
    A.primeRange = tonumber(A.primeRange) or 80
    A.radius = math.min(tonumber(A.radius) or 10, 10)
    A.plotSync = A.plotSync or {caches = {}, connections = {}}
    A.animals = A.animals or {}
    A.promptCache = A.promptCache or {}
    A.internalCache = A.internalCache or {}
    A.state = A.state or {active = false, startTime = 0, phase = "idle", label = "", lastResult = "", lastResultTime = 0}

    local function barSet(p, label)
        local progress = math.clamp(tonumber(p) or 0, 0, 1)
        local pct = math.floor(progress * 100 + 0.5)
        local text = nil
        if type(label) == "string" and label ~= "" then
            text = string.upper(label)
            if progress > 0 then
                text = text .. "  " .. tostring(pct) .. "%"
            end
        end
        M.updateStealProgress(progress, text)
    end
    local function barReset()
        M.updateStealProgress(0)
    end
    local function rootPart()
        local char = player.Character
        return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")) or nil
    end
    local function splitPath(path)
        if typeof(path) == "table" then return path end
        local out = {}
        for part in string.gmatch(tostring(path), "[^%.]+") do
            table.insert(out, tonumber(part) or part)
        end
        return out
    end
    local function resolvePath(path, root)
        local current, parent, key = root, nil, nil
        for _, part in ipairs(splitPath(path)) do
            parent = current
            key = part
            current = current and current[part] or nil
        end
        return current, parent, key
    end
    local function applySyncDiff(channelName, packet)
        local cache = A.plotSync.caches[channelName]
        if typeof(cache) ~= "table" then return end
        local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
        local current, parent, key = resolvePath(path, cache)
        if action == "Changed" then
            if parent ~= nil then parent[key] = a end
        elseif action == "ArrayInsert" then
            if current ~= nil then table.insert(current, b, a) end
        elseif action == "ArrayRemoved" then
            if current ~= nil then table.remove(current, b) end
        elseif action == "DictionaryInsert" then
            if current ~= nil then current[b] = a end
        elseif action == "DictionaryRemoved" then
            if current ~= nil then current[b] = nil end
        end
    end
    local function attachPlotChannel(remote, plots, requestData)
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
            for _, packet in ipairs(queue) do applySyncDiff(channelName, packet) end
        end)
    end

    function M.initSemiSync()
        if A.syncReady then return true end
        local ok = pcall(function()
            local rs = game:GetService("ReplicatedStorage")
            A.packages = rs:WaitForChild("Packages", 10)
            A.datas = rs:WaitForChild("Datas", 10)
            A.plots = workspace:WaitForChild("Plots", 10)
            if not (A.packages and A.datas and A.plots) then return end
            A.animalsData = require(A.datas:WaitForChild("Animals", 10))
            local sync = A.packages:WaitForChild("Synchronizer", 10)
            A.channelFolder = sync:WaitForChild("Channel", 10)
            A.routeRemote = sync:WaitForChild("CommunicationRoute", 10)
            A.requestData = sync:FindFirstChild("RequestData")
            for _, child in ipairs(A.channelFolder:GetChildren()) do
                if child:IsA("RemoteEvent") then attachPlotChannel(child, A.plots, A.requestData) end
            end
            A.channelFolder.ChildAdded:Connect(function(child)
                if child:IsA("RemoteEvent") then attachPlotChannel(child, A.plots, A.requestData) end
            end)
            A.routeRemote.OnClientEvent:Connect(function(actions)
                for _, action in ipairs(actions) do
                    local kind, channelName = action[1], tostring(action[2])
                    if A.plots and A.plots:FindFirstChild(channelName) then
                        if kind == "ListenerAdded" then
                            local remote = A.channelFolder and A.channelFolder:FindFirstChild(channelName)
                            if remote and remote:IsA("RemoteEvent") then attachPlotChannel(remote, A.plots, A.requestData) end
                        elseif kind == "ListenerRemoved" then
                            for remote, conn in pairs(A.plotSync.connections) do
                                if tostring(remote.Name) == channelName then
                                    pcall(function() conn:Disconnect() end)
                                    A.plotSync.connections[remote] = nil
                                    A.plotSync.caches[channelName] = nil
                                    break
                                end
                            end
                        end
                    end
                end
            end)
            A.syncReady = true
        end)
        return ok and A.syncReady == true
    end

    local function getPlotOwner(plot)
        local sign = plot and plot:FindFirstChild("PlotSign")
        local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
        local label = frame and frame:FindFirstChild("TextLabel")
        if not label or label.Text == "Empty Base" then return nil end
        return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
    end
    local function isMyBaseAnimal(animalData)
        if not animalData or not animalData.plot or not A.plots then return false end
        local plot = A.plots:FindFirstChild(animalData.plot)
        if not plot then return false end
        local owner = getPlotOwner(plot)
        return owner == player.DisplayName or owner == player.Name
    end
    local function podiumFor(animalData)
        local plot = A.plots and A.plots:FindFirstChild(animalData.plot)
        local podiums = plot and plot:FindFirstChild("AnimalPodiums")
        return podiums and podiums:FindFirstChild(animalData.slot) or nil
    end
    local function animalPos(animalData)
        local podium = podiumFor(animalData)
        return podium and podium:GetPivot().Position or nil
    end
    local function distToAnimal(animalData)
        local root = rootPart()
        local pos = animalPos(animalData)
        return root and pos and (root.Position - pos).Magnitude or math.huge
    end
    local function findPromptForAnimal(animalData)
        if not animalData then return nil end
        local cached = A.promptCache[animalData.uid]
        if cached and cached.Parent then return cached end
        local podium = podiumFor(animalData)
        local base = podium and podium:FindFirstChild("Base")
        local spawn = base and base:FindFirstChild("Spawn")
        local attach = spawn and spawn:FindFirstChild("PromptAttachment")
        if not attach then return nil end
        for _, prompt in ipairs(attach:GetChildren()) do
            if prompt:IsA("ProximityPrompt") then
                A.promptCache[animalData.uid] = prompt
                return prompt
            end
        end
        return nil
    end

    function M.scanAllPlotsSemi()
        if not M.initSemiSync() then return 0 end
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
                                uid = plot.Name .. "_" .. tostring(slot),
                            })
                        end
                    end
                end
            end
        end
        A.animals = newCache
        return #newCache
    end

    local function pickClosest()
        local root = rootPart()
        if not root then return nil end
        local best, bestDist = nil, math.huge
        for _, animalData in ipairs(A.animals) do
            if not isMyBaseAnimal(animalData) then
                local pos = animalPos(animalData)
                local dist = pos and (root.Position - pos).Magnitude or math.huge
                if dist <= (A.primeRange or 80) and dist < bestDist then
                    best, bestDist = animalData, dist
                end
            end
        end
        return best
    end
    local function buildCallbacks(prompt)
        if A.internalCache[prompt] then return end
        local data = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}
        local okHold, holds = pcall(getconnections, prompt.PromptButtonHoldBegan)
        if okHold and type(holds) == "table" then
            for _, conn in ipairs(holds) do
                if type(conn.Function) == "function" then table.insert(data.holdCallbacks, conn.Function) end
            end
        end
        local okTrigger, triggers = pcall(getconnections, prompt.Triggered)
        if okTrigger and type(triggers) == "table" then
            for _, conn in ipairs(triggers) do
                if type(conn.Function) == "function" then table.insert(data.triggerCallbacks, conn.Function) end
            end
        end
        if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then A.internalCache[prompt] = data end
    end
    local function executeSemi(prompt, animalData)
        if not prompt or not prompt.Parent or not animalData then return false end
        buildCallbacks(prompt)
        local data = A.internalCache[prompt]
        if not data or not data.ready then return false end
        data.ready = false
        A.state.active = true
        A.state.startTime = tick()
        A.state.phase = "holding"
        A.state.label = animalData.name or "Animal"
        M.isStealing = true
        M.stealStartTime = A.state.startTime
        task.spawn(function()
            local startTime = A.state.startTime
            for _, fn in ipairs(data.holdCallbacks) do task.spawn(function() pcall(fn) end) end
            while A.enabled and (M.stealMode == "Semi" or M.stealMode == "V2") and tick() - startTime < (A.holdMin or 1.3) do
                local elapsed = tick() - startTime
                A.state.phase = "holding"
                barSet(elapsed / (A.holdMax or 2.6), "HOLDING " .. tostring(A.state.label))
                task.wait()
            end
            A.state.phase = "waitingRange"
            local alreadyInRange = distToAnimal(animalData) <= (tonumber(A.radius) or 10)
            local fired = false
            while A.enabled and (M.stealMode == "Semi" or M.stealMode == "V2") and prompt.Parent do
                local elapsed = tick() - startTime
                if elapsed > (A.holdMax or 2.6) then break end
                barSet(elapsed / (A.holdMax or 2.6), "MOVE CLOSER  " .. tostring(A.state.label))
                if distToAnimal(animalData) <= (tonumber(A.radius) or 10) then
                    if not alreadyInRange then task.wait(A.entryDelay or 0.3) end
                    if A.enabled and (M.stealMode == "Semi" or M.stealMode == "V2") then
                        for _, fn in ipairs(data.triggerCallbacks) do task.spawn(function() pcall(fn) end) end
                        pcall(function() if _G.AutoCarrySpeed and _G.AutoCarrySpeed.WatchPickup then _G.AutoCarrySpeed.WatchPickup(1.25) end end)
                        fired = true
                    end
                    break
                end
                task.wait()
            end
            A.state.lastResult = fired and ("Stole " .. tostring(A.state.label)) or ("Missed window: " .. tostring(A.state.label))
            A.state.active = false
            A.state.phase = "idle"
            A.state.lastResultTime = tick()
            if fired then
                barSet(1, "STOLE " .. tostring(A.state.label))
            else
                barSet(0, A.state.lastResult)
            end
            task.wait(A.cooldown or 0.05)
            data.ready = true
            M.isStealing = false
            barReset()
        end)
        return true
    end

    function M.stopSemiSteal()
        A.enabled = false
        if A.conn then A.conn:Disconnect(); A.conn = nil end
        A.state.active = false
        A.state.phase = "idle"
        M.isStealing = false
        barReset()
    end

    function M.startSemiSteal()
        A.radius = math.min(tonumber(A.radius) or 10, 10)
        A.enabled = true
        M.initSemiSync()
        pcall(M.scanAllPlotsSemi)
        if A.conn then A.conn:Disconnect(); A.conn = nil end
        A.conn = RunService.Heartbeat:Connect(function()
            if not A.enabled then return end
            if not M.Steal.AutoStealEnabled then return end
            if M.stealMode ~= "Semi" and M.stealMode ~= "V2" then M.stopSemiSteal(); return end
            if A.state.active then return end
            local target = pickClosest()
            if not target then return end
            local prompt = findPromptForAnimal(target)
            if prompt then executeSemi(prompt, target) end
        end)
    end
end

local function v3ReleasePrompt(prompt)
    if not prompt then return end
    pcall(function()
        if prompt.InputHoldEnd then prompt:InputHoldEnd() end
    end)
end

local function v3HoldPrompt(prompt)
    if not prompt or not prompt.Parent then return false end
    local ok = pcall(function()
        if prompt.InputHoldBegin then
            prompt:InputHoldBegin()
        end
    end)
    if not ok then
        pcall(function()
            if fireproximityprompt then
                fireproximityprompt(prompt)
            end
        end)
    end
    buildCallbacks(prompt)
    local data = M.stealCache[prompt]
    if data then
        for _, fn in ipairs(data.holdCallbacks) do
            task.spawn(function() pcall(fn) end)
        end
    end
    return true
end

local function v3TriggerPrompt(prompt)
    if not prompt then return end
    buildCallbacks(prompt)
    local data = M.stealCache[prompt]
    if data then
        for _, fn in ipairs(data.triggerCallbacks) do
            task.spawn(function() pcall(fn) end)
        end
    end
    pcall(function()
        if prompt.InputHoldEnd then prompt:InputHoldEnd() end
    end)
    pcall(function()
        if fireproximityprompt then
            fireproximityprompt(prompt)
        end
    end)
end

local function v3LiveDist(ad, hrp)
    if not ad or not hrp then return math.huge end
    local plots = workspace:FindFirstChild("Plots")
    local plot = plots and plots:FindFirstChild(ad.plot)
    local pods = plot and plot:FindFirstChild("AnimalPodiums")
    local pod = pods and pods:FindFirstChild(ad.slot)
    if pod then
        local ok, pos = pcall(function() return pod:GetPivot().Position end)
        if ok and pos then
            ad.worldPosition = pos
            return (hrp.Position - pos).Magnitude
        end
    end
    if ad.worldPosition then
        return (hrp.Position - ad.worldPosition).Magnitude
    end
    return math.huge
end

function M.startV3Steal()
    if M.V3.conn then return end
    M.V3.enabled = true
    M.V3.progress = 0
    M.V3.currentUid = nil
    M.V3.lastInRange = 0
    M.V3.holding = false
    M.V3.holdPrompt = nil
    M.V3.cooldownUntil = 0
    M.V3.lastHoldPulse = 0

    M.V3.conn = RunService.Heartbeat:Connect(function(dt)
        if not M.Steal.AutoStealEnabled or M.stealMode ~= "V3" or not M.V3.enabled then
            if M.V3.holdPrompt then v3ReleasePrompt(M.V3.holdPrompt) end
            if M.V3.progress > 0 or M.V3.holding or M.isStealing then
                M.V3.progress = 0
                M.V3.currentUid = nil
                M.V3.holding = false
                M.V3.holdPrompt = nil
                M.isStealing = false
                M.updateStealProgress(0)
            end
            return
        end

        local stopT = math.max(tonumber(M.Steal.StopTime) or 0.35, 0.05)
        local holdT = math.max(tonumber(M.Steal.StealDuration) or 1.4, 0.05)

        if tick() < (M.V3.cooldownUntil or 0) then
            M.updateStealProgress(0)
            return
        end

        local char = player.Character
        local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
        if not hrp then return end

        local target = nearestAnimalNormal()
        local dist = target and v3LiveDist(target, hrp) or math.huge
        local radius = M.getActiveStealRadius()
        local inRange = target ~= nil and dist <= radius

        if inRange then
            M.V3.lastInRange = tick()

            if M.V3.currentUid ~= target.uid then
                if M.V3.holdPrompt then v3ReleasePrompt(M.V3.holdPrompt) end
                M.V3.currentUid = target.uid
                M.V3.progress = 0
                M.V3.holding = false
                M.V3.holdPrompt = nil
            end

            local prompt = M.promptCache[target.uid]
            if not prompt or not prompt.Parent then
                prompt = findPromptNormal(target)
            end
            if not prompt then
                M.V3.progress = math.clamp(M.V3.progress + (dt / holdT), 0, 1)
                M.updateStealProgress(M.V3.progress)
                M.isStealing = M.V3.progress > 0
                return
            end

            M.V3.holdPrompt = prompt
            M.isStealing = true
            local now = tick()
            if (not M.V3.holding) or (now - (M.V3.lastHoldPulse or 0) > 0.1) then
                M.V3.holding = true
                M.V3.lastHoldPulse = now
                v3HoldPrompt(prompt)
            end

            M.V3.progress = math.clamp(M.V3.progress + (dt / holdT), 0, 1)
            M.updateStealProgress(M.V3.progress)

            if M.V3.progress >= 1 then
                v3TriggerPrompt(prompt)
                M.V3.progress = 0
                M.V3.currentUid = nil
                M.V3.holding = false
                M.V3.holdPrompt = nil
                M.isStealing = false
                M.updateStealProgress(0)
                M.V3.cooldownUntil = tick() + math.max(stopT, 0.25)
            end
        else
            if M.V3.holding or M.V3.holdPrompt then
                v3ReleasePrompt(M.V3.holdPrompt)
                M.V3.holding = false
                M.V3.holdPrompt = nil
            end

            if M.V3.progress > 0 then
                local decay = dt / stopT
                M.V3.progress = math.max(0, M.V3.progress - decay)
                M.updateStealProgress(M.V3.progress)
                if M.V3.progress <= 0 then
                    M.V3.currentUid = nil
                    M.isStealing = false
                    M.updateStealProgress(0)
                else
                    M.isStealing = true
                end
            else
                M.isStealing = false
            end
        end
    end)
end

function M.stopV3Steal()
    M.V3.enabled = false
    if M.V3.holdPrompt then
        v3ReleasePrompt(M.V3.holdPrompt)
    end
    if M.V3.conn then
        pcall(function() M.V3.conn:Disconnect() end)
        M.V3.conn = nil
    end
    M.V3.progress = 0
    M.V3.currentUid = nil
    M.V3.holding = false
    M.V3.holdPrompt = nil
    M.V3.cooldownUntil = 0
    M.V3.lastInRange = 0
    M.V3.lastHoldPulse = 0
    M.isStealing = false
    M.updateStealProgress(0)
end

function M.startAutoSteal()
    return M.startAutoStealVis()
end

function M.stopAutoSteal()
    return M.stopAutoStealVis()
end

function M.setStealRadius(radius)
    M.Steal.StealRadius = radius
    M.updateStatusRadius()
end




function M.findBat()
    local char=player.Character;if not char then return nil end
    for _,tool in ipairs(char:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end
    local bp=player:FindFirstChild("Backpack");if bp then for _,tool in ipairs(bp:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end end
    return nil
end

function M.findMedusa()
    local c=player.Character;if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
    local bp=player:FindFirstChild("Backpack");if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
    return nil
end

function M.unequipMedusaAfterUse(med)
    task.spawn(function()
        for _ = 1, 5 do
            task.wait(0.08)
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local backpack = player:FindFirstChildOfClass("Backpack")
            
            if med and backpack and med.Parent == char then
                pcall(function() med.Parent = backpack end)
            end
            if not med or med.Parent ~= char then break end
        end
    end)
end

function M.useMedusaCounter()
    if M.medusaDebounce then return end;if M.MEDUSA_COOLDOWN>(tick()-M.medusaLastUsed) then return end
    local c=player.Character;if not c then return end;M.medusaDebounce=true
    local med=M.findMedusa();if not med then M.medusaDebounce=false;return end
    local function activateOnce()
        local currentChar = player.Character
        if not currentChar or med.Parent ~= currentChar then M.medusaDebounce=false;return end
        pcall(function() med:Activate() end)
        M.unequipMedusaAfterUse(med)
        task.defer(function() task.wait(0.18); if M._switchMedusaToBat then M._switchMedusaToBat() end end)
        M.medusaLastUsed=tick();M.medusaDebounce=false
    end
    if med.Parent~=c then
        local hum2=c:FindFirstChildOfClass("Humanoid")
        if not hum2 then M.medusaDebounce=false;return end
        pcall(function() hum2:EquipTool(med) end)
        task.delay(0.12, activateOnce)
        return
    end
    activateOnce()
end

function M.getClosestTargetAimbot()
    local myChar = player.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local closest, closestDistance = nil, math.huge
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= player then
            local otherChar = other.Character
            local otherRoot = otherChar and otherChar:FindFirstChild("HumanoidRootPart")
            local otherHum = otherChar and otherChar:FindFirstChildOfClass("Humanoid")
            if otherRoot and otherHum and otherHum.Health > 0 then
                local distance = (otherRoot.Position - myRoot.Position).Magnitude
                if distance < closestDistance then
                    closest = otherRoot
                    closestDistance = distance
                end
            end
        end
    end
    return closest
end

function M.startAutoMedusa()
    if M.autoMedusaConn then pcall(function() M.autoMedusaConn:Disconnect() end) end
    M.autoMedusaEnabled = true
    M.autoMedusaEquipPending = false
    M.autoMedusaUsePending = false

    local function activateMedusa(med, char)
        if M.autoMedusaUsePending or not med or med.Parent ~= char then return false end
        M.autoMedusaUsePending = true
        pcall(function() med:Activate() end)
        M.autoMedusaLastUsed = tick()
        M.unequipMedusaAfterUse(med)
        task.delay(0.30, function()
            M.autoMedusaUsePending = false
            if M.autoMedusaEnabled and M._switchMedusaToBat then M._switchMedusaToBat() end
        end)
        return true
    end

    M.autoMedusaConn = RunService.Heartbeat:Connect(function()
        if not M.autoMedusaEnabled or M.autoMedusaUsePending or M.autoMedusaEquipPending then return end
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hum or hum.Health <= 0 or not root then return end
        local target = M.getClosestTargetAimbot and M.getClosestTargetAimbot() or nil
        local range = tonumber(M.autoMedusaRange) or 15
        if not target or not target.Position or (target.Position - root.Position).Magnitude > range then return end
        if tick() - (M.autoMedusaLastUsed or 0) < (tonumber(M.MEDUSA_COOLDOWN) or 25) then return end

        local med = M.findMedusa()
        if not med then return end
        if med.Parent == char then
            activateMedusa(med, char)
            return
        end

        M.autoMedusaEquipPending = true
        pcall(function() hum:EquipTool(med) end)
        task.delay(0.20, function()
            M.autoMedusaEquipPending = false
            if not M.autoMedusaEnabled then return end
            local currentChar = player.Character
            local currentHum = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
            local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
            local currentTarget = M.getClosestTargetAimbot and M.getClosestTargetAimbot() or nil
            local currentRange = tonumber(M.autoMedusaRange) or 15
            if not currentChar or not currentHum or currentHum.Health <= 0 or med.Parent ~= currentChar then return end
            if not currentTarget or not currentTarget.Position or not currentRoot or (currentTarget.Position - currentRoot.Position).Magnitude > currentRange then return end
            if tick() - (M.autoMedusaLastUsed or 0) < (tonumber(M.MEDUSA_COOLDOWN) or 25) then return end
            activateMedusa(med, currentChar)
        end)
    end)
    if M.setAutoMedusaVisual then M.setAutoMedusaVisual(true) end
    if M.mobBtnRefs and M.mobBtnRefs.autoMedusa then M.mobBtnRefs.autoMedusa(true) end
end

function M.stopAutoMedusa()
    M.autoMedusaEnabled = false
    M.autoMedusaEquipPending = false
    if M.autoMedusaConn then pcall(function() M.autoMedusaConn:Disconnect() end); M.autoMedusaConn = nil end
    if M.setAutoMedusaVisual then M.setAutoMedusaVisual(false) end
    if M.mobBtnRefs and M.mobBtnRefs.autoMedusa then M.mobBtnRefs.autoMedusa(false) end
end

function M.onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if part.Anchored and part.Transparency==1 then
            if M.medusaCounterEnabled then M.useMedusaCounter() end
        end
    end)
end

function M.setupMedusa(char)
    for _,c in pairs(M.Conns.anchor) do pcall(function() c:Disconnect() end) end;M.Conns.anchor={}
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(M.Conns.anchor,M.onAnchorChanged(part)) end end
    table.insert(M.Conns.anchor,char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(M.Conns.anchor,M.onAnchorChanged(part)) end end))
end

function M.stopMedusaCounter() for _,c in pairs(M.Conns.anchor) do pcall(function() c:Disconnect() end) end;M.Conns.anchor={} end

function M.findBatForCounter()
    local c=player.Character;if not c then return nil end;local bp=player:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(M.BAT_COUNTER_SLAP_LIST) do local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name));if t then return t end end
    for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
    if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
    return nil
end

function M.swingBatForCounter(bat,char)
    local hum2=char:FindFirstChildOfClass("Humanoid")
    if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end;task.wait(0.05) end
    local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then pcall(function() remote:FireServer() end);task.wait(0.15);pcall(function() remote:FireServer() end)
    else pcall(function() bat:Activate() end);task.wait(0.15);pcall(function() bat:Activate() end) end
end

function M.startBatCounter()
    if M.Conns.batCounter then return end
    M.Conns.batCounter=RunService.Heartbeat:Connect(function()
        if not M.batCounterEnabled or M.batCounterDebounce then return end
        local char=player.Character;if not char then return end;local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
        local st=hum2:GetState()
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
            M.batCounterDebounce=true;task.spawn(function() local bat=M.findBatForCounter();if bat then M.swingBatForCounter(bat,char) end;task.wait(0.5);M.batCounterDebounce=false end)
        end
    end)
    M.updateBatProtection()
end

function M.stopBatCounter()
    if M.Conns.batCounter then M.Conns.batCounter:Disconnect();M.Conns.batCounter=nil end
    M.batCounterDebounce=false
    M.updateBatProtection()
end




M.aimbotSpeed = M.aimbotSpeed or 58
M.laggerAimbotSpeed = M.laggerAimbotSpeed or 40
M._aimbotSwingCooldown = false


local ZBat = {
    on = false,
    conn = nil,
    equipped = false,
    Speed = 56,
    VertSpeed = 52,
    Dist = -2.8,
    Height = 4.75,
    VertOffset = 1,
    TurnSpeed = 285,
    MaxTurnRate = 28,
}

local function zFindBat()
    local char = player.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
    end
    local bp = player:FindFirstChild("Backpack") or player:FindFirstChildOfClass("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
        end
    end
    return nil
end

local function zGetTarget()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local d = (tRoot.Position - root.Position).Magnitude
                if d < minDist then minDist = d; closest = tRoot end
            end
        end
    end
    return closest
end

local function _aceFiniteVector3(v)
    return v.X==v.X and v.Y==v.Y and v.Z==v.Z
        and math.abs(v.X)<1e7 and math.abs(v.Y)<1e7 and math.abs(v.Z)<1e7
end

function M._7upInspectTarget(plr, targetRoot, myRoot)
    if not plr or not targetRoot or not targetRoot.Parent then return true, nil end
    M._targetSamples = M._targetSamples or {}
    local sample = M._targetSamples[plr] or {}
    M._targetSamples[plr] = sample
    local now = tick()
    local pos = targetRoot.Position
    local vel = targetRoot.AssemblyLinearVelocity
    local destroyHeight = workspace.FallenPartsDestroyHeight or -500
    local voidFloor = math.max(destroyHeight + 90, -50)
    local dt = sample.time and math.max(now - sample.time, 1/240) or math.huge
    local delta = sample.position and (pos - sample.position) or Vector3.zero
    local impossibleStep = sample.position ~= nil and dt < 0.4 and (delta.Magnitude > 90 or math.abs(delta.Y) > 38)
    local badVelocity = not _aceFiniteVector3(vel) or vel.Magnitude > 650 or math.abs(vel.Y) > 150
    local badPosition = not _aceFiniteVector3(pos) or pos.Y <= voidFloor or pos.Y > 650
        or (myRoot and (pos - myRoot.Position).Magnitude > 4000)
    if badPosition or badVelocity or impossibleStep then sample.suspiciousUntil = now + 1.35
    elseif now >= (sample.suspiciousUntil or 0) then sample.safePosition = pos; sample.safeCFrame = targetRoot.CFrame end
    sample.position = pos; sample.time = now
    return now < (sample.suspiciousUntil or 0), sample
end

function M._7upGuardVoid(root, hum, targetRoot)
    if not root or not hum then return false end
    local now = tick()
    local position = root.Position
    local velocity = root.AssemblyLinearVelocity
    local destroyHeight = workspace.FallenPartsDestroyHeight or -500
    local voidFloor = math.max(destroyHeight + 80, -55)
    local dt = now - (M._lastSampleTime or now)
    local suddenDrop = M._lastPosition and dt <= 0.35 and position.Y < M._lastPosition.Y - 40
    local suddenRise = M._lastPosition and dt <= 0.35 and position.Y > M._lastPosition.Y + 25
    local safeRise = M._lastSafeCFrame and position.Y > M._lastSafeCFrame.Position.Y + 30
    local forcedLaunch = math.abs(velocity.Y) > 90 or velocity.Magnitude > 450
    local inVoid = position.Y <= voidFloor
    local resetHeight = position.Y > 400
    local recovering = now < (M._voidRecoverUntil or 0)

    if inVoid or suddenDrop or suddenRise or safeRise or forcedLaunch or resetHeight then
        if sethiddenproperty then pcall(function() sethiddenproperty(root, "PhysicsRepRootPart", root) end) end
        local recoveryCFrame = M._safeEngagementCFrame or M._lastSafeCFrame
        if targetRoot and targetRoot.Parent and targetRoot.Position.Y > voidFloor + 10 and targetRoot.Position.Y < 350 then
            local tp = targetRoot.Position
            local recoveryPos = Vector3.new(tp.X, tp.Y + 0.9, tp.Z)
            local facing = Vector3.new(targetRoot.CFrame.LookVector.X, 0, targetRoot.CFrame.LookVector.Z)
            if facing.Magnitude < 0.01 then facing = Vector3.new(0, 0, -1) end
            recoveryCFrame = CFrame.lookAt(recoveryPos, recoveryPos + facing.Unit)
        end
        pcall(function()
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            hum.PlatformStand = false
            hum.Sit = false
            hum.AutoRotate = true
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
            if recoveryCFrame then root.CFrame = recoveryCFrame end
        end)
        M._voidRecoverUntil = now + 0.55
        M._physPulseUntil = now + 0.2
        recovering = true
    elseif not recovering and position.Y > voidFloor + 15 and math.abs(velocity.Y) < 85 and position.Y < 250 then
        M._lastSafeCFrame = root.CFrame
    end

    if recovering then
        pcall(function()
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            if targetRoot and targetRoot.Parent and targetRoot.Position.Y > voidFloor + 10 and targetRoot.Position.Y < 350 then
                local tp = targetRoot.Position + Vector3.new(0, 0.9, 0)
                root.CFrame = CFrame.new(tp)
            end
        end)
        if sethiddenproperty then pcall(function() sethiddenproperty(root, "PhysicsRepRootPart", root) end) end
    end
    M._lastPosition = position
    M._lastSampleTime = now
    return recovering
end

function M.getNormalAimbotSpeed()
    if M.laggerModeEnabled or M.laggerCarryActive then
        return tonumber(M.laggerAimbotSpeed) or 40
    end
    return tonumber(M.aimbotSpeed) or 58
end

function M.startBatAimbot()
    if not M.safeModeTryStart() then return end
    if M.aimbotConn then pcall(function() M.aimbotConn:Disconnect() end); M.aimbotConn = nil end
    if M.autoLeftEnabled then M.autoLeftEnabled=false; if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end; M.stopAutoLeft() end
    if M.autoRightEnabled then M.autoRightEnabled=false; if M.autoRightSetVisual then M.autoRightSetVisual(false) end; M.stopAutoRight() end
    
    M.autoBatEnabled = true
    M.updateBatProtection()
    M._aimbotSwingCooldown = false
    
    M.aimbotConn = RunService.RenderStepped:Connect(function()
        if not M.autoBatEnabled then return end
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root or not hum or hum.Health <= 0 then return end
        
        local bat = char:FindFirstChildOfClass("Tool") or zFindBat()
        if bat and bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
        
        local target = zGetTarget()
        if not target then return end
        
        local chaseSpeed = M.getNormalAimbotSpeed()
        local targetPos = target.Position + Vector3.new(0, 0.9, 0)
        local diff = targetPos - root.Position
        local dist = diff.Magnitude
        
        if dist > 0.1 then
            local moveDir = diff.Unit
            root.AssemblyLinearVelocity = Vector3.new(moveDir.X * chaseSpeed, root.AssemblyLinearVelocity.Y, moveDir.Z * chaseSpeed)
            local lookAt = Vector3.new(target.Position.X, root.Position.Y, target.Position.Z)
            root.CFrame = CFrame.lookAt(root.Position, lookAt)
        end
        
        if M.autoSwingEnabled and bat and not M._aimbotSwingCooldown then
            M._aimbotSwingCooldown = true
            pcall(function() bat:Activate() end)
            task.delay(0.08, function() M._aimbotSwingCooldown = false end)
        end
    end)
    if M.autoBatSetVisual then M.autoBatSetVisual(true) end
    if M.mobBtnRefs and M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(true) end
end

function M.stopBatAimbot()
    M.autoBatEnabled = false
    M.updateBatProtection()
    if M.aimbotConn then pcall(function() M.aimbotConn:Disconnect() end); M.aimbotConn = nil end
    M._aimbotSwingCooldown = false
    M.restoreCharacterMovement(player.Character)
    if M.autoBatSetVisual then M.autoBatSetVisual(false) end
    if M.mobBtnRefs and M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(false) end
end

function M.queueAutoBatStart()
    if not M.safeModeTryStart() then return end
    if M.antiKickEnabled and M.brainrotDetected then return end
    if M.autoLeftEnabled then M.autoLeftEnabled=false; if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end; M.stopAutoLeft() end
    if M.autoRightEnabled then M.autoRightEnabled=false; if M.autoRightSetVisual then M.autoRightSetVisual(false) end; M.stopAutoRight() end
    M.startBatAimbot()
end

function M.findBatForAimbot() return zFindBat() end

function M.swingCurrentBatAimbot(char)
    if not M.autoSwingEnabled then return end
    local bat = zFindBat()
    if bat and bat.Parent == char then
        pcall(function() bat:Activate() end)
    end
end




function M._adClearConns()
    for _, key in ipairs({"_antiDieConn", "antiDieConn", "_antiDieCharConn", "_antiDieHealthConn", "_antiDieDiedConn", "_antiDieRenderConn", "_antiDieStateConn"}) do
        local c = M[key]
        if c then pcall(function() c:Disconnect() end); M[key] = nil end
    end
end

local function _adHarden(hum)
    if not hum then return end
    pcall(function() hum.BreakJointsOnDeath = false end)
    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false) end)
    pcall(function() hum.RequiresNeck = false end)
end

function M._adProtectCharacter(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    pcall(function()
        _adHarden(hum)
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        local st = hum:GetState()
        if hum.Health <= 0 then hum.Health = hum.MaxHealth end
        if st == Enum.HumanoidStateType.Dead or st == Enum.HumanoidStateType.Ragdoll then
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
    if M._antiDieHealthConn then pcall(function() M._antiDieHealthConn:Disconnect() end) end
    M._antiDieHealthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not M.antiDieEnabled and not M.bypassAimbotEnabled and not M.autoBatEnabled then return end
        pcall(function()
            _adHarden(hum)
            if hum.Health < hum.MaxHealth or hum.Health <= 0 then
                hum.MaxHealth = math.huge
                hum.Health = math.huge
                hum.PlatformStand = false
                hum.Sit = false
            end
        end)
    end)
    if M._antiDieDiedConn then pcall(function() M._antiDieDiedConn:Disconnect() end) end
    M._antiDieDiedConn = hum.Died:Connect(function()
        if not M.antiDieEnabled and not M.bypassAimbotEnabled and not M.autoBatEnabled then return end
        pcall(function()
            _adHarden(hum)
            hum.MaxHealth = math.huge
            hum.Health = math.huge
            hum.PlatformStand = false
            hum.Sit = false
            hum:ChangeState(Enum.HumanoidStateType.Running)
            task.defer(function()
                if not M.antiDieEnabled and not M.bypassAimbotEnabled and not M.autoBatEnabled then return end
                pcall(function()
                    _adHarden(hum)
                    hum.MaxHealth = math.huge
                    hum.Health = math.huge
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end)
            end)
        end)
    end)
    if M._antiDieStateConn then pcall(function() M._antiDieStateConn:Disconnect() end) end
    M._antiDieStateConn = hum.StateChanged:Connect(function(_, new)
        if not M.antiDieEnabled and not M.bypassAimbotEnabled and not M.autoBatEnabled then return end
        if new == Enum.HumanoidStateType.Dead or new == Enum.HumanoidStateType.Ragdoll then
            pcall(function()
                _adHarden(hum)
                hum.MaxHealth = math.huge
                hum.Health = math.huge
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end
    end)
end

function M.startAntiDie()
    
    if M._adClearConns then pcall(M._adClearConns) end
    M.antiDieEnabled = true
    M._antiDieDeathConns = M._antiDieDeathConns or {}

    local function destroyAdBillboard()
        if M._adBillboardUpdater then pcall(function() M._adBillboardUpdater:Disconnect() end); M._adBillboardUpdater = nil end
        if M._adBillboardGui then pcall(function() M._adBillboardGui:Destroy() end); M._adBillboardGui = nil end
    end
    M._destroyAdBillboard = destroyAdBillboard

    -- Anti Die continúa protegiendo al personaje, pero no crea ningún mensaje,
    -- BillboardGui, texto ni notificación visible.
    local function createAdBillboard(char)
        destroyAdBillboard()
    end

    local function protectChar(char)
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
        if not hum then return end
        pcall(function()
            hum.MaxHealth = math.huge
            hum.Health = math.huge
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            hum.BreakJointsOnDeath = false
        end)
        for _, c in ipairs(M._antiDieDeathConns) do pcall(function() c:Disconnect() end) end
        M._antiDieDeathConns = {}
        table.insert(M._antiDieDeathConns, hum.StateChanged:Connect(function(_, new)
            if not M.antiDieEnabled then return end
            if new == Enum.HumanoidStateType.Dead then
                pcall(function()
                    hum.Health = math.huge
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                end)
            end
        end))
        table.insert(M._antiDieDeathConns, hum:GetPropertyChangedSignal("Health"):Connect(function()
            if not M.antiDieEnabled then return end
            if hum.Health < hum.MaxHealth then pcall(function() hum.Health = math.huge end) end
        end))
        if M.antiDieConn then pcall(function() M.antiDieConn:Disconnect() end) end
        M.antiDieConn = RunService.Heartbeat:Connect(function()
            if not M.antiDieEnabled then return end
            if hum and hum.Parent and hum.Health < hum.MaxHealth then
                pcall(function() hum.Health = math.huge end)
            end
        end)
        createAdBillboard(char)
    end
    M._adProtectCharacter = protectChar

    if player.Character then protectChar(player.Character) end
    if M._antiDieCharConn then pcall(function() M._antiDieCharConn:Disconnect() end) end
    M._antiDieCharConn = player.CharacterAdded:Connect(function(c)
        if not M.antiDieEnabled then return end
        task.wait(0.1)
        protectChar(c)
    end)
    if M.setAntiDieVisual then pcall(function() M.setAntiDieVisual(true) end) end
end

function M.stopAntiDie()
    M.antiDieEnabled = false
    if M._destroyAdBillboard then pcall(M._destroyAdBillboard) end
    if M._antiDieDeathConns then
        for _, c in ipairs(M._antiDieDeathConns) do pcall(function() c:Disconnect() end) end
        M._antiDieDeathConns = {}
    end
    pcall(function()
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            hum.MaxHealth = 100
            if hum.Health > 100 then hum.Health = 100 end
        end
    end)
    M._adClearConns()
    if M._antiDieRenderConn then
        pcall(function() M._antiDieRenderConn:Disconnect() end)
        M._antiDieRenderConn = nil
    end
end


function M.setPerfectHit(enabled)
    M.perfectHitEnabled = enabled == true
    M.tpBatSureHitEnabled = M.perfectHitEnabled
    if M.perfectHitEnabled then
        M.tpBatHitMode = "Sure"
    else
        M.tpBatHitMode = "Normal"
    end
    if M.setPerfectHitVisual then pcall(function() M.setPerfectHitVisual(M.perfectHitEnabled) end) end
    if M.setTpBatModeUI then
        pcall(function()
            M.setTpBatModeUI(M.perfectHitEnabled and "Sure Hit" or "Normal Hit")
        end)
    end
    pcall(saveCherryConfig)
end





M._hardHitRing = nil
M._hardHitConn = nil

function M.hideHardHitRing()
    if M._hardHitRing then
        pcall(function() M._hardHitRing:Destroy() end)
        M._hardHitRing = nil
    end
end

function M.showHardHitRing()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if M._hardHitRing and M._hardHitRing.Parent then return end
    local cyl = Instance.new("CylinderHandleAdornment")
    cyl.Name = "S1NXYHardHitRing"
    cyl.Adornee = hrp
    cyl.Color3 = Color3.fromRGB(0, 0, 0)
    cyl.AlwaysOnTop = true
    cyl.ZIndex = 5
    cyl.Transparency = 0.1
    local r = tonumber(M.hardHitRadius) or 10
    cyl.Radius = r
    cyl.InnerRadius = math.max(0.1, r - 0.35)
    cyl.Height = 0.15
    cyl.CFrame = CFrame.new(0, -3, 0)
    cyl.Parent = hrp
    M._hardHitRing = cyl
end

function M.startHardHit()
    M.hardHitEnabled = true
    if M._hardHitConn then return end
    M._hardHitConn = RunService.Heartbeat:Connect(function()
        if not M.hardHitEnabled then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        if not M._hardHitRing or not M._hardHitRing.Parent then
            M.showHardHitRing()
        end
        if M._hardHitRing then
            local r = tonumber(M.hardHitRadius) or 10
            M._hardHitRing.Radius = r
            M._hardHitRing.InnerRadius = math.max(0.1, r - 0.35)
            if M._hardHitRing.Adornee ~= root then
                M._hardHitRing.Adornee = root
                M._hardHitRing.Parent = root
            end
        end
    end)
    M.showHardHitRing()
end

function M.stopHardHit()
    M.hardHitEnabled = false
    if M._hardHitConn then
        pcall(function() M._hardHitConn:Disconnect() end)
        M._hardHitConn = nil
    end
    M.hideHardHitRing()
end





M._bypassTarget = nil
M._bypassHRP = nil
M._bypassHum = nil
M.tpBatRange = M.tpBatRange or 1e9
M.tpBatClose = M.tpBatClose or 6
M.tpBatOffset = M.tpBatOffset or 2.4
M._tpBatOrbitAngle = 0
M._tpBatLastSwing = 0
M._bypassSwingCooldown = false

local TP_BAT_PRIORITY_NAMES = {
    "Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap", "Emerald Slap",
    "Ruby Slap", "Dark Matter Slap", "Flame Slap", "Nuclear Slap", "Galaxy Slap", "Glitched Slap"
}

function M._bypassFindBat()
    local character = player.Character
    if not character then return nil end
    local bat = character:FindFirstChild("Bat")
    if bat and bat:IsA("Tool") then return bat end
    local backpack = player:FindFirstChild("Backpack") or player:FindFirstChildOfClass("Backpack")
    if backpack then
        bat = backpack:FindFirstChild("Bat")
        if bat and bat:IsA("Tool") then
            bat.Parent = character
            return bat
        end
    end
    return nil
end

function M._bypassGetClosest()
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return nil, math.huge end
    local best, bestDist = nil, math.huge
    for _, other in pairs(Players:GetPlayers()) do
        if other ~= player and other.Character then
            local humanoid = other.Character:FindFirstChild("Humanoid")
            local targetRoot = other.Character:FindFirstChild("HumanoidRootPart")
            if humanoid and humanoid.Health > 0 and targetRoot then
                local distance = (root.Position - targetRoot.Position).Magnitude
                if distance < bestDist then
                    bestDist, best = distance, targetRoot
                end
            end
        end
    end
    return best, bestDist
end

M._adaptTpBatCooldown = false
M._adaptTpBatSilentAim = false
M._adaptTpBatCharacter = nil
M._adaptTpBatHumanoid = nil
M._adaptTpBatRoot = nil

function M._adaptTpBatTryHit()
    if M._adaptTpBatCooldown then return end
    M._adaptTpBatCooldown = true
    pcall(function()
        local bat = M._bypassFindBat()
        if bat then
            bat:Activate()
            local remote = bat:FindFirstChildWhichIsA("RemoteEvent")
            if remote then remote:FireServer() end
        end
    end)
    task.delay(0.05, function() M._adaptTpBatCooldown = false end)
end




function M._bypassClearGodConns()
    for _, key in ipairs({"_bypassGodConn", "_bypassGodHealthConn", "_bypassGodDiedConn", "_bypassGodCharConn"}) do
        local c = M[key]
        if c then pcall(function() c:Disconnect() end); M[key] = nil end
    end
end

M._batProtectionEnabled = false

function M.isBatModeActive()
    return M.autoBatEnabled == true
        or M.bypassAimbotEnabled == true
        or M.batV2Enabled == true
        or M.batCounterEnabled == true
end

function M.updateBatProtection()
    local active = M.isBatModeActive()
    if active and not M._batProtectionEnabled then
        M._batProtectionEnabled = true
        M.enableBypassGodmode()
    elseif not active and M._batProtectionEnabled then
        M._batProtectionEnabled = false
        M.disableBypassGodmode()
    end
end

function M._bypassProtectCharacter(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    pcall(function()
        hum.MaxHealth = math.max(hum.MaxHealth, 100)
        if hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
    end)
    if M._bypassGodHealthConn then pcall(function() M._bypassGodHealthConn:Disconnect() end) end
    M._bypassGodHealthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not M.isBatModeActive() then return end
        if hum.Health < hum.MaxHealth then
            pcall(function() hum.Health = hum.MaxHealth end)
        end
    end)
    if M._bypassGodDiedConn then pcall(function() M._bypassGodDiedConn:Disconnect() end) end
    M._bypassGodDiedConn = hum.Died:Connect(function()
        if not M.isBatModeActive() then return end
        pcall(function()
            hum.Health = hum.MaxHealth
            hum:ChangeState(Enum.HumanoidStateType.Running)
            hum.PlatformStand = false
        end)
    end)
end

function M.enableBypassGodmode()
    M._bypassClearGodConns()
    local char = player.Character
    if char then M._bypassProtectCharacter(char) end
    M._bypassGodCharConn = player.CharacterAdded:Connect(function(c)
        if not M.isBatModeActive() then return end
        task.wait(0.15)
        M._bypassProtectCharacter(c)
    end)
    M._bypassGodConn = RunService.Heartbeat:Connect(function()
        if not M.isBatModeActive() then return end
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        pcall(function()
            if hum.Health < (hum.MaxHealth or 100) then
                hum.Health = hum.MaxHealth or 100
            end
            if hum:GetState() == Enum.HumanoidStateType.Dead then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
    end)
end

function M.disableBypassGodmode()
    M._bypassClearGodConns()
end

function M.startBypassAimbot()
    if not M.safeModeTryStart() then return end
    if M.bypassAimbotConn then
        pcall(function() M.bypassAimbotConn:Disconnect() end)
        M.bypassAimbotConn = nil
    end

    
    if M.autoBatEnabled then
        M.autoBatEnabled = false
        if M.autoBatSetVisual then M.autoBatSetVisual(false) end
        M.stopBatAimbot()
    end

    M.bypassAimbotEnabled = true
    M.updateBatProtection()
    M._adaptTpBatCooldown = false

    M.bypassAimbotConn = RunService.Heartbeat:Connect(function()
        if not M.bypassAimbotEnabled then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return end

        local target = M._bypassGetClosest()
        if not target or not target.Parent then return end

        if not char:FindFirstChildOfClass("Tool") then
            local bat = M._bypassFindBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end

        
        if sethiddenproperty then
            pcall(function() sethiddenproperty(root, "PhysicsRepRootPart", target) end)
        end

        local targetPos = target.Position + Vector3.new(0, 0.9, 0)
        if (root.Position - targetPos).Magnitude > 8 then
            root.CFrame = CFrame.new(targetPos)
        end

        local cam = workspace.CurrentCamera
        if cam then
            cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position)
        end

        M._adaptTpBatTryHit()
    end)

    if M.setBypassVisual then M.setBypassVisual(true) end
    if M.mobBtnRefs and M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(true) end
end

function M.restoreCharacterMovement(char)
    char = char or player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        pcall(function()
            root.Anchored = false
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            root.Velocity = Vector3.zero
            root.RotVelocity = Vector3.zero
        end)
    end
    if hum then
        pcall(function()
            hum.PlatformStand = false
            hum.Sit = false
            hum.AutoRotate = true
            if hum.WalkSpeed <= 0 then hum.WalkSpeed = 16 end
            if hum.UseJumpPower and hum.JumpPower <= 0 then hum.JumpPower = 50 end
            if not hum.UseJumpPower and hum.JumpHeight <= 0 then hum.JumpHeight = 7.2 end
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end)
        task.defer(function()
            if hum.Parent and hum.Health > 0 then
                pcall(function()
                    hum.PlatformStand = false
                    hum.Sit = false
                    hum.AutoRotate = true
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end)
            end
        end)
        pcall(function()
            local playerScripts = player:FindFirstChild("PlayerScripts")
            local playerModule = playerScripts and playerScripts:FindFirstChild("PlayerModule")
            local controlModule = playerModule and playerModule:FindFirstChild("ControlModule")
            if controlModule then
                local controls = require(controlModule)
                if controls and controls.Enable then controls:Enable() end
            end
        end)
    end
end

function M.stopBypassAimbot()
    if M.bypassAimbotConn then
        pcall(function() M.bypassAimbotConn:Disconnect() end)
        M.bypassAimbotConn = nil
    end
    M.bypassAimbotEnabled = false
    M._adaptTpBatCooldown = false
    M.updateBatProtection()
    M.restoreCharacterMovement(player.Character)
    M.bypassPrevAutoRotate = nil
    M._adaptTpBatCharacter = nil
    M._adaptTpBatHumanoid = nil
    M._adaptTpBatRoot = nil
    if M.setBypassVisual then M.setBypassVisual(false) end
    if M.mobBtnRefs and M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(false) end
end

function M.toggleBypassAimbot()
    M.bypassAimbotEnabled = not M.bypassAimbotEnabled
    if M.bypassAimbotEnabled then
        M.startBypassAimbot()
    else
        M.stopBypassAimbot()
    end
    if M.setBypassVisual then
        M.setBypassVisual(M.bypassAimbotEnabled)
    end
    if M.mobGuiRef and M.mobBtnRefs.bypass then
        M.mobBtnRefs.bypass(M.bypassAimbotEnabled)
    end
    saveCherryConfig()
    return M.bypassAimbotEnabled
end




function M._batV2Swing()
    if M._batV2SwingCooldown then return end
    M._batV2SwingCooldown = true
    pcall(function()
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local bat = M._bypassFindBat()
        if char and bat then
            if bat.Parent ~= char and hum then pcall(function() hum:EquipTool(bat) end) end
            local remote = bat:FindFirstChildWhichIsA("RemoteEvent")
            if remote then pcall(function() remote:FireServer() end) end
            pcall(function() bat:Activate() end)
        end
    end)
    task.delay(0.08, function() M._batV2SwingCooldown = false end)
end

function M.startBatV2()
    if not M.safeModeTryStart() then return end
    if M.batV2Conn then pcall(function() M.batV2Conn:Disconnect() end); M.batV2Conn = nil end
    if M.autoLeftEnabled then M.autoLeftEnabled=false; if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end; M.stopAutoLeft() end
    if M.autoRightEnabled then M.autoRightEnabled=false; if M.autoRightSetVisual then M.autoRightSetVisual(false) end; M.stopAutoRight() end
    
    M.batV2Enabled = true
    M.updateBatProtection()
    ZBat.on = true
    ZBat.equipped = false
    
    local char0 = player.Character
    local hum0 = char0 and char0:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate = false end
    
    M.batV2Conn = RunService.Heartbeat:Connect(function()
        if not M.batV2Enabled or not ZBat.on then return end
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root or not hum or hum.Health <= 0 then return end
        
        if not ZBat.equipped then
            ZBat.equipped = true
            if not char:FindFirstChildOfClass("Tool") then
                local bat = zFindBat()
                if bat then pcall(function() hum:EquipTool(bat) end) end
            end
        end
        
        local target = zGetTarget()
        if not target then hum.AutoRotate = true; return end
        
        local targetVel = target.AssemblyLinearVelocity
        local aimPos = target.Position + (targetVel * math.clamp(targetVel.Magnitude / 130, 0.05, 0.15)) + Vector3.new(0, ZBat.VertOffset, 0)
        hum.AutoRotate = false
        
        local look = aimPos - root.Position
        local flatLook = Vector3.new(look.X, 0, look.Z)
        if look.Magnitude > 0.01 and flatLook.Magnitude > 0.01 then
            local tYaw = math.deg(math.atan2(-flatLook.X, -flatLook.Z))
            local yawD = (tYaw - root.Orientation.Y + 180) % 360 - 180
            local yawR = math.clamp(math.rad(yawD) * ZBat.TurnSpeed, -ZBat.MaxTurnRate, ZBat.MaxTurnRate)
            root.AssemblyAngularVelocity = Vector3.new(0, yawR, 0)
            
            local dir = flatLook.Unit
            local desired = aimPos + dir * ZBat.Dist + Vector3.new(0, ZBat.Height, 0)
            local to = desired - root.Position
            local hDir = Vector3.new(to.X, 0, to.Z)
            local zSpeed = ZBat.Speed
            local hVel = (hDir.Magnitude > 0.2) and (hDir.Unit * zSpeed) or Vector3.zero
            local vVel = Vector3.new(0, math.clamp(to.Y * 2.5, -ZBat.VertSpeed, ZBat.VertSpeed), 0)
            root.AssemblyLinearVelocity = Vector3.new(hVel.X, vVel.Y, hVel.Z)
            
            if sethiddenproperty then pcall(function() sethiddenproperty(root, "PhysicsRepRootPart", target) end) end
            if hDir.Magnitude > 0.5 then hum:Move(hDir.Unit, false) end
        end
        
        if M.autoSwingEnabled then
            local bat = zFindBat()
            if bat and bat.Parent == char then pcall(function() bat:Activate() end) end
        end
    end)
    if M.setBatV2Visual then M.setBatV2Visual(true) end
    if M.mobBtnRefs and M.mobBtnRefs.batV2 then M.mobBtnRefs.batV2(true) end
end

function M.stopBatV2()
    M.batV2Enabled = false
    M.updateBatProtection()
    if M.batV2Conn then pcall(function() M.batV2Conn:Disconnect() end); M.batV2Conn = nil end
    ZBat.on = false
    M.restoreCharacterMovement(player.Character)
    if M.setBatV2Visual then M.setBatV2Visual(false) end
    if M.mobBtnRefs and M.mobBtnRefs.batV2 then M.mobBtnRefs.batV2(false) end
end



function M._switchMedusaToBat()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local bat = M.findBat and M.findBat() or nil
    if bat and bat.Parent ~= char and hum then pcall(function() hum:EquipTool(bat) end); task.wait(0.08) end
    if bat and bat.Parent == char then pcall(function() bat:Activate() end) end
end
M._autoResetThreatConn = nil
M._autoResetDeathConn = nil
M._autoResetHealthConn = nil
M._autoRespawnBusy = false
function M._forceRespawnAfterDeath()
    if M._autoRespawnBusy then return end
    M._autoRespawnBusy = true
    task.defer(function()
        pcall(function() player:LoadCharacter() end)
        task.delay(2, function() M._autoRespawnBusy = false end)
    end)
end
function M.startAutoResetThreats(char)
    if M._autoResetThreatConn then pcall(function() M._autoResetThreatConn:Disconnect() end) end
    if M._autoResetDeathConn then pcall(function() M._autoResetDeathConn:Disconnect() end) end
    if M._autoResetHealthConn then pcall(function() M._autoResetHealthConn:Disconnect() end) end
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if M.resetOnDeathEnabled then
        M._autoResetHealthConn = hum.HealthChanged:Connect(function(health)
            if health <= 0 then M._forceRespawnAfterDeath() end
        end)
        M._autoResetDeathConn = hum.Died:Connect(function()
            M._forceRespawnAfterDeath()
        end)
    end
    if M.resetOnMedusaEnabled then
        M._autoResetThreatConn = hum.StateChanged:Connect(function(_, state)
            if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
                task.delay(0.12, function()
                    if player.Character == char and M._brainrotEnemyHasWeapon and M._brainrotEnemyHasWeapon("medusa") then
                        M.runInstantReset("medusa")
                    end
                end)
            end
        end)
    end
end


M._medusaWatchConns = {}
M._medusaSwapPending = false
function M._watchMedusaTool(med)
    if not med or not med:IsA("Tool") or M._medusaWatchConns[med] then return end
    local conn
    conn = med.Activated:Connect(function()
        if M._medusaSwapPending then return end
        M._medusaSwapPending = true
        task.spawn(function()
            task.wait(0.18)
            if M.unequipMedusaAfterUse then pcall(function() M.unequipMedusaAfterUse(med) end) end
            task.wait(0.12)
            if M._switchMedusaToBat then M._switchMedusaToBat() end
            M._medusaSwapPending = false
        end)
    end)
    M._medusaWatchConns[med] = conn
    med.AncestryChanged:Connect(function(_, parent)
        if not parent then
            if M._medusaWatchConns[med] then pcall(function() M._medusaWatchConns[med]:Disconnect() end); M._medusaWatchConns[med]=nil end
        end
    end)
end
function M._watchMedusaInCharacter(char)
    local bp = player:FindFirstChildOfClass("Backpack")
    for _, obj in ipairs(bp and bp:GetChildren() or {}) do
        if obj:IsA("Tool") then
            local n=obj.Name:lower()
            if n:find("medusa",1,true) or n:find("stone",1,true) or n:find("head",1,true) then M._watchMedusaTool(obj) end
        end
    end
    if bp and not M._medusaBackpackConn then
        M._medusaBackpackConn = bp.ChildAdded:Connect(function(obj)
            if obj:IsA("Tool") then
                local n=obj.Name:lower()
                if n:find("medusa",1,true) or n:find("stone",1,true) or n:find("head",1,true) then M._watchMedusaTool(obj) end
            end
        end)
    end
    for _, obj in ipairs(char and char:GetChildren() or {}) do
        if obj:IsA("Tool") then
            local n=obj.Name:lower()
            if n:find("medusa",1,true) or n:find("stone",1,true) or n:find("head",1,true) then M._watchMedusaTool(obj) end
        end
    end
    if char then
        char.ChildAdded:Connect(function(obj)
            if obj:IsA("Tool") then
                local n=obj.Name:lower()
                if n:find("medusa",1,true) or n:find("stone",1,true) or n:find("head",1,true) then M._watchMedusaTool(obj) end
            end
        end)
    end
end


M.instantResetBusy = false
M.instantResetRespawnConn = nil
M.instantResetThread = nil
M.instantResetStop = false
M.instantResetCameraConn = nil

local function s1nxyInstaResetFast()
    if M.instantResetBusy then return end
    M.instantResetBusy = true
    M.instantResetStop = false
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not character or not humanoid then M.instantResetBusy = false; return end

    local camera = workspace.CurrentCamera
    local lockedCameraCFrame = camera and camera.CFrame or nil
    local originalHipHeight = humanoid.HipHeight
    local respawning = false
    if M.instantResetCameraConn then pcall(function() M.instantResetCameraConn:Disconnect() end) end
    if camera and lockedCameraCFrame then
        M.instantResetCameraConn = RunService.RenderStepped:Connect(function()
            if M.instantResetBusy and not respawning and camera then camera.CFrame = lockedCameraCFrame end
        end)
    end

    M.instantResetThread = task.spawn(function()
        local attempts, maxAttempts = 0, 40
        while character and character.Parent and humanoid and humanoid.Health > 0 and not respawning and not M.instantResetStop do
            if player.Character ~= character then respawning = true; break end
            pcall(function()
                humanoid.HipHeight = 1e30
                humanoid.AutoRotate = true
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end)
            if not character.Parent or humanoid.Health <= 0 or player.Character ~= character then break end
            attempts += 1
            if attempts >= maxAttempts then break end
            task.wait(0.05)
        end
        if not respawning and not M.instantResetStop and character and character.Parent and humanoid and humanoid.Health > 0 then
            pcall(function() humanoid.Health = 0 end)
            task.wait(0.1)
        end
        if character and character.Parent and humanoid and humanoid.Health > 0 then
            pcall(function()
                humanoid.HipHeight = originalHipHeight
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = (part.Name ~= "HumanoidRootPart") end
                end
            end)
        end
        if M.instantResetCameraConn then pcall(function() M.instantResetCameraConn:Disconnect() end); M.instantResetCameraConn=nil end
        M.instantResetThread=nil
        M.instantResetRespawnConn=nil
        M.instantResetBusy=false
        M.instantResetStop=false
    end)

    if M.instantResetRespawnConn then pcall(function() M.instantResetRespawnConn:Disconnect() end) end
    M.instantResetRespawnConn = player.CharacterAdded:Connect(function()
        respawning = true
        M.instantResetStop = true
        if M.instantResetCameraConn then pcall(function() M.instantResetCameraConn:Disconnect() end); M.instantResetCameraConn=nil end
        M.instantResetRespawnConn=nil
        M.instantResetBusy=false
    end)
end

function M.runInstantReset()
    s1nxyInstaResetFast()
end




function M.doAutoTPDown(force)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum2 = char:FindFirstChildOfClass("Humanoid")
    if not hum2 then return end
    
    if not force then
        if hum2.FloorMaterial ~= Enum.Material.Air then return end
        if not (hrp.Position.Y >= (tonumber(M.autoTPHeight) or 20)) then return end
    end
    local yaw = select(2, hrp.CFrame:ToEulerAnglesYXZ())
    hrp.CFrame = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z) * CFrame.Angles(0, yaw, 0)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    pcall(function() hrp.Velocity = Vector3.zero end)
    pcall(function() hrp.RotVelocity = Vector3.zero end)
end
function M.startAutoTP()
    if M.autoTPConn then task.cancel(M.autoTPConn); M.autoTPConn = nil end
    if not M.autoTPEnabled then return end
    M.autoTPConn = task.spawn(function()
        while M.autoTPEnabled do
            task.wait(0.1)
            pcall(function() M.doAutoTPDown(false) end)
        end
        M.autoTPConn = nil
    end)
end
function M.stopAutoTP()
    M.autoTPEnabled = false
    M._autoTPPauseToken = (M._autoTPPauseToken or 0) + 1
    if M.autoTPConn then task.cancel(M.autoTPConn); M.autoTPConn = nil end
end
function M.runTPFloor()
    
    pcall(function() M.doAutoTPDown(true) end)
end

function M.enableStretchRez()
    M.stretchRezEnabled=true;if M.stretchRezConn then M.stretchRezConn:Disconnect() end
    pcall(function() RunService:UnbindFromRenderStep("Movee_Stretch") end)
    pcall(function() RunService:BindToRenderStep("Movee_Stretch",Enum.RenderPriority.Last.Value-1,function() local cam=workspace.CurrentCamera;if cam then cam.CFrame=cam.CFrame*CFrame.new(0,0,0,1,0,0,0,0.8,0,0,0,1) end end) end)
end

function M.disableStretchRez() M.stretchRezEnabled=false;pcall(function() RunService:UnbindFromRenderStep("Movee_Stretch") end) end

function M._isUnderPlots(obj)
    local p = obj
    while p and p ~= workspace do
        if p.Name == "Plots" then return true end
        p = p.Parent
    end
    return false
end

function M._selectiveNoclipIsProtected(part)
    if not part or not part:IsA("BasePart") then return true end
    if M._isUnderPlots(part) then return true end
    local p = part
    while p and p ~= workspace do
        local n = tostring(p.Name):lower()
        if n:find("base", 1, true) or n:find("plot", 1, true) or n:find("floor", 1, true) or n:find("ground", 1, true) or n:find("baseplate", 1, true) then return true end
        p = p.Parent
    end
    return false
end

function M._selectiveNoclipRestore()
    for part, oldValue in pairs(M._selectiveNoclipChanged) do
        if typeof(part) == "Instance" and part.Parent then
            pcall(function() part.CanCollide = oldValue end)
        end
    end
    table.clear(M._selectiveNoclipChanged)
end

function M.stopSelectiveNoclip()
    M.selectiveNoclipEnabled = false
    if M._selectiveNoclipConn then
        pcall(function() M._selectiveNoclipConn:Disconnect() end)
        M._selectiveNoclipConn = nil
    end
    M._selectiveNoclipRestore()
end

function M.startSelectiveNoclip()
    M.selectiveNoclipEnabled = true
    if M._selectiveNoclipConn then return end
    local acc = 0
    M._selectiveNoclipConn = RunService.Heartbeat:Connect(function(dt)
        if not M.selectiveNoclipEnabled then return end
        acc = acc + (dt or 0)
        if acc < 0.25 then return end
        acc = 0
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and not M._selectiveNoclipIsProtected(part) then
                local char = player.Character
                if not (char and part:IsDescendantOf(char)) then
                    if M._selectiveNoclipChanged[part] == nil then
                        M._selectiveNoclipChanged[part] = part.CanCollide
                    end
                    if part.CanCollide then part.CanCollide = false end
                end
            end
        end
    end)
end

function M.applyAntiLagDerender(obj)
    if not obj then return end
    pcall(function()
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or
               obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
            obj.Enabled = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            local head = obj.Parent and obj.Parent.Name == "Head"
            if not (obj.Name == "face" and head) then
                pcall(function() obj:Destroy() end)
            end
        elseif obj:IsA("SurfaceAppearance") then
            pcall(function() obj:Destroy() end)
        elseif obj:IsA("Highlight") or obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
            
            local parent = obj.Parent
            local inPlayerGui = parent and parent:FindFirstAncestorOfClass("PlayerGui") ~= nil
            if not inPlayerGui then obj.Enabled = false end
        elseif obj:IsA("MeshPart") then
            obj.RenderFidelity = Enum.RenderFidelity.Performance
        elseif obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("brainrot", 1, true) or name:find("animal", 1, true) or
               name:find("carry", 1, true) or name:find("grab", 1, true) or
               name:find("steal", 1, true) or name:find("hold", 1, true) then
                pcall(function() obj:Destroy() end)
            end
        elseif obj:IsA("Animator") and obj.Parent and obj.Parent.Parent ~= player.Character then
            pcall(function() obj:Destroy() end)
        elseif obj:IsA("PostEffect") or obj:IsA("BlurEffect") or obj:IsA("SunRaysEffect") or
               obj:IsA("ColorCorrectionEffect") or obj:IsA("BloomEffect") or
               obj:IsA("DepthOfFieldEffect") or obj:IsA("Atmosphere") or obj:IsA("Clouds") then
            obj.Enabled = false
        end
    end)
end

function M.enableAntiLag()
    if M.antiLagEnabled and M.antiLagDescConn then return end
    M.removeAccessoriesEnabled = true
    M.antiLagEnabled = true

    pcall(function()
        settings().Rendering.QualityLevel = 1
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Disabled
    end)
    pcall(function() Lighting.GlobalShadows = false end)
    pcall(function()
        Lighting.Technology = Enum.Technology.Compatibility
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.ExposureCompensation = 0
    end)
    pcall(function()
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            terrain.Decoration = false
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
            terrain.WaterTransparency = 1
        end
    end)

    for _, effect in ipairs(Lighting:GetDescendants()) do
        pcall(function()
            if effect:IsA("PostEffect") or effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or
               effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or
               effect:IsA("DepthOfFieldEffect") or effect:IsA("Atmosphere") or effect:IsA("Clouds") then
                effect.Enabled = false
            end
        end)
    end

    for _, obj in ipairs(workspace:GetDescendants()) do
        M.applyAntiLagDerender(obj)
    end

    if M.antiLagDescConn then
        pcall(function() M.antiLagDescConn:Disconnect() end)
    end
    M.antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
        if not M.removeAccessoriesEnabled then return end
        if obj:IsA("Terrain") then
            pcall(function()
                obj.Decoration = false
                obj.WaterWaveSize = 0
                obj.WaterWaveSpeed = 0
                obj.WaterReflectance = 0
                obj.WaterTransparency = 1
            end)
        end
        task.defer(function()
            if M.removeAccessoriesEnabled then
                M.applyAntiLagDerender(obj)
            end
        end)
    end)
end

function M.disableAntiLag()
    M.removeAccessoriesEnabled = false
    M.antiLagEnabled = false
    if M.antiLagDescConn then
        pcall(function() M.antiLagDescConn:Disconnect() end)
        M.antiLagDescConn = nil
    end
    pcall(function()
        Lighting.GlobalShadows = true
        for _, effect in ipairs(Lighting:GetDescendants()) do
            pcall(function()
                if effect:IsA("PostEffect") or effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or
                   effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or
                   effect:IsA("DepthOfFieldEffect") or effect:IsA("Atmosphere") or effect:IsA("Clouds") then
                    effect.Enabled = true
                end
            end)
        end
    end)
end





function M._stabilizeFlingRoot(root)
    if not root or not root.Parent then return end
    local velocity
    local ok = pcall(function() velocity = root.AssemblyLinearVelocity end)
    if not ok or typeof(velocity) ~= "Vector3" then
        ok, velocity = pcall(function() return root.Velocity end)
        if not ok or typeof(velocity) ~= "Vector3" then return end
    end
    if velocity.Magnitude <= 80 then return end
    local stabilized = Vector3.new(0, velocity.Y, 0)
    pcall(function() root.AssemblyLinearVelocity = stabilized end)
    pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
    pcall(function() root.Velocity = stabilized end)
    pcall(function() root.RotVelocity = Vector3.zero end)
end

function M.enableAntiFling()
    if M.antiFlingConn then return end
    M.antiFlingEnabled = true
    M.antiFlingConn = RunService.Heartbeat:Connect(function()
        if not M.antiFlingEnabled then return end
        local char = player.Character
        M._stabilizeFlingRoot(char and char:FindFirstChild("HumanoidRootPart"))
    end)
end

function M.disableAntiFling()
    M.antiFlingEnabled = false
    if M.antiFlingConn then
        pcall(function() M.antiFlingConn:Disconnect() end)
        M.antiFlingConn = nil
    end
end

function M.clearSaturatedColors()
    if M.saturatedPulseConn then
        pcall(function() M.saturatedPulseConn:Disconnect() end)
        M.saturatedPulseConn = nil
    end
    for _, fx in ipairs({M.saturatedColorFx, M.saturatedBloomFx, M.saturatedAtmosphereFx, M.saturatedSunRaysFx, M.saturatedDofFx}) do
        if fx then pcall(function() fx:Destroy() end) end
    end
    M.saturatedColorFx = nil
    M.saturatedBloomFx = nil
    M.saturatedAtmosphereFx = nil
    M.saturatedSunRaysFx = nil
    M.saturatedDofFx = nil
end

function M.enableSaturatedColors()
    M.clearSaturatedColors()
    M.saturatedColorsEnabled = true
    local color = Instance.new("ColorCorrectionEffect")
    color.Name = "S1NXYSaturatedColors"
    color.Saturation = 0.6
    color.Contrast = 0.4
    color.Brightness = 0.05
    color.TintColor = Color3.fromRGB(255, 240, 220)
    color.Parent = Lighting
    M.saturatedColorFx = color

    local bloom = Instance.new("BloomEffect")
    bloom.Name = "S1NXYBloom"
    bloom.Intensity = 0.8
    bloom.Size = 24
    bloom.Threshold = 1
    bloom.Parent = Lighting
    M.saturatedBloomFx = bloom

    local atmosphere = Instance.new("Atmosphere")
    atmosphere.Name = "S1NXYAtmosphere"
    atmosphere.Density = 0.3
    atmosphere.Offset = 0.25
    atmosphere.Color = Color3.fromRGB(199, 199, 255)
    atmosphere.Decay = Color3.fromRGB(106, 112, 125)
    atmosphere.Glare = 0.2
    atmosphere.Haze = 1
    atmosphere.Parent = Lighting
    M.saturatedAtmosphereFx = atmosphere

    local sun = Instance.new("SunRaysEffect")
    sun.Name = "S1NXYSunRays"
    sun.Intensity = 0.2
    sun.Spread = 0.8
    sun.Parent = Lighting
    M.saturatedSunRaysFx = sun

    local dof = Instance.new("DepthOfFieldEffect")
    dof.Name = "S1NXYDOF"
    dof.FocusDistance = 25
    dof.InFocusRadius = 10
    dof.NearIntensity = 0.2
    dof.FarIntensity = 0.4
    dof.Parent = Lighting
    M.saturatedDofFx = dof

    M.saturatedPulseConn = RunService.Heartbeat:Connect(function()
        if not M.saturatedColorsEnabled then return end
        if M.saturatedColorFx and M.saturatedColorFx.Parent then
            M.saturatedColorFx.Contrast = 0.35 + math.sin(tick() * 2) * 0.05
        end
    end)
end

function M.disableSaturatedColors()
    M.saturatedColorsEnabled = false
    M.clearSaturatedColors()
end




M.antiRagdollNoSplatterCooldown = 0
M._antiRagdollHumanoid = nil
M._antiRagdollStateBackup = nil

function M._antiRagdollApplyStates(hum)
    if not hum then return end
    if M._antiRagdollHumanoid ~= hum then
        M._antiRagdollHumanoid = hum
        M._antiRagdollStateBackup = {}
        for _, state in ipairs({Enum.HumanoidStateType.Physics, Enum.HumanoidStateType.Ragdoll, Enum.HumanoidStateType.FallingDown}) do
            local ok, enabled = pcall(function() return hum:GetStateEnabled(state) end)
            M._antiRagdollStateBackup[state] = (not ok) or enabled
        end
    end
    pcall(function()
        hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum.PlatformStand = false
        hum.Sit = false
    end)
end

function M._antiRagdollRestoreStates()
    local hum = M._antiRagdollHumanoid
    local backup = M._antiRagdollStateBackup
    if hum and backup then
        pcall(function()
            for _, state in ipairs({Enum.HumanoidStateType.Physics, Enum.HumanoidStateType.Ragdoll, Enum.HumanoidStateType.FallingDown}) do
                hum:SetStateEnabled(state, backup[state] ~= false)
            end
            hum.PlatformStand = false
            hum.Sit = false
            hum.AutoRotate = true
            if hum.Health > 0 then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
        end)
    end
    M._antiRagdollHumanoid = nil
    M._antiRagdollStateBackup = nil
end

function M.forceNoSplatterReset()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end

    
    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        hum:ChangeState(Enum.HumanoidStateType.Running)
        root.Velocity = Vector3.zero
        root.RotVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        root.Anchored = false
        hum.PlatformStand = false
        hum.Sit = false
        hum.AutoRotate = not M.isBatModeActive()
        hum.JumpPower = hum.JumpPower > 0 and hum.JumpPower or 50
        hum.WalkSpeed = hum.WalkSpeed > 0 and hum.WalkSpeed or 16

        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then
                obj.Enabled = true
            elseif obj:IsA("Constraint") then
                obj.Enabled = true
            elseif obj:IsA("BasePart") then
                obj.CanCollide = true
                obj.AssemblyLinearVelocity = Vector3.zero
                obj.AssemblyAngularVelocity = Vector3.zero
            end
        end

        if workspace.CurrentCamera then
            workspace.CurrentCamera.CameraSubject = hum
        end

        local playerScripts = player:FindFirstChild("PlayerScripts")
        local playerModule = playerScripts and playerScripts:FindFirstChild("PlayerModule")
        local controlModule = playerModule and playerModule:FindFirstChild("ControlModule")
        if controlModule then
            local loaded, module = pcall(require, controlModule)
            if loaded and module and module.Enable then module:Enable() end
        end
    end)
end

function M.startAntiRagdoll()
    if M.Conns.antiRag then return end
    M.Conns.antiRag = RunService.Heartbeat:Connect(function()
        if not M.antiRagdollEnabled then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health <= 0 then return end
        M._antiRagdollApplyStates(hum)

        local state = hum:GetState()
        local ragdolled = (state == Enum.HumanoidStateType.Physics or
                          state == Enum.HumanoidStateType.Ragdoll or
                          state == Enum.HumanoidStateType.FallingDown)

        if M.antiRagdollMode == "No Splatter" then
            if ragdolled then
                local now = tick()
                if now - (M.antiRagdollNoSplatterCooldown or 0) > 0.15 then
                    M.antiRagdollNoSplatterCooldown = now
                    M.forceNoSplatterReset()
                end
            end
            return
        end

        if not root then return end
        local endTime = player:GetAttribute("RagdollEndTime")
        if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then
            ragdolled = true
        end
        if ragdolled then
            pcall(function()
                player:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
            end)
            for _, d in ipairs(char:GetDescendants()) do
                if d:IsA("BallSocketConstraint") or
                   (d:IsA("Attachment") and d.Name:find("RagdollAttachment")) then
                    d:Destroy()
                end
            end
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("Motor6D") and obj.Enabled == false then
                    obj.Enabled = true
                end
            end
            if hum.Health > 0 then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
            workspace.CurrentCamera.CameraSubject = hum
            root.Anchored = false
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            hum.PlatformStand = false
            hum.Sit = false
        end
    end)
end

function M.stopAntiRagdoll()
    if M.Conns.antiRag then
        M.Conns.antiRag:Disconnect()
        M.Conns.antiRag = nil
    end
    M._antiRagdollRestoreStates()
    M.restoreCharacterMovement(player.Character)
end




M.jumpHeld = false
M.infJumpThread = nil
M._infJumpBoosting = false
M._infJumpLastBoost = 0
M.INF_JUMP_BOOST_FORCE = 25
M.INF_JUMP_BOOST_FRAMES = 2
M.INF_JUMP_BOOST_COOLDOWN = 0.12

local function M_applyInfJumpBoost(root)
    if not root or M._infJumpBoosting then return end
    local now = tick()
    if now - M._infJumpLastBoost < M.INF_JUMP_BOOST_COOLDOWN then return end
    M._infJumpLastBoost = now
    M._infJumpBoosting = true

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(0, math.huge, 0)
    bv.P = 1250
    bv.Velocity = Vector3.new(root.Velocity.X, M.INF_JUMP_BOOST_FORCE, root.Velocity.Z)
    bv.Parent = root

    local frameCount = 0
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if frameCount < M.INF_JUMP_BOOST_FRAMES then
            frameCount = frameCount + 1
            if bv and bv.Parent then
                bv.Velocity = bv.Velocity + Vector3.new(0, 0.01, 0)
            end
        else
            if bv then pcall(function() bv:Destroy() end) end
            if conn then conn:Disconnect() end
            M._infJumpBoosting = false
        end
    end)
end

task.spawn(function()
    local pg = player:WaitForChild("PlayerGui", 10)
    if pg then
        local function hookJumpButton(btn)
            if btn:IsA("GuiButton") and btn.Name == "JumpButton" and not btn:GetAttribute("InfJumpHooked") then
                btn:SetAttribute("InfJumpHooked", true)
                btn.MouseButton1Down:Connect(function()
                    if M.infJumpEnabled then
                        M.jumpHeld = true
                    end
                end)
                btn.MouseButton1Up:Connect(function() M.jumpHeld = false end)
                btn.MouseLeave:Connect(function() M.jumpHeld = false end)
            end
        end
        for _, d in ipairs(pg:GetDescendants()) do hookJumpButton(d) end
        pg.DescendantAdded:Connect(hookJumpButton)
    end
end)

UIS.JumpRequest:Connect(function()
    if M.infJumpEnabled and M.infJumpMode == "manual" then
        M.jumpHeld = true
        task.delay(0.08, function() M.jumpHeld = false end)
    end
end)

UIS.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if M.infJumpEnabled
        and inp.UserInputType == Enum.UserInputType.Keyboard
        and inp.KeyCode == Enum.KeyCode.Space then
        M.jumpHeld = true
    end
end)

UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == Enum.KeyCode.Space then
        M.jumpHeld = false
    end
end)

function M.startManualInfJumpLoop()
    if M.infJumpThread then M.infJumpThread:Disconnect() end
    M.infJumpThread = RunService.Heartbeat:Connect(function()
        if not M.infJumpEnabled or M.infJumpMode ~= "manual" then return end
        if not M.jumpHeld then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end
        M_applyInfJumpBoost(root)
    end)
end

function M.stopManualInfJumpLoop()
    if M.infJumpThread then
        M.infJumpThread:Disconnect()
        M.infJumpThread = nil
    end
    M.jumpHeld = false
    M._infJumpBoosting = false
end

function M.startHoldInfJump()
    if M.holdInfJumpConn then M.holdInfJumpConn:Disconnect() end
    M.holdInfJumpConn = RunService.Heartbeat:Connect(function()
        if not M.infJumpEnabled or M.infJumpMode ~= "hold" then return end
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local isJumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or M.jumpHeld or (hum.Jump == true)
        local vel = root.AssemblyLinearVelocity
        if isJumpHeld and vel.Y < 35 then
            root.AssemblyLinearVelocity = Vector3.new(vel.X, 55, vel.Z)
        end
        vel = root.AssemblyLinearVelocity
        if vel.Y < -120 then
            root.AssemblyLinearVelocity = Vector3.new(vel.X, -120, vel.Z)
        end
    end)
end

function M.stopHoldInfJump()
    if M.holdInfJumpConn then
        M.holdInfJumpConn:Disconnect()
        M.holdInfJumpConn = nil
    end
end


function M.startUnwalk()
    local c=player.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim=c:FindFirstChild("Animate");if anim then M.unwalkSavedAnimate=anim:Clone();anim:Destroy() end
end

function M.stopUnwalk() local c=player.Character;if c and M.unwalkSavedAnimate then M.unwalkSavedAnimate:Clone().Parent=c;M.unwalkSavedAnimate=nil end end

function M.hasBrainrotInHand()
    local char = player.Character
    if not char then return false end
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") then
            local name = item.Name:lower()
            if name:find("brainrot", 1, true) or name:find("skibidi", 1, true) or name:find("toilet", 1, true) then
                return true
            end
        end
    end
    return false
end

function M._brainrotIsHeld()
    local char = player.Character
    if not char then return false end
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") then
            local n = item.Name:lower()
            if n:find("brainrot", 1, true) or n:find("skibidi", 1, true) or n:find("toilet", 1, true) then
                M._brainrotTrackedTool = item
                return true
            end
        end
    end
    return false
end

function M._brainrotFindTrackedTool()
    local char = player.Character
    local backpack = player:FindFirstChildOfClass("Backpack")
    local tool = M._brainrotTrackedTool
    if tool and (tool.Parent == char or tool.Parent == backpack) then return tool end
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") then
                local n = item.Name:lower()
                if n:find("brainrot", 1, true) or n:find("skibidi", 1, true) or n:find("toilet", 1, true) then
                    M._brainrotTrackedTool = item
                    return item
                end
            end
        end
    end
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                local n = item.Name:lower()
                if n:find("brainrot", 1, true) or n:find("skibidi", 1, true) or n:find("toilet", 1, true) then
                    M._brainrotTrackedTool = item
                    return item
                end
            end
        end
    end
    return nil
end

function M._brainrotEnemyHasWeapon(kind)
    local myChar = player.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return false end
    local words = kind == "bat" and {"bat", "slap", "baseball"} or {"medusa", "stone", "head"}
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= player then
            local char = other.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root and (root.Position - myRoot.Position).Magnitude <= 18 then
                for _, item in ipairs(char:GetChildren()) do
                    if item:IsA("Tool") then
                        local name = item.Name:lower()
                        for _, word in ipairs(words) do
                            if name:find(word, 1, true) then return true end
                        end
                    end
                end
            end
        end
    end
    return false
end

function M._brainrotIsFrozen()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum then return false end

    
    local state = hum:GetState()
    if hum.PlatformStand or state == Enum.HumanoidStateType.Physics
        or state == Enum.HumanoidStateType.Ragdoll
        or state == Enum.HumanoidStateType.FallingDown then
        return true
    end
    if root and root.Anchored then return true end

    
    for _, obj in ipairs({char, hum, root}) do
        if obj then
            for _, attrName in ipairs({"Frozen", "Freeze", "IsFrozen", "Stunned", "Medusa"}) do
                if obj:GetAttribute(attrName) == true then return true end
            end
        end
    end
    return false
end

function M._brainrotAllowRelease(reason)
    
    if reason == "hit" or reason == "medusa" or reason == "drop" then
        M._brainrotReleaseReason = reason
        M._brainrotReleaseWindow = tick() + 1.5
        return true
    end
    return false
end

function M._brainrotResetReleaseIfEmpty()
    if not M._brainrotIsHeld() and tick() > (M._brainrotReleaseWindow or 0) then
        M._brainrotReleaseReason = nil
    end
end

function M.startBrainrotHoldProtection()
    if M._brainrotHoldConn then return end

    
    
    
    M._brainrotRecoverAt = 0
    M._brainrotRecovering = false
    local RECOVER_COOLDOWN = 0.35

    local function isBrainrotTool(item)
        if not item or not item:IsA("Tool") then return false end
        local n = item.Name:lower()
        return n:find("brainrot", 1, true) ~= nil
            or n:find("skibidi", 1, true) ~= nil
            or n:find("toilet", 1, true) ~= nil
    end

    local function recoverTrackedTool(tool, hum, char, backpack)
        if M._brainrotRecovering or tick() < (M._brainrotRecoverAt or 0) then return end
        if M._brainrotReleaseReason ~= nil then return end
        if not tool or not backpack or tool.Parent ~= backpack then return end
        if not hum or hum.Health <= 0 or not char or not char.Parent then return end
        if M._brainrotIsFrozen() then return end

        M._brainrotRecovering = true
        M._brainrotRecoverAt = tick() + RECOVER_COOLDOWN
        task.defer(function()
            if M._brainrotReleaseReason == nil and tool.Parent == backpack and hum.Parent == char and hum.Health > 0 then
                pcall(function() hum:EquipTool(tool) end)
            end
            task.delay(0.12, function()
                M._brainrotRecovering = false
            end)
        end)
    end

    local function bindHealth(char)
        if M._brainrotHealthConn then
            pcall(function() M._brainrotHealthConn:Disconnect() end)
            M._brainrotHealthConn = nil
        end
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        M._brainrotLastHealth = hum.Health
        M._brainrotHealthConn = hum.HealthChanged:Connect(function(newHealth)
            local previous = M._brainrotLastHealth
            M._brainrotLastHealth = newHealth
            
            if previous and (previous - newHealth) > 0.01 and M._brainrotIsHeld() and M._brainrotEnemyHasWeapon("bat") then
                M._brainrotAllowRelease("hit")
            end
        end)
    end

    if player.Character then bindHealth(player.Character) end
    if not M._brainrotCharacterConn then
        M._brainrotCharacterConn = player.CharacterAdded:Connect(function(char)
            task.wait(0.1)
            bindHealth(char)
        end)
    end

    local backpack = player:FindFirstChildOfClass("Backpack")
    if backpack and not M._brainrotBackpackConn then
        M._brainrotBackpackConn = backpack.ChildAdded:Connect(function(item)
            if isBrainrotTool(item) and M._brainrotReleaseReason == nil then
                M._brainrotTrackedTool = item
                task.defer(function()
                    local char = player.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    recoverTrackedTool(item, hum, char, backpack)
                end)
            end
        end)
    end

    M._brainrotHoldConn = RunService.Heartbeat:Connect(function()
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local backpack = player:FindFirstChildOfClass("Backpack")
        local held = M._brainrotIsHeld()
        local tracked = M._brainrotFindTrackedTool()

        
        
        

        
        
        
        if tracked and not held then
            recoverTrackedTool(tracked, hum, char, backpack)
        end

        if not held then
            M._brainrotResetReleaseIfEmpty()
            if M._brainrotReleaseReason ~= nil and tick() > (M._brainrotReleaseWindow or 0) then
                M._brainrotReleaseReason = nil
                M._brainrotTrackedTool = nil
                M.brainrotDetected = false
            end
            return
        end

        
        
        if M._brainrotReleaseReason == nil then
            M.brainrotDetected = true
        end
    end)
end

function M.stopBrainrotHoldProtection()
    if M._brainrotHoldConn then pcall(function() M._brainrotHoldConn:Disconnect() end); M._brainrotHoldConn = nil end
    if M._brainrotHealthConn then pcall(function() M._brainrotHealthConn:Disconnect() end); M._brainrotHealthConn = nil end
    if M._brainrotCharacterConn then pcall(function() M._brainrotCharacterConn:Disconnect() end); M._brainrotCharacterConn = nil end
    if M._brainrotBackpackConn then pcall(function() M._brainrotBackpackConn:Disconnect() end); M._brainrotBackpackConn = nil end
    M._brainrotReleaseReason = nil
    M._brainrotTrackedTool = nil
    M._brainrotRecoverAt = 0
    M._brainrotRecovering = false
end


task.defer(function()
    pcall(function() M.startBrainrotHoldProtection() end)
end)

function M.forceLaggerCarryWhileHolding()
    if not M.hasBrainrotInHand() then return false end
    M.BRAINROT_CARRY_SPEED = 32
    M.CS = 32
    M.LAGGER_CARRY_SPEED = 32
    M.carrySpeedActive = false
    M.laggerModeEnabled = false
    M.laggerCarryActive = true
    return true
end

function M.toggleCarryMode()
    if M.forceLaggerCarryWhileHolding() then
        M.refreshSpeedModeLabel()
        if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
        if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
        if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(true) end
        if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
        if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
        if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry On" end
        saveCherryConfig()
        return
    end
    M.carrySpeedActive = not M.carrySpeedActive
    if M.carrySpeedActive then M.laggerCarryActive = false end
    M.refreshSpeedModeLabel()
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.carryModeBtn then
        M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off"
    end
    if M.laggerCarryBtn then
        M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off"
    end
    saveCherryConfig()
end

function M.toggleLaggerMode()
    if M.forceLaggerCarryWhileHolding() then
        M.refreshSpeedModeLabel()
        if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
        if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(true) end
        if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
        if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry On" end
        saveCherryConfig()
        return
    end
    M.laggerModeEnabled = not M.laggerModeEnabled
    if M.laggerModeEnabled then M.laggerCarryActive = false end
    M.refreshSpeedModeLabel()
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.laggerModeBtn then
        M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off"
    end
    if M.laggerCarryBtn then
        M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off"
    end
    saveCherryConfig()
end

function M.cycleLaggerModeBind()
    if M.forceLaggerCarryWhileHolding() then
        M.refreshSpeedModeLabel()
        if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
        if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
        if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(true) end
        if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
        if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
        if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry On" end
        saveCherryConfig()
        return
    end
    if not M.laggerCarryActive and not M.laggerModeEnabled then
        M.laggerCarryActive = true
        M.laggerModeEnabled = false
        M.carrySpeedActive = false
    elseif M.laggerCarryActive then
        M.laggerCarryActive = false
        M.laggerModeEnabled = true
    else
        M.laggerModeEnabled = false
        M.laggerCarryActive = true
        M.carrySpeedActive = false
    end

    M.refreshSpeedModeLabel()
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.carryModeBtn then M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off" end
    if M.laggerModeBtn then M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off" end
    if M.laggerCarryBtn then M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off" end
    saveCherryConfig()
end

function M.toggleLaggerCarry()
    M.laggerCarryActive = not M.laggerCarryActive
    if M.laggerCarryActive then
        M.laggerModeEnabled = false
        M.carrySpeedActive = false
    end
    M.refreshSpeedModeLabel()
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.laggerModeBtn then
        M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off"
    end
    if M.carryModeBtn then
        M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off"
    end
    if M.laggerCarryBtn then
        M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off"
    end
    saveCherryConfig()
end

function M.stopAutoLeft()
    M.autoLeftEnabled = false
    if M.alConn then M.alConn:Disconnect(); M.alConn = nil end
    M.alPhase = 1
    local char = player.Character
    if char then
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then h:Move(Vector3.zero, false) end
    end
    if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
    if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(false) end
end

function M.stopAutoRight()
    M.autoRightEnabled = false
    if M.arConn then M.arConn:Disconnect(); M.arConn = nil end
    M.arPhase = 1
    local char = player.Character
    if char then
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then h:Move(Vector3.zero, false) end
    end
    if M.autoRightSetVisual then M.autoRightSetVisual(false) end
    if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(false) end
end

function M.startAutoLeft()
    if M.alConn then M.alConn:Disconnect() end
    M.alPhase = 1
    M.autoLeftEnabled = true
    M.alConn = RunService.Heartbeat:Connect(function()
        if not M.autoLeftEnabled then return end
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        local spd = (M.getAutoPathSpeed and M.getAutoPathSpeed()) or (M.NS or 60)
        if M.alPhase == 1 then
            local tgt = Vector3.new(M.AP_L1.X, hrp.Position.Y, M.AP_L1.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                M.alPhase = 2
                local d = M.AP_L2 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z)
                if mv.Magnitude > 0.01 then mv = mv.Unit end
                hum:Move(mv, false)
                hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = M.AP_L1 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.01 then mv = mv.Unit end
            hum:Move(mv, false)
            hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif M.alPhase == 2 then
            local tgt = Vector3.new(M.AP_L2.X, hrp.Position.Y, M.AP_L2.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                hrp.AssemblyLinearVelocity = Vector3.zero
                M.autoLeftEnabled = false
                if M.alConn then M.alConn:Disconnect(); M.alConn = nil end
                M.alPhase = 1
                if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
                if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(false) end
                return
            end
            local d = M.AP_L2 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.01 then mv = mv.Unit end
            hum:Move(mv, false)
            hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
        if M.autoMoveSwingEnabled and not M._alSwingDebounce then
            M._alSwingDebounce = true
            local bat = M.findBat and M.findBat() or (M.findBatForAimbot and M.findBatForAimbot())
            if bat then
                if bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
                pcall(function() bat:Activate() end)
            end
            task.delay(M.autoMoveSwingInterval or 0.3, function() M._alSwingDebounce = false end)
        end
    end)
end

function M.startAutoRight()
    if M.arConn then M.arConn:Disconnect() end
    M.arPhase = 1
    M.autoRightEnabled = true
    M.arConn = RunService.Heartbeat:Connect(function()
        if not M.autoRightEnabled then return end
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        local spd = (M.getAutoPathSpeed and M.getAutoPathSpeed()) or (M.NS or 60)
        if M.arPhase == 1 then
            local tgt = Vector3.new(M.AP_R1.X, hrp.Position.Y, M.AP_R1.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                M.arPhase = 2
                local d = M.AP_R2 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z)
                if mv.Magnitude > 0.01 then mv = mv.Unit end
                hum:Move(mv, false)
                hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = M.AP_R1 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.01 then mv = mv.Unit end
            hum:Move(mv, false)
            hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif M.arPhase == 2 then
            local tgt = Vector3.new(M.AP_R2.X, hrp.Position.Y, M.AP_R2.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                hrp.AssemblyLinearVelocity = Vector3.zero
                M.autoRightEnabled = false
                if M.arConn then M.arConn:Disconnect(); M.arConn = nil end
                M.arPhase = 1
                if M.autoRightSetVisual then M.autoRightSetVisual(false) end
                if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(false) end
                return
            end
            local d = M.AP_R2 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.01 then mv = mv.Unit end
            hum:Move(mv, false)
            hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
        if M.autoMoveSwingEnabled and not M._arSwingDebounce then
            M._arSwingDebounce = true
            local bat = M.findBat and M.findBat() or (M.findBatForAimbot and M.findBatForAimbot())
            if bat then
                if bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
                pcall(function() bat:Activate() end)
            end
            task.delay(M.autoMoveSwingInterval or 0.3, function() M._arSwingDebounce = false end)
        end
    end)
end

function M.enableAntiKick()
    M.antiKickEnabled = true
    M.startBrainrotHoldProtection()
    task.spawn(function()
        while M.antiKickEnabled do
            task.wait(0.5)
            local char = player.Character
            if char then
                local found = false
                for _, tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        local n = tool.Name:lower()
                        if n:find("brainrot") or n:find("skibidi") or n:find("toilet") then
                            found = true
                            break
                        end
                    end
                end
                M.brainrotDetected = found
                if found then
                    if M.autoBatEnabled then M.stopBatAimbot() end
                    if M.autoLeftEnabled then M.autoLeftEnabled=false; if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end; M.stopAutoLeft() end
                    if M.autoRightEnabled then M.autoRightEnabled=false; if M.autoRightSetVisual then M.autoRightSetVisual(false) end; M.stopAutoRight() end
                end
            end
        end
    end)
end

function M.disableAntiKick()
    M.antiKickEnabled = false
    M.brainrotDetected = false
end




function M.safeModeGetCountdownLabel()
    local ok, label = pcall(function()
        local pg = player:FindFirstChild("PlayerGui")
        if not pg then return nil end
        local top = pg:FindFirstChild("DuelsMachineTopFrame")
        if not top then return nil end
        local inner = top:FindFirstChild("DuelsMachineTopFrame")
        if not inner then return nil end
        local timer = inner:FindFirstChild("Timer")
        if not timer then return nil end
        return timer:FindFirstChild("Label")
    end)
    return (ok and label) or nil
end

function M.safeModeCountdownNumber(text)
    local t = tostring(text or ""):upper():gsub("^%s+", ""):gsub("%s+$", "")
    if t == "GO" or t == "START" or t == "READY" then return true end
    local n = tonumber(t)
    return n ~= nil and n >= 0 and n <= 10
end

function M.safeModeInDuelCountdown()
    local label = M.safeModeGetCountdownLabel()
    return label and M.safeModeCountdownNumber(label.Text) or false
end

M.SAFE_MODE_BLOCKED_TOOLS = {
    bat=true, slap=true, sword=true, gun=true, pistol=true, rifle=true,
    medusa=true, hammer=true, axe=true, knife=true, katana=true, blade=true, fist=true,
}

function M.safeModeIsCarryableTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local name = tool.Name:lower()
    for word in pairs(M.SAFE_MODE_BLOCKED_TOOLS) do
        if name:find(word, 1, true) then return false end
    end
    return true
end

function M.safeModeHoldingBrainrot()
    local ok, val = pcall(function() return player:GetAttribute("Stealing") end)
    if ok and val == true then return true end
    local ok2, val2 = pcall(function() return player:GetAttribute("AntiKick") end)
    if ok2 and val2 == true then return true end
    local char = player.Character
    if not char then return false end
    local ok3, val3 = pcall(function() return char:GetAttribute("Stealing") end)
    if ok3 and val3 == true then return true end
    if M.brainrotDetected then return true end
    if M.hasBrainrotInHand and M.hasBrainrotInHand() then return true end
    for _, name in ipairs({"Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab"}) do
        local v = char:FindFirstChild(name, true)
        if v then
            if v:IsA("BoolValue") and v.Value then return true end
            if v:IsA("ObjectValue") and v.Value then return true end
            if v:IsA("StringValue") and v.Value ~= "" then return true end
        end
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
            local n = child.Name:lower()
            if n:find("brainrot") or n:find("animal") or n:find("carry") or n:find("grab") or n:find("steal") or n:find("hold") then
                return true
            end
        end
    end
    return false
end

function M.safeModeIsLocked()
    if not M.safeModeEnabled then return false end
    return M.safeModeInDuelCountdown() or M.safeModeHoldingBrainrot()
end

function M.safeModeForceStop(reason)
    local stopped = false
    if M.autoBatEnabled then
        M.stopBatAimbot()
        stopped = true
    end
    if M.bypassAimbotEnabled then
        M.stopBypassAimbot()
        stopped = true
    end
    if M.batV2Enabled then
        M.stopBatV2()
        stopped = true
    end
    if stopped then
        pcall(function()
            if type(showActionNotification) == "function" then
                showActionNotification(reason or "SAFE MODE LOCK")
            end
        end)
    end
end

function M.safeModeTryStart()
    if M.safeModeIsLocked() then
        M.safeModeForceStop("SAFE MODE LOCK")
        return false
    end
    return true
end

function M.enableSafeMode()
    M.safeModeEnabled = true
end

function M.disableSafeMode()
    M.safeModeEnabled = false
end

if not M._safeModeMonitorStarted then
    M._safeModeMonitorStarted = true
    RunService.Heartbeat:Connect(function()
        if M.safeModeEnabled and M.safeModeIsLocked() then
            M.safeModeForceStop("SAFE MODE LOCK")
        end
    end)
end




function M.mirrorTPAimbotActive()
    return M.autoBatEnabled == true or M.bypassAimbotEnabled == true
end

function M.mirrorTPTeleportDown()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 then return end
    local now = tick()
    if now - (M.mirrorTPLastTeleport or 0) < 0.08 then return end
    M.mirrorTPLastTeleport = now
    local _, yaw = root.CFrame:ToEulerAnglesYXZ()
    local y = (M.MIRROR_TP_DOWN_Y or -7) + (math.random() * 0.6 - 0.3)
    root.CFrame = CFrame.new(root.Position.X, y, root.Position.Z) * CFrame.Angles(0, yaw, 0)
    root.AssemblyLinearVelocity = Vector3.new((math.random()-0.5)*0.4, 0, (math.random()-0.5)*0.4)
end

if not M._mirrorTPStarted then
    M._mirrorTPStarted = true
    RunService.Heartbeat:Connect(function()
        if not M.mirrorTPDownEnabled or not M.mirrorTPAimbotActive() then
            if next(M.mirrorTPPreviousY) then
                table.clear(M.mirrorTPPreviousY)
            end
            return
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local currentY = root.Position.Y
                    local previousY = M.mirrorTPPreviousY[plr.UserId]
                    if previousY and previousY - currentY >= (M.MIRROR_TP_DROP_THRESHOLD or 3) then
                        pcall(M.mirrorTPTeleportDown)
                        table.clear(M.mirrorTPPreviousY)
                        return
                    end
                    M.mirrorTPPreviousY[plr.UserId] = currentY
                end
            end
        end
    end)
end

function M.setMirrorTPDown(enabled)
    M.mirrorTPDownEnabled = enabled == true
    if not M.mirrorTPDownEnabled then
        table.clear(M.mirrorTPPreviousY)
    end
    if M.setMirrorTPVisual then M.setMirrorTPVisual(M.mirrorTPDownEnabled) end
end

function M.isStealState()
    local char = player.Character
    if not char then return false end
    if M.hasBrainrotInHand() then return true end
    local h = char:FindFirstChildOfClass("Humanoid")
    if h and h.WalkSpeed < 25 then return true end
    local ok, val = pcall(function() return player:GetAttribute("Stealing") end)
    if ok and val == true then return true end
    local ok2, val2 = pcall(function() return char:GetAttribute("Stealing") end)
    if ok2 and val2 == true then return true end
    return false
end

function M.getActiveMoveSpeed()
    if M.hasBrainrotInHand and M.hasBrainrotInHand() then
        
        return tonumber(M.NS) or 16
    end
    if M.autoSwitchSpeedEnabled then
        local isSteal = M.isStealState()
        local inLagger = M.laggerModeEnabled or M.laggerCarryActive
        if inLagger then
            return isSteal and M.LAGGER_CARRY_SPEED or M.LAGGER_SPEED
        end
        return isSteal and M.CS or M.NS
    end

    if M.hasBrainrotInHand() then
        return tonumber(M.NS) or 16
    end
    if M.laggerCarryActive then return M.LAGGER_CARRY_SPEED
    elseif M.laggerModeEnabled then return M.LAGGER_SPEED
    elseif M.carrySpeedActive then return M.CS
    else return M.NS end
end

function M.getAutoPathSpeed()
    if M.laggerModeEnabled or M.laggerCarryActive then return M.LAGGER_SPEED
    else return M.NS end
end

function M.setModeNormalFlags()
    M.carrySpeedActive = false
    M.laggerModeEnabled = false
    M.laggerCarryActive = false
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(false) end
    if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
    if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry Off" end
    if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
end

function M.setModeCarryFlags()
    M.carrySpeedActive = true
    M.laggerModeEnabled = false
    M.laggerCarryActive = false
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(true) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(false) end
    if M.carryModeBtn then M.carryModeBtn.Text = "Carry On" end
    if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry Off" end
    if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
end

function M.setModeLaggerCarryFlags()
    M.carrySpeedActive = false
    M.laggerModeEnabled = false
    M.laggerCarryActive = true
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(false) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(true) end
    if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
    if M.laggerModeBtn then M.laggerModeBtn.Text = "Lag Off" end
    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry On" end
    if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
end

function M.stopWalkSpeedAutoSwitch()
    if M._autoSwitchSpeedConn then
        pcall(function() M._autoSwitchSpeedConn:Disconnect() end)
        M._autoSwitchSpeedConn = nil
    end
end

function M.startWalkSpeedAutoSwitch()
    if M._autoSwitchSpeedConn then return end
    M._autoSwitchSpeedConn = RunService.Heartbeat:Connect(function()
        if not M.autoSwitchSpeedEnabled and not M.autoTurnOffSpeedEnabled and not M.autoSwitchLaggerSpeedEnabled then
            M.stopWalkSpeedAutoSwitch()
            return
        end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local ws = hum.WalkSpeed or 16
        local thr = tonumber(M.AUTO_SWITCH_THRESHOLD) or 25

        if M.autoSwitchSpeedEnabled and ws <= thr and not M.carrySpeedActive and not M.laggerCarryActive then
            M.setModeCarryFlags()
        elseif M.autoTurnOffSpeedEnabled and ws > thr and M.carrySpeedActive then
            M.setModeNormalFlags()
        end

        if M.autoSwitchLaggerSpeedEnabled and ws <= thr and not M.laggerCarryActive and not M.laggerModeEnabled then
            M.setModeLaggerCarryFlags()
        elseif M.autoSwitchLaggerSpeedEnabled and ws > thr and (M.laggerCarryActive or M.laggerModeEnabled) then
            M.setModeNormalFlags()
        end
    end)
end

function M.refreshWalkSpeedAutoSwitch()
    if M.autoSwitchSpeedEnabled or M.autoTurnOffSpeedEnabled or M.autoSwitchLaggerSpeedEnabled then
        M.startWalkSpeedAutoSwitch()
    else
        M.stopWalkSpeedAutoSwitch()
    end
end

function M.updateAutoSwitchSpeed()
    if M.autoSwitchSpeedEnabled then
        local isSteal = M.isStealState()
        if isSteal ~= M._autoSwitchWasSteal then
            M._autoSwitchWasSteal = isSteal
            local inLagger = M.laggerModeEnabled or M.laggerCarryActive
            if isSteal then
                if inLagger then
                    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(true) end
                    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
                    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry On" end
                    if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
                else
                    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(true) end
                    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(false) end
                    if M.carryModeBtn then M.carryModeBtn.Text = "Carry On" end
                    if M.laggerCarryBtn then M.laggerCarryBtn.Text = "L.Carry Off" end
                end
            else
                if inLagger then
                    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
                    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
                    if M.laggerCarryBtn then M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off" end
                    if M.laggerModeBtn then M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off" end
                    if M.carryModeBtn then M.carryModeBtn.Text = "Carry Off" end
                else
                    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(false) end
                    if M.carryModeBtn then M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off" end
                end
            end
            if M.refreshSpeedModeLabel then M.refreshSpeedModeLabel() end
        end
    end
end

function M.isRagdollState(hum)
    if not hum then return true end;local st=hum:GetState()
    return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown
end

function M.runDrop()
    if M.dropActive then return end
    
    
    if M._brainrotIsHeld and M._brainrotIsHeld() then
        M._brainrotAllowRelease("drop")
    end
    M.stopAutoTPForAction()
    M._wfConns = M._wfConns or {}
    for _, c in ipairs(M._wfConns) do
        if typeof(c) == "RBXScriptConnection" then pcall(function() c:Disconnect() end) end
    end
    M._wfConns = {}
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not root then return end
    if M.autoBatEnabled then
        M.autoBatEnabled = false
        if M.resetAutoBatMotion then M.resetAutoBatMotion() end
        if M.autoBatSetVisual then M.autoBatSetVisual(false) end
        if M.refreshBatMotionAntiDieGuard then M.refreshBatMotionAntiDieGuard() end
    end
    M.dropActive = true
    local changedCollisions = {}
    local function cleanupDrop()
        M.dropActive = false
        for _, c in ipairs(M._wfConns or {}) do
            if typeof(c) == "RBXScriptConnection" then pcall(function() c:Disconnect() end) end
        end
        M._wfConns = {}
        for part, wasCollide in pairs(changedCollisions) do
            if typeof(part) == "Instance" and part.Parent then pcall(function() part.CanCollide = wasCollide end) end
        end
    end
    local colConn = RunService.Stepped:Connect(function()
        if not M.dropActive then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                for _, part in ipairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if changedCollisions[part] == nil then changedCollisions[part] = part.CanCollide end
                        pcall(function() part.CanCollide = false end)
                    end
                end
            end
        end
    end)
    table.insert(M._wfConns, colConn)
    local flingThread = coroutine.create(function()
        while M.dropActive do
            RunService.Heartbeat:Wait()
            local c = player.Character
            local currentRoot = c and c:FindFirstChild("HumanoidRootPart")
            if not currentRoot then break end
            local vel = currentRoot.Velocity
            pcall(function() currentRoot.Velocity = vel * 10000 + Vector3.new(0, 10000, 0) end)
            RunService.RenderStepped:Wait()
            if currentRoot and currentRoot.Parent then pcall(function() currentRoot.Velocity = vel end) end
            RunService.Stepped:Wait()
            if currentRoot and currentRoot.Parent then pcall(function() currentRoot.Velocity = vel + Vector3.new(0, 0.1, 0) end) end
        end
    end)
    local ok = coroutine.resume(flingThread)
    if not ok then cleanupDrop(); return end
    task.delay(0.16, cleanupDrop)
end

function M.stopAutoTPForAction()
    if not M.autoTPEnabled then return end
    M._autoTPPauseToken = (M._autoTPPauseToken or 0) + 1
    local pauseToken = M._autoTPPauseToken
    if M.autoTPConn then task.cancel(M.autoTPConn); M.autoTPConn = nil end
    task.spawn(function()
        task.wait(0.12)
        while M.autoTPEnabled
            and pauseToken == M._autoTPPauseToken
            and (M.dropActive == true or (M.bypassAimbotEnabled == true and M._bypassTarget ~= nil)) do
            task.wait(0.1)
        end
        if M.autoTPEnabled and pauseToken == M._autoTPPauseToken and not M.autoTPConn then
            M.startAutoTP()
        end
    end)
end

function M.startRemoveAcc()
    if M.removeAccEnabled then return end
    M.removeAccEnabled = true
    local function removeAccDo()
        if not M.removeAccEnabled then return end
        local char = player.Character
        if not char then return end
        for _,obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Accessory") or obj:IsA("Hat") then
                if not M.removedAccessories[obj] then
                    M.removedAccessories[obj] = true
                    pcall(function() obj:Destroy() end)
                end
            end
        end
    end
    removeAccDo()
    M.removeAccConn = player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if M.removeAccEnabled then removeAccDo() end
    end)
end

function M.stopRemoveAcc()
    M.removeAccEnabled = false
    if M.removeAccConn then
        M.removeAccConn:Disconnect()
        M.removeAccConn = nil
    end
    M.removedAccessories = {}
end




local CHERRY_CONFIG_NAME = "CherryConfig.json"
local CherryConfig = { Theme="Red" }
local CHERRY_THEMES = {
    Default  = { Accent=Color3.fromRGB(255,255,255), AccentDim=Color3.fromRGB(180,180,190), Bg=Color3.fromRGB(0,0,0),     Row=Color3.fromRGB(8,8,12) },
    Purple   = { Accent=Color3.fromRGB(207,159,255), AccentDim=Color3.fromRGB(160,120,210), Bg=Color3.fromRGB(8,4,14),    Row=Color3.fromRGB(16,10,24) },
    MetallicPurple = { Accent=Color3.fromRGB(232,52,68), AccentDim=Color3.fromRGB(180,40,50), Bg=Color3.fromRGB(6,4,12), Row=Color3.fromRGB(14,10,22) },
    Blue     = { Accent=Color3.fromRGB(232,52,68),  AccentDim=Color3.fromRGB(40,90,180),   Bg=Color3.fromRGB(4,8,16),    Row=Color3.fromRGB(10,16,28) },
    Red      = { Accent=Color3.fromRGB(232,52,68),   AccentDim=Color3.fromRGB(180,40,50),   Bg=Color3.fromRGB(14,4,6),    Row=Color3.fromRGB(24,10,12) },
    Pink     = { Accent=Color3.fromRGB(255,105,180), AccentDim=Color3.fromRGB(200,80,140),  Bg=Color3.fromRGB(14,6,12),   Row=Color3.fromRGB(24,12,20) },
    Yellow   = { Accent=Color3.fromRGB(255,214,0),   AccentDim=Color3.fromRGB(200,170,0),   Bg=Color3.fromRGB(12,12,4),   Row=Color3.fromRGB(20,18,8) },
    Grey     = { Accent=Color3.fromRGB(180,180,185), AccentDim=Color3.fromRGB(120,120,125), Bg=Color3.fromRGB(10,10,12),  Row=Color3.fromRGB(18,18,20) },
    Forest   = { Accent=Color3.fromRGB(46,200,120),  AccentDim=Color3.fromRGB(30,140,80),   Bg=Color3.fromRGB(4,12,8),    Row=Color3.fromRGB(10,22,14) },
    Cyan     = { Accent=Color3.fromRGB(0,220,255),   AccentDim=Color3.fromRGB(0,160,190),   Bg=Color3.fromRGB(4,12,16),   Row=Color3.fromRGB(8,20,26) },
    Orange   = { Accent=Color3.fromRGB(255,140,40),  AccentDim=Color3.fromRGB(200,100,30),  Bg=Color3.fromRGB(14,8,4),    Row=Color3.fromRGB(24,14,8) },
}
if M._savedTheme and CHERRY_THEMES[M._savedTheme] then
    CherryConfig.Theme = M._savedTheme
end
M.colorScheme = CherryConfig.Theme
M.customBgId = 0
M.customBgOpacity = 0.35
M.BG_IMAGE_IDS = {
    -2, 
    -101, -102, -103, -104, -105, -106, -107, -108,
    -109, -110, -111, -112, -113, -114, -115, -116,
    79737099962715,
    71211662493854,
    15556272558,
    1471587689,
    14349182390,
    108236541541009,
}
M.MOB_BTN_IMAGE_IDS = {
    15101684346,
    39396,
    109592813321691,
    83661129801187,
    94353803110527,
    109100201685955,
}
M.BG_IMAGE_LOCAL_FILES = {
    [-2] = "S1NXY_CustomBackground_Skull.webp",
    [-101] = "S1NXY_MenuBackground_01.jpg",
    [-102] = "S1NXY_MenuBackground_02.jpg",
    [-103] = "S1NXY_MenuBackground_03.jpg",
    [-104] = "S1NXY_MenuBackground_04.jpg",
    [-105] = "S1NXY_MenuBackground_05.jpg",
    [-106] = "S1NXY_MenuBackground_06.jpg",
    [-107] = "S1NXY_MenuBackground_07.jpg",
    [-108] = "S1NXY_MenuBackground_08.jpg",
    [-109] = "S1NXY_MenuBackground_09.jpg",
    [-110] = "S1NXY_MenuBackground_10.jpg",
    [-111] = "S1NXY_MenuBackground_11.jpg",
    [-112] = "S1NXY_MenuBackground_12.jpg",
    [-113] = "S1NXY_MenuBackground_13.jpg",
    [-114] = "S1NXY_MenuBackground_14.jpg",
    [-115] = "S1NXY_MenuBackground_15.jpg",
    [-116] = "S1NXY_MenuBackground_16.jpg",
}
M.BG_IMAGE_LOCAL_URLS = {
    [-2] = "https://files.manuscdn.com/user_upload_by_module/session_file/310519663891813390/lpriVHpffDFEIdpM.webp",
    [-101] = "https://files.manuscdn.com/user_upload_by_module/session_file/310519663903636179/mDLkmFcYPjBZLaZM.JPG",
    [-102] = "https://files.manuscdn.com/user_upload_by_module/session_file/310519663903636179/eyzWsTILwOyfUUut.JPG",
    [-103] = "https://files.manuscdn.com/user_upload_by_module/session_file/310519663903636179/blUFYXqTgPfYHvqO.JPG",
    [-104] = "https://files.manuscdn.com/user_upload_by_module/session_file/310519663903636179/CeneQnGKkEdndIHj.JPG",
    [-105] = "https://files.manuscdn.com/user_upload_by_module/session_file/310519663903636179/DKnHBroKQTmGUfjb.JPG",
    [-106] = "https://files.manuscdn.com/user_upload_by_module/session_file/310519663903636179/StUoBTkrLCuUVrif.JPG",
    [-107] = "https://files.manuscdn.com/user_upload_by_module/session_file/310519663903636179/nKvKuNypOmDTBrNQ.JPG",
    [-108] = "https://files.manuscdn.com/user_upload_by_module/session_file/310519663903636179/SCZKrRZrGPrdHcBI.JPG",
    [-109] = "https://files.manuscdn.com/user_upload_by_module/session_file/310519663903636179/fKxVyxATlMiFrDqw.JPG",
    [-110] = "https://files.manuscdn.com/user_upload_by_module/session_file/310519663903636179/pxNPnIfBffpAdNjD.JPG",
    [-111] = "https://files.manuscdn.com/user_upload_by_module/session_file/310519663903636179/jzCrRUEyDfLOeoyr.JPG",
    [-112] = "https://files.manuscdn.com/user_upload_by_module/session_file/310519663903636179/DuFwVtvGXkcbCiDF.JPG",
    [-113] = "https://files.manuscdn.com/user_upload_by_module/session_file/310519663903636179/kewDaXEGkngvEMmC.JPG",
    [-114] = "https://files.manuscdn.com/user_upload_by_module/session_file/310519663903636179/YNxGOsZrnEqyXxno.JPG",
    [-115] = "https://files.manuscdn.com/user_upload_by_module/session_file/310519663903636179/eywpQHVzHyygBzFf.JPG",
    [-116] = "https://files.manuscdn.com/user_upload_by_module/session_file/310519663903636179/aSCSEHqnrGoPlICc.JPG",
}

local function resolveBackgroundAsset(id)
    id = tonumber(id) or 0
    if id < 0 then
        local localFile = M.BG_IMAGE_LOCAL_FILES[id]
        local remoteUrl = M.BG_IMAGE_LOCAL_URLS[id]
        if not localFile or not remoteUrl then return nil end
        if type(getcustomasset) ~= "function" or type(isfile) ~= "function" then return nil end
        if not isfile(localFile) and type(writefile) == "function" then
            pcall(function()
                local data = game:HttpGet(remoteUrl)
                if data and #data > 0 then writefile(localFile, data) end
            end)
        end
        if not isfile(localFile) then return nil end
        local ok, asset = pcall(getcustomasset, localFile)
        return ok and asset or nil
    end
    return id > 0 and ("rbxassetid://" .. tostring(id)) or ""
end

local function loadCherryConfig()
    if type(readfile)~="function" or type(isfile)~="function" then return end
    local ok,d = pcall(function()
        if not isfile(CHERRY_CONFIG_NAME) then return nil end
        return HS:JSONDecode(readfile(CHERRY_CONFIG_NAME))
    end)
    if ok and type(d)=="table" then
        local themeName = nil
        if type(d.Theme)=="string" and CHERRY_THEMES[d.Theme] then themeName = d.Theme end
        if type(d.colorScheme)=="string" and CHERRY_THEMES[d.colorScheme] then themeName = d.colorScheme end
        if themeName then
            CherryConfig.Theme = themeName
            M.colorScheme = themeName
            M._savedTheme = themeName
        end
        if type(d.normalSpeed)=="number" then M.NS=d.normalSpeed end
        if type(d.carrySpeed)=="number" then M.CS=d.carrySpeed end
        if type(d.laggerSpeed)=="number" then M.LAGGER_SPEED=d.laggerSpeed end
        if type(d.laggerCarrySpeed)=="number" then M.LAGGER_CARRY_SPEED=d.laggerCarrySpeed end
        M.BRAINROT_CARRY_SPEED = 32
        if type(d.speedMethod)=="string" then
            for _,sm in ipairs(M.speedMethodList) do if sm==d.speedMethod then M.speedMethod=sm; break end end
        end
        M.Steal.StealRadius = 63
        if type(d.stealDuration)=="number" then M.Steal.StealDuration=d.stealDuration end
        if type(d.stealStopTime)=="number" then M.Steal.StopTime=d.stealStopTime end
        if type(d.stealMode)=="string" then
            if d.stealMode == "Semi" or d.stealMode == "Normal" or d.stealMode == "V1" or d.stealMode == "V2" or d.stealMode == "V3" then
                M.stealMode=d.stealMode
            end
        end
        if type(d.autoTPHeight)=="number" then M.autoTPHeight=d.autoTPHeight end
        if type(d.fovValue)=="number" then M.fovValue=d.fovValue end
        if type(d.uiScale)=="number" then M.uiScale=math.clamp(d.uiScale, 0.5, 2.0) end
        if type(d.infJumpMode)=="string" then M.infJumpMode=d.infJumpMode end
        if type(d.mobileButtonsSize)=="number" then M.mobileButtonsSize=d.mobileButtonsSize end
        if type(d.skyTheme)=="string" then M.currentSkyTheme=d.skyTheme end
        if type(d.stealBarSize)=="number" then M.stealBarSize=d.stealBarSize end
        if type(d.grabScale)=="number" then M.grabScale=math.clamp(d.grabScale, 0.5, 2.0) end
        if type(d.stealBarColorName)=="string" and M.STEAL_BAR_COLORS[d.stealBarColorName] then
            M.stealBarColorName = d.stealBarColorName
            M.stealBarColor = M.STEAL_BAR_COLORS[d.stealBarColorName]
        end
        if type(d.stealBarBackgroundName)=="string" and M.STEAL_BAR_BACKGROUNDS[d.stealBarBackgroundName] then
            M.stealBarBackgroundName = d.stealBarBackgroundName
        end
        if type(d.stealBarBackgroundColorName)=="string" and M.STEAL_BAR_BACKGROUND_COLORS[d.stealBarBackgroundColorName] then
            M.stealBarBackgroundColorName = d.stealBarBackgroundColorName
        end
        if type(d.stealBarPosition)=="table" then
            local p = d.stealBarPosition
            if type(p.xScale)=="number" and type(p.xOffset)=="number" and type(p.yScale)=="number" and type(p.yOffset)=="number" then
                M.stealBarPosition = {xScale=p.xScale, xOffset=p.xOffset, yScale=p.yScale, yOffset=p.yOffset}
            end
        end
        if d.carrySpeedActive~=nil then M.carrySpeedActive=d.carrySpeedActive end
        if d.laggerModeEnabled~=nil then M.laggerModeEnabled=d.laggerModeEnabled end
        if d.autoSwing~=nil then M.autoSwingEnabled=d.autoSwing==true end
        if d.introSoundEnabled~=nil then M.introSoundEnabled=d.introSoundEnabled==true end
        if d.introSongChoice then M.introSongChoice=d.introSongChoice end
        if d.songChoice then M.songChoice=math.clamp(tonumber(d.songChoice) or 1, 1, #M.SONG_OPTIONS) end
        if d.introGUIEnabled~=nil then M.introGUIEnabled=d.introGUIEnabled==true end
        if d.resetOnDeathEnabled~=nil then M.resetOnDeathEnabled=d.resetOnDeathEnabled==true end
        if d.resetOnMedusaEnabled~=nil then M.resetOnMedusaEnabled=d.resetOnMedusaEnabled==true end
        if d.ragdollGui~=nil then M.ragdollGuiEnabled=d.ragdollGui==true end
        if d.circleButtonsEnabled~=nil then M.circleButtonsEnabled=d.circleButtonsEnabled==true end
        if d.selectiveNoclipEnabled~=nil then M.selectiveNoclipEnabled=d.selectiveNoclipEnabled==true end
        if d.perButtonDrag~=nil then M.perButtonDragEnabled=d.perButtonDrag==true end
        if d.mobileButtonsEnabled~=nil then M.mobileButtonsEnabled=d.mobileButtonsEnabled end
        if d.autoMoveSwing~=nil then M.autoMoveSwingEnabled=d.autoMoveSwing==true end
        if d.autoSwitchSpeed~=nil then M.autoSwitchSpeedEnabled=d.autoSwitchSpeed==true end
        if d.autoTurnOffSpeed~=nil then M.autoTurnOffSpeedEnabled=d.autoTurnOffSpeed==true end
        if d.autoSwitchLaggerSpeed~=nil then M.autoSwitchLaggerSpeedEnabled=d.autoSwitchLaggerSpeed==true end
        if type(d.customFont)=="string" then M.customFontSelected=d.customFont end
        if d.showPlayerSpeeds~=nil then M.showPlayerSpeeds=d.showPlayerSpeeds==true end
        if d.removeAcc~=nil then M.removeAccEnabled=d.removeAcc end
        if d.antiRagdoll~=nil then M.antiRagdollEnabled=d.antiRagdoll end
        if type(d.antiRagdollMode)=="string" and (d.antiRagdollMode=="Splatter" or d.antiRagdollMode=="No Splatter") then M.antiRagdollMode=d.antiRagdollMode end
        if d.autoStealEnabled~=nil then M.Steal.AutoStealEnabled=d.autoStealEnabled end
        if d.autoRadiusEnabled~=nil then M.autoRadiusEnabled=d.autoRadiusEnabled==true end

        if d.infiniteJump~=nil then M.infJumpEnabled=d.infiniteJump end
        if d.medusaCounter~=nil then M.medusaCounterEnabled=d.medusaCounter end
        if d.autoMedusa~=nil then M.autoMedusaEnabled=d.autoMedusa end
        if type(d.autoMedusaRange)=="number" then M.autoMedusaRange=math.clamp(d.autoMedusaRange, 5, 100) end
        if d.batCounter~=nil then M.batCounterEnabled=d.batCounter end
        if d.unwalkEnabled~=nil then M.unwalkEnabled=d.unwalkEnabled end
        if d.antiLag~=nil then M.antiLagEnabled=d.antiLag end
        if d.uiLocked~=nil then M.uiLocked=d.uiLocked==true end
        if d.stretchRez~=nil then M.stretchRezEnabled=d.stretchRez end
        if d.autoTPEnabled~=nil then M.autoTPEnabled=d.autoTPEnabled end
        if d.antiKick~=nil then M.antiKickEnabled=d.antiKick end
        if d.antiFling~=nil then M.antiFlingEnabled=d.antiFling end
        if d.saturatedColors~=nil then
            M.saturatedColorsEnabled = d.saturatedColors == true
        elseif d.SaturatedColorsEnabled~=nil then
            M.saturatedColorsEnabled = d.SaturatedColorsEnabled == true
        end
        if d.safeMode~=nil then M.safeModeEnabled=d.safeMode end
        if d.mirrorTPDown~=nil then M.mirrorTPDownEnabled=d.mirrorTPDown end
        if type(d.customBgId)=="number" then M.customBgId=(d.customBgId == -1) and 0 or d.customBgId end
        if type(d.customBgOpacity)=="number" then M.customBgOpacity=math.clamp(d.customBgOpacity,0,1) end
        if d.autoBat~=nil then M.autoBatEnabled=d.autoBat end
        if d.semiHoldMin then M.Semi.holdMin=d.semiHoldMin end
        if d.semiHoldMax then M.Semi.holdMax=d.semiHoldMax end
        if d.semiEntryDelay then M.Semi.entryDelay=d.semiEntryDelay end
        if d.semiPrimeRange then M.Semi.primeRange=d.semiPrimeRange end
        if type(d.semiRadius)=="number" then M.Semi.radius=math.min(d.semiRadius, 10) end
        if d.lineESPEnabled~=nil then M.lineESPEnabled=d.lineESPEnabled end
        if d.speedESPEnabled~=nil then M.speedESPEnabled=d.speedESPEnabled==true end
        if d.perfectHitEnabled~=nil then M.perfectHitEnabled=d.perfectHitEnabled~=false; M.tpBatSureHitEnabled=M.perfectHitEnabled end
        if d.hardHitEnabled~=nil then M.hardHitEnabled=d.hardHitEnabled==true end
        if type(d.hardHitRadius)=="number" then M.hardHitRadius=d.hardHitRadius end
        if d.antiDieEnabled~=nil then M.antiDieEnabled=d.antiDieEnabled==true end
        if d.espPlayerEnabled~=nil then M.espPlayerEnabled=d.espPlayerEnabled==true end
        if d.hitboxBoxEnabled~=nil then M.hitboxBoxEnabled=d.hitboxBoxEnabled end
        if d.menuOpen~=nil then M.menuOpen=d.menuOpen~=false end
        if type(d.openButtonPosition)=="table" then
            local p = d.openButtonPosition
            if type(p.xScale)=="number" and type(p.xOffset)=="number" and type(p.yScale)=="number" and type(p.yOffset)=="number" then
                M.openButtonPosition = {xScale=p.xScale, xOffset=p.xOffset, yScale=p.yScale, yOffset=p.yOffset}
            end
        end
        if type(d.menuPosition)=="table" then
            local p = d.menuPosition
            if type(p.xScale)=="number" and type(p.xOffset)=="number" and type(p.yScale)=="number" and type(p.yOffset)=="number" then
                M.menuPosition = {xScale=p.xScale, xOffset=p.xOffset, yScale=p.yScale, yOffset=p.yOffset}
            end
        end
        if type(d.Theme)=="string" and CHERRY_THEMES[d.Theme] then M._savedTheme=d.Theme; M.colorScheme=d.Theme end
        if type(d.colorScheme)=="string" and CHERRY_THEMES[d.colorScheme] then M._savedTheme=d.colorScheme; M.colorScheme=d.colorScheme end
        if type(d.animPack)=="string" then M.animPack=d.animPack end
        if d.headlessEnabled~=nil then M.headlessEnabled=d.headlessEnabled end
        if d.korbloxEnabled~=nil then M.korbloxEnabled=d.korbloxEnabled end
        if d.bypassAimbotEnabled~=nil then M.bypassAimbotEnabled=d.bypassAimbotEnabled end
        if d.batV2Enabled~=nil then M.batV2Enabled=d.batV2Enabled end
        if d.animPackEnabled~=nil then M.animPackEnabled=d.animPackEnabled end
        local function lk(e,d2)
            if type(d2)~="table" then return end
            if d2.kb and Enum.KeyCode[d2.kb] then e.kb=Enum.KeyCode[d2.kb] else e.kb=nil end
            if d2.gp and Enum.KeyCode[d2.gp] then e.gp=Enum.KeyCode[d2.gp] else e.gp=nil end
        end
        if d.dropBrainrotKey then lk(M.KB.DropBrainrot,d.dropBrainrotKey) end
        if d.autoLeftKey then lk(M.KB.AutoLeft,d.autoLeftKey) end
        if d.autoRightKey then lk(M.KB.AutoRight,d.autoRightKey) end
        if d.autoBatKey then lk(M.KB.AutoBat,d.autoBatKey) end
        if d.laggerToggleKey then lk(M.KB.LaggerToggle,d.laggerToggleKey) end
        if d.tpFloorKey then lk(M.KB.TPFloor,d.tpFloorKey) end
        if d.guiHideKey then lk(M.KB.GuiHide,d.guiHideKey) end
        if d.speedToggleKey then lk(M.KB.SpeedToggle,d.speedToggleKey) end
        if d.bypassAimbotKey then lk(M.KB.BypassAimbot,d.bypassAimbotKey) end
        if d.batV2Key then lk(M.KB.BatV2,d.batV2Key) end
        if d.autoGrabKey then lk(M.KB.AutoGrab,d.autoGrabKey) end
        if d.autoMedusaKey then lk(M.KB.AutoMedusa,d.autoMedusaKey) end
        if d.espPlayerKey then lk(M.KB.ESPPlayer,d.espPlayerKey) end
        if d.antiAntiKey then lk(M.KB.AntiAnti,d.antiAntiKey) end
    end
end

local function saveCherryConfig()
    if type(writefile)~="function" then return end
    local function ks(e)
        if type(e) ~= "table" then return {kb=nil,gp=nil} end
        return {
            kb = (e.kb and e.kb.Name) or nil,
            gp = (e.gp and e.gp.Name) or nil,
        }
    end
    local cfg = {
        Theme=CherryConfig.Theme, colorScheme=M.colorScheme or CherryConfig.Theme, menuOpen=M.menuOpen~=false,
        openButtonPosition=M.openButtonPosition,
        menuPosition=M.menuPosition,
        normalSpeed=M.NS, carrySpeed=M.CS, laggerSpeed=M.LAGGER_SPEED,
        laggerCarrySpeed=M.LAGGER_CARRY_SPEED, speedMethod=M.speedMethod, grabRadius=M.Steal.StealRadius,
        stealDuration=M.Steal.StealDuration, stealStopTime=M.Steal.StopTime, stealMode=M.stealMode,
        autoTPHeight=M.autoTPHeight, fovValue=M.fovValue, uiScale=M.uiScale,
        infJumpMode=M.infJumpMode,
        mobileButtonsSize=M.mobileButtonsSize, skyTheme=M.currentSkyTheme,
        customBgId=tonumber(M.customBgId) or 0, customBgOpacity=tonumber(M.customBgOpacity) or 0.35,
        stealBarSize=M.stealBarSize,
        grabScale=M.grabScale,
        stealBarColorName=M.stealBarColorName,
        stealBarBackgroundName=M.stealBarBackgroundName,
        stealBarBackgroundColorName=M.stealBarBackgroundColorName,
        stealBarPosition=M.stealBarPosition,
        carrySpeedActive=M.carrySpeedActive, laggerModeEnabled=M.laggerModeEnabled,
        autoSwing=M.autoSwingEnabled, introSoundEnabled=M.introSoundEnabled,
        introSongChoice=M.introSongChoice,
        songChoice=M.songChoice,
        introGUIEnabled=M.introGUIEnabled,
        resetOnDeathEnabled=M.resetOnDeathEnabled == true,
        resetOnMedusaEnabled=M.resetOnMedusaEnabled == true,
        ragdollGui=M.ragdollGuiEnabled, circleButtonsEnabled=M.circleButtonsEnabled,
        selectiveNoclipEnabled=M.selectiveNoclipEnabled,
        perButtonDrag=M.perButtonDragEnabled, mobileButtonsEnabled=M.mobileButtonsEnabled,
        autoMoveSwing=M.autoMoveSwingEnabled,
        autoSwitchSpeed=M.autoSwitchSpeedEnabled, autoTurnOffSpeed=M.autoTurnOffSpeedEnabled, autoSwitchLaggerSpeed=M.autoSwitchLaggerSpeedEnabled, customFont=M.customFontSelected, showPlayerSpeeds=M.showPlayerSpeeds,
        removeAcc=M.removeAccEnabled,
        autoStealEnabled=M.Steal.AutoStealEnabled,
        autoRadiusEnabled=M.autoRadiusEnabled,
        antiRagdoll=M.antiRagdollEnabled, antiRagdollMode=M.antiRagdollMode, infiniteJump=M.infJumpEnabled,
        medusaCounter=M.medusaCounterEnabled, autoMedusa=M.autoMedusaEnabled, autoMedusaRange=M.autoMedusaRange, batCounter=M.batCounterEnabled,
        unwalkEnabled=M.unwalkEnabled, antiLag=M.antiLagEnabled, uiLocked=M.uiLocked,
        stretchRez=M.stretchRezEnabled, autoTPEnabled=M.autoTPEnabled,
        antiKick=M.antiKickEnabled, antiFling=M.antiFlingEnabled,
        saturatedColors=M.saturatedColorsEnabled == true,
        SaturatedColorsEnabled=M.saturatedColorsEnabled == true,
        safeMode=M.safeModeEnabled, mirrorTPDown=M.mirrorTPDownEnabled, autoBat=M.autoBatEnabled,
        espPlayerEnabled=M.espPlayerEnabled == true,
        semiHoldMin=M.Semi.holdMin, semiHoldMax=M.Semi.holdMax,
        semiEntryDelay=M.Semi.entryDelay,
        semiPrimeRange=M.Semi.primeRange,
        semiRadius=math.min(M.Semi.radius, 10),
        lineESPEnabled=M.lineESPEnabled,
        speedESPEnabled=M.speedESPEnabled,
        perfectHitEnabled=M.perfectHitEnabled,
        hardHitEnabled=M.hardHitEnabled, hardHitRadius=M.hardHitRadius,
        antiDieEnabled=M.antiDieEnabled,
        hitboxBoxEnabled=M.hitboxBoxEnabled,
        animPack=M.animPack,
        headlessEnabled=M.headlessEnabled,
        korbloxEnabled=M.korbloxEnabled,
        bypassAimbotEnabled=M.bypassAimbotEnabled,
        batV2Enabled=M.batV2Enabled,
        animPackEnabled=M.animPackEnabled,
        dropBrainrotKey=ks(M.KB.DropBrainrot), autoLeftKey=ks(M.KB.AutoLeft),
        autoRightKey=ks(M.KB.AutoRight), autoBatKey=ks(M.KB.AutoBat),
        laggerToggleKey=ks(M.KB.LaggerToggle), tpFloorKey=ks(M.KB.TPFloor),
        guiHideKey=ks(M.KB.GuiHide),
        speedToggleKey=ks(M.KB.SpeedToggle), bypassAimbotKey=ks(M.KB.BypassAimbot),
        batV2Key=ks(M.KB.BatV2), autoGrabKey=ks(M.KB.AutoGrab), autoMedusaKey=ks(M.KB.AutoMedusa), espPlayerKey=ks(M.KB.ESPPlayer),
        antiAntiKey=ks(M.KB.AntiAnti),
    }
    pcall(function() writefile(CHERRY_CONFIG_NAME, HS:JSONEncode(cfg)) end)
end

M.saveConfig = saveCherryConfig


local AAD_NetworkClient = game:GetService("NetworkClient")
local function aadIsPart(x)
    return x and pcall(function() return x:IsA("BasePart") end) and x:IsA("BasePart")
end
local function aadHiddenSet(instance, property, value)
    local setter = sethiddenproperty or set_hidden_property or sethiddenprop or set_hidden_prop
    if type(setter) == "function" then return pcall(setter, instance, property, value) end
    return pcall(function() instance[property] = value end)
end
local function aadHiddenGet(instance, property)
    local getter = gethiddenproperty or get_hidden_property or gethiddenprop or get_hidden_prop
    if type(getter) == "function" then
        local ok, value = pcall(getter, instance, property)
        if ok then return true, value end
    end
    local ok, value = pcall(function() return instance[property] end)
    return ok, value
end

M._aadHook = M._aadHook or {alive=true, enabled=false, character=nil, rootPart=nil, fakeRoot=nil, repRootOwner=nil, stepConnection=nil, characterConnection=nil, settingsRestore={}}
local aad = M._aadHook
local AAD_FAKE_ROOT_NAME = "S1NXYDesyncRoot"
local AAD_FAKE_ROOT_Y = -2500
local AAD_FAKE_ROOT_VELOCITY = Vector3.new(0, -1000, 0)

local function aadRestoreSettings()
    for _, item in ipairs(aad.settingsRestore or {}) do
        if item.instance and item.instance.Parent then pcall(function() item.instance[item.property] = item.value end) end
    end
    aad.settingsRestore = {}
end
local function aadRememberSetting(instance, property)
    local ok, value = pcall(function() return instance[property] end)
    if ok then table.insert(aad.settingsRestore, {instance=instance, property=property, value=value}) end
end
local function aadPublicSetting(instance, property, value)
    aadRememberSetting(instance, property)
    pcall(function() instance[property] = value end)
end
local function aadDestroyFake()
    local fake = aad.fakeRoot
    aad.fakeRoot = nil
    if fake then pcall(function() fake:Destroy() end) end
end
local function aadRestoreRoot()
    local owner = aad.repRootOwner or aad.rootPart
    if aadIsPart(owner) then aadHiddenSet(owner, "PhysicsRepRootPart", owner) end
    aad.repRootOwner = nil
end
local function aadCurrentRoot(char)
    char = char or player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    return aadIsPart(root) and root or nil
end
local function aadCreateFake(root)
    aadDestroyFake()
    local fake = Instance.new("Part")
    fake.Name = AAD_FAKE_ROOT_NAME
    fake.Size = Vector3.new(2,2,1)
    fake.Anchored = true
    fake.CanCollide = false
    fake.CanTouch = false
    fake.CanQuery = false
    fake.Transparency = 1
    fake.CFrame = CFrame.new(root.Position.X, AAD_FAKE_ROOT_Y, root.Position.Z)
    fake.AssemblyLinearVelocity = AAD_FAKE_ROOT_VELOCITY
    fake.Parent = workspace
    aad.fakeRoot = fake
    return fake
end
local function aadAssignRoot(root, fake)
    if not aadIsPart(root) or not aadIsPart(fake) then return false end
    aadHiddenSet(root, "PhysicsRepRootPart", root)
    aad.repRootOwner = root
    return aadHiddenSet(root, "PhysicsRepRootPart", fake)
end
local function aadStep()
    if not aad.alive or not aad.enabled then return end
    local root = aad.rootPart
    if not aadIsPart(root) then root = aadCurrentRoot(aad.character); aad.rootPart = root end
    if not root then return end
    if not aad.fakeRoot or not aad.fakeRoot.Parent then
        local fake = aadCreateFake(root)
        aadAssignRoot(root, fake)
        return
    end
    local fake = aad.fakeRoot
    local ok, pos = pcall(function() return root.Position end)
    if ok and (math.abs(pos.X-fake.Position.X)>0.01 or math.abs(pos.Z-fake.Position.Z)>0.01 or math.abs(fake.Position.Y-AAD_FAKE_ROOT_Y)>0.01) then
        pcall(function() fake.CFrame = CFrame.new(pos.X, AAD_FAKE_ROOT_Y, pos.Z) end)
    end
    pcall(function() fake.Anchored=true; fake.AssemblyLinearVelocity=AAD_FAKE_ROOT_VELOCITY end)
    local got, current = aadHiddenGet(root, "PhysicsRepRootPart")
    if not got or current ~= fake then aadHiddenSet(root, "PhysicsRepRootPart", fake) end
end
local function aadBindCharacter(char)
    local old = aad.rootPart
    aad.character = char
    aad.rootPart = aadCurrentRoot(char)
    if aad.enabled then
        if aadIsPart(old) and old ~= aad.rootPart then aadHiddenSet(old, "PhysicsRepRootPart", old) end
        aadDestroyFake()
        if aad.rootPart then aadAssignRoot(aad.rootPart, aadCreateFake(aad.rootPart)) end
    end
end

function M.startAntiAntiDesync()
    M.stopAntiAntiDesync()
    aad.alive = true
    aad.enabled = true
    M.aadEnabled = true
    pcall(function() aadHiddenSet(player, "MaximumSimulationRadius", math.huge); aadHiddenSet(player, "SimulationRadius", math.huge) end)
    pcall(function()
        local ns = settings().Network
        aadPublicSetting(ns, "InterpolationThrottling", Enum.InterpolationThrottlingMode.Disabled)
        local ps = settings().Physics
        aadPublicSetting(ps, "PhysicsEnvironmentalThrottle", Enum.EnviromentalPhysicsThrottle.Disabled)
        aadPublicSetting(ps, "AllowSleep", false)
    end)
    pcall(function() AAD_NetworkClient:SetOutgoingKBPSLimit(math.huge) end)
    aadBindCharacter(player.Character)
    if aad.characterConnection then pcall(function() aad.characterConnection:Disconnect() end) end
    aad.characterConnection = player.CharacterAdded:Connect(function(char) task.defer(function() aadBindCharacter(char) end) end)
    if aad.stepConnection then pcall(function() aad.stepConnection:Disconnect() end) end
    aad.stepConnection = RunService.Stepped:Connect(aadStep)
    if M.mobBtnRefs and M.mobBtnRefs.antiAnti then M.mobBtnRefs.antiAnti(true) end
end
function M.stopAntiAntiDesync()
    aad.enabled = false
    M.aadEnabled = false
    if aad.stepConnection then pcall(function() aad.stepConnection:Disconnect() end); aad.stepConnection=nil end
    if aad.characterConnection then pcall(function() aad.characterConnection:Disconnect() end); aad.characterConnection=nil end
    aadRestoreRoot()
    aadDestroyFake()
    aadRestoreSettings()
    if M.mobBtnRefs and M.mobBtnRefs.antiAnti then M.mobBtnRefs.antiAnti(false) end
end
function M.setAntiAntiDesync(on)
    if on then M.startAntiAntiDesync() else M.stopAntiAntiDesync() end
end
function M.toggleAntiAntiDesync()
    M.setAntiAntiDesync(not M.aadEnabled)
end




local RunService2 = game:GetService("RunService")
local cherryESPState = { LineESP=false, SpeedESP=false }
local cherryESPObjects = {}
local cherryLineGui = nil
local DrawingAvailable = false
pcall(function() DrawingAvailable = Drawing and type(Drawing.new)=="function" end)

local function cherryRemoveESP(p)
    local r = cherryESPObjects[p]
    if not r then return end
    for _,o in pairs(r) do pcall(function()
        if typeof(o)=="Instance" then o:Destroy()
        elseif o.Remove then o:Remove() end
    end) end
    cherryESPObjects[p]=nil
end

local function cherryGetSpeed(root)
    local v
    pcall(function() v=root.AssemblyLinearVelocity end)
    if not v then pcall(function() v=root.Velocity end) end
    if not v then return 0 end
    return Vector3.new(v.X,0,v.Z).Magnitude
end

local function cherryCreateESP(p)
    if cherryESPObjects[p] then return cherryESPObjects[p] end
    local r={}
    local hl=Instance.new("Highlight")
    hl.FillTransparency=1; hl.OutlineTransparency=0
    hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
    hl.Enabled=false; hl.Parent=workspace
    r.Highlight=hl

    local hitboxBox=Instance.new("BoxHandleAdornment")
    hitboxBox.Name="EnemyHitboxBox"
    hitboxBox.Size=Vector3.new(4.6, 6.8, 3.6)
    hitboxBox.CFrame=CFrame.new(0, 1.15, 0)
    hitboxBox.Transparency=0.58
    hitboxBox.AlwaysOnTop=true
    hitboxBox.ZIndex=5
    hitboxBox.Visible=false
    hitboxBox.Parent=workspace
    r.HitboxBox=hitboxBox

    local bb=Instance.new("BillboardGui")
    bb.Size=UDim2.fromOffset(220,78); bb.StudsOffset=Vector3.new(0,4.35,0)
    bb.AlwaysOnTop=true; bb.Enabled=false; bb.ResetOnSpawn=false
    bb.Parent=player:WaitForChild("PlayerGui")

    local avatar=Instance.new("ImageLabel",bb)
    avatar.Name="EnemyAvatar"
    avatar.Size=UDim2.fromOffset(42,42)
    avatar.Position=UDim2.new(0.5,-21,0,0)
    avatar.BackgroundColor3=Color3.fromRGB(25,25,30)
    avatar.BorderSizePixel=0
    avatar.ScaleType=Enum.ScaleType.Crop
    avatar.ZIndex=3
    Instance.new("UICorner",avatar).CornerRadius=UDim.new(1,0)
    local avatarStroke=Instance.new("UIStroke",avatar)
    avatarStroke.Name="AvatarStroke"
    avatarStroke.Thickness=2
    avatarStroke.Color=Color3.fromRGB(255,255,255)
    avatarStroke.Transparency=0.15
    task.spawn(function()
        local ok, content = pcall(function()
            return Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)
        if ok and content and avatar.Parent then avatar.Image = content end
    end)

    local nameLabel=Instance.new("TextLabel",bb)
    nameLabel.Name="EnemyName"
    nameLabel.Visible=false
    nameLabel.Size=UDim2.new(1,0,0,24)
    nameLabel.Position=UDim2.new(0,0,0,43)
    nameLabel.BackgroundTransparency=1
    nameLabel.Text="Enemy"
    nameLabel.TextColor3=Color3.fromRGB(255,255,255)
    nameLabel.TextStrokeColor3=Color3.new(0,0,0)
    nameLabel.TextStrokeTransparency=0
    nameLabel.Font=Enum.Font.GothamBlack
    nameLabel.TextSize=15
    nameLabel.TextXAlignment=Enum.TextXAlignment.Center
    nameLabel.TextYAlignment=Enum.TextYAlignment.Center
    nameLabel.TextTruncate=Enum.TextTruncate.AtEnd
    nameLabel.ZIndex=3

    local sl=Instance.new("TextLabel",bb)
    sl.Name="SpeedText"
    sl.Size=UDim2.new(1,0,0,18)
    sl.Position=UDim2.new(0,0,0,62)
    sl.BackgroundTransparency=1; sl.Text="0.0 spd"
    sl.TextStrokeColor3=Color3.new(0,0,0); sl.TextStrokeTransparency=0
    sl.Font=Enum.Font.GothamBlack; sl.TextSize=12
    sl.TextXAlignment=Enum.TextXAlignment.Center; sl.TextYAlignment=Enum.TextYAlignment.Center
    sl.ZIndex=3
    r.Billboard=bb; r.SpeedText=sl; r.NameText=nameLabel; r.Avatar=avatar
    if not cherryLineGui then
        cherryLineGui = Instance.new("ScreenGui")
        cherryLineGui.Name = "S1NXY_ESP_Lines"
        cherryLineGui.ResetOnSpawn = false
        cherryLineGui.IgnoreGuiInset = true
        cherryLineGui.DisplayOrder = 90
        cherryLineGui.Parent = player:WaitForChild("PlayerGui")
    end
    local lineFrame = Instance.new("Frame")
    lineFrame.Name = "EnemyLine"
    lineFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    lineFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    lineFrame.BorderSizePixel = 0
    lineFrame.Size = UDim2.fromOffset(0, 2)
    lineFrame.Visible = false
    lineFrame.ZIndex = 90
    lineFrame.Parent = cherryLineGui
    r.LineFrame = lineFrame
    if DrawingAvailable then
        local ln=Drawing.new("Line")
        ln.Visible=false; ln.Thickness=2.75; ln.Transparency=1
        r.Line=ln
    end
    cherryESPObjects[p]=r
    return r
end

Players.PlayerRemoving:Connect(function(p) cherryRemoveESP(p) end)

local function themeDarkFromAccent(accent, amount)
    amount = math.clamp(tonumber(amount) or 0.12, 0, 1)
    return Color3.new(
        math.clamp(accent.R * amount, 0, 1),
        math.clamp(accent.G * amount, 0, 1),
        math.clamp(accent.B * amount, 0, 1)
    )
end

local function isNearBlack(c, threshold)
    if typeof(c) ~= "Color3" then return false end
    threshold = threshold or 0.14
    return c.R <= threshold and c.G <= threshold and c.B <= threshold
end

local function applyAccentFromTheme()
    local name = "Red" 
    if not CHERRY_THEMES[name] then name = "Red" end
    CherryConfig.Theme = name
    M.colorScheme = name
    M._savedTheme = name
    local t = CHERRY_THEMES[name]
    local accent = t.Accent
    local dim = t.AccentDim or accent:Lerp(Color3.new(0,0,0), 0.35)

    local bg  = Color3.fromRGB(6, 4, 12)
    local row = Color3.fromRGB(14, 10, 22)
    local btn = Color3.fromRGB(0, 0, 0)
    local tog = Color3.fromRGB(20, 14, 30)
    local gradTop = Color3.fromRGB(18, 10, 28)
    local gradBot = Color3.fromRGB(4, 2, 8)

    CHERRY_ACCENT = accent
    UI_ACCENT = accent
    UI_ACCENT_DIM = dim
    UI_BG_DARK = bg
    UI_ROW_BG = row
    UI_BTN_BG = btn
    UI_TOGGLE_OFF = tog
    UI_TOGGLE_KNOB = Color3.fromRGB(200, 200, 210)
    UI_KNOB_ON = Color3.fromRGB(255, 255, 255)
    UI_TEXT_PRIMARY = Color3.fromRGB(255, 255, 255)
    UI_TEXT_WHITE = Color3.fromRGB(255, 255, 255)
    UI_TEXT_DIM = dim:Lerp(Color3.fromRGB(200,200,210), 0.4)
    UI_TEXT_SECTION = accent
    UI_CARD_STROKE = dim
    UI_GRAD_TOP = gradTop
    UI_GRAD_BOT = gradBot

    M.Theme = {
        Name = name,
        Accent = accent,
        AccentDim = dim,
        Bg = bg,
        Row = row,
    }
end

function M.recolorBlacksToTheme(root)
    if not root then return end
    local bg = UI_BG_DARK or Color3.fromRGB(6,4,12)
    local row = UI_ROW_BG or Color3.fromRGB(14,10,22)
    local btn = UI_BTN_BG or Color3.fromRGB(0,0,0)
    local accent = UI_ACCENT or Color3.fromRGB(232,52,68)
    local dim = UI_ACCENT_DIM or accent

    local function recolor(obj)
        if obj:IsA("GuiObject") then
            local ok, col = pcall(function() return obj.BackgroundColor3 end)
            if ok and isNearBlack(col) then
                if obj:IsA("Frame") and (obj.Name == "Main" or obj.Name == "MainFrame" or obj.Size.X.Scale >= 0.9) then
                    obj.BackgroundColor3 = bg
                elseif obj:IsA("TextButton") or obj:IsA("ImageButton") then
                    obj.BackgroundColor3 = btn
                else
                    obj.BackgroundColor3 = row
                end
            end
        end
        if obj:IsA("UIStroke") then
            local ok, col = pcall(function() return obj.Color end)
            if ok and isNearBlack(col, 0.25) then
                obj.Color = dim
            end
        end
        if obj:IsA("UIGradient") then
            pcall(function()
                obj.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, UI_GRAD_TOP or gradTop or row),
                    ColorSequenceKeypoint.new(1, UI_GRAD_BOT or bg),
                })
            end)
        end
    end

    recolor(root)
    for _, d in ipairs(root:GetDescendants()) do
        recolor(d)
    end
end

local CHERRY_ACCENT = CHERRY_THEMES[CherryConfig.Theme].Accent

RunService2.RenderStepped:Connect(function()
    local cam=workspace.CurrentCamera; if not cam then return end
    local lc=player.Character
    local lr=lc and lc:FindFirstChild("HumanoidRootPart")
    local chest=lc and (lc:FindFirstChild("UpperTorso") or lc:FindFirstChild("Torso"))
    local lineStart=Vector2.new(cam.ViewportSize.X*0.5, cam.ViewportSize.Y*0.82)
    if chest or lr then
        local startPart = chest or lr
        local rp,rv=cam:WorldToViewportPoint(startPart.Position)
        if rv and rp.Z>0 then lineStart=Vector2.new(rp.X,rp.Y) end
    end
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=player then
            local r=cherryCreateESP(p)
        local ch=p.Character
        local hum=ch and ch:FindFirstChildOfClass("Humanoid")
        local root=ch and ch:FindFirstChild("HumanoidRootPart")
        local head=ch and ch:FindFirstChild("Head")
        local alive=ch and hum and root and hum.Health>0
        if not alive then
            if r.Line then r.Line.Visible=false end
            if r.LineFrame then r.LineFrame.Visible=false end
            r.Highlight.Enabled=false; r.Billboard.Enabled=false
            r.Highlight.Adornee=nil; r.Billboard.Adornee=nil
            r.HitboxBox.Visible=false; r.HitboxBox.Adornee=nil
        else
            local liveAccent = UI_ACCENT or CHERRY_ACCENT or Color3.fromRGB(232,52,68)
        r.Highlight.Adornee=ch; r.Highlight.Enabled=cherryESPState.LineESP
        r.HitboxBox.Adornee=root
        r.HitboxBox.Color3=Color3.fromRGB(255, 105, 180)
        r.HitboxBox.Visible=cherryESPState.HitboxBox
        r.Highlight.OutlineColor=liveAccent
        r.Highlight.FillColor=liveAccent
        r.Highlight.FillTransparency=0.85
        if r.Line or r.LineFrame then
            local targetPart = head or root
            local tp,tv=cam:WorldToViewportPoint(targetPart.Position)
            if cherryESPState.LineESP and tv and tp.Z>0 then
                local endPoint = Vector2.new(tp.X, tp.Y)
                if r.Line then
                    r.Line.From=lineStart; r.Line.To=endPoint
                    r.Line.Color=liveAccent; r.Line.Thickness=2.75; r.Line.Visible=true
                end
                if r.LineFrame then
                    local delta = endPoint - lineStart
                    local length = delta.Magnitude
                    r.LineFrame.Position = UDim2.fromOffset((lineStart.X + endPoint.X) * 0.5, (lineStart.Y + endPoint.Y) * 0.5)
                    r.LineFrame.Size = UDim2.fromOffset(length, 2.75)
                    r.LineFrame.Rotation = math.deg(math.atan2(delta.Y, delta.X))
                    r.LineFrame.BackgroundColor3 = liveAccent
                    r.LineFrame.Visible = true
                end
            else
                if r.Line then r.Line.Visible=false end
                if r.LineFrame then r.LineFrame.Visible=false end
            end
        end
            if r.Avatar then
                
                r.Avatar.Visible = not (M.espPlayerEnabled == true)
            end
            if cherryESPState.SpeedESP and head then
                r.Billboard.Adornee=head
                r.Billboard.Enabled=true
                r.SpeedText.Text=string.format("%.1f spd", cherryGetSpeed(root))
                r.SpeedText.TextColor3=liveAccent
            else
                r.Billboard.Enabled=false
                r.Billboard.Adornee=nil
            end
        end
        end
    end
end)

function M.trackConn(conn) table.insert(M._persistentConns,conn); return conn end
function M.clearPersistentConns()
    for _,c in ipairs(M._persistentConns) do pcall(function() c:Disconnect() end) end
    M._persistentConns={}
end

function M.makeNumberCallback(tbl,key,min,max)
    return function(v)
        if min and v<min then return end
        if max and v>max then return end
        tbl[key]=v
        if key=="mobileButtonsSize" and M.mobileButtonsEnabled then M.buildMobileButtons() end
        if key=="stealBarSize" then M.buildStatusUI() end
        saveCherryConfig()
    end
end





local UI_ACCENT       = Color3.fromRGB(232, 52, 68)
local UI_ACCENT_DIM   = Color3.fromRGB(180, 40, 50)
local UI_BG_DARK      = Color3.fromRGB(6, 4, 12)
local UI_ROW_BG       = Color3.fromRGB(14, 10, 22)
local UI_CARD_STROKE  = Color3.fromRGB(128, 128, 128)
local UI_TEXT_WHITE   = Color3.fromRGB(255,255,255)
local UI_TEXT_PRIMARY = Color3.fromRGB(255, 255, 255)
local UI_TEXT_DIM     = Color3.fromRGB(125,125,125)
local UI_TEXT_SECTION = Color3.fromRGB(232,52,68)
local UI_BTN_BG       = Color3.fromRGB(0,0,0)
local UI_TOGGLE_OFF   = Color3.fromRGB(20,14,30)
local UI_TOGGLE_KNOB  = Color3.fromRGB(128, 128, 128)
local UI_KNOB_ON      = Color3.fromRGB(255, 255, 255)
local UI_GRAD_TOP     = Color3.fromRGB(18,10,28)
local UI_GRAD_BOT     = Color3.fromRGB(4,2,8)

pcall(applyAccentFromTheme)

local UI_TWEEN_FAST = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local UI_TWEEN_MED  = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)


local function uiCardStyle(f)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,12); c.Parent = f
    local s = Instance.new("UIStroke"); s.Thickness = 1; s.Color = UI_CARD_STROKE or Color3.fromRGB(45, 45, 45); s.Transparency = 0.45; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = f
    local g = Instance.new("UIGradient"); g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, UI_GRAD_TOP or Color3.fromRGB(18,10,28)),
        ColorSequenceKeypoint.new(1, UI_GRAD_BOT or Color3.fromRGB(4,2,8))
    }); g.Rotation = 45; g.Parent = f
end

local function uiSmallBtn(p)
    local b = Instance.new("TextButton")
    b.Position = p.Pos or UDim2.new(0,0,0,0); b.Size = p.Size or UDim2.new(0,46,0,28)
    b.BackgroundColor3 = p.Bg or UI_BTN_BG; b.BorderSizePixel = 0
    b.Text = p.Text or ""; b.TextColor3 = p.Col or UI_TEXT_DIM; b.TextSize = p.TS or 13
    b.Font = Enum.Font.GothamBold; b.AutoButtonColor = false; b.ZIndex = p.Z or 1; b.Parent = p.Parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,p.CR or 6); c.Parent = b
    return b
end

local function uiAccentBar(parent, on)
    local b = Instance.new("Frame")
    b.Position = UDim2.new(0,0,0.5,-11); b.Size = UDim2.new(0,3,0,22)
    b.BackgroundColor3 = on and UI_ACCENT or UI_TEXT_WHITE
    b.BackgroundTransparency = on and 0 or 1; b.BorderSizePixel = 0; b.Parent = parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,2); c.Parent = b
    return b
end

local function uiAutoCanvas(scroll)
    local lay = scroll:FindFirstChildOfClass("UIListLayout"); if not lay then return end
    local pad = scroll:FindFirstChildOfClass("UIPadding")
    local function upd()
        local padBottom = (pad and pad.PaddingBottom.Offset or 0)
        local padTop = (pad and pad.PaddingTop.Offset or 0)
        local h = lay.AbsoluteContentSize.Y + padBottom + padTop + 24
        scroll.CanvasSize = UDim2.new(0, 0, 0, math.max(h, 1))
    end
    lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(upd)
    task.defer(upd)
    task.delay(0.15, upd)
    task.delay(0.5, upd)
end

local function uiSectionHeader(parent, text)
    local r = Instance.new("Frame"); r.Size = UDim2.new(1,0,0,40); r.BackgroundTransparency = 1; r.Parent = parent
    local b = Instance.new("Frame"); b.Position = UDim2.new(0,0,0.5,-6); b.Size = UDim2.new(0,3,0,13)
    b.BackgroundColor3 = UI_ACCENT; b.BorderSizePixel = 0; b.Parent = r
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,2)
    local l = Instance.new("TextLabel"); l.Position = UDim2.new(0,12,0,0); l.Size = UDim2.new(1,-12,1,0)
    l.BackgroundTransparency = 1; l.Text = text; l.TextColor3 = UI_TEXT_SECTION; l.TextSize = 17
    l.Font = Enum.Font.GothamBold; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = r
    return r
end

local function uiInputRow(parent, label, def, hidden)
    local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1,0,0,52)
    r.BackgroundColor3 = UI_ROW_BG; r.BackgroundTransparency = 0.1; r.BorderSizePixel = 0
    if hidden then r.Visible = false end; r.Parent = parent; uiCardStyle(r)
    local l = Instance.new("TextLabel"); l.Position = UDim2.new(0,16,0,0); l.Size = UDim2.new(1,-92,1,0)
    l.BackgroundTransparency = 1; l.Text = label; l.TextColor3 = UI_TEXT_PRIMARY; l.TextSize = 15
    l.Font = Enum.Font.GothamMedium; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = r
    local bx = Instance.new("TextBox"); bx.Position = UDim2.new(1,-72,0.5,-15); bx.Size = UDim2.new(0,62,0,30)
    bx.BackgroundColor3 = UI_BTN_BG; bx.BorderSizePixel = 0; bx.Text = tostring(def); bx.TextColor3 = UI_ACCENT
    bx.TextSize = 15; bx.Font = Enum.Font.GothamBold; bx.Parent = r
    Instance.new("UICorner",bx).CornerRadius = UDim.new(0,6)
    return r, bx
end

local function uiToggleRow(parent, label, on, callback)
    local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1,0,0,54)
    r.BackgroundColor3 = UI_ROW_BG; r.BackgroundTransparency = 0.1; r.BorderSizePixel = 0; r.Parent = parent; uiCardStyle(r)
    local bar = uiAccentBar(r, on)
    local l = Instance.new("TextLabel"); l.Position = UDim2.new(0,12,0,0); l.Size = UDim2.new(1,-62,1,0)
    l.BackgroundTransparency = 1; l.Text = label; l.TextColor3 = UI_TEXT_PRIMARY; l.TextSize = 15
    l.Font = Enum.Font.GothamMedium; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = r

    local tb = Instance.new("TextButton"); tb.Position = UDim2.new(1,-62,0.5,-12); tb.Size = UDim2.new(0,48,0,24)
    tb.BackgroundColor3 = on and UI_ACCENT or UI_TOGGLE_OFF; tb.BorderSizePixel = 0; tb.Text = ""; tb.AutoButtonColor = false; tb.Parent = r
    Instance.new("UICorner",tb).CornerRadius = UDim.new(0,12)
    local knob = Instance.new("Frame"); knob.Size = UDim2.new(0,18,0,18); knob.BorderSizePixel = 0
    knob.Position = on and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
    knob.BackgroundColor3 = on and UI_KNOB_ON or UI_TOGGLE_KNOB; knob.Parent = tb
    Instance.new("UICorner",knob)

    local state = on
    local function set(v)
        state = v
        TweenService:Create(tb, UI_TWEEN_FAST, {BackgroundColor3 = v and UI_ACCENT or UI_TOGGLE_OFF}):Play()
        TweenService:Create(knob, UI_TWEEN_FAST, {Position = v and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9), BackgroundColor3 = v and UI_KNOB_ON or UI_TOGGLE_KNOB}):Play()
        TweenService:Create(bar, UI_TWEEN_FAST, {BackgroundTransparency = v and 0 or 1}):Play()
        bar.BackgroundColor3 = UI_ACCENT
    end
    tb.MouseButton1Click:Connect(function()
        set(not state)
        if callback then callback(state) end
        saveCherryConfig()
    end)
    return r, set
end

local function uiActionRow(parent, label, callback)
    local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1,0,0,56)
    r.BackgroundColor3 = UI_ROW_BG; r.BackgroundTransparency = 0.1; r.BorderSizePixel = 0; r.Parent = parent; uiCardStyle(r)
    local btn = Instance.new("TextButton"); btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1
    btn.Text = label; btn.TextColor3 = UI_TEXT_PRIMARY; btn.TextSize = 15; btn.Font = Enum.Font.GothamBold; btn.Parent = r
    local bar = uiAccentBar(r, false)

    btn.MouseButton1Click:Connect(function()
        bar.BackgroundColor3 = UI_ACCENT
        TweenService:Create(bar, UI_TWEEN_FAST, {BackgroundTransparency = 0}):Play()
        task.delay(0.3, function() TweenService:Create(bar, UI_TWEEN_FAST, {BackgroundTransparency = 1}):Play() end)
        if callback then callback() end
    end)
    return r, btn
end

local function uiNumberRow(parent, label, value, minV, maxV, callback)
    local r, bx = uiInputRow(parent, label, value)
    bx.FocusLost:Connect(function()
        local n = tonumber(bx.Text)
        if n and n >= minV and n <= maxV then
            if callback then callback(n) end
            saveCherryConfig()
        else
            bx.Text = tostring(value)
        end
    end)
    return r, bx
end

local function uiChoiceRow(parent, label, options, defaultIndex, callback)
    local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1,0,0,62)
    r.BackgroundColor3 = UI_ROW_BG; r.BackgroundTransparency = 0.1; r.BorderSizePixel = 0; r.Parent = parent; uiCardStyle(r)
    local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,16,0,0); l.Size=UDim2.new(0.43,0,0,62); l.BackgroundTransparency=1
    l.Text=label; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=17; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
    local la = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-174,0,8), Size=UDim2.new(0,34,0,32), Text="<", Col=UI_TEXT_PRIMARY, TS=13, CR=7})
    local vl = Instance.new("TextLabel"); vl.Position=UDim2.new(1,-141,0,8); vl.Size=UDim2.new(0,112,0,32)
    vl.BackgroundColor3=UI_BTN_BG; vl.BorderSizePixel=0; vl.Text=options[defaultIndex or 1]; vl.TextColor3=UI_TEXT_PRIMARY; vl.TextSize=15; vl.Font=Enum.Font.GothamBold; vl.Parent=r
    Instance.new("UICorner",vl).CornerRadius=UDim.new(0,7)
    local ra = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-35,0,8), Size=UDim2.new(0,34,0,32), Text=">", Col=UI_TEXT_PRIMARY, TS=13, CR=7})
    local idx = defaultIndex or 1
    local function upd()
        vl.Text = options[idx]
        if callback then callback(options[idx]) end
        saveCherryConfig()
    end
    la.MouseButton1Click:Connect(function() idx=idx-1; if idx<1 then idx=#options end; upd() end)
    ra.MouseButton1Click:Connect(function() idx=idx+1; if idx>#options then idx=1 end; upd() end)
    local function setVal(v)
        for i,o in ipairs(options) do if o==v then idx=i; vl.Text=o; break end end
    end
    return r, setVal
end

local ARROW_GLOW_TRANSPARENCY = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.82, 0),
    NumberSequenceKeypoint.new(0.28, 0.06, 0),
    NumberSequenceKeypoint.new(0.52, 0.22, 0),
    NumberSequenceKeypoint.new(1, 0.82, 0),
})

local function styleArrowButton(arrow)
    local border = Instance.new("UIStroke")
    border.Name = "AnimatedArrowBorder"
    border.Color = Color3.fromRGB(255, 255, 255)
    border.Thickness = 1.8
    border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    border.Transparency = 0.05
    border.Parent = arrow
    local bg = Instance.new("UIGradient")
    bg.Rotation = 135
    bg.Transparency = ARROW_GLOW_TRANSPARENCY
    bg.Parent = border

    local glow = Instance.new("UIStroke")
    glow.Name = "AnimatedArrowGlow"
    glow.Color = Color3.fromRGB(255, 255, 255)
    glow.Thickness = 3.6
    glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    glow.Transparency = 0.58
    glow.Parent = arrow
    local gg = Instance.new("UIGradient")
    gg.Name = "GlowGradient"
    gg.Rotation = 180
    gg.Transparency = ARROW_GLOW_TRANSPARENCY
    gg.Parent = glow
end

local function styleOptionChip(btn, active)
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundColor3 = active and UI_ACCENT or Color3.fromRGB(220, 220, 225)
    local stroke = btn:FindFirstChildOfClass("UIStroke")
    if not stroke then
        stroke = Instance.new("UIStroke")
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = btn
    end
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = active and 2 or 1.4
    stroke.Transparency = 0
    btn.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextStrokeTransparency = 0
end

local function uiExpandToggleRow(parent, label, on, options, defaultIndex, onToggle, onOption)
    local container = Instance.new("Frame")
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 64)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.ClipsDescendants = false
    container.Parent = parent

    local col = Instance.new("UIListLayout")
    col.FillDirection = Enum.FillDirection.Vertical
    col.SortOrder = Enum.SortOrder.LayoutOrder
    col.Padding = UDim.new(0, 6)
    col.Parent = container

    local r = Instance.new("Frame")
    r.LayoutOrder = 1
    r.ClipsDescendants = true
    r.Size = UDim2.new(1, 0, 0, 64)
    r.BackgroundColor3 = UI_ROW_BG
    r.BackgroundTransparency = 0.1
    r.BorderSizePixel = 0
    r.Parent = container
    uiCardStyle(r)

    local bar = uiAccentBar(r, on)
    local l = Instance.new("TextLabel")
    l.Position = UDim2.new(0, 16, 0, 0)
    l.Size = UDim2.new(1, -118, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = label
    l.TextColor3 = UI_TEXT_PRIMARY
    l.TextSize = 17
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = r

    local expanded = false
    local arrow = Instance.new("TextButton")
    arrow.Name = "ArrowButton"
    arrow.Position = UDim2.new(1, -116, 0.5, -17)
    arrow.Size = UDim2.new(0, 48, 0, 34)
    arrow.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
    arrow.BackgroundTransparency = 0.1
    arrow.BorderSizePixel = 0
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(255, 255, 255)
    arrow.TextSize = 18
    arrow.Font = Enum.Font.GothamBlack
    arrow.AutoButtonColor = false
    arrow.Parent = r
    Instance.new("UICorner", arrow).CornerRadius = UDim.new(0, 7)
    styleArrowButton(arrow)

    local tb = Instance.new("TextButton")
    tb.Position = UDim2.new(1, -68, 0.5, -15)
    tb.Size = UDim2.new(0, 58, 0, 30)
    tb.BackgroundColor3 = on and UI_ACCENT or UI_TOGGLE_OFF
    tb.BorderSizePixel = 0
    tb.Text = ""
    tb.AutoButtonColor = false
    tb.Parent = r
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 11)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 19, 0, 19)
    knob.BorderSizePixel = 0
    knob.Position = on and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = on and UI_KNOB_ON or UI_TOGGLE_KNOB
    knob.Parent = tb
    Instance.new("UICorner", knob)

    local useScroll = #options > 4
    local optFrame = Instance.new("Frame")
    optFrame.LayoutOrder = 2
    optFrame.Size = UDim2.new(1, 0, 0, useScroll and 140 or 40)
    optFrame.BackgroundColor3 = UI_ROW_BG
    optFrame.BackgroundTransparency = 0.12
    optFrame.BorderSizePixel = 0
    optFrame.Visible = false
    optFrame.ClipsDescendants = true
    optFrame.Parent = container
    uiCardStyle(optFrame)

    local optPad = Instance.new("UIPadding")
    optPad.PaddingLeft = UDim.new(0, 8)
    optPad.PaddingRight = UDim.new(0, 8)
    optPad.PaddingTop = UDim.new(0, 6)
    optPad.PaddingBottom = UDim.new(0, 6)
    optPad.Parent = optFrame

    local optParent = optFrame
    if useScroll then
        local scroll = Instance.new("ScrollingFrame")
        scroll.Name = "OptionsScroll"
        scroll.Size = UDim2.new(1, -4, 1, -4)
        scroll.Position = UDim2.new(0, 2, 0, 2)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 5
        scroll.ScrollBarImageColor3 = UI_ACCENT
        scroll.ScrollingDirection = Enum.ScrollingDirection.Y
        scroll.ElasticBehavior = Enum.ElasticBehavior.Always
        scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.Parent = optFrame
        local sPad = Instance.new("UIPadding")
        sPad.PaddingLeft = UDim.new(0, 6)
        sPad.PaddingRight = UDim.new(0, 8)
        sPad.PaddingTop = UDim.new(0, 4)
        sPad.PaddingBottom = UDim.new(0, 8)
        sPad.Parent = scroll
        local sLay = Instance.new("UIListLayout")
        sLay.FillDirection = Enum.FillDirection.Vertical
        sLay.Padding = UDim.new(0, 5)
        sLay.SortOrder = Enum.SortOrder.LayoutOrder
        sLay.Parent = scroll
        optParent = scroll
    else
        local optLayout = Instance.new("UIListLayout")
        optLayout.FillDirection = Enum.FillDirection.Horizontal
        optLayout.Padding = UDim.new(0, 6)
        optLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        optLayout.SortOrder = Enum.SortOrder.LayoutOrder
        optLayout.Parent = optFrame
    end

    local settingsHost = Instance.new("Frame")
    settingsHost.Name = "ModeSettings"
    settingsHost.LayoutOrder = 3
    settingsHost.Size = UDim2.new(1, 0, 0, 0)
    settingsHost.AutomaticSize = Enum.AutomaticSize.Y
    settingsHost.BackgroundTransparency = 1
    settingsHost.Visible = false
    settingsHost.Parent = container

    local settingsLayout = Instance.new("UIListLayout")
    settingsLayout.Padding = UDim.new(0, 6)
    settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    settingsLayout.Parent = settingsHost

    local idx = defaultIndex or 1
    local optionBtns = {}
    local state = on
    local modeSettings = {}

    local function refreshOptionVisuals()
        for i, b in ipairs(optionBtns) do
            styleOptionChip(b, i == idx)
        end
    end

    local function refreshModeSettings()
        local any = false
        for lab, fr in pairs(modeSettings) do
            local show = expanded and (lab == options[idx])
            fr.Visible = show
            if show then any = true end
        end
        settingsHost.Visible = any
    end

    for i, opt in ipairs(options) do
        local b = Instance.new("TextButton")
        b.LayoutOrder = i
        if useScroll then
            b.Size = UDim2.new(1, -4, 0, 36)
        else
            b.Size = UDim2.new(0, math.max(64, #tostring(opt) * 10 + 22), 0, 34)
        end
        b.BorderSizePixel = 0
        b.Text = tostring(opt)
        b.TextSize = useScroll and 16 or 16
        b.Font = Enum.Font.GothamBlack
        b.TextXAlignment = useScroll and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center
        b.AutoButtonColor = false
        b.Parent = optParent
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
        if useScroll then
            local p = Instance.new("UIPadding")
            p.PaddingLeft = UDim.new(0, 10)
            p.Parent = b
        end
        styleOptionChip(b, i == idx)
        b.MouseButton1Click:Connect(function()
            idx = i
            refreshOptionVisuals()
            refreshModeSettings()
            if onOption then onOption(options[idx]) end
            saveCherryConfig()
        end)
        optionBtns[i] = b
    end

    local function setExpanded(v)
        expanded = v
        optFrame.Visible = v
        arrow.Text = v and "▲" or "▼"
        refreshModeSettings()
    end

    arrow.MouseButton1Click:Connect(function()
        setExpanded(not expanded)
    end)

    local function set(v)
        state = v
        TweenService:Create(tb, UI_TWEEN_FAST, {BackgroundColor3 = v and UI_ACCENT or UI_TOGGLE_OFF}):Play()
        TweenService:Create(knob, UI_TWEEN_FAST, {
            Position = v and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
            BackgroundColor3 = v and UI_KNOB_ON or UI_TOGGLE_KNOB
        }):Play()
        TweenService:Create(bar, UI_TWEEN_FAST, {BackgroundTransparency = v and 0 or 1}):Play()
        bar.BackgroundColor3 = UI_ACCENT
    end

    tb.MouseButton1Click:Connect(function()
        set(not state)
        if onToggle then onToggle(state) end
        saveCherryConfig()
    end)

    local function setOption(v)
        for i, o in ipairs(options) do
            if o == v then
                idx = i
                refreshOptionVisuals()
                refreshModeSettings()
                break
            end
        end
    end

    local function registerModeSettings(optionLabel, frame)
        frame.Parent = settingsHost
        frame.Visible = false
        frame.Size = UDim2.new(1, 0, 0, 0)
        frame.AutomaticSize = Enum.AutomaticSize.Y
        modeSettings[optionLabel] = frame
        task.defer(refreshModeSettings)
    end

    return container, set, setOption, registerModeSettings, function() return options[idx] end
end

local function uiMakePage(parent, name, order, vis)
    local p = Instance.new("ScrollingFrame"); p.Name=name; p.Visible=vis~=false; p.LayoutOrder=order
    p.Size=UDim2.new(1,0,1,0); p.BackgroundTransparency=1; p.BorderSizePixel=0
    p.ScrollBarThickness=8
    p.ScrollBarImageColor3=UI_ACCENT
    p.ScrollBarImageTransparency=0.15
    p.ScrollingEnabled=true
    p.ScrollingDirection=Enum.ScrollingDirection.Y
    p.ElasticBehavior=Enum.ElasticBehavior.Always
    p.AutomaticCanvasSize=Enum.AutomaticSize.Y
    p.CanvasSize=UDim2.new(0,0,0,0)
    p.Parent=parent
    local l = Instance.new("UIListLayout"); l.Padding=UDim.new(0,7); l.SortOrder=Enum.SortOrder.LayoutOrder; l.Parent=p
    local pd = Instance.new("UIPadding")
    pd.PaddingTop=UDim.new(0,4)
    pd.PaddingBottom=UDim.new(0,40)
    pd.PaddingRight=UDim.new(0,6)
    pd.PaddingLeft=UDim.new(0,2)
    pd.Parent=p
    uiAutoCanvas(p)
    return p
end

local function uiMakeTab(parent, name, text, pos, active)
    local b = Instance.new("TextButton"); b.Name=name; b.ZIndex=9
    if pos then b.Position=pos end; b.Size = UDim2.new(1,0,0,38)
    b.BackgroundColor3 = active and UI_ACCENT or Color3.fromRGB(22, 22, 28)
    b.BackgroundTransparency = active and 0.12 or 0.25
    b.BorderSizePixel=0
    b.ClipsDescendants = true
    b.Text=text
    local tabSurface = Instance.new("Frame")
    tabSurface.Name = "GradientSurface"
    tabSurface.Size = UDim2.fromScale(1, 1)
    tabSurface.BackgroundColor3 = active and UI_ACCENT or Color3.fromRGB(35, 40, 46)
    tabSurface.BackgroundTransparency = active and 0.18 or 0.45
    tabSurface.BorderSizePixel = 0
    tabSurface.ZIndex = b.ZIndex - 1
    tabSurface.Parent = b
    Instance.new("UICorner", tabSurface).CornerRadius = UDim.new(0, 14)
    local tabGradient = Instance.new("UIGradient")
    tabGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, active and UI_ACCENT or Color3.fromRGB(70, 80, 90)),
        ColorSequenceKeypoint.new(0.6, active and UI_ACCENT or Color3.fromRGB(28, 32, 38)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 14, 18)),
    })
    tabGradient.Rotation = 7
    tabGradient.Parent = tabSurface
    b.TextColor3 = active and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(235,235,245)
    b.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    b.TextStrokeTransparency = active and 0.15 or 1
    b.TextTransparency=0
    b.TextSize=12; b.Font=Enum.Font.GothamBlack; b.AutoButtonColor=false; b.Parent=parent
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)
    local stroke = Instance.new("UIStroke"); stroke.Name="TabStroke"
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = active and 2 or 1
    stroke.Transparency = active and 0 or 0.55
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = b
    b:SetAttribute("IsActiveTab", active and true or false)
    b.MouseEnter:Connect(function()
        if not b:GetAttribute("IsActiveTab") then
            TweenService:Create(b, UI_TWEEN_FAST, {
                BackgroundColor3 = UI_ACCENT,
                BackgroundTransparency = 0.45,
                TextColor3 = Color3.fromRGB(0, 0, 0)
            }):Play()
            local st = b:FindFirstChild("TabStroke")
            if st then st.Transparency = 0.15; st.Thickness = 1.6 end
            b.TextStrokeTransparency = 0.25
        end
    end)
    b.MouseLeave:Connect(function()
        if not b:GetAttribute("IsActiveTab") then
            TweenService:Create(b, UI_TWEEN_FAST, {
                BackgroundColor3 = Color3.fromRGB(22, 22, 28),
                BackgroundTransparency = 0.25,
                TextColor3 = Color3.fromRGB(235,235,245)
            }):Play()
            local st = b:FindFirstChild("TabStroke")
            if st then st.Transparency = 0.55; st.Thickness = 1 end
            b.TextStrokeTransparency = 1
        end
    end)
    b.MouseButton1Down:Connect(function()
        b.TextColor3 = Color3.fromRGB(0, 0, 0)
        b.TextStrokeTransparency = 0.1
        local st = b:FindFirstChild("TabStroke")
        if st then
            st.Color = Color3.fromRGB(255, 255, 255)
            st.Transparency = 0
            st.Thickness = 2
        end
    end)
    return b
end


function M.applyCustomBackground(frame)
    if not frame then return end
    local existing = frame:FindFirstChild("CustomBgImage")
    if existing then existing:Destroy() end
    local id = tonumber(M.customBgId) or 0
    if id == 0 then return end
    local asset = resolveBackgroundAsset(id)
    if not asset then return end
    local img = Instance.new("ImageLabel")
    img.Name = "CustomBgImage"
    img.BackgroundTransparency = 1
    img.Image = asset
    img.ScaleType = Enum.ScaleType.Crop
    img.Size = UDim2.fromScale(1, 1)
    img.Position = UDim2.fromScale(0, 0)
    img.ZIndex = 0
    img.ImageTransparency = math.clamp(tonumber(M.customBgOpacity) or 0.35, 0, 1)
    img.Parent = frame
end

function M.openImagePicker(kind)
    local isBg = kind == "bg"
    if not isBg then return end
    local ids = M.BG_IMAGE_IDS
    local title = "CUSTOM BG"
    local currentId = tonumber(M.customBgId) or 0
    local opacity = math.clamp(tonumber(M.customBgOpacity) or 0.35, 0, 1)

    local old = player.PlayerGui:FindFirstChild("S1NXYImagePicker")
    if old then old:Destroy() end
    local cg = game:GetService("CoreGui"):FindFirstChild("S1NXYImagePicker")
    if cg then cg:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "S1NXYImagePicker"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 120
    pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not gui.Parent then gui.Parent = player:WaitForChild("PlayerGui") end

    local dim = Instance.new("TextButton")
    dim.Size = UDim2.fromScale(1, 1)
    dim.BackgroundColor3 = Color3.new(0, 0, 0)
    dim.BackgroundTransparency = 0.45
    dim.Text = ""
    dim.AutoButtonColor = false
    dim.ZIndex = 1
    dim.Parent = gui
    dim.MouseButton1Click:Connect(function() gui:Destroy() end)

    local panel = Instance.new("Frame")
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Position = UDim2.new(0.5, 0, 0.5, 0)
    panel.Size = UDim2.new(0, 220, 0, isBg and 280 or 230)
    panel.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    panel.BorderSizePixel = 0
    panel.ZIndex = 2
    panel.ClipsDescendants = true
    panel.Parent = gui
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)
    local pst = Instance.new("UIStroke", panel)
    pst.Color = Color3.fromRGB(50, 50, 60)
    pst.Thickness = 1

    local hdr = Instance.new("TextLabel")
    hdr.Size = UDim2.new(1, -40, 0, 28)
    hdr.Position = UDim2.new(0, 12, 0, 6)
    hdr.BackgroundTransparency = 1
    hdr.Text = title
    hdr.TextColor3 = Color3.fromRGB(230, 230, 235)
    hdr.Font = Enum.Font.GothamBold
    hdr.TextSize = 12
    hdr.TextXAlignment = Enum.TextXAlignment.Left
    hdr.ZIndex = 3
    hdr.Parent = panel

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 24, 0, 24)
    close.Position = UDim2.new(1, -30, 0, 6)
    close.BackgroundTransparency = 1
    close.Text = "×"
    close.TextColor3 = Color3.fromRGB(180, 180, 190)
    close.Font = Enum.Font.GothamBold
    close.TextSize = 18
    close.ZIndex = 3
    close.Parent = panel
    close.MouseButton1Click:Connect(function() gui:Destroy() end)

    local preview = Instance.new("ImageLabel")
    preview.Name = "Preview"
    preview.Size = UDim2.new(1, -24, 0, 100)
    preview.Position = UDim2.new(0, 12, 0, 34)
    preview.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    preview.BorderSizePixel = 0
    preview.ScaleType = Enum.ScaleType.Crop
    preview.Image = currentId > 0 and ("rbxassetid://" .. currentId) or ""
    preview.ImageTransparency = isBg and opacity or 0
    preview.ZIndex = 3
    preview.Parent = panel
    Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 10)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -24, 0, 56)
    scroll.Position = UDim2.new(0, 12, 0, 142)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = UI_ACCENT or Color3.fromRGB(200, 200, 200)
    scroll.ScrollingDirection = Enum.ScrollingDirection.X
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.X
    scroll.ZIndex = 3
    scroll.Parent = panel

    local lay = Instance.new("UIListLayout")
    lay.FillDirection = Enum.FillDirection.Horizontal
    lay.Padding = UDim.new(0, 8)
    lay.VerticalAlignment = Enum.VerticalAlignment.Center
    lay.Parent = scroll

    local selectedId = currentId

    local function selectId(id)
        selectedId = id
        preview.Image = resolveBackgroundAsset(id) or ""
        if isBg then
            M.customBgId = id
            if M._customBackgroundTarget then M.applyCustomBackground(M._customBackgroundTarget) elseif M.mainFrame then M.applyCustomBackground(M.mainFrame) end
        end
        saveCherryConfig()
    end

    local none = Instance.new("TextButton")
    none.Size = UDim2.new(0, 48, 0, 48)
    none.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    none.Text = "OFF"
    none.TextColor3 = Color3.fromRGB(200, 200, 210)
    none.Font = Enum.Font.GothamBold
    none.TextSize = 10
    none.ZIndex = 4
    none.Parent = scroll
    Instance.new("UICorner", none).CornerRadius = UDim.new(0, 8)
    none.MouseButton1Click:Connect(function() selectId(0) end)

    for _, id in ipairs(ids) do
        local thumb = Instance.new("ImageButton")
        thumb.Size = UDim2.new(0, 48, 0, 48)
        thumb.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
        thumb.Image = resolveBackgroundAsset(id) or ""
        thumb.ScaleType = Enum.ScaleType.Crop
        thumb.ZIndex = 4
        thumb.Parent = scroll
        Instance.new("UICorner", thumb).CornerRadius = UDim.new(0, 8)
        local st = Instance.new("UIStroke", thumb)
        st.Color = Color3.fromRGB(255, 255, 255)
        st.Transparency = (id == currentId) and 0.2 or 0.7
        st.Thickness = 1
        thumb.MouseButton1Click:Connect(function()
            selectId(id)
            for _, ch in ipairs(scroll:GetChildren()) do
                if ch:IsA("ImageButton") then
                    local s = ch:FindFirstChildOfClass("UIStroke")
                    if s then s.Transparency = 0.7 end
                end
            end
            st.Transparency = 0.2
        end)
    end

    if isBg then
        local opLbl = Instance.new("TextLabel")
        opLbl.Size = UDim2.new(0.5, -12, 0, 18)
        opLbl.Position = UDim2.new(0, 12, 0, 208)
        opLbl.BackgroundTransparency = 1
        opLbl.Text = "OPACITY"
        opLbl.TextColor3 = Color3.fromRGB(160, 160, 170)
        opLbl.Font = Enum.Font.GothamBold
        opLbl.TextSize = 10
        opLbl.TextXAlignment = Enum.TextXAlignment.Left
        opLbl.ZIndex = 3
        opLbl.Parent = panel

        local opVal = Instance.new("TextLabel")
        opVal.Size = UDim2.new(0.5, -12, 0, 18)
        opVal.Position = UDim2.new(0.5, 0, 0, 208)
        opVal.BackgroundTransparency = 1
        opVal.Text = tostring(math.floor((1 - opacity) * 100)) .. "%"
        opVal.TextColor3 = Color3.fromRGB(200, 200, 210)
        opVal.Font = Enum.Font.GothamBold
        opVal.TextSize = 10
        opVal.TextXAlignment = Enum.TextXAlignment.Right
        opVal.ZIndex = 3
        opVal.Parent = panel

        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, -24, 0, 8)
        track.Position = UDim2.new(0, 12, 0, 232)
        track.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
        track.BorderSizePixel = 0
        track.ZIndex = 3
        track.Parent = panel
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(1 - opacity, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(220, 220, 230)
        fill.BorderSizePixel = 0
        fill.ZIndex = 4
        fill.Parent = track
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 16, 0, 16)
        knob.AnchorPoint = Vector2.new(0.5, 0.5)
        knob.Position = UDim2.new(1 - opacity, 0, 0.5, 0)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.BorderSizePixel = 0
        knob.ZIndex = 5
        knob.Parent = track
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local dragging = false
        local function setFromX(x)
            local rel = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
            local imageTransparency = 1 - rel
            opacity = imageTransparency
            M.customBgOpacity = opacity
            fill.Size = UDim2.new(rel, 0, 1, 0)
            knob.Position = UDim2.new(rel, 0, 0.5, 0)
            preview.ImageTransparency = opacity
            opVal.Text = tostring(math.floor(rel * 100)) .. "%"
            if M._customBackgroundTarget then M.applyCustomBackground(M._customBackgroundTarget) elseif M.mainFrame then M.applyCustomBackground(M.mainFrame) end
            saveCherryConfig()
        end
        track.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                setFromX(i.Position.X)
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                setFromX(i.Position.X)
            end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end
end




function M._fontShouldTouch(obj)
    if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return false end
    if obj.TextStrokeTransparency ~= 1 then return false end
    return true
end

function M._fontApplyOne(txt)
    if not M._fontShouldTouch(txt) then return end
    if not M._fontOrig[txt] then M._fontOrig[txt] = txt.FontFace end
    if M._fontMy then
        pcall(function() txt.FontFace = M._fontMy end)
    end
end

function M._fontSetupCoding()
    if M._fontMy and M.customFontSelected == "Coding Font" then return true end
    local ok = pcall(function()
        if isfile and writefile and getcustomasset then
            if not isfile("s1nxy_starborn.ttf") then
                writefile("s1nxy_starborn.ttf", game:HttpGet("https://granny.anondrop.net/uploads/6c2505542959f371/Starborn.ttf"))
            end
            writefile("s1nxy_starborn.json", HS:JSONEncode({
                name = "Starborn",
                faces = {{name = "Regular", weight = 400, style = "normal", assetId = getcustomasset("s1nxy_starborn.ttf")}}
            }))
            M._fontMy = Font.new(getcustomasset("s1nxy_starborn.json"))
        end
    end)
    return ok and M._fontMy ~= nil
end

function M.getFontForName(name)
    if not name or name == "None" then return nil end
    if name == "Coding Font" then
        if M._fontSetupCoding() then return M._fontMy end
        return nil
    elseif name == "Summer" then
        return Font.new("rbxasset://fonts/families/PermanentMarker.json")
    elseif name == "Beachy" then
        return Font.new("rbxasset://fonts/families/DenkOne.json")
    elseif name == "Scary" then
        return Font.new("rbxasset://fonts/families/Creepster.json")
    elseif name == "Bangers" then
        return Font.new("rbxasset://fonts/families/Bangers.json")
    end
    return nil
end

function M.applyCustomFont(name)
    if M._fontConn then pcall(function() M._fontConn:Disconnect() end); M._fontConn = nil end
    for obj, orig in pairs(M._fontOrig) do
        pcall(function() if obj and obj.Parent then obj.FontFace = orig end end)
    end
    M._fontOrig = {}
    M.customFontSelected = name or "None"
    if name and name ~= "None" then
        local font = M.getFontForName(name)
        if font then
            M._fontMy = font
            for _, v in ipairs(game:GetDescendants()) do
                M._fontApplyOne(v)
            end
            M._fontConn = game.DescendantAdded:Connect(function(obj)
                if M.customFontSelected ~= "None" then M._fontApplyOne(obj) end
            end)
        end
    else
        M._fontMy = nil
    end
    pcall(function()
        if type(saveCherryConfig) == "function" then saveCherryConfig() end
    end)
end




function M.destroyMobileButtons()
    if M.mobGuiRef then
        pcall(function() M.mobGuiRef:Destroy() end)
        M.mobGuiRef = nil
    end
    for _,n in ipairs({"MoveeMobileButtons"}) do
        local old = game:GetService("CoreGui"):FindFirstChild(n); if old then old:Destroy() end
        local pgui = player:FindFirstChild("PlayerGui"); if pgui then local o = pgui:FindFirstChild(n); if o then o:Destroy() end end
    end
    M.mobBtnRefs = {}
end

function M.loadBtnPositions()
    if not(isfile and isfile(M.MOB_POS_FILE)) then return {} end
    local ok, data = pcall(function() return HS:JSONDecode(readfile(M.MOB_POS_FILE)) end)
    if ok and type(data)=="table" then return data end
    return {}
end

function M.saveBtnPositions()
    if not writefile then return end
    local gui = M.cleanToggleGui or M.mobGuiRef
    if not gui then return end
    local out = {}
    for _,child in ipairs(gui:GetDescendants()) do
        if child:IsA("TextButton") and child:GetAttribute("BtnKey") then
            local key = child:GetAttribute("BtnKey")
            out[key] = {x=child.Position.X.Offset, y=child.Position.Y.Offset}
        end
    end
    pcall(function() writefile(M.MOB_POS_FILE, HS:JSONEncode(out)) end)
end

function M.resetMobilePositions()
    pcall(function()
        if type(delfile) == "function" then
            delfile(M.MOB_POS_FILE)
        elseif type(writefile) == "function" then
            writefile(M.MOB_POS_FILE, "{}")
        end
    end)
    pcall(function()
        if isfile and isfile(M.MOB_POS_FILE) and type(writefile) == "function" then
            writefile(M.MOB_POS_FILE, "{}")
        end
    end)
    M._forceDefaultMobPos = true
    if M.buildCleanTogglePanel then M.buildCleanTogglePanel() else M.buildMobileButtons() end
    M._forceDefaultMobPos = false
    pcall(function()
        if not M.mobGuiRef then return end
        local out = {}
        for _, child in ipairs(M.mobGuiRef:GetDescendants()) do
            if child:IsA("TextButton") and child:GetAttribute("BtnKey") then
                local key = child:GetAttribute("BtnKey")
                local dx = child:GetAttribute("DefaultX")
                local dy = child:GetAttribute("DefaultY")
                if typeof(dx) == "number" and typeof(dy) == "number" then
                    child.Position = UDim2.new(0, dx, 0, dy)
                    out[key] = {x = dx, y = dy}
                end
            end
        end
        if writefile then
            writefile(M.MOB_POS_FILE, HS:JSONEncode(out))
        end
    end)
end

function M.buildMobileButtons()
    M.destroyMobileButtons()
    if not M.mobileButtonsEnabled then return end

    local savedPositions = M._forceDefaultMobPos and {} or M.loadBtnPositions()
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)

    
    local BTN_SIZE = 60
    local BTN_GAP = 8
    local PADDING = 4
    local BTN_H = BTN_SIZE
    local BTN_W = BTN_SIZE
    local CORNER_R = 18

    local mobGui = Instance.new("ScreenGui")
    mobGui.Name = "MoveeMobileButtons"
    mobGui.ResetOnSpawn = false
    mobGui.DisplayOrder = 15
    mobGui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(mobGui) end end)
    if not pcall(function() mobGui.Parent = game:GetService("CoreGui") end) then
        mobGui.Parent = player:WaitForChild("PlayerGui")
    end
    M.mobGuiRef = mobGui
    
    mobGui.Enabled = M._introActive ~= true

    local accent = Color3.fromRGB(232, 52, 68)
    
    local SILVER = Color3.fromRGB(180, 180, 190)
    local BTN_OFF = Color3.fromRGB(10, 10, 10)
    local BTN_ON = SILVER
    local TXT_OFF = Color3.fromRGB(225, 225, 225)
    local TXT_ON = Color3.fromRGB(255, 255, 255)
    local STROKE_COLOR = Color3.fromRGB(70, 70, 70)
    local redShineEntries = {}

    local function attachRedTextShine(btn)
        btn.TextTransparency = 1

        local shineText = Instance.new("TextLabel")
        shineText.Name = "RedTextShine"
        shineText.BackgroundTransparency = 1
        shineText.BorderSizePixel = 0
        shineText.Size = UDim2.fromScale(1, 1)
        shineText.Position = UDim2.fromScale(0, 0)
        shineText.Text = btn.Text
        shineText.TextColor3 = Color3.fromRGB(75, 230, 110)
        shineText.TextTransparency = 0
        shineText.TextScaled = false
        shineText.TextSize = 11
        shineText.Font = Enum.Font.GothamBold
        shineText.TextWrapped = true
        shineText.LineHeight = 1.2
        shineText.TextXAlignment = Enum.TextXAlignment.Center
        shineText.TextYAlignment = Enum.TextYAlignment.Center
        shineText.ZIndex = btn.ZIndex + 1
        shineText.Active = false
        shineText.Selectable = false
        shineText.Parent = btn

        local shineGradient = Instance.new("UIGradient")
        shineGradient.Name = "RedShineGradient"
        shineGradient.Offset = Vector2.new(-1.25, 0)
        shineGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(8, 70, 24)),
            ColorSequenceKeypoint.new(0.38, Color3.fromRGB(30, 145, 58)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(180, 255, 195)),
            ColorSequenceKeypoint.new(0.62, Color3.fromRGB(65, 220, 95)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(8, 70, 24)),
        })
        shineGradient.Parent = shineText
        table.insert(redShineEntries, {button = btn, label = shineText, gradient = shineGradient})
    end

    local ROSE_BUTTON_URL = "https://files.manuscdn.com/user_upload_by_module/session_file/310519663932881825/ecnWznTIHWKwlfzu.JPG"
    local ROSE_BUTTON_FILE = "S1NXY_RoseButton.jpg"
    local roseButtonAssetId = nil
    pcall(function()
        local loader = getLocalAssetLoader()
        if loader and downloadLocalAsset(ROSE_BUTTON_URL, ROSE_BUTTON_FILE) and isfile and isfile(ROSE_BUTTON_FILE) then
            local ok, asset = pcall(loader, ROSE_BUTTON_FILE)
            if ok then roseButtonAssetId = asset end
        end
    end)

    local function attachRoseBackground(btn)
        if not roseButtonAssetId then return end
        local image = Instance.new("ImageLabel")
        image.Name = "RoseBackground"
        image.Size = UDim2.fromScale(1, 1)
        image.Position = UDim2.fromScale(0, 0)
        image.BackgroundTransparency = 1
        image.BorderSizePixel = 0
        image.Image = roseButtonAssetId
        image.ScaleType = Enum.ScaleType.Crop
        image.ImageTransparency = 0.08
        image.ZIndex = btn.ZIndex
        image.Active = false
        image.Selectable = false
        image.Parent = btn
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, CORNER_R)
        corner.Parent = image
        local shade = Instance.new("Frame")
        shade.Name = "RoseTextShade"
        shade.Size = UDim2.fromScale(1, 1)
        shade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        shade.BackgroundTransparency = 0.42
        shade.BorderSizePixel = 0
        shade.ZIndex = btn.ZIndex + 1
        shade.Active = false
        shade.Selectable = false
        shade.Parent = btn
        local shadeCorner = Instance.new("UICorner")
        shadeCorner.CornerRadius = UDim.new(0, CORNER_R)
        shadeCorner.Parent = shade
    end

    local btnDefs = {
        {"instaReset", "INSTA\nRESET", false, 0, 0},
        {"autoLeft", "AUTO\nLEFT", true, 2, 0},
        {"autoRight", "AUTO\nRIGHT", true, 3, 0},
        {"autoMedusa", "AUTO\nMEDUSA", true, 0, 1},
        {"bypass", "BAT\nTP", true, 1, 1},
        {"tpDown", "TP\nDOWN", false, 2, 1},
        {"drop", "DROP\nBRAINROT", false, 3, 1},
        {"batV2", "BAT\nV2", true, 1, 2},
        {"autoBat", "AUTO\nBAT", true, 2, 2},
        {"carrySpeed", "CARRY\nSPEED", true, 3, 2},
        {"lagger", "LAGGER\nMODE", true, 1, 3},
        {"laggerCarry", "LAGGER\nCARRY", true, 2, 3},
        {"autoTpDown", "AUTO TP\nDOWN", true, 3, 3},
        {"antiAnti", "ANTI ANTI\nBYPASS", true, 0, 4},
    }

    local cols = 4
    local gap = BTN_GAP
    local padding = PADDING
    local startX = vp.X - (cols * (BTN_W + gap)) - padding
    local startY = 50

    task.spawn(function()
        while mobGui and mobGui.Parent do
            local animatedAny = false
            for _, entry in ipairs(redShineEntries) do
                local btn = entry.button
                local gradient = entry.gradient
                if btn and btn.Parent and gradient and gradient.Parent and btn.Visible then
                    animatedAny = true
                    gradient.Offset = Vector2.new(-1.25, 0)
                    local tween = TweenService:Create(
                        gradient,
                        TweenInfo.new(1.45, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
                        {Offset = Vector2.new(1.25, 0)}
                    )
                    tween:Play()
                    tween.Completed:Wait()
                end
            end
            if not animatedAny then task.wait(0.5) else task.wait(0.8) end
        end
    end)

    for i, def in ipairs(btnDefs) do
        local key = def[1]
        local label = def[2]
        local isToggle = def[3]
        local isMovable = true

        local col = def[4] or ((i-1) % cols)
        local row = def[5] or math.floor((i-1) / cols)
        local defaultX = startX + col * (BTN_W + gap)
        local defaultY = startY + row * (BTN_H + gap)

        local saved = (not M._forceDefaultMobPos) and savedPositions[key] or nil
        local posX = (saved and type(saved.x) == "number") and saved.x or defaultX
        local posY = (saved and type(saved.y) == "number") and saved.y or defaultY

        local btn = Instance.new("TextButton")
        btn.Name = "Btn_" .. key
        btn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        btn.Position = UDim2.new(0, posX, 0, posY)
        btn:SetAttribute("DefaultX", defaultX)
        btn:SetAttribute("DefaultY", defaultY)
        btn.BackgroundColor3 = BTN_OFF
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ZIndex = 101
        btn:SetAttribute("BtnKey", key)
        btn.Parent = mobGui

        local corner = Instance.new("UICorner", btn)
        corner.CornerRadius = UDim.new(0, CORNER_R)
        local stroke = Instance.new("UIStroke", btn)
        stroke.Name = "NormalStroke"
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Color = STROKE_COLOR
        stroke.Thickness = 1.2
        stroke.Transparency = 0.4

        local textLabel = Instance.new("TextLabel", btn)
        textLabel.Name = "ButtonText"
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = label
        textLabel.TextColor3 = TXT_OFF
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextSize = 10
        textLabel.TextWrapped = true
        textLabel.ZIndex = 102
        textLabel.Active = false
        textLabel.Selectable = false
        local isOn = (key == "autoTpDown" and M.autoTPEnabled == true) or false
        local function setOn(v)
            isOn = v
            if v then
                btn.BackgroundColor3 = BTN_ON
                textLabel.TextColor3 = TXT_ON
                stroke.Color = SILVER
                stroke.Transparency = 0
            else
                btn.BackgroundColor3 = BTN_OFF
                textLabel.TextColor3 = TXT_OFF
                stroke.Color = STROKE_COLOR
                stroke.Transparency = 0.4
            end
        end

        if isOn then setOn(true) end
        M.mobBtnRefs[key] = setOn

        local dragging = false
        local dragStart = nil
        local startPos = nil
        btn.InputBegan:Connect(function(input)
            if not isMovable or M.uiLocked then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = btn.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        M.saveBtnPositions()
                    end
                end)
            end
        end)
        btn.InputChanged:Connect(function(input)
            if isMovable and dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                btn.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if dragging and M.uiLocked then
                dragging = false
            end
        end)

        btn.Activated:Connect(function()
            if key == "drop" then
                M.runDrop()
            elseif key == "instaReset" then
                M.runInstantReset()
            elseif key == "tpDown" then
                M.runTPFloor()
            elseif key == "autoTpDown" then
                M.autoTPEnabled = not M.autoTPEnabled
                if M.autoTPEnabled then M.startAutoTP() else M.stopAutoTP() end
                setOn(M.autoTPEnabled)
                if M.setAutoTPVisual then M.setAutoTPVisual(M.autoTPEnabled) end
                saveCherryConfig()
            elseif key == "autoLeft" then
                if M.autoBatEnabled then
                    M.stopBatAimbot()
                    if M.autoBatSetVisual then M.autoBatSetVisual(false) end
                    if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(false) end
                end
                if M.autoRightEnabled then
                    M.autoRightEnabled = false
                    M.stopAutoRight()
                    if M.autoRightSetVisual then M.autoRightSetVisual(false) end
                    if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(false) end
                end
                M.autoLeftEnabled = not M.autoLeftEnabled
                if M.autoLeftEnabled then M.startAutoLeft() else M.stopAutoLeft() end
                setOn(M.autoLeftEnabled)
                if M.autoLeftSetVisual then M.autoLeftSetVisual(M.autoLeftEnabled) end
                saveCherryConfig()
            elseif key == "autoRight" then
                if M.autoBatEnabled then
                    M.stopBatAimbot()
                    if M.autoBatSetVisual then M.autoBatSetVisual(false) end
                    if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(false) end
                end
                if M.autoLeftEnabled then
                    M.autoLeftEnabled = false
                    M.stopAutoLeft()
                    if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
                    if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(false) end
                end
                M.autoRightEnabled = not M.autoRightEnabled
                if M.autoRightEnabled then M.startAutoRight() else M.stopAutoRight() end
                setOn(M.autoRightEnabled)
                if M.autoRightSetVisual then M.autoRightSetVisual(M.autoRightEnabled) end
                saveCherryConfig()
            elseif key == "autoBat" then
                if M.autoLeftEnabled then
                    M.autoLeftEnabled = false
                    M.stopAutoLeft()
                    if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end
                    if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(false) end
                end
                if M.autoRightEnabled then
                    M.autoRightEnabled = false
                    M.stopAutoRight()
                    if M.autoRightSetVisual then M.autoRightSetVisual(false) end
                    if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(false) end
                end
                if not M.autoBatEnabled then
                    M.queueAutoBatStart()
                else
                    M.stopBatAimbot()
                end
                setOn(M.autoBatEnabled)
                if M.autoBatSetVisual then M.autoBatSetVisual(M.autoBatEnabled) end
                saveCherryConfig()
            elseif key == "lagger" then
                M.toggleLaggerMode()
                setOn(M.laggerModeEnabled)
                if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
                if M.laggerModeBtn then
                    M.laggerModeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off"
                end
                saveCherryConfig()
            elseif key == "carrySpeed" then
                M.toggleCarryMode()
                setOn(M.carrySpeedActive)
                if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
                if M.carryModeBtn then
                    M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off"
                end
                saveCherryConfig()
            elseif key == "bypass" then
                M.toggleBypassAimbot()
                setOn(M.bypassAimbotEnabled)
                if M.setBypassVisual then M.setBypassVisual(M.bypassAimbotEnabled) end
                saveCherryConfig()
            elseif key == "batV2" then
                if M.batV2Enabled then
                    M.stopBatV2()
                else
                    if M.autoBatEnabled then M.stopBatAimbot() end
                    if M.bypassAimbotEnabled then M.stopBypassAimbot() end
                    M.startBatV2()
                end
                setOn(M.batV2Enabled)
                if M.setBatV2Visual then M.setBatV2Visual(M.batV2Enabled) end
                saveCherryConfig()
            elseif key == "autoMedusa" then
                if M.autoMedusaEnabled then M.stopAutoMedusa() else M.startAutoMedusa() end
                setOn(M.autoMedusaEnabled)
                if M.setAutoMedusaVisual then M.setAutoMedusaVisual(M.autoMedusaEnabled) end
                saveCherryConfig()
            elseif key == "antiAnti" then
                M.toggleAntiAntiDesync()
                setOn(M.aadEnabled)
                saveCherryConfig()
            elseif key == "laggerCarry" then
                M.toggleLaggerCarry()
                setOn(M.laggerCarryActive)
                saveCherryConfig()
            end
        end)
    end

    if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(M.autoLeftEnabled) end
    if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(M.autoRightEnabled) end
    if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(M.autoBatEnabled) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(M.bypassAimbotEnabled) end
    if M.mobBtnRefs.batV2 then M.mobBtnRefs.batV2(M.batV2Enabled) end
    if M.mobBtnRefs.autoMedusa then M.mobBtnRefs.autoMedusa(M.autoMedusaEnabled) end
    if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
    if M.mobBtnRefs.antiAnti then M.mobBtnRefs.antiAnti(M.aadEnabled) end
end

function M.buildGui()
    
    if M._hubGui then pcall(function() M._hubGui:Destroy() end); M._hubGui = nil end
    if M._minPill then pcall(function() M._minPill:Destroy() end); M._minPill = nil end
    applyAccentFromTheme()
    M.clearPersistentConns()

    for _,n in ipairs({"S1NXY_Hub","MoveeDuels","Cherry_Menu","K7HubGUI","VantaHubUI","S1NXYHubUI","S1NXYHubUI","AceDuelsAdaptReconstruct","AdaptHubPolished","AdaptDuelsAdaptReconstruct","CyberHub"}) do
        local cg=game:GetService("CoreGui")
        local old=cg:FindFirstChild(n); if old then old:Destroy() end
        local pg=player:FindFirstChild("PlayerGui")
        if pg then local o=pg:FindFirstChild(n); if o then o:Destroy() end end
    end

    M.buildStatusUI()

    local gui = Instance.new("ScreenGui")
    gui.Name = "S1NXY_Hub"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = player:WaitForChild("PlayerGui")
    M._hubGui = gui

    local Frame = Instance.new("Frame")
    Frame.Name = "Frame"
    Frame.ClipsDescendants = false
    local savedMenuPosition = M.menuPosition
    Frame.Position = savedMenuPosition and UDim2.new(savedMenuPosition.xScale, savedMenuPosition.xOffset, savedMenuPosition.yScale, savedMenuPosition.yOffset) or UDim2.new(0,10,0.5,-290)
    Frame.Size = UDim2.new(0,356,0,536)
    Frame.BackgroundColor3 = UI_BG_DARK
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Parent = gui
    M.mainFrame = Frame

    local Inner = Instance.new("Frame")
    Inner.Name = "Inner"
    Inner.Size = UDim2.fromScale(1, 1)
    Inner.BackgroundColor3 = UI_BG_DARK
    Inner.BackgroundTransparency = 0.02
    Inner.BorderSizePixel = 0
    Inner.ClipsDescendants = false
    Inner.Parent = Frame
    local innerCorner = Instance.new("UICorner")
    innerCorner.CornerRadius = UDim.new(0, 24)
    innerCorner.Parent = Inner
    M._customBackgroundTarget = Inner
    M.applyCustomBackground(Inner)
    local innerGradient = Instance.new("UIGradient")
    innerGradient.Name = "772BackgroundGradient"
    innerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(4, 4, 4)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 10, 12)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 4, 4))
    })
    innerGradient.Rotation = 135
    innerGradient.Parent = Inner

    local UIScale = Instance.new("UIScale")
    UIScale.Name = "BDUIScale"
    UIScale.Scale = math.clamp(tonumber(M.uiScale) or 1.0, 0.5, 2.0)
    UIScale.Parent = Frame
    M.uiScaleRef = UIScale

    local frameCorner = Instance.new("UICorner")
    frameCorner.Name = "MainCorner"
    frameCorner.CornerRadius = UDim.new(0, 24)
    frameCorner.Parent = Frame
    do
        local g = Instance.new("UIGradient")
        g.Name = "MainGradient"
        local accent = UI_ACCENT or Color3.fromRGB(232,52,68)
        local bg = UI_BG_DARK or Color3.fromRGB(6,4,12)
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, bg:Lerp(accent, 0.12)),
            ColorSequenceKeypoint.new(0.45, bg),
            ColorSequenceKeypoint.new(1, bg:Lerp(accent, 0.06)),
        })
        g.Rotation = 120
        g.Parent = Frame
        local stroke = Instance.new("UIStroke")
        stroke.Name = "MainStroke"
        stroke.Color = accent
        stroke.Thickness = 1.4
        stroke.Transparency = 0.55
        stroke.Parent = Frame
    end

    
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1,0,0,62)
    Header.BackgroundTransparency = 1
    Header.Active = true
    Header.Parent = Inner

    do
        local t = Instance.new("TextLabel"); t.ZIndex=3
        t.Position = UDim2.new(0,14,0,8); t.Size = UDim2.new(1,-90,0,22)
        t.BackgroundTransparency = 1
        t.Text = "S1NXY"
        t.TextColor3 = UI_TEXT_WHITE
        t.TextSize = 17; t.Font = Enum.Font.GothamBlack
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.RichText = true; t.Parent = Header

        local s = Instance.new("TextLabel"); s.ZIndex=3
        s.Position = UDim2.new(0,14,0,32); s.Size = UDim2.new(0,220,0,14)
        s.BackgroundTransparency = 1
        s.Text = "S1NXY"
        s.TextColor3 = UI_TEXT_DIM
        s.TextSize = 10; s.Font = Enum.Font.GothamBold
        s.TextXAlignment = Enum.TextXAlignment.Left; s.Parent = Header
    end

    local MinBtn = Instance.new("TextButton")
    MinBtn.ZIndex=3; MinBtn.Position=UDim2.new(1,-42,0,13); MinBtn.Size=UDim2.new(0,30,0,30)
    MinBtn.BackgroundColor3=UI_BTN_BG; MinBtn.BorderSizePixel=0; MinBtn.Text="-"
    MinBtn.TextColor3=UI_TEXT_PRIMARY; MinBtn.TextSize=13; MinBtn.Font=Enum.Font.GothamBold
    MinBtn.AutoButtonColor=false; MinBtn.Parent=Header
    Instance.new("UICorner",MinBtn).CornerRadius = UDim.new(0,6)
    MinBtn.MouseButton1Down:Connect(function() TweenService:Create(MinBtn, UI_TWEEN_FAST, {BackgroundColor3 = UI_ACCENT}):Play() end)
    MinBtn.MouseButton1Up:Connect(function() TweenService:Create(MinBtn, UI_TWEEN_FAST, {BackgroundColor3 = UI_BTN_BG}):Play() end)

    local lockButton = Instance.new("TextButton")
    lockButton.Size = UDim2.new(0,60,0,24)
    lockButton.Position = UDim2.new(1,-108,0.5,-12)
    lockButton.BackgroundColor3 = UI_BTN_BG
    lockButton.BorderSizePixel = 0
    lockButton.Text = "UNLOCK"
    lockButton.TextColor3 = UI_TEXT_DIM
    lockButton.Font = Enum.Font.GothamBold
    lockButton.TextSize = 9
    lockButton.AutoButtonColor = false
    lockButton.ZIndex = 3
    lockButton.Parent = Header
    Instance.new("UICorner",lockButton).CornerRadius = UDim.new(0,6)

    local saveOpenButtonPosition
    local locked = M.uiLocked == true
    lockButton.Text = locked and "LOCKED" or "UNLOCK"
    lockButton.TextColor3 = locked and UI_ACCENT or UI_TEXT_DIM
    lockButton.Activated:Connect(function()
        locked = not locked
        M.uiLocked = locked
        lockButton.Text = locked and "LOCKED" or "UNLOCK"
        lockButton.TextColor3 = locked and UI_ACCENT or UI_TEXT_DIM
        if locked then
            pcall(M.saveBtnPositions)
            if type(saveOpenButtonPosition) == "function" then saveOpenButtonPosition() end
            saveCherryConfig()
        else
            saveCherryConfig()
        end
    end)

    local Div = Instance.new("Frame")
    Div.Position = UDim2.new(0,16,0,64); Div.Size = UDim2.new(1,-32,0,1)
    Div.BackgroundColor3 = UI_TEXT_WHITE; Div.BorderSizePixel = 0; Div.Parent = Inner
    do local g=Instance.new("UIGradient"); g.Color=ColorSequence.new(UI_ACCENT,UI_ACCENT); g.Transparency=NumberSequence.new(0.2,0.85); g.Parent=Div end

    
    local SidePanel = Instance.new("Frame")
    SidePanel.Name = "LeftPanel"
    SidePanel.Position = UDim2.new(1, -158, 0, 72)
    SidePanel.Size = UDim2.new(0, 150, 1, -118)
    SidePanel.BackgroundColor3 = UI_BG_DARK
    SidePanel.BackgroundTransparency = 0.35
    SidePanel.BorderSizePixel = 0
    SidePanel.Parent = Inner
    Instance.new("UICorner", SidePanel).CornerRadius = UDim.new(0, 12)
    local sideGradient = Instance.new("UIGradient")
    sideGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 22, 28)),
        ColorSequenceKeypoint.new(0.55, UI_BG_DARK),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 7, 10)),
    })
    sideGradient.Rotation = 90
    sideGradient.Parent = SidePanel
    local sideStroke = Instance.new("UIStroke")
    sideStroke.Color = UI_ACCENT
    sideStroke.Transparency = 0.65
    sideStroke.Thickness = 1
    sideStroke.Parent = SidePanel
    local TabBar = Instance.new("ScrollingFrame")
    TabBar.Name = "TabBar"
    TabBar.Position = UDim2.new(0,0,0,0)
    TabBar.Size = UDim2.new(1,0,1,0)
    TabBar.BackgroundTransparency = 1
    TabBar.BorderSizePixel = 0
    TabBar.ScrollBarThickness = 3
    TabBar.ScrollBarImageColor3 = UI_ACCENT
    TabBar.ScrollingDirection = Enum.ScrollingDirection.Y
    TabBar.ElasticBehavior = Enum.ElasticBehavior.Always
    TabBar.CanvasSize = UDim2.new(0,0,0,0)
    TabBar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabBar.Parent = SidePanel

    local TabsLayout = Instance.new("UIListLayout")
    TabsLayout.FillDirection = Enum.FillDirection.Vertical
    TabsLayout.Padding = UDim.new(0,6)
    TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabsLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    TabsLayout.Parent = TabBar

    local TabPad = Instance.new("UIPadding")
    TabPad.PaddingLeft = UDim.new(0,15)
    TabPad.PaddingRight = UDim.new(0,15)
    TabPad.PaddingTop = UDim.new(0,12)
    TabPad.PaddingBottom = UDim.new(0,10)
    TabPad.Parent = TabBar

    local TSpeed = uiMakeTab(TabBar,"Tab_SPEED","SPEED",nil,true); TSpeed.LayoutOrder=1
    local TMech  = uiMakeTab(TabBar,"Tab_MECH","MECHANICS",nil,false); TMech.LayoutOrder=2
    local TVis   = uiMakeTab(TabBar,"Tab_VIS","VISUALS",nil,false); TVis.LayoutOrder=3
    local TUtil  = uiMakeTab(TabBar,"Tab_UTIL","UTILITY",nil,false); TUtil.LayoutOrder=4
    local TKB    = uiMakeTab(TabBar,"Tab_KB","KEYBINDS",nil,false); TKB.LayoutOrder=5
    local TMusic = uiMakeTab(TabBar,"Tab_MUSIC","MUSIC",nil,false); TMusic.LayoutOrder=6
    local TIntros = uiMakeTab(TabBar,"Tab_INTROS","INTROS",nil,false); TIntros.LayoutOrder=7

    
    local PagedContent = Instance.new("Frame")
    PagedContent.Name = "PagedContent"
    PagedContent.Position = UDim2.new(0,8,0,72)
    PagedContent.Size = UDim2.new(1,-174,1,-120)
    PagedContent.BackgroundColor3 = Color3.fromRGB(3, 4, 8)
    PagedContent.BackgroundTransparency = 0.58
    PagedContent.BorderSizePixel = 0
    PagedContent.ClipsDescendants = true
    PagedContent.Parent = Inner
    local contentStroke = Instance.new("UIStroke")
    contentStroke.Color = UI_ACCENT
    contentStroke.Transparency = 0.68
    contentStroke.Thickness = 1
    contentStroke.Parent = PagedContent

    
    local PM    = uiMakePage(PagedContent, "Page_SPEED",     1, true)
    local PMech = uiMakePage(PagedContent, "Page_MECHANICS", 2, false)
    local PVis  = uiMakePage(PagedContent, "Page_VISUALS",   3, false)
    local PUtil = uiMakePage(PagedContent, "Page_UTILITY",   4, false)
    local PKB   = uiMakePage(PagedContent, "Page_KEYBINDS",  5, false)
    local PMusic = uiMakePage(PagedContent, "Page_MUSIC", 6, false)
    local PIntros = uiMakePage(PagedContent, "Page_INTROS", 7, false)

    local Pages = {SPEED=PM, MECHANICS=PMech, VISUALS=PVis, UTILITY=PUtil, KEYBINDS=PKB, MUSIC=PMusic, INTROS=PIntros}
    local Tabs  = {SPEED=TSpeed, MECHANICS=TMech, VISUALS=TVis, UTILITY=TUtil, KEYBINDS=TKB, MUSIC=TMusic, INTROS=TIntros}
    local curTab = "SPEED"

    local function switchTab(name)
        if curTab == name then return end; curTab = name
        for k,p in pairs(Pages) do p.Visible = (k==name) end
        for k,b in pairs(Tabs) do
            local act = (k==name)
            b:SetAttribute("IsActiveTab", act)
            b.BackgroundColor3 = act and UI_ACCENT or Color3.fromRGB(22, 22, 28)
            b.BackgroundTransparency = act and 0.12 or 0.25
            b.TextColor3 = act and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(235,235,245)
            b.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            b.TextStrokeTransparency = act and 0.15 or 1
            local st = b:FindFirstChild("TabStroke")
            if st then
                st.Color = Color3.fromRGB(255, 255, 255)
                st.Thickness = act and 2 or 1
                st.Transparency = act and 0 or 0.55
            end
        end
    end
    M.selectTab = switchTab

    TSpeed.MouseButton1Click:Connect(function() switchTab("SPEED") end)
    TMech.MouseButton1Click:Connect(function() switchTab("MECHANICS") end)
    TVis.MouseButton1Click:Connect(function() switchTab("VISUALS") end)
    TUtil.MouseButton1Click:Connect(function() switchTab("UTILITY") end)
    TKB.MouseButton1Click:Connect(function() switchTab("KEYBINDS") end)
    TMusic.MouseButton1Click:Connect(function() switchTab("MUSIC") end)
    TIntros.MouseButton1Click:Connect(function() switchTab("INTROS") end)

    
    local MinPill
    local function closeUI()
        local tween = TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 420, 0, 0),
            Position = Frame.Position + UDim2.new(0, 0, 0, 264),
            BackgroundTransparency = 1
        })
        tween:Play()
        tween.Completed:Connect(function()
            Frame.Visible = false
            Frame.Size = UDim2.new(0, 356, 0, 536)
            local saved = M.menuPosition
            Frame.Position = saved and UDim2.new(saved.xScale, saved.xOffset, saved.yScale, saved.yOffset) or UDim2.new(0, 12, 0.5, -170)
            Frame.BackgroundTransparency = 0
            M.menuOpen = false
            pcall(saveCherryConfig)
            task.delay(0.4, function()
                if not Frame.Visible and MinPill then MinPill.Visible = true end
            end)
        end)
    end
    MinPill = Instance.new("Frame")
    MinPill.Visible=false; MinPill.Active=true; MinPill.ZIndex=40
    MinPill.AnchorPoint = Vector2.new(0.5, 0)
    local savedOpenButtonPosition = M.openButtonPosition
    MinPill.Position = savedOpenButtonPosition and UDim2.new(savedOpenButtonPosition.xScale, savedOpenButtonPosition.xOffset, savedOpenButtonPosition.yScale, savedOpenButtonPosition.yOffset) or UDim2.new(0.5, 0, 0, 10)
    MinPill.Size = UDim2.new(0, 110, 0, 32)
    MinPill.AutomaticSize = Enum.AutomaticSize.None
    M._minPill = MinPill
    MinPill.BackgroundColor3=Color3.fromRGB(14,14,18); MinPill.BackgroundTransparency=0.08; MinPill.BorderSizePixel=0; MinPill.Parent=gui
    Instance.new("UICorner",MinPill).CornerRadius=UDim.new(0,16)
    local pillPadding = Instance.new("UIPadding")
    pillPadding.PaddingLeft = UDim.new(0, 12)
    pillPadding.PaddingRight = UDim.new(0, 12)
    pillPadding.Parent = MinPill
    do
        local pg = Instance.new("UIGradient")
        pg.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(55,60,70)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25,28,34)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(10,12,16))
        })
        pg.Rotation = 25
        pg.Parent = MinPill
    end
    do
        local pst = Instance.new("UIStroke")
        pst.Color = Color3.fromRGB(125,142,131)
        pst.Thickness = 1.4
        pst.Transparency = 0.12
        pst.Parent = MinPill
    end
    do
        local l=Instance.new("TextLabel"); l.ZIndex=41; l.Size=UDim2.new(1,0,1,0); l.BackgroundTransparency=1; l.Text="S1NXY"; l.TextColor3=Color3.fromRGB(245,245,250); l.TextSize=11; l.Font=Enum.Font.GothamBlack; l.TextXAlignment=Enum.TextXAlignment.Center; l.TextYAlignment=Enum.TextYAlignment.Center; l.Parent=MinPill
        local textShimmer = Instance.new("UIGradient", l)
        textShimmer.Name = "N0T_VX_Shimmer"
        textShimmer.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(120,125,135)),
            ColorSequenceKeypoint.new(0.35, Color3.fromRGB(245,245,250)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(0.65, Color3.fromRGB(245,245,250)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(120,125,135))
        })
        textShimmer.Offset = Vector2.new(-1,0)
        task.spawn(function()
            while l.Parent do
                textShimmer.Offset = Vector2.new(-1,0)
                local tw = TweenService:Create(textShimmer, TweenInfo.new(0.9, Enum.EasingStyle.Linear), {Offset=Vector2.new(1,0)})
                tw:Play()
                task.wait(0.95)
            end
        end)
        local b=Instance.new("TextButton"); b.ZIndex=42; b.Size=UDim2.new(1,0,1,0); b.BackgroundTransparency=1; b.Text=""; b.AutoButtonColor=false; b.Parent=MinPill
        b.MouseEnter:Connect(function() TweenService:Create(MinPill,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(35,38,45)}):Play() end)
        b.MouseLeave:Connect(function() TweenService:Create(MinPill,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(14,14,18)}):Play() end)
        b.MouseButton1Click:Connect(function()
            MinPill.Visible=false; Frame.Visible=true
            M.menuOpen = true
            pcall(saveCherryConfig)
        end)
    end

    MinBtn.MouseButton1Click:Connect(closeUI)

    
    do
        saveOpenButtonPosition = function()
            local p = MinPill.Position
            M.openButtonPosition = {xScale=p.X.Scale, xOffset=p.X.Offset, yScale=p.Y.Scale, yOffset=p.Y.Offset}
            local f = Frame.Position
            M.menuPosition = {xScale=f.X.Scale, xOffset=f.X.Offset, yScale=f.Y.Scale, yOffset=f.Y.Offset}
            pcall(saveCherryConfig)
        end
        local function makeDrag(obj, target)
            local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
            obj.InputBegan:Connect(function(i)
                if M.uiLocked then return end
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                    dragging=true; dragStart=i.Position; startPos=target.Position
                    i.Changed:Connect(function()
                        if i.UserInputState==Enum.UserInputState.End then
                            dragging=false
                            if target == MinPill and M.uiLocked then saveOpenButtonPosition() end
                        end
                    end)
                end
            end)
            obj.InputChanged:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
                    dragInput=i
                end
            end)
            UIS.InputChanged:Connect(function(i)
                if M.uiLocked then dragging=false end
                if dragging and i==dragInput then
                    local delta=i.Position-dragStart
                    target.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
                end
            end)
        end
        makeDrag(Header, Frame)
        local openDragHandle = MinPill:FindFirstChildWhichIsA("TextButton") or MinPill
        makeDrag(openDragHandle, MinPill)
    end

    
    M._anyKeyListening = false
    local activeKBBtn = nil
    M.keybindButtons = M.keybindButtons or {}
    local listeningTimeout = nil

    local function resetKeybindCapture()
        if activeKBBtn then
            for e,b in pairs(M.keybindButtons) do
                if b == activeKBBtn then
                    local parts = {}
                    if e.kb then table.insert(parts, e.kb.Name) end
                    if e.gp then table.insert(parts, e.gp.Name) end
                    b.Text = (#parts > 0) and table.concat(parts, " / ") or "..."
                    b.TextColor3 = UI_TEXT_DIM
                    break
                end
            end
            activeKBBtn = nil
            M._anyKeyListening = false
            if listeningTimeout then task.cancel(listeningTimeout); listeningTimeout = nil end
        end
    end

    local function formatKeybindText(entry)
        if not entry then return "..." end
        local parts = {}
        if entry.kb then table.insert(parts, entry.kb.Name) end
        if entry.gp then table.insert(parts, entry.gp.Name) end
        if #parts == 0 then return "..." end
        return table.concat(parts, " / ")
    end

    local function isGamepadInputType(uit)
        return uit == Enum.UserInputType.Gamepad1
            or uit == Enum.UserInputType.Gamepad2
            or uit == Enum.UserInputType.Gamepad3
            or uit == Enum.UserInputType.Gamepad4
            or uit == Enum.UserInputType.Gamepad5
            or uit == Enum.UserInputType.Gamepad6
            or uit == Enum.UserInputType.Gamepad7
            or uit == Enum.UserInputType.Gamepad8
    end

    local function uiKeybindRow(parent, label, kbEntry)
        local r = Instance.new("Frame"); r.ClipsDescendants = true; r.Size = UDim2.new(1,0,0,56)
        r.BackgroundColor3 = UI_ROW_BG; r.BackgroundTransparency = 0.1; r.BorderSizePixel = 0; r.Parent = parent; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,13,0,0); l.Size=UDim2.new(0.42,0,0,56); l.BackgroundTransparency=1
        l.Text=label; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=15; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local btn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-156,0.5,-15), Size=UDim2.new(0,146,0,32),
            Text=formatKeybindText(kbEntry),
            Col=UI_TEXT_DIM, TS=12, CR=6})
        M.keybindButtons[kbEntry] = btn

        btn.MouseButton1Click:Connect(function()
            if activeKBBtn and activeKBBtn ~= btn then resetKeybindCapture() end
            activeKBBtn = btn
            btn.Text = "Press key / button..."
            btn.TextColor3 = Color3.fromRGB(150,150,150)
            M._anyKeyListening = true
            if listeningTimeout then task.cancel(listeningTimeout) end
            listeningTimeout = task.delay(8, resetKeybindCapture)
        end)
        return r
    end

    local function kbMatch(entry, keycode)
        if not entry or not keycode or keycode == Enum.KeyCode.Unknown then return false end
        if entry.kb and entry.kb == keycode then return true end
        if entry.gp and entry.gp == keycode then return true end
        return false
    end

    M._keybindCaptureConn = UIS.InputBegan:Connect(function(input, gameProcessed)
        if M._anyKeyListening then
            if activeKBBtn then
                local kc = input.KeyCode
                if kc == Enum.KeyCode.Escape then
                    resetKeybindCapture(); pcall(saveCherryConfig); return
                end
                local uit = input.UserInputType
                if uit == Enum.UserInputType.Keyboard and kc ~= Enum.KeyCode.Unknown then
                    for e,b in pairs(M.keybindButtons) do
                        if b == activeKBBtn then
                            e.kb = kc
                            b.Text = formatKeybindText(e)
                            b.TextColor3 = UI_TEXT_DIM
                            activeKBBtn = nil; M._anyKeyListening = false
                            if listeningTimeout then task.cancel(listeningTimeout); listeningTimeout = nil end
                            pcall(saveCherryConfig)
                            break
                        end
                    end
                elseif isGamepadInputType(uit) and kc ~= Enum.KeyCode.Unknown then
                    for e,b in pairs(M.keybindButtons) do
                        if b == activeKBBtn then
                            e.gp = kc
                            b.Text = formatKeybindText(e)
                            b.TextColor3 = UI_TEXT_DIM
                            activeKBBtn = nil; M._anyKeyListening = false
                            if listeningTimeout then task.cancel(listeningTimeout); listeningTimeout = nil end
                            pcall(saveCherryConfig)
                            break
                        end
                    end
                end
            end
            return
        end

        if gameProcessed then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard and not isGamepadInputType(input.UserInputType) then return end
        local kc = input.KeyCode
        if kc == Enum.KeyCode.Unknown then return end

        if kbMatch(M.KB.LaggerToggle, kc) then
            local now = tick()
            if not M._lastLaggerBindPress or now - M._lastLaggerBindPress > 0.15 then
                M._lastLaggerBindPress = now
                M.cycleLaggerModeBind()
            end
            return
        end
        if kbMatch(M.KB.SpeedToggle, kc) then M.toggleCarryMode(); saveCherryConfig() end
        if kbMatch(M.KB.DropBrainrot, kc) then M.runDrop() end
        if kbMatch(M.KB.TPFloor, kc) then M.runTPFloor() end
        if kbMatch(M.KB.AutoLeft, kc) then
            M.autoLeftEnabled = not M.autoLeftEnabled
            if M.autoLeftEnabled then
                if M.autoRightEnabled then M.autoRightEnabled = false; M.stopAutoRight() end
                if M.autoBatEnabled then M.stopBatAimbot() end
                M.startAutoLeft()
            else M.stopAutoLeft() end
            if M.autoLeftSetVisual then M.autoLeftSetVisual(M.autoLeftEnabled) end
            if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(M.autoLeftEnabled) end
            saveCherryConfig()
        end
        if kbMatch(M.KB.AutoRight, kc) then
            M.autoRightEnabled = not M.autoRightEnabled
            if M.autoRightEnabled then
                if M.autoLeftEnabled then M.autoLeftEnabled = false; M.stopAutoLeft() end
                if M.autoBatEnabled then M.stopBatAimbot() end
                M.startAutoRight()
            else M.stopAutoRight() end
            if M.autoRightSetVisual then M.autoRightSetVisual(M.autoRightEnabled) end
            if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(M.autoRightEnabled) end
            saveCherryConfig()
        end
        if kbMatch(M.KB.AutoBat, kc) then
            if not M.autoBatEnabled then
                if M.autoLeftEnabled then M.autoLeftEnabled = false; M.stopAutoLeft() end
                if M.autoRightEnabled then M.autoRightEnabled = false; M.stopAutoRight() end
                M.queueAutoBatStart()
            else M.stopBatAimbot() end
            if M.autoBatSetVisual then M.autoBatSetVisual(M.autoBatEnabled) end
            if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(M.autoBatEnabled) end
            saveCherryConfig()
        end
        if kbMatch(M.KB.BypassAimbot, kc) then
            M.toggleBypassAimbot()
            if M.setBypassVisual then M.setBypassVisual(M.bypassAimbotEnabled) end
            if M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(M.bypassAimbotEnabled) end
            saveCherryConfig()
        end
        if kbMatch(M.KB.BatV2, kc) then
            if M.batV2Enabled then
                M.stopBatV2()
            else
                if M.autoBatEnabled then M.stopBatAimbot() end
                if M.bypassAimbotEnabled then M.stopBypassAimbot() end
                M.startBatV2()
            end
            if M.setBatV2Visual then M.setBatV2Visual(M.batV2Enabled) end
            if M.mobBtnRefs and M.mobBtnRefs.batV2 then M.mobBtnRefs.batV2(M.batV2Enabled) end
            saveCherryConfig()
        end
        if kbMatch(M.KB.AutoGrab, kc) then
            if M.Steal.AutoStealEnabled then M.stopAutoSteal() else M.startAutoSteal() end
            if M.setInstaGrab then M.setInstaGrab(M.Steal.AutoStealEnabled) end
            saveCherryConfig()
        end
        if kbMatch(M.KB.AutoMedusa, kc) then
            if M.autoMedusaEnabled then M.stopAutoMedusa() else M.startAutoMedusa() end
            if M.setAutoMedusaVisual then M.setAutoMedusaVisual(M.autoMedusaEnabled) end
            if M.mobBtnRefs and M.mobBtnRefs.autoMedusa then M.mobBtnRefs.autoMedusa(M.autoMedusaEnabled) end
            saveCherryConfig()
        end
        if kbMatch(M.KB.ESPPlayer, kc) then
            M.espPlayerEnabled = not M.espPlayerEnabled
            if M.espPlayerEnabled then
                pcall(function() M.updatePlayerESP() end)
            else
                for _, data in pairs(M.playerESPList) do
                    if data and data.gui then data.gui.Visible = false end
                end
            end
            saveCherryConfig()
        end
        if kbMatch(M.KB.BatV2, kc) then
            if M.batV2Enabled then
                M.stopBatV2()
            else
                if M.autoBatEnabled then M.stopBatAimbot() end
                if M.bypassAimbotEnabled then M.stopBypassAimbot() end
                M.startBatV2()
            end
            if M.setBatV2Visual then M.setBatV2Visual(M.batV2Enabled) end
            if M.mobBtnRefs and M.mobBtnRefs.batV2 then M.mobBtnRefs.batV2(M.batV2Enabled) end
            saveCherryConfig()
        end
        if kbMatch(M.KB.AutoGrab, kc) then
            if M.Steal.AutoStealEnabled then M.stopAutoSteal() else M.startAutoSteal() end
            if M.setInstaGrab then M.setInstaGrab(M.Steal.AutoStealEnabled) end
            saveCherryConfig()
        end
        if kbMatch(M.KB.AutoMedusa, kc) then
            if M.autoMedusaEnabled then M.stopAutoMedusa() else M.startAutoMedusa() end
            if M.setAutoMedusaVisual then M.setAutoMedusaVisual(M.autoMedusaEnabled) end
            if M.mobBtnRefs and M.mobBtnRefs.autoMedusa then M.mobBtnRefs.autoMedusa(M.autoMedusaEnabled) end
            saveCherryConfig()
        end
        if kbMatch(M.KB.ESPPlayer, kc) then
            M.espPlayerEnabled = not M.espPlayerEnabled
            if M.espPlayerEnabled then
                pcall(function() M.updatePlayerESP() end)
            else
                for _, data in pairs(M.playerESPList) do
                    if data and data.gui then data.gui.Visible = false end
                end
            end
            saveCherryConfig()
        end
        if kbMatch(M.KB.AntiAnti, kc) then
            M.toggleAntiAntiDesync()
            if M.mobBtnRefs and M.mobBtnRefs.antiAnti then M.mobBtnRefs.antiAnti(M.aadEnabled) end
            saveCherryConfig()
        end
        if kbMatch(M.KB.GuiHide, kc) then
            if Frame then
                Frame.Visible = not Frame.Visible
                MinPill.Visible = not Frame.Visible
                M.menuOpen = Frame.Visible == true
                pcall(saveCherryConfig)
            end
        end
    end)

    
    uiSectionHeader(PM, "SPEEDS")
    local _, nsBox = uiNumberRow(PM, "Normal Speed", M.NS, 1, 500, function(v) M.NS = v end)
    local _, csBox = uiNumberRow(PM, "Carry Speed", M.CS, 1, 500, function(v) M.CS = v end)
    M.normalBox = nsBox; M.carryBox = csBox

    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PM; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(1,-74,1,0)
        l.BackgroundTransparency=1; l.Text="Carry Mode"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=14; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local carryBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-100,0.5,-13), Size=UDim2.new(0,88,0,26),
            Text=M.carrySpeedActive and "Carry On" or "Carry Off", Col=UI_TEXT_PRIMARY, TS=12, CR=6, SC=UI_ACCENT, STr=0.3})
        carryBtn.MouseButton1Click:Connect(function()
            M.carrySpeedActive = not M.carrySpeedActive
            carryBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off"
            M.refreshSpeedModeLabel()
            if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
            if M.mobBtnRefs.laggerCarry then M.mobBtnRefs.laggerCarry(M.laggerCarryActive) end
            if M.carryModeBtn then M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off" end
            if M.laggerCarryBtn then M.laggerCarryBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off" end
            saveCherryConfig()
        end)
        M.carryModeBtn = carryBtn
    end

    local _, setAutoCarry = uiToggleRow(PM, "Auto Carry Speed", M.autoSwitchSpeedEnabled, function(on)
        M.autoSwitchSpeedEnabled = on
        M._autoSwitchWasSteal = nil
        if not on then
            if M.carryModeBtn then
                M.carryModeBtn.Text = M.carrySpeedActive and "Carry On" or "Carry Off"
            end
            if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
        end
        M.refreshWalkSpeedAutoSwitch()
        saveCherryConfig()
    end)
    M.setAutoCarryVisual = setAutoCarry

    local _, setAutoTurnOff = uiToggleRow(PM, "Auto Turn Off Speed", M.autoTurnOffSpeedEnabled, function(on)
        M.autoTurnOffSpeedEnabled = on
        M.refreshWalkSpeedAutoSwitch()
        saveCherryConfig()
    end)
    M.setAutoTurnOffVisual = setAutoTurnOff

    local _, setAutoLagSwitch = uiToggleRow(PM, "Auto Switch Lagger Speed", M.autoSwitchLaggerSpeedEnabled, function(on)
        M.autoSwitchLaggerSpeedEnabled = on
        M.refreshWalkSpeedAutoSwitch()
        saveCherryConfig()
    end)
    M.setAutoSwitchLaggerVisual = setAutoLagSwitch

    uiSectionHeader(PM, "LAGGER")
    local _, lsBox = uiNumberRow(PM, "Lagger Normal", M.LAGGER_SPEED, 1, 500, function(v) M.LAGGER_SPEED = v end)
    local _, lcBox = uiNumberRow(PM, "Lagger Carry", math.min(M.LAGGER_CARRY_SPEED,23), 1, 23, function(v) M.LAGGER_CARRY_SPEED = math.min(v,23) end)

    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PM; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(1,-74,1,0)
        l.BackgroundTransparency=1; l.Text="Lagger Mode"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=14; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local modeBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-100,0.5,-13), Size=UDim2.new(0,88,0,26),
            Text=M.laggerModeEnabled and "Lag On" or "Lag Off", Col=UI_TEXT_PRIMARY, TS=12, CR=6, SC=UI_ACCENT, STr=0.3})
        modeBtn.MouseButton1Click:Connect(function()
            M.toggleLaggerMode()
            modeBtn.Text = M.laggerModeEnabled and "Lag On" or "Lag Off"
        end)
        M.laggerModeBtn = modeBtn
    end

    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PM; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(1,-74,1,0)
        l.BackgroundTransparency=1; l.Text="Lagger Carry Mode"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=14; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local modeBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-100,0.5,-13), Size=UDim2.new(0,88,0,26),
            Text=M.laggerCarryActive and "L.Carry On" or "L.Carry Off", Col=UI_TEXT_PRIMARY, TS=12, CR=6, SC=UI_ACCENT, STr=0.3})
        modeBtn.MouseButton1Click:Connect(function()
            M.toggleLaggerCarry()
            modeBtn.Text = M.laggerCarryActive and "L.Carry On" or "L.Carry Off"
        end)
        M.laggerCarryBtn = modeBtn
    end

    
    uiSectionHeader(PMech, "COMBAT")
    local _, setBatAimbot = uiToggleRow(PMech, "Bat Aimbot", M.autoBatEnabled, function(on)
        if on then M.queueAutoBatStart() else M.stopBatAimbot() end
    end)
    M.autoBatSetVisual = setBatAimbot

    local _, setBatCounter = uiToggleRow(PMech, "Bat Counter", M.batCounterEnabled, function(on)
        M.batCounterEnabled = on
        if on then M.startBatCounter() else M.stopBatCounter() end
    end)
    M.setBatCounterVisual = setBatCounter

    local _, setBypassVis = uiToggleRow(PMech, "Bat TP", M.bypassAimbotEnabled, function(on)
        M.bypassAimbotEnabled = on
        if on then M.startBypassAimbot() else M.stopBypassAimbot() end
        if M.setBypassVisual then M.setBypassVisual(on) end
        if M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(on) end
        saveCherryConfig()
    end)
    M.setBypassVisual = setBypassVis

    local _, setPerfectHit = uiToggleRow(PMech, "Perfect Hit", M.perfectHitEnabled, function(on)
        M.setPerfectHit(on)
        saveCherryConfig()
    end)
    M.setPerfectHitVisual = setPerfectHit

    local _, setHardHit = uiToggleRow(PMech, "Hard Hit", M.hardHitEnabled, function(on)
        if on then M.startHardHit() else M.stopHardHit() end
        saveCherryConfig()
    end)
    M.setHardHitVisual = setHardHit

    local _, setAntiDie = uiToggleRow(PMech, "Anti Die", M.antiDieEnabled, function(on)
        if on then M.startAntiDie() else M.stopAntiDie() end
        saveCherryConfig()
    end)
    M.setAntiDieVisual = setAntiDie

    local _, setBatV2 = uiToggleRow(PMech, "Bat V2", M.batV2Enabled, function(on)
        if on then M.startBatV2() else M.stopBatV2() end
        if M.setBatV2Visual then M.setBatV2Visual(on) end
        saveCherryConfig()
    end)
    M.setBatV2Visual = setBatV2

    local _, setAntiRag = uiToggleRow(PMech, "Anti Ragdoll", M.antiRagdollEnabled, function(on)
        M.antiRagdollEnabled = on
        if on then M.startAntiRagdoll() else M.stopAntiRagdoll() end
    end)
    M.setAntiRagVisual = setAntiRag

    local _, setAntiRagModeUI = uiChoiceRow(PMech, "Anti Ragdoll Mode", {"Splatter","No Splatter"},
        M.antiRagdollMode == "No Splatter" and 2 or 1,
        function(newMode)
            M.antiRagdollMode = (newMode == "No Splatter") and "No Splatter" or "Splatter"
            if M.antiRagdollEnabled then M.stopAntiRagdoll(); M.startAntiRagdoll() end
        end
    )
    M.setAntiRagModeUI = setAntiRagModeUI

    local _, setMedusa = uiToggleRow(PMech, "Medusa Counter", M.medusaCounterEnabled, function(on)
        M.medusaCounterEnabled = on
        if on then M.setupMedusa(player.Character) else M.stopMedusaCounter() end
    end)
    M.setMedusaVisual = setMedusa

    local _, setAutoMedusa = uiToggleRow(PMech, "Auto Medusa", M.autoMedusaEnabled, function(on)
        M.autoMedusaEnabled = on
        if on then M.startAutoMedusa() else M.stopAutoMedusa() end
        if M.setAutoMedusaVisual then M.setAutoMedusaVisual(on) end
        saveCherryConfig()
    end)
    M.setAutoMedusaVisual = setAutoMedusa
    uiNumberRow(PMech, "Auto Medusa Range", M.autoMedusaRange, 5, 100, function(v)
        M.autoMedusaRange = v
        saveCherryConfig()
    end)

    local _, setAutoSwing = uiToggleRow(PMech, "Auto Swing", M.autoSwingEnabled, function(on)
        M.autoSwingEnabled = on
    end)
    M.setAutoSwingVisual = setAutoSwing

    uiSectionHeader(PMech, "STEAL")
    local stealModeLabels = {"V1", "V2", "V3"}
    local function stealLabelToMode(lab)
        if lab == "V2" then return "V2" end
        if lab == "V3" then return "V3" end
        return "V1"
    end
    local function stealModeToLabel(mode)
        if mode == "Semi" or mode == "V2" then return "V2" end
        if mode == "V3" then return "V3" end
        return "V1"
    end
    local stealDefaultIdx = 1
    do
        local lab = stealModeToLabel(M.stealMode)
        for i, v in ipairs(stealModeLabels) do if v == lab then stealDefaultIdx = i break end end
    end

    local _, setAutoSteal, setStealModeUI, regStealSettings = uiExpandToggleRow(
        PMech, "Auto Steal", M.Steal.AutoStealEnabled, stealModeLabels, stealDefaultIdx,
        function(on)
            M.Steal.AutoStealEnabled = on == true
            if on then M.startAutoSteal() else M.stopAutoSteal() end
            saveCherryConfig()
        end,
        function(newLabel)
            local oldMode = M.stealMode
            M.stealMode = stealLabelToMode(newLabel)
            if oldMode ~= M.stealMode and M.Steal.AutoStealEnabled then M.stopAutoSteal(); M.startAutoSteal() end
            M.updateStatusRadius()
            saveCherryConfig()
        end
    )
    M.setInstaGrab = setAutoSteal
    M.setStealModeUI = setStealModeUI

    
    local v1Box = Instance.new("Frame"); v1Box.BackgroundTransparency=1; v1Box.Size=UDim2.new(1,0,0,0); v1Box.AutomaticSize=Enum.AutomaticSize.Y
    local v1Lay = Instance.new("UIListLayout"); v1Lay.Padding=UDim.new(0,6); v1Lay.Parent=v1Box
    local _, srBox = uiNumberRow(v1Box, "Grab Radius", M.Steal.StealRadius, 0.5, 300, function(v)
        M.Steal.StealRadius = v; M.setStealRadius(v); M.updateStatusRadius()
    end)
    M.radInput = srBox
    local _, sdBox = uiNumberRow(v1Box, "Hold Duration", M.Steal.StealDuration, 0.1, 10, function(v)
        M.Steal.StealDuration = v
    end)
    M.durationBox = sdBox
    local _, setAutoRadius = uiToggleRow(v1Box, "Auto Radius", M.autoRadiusEnabled, function(on)
        M.autoRadiusEnabled = on; M.updateStatusRadius()
    end)
    M.setAutoRadiusVisual = nil
    

    
    local v2Box = Instance.new("Frame"); v2Box.BackgroundTransparency=1; v2Box.Size=UDim2.new(1,0,0,0); v2Box.AutomaticSize=Enum.AutomaticSize.Y
    local v2Lay = Instance.new("UIListLayout"); v2Lay.Padding=UDim.new(0,6); v2Lay.Parent=v2Box
    local _, semiRadBox = uiNumberRow(v2Box, "Semi Radius (max 10)", math.min(M.Semi.radius,10), 0.5, 10, function(v)
        M.Semi.radius = math.min(v,10)
        if semiRadBox then semiRadBox.Text = tostring(M.Semi.radius) end
    end)
    M.semiRadInput = semiRadBox
    local _, semiHoldMin = uiNumberRow(v2Box, "Hold Min", M.Semi.holdMin or 1.3, 0.1, 5, function(v) M.Semi.holdMin = v end)
    local _, semiHoldMax = uiNumberRow(v2Box, "Hold Max", M.Semi.holdMax or 2.6, 0.1, 8, function(v) M.Semi.holdMax = v end)
    

    
    local v3Box = Instance.new("Frame"); v3Box.BackgroundTransparency=1; v3Box.Size=UDim2.new(1,0,0,0); v3Box.AutomaticSize=Enum.AutomaticSize.Y
    local v3Lay = Instance.new("UIListLayout"); v3Lay.Padding=UDim.new(0,6); v3Lay.Parent=v3Box
    local _, v3Rad = uiNumberRow(v3Box, "Grab Radius", M.Steal.StealRadius, 0.5, 300, function(v)
        M.Steal.StealRadius = v; M.setStealRadius(v); M.updateStatusRadius()
    end)
    local _, v3Dur = uiNumberRow(v3Box, "Fill Duration", M.Steal.StealDuration, 0.1, 10, function(v)
        M.Steal.StealDuration = v
    end)
    do
        local r = Instance.new("Frame")
        r.ClipsDescendants = true
        r.Size = UDim2.new(1, 0, 0, 46)
        r.BackgroundColor3 = UI_ROW_BG
        r.BackgroundTransparency = 0.1
        r.BorderSizePixel = 0
        r.Parent = v3Box
        uiCardStyle(r)
        local l = Instance.new("TextLabel")
        l.Position = UDim2.new(0, 14, 0, 0)
        l.Size = UDim2.new(0.42, 0, 1, 0)
        l.BackgroundTransparency = 1
        l.Text = "Stop Time (s)"
        l.TextColor3 = UI_TEXT_PRIMARY
        l.TextSize = 13
        l.Font = Enum.Font.GothamMedium
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = r

        local function clampStop(n)
            n = tonumber(n) or 0.35
            return math.clamp(n, 0.1, 30)
        end

        local box = Instance.new("TextBox")
        box.Name = "StopTimeBox"
        box.Position = UDim2.new(1, -118, 0.5, -13)
        box.Size = UDim2.new(0, 52, 0, 26)
        box.BackgroundColor3 = UI_BTN_BG
        box.BorderSizePixel = 0
        box.Text = string.format("%.2f", clampStop(M.Steal.StopTime))
        box.TextColor3 = UI_TEXT_PRIMARY
        box.TextSize = 12
        box.Font = Enum.Font.GothamBold
        box.ClearTextOnFocus = false
        box.Parent = r
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 7)

        local function applyStop(n)
            n = clampStop(n)
            M.Steal.StopTime = n
            box.Text = string.format("%.2f", n)
            saveCherryConfig()
        end

        box.FocusLost:Connect(function()
            applyStop(box.Text)
        end)

        local minus = uiSmallBtn({
            Parent = r, Pos = UDim2.new(1, -158, 0.5, -13), Size = UDim2.new(0, 28, 0, 26),
            Text = "-", Col = UI_TEXT_PRIMARY, TS = 14, CR = 7
        })
        local plus = uiSmallBtn({
            Parent = r, Pos = UDim2.new(1, -54, 0.5, -13), Size = UDim2.new(0, 28, 0, 26),
            Text = "+", Col = UI_TEXT_PRIMARY, TS = 14, CR = 7
        })
        minus.MouseButton1Click:Connect(function()
            applyStop((tonumber(M.Steal.StopTime) or 0.35) - 0.25)
        end)
        plus.MouseButton1Click:Connect(function()
            applyStop((tonumber(M.Steal.StopTime) or 0.35) + 0.25)
        end)

        M.stopTimeBox = box
    end
    local _, setAutoRadius3 = uiToggleRow(v3Box, "Auto Radius", M.autoRadiusEnabled, function(on)
        M.autoRadiusEnabled = on
        M.updateStatusRadius()
    end)
    M.setAutoRadiusVisual = setAutoRadius3
    regStealSettings("V3", v3Box)

    local _, sbBox = uiNumberRow(PMech, "Auto Grab Bar Size", M.stealBarSize, 100, 600, function(v)
        M.stealBarSize = v
        M.buildStatusUI()
    end)

    uiSectionHeader(PMech, "MOTION")
    local jumpDefaultIdx = (M.infJumpMode == "hold") and 2 or 1
    local _, setInfJump, setJumpModeUI = uiExpandToggleRow(
        PMech,
        "Infinite Jump",
        M.infJumpEnabled,
        {"Manual", "Hold"},
        jumpDefaultIdx,
        function(on)
            M.infJumpEnabled = on
            if on and M.infJumpMode == "manual" then M.startManualInfJumpLoop()
            elseif on and M.infJumpMode == "hold" then M.startHoldInfJump()
            else M.stopManualInfJumpLoop(); M.stopHoldInfJump() end
        end,
        function(newMode)
            local wasOn = M.infJumpEnabled
            M.infJumpMode = (newMode == "Hold") and "hold" or "manual"
            if wasOn then
                M.stopManualInfJumpLoop(); M.stopHoldInfJump()
                if M.infJumpMode == "manual" then M.startManualInfJumpLoop()
                else M.startHoldInfJump() end
            end
        end
    )
    M.setInfJumpVisual = setInfJump
    M.setJumpModeUI = setJumpModeUI

    local _, setMirrorTP = uiToggleRow(PMech, "Mirror TP Down", M.mirrorTPDownEnabled, function(on)
        M.setMirrorTPDown(on)
        saveCherryConfig()
    end)
    M.setMirrorTPVisual = setMirrorTP

    local _, setAL = uiToggleRow(PMech, "Auto Left", M.autoLeftEnabled, function(on)
        if on then
            if M.autoRightEnabled then M.autoRightEnabled=false; M.stopAutoRight(); if M.autoRightSetVisual then M.autoRightSetVisual(false) end end
            if M.autoBatEnabled then M.stopBatAimbot(); if M.autoBatSetVisual then M.autoBatSetVisual(false) end end
            M.autoLeftEnabled=true; M.startAutoLeft()
        else M.autoLeftEnabled=false; M.stopAutoLeft() end
        if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(on) end
    end)
    M.autoLeftSetVisual = setAL

    local _, setAR = uiToggleRow(PMech, "Auto Right", M.autoRightEnabled, function(on)
        if on then
            if M.autoLeftEnabled then M.autoLeftEnabled=false; M.stopAutoLeft(); if M.autoLeftSetVisual then M.autoLeftSetVisual(false) end end
            if M.autoBatEnabled then M.stopBatAimbot(); if M.autoBatSetVisual then M.autoBatSetVisual(false) end end
            M.autoRightEnabled=true; M.startAutoRight()
        else M.autoRightEnabled=false; M.stopAutoRight() end
        if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(on) end
    end)
    M.autoRightSetVisual = setAR

    local _, setATP = uiToggleRow(PMech, "Auto TP Down", M.autoTPEnabled, function(on)
        M.autoTPEnabled = on
        if on then M.startAutoTP() else M.stopAutoTP() end
        if M.mobBtnRefs.autoTpDown then M.mobBtnRefs.autoTpDown(on) end
        saveCherryConfig()
    end)
    M.setAutoTPVisual = function(on)
        setATP(on)
        if M.mobBtnRefs.autoTpDown then M.mobBtnRefs.autoTpDown(on) end
    end

    local _, tpHBox = uiNumberRow(PMech, "TP Height", M.autoTPHeight, 1, 100, function(v) M.autoTPHeight = v end)
    M.autoTPHeightBox = tpHBox

    
    uiSectionHeader(PVis, "SKY & VISION")
    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PVis; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,13,0,0); l.Size=UDim2.new(0.55,0,1,0)
        l.BackgroundTransparency=1; l.Text="Sky Theme"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=13; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local skyLbl = Instance.new("TextLabel"); skyLbl.Position=UDim2.new(0.55,0,0,0); skyLbl.Size=UDim2.new(0.45,-10,1,0)
        skyLbl.BackgroundTransparency=1; skyLbl.Text=M.currentSkyTheme; skyLbl.TextColor3=UI_ACCENT; skyLbl.Font=Enum.Font.GothamBold; skyLbl.TextSize=12; skyLbl.TextXAlignment=Enum.TextXAlignment.Right; skyLbl.Parent=r
        local skyIdx = 1
        for i,t in ipairs(M.SkyOrder) do if t == M.currentSkyTheme then skyIdx = i; break end end
        local btn = Instance.new("TextButton",r); btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Text=""
        btn.Activated:Connect(function()
            skyIdx = skyIdx % #M.SkyOrder + 1
            local t = M.SkyOrder[skyIdx]
            skyLbl.Text = t; M.currentSkyTheme = t; M.CandyApplyCustomSky(t); saveCherryConfig()
        end)
    end
    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PVis; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,13,0,0); l.Size=UDim2.new(0.55,0,1,0)
        l.BackgroundTransparency=1; l.Text="FOV"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=13; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local fovLbl = Instance.new("TextLabel"); fovLbl.Position=UDim2.new(0.55,0,0,0); fovLbl.Size=UDim2.new(0.45,-10,1,0)
        fovLbl.BackgroundTransparency=1; fovLbl.Text=tostring(M.fovValue); fovLbl.TextColor3=UI_ACCENT; fovLbl.Font=Enum.Font.GothamBold; fovLbl.TextSize=12; fovLbl.TextXAlignment=Enum.TextXAlignment.Right; fovLbl.Parent=r
        local fovIdx = 1
        local btn = Instance.new("TextButton",r); btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Text=""
        btn.Activated:Connect(function()
            fovIdx = fovIdx % #M.fovOptions + 1
            M.fovValue = M.fovOptions[fovIdx]; fovLbl.Text = tostring(M.fovValue); M.applyFOV(); saveCherryConfig()
        end)
    end

    uiSectionHeader(PVis, "COLOUR SCHEME")
    do
        local themeNames = {}
        for name in pairs(CHERRY_THEMES) do table.insert(themeNames, name) end
        table.sort(themeNames)
        local cur = CherryConfig.Theme or "MetallicPurple"
        local idx = 1
        for i,n in ipairs(themeNames) do if n == cur then idx = i break end end

        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,56)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PVis; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,13,0,0); l.Size=UDim2.new(0.4,0,1,0)
        l.BackgroundTransparency=1; l.Text="Theme"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=16
        l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local themeLbl = Instance.new("TextLabel"); themeLbl.Position=UDim2.new(0.4,0,0,0); themeLbl.Size=UDim2.new(0.6,-10,1,0)
        themeLbl.BackgroundTransparency=1; themeLbl.Text=cur; themeLbl.TextColor3=UI_ACCENT
        themeLbl.Font=Enum.Font.GothamBold; themeLbl.TextSize=15; themeLbl.TextXAlignment=Enum.TextXAlignment.Right; themeLbl.Parent=r

        local sw = Instance.new("Frame"); sw.Size=UDim2.new(1,0,0,46); sw.BackgroundTransparency=1; sw.Parent=PVis
        local swLay = Instance.new("UIListLayout"); swLay.FillDirection=Enum.FillDirection.Horizontal
        swLay.Padding=UDim.new(0,8); swLay.VerticalAlignment=Enum.VerticalAlignment.Center; swLay.Parent=sw
        local function applyTheme(name)
            local t = CHERRY_THEMES[name]; if not t then return end
            CherryConfig.Theme = name
            M.colorScheme = name
            M._savedTheme = name
            applyAccentFromTheme()
            themeLbl.Text = name
            themeLbl.TextColor3 = t.Accent
            if M.mainFrame then
                M.mainFrame.BackgroundColor3 = UI_BG_DARK
                local st = M.mainFrame:FindFirstChild("MainStroke")
                if st then st.Color = t.Accent end
                local gr = M.mainFrame:FindFirstChild("MainGradient")
                if gr then
                    gr.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, UI_GRAD_TOP),
                        ColorSequenceKeypoint.new(0.45, UI_BG_DARK),
                        ColorSequenceKeypoint.new(1, UI_GRAD_BOT),
                    })
                end
            end
            pcall(function()
                if M.mainFrame then M.recolorBlacksToTheme(M.mainFrame) end
                if M.mobGuiRef then M.recolorBlacksToTheme(M.mobGuiRef) end
                if M.statusGui then M.recolorBlacksToTheme(M.statusGui) end
            end)
            M.applyStealBarTheme(t.Accent)
            M.updateHeadTheme()
            saveCherryConfig()
            
            
            saveCherryConfig()
        end
        for _, name in ipairs(themeNames) do
            local t = CHERRY_THEMES[name]
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(0, 46, 0, 28)
            b.BackgroundColor3 = t.Accent
            b.Text = ""
            b.AutoButtonColor = false
            b.Parent = sw
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
            local st = Instance.new("UIStroke"); st.Color = Color3.fromRGB(255,255,255); st.Transparency = 0.4; st.Parent = b
            b.MouseButton1Click:Connect(function() applyTheme(name) end)
        end
        local btn = Instance.new("TextButton", r); btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Text=""
        btn.Activated:Connect(function()
            idx = idx % #themeNames + 1
            applyTheme(themeNames[idx])
        end)
    end

    uiSectionHeader(PVis, "BACKGROUND")
    uiActionRow(PVis, "Custom Background", function()
        M.openImagePicker("bg")
    end)

    uiSectionHeader(PVis, "ESP")
    uiToggleRow(PVis, "ESP Player", M.espPlayerEnabled, function(on)
        M.espPlayerEnabled = on == true
        if M.espPlayerEnabled then
            pcall(function() M.updatePlayerESP() end)
        else
            for _, d in pairs(M.playerESPList) do
                if d and d.gui then d.gui.Visible = false end
            end
        end
        saveCherryConfig()
    end)
    local _, setLineESP = uiToggleRow(PVis, "ESP Lines", M.lineESPEnabled, function(on)
        M.lineESPEnabled = on
        cherryESPState.LineESP = on
        saveCherryConfig()
    end)

    local _, setHitboxBox = uiToggleRow(PVis, "Hitbox Box", M.hitboxBoxEnabled, function(on)
        M.hitboxBoxEnabled = on == true
        cherryESPState.HitboxBox = M.hitboxBoxEnabled
        saveCherryConfig()
    end)
    M.setHitboxBoxVisual = setHitboxBox
    local _, setSpeedESP = uiToggleRow(PVis, "ESP Speed", M.speedESPEnabled, function(on)
        M.speedESPEnabled = on
        cherryESPState.SpeedESP = on
        saveCherryConfig()
    end)

    local _, setSaturatedColors = uiToggleRow(PVis, "Saturated Colors", M.saturatedColorsEnabled == true, function(on)
        M.saturatedColorsEnabled = on == true
        if M.saturatedColorsEnabled then
            M.enableSaturatedColors()
        else
            M.disableSaturatedColors()
        end
        
        saveCherryConfig()
    end)
    M.setSaturatedColorsVisual = setSaturatedColors
    
    uiSectionHeader(PUtil, "MISC")
    local _, setUnwalk = uiToggleRow(PUtil, "Unwalk", M.unwalkEnabled, function(on)
        M.unwalkEnabled = on
        if on then M.startUnwalk() else M.stopUnwalk() end
    end)
    M.setUnwalkVisual = setUnwalk

    local _, setAntiLag = uiToggleRow(PUtil, "Anti-Lag", M.antiLagEnabled, function(on)
        M.antiLagEnabled = on
        if on then M.enableAntiLag() else M.disableAntiLag() end
        saveCherryConfig()
    end)
    M.setAntiLagVisual = setAntiLag

    local _, setStretch = uiToggleRow(PUtil, "Stretch Rez", M.stretchRezEnabled, function(on)
        M.stretchRezEnabled = on
        if on then M.enableStretchRez() else M.disableStretchRez() end
    end)
    M.setStretchRezVisual = setStretch

    local _, setRemoveAcc = uiToggleRow(PUtil, "Remove Accessories", M.removeAccEnabled, function(on)
        M.removeAccEnabled = on
        if on then M.startRemoveAcc() else M.stopRemoveAcc() end
    end)

    local _, setAntiKick = uiToggleRow(PUtil, "Anti-Kick", M.antiKickEnabled, function(on)
        M.antiKickEnabled = on
        if on then M.enableAntiKick() else M.disableAntiKick() end
        saveCherryConfig()
    end)
    M.antiKickSetVisual = setAntiKick

    local _, setAntiFling = uiToggleRow(PUtil, "Anti-Fling Shield", M.antiFlingEnabled, function(on)
        M.antiFlingEnabled = on == true
        if on then M.enableAntiFling() else M.disableAntiFling() end
        saveCherryConfig()
    end)
    M.setAntiFlingVisual = setAntiFling

    local _, setSafeMode = uiToggleRow(PUtil, "Safe Mode", M.safeModeEnabled, function(on)
        M.safeModeEnabled = on
        if on then M.enableSafeMode() else M.disableSafeMode() end
        saveCherryConfig()
    end)    M.setSafeModeVisual = setSafeMode
    local _, setResetOnDeath = uiToggleRow(PUtil, "Reset on Death", M.resetOnDeathEnabled == true, function(on)
        M.resetOnDeathEnabled = on == true
        M.startAutoResetThreats(player.Character)
        saveCherryConfig()
    end)
    M.setResetOnDeathVisual = setResetOnDeath
    local _, setResetOnMedusa = uiToggleRow(PUtil, "Reset on Medusa", M.resetOnMedusaEnabled == true, function(on)
        M.resetOnMedusaEnabled = on == true
        M.startAutoResetThreats(player.Character)
        saveCherryConfig()
    end)
    M.setResetOnMedusaVisual = setResetOnMedusa
    do
        local fontIdx = 11
        for i, n in ipairs(M.FONT_NAMES) do
            if n == (M.customFontSelected or "None") then fontIdx = i break end
        end
        local _, setFontUI = uiChoiceRow(PUtil, "Custom Font", M.FONT_NAMES, fontIdx, function(v)
            M.applyCustomFont(v)
            saveCherryConfig()
        end)
    end

    local _, setIntroGUI = uiToggleRow(PUtil, "Intro GUI", M.introGUIEnabled, function(on)
        M.introGUIEnabled = on
    end)

    local _, setMobBtns = uiToggleRow(PUtil, "Mobile Buttons", M.mobileButtonsEnabled, function(on)
        M.mobileButtonsEnabled = on
        if on then M.buildCleanTogglePanel() else M.destroyCleanTogglePanel() end
        saveCherryConfig()
    end)

    local _, setCircleBtns = uiToggleRow(PUtil, "Circle Buttons", M.circleButtonsEnabled, function(on)
        M.circleButtonsEnabled = on
        if M.mobileButtonsEnabled then M.buildCleanTogglePanel() end
        saveCherryConfig()
    end)
    M.setCircleBtnsVisual = setCircleBtns

    local _, setSelectiveNoclip = uiToggleRow(PUtil, "Selective Noclip", M.selectiveNoclipEnabled, function(on)
        M.selectiveNoclipEnabled = on == true
        if M.selectiveNoclipEnabled then M.startSelectiveNoclip() else M.stopSelectiveNoclip() end
        saveCherryConfig()
    end)
    M.setSelectiveNoclipVisual = setSelectiveNoclip

    local _, btnSzBox = uiNumberRow(PUtil, "Button Size", M.mobileButtonsSize, 40, 150, function(v)
        M.mobileButtonsSize = math.clamp(tonumber(v) or 100, 40, 150)
        local scaled = math.clamp(math.floor(M.mobileButtonsSize * (M.uiScale or 1)), 40, 300)
        if M.mobGuiRef then
            for _, child in ipairs(M.mobGuiRef:GetChildren()) do
                if child:IsA("TextButton") and child:GetAttribute("BtnKey") then
                    child.Size = UDim2.fromOffset(scaled, scaled)
                    local c = child:FindFirstChildOfClass("UICorner")
                    if c then c.CornerRadius = UDim.new(0, math.clamp(math.floor(scaled * 0.22), 8, 32)) end
                end
            end
        end
        if M.mobileButtonsEnabled then M.buildCleanTogglePanel() end
        saveCherryConfig()
    end)

    local _, menuScaleBox = uiNumberRow(PUtil, "Menu Scale", M.uiScale or 1.0, 0.5, 2.0, function(v)
        M.uiScale = math.clamp(tonumber(v) or 1.0, 0.5, 2.0)
        if M.uiScaleRef then M.uiScaleRef.Scale = M.uiScale end
        saveCherryConfig()
    end)
    menuScaleBox.TextEditable = true
    menuScaleBox.Active = true
    menuScaleBox.ClearTextOnFocus = false

    local _, grabScaleBox = uiNumberRow(PUtil, "Auto Grab Scale", M.grabScale, 0.5, 2.0, function(v)
        M.grabScale = math.clamp(tonumber(v) or 1.0, 0.5, 2.0)
        if M.grabScaleRef then M.grabScaleRef.Scale = M.grabScale end
        if M.Steal and M.Steal.AutoStealEnabled and not M.grabScaleRef then M.buildStatusUI() end
        saveCherryConfig()
    end)

    uiActionRow(PUtil, "Reset Mobile Positions", function() M.resetMobilePositions() end)

    uiSectionHeader(PUtil, "CHARTER")
    local packNames = {}
    for name in pairs(M.PACKS) do table.insert(packNames, name) end
    table.sort(packNames)

    local packDefaultIdx = 1
    for i,v in ipairs(packNames) do if v == M.animPack then packDefaultIdx = i break end end
    local _, setAnimPackToggle, setPackUI = uiExpandToggleRow(
        PUtil,
        "Animation Pack",
        M.animPackEnabled,
        packNames,
        packDefaultIdx,
        function(on)
            M.animPackEnabled = on
            if on then M.applyAnimPack(M.animPack)
            else local char=player.Character; if char then M.resetAnimations(char) end end
            saveCherryConfig()
        end,
        function(v)
            M.animPack = v
            if M.animPackEnabled then M.applyAnimPack(v) end
            saveCherryConfig()
        end
    )
    M.setPackModeUI = setPackUI

    uiActionRow(PUtil, "Apply Animation Pack", function()
        if M.animPackEnabled then M.applyAnimPack(M.animPack) end
        saveCherryConfig()
    end)

    local _, setHeadless = uiToggleRow(PUtil, "Headless", M.headlessEnabled, function(on)
        M.headlessEnabled = on
        M.applyHeadlessToChar(player.Character, on)
        saveCherryConfig()
    end)
    local _, setKorblox = uiToggleRow(PUtil, "Korblox", M.korbloxEnabled, function(on)
        M.korbloxEnabled = on
        M.applyKorbloxToChar(player.Character, on)
        saveCherryConfig()
    end)

    uiSectionHeader(PUtil, "PANELS")
    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PUtil; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(1,-74,1,0)
        l.BackgroundTransparency=1; l.Text="Save Config"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=14; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local sBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-80,0.5,-13), Size=UDim2.new(0,68,0,26),
            Text="SAVE", Col=Color3.fromRGB(200,200,200), TS=12, CR=6, SC=Color3.fromRGB(40,40,40), STr=0.2})
        sBtn.Activated:Connect(function()
            saveCherryConfig()
            sBtn.Text = "OK"
            task.delay(0.8, function() if sBtn and sBtn.Parent then sBtn.Text = "SAVE" end end)
        end)
    end
    do
        local r = Instance.new("Frame"); r.ClipsDescendants=true; r.Size=UDim2.new(1,0,0,46)
        r.BackgroundColor3=UI_ROW_BG; r.BackgroundTransparency=0.03; r.BorderSizePixel=0; r.Parent=PUtil; uiCardStyle(r)
        local l = Instance.new("TextLabel"); l.Position=UDim2.new(0,14,0,0); l.Size=UDim2.new(1,-74,1,0)
        l.BackgroundTransparency=1; l.Text="Reset All Settings"; l.TextColor3=UI_TEXT_PRIMARY; l.TextSize=14; l.Font=Enum.Font.GothamMedium; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=r
        local rBtn = uiSmallBtn({Parent=r, Pos=UDim2.new(1,-80,0.5,-13), Size=UDim2.new(0,68,0,26),
            Text="RESET", Col=Color3.fromRGB(200,200,200), TS=12, CR=6, SC=Color3.fromRGB(40,40,40), STr=0.2})
        rBtn.Activated:Connect(function() M.resetAllSettings() end)
    end

    
    uiSectionHeader(PMusic, "MUSIC")
    local _, setSongUI = uiChoiceRow(PMusic, "Songs", M.SONG_NAMES, M.songChoice, function(v)
        for i, name in ipairs(M.SONG_NAMES) do
            if name == v then
                M.selectSong(i)
                break
            end
        end
        saveCherryConfig()
    end)
    M.setSongUI = setSongUI
    uiActionRow(PMusic, "Pause / Resume Music", function()
        M.toggleSongPause()
    end)
    
    local Jukebox = Instance.new("Frame")
    Jukebox.Name = "S1NXY_Jukebox"
    Jukebox.Size = UDim2.new(1, -8, 0, 230)
    Jukebox.BackgroundColor3 = Color3.fromRGB(3, 12, 8)
    Jukebox.BackgroundTransparency = 0.08
    Jukebox.BorderSizePixel = 0
    Jukebox.LayoutOrder = 20
    Jukebox.Parent = PMusic
    uiCardStyle(Jukebox)
    local JukeboxTitle = Instance.new("TextLabel")
    JukeboxTitle.Size = UDim2.new(1, -24, 0, 30)
    JukeboxTitle.Position = UDim2.new(0, 12, 0, 10)
    JukeboxTitle.BackgroundTransparency = 1
    JukeboxTitle.Text = "7UP // JUKEBOX"
    JukeboxTitle.TextColor3 = UI_ACCENT
    JukeboxTitle.Font = Enum.Font.GothamBlack
    JukeboxTitle.TextSize = 18
    JukeboxTitle.TextXAlignment = Enum.TextXAlignment.Left
    JukeboxTitle.Parent = Jukebox
    local JukeboxSong = Instance.new("TextLabel")
    JukeboxSong.Name = "CurrentSong"
    JukeboxSong.Size = UDim2.new(1, -24, 0, 52)
    JukeboxSong.Position = UDim2.new(0, 12, 0, 48)
    JukeboxSong.BackgroundColor3 = Color3.fromRGB(0, 20, 12)
    JukeboxSong.BackgroundTransparency = 0.12
    JukeboxSong.Text = (M.SONG_NAMES and M.SONG_NAMES[M.songChoice]) or "No song"
    JukeboxSong.TextColor3 = UI_TEXT_WHITE
    JukeboxSong.Font = Enum.Font.GothamBold
    JukeboxSong.TextSize = 16
    JukeboxSong.TextXAlignment = Enum.TextXAlignment.Left
    JukeboxSong.Parent = Jukebox
    Instance.new("UICorner", JukeboxSong).CornerRadius = UDim.new(0, 12)
    local function jukeboxButton(text, pos, callback)
        local b = uiSmallBtn({Parent=Jukebox, Pos=pos, Size=UDim2.new(0,82,0,34), Text=text, Col=UI_ACCENT, TS=13, CR=14, SC=UI_ACCENT, STr=0.05})
        b.Activated:Connect(callback)
        return b
    end
    jukeboxButton("<<", UDim2.new(0, 18, 0, 116), function() M.jukeboxPrevious(); JukeboxSong.Text = M.SONG_NAMES[M.songChoice] or "No song" end)
    jukeboxButton("PLAY", UDim2.new(0.5, -41, 0, 116), function() M.toggleSongPause(); JukeboxSong.Text = M.SONG_NAMES[M.songChoice] or "No song" end)
    jukeboxButton(">>", UDim2.new(1, -100, 0, 116), function() M.jukeboxNext(); JukeboxSong.Text = M.SONG_NAMES[M.songChoice] or "No song" end)
    local loopButton = jukeboxButton("LOOP OFF", UDim2.new(0, 18, 0, 174), function()
        local on = M.jukeboxToggleLoop()
        loopButton.Text = on and "LOOP ON" or "LOOP OFF"
    end)
    jukeboxButton("QUIETER", UDim2.new(0.5, -130, 0, 174), function() M.jukeboxSetVolume((jukeboxVolume or 0.75) - 0.1) end)
    jukeboxButton("LOUDER +", UDim2.new(1, -100, 0, 174), function() M.jukeboxSetVolume((jukeboxVolume or 0.75) + 0.1) end)

    
    uiSectionHeader(PIntros, "INTROS")
    local _, setIntro = uiToggleRow(PIntros, "Intro Song", M.introSoundEnabled, function(on)
        M.introSoundEnabled = on
        if not on and introSoundInstance and introSoundInstance.IsPlaying then
            pcall(function() introSoundInstance:Stop() end)
        end
    end)

    local musicDefault = math.clamp(tonumber(M.introSongChoice) or 1, 1, #M.INTRO_MUSIC_NAMES)
    local _, setIntroSongUI = uiChoiceRow(PIntros, "Intro Music", M.INTRO_MUSIC_NAMES,
        musicDefault,
        function(v)
            for i, name in ipairs(M.INTRO_MUSIC_NAMES) do
                if name == v then M.introSongChoice = i; break end
            end
            saveCherryConfig()
        end
    )
    M.setIntroSongUI = setIntroSongUI
    uiActionRow(PIntros, "Preview Intro Music", function()
        M.previewIntroMusic()
    end)

    
    uiSectionHeader(PKB, "TECLAS")
    uiKeybindRow(PKB, "Hide GUI",       M.KB.GuiHide)
    uiKeybindRow(PKB, "Carry Mode",     M.KB.SpeedToggle)
    uiKeybindRow(PKB, "Lagger Mode",    M.KB.LaggerToggle)
    uiKeybindRow(PKB, "Bat Aimbot",     M.KB.AutoBat)
    uiKeybindRow(PKB, "Bat TP",         M.KB.BypassAimbot)
    uiKeybindRow(PKB, "Bat V2",         M.KB.BatV2)
    uiKeybindRow(PKB, "Auto Grab",      M.KB.AutoGrab)
    uiKeybindRow(PKB, "Auto Medusa",    M.KB.AutoMedusa)
    uiKeybindRow(PKB, "ESP Player",     M.KB.ESPPlayer)
    uiKeybindRow(PKB, "ANTI ANTI BYPASS", M.KB.AntiAnti)
    uiKeybindRow(PKB, "Auto Left",      M.KB.AutoLeft)
    uiKeybindRow(PKB, "Auto Right",     M.KB.AutoRight)
    uiKeybindRow(PKB, "Drop Brainrot",  M.KB.DropBrainrot)
    uiKeybindRow(PKB, "TP Down",        M.KB.TPFloor)

    
    
    do
        local introPlaying = M._introActive == true
        local open = false
        Frame.Visible = false
        MinPill.Visible = true
        M.menuOpen = open
    end

    
    M.applyStealBarTheme(CHERRY_ACCENT)
    M.updateHeadTheme()
    M.applyFOV()

    M.autoTPHeightBox = tpHBox
    M.radInput = srBox
    M.durationBox = sdBox
    M.btnSzBox = btnSzBox
    M.sbBox = sbBox

    if M.setAntiRagVisual then M.setAntiRagVisual(M.antiRagdollEnabled) end
    if M.setSafeModeVisual then M.setSafeModeVisual(M.safeModeEnabled) end
    if M.setAutoCarryVisual then M.setAutoCarryVisual(M.autoSwitchSpeedEnabled) end
    if M.setCircleBtnsVisual then M.setCircleBtnsVisual(M.circleButtonsEnabled) end
    if M.customFontSelected and M.customFontSelected ~= "None" then
        task.defer(function() pcall(function() M.applyCustomFont(M.customFontSelected) end) end)
    end
    if M.setMirrorTPVisual then M.setMirrorTPVisual(M.mirrorTPDownEnabled) end
    if M.safeModeEnabled then M.enableSafeMode() end
    if M.antiKickEnabled then M.enableAntiKick() end

    if M.setAntiRagModeUI then M.setAntiRagModeUI(M.antiRagdollMode == "No Splatter" and "No Splatter" or "Splatter") end
    if M.setInfJumpVisual then M.setInfJumpVisual(M.infJumpEnabled) end
    if M.setMedusaVisual then M.setMedusaVisual(M.medusaCounterEnabled) end
    if M.setAutoMedusaVisual then M.setAutoMedusaVisual(M.autoMedusaEnabled) end
    if M.setBatCounterVisual then M.setBatCounterVisual(M.batCounterEnabled) end
    if M.setUnwalkVisual then M.setUnwalkVisual(M.unwalkEnabled) end
    if M.setAntiLagVisual then M.setAntiLagVisual(M.antiLagEnabled) end
    if M.setStretchRezVisual then M.setStretchRezVisual(M.stretchRezEnabled) end
    if M.setAutoTPVisual then M.setAutoTPVisual(M.autoTPEnabled) end
    if M.antiKickSetVisual then M.antiKickSetVisual(M.antiKickEnabled) end
    if M.setInstaGrab then M.setInstaGrab(M.Steal.AutoStealEnabled) end
    if M.setAutoRadiusVisual then M.setAutoRadiusVisual(M.autoRadiusEnabled) end
    if M.autoBatSetVisual then M.autoBatSetVisual(M.autoBatEnabled) end
    if M.autoLeftSetVisual then M.autoLeftSetVisual(M.autoLeftEnabled) end
    if M.autoRightSetVisual then M.autoRightSetVisual(M.autoRightEnabled) end
    if M.setAutoSwingVisual then M.setAutoSwingVisual(M.autoSwingEnabled) end
    if M.setBypassVisual then M.setBypassVisual(M.bypassAimbotEnabled) end
    if M.setBatV2Visual then M.setBatV2Visual(M.batV2Enabled) end
    if M.mobBtnRefs.autoBat then M.mobBtnRefs.autoBat(M.autoBatEnabled) end
    if M.mobBtnRefs.autoLeft then M.mobBtnRefs.autoLeft(M.autoLeftEnabled) end
    if M.mobBtnRefs.autoRight then M.mobBtnRefs.autoRight(M.autoRightEnabled) end
    if M.mobBtnRefs.carrySpeed then M.mobBtnRefs.carrySpeed(M.carrySpeedActive) end
    if M.mobBtnRefs.lagger then M.mobBtnRefs.lagger(M.laggerModeEnabled) end
    if M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(M.bypassAimbotEnabled) end
    if M.headlessEnabled then M.applyHeadlessToChar(player.Character, true) end
    if M.korbloxEnabled then M.applyKorbloxToChar(player.Character, true) end
    if M.setStealModeUI then
        local lab = "V1"
        if M.stealMode == "Semi" or M.stealMode == "V2" then lab = "V2"
        elseif M.stealMode == "V3" then lab = "V3" end
        M.setStealModeUI(lab)
    end
    if M.setJumpModeUI then M.setJumpModeUI(M.infJumpMode == "hold" and "Hold" or "Manual") end
    if M.setPackModeUI and M.animPack then M.setPackModeUI(M.animPack) end
    if M.animPackEnabled then
        task.wait(0.5); M.applyAnimPack(M.animPack)
    else
        local char = player.Character; if char then M.resetAnimations(char) end
    end
    cherryESPState.LineESP = M.lineESPEnabled
    cherryESPState.SpeedESP = M.speedESPEnabled
    cherryESPState.HitboxBox = M.hitboxBoxEnabled
    M.updateStatusRadius()
    M.startHeadSpeedUpdates()
end

function M.applyStealBarTheme(accentColor)
    local col = M.stealBarColor or accentColor or UI_ACCENT or CHERRY_ACCENT or Color3.fromRGB(255, 255, 255)
    if M.statusFill then
        M.statusFill.BackgroundColor3 = col
    end
    if M.statusDot then
        M.statusDot.BackgroundColor3 = col
    end
    if M.statusMain then
        local st = M.statusMain:FindFirstChildOfClass("UIStroke")
        if st then st.Color = col end
    end
end




function M.resetAllSettings()
    M.NS = 60
    M.CS = 30
    M.LAGGER_SPEED = 10.1
    M.LAGGER_CARRY_SPEED = 15
    M.speedMethod = "Velocity"
    M.hyperMult = 4
    M._lastSpeedMethod = nil
    M._anchoredBySpeed = nil
    M.carrySpeedActive = false
    M.laggerModeEnabled = false
    M.laggerCarryActive = false
    M.antiRagdollEnabled = false
    M.antiRagdollMode = "Splatter"
    M.infJumpEnabled = false
    M.infJumpMode = "manual"
    M.medusaCounterEnabled = false
    M.autoMedusaEnabled = false
    M.autoMedusaRange = 15
    M.autoMedusaLastUsed = 0
    M.autoMedusaEquipPending = false
    M.batCounterEnabled = false
    M.unwalkEnabled = false
    M.medusaDebounce = false
    M.medusaLastUsed = 0
    M.autoLeftEnabled = false
    M.autoRightEnabled = false
    M.autoBatEnabled = false
    M.autoSwingEnabled = true
    M.autoMoveSwingEnabled = false
    M.antiLagEnabled = false
    M.removeAccessoriesEnabled = false
    M.stretchRezEnabled = false
    M.autoTPEnabled = false
    M.autoTPHeight = 20
    M.guiTransparencyEnabled = false
    M.mobileButtonsEnabled = true
    M.mobileButtonsSize = 100
    M.circleButtonsEnabled = false
    M.selectiveNoclipEnabled = false
    M._selectiveNoclipRestore()
    M.fovValue = 80
    M.fovIndex = 1
    M.autoSwitchSpeedEnabled = false
    M.antiKickEnabled = false
    M.brainrotDetected = false
    M.ragdollGuiEnabled = true
    M.introSoundEnabled = true
    M.introSongChoice = 1
    M.introGUIEnabled = true
    M.Steal.AutoStealEnabled = false
    M.autoRadiusEnabled = false
    M.Steal.StealRadius = 63
    M.Steal.StealDuration = 1.4
    M.Steal.StopTime = 0.35
    M.stealMode = "V1"
    M.Semi.holdMin = 1.3
    M.Semi.holdMax = 2.6
    M.Semi.entryDelay = 0.3
    M.Semi.radius = 10
    M.Semi.primeRange = 80
    M.removeAccEnabled = false
        M.showPlayerSpeeds = false
    M.uiScale = 0.50
    M.perButtonDragEnabled = true
    M.stealBarSize = 300
    M.grabScale = 1.0
    M.stealBarPosition = nil
    M.stealBarColorName = "Red"
    M.stealBarColor = M.STEAL_BAR_COLORS.Red
    M.stealBarBackgroundName = "Black"
    M.stealBarBackgroundColorName = "Black"
    M.lineESPEnabled = false
    M.hitboxBoxEnabled = false
        M.animPack = "Adidas Sports"
    M.headlessEnabled = false
    M.korbloxEnabled = false
    M.bypassAimbotEnabled = false
    M.animPackEnabled = true

    M.stopAutoSteal()
    M.stopBatAimbot()
    M.stopAutoLeft()
    M.stopAutoRight()
    M.stopSelectiveNoclip()
    M.stopAntiAntiDesync()
    M.stopAntiRagdoll()
    M.stopHoldInfJump()
    M.stopManualInfJumpLoop()
    M.stopMedusaCounter()
    M.stopAutoMedusa()
    M.stopBatCounter()
    M.stopUnwalk()
    M.disableAntiLag()
    M.disableStretchRez()
    M.stopAutoTP()
    M.disableAntiKick()
    M.disableAntiFling()
    M.disableSaturatedColors()
    M.stopBypassAimbot()
    M.stopRemoveAcc()
    M.toggleESP(false)
    M.togglePlayerSpeeds(false)

    saveCherryConfig()
    M.buildGui()
end




M._blessTpBatConn = nil
M.bypassAimbotEnabled = M.bypassAimbotEnabled or false
function M.startBlessTpBat()
    if M.batV2Enabled then
        M.stopBatV2()
        M.batV2Enabled = false
        if M.mobBtnRefs and M.mobBtnRefs.batV2 then M.mobBtnRefs.batV2(false) end
        if M.setBatV2Visual then M.setBatV2Visual(false) end
    end
    if M._blessTpBatConn then pcall(function() M._blessTpBatConn:Disconnect() end) end
    M.bypassAimbotEnabled = true
    pcall(function()
        if M.autoBatEnabled then M.autoBatEnabled = false; if M.stopBatAimbot then M.stopBatAimbot() end end
    end)
    M._blessTpBatConn = RunService.Heartbeat:Connect(function()
        if not M.bypassAimbotEnabled then return end
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return end
        local target = M.getClosestTargetAimbot and M.getClosestTargetAimbot() or nil
        if not target or not target.Parent then return end
        if not char:FindFirstChildOfClass("Tool") then
            local bat = M.findBat and M.findBat() or nil
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        if sethiddenproperty then pcall(function() sethiddenproperty(root, "PhysicsRepRootPart", target) end) end
        local targetPos = target.Position + Vector3.new(0, 0.9, 0)
        if (root.Position - targetPos).Magnitude > 8 then root.CFrame = CFrame.new(targetPos) end
        local cam = workspace.CurrentCamera
        if cam then cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position) end
        if M._adaptTpBatTryHit then M._adaptTpBatTryHit() end
    end)
    if M.setBypassVisual then M.setBypassVisual(true) end
    if M.mobBtnRefs and M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(true) end
end
function M.stopBlessTpBat()
    M.bypassAimbotEnabled = false
    if M._blessTpBatConn then pcall(function() M._blessTpBatConn:Disconnect() end); M._blessTpBatConn = nil end
    if M.setBypassVisual then M.setBypassVisual(false) end
    if M.mobBtnRefs and M.mobBtnRefs.bypass then M.mobBtnRefs.bypass(false) end
end
function M.toggleBlessTpBat()
    if M.bypassAimbotEnabled then M.stopBlessTpBat() else M.startBlessTpBat() end
end
M.startBypassAimbot = M.startBlessTpBat
M.stopBypassAimbot = M.stopBlessTpBat
M.toggleBypassAimbot = M.toggleBlessTpBat




repeat task.wait() until game:IsLoaded()
task.wait(0.5)
loadCherryConfig()




if M._savedTheme and CHERRY_THEMES[M._savedTheme] then
    CherryConfig.Theme = M._savedTheme
    M.colorScheme = M._savedTheme
elseif M.colorScheme and CHERRY_THEMES[M.colorScheme] then
    CherryConfig.Theme = M.colorScheme
    M._savedTheme = M.colorScheme
end

applyAccentFromTheme()
pcall(saveCherryConfig)
M.buildGui()




pcall(function()
    if M.applyStealBarTheme then M.applyStealBarTheme(UI_ACCENT) end
    if M.updateHeadTheme then M.updateHeadTheme() end
    if M.mainFrame then M.recolorBlacksToTheme(M.mainFrame) end
    if M.statusGui then M.recolorBlacksToTheme(M.statusGui) end
end)

function M.destroyCleanTogglePanel()
    if M.cleanToggleGui then pcall(function() M.cleanToggleGui:Destroy() end); M.cleanToggleGui = nil end
end

function M.buildCleanTogglePanel()
    M.destroyCleanTogglePanel()
    local gui = Instance.new("ScreenGui")
    gui.Name = "CleanTogglePanel"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() gui.ModalEnabled = false end)
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then gui.Parent = player:WaitForChild("PlayerGui") end
    M.cleanToggleGui = gui
    local frame = Instance.new("Frame", gui)
    frame.Name = "CleanToggles"
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Active = false
    frame.Selectable = false
    frame.Size = UDim2.new(0, 276, 0, 390)
    frame.Position = UDim2.new(1, -280, 0, 50)
    local SILVER = Color3.fromRGB(180,180,190)
    local ACTIVE_YELLOW = Color3.fromRGB(255,205,40)
    local OFF = Color3.fromRGB(10,10,10)
    local OFF_TEXT = Color3.fromRGB(225,225,225)
    local ON_TEXT = Color3.fromRGB(255,255,255)
    local STROKE = Color3.fromRGB(70,70,70)
    local defs = {
        {"InstaReset", "INSTA\nRESET", 0, 0}, {"AutoLeft", "AUTO\nLEFT", 2, 0},
        {"AutoRight", "AUTO\nRIGHT", 3, 0}, {"AutoMedusa", "AUTO\nMEDUSA", 0, 1},
        {"BatTP", "BAT\nTP", 1, 1}, {"TpDown", "TP\nDOWN", 2, 1},
        {"DropBR", "DROP\nBRAINROT", 3, 1}, {"BatV2", "BAT\nV2", 1, 2},
        {"AutoBat", "AUTO\nBAT", 2, 2}, {"CarrySpeed", "CARRY\nSPEED", 3, 2},
        {"Lagger", "LAGGER\n1", 1, 3}, {"LaggerCarry", "LAGGER\n2", 2, 3},
        {"AutoTPDown", "AUTO TP\nDOWN", 3, 3}, {"AntiAnti", "ANTI ANTI\nBYPASS", 0, 4},
    }
    local refs = {}
    local states = {}
    local savedCleanTogglePositions = M.loadBtnPositions()
    local function makeToggle(key, text, index, gridCol, gridRow)
        local b = Instance.new("TextButton", frame)
        b.Name = key
        b.Size = UDim2.new(0, 60, 0, 60)
        local col = gridCol or ((index-1) % 2)
        local row = gridRow or math.floor((index-1) / 2)
        local defaultX = col * 68
        local defaultY = row * 78
        local saved = savedCleanTogglePositions[key]
        local posX = (saved and type(saved.x) == "number") and saved.x or defaultX
        local posY = (saved and type(saved.y) == "number") and saved.y or defaultY
        b.Position = UDim2.new(0, posX, 0, posY)
        b:SetAttribute("BtnKey", key)
        b:SetAttribute("DefaultX", defaultX)
        b:SetAttribute("DefaultY", defaultY)
        b.BackgroundColor3 = OFF
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.Active = true
        b.Selectable = false
        b.Text = ""
        b.ZIndex = 10
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,18)
        local st = Instance.new("UIStroke", b)
        st.Color = STROKE; st.Thickness = 1.2; st.Transparency = 0.4
        local l = Instance.new("TextLabel", b)
        l.BackgroundTransparency = 1
        l.Size = UDim2.fromScale(1,1)
        l.Text = text
        l.TextWrapped = true
        l.Font = Enum.Font.GothamBold
        l.TextSize = 10
        l.TextColor3 = OFF_TEXT
        l.Active = false
        l.Selectable = false
        l.ZIndex = 11
        local on = false
        local function setOn(v)
            on = v == true
            b.BackgroundColor3 = on and ACTIVE_YELLOW or OFF
            l.TextColor3 = on and ON_TEXT or OFF_TEXT
            st.Color = on and ACTIVE_YELLOW or STROKE
            st.Transparency = on and 0 or 0.4
        end
        refs[key] = setOn
        local dragging = false
        local dragStart = nil
        local startPos = nil
        b.InputBegan:Connect(function(input)
            if M.uiLocked then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = b.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        M.saveBtnPositions()
                    end
                end)
            end
        end)
        b.InputChanged:Connect(function(input)
            if dragging and not M.uiLocked and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                b.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if dragging and M.uiLocked then dragging = false end
        end)
        b.Activated:Connect(function()
            if key == "InstaReset" then
                M.runInstantReset(); setOn(true); task.delay(0.25, function() setOn(false) end)
            elseif key == "TpDown" then
                M.runTPFloor(); setOn(true); task.delay(0.25, function() setOn(false) end)
            elseif key == "DropBR" then
                M.runDrop(); setOn(true); task.delay(0.3, function() setOn(false) end)
            elseif key == "AutoLeft" then
                M.autoLeftEnabled = not M.autoLeftEnabled
                if M.autoLeftEnabled then M.startAutoLeft() else M.stopAutoLeft() end
                setOn(M.autoLeftEnabled)
            elseif key == "AutoRight" then
                M.autoRightEnabled = not M.autoRightEnabled
                if M.autoRightEnabled then M.startAutoRight() else M.stopAutoRight() end
                setOn(M.autoRightEnabled)
            elseif key == "AutoBat" then
                if M.autoBatEnabled then M.stopBatAimbot() else M.queueAutoBatStart() end
                setOn(M.autoBatEnabled)
            elseif key == "AutoMedusa" then
                if M.autoMedusaEnabled then M.stopAutoMedusa() else M.startAutoMedusa() end
                setOn(M.autoMedusaEnabled)
                if M.setAutoMedusaVisual then M.setAutoMedusaVisual(M.autoMedusaEnabled) end
            elseif key == "BatTP" then
                M.toggleBypassAimbot(); setOn(M.bypassAimbotEnabled)
                if refs.BatV2 then refs.BatV2(M.batV2Enabled) end
            elseif key == "AutoTPDown" then
                M.autoTPEnabled = not M.autoTPEnabled
                if M.autoTPEnabled then M.startAutoTP() else M.stopAutoTP() end
                setOn(M.autoTPEnabled)
            elseif key == "BatV2" then
                if M.batV2Enabled then M.stopBatV2() else M.startBatV2() end
                setOn(M.batV2Enabled)
                if refs.BatTP then refs.BatTP(M.bypassAimbotEnabled) end
            elseif key == "AntiAnti" then
                M.setAntiAntiDesync(not M.aadEnabled)
                setOn(M.aadEnabled)
            elseif key == "CarrySpeed" then
                M.toggleCarryMode()
                setOn(M.carrySpeedActive)
            elseif key == "Lagger" then
                M.toggleLaggerMode(); setOn(M.laggerModeEnabled)
            elseif key == "LaggerCarry" then
                M.toggleLaggerCarry(); setOn(M.laggerCarryActive)
            end
        end)
        return setOn
    end
    for i,d in ipairs(defs) do refs[d[1]] = makeToggle(d[1], d[2], i, d[3], d[4]) end
    refs.InstaReset(false); refs.TpDown(false); refs.DropBR(false)
    refs.AutoLeft(M.autoLeftEnabled); refs.AutoRight(M.autoRightEnabled); refs.AutoBat(M.autoBatEnabled)
    refs.AutoMedusa(M.autoMedusaEnabled); refs.BatTP(M.bypassAimbotEnabled); refs.AutoTPDown(M.autoTPEnabled)
    refs.BatV2(M.batV2Enabled); refs.AntiAnti(M.aadEnabled); refs.CarrySpeed(M.carrySpeedActive)
    refs.Lagger(M.laggerModeEnabled); refs.LaggerCarry(M.laggerCarryActive)
    M.mobBtnRefs.autoLeft = refs.AutoLeft
    M.mobBtnRefs.autoRight = refs.AutoRight
    M.mobBtnRefs.autoBat = refs.AutoBat
    M.mobBtnRefs.autoMedusa = refs.AutoMedusa
    M.mobBtnRefs.bypass = refs.BatTP
    M.mobBtnRefs.autoTpDown = refs.AutoTPDown
    M.mobBtnRefs.batV2 = refs.BatV2
    M.mobBtnRefs.antiAnti = refs.AntiAnti
    M.mobBtnRefs.carrySpeed = refs.CarrySpeed
    M.mobBtnRefs.lagger = refs.Lagger
    M.mobBtnRefs.laggerCarry = refs.LaggerCarry
    return gui
end

M.destroyMobileButtons()
if M.mobileButtonsEnabled then M.buildCleanTogglePanel() end
if M.antiRagdollEnabled then M.startAntiRagdoll() end
if M.infJumpEnabled then
    if M.infJumpMode=="manual" then M.startManualInfJumpLoop()
    elseif M.infJumpMode=="hold" then M.startHoldInfJump() end
end
if M.medusaCounterEnabled then M.setupMedusa(player.Character) end
if M.autoMedusaEnabled then M.startAutoMedusa() end
if M.batCounterEnabled then M.startBatCounter() end
if M.unwalkEnabled then M.startUnwalk() end
if M.autoTPEnabled then M.startAutoTP() end
if M.antiFlingEnabled then M.enableAntiFling() end
if M.saturatedColorsEnabled then M.enableSaturatedColors() end
if M.autoBatEnabled then M.queueAutoBatStart() end
if M.autoLeftEnabled then M.startAutoLeft() end
if M.autoRightEnabled then M.startAutoRight() end
if M.Steal.AutoStealEnabled then M.startAutoSteal() end
if M.bypassAimbotEnabled then M.startBypassAimbot() end
if M.perfectHitEnabled then M.setPerfectHit(true) end
if M.hardHitEnabled then M.startHardHit() end
if M.antiDieEnabled then M.startAntiDie() end
if M.batV2Enabled then M.startBatV2() end
if M.antiKickEnabled then M.enableAntiKick() end
if M.antiLagEnabled then M.enableAntiLag() end
if M.stretchRezEnabled then M.enableStretchRez() end
if M.removeAccEnabled then M.startRemoveAcc() end
if M.selectiveNoclipEnabled then M.startSelectiveNoclip() end

if M.animPackEnabled and M.animPack and M.PACKS[M.animPack] then
    task.wait(0.5)
    M.applyAnimPack(M.animPack)
else
    local char = player.Character
    if char then
        M.resetAnimations(char)
    end
end

if M.headlessEnabled or M.korbloxEnabled then
    task.wait(0.3)
    M.applyCharterToChar(player.Character)
end

M.CandyApplyCustomSky(M.currentSkyTheme)
if M.showPlayerSpeeds then M.togglePlayerSpeeds(true) end

M.updateStatusRadius()
M.startHeadSpeedUpdates()

if player.Character then
    M._watchMedusaInCharacter(player.Character)
    M.startAutoResetThreats(player.Character)
    M.setupHeadIndicator(player.Character)
    if M.headIndicator and M.headIndicator.bb then M.headIndicator.bb.Enabled = (M._introActive ~= true) end
    M.setupRagdollTriggers()
end
player.CharacterAdded:Connect(function(char)
    M.isRagdollActive = false
    M.ragdollTimerRemaining = 0
    if M.ragdollTimerThread then task.cancel(M.ragdollTimerThread); M.ragdollTimerThread = nil end
    task.wait(0.5)
    M._watchMedusaInCharacter(char)
    M.startAutoResetThreats(char)
    M.setupHeadIndicator(char)
    if M.headIndicator and M.headIndicator.bb then M.headIndicator.bb.Enabled = (M._introActive ~= true) end
    M.setupRagdollTriggers()
    if M.medusaCounterEnabled then M.setupMedusa(char) end
    if M.autoMedusaEnabled then task.wait(0.1); M.startAutoMedusa() end
    if M.batCounterEnabled then M.startBatCounter() end
    if M.batV2Enabled then task.wait(0.2); M.startBatV2() end
    if M.unwalkEnabled then task.wait(0.5); M.startUnwalk() end
    if M.animPackEnabled and M.animPack and M.PACKS[M.animPack] then
        task.wait(0.2)
        M.applyAnimPack(M.animPack)
    else
        M.resetAnimations(char)
    end
    if M.headlessEnabled or M.korbloxEnabled then
        task.wait(0.2)
        M.applyCharterToChar(char)
    end
    if M.bypassAimbotEnabled then
        task.wait(0.2)
        M.startBypassAimbot()
    end
    if M.perfectHitEnabled then M.setPerfectHit(true) end
    if M.hardHitEnabled then
        task.wait(0.1)
        M.startHardHit()
    end
    if M.antiDieEnabled then
        task.wait(0.1)
        M.startAntiDie()
    end
end)


do
    local _ncAcc = 0
    RunService.Heartbeat:Connect(function(dt)
        _ncAcc = _ncAcc + dt
        if _ncAcc < 0.35 then return end
        _ncAcc = 0
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CanCollide = false end
                local head = p.Character:FindFirstChild("Head")
                if head then head.CanCollide = false end
            end
        end
    end)
end

local function destroySpeedObjects()
    if M._anchoredBySpeed then pcall(function() M._anchoredBySpeed.Anchored = false end); M._anchoredBySpeed = nil end
    if M._bodyVel then pcall(function() M._bodyVel:Destroy() end); M._bodyVel = nil end
    if M._bodyPosition then pcall(function() M._bodyPosition:Destroy() end); M._bodyPosition = nil end
    if M._bodyForce then pcall(function() M._bodyForce:Destroy() end); M._bodyForce = nil end
    if M._bodyThrust then pcall(function() M._bodyThrust:Destroy() end); M._bodyThrust = nil end
    if M._linearVel then pcall(function() M._linearVel:Destroy() end); M._linearVel = nil end
    if M._vectorForce then pcall(function() M._vectorForce:Destroy() end); M._vectorForce = nil end
    if M._alignPos then pcall(function() M._alignPos:Destroy() end); M._alignPos = nil end
    if M._rocket then pcall(function() M._rocket:Destroy() end); M._rocket = nil end
    if M._rocketTarget then pcall(function() M._rocketTarget:Destroy() end); M._rocketTarget = nil end
    if M._attLinVel then pcall(function() M._attLinVel:Destroy() end); M._attLinVel = nil end
    if M._attVecForce then pcall(function() M._attVecForce:Destroy() end); M._attVecForce = nil end
    if M._attAlign then pcall(function() M._attAlign:Destroy() end); M._attAlign = nil end
    if M._speedTween then pcall(function() M._speedTween:Cancel() end); M._speedTween = nil end
end

local function ensureSpeedAttachment(hrp, key, name)
    local att = M[key]
    if not att or att.Parent ~= hrp then
        if att then pcall(function() att:Destroy() end) end
        att = Instance.new("Attachment")
        att.Name = name or "MoveeSpeedAtt"
        att.Parent = hrp
        M[key] = att
    end
    return att
end

local function applySpeedMethod(hrp, hum, dir, spd, dt)
    local step = dt or 1/60
    local m = M.speedMethod
    if M._lastSpeedMethod ~= m then
        destroySpeedObjects()
        if m ~= "WalkSpeed" and hum.WalkSpeed ~= 16 then hum.WalkSpeed = 16 end
        M._lastSpeedMethod = m
    end
    local char = hrp.Parent
    local targetPos = hrp.Position + (dir * spd * step)

    local function massImpulse(direction, targetSpeed)
        local mass = hrp.AssemblyMass or 1
        local current = hrp.AssemblyLinearVelocity
        local desired = Vector3.new(direction.X * targetSpeed, current.Y, direction.Z * targetSpeed)
        local delta = desired - current
        pcall(function() hrp:ApplyImpulse(Vector3.new(delta.X, 0, delta.Z) * mass) end)
    end

    if m == "Velocity" then
        massImpulse(dir, spd)
    elseif m == "AssemblyLinearVelocity" then
        massImpulse(dir, spd)
    elseif m == "Velocity Lerp" then
        local current = hrp.AssemblyLinearVelocity
        local desired = Vector3.new(dir.X*spd, current.Y, dir.Z*spd)
        local blended = current:Lerp(desired, 0.6)
        local mass = hrp.AssemblyMass or 1
        pcall(function() hrp:ApplyImpulse(Vector3.new(blended.X - current.X, 0, blended.Z - current.Z) * mass) end)
    elseif m == "AssemblyLinearVelocity Lerp" then
        local current = hrp.AssemblyLinearVelocity
        local desired = Vector3.new(dir.X*spd, current.Y, dir.Z*spd)
        local blended = current:Lerp(desired, 0.6)
        local mass = hrp.AssemblyMass or 1
        pcall(function() hrp:ApplyImpulse(Vector3.new(blended.X - current.X, 0, blended.Z - current.Z) * mass) end)
    elseif m == "CFrame" then
        hrp.CFrame = hrp.CFrame + (dir * spd * step)
    elseif m == "CFrame Lerp" then
        hrp.CFrame = hrp.CFrame:Lerp(hrp.CFrame + (dir * spd * step), 0.5)
    elseif m == "Hyper CFrame" then
        hrp.CFrame = hrp.CFrame + (dir * spd * (M.hyperMult or 4) * step)
    elseif m == "Anchored CFrame" then
        if not hrp.Anchored then
            hrp.Anchored = true
            M._anchoredBySpeed = hrp
        end
        hrp.CFrame = hrp.CFrame + (dir * spd * step)
    elseif m == "PivotTo" then
        hrp:PivotTo(hrp.CFrame + (dir * spd * step))
    elseif m == "Model PivotTo" then
        if char and char:IsA("Model") then
            char:PivotTo(char:GetPivot() + (dir * spd * step))
        else
            hrp:PivotTo(hrp.CFrame + (dir * spd * step))
        end
    elseif m == "Tween CFrame" then
        if M._speedTween then pcall(function() M._speedTween:Cancel() end) end
        M._speedTween = TweenService:Create(hrp, TweenInfo.new(step, Enum.EasingStyle.Linear), {CFrame = hrp.CFrame + (dir * spd * step)})
        M._speedTween:Play()
    elseif m == "WalkSpeed" then
        hum.WalkSpeed = spd
    elseif m == "Humanoid Move" then
        hum.WalkSpeed = spd
        hum:Move(dir)
    elseif m == "Humanoid MoveTo" then
        hum:MoveTo(targetPos, hrp)
    elseif m == "BodyVelocity" then
        if not M._bodyVel or M._bodyVel.Parent ~= hrp then
            if M._bodyVel then pcall(function() M._bodyVel:Destroy() end) end
            M._bodyVel = Instance.new("BodyVelocity")
            M._bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            M._bodyVel.Parent = hrp
        end
        M._bodyVel.Velocity = Vector3.new(dir.X*spd, M._bodyVel.Velocity.Y, dir.Z*spd)
    elseif m == "BodyPosition" then
        if not M._bodyPosition or M._bodyPosition.Parent ~= hrp then
            if M._bodyPosition then pcall(function() M._bodyPosition:Destroy() end) end
            M._bodyPosition = Instance.new("BodyPosition")
            M._bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            M._bodyPosition.P = 500
            M._bodyPosition.D = 50
            M._bodyPosition.Parent = hrp
        end
        M._bodyPosition.Position = targetPos
    elseif m == "BodyForce" then
        if not M._bodyForce or M._bodyForce.Parent ~= hrp then
            if M._bodyForce then pcall(function() M._bodyForce:Destroy() end) end
            M._bodyForce = Instance.new("BodyForce")
            M._bodyForce.Parent = hrp
        end
        M._bodyForce.Force = Vector3.new(dir.X*spd, 0, dir.Z*spd) * 100
    elseif m == "BodyThrust" then
        if not M._bodyThrust or M._bodyThrust.Parent ~= hrp then
            if M._bodyThrust then pcall(function() M._bodyThrust:Destroy() end) end
            M._bodyThrust = Instance.new("BodyThrust")
            M._bodyThrust.Force = Vector3.new(math.huge, math.huge, math.huge)
            M._bodyThrust.Parent = hrp
        end
        M._bodyThrust.Force = Vector3.new(dir.X*spd, 0, dir.Z*spd) * 100
    elseif m == "LinearVelocity" then
        if not M._linearVel or M._linearVel.Parent ~= hrp then
            if M._linearVel then pcall(function() M._linearVel:Destroy() end) end
            local att = ensureSpeedAttachment(hrp, "_attLinVel", "MoveeLinVelAtt")
            M._linearVel = Instance.new("LinearVelocity")
            M._linearVel.Attachment0 = att
            M._linearVel.MaxForce = 1e8
            M._linearVel.RelativeTo = Enum.ActuatorRelativeTo.World
            M._linearVel.Parent = hrp
        end
        M._linearVel.VectorVelocity = Vector3.new(dir.X*spd, M._linearVel.VectorVelocity.Y, dir.Z*spd)
    elseif m == "VectorForce" then
        if not M._vectorForce or M._vectorForce.Parent ~= hrp then
            if M._vectorForce then pcall(function() M._vectorForce:Destroy() end) end
            local att = ensureSpeedAttachment(hrp, "_attVecForce", "MoveeVecForceAtt")
            M._vectorForce = Instance.new("VectorForce")
            M._vectorForce.Attachment0 = att
            M._vectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
            M._vectorForce.Parent = hrp
        end
        M._vectorForce.Force = Vector3.new(dir.X*spd, 0, dir.Z*spd) * 100
    elseif m == "AlignPosition" then
        if not M._alignPos or M._alignPos.Parent ~= hrp then
            if M._alignPos then pcall(function() M._alignPos:Destroy() end) end
            local att = ensureSpeedAttachment(hrp, "_attAlign", "MoveeAlignAtt")
            M._alignPos = Instance.new("AlignPosition")
            M._alignPos.Attachment0 = att
            M._alignPos.Mode = Enum.PositionAlignmentMode.OneAttachment
            M._alignPos.MaxForce = math.huge
            M._alignPos.Responsiveness = 15
            M._alignPos.RigidityEnabled = false
            M._alignPos.Parent = hrp
        end
        M._alignPos.Position = targetPos
    elseif m == "ApplyImpulse" then
        local mass = hrp.AssemblyMass or 1
        local current = hrp.AssemblyLinearVelocity
        local desired = Vector3.new(dir.X * spd, current.Y, dir.Z * spd)
        local delta = desired - current
        pcall(function() hrp:ApplyImpulse(Vector3.new(delta.X, 0, delta.Z) * mass) end)
    elseif m == "RocketPropulsion" then
        if not M._rocket or M._rocket.Parent ~= hrp or not M._rocketTarget then
            if M._rocket then pcall(function() M._rocket:Destroy() end) end
            if M._rocketTarget then pcall(function() M._rocketTarget:Destroy() end) end
            M._rocketTarget = Instance.new("Part")
            M._rocketTarget.Name = "MoveeRocketTarget"
            M._rocketTarget.Anchored = true
            M._rocketTarget.CanCollide = false
            M._rocketTarget.Transparency = 1
            M._rocketTarget.Size = Vector3.new(1,1,1)
            M._rocketTarget.Parent = workspace
            M._rocket = Instance.new("RocketPropulsion")
            M._rocket.MaxThrust = 3000
            M._rocket.MaxTorque = 1000
            M._rocket.ThrustP = 100
            M._rocket.ThrustD = 20
            M._rocket.TurnP = 100
            M._rocket.TurnD = 10
            M._rocket.Target = M._rocketTarget
            M._rocket.Parent = hrp
        end
        M._rocketTarget.Position = targetPos
        pcall(function() M._rocket:Fire() end)
    end
end

RunService.RenderStepped:Connect(function(dt)
    local char=player.Character; if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid"); local hrp=char:FindFirstChild("HumanoidRootPart"); if not hum or not hrp then return end
    if M.isRagdollState(hum) then M.lastMoveDir=Vector3.new(0,0,0); destroySpeedObjects(); return end
    if not M.autoBatEnabled and not M.autoLeftEnabled and not M.autoRightEnabled then
        M.updateAutoSwitchSpeed()
        local md=hum.MoveDirection; local spd=M.getActiveMoveSpeed()
        local dir = Vector3.new(0,0,0)
        if md.Magnitude>0 then
            M.lastMoveDir=md; dir=md
        elseif M.antiRagdollEnabled and M.lastMoveDir.Magnitude>0 then
            local anyHeld=false; for key in pairs(M.MOVE_KEYS) do if UIS:IsKeyDown(key) then anyHeld=true; break end end
            if anyHeld then dir=M.lastMoveDir end
        end
        if dir.Magnitude>0 then
            applySpeedMethod(hrp, hum, dir, spd, dt)
        else
            destroySpeedObjects()
        end
    end
end)


task.spawn(function()
    while task.wait(5) do saveCherryConfig() end
end)

M.applyFOV()
task.spawn(function()
    while true do
        task.wait(3)
        pcall(M.saveBtnPositions)
    end
end)

task.spawn(function()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then plots = workspace:WaitForChild("Plots",10) end
    if plots then
        for _,plot in ipairs(plots:GetChildren()) do
            if plot:IsA("Model") then scanPlotNormal(plot) end
        end
        plots.ChildAdded:Connect(function(plot)
            if plot:IsA("Model") then task.wait(0.5); scanPlotNormal(plot) end
        end)
        while true do
            task.wait(5)
            M.animalCache={}; M.promptCache={}; M.stealCache={}
            for _,plot in ipairs(plots:GetChildren()) do
                if plot:IsA("Model") then scanPlotNormal(plot) end
            end
        end
    end
end)

task.spawn(function()
    M.initSemiSync()
    while true do
        task.wait(5)
        if M.Semi.enabled or M.stealMode == "Semi" then
            pcall(M.scanAllPlotsSemi)
        end
    end
end)

function M.refreshSpeedModeLabel()
    
end

pcall(function()
    M.refreshWalkSpeedAutoSwitch()
    if M.customFontSelected and M.customFontSelected ~= "None" then
        task.spawn(function()
            task.wait(0.4)
            pcall(function() M.applyCustomFont(M.customFontSelected) end)
        end)
    end
end)
local function applyRoundedMenuStyle(root)
    if not root then return end
    local function style(obj)
        if obj:IsA("UIStroke") then
            obj.Transparency = 1
            return
        end
        if not obj:IsA("GuiObject") then return end
        obj.BorderSizePixel = 0
        if obj:IsA("Frame") or obj:IsA("TextButton") or obj:IsA("TextBox") or obj:IsA("ImageButton") or obj:IsA("ImageLabel") or obj:IsA("ScrollingFrame") then
            local c = obj:FindFirstChildOfClass("UICorner")
            if not c then
                c = Instance.new("UICorner")
                c.Parent = obj
            end
            c.CornerRadius = (obj == root) and UDim.new(0, 32) or UDim.new(0, 18)
        end
    end
    style(root)
    for _, obj in ipairs(root:GetDescendants()) do style(obj) end
    root.DescendantAdded:Connect(style)
end
applyRoundedMenuStyle(M.mainFrame)
if M.mainFrame then
    M.mainFrame.Size = UDim2.fromOffset(356, 536)
    local effectiveScale = M.mainFrame:FindFirstChild("BDUIScale")
    if effectiveScale then effectiveScale.Scale = math.clamp(tonumber(M.uiScale) or 1.0, 0.5, 2.0) end
end
print("S1NXY DL loaded successfully!")
return M