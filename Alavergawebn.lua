if _G.TraceRunning then return end
_G.TraceRunning = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local camera = workspace.CurrentCamera

NS = 60
CS = 30
LAGGER_SPEED_1 = 15
LAGGER_SPEED_2 = 24.5
MEDUSA_COOLDOWN = 25
BAT_AIMBOT_SPEED = 58
BYPASS_AIMBOT_SPEED = 60
MOBILE_PANEL_WIDTH = 128
MOBILE_PANEL_HEIGHT = 294
CONFIG_FILE = "Trace.json"
BAT_V2_HIT_DIST = 4.5
_isDraggingButton = false

speedMode = false
antiRagdollEnabled = false
jumpMode = 1
jumpEnabled = false
laggerToggled = false
laggerLevel = 1
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
medusaAutoResetEnabled = false
autoTPDownEnabled = false
autoTPDownHeight = 20
uiLocked = false
editModeEnabled = false
uiScaleValue = 100
espEnabled = false
fovSelectorVisible = false

bodyLockEnabled = false
bodyLockRange = 20
bodyLockRangeBox = nil
_bodyLockConn = nil
bodyLockSetVisual = nil
_blSuppressCount = 0
_blWasEnabled = false
_blRestoreTimer = nil
_blSmoothRestore = false

savedProgressBarPos = nil
savedButtonPositions = {}
savedMobilePanelPos = nil
savedStealBarPos = nil -- Nueva variable para guardar posición de la barra de steal
instaResetFloatingPos = nil
tpBatFloatingPos = nil

currentAnimPack = "Off"
originalTryardAnims = nil
tryardHeartbeatConn = nil
animSelectorLabel = nil

-- ============================================
-- MUSIC SYSTEM (BOOMIN SONGS)
-- ============================================
local KEEP_MUSIC_SONGS = {
	"https://files.catbox.moe/f0wih0.mp3",
	"https://files.catbox.moe/lprp3g.mp3",
	"https://files.catbox.moe/akvg2m.mp3",
	"https://files.catbox.moe/dtsp9i.mp3",
	"https://files.catbox.moe/ddnbup.mp3",
	"https://files.catbox.moe/h3cuo6.mp3",
	"https://files.catbox.moe/2mw4g9.mp3",
	"https://files.catbox.moe/x0zr5p.mp3",
	"https://files.catbox.moe/24b3c5.mp3",
	"https://files.catbox.moe/jvpu0j.mp3",
}

local INTRO_SONGS_P = {
	"https://files.catbox.moe/f0wih0.mp3",
	"https://files.catbox.moe/lprp3g.mp3",
	"https://files.catbox.moe/akvg2m.mp3",
	"https://files.catbox.moe/dtsp9i.mp3",
	"https://files.catbox.moe/ddnbup.mp3",
	"https://files.catbox.moe/h3cuo6.mp3",
	"https://files.catbox.moe/2mw4g9.mp3",
	"https://files.catbox.moe/x0zr5p.mp3",
	"https://files.catbox.moe/24b3c5.mp3",
	"https://files.catbox.moe/jvpu0j.mp3",
}

local keepMusicEnabled = false
local keepMusicSound = nil
local keepMusicLoopConn = nil
local setKeepMusicVisual = nil
local keepMusicIndex = 1

-- Intro Song variables
local songIndex = 1
local previewLoading = false
local previewSound = nil
local previewCacheFile = "MeowlPreview_cache"
local indexFile = "MeowlMusicIndex"

-- Load saved song index
pcall(function() 
	if isfile and isfile(indexFile) then 
		local n = tonumber(readfile(indexFile))
		if n and n >= 1 and n <= #INTRO_SONGS_P then songIndex = n end
	end
end)

local function stopKeepMusic()
	keepMusicEnabled = false
	if keepMusicLoopConn then pcall(function() keepMusicLoopConn:Disconnect() end); keepMusicLoopConn = nil end
	if keepMusicSound and keepMusicSound.Parent then
		pcall(function() keepMusicSound:Stop(); keepMusicSound:Destroy() end)
	end
	keepMusicSound = nil
end

local function stopPreview()
	pcall(function()
		if previewSound and previewSound.Parent then
			previewSound:Stop()
			previewSound:Destroy()
			previewSound = nil
		end
	end)
end

local function playPreview(idx)
	if previewLoading then return end
	previewLoading = true
	stopPreview()
	task.spawn(function()
		pcall(function()
			local content = game:HttpGet(INTRO_SONGS_P[idx])
			writefile(previewCacheFile, content)
			local snd = Instance.new("Sound", game:GetService("SoundService"))
			snd.SoundId = getcustomasset(previewCacheFile)
			snd.Volume = 0.7
			snd.Looped = false
			previewSound = snd
			snd:Play()
			task.delay(12, function()
				if previewSound == snd then stopPreview() end
			end)
		end)
		previewLoading = false
	end)
end

local function startKeepMusic(songIdx)
	stopKeepMusic()
	keepMusicEnabled = true
	keepMusicIndex = songIdx or keepMusicIndex
	task.spawn(function()
		pcall(function()
			local url = KEEP_MUSIC_SONGS[keepMusicIndex]
			local content = game:HttpGet(url)
			writefile("MeowlKeepMusic_cache", content)
			if not keepMusicEnabled then return end
			local snd = Instance.new("Sound", game:GetService("SoundService"))
			snd.SoundId = getcustomasset("MeowlKeepMusic_cache")
			snd.Volume = 0.6
			snd.Looped = true
			keepMusicSound = snd
			snd:Play()
			keepMusicLoopConn = snd.Stopped:Connect(function()
				if keepMusicEnabled then
					task.wait(0.2)
					if keepMusicEnabled and keepMusicSound == snd then
						snd:Play()
					end
				end
			end)
		end)
	end)
end

-- ============================================
-- SKY THEME SYSTEM
-- ============================================
local currentSkyTheme = "None"
local driftOriginalLighting = nil
local DRIFT_SKY_TAG = "_TraceSkyMod"

DRIFT_SKY_PRESETS = {
    None = { kind = "off" },
    Night = { clock = 0, brightness = 0.8, outAmb = {255, 0, 0}, ambient = {255, 0, 0}, sky = {stars = 3000, moon = 14}, atm = {dens = 0.25, color = {255, 0, 0}, decay = {255, 0, 0}, glare = 0, haze = 0.5} },
    Aurora = { clock = 0, brightness = 0.5, outAmb = {255, 0, 0}, ambient = {255, 0, 0}, sky = {stars = 2500, moon = 10}, atm = {dens = 0.3, color = {255, 0, 0}, decay = {255, 0, 0}, glare = 0.5, haze = 0.8}, clouds = {cover = 0.3, dens = 0.4, color = {255, 0, 0}} },
    Sunset = { clock = 18.5, brightness = 2.2, outAmb = {255, 0, 0}, ambient = {255, 0, 0}, sky = {stars = 0, sun = 8}, atm = {dens = 0.42, color = {255, 0, 0}, decay = {255, 0, 0}, glare = 2.5, haze = 2.2}, clouds = {cover = 0.55, dens = 0.5, color = {255, 0, 0}} },
    Galaxy = { clock = 0, brightness = 0.3, outAmb = {255, 0, 0}, ambient = {50, 0, 0}, sky = {stars = 5000, moon = 8}, atm = {dens = 0.15, color = {255, 0, 0}, decay = {255, 0, 0}, glare = 0, haze = 0.2} },
    Cyber = { clock = 0, brightness = 1.2, outAmb = {255, 0, 0}, ambient = {255, 0, 0}, sky = {stars = 1000, moon = 5}, atm = {dens = 0.38, color = {255, 0, 0}, decay = {255, 0, 0}, glare = 1.5, haze = 1.8} },
    Sakura = { clock = 9, brightness = 2.0, outAmb = {255, 0, 0}, ambient = {255, 0, 0}, sky = {stars = 0, sun = 10}, atm = {dens = 0.3, color = {255, 0, 0}, decay = {255, 0, 0}, glare = 1.5, haze = 1.5}, clouds = {cover = 0.5, dens = 0.4, color = {255, 150, 150}} },
    ["Pink Night"] = { clock = 0, brightness = 0.7, outAmb = {255, 0, 0}, ambient = {255, 0, 0}, sky = {stars = 3500, moon = 12}, atm = {dens = 0.28, color = {255, 0, 0}, decay = {255, 0, 0}, glare = 0.4, haze = 0.9} },
    ["Blood Moon"] = { clock = 0, brightness = 0.9, outAmb = {255, 0, 0}, ambient = {255, 0, 0}, sky = {stars = 2000, moon = 18}, atm = {dens = 0.3, color = {255, 0, 0}, decay = {255, 0, 0}, glare = 0.5, haze = 1.2} },
    Heaven = { clock = 12, brightness = 3, outAmb = {255, 150, 150}, ambient = {255, 0, 0}, sky = {stars = 0, sun = 14}, atm = {dens = 0.15, color = {255, 150, 150}, decay = {255, 0, 0}, glare = 2, haze = 1.5}, clouds = {cover = 0.8, dens = 0.6, color = {255, 150, 150}} },
    Storm = { clock = 14, brightness = 0.7, outAmb = {255, 0, 0}, ambient = {255, 0, 0}, sky = {stars = 0, sun = 4}, atm = {dens = 0.6, color = {255, 0, 0}, decay = {255, 0, 0}, glare = 0.2, haze = 3}, clouds = {cover = 0.95, dens = 0.9, color = {255, 0, 0}} },
    Sunrise = { clock = 6.5, brightness = 2, outAmb = {255, 0, 0}, ambient = {255, 0, 0}, sky = {stars = 0, sun = 10}, atm = {dens = 0.35, color = {255, 0, 0}, decay = {255, 0, 0}, glare = 2, haze = 1.8}, clouds = {cover = 0.45, dens = 0.4, color = {255, 0, 0}} },
    ["Deep Space"] = { clock = 0, brightness = 0.2, outAmb = {50, 0, 0}, ambient = {50, 0, 0}, sky = {stars = 6000, moon = 6}, atm = {dens = 0.05, color = {50, 0, 0}, decay = {50, 0, 0}, glare = 0, haze = 0} },
    ["Lavender Dream"] = { clock = 20, brightness = 0.8, outAmb = {255, 0, 0}, ambient = {255, 0, 0}, sky = {stars = 2800, moon = 10}, atm = {dens = 0.3, color = {255, 0, 0}, decay = {255, 0, 0}, glare = 0.3, haze = 0.8} },
    Vaporwave = { clock = 0, brightness = 1.1, outAmb = {255, 0, 0}, ambient = {255, 0, 0}, sky = {stars = 3000, moon = 8}, atm = {dens = 0.35, color = {255, 0, 0}, decay = {255, 0, 0}, glare = 1.2, haze = 1.5} },
    ["Midnight Ocean"] = { clock = 0, brightness = 0.6, outAmb = {255, 0, 0}, ambient = {255, 0, 0}, sky = {stars = 4000, moon = 12}, atm = {dens = 0.28, color = {255, 0, 0}, decay = {255, 0, 0}, glare = 0.3, haze = 0.8} },
    Arctic = { clock = 13, brightness = 2.5, outAmb = {255, 150, 150}, ambient = {255, 0, 0}, sky = {stars = 0, sun = 12}, atm = {dens = 0.32, color = {255, 0, 0}, decay = {255, 0, 0}, glare = 1.8, haze = 2}, clouds = {cover = 0.6, dens = 0.5, color = {255, 150, 150}} },
    Toxic = { clock = 20, brightness = 1.0, outAmb = {255, 0, 0}, ambient = {255, 0, 0}, sky = {stars = 1500, moon = 9}, atm = {dens = 0.35, color = {255, 0, 0}, decay = {255, 0, 0}, glare = 0.8, haze = 1.2} },
    Inferno = { clock = 18, brightness = 1.8, outAmb = {255, 0, 0}, ambient = {255, 0, 0}, sky = {stars = 0, sun = 6}, atm = {dens = 0.5, color = {255, 0, 0}, decay = {255, 0, 0}, glare = 3, haze = 2.5}, clouds = {cover = 0.7, dens = 0.7, color = {255, 0, 0}} },
    ["Solar Eclipse"] = { clock = 12, brightness = 0.4, outAmb = {255, 0, 0}, ambient = {50, 0, 0}, sky = {stars = 500, sun = 6}, atm = {dens = 0.45, color = {255, 0, 0}, decay = {50, 0, 0}, glare = 0.1, haze = 2} },
    Hellscape = { clock = 20, brightness = 1.4, outAmb = {255, 0, 0}, ambient = {255, 0, 0}, sky = {stars = 0, sun = 4}, atm = {dens = 0.6, color = {255, 0, 0}, decay = {255, 0, 0}, glare = 2.5, haze = 3.5}, clouds = {cover = 0.85, dens = 0.8, color = {255, 0, 0}} },
    ["Volcanic"] = { clock = 18, brightness = 1.6, outAmb = {255, 0, 0}, ambient = {255, 0, 0}, sky = {stars = 0, sun = 5}, atm = {dens = 0.55, color = {255, 0, 0}, decay = {255, 0, 0}, glare = 2, haze = 3}, clouds = {cover = 0.75, dens = 0.7, color = {255, 0, 0}} },
    ["Emerald Dawn"] = { clock = 6, brightness = 1.8, outAmb = {255, 0, 0}, ambient = {255, 0, 0}, sky = {stars = 0, sun = 9}, atm = {dens = 0.28, color = {255, 0, 0}, decay = {255, 0, 0}, glare = 1.5, haze = 1.2}, clouds = {cover = 0.4, dens = 0.4, color = {255, 0, 0}} },
}
DRIFT_SKY_ORDER = {"None","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno"}

function driftSaveOriginalLighting()
   if driftOriginalLighting then return end
   driftOriginalLighting = {
       ClockTime = Lighting.ClockTime,
       OutdoorAmbient = Lighting.OutdoorAmbient,
       Ambient = Lighting.Ambient,
       Brightness = Lighting.Brightness,
       FogStart = Lighting.FogStart,
       FogEnd = Lighting.FogEnd,
       FogColor = Lighting.FogColor,
       GlobalShadows = Lighting.GlobalShadows,
       LightingChildren = {},
       TerrainChildren = {}
   }
   for _, child in ipairs(Lighting:GetChildren()) do
       if child:IsA("Sky") or child:IsA("Atmosphere") then
           table.insert(driftOriginalLighting.LightingChildren, child:Clone())
       end
   end
   local terrain = workspace:FindFirstChildOfClass("Terrain")
   if terrain then
       for _, child in ipairs(terrain:GetChildren()) do
           if child:IsA("Clouds") then
               table.insert(driftOriginalLighting.TerrainChildren, child:Clone())
           end
       end
   end
end

function driftClearSky()
   for _, child in ipairs(Lighting:GetChildren()) do
       if child:GetAttribute(DRIFT_SKY_TAG) or child:IsA("Sky") or child:IsA("Atmosphere") then
           pcall(function() child:Destroy() end)
       end
   end
   local terrain = workspace:FindFirstChildOfClass("Terrain")
   if terrain then
       for _, child in ipairs(terrain:GetChildren()) do
           if child:GetAttribute(DRIFT_SKY_TAG) or child:IsA("Clouds") then
               pcall(function() child:Destroy() end)
           end
       end
   end
end

function driftMakeInst(className, parent, props)
   local inst = Instance.new(className)
   inst:SetAttribute(DRIFT_SKY_TAG, true)
   for k, v in pairs(props or {}) do
       pcall(function() inst[k] = v end)
   end
   inst.Parent = parent
   return inst
end

function dC3(t) return Color3.fromRGB(t[1], t[2], t[3]) end

function applyDriftSkyTheme(mode)
   driftSaveOriginalLighting()
   driftClearSky()
   local terrain = workspace:FindFirstChildOfClass("Terrain")
   local preset = DRIFT_SKY_PRESETS[mode]
   if not preset or preset.kind == "off" then
       if driftOriginalLighting then
           for k, v in pairs(driftOriginalLighting) do
               if k ~= "LightingChildren" and k ~= "TerrainChildren" then
                   pcall(function() Lighting[k] = v end)
               end
           end
           for _, child in ipairs(driftOriginalLighting.LightingChildren or {}) do
               child:Clone().Parent = Lighting
           end
           local offTerrain = workspace:FindFirstChildOfClass("Terrain")
           if offTerrain then
               for _, child in ipairs(driftOriginalLighting.TerrainChildren or {}) do
                   child:Clone().Parent = offTerrain
               end
           end
       end
       return
   end
   Lighting.FogStart = 0
   Lighting.FogEnd = 100000
   Lighting.GlobalShadows = true
   Lighting.ClockTime = preset.clock or 14
   Lighting.Brightness = preset.brightness or 2
   if preset.outAmb then Lighting.OutdoorAmbient = dC3(preset.outAmb) end
   if preset.ambient then Lighting.Ambient = dC3(preset.ambient) end
   if preset.sky then
       local sp = {}
       if preset.sky.stars then sp.StarCount = preset.sky.stars end
       if preset.sky.moon then sp.MoonAngularSize = preset.sky.moon end
       if preset.sky.sun then sp.SunAngularSize = preset.sky.sun end
       driftMakeInst("Sky", Lighting, sp)
   end
   if preset.atm then
       driftMakeInst("Atmosphere", Lighting, {
           Density = preset.atm.dens or 0.3,
           Color = dC3(preset.atm.color),
           Decay = dC3(preset.atm.decay),
           Glare = preset.atm.glare or 1,
           Haze = preset.atm.haze or 1
       })
   end
   if preset.clouds and terrain then
       driftMakeInst("Clouds", terrain, {
           Cover = preset.clouds.cover or 0.5,
           Density = preset.clouds.dens or 0.5,
           Color = dC3(preset.clouds.color)
       })
   end
end

-- ============================================

local ANIM_PACKS = {
    Tryhard = {
        idle1 = "rbxassetid://133806214992291",
        idle2 = "rbxassetid://94970088341563",
        walk  = "rbxassetid://707897309",
        run   = "rbxassetid://707861613",
        jump  = "rbxassetid://116936326516985",
        fall  = "rbxassetid://116936326516985",
        climb = "rbxassetid://116936326516985",
        swim  = "rbxassetid://116936326516985",
        swimidle = "rbxassetid://116936326516985",
    },
    Crazy = {
        idle1 = "rbxassetid://133806214992291",
        idle2 = "rbxassetid://94970088341563",
        walk  = "rbxassetid://134824450619865",
        run   = "rbxassetid://134824450619865",
        jump  = "rbxassetid://121454505477205",
        fall  = "rbxassetid://94788218468396",
        climb = "rbxassetid://121454505477205",
        swim  = "rbxassetid://121454505477205",
        swimidle = "rbxassetid://121454505477205",
    }
}

local ANIM_PACK_ORDER = {{"Off", "Off"}, {"Tryhard", "Tryhard"}, {"Crazy", "Crazy"}}

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
    InstaReset   = {kb = Enum.KeyCode.G, gp = nil},
    JumpMode     = {kb = Enum.KeyCode.V, gp = nil},
    TPLock       = {kb = Enum.KeyCode.N, gp = nil},
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
    InstaReset   = {kb = DEFAULT_KB.InstaReset.kb, gp = DEFAULT_KB.InstaReset.gp},
    JumpMode     = {kb = DEFAULT_KB.JumpMode.kb, gp = DEFAULT_KB.JumpMode.gp},
    TPLock       = {kb = DEFAULT_KB.TPLock.kb, gp = DEFAULT_KB.TPLock.gp},
}

_isResetting = false
_lastSavedJSON = nil
_isLoading = false

CONFIG = {
    AUTO_STEAL_ENABLED = false,
    HOLD_MIN = 1.3,
    HOLD_MAX = 2.6,
    ENTRY_DELAY = 0.3,
    COOLDOWN = 0.05,
    STEAL_RANGE = 9,
    PRIME_RANGE = 80,
}

StealState = {
    active = false,
    startTime = 0,
    phase = "idle",
    label = "",
    lastResult = "",
    lastResultTime = 0,
    totalSteals = 0,
    failedSteals = 0,
}

savedStealRadius = CONFIG.STEAL_RANGE
savedStealDuration = CONFIG.HOLD_MAX

local plots = workspace:WaitForChild("Plots")
local AnimalsData = {}
local syncRemotes = nil
local plotAnimalSync = { caches = {}, connections = {} }
local allAnimalsCache = {}
local PromptMemoryCache = {}
local InternalStealCache = {}
local stealConnection = nil

local function splitSyncPath(path)
    if typeof(path) == "table" then return path end
    local out = {}
    for part in string.gmatch(tostring(path), "[^%.]+") do
        table.insert(out, tonumber(part) or part)
    end
    return out
end

local function resolveSyncPath(path, root)
    local current = root
    local parent = nil
    local key = nil
    for _, part in ipairs(splitSyncPath(path)) do
        parent = current
        key = part
        current = current and current[part] or nil
    end
    return current, parent, key
end

local function applyPlotSyncDiff(channelName, packet)
    local cache = plotAnimalSync.caches[channelName]
    if typeof(cache) ~= "table" then return end
    local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
    local current, parent, key = resolveSyncPath(path, cache)
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

local function attachPlotChannel(remote)
    if plotAnimalSync.connections[remote] then return end
    local channelName = tostring(remote.Name)
    if not plots:FindFirstChild(channelName) then return end
    if syncRemotes.requestData and plotAnimalSync.caches[channelName] == nil then
        local ok, data = pcall(function()
            return syncRemotes.requestData:InvokeServer(channelName)
        end)
        if ok and typeof(data) == "table" then
            plotAnimalSync.caches[channelName] = data
        else
            plotAnimalSync.caches[channelName] = {}
        end
    elseif plotAnimalSync.caches[channelName] == nil then
        plotAnimalSync.caches[channelName] = {}
    end
    plotAnimalSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
        for _, packet in ipairs(queue) do
            applyPlotSyncDiff(channelName, packet)
        end
    end)
end

local function detachPlotChannel(channelName)
    for remote, conn in pairs(plotAnimalSync.connections) do
        if tostring(remote.Name) == tostring(channelName) then
            conn:Disconnect()
            plotAnimalSync.connections[remote] = nil
            plotAnimalSync.caches[tostring(channelName)] = nil
            break
        end
    end
end

local function getPlotChannelData(plotName)
    return plotAnimalSync.caches[plotName]
end

local function getPlotOwner(plot)
    local sign = plot:FindFirstChild("PlotSign")
    local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
    local label = frame and frame:FindFirstChild("TextLabel")
    if not label or label.Text == "Empty Base" then return nil end
    return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
end

local function isMyBaseAnimal(animalData)
    if not animalData or not animalData.plot then return false end
    local plot = plots:FindFirstChild(animalData.plot)
    if not plot then return false end
    return getPlotOwner(plot) == LP.DisplayName
end

local function findProximityPromptForAnimal(animalData)
    if not animalData then return nil end
    local cached = PromptMemoryCache[animalData.uid]
    if cached and cached.Parent then return cached end
    local plot = plots:FindFirstChild(animalData.plot)
    if not plot then return nil end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return nil end
    local podium = podiums:FindFirstChild(animalData.slot)
    if not podium then return nil end
    local base = podium:FindFirstChild("Base")
    if not base then return nil end
    local spawn = base:FindFirstChild("Spawn")
    if not spawn then return nil end
    local attach = spawn:FindFirstChild("PromptAttachment")
    if not attach then return nil end
    for _, p in ipairs(attach:GetChildren()) do
        if p:IsA("ProximityPrompt") then
            PromptMemoryCache[animalData.uid] = p
            return p
        end
    end
    return nil
end

local function getAnimalPosition(animalData)
    local plot = plots:FindFirstChild(animalData.plot)
    if not plot then return nil end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return nil end
    local podium = podiums:FindFirstChild(animalData.slot)
    if not podium then return nil end
    return podium:GetPivot().Position
end

local function distToAnimal(animalData)
    local character = LP.Character
    if not character then return math.huge end
    local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
    if not hrp then return math.huge end
    local pos = getAnimalPosition(animalData)
    if not pos then return math.huge end
    return (hrp.Position - pos).Magnitude
end

local function pickClosest()
    local character = LP.Character
    if not character then return nil end
    local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
    if not hrp then return nil end
    local best, bestDist = nil, math.huge
    for _, animalData in ipairs(allAnimalsCache) do
        if isMyBaseAnimal(animalData) then continue end
        local pos = getAnimalPosition(animalData)
        if not pos then continue end
        local dist = (hrp.Position - pos).Magnitude
        if dist > CONFIG.PRIME_RANGE then continue end
        if dist < bestDist then
            bestDist = dist
            best = animalData
        end
    end
    return best
end

local function scanAllPlots()
    local newCache = {}
    for _, plot in ipairs(plots:GetChildren()) do
        local cache = getPlotChannelData(plot.Name)
        if not cache then continue end
        local animalList = cache.AnimalList
        if typeof(animalList) ~= "table" then continue end
        for slot, animalData in pairs(animalList) do
            if type(animalData) == "table" then
                local animalName = animalData.Index
                local animalInfo = AnimalsData[animalName]
                if not animalInfo then continue end
                table.insert(newCache, {
                    name = animalInfo.DisplayName or animalName,
                    plot = plot.Name,
                    slot = tostring(slot),
                    uid = plot.Name .. "_" .. tostring(slot),
                })
            end
        end
    end
    allAnimalsCache = newCache
    return #allAnimalsCache
end

local function buildStealCallbacks(prompt)
    if InternalStealCache[prompt] then return end
    local data = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }
    local ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
    if ok1 and type(conns1) == "table" then
        for _, conn in ipairs(conns1) do
            if type(conn.Function) == "function" then
                table.insert(data.holdCallbacks, conn.Function)
            end
        end
    end
    local ok2, conns2 = pcall(getconnections, prompt.Triggered)
    if ok2 and type(conns2) == "table" then
        for _, conn in ipairs(conns2) do
            if type(conn.Function) == "function" then
                table.insert(data.triggerCallbacks, conn.Function)
            end
        end
    end
    if (#data.holdCallbacks > 0) or (#data.triggerCallbacks > 0) then
        InternalStealCache[prompt] = data
    end
end

local function executeStealAsync(prompt, animalData)
    local data = InternalStealCache[prompt]
    if not data or not data.ready then return false end
    data.ready = false

    local label = animalData.name or "Animal"
    StealState.active = true
    StealState.startTime = tick()
    StealState.phase = "holding"
    StealState.label = label

    task.spawn(function()
        for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
        task.wait(CONFIG.HOLD_MIN)
        StealState.phase = "waitingRange"
        local alreadyInRange = distToAnimal(animalData) <= CONFIG.STEAL_RANGE
        local fired = false
        while true do
            local elapsed = tick() - StealState.startTime
            if elapsed > CONFIG.HOLD_MAX then break end
            if not prompt.Parent then break end
            if distToAnimal(animalData) <= CONFIG.STEAL_RANGE then
                if not alreadyInRange then task.wait(CONFIG.ENTRY_DELAY) end
                for _, fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
                fired = true
                break
            end
            task.wait()
        end
        if fired then
            StealState.totalSteals = StealState.totalSteals + 1
            StealState.lastResult = "Stole " .. label
        else
            StealState.failedSteals = StealState.failedSteals + 1
            StealState.lastResult = "Missed window: " .. label
        end
        StealState.active = false
        StealState.phase = "idle"
        StealState.lastResultTime = tick()
        task.wait(CONFIG.COOLDOWN)
        data.ready = true
    end)
    return true
end

local function attemptSteal(prompt, animalData)
    if not prompt or not prompt.Parent then return false end
    buildStealCallbacks(prompt)
    if not InternalStealCache[prompt] then return false end
    return executeStealAsync(prompt, animalData)
end

function startAutoSteal()
    if stealConnection then return end
    stealConnection = RunService.Heartbeat:Connect(function()
        if not CONFIG.AUTO_STEAL_ENABLED then return end
        if StealState.active then return end
        local target = pickClosest()
        if not target then return end
        local prompt = PromptMemoryCache[target.uid]
        if not prompt or not prompt.Parent then
            prompt = findProximityPromptForAnimal(target)
        end
        if prompt then attemptSteal(prompt, target) end
    end)
end

function stopAutoSteal()
    if stealConnection then
        stealConnection:Disconnect()
        stealConnection = nil
    end
    StealState.active = false
    StealState.phase = "idle"
end

do
    local Packages = ReplicatedStorage:WaitForChild("Packages")
    local Datas = ReplicatedStorage:WaitForChild("Datas")
    AnimalsData = require(Datas:WaitForChild("Animals"))
    local folder = Packages:WaitForChild("Synchronizer")
    syncRemotes = {
        channelFolder = folder:WaitForChild("Channel"),
        routeRemote = folder:WaitForChild("CommunicationRoute"),
        requestData = folder:FindFirstChild("RequestData"),
    }
    for _, child in ipairs(syncRemotes.channelFolder:GetChildren()) do
        if child:IsA("RemoteEvent") then attachPlotChannel(child) end
    end
    syncRemotes.channelFolder.ChildAdded:Connect(function(child)
        if child:IsA("RemoteEvent") then attachPlotChannel(child) end
    end)
    syncRemotes.routeRemote.OnClientEvent:Connect(function(actions)
        for _, action in ipairs(actions) do
            local kind, channelName = action[1], tostring(action[2])
            if not plots:FindFirstChild(channelName) then continue end
            if kind == "ListenerAdded" then
                local remote = syncRemotes.channelFolder:FindFirstChild(channelName)
                if remote and remote:IsA("RemoteEvent") then attachPlotChannel(remote) end
            elseif kind == "ListenerRemoved" then
                detachPlotChannel(channelName)
            end
        end
    end)
    scanAllPlots()
end

task.spawn(function()
    while task.wait(5) do scanAllPlots() end
end)

medusaDebounce = false
medusaLastUsed = 0
dropActive = false
lastDropTime = 0
lastMoveDir = Vector3.new(0,0,0)
local speedLV = nil
local speedAttachment = nil
origFOV = 70

resetRemote = nil
GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
autoResetStates = {
    BALLOON = false,
    JAIL = false,
    TINY = false,
    RAGDOLL = false,
    ROCKET = false
}

_anyKeyListening = false
_aimbotConn = nil
_prevAutoRotate = nil
tpLockEnabled = false
tpLockSetVisual = nil
tpLockConn = nil
tpLockPrevAutoRotate = nil
tpLockHitCD = false
TP_LOCK_SWING_CD = 0.08
tpBatFloatingButton = nil

enemySpeedConn = nil
movementLoop = nil
steppedConn = nil
alConn = nil
arConn = nil
infJumpConn = nil
holdJumpConn = nil
holdJumpJumpConn = nil
mobileJumpConn = nil
heartbeatJumpConn = nil
mobileAddedConn = nil
autoTPDownConn = nil
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
progressRadLbl = nil
pbFrame = nil
speedLabel = nil
modeValLbl = nil
normalBox, carryBox, laggerBox, lagger2Box, radInput, autoTPHeightBox, batSpeedBox, uiScaleBox = nil, nil, nil, nil, nil, nil, nil, nil
modeSelectBtn, dropModeBtnRef = nil, nil
setJumpToggleState = nil
autoBatSetVisual, autoLeftSetVisual, autoRightSetVisual, setBatCounterVisual, setMedusaVisual, setMedusaAutoResetVisual = nil, nil, nil, nil, nil, nil
setAntiRagVisual, setJumpVisual, setUnwalkVisual, setAntiLagVisual, setAutoTPDownVisual, setLockUIVisual, setInstaGrab = nil, nil, nil, nil, nil, nil, nil
setEditModeVisual = nil
setESPVIsual = nil
mobSetAutoBat, mobSetAutoLeft, mobSetAutoRight, mobSetDropBR, mobSetTpDown, mobSetCarry, mobSetLagger1, mobSetLagger2 = nil, nil, nil, nil, nil, nil, nil, nil
miniBtn, main, gui = nil, nil, nil
MobilePanel = nil
instaResetFloatingButton = nil
showGui = nil
hideGui = nil
mainUIScale = nil
animSelectorLabel = nil
pbScale = nil
fovToggleBtn = nil
fovContainer = nil
skySelectorLabel = nil

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

local function isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand
        or st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.FallingDown
end

local function getActiveMoveSpeed()
    if laggerToggled then
        return (laggerLevel == 2) and LAGGER_SPEED_2 or LAGGER_SPEED_1
    else
        return speedMode and CS or NS
    end
end

local function setupSpeedLinearVelocity(char)
    if speedLV then pcall(function() speedLV:Destroy() end); speedLV = nil end
    if speedAttachment then pcall(function() speedAttachment:Destroy() end); speedAttachment = nil end
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    speedAttachment = Instance.new("Attachment")
    speedAttachment.Name = "TraceSpeedLV_Attachment"
    speedAttachment.Parent = hrp
    speedLV = Instance.new("LinearVelocity")
    speedLV.Name = "TraceSpeedLinearVelocity"
    speedLV.Attachment0 = speedAttachment
    speedLV.RelativeTo = Enum.ActuatorRelativeTo.World
    speedLV.VectorVelocity = Vector3.zero
    speedLV.ForceLimitMode = Enum.ForceLimitMode.PerAxis
    speedLV.MaxAxesForce = Vector3.new(100000, 0, 100000)
    speedLV.Enabled = false
    speedLV.Parent = hrp
end

BAT_COUNTER_SLAP_LIST = {
    "Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap",
    "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap",
    "Nuclear Slap", "Galaxy Slap", "Glitched Slap"
}

AP = {
    L1 = Vector3.new(-476.48, -6.28, 92.73),
    L2 = Vector3.new(-483.12, -4.95, 94.80),
    L_FACE = Vector3.new(-482.25, -4.96, 92.09),
    R1 = Vector3.new(-476.16, -6.52, 25.62),
    R2 = Vector3.new(-483.06, -5.03, 25.48),
    R_FACE = Vector3.new(-482.06, -6.93, 35.47),
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

function resetProgressBar()
    if progressPct then progressPct.Text = "0%" end
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
end

local _tpDownActive = false

function runTPDown()
    if _tpDownActive then return end
    _tpDownActive = true
    pcall(function()
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then _tpDownActive = false; return end
        root.CFrame = CFrame.new(root.Position.X, -7.00, root.Position.Z) * CFrame.Angles(0, select(2, root.CFrame:ToEulerAnglesYXZ()), 0)
        root.Velocity = Vector3.zero
    end)
    _tpDownActive = false
end

function startAutoTPDown()
    if autoTPDownConn then task.cancel(autoTPDownConn); autoTPDownConn = nil end
    autoTPDownConn = task.spawn(function()
        while autoTPDownEnabled do
            task.wait(0.1)
            if not autoTPDownEnabled then break end
            pcall(function()
                local char = LP.Character; if not char then return end
                local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
                local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
                if hum.FloorMaterial ~= Enum.Material.Air then return end
                if root.Position.Y < autoTPDownHeight then return end
                root.CFrame = CFrame.new(root.Position.X, -7.00, root.Position.Z) * CFrame.Angles(0, select(2, root.CFrame:ToEulerAnglesYXZ()), 0)
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end)
        end
    end)
end

function stopAutoTPDown()
    autoTPDownEnabled = false
    if autoTPDownConn then task.cancel(autoTPDownConn); autoTPDownConn = nil end
end

local AntiRagdollV2 = {
    Enabled = false,
    Connection = nil,
    ResetCooldown = 0,
}

local function startAntiRagdoll()
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
        local now = tick()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown then
            if now - AntiRagdollV2.ResetCooldown > 0.15 then
                AntiRagdollV2.ResetCooldown = now
                pcall(function()
                    if hum:GetState() == Enum.HumanoidStateType.GettingUp then return end
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

local function stopAntiRagdoll()
    AntiRagdollV2.Enabled = false
    if AntiRagdollV2.Connection then
        AntiRagdollV2.Connection:Disconnect()
        AntiRagdollV2.Connection = nil
    end    AntiRagdollV2.ResetCooldown = 0
end

local function setAntiRag(on)
    antiRagdollEnabled = on
    if on then startAntiRagdoll() else stopAntiRagdoll() end
    if setAntiRagVisual then setAntiRagVisual(on) end
end

do
    local _ragCountdownRunning = false

    local function _getRagBillboard()
        local char = LP.Character
        if not char then return nil, nil end
        local head = char:FindFirstChild("Head")
        if not head then return nil, nil end
        local pGui = LP.PlayerGui
        local existing = pGui:FindFirstChild("RagCountdownBillboard")
        if existing then existing:Destroy() end
        local bb = Instance.new("BillboardGui")
        bb.Name = "RagCountdownBillboard"
        bb.Size = UDim2.new(0, 84, 0, 42)
        bb.StudsOffset = Vector3.new(0, 4.5, 0)
        bb.AlwaysOnTop = true
        bb.Adornee = head
        bb.Parent = pGui
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.AnchorPoint = Vector2.new(0.5, 0.5)
        lbl.Position = UDim2.new(0.5, 0, 0.5, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextScaled = true
        lbl.TextColor3 = Color3.fromRGB(255, 150, 150)
        lbl.TextStrokeColor3 = Color3.fromRGB(255, 150, 150)
        lbl.TextStrokeTransparency = 0
        lbl.Text = ""
        lbl.Parent = bb
        return bb, lbl
    end

    local function _ragPunch(lbl, text)
        if not (lbl and lbl.Parent) then return end
        lbl.Text = text
    end

    local function _startRagCountdown()
        if _ragCountdownRunning then return end
        _ragCountdownRunning = true
        task.spawn(function()
            local bb, lbl = _getRagBillboard()
            if not bb then _ragCountdownRunning = false; return end
            local timeLeft = 2.5
            local step     = 0.1
            while timeLeft > 0 and bb.Parent do
                _ragPunch(lbl, string.format("%.1f", timeLeft))
                task.wait(step)
                timeLeft = timeLeft - step
            end
            if bb and bb.Parent then
                _ragPunch(lbl, "READY!")
                task.wait(0.5)
                if bb and bb.Parent then bb:Destroy() end
            end
            _ragCountdownRunning = false
        end)
    end

    local _wasRagdolled = false
    RunService.Heartbeat:Connect(function()
        local char = LP.Character
        if not char then _wasRagdolled = false; return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then _wasRagdolled = false; return end
        local st = hum:GetState()
        local inRag = st == Enum.HumanoidStateType.Physics
                   or st == Enum.HumanoidStateType.Ragdoll
                   or st == Enum.HumanoidStateType.FallingDown
        if inRag and not _wasRagdolled then
            _wasRagdolled = true
            _startRagCountdown()
        elseif not inRag then
            _wasRagdolled = false
        end
    end)
end

local function setupChar(char)
    if antiRagdollEnabled then
        task.wait(0.5)
        startAntiRagdoll()
    end
end
LP.CharacterAdded:Connect(setupChar)
if LP.Character then
    task.spawn(function() setupChar(LP.Character) end)
end

local espHighlightCache = {}
local espBillboardCache = {}
local espTracerCache = {}
local espConn = nil
local _espLastRun = 0

local function clearESP()
    for plr in pairs(espHighlightCache) do
        pcall(function() espHighlightCache[plr]:Destroy() end)
    end
    for plr in pairs(espBillboardCache) do
        pcall(function() espBillboardCache[plr]:Destroy() end)
    end
    for plr in pairs(espTracerCache) do
        for _, ln in ipairs(espTracerCache[plr]) do
            pcall(function() ln.Visible = false; ln:Remove() end)
        end
    end
    espHighlightCache = {}
    espBillboardCache = {}
    espTracerCache = {}
end

local function makeESPBillboard(tHead)
    return nil, nil
end

local function makeESPTracers()
    if not (Drawing and type(Drawing.new) == "function") then return nil end
    local WHITE = Color3.fromRGB(255, 255, 255)
    local outer = Drawing.new("Line")
    outer.Color = WHITE
    outer.Thickness = 2.2
    outer.Transparency = 0.90
    outer.Visible = false
    local mid = Drawing.new("Line")
    mid.Color = WHITE
    mid.Thickness = 1.2
    mid.Transparency = 0.74
    mid.Visible = false
    local core = Drawing.new("Line")
    core.Color = WHITE
    core.Thickness = 0.6
    core.Transparency = 0.10
    core.Visible = false
    return {outer, mid, core}
end

local function updateESP()
    local now = tick()
    if now - _espLastRun < 0.03 then return end
    _espLastRun = now
    if not espEnabled then clearESP(); return end
    local myChar = LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local myPos = myRoot.Position
    local myScreenPos, myOnScreen = camera:WorldToViewportPoint(myPos)
    local myVec = Vector2.new(myScreenPos.X, myScreenPos.Y)
    local currentPlayers = Players:GetPlayers()
    local plrSet = {}
    for _, p in ipairs(currentPlayers) do plrSet[p] = true end
    for plr in pairs(espHighlightCache) do
        if not plrSet[plr] then
            pcall(function() espHighlightCache[plr]:Destroy() end)
            espHighlightCache[plr] = nil
        end
    end
    for plr in pairs(espTracerCache) do
        if not plrSet[plr] then
            for _, ln in ipairs(espTracerCache[plr]) do
                pcall(function() ln.Visible = false; ln:Remove() end)
            end
            espTracerCache[plr] = nil
        end
    end
    for _, plr in ipairs(currentPlayers) do
        if plr == LP then continue end
        local char = plr.Character
        if not char then
            if espHighlightCache[plr] then
                pcall(function() espHighlightCache[plr]:Destroy() end)
                espHighlightCache[plr] = nil
            end
            if espBillboardCache[plr] then
                pcall(function() espBillboardCache[plr]:Destroy() end)
                espBillboardCache[plr] = nil
            end
            if espTracerCache[plr] then
                for _, ln in ipairs(espTracerCache[plr]) do
                    pcall(function() ln.Visible = false end)
                end
            end
            continue
        end
        local tRoot = char:FindFirstChild("HumanoidRootPart")
        local tHead = char:FindFirstChild("Head")
        local tHum = char:FindFirstChildOfClass("Humanoid")
        local alive = tRoot and tHead and tHum and tHum.Health > 0
        if alive then
            local hl = espHighlightCache[plr]
            if not hl or not hl.Parent or hl.Parent ~= char then
                if hl then pcall(function() hl:Destroy() end) end
                hl = Instance.new("Highlight")
                hl.Name = "TraceESP"
                hl.FillColor = Color3.fromRGB(50, 0, 0)
                hl.FillTransparency = 0.72
                hl.OutlineColor = Color3.fromRGB(50, 0, 0)
                hl.OutlineTransparency = 0.05
                hl.Adornee = char
                hl.Parent = char
                espHighlightCache[plr] = hl
            end
            local lines = espTracerCache[plr]
            if not lines then
                lines = makeESPTracers()
                espTracerCache[plr] = lines or {}
            end
            if lines and #lines > 0 then
                local destPos = tRoot.Position
                local pos, onScreen = camera:WorldToViewportPoint(destPos)
                if onScreen and pos.Z > 0 and myOnScreen then
                    local tVec = Vector2.new(pos.X, pos.Y)
                    for _, ln in ipairs(lines) do
                        ln.From = myVec
                        ln.To = tVec
                        ln.Visible = true
                    end
                else
                    for _, ln in ipairs(lines) do ln.Visible = false end
                end
            end
        else
            if espHighlightCache[plr] then
                pcall(function() espHighlightCache[plr]:Destroy() end)
                espHighlightCache[plr] = nil
            end
            if espBillboardCache[plr] then
                pcall(function() espBillboardCache[plr]:Destroy() end)
                espBillboardCache[plr] = nil
            end
            if espTracerCache[plr] then
                for _, ln in ipairs(espTracerCache[plr]) do
                    pcall(function() ln.Visible = false end)
                end
            end
        end
    end
end

local function startESPLoop()
    if espConn then espConn:Disconnect() end
    espConn = RunService.RenderStepped:Connect(updateESP)
end

local function stopESPLoop()
    if espConn then espConn:Disconnect(); espConn = nil end
    clearESP()
end

function toggleESP(on)
    espEnabled = on
    if on then startESPLoop() else stopESPLoop() end
    if setESPVIsual then setESPVIsual(on) end
end

local function getClosestTargetBody()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = tRoot
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
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    local dist = (target.Position - root.Position).Magnitude
    if dist > bodyLockRange then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    if hum.AutoRotate then hum.AutoRotate = false end

    local targetVel = target.AssemblyLinearVelocity
    local speed3 = targetVel.Magnitude
    local predictTime = math.clamp(speed3 / 80, 0.08, 0.35)
    local predictedPos = target.Position + targetVel * predictTime

    local targetHead = target.Parent and target.Parent:FindFirstChild("Head")
    local targetHeight = targetHead and targetHead.Position.Y or target.Position.Y
    local myHeight = root.Position.Y + (hum.HipHeight or 0)
    local heightDiff = targetHeight - myHeight
    local verticalCorrection = math.clamp(heightDiff * 0.15, -1.5, 1.5)

    local flatTarget = Vector3.new(predictedPos.X, root.Position.Y + verticalCorrection, predictedPos.Z)
    local toPredict = flatTarget - root.Position
    if toPredict.Magnitude > 0.1 then
        local goalCF = CFrame.lookAt(root.Position, flatTarget)
        local diffCF = root.CFrame:Inverse() * goalCF
        local _, ry, _ = diffCF:ToEulerAnglesXYZ()
        ry = math.clamp(ry, -2.5, 2.5)
        root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(0, ry * 42, 0))
    end
end

function startBodyLock()
    if _bodyLockConn then _bodyLockConn:Disconnect() end
    _bodyLockConn = RunService.RenderStepped:Connect(function()
        if not bodyLockEnabled then return end
        if _blSuppressCount > 0 then return end
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
        root.AssemblyAngularVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, -0.1, root.AssemblyLinearVelocity.Z)
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
        local function restore()
            if bodyLockEnabled then
                _blSmoothRestore = true
                startBodyLock()
                if bodyLockSetVisual then bodyLockSetVisual(true) end
                task.delay(0.5, function()
                    _blSmoothRestore = false
                end)
            end
            _blRestoreTimer = nil
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
    local oldBB = head:FindFirstChild("TraceSpeedIndicator")
    if oldBB then oldBB:Destroy() end
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "TraceSpeedIndicator"
    bb.Size = UDim2.new(0, 120, 0, 32)
    bb.StudsOffset = Vector3.new(0, 3.2, 0)
    bb.AlwaysOnTop = true
    speedLabel = Instance.new("TextLabel", bb)
    speedLabel.Size = UDim2.new(1, 0, 1, 0)
    speedLabel.Position = UDim2.new(0, 0, 0, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Spd: 0.0"
    speedLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextScaled = true
    speedLabel.TextStrokeTransparency = 0
    speedLabel.TextStrokeColor3 = Color3.fromRGB(255, 150, 150)
end

function updateEnemySpeedLabels()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") and char:FindFirstChildOfClass("Humanoid").Health > 0 then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local velocity = hrp.AssemblyLinearVelocity
                local speed = (Vector3.new(velocity.X, 0, velocity.Z).Magnitude)
                local label = enemySpeedLabels[player]
                if not label then
                    local head = char:FindFirstChild("Head")
                    if head then
                        local bb = Instance.new("BillboardGui", head)
                        bb.Size = UDim2.new(0, 100, 0, 25)
                        bb.StudsOffset = Vector3.new(0, 3.5, 0)
                        bb.AlwaysOnTop = true
                        bb.Name = "EnemySpeedGui"
                        local textLabel = Instance.new("TextLabel", bb)
                        textLabel.Size = UDim2.new(1, 0, 1, 0)
                        textLabel.BackgroundTransparency = 1
                        textLabel.Text = string.format("%.1f", speed)
                        textLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
                        textLabel.Font = Enum.Font.GothamBold
                        textLabel.TextScaled = true
                        textLabel.TextStrokeTransparency = 0
                        textLabel.TextStrokeColor3 = Color3.fromRGB(255, 150, 150)
                        label = textLabel
                        enemySpeedLabels[player] = label
                    end
                elseif label and label.Parent and label.Parent.Parent ~= char then
                    local head = char:FindFirstChild("Head")
                    if head then label.Parent.Parent = head end
                end
                if label then label.Text = string.format("%.1f", speed) end
            else
                local label = enemySpeedLabels[player]
                if label and label.Parent and label.Parent.Parent then label.Parent.Parent = nil end
                enemySpeedLabels[player] = nil
            end
        end
    end
    for player, label in pairs(enemySpeedLabels) do
        if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            if label and label.Parent and label.Parent.Parent then label.Parent.Parent = nil end
            enemySpeedLabels[player] = nil
        end
    end
end

function startEnemySpeed()
    if enemySpeedConn then enemySpeedConn:Disconnect() end
    enemySpeedConn = RunService.Heartbeat:Connect(function()
        updateEnemySpeedLabels()
    end)
end

function stopEnemySpeed()
    if enemySpeedConn then enemySpeedConn:Disconnect(); enemySpeedConn = nil end
end

-- New Jump Logic Helpers (from Modified_BrokenHubMobile7_57_Corrected38(2).txt)
local function applyImpulseForVelocity(hrp, desiredVelocity)
    if not hrp then return end
    local mass = hrp.AssemblyMass
    local currentVel = hrp.AssemblyLinearVelocity
    local impulse = (desiredVelocity - currentVel) * mass
    hrp:ApplyImpulse(impulse)
end

local function applyImpulseZero(hrp)
    if not hrp then return end
    local mass = hrp.AssemblyMass
    local currentVel = hrp.AssemblyLinearVelocity
    hrp:ApplyImpulse(-currentVel * mass)
end

local function aceInfJumpIsCarrying(char)
    char = char or LP.Character
    if not char then return false end
    local ok1, v1 = pcall(function() return LP:GetAttribute("Stealing") end)
    if ok1 and v1 == true then return true end
    local ok2, v2 = pcall(function() return char:GetAttribute("Stealing") end)
    if ok2 and v2 == true then return true end
    local ok3, v3 = pcall(function() return LP:GetAttribute("AntiKick") end)
    if ok3 and v3 == true then return true end
    if _G.AutoCarrySpeed and type(_G.AutoCarrySpeed.IsCarryingBrainrot) == "function" then
        local ok4, v4 = pcall(function() return _G.AutoCarrySpeed.IsCarryingBrainrot(char) end)
        if ok4 and v4 == true then return true end
    end
    return false
end

_G.AceNormalInfJump = _G.AceNormalInfJump or {holdPressed=false, holdActive=false, controllerActive=false, mobilePressed=false, mobileActive=false, hooked={}}

local function AceStopNormalInfJumpHoldState()
    local S = _G.AceNormalInfJump
    if S then
        S.holdPressed = false
        S.holdActive = false
        S.controllerActive = false
        S.mobilePressed = false
        S.mobileActive = false
    end
end

local function AceApplyNormalInfJumpBoost(boost)
    if not jumpEnabled then return end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 then return end
    if aceInfJumpIsCarrying(char) then
        -- ANTI-DROP + ANTI-RESET FIX
        local currentVel = root.AssemblyLinearVelocity
        local CARRY_JUMP_MAX = 24
        local CARRY_JUMP_STEP = 8
        if currentVel.Y < CARRY_JUMP_MAX then
            local newY = math.min(CARRY_JUMP_MAX, math.max(currentVel.Y, 0) + CARRY_JUMP_STEP)
            applyImpulseForVelocity(root, Vector3.new(currentVel.X, newY, currentVel.Z))
        end
        return
    end
    local currentVel = root.AssemblyLinearVelocity
    local targetY = tonumber(boost) or 35
    applyImpulseForVelocity(root, Vector3.new(currentVel.X, targetY, currentVel.Z))
end

local function AceHookNormalInfMobileJumpButton(obj)
    local S = _G.AceNormalInfJump
    if not obj or obj.Name ~= "JumpButton" or not obj:IsA("GuiButton") or S.hooked[obj] then return end
    S.hooked[obj] = true
    obj.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Touch or not jumpEnabled then return end
        S.mobilePressed = true
        task.delay(0.12, function()
            if S.mobilePressed and jumpEnabled then
                S.mobileActive = true
                AceApplyNormalInfJumpBoost(35)
            end
        end)
    end)
    obj.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            S.mobilePressed = false
            S.mobileActive = false
        end
    end)
    obj.AncestryChanged:Connect(function(_, parent)
        if not parent then
            S.hooked[obj] = nil
            S.mobilePressed = false
            S.mobileActive = false
        end
    end)
end

function stopJumpMode()
    jumpEnabled = false
    AceStopNormalInfJumpHoldState()
    if infJumpConn then infJumpConn:Disconnect(); infJumpConn = nil end
    if holdJumpConn then holdJumpConn:Disconnect(); holdJumpConn = nil end
    if holdJumpJumpConn then holdJumpJumpConn:Disconnect(); holdJumpJumpConn = nil end
    if mobileJumpConn then mobileJumpConn:Disconnect(); mobileJumpConn = nil end
    if heartbeatJumpConn then heartbeatJumpConn:Disconnect(); heartbeatJumpConn = nil end
    if mobileAddedConn then mobileAddedConn:Disconnect(); mobileAddedConn = nil end
end

function startJumpMode()
    stopJumpMode()
    jumpEnabled = true
    
    local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui")
    
    infJumpConn = UIS.JumpRequest:Connect(function()
        AceApplyNormalInfJumpBoost(35)
    end)
    
    holdJumpConn = UIS.InputBegan:Connect(function(input)
        if UIS:GetFocusedTextBox() then return end
        local S = _G.AceNormalInfJump
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
            S.holdPressed = true
            task.delay(0.12, function()
                if S.holdPressed and jumpEnabled then
                    S.holdActive = true
                    AceApplyNormalInfJumpBoost(35)
                end
            end)
        elseif input.KeyCode == Enum.KeyCode.ButtonA and input.UserInputType.Name:match("^Gamepad") then
            S.controllerActive = true
        end
    end)
    
    holdJumpJumpConn = UIS.InputEnded:Connect(function(input)
        local S = _G.AceNormalInfJump
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
            S.holdPressed = false
            S.holdActive = false
        end
        if input.KeyCode == Enum.KeyCode.ButtonA and input.UserInputType.Name:match("^Gamepad") then
            S.controllerActive = false
        end
    end)
    
    for _, obj in ipairs(pg:GetDescendants()) do
        AceHookNormalInfMobileJumpButton(obj)
    end
    mobileAddedConn = pg.DescendantAdded:Connect(function(obj)
        task.defer(AceHookNormalInfMobileJumpButton, obj)
    end)
    
    heartbeatJumpConn = RunService.Heartbeat:Connect(function()
        local S = _G.AceNormalInfJump
        if jumpEnabled and (S.holdActive or S.mobileActive or S.controllerActive) then
            AceApplyNormalInfJumpBoost(35)
        end
    end)
end

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
        if laggerToggled then
            modeValLbl.Text = laggerLevel == 1 and "Lagger Spd" or "Lagger Carry"
        elseif speedMode then
            modeValLbl.Text = "Carry Mode"
        else
            modeValLbl.Text = "Normal"
        end
    end
end

function resetMovementState()
    refreshSpeedModeLabel()
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled and laggerLevel == 1) end
    if mobSetLagger2 then mobSetLagger2(laggerToggled and laggerLevel == 2) end
end

function toggleCarryMode()
    if laggerToggled then
        laggerToggled = false
        laggerLevel = 1
        speedMode = true
    else
        speedMode = not speedMode
        if speedMode then
            laggerToggled = false
            laggerLevel = 1
        end
    end
    resetMovementState()
end

function toggleLaggerCycle()
    if speedMode then
        speedMode = false
        if mobSetCarry then mobSetCarry(false) end
    end
    if not laggerToggled then
        laggerToggled = true
        laggerLevel = 1
    else
        laggerLevel = (laggerLevel == 1) and 2 or 1
    end
    resetMovementState()
end

function runTPFloor()
    pcall(function()
        local char = LP.Character; if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        hrp.CFrame = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z) * CFrame.Angles(0, select(2, hrp.CFrame:ToEulerAnglesYXZ()), 0)
        hrp.Velocity = Vector3.zero
    end)
end

local oldFire
oldFire = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
    if not resetRemote and self.Name:sub(1,3) == "RE/" then
        resetRemote = self
    end
    return oldFire(self, ...)
end))

task.spawn(function()
    task.wait(2)
    if not resetRemote then
        for _, d in pairs(game:GetDescendants()) do
            if d:IsA("RemoteEvent") and d.Name:sub(1,3) == "RE/" then
                resetRemote = d
                break
            end
        end
    end
end)

task.spawn(function()
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            obj.OnClientEvent:Connect(function(...)
                for _, arg in ipairs({...}) do
                    if type(arg) == "string" then
                        local msg = arg:lower()
                        if msg:find("jump higher") and autoResetStates.BALLOON then
                            instareset("balloon")
                        elseif msg:find("jail") and autoResetStates.JAIL then
                            instareset("jail")
                        elseif msg:find("tiny") and autoResetStates.TINY then
                            instareset("tiny")
                        elseif msg:find("ragdoll") and autoResetStates.RAGDOLL then
                            instareset("ragdoll")
                        elseif msg:find("rocket") and autoResetStates.ROCKET then
                            instareset("rocket")
                        end
                    end
                end
            end)
        end
    end
end)

function instareset(resetType)
    if not resetRemote then return end
    local oldChar = LP.Character
    task.spawn(function()
        local attempts = 0
        while attempts < 50 do
            pcall(function() resetRemote:FireServer(GUID, LP, resetType or "balloon") end)
            task.wait(0.05)
            attempts = attempts + 1
            if LP.Character ~= oldChar then break end
        end
    end)
end

function instaReset()
    instareset("balloon")
end

function stopAutoLeft()
    if alConn then alConn:Disconnect(); alConn = nil end
    alPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(Vector3.zero, false) end
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
        local spd = laggerToggled and LAGGER_SPEED_1 or NS
        if alPhase == 1 then
            local tgt = Vector3.new(AP.L1.X, root.Position.Y, AP.L1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                alPhase = 2
                local d = AP.L2 - root.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.L1 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif alPhase == 2 then
            local tgt = Vector3.new(AP.L2.X, root.Position.Y, AP.L2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                root.AssemblyLinearVelocity = Vector3.zero
                autoLeftEnabled = false
                if alConn then alConn:Disconnect(); alConn = nil end
                alPhase = 1
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if mobSetAutoLeft then mobSetAutoLeft(false) end
                _unsuppressBodyLock(true)
                local facePos = Vector3.new(AP.L_FACE.X, root.Position.Y, AP.L_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = CFrame.new(root.Position, facePos)
                end
                return
            end
            local d = AP.L2 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end

function stopAutoRight()
    if arConn then arConn:Disconnect(); arConn = nil end
    arPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(Vector3.zero, false) end
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
        local spd = laggerToggled and LAGGER_SPEED_1 or NS
        if arPhase == 1 then
            local tgt = Vector3.new(AP.R1.X, root.Position.Y, AP.R1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                arPhase = 2
                local d = AP.R2 - root.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.R1 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif arPhase == 2 then
            local tgt = Vector3.new(AP.R2.X, root.Position.Y, AP.R2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                root.AssemblyLinearVelocity = Vector3.zero
                autoRightEnabled = false
                if arConn then arConn:Disconnect(); arConn = nil end
                arPhase = 1
                if autoRightSetVisual then autoRightSetVisual(false) end
                if mobSetAutoRight then mobSetAutoRight(false) end
                _unsuppressBodyLock(true)
                local facePos = Vector3.new(AP.R_FACE.X, root.Position.Y, AP.R_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = CFrame.new(root.Position, facePos)
                end
                return
            end
            local d = AP.R2 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end

function getClosestTarget()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = tRoot
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

function stopAimbotAdapt()
    if _aimbotConn then
        pcall(function() _aimbotConn:Disconnect() end)
        _aimbotConn = nil
    end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = (_prevAutoRotate == nil) and true or _prevAutoRotate
        hum.PlatformStand = false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    if root then
        root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
        root.AssemblyAngularVelocity = Vector3.zero
    end
    _prevAutoRotate = nil
    lastMoveDir = Vector3.zero
    _unsuppressBodyLock(true)
end

function startAimbotAdapt()
    if _aimbotConn then return end
    _suppressBodyLock()
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then
        if _prevAutoRotate == nil then _prevAutoRotate = hum0.AutoRotate end
        hum0.AutoRotate = false
    end
    _aimbotConn = RunService.RenderStepped:Connect(function()
        if not autoBatEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target = getClosestTarget()
        if not target then return end
        local targetVel = target.AssemblyLinearVelocity
        local myPos = root.Position
        local targetPos = target.Position
        local predictPos = targetPos + targetVel * 0.14
        predictPos = predictPos + target.CFrame.LookVector * 0.3
        local direction = predictPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0 then flatDir = flatDir.Unit else flatDir = Vector3.new(0,0,0) end
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
        yVel = math.clamp(yVel, -70, 110)
        local desiredVel = Vector3.new(flatDir.X * BAT_AIMBOT_SPEED, yVel, flatDir.Z * BAT_AIMBOT_SPEED)
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
        local distToTarget = (root.Position - target.Position).Magnitude
        if distToTarget <= 8 then trySwing() end
    end)
end

function disableAutoBat()
    autoBatEnabled = false
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
    stopAimbotAdapt()
end

function enableAutoBat()
    if autoLeftEnabled then
        autoLeftEnabled = false
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        stopAutoLeft()
    end
    if autoRightEnabled then
        autoRightEnabled = false
        if autoRightSetVisual then autoRightSetVisual(false) end
        stopAutoRight()
    end
    if tpLockEnabled then
        toggleTPLock()
    end
    autoBatEnabled = true
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobSetAutoBat then mobSetAutoBat(true) end
    startAimbotAdapt()
end

local function getClosestPlayer()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil, math.huge end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            if tRoot then
                local d = (tRoot.Position - root.Position).Magnitude
                if d < minDist then minDist = d; closest = plr end
            end
        end
    end
    return closest, minDist
end

local function tpLockTryHit()
    if tpLockHitCD then return end
    tpLockHitCD = true
    pcall(function()
        local char = LP.Character
        if char then
            local bat = findBat()
            if bat then
                if bat.Parent ~= char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then pcall(function() hum:EquipTool(bat) end) end
                end
                pcall(function() bat:Activate() end)
                local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
                if ev then pcall(function() ev:FireServer() end) end
            end
        end
    end)
    task.delay(TP_LOCK_SWING_CD, function() tpLockHitCD = false end)
end

local function startTPLock()
    if tpLockConn then tpLockConn:Disconnect() end
    if autoLeftEnabled then autoLeftEnabled = false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end end
    if autoRightEnabled then autoRightEnabled = false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end end
    if autoBatEnabled then disableAutoBat() end
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        if tpLockPrevAutoRotate == nil then tpLockPrevAutoRotate = hum.AutoRotate end
        hum.AutoRotate = false
    end
    tpLockConn = RunService.Heartbeat:Connect(function()
        if not tpLockEnabled then return end
        local char = LP.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
        local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target, targetDist = getClosestPlayer()
        if not target then return end
        local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
        if not tRoot then return end

        if sethiddenproperty then
            pcall(function() sethiddenproperty(root, "PhysicsRepRootPart", tRoot) end)
        end
        local targetPos = tRoot.Position + Vector3.new(0, 0.9, 0)
        if (root.Position - targetPos).Magnitude > 8 then
            root.CFrame = CFrame.new(targetPos)
        end
        workspace.CurrentCamera.CFrame = CFrame.new(
            workspace.CurrentCamera.CFrame.Position, tRoot.Position
        )
        tpLockTryHit()
    end)
end

local function stopTPLock()
    if tpLockConn then tpLockConn:Disconnect(); tpLockConn = nil end
    tpLockHitCD = false
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        if sethiddenproperty then pcall(function() sethiddenproperty(root, "PhysicsRepRootPart", nil) end) end
    end
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = (tpLockPrevAutoRotate == nil) and true or tpLockPrevAutoRotate
        hum.PlatformStand = false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    end
    tpLockPrevAutoRotate = nil
end

function toggleTPLock()
    tpLockEnabled = not tpLockEnabled
    if tpLockEnabled then
        startTPLock()
        if tpLockSetVisual then tpLockSetVisual(true) end
        if tpBatFloatingButton then
            local btnFrame = tpBatFloatingButton:FindFirstChild("Frame")
            if btnFrame then
                btnFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
                local label = btnFrame:FindFirstChild("TextLabel")
                if label then label.TextColor3 = Color3.fromRGB(255, 150, 150) end
            end
        end
    else
        stopTPLock()
        if tpLockSetVisual then tpLockSetVisual(false) end
        if tpBatFloatingButton then
            local btnFrame = tpBatFloatingButton:FindFirstChild("Frame")
            if btnFrame then
                btnFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
                local label = btnFrame:FindFirstChild("TextLabel")
                if label then label.TextColor3 = Color3.fromRGB(255, 150, 150) end
            end
        end
    end
    return tpLockEnabled
end

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
    if tick() - medusaLastUsed < MEDUSA_COOLDOWN then return end
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
    medusaLastUsed = tick()
    medusaDebounce = false
end

function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if medusaCounterEnabled and part.Anchored and part.Transparency == 1 then useMedusaCounter() end
    end)
end

function setupMedusa(char)
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

function onMedusaResetAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if medusaAutoResetEnabled and part.Anchored and part.Transparency == 1 then
            instaReset()
        end
    end)
end

function setupMedusaAutoReset(char)
    for _, c in pairs(medusaResetConns) do pcall(function() c:Disconnect() end) end
    medusaResetConns = {}
    if not char or not medusaAutoResetEnabled then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(medusaResetConns, onMedusaResetAnchorChanged(part))
        end
    end
    table.insert(medusaResetConns, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            table.insert(medusaResetConns, onMedusaResetAnchorChanged(part))
        end
    end))
end

function stopMedusaAutoReset()
    for _, c in pairs(medusaResetConns) do pcall(function() c:Disconnect() end) end
    medusaResetConns = {}
end

function setMedusaCounterState(state)
    medusaCounterEnabled = state
    if state then
        if medusaAutoResetEnabled then
            medusaAutoResetEnabled = false
            if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
            stopMedusaAutoReset()
        end
        if LP.Character then setupMedusa(LP.Character) else stopMedusaCounter() end
    else
        stopMedusaCounter()
    end    if setMedusaVisual then setMedusaVisual(state) end
end

function setMedusaAutoResetState(state)
    medusaAutoResetEnabled = state
    if state then
        if medusaCounterEnabled then
            medusaCounterEnabled = false
            if setMedusaVisual then setMedusaVisual(false) end
            stopMedusaCounter()
        end
        if LP.Character then setupMedusaAutoReset(LP.Character) else stopMedusaAutoReset() end
    else
        stopMedusaAutoReset()
    end
    if setMedusaAutoResetVisual then setMedusaAutoResetVisual(state) end
end

local DROP_ASCEND_DURATION = 0.22
local DROP_ASCEND_SPEED = 160
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
        if root then root.AssemblyLinearVelocity = Vector3.zero end
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
            speedH = Vector3.new(vel.X, 0, vel.Z).Magnitude
        end
        local cooldown = (speedH > 5) and 0.6 or 0.25
        if tick() - lastDropTime < cooldown then return end
        lastDropTime = tick()

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

        local function finishDrop(threadRef)
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
                    r.AssemblyLinearVelocity = Vector3.zero
                    r.AssemblyAngularVelocity = Vector3.zero
                    if r.Position.Y < -100 then
                        r.CFrame = CFrame.new(r.Position.X, 5, r.Position.Z)
                    end
                    local rp = RaycastParams.new()
                    rp.FilterDescendantsInstances = {c}
                    rp.FilterType = Enum.RaycastFilterType.Exclude
                    local rr = workspace:Raycast(r.Position, Vector3.new(0, -2000, 0), rp)
                    if rr then
                        local off = (h and h.HipHeight or 2) + (r.Size.Y / 2)
                        r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + off, r.Position.Z)
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
            local startTime = tick()
            while dropActive and (tick() - startTime) < 0.25 do
                RunService.Heartbeat:Wait()
                local c = LP.Character
                local r = c and c:FindFirstChild("HumanoidRootPart")
                if not r then break end
                local vel = r.AssemblyLinearVelocity
                vel = Vector3.new(0, vel.Y, 0)
                r.AssemblyLinearVelocity = vel * 10000 + Vector3.new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if r and r.Parent then r.AssemblyLinearVelocity = vel end
                RunService.Stepped:Wait()
                if r and r.Parent then r.AssemblyLinearVelocity = vel + Vector3.new(0, 0.1, 0) end
            end
            finishDrop(flingThread)
        end)
        table.insert(dropConnections, flingThread)

        task.delay(0.35, function()
            if dropActive then
                finishDrop(flingThread)
            end
        end)
        return
    end

    dropActive = true
    if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
    if mobSetDropBR then mobSetDropBR(true) end

    local t0 = tick()
    if _dropConn then _dropConn:Disconnect() end
    _dropConn = RunService.Heartbeat:Connect(function()
        local c = LP.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        if not r then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            dropActive = false
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        if not dropActive then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        if tick() - t0 >= DROP_ASCEND_DURATION then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            pcall(function()
                local rp = RaycastParams.new()
                rp.FilterDescendantsInstances = {c}
                rp.FilterType = Enum.RaycastFilterType.Exclude
                local rr = workspace:Raycast(r.Position, Vector3.new(0, -3000, 0), rp)
                if rr then
                    local hum2 = c:FindFirstChildOfClass("Humanoid")
                    local off = ((hum2 and hum2.HipHeight) or 2) + (r.Size.Y / 2)
                    r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + off, r.Position.Z)
                    r.AssemblyLinearVelocity = Vector3.zero
                    r.AssemblyAngularVelocity = Vector3.zero
                end
                if hum2 and hum2.Health > 0 then hum2:ChangeState(Enum.HumanoidStateType.Running) end
            end)
            dropActive = false
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        local lv = r.AssemblyLinearVelocity
        r.AssemblyLinearVelocity = Vector3.new(lv.X, DROP_ASCEND_SPEED, lv.Z)
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

function applyAntiLagDerender(obj)
    pcall(function()
        if obj:IsA("Accessory") or obj:IsA("Hat") then obj:Destroy()
        elseif obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
            for _, t in ipairs(obj:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end
        end
    end)
end

function enableAntiLag()
    removeAccessoriesEnabled = true
    antiLagEnabled = true
    if defLightBrightness == nil then
        defLightBrightness = Lighting.Brightness
        defLightClock = Lighting.ClockTime
        defLightAmbient = Lighting.OutdoorAmbient
        defGlobalShadows = Lighting.GlobalShadows
        defFogEnd = Lighting.FogEnd
    end
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e10
    Lighting.Brightness = 0
    for _, e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                e.Enabled = false
            end
        end)
    end
    for _, obj in ipairs(workspace:GetDescendants()) do applyAntiLagDerender(obj) end
    if antiLagDescConn then antiLagDescConn:Disconnect() end
    antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
        if removeAccessoriesEnabled then applyAntiLagDerender(obj) end
    end)
end

function disableAntiLag()
    removeAccessoriesEnabled = false
    antiLagEnabled = false
    if antiLagDescConn then antiLagDescConn:Disconnect(); antiLagDescConn = nil end
    if defLightBrightness ~= nil then Lighting.Brightness = defLightBrightness end
    if defLightClock ~= nil then Lighting.ClockTime = defLightClock end
    if defLightAmbient ~= nil then Lighting.OutdoorAmbient = defLightAmbient end
    if defGlobalShadows ~= nil then Lighting.GlobalShadows = defGlobalShadows end
    if defFogEnd ~= nil then Lighting.FogEnd = defFogEnd end
    for _, e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                e.Enabled = true
            end
        end)
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
        if c then c.CFrame = c.CFrame * CFrame.new(0,0,0,1,0,0,0,0.7,0,0,0,1) end
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

function applyShimmerToText(obj, speed)
    speed = speed or 0.8
    local grad = Instance.new("UIGradient", obj)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 0, 0)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(50, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 0, 0)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(50, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 0, 0))
    })
    grad.Rotation = 45
    grad.Offset = Vector2.new(0.2, 0)
    return grad
end

local function drag(f)
    local dn, ds, sp, di = false
    f.InputBegan:Connect(function(i)
        if uiLocked then return end
        if _isDraggingButton then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dn = true; ds = i.Position; sp = f.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dn = false end end)
        end
    end)
    f.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end
    end)
    UIS.InputChanged:Connect(function(i)
        if i == di and dn then
            if uiLocked then dn = false; return end
            if _isDraggingButton then return end
            local nX = sp.X.Offset + (i.Position.X - ds.X)
            local nY = sp.Y.Offset + (i.Position.Y - ds.Y)
            f.Position = UDim2.new(sp.X.Scale, nX, sp.Y.Scale, nY)
        end
    end)
end

function setupMovementAndIndicators(char)
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end

    steppedConn = RunService.Stepped:Connect(function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                for _, part in ipairs(p.Character:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end
    end)

    movementLoop = RunService.RenderStepped:Connect(function()
        local char2 = LP.Character
        if not char2 then return end
        local hum = char2:FindFirstChildOfClass("Humanoid")
        local hrp = char2:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end

        if not speedLV or not speedLV.Parent then
            setupSpeedLinearVelocity(char2)
        end

        if isRagdollState(hum) then
            lastMoveDir = Vector3.zero
            if speedLV then speedLV.VectorVelocity = Vector3.zero; speedLV.Enabled = false end
            return
        end

        if not autoBatEnabled and not tpLockEnabled and not autoLeftEnabled and not autoRightEnabled then
            local md = hum.MoveDirection
            local spd = getActiveMoveSpeed()

            if md.Magnitude > 0.05 then
                lastMoveDir = md
                local horizontal = Vector3.new(md.X, 0, md.Z).Unit * spd
                if speedLV then speedLV.VectorVelocity = horizontal; speedLV.Enabled = true end
            else
                local anyHeld = false
                if antiRagdollEnabled and lastMoveDir.Magnitude > 0.05 then
                    for key in pairs(MOVE_KEYS) do
                        if UIS:IsKeyDown(key) then anyHeld = true; break end
                    end
                end
                if anyHeld then
                    local horizontal = Vector3.new(lastMoveDir.X, 0, lastMoveDir.Z).Unit * spd
                    if speedLV then speedLV.VectorVelocity = horizontal; speedLV.Enabled = true end
                else
                    if speedLV then speedLV.VectorVelocity = Vector3.zero; speedLV.Enabled = false end
                end
            end
        else
            if speedLV then speedLV.VectorVelocity = Vector3.zero; speedLV.Enabled = false end
        end

        if speedLabel then
            local horizSpeed = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z).Magnitude
            speedLabel.Text = string.format("Speed: %.1f", horizSpeed)
        end
    end)

    setupSpeedIndicator(char)
    startEnemySpeed()
end

function toggleLockUI(state)
    if state == nil then uiLocked = not uiLocked else uiLocked = state end
    if uiLocked and editModeEnabled then
        editModeEnabled = false
        if setEditModeVisual then setEditModeVisual(false) end
    end
    if setLockUIVisual then setLockUIVisual(uiLocked) end
end

function toggleEditMode(state)
    if state == nil then state = not editModeEnabled end
    if state and uiLocked then state = false end
    editModeEnabled = state
    if setEditModeVisual then setEditModeVisual(editModeEnabled) end
end

function disableAllAimbots()
    if autoBatEnabled then
        disableAutoBat()
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
    end
    if tpLockEnabled then toggleTPLock() end
end

function stopAllBackgroundTasks()
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    if speedLV then pcall(function() speedLV:Destroy() end); speedLV = nil end
    if speedAttachment then pcall(function() speedAttachment:Destroy() end); speedAttachment = nil end
    stopEnemySpeed()
    if stretchEnabled then disableStretch() end
    if stretchConn then stretchConn:Disconnect(); stretchConn = nil end
    if stretchFovConn then stretchFovConn:Disconnect(); stretchFovConn = nil end
    stopAntiRagdoll()
    stopJumpMode()
    stopBatCounter()
    stopMedusaCounter()
    stopMedusaAutoReset()
    stopAutoSteal()
    stopAutoTPDown()
    disableAutoBat()
    if tpLockEnabled then stopTPLock() end
    stopAutoLeft()
    stopAutoRight()
    if unwalkEnabled then stopUnwalk() end
    if antiLagEnabled then disableAntiLag() end
    if espEnabled then toggleESP(false) end
    if dropActive then stopDropBrainrot() end
    if bodyLockEnabled then stopBodyLock() end
    _blSuppressCount = 0
    _blWasEnabled = false
    if _blRestoreTimer then
        task.cancel(_blRestoreTimer)
        _blRestoreTimer = nil
    end
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
end

-- ============================================
-- BACKGROUND SYSTEM CON FOTOS MÚLTIPLES
-- ============================================
local BackgroundDecals = {
    [1] = "rbxassetid://90453834580322",
    [2] = "rbxassetid://127008542588565",
    [3] = "rbxassetid://81233250155347",
    [4] = "rbxassetid://77446891363466",
    [5] = "rbxassetid://93417009946836",
    [6] = "rbxassetid://102729289645203",
    [7] = "rbxassetid://113953274092851",
    [8] = "rbxassetid://116355482429334",
    [9] = "rbxassetid://133090961209841",
    [10] = "rbxassetid://84995781107338",
}
currentBgIndex = currentBgIndex or 1
local bgDecalRef = nil
local bgPreviewRef = nil

local function updateBackground(index)
    currentBgIndex = index
    if bgDecalRef then
        bgDecalRef.Image = BackgroundDecals[index] or BackgroundDecals[1]
    end
    if bgPreviewRef then
        bgPreviewRef.Image = BackgroundDecals[index] or BackgroundDecals[1]
    end
end

function buildConfigTable()
    local config = {
        normalSpeed = NS,
        carrySpeed = CS,
        laggerSpeed1 = LAGGER_SPEED_1,
        laggerSpeed2 = LAGGER_SPEED_2,
        stealRadius = CONFIG.STEAL_RANGE,
        stealDuration = CONFIG.HOLD_MAX,
        autoTPDownHeight = autoTPDownHeight,
        antiRagdoll = antiRagdollEnabled,
        autoSteal = CONFIG.AUTO_STEAL_ENABLED,
        jumpEnabled = jumpEnabled,
        jumpMode = jumpMode,
        medusaCounter = medusaCounterEnabled,
        batCounter = batCounterEnabled,
        laggerToggled = laggerToggled,
        laggerLevel = laggerLevel,
        carryMode = speedMode,
        batAimbotSpeed = BAT_AIMBOT_SPEED,
        dropMode = dropMode,
        medusaAutoReset = medusaAutoResetEnabled,
        stretchEnabled = stretchEnabled,
        stretchFOV = stretchFOV,
        uiScale = uiScaleValue,
        animPack = currentAnimPack,
        espEnabled = espEnabled,
        antiLag = antiLagEnabled,
        tpLockEnabled = tpLockEnabled,
        mobileButtonPositions = savedButtonPositions,
        stealBarPos = savedStealBarPos, -- Guardar posición de la barra de steal
        dropBrainrotKey = {kb = KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name, gp = KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name},
        autoLeftKey = {kb = KB.AutoLeft.kb and KB.AutoLeft.kb.Name, gp = KB.AutoLeft.gp and KB.AutoLeft.gp.Name},
        autoRightKey = {kb = KB.AutoRight.kb and KB.AutoRight.kb.Name, gp = KB.AutoRight.gp and KB.AutoRight.gp.Name},
        autoBatKey = {kb = KB.AutoBat.kb and KB.AutoBat.kb.Name, gp = KB.AutoBat.gp and KB.AutoBat.gp.Name},
        tpFloorKey = {kb = KB.TPFloor.kb and KB.TPFloor.kb.Name, gp = KB.TPFloor.gp and KB.TPFloor.gp.Name},
        carryToggleKey = {kb = KB.CarryToggle.kb and KB.CarryToggle.kb.Name, gp = KB.CarryToggle.gp and KB.CarryToggle.gp.Name},
        laggerModeKey = {kb = KB.LaggerMode.kb and KB.LaggerMode.kb.Name, gp = KB.LaggerMode.gp and KB.LaggerMode.gp.Name},
        instaResetKey = {kb = KB.InstaReset.kb and KB.InstaReset.kb.Name, gp = KB.InstaReset.gp and KB.InstaReset.gp.Name},
        jumpModeKey = {kb = KB.JumpMode.kb and KB.JumpMode.kb.Name, gp = KB.JumpMode.gp and KB.JumpMode.gp.Name},
        tpLockKey = {kb = KB.TPLock.kb and KB.TPLock.kb.Name, gp = KB.TPLock.gp and KB.TPLock.gp.Name},
        instaResetFloatingPos = instaResetFloatingPos,
        tpBatFloatingPos = tpBatFloatingPos,
        bodyLockEnabled = bodyLockEnabled,
        bodyLockRange = bodyLockRange,
        autoResetStates = autoResetStates,
        progressBarPos = savedProgressBarPos,
        lockUI = uiLocked,
        editMode = editModeEnabled,
        backgroundIndex = currentBgIndex,
        skyTheme = currentSkyTheme,
    }
    if pbFrame then
        config.progressBarPos = {
            XScale = pbFrame.Position.X.Scale,
            XOffset = pbFrame.Position.X.Offset,
            YScale = pbFrame.Position.Y.Scale,
            YOffset = pbFrame.Position.Y.Offset
        }
    end
    if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        config.mobilePanelPos = {
            XScale = container.Position.X.Scale,
            XOffset = container.Position.X.Offset,
            YScale = container.Position.Y.Scale,
            YOffset = container.Position.Y.Offset
        }
    end
    return config
end

function saveAllSettings()
    if _isResetting then return true end
    local config = buildConfigTable()
    local json = HS:JSONEncode(config)
    if json == _lastSavedJSON then return true end
    local success, err = pcall(function() writefile(CONFIG_FILE, json) end)
    if success then _lastSavedJSON = json end
    return success
end

function loadAllSettings()
    if not isfile or not isfile(CONFIG_FILE) then return false end
    local success, data = pcall(function() return HS:JSONDecode(readfile(CONFIG_FILE)) end)
    if not success or not data then return false end

    _isLoading = true

    NS = data.normalSpeed or NS
    CS = data.carrySpeed or CS
    LAGGER_SPEED_1 = data.laggerSpeed1 or LAGGER_SPEED_1
    LAGGER_SPEED_2 = data.laggerSpeed2 or LAGGER_SPEED_2
    CONFIG.STEAL_RANGE = data.stealRadius or CONFIG.STEAL_RANGE
    CONFIG.HOLD_MAX = data.stealDuration or CONFIG.HOLD_MAX
    autoTPDownHeight = data.autoTPDownHeight or data.autoTPHeight or 20
    autoTPDownEnabled = data.autoTPDownEnabled or false
    uiLocked = data.lockUI or false
    editModeEnabled = data.editMode or false
    antiRagdollEnabled = data.antiRagdoll or false
    CONFIG.AUTO_STEAL_ENABLED = data.autoSteal or false
    jumpEnabled = data.jumpEnabled or false
    jumpMode = data.jumpMode or 1
    medusaCounterEnabled = data.medusaCounter or false
    batCounterEnabled = data.batCounter or false
    unwalkEnabled = data.unwalk or false
    antiLagEnabled = data.antiLag or false
    laggerToggled = data.laggerToggled or false
    speedMode = data.carryMode or false
    laggerLevel = data.laggerLevel or 1
    medusaAutoResetEnabled = data.medusaAutoReset or false
    if medusaAutoResetEnabled and medusaCounterEnabled then medusaCounterEnabled = false end
    uiScaleValue = data.uiScale or 100
    if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
    if pbScale then pbScale.Scale = uiScaleValue / 100 end
    espEnabled = data.espEnabled or false
    if espEnabled then toggleESP(true) else toggleESP(false) end

    tpLockEnabled = data.tpLockEnabled or false
    if tpLockEnabled then
        task.defer(function()
            toggleTPLock()
            if tpLockSetVisual then tpLockSetVisual(true) end
        end)
    else
        if tpLockSetVisual then tpLockSetVisual(false) end
    end

    if data.animPack and ANIM_PACKS[data.animPack] then
        startAnimPack(data.animPack)
    else
        currentAnimPack = "Off"
        stopAnimPack()
    end

    if data.skyTheme and DRIFT_SKY_PRESETS[data.skyTheme] then
        currentSkyTheme = data.skyTheme
        applyDriftSkyTheme(currentSkyTheme)
        if skySelectorLabel then skySelectorLabel.Text = currentSkyTheme end
    end

    local function lk(e, d)
        if not d then return end
        if d.kb and Enum.KeyCode[d.kb] then e.kb = Enum.KeyCode[d.kb] end
        if d.gp and Enum.KeyCode[d.gp] then e.gp = Enum.KeyCode[d.gp] end
    end
    lk(KB.DropBrainrot, data.dropBrainrotKey)
    lk(KB.AutoLeft, data.autoLeftKey)
    lk(KB.AutoRight, data.autoRightKey)
    lk(KB.AutoBat, data.autoBatKey)
    lk(KB.TPFloor, data.tpFloorKey)
    lk(KB.CarryToggle, data.carryToggleKey)
    lk(KB.LaggerMode, data.laggerModeKey)
    lk(KB.InstaReset, data.instaResetKey)
    lk(KB.JumpMode, data.jumpModeKey)
    lk(KB.TPLock, data.tpLockKey)

    if data.mobileButtonPositions then savedButtonPositions = data.mobileButtonPositions end
    if data.mobilePanelPos then savedMobilePanelPos = data.mobilePanelPos end
    if data.stealBarPos then savedStealBarPos = data.stealBarPos end -- Cargar posición de la barra de steal
    if data.instaResetFloatingPos then instaResetFloatingPos = data.instaResetFloatingPos end
    if data.tpBatFloatingPos then tpBatFloatingPos = data.tpBatFloatingPos end
    if data.progressBarPos then savedProgressBarPos = data.progressBarPos end
    if data.bodyLockEnabled ~= nil then
        bodyLockEnabled = data.bodyLockEnabled
        if bodyLockEnabled then
            task.defer(function()
                if bodyLockSetVisual then bodyLockSetVisual(true) end
                startBodyLock()
            end)
        end
    end
    if data.bodyLockRange then
        bodyLockRange = data.bodyLockRange
        if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    end
    if data.autoResetStates then
        for k, v in pairs(data.autoResetStates) do
            if autoResetStates[k] ~= nil then autoResetStates[k] = v end
        end
    end

    dropMode = data.dropMode or 1
    stretchEnabled = data.stretchEnabled or false
    stretchFOV = data.stretchFOV or 120
    BAT_AIMBOT_SPEED = data.batAimbotSpeed or BAT_AIMBOT_SPEED

    if data.backgroundIndex and BackgroundDecals[data.backgroundIndex] then
        currentBgIndex = data.backgroundIndex
        if bgDecalRef then
            bgDecalRef.Image = BackgroundDecals[currentBgIndex] or BackgroundDecals[1]
        end
        if bgPreviewRef then
            bgPreviewRef.Image = BackgroundDecals[currentBgIndex] or BackgroundDecals[1]
        end
    else
        currentBgIndex = 1
        if bgDecalRef then
            bgDecalRef.Image = BackgroundDecals[1]
        end
        if bgPreviewRef then
            bgPreviewRef.Image = BackgroundDecals[1]
        end
    end

    autoBatEnabled = false
    autoLeftEnabled = false
    autoRightEnabled = false

    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    refreshSpeedModeLabel()

    _lastSavedJSON = HS:JSONEncode(buildConfigTable())
    _isLoading = false
    return true
end

function forceResetUI()
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED_1) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_SPEED_2) end
    if autoTPHeightBox then autoTPHeightBox.Text = tostring(autoTPDownHeight) end
    if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
    if modeSelectBtn then modeSelectBtn.Text = jumpMode == 1 and "Tap Tap" or "Hold" end
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end

    local function safeSet(fn, val) if fn then fn(val) end end
    safeSet(autoBatSetVisual, false)
    safeSet(autoLeftSetVisual, false)
    safeSet(autoRightSetVisual, false)
    safeSet(setBatCounterVisual, false)
    safeSet(setMedusaVisual, false)
    safeSet(setMedusaAutoResetVisual, false)
    safeSet(setAntiRagVisual, false)
    safeSet(setJumpVisual, false)
    safeSet(setUnwalkVisual, false)
    safeSet(setAntiLagVisual, false)
    safeSet(setAutoTPDownVisual, false)
    safeSet(setLockUIVisual, false)
    safeSet(setEditModeVisual, false)
    safeSet(setInstaGrab, false)
    safeSet(tpLockSetVisual, false)
    safeSet(setESPVIsual, false)
    safeSet(bodyLockSetVisual, false)
    if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end

    safeSet(mobSetAutoBat, false)
    safeSet(mobSetAutoLeft, false)
    safeSet(mobSetAutoRight, false)
    safeSet(mobSetDropBR, false)
    safeSet(mobSetTpDown, false)
    safeSet(mobSetCarry, false)
    safeSet(mobSetLagger1, false)
    safeSet(mobSetLagger2, false)

    if setJumpToggleState then setJumpToggleState(false) end
    refreshSpeedModeLabel()
    updateProgressBarVisibility()
    disableAntiLag()

    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end

    currentBgIndex = 1
    if bgDecalRef then
        bgDecalRef.Image = BackgroundDecals[1]
    end
    if bgPreviewRef then
        bgPreviewRef.Image = BackgroundDecals[1]
    end

    currentSkyTheme = "None"
    applyDriftSkyTheme("None")
    if skySelectorLabel then skySelectorLabel.Text = "None" end

    saveAllSettings()
end

function resetFloatingPositions()
    if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        container.Position = UDim2.new(1, -MOBILE_PANEL_WIDTH - 10, 0, 0)
        savedButtonPositions = {}
        if container:FindFirstChild("ButtonsContainer") then
            for _, btn in ipairs(container.ButtonsContainer:GetChildren()) do
                if btn:IsA("TextButton") and btn.Name then
                    local defX, defY = getDefaultButtonPosition(btn.Name)
                    btn.Position = UDim2.new(0, defX, 0, defY)
                end
            end
        end
    end
    if instaResetFloatingButton and instaResetFloatingButton:FindFirstChild("Frame") then
        local btnFrame = instaResetFloatingButton:FindFirstChild("Frame")
        btnFrame.Position = UDim2.new(1, -MOBILE_PANEL_WIDTH - 10, 0, MOBILE_PANEL_HEIGHT + 10)
        instaResetFloatingPos = nil
    end
    if tpBatFloatingButton and tpBatFloatingButton:FindFirstChild("Frame") then
        local btnFrame = tpBatFloatingButton:FindFirstChild("Frame")
        btnFrame.Position = UDim2.new(1, -10 - 60, 0, MOBILE_PANEL_HEIGHT + 10)
        tpBatFloatingPos = nil
    end
    if pbFrame then
        pbFrame.Position = UDim2.new(0.5, -140, 1, -50)
        savedProgressBarPos = nil
    end
    savedMobilePanelPos = nil
    savedStealBarPos = nil -- Resetear posición de la barra de steal
    instaResetFloatingPos = nil
    tpBatFloatingPos = nil
end

function resetToFactoryDefaults()
    _isResetting = true

    stopAllBackgroundTasks()
    stopAutoSteal()
    stopAutoTPDown()
    stopBatCounter()
    stopMedusaCounter()
    stopMedusaAutoReset()
    stopAntiRagdoll()
    stopJumpMode()
    stopUnwalk()
    disableAutoBat()
    if tpLockEnabled then toggleTPLock() end
    stopBodyLock()
    if espEnabled then toggleESP(false) end
    if stretchEnabled then disableStretch() end
    if antiLagEnabled then disableAntiLag() end
    if dropActive then stopDropBrainrot() end

    NS = 60
    CS = 29
    LAGGER_SPEED_1 = 20
    LAGGER_SPEED_2 = 10
    CONFIG.STEAL_RANGE = 9
    CONFIG.HOLD_MAX = 2.6
    autoTPDownHeight = 20
    speedMode = false
    laggerToggled = false
    laggerLevel = 1
    antiRagdollEnabled = false
    jumpEnabled = false
    jumpMode = 1
    medusaCounterEnabled = false
    batCounterEnabled = false
    autoBatEnabled = false
    autoLeftEnabled = false
    autoRightEnabled = false
    unwalkEnabled = false
    antiLagEnabled = false
    autoTPDownEnabled = false
    uiLocked = false
    editModeEnabled = false
    CONFIG.AUTO_STEAL_ENABLED = false
    BAT_AIMBOT_SPEED = 58
    tpLockEnabled = false
    dropMode = 1
    medusaAutoResetEnabled = false
    stretchEnabled = false
    stretchFOV = 120
    uiScaleValue = 100
    if mainUIScale then mainUIScale.Scale = 1 end
    if pbScale then pbScale.Scale = 1 end
    espEnabled = false
    bodyLockEnabled = false
    bodyLockRange = 20
    for k in pairs(autoResetStates) do autoResetStates[k] = false end

    currentAnimPack = "Off"
    stopAnimPack()
    currentSkyTheme = "None"
    applyDriftSkyTheme("None")
    if skySelectorLabel then skySelectorLabel.Text = "None" end

    savedStealRadius = CONFIG.STEAL_RANGE
    savedStealDuration = CONFIG.HOLD_MAX

    for key, val in pairs(DEFAULT_KB) do
        if KB[key] then
            KB[key].kb = val.kb
            KB[key].gp = val.gp
        end
    end

    if isfile and isfile(CONFIG_FILE) then
        pcall(delfile, CONFIG_FILE)
    end

    resetFloatingPositions()

    forceResetUI()
    updateProgressBarVisibility()
    refreshSpeedModeLabel()

    _lastSavedJSON = nil
    saveAllSettings()

    _isResetting = false
end

function updateProgressBarVisibility()
    if pbFrame then pbFrame.Visible = true end
end

function getDefaultButtonPosition(btnName)
    local BTN_W, BTN_H = 60, 60
    local GAP = 8
    local orderMap = {
        DropBR = 0, AutoLeft = 1, AutoBat = 2, AutoRight = 3,
        TpDown = 4, Carry = 5, Lagger1 = 6, Lagger2 = 7
    }
    local order = orderMap[btnName] or 0
    local row = math.floor(order / 2)
    local col = order % 2
    return col * (BTN_W + GAP), row * (BTN_H + GAP + 10)
end

-- ============================================================
-- EFECTO AGUA CRISTALINA PARA TABS
-- ============================================================
local function createWaterEffect()
    local waterMaterial = Instance.new("ParticleEmitter")
    waterMaterial.Name = "WaterGlow"
    waterMaterial.Texture = "rbxassetid://110188989075216"
    waterMaterial.Rate = 100
    waterMaterial.Lifetime = NumberRange.new(0.5, 1.5)
    waterMaterial.VelocityInheritance = 0
    waterMaterial.SpreadAngle = Vector2.new(360, 360)
    waterMaterial.Rotation = NumberRange.new(0, 360)
    waterMaterial.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(0.5, 0.3),
        NumberSequenceKeypoint.new(1, 0.9)
    })
    waterMaterial.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 2),
        NumberSequenceKeypoint.new(1, 8)
    })
    waterMaterial.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 0, 0))
    })
    waterMaterial.LightEmission = 0.8
    waterMaterial.LockedToPart = true
    waterMaterial.ZOffset = -2
    return waterMaterial
end

local function applyWaterEffectToTab(tabPage, pageName)
    if not tabPage then return end
    
    local waterBg = Instance.new("Frame", tabPage)
    waterBg.Size = UDim2.new(1, 0, 1, 0)
    waterBg.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    waterBg.BackgroundTransparency = 0.15
    waterBg.BorderSizePixel = 0
    waterBg.ZIndex = 1
    waterBg.Name = "WaterBackground"
    
    local waterGrad = Instance.new("UIGradient", waterBg)
    waterGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 0, 0)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(50, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 0, 0)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(50, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 0, 0))
    })
    waterGrad.Rotation = 45
    waterGrad.Offset = Vector2.new(0.2, 0)
    waterGrad.Name = "WaterGradient"
    
    local sparkles = Instance.new("ParticleEmitter", waterBg)
    sparkles.Texture = "rbxassetid://110188989075216"
    sparkles.Rate = 50
    sparkles.Lifetime = NumberRange.new(0.5, 1.5)
    sparkles.VelocityInheritance = 0
    sparkles.SpreadAngle = Vector2.new(360, 360)
    sparkles.Rotation = NumberRange.new(0, 360)
    sparkles.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })
    sparkles.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 3)
    })
    sparkles.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 0, 0))
    })
    sparkles.LightEmission = 1
    sparkles.Enabled = true
    sparkles.Name = "WaterSparkles"
    
    local borderGlow = Instance.new("UIStroke", tabPage)
    borderGlow.Color = Color3.fromRGB(50, 0, 0)
    borderGlow.Thickness = 3
    borderGlow.Transparency = 0.3
    borderGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    borderGlow.Name = "WaterBorder"
    
    local waveEffect = Instance.new("ParticleEmitter", waterBg)
    waveEffect.Texture = "rbxassetid://110188989075216"
    waveEffect.Rate = 30
    waveEffect.Lifetime = NumberRange.new(1, 2)
    waveEffect.VelocityInheritance = 0
    waveEffect.SpreadAngle = Vector2.new(360, 360)
    waveEffect.Rotation = NumberRange.new(0, 360)
    waveEffect.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(0.3, 0.5),
        NumberSequenceKeypoint.new(0.7, 0.5),
        NumberSequenceKeypoint.new(1, 0.9)
    })
    waveEffect.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 5),
        NumberSequenceKeypoint.new(0.5, 10),
        NumberSequenceKeypoint.new(1, 5)
    })
    waveEffect.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 0, 0))
    })
    waveEffect.LightEmission = 0.5
    waveEffect.Enabled = true
    waveEffect.Name = "WaterWaves"
    
    local function animateWater()
        local offset = 0
        local direction = 1
        while waterBg and waterBg.Parent do
            offset = offset + 0.002 * direction
            if offset > 0.3 or offset < -0.3 then
                direction = -direction
            end
            if waterGrad then
                waterGrad.Offset = Vector2.new(offset, 0)
                waterGrad.Rotation = 45 + math.sin(offset * 10) * 5
            end
            task.wait(0.05)
        end
    end
    task.spawn(animateWater)
    
    return waterBg
end

local function enhanceTabsWithWaterEffect()
    local tabs = {"Moment", "Combat", "Main", "Keybinds"}
    
    for i, name in ipairs(tabs) do
        local page = contentPages[name]
        if page then
            applyWaterEffectToTab(page, name)
            
            local btn = tabButtons[i]
            if btn then
                local btnWater = Instance.new("UIStroke", btn)
                btnWater.Color = Color3.fromRGB(50, 0, 0)
                btnWater.Thickness = 2
                btnWater.Transparency = 0.8
                btnWater.Name = "WaterButtonStroke"
                
                local btnSparkles = Instance.new("ParticleEmitter", btn)
                btnSparkles.Texture = "rbxassetid://110188989075216"
                btnSparkles.Rate = 20
                btnSparkles.Lifetime = NumberRange.new(0.3, 1)
                btnSparkles.VelocityInheritance = 0
                btnSparkles.SpreadAngle = Vector2.new(360, 360)
                btnSparkles.Rotation = NumberRange.new(0, 360)
                btnSparkles.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.5, 0.1),
                    NumberSequenceKeypoint.new(1, 1)
                })
                btnSparkles.Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 4)
                })
                btnSparkles.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 0, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 0, 0)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 0, 0))
                })
                btnSparkles.LightEmission = 0.8
                btnSparkles.Enabled = false
                btnSparkles.Name = "WaterButtonSparkles"
                
                btn._waterSparkles = btnSparkles
                btn._waterStroke = btnWater
                
                btn.MouseButton1Click:Connect(function()
                    for _, pg in pairs(contentPages) do
                        local waterEff = pg:FindFirstChild("WaterBackground")
                        if waterEff then
                            local sparkles = waterEff:FindFirstChild("WaterSparkles")
                            if sparkles and sparkles:IsA("ParticleEmitter") then
                                sparkles.Enabled = false
                            end
                            local waves = waterEff:FindFirstChild("WaterWaves")
                            if waves and waves:IsA("ParticleEmitter") then
                                waves.Enabled = false
                            end
                        end
                    end
                    
                    for _, b in ipairs(tabButtons) do
                        if b._waterSparkles then
                            b._waterSparkles.Enabled = false
                        end
                        if b._waterStroke then
                            b._waterStroke.Transparency = 0.8
                        end
                    end
                    
                    if btn._waterSparkles then
                        btn._waterSparkles.Enabled = true
                        task.delay(0.5, function()
                            if btn._waterSparkles then
                                btn._waterSparkles.Enabled = false
                            end
                        end)
                    end
                    if btn._waterStroke then
                        btn._waterStroke.Transparency = 0.2
                        task.delay(0.5, function()
                            if btn._waterStroke then
                                btn._waterStroke.Transparency = 0.8
                            end
                        end)
                    end
                    
                    local page = contentPages[name]
                    if page then
                        local waterBg = page:FindFirstChild("WaterBackground")
                        if waterBg then
                            local sparkles = waterBg:FindFirstChild("WaterSparkles")
                            if sparkles and sparkles:IsA("ParticleEmitter") then
                                sparkles.Enabled = true
                            end
                            local waves = waterBg:FindFirstChild("WaterWaves")
                            if waves and waves:IsA("ParticleEmitter") then
                                waves.Enabled = true
                            end
                        end
                    end
                end)
            end
        end
    end
end

-- ============================================================
-- FUNCIÓN BUILD GUI
-- ============================================================
function buildGui()
    local BG = Color3.fromRGB(25, 25, 25)
    local BG2 = Color3.fromRGB(35, 35, 35)
    local ROW_BG = Color3.fromRGB(30, 30, 30)
    local ROW_BORDER = Color3.fromRGB(50, 50, 50)
    local WHITE = Color3.fromRGB(255, 255, 255)
    local GRAY = Color3.fromRGB(180, 180, 180)
    local INP = Color3.fromRGB(45, 45, 45)
    local RED2 = Color3.fromRGB(220, 60, 60)
    local RED3 = Color3.fromRGB(180, 40, 40)
    local OFF = Color3.fromRGB(60, 60, 60)
    local TAB_ACTIVE = Color3.fromRGB(255, 255, 255)
    local TAB_INACT = Color3.fromRGB(150, 150, 150)
    local SECT_LBL = Color3.fromRGB(200, 200, 200)
    local ON_COLOR = Color3.fromRGB(200, 50, 50)

    local GUI_W, GUI_H = 330, 480

    local old = game:GetService("CoreGui"):FindFirstChild("Trace")
    if old then old:Destroy() end
    local pg = LP:FindFirstChild("PlayerGui")
    if pg then local o = pg:FindFirstChild("Trace"); if o then o:Destroy() end end

    gui = Instance.new("ScreenGui")
    gui.Name = "Trace"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 10
    gui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then
        gui.Parent = LP:WaitForChild("PlayerGui")
    end

    main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, GUI_W, 0, GUI_H)
    main.Position = UDim2.new(0, 20, 0, 2)
    main.BackgroundColor3 = BG
    main.BackgroundTransparency = 1
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)

    mainUIScale = Instance.new("UIScale", main)
    mainUIScale.Scale = uiScaleValue / 100

    bgDecalRef = Instance.new("ImageLabel", main)
    bgDecalRef.Size = UDim2.new(1, 0, 1, 0)
    bgDecalRef.Position = UDim2.new(0, 0, 0, 0)
    bgDecalRef.BackgroundTransparency = 1
    bgDecalRef.Image = BackgroundDecals[currentBgIndex] or BackgroundDecals[1]
    bgDecalRef.ZIndex = 0
    bgDecalRef.ScaleType = Enum.ScaleType.Crop
    local decalCorner = Instance.new("UICorner", bgDecalRef)
    decalCorner.CornerRadius = UDim.new(0, 18)

    local titleContainer = Instance.new("Frame", main)
    titleContainer.Size = UDim2.new(1, -80, 0, 40)
    titleContainer.Position = UDim2.new(0, 12, 0, 4)
    titleContainer.BackgroundTransparency = 1
    titleContainer.ZIndex = 20
    titleContainer.ClipsDescendants = false

    local TraceLabel = Instance.new("TextLabel", titleContainer)
    TraceLabel.Size = UDim2.new(0, 70, 1, 0)
    TraceLabel.Position = UDim2.new(0, 0, 0, 0)
    TraceLabel.BackgroundTransparency = 1
    TraceLabel.Text = "Trace"
    TraceLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
    TraceLabel.Font = Enum.Font.GothamBlack
    TraceLabel.TextSize = 28
    TraceLabel.TextXAlignment = Enum.TextXAlignment.Left
    TraceLabel.TextStrokeColor3 = Color3.fromRGB(255, 150, 150)
    TraceLabel.TextStrokeTransparency = 0.2
    TraceLabel.ZIndex = 21

    local hubLabel = Instance.new("TextLabel", titleContainer)
    hubLabel.Size = UDim2.new(0, 105, 1, 0)
    hubLabel.Position = UDim2.new(0, 86, 0, 0)
    hubLabel.BackgroundTransparency = 1
    hubLabel.Text = ""
    hubLabel.TextColor3 = WHITE
    hubLabel.Font = Enum.Font.GothamBlack
    hubLabel.TextSize = 28
    hubLabel.TextXAlignment = Enum.TextXAlignment.Left
    hubLabel.TextStrokeColor3 = Color3.fromRGB(255, 150, 150)
    hubLabel.TextStrokeTransparency = 0.2
    hubLabel.ZIndex = 21

    local closeBtn = Instance.new("TextButton", main)
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -42, 0, 8)
    closeBtn.BackgroundColor3 = RED3
    closeBtn.BackgroundTransparency = 0.6
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "−"
    closeBtn.TextColor3 = WHITE
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 26
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 200
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

    closeBtn.MouseEnter:Connect(function()
        TS:Create(closeBtn, TweenInfo.new(0.12), {TextColor3 = WHITE, BackgroundColor3 = RED2}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TS:Create(closeBtn, TweenInfo.new(0.12), {TextColor3 = WHITE, BackgroundColor3 = RED3}):Play()
    end)

    miniBtn = Instance.new("TextButton", gui)
    miniBtn.Size = UDim2.new(0, 70, 0, 30)
    miniBtn.Position = UDim2.new(0, 16, 0, 58)
    miniBtn.BackgroundColor3 = RED2
    miniBtn.BackgroundTransparency = 0
    miniBtn.BorderSizePixel = 0
    miniBtn.Text = "TRACES"
    miniBtn.TextColor3 = WHITE
    miniBtn.Font = Enum.Font.GothamBold
    miniBtn.TextSize = 12
    miniBtn.ZIndex = 20
    miniBtn.Visible = false
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 8)

    showGui = function()
        if main then main.Visible = true end
        if miniBtn then miniBtn.Visible = false end
    end
    hideGui = function()
        if main then main.Visible = false end
        if miniBtn then miniBtn.Visible = true end
    end

    closeBtn.MouseButton1Click:Connect(hideGui)
    miniBtn.MouseButton1Click:Connect(showGui)

    local tabBar = Instance.new("Frame", main)
    tabBar.Size = UDim2.new(1, -24, 0, 32)
    tabBar.Position = UDim2.new(0, 12, 0, 50)
    tabBar.BackgroundTransparency = 1
    tabBar.ZIndex = 10

    local tabs = {"Moment", "Combat", "Main", "Keybinds"}
    local tabButtons = {}
    local tabContent = Instance.new("Frame", main)
    tabContent.Size = UDim2.new(1, -14, 1, -96)
    tabContent.Position = UDim2.new(0, 7, 0, 86)
    tabContent.BackgroundTransparency = 1
    tabContent.ClipsDescendants = true
    tabContent.ZIndex = 5

    local contentPages = {}

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton", tabBar)
        btn.Size = UDim2.new(1 / #tabs, -4, 1, 0)
        btn.Position = UDim2.new((i-1)/#tabs, 2, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
        btn.BackgroundTransparency = 0.5
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = TAB_INACT
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.AutoButtonColor = false
        btn.ZIndex = 11
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = ROW_BORDER
        stroke.Thickness = 1

        local page = Instance.new("ScrollingFrame", tabContent)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.Position = UDim2.new(0, 0, 0, 0)
        page.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
        page.BackgroundTransparency = 0.6
        page.BorderSizePixel = 0
        page.ClipsDescendants = true
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = RED3
        page.ScrollBarImageTransparency = 0.3
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.None
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.ZIndex = 6
        Instance.new("UICorner", page).CornerRadius = UDim.new(0, 16)
        page.Visible = (i == 1)

        local layout = Instance.new("UIListLayout", page)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 6)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local padding = Instance.new("UIPadding", page)
        padding.PaddingLeft = UDim.new(0, 8)
        padding.PaddingRight = UDim.new(0, 8)
        padding.PaddingTop = UDim.new(0, 6)
        padding.PaddingBottom = UDim.new(0, 16)

        local function updateCanvas()
            local contentSize = layout.AbsoluteContentSize
            local padBottom = padding.PaddingBottom.Offset
            local padTop = padding.PaddingTop.Offset
            local extra = 20
            page.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + padTop + padBottom + extra)
        end

        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
        task.spawn(updateCanvas)

        contentPages[name] = page

        btn.MouseButton1Click:Connect(function()
            for _, pg in pairs(contentPages) do pg.Visible = false end
            page.Visible = true
            for _, b in ipairs(tabButtons) do
                b.TextColor3 = TAB_INACT
                b.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
            end
            btn.TextColor3 = TAB_ACTIVE
            btn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
            task.wait(0.05)
            updateCanvas()
        end)

        table.insert(tabButtons, btn)
    end

    if tabButtons[1] then
        tabButtons[1].TextColor3 = TAB_ACTIVE
        tabButtons[1].BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    end

    local pageCounters = {}

    local function getNextOrder(page)
        if not pageCounters[page] then pageCounters[page] = 0 end
        pageCounters[page] = pageCounters[page] + 1
        return pageCounters[page]
    end

    local function mkSect(page, txt)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, 0, 0, 26)
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(1, -16, 1, 0)
        l.Position = UDim2.new(0, 8, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt:upper()
        l.TextColor3 = SECT_LBL
        l.Font = Enum.Font.GothamBlack
        l.TextSize = 13
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextStrokeColor3 = Color3.fromRGB(255, 150, 150)
        l.TextStrokeTransparency = 0.3
        l.ZIndex = 8
        local line = Instance.new("Frame", f)
        line.Size = UDim2.new(1, -24, 0, 1.5)
        line.Position = UDim2.new(0, 12, 1, -4)
        line.BackgroundColor3 = WHITE
        line.BackgroundTransparency = 0.6
        line.BorderSizePixel = 0
        line.ZIndex = 8
        return f
    end

    local function mkRow(page, h)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, -4, 0, h or 38)
        f.BackgroundColor3 = ROW_BG
        f.BackgroundTransparency = 0.7
        f.BorderSizePixel = 0
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        local rowStroke = Instance.new("UIStroke", f)
        rowStroke.Color = ROW_BORDER
        rowStroke.Thickness = 1
        rowStroke.Transparency = 0.5
        f.MouseEnter:Connect(function()
            TS:Create(f, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 0, 0)}):Play()
        end)
        f.MouseLeave:Connect(function()
            TS:Create(f, TweenInfo.new(0.1), {BackgroundColor3 = ROW_BG}):Play()
        end)
        return f
    end

    local function mkLabel(row, txt)
        local l = Instance.new("TextLabel", row)
        l.Size = UDim2.new(0.55, 0, 1, 0)
        l.Position = UDim2.new(0, 10, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = WHITE
        l.Font = Enum.Font.GothamBold
        l.TextSize = 11
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextTruncate = Enum.TextTruncate.AtEnd
        l.TextStrokeColor3 = Color3.fromRGB(255, 150, 150)
        l.TextStrokeTransparency = 0.5
        l.ZIndex = 8
        return l
    end

    local function mkPill(row, offset)
        local pill = Instance.new("Frame", row)
        pill.Size = UDim2.new(0, 44, 0, 22)
        pill.Position = UDim2.new(1, -(offset or 52), 0.5, -11)
        pill.BackgroundColor3 = OFF
        pill.BorderSizePixel = 0
        pill.ZIndex = 8
        Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
        local stroke = Instance.new("UIStroke", pill)
        stroke.Color = ROW_BORDER
        stroke.Thickness = 1.2
        stroke.Transparency = 0.6
        local dot = Instance.new("Frame", pill)
        dot.Size = UDim2.new(0, 16, 0, 16)
        dot.Position = UDim2.new(0, 3, 0.5, -8)
        dot.BackgroundColor3 = GRAY
        dot.BorderSizePixel = 0
        dot.ZIndex = 9
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        return pill, dot
    end

    local function animPill(pill, dot, on)
        TS:Create(pill, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = on and ON_COLOR or OFF}):Play()
        TS:Create(dot, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            Position = on and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
            BackgroundColor3 = on and WHITE or GRAY
        }):Play()
        local stroke = pill:FindFirstChildOfClass("UIStroke")
        if stroke then
            TS:Create(stroke, TweenInfo.new(0.2), {Color = on and WHITE or ROW_BORDER, Transparency = on and 0 or 0.6}):Play()
        end
    end

    local function mkToggle(page, txt, cb)
        local row = mkRow(page, 38)
        mkLabel(row, txt)
        local pill, dot = mkPill(row, 52)
        local on = false
        local function sv(s) on = s; animPill(pill, dot, s) end
        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 10
        clk.MouseButton1Click:Connect(function()
            if editModeEnabled and not uiLocked then
                pcall(cb, not on)
            else
                on = not on
                sv(on)
                pcall(cb, on)
            end
        end)
        return sv
    end

    local function mkSelector(parent, default, options, cb)
        local container = Instance.new("Frame", parent)
        container.Size = UDim2.new(0, 160, 1, 0)
        container.Position = UDim2.new(1, -168, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8

        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        local leftStroke = Instance.new("UIStroke", leftBtn)
        leftStroke.Color = ROW_BORDER
        leftStroke.Thickness = 1

        local label = Instance.new("TextLabel", container)
        label.Size = UDim2.new(0, 80, 0, 26)
        label.Position = UDim2.new(0.5, -40, 0.5, -13)
        label.BackgroundTransparency = 1
        label.Text = default
        label.TextColor3 = WHITE
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.ZIndex = 9

        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local rightStroke = Instance.new("UIStroke", rightBtn)
        rightStroke.Color = ROW_BORDER
        rightStroke.Thickness = 1

        local function updateLabel(newText)
            label.Text = newText
        end

        leftBtn.MouseButton1Click:Connect(function()
            if cb then cb(-1, updateLabel) end
        end)
        rightBtn.MouseButton1Click:Connect(function()
            if cb then cb(1, updateLabel) end
        end)

        return label
    end

    local function mkBox(parent, default, w, xOff, cb)
        local tb = Instance.new("TextBox", parent)
        local bw = w or 50
        local xo = math.max(xOff or 56, bw + 12)
        tb.Size = UDim2.new(0, bw, 0, 24)
        tb.Position = UDim2.new(1, -xo, 0.5, -12)
        tb.BackgroundColor3 = INP
        tb.BackgroundTransparency = 0.7
        tb.BorderSizePixel = 0
        tb.Text = tostring(default)
        tb.TextColor3 = WHITE
        tb.Font = Enum.Font.GothamBold
        tb.TextSize = 11
        tb.ClearTextOnFocus = false
        tb.ZIndex = 8
        Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 6)
        local bs = Instance.new("UIStroke", tb)
        bs.Color = ROW_BORDER
        bs.Thickness = 1.2
        bs.Transparency = 0.25
        tb.Focused:Connect(function() TS:Create(bs, TweenInfo.new(0.12), {Color = WHITE, Transparency = 0}):Play() end)
        tb.FocusLost:Connect(function()
            TS:Create(bs, TweenInfo.new(0.12), {Color = ROW_BORDER, Transparency = 0.25}):Play()
            if cb then local n = tonumber(tb.Text); if n then cb(n) else tb.Text = tostring(default) end end
        end)
        return tb
    end

    local function mkKeyButton(parent, kbEntry)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, 80, 0, 24)
        btn.Position = UDim2.new(1, -88, 0.5, -12)
        btn.BackgroundColor3 = INP
        btn.BackgroundTransparency = 0.5
        btn.BorderSizePixel = 0
        local function getLabel() return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None" end
        btn.Text = getLabel()
        btn.TextColor3 = WHITE
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 9
        btn.ZIndex = 8
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local bs = Instance.new("UIStroke", btn)
        bs.Color = ROW_BORDER
        bs.Thickness = 1
        local li = false; local lc; local pv = btn.Text; local listenStart = 0
        btn.Activated:Connect(function()
            if li then li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; btn.TextColor3 = WHITE; return end
            pv = btn.Text; li = true; _anyKeyListening = true; listenStart = tick(); btn.Text = "..."; btn.TextColor3 = WHITE
            lc = UIS.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode == Enum.KeyCode.Escape then li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; btn.TextColor3 = WHITE; return end
                local isGp = isGamepadInput(inp)
                if isGp and tick()-listenStart < 0.15 then return end
                if not isBindableInput(inp) then return end
                btn.Text = inp.KeyCode.Name; pv = inp.KeyCode.Name; btn.TextColor3 = WHITE
                li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end
                if isGp then kbEntry.gp = inp.KeyCode; kbEntry.kb = nil else kbEntry.kb = inp.KeyCode; kbEntry.gp = nil end
            end)
        end)
        table.insert(keyButtonRefs, {btn = btn, entry = kbEntry})
        return btn
    end

    local function addKeybindRow(page, labelText, kbEntry)
        local row = mkRow(page, 36)
        mkLabel(row, labelText)
        mkKeyButton(row, kbEntry)
    end

    -- ========== MOMENT TAB ==========
    local momentPage = contentPages["Moment"]

    mkSect(momentPage, "Speed")
    do local row = mkRow(momentPage, 38); mkLabel(row, "Normal Speed"); normalBox = mkBox(row, NS, 50, 56, function(v) if v > 0 and v <= 500 then NS = v end end) end
    do local row = mkRow(momentPage, 38); mkLabel(row, "Carry Speed"); carryBox = mkBox(row, CS, 50, 56, function(v) if v > 0 and v <= 500 then CS = v end end) end
    do local row = mkRow(momentPage, 38); mkLabel(row, "Lagger Speed"); laggerBox = mkBox(row, LAGGER_SPEED_1, 50, 56, function(v) if v > 0 and v <= 500 then LAGGER_SPEED_1 = v end end) end
    do local row = mkRow(momentPage, 38); mkLabel(row, "Lagger Carry"); lagger2Box = mkBox(row, LAGGER_SPEED_2, 50, 56, function(v) if v > 0 and v <= 500 then LAGGER_SPEED_2 = v end end) end
    do
        local row = mkRow(momentPage, 38)
        mkLabel(row, "Current Mode")
        modeValLbl = Instance.new("TextLabel", row)
        modeValLbl.Size = UDim2.new(0, 110, 1, 0)
        modeValLbl.Position = UDim2.new(1, -118, 0, 0)
        modeValLbl.BackgroundTransparency = 1
        modeValLbl.Text = "Normal"
        modeValLbl.TextColor3 = WHITE
        modeValLbl.Font = Enum.Font.GothamBlack
        modeValLbl.TextSize = 11
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

    mkSect(momentPage, "Jump")
    do
        local row = mkRow(momentPage, 38)
        mkLabel(row, "Infinite Jump")
        local jumpPill, jumpDot = mkPill(row, 52)
        local jumpOn = false
        setJumpToggleState = function(state)
            if jumpOn == state then return end
            jumpOn = state
            animPill(jumpPill, jumpDot, state)
            if state then jumpEnabled = true; startJumpMode() else jumpEnabled = false; stopJumpMode() end
        end
        local jumpClk = Instance.new("TextButton", jumpPill)
        jumpClk.Size = UDim2.new(1,0,1,0)
        jumpClk.BackgroundTransparency = 1
        jumpClk.Text = ""
        jumpClk.AutoButtonColor = false
        jumpClk.ZIndex = 10
        jumpClk.MouseButton1Click:Connect(function()
            if editModeEnabled and not uiLocked then
                if jumpOn then
                    jumpEnabled = false
                    stopJumpMode()
                else
                    jumpEnabled = true
                    startJumpMode()
                end
            else
                setJumpToggleState(not jumpOn)
            end
        end)
        setJumpVisual = function(state) setJumpToggleState(state) end
    end

    do
        local row = mkRow(momentPage, 38)
        mkLabel(row, "Jump Mode")
        modeSelectBtn = mkSelector(row, jumpMode == 1 and "Tap Tap" or "Hold", {"Tap Tap", "Hold"}, function(dir, update)
            local newMode = jumpMode == 1 and 2 or 1
            jumpMode = newMode
            update(jumpMode == 1 and "Tap Tap" or "Hold")
            if jumpEnabled then stopJumpMode(); startJumpMode() end
        end)
    end

    setUnwalkVisual = mkToggle(momentPage, "Unwalk", function(on)
        unwalkEnabled = on
        if on then startUnwalk() else stopUnwalk() end
    end)

    mkSect(momentPage, "Drop")
    dropBrainrotSetVisual = mkToggle(momentPage, "Drop Brainrot", function(on)
        if on then
            executeDropWithToggle(function(v)
                dropBrainrotSetVisual(v)
                if mobSetDropBR then mobSetDropBR(v) end
            end)
        end
    end)
    setDropVisual = dropBrainrotSetVisual

    do
        local row = mkRow(momentPage, 38)
        mkLabel(row, "Drop Mode")
        dropModeBtnRef = mkSelector(row, dropMode == 1 and "Fling" or "Jump Drop", {"Fling", "Jump Drop"}, function(dir, update)
            if dropActive then stopDropBrainrot() end
            dropMode = dropMode == 1 and 2 or 1
            update(dropMode == 1 and "Fling" or "Jump Drop")
        end)
    end

    mkSect(momentPage, "Auto Movement")
    autoLeftSetVisual = mkToggle(momentPage, "Auto Left", function(on)
        autoLeftEnabled = on
        if on then startAutoLeft() else stopAutoLeft() end
        if mobSetAutoLeft then mobSetAutoLeft(on) end
    end)
    autoRightSetVisual = mkToggle(momentPage, "Auto Right", function(on)
        autoRightEnabled = on
        if on then startAutoRight() else stopAutoRight() end
        if mobSetAutoRight then mobSetAutoRight(on) end
    end)

    mkSect(momentPage, "TP & Reset")
    do
        local row = mkRow(momentPage, 38)
        mkLabel(row, "TP Down")
        local clk = Instance.new("TextButton", row)
        clk.Size = UDim2.new(0.58, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 8
        clk.MouseButton1Click:Connect(function()
            runTPDown()
        end)
        local actLbl = Instance.new("TextLabel", row)
        actLbl.Size = UDim2.new(0, 70, 1, 0)
        actLbl.Position = UDim2.new(1, -78, 0, 0)
        actLbl.BackgroundTransparency = 1
        actLbl.Text = "ACTIVATE"
        actLbl.TextColor3 = WHITE
        actLbl.Font = Enum.Font.GothamBold
        actLbl.TextSize = 9
        actLbl.TextXAlignment = Enum.TextXAlignment.Right
        actLbl.ZIndex = 8
    end

    setAutoTPDownVisual = mkToggle(momentPage, "Auto TP Down", function(on)
        autoTPDownEnabled = on
        if on then startAutoTPDown() else stopAutoTPDown() end
    end)
    do
        local row = mkRow(momentPage, 38)
        mkLabel(row, "Height Y")
        autoTPHeightBox = mkBox(row, autoTPDownHeight, 50, 56, function(v)
            if v and v >= 1 and v <= 500 then autoTPDownHeight = v end
        end)
    end

    mkSect(momentPage, "Music")
    
    -- Intro Song Selector
    do
        local songRow = mkRow(momentPage, 32)
        mkLabel(songRow, "Intro Song")
        local songBtn = Instance.new("TextButton", songRow)
        songBtn.Size = UDim2.new(0, 90, 0, 22)
        songBtn.Position = UDim2.new(1, -96, 0.5, -11)
        songBtn.BackgroundColor3 = Color3.fromRGB(12, 0, 24)
        songBtn.BorderSizePixel = 0
        songBtn.Text = "Song " .. songIndex .. " ›"
        songBtn.TextColor3 = Color3.fromRGB(160, 0, 255)
        songBtn.Font = Enum.Font.GothamBold
        songBtn.TextSize = 11
        songBtn.AutoButtonColor = false
        songBtn.ZIndex = 5
        Instance.new("UICorner", songBtn).CornerRadius = UDim.new(0, 6)
        local sst = Instance.new("UIStroke", songBtn)
        sst.Color = Color3.fromRGB(90, 0, 150); sst.Thickness = 1
        songBtn.Activated:Connect(function()
            songIndex = songIndex % #INTRO_SONGS_P + 1
            songBtn.Text = "Song " .. songIndex .. " ›"
            task.spawn(function()
                playPreview(songIndex)
            end)
            pcall(function() if writefile then writefile(indexFile, tostring(songIndex)) end end)
            -- if keep music is on, restart with new song
            if keepMusicEnabled then
                task.delay(0.1, function() startKeepMusic(songIndex) end)
            end
        end)
    end
    
    setKeepMusicVisual = mkToggle(momentPage, "Keep Music On", function(on)
        if on then
            startKeepMusic(keepMusicIndex)
        else
            stopKeepMusic()
        end
    end)

    -- ========== COMBAT TAB ==========
    local combatPage = contentPages["Combat"]

    mkSect(combatPage, "Aimbots")
    autoBatSetVisual = mkToggle(combatPage, "Auto Bat", function(on)
        if on then enableAutoBat() else disableAutoBat() end
        if mobSetAutoBat then mobSetAutoBat(on) end
    end)
    do local row = mkRow(combatPage, 38); mkLabel(row, "Bat Aimbot Speed"); batSpeedBox = mkBox(row, BAT_AIMBOT_SPEED, 50, 56, function(v) if v > 0 and v <= 200 then BAT_AIMBOT_SPEED = v end end) end

    tpLockSetVisual = mkToggle(combatPage, "TP Bat", function(on)
        if on then
            if not tpLockEnabled then toggleTPLock() end
        else
            if tpLockEnabled then toggleTPLock() end
        end
    end)
    if tpLockSetVisual then tpLockSetVisual(tpLockEnabled) end

    mkSect(combatPage, "Counters")
    setBatCounterVisual = mkToggle(combatPage, "Bat Counter", function(on)
        batCounterEnabled = on
        if on then startBatCounter() else stopBatCounter() end
    end)

    setMedusaVisual = mkToggle(combatPage, "Medusa Counter", function(on) setMedusaCounterState(on) end)
    setMedusaAutoResetVisual = mkToggle(combatPage, "Medusa Auto Reset", function(on) setMedusaAutoResetState(on) end)

    mkSect(combatPage, "Defense")
    setAntiRagVisual = mkToggle(combatPage, "Anti Ragdoll", function(on)
        setAntiRag(on)
    end)

    bodyLockSetVisual = mkToggle(combatPage, "Body Lock", function(on)
        bodyLockEnabled = on
        if on then
            if _blSuppressCount == 0 then startBodyLock() end
        else
            stopBodyLock()
        end
    end)
    do
        local row = mkRow(combatPage, 38)
        mkLabel(row, "Body Lock Range")
        bodyLockRangeBox = mkBox(row, bodyLockRange, 50, 56, function(v)
            if v and v > 0 then
                bodyLockRange = math.clamp(math.floor(v), 5, 200)
                if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
            end
        end)
    end

    -- ========== MAIN TAB ==========
    local mainPage = contentPages["Main"]

    mkSect(mainPage, "Auto Steal")
    setInstaGrab = mkToggle(mainPage, "Auto Steal", function(on)
        CONFIG.AUTO_STEAL_ENABLED = on
        if on then pcall(startAutoSteal) else stopAutoSteal() end
        updateProgressBarVisibility()
    end)

    do
        local row = mkRow(mainPage, 38)
        mkLabel(row, "Steal Radius")
        radInput = mkBox(row, CONFIG.STEAL_RANGE, 50, 56, function(v)
            if v and v >= 5 and v <= 300 then
                CONFIG.STEAL_RANGE = math.floor(v+0.5)
                radInput.Text = tostring(CONFIG.STEAL_RANGE)
            end
        end)
    end

    -- ===== CUSTOMIZATION =====
    mkSect(mainPage, "CUSTOMIZATION")

    -- 1. Anim Pack
    do
        local row = mkRow(mainPage, 38)
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
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        local leftStroke = Instance.new("UIStroke", leftBtn)
        leftStroke.Color = ROW_BORDER
        leftStroke.Thickness = 1

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
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local rightStroke = Instance.new("UIStroke", rightBtn)
        rightStroke.Color = ROW_BORDER
        rightStroke.Thickness = 1

        local function updateAnimSelector(direction)
            local idx = 1
            for i, entry in ipairs(ANIM_PACK_ORDER) do
                if entry[2] == currentAnimPack then idx = i; break end
            end
            local newIdx = idx + direction
            if newIdx < 1 then newIdx = #ANIM_PACK_ORDER end
            if newIdx > #ANIM_PACK_ORDER then newIdx = 1 end
            local packName = ANIM_PACK_ORDER[newIdx][2]
            if packName == "Off" then
                stopAnimPack()
            else
                startAnimPack(packName)
            end
        end

        leftBtn.MouseButton1Click:Connect(function() updateAnimSelector(-1) end)
        rightBtn.MouseButton1Click:Connect(function() updateAnimSelector(1) end)
    end

    -- 2. Sky Theme
    do
        local row = mkRow(mainPage, 38)
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
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        local leftStroke = Instance.new("UIStroke", leftBtn)
        leftStroke.Color = ROW_BORDER
        leftStroke.Thickness = 1

        skySelectorLabel = Instance.new("TextLabel", container)
        skySelectorLabel.Size = UDim2.new(0, 80, 0, 26)
        skySelectorLabel.Position = UDim2.new(0.5, -40, 0.5, -13)
        skySelectorLabel.BackgroundTransparency = 1
        skySelectorLabel.Text = currentSkyTheme or "None"
        skySelectorLabel.TextColor3 = WHITE
        skySelectorLabel.Font = Enum.Font.GothamBold
        skySelectorLabel.TextSize = 12
        skySelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        skySelectorLabel.ZIndex = 9

        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local rightStroke = Instance.new("UIStroke", rightBtn)
        rightStroke.Color = ROW_BORDER
        rightStroke.Thickness = 1

        local function updateSkySelector(direction)
            local idx = 1
            for i, name in ipairs(DRIFT_SKY_ORDER) do
                if name == currentSkyTheme then idx = i; break end
            end
            local newIdx = idx + direction
            if newIdx < 1 then newIdx = #DRIFT_SKY_ORDER end
            if newIdx > #DRIFT_SKY_ORDER then newIdx = 1 end
            local themeName = DRIFT_SKY_ORDER[newIdx]
            currentSkyTheme = themeName
            applyDriftSkyTheme(themeName)
            skySelectorLabel.Text = themeName
            saveAllSettings()
        end

        leftBtn.MouseButton1Click:Connect(function() updateSkySelector(-1) end)
        rightBtn.MouseButton1Click:Connect(function() updateSkySelector(1) end)
    end

    -- 3. Background con selector de imágenes
    do
        local row = mkRow(mainPage, 38)
        mkLabel(row, "Background")

        local leftBtn = Instance.new("TextButton", row)
        leftBtn.Size = UDim2.new(0, 28, 0, 22)
        leftBtn.Position = UDim2.new(1, -132, 0.5, -11)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        local leftStroke = Instance.new("UIStroke", leftBtn)
        leftStroke.Color = ROW_BORDER
        leftStroke.Thickness = 1

        local preview = Instance.new("ImageLabel", row)
        preview.Size = UDim2.new(0, 48, 0, 32)
        preview.Position = UDim2.new(1, -98, 0.5, -16)
        preview.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
        preview.BackgroundTransparency = 0
        preview.BorderSizePixel = 0
        preview.Image = BackgroundDecals[currentBgIndex] or BackgroundDecals[1]
        preview.ImageTransparency = 0
        preview.ZIndex = 3
        Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 4)
        local prevStroke = Instance.new("UIStroke", preview)
        prevStroke.Color = ROW_BORDER
        prevStroke.Thickness = 1
        bgPreviewRef = preview

        local rightBtn = Instance.new("TextButton", row)
        rightBtn.Size = UDim2.new(0, 28, 0, 22)
        rightBtn.Position = UDim2.new(1, -38, 0.5, -11)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local rightStroke = Instance.new("UIStroke", rightBtn)
        rightStroke.Color = ROW_BORDER
        rightStroke.Thickness = 1

        local function updateBg(direction)
            local newIndex = currentBgIndex + direction
            if newIndex < 1 then newIndex = #BackgroundDecals end
            if newIndex > #BackgroundDecals then newIndex = 1 end
            updateBackground(newIndex)
            preview.Image = BackgroundDecals[newIndex] or BackgroundDecals[1]
        end

        leftBtn.MouseButton1Click:Connect(function() updateBg(-1) end)
        rightBtn.MouseButton1Click:Connect(function() updateBg(1) end)

        local countLbl = Instance.new("TextLabel", row)
        countLbl.Size = UDim2.new(0, 30, 1, 0)
        countLbl.Position = UDim2.new(1, -170, 0, 0)
        countLbl.BackgroundTransparency = 1
        countLbl.Text = currentBgIndex .. "/" .. #BackgroundDecals
        countLbl.TextColor3 = Color3.fromRGB(255, 150, 150)
        countLbl.Font = Enum.Font.GothamBold
        countLbl.TextSize = 10
        countLbl.TextXAlignment = Enum.TextXAlignment.Right
        countLbl.ZIndex = 8
    end

    setESPVIsual = mkToggle(mainPage, "Player ESP", function(on) toggleESP(on) end)

    do
        local row = mkRow(mainPage, 38)
        mkLabel(row, "Stretch Rez")

        local expandBtn = Instance.new("TextButton", row)
        expandBtn.Size = UDim2.new(0, 28, 0, 22)
        expandBtn.Position = UDim2.new(0.58, 0, 0.5, -11)
        expandBtn.BackgroundColor3 = INP
        expandBtn.BackgroundTransparency = 0.7
        expandBtn.BorderSizePixel = 0
        expandBtn.Text = "▶"
        expandBtn.TextColor3 = WHITE
        expandBtn.Font = Enum.Font.GothamBold
        expandBtn.TextSize = 14
        expandBtn.AutoButtonColor = false
        expandBtn.ZIndex = 9
        Instance.new("UICorner", expandBtn).CornerRadius = UDim.new(0, 6)
        local expandStroke = Instance.new("UIStroke", expandBtn)
        expandStroke.Color = ROW_BORDER
        expandStroke.Thickness = 1

        local stretchPill, stretchDot = mkPill(row, 52)
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
        stretchClk.MouseButton1Click:Connect(function()
            setStretch(not stretchOn)
        end)
        _G.stretchToggleSetter = setStretch

        fovContainer = Instance.new("Frame", mainPage)
        fovContainer.Size = UDim2.new(1, -4, 0, 38)
        fovContainer.BackgroundColor3 = ROW_BG
        fovContainer.BackgroundTransparency = 0.7
        fovContainer.BorderSizePixel = 0
        fovContainer.LayoutOrder = getNextOrder(mainPage)
        fovContainer.ZIndex = 7
        fovContainer.Visible = false
        Instance.new("UICorner", fovContainer).CornerRadius = UDim.new(0, 10)
        local fovStroke = Instance.new("UIStroke", fovContainer)
        fovStroke.Color = ROW_BORDER
        fovStroke.Thickness = 1
        fovStroke.Transparency = 0.5

        local fovLabel = Instance.new("TextLabel", fovContainer)
        fovLabel.Size = UDim2.new(0.25, 0, 1, 0)
        fovLabel.Position = UDim2.new(0, 10, 0, 0)
        fovLabel.BackgroundTransparency = 1
        fovLabel.Text = "FOV"
        fovLabel.TextColor3 = WHITE
        fovLabel.Font = Enum.Font.GothamBold
        fovLabel.TextSize = 11
        fovLabel.TextXAlignment = Enum.TextXAlignment.Left
        fovLabel.TextStrokeColor3 = Color3.fromRGB(255, 150, 150)
        fovLabel.TextStrokeTransparency = 0.5
        fovLabel.ZIndex = 8

        local fovBtnFrame = Instance.new("Frame", fovContainer)
        fovBtnFrame.Size = UDim2.new(0, 150, 1, 0)
        fovBtnFrame.Position = UDim2.new(1, -162, 0, 0)
        fovBtnFrame.BackgroundTransparency = 1
        fovBtnFrame.ZIndex = 8

        local function makeFOVBtn(val, x)
            local btn = Instance.new("TextButton", fovBtnFrame)
            btn.Size = UDim2.new(0, 42, 0, 26)
            btn.Position = UDim2.new(0, x, 0.5, -13)
            btn.BackgroundColor3 = INP
            btn.BackgroundTransparency = 0.7
            btn.BorderSizePixel = 0
            btn.Text = tostring(val)
            btn.TextColor3 = WHITE
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 11
            btn.AutoButtonColor = false
            btn.ZIndex = 9
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            local stroke = Instance.new("UIStroke", btn)
            stroke.Color = ROW_BORDER
            stroke.Thickness = 1
            if val == stretchFOV then
                btn.BackgroundColor3 = WHITE
                btn.TextColor3 = Color3.fromRGB(255, 150, 150)
            end
            btn.MouseButton1Click:Connect(function()
                stretchFOV = val
                if stretchEnabled then applyStretchFOV(val) end
                for _, b in ipairs(fovBtnFrame:GetChildren()) do
                    if b:IsA("TextButton") then
                        local v = tonumber(b.Text)
                        if v == val then
                            b.BackgroundColor3 = WHITE
                            b.TextColor3 = Color3.fromRGB(255, 150, 150)
                        else
                            b.BackgroundColor3 = INP
                            b.TextColor3 = WHITE
                        end
                    end
                end
            end)
            return btn
        end
        makeFOVBtn(90, 0)
        makeFOVBtn(120, 54)
        makeFOVBtn(180, 108)
        _G.fovButtons = fovBtnFrame:GetChildren()

        local function toggleFov()
            fovContainer.Visible = not fovContainer.Visible
            expandBtn.Text = fovContainer.Visible and "▼" or "▶"
        end

        expandBtn.MouseButton1Click:Connect(toggleFov)
        fovToggleBtn = expandBtn
    end

    setAntiLagVisual = mkToggle(mainPage, "Anti Lag", function(on)
        if on then enableAntiLag() else disableAntiLag() end
    end)

    mkSect(mainPage, "Interface")
    setEditModeVisual = mkToggle(mainPage, "Edit Button", function(on)
        toggleEditMode(on)
        if on and uiLocked then
            editModeEnabled = false
            setEditModeVisual(false)
        end
    end)
    if setEditModeVisual then setEditModeVisual(editModeEnabled) end

    setLockUIVisual = mkToggle(mainPage, "Lock UI", function(on)
        toggleLockUI(on)
        if on and editModeEnabled then
            editModeEnabled = false
            if setEditModeVisual then setEditModeVisual(false) end
        end
    end)

    do
        local row = mkRow(mainPage, 38)
        mkLabel(row, "UI Scale")
        uiScaleBox = mkBox(row, uiScaleValue, 50, 56, function(v)
            local n = math.clamp(math.floor(v+0.5), 50, 150)
            uiScaleValue = n
            if mainUIScale then mainUIScale.Scale = n/100 end
            if pbScale then pbScale.Scale = n/100 end
        end)
    end

    mkSect(mainPage, "Config")
    do
        local row = mkRow(mainPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local saveBtn = Instance.new("TextButton", row)
        saveBtn.Size = UDim2.new(1, -12, 0.8, 0)
        saveBtn.Position = UDim2.new(0, 6, 0.1, 0)
        saveBtn.BackgroundColor3 = RED3
        saveBtn.BackgroundTransparency = 0.5
        saveBtn.BorderSizePixel = 0
        saveBtn.Text = "SAVE CONFIG"
        saveBtn.TextColor3 = WHITE
        saveBtn.Font = Enum.Font.GothamBold
        saveBtn.TextSize = 13
        saveBtn.TextStrokeColor3 = Color3.fromRGB(255, 150, 150)
        saveBtn.TextStrokeTransparency = 0
        saveBtn.AutoButtonColor = false
        saveBtn.ZIndex = 8
        Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 8)
        local saveStroke = Instance.new("UIStroke", saveBtn)
        saveStroke.Color = ROW_BORDER
        saveStroke.Thickness = 1.2
        saveStroke.Transparency = 0.5
        saveBtn.MouseButton1Click:Connect(function()
            local ok = saveAllSettings()
            saveBtn.Text = ok and "SAVED ✓" or "ERROR"
            task.delay(1.2, function()
                if saveBtn and saveBtn.Parent then saveBtn.Text = "SAVE CONFIG" end
            end)
        end)
    end

    do
        local row = mkRow(mainPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local delBtn = Instance.new("TextButton", row)
        delBtn.Size = UDim2.new(1, -12, 0.8, 0)
        delBtn.Position = UDim2.new(0, 6, 0.1, 0)
        delBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
        delBtn.BackgroundTransparency = 0.5
        delBtn.BorderSizePixel = 0
        delBtn.Text = "DELETE SETTINGS"
        delBtn.TextColor3 = WHITE
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 13
        delBtn.TextStrokeColor3 = Color3.fromRGB(255, 150, 150)
        delBtn.TextStrokeTransparency = 0
        delBtn.AutoButtonColor = false
        delBtn.ZIndex = 8
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 8)
        local delStroke = Instance.new("UIStroke", delBtn)
        delStroke.Color = ROW_BORDER
        delStroke.Thickness = 1.2
        delStroke.Transparency = 0.5

        local deleteState = 0
        local originalDeleteText = "DELETE SETTINGS"
        local delDebounce = false
        delBtn.MouseButton1Click:Connect(function()
            if delDebounce then return end
            if deleteState == 0 then
                deleteState = 1
                delBtn.Text = "CONFIRM?"
                delBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
                task.delay(2, function()
                    if delBtn and delBtn.Parent and deleteState == 1 then
                        deleteState = 0
                        delBtn.Text = originalDeleteText
                        delBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
                    end
                end)
            elseif deleteState == 1 then
                delDebounce = true
                local success = pcall(resetToFactoryDefaults)
                delBtn.Text = success and "DELETED ✓" or "ERROR"
                delBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
                deleteState = 0
                task.delay(1.5, function()
                    if delBtn and delBtn.Parent then
                        delBtn.Text = originalDeleteText
                        delBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
                        delDebounce = false
                    end
                end)
            end
        end)
    end

    -- KEYBINDS TAB
    local keyPage = contentPages["Keybinds"]
    mkSect(keyPage, "Keybinds")
    addKeybindRow(keyPage, "Carry Mode", KB.CarryToggle)
    addKeybindRow(keyPage, "Lagger Mode", KB.LaggerMode)
    addKeybindRow(keyPage, "Auto Left", KB.AutoLeft)
    addKeybindRow(keyPage, "Auto Right", KB.AutoRight)
    addKeybindRow(keyPage, "Auto Bat", KB.AutoBat)
    addKeybindRow(keyPage, "TP Bat", KB.TPLock)
    addKeybindRow(keyPage, "TP Down", KB.TPFloor)
    addKeybindRow(keyPage, "Drop Brainrot", KB.DropBrainrot)
    addKeybindRow(keyPage, "Jump Mode", KB.JumpMode)
    addKeybindRow(keyPage, "Hide GUI", KB.GuiHide)

    local spacer = Instance.new("Frame", keyPage)
    spacer.Size = UDim2.new(1, 0, 0, 16)
    spacer.BackgroundTransparency = 1
    spacer.LayoutOrder = getNextOrder(keyPage)
    spacer.ZIndex = 7

    drag(main)
end

-- ============================================================
-- NUEVA BARRA DE STEAL (K7_StatusUI) - RED THEME DESIGN
-- ============================================================

local oldStealBarGui = LP.PlayerGui:FindFirstChild("K7_StatusUI")
if oldStealBarGui then oldStealBarGui:Destroy() end

local stealBarGui = Instance.new("ScreenGui")
stealBarGui.Name = "K7_StatusUI"
stealBarGui.ResetOnSpawn = false
stealBarGui.IgnoreGuiInset = true
stealBarGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
stealBarGui.Parent = LP:WaitForChild("PlayerGui")

stealBarGui.Enabled = false

local C = {
    bg      = Color3.fromRGB(10, 0, 0),      -- Dark background
    accent  = Color3.fromRGB(255, 0, 0),     -- Bright Red
    white   = Color3.fromRGB(255, 255, 255),
    grey    = Color3.fromRGB(180, 180, 180),
    track   = Color3.fromRGB(30, 0, 0),      -- Darker red for track
    stroke  = Color3.fromRGB(255, 0, 0),
}

local FONT_BOLD = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
local FONT_REG  = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular)

local function addMoneyBackground(parent, count, color)
    for i = 1, count do
        local money = Instance.new("TextLabel")
        money.BackgroundTransparency = 1
        money.Size = UDim2.fromOffset(10, 10)
        money.Position = UDim2.fromScale(math.random(), math.random())
        money.Text = "$"
        money.TextColor3 = color or Color3.fromRGB(255, 255, 255)
        money.TextTransparency = math.random(7, 9) / 10
        money.TextSize = math.random(8, 12)
        money.Rotation = math.random(-45, 45)
        money.ZIndex = 1
        money.Parent = parent
    end
end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.fromOffset(360, 65)
mainFrame.AnchorPoint = Vector2.new(0.5, 1)

-- Cargar posición guardada
if savedStealBarPos then
    mainFrame.Position = UDim2.new(
        savedStealBarPos.XScale or 0.5,
        savedStealBarPos.XOffset or 0,
        savedStealBarPos.YScale or 1,
        savedStealBarPos.YOffset or -70
    )
else
    mainFrame.Position = UDim2.new(0.5, 0, 1, -70)
end

mainFrame.BackgroundColor3 = C.bg
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = stealBarGui

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 18)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = C.accent
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.6
mainStroke.Parent = mainFrame

-- Percentage Label
local pctLbl = Instance.new("TextLabel")
pctLbl.BackgroundTransparency = 1
pctLbl.Position = UDim2.fromOffset(20, 10)
pctLbl.Size = UDim2.fromOffset(80, 30)
pctLbl.FontFace = FONT_BOLD
pctLbl.TextSize = 24
pctLbl.TextColor3 = C.white
pctLbl.TextXAlignment = Enum.TextXAlignment.Left
pctLbl.Text = "0%"
pctLbl.Parent = mainFrame

-- Info Label (FPS, PING, Radius)
local infoLbl = Instance.new("TextLabel")
infoLbl.BackgroundTransparency = 1
infoLbl.AnchorPoint = Vector2.new(1, 0)
infoLbl.Position = UDim2.new(1, -15, 0, 20)
infoLbl.Size = UDim2.fromOffset(200, 20)
infoLbl.FontFace = FONT_BOLD
infoLbl.TextSize = 12
infoLbl.TextColor3 = C.white
infoLbl.TextXAlignment = Enum.TextXAlignment.Right
infoLbl.Text = "FPS: 60 PING: 0ms"
infoLbl.Parent = mainFrame

-- Progress Bar Track
local track = Instance.new("Frame")
track.AnchorPoint = Vector2.new(0.5, 1)
track.Position = UDim2.new(0.5, 0, 1, -8)
track.Size = UDim2.new(0.9, 0, 0, 6)
track.BackgroundColor3 = C.track
track.BorderSizePixel = 0
track.ClipsDescendants = true
track.Parent = mainFrame
Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

-- Progress Bar Fill
local fill = Instance.new("Frame")
fill.Size = UDim2.fromScale(0, 1)
fill.BackgroundColor3 = C.accent
fill.BorderSizePixel = 0
fill.Parent = track
Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

			-- Stars
			for i = 1, 30 do
			    local star = Instance.new("Frame")
			    local size = math.random(2, 5)
			    star.Size = UDim2.fromOffset(size, size)
			    star.Position = UDim2.fromScale(math.random(), math.random() * 0.8)
			    star.BackgroundColor3 = C.white
			    star.BackgroundTransparency = math.random(3, 7) / 10
			    star.BorderSizePixel = 0
			    star.ZIndex = 1
			    star.Parent = mainFrame
			    Instance.new("UICorner", star).CornerRadius = UDim.new(1, 0)
			end
			addMoneyBackground(mainFrame, 15, C.white)

local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   C.accent),
    ColorSequenceKeypoint.new(0.3, C.accent),
    ColorSequenceKeypoint.new(0.5, C.white),
    ColorSequenceKeypoint.new(0.7, C.accent),
    ColorSequenceKeypoint.new(1,   C.accent),
})
grad.Parent = fill

-- Drag y guardado de posición
local dragging = false
local dragStart = nil
local startPos = nil

local function startDrag(input)
    if uiLocked then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end

local function onDrag(input)
    if not dragging or uiLocked then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local d = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end

local function endDrag(input)
    if dragging then
        -- Guardar posición cuando se suelta
        savedStealBarPos = {
            XScale = mainFrame.Position.X.Scale,
            XOffset = mainFrame.Position.X.Offset,
            YScale = mainFrame.Position.Y.Scale,
            YOffset = mainFrame.Position.Y.Offset
        }
        dragging = false
        dragStart = nil
        startPos = nil
        -- Auto-guardar al soltar
        task.spawn(function()
            saveAllSettings()
        end)
    end
end

mainFrame.InputBegan:Connect(startDrag)
UIS.InputChanged:Connect(onDrag)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        endDrag(input)
    end
end)

local shimmerRunning = true
local shimmerThread = nil

local function startShimmer()
    if shimmerThread then return end
    shimmerRunning = true
    shimmerThread = task.spawn(function()
        while shimmerRunning and grad and grad.Parent do
            local fw = TS:Create(grad, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Offset = Vector2.new(0.5, 0)
            })
            fw:Play()
            fw.Completed:Wait()
            if not shimmerRunning then break end
            local bk = TS:Create(grad, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Offset = Vector2.new(-0.5, 0)
            })
            bk:Play()
            bk.Completed:Wait()
        end
        shimmerThread = nil
    end)
end

local function stopShimmer()
    shimmerRunning = false
    if shimmerThread then
        task.cancel(shimmerThread)
        shimmerThread = nil
    end
end

local frameCount = 0
local timeAccum = 0
local currentFPS = 0

RunService.RenderStepped:Connect(function(delta)
    frameCount = frameCount + 1
    timeAccum = timeAccum + delta
    if timeAccum >= 0.5 then
        currentFPS = math.floor(frameCount / timeAccum + 0.5)
        frameCount = 0
        timeAccum = 0
        local ping = 0
        pcall(function() ping = math.floor(LP:GetNetworkPing() * 1000 + 0.5) end)
        infoLbl.Text = string.format("FPS: %d PING: %dms", currentFPS, ping)
    end
end)

function updateStealProgress(progress)
    progress = math.clamp(progress or 0, 0, 1)
    local pct = math.floor(progress * 100)
    fill.Size = UDim2.fromScale(progress, 1)
    if progress > 0 then
        stopShimmer()
    else
        startShimmer()
    end
    pctLbl.Text = pct .. "%"
end

function updateStealRadius(radius)
    -- Radius is no longer shown in the new design to match the reference image
end

function setStealBarColor(color)
    fill.BackgroundColor3 = color
end

startShimmer()
updateStealRadius(CONFIG.STEAL_RANGE)

local radUpdateConn = nil
radUpdateConn = RunService.Heartbeat:Connect(function()
    local currentRad = CONFIG.STEAL_RANGE
    if currentRad then
        updateStealRadius(currentRad)
    end
end)

local progressUpdateConn = nil
progressUpdateConn = RunService.Heartbeat:Connect(function()
    local targetPct = 0
    if StealState.active then
        local elapsed = tick() - StealState.startTime
        local duration = CONFIG.HOLD_MAX
        targetPct = math.clamp(elapsed / duration, 0, 1)
    elseif StealState.lastResultTime > 0 and (tick() - StealState.lastResultTime) < 1.2 then
        targetPct = 1
    else
        targetPct = 0
    end
    updateStealProgress(targetPct)
end)

function showStealBar()
    stealBarGui.Enabled = true
end

function hideStealBar()
    stealBarGui.Enabled = false
end

-- ============================================================

function createMobilePanel()
    local panel = Instance.new("ScreenGui")
    panel.Name = "TraceMobilePanel"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.Enabled = false
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = game:GetService("CoreGui") end) then
        panel.Parent = LP:WaitForChild("PlayerGui")
    end

    local BTN_W, BTN_H = 60, 60
    local GAP = 8
    local COLUMNS = 2
    local ROWS = 4
    local PANEL_W = BTN_W * COLUMNS + GAP * (COLUMNS - 1)
    local PANEL_H = BTN_H * ROWS + (GAP + 10) * (ROWS - 1)

    local container = Instance.new("Frame", panel)
    container.Name = "FloatingPanel"
    container.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
    container.Position = UDim2.new(1, -PANEL_W - 10, 0, 0)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Active = true
    container.Selectable = true
    container.ClipsDescendants = false

    local btnContainer = Instance.new("Frame", container)
    btnContainer.Name = "ButtonsContainer"
    btnContainer.Size = UDim2.new(1, 0, 1, 0)
    btnContainer.BackgroundTransparency = 1
    btnContainer.ClipsDescendants = false

    local WHITE = Color3.fromRGB(255, 255, 255)
    local INACTIVE_BG = Color3.fromRGB(255, 255, 255)
    local INACTIVE_TEXT = Color3.fromRGB(40, 40, 40)
    local STROKE_COLOR = Color3.fromRGB(200, 200, 200)
    local ACTIVE_BG = Color3.fromRGB(240, 240, 240)
    local ACTIVE_TEXT = Color3.fromRGB(255, 0, 0) -- Red text when active for contrast

    local buttons = {}
    local buttonNames = {"DropBR", "AutoLeft", "AutoBat", "AutoRight", "TpDown", "Carry", "Lagger1", "Lagger2"}
    local buttonTexts = {"DROP\nBR", "AUTO\nLEFT", "BAT\nAIMBOT", "AUTO\nRIGHT", "TP\nDOWN", "CARRY\nSPD", "LAGGER\nSPEED", "LAGGER\nCARRY"}

    local function createButton(name, text, order, isToggle, callback)
        local btn = Instance.new("TextButton", btnContainer)
        btn.Name = name
        btn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        btn.BackgroundColor3 = INACTIVE_BG
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ZIndex = 10

        local savedPos = savedButtonPositions[name]
        if savedPos then
            btn.Position = UDim2.new(0, savedPos.X or 0, 0, savedPos.Y or 0)
        else
            local defX, defY = getDefaultButtonPosition(name)
            btn.Position = UDim2.new(0, defX, 0, defY)
        end

        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 18)
        addMoneyBackground(btn, 4, Color3.fromRGB(0, 0, 0))
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = STROKE_COLOR
        stroke.Thickness = 1.2
        stroke.Transparency = 0.4
        stroke.Name = "NormalStroke"

        local label = Instance.new("TextLabel", btn)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = INACTIVE_TEXT
        label.Font = Enum.Font.GothamBold
        label.TextSize = 10
        label.TextWrapped = true
        label.ZIndex = 11

        local active = false
	        local function setActive(state)
	            active = state
	            if active then
	                btn.BackgroundColor3 = ACTIVE_BG
	                label.TextColor3 = ACTIVE_TEXT
	                stroke.Color = Color3.fromRGB(255, 0, 0) -- Red stroke for active
	                stroke.Transparency = 0
	            else
                btn.BackgroundColor3 = INACTIVE_BG
                label.TextColor3 = INACTIVE_TEXT
                stroke.Color = STROKE_COLOR
                stroke.Transparency = 0.4
            end
        end

        local dragging = false
        local hasMoved = false
        local dragStart = nil
        local startPos = nil
        local movedDistance = 0

        local function onInputBegan(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                hasMoved = false
                movedDistance = 0
                dragStart = input.Position
                startPos = btn.Position
                _isDraggingButton = true
            end
        end

        local function onInputChanged(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                movedDistance = delta.Magnitude
                if editModeEnabled and not uiLocked then
                    hasMoved = true
                    btn.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
                end
            end
        end

        local function onInputEnded(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    if movedDistance < 3 then
                        if isToggle then
                            if editModeEnabled and not uiLocked then
                                if callback then callback(function() end) end
                            else
                                if callback then callback(setActive) end
                            end
                        else
                            if callback then callback(setActive, active) end
                        end
                    elseif editModeEnabled and not uiLocked and hasMoved then
                        savedButtonPositions[name] = {
                            X = btn.Position.X.Offset,
                            Y = btn.Position.Y.Offset
                        }
                    end
                    dragging = false
                    hasMoved = false
                    dragStart = nil
                    startPos = nil
                    movedDistance = 0
                    _isDraggingButton = false
                end
            end
        end

        btn.InputBegan:Connect(onInputBegan)
        btn.InputChanged:Connect(onInputChanged)
        btn.InputEnded:Connect(onInputEnded)

        buttons[name] = {btn = btn, setActive = setActive, label = label}
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
                runTPDown()
                setActive(true)
                task.delay(0.2, function() setActive(false) end)
            end
        elseif name == "Carry" then
            callback = function(setActive)
                if not speedMode then
                    speedMode = true; laggerToggled = false; laggerLevel = 1; setActive(true)
                    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
                else
                    speedMode = false; setActive(false)
                end
                refreshSpeedModeLabel()
            end
        elseif name == "Lagger1" then
            callback = function(setActive)
                if speedMode then speedMode = false; if mobSetCarry then mobSetCarry(false) end end
                if not laggerToggled or laggerLevel ~= 1 then
                    laggerToggled = true; laggerLevel = 1; setActive(true)
                    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
                else
                    laggerToggled = false; laggerLevel = 1; setActive(false)
                end
                refreshSpeedModeLabel()
            end
        elseif name == "Lagger2" then
            callback = function(setActive)
                if speedMode then speedMode = false; if mobSetCarry then mobSetCarry(false) end end
                if not laggerToggled or laggerLevel ~= 2 then
                    laggerToggled = true; laggerLevel = 2; setActive(true)
                    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                else
                    laggerToggled = false; laggerLevel = 1; setActive(false)
                end
                refreshSpeedModeLabel()
            end
        end
        mobSetAutoBat = buttons.AutoBat and buttons.AutoBat.setActive
        mobSetAutoLeft = buttons.AutoLeft and buttons.AutoLeft.setActive
        mobSetAutoRight = buttons.AutoRight and buttons.AutoRight.setActive
        mobSetDropBR = buttons.DropBR and buttons.DropBR.setActive
        mobSetTpDown = buttons.TpDown and buttons.TpDown.setActive
        mobSetCarry = buttons.Carry and buttons.Carry.setActive
        mobSetLagger1 = buttons.Lagger1 and buttons.Lagger1.setActive
        mobSetLagger2 = buttons.Lagger2 and buttons.Lagger2.setActive

        local setActive = createButton(name, text, i-1, true, callback)
        if name == "AutoBat" then mobSetAutoBat = setActive end
        if name == "AutoLeft" then mobSetAutoLeft = setActive end
        if name == "AutoRight" then mobSetAutoRight = setActive end
        if name == "DropBR" then mobSetDropBR = setActive end
        if name == "TpDown" then mobSetTpDown = setActive end
        if name == "Carry" then mobSetCarry = setActive end
        if name == "Lagger1" then mobSetLagger1 = setActive end
        if name == "Lagger2" then mobSetLagger2 = setActive end
    end

    if buttons.AutoBat and buttons.AutoBat.setActive then buttons.AutoBat.setActive(autoBatEnabled) end
    if buttons.AutoLeft and buttons.AutoLeft.setActive then buttons.AutoLeft.setActive(autoLeftEnabled) end
    if buttons.AutoRight and buttons.AutoRight.setActive then buttons.AutoRight.setActive(autoRightEnabled) end
    if buttons.Carry and buttons.Carry.setActive then buttons.Carry.setActive(speedMode) end
    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(laggerToggled and laggerLevel == 1) end
    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(laggerToggled and laggerLevel == 2) end

    if savedMobilePanelPos then
        container.Position = UDim2.new(
            savedMobilePanelPos.XScale or 1,
            savedMobilePanelPos.XOffset or (-PANEL_W - 10),
            savedMobilePanelPos.YScale or 0,
            savedMobilePanelPos.YOffset or 0
        )
    end

    local draggingPanel = false
    local dragStartPos = nil
    local dragStartMousePos = nil
    local function startDragPanel(input)
        if uiLocked or _isDraggingButton or editModeEnabled then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingPanel = true
            dragStartPos = container.Position
            dragStartMousePos = input.Position
        end
    end
    local function onDragPanel(input)
        if not draggingPanel or uiLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragStartPos and dragStartMousePos then
                local delta = input.Position - dragStartMousePos
                local newX = dragStartPos.X.Offset + delta.X
                local newY = dragStartPos.Y.Offset + delta.Y                container.Position = UDim2.new(dragStartPos.X.Scale, newX, dragStartPos.Y.Scale, newY)
            end
        end
    end
    local function endDragPanel()
        if draggingPanel then
            draggingPanel = false
            savedMobilePanelPos = {
                XScale = container.Position.X.Scale,
                XOffset = container.Position.X.Offset,
                YScale = container.Position.Y.Scale,
                YOffset = container.Position.Y.Offset
            }
        end
        dragStartPos = nil
        dragStartMousePos = nil
    end
    container.InputBegan:Connect(startDragPanel)
    container.InputEnded:Connect(endDragPanel)
    UIS.InputChanged:Connect(onDragPanel)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            endDragPanel()
        end
    end)

    return panel
end

function showMobilePanel()
    if MobilePanel then MobilePanel.Enabled = true end
end

function hideMobilePanel()
    if MobilePanel then MobilePanel.Enabled = false end
end

function createInstaResetFloatingButton()
    local INACTIVE_BG = Color3.fromRGB(255, 255, 255)
    local INACTIVE_TEXT = Color3.fromRGB(40, 40, 40)
    local STROKE_COLOR = Color3.fromRGB(200, 200, 200)
    local ACTIVE_BG = Color3.fromRGB(240, 240, 240)
    local ACTIVE_TEXT = Color3.fromRGB(255, 0, 0)
    
    local panel = Instance.new("ScreenGui")
    panel.Name = "InstaResetButton"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 20
    panel.Enabled = false
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = game:GetService("CoreGui") end) then
        panel.Parent = LP:WaitForChild("PlayerGui")
    end

    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 60)
    btnFrame.Name = "Frame"
    if instaResetFloatingPos then
        btnFrame.Position = UDim2.new(instaResetFloatingPos.XScale or 1,
                                      instaResetFloatingPos.XOffset or (-MOBILE_PANEL_WIDTH - 10),
                                      instaResetFloatingPos.YScale or 0,
                                      instaResetFloatingPos.YOffset or (MOBILE_PANEL_HEIGHT + 10))
    else
        btnFrame.Position = UDim2.new(1, -MOBILE_PANEL_WIDTH - 10, 0, MOBILE_PANEL_HEIGHT + 10)
    end
    btnFrame.BackgroundColor3 = INACTIVE_BG
    btnFrame.BackgroundTransparency = 0
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 18)
    addMoneyBackground(btnFrame, 4, Color3.fromRGB(0, 0, 0))
    
    local stroke = Instance.new("UIStroke", btnFrame)
    stroke.Color = STROKE_COLOR
    stroke.Thickness = 1.2
    stroke.Transparency = 0.4
    
    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "RESET"
    label.TextColor3 = INACTIVE_TEXT
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextWrapped = true
    label.ZIndex = 21

    local function setActive(state)
        if state then
            btnFrame.BackgroundColor3 = ACTIVE_BG
            label.TextColor3 = ACTIVE_TEXT
            stroke.Color = Color3.fromRGB(255, 0, 0)
            stroke.Transparency = 0
        else
            btnFrame.BackgroundColor3 = INACTIVE_BG
            label.TextColor3 = INACTIVE_TEXT
            stroke.Color = STROKE_COLOR
            stroke.Transparency = 0.4
        end
    end

    local dragging = false; local hasMoved = false; local dragStart, startPos
    btnFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true; hasMoved = false; dragStart = inp.Position; startPos = btnFrame.Position
        end
    end)
    btnFrame.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - dragStart
            if delta.Magnitude > 5 then hasMoved = true end
            if hasMoved and not uiLocked then
                btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                              startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    btnFrame.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                if not hasMoved then
                    setActive(true)
                    instaReset()
                    if setInstaResetVisual then setInstaResetVisual(true) end
                    task.delay(0.3, function() if setInstaResetVisual then setInstaResetVisual(false) end; setActive(false) end)
                elseif not uiLocked and hasMoved then
                    instaResetFloatingPos = {
                        XScale = btnFrame.Position.X.Scale,
                        XOffset = btnFrame.Position.X.Offset,
                        YScale = btnFrame.Position.Y.Scale,
                        YOffset = btnFrame.Position.Y.Offset
                    }
                end
                dragging = false; hasMoved = false
            end
        end
    end)
    return panel
end

function showInstaResetButton()
    if instaResetFloatingButton then instaResetFloatingButton.Enabled = true end
end

function hideInstaResetButton()
    if instaResetFloatingButton then instaResetFloatingButton.Enabled = false end
end

function createTpBatFloatingButton()
    local INACTIVE_BG = Color3.fromRGB(255, 255, 255)
    local INACTIVE_TEXT = Color3.fromRGB(40, 40, 40)
    local STROKE_COLOR = Color3.fromRGB(200, 200, 200)
    local ACTIVE_BG = Color3.fromRGB(240, 240, 240)
    local ACTIVE_TEXT = Color3.fromRGB(255, 0, 0)

    local panel = Instance.new("ScreenGui")
    panel.Name = "TpBatButton"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 21
    panel.Enabled = false
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = game:GetService("CoreGui") end) then
        panel.Parent = LP:WaitForChild("PlayerGui")
    end

    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 60)
    btnFrame.Name = "Frame"
    if tpBatFloatingPos then
        btnFrame.Position = UDim2.new(tpBatFloatingPos.XScale or 1,
                                      tpBatFloatingPos.XOffset or (-10 - 60),
                                      tpBatFloatingPos.YScale or 0,
                                      tpBatFloatingPos.YOffset or (MOBILE_PANEL_HEIGHT + 10))
    else
        btnFrame.Position = UDim2.new(1, -10 - 60, 0, MOBILE_PANEL_HEIGHT + 10)
    end
    btnFrame.BackgroundColor3 = INACTIVE_BG
    btnFrame.BackgroundTransparency = 0
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 18)
    addMoneyBackground(btnFrame, 4, Color3.fromRGB(0, 0, 0))
    
    local stroke = Instance.new("UIStroke", btnFrame)
    stroke.Color = STROKE_COLOR
    stroke.Thickness = 1.2
    stroke.Transparency = 0.4

    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "TP\nBAT"
    label.TextColor3 = INACTIVE_TEXT
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextWrapped = true
    label.ZIndex = 21

    local function setActive(state)
        if state then
            btnFrame.BackgroundColor3 = ACTIVE_BG
            label.TextColor3 = ACTIVE_TEXT
            stroke.Color = Color3.fromRGB(255, 0, 0)
            stroke.Transparency = 0
        else
            btnFrame.BackgroundColor3 = INACTIVE_BG
            label.TextColor3 = INACTIVE_TEXT
            stroke.Color = STROKE_COLOR
            stroke.Transparency = 0.4
        end
    end

    local dragging = false; local hasMoved = false; local dragStart, startPos
    btnFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true; hasMoved = false; dragStart = inp.Position; startPos = btnFrame.Position
        end
    end)
    btnFrame.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - dragStart
            if delta.Magnitude > 5 then hasMoved = true end
            if hasMoved and not uiLocked then
                btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                              startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    btnFrame.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                if not hasMoved then
                    setActive(not tpLockEnabled)
                    toggleTPLock()
                elseif not uiLocked and hasMoved then
                    tpBatFloatingPos = {
                        XScale = btnFrame.Position.X.Scale,
                        XOffset = btnFrame.Position.X.Offset,
                        YScale = btnFrame.Position.Y.Scale,
                        YOffset = btnFrame.Position.Y.Offset
                    }
                end
                dragging = false; hasMoved = false
            end
        end
    end)
    tpBatFloatingButton = panel
    return panel
end

function showTpBatButton()
    if tpBatFloatingButton then tpBatFloatingButton.Enabled = true end
end

function hideTpBatButton()
    if tpBatFloatingButton then tpBatFloatingButton.Enabled = false end
end

function updateUIFromLoaded()
    task.wait()
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED_1) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_SPEED_2) end
    if autoTPHeightBox then autoTPHeightBox.Text = tostring(autoTPDownHeight) end
    if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    refreshSpeedModeLabel()

    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end

    if skySelectorLabel then
        skySelectorLabel.Text = currentSkyTheme or "None"
    end

    if savedProgressBarPos and pbFrame then
        pbFrame.Position = UDim2.new(
            savedProgressBarPos.XScale or 0.5,
            savedProgressBarPos.XOffset or -140,
            savedProgressBarPos.YScale or 1,
            savedProgressBarPos.YOffset or -50
        )
    end

    -- Restaurar posición de la barra de steal
    if savedStealBarPos and stealBarGui and mainFrame then
        mainFrame.Position = UDim2.new(
            savedStealBarPos.XScale or 0.5,
            savedStealBarPos.XOffset or 0,
            savedStealBarPos.YScale or 1,
            savedStealBarPos.YOffset or -70
        )
    end

    if bgDecalRef then
        bgDecalRef.Image = BackgroundDecals[currentBgIndex] or BackgroundDecals[1]
    end
    if bgPreviewRef then
        bgPreviewRef.Image = BackgroundDecals[currentBgIndex] or BackgroundDecals[1]
    end

    if uiLocked and setLockUIVisual then setLockUIVisual(true) end
    if editModeEnabled and setEditModeVisual then setEditModeVisual(true) end
    if antiRagdollEnabled and setAntiRagVisual then setAntiRagVisual(true); startAntiRagdoll() end
    if CONFIG.AUTO_STEAL_ENABLED and setInstaGrab then setInstaGrab(true); pcall(startAutoSteal) end
    if jumpEnabled then
        if setJumpVisual then setJumpVisual(true) end
        startJumpMode()
    else
        if setJumpVisual then setJumpVisual(false) end
    end

    if medusaCounterEnabled then
        if setMedusaVisual then setMedusaVisual(true) end
        if LP.Character then setupMedusa(LP.Character) end
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
        stopMedusaAutoReset()
    elseif medusaAutoResetEnabled then
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(true) end
        if LP.Character then setupMedusaAutoReset(LP.Character) end
        if setMedusaVisual then setMedusaVisual(false) end
        stopMedusaCounter()
    else
        if setMedusaVisual then setMedusaVisual(false) end
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
        stopMedusaCounter()
        stopMedusaAutoReset()
    end

    if batCounterEnabled and setBatCounterVisual then
        setBatCounterVisual(true)
        startBatCounter()
    end
    if autoTPDownEnabled then
        if setAutoTPDownVisual then setAutoTPDownVisual(true) end
        startAutoTPDown()
    end
    if unwalkEnabled and setUnwalkVisual then setUnwalkVisual(true); task.spawn(function() task.wait(0.5); startUnwalk() end) end
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

    if tpLockEnabled then
        if tpLockSetVisual then tpLockSetVisual(true) end
        if not tpLockConn then startTPLock() end
        if tpBatFloatingButton then
            local btnFrame = tpBatFloatingButton:FindFirstChild("Frame")
            if btnFrame then
                btnFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
                local label = btnFrame:FindFirstChild("TextLabel")
                if label then label.TextColor3 = Color3.fromRGB(255, 150, 150) end
            end
        end
    else
        if tpLockSetVisual then tpLockSetVisual(false) end
        if tpBatFloatingButton then
            local btnFrame = tpBatFloatingButton:FindFirstChild("Frame")
            if btnFrame then
                btnFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
                local label = btnFrame:FindFirstChild("TextLabel")
                if label then label.TextColor3 = Color3.fromRGB(255, 150, 150) end
            end
        end
    end

    if stretchEnabled then
        enableStretch()
        if _G.stretchToggleSetter then _G.stretchToggleSetter(true) end
    else
        if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    end

    if _G.fovButtons then
        for _, btn in ipairs(_G.fovButtons) do
            if btn:IsA("TextButton") then
                local val = tonumber(btn.Text)
                if val == stretchFOV then
                    btn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
                    btn.TextColor3 = Color3.fromRGB(255, 150, 150)
                else
                    btn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
                    btn.TextColor3 = Color3.fromRGB(255, 150, 150)
                end
            end
        end
    end

    if modeSelectBtn then modeSelectBtn.Text = jumpMode == 1 and "Tap Tap" or "Hold" end

    if mobSetAutoBat then mobSetAutoBat(autoBatEnabled) end
    if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
    if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled and laggerLevel == 1) end
    if mobSetLagger2 then mobSetLagger2(laggerToggled and laggerLevel == 2) end

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

    if fovContainer then
        fovContainer.Visible = false
        if fovToggleBtn then fovToggleBtn.Text = "▶" end
    end

    updateStealRadius(CONFIG.STEAL_RANGE)
end

-- ============================================================
-- TRACES INTRO
-- ============================================================
local introGui = Instance.new("ScreenGui")
introGui.Name = "TRACESIntro"
introGui.IgnoreGuiInset = true
introGui.DisplayOrder = 999999
introGui.ResetOnSpawn = false
introGui.Parent = LP:WaitForChild("PlayerGui")

local _introSound = nil
task.spawn(function()
    pcall(function()
        local url = "https://files.catbox.moe/tvpqny.mp3"
        local fileName = "TRACESIntroSong.mp3"
        local soundId
        local hasFile = false
        pcall(function() hasFile = isfile and isfile(fileName) end)
        if not hasFile then
            local data = game:HttpGet(url)
            if data and #data > 0 then writefile(fileName, data) end
        end
        pcall(function() soundId = getcustomasset(fileName) end)
        if not soundId then return end
        local snd = Instance.new("Sound")
        snd.Name = "TRACESIntroMusic"
        snd.Volume = 0.75
        snd.Looped = false
        snd.SoundId = soundId
        snd.Parent = game:GetService("SoundService")
        _introSound = snd
        task.wait(1.2)
        local t0 = tick()
        while snd and not snd.IsLoaded and tick()-t0 < 10 do task.wait(0.05) end
        pcall(function() snd:Play() end)
        snd.Ended:Connect(function()
            finishIntro()
        end)
    end)
end)

local bgHolder = Instance.new("Frame", introGui)
bgHolder.AnchorPoint = Vector2.new(0.5, 0.5)
bgHolder.Size = UDim2.new(0, 500, 0, 500)
bgHolder.Position = UDim2.new(0.5, 0, 0.42, 0)
bgHolder.BackgroundTransparency = 1
bgHolder.ZIndex = 2

local bgImg = Instance.new("ImageLabel", bgHolder)
bgImg.Size = UDim2.new(1, 0, 1, 0)
bgImg.BackgroundTransparency = 1
bgImg.Image = "rbxassetid://74670572484706"
bgImg.ImageTransparency = 0.10
bgImg.ScaleType = Enum.ScaleType.Crop
bgImg.ZIndex = 2

local fgHolder = Instance.new("Frame", introGui)
fgHolder.AnchorPoint = Vector2.new(0.5, 0.5)
fgHolder.Size = UDim2.new(0, 480, 0, 480)
fgHolder.Position = UDim2.new(0.5, 0, 0.72, 0)
fgHolder.BackgroundTransparency = 1
fgHolder.ZIndex = 4

local fgImg = Instance.new("ImageLabel", fgHolder)
fgImg.Size = UDim2.new(1, 0, 1, 0)
fgImg.BackgroundTransparency = 1
fgImg.Image = "rbxassetid://96474640431338"
fgImg.ImageTransparency = 0
fgImg.ScaleType = Enum.ScaleType.Fit
fgImg.ZIndex = 4

local tapLbl = Instance.new("TextLabel", introGui)
tapLbl.AnchorPoint = Vector2.new(0.5, 0)
tapLbl.Position = UDim2.new(0.5, 0, 0.82, 0)
tapLbl.Size = UDim2.new(0.9, 0, 0, 30)
tapLbl.BackgroundTransparency = 1
tapLbl.Text = "TAP ANYWHERE TO SKIP"
tapLbl.TextColor3 = Color3.fromRGB(255, 150, 150)
tapLbl.Font = Enum.Font.GothamBlack
tapLbl.TextSize = 18
tapLbl.TextStrokeColor3 = Color3.fromRGB(255, 150, 150)
tapLbl.TextStrokeTransparency = 0.2
tapLbl.ZIndex = 6

local tapCatcher = Instance.new("TextButton", introGui)
tapCatcher.Size = UDim2.new(1, 0, 1, 0)
tapCatcher.BackgroundTransparency = 1
tapCatcher.Text = ""
tapCatcher.ZIndex = 20
tapCatcher.AutoButtonColor = false

local function spawnParticle(x, y, color, size, rot)
    local p = Instance.new("Frame", introGui)
    p.AnchorPoint = Vector2.new(0.5, 0.5)
    p.Size = UDim2.new(0, size, 0, size)
    p.Position = UDim2.new(x, 0, y, 0)
    p.BackgroundColor3 = color
    p.BorderSizePixel = 0
    p.Rotation = rot or 0
    p.ZIndex = 15
    Instance.new("UICorner", p).CornerRadius = UDim.new(0, 2)
    return p
end

local function burstEffect(cx, cy, count, colors)
    for i = 1, count do
        local angle = (i / count) * math.pi * 2
        local dist = math.random(60, 180) / 1000
        local tx = cx + math.cos(angle) * dist
        local ty = cy + math.sin(angle) * dist
        local col = colors[math.random(1, #colors)]
        local sz = math.random(6, 18)
        local p = spawnParticle(cx, cy, col, sz, math.random(0, 360))
        local dur = math.random(30, 60) / 100
        TS:Create(p,
            TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = UDim2.new(tx, 0, ty, 0), BackgroundTransparency = 1, Size = UDim2.new(0, sz * 2, 0, sz * 2)}
        ):Play()
        task.delay(dur + 0.05, function() pcall(function() p:Destroy() end) end)
    end
end

local introActive = true
local introDone = false

task.spawn(function()
    task.wait(0.1)
    local blood = {
        Color3.fromRGB(50, 0, 0),
        Color3.fromRGB(50, 0, 0),
        Color3.fromRGB(50, 0, 0),
        Color3.fromRGB(50, 0, 0),
    }
    burstEffect(0.5, 0.42, 22, blood)
    task.wait(0.15)
    burstEffect(0.35, 0.5, 12, blood)
    task.wait(0.1)
    burstEffect(0.65, 0.35, 12, blood)

    task.wait(0.3)
    local sand = {
        Color3.fromRGB(50, 0, 0),
        Color3.fromRGB(50, 0, 0),
        Color3.fromRGB(50, 0, 0),
        Color3.fromRGB(50, 0, 0),
    }
    burstEffect(0.5, 0.42, 18, sand)
    task.wait(0.1)
    burstEffect(0.3, 0.6, 10, sand)
    task.wait(0.1)
    burstEffect(0.7, 0.55, 10, sand)

    task.wait(0.3)
    local white = {Color3.fromRGB(255, 150, 150), Color3.fromRGB(255, 150, 150)}
    burstEffect(0.5, 0.42, 16, white)
end)

local function finishIntro()
    if introDone then return end
    introDone = true
    introActive = false

    local blood = {Color3.fromRGB(50, 0, 0), Color3.fromRGB(50, 0, 0), Color3.fromRGB(50, 0, 0)}
    local white = {Color3.fromRGB(255, 150, 150), Color3.fromRGB(255, 150, 150)}
    burstEffect(0.5, 0.42, 20, blood)
    task.wait(0.05)
    burstEffect(0.5, 0.42, 14, white)
    task.wait(0.12)

    local flash = Instance.new("Frame", introGui)
    flash.Size = UDim2.new(1, 0, 1, 0)
    flash.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    flash.BackgroundTransparency = 0
    flash.BorderSizePixel = 0
    flash.ZIndex = 18
    TS:Create(flash,
        TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = 1}
    ):Play()

    local t = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TS:Create(bgImg, t, {ImageTransparency = 1}):Play()
    TS:Create(fgImg, t, {ImageTransparency = 1}):Play()
    TS:Create(tapLbl, t, {TextTransparency = 1, TextStrokeTransparency = 1}):Play()

    task.delay(0.5, function()
        if _introSound then pcall(function() _introSound:Stop() end); pcall(function() _introSound:Destroy() end) end
        pcall(function() introGui:Destroy() end)
        showStealBar()
        showMobilePanel()
        showInstaResetButton()
        showTpBatButton()
        if miniBtn then miniBtn.Visible = true end
        task.delay(0.3, enhanceTabsWithWaterEffect)
    end)
end

tapCatcher.MouseButton1Click:Connect(finishIntro)

task.spawn(function()
    local amt = 4
    local spd = 0.07
    while introActive do
        local dx = math.random(-amt, amt)
        local dy = math.random(-amt, amt)
        TS:Create(bgHolder,
            TweenInfo.new(spd, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Position = UDim2.new(0.5, dx, 0.42, dy)}
        ):Play()
        task.wait(spd + 0.01)
    end
end)

task.spawn(function()
    while introActive do
        task.wait(math.random(8, 18) * 0.1)
        if not introActive then break end
        tapLbl.TextTransparency = 0.6
        task.wait(0.07)
        tapLbl.TextTransparency = 0
        task.wait(0.05)
        tapLbl.TextTransparency = 0.5
        task.wait(0.06)
        tapLbl.TextTransparency = 0
    end
end)

task.delay(14, finishIntro)

-- ============================================================

buildGui()

if loadAllSettings() then
    updateUIFromLoaded()
end

MobilePanel = createMobilePanel()
instaResetFloatingButton = createInstaResetFloatingButton()
tpBatFloatingButton = createTpBatFloatingButton()

hideStealBar()
hideMobilePanel()
hideInstaResetButton()
hideTpBatButton()
if miniBtn then miniBtn.Visible = false end
if main then main.Visible = false end

if LP.Character then
    task.wait(0.1)
    while not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") or not LP.Character:FindFirstChildOfClass("Humanoid") do
        task.wait()
    end
    setupMovementAndIndicators(LP.Character)
    if currentAnimPack ~= "Off" then
        startAnimPack(currentAnimPack)
    end
    if currentSkyTheme and currentSkyTheme ~= "None" then
        applyDriftSkyTheme(currentSkyTheme)
    end
end

LP.CharacterAdded:Connect(function(char)
    stopAutoSteal()
    stopAutoLeft()
    stopAutoRight()
    stopBatCounter()
    stopMedusaCounter()
    stopAutoTPDown()
    stopUnwalk()
    stopDropBrainrot()
    stopMedusaAutoReset()
    if autoBatEnabled then disableAutoBat() end
    if tpLockEnabled then stopTPLock() end
    if bodyLockEnabled then stopBodyLock() end

    task.wait(0.1)
    while not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") or not LP.Character:FindFirstChildOfClass("Humanoid") do
        task.wait()
    end

    setupMovementAndIndicators(char)

    if CONFIG.AUTO_STEAL_ENABLED then
        pcall(startAutoSteal)
    end

    if tpLockEnabled then
        task.defer(function() startTPLock() end)
    end
    if jumpEnabled then startJumpMode() end
    if antiRagdollEnabled then
        task.wait(0.5)
        startAntiRagdoll()
    end
    if bodyLockEnabled and _blSuppressCount == 0 then startBodyLock() end

    if medusaCounterEnabled then
        setupMedusa(char)
        if setMedusaVisual then setMedusaVisual(true) end
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
        stopMedusaAutoReset()
    elseif medusaAutoResetEnabled then
        setupMedusaAutoReset(char)
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(true) end
        if setMedusaVisual then setMedusaVisual(false) end
        stopMedusaCounter()
    else
        stopMedusaCounter()
        stopMedusaAutoReset()
        if setMedusaVisual then setMedusaVisual(false) end
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
    end

    if batCounterEnabled then startBatCounter() end
    if unwalkEnabled then startUnwalk() end
    if autoTPDownEnabled then startAutoTPDown() end

    if currentAnimPack ~= "Off" then
        task.wait(0.5)
        startAnimPack(currentAnimPack)
    end

    if currentSkyTheme and currentSkyTheme ~= "None" then
        applyDriftSkyTheme(currentSkyTheme)
    end

    updateProgressBarVisibility()
    refreshSpeedModeLabel()
end)

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
        if tick() - lastLaggerToggle >= LAGGER_COOLDOWN then
            lastLaggerToggle = tick()
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
    if kbMatch(KB.TPFloor, kc) then runTPFloor(); return end
    if kbMatch(KB.InstaReset, kc) then instaReset(); return end
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
    if kbMatch(KB.TPLock, kc) then
        toggleTPLock()
        return
    end
    if kbMatch(KB.JumpMode, kc) then
        if modeSelectBtn then
            local newMode = jumpMode == 1 and 2 or 1
            jumpMode = newMode
            modeSelectBtn.Text = jumpMode == 1 and "Tap Tap" or "Hold"
            if jumpEnabled then stopJumpMode(); startJumpMode() end
        end
        return
    end
    if kbMatch(KB.GuiHide, kc) then
        if main then
            if main.Visible then hideGui() else showGui() end
        end
        return
    end
end)

-- ============================================================
-- LIMPIEZA AL FINALIZAR
-- ============================================================
local function cleanup()
    stopAllBackgroundTasks()
    if stealBarGui then stealBarGui:Destroy() end
    if radUpdateConn then radUpdateConn:Disconnect() end
    if progressUpdateConn then progressUpdateConn:Disconnect() end
    stopShimmer()
end

game:GetService("RunService").Heartbeat:Connect(function()
    if not LP or not LP.PlayerGui then
        cleanup()
    end
end)