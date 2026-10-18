--[[
 SKM DUEL - Complete UI Overhaul
 - Renamed from s2y hub duels to SKM DUEL
 - Color theme changed to VIOLET/PURPLE
 - Removed AUTO GRAB and SKY tabs
 --]]

repeat task.wait() until game:IsLoaded()

do
 local Players = game:GetService("Players")
 local TweenService = game:GetService("TweenService")
 local CoreGui = game:GetService("CoreGui")
 local player = Players.LocalPlayer

-- 6 rotating songs
 local intros = {
 "https://files.catbox.moe/zuid5n.mp3",
 "https://files.catbox.moe/z6eqnt.mp3",
 "https://files.catbox.moe/t0nlhv.mp3",
 "https://files.catbox.moe/mthg31.mp3",
 "https://files.catbox.moe/ddnbup.mp3",
 "https://files.catbox.moe/hg5cr4.mp3",
 }

local indexFile = "SKMMusicIndex"
 local currentIndex = 1

pcall(function()
 if isfile and isfile(indexFile) then
 local saved = readfile(indexFile)
 local n = tonumber(saved)
 if n and n >= 1 and n <= #intros then
 currentIndex = n
 end
 end
 end)

local nextIndex = currentIndex % #intros + 1

pcall(function()
 if writefile then
 writefile(indexFile, tostring(nextIndex))
 end
 end)

local url = intros[currentIndex]
 print("[SKM DUEL] Playing song " .. currentIndex .. " of " .. #intros)

local songContent = game:HttpGet(url)
 writefile("SKMIntro_cache", songContent)

local INTRO_DURATION = 9

local blur = Instance.new("BlurEffect")
 blur.Size = 56
 blur.Parent = game:GetService("Lighting")

local introGui = Instance.new("ScreenGui")
 introGui.Name = "SKM DUEL Intro"
 introGui.ResetOnSpawn = false
 introGui.IgnoreGuiInset = true
 introGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
 introGui.Parent = CoreGui

-- Wave image (animated waves)
 local waveImage = Instance.new("ImageLabel", introGui)
 waveImage.Size = UDim2.new(0, 200, 0, 80)
 waveImage.Position = UDim2.new(0.5, -100, 0.3, -40)
 waveImage.BackgroundTransparency = 1
 waveImage.Image = "rbxassetid://6031098373"
 waveImage.ScaleType = Enum.ScaleType.Fit
 waveImage.ImageTransparency = 0.3
 waveImage.ZIndex = 105

-- Animate wave image
 local wavePulse1 = TweenService:Create(waveImage, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
 ImageTransparency = 0.1
 })
 wavePulse1:Play()

local wavePulse2 = TweenService:Create(waveImage, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
 Size = UDim2.new(0, 220, 0, 90)
 })
 wavePulse2:Play()

-- Wave text with emojis on both sides - VIOLET THEME
 local waveTag = Instance.new("TextLabel", introGui)
 waveTag.Size = UDim2.new(0, 450, 0, 80)
 waveTag.Position = UDim2.new(1, 50, 0.45, -40)
 waveTag.BackgroundTransparency = 1
 waveTag.Text = "SKM DUEL "
 waveTag.Font = Enum.Font.SourceSansBold
 waveTag.TextSize = 72
 waveTag.TextColor3 = Color3.fromRGB(160, 32, 240) -- VIOLET
 waveTag.TextStrokeColor3 = Color3.fromRGB(100, 0, 180)
 waveTag.TextStrokeTransparency = 0.0
 waveTag.TextXAlignment = Enum.TextXAlignment.Center
 waveTag.TextTransparency = 0
 waveTag.ZIndex = 110

-- .gg text - VIOLET
 local ggTag = Instance.new("TextLabel", introGui)
 ggTag.Size = UDim2.new(0, 200, 0, 60)
 ggTag.Position = UDim2.new(0, -250, 0.6, -30)
 ggTag.BackgroundTransparency = 1
 ggTag.Text = ""
 ggTag.Font = Enum.Font.SourceSansBold
 ggTag.TextSize = 56
 ggTag.TextColor3 = Color3.fromRGB(160, 32, 240)
 ggTag.TextStrokeColor3 = Color3.fromRGB(100, 0, 180)
 ggTag.TextStrokeTransparency = 0.2
 ggTag.TextXAlignment = Enum.TextXAlignment.Center
 ggTag.TextTransparency = 0
 ggTag.ZIndex = 110

-- Small wave decoration under text
 local waveDeco = Instance.new("ImageLabel", introGui)
 waveDeco.Size = UDim2.new(0, 300, 0, 20)
 waveDeco.Position = UDim2.new(0.5, -150, 0.7, -10)
 waveDeco.BackgroundTransparency = 1
 waveDeco.Image = "rbxassetid://6031098373"
 waveDeco.ScaleType = Enum.ScaleType.Fit
 waveDeco.ImageTransparency = 0.5
 waveDeco.ZIndex = 105

local waveDecoPulse = TweenService:Create(waveDeco, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
 ImageTransparency = 0.2,
 Size = UDim2.new(0, 320, 0, 25)
 })
 waveDecoPulse:Play()

local snd = Instance.new("Sound", game:GetService("SoundService"))
 snd.SoundId = getcustomasset("SKMIntro_cache")
 snd.Volume = 0.7
 snd.Looped = false
 snd:Play()

-- Animate SKM DUEL to center
 local waveTween = TweenService:Create(waveTag, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
 Position = UDim2.new(0.5, -225, 0.45, -40)
 })
 waveTween:Play()

-- Animate .duels to center
 local ggTween = TweenService:Create(ggTag, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
 Position = UDim2.new(0.5, -100, 0.6, -30)
 })
 ggTween:Play()

-- Fade in wave image
 task.wait(0.3)
 local waveFade = TweenService:Create(waveImage, TweenInfo.new(1, Enum.EasingStyle.Quad), {
 ImageTransparency = 0.3
 })
 waveFade:Play()

task.wait(1.2)
 local blinkActive = true
 local visible = true
 task.spawn(function()
 local startTime = tick()
 while blinkActive and (tick() - startTime) < (INTRO_DURATION - 1.5) do
 task.wait(0.15)
 visible = not visible
 waveTag.TextTransparency = visible and 0 or 1
 ggTag.TextTransparency = visible and 0 or 0.5
 waveDeco.ImageTransparency = visible and 0.5 or 0.8
 end
 end)

task.wait(INTRO_DURATION - 1.5)

blinkActive = false
 local fadeInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
 TweenService:Create(waveTag, fadeInfo, {TextTransparency = 1}):Play()
 TweenService:Create(ggTag, fadeInfo, {TextTransparency = 1}):Play()
 TweenService:Create(waveImage, fadeInfo, {ImageTransparency = 1}):Play()
 TweenService:Create(waveDeco, fadeInfo, {ImageTransparency = 1}):Play()
 TweenService:Create(snd, TweenInfo.new(0.6), {Volume = 0}):Play()
 TweenService:Create(blur, fadeInfo, {Size = 0}):Play()
 task.wait(0.7)

pcall(function() snd:Stop(); snd:Destroy() end)
 pcall(function() blur:Destroy() end)
 pcall(function() introGui:Destroy() end)
 end

-- ============================================================
 -- ZOMBIE ANIMATION
 -- ============================================================

local Players = game:GetService("Players")
 local RunService = game:GetService("RunService")
 local LP = Players.LocalPlayer

-- Zombie animation variables
 local zombieAnimTrack = nil
 local zombieAnimator = nil
 local isZombieActive = false

-- Zombie animation ID (classic zombie walk/limp)
 local ZOMBIE_ANIM_ID = "rbxassetid://14586863135" -- Zombie walk animation

local function applyZombieAnimation(character)
 if not character then return end

local humanoid = character:FindFirstChildOfClass("Humanoid")
 if not humanoid then return end

-- Stop any existing zombie animation
 if zombieAnimTrack then
 zombieAnimTrack:Stop()
 zombieAnimTrack = nil
 end

-- Get or create animator
 zombieAnimator = humanoid:FindFirstChildOfClass("Animator")
 if not zombieAnimator then
 zombieAnimator = Instance.new("Animator")
 zombieAnimator.Parent = humanoid
 end

-- Load and play zombie animation
 local zombieAnim = Instance.new("Animation")
 zombieAnim.AnimationId = ZOMBIE_ANIM_ID

zombieAnimTrack = zombieAnimator:LoadAnimation(zombieAnim)
 if zombieAnimTrack then
 zombieAnimTrack.Looped = true
 zombieAnimTrack.Priority = Enum.AnimationPriority.Core
 zombieAnimTrack:Play()
 isZombieActive = true
 print("[SKM DUEL] Zombie animation activated!")
 end
 end

local function removeZombieAnimation()
 if zombieAnimTrack then
 zombieAnimTrack:Stop()
 zombieAnimTrack = nil
 end
 isZombieActive = false
 end

-- Character added event
 LP.CharacterAdded:Connect(function(character)
 task.wait(0.5) -- Wait for character to fully load
 applyZombieAnimation(character)
 end)

-- Check if character already exists
 if LP.Character then
 task.wait(0.5)
 applyZombieAnimation(LP.Character)
 end

-- Keep zombie animation active on respawn
 LP.CharacterAdded:Connect(function()
 removeZombieAnimation()
 end)

print("[SKM DUEL] Zombie animation loaded - Ready!")

-- ============================================================
 -- AUTO GRAB GUI — beautiful "UNREADY / READY" floating pill
 -- VIOLET EDITION
 -- ============================================================

do
 local TS = game:GetService("TweenService")
 local UIS = game:GetService("UserInputService")

-- ============================================================
 -- MINIMAL STEAL STATE
 -- ============================================================
 local Steal = {
 AutoStealEnabled=false, StealRadius=55, StealDuration=0.2,
 Mode="half",
 HalfFireRange=10, HalfHoldMin=1.3, HalfHoldMax=2.6, HalfEntryDelay=0.3,
 Data={}
 }
 local isStealing = false
 local stealStartTime = nil
 local autoConn = nil
 local progressFill, progressPct

local function isMyPlotByName(plotName)
 local plots=workspace:FindFirstChild("Plots"); if not plots then return false end
 local plot=plots:FindFirstChild(plotName); if not plot then return false end
 local sign=plot:FindFirstChild("PlotSign")
 if sign then local yb=sign:FindFirstChild("YourBase"); if yb and yb:IsA("BillboardGui") then return yb.Enabled==true end end
 return false
 end

local function findNearestPrompt()
 local char=LP.Character; if not char then return nil end
 local root=char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
 if not root then return nil end
 local plots=workspace:FindFirstChild("Plots"); if not plots then return nil end
 local nearest,dist=nil,math.huge
 for _,plot in ipairs(plots:GetChildren()) do
 if plot:IsA("Model") and not isMyPlotByName(plot.Name) then
 local pods=plot:FindFirstChild("AnimalPodiums")
 if pods then
 for _,pod in ipairs(pods:GetChildren()) do
 local base=pod:FindFirstChild("Base")
 local sp=base and base:FindFirstChild("Spawn")
 if sp then
 local d=(sp.Position-root.Position).Magnitude
 if d<=Steal.StealRadius and d<dist then
 local found=nil
 local att=sp:FindFirstChild("PromptAttachment")
 if att then for _,pr in ipairs(att:GetChildren()) do if pr:IsA("ProximityPrompt") and pr.ActionText and pr.ActionText:find("Steal") then found=pr end end end
 if not found then for _,pr in ipairs(sp:GetDescendants()) do if pr:IsA("ProximityPrompt") and pr.ActionText and pr.ActionText:find("Steal") then found=pr end end end
 if found then nearest,dist=found,d end
 end
 end
 end
 end
 end
 end
 return nearest
 end

local function _promptDist(prompt)
 local char=LP.Character; if not char then return math.huge end
 local root=char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
 if not root then return math.huge end
 local part=prompt.Parent
 if part and part:IsA("Attachment") then part=part.Parent end
 if part and part:IsA("BasePart") then return (part.Position-root.Position).Magnitude end
 local ok,cf=pcall(function() return prompt.Parent and prompt.Parent.WorldPosition end)
 if ok and cf then return (cf-root.Position).Magnitude end
 return math.huge
 end

local function executeSteal(prompt)
 if isStealing then return end
 if not Steal.Data[prompt] then
 Steal.Data[prompt]={hold={},trigger={},ready=true}
 if getconnections then
 for _,c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do if c.Function then table.insert(Steal.Data[prompt].hold,c.Function) end end
 for _,c in ipairs(getconnections(prompt.Triggered)) do if c.Function then table.insert(Steal.Data[prompt].trigger,c.Function) end end
 end
 end
 local data=Steal.Data[prompt]; if not data.ready then return end
 data.ready=false; isStealing=true; stealStartTime=tick()
 if Steal.Mode=="half" then
 task.spawn(function()
 for _,fn in ipairs(data.hold) do task.spawn(fn) end
 task.wait(Steal.HalfHoldMin)
 local inRange=_promptDist(prompt)<=Steal.HalfFireRange
 while true do
 local el=tick()-stealStartTime
 if el>Steal.HalfHoldMax or not prompt.Parent then break end
 if _promptDist(prompt)<=Steal.HalfFireRange then
 if not inRange then task.wait(Steal.HalfEntryDelay) end
 for _,fn in ipairs(data.trigger) do task.spawn(fn) end; break
 end
 task.wait()
 end
 task.wait(0.05); data.ready=true; isStealing=false
 end)
 else
 task.spawn(function()
 for _,fn in ipairs(data.hold) do task.spawn(fn) end
 local el=0; while el<Steal.StealDuration do el=el+task.wait() end
 for _,fn in ipairs(data.trigger) do task.spawn(fn) end
 task.wait(0.05); data.ready=true; isStealing=false
 end)
 end
 end

local function startAutoSteal()
 if autoConn then return end
 autoConn=RunService.Heartbeat:Connect(function()
 if not Steal.AutoStealEnabled or isStealing then return end
 local p=findNearestPrompt(); if p then executeSteal(p) end
 end)
 end

local function stopAutoSteal()
 if autoConn then autoConn:Disconnect(); autoConn=nil end
 isStealing=false
 end

_G.AutoSteal = Steal

-- ============================================================
 -- BEAUTIFIED GUI with VIOLET theme
 -- ============================================================
 local _oldSPG = LP.PlayerGui:FindFirstChild("StealProgressScreenGui")
 if _oldSPG then _oldSPG:Destroy() end
 local spScreenGui=Instance.new("ScreenGui")
 spScreenGui.Name="StealProgressScreenGui";spScreenGui.ResetOnSpawn=false
 spScreenGui.DisplayOrder=200;spScreenGui.IgnoreGuiInset=true
 spScreenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
 spScreenGui.Parent=LP.PlayerGui

-- Main frame – transparent to show background image
 local spFrame=Instance.new("Frame",spScreenGui)
 spFrame.Name="StealProgressGui"
 spFrame.Size=UDim2.new(0,320,0,24)
 spFrame.Position=UDim2.new(0.5,0,1,-90)
 spFrame.AnchorPoint=Vector2.new(0.5,1)
 spFrame.BackgroundTransparency=1
 spFrame.BorderSizePixel=0;spFrame.Active=true;spFrame.Visible=true
 spFrame.ZIndex=300;spFrame.ClipsDescendants=true
 Instance.new("UICorner",spFrame).CornerRadius=UDim.new(1,0)

-- Shadow (glow) behind the pill - VIOLET tinted
 local shadow=Instance.new("Frame",spScreenGui)
 shadow.Name="PillShadow"
 shadow.Size=UDim2.new(0,330,0,30)
 shadow.Position=UDim2.new(0.5,0,1,-87)
 shadow.AnchorPoint=Vector2.new(0.5,1)
 shadow.BackgroundColor3=Color3.fromRGB(160, 32, 240) -- VIOLET
 shadow.BackgroundTransparency=0.85
 shadow.BorderSizePixel=0
 shadow.ZIndex=299
 local shadowCorner=Instance.new("UICorner",shadow)
 shadowCorner.CornerRadius=UDim.new(1,0)
 local shadowBlur=Instance.new("BlurEffect",shadow)
 shadowBlur.Size=10
 shadow.ClipsDescendants=true

-- Background image (the entire pill background) - VIOLET theme
 local bgImage=Instance.new("ImageLabel",spFrame)
 bgImage.Name="BgImage"
 bgImage.Size=UDim2.new(1,0,1,0)
 bgImage.Position=UDim2.new(0,0,0,0)
 bgImage.BackgroundTransparency=1
 bgImage.Image="rbxassetid://115292342024385"
 bgImage.ZIndex=300
 bgImage.ScaleType=Enum.ScaleType.Slice
 bgImage.ImageColor3=Color3.fromRGB(120, 20, 180)
 bgImage.SliceCenter=Rect.new(4,4,4,4)

-- Outer border with glow effect - VIOLET
 local border=Instance.new("UIStroke",spFrame)
 border.Color=Color3.fromRGB(160, 32, 240)
 border.Thickness=2.5
 border.Transparency=0.1
 border.ApplyStrokeMode=Enum.ApplyStrokeMode.Border

-- Inner glassy overlay (shine effect – moving) - VIOLET tinted
 local shine=Instance.new("Frame",spFrame)
 shine.Name="Shine"
 shine.Size=UDim2.new(0.5,0,1,0)
 shine.Position=UDim2.new(-0.5,0,0,0)
 shine.BackgroundColor3=Color3.fromRGB(160, 32, 240)
 shine.BackgroundTransparency=0.7
 shine.BorderSizePixel=0
 shine.ZIndex=302
 shine.ClipsDescendants=true
 local shineCorner=Instance.new("UICorner",shine)
 shineCorner.CornerRadius=UDim.new(1,0)
 -- Animate shine from left to right continuously
 task.spawn(function()
 while true do
 shine.Position=UDim2.new(-0.5,0,0,0)
 TS:Create(shine,TweenInfo.new(1.2,Enum.EasingStyle.Linear),{Position=UDim2.new(1.5,0,0,0)}):Play()
 task.wait(1.2)
 end
 end)

-- Progress fill – violet gradient
 local spFill=Instance.new("Frame",spFrame)
 spFill.Name="ProgressFill"
 spFill.Size=UDim2.new(0,0,1,-6)
 spFill.Position=UDim2.new(0,3,0,3)
 spFill.BackgroundColor3=Color3.fromRGB(150, 20, 200)
 spFill.BackgroundTransparency=0
 spFill.BorderSizePixel=0
 spFill.ZIndex=301
 spFill.ClipsDescendants=true
 local fillCorner=Instance.new("UICorner",spFill)
 fillCorner.CornerRadius=UDim.new(1,0)
 -- Gradient: dark violet to bright violet
 local gradient=Instance.new("UIGradient",spFill)
 gradient.Color=ColorSequence.new{
 ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 0, 80)),
 ColorSequenceKeypoint.new(0.4, Color3.fromRGB(150, 20, 200)),
 ColorSequenceKeypoint.new(0.7, Color3.fromRGB(200, 50, 255)),
 ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 100, 255))
 }
 gradient.Rotation=90

-- Text label with shadow - VIOLET theme
 local spPct=Instance.new("TextLabel",spFrame)
 spPct.Size=UDim2.new(1,-28,1,0)
 spPct.Position=UDim2.new(0,14,0,0)
 spPct.BackgroundTransparency=1
 spPct.Text="UNREADY"
 spPct.TextColor3=Color3.fromRGB(255,255,255)
 spPct.Font=Enum.Font.GothamBold
 spPct.TextSize=14
 spPct.TextStrokeTransparency=0.3
 spPct.TextStrokeColor3=Color3.fromRGB(120, 20, 180)
 spPct.TextXAlignment=Enum.TextXAlignment.Center
 spPct.TextYAlignment=Enum.TextYAlignment.Center
 spPct.ZIndex=304
 -- Add a subtle glow to text (duplicate behind)
 local textShadow=spPct:Clone()
 textShadow.Name="TextShadow"
 textShadow.Parent=spFrame
 textShadow.TextColor3=Color3.fromRGB(0,0,0)
 textShadow.TextStrokeTransparency=1
 textShadow.TextTransparency=0.8
 textShadow.ZIndex=303
 textShadow.Position=UDim2.new(0,14,0,1)

progressFill=spFill
 progressPct=spPct

-- Toggle button (invisible, covers whole pill)
 local spToggleBtn=Instance.new("TextButton",spFrame)
 spToggleBtn.Name="ToggleGUIBtn"
 spToggleBtn.Size=UDim2.new(1,0,1,0)
 spToggleBtn.BackgroundTransparency=1
 spToggleBtn.Text=""
 spToggleBtn.AutoButtonColor=false
 spToggleBtn.ZIndex=310
 local _spWasDragged=false
 spToggleBtn.Activated:Connect(function()
 if _spWasDragged then return end
 local base=spFrame.Size
 TS:Create(spFrame,TweenInfo.new(0.08),{Size=UDim2.new(base.X.Scale,base.X.Offset0.95,base.Y.Scale,base.Y.Offset0.9)}):Play()
 task.delay(0.1,function() TS:Create(spFrame,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Size=base}):Play() end)
 end)

-- drive fill/label with smooth lerp, fill completes in 0.2 sec
 local FILL_DURATION = 0.2
 local _lastPct=0
 RunService.RenderStepped:Connect(function()
 if not spFrame.Visible then return end
 local pct=0
 if isStealing and stealStartTime then
 pct=math.clamp((tick()-stealStartTime)/FILL_DURATION,0,1)
 elseif Steal.AutoStealEnabled then
 pct=(findNearestPrompt() and 1 or 0)
 end
 _lastPct=_lastPct+(pct-_lastPct)0.2
 local f=math.clamp(_lastPct,0,1)
 spFill.Size=UDim2.new(f,-6f,1,-6)
 if _lastPct>=0.87 then
 spPct.Text="READY"
 spPct.TextColor3=Color3.fromRGB(120,255,140)
 textShadow.TextColor3=Color3.fromRGB(0,0,0)
 -- Glow pulse when ready
 TS:Create(spFill,TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,1,true),{
 BackgroundColor3 = Color3.fromRGB(0,255,50)
 }):Play()
 else
 spPct.Text="UNREADY"
 spPct.TextColor3=Color3.fromRGB(255,255,255)
 textShadow.TextColor3=Color3.fromRGB(0,0,0)
 end
 end)

-- drag handling with off-screen clamp
 local dragging,dragStart,startPos=false,nil,nil
 spToggleBtn.InputBegan:Connect(function(inp)
 if inp.UserInputTypeEnum.UserInputType.MouseButton1 or inp.UserInputTypeEnum.UserInputType.Touch then
 dragging=true;_spWasDragged=false;dragStart=inp.Position;startPos=spFrame.Position
 inp.Changed:Connect(function() if inp.UserInputStateEnum.UserInputState.End then dragging=false end end)
 end
 end)
 UIS.InputChanged:Connect(function(inp)
 if not dragging then return end
 if inp.UserInputTypeEnum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then
 local dx=inp.Position.X-dragStart.X
 local dy=inp.Position.Y-dragStart.Y
 if math.abs(dx)>5 or math.abs(dy)>5 then _spWasDragged=true end
 local cam=workspace.CurrentCamera
 local vp=cam and cam.ViewportSize or Vector2.new(1000,1000)
 local sz=spFrame.AbsoluteSize
 local newXScalePx=startPos.X.Scalevp.X
 local newX=math.clamp(newXScalePx+startPos.X.Offset+dx,sz.X/2,vp.X-sz.X/2)
 local newY=math.clamp(startPos.Y.Scalevp.Y+startPos.Y.Offset+dy,sz.Y,vp.Y)
 spFrame.Position=UDim2.new(startPos.X.Scale,newX-newXScalePx,startPos.Y.Scale,newY-startPos.Y.Scale*vp.Y)
 -- move shadow with it
 shadow.Position=UDim2.new(spFrame.Position.X.Scale,spFrame.Position.X.Offset,spFrame.Position.Y.Scale,spFrame.Position.Y.Offset+3)
 end
 end)
 -- Sync shadow position on any move
 local function updateShadow()
 shadow.Position=UDim2.new(spFrame.Position.X.Scale,spFrame.Position.X.Offset,spFrame.Position.Y.Scale,spFrame.Position.Y.Offset+3)
 end
 spFrame:GetPropertyChangedSignal("Position"):Connect(updateShadow)
 updateShadow()

_G._CursedSetProgressBarVisible=function(v) spFrame.Visible=v; shadow.Visible=v end

-- half autograb always on
 Steal.AutoStealEnabled=true
 pcall(startAutoSteal)

-- ============================================================
 -- ANTI‑DIE — ALWAYS ENABLED
 -- ============================================================
 do
 local Workspace = game:GetService("Workspace")
 local connections = {}

local function enableAntiDie()
 local char = LP.Character
 if not char then return end
 local hum = char:FindFirstChildOfClass("Humanoid")
 if not hum then return end

local healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
 if hum.Health <= 0 then
 hum.Health = hum.MaxHealth
 end
 end)
 table.insert(connections, healthConn)

local diedConn = hum.Died:Connect(function()
 task.wait()
 pcall(function()
 local newHum = Instance.new("Humanoid")
 newHum.Name = "Humanoid"
 newHum.Parent = char
 if Workspace.CurrentCamera then
 Workspace.CurrentCamera.CameraSubject = newHum
 end
 hum:Destroy()
 end)
 end)
 table.insert(connections, diedConn)
 end

local function setup()
 for _, conn in pairs(connections) do
 pcall(conn.Disconnect, conn)
 end
 connections = {}
 enableAntiDie()
 end

setup()
 LP.CharacterAdded:Connect(function()
 task.wait(0.1)
 setup()
 end)
 end

print("[SKM DUEL] Auto Grab GUI loaded - VIOLET EDITION")
 end

-- ============================================================
 -- SKM DUEL (Violet & Dark Edition)
 -- ============================================================

local Players = game:GetService("Players")
 local RunService = game:GetService("RunService")
 local UIS = game:GetService("UserInputService")
 local TweenService = game:GetService("TweenService")
 local HttpService = game:GetService("HttpService")
 local ContentProvider = game:GetService("ContentProvider")
 local Stats = game:GetService("Stats")
 local Lighting = game:GetService("Lighting")
 local LP = Players.LocalPlayer

local LOGO_ID = "rbxassetid://96255128725816"
 task.spawn(function() pcall(function() ContentProvider:PreloadAsync({LOGO_ID}) end) end)

local _isfile = isfile or (syn and syn.isfile) or (getgenv and getgenv().isfile) or function() return false end
 local _readfile = readfile or (syn and syn.readfile) or (getgenv and getgenv().readfile) or function() return nil end
 local _writefile= writefile or (syn and syn.writefile) or (getgenv and getgenv().writefile) or function() end
 local getconnections = getconnections or get_signal_cons or getconnects or (syn and syn.get_signal_cons)

-- ============================================================
 -- STATE
 -- ============================================================
 local State = {
 normalSpeed=60, carrySpeed=30, laggerSpeed=10.1,
 speedToggled=false, laggerEnabled=false,
 infJumpEnabled=false, antiRagdollEnabled=false, fpsBoostEnabled=false,
 guiVisible=false, uiLocked=false,
 isStealing=false, stealStartTime=nil, lastStealTick=0,
 autoLeftEnabled=false, autoRightEnabled=false,
 autoLeftPhase=1, autoRightPhase=1,
 medusaLastUsed=0, medusaDebounce=false, medusaCounterEnabled=false,
 batAimbotToggled=false, autoSwingEnabled=true,
 hittingCooldown=false,
 batCounterEnabled=false, batCounterDebounce=false,
 dropEnabled=false, _tpInProgress=false,
 lastMoveDir=Vector3.new(0,0,0),
 unwalkEnabled=false, fovBoostEnabled=false, stackButtonsHidden=false, dragButtonsEnabled=false,
 _prevCarry=30, _prevSpeed=false,
 separateButtonMovement=false,
 }

local Keys = {
 speed=Enum.KeyCode.Q, guiHide=Enum.KeyCode.LeftControl,
 autoLeft=Enum.KeyCode.L, autoRight=Enum.KeyCode.R,
 lagger=Enum.KeyCode.Unknown, tpDown=Enum.KeyCode.Unknown,
 drop=Enum.KeyCode.H, aimbot=Enum.KeyCode.Unknown,
 }

-- ============================================================
 -- DEFAULT STACK BUTTON POSITIONS
 -- ============================================================
 local BTN_W=58; local BTN_H=58; local BTN_GAP=6; local COLS=2
 local stackDefs = {
 {key="aimbot", label="AUTO\nBAT"},
 {key="carrySpeed", label="CARRY\nSPD"},
 {key="autoLeft", label="AUTO\nLEFT"},
 {key="autoRight", label="AUTO\nRIGHT"},
 {key="drop", label="DROP\nBR"},
 {key="lagger", label="LAGGER\nMODE"},
 {key="tpDown", label="TP\nDOWN"},
 {key="laggerCarry",label="LAGGER\nCARRY"},
 }
 local GRID_W=COLS*(BTN_W+BTN_GAP)-BTN_GAP
 local GRID_H=math.ceil(#stackDefs/COLS)*(BTN_H+BTN_GAP)-BTN_GAP

local function getDefaultStackPos(i)
 local col=(i-1)%COLS
 local row2=math.floor((i-1)/COLS)
 return UDim2.new(1,-(GRID_W+10)+col*(BTN_W+BTN_GAP),0.5,-(GRID_H/2)+row2*(BTN_H+BTN_GAP))
 end

local Steal = {
 AutoStealEnabled=false, StealRadius=20, StealDuration=0.25,
 Data={}, plotCache={}, plotCacheTime={}, cachedPrompts={}, promptCacheTime=0,
 }

-- ============================================================
 -- STEAL PROGRESS BAR ON PLAYER HEAD
 -- ============================================================
 local stealProgressBar = nil
 local stealProgressGui = nil

local function createStealProgressBar()
 if stealProgressGui then return end

stealProgressGui = Instance.new("BillboardGui")
 stealProgressGui.Name = "StealProgressBar"
 stealProgressGui.Size = UDim2.new(0, 150, 0, 20)
 stealProgressGui.StudsOffset = Vector3.new(0, 3.5, 0)
 stealProgressGui.AlwaysOnTop = true
 stealProgressGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
 stealProgressGui.ResetOnSpawn = false

-- Background frame
 local bg = Instance.new("Frame", stealProgressGui)
 bg.Name = "Background"
 bg.Size = UDim2.new(1, 0, 1, 0)
 bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
 bg.BackgroundTransparency = 0.5
 bg.BorderSizePixel = 0
 local bgCorner = Instance.new("UICorner", bg)
 bgCorner.CornerRadius = UDim.new(0, 4)

-- Progress fill frame - VIOLET
 local fill = Instance.new("Frame", stealProgressGui)
 fill.Name = "Fill"
 fill.Size = UDim2.new(0, 0, 1, 0)
 fill.BackgroundColor3 = Color3.fromRGB(160, 32, 240)
 fill.BackgroundTransparency = 0
 fill.BorderSizePixel = 0
 local fillCorner = Instance.new("UICorner", fill)
 fillCorner.CornerRadius = UDim.new(0, 4)

-- Percentage text
 local text = Instance.new("TextLabel", stealProgressGui)
 text.Name = "Percentage"
 text.Size = UDim2.new(1, 0, 1, 0)
 text.BackgroundTransparency = 1
 text.Text = "0%"
 text.TextColor3 = Color3.fromRGB(255, 255, 255)
 text.Font = Enum.Font.GothamBold
 text.TextSize = 10
 text.TextStrokeTransparency = 0.5
 text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

stealProgressBar = {bg = bg, fill = fill, text = text}
 end

local function updateStealProgress(progress)
 if not stealProgressBar then return end
 local prog = math.clamp(progress, 0, 1)
 stealProgressBar.fill.Size = UDim2.new(prog, 0, 1, 0)
 stealProgressBar.text.Text = math.floor(prog * 100) .. "%"

-- Change color based on progress - VIOLET shades
 if prog >= 0.8 then
 stealProgressBar.fill.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
 elseif prog >= 0.5 then
 stealProgressBar.fill.BackgroundColor3 = Color3.fromRGB(160, 32, 240)
 else
 stealProgressBar.fill.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
 end
 end

local function showStealProgressBar()
 if not stealProgressGui then
 createStealProgressBar()
 end

local char = LP.Character
 if char and char:FindFirstChild("Head") then
 if stealProgressGui.Parent ~= char.Head then
 stealProgressGui.Parent = char.Head
 end
 stealProgressGui.Enabled = true
 end
 end

local function hideStealProgressBar()
 if stealProgressGui then
 stealProgressGui.Enabled = false
 if stealProgressBar then
 updateStealProgress(0)
 end
 end
 end

-- ============================================================
 -- PRESETS
 -- ============================================================
 local Presets = {}
 local PRESET_FILE = "SKM Presets.json"
 local LAST_PRESET_FILE = "SKM LastPreset.json"
 local CONFIG_FILE = "SKM Config.json"

local function buildPresetSnapshot()
 return {
 normalSpeed = State.normalSpeed,
 carrySpeed = State.carrySpeed,
 laggerSpeed = State.laggerSpeed,
 stealRadius = Steal.StealRadius,
 stealDuration = Steal.StealDuration,
 infJump = State.infJumpEnabled,
 antiRagdoll = State.antiRagdollEnabled,
 fpsBoost = State.fpsBoostEnabled,
 medusaCounter = State.medusaCounterEnabled,
 batCounter = State.batCounterEnabled,
 autoSteal = Steal.AutoStealEnabled,
 }
 end

local function savePresetsFile()
 local ok,encoded=pcall(function() return HttpService:JSONEncode(Presets) end)
 if ok then pcall(function() _writefile(PRESET_FILE,encoded) end) end
 end

local function loadPresetsFile()
 local hasFile=false; pcall(function() hasFile=_isfile(PRESET_FILE) end)
 if not hasFile then return end
 local raw; pcall(function() raw=_readfile(PRESET_FILE) end)
 if not raw then return end
 local ok,decoded=pcall(function() return HttpService:JSONDecode(raw) end)
 if ok and decoded then Presets=decoded end
 end

local function saveLastPresetName(name)
 local ok, encoded = pcall(function() return HttpService:JSONEncode({lastPreset=name}) end)
 if ok then pcall(function() _writefile(LAST_PRESET_FILE, encoded) end) end
 end

local function loadLastPresetName()
 local hasFile = false; pcall(function() hasFile = _isfile(LAST_PRESET_FILE) end)
 if not hasFile then return nil end
 local raw; pcall(function() raw = _readfile(LAST_PRESET_FILE) end)
 if not raw then return nil end
 local ok, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
 if ok and decoded then return decoded.lastPreset end
 return nil
 end

local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
 [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}

local PLOT_CACHE_DURATION=2; local PROMPT_CACHE_REFRESH=0.15
 local STEAL_COOLDOWN=0.1; local MEDUSA_COOLDOWN=25; local DROP_AUTO_OFF_DELAY=0.15

local POS={
 L1=Vector3.new(-476.48,-6.28,92.73), L2=Vector3.new(-483.12,-4.95,94.80),
 L_FACE=Vector3.new(-482.25,-4.96,92.09),
 R1=Vector3.new(-476.16,-6.52,25.62), R2=Vector3.new(-483.06,-5.03,25.48),
 R_FACE=Vector3.new(-482.06,-6.93,35.47),
 }

local Conns={autoSteal=nil,antiRag=nil,autoLeft=nil,autoRight=nil,aimbot=nil,anchor={},progress=nil,batCounter=nil,unwalk=nil}

local h,hrp
 local setAutoLeft,setAutoRight,setInfJump,setAntiRag,setFps
 local setMedusaCounter,setUnwalkToggle,setAimbot,setAutoSwing
 local setLagger,setDropBrainrot,setInstaGrab,setFovBoost
 local fovBoostConn = nil
 local function enableFovBoost()
 workspace.CurrentCamera.FieldOfView = 120
 if fovBoostConn then fovBoostConn:Disconnect() end
 fovBoostConn = RunService.RenderStepped:Connect(function()
 if not State.fovBoostEnabled then fovBoostConn:Disconnect(); fovBoostConn = nil; return end
 workspace.CurrentCamera.FieldOfView = 120
 end)
 end
 local function disableFovBoost()
 State.fovBoostEnabled = false
 if fovBoostConn then fovBoostConn:Disconnect(); fovBoostConn = nil end
 workspace.CurrentCamera.FieldOfView = 70
 end
 local setupMedusaCounter,stopMedusaCounter,startAntiRagdoll,stopAntiRagdoll
 local applyFPSBoost,startAutoSteal,stopAutoSteal
 local startAutoLeft,stopAutoLeft,startAutoRight,stopAutoRight
 local saveConfig,loadConfig,runDropBrainrot,stopDropBrainrot,doTpDown
 local startBatAimbot,stopBatAimbot,startBatCounter,stopBatCounter,setBatCounter
 local stackBtnRefs={}; local stackWrappers={}; local keybindBtnRefs={}
 local normalBox,carryBox,laggerBox,uiScaleBox,stealRadBox,lockBtn
 local setHideButtonsToggle
 local radTB

local presetListFrame=nil
 local presetNameBox=nil
 local rebuildPresetList

-- ============================================================
 -- COLORS (Violet & Dark)
 -- ============================================================
 local C = {
 winBg = Color3.fromRGB(0, 0, 0),
 winBorder = Color3.fromRGB(160, 32, 240),
 topBg = Color3.fromRGB(0, 0, 0),
 topTitle = Color3.fromRGB(255, 255, 255),
 topSub = Color3.fromRGB(160, 32, 240),
 topBtn = Color3.fromRGB(80, 0, 120),
 topBtnHov = Color3.fromRGB(160, 32, 240),
 topDivider = Color3.fromRGB(80, 0, 120),
 tabBarBg = Color3.fromRGB(0, 0, 0),
 tabBarDiv = Color3.fromRGB(80, 0, 120),
 tabIdle = Color3.fromRGB(160, 32, 240),
 tabActive = Color3.fromRGB(255, 255, 255),
 tabActiveBg = Color3.fromRGB(120, 20, 180),
 tabUnderline= Color3.fromRGB(160, 32, 240),
 sectionTxt = Color3.fromRGB(160, 32, 240),
 sectionDiv = Color3.fromRGB(80, 0, 120),
 rowBg = Color3.fromRGB(10, 10, 10),
 rowBorder = Color3.fromRGB(80, 0, 120),
 rowLabel = Color3.fromRGB(220, 230, 255),
 rowSub = Color3.fromRGB(160, 32, 240),
 rowValue = Color3.fromRGB(200, 100, 255),
 rowHov = Color3.fromRGB(60, 20, 80),
 inputBg = Color3.fromRGB(20, 20, 20),
 inputBorder = Color3.fromRGB(80, 0, 120),
 inputFocus = Color3.fromRGB(160, 32, 240),
 inputTxt = Color3.fromRGB(220, 230, 255),
 pillOff = Color3.fromRGB(40, 40, 40),
 pillOn = Color3.fromRGB(120, 20, 180),
 dotOff = Color3.fromRGB(80, 80, 80),
 dotOn = Color3.fromRGB(255, 255, 255),
 pillBorder = Color3.fromRGB(160, 32, 240),
 modeBtnBg = Color3.fromRGB(15, 15, 15),
 modeBtnBrd = Color3.fromRGB(80, 0, 120),
 modeBtnTxt = Color3.fromRGB(160, 32, 240),
 modeBtnActBg= Color3.fromRGB(120, 20, 180),
 modeBtnActTx= Color3.fromRGB(255, 255, 255),
 chipBg = Color3.fromRGB(15, 15, 15),
 chipBorder = Color3.fromRGB(80, 0, 120),
 chipTxt = Color3.fromRGB(160, 32, 240),
 btnBg = Color3.fromRGB(120, 20, 180),
 btnBorder = Color3.fromRGB(160, 32, 240),
 btnTxt = Color3.fromRGB(255, 255, 255),
 btnHov = Color3.fromRGB(160, 32, 240),
 stackBg = Color3.fromRGB(0, 0, 0),
 stackBrd = Color3.fromRGB(80, 0, 120),
 stackTxt = Color3.fromRGB(160, 32, 240),
 stackActBg = Color3.fromRGB(120, 20, 180),
 stackActBrd = Color3.fromRGB(160, 32, 240),
 stackActTxt = Color3.fromRGB(255, 255, 255),
 stackDot = Color3.fromRGB(60, 60, 60),
 stackDotOn = Color3.fromRGB(160, 32, 240),
 infoBg = Color3.fromRGB(0, 0, 0),
 infoBrd = Color3.fromRGB(80, 0, 120),
 infoTxt = Color3.fromRGB(160, 32, 240),
 infoVal = Color3.fromRGB(220, 230, 255),
 infoFill = Color3.fromRGB(160, 32, 240),
 accent = Color3.fromRGB(80, 0, 120),
 accentDim = Color3.fromRGB(120, 20, 180),
 presetBg = Color3.fromRGB(10, 10, 10),
 presetBrd = Color3.fromRGB(80, 0, 120),
 presetLoad = Color3.fromRGB(120, 20, 180),
 presetDel = Color3.fromRGB(40, 20, 40),
 delBrd = Color3.fromRGB(70, 40, 70),
 lockOn = Color3.fromRGB(255, 255, 255),
 divider = Color3.fromRGB(80, 0, 120),
 }

-- ============================================================
 -- CLEANUP
 -- ============================================================
 for _,name in pairs({"VyseSlottedGUI","VyseAsireGUI","VyseAsireHubV4","VyseAsireHubV5","VyseAsireHubV5_1","AsireHubV5_1","AsireHubV5_2","J5HubV5_2","J5HubV5_3","BloomHub", "Wavecc", "Yosemite", "s2y hub duels", "SKM DUEL"}) do
 pcall(function() local o=game:GetService("CoreGui"):FindFirstChild(name); if o then o:Destroy() end end)
 pcall(function() local o=LP:WaitForChild("PlayerGui"):FindFirstChild(name); if o then o:Destroy() end end)
 end

-- ============================================================
 -- ROOT GUI
 -- ============================================================
 local gui=Instance.new("ScreenGui")
 gui.Name="SKM DUEL"; gui.ResetOnSpawn=false; gui.DisplayOrder=10
 gui.IgnoreGuiInset=true; gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
 gui.Parent=LP:WaitForChild("PlayerGui")

local uiScaleObj=Instance.new("UIScale",gui); uiScaleObj.Scale=1.0

-- ============================================================
 -- HELPERS
 -- ============================================================
 local function mkCorner(p,r) local c=Instance.new("UICorner",p); c.CornerRadius=UDim.new(0,r or 8); return c end
 local function mkStroke(p,col,th)
 local s=Instance.new("UIStroke",p); s.Color=col; s.Thickness=th or 1
 s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; return s
 end
 local function mkPad(p,t,b,l,r)
 local pd=Instance.new("UIPadding",p)
 pd.PaddingTop=UDim.new(0,t or 0); pd.PaddingBottom=UDim.new(0,b or 0)
 pd.PaddingLeft=UDim.new(0,l or 0); pd.PaddingRight=UDim.new(0,r or 0)
 return pd
 end

-- ============================================================
 -- DRAG
 -- ============================================================
 local function makeDraggable(frame,handle)
 local src=handle or frame
 local dragging,dragInput,dragStart,startPos,dragMoved=false,nil,nil,nil,false
 src.InputBegan:Connect(function(inp)
 if State.uiLocked then return end
 if inp.UserInputTypeEnum.UserInputType.MouseButton1 or inp.UserInputTypeEnum.UserInputType.Touch then
 dragging=true; dragMoved=false; dragStart=inp.Position; startPos=frame.Position
 inp.Changed:Connect(function() if inp.UserInputStateEnum.UserInputState.End then dragging=false; dragMoved=false end end)
 end
 end)
 src.InputChanged:Connect(function(inp)
 if inp.UserInputTypeEnum.UserInputType.MouseMovement or inp.UserInputTypeEnum.UserInputType.Touch then dragInput=inp end
 end)
 UIS.InputChanged:Connect(function(inp)
 if inpdragInput and dragging and not State.uiLocked then
 local dx=inp.Position.X-dragStart.X; local dy=inp.Position.Y-dragStart.Y
 if not dragMoved and (math.abs(dx)<10 and math.abs(dy)<10) then return end
 dragMoved=true
 frame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+dx,startPos.Y.Scale,startPos.Y.Offset+dy)
 end
 end)
 end

local function makeStackDraggable(frame,onTap)
 local dragging,dragInput,dragStart,startPos=false,nil,nil,nil; local moved=false
 frame.InputBegan:Connect(function(inp)
 if inp.UserInputType~=Enum.UserInputType.MouseButton1 and inp.UserInputType~=Enum.UserInputType.Touch then return end
 dragging=true; moved=false; dragStart=inp.Position; startPos=frame.Position
 inp.Changed:Connect(function()
 if inp.UserInputStateEnum.UserInputState.End then
 dragging=false; moved=false
 end
 end)
 end)
 frame.InputChanged:Connect(function(inp)
 if inp.UserInputTypeEnum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then dragInput=inp end
 end)
 UIS.InputChanged:Connect(function(inp)
 if inp~=dragInput or not dragging then return end
 local dx=inp.Position.X-dragStart.X; local dy=inp.Position.Y-dragStart.Y
 if not State.separateButtonMovement then
 moved = false
 return
 end
 if math.abs(dx)>10 or math.abs(dy)>10 then moved=true end
 if moved and not State.uiLocked then
 frame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+dx,startPos.Y.Scale,startPos.Y.Offset+dy)
 end
 end)
 end

-- ============================================================
 -- MAIN WINDOW (Rounded corners, side tabs)
 -- ============================================================
 local WIN_W = 340
 local WIN_H = 420
 local TITLE_H = 52
 local SIDE_TAB_W = 70

local mainOuter = Instance.new("Frame", gui)
 mainOuter.Name = "MainOuter"
 mainOuter.Size = UDim2.new(0, WIN_W + SIDE_TAB_W, 0, WIN_H)
 mainOuter.Position = UDim2.new(0.5, -(WIN_W + SIDE_TAB_W)/2, 0.5, -WIN_H/2 + 80)
 mainOuter.BackgroundColor3 = C.winBg
 mainOuter.BackgroundTransparency = 0
 mainOuter.BorderSizePixel = 0
 mainOuter.ClipsDescendants = true
 mainOuter.Active = true
 mainOuter.Visible = false
 mkStroke(mainOuter, C.winBorder, 1.5)
 mkCorner(mainOuter, 10)

-- ============================================================
 -- BACKGROUND DECAL
 -- ============================================================
 local bgDecal = Instance.new("ImageLabel", mainOuter)
 bgDecal.Size = UDim2.new(1, 0, 1, 0)
 bgDecal.Position = UDim2.new(0, 0, 0, 0)
 bgDecal.BackgroundTransparency = 1
 bgDecal.Image = "rbxassetid://107977050874654"
 bgDecal.ZIndex = 1
 bgDecal.ScaleType = Enum.ScaleType.Crop
 mkCorner(bgDecal, 10)

do
 local _drag, _ds, _sp = false, nil, nil
 mainOuter.InputBegan:Connect(function(inp)
 if inp.UserInputType == Enum.UserInputType.MouseButton1
 or inp.UserInputType == Enum.UserInputType.Touch then
 _drag = true; _ds = inp.Position; _sp = mainOuter.Position
 inp.Changed:Connect(function()
 if inp.UserInputState == Enum.UserInputState.End then _drag = false end
 end)
 end
 end)
 UIS.InputChanged:Connect(function(inp)
 if not _drag then return end
 if inp.UserInputType == Enum.UserInputType.MouseMovement
 or inp.UserInputType == Enum.UserInputType.Touch then
 local d = inp.Position - _ds
 mainOuter.Position = UDim2.new(_sp.X.Scale, _sp.X.Offset + d.X, _sp.Y.Scale, _sp.Y.Offset + d.Y)
 end
 end)
 end

-- ============================================================
 -- SIDE TABS - REMOVED "Steals" and "Sky"
 -- ============================================================
 local sideTabs = Instance.new("Frame", mainOuter)
 sideTabs.Size = UDim2.new(0, SIDE_TAB_W, 1, 0)
 sideTabs.Position = UDim2.new(0, 0, 0, 0)
 sideTabs.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
 sideTabs.BackgroundTransparency = 0.6
 sideTabs.BorderSizePixel = 0
 sideTabs.ZIndex = 5
 mkCorner(sideTabs, 10)

local sideTabsList = Instance.new("UIListLayout", sideTabs)
 sideTabsList.FillDirection = Enum.FillDirection.Vertical
 sideTabsList.SortOrder = Enum.SortOrder.LayoutOrder
 sideTabsList.Padding = UDim.new(0, 2)
 sideTabsList.VerticalAlignment = Enum.VerticalAlignment.Top

-- REMOVED: "Steals" and "Sky"
 local TABS = {"Speed", "Auto Bat", "Movement", "Configs"}
 local currentTab = "Speed"
 local tabBtns = {}; local tabPages = {}

for i, name in ipairs(TABS) do
 local btn = Instance.new("TextButton", sideTabs)
 btn.Size = UDim2.new(1, 0, 0, 40)
 btn.BackgroundColor3 = (name == currentTab) and Color3.fromRGB(120, 20, 180) or Color3.fromRGB(0, 0, 0)
 btn.BackgroundTransparency = (name == currentTab) and 0 or 0.4
 btn.BorderSizePixel = 0
 btn.Text = name
 btn.TextColor3 = (name == currentTab) and Color3.fromRGB(255,255,255) or Color3.fromRGB(160, 32, 240)
 btn.Font = Enum.Font.GothamBold
 btn.TextSize = 10
 btn.TextWrapped = true
 btn.ZIndex = 7
 btn.LayoutOrder = i
 btn.AutoButtonColor = false
 mkStroke(btn, Color3.fromRGB(80, 0, 120), 1)
 mkCorner(btn, 6)
 tabBtns[name] = {btn = btn, underline = nil}

btn.MouseButton1Click:Connect(function()
 currentTab = name
 for _, n in ipairs(TABS) do
 local t = tabBtns[n]; local active = (n == name)
 TweenService:Create(t.btn, TweenInfo.new(0.18), {
 BackgroundColor3 = active and Color3.fromRGB(120, 20, 180) or Color3.fromRGB(0, 0, 0),
 BackgroundTransparency = active and 0 or 0.4,
 TextColor3 = active and Color3.fromRGB(255,255,255) or Color3.fromRGB(160, 32, 240),
 }):Play()
 if tabPages[n] then tabPages[n].Visible = active end
 end
 end)
 end

-- ============================================================
 -- HEADER - VIOLET
 -- ============================================================
 local header = Instance.new("Frame", mainOuter)
 header.Size = UDim2.new(1, -SIDE_TAB_W, 0, TITLE_H)
 header.Position = UDim2.new(0, SIDE_TAB_W, 0, 0)
 header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
 header.BackgroundTransparency = 0.5
 header.BorderSizePixel = 0; header.ZIndex = 5
 mkCorner(header, 10)

local hAccent = Instance.new("Frame", header)
 hAccent.Size = UDim2.new(0, 3, 0, 22); hAccent.Position = UDim2.new(0, 0, 0, 3)
 hAccent.BackgroundColor3 = Color3.fromRGB(160, 32, 240); hAccent.BorderSizePixel = 0; hAccent.ZIndex = 6
 mkCorner(hAccent, 2)

local logoBadge = Instance.new("Frame", header)
 logoBadge.Size = UDim2.new(0, 24, 0, 24); logoBadge.Position = UDim2.new(0, 8, 0, 2)
 logoBadge.BackgroundColor3 = Color3.fromRGB(160, 32, 240); logoBadge.BorderSizePixel = 0; logoBadge.ZIndex = 6
 mkCorner(logoBadge, 6)
 local logoBadgeLbl = Instance.new("TextLabel", logoBadge)
 logoBadgeLbl.Size = UDim2.new(1,0,1,0); logoBadgeLbl.BackgroundTransparency = 1
 logoBadgeLbl.Text = "S"; logoBadgeLbl.TextColor3 = Color3.fromRGB(0,0,0)
 logoBadgeLbl.Font = Enum.Font.GothamBlack; logoBadgeLbl.TextSize = 10; logoBadgeLbl.ZIndex = 7

local titleLbl = Instance.new("TextLabel", header)
 titleLbl.Size = UDim2.new(0, 100, 0, 14); titleLbl.Position = UDim2.new(0, 38, 0, 2)
 titleLbl.BackgroundTransparency = 1; titleLbl.Text = "SKM DUEL"
 titleLbl.TextColor3 = Color3.fromRGB(160, 32, 240); titleLbl.Font = Enum.Font.GothamBlack
 titleLbl.TextSize = 11; titleLbl.TextXAlignment = Enum.TextXAlignment.Left; titleLbl.ZIndex = 6

local verLbl = Instance.new("TextLabel", header)
 verLbl.Size = UDim2.new(0, 50, 0, 12); verLbl.Position = UDim2.new(0, 38, 0, 16)
 verLbl.BackgroundTransparency = 1; verLbl.Text = "v1.0 · autosave"
 verLbl.TextColor3 = Color3.fromRGB(160, 32, 240); verLbl.Font = Enum.Font.Gotham
 verLbl.TextSize = 7; verLbl.TextXAlignment = Enum.TextXAlignment.Left; verLbl.ZIndex = 6

local closeBtn = Instance.new("TextButton", header)
 closeBtn.Size = UDim2.new(0, 20, 0, 20); closeBtn.Position = UDim2.new(1, -24, 0, 4)
 closeBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 40); closeBtn.BorderSizePixel = 0
 closeBtn.Text = "×"; closeBtn.TextColor3 = Color3.fromRGB(160, 32, 240)
 closeBtn.Font = Enum.Font.GothamBlack; closeBtn.TextSize = 13; closeBtn.ZIndex = 8
 mkStroke(closeBtn, Color3.fromRGB(80, 0, 120), 1)
 mkCorner(closeBtn, 6)
 closeBtn.MouseEnter:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(120, 20, 180), TextColor3 = Color3.fromRGB(255,255,255)}):Play() end)
 closeBtn.MouseLeave:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 20, 40), TextColor3 = Color3.fromRGB(160, 32, 240)}):Play() end)
 closeBtn.MouseButton1Click:Connect(function() State.guiVisible = false; mainOuter.Visible = false end)

lockBtn = Instance.new("TextButton", header)
 lockBtn.Size = UDim2.new(0, 20, 0, 20); lockBtn.Position = UDim2.new(1, -48, 0, 4)
 lockBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); lockBtn.BorderSizePixel = 0
 lockBtn.Text = "🔓"; lockBtn.Font = Enum.Font.GothamBold; lockBtn.TextSize = 10; lockBtn.ZIndex = 8
 mkStroke(lockBtn, Color3.fromRGB(80, 0, 120), 1)
 mkCorner(lockBtn, 6)
 lockBtn.MouseButton1Click:Connect(function()
 State.uiLocked = not State.uiLocked
 lockBtn.Text = State.uiLocked and "🔒" or "🔓"
 TweenService:Create(lockBtn, TweenInfo.new(0.1), {BackgroundColor3 = State.uiLocked and Color3.fromRGB(40,20,40) or Color3.fromRGB(20,20,20)}):Play()
 end)

local titleDiv = Instance.new("Frame", header)
 titleDiv.Size = UDim2.new(1, -8, 0, 1); titleDiv.Position = UDim2.new(0, 4, 0, 28)
 titleDiv.BackgroundColor3 = Color3.fromRGB(80, 0, 120); titleDiv.BorderSizePixel = 0; titleDiv.ZIndex = 4

-- ============================================================
 -- CONTENT AREA
 -- ============================================================
 local CONTENT_Y = TITLE_H + 1
 local contentBg = Instance.new("Frame", mainOuter)
 contentBg.Size = UDim2.new(1, -SIDE_TAB_W, 1, -CONTENT_Y)
 contentBg.Position = UDim2.new(0, SIDE_TAB_W, 0, CONTENT_Y)
 contentBg.BackgroundColor3 = C.winBg
 contentBg.BackgroundTransparency = 0.3
 contentBg.BorderSizePixel = 0
 contentBg.ClipsDescendants = true
 contentBg.ZIndex = 2

-- ============================================================
 -- ROW / PAGE BUILDERS
 -- ============================================================
 local currentPage = nil; local lo = 0
 local function LO() lo = lo + 1; return lo end

local function makeGap(px)
 local f = Instance.new("Frame", currentPage)
 f.Size = UDim2.new(1, 0, 0, px or 6)
 f.BackgroundTransparency = 1; f.BorderSizePixel = 0; f.LayoutOrder = LO()
 end

local function makeSectionHeader(label)
 local wrap = Instance.new("Frame", currentPage)
 wrap.Size = UDim2.new(1, 0, 0, 20)
 wrap.BackgroundTransparency = 1; wrap.BorderSizePixel = 0; wrap.LayoutOrder = LO()
 local lbl = Instance.new("TextLabel", wrap)
 lbl.Size = UDim2.new(1, -20, 1, 0)
 lbl.Position = UDim2.new(0, 10, 0, 0)
 lbl.BackgroundTransparency = 1
 lbl.Text = label and label:upper() or ""
 lbl.TextColor3 = Color3.fromRGB(160, 32, 240)
 lbl.Font = Enum.Font.GothamBold
 lbl.TextSize = 9
 lbl.TextXAlignment = Enum.TextXAlignment.Left
 local line = Instance.new("Frame", wrap)
 line.Size = UDim2.new(1, -10, 0, 1); line.Position = UDim2.new(0, 10, 1, 0)
 line.BackgroundColor3 = Color3.fromRGB(160, 32, 240)
 line.BackgroundTransparency = 0.65; line.BorderSizePixel = 0
 end

local function makeInputRow(label, default, onChange)
 local row = Instance.new("Frame", currentPage)
 row.Size = UDim2.new(1, 0, 0, 42)
 row.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
 row.BackgroundTransparency = 0.6
 row.BorderSizePixel = 0; row.LayoutOrder = LO()
 mkStroke(row, Color3.fromRGB(80, 0, 120), 1)
 mkCorner(row, 8)

local lbl = Instance.new("TextLabel", row)
 lbl.Size = UDim2.new(1, -90, 1, 0)
 lbl.Position = UDim2.new(0, 10, 0, 0)
 lbl.BackgroundTransparency = 1; lbl.Text = label
 lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
 lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 10
 lbl.TextXAlignment = Enum.TextXAlignment.Left

local boxWrap = Instance.new("Frame", row)
 boxWrap.Size = UDim2.new(0, 64, 0, 26)
 boxWrap.Position = UDim2.new(1, -72, 0.5, -13)
 boxWrap.BackgroundColor3 = Color3.fromRGB(20, 5, 20); boxWrap.BorderSizePixel = 0
 boxWrap.BackgroundTransparency = 0.6
 mkStroke(boxWrap, Color3.fromRGB(80, 0, 120), 1)
 mkCorner(boxWrap, 6)

local box = Instance.new("TextBox", boxWrap)
 box.Size = UDim2.new(1, -8, 1, 0); box.Position = UDim2.new(0, 4, 0, 0)
 box.BackgroundTransparency = 1; box.Text = tostring(default)
 box.TextColor3 = Color3.fromRGB(255, 255, 255); box.Font = Enum.Font.GothamBold
 box.TextSize = 11; box.ClearTextOnFocus = false; box.ZIndex = 8
 box.TextXAlignment = Enum.TextXAlignment.Center
 box.FocusLost:Connect(function()
 if onChange then local n = tonumber(box.Text); if n then onChange(n); task.spawn(function() pcall(saveConfig) end) else box.Text = tostring(default) end end
 end)
 return box, row
 end

local function makeToggleRow(label, defaultOn, onToggle)
 local row = Instance.new("Frame", currentPage)
 row.Size = UDim2.new(1, 0, 0, 42)
 row.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
 row.BackgroundTransparency = 0.6
 row.BorderSizePixel = 0; row.LayoutOrder = LO()
 local rowStroke = mkStroke(row, Color3.fromRGB(80, 0, 120), 1)
 mkCorner(row, 8)

local lbl = Instance.new("TextLabel", row)
 lbl.Size = UDim2.new(1, -70, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0)
 lbl.BackgroundTransparency = 1; lbl.Text = label
 lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
 lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 10
 lbl.TextXAlignment = Enum.TextXAlignment.Left

local pillBg = Instance.new("Frame", row)
 pillBg.Size = UDim2.new(0, 38, 0, 18)
 pillBg.Position = UDim2.new(1, -46, 0.5, -9)
 pillBg.BackgroundColor3 = defaultOn and Color3.fromRGB(160, 32, 240) or Color3.fromRGB(40, 10, 40)
 pillBg.BackgroundTransparency = 0.3
 pillBg.BorderSizePixel = 0; pillBg.ZIndex = 7
 local pillCorner = Instance.new("UICorner", pillBg)
 pillCorner.CornerRadius = UDim.new(1, 0)

local dot = Instance.new("Frame", pillBg)
 dot.Size = UDim2.new(0, 14, 0, 14)
 dot.Position = defaultOn and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
 dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
 dot.BorderSizePixel = 0; dot.ZIndex = 8
 local dotCorner = Instance.new("UICorner", dot)
 dotCorner.CornerRadius = UDim.new(1, 0)

local isOn = defaultOn or false
 local function setV(on)
 isOn = on
 TweenService:Create(pillBg, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
 BackgroundColor3 = on and Color3.fromRGB(160, 32, 240) or Color3.fromRGB(40, 10, 40),
 BackgroundTransparency = on and 0 or 0.3
 }):Play()
 TweenService:Create(dot, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
 Position = on and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
 }):Play()
 TweenService:Create(rowStroke, TweenInfo.new(0.15), {
 Color = on and Color3.fromRGB(160, 32, 240) or Color3.fromRGB(80, 0, 120)
 }):Play()
 end
 local function toggle() isOn = not isOn; setV(isOn); if onToggle then pcall(onToggle, isOn) end; task.spawn(function() pcall(saveConfig) end) end

local clk = Instance.new("TextButton", row)
 clk.Size = UDim2.new(1, -50, 1, 0); clk.BackgroundTransparency = 1
 clk.Text = ""; clk.ZIndex = 5; clk.BorderSizePixel = 0
 clk.AutoButtonColor = false
 clk.MouseButton1Click:Connect(toggle)
 clk.MouseEnter:Connect(function()
 TweenService:Create(row, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(60, 20, 80), BackgroundTransparency = 0.3}):Play()
 end)
 clk.MouseLeave:Connect(function()
 TweenService:Create(row, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(10, 10, 10), BackgroundTransparency = 0.6}):Play()
 end)
 local pClk = Instance.new("TextButton", pillBg)
 pClk.Size = UDim2.new(1, 0, 1, 0); pClk.BackgroundTransparency = 1
 pClk.Text = ""; pClk.ZIndex = 9; pClk.BorderSizePixel = 0
 pClk.AutoButtonColor = false
 pClk.MouseButton1Click:Connect(toggle)
 return setV
 end

-- ============================================================
 -- KEYBIND ROW
 -- ============================================================
 local function getKeyDisplayName(kc)
 local n = kc.Name
 local gpNames = {
 ButtonA="A",ButtonB="B",ButtonX="X",ButtonY="Y",
 ButtonL1="LB",ButtonL2="LT",ButtonL3="LS",
 ButtonR1="RB",ButtonR2="RT",ButtonR3="RS",
 ButtonSelect="SEL",ButtonStart="STA",
 DPadUp="D↑",DPadDown="D↓",DPadLeft="D←",DPadRight="D→",
 Thumbstick1="LS",Thumbstick2="RS",
 }
 if gpNames[n] then return gpNames[n] end
 return n:sub(1, 5)
 end

local function makeKeybindRow(label, currentKey, onChanged, keyName)
 local row = Instance.new("Frame", currentPage)
 row.Size = UDim2.new(1, 0, 0, 42)
 row.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
 row.BackgroundTransparency = 0.6
 row.BorderSizePixel = 0; row.LayoutOrder = LO()
 mkStroke(row, Color3.fromRGB(80, 0, 120), 1)
 mkCorner(row, 8)

local lbl = Instance.new("TextLabel", row)
 lbl.Size = UDim2.new(1, -80, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0)
 lbl.BackgroundTransparency = 1; lbl.Text = label
 lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
 lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 10
 lbl.TextXAlignment = Enum.TextXAlignment.Left

local kbtn = Instance.new("TextButton", row)
 kbtn.Size = UDim2.new(0, 42, 0, 20); kbtn.Position = UDim2.new(1, -50, 0.5, -10)
 kbtn.BackgroundColor3 = Color3.fromRGB(40, 10, 40); kbtn.BorderSizePixel = 0
 kbtn.BackgroundTransparency = 0.3
 kbtn.Text = getKeyDisplayName(currentKey); kbtn.TextColor3 = Color3.fromRGB(160, 32, 240)
 kbtn.Font = Enum.Font.GothamBold; kbtn.TextSize = 9; kbtn.ZIndex = 8
 kbtn.AutoButtonColor = false
 local ks = mkStroke(kbtn, Color3.fromRGB(80, 0, 120), 1)
 mkCorner(kbtn, 5)

local listening = false; local lconnKeyboard = nil; local lconnGamepad = nil
 local function stopL(key)
 listening = false
 if lconnKeyboard then lconnKeyboard:Disconnect(); lconnKeyboard = nil end
 if lconnGamepad then lconnGamepad:Disconnect(); lconnGamepad = nil end
 TweenService:Create(ks, TweenInfo.new(0.12), {Color=Color3.fromRGB(160, 32, 240)}):Play()
 kbtn.TextColor3 = Color3.fromRGB(160, 32, 240)
 if key then
 kbtn.Text = getKeyDisplayName(key)
 if onChanged then onChanged(key) end
 task.spawn(function() if saveConfig then pcall(saveConfig) end end)
 end
 end
 kbtn.MouseButton1Click:Connect(function()
 if listening then stopL(nil); return end
 listening = true; kbtn.Text = "···"; kbtn.TextColor3 = C.inputTxt
 TweenService:Create(ks, TweenInfo.new(0.12), {Color=C.inputFocus}):Play()
 lconnKeyboard = UIS.InputBegan:Connect(function(inp)
 if not listening then return end
 if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
 if inp.KeyCode == Enum.KeyCode.Escape then stopL(nil); return end
 stopL(inp.KeyCode)
 end)
 lconnGamepad = UIS.InputBegan:Connect(function(inp)
 if not listening then return end
 if inp.UserInputType ~= Enum.UserInputType.Gamepad1
 and inp.UserInputType ~= Enum.UserInputType.Gamepad2
 and inp.UserInputType ~= Enum.UserInputType.Gamepad3
 and inp.UserInputType ~= Enum.UserInputType.Gamepad4 then return end
 local kc = inp.KeyCode; if kc == Enum.KeyCode.Unknown then return end
 stopL(kc)
 end)
 end)
 if keyName then keybindBtnRefs[keyName] = kbtn end
 return kbtn
 end

-- ============================================================
 -- BUILD PAGES
 -- ============================================================
 local function buildPage(tabName, buildFn)
 local page = Instance.new("ScrollingFrame", contentBg)
 page.Name = tabName; page.Visible = (tabName == "Speed")
 page.Size = UDim2.new(1, 0, 1, 0); page.Position = UDim2.new(0, 0, 0, 0)
 page.BackgroundTransparency = 1; page.BorderSizePixel = 0
 page.ScrollBarThickness = 3
 page.ScrollBarImageColor3 = Color3.fromRGB(160, 32, 240)
 page.ScrollBarImageTransparency = 0.4
 page.AutomaticCanvasSize = Enum.AutomaticSize.Y; page.CanvasSize = UDim2.new(0, 0, 0, 0)
 local ll = Instance.new("UIListLayout", page)
 ll.SortOrder = Enum.SortOrder.LayoutOrder; ll.Padding = UDim.new(0, 0)
 tabPages[tabName] = page; currentPage = page; lo = 0
 buildFn()
 currentPage = nil
 end

-- ============================================================
 -- SPEED PAGE
 -- ============================================================
 buildPage("Speed", function()
 makeGap(2)
 makeSectionHeader("Speed Settings")
 makeGap(2)

normalBox = makeInputRow("Normal Speed", State.normalSpeed, function(n)
 if n > 0 and n <= 500 then State.normalSpeed = n end
 end)
 carryBox = makeInputRow("Carry Speed", State.carrySpeed, function(n)
 if n > 0 and n <= 500 then State.carrySpeed = n end
 end)
 laggerBox = makeInputRow("Lagger Speed", State.laggerSpeed, function(n)
 if n > 0 and n <= 500 then State.laggerSpeed = n end
 end)

makeGap(6)
 makeSectionHeader("Keybinds")
 makeGap(2)
 makeKeybindRow("Speed Key", Keys.speed, function(k) Keys.speed = k end, "speed")
 makeKeybindRow("Lagger Key", Keys.lagger, function(k) Keys.lagger = k end, "lagger")
 end)

-- ============================================================
 -- AUTO BAT PAGE
 -- ============================================================
 buildPage("Auto Bat", function()
 makeGap(2)
 makeSectionHeader("Aimbot")
 makeGap(2)
 setAutoSwing = makeToggleRow("Auto Swing", true, function(on) State.autoSwingEnabled = on end)
 makeGap(8)
 makeSectionHeader("Keybinds")
 makeGap(2)
 makeKeybindRow("Aimbot Key", Keys.aimbot, function(k) Keys.aimbot = k end, "aimbot")
 end)

-- ============================================================
 -- MOVEMENT PAGE
 -- ============================================================
 buildPage("Movement", function()
 makeGap(2)
 makeSectionHeader("Character")
 makeGap(2)
 setInfJump = makeToggleRow("Infinite Jump", false, function(on) State.infJumpEnabled = on end)
 setAntiRag = makeToggleRow("Anti Ragdoll", false, function(on)
 State.antiRagdollEnabled = on; if on then startAntiRagdoll() else stopAntiRagdoll() end
 end)
 setUnwalkToggle = makeToggleRow("Unwalk", false, function(on)
 State.unwalkEnabled = on
 if on then disableAnimations() else enableAnimations() end
 end)
 setFps = makeToggleRow("FPS Boost", false, function(on)
 State.fpsBoostEnabled = on; if on then pcall(applyFPSBoost) end
 end)
 setFovBoost = makeToggleRow("FOV Boost", false, function(on)
 State.fovBoostEnabled = on
 if on then enableFovBoost() else disableFovBoost() end
 end)
 makeGap(8)
 makeSectionHeader("Auto Movement")
 makeGap(2)
 makeKeybindRow("Auto Left", Keys.autoLeft, function(k) Keys.autoLeft = k end, "autoLeft")
 makeKeybindRow("Auto Right", Keys.autoRight, function(k) Keys.autoRight = k end, "autoRight")
 makeGap(8)
 makeSectionHeader("Other Keys")
 makeGap(2)
 makeKeybindRow("Drop Key", Keys.drop, function(k) Keys.drop = k end, "drop")
 makeKeybindRow("TP Down Key", Keys.tpDown, function(k) Keys.tpDown = k end, "tpDown")
 end)

-- ============================================================
 -- CONFIGS/SETTINGS PAGE
 -- ============================================================
 local function applyStackButtonsVisible(visible)
 State.stackButtonsHidden = not visible
 for _, wrapper in pairs(stackWrappers) do wrapper.Visible = visible end
 end

local function applyPreset(data)
 if data.normalSpeed then State.normalSpeed=data.normalSpeed; if normalBox then normalBox.Text=tostring(data.normalSpeed) end end
 if data.carrySpeed then State.carrySpeed=data.carrySpeed; if carryBox then carryBox.Text=tostring(data.carrySpeed) end end
 if data.laggerSpeed then State.laggerSpeed=data.laggerSpeed; if laggerBox then laggerBox.Text=tostring(data.laggerSpeed) end end
 if data.stealRadius then
 Steal.StealRadius=data.stealRadius; Steal.cachedPrompts={}; Steal.promptCacheTime=0
 if stealRadBox and not stealRadBox:IsFocused() then stealRadBox.Text=tostring(data.stealRadius) end
 if radTB and not radTB:IsFocused() then radTB.Text=tostring(data.stealRadius) end
 end
 if data.stealDuration then Steal.StealDuration=data.stealDuration end
 if data.infJump~=nil and setInfJump then State.infJumpEnabled=data.infJump; setInfJump(data.infJump) end
 if data.antiRagdoll~=nil and setAntiRag then State.antiRagdollEnabled=data.antiRagdoll; setAntiRag(data.antiRagdoll); if data.antiRagdoll then startAntiRagdoll() else stopAntiRagdoll() end end
 if data.fpsBoost~=nil and setFps then State.fpsBoostEnabled=data.fpsBoost; setFps(data.fpsBoost); if data.fpsBoost then pcall(applyFPSBoost) end end
 if data.medusaCounter~=nil and setMedusaCounter then State.medusaCounterEnabled=data.medusaCounter; setMedusaCounter(data.medusaCounter); if data.medusaCounter then setupMedusaCounter(LP.Character) else stopMedusaCounter() end end
 if data.batCounter~=nil and setBatCounter then State.batCounterEnabled=data.batCounter; setBatCounter(data.batCounter); if data.batCounter then startBatCounter() else stopBatCounter() end end
 if data.autoSteal~=nil and setInstaGrab then
 Steal.AutoStealEnabled=data.autoSteal; setInstaGrab(data.autoSteal)
 if data.autoSteal then pcall(startAutoSteal) else stopAutoSteal() end
 end
 end

local function resetButtonPositions()
 for i, def in ipairs(stackDefs) do
 local btn = stackWrappers[def.key]
 if btn then
 local defaultPos = getDefaultStackPos(i)
 TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
 Position = defaultPos
 }):Play()
 end
 end
 end

buildPage("Configs", function()
 makeGap(2)
 makeSectionHeader("Interface")
 makeGap(2)
 makeKeybindRow("Hide GUI", Keys.guiHide, function(k) Keys.guiHide = k end, "guiHide")
 uiScaleBox = makeInputRow("UI Scale", 1.0, function(n)
 if n >= 0.5 and n <= 2.0 then if uiScaleObj then uiScaleObj.Scale = n end end
 end)
 setHideButtonsToggle = makeToggleRow("Hide Buttons", false, function(on)
 applyStackButtonsVisible(not on)
 end)
 makeToggleRow("Drag Buttons", false, function(on)
 State.dragButtonsEnabled = on
 end)
 makeToggleRow("Separate Movement", false, function(on)
 State.separateButtonMovement = on
 task.spawn(function() pcall(saveConfig) end)
 end)

makeGap(8)
 makeSectionHeader("Combat")
 makeGap(2)
 setBatCounter = makeToggleRow("Bat Counter", false, function(on)
 State.batCounterEnabled = on
 if on then startBatCounter() else stopBatCounter() end
 end)

makeGap(8)

local rWrap = Instance.new("Frame", currentPage)
 rWrap.Size = UDim2.new(1, 0, 0, 46); rWrap.BackgroundTransparency = 1
 rWrap.BorderSizePixel = 0; rWrap.LayoutOrder = LO()
 local resetBtn = Instance.new("TextButton", rWrap)
 resetBtn.Size = UDim2.new(1, -28, 0, 32); resetBtn.Position = UDim2.new(0, 14, 0, 7)
 resetBtn.BackgroundColor3 = C.btnBg; resetBtn.BorderSizePixel = 0
 resetBtn.Text = "↺ Reset Button Positions"; resetBtn.TextColor3 = C.btnTxt
 resetBtn.Font = Enum.Font.GothamBold; resetBtn.TextSize = 12; resetBtn.ZIndex = 5
 mkStroke(resetBtn, C.btnBorder, 1)
 mkCorner(resetBtn, 6)
 resetBtn.MouseEnter:Connect(function() TweenService:Create(resetBtn,TweenInfo.new(0.1),{BackgroundColor3=C.btnHov}):Play() end)
 resetBtn.MouseLeave:Connect(function() TweenService:Create(resetBtn,TweenInfo.new(0.1),{BackgroundColor3=C.btnBg}):Play() end)
 resetBtn.MouseButton1Click:Connect(function()
 resetButtonPositions()
 if mbPanel then
 TweenService:Create(mbPanel, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
 Position = UDim2.new(1, -(MB_TOTAL_W+8), 0.5, -(MB_TOTAL_H/2)-40)
 }):Play()
 end
 resetBtn.Text = "✓ Positions Reset!"
 task.delay(1.8, function()
 if resetBtn and resetBtn.Parent then
 resetBtn.Text = "↺ Reset Button Positions"
 end
 end)
 end)

makeGap(8)

local fw = Instance.new("Frame", currentPage); fw.Size = UDim2.new(1, 0, 0, 22)
 fw.BackgroundTransparency = 1; fw.BorderSizePixel = 0; fw.LayoutOrder = LO()
 local fl = Instance.new("TextLabel", fw); fl.Size = UDim2.new(1, 0, 1, 0)
 fl.BackgroundTransparency = 1; fl.Text = "SKM DUEL · v1.0"
 fl.TextColor3 = Color3.fromRGB(160, 32, 240); fl.Font = Enum.Font.Gotham; fl.TextSize = 10
 fl.TextXAlignment = Enum.TextXAlignment.Center
 end)

rebuildPresetList = function()
 end

for _, n in ipairs(TABS) do
 local t = tabBtns[n]; local active = (n == "Speed")
 t.btn.TextColor3 = active and Color3.fromRGB(255,255,255) or Color3.fromRGB(160, 32, 240)
 t.btn.BackgroundColor3 = active and Color3.fromRGB(120, 20, 180) or Color3.fromRGB(0, 0, 0)
 t.btn.BackgroundTransparency = active and 0 or 0.4
 if tabPages[n] then tabPages[n].Visible = active end
 end

-- ============================================================
 -- SKM DUEL TOGGLE BUTTON (RECTANGLE) - VIOLET
 -- ============================================================
 local vBtnFrame = Instance.new("Frame", gui)
 vBtnFrame.Name = "SKM DUEL VBtn"
 vBtnFrame.Size = UDim2.new(0, 120, 0, 45)
 vBtnFrame.Position = UDim2.new(0, 10, 0.5, -22)
 vBtnFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
 vBtnFrame.BackgroundTransparency = 0.3
 vBtnFrame.BorderSizePixel = 0
 vBtnFrame.Active = true
 vBtnFrame.ZIndex = 20
 mkStroke(vBtnFrame, Color3.fromRGB(160, 32, 240), 2)
 mkCorner(vBtnFrame, 8)

local vBtnLbl = Instance.new("TextLabel", vBtnFrame)
 vBtnLbl.Size = UDim2.new(1, 0, 1, 0)
 vBtnLbl.BackgroundTransparency = 1
 vBtnLbl.Text = "SKM DUEL"
 vBtnLbl.TextColor3 = Color3.fromRGB(160, 32, 240)
 vBtnLbl.Font = Enum.Font.GothamBlack
 vBtnLbl.TextSize = 18
 vBtnLbl.TextXAlignment = Enum.TextXAlignment.Center
 vBtnLbl.TextYAlignment = Enum.TextYAlignment.Center
 vBtnLbl.ZIndex = 21

local glow = Instance.new("Frame", vBtnFrame)
 glow.Size = UDim2.new(1.1, 0, 1.1, 0)
 glow.Position = UDim2.new(-0.05, 0, -0.05, 0)
 glow.BackgroundColor3 = Color3.fromRGB(160, 32, 240)
 glow.BackgroundTransparency = 0.8
 glow.BorderSizePixel = 0
 glow.ZIndex = 19
 mkCorner(glow, 10)

local vDragging,vDragInput,vDragStart,vStartPos=false,nil,nil,nil; local vMoved=false
 vBtnFrame.InputBegan:Connect(function(inp)
 if inp.UserInputType~=Enum.UserInputType.MouseButton1 and inp.UserInputType~=Enum.UserInputType.Touch then return end
 vDragging=true; vMoved=false; vDragStart=inp.Position; vStartPos=vBtnFrame.Position
 inp.Changed:Connect(function()
 if inp.UserInputStateEnum.UserInputState.End then
 if not vMoved then
 State.guiVisible=not State.guiVisible
 mainOuter.Visible=State.guiVisible
 TweenService:Create(mkStroke(vBtnFrame, State.guiVisible and Color3.fromRGB(210,200,200) or Color3.fromRGB(160, 32, 240), 2), TweenInfo.new(0.15), {}):Play()
 if State.guiVisible then
 TweenService:Create(glow, TweenInfo.new(0.3), {BackgroundTransparency = 0.5}):Play()
 task.wait(0.3)
 TweenService:Create(glow, TweenInfo.new(0.3), {BackgroundTransparency = 0.8}):Play()
 end
 end
 vDragging=false; vMoved=false
 end
 end)
 end)
 vBtnFrame.InputChanged:Connect(function(inp)
 if inp.UserInputTypeEnum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then vDragInput=inp end
 end)
 UIS.InputChanged:Connect(function(inp)
 if inp~=vDragInput or not vDragging then return end
 local dx=inp.Position.X-vDragStart.X; local dy=inp.Position.Y-vDragStart.Y
 if math.abs(dx)>4 or math.abs(dy)>4 then vMoved=true end
 if vMoved then vBtnFrame.Position=UDim2.new(vStartPos.X.Scale,vStartPos.X.Offset+dx,vStartPos.Y.Scale,vStartPos.Y.Offset+dy) end
 end)

vBtnFrame.MouseEnter:Connect(function()
 if not State.guiVisible then
 TweenService:Create(vBtnFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 130, 0, 50)}):Play()
 TweenService:Create(vBtnLbl, TweenInfo.new(0.2), {TextSize = 20}):Play()
 TweenService:Create(glow, TweenInfo.new(0.2), {BackgroundTransparency = 0.6}):Play()
 end
 end)
 vBtnFrame.MouseLeave:Connect(function()
 if not State.guiVisible then
 TweenService:Create(vBtnFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 120, 0, 45)}):Play()
 TweenService:Create(vBtnLbl, TweenInfo.new(0.2), {TextSize = 18}):Play()
 TweenService:Create(glow, TweenInfo.new(0.2), {BackgroundTransparency = 0.8}):Play()
 end
 end)

-- ============================================================
 -- RADIUS TEXT BOX (Hidden, for config only)
 -- ============================================================
 radTB = Instance.new("TextBox", gui)
 radTB.Size = UDim2.new(0, 0, 0, 0); radTB.BackgroundTransparency = 1; radTB.TextTransparency = 1
 radTB.Text = tostring(Steal.StealRadius); radTB.ClearTextOnFocus = false; radTB.ZIndex = 0
 radTB.FocusLost:Connect(function()
 local n = tonumber(radTB.Text)
 if n and n >= 5 and n <= 300 then
 Steal.StealRadius = math.floor(n); Steal.cachedPrompts = {}; Steal.promptCacheTime = 0
 if stealRadBox and not stealRadBox:IsFocused() then stealRadBox.Text = tostring(Steal.StealRadius) end
 task.spawn(function() pcall(saveConfig) end)
 end
 radTB.Text = tostring(Steal.StealRadius)
 end)

-- ============================================================
 -- MOBILE BUTTONS (Rounded corners) - VIOLET
 -- ============================================================
 local MB_BW = 58; local MB_BH = 58; local MB_PAD = 6; local MB_CORNER = 8
 local MB_COLS2 = 2; local MB_ROWS2 = 4
 local MB_TOTAL_W = MB_COLS2*MB_BW + (MB_COLS2+1)MB_PAD
 local MB_TOTAL_H = MB_ROWS2MB_BH + (MB_ROWS2+1)*MB_PAD

local mbPanel = Instance.new("Frame", gui)
 mbPanel.Name = "MobileButtonPanel"
 mbPanel.Size = UDim2.new(0, MB_TOTAL_W, 0, MB_TOTAL_H)
 mbPanel.Position = UDim2.new(1, -(MB_TOTAL_W+8), 0.5, -(MB_TOTAL_H/2)-40)
 mbPanel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
 mbPanel.BackgroundTransparency = 1
 mbPanel.BorderSizePixel = 0
 mbPanel.Active = true
 mbPanel.ZIndex = 99

local function btnPos2(row, col)
 return UDim2.new(0, MB_PAD + (col-1)(MB_BW+MB_PAD), 0, MB_PAD + (row-1)(MB_BH+MB_PAD))
 end

local mbGrid = {
 {1,1},{1,2},
 {2,1},{2,2},
 {3,1},{3,2},
 {4,1},{4,2},
 }

for i, def in ipairs(stackDefs) do
 local rc = mbGrid[i]; if not rc then break end
 local row, col = rc[1], rc[2]

local btn = Instance.new("TextButton", mbPanel)
 btn.Name = "StackBtn_"..def.key
 btn.Size = UDim2.new(0, MB_BW, 0, MB_BH)
 btn.Position = btnPos2(row, col)
 btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
 btn.BackgroundTransparency = 0.3
 btn.BorderSizePixel = 0
 btn.Text = ""
 btn.ZIndex = 101
 local btnCorner = Instance.new("UICorner", btn)
 btnCorner.CornerRadius = UDim.new(0, MB_CORNER)
 local btnStroke = Instance.new("UIStroke", btn)
 btnStroke.Color = Color3.fromRGB(80, 0, 120)
 btnStroke.Thickness = 1.5
 btnStroke.Transparency = 0.3

local label = Instance.new("TextLabel", btn)
 label.Size = UDim2.new(1, 0, 1, 0)
 label.BackgroundTransparency = 1
 label.Text = def.label
 label.TextColor3 = Color3.fromRGB(160, 32, 240)
 label.Font = Enum.Font.GothamBold
 label.TextSize = 10
 label.TextWrapped = true
 label.TextXAlignment = Enum.TextXAlignment.Center
 label.TextYAlignment = Enum.TextYAlignment.Center
 label.ZIndex = 102

stackWrappers[def.key] = btn

local btnState = false
 local function setOn(on)
 btnState = on
 if on then
 btnStroke.Color = Color3.fromRGB(160, 32, 240)
 btnStroke.Transparency = 0
 btnStroke.Thickness = 2
 TweenService:Create(label, TweenInfo.new(0.12), {TextColor3 = Color3.fromRGB(200, 255, 200)}):Play()
 else
 btnStroke.Color = Color3.fromRGB(80, 0, 120)
 btnStroke.Transparency = 0.3
 btnStroke.Thickness = 1.5
 TweenService:Create(label, TweenInfo.new(0.12), {TextColor3 = Color3.fromRGB(160, 32, 240)}):Play()
 end
 end
 stackBtnRefs[def.key] = {setOn = setOn}

local function onTap()
 if def.key == "tpDown" then doTpDown(); return end
 if def.key == "carrySpeed" then
 State.speedToggled = not State.speedToggled
 setOn(State.speedToggled)
 return
 end
 if def.key == "laggerCarry" then
 State.laggerEnabled = not State.laggerEnabled
 setOn(State.laggerEnabled)
 if State.laggerEnabled then
 State._prevCarry = State.carrySpeed
 State._prevSpeed = State.speedToggled
 State.speedToggled = false
 if stackBtnRefs.carrySpeed then stackBtnRefs.carrySpeed.setOn(false) end
 if carryBox then carryBox.Text = tostring(State.laggerSpeed) end
 else
 State.carrySpeed = State._prevCarry or 30
 State.speedToggled = State._prevSpeed or false
 if carryBox then carryBox.Text = tostring(State.carrySpeed) end
 if stackBtnRefs.carrySpeed then stackBtnRefs.carrySpeed.setOn(State.speedToggled) end
 end
 return
 end
 local ns = not btnState; setOn(ns)
 if def.key == "autoLeft" then
 State.autoLeftEnabled = ns
 if ns and State.batAimbotToggled then State.batAimbotToggled=false; stopBatAimbot(); if stackBtnRefs.aimbot then stackBtnRefs.aimbot.setOn(false) end end
 if ns then startAutoLeft() else stopAutoLeft() end
 elseif def.key == "autoRight" then
 State.autoRightEnabled = ns
 if ns and State.batAimbotToggled then State.batAimbotToggled=false; stopBatAimbot(); if stackBtnRefs.aimbot then stackBtnRefs.aimbot.setOn(false) end end
 if ns then startAutoRight() else stopAutoRight() end
 elseif def.key == "aimbot" then
 State.batAimbotToggled = ns
 if ns then
 if State.autoLeftEnabled then State.autoLeftEnabled=false; stopAutoLeft(); if stackBtnRefs.autoLeft then stackBtnRefs.autoLeft.setOn(false) end end
 if State.autoRightEnabled then State.autoRightEnabled=false; stopAutoRight(); if stackBtnRefs.autoRight then stackBtnRefs.autoRight.setOn(false) end end
 pcall(startBatAimbot)
 else stopBatAimbot() end
 elseif def.key == "lagger" then
 State.laggerEnabled = ns
 if ns then
 State._prevCarry = State.carrySpeed
 State._prevSpeed = State.speedToggled
 State.speedToggled = false
 if stackBtnRefs.carrySpeed then stackBtnRefs.carrySpeed.setOn(false) end
 if carryBox then carryBox.Text = tostring(State.laggerSpeed) end
 else
 State.carrySpeed = State._prevCarry or 30
 State.speedToggled = State._prevSpeed or false
 if carryBox then carryBox.Text = tostring(State.carrySpeed) end
 if stackBtnRefs.carrySpeed then stackBtnRefs.carrySpeed.setOn(State.speedToggled) end
 end
 elseif def.key == "drop" then
 if ns then runDropBrainrot() else stopDropBrainrot() end
 end
 end

btn.MouseButton1Click:Connect(onTap)
 makeStackDraggable(btn, onTap)
 end

local _origApplyVisible = applyStackButtonsVisible
 applyStackButtonsVisible = function(visible)
 mbPanel.Visible = visible
 State.stackButtonsHidden = not visible
 end

-- ============================================================
 -- HELPERS & FUNCTIONS
 -- ============================================================
 local function resetProgressBar()
 if stealProgressBar then
 updateStealProgress(0)
 hideStealProgressBar()
 end
 end

doTpDown = function()
 pcall(function()
 local c=LP.Character; if not c then return end
 local root=c:FindFirstChild("HumanoidRootPart"); if not root then return end
 local rp=RaycastParams.new(); rp.FilterDescendantsInstances={c}; rp.FilterType=Enum.RaycastFilterType.Exclude
 local res=workspace:Raycast(root.Position,Vector3.new(0,-1000,0),rp)
 if res then root.CFrame=CFrame.new(res.Position+Vector3.new(0,root.Size.Y/2+0.5,0)); root.AssemblyLinearVelocity=Vector3.zero end
 end)
 end

-- ============================================================
 -- DROP BRAINROT
 -- ============================================================
 local _dropConns={}
 runDropBrainrot=function()
 if State.dropEnabled then return end; State.dropEnabled=true
 if stackBtnRefs.drop then stackBtnRefs.drop.setOn(true) end
 task.spawn(function()
 local colConn=RunService.Stepped:Connect(function()
 if not State.dropEnabled then return end
 for _,p in ipairs(Players:GetPlayers()) do
 if p~=LP and p.Character then
 for _,part in ipairs(p.Character:GetChildren()) do if part:IsA("BasePart") then part.CanCollide=false end end
 end
 end
 end)
 table.insert(_dropConns,colConn)
 task.spawn(function()
 while State.dropEnabled do
 RunService.Heartbeat:Wait()
 local c=LP.Character; local root=c and c:FindFirstChild("HumanoidRootPart")
 if not root then continue end
 local vel=root.Velocity
 root.Velocity=vel*10000+Vector3.new(0,10000,0)
 RunService.RenderStepped:Wait()
 if root and root.Parent then root.Velocity=vel end
 RunService.Stepped:Wait()
 if root and root.Parent then root.Velocity=vel+Vector3.new(0,0.1,0) end
 end
 end)
 task.wait(DROP_AUTO_OFF_DELAY); stopDropBrainrot()
 end)
 end
 stopDropBrainrot=function()
 State.dropEnabled=false
 for _,cn in ipairs(_dropConns) do pcall(function() cn:Disconnect() end) end; _dropConns={}
 if stackBtnRefs.drop then stackBtnRefs.drop.setOn(false) end
 end

-- ============================================================
 -- CURSED HUB AIMBOT (from leaked script)
 -- ============================================================
 local AUTO_BAT_SPEED = 58
 local AUTO_BAT_VERT_SPEED = 52
 local AUTO_BAT_DIST = -2.8
 local AUTO_BAT_HEIGHT = 4.75
 local AUTO_BAT_V_OFF = 1
 local AUTO_BAT_TURN_SPEED = 285
 local AUTO_BAT_MAX_TURN_RATE = 28

local autoBatConnection = nil
 local autoBatEquipped = false
 local _autoBatTarget = nil
 local _autoBatLastScan = 0
 local batTool = nil

local function getCharacter() return LP.Character end

local function getHumanoid()
 local char = getCharacter()
 return char and char:FindFirstChildOfClass("Humanoid")
 end

local function getRootPart()
 local char = getCharacter()
 return char and char:FindFirstChild("HumanoidRootPart")
 end

local function getAutoBatTarget()
 local root = getRootPart()
 if not root then return nil end
 local now = tick()
 if now - _autoBatLastScan <= 0.1 and _autoBatTarget and _autoBatTarget.Parent then
 local hum = _autoBatTarget.Parent:FindFirstChildOfClass("Humanoid")
 if hum and hum.Health > 0 then
 return _autoBatTarget
 end
 end
 _autoBatLastScan = now
 _autoBatTarget = nil
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
 _autoBatTarget = closest
 return _autoBatTarget
 end

local function findBat()
 local char = getCharacter()
 if not char then return nil end
 for _, tool in ipairs(char:GetChildren()) do
 if tool:IsA("Tool") then
 local name = tool.Name:lower()
 if name:find("bat") or name:find("slap") then
 return tool
 end
 end
 end
 local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
 if bp then
 for _, tool in ipairs(bp:GetChildren()) do
 if tool:IsA("Tool") then
 local name = tool.Name:lower()
 if name:find("bat") or name:find("slap") then
 return tool
 end
 end
 end
 end
 return nil
 end

local function ensureBatEquipped()
 local char = getCharacter()
 local hum = getHumanoid()
 if not char or not hum then return end
 if not char:FindFirstChildOfClass("Tool") then
 local bat = findBat()
 if bat then
 pcall(function() hum:EquipTool(bat) end)
 batTool = bat
 end
 else
 batTool = char:FindFirstChildOfClass("Tool")
 end
 end

local function resetAutoBatMotion()
 local root = getRootPart()
 local hum = getHumanoid()
 if root then
 root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.3
 root.AssemblyAngularVelocity = Vector3.zero
 end
 if hum then hum.AutoRotate = true end
 end

startBatAimbot = function()
 if autoBatConnection then return end
 autoBatConnection = RunService.Heartbeat:Connect(function()
 if not State.batAimbotToggled then return end

local char = getCharacter()
 local hum = getHumanoid()
 local root = getRootPart()
 if not char or not hum or not root then return end

if not autoBatEquipped then
 autoBatEquipped = true
 ensureBatEquipped()
 end

local target = getAutoBatTarget()
 if target then
 local targetVel = target.AssemblyLinearVelocity
 local aimTargetPos = target.Position + (targetVel * math.clamp(targetVel.Magnitude / 130, 0.05, 0.15)) + Vector3.new(0, AUTO_BAT_V_OFF, 0)

hum.AutoRotate = false

local look = aimTargetPos - root.Position
 local flatLook = Vector3.new(look.X, 0, look.Z)

if look.Magnitude > 0.01 and flatLook.Magnitude > 0.01 then
 local targetYaw = math.deg(math.atan2(-flatLook.X, -flatLook.Z))
 local yawDelta = (targetYaw - root.Orientation.Y + 180) % 360 - 180
 local targetPitch = math.deg(math.atan2(look.Y, flatLook.Magnitude))
 local pitchDelta = (targetPitch - root.Orientation.X + 180) % 360 - 180

local yawRate = math.clamp(math.rad(yawDelta) * AUTO_BAT_TURN_SPEED, -AUTO_BAT_MAX_TURN_RATE, AUTO_BAT_MAX_TURN_RATE)
 local pitchRate = math.clamp(math.rad(pitchDelta) * AUTO_BAT_TURN_SPEED, -AUTO_BAT_MAX_TURN_RATE, AUTO_BAT_MAX_TURN_RATE)

local yawRad = math.rad(root.Orientation.Y)
 local rightAxis = Vector3.new(math.cos(yawRad), 0, -math.sin(yawRad))
 root.AssemblyAngularVelocity = Vector3.new(0, yawRate, 0) + (rightAxis * pitchRate)
 else
 root.AssemblyAngularVelocity = Vector3.zero
 end

local dir = look.Magnitude > 0.01 and look.Unit or Vector3.zero
 local standPos = aimTargetPos - (dir * AUTO_BAT_DIST) + Vector3.new(0, AUTO_BAT_HEIGHT, 0)
 local moveDir = standPos - root.Position
 local hDir = Vector3.new(moveDir.X, 0, moveDir.Z)
 local hVel = hDir.Magnitude > 0.1 and hDir.Unit * AUTO_BAT_SPEED or Vector3.zero
 local vVel = math.abs(moveDir.Y) > 0.1 and Vector3.new(0, math.sign(moveDir.Y) * AUTO_BAT_VERT_SPEED, 0) or Vector3.new(0, -2, 0)
 root.AssemblyLinearVelocity = hVel + vVel
 if hDir.Magnitude > 0.5 then
 hum:Move(hDir.Unit, false)
 end

if State.autoSwingEnabled and (root.Position - target.Position).Magnitude < 6 then
 local bat = findBat() or batTool
 if bat and bat:IsA("Tool") then
 pcall(function() bat:Activate() end)
 end
 end
 else
 hum.AutoRotate = true
 root.AssemblyAngularVelocity = Vector3.zero
 root.AssemblyLinearVelocity = Vector3.zero
 end
 end)
 end

stopBatAimbot = function()
 if autoBatConnection then
 autoBatConnection:Disconnect()
 autoBatConnection = nil
 end
 resetAutoBatMotion()
 autoBatEquipped = false
 end

-- Character respawn handler for auto bat
 LP.CharacterAdded:Connect(function()
 autoBatEquipped = false
 if State.batAimbotToggled then
 task.wait(0.5)
 ensureBatEquipped()
 end
 end)

-- ============================================================
 -- BAT COUNTER
 -- ============================================================
 local BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}

local function findBatForCounter()
 local c=LP.Character; if not c then return nil end
 local bp=LP:FindFirstChildOfClass("Backpack")
 for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do
 local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
 if t then return t end
 end
 for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
 if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
 return nil
 end

local function swingBatForCounter(bat,char)
 local hum2=char:FindFirstChildOfClass("Humanoid")
 if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end; task.wait(0.05) end
 local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
 if remote and remote:IsA("RemoteEvent") then
 pcall(function() remote:FireServer() end); task.wait(0.15); pcall(function() remote:FireServer() end)
 else pcall(function() bat:Activate() end); task.wait(0.15); pcall(function() bat:Activate() end) end
 end

startBatCounter=function()
 if Conns.batCounter then return end
 Conns.batCounter=RunService.Heartbeat:Connect(function()
 if not State.batCounterEnabled then return end
 if State.batCounterDebounce then return end
 local char=LP.Character; if not char then return end
 local hum2=char:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
 local st=hum2:GetState()
 local isRagdolled=stEnum.HumanoidStateType.Physics or stEnum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown
 if isRagdolled then
 State.batCounterDebounce=true
 task.spawn(function()
 local bat=findBatForCounter()
 if bat then swingBatForCounter(bat,char) end
 task.wait(0.5); State.batCounterDebounce=false
 end)
 end
 end)
 end
 stopBatCounter=function()
 if Conns.batCounter then Conns.batCounter:Disconnect(); Conns.batCounter=nil end
 State.batCounterDebounce=false
 end

-- ============================================================
 -- MEDUSA
 -- ============================================================
 local function findMedusa()
 local c=LP.Character; if not c then return nil end
 for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
 local bp=LP:FindFirstChild("Backpack")
 if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
 return nil
 end
 local function useMedusaCounter()
 if State.medusaDebounce then return end; if tick()-State.medusaLastUsed<MEDUSA_COOLDOWN then return end
 local c=LP.Character; if not c then return end; State.medusaDebounce=true
 local med=findMedusa(); if not med then State.medusaDebounce=false; return end
 if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:EquipTool(med) end end
 pcall(function() med:Activate() end); State.medusaLastUsed=tick(); State.medusaDebounce=false
 end
 local function onAnchorChanged(part) return part:GetPropertyChangedSignal("Anchored"):Connect(function() if part.Anchored and part.Transparency==1 then useMedusaCounter() end end) end
 setupMedusaCounter=function(char)
 stopMedusaCounter(); if not char then return end
 for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end
 table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end))
 end
 stopMedusaCounter=function() for _,c2 in pairs(Conns.anchor) do pcall(function() c2:Disconnect() end) end; Conns.anchor={} end

-- ============================================================
 -- AUTO LEFT / RIGHT
 -- ============================================================
 startAutoLeft=function()
 if Conns.autoLeft then Conns.autoLeft:Disconnect() end; State.autoLeftPhase=1
 Conns.autoLeft=RunService.Heartbeat:Connect(function()
 if not State.autoLeftEnabled then return end; local c=LP.Character; if not c then return end
 local root=c:FindFirstChild("HumanoidRootPart"); local hum2=c:FindFirstChildOfClass("Humanoid"); if not root or not hum2 then return end
 local spd=State.normalSpeed
 if State.autoLeftPhase1 then
 local tgt=Vector3.new(POS.L1.X,root.Position.Y,POS.L1.Z); if (tgt-root.Position).Magnitude<1 then State.autoLeftPhase=2; local d=(POS.L2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.Xspd,root.AssemblyLinearVelocity.Y,mv.Zspd); return end
 local d=(POS.L1-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.Xspd,root.AssemblyLinearVelocity.Y,mv.Zspd)
 elseif State.autoLeftPhase2 then
 local tgt=Vector3.new(POS.L2.X,root.Position.Y,POS.L2.Z); if (tgt-root.Position).Magnitude<1 then hum2:Move(Vector3.zero,false); root.AssemblyLinearVelocity=Vector3.zero; State.autoLeftEnabled=false; if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end; State.autoLeftPhase=1; if stackBtnRefs.autoLeft then stackBtnRefs.autoLeft.setOn(false) end; if (POS.L_FACE-root.Position).Magnitude>0.01 then root.CFrame=CFrame.new(root.Position,Vector3.new(POS.L_FACE.X,root.Position.Y,POS.L_FACE.Z)) end; return end
 local d=(POS.L2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.Xspd,root.AssemblyLinearVelocity.Y,mv.Zspd)
 end
 end)
 end
 stopAutoLeft=function()
 if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end; State.autoLeftPhase=1
 local c=LP.Character; if c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:Move(Vector3.zero,false) end end
 if stackBtnRefs.autoLeft then stackBtnRefs.autoLeft.setOn(false) end
 end

startAutoRight=function()
 if Conns.autoRight then Conns.autoRight:Disconnect() end; State.autoRightPhase=1
 Conns.autoRight=RunService.Heartbeat:Connect(function()
 if not State.autoRightEnabled then return end; local c=LP.Character; if not c then return end
 local root=c:FindFirstChild("HumanoidRootPart"); local hum2=c:FindFirstChildOfClass("Humanoid"); if not root or not hum2 then return end
 local spd=State.normalSpeed
 if State.autoRightPhase1 then
 local tgt=Vector3.new(POS.R1.X,root.Position.Y,POS.R1.Z); if (tgt-root.Position).Magnitude<1 then State.autoRightPhase=2; local d=(POS.R2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.Xspd,root.AssemblyLinearVelocity.Y,mv.Zspd); return end
 local d=(POS.R1-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.Xspd,root.AssemblyLinearVelocity.Y,mv.Zspd)
 elseif State.autoRightPhase2 then
 local tgt=Vector3.new(POS.R2.X,root.Position.Y,POS.R2.Z); if (tgt-root.Position).Magnitude<1 then hum2:Move(Vector3.zero,false); root.AssemblyLinearVelocity=Vector3.zero; State.autoRightEnabled=false; if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end; State.autoRightPhase=1; if stackBtnRefs.autoRight then stackBtnRefs.autoRight.setOn(false) end; if (POS.R_FACE-root.Position).Magnitude>0.01 then root.CFrame=CFrame.new(root.Position,Vector3.new(POS.R_FACE.X,root.Position.Y,POS.R_FACE.Z)) end; return end
 local d=(POS.R2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.Xspd,root.AssemblyLinearVelocity.Y,mv.Zspd)
 end
 end)
 end
 stopAutoRight=function()
 if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end; State.autoRightPhase=1
 local c=LP.Character; if c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:Move(Vector3.zero,false) end end
 if stackBtnRefs.autoRight then stackBtnRefs.autoRight.setOn(false) end
 end

-- ============================================================
 -- ANTI RAGDOLL
 -- ============================================================
 startAntiRagdoll=function()
 if Conns.antiRag then return end
 Conns.antiRag=RunService.Heartbeat:Connect(function()
 if not State.antiRagdollEnabled then return end
 local c=LP.Character; if not c then return end
 local hum2=c:FindFirstChildOfClass("Humanoid"); local root=c:FindFirstChild("HumanoidRootPart")
 if not hum2 or not root then return end; if hum2.Health<=0 then return end
 local st=hum2:GetState(); if stEnum.HumanoidStateType.Dead then return end
 if stEnum.HumanoidStateType.Physics or stEnum.HumanoidStateType.Ragdoll or stEnum.HumanoidStateType.FallingDown then
 pcall(function() hum2:ChangeState(Enum.HumanoidStateType.GettingUp) end)
 pcall(function() workspace.CurrentCamera.CameraSubject=hum2 end)
 pcall(function() local PM=LP.PlayerScripts:FindFirstChild("PlayerModule"); if PM then local CM=require(PM:FindFirstChild("ControlModule")); if CM then CM:Enable() end end end)
 root.AssemblyLinearVelocity=Vector3.new(0,0,0); root.RotVelocity=Vector3.new(0,0,0)
 end
 for _,obj in ipairs(c:GetDescendants()) do pcall(function() if obj:IsA("Motor6D") and obj.Enabled==false then obj.Enabled=true end end) end
 end)
 end
 stopAntiRagdoll=function() if Conns.antiRag then Conns.antiRag:Disconnect(); Conns.antiRag=nil end end

-- ============================================================
 -- UNWALK
 -- ============================================================
 local unwalkAnimations = {}
 local function disableAnimations()
 local char = LP.Character; if not char then return end
 local hum2 = char:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
 for _, track in pairs(unwalkAnimations) do pcall(function() track:Stop() end) end
 unwalkAnimations = {}
 local animator = hum2:FindFirstChildOfClass("Animator")
 if animator then
 for _, track in pairs(animator:GetPlayingAnimationTracks()) do
 track:Stop(); table.insert(unwalkAnimations, track)
 end
 end
 end
 local function enableAnimations() unwalkAnimations = {} end

RunService.Heartbeat:Connect(function()
 if not State.unwalkEnabled then return end
 disableAnimations()
 end)

-- ============================================================
 -- FPS BOOST
 -- ============================================================
 applyFPSBoost=function()
 pcall(function() setfpscap(999999999) end)
 local function pO(v) pcall(function()
 if v:IsA("Model") then v.LevelOfDetail=Enum.ModelLevelOfDetail.Disabled; v.ModelStreamingMode=Enum.ModelStreamingMode.Nonatomic
 elseif v:IsA("MeshPart") then v.CastShadow=false; v.DoubleSided=false; v.RenderFidelity=Enum.RenderFidelity.Performance
 elseif v:IsA("BasePart") then v.CastShadow=false; v.Material=Enum.Material.Plastic; v.Reflectance=0
 elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency=1
 elseif v:IsA("SpecialMesh") then v.TextureId=""
 elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled=false
 elseif v:IsA("SurfaceAppearance") or v:IsA("MaterialVariant") then v:Destroy()
 elseif v:IsA("Attachment") then v.Visible=false end
 end) end
 for _,v in pairs(workspace:GetDescendants()) do pO(v) end
 pcall(function()
 local L=game:GetService("Lighting")
 for _,v in pairs(L:GetDescendants()) do pcall(function() if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Clouds") or v:IsA("PostEffect") or v:IsA("ColorCorrectionEffect") then v:Destroy() end end) end
 pcall(function() sethiddenproperty(L,"Technology",Enum.Technology.Legacy) end)
 L.GlobalShadows=false; L.FogEnd=9e9; L.Brightness=0
 local ter=workspace:FindFirstChildOfClass("Terrain")
 if ter then pcall(function() sethiddenproperty(ter,"Decoration",false) end); ter.WaterReflectance=0; ter.WaterTransparency=0.7; ter.WaterWaveSize=0; ter.WaterWaveSpeed=0 end
 end)
 workspace.DescendantAdded:Connect(function(v) if State.fpsBoostEnabled then task.spawn(pO,v) end end)
 end

-- ============================================================
 -- STEAL
 -- ============================================================
 local function isMyPlotByName2(pn)
 local ct=tick(); if Steal.plotCache[pn] and (ct-(Steal.plotCacheTime[pn] or 0))<PLOT_CACHE_DURATION then return Steal.plotCache[pn] end
 local plots=workspace:FindFirstChild("Plots"); if not plots then Steal.plotCache[pn]=false; Steal.plotCacheTime[pn]=ct; return false end
 local plot=plots:FindFirstChild(pn); if not plot then Steal.plotCache[pn]=false; Steal.plotCacheTime[pn]=ct; return false end
 local sign=plot:FindFirstChild("PlotSign"); if sign then local yb=sign:FindFirstChild("YourBase"); if yb and yb:IsA("BillboardGui") then local r=yb.Enabled==true; Steal.plotCache[pn]=r; Steal.plotCacheTime[pn]=ct; return r end end
 Steal.plotCache[pn]=false; Steal.plotCacheTime[pn]=ct; return false
 end
 local function findNearestPrompt2()
 local c=LP.Character; if not c then return nil end; local root=c:FindFirstChild("HumanoidRootPart"); if not root then return nil end
 local ct=tick(); if ct-Steal.promptCacheTime<PROMPT_CACHE_REFRESH and #Steal.cachedPrompts>0 then local np,nd=nil,math.huge; for _,data in ipairs(Steal.cachedPrompts) do if data.spawn then local dist=(data.spawn.Position-root.Position).Magnitude; if dist<=Steal.StealRadius and dist<nd then np=data.prompt; nd=dist end end end; if np then return np end end
 Steal.cachedPrompts={}; Steal.promptCacheTime=ct; local plots=workspace:FindFirstChild("Plots"); if not plots then return nil end; local np,nd=nil,math.huge
 for _,plot in ipairs(plots:GetChildren()) do if isMyPlotByName2(plot.Name) then continue end; local pods=plot:FindFirstChild("AnimalPodiums"); if not pods then continue end
 for _,pod in ipairs(pods:GetChildren()) do pcall(function() local base=pod:FindFirstChild("Base"); local sp=base and base:FindFirstChild("Spawn"); if sp then local att=sp:FindFirstChild("PromptAttachment"); if att then for _,child in ipairs(att:GetChildren()) do if child:IsA("ProximityPrompt") then local dist=(sp.Position-root.Position).Magnitude; table.insert(Steal.cachedPrompts,{prompt=child,spawn=sp}); if dist<=Steal.StealRadius and dist<nd then np=child; nd=dist end; break end end end end end) end
 end; return np
 end
 local function executeSteal2(prompt)
 local ct=tick(); if ct-State.lastStealTick<STEAL_COOLDOWN then return end; if State.isStealing then return end
 if not Steal.Data[prompt] then Steal.Data[prompt]={hold={},trigger={},ready=true}; pcall(function() if getconnections then for _,c2 in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do if c2.Function then table.insert(Steal.Data[prompt].hold,c2.Function) end end; for _,c2 in ipairs(getconnections(prompt.Triggered)) do if c2.Function then table.insert(Steal.Data[prompt].trigger,c2.Function) end end else Steal.Data[prompt].useFallback=true end end) end
 local data=Steal.Data[prompt]; if not data.ready then return end; data.ready=false; State.isStealing=true; State.stealStartTime=ct; State.lastStealTick=ct

showStealProgressBar()

if Conns.progress then Conns.progress:Disconnect() end
 Conns.progress = RunService.Heartbeat:Connect(function()
 if not State.isStealing then
 Conns.progress:Disconnect()
 return
 end
 local prog = math.clamp((tick() - State.stealStartTime) / Steal.StealDuration, 0, 1)
 updateStealProgress(prog)
 end)

task.spawn(function()
 local ok=false; pcall(function() if not data.useFallback then for _,fn in ipairs(data.hold) do task.spawn(fn) end; task.wait(Steal.StealDuration); for _,fn in ipairs(data.trigger) do task.spawn(fn) end; ok=true end end)
 if not ok and fireproximityprompt then pcall(function() fireproximityprompt(prompt); ok=true end) end
 if not ok then pcall(function() prompt:InputHoldBegin(); task.wait(Steal.StealDuration); prompt:InputHoldEnd() end) end
 task.wait(Steal.StealDuration*0.3)
 if Conns.progress then Conns.progress:Disconnect() end
 resetProgressBar()
 hideStealProgressBar()
 task.wait(0.05)
 data.ready=true
 State.isStealing=false
 end)
 end

startAutoSteal = function()
 if Conns.autoSteal then return end
 Conns.autoSteal=RunService.Heartbeat:Connect(function() if not Steal.AutoStealEnabled or State.isStealing then return end; local p=findNearestPrompt2(); if p then executeSteal2(p) end end)
 end

stopAutoSteal = function()
 if Conns.autoSteal then Conns.autoSteal:Disconnect(); Conns.autoSteal=nil end
 State.isStealing=false; State.lastStealTick=0; Steal.plotCache={}; Steal.plotCacheTime={}; Steal.cachedPrompts={}
 resetProgressBar()
 hideStealProgressBar()
 end

-- ============================================================
 -- SAVE/LOAD CONFIG
 -- ============================================================
 saveConfig = function()
 local cfg = {
 normalSpeed = State.normalSpeed,
 carrySpeed = State.carrySpeed,
 laggerSpeed = State.laggerSpeed,
 stealRadius = Steal.StealRadius,
 stealDuration = Steal.StealDuration,
 uiScale = uiScaleObj and uiScaleObj.Scale or 1.0,
 stackButtonsHidden = State.stackButtonsHidden,
 speedKey = Keys.speed.Name,
 autoLeftKey = Keys.autoLeft.Name,
 autoRightKey = Keys.autoRight.Name,
 guiHideKey = Keys.guiHide.Name,
 dropKey = Keys.drop.Name,
 laggerKey = Keys.lagger.Name,
 tpDownKey = Keys.tpDown.Name,
 aimbotKey = Keys.aimbot.Name,
 infJump = State.infJumpEnabled,
 antiRagdoll = State.antiRagdollEnabled,
 fpsBoost = State.fpsBoostEnabled,
 fovBoost = State.fovBoostEnabled,
 medusaCounter = State.medusaCounterEnabled,
 batCounter = State.batCounterEnabled,
 autoStealEnabled = Steal.AutoStealEnabled,
 separateButtonMovement = State.separateButtonMovement,
 autoSwingEnabled = State.autoSwingEnabled,
 }
 local ok, encoded = pcall(function() return HttpService:JSONEncode(cfg) end)
 if ok then pcall(function() _writefile(CONFIG_FILE, encoded) end) end
 end

loadConfig = function()
 local hasFile = false
 pcall(function() hasFile = _isfile(CONFIG_FILE) end)
 if not hasFile then return end

local raw
 local ok = pcall(function() raw = _readfile(CONFIG_FILE) end)
 if not ok or not raw then return end

local cfg; local ok2 = pcall(function() cfg = HttpService:JSONDecode(raw) end)
 if not ok2 or not cfg then return end

if cfg.normalSpeed then State.normalSpeed = cfg.normalSpeed; if normalBox then normalBox.Text = tostring(cfg.normalSpeed) end end
 if cfg.carrySpeed then State.carrySpeed = cfg.carrySpeed; if carryBox then carryBox.Text = tostring(cfg.carrySpeed) end end
 if cfg.laggerSpeed then State.laggerSpeed = cfg.laggerSpeed; if laggerBox then laggerBox.Text = tostring(cfg.laggerSpeed) end end
 if cfg.stealRadius then Steal.StealRadius = cfg.stealRadius end
 if cfg.stealDuration then Steal.StealDuration = cfg.stealDuration end
 if cfg.uiScale and uiScaleObj then
 uiScaleObj.Scale = cfg.uiScale
 if uiScaleBox then uiScaleBox.Text = tostring(cfg.uiScale) end
 end
 if cfg.stackButtonsHidden then
 applyStackButtonsVisible(false)
 if setHideButtonsToggle then setHideButtonsToggle(true) end
 end

if cfg.separateButtonMovement ~= nil then
 State.separateButtonMovement = cfg.separateButtonMovement
 end

if cfg.autoSwingEnabled ~= nil then
 State.autoSwingEnabled = cfg.autoSwingEnabled
 if setAutoSwing then setAutoSwing(cfg.autoSwingEnabled) end
 end

local function tryKey(field, keyTarget)
 if cfg[field] and Enum.KeyCode[cfg[field]] then
 local kc = Enum.KeyCode[cfg[field]]
 Keys[keyTarget] = kc
 if keybindBtnRefs[keyTarget] then
 keybindBtnRefs[keyTarget].Text = getKeyDisplayName(kc)
 end
 end
 end
 tryKey("speedKey", "speed")
 tryKey("autoLeftKey", "autoLeft")
 tryKey("autoRightKey","autoRight")
 tryKey("guiHideKey", "guiHide")
 tryKey("dropKey", "drop")
 tryKey("laggerKey", "lagger")
 tryKey("tpDownKey", "tpDown")
 tryKey("aimbotKey", "aimbot")

if cfg.autoStealEnabled then Steal.AutoStealEnabled = true; if setInstaGrab then setInstaGrab(true) end; pcall(startAutoSteal) end
 if cfg.infJump then State.infJumpEnabled = true; if setInfJump then setInfJump(true) end end
 if cfg.antiRagdoll then State.antiRagdollEnabled = true; if setAntiRag then setAntiRag(true) end; startAntiRagdoll() end
 if cfg.fpsBoost then State.fpsBoostEnabled = true; if setFps then setFps(true) end; applyFPSBoost() end
 if cfg.fovBoost then State.fovBoostEnabled = true; if setFovBoost then setFovBoost(true) end; enableFovBoost() end
 if cfg.medusaCounter then State.medusaCounterEnabled = true; if setMedusaCounter then setMedusaCounter(true) end; setupMedusaCounter(LP.Character) end
 if cfg.batCounter then State.batCounterEnabled = true; if setBatCounter then setBatCounter(true) end; startBatCounter() end
 end

-- ============================================================
 -- CHARACTER SETUP
 -- ============================================================
 local function setupChar(char)
 task.wait(0.1)
 h=char:WaitForChild("Humanoid",5)
 hrp=char:WaitForChild("HumanoidRootPart",5)
 if not h or not hrp then return end

local head=char:FindFirstChild("Head")
 if head then
 local oldBB=head:FindFirstChild("SKM DUEL BB"); if oldBB then oldBB:Destroy() end

local bb=Instance.new("BillboardGui", head)
 bb.Name="SKM DUEL BB"
 bb.Size=UDim2.new(0, 160, 0, 52)
 bb.StudsOffset=Vector3.new(0, 3, 0)
 bb.AlwaysOnTop=true

local speedBillLbl=Instance.new("TextLabel", bb)
 speedBillLbl.Name="SpeedBillLbl"
 speedBillLbl.Size=UDim2.new(1, 0, 0, 24)
 speedBillLbl.Position=UDim2.new(0, 0, 0, 0)
 speedBillLbl.BackgroundTransparency=1
 speedBillLbl.Text="0.0"
 speedBillLbl.TextColor3=Color3.fromRGB(160, 32, 240)
 speedBillLbl.Font=Enum.Font.GothamBlack
 speedBillLbl.TextScaled=true
 speedBillLbl.TextStrokeTransparency=0.1
 speedBillLbl.TextStrokeColor3=Color3.new(0, 0, 0)

local lbl2=Instance.new("TextLabel", bb)
 lbl2.Size=UDim2.new(1, 0, 0, 24)
 lbl2.Position=UDim2.new(0, 0, 0, 28)
 lbl2.BackgroundTransparency=1
 lbl2.Text="SKM DUEL"
 lbl2.TextColor3=Color3.fromRGB(160, 32, 240)
 lbl2.Font=Enum.Font.GothamBold
 lbl2.TextScaled=true
 lbl2.TextStrokeTransparency=0.1
 lbl2.TextStrokeColor3=Color3.new(0, 0, 0)
 end

if Conns.unwalk then Conns.unwalk:Disconnect(); Conns.unwalk=nil end
 if State.unwalkEnabled then task.spawn(function() task.wait(0.5); disableAnimations() end) end
 stopAntiRagdoll()
 if State.antiRagdollEnabled then task.wait(0.5); startAntiRagdoll() end
 if State.medusaCounterEnabled then setupMedusaCounter(char) end
 if State.batAimbotToggled then stopBatAimbot(); task.wait(0.2); pcall(startBatAimbot) end
 if State.batCounterEnabled then task.wait(0.3); startBatCounter() end
 end

LP.CharacterAdded:Connect(setupChar)
 if LP.Character then task.spawn(function() setupChar(LP.Character) end) end

-- Also update progress bar when character respawns
 LP.CharacterAdded:Connect(function()
 createStealProgressBar()
 end)

createStealProgressBar()

-- ============================================================
 -- RUNTIME LOOPS
 -- ============================================================
 RunService.Stepped:Connect(function()
 for _,p in ipairs(Players:GetPlayers()) do
 if p~=LP and p.Character then
 for _,part in ipairs(p.Character:GetChildren()) do if part:IsA("BasePart") then part.CanCollide=false end end
 end
 end
 end)

UIS.JumpRequest:Connect(function()
 if not State.infJumpEnabled then return end
 local c=LP.Character; if not c then return end; local root=c:FindFirstChild("HumanoidRootPart")
 if root then root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 55, root.AssemblyLinearVelocity.Z) end
 end)

RunService.RenderStepped:Connect(function()
 if not (h and hrp) then return end; if State._tpInProgress then return end

if not State.batAimbotToggled and not State.autoLeftEnabled and not State.autoRightEnabled then
 local md = h.MoveDirection
 local spd
 if State.laggerEnabled then
 spd = State.laggerSpeed
 elseif State.speedToggled then
 spd = State.carrySpeed
 else
 spd = State.normalSpeed
 end
 if h.WalkSpeed ~= spd then h.WalkSpeed = spd end
 if md.Magnitude > 0 then
 State.lastMoveDir = md
 hrp.AssemblyLinearVelocity = Vector3.new(md.X * spd, hrp.AssemblyLinearVelocity.Y, md.Z * spd)
 elseif State.antiRagdollEnabled and State.lastMoveDir.Magnitude > 0 then
 local anyHeld = false
 for key in pairs(MOVE_KEYS) do if UIS:IsKeyDown(key) then anyHeld = true; break end end
 if anyHeld then
 hrp.AssemblyLinearVelocity = Vector3.new(State.lastMoveDir.X * spd, hrp.AssemblyLinearVelocity.Y, State.lastMoveDir.Z * spd)
 end
 end
 end

pcall(function()
 local head2 = LP.Character and LP.Character:FindFirstChild("Head")
 if head2 then
 local bb2 = head2:FindFirstChild("SKM DUEL BB")
 local sl = bb2 and bb2:FindFirstChild("SpeedBillLbl")
 if sl then
 local hspd = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z).Magnitude
 sl.Text = string.format("%.1f", hspd)
 end
 end
 end)
 end)

-- ============================================================
 -- INPUT
 -- ============================================================
 UIS.InputBegan:Connect(function(inp,gp)
 if gp then return end
 local isKb=inp.UserInputTypeEnum.UserInputType.Keyboard
 local isGp=inp.UserInputTypeEnum.UserInputType.Gamepad1 or inp.UserInputTypeEnum.UserInputType.Gamepad2 or inp.UserInputTypeEnum.UserInputType.Gamepad3 or inp.UserInputTypeEnum.UserInputType.Gamepad4
 if not isKb and not isGp then return end
 local kc=inp.KeyCode; if kcEnum.KeyCode.Unknown then return end

if kcKeys.speed then
 State.speedToggled=not State.speedToggled
 if stackBtnRefs.carrySpeed then stackBtnRefs.carrySpeed.setOn(State.speedToggled) end
 elseif kcKeys.autoLeft then
 State.autoLeftEnabled=not State.autoLeftEnabled
 if stackBtnRefs.autoLeft then stackBtnRefs.autoLeft.setOn(State.autoLeftEnabled) end
 if State.autoLeftEnabled and State.batAimbotToggled then State.batAimbotToggled=false; stopBatAimbot(); if stackBtnRefs.aimbot then stackBtnRefs.aimbot.setOn(false) end end
 if State.autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
 elseif kcKeys.autoRight then
 State.autoRightEnabled=not State.autoRightEnabled
 if stackBtnRefs.autoRight then stackBtnRefs.autoRight.setOn(State.autoRightEnabled) end
 if State.autoRightEnabled and State.batAimbotToggled then State.batAimbotToggled=false; stopBatAimbot(); if stackBtnRefs.aimbot then stackBtnRefs.aimbot.setOn(false) end end
 if State.autoRightEnabled then startAutoRight() else stopAutoRight() end
 elseif kcKeys.drop then
 if not State.dropEnabled then runDropBrainrot() end
 elseif kcKeys.lagger then
 State.laggerEnabled = not State.laggerEnabled
 if stackBtnRefs.lagger then stackBtnRefs.lagger.setOn(State.laggerEnabled) end
 if State.laggerEnabled then
 State._prevCarry = State.carrySpeed
 State._prevSpeed = State.speedToggled
 State.speedToggled = false
 if stackBtnRefs.carrySpeed then stackBtnRefs.carrySpeed.setOn(false) end
 if carryBox then carryBox.Text = tostring(State.laggerSpeed) end
 else
 State.carrySpeed = State._prevCarry or 30
 State.speedToggled = State._prevSpeed or false
 if carryBox then carryBox.Text = tostring(State.carrySpeed) end
 if stackBtnRefs.carrySpeed then stackBtnRefs.carrySpeed.setOn(State.speedToggled) end
 end
 elseif kcKeys.tpDown then
 doTpDown()
 elseif kcKeys.aimbot then
 State.batAimbotToggled=not State.batAimbotToggled
 if State.batAimbotToggled then
 if State.autoLeftEnabled then State.autoLeftEnabled=false; stopAutoLeft(); if stackBtnRefs.autoLeft then stackBtnRefs.autoLeft.setOn(false) end end
 if State.autoRightEnabled then State.autoRightEnabled=false; stopAutoRight(); if stackBtnRefs.autoRight then stackBtnRefs.autoRight.setOn(false) end end
 pcall(startBatAimbot)
 else stopBatAimbot() end
 if stackBtnRefs.aimbot then stackBtnRefs.aimbot.setOn(State.batAimbotToggled) end
 elseif kcKeys.guiHide then
 if isKb then State.guiVisible=not State.guiVisible; mainOuter.Visible=State.guiVisible end
 end
 end)

-- ============================================================
 -- INIT
 -- ============================================================
 loadPresetsFile()
 rebuildPresetList()

loadConfig()

task.spawn(function()
 task.wait(0.3)
 local lastPresetName = loadLastPresetName()
 if lastPresetName and lastPresetName ~= "" then
 for _, preset in ipairs(Presets) do
 if preset.name == lastPresetName then
 applyPreset(preset.data)
 print("[SKM DUEL v1.0] Auto-loaded last preset: " .. lastPresetName)
 break
 end
 end
 end
 end)

task.delay(1, function() pcall(saveConfig) end)

print("[SKM DUEL v1.0] Loaded")
 loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FREE-ZOMBIE-ANIMATION-FOR-R16-GAMES-ONLY-136146"))()