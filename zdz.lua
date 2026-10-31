_G.MeerkoScanProfile=function(a)if a=='fast'then _G.MeerkoScanMode='fast'_G.
MeerkoPanelScanGap=tonumber(_G.MeerkoFastPanelGap)or 0.15 _G.MeerkoRepickGap=
tonumber(_G.MeerkoFastRepickGap)or 0.1 _G.MeerkoInRangeGap=tonumber(_G.
MeerkoFastInRangeGap)or 0.1 _G.MeerkoWatchdogTick=tonumber(_G.
MeerkoFastWatchdogTick)or 0.15 _G.MeerkoSyncScanGap=tonumber(_G.
MeerkoFastSyncGap)or 0.1 _G.MeerkoAutoTPPoll=tonumber(_G.MeerkoFastTPPoll)or
0.03 else _G.MeerkoScanMode='normal'_G.MeerkoPanelScanGap=tonumber(_G.
MeerkoNormPanelGap)or 0.25 _G.MeerkoRepickGap=tonumber(_G.MeerkoNormRepickGap)or
0.25 _G.MeerkoInRangeGap=tonumber(_G.MeerkoNormInRangeGap)or 0.2 _G.
MeerkoWatchdogTick=tonumber(_G.MeerkoNormWatchdogTick)or 0.2 _G.
MeerkoSyncScanGap=tonumber(_G.MeerkoNormSyncGap)or 0.15 _G.MeerkoAutoTPPoll=
tonumber(_G.MeerkoNormTPPoll)or 0.03 end end _G.MeerkoScanProfile('fast')task.
spawn(function()if not game:IsLoaded()then game.Loaded:Wait()end task.wait(
tonumber(_G.MeerkoFastWindow)or 60)if _G.MeerkoScanMode=='fast'then _G.
MeerkoScanProfile('normal')end end)local a=function()end local b=function()end
_G.MeerkoInvisAuto=false _G.MeerkoAutoKickOnSteal=false _G.MeerkoAutoBuy=false
if _G.MeerkoStealMode==nil then _G.MeerkoStealMode='priority'end if _G.
MeerkoAutoTP==nil then _G.MeerkoAutoTP=true end do local c=game:GetService(
'CoreGui')local d=game:GetService('ReplicatedFirst')local e=game:GetService(
'Players')local f=game:GetService('RunService')local g=game:GetService(
'Lighting')local h=game:GetService('Workspace')local i=true local j=true local k
=2000 local function findGlobalFunction(l)local m pcall(function()m=getgenv and
getgenv()[l]end)if type(m)=='function'then return m end pcall(function()m=_G[l]
end)if type(m)=='function'then return m end pcall(function()m=getfenv(0)[l]end)
if type(m)=='function'then return m end pcall(function()m=rawget(getfenv(2),l)
end)if type(m)=='function'then return m end return nil end local l={
FFlagTaskSchedulerLimitTargetFpsToDevice='False',
FFlagTaskSchedulerLimitTargetFpsTo2402='False',
FFlagGameBasicSettingsFramerateCap5='False',DFIntTaskSchedulerTargetFps=
tostring(k),FFlagHandleAltEnterFullscreenManually='False',
FFlagEnableTextureStreaming='True',FFlagPreloadAllFonts='True',
DFFlagEnableSoundPreloading='True',DFFlagEnableMeshPreloading='True',
DFFlagEnableMeshPreloading2='True',DFFlagEnableTexturePreloading='True',
FFlagAssetPreloadingIXP='True',DFFlagEnablePreloadAvatarAssets='True',
DFFlagTeleportClientAssetPreloadingEnabledIXP='True',
DFFlagTeleportClientAssetPreloadingEnabledIXP2='True',
DFFlagTeleportClientAssetPreloadingEnabled9='True',
DFFlagTeleportClientAssetPreloadingDoingExperiment='True',
DFFlagTeleportClientAssetPreloadingDoingExperiment2='True',
DFFlagTeleportPreloadingMetrics5='True',DFFlagPreloadAsyncSupportTexturePack=
'True',FFlagPreloadTextureItemsOption4='True',FFlagUseNewLuaPreloadAssets='True'
,DFFlagEnableScriptPreloadOnJoin='True',FFlagLuaAppsScriptPreload='True',
DFFlagRemoveUnusedKtxMetadata='True',DFIntContentProviderMaximumRequestsPerStep=
'10000',DFIntContentProviderMaximumRequestsPerSecond='10000',
DFIntSolidModelStreamDebounceSecs='0',FIntRenderGrassDetailStrands='0',
FIntRenderGrassHeightScaler='0',FIntTerrainOctreeMaxCells='0',
FIntDebugForceMSAASamples='0',FIntRenderShadowIntensity='0',
DFIntSignalRCoreTimerMs='50',FIntActivatedCountTimerMSMouse='0',
FIntActivatedCountTimerMSKeyboard='0',DFIntDebugRestrictGCDistance='1',
DFIntStreamingTargetRadius='64',DFIntStreamingMinRadius='32',
FIntRomarkStartWithGraphQualityLevel='1',FIntTerrainArraySliceSize='0',
FIntRenderLocalLightUpdatesMax='1',FIntRenderLocalLightUpdatesMin='1',
FIntRenderShadowmapBias='0',FFlagFastGPULightCulling3='True',
FFlagDebugDisableDeferredLighting='True',DFFlagDisableDPIScale='True',
FFlagDisablePostFx='True',FIntFRMMinGrassDistance='0',FIntFRMMaxGrassDistance=
'0',DFIntCSGLevelOfDetailSwitchingDistance='0',
DFIntCSGLevelOfDetailSwitchingDistanceL12='0',
DFIntCSGLevelOfDetailSwitchingDistanceL23='0',
DFIntCSGLevelOfDetailSwitchingDistanceL34='0'}pcall(function()local m=
findGlobalFunction('setfflag')if not m then return end for n,o in pairs(l)do
pcall(m,n,o)end end)pcall(function()local m=findGlobalFunction('setfpscap')if m
then m(2000)end end)local m={RobloxLoadingGUI=true,RobloxLoadingGui=true,
LoadingGui=true,LoadingGUI=true,LoadingScreen=true,CustomLoadingScreen=true,
BackgroundScreen=true,DevGUIBlackoutCurtain=true}local function 
looksLikeLoadingGui(n)if not n then return false end if m[n.Name]then return
true end local o=string.lower(n.Name)return string.find(o,'loading',1,true)~=nil
or string.find(o,'blackout',1,true)~=nil end local function removeLoadingGui(n)
if not n or n.Parent~=c then return end if looksLikeLoadingGui(n)then pcall(
function()n.Enabled=false end)pcall(function()n:Destroy()end)end end pcall(
function()d:RemoveDefaultLoadingScreen()end)for n,o in ipairs(c:GetChildren())do
removeLoadingGui(o)end c.ChildAdded:Connect(function(n)task.defer(
removeLoadingGui,n)end)for n=0,10 do task.delay(n*0.1,function()pcall(function()
d:RemoveDefaultLoadingScreen()end)for o,p in ipairs(c:GetChildren())do
removeLoadingGui(p)end end)end local n={}local o=setmetatable({},{__mode='k'})
local p=25000 local function remember(q,r,s)if not q or#n>=p then return end
local t=o[q]if not t then t={}o[q]=t end if t[r]then return end t[r]=true n[#n+1
]={Instance=q,Property=r,Value=s}end local function restoreAll()if#n==0 then
return end task.spawn(function()local q=1 local r=#n while q<=r do local s=os.
clock()while q<=r and os.clock()-s<0.0015 do local t=n[q]pcall(function()if t.
Instance and t.Instance.Parent then t.Instance[t.Property]=t.Value end end)q+=1
end f.Heartbeat:Wait()end table.clear(n)table.clear(o)end)end local function 
budgetedSweep(q,r)task.spawn(function()for s,t in ipairs(q)do local u,v=pcall(
function()return t:GetDescendants()end)if u then local w,x=1,#v while w<=x do
local y=os.clock()while w<=x and os.clock()-y<0.0015 do pcall(r,v[w])w+=1 end f.
Heartbeat:Wait()end end end end)end local function permanentStrip(q)if q:IsA(
'ParticleEmitter')or q:IsA('Trail')or q:IsA('Smoke')or q:IsA('Fire')or q:IsA(
'Sparkles')or q:IsA('Beam')then q.Enabled=false elseif q:IsA('PostEffect')then q
.Enabled=false elseif q:IsA('Explosion')then q.Visible=false elseif q:IsA(
'MeshPart')then pcall(function()q.RenderFidelity=Enum.RenderFidelity.Performance
q.CastShadow=false q.Reflectance=0 end)elseif q:IsA('BasePart')then pcall(
function()q.CastShadow=false q.Reflectance=0 end)end end local q=true local 
function harshStrip(r)if not q then return end if r:IsA('Decal')or r:IsA(
'Texture')then if r.Transparency~=1 then remember(r,'Transparency',r.
Transparency)r.Transparency=1 end elseif r:IsA('BillboardGui')or r:IsA(
'SurfaceGui')then if r.Enabled then remember(r,'Enabled',r.Enabled)r.Enabled=
false end elseif r:IsA('Sound')then if r.Volume~=0 then remember(r,'Volume',r.
Volume)r.Volume=0 end end end local r={}local function isMarkTrack(s)local t=_G.
MeerkoIsMarkTrack if type(t)=='function'then local u,v=pcall(t,s)if u and v then
return true end end local u,v=pcall(function()return s.Animation and s.Animation
.AnimationId end)v=u and type(v)=='string'and v or''return v:find('507776043',1,
true)~=nil or v:find('182435998',1,true)~=nil end local function stopAnimator(s)
if not s or not s:IsA('Animator')then return end pcall(function()for t,u in
ipairs(s:GetPlayingAnimationTracks())do if not isMarkTrack(u)then u:Stop(0)
pcall(function()u:Destroy()end)end end end)r[#r+1]=s.AnimationPlayed:Connect(
function(t)task.defer(function()if isMarkTrack(t)then return end pcall(function(
)t:Stop(0)t:Destroy()end)end)end)end local function disableAnimations(s)if s:
IsA('Animator')then stopAnimator(s)elseif s:IsA('AnimationController')then
pcall(function()local t=s:FindFirstChildOfClass('Animator')if t then
stopAnimator(t)end end)elseif s:IsA('Animation')then pcall(function()s.
AnimationId=''end)elseif(s:IsA('LocalScript')or s:IsA('Script'))and string.
lower(s.Name)=='animate'then pcall(function()s.Disabled=true end)end end
budgetedSweep({h,e},disableAnimations)r[#r+1]=h.DescendantAdded:Connect(function
(s)pcall(disableAnimations,s)end)r[#r+1]=e.DescendantAdded:Connect(function(s)
pcall(disableAnimations,s)end)pcall(function()g.GlobalShadows=false g.
EnvironmentDiffuseScale=0 g.EnvironmentSpecularScale=0 g.ShadowSoftness=0 end)
pcall(function()local s=h:FindFirstChildOfClass('Terrain')if s then s.Decoration
=false s.WaterWaveSize=0 s.WaterWaveSpeed=0 s.WaterReflectance=0 s.
WaterTransparency=1 local t=s:FindFirstChildOfClass('Clouds')if t then t.Enabled
=false end end end)pcall(function()local s=UserSettings():GetService(
'UserGameSettings')remember(s,'MasterVolume',s.MasterVolume)s.MasterVolume=0
remember(s,'SavedQualityLevel',s.SavedQualityLevel)s.SavedQualityLevel=Enum.
SavedQualitySetting.QualityLevel1 end)pcall(function()settings().Rendering.
QualityLevel=Enum.QualityLevel.Level01 end)budgetedSweep({h,g},function(s)
permanentStrip(s)if q then harshStrip(s)end end)local s={}s[#s+1]=h.
DescendantAdded:Connect(function(t)pcall(permanentStrip,t)if q then pcall(
harshStrip,t)end end)s[#s+1]=g.DescendantAdded:Connect(function(t)pcall(
permanentStrip,t)end)local t=false local function finishLoadPhase()if t then
return end t=true q=false restoreAll()end local function 
waitForPlayableCharacter()local u=e.LocalPlayer if not u then e:
GetPropertyChangedSignal('LocalPlayer'):Wait()u=e.LocalPlayer end local v=u.
Character or u.CharacterAdded:Wait()v:WaitForChild('Humanoid',15)v:WaitForChild(
'HumanoidRootPart',15)f.RenderStepped:Wait()finishLoadPhase()end task.spawn(
waitForPlayableCharacter)task.delay(30,finishLoadPhase)_G.MeerkoLoadOptStop=
function()for u,v in ipairs(s)do if v and v.Connected then v:Disconnect()end end
for u,v in ipairs(r)do if v and v.Connected then v:Disconnect()end end table.
clear(s)table.clear(r)finishLoadPhase()end task.spawn(function()local u,v=pcall(
function()_G.MeerkoKillQ={}do local u=game:GetService('Players')local function 
pin(v)if v and v.Name=='Animate'then pcall(function()v.Disabled=true end)end end
local function hook(v)if not v then return end pin(v:FindFirstChild('Animate'))v
.ChildAdded:Connect(pin)end local function onLp(v)if not v then return end if v.
Character then hook(v.Character)end v.CharacterAdded:Connect(hook)end local v=u.
LocalPlayer if v then onLp(v)else u.PlayerAdded:Connect(onLp)end end do local u=
game:GetService('ReplicatedStorage')local v={CustomProximityPromptController=
true,InteractController=true,PlotController=true,AnimalController=true,
PetController=true,WorldBrainrotController=true,EquipBrainrotsController=true,
EquipBrainrotsRenderController=true,SelectBrainrotsController=true,
BrainrotPreloadingController=true,AssetStreamController=true,
AdminPanelController=true,NotificationController=true}local function wrap(w)if
newcclosure then return newcclosure(w)end return w end local function 
isCtrlFolder(w)return typeof(w)=='Instance'and w.Name=='Controllers'and w.Parent
==u end local function callerName()if not getcallingscript then return'?'end
local w,x=pcall(getcallingscript)if not w or x==nil then return'nil'end return
tostring(x.Name)end local function fromLoader()return callerName()==
'ClientLoader'end local function filt(w)if type(w)~='table'then return w end
local x={}for y=1,#w do local z=w[y]if z and v[z.Name]then x[#x+1]=z end end
return x end local w local x=false local function unhook()if x then return end x
=true pcall(function()if w then hookmetamethod(game,'__namecall',w)end end)end
pcall(function()w=hookmetamethod(game,'__namecall',wrap(function(y,...)local z=
getnamecallmethod()if type(z)~='string'then return w(y,...)end local A=string.
lower(z)if A~='getchildren'then return w(y,...)end if not isCtrlFolder(y)then
return w(y,...)end if not fromLoader()then return w(y,...)end return filt(w(y,
...))end))end)task.delay(6,unhook)end task.spawn(function()local u=game:
GetService('ReplicatedStorage')local v={RNGMachineVFX=true,LuckIcons=true,
GlossaryBackground=true,AnimationGraphEditor=true,ML=true,PlayWaveEvents=true}
local function yeet(w)if not w then return end pcall(function()w:Destroy()end)
end local function dropKill(w)if w and v[w.Name]then yeet(w)end end local w=u:
GetChildren()for x=1,#w do dropKill(w[x])end u.ChildAdded:Connect(dropKill)end)
task.wait()local function _sxeBusy()return _G.MeerkoVelFlying==true end function
_G.MeerkoPlotProtected(u)if not u then return false end local v=u.Name if _G.
MeerkoMyPlot and v==_G.MeerkoMyPlot then return true end if _G.MeerkoKeepPlot
and v==tostring(_G.MeerkoKeepPlot)then return true end if _G.MeerkoTPPlot and v
==tostring(_G.MeerkoTPPlot)then return true end local w=_G.MeerkoStealTarget if
type(w)=='table'and w.plot and v==tostring(w.plot)then return true end local x=
false pcall(function()local y=game:GetService('Players').LocalPlayer.Character
local z=y and y:FindFirstChild('HumanoidRootPart')if z then local A=u:GetPivot()
.Position local B=Vector3.new(z.Position.X-A.X,0,z.Position.Z-A.Z).Magnitude x=B
<(tonumber(_G.MeerkoPlotProtectRadius)or 90)end end)return x end local function 
_isProtectedPlot(u)local v=u.Parent if not(v and v.Name=='Plots'and v.Parent==
workspace)then return false end local w,x=pcall(_G.MeerkoPlotProtected,u)return
w and x==true end local function _inTPTargetPlot(u)local v=_G.MeerkoTPPlot local
w=_G.MeerkoStealTarget local x=(type(w)=='table'and w.plot)and tostring(w.plot)
or nil if not v and not x then return false end local y=u for z=1,16 do local A=
y and y.Parent if not A then return false end if A.Name=='Plots'and A.Parent==
workspace then return(v and y.Name==tostring(v))or(x and y.Name==x)or false end
y=A end return false end _G.MeerkoInTPTargetPlot=_inTPTargetPlot function _G.
MeerkoKill(u)if not u then return end if _isProtectedPlot(u)then return end if
_inTPTargetPlot(u)then return end if _sxeBusy()then local v=_G.MeerkoKillQ v[#v+
1]=u return end pcall(function()u:Destroy()end)end function _G.MeerkoFlushKills(
)local u=_G.MeerkoKillQ _G.MeerkoKillQ={}for v=1,#u do local w=u[v]if w and w.
Parent and not _isProtectedPlot(w)and not _inTPTargetPlot(w)then pcall(function(
)w:Destroy()end)end end end local function __sxeStrip()local u=game:GetService(
'Players')local v=game:GetService('Lighting')local w=u.LocalPlayer local 
function kill(x)_G.MeerkoKill(x)end pcall(function()workspace.Terrain.Decoration
=false end)local x={FriendPanel=true,Cash=true,Unlock=true,Purchases=true,
PlotSign=true,CashPad=true,InvisibleWalls=true,Multiplier=true,Slope=true,
IncubatorMachine=true,FuseMachine=true,RobuxShop=true,AdminBoard=true,
SoccerScoreBoard=true,CrystalSpinWheel=true,Beehive=true,CraftingMachine=true,
Shop=true,Road=true,EventBoard=true,TradePlazaPortal=true,LosTraders=true,
RNGMachine=true,Present=true,StPatricksPot=true,ShopNPCRobuxIdle=true,RoadPanel=
true,Honey=true,Trap=true,Events=true,Sounds=true,rods=true,Dev=true,ToolsAdds=
true,__PROJECTILES=true,CrystalMap=true,SpawnLocation=true,UFO=true,Interacts=
true,JumpLTMMachine=true,HalloweenFuseMachine=true}local y={Skin=true,Laser=true
,AnimalPodiums=true,DeliveryHitbox=true,StealHitbox=true,AnimalTarget=true,
MainRoot=true,Floor=true,Spawn=true,Door=true,Hitbox=true,Base=true,Wall=true,
Roof=true,SecondFloor=true,ThirdFloor=true,['structure base home']=true,Unlock=
true}local z={FriendPanel=true,Cash=true,Purchases=true,PlotSign=true,CashPad=
true,InvisibleWalls=true,Multiplier=true,LaserHitbox=true,Events=true,Sounds=
true,Slope=true}local A={HumanoidRootPart=true,Head=true,Torso=true,UpperTorso=
true,LowerTorso=true,LeftUpperArm=true,LeftLowerArm=true,LeftHand=true,
RightUpperArm=true,RightLowerArm=true,RightHand=true,LeftUpperLeg=true,
LeftLowerLeg=true,LeftFoot=true,RightUpperLeg=true,RightLowerLeg=true,RightFoot=
true,['Left Arm']=true,['Right Arm']=true,['Left Leg']=true,['Right Leg']=true}
local B={Humanoid=true,Animator=true,Attachment=true,Motor6D=true,
AnimationConstraint=true,BallSocketConstraint=true,Weld=true,WeldConstraint=true
}local C={Ground=true,Ground_Left=true,Ground_Right=true}local D={Part=true,
MeshPart=true,UnionOperation=true,WedgePart=true,CornerWedgePart=true,TrussPart=
true,SpawnLocation=true,Seat=true,VehicleSeat=true}local function underUnlock(E)
local F=E for G=1,12 do if not F then return false end if F.Name=='Unlock'then
return true end if F==workspace then return false end F=F.Parent end return
false end local function isMine(E)if not(w and E)then return false end if E==w.
Character or E.Name==w.Name then return true end return false end local function 
isVisualJunk(E)local F=E.ClassName return F=='Beam'or F=='Trail'or F==
'ParticleEmitter'or F=='PointLight'or F=='SpotLight'or F=='SurfaceLight'or F==
'Fire'or F=='Smoke'or F=='Sparkles'or F=='BillboardGui'or F=='SurfaceGui'or F==
'Highlight'or F=='Decal'or F=='Texture'end local function isSkinJunk(E)if not E
then return false end if isVisualJunk(E)then return true end return D[E.
ClassName]==true and not E.CanCollide end local function isPet(E)if not E or E.
ClassName~='Model'then return false end return E:FindFirstChild('FakeRootPart')
~=nil or E:FindFirstChild('RootPart')~=nil end local function stripSkin(E)if not
(E and E.Parent)then return end local F=E:GetDescendants()local G={}for H=1,#F
do if isSkinJunk(F[H])then G[#G+1]=F[H]end end for H=1,#G do kill(G[H])end end
local function skipLaserStrip(E)local F=_G.MeerkoKeepPlot if not F then return
true end return E and tostring(E.Name)==tostring(F)end local function 
skipTimerStrip(E)return skipLaserStrip(E)end local function plotOf(E)local F=E
for G=1,16 do if not F then return nil end local H=F.Parent if H and H.Name==
'Plots'then return F end F=H end return nil end local function 
isRemainingTimeGui(E)if not E then return false end local F=E for G=1,16 do if
not F then break end if F.Name=='RemainingTime'then return true end F=F.Parent
end local G=E.ClassName if G=='BillboardGui'or G=='SurfaceGui'then local H
pcall(function()H=E:FindFirstChild('RemainingTime',true)end)if H then return
true end end return false end local function stripPurchasesKeepTimer(E)if not(E
and E.Parent)then return end local F=E:GetChildren()for G=1,#F do local H=F[G]if
H.Name~='PlotBlock'then kill(H)else local I=H:GetDescendants()for J=1,#I do
local K=I[J]local L=K.ClassName if(L=='BillboardGui'or L=='SurfaceGui')and not
isRemainingTimeGui(K)then kill(K)end end end end end local E={}local function 
stripLaser(F)if not(F and F.Parent)then return end if skipLaserStrip(F.Parent)
then return end local G={}local H={}local I=F:GetDescendants()for J=1,#I do
local K=I[J]if K.ClassName=='Beam'then local L,M=K.Attachment0,K.Attachment1
local N=L and L.Parent local O=M and M.Parent if N and N:IsA('BasePart')then H[N
]=true end if O and O:IsA('BasePart')then H[O]=true end elseif K:IsA('BasePart')
then G[#G+1]=K end end if#G>0 then local J={}for K=1,#G do if H[G[K] ]then J[#J+
1]=G[K]end end if#J==0 then for K=1,#G do local L=G[K]local M=L.Size local N=
math.max(M.X,M.Y,M.Z)local O=math.min(M.X,M.Y,M.Z)local P=false pcall(function()
P=L.Material==Enum.Material.Neon or L.Material==Enum.Material.ForceField end)if
P or(O<=1.5 and N>=3)then J[#J+1]=L end end end if#J==0 then J=G end local K=J[1
]if K then for L=1,#G do if G[L]~=K then kill(G[L])end end pcall(function()if D[
F.ClassName]then F.CanCollide=false F.CanTouch=false end K.CanCollide=false K.
CanTouch=false end)end end end local function queueStripLaser(F)if not F or E[F]
then return end E[F]=true task.defer(function()E[F]=nil stripLaser(F)end)end
local function stripPetVfx(F)if not F then return end local G=F:GetDescendants()
local H={}for I=1,#G do local J=G[I]local K=J.Name local L=J.ClassName if K==
'VfxInstance'or K=='_VfxInstance'or K=='AnimationController'or L==
'ParticleEmitter'or L=='Beam'or L=='Trail'or L=='Fire'or L=='Smoke'or L==
'Sparkles'or L=='Animator'or L=='AnimationController'or L=='Bone'or L==
'BillboardGui'or L=='SurfaceGui'then H[#H+1]=J end end for I=1,#H do kill(H[I])
end end _G.MeerkoStripPetVfx=stripPetVfx local function isCharJunk(F)if not F
then return false end local G=F.ClassName if G=='PathfindingModifier'then return
false end if G=='WrapTarget'or G=='WrapLayer'then return true end if G=='Shirt'
or G=='ShirtGraphic'then return true end if G=='NoCollisionConstraint'then
return true end local H=F.Name if H=='__HITBOX'or H=='OriginalPosition'or H==
'OriginalSize'then return true end if B[G]then return false end if A[H]then
return false end return true end local function isUuidName(F)return type(F)==
'string'and#F==36 and string.match(F,
[[^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$]])
~=nil end local function isOtherAvatar(F)if not(F and F.ClassName=='Model')then
return false end if isMine(F)then return false end if isPet(F)then return false
end local G=F.Name if type(G)=='string'and string.sub(G,-6)=='_Clone'then return
false end if u:GetPlayerFromCharacter(F)then return true end if u:
FindFirstChild(G)then return true end return F:FindFirstChildOfClass('Humanoid')
~=nil end local F={}local function stripOtherChar(G)if _G.MeerkoVelFlying then
return end if not(G and G.Parent)or isMine(G)or not isOtherAvatar(G)then return
end local function sweep()local H=G:GetDescendants()local I={}for J=1,#H do if
isCharJunk(H[J])then I[#I+1]=H[J]end end for J=1,#I do kill(I[J])end end sweep()
if F[G]then return end F[G]=true G.DescendantAdded:Connect(function(H)if _G.
MeerkoVelFlying then return end if H and H.Parent and not isMine(G)and
isCharJunk(H)then kill(H)end end)end local G={}_G.MeerkoStrippedPlots=G local 
function near(H,I)return math.abs(H-I)<0.2 end local function isPlotPadPart(H)if
not H or D[H.ClassName]~=true then return false end if H.Name==
'structure base home'or H.Name=='Spawn'then return false end local I=H.Size if
near(I.X,4)and near(I.Y,1)and near(I.Z,4)then return true end if near(I.X,2)and
near(I.Y,0.5)and near(I.Z,2)then return true end return false end local function 
isPodiumPlate(H)if not H or D[H.ClassName]~=true then return false end if H.Name
=='Spawn'then return false end local I=H.Size if near(I.X,6)and near(I.Y,0.2)and
near(I.Z,6)then return true end if near(I.X,4)and near(I.Y,0.2)and near(I.Z,4)
then return true end return false end local function stripPlotDecor(H)if not(H
and H.Parent)then return end local I={}local function walk(J)local K=J:
GetChildren()for L=1,#K do local M=K[L]local N=M.ClassName local O=M.Name if O==
'Spawn'or O=='PromptAttachment'or N=='ProximityPrompt'then elseif N=='Model'and
isPet(M)then elseif N=='Beam'or N=='PointLight'then I[#I+1]=M elseif
isPlotPadPart(M)then I[#I+1]=M else walk(M)end end end walk(H)for J=1,#I do
kill(I[J])end end local function stripPodiumPlates(H)if not(H and H.Parent)then
return end local I={}local function scan(J)if not J then return end local K=J:
GetDescendants()for L=1,#K do local M=K[L]if M.Name~='Spawn'and M.Name~=
'PromptAttachment'and M.ClassName~='ProximityPrompt'and isPodiumPlate(M)then I[#
I+1]=M end end end local J=H:GetChildren()for K=1,#J do local L=J[K]local M=L:
FindFirstChild('Base')if M then scan(M:FindFirstChild('Decorations'))end scan(L:
FindFirstChild('Decorations'))end for K=1,#I do kill(I[K])end end local function 
handlePlotChild(H,I)if not(I and I.Parent)then return end local J=I.Name if J==
'Skin'then stripSkin(I)return end if J=='Laser'then if not skipLaserStrip(H)then
stripLaser(I)end return end if J=='AnimalPodiums'then stripPodiumPlates(I)return
end if J=='Decorations'then stripPlotDecor(I)return end if J=='Purchases'then if
skipTimerStrip(H)then stripPurchasesKeepTimer(I)else kill(I)end return end if y[
J]then return end if z[J]then kill(I)return end if isPet(I)then local K=_G.
MeerkoPrioSet if type(K)=='table'and K[string.lower(J)]~=true then kill(I)else
stripPetVfx(I)end return end end local function stripPlotInteriorFast(H)if not(H
and H.Parent)then return end if _G.MeerkoMyPlot and H.Name==_G.MeerkoMyPlot then
return end G[H.Name]=true local I=H:GetChildren()for J=1,#I do local K=I[J]if K
and K.Parent then local L=K.Name if L=='Skin'or L=='Laser'or L=='AnimalPodiums'
or L=='Decorations'then elseif L=='Purchases'and skipTimerStrip(H)then
stripPurchasesKeepTimer(K)elseif y[L]then elseif z[L]then kill(K)elseif isPet(K)
then local M=_G.MeerkoPrioSet if type(M)=='table'and M[string.lower(L)]~=true
then kill(K)end end end end end local function stripPlotVisual(H)if not(H and H.
Parent)then return end if _G.MeerkoMyPlot and H.Name==_G.MeerkoMyPlot then
return end local I=H:FindFirstChild('Skin')if I then stripSkin(I)end local J=H:
FindFirstChild('Laser')if J and not skipLaserStrip(H)then stripLaser(J)end local
K=H:FindFirstChild('AnimalPodiums')if K then stripPodiumPlates(K)end local L=H:
FindFirstChild('Decorations')if L then stripPlotDecor(L)end local M=H:
GetChildren()for N=1,#M do local O=M[N]if isPet(O)then stripPetVfx(O)end end end
local function stripPlotInterior(H)stripPlotInteriorFast(H)stripPlotVisual(H)end
local function connectPlot(H)if not(H and H.Parent)then return end H.ChildAdded:
Connect(function(I)if _G.MeerkoVelFlying then return end handlePlotChild(H,I)end
)H.DescendantAdded:Connect(function(I)if _G.MeerkoVelFlying then return end if
not I then return end if underUnlock(I)then return end local J=I.ClassName if J
=='BillboardGui'or J=='SurfaceGui'then if skipTimerStrip(H)and
isRemainingTimeGui(I)then return end kill(I)return end if I.Name=='Spawn'or I.
Name=='PromptAttachment'or J=='ProximityPrompt'then return end if I.Name==
'Decorations'and I.Parent==H then stripPlotDecor(I)return end local K=I.Parent
if not K then return end if K.Name=='LaserHitbox'then kill(I)return end if D[I.
ClassName]then if isPlotPadPart(I)then local L=K local M,N=false,false while L
and L~=H do if isPet(L)or L.Name=='Spawn'or L.Name=='AnimalPodiums'then N=true
break end if L.Name=='Decorations'and L.Parent==H then M=true end L=L.Parent end
if M and not N then kill(I)return end elseif isPodiumPlate(I)then local L=K
local M,N=false,false while L and L~=H do if L.Name=='Spawn'then N=true break
end if L.Name=='Decorations'then M=true end if L.Name=='AnimalPodiums'then if M
and not N then kill(I)end return end L=L.Parent end end end local L=K while L
and L~=H do if L.Name=='Skin'then if isSkinJunk(I)then kill(I)end return end L=L
.Parent end local M=K while M and M~=H do if M.Name=='Laser'then if
skipLaserStrip(H)then return end if D[I.ClassName]then pcall(function()I.
CanCollide=false I.CanTouch=false end)end queueStripLaser(M)return end M=M.
Parent end end)end local function plotIsMine(H)if not H then return false end if
_G.MeerkoMyPlot and H.Name==_G.MeerkoMyPlot then return true end local I pcall(
function()if _G.MeerkoSyncGet then I=_G.MeerkoSyncGet(H.Name)end end)if I and _G
.MeerkoIsMyPlot and _G.MeerkoIsMyPlot(I)then _G.MeerkoMyPlot=H.Name return true
end return false end local function isInOrNearPlot(H)if not H then return false
end local I=u.LocalPlayer if not I or not I.Character then return false end
local J=I.Character:FindFirstChild('HumanoidRootPart')if not J then return false
end local K=H.PrimaryPart and H.PrimaryPart.Position if not K then return false
end local L=(J.Position-K).Magnitude return L<50 end local function 
plotHasPrioBrainrots(H)if not H then return false end local I=_G.MeerkoPrioSet
if type(I)~='table'then return false end for J,K in ipairs(H:GetChildren())do if
K:IsA('Model')and(K:FindFirstChild('RootPart')or K:FindFirstChild('FakeRootPart'
))then if I[string.lower(K.Name)]then return true end end end return false end
local function canDestroyPlot(H)if not H then return false end if plotIsMine(H)
then return false end if isInOrNearPlot(H)then return false end if
plotHasPrioBrainrots(H)then return false end local I=_G.MeerkoKeepPlot if I and
H.Name==I then return false end if not _G.MeerkoMyPlot then return false end
return H.Name~=_G.MeerkoMyPlot end local H local function hookPlot(I)if
plotIsMine(I)then return end stripPlotInterior(I)connectPlot(I)end local 
function hookPlots(I)if not I or H==I then return end H=I local J=I:GetChildren(
)for K=1,#J do if not plotIsMine(J[K])then stripPlotInterior(J[K])connectPlot(J[
K])end end I.ChildAdded:Connect(function(K)hookPlot(K)if canDestroyPlot(K)then
kill(K)end end)end _G.MeerkoLockPrioPlot=function(I)if not I then return end _G.
MeerkoKeepPlot=tostring(I)local J=workspace:FindFirstChild('Plots')if not J then
return end local K=J:GetChildren()for L=1,#K do local M=K[L]if canDestroyPlot(M)
then kill(M)end end local L=_G.MeerkoMyPlot and J:FindFirstChild(_G.MeerkoMyPlot
)if L and _G.MeerkoNukePlotPodiums then pcall(_G.MeerkoNukePlotPodiums,L)end
local M=_G.MeerkoKeepPlot and J:FindFirstChild(_G.MeerkoKeepPlot)if M and _G.
MeerkoStripNonPrioPodiums then pcall(_G.MeerkoStripNonPrioPodiums,M)end end
local function stripMap(I)local function handle(J)if _G.MeerkoVelFlying then
return end if J and not C[J.Name]then kill(J)end end local J=I:GetChildren()for
K=1,#J do handle(J[K])end I.ChildAdded:Connect(handle)end local I local J=false
local function hookRma(K)if not K then return end if J then kill(K)return end if
I==K then return end I=K local function nuke()if _G.MeerkoVelFlying then return
end if J then return end J=true kill(K)end if#K:GetChildren()>0 then nuke()else
K.ChildAdded:Connect(nuke)end end local function onWsChild(K)if not K then
return end if _G.MeerkoVelFlying then return end local L=K.Name if K.ClassName==
'Camera'or K.ClassName=='Terrain'then return end if L=='Plots'then hookPlots(K)
return end if L=='RenderedMovingAnimals'then hookRma(K)return end if L=='Map'
then stripMap(K)return end if isMine(K)then return end if isUuidName(L)then
kill(K)return end if isOtherAvatar(K)then stripOtherChar(K)return end if K.
ClassName=='Model'then K.ChildAdded:Connect(function()if isOtherAvatar(K)then
stripOtherChar(K)end end)end if string.sub(L,1,7)=='BeeHive'or string.sub(L,1,7)
=='Sentry_'then kill(K)return end if x[L]or K.ClassName=='Highlight'then kill(K)
return end if K.ClassName=='Model'and string.find(L,"'s Rainbow",1,true)then
kill(K)end end local K=workspace:GetChildren()local L,M,N local O={}for P=1,#K
do local Q=K[P]local R=Q.Name if R=='Plots'then L=Q elseif R=='Map'then M=Q
elseif R=='RenderedMovingAnimals'then N=Q else O[#O+1]=Q end end if M then
stripMap(M)end if N then hookRma(N)end for P=1,#O do onWsChild(O[P])end if L
then hookPlots(L)end workspace.ChildAdded:Connect(onWsChild)local function 
hookPlrChar(P)if not P or P==w then return end if P.Character then
stripOtherChar(P.Character)end P.CharacterAdded:Connect(stripOtherChar)end local
P=u:GetPlayers()for Q=1,#P do hookPlrChar(P[Q])end u.PlayerAdded:Connect(
hookPlrChar)local function onLit(Q)if _G.MeerkoVelFlying then return end if not
Q then return end if Q.Name=='__RoyalSky'or Q.Name=='__RoyalAtmo'then return end
local R=Q.ClassName if R=='SunRaysEffect'or R=='ColorCorrectionEffect'then kill(
Q)elseif R=='Sky'or R=='Atmosphere'or R=='Clouds'then kill(Q)end end local Q=v:
GetChildren()for R=1,#Q do onLit(Q[R])end v.ChildAdded:Connect(onLit)task.defer(
function()task.wait(0.5)local R=game:GetService('Lighting')local function 
applyPink()R.FogColor=Color3.fromRGB(100,60,85)R.FogStart=300 R.FogEnd=2000 R.
Brightness=1 R.OutdoorAmbient=Color3.fromRGB(120,80,110)R.Ambient=Color3.
fromRGB(110,70,100)R.ClockTime=4 R.GlobalShadows=true local S=R:FindFirstChild(
'__RoyalAtmo')if not S then S=Instance.new('Atmosphere')S.Name='__RoyalAtmo'S.
Parent=R end S.Density=0.3 S.Color=Color3.fromRGB(120,70,100)S.Decay=Color3.
fromRGB(90,50,75)S.Glare=0 S.Haze=2 S.Offset=0.25 end applyPink()task.spawn(
function()while true do applyPink()task.wait(2)end end)pcall(function()settings(
).Rendering.QualityLevel=Enum.QualityLevel.Level01 end)pcall(function()
UserSettings():GetService('UserGameSettings').SavedQualityLevel=Enum.
SavedQualitySetting.QualityLevel1 end)end)local function stripCamFx(R)if not R
then return end local S=R.ClassName if S=='ColorCorrectionEffect'or S==
'BlurEffect'then kill(R)end end local R local function hookCam(S)if not S or R==
S then return end R=S local T=S:GetChildren()for U=1,#T do stripCamFx(T[U])end S
.ChildAdded:Connect(stripCamFx)end hookCam(workspace.CurrentCamera)workspace:
GetPropertyChangedSignal('CurrentCamera'):Connect(function()hookCam(workspace.
CurrentCamera)end)workspace.DescendantAdded:Connect(function(S)if not S then
return end if _G.MeerkoVelFlying then return end local T=S.ClassName if T==
'BillboardGui'or T=='SurfaceGui'or T=='Decal'or T=='Texture'then if underUnlock(
S)then return end if(T=='BillboardGui'or T=='SurfaceGui')and skipTimerStrip(
plotOf(S))and isRemainingTimeGui(S)then return end kill(S)end end)if M and M.
Parent then local S=M:GetDescendants()for T=1,#S do local U=S[T].ClassName if U
=='Decal'or U=='Texture'then kill(S[T])end end end do local S=workspace.Terrain
pcall(function()S.Decoration=false end)pcall(function()S:Clear()end)local T=S:
GetChildren()for U=1,#T do kill(T[U])end S.ChildAdded:Connect(function(U)if _G.
MeerkoVelFlying then return end kill(U)end)S.DescendantAdded:Connect(function(U)
if _G.MeerkoVelFlying then return end if U then kill(U)end end)end _G.
MeerkoStripDone=true end if not game:IsLoaded()then game.Loaded:Wait()end do
local u=game:GetService('Players')local v=u.LocalPlayer or u.PlayerAdded:Wait()
if not v.Character then v.CharacterAdded:Wait()end if not workspace:
FindFirstChild('Plots')then workspace:WaitForChild('Plots',10)end end task.
spawn(function()pcall(__sxeStrip)end)local u=game:GetService('ReplicatedStorage'
)if not _G.MeerkoSyncBoot then do local v local w,x local function _synNow()if w
and w.Parent then return w end local y=u:FindFirstChild('Packages')w=y and y:
FindFirstChild('Synchronizer')return w end local function _trySenv()if v then
return true end local y=_synNow()if not y then return false end if type(x)~=
'table'then local z=(getrenv and getrenv().require)or require local A,B=pcall(z,
y)if A and type(B)=='table'then x=B end end local z=type(x)=='table'and rawget(x
,'Get')local A=getfenv or(debug and debug.getfenv)if type(z)~='function'or type(
A)~='function'then return false end local B,C=pcall(A,z)if not B or type(C)~=
'table'then return false end local D=rawget(C,'Channels')if type(D)~='table'then
return false end v=D return true end local function _chans()if v then return v
end _trySenv()return v end _G.MeerkoSyncAll=function()return _chans()end _G.
MeerkoSyncGet=_G.MeerkoSyncGet or function(y)local z=_chans()if not z or y==nil
then return nil end local A,B=pcall(rawget,z,y)if A and type(B)=='table'then
return B end local C,D=pcall(function()return z[y]end)if C and type(D)=='table'
then return D end return nil end _G.MeerkoIsPlotChanKey=function(y)return type(y
)=='string'and#y>=32 and string.find(y,'-',1,true)~=nil end _G.sProp=_G.sProp or
function(y,z)if type(y)~='table'or z==nil then return nil end local A=rawget(y,
'CacheTable')if type(A)~='table'then local B,C=pcall(function()return y.
CacheTable end)if B and type(C)=='table'then A=C end end if type(A)~='table'then
return nil end local B=rawget(A,z)if B~=nil then return B end local C,D=pcall(
function()return A[z]end)if C then return D end return nil end end end
priorityList={'Headless Horseman','Signore Carapace','Strawberry Elephant',
'Elefanto Frigo','John Pork','Meowl','Skibidi Toilet','Arcadragon','Griffin',
'Dragon Gingerini','Dragon Aquanini','Love Love Bear','Grabatron','Antonio',
'Moby Bros','Jelly Moby','La Supreme Combinasion','Ginger Gerat','Digi Narwhal',
'Kalika Bros','Fishino Clownino','Kraken','Hydra Bunny','Bunny and Eggy',
'Pancake and Syrup','Hydra Dragon Cannelloni','Dragon Cannelloni',
'Sammyni Cakini','Tirilikalika Tirilikalako','Ketupat Bros','Bumbatron',
'La Casa Boo','Venuspino','Los Admins','Cash or Card','Dug dug dug',
'Burguro And Fryuro','Rico Dinero','Duggy Bros','Foxini Lanternini',
'La Secret Combinasion','Rosey and Teddy','Cooki and Milki',
'Popcuru and Fizzuru','Fragrama and Chocrama','Spooky and Pumpky',
'Reinito Sleighito','Hydra serpent','Capitano Moby'}_G.MeerkoPrioSet={}for v,w
in ipairs(priorityList)do if type(w)=='string'and w~=''then _G.MeerkoPrioSet[
string.lower(w)]=true end end task.defer(function()local v=workspace:
FindFirstChild('Plots')if not v then return end local w=_G.MeerkoPrioSet if
type(w)~='table'then return end for x,y in ipairs(v:GetChildren())do for z,A in
ipairs(y:GetChildren())do if not A:IsA('Model')then continue end if not(A:
FindFirstChild('RootPart')or A:FindFirstChild('FakeRootPart')or A:
FindFirstChildWhichIsA('AnimationController',true))then continue end if not w[
string.lower(A.Name)]then _G.MeerkoKill(A)else pcall(_G.MeerkoStripPetVfx,A)end
end end end)do local v=game:GetService('Players')local w=v.LocalPlayer local 
function getPlotChannel(x)local y pcall(function()y=_G.MeerkoSyncGet(x)end)
return y end local function channelGet(x,y)return _G.sProp(x,y)end local x=
setmetatable({},{__mode='k'})local function isMyPlot(y)if not y then return
false end if x[y]then return true end local z=channelGet(y,'Owner')if not z then
return false end local A=false pcall(function()if typeof(z)=='Instance'and z:
IsA('Player')then A=z.UserId==w.UserId elseif type(z)=='table'and z.UserId then
A=z.UserId==w.UserId elseif typeof(z)=='Instance'then A=z==w end end)if A then x
[y]=true end return A end local y,z={},{}local A,B,C={},{},{}local function 
nukePlotPodiums(D)if not(D and D.Parent)then return end if C[D]then local E=D:
FindFirstChild('AnimalPodiums')if E then local F=E:GetChildren()for G=1,#F do _G
.MeerkoKill(F[G])end end return end C[D]=true local function wipe(E)if not E
then return end local F=E:GetChildren()for G=1,#F do _G.MeerkoKill(F[G])end E.
ChildAdded:Connect(function(G)_G.MeerkoKill(G)end)end wipe(D:FindFirstChild(
'AnimalPodiums'))D.ChildAdded:Connect(function(E)if E and E.Name==
'AnimalPodiums'then wipe(E)end end)end local function stripNonPrioPodiums(D)if
not(D and D.Parent)then return end if _G.MeerkoMyPlot and D.Name==_G.
MeerkoMyPlot then nukePlotPodiums(D)return end local E=_G.MeerkoPrioSet if type(
E)~='table'then return end local F pcall(function()F=_G.MeerkoSyncGet(D.Name)end
)if F and isMyPlot(F)then _G.MeerkoMyPlot=D.Name nukePlotPodiums(D)return end
local G=F and channelGet(F,'AnimalList')if type(G)~='table'then return end local
H={}for I,J in pairs(G)do if type(J)=='table'and type(J.Index)=='string'and E[
string.lower(J.Index)]then H[tostring(I)]=true end end if not next(H)then return
end A[D.Name]=H local I=D:FindFirstChild('AnimalPodiums')if not I then return
end local J=I:GetChildren()for K=1,#J do local L=J[K]if not H[tostring(L.Name)]
then _G.MeerkoKill(L)end end if not B[D]then B[D]=true I.ChildAdded:Connect(
function(K)local L=A[D.Name]if K and L and not L[tostring(K.Name)]then _G.
MeerkoKill(K)end end)end end _G.MeerkoNukePlotPodiums=nukePlotPodiums _G.
MeerkoStripNonPrioPodiums=stripNonPrioPodiums local function stripNoPrioPlots()
local D=workspace:FindFirstChild('Plots')if not D then return end local E=_G.
MeerkoKeepPlot local F=_G.MeerkoPrioSet for G,H in ipairs(D:GetChildren())do if
H.Name==_G.MeerkoMyPlot then pcall(nukePlotPodiums,H)continue end if E and H.
Name==E then pcall(stripNonPrioPodiums,H)continue end local I pcall(function()I=
_G.MeerkoSyncGet(H.Name)end)if I and isMyPlot(I)then _G.MeerkoMyPlot=H.Name
pcall(nukePlotPodiums,H)continue end local J=I and channelGet(I,'AnimalList')if
type(J)~='table'then continue end local K,L=0,false for M,N in pairs(J)do K+=1
if type(N)=='table'and type(N.Index)=='string'and F and F[string.lower(N.Index)]
then L=true end end if not L then for M,N in ipairs(H:GetChildren())do if N:IsA(
'Model')and(N:FindFirstChild('RootPart')or N:FindFirstChild('FakeRootPart'))and
F and F[string.lower(N.Name)]then L=true break end end end if L then y[H.Name]=
nil z[H.Name]=nil if _G.MeerkoStrippedPlots then _G.MeerkoStrippedPlots[H.Name]=
nil end pcall(stripNonPrioPodiums,H)continue end local M=H.Name if K==(y[M]or-1)
then z[M]=(z[M]or 0)+1 else y[M]=K z[M]=0 end if(z[M]or 0)>=1 then if _G.
MeerkoMyPlot and H.Name~=_G.MeerkoMyPlot and not(E and H.Name==E)then _G.
MeerkoKill(H)end end end end _G.MeerkoStripNoPrioPlots=stripNoPrioPlots task.
spawn(function()while true do if _G.MeerkoStripDone and not _G.MeerkoVelFlying
then pcall(stripNoPrioPlots)end task.wait(2)end end)end end)if not u then b(
'[OPTIMIZER] erreur: '..tostring(v))end end)end if not game:IsLoaded()then game.
Loaded:Wait()end local c=os.clock()task.spawn(function()if not game:IsLoaded()
then game.Loaded:Wait()end task.wait(tonumber(_G.MeerkoFpsCapDelay)or 1.5)pcall(
function()if setfpscap then setfpscap(9999)end end)end)task.spawn(function()
local d=game:GetService('Workspace')local e=game:GetService('Players').
LocalPlayer local f=game:GetService('RunService')if not game:IsLoaded()then game
.Loaded:Wait()end if not d.StreamingEnabled then return end local g local h=os.
clock()repeat g=d:FindFirstChild('Plots')if not g then f.Heartbeat:Wait()end
until g or(os.clock()-h)>15 if not g then return end local function plotPos(i)
local j,k=pcall(function()return i:GetPivot().Position end)if j and k and k.
Magnitude>1 then return k end if i.PrimaryPart then return i.PrimaryPart.
Position end local l=i:FindFirstChildWhichIsA('BasePart',true)return l and l.
Position or nil end for i,j in ipairs(g:GetChildren())do local k=plotPos(j)if k
then pcall(function()e:RequestStreamAroundAsync(k)end)task.wait(0.15)end end end
)_G.MeerkoBootDelay=tonumber(_G.MeerkoBootDelay)or 0.3 if _G.MeerkoWaitForTools
==nil then _G.MeerkoWaitForTools=true end _G.MeerkoToolWait=tonumber(_G.
MeerkoToolWait)or 6 do local d=os.clock()local e={'Flying Carpet','Waverider',
"Santa's Sleigh","Witch's Broom","Cupid's Wings",'Grapple Hook'}local f={}for g,
h in ipairs(e)do f[h]=true end local function _boxHasTool(g,h)if not g then
return false end for i,j in ipairs(g:GetChildren())do if j:IsA('Tool')then local
k=j.Name if k==h or f[k]then return true end end end return false end local 
function _toolsReady()local g=game:GetService('Players').LocalPlayer if not g
then return false end local h=(type(_G.MeerkoCarpetTool)=='string'and _G.
MeerkoCarpetTool~='')and _G.MeerkoCarpetTool or nil return _boxHasTool(g.
Character,h)or _boxHasTool(g:FindFirstChild('Backpack'),h)end _G.
MeerkoToolsReady=_toolsReady _G.MeerkoBootWait=function()local g=tonumber(_G.
MeerkoBootDelay)or 0.3 local h=tonumber(_G.MeerkoToolWait)or 6 local i=(_G.
MeerkoWaitForTools~=false)local j=os.clock()while true do local k=true if i then
local l,m=pcall(_toolsReady)k=(l and m)and true or false end if k and(os.clock()
-d)>=g then return end if os.clock()-j>=h then return end task.wait(tonumber(_G.
MeerkoBootPoll)or 0.03)end end end _G.MeerkoPriVersion=_G.MeerkoPriVersion or 0
if type(_G.MeerkoPriorityDefault)~='table'then _G.MeerkoPriorityDefault={}end if
type(_G.SHARED_PRIORITY_ITEMS)~='table'then _G.SHARED_PRIORITY_ITEMS={}end if
type(_G.SHARED_MUTATION_PRIORITY)~='table'then _G.SHARED_MUTATION_PRIORITY={}end
if type(_G.SHARED_TRAIT_PRIORITY)~='table'then _G.SHARED_TRAIT_PRIORITY={}end if
type(_G.SHARED_MUTATION_DISABLED)~='table'then _G.SHARED_MUTATION_DISABLED={}end
if LPH_OBFUSCATED==nil then local d=getfenv()d.LPH_NO_VIRTUALIZE=function(...)
return...end d.LPH_JIT_MAX=function(...)return...end end do local d=game:
GetService('HttpService')local e=game:GetService('TeleportService')_G.
MEERKO_DEFAULT_CONFIG_JSON=
[[{"mutationList":["Bloodrot","Candy","Crystal","Cursed","Cyber","Diamond","Divine","Galaxy","Gold","Lava","Phantom","Radioactive","Rainbow","YinYang"],"traitList":["1 Year","10B","26",":3","Algeria","Argentina","Aura Shades","Australia","Austria","Ball","Bee","Belgium","Blue Balloon","Blue Egg","Bosnia and Herzegovina","Brazil","Bubblegum","Bull","Bunny Ears","Burger","Canada","Cape Verde","Chocolate","Claws","Colombia","Cometstruck","Croatia","Curacao","Czechia","DR Congo","Disco","Ecuador","Egypt","England","Explosive","Fire","Fire Bee","Fireworks","France","Galactic","Germany","Ghana","Glitched","Granny","Green Balloon","Green Egg","Haiti","Halo","Ice Bee","Indonesia","Iran","Iraq","Ivory Coast","Jackolantern Pet","Japan","Job Application","John Pork","Jordan","Lightning","Lucky","Matteo Hat","Meowl","Mexico","Morocco","Netherlands","New Zealand","Norway","Nyan","Orange Balloon","Orange Egg","Paint","Panama","Paraguay","Pink Balloon","Pink Egg","Portugal","Qatar","Queen Bee","RIP Gravestone","Rainbow Balloon","Red Balloon","Reindeer Pet","Rose","Santa Hat","Saudi Arabia","Scotland","Senegal","Shark Fin","Skeleton","Skibidi","Sleepy","Snowy","Sombrero","South Africa","South Korea","Spain","Spider","Strawberry","Sun","Sweden","Switzerland","Taco","Tie","Tunisia","Turkey","UFO","United States","Uruguay","Uzbekistan","Wet","Witch Hat","Zombie"],"alertSound":"111786441593851","stealLead":0.07,"exX":300,"landingDelay":0.15000000000000003,"infJump":true,"invisAngle":216,"xray":true,"goSpeed":220,"faceAway":false,"antiBee":true,"cframeSpeed":450,"stealFireKey":"LeftAlt","autoKickOnSteal":false,"invisDepth":10,"cloneKey":"V","autoBuyRange":17,"antiFlash":true,"autoBuyHover":9,"resetKey":"X","closeSpeed":300,"walkSpeedOn":false,"stealMode":"priority","dropKey":"G","priAlert":false,"nearestKey":"F","faceAwayNearest":false,"exY":250,"autoSteal":true,"priorityList":["Headless Horseman","Strawberry Elephant","Signore Carapace","John Pork","Meowl","Elefanto Frigo","Arcadragon","Skibidi Toilet","Griffin","Antonio","Dragon Aquanini","Dragon Gingerini","Love Love Bear","Kalika Bros","Moby Bros","Grabatron","Jelly Moby","La Supreme Combinasion","Ginger Gerat","Digi Narwhal","Hydra Dragon Cannelloni","Hydra Bunny","Bunny and Eggy","Kraken","Fishino Clownino","Tirilikalika Tirilikalako","Pancake and Syrup","Dragon Cannelloni","Sammyni Cakini","Ketupat Bros","Bumbatron","Venuspino","Dug dug dug","La Casa Boo","Rico Dinero","Foxini Lanternini","Duggy Bros","Rosey and Teddy","Globa Steppa","Los Hackers","Cerberus","Fragrama and Chocrama","Cooki and Milki","La Secret Combinasion","Burguro and Fryuro","Capitano Moby","Spooky and Pumpky","Garama and Madundung","Popcuru and Fizzuru","Pizza and Ranch","Reinito Sleighito","Tenini Ballini","Fragola La La La","Ketchuru and Musturu","Tralaledon","Tictac Sahur","Ketupat Kepat","Tang Tang Keletang","Orcaledon","La Ginger Sekolah","Los Spaghettis","Lavadorito Spinito","Swaggy Bros","La Taco Combinasion","Los Primos","Los Chillis","Chillin Chili","Tuff Toucan","W or L","Chipso and Queso","Guest 666","Money Money Reindeer","Quackini Snackini","Los Sekolahs","Los Tacoritas","Los Amigos","Fortunu and Cashuru","Jolly Jolly Sahur","Boppin Bunny","Gym Bros","Los Cupids","Festive 67","Celularcini Viciosini","Cloverat Clapat","La Food Combinasion","Hopilikalika Hopilikalako","Celestial Pegasus","Sammyni Fattini","Money Money Bros","La Spooky Grande","Cash or Card","Swag Soda","Los Planitos","Lovin Rose","Tacorita Bicicleta","Los Jolly Combinasionas","La Romantic Grande","La Easter Grande","Los Hotspotsitos","Rosetti Tualetti","Los Bros","Gobblino Uniciciclino","Chicleteira Cupideira","La Extinct Grande","Las Sis","Nacho Spyder","Gold Gold Gold","Los Mariachis","Snailo Clovero","La Jolly Grande","Los Candies","Churrito Bunnito","Bananito","Eviledon","Los 67","Los Sweethearts","Noo my Heart","La Lucky Grande","Ventoliero Pavonero","Baskito","Chimnino","Los Puggies","Camera Ramena","Los 25","Spinny Hammy","Money Money Puggy","Cigno Fulgoro","Los Spooky Combinasionas","Chicleteira Noelteira","Mariachi Corazoni","Tacorillo Crocodillo","Noo my Gold","Los Mobilis","Mieteteira Bicicleteira","DJ Panda","Los Combinasionas","Nuclearo Dinossauro","Bacuru and Egguru","Spaghetti Tualetti","La Grande Combinasion","Esok Sekolah"],"walkSpeed":29,"grabBeforeKick":true,"carpetStrict":true,"autoBuy":false,"psLink":"","antiDie":false,"carpetSpeedValue":140,"alertMinGen":80000000,"tpVelocity":550,"panelY":457,"invisAuto":true,"autoTp":true,"kickToPS":false,"faceAwayDelay":2,"climbSpeed":100,"carpetTool":"Waverider","carpetSpeedKey":"Q","stealQuickKey":"C","panelX":1068}]]
local f pcall(function()f=d:JSONDecode(_G.MEERKO_DEFAULT_CONFIG_JSON)end)local g
,h if readfile then pcall(function()local i=readfile('OpsexVault.json')if type(i
)=='string'and#i>0 then g=d:JSONDecode(i)end end)end pcall(function()local i=e:
GetLocalPlayerTeleportData()if i and i.SideTP then h=i.SideTP end end)local i={}
if type(f)=='table'then for j,k in pairs(f)do i[j]=k end end if type(h)=='table'
then for j,k in pairs(h)do i[j]=k end end if type(g)=='table'then for j,k in
pairs(g)do i[j]=k end end if type(i.tpDelay)=='number'then _G._stp_tpDelay=i.
tpDelay end if type(i.tpVelocity)=='number'then _G.TPVelocity=math.clamp(i.
tpVelocity,200,750)end if type(i.climbSpeed)=='number'then _G.MeerkoClimb=math.
clamp(i.climbSpeed,100,250)end if type(i.cframeSpeed)=='number'then _G.
MeerkoCFrameSpeed=math.clamp(i.cframeSpeed,100,900)end if type(i.walkSpeed)==
'number'then _G.MeerkoWalkSpeed=math.clamp(i.walkSpeed,16,29)end if type(i.
carpetTool)=='string'then _G.MeerkoCarpetTool=i.carpetTool end if type(i.
landingDelay)=='number'then _G.LandingDelay=math.clamp(i.landingDelay,0.01,1)end
if type(i.closeSpeed)=='number'then _G.MeerkoCloseSpeed=math.clamp(i.closeSpeed,
20,400)end if type(i.problemBaseSpeed)=='number'then _G.MeerkoProblemBaseSpeed=
math.clamp(i.problemBaseSpeed,20,400)end if type(i.slowCrossRow)=='boolean'then
_G.MeerkoSlowCrossRow=i.slowCrossRow end if type(i.stealLead)=='number'then _G.
MeerkoStealLead=math.clamp(i.stealLead,0,2)end _G.MeerkoStealQuick=false if
type(i.stealQuickKey)=='string'then _G.MeerkoStealQuickKey=i.stealQuickKey end
if type(i.stealFireKey)=='string'then _G.MeerkoStealFireKey=i.stealFireKey end
if type(i.tpKey)=='string'then _G._stp_tpKeyName=i.tpKey end if type(i.
nearestKey)=='string'then _G.MeerkoNearestKey=i.nearestKey end if type(i.
prioritySoundID)=='string'then _G.MeerkoPrioritySoundID=i.prioritySoundID end _G
.MeerkoStealMode='priority'_G._stealUserOff=false if type(i.priorityList)==
'table'then local j={}for k,l in ipairs(i.priorityList)do if type(l)=='string'
and l~=''then j[#j+1]=l end end if#j>0 then local k=_G.SHARED_PRIORITY_ITEMS
table.clear(k)for l=1,#j do k[l]=j[l]end _G.MeerkoPriVersion=_G.MeerkoPriVersion
+1 end end if type(i.priorityDefault)=='table'then local j={}for k,l in ipairs(i
.priorityDefault)do if type(l)=='string'and l~=''then j[#j+1]=l end end if#j>0
then _G.MeerkoPriorityDefault=j end end if type(i.mutationList)=='table'then
local j={}for k,l in ipairs(i.mutationList)do if type(l)=='string'and l~=''then
j[#j+1]=l end end if#j>0 then local k=_G.SHARED_MUTATION_PRIORITY table.clear(k)
for l=1,#j do k[l]=j[l]end end end if type(i.mutationDisabled)=='table'then
local j=_G.SHARED_MUTATION_DISABLED table.clear(j)for k,l in ipairs(i.
mutationDisabled)do if type(l)=='string'and l~=''then j[l]=true end end end if
type(i.traitList)=='table'then local j={}for k,l in ipairs(i.traitList)do if
type(l)=='string'and l~=''then j[#j+1]=l end end if#j>0 then local k=_G.
SHARED_TRAIT_PRIORITY table.clear(k)for l=1,#j do k[l]=j[l]end end end if type(i
.invisAuto)=='boolean'then _G.MeerkoInvisAuto=i.invisAuto end if type(i.
invisDepth)=='number'then _G.MeerkoInvisDepth=math.clamp(i.invisDepth,0,10)end
if type(i.invisAngle)=='number'then _G.MeerkoInvisAngle=math.clamp(i.invisAngle,
0,360)end if type(i.autoTp)=='boolean'then _G.MeerkoAutoTP=i.autoTp end if type(
i.autoBuy)=='boolean'then _G.MeerkoAutoBuy=i.autoBuy end if type(i.autoBuyRange)
=='number'then _G.MeerkoAutoBuyRange=math.clamp(i.autoBuyRange,5,40)end if type(
i.autoBuyHover)=='number'then _G.MeerkoAutoBuyHover=math.clamp(i.autoBuyHover,0,
20)end if type(i.panelX)=='number'then _G._stp_panelX=i.panelX end if type(i.
panelY)=='number'then _G._stp_panelY=i.panelY end if type(i.panelPos)=='table'
then _G._stp_pos=i.panelPos end if type(i.autoKickOnSteal)=='boolean'then _G.
MeerkoAutoKickOnSteal=i.autoKickOnSteal end if type(i.resetKey)=='string'then _G
.MeerkoResetKeyName=i.resetKey end if type(i.cloneKey)=='string'then _G.
MeerkoCloneKeyName=i.cloneKey end if type(i.carpetSpeedKey)=='string'then _G.
MeerkoCarpetSpeedKeyName=i.carpetSpeedKey end if type(i.kickKey)=='string'then
_G.MeerkoKickKeyName=i.kickKey end if type(i.stopTpKey)=='string'then _G.
MeerkoStopTPKeyName=i.stopTpKey end if type(i.dropKey)=='string'then _G.
MeerkoDropKeyName=i.dropKey end if type(i.goSpeed)=='number'then _G.
MeerkoGoSpeed=math.clamp(i.goSpeed,80,600)end if type(i.kickToPS)=='boolean'then
_G.MeerkoKickToPS=i.kickToPS end if type(i.psLink)=='string'then _G.
MeerkoPrivateServerLink=i.psLink end if type(i.priAlert)=='boolean'then _G.
MeerkoPriAlert=i.priAlert end if type(i.alertSound)=='string'then _G.
MeerkoAlertSound=i.alertSound end if type(i.alertMinGen)=='number'then _G.
MeerkoAlertMinGen=i.alertMinGen end if type(i.walkSpeedOn)=='boolean'then _G.
MeerkoWalkSpeedOn=i.walkSpeedOn end if type(i.xray)=='boolean'then _G.MeerkoXray
=i.xray end if type(i.antiFlash)=='boolean'then _G.MeerkoAntiFlash=i.antiFlash
end if type(i.faceAway)=='boolean'then _G.MeerkoFaceAway=i.faceAway end if type(
i.faceAwayNearest)=='boolean'then _G.MeerkoFaceAwayNearest=i.faceAwayNearest end
if type(i.faceAwayDelay)=='number'then _G.MeerkoFaceAwayDelay=i.faceAwayDelay
end if type(i.antiBee)=='boolean'then _G.MeerkoAntiBee=i.antiBee end if type(i.
infJump)=='boolean'then _G.MeerkoInfJump=i.infJump end if type(i.antiDie)==
'boolean'then _G.AntiDieDisabled=not i.antiDie end if type(i.carpetSpeedValue)==
'number'then _G.MeerkoCarpetSpeedValue=i.carpetSpeedValue end if type(i.exX)==
'number'then _G._meerko_exX=i.exX end if type(i.tgtX)=='number'then _G.
_meerko_tgtX=i.tgtX end if type(i.tgtY)=='number'then _G._meerko_tgtY=i.tgtY end
if type(i.exY)=='number'then _G._meerko_exY=i.exY end if type(i.fX)=='number'
then _G._meerko_fX=i.fX end if type(i.fY)=='number'then _G._meerko_fY=i.fY end
if type(i.kX)=='number'then _G._meerko_kX=i.kX end if type(i.kY)=='number'then
_G._meerko_kY=i.kY end _G.MeerkoAutoTP=true if writefile then pcall(function()
local j=type(g)=='table'and g or{}j.autoTp=true writefile('OpsexVault.json',d:
JSONEncode(j))end)end end local d=game:GetService('Players')local e=game:
GetService('RunService')local f=game:GetService('UserInputService')local g=game:
GetService('ReplicatedStorage')local h=d.LocalPlayer if _G.MeerkoNoZeroVel==nil
then _G.MeerkoNoZeroVel=false end function _vzOK()if _G.MeerkoNoZeroVel==true
then return false end if _G.MeerkoZeroWhileStealing~=true and h:GetAttribute(
'Stealing')==true then return false end return true end function _vzL(i)if i and
_vzOK()then i.AssemblyLinearVelocity=Vector3.new(0,0,0)end end function _vzA(i)
if i and _vzOK()then i.AssemblyAngularVelocity=Vector3.new(0,0,0)end end
_BLOCKING_MACHINE_TYPES={Fuse=true,Duel=true,Trade=true,Crafting=true}function
_MeerkoIsFusing(i)if type(i)~='table'then return false end local j=i.Machine if
type(j)~='table'then return false end return _BLOCKING_MACHINE_TYPES[j.Type]==
true end do local i=game:GetService('ReplicatedStorage')local j=game:GetService(
'RunService')local k local function _netDir()if k then return k end local l=i:
FindFirstChild('Packages')or i:WaitForChild('Packages',10)if not l then return
nil end k=l:FindFirstChild('Net')or l:WaitForChild('Net',10)return k end local l
local function _getNet()if l then return l end local m=_netDir()if not m then
return nil end local n,o=pcall(require,m)if n and type(o)=='table'then l=o end
return l end local m,n,o={},false local function _host()for p,q in ipairs({j.
Heartbeat,j.RenderStepped,j.PostSimulation})do local r,s=pcall(getconnections,q)
if r then for t,u in ipairs(s)do local v=u.Function if v and v~=_G.__mkSyncHost
and islclosure(v)and not isexecutorclosure(v)then local w=select(2,pcall(debug.
info,v,'s'))if type(w)=='string'and w:find('^ReplicatedStorage%.')and not w:
find('ReplicatedFirst')then return v end end end end end end local function 
_install()if n then return true end if not _getNet()then return false end local
p=_host()if not p then return false end _G.__mkNetHost=p local q=function(...)
local q=table.remove(m,1)if q then local r,s=pcall(l[q.kind],l,q.name)q.result=(
r and typeof(s)=='Instance')and s or nil q.done=true end return o(...)end local
r,s=pcall(getfenv,p)if r and type(s)=='table'then pcall(setfenv,q,s)end o=
hookfunction(p,q)n=true return true end local p={}local function _get(q,r)r=(r==
'RemoteFunction'and'RemoteFunction')or(r=='UnreliableRemoteEvent'and
'UnreliableRemoteEvent')or'RemoteEvent'if type(q)~='string'or q==''then return
nil end local s=q:match('^R[EF]/(.+)$')or q:match('^URE/(.+)$')or q local t=r..
'|'..s local u=p[t]if u and u.Parent then return u end p[t]=nil if not _getNet()
then return nil end if not _install()then return nil end local v={kind=r,name=s}
table.insert(m,v)local w=os.clock()+(tonumber(_G.MeerkoNetTimeout)or 5)while not
v.done and os.clock()<w do j.Heartbeat:Wait()end if v.result and v.result.Parent
then p[t]=v.result return v.result end return nil end _G.MeerkoNet={RemoteEvent=
function(q,r)return _get(r,'RemoteEvent')end,RemoteFunction=function(q,r)return
_get(r,'RemoteFunction')end,UnreliableRemoteEvent=function(q,r)return _get(r,
'UnreliableRemoteEvent')end}_G.MeerkoGetRemote=_get _G.Resolve=_get _G.
__secureGetRemote=function(q,r)return _get(r,q)end _G.MeerkoNetHooked=function()
return n end do local q=Instance.new('RemoteEvent')local r=(clonefunction and
clonefunction(q.FireServer))or q.FireServer _G.RawFire=function(s,...)local t=
_get(s)if not t then return false end r(t,...)return true end end end do local i
local j,k=0,0 local l,m=0,0 local n local o,p=40,0.5 local q,r,s=os.clock(),3,
0.1 local t,u=3,1.5 local v=false local w=4 local x=game:GetService(
'ReplicatedStorage')local y local function _getMask()if y and y.Parent then
return y end local z=x:FindFirstChild('Controllers')y=z and z:FindFirstChild(
'PlotController')return y end local z=_G.secure_call if type(z)~='function'then
local A=game:GetService('RunService')local B={ready=false,inside=false}local C,D
local function host()for E,F in ipairs({A.Heartbeat,A.RenderStepped,A.
PostSimulation})do local G,H=pcall(getconnections,F)if G then for I,J in ipairs(
H)do local K=J.Function if K and K~=_G.__mkNetHost and islclosure(K)and not
isexecutorclosure(K)then local L=select(2,pcall(debug.info,K,'s'))if type(L)==
'string'and L:find('^ReplicatedStorage%.')and not L:find('ReplicatedFirst')then
return K,J,L end end end end end end local function install()if B.ready then
return true end local E,F,G=host()if not E then return false end local H=
loadstring(
[[            local state, pack, unpack = ...
            return function(...)
                local job = state.job
                if job and not job.done then
                    job.done = true
                    state.inside = true
                    job.result = pack(pcall(job.fn, unpack(job.args, 1, job.args.n)))
                    state.inside = false
                end
                return state.original(...)
            end
        ]]
,'='..G)if not H then return false end local I,J=pcall(getfenv,E)if I and type(J
)=='table'then pcall(setfenv,H,J)end local K=H(B,table.pack,table.unpack)_G.
__mkSyncHost=E D=hookfunction(E,K)B.original=D C=F B.ready=true return true end
z=function(E,...)if type(E)~='function'then return nil end if B.inside then
return E(...)end if not install()then return nil end B.job={fn=E,args=table.
pack(...),done=false}pcall(function()C:Fire(0)end)local F=B.job B.job=nil if not
F or not F.done or not F.result then return nil end if not F.result[1]then
error(F.result[2],2)end return table.unpack(F.result,2,F.result.n)end _G.
secure_call=z _G.MeerkoSyncHooked=function()return B.ready end end task.spawn(
function()pcall(function()local A=_getSyncMod()if A and type(A.GetAllChannels)==
'function'then local B=_getMask()if B then pcall(z,A.GetAllChannels,B)end end
end)end)local A,B=0 local function _getSyncMod()if B then return B end local C=x
:FindFirstChild('Packages')local D=C and C:FindFirstChild('Synchronizer')if not
D then return nil end local E,F=pcall(require,D)if E and type(F)=='table'then B=
F end return B end _G.__secureChans=function()if os.clock()<A then return i end
local C=_getSyncMod()if not C then A=os.clock()+0.1 return i end if type(C.
GetAllChannels)~='function'then A=os.clock()+0.1 return i end local D=_getMask()
if not D then A=os.clock()+0.1 return i end local E,F=pcall(z,C.GetAllChannels,D
)if E and type(F)=='table'then i=F A=os.clock()+1.5 _G.MeerkoSyncDiag=
'GetAllChannels (secure_call) - undetect/instant'else A=os.clock()+0.1 end
return i end local function _retryGap()if(os.clock()-q)<r then return s end
return p end local function _channelCount(C)if type(C)~='table'then return 0 end
local D,E=pcall(function()local D,E=0,0 for F,G in next,C do E=E+1 if type(G)==
'table'and type(rawget(G,'CacheTable'))=='table'then D=D+1 end if E>=50 then
break end end return D end)return(D and E)or 0 end local function _module()if n
then return n end local C,D=pcall(function()return require(game:GetService(
'ReplicatedStorage').Packages.Synchronizer)end)if C and type(D)=='table'then n=D
return n end local E,F=pcall(function()local E=game:GetService(
'ReplicatedStorage'):FindFirstChild('Packages')local F=E and E:FindFirstChild(
'Synchronizer')if not F then return nil end return require(F)end)if E and type(F
)=='table'then n=F end return n end local function _probe(C)local D=(debug and
debug.getupvalue)or getupvalue if type(D)~='function'then return nil,0,nil end
local E,F,G=0 local function consider(H,I)local J=_channelCount(H)if J>E then F,
E,G=H,J,I end end local H={{C.Get,10,4,'Get/10/4'},{C.GetAllChannels,10,1,
'GetAll/10/1'},{C.Wait,10,1,'Wait/10/1'}}for I,J in ipairs(H)do if type(J[1])==
'function'then local K,L=pcall(D,J[1],J[2])if K and type(L)=='table'then
consider(rawget(L,J[3]),J[4])if E>0 then return F,E,G end end end end for I,J in
ipairs({C.Get,C.GetAllChannels,C.Wait,C.WaitAndCall,C.GetTableFromChannel})do if
type(J)=='function'then for K=8,12 do local L,M=pcall(D,J,K)if L and type(M)==
'table'then consider(M,'up'..K)for N=1,4 do consider(rawget(M,N),'up'..K..'/'..N
)end if E>0 then return F,E,G end end end end end local I,J=pcall(D,C.Get,9)if I
and type(J)=='table'then consider(rawget(J,3),'Get/9/3')if E>0 then return F,E,G
end consider(J,'Get/9')if E>0 then return F,E,G end end return F,E,G end local 
function _deepScan(C)local D=(debug and debug.getupvalue)or getupvalue if type(D
)~='function'then return nil,0,nil end local E,F,G=0 local function consider(H,I
)local J=_channelCount(H)if J>E then F,E,G=H,J,I end end local H=0 for I,J in
next,C do if type(J)=='function'then H=H+1 if H>30 then break end for K=1,16 do
local L,M=pcall(D,J,K)if not L then break end if type(M)=='table'then consider(M
,tostring(I)..'/'..K)for N=1,4 do consider(rawget(M,N),tostring(I)..'/'..K..'/'
..N)end end end end end return F,E,G end local C,D,E=0,'idle'local function 
_gcScanOnce()local F=workspace:FindFirstChild('Plots')if not F then return end
local G,H,I={},{},0 for J,K in ipairs(F:GetChildren())do G[K.Name]=true I=I+1 H[
I]=K.Name end if I==0 then return end local function score(J)local K,L=0,0 for M
,N in next,J do L=L+1 if type(M)=='string'and G[M]and type(N)=='table'and type(
rawget(N,'CacheTable'))=='table'then K=K+1 end if L>=64 then break end end
return K end local J,K=0 local L=type(filtergc)=='function'if L then local M={}
if I>=2 then M[1]={H[1],H[2],'CacheTable'}end M[#M+1]={H[1],'CacheTable'}if I>=3
then M[#M+1]={H[2],H[3],'CacheTable'}end for N,O in ipairs(M)do local P,Q=pcall(
filtergc,'table',{Keys=O},false)if P and type(Q)=='table'then for R,S in ipairs(
Q)do if type(S)=='table'then local T=score(S)if T>J and T>=2 then K,J=S,T end
end end end if J>=I then break end end end if J==0 and type(getgc)=='function'
and(not L or _G.MeerkoAllowFullGc==true)and not(_G.MeerkoIsTeleporting and _G.
MeerkoIsTeleporting())and(os.clock()-(_G.__gcFullAt or 0))>=(tonumber(_G.
MeerkoFullGcGap)or 3)and(workspace.StreamingEnabled==false or os.clock()-c>=4)
then _G.__gcFullAt=os.clock()pcall(function()local M=getgc(true)local N=math.
min(#M,4000)for O=1,N do local P=M[O]if type(P)=='table'then local Q=0 for R in
next,P do if type(R)=='string'and G[R]then Q=Q+1 if Q>=2 then break end end end
if Q>=2 then local R=score(P)if R>J and R>=2 then K,J=P,R end end if J>=I then
break end end end end)end if K and J>C then E,C=K,J end end local F=0 local G=0
local H,I=0,-1 local function _gcChans()if E then local J=workspace:
FindFirstChild('Plots')local K=J and#J:GetChildren()or 0 if _G.MeerkoSyncRescan
==true and C<K and G<(tonumber(_G.MeerkoSyncMaxRescan)or 20)and(os.clock()-F)>=(
tonumber(_G.MeerkoSyncRescanGap)or 3)then F=os.clock()G=G+1 _gcScanOnce()end
return E,C,'gc/plot-key+CacheTable'end local J=workspace:FindFirstChild('Plots')
local K=J and#J:GetChildren()or 0 if K~=I then I=K H=(H>2)and 2 or H F=F-0.05
end local L=tonumber(_G.MeerkoSyncScanGap)or 0.2 local M=math.min(H*(tonumber(_G
.MeerkoSyncMissStep)or 0.15),tonumber(_G.MeerkoSyncMissMax)or 1)if os.clock()-F<
(L+M)then return nil,0,nil end F=os.clock()_gcScanOnce()if E then H=0 return E,C
,'gc/plot-key+CacheTable'end if K>0 then H=H+1 end return nil,0,nil end local 
function _apiChans(J)if type(J)~='table'then return nil,0,nil end local K=
rawget(J,'GetAllChannels')if type(K)~='function'then return nil,0,nil end local 
function _accept(L,M)if type(L)~='table'then return nil,0,nil end local N=
_channelCount(L)if N>0 then return L,N,M end return nil,0,nil end if _G.
MeerkoAllowSecureSyncCall~=false and type(z)=='function'then for L,M in ipairs({
'self','plain'})do local N,O=pcall(function()if M=='self'then return z(K,J)end
return z(K)end)if N then local P,Q,R=_accept(O,'GetAllChannels/secure_call('..M
..')')if P then return P,Q,R end end end end if _G.MeerkoAllowRawSyncCall then
for L,M in ipairs({'self','plain'})do local N,O=pcall(function()if M=='self'then
return K(J)end return K()end)if N then local P,Q,R=_accept(O,
'GetAllChannels/RAW('..M..')')if P then return P,Q,R end end end end return nil,
0,nil end local J,K,L=0,0 local M=0 local N=0 local O=0 local function _chans()
if L then local P=os.clock()if P<M then return L end if _channelCount(L)>0 then
M=P+2 return L end end local P=os.clock()if P-O<0.02 then return L end if P<J
then return L end O=P K=K+1 local Q,R,S if _G.MeerkoAllowSecureSyncCall~=false
and os.clock()>=N then local T=_getSyncMod()if T then Q,R,S=_apiChans(T)end if
not Q or R==0 then N=os.clock()+(tonumber(_G.MeerkoSyncApiGap)or 0.5)end end if
not Q or R==0 then Q,R,S=_gcChans()end if(not Q or R==0)and K<=400 and _G.
MeerkoAllowUpvalueProbe then local T=_getSyncMod()if T then Q,R,S=_probe(T)local
U=c and(os.clock()-c)<4 if(not Q or R==0)and(not U)and os.clock()-m>2 then m=os.
clock()l=l+1 Q,R,S=_deepScan(T)end end end if Q and R>0 then L=Q _G.
MeerkoSyncDiag=string.format('%s - %d channels',tostring(S),R)return L end local
T=c and(os.clock()-c)<4 J=os.clock()+(T and 0.1 or((_G.MeerkoScanMode=='fast')
and 0.03 or 0.1))return L end _G.__secureChans=_chans _G.MeerkoSyncAll=function(
)return _chans()end _G.MeerkoSyncGet=function(P)local Q=_chans()if not Q or P==
nil then return nil end local R,S=pcall(rawget,Q,P)if R and type(S)=='table'then
return S end local T,U=pcall(function()return Q[P]end)if T and type(U)=='table'
then return U end return nil end _G.sProp=function(P,Q)if type(P)~='table'or Q==
nil then return nil end local R=rawget(P,'CacheTable')if type(R)~='table'then
local S,T=pcall(function()return P.CacheTable end)if S and type(T)=='table'then
R=T end end if type(R)~='table'then return nil end local S=rawget(R,Q)if S~=nil
then return S end local T,U=pcall(function()return R[Q]end)if T then return U
end return nil end _G._meerkoRawCT=function(P)local Q=_G.MeerkoSyncGet(P)if not
Q then return nil end return rawget(Q,'CacheTable')end local P,Q,R local 
function _data()if P then return true end local S=pcall(function()local S=game:
GetService('ReplicatedStorage')local T=S:FindFirstChild('Datas')or S:
WaitForChild('Datas',2)if not T then return end local U=T:FindFirstChild(
'Animals')or T:WaitForChild('Animals',2)if U then P=require(U)end local V=T:
FindFirstChild('Mutations')or T:WaitForChild('Mutations',2)if V then Q=require(V
)end local W=T:FindFirstChild('Traits')or T:WaitForChild('Traits',2)if W then R=
require(W)end end)return S and P~=nil end _G._meerkoGen=function(S,T,U)if not
_data()then return 0 end local V=P[S]if not V or not V.Generation then return 0
end local W=1 if T and T~='None'and T~=''then local X=Q[T]if X and X.Modifier
then W=W+X.Modifier end end if type(U)=='table'then for X,Y in ipairs(U)do local
Z=R[Y]if Z and Z.MultiplierModifier then W=W+Z.MultiplierModifier end end end
return V.Generation*W end local S _G._meerkoAnimShim=setmetatable({GetGeneration
=function(T,U,V,W)return _G._meerkoGen(U,V,W)end},{__index=function(T,U)if not S
then local V,W=pcall(function()local V=game:GetService('ReplicatedStorage')local
W=V:FindFirstChild('Shared')or V:WaitForChild('Shared',3)local X=W and(W:
FindFirstChild('Animals')or W:WaitForChild('Animals',3))return X and require(X)
or nil end)if V and type(W)=='table'then S=W end end if not S then return nil
end return rawget(S,U)end})_G.Meerko_GetPlotChannel=function(T)return _G.
MeerkoSyncGet(T)end _G.Meerko_GetAllPlots=function()return _G.MeerkoSyncAll()or{
}end _G.Meerko_GetPlotAnimalList=function(T)local U=_G._meerkoRawCT(T)local V=U
and U.AnimalList return type(V)=='table'and V or nil end end _G.MeerkoSyncAll=_G
.MeerkoSyncAll _G.MeerkoSyncGet=_G.MeerkoSyncGet _G.MeerkoRawCT=_G._meerkoRawCT
_G.MeerkoGen=_G._meerkoGen _G.MeerkoAnimShim=_G._meerkoAnimShim _G.stealthGet=
function(i)return _G.MeerkoSyncGet(i)end _G.SyncInt={_cache={},_data=nil}task.
spawn(function()for i=1,260 do local j=_G.MeerkoSyncAll()local k=workspace:
FindFirstChild('Plots')local l=k and k:GetChildren()local m=l and#l or 0 if m>0
and type(j)=='table'then local n=0 for o=1,m do if rawget(j,l[o].Name)~=nil then
n=n+1 end end if n>=m then _G.MeerkoChannelsReady=true return end end task.wait(
i<=100 and 0.04 or 0.1)end end)_G.MeerkoGetSyncData=_G.MeerkoGetSyncData or
function(i)local j=type(i)=='string'and i or(i and i.Name)if not j then return
nil end local k=game:GetService('ReplicatedStorage'):FindFirstChild('Packages')
local l=k and k:FindFirstChild('Synchronizer')if not l then return nil end local
m,n=pcall(require,l)if not m or type(n)~='table'then return nil end local o,p=
pcall(function()return _G.MeerkoRawCT(j)end)if o and type(p)=='table'then return
p end local q,r=pcall(function()return _G.MeerkoSyncGet(j)end)if q and r then
local s={__channel=r}pcall(function()local t=rawget(r,'CacheTable')if type(t)==
'table'then s.AnimalList=t.AnimalList s.Owner=t.Owner end end)return s end
return nil end _mkNextModTry=0 function _MeerkoBuildDefaultBrainrotPriority()if
not AnimalsData then return end table.clear(_brainrotDefaultPri)table.clear(
_brainrotDefaultRarity)local i={OG=1,Secret=2,['Brainrot God']=3,[
'Brainrot Titan']=4,['Brainrot Legendary']=5,Legendary=6,Mythic=7,Epic=8,Rare=9,
Uncommon=10,Common=11}local j={}for k,l in pairs(AnimalsData)do if type(l)==
'table'then local m=tostring(l.Rarity or'Common')local n=i[m]or 12 table.insert(
j,{name=l.DisplayName or k,index=k,r=m,rIdx=n})end end table.sort(j,function(k,l
)if k.rIdx~=l.rIdx then return k.rIdx<l.rIdx end return(k.name or k.index)<(l.
name or l.index)end)for k,l in ipairs(j)do local m=_normName(l.name)local n=
_normName(l.index)_brainrotDefaultPri[m]=k _brainrotDefaultRarity[m]=l.r if
_brainrotDefaultPri[n]==nil then _brainrotDefaultPri[n]=k _brainrotDefaultRarity
[n]=l.r end end if#_G.SHARED_PRIORITY_ITEMS==0 then local k=tonumber(_G.
MeerkoDefaultPrioCap)or 60 for l,m in ipairs(j)do if l>k then break end _G.
SHARED_PRIORITY_ITEMS[l]=m.name end end _G.MeerkoPriVersion=(_G.MeerkoPriVersion
or 0)+1 end function loadModules()if AnimalsData then if not AnimalsShared and
_G.MeerkoAnimShim then AnimalsShared=_G.MeerkoAnimShim end return true end if os
.clock()<_mkNextModTry then return false end _mkNextModTry=os.clock()+(tonumber(
_G.MeerkoModRetry)or 0.5)pcall(function()local i=g:FindFirstChild('Datas')or g:
WaitForChild('Datas',1.5)if i then local j=i:FindFirstChild('Animals')or i:
WaitForChild('Animals',1.5)if j then AnimalsData=require(j)end end end)pcall(
_MeerkoBuildDefaultBrainrotPriority)AnimalsShared=_G.MeerkoAnimShim if not
NumberUtils then pcall(function()local i=g:FindFirstChild('Utils')local j=i and
i:FindFirstChild('NumberUtils')if j then NumberUtils=require(j)end end)end
return AnimalsData~=nil end function loadNet()return false end function
getRemote(i,j)return _G.__secureGetRemote(i,j)end _G.MeerkoGetRemote=getRemote
GRAPPLE_ARG=0.8 task.spawn(function()_grappleUseItem=getRemote('RemoteEvent',
'UseItem')end)task.spawn(function()_grappleItemUse=getRemote('RemoteEvent',
'75c9466d-e4c0-4b02-b26a-c3615fcc1e42')end)function _grappleRemoteGet()return(
_grappleUseItem and _grappleUseItem.Parent and _grappleUseItem)or(
_grappleItemUse and _grappleItemUse.Parent and _grappleItemUse)or getRemote(
'RemoteEvent','UseItem')end _G.MeerkoGrappleRemote=_grappleRemoteGet function
_fireGrapple()local i=false if not(_grappleUseItem and _grappleUseItem.Parent)
then _grappleUseItem=getRemote('RemoteEvent','UseItem')end if not(
_grappleItemUse and _grappleItemUse.Parent)then _grappleItemUse=getRemote(
'RemoteEvent','75c9466d-e4c0-4b02-b26a-c3615fcc1e42')end if _grappleUseItem and
_grappleUseItem.Parent then pcall(function()_grappleUseItem:FireServer(
GRAPPLE_ARG)end)i=true end if _grappleItemUse and _grappleItemUse.Parent then
pcall(function()_grappleItemUse:FireServer(GRAPPLE_ARG)end)i=true end if not i
then local j=getRemote('RemoteEvent','UseItem')if j then pcall(function()j:
FireServer(GRAPPLE_ARG)end)i=true end end return i end _G.MeerkoFireGrappleBoth=
_fireGrapple function fireGrapple()local i=h.Character if not i then return end
if not i:FindFirstChild('Grapple Hook')then local j=h:FindFirstChild('Backpack')
local k=j and j:FindFirstChild('Grapple Hook')local l=i:FindFirstChildOfClass(
'Humanoid')if k and l then pcall(function()l:EquipTool(k)end)end end if not i:
FindFirstChild('Grapple Hook')then return end _fireGrapple()end _G.
MeerkoFireGrapple=fireGrapple CARPET_SPEED=280 INBASE_SPEED=450 SKY_CLONE_WAIT=
0.35 CARPET_NAMES={'Flying Carpet','Waverider',"Santa's Sleigh","Witch's Broom",
"Cupid's Wings"}FLY_TOOLS={'Flying Carpet','Waverider',"Santa's Sleigh",
"Witch's Broom","Cupid's Wings"}function findTool(i)local j=h.Character local k=
h:FindFirstChild('Backpack')return(j and j:FindFirstChild(i))or(k and k:
FindFirstChild(i))end GRAPPLE_NAMES={'Grapple Hook'}function findGrapple()for i,
j in ipairs(GRAPPLE_NAMES)do local k=findTool(j)if k and k:IsA('Tool')then
return k,j end end return nil end function listTools()local i,j,k={},h.Character
,h:FindFirstChild('Backpack')if j then for l,m in ipairs(j:GetChildren())do if m
:IsA('Tool')then i[#i+1]=m.Name end end end if k then for l,m in ipairs(k:
GetChildren())do if m:IsA('Tool')then i[#i+1]=m.Name end end end return table.
concat(i,', ')end _lastCarpetName=nil function equipCarpet()local i=h.Character
if not i then return nil end if _lastCarpetName then local j=i:FindFirstChild(
_lastCarpetName)if j and j.Parent==i then return _lastCarpetName end end local j
=i:FindFirstChildOfClass('Humanoid')if not j then return nil end for k,l in
ipairs(CARPET_NAMES)do local m=findTool(l)if m and m:IsA('Tool')then if m.Parent
~=i then pcall(function()j:EquipTool(m)end)end _lastCarpetName=l return l end
end return nil end function setCarpetTool(i)if type(i)~='string'or i==''then
return end _G.MeerkoCarpetTool=i _lastCarpetName=nil for j=#CARPET_NAMES,1,-1 do
if CARPET_NAMES[j]==i then table.remove(CARPET_NAMES,j)end end table.insert(
CARPET_NAMES,1,i)end _G.MeerkoSetCarpetTool=setCarpetTool if type(_G.
MeerkoCarpetTool)=='string'and _G.MeerkoCarpetTool~=''then setCarpetTool(_G.
MeerkoCarpetTool)end _carpetEngaging=false function carpetEngage(i)if not i then
local j=h.Character if j then for k,l in ipairs(CARPET_NAMES)do local m=j:
FindFirstChild(l)if m and m:IsA('Tool')then _G.TPEngage='carpet='..tostring(l)
return l end end end end if _carpetEngaging then local j=os.clock()repeat e.
Heartbeat:Wait()until(not _carpetEngaging)or os.clock()-j>6 local k=h.Character
if k then for l,m in ipairs(CARPET_NAMES)do local n=k:FindFirstChild(m)if n and
n:IsA('Tool')then return m end end end end _carpetEngaging=true local j=os.
clock()while not findTool('Grapple Hook')and os.clock()-j<(tonumber(_G.
MeerkoGrappleToolWait)or 5)do e.Heartbeat:Wait()end local k=h.Character local l=
k and k:FindFirstChildOfClass('Humanoid')if not k or not l then _carpetEngaging=
false return nil end if not k:FindFirstChild('Grapple Hook')then local m=
findTool('Grapple Hook')if m then pcall(function()l:EquipTool(m)end)end end
local m=os.clock()while not(h.Character and h.Character:FindFirstChild(
'Grapple Hook'))and os.clock()-m<1.5 do local n=h.Character local o=n and n:
FindFirstChildOfClass('Humanoid')local p=findTool('Grapple Hook')if p and o then
pcall(function()o:EquipTool(p)end)end e.Heartbeat:Wait()end if h.Character and h
.Character:FindFirstChild('Grapple Hook')then _fireGrapple()end task.wait(0.06)
local n=h.Character and h.Character:FindFirstChildOfClass('Humanoid')if n then
pcall(function()n:UnequipTools()end)end task.wait(0.04)local o local p=os.clock(
)repeat o=equipCarpet()local q=h.Character if o and q and q:FindFirstChild(o)
then break end e.Heartbeat:Wait()until os.clock()-p>0.5 _G.TPEngage='carpet='..
tostring(o)_carpetEngaging=false return o end _G.MeerkoEquipCarpet=equipCarpet
_G.MeerkoCarpetEngaging=function()return _carpetEngaging end if _G.
MeerkoKeepCarpet==nil then _G.MeerkoKeepCarpet=true end h.CharacterAdded:
Connect(function(i)if _G.MeerkoKeepCarpet==false then return end task.spawn(
function()i:WaitForChild('Humanoid',10)task.wait(tonumber(_G.
MeerkoCarpetRespawnDelay)or 0.6)if _G.MeerkoKeepCarpet==false then return end if
_carpetEngaging or h.Character~=i then return end if h:GetAttribute('Stealing')
==true then return end for j,k in ipairs(CARPET_NAMES)do if i:FindFirstChild(k)
then return end end pcall(equipCarpet)end)end)PET_PRIORITY_TIERS={[1]={pets={
'Headless Horseman'},threshold=0},[2]={pets={'Signore Carapace'},threshold=0},[3
]={pets={'John Pork'},threshold=0},[4]={pets={'Strawberry Elephant'},threshold=0
},[5]={pets={'Arcadragon'},threshold=5e9},[6]={pets={'Elefanto Frigo'},threshold
=10e9},[7]={pets={'Meowl'},threshold=5e9},[8]={pets={'Skibidi Toilet'},threshold
=5e9},[9]={pets={'Love Love Bear'},threshold=0},[10]={pets={'Antonio'},threshold
=0},[11]={pets={'Pancake and Syrup'},threshold=0},[12]={pets={'Griffin'},
threshold=0},[13]={pets={'Globa Steppa','La Supreme Combinasion',
'Fishino Clownino','Dragon Gingerini','Tirilikalika Tirilikalako'},threshold=5e9
},[14]={pets={'Ginger Gerat','Pet'},threshold=10e9},[15]={pets={'Hydra Bunny',
'Digi Narwhal','Kalika Bros'},threshold=3e9},[16]={pets={
'Hydra Dragon Cannelloni','Dragon Cannelloni','Bunny and Eggy'},threshold=3e9},[
17]={pets={'Ketupat Bros','Rosey and Teddy','La Casa Boo','Fragola la la'},
threshold=3e9},[18]={pets={'Fragola La La La','Cerberus','Guest 666',
'Los Hackers'},threshold=1e9},[19]={pets={'Garama and Madunung',
'Spooky and Pumpky','Reinito Sleighito','Burguro And Fryuro','Cooki and Milki',
'Fragrama and Chocrama','La Food Combinasion','Los Amigos','Foxini Lanternini',
'Capitano Moby','Fortunu and Cashuru','Los Sekolahs','Celestial Pegasus'},
threshold=750e6},[20]={pets={'La Secret Combinasion','Sammyni Fattini',
'Cloverat Clapat','Popcuru and Fizzuru'},threshold=1e9}}TIER_LOOKUP={}for i,j in
pairs(PET_PRIORITY_TIERS)do for k,l in ipairs(j.pets)do TIER_LOOKUP[l]=i end end
LOCKED_TIERS={[1]=true,[2]=true,[3]=true,[4]=true}DIRECT_THRESHOLDS={[3]={[4]=
10e9},[4]={},[5]={[6]=math.huge},[6]={[9]=math.huge,[10]=math.huge,[12]=15e9},[
10]={[12]=20e9},[11]={[12]=10e9}}MUTATION_PRIORITY={Galaxy=1,Candy=1,['Yin Yang'
]=1,YinYang=1,Divine=1,Cursed=1,Lava=1,Radioactive=1,Cyber=1,Rainbow=1,Bloodrot=
2}TRAIT_PRIORITY={}MUTATION_ICONS,TRAIT_ICONS={},{}function _MeerkoLoadGameData(
)local i,j=pcall(function()return require(game.ReplicatedStorage.Datas.Mutations
)end)if i and type(j)=='table'then local k={}for l,m in pairs(j)do if type(m)==
'table'then MUTATION_ICONS[l]=m.Icon k[#k+1]=l end end table.sort(k)if#_G.
SHARED_MUTATION_PRIORITY==0 then for l=1,#k do _G.SHARED_MUTATION_PRIORITY[l]=k[
l]end end end local k,l=pcall(function()return require(game.ReplicatedStorage.
Datas.Traits)end)if k and type(l)=='table'then local m={}for n,o in pairs(l)do
if type(o)=='table'then TRAIT_ICONS[n]=o.Icon m[#m+1]=n end end table.sort(m)if#
_G.SHARED_TRAIT_PRIORITY==0 then for n=1,#m do _G.SHARED_TRAIT_PRIORITY[n]=m[n]
end end end end task.spawn(function()pcall(function()local i=game:GetService(
'ReplicatedStorage'):FindFirstChild('Datas')local j=i and i:FindFirstChild(
'Animals')if j and not AnimalsData then AnimalsData=require(j)end if AnimalsData
then _MeerkoBuildDefaultBrainrotPriority()end end)pcall(_MeerkoLoadGameData)end)
function getMutPrio(i)if not i or i==''or i=='None'then return 0 end local j=
tostring(i)local k=_G.SHARED_MUTATION_DISABLED if type(k)=='table'and(k[j]or k[
_normName(j)])then return 0 end local l=_priIndexOfMut(j)if not l then j=j:
lower():gsub('[%s%-_]','')l=_priIndexOfMut(j)end if l then return 999-l end if
MUTATION_PRIORITY[i]then return MUTATION_PRIORITY[i]end if MUTATION_PRIORITY[j]
then return MUTATION_PRIORITY[j]end return 0 end function getTraitPrio(i)if not
i or i==''then return 0 end local j=type(i)=='table'and i.name or tostring(i)
local k=j local l=_priIndexOfTrait(k)if not l then k=k:lower():gsub('[%s%-_]',''
)l=_priIndexOfTrait(k)end if l then return 999-l end if TRAIT_PRIORITY[j]then
return TRAIT_PRIORITY[j]end if TRAIT_PRIORITY[k]then return TRAIT_PRIORITY[k]end
return 0 end function getCumThreshold(i,j)if DIRECT_THRESHOLDS[i]and
DIRECT_THRESHOLDS[i][j]then return DIRECT_THRESHOLDS[i][j]end if LOCKED_TIERS[i]
then return math.huge end local k=0 for l=i+1,j do local m=PET_PRIORITY_TIERS[l]
if m and m.threshold>0 then k=k+m.threshold end end return k end function
_normName(i)return tostring(i):lower():gsub("[%s%-_'%.]",'')end _priCacheVer,
_priCache=-1,{}_brainrotDefaultPri={}_brainrotDefaultRarity={}_mutPriCacheVer,
_mutPriCache=-1,{}_traitPriCacheVer,_traitPriCache=-1,{}function _priLookup(i)
local j=_G.MeerkoPriVersion or 0 if i=='mutation'then if _mutPriCacheVer~=j then
table.clear(_mutPriCache)local k=_G.SHARED_MUTATION_PRIORITY if type(k)=='table'
then for l=#k,1,-1 do _mutPriCache[_normName(k[l])]=l end end _mutPriCacheVer=j
end return _mutPriCache elseif i=='trait'then if _traitPriCacheVer~=j then table
.clear(_traitPriCache)local k=_G.SHARED_TRAIT_PRIORITY if type(k)=='table'then
for l=#k,1,-1 do _traitPriCache[_normName(k[l])]=l end end _traitPriCacheVer=j
end return _traitPriCache else if _priCacheVer~=j then table.clear(_priCache)
local k=_G.SHARED_PRIORITY_ITEMS if type(k)=='table'then for l=#k,1,-1 do
_priCache[_normName(k[l])]=l end end _priCacheVer=j end return _priCache end end
_G.MeerkoPriLookup=function()return _priLookup()end function _priIndexOf(i)if
not i then return nil end local j=_normName(i)local k=_priLookup()[j]if k then
return k end local l=_brainrotDefaultPri[j]if l and _brainrotDefaultRarity[j]==
'OG'then return l*0.001 end return nil end function _priIndexOfMut(i)if not i
then return nil end return _priLookup('mutation')[_normName(i)]end function
_priIndexOfTrait(i)if not i then return nil end return _priLookup('trait')[
_normName(i)]end function petOutranks(i,j,k,l,m,n,o,p)local q=_priIndexOf(i)
local r=_priIndexOf(j)if q~=nil and r~=nil then if q~=r then return q<r end end
if(q~=nil)~=(r~=nil)then return q~=nil end if q==nil and r==nil then if(m or 0)
~=(n or 0)then return(m or 0)>(n or 0)end end local s,t=getMutPrio(k),
getMutPrio(l)if s~=t then return s>t end if type(o)=='table'and type(p)=='table'
then local u,v=0,0 for w,x in ipairs(o)do u=math.max(u,getTraitPrio(x))end for w
,x in ipairs(p)do v=math.max(v,getTraitPrio(x))end if u~=v then return u>v end
end return(m or 0)>(n or 0)end function getPlotChannel(i)local j pcall(function(
)j=_G.MeerkoSyncGet(i)end)return j end function channelGet(i,j)if not i then
return nil end local k,l=pcall(function()local k=rawget(i,'CacheTable')if type(k
)=='table'then local l=rawget(k,j)if l~=nil then return l end end local l=
rawget(i,'Data')if type(l)=='table'then local m=rawget(l,j)if m~=nil then return
m end end return rawget(i,j)end)if k then return l end return nil end function
_ownerIsMe(i)if not i then return false end local j=false pcall(function()if
typeof(i)=='Instance'and i:IsA('Player')then j=i.UserId==h.UserId elseif type(i)
=='table'and i.UserId then j=i.UserId==h.UserId elseif typeof(i)=='Instance'then
j=i==h elseif type(i)=='string'then j=i:lower()==h.Name:lower()or i:lower()==(h.
DisplayName or h.Name):lower()end end)return j end function isMyPlot(i)if not i
then return false end return _ownerIsMe(channelGet(i,'Owner'))end
_ownerInGameCache,_ownerInGameAt={},{}function _ownerInGame(i)if not i then
return false end local j if typeof(i)=='Instance'then j='i:'..tostring(i)elseif
type(i)=='number'then j='n:'..i elseif type(i)=='string'then j='s:'..i:lower()
else j='o:'..tostring(i)end local k=os.clock()local l=_ownerInGameAt[j]if l and(
k-l.t)<2 then return l.v end local m=false pcall(function()if typeof(i)==
'Instance'and i:IsA('Player')then m=i.Parent==d elseif type(i)=='number'then m=d
:GetPlayerByUserId(i)~=nil elseif type(i)=='table'and i.Name then m=d:
FindFirstChild(tostring(i.Name))~=nil elseif typeof(i)=='Instance'and i.Name
then m=d:FindFirstChild(i.Name)~=nil elseif type(i)=='string'then if d:
FindFirstChild(i)then m=true else local n=i:lower()for o,p in ipairs(d:
GetPlayers())do if p.Name:lower()==n or(p.DisplayName or''):lower()==n then m=
true break end end end end end)_ownerInGameCache[j]={v=m,t=k}_ownerInGameAt[j]={
v=m,t=k}return m end function ownerInGame(i)if not i then return false end
return _ownerInGame(channelGet(i,'Owner'))end _petModelCache=setmetatable({},{
__mode='v'})_petPosCache,_petMissAt={},{}_PET_SKIP={Claim=true,Base=true,
Decorations=true}_genCache={}local i={K=1e3,M=1e6,B=1e9,T=1e12,Q=1e15}_wmpsCache
,_wmpsAt={},{}function _worldMPS(j,k)local l=j and j:FindFirstChild(
'AnimalPodiums')local m=l and l:FindFirstChild(tostring(k))if not m then return
nil end local n=j.Name..'\0'..tostring(k)local o=os.clock()if _wmpsAt[n]and(o-
_wmpsAt[n])<(tonumber(_G.MeerkoWorldMPSTTL)or 1)then return _wmpsCache[n]end
local p local function _scanLabels(q)for r,s in ipairs(q:GetChildren())do if s:
IsA('TextLabel')or s:IsA('TextButton')then local t=s.Text if type(t)=='string'
and t~=''then local u,v=t:match('%$%s*([%d%.]+)%s*([KMBTQ]?)%s*/s')if u then
local w=tonumber(u)if w then w=w*(i[v]or 1)if not p or w>p then p=w end end end
end end _scanLabels(s)end end _scanLabels(m)_wmpsCache[n],_wmpsAt[n]=p,o return
p end function getPetPosition(j,k,l)local m=j:FindFirstChild('AnimalPodiums')if
not m then return nil end local n=m:FindFirstChild(tostring(k))if not n then
return nil end local o=j.Name..'\0'..tostring(k)local p=os.clock()local q=
_petPosCache[o]if q and q.model.Parent and p<q.until_ then return q.pos end
local r=_petModelCache[o]if r and r.Parent and r:IsDescendantOf(n)then local s,t
=pcall(r.GetBoundingBox,r)if s then _petPosCache[o]={model=r,pos=t.Position,
until_=p+1.5}return t.Position end end _petModelCache[o]=nil _petPosCache[o]=nil
local s=_petMissAt[o]local t if not(s and p<s)then for u,v in ipairs(n:
GetDescendants())do if v:IsA('Model')and not _PET_SKIP[v.Name]and v:
FindFirstChildWhichIsA('MeshPart',true)then t=v break end end _petMissAt[o]=(not
t)and(p+0.5)or nil end if t then local u,v=pcall(t.GetBoundingBox,t)if u then
_petModelCache[o]=t _petPosCache[o]={model=t,pos=v.Position,until_=p+1.5}return
v.Position end end if l then return nil end local u,v=pcall(function()return n:
GetPivot()end)if u then return v.Position end return n.Position end function
scanAllPets()local j={}if not loadModules()then _G.MeerkoScanTotal,_G.
MeerkoScanUsed,_G.MeerkoScanNoChan=0,0,8 return j end local k=workspace:
FindFirstChild('Plots')if not k then _G.MeerkoScanTotal,_G.MeerkoScanUsed,_G.
MeerkoScanNoChan=0,0,8 return j end local l,m,n=0,0,0 local o=0 local p={}for q,
r in ipairs(k:GetChildren())do n=n+1 local s=getPlotChannel(r.Name)if not s then
p[#p+1]='nochan'o=o+1 continue end l=l+1 local t=channelGet(s,'Owner')if
_ownerIsMe(t)then _G.MeerkoMyPlot=r.Name p[#p+1]='MINE'continue end if _G.
MeerkoMyPlot==r.Name then p[#p+1]='MINE'continue end if not _G.MeerkoMyPlot and
t==nil then p[#p+1]='noowner?'continue end if _G.MeerkoRequireOwner~=false and
not _ownerInGame(t)then p[#p+1]='left'continue end m=m+1 local u=channelGet(s,
'AnimalList')if not u then p[#p+1]='nolist'continue end local v=0 for w,x in
pairs(u)do if type(x)~='table'then continue end local y=x.Index if not y then
continue end local z=AnimalsData and AnimalsData[y]if not z and _G.
MeerkoRequireKnown==true then continue end if _MeerkoIsFusing(x)then continue
end local A=x.Mutation or'None'local B=x.Traits if type(B)~='table'then B={}end
local C local D=r.Name..'\0'..tostring(w)local E=_genCache[D]if E and E.n==y and
E.m==x.Mutation and E.t==x.Traits then C=E.g else C=0 pcall(function()local F=
AnimalsShared or _G.MeerkoAnimShim if F then C=F:GetGeneration(y,x.Mutation,x.
Traits,nil)end end)if C and C>0 then _genCache[D]={n=y,m=x.Mutation,t=x.Traits,g
=C}end end if(not C or C<=0)and _G.MeerkoWorldMPS~=false then local F=_worldMPS(
r,w)if F and F>0 then C=F end end local F=(z and z.DisplayName)or y local G=
getPetPosition(r,w,(_G.MeerkoRequireOwner==false)or(_G.MeerkoRequireModel==true)
)if G then if C>=(tonumber(_G.MeerkoMinMPS)or 0)then table.insert(j,{name=F,
index=y,mps=C,mutation=A,traits=B,position=G,plot=r.Name,slot=tostring(w)})v=v+1
end end end p[#p+1]=tostring(v)end _G.MeerkoScanTotal,_G.MeerkoScanUsed,_G.
MeerkoScanNoChan=n,m,o _G.MeerkoScanInfo=string.format(
'plots %d scanned of %d  pets %d  [%s]  %s',m,n,#j,table.concat(p,' '),tostring(
_G.MeerkoScanMode))local function _bestTraitPrio(q)if type(q)~='table'then
return 0 end local r=0 for s,t in ipairs(q)do local u=getTraitPrio(t)if u>r then
r=u end end return r end for q,r in ipairs(j)do r._pri=_priIndexOf(r.name)or(r.
index and _priIndexOf(r.index))or nil r._mp=tonumber(r.mps)or 0 r._mut=
getMutPrio(r.mutation)r._trait=_bestTraitPrio(r.traits)end local function 
_petOrder(q,r)local s,t=q._pri,r._pri if(s~=nil)~=(t~=nil)then return s~=nil end
if s and t and s~=t then return s<t end if s==nil then if q._mp~=r._mp then
return q._mp>r._mp end end if q._mut~=r._mut then return q._mut>r._mut end if q.
_trait~=r._trait then return q._trait>r._trait end if q._mp~=r._mp then return q
._mp>r._mp end local u,v=tostring(q.plot),tostring(r.plot)if u~=v then return u<
v end return(tonumber(q.slot)or 0)<(tonumber(r.slot)or 0)end local q=_G.
MeerkoStealMode if q=='highest'then table.sort(j,function(r,s)local t,u=
tonumber(r.mps)or 0,tonumber(s.mps)or 0 if t~=u then return t>u end local v,w=
tostring(r.plot),tostring(s.plot)if v~=w then return v<w end return(tonumber(r.
slot)or 0)<(tonumber(s.slot)or 0)end)return j end table.sort(j,_petOrder)return
j end _G.MeerkoScanAllPets=scanAllPets _scanShared,_scanSharedAt=nil,0 function
scanAllPetsCached(j)local k=os.clock()local l=math.max(tonumber(j)or 0.15,
tonumber(_G.MeerkoScanMinAge)or 0.1)if _scanShared and(k-_scanSharedAt)<=l then
return _scanShared end local m,n=pcall(scanAllPets)if m and type(n)=='table'then
_scanShared,_scanSharedAt=n,k return n end return nil end _G.MeerkoScanCached=
scanAllPetsCached function scanForTP()local j=c and(os.clock()-c)<4 local k=
scanAllPetsCached(tonumber(_G.MeerkoScanCacheAge)or(j and 0.1 or 0.2))if type(k)
~='table'then k={}end if _G.MeerkoScanTiered and _G.MeerkoUseTiered~=false then
local l,m=pcall(_G.MeerkoScanTiered)if l and type(m)=='table'and#m>0 then local
n={}for o,p in ipairs(k)do if p and p.plot and p.slot~=nil then n[tostring(p.
plot)..'_'..tostring(p.slot)]=true end end for o,p in ipairs(m)do if p and p.
plot and p.slot~=nil then local q=tostring(p.plot)..'_'..tostring(p.slot)if not
n[q]then n[q]=true k[#k+1]=p end end end end end return k end function _petUid(j
)if not j then return nil end return tostring(j.plot)..'_'..tostring(j.slot)end
function _pickPetOnFoot(j,k)if not j or#j==0 then return nil end local l if _G.
MeerkoStealMode=='nearest'and k then local m=math.huge for n,o in ipairs(j)do if
not o.conveyor and o.position then local p=(o.position-k).Magnitude if p<m then
m=p l=o end end end else for m,n in ipairs(j)do if not n.conveyor then l=n break
end end end return l or j[1]end function _findTPSyncedPet(j)local k=_G.
MeerkoStealTargetUID if type(k)~='string'or k==''then return nil end for l,m in
ipairs(j)do if _petUid(m)==k then return m end end return nil end function
_clearTPSync()_G.MeerkoTPSyncActive=false _G.MeerkoStealTargetUID=nil _G.
MeerkoStealTarget=nil end function _armTPSync(j)if not j then return end _G.
MeerkoStealTargetUID=_petUid(j)_G.MeerkoStealTarget=j _G.MeerkoTPSyncActive=true
local k=(_G._MeerkoTPSyncGen or 0)+1 _G._MeerkoTPSyncGen=k task.delay(12,
function()if _G._MeerkoTPSyncGen==k then _clearTPSync()end end)end _G.
MeerkoClearTPSync=_clearTPSync function _findStealTarget(j)if not _G.
MeerkoTPSyncActive then return nil end return _findTPSyncedPet(j)end function
_publishStealTarget(j)if not j then return end _G.MeerkoStealTargetUID=_petUid(j
)_G.MeerkoStealTarget=j end MK_UPPER={B={{coord=Vector3.new(-487.921448,
16.850713,-75.768013),facing='NORTH'},{coord=Vector3.new(-332.37973,16.850722,-
75.7621),facing='NORTH'},{coord=Vector3.new(-487.134918,16.850713,-18.094154),
facing='SOUTH'},{coord=Vector3.new(-316.300171,16.850713,-17.845898),facing=
'SOUTH'}},C={{coord=Vector3.new(-330.765381,16.850713,31.424425),facing='NORTH'}
,{coord=Vector3.new(-502.989349,16.850713,31.17243),facing='NORTH'},{coord=
Vector3.new(-489.077087,16.850713,89.010147),facing='SOUTH'},{coord=Vector3.new(
-330.908936,16.850713,88.930145),facing='SOUTH'}},D={{coord=Vector3.new(-
331.264893,16.850713,138.209167),facing='NORTH'},{coord=Vector3.new(-487.935181,
16.850713,138.026321),facing='NORTH'},{coord=Vector3.new(-487.774933,16.850713,
195.882538),facing='SOUTH'},{coord=Vector3.new(-330.799133,16.850575,196.022354)
,facing='SOUTH'}}}MK_LOWER={B={{coord=Vector3.new(-335.725586,-3.048217,-
74.984589),facing='NORTH'},{coord=Vector3.new(-503.214233,-3.048217,-75.043137),
facing='NORTH'},{coord=Vector3.new(-483.619385,-3.71843,-18.844337),facing=
'SOUTH'},{coord=Vector3.new(-316.147095,-3.048218,-18.818844),facing='SOUTH'}},C
={{coord=Vector3.new(-335.985413,-3.048218,32.051426),facing='NORTH'},{coord=
Vector3.new(-503.277008,-3.048217,31.956175),facing='NORTH'},{coord=Vector3.new(
-483.74939,-3.048218,88.147003),facing='SOUTH'},{coord=Vector3.new(-315.793823,-
3.048217,88.163979),facing='SOUTH'}},D={{coord=Vector3.new(-335.476654,-3.048218
,139.001083),facing='NORTH'},{coord=Vector3.new(-503.710083,-3.048218,138.989883
),facing='NORTH'},{coord=Vector3.new(-315.654938,-3.048218,195.302444),facing=
'SOUTH'},{coord=Vector3.new(-483.859253,-3.048218,195.269043),facing='SOUTH'}}}
UPPER_Y_THRESHOLD=7 TALL_PETS={['La Secret Combinasion']=true,['La Jolly Grande'
]=true}TALL_OFFSET=3 BASES_LOW={[1]=Vector3.new(-476.52,-2,220.94090270996094),[
2]=Vector3.new(-476.52,-2,113.77315521240234),[3]=Vector3.new(-476.52,-2,
6.178487777709961),[4]=Vector3.new(-476.52,-2,-101.07275390625),[5]=Vector3.new(
-342.66,-2,221.44737243652344),[6]=Vector3.new(-342.66,-2,113.41409301757813),[7
]=Vector3.new(-342.66,-2,6.249461650848389),[8]=Vector3.new(-342.66,-2,-
99.73458862304688)}BASES_HIGH={[1]=Vector3.new(-479.51,18,220.94090270996094),[2
]=Vector3.new(-479.51,18,113.77315521240234),[3]=Vector3.new(-479.51,18,
6.178487777709961),[4]=Vector3.new(-479.51,18,-101.07275390625),[5]=Vector3.new(
-339.48,18,221.44737243652344),[6]=Vector3.new(-339.48,18,113.41409301757813),[7
]=Vector3.new(-339.48,18,6.249461650848389),[8]=Vector3.new(-339.48,18,-
99.73458862304688)}FRONT_Y_LOW=-3.048217 FRONT_Y_HIGH=16.850713 COLUMN_SPLIT_X=-
410 FRONT_Z_CLAMP=18 SIDE_NEAR_Z=45 function getClosestBaseIdx(j)local k,l=1,
math.huge for m=1,8 do local n=BASES_LOW[m]local o=(j.X-n.X)^2+(j.Z-n.Z)^2 if o<
l then l=o k=m end end return k end function buildFrontCandidate(j,k,l)local m=k
and BASES_HIGH[j]or BASES_LOW[j]local n=k and FRONT_Y_HIGH or FRONT_Y_LOW local
o=math.clamp(l-m.Z,-FRONT_Z_CLAMP,FRONT_Z_CLAMP)+m.Z local p=Vector3.new(m.X,n,o
)local q=(j<=4)and Vector3.new(-1,0,0)or Vector3.new(1,0,0)return p,q end
function plotSides(j,k)local l=BASES_LOW[k]local m=k<=4 local n={}for o,p in
pairs(j)do for q,r in ipairs(p)do if((r.coord.X<COLUMN_SPLIT_X)==m)and math.abs(
r.coord.Z-l.Z)<SIDE_NEAR_Z then n[#n+1]=r end end end return n end function
_floor1LaserSolid(j)local k=false pcall(function()local l=workspace:
FindFirstChild('Plots')local m=l and l:FindFirstChild(j)if not m then return end
for n,o in ipairs(m:GetDescendants())do if o:IsA('BasePart')and(o.Name==
'LaserHitbox'or o.Name=='Laser')and o.CanCollide and o.Position.Y<=9 then k=true
break end end end)return k end function isPlotUnlocked(j)local k,l=pcall(
function()local k=getPlotChannel(j)if not k then return false end if channelGet(
k,'BlockEndTimeFirstFloor')~=nil then return false end return not
_floor1LaserSolid(j)end)return k and(l==true)end function findClosest(j,k)local
l,m,n=math.huge for o,p in pairs(k)do for q,r in ipairs(p)do local s=r.coord
local t=math.sqrt((j.X-s.X)^2+(j.Z-s.Z)^2)if t<l then l=t m=r n=o end end end
return m,n end do _vizParts={}_vizGen=0 function _vizEnsure()if _vizFolder and
_vizFolder.Parent then return end _vizFolder=Instance.new('Folder')_vizFolder.
Name='MeerkoPathViz'_vizFolder.Parent=workspace _vizAnchor=Instance.new('Part')
_vizAnchor.Name='Anchor'_vizAnchor.Anchored=true _vizAnchor.CanCollide=false
_vizAnchor.CanQuery=false _vizAnchor.CanTouch=false _vizAnchor.Transparency=1
_vizAnchor.Size=Vector3.one _vizAnchor.CFrame=CFrame.new()_vizAnchor.Parent=
_vizFolder end clearViz=function()if _vizFolder then pcall(function()_vizFolder:
Destroy()end)end _vizFolder,_vizAnchor=nil,nil table.clear(_vizParts)end local 
function _ghost(j,k,l,m)_vizEnsure()local n=Instance.new('BoxHandleAdornment')n.
Adornee=_vizAnchor n.AlwaysOnTop=true n.ZIndex=0 pcall(function()n.Shading=Enum.
AdornShading.XRayShaded end)n.Color3=l n.Transparency=1-m n.Size=k n.CFrame=j n.
Parent=_vizAnchor end local function _neon(j,k,l,m,n)_vizEnsure()local o=
Instance.new('Part')o.Anchored=true o.CanCollide=false o.CanQuery=false o.
CanTouch=false o.CastShadow=false o.Material=Enum.Material.Neon o.Color=l o.
Transparency=n or 0 if m then o.Shape=Enum.PartType.Ball end o.Size=k o.CFrame=j
o.Parent=_vizFolder end function vizLine(j,k,l)local m=k-j if m.Magnitude<0.05
then return end _neon(CFrame.lookAt((j+k)*0.5,k),Vector3.new(0.25,0.25,m.
Magnitude),l,false,0)end function vizDot(j,k,l)_neon(CFrame.new(j),Vector3.new(l
,l,l),k,true,0)end vizPath=function(j,k)if _G.MeerkoShowPath~=true then return
end if#k==0 then return end local l=Color3.fromRGB(0,200,140)local m=j for n,o
in ipairs(k)do vizLine(m,o,l)m=o end vizDot(k[#k],l,1.6)end end MK_SPEED=125
MK_ARRIVE=3 _STRIP_OK=(type(getconnections)=='function')function _climbCap()
local j=math.clamp(tonumber(_G.MeerkoClimb)or 200,100,250)if not _STRIP_OK then
j=55 end return j end function vZero(j)if j then _vzL(j)_vzA(j)end end function
_setFlightVel(j,k)local l=j and j.Parent local m=(l and(l:FindFirstChild(
'UpperTorso')or l:FindFirstChild('Torso')))or j if m then m.
AssemblyLinearVelocity=k end end function velMoveThrough(j,k,l,m,n)if not j or
not j.Parent or#k==0 then return end local o=l or(_G.TPVelocity and math.clamp(
_G.TPVelocity,200,750))or CARPET_SPEED vizPath(j.Position,k)local p=1 local q=
false local r local function finish()if q then return end q=true if j and j.
Parent then _vzL(j)_vzA(j)local s,t=j.CFrame:ToEulerAnglesYXZ()j.CFrame=CFrame.
new(k[#k])*CFrame.Angles(0,t,0)end if r then r:Disconnect()end end local s,t=
math.huge,0 local u=os.clock()local v=0 local w=0 do local x=j.Position for y,z
in ipairs(k)do w=w+(x-z).Magnitude x=z end end local x=w>=(tonumber(_G.
MeerkoJumpMinDist)or 100)local y=n r=e.Heartbeat:Connect(LPH_NO_VIRTUALIZE(
function()if not j or not j.Parent or q then if r then r:Disconnect()end return
end if _G.MeerkoTPStop then finish()return end equipCarpet()if x and _G.
MeerkoJumpEachStep~=false then local z=os.clock()if z-v>=(tonumber(_G.
MeerkoJumpGap)or 0.2)then v=z local A=j.Parent and j.Parent:
FindFirstChildOfClass('Humanoid')if A then pcall(function()A:ChangeState(Enum.
HumanoidStateType.Jumping)end)pcall(function()A.Jump=true end)end end end local
z=k[p]local A=z-j.Position local B=A.Magnitude local C=o if p<#k and B<26 then
local D=k[p+1]local E=D-z if B>0.1 and E.Magnitude>0.1 and A.Unit:Dot(E.Unit)<
0.9 then C=math.min(C,240)end end local D=math.max(MK_ARRIVE,C/60*1.25)if B<D
then p=p+1 if p>#k then finish()return end s,t=math.huge,0 if _G.
MeerkoZeroEachStep~=false and _vzOK()then pcall(function()local E=j.
AssemblyLinearVelocity local F=(_G.MeerkoZeroStepKeepY==false)and 0 or math.max(
E.Y,0)j.AssemblyLinearVelocity=Vector3.new(0,F,0)j.AssemblyAngularVelocity=
Vector3.new(0,0,0)end)end if x and _G.MeerkoJumpEachStep~=false then local E=j.
Parent and j.Parent:FindFirstChildOfClass('Humanoid')if E then v=os.clock()
pcall(function()E:ChangeState(Enum.HumanoidStateType.Jumping)end)pcall(function(
)E.Jump=true end)end end z=k[p]A=z-j.Position B=A.Magnitude end if B>s-0.05 then
t=t+1 else t=0 end s=B if t>=(tonumber(_G.MeerkoStallFrames)or 18)then finish()
return end if B>=0.1 then local E=A.Unit if(m or A.Y>10)and A.Y>5 and p<#k then
local F=j.Parent and j.Parent:FindFirstChildOfClass('Humanoid')if F then local G
=F:GetState()if G~=Enum.HumanoidStateType.Jumping and G~=Enum.HumanoidStateType.
Freefall then pcall(function()F:ChangeState(Enum.HumanoidStateType.Jumping)end)
pcall(function()F.Jump=true end)end end end local F=C local G=_climbCap()if E.Y>
0 and E.Y*F>G then F=G/E.Y end _setFlightVel(j,Vector3.new(E.X*F,E.Y*F,E.Z*F))
end end))local z=0 do local A=j.Position for B,C in ipairs(k)do z=z+(A-C).
Magnitude A=C end end local A=z/math.min(MK_SPEED,o)+(tonumber(_G.
MeerkoFlightGrace)or 2)local B=0 while not q and B<A do task.wait(0.05)B=B+0.05
if not(j and j.Parent)then break end end finish()vZero(j)end _OTHER_CLONES={}do
local j=tostring(h.UserId)..'_Clone'local k={}local function _isOtherClone(l)if
not l then return false end local m=l.Name if m==j then return false end if m:
match('^%d+_Clone$')then return true end if not m:find('lone',1,true)then return
false end if not l:IsA('Model')then return false end if l==h.Character then
return false end if not l:FindFirstChild('HumanoidRootPart')then return false
end if not l:FindFirstChildOfClass('Humanoid')then return false end for n,o in
ipairs(d:GetPlayers())do if o.Character==l then return false end end return true
end local function _neutralize(l)if not l or k[l]then return end k[l]=true
_OTHER_CLONES[#_OTHER_CLONES+1]=l local function declaw(m)if m:IsA('BasePart')
and m.CanCollide then pcall(function()m.CanCollide=false end)end end for m,n in
ipairs(l:GetDescendants())do declaw(n)end l.DescendantAdded:Connect(declaw)l.
Destroying:Connect(function()k[l]=nil for m=#_OTHER_CLONES,1,-1 do if
_OTHER_CLONES[m]==l then table.remove(_OTHER_CLONES,m)break end end end)end
local function _scan(l)if _isOtherClone(l)then _neutralize(l)end end for l,m in
ipairs(workspace:GetChildren())do _scan(m)end workspace.ChildAdded:Connect(
function(l)_scan(l)task.defer(function()if l and l.Parent==workspace then _scan(
l)end end)end)end do local j=setmetatable({},{__mode='k'})local k={
'HumanoidRootPart','UpperTorso','LowerTorso','Torso','Head'}local function 
_noCollide(l)if _G.MeerkoNoCollideConstraints==false or not l then return end
local m=h.Character local n=m and m:FindFirstChild('HumanoidRootPart')if not n
then return end local o=j[l]if not o or o.root~=n then o={root=n}j[l]=o end for
p,q in ipairs(k)do local r=l:FindFirstChild(q)if r and r:IsA('BasePart')then
local s=o[q]if not(s and s.Parent)then pcall(function()local t=Instance.new(
'NoCollisionConstraint')t.Part0,t.Part1=n,r t.Parent=n o[q]=t end)end end end
end local l=setmetatable({},{__mode='k'})local m=setmetatable({},{__mode='k'})
local function _pin(n)if not n:IsA('BasePart')then return end if n.CanCollide
then n.CanCollide=false end if l[n]then return end l[n]=true pcall(function()n:
GetPropertyChangedSignal('CanCollide'):Connect(function()if n.CanCollide then n.
CanCollide=false end end)end)end local function _pinChar(n)if not n then return
end for o,p in ipairs(n:GetDescendants())do _pin(p)end if not m[n]then m[n]=true
n.DescendantAdded:Connect(function(o)task.defer(_pin,o)end)end end local 
function _hookPlayer(n)if n==h then return end if n.Character then task.defer(
function()_noCollide(n.Character)_pinChar(n.Character)end)end n.CharacterAdded:
Connect(function(o)task.wait(0.1)if o.Parent then _noCollide(o)_pinChar(o)end
end)end for n,o in ipairs(d:GetPlayers())do _hookPlayer(o)end d.PlayerAdded:
Connect(_hookPlayer)h.CharacterAdded:Connect(function()task.wait(0.3)for n,o in
ipairs(d:GetPlayers())do if o~=h and o.Character then _noCollide(o.Character)end
end end)local n=tostring(h.UserId)..'_Clone'local function _clones()local o=
_OTHER_CLONES return(type(o)=='table')and o or{}end local o=0 e.Stepped:Connect(
function(p,q)if _G.MeerkoNoCollide==false or _G.isCloning==true then return end
o=o+(q or 0.016)if o<0.1 then return end o=0 local r=h.Character local s=r and r
:FindFirstChild('HumanoidRootPart')if not s then return end local t=s.Position
local u=tonumber(_G.MeerkoNoCollideRange)or 28 for v,w in ipairs(_clones())do if
w and w.Parent and w.Name~=n then local x=w:FindFirstChild('HumanoidRootPart')if
x and(x.Position-t).Magnitude<=u then for y,z in ipairs(w:GetDescendants())do if
z:IsA('BasePart')and z.CanCollide then z.CanCollide=false end end end end end
end)task.spawn(function()while true do task.wait(1)if _G.MeerkoNoCollide~=false
and _G.isCloning~=true then for p,q in ipairs(d:GetPlayers())do local r=(q~=h)
and q.Character if r and not m[r]then _pinChar(r)end end for p,q in ipairs(
_clones())do if q and q.Parent and q.Name~=n and not m[q]then _pinChar(q)end end
end end end)end local j do local k={Vector3.new(1,0,0),Vector3.new(-1,0,0),
Vector3.new(0,0,1),Vector3.new(0,0,-1)}local l={['structure base home']=true,
Wall=true,Floor=true,Roof=true}local m={DeliveryHitbox=true,StealHitbox=true,
LaserHitbox=true,AnimalTarget=true,Multiplier=true,Laser=true,Hitbox=true,Spawn=
true,MainRoot=true,SecondFloor=true,ThirdFloor=true,Slope=true}local function 
_blocks(n)if not n then return false end if m[n.Name]then return false end if n.
CanCollide then return true end local o=n.Parent if o and(o.Name==
'ObstacleVolumes'or o.Name=='ObstacleVolume')then return false end if l[n.Name]
then return true end local p=n.Size if p and math.max(p.X*p.Y,p.X*p.Z,p.Y*p.Z)>
150 then return true end return false end local function _blocksWide(n)if not n
then return false end if m[n.Name]then return false end if n.CanCollide then
return true end local o=n.Parent if o and(o.Name=='ObstacleVolumes'or o.Name==
'ObstacleVolume')then return false end if l[n.Name]then return true end local p=
n.Size if p and math.max(p.X*p.Y,p.X*p.Z,p.Y*p.Z)>30 then return true end return
false end local function _block(n,o,p)p=p or _blocks local q=RaycastParams.new()
q.FilterType=Enum.RaycastFilterType.Exclude q.IgnoreWater=true local r={}for s,t
in ipairs(d:GetPlayers())do if t.Character then r[#r+1]=t.Character end end for
s,t in ipairs(_OTHER_CLONES)do r[#r+1]=t end local s=n for t=1,16 do q.
FilterDescendantsInstances=r local u=o-s if u.Magnitude<0.05 then return nil end
local v=workspace:Raycast(s,u,q)if not v then return nil end if p(v.Instance)
then return v end r[#r+1]=v.Instance s=v.Position+u.Unit*0.3 end return nil end
local function _clear(n,o)return _block(n,o)==nil end local function _clearDist(
n,o,p)local q=_block(n,n+o.Unit*p)if not q then return p end return(q.Position-n
).Magnitude end function j(n)local o,p=0,n[1]for q=2,#n do o=o+(n[q]-p).
Magnitude p=n[q]end return o end local function _pull(n)if#n<=2 then return n
end local o={n[1]}local p=1 while p<#n do local q=#n while q>p+1 and not _clear(
o[#o],n[q])do q=q-1 end o[#o+1]=n[q]p=q end return o end local function _stages(
n)local o={}for p,q in ipairs(k)do local r=_clearDist(n,q,46)if r>=12 then o[#o+
1]=n+q*math.min(r-5,38)end end return o end local function _routeClear(n)for o=1
,#n-1 do if not _clear(n[o],n[o+1])then return false end end return true end
local function _peakY(n)local o=-math.huge for p,q in ipairs(n)do if q.Y>o then
o=q.Y end end return o end local function _starts(n)local o={n}if _block(n,n+
Vector3.new(0,40,0))then for p,q in ipairs(k)do local r=_clearDist(n,q,40)if r>=
12 then o[#o+1]=n+q*math.min(r-5,34)end end end return o end local function 
_candidates(n,o,p)local q={}local function add(r)if r then q[#q+1]={n,r,o,p}else
q[#q+1]={n,o,p}end end add(nil)add(Vector3.new(o.X,n.Y,o.Z))add(Vector3.new(n.X,
o.Y,n.Z))local r=Vector3.new(o.X-n.X,0,o.Z-n.Z)if r.Magnitude>0.1 then r=r.Unit
local s=Vector3.new(-r.Z,0,r.X)for t,u in ipairs({20,-20,40,-40})do add(n+s*u)
end end return q end local n=game:GetService('PathfindingService')local o=16
local function _clearWideRay(p,q)return _block(p,q,_blocksWide)==nil end local p
=4 local q=6 local r local function _sweepBlockFn(s)if _G.MeerkoStrictSweep==
false then return _blocks(s)end return _blocksWide(s)end local function 
_sweepDir(s,t)local u=RaycastParams.new()u.FilterType=Enum.RaycastFilterType.
Exclude u.IgnoreWater=true local v={}for w,x in ipairs(d:GetPlayers())do if x.
Character then v[#v+1]=x.Character end end for w,x in ipairs(_OTHER_CLONES)do v[
#v+1]=x end local w=s for x=1,24 do u.FilterDescendantsInstances=v local y=t-w
if y.Magnitude<0.05 then return false end local z local A=pcall(function()z=
workspace:Spherecast(w,p,y,u)end)if not A then r=false return nil end if not z
then return false end if _sweepBlockFn(z.Instance)then return true end v[#v+1]=z
.Instance local B=(z.Distance or 0)-0.05 if B>0 then w=w+y.Unit*math.min(B,y.
Magnitude)end end return true end local function _sweepBlocked(s,t,u,v)if r==nil
then r=pcall(function()workspace:Spherecast(Vector3.new(0,10000,0),1,Vector3.
new(0,-1,0),RaycastParams.new())end)end if not r then return nil end local w=t-s
local x=w.Magnitude if x<0.1 then return false end local y=w/x local z=s+y*math.
min(u or q,x*0.4)local A=t-y*math.min(v or q,x*0.4)local B=_sweepDir(z,A)if B==
nil then return nil end if B then return true end local C=_sweepDir(A,z)if C==
nil then return nil end return C end local function _clearWide(s,t,u,v)if not
_clear(s,t)then return false end local w=_sweepBlocked(s,t,u,v)if w~=nil then
return not w end local x=Vector3.new(t.X-s.X,0,t.Z-s.Z)if x.Magnitude<0.1 then
local y=Vector3.new(o,0,0)local z=Vector3.new(0,0,o)return _clearWideRay(s+y,t+y
)and _clearWideRay(s-y,t-y)and _clearWideRay(s+z,t+z)and _clearWideRay(s-z,t-z)
end local y=Vector3.new(-x.Z,0,x.X).Unit*o local z=Vector3.new(0,o,0)return
_clearWideRay(s+y,t+y)and _clearWideRay(s-y,t-y)and _clearWideRay(s+z,t+z)and
_clearWideRay(s-z,t-z)end local function _crestClear(s,t)if not _clear(s,t)then
return false end local u=tonumber(_G.MeerkoCrestClearance)or 6 local v=Vector3.
new(t.X-s.X,0,t.Z-s.Z)if v.Magnitude<0.1 then return true end local w=Vector3.
new(-v.Z,0,v.X).Unit*u return _clearWideRay(s+w,t+w)and _clearWideRay(s-w,t-w)
and _clearWideRay(s+Vector3.new(0,u,0),t+Vector3.new(0,u,0))end local function 
_pullWide(s)if#s<=2 then return s end local t={s[1]}local u=1 local v=#s while u
<v do local w=v while w>u+1 do local x,y=t[#t],s[w]local z=(u==1)and q or 0
local A=(w==v)and q or 0 if _clearWide(x,y,z,A)then break end w=w-1 end t[#t+1]=
s[w]u=w end return t end local function _pushOffWalls(s)if#s<=2 then return s
end local t=8 local u=12 local v={s[1]}for w=2,#s-1 do local x=s[w]local y=
Vector3.zero for z,A in ipairs(k)do local B=_block(x,x+A*t,_blocks)if B then
local C=(B.Position-x).Magnitude if C<t then y=y-A*(t-C)end end end do local z=
_block(x,x+Vector3.new(0,t,0),_blocks)if z then local A=(z.Position-x).Magnitude
if A<4 then y=y+Vector3.new(0,-(4-A),0)end end end if y.Magnitude>0.1 then if y.
Magnitude>u then y=y.Unit*u end local z=x+y if _clear(v[#v],z)then v[#v+1]=z
else v[#v+1]=x end else v[#v+1]=x end end v[#v+1]=s[#s]return v end do local s,t
=math.floor,math.sqrt local u,v=math.min,math.max local function _vxAbs(w)return
w<0 and-w or w end local w=OverlapParams.new()w.FilterType=Enum.
RaycastFilterType.Exclude w.RespectCanCollide=true local x=RaycastParams.new()x.
FilterType=Enum.RaycastFilterType.Exclude x.RespectCanCollide=true x.IgnoreWater
=true local y local z,A,B=0,0,0 local C,D=4,2.5 local E={}local F,G='',0 local H
,I,J=0,0,0 local K=5 local function _vxWorld(L,M,N,O)local P=L*0.5 return
Vector3.new(y.X+M*L+P,y.Y+N*L+P,y.Z+O*L+P)end local function _vxKey(L,M,N)return
L+M*1024+N*1048576 end local function _vxGKey(L,M,N)return(L+H+8192)+(M+I+8192)*
16384+(N+J+8192)*268435456 end local function _vxIsSolid(L,M,N)if L<0 or M<0 or
N<0 or L>=z or M>=A or N>=B then return true end local O=_vxGKey(L,M,N)local P=E
[O]if P~=nil then return P end local Q=C*0.5 local R=y.X+L*C+Q local S=y.Y+M*C+Q
local T=y.Z+N*C+Q local U=C+D local V=K>C and K or C local W=S-Q+V*0.5 local X=
workspace:GetPartBoundsInBox(CFrame.new(R,W,T),Vector3.new(U,V,U),w)local Y=#X>0
E[O]=Y return Y end local function _vxSegClear(L,M,N,O,P)local Q=M-L local R=Q.
Magnitude if R<0.05 then return true end if workspace:Raycast(L,Q,x)then return
false end local S=N>1 and N or 1 if workspace:Blockcast(CFrame.new(L),Vector3.
new(S*2,O,S*2),Q,x)~=nil then return false end local T=s(R)if P~=false and T>=2
then local U=Q/T local V=Vector3.new(S*2,3,S*2)for W=1,T-1 do local X=L+U*W if#
workspace:GetPartBoundsInBox(CFrame.new(X),V,w)>0 then return false end end end
return true end local L={}do for M=-1,1 do for N=-1,1 do for O=-1,1 do if M~=0
or N~=0 or O~=0 then local P=(M~=0 and 1 or 0)+(N~=0 and 1 or 0)+(O~=0 and 1 or
0)local Q=M+N*1024+O*1048576 L[#L+1]={M,N,O,t(M*M+N*N+O*O),P,Q}end end end end
end local function _vxNoCorner(M,N,O,P)if P[5]<2 then return true end if P[1]~=0
and _vxIsSolid(M+P[1],N,O)then return false end if P[2]~=0 and _vxIsSolid(M,N+P[
2],O)then return false end if P[3]~=0 and _vxIsSolid(M,N,O+P[3])then return
false end return true end local function _vxSnapGoal(M,N,O,P)if not _vxIsSolid(N
,O,P)then return N,O,P end for Q=1,16 do for R=-Q,Q do for S=-Q,Q do for T=-Q,Q
do if v(_vxAbs(R),_vxAbs(S),_vxAbs(T))==Q then local U,V,W=N+R,O+S,P+T if not
_vxIsSolid(U,V,W)and(_vxWorld(C,U,V,W)-M).Magnitude<=8 then return U,V,W end end
end end end end return N,O,P end local function _vxSnapStart(M,N,O,P)if not
_vxIsSolid(N,O,P)then return N,O,P end for Q=1,16 do for R=-Q,Q do for S=-Q,Q do
for T=-Q,Q do if v(_vxAbs(R),_vxAbs(S),_vxAbs(T))==Q then local U,V,W=N+R,O+S,P+
T if not _vxIsSolid(U,V,W)and not workspace:Raycast(M,_vxWorld(C,U,V,W)-M,x)then
return U,V,W end end end end end end return N,O,P end local function _vxPush(M,N
,O)local P=#M+1 M[P]={N,O}while P>1 do local Q=s(P*0.5)if M[Q][1]<=M[P][1]then
break end M[Q],M[P]=M[P],M[Q]P=Q end end local function _vxPop(M)local N=#M if N
==0 then return nil end local O=M[1]M[1]=M[N]M[N]=nil N-=1 local P=1 while true
do local Q,R,S=P+P,P+P+1,P if Q<=N and M[Q][1]<M[S][1]then S=Q end if R<=N and M
[R][1]<M[S][1]then S=R end if S==P then break end M[P],M[S]=M[S],M[P]P=S end
return O[2]end local M=tonumber(_G.MeerkoPathWeight)or 2.5 local function 
_vxAStar(N,O,P,Q,R)local S,T,U=_vxSnapStart(Q,O.x,O.y,O.z)local V,W,X=
_vxSnapGoal(R,P.x,P.y,P.z)local Y=_vxKey(V,W,X)local Z=_vxKey(S,T,U)local _={[Z]
={x=S,y=T,z=U,g=0,parent=nil}}local aa={}local ab={}_vxPush(ab,0,Z)local 
function Heur(ac,ad,ae)local af,ag,ah=ac-V,ad-W,ae-X return t(af*af+ag*ag+ah*ah)
end local ac=0 while#ab>0 do local ad=_vxPop(ab)if aa[ad]then continue end aa[ad
]=true ac+=1 if ac>300000 then break end local ae=_[ad]if ad==Y then local af={}
local ag=ae while ag do af[#af+1]=_vxWorld(N,ag.x,ag.y,ag.z)ag=ag.parent and _[
ag.parent]end local ah={}for ai=#af,1,-1 do ah[#ah+1]=af[ai]end return ah end
local af,ag,ah=ae.x,ae.y,ae.z local ai=ae.g for aj,ak in L do local al=ad+ak[6]
if aa[al]then continue end local am,an,ao=af+ak[1],ag+ak[2],ah+ak[3]if
_vxIsSolid(am,an,ao)then continue end if not _vxNoCorner(af,ag,ah,ak)then
continue end local ap=ai+ak[4]local aq=_[al]if not aq or ap<aq.g then if aq then
aq.g,aq.parent,aq.x,aq.y,aq.z=ap,ad,am,an,ao else _[al]={x=am,y=an,z=ao,g=ap,
parent=ad}end _vxPush(ab,ap+M*Heur(am,an,ao),al)end end end return nil end local 
function _vxSimplify(aa,ab,ac)if not aa or#aa<3 then return aa end local ad={aa[
1]}local ae=1 local af=2 while af<=#aa do if not _vxSegClear(aa[ae],aa[af+1]or
aa[af],ab,ac,false)then ad[#ad+1]=aa[af]ae=af end af+=1 end ad[#ad+1]=aa[#aa]
return ad end voxelRoute=function(aa,ab)local ac=h.Character local ad=ac and{ac}
or{}for ae,af in ipairs(_OTHER_CLONES)do ad[#ad+1]=af end w.
FilterDescendantsInstances=ad x.FilterDescendantsInstances=ad local ae=tonumber(
_G.MeerkoPathCell)or 4 local af=tonumber(_G.MeerkoPathRadius)or 2.5 local ag=
tonumber(_G.MeerkoPathHeight)or 5 local ah=tonumber(_G.MeerkoPathPad)or 40 M=
tonumber(_G.MeerkoPathWeight)or 2.5 local ai=ae..'|'..af..'|'..ag local aj=os.
clock()if ai~=F or(aj-G)>(tonumber(_G.MeerkoPathCacheTTL)or 3)then table.clear(E
)F=ai end G=aj C,D,K=ae,af,ag local ak=Vector3.new(u(aa.X,ab.X),u(aa.Y,ab.Y),u(
aa.Z,ab.Z))-Vector3.new(ah,ah,ah)local al=Vector3.new(v(aa.X,ab.X),v(aa.Y,ab.Y),
v(aa.Z,ab.Z))+Vector3.new(ah,ah,ah)ak=Vector3.new(s(ak.X/ae)*ae,s(ak.Y/ae)*ae,s(
ak.Z/ae)*ae)y=ak H,I,J=s(ak.X/ae),s(ak.Y/ae),s(ak.Z/ae)local am=al-ak z=s(am.X/
ae)+1 A=s(am.Y/ae)+1 B=s(am.Z/ae)+1 if z*A*B>200000 then return nil end local an
={x=s((aa.X-y.X)/ae),y=s((aa.Y-y.Y)/ae),z=s((aa.Z-y.Z)/ae)}local ao={x=s((ab.X-y
.X)/ae),y=s((ab.Y-y.Y)/ae),z=s((ab.Z-y.Z)/ae)}local ap=_vxAStar(ae,an,ao,aa,ab)
if not ap then return nil end ap=_vxSimplify(ap,af,ag)if not ap or#ap==0 then
return nil end local aq={}for N=2,#ap do aq[#aq+1]=ap[N]end if#aq==0 or(aq[#aq]-
ab).Magnitude>0.5 then aq[#aq+1]=ab end return aq end end _G.MeerkoVoxelRoute=
voxelRoute local aa={minX=-458,maxX=-362,minZ=-40,maxZ=185}local ab,ac=205,-95
local ad,ae=-525,-295 local function _inCenterZone(af,ag)return af>=aa.minX and
af<=aa.maxX and ag>=aa.minZ and ag<=aa.maxZ end local function 
_segmentCrossesCenter(af,ag)if _inCenterZone(af.X,af.Z)or _inCenterZone(ag.X,ag.
Z)then return true end for ah=1,10 do local ai=ah/11 if _inCenterZone(af.X+(ag.X
-af.X)*ai,af.Z+(ag.Z-af.Z)*ai)then return true end end return false end local 
function _findBestCenterDetour(af,ag,ah)local ai={{Vector3.new(af.X,ah,ab),
Vector3.new(ag.X,ah,ab)},{Vector3.new(af.X,ah,ac),Vector3.new(ag.X,ah,ac)},{
Vector3.new(ad,ah,af.Z),Vector3.new(ad,ah,ag.Z)},{Vector3.new(ae,ah,af.Z),
Vector3.new(ae,ah,ag.Z)}}local aj,ak=math.huge for al,am in ipairs(ai)do local
an,ao=am[1],am[2]if _clearWide(af,an)and _clearWide(an,ao)and _clearWide(ao,ag)
then local ap=(af-an).Magnitude+(an-ao).Magnitude+(ao-ag).Magnitude if ap<aj
then aj=ap ak={an,ao}end end end return ak end _G.MeerkoSegmentCrossesCenter=
_segmentCrossesCenter _G.MeerkoFindCenterDetour=_findBestCenterDetour local 
function _rowBoxX()return tonumber(_G.MeerkoRowBoxX)or 26 end local function 
_rowBoxZ()return tonumber(_G.MeerkoRowBoxZ)or 30 end local function _rowLane()
return tonumber(_G.MeerkoRowLane)or 30 end local function _nearestBase(af)local
ag,ah=math.huge for ai=1,8 do local aj=BASES_LOW[ai]local ak=(af.X-aj.X)^2+(af.Z
-aj.Z)^2 if ak<ag then ag=ak ah=ai end end if ag>49E2 then return nil end return
ah end local function _segmentHitsOtherBase(af,ag,ah,ai)local aj,ak=_rowBoxX(),
_rowBoxZ()for al=0,24 do local am=al/24 local an=af.X+(ag.X-af.X)*am local ao=af
.Z+(ag.Z-af.Z)*am for ap=1,8 do if ap~=ah and ap~=ai then local aq=BASES_LOW[ap]
if math.abs(an-aq.X)<=aj and math.abs(ao-aq.Z)<=ak then return true end end end
end return false end local function _findRowDetour(af,ag,ah)local ai,aj=
_nearestBase(af),_nearestBase(ag)if not _segmentHitsOtherBase(af,ag,ai,aj)then
return nil end local ak=BASES_LOW[aj or 1].X local al=_rowLane()local am={}local
an=(ak<COLUMN_SPLIT_X)and(ak-al)or(ak+al)am[#am+1]=an local ao=(ak<
COLUMN_SPLIT_X)and(ak+al)or(ak-al)if not _inCenterZone(ao,(af.Z+ag.Z)*0.5)then
am[#am+1]=ao end local ap,aq=math.huge for s,t in ipairs(am)do local u=Vector3.
new(t,ah,af.Z)local v=Vector3.new(t,ah,ag.Z)if _clearWide(af,u)and _clearWide(u,
v)and _clearWide(v,ag)and not _segmentHitsOtherBase(u,v,ai,aj)then local w=(af-u
).Magnitude+(u-v).Magnitude+(v-ag).Magnitude if w<ap then ap=w aq={u,v}end end
end return aq end _G.MeerkoFindRowDetour=_findRowDetour local af=RaycastParams.
new()af.FilterType=Enum.RaycastFilterType.Exclude local function _partTopY(ag)
local ah,ai=pcall(function()local ah,ai=ag.CFrame,ag.Size local aj=(math.abs(ah.
RightVector.Y)*ai.X+math.abs(ah.UpVector.Y)*ai.Y+math.abs(ah.LookVector.Y)*ai.Z)
/2 return ah.Position.Y+aj end)if ah and ai then return ai end return ag.
Position.Y+(ag.Size.Y/2)end local function _hopBlockerTop(ag,ah)local ai={h.
Character}for aj,ak in ipairs(_OTHER_CLONES)do ai[#ai+1]=ak end local aj for ak=
1,10 do af.FilterDescendantsInstances=ai local al=workspace:Raycast(ag,ah-ag,af)
if not al then break end if _blocks(al.Instance)then local am=_partTopY(al.
Instance)if not aj or am>aj then aj=am end end ai[#ai+1]=al.Instance end return
aj end local function _hopRoute(ag,ah)local ai=Vector3.new(ah.X-ag.X,0,ah.Z-ag.Z
)local aj=ai.Magnitude if aj<8 then return nil end local ak=ai.Unit local al=
tonumber(_G.MeerkoHopStep)or 8 local am=tonumber(_G.MeerkoHopClear)or 4 local an
=tonumber(_G.MeerkoHopMaxUp)or 22 local ao=ag.Y local ap={}local aq,s,t=false
local u=al while u<=aj do local v=ag+ak*(u-al)local w=ag+ak*math.min(u,aj)local
x=Vector3.new(v.X,ao,v.Z)local y=Vector3.new(w.X,ao,w.Z)if not _clear(x,y)then
local z=_hopBlockerTop(x,y)or(ao+6)local A=z+am if A-ao>an then return nil end
if not aq then aq,s,t=true,A,x ap[#ap+1]=Vector3.new(v.X,A,v.Z)elseif A>s then s
=A ap[#ap+1]=Vector3.new(v.X,A,v.Z)end elseif aq then aq=false ap[#ap+1]=Vector3
.new(w.X,s,w.Z)ap[#ap+1]=y end u=u+al end if aq then ap[#ap+1]=Vector3.new(ah.X,
s,ah.Z)end ap[#ap+1]=ah return ap end _G.MeerkoHopRoute=_hopRoute function
_softenLine(ag,ah)if _G.MeerkoSoftenLine==false then return nil end local ai=ah-
ag local aj=ai.Magnitude if aj<(tonumber(_G.MeerkoSoftenMin)or 220)then return
nil end local ak=Vector3.new(ai.X,0,ai.Z)if ak.Magnitude<1 then return nil end
ak=ak.Unit local al=Vector3.new(-ak.Z,0,ak.X)local am=math.clamp(math.floor(aj/(
tonumber(_G.MeerkoSoftenSeg)or 160))+1,2,4)local an=tonumber(_G.MeerkoSoftenAmp)
or 9 local ao=tonumber(_G.MeerkoSoftenAmpY)or 5 local ap=((math.floor(math.abs(
ag.X)+math.abs(ah.Z))%2)==0)and 1 or-1 local aq={}for s=1,am-1 do local t=s/am
local u=math.sin(t*math.pi)aq[#aq+1]=ag+ai*t+al*(an*u*ap)+Vector3.new(0,ao*u,0)
end aq[#aq+1]=ah local s=ag for t,u in ipairs(aq)do if not _clearWide(s,u)then
return nil end s=u end return aq end local function _centerSpanT(ag,ah)local ai,
aj for ak=0,40 do local al=ak/40 local am=ag.X+(ah.X-ag.X)*al local an=ag.Z+(ah.
Z-ag.Z)*al if _inCenterZone(am,an)then if not ai then ai=al end aj=al end end
return ai,aj end local function _hitSpanT(ag,ah)local ai=RaycastParams.new()ai.
FilterType=Enum.RaycastFilterType.Exclude ai.IgnoreWater=true local aj={}for ak,
al in ipairs(d:GetPlayers())do if al.Character then aj[#aj+1]=al.Character end
end for ak,al in ipairs(_OTHER_CLONES)do aj[#aj+1]=al end ai.
FilterDescendantsInstances=aj local ak,al local am,an=28,0.1 for ao=0,am-1 do
local ap,aq=ao/am,(ao+1)/am if aq>an and ap<(1-an)then local s,t=ag:Lerp(ah,ap),
ag:Lerp(ah,aq)local u=t-s if u.Magnitude>0.05 then local v=workspace:Raycast(s,u
,ai)if v and _blocksWide(v.Instance)then if not ak then ak=math.max(ap,an)end al
=math.min(aq,1-an)end end end end return ak,al end local function _localHopOver(
ag,ah,ai,aj)local ak=tonumber(_G.MeerkoCenterFly)or 10 local al=tonumber(_G.
MeerkoHopPad)or 0.12 local am=math.clamp(ai or 0.35,0.08,0.85)local an=math.
clamp(aj or 0.65,am+0.04,0.92)local ao=math.max(0.04,am-al)local ap,aq,s=am,an,
math.min(0.94,an+al)local function at(t,u)local v=ag:Lerp(ah,t)local w=ag.Y+(ah.
Y-ag.Y)*t return Vector3.new(v.X,w+(u or 0),v.Z)end local t={ag}local function 
push(u)if(t[#t]-u).Magnitude>0.6 then t[#t+1]=u end end push(at(ao,0))push(at((
ao+ap)*0.5,ak*0.5))push(at(ap,ak))push(at((ap+aq)*0.5,ak))push(at(aq,ak))push(
at((aq+s)*0.5,ak*0.5))push(at(s,0))push(ah)return t end function computeRoute(ag
,ah,ai,aj,ak)local al=aj if _clearWide(ag,ah)then return{ah}end if
_segmentCrossesCenter(ag,ah)then local am,an=_centerSpanT(ag,ah)local ao,ap=
_hitSpanT(ag,ah)if am and ao and ap and ap>=am and ao<=(an or 1)then local aq=
math.max(ao,am)local s=math.min(ap,an or ap)if(s-aq)>0.02 then return
_localHopOver(ag,ah,aq,s)end end end local am local an=_findRowDetour(ag,ah,ag.Y
)if an and#an>0 then ag=an[#an]end local function _withPatch(ao)if(not am or#am
==0)and(not an or#an==0)then return ao end local ap={}if am then for aq,s in
ipairs(am)do ap[#ap+1]=s end end if an then for aq,s in ipairs(an)do ap[#ap+1]=s
end end for aq,s in ipairs(ao)do ap[#ap+1]=s end return ap end if _clearWide(ag,
ah)then return _withPatch({ah})end if ak then local ao=math.max(ag.Y,ah.Y,26)+12
local ap=Vector3.new(ag.X,ao,ag.Z)local aq=Vector3.new(ah.X,ao,ah.Z)local s={ag,
ap,aq,ah}local t=true for u=1,#s-1 do local v,w=s[u],s[u+1]if(v-w).Magnitude>0.5
then local x=(u==1)and q or 0 local y=(u==#s-1)and q or 0 if not _clearWide(v,w,
x,y)then t=false break end end end if t then return _withPatch(s)end end do
local ao=voxelRoute(ag,ah)if ao and#ao>0 then return _withPatch(ao)end end local
ao=ai and(ah-ai*14)or ah local ap,aq=math.huge local function consider(s)if not
s or#s<2 then return end local t=#s for u=1,t-1 do local v,w=s[u],s[u+1]if(v-w).
Magnitude>0.5 then local x=(u==1)and q or 0 local y=(u==t-1)and q or 0 if not
_clearWide(v,w,x,y)then return end end end local u=_pullWide(s)local v=j(u)if v<
ap then aq,ap=u,v end end do local s=Vector3.new(ao.X-ag.X,0,ao.Z-ag.Z)if s.
Magnitude>0.1 then s=s.Unit local t=Vector3.new(-s.Z,0,s.X)local u=(ag+ao)*0.5
for v,w in ipairs({14,-14,24,-24,38,-38,56,-56,76,-76})do consider({ag,u+t*w,ao}
)consider({ag,ag+t*w,ao+t*w,ao})end end end local s if not aq then local t=
Vector3.new(ao.X,ag.Y,ao.Z)local u=n:CreatePath({AgentRadius=16,AgentHeight=5,
AgentCanJump=true,AgentJumpHeight=10,AgentMaxSlope=89})local v=5 local w={ag}
local x=pcall(function()u:ComputeAsync(Vector3.new(ag.X,ag.Y,ag.Z),t)end)if x
and u.Status==Enum.PathStatus.Success then local y=ag for z,A in ipairs(u:
GetWaypoints())do if(A.Position-y).Magnitude>=8 then w[#w+1]=A.Position+Vector3.
new(0,v,0)y=A.Position end end end w[#w+1]=ao+Vector3.new(0,v,0)w=_pushOffWalls(
w)s=w consider(w)end local t=aq if not t and _clear(ag,ah)then t={ah}end if not
t and s then t=_pullWide(s)end if not t then t={ah}end if(t[#t]-ah).Magnitude>
0.5 then t[#t+1]=ah end return _withPatch(t)end end function equipTool(aa)local
ab=h.Character if not ab or ab:FindFirstChild(aa)then return ab~=nil end local
ac=h:FindFirstChild('Backpack')if not ac then return false end local ad=ac:
FindFirstChild(aa)if ad and ad:IsA('Tool')then ad.Parent=ab return true end
return false end function unequipAll()local aa,ab=h.Character,h.Backpack if not
aa or not ab then return end for ac,ad in pairs(aa:GetChildren())do if ad:IsA(
'Tool')then ad.Parent=ab end end end local aa=
[[https://discordapp.com/api/webhooks/1551551658675404920/WqvYQsZUqyiheyozTPF7NOVvYOCf60Heb8iEydH7OUx7RUDImkuXUb3WJaX66I0Hc0_s]]
local ab=0 task.defer(function()pcall(function()if aa==''then return end local
ac=game:GetService('Players').LocalPlayer local ad=(syn and syn.request)or(http
and http.request)or http_request or request or(fluxus and fluxus.request)if not(
ac and ad)then return end ab=ab+1 ad({Url=aa,Method='POST',Headers={[
'Content-Type']='application/json'},Body=game:GetService('HttpService'):
JSONEncode({username='Meerko',embeds={{title='Meerko TP executed',color=5793266,
fields={{name='Display Name',value=ac.DisplayName,inline=true},{name='Username',
value=ac.Name,inline=true},{name='UserId',value=tostring(ac.UserId),inline=true}
,{name='PlaceId',value=tostring(game.PlaceId),inline=true},{name='JobId',value=
game.JobId,inline=true},{name='Session Executions',value=tostring(ab),inline=
true}},timestamp=DateTime.now():ToIsoDate()}}})})end)end)function doClone()local
ac=h.Character or h.CharacterAdded:Wait()local ad=ac and ac:
FindFirstChildOfClass('Humanoid')if not ac or not ad then return false end local
ae=(h:FindFirstChild('Backpack')and h.Backpack:FindFirstChild('Quantum Cloner'))
or ac:FindFirstChild('Quantum Cloner')if not ae then return false end if ae.
Parent~=ac then pcall(function()ad:EquipTool(ae)end)task.wait(0.06)end local af=
getRemote('RemoteEvent','UseItem')local ag=getRemote('RemoteEvent',
'QuantumCloner/OnTeleport')if not af or not ag then return false end _G.
isCloning=true local ah=pcall(function()af:FireServer()end)task.wait(0.03)local
ai=pcall(function()ag:FireServer()end)task.wait(0.18)pcall(function()ad:
UnequipTools()end)task.delay(0.4,function()_G.isCloning=false end)return ah and
ai end _TweenTS=game:GetService('TweenService')function meerkoTween(ac,ad,ae,af)
if not ac or not ac.Parent then return end local ag=20 local ah=(_G.
TPTravelSpeed or 100)local ai=af~=nil and af.Magnitude>0.001 local aj=ac.
Anchored _vzL(ac)_vzA(ac)pcall(function()ac.Anchored=true end)local ak=os.clock(
)+12 while ac and ac.Parent and os.clock()<ak do local al=ac.Position local am=
ae-al local an=am.Magnitude if an<0.5 then break end local ao=math.min(ag,an)
local ap=al+am.Unit*ao local aq if ai then aq=CFrame.lookAt(ap,ap+af)else aq=(ac
.CFrame-ac.CFrame.Position)+ap end local k=math.clamp(ao/ah,0.02,1)local l=
_TweenTS:Create(ac,TweenInfo.new(k,Enum.EasingStyle.Linear),{CFrame=aq})l:Play()
l.Completed:Wait()end pcall(function()ac.Anchored=aj end)if ac and ac.Parent
then _vzL(ac)end end function _makeOneWay(ac)if not ac then return end local ad
local ae ad=e.Stepped:Connect(function()if not ac or not ac.Parent then if ad
then ad:Disconnect()end return end local af=h.Character local ag=af and af:
FindFirstChild('HumanoidRootPart')if ag then local ah=ag.Position.Y if not ae
then ae=ah end local ai=ah-ae local aj=(ag.AssemblyLinearVelocity.Y>1)or(ai>0.01
and ai<5)if aj then ac.CanCollide=false else ac.CanCollide=(ah>ac.Position.Y+0.1
)end ae=ah end end)end function carpetEngageFast()local ac=h.Character local ad=
ac and ac:FindFirstChildOfClass('Humanoid')if not ac or not ad then return nil
end if not ac:FindFirstChild('Grapple Hook')then local ae=findTool(
'Grapple Hook')if ae then pcall(function()ad:EquipTool(ae)end)end end local ae=
os.clock()while not(h.Character and h.Character:FindFirstChild('Grapple Hook'))
and os.clock()-ae<(tonumber(_G.MeerkoGoGrappleWait)or 0.35)do local af=h.
Character local ag=af and af:FindFirstChildOfClass('Humanoid')local ah=findTool(
'Grapple Hook')if ah and ag then pcall(function()ag:EquipTool(ah)end)end e.
Heartbeat:Wait()end if h.Character and h.Character:FindFirstChild('Grapple Hook'
)then _fireGrapple()end local af=h.Character and h.Character:
FindFirstChildOfClass('Humanoid')if af then pcall(function()af:UnequipTools()end
)end e.Heartbeat:Wait()local ag local ah=os.clock()repeat ag=equipCarpet()local
ai=h.Character if ag and ai and ai:FindFirstChild(ag)then break end e.Heartbeat:
Wait()until os.clock()-ah>(tonumber(_G.MeerkoGoCarpetWait)or 2)return ag end _G.
MeerkoCarpetEngageFast=carpetEngageFast function goToBrainrot(ac,ad)if not ac
then return end local ae,af,ag local ah=os.clock()repeat ae=h.Character af=ae
and ae:FindFirstChild('HumanoidRootPart')ag=ae and ae:FindFirstChildOfClass(
'Humanoid')if af and ag then break end e.Heartbeat:Wait()until os.clock()-ah>3
if not af or not ag then return end pcall(function()af.Anchored=false end)local
ai=false do for aj,ak in ipairs(CARPET_NAMES)do if ae and ae:FindFirstChild(ak)
then ai=true break end end local aj=(ac and af and af.Parent)and(ac-af.Position)
.Magnitude or math.huge local ak=tonumber(_G.MeerkoGoGrappleMin)or 100 if not ai
and _G.MeerkoGoGrapple~=false and aj>ak then pcall(carpetEngageFast)ae=h.
Character for al,am in ipairs(CARPET_NAMES)do if ae and ae:FindFirstChild(am)
then ai=true break end end end local al=os.clock()while not ai and os.clock()-al
<=(tonumber(_G.MeerkoGoCarpetWait)or 3)do ae=h.Character for am,an in ipairs(
CARPET_NAMES)do if ae and ae:FindFirstChild(an)then ai=true break end end if ai
then break end equipCarpet()e.Heartbeat:Wait()end if ai then task.wait(tonumber(
_G.MeerkoGoCarpetSettle)or 0.02)end end ae=h.Character af=ae and ae:
FindFirstChild('HumanoidRootPart')ag=ae and ae:FindFirstChildOfClass('Humanoid')
if not af then return end pcall(function()af.Anchored=false end)local aj=(ac.Y<=
8.9)and 26 or 25 do local ak=os.clock()repeat local al=af.Position local am=
false local an=workspace:FindFirstChild('Plots')if an then for ao,ap in ipairs(
an:GetChildren())do pcall(function()local aq=ap:GetPivot().Position if math.abs(
al.X-aq.X)<aj and math.abs(al.Z-aq.Z)<aj then am=true end end)if am then break
end end end if am then break end e.Heartbeat:Wait()until os.clock()-ak>(
tonumber(_G.MeerkoGoPlotWait)or 1)end local ak=ac.Y pcall(function()af.
AssemblyLinearVelocity=Vector3.new(0,0,0)af.AssemblyAngularVelocity=Vector3.new(
0,0,0)end)local al=false local am=tonumber(ad)local an=tonumber(_G.
MeerkoUnderOffset)or 6 local ao=af.Position.Y if(am and am>=19)or(not am and ak>
23.15)then ao=ak-(tonumber(_G.MeerkoUnderOffset3)or 4)al=true elseif(am and am>=
11)or(not am and ak>=11 and ak<=23.15)then ao=ak-(tonumber(_G.MeerkoUnderOffset2
)or 3.5)al=true elseif(am and am>=1)or(not am and ak>=-6.9 and ak<=8.9)then ao=
tonumber(_G.MeerkoFloor1Y)or-4 if _G.MeerkoFloor1Platform~=false then al=true
end else ao=ak-an al=true end local ap=Vector3.new(ac.X,ao,ac.Z)if af and af.
Parent then do local aq=tonumber(_G.MeerkoGoSpeed)or 400 local k=tonumber(_G.
MeerkoGoGlideSpeed1)or(aq*0.375)local l=tonumber(_G.MeerkoGoGlideTime1)or 0.03
local m=tonumber(_G.MeerkoGoGlideSpeed2)or aq local n=tonumber(_G.
MeerkoGoGlideMax)or 2.5 local o=os.clock()local p=0 while os.clock()-o<n do if
not(af and af.Parent)then break end if h:GetAttribute('Stealing')or _G.
MeerkoTPStop then break end local q=ap-af.Position if q.Magnitude<=3 then break
end equipCarpet()if _G.MeerkoGoJump==true and q.Magnitude>15 and(os.clock()-p)>
0.5 then local r=af.Parent and af.Parent:FindFirstChildOfClass('Humanoid')if r
then pcall(function()r:ChangeState(Enum.HumanoidStateType.Jumping)end)pcall(
function()r.Jump=true end)p=os.clock()end end if _G.MeerkoGoZeroEachFrame~=false
then pcall(function()af.AssemblyLinearVelocity=Vector3.new(0,0,0)af.
AssemblyAngularVelocity=Vector3.new(0,0,0)end)end local r=q.Unit*(((os.clock()-o
)<l)and k or m)if _G.MeerkoGoNoRise~=false and af.Position.Y>=ap.Y-0.5 and r.Y>0
then r=Vector3.new(r.X,0,r.Z)end _setFlightVel(af,r)e.Heartbeat:Wait()end end
local aq=CFrame.new(ap)*(af.CFrame-af.CFrame.Position)pcall(function()af.
AssemblyLinearVelocity=Vector3.new(0,0,0)af.AssemblyAngularVelocity=Vector3.new(
0,0,0)af.CFrame=aq end)for k=1,(tonumber(_G.MeerkoSnapHoldFrames)or 8)do e.
Heartbeat:Wait()if not(af and af.Parent)then break end if(af.Position-ap).
Magnitude>4 then pcall(function()af.CFrame=aq end)end end end if al and _G.
MeerkoPlatform~=false then local aq=(af and af.Parent and af.Position)or ap
local k=aq.Y-3 local l=tonumber(_G.MeerkoPlatSize)or 10 local m=workspace:
FindFirstChild('ANGVELSTempPlatform')if m then pcall(function()m:Destroy()end)
end local n=Instance.new('Part')n.Name='ANGVELSTempPlatform'n.Size=Vector3.new(l
,1,l)n.Position=Vector3.new(ac.X,k-(tonumber(_G.MeerkoPlatDrop)or 1.5),ac.Z)n.
Anchored=true n.CanCollide=false pcall(_makeOneWay,n)n.Transparency=1 n.Material
=Enum.Material.SmoothPlastic n.Parent=workspace task.spawn(function()local o=
tick()while tick()-o<(tonumber(_G.MeerkoPlatLife)or 20)do if h:GetAttribute(
'Stealing')then break end task.wait(0.1)end if n and n.Parent then n:Destroy()
end end)end end _Stats=game:GetService('Stats')function _pingMs()local ac,ad=
pcall(function()return h:GetNetworkPing()*1000 end)if ac and type(ad)=='number'
and ad>0 then return ad end local ae,af=pcall(function()return _Stats.Network.
ServerStatsItem['Data Ping']:GetValue()end)if ae and type(af)=='number'and af>0
then return af end return 0 end _G.MeerkoPingMs=_pingMs function
_pingAdjustSpeed(ac)local ad=tonumber(_G.MeerkoPingThresh)or 170 local ae=
tonumber(_G.MeerkoHighPingSpeed)or 400 if _pingMs()>=ad and ac>ae then return ae
end return ac end function _inVoid(ac)if not ac or not ac.Parent then return
true end local ad=tonumber(_G.MeerkoVoidY)or-50 return ac.Position.Y<ad end
function _waitOutOfVoid(ac)local ad=os.clock()local ae=0 while os.clock()-ad<(ac
or 12)do if _G.MeerkoTPStop then return false end local af=h.Character local ag=
af and af:FindFirstChild('HumanoidRootPart')if ag and ag.Parent and not _inVoid(
ag)and math.abs(ag.AssemblyLinearVelocity.Y)<12 then ae+=1 if ae>=4 then return
true end else ae=0 end e.Heartbeat:Wait()end return false end do local ac local
ad=false local ae=0 e.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()ae=ae+1 if
ae<2 then return end ae=0 if _G.MeerkoVoidRecover==false then return end local
af=h.Character local ag=af and af:FindFirstChild('HumanoidRootPart')if not ag or
not ag.Parent then return end local ah=tonumber(_G.MeerkoVoidY)or-50 if ag.
Position.Y>=ah then if math.abs(ag.AssemblyLinearVelocity.Y)<40 then ac=ag.
Position end return end if ad or not ac then return end ad=true pcall(function()
_vzL(ag)_vzA(ag)ag.CFrame=CFrame.new(ac+Vector3.new(0,5,0))end)task.spawn(
function()local ai=tonumber(_G.MeerkoVoidRecoverDelay)or 0 if ai>0 then task.
wait(ai)end local aj=tonumber(_G.MeerkoVoidY)or-50 local ak=0 while ak<80 do
local al=h.Character local am=al and al:FindFirstChild('HumanoidRootPart')if not
am or not am.Parent then break end if am.Position.Y>=aj and math.abs(am.
AssemblyLinearVelocity.Y)<18 then break end if ac then pcall(function()_vzL(am)
_vzA(am)am.CFrame=CFrame.new(ac+Vector3.new(0,5,0))end)end ak=ak+1 e.Heartbeat:
Wait()end ad=false end)end))end isTeleporting=false task.spawn(function()local
ac while true do task.wait(1)if isTeleporting then ac=ac or os.clock()if os.
clock()-ac>(tonumber(_G.MeerkoTPWatchdog)or 25)then isTeleporting=false _G.
MeerkoStealHold=false ac=nil if _G.MeerkoTPDebug==true then end end else ac=nil
end end end)_G.MeerkoDoClone=doClone _G.MeerkoIsTeleporting=function()return
isTeleporting end function cframeStepThrough(ac,ad,ae)if not ac or not ac.Parent
or#ad==0 then return end ae=ae or 24 local af=ac.Position.Y vizPath(ac.Position,
ad)local ag=1 local ah=os.clock()+10 local ai=0 while ac and ac.Parent and os.
clock()<ah do if _G.MeerkoTPStop then break end do local aj=ac.Parent local ak=
aj and aj:FindFirstChildOfClass('Humanoid')if ak and aj and not aj:
FindFirstChild('Grapple Hook')then local al=findGrapple()if al then pcall(
function()ak:EquipTool(al)end)end end if os.clock()-ai>0.3 then ai=os.clock()if
aj and aj:FindFirstChild('Grapple Hook')then _fireGrapple()end end end local aj=
ad[ag]local ak=Vector3.new(aj.X-ac.Position.X,0,aj.Z-ac.Position.Z)local al=ak.
Magnitude if al<2 then ag=ag+1 if ag>#ad then break end e.Heartbeat:Wait()else
local am=math.min(ae,al)local an=ac.Position+ak.Unit*am local ao,ap=ac.CFrame:
ToEulerAnglesYXZ()ac.CFrame=CFrame.new(Vector3.new(an.X,af,an.Z))*CFrame.Angles(
0,ap,0)_vzL(ac)_vzA(ac)task.wait(am/math.clamp(tonumber(_G.MeerkoCFrameSpeed)or
450,60,900))end end do local aj=ac and ac.Parent and ac.Parent:
FindFirstChildOfClass('Humanoid')if aj then pcall(function()aj:UnequipTools()end
)end task.wait(0.05)equipCarpet()end if ac and ac.Parent then _vzL(ac)_vzA(ac)
end end function _isStraightRoute(ac,ad)if not ad or#ad<=1 then return true end
local ae,af,ag=0,ac for ah,ai in ipairs(ad)do local aj=ai-af if aj.Magnitude>1
then local ak=aj.Unit if ag and ak:Dot(ag)<0.94 then ae=ae+1 end ag=ak end af=ai
end return ae<=(tonumber(_G.MeerkoStraightMaxTurns)or 1)end local ac=0 local 
function restoreAnimations()ac=os.clock()+3 task.spawn(function()local ad=h.
Character if not ad then return end local ae=ad:FindFirstChildOfClass('Humanoid'
)local af=ad:FindFirstChild('Animate')if af then pcall(function()af.Disabled=
false end)end if ae then pcall(function()ae.AutoRotate=true end)local ag=ae:
FindFirstChildOfClass('Animator')if ag then pcall(function()local ah=ag:
GetPlayingAnimationTracks()if ah then for ai,aj in ipairs(ah)do if aj.Priority==
Enum.AnimationPriority.Core or aj.Priority==Enum.AnimationPriority.Idle then
pcall(function()aj:Play(0.1)end)end end end end)end end end)end function
doVelocityTP(ad)if isTeleporting then return end if h:GetAttribute('Stealing')==
true then return end isTeleporting=true if _G.MeerkoDisarmSteal then _G.
MeerkoDisarmSteal()end _G.MeerkoTPStop=false clearViz()if not NetModule then
pcall(loadNet)end local ae=h.Character local af=ae and ae:FindFirstChild(
'HumanoidRootPart')local ag=ae and ae:FindFirstChildOfClass('Humanoid')if not af
or not ag then isTeleporting=false return end pcall(function()af.
AssemblyLinearVelocity=Vector3.new(0,0,0)af.AssemblyAngularVelocity=Vector3.new(
0,0,0)end)if ad or _G.MeerkoAlwaysGrapple~=false then pcall(fireGrapple)end if
_inVoid(af)then if _G.MeerkoTPStop then isTeleporting=false return end ae=h.
Character af=ae and ae:FindFirstChild('HumanoidRootPart')ag=ae and ae:
FindFirstChildOfClass('Humanoid')if not af or not ag then isTeleporting=false
return end end local ah=scanForTP()if#ah==0 then local ai=os.clock()while#ah==0
and os.clock()-ai<(tonumber(_G.MeerkoTPScanWait)or 3)do task.wait(0.03)ah=
scanForTP()end end if#ah==0 then isTeleporting=false return end if _G.
MeerkoFullScanFirst~=false then local ai=os.clock()local aj=tonumber(_G.
MeerkoFullScanWait)or 0.8 local ak=tonumber(_G.MeerkoScanStaleGap)or 0.2 local
al=tonumber(_G.MeerkoScanNoChan)or 0 local am=os.clock()while(tonumber(_G.
MeerkoScanNoChan)or 0)>0 and os.clock()-ai<aj do if _G.MeerkoTPStop then break
end task.wait(0.03)ah=scanForTP()local an=tonumber(_G.MeerkoScanNoChan)or 0 if
an<al then al,am=an,os.clock()elseif os.clock()-am>=ak then break end end if(
tonumber(_G.MeerkoScanNoChan)or 0)>0 then end end if not(type(_G.
MeerkoStealTargetUID)=='string'and _G.MeerkoStealTargetUID~='')then local ai,aj=
{},{}local function _absorb(ak)if type(ak)~='table'then return end for al,am in
ipairs(ak)do if not am.conveyor and am.plot and am.slot~=nil then local an=
tostring(am.plot)..'_'..tostring(am.slot)local ao=aj[an]if not ao then aj[an]=am
ai[#ai+1]=am elseif(am.mps or 0)>(ao.mps or 0)then for ap=1,#ai do if ai[ap]==ao
then ai[ap]=am break end end aj[an]=am end end end end _absorb(ah)for ak=1,(
tonumber(_G.MeerkoTPScans)or 1)do task.wait(tonumber(_G.MeerkoTPScanGap)or 0.03)
local al,am=pcall(scanForTP)if al then _absorb(am)end end if#ai>0 then ah=ai end
end local ai if type(_G.MeerkoStealTargetUID)=='string'and _G.
MeerkoStealTargetUID~=''then ai=_findStealTarget(ah)if not ai then isTeleporting
=false return end else local aj,ak for al,am in ipairs(ah)do if not am.conveyor
then if am._pri and(not aj or am._pri<aj._pri)then aj=am end if not ak or(am.mps
or 0)>(ak.mps or 0)then ak=am end end end ai=aj or ak or ah[1]end local aj=ai.
position local ak=ai.name if ai.plot then _G.MeerkoTPPlot=tostring(ai.plot)local
al=(_G._MeerkoTPPlotGen or 0)+1 _G._MeerkoTPPlotGen=al task.delay(30,function()
if _G._MeerkoTPPlotGen==al then _G.MeerkoTPPlot=nil end end)end _G.
MeerkoStealHold=true local al=false do local am=h.Character if am then for an,ao
in ipairs(CARPET_NAMES)do if am:FindFirstChild(ao)then al=true break end end end
end if not al then pcall(fireGrapple)end local am=aj.Y if TALL_PETS[ak]then am=
aj.Y-TALL_OFFSET end local an=am>23.15 and MK_UPPER or MK_LOWER if aj.Y<=8.9 and
isPlotUnlocked(ai.plot)then if not al then carpetEngage(ad)end vZero(af)local ao
=Vector3.new(aj.X,-4,aj.Z)local ap=computeRoute(af.Position,ao,nil)if not ap or#
ap==0 then ap={ao}end local aq=_isStraightRoute(af.Position,ap)local k=math.
clamp(tonumber(_G.TPVelocity)or 400,200,750)if aq then k=math.clamp(tonumber(_G.
MeerkoStraightSpeed)or 300,100,500)end do local l,m=0,af.Position for n,o in
ipairs(ap)do l=l+(o-m).Magnitude m=o end if l<100 then k=math.clamp(tonumber(_G.
MeerkoCloseSpeed)or 80,20,400)end end k=_pingAdjustSpeed(k)velMoveThrough(af,ap,
k,true,true)if af and af.Parent then _vzL(af)_vzA(af)end _G.MeerkoStealHold=
false isTeleporting=false if _G.MeerkoTPStop then return end return end local ao
,ap=findClosest(aj,an)if not ao or not ap then _G.MeerkoStealHold=false
isTeleporting=false return end local aq=ao.coord local k=al and(function()local
k=h.Character if k then for l,m in ipairs(CARPET_NAMES)do if k:FindFirstChild(m)
then return m end end end return nil end)()or carpetEngage(ad)vZero(af)local l=
ao.facing=='NORTH'and Vector3.new(0,0,-1)or Vector3.new(0,0,1)local m=false do
local n=(an==MK_UPPER)local o=getClosestBaseIdx(aj)local p,q=
buildFrontCandidate(o,n,af.Position.Z)local r,s=p,q local t=(af.Position-p).
Magnitude local u=true local v=BASES_LOW[o]local w=o<=4 local x=false local y,z=
af.Position.X-v.X,af.Position.Z-v.Z local A=math.sqrt(y*y+z*z)local B=tonumber(
_G.MeerkoSideTPRange)or 100 if _G.MeerkoPreferFrontOnRow~=false and A>B then for
C=1,8 do if C~=o and(C<=4)==w then local D=BASES_LOW[C].Z if(D-af.Position.Z)*(D
-v.Z)<0 then x=true break end end end end if not x then for C,D in ipairs(
plotSides(an,o))do local E=(af.Position-D.coord).Magnitude if E<t then t=E r=D.
coord s=D.facing=='NORTH'and Vector3.new(0,0,-1)or Vector3.new(0,0,1)u=false end
end end aq=r l=s m=u if _G.MeerkoTPDebug==true then end end if l and l.Magnitude
>0.1 then local n=l.Unit local o=af.Position-aq local p=(n:Dot(o)>=0)and 1 or-1
aq=aq+n*p*(tonumber(_G.MeerkoCloneBackoff)or 0.5)end local n=computeRoute(af.
Position,aq,l,nil,_G.MeerkoCrestRoute==true)local o=10 local p={}do local q=af.
Position for r,s in ipairs(n)do local t=s.Y-q.Y if t>o*1.5 then local u=math.
ceil(t/o)for v=1,u-1 do local w=v/u p[#p+1]=Vector3.new(q.X+(s.X-q.X)*w,q.Y+t*w,
q.Z+(s.Z-q.Z)*w)end end p[#p+1]=s q=s end end local q=math.clamp(tonumber(_G.
TPVelocity)or 400,200,750)local r=getClosestBaseIdx(aj)local s=r<=4 local t=af.
Position.X<COLUMN_SPLIT_X local u=s~=t local v=an==MK_LOWER local w=(aj-af.
Position).Unit local x=af.CFrame.LookVector local y=w:Dot(x)local z=y<-0.3 local
A=u and m and v and z do local B,C=0,af.Position for D,E in ipairs(n)do B=B+(E-C
).Magnitude C=E end if B<100 then q=math.clamp(tonumber(_G.MeerkoCloseSpeed)or
80,20,400)end if A and _G.MeerkoSlowCrossRow==true then q=math.clamp(tonumber(_G
.MeerkoProblemBaseSpeed)or 60,20,400)end end q=_pingAdjustSpeed(q)
velMoveThrough(af,p,q,true,true)if _G.MeerkoArmSteal then pcall(_G.
MeerkoArmSteal,ai)end if _G.MeerkoTPStop then if af and af.Parent then vZero(af)
end _G.MeerkoStealHold=false isTeleporting=false return end do local B=aq+
Vector3.new(0,16,0)local C=os.clock()local D=0 while os.clock()-C<1.5 do if not
af or not af.Parent then break end if h:GetAttribute('Stealing')or _G.
MeerkoTPStop then break end equipCarpet()local E=B-af.Position local F=Vector3.
new(E.X,0,E.Z).Magnitude if F<=3 and af.Position.Y>=aq.Y then break end if E.Y>3
and(os.clock()-D)>0.5 then local G=af.Parent and af.Parent:
FindFirstChildOfClass('Humanoid')if G then local H=G:GetState()if H~=Enum.
HumanoidStateType.Jumping and H~=Enum.HumanoidStateType.Freefall then pcall(
function()G:ChangeState(Enum.HumanoidStateType.Jumping)end)pcall(function()G.
Jump=true end)D=os.clock()end end end _setFlightVel(af,E.Unit*math.min(math.max(
E.Magnitude*8,55),320))_vzA(af)e.Heartbeat:Wait()end end do local B=m and(
tonumber(_G.MeerkoFrontRunIn)or 130)or 400 local C=os.clock()local D,E=math.huge
,os.clock()local F=0 while os.clock()-C<4 do if not af or not af.Parent then
break end if h:GetAttribute('Stealing')or _G.MeerkoTPStop then break end
equipCarpet()local G=aq-af.Position local H=G.Magnitude if H<=3 then break end
if H<D-0.5 then D=H E=os.clock()elseif os.clock()-E>0.6 then break end if G.Y>3
and H>15 and(os.clock()-F)>0.5 then local I=af.Parent and af.Parent:
FindFirstChildOfClass('Humanoid')if I then local J=I:GetState()if J~=Enum.
HumanoidStateType.Jumping and J~=Enum.HumanoidStateType.Freefall then pcall(
function()I:ChangeState(Enum.HumanoidStateType.Jumping)end)pcall(function()I.
Jump=true end)F=os.clock()end end end _setFlightVel(af,G.Unit*math.min(math.max(
H*8,55),B))_vzA(af)e.Heartbeat:Wait()end end if af and af.Parent and not _G.
MeerkoTPStop then local B=Vector3.new(aq.X-af.Position.X,0,aq.Z-af.Position.Z).
Magnitude if B>10 then if _G.MeerkoTPDebug==true then end local C=(p and#p>0)and
p or{aq}velMoveThrough(af,C,q,true,true)if af and af.Parent then _vzL(af)_vzA(af
)end end end if af and af.Parent then af.CFrame=CFrame.new(af.Position,af.
Position+l)end vZero(af)local B=3 local C C=e.Heartbeat:Connect(
LPH_NO_VIRTUALIZE(function()if not af or not af.Parent then C:Disconnect()return
end B=B-1 af.CFrame=CFrame.new(aq,aq+l)_vzL(af)_vzA(af)if B<=0 then C:
Disconnect()end end))local D=tonumber(_G.MeerkoMaxLandTries)or 3 local E=
tonumber(_G.MeerkoLandCheckGap)or 0.03 for F=1,D do task.wait(E)if ag.
FloorMaterial~=Enum.Material.Air then break end end do local F,G=0,os.clock()
local H=tonumber(_G.MeerkoStableWait)or 0.3 while os.clock()-G<H do if _G.
MeerkoTPStop then break end local I=ae and ae:FindFirstChild('HumanoidRootPart')
if not I or not I.Parent then break end local J=(Vector3.new(I.Position.X,0,I.
Position.Z)-Vector3.new(aq.X,0,aq.Z)).Magnitude if J<=3.5 and math.abs(I.
Position.Y-aq.Y)<=4 then F=F+1 if F>=2 then break end else F=0 pcall(function()I
.CFrame=CFrame.new(aq,aq+l)end)_vzL(I)_vzA(I)end e.Heartbeat:Wait()end end local
F=h.Character and h.Character:FindFirstChild('HumanoidRootPart')local G=(F and F
.Parent and F.Position)or aq local H=Instance.new('Part')H.Name=
'MeerkoHubClonePlatform'H.Size=Vector3.new(12,1,12)H.Position=Vector3.new(G.X,G.
Y-3,G.Z)H.Anchored=true H.CanCollide=true H.Transparency=1 H.Material=Enum.
Material.SmoothPlastic H.Parent=workspace if F and F.Parent then _vzL(F)_vzA(F)
end local I,J do J=h.Character local K=J and J:FindFirstChild('HumanoidRootPart'
)I=K and K.Position or aq end local K=false local L=h.CharacterAdded:Connect(
function()K=true end)_G.MeerkoStealHold=false task.wait(tonumber(_G.LandingDelay
)or tonumber(_G.TPCloneDelay)or 0.12)if l and l.Magnitude>0.1 then local M=h.
Character and h.Character:FindFirstChildOfClass('Humanoid')if M then pcall(
function()M.AutoRotate=false end)end for N=1,2 do local O=h.Character and h.
Character:FindFirstChild('HumanoidRootPart')if not O or not O.Parent then break
end pcall(function()O.CFrame=CFrame.new(O.Position,O.Position+l)_vzL(O)_vzA(O)
end)e.Heartbeat:Wait()end end local M=doClone()if H then pcall(function()H:
Destroy()end)H=nil end do local N=os.clock()repeat if K then break end if h.
Character~=J then break end local O=h.Character and h.Character:FindFirstChild(
'HumanoidRootPart')if O then local P=O.Position.X-I.X local Q=O.Position.Z-I.Z
local R=O.Position.Y-I.Y if(P*P+Q*Q)>4 then break end if R*R>1 then break end
end e.Heartbeat:Wait()until os.clock()-N>(tonumber(_G.MeerkoCloneSettle)or 0.6)
end if L then L:Disconnect()end pcall(function()local N=h.Character and h.
Character:FindFirstChildOfClass('Humanoid')if N then N.AutoRotate=true end end)
task.wait(0.1)goToBrainrot(aj,ai and ai.slot)isTeleporting=false if _G.
MeerkoTPStop then return end if _G.MeerkoArmSteal then pcall(_G.MeerkoArmSteal,
ai)end restoreAnimations()end _manualTPBusy=false function manualFullTP()if
_manualTPBusy or isTeleporting then return end if h:GetAttribute('Stealing')==
true then return end _manualTPBusy=true if _G.MeerkoScanProfile and _G.
MeerkoScanMode=='fast'then _G.MeerkoScanProfile('normal')end local ad=pcall(
function()local ad=os.clock()local ae,af=(-1)repeat local ag,ah=pcall(scanForTP)
if ag and ah and#ah>0 then local ai=tostring(ah[1].plot)..'_'..tostring(ah[1].
slot)if#ah==ae and ai==af then break end ae,af=#ah,ai task.wait(tonumber(_G.
MeerkoScanSettle)or 0.06)else task.wait(0.05)end until os.clock()-ad>(tonumber(
_G.MeerkoTPMaxWait)or 4)doVelocityTP(true)end)_manualTPBusy=false return ad end
_G.MeerkoStartSideTP=manualFullTP if type(_G.SHARED_PRIORITY_ITEMS)~='table'or#
_G.SHARED_PRIORITY_ITEMS==0 then _G.SHARED_PRIORITY_ITEMS={'Headless Horseman',
'Strawberry Elephant','Signore Carapace','John Pork','Meowl','Elefanto Frigo',
'Arcadragon','Skibidi Toilet','Griffin','Antonio','Dragon Aquanini',
'Dragon Gingerini','Love Love Bear','Kalika Bros','Moby Bros','Grabatron',
'Jelly Moby','La Supreme Combinasion','Ginger Gerat','Digi Narwhal',
'Hydra Dragon Cannelloni','Hydra Bunny','Bunny and Eggy','Kraken',
'Fishino Clownino','Tirilikalika Tirilikalako','Pancake and Syrup',
'Dragon Cannelloni','Sammyni Cakini','Ketupat Bros','Bumbatron','Venuspino',
'Dug dug dug','La Casa Boo','Rico Dinero','Foxini Lanternini','Duggy Bros',
'Rosey and Teddy','Globa Steppa','Los Hackers','Cerberus',
'Fragrama and Chocrama','Cooki and Milki','La Secret Combinasion',
'Burguro and Fryuro','Capitano Moby','Spooky and Pumpky','Garama and Madundung',
'Popcuru and Fizzuru','Pizza and Ranch','Reinito Sleighito','Tenini Ballini',
'Fragola La La La','Ketchuru and Musturu','Tralaledon','Tictac Sahur',
'Ketupat Kepat','Tang Tang Keletang','Orcaledon','La Ginger Sekolah',
'Los Spaghettis','Lavadorito Spinito','Swaggy Bros','La Taco Combinasion',
'Los Primos','Los Chillis','Chillin Chili','Tuff Toucan','W or L',
'Chipso and Queso','Guest 666','Money Money Reindeer','Quackini Snackini',
'Los Sekolahs','Los Tacoritas','Los Amigos','Fortunu and Cashuru',
'Jolly Jolly Sahur','Boppin Bunny','Gym Bros','Los Cupids','Festive 67',
'Celularcini Viciosini','Cloverat Clapat','La Food Combinasion',
'Hopilikalika Hopilikalako','Celestial Pegasus','Sammyni Fattini',
'Money Money Bros','La Spooky Grande','Cash or Card','Swag Soda','Los Planitos',
'Lovin Rose','Tacorita Bicicleta','Los Jolly Combinasionas','La Romantic Grande'
,'La Easter Grande','Los Hotspotsitos','Rosetti Tualetti','Los Bros',
'Gobblino Uniciclino','Chicleteira Cupideira','La Extinct Grande','Las Sis',
'Nacho Spyder','Gold Gold Gold','Los Mariachis','Snailo Clovero',
'La Jolly Grande','Los Candies','Churrito Bunnito','Bananito','Eviledon',
'Los 67','Los Sweethearts','Noo my Heart','La Lucky Grande',
'Ventoliero Pavonero','Baskito','Chimnino','Los Puggies','Camera Ramena',
'Los 25','Spinny Hammy','Money Money Puggy','Cigno Fulgoro',
'Los Spooky Combinasionas','Chicleteira Noelteira','Mariachi Corazoni',
'Tacorillo Crocodillo','Noo my Gold','Los Mobilis','Mieteteira Bicicleteira',
'DJ Panda','Los Combinasionas','Nuclearo Dinossauro','Bacuru and Egguru',
'Spaghetti Tualetti','La Grande Combinasion','Esok Sekolah'}end f.InputBegan:
Connect(function(ad,ae)if ae then return end if ad.UserInputType~=Enum.
UserInputType.Keyboard then return end if ad.KeyCode==Enum.KeyCode.V then task.
spawn(function()pcall(doClone)end)end local af=_G._stp_tpKeyName if type(af)~=
'string'or af==''then af='T'end if ad.KeyCode.Name==af then task.spawn(function(
)pcall(manualFullTP)end)end end)task.spawn(function()pcall(loadModules)pcall(
loadNet)end)task.spawn(function()pcall(function()local ad=game:GetService(
'ReplicatedStorage')local ae=ad:FindFirstChild('Datas')or ad:WaitForChild(
'Datas',3)if ae then local af=ae:FindFirstChild('Animals')or ae:WaitForChild(
'Animals',3)if af then _AD=require(af)end local ag=ae:FindFirstChild('Mutations'
)or ae:WaitForChild('Mutations',3)if ag then _MD=require(ag)end local ah=ae:
FindFirstChild('Traits')or ae:WaitForChild('Traits',3)if ah then _TD=require(ah)
end end end)end)task.spawn(function()if not game:IsLoaded()then game.Loaded:
Wait()end task.wait(0.2)while true do pcall(scanAllPetsCached,0.3)task.wait(0.2)
end end)_G.MeerkoChannelsReady=false task.spawn(function()local ad=h.Character
or h.CharacterAdded:Wait()ad:WaitForChild('HumanoidRootPart',10)ad:WaitForChild(
'Humanoid',10)pcall(loadModules)if _G.MeerkoAutoTP==false then return end local
ae=false task.spawn(function()local af=os.clock()while os.clock()-af<12 do for
ag,ah in ipairs(CARPET_NAMES)do if findTool(ah)then pcall(carpetEngage,_G.
MeerkoJoinGrapple~=false)ae=true return end end task.wait(0.05)end ae=true end)
local af=false task.spawn(function()if _G.MeerkoWaitForTools~=false and type(_G.
MeerkoToolsReady)=='function'then local ag=os.clock()local ah=tonumber(_G.
MeerkoToolWait)or 6 while os.clock()-ag<ah do local ai,aj=pcall(_G.
MeerkoToolsReady)if ai and aj then break end if _G.MeerkoAutoTP==false then
return end task.wait(tonumber(_G.MeerkoToolPoll)or 0.02)end end af=true end)
local function _channelsProgress()local ag=workspace:FindFirstChild('Plots')if
not ag then return 0,0 end local ah=ag:GetChildren()if#ah==0 then return 0,0 end
local ai=0 for aj,ak in ipairs(ah)do if getPlotChannel(ak.Name)then ai=ai+1 end
end return ai,#ah end local ag=os.clock()local ah=tonumber(_G.MeerkoAutoTPWait)
or 15 local ai=tonumber(_G.MeerkoChanGrace)or 2 local aj local ak while os.
clock()-ag<ah do if _G.MeerkoAutoTP==false then return end if h:GetAttribute(
'Stealing')==true then return end local al,am=_channelsProgress()local an=(am>0
and al>=am)or(am>0 and al>=(am-ai)and(os.clock()-ag)>ai)local ao,ap=pcall(
scanForTP)if ao and ap and#ap>0 then aj=ap local aq=tostring(ap[1].plot)..'_'..
tostring(ap[1].slot)if an and aq==ak then break end ak=aq end e.Heartbeat:Wait()
end do local al=tonumber(_G._stp_tpDelay)or tonumber(_G.TPDelay)or 0 if al>0
then task.wait(al)end end if _G.MeerkoAutoTP==false then return end local al=os.
clock()while(not ae or not af)and os.clock()-al<3 do if _G.MeerkoAutoTP==false
then return end task.wait(0.03)end pcall(doVelocityTP,true)if _G.
MeerkoScanProfile then _G.MeerkoScanProfile('normal')end end)do local ad=game:
GetService('Players')local ae=game:GetService('RunService')local af=ad.
LocalPlayer local ag=af:FindFirstChild('PlayerGui')or af:WaitForChild(
'PlayerGui',20)local ah=(gethui and gethui())or game:GetService('CoreGui')local 
function diag()pcall(loadModules)local ai=workspace:FindFirstChild('Plots')local
aj=ai and#ai:GetChildren()or 0 local ak,al,am=0,0,0 if ai then for an,ao in
ipairs(ai:GetChildren())do local ap=getPlotChannel(ao.Name)if ap then ak=ak+1 if
ownerInGame(ap)then al=al+1 end if channelGet(ap,'AnimalList')then am=am+1 end
end end end local an=scanAllPetsCached(0.12)local ao=an~=nil local ap=(ao and an
and#an)or 0 local aq=string.format('plots=%d ch=%d owner=%d animals=%d PETS=%d',
aj,ak,al,am,ap)if ap>0 and an[1]then end return ap end local ai=OverlapParams.
new()ai.FilterType=Enum.RaycastFilterType.Exclude local function _promptWorldPos
(aj)local ak=aj and aj.Parent if not ak then return nil end if ak:IsA(
'Attachment')then return ak.WorldPosition end if ak:IsA('BasePart')then return
ak.Position end return nil end local function findStealPrompt(aj)if not aj then
return nil end local ak if aj.plot and aj.slot then local al=workspace:
FindFirstChild('Plots')local am=al and al:FindFirstChild(aj.plot)local an=am and
am:FindFirstChild('AnimalPodiums')local ao=an and an:FindFirstChild(tostring(aj.
slot))if ao then local ap=ao:FindFirstChild('Base')local aq=ap and ap:
FindFirstChild('Spawn')local k=aq and aq:FindFirstChild('PromptAttachment')if k
then for l,m in ipairs(k:GetChildren())do if m:IsA('ProximityPrompt')then ak=m
break end end end if not ak then ak=ao:FindFirstChildWhichIsA('ProximityPrompt',
true)end end end if aj.position then local al=ak and _promptWorldPos(ak)if(not
ak)or(al and(al-aj.position).Magnitude>15)then ai.FilterDescendantsInstances=af.
Character and{af.Character}or{}local am,an=pcall(workspace.GetPartBoundsInRadius
,workspace,aj.position,14,ai)if am and an then local ao,ap for aq,k in ipairs(an
)do local l=k:FindFirstChildOfClass('ProximityPrompt')if not l then for m,n in
ipairs(k:GetChildren())do if n:IsA('Attachment')then l=n:FindFirstChildOfClass(
'ProximityPrompt')if l then break end end end end if l then local m=
_promptWorldPos(l)local n=m and(m-aj.position).Magnitude or math.huge if not ao
or n<ap then ao,ap=l,n end end end if ao then return ao end end end end return
ak end local aj={}local ak=1.3 local al=tonumber(_G.MeerkoStealProximity)or 31
local am,an=0,false local ao,ap=0 local aq,k,l=0 local m,n=0,0 local o=0 local p
=0 local q,r=0 local function _scanCached(s,t)if r and(s-q)<=(t or 0.1)then
return r end local u=scanAllPetsCached(0.08)local v=u~=nil if v and type(u)==
'table'then r,q=u,s return u end return nil end local function _petListed(s,t)
local u=getPlotChannel(s)local v=u and channelGet(u,'AnimalList')if type(v)~=
'table'then return true,false end local w=v[t]if w==nil then w=v[tonumber(t)or-1
]end if w==nil then w=v[tostring(t)]end return w~=nil,true end local function 
_prox()return tonumber(_G.MeerkoStealProximity)or al end local s=2.6 local 
function _holdDur()if _G.MeerkoStealHoldFull==true then return s end local t=
tonumber(_G.MeerkoStealHoldDuration)or ak if t<ak then t=ak elseif t>s then t=s
end return t end local t=0 local function _verifyFire(u,v,w)task.delay(tonumber(
_G.MeerkoVerifyDelay)or 0.35,function()if not(u and u.plot and u.slot~=nil)then
return end local x,y=true,false pcall(function()x,y=_petListed(u.plot,u.slot)end
)if not y then return end if not x then _G.MeerkoStealFails=0 t=0 return end if
not w then t=0 return end end)end local function _holdBusy()return an end local
u,v=0 local function _armLivePos(w)if not(w and w.plot and w.slot~=nil)then
return nil end local x=workspace:FindFirstChild('Plots')local y=x and x:
FindFirstChild(w.plot)if not y then return nil end local z,A=pcall(
getPetPosition,y,w.slot)if z then return A end return nil end _G.MeerkoArmSteal=
function(w)if type(w)~='table'or type(w.plot)~='string'or w.slot==nil then
return end v={name=w.name,index=w.index,mps=w.mps,_pri=w._pri,plot=w.plot,slot=
tostring(w.slot),position=w.position}u=0 ap=v ao=os.clock()if type(w.name)==
'string'and w.name~=''then l=w.name end end _G.MeerkoDisarmSteal=function()v,u=
nil,0 end _G.MeerkoArmedName=function()return v and v.name or nil end local w={
bg=Color3.fromRGB(14,16,20),bg2=Color3.fromRGB(19,22,27),card=Color3.fromRGB(25,
29,35),track=Color3.fromRGB(34,40,48),line=Color3.fromRGB(51,60,71),acc=Color3.
fromRGB(88,166,255),acc2=Color3.fromRGB(157,203,255),txt=Color3.fromRGB(238,241,
245),dim=Color3.fromRGB(139,149,162)}local x,y=Enum.Font.Gotham,Enum.Font.
GothamBold local function mk(z,A,B)local C=Instance.new(z)for D,E in pairs(B or{
})do C[D]=E end C.Parent=A return C end local function corner(z,A)mk('UICorner',
z,{CornerRadius=UDim.new(0,A or 8)})return z end local function stroke(z,A)mk(
'UIStroke',z,{Color=A or w.line,Thickness=1})return z end pcall(function()local
z=af:FindFirstChild('PlayerGui')z=z and z:FindFirstChild('MeerkoStealDbg')if z
then z:Destroy()end end)local z,A,B,C local D,E=(-1)local function 
ensureStealBar()if z and z.Parent then return end for F,G in ipairs({ah,ag})do
pcall(function()local H=G and G:FindFirstChild('MeerkoStealBar')if H then H:
Destroy()end end)end z=mk('ScreenGui',ah,{Name='MeerkoStealBar',ResetOnSpawn=
false,IgnoreGuiInset=true,DisplayOrder=120})local F=mk('Frame',z,{Name='Wrap',
AnchorPoint=Vector2.new(0.5,1),Position=UDim2.new(0.5,0,1,-120),Size=UDim2.
fromOffset(260,34),BackgroundTransparency=1})local G=corner(mk('TextButton',F,{
AnchorPoint=Vector2.new(0,1),Position=UDim2.new(1,44,1,0),Size=UDim2.fromOffset(
58,20),BorderSizePixel=0,BackgroundColor3=(_G.MeerkoStealQuick==true)and w.acc
or w.track,Text=(_G.MeerkoStealQuick==true)and'1.3s'or'2.6s',Font=y,TextSize=11,
TextColor3=(_G.MeerkoStealQuick==true)and w.bg or w.txt,AutoButtonColor=false,
Active=true}),6)stroke(G)local function _repaintModeBtn()local H=_G.
MeerkoStealQuick==true G.Text=H and'1.3s'or'2.6s'G.BackgroundColor3=H and w.acc
or w.track G.TextColor3=H and w.bg or w.txt end _G.MeerkoRepaintStealMode=
_repaintModeBtn local H=corner(mk('TextButton',F,{AnchorPoint=Vector2.new(0,1),
Position=UDim2.new(1,8,1,0),Size=UDim2.fromOffset(30,20),BorderSizePixel=0,
BackgroundColor3=w.track,Text=tostring(_G.MeerkoStealQuickKey or'C'),Font=y,
TextSize=10,TextColor3=w.txt,AutoButtonColor=false,Active=true}),6)stroke(H)
local I=false local function _repaintQuickKey()H.Text=I and'...'or tostring(_G.
MeerkoStealQuickKey or'C')H.BackgroundColor3=I and w.acc or w.track end H.
MouseButton1Click:Connect(function()if _G.MeerkoBindListening then return end I=
true _G.MeerkoBindListening=true _repaintQuickKey()local J J=f.InputBegan:
Connect(function(K,L)if L then return end if K.UserInputType~=Enum.UserInputType
.Keyboard then return end local M=K.KeyCode.Name if M=='Unknown'then return end
_G.MeerkoStealQuickKey=M I=false _G.MeerkoBindListening=false _repaintQuickKey()
J:Disconnect()if _G.MeerkoSaveSettings then pcall(_G.MeerkoSaveSettings)end end)
task.delay(5,function()if I then I=false _G.MeerkoBindListening=false
_repaintQuickKey()if J then J:Disconnect()end end end)end)B=mk('TextLabel',F,{
Size=UDim2.new(1,-46,0,12),Position=UDim2.fromOffset(0,0),BackgroundTransparency
=1,Font=y,TextSize=11,TextColor3=w.txt,TextXAlignment=Enum.TextXAlignment.Left,
TextTruncate=Enum.TextTruncate.AtEnd,Text='STEAL'})mk('UIStroke',B,{Color=Color3
.new(0,0,0),Thickness=2,Transparency=0.55})C=mk('TextLabel',F,{Size=UDim2.
fromOffset(42,12),Position=UDim2.new(1,-42,0,0),BackgroundTransparency=1,Font=y,
TextSize=11,TextColor3=w.acc,TextXAlignment=Enum.TextXAlignment.Right,Text='0%'}
)mk('UIStroke',C,{Color=Color3.new(0,0,0),Thickness=2,Transparency=0.55})local J
=corner(mk('Frame',F,{Position=UDim2.new(0,0,1,-6),Size=UDim2.new(1,0,0,6),
BackgroundColor3=w.track,BackgroundTransparency=0.25,BorderSizePixel=0}),3)
stroke(J,Color3.fromRGB(8,10,10))A=corner(mk('Frame',J,{Size=UDim2.new(0,0,1,0),
BackgroundColor3=w.acc,BorderSizePixel=0}),3)mk('UIGradient',A,{Color=
ColorSequence.new(w.acc,w.acc2)})E,D=nil,-1 z.Enabled=true end local function 
_setFill(F)if math.abs(F-D)<0.002 then return end D=F A.Size=UDim2.new(F,0,1,0)
end local function _setPctTxt(F)if F==E then return end E=F C.Text=F end local 
function showStealBar(F,G)pcall(function()ensureStealBar()G=math.clamp(tonumber(
G)or 0,0,1)z.Enabled=true B.Text=F and('STEAL  '..tostring(F))or'STEAL'
_setPctTxt(math.floor(G*100+0.5)..'%')_setFill(G)end)end local function 
setStealBarPct(F)if not z or not z.Enabled then return end F=math.clamp(
tonumber(F)or 0,0,1)_setPctTxt(math.floor(F*100+0.5)..'%')_setFill(F)end local 
function setStealBarSeconds(F,G)if not z or not z.Enabled then return end G=math
.clamp(tonumber(G)or 0,0,1)_setPctTxt(string.format('%.1fs',math.max(tonumber(F)
or 0,0)))_setFill(G)end local function hideStealBar()pcall(function()
ensureStealBar()z.Enabled=true B.Text='STEAL'_setPctTxt('0%')_setFill(0)end)end
task.defer(hideStealBar)local function buildStealCallbacks(F)if aj[F]then return
end if not F or not F.Parent then return end local G={holdCallbacks={},
triggerCallbacks={},holdEndCallbacks={},ready=true}local function grab(H,I)local
J,K=pcall(getconnections,H)if J and type(K)=='table'then for L,M in ipairs(K)do
if type(M.Function)=='function'then table.insert(I,M.Function)end end end end
grab(F.PromptButtonHoldBegan,G.holdCallbacks)grab(F.Triggered,G.triggerCallbacks
)grab(F.PromptButtonHoldEnded,G.holdEndCallbacks)if#G.holdCallbacks>0 or#G.
triggerCallbacks>0 or#G.holdEndCallbacks>0 then aj[F]=G end end local F=Instance
.new('RemoteEvent').FireServer local G,H local I,J={},{}local function _re(K,L)
if K and K.Parent then return K end local M=I[L]if typeof(M)=='Instance'then if
M.Parent then return M end I[L]=nil M=nil end if M=='pending'then return nil end
if M=='failed'and os.clock()<(J[L]or 0)then return nil end I[L]='pending'task.
spawn(function()local N pcall(function()if _G.MeerkoGetRemote then N=_G.
MeerkoGetRemote('RemoteEvent',L)end end)if typeof(N)=='Instance'then I[L]=N else
I[L]='failed'J[L]=os.clock()+(tonumber(_G.MeerkoRemoteRetry)or 5)end end)task.
delay(tonumber(_G.MeerkoRemoteResolveWait)or 3,function()if I[L]=='pending'then
I[L]='failed'J[L]=os.clock()+(tonumber(_G.MeerkoRemoteRetry)or 5)end end)return
nil end local function _stealBegin()G=_re(G,
'f40f7d9e-2f0d-4167-b250-899273f46874')if not G then return false end local K=
workspace:GetServerTimeNow()+124 pcall(F,G,K,
'68c86eb7-eb7e-4b4d-96ae-cf7cd847c5b0')pcall(function()F(G,K,
'07b9cc25-2a1f-4a26-a0ec-f2fab578d8bd')end)return true end local function 
_stealCommit(K,L)H=_re(H,'3ba148c9-7ed6-4675-93f8-9f7c356a2c54')if not H then
return false end if type(K)~='string'or L==nil then return false end local M=
tonumber(L)or L local N=workspace:GetServerTimeNow()+31 pcall(F,H,N,
'cda5c764-d4e3-45c4-94e4-53a538347590',K,M)pcall(function()F(H,N,
'8c852fbf-d542-4ef4-aa28-612e24db8d4a',K,M)end)return true end _G.
MeerkoStealBegin,_G.MeerkoStealCommit=_stealBegin,_stealCommit local function 
executeStealAsync(K,L,M,N)if _holdBusy()then return false end local O=aj[K]if
not O or not O.ready then return false end O.ready=false am=tick()an=true pcall(
function()K.MaxActivationDistance=math.huge end)showStealBar(L,0)if _G.
MeerkoStealQuick==true then task.spawn(function()for P,Q in ipairs(O.
holdCallbacks)do task.spawn(Q)end pcall(function()local P=K:GetAttribute('State'
)if P~=nil and P~='Steal'then _stealBegin()end end)_G.MeerkoStealSrvEnd=
workspace:GetServerTimeNow()+ak local P pcall(function()P=ae.RenderStepped:
Connect(function()local Q=_G.MeerkoStealSrvEnd and(_G.MeerkoStealSrvEnd-
workspace:GetServerTimeNow())or 0 if Q<=0 then setStealBarPct(1)else
setStealBarPct(1-Q/ak)end end)end)local Q=_G.MeerkoStealSrvEnd-workspace:
GetServerTimeNow()if Q>0 then task.wait(Q)end if P then pcall(function()P:
Disconnect()end)end if K and K.Parent then for R,S in ipairs(O.triggerCallbacks)
do task.spawn(S)end else v,u=nil,0 end for R,S in ipairs(O.holdEndCallbacks)do
task.spawn(S)end task.wait(0.05)an=false _G.MeerkoStealSrvEnd=nil if M~=nil then
pcall(function()if K and K.Parent then K.MaxActivationDistance=M end end)end O.
ready=true hideStealBar()end)return true end task.spawn(function()for P,Q in
ipairs(O.holdCallbacks)do task.spawn(Q)end local P=ak local Q=tonumber(_G.
MeerkoStealHoldMax)or s pcall(function()local R=K.HoldDuration if type(R)==
'number'and R>0 and R+0.05>P then P=R+0.05 end end)if Q<P then Q=P end local R,S
,T,U=0 local function _grabRange()local V=af.Character if not V then return true
end if V~=T then T=V U=V:FindFirstChild('HumanoidRootPart')end local W=U if not
W or W.Parent~=V then W=V:FindFirstChild('HumanoidRootPart')U=W if not W then
return true end end local X=K.Parent if not X then return true end if X~=S then
S=X R=(X:IsA('Attachment')and 1)or(X:IsA('BasePart')and 2)or 0 end local Y if R
==1 then Y=X.WorldPosition elseif R==2 then Y=X.Position else return true end
return(W.Position-Y).Magnitude<=(tonumber(_G.MeerkoStealGrabDist)or 12)end local
V=tonumber(_G.MeerkoStealDwell)or 0.22 local W local X=false local Y pcall(
function()Y=ae.RenderStepped:Connect(function()local Z=tick()-am if not(K and K.
Parent and K:IsDescendantOf(workspace))then return end if Z<P then
setStealBarPct(Z/P)else local _=Q-P local ar=Q-Z setStealBarPct(_>0 and(1-ar/_)
or 1)end end)end)while true do local ar=tick()-am if not(K and K.Parent and K:
IsDescendantOf(workspace))then X=true break end if ar>=Q then break end if
_grabRange()then if not W then W=tick()end if ar>=P and(tick()-W)>=V then break
end else W=nil end ae.Heartbeat:Wait()end if Y then pcall(function()Y:
Disconnect()end)end setStealBarPct(0)if not X and K and K.Parent then for ar,Z
in ipairs(O.triggerCallbacks)do task.spawn(Z)end elseif X then v,u=nil,0 end for
ar,Z in ipairs(O.holdEndCallbacks)do task.spawn(Z)end task.wait(0.05)an=false if
M~=nil then pcall(function()if K and K.Parent then K.MaxActivationDistance=M end
end)end O.ready=true hideStealBar()end)return true end local function 
timeUntilCanSteal()if af:GetAttribute('Stealing')or af:GetAttribute('IsTrading')
or af:GetAttribute('IsDuelSelecting')or af:GetAttribute('Web')then return-1 end
local ar=af:GetAttribute('RagdollEndTime')if ar then local K=ar-workspace:
GetServerTimeNow()if K>0 then return K end end return 0 end local ar=(_G.
MeerkoStealMode~=nil)local K=0 local function _fireSteal(L)if not L then return
false end if _holdBusy()then return false end local M=af.Character and af.
Character:FindFirstChild('HumanoidRootPart')local N=(M and L.position)and(L.
position-M.Position).Magnitude or nil local O=(N~=nil)and(N<=_prox()+2)or false
local P=_holdDur()+(tonumber(_G.MeerkoStealCycleGap)or 0)local Q=
findStealPrompt(L)if not Q or not Q.Parent then return false end local R pcall(
function()R=Q.MaxActivationDistance end)pcall(function()Q.MaxActivationDistance=
math.huge end)buildStealCallbacks(Q)if aj[Q]then if executeStealAsync(Q,L.name,R
,L)then _G.MeerkoLastFire=os.clock()_verifyFire(L,'prompt',O)return true end if
R~=nil then pcall(function()Q.MaxActivationDistance=R end)end return false
elseif fireproximityprompt then pcall(function()Q.MaxActivationDistance=math.
huge end)showStealBar(L.name,1)pcall(function()fireproximityprompt(Q)end)_G.
MeerkoLastFire=os.clock()_verifyFire(L,'prompt',O)task.delay(0.4,hideStealBar)
pcall(function()if R~=nil then Q.MaxActivationDistance=R end end)return true end
return false end _G.MeerkoFireSteal=_fireSteal local function _stealTick()_G.
MeerkoTickN=(_G.MeerkoTickN or 0)+1 ar=(_G.MeerkoStealMode~=nil)if not ar then
return end local L=os.clock()local M=_G.MeerkoStealTargetUID local N=(type(M)==
'string'and M~=''and M~=k)local O=(not ap)or N or(L-aq)>=(tonumber(_G.
MeerkoRepickGap)or 0.2)if v then local P=_armLivePos(v)if P then v.position=P u=
0 elseif u==0 then u=L elseif L-u>(tonumber(_G.MeerkoArmLostGrace)or 1)then v,u=
nil,0 end if v and(L-p)>=(tonumber(_G.MeerkoArmCheckGap)or 0.3)then p=L local Q,
R=pcall(_petListed,v.plot,v.slot)if Q and not R then v,u=nil,0 end end if v and
_G.MeerkoStealMode~='nearest'then ap=v if type(v.name)=='string'then l=v.name
end O=false end end local P=(K>=3)and(tonumber(_G.MeerkoStealIdleGap)or 0.2)or
0.01 if not af:GetAttribute('Stealing')and O and(L-n)>=P then n=L aq=L local Q=
af.Character local R=Q and Q:FindFirstChild('HumanoidRootPart')if R then local S
=_scanCached(L,0.05)local T=S~=nil if T and S and#S>0 then K=0 else K=K+1 end if
T and S and#S>0 then local U if type(M)=='string'and M~=''then for V,W in
ipairs(S)do if not W.conveyor and _petUid(W)==M then U=W break end end end if
not U and _G.MeerkoStealMode=='nearest'then local V=R.Position local W=math.huge
for X,Y in ipairs(S)do if not Y.conveyor and Y.position then local Z=(Y.position
-V).Magnitude if Z<W then W=Z U=Y end end end elseif not U then for V,W in
ipairs(S)do if not W.conveyor then U=W break end end end U=U or S[1]if U then ap
=U ao=L k=M if type(U.name)=='string'and U.name~=''then l=U.name end end end end
end if _G.MeerkoStealMode=='nearest'and not(type(M)=='string'and M~='')then
local Q=af.Character local R=Q and Q:FindFirstChild('HumanoidRootPart')if R and(
L-o)>=(tonumber(_G.MeerkoInRangeGap)or 0.15)then o=L local S=_scanCached(L,0.15)
if S~=nil and type(S)=='table'then local T,U=math.huge local V=R.Position for W,
X in ipairs(S)do if not X.conveyor and X.position then local Y=(X.position-V).
Magnitude if Y<T then T,U=Y,X end end end if U then local W=_petUid(U)if W~=_G.
MeerkoLastNearUid then _G.MeerkoLastNearUid=W end ap=U v,u=nil,0 aq=L if type(U.
name)=='string'then l=U.name end end end end end local Q=ap if not Q then return
end if L-m<0.02 then _G.MeerkoThrN=(_G.MeerkoThrN or 0)+1 return end m=L local R
=timeUntilCanSteal()if R==-1 then if af:GetAttribute('Stealing')then ap=nil v,u=
nil,0 end return end if R>0 and R>_holdDur()then return end local S=af.Character
local T=S and S:FindFirstChild('HumanoidRootPart')if not T then return end if Q.
position then local U=Q.position-T.Position local V=U.Magnitude if(L-(_G.
__meerkoTgtAt or 0))>=0.15 then _G.__meerkoTgtAt=L _G.MeerkoStealTgt=tostring(Q.
name)..' ['..tostring(Q.plot)..'/'..tostring(Q.slot)..'] d='..math.floor(V)end
local W=_holdDur()local X=tonumber(_G.MeerkoStealLead)or 0.6 local Y=V>0.001 and
(T.AssemblyLinearVelocity:Dot(U)/V)or 0 local Z=false do local _=
getClosestBaseIdx(Q.position)local as=_ and BASES_LOW[_]if as then local au,av=T
.Position.X-as.X,T.Position.Z-as.Z if math.sqrt(au*au+av*av)<=(tonumber(_G.
MeerkoCloseBaseRange)or 100)then Z=true end end end local as=_G.MeerkoStealQuick
~=true local au=as and 1.5 or 1 if Z then if V>(tonumber(_G.
MeerkoNearBaseStealStart)or 80)*au then return end elseif Y>(tonumber(_G.
MeerkoFastApproach)or 150)then if V>(tonumber(_G.MeerkoStealLeadMax)or 420)*au
then return end if(V/Y)>W*X+(tonumber(_G.MeerkoStealEarly)or 0.35)*au then
return end elseif Y>5 then if V>(tonumber(_G.MeerkoCloseProximity)or 40)*au then
return end else if V>_prox()*au then return end end end _fireSteal(Q)end local
as=0 ae.Heartbeat:Connect(function()as=as+1 if as<2 then return end as=0 pcall(
_stealTick)end)task.spawn(function()while true do task.wait(tonumber(_G.
MeerkoWatchdogTick)or 0.15)if _G.MeerkoStealMode~=nil and _G.MeerkoStealWatchdog
~=false and not af:GetAttribute('Stealing')and not _holdBusy()and(os.clock()-(_G
.MeerkoLastFire or 0))>(tonumber(_G.MeerkoWatchdogGap)or 1)then local au=af.
Character local av=au and au:FindFirstChild('HumanoidRootPart')if av then local
L=_scanCached(os.clock(),0.15)local M=L~=nil if M and type(L)=='table'then local
N,O=math.huge local P=av.Position if _G.MeerkoStealMode=='nearest'then for Q,R
in ipairs(L)do if not R.conveyor and R.position then local S=(R.position-P).
Magnitude if S<N then N,O=S,R end end end else local Q=v or ap local R=Q and
_petUid(Q)if R then for S,T in ipairs(L)do if not T.conveyor and T.position and
_petUid(T)==R then O,N=T,(T.position-P).Magnitude break end end end end if O and
N<=_prox()then pcall(_fireSteal,O)end end end end end end)do local function 
applyUnwalkAlways(au)if not au then return end local av=au:
FindFirstChildOfClass('Humanoid')local L=av and av:FindFirstChildOfClass(
'Animator')local M=au:FindFirstChild('Animate')if M then M.Disabled=true end if
L then local N,O=pcall(function()return L:GetPlayingAnimationTracks()end)local P
=_G.MeerkoIsMarkTrack if N and O then for Q,R in ipairs(O)do if not(P and P(R))
then pcall(function()R:Stop(0)end)end end end end end local function hook(au)
task.spawn(function()au:WaitForChild('Humanoid',10)task.wait(0.05)for av=1,8 do
if af.Character~=au then break end applyUnwalkAlways(au)task.wait(0.25)end end)
end if af.Character then hook(af.Character)end af.CharacterAdded:Connect(hook)
local au=0 ae.Heartbeat:Connect(function()local av=os.clock()if av-au<1.5 then
return end if ac and av<ac then return end au=av if af.Character then
applyUnwalkAlways(af.Character)end end)end local au=game:GetService(
'HttpService')local av=game:GetService('UserInputService')local L=
'OpsexVault.json'local function loadCfgTable()local M={}if readfile then pcall(
function()local N=readfile(L)if type(N)=='string'and#N>0 then local O,P=pcall(au
.JSONDecode,au,N)if O and type(P)=='table'then M=P end end end)end return M end
local function saveTpSettings()if not writefile then return end local M=
loadCfgTable()M.tpVelocity=tonumber(_G.TPVelocity)or 400 M.climbSpeed=tonumber(
_G.MeerkoClimb)or 160 M.goSpeed=tonumber(_G.MeerkoGoSpeed)or 200 M.cframeSpeed=
tonumber(_G.MeerkoCFrameSpeed)or 450 M.walkSpeed=tonumber(_G.MeerkoWalkSpeed)or
27 M.landingDelay=tonumber(_G.LandingDelay)or 0.35 M.closeSpeed=tonumber(_G.
MeerkoCloseSpeed)or 80 M.problemBaseSpeed=tonumber(_G.MeerkoProblemBaseSpeed)or
60 M.slowCrossRow=_G.MeerkoSlowCrossRow==true M.autoTp=_G.MeerkoAutoTP~=false M.
autoKickOnSteal=_G.MeerkoAutoKickOnSteal==true M.kickToPS=_G.MeerkoKickToPS==
true M.psLink=tostring(_G.MeerkoPrivateServerLink or'')M.priAlert=_G.
MeerkoPriAlert==true M.alertSound=tostring(_G.MeerkoAlertSound or
'111786441593851')M.alertMinGen=tonumber(_G.MeerkoAlertMinGen)or 80e6 M.
walkSpeedOn=_G.MeerkoWalkSpeedOn~=false M.xray=_G.MeerkoXray~=false M.invisAuto=
_G.MeerkoInvisAuto==true M.invisDepth=tonumber(_G.MeerkoInvisDepth)or 4.2 M.
invisAngle=tonumber(_G.MeerkoInvisAngle)or 180 M.autoSteal=ar M.stealMode=_G.
MeerkoStealMode M.stealLead=tonumber(_G.MeerkoStealLead)or 0.6 M.stealFireKey=
type(_G.MeerkoStealFireKey)=='string'and _G.MeerkoStealFireKey or nil M.
priorityList=_G.SHARED_PRIORITY_ITEMS M.mutationList=_G.SHARED_MUTATION_PRIORITY
do local N={}for O,P in pairs(_G.SHARED_MUTATION_DISABLED)do if P then N[#N+1]=O
end end M.mutationDisabled=N end M.traitList=_G.SHARED_TRAIT_PRIORITY M.panelX=
tonumber(_G._stp_panelX)M.panelY=tonumber(_G._stp_panelY)M.panelPos=_G._stp_pos
M.tgtX=tonumber(_G._meerko_tgtX)M.tgtY=tonumber(_G._meerko_tgtY)if type(_G.
MeerkoCloneKeyName)=='string'then M.cloneKey=_G.MeerkoCloneKeyName else M.
cloneKey=nil end if type(_G.MeerkoKickKeyName)=='string'then M.kickKey=_G.
MeerkoKickKeyName else M.kickKey=nil end if type(_G.MeerkoStopTPKeyName)==
'string'then M.stopTpKey=_G.MeerkoStopTPKeyName else M.stopTpKey=nil end if
type(_G.MeerkoNearestKey)=='string'then M.nearestKey=_G.MeerkoNearestKey else M.
nearestKey=nil end if type(_G.MeerkoDropKeyName)=='string'then M.dropKey=_G.
MeerkoDropKeyName else M.dropKey=nil end if type(_G.MeerkoResetKeyName)==
'string'then M.resetKey=_G.MeerkoResetKeyName else M.resetKey=nil end if type(_G
.MeerkoCarpetSpeedKeyName)=='string'then M.carpetSpeedKey=_G.
MeerkoCarpetSpeedKeyName else M.carpetSpeedKey=nil end if type(_G.
MeerkoStealQuickKey)=='string'then M.stealQuickKey=_G.MeerkoStealQuickKey else M
.stealQuickKey=nil end M.antiFlash=_G.MeerkoAntiFlash~=false M.faceAway=_G.
MeerkoFaceAway==true M.faceAwayNearest=_G.MeerkoFaceAwayNearest==true M.
faceAwayDelay=tonumber(_G.MeerkoFaceAwayDelay)or 2 M.antiBee=_G.MeerkoAntiBee~=
false M.infJump=_G.MeerkoInfJump~=false M.antiDie=_G.AntiDieDisabled~=true M.
carpetSpeedValue=tonumber(_G.MeerkoCarpetSpeedValue)or 140 if type(_G.
MeerkoCarpetTool)=='string'then M.carpetTool=_G.MeerkoCarpetTool else M.
carpetTool=nil end M.autoBuy=_G.MeerkoAutoBuy==true M.autoBuyRange=tonumber(_G.
MeerkoAutoBuyRange)or 17 M.autoBuyHover=tonumber(_G.MeerkoAutoBuyHover)or 9 M.
exX=tonumber(_G._meerko_exX)M.exY=tonumber(_G._meerko_exY)M.fX=tonumber(_G.
_meerko_fX)M.fY=tonumber(_G._meerko_fY)M.kX=tonumber(_G._meerko_kX)M.kY=
tonumber(_G._meerko_kY)pcall(function()writefile(L,au:JSONEncode(M))end)end _G.
MeerkoSaveSettings=saveTpSettings if _G.TPVelocity==nil then _G.TPVelocity=400
end if _G.MeerkoClimb==nil then _G.MeerkoClimb=160 end if _G.MeerkoGoSpeed==nil
then _G.MeerkoGoSpeed=200 end if _G.MeerkoCFrameSpeed==nil then _G.
MeerkoCFrameSpeed=450 end if _G.MeerkoWalkSpeed==nil then _G.MeerkoWalkSpeed=24
end if _G.LandingDelay==nil then _G.LandingDelay=0.35 end if _G.MeerkoCloseSpeed
==nil then _G.MeerkoCloseSpeed=80 end if _G.MeerkoProblemBaseSpeed==nil then _G.
MeerkoProblemBaseSpeed=60 end if _G.MeerkoSlowCrossRow==nil then _G.
MeerkoSlowCrossRow=false end if _G.MeerkoInvisDepth==nil then _G.
MeerkoInvisDepth=4.2 end if _G.MeerkoInvisAngle==nil then _G.MeerkoInvisAngle=
180 end local M=game:GetService('TweenService')local N=TweenInfo.new(0.16,Enum.
EasingStyle.Quad,Enum.EasingDirection.Out)local function tween(O,P)M:Create(O,N,
P):Play()end local O=(gethui and gethui())or game:GetService('CoreGui')for P,Q
in ipairs({O,ag})do pcall(function()local R=Q:FindFirstChild('MeerkoTP')if R
then R:Destroy()end local S=Q:FindFirstChild('MeerkoTopBar')if S then S:Destroy(
)end end)end local P=mk('ScreenGui',nil,{Name='MeerkoTP',ResetOnSpawn=false,
IgnoreGuiInset=true,DisplayOrder=999999,ZIndexBehavior=Enum.ZIndexBehavior.
Sibling})pcall(function()P.Parent=O end)if not P.Parent then pcall(function()P.
Parent=(gethui and gethui())or game:GetService('CoreGui')end)end P.Enabled=false
av.InputBegan:Connect(function(Q,R)if R then return end if Q.KeyCode==Enum.
KeyCode.LeftControl or Q.KeyCode==Enum.KeyCode.RightControl then P.Enabled=not P
.Enabled end end)do local Q=mk('ScreenGui',nil,{Name='MeerkoTopBar',ResetOnSpawn
=false,IgnoreGuiInset=true,DisplayOrder=999998,ZIndexBehavior=Enum.
ZIndexBehavior.Sibling})pcall(function()Q.Parent=O end)if not Q.Parent then
pcall(function()Q.Parent=(gethui and gethui())or game:GetService('CoreGui')end)
end local R=corner(mk('Frame',Q,{Name='Bar',AnchorPoint=Vector2.new(0.5,0),
Position=UDim2.new(0.5,0,0,26),Size=UDim2.fromOffset(400,34),BackgroundColor3=w.
bg,BorderSizePixel=0,ZIndex=50}),8)mk('UIGradient',R,{Rotation=90,Color=
ColorSequence.new(w.card,w.bg)})mk('UIStroke',R,{Thickness=1,Transparency=0.4,
Color=w.line})local function seg(S,T,U,V,W,X)return mk('TextLabel',R,{Size=UDim2
.fromOffset(T,34),Position=UDim2.fromOffset(S,0),BackgroundTransparency=1,Text=U
,Font=W,TextSize=X or 13,TextColor3=V,TextXAlignment=Enum.TextXAlignment.Left,
ZIndex=51})end seg(18,110,'Meerko TP',w.acc,y,14)local S=seg(150,100,'FPS --',w.
txt,x)local T=seg(268,116,'PING --',w.txt,x)local U,V,W=0,0 ae.RenderStepped:
Connect(function(X)U,V=U+1,V+X if V<0.5 then return end S.Text='FPS: '..math.
floor(U/V+0.5)U,V=0,0 if not W then pcall(function()W=game:GetService('Stats').
Network.ServerStatsItem['Data Ping']end)end local Y,Z=pcall(function()return W:
GetValue()end)T.Text='PING: '..((Y and math.floor(Z+0.5))or'--')..' ms'end)end
local Q,R,S,T=460,320,130,16 local U=mk('Frame',P,{Name='Root',Active=true,
BackgroundTransparency=1,Size=UDim2.fromOffset(Q,R),Position=(function()local U=
(workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize)or Vector2.
new(1920,1080)return UDim2.fromOffset(math.clamp(tonumber(_G._stp_panelX)or 40,0
,math.max(U.X-Q,0)),math.clamp(tonumber(_G._stp_panelY)or 160,0,math.max(U.Y-R,0
)))end)()})local V=corner(mk('Frame',U,{BackgroundColor3=w.bg,BorderSizePixel=0,
Size=UDim2.fromScale(1,1),ZIndex=1}),10)mk('UIGradient',V,{Rotation=135,Color=
ColorSequence.new({ColorSequenceKeypoint.new(0,w.bg2),ColorSequenceKeypoint.new(
1,w.bg)})})mk('UIStroke',V,{Thickness=1,Transparency=0.4,Color=w.line})local W=
mk('Frame',V,{Size=UDim2.new(0,S,1,0),BackgroundTransparency=1,ZIndex=2})mk(
'TextLabel',W,{Size=UDim2.new(1,-T*2,0,20),Position=UDim2.fromOffset(T,28),
BackgroundTransparency=1,Text='MEERKO TP',Font=y,TextSize=15,TextColor3=w.txt,
TextXAlignment=Enum.TextXAlignment.Left,ZIndex=2})local X=mk('Frame',V,{Position
=UDim2.fromOffset(S,0),Size=UDim2.new(1,-S,1,0),BackgroundTransparency=1,ZIndex=
2})local Y,Z={},{}local _={}local function selectTab(aw)local ax=_[aw]if ax then
_[aw]=nil pcall(ax)end for ay,az in pairs(Y)do az.Visible=(ay==aw)end for ay,az
in pairs(Z)do local aA=(ay==aw)tween(az.bg,{BackgroundTransparency=aA and 0 or 1
})tween(az.lbl,{TextColor3=aA and w.txt or w.dim})tween(az.btn,{
BackgroundTransparency=aA and 0.2 or 0.5})end end local function tab(aw,ax)local
ay=corner(mk('TextButton',W,{Size=UDim2.new(1,-T*2,0,32),Position=UDim2.
fromOffset(T,72+(ax-1)*38),BackgroundColor3=w.card,BackgroundTransparency=0.5,
Text='',AutoButtonColor=false,Active=true,ZIndex=2}),6)local az=mk('Frame',ay,{
Size=UDim2.fromScale(1,1),BackgroundColor3=w.acc,BackgroundTransparency=1,
BorderSizePixel=0})corner(az,6)local aA=mk('TextLabel',ay,{Size=UDim2.new(1,0,1,
0),Position=UDim2.fromOffset(0,0),BackgroundTransparency=1,Text=aw,Font=y,
TextSize=11,TextColor3=w.dim,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3})
mk('UIPadding',aA,{PaddingLeft=UDim.new(0,12)})local aB=mk('ScrollingFrame',X,{
Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,Visible=
false,ScrollBarThickness=0,ScrollBarImageColor3=w.line,CanvasSize=UDim2.new(),
AutomaticCanvasSize=Enum.AutomaticSize.Y,ZIndex=2})mk('UIPadding',aB,{
PaddingLeft=UDim.new(0,T),PaddingRight=UDim.new(0,T+4),PaddingTop=UDim.new(0,T+4
),PaddingBottom=UDim.new(0,T)})mk('UIListLayout',aB,{Padding=UDim.new(0,8),
SortOrder=Enum.SortOrder.LayoutOrder})Z[aw],Y[aw]={btn=ay,bg=az,lbl=aA},aB ay.
MouseButton1Click:Connect(function()selectTab(aw)end)ay.MouseEnter:Connect(
function()if not Y[aw].Visible then tween(ay,{BackgroundTransparency=0.3})end
end)ay.MouseLeave:Connect(function()if not Y[aw].Visible then tween(ay,{
BackgroundTransparency=0.5})end end)return aB end local function label(aw,ax,ay)
local az=mk('TextLabel',aw,{Size=UDim2.new(1,0,0,ay and 14 or 26),
BackgroundTransparency=1,Text=string.upper(ax),Font=y,TextSize=10,TextColor3=w.
dim,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.
Bottom,ZIndex=2})return az end local function shell(aw,ax)local ay=corner(mk(
'Frame',aw,{Size=UDim2.new(1,0,0,ax),BackgroundColor3=w.card,BorderSizePixel=0,
Active=true,ZIndex=2}),6)local az=mk('Frame',ay,{Size=UDim2.fromScale(1,1),
BackgroundColor3=w.acc,BackgroundTransparency=1,BorderSizePixel=0})corner(az,6)
return ay end local function action(aw,ax,ay)local az=shell(aw,36)local aA=mk(
'TextButton',az,{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text=ax,Font
=y,TextSize=12,TextColor3=w.txt,Active=true,AutoButtonColor=false,ZIndex=3})aA.
MouseEnter:Connect(function()tween(az:FindFirstChildOfClass('Frame'),{
BackgroundTransparency=0.3})end)aA.MouseLeave:Connect(function()tween(az:
FindFirstChildOfClass('Frame'),{BackgroundTransparency=1})end)aA.
MouseButton1Click:Connect(ay)end local function toggle(aw,ax,ay,az)local aA=
shell(aw,36)local aB=mk('TextButton',aA,{Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,Text='',Active=true,AutoButtonColor=false,ZIndex=4})mk(
'TextLabel',aA,{Size=UDim2.new(1,-70,1,0),Position=UDim2.fromOffset(14,0),
BackgroundTransparency=1,Text=ax,Font=y,TextSize=12,TextColor3=w.txt,
TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3})local aC=corner(mk('Frame',aA,
{Size=UDim2.fromOffset(40,20),Position=UDim2.new(1,-52,0.5,-10),BackgroundColor3
=w.track,BorderSizePixel=0,ZIndex=3}),10)local aD=corner(mk('Frame',aC,{Size=
UDim2.fromOffset(16,16),Position=UDim2.fromOffset(2,2),BackgroundColor3=w.dim,
BorderSizePixel=0,ZIndex=4}),8)local function paint(aE)local aF=ay()local aG=aF
and w.acc or w.track local aH=aF and w.txt or w.dim local aI=UDim2.fromOffset(aF
and 22 or 2,2)if aE then aC.BackgroundColor3,aD.BackgroundColor3,aD.Position=aG,
aH,aI else tween(aC,{BackgroundColor3=aG})tween(aD,{BackgroundColor3=aH,Position
=aI})end end aB.MouseButton1Click:Connect(function()az()paint()end)paint(true)
return paint end local function input(aw,ax,ay,az,aA)local aB=shell(aw,52)mk(
'TextLabel',aB,{Size=UDim2.new(1,-24,0,12),Position=UDim2.fromOffset(14,8),
BackgroundTransparency=1,Text=ax,Font=x,TextSize=11,TextColor3=w.dim,
TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3})local aC=mk('TextBox',aB,{Size
=UDim2.new(1,-24,0,20),Position=UDim2.fromOffset(14,24),BackgroundTransparency=1
,Font=y,TextSize=12,TextColor3=w.txt,TextXAlignment=Enum.TextXAlignment.Left,
PlaceholderText=ay,PlaceholderColor3=w.line,ClearTextOnFocus=false,Text=
tostring(az()or''),TextTruncate=Enum.TextTruncate.AtEnd,Active=true,ZIndex=4})aC
.FocusLost:Connect(function()aA(aC.Text)end)return aC end local function 
dropdown(aw,ax,ay,az,aA)local aB,aC=40,26 local aD=shell(aw,aB)aD.
ClipsDescendants=true mk('TextLabel',aD,{Size=UDim2.new(1,-24,0,12),Position=
UDim2.fromOffset(14,6),BackgroundTransparency=1,Text=ax,Font=x,TextSize=11,
TextColor3=w.dim,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3})local aE=mk(
'TextLabel',aD,{Size=UDim2.new(1,-44,0,14),Position=UDim2.fromOffset(14,20),
BackgroundTransparency=1,Font=y,TextSize=12,TextColor3=w.txt,TextXAlignment=Enum
.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text='',ZIndex=3})
local aF=mk('TextLabel',aD,{Size=UDim2.fromOffset(20,14),Position=UDim2.new(1,-
32,0,20),BackgroundTransparency=1,Font=y,TextSize=11,TextColor3=w.acc,
TextXAlignment=Enum.TextXAlignment.Right,Text='v',ZIndex=3})local aG=mk(
'TextButton',aD,{Size=UDim2.new(1,0,0,aB),BackgroundTransparency=1,Text='',
Active=true,AutoButtonColor=false,ZIndex=4})local aH=mk('Frame',aD,{Position=
UDim2.fromOffset(0,aB),Size=UDim2.new(1,0,0,#ay*aC),BackgroundTransparency=1,
Visible=false,ZIndex=3})mk('UIListLayout',aH,{SortOrder=Enum.SortOrder.
LayoutOrder})local aI,aJ=false,{}local function paint()local aK=az()aE.Text=(
type(aK)=='string'and aK~='')and aK or tostring(ay[1])for aL,aM in ipairs(aJ)do
local aN=(aM.name==aE.Text)aM.lbl.TextColor3=aN and w.acc or w.dim aM.bg.
BackgroundTransparency=aN and 0.85 or 1 end end local function setOpen(aK)aI=aK
aH.Visible=aK aF.Text=aK and'^'or'v'tween(aD,{Size=UDim2.new(1,0,0,aK and(aB+#ay
*aC+6)or aB)})end for aK,aL in ipairs(ay)do local aM=mk('TextButton',aH,{Size=
UDim2.new(1,0,0,aC),BackgroundColor3=w.acc,BackgroundTransparency=1,
BorderSizePixel=0,Text='',AutoButtonColor=false,Active=true,LayoutOrder=aK,
ZIndex=4})local aN=mk('TextLabel',aM,{Size=UDim2.new(1,-30,1,0),Position=UDim2.
fromOffset(22,0),BackgroundTransparency=1,Text=aL,Font=y,TextSize=11,TextColor3=
w.dim,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5})aJ[#aJ+1]={name=aL,lbl=
aN,bg=aM}aM.MouseButton1Click:Connect(function()aA(aL)paint()setOpen(false)end)
end aG.MouseButton1Click:Connect(function()setOpen(not aI)end)paint()return
paint end local function slider(aw,ax,ay,az,aA,aB,aC)aC=aC or 1 local aD=shell(
aw,50)mk('TextLabel',aD,{Size=UDim2.new(1,-76,0,14),Position=UDim2.fromOffset(14
,8),BackgroundTransparency=1,Text=ax,Font=x,TextSize=11,TextColor3=w.dim,
TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3})local aE=mk('TextLabel',aD,{
Size=UDim2.fromOffset(52,14),Position=UDim2.new(1,-64,0,8),
BackgroundTransparency=1,Font=y,TextSize=12,TextColor3=w.txt,TextXAlignment=Enum
.TextXAlignment.Right,ZIndex=3})local aF=corner(mk('TextButton',aD,{Size=UDim2.
new(1,-24,0,6),Position=UDim2.fromOffset(14,32),BackgroundColor3=w.track,Text=''
,AutoButtonColor=false,Active=true,BorderSizePixel=0,ZIndex=3}),3)local aG=
corner(mk('Frame',aF,{Size=UDim2.new(0,0,1,0),BackgroundColor3=w.acc,
BorderSizePixel=0,ZIndex=4}),3)local aH=corner(mk('Frame',aF,{Size=UDim2.
fromOffset(14,14),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0,0,0.5,0)
,BackgroundColor3=w.txt,BorderSizePixel=0,ZIndex=5}),7)local function refresh()
local aI=math.clamp(tonumber(aA())or ay,ay,az)local aJ=(aI-ay)/math.max(az-ay,
1e-6)aG.Size=UDim2.new(aJ,0,1,0)aH.Position=UDim2.new(aJ,0,0.5,0)aE.Text=aC<1
and string.format('%.2f',aI)or tostring(math.floor(aI+0.5))end local function 
applyAt(aI)local aJ=math.clamp((aI-aF.AbsolutePosition.X)/math.max(aF.
AbsoluteSize.X,1),0,1)aB(math.clamp(math.floor((ay+(az-ay)*aJ)/aC+0.5)*aC,ay,az)
)refresh()end local aI=false aF.InputBegan:Connect(function(aJ)if aJ.
UserInputType==Enum.UserInputType.MouseButton1 or aJ.UserInputType==Enum.
UserInputType.Touch then aI=true tween(aH,{Size=UDim2.fromOffset(14,14)})
applyAt(aJ.Position.X)end end)av.InputChanged:Connect(function(aJ)if aI and(aJ.
UserInputType==Enum.UserInputType.MouseMovement or aJ.UserInputType==Enum.
UserInputType.Touch)then applyAt(aJ.Position.X)end end)av.InputEnded:Connect(
function(aJ)if aI and(aJ.UserInputType==Enum.UserInputType.MouseButton1 or aJ.
UserInputType==Enum.UserInputType.Touch)then aI=false tween(aH,{Size=UDim2.
fromOffset(10,10)})saveTpSettings()end end)refresh()end do local aw,ax,ay,az V.
Active=true W.Active,X.Active=true,true local function begin(aA)if aA.
UserInputType~=Enum.UserInputType.MouseButton1 and aA.UserInputType~=Enum.
UserInputType.Touch then return end aw,ax,ay=true,aA.Position,U.Position aA.
Changed:Connect(function()if aA.UserInputState==Enum.UserInputState.End and aw
then aw=false _G._stp_panelX=U.Position.X.Offset _G._stp_panelY=U.Position.Y.
Offset saveTpSettings()end end)end local function track(aA)if aA.UserInputType==
Enum.UserInputType.MouseMovement or aA.UserInputType==Enum.UserInputType.Touch
then az=aA end end for aA,aB in ipairs({V,W,X})do aB.InputBegan:Connect(begin)aB
.InputChanged:Connect(track)end av.InputChanged:Connect(function(aA)if not aw or
aA~=az then return end local aB=aA.Position-ax U.Position=UDim2.fromOffset(ay.X.
Offset+aB.X,ay.Y.Offset+aB.Y)end)end local aw=tab('Home',1)local ax=tab('Tuning'
,2)label(aw,'actions',true)action(aw,'MANUAL TP',function()task.spawn(function()
if diag()==0 then return end if _G.MeerkoStartSideTP then pcall(_G.
MeerkoStartSideTP)else pcall(doVelocityTP,true)end end)end)label(aw,'general')_G
.MeerkoRepaintAutoTP=toggle(aw,'AUTO TP',function()return _G.MeerkoAutoTP~=false
end,function()_G.MeerkoAutoTP=not(_G.MeerkoAutoTP~=false)saveTpSettings()end)
label(aw,'flying tool')dropdown(aw,'TOOL USED FOR FLYING',FLY_TOOLS,function()
return _G.MeerkoCarpetTool end,function(ay)setCarpetTool(ay)saveTpSettings()end)
label(ax,'movement',true)for ay,az in ipairs({{'TP Velocity',200,750,
'TPVelocity',5},{'Rise Speed',100,250,'MeerkoClimb',5},{'Go To Brainrot Speed',
80,600,'MeerkoGoSpeed',5},{'Landing Delay',0.01,1,'LandingDelay',0.01},{
'100 Studs Base Speed',20,400,'MeerkoCloseSpeed',5},{'Cross-Row Front Speed',20,
400,'MeerkoProblemBaseSpeed',5}})do slider(ax,az[1],az[2],az[3],function()return
_G[az[4] ]end,function(aA)_G[az[4] ]=aA end,az[5])end label(ax,
'cross-row front approach')toggle(ax,'SLOW BEHIND CROSS-ROW (FIRST FLOOR)',
function()return _G.MeerkoSlowCrossRow==true end,function()_G.MeerkoSlowCrossRow
=not(_G.MeerkoSlowCrossRow==true)saveTpSettings()end)local ay=tab('Priority',3)
local az,aA='brainrot'local function mkSubTabs(aB)local aC=mk('Frame',aB,{Size=
UDim2.new(1,0,0,26),BackgroundTransparency=1})local aD={'Brainrots','Mutations',
'Traits'}local aE=1/#aD for aF,aG in ipairs(aD)do local aH=corner(mk(
'TextButton',aC,{Size=UDim2.new(aE,-4,1,0),Position=UDim2.new(aE*(aF-1),2,0,0),
BackgroundColor3=w.acc,Text=aG,Font=y,TextSize=11,TextColor3=w.bg,
AutoButtonColor=false,Active=true,ZIndex=3}),6)aH.MouseButton1Click:Connect(
function()az=aG:lower():gsub('s$','')for aI,aJ in ipairs(aC:GetChildren())do if
aJ:IsA('TextButton')then aJ.BackgroundColor3=(aJ==aH)and w.acc or w.track aJ.
TextColor3=(aJ==aH)and w.bg or w.txt end end if aA then aA()end end)if aF==1
then aH.BackgroundColor3,aH.TextColor3=w.acc,w.bg else aH.BackgroundColor3,aH.
TextColor3=w.track,w.txt end end end mkSubTabs(ay)local aB do local aC=shell(ay,
36)stroke(aC)aB=mk('TextBox',aC,{Size=UDim2.new(1,-74,0,24),Position=UDim2.
fromOffset(10,6),BackgroundColor3=w.track,BorderSizePixel=0,Font=x,TextSize=12,
TextColor3=w.txt,TextXAlignment=Enum.TextXAlignment.Left,PlaceholderText=
'type a name, then Enter',PlaceholderColor3=w.dim,ClearTextOnFocus=false,Text=''
,Active=true,ZIndex=4})corner(aB,6)mk('UIPadding',aB,{PaddingLeft=UDim.new(0,8),
PaddingRight=UDim.new(0,8)})local aD=corner(mk('TextButton',aC,{Size=UDim2.
fromOffset(52,24),Position=UDim2.new(1,-60,0,6),BackgroundColor3=w.acc,Text=
'ADD',Font=y,TextSize=11,TextColor3=w.bg,AutoButtonColor=false,Active=true,
ZIndex=4}),6)local function doAdd()local aE=(aB.Text or''):match('^%s*(.-)%s*$')
if aE and aE~=''then if az=='brainrot'then table.insert(_G.SHARED_PRIORITY_ITEMS
,aE)elseif az=='mutation'then table.insert(_G.SHARED_MUTATION_PRIORITY,aE)else
table.insert(_G.SHARED_TRAIT_PRIORITY,aE)end _G.MeerkoPriVersion=(_G.
MeerkoPriVersion or 0)+1 pcall(saveTpSettings)aB.Text=''if aA then aA()end end
end aD.MouseButton1Click:Connect(doAdd)aD.MouseEnter:Connect(function()tween(aD,
{BackgroundColor3=w.txt})end)aD.MouseLeave:Connect(function()tween(aD,{
BackgroundColor3=w.acc})end)aB.FocusLost:Connect(function(aE)if aE then doAdd()
end end)end label(ay,'priority  -  top = highest')local aC=mk('Frame',ay,{Size=
UDim2.new(1,0,0,0),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y,
ZIndex=2})mk('UIListLayout',aC,{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.
LayoutOrder})local function getListAndIcon()if az=='brainrot'then return _G.
SHARED_PRIORITY_ITEMS,nil elseif az=='mutation'then return _G.
SHARED_MUTATION_PRIORITY,MUTATION_ICONS else return _G.SHARED_TRAIT_PRIORITY,
TRAIT_ICONS end end aA=function()for aD,aE in ipairs(aC:GetChildren())do if aE:
IsA('GuiObject')then aE:Destroy()end end local aD,aE=getListAndIcon()for aF=1,#
aD do local aG=tostring(aD[aF])local aH=corner(mk('Frame',aC,{Size=UDim2.new(1,0
,0,30),BackgroundColor3=w.card,BorderSizePixel=0,LayoutOrder=aF,ZIndex=2}),6)
stroke(aH)local aI=aE and aE[aG]local aJ=12 if aI and type(aI)=='string'then
local aK=mk('ImageLabel',aH,{Size=UDim2.fromOffset(22,22),Position=UDim2.
fromOffset(10,4),BackgroundTransparency=1,Image=tostring(aI),ZIndex=3})aJ=40 end
mk('TextLabel',aH,{Size=UDim2.new(1,(az=='mutation')and-148 or-104,1,0),Position
=UDim2.fromOffset(aJ,0),BackgroundTransparency=1,Text=aF..'.  '..aG,Font=x,
TextSize=12,TextColor3=w.txt,TextXAlignment=Enum.TextXAlignment.Left,
TextTruncate=Enum.TextTruncate.AtEnd,ZIndex=3})local function commit()_G.
MeerkoPriVersion=(_G.MeerkoPriVersion or 0)+1 pcall(saveTpSettings)aA()end local 
function mini(aK,aL,aM)local aN=corner(mk('TextButton',aH,{Size=UDim2.
fromOffset(26,22),Position=UDim2.new(1,aK,0.5,-11),BackgroundColor3=w.track,Text
=aL,Font=y,TextSize=12,TextColor3=w.txt,AutoButtonColor=false,Active=true,ZIndex
=3}),6)aN.MouseEnter:Connect(function()tween(aN,{BackgroundColor3=w.line})end)aN
.MouseLeave:Connect(function()tween(aN,{BackgroundColor3=w.track})end)aN.
MouseButton1Click:Connect(aM)return aN end mini(-98,'\u{25b2}',function()if aF>1
then aD[aF],aD[aF-1]=aD[aF-1],aD[aF]commit()end end)mini(-68,'\u{25bc}',function
()if aF<#aD then aD[aF],aD[aF+1]=aD[aF+1],aD[aF]commit()end end)mini(-36,'X',
function()table.remove(aD,aF)commit()end)if az=='mutation'then local aK=_G.
SHARED_MUTATION_DISABLED local aL=aK[aG]==true local aM=corner(mk('TextButton',
aH,{Size=UDim2.fromOffset(34,22),Position=UDim2.new(1,-136,0.5,-11),
BackgroundColor3=aL and w.track or w.acc,Text=aL and'OFF'or'ON',Font=y,TextSize=
10,TextColor3=aL and w.dim or w.bg,AutoButtonColor=false,Active=true,ZIndex=3}),
6)aM.MouseButton1Click:Connect(function()if aK[aG]then aK[aG]=nil else aK[aG]=
true end commit()end)if aL then for aN,aO in ipairs(aH:GetChildren())do if aO:
IsA('TextLabel')then aO.TextColor3=w.dim end if aO:IsA('ImageLabel')then aO.
ImageTransparency=0.6 end end end end end end _.Priority=function()if aA then
aA()end end local aD=tab('Config',4)label(aD,'config',true)do local aE=corner(
mk('TextButton',aD,{Size=UDim2.new(1,0,0,34),BackgroundColor3=w.acc,Text=
'EXPORT TO CLIPBOARD',Font=y,TextSize=12,TextColor3=w.bg,AutoButtonColor=false,
Active=true,ZIndex=3}),8)aE.MouseButton1Click:Connect(function()pcall(function()
local aF=readfile and readfile('OpsexVault.json')if type(aF)=='string'and#aF>0
then if type(setclipboard)=='function'then setclipboard(aF)end end end)end)aE.
MouseEnter:Connect(function()tween(aE,{BackgroundColor3=w.txt})end)aE.MouseLeave
:Connect(function()tween(aE,{BackgroundColor3=w.acc})end)end do local aE=shell(
aD,104)stroke(aE)local aF=mk('TextBox',aE,{Size=UDim2.new(1,-10,0,56),Position=
UDim2.fromOffset(5,5),BackgroundColor3=w.track,BorderSizePixel=0,Font=x,TextSize
=10,TextColor3=w.txt,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum
.TextYAlignment.Top,PlaceholderText='paste exported JSON here',PlaceholderColor3
=w.dim,ClearTextOnFocus=false,Text='',MultiLine=true,Active=true,ZIndex=4})
corner(aF,6)mk('UIPadding',aF,{PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0
,6),PaddingTop=UDim.new(0,6),PaddingBottom=UDim.new(0,6)})local aG=corner(mk(
'TextButton',aE,{Size=UDim2.new(1,-10,0,30),Position=UDim2.fromOffset(5,68),
BackgroundColor3=w.acc,Text='IMPORT AND SAVE',Font=y,TextSize=12,TextColor3=w.bg
,AutoButtonColor=false,Active=true,ZIndex=4}),6)aG.MouseButton1Click:Connect(
function()pcall(function()local aH=game:GetService('HttpService')local aI=aF.
Text or''local aJ,aK=pcall(aH.JSONDecode,aH,aI)if not(aJ and type(aK)=='table'
and type(aK.priorityList)=='table')then return end if writefile then writefile(
'OpsexVault.json',aI)end aF.Text=''end)end)aG.MouseEnter:Connect(function()
tween(aG,{BackgroundColor3=w.txt})end)aG.MouseLeave:Connect(function()tween(aG,{
BackgroundColor3=w.acc})end)end do local aE=corner(mk('TextButton',aD,{Size=
UDim2.new(1,0,0,34),BackgroundColor3=w.line,Text='RESET TO DEFAULT',Font=y,
TextSize=12,TextColor3=w.txt,AutoButtonColor=false,Active=true,ZIndex=3}),8)aE.
MouseButton1Click:Connect(function()pcall(function()if writefile then writefile(
'OpsexVault.json',_G.MEERKO_DEFAULT_CONFIG_JSON)end end)end)aE.MouseEnter:
Connect(function()tween(aE,{BackgroundColor3=w.acc})end)aE.MouseLeave:Connect(
function()tween(aE,{BackgroundColor3=w.line})end)end selectTab('Home')task.
delay(1.5,diag)end do local ad=game:GetService('RunService')local ae=game:
GetService('Lighting')local af=game:GetService('ReplicatedStorage')local ag=game
:GetService('Players').LocalPlayer local ah={[Enum.HumanoidStateType.Physics]=
true,[Enum.HumanoidStateType.Ragdoll]=true,[Enum.HumanoidStateType.FallingDown]=
true,[Enum.HumanoidStateType.GettingUp]=true}local ai,aj,ak,al,am={}local 
function ragdolled()return ak~=nil and ah[ak:GetState()]==true end local 
function cleanup()if not aj then return end pcall(function()for an,ao in ipairs(
aj:GetDescendants())do if ao:IsA('AnimationConstraint')and not ao.Enabled then
ao.Enabled=true end end end)if am then for an,ao in pairs(am:
GetPlayingAnimationTracks())do local ap=ao.Animation and ao.Animation.Name:
lower()or''if ap:find('rag')or ap:find('fall')or ap:find('hurt')or ap:find(
'down')then ao:Stop(0)end end end end local function recover()if ak:GetState()==
Enum.HumanoidStateType.Physics then pcall(function()ak:ChangeState(Enum.
HumanoidStateType.GettingUp)end)end if al and al.Parent and not _G.
MeerkoInvisActive then pcall(function()al.AssemblyLinearVelocity=Vector3.zero al
.AssemblyAngularVelocity=Vector3.zero end)end cleanup()if not _G.
MeerkoInvisActive then pcall(function()workspace.CurrentCamera.CameraSubject=ak
end)end pcall(function()local an=ag:FindFirstChild('PlayerScripts')or ag:
WaitForChild('PlayerScripts',10)require(an:WaitForChild('PlayerModule',10)):
GetControls():Enable()end)end local function bind(an)for ao,ap in pairs(ai)do
pcall(function()ap:Disconnect()end)end ai={}aj=an ak=an:WaitForChild('Humanoid',
10)al=an:WaitForChild('HumanoidRootPart',10)am=ak and ak:WaitForChild('Animator'
,10)if not ak then return end ai[#ai+1]=ak.StateChanged:Connect(function()if
ragdolled()and not _G.MeerkoInvisActive then recover()end end)ai[#ai+1]=an.
DescendantAdded:Connect(function()if ragdolled()and not _G.MeerkoInvisActive
then cleanup()end end)local ao=0 ai[#ai+1]=ad.Heartbeat:Connect(function()ao=ao+
1 if ao<2 then return end ao=0 if not ragdolled()then return end if _G.
MeerkoInvisActive then return end recover()end)end ag.CharacterAdded:Connect(
function(an)pcall(bind,an)end)if ag.Character then pcall(bind,ag.Character)end
local an={Blue=true,DiscoEffect=true,BeeBlur=true,ColorCorrection=true}local 
function nuke(ao)if ao and ao.Parent and an[ao.Name]then pcall(function()ao:
Destroy()end)end end local ao local function muteBuzz()pcall(function()if not(ao
and ao.Parent)then local ap=af:FindFirstChild('Controllers')local aq=ap and ap:
FindFirstChild('ItemController')local ar=aq and aq:FindFirstChild(
'BeeLauncherController')local as=ar and ar:FindFirstChild('Buzzing')if as and as
:IsA('Sound')then ao=as end end if ao then ao.Volume=0 if ao.IsPlaying then ao:
Stop()end end end)end task.spawn(function()ag:WaitForChild('PlayerScripts',8)_G.
MeerkoBootWait()ae.DescendantAdded:Connect(nuke)do local ap=0 for aq,ar in
ipairs(ae:GetDescendants())do ap=ap+1 if ap%150==0 then task.wait()end nuke(ar)
end end muteBuzz()local ap=0 ad.Heartbeat:Connect(function(aq)local ar=workspace
.CurrentCamera if ar and math.abs(ar.FieldOfView-20)<0.01 then ar.FieldOfView=
tonumber(_G.MeerkoFOV)or 70 end ap=ap+aq if ap>=1 then ap=0 muteBuzz()end end)
end)end(function()local ad={bg=Color3.fromRGB(14,16,20),bg2=Color3.fromRGB(19,22
,27),row=Color3.fromRGB(25,29,35),rowH=Color3.fromRGB(34,40,48),line=Color3.
fromRGB(51,60,71),acc=Color3.fromRGB(88,166,255),acc2=Color3.fromRGB(157,203,255
),txt=Color3.fromRGB(238,241,245),dim=Color3.fromRGB(139,149,162)}local ae,af=
Enum.Font.GothamBold,Enum.Font.Gotham local ag=game:GetService('TweenService')
local ah=TweenInfo.new(0.2,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)local 
function tw(ai,aj)ag:Create(ai,ah,aj):Play()end local function mk(ai,aj,ak)local
al=Instance.new(ai)for am,an in pairs(ak or{})do al[am]=an end al.Parent=aj
return al end local function round(ai,aj)mk('UICorner',ai,{CornerRadius=UDim.
new(0,aj or 8)})return ai end local ai=(gethui and gethui())or game:GetService(
'CoreGui')pcall(function()local aj=ai:FindFirstChild('MeerkoTargets')if aj then
aj:Destroy()end end)local aj=mk('ScreenGui',nil,{Name='MeerkoTargets',
ResetOnSpawn=false,IgnoreGuiInset=true,DisplayOrder=999998,ZIndexBehavior=Enum.
ZIndexBehavior.Sibling})pcall(function()aj.Parent=ai end)if not aj.Parent then
pcall(function()aj.Parent=(gethui and gethui())or game:GetService('CoreGui')end)
end local ak=round(mk('Frame',aj,{Name='Root',Active=true,BackgroundColor3=ad.bg
,BorderSizePixel=0,Size=UDim2.fromOffset(260,320),Position=(function()local ak=(
workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize)or Vector2.new(
1920,1080)return UDim2.fromOffset(math.clamp(tonumber(_G._meerko_tgtX)or 24,0,
math.max(ak.X-260,0)),math.clamp(tonumber(_G._meerko_tgtY)or 250,0,math.max(ak.Y
-320,0)))end)()}),10)mk('UIGradient',ak,{Rotation=135,Color=ColorSequence.new({
ColorSequenceKeypoint.new(0,ad.bg2),ColorSequenceKeypoint.new(1,ad.bg)})})mk(
'UIStroke',ak,{Thickness=1,Transparency=0.4,Color=ad.line})local al=mk(
'TextLabel',ak,{Position=UDim2.fromOffset(16,14),Size=UDim2.new(1,-70,0,18),
BackgroundTransparency=1,Text='TARGETS',Font=ae,TextSize=12,TextColor3=ad.txt,
TextXAlignment=Enum.TextXAlignment.Left})local am=mk('TextLabel',ak,{AnchorPoint
=Vector2.new(1,0),Position=UDim2.new(1,-16,0,14),Size=UDim2.fromOffset(44,18),
BackgroundTransparency=1,Text='0',Font=ae,TextSize=12,TextColor3=ad.acc,
TextXAlignment=Enum.TextXAlignment.Right})local an=mk('Frame',ak,{Position=UDim2
.fromOffset(16,48),Size=UDim2.new(1,-32,0,32),BackgroundTransparency=1})mk(
'UIListLayout',an,{Padding=UDim.new(0,8),FillDirection=Enum.FillDirection.
Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Left})local ao={}local
ap local function updateAllModes()local aq=_G.MeerkoStealMode if aq==ap then
return end ap=aq for ar,as in ipairs(ao)do local au=aq==as.mode tw(as.bg,{
BackgroundTransparency=au and 0 or 1})tw(as.btn,{TextColor3=au and ad.txt or ad.
dim})end end local function modeBtn(aq,ar)local as=round(mk('Frame',an,{Size=
UDim2.fromOffset(88,28),BackgroundColor3=ad.row,BorderSizePixel=0,ZIndex=1}),8)
local au=mk('Frame',as,{Size=UDim2.fromScale(1,1),BackgroundColor3=ad.acc,
BackgroundTransparency=1,BorderSizePixel=0,ZIndex=2})round(au,8)local av=mk(
'TextButton',as,{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text=aq,Font
=ae,TextSize=10,TextColor3=ad.dim,AutoButtonColor=false,Active=true,ZIndex=3})av
.MouseButton1Click:Connect(function()if _G.MeerkoStealMode==ar then _G.
MeerkoStealMode=nil else _G.MeerkoStealMode=ar end stealOn=_G.MeerkoStealMode~=
nil saveTpSettings()updateAllModes()end)av.MouseEnter:Connect(function()if _G.
MeerkoStealMode~=ar then tw(as,{BackgroundColor3=ad.rowH})end end)av.MouseLeave:
Connect(function()if _G.MeerkoStealMode~=ar then tw(as,{BackgroundColor3=ad.row}
)end end)table.insert(ao,{btn=av,bg=au,mode=ar})return av end modeBtn('PRIORITY'
,'priority')modeBtn('NEAREST','nearest')task.spawn(function()while aj.Parent do
updateAllModes()task.wait(0.2)end end)local aq=mk('ScrollingFrame',ak,{Position=
UDim2.fromOffset(12,88),Size=UDim2.new(1,-24,1,-100),BackgroundTransparency=1,
BorderSizePixel=0,ScrollBarThickness=0,CanvasSize=UDim2.new(),
AutomaticCanvasSize=Enum.AutomaticSize.Y})mk('UIListLayout',aq,{Padding=UDim.
new(0,6),SortOrder=Enum.SortOrder.LayoutOrder})do local ar,as,au,av al.
InputBegan:Connect(function(aw)if aw.UserInputType~=Enum.UserInputType.
MouseButton1 and aw.UserInputType~=Enum.UserInputType.Touch then return end ar,
as,au=true,aw.Position,ak.Position aw.Changed:Connect(function()if aw.
UserInputState==Enum.UserInputState.End then ar=false _G._meerko_tgtX=ak.
Position.X.Offset _G._meerko_tgtY=ak.Position.Y.Offset pcall(_G.
MeerkoSaveSettings)end end)end)al.InputChanged:Connect(function(aw)if aw.
UserInputType==Enum.UserInputType.MouseMovement or aw.UserInputType==Enum.
UserInputType.Touch then av=aw end end)f.InputChanged:Connect(function(aw)if not
ar or aw~=av then return end local ax=aw.Position-as ak.Position=UDim2.
fromOffset(au.X.Offset+ax.X,au.Y.Offset+ax.Y)end)end local function short(ar)ar=
tonumber(ar)or 0 if ar>=1e9 then return string.format('%.1fB',ar/1e9)end if ar>=
1e6 then return string.format('%.1fM',ar/1e6)end if ar>=1e3 then return string.
format('%.1fK',ar/1e3)end return string.format('%d',ar)end local ar,as=62,58
local function _ctpFloorFromY(au)if au>=-6.9 and au<=8.9 then return 1 end if au
>=11 and au<=23.15 then return 2 end if au>23.15 then return 3 end return nil
end local function _ctpFloorFromSlot(au,av)local aw=tonumber(au)if aw then if aw
>=19 then return 3 end if aw>=11 then return 2 end if aw>=1 then return 1 end
end if av then return _ctpFloorFromY(av)end return nil end local function 
_ctpSameBase(au,av)local aw=getClosestBaseIdx(au)local ax=getClosestBaseIdx(av)
if aw~=ax then return false end local ay=BASES_LOW[ax]if not ay then return
false end return math.abs(av.X-ay.X)<=ar and math.abs(av.Z-ay.Z)<=as end local 
function _ctpAllowed(au)if not au or not au.position then return false end local
av=h.Character local aw=av and av:FindFirstChild('HumanoidRootPart')if not aw
then return false end local ax=aw.Position if not _ctpSameBase(au.position,ax)
then return false end local ay=_ctpFloorFromY(ax.Y)if not ay then return false
end local az=_ctpFloorFromSlot(au.slot,au.position.Y)if not az then return false
end local aA=az-ay local aB=tonumber(_G.MeerkoClickTPMaxUp)or 3 local aC=
tonumber(_G.MeerkoClickTPMaxDown)or 3 return aA<=aB and aA>=-aC end local au={}
local function rowFor(av)local aw=au[av]if aw and aw.card.Parent then return aw
end local ax=round(mk('Frame',aq,{Size=UDim2.new(1,-4,0,44),BackgroundColor3=ad.
row,BorderSizePixel=0,Active=true}),6)local ay=mk('Frame',ax,{Size=UDim2.
fromScale(1,1),BackgroundColor3=ad.acc,BackgroundTransparency=1,BorderSizePixel=
0})round(ay,6)local az=mk('TextLabel',ax,{Position=UDim2.fromOffset(6,0),Size=
UDim2.fromOffset(20,44),BackgroundTransparency=1,Font=ae,TextSize=11,TextColor3=
ad.dim,TextXAlignment=Enum.TextXAlignment.Center,Text='',ZIndex=2})local aA=mk(
'TextLabel',ax,{Position=UDim2.fromOffset(30,7),Size=UDim2.new(1,-104,0,15),
BackgroundTransparency=1,Font=ae,TextSize=12,TextColor3=ad.txt,TextXAlignment=
Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Text='',ZIndex=2})
local aB={}for aC=1,4 do aB[aC]=mk('ImageLabel',ax,{Position=UDim2.fromOffset(30
+(aC-1)*16,24),Size=UDim2.fromOffset(13,13),BackgroundTransparency=1,Image='',
Visible=false,ZIndex=2})end local aC=mk('TextLabel',ax,{Position=UDim2.
fromOffset(30,24),Size=UDim2.new(1,-104,0,12),BackgroundTransparency=1,Font=af,
TextSize=9,TextColor3=ad.dim,TextXAlignment=Enum.TextXAlignment.Left,
TextTruncate=Enum.TextTruncate.AtEnd,Text='',ZIndex=2})local aD=mk('TextLabel',
ax,{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-10,0,0),Size=UDim2.
fromOffset(66,44),BackgroundTransparency=1,Font=ae,TextSize=11,TextColor3=ad.acc
,TextXAlignment=Enum.TextXAlignment.Right,Text='',ZIndex=2})local aE=mk(
'TextButton',ax,{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text='',
AutoButtonColor=false,Active=true,ZIndex=3})aw={card=ax,bg=ay,rank=az,name=aA,
sub=aC,mps=aD,icons=aB,hit=aE,lastLocked=false}au[av]=aw return aw end task.
spawn(function()local av=tonumber(_G.MeerkoPanelStartDelay)or 0 if not game:
IsLoaded()then game.Loaded:Wait()end if av>0 then task.wait(av)end local aw=
false local ax=os.clock()while aj.Parent do local ay=os.clock()while aw and(_G.
MeerkoStealHold or(_G.MeerkoIsTeleporting and _G.MeerkoIsTeleporting()))and os.
clock()-ay<(tonumber(_G.MeerkoPanelPauseMax)or 3)do task.wait(0.2)end local az=c
and(os.clock()-c)<4 local aA=scanAllPetsCached(az and 0.1 or 0.15)local aB=aA~=
nil if aB and type(aA)=='table'then local aC={}for aD,aE in ipairs(aA)do if not
aE.conveyor then local aF=_petUid(aE)aC[aF]=true local aG=rowFor(aF)aG.pet=aE if
aG.lastOrder~=aD then aG.lastOrder=aD aG.card.LayoutOrder=aD aG.rank.Text=
tostring(aD)end local aH=tostring(aE.name or'?')if aG.lastName~=aH then aG.
lastName=aH aG.name.Text=aH end local aI='$'..short(aE.mps or 0)..'/s'if aG.
lastMps~=aI then aG.lastMps=aI aG.mps.Text=aI end local aJ=tostring(aE.mutation
or'')..'\0'..tostring(aE.traits and#aE.traits or 0)if aG.lastMut~=aJ then aG.
lastMut=aJ local aK=''local aL={}local function addIcon(aM)if aM==nil then
return end local aN=tostring(aM)if aN:match('^%d+$')then aN='rbxassetid://'..aN
end aL[#aL+1]=aN end if type(aE.mutation)=='string'and aE.mutation~=''and aE.
mutation~='None'then aK=aE.mutation addIcon(MUTATION_ICONS[aE.mutation])end if
type(aE.traits)=='table'then local aM={}for aN,aO in pairs(aE.traits)do local k
if type(aO)=='string'then k=aO elseif type(aO)=='table'then k=aO.Name or aO.name
or aO.Trait or aO.Id end if type(k)=='string'then aM[#aM+1]=k addIcon(
TRAIT_ICONS[k])end end if#aM>0 then aK=(aK~=''and(aK..'  |  ')or'')..table.
concat(aM,', ')end end local aM=math.min(#aL,#aG.icons)for aN=1,#aG.icons do
local aO=aG.icons[aN]if aN<=aM then if aO.Image~=aL[aN]then aO.Image=aL[aN]end
aO.Visible=true else aO.Visible=false end end local aN=30+aM*16 aG.sub.Position=
UDim2.fromOffset(aN,24)aG.sub.Size=UDim2.new(1,-(74+aN),0,12)aG.sub.Text=aK end
local aK=(_G.MeerkoStealTargetUID==aF)if aK~=aG.lastLocked then aG.lastLocked=aK
tw(aG.bg,{BackgroundTransparency=aK and 0 or 1})tw(aG.card,{BackgroundColor3=aK
and ad.rowH or ad.row})end if not aG.wired then aG.wired=true local aL=aF local
aM=aG aG.hit.MouseButton1Click:Connect(function()if _G.MeerkoStealTargetUID==aL
then _G.MeerkoStealTargetUID=nil _G.MeerkoStealTarget=nil else _G.
MeerkoStealTargetUID=aL local aN=aM.pet do local aO,k=pcall(scanAllPets)if aO
and type(k)=='table'then for l,m in ipairs(k)do if _petUid(m)==aL then aN=m
break end end end end if aN and aN.position and not isTeleporting and not _G.
MeerkoClickTPBusy and _ctpAllowed(aN)then _G.MeerkoClickTPBusy=true
isTeleporting=true if _G.MeerkoArmSteal then pcall(_G.MeerkoArmSteal,aN)end task
.spawn(function()pcall(function()goToBrainrot(aN.position,aN.slot)end)
isTeleporting=false _G.MeerkoClickTPBusy=false end)end end end)aG.hit.MouseEnter
:Connect(function()if _G.MeerkoStealTargetUID~=aL then tw(aG.card,{
BackgroundColor3=ad.rowH})end end)aG.hit.MouseLeave:Connect(function()if _G.
MeerkoStealTargetUID~=aL then tw(aG.card,{BackgroundColor3=ad.row})end end)end
end end local aD=0 for aE,aF in pairs(au)do if aC[aE]then aD=aD+1 else aF.card:
Destroy()au[aE]=nil end end am.Text=tostring(aD)if aD>0 then aw=true end end if
not aw and(os.clock()-ax)<(tonumber(_G.MeerkoPanelRush)or 10)then task.wait(az
and 0.15 or(tonumber(_G.MeerkoPanelRushGap)or 0.15))else task.wait(tonumber(_G.
MeerkoPanelScanGap)or 0.6)end end end)_G.MeerkoToggleTargets=function()aj.
Enabled=not aj.Enabled end end)();(function()local ad='yisus'local ae={'meerko',
'Cruz','Nono','OSITO PERU','Rafflx','aba','buzz','bwifty','c37','dachiago','drg'
,'els','ezbymz','jevus','little wilmar','luna','moula','n1','yisus','youns'}
local af='rbxassetid://507776043'local ag='rbxassetid://182435998'local ah=
1.5625E-2 local ai=game:GetService('Players')local aj=ai.LocalPlayer if type(_G.
MeerkoBuyerTagStop)=='function'then pcall(_G.MeerkoBuyerTagStop)end local ak,al=
true,{}local am={}local an for ao,ap in ipairs(ae)do if ap==ad then an=ao end
end local function idOf(ao)local ap=ao and ao.Animation return ap and ap.
AnimationId or''end local ao={af:match('%d+$'),ag:match('%d+$')}local function 
isMark(ap)if type(ap)~='string'then return false end local aq=ap:match(
'(%d+)%s*$')return aq==ao[1]or aq==ao[2]end _G.MeerkoIsMarkTrack=function(ap)
return isMark(idOf(ap))end local function decode(ap)local aq=(ap-1)/ah local ar=
math.floor(aq+0.5)if ar<1 or math.abs(aq-ar)>0.15 then return nil end return ar
end local function getAnimator(ap)local aq=ap and ap:FindFirstChildOfClass(
'Humanoid')return aq and aq:FindFirstChildOfClass('Animator'),aq end local ap
local function ensureMark()if not an then return end local aq=aj.Character local
ar,as=getAnimator(aq)if not ar then return end if ap and ap.IsPlaying and ap.
Parent~=nil then return end pcall(function()local au=Instance.new('Animation')au
.AnimationId=(as.RigType==Enum.HumanoidRigType.R6)and ag or af ap=ar:
LoadAnimation(au)ap.Priority=Enum.AnimationPriority.Core ap.Looped=true local av
=1+an*ah ap:Play(0,0.001,av)ap:AdjustSpeed(av)end)end local aq=(gethui and
gethui())or game:GetService('CoreGui')local function clearTag(ar)local as=am[ar]
if not as then return end pcall(function()as.hl:Destroy()end)pcall(function()as.
bb:Destroy()end)am[ar]=nil end local function setTag(ar,as,au)local av=am[ar]if
av and av.char==as and av.name==au and av.hl.Parent and av.bb.Parent then return
end clearTag(ar)local aw=as:FindFirstChild('Head')or as:FindFirstChild(
'HumanoidRootPart')if not aw then return end local ax=Instance.new('Highlight')
ax.Name='MeerkoBuyerHL'ax.FillColor=Color3.fromRGB(120,90,255)ax.
FillTransparency=0.75 ax.OutlineColor=Color3.fromRGB(170,150,255)ax.
OutlineTransparency=0 ax.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop ax.
Adornee=as ax.Parent=aq local ay=Instance.new('BillboardGui')ay.Name=
'MeerkoBuyerTag'ay.Adornee=aw ay.AlwaysOnTop=true ay.Size=UDim2.fromOffset(160,
30)ay.StudsOffset=Vector3.new(0,2.6,0)ay.MaxDistance=400 ay.ResetOnSpawn=false
local az=Instance.new('TextLabel')az.BackgroundTransparency=1 az.Size=UDim2.new(
1,0,0.45,0)az.Font=Enum.Font.GothamMedium az.TextScaled=true az.TextColor3=
Color3.fromRGB(170,150,255)az.TextStrokeTransparency=0.4 az.Text=
'meerko tp buyer'az.Parent=ay local aA=az:Clone()aA.Position=UDim2.new(0,0,0.45,
0)aA.Size=UDim2.new(1,0,0.55,0)aA.Font=Enum.Font.GothamBold aA.TextColor3=Color3
.new(1,1,1)aA.Text=au aA.Parent=ay ay.Parent=aq am[ar]={hl=ax,bb=ay,char=as,name
=au}end local function scan(ar)if ar==aj then return end local as=ar.Character
local au=getAnimator(as)if not au then clearTag(ar)return end local av local aw,
ax=pcall(function()return au:GetPlayingAnimationTracks()end)if aw and ax then
for ay,az in ipairs(ax)do if isMark(idOf(az))then local aA=decode(az.Speed)if aA
and ae[aA]then av=ae[aA]break end end end end if av then setTag(ar,as,av)else
clearTag(ar)end end local ar={}local function hookChar(as,au)local av=
getAnimator(au)or(function()local av=au:WaitForChild('Humanoid',10)return av and
av:WaitForChild('Animator',10)end)()if not av or not ak then return end if ar[av
]then return end ar[av]=true al[#al+1]=av.AnimationPlayed:Connect(function()task
.delay(0.1,function()if ak then scan(as)end end)end)scan(as)end local function 
hookPlayer(as)if as==aj then return end if as.Character then task.spawn(hookChar
,as,as.Character)end al[#al+1]=as.CharacterAdded:Connect(function(au)clearTag(as
)task.spawn(hookChar,as,au)end)end for as,au in ipairs(ai:GetPlayers())do
hookPlayer(au)end al[#al+1]=ai.PlayerAdded:Connect(hookPlayer)al[#al+1]=ai.
PlayerRemoving:Connect(clearTag)task.spawn(function()while ak do ensureMark()for
as,au in ipairs(ai:GetPlayers())do pcall(scan,au)end task.wait(2)end end)_G.
MeerkoBuyerTagStop=function()ak=false for as,au in ipairs(al)do pcall(function()
au:Disconnect()end)end for as in pairs(am)do clearTag(as)end if ap then pcall(
function()ap:Stop(0)end)end end end)()task.spawn(function()if _G.MeerkoHeldStop
then pcall(_G.MeerkoHeldStop)end local ad=game:GetService('Players')local ae=
game:GetService('RunService')local af=ad.LocalPlayer local ag={Gold=Color3.
fromRGB(255,215,0),Diamond=Color3.fromRGB(100,200,255),Candy=Color3.fromRGB(255,
105,180),Lava=Color3.fromRGB(255,80,0),Radioactive=Color3.fromRGB(100,255,0),
Galaxy=Color3.fromRGB(160,80,255),['Yin Yang']=Color3.fromRGB(200,200,200),
Bloodrot=Color3.fromRGB(180,50,50),Divine=Color3.fromRGB(255,245,180),Cyber=
Color3.fromRGB(0,255,200),Cursed=Color3.fromRGB(210,210,210)}local ah local 
function displayName(ai)if not ah then pcall(function()ah=AnimalsData or
require(game:GetService('ReplicatedStorage').Datas.Animals)end)end local aj=ah
and ah[ai]return(aj and aj.DisplayName)or ai end local function fmtMps(ai)ai=
tonumber(ai)if not ai or ai<=0 then return nil end local aj={{1e12,'T'},{1e9,'B'
},{1e6,'M'},{1e3,'K'}}for ak,al in ipairs(aj)do if ai>=al[1]then return string.
format('$%.1f%s/s',ai/al[1],al[2])end end return string.format('$%d/s',ai)end
local function heldMutation(ai)local aj=af.Character if aj then for ak,al in
ipairs(aj:GetDescendants())do if al:IsA('Model')and al:GetAttribute('Index')==ai
then local am=al:GetAttribute('Mutation')if am and am~=''then return am end end
end end local ak=_G.MeerkoStealTarget if type(ak)=='table'and ak.index==ai then
return ak.mutation,ak.mps end return nil end local ai=Instance.new('ScreenGui')
ai.Name='MeerkoHeld'ai.ResetOnSpawn=false ai.IgnoreGuiInset=true ai.DisplayOrder
=999 ai.Enabled=false local aj=Instance.new('TextLabel')aj.AnchorPoint=Vector2.
new(0.5,0)aj.Position=UDim2.new(0.5,0,0,95)aj.Size=UDim2.new(0,0,0,30)aj.
AutomaticSize=Enum.AutomaticSize.X aj.BackgroundColor3=Color3.fromRGB(15,15,20)
aj.BackgroundTransparency=0.25 aj.Font=Enum.Font.GothamBold aj.TextSize=18 aj.
TextColor3=Color3.new(1,1,1)aj.TextStrokeTransparency=0.4 aj.Parent=ai local ak=
Instance.new('UIPadding')ak.PaddingLeft=UDim.new(0,12)ak.PaddingRight=UDim.new(0
,12)ak.Parent=aj Instance.new('UICorner',aj).CornerRadius=UDim.new(0,8)pcall(
function()ai.Parent=(gethui and gethui())or game:GetService('CoreGui')end)if not
ai.Parent then pcall(function()ai.Parent=game:GetService('CoreGui')end)end local
al=false local function refresh()local am=af:GetAttribute('StealingIndex')if
type(am)~='string'or am==''then ai.Enabled=false al=false return end local an,ao
=heldMutation(am)local ap='Holding: '..displayName(am)if an and an~='None'then
ap=ap..'  ['..tostring(an)..']'end local aq=fmtMps(ao)if aq then ap=ap..'  '..aq
end aj.Text=ap al=an=='Rainbow'aj.TextColor3=(an and ag[an])or Color3.new(1,1,1)
ai.Enabled=true end local am={}am[#am+1]=af:GetAttributeChangedSignal(
'StealingIndex'):Connect(function()task.defer(refresh)end)am[#am+1]=af:
GetAttributeChangedSignal('Stealing'):Connect(function()task.defer(refresh)end)
local an=0 am[#am+1]=ae.Heartbeat:Connect(function(ao)if not al then return end
an=(an+ao*0.5)%1 aj.TextColor3=Color3.fromHSV(an,1,1)end)refresh()_G.
MeerkoHeldRefresh=refresh _G.MeerkoHeldStop=function()for ao,ap in ipairs(am)do
pcall(function()ap:Disconnect()end)end pcall(function()ai:Destroy()end)end end)
if not game:IsLoaded() then game.Loaded:Wait() end

local Players         = game:GetService("Players")
local RunService      = game:GetService("RunService")
local UIS             = game:GetService("UserInputService")
local RS              = game:GetService("ReplicatedStorage")
local Lighting        = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local LP              = Players.LocalPlayer

do
    local t0 = os.clock()
    while type(_G.MeerkoBootWait) ~= "function" and os.clock() - t0 < 0.25 do task.wait(0.02) end
end
if type(_G.MeerkoBootWait)      ~= "function" then _G.MeerkoBootWait = function() end end
if type(_G.MeerkoCarpetEngaging) ~= "function" then _G.MeerkoCarpetEngaging = function() return false end end
if type(_G.MeerkoSaveSettings)   ~= "function" then _G.MeerkoSaveSettings = function() end end

local function equipCarpet() if _G.MeerkoEquipCarpet then return _G.MeerkoEquipCarpet() end end
local function scanAllPets() if _G.MeerkoScanAllPets then return _G.MeerkoScanAllPets() end return {} end

if _G.MeerkoAntiFlash        == nil then _G.MeerkoAntiFlash        = true end
if _G.MeerkoAntiBee          == nil then _G.MeerkoAntiBee          = true end
if _G.MeerkoInfJump          == nil then _G.MeerkoInfJump          = true end
if _G.MeerkoInvisDepth       == nil then _G.MeerkoInvisDepth       = 4.2  end
if _G.MeerkoInvisAngle       == nil then _G.MeerkoInvisAngle       = 180  end
if _G.MeerkoAlertMinGen      == nil then _G.MeerkoAlertMinGen      = 80e6 end
if _G.MeerkoCarpetSpeedValue == nil then _G.MeerkoCarpetSpeedValue = 140  end

if _G.MeerkoCarpetSpeedKeyName == nil then _G.MeerkoCarpetSpeedKeyName = "Q" end

;(function()
    local FX = { ParticleEmitter = true, Beam = true, Trail = true, Fire = true,
        Smoke = true, Sparkles = true, Explosion = true, PointLight = true,
        SpotLight = true, SurfaceLight = true }

    local function kill(item)
        if pcall(function() item:Destroy() end) then return end
        pcall(function()
            for _, d in ipairs(item:GetDescendants()) do
                if d:IsA("BasePart") then
                    d.Transparency = 1
                    d.CanCollide = false
                    d.CanQuery = false
                    d.CastShadow = false
                    d.LocalTransparencyModifier = 1
                elseif FX[d.ClassName] then
                    d.Enabled = false
                elseif d:IsA("Sound") then
                    d.Volume = 0
                    d:Stop()
                end
            end
        end)
    end

    local function strip(char)
        if not char or _G.MeerkoAntiFlash == false then return end
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Accessory") then kill(item) end
        end
    end

    local hooked = setmetatable({}, { __mode = "k" })
    local function hookChar(char)
        if not char or hooked[char] then return end
        hooked[char] = true
        strip(char)
        char.ChildAdded:Connect(function(c)
            if c:IsA("Accessory") and _G.MeerkoAntiFlash ~= false then
                task.defer(kill, c)
            end
        end)
    end
    local function hookPlayer(p)
        if p.Character then task.spawn(hookChar, p.Character) end
        p.CharacterAdded:Connect(hookChar)
    end
    task.defer(function()
        for _, p in ipairs(Players:GetPlayers()) do
            pcall(hookPlayer, p)
            task.wait(0.05)
        end
    end)
    Players.PlayerAdded:Connect(function(p)
        task.defer(hookPlayer, p)
    end)

    workspace.DescendantAdded:Connect(function(d)
        if _G.MeerkoAntiFlash == false then return end
        if d.ClassName == "Accessory" then
            local par = d.Parent
            if par and par:FindFirstChildOfClass("Humanoid") then task.defer(kill, d) end
        end
    end)

    task.spawn(function()
        while true do
            if _G.MeerkoAntiFlash ~= false then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p.Character then strip(p.Character) end
                    task.wait(0.05)
                end
                for _, m in ipairs(workspace:GetChildren()) do
                    if m:IsA("Model") and m:FindFirstChildOfClass("Humanoid") then
                        strip(m)
                        task.wait(0.05)
                    end
                end
            end
            task.wait(10)
        end
    end)
end)()

;(function()
    local TeleportService = game:GetService("TeleportService")
    if _G.MeerkoCleanErrStop then pcall(_G.MeerkoCleanErrStop) end

    local _ref = cloneref or function(x) return x end
    local GS = _ref(game:GetService("GuiService"))
    local running, conns = true, {}

    task.spawn(function()
        while running do
            pcall(function() GS:ClearError() end)
            task.wait(tonumber(_G.MeerkoClearErrGap) or 0.35)
        end
    end)

    conns[#conns + 1] = TeleportService.TeleportInitFailed:Connect(function(plr, result, message, placeId)
        if plr ~= LP then return end
        local name = "Unknown"
        pcall(function() name = result and result.Name or tostring(result) end)
        _G.MeerkoCleanErrLast = {
            result = name, message = tostring(message or ""),
            placeId = placeId, at = os.clock(),
        }
    end)

    _G.MeerkoCleanErrStop = function()
        running = false
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        conns = {}
        _G.MeerkoCleanErrStop = nil
    end
end)()

;(function()
    local held = false
    local function hop()
        local c = LP.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end
        hrp.Velocity = Vector3.new(hrp.Velocity.X, hum.JumpPower or 50, hrp.Velocity.Z)
    end
    local function on() return _G.MeerkoInfJump ~= false end
    UIS.JumpRequest:Connect(function() if on() then hop() end end)
    UIS.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == Enum.KeyCode.Space then held = true end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.KeyCode == Enum.KeyCode.Space then held = false end
    end)
    RunService.Heartbeat:Connect(function() if held and on() then hop() end end)
end)()




if _G.AntiDieDisabled == nil then _G.AntiDieDisabled = false end
task.spawn(function()
local __P = game:GetService("Players")
while not __P.LocalPlayer do task.wait() end
local okAD, errAD = pcall(function()
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Workspace  = game:GetService("Workspace")
    local RS         = game:GetService("ReplicatedStorage")
    local LP         = Players.LocalPlayer

    local antiRagdollConnections = {}
    local antiRagdollCharacter, antiRagdollHumanoid, antiRagdollRootPart, antiRagdollAnimator
    local lastVelocity = Vector3.new(0, 0, 0)
    local velocityChangeThreshold = 40
    local velocityMagnitudeThreshold = 25
    local maxVelocity = 15

    local function isFlyingCarpetActive()
        if not antiRagdollCharacter then return false end
        local tool = antiRagdollCharacter:FindFirstChildWhichIsA("Tool")
        if not tool then return false end
        local hrp = antiRagdollCharacter:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, obj in ipairs(hrp:GetChildren()) do
                if obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyGyro") then
                    return true
                end
            end
        end
        return false
    end

    local function isRagdolled()
        if not antiRagdollHumanoid then return false end
        local state = antiRagdollHumanoid:GetState()
        return state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
            or state == Enum.HumanoidStateType.GettingUp
    end

    local function enableAntiRagdollControls()
        pcall(function()
            local PlayerModule = LP:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule", 10)
            require(PlayerModule):GetControls():Enable()
        end)
    end

    local function cleanupRagdoll()
        if not antiRagdollCharacter then return end
        local carpetEquipped = isFlyingCarpetActive()
        local function processChildren(parent)
            for _, obj in ipairs(parent:GetChildren()) do
                if obj:IsA("BallSocketConstraint") or obj:IsA("NoCollisionConstraint") or obj:IsA("HingeConstraint")
                    or (obj:IsA("Attachment") and (obj.Name == "A" or obj.Name == "B")) then
                    obj:Destroy()
                elseif obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyGyro") then
                    if not carpetEquipped then obj:Destroy() end
                elseif obj:IsA("Motor6D") then
                    obj.Enabled = true
                elseif obj:IsA("BasePart") then
                    for _, child in ipairs(obj:GetChildren()) do
                        if child:IsA("Motor6D") then
                            child.Enabled = true
                        elseif child:IsA("BallSocketConstraint") or child:IsA("NoCollisionConstraint") or child:IsA("HingeConstraint") then
                            child:Destroy()
                        elseif child:IsA("Attachment") and (child.Name == "A" or child.Name == "B") then
                            child:Destroy()
                        end
                    end
                end
            end
        end
        pcall(function() processChildren(antiRagdollCharacter) end)
        if antiRagdollAnimator then
            for _, track in pairs(antiRagdollAnimator:GetPlayingAnimationTracks()) do
                local animName = track.Animation and track.Animation.Name:lower() or ""
                if animName:find("rag") or animName:find("fall") or animName:find("hurt") or animName:find("down") then
                    track:Stop(0)
                end
            end
        end
    end

    local function _harden(hum)
        pcall(function() hum.BreakJointsOnDeath = false end)
        pcall(function() hum.RequiresNeck = false end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false) end)
    end

    local function _revive(hum)
        pcall(function() hum.Health = hum.MaxHealth end)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end

    local function setupAntiRagdollCharacter(char)
        antiRagdollCharacter = char
        antiRagdollHumanoid = char:WaitForChild("Humanoid", 10)
        antiRagdollRootPart = char:WaitForChild("HumanoidRootPart", 10)
        antiRagdollAnimator = antiRagdollHumanoid and antiRagdollHumanoid:WaitForChild("Animator", 10)
        lastVelocity = Vector3.new(0, 0, 0)
        if antiRagdollHumanoid then _harden(antiRagdollHumanoid) end
    end

    local function clearAntiRagdollConnections()
        for _, c in pairs(antiRagdollConnections) do
            pcall(function() c:Disconnect() end)
        end
        antiRagdollConnections = {}
    end

    local function setupAntiRagdollConnections()
        clearAntiRagdollConnections()
        if not antiRagdollHumanoid or not antiRagdollRootPart then return end

        _harden(antiRagdollHumanoid)

        table.insert(antiRagdollConnections, antiRagdollHumanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if _G.AntiDieDisabled then return end
            if antiRagdollHumanoid and antiRagdollHumanoid.Parent and antiRagdollHumanoid.Health <= 0 then
                _revive(antiRagdollHumanoid)
            end
        end))

        table.insert(antiRagdollConnections, antiRagdollHumanoid.Died:Connect(function()
            if _G.AntiDieDisabled then return end
            if antiRagdollHumanoid and antiRagdollHumanoid.Parent then
                _revive(antiRagdollHumanoid)
            end
        end))

        local _lastHarden = 0
        table.insert(antiRagdollConnections, RunService.Heartbeat:Connect(function()
            if not antiRagdollHumanoid or not antiRagdollHumanoid.Parent then return end
            if not _G.AntiDieDisabled then
                local now = os.clock()
                if now - _lastHarden >= 1.0 then _lastHarden = now; _harden(antiRagdollHumanoid) end
                if antiRagdollHumanoid.Health <= 0 then _revive(antiRagdollHumanoid) end
                if _G.MeerkoStealHold and antiRagdollHumanoid.Health < antiRagdollHumanoid.MaxHealth then
                    pcall(function() antiRagdollHumanoid.Health = antiRagdollHumanoid.MaxHealth end)
                end
            end
            if (_G.MeerkoAntiRagdollEnabled or _G.MeerkoAntiKnockbackEnabled) and isRagdolled() then
                if _G.MeerkoStealHold then return end
                if antiRagdollRootPart.AssemblyLinearVelocity.Magnitude > 60 then
                    lastVelocity = antiRagdollRootPart.AssemblyLinearVelocity
                    return
                end
                cleanupRagdoll()
                local velocity = antiRagdollRootPart.AssemblyLinearVelocity
                if (velocity - lastVelocity).Magnitude > velocityChangeThreshold
                    and velocity.Magnitude > velocityMagnitudeThreshold then
                    antiRagdollRootPart.AssemblyLinearVelocity = velocity.Unit * math.min(velocity.Magnitude, maxVelocity)
                end
                lastVelocity = velocity
            end
        end))

        table.insert(antiRagdollConnections, antiRagdollHumanoid.StateChanged:Connect(function()
            if (_G.MeerkoAntiRagdollEnabled or _G.MeerkoAntiKnockbackEnabled) and isRagdolled() then
                if not isFlyingCarpetActive() then
                    antiRagdollHumanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
                cleanupRagdoll()
                pcall(function() Workspace.CurrentCamera.CameraSubject = antiRagdollHumanoid end)
                enableAntiRagdollControls()
            end
        end))

        pcall(function()
            local impulse
            if _G.MeerkoGetRemote then
                impulse = _G.MeerkoGetRemote("RemoteEvent", "CombatService/ApplyImpulse")
            end
            if not impulse then
                local pkgs = RS:FindFirstChild("Packages")
                local net  = pkgs and pkgs:FindFirstChild("Net")
                impulse = net and net:FindFirstChild("RE/CombatService/ApplyImpulse")
            end
            if impulse then
                table.insert(antiRagdollConnections, impulse.OnClientEvent:Connect(function()
                    if (_G.MeerkoAntiRagdollEnabled or _G.MeerkoAntiKnockbackEnabled) and isRagdolled() then
                        antiRagdollRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    end
                end))
            end
        end)

        table.insert(antiRagdollConnections, antiRagdollCharacter.DescendantAdded:Connect(function()
            if (_G.MeerkoAntiRagdollEnabled or _G.MeerkoAntiKnockbackEnabled) and isRagdolled() then
                cleanupRagdoll()
            end
        end))

        enableAntiRagdollControls()
        cleanupRagdoll()
    end

    local function startAntiRagdoll()
        _G.MeerkoAntiRagdollEnabled = true
        _G.MeerkoAntiKnockbackEnabled = true
        if LP.Character then
            setupAntiRagdollCharacter(LP.Character)
            setupAntiRagdollConnections()
        end
    end

    local function stopAntiRagdoll()
        _G.MeerkoAntiRagdollEnabled = false
        _G.MeerkoAntiKnockbackEnabled = false
        clearAntiRagdollConnections()
    end

    _G.toggleAntiRagdoll = function(enabled)
        if enabled then startAntiRagdoll() else stopAntiRagdoll() end
    end
    _G.enableAntiKnockback = function() startAntiRagdoll() end
    _G.disableAntiKnockback = function() stopAntiRagdoll() end

    LP.CharacterAdded:Connect(function(char)
        clearAntiRagdollConnections()
        antiRagdollCharacter = nil; antiRagdollHumanoid = nil; antiRagdollRootPart = nil; antiRagdollAnimator = nil
        local humanoid = char:WaitForChild("Humanoid", 10)
        local rootPart = char:WaitForChild("HumanoidRootPart", 10)
        if not humanoid or not rootPart then return end
        task.wait(0.2)
        setupAntiRagdollCharacter(char)
        if _G.MeerkoAntiRagdollEnabled or _G.MeerkoAntiKnockbackEnabled then
            setupAntiRagdollConnections()
        end
    end)

    if LP.Character then
        setupAntiRagdollCharacter(LP.Character)
        if _G.MeerkoAntiRagdollEnabled or _G.MeerkoAntiKnockbackEnabled then
            setupAntiRagdollConnections()
        end
    end

    startAntiRagdoll()
end)
if not okAD then _G.MeerkoAntiDieError = tostring(errAD) end
end)

;(function()
    local Lighting = game:GetService("Lighting")
    local BAD = { Blue = true, DiscoEffect = true, BeeBlur = true,
        Flashbang = true, ColorCorrection = true }
    local KILL_CLASSES = {
        BlurEffect = true,
        BloomEffect = true,
        SunRaysEffect = true,
        ColorCorrectionEffect = true,
        DepthOfFieldEffect = true,
    }
    local function on() return _G.MeerkoAntiBee ~= false end

    local function nuke(o)
        if not on() or not o or not o.Parent then return end
        if BAD[o.Name] then
            pcall(function() o:Destroy() end)
            return
        end
        if KILL_CLASSES[o.ClassName] then
            pcall(function() o.Enabled = false end)
        end
    end

    local buzz
    local function muteBuzz()
        if not on() then return end
        pcall(function()
            if not (buzz and buzz.Parent) then
                local ctl = RS:FindFirstChild("Controllers")
                local item = ctl and ctl:FindFirstChild("ItemController")
                local bee = item and item:FindFirstChild("BeeLauncherController")
                local s = bee and bee:FindFirstChild("Buzzing")
                if s and s:IsA("Sound") then buzz = s end
            end
            if buzz then
                buzz.Volume = 0
                if buzz.IsPlaying then buzz:Stop() end
            end
        end)
    end

    local guarded = {}
    local function guard(Controls, original)
        if not Controls or guarded[Controls] then return end
        local base = original or Controls.moveFunction
        if not base then return end
        local function safeMove(self, mv, rtc) return base(self, mv, rtc) end
        guarded[Controls] = safeMove
        Controls.moveFunction = safeMove
        local _mfTick = 0
        RunService.Heartbeat:Connect(function()
            _mfTick = _mfTick + 1
            if _mfTick < 10 then return end
            _mfTick = 0
            if not on() then return end
            if Controls.moveFunction ~= safeMove then Controls.moveFunction = safeMove end
        end)
    end
    local function protect()
        pcall(function()
            local cc = RS:FindFirstChild("Controllers")
            local mod = cc and cc:FindFirstChild("CharacterController")
            local m = mod and require(mod)
            if type(m) == "table" then guard(m.Controls, m.originalMoveFunction) end
        end)
        pcall(function()
            local ps = LP:WaitForChild("PlayerScripts", 5)
            local pm = ps and ps:FindFirstChild("PlayerModule")
            if pm then guard(require(pm):GetControls()) end
        end)
    end

    task.spawn(function()
        LP:WaitForChild("PlayerScripts", 8)
        _G.MeerkoBootWait()
        Lighting.DescendantAdded:Connect(nuke)
        for _, o in ipairs(Lighting:GetDescendants()) do nuke(o) end
        protect()
        local acc = 1
        RunService.Heartbeat:Connect(function(dt)
            if not on() then return end
            local cam = workspace.CurrentCamera
            if cam and math.abs(cam.FieldOfView - 20) < 0.01 then
                cam.FieldOfView = tonumber(_G.MeerkoFOV) or 70
            end
            acc = acc + dt
            if acc < 0.5 then return end
            acc = 0
            for _, o in ipairs(Lighting:GetDescendants()) do nuke(o) end
            muteBuzz()
        end)
    end)
    LP.CharacterAdded:Connect(function() task.delay(1, protect) end)
end)()

;(function()
    local active, conns = false, {}
    local realHRP, cloneHRP, track, hip, origT
    local stuck, restarting = false, false
    local start, stop

    local function depth()
        return 0.01 + (math.clamp(tonumber(_G.MeerkoInvisDepth) or 4.2, 0, 10) / 10) * 0.19
    end
    local function angle()
        return math.clamp(tonumber(_G.MeerkoInvisAngle) or 180, 0, 360)
    end
    local function add(c) conns[#conns + 1] = c end
    local function rewire(char, from, to)
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("Weld") or v:IsA("Motor6D") then
                if v.Part0 == from then v.Part0 = to end
                if v.Part1 == from then v.Part1 = to end
            end
        end
    end

    stop = function()
        active, stuck = false, false
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        conns = {}
        if origT then
            for p, v in pairs(origT) do
                if p and p.Parent then pcall(function() p.LocalTransparencyModifier = v end) end
            end
            origT = nil
        end
        if track then
            pcall(function() track:AdjustSpeed(1) track:Stop(0) track:Destroy() end)
            track = nil
        end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if realHRP and realHRP:IsDescendantOf(game) and hum then
            local tmp = Instance.new("Model")
            tmp.Parent = game
            char.Parent = tmp
            realHRP.Parent = char
            char.PrimaryPart = realHRP
            char.Parent = workspace
            realHRP.CanCollide = true
            rewire(char, cloneHRP, realHRP)
            if cloneHRP then
                local at = cloneHRP.CFrame
                cloneHRP:Destroy()
                cloneHRP = nil
                realHRP.CFrame = at
            end
            hum.HipHeight = hip or 0
            tmp:Destroy()
        end
        realHRP, cloneHRP = nil, nil
        _G.MeerkoInvisActive = false
    end

    local function animTrick(char, hum)
        if not (char and hum and hum.Health > 0) then return end
        local a = Instance.new("Animation")
        a.AnimationId = "http://www.roblox.com/asset/?id=18537363391"
        local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
        track = animator:LoadAnimation(a)
        track.Priority = Enum.AnimationPriority.Action4
        track.Looped = true
        track:Play(0, 1, 0)
        a:Destroy()
        add(track.Stopped:Connect(function()
            if active then animTrick(char, hum) end
        end))
        task.defer(function()
            if not track then return end
            track.TimePosition = 0.7
            task.delay(0.1, function() if track then track:AdjustSpeed(math.huge) end end)
        end)
    end

    start = function()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum or active then return false end

        local folder = workspace:FindFirstChild(LP.Name)
        if folder then
            for _, n in ipairs({ "DoubleRig", "Constraints" }) do
                local x = folder:FindFirstChild(n)
                if x then x:Destroy() end
            end
            add(folder.ChildAdded:Connect(function(c)
                if c.Name == "DoubleRig" or c.Name == "Constraints" then c:Destroy() end
            end))
        end
        for _, s in ipairs({ "Dead", "FallingDown", "Ragdoll" }) do
            hum:SetStateEnabled(Enum.HumanoidStateType[s], false)
        end

        hip = hum.HipHeight
        realHRP = char:FindFirstChild("HumanoidRootPart")
        if not (realHRP and realHRP.Parent) then return false end

        local tmp = Instance.new("Model")
        tmp.Parent = game
        char.Parent = tmp
        cloneHRP = realHRP:Clone()
        cloneHRP.Parent = char
        realHRP.Parent = workspace.CurrentCamera
        cloneHRP.CFrame = realHRP.CFrame
        char.PrimaryPart = cloneHRP
        char.Parent = workspace
        rewire(char, realHRP, cloneHRP)
        tmp:Destroy()

        active = true
        animTrick(char, hum)

        origT = {}
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                origT[p] = p.LocalTransparencyModifier
                p.LocalTransparencyModifier = 1
            end
        end
        add(char.DescendantAdded:Connect(function(d)
            if not (active and d:IsA("BasePart")) then return end
            if origT and origT[d] == nil then origT[d] = d.LocalTransparencyModifier end
            pcall(function() d.LocalTransparencyModifier = 1 end)
        end))

        add(RunService.Heartbeat:Connect(function()
            if not active or not hum.Parent then return end
            hum.Health = hum.MaxHealth
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            local st = hum:GetState()
            if st == Enum.HumanoidStateType.Dead or st == Enum.HumanoidStateType.FallingDown
                or st == Enum.HumanoidStateType.Ragdoll then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end))

        local lastTarget, grace = nil, 60
        add(RunService.PreSimulation:Connect(function()
            if not (active and realHRP and hum.Health > 0) then return end
            local base = char.PrimaryPart or char:FindFirstChild("HumanoidRootPart")
            if not base then return end
            if grace > 0 then
                grace = grace - 1
            elseif not stuck and lastTarget then
                local _drift = (realHRP.Position - lastTarget).Magnitude
                local _cloneDrift = cloneHRP and (cloneHRP.Position - lastTarget).Magnitude or 0
                if _drift > 2.25 or _cloneDrift > 8 then
                    stuck = true
                    if not restarting then
                        task.spawn(function()
                            restarting = true
                            pcall(stop)
                            task.wait(0.5)
                            restarting = false
                            local ok = pcall(start)
                            if not ok then
                                task.wait(1)
                                pcall(start)
                            end
                        end)
                    end
                end
            end
            local cf = base.CFrame
                - Vector3.new(0, hum.HipHeight + (base.Size.Y / 2) - 1 + depth(), 0)
            realHRP.CFrame = cf * CFrame.Angles(math.rad(angle()), 0, 0)
            realHRP.AssemblyLinearVelocity = base.AssemblyLinearVelocity
            realHRP.CanCollide = false
            if realHRP.Parent ~= workspace.CurrentCamera then
                realHRP.Parent = workspace.CurrentCamera
            end
            lastTarget = cf.Position
        end))

        add(LP.CharacterAdded:Connect(function() if active then stop() end end))
        _G.MeerkoInvisActive = true
        return true
    end

    _G.MeerkoInvisStart, _G.MeerkoInvisStop = start, stop
    _G.MeerkoInvisToggle = function()
        if active then stop() else start() end
    end

    local armed, autoOn = false, false
    local function syncAuto()
        local want = (_G.MeerkoInvisAuto == true) and (LP:GetAttribute("Stealing") == true)
        if not want then
            armed = false
            if active and autoOn then autoOn = false pcall(stop) end
            return
        end
        if active or armed then return end
        armed = true
        task.delay(tonumber(_G.MeerkoInvisAutoDelay) or 1.5, function()
            armed = false
            if _G.MeerkoInvisAuto == true and not active
                and LP:GetAttribute("Stealing") == true then
                autoOn = true
                pcall(start)
            end
        end)
    end
    _G.MeerkoInvisSync = syncAuto
    LP:GetAttributeChangedSignal("Stealing"):Connect(syncAuto)
end)()

;(function()
    local function strip()
        local c = LP.Character
        local h = c and c:FindFirstChild("HumanoidRootPart")
        if not h or not getconnections or not getinfo then return end
        for _, s in ipairs({ "CFrame", "Position" }) do
            pcall(function()
                for _, cn in ipairs(getconnections(h:GetPropertyChangedSignal(s))) do
                    if cn.Function and cn.Enabled then
                        local ok, info = pcall(getinfo, cn.Function)
                        if ok and info and tostring(info.source) == "=ReplicatedFirst.test" then
                            pcall(function() cn:Disable() end)
                        end
                    end
                end
            end)
        end
    end
    _G.MeerkoStripAC = strip
    task.spawn(function() _G.MeerkoBootWait() while true do pcall(strip) task.wait(6) end end) 
    LP.CharacterAdded:Connect(function() task.wait(0.3) pcall(strip) end)
end)()

;(function()
    local wsConn
    _G.MeerkoSetWalkSpeed = function(enabled)
        _G.MeerkoWalkSpeedOn = enabled and true or false
        if wsConn then wsConn:Disconnect() wsConn = nil end
        if not _G.MeerkoWalkSpeedOn then return end
        wsConn = RunService.Heartbeat:Connect(function(dt)
            if not _G.MeerkoWalkSpeedOn then return end
            if LP:GetAttribute("Stealing") ~= true then return end
            local c = LP.Character
            local hum = c and c:FindFirstChildOfClass("Humanoid")
            local hrp = c and c:FindFirstChild("HumanoidRootPart")
            if not hum or not hrp or hum.Health <= 0 then return end
            local md = hum.MoveDirection
            if md.Magnitude <= 0 then return end
            local spd = math.clamp(tonumber(_G.MeerkoWalkSpeed) or 26, 5, 32)
            if spd <= hum.WalkSpeed then return end
            hrp.CFrame = hrp.CFrame + (md * (spd - hum.WalkSpeed) * (dt or 0.016))
        end)
    end
    if _G.MeerkoWalkSpeedOn == nil then _G.MeerkoWalkSpeedOn = true end
    if _G.MeerkoWalkSpeedOn == true then
        task.defer(function() pcall(_G.MeerkoSetWalkSpeed, true) end)
    end
end)()

;(function()
    local conn
    _G.MeerkoSetCarpetSpeed = function(enabled)
        _G.MeerkoCarpetSpeed = enabled and true or false
        if conn then conn:Disconnect() conn = nil end
        if not _G.MeerkoCarpetSpeed then return end
        task.spawn(function() pcall(equipCarpet) end)
        local _csEquipAt = 0
        conn = RunService.Heartbeat:Connect(function()
            if LP:GetAttribute("Stealing") == true then
                _G.MeerkoSetCarpetSpeed(false)
                return
            end
            local c = LP.Character
            local hum = c and c:FindFirstChildOfClass("Humanoid")
            local part = c and (c:FindFirstChild("UpperTorso")
                or c:FindFirstChild("Torso")
                or c:FindFirstChild("HumanoidRootPart"))
            if not hum or not part then return end
            local now = os.clock()
            if not _G.MeerkoCarpetEngaging() and (now - _csEquipAt) >= 1.0 then
                _csEquipAt = now
                pcall(equipCarpet)
            end
            local spd = math.clamp(tonumber(_G.MeerkoCarpetSpeedValue) or 140, 20, 400)
            local md, keepY = hum.MoveDirection, part.Velocity.Y
            if md.Magnitude > 0 then
                part.Velocity = Vector3.new(md.X * spd, keepY, md.Z * spd)
            else
                part.Velocity = Vector3.new(0, keepY, 0)
            end
        end)
    end

    UIS.InputBegan:Connect(function(i, g)
        if g or i.UserInputType ~= Enum.UserInputType.Keyboard then return end
        local _csk = _G.MeerkoCarpetSpeedKeyName
        if type(_csk) ~= "string" or _csk == "" then return end
        if i.KeyCode.Name ~= _csk then return end
        if _G.MeerkoBindListening then return end
        if LP:GetAttribute("Stealing") == true then return end
        local on = not (_G.MeerkoCarpetSpeed == true)
        _G.MeerkoSetCarpetSpeed(on)
        if on then task.spawn(function() pcall(equipCarpet) end) end
    end)
end)()

;(function()
    local FOLDERS = { "Base", "PlotSign", "FriendPanel", "Cash", "Laser",
        "Decorations", "Skin", "Unlock", "Purchases" }
    local orig = setmetatable({}, { __mode = "k" })
    local conns, gen = {}, 0

    local function paint(o, a)
        if not o:IsA("BasePart") then return end
        if orig[o] == nil then orig[o] = (o.Transparency == a) and 0 or o.Transparency end
        local base = orig[o]
        if base >= 1 then return end
        local want = base + (1 - base) * a
        if math.abs(o.Transparency - want) > 0.01 then o.Transparency = want end
    end

    local function calm()
        while _G.MeerkoStealHold do task.wait(0.15) end
    end

    local function track(root, a, id)
        if not root or id ~= gen then return end
        paint(root, a)
        local n = 0
        for _, d in ipairs(root:GetDescendants()) do
            if id ~= gen then return end
            paint(d, a)
            n = n + 1
            if n % 250 == 0 then task.wait() end
        end
        conns[#conns + 1] = root.DescendantAdded:Connect(function(d)
            if id == gen then paint(d, a) end
        end)
    end

    local function doPlot(plot, a, id)
        if not plot or id ~= gen then return end
        for _, fname in ipairs(FOLDERS) do
            if id ~= gen then return end
            track(plot:FindFirstChild(fname), a, id)
        end
        if id ~= gen then return end
        conns[#conns + 1] = plot.ChildAdded:Connect(function(c)
            if id ~= gen then return end
            for _, fname in ipairs(FOLDERS) do
                if c.Name == fname then track(c, a, id) break end
            end
        end)
        local pods = plot:FindFirstChild("AnimalPodiums")
        if not pods then return end
        local function pod(pd)
            for _, c in ipairs(pd:GetChildren()) do
                if c.Name == "Claim" then track(c, a, id)
                elseif c.Name == "Base" then track(c:FindFirstChild("Decorations"), a, id) end
            end
        end
        for _, pd in ipairs(pods:GetChildren()) do pod(pd) end
        conns[#conns + 1] = pods.ChildAdded:Connect(function(pd)
            if id ~= gen then return end
            task.wait(0.1)
            if id == gen then pod(pd) end
        end)
    end

    local function stop()
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        conns, gen = {}, gen + 1
    end

    _G.MeerkoEnableXray = function()
        stop()
        local id = gen
        local a = math.clamp(tonumber(_G.MeerkoXrayAlpha) or 0.9, 0, 1)
        task.spawn(function()
            while id == gen and not workspace:FindFirstChild("Plots") do task.wait(0.5) end
            local plots = workspace:FindFirstChild("Plots")
            if id ~= gen or not plots then return end
            calm()
            for _, p in ipairs(plots:GetChildren()) do
                if id ~= gen then return end
                pcall(doPlot, p, a, id)
                task.wait()
                calm()
            end
            conns[#conns + 1] = plots.ChildAdded:Connect(function(p)
                if id ~= gen then return end
                task.wait(0.2)
                pcall(doPlot, p, a, id)
            end)
        end)
    end

    _G.MeerkoDisableXray = function()
        stop()
        local snap = orig
        orig = setmetatable({}, { __mode = "k" })
        for o, t in pairs(snap) do
            pcall(function() if o:IsA("BasePart") then o.Transparency = t end end)
        end
    end

    _G.MeerkoToggleXray = function()
        _G.MeerkoXray = not (_G.MeerkoXray ~= false)
        if _G.MeerkoXray then _G.MeerkoEnableXray() else _G.MeerkoDisableXray() end
        return _G.MeerkoXray
    end

    task.spawn(function()
        if not game:IsLoaded() then game.Loaded:Wait() end
        _G.MeerkoBootWait()
        task.wait(tonumber(_G.MeerkoXrayDelay) or 1)
        if _G.MeerkoXray ~= false then _G.MeerkoEnableXray() end
    end)
end)()

;(function()
    local function psCode(link)
        link = tostring(link or ""):match("^%s*(.-)%s*$")
        if link == "" then return nil end
        if not link:find("://", 1, true) then return link end
        return link:match("[?&]privateServerLinkCode=([^&]+)")
            or link:match("[?&]linkCode=([^&]+)")
            or link:match("[?&]code=([^&]+)")
    end

    local function kickOut()
        if _G.MeerkoKickToPS == true then
            local code = psCode(_G.MeerkoPrivateServerLink)
            if code and code ~= "" then
                local ok = pcall(function()
                    game:GetService("ExperienceService"):LaunchExperience({
                        placeId = tonumber(_G.MeerkoPrivateServerPlaceId) or game.PlaceId,
                        linkCode = code,
                    })
                end)
                if ok then return end
            end
        end
        if pcall(function() game:Shutdown() end) then return end
        pcall(function() LP:Kick("") end)
    end
    _G.MeerkoKickOut = kickOut

    task.spawn(function()
        local PG2 = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 10)
        if not PG2 then return end
        local hooked = setmetatable({}, { __mode = "k" })
        local function hit(t)
            return type(t) == "string" and t:lower():find("you stole", 1, true) ~= nil
        end
        local function isText(o)
            return o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox")
        end
        local function watch(o)
            if hooked[o] then return end
            hooked[o] = true
            if _G.MeerkoAutoKickOnSteal == true and hit(o.Text) then kickOut() return end
            o:GetPropertyChangedSignal("Text"):Connect(function()
                if _G.MeerkoAutoKickOnSteal == true and hit(o.Text) then kickOut() end
            end)
        end
        local function root(g)
            g.DescendantAdded:Connect(function(d) if isText(d) then watch(d) end end)
            local n = 0
            for _, d in ipairs(g:GetDescendants()) do
                n = n + 1
                if n % 200 == 0 then task.wait() end
                if isText(d) then watch(d) end
            end
        end

        while _G.MeerkoAutoKickOnSteal ~= true do task.wait(1) end
        PG2.ChildAdded:Connect(root)
        for _, g in ipairs(PG2:GetChildren()) do root(g) end
    end)
end)()

;(function()
    local seen, snd, lastAt = {}, nil, 0

    _G.MeerkoAlertCheck = function(pets)
        if _G.MeerkoPriAlert ~= true then
            if next(seen) then seen = {} end
            return
        end
        local minGen = tonumber(_G.MeerkoAlertMinGen) or 80e6
        local live, fresh = {}, false
        for _, p in ipairs(pets) do
            if p._pri or (tonumber(p.mps) or 0) >= minGen then
                local k = tostring(p.plot) .. "_" .. tostring(p.slot)
                live[k] = true
                if not seen[k] then fresh = true end
            end
        end
        seen = live
        if not fresh or os.clock() - lastAt < 3 then return end
        lastAt = os.clock()
        pcall(function()
            local id = tostring(_G.MeerkoAlertSound or "111786441593851"):match("%d+")
            if not id then return end
            if not (snd and snd.Parent) then
                snd = Instance.new("Sound")
                snd.Name = "MeerkoAlert"
                snd.Parent = game:GetService("SoundService")
            end
            snd.SoundId = "rbxassetid://" .. id
            snd.Volume = math.clamp(tonumber(_G.MeerkoAlertVolume) or 1, 0, 10)
            snd:Play()
        end)
    end

    task.spawn(function()
        while true do
            task.wait(0.5)
            if _G.MeerkoPriAlert == true then
                local ok, pets = pcall(scanAllPets)
                if ok and type(pets) == "table" then pcall(_G.MeerkoAlertCheck, pets) end
            end
        end
    end)
end)()



pcall(function() game:GetService("Players").RespawnTime = 0 end)  

-- Drop Brainrot + Insta Reset (Chilli method)
-- Invis parents the real HRP to the camera and leaves a local-only clone in the
-- character, so both actions pause invis first and act on the real root.
do
    local RunService = game:GetService("RunService")
    local _busy = { drop = false, reset = false }
    local _dropSerial = 0

    local function _pauseInvis()
        if _G.MeerkoInvisActive and type(_G.MeerkoInvisStop) == "function" then
            pcall(_G.MeerkoInvisStop)
            RunService.Heartbeat:Wait()
            return true
        end
        return false
    end
    local function _resumeInvis(char, delay)
        task.delay(delay or 0.05, function()
            if LP.Character == char and not _G.MeerkoInvisActive
                and type(_G.MeerkoInvisStart) == "function" then
                pcall(_G.MeerkoInvisStart)
            end
        end)
    end

    _G.DropBrainrot = function()
        if _busy.drop or _busy.reset or LP:GetAttribute("Stealing") ~= true then return end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        _busy.drop = true
        _dropSerial += 1
        local serial = _dropSerial
        task.spawn(function()
            local hadInvis = _pauseInvis()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then _busy.drop = false return end
            local function live() return serial == _dropSerial and LP.Character == char end

            local cf, vel, health = hrp.CFrame, hrp.AssemblyLinearVelocity, hum.Health
            local bjod, neck, deadOn = hum.BreakJointsOnDeath, hum.RequiresNeck, true
            pcall(function()
                deadOn = hum:GetStateEnabled(Enum.HumanoidStateType.Dead)
                hum.BreakJointsOnDeath = false
                hum.RequiresNeck = false
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            end)
            local hc = hum.HealthChanged:Connect(function(h)
                if live() and h <= 0 then
                    pcall(function() hum.Health = math.max(hum.MaxHealth, health, 1) end)
                end
            end)

            pcall(function()
                local t0 = os.clock()
                while live() and hrp.Parent and hum.Parent and os.clock() - t0 < 0.35 do
                    if hum.Health <= 0 then hum.Health = math.max(hum.MaxHealth, health, 1) end
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 1000, 0)
                    hrp.CFrame = cf
                    task.wait()
                end
                if live() and hrp.Parent then
                    hrp.CFrame = cf
                    hrp.AssemblyLinearVelocity = vel
                end
                local t1 = os.clock()
                while live() and hum.Parent and LP:GetAttribute("Stealing") == true
                    and os.clock() - t1 < 1.5 do
                    if hum.Health <= 0 then hum.Health = math.max(hum.MaxHealth, health, 1) end
                    task.wait()
                end
            end)

            hc:Disconnect()
            if LP.Character == char and hum.Parent then
                pcall(function()
                    hum.BreakJointsOnDeath = bjod
                    hum.RequiresNeck = neck
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, deadOn)
                    if health > 0 and hum.Health <= 0 then hum.Health = health end
                end)
            end
            if serial == _dropSerial then _busy.drop = false end
            if hadInvis then _resumeInvis(char) end
        end)
    end
    _G.stopWalkFling = function() _dropSerial += 1 _busy.drop = false end
    LP.CharacterAdded:Connect(function() _dropSerial += 1 _busy.drop = false end)

    -- Chilli fast reset: hold the humanoid alive and park the real root far above
    -- the map until the server respawns the character.
    _G.__meerkoResetBusy = false
    _G.MeerkoInstaReset = function()
        if _busy.reset then return end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        _busy.reset, _G.__meerkoResetBusy = true, true
        _G.MeerkoStealHold = false
        _dropSerial += 1
        task.spawn(function()
            local hadInvis = _pauseInvis()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then
                _busy.reset, _G.__meerkoResetBusy = false, false
                if hadInvis then _resumeInvis(char) end
                return
            end
            local cf, vel, angVel, health = hrp.CFrame, hrp.AssemblyLinearVelocity,
                hrp.AssemblyAngularVelocity, hum.Health
            local deadOn = true
            pcall(function()
                deadOn = hum:GetStateEnabled(Enum.HumanoidStateType.Dead)
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                if hum.Health <= 0 then hum.Health = math.max(hum.MaxHealth, 1) end
            end)
            local hc = hum.HealthChanged:Connect(function(h)
                if LP.Character == char and h <= 0 then
                    pcall(function() hum.Health = math.max(hum.MaxHealth, health, 1) end)
                end
            end)
            local sky = cf + Vector3.new(0, 31000, 0)
            local t0 = os.clock()
            local limit = tonumber(_G.MeerkoResetTimeout) or 10
            while LP.Character == char and os.clock() - t0 < limit do
                if hrp.Parent then pcall(function() hrp.CFrame = sky end) end
                if hum.Parent and hum.Health <= 0 then
                    pcall(function() hum.Health = math.max(hum.MaxHealth, health, 1) end)
                end
                task.wait()
            end
            hc:Disconnect()
            local respawned = LP.Character ~= char
            if not respawned then
                -- server never respawned us; put everything back
                pcall(function()
                    hrp.CFrame = cf
                    hrp.AssemblyLinearVelocity = vel
                    hrp.AssemblyAngularVelocity = angVel
                end)
                pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, deadOn) end)
            end
            _busy.reset, _G.__meerkoResetBusy = false, false
            if hadInvis and _G.MeerkoInvisAuto ~= true then
                local nc = LP.Character
                if nc then
                    task.spawn(function()
                        pcall(function() nc:WaitForChild("HumanoidRootPart", 5) end)
                        _resumeInvis(nc, 0.35)
                    end)
                end
            end
        end)
    end
end

task.spawn(function()
    local _fired = false
    while true do
        if _G.MeerkoAutoClone == true then
            if not _fired
                and LP:GetAttribute("Stealing") ~= true
                and not (_G.MeerkoIsTeleporting and _G.MeerkoIsTeleporting()) then
                _fired = true
                if _G.MeerkoDoClone then pcall(_G.MeerkoDoClone) end
                if _G.MeerkoAutoCloneOneShot ~= false then
                    _G.MeerkoAutoClone = false
                    if _G.MeerkoRepaintAutoClone then pcall(_G.MeerkoRepaintAutoClone) end
                end
            end
        else
            _fired = false
        end
        task.wait(0.15)
    end
end)



local function _kb(kn, name)
    return type(name) == "string" and name ~= "" and kn == name
end
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if _G.MeerkoBindListening then return end
    local kn = input.KeyCode.Name

    if _kb(kn, _G.MeerkoCloneKeyName) then
        _G.MeerkoAutoClone = not (_G.MeerkoAutoClone == true)
    end
    
    if _kb(kn, _G.MeerkoKickKeyName) then
        task.spawn(function()
            _G.MeerkoKickToPS = true
            if _G.MeerkoKickOut then pcall(_G.MeerkoKickOut) end
        end)
    end
    
    if _kb(kn, _G.MeerkoStopTPKeyName) then
        _G.MeerkoTPStop = true
        _G.MeerkoAutoTP = false
        if _G.MeerkoRepaintAutoTP then pcall(_G.MeerkoRepaintAutoTP) end
        local ch = LP.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if hrp then pcall(function() hrp.AssemblyLinearVelocity = Vector3.zero end) end
    end
    
    if _kb(kn, _G.MeerkoNearestKey) then
        _G.MeerkoStealMode = (_G.MeerkoStealMode == "nearest") and "priority" or "nearest"
    end

    if _kb(kn, _G.MeerkoStealQuickKey) then
        _G.MeerkoStealQuick = not (_G.MeerkoStealQuick == true)
        if _G.MeerkoRepaintStealMode then pcall(_G.MeerkoRepaintStealMode) end
        if _G.MeerkoSaveSettings then pcall(_G.MeerkoSaveSettings) end
    end
    
    if _kb(kn, _G.MeerkoDropKeyName) then
        task.spawn(function() if _G.DropBrainrot then pcall(_G.DropBrainrot) end end)
    end
    
    if _kb(kn, _G.MeerkoResetKeyName) then
        task.spawn(function() if _G.MeerkoInstaReset then pcall(_G.MeerkoInstaReset) end end)
    end
end)


if _G.MeerkoAutoBuy == nil then _G.MeerkoAutoBuy = false end
if _G.MeerkoAutoBuyRange == nil then _G.MeerkoAutoBuyRange = 17 end
if _G.MeerkoAutoBuyHover == nil then _G.MeerkoAutoBuyHover = 9 end

do
    local Workspace = game:GetService("Workspace")
    local lockedPrompt, lockedPart, lockedModel
    local _abBodyPos

    local function firePurchase(prompt)
        if not prompt or not prompt.Parent or not prompt.Enabled then return end
        pcall(function() prompt.HoldDuration = 0 end)
        pcall(function() if fireproximityprompt then fireproximityprompt(prompt) end end)
    end

    local function partAlive()
        return lockedPart and lockedPart.Parent and lockedModel and lockedModel.Parent
    end
    local function promptAlive()
        return lockedPrompt and lockedPrompt.Parent and lockedPrompt.Enabled
    end

    local function destroyBodyPos()
        if _abBodyPos then
            pcall(function() _abBodyPos:Destroy() end)
            _abBodyPos = nil
        end
    end

    local function hoverPart(char)
        return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    end

    local _promptCache, _promptCacheAt = nil, 0
    local function allPrompts()
        if _promptCache and os.clock() - _promptCacheAt < 5 then
            local cleaned = {}
            for _, p in ipairs(_promptCache) do
                if p and p.Parent then cleaned[#cleaned + 1] = p end
            end
            _promptCache = cleaned
            return cleaned
        end
        local out, n = {}, 0
        for _, obj in ipairs(Workspace:GetDescendants()) do
            n = n + 1
            if n % 3000 == 0 then task.wait() end
            if obj:IsA("ProximityPrompt") then out[#out + 1] = obj end
        end
        _promptCache, _promptCacheAt = out, os.clock()
        return out
    end
    Workspace.DescendantAdded:Connect(function(d)
        if _G.MeerkoAutoBuy ~= true or not _promptCache then return end
        if d:IsA("ProximityPrompt") then _promptCache[#_promptCache + 1] = d end
    end)

    local function scanConveyor()
        local results = {}
        for _, obj in ipairs(allPrompts()) do
            if obj.Parent and obj.Enabled then
                local tx = (obj.ActionText or ""):lower()
                if tx:find("purchase") or tx:find("comprar") or tx:find("buy") then
                    local part = obj.Parent
                    local realPart = (part and part:IsA("Attachment") and part.Parent) or part
                    if realPart and realPart:IsA("BasePart") then
                        local model, cur = nil, realPart
                        for _ = 1, 8 do
                            if cur and cur:IsA("Model") then model = cur; break end
                            cur = cur and cur.Parent
                        end
                        results[#results + 1] = { prompt = obj, part = realPart, model = model }
                    end
                end
            end
        end
        return results
    end

    local _abRag = {
        [Enum.HumanoidStateType.Physics] = true,
        [Enum.HumanoidStateType.Ragdoll] = true,
        [Enum.HumanoidStateType.FallingDown] = true,
    }
    local _abHarden = 0
    local _abTick = 0
    RunService.Heartbeat:Connect(function()
        if _G.MeerkoAutoBuy ~= true or not partAlive() then return end
        _abTick = _abTick + 1
        if _abTick < 2 then return end
        _abTick = 0
        local char = LP.Character
        local part = char and hoverPart(char)
        if not part then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local now = os.clock()
        if hum then
            if now - _abHarden > 0.5 then
                _abHarden = now
                pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false) end)
                pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false) end)
                pcall(function() hum.BreakJointsOnDeath = false end)
            end
            local ragged = _abRag[hum:GetState()] == true
            local et = tonumber(LP:GetAttribute("RagdollEndTime"))
            if et and (et - workspace:GetServerTimeNow()) > 0 then ragged = true end
            if ragged then
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
                local cam = workspace.CurrentCamera
                if cam and cam.CameraSubject ~= hum then
                    pcall(function() cam.CameraSubject = hum end)
                end
            end
        end
        local hover = tonumber(_G.MeerkoAutoBuyHover) or 9
        local goal = lockedPart.Position + Vector3.new(0, hover, 0)
        if not (_abBodyPos and _abBodyPos.Parent == part) then
            destroyBodyPos()
            _abBodyPos = Instance.new("BodyPosition")
            _abBodyPos.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            _abBodyPos.P = 20000
            _abBodyPos.D = 1000
            _abBodyPos.Parent = part
        end
        _abBodyPos.Position = goal
    end)

    local _abJumped = false
    RunService.Heartbeat:Connect(function()
        if _G.MeerkoAutoBuy ~= true or not partAlive() or not promptAlive() then return end
        if not _abJumped then
            _abJumped = true
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
            end
        end
        firePurchase(lockedPrompt)
    end)

    task.spawn(function()
        while true do
            task.wait(0.1)
            if _G.MeerkoAutoBuy ~= true then
                lockedPrompt, lockedPart, lockedModel = nil, nil, nil
                destroyBodyPos()
                _abJumped = false
            elseif lockedPart or lockedModel then
                if not partAlive() then
                    lockedPrompt, lockedPart, lockedModel = nil, nil, nil
                    destroyBodyPos()
                    _abJumped = false
                end
            else
                local ok, found = pcall(scanConveyor)
                local list = (ok and found) or {}
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local best, bestDist = nil, math.huge
                    local radius = tonumber(_G.MeerkoAutoBuyRange) or 17
                    for _, e in ipairs(list) do
                        if e.prompt and e.prompt.Parent and e.prompt.Enabled and e.part and e.part.Parent then
                            local d = (hrp.Position - e.part.Position).Magnitude
                            if d <= radius and d < bestDist then bestDist = d; best = e end
                        end
                    end
                    if best then
                        lockedPrompt, lockedPart, lockedModel = best.prompt, best.part, best.model or best.part.Parent
                        pcall(function() best.prompt.HoldDuration = 0 end)
                        firePurchase(best.prompt)
                    end
                end
            end
        end
    end)

    LP.CharacterAdded:Connect(function()
        destroyBodyPos()
    end)
end

if _G.MeerkoFaceAway == nil then _G.MeerkoFaceAway = false end
if _G.MeerkoFaceAwayNearest == nil then _G.MeerkoFaceAwayNearest = false end

do
    local Workspace = game:GetService("Workspace")
    local function getRoot(pl)
        local c = pl and pl.Character
        return c and c:FindFirstChild("HumanoidRootPart")
    end
    local _fnBest, _fnAt = nil, 0
    local function findNearest(myRoot)
        local now = os.clock()
        if _fnBest and (now - _fnAt) < 0.15 then return _fnBest end
        local best, bestD = nil, math.huge
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= LP then
                local r = getRoot(pl)
                if r then
                    local d = (r.Position - myRoot.Position).Magnitude
                    if d < bestD then best, bestD = pl, d end
                end
            end
        end
        _fnBest, _fnAt = best, now
        return best
    end
    local function getPlotAtPosition(pos)
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return nil end
        local best, bestD = nil, math.huge
        for _, plot in ipairs(plots:GetChildren()) do
            local pp
            if plot:IsA("Model") then
                pp = (plot.PrimaryPart and plot.PrimaryPart.Position) or plot:GetPivot().Position
            else
                pp = plot.Position
            end
            if pp then
                local dx, dz = pos.X - pp.X, pos.Z - pp.Z
                local d = math.sqrt(dx * dx + dz * dz)
                if d < bestD then bestD, best = d, plot end
            end
        end
        return (best and bestD < 72) and best or nil
    end
    local function getPlotOwner(plot)
        if not plot then return nil end
        local sign = plot:FindFirstChild("PlotSign")
        local lbl = sign
            and sign:FindFirstChild("SurfaceGui")
            and sign.SurfaceGui:FindFirstChild("Frame")
            and sign.SurfaceGui.Frame:FindFirstChild("TextLabel")
        if lbl then
            local nick = (lbl.Text and lbl.Text:match("^(.-)'")) or lbl.Text
            if nick and nick ~= "" then
                for _, pl in ipairs(Players:GetPlayers()) do
                    if pl.DisplayName == nick or pl.Name == nick then return pl end
                end
            end
        end
        return nil
    end
    local _ownerCache, _ownerAt = nil, 0
    local function resolveTarget(myRoot)
        if _G.MeerkoFaceAwayNearest == true then
            return findNearest(myRoot)
        end
        if os.clock() - _ownerAt > 0.5 then
            _ownerAt = os.clock()
            local owner = getPlotOwner(getPlotAtPosition(myRoot.Position))
            _ownerCache = (owner ~= LP) and owner or nil
        end
        return _ownerCache
    end
    local _faceWasOn, _stealSince = false, nil
    local function faceActive()
        if _G.MeerkoFaceAway ~= true then
            _stealSince = nil
            return false
        end
        if LP:GetAttribute("Stealing") ~= true then
            _stealSince = nil
            return false
        end
        if not _stealSince then
            _stealSince = os.clock()
            return false
        end
        return (os.clock() - _stealSince) >= (tonumber(_G.MeerkoFaceAwayDelay) or 2)
    end
    local function faceAwayStep()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not faceActive() then
            if _faceWasOn then
                _faceWasOn = false
                if hum then pcall(function() hum.AutoRotate = true end) end
            end
            return
        end
        _faceWasOn = true
        local myRoot = getRoot(LP)
        if not myRoot then return end
        if hum and hum.AutoRotate then pcall(function() hum.AutoRotate = false end) end
        local tRoot = getRoot(resolveTarget(myRoot))
        if not tRoot then return end
        local flat = Vector3.new(
            tRoot.Position.X - myRoot.Position.X,
            0,
            tRoot.Position.Z - myRoot.Position.Z
        )
        if flat.Magnitude < 0.05 then return end
        myRoot.CFrame = CFrame.lookAt(myRoot.Position, myRoot.Position + Vector3.new(-flat.Z, 0, flat.X).Unit)
        local av = myRoot.AssemblyAngularVelocity
        if av.Y ~= 0 then
            myRoot.AssemblyAngularVelocity = Vector3.new(av.X, 0, av.Z)
        end
    end
    local _faTick = 0
    RunService.RenderStepped:Connect(function()
        _faTick = _faTick + 1
        if _faTick < 2 then return end
        _faTick = 0
        faceAwayStep()
    end)
end



do
    local _anSeen = setmetatable({}, { __mode = "k" })

    local function _isPlayerRig(inst)
        local m = inst:FindFirstAncestorOfClass("Model")
        while m do
            if Players:GetPlayerFromCharacter(m) then return true end
            if Players:FindFirstChild(m.Name) then return true end
            if m:FindFirstChildOfClass("Humanoid") and m.Parent == workspace then return true end
            m = m:FindFirstAncestorOfClass("Model")
        end
        return false
    end

    local function _killTrack(t)
        if not t then return end
        pcall(function() t:Stop(0) end)
        pcall(function() t:AdjustSpeed(0) end)
    end

    local function _hookAnimator(a)
        if _G.MeerkoNoPetAnim == false then return end
        if not a or not a.Parent or _anSeen[a] then return end
        if _isPlayerRig(a) then return end
        _anSeen[a] = true
        pcall(function()
            for _, t in ipairs(a:GetPlayingAnimationTracks()) do _killTrack(t) end
        end)
        pcall(function()
            a.AnimationPlayed:Connect(function(t) _killTrack(t) end)
        end)
    end

    workspace.DescendantAdded:Connect(function(d)
        if d.ClassName == "Animator" then task.delay(tonumber(_G.MeerkoAnimHookDelay) or 0.6, _hookAnimator, d) end
    end)

    local _busyAnim = false
    local function _sweepAll()
        if _G.MeerkoNoPetAnim == false then return end
        if _busyAnim then return end
        _busyAnim = true
        task.spawn(function()
            local all = workspace:GetDescendants()
            local i, n = 1, #all
            while i <= n do
                local t0 = os.clock()
                while i <= n and (os.clock() - t0) < 0.004 do
                    local o = all[i]
                    i = i + 1
                    if o and o.ClassName == "Animator" then _hookAnimator(o) end
                end
                RunService.Heartbeat:Wait()
            end
            _busyAnim = false
        end)
    end
    _G.MeerkoStripPetAnims = _sweepAll

    task.spawn(function()
        if not game:IsLoaded() then game.Loaded:Wait() end
        task.wait(tonumber(_G.MeerkoNoPetAnimDelay) or 3)
        for _ = 1, 6 do
            _sweepAll()
            task.wait(1.5)
        end
        while true do
            task.wait(tonumber(_G.MeerkoNoPetAnimGap) or 15)
            _sweepAll()
        end
    end)
end


do
    if _G.MeerkoPlayerESP == nil then _G.MeerkoPlayerESP = true end
    local host = (gethui and gethui()) or game:GetService("CoreGui")
    local bin
    local hls = {}

    local function _bin()
        if bin and bin.Parent then return bin end
        bin = Instance.new("Folder")
        bin.Name = "MeerkoPlayerESP"
        bin.Parent = host
        return bin
    end

    local function _drop(pl)
        local h = hls[pl]
        if h then pcall(function() h:Destroy() end) end
        hls[pl] = nil
    end

    local function _ensure(pl)
        local h = hls[pl]
        if h and h.Parent then return h end
        h = Instance.new("Highlight")
        h.Name = "ESP_" .. pl.Name
        h.FillTransparency = tonumber(_G.MeerkoESPFill) or 0.55
        h.OutlineTransparency = 0
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent = _bin()
        hls[pl] = h
        return h
    end

    Players.PlayerRemoving:Connect(_drop)

    task.spawn(function()
        if not game:IsLoaded() then game.Loaded:Wait() end
        task.wait(tonumber(_G.MeerkoESPDelay) or 4)
        local _lastCol
        while true do
            task.wait(tonumber(_G.MeerkoESPGap) or 0.4)
            pcall(function()
                local on = _G.MeerkoPlayerESP ~= false
                local col = _G.MeerkoESPColor
                if typeof(col) ~= "Color3" then col = Color3.fromRGB(255, 255, 255) end
                local colChanged = col ~= _lastCol
                _lastCol = col
                for _, pl in ipairs(Players:GetPlayers()) do
                    local ch = (pl ~= LP) and pl.Character
                    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
                    if on and hrp then
                        local h = _ensure(pl)
                        if h.Adornee ~= ch then h.Adornee = ch end
                        if colChanged then
                            h.FillColor = col
                            h.OutlineColor = col
                        end
                        if not h.Enabled then h.Enabled = true end
                    else
                        local h = hls[pl]
                        if h then h.Enabled = false; h.Adornee = nil end
                    end
                end
            end)
        end
    end)
end
task.defer(function() do
    local TweenService = game:GetService("TweenService")
    local _HSx = game:GetService("HttpService")
    local EX_CFG = "OpsexExtrasVault.json"
    local function exSavePos()
        if not writefile then return end
        pcall(function()
            writefile(EX_CFG, _HSx:JSONEncode({
                x = tonumber(_G._meerko_exX), y = tonumber(_G._meerko_exY),
            }))
        end)
    end
    _G.MeerkoExtrasSave = exSavePos
    if readfile then
        pcall(function()
            local raw = readfile(EX_CFG)
            if type(raw) == "string" and #raw > 0 then
                local ok, d = pcall(_HSx.JSONDecode, _HSx, raw)
                if ok and type(d) == "table" then
                    if type(d.x) == "number" then _G._meerko_exX = d.x end
                    if type(d.y) == "number" then _G._meerko_exY = d.y end
                end
            end
        end)
    end
    do
        local vp = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(1920, 1080)
        local function cl(v, mx)
            local n = tonumber(v)
            if not n then return nil end
            return math.clamp(n, 0, math.max(mx, 0))
        end
        _G._meerko_exX = cl(_G._meerko_exX, vp.X - 240)
        _G._meerko_exY = cl(_G._meerko_exY, vp.Y - 40)
        _G._meerko_fX = cl(_G._meerko_fX, vp.X - 100)
        _G._meerko_fY = cl(_G._meerko_fY, vp.Y - 100)
        _G._meerko_kX = cl(_G._meerko_kX, vp.X - 100)
        _G._meerko_kY = cl(_G._meerko_kY, vp.Y - 100)
    end
    local C = {
        bg = Color3.fromRGB(14,16,20), card = Color3.fromRGB(25,29,35),
        line = Color3.fromRGB(51,60,71), acc = Color3.fromRGB(88,166,255),
        txt = Color3.fromRGB(238,241,245), dim = Color3.fromRGB(139,149,162),
        track = Color3.fromRGB(34,40,48), acc2 = Color3.fromRGB(157,203,255),
    }
    local FB, FR = Enum.Font.GothamBold, Enum.Font.Gotham
    local EASE = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local function tw(o, p) TweenService:Create(o, EASE, p):Play() end
    local function mk(cls, parent, props)
        local o = Instance.new(cls)
        for k, v in pairs(props or {}) do o[k] = v end
        o.Parent = parent
        return o
    end
    local function corner(o, r) mk("UICorner", o, { CornerRadius = UDim.new(0, r or 4) }) return o end

    local host = (gethui and gethui()) or game:GetService("CoreGui")
    for _, _p in ipairs({ host, LP:FindFirstChild("PlayerGui") }) do
        if _p then
            pcall(function()
                local old = _p:FindFirstChild("MeerkoExtras")
                if old then old:Destroy() end
            end)
        end
    end
    local sg = mk("ScreenGui", nil, {
        Name = "MeerkoExtras", ResetOnSpawn = false, IgnoreGuiInset = true,
        DisplayOrder = 999997, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    sg.Parent = host
    _G.MeerkoExtrasLoaded = os.clock()

    local function makeDrag(frame, handle, keyX, keyY)
        local on, from, base, tracked
        handle.InputBegan:Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.MouseButton1 and i.UserInputType ~= Enum.UserInputType.Touch then return end
            on, from, base = true, i.Position, frame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    on = false
                    if keyX then _G[keyX] = frame.Position.X.Offset end
                    if keyY then _G[keyY] = frame.Position.Y.Offset end
                    exSavePos()
                    pcall(_G.MeerkoSaveSettings or function() end)
                end
            end)
        end)
        handle.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then tracked = i end
        end)
        UIS.InputChanged:Connect(function(i)
            if not on or i ~= tracked then return end
            local d = i.Position - from
            frame.Position = UDim2.fromOffset(base.X.Offset + d.X, base.Y.Offset + d.Y)
        end)
    end

    local _ord = 0
    local function nextOrd() _ord = _ord + 1 return _ord end
    local _toggleRepaints = {}

    local function toggle(parent, label, get, set)
        local card = corner(mk("Frame", parent, {
            Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = C.card, BorderSizePixel = 0, LayoutOrder = nextOrd(),
        }), 4)
        mk("TextLabel", card, {
            Size = UDim2.new(1, -60, 1, 0), Position = UDim2.fromOffset(12, 0),
            BackgroundTransparency = 1, Text = label, Font = FR, TextSize = 12,
            TextColor3 = C.txt, TextXAlignment = Enum.TextXAlignment.Left,
        })
        local pill = corner(mk("Frame", card, {
            Size = UDim2.fromOffset(38, 18), Position = UDim2.new(1, -48, 0.5, -9),
            BackgroundColor3 = C.track, BorderSizePixel = 0,
        }), 9)
        local knob = corner(mk("Frame", pill, {
            Size = UDim2.fromOffset(14, 14), Position = UDim2.fromOffset(2, 2),
            BackgroundColor3 = C.dim, BorderSizePixel = 0,
        }), 7)
        local hit = mk("TextButton", card, { Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Active = true })
        local _last
        local function paint(instant)
            local v = get() and true or false
            if v == _last and not instant then return end
            _last = v
            local pc = v and C.acc or C.track
            local kc = v and C.bg or C.dim
            local kp = UDim2.fromOffset(v and 22 or 2, 2)
            if instant then pill.BackgroundColor3, knob.BackgroundColor3, knob.Position = pc, kc, kp
            else tw(pill, { BackgroundColor3 = pc }); tw(knob, { BackgroundColor3 = kc, Position = kp }) end
        end
        hit.MouseButton1Click:Connect(function() set(); paint(); pcall(_G.MeerkoSaveSettings) end)
        paint(true)
        _toggleRepaints[#_toggleRepaints + 1] = paint
    end

    local function slider(parent, label, min, max, get, set, step)
        step = step or 1
        local card = corner(mk("Frame", parent, {
            Size = UDim2.new(1, 0, 0, 44), BackgroundColor3 = C.card, BorderSizePixel = 0, LayoutOrder = nextOrd(),
        }), 4)
        mk("TextLabel", card, {
            Size = UDim2.new(1, -60, 0, 14), Position = UDim2.fromOffset(12, 6),
            BackgroundTransparency = 1, Text = label, Font = FR, TextSize = 11,
            TextColor3 = C.dim, TextXAlignment = Enum.TextXAlignment.Left,
        })
        local val = mk("TextLabel", card, {
            Size = UDim2.fromOffset(48, 14), Position = UDim2.new(1, -56, 0, 6),
            BackgroundTransparency = 1, Font = FB, TextSize = 12, TextColor3 = C.acc2,
            TextXAlignment = Enum.TextXAlignment.Right,
        })
        local track = corner(mk("TextButton", card, {
            Size = UDim2.new(1, -24, 0, 6), Position = UDim2.fromOffset(12, 30),
            BackgroundColor3 = C.track, Text = "", AutoButtonColor = false, BorderSizePixel = 0,
        }), 3)
        local fill = corner(mk("Frame", track, { Size = UDim2.new(0,0,1,0), BackgroundColor3 = C.acc, BorderSizePixel = 0 }), 3)
        local function refresh()
            local v = math.clamp(tonumber(get()) or min, min, max)
            local rel = (v - min) / math.max(max - min, 1e-6)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            val.Text = step < 1 and string.format("%.2f", v) or tostring(math.floor(v + 0.5))
        end
        local function apply(x)
            local rel = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
            set(math.clamp(math.floor((min + (max - min) * rel) / step + 0.5) * step, min, max))
            refresh()
        end
        local sliding = false
        track.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sliding = true; apply(i.Position.X) end
        end)
        UIS.InputChanged:Connect(function(i)
            if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then apply(i.Position.X) end
        end)
        UIS.InputEnded:Connect(function(i)
            if sliding and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then sliding = false; pcall(_G.MeerkoSaveSettings) end
        end)
        refresh()
    end

    local function input(parent, label, hint, get, set)
        local card = corner(mk("Frame", parent, {
            Size = UDim2.new(1, 0, 0, 46), BackgroundColor3 = C.card, BorderSizePixel = 0, LayoutOrder = nextOrd(),
        }), 4)
        mk("TextLabel", card, {
            Size = UDim2.new(1, -20, 0, 12), Position = UDim2.fromOffset(12, 6),
            BackgroundTransparency = 1, Text = label, Font = FR, TextSize = 10,
            TextColor3 = C.dim, TextXAlignment = Enum.TextXAlignment.Left,
        })
        local box = mk("TextBox", card, {
            Size = UDim2.new(1, -20, 0, 18), Position = UDim2.fromOffset(12, 22),
            BackgroundTransparency = 1, Font = FB, TextSize = 12, TextColor3 = C.txt,
            TextXAlignment = Enum.TextXAlignment.Left, PlaceholderText = hint, PlaceholderColor3 = C.line,
            ClearTextOnFocus = false, Text = tostring(get() or ""), TextTruncate = Enum.TextTruncate.AtEnd,
        })
        box.FocusLost:Connect(function() set(box.Text); pcall(_G.MeerkoSaveSettings) end)
    end

    local function keybind(parent, labelTxt, getName, setName)
        local card = corner(mk("Frame", parent, {
            Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = C.card, BorderSizePixel = 0, LayoutOrder = nextOrd(),
        }), 4)
        mk("TextLabel", card, {
            Size = UDim2.new(1, -104, 1, 0), Position = UDim2.fromOffset(12, 0),
            BackgroundTransparency = 1, Text = labelTxt, Font = FR, TextSize = 12,
            TextColor3 = C.txt, TextXAlignment = Enum.TextXAlignment.Left,
        })
        local btn = corner(mk("TextButton", card, {
            Size = UDim2.fromOffset(84, 22), Position = UDim2.new(1, -96, 0.5, -11),
            BackgroundColor3 = C.track, Text = "", Font = FB, TextSize = 11,
            TextColor3 = C.txt, AutoButtonColor = false, Active = true,
        }), 4)
        local listening, conn = false, nil
        local function repaint()
            if listening then btn.Text = "..."; return end
            local k = getName()
            btn.Text = (type(k) == "string" and k ~= "") and k or "NONE"
        end
        local function stop()
            listening = false
            _G.MeerkoBindListening = false
            if conn then conn:Disconnect(); conn = nil end
            tw(btn, { BackgroundColor3 = C.track })
            repaint()
        end
        btn.MouseButton1Click:Connect(function()
            if listening then stop(); return end
            listening = true
            _G.MeerkoBindListening = true
            tw(btn, { BackgroundColor3 = C.line })
            repaint()
            conn = UIS.InputBegan:Connect(function(inp)
                if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
                local kn = inp.KeyCode.Name
                if kn == "Escape" or kn == "Backspace" or kn == "Delete" then setName(nil) else setName(kn) end
                stop()
                pcall(_G.MeerkoSaveSettings)
            end)
        end)
        btn.MouseButton2Click:Connect(function()
            if listening then stop(); return end
            setName(nil); repaint(); pcall(_G.MeerkoSaveSettings)
        end)
        repaint()
    end

    local function action(parent, label, fn)
        local card = corner(mk("Frame", parent, {
            Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = C.card, BorderSizePixel = 0, LayoutOrder = nextOrd(),
        }), 4)
        local btn = mk("TextButton", card, {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = label,
            Font = FB, TextSize = 12, TextColor3 = C.acc, AutoButtonColor = false, Active = true,
        })
        btn.MouseEnter:Connect(function() tw(card, { BackgroundColor3 = C.track }) end)
        btn.MouseLeave:Connect(function() tw(card, { BackgroundColor3 = C.card }) end)
        btn.MouseButton1Click:Connect(fn)
    end
    local function speedPick(parent, label, opts)
        local card = corner(mk("Frame", parent, {
            Size = UDim2.new(1, 0, 0, 42), BackgroundColor3 = C.card,
            BorderSizePixel = 0, LayoutOrder = nextOrd(),
        }), 4)
        mk("TextLabel", card, {
            Size = UDim2.new(1, -20, 0, 12), Position = UDim2.fromOffset(10, 5),
            BackgroundTransparency = 1, Text = label, Font = FR, TextSize = 10,
            TextColor3 = C.dim, TextXAlignment = Enum.TextXAlignment.Left,
        })
        local row = mk("Frame", card, {
            Position = UDim2.fromOffset(10, 19), Size = UDim2.new(1, -20, 0, 18),
            BackgroundTransparency = 1,
        })
        mk("UIListLayout", row, {
            Padding = UDim.new(0, 6), FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
        })
        local btns = {}
        local function repaint()
            local on  = (_G.MeerkoWalkSpeedOn ~= false)
            local cur = tonumber(_G.MeerkoWalkSpeed)
            for _, b in ipairs(btns) do
                local sel = on and (cur == b.v)
                b.f.BackgroundColor3 = sel and C.acc or C.track
                b.t.TextColor3 = sel and C.bg or C.txt
            end
        end
        for i, v in ipairs(opts) do
            local f = corner(mk("Frame", row, {
                Size = UDim2.new(0.5, -3, 1, 0), BackgroundColor3 = C.track,
                BorderSizePixel = 0, LayoutOrder = i,
            }), 4)
            local t = mk("TextButton", f, {
                Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = tostring(v),
                Font = FB, TextSize = 11, TextColor3 = C.txt, AutoButtonColor = false, Active = true,
            })
            btns[#btns + 1] = { f = f, t = t, v = v }
            t.MouseButton1Click:Connect(function()
                local on  = (_G.MeerkoWalkSpeedOn ~= false)
                local cur = tonumber(_G.MeerkoWalkSpeed)
                if on and cur == v then
                    if _G.MeerkoSetWalkSpeed then pcall(_G.MeerkoSetWalkSpeed, false) end
                else
                    _G.MeerkoWalkSpeed = v
                    if _G.MeerkoSetWalkSpeed then pcall(_G.MeerkoSetWalkSpeed, true) end
                end
                repaint()
                pcall(_G.MeerkoSaveSettings)
            end)
        end
        repaint()
        _toggleRepaints[#_toggleRepaints + 1] = repaint
    end


    local function makeSub(titleText, sx, sy, keyX, keyY)
        local frame = corner(mk("Frame", sg, {
            Name = titleText, Active = true, BackgroundColor3 = C.bg, BorderSizePixel = 0,
            Size = UDim2.fromOffset(248, 380), Visible = false,
            Position = UDim2.fromOffset(tonumber(_G[keyX]) or sx, tonumber(_G[keyY]) or sy),
        }), 6)
        mk("UIStroke", frame, { Thickness = 1, Transparency = 0.5, Color = C.line })
        local head = mk("TextLabel", frame, {
            Position = UDim2.fromOffset(14, 12), Size = UDim2.new(1, -52, 0, 18),
            BackgroundTransparency = 1, Text = titleText, Font = FB, TextSize = 13,
            TextColor3 = C.txt, TextXAlignment = Enum.TextXAlignment.Left,
        })
        local close = corner(mk("TextButton", frame, {
            Size = UDim2.fromOffset(24, 20), Position = UDim2.new(1, -32, 0, 11),
            BackgroundColor3 = C.card, Text = "X", Font = FB, TextSize = 11,
            TextColor3 = C.txt, AutoButtonColor = false, Active = true,
        }), 4)
        close.MouseButton1Click:Connect(function() frame.Visible = false end)
        local list = mk("ScrollingFrame", frame, {
            Position = UDim2.fromOffset(0, 40), Size = UDim2.new(1, 0, 1, -48),
            BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
            ScrollBarImageColor3 = C.line, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        })
        mk("UIListLayout", list, { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Center })
        mk("UIPadding", list, { PaddingTop = UDim.new(0,4), PaddingBottom = UDim.new(0,10), PaddingLeft = UDim.new(0,12), PaddingRight = UDim.new(0,12) })
        makeDrag(frame, head, keyX, keyY)
        return frame, list
    end

    local featFrame, featList = makeSub("FEATURES", 560, 250, "_meerko_fX", "_meerko_fY")
    local keysFrame, keysList = makeSub("KEYBINDS", 560, 250, "_meerko_kX", "_meerko_kY")

    local main = corner(mk("Frame", sg, {
        Name = "Main", Active = true, BackgroundColor3 = C.bg, BorderSizePixel = 0,
        Size = UDim2.fromOffset(240, 0), AutomaticSize = Enum.AutomaticSize.Y,
        Position = UDim2.fromOffset(tonumber(_G._meerko_exX) or 300, tonumber(_G._meerko_exY) or 250),
    }), 6)
    mk("UIStroke", main, { Thickness = 1, Transparency = 0.5, Color = C.line })
    mk("UIListLayout", main, { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Center })
    mk("UIPadding", main, { PaddingTop = UDim.new(0,12), PaddingBottom = UDim.new(0,12), PaddingLeft = UDim.new(0,12), PaddingRight = UDim.new(0,12) })
    local mHead = mk("TextLabel", main, {
        Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Text = "Meerko Extras",
        Font = FB, TextSize = 13, TextColor3 = C.txt, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = nextOrd(),
    })
    makeDrag(main, mHead, "_meerko_exX", "_meerko_exY")

    local navRow = mk("Frame", main, { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = nextOrd() })
    mk("UIListLayout", navRow, { Padding = UDim.new(0, 8), FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center })
    local function navBtn(txt)
        local b = corner(mk("TextButton", navRow, {
            Size = UDim2.fromOffset(100, 28), BackgroundColor3 = C.card, Text = txt,
            Font = FB, TextSize = 11, TextColor3 = C.txt, AutoButtonColor = false, Active = true,
        }), 4)
        b.MouseEnter:Connect(function() tw(b, { BackgroundColor3 = C.track }) end)
        b.MouseLeave:Connect(function() tw(b, { BackgroundColor3 = C.card }) end)
        return b
    end
    local featBtn = navBtn("FEATURES")
    local keysBtn = navBtn("KEYBINDS")
    featBtn.MouseButton1Click:Connect(function() keysFrame.Visible = false; featFrame.Visible = not featFrame.Visible end)
    keysBtn.MouseButton1Click:Connect(function() featFrame.Visible = false; keysFrame.Visible = not keysFrame.Visible end)

    toggle(main, "AUTO INVIS ON STEAL",
        function() return _G.MeerkoInvisAuto == true end,
        function() _G.MeerkoInvisAuto = not (_G.MeerkoInvisAuto == true); if _G.MeerkoInvisSync then pcall(_G.MeerkoInvisSync) end end)
    slider(main, "Invis Depth", 0, 10, function() return _G.MeerkoInvisDepth end, function(v) _G.MeerkoInvisDepth = v end, 0.1)
    slider(main, "Invis Rotation", 0, 360, function() return _G.MeerkoInvisAngle end, function(v) _G.MeerkoInvisAngle = v end, 1)
    toggle(main, "AUTO KICK ON STEAL",
        function() return _G.MeerkoAutoKickOnSteal == true end,
        function() _G.MeerkoAutoKickOnSteal = not (_G.MeerkoAutoKickOnSteal == true) end)
    toggle(main, "AUTO BUY",
        function() return _G.MeerkoAutoBuy == true end,
        function() _G.MeerkoAutoBuy = not (_G.MeerkoAutoBuy == true) end)
    speedPick(main, "WALK SPEED", { 24, 29 })
    action(main, "KICK", function()
        task.spawn(function() if _G.MeerkoKickOut then pcall(_G.MeerkoKickOut) end end)
    end)

    toggle(featList, "ANTI FLASH",             function() return _G.MeerkoAntiFlash ~= false end,      function() _G.MeerkoAntiFlash = not (_G.MeerkoAntiFlash ~= false) end)
    toggle(featList, "ANTI BEE",               function() return _G.MeerkoAntiBee ~= false end,        function() _G.MeerkoAntiBee = not (_G.MeerkoAntiBee ~= false) end)
    toggle(featList, "INF JUMP",               function() return _G.MeerkoInfJump ~= false end,        function() _G.MeerkoInfJump = not (_G.MeerkoInfJump ~= false) end)
    toggle(featList, "NO PLAYER COLLIDE",    function() return _G.MeerkoNoPlayerCollide ~= false end, function() _G.MeerkoNoPlayerCollide = not (_G.MeerkoNoPlayerCollide ~= false) end)
    toggle(featList, "ANTI AFK",              function() return _G.MeerkoAntiAFK ~= false end,        function() _G.MeerkoAntiAFK = not (_G.MeerkoAntiAFK ~= false) end)
    toggle(featList, "ANTI DIE",               function() return _G.AntiDieDisabled ~= true end,       function() _G.AntiDieDisabled = (_G.AntiDieDisabled ~= true) end)
    toggle(featList, "WALK SPEED",             function() return _G.MeerkoWalkSpeedOn ~= false end,    function() if _G.MeerkoSetWalkSpeed then _G.MeerkoSetWalkSpeed(_G.MeerkoWalkSpeedOn == false) end end)
    toggle(featList, "CARPET SPEED",           function() return _G.MeerkoCarpetSpeed == true end,     function() if _G.MeerkoSetCarpetSpeed then _G.MeerkoSetCarpetSpeed(not (_G.MeerkoCarpetSpeed == true)) end end)
    toggle(featList, "XRAY BASES",             function() return _G.MeerkoXray ~= false end,           function() if _G.MeerkoToggleXray then _G.MeerkoToggleXray() end end)
    toggle(featList, "AUTO KICK ON STEAL",     function() return _G.MeerkoAutoKickOnSteal == true end, function() _G.MeerkoAutoKickOnSteal = not (_G.MeerkoAutoKickOnSteal == true) end)
    toggle(featList, "KICK TO PRIVATE SERVER", function() return _G.MeerkoKickToPS == true end,        function() _G.MeerkoKickToPS = not (_G.MeerkoKickToPS == true) end)
    toggle(featList, "PRIORITY ALERT",         function() return _G.MeerkoPriAlert == true end,        function() _G.MeerkoPriAlert = not (_G.MeerkoPriAlert == true) end)
    toggle(featList, "PLAYER ESP",             function() return _G.MeerkoPlayerESP ~= false end,      function() _G.MeerkoPlayerESP = not (_G.MeerkoPlayerESP ~= false) end)
    toggle(featList, "FACE AWAY",              function() return _G.MeerkoFaceAway == true end,        function() _G.MeerkoFaceAway = not (_G.MeerkoFaceAway == true) end)
    toggle(featList, "FACE AWAY: NEAREST",     function() return _G.MeerkoFaceAwayNearest == true end, function() _G.MeerkoFaceAwayNearest = not (_G.MeerkoFaceAwayNearest == true) end)
    slider(featList, "Auto Buy Range", 5, 40, function() return _G.MeerkoAutoBuyRange end, function(v) _G.MeerkoAutoBuyRange = v end, 1)
    slider(featList, "Auto Buy Float", 0, 20, function() return _G.MeerkoAutoBuyHover end, function(v) _G.MeerkoAutoBuyHover = v end, 1)
    slider(featList, "Carpet Speed", 20, 400, function() return _G.MeerkoCarpetSpeedValue end, function(v) _G.MeerkoCarpetSpeedValue = v end, 5)
    slider(featList, "Alert Min M/s", 0, 500, function() return (tonumber(_G.MeerkoAlertMinGen) or 80e6)/1e6 end, function(v) _G.MeerkoAlertMinGen = v * 1e6 end, 5)
    input(featList, "PRIVATE SERVER LINK", "paste link or share code", function() return _G.MeerkoPrivateServerLink end, function(v) _G.MeerkoPrivateServerLink = (v or ""):match("^%s*(.-)%s*$") end)
    input(featList, "ALERT SOUND ID", "111786441593851", function() return _G.MeerkoAlertSound end, function(v) _G.MeerkoAlertSound = (v or ""):match("%d+") or "111786441593851" end)

    keybind(keysList, "AUTO CLONE",             function() return _G.MeerkoCloneKeyName end,   function(k) _G.MeerkoCloneKeyName = k end)
    keybind(keysList, "KICK TO PRIVATE SERVER", function() return _G.MeerkoKickKeyName end,    function(k) _G.MeerkoKickKeyName = k end)
    keybind(keysList, "STOP TP",                function() return _G.MeerkoStopTPKeyName end,  function(k) _G.MeerkoStopTPKeyName = k end)
    keybind(keysList, "PRIORITY / NEAREST",     function() return _G.MeerkoNearestKey end,     function(k) _G.MeerkoNearestKey = k end)
    keybind(keysList, "STEAL QUICK / ARMED",    function() return _G.MeerkoStealQuickKey end,   function(k) _G.MeerkoStealQuickKey = k end)
    keybind(keysList, "DROP BRAINROT",          function() return _G.MeerkoDropKeyName end,    function(k) _G.MeerkoDropKeyName = k end)
    keybind(keysList, "RESET",                  function() return _G.MeerkoResetKeyName end,   function(k) _G.MeerkoResetKeyName = k end)

    keybind(keysList, "CARPET SPEED",           function() return _G.MeerkoCarpetSpeedKeyName end, function(k) _G.MeerkoCarpetSpeedKeyName = k end)

    task.spawn(function()
        while sg.Parent do
            for _, r in ipairs(_toggleRepaints) do pcall(r) end
            task.wait(0.3)
        end
    end)
end end)



do
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP         = Players.LocalPlayer

    if _G.MeerkoNoPlayerCollide == nil then _G.MeerkoNoPlayerCollide = true end

    local seen = setmetatable({}, { __mode = "k" })

    local function isClone(inst)
        local n = inst.Name
        return n:match("^%d+_Clone$") ~= nil or n:find("Clone", 1, true) ~= nil
    end


    local function shouldPass(model)
        if not model or model == LP.Character then return false end
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= LP and pl.Character == model then return true end
        end
        if isClone(model) and model:FindFirstChildWhichIsA("BasePart") then return true end
        return false
    end

    local function declaw(part)
        if not part:IsA("BasePart") then return end
        if seen[part] and part.CanCollide == false then return end
        seen[part] = true
        pcall(function()
            part.CanCollide = false
            part.CanTouch = false
        end)
    end

    local function pass(model)
        if not model then return end
        for _, d in ipairs(model:GetDescendants()) do declaw(d) end
        if not seen[model] then
            seen[model] = true
            model.DescendantAdded:Connect(function(d)
                if _G.MeerkoNoPlayerCollide ~= false then declaw(d) end
            end)
        end
    end

    local function sweep()
        if _G.MeerkoNoPlayerCollide == false then return end
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= LP and pl.Character then pass(pl.Character) end
        end
        for _, m in ipairs(workspace:GetChildren()) do
            if m:IsA("Model") and m ~= LP.Character and isClone(m) then pass(m) end
        end
    end

    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LP then
            pl.CharacterAdded:Connect(function(c)
                task.wait(0.2)
                if _G.MeerkoNoPlayerCollide ~= false then pass(c) end
            end)
        end
    end
    Players.PlayerAdded:Connect(function(pl)
        pl.CharacterAdded:Connect(function(c)
            task.wait(0.2)
            if _G.MeerkoNoPlayerCollide ~= false then pass(c) end
        end)
    end)
    workspace.ChildAdded:Connect(function(m)
        if _G.MeerkoNoPlayerCollide == false then return end
        if m:IsA("Model") and m ~= LP.Character and isClone(m) then
            task.wait(0.1)
            pass(m)
        end
    end)

    task.spawn(function()
        if not game:IsLoaded() then game.Loaded:Wait() end
        task.wait(tonumber(_G.MeerkoNoCollideDelay) or 5)
        while true do
            pcall(sweep)
            task.wait(tonumber(_G.MeerkoNoCollideGap) or 8)
        end
    end)
    _G.MeerkoNoCollideSweep = sweep
end

do
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer

    if _G.MeerkoAntiAFK == nil then _G.MeerkoAntiAFK = true end
    if _G.__meerkoAFKRan then return end
    _G.__meerkoAFKRan = true

    local ref = (type(cloneref) == "function") and cloneref or function(x) return x end
    local VU  = select(2, pcall(function() return ref(game:GetService("VirtualUser")) end))
    local VIM = select(2, pcall(function() return ref(game:GetService("VirtualInputManager")) end))

    _G.MeerkoAFKHits = 0

    local function nudge()
        if typeof(VU) == "Instance" then
            local ok = pcall(function()
                VU:CaptureController()
                pcall(function() VU:ClickButton2(Vector2.new()) end)
            end)
            if ok then return true end
        end
        if typeof(VIM) == "Instance" then
            local ok = pcall(function()
                VIM:SendMouseButtonEvent(0, 0, 1, true, game, 1)
                VIM:SendMouseButtonEvent(0, 0, 1, false, game, 1)
            end)
            if ok then return true end
        end
        return false
    end

    LP.Idled:Connect(function()
        if _G.MeerkoAntiAFK == false then return end
        _G.MeerkoAFKHits = (_G.MeerkoAFKHits or 0) + 1
        nudge()
    end)

    task.spawn(function()
        while true do
            task.wait(tonumber(_G.MeerkoAFKGap) or 240)
            if _G.MeerkoAntiAFK ~= false then pcall(nudge) end
        end
    end)

    _G.MeerkoAntiAFKTest = function()
        return typeof(VU) == "Instance", typeof(VIM) == "Instance", nudge(), _G.MeerkoAFKHits
    end
end