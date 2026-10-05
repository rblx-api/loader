--[[
  Music Player Standalone
  Listas + lógica + barra flotante (play/pause, ±10s, prev/next)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

-- ===================== LISTAS =====================
local listaCatbox = {
    {name = "Traigo mi Cuerno el lirikario", link = "https://files.catbox.moe/9encfb.mp3"},
    {name = "El chiricuazo v3", link = "https://files.catbox.moe/jxie7x.mp3"},
    {name = "El de la R", link = "https://files.catbox.moe/z71nw9.mp3"},
    {name = "La maña music", link = "https://files.catbox.moe/7qa0i4.mp3"},
    {name = "Aqui seguimos", link = "https://files.catbox.moe/ih03mg.mp3"},
    {name = "El trueno", link = "https://files.catbox.moe/1erzv2.mp3"},
    {name = "Mujer de piedra", link = "https://files.catbox.moe/9yjej5.mp3"},
    {name = "Jefe mencho", link = "https://files.catbox.moe/fe9yxr.mp3"},
    {name = "El contra tijerina v2", link = "https://files.catbox.moe/05y33r.mp3"},
    {name = "Doma", link = "https://files.catbox.moe/mkwawe.mp3"},
    {name = "Lo que hay x aqui", link = "https://files.catbox.moe/66nnop.mp3"},
    {name = "Ebrio de Amor", link = "https://files.catbox.moe/8leyi2.mp3"},
    {name = "Mi radio y Mi cuerno", link = "https://files.catbox.moe/vpvrt5.mp3"},
    {name = "Furia blanca", link = "https://files.catbox.moe/s5nxvp.mp3"},
    {name = "Belanova", link = "https://files.catbox.moe/a9plsn.mp3"},
    {name = "Culpable tu", link = "https://files.catbox.moe/2o7npd.mp3"},
    {name = "Cumbia la Ksquiza", link = "https://files.catbox.moe/fulmex.mp3"},
    {name = "La diestra", link = "https://files.catbox.moe/zr98e5.mp3"},
    {name = "Borro Cassette", link = "https://files.catbox.moe/nabpiz.mp3"},
    {name = "Cuando no era cantante", link = "https://files.catbox.moe/go56j6.mp3"},
    {name = "Noches Frías", link = "https://files.catbox.moe/hvsrir.mp3"},
    {name = "La plena", link = "https://files.catbox.moe/fv1c91.mp3"},
    {name = "Bipolar (peso pluma)", link = "https://files.catbox.moe/wplf2q.mp3"},
    {name = "Webazon", link = "https://files.catbox.moe/jit8ei.mp3"},
    {name = "Di que si", link = "https://files.catbox.moe/y3yr75.mp3"},
    {name = "Me la avente", link = "https://files.catbox.moe/z5oxpg.mp3"},
    {name = "Antonio aguilar - hijo desobediente", link = "https://files.catbox.moe/dpwv18.mp3"},
    {name = "Mi Pasado Y Mi Presente", link = "https://files.catbox.moe/9bbmoa.mp3"},
    {name = "Bad bonny callaita", link = "https://files.catbox.moe/q17vjg.mp3"},
    {name = "inspírate vol 7", link = "https://files.catbox.moe/hmuaty.mp3"},
    {name = "Ni por favor (lefty sm)", link = "https://files.catbox.moe/e27idr.mp3"},
    {name = "Ondeado v2", link = "https://files.catbox.moe/7b79ys.mp3"},
    {name = "Quien te entiende", link = "https://files.catbox.moe/ybf5u6.mp3"},
    {name = "Con tus besos - Eslabon Armando", link = "https://files.catbox.moe/2evdys.mp3"},
}

local listaSound = {
    {name = "Aura Isxwn", link = "https://files.catbox.moe/n2po3t.mp3"},
    {name = "Let it show", link = "https://files.catbox.moe/an2x44.mp3"},
    {name = "Still Think About You", link = "https://files.catbox.moe/n6lxff.mp3"},
    {name = "Alok Alan walker", link = "https://files.catbox.moe/5e9jqa.mp3"},
}

-- ===================== ESTADO =====================
local activePlaylist = "Musica" -- "Musica" | "Sound"
local currentSongIndex = 1
local currentSongName = listaCatbox[1].name
local isMusicPaused = true
local musicLoaded = false
local savedMusicTimePosition = 0
local resumeMusicPositionOnLoad = false

local function getActivePlaylist()
    return activePlaylist == "Sound" and listaSound or listaCatbox
end

-- ===================== SOUND =====================
local bgMusic = Instance.new("Sound")
bgMusic.Name = "StandaloneMusic"
bgMusic.Volume = 1
bgMusic.Looped = false
bgMusic.Parent = SoundService

local function safeIsfile(path)
    if type(isfile) == "function" then
        local ok, res = pcall(isfile, path)
        return ok and res
    end
    return false
end

local function safeWritefile(path, data)
    if type(writefile) == "function" then
        pcall(writefile, path, data)
    end
end

local function musicFileName(url)
    local base = tostring(url):match("([^/]+)%.mp3$") or tostring(url):match("([^/]+)$") or "song"
    return "music_" .. base:gsub("[^%w_%-]", "_") .. ".mp3"
end

-- Referencias UI (se llenan al crear la barra)
local musicFloatFrame, musicFloatTitle
local musicFloatBars = {}
local playPauseBtn

local function updateMusicUI()
    if musicFloatTitle then
        musicFloatTitle.Text = tostring(currentSongName)
    end
    if playPauseBtn then
        playPauseBtn.Text = (musicLoaded and not isMusicPaused and bgMusic.Playing) and "❚❚" or "▶"
    end
    if musicFloatFrame then
        musicFloatFrame.Visible = true
    end
end

local function playSongByIndex(idx, playNow)
    local playlist = getActivePlaylist()
    if idx < 1 or idx > #playlist then return end

    local previousIndex = currentSongIndex
    musicLoaded = false
    currentSongIndex = idx
    currentSongName = playlist[idx].name
    if idx ~= previousIndex then
        savedMusicTimePosition = 0
    end
    updateMusicUI()

    if playNow == nil then playNow = true end
    if not playNow then return end

    task.spawn(function()
        local song = getActivePlaylist()[idx]
        if bgMusic.Playing then bgMusic:Stop() end

        local fileName = musicFileName(song.link)
        local assetLoader = getcustomasset or getsynasset
        if type(assetLoader) ~= "function" then
            isMusicPaused = true
            updateMusicUI()
            warn("[Music] No hay getcustomasset / getsynasset")
            return
        end

        if not safeIsfile(fileName) then
            local ok, data = pcall(function()
                return game:HttpGet(song.link, true)
            end)
            if ok and type(data) == "string" and #data >= 1024 then
                safeWritefile(fileName, data)
            end
        end

        local okAsset, assetId = pcall(assetLoader, fileName)
        if not okAsset or type(assetId) ~= "string" or assetId == "" then
            isMusicPaused = true
            updateMusicUI()
            warn("[Music] No se pudo cargar: " .. tostring(song.name))
            return
        end

        bgMusic.SoundId = assetId
        musicLoaded = true

        if resumeMusicPositionOnLoad and savedMusicTimePosition > 0 then
            pcall(function() bgMusic.TimePosition = savedMusicTimePosition end)
            resumeMusicPositionOnLoad = false
        end

        isMusicPaused = false
        pcall(function() bgMusic:Play() end)
        updateMusicUI()
    end)
end

local function playNextSong()
    local playlist = getActivePlaylist()
    if #playlist == 0 then return end
    local nextIndex = currentSongIndex + 1
    if nextIndex > #playlist then nextIndex = 1 end
    playSongByIndex(nextIndex, true)
end

local function playPreviousSong()
    local playlist = getActivePlaylist()
    if #playlist == 0 then return end
    local prevIndex = currentSongIndex - 1
    if prevIndex < 1 then prevIndex = #playlist end
    playSongByIndex(prevIndex, true)
end

local function seekMusicBy(seconds)
    if not musicLoaded then return end
    local current, length = 0, 0
    pcall(function()
        current = bgMusic.TimePosition
        length = bgMusic.TimeLength
    end)
    local target = math.max(0, current + seconds)
    if length and length > 0 then
        target = math.min(target, math.max(0, length - 0.05))
    end
    pcall(function() bgMusic.TimePosition = target end)
    savedMusicTimePosition = target
end

local function toggleMusicPause()
    if not musicLoaded then
        playSongByIndex(currentSongIndex, true)
        return
    end
    if bgMusic.Playing then
        pcall(function() savedMusicTimePosition = bgMusic.TimePosition end)
        bgMusic:Pause()
        isMusicPaused = true
    else
        pcall(function() bgMusic:Resume() end)
        isMusicPaused = false
    end
    updateMusicUI()
end

bgMusic.Ended:Connect(function()
    isMusicPaused = false
    musicLoaded = false
    updateMusicUI()
    playNextSong()
end)

-- ===================== BARRA FLOTANTE =====================
local function createMusicFloatingBar()
    local HudGui = Instance.new("ScreenGui")
    HudGui.Name = "StandaloneMusicHUD"
    HudGui.ResetOnSpawn = false
    HudGui.IgnoreGuiInset = true
    HudGui.DisplayOrder = 30
    pcall(function()
        HudGui.Parent = game:GetService("CoreGui")
    end)
    if not HudGui.Parent then
        HudGui.Parent = LP:WaitForChild("PlayerGui")
    end

    musicFloatFrame = Instance.new("Frame")
    musicFloatFrame.Name = "MusicFloatingBar"
    musicFloatFrame.Size = UDim2.new(0, 280, 0, 42)
    musicFloatFrame.Position = UDim2.new(0.5, -140, 0, 18)
    musicFloatFrame.BackgroundColor3 = Color3.fromRGB(10, 8, 14)
    musicFloatFrame.BackgroundTransparency = 0.08
    musicFloatFrame.BorderSizePixel = 0
    musicFloatFrame.Visible = true
    musicFloatFrame.ZIndex = 30
    musicFloatFrame.Parent = HudGui
    Instance.new("UICorner", musicFloatFrame).CornerRadius = UDim.new(0, 13)

    local stroke = Instance.new("UIStroke", musicFloatFrame)
    stroke.Color = Color3.fromRGB(185, 0, 0)
    stroke.Thickness = 1.3
    stroke.Transparency = 0.15

    local function makeBtn(text, xOffset, callback)
        local btn = Instance.new("TextButton", musicFloatFrame)
        btn.Size = UDim2.new(0, 34, 0, 24)
        btn.Position = UDim2.new(0, xOffset, 0.5, -12)
        btn.BackgroundColor3 = Color3.fromRGB(45, 40, 55)
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.ZIndex = 32
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    -- Layout: |◀  -10  ▶/❚❚  +10  ▶|
    makeBtn("|◀", 6, playPreviousSong)
    makeBtn("-10", 44, function() seekMusicBy(-10) end)

    playPauseBtn = makeBtn("▶", 82, toggleMusicPause)

    makeBtn("+10", 120, function() seekMusicBy(10) end)
    makeBtn("▶|", 158, playNextSong)

    -- Título de la canción
    musicFloatTitle = Instance.new("TextLabel", musicFloatFrame)
    musicFloatTitle.Size = UDim2.new(0, 80, 0, 14)
    musicFloatTitle.Position = UDim2.new(0, 198, 0, 4)
    musicFloatTitle.BackgroundTransparency = 1
    musicFloatTitle.Text = tostring(currentSongName)
    musicFloatTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    musicFloatTitle.Font = Enum.Font.GothamBold
    musicFloatTitle.TextSize = 9
    musicFloatTitle.TextTruncate = Enum.TextTruncate.AtEnd
    musicFloatTitle.TextXAlignment = Enum.TextXAlignment.Left
    musicFloatTitle.ZIndex = 32

    -- Equalizer simple
    for i = 1, 7 do
        local bar = Instance.new("Frame", musicFloatFrame)
        bar.Name = "Eq" .. i
        bar.Size = UDim2.new(0, 3, 0, 6)
        bar.Position = UDim2.new(0, 198 + ((i - 1) * 5), 1, -6)
        bar.AnchorPoint = Vector2.new(0, 1)
        bar.BackgroundColor3 = Color3.fromRGB(185, 0, 0)
        bar.BorderSizePixel = 0
        bar.ZIndex = 32
        Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
        table.insert(musicFloatBars, bar)
    end

    -- Animación del equalizer
    local beatClock = 0
    RunService.Heartbeat:Connect(function(dt)
        beatClock = beatClock + dt
        if beatClock < 0.12 then return end
        beatClock = 0
        if not musicFloatFrame or not musicFloatFrame.Visible then return end
        if isMusicPaused or not bgMusic.Playing then
            for _, bar in ipairs(musicFloatBars) do
                if bar and bar.Parent then
                    bar.Size = UDim2.new(0, 3, 0, 4)
                end
            end
            return
        end
        local beat = os.clock() * 5
        for i, bar in ipairs(musicFloatBars) do
            if bar and bar.Parent then
                bar.Size = UDim2.new(0, 3, 0, 4 + math.floor((math.sin(beat + i * 0.9) + 1) * 4))
            end
        end
    end)

    updateMusicUI()
end

-- ===================== INICIO =====================
createMusicFloatingBar()

-- Opcional: arrancar la primera canción automáticamente
-- playSongByIndex(1, true)

print("[Music] Reproductor listo. Usa la barra flotante o llama playSongByIndex(n, true)")