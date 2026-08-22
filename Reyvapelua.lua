local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local UIS          = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService  = game:GetService("HttpService")
local ContentProvider = game:GetService("ContentProvider")
local Lighting     = game:GetService("Lighting")
local Workspace    = game:GetService("Workspace")
local LP           = Players.LocalPlayer
local _isfile    = isfile    or (syn and syn.isfile)    or function() return false end
local _readfile  = readfile  or (syn and syn.readfile)  or function() return nil  end
local _writefile = writefile or (syn and syn.writefile) or function()             end
local getconnections = getconnections or get_signal_cons or getconnects or (syn and syn.get_signal_cons)
local State = {
    normalSpeed=60, carrySpeed=30, laggerSpeed=13, laggerCarrySpeed=13,
    speedType="normal", laggerActive=false, laggerCarryActive=false,
    aimbotActive=false, hittingCooldown=false,
    AIMBOT_SPEED=56.5, HIT_DISTANCE=4.2, SWING_COOLDOWN=0.055,
    BEHIND_DISTANCE=-3, BASE_PREDICTION=0.15, FACING_PREDICTION=1.5,
    PREDICTION_RADIUS_LIMIT=10,
    batCounterEnabled=false, batCounterDebounce=false,
    infJumpEnabled=false, infJumpMode="manual",
    antiRagdollEnabled=false, fpsBoostEnabled=false,
    medusaCounterEnabled=false, medusaLastUsed=0, medusaDebounce=false,
    autoLeftEnabled=false, autoRightEnabled=false,
    autoLeftPhase=1, autoRightPhase=1,
    dropBrainrotActive=false, autoTpDownEnabled=false, autoTpDownY=20,
    guiVisible=true, lastMoveDir=Vector3.new(0,0,0),
    unwalkEnabled=false, animEnabled=false,
    keyAutoLeft=Enum.KeyCode.Unknown, keyAutoRight=Enum.KeyCode.Unknown,
    keyDropBR=Enum.KeyCode.Unknown,   keyTpDown=Enum.KeyCode.Unknown,
    keyAutoBat=Enum.KeyCode.E,        keyGuiHide=Enum.KeyCode.LeftControl,
    -- Extra state
    duelLaggerActive = false,
    bypassActive     = false,
    bypassSpeedBoost = 33.3,
    bypassLagAmount  = 0.028,
    laggerPanelVisible = false,
}
local AutoSteal = {
    Enabled=false, Radius=20, Duration=1.3, IsStealing=false,
    Data={}, ProgressFill=nil, ProgressText=nil,
}
local POS_L1=Vector3.new(-476.48,-6.28,92.73); local POS_L2=Vector3.new(-483.12,-4.95,94.80)
local POS_R1=Vector3.new(-476.16,-6.52,25.62); local POS_R2=Vector3.new(-483.04,-5.09,23.14)
local MEDUSA_COOLDOWN=25
local DROP_ASCEND_DURATION=0.2; local DROP_ASCEND_SPEED=150
local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,[Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}
local AntiRagdollConns={}
local Conns={autoLeft=nil,autoRight=nil,anchor={},batCounter=nil}
local h,hrp,speedLbl
local animHBConn=nil; local savedAnimate=nil; local originalAnims=nil
local setAutoLeft,setAutoRight,setInstaGrab,setAutoBat,setInfJump
local setAntiRag,setFps,setMedusaCounter,setAutoTpDown
local setAnimToggle,setUnwalkToggle,setBatCounter
local setMenuDropBR,setMenuTpDown,setLockToggle,setVisToggle
local setDuelLagUI, setBypassTogUI
local modeValLbl,normalBox,carryBox,laggerBox,laggerCarryBox,radiusBox,progressRadLbl
local setSpeedToggleUI,setLaggerToggleUI,setLaggerCarryUI
local saveConfig,loadConfig,rebuildPresetList,applyPreset
local presetListFrame,presetNameBox
local startAntiRagdoll,stopAntiRagdoll,applyFPSBoost
local startUnwalk,stopUnwalk
local setupMedusaCounter,stopMedusaCounter
local startAutoLeft,stopAutoLeft,startAutoRight,stopAutoRight
local startBatCounter,stopBatCounter
local startAutoSteal,stopAutoSteal
local startAimbot,stopAimbot
local MobileButtons={Visible=true,Locked=true,Containers={},Buttons={}}
local laggerPanelGui=nil
local duelLaggerThread = nil
local function duelBomb(amt)
    local main, spam = {}, {{}}
    local z = spam[1]
    for i = 1, amt do local t = {}; table.insert(z, t); z = t end
    local max = math.min(499999 / (amt + 2), 1500)
    for i = 1, max do table.insert(main, spam) end
    pcall(function() game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(main) end)
end
local function toggleDuelLagger(value)
    State.duelLaggerActive = value
    if value then
        if duelLaggerThread then task.cancel(duelLaggerThread) end
        duelLaggerThread = task.spawn(function()
            while State.duelLaggerActive do
                pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge) end)
                duelBomb(270)
                task.wait(UIS.TouchEnabled and 5.8 or 0.25)
            end
        end)
    else
        if duelLaggerThread then task.cancel(duelLaggerThread); duelLaggerThread = nil end
    end
end
local origWorkspace = {}
local antiLagActive = false
local antiLagDescConn = nil
local function saveWorkspaceState()
    if next(origWorkspace) ~= nil then return end
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") then
            origWorkspace[obj] = { Enabled = obj.Enabled }
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            origWorkspace[obj] = { Transparency = obj.Transparency }
        elseif obj:IsA("BasePart") then
            origWorkspace[obj] = { Material = obj.Material, Reflectance = obj.Reflectance, CastShadow = obj.CastShadow }
        end
    end
end
local function restoreWorkspaceState()
    for obj, props in pairs(origWorkspace) do
        if obj and obj.Parent then pcall(function() for k, v in pairs(props) do obj[k] = v end end) end
    end
    origWorkspace = {}
end
local function bypassProcessObj(obj)
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") then
        pcall(function() obj.Enabled = false end)
    end
    if obj:IsA("Decal") or obj:IsA("Texture") then
        pcall(function() obj.Transparency = 1 end)
    end
    if obj:IsA("BasePart") then
        pcall(function() obj.Material = Enum.Material.Plastic; obj.Reflectance = 0; obj.CastShadow = false end)
    end
end
local function enableAntiLag()
    if antiLagActive then return end
    saveWorkspaceState()
    antiLagActive = true
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    for _, e in pairs(Lighting:GetChildren()) do
        if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
            e.Enabled = false
        end
    end
    for _, obj in pairs(Workspace:GetDescendants()) do bypassProcessObj(obj) end
    if antiLagDescConn then antiLagDescConn:Disconnect() end
    antiLagDescConn = Workspace.DescendantAdded:Connect(function(obj)
        if antiLagActive then task.defer(function()
            if obj and obj.Parent and antiLagActive then bypassProcessObj(obj) end
        end) end
    end)
end
local function disableAntiLag()
    if not antiLagActive then return end
    antiLagActive = false
    if antiLagDescConn then antiLagDescConn:Disconnect(); antiLagDescConn = nil end
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic end)
    restoreWorkspaceState()
end
local function toggleBypass(value)
    State.bypassActive = value
    if value then enableAntiLag() else disableAntiLag() end
end
RunService.RenderStepped:Connect(function()
    if not State.bypassActive then return end
    local char = LP.Character; if not char then return end
    local bhrp = char:FindFirstChild("HumanoidRootPart")
    local bhum = char:FindFirstChildOfClass("Humanoid")
    if bhrp and bhum and bhum.MoveDirection.Magnitude > 0 then
        bhrp.Velocity = Vector3.new(bhum.MoveDirection.X * State.bypassSpeedBoost, bhrp.Velocity.Y, bhum.MoveDirection.Z * State.bypassSpeedBoost)
    end
end)
RunService.RenderStepped:Connect(function()
    if not State.bypassActive or State.bypassLagAmount <= 0 then return end
    local t = tick()
    while tick() - t < State.bypassLagAmount do end
end)
local function refreshUIToggles()
    if setSpeedToggleUI  then setSpeedToggleUI(State.speedType=="carry") end
    if setLaggerToggleUI then setLaggerToggleUI(State.laggerActive) end
    if setLaggerCarryUI  then setLaggerCarryUI(State.laggerCarryActive) end
    if modeValLbl then
        if State.laggerCarryActive then modeValLbl.Text="Lagger Carry"
        elseif State.laggerActive  then modeValLbl.Text="Lagger Normal"
        else modeValLbl.Text=(State.speedType=="normal") and "Normal" or "Carry" end
    end
end
local function deactivateAllSpeedModes()
    if State.speedType=="carry" then State.speedType="normal"; if MobileButtons.Buttons.carrySpeed then MobileButtons.Buttons.carrySpeed(false) end end
    if State.laggerActive then State.laggerActive=false;AutoSteal.Enabled=false;if setInstaGrab then setInstaGrab(false) end;stopAutoSteal();if MobileButtons.Buttons.lagger then MobileButtons.Buttons.lagger(false) end end
    if State.laggerCarryActive then State.laggerCarryActive=false;AutoSteal.Enabled=false;if setInstaGrab then setInstaGrab(false) end;stopAutoSteal();if MobileButtons.Buttons.laggerCarry then MobileButtons.Buttons.laggerCarry(false) end end
end
local function toggleSpeedType()
    if State.speedType=="carry" then State.speedType="normal";refreshUIToggles();if MobileButtons.Buttons.carrySpeed then MobileButtons.Buttons.carrySpeed(false) end;return end
    deactivateAllSpeedModes();State.speedType="carry";refreshUIToggles();if MobileButtons.Buttons.carrySpeed then MobileButtons.Buttons.carrySpeed(true) end
end
local function toggleLagger()
    if State.laggerActive then State.laggerActive=false;AutoSteal.Enabled=false;if setInstaGrab then setInstaGrab(false) end;stopAutoSteal();refreshUIToggles();if MobileButtons.Buttons.lagger then MobileButtons.Buttons.lagger(false) end;return end
    deactivateAllSpeedModes();State.laggerActive=true;AutoSteal.Enabled=true;if setInstaGrab then setInstaGrab(true) end;startAutoSteal();refreshUIToggles();if MobileButtons.Buttons.lagger then MobileButtons.Buttons.lagger(true) end
end
local function toggleLaggerCarry()
    if State.laggerCarryActive then State.laggerCarryActive=false;AutoSteal.Enabled=false;if setInstaGrab then setInstaGrab(false) end;stopAutoSteal();refreshUIToggles();if MobileButtons.Buttons.laggerCarry then MobileButtons.Buttons.laggerCarry(false) end;return end
    deactivateAllSpeedModes();State.laggerCarryActive=true;AutoSteal.Enabled=true;if setInstaGrab then setInstaGrab(true) end;startAutoSteal();refreshUIToggles();if MobileButtons.Buttons.laggerCarry then MobileButtons.Buttons.laggerCarry(true) end
end
local function getCurrentSpeed()
    if State.laggerCarryActive then return State.laggerCarrySpeed
    elseif State.laggerActive  then return State.laggerSpeed
    else return (State.speedType=="normal") and State.normalSpeed or State.carrySpeed end
end
local function getAutoMoveSpeed()
    if State.laggerCarryActive then return State.normalSpeed
    elseif State.laggerActive  then return State.laggerSpeed
    else return State.normalSpeed end
end
local autoStealConn=nil
local PLOT_CACHE_DURATION=2;local PROMPT_CACHE_REFRESH=0.15
local plotCache={};local plotCacheTime={};local cachedPrompts={};local promptCacheTime=0
local function isMyPlotByName(pn)
    local ct=tick();if plotCache[pn] and (ct-(plotCacheTime[pn] or 0))<PLOT_CACHE_DURATION then return plotCache[pn] end
    local plots=workspace:FindFirstChild("Plots");if not plots then plotCache[pn]=false;plotCacheTime[pn]=ct;return false end
    local plot=plots:FindFirstChild(pn);if not plot then plotCache[pn]=false;plotCacheTime[pn]=ct;return false end
    local sign=plot:FindFirstChild("PlotSign")
    if sign then local yb=sign:FindFirstChild("YourBase");if yb and yb:IsA("BillboardGui") then plotCache[pn]=yb.Enabled;plotCacheTime[pn]=ct;return yb.Enabled end end
    plotCache[pn]=false;plotCacheTime[pn]=ct;return false
end
local function findNearestPrompt()
    local char=LP.Character;local root=char and char:FindFirstChild("HumanoidRootPart");if not root then return nil end
    local ct=tick()
    if ct-promptCacheTime<PROMPT_CACHE_REFRESH and #cachedPrompts>0 then
        local np,nd=nil,math.huge
        for _,d in ipairs(cachedPrompts) do if d.spawn then local dist=(d.spawn.Position-root.Position).Magnitude;if dist<=AutoSteal.Radius and dist<nd then np=d.prompt;nd=dist end end end
        if np then return np end
    end
    cachedPrompts={};promptCacheTime=ct
    local plots=workspace:FindFirstChild("Plots");if not plots then return nil end
    local np,nd=nil,math.huge
    for _,plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local pods=plot:FindFirstChild("AnimalPodiums");if not pods then continue end
        for _,pod in ipairs(pods:GetChildren()) do pcall(function()
            local base=pod:FindFirstChild("Base");local sp=base and base:FindFirstChild("Spawn")
            if sp then local att=sp:FindFirstChild("PromptAttachment");if att then
                for _,child in ipairs(att:GetChildren()) do if child:IsA("ProximityPrompt") then
                    local dist=(sp.Position-root.Position).Magnitude;table.insert(cachedPrompts,{prompt=child,spawn=sp})
                    if dist<=AutoSteal.Radius and dist<nd then np=child;nd=dist end;break
                end end
            end end
        end) end
    end
    return np
end
local function executeSteal(prompt)
    if AutoSteal.IsStealing then return end
    if not AutoSteal.Data[prompt] then
        AutoSteal.Data[prompt]={hold={},trigger={},ready=true}
        pcall(function() if getconnections then
            for _,c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do if c.Function then table.insert(AutoSteal.Data[prompt].hold,c.Function) end end
            for _,c in ipairs(getconnections(prompt.Triggered)) do if c.Function then table.insert(AutoSteal.Data[prompt].trigger,c.Function) end end
        else AutoSteal.Data[prompt].useFallback=true end end)
    end
    local data=AutoSteal.Data[prompt];if not data.ready then return end
    data.ready=false;AutoSteal.IsStealing=true
    local startTime=tick()
    local conn;conn=RunService.Heartbeat:Connect(function()
        if not AutoSteal.IsStealing then conn:Disconnect();return end
        local prog=math.clamp((tick()-startTime)/AutoSteal.Duration,0,1)
        if AutoSteal.ProgressFill then AutoSteal.ProgressFill.Size=UDim2.new(prog,0,1,0) end
        if AutoSteal.ProgressText then AutoSteal.ProgressText.Text=math.floor(prog*100).."%" end
    end)
    task.spawn(function()
        local ok=false
        pcall(function() if not data.useFallback then for _,f in ipairs(data.hold) do task.spawn(f) end;task.wait(AutoSteal.Duration);for _,f in ipairs(data.trigger) do task.spawn(f) end;ok=true end end)
        if not ok and fireproximityprompt then pcall(function() fireproximityprompt(prompt);ok=true end) end
        if not ok then pcall(function() prompt:InputHoldBegin();task.wait(AutoSteal.Duration);prompt:InputHoldEnd() end) end
        AutoSteal.IsStealing=false;data.ready=true;task.wait(0.6)
        if not AutoSteal.IsStealing and AutoSteal.ProgressFill then TweenService:Create(AutoSteal.ProgressFill,TweenInfo.new(0.4),{Size=UDim2.new(0,0,1,0)}):Play() end
        if AutoSteal.ProgressText then AutoSteal.ProgressText.Text="0%" end
    end)
end
startAutoSteal=function()
    if autoStealConn then return end
    autoStealConn=RunService.Heartbeat:Connect(function() if AutoSteal.Enabled and not AutoSteal.IsStealing then local p=findNearestPrompt();if p then executeSteal(p) end end end)
end
stopAutoSteal=function()
    if autoStealConn then autoStealConn:Disconnect();autoStealConn=nil end
    AutoSteal.IsStealing=false
    for _,v in pairs(AutoSteal.Data) do if v.ready~=nil then v.ready=true end end
    plotCache={};plotCacheTime={};cachedPrompts={}
end
local resetPos=Vector3.new(0.076,99997.35,-0.517);local activeResetClone=nil
local function cleanupReset()
    if activeResetClone then activeResetClone:Destroy();activeResetClone=nil end
    workspace.CurrentCamera.CameraSubject=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    workspace.CurrentCamera.CameraType=Enum.CameraType.Custom
    pcall(function() local hGui=LP.PlayerGui:FindFirstChild("Health");if hGui then hGui.Enabled=true end end)
end
local function doInstantReset()
    local char=LP.Character;local hrp2=char and char:FindFirstChild("HumanoidRootPart");local hum2=char and char:FindFirstChildOfClass("Humanoid");if not hrp2 or not hum2 then return end
    hum2:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false);hum2:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false);cleanupReset()
    pcall(function() local hGui=LP.PlayerGui:FindFirstChild("Health");if hGui then hGui.Enabled=false end;local head=char:FindFirstChild("Head");if head then local died=head:FindFirstChild("Died");if died then died.Volume=0 end end end)
    char.Archivable=true;local clone=char:Clone();clone.Name="FakePlayer";clone.Parent=workspace;activeResetClone=clone
    for _,v in ipairs(clone:GetDescendants()) do if v:IsA("LuaSourceContainer") then v:Destroy() elseif v:IsA("BasePart") then v.Anchored=true;v.CanCollide=false end end
    workspace.CurrentCamera.CameraType=Enum.CameraType.Scriptable;local oldCamCF=workspace.CurrentCamera.CFrame
    local carpet=LP.Backpack:FindFirstChild("Flying Carpet");if carpet then carpet.Parent=char end
    task.spawn(function() for i=1,10 do if hrp2 and hrp2.Parent then hrp2.CFrame=CFrame.new(resetPos);hrp2.AssemblyLinearVelocity=Vector3.zero end;RunService.PreSimulation:Wait() end;hum2.Health=0 end)
    task.spawn(function() while activeResetClone and LP.Character==char do workspace.CurrentCamera.CFrame=oldCamCF;RunService.RenderStepped:Wait() end;cleanupReset() end)
end
LP.CharacterAdded:Connect(function() task.wait(0.5);cleanupReset() end)
local Anims={idle1="rbxassetid://133806214992291",idle2="rbxassetid://94970088341563",walk="rbxassetid://707897309",run="rbxassetid://707861613",jump="rbxassetid://116936326516985",fall="rbxassetid://116936326516985",climb="rbxassetid://116936326516985",swim="rbxassetid://116936326516985",swimidle="rbxassetid://116936326516985"}
task.spawn(function() pcall(function() ContentProvider:PreloadAsync(Anims) end) end)
local function isPackAnim(id) if not id then return false end;for _,v in pairs(Anims) do if v==id then return true end end;return false end
local function saveOriginalAnims(char) local a=char:FindFirstChild("Animate");if not a then return end;local function g(o) return o and o.AnimationId or nil end;local ids={idle1=g(a.idle and a.idle.Animation1),idle2=g(a.idle and a.idle.Animation2),walk=g(a.walk and a.walk.WalkAnim),run=g(a.run and a.run.RunAnim),jump=g(a.jump and a.jump.JumpAnim),fall=g(a.fall and a.fall.FallAnim),climb=g(a.climb and a.climb.ClimbAnim),swim=g(a.swim and a.swim.Swim),swimidle=g(a.swimidle and a.swimidle.SwimIdle)};if not isPackAnim(ids.walk) then originalAnims=ids end end
local function applyAnimPack(char) local a=char:FindFirstChild("Animate");if not a then return end;local function s(o,id) if o then o.AnimationId=id end end;s(a.idle and a.idle.Animation1,Anims.idle1);s(a.idle and a.idle.Animation2,Anims.idle2);s(a.walk and a.walk.WalkAnim,Anims.walk);s(a.run and a.run.RunAnim,Anims.run);s(a.jump and a.jump.JumpAnim,Anims.jump);s(a.fall and a.fall.FallAnim,Anims.fall);s(a.climb and a.climb.ClimbAnim,Anims.climb);s(a.swim and a.swim.Swim,Anims.swim);s(a.swimidle and a.swimidle.SwimIdle,Anims.swimidle) end
local function restoreOriginalAnims(char) if not originalAnims then return end;local a=char:FindFirstChild("Animate");if not a then return end;local function s(o,id) if o and id then o.AnimationId=id end end;s(a.idle and a.idle.Animation1,originalAnims.idle1);s(a.idle and a.idle.Animation2,originalAnims.idle2);s(a.walk and a.walk.WalkAnim,originalAnims.walk);s(a.run and a.run.RunAnim,originalAnims.run);s(a.jump and a.jump.JumpAnim,originalAnims.jump);s(a.fall and a.fall.FallAnim,originalAnims.fall);s(a.climb and a.climb.ClimbAnim,originalAnims.climb);s(a.swim and a.swim.Swim,originalAnims.swim);s(a.swimidle and a.swimidle.SwimIdle,originalAnims.swimidle);local hum2=char:FindFirstChildOfClass("Humanoid");if hum2 then for _,t in ipairs(hum2:GetPlayingAnimationTracks()) do t:Stop(0) end;hum2:ChangeState(Enum.HumanoidStateType.Running) end end
local function startAnimToggle() if animHBConn then animHBConn:Disconnect();animHBConn=nil end;local char=LP.Character;if char then saveOriginalAnims(char);applyAnimPack(char);local hum2=char:FindFirstChildOfClass("Humanoid");if hum2 then for _,t in ipairs(hum2:GetPlayingAnimationTracks()) do t:Stop(0) end;hum2:ChangeState(Enum.HumanoidStateType.Running) end end;animHBConn=RunService.Heartbeat:Connect(function() if not State.animEnabled then return end;local c=LP.Character;if c then applyAnimPack(c) end end) end
local function stopAnimToggle() if animHBConn then animHBConn:Disconnect();animHBConn=nil end;local char=LP.Character;if char then restoreOriginalAnims(char) end end
local Presets={};local PRESET_FILE="AnguishPresets.json";local LAST_PRESET_FILE="AnguishLastPreset.json";local CONFIG_FILE="AnguishConfig.json"
local function buildPresetSnapshot() return {normalSpeed=State.normalSpeed,carrySpeed=State.carrySpeed,laggerSpeed=State.laggerSpeed,laggerCarrySpeed=State.laggerCarrySpeed,speedType=State.speedType,laggerActive=State.laggerActive,laggerCarryActive=State.laggerCarryActive,stealRadius=AutoSteal.Radius,stealDuration=AutoSteal.Duration,infJump=State.infJumpEnabled,infJumpMode=State.infJumpMode,antiRagdoll=State.antiRagdollEnabled,fpsBoost=State.fpsBoostEnabled,medusaCounter=State.medusaCounterEnabled,batCounter=State.batCounterEnabled,autoSteal=AutoSteal.Enabled,animEnabled=State.animEnabled,autoTpDown=State.autoTpDownEnabled,autoTpDownY=State.autoTpDownY,duelLagger=State.duelLaggerActive,bypass=State.bypassActive,bypassSpeedBoost=State.bypassSpeedBoost,bypassLagAmount=State.bypassLagAmount} end
local function savePresetsFile() local ok,e=pcall(function() return HttpService:JSONEncode(Presets) end);if ok then pcall(function() _writefile(PRESET_FILE,e) end) end end
local function loadPresetsFile() local h2=false;pcall(function() h2=_isfile(PRESET_FILE) end);if not h2 then return end;local r;pcall(function() r=_readfile(PRESET_FILE) end);if not r then return end;local ok,d=pcall(function() return HttpService:JSONDecode(r) end);if ok and d then Presets=d end end
local function saveLastPresetName(n) local ok,e=pcall(function() return HttpService:JSONEncode({lastPreset=n}) end);if ok then pcall(function() _writefile(LAST_PRESET_FILE,e) end) end end
local function loadLastPresetName() local h2=false;pcall(function() h2=_isfile(LAST_PRESET_FILE) end);if not h2 then return nil end;local r;pcall(function() r=_readfile(LAST_PRESET_FILE) end);if not r then return nil end;local ok,d=pcall(function() return HttpService:JSONDecode(r) end);if ok and d then return d.lastPreset end;return nil end
for _,name in pairs({"AnguishHub","AgonyHubV2","VexulHubGUI","VexHubV5_2","AnguishHub2"}) do
    pcall(function() local o=game:GetService("CoreGui"):FindFirstChild(name);if o then o:Destroy() end end)
    pcall(function() local o=LP:WaitForChild("PlayerGui"):FindFirstChild(name);if o then o:Destroy() end end)
end
local C={
    bg=Color3.fromRGB(6,8,20),
    panel=Color3.fromRGB(10,12,28),
    card=Color3.fromRGB(14,16,36),
    cardHov=Color3.fromRGB(18,22,48),
    border=Color3.fromRGB(0,140,255),
    borderDim=Color3.fromRGB(30,50,120),
    accent=Color3.fromRGB(0,160,255),
    accentLight=Color3.fromRGB(180,80,255),
    accentDark=Color3.fromRGB(0,80,200),
    tabActive=Color3.fromRGB(0,180,255),
    tabInactive=Color3.fromRGB(80,100,140),
    text=Color3.fromRGB(220,230,255),
    textMuted=Color3.fromRGB(120,140,180),
    textDim=Color3.fromRGB(70,80,120),
    white=Color3.fromRGB(255,255,255),
    onBg=Color3.fromRGB(0,100,210),
    offBg=Color3.fromRGB(12,16,38),
    inputBg=Color3.fromRGB(6,8,20),
    success=Color3.fromRGB(80,220,140),
    badge=Color3.fromRGB(200,60,255),
    badgeBg=Color3.fromRGB(20,10,50),
}
local gui=Instance.new("ScreenGui"); gui.Name="AnguishHub"; gui.ResetOnSpawn=false; gui.DisplayOrder=10; gui.IgnoreGuiInset=true; gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; gui.Parent=LP:WaitForChild("PlayerGui")
do
    local ls = Instance.new("ScreenGui")
    ls.Name = "AnguishLoader"; ls.ResetOnSpawn = false
    ls.DisplayOrder = 999; ls.IgnoreGuiInset = true
    ls.Parent = LP:WaitForChild("PlayerGui")
    -- full-screen dark bg
    local bg = Instance.new("Frame", ls)
    bg.Size = UDim2.new(1,0,1,0); bg.BackgroundColor3 = Color3.fromRGB(4,5,14)
    bg.BorderSizePixel = 0; bg.ZIndex = 1
    -- animated grid lines (horizontal)
    for i = 1, 8 do
        local line = Instance.new("Frame", bg)
        line.Size = UDim2.new(1,0,0,1)
        line.Position = UDim2.new(0,0,i/9,0)
        line.BackgroundColor3 = Color3.fromRGB(0,60,140)
        line.BackgroundTransparency = 0.7
        line.BorderSizePixel = 0; line.ZIndex = 2
    end
    -- vertical grid lines
    for i = 1, 12 do
        local line = Instance.new("Frame", bg)
        line.Size = UDim2.new(0,1,1,0)
        line.Position = UDim2.new(i/13,0,0,0)
        line.BackgroundColor3 = Color3.fromRGB(0,60,140)
        line.BackgroundTransparency = 0.7
        line.BorderSizePixel = 0; line.ZIndex = 2
    end
    -- glow orb behind logo
    local orb = Instance.new("Frame", bg)
    orb.Size = UDim2.new(0,340,0,340)
    orb.Position = UDim2.new(0.5,-170,0.5,-210)
    orb.BackgroundColor3 = Color3.fromRGB(0,100,255)
    orb.BackgroundTransparency = 0.82
    orb.BorderSizePixel = 0; orb.ZIndex = 2
    Instance.new("UICorner", orb).CornerRadius = UDim.new(1,0)
    -- logo container
    local logoFrame = Instance.new("Frame", bg)
    logoFrame.Size = UDim2.new(0,260,0,110)
    logoFrame.Position = UDim2.new(0.5,-130,0.5,-175)
    logoFrame.BackgroundTransparency = 1; logoFrame.ZIndex = 3
    -- icon
    local icon = Instance.new("TextLabel", logoFrame)
    icon.Size = UDim2.new(0,60,0,60); icon.Position = UDim2.new(0.5,-30,0,0)
    icon.BackgroundTransparency = 1; icon.Text = "!"
    icon.TextColor3 = Color3.fromRGB(0,180,255)
    icon.Font = Enum.Font.GothamBlack; icon.TextSize = 52; icon.ZIndex = 4
    -- ANGUISH title
    local title = Instance.new("TextLabel", logoFrame)
    title.Size = UDim2.new(1,0,0,48); title.Position = UDim2.new(0,0,0,60)
    title.BackgroundTransparency = 1; title.Text = "ANGUISH"
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Font = Enum.Font.GothamBlack; title.TextSize = 46
    title.TextXAlignment = Enum.TextXAlignment.Center; title.ZIndex = 4
    -- subtitle
    local sub = Instance.new("TextLabel", bg)
    sub.Size = UDim2.new(0,300,0,22); sub.Position = UDim2.new(0.5,-150,0.5,-50)
    sub.BackgroundTransparency = 1; sub.Text = "ANGUISH HUB"
    sub.TextColor3 = Color3.fromRGB(0,160,255)
    sub.Font = Enum.Font.GothamBold; sub.TextSize = 14
    sub.TextXAlignment = Enum.TextXAlignment.Center
    sub.TextTransparency = 0.3; sub.ZIndex = 4
    -- thin accent line under subtitle
    local accentLine = Instance.new("Frame", bg)
    accentLine.Size = UDim2.new(0,0,0,2); accentLine.Position = UDim2.new(0.5,-120,0.5,-22)
    accentLine.BackgroundColor3 = Color3.fromRGB(0,160,255)
    accentLine.BorderSizePixel = 0; accentLine.ZIndex = 4
    Instance.new("UICorner", accentLine).CornerRadius = UDim.new(1,0)
    -- progress bar track
    local barW = 280
    local barTrack = Instance.new("Frame", bg)
    barTrack.Size = UDim2.new(0,barW,0,4)
    barTrack.Position = UDim2.new(0.5,-barW/2,0.5,40)
    barTrack.BackgroundColor3 = Color3.fromRGB(15,20,50)
    barTrack.BorderSizePixel = 0; barTrack.ZIndex = 4
    Instance.new("UICorner", barTrack).CornerRadius = UDim.new(1,0)
    -- progress bar fill
    local barFill = Instance.new("Frame", barTrack)
    barFill.Size = UDim2.new(0,0,1,0)
    barFill.BackgroundColor3 = Color3.fromRGB(0,160,255)
    barFill.BorderSizePixel = 0; barFill.ZIndex = 5
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(1,0)
    -- glow on bar fill
    local barGlow = Instance.new("Frame", barFill)
    barGlow.Size = UDim2.new(0,24,3,0); barGlow.Position = UDim2.new(1,-12,-1,0)
    barGlow.BackgroundColor3 = Color3.fromRGB(120,210,255)
    barGlow.BackgroundTransparency = 0.3; barGlow.BorderSizePixel = 0; barGlow.ZIndex = 6
    Instance.new("UICorner", barGlow).CornerRadius = UDim.new(1,0)
    -- status label
    local statusLbl = Instance.new("TextLabel", bg)
    statusLbl.Size = UDim2.new(0,300,0,20); statusLbl.Position = UDim2.new(0.5,-150,0.5,52)
    statusLbl.BackgroundTransparency = 1; statusLbl.Text = "Starting..."
    statusLbl.TextColor3 = Color3.fromRGB(100,140,200)
    statusLbl.Font = Enum.Font.Gotham; statusLbl.TextSize = 11
    statusLbl.TextXAlignment = Enum.TextXAlignment.Center; statusLbl.ZIndex = 4
    -- version badge
    local ver = Instance.new("TextLabel", bg)
    ver.Size = UDim2.new(0,200,0,16); ver.Position = UDim2.new(0.5,-100,1,-28)
    ver.BackgroundTransparency = 1; ver.Text = "v3.0"
    ver.TextColor3 = Color3.fromRGB(40,60,100)
    ver.Font = Enum.Font.Gotham; ver.TextSize = 10
    ver.TextXAlignment = Enum.TextXAlignment.Center; ver.ZIndex = 4
    -- SOUND
    local snd = Instance.new("Sound")
    snd.SoundId = "rbxassetid://1837798873" -- deep whoosh/boot sound
    snd.Volume = 0.5; snd.RollOffMaxDistance = 0
    snd.Parent = workspace; pcall(function() snd:Play() end)
    -- ANIMATE
    -- pulse the orb
    task.spawn(function()
        while orb and orb.Parent do
            TweenService:Create(orb, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency=0.88}):Play()
            task.wait(1.2)
            TweenService:Create(orb, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency=0.78}):Play()
            task.wait(1.2)
        end
    end)
    -- animate accent line expanding
    TweenService:Create(accentLine, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size=UDim2.new(0,240,0,2), Position=UDim2.new(0.5,-120,0.5,-22)}):Play()
    -- steps
    local steps = {
        {t=0.3,  pct=0.08, msg="Loading..."},
        {t=0.7,  pct=0.22, msg="Checking game..."},
        {t=1.1,  pct=0.40, msg="Setting up..."},
        {t=1.5,  pct=0.58, msg="Loading config..."},
        {t=1.9,  pct=0.75, msg="Building UI..."},
        {t=2.3,  pct=0.90, msg="Almost done..."},
        {t=2.6,  pct=1.0,  msg="Loaded!"},
    }
    task.spawn(function()
        for _, step in ipairs(steps) do
            task.wait(step.t - (steps[_ > 1 and _-1 or 1].t or 0))
            statusLbl.Text = step.msg
            TweenService:Create(barFill, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size=UDim2.new(step.pct, 0, 1, 0)}):Play()
        end
        task.wait(0.4)
        -- flash the bar white then fade out whole screen
        TweenService:Create(barFill, TweenInfo.new(0.15), {BackgroundColor3=Color3.fromRGB(255,255,255)}):Play()
        task.wait(0.18)
        TweenService:Create(bg, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {BackgroundTransparency=1}):Play()
        -- fade all children
        for _, obj in ipairs(bg:GetDescendants()) do
            if obj:IsA("Frame") or obj:IsA("TextLabel") then
                pcall(function()
                    TweenService:Create(obj, TweenInfo.new(0.45), {BackgroundTransparency=1, TextTransparency=1}):Play()
                end)
            end
        end
        task.wait(0.55)
        ls:Destroy()
        pcall(function() snd:Stop(); snd:Destroy() end)
    end)
end
local stealBar=Instance.new("Frame",gui); stealBar.Size=UDim2.new(0,280,0,56); stealBar.Position=UDim2.new(0.5,-140,1,-80); stealBar.BackgroundColor3=C.panel; stealBar.BorderSizePixel=0; stealBar.ZIndex=100; Instance.new("UICorner",stealBar).CornerRadius=UDim.new(0,12); local _sbs=Instance.new("UIStroke",stealBar);_sbs.Color=C.border;_sbs.Thickness=1
local pctLbl=Instance.new("TextLabel",stealBar); pctLbl.Size=UDim2.new(0.38,0,0,26); pctLbl.Position=UDim2.new(0,12,0,6); pctLbl.BackgroundTransparency=1; pctLbl.Text="0%"; pctLbl.TextColor3=C.accentLight; pctLbl.Font=Enum.Font.GothamBlack; pctLbl.TextSize=22; pctLbl.TextXAlignment=Enum.TextXAlignment.Left; pctLbl.ZIndex=101
local progressRadLblG=Instance.new("TextLabel",stealBar); progressRadLblG.Size=UDim2.new(0.62,-12,0,26); progressRadLblG.Position=UDim2.new(0.38,0,0,6); progressRadLblG.BackgroundTransparency=1; progressRadLblG.Text="Radius: 20"; progressRadLblG.TextColor3=C.textMuted; progressRadLblG.Font=Enum.Font.GothamBold; progressRadLblG.TextSize=13; progressRadLblG.TextXAlignment=Enum.TextXAlignment.Right; progressRadLblG.ZIndex=101
progressRadLbl=progressRadLblG
local barTrack=Instance.new("Frame",stealBar); barTrack.Size=UDim2.new(1,-24,0,6); barTrack.Position=UDim2.new(0,12,1,-16); barTrack.BackgroundColor3=C.offBg; barTrack.BorderSizePixel=0; barTrack.ZIndex=101; Instance.new("UICorner",barTrack).CornerRadius=UDim.new(1,0)
local barFill=Instance.new("Frame",barTrack); barFill.Size=UDim2.new(0,0,1,0); barFill.BackgroundColor3=C.accent; barFill.BorderSizePixel=0; barFill.ZIndex=102; Instance.new("UICorner",barFill).CornerRadius=UDim.new(1,0)
AutoSteal.ProgressFill=barFill; AutoSteal.ProgressText=pctLbl
do local drg,di,ds,sp=false,nil,nil,nil
    stealBar.InputBegan:Connect(function(i) if MobileButtons.Locked then return end;if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drg=true;ds=i.Position;sp=stealBar.Position;i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then drg=false end end) end end)
    stealBar.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di=i end end)
    UIS.InputChanged:Connect(function(i) if i==di and drg and not MobileButtons.Locked then local dx=i.Position.X-ds.X;local dy=i.Position.Y-ds.Y;stealBar.Position=UDim2.new(sp.X.Scale,sp.X.Offset+dx,sp.Y.Scale,sp.Y.Offset+dy) end end)
end
local WIN_W=390; local WIN_H=480
local closeBtnRef=nil; local miniBtn=nil
local main=Instance.new("Frame",gui)
main.Name="Main"; main.Size=UDim2.new(0,WIN_W,0,WIN_H); main.Position=UDim2.new(0,24,0,24)
main.BackgroundColor3=C.bg; main.BorderSizePixel=0; main.ClipsDescendants=false
main.Active=false
Instance.new("UICorner",main).CornerRadius=UDim.new(0,16)
local _ms=Instance.new("UIStroke",main);_ms.Color=C.border;_ms.Thickness=1.5
local starBtn=Instance.new("TextButton",gui); starBtn.Name="StarToggle"
starBtn.Size=UDim2.new(0,44,0,44); starBtn.Position=UDim2.new(0,8,0,8)
starBtn.BackgroundColor3=C.panel; starBtn.BorderSizePixel=0
starBtn.Text="A"; starBtn.TextColor3=C.accent; starBtn.TextSize=22; starBtn.Font=Enum.Font.GothamBold; starBtn.ZIndex=100; starBtn.AutoButtonColor=false
Instance.new("UICorner",starBtn).CornerRadius=UDim.new(0,12); Instance.new("UIStroke",starBtn).Color=C.border
do local drg,di,ds,sp=false,nil,nil,nil
    starBtn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drg=true;ds=i.Position;sp=starBtn.Position;i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then drg=false end end) end end)
    starBtn.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di=i end end)
    UIS.InputChanged:Connect(function(i) if i==di and drg then local dx=i.Position.X-ds.X;local dy=i.Position.Y-ds.Y;starBtn.Position=UDim2.new(sp.X.Scale,sp.X.Offset+dx,sp.Y.Scale,sp.Y.Offset+dy) end end)
end
local guiOpen=true
starBtn.MouseButton1Click:Connect(function()
    guiOpen=not guiOpen; main.Visible=guiOpen
    TweenService:Create(starBtn,TweenInfo.new(0.2),{BackgroundColor3=guiOpen and C.panel or C.card}):Play()
    starBtn.TextColor3=guiOpen and C.accent or C.tabInactive
end)
local header=Instance.new("Frame",main); header.Size=UDim2.new(1,0,0,46); header.BackgroundColor3=C.panel; header.BorderSizePixel=0; header.ZIndex=4; header.Active=true
Instance.new("UICorner",header).CornerRadius=UDim.new(0,16)
local hfix=Instance.new("Frame",header); hfix.Size=UDim2.new(1,0,0.5,0); hfix.Position=UDim2.new(0,0,0.5,0); hfix.BackgroundColor3=C.panel; hfix.BorderSizePixel=0; hfix.ZIndex=4
local hdiv=Instance.new("Frame",header); hdiv.Size=UDim2.new(1,0,0,1); hdiv.Position=UDim2.new(0,0,1,-1); hdiv.BackgroundColor3=C.borderDim; hdiv.BorderSizePixel=0; hdiv.ZIndex=5
do -- drag main window via header
    local drg,di,ds,sp=false,nil,nil,nil
    header.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            drg=true; ds=i.Position; sp=main.Position
            i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then drg=false end end)
        end
    end)
    header.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di=i end end)
    UIS.InputChanged:Connect(function(i)
        if i==di and drg then local dx=i.Position.X-ds.X; local dy=i.Position.Y-ds.Y; main.Position=UDim2.new(sp.X.Scale,sp.X.Offset+dx,sp.Y.Scale,sp.Y.Offset+dy) end
    end)
end
local logoDot=Instance.new("Frame",header); logoDot.Size=UDim2.new(0,9,0,9); logoDot.Position=UDim2.new(0,14,0.5,-4.5); logoDot.BackgroundColor3=C.accent; logoDot.BorderSizePixel=0; logoDot.ZIndex=6; Instance.new("UICorner",logoDot).CornerRadius=UDim.new(1,0)
RunService.RenderStepped:Connect(function() local t=tick()*2; logoDot.BackgroundColor3=Color3.fromRGB(math.floor(0+80*math.abs(math.sin(t))),math.floor(120+80*math.abs(math.sin(t+1))),math.floor(220+35*math.sin(t+2))) end)
local titleLbl=Instance.new("TextLabel",header); titleLbl.Size=UDim2.new(0,110,1,0); titleLbl.Position=UDim2.new(0,28,0,0); titleLbl.BackgroundTransparency=1; titleLbl.Text="ANGUISH"; titleLbl.TextColor3=C.accent; titleLbl.Font=Enum.Font.GothamBlack; titleLbl.TextSize=16; titleLbl.TextXAlignment=Enum.TextXAlignment.Left; titleLbl.ZIndex=6
local modeBadge=Instance.new("Frame",header); modeBadge.Size=UDim2.new(0,64,0,20); modeBadge.Position=UDim2.new(0,130,0.5,-10); modeBadge.BackgroundColor3=C.badgeBg; modeBadge.BorderSizePixel=0; modeBadge.ZIndex=6; Instance.new("UICorner",modeBadge).CornerRadius=UDim.new(0,6); Instance.new("UIStroke",modeBadge).Color=C.border
local modeBadgeLbl=Instance.new("TextLabel",modeBadge); modeBadgeLbl.Size=UDim2.new(1,0,1,0); modeBadgeLbl.BackgroundTransparency=1; modeBadgeLbl.Text="NORMAL"; modeBadgeLbl.TextColor3=C.accent; modeBadgeLbl.Font=Enum.Font.GothamBold; modeBadgeLbl.TextSize=10; modeBadgeLbl.ZIndex=7
modeValLbl=modeBadgeLbl
local sixEyesLbl=Instance.new("TextLabel",header); sixEyesLbl.Size=UDim2.new(0,110,1,0); sixEyesLbl.Position=UDim2.new(1,-114,0,0); sixEyesLbl.BackgroundTransparency=1; sixEyesLbl.Text=""; sixEyesLbl.TextColor3=C.textDim; sixEyesLbl.Font=Enum.Font.Gotham; sixEyesLbl.TextSize=9; sixEyesLbl.TextXAlignment=Enum.TextXAlignment.Right; sixEyesLbl.ZIndex=6
local TABS={"SPEED","STEAL","MOVEMENT","VISUAL","CTRL","SETTINGS"}
local sidebar=Instance.new("Frame",main); sidebar.Name="Sidebar"; sidebar.Size=UDim2.new(0,106,1,-46); sidebar.Position=UDim2.new(0,0,0,46); sidebar.BackgroundColor3=C.panel; sidebar.BorderSizePixel=0; sidebar.ZIndex=4; sidebar.ClipsDescendants=true
Instance.new("UICorner",sidebar).CornerRadius=UDim.new(0,16)
local sfix=Instance.new("Frame",main); sfix.Size=UDim2.new(0,20,1,-46); sfix.Position=UDim2.new(0,86,0,46); sfix.BackgroundColor3=C.panel; sfix.BorderSizePixel=0; sfix.ZIndex=4
local sideLayout=Instance.new("UIListLayout",sidebar); sideLayout.SortOrder=Enum.SortOrder.LayoutOrder; sideLayout.Padding=UDim.new(0,2); sideLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
local sidePad=Instance.new("UIPadding",sidebar); sidePad.PaddingTop=UDim.new(0,8); sidePad.PaddingLeft=UDim.new(0,4); sidePad.PaddingRight=UDim.new(0,4)
local divider=Instance.new("Frame",main); divider.Size=UDim2.new(0,1,1,-46); divider.Position=UDim2.new(0,106,0,46); divider.BackgroundColor3=C.borderDim; divider.BorderSizePixel=0; divider.ZIndex=5
local contentArea=Instance.new("Frame",main); contentArea.Size=UDim2.new(1,-114,1,-46); contentArea.Position=UDim2.new(0,110,0,46); contentArea.BackgroundTransparency=1; contentArea.BorderSizePixel=0; contentArea.ClipsDescendants=true; contentArea.ZIndex=2
local tabPages={}
local function makePage(name)
    local sf=Instance.new("ScrollingFrame",contentArea); sf.Name=name; sf.Size=UDim2.new(1,0,1,0); sf.BackgroundTransparency=1; sf.BorderSizePixel=0; sf.ScrollBarThickness=2; sf.ScrollBarImageColor3=C.border; sf.AutomaticCanvasSize=Enum.AutomaticSize.Y; sf.CanvasSize=UDim2.new(0,0,0,0); sf.ZIndex=2; sf.Visible=false
    local ll=Instance.new("UIListLayout",sf); ll.Padding=UDim.new(0,4); ll.SortOrder=Enum.SortOrder.LayoutOrder
    local pp=Instance.new("UIPadding",sf); pp.PaddingLeft=UDim.new(0,10); pp.PaddingRight=UDim.new(0,10); pp.PaddingTop=UDim.new(0,8); pp.PaddingBottom=UDim.new(0,10)
    tabPages[name]=sf; return sf
end
for _,t in ipairs(TABS) do makePage(t) end
local currentTab=nil
local tabBtns={}
local function switchTab(name)
    if currentTab==name then return end
    currentTab=name
    for _,t in ipairs(TABS) do
        if tabPages[t] then tabPages[t].Visible=(t==name) end
        if tabBtns[t] then
            local isActive=(t==name)
            tabBtns[t].TextColor3=isActive and C.tabActive or C.tabInactive
            local accent=tabBtns[t]:FindFirstChild("Accent"); if accent then accent.BackgroundTransparency=isActive and 0 or 1 end
        end
    end
end
for i,tname in ipairs(TABS) do
    local tb=Instance.new("TextButton",sidebar)
    tb.Size=UDim2.new(1,-4,0,34); tb.BackgroundTransparency=1
    tb.Text=tname; tb.TextColor3=C.tabInactive; tb.Font=Enum.Font.GothamBold; tb.TextSize=10
    tb.AutoButtonColor=false; tb.ZIndex=6; tb.LayoutOrder=i
    local accent=Instance.new("Frame",tb); accent.Name="Accent"
    accent.Size=UDim2.new(0,3,0.6,0); accent.Position=UDim2.new(0,0,0.2,0)
    accent.BackgroundColor3=C.tabActive; accent.BorderSizePixel=0; accent.BackgroundTransparency=1; accent.ZIndex=7
    Instance.new("UICorner",accent).CornerRadius=UDim.new(1,0)
    tabBtns[tname]=tb
    tb.MouseButton1Click:Connect(function() switchTab(tname) end)
end
local pageLoOrder={}
local function pageNextLO(pageName) pageLoOrder[pageName]=(pageLoOrder[pageName] or 0)+1; return pageLoOrder[pageName] end
local function makePageGap(pageName,px)
    local f=Instance.new("Frame",tabPages[pageName]); f.Size=UDim2.new(1,0,0,px or 4); f.BackgroundTransparency=1; f.BorderSizePixel=0; f.LayoutOrder=pageNextLO(pageName)
end
local function makePageSectionLabel(pageName,txt)
    local row=Instance.new("Frame",tabPages[pageName]); row.Size=UDim2.new(1,0,0,20); row.BackgroundTransparency=1; row.BorderSizePixel=0; row.LayoutOrder=pageNextLO(pageName)
    local lbl=Instance.new("TextLabel",row); lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1; lbl.Text=txt:upper(); lbl.TextColor3=C.accent; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=9; lbl.TextXAlignment=Enum.TextXAlignment.Left
end
local function makePageToggleRow(pageName,label,subLabel,defaultOn,onToggle,keybindStateKey)
    local row=Instance.new("Frame",tabPages[pageName]); row.Size=UDim2.new(1,0,0,subLabel and 46 or 36); row.BackgroundColor3=C.card; row.BorderSizePixel=0; row.LayoutOrder=pageNextLO(pageName); Instance.new("UICorner",row).CornerRadius=UDim.new(0,10)
    local lblW=keybindStateKey and 0.45 or 0.60
    local lbl=Instance.new("TextLabel",row); lbl.Size=UDim2.new(lblW,-4,0,18); lbl.Position=UDim2.new(0,12,0,subLabel and 8 or 9); lbl.BackgroundTransparency=1; lbl.Text=label; lbl.TextColor3=C.text; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=12; lbl.TextXAlignment=Enum.TextXAlignment.Left
    if subLabel then local sl=Instance.new("TextLabel",row); sl.Size=UDim2.new(lblW,-4,0,14); sl.Position=UDim2.new(0,12,0,26); sl.BackgroundTransparency=1; sl.Text=subLabel; sl.TextColor3=C.textDim; sl.Font=Enum.Font.Gotham; sl.TextSize=10; sl.TextXAlignment=Enum.TextXAlignment.Left end
    local newKeyBtn=nil
    if keybindStateKey then
        local curK=State[keybindStateKey]; local kDisp=(curK and curK~=Enum.KeyCode.Unknown) and curK.Name or "-"
        newKeyBtn=Instance.new("TextButton",row); newKeyBtn.Size=UDim2.new(0,52,0,20); newKeyBtn.Position=UDim2.new(1,-104,0.5,-10); newKeyBtn.BackgroundColor3=C.inputBg; newKeyBtn.BorderSizePixel=0; newKeyBtn.Text=kDisp; newKeyBtn.TextColor3=C.textMuted; newKeyBtn.Font=Enum.Font.GothamBold; newKeyBtn.TextSize=9; newKeyBtn.AutoButtonColor=false; newKeyBtn.ZIndex=7; Instance.new("UICorner",newKeyBtn).CornerRadius=UDim.new(0,5); Instance.new("UIStroke",newKeyBtn).Color=C.borderDim
        local nkL=false; local nkConn=nil
        local function nkStop(key) nkL=false;if nkConn then nkConn:Disconnect();nkConn=nil end;newKeyBtn.TextColor3=C.textMuted;if key then State[keybindStateKey]=key;newKeyBtn.Text=key.Name;task.spawn(function() if saveConfig then pcall(saveConfig) end end) end end
        newKeyBtn.MouseButton1Click:Connect(function() if nkL then nkStop(nil);return end;nkL=true;newKeyBtn.Text="...";newKeyBtn.TextColor3=C.accentLight
            nkConn=UIS.InputBegan:Connect(function(inp,gp) if not nkL then return end;if inp.UserInputType==Enum.UserInputType.Keyboard then if inp.KeyCode==Enum.KeyCode.Escape then nkStop(nil);return end;nkStop(inp.KeyCode) elseif inp.UserInputType==Enum.UserInputType.Gamepad1 then nkStop(inp.KeyCode) end end) end)
    end
    local pillBg=Instance.new("Frame",row); pillBg.Size=UDim2.new(0,42,0,22); pillBg.Position=UDim2.new(1,-52,0.5,-11); pillBg.BackgroundColor3=defaultOn and C.onBg or C.offBg; pillBg.BorderSizePixel=0; pillBg.ZIndex=5; Instance.new("UICorner",pillBg).CornerRadius=UDim.new(1,0); local psk=Instance.new("UIStroke",pillBg);psk.Color=defaultOn and C.border or C.borderDim;psk.Thickness=1
    local dot=Instance.new("Frame",pillBg); dot.Size=UDim2.new(0,15,0,15); dot.Position=defaultOn and UDim2.new(1,-18,0.5,-7.5) or UDim2.new(0,3,0.5,-7.5); dot.BackgroundColor3=defaultOn and C.accentLight or C.textDim; dot.BorderSizePixel=0; dot.ZIndex=6; Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
    local isOn=defaultOn or false
    local function setV(on) isOn=on;TweenService:Create(pillBg,TweenInfo.new(0.18,Enum.EasingStyle.Quad),{BackgroundColor3=on and C.onBg or C.offBg}):Play();TweenService:Create(psk,TweenInfo.new(0.18),{Color=on and C.border or C.borderDim}):Play();TweenService:Create(dot,TweenInfo.new(0.18,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-18,0.5,-7.5) or UDim2.new(0,3,0.5,-7.5),BackgroundColor3=on and C.accentLight or C.textDim}):Play() end
    local clk=Instance.new("TextButton",row); clk.Size=UDim2.new(1,0,1,0); clk.BackgroundTransparency=1; clk.Text=""; clk.ZIndex=3
    clk.MouseButton1Click:Connect(function() isOn=not isOn;setV(isOn);if onToggle then pcall(onToggle,isOn) end;task.spawn(function() if saveConfig then pcall(saveConfig) end end) end)
    row.MouseEnter:Connect(function() TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C.cardHov}):Play() end)
    row.MouseLeave:Connect(function() TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C.card}):Play() end)
    return setV,newKeyBtn
end
local function makePageInputRow(pageName,label,subLabel,defaultVal,onChange)
    local row=Instance.new("Frame",tabPages[pageName]); row.Size=UDim2.new(1,0,0,subLabel and 46 or 36); row.BackgroundColor3=C.card; row.BorderSizePixel=0; row.LayoutOrder=pageNextLO(pageName); Instance.new("UICorner",row).CornerRadius=UDim.new(0,10)
    local lbl=Instance.new("TextLabel",row); lbl.Size=UDim2.new(0.55,0,0,18); lbl.Position=UDim2.new(0,12,0,subLabel and 8 or 9); lbl.BackgroundTransparency=1; lbl.Text=label; lbl.TextColor3=C.text; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=12; lbl.TextXAlignment=Enum.TextXAlignment.Left
    if subLabel then local sl=Instance.new("TextLabel",row); sl.Size=UDim2.new(0.55,0,0,14); sl.Position=UDim2.new(0,12,0,26); sl.BackgroundTransparency=1; sl.Text=subLabel; sl.TextColor3=C.textDim; sl.Font=Enum.Font.Gotham; sl.TextSize=10; sl.TextXAlignment=Enum.TextXAlignment.Left end
    local box=Instance.new("TextBox",row); box.Size=UDim2.new(0,72,0,26); box.Position=UDim2.new(1,-82,0.5,-13); box.BackgroundColor3=C.inputBg; box.BorderSizePixel=0; box.Text=tostring(defaultVal); box.TextColor3=C.accentLight; box.Font=Enum.Font.GothamBold; box.TextSize=13; box.ClearTextOnFocus=true; box.ZIndex=3; Instance.new("UICorner",box).CornerRadius=UDim.new(0,7); local bs=Instance.new("UIStroke",box);bs.Color=C.borderDim;bs.Thickness=1
    box.Focused:Connect(function() TweenService:Create(bs,TweenInfo.new(0.15),{Color=C.border}):Play() end)
    box.FocusLost:Connect(function() TweenService:Create(bs,TweenInfo.new(0.15),{Color=C.borderDim}):Play();local n=tonumber(box.Text);if n then local v=math.floor(math.clamp(n,0,500));box.Text=tostring(v);if onChange then onChange(v) end;task.spawn(function() if saveConfig then pcall(saveConfig) end end) else box.Text=tostring(defaultVal) end end)
    row.MouseEnter:Connect(function() TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C.cardHov}):Play() end)
    row.MouseLeave:Connect(function() TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C.card}):Play() end)
    return box
end
local function makeDualSpeedRow(pageName,label,subLabel,defaultCarry,defaultNormal,onChangeCarry,onChangeNormal)
    local row=Instance.new("Frame",tabPages[pageName]); row.Size=UDim2.new(1,0,0,62); row.BackgroundColor3=C.card; row.BorderSizePixel=0; row.LayoutOrder=pageNextLO(pageName); Instance.new("UICorner",row).CornerRadius=UDim.new(0,10)
    local lbl=Instance.new("TextLabel",row); lbl.Size=UDim2.new(0.5,0,0,18); lbl.Position=UDim2.new(0,12,0,8); lbl.BackgroundTransparency=1; lbl.Text=label; lbl.TextColor3=C.text; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=12; lbl.TextXAlignment=Enum.TextXAlignment.Left
    if subLabel then local sl=Instance.new("TextLabel",row); sl.Size=UDim2.new(0.5,0,0,13); sl.Position=UDim2.new(0,12,0,26); sl.BackgroundTransparency=1; sl.Text=subLabel; sl.TextColor3=C.textDim; sl.Font=Enum.Font.Gotham; sl.TextSize=10; sl.TextXAlignment=Enum.TextXAlignment.Left end
    local clbl=Instance.new("TextLabel",row); clbl.Size=UDim2.new(0,38,0,12); clbl.Position=UDim2.new(1,-116,0,10); clbl.BackgroundTransparency=1; clbl.Text="CARRY"; clbl.TextColor3=C.textMuted; clbl.Font=Enum.Font.GothamBold; clbl.TextSize=9; clbl.TextXAlignment=Enum.TextXAlignment.Center
    local cBox=Instance.new("TextBox",row); cBox.Size=UDim2.new(0,50,0,28); cBox.Position=UDim2.new(1,-118,0,22); cBox.BackgroundColor3=C.inputBg; cBox.BorderSizePixel=0; cBox.Text=tostring(defaultCarry); cBox.TextColor3=C.accentLight; cBox.Font=Enum.Font.GothamBlack; cBox.TextSize=15; cBox.ClearTextOnFocus=true; cBox.ZIndex=3; Instance.new("UICorner",cBox).CornerRadius=UDim.new(0,8); local cbs=Instance.new("UIStroke",cBox);cbs.Color=C.borderDim;cbs.Thickness=1
    cBox.Focused:Connect(function() TweenService:Create(cbs,TweenInfo.new(0.15),{Color=C.border}):Play() end)
    cBox.FocusLost:Connect(function() TweenService:Create(cbs,TweenInfo.new(0.15),{Color=C.borderDim}):Play();local n=tonumber(cBox.Text);if n then local v=math.floor(math.clamp(n,0,500));cBox.Text=tostring(v);if onChangeCarry then onChangeCarry(v) end;task.spawn(function() if saveConfig then pcall(saveConfig) end end) else cBox.Text=tostring(defaultCarry) end end)
    local nlbl=Instance.new("TextLabel",row); nlbl.Size=UDim2.new(0,44,0,12); nlbl.Position=UDim2.new(1,-58,0,10); nlbl.BackgroundTransparency=1; nlbl.Text="NORMAL"; nlbl.TextColor3=C.textMuted; nlbl.Font=Enum.Font.GothamBold; nlbl.TextSize=9; nlbl.TextXAlignment=Enum.TextXAlignment.Center
    local nBox=Instance.new("TextBox",row); nBox.Size=UDim2.new(0,50,0,28); nBox.Position=UDim2.new(1,-62,0,22); nBox.BackgroundColor3=C.inputBg; nBox.BorderSizePixel=0; nBox.Text=tostring(defaultNormal); nBox.TextColor3=C.accentLight; nBox.Font=Enum.Font.GothamBlack; nBox.TextSize=15; nBox.ClearTextOnFocus=true; nBox.ZIndex=3; Instance.new("UICorner",nBox).CornerRadius=UDim.new(0,8); local nbs=Instance.new("UIStroke",nBox);nbs.Color=C.borderDim;nbs.Thickness=1
    nBox.Focused:Connect(function() TweenService:Create(nbs,TweenInfo.new(0.15),{Color=C.border}):Play() end)
    nBox.FocusLost:Connect(function() TweenService:Create(nbs,TweenInfo.new(0.15),{Color=C.borderDim}):Play();local n=tonumber(nBox.Text);if n then local v=math.floor(math.clamp(n,0,500));nBox.Text=tostring(v);if onChangeNormal then onChangeNormal(v) end;task.spawn(function() if saveConfig then pcall(saveConfig) end end) else nBox.Text=tostring(defaultNormal) end end)
    row.MouseEnter:Connect(function() TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C.cardHov}):Play() end)
    row.MouseLeave:Connect(function() TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C.card}):Play() end)
    return cBox,nBox
end
local function makePageActionBtn(pageName,label,onClick)
    local btn=Instance.new("TextButton",tabPages[pageName]); btn.Size=UDim2.new(1,0,0,34); btn.BackgroundColor3=C.card; btn.BorderSizePixel=0; btn.LayoutOrder=pageNextLO(pageName); btn.Text=label; btn.TextColor3=C.text; btn.Font=Enum.Font.GothamBold; btn.TextSize=12; Instance.new("UICorner",btn).CornerRadius=UDim.new(0,10); Instance.new("UIStroke",btn).Color=C.borderDim
    btn.MouseButton1Click:Connect(function() TweenService:Create(btn,TweenInfo.new(0.08),{BackgroundColor3=C.onBg}):Play();task.delay(0.16,function() TweenService:Create(btn,TweenInfo.new(0.12),{BackgroundColor3=C.card}):Play() end);if onClick then pcall(onClick) end end)
    btn.MouseEnter:Connect(function() TweenService:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=C.cardHov}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=C.card}):Play() end)
    return btn
end
local function makeDualSelector(pageName,opt1,opt2,defaultSel,onChange)
    local wrap=Instance.new("Frame",tabPages[pageName]); wrap.Size=UDim2.new(1,0,0,32); wrap.BackgroundTransparency=1; wrap.BorderSizePixel=0; wrap.LayoutOrder=pageNextLO(pageName)
    local function makeBtn(txt,xScale,xOff,active) local b=Instance.new("TextButton",wrap);b.Size=UDim2.new(0.5-0.01,0,1,0);b.Position=UDim2.new(xScale,xOff,0,0);b.BackgroundColor3=active and C.onBg or C.offBg;b.BorderSizePixel=0;b.Text=txt;b.TextColor3=active and C.accentLight or C.textDim;b.Font=Enum.Font.GothamBold;b.TextSize=12;b.AutoButtonColor=false;b.ZIndex=5;Instance.new("UICorner",b).CornerRadius=UDim.new(0,8);Instance.new("UIStroke",b).Color=C.borderDim;return b end
    local b1=makeBtn(opt1,0,0,defaultSel==opt1); local b2=makeBtn(opt2,0.5,2,defaultSel==opt2)
    local function upd(sel) b1.BackgroundColor3=sel==opt1 and C.onBg or C.offBg;b1.TextColor3=sel==opt1 and C.accentLight or C.textDim;b2.BackgroundColor3=sel==opt2 and C.onBg or C.offBg;b2.TextColor3=sel==opt2 and C.accentLight or C.textDim end
    b1.MouseButton1Click:Connect(function() if onChange then onChange(opt1) end;upd(opt1) end)
    b2.MouseButton1Click:Connect(function() if onChange then onChange(opt2) end;upd(opt2) end)
    return upd
end
makePageSectionLabel("SPEED","Speed Values")
local carryNormalCarryBox, carryNormalNormalBox = makeDualSpeedRow("SPEED","Normal Speed","Standard movement",State.carrySpeed,State.normalSpeed,
    function(v) State.carrySpeed=v end,
    function(v) State.normalSpeed=v end)
carryBox=carryNormalCarryBox; normalBox=carryNormalNormalBox
local laggerCarryBox2, laggerNormalBox2 = makeDualSpeedRow("SPEED","Lagger Speed","Low-ping lagger",State.laggerCarrySpeed,State.laggerSpeed,
    function(v) State.laggerCarrySpeed=v end,
    function(v) State.laggerSpeed=v end)
laggerCarryBox=laggerCarryBox2; laggerBox=laggerNormalBox2
makePageSectionLabel("SPEED","Speed Modes")
setSpeedToggleUI = makePageToggleRow("SPEED","Carry Mode","Toggle carry speed",false,function(on) toggleSpeedType() end)
setLaggerToggleUI = makePageToggleRow("SPEED","Lagger Mode","Activates auto steal",false,function(on) toggleLagger() end)
setLaggerCarryUI = makePageToggleRow("SPEED","Lagger Carry","Lagger + carry combo",false,function(on) toggleLaggerCarry() end)
makePageSectionLabel("STEAL","Auto Steal")
radiusBox = makePageInputRow("STEAL","Grab Radius","Distance to steal from",AutoSteal.Radius,function(v) AutoSteal.Radius=v;if progressRadLbl then progressRadLbl.Text="Radius: "..v end end)
makePageInputRow("STEAL","Grab Duration","Hold time (seconds)",AutoSteal.Duration,function(v) AutoSteal.Duration=math.clamp(v/100,0.05,10) end)
setInstaGrab = makePageToggleRow("STEAL","Auto Grab","Steal nearby animals",false,function(on) AutoSteal.Enabled=on;if on then startAutoSteal() else stopAutoSteal() end end)
makePageSectionLabel("STEAL","Bat Aimbot")
setAutoBat = makePageToggleRow("STEAL","Bat Aimbot","Blackskill prediction system",false,function(on)
    State.aimbotActive=on
    if on then
        -- turn off auto left
        if State.autoLeftEnabled then
            State.autoLeftEnabled=false
            stopAutoLeft()
            if setAutoLeft then setAutoLeft(false) end
            if MobileButtons.Buttons.autoLeft then MobileButtons.Buttons.autoLeft(false) end
        end
        -- turn off auto right
        if State.autoRightEnabled then
            State.autoRightEnabled=false
            stopAutoRight()
            if setAutoRight then setAutoRight(false) end
            if MobileButtons.Buttons.autoRight then MobileButtons.Buttons.autoRight(false) end
        end
        startAimbot()
    else
        stopAimbot()
    end
    if MobileButtons.Buttons.autoBat then MobileButtons.Buttons.autoBat(on) end
end,"keyAutoBat")
setBatCounter = makePageToggleRow("STEAL","Bat Counter","Auto-counter ragdoll",false,function(on) State.batCounterEnabled=on;if on then startBatCounter() else stopBatCounter() end end)
makePageSectionLabel("MOVEMENT","Auto Walk")
setAutoLeft  = makePageToggleRow("MOVEMENT","Auto Left","Walk to left podium",false,function(on) State.autoLeftEnabled=on;if MobileButtons.Buttons.autoLeft then MobileButtons.Buttons.autoLeft(on) end;if on then startAutoLeft() else stopAutoLeft() end end,"keyAutoLeft")
setAutoRight = makePageToggleRow("MOVEMENT","Auto Right","Walk to right podium",false,function(on) State.autoRightEnabled=on;if MobileButtons.Buttons.autoRight then MobileButtons.Buttons.autoRight(on) end;if on then startAutoRight() else stopAutoRight() end end,"keyAutoRight")
makePageSectionLabel("MOVEMENT","Teleport")
setMenuDropBR = makePageToggleRow("MOVEMENT","Drop Brainrot","TP through floor",false,function(on) if on then runDropBrainrot();task.delay(0.5,function() if setMenuDropBR then setMenuDropBR(false) end;if MobileButtons.Buttons.dropBR then MobileButtons.Buttons.dropBR(false) end end) end end,"keyDropBR")
setMenuTpDown = makePageToggleRow("MOVEMENT","TP to Ground","Snap to nearest floor",false,function(on) if on then tpToGround();task.delay(0.5,function() if setMenuTpDown then setMenuTpDown(false) end;if MobileButtons.Buttons.tpDown then MobileButtons.Buttons.tpDown(false) end end) end end,"keyTpDown")
makePageActionBtn("MOVEMENT","Instant Reset",function() doInstantReset() end)
makePageSectionLabel("MOVEMENT","Mechanics")
setInfJump = makePageToggleRow("MOVEMENT","Infinite Jump",nil,false,function(on) State.infJumpEnabled=on end)
local updateJumpModeUI = makeDualSelector("MOVEMENT","Manual","Hold","manual",function(sel) State.infJumpMode=sel;task.spawn(function() if saveConfig then pcall(saveConfig) end end) end)
setAutoTpDown = makePageToggleRow("MOVEMENT","Auto TP Down",nil,false,function(on) State.autoTpDownEnabled=on end)
makePageInputRow("MOVEMENT","Y Trigger",nil,State.autoTpDownY,function(v) State.autoTpDownY=v end)
makePageSectionLabel("VISUAL","World")
setFps = makePageToggleRow("VISUAL","FPS Boost","Remove particles & shadows",false,function(on) State.fpsBoostEnabled=on;if on then pcall(applyFPSBoost) end end)
makePageSectionLabel("VISUAL","Player")
setAnimToggle  = makePageToggleRow("VISUAL","Anim Pack","Custom animation set",false,function(on) State.animEnabled=on;if on then startAnimToggle() else stopAnimToggle() end end)
setUnwalkToggle= makePageToggleRow("VISUAL","Unwalk","Remove walk animation",false,function(on) if on then startUnwalk() else stopUnwalk() end end)
makePageSectionLabel("CTRL","Defense")
setAntiRag = makePageToggleRow("CTRL","Anti Ragdoll","Cash Hub x EclipseX system",false,function(on) State.antiRagdollEnabled=on;if on then startAntiRagdoll() else stopAntiRagdoll() end end)
setMedusaCounter = makePageToggleRow("CTRL","Medusa Counter","Auto-use medusa head",false,function(on) State.medusaCounterEnabled=on;if on then setupMedusaCounter(LP.Character) else stopMedusaCounter() end end)
makePageSectionLabel("CTRL","Lagger Tools")
setDuelLagUI = makePageToggleRow("CTRL","Duel Lagger","Bomb opponent with lag packets",false,function(on) toggleDuelLagger(on) end)
setBypassTogUI = makePageToggleRow("CTRL","Bypass","Anti-lag + speed boost",false,function(on) toggleBypass(on) end)
makePageInputRow("CTRL","Bypass Speed","Speed boost amount",33,function(v) State.bypassSpeedBoost=v end)
makePageInputRow("CTRL","Lag Inject (ms)","Lag injection in ms (0=off)",28,function(v) State.bypassLagAmount=v/1000 end)
makePageSectionLabel("SETTINGS","Mobile Buttons")
setLockToggle = makePageToggleRow("SETTINGS","Lock Cubes","Prevent accidental drag",true,function(on) MobileButtons.Locked=on end)
setVisToggle  = makePageToggleRow("SETTINGS","Show Cubes","Toggle mobile panel",true,function(on) MobileButtons.Visible=on;for _,c in ipairs(MobileButtons.Containers) do c.Visible=on end end)
makePageSectionLabel("SETTINGS","Panels")
makePageToggleRow("SETTINGS","Lagger Panel","Floating Duel Lag & Bypass panel",false,function(on) State.laggerPanelVisible=on;if laggerPanelGui then laggerPanelGui.Enabled=on end end)
makePageSectionLabel("SETTINGS","Presets")
do
    local nameRow=Instance.new("Frame",tabPages["SETTINGS"]); nameRow.Size=UDim2.new(1,0,0,36); nameRow.BackgroundColor3=C.card; nameRow.BorderSizePixel=0; nameRow.LayoutOrder=pageNextLO("SETTINGS"); Instance.new("UICorner",nameRow).CornerRadius=UDim.new(0,10)
    local nbs=Instance.new("UIStroke",nameRow);nbs.Color=C.borderDim;nbs.Thickness=1
    presetNameBox=Instance.new("TextBox",nameRow); presetNameBox.Size=UDim2.new(1,-12,1,0); presetNameBox.Position=UDim2.new(0,12,0,0); presetNameBox.BackgroundTransparency=1; presetNameBox.PlaceholderText="Preset name..."; presetNameBox.PlaceholderColor3=C.textDim; presetNameBox.Text=""; presetNameBox.TextColor3=C.text; presetNameBox.Font=Enum.Font.GothamBold; presetNameBox.TextSize=12; presetNameBox.ClearTextOnFocus=false; presetNameBox.ZIndex=9
    presetNameBox.Focused:Connect(function() TweenService:Create(nbs,TweenInfo.new(0.15),{Color=C.border}):Play() end)
    presetNameBox.FocusLost:Connect(function() TweenService:Create(nbs,TweenInfo.new(0.15),{Color=C.borderDim}):Play() end)
end
makePageActionBtn("SETTINGS","+ Save Preset",function()
    local nm=(presetNameBox and presetNameBox.Text:match("^%s*(.-)%s*$")) or "";if nm=="" then return end
    local found=false;for i,p in ipairs(Presets) do if p.name==nm then Presets[i].data=buildPresetSnapshot();found=true;break end end
    if not found then table.insert(Presets,{name=nm,data=buildPresetSnapshot()}) end
    savePresetsFile();if presetNameBox then presetNameBox.Text="" end;rebuildPresetList()
end)
do
    local listWrap=Instance.new("Frame",tabPages["SETTINGS"]); listWrap.Size=UDim2.new(1,0,0,0); listWrap.AutomaticSize=Enum.AutomaticSize.Y; listWrap.BackgroundTransparency=1; listWrap.BorderSizePixel=0; listWrap.LayoutOrder=pageNextLO("SETTINGS")
    Instance.new("UIListLayout",listWrap).Padding=UDim.new(0,4)
    local ep=Instance.new("TextLabel",listWrap); ep.Name="EmptyLabel"; ep.Size=UDim2.new(1,0,0,24); ep.BackgroundTransparency=1; ep.Text="No presets saved."; ep.TextColor3=C.textDim; ep.Font=Enum.Font.Gotham; ep.TextSize=11; ep.TextXAlignment=Enum.TextXAlignment.Center; ep.LayoutOrder=1
    presetListFrame=listWrap
end
makePageActionBtn("SETTINGS","Save Config",function() if saveConfig then pcall(saveConfig) end end)
rebuildPresetList=function()
    if not presetListFrame then return end
    for _,ch in ipairs(presetListFrame:GetChildren()) do if ch.Name~="EmptyLabel" and not ch:IsA("UIListLayout") then ch:Destroy() end end
    local ep=presetListFrame:FindFirstChild("EmptyLabel"); if ep then ep.Visible=(#Presets==0) end
    for i,preset in ipairs(Presets) do
        local row=Instance.new("Frame",presetListFrame); row.Size=UDim2.new(1,0,0,36); row.BackgroundColor3=C.card; row.BorderSizePixel=0; row.LayoutOrder=i+1; Instance.new("UICorner",row).CornerRadius=UDim.new(0,10); Instance.new("UIStroke",row).Color=C.borderDim
        local nm=Instance.new("TextLabel",row); nm.Size=UDim2.new(1,-90,1,0); nm.Position=UDim2.new(0,12,0,0); nm.BackgroundTransparency=1; nm.Text=preset.name; nm.TextColor3=C.text; nm.Font=Enum.Font.GothamBold; nm.TextSize=12; nm.TextXAlignment=Enum.TextXAlignment.Left; nm.TextTruncate=Enum.TextTruncate.AtEnd
        local lb=Instance.new("TextButton",row); lb.Size=UDim2.new(0,42,0,24); lb.Position=UDim2.new(1,-88,0.5,-12); lb.BackgroundColor3=C.onBg; lb.BorderSizePixel=0; lb.Text="Load"; lb.TextColor3=C.white; lb.Font=Enum.Font.GothamBold; lb.TextSize=11; lb.ZIndex=9; Instance.new("UICorner",lb).CornerRadius=UDim.new(0,10)
        lb.MouseButton1Click:Connect(function() applyPreset(preset.data); saveLastPresetName(preset.name); lb.Text="OK"; task.delay(1.2,function() if lb and lb.Parent then lb.Text="Load" end end) end)
        local db=Instance.new("TextButton",row); db.Size=UDim2.new(0,30,0,24); db.Position=UDim2.new(1,-42,0.5,-12); db.BackgroundColor3=C.inputBg; db.BorderSizePixel=0; db.Text="X"; db.TextColor3=C.textDim; db.Font=Enum.Font.GothamBold; db.TextSize=11; db.ZIndex=9; Instance.new("UICorner",db).CornerRadius=UDim.new(0,10); Instance.new("UIStroke",db).Color=C.borderDim
        db.MouseButton1Click:Connect(function() table.remove(Presets,i); savePresetsFile(); rebuildPresetList() end)
    end
end
applyPreset=function(data)
    if data.normalSpeed      then State.normalSpeed=data.normalSpeed;      if normalBox      then normalBox.Text=tostring(data.normalSpeed)           end end
    if data.carrySpeed       then State.carrySpeed=data.carrySpeed;        if carryBox       then carryBox.Text=tostring(data.carrySpeed)             end end
    if data.laggerSpeed      then State.laggerSpeed=data.laggerSpeed;      if laggerBox      then laggerBox.Text=tostring(data.laggerSpeed)           end end
    if data.laggerCarrySpeed then State.laggerCarrySpeed=data.laggerCarrySpeed; if laggerCarryBox then laggerCarryBox.Text=tostring(data.laggerCarrySpeed) end end
    if data.stealRadius      then AutoSteal.Radius=data.stealRadius;       if progressRadLbl then progressRadLbl.Text="Radius: "..data.stealRadius end; if radiusBox then radiusBox.Text=tostring(data.stealRadius) end end
    if data.stealDuration    then AutoSteal.Duration=data.stealDuration end
    if data.infJump~=nil     and setInfJump         then State.infJumpEnabled=data.infJump;           setInfJump(data.infJump) end
    if data.infJumpMode      then State.infJumpMode=data.infJumpMode;       updateJumpModeUI(data.infJumpMode) end
    if data.antiRagdoll~=nil and setAntiRag         then State.antiRagdollEnabled=data.antiRagdoll;   setAntiRag(data.antiRagdoll);    if data.antiRagdoll then startAntiRagdoll()  else stopAntiRagdoll()  end end
    if data.fpsBoost~=nil    and setFps             then State.fpsBoostEnabled=data.fpsBoost;         setFps(data.fpsBoost);           if data.fpsBoost    then pcall(applyFPSBoost) end end
    if data.medusaCounter~=nil and setMedusaCounter then State.medusaCounterEnabled=data.medusaCounter; setMedusaCounter(data.medusaCounter); if data.medusaCounter then setupMedusaCounter(LP.Character) else stopMedusaCounter() end end
    if data.batCounter~=nil  and setBatCounter      then State.batCounterEnabled=data.batCounter;     setBatCounter(data.batCounter);  if data.batCounter  then startBatCounter()   else stopBatCounter()   end end
    if data.autoSteal~=nil   and setInstaGrab       then AutoSteal.Enabled=data.autoSteal;            setInstaGrab(data.autoSteal);    if data.autoSteal   then pcall(startAutoSteal) else stopAutoSteal() end end
    if data.animEnabled~=nil and setAnimToggle      then State.animEnabled=data.animEnabled;          setAnimToggle(data.animEnabled); if data.animEnabled then startAnimToggle()   else stopAnimToggle()   end end
    if data.autoTpDown~=nil  and setAutoTpDown      then State.autoTpDownEnabled=data.autoTpDown;     setAutoTpDown(data.autoTpDown) end
    if data.autoTpDownY      then State.autoTpDownY=data.autoTpDownY end
    -- Extra fields
    if data.duelLagger~=nil  and setDuelLagUI    then toggleDuelLagger(data.duelLagger); setDuelLagUI(data.duelLagger) end
    if data.bypass~=nil      and setBypassTogUI        then toggleBypass(data.bypass); setBypassTogUI(data.bypass) end
    if data.bypassSpeedBoost then State.bypassSpeedBoost=data.bypassSpeedBoost end
    if data.bypassLagAmount  then State.bypassLagAmount=data.bypassLagAmount end
    if data.speedType        then State.speedType=data.speedType end
    if data.laggerActive~=nil     then State.laggerActive=data.laggerActive end
    if data.laggerCarryActive~=nil then State.laggerCarryActive=data.laggerCarryActive end
    refreshUIToggles()
end
local function createMobilePanel()
    local BTN_W=48; local BTN_H=48; local CORNER=12; local GAP=10
    local COL1_X=-(BTN_W+GAP+BTN_W+10); local COL2_X=-(BTN_W+10); local BASE_Y=0.30
    local ROW_Y={-((BTN_H*4+GAP*3)/2),-((BTN_H*4+GAP*3)/2)+(BTN_H+GAP),-((BTN_H*4+GAP*3)/2)+(BTN_H+GAP)*2,-((BTN_H*4+GAP*3)/2)+(BTN_H+GAP)*3}
    local function makeSepBtn(name,text,defPos,saveKey,cb)
        local sg=Instance.new("ScreenGui"); sg.Name="AnguishMobile_"..name; sg.Parent=LP:WaitForChild("PlayerGui"); sg.ResetOnSpawn=false; sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; sg.DisplayOrder=15
        local cont=Instance.new("Frame",sg); cont.Name=name; cont.BackgroundColor3=C.panel; cont.BorderSizePixel=0; cont.Size=UDim2.new(0,BTN_W,0,BTN_H); cont.Position=defPos
        Instance.new("UICorner",cont).CornerRadius=UDim.new(0,CORNER); Instance.new("UIStroke",cont).Color=C.borderDim
        local btn=Instance.new("TextButton",cont); btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Font=Enum.Font.GothamBlack; btn.Text=text; btn.TextColor3=C.text; btn.TextSize=11; btn.TextWrapped=true; btn.AutoButtonColor=false
        local function setActive(s) TweenService:Create(cont,TweenInfo.new(0.15),{BackgroundColor3=s and C.onBg or C.panel}):Play(); btn.TextColor3=s and C.white or C.text end
        btn.MouseButton1Click:Connect(function() if cb then cb(setActive) end end)
        -- always draggable
        local drg,di,ds,sp2=false,nil,nil,nil
        cont.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drg=true;ds=i.Position;sp2=cont.Position;i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then drg=false end end) end end)
        cont.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di=i end end)
        UIS.InputChanged:Connect(function(i) if i==di and drg then local dx=i.Position.X-ds.X;local dy=i.Position.Y-ds.Y;cont.Position=UDim2.new(sp2.X.Scale,sp2.X.Offset+dx,sp2.Y.Scale,sp2.Y.Offset+dy) end end)
        local sv=nil; pcall(function() sv=readfile(saveKey) end)
        if sv and sv~="" then local pts={};for pt in sv:gmatch("[^,]+") do table.insert(pts,pt) end;if #pts>=4 then cont.Position=UDim2.new(tonumber(pts[1]),tonumber(pts[2]),tonumber(pts[3]),tonumber(pts[4])) end end
        local lastS=0; cont:GetPropertyChangedSignal("Position"):Connect(function() if tick()-lastS>0.5 then lastS=tick();local p=cont.Position;pcall(function() writefile(saveKey,string.format("%.3f,%.1f,%.3f,%.1f",p.X.Scale,p.X.Offset,p.Y.Scale,p.Y.Offset)) end) end end)
        cont.Visible=MobileButtons.Visible; table.insert(MobileButtons.Containers,cont); return setActive
    end
    local dropSA =makeSepBtn("BtnDropBR",   "DROP\nBR",    UDim2.new(1,COL1_X,BASE_Y,ROW_Y[1]),"AnguishBtn_dropbr.txt",    function(sa) runDropBrainrot();if setMenuDropBR then setMenuDropBR(true) end;task.delay(0.5,function() if setMenuDropBR then setMenuDropBR(false) end;sa(false) end) end)
    local autoLSA,autoRSA,batSA
    autoLSA=makeSepBtn("BtnAutoLeft","AUTO\nLEFT",UDim2.new(1,COL2_X,BASE_Y,ROW_Y[1]),"AnguishBtn_autoleft.txt",function(sa)
        State.autoLeftEnabled=not State.autoLeftEnabled
        if State.autoLeftEnabled then
            if State.autoRightEnabled then State.autoRightEnabled=false;stopAutoRight();if setAutoRight then setAutoRight(false) end;if autoRSA then autoRSA(false) end end
            if State.aimbotActive then State.aimbotActive=false;stopAimbot();if setAutoBat then setAutoBat(false) end;if batSA then batSA(false) end end
            startAutoLeft();sa(true)
        else stopAutoLeft();sa(false) end
        if setAutoLeft then setAutoLeft(State.autoLeftEnabled) end
    end)
    batSA=makeSepBtn("BtnAutoBat","BAT\nAIMBOT",UDim2.new(1,COL1_X,BASE_Y,ROW_Y[2]),"AnguishBtn_autobat.txt",function(sa)
        State.aimbotActive=not State.aimbotActive
        if State.aimbotActive then
            if State.autoLeftEnabled then State.autoLeftEnabled=false;stopAutoLeft();if setAutoLeft then setAutoLeft(false) end;if autoLSA then autoLSA(false) end end
            if State.autoRightEnabled then State.autoRightEnabled=false;stopAutoRight();if setAutoRight then setAutoRight(false) end;if autoRSA then autoRSA(false) end end
            startAimbot();sa(true)
        else stopAimbot();sa(false) end
        if setAutoBat then setAutoBat(State.aimbotActive) end
    end)
    autoRSA=makeSepBtn("BtnAutoRight","AUTO\nRIGHT",UDim2.new(1,COL2_X,BASE_Y,ROW_Y[2]),"AnguishBtn_autoright.txt",function(sa)
        State.autoRightEnabled=not State.autoRightEnabled
        if State.autoRightEnabled then
            if State.autoLeftEnabled then State.autoLeftEnabled=false;stopAutoLeft();if setAutoLeft then setAutoLeft(false) end;if autoLSA then autoLSA(false) end end
            if State.aimbotActive then State.aimbotActive=false;stopAimbot();if setAutoBat then setAutoBat(false) end;if batSA then batSA(false) end end
            startAutoRight();sa(true)
        else stopAutoRight();sa(false) end
        if setAutoRight then setAutoRight(State.autoRightEnabled) end
    end)
    local tpSA   =makeSepBtn("BtnTpDown",   "TP\nDOWN",    UDim2.new(1,COL1_X,BASE_Y,ROW_Y[3]),"AnguishBtn_tpdown.txt",    function(sa) tpToGround();if setMenuTpDown then setMenuTpDown(true) end;task.delay(0.5,function() if setMenuTpDown then setMenuTpDown(false) end;sa(false) end) end)
    local carrySA=makeSepBtn("BtnCarrySpd", "CARRY\nSPD",  UDim2.new(1,COL2_X,BASE_Y,ROW_Y[3]),"AnguishBtn_carryspd.txt",  function(sa) toggleSpeedType();sa(State.speedType=="carry") end)
    local lagCSA =makeSepBtn("BtnLaggerCarry","LAGGER\nCARRY",UDim2.new(1,COL1_X,BASE_Y,ROW_Y[4]),"AnguishBtn_laggercarry.txt",function(sa) toggleLaggerCarry();sa(State.laggerCarryActive) end)
    local lagSA  =makeSepBtn("BtnLaggerMode","LAGGER\nMODE",UDim2.new(1,COL2_X,BASE_Y,ROW_Y[4]),"AnguishBtn_laggermode.txt",function(sa) toggleLagger();sa(State.laggerActive) end)
    MobileButtons.Buttons={autoLeft=autoLSA,autoRight=autoRSA,autoBat=batSA,carrySpeed=carrySA,lagger=lagSA,dropBR=dropSA,tpDown=tpSA,laggerCarry=lagCSA}
    task.spawn(function() task.wait(0.1);batSA(State.aimbotActive);carrySA(State.speedType=="carry");lagSA(State.laggerActive);lagCSA(State.laggerCarryActive);autoLSA(State.autoLeftEnabled);autoRSA(State.autoRightEnabled) end)
end
local SWING_COOLDOWN = 0.25
local BAT_HIT_RANGE  = 16
local function findBatTool()
    local c = LP.Character; if not c then return nil end
    local bp = LP:FindFirstChildOfClass("Backpack")
    local SlapList = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
    for _, ch in ipairs(c:GetChildren()) do
        if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then return ch end
    end
    if bp then
        for _, ch in ipairs(bp:GetChildren()) do
            if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then return ch end
        end
    end
    for _, name in ipairs(SlapList) do
        local t = (c and c:FindFirstChild(name)) or (bp and bp:FindFirstChild(name))
        if t then return t end
    end
    return nil
end
local function getClosestPlayer()
    if not LP.Character then return nil, math.huge end
    local myHRP = LP.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil, math.huge end
    local cp, cd = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            local ph = p.Character:FindFirstChildOfClass("Humanoid")
            if tr and ph and ph.Health > 0 then
                local d = (myHRP.Position - tr.Position).Magnitude
                if d < cd then cd = d; cp = p end
            end
        end
    end
    return cp, cd
end
local function tryHitBat()
    if State.hittingCooldown then return end
    local char = LP.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    State.hittingCooldown = true
    pcall(function()
        local c = LP.Character; if not c then return end
        local tool = nil
        for _, v in ipairs(c:GetChildren()) do if v:IsA("Tool") then tool = v; break end end
        if not tool then return end
        local remote = tool:FindFirstChildOfClass("RemoteEvent")
        if remote then pcall(function() remote:FireServer() end)
        else pcall(function() tool:Activate() end) end
    end)
    task.delay(SWING_COOLDOWN, function() State.hittingCooldown = false end)
end
local aimbotConnection = nil
local _lastTargetPos  = nil
local _lastTargetTime = nil
local _lastTargetVel  = Vector3.new(0,0,0)
local _lastDirChange  = 0
local _prevErrorY     = 0
startAimbot = function()
    if aimbotConnection then return end
    State.aimbotActive = true
    local char = LP.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    local bat  = findBatTool()
    if bat and hum and bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
    if hum then hum.AutoRotate = true end
    _lastTargetPos  = nil; _lastTargetTime = nil
    _lastTargetVel  = Vector3.new(0,0,0)
    _lastDirChange  = 0;   _prevErrorY     = 0
    aimbotConnection = RunService.Heartbeat:Connect(function()
        if not State.aimbotActive then return end
        local c = LP.Character; if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart")
        local myHum = c:FindFirstChildOfClass("Humanoid")
        if not root or not myHum or myHum.Health <= 0 then return end
        -- keep bat equipped
        local curBat = findBatTool()
        local hasOther = false
        for _, v in ipairs(c:GetChildren()) do if v:IsA("Tool") and v ~= curBat then hasOther = true; break end end
        if curBat and curBat.Parent ~= c and not hasOther then pcall(function() myHum:EquipTool(curBat) end) end
        local target, dist = getClosestPlayer()
        if target and target.Character then
            local tr   = target.Character:FindFirstChild("HumanoidRootPart")
            local head = target.Character:FindFirstChild("Head")
            if tr then
                local targetPos = head and (head.Position - Vector3.new(0,1.2,0)) or (tr.Position + Vector3.new(0,0.8,0))
                if head then
                    local maxH = head.Position.Y - 0.5
                    if targetPos.Y > maxH then targetPos = Vector3.new(targetPos.X, maxH, targetPos.Z) end
                end
                local now = tick()
                local dt  = now - (_lastTargetTime or now)
                if _lastTargetPos and dt > 0 and dt < 0.1 then
                    local newVel = (targetPos - _lastTargetPos) / dt
                    newVel = Vector3.new(
                        math.clamp(newVel.X,-80,80),
                        math.clamp(newVel.Y,-100,100),
                        math.clamp(newVel.Z,-80,80))
                    if _lastTargetVel:Dot(newVel) < -0.5 then _lastDirChange = now end
                    _lastTargetVel = newVel
                end
                _lastTargetPos  = targetPos
                _lastTargetTime = now
                local leadTime = (now - _lastDirChange < 0.25) and 0.10 or 0.18
                local predicted = targetPos + _lastTargetVel * leadTime
                local horDist = Vector3.new(predicted.X-root.Position.X,0,predicted.Z-root.Position.Z).Magnitude
                local spdHor  = (horDist > 4) and 60 or 55
                -- PID vertical
                local yError    = predicted.Y - root.Position.Y
                local dtPID     = math.max(dt, 0.02)
                local kp, kd    = 2.2, 0.2
                local vSpeed    = kp*yError + kd*(yError-_prevErrorY)/dtPID
                _prevErrorY     = yError
                vSpeed          = math.clamp(vSpeed, -60, 35)
                if math.abs(yError) < 0.5 then vSpeed = vSpeed * 0.15 end
                local dir = predicted - root.Position
                local horDir = Vector3.new(dir.X,0,dir.Z)
                if horDir.Magnitude > 0.01 then horDir = horDir.Unit else horDir = Vector3.new(0,0,0) end
                root.Velocity = Vector3.new(horDir.X*spdHor, vSpeed, horDir.Z*spdHor)
                local curTool = nil
                for _, v in ipairs(c:GetChildren()) do if v:IsA("Tool") then curTool = v; break end end
                if dist <= BAT_HIT_RANGE and curTool and
                    (curTool.Name:lower():find("bat") or curTool.Name:lower():find("slap")) then
                    tryHitBat()
                end
            end
        else
            root.Velocity = Vector3.new(0, root.Velocity.Y, 0)
            _lastTargetPos = nil; _lastTargetTime = nil
            _lastTargetVel = Vector3.new(0,0,0)
            _lastDirChange = 0;   _prevErrorY = 0
        end
    end)
end
stopAimbot = function()
    State.aimbotActive = false
    if aimbotConnection then aimbotConnection:Disconnect(); aimbotConnection = nil end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if root then pcall(function() root.Velocity = Vector3.new(0, root.Velocity.Y, 0) end) end
    if hum  then hum:Move(Vector3.zero, false); hum.AutoRotate = true end
    State.hittingCooldown = false
end
startAntiRagdoll=function()
    if #AntiRagdollConns>0 then return end
    local char=LP.Character or LP.CharacterAdded:Wait()
    local humanoid=char:WaitForChild("Humanoid")
    local root=char:WaitForChild("HumanoidRootPart")
    local animator=humanoid:WaitForChild("Animator")
    local maxVelocity=40;local clampVelocity=25;local maxClamp=15;local lastVelocity=Vector3.new(0,0,0)
    local function IsRagdollState() local s=humanoid:GetState();return s==Enum.HumanoidStateType.Physics or s==Enum.HumanoidStateType.Ragdoll or s==Enum.HumanoidStateType.FallingDown or s==Enum.HumanoidStateType.GettingUp end
    local function CleanRagdollEffects()
        for _,obj in pairs(char:GetDescendants()) do
            if obj:IsA("BallSocketConstraint") or obj:IsA("NoCollisionConstraint") or obj:IsA("HingeConstraint") or (obj:IsA("Attachment") and (obj.Name=="A" or obj.Name=="B")) then obj:Destroy()
            elseif obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyGyro") then obj:Destroy()
            elseif obj:IsA("Motor6D") then obj.Enabled=true end
        end
        for _,track in pairs(animator:GetPlayingAnimationTracks()) do
            local n=track.Animation and track.Animation.Name:lower() or ""
            if n:find("rag") or n:find("fall") or n:find("hurt") or n:find("down") then track:Stop(0) end
        end
    end
    local function ReEnableControls()
        pcall(function() require(LP:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls():Enable() end)
        workspace.CurrentCamera.CameraSubject=humanoid
    end
    table.insert(AntiRagdollConns,humanoid.StateChanged:Connect(function()
        if IsRagdollState() then humanoid:ChangeState(Enum.HumanoidStateType.Running);CleanRagdollEffects();workspace.CurrentCamera.CameraSubject=humanoid;ReEnableControls() end
    end))
    table.insert(AntiRagdollConns,RunService.Heartbeat:Connect(function()
        if not State.antiRagdollEnabled then return end
        if IsRagdollState() then
            CleanRagdollEffects()
            local vel=root.AssemblyLinearVelocity
            if (vel-lastVelocity).Magnitude>maxVelocity and vel.Magnitude>clampVelocity then root.AssemblyLinearVelocity=vel.Unit*math.min(vel.Magnitude,maxClamp) end
            lastVelocity=vel
        end
    end))
    table.insert(AntiRagdollConns,char.DescendantAdded:Connect(function() if IsRagdollState() then CleanRagdollEffects() end end))
    table.insert(AntiRagdollConns,LP.CharacterAdded:Connect(function(newChar)
        char=newChar;humanoid=newChar:WaitForChild("Humanoid");root=newChar:WaitForChild("HumanoidRootPart");animator=humanoid:WaitForChild("Animator");lastVelocity=Vector3.new(0,0,0)
        ReEnableControls();CleanRagdollEffects()
    end))
    ReEnableControls();CleanRagdollEffects()
end
stopAntiRagdoll=function()
    for _,conn in pairs(AntiRagdollConns) do pcall(function() conn:Disconnect() end) end
    AntiRagdollConns={}
end
local function tpToGround()
    local char=LP.Character;if not char then return end;local root=char:FindFirstChild("HumanoidRootPart");if not root then return end
    local rot=root.CFrame.Rotation;local rp=RaycastParams.new();rp.FilterType=Enum.RaycastFilterType.Exclude;rp.FilterDescendantsInstances={char}
    local res=workspace:Raycast(root.Position,Vector3.new(0,-500,0),rp)
    if res then root.CFrame=CFrame.new(res.Position+Vector3.new(0,3,0))*rot else root.CFrame=CFrame.new(root.Position+Vector3.new(0,-20,0))*rot end
end
local function runDropBrainrot()
    if State.dropBrainrotActive then return end;local char=LP.Character;if not char then return end;local root=char:FindFirstChild("HumanoidRootPart");if not root then return end
    State.dropBrainrotActive=true;local t0=tick();local dc
    dc=RunService.Heartbeat:Connect(function()
        local r=char and char:FindFirstChild("HumanoidRootPart");if not r then dc:Disconnect();State.dropBrainrotActive=false;return end
        if tick()-t0>=DROP_ASCEND_DURATION then
            dc:Disconnect();local rp=RaycastParams.new();rp.FilterDescendantsInstances={char};rp.FilterType=Enum.RaycastFilterType.Exclude
            local rr=workspace:Raycast(r.Position,Vector3.new(0,-2000,0),rp)
            if rr then local hum2=char:FindFirstChildOfClass("Humanoid");local off=(hum2 and hum2.HipHeight or 2)+(r.Size.Y/2);r.CFrame=CFrame.new(r.Position.X,rr.Position.Y+off,r.Position.Z);r.AssemblyLinearVelocity=Vector3.zero end
            State.dropBrainrotActive=false;return
        end
        r.AssemblyLinearVelocity=Vector3.new(r.AssemblyLinearVelocity.X,DROP_ASCEND_SPEED,r.AssemblyLinearVelocity.Z)
    end)
end
startAutoLeft=function()
    if Conns.autoLeft then Conns.autoLeft:Disconnect() end;State.autoLeftPhase=1
    Conns.autoLeft=RunService.Heartbeat:Connect(function()
        if not State.autoLeftEnabled then return end
        local char=LP.Character;if not char then return end
        local root=char:FindFirstChild("HumanoidRootPart");local hum2=char:FindFirstChildOfClass("Humanoid");if not root or not hum2 then return end
        local spd=getAutoMoveSpeed()
        if State.autoLeftPhase==1 then
            local tgt=Vector3.new(POS_L1.X,root.Position.Y,POS_L1.Z)
            if (tgt-root.Position).Magnitude<1 then State.autoLeftPhase=2;return end
            local d=(POS_L1-root.Position);local mv=Vector3.new(d.X,0,d.Z).Unit;hum2:Move(mv,false);root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif State.autoLeftPhase==2 then
            local tgt=Vector3.new(POS_L2.X,root.Position.Y,POS_L2.Z)
            if (tgt-root.Position).Magnitude<1 then
                hum2:Move(Vector3.zero,false);root.AssemblyLinearVelocity=Vector3.new(0,root.AssemblyLinearVelocity.Y,0)
                State.autoLeftEnabled=false;if Conns.autoLeft then Conns.autoLeft:Disconnect();Conns.autoLeft=nil end;State.autoLeftPhase=1
                if setAutoLeft then setAutoLeft(false) end;if MobileButtons.Buttons.autoLeft then MobileButtons.Buttons.autoLeft(false) end;return
            end
            local d=(POS_L2-root.Position);local mv=Vector3.new(d.X,0,d.Z).Unit;hum2:Move(mv,false);root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end
stopAutoLeft=function()
    if Conns.autoLeft then Conns.autoLeft:Disconnect();Conns.autoLeft=nil end;State.autoLeftPhase=1
    local char=LP.Character;if char then local hum2=char:FindFirstChildOfClass("Humanoid");if hum2 then hum2:Move(Vector3.zero,false) end end
    if MobileButtons.Buttons.autoLeft then MobileButtons.Buttons.autoLeft(false) end
end
startAutoRight=function()
    if Conns.autoRight then Conns.autoRight:Disconnect() end;State.autoRightPhase=1
    Conns.autoRight=RunService.Heartbeat:Connect(function()
        if not State.autoRightEnabled then return end
        local char=LP.Character;if not char then return end
        local root=char:FindFirstChild("HumanoidRootPart");local hum2=char:FindFirstChildOfClass("Humanoid");if not root or not hum2 then return end
        local spd=getAutoMoveSpeed()
        if State.autoRightPhase==1 then
            local tgt=Vector3.new(POS_R1.X,root.Position.Y,POS_R1.Z)
            if (tgt-root.Position).Magnitude<1 then State.autoRightPhase=2;return end
            local d=(POS_R1-root.Position);local mv=Vector3.new(d.X,0,d.Z).Unit;hum2:Move(mv,false);root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif State.autoRightPhase==2 then
            local tgt=Vector3.new(POS_R2.X,root.Position.Y,POS_R2.Z)
            if (tgt-root.Position).Magnitude<1 then
                hum2:Move(Vector3.zero,false);root.AssemblyLinearVelocity=Vector3.new(0,root.AssemblyLinearVelocity.Y,0)
                State.autoRightEnabled=false;if Conns.autoRight then Conns.autoRight:Disconnect();Conns.autoRight=nil end;State.autoRightPhase=1
                if setAutoRight then setAutoRight(false) end;if MobileButtons.Buttons.autoRight then MobileButtons.Buttons.autoRight(false) end;return
            end
            local d=(POS_R2-root.Position);local mv=Vector3.new(d.X,0,d.Z).Unit;hum2:Move(mv,false);root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end
stopAutoRight=function()
    if Conns.autoRight then Conns.autoRight:Disconnect();Conns.autoRight=nil end;State.autoRightPhase=1
    local char=LP.Character;if char then local hum2=char:FindFirstChildOfClass("Humanoid");if hum2 then hum2:Move(Vector3.zero,false) end end
    if MobileButtons.Buttons.autoRight then MobileButtons.Buttons.autoRight(false) end
end
local function findMedusa() local char=LP.Character;if not char then return nil end;for _,t in ipairs(char:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end;local bp=LP:FindFirstChild("Backpack");if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end;return nil end
local function useMedusaCounter() if State.medusaDebounce then return end;if tick()-State.medusaLastUsed<MEDUSA_COOLDOWN then return end;local char=LP.Character;if not char then return end;State.medusaDebounce=true;local med=findMedusa();if not med then State.medusaDebounce=false;return end;if med.Parent~=char then local hum2=char:FindFirstChildOfClass("Humanoid");if hum2 then hum2:EquipTool(med) end end;pcall(function() med:Activate() end);State.medusaLastUsed=tick();State.medusaDebounce=false end
local function onAnchorChanged(part) return part:GetPropertyChangedSignal("Anchored"):Connect(function() if part.Anchored and part.Transparency==1 then useMedusaCounter() end end) end
setupMedusaCounter=function(char) stopMedusaCounter();if not char then return end;for _,p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(p)) end end;table.insert(Conns.anchor,char.DescendantAdded:Connect(function(p) if p:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(p)) end end)) end
stopMedusaCounter=function() for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={} end
applyFPSBoost=function()
    pcall(function() setfpscap(999999999) end)
    local function pO(v) pcall(function() if v:IsA("Model") then v.LevelOfDetail=Enum.ModelLevelOfDetail.Disabled;v.ModelStreamingMode=Enum.ModelStreamingMode.Nonatomic elseif v:IsA("MeshPart") then v.CastShadow=false;v.DoubleSided=false;v.RenderFidelity=Enum.RenderFidelity.Performance elseif v:IsA("BasePart") then v.CastShadow=false;v.Material=Enum.Material.Plastic;v.Reflectance=0 elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency=1 elseif v:IsA("SpecialMesh") then v.TextureId="" elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled=false elseif v:IsA("SurfaceAppearance") or v:IsA("MaterialVariant") then v:Destroy() elseif v:IsA("Attachment") then v.Visible=false end end) end
    for _,v in pairs(workspace:GetDescendants()) do pO(v) end
    pcall(function() local L=game:GetService("Lighting");for _,v in pairs(L:GetDescendants()) do pcall(function() if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Clouds") or v:IsA("PostEffect") or v:IsA("ColorCorrectionEffect") then v:Destroy() end end) end;pcall(function() sethiddenproperty(L,"Technology",Enum.Technology.Legacy) end);L.GlobalShadows=false;L.FogEnd=9e9;L.Brightness=0;local ter=workspace:FindFirstChildOfClass("Terrain");if ter then pcall(function() sethiddenproperty(ter,"Decoration",false) end);ter.WaterReflectance=0;ter.WaterTransparency=0.7;ter.WaterWaveSize=0;ter.WaterWaveSpeed=0 end end)
    workspace.DescendantAdded:Connect(function(v) if State.fpsBoostEnabled then task.spawn(pO,v) end end)
end
startUnwalk=function() if State.unwalkEnabled then return end;State.unwalkEnabled=true;local c=LP.Character;if not c then return end;local hum2=c:FindFirstChildOfClass("Humanoid");if hum2 then for _,t in ipairs(hum2:GetPlayingAnimationTracks()) do t:Stop() end end;local anim=c:FindFirstChild("Animate");if anim then savedAnimate=anim:Clone();anim:Destroy() end end
stopUnwalk=function() if not State.unwalkEnabled then return end;State.unwalkEnabled=false;local c=LP.Character;if c and savedAnimate then savedAnimate.Parent=c;savedAnimate.Disabled=false;savedAnimate=nil end;task.spawn(function() task.wait(0.15);local char=LP.Character;if not char then return end;if State.animEnabled then saveOriginalAnims(char);applyAnimPack(char) else restoreOriginalAnims(char) end end) end
startBatCounter=function()
    if Conns.batCounter then return end
    Conns.batCounter=RunService.Heartbeat:Connect(function()
        if not State.batCounterEnabled or State.batCounterDebounce then return end
        local char=LP.Character;if not char then return end;local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
        local st=hum2:GetState()
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
            State.batCounterDebounce=true
            task.spawn(function()
                local bat=getBat()
                if bat then
                    local hum3=char:FindFirstChildOfClass("Humanoid")
                    if bat.Parent~=char and hum3 then pcall(function() hum3:EquipTool(bat) end);task.wait(0.05) end
                    local remote=bat:FindFirstChildWhichIsA("RemoteEvent")
                    if remote then pcall(function() remote:FireServer() end);task.wait(0.15);pcall(function() remote:FireServer() end)
                    else pcall(function() bat:Activate() end);task.wait(0.15);pcall(function() bat:Activate() end) end
                end
                task.wait(0.5);State.batCounterDebounce=false
            end)
        end
    end)
end
stopBatCounter=function() if Conns.batCounter then Conns.batCounter:Disconnect();Conns.batCounter=nil end;State.batCounterDebounce=false end
saveConfig=function()
    local cfg={normalSpeed=State.normalSpeed,carrySpeed=State.carrySpeed,laggerSpeed=State.laggerSpeed,laggerCarrySpeed=State.laggerCarrySpeed,speedType=State.speedType,laggerActive=State.laggerActive,laggerCarryActive=State.laggerCarryActive,stealRadius=AutoSteal.Radius,stealDuration=AutoSteal.Duration,infJump=State.infJumpEnabled,infJumpMode=State.infJumpMode,antiRagdoll=State.antiRagdollEnabled,fpsBoost=State.fpsBoostEnabled,medusaCounter=State.medusaCounterEnabled,batCounter=State.batCounterEnabled,autoStealEnabled=AutoSteal.Enabled,animEnabled=State.animEnabled,autoTpDown=State.autoTpDownEnabled,autoTpDownY=State.autoTpDownY,mobileLocked=MobileButtons.Locked,mobileVisible=MobileButtons.Visible,keyAutoLeft=State.keyAutoLeft.Name,keyAutoRight=State.keyAutoRight.Name,keyDropBR=State.keyDropBR.Name,keyTpDown=State.keyTpDown.Name,keyAutoBat=State.keyAutoBat.Name,keyGuiHide=State.keyGuiHide.Name,
    -- Extra fields
    duelLaggerActive=State.duelLaggerActive,bypassActive=State.bypassActive,bypassSpeedBoost=State.bypassSpeedBoost,bypassLagAmount=State.bypassLagAmount}
    local ok,enc=pcall(function() return HttpService:JSONEncode(cfg) end);if ok then pcall(function() _writefile(CONFIG_FILE,enc) end) end
end
loadConfig=function()
    local has=false;pcall(function() has=_isfile(CONFIG_FILE) end);if not has then return end
    local raw;pcall(function() raw=_readfile(CONFIG_FILE) end);if not raw then return end
    local ok,cfg=pcall(function() return HttpService:JSONDecode(raw) end);if not ok or not cfg then return end
    if cfg.normalSpeed      then State.normalSpeed=cfg.normalSpeed;      if normalBox      then normalBox.Text=tostring(cfg.normalSpeed) end end
    if cfg.carrySpeed       then State.carrySpeed=cfg.carrySpeed;        if carryBox       then carryBox.Text=tostring(cfg.carrySpeed) end end
    if cfg.laggerSpeed      then State.laggerSpeed=cfg.laggerSpeed;      if laggerBox      then laggerBox.Text=tostring(cfg.laggerSpeed) end end
    if cfg.laggerCarrySpeed then State.laggerCarrySpeed=cfg.laggerCarrySpeed;if laggerCarryBox then laggerCarryBox.Text=tostring(cfg.laggerCarrySpeed) end end
    if cfg.speedType=="normal" or cfg.speedType=="carry" then State.speedType=cfg.speedType end
    if type(cfg.laggerActive)=="boolean"      then State.laggerActive=cfg.laggerActive end
    if type(cfg.laggerCarryActive)=="boolean" then State.laggerCarryActive=cfg.laggerCarryActive end
    if cfg.stealRadius   then AutoSteal.Radius=cfg.stealRadius;   if progressRadLbl then progressRadLbl.Text="Radius: "..cfg.stealRadius end;if radiusBox then radiusBox.Text=tostring(cfg.stealRadius) end end
    if cfg.stealDuration then AutoSteal.Duration=cfg.stealDuration end
    if cfg.infJump       then State.infJumpEnabled=true;     if setInfJump    then setInfJump(true) end end
    if cfg.infJumpMode=="manual" or cfg.infJumpMode=="hold" then State.infJumpMode=cfg.infJumpMode;updateJumpModeUI(cfg.infJumpMode) end
    if cfg.autoTpDown    then State.autoTpDownEnabled=true;  if setAutoTpDown then setAutoTpDown(true) end end
    if cfg.autoTpDownY   then State.autoTpDownY=cfg.autoTpDownY end
    if cfg.antiRagdoll   then State.antiRagdollEnabled=true; if setAntiRag    then setAntiRag(true) end;startAntiRagdoll() end
    if cfg.fpsBoost      then State.fpsBoostEnabled=true;    if setFps        then setFps(true) end;pcall(applyFPSBoost) end
    if cfg.medusaCounter then State.medusaCounterEnabled=true;if setMedusaCounter then setMedusaCounter(true) end;setupMedusaCounter(LP.Character) end
    if cfg.batCounter    then State.batCounterEnabled=true;  if setBatCounter then setBatCounter(true) end;startBatCounter() end
    if cfg.autoStealEnabled then AutoSteal.Enabled=true;     if setInstaGrab  then setInstaGrab(true) end;pcall(startAutoSteal) end
    if cfg.animEnabled   then State.animEnabled=true;        if setAnimToggle then setAnimToggle(true) end;startAnimToggle() end
    if cfg.mobileLocked~=nil  then MobileButtons.Locked=cfg.mobileLocked;   if setLockToggle then setLockToggle(cfg.mobileLocked) end end
    if cfg.mobileVisible~=nil then MobileButtons.Visible=cfg.mobileVisible; if setVisToggle  then setVisToggle(cfg.mobileVisible) end;for _,c in ipairs(MobileButtons.Containers) do c.Visible=cfg.mobileVisible end end
    -- Extra fields
    if cfg.duelLaggerActive then toggleDuelLagger(true); if setDuelLagUI then setDuelLagUI(true) end end
    if cfg.bypassActive     then toggleBypass(true);     if setBypassTogUI     then setBypassTogUI(true)     end end
    if cfg.bypassSpeedBoost then State.bypassSpeedBoost=cfg.bypassSpeedBoost end
    if cfg.bypassLagAmount  then State.bypassLagAmount=cfg.bypassLagAmount end
    local function loadKey(cf,sk) if cfg[cf] and type(cfg[cf])=="string" then local ok2,kc=pcall(function() return Enum.KeyCode[cfg[cf]] end);if ok2 and kc then State[sk]=kc end end end
    loadKey("keyAutoLeft","keyAutoLeft");loadKey("keyAutoRight","keyAutoRight");loadKey("keyDropBR","keyDropBR");loadKey("keyTpDown","keyTpDown");loadKey("keyAutoBat","keyAutoBat");loadKey("keyGuiHide","keyGuiHide")
    task.spawn(function()
        task.wait(0.6)
        if MobileButtons.Buttons.autoBat      then MobileButtons.Buttons.autoBat(State.aimbotActive) end
        if MobileButtons.Buttons.carrySpeed   then MobileButtons.Buttons.carrySpeed(State.speedType=="carry") end
        if MobileButtons.Buttons.lagger       then MobileButtons.Buttons.lagger(State.laggerActive) end
        if MobileButtons.Buttons.laggerCarry  then MobileButtons.Buttons.laggerCarry(State.laggerCarryActive) end
        if MobileButtons.Buttons.autoLeft     then MobileButtons.Buttons.autoLeft(State.autoLeftEnabled) end
        if MobileButtons.Buttons.autoRight    then MobileButtons.Buttons.autoRight(State.autoRightEnabled) end
        if MobileButtons.Buttons.duelLag      then MobileButtons.Buttons.duelLag(State.duelLaggerActive) end
        if MobileButtons.Buttons.bypass       then MobileButtons.Buttons.bypass(State.bypassActive) end
        if State.laggerActive or State.laggerCarryActive then startAutoSteal() end
        if State.autoLeftEnabled  then startAutoLeft() end
        if State.autoRightEnabled then startAutoRight() end
    end)
    refreshUIToggles()
end
local function setupChar(char)
    task.wait(0.1);originalAnims=nil
    h=char:WaitForChild("Humanoid",5);hrp=char:WaitForChild("HumanoidRootPart",5)
    if not h or not hrp then return end
    local head=char:FindFirstChild("Head")
    if head then
        local old=head:FindFirstChild("SpeedBillboard");if old then old:Destroy() end
        local bb=Instance.new("BillboardGui",head);bb.Name="SpeedBillboard";bb.Size=UDim2.new(0,140,0,48);bb.StudsOffset=Vector3.new(0,3,0);bb.AlwaysOnTop=true
        -- speed label (bottom half)
        speedLbl=Instance.new("TextLabel",bb);speedLbl.Size=UDim2.new(1,0,0.5,0);speedLbl.Position=UDim2.new(0,0,0.5,0);speedLbl.BackgroundTransparency=1;speedLbl.TextColor3=C.accentLight;speedLbl.Font=Enum.Font.GothamBold;speedLbl.TextScaled=true;speedLbl.TextStrokeTransparency=0
        -- ragdoll timer label (top half, above speed)
        local ragLbl=Instance.new("TextLabel",bb);ragLbl.Name="RagTimerLbl";ragLbl.Size=UDim2.new(1,0,0.5,0);ragLbl.Position=UDim2.new(0,0,0,0);ragLbl.BackgroundTransparency=1;ragLbl.Text="";ragLbl.TextColor3=Color3.fromRGB(200,80,255);ragLbl.Font=Enum.Font.GothamBlack;ragLbl.TextScaled=true;ragLbl.TextStrokeTransparency=0;ragLbl.TextStrokeColor3=Color3.new(0,0,0)
    end
    -- Recreate speed billboard
    if State.antiRagdollEnabled then stopAntiRagdoll();task.wait(0.5);startAntiRagdoll() end
    if State.medusaCounterEnabled then setupMedusaCounter(char) end
    if State.batCounterEnabled then task.wait(0.3);startBatCounter() end
    if State.animEnabled then task.wait(0.3);saveOriginalAnims(char);applyAnimPack(char) end
    if State.unwalkEnabled then State.unwalkEnabled=false;task.wait(0.3);startUnwalk() end
    if State.aimbotActive then stopAimbot();State.aimbotActive=true;startAimbot() end
end
LP.CharacterAdded:Connect(setupChar)
if LP.Character then task.spawn(function() setupChar(LP.Character) end) end
RunService.Stepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then for _,part in ipairs(p.Character:GetChildren()) do if part:IsA("BasePart") then part.CanCollide=false end end end
    end
end)
RunService.Heartbeat:Connect(function()
    if not State.infJumpEnabled and not State.autoTpDownEnabled then return end
    local char=LP.Character;if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart");if not root then return end
    if State.infJumpEnabled then
        local hum2=char:FindFirstChildOfClass("Humanoid")
        if State.infJumpMode=="hold" then local jumpHeld=UIS:IsKeyDown(Enum.KeyCode.Space) or (hum2 and hum2.Jump==true);if jumpHeld and root.Velocity.Y<30 then root.Velocity=Vector3.new(root.Velocity.X,55,root.Velocity.Z) end end
        if root.Velocity.Y<-120 then root.Velocity=Vector3.new(root.Velocity.X,-120,root.Velocity.Z) end
    end
    if State.autoTpDownEnabled and root.Position.Y>=State.autoTpDownY then local rot=root.CFrame.Rotation;root.CFrame=CFrame.new(root.Position.X,-8.80,root.Position.Z)*rot end
end)
UIS.JumpRequest:Connect(function()
    if not State.infJumpEnabled or State.infJumpMode~="manual" then return end
    local char=LP.Character;if not char then return end;local root=char:FindFirstChild("HumanoidRootPart");if root then root.Velocity=Vector3.new(root.Velocity.X,55,root.Velocity.Z) end
end)
RunService.RenderStepped:Connect(function()
    if not(h and hrp) then return end
    if State.autoLeftEnabled or State.autoRightEnabled then if speedLbl then speedLbl.Text="Speed: "..string.format("%.1f",Vector3.new(hrp.Velocity.X,0,hrp.Velocity.Z).Magnitude) end;return end
    local md=h.MoveDirection;local spd=getCurrentSpeed();local velY=hrp.Velocity.Y
    if md.Magnitude>0 then State.lastMoveDir=md;hrp.Velocity=Vector3.new(md.X*spd,velY,md.Z*spd)
    elseif State.antiRagdollEnabled and State.lastMoveDir.Magnitude>0 then
        local anyHeld=false;for k in pairs(MOVE_KEYS) do if UIS:IsKeyDown(k) then anyHeld=true;break end end
        if anyHeld then hrp.Velocity=Vector3.new(State.lastMoveDir.X*spd,velY,State.lastMoveDir.Z*spd) end
    end
    if speedLbl then speedLbl.Text="Speed: "..string.format("%.1f",Vector3.new(hrp.Velocity.X,0,hrp.Velocity.Z).Magnitude) end
end)
task.spawn(function() while task.wait(0.5) do pcall(function() if progressRadLbl then progressRadLbl.Text="Radius: "..AutoSteal.Radius end end) end end)
task.spawn(function() while task.wait(0.3) do pcall(function()
    if State.laggerCarryActive then modeValLbl.Text="LAGGER+"
    elseif State.laggerActive  then modeValLbl.Text="LAGGER"
    elseif State.speedType=="carry" then modeValLbl.Text="CARRY"
    else modeValLbl.Text="NORMAL" end
end) end end)
local function handleKeybind(kc)
    if State.keyAutoLeft~=Enum.KeyCode.Unknown and kc==State.keyAutoLeft then
        State.autoLeftEnabled=not State.autoLeftEnabled;if setAutoLeft then setAutoLeft(State.autoLeftEnabled) end;if MobileButtons.Buttons.autoLeft then MobileButtons.Buttons.autoLeft(State.autoLeftEnabled) end;if State.autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
    end
    if State.keyAutoRight~=Enum.KeyCode.Unknown and kc==State.keyAutoRight then
        State.autoRightEnabled=not State.autoRightEnabled;if setAutoRight then setAutoRight(State.autoRightEnabled) end;if MobileButtons.Buttons.autoRight then MobileButtons.Buttons.autoRight(State.autoRightEnabled) end;if State.autoRightEnabled then startAutoRight() else stopAutoRight() end
    end
    if State.keyDropBR~=Enum.KeyCode.Unknown and kc==State.keyDropBR then runDropBrainrot();if setMenuDropBR then setMenuDropBR(true) end;if MobileButtons.Buttons.dropBR then MobileButtons.Buttons.dropBR(true) end;task.delay(0.5,function() if setMenuDropBR then setMenuDropBR(false) end;if MobileButtons.Buttons.dropBR then MobileButtons.Buttons.dropBR(false) end end) end
    if State.keyTpDown~=Enum.KeyCode.Unknown and kc==State.keyTpDown then tpToGround();if setMenuTpDown then setMenuTpDown(true) end;if MobileButtons.Buttons.tpDown then MobileButtons.Buttons.tpDown(true) end;task.delay(0.5,function() if setMenuTpDown then setMenuTpDown(false) end;if MobileButtons.Buttons.tpDown then MobileButtons.Buttons.tpDown(false) end end) end
    if State.keyAutoBat~=Enum.KeyCode.Unknown and kc==State.keyAutoBat then
        State.aimbotActive=not State.aimbotActive
        if State.aimbotActive then
            if State.autoLeftEnabled then State.autoLeftEnabled=false;stopAutoLeft();if setAutoLeft then setAutoLeft(false) end;if MobileButtons.Buttons.autoLeft then MobileButtons.Buttons.autoLeft(false) end end
            if State.autoRightEnabled then State.autoRightEnabled=false;stopAutoRight();if setAutoRight then setAutoRight(false) end;if MobileButtons.Buttons.autoRight then MobileButtons.Buttons.autoRight(false) end end
            startAimbot()
        else
            stopAimbot()
        end
        if setAutoBat then setAutoBat(State.aimbotActive) end
        if MobileButtons.Buttons.autoBat then MobileButtons.Buttons.autoBat(State.aimbotActive) end
    end
    if State.keyGuiHide~=Enum.KeyCode.Unknown and kc==State.keyGuiHide then
        guiOpen=not guiOpen; main.Visible=guiOpen
        starBtn.TextColor3=guiOpen and C.accent or C.tabInactive
    end
end
UIS.InputBegan:Connect(function(inp,gp)
    if gp then return end
    if inp.UserInputType==Enum.UserInputType.Keyboard or inp.UserInputType==Enum.UserInputType.Gamepad1 then handleKeybind(inp.KeyCode) end
end)
local function createLaggerPanel()
    if laggerPanelGui then laggerPanelGui:Destroy(); laggerPanelGui=nil end
    local sg=Instance.new("ScreenGui"); sg.Name="AnguishLaggerPanel"; sg.ResetOnSpawn=false; sg.DisplayOrder=20; sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; sg.Parent=LP:WaitForChild("PlayerGui")
    laggerPanelGui=sg
    local PANEL_W=160; local PANEL_H=140
    local frame=Instance.new("Frame",sg); frame.Name="LaggerPanel"; frame.Size=UDim2.new(0,PANEL_W,0,PANEL_H); frame.Position=UDim2.new(0.5,-PANEL_W/2,0.65,0); frame.BackgroundColor3=C.panel; frame.BorderSizePixel=0; frame.Active=true
    Instance.new("UICorner",frame).CornerRadius=UDim.new(0,14); local fStroke=Instance.new("UIStroke",frame); fStroke.Color=C.border; fStroke.Thickness=1.5
    local titleBar=Instance.new("TextLabel",frame); titleBar.Size=UDim2.new(1,0,0,30); titleBar.BackgroundColor3=C.card; titleBar.BorderSizePixel=0; titleBar.Text="LAGGER"; titleBar.TextColor3=C.accent; titleBar.Font=Enum.Font.GothamBlack; titleBar.TextSize=12; titleBar.ZIndex=2
    Instance.new("UICorner",titleBar).CornerRadius=UDim.new(0,14)
    local tfix=Instance.new("Frame",frame); tfix.Size=UDim2.new(1,0,0,14); tfix.Position=UDim2.new(0,0,0,16); tfix.BackgroundColor3=C.card; tfix.BorderSizePixel=0; tfix.ZIndex=2
    local dragging,dragStart,startPos=false,nil,nil
    titleBar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true;dragStart=i.Position;startPos=frame.Position;i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end) end end)
    UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local dx=i.Position.X-dragStart.X;local dy=i.Position.Y-dragStart.Y;frame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+dx,startPos.Y.Scale,startPos.Y.Offset+dy) end end)
    pcall(function() local sv=readfile("AnguishLaggerPanel_pos.txt");if sv and sv~="" then local pts={};for pt in sv:gmatch("[^,]+") do table.insert(pts,pt) end;if #pts>=4 then frame.Position=UDim2.new(tonumber(pts[1]),tonumber(pts[2]),tonumber(pts[3]),tonumber(pts[4])) end end end)
    local lastST=0; frame:GetPropertyChangedSignal("Position"):Connect(function() if tick()-lastST>0.5 then lastST=tick();local p=frame.Position;pcall(function() writefile("AnguishLaggerPanel_pos.txt",string.format("%.3f,%.1f,%.3f,%.1f",p.X.Scale,p.X.Offset,p.Y.Scale,p.Y.Offset)) end) end end)
    local BTN_W2=64; local BTN_H2=46; local GAP2=10; local totalW=BTN_W2*2+GAP2; local startX=(PANEL_W-totalW)/2
    local function makePanelBtn(name,text,xOff,cb)
        local cont=Instance.new("Frame",frame); cont.Name=name; cont.Size=UDim2.new(0,BTN_W2,0,BTN_H2); cont.Position=UDim2.new(0,xOff,0,42); cont.BackgroundColor3=C.card; cont.BorderSizePixel=0; cont.ZIndex=3
        Instance.new("UICorner",cont).CornerRadius=UDim.new(0,10); Instance.new("UIStroke",cont).Color=C.borderDim
        local lbl=Instance.new("TextButton",cont); lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1; lbl.Font=Enum.Font.GothamBlack; lbl.Text=text; lbl.TextColor3=C.text; lbl.TextSize=9; lbl.TextWrapped=true; lbl.AutoButtonColor=false; lbl.ZIndex=4
        local function setActive(s) TweenService:Create(cont,TweenInfo.new(0.15),{BackgroundColor3=s and C.onBg or C.card}):Play(); lbl.TextColor3=s and C.white or C.text end
        lbl.MouseButton1Click:Connect(function() cb(setActive) end); return setActive
    end
    local duelSA  =makePanelBtn("BtnDuelLag","DUEL\nLAG",startX,function(sa) State.duelLaggerActive=not State.duelLaggerActive;toggleDuelLagger(State.duelLaggerActive);if setDuelLagUI then setDuelLagUI(State.duelLaggerActive) end;sa(State.duelLaggerActive) end)
    local bypassSA=makePanelBtn("BtnBypass","BY\nPASS",startX+BTN_W2+GAP2,function(sa) State.bypassActive=not State.bypassActive;toggleBypass(State.bypassActive);if setBypassTogUI then setBypassTogUI(State.bypassActive) end;sa(State.bypassActive) end)
    local statusLbl=Instance.new("TextLabel",frame); statusLbl.Size=UDim2.new(1,-16,0,20); statusLbl.Position=UDim2.new(0,8,0,96); statusLbl.BackgroundTransparency=1; statusLbl.Font=Enum.Font.Gotham; statusLbl.TextSize=9; statusLbl.TextColor3=C.textMuted; statusLbl.Text="Tap to toggle"; statusLbl.TextWrapped=true; statusLbl.ZIndex=3
    task.spawn(function() task.wait(0.1); duelSA(State.duelLaggerActive); bypassSA(State.bypassActive) end)
    sg.Enabled=State.laggerPanelVisible
end
do
    local ragTimerActive = false
    local function getRagLbl()
        local char = LP.Character; if not char then return nil end
        local head = char:FindFirstChild("Head"); if not head then return nil end
        local bb = head:FindFirstChild("SpeedBillboard"); if not bb then return nil end
        return bb:FindFirstChild("RagTimerLbl")
    end
    local function startRagTimer()
        if ragTimerActive then return end
        ragTimerActive = true
        local lbl = getRagLbl(); if not lbl then ragTimerActive = false; return end
        lbl.TextColor3 = Color3.fromRGB(200, 80, 255)
        lbl.Text = "3.0"
        local timeLeft = 3.0
        local conn
        conn = RunService.Heartbeat:Connect(function(dt)
            local l = getRagLbl()
            if not l then conn:Disconnect(); ragTimerActive = false; return end
            timeLeft = timeLeft - dt
            if timeLeft <= 0 then
                conn:Disconnect()
                ragTimerActive = false
                l.TextColor3 = Color3.fromRGB(80, 220, 80)
                l.Text = "READY"
                task.delay(1.2, function()
                    local l2 = getRagLbl(); if l2 then l2.Text = "" end
                end)
            else
                l.Text = string.format("%.1f", timeLeft)
            end
        end)
    end
    local function hookCharacter(char)
        local hum = char:WaitForChild("Humanoid", 5); if not hum then return end
        hum.StateChanged:Connect(function(_, new)
            if new == Enum.HumanoidStateType.Physics
            or new == Enum.HumanoidStateType.Ragdoll
            or new == Enum.HumanoidStateType.FallingDown then
                startRagTimer()
            end
        end)
    end
    if LP.Character then hookCharacter(LP.Character) end
    LP.CharacterAdded:Connect(function(char)
        ragTimerActive = false
        hookCharacter(char)
    end)
end
switchTab("SPEED")
task.spawn(function() task.wait(0.5);createMobilePanel();createLaggerPanel() end)
loadPresetsFile();rebuildPresetList();loadConfig()
task.spawn(function()
    task.wait(0.6)
    local last=loadLastPresetName()
    if last and last~="" then for _,p in ipairs(Presets) do if p.name==last then applyPreset(p.data);print("[Anguish] Auto-loaded preset: "..last);break end end end
end)
task.delay(1,function() pcall(saveConfig) end)
print("[ANGUISH] Loaded | LCtrl to hide")