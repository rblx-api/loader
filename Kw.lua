-- ============================================================================
-- fadeaway - Mobile Version
-- ============================================================================
-- game loaded check removed
local Players,RunService,UIS,TS,Lighting,HS = game:GetService("Players"),game:GetService("RunService"),game:GetService("UserInputService"),game:GetService("TweenService"),game:GetService("Lighting"),game:GetService("HttpService")
local LP = Players.LocalPlayer

-- ANTI-KICK PROTECTION - ELITE 10X ENHANCED
task.spawn(function() end)

local NS,CS = 60,30
local LAGGER_SPEED = 15
local LAGGER_CARRY_SPEED = 24.5
local speedMode,antiRagdollEnabled,infJumpEnabled = false,false,false
local infJumpMode = "manual"  -- "manual" or "hold"
local laggerToggled = false
local laggerPhase = 0
local medusaCounterEnabled = false
local batCounterEnabled = false
local unwalkEnabled = false
local medusaDebounce,medusaLastUsed = false,0
local dropBrainrotActive = false
local autoLeftEnabled,autoRightEnabled = false,false
local autoLeftSetVisual,autoRightSetVisual = nil,nil
local speedLabel = nil
local autoBatEnabled = false
local autoSwingEnabled = true
local autoBatSetVisual = nil
local autoBatEquippedThisRun = false
local _autoBatTarget = nil
local _autoBatLastScan = 0
local resetAutoBatMotion = nil
local AUTO_BAT_SPEED,AUTO_BAT_VERT_SPEED,AUTO_BAT_DIST,AUTO_BAT_HEIGHT,AUTO_BAT_V_OFF,AUTO_BAT_TURN_SPEED,AUTO_BAT_MAX_TURN_RATE = 58,52,-2.8,4.75,1,285,28
local setBatCounterVisual = nil
local startBatCounter,stopBatCounter
local antiLagEnabled = false
local antiLagStopFn = nil
local setAntiLagVisual = nil
local stretchRezEnabled = false
local stretchRezConn = nil
local setStretchRezVisual = nil
local tryhardAnimEnabled = false
local setTryhardAnimVisual = nil
local originalAnims = nil
local unwalkSavedAnimate = nil
local _anyKeyListening = false
local autoTPEnabled = false
local autoTPHeight = 20
local autoTPConn = nil
local setAutoTPVisual = nil
local uiLocked = false

-- SKIN CHANGER STATE
local SC_headlessEnabled = false
local SC_korbloxEnabled = false
local SC_currentOutfit = "Default"
local SC_selectedAnimPack = "Adidas Sports"
local SC_animationPackActive = false
local SC_cosmeticState = setmetatable({},{__mode="k"})
local SC_animApplyGeneration = 0

local SC_HEADLESS_MESH_ID = "rbxassetid://1095708"
local SC_KORBLOX_MESH_ID = "rbxassetid://101851696"
local SC_KORBLOX_TEXTURE_ID = "rbxassetid://101851254"

local SC_ANIMATION_PACKS = {
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
	Werewolf={WalkAnim=10921342074,RunAnim=10921336997,JumpAnim=10921339758,FallAnim=10921337907,SwimIdle=10921341319,Swim=10921340419,ClimbAnim=10921329322,Animation1=10921330408,Animation2=10921333667},
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

local SC_OUTFIT_DEFS = {
	["Outfit 1"]={shirt="rbxassetid://11814874288",pants="rbxassetid://77686770169224"},
	["Outfit 2"]={shirt="rbxassetid://7791905291",pants="rbxassetid://84715951225041"},
	["Outfit 3"]={shirt="rbxassetid://136747635179752",pants="rbxassetid://4620736485"},
}

local function SC_animPick(pack,...)
	for i=1,select("#",...) do local v=pack[select(i,...)]; if v~=nil then return v end end
	return nil
end
local function SC_ensureAnim(folder,name)
	if not folder then return nil end
	local obj=folder:FindFirstChild(name)
	if not obj then obj=Instance.new("Animation"); obj.Name=name; obj.Parent=folder end
	return obj
end
local function SC_applyAnimPack(packName,char)
	local pack=SC_ANIMATION_PACKS[packName]; if not pack then return false end
	SC_animApplyGeneration=SC_animApplyGeneration+1
	local gen=SC_animApplyGeneration
	char=char or LP.Character; if not char then return false end
	local animate,ready
	for _=1,40 do
		animate=char:FindFirstChild("Animate")
		if animate and animate:FindFirstChild("idle") and animate:FindFirstChild("run") and animate:FindFirstChild("walk") then ready=true;break end
		task.wait(.1)
	end
	if not ready or gen~=SC_animApplyGeneration then return false end
	local hum=char:FindFirstChildOfClass("Humanoid")
	local animator=hum and hum:FindFirstChildOfClass("Animator")
	local canToggle=animate:IsA("LocalScript") or animate:IsA("Script")
	if canToggle then pcall(function() animate.Disabled=true end) end
	RunService.Heartbeat:Wait()
	local tracks=animator and animator:GetPlayingAnimationTracks() or (hum and hum:GetPlayingAnimationTracks() or {})
	for _,track in ipairs(tracks) do
		if track.Priority==Enum.AnimationPriority.Core or track.Priority==Enum.AnimationPriority.Idle or track.Priority==Enum.AnimationPriority.Movement then
			pcall(function() track:Stop(.12) end)
		end
	end
	local function assetId(id)
		if not id then return nil end
		local digits=tostring(id):match("%d+")
		return digits and ("rbxassetid://"..digits) or nil
	end
	local function setAnim(folder,objName,id)
		local obj=SC_ensureAnim(animate:FindFirstChild(folder),objName)
		local resolved=assetId(id)
		if obj and resolved and obj.AnimationId~=resolved then obj.AnimationId=resolved end
	end
	setAnim("walk","WalkAnim",SC_animPick(pack,"WalkAnim","Walk")); setAnim("run","RunAnim",SC_animPick(pack,"RunAnim","Run"))
	setAnim("jump","JumpAnim",SC_animPick(pack,"JumpAnim","Jump")); setAnim("fall","FallAnim",SC_animPick(pack,"FallAnim","Fall"))
	setAnim("climb","ClimbAnim",SC_animPick(pack,"ClimbAnim","Climb")); setAnim("swim","Swim",SC_animPick(pack,"Swim"))
	setAnim("swimidle","SwimIdle",SC_animPick(pack,"SwimIdle") or SC_animPick(pack,"Swim"))
	local idle=animate:FindFirstChild("idle")
	if idle then
		local ids=pack.Idle or {SC_animPick(pack,"Animation1"),SC_animPick(pack,"Animation2")}
		if ids[1] or ids[2] then
			local id1=ids[1] or ids[2]; local id2=ids[2] or ids[1]
			local a1=SC_ensureAnim(idle,"Animation1"); local a2=SC_ensureAnim(idle,"Animation2")
			if a1 then a1.AnimationId=assetId(id1) end
			if a2 then a2.AnimationId=assetId(id2) end
			for _,child in ipairs(idle:GetChildren()) do
				if child:IsA("Animation") and child~=a1 and child~=a2 then child:Destroy() end
			end
			if a1 and not a1:FindFirstChild("Weight") then local w=Instance.new("NumberValue",a1);w.Name="Weight";w.Value=9 end
			if a2 and not a2:FindFirstChild("Weight") then local w=Instance.new("NumberValue",a2);w.Name="Weight";w.Value=1 end
		end
	end
	RunService.Heartbeat:Wait()
	if gen~=SC_animApplyGeneration or not animate.Parent then return false end
	if canToggle then
		local replacement; pcall(function() replacement=animate:Clone() end)
		if replacement then
			replacement.Name="MwVaneSCReload"; replacement.Disabled=true; replacement.Parent=char
			animate:Destroy(); replacement.Name="Animate"; animate=replacement
			RunService.Heartbeat:Wait()
			if gen~=SC_animApplyGeneration or not animate.Parent then return false end
			animate.Disabled=false
		else pcall(function() animate.Disabled=false end) end
	end
	RunService.Heartbeat:Wait()
	local applied=gen==SC_animApplyGeneration and SC_selectedAnimPack==packName
	if applied then SC_animationPackActive=true end
	return applied
end

local function SC_applyHeadless(char,enabled)
	local head=char and char:FindFirstChild("Head"); if not head then return end
	local state=SC_cosmeticState[char] or {}; SC_cosmeticState[char]=state
	if enabled then
		if state.headTransparency==nil then state.headTransparency=head.Transparency; state.headCanCollide=head.CanCollide; local face=head:FindFirstChild("face"); state.face=face and face:Clone() or nil end
		head.Transparency=1; head.CanCollide=false
		local face=head:FindFirstChild("face"); if face then face:Destroy() end
		local old=head:FindFirstChild("MwVaneSCHeadlessMesh"); if old then old:Destroy() end
		local mesh=Instance.new("SpecialMesh",head); mesh.Name="MwVaneSCHeadlessMesh"; mesh.MeshType=Enum.MeshType.FileMesh; mesh.MeshId=SC_HEADLESS_MESH_ID; mesh.Scale=Vector3.new(.001,.001,.001)
	else
		local mesh=head:FindFirstChild("MwVaneSCHeadlessMesh"); if mesh then mesh:Destroy() end
		if state.headTransparency~=nil then
			head.Transparency=state.headTransparency; head.CanCollide=state.headCanCollide
			if state.face and not head:FindFirstChild("face") then state.face:Clone().Parent=head end
			state.headTransparency=nil; state.headCanCollide=nil; state.face=nil
		end
	end
end

local function SC_applyKorblox(char,enabled)
	local hum=char and char:FindFirstChildOfClass("Humanoid"); if not hum then return end
	local state=SC_cosmeticState[char] or {}; SC_cosmeticState[char]=state
	if hum.RigType==Enum.HumanoidRigType.R6 then
		local leg=char:FindFirstChild("Right Leg"); if not leg then return end
		if enabled then
			if not state.r6LegColor then state.r6LegColor=leg.Color; state.r6Meshes={}; for _,v in ipairs(leg:GetChildren()) do if v:IsA("SpecialMesh") or v:IsA("CharacterMesh") then table.insert(state.r6Meshes,v:Clone()); v:Destroy() end end end
			leg.Color=Color3.fromRGB(64,64,64); local old=leg:FindFirstChild("MwVaneSCKorbloxMesh"); if old then old:Destroy() end
			local mesh=Instance.new("SpecialMesh",leg); mesh.Name="MwVaneSCKorbloxMesh"; mesh.MeshType=Enum.MeshType.FileMesh; mesh.MeshId=SC_KORBLOX_MESH_ID; mesh.TextureId=SC_KORBLOX_TEXTURE_ID
		else
			local mesh=leg:FindFirstChild("MwVaneSCKorbloxMesh"); if mesh then mesh:Destroy() end
			if state.r6LegColor then leg.Color=state.r6LegColor end
			if state.r6Meshes then for _,v in ipairs(state.r6Meshes) do v:Clone().Parent=leg end end
			state.r6LegColor=nil; state.r6Meshes=nil
		end
	else
		local upper=char:FindFirstChild("RightUpperLeg"); local lower=char:FindFirstChild("RightLowerLeg"); local foot=char:FindFirstChild("RightFoot")
		if not upper then return end
		if enabled then
			if not state.r15Transparency then state.r15Transparency={upper.Transparency,lower and lower.Transparency or 0,foot and foot.Transparency or 0} end
			upper.Transparency=1; if lower then lower.Transparency=1 end; if foot then foot.Transparency=1 end
			local old=char:FindFirstChild("MwVaneSCKorbloxLeg"); if old then old:Destroy() end
			local leg=Instance.new("Part",char); leg.Name="MwVaneSCKorbloxLeg"; leg.Size=Vector3.new(1,2,1); leg.Anchored=false; leg.CanCollide=false; leg.Massless=true; leg.Color=Color3.fromRGB(64,64,64)
			local mesh=Instance.new("SpecialMesh",leg); mesh.MeshType=Enum.MeshType.FileMesh; mesh.MeshId=SC_KORBLOX_MESH_ID; mesh.TextureId=SC_KORBLOX_TEXTURE_ID
			local weld=Instance.new("Weld",leg); weld.Name="MwVaneSCKorbloxWeld"; weld.Part0=upper; weld.Part1=leg; weld.C0=CFrame.new(0,-.8,0)
		else
			local vals=state.r15Transparency
			if vals then upper.Transparency=vals[1]; if lower then lower.Transparency=vals[2] end; if foot then foot.Transparency=vals[3] end end
			local leg=char:FindFirstChild("MwVaneSCKorbloxLeg"); if leg then leg:Destroy() end; state.r15Transparency=nil
		end
	end
end

local function SC_applyOutfit(char,name)
	if not char then return end
	-- Clear previous outfit accessories
	for _,acc in ipairs(char:GetChildren()) do
		if acc:IsA("Accessory") and (acc.Name=="MwVaneSCFit1Hair" or acc.Name=="MwVaneSCFitHeadAcc") then acc:Destroy() end
	end
	local def=SC_OUTFIT_DEFS[name]
	if not def then
		-- Default: remove shirt/pants added by us and restore headless off
		SC_applyHeadless(char,false)
		local shirt=char:FindFirstChild("MwVaneSCShirt"); if shirt then shirt:Destroy() end
		local pants=char:FindFirstChild("MwVaneSCPants"); if pants then pants:Destroy() end
		return
	end
	SC_applyHeadless(char,true)
	local shirt=char:FindFirstChildOfClass("Shirt")
	if not shirt then shirt=Instance.new("Shirt",char); shirt.Name="MwVaneSCShirt" end
	shirt.ShirtTemplate=def.shirt
	local pants=char:FindFirstChildOfClass("Pants")
	if not pants then pants=Instance.new("Pants",char); pants.Name="MwVaneSCPants" end
	pants.PantsTemplate=def.pants
	if name=="Outfit 1" then
		pcall(function()
			local hair=Instance.new("Accessory",char); hair.Name="MwVaneSCFit1Hair"
			local handle=Instance.new("Part",hair); handle.Name="Handle"; handle.Size=Vector3.new(2,2,2); handle.CanCollide=false
			local mesh=Instance.new("SpecialMesh",handle); mesh.MeshType=Enum.MeshType.FileMesh; mesh.MeshId="rbxassetid://78289009309744"; mesh.TextureId="rbxassetid://78289009309744"; mesh.Scale=Vector3.new(1.25,1.25,1.25)
			local weld=Instance.new("Weld",handle); local head=char:FindFirstChild("Head")
			if head then weld.Part0=head; weld.Part1=handle; weld.C0=CFrame.new(0,0.2,-0.1) end
		end)
	end
end

local function SC_onCharacter(char)
	task.wait(0.3)
	SC_applyHeadless(char,SC_headlessEnabled)
	SC_applyKorblox(char,SC_korbloxEnabled)
	SC_applyOutfit(char,SC_currentOutfit)
	if SC_animationPackActive and SC_selectedAnimPack and SC_ANIMATION_PACKS[SC_selectedAnimPack] then
		task.spawn(function() task.wait(.3); SC_applyAnimPack(SC_selectedAnimPack,char) end)
	end
end

local setLockUIVisual = nil
local KB = {
	DropBrainrot={kb=Enum.KeyCode.X,gp=nil},
	AutoLeft    ={kb=Enum.KeyCode.Z,gp=nil},
	AutoRight   ={kb=Enum.KeyCode.C,gp=nil},
	AutoBat     ={kb=Enum.KeyCode.E,gp=nil},
	TPBat       ={kb=Enum.KeyCode.V,gp=nil},
	TPFloor     ={kb=Enum.KeyCode.F,gp=nil},
	GuiHide     ={kb=Enum.KeyCode.LeftControl,gp=nil},
	SpeedToggle ={kb=Enum.KeyCode.Q,gp=nil},
	LaggerToggle={kb=Enum.KeyCode.R,gp=nil},
}

-- ============================================================================
-- KEYBIND AUTO-SAVE SYSTEM
-- ============================================================================
--[[ 
	KEYBIND AUTO-SAVE DOCUMENTATION:
	
	All keybinds are automatically saved to "fadeaway_settings.json" every 5 seconds.
	When the script loads, it automatically restores your saved keybinds.
	
	USAGE EXAMPLES:
	
	1. Manually change a keybind (from UI or code):
	   _G.updateKeybind("DropBrainrot", Enum.KeyCode.V)
	   
	2. Check current keybind:
	   print(KB.AutoLeft.kb.Name)  -- Outputs: Z
	   
	3. List all keybinds:
	   for name, data in pairs(KB) do
	       print(name .. " = " .. (data.kb and data.kb.Name or "Not Set"))
	   end
	
	4. The following keybinds are available to change:
	   - DropBrainrot (Default: X)
	   - AutoLeft (Default: Z)
	   - AutoRight (Default: C)
	   - AutoBat (Default: E)
	   - TPFloor (Default: F)
	   - GuiHide (Default: LeftControl)
	   - SpeedToggle (Default: Q)
	   - LaggerToggle (Default: R)
	
	All changes are automatically saved within 0.1 seconds of being made!
--]]

local function updateKeybind(name, newKeyCode)
	if KB[name] then
		KB[name].kb = newKeyCode
		-- Save immediately when a keybind is changed
		task.spawn(function()
			task.wait(0.1)
			if _G._saveConfig then _G._saveConfig() end
		end)
		return true
	end
	return false
end

-- Export updateKeybind function globally for UI and script access
_G.updateKeybind = updateKeybind
local AP_L1,AP_L2 = Vector3.new(-476.47,-6.28,92.73),Vector3.new(-483.12,-4.95,94.81)
local AP_R1,AP_R2 = Vector3.new(-476.16,-6.52,25.62),Vector3.new(-483.06,-5.03,25.48)
local Steal = {
	AutoStealEnabled=false,StealMode="Normal",
	STEAL_HOLD_MIN=1.3,STEAL_HOLD_MAX=2.6,STEAL_ENTRY_DELAY=0.3,STEAL_PRIME_RANGE=80,
	Data={},
	-- Mode-specific values
	Modes={
		Normal={StealRadius=60, StealDuration=1.4},
		Semi={StealRadius=9, StealDuration=1.1}
	}
}

-- Function to get current mode values
local function getStealValues()
	return Steal.Modes[Steal.StealMode] or Steal.Modes["Normal"]
end

-- Accessor functions for dynamic values
function Steal:getRadius() return getStealValues().StealRadius end
function Steal:getDuration() return getStealValues().StealDuration end

-- Helper to switch modes
function Steal:setMode(mode)
	if Steal.Modes[mode] then
		Steal.StealMode = mode
	end
end
local isStealing = false
local stealCache = {}
local StealState = {active=false,startTime=0,phase="idle",label="IDLE",lastResult="",lastResultTime=0}
local Conns = {autoSteal=nil,antiRag=nil,batCounter=nil,anchor={},progress=nil,esp={},mwvaneTPBat=nil}

-- ============================================================
-- MWVANE TP BAT (PORTED FROM Candy tp.txt)
-- ============================================================
do
	_G.mwvaneTPBatToggled = false
	_G.mwvaneTPBatHittingCooldown = false
	_G.MWVANE_TP_BAT_RANGE = _G.MWVANE_TP_BAT_RANGE or _G.CANDY_TP_BAT_RANGE or 100
	local MWVANE_TP_HIT_COOLDOWN = 0.08
	
	local function getMwVaneTPBat()
		local char = LP.Character
		if not char then return nil end
		local tool = char:FindFirstChild("Bat")
		if tool then return tool end
		local bp = LP:FindFirstChild("Backpack")
		if bp then
			tool = bp:FindFirstChild("Bat")
			if tool then tool.Parent = char; return tool end
		end
		return nil
	end
	
	local function tryMwVaneTPHit()
		if _G.mwvaneTPBatHittingCooldown then return end
		_G.mwvaneTPBatHittingCooldown = true
		pcall(function()
			local bat = getMwVaneTPBat()
			if bat then
				bat:Activate()
				local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
				if ev then ev:FireServer() end
			end
		end)
		task.delay(MWVANE_TP_HIT_COOLDOWN, function() _G.mwvaneTPBatHittingCooldown = false end)
	end
	
	local function getMwVaneTPClosest()
		local char = LP.Character
		if not char then return nil end
		local root = char:FindFirstChild("HumanoidRootPart")
		if not root then return nil end
		local closest, bestDist = nil, _G.MWVANE_TP_BAT_RANGE
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LP and p.Character then
				local tr = p.Character:FindFirstChild("HumanoidRootPart")
				if tr then
					local d = (tr.Position - root.Position).Magnitude
					if d < bestDist then closest, bestDist = p, d end
				end
			end
		end
		return closest
	end
	
	local function startMwVaneTPBat()
		if Conns.mwvaneTPBat then return end
		Conns.mwvaneTPBat = RunService.Heartbeat:Connect(function()
			if not _G.mwvaneTPBatToggled then return end
			local char = LP.Character
			if not char then return end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			local hum = char:FindFirstChildOfClass("Humanoid")
			if not hrp or not hum then return end
			local animator = hum:FindFirstChildOfClass("Animator")
			if animator then
				local tracks = animator:GetPlayingAnimationTracks()
				for i = #tracks, 1, -1 do pcall(function() tracks[i]:Stop() end) end
			end
			local target = getMwVaneTPClosest()
			if target and target.Character then
				local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
				if targetRoot then
					if sethiddenproperty then pcall(sethiddenproperty, hrp, "PhysicsRepRootPart", targetRoot) end
					local targetPos = targetRoot.Position + Vector3.new(0, 0.9, 0)
					if (hrp.Position - targetPos).Magnitude > 8 then hrp.CFrame = CFrame.new(targetPos) end
					local cam = workspace.CurrentCamera
					if cam then cam.CFrame = CFrame.new(cam.CFrame.Position, targetRoot.Position) end
					tryMwVaneTPHit()
				end
			end
			for _, v in ipairs(char:GetDescendants()) do
				if v:IsA("BasePart") then v.CanCollide = false end
			end
		end)
	end
	
	local function stopMwVaneTPBat()
		if Conns.mwvaneTPBat then
			Conns.mwvaneTPBat:Disconnect()
			Conns.mwvaneTPBat = nil
		end
		local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
		if root and sethiddenproperty then pcall(sethiddenproperty, root, "PhysicsRepRootPart", root) end
	end
	
	_G.startMwVaneTPBat = startMwVaneTPBat
	_G.stopMwVaneTPBat = stopMwVaneTPBat
	_G.getClosestMwVaneTP = getMwVaneTPClosest
	_G.tryHitMwVaneTP = tryMwVaneTPHit
end
local MEDUSA_COOLDOWN = 25
local batCounterDebounce = false
local progressRadLbl,progressFill,progressPct
local modeValLbl
local lastMoveDir = Vector3.new(0,0,0)
local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
	[Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}

-- S2 Velocity Masking System
local velChecked = {}
local hookedVelParts = {}

local function setupVelChecked(char)
	velChecked = {}
	if not char then return end
	local hrp = char:WaitForChild("HumanoidRootPart", 5)
	if hrp then velChecked[hrp] = true end
	return hrp
end

local function hookVelHRP(hrp)
	if not hrp or hookedVelParts[hrp] then return end
	hookedVelParts[hrp] = true
	local mt = getrawmetatable(hrp)
	if not mt then return end
	setreadonly(mt, false)
	local originalVelIndex = rawget(mt, "__index")
	mt.__index = newcclosure(function(self, key)
		if not checkcaller() and velChecked[self] and (key == "AssemblyLinearVelocity" or key == "Velocity") then
			local real
			if type(originalVelIndex) == "function" then
				real = originalVelIndex(self, key)
			elseif type(originalVelIndex) == "table" then
				real = originalVelIndex[key]
			end
			if real.Magnitude > 20 then
				return real.Unit * 20
			end
			return real
		end
		if type(originalVelIndex) == "function" then
			return originalVelIndex(self, key)
		elseif type(originalVelIndex) == "table" then
			return originalVelIndex[key]
		end
	end)
	setreadonly(mt, true)
end

local function applyVel(part, targetVel)
	if not part or not part.Parent then return end
	local mass = part.AssemblyMass
	if mass and mass > 0 then
		local delta = targetVel - part.AssemblyLinearVelocity
		part:ApplyImpulse(delta * mass)
	else
		part.AssemblyLinearVelocity = targetVel
	end
end

local function applyVelocitySpeed(dir, speed)
	local char = LP.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not char or not hum or not root or hum.Health <= 0 then return end
	if dir and dir.Magnitude > 0.05 then
		pcall(function()
			if root.SetNetworkOwner then root:SetNetworkOwner(LP) end
		end)
		local unit = dir.Unit
		applyVel(root, Vector3.new(unit.X * speed, root.AssemblyLinearVelocity.Y, unit.Z * speed))
	else
		applyVel(root, Vector3.new(0, root.AssemblyLinearVelocity.Y, 0))
	end
end

local function getActiveMoveSpeed()
	return laggerToggled and (laggerPhase==2 and LAGGER_CARRY_SPEED or LAGGER_SPEED) or (speedMode and CS or NS)
end
local function getAutoPathSpeed()
	return laggerToggled and LAGGER_SPEED or NS
end
local function isRagdollState(hum)
		if not hum then return false end
		local st=hum:GetState()
		return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown
	end

	task.spawn(function()
				while task.wait(0.1) do
					pcall(function()
						for _, p in ipairs(Players:GetPlayers()) do
							if p ~= LP and p.Character then
								local hum = p.Character:FindFirstChildOfClass("Humanoid")
								if hum then
									-- ESP Logic
									if _G.espEnabled or _G.lineEspEnabled then
										local char = p.Character
										local root = char:FindFirstChild("HumanoidRootPart")
										if root then
											if not Conns.esp[p] then Conns.esp[p] = {} end
											
											-- Box ESP
											if _G.espEnabled and not Conns.esp[p].box then
												local bg = Instance.new("BillboardGui")
												bg.Name = "ESP_" .. p.Name
												bg.AlwaysOnTop = true
												bg.Size = UDim2.new(4, 0, 5.5, 0)
												bg.Adornee = root
												
												local box = Instance.new("Frame", bg)
												box.Size = UDim2.new(1, 0, 1, 0)
												box.BackgroundTransparency = 1
												local stroke = Instance.new("UIStroke", box)
												stroke.Color = Color3.fromRGB(255, 255, 255)
												stroke.Thickness = 1.5
												
												local lbl = Instance.new("TextLabel", bg)
												lbl.Size = UDim2.new(1, 0, 0, 20)
												lbl.Position = UDim2.new(0, 0, 0, -25)
												lbl.BackgroundTransparency = 1
												lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
												lbl.Font = Enum.Font.GothamBold
												lbl.TextSize = 12
												lbl.Text = p.Name
												lbl.TextStrokeTransparency = 0.5
												
												local targetGui = LP:FindFirstChild("PlayerGui")
												if targetGui then bg.Parent = targetGui end
												Conns.esp[p].box = bg
											elseif not _G.espEnabled and Conns.esp[p].box then
												pcall(function() Conns.esp[p].box:Destroy() end)
												Conns.esp[p].box = nil
											end
	
											-- Line ESP (Tracers)
											if _G.lineEspEnabled and not Conns.esp[p].line then
												local line = Drawing.new("Line")
												line.Visible = true
												line.To = Vector2.new(0, 0)
												line.Color = Color3.fromRGB(255, 255, 255)
												line.Thickness = 1.5
												line.Transparency = 0.7
												Conns.esp[p].line = line
											elseif not _G.lineEspEnabled and Conns.esp[p].line then
												pcall(function() Conns.esp[p].line:Remove() end)
												Conns.esp[p].line = nil
											end
	
											-- Update Line Position
											if Conns.esp[p].line then
												local myChar = LP.Character
												local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
												local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(root.Position)
												
												if onScreen and myRoot then
													local myScreenPos = workspace.CurrentCamera:WorldToViewportPoint(myRoot.Position)
													Conns.esp[p].line.Visible = true
													Conns.esp[p].line.From = Vector2.new(myScreenPos.X, myScreenPos.Y)
													Conns.esp[p].line.To = Vector2.new(screenPos.X, screenPos.Y)
												else
													Conns.esp[p].line.Visible = false
												end
											end
										end
									end
								end
							end
						end
						
						-- Cleanup ESP
						for p, data in pairs(Conns.esp) do
							local shouldKeep = p.Parent and p.Character and (_G.espEnabled or _G.lineEspEnabled)
							if not shouldKeep then
								if data.box then pcall(function() data.box:Destroy() end) end
								if data.line then pcall(function() data.line:Remove() end) end
								Conns.esp[p] = nil
							end
						end
					end)
				end
			end)

local function isMyPlotByName(plotName)
	local plots=workspace:FindFirstChild("Plots")
	if not plots then return false end
	local plot=plots:FindFirstChild(plotName)
	if not plot then return false end
	local sign=plot:FindFirstChild("PlotSign")
	if sign then
		local yb=sign:FindFirstChild("YourBase")
		if yb and yb:IsA("BillboardGui") then
			return yb.Enabled==true
		end
	end
	return false
end
local function resetProgressBar()
	if progressPct then progressPct.Text="0%" end
	if progressFill then progressFill.Size=UDim2.new(0,0,1,0) end
end
local function findNearestPrompt()
	local char=LP.Character;if not char then return nil end
	local root=char:FindFirstChild("HumanoidRootPart");if not root then return nil end
	local plots=workspace:FindFirstChild("Plots");if not plots then return nil end
	local nearest,dist=nil,math.huge
	-- Use larger detection range for Semi mode, smaller for Normal mode
	local detectionRange = (Steal.StealMode == "Semi") and Steal.STEAL_PRIME_RANGE or Steal:getRadius()
	for _,plot in ipairs(plots:GetChildren()) do
		if isMyPlotByName(plot.Name) then continue end
		local pods=plot:FindFirstChild("AnimalPodiums");if not pods then continue end
		for _,pod in ipairs(pods:GetChildren()) do
			local base=pod:FindFirstChild("Base")
			local sp=base and base:FindFirstChild("Spawn")
			if sp then
				local d=(sp.Position-root.Position).Magnitude
				if d<=detectionRange and d<dist then
					local att=sp:FindFirstChild("PromptAttachment")
					if att then
						for _,prompt in ipairs(att:GetChildren()) do
							if prompt:IsA("ProximityPrompt") and prompt.ActionText:find("Steal") then
								nearest,dist=prompt,d
							end
						end
					end
				end
			end
		end
	end
	return nearest
end
local function buildCallbacks(prompt)
	if stealCache[prompt] then return end
	local data={holdCallbacks={},triggerCallbacks={},ready=true}
	local ok1,c1=pcall(getconnections,prompt.PromptButtonHoldBegan)
	if ok1 and type(c1)=="table" then
		for _,conn in ipairs(c1) do
			if type(conn.Function)=="function" then
				table.insert(data.holdCallbacks,conn.Function)
			end
		end
	end
	local ok2,c2=pcall(getconnections,prompt.Triggered)
	if ok2 and type(c2)=="table" then
		for _,conn in ipairs(c2) do
			if type(conn.Function)=="function" then
				table.insert(data.triggerCallbacks,conn.Function)
			end
		end
	end
	if #data.holdCallbacks>0 or #data.triggerCallbacks>0 then
		stealCache[prompt]=data
	end
end
local function distToPrompt(prompt)
	local char=LP.Character;if not char then return math.huge end
	local hrp=char:FindFirstChild("HumanoidRootPart")
	if not hrp then return math.huge end
	-- Navigate up the hierarchy: ProximityPrompt -> PromptAttachment -> Spawn -> Base -> AnimalPodium
	local att = prompt.Parent
	if not att or not att:IsA("Attachment") then return math.huge end
	local spawn = att.Parent
	if not spawn or spawn.Name ~= "Spawn" then return math.huge end
	return (hrp.Position - spawn.Position).Magnitude
end
local function execStealNormal(prompt)
	local data=stealCache[prompt]
	if not data or not data.ready then return false end
	if #data.holdCallbacks == 0 and #data.triggerCallbacks == 0 then return false end
	data.ready=false;isStealing=true
	
	StealState.active=true
	StealState.startTime=tick()
	StealState.phase="normal"
	StealState.label="Normal"
	
	task.spawn(function()
		for _,fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
		local elapsed=0
		while elapsed<Steal:getDuration() do
			elapsed=elapsed+task.wait()
		end
		for _,fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
		task.wait(0.01)
		
		StealState.active=false
		StealState.phase="idle"
		StealState.lastResult="Stole"
		StealState.lastResultTime=tick()
		
		data.ready=true;isStealing=false
	end)
	return true
end
local function execStealSemi(prompt)
	local data=stealCache[prompt]
	if not data or not data.ready then return false end
	if #data.holdCallbacks == 0 and #data.triggerCallbacks == 0 then return false end
	data.ready=false
	isStealing=true
	
	StealState.active=true
	StealState.startTime=tick()
	StealState.phase="holding"
	StealState.label="Holding"
	
	
	task.spawn(function()
		for _,fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
		task.wait(Steal.STEAL_HOLD_MIN)
		
		StealState.phase="waitingRange"
		StealState.label="Waiting"
		
		local alreadyInRange=distToPrompt(prompt)<=Steal:getRadius()
		local fired=false
		while true do
			local elapsed=tick()-StealState.startTime
			if elapsed>Steal.STEAL_HOLD_MAX then break end
			if not prompt.Parent then break end
			if distToPrompt(prompt)<=Steal:getRadius() then
				if not alreadyInRange then task.wait(Steal.STEAL_ENTRY_DELAY) end
				for _,fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
				fired=true
				StealState.label="Stealing"
				break
			end
			task.wait()
		end
		
		StealState.active=false
		StealState.phase="idle"
		
		if fired then
			StealState.lastResult="Stole"
		else
			StealState.lastResult="Missed"
		end
		StealState.lastResultTime=tick()
		
		task.wait(Steal:getDuration()*0.1)
		data.ready=true
		isStealing=false
	end)
	return true
end
local function startAutoSteal()
	if Conns.autoSteal then return end
	Conns.autoSteal=RunService.Heartbeat:Connect(function()
		if not Steal.AutoStealEnabled or isStealing then return end
		local p=findNearestPrompt();if p then
			buildCallbacks(p)
			if Steal.StealMode=="Semi" then
				execStealSemi(p)
			else
				execStealNormal(p)
			end
		end
	end)
end
local function stopAutoSteal()
	if Conns.autoSteal then Conns.autoSteal:Disconnect();Conns.autoSteal=nil end
	if Conns.progress then Conns.progress:Disconnect();Conns.progress=nil end
	isStealing=false;resetProgressBar()
end
RunService.Stepped:Connect(function()
	for _,p in ipairs(Players:GetPlayers()) do
		if p~=LP and p.Character then
			for _,part in ipairs(p.Character:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide=false end
			end
		end
	end
end)
RunService.RenderStepped:Connect(function(dt)
	local char=LP.Character;if not char then return end
	local hum=char:FindFirstChildOfClass("Humanoid")
	local hrp=char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then return end
	if isRagdollState(hum) then lastMoveDir=Vector3.new(0,0,0);return end
	if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled then
		local md=hum.MoveDirection
		local spd=getActiveMoveSpeed()
		local dir=nil
		if md.Magnitude>0 then
			lastMoveDir=md
			dir=md
		elseif antiRagdollEnabled and lastMoveDir.Magnitude>0 then
			local anyHeld=false
			for key in pairs(MOVE_KEYS) do if UIS:IsKeyDown(key) then anyHeld=true;break end end
			if anyHeld then dir=lastMoveDir end
		end
		applyVelocitySpeed(dir, spd)
	end
	if speedLabel then speedLabel.Text=string.format("Speed: %.1f",Vector3.new(hrp.AssemblyLinearVelocity.X,0,hrp.AssemblyLinearVelocity.Z).Magnitude) end
end)
local alConn,arConn=nil,nil
local alPhase,arPhase=1,1
local function stopAutoLeft()
	if alConn then alConn:Disconnect();alConn=nil end;alPhase=1
	local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
	if autoLeftSetVisual then autoLeftSetVisual(false) end
end
local function stopAutoRight()
	if arConn then arConn:Disconnect();arConn=nil end;arPhase=1
	local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
	if autoRightSetVisual then autoRightSetVisual(false) end
end
local function startAutoLeft()
	if alConn then alConn:Disconnect() end;alPhase=1
	alConn=RunService.Heartbeat:Connect(function()
		if not autoLeftEnabled then return end
		local char=LP.Character;if not char then return end
		local hrp=char:FindFirstChild("HumanoidRootPart")
		local hum=char:FindFirstChildOfClass("Humanoid")
		if not hrp or not hum then return end
		if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
		local spd=getAutoPathSpeed()
		if alPhase==1 then
			local tgt=Vector3.new(AP_L1.X,hrp.Position.Y,AP_L1.Z)
			if (tgt-hrp.Position).Magnitude<1 then
				alPhase=2
				local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
				hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
				return
			end
			local d=AP_L1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
		elseif alPhase==2 then
			local tgt=Vector3.new(AP_L2.X,hrp.Position.Y,AP_L2.Z)
			if (tgt-hrp.Position).Magnitude<1 then
				hum:Move(Vector3.zero,false);hrp.AssemblyLinearVelocity=Vector3.zero
				autoLeftEnabled=false;if alConn then alConn:Disconnect();alConn=nil end
				alPhase=1;if autoLeftSetVisual then autoLeftSetVisual(false) end;return
			end
			local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
		end
	end)
end
local function startAutoRight()
	if arConn then arConn:Disconnect() end;arPhase=1
	arConn=RunService.Heartbeat:Connect(function()
		if not autoRightEnabled then return end
		local char=LP.Character;if not char then return end
		local hrp=char:FindFirstChild("HumanoidRootPart")
		local hum=char:FindFirstChildOfClass("Humanoid")
		if not hrp or not hum then return end
		if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
		local spd=getAutoPathSpeed()
		if arPhase==1 then
			local tgt=Vector3.new(AP_R1.X,hrp.Position.Y,AP_R1.Z)
			if (tgt-hrp.Position).Magnitude<1 then
				arPhase=2
				local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
				hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
				return
			end
			local d=AP_R1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
		elseif arPhase==2 then
			local tgt=Vector3.new(AP_R2.X,hrp.Position.Y,AP_R2.Z)
			if (tgt-hrp.Position).Magnitude<1 then
				hum:Move(Vector3.zero,false);hrp.AssemblyLinearVelocity=Vector3.zero
				autoRightEnabled=false;if arConn then arConn:Disconnect();arConn=nil end
				arPhase=1;if autoRightSetVisual then autoRightSetVisual(false) end;return
			end
			local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
		end
	end)
end
local function setupSpeedIndicator(char)
	local head=char:WaitForChild("Head",5);if not head then return end
	local bb=Instance.new("BillboardGui",head)
	bb.Size=UDim2.new(0,160,0,60);bb.StudsOffset=Vector3.new(0,3,0);bb.AlwaysOnTop=true
	speedLabel=Instance.new("TextLabel",bb)
	speedLabel.Size=UDim2.new(1,0,0.56,0);speedLabel.BackgroundTransparency=1
	speedLabel.Text="Speed: 0";speedLabel.TextColor3=Color3.fromRGB(40,200,90)
	speedLabel.Font=Enum.Font.GothamBold;speedLabel.TextScaled=true
	speedLabel.TextStrokeTransparency=0;speedLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)
	local discordLabel=Instance.new("TextLabel",bb)
	discordLabel.Size=UDim2.new(1,0,0.38,0);discordLabel.Position=UDim2.new(0,0,0.58,0)
	discordLabel.BackgroundTransparency=1;discordLabel.Text="discord.gg/mwvanehub"
	discordLabel.TextColor3=Color3.fromRGB(40,200,90);discordLabel.Font=Enum.Font.GothamBold
	discordLabel.TextScaled=true;discordLabel.TextStrokeTransparency=0;discordLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)
end
local function startAntiRagdoll()
	if Conns.antiRag then return end
	Conns.antiRag = RunService.Heartbeat:Connect(function()
		if not antiRagdollEnabled then return end
		
		local char = LP.Character
		if not char then return end
		
		local hum = char:FindFirstChildOfClass("Humanoid")
		local root = char:FindFirstChild("HumanoidRootPart")
		if not (hum and root) then return end
		
		local s = hum:GetState()
		local ragdolled = (s == Enum.HumanoidStateType.Physics or s == Enum.HumanoidStateType.Ragdoll or s == Enum.HumanoidStateType.FallingDown)
		
		local endTime = LP:GetAttribute("RagdollEndTime")
		if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then 
			ragdolled = true 
		end
		
		if ragdolled then
			pcall(function() LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end)
			
			for _, d in ipairs(char:GetDescendants()) do
				if d:IsA("BallSocketConstraint") or (d:IsA("Attachment") and d.Name:find("RagdollAttachment")) then 
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
		end
	end)
end

local function stopAntiRagdoll()
	if Conns.antiRag then 
		Conns.antiRag:Disconnect() 
		Conns.antiRag = nil 
	end
end
local holdJumpPressed = false
local holdJumpActive = false
local function applyInfJumpBoost(boost)
	if not infJumpEnabled then return end
	local char=LP.Character;if not char then return end
	local root=char:FindFirstChild("HumanoidRootPart")
	if root then root.Velocity=Vector3.new(root.Velocity.X,boost,root.Velocity.Z) end
end
-- Inf jump (Manual Mode)
UIS.JumpRequest:Connect(function()
    if not infJumpEnabled or infJumpMode ~= "manual" then return end
    local c=LP.Character; if not c then return end; local root=c:FindFirstChild("HumanoidRootPart")
    if root then root.Velocity=Vector3.new(root.Velocity.X,55,root.Velocity.Z) end
end)
UIS.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.Keyboard and input.KeyCode==Enum.KeyCode.Space and not UIS:GetFocusedTextBox() then
		holdJumpPressed=true
		task.delay(0.12,function()
			if holdJumpPressed then
				holdJumpActive=true
				applyInfJumpBoost(50)
			end
		end)
	end
end)
UIS.InputEnded:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.Keyboard and input.KeyCode==Enum.KeyCode.Space then holdJumpPressed=false;holdJumpActive=false end
end)
-- Hold Inf Jump (Hold Mode)
RunService.Heartbeat:Connect(function()
	if infJumpEnabled and infJumpMode == "hold" then
		local char = LP.Character
		if not char then return end
		local root = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not root or not hum then return end
		
		local jumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or UIS:IsKeyDown(Enum.KeyCode.ButtonA) or hum.Jump
		if jumpHeld and root.Velocity.Y < 38 then
			root.Velocity = Vector3.new(root.Velocity.X, 38, root.Velocity.Z)
		end
	elseif holdJumpActive then
		applyInfJumpBoost(50)
	end
end)
local function startUnwalk()
	local c=LP.Character;if not c then return end
	local hum=c:FindFirstChildOfClass("Humanoid")
	if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
	local anim=c:FindFirstChild("Animate")
	if anim then unwalkSavedAnimate=anim:Clone();anim:Destroy() end
end
local function stopUnwalk()
	local c=LP.Character
	if c and unwalkSavedAnimate then unwalkSavedAnimate:Clone().Parent=c;unwalkSavedAnimate=nil end
end

-- Tryhard Animation Functions
local Anims = {
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

local function isPackAnim(id)
	if not id then return false end
	for _, v in pairs(Anims) do
		if v == id then return true end
	end
	return false
end

local function saveOriginalAnims(char)
	local anim = char:FindFirstChild("Animate")
	if not anim then return end
	
	local function g(o) return o and o.AnimationId or nil end
	local ids = {
		idle1 = g(anim.idle and anim.idle.Animation1),
		idle2 = g(anim.idle and anim.idle.Animation2),
		walk = g(anim.walk and anim.walk.WalkAnim),
		run = g(anim.run and anim.run.RunAnim),
		jump = g(anim.jump and anim.jump.JumpAnim),
		fall = g(anim.fall and anim.fall.FallAnim),
		climb = g(anim.climb and anim.climb.ClimbAnim),
		swim = g(anim.swim and anim.swim.Swim),
		swimidle = g(anim.swimidle and anim.swimidle.SwimIdle),
	}
	
	if not isPackAnim(ids.walk) then
		originalAnims = ids
	end
end

local function applyAnimPack(char)
	local anim = char:FindFirstChild("Animate")
	if not anim then return end
	
	local function s(o, id)
		if o then o.AnimationId = id end
	end
	
	s(anim.idle and anim.idle.Animation1, Anims.idle1)
	s(anim.idle and anim.idle.Animation2, Anims.idle2)
	s(anim.walk and anim.walk.WalkAnim, Anims.walk)
	s(anim.run and anim.run.RunAnim, Anims.run)
	s(anim.jump and anim.jump.JumpAnim, Anims.jump)
	s(anim.fall and anim.fall.FallAnim, Anims.fall)
	s(anim.climb and anim.climb.ClimbAnim, Anims.climb)
	s(anim.swim and anim.swim.Swim, Anims.swim)
	s(anim.swimidle and anim.swimidle.SwimIdle, Anims.swimidle)
end

local function restoreOriginalAnims(char)
	if not originalAnims then return end
	
	local anim = char:FindFirstChild("Animate")
	if not anim then return end
	
	local function s(o, id)
		if o and id then o.AnimationId = id end
	end
	
	s(anim.idle and anim.idle.Animation1, originalAnims.idle1)
	s(anim.idle and anim.idle.Animation2, originalAnims.idle2)
	s(anim.walk and anim.walk.WalkAnim, originalAnims.walk)
	s(anim.run and anim.run.RunAnim, originalAnims.run)
	s(anim.jump and anim.jump.JumpAnim, originalAnims.jump)
	s(anim.fall and anim.fall.FallAnim, originalAnims.fall)
	s(anim.climb and anim.climb.ClimbAnim, originalAnims.climb)
	s(anim.swim and anim.swim.Swim, originalAnims.swim)
	s(anim.swimidle and anim.swimidle.SwimIdle, originalAnims.swimidle)
	
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
		for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
			t:Stop(0)
		end
		hum:ChangeState(Enum.HumanoidStateType.Running)
	end
end

local function startTryhardAnim()
	local char = LP.Character
	if char then
		saveOriginalAnims(char)
		applyAnimPack(char)
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
				t:Stop(0)
			end
			hum:ChangeState(Enum.HumanoidStateType.Running)
		end
	end
end

local function stopTryhardAnim()
	local char = LP.Character
	if char then
		restoreOriginalAnims(char)
	end
end

-- Setup on character spawn
LP.CharacterAdded:Connect(function(char)
	task.wait(0.3)
	hookedVelParts = {}
	local hrp = setupVelChecked(char)
	hookVelHRP(hrp)
	if tryhardAnimEnabled then
		saveOriginalAnims(char)
		applyAnimPack(char)
	end
	SC_onCharacter(char)
end)
local function runDrop()
    if dropBrainrotActive then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    if autoBatEnabled then
        autoBatEnabled=false
        if resetAutoBatMotion then resetAutoBatMotion() end
        if autoBatSetVisual then autoBatSetVisual(false) end
    end
    
    dropBrainrotActive = true
    local t0 = tick()
    local DROP_ASCEND_DURATION = 0.2
    local DROP_ASCEND_SPEED = 150
    local dc
    dc = RunService.Heartbeat:Connect(function()
        local r = char and char:FindFirstChild("HumanoidRootPart")
        if not r then
            dc:Disconnect()
            dropBrainrotActive = false
            return
        end
        if tick() - t0 >= DROP_ASCEND_DURATION then
            dc:Disconnect()
            local rp = RaycastParams.new()
            rp.FilterDescendantsInstances = { char }
            rp.FilterType = Enum.RaycastFilterType.Exclude
            local rr = workspace:Raycast(r.Position, Vector3.new(0, -2000, 0), rp)
            if rr then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local off = (hum and hum.HipHeight or 2) + (r.Size.Y / 2)
                r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + off, r.Position.Z)
                r.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
            dropBrainrotActive = false
            return
        end
        r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, DROP_ASCEND_SPEED, r.AssemblyLinearVelocity.Z)
    end)
end
local function doAutoTPDown(force)
	local char=LP.Character;if not char then return end
	local hrp=char:FindFirstChild("HumanoidRootPart");if not hrp then return end
	local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
	if not force then
		if hum2.FloorMaterial~=Enum.Material.Air then return end
		if hrp.Position.Y<autoTPHeight then return end
	end
local _, tpYaw = hrp.CFrame:ToEulerAnglesYXZ()
hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z)*CFrame.Angles(0,tpYaw,0)
	hrp.AssemblyLinearVelocity=Vector3.zero
end
local function startAutoTP()
	if autoTPConn then task.cancel(autoTPConn);autoTPConn=nil end
	autoTPConn=task.spawn(function()
		while autoTPEnabled do
			task.wait(0.1)
			pcall(function() doAutoTPDown(false) end)
		end
	end)
end
local function stopAutoTP()
	autoTPEnabled=false
	if autoTPConn then task.cancel(autoTPConn);autoTPConn=nil end
end
local function runTPFloor()
	pcall(function() doAutoTPDown(true) end)
end
local function enableStretchRez()
	stretchRezEnabled=true
	workspace.CurrentCamera.FieldOfView=107
	if stretchRezConn then stretchRezConn:Disconnect() end
	stretchRezConn=RunService.RenderStepped:Connect(function()
		if not stretchRezEnabled then stretchRezConn:Disconnect();stretchRezConn=nil;return end
		workspace.CurrentCamera.FieldOfView=107
	end)
end
local function disableStretchRez()
	stretchRezEnabled=false
	if stretchRezConn then stretchRezConn:Disconnect();stretchRezConn=nil end
	workspace.CurrentCamera.FieldOfView=70
end

-- ============================================================================
-- ANTI LAG (adapted from Luatusmuertos, replaces Dawg Optimizer)
-- ============================================================================
local ANTI_LAG = (function()
	local active, generation = false, 0
	local connections = {}
	local saved = setmetatable({}, { __mode = "k" })
	local detached = {}
	local animators = setmetatable({}, { __mode = "k" })
	local stoppedTracks = setmetatable({}, { __mode = "k" })

	local function skyChangerActive()
		return _G._CandyHubSkyMode ~= nil and _G._CandyHubSkyMode ~= "Off"
	end

	local function change(object, property, value)
		pcall(function()
			local original = object[property]
			if original == value then return end
			object[property] = value
			local properties = saved[object]
			if not properties then properties = {}; saved[object] = properties end
			if not properties[property] then properties[property] = { value = original } end
		end)
	end

	local function isProtectedVisual(object)
		local char = LP.Character
		if char and (object == char or object:IsDescendantOf(char)) then return true end
		local parent = object
		while parent and parent ~= workspace do
			if parent:IsA("LayerCollector") or parent:IsA("GuiObject")
			or parent:IsA("GuiBase2d") then return true end
			local name = parent.Name or ""
			if name:match("^Crystal") or name:match("^__Crystal") or name:match("^Eclipse")
			or name:match("^ESP_") or name:match("^SkinChanger_") or name:match("^Korblox_")
			or name:match("^ShadowHub") or name == "StealBar" or name:match("^MwVane")
			or name == "Headless_Headless" or name == "GreenDuelsBB"
			or name == "PredictionSphere" then return true end
			parent = parent.Parent
		end
		if skyChangerActive() and (object == Lighting or object:IsDescendantOf(Lighting)) then return true end
		return false
	end

	local function stopAnimations(animator)
		if animators[animator] then return end
		local char = LP.Character
		if char and animator:IsDescendantOf(char) then return end
		animators[animator] = true
		local token = generation
		local ok, connection = pcall(function()
			return animator.AnimationPlayed:Connect(function(track)
				if not active or generation ~= token then return end
				task.defer(function()
					if active and generation == token then pcall(function() track:Stop(0) end) end
				end)
			end)
		end)
		if ok then table.insert(connections, connection) end
		pcall(function()
			for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
				if track.IsPlaying then
					stoppedTracks[track] = { animator = animator, time = track.TimePosition, speed = track.Speed }
					track:Stop(0)
				end
			end
		end)
	end

	local function apply(object)
		if not active or isProtectedVisual(object) then return end
		if object:IsA("Terrain") then
			change(object, "Decoration", false)
			change(object, "WaterWaveSize", 0)
			change(object, "WaterWaveSpeed", 0)
			change(object, "WaterReflectance", 0)
			change(object, "WaterTransparency", 1)
		end
		if object:IsA("BasePart") then
			change(object, "Material", Enum.Material.Plastic)
			change(object, "MaterialVariant", "")
			change(object, "Reflectance", 0)
			change(object, "CastShadow", false)
			if object:IsA("MeshPart") then
				change(object, "TextureID", "")
				change(object, "RenderFidelity", Enum.RenderFidelity.Performance)
				change(object, "DoubleSided", false)
			elseif object:IsA("PartOperation") then
				change(object, "RenderFidelity", Enum.RenderFidelity.Performance)
			end
		elseif object:IsA("SpecialMesh") then
			change(object, "TextureId", "")
		elseif object:IsA("SurfaceAppearance") then
			detached[object] = true
			change(object, "Parent", nil)
		elseif object:IsA("Decal") or object:IsA("Texture") then
			change(object, "Transparency", 1)
			change(object, "Texture", "")
		elseif object:IsA("ParticleEmitter") then
			change(object, "Enabled", false)
			change(object, "Rate", 0)
			pcall(function() object:Clear() end)
		elseif object:IsA("Trail") then
			change(object, "Enabled", false)
			pcall(function() object:Clear() end)
		elseif object:IsA("Beam") or object:IsA("Fire") or object:IsA("Smoke")
		or object:IsA("Sparkles") or object:IsA("Light") or object:IsA("PostEffect")
		or object:IsA("Clouds") then
			change(object, "Enabled", false)
		elseif object:IsA("Atmosphere") then
			change(object, "Density", 0)
			change(object, "Haze", 0)
			change(object, "Glare", 0)
		elseif object:IsA("Sky") then
			for _, face in ipairs({"SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp", "SunTextureId", "MoonTextureId"}) do
				change(object, face, "")
			end
			change(object, "StarCount", 0)
			change(object, "CelestialBodiesShown", false)
		elseif object:IsA("Shirt") then
			change(object, "ShirtTemplate", "")
		elseif object:IsA("Pants") then
			change(object, "PantsTemplate", "")
		elseif object:IsA("ShirtGraphic") then
			change(object, "Graphic", "")
		elseif object:IsA("Animator") then
			stopAnimations(object)
		end
	end

	local function applyLighting()
		if skyChangerActive() then return end
		change(Lighting, "GlobalShadows", false)
		change(Lighting, "EnvironmentDiffuseScale", 0)
		change(Lighting, "EnvironmentSpecularScale", 0)
		change(Lighting, "FogStart", 0)
		change(Lighting, "FogEnd", 1e10)
	end

	local function stop()
		if not active then return end
		active = false
		generation += 1
		for _, connection in ipairs(connections) do pcall(function() connection:Disconnect() end) end
		connections = {}
		for object, properties in pairs(saved) do
			for property, original in pairs(properties) do
				pcall(function() object[property] = original.value end)
			end
		end
		saved = setmetatable({}, { __mode = "k" })
		detached = {}
		animators = setmetatable({}, { __mode = "k" })
		for track, state in pairs(stoppedTracks) do
			pcall(function()
				if state.animator.Parent and not track.IsPlaying then
					track:Play(0, 1, state.speed)
					track.TimePosition = state.time
				end
			end)
		end
		stoppedTracks = setmetatable({}, { __mode = "k" })
	end

	local function start()
		if active then return end
		active = true
		generation += 1
		local token = generation
		applyLighting()
		pcall(function() change(settings().Rendering, "QualityLevel", Enum.QualityLevel.Level01) end)
		pcall(function()
			change(UserSettings():GetService("UserGameSettings"), "SavedQualityLevel", Enum.SavedQualitySetting.QualityLevel1)
		end)
		for _, root in ipairs({ workspace, Lighting }) do
			table.insert(connections, root.DescendantAdded:Connect(function(object)
				task.defer(function()
					if active and generation == token then pcall(apply, object) end
				end)
			end))
		end
		table.insert(connections, Lighting.Changed:Connect(function(property)
			if active and (property == "GlobalShadows" or property == "EnvironmentDiffuseScale"
			or property == "EnvironmentSpecularScale" or property == "FogStart" or property == "FogEnd") then
				applyLighting()
			end
		end))
		task.spawn(function()
			for _, root in ipairs({ workspace, Lighting }) do
				for index, object in ipairs(root:GetDescendants()) do
					if not active or generation ~= token then return end
					pcall(apply, object)
					if index % 200 == 0 then task.wait() end
				end
			end
		end)
	end

	return { Start = start, Stop = stop }
end)()

local function startAntiLag()
	if antiLagStopFn then pcall(antiLagStopFn);antiLagStopFn=nil end
	ANTI_LAG.Start()
	antiLagStopFn=function() ANTI_LAG.Stop() end
end
local function stopAntiLag()
	if antiLagStopFn then pcall(antiLagStopFn);antiLagStopFn=nil end
	ANTI_LAG.Stop()
end
-- ============================================================================
-- COLOR THEME
-- ============================================================================

-- ============================================================================
-- ============================================================
--  SKY SYSTEM - CANDY HUB
-- ============================================================


-- ============================================================
--  SKY TAG & PRESETS
-- ============================================================
local CANDY_SKY_TAG = "CandyHubSkyTheme"
_G._CandyHubSkyMode = _G._CandyHubSkyMode or "Off"
local candyOriginalLighting = nil

-- Added full custom sky preset set from uploaded skys.txt.
local CANDY_SKY_PRESETS = {
    ["Off"] = {kind = "off"},

    ["Night"] = {
        clock = 22, brightness = 2,
        ambient = {110,100,130}, outAmb = {120,110,140},
        sky = {stars = 4000, moon = 18, sun = 0, moonTex = true},
        atm = {dens = 0.45, color = {120,60,180}, decay = {60,20,100}, glare = 0.5, haze = 1.2},
    },
    ["Aurora"] = {
        clock = 14, brightness = 3,
        ambient = {150,120,150}, outAmb = {160,130,160},
        atm = {dens = 0.55, color = {255,80,200}, decay = {255,20,150}, glare = 2.5, haze = 3},
        clouds = {cover = 0.7, dens = 0.7, color = {255,240,250}},
    },
    ["Sunset"] = {
        clock = 17.2, brightness = 2.5,
        ambient = {170,120,100}, outAmb = {180,130,110},
        sky = {stars = 0, sun = 25, moon = 0},
        atm = {dens = 0.5, color = {255,130,60}, decay = {255,80,30}, glare = 2, haze = 2.5},
        clouds = {cover = 0.55, dens = 0.55, color = {255,200,140}},
    },
    ["Galaxy"] = {
        clock = 0, brightness = 1.5,
        ambient = {70,60,100}, outAmb = {80,70,110},
        sky = {stars = 10000, moon = 30, sun = 0},
        atm = {dens = 0.15, color = {40,20,80}, decay = {20,10,50}, glare = 0.3, haze = 0.5},
    },
    ["Cyber"] = {
        clock = 21, brightness = 2.2,
        ambient = {90,130,170}, outAmb = {100,140,180},
        sky = {stars = 2000, moon = 12},
        atm = {dens = 0.4, color = {0,200,255}, decay = {150,0,255}, glare = 2, haze = 2},
        clouds = {cover = 0.4, dens = 0.6, color = {100,200,255}},
    },
    ["Sakura"] = {
        clock = 11, brightness = 3.5,
        ambient = {170,150,160}, outAmb = {180,160,170},
        sky = {sun = 8},
        atm = {dens = 0.3, color = {255,200,220}, decay = {255,170,200}, glare = 1, haze = 1.5},
        clouds = {cover = 0.6, dens = 0.4, color = {255,250,252}},
    },
    ["Pink Night"] = {
        clock = 23, brightness = 2.2,
        ambient = {120,60,110}, outAmb = {140,70,120},
        sky = {stars = 5000, moon = 22, sun = 0, moonTex = true},
        atm = {dens = 0.5, color = {255,80,180}, decay = {140,30,100}, glare = 0.7, haze = 1.4},
        clouds = {cover = 0.3, dens = 0.5, color = {180,90,150}},
    },

    -- ════════════════════════════════════════════════════════════════
    -- 15 NEW PRESETS
    -- ════════════════════════════════════════════════════════════════

    ["Blood Moon"] = {
        clock = 22.5, brightness = 1.6,
        ambient = {130,40,40}, outAmb = {150,50,50},
        sky = {stars = 1500, moon = 28, sun = 0, moonTex = true},
        atm = {dens = 0.6, color = {220,30,30}, decay = {120,10,10}, glare = 1.4, haze = 2},
        clouds = {cover = 0.5, dens = 0.7, color = {120,30,30}},
    },
    ["Emerald Dawn"] = {
        clock = 6.5, brightness = 2.8,
        ambient = {130,170,140}, outAmb = {140,180,150},
        sky = {sun = 18, moon = 0, stars = 0},
        atm = {dens = 0.4, color = {80,200,140}, decay = {40,150,90}, glare = 1.8, haze = 2.2},
        clouds = {cover = 0.5, dens = 0.5, color = {200,255,220}},
    },
    ["Volcanic"] = {
        clock = 19, brightness = 2,
        ambient = {180,80,40}, outAmb = {200,90,50},
        sky = {stars = 200, sun = 12, moon = 0},
        atm = {dens = 0.75, color = {255,60,0}, decay = {180,20,0}, glare = 3, haze = 3.5},
        clouds = {cover = 0.8, dens = 0.9, color = {120,40,20}},
    },
    ["Arctic"] = {
        clock = 9, brightness = 3.2,
        ambient = {200,220,235}, outAmb = {210,230,245},
        sky = {sun = 10, stars = 0, moon = 0},
        atm = {dens = 0.3, color = {180,220,255}, decay = {140,200,240}, glare = 1.5, haze = 1.8},
        clouds = {cover = 0.7, dens = 0.6, color = {250,253,255}},
    },
    ["Midnight Ocean"] = {
        clock = 1.5, brightness = 1.7,
        ambient = {60,90,130}, outAmb = {70,100,140},
        sky = {stars = 6000, moon = 24, sun = 0, moonTex = true},
        atm = {dens = 0.5, color = {20,60,140}, decay = {10,30,90}, glare = 0.6, haze = 1.5},
    },
    ["Vaporwave"] = {
        clock = 19.5, brightness = 2.4,
        ambient = {180,120,200}, outAmb = {190,130,210},
        sky = {stars = 1000, moon = 14},
        atm = {dens = 0.45, color = {255,100,220}, decay = {120,60,255}, glare = 2.2, haze = 2.4},
        clouds = {cover = 0.5, dens = 0.55, color = {200,150,255}},
    },
    ["Toxic"] = {
        clock = 13, brightness = 2.5,
        ambient = {140,180,80}, outAmb = {150,190,90},
        atm = {dens = 0.55, color = {100,220,40}, decay = {60,150,20}, glare = 1.8, haze = 2.6},
        clouds = {cover = 0.65, dens = 0.7, color = {180,255,120}},
    },
    ["Solar Eclipse"] = {
        clock = 12, brightness = 0.9,
        ambient = {50,40,60}, outAmb = {60,50,70},
        sky = {stars = 3500, sun = 22, moon = 0},
        atm = {dens = 0.5, color = {255,140,40}, decay = {30,20,40}, glare = 2.8, haze = 1.8},
    },
    ["Hellscape"] = {
        clock = 18, brightness = 1.8,
        ambient = {200,60,30}, outAmb = {220,70,40},
        sky = {stars = 100, sun = 30, moon = 0},
        atm = {dens = 0.85, color = {255,30,0}, decay = {120,0,0}, glare = 3.5, haze = 4},
        clouds = {cover = 0.95, dens = 0.95, color = {80,20,10}},
    },
    ["Heaven"] = {
        clock = 12, brightness = 4,
        ambient = {240,235,210}, outAmb = {250,245,220},
        sky = {sun = 16, moon = 0, stars = 0},
        atm = {dens = 0.25, color = {255,250,220}, decay = {255,240,200}, glare = 3, haze = 1.5},
        clouds = {cover = 0.85, dens = 0.5, color = {255,255,255}},
    },
    ["Storm"] = {
        clock = 15, brightness = 1.4,
        ambient = {90,90,110}, outAmb = {100,100,120},
        sky = {stars = 0, sun = 6, moon = 0},
        atm = {dens = 0.65, color = {80,90,120}, decay = {40,50,80}, glare = 0.5, haze = 3},
        clouds = {cover = 0.95, dens = 0.95, color = {60,65,80}},
    },
    ["Sunrise"] = {
        clock = 6.2, brightness = 2.8,
        ambient = {220,180,130}, outAmb = {230,190,140},
        sky = {sun = 22, stars = 0, moon = 0},
        atm = {dens = 0.45, color = {255,180,100}, decay = {255,140,80}, glare = 2.4, haze = 2.2},
        clouds = {cover = 0.4, dens = 0.4, color = {255,220,180}},
    },
    ["Deep Space"] = {
        clock = 0, brightness = 1,
        ambient = {30,25,50}, outAmb = {40,35,60},
        sky = {stars = 15000, moon = 0, sun = 0},
        atm = {dens = 0.08, color = {15,5,40}, decay = {5,0,20}, glare = 0.2, haze = 0.3},
    },
    ["Lavender Dream"] = {
        clock = 18.5, brightness = 2.6,
        ambient = {180,160,220}, outAmb = {190,170,230},
        sky = {stars = 800, moon = 16, sun = 0},
        atm = {dens = 0.4, color = {200,160,255}, decay = {160,120,220}, glare = 1.4, haze = 1.8},
        clouds = {cover = 0.55, dens = 0.5, color = {220,200,255}},
    },
    ["Inferno"] = {
        clock = 17.5, brightness = 2.2,
        ambient = {220,100,40}, outAmb = {235,110,50},
        sky = {sun = 26, moon = 0, stars = 0},
        atm = {dens = 0.6, color = {255,90,20}, decay = {200,40,0}, glare = 3, haze = 3.2},
        clouds = {cover = 0.7, dens = 0.7, color = {200,80,40}},
    },
    ["Mint Sky"] = {
        clock = 10, brightness = 3.2,
        ambient = {180,230,210}, outAmb = {190,240,220},
        sky = {sun = 10},
        atm = {dens = 0.32, color = {150,255,210}, decay = {100,220,180}, glare = 1.6, haze = 1.6},
        clouds = {cover = 0.55, dens = 0.45, color = {240,255,250}},
    },
}

-- ============================================================
--  SKY UTILITY FUNCTIONS
-- ============================================================

local function candySaveOriginalLighting()
	if candyOriginalLighting then return end
	candyOriginalLighting={
		ClockTime=Lighting.ClockTime,
		OutdoorAmbient=Lighting.OutdoorAmbient,
		Ambient=Lighting.Ambient,
		Brightness=Lighting.Brightness,
		FogStart=Lighting.FogStart,
		FogEnd=Lighting.FogEnd,
		FogColor=Lighting.FogColor,
		ColorShift_Top=Lighting.ColorShift_Top,
		ColorShift_Bottom=Lighting.ColorShift_Bottom,
		GeographicLatitude=Lighting.GeographicLatitude,
		GlobalShadows=Lighting.GlobalShadows,
		LightingChildren={},
		TerrainChildren={}
	}
	for _,child in ipairs(Lighting:GetChildren()) do
		if child:IsA("Sky") or child:IsA("Atmosphere") then table.insert(candyOriginalLighting.LightingChildren,child:Clone()) end
	end
	local terrain=workspace:FindFirstChildOfClass("Terrain")
	if terrain then
		for _,child in ipairs(terrain:GetChildren()) do
			if child:IsA("Clouds") then table.insert(candyOriginalLighting.TerrainChildren,child:Clone()) end
		end
	end
end

local function candyClearSky(removeAll)
	for _,child in ipairs(Lighting:GetChildren()) do
		if child:GetAttribute(CANDY_SKY_TAG) or (removeAll and (child:IsA("Sky") or child:IsA("Atmosphere"))) then pcall(function() child:Destroy() end) end
	end
	local terrain=workspace:FindFirstChildOfClass("Terrain")
	if terrain then
		for _,child in ipairs(terrain:GetChildren()) do
			if child:GetAttribute(CANDY_SKY_TAG) or (removeAll and child:IsA("Clouds")) then pcall(function() child:Destroy() end) end
		end
	end
end

local function candyInstance(className,parent,props)
	local inst=Instance.new(className)
	inst:SetAttribute(CANDY_SKY_TAG,true)
	for k,v in pairs(props or {}) do pcall(function() inst[k]=v end) end
	inst.Parent=parent
	return inst
end

local function candyColor(rgb)
	return Color3.fromRGB(rgb[1],rgb[2],rgb[3])
end

local function CandyApplyCustomSky(mode)
	candySaveOriginalLighting()
	candyClearSky(true)
	local terrain=workspace:FindFirstChildOfClass("Terrain")
	local preset=CANDY_SKY_PRESETS[mode]
	if not preset or preset.kind=="off" then
		if candyOriginalLighting then
			for k,v in pairs(candyOriginalLighting) do
				if k~="LightingChildren" and k~="TerrainChildren" then pcall(function() Lighting[k]=v end) end
			end
			for _,child in ipairs(candyOriginalLighting.LightingChildren or {}) do child:Clone().Parent=Lighting end
			local offTerrain=workspace:FindFirstChildOfClass("Terrain")
			if offTerrain then
				for _,child in ipairs(candyOriginalLighting.TerrainChildren or {}) do child:Clone().Parent=offTerrain end
			end
		end
		_G._CandyHubSkyMode="Off"
		return
	end

	Lighting.FogStart=0
	Lighting.FogEnd=100000
	Lighting.FogColor=Color3.fromRGB(200,200,200)
	Lighting.ColorShift_Top=Color3.fromRGB(0,0,0)
	Lighting.ColorShift_Bottom=Color3.fromRGB(0,0,0)
	Lighting.GlobalShadows=true
	Lighting.ClockTime=preset.clock or 14
	Lighting.Brightness=preset.brightness or 2
	if preset.outAmb then Lighting.OutdoorAmbient=candyColor(preset.outAmb) end
	if preset.ambient then Lighting.Ambient=candyColor(preset.ambient) end

	if preset.sky then
		local skyProps={}
		if preset.sky.stars then skyProps.StarCount=preset.sky.stars end
		if preset.sky.moon then skyProps.MoonAngularSize=preset.sky.moon end
		if preset.sky.sun then skyProps.SunAngularSize=preset.sky.sun end
		if preset.sky.moonTex then skyProps.MoonTextureId="rbxasset://sky/moon.jpg" end
		candyInstance("Sky",Lighting,skyProps)
	end

	if preset.atm then
		candyInstance("Atmosphere",Lighting,{
			Density=preset.atm.dens or 0.3,
			Color=candyColor(preset.atm.color),
			Decay=candyColor(preset.atm.decay),
			Glare=preset.atm.glare or 1,
			Haze=preset.atm.haze or 1
		})
	end

	if preset.clouds and terrain then
		candyInstance("Clouds",terrain,{
			Cover=preset.clouds.cover or 0.5,
			Density=preset.clouds.dens or 0.5,
			Color=candyColor(preset.clouds.color)
		})
	end

	_G._CandyHubSkyMode=mode
end

local CandySkyOrder={{"Off","Off"},{"Night","Night"},{"Aurora","Aurora"},{"Sunset","Sunset"},{"Galaxy","Galaxy"},{"Cyber","Cyber"},{"Sakura","Sakura"},{"Pink Night","Pink Night"},{"Blood Moon","Blood Moon"},{"Emerald Dawn","Emerald Dawn"},{"Volcanic","Volcanic"},{"Arctic","Arctic"},{"Midnight Ocean","Midnight Ocean"},{"Vaporwave","Vaporwave"},{"Toxic","Toxic"},{"Solar Eclipse","Solar Eclipse"},{"Hellscape","Hellscape"},{"Heaven","Heaven"},{"Storm","Storm"},{"Sunrise","Sunrise"},{"Deep Space","Deep Space"},{"Lavender Dream","Lavender Dream"},{"Inferno","Inferno"},{"Mint Sky","Mint Sky"}}

local function findMedusa()
	local c=LP.Character;if not c then return nil end
	for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
	local bp=LP:FindFirstChild("Backpack")
	if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
	return nil
end
local function useMedusaCounter()
	if medusaDebounce then return end;if tick()-medusaLastUsed<MEDUSA_COOLDOWN then return end
	local c=LP.Character;if not c then return end;medusaDebounce=true
	local med=findMedusa();if not med then medusaDebounce=false;return end
	if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid");if hum2 then hum2:EquipTool(med) end end
	pcall(function() med:Activate() end);medusaLastUsed=tick();medusaDebounce=false
end
local function onAnchorChanged(part)
	return part:GetPropertyChangedSignal("Anchored"):Connect(function()
		if part.Anchored and part.Transparency==1 then 
			if medusaCounterEnabled then useMedusaCounter() end
		end
	end)
end
local function setupMedusa(char)
	for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={}
	if not char then return end
	for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end
	table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part)
		if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end
	end))
end
local function stopMedusaCounter()
	for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={}
end

-- Instant Medusa Reset System removed (feature disabled)
local BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
local function findBatForCounter()
	local c=LP.Character;if not c then return nil end
	local bp=LP:FindFirstChildOfClass("Backpack")
	for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do
		local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name));if t then return t end
	end
	for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
	if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
	return nil
end
local function swingBatForCounter(bat,char)
	local hum2=char:FindFirstChildOfClass("Humanoid")
	if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end;task.wait(0.05) end
	local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
	if remote and remote:IsA("RemoteEvent") then
		pcall(function() remote:FireServer() end);task.wait(0.15);pcall(function() remote:FireServer() end)
	else pcall(function() bat:Activate() end);task.wait(0.15);pcall(function() bat:Activate() end) end
end
startBatCounter=function()
	if Conns.batCounter then return end
	Conns.batCounter=RunService.Heartbeat:Connect(function()
		if not batCounterEnabled then return end
		if batCounterDebounce then return end
		local char=LP.Character;if not char then return end
		local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
		local st=hum2:GetState()
		if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
			batCounterDebounce=true
			task.spawn(function()
				local bat=findBatForCounter()
				if bat then swingBatForCounter(bat,char) end
				task.wait(0.5);batCounterDebounce=false
			end)
		end
	end)
end
stopBatCounter=function()
	if Conns.batCounter then Conns.batCounter:Disconnect();Conns.batCounter=nil end
	batCounterDebounce=false
end
local function getAutoBatTarget()
	local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if not root then return nil end
	local now=tick()
	if now-_autoBatLastScan<=0.1 and _autoBatTarget and _autoBatTarget.Parent then
		local hum=_autoBatTarget.Parent:FindFirstChildOfClass("Humanoid")
		if hum and hum.Health>0 then return _autoBatTarget end
	end
	_autoBatLastScan=now
	_autoBatTarget=nil
	local closest,minDist=nil,math.huge
	for _,plr in ipairs(Players:GetPlayers()) do
		if plr~=LP and plr.Character then
			local tRoot=plr.Character:FindFirstChild("HumanoidRootPart")
			local hum=plr.Character:FindFirstChildOfClass("Humanoid")
			if tRoot and hum and hum.Health>0 then
				local dist=(tRoot.Position-root.Position).Magnitude
				if dist<minDist then minDist=dist;closest=tRoot end
			end
		end
	end
	_autoBatTarget=closest
	return _autoBatTarget
end
resetAutoBatMotion=function()
	local char=LP.Character
	local hrp=char and char:FindFirstChild("HumanoidRootPart")
	local hum=char and char:FindFirstChildOfClass("Humanoid")
	if hrp then hrp.AssemblyLinearVelocity=hrp.AssemblyLinearVelocity*0.3;hrp.AssemblyAngularVelocity=Vector3.zero end
	if hum then hum.AutoRotate=true end
end
local _autoTPWasEnabled=false
local function enableAutoBat()
	if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
	if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
	if autoTPEnabled then _autoTPWasEnabled=true;stopAutoTP();if setAutoTPVisual then setAutoTPVisual(false) end else _autoTPWasEnabled=false end
	autoBatEquippedThisRun=false
	autoBatEnabled=true
end
local function disableAutoBat()
	autoBatEnabled=false
	autoBatEquippedThisRun=false
	local char=LP.Character
	if char then
		local hum2=char:FindFirstChildOfClass("Humanoid")
		if hum2 then hum2.AutoRotate=true end
	end
	if resetAutoBatMotion then resetAutoBatMotion() end
	if _autoTPWasEnabled then
		_autoTPWasEnabled=false;autoTPEnabled=true
		if setAutoTPVisual then setAutoTPVisual(true) end;startAutoTP()
	end
end
local function queueAutoLeftStart()
	autoLeftEnabled=true
	if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
	if autoBatEnabled then disableAutoBat();if autoBatSetVisual then autoBatSetVisual(false) end end
	startAutoLeft()
end
local function queueAutoRightStart()
	autoRightEnabled=true
	if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
	if autoBatEnabled then disableAutoBat();if autoBatSetVisual then autoBatSetVisual(false) end end
	startAutoRight()
end
local function queueAutoBatStart()
	if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
	if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
	enableAutoBat()
end
RunService.Heartbeat:Connect(function()
	if not autoBatEnabled then return end
	local char=LP.Character
	local hum=char and char:FindFirstChildOfClass("Humanoid")
	local root=char and char:FindFirstChild("HumanoidRootPart")
	if not root or not hum then return end
	if not autoBatEquippedThisRun then
		autoBatEquippedThisRun=true
		if not char:FindFirstChildOfClass("Tool") then
			local bp=LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
			local bpBat=bp and bp:FindFirstChild("Bat")
			if bpBat then pcall(function() hum:EquipTool(bpBat) end) end
		end
	end
	local target=getAutoBatTarget()
	if target then
		local targetVel=target.AssemblyLinearVelocity
		local aimTargetPos=target.Position+(targetVel*math.clamp(targetVel.Magnitude/130,0.05,0.15))+Vector3.new(0,AUTO_BAT_V_OFF,0)
		hum.AutoRotate=false
		local look=aimTargetPos-root.Position
		local flatLook=Vector3.new(look.X,0,look.Z)
		if look.Magnitude>0.01 and flatLook.Magnitude>0.01 then
			local targetYaw=math.deg(math.atan2(-flatLook.X,-flatLook.Z))
			local yawDelta=(targetYaw-root.Orientation.Y+180)%360-180
			local targetPitch=math.deg(math.atan2(look.Y,flatLook.Magnitude))
			local pitchDelta=(targetPitch-root.Orientation.X+180)%360-180
			local yawRate=math.clamp(math.rad(yawDelta)*AUTO_BAT_TURN_SPEED,-AUTO_BAT_MAX_TURN_RATE,AUTO_BAT_MAX_TURN_RATE)
			local pitchRate=math.clamp(math.rad(pitchDelta)*AUTO_BAT_TURN_SPEED,-AUTO_BAT_MAX_TURN_RATE,AUTO_BAT_MAX_TURN_RATE)
			local yawRad=math.rad(root.Orientation.Y)
			local rightAxis=Vector3.new(math.cos(yawRad),0,-math.sin(yawRad))
			root.AssemblyAngularVelocity=Vector3.new(0,yawRate,0)+(rightAxis*pitchRate)
		else
			root.AssemblyAngularVelocity=Vector3.zero
		end
		local dir=look.Magnitude>0.01 and look.Unit or Vector3.zero
		local standPos=aimTargetPos-(dir*AUTO_BAT_DIST)+Vector3.new(0,AUTO_BAT_HEIGHT,0)
		local moveDir=standPos-root.Position
		local hDir=Vector3.new(moveDir.X,0,moveDir.Z)
		local hVel=hDir.Magnitude>0.1 and hDir.Unit*AUTO_BAT_SPEED or Vector3.zero
		local vVel=math.abs(moveDir.Y)>0.1 and Vector3.new(0,math.sign(moveDir.Y)*AUTO_BAT_VERT_SPEED,0) or Vector3.new(0,-2,0)
		root.AssemblyLinearVelocity=hVel+vVel
		if hDir.Magnitude>0.5 then hum:Move(hDir.Unit,false) end
	else
		hum.AutoRotate=true
		root.AssemblyAngularVelocity=Vector3.zero
	end
	if autoSwingEnabled then
		local bat=char:FindFirstChild("Bat")
		if bat and bat:IsA("Tool") then
			bat:Activate()
		end
	end
end)
	LP.CharacterAdded:Connect(function(char)
		task.wait(0.5)
		setupSpeedIndicator(char)
		if medusaCounterEnabled then setupMedusa(char) end
		if batCounterEnabled then startBatCounter() end
		if unwalkEnabled then task.wait(0.5);startUnwalk() end
	end)
if LP.Character then setupSpeedIndicator(LP.Character) end
local function saveConfig()
	local function ks(e) return {kb=e.kb and e.kb.Name or nil,gp=e.gp and e.gp.Name or nil} end
	local cfg={
		normalSpeed=NS,carrySpeed=CS,
		dropBrainrotKey=ks(KB.DropBrainrot),autoLeftKey=ks(KB.AutoLeft),autoRightKey=ks(KB.AutoRight),
		autoBatKey=ks(KB.AutoBat),mwvaneTPBatKey=ks(KB.TPBat),laggerToggleKey=ks(KB.LaggerToggle),tpFloorKey=ks(KB.TPFloor),guiHideKey=ks(KB.GuiHide),
		speedToggleKey=ks(KB.SpeedToggle),
		grabRadius=Steal:getRadius(),stealDuration=Steal:getDuration(),stealMode=Steal.StealMode,
		antiRagdoll=antiRagdollEnabled,autoStealEnabled=Steal.AutoStealEnabled,
		infiniteJump=infJumpEnabled,infJumpMode=infJumpMode,medusaCounter=medusaCounterEnabled,
		batCounter=batCounterEnabled,
		carryMode=speedMode,laggerMode=laggerToggled,laggerCarryMode=laggerPhase==2,laggerSpeed=LAGGER_SPEED,laggerCarrySpeed=LAGGER_CARRY_SPEED,
		autoBat=autoBatEnabled,autoSwing=autoSwingEnabled,
		unwalkEnabled=unwalkEnabled,tryhardAnim=tryhardAnimEnabled,
		antiLag=antiLagEnabled,stretchRez=stretchRezEnabled,
		autoTPEnabled=autoTPEnabled,autoTPHeight=autoTPHeight,
		mwvaneTPBatRange=_G.MWVANE_TP_BAT_RANGE,
		skyTheme=_G._CandyHubSkyMode or "Off",
		selectedBgIndex=_G.selectedBgIndex,
			uiLocked=uiLocked,
			sc_headless=SC_headlessEnabled,
			sc_korblox=SC_korbloxEnabled,
			sc_outfit=SC_currentOutfit,
			sc_animPack=SC_selectedAnimPack,
			sc_animPackActive=SC_animationPackActive
		}
	if writefile then pcall(function() writefile("fadeaway_settings.json",HS:JSONEncode(cfg)) end) end
end

-- Export saveConfig globally for keybind updates
_G._saveConfig = saveConfig

-- Auto-save config every 5 seconds
task.spawn(function() while task.wait(5) do saveConfig() end end)
	-- UI setter callbacks stored in _G to reduce Luau local-register pressure.
local normalBox,carryBox,laggerBox,laggerCarryBox,radInput,autoTPHeightBox
-- Single fixed main background; the old background image list/picker is removed.
local MAIN_BACKGROUND_ASSET = "121659577844718"
_G.selectedBgIndex = 1
_G.BG_IDS = {MAIN_BACKGROUND_ASSET}
local stealBarImg
local function refreshSpeedModeLabel()
	if modeValLbl then modeValLbl.Text=laggerToggled and (laggerPhase==2 and "Lagger Carry" or "Lagger Normal") or (speedMode and "Carry" or "Normal") end
end
-- S2 Speed System API
function _G.S2SpeedSetNormal() speedMode=false;laggerToggled=false;laggerPhase=0;refreshSpeedModeLabel() end
function _G.S2SpeedSetCarry() speedMode=true;laggerToggled=false;laggerPhase=0;refreshSpeedModeLabel() end
function _G.S2SpeedSetLaggerNormal() speedMode=false;laggerToggled=true;laggerPhase=1;refreshSpeedModeLabel() end
function _G.S2SpeedSetLaggerCarry() speedMode=false;laggerToggled=true;laggerPhase=2;refreshSpeedModeLabel() end
local function toggleCarryMode()
	if laggerToggled then
		laggerToggled=false
		laggerPhase=0
		speedMode=true
	else
		speedMode=not speedMode
	end
	refreshSpeedModeLabel()
end
local function toggleLaggerMode()
	if not laggerToggled then
		speedMode=false
		laggerToggled=true
		laggerPhase=2
	elseif laggerPhase==2 then
		laggerPhase=1
	else
		laggerPhase=2
	end
	refreshSpeedModeLabel()
end
local function buildGui()
		local BG    = Color3.fromRGB(0,0,0)
		local BG2   = Color3.fromRGB(2, 18, 7)
		local CARD  = Color3.fromRGB(8, 45, 18)
		local HOV   = Color3.fromRGB(60, 230, 100)
		local RED   = Color3.fromRGB(40, 200, 90)
		local REDDIM= Color3.fromRGB(200,200,200)
		local STROKE= Color3.fromRGB(90, 255, 130)
		local W     = Color3.fromRGB(255,255,255)
		local DIM   = Color3.fromRGB(220,220,220)
		local INP   = Color3.fromRGB(2, 12, 5)
		local OFF   = Color3.fromRGB(3, 22, 8)
		local old=game:GetService("CoreGui"):FindFirstChild("ShadowHub");if old then old:Destroy() end
		local pg=LP:FindFirstChild("PlayerGui");if pg then local o=pg:FindFirstChild("ShadowHub");if o then o:Destroy() end end
		local gui=Instance.new("ScreenGui")
		gui.Name="ShadowHub";gui.ResetOnSpawn=false;gui.DisplayOrder=10;gui.IgnoreGuiInset=true
		pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
		if not pcall(function() gui.Parent=game:GetService("CoreGui") end) then gui.Parent=LP:WaitForChild("PlayerGui") end
		local main=Instance.new("CanvasGroup",gui)
			local targetSize = UDim2.new(0,300,0,360)
				local minimizedSize = UDim2.new(0,300,0,58)
		local minimized = false
		local targetPos = UDim2.new(0,20,0,20)
			main.Size=UDim2.new(0,300,0,340)
			main.Position=UDim2.new(0.5,-150,0.5,-170)
		main.BackgroundColor3=BG;main.BackgroundTransparency=0.2;main.GroupTransparency=1;main.BorderSizePixel=0;main.ClipsDescendants=true
		Instance.new("UICorner",main).CornerRadius=UDim.new(0,12)
		
		task.spawn(function()
			TS:Create(main, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				Size = targetSize,
				Position = targetPos,
				GroupTransparency = 0
			}):Play()
		end)
	-- No outline around the main menu container.
	local bgImg=Instance.new("ImageLabel",main)
	bgImg.Size=UDim2.new(1,0,1,0);bgImg.Position=UDim2.new(0,0,0,0)
	bgImg.BackgroundTransparency=1;bgImg.BorderSizePixel=0;bgImg.Image="rbxassetid://" .. MAIN_BACKGROUND_ASSET
	bgImg.ZIndex=1;bgImg.ImageTransparency=0
	Instance.new("UICorner",bgImg).CornerRadius=UDim.new(0,12)
	local function drag(f)
		local dn,ds,sp,di=false,false,false,false
		f.InputBegan:Connect(function(i)
			if uiLocked then return end
			if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
				dn=true;ds=i.Position;sp=f.Position
				i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dn=false end end)
			end
		end)
		f.InputChanged:Connect(function(i)
			if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di=i end
		end)
		UIS.InputChanged:Connect(function(i)
			if uiLocked then return end
			if i==di and dn then
				local nX=sp.X.Offset+(i.Position.X-ds.X)
				local nY=sp.Y.Offset+(i.Position.Y-ds.Y)
				f.Position=UDim2.new(sp.X.Scale,nX,sp.Y.Scale,nY)
			end
		end)
	end
	drag(main)
	local hdr=Instance.new("Frame",main)
		hdr.Size=UDim2.new(1,0,0,64);hdr.Position=UDim2.new(0,0,0,0);hdr.BackgroundColor3=BG2;hdr.BackgroundTransparency=1;hdr.BorderSizePixel=0;hdr.ZIndex=2
Instance.new("UICorner",hdr).CornerRadius=UDim.new(0,12)
		local hdrMask=Instance.new("Frame",hdr)
		hdrMask.Size=UDim2.new(1,0,0,10);hdrMask.Position=UDim2.new(0,0,1,-10)
		hdrMask.BackgroundColor3=BG2;hdrMask.BackgroundTransparency=1;hdrMask.BorderSizePixel=0;hdrMask.ZIndex=1
		local ttl=Instance.new("ImageLabel",hdr)
		ttl.Name="MainLogo"
		ttl.Size=UDim2.new(0,260,0,58);ttl.Position=UDim2.new(0.5,-130,0.5,-29)
		ttl.BackgroundTransparency=1;ttl.BorderSizePixel=0
		ttl.Image="rbxassetid://114193031021374";ttl.ScaleType=Enum.ScaleType.Fit;ttl.ZIndex=3
		local minBtn=Instance.new("TextButton",hdr)
		minBtn.Size=UDim2.new(0,28,0,28);minBtn.Position=UDim2.new(1,-34,0.5,-14)
		minBtn.BackgroundColor3=BG2;minBtn.BorderSizePixel=0;minBtn.ZIndex=3
		minBtn.Text="−";minBtn.TextColor3=REDDIM;minBtn.Font=Enum.Font.GothamBold;minBtn.TextSize=22
		Instance.new("UICorner",minBtn).CornerRadius=UDim.new(0,8)
		minBtn.MouseEnter:Connect(function() TS:Create(minBtn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(12,65,25),TextColor3=RED}):Play() end)
		minBtn.MouseLeave:Connect(function() TS:Create(minBtn,TweenInfo.new(0.1),{BackgroundColor3=BG2,TextColor3=REDDIM}):Play() end)
		local profileCard, sf, tabBar
		local function setMenuMinimized(shouldMinimize)
		if minimized == shouldMinimize then return end
		minimized = shouldMinimize
		local easing = shouldMinimize and Enum.EasingDirection.In or Enum.EasingDirection.Out
		local sizeGoal = shouldMinimize and minimizedSize or targetSize
		minBtn.Text = shouldMinimize and "+" or "−"
		-- Keep only the header visible while minimized; restore the rest when opened.
			if shouldMinimize then
				profileCard.Visible = false
				sf.Visible = false
				tabBar.Visible = false
				-- Keep the fixed main background visible while the controls are minimized.
				bgImg.Visible = true
			else
			profileCard.Visible = true
			sf.Visible = true
			tabBar.Visible = true
			bgImg.Visible = true
		end
		TS:Create(main, TweenInfo.new(0.42, Enum.EasingStyle.Quint, easing), {Size = sizeGoal, GroupTransparency = 0}):Play()
	end
	minBtn.Activated:Connect(function() setMenuMinimized(not minimized) end)

	-- Player Profile Section
		profileCard=Instance.new("Frame",main)
		profileCard.Size=UDim2.new(1,0,0,0);profileCard.Position=UDim2.new(0,0,0,64)
	profileCard.BackgroundTransparency=1;profileCard.BorderSizePixel=0;profileCard.ZIndex=2
	
	local setMwVaneTPBatVisual = nil
	local currentTab="Speed"
	local tabSections={Speed={},Combat={},Bat={},Visual={},Config={}}
	local tabButtons={}
	
	tabBar=Instance.new("Frame",main)
		tabBar.Size=UDim2.new(1,0,0,50);tabBar.Position=UDim2.new(0,0,1,-50)
		tabBar.BackgroundColor3=BG2;tabBar.BackgroundTransparency=0.7;tabBar.BorderSizePixel=0;tabBar.ZIndex=2
		Instance.new("UICorner",tabBar).CornerRadius=UDim.new(0,10)
		local tabLayout=Instance.new("UIListLayout",tabBar);tabLayout.FillDirection=Enum.FillDirection.Horizontal;tabLayout.SortOrder=Enum.SortOrder.LayoutOrder;tabLayout.Padding=UDim.new(0,4);tabLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center;tabLayout.VerticalAlignment=Enum.VerticalAlignment.Center
	
	local function switchTab(tabName)
		currentTab=tabName
			for tabName2,sections in pairs(tabSections) do
				for _,sect in ipairs(sections) do 
						if sect.Name == "StealModeTabs" or sect.Name == "JumpModeTabs" then
							sect.Visible = false
							if _G._stealChevronIcon then _G._stealChevronIcon.Text = "▼" end
							if _G._jumpChevronIcon then _G._jumpChevronIcon.Text = "▼" end
						else
						sect.Visible=(tabName2==currentTab) 
					end
				end
			end
		for tName,btn in pairs(tabButtons) do
			local isActive=(tName==tabName)
			TS:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=isActive and REDDIM or BG}):Play()
			btn.TextColor3=isActive and Color3.fromRGB(255,255,255) or Color3.fromRGB(150,210,160)
			local tabStroke=btn:FindFirstChildOfClass("UIStroke")
			if tabStroke then tabStroke.Transparency=isActive and 0 or 1 end
		end
	end
	
for i,tabName in ipairs({"Speed","Combat","Bat","Visual","Config"}) do
			local tabBtn=Instance.new("TextButton",tabBar)
			tabBtn.Size=UDim2.new(0.19,0,0,35);tabBtn.LayoutOrder=i
		tabBtn.BackgroundColor3=(tabName=="Speed") and REDDIM or BG;tabBtn.BorderSizePixel=0;tabBtn.ClipsDescendants=false
		tabBtn.Text=tabName;tabBtn.TextColor3=(tabName=="Speed") and Color3.fromRGB(255,255,255) or Color3.fromRGB(150,210,160)
		tabBtn.Font=Enum.Font.GothamBold;tabBtn.TextSize=12;tabBtn.ZIndex=5
		Instance.new("UICorner",tabBtn).CornerRadius=UDim.new(0,8)
		local stroke=Instance.new("UIStroke",tabBtn);stroke.Color=STROKE;stroke.Thickness=1.5;stroke.Transparency=(tabName=="Speed") and 0 or 1
		tabButtons[tabName]=tabBtn
		tabBtn.MouseEnter:Connect(function() TS:Create(tabBtn,TweenInfo.new(0.15),{BackgroundColor3=(tabName==currentTab) and REDDIM or HOV}):Play() end)
		tabBtn.MouseLeave:Connect(function() TS:Create(tabBtn,TweenInfo.new(0.15),{BackgroundColor3=(tabName==currentTab) and REDDIM or BG}):Play() end)
		tabBtn.MouseButton1Click:Connect(function() switchTab(tabName) end)
	end
	
		sf=Instance.new("ScrollingFrame",main)
				sf.Size=UDim2.new(1,0,1,-114);sf.Position=UDim2.new(0,0,0,64)
	sf.BackgroundTransparency=1;sf.BorderSizePixel=0;sf.ClipsDescendants=true;sf.ZIndex=2
	sf.ScrollBarThickness=0;sf.ScrollBarImageTransparency=1
	sf.CanvasSize=UDim2.new(0,0,0,0);sf.AutomaticCanvasSize=Enum.AutomaticSize.Y
	local ll=Instance.new("UIListLayout",sf);ll.SortOrder=Enum.SortOrder.LayoutOrder;ll.Padding=UDim.new(0,2)
	local pad=Instance.new("UIPadding",sf)
	pad.PaddingLeft=UDim.new(0,7);pad.PaddingRight=UDim.new(0,7)
	pad.PaddingTop=UDim.new(0,7);pad.PaddingBottom=UDim.new(0,10)
	local lo=0
	local currentMkSection="Speed"
	local function LO() lo=lo+1;return lo end
	local function mkSect(txt,tab)
		tab=tab or "Speed"
		currentMkSection=tab
		local f=Instance.new("Frame",sf);f.Size=UDim2.new(1,0,0,20);f.BackgroundTransparency=1;f.BorderSizePixel=0;f.LayoutOrder=LO()
		f.Visible=(tab==currentTab)
		table.insert(tabSections[tab],f)
		local l=Instance.new("TextLabel",f);l.Size=UDim2.new(1,-8,1,0);l.Position=UDim2.new(0,8,0,0)
		l.BackgroundTransparency=1;l.Text=txt:upper();l.TextColor3=RED
		l.Font=Enum.Font.GothamBlack;l.TextSize=9;l.TextXAlignment=Enum.TextXAlignment.Left
		l.TextStrokeTransparency=0.85;l.TextStrokeColor3=Color3.fromRGB(0,0,0)
	end
	local function mkRow(h)
		local f=Instance.new("Frame",sf);f.Size=UDim2.new(1,0,0,h or 32)
		f.BackgroundColor3=CARD;f.BackgroundTransparency=0.25;f.BorderSizePixel=0;f.LayoutOrder=LO()
		f.Visible=(currentMkSection==currentTab)
		table.insert(tabSections[currentMkSection],f)
		Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)
		Instance.new("UIStroke",f).Color=Color3.fromRGB(8,35,15)
		f.MouseEnter:Connect(function() TS:Create(f,TweenInfo.new(0.08),{BackgroundColor3=HOV}):Play() end)
		f.MouseLeave:Connect(function() TS:Create(f,TweenInfo.new(0.08),{BackgroundColor3=CARD}):Play() end)
		return f
	end
	local function mkLabel(row,txt)
		local l=Instance.new("TextLabel",row);l.Size=UDim2.new(0.58,0,1,0);l.Position=UDim2.new(0,9,0,0)
		l.BackgroundTransparency=1;l.Text=txt;l.TextColor3=W
		l.Font=Enum.Font.GothamBold;l.TextSize=11;l.TextXAlignment=Enum.TextXAlignment.Left
	end
	local function mkPill(row,offset)
		local pill=Instance.new("Frame",row);pill.Size=UDim2.new(0,36,0,19)
		pill.Position=UDim2.new(1,-(offset or 42),0.5,-9.5)
		pill.BackgroundColor3=OFF;pill.BorderSizePixel=0;pill.ZIndex=3
		Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)
		local dot=Instance.new("Frame",pill);dot.Size=UDim2.new(0,13,0,13);dot.Position=UDim2.new(0,3,0.5,-6.5)
		dot.BackgroundColor3=DIM;dot.BorderSizePixel=0;dot.ZIndex=4
		Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
		return pill,dot
	end
	local function animPill(pill,dot,on)
		TS:Create(pill,TweenInfo.new(0.18,Enum.EasingStyle.Quad),{BackgroundColor3=on and Color3.fromRGB(25,150,70) or OFF}):Play()
		TS:Create(dot,TweenInfo.new(0.18,Enum.EasingStyle.Back),{
			Position=on and UDim2.new(1,-16,0.5,-6.5) or UDim2.new(0,3,0.5,-6.5),
			BackgroundColor3=on and RED or DIM
		}):Play()
	end
	local function mkToggle(txt,cb)
		local row=mkRow(32);mkLabel(row,txt)
		local pill,dot=mkPill(row,42)
		local on=false
		local function sv(s) on=s;animPill(pill,dot,s) end
		local clk=Instance.new("TextButton",pill);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=5
		clk.Activated:Connect(function() on=not on;sv(on);cb(on) end)
		pill.ZIndex=3;dot.ZIndex=4
		return sv
	end
	local function mkBox(parent,default,w,xOff,cb)
		local tb=Instance.new("TextBox",parent)
		tb.Size=UDim2.new(0,w or 50,0,22);tb.Position=UDim2.new(1,-(xOff or 56),0.5,-11)
		tb.BackgroundColor3=Color3.fromRGB(8,70,25);tb.BorderSizePixel=0;tb.Text=tostring(default);tb.TextColor3=W
		tb.Font=Enum.Font.GothamBold;tb.TextSize=11;tb.ClearTextOnFocus=false;tb.ZIndex=5
		Instance.new("UICorner",tb).CornerRadius=UDim.new(0,10)
		local bs=Instance.new("UIStroke",tb);bs.Color=Color3.fromRGB(255,255,255);bs.Thickness=1
		tb.Focused:Connect(function() TS:Create(bs,TweenInfo.new(0.12),{Color=REDDIM}):Play() end)
		tb.FocusLost:Connect(function()
			TS:Create(bs,TweenInfo.new(0.12),{Color=Color3.fromRGB(8,45,18)}):Play()
			if cb then local n=tonumber(tb.Text);if n then cb(n) else tb.Text=tostring(default) end end
		end)
		return tb
	end
	local GAMEPAD_KEYS={
		[Enum.KeyCode.ButtonA]=true,[Enum.KeyCode.ButtonB]=true,[Enum.KeyCode.ButtonX]=true,[Enum.KeyCode.ButtonY]=true,
		[Enum.KeyCode.ButtonL1]=true,[Enum.KeyCode.ButtonR1]=true,[Enum.KeyCode.ButtonL2]=true,[Enum.KeyCode.ButtonR2]=true,
		[Enum.KeyCode.ButtonL3]=true,[Enum.KeyCode.ButtonR3]=true,[Enum.KeyCode.ButtonStart]=true,[Enum.KeyCode.ButtonSelect]=true,
		[Enum.KeyCode.DPadUp]=true,[Enum.KeyCode.DPadDown]=true,[Enum.KeyCode.DPadLeft]=true,[Enum.KeyCode.DPadRight]=true
	}
	local function isGamepadInput(inp) return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad")~=nil end
	local function isBindableInput(inp)
		if not inp or inp.KeyCode==Enum.KeyCode.Unknown then return false end
		if inp.UserInputType==Enum.UserInputType.Keyboard then return true end
		return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode]==true
	end
	local function kbMatch(entry,kc) return kc and (kc==entry.kb or (entry.gp and kc==entry.gp)) end
			local function mkKB(parent,kbEntry,cb)
			local container=Instance.new("Frame",parent)
			container.Size=UDim2.new(0,68,0,22);container.Position=UDim2.new(1,-72,0.5,-11)
			container.BackgroundTransparency=1
			local btn=Instance.new("TextButton",container)
			btn.Size=UDim2.new(0,46,0,22);btn.Position=UDim2.new(0,0,0,0)
			btn.BackgroundColor3=INP;btn.BorderSizePixel=0
			local function getLabel() return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None" end
			btn.Text=getLabel();btn.TextColor3=W
			btn.Font=Enum.Font.GothamBold;btn.TextSize=9;btn.ZIndex=5
			Instance.new("UICorner",btn).CornerRadius=UDim.new(0,10)
			
			local rst=Instance.new("TextButton",container)
			rst.Size=UDim2.new(0,18,0,22);rst.Position=UDim2.new(0,50,0,0)
			rst.BackgroundColor3=Color3.fromRGB(12,90,35);rst.BorderSizePixel=0
			rst.Text="X";rst.TextColor3=Color3.fromRGB(130,255,160)
			rst.Font=Enum.Font.GothamBold;rst.TextSize=10;rst.ZIndex=5
			Instance.new("UICorner",rst).CornerRadius=UDim.new(0,10)
			
			local li=false;local lc;local pv=btn.Text;local listenStart=0
			btn.Activated:Connect(function()
				if li then li=false;_anyKeyListening=false;if lc then lc:Disconnect();lc=nil end;btn.Text=pv;btn.TextColor3=W;return end
				pv=btn.Text;li=true;_anyKeyListening=true;listenStart=tick();btn.Text="...";btn.TextColor3=W
				lc=UIS.InputBegan:Connect(function(inp)
					if not li then return end
					if inp.KeyCode==Enum.KeyCode.Escape then li=false;_anyKeyListening=false;if lc then lc:Disconnect();lc=nil end;btn.Text=pv;btn.TextColor3=W;return end
					local isGp=isGamepadInput(inp)
					if isGp and tick()-listenStart<0.15 then return end
					if not isBindableInput(inp) then return end
					btn.Text=inp.KeyCode.Name;pv=inp.KeyCode.Name;btn.TextColor3=W
					li=false;_anyKeyListening=false;if lc then lc:Disconnect();lc=nil end
					if cb then cb(inp.KeyCode,isGp) end
				end)
			end)
			rst.Activated:Connect(function()
				kbEntry.kb=nil;kbEntry.gp=nil
				btn.Text="None";pv="None"
				if cb then cb(nil,false) end
			end)
			return btn
		end

	local function mkToggleKB(txt,kbEntry,onToggle,onKB)
		local row=mkRow(32);mkLabel(row,txt)
		if kbEntry then mkKB(row,kbEntry,function(k,isGp)
			if isGp then kbEntry.gp=k;kbEntry.kb=nil else kbEntry.kb=k;kbEntry.gp=nil end
			if onKB then onKB(k,isGp) end
		end) end
		local pill,dot=mkPill(row,kbEntry and 102 or 42)
		local on=false
		local function sv(s) on=s;animPill(pill,dot,s) end
		local clk=Instance.new("TextButton",pill);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=5
		clk.Activated:Connect(function() if _anyKeyListening then return end;on=not on;sv(on);if onToggle then onToggle(on) end end)
		pill.ZIndex=3;dot.ZIndex=4
		return sv
	end
	
--[[
    Auto Steal Bar - fadeaway Version
]]
local stealParent = LP:WaitForChild("PlayerGui")

local stealGui = Instance.new("ScreenGui", stealParent)
stealGui.Name = "StealBar"
stealGui.ResetOnSpawn = false
stealGui.DisplayOrder = 500
stealGui.IgnoreGuiInset = true

local BAR_W, BAR_H = 300, 60

local barFrame = Instance.new("Frame", stealGui)
barFrame.Name = "StealBar"
barFrame.Size = UDim2.new(0, BAR_W, 0, BAR_H)
barFrame.Position = UDim2.new(0.5, -BAR_W/2, 1, -68)
	barFrame.BackgroundColor3 = Color3.fromRGB(25, 125, 55)
barFrame.BorderSizePixel = 0
barFrame.Active = true
barFrame.ZIndex = 90
Instance.new("UICorner", barFrame).CornerRadius = UDim.new(0, 12)
local barStroke = Instance.new("UIStroke", barFrame)
	barStroke.Color = Color3.fromRGB(105, 235, 125)
barStroke.Thickness = 1.2
drag(barFrame)

local barGradient = Instance.new("UIGradient", barFrame)
	barGradient.Color = ColorSequence.new(Color3.fromRGB(45, 165, 75), Color3.fromRGB(12, 75, 28))
barGradient.Rotation = 135

stealBarImg = Instance.new("ImageLabel", barFrame)
stealBarImg.Size = UDim2.new(1, 0, 1, 0)
stealBarImg.BackgroundTransparency = 1
stealBarImg.ZIndex = 91
Instance.new("UICorner", stealBarImg).CornerRadius = UDim.new(0, 12)

local statusDot = Instance.new("Frame", barFrame)
statusDot.Size = UDim2.fromOffset(6, 6)
statusDot.Position = UDim2.fromOffset(11, 7)
statusDot.BackgroundColor3 = Color3.fromRGB(100, 255, 130)
statusDot.BorderSizePixel = 0
statusDot.ZIndex = 92
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

local percentLbl = Instance.new("TextLabel", barFrame)
percentLbl.Size = UDim2.new(0, 100, 0, 18)
percentLbl.Position = UDim2.fromOffset(22, 2)
percentLbl.BackgroundTransparency = 1
percentLbl.Text = "● 0%"
percentLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
percentLbl.Font = Enum.Font.GothamBold
percentLbl.TextSize = 15
percentLbl.TextXAlignment = Enum.TextXAlignment.Left
percentLbl.ZIndex = 92

local radiusLbl = Instance.new("TextLabel", barFrame)
radiusLbl.Size = UDim2.new(0, 120, 0, 18)
radiusLbl.Position = UDim2.new(1, -130, 0, 2)
radiusLbl.BackgroundTransparency = 1
radiusLbl.Text = "Radius: " .. tostring(Steal:getRadius())
radiusLbl.TextColor3 = Color3.fromRGB(245, 245, 245)
radiusLbl.Font = Enum.Font.GothamBold
radiusLbl.TextSize = 12
radiusLbl.TextXAlignment = Enum.TextXAlignment.Right
radiusLbl.ZIndex = 92

local infoLbl = Instance.new("TextLabel", barFrame)
infoLbl.Size = UDim2.new(0.5, -10, 0, 13)
infoLbl.Position = UDim2.fromOffset(10, 22)
infoLbl.BackgroundTransparency = 1
infoLbl.Text = "FPS: 0  |  PING: 0ms"
infoLbl.TextColor3 = Color3.fromRGB(170, 210, 175)
infoLbl.Font = Enum.Font.GothamBold
infoLbl.TextSize = 10
infoLbl.TextXAlignment = Enum.TextXAlignment.Left
infoLbl.ZIndex = 92

local discordLbl = Instance.new("TextLabel", barFrame)
discordLbl.Size = UDim2.new(0.5, -10, 0, 13)
discordLbl.Position = UDim2.new(0.5, 0, 0, 22)
discordLbl.BackgroundTransparency = 1
discordLbl.Text = "discord.gg/mwvanehub"
discordLbl.TextColor3 = Color3.fromRGB(190, 235, 195)
discordLbl.Font = Enum.Font.GothamBold
discordLbl.TextSize = 10
discordLbl.TextXAlignment = Enum.TextXAlignment.Right
discordLbl.ZIndex = 92

local barTrack = Instance.new("Frame", barFrame)
barTrack.Size = UDim2.new(1, -20, 0, 10)
barTrack.Position = UDim2.new(0, 10, 1, -17)
	barTrack.BackgroundColor3 = Color3.fromRGB(2, 35, 10)
barTrack.BorderSizePixel = 0
barTrack.ZIndex = 92
Instance.new("UICorner", barTrack).CornerRadius = UDim.new(0, 4)

local barFill = Instance.new("Frame", barTrack)
barFill.Size = UDim2.fromScale(0, 1)
	barFill.BackgroundColor3 = Color3.fromRGB(5, 65, 20)
barFill.BorderSizePixel = 0
barFill.ZIndex = 93
Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 4)

-- Progress bar UI references for the steal system
progressFill = barFill
progressPct = percentLbl
progressRadLbl = radiusLbl

local stealFPS = 0
local stealPing = 0
local fpsFrames = 0
local fpsWindowStart = tick()

RunService.RenderStepped:Connect(function()
	fpsFrames = fpsFrames + 1
	radiusLbl.Text = "Radius: " .. tostring(Steal:getRadius())
	infoLbl.Text = string.format("FPS: %d  ·  PING: %dms  ·  mwvane hub", stealFPS, stealPing)

	local p = 0
	if StealState.active then
		local elapsed = tick() - StealState.startTime
		local maxDuration = (StealState.phase == "normal") and Steal:getDuration() or Steal.STEAL_HOLD_MAX
		p = math.clamp(elapsed / maxDuration, 0, 1)
	elseif StealState.lastResultTime > 0 and (tick() - StealState.lastResultTime) < 1.5 then
		p = 1
	else
		p = 0
	end
	barFill.Size = UDim2.new(p, 0, 1, 0)

	if StealState.active then
		local labelText = string.upper(StealState.label) .. "  ·  " .. string.format("%.2fs", tick() - StealState.startTime)
		percentLbl.Text = "● " .. labelText
	elseif StealState.lastResultTime > 0 and (tick() - StealState.lastResultTime) < 1.5 then
		percentLbl.Text = "● " .. StealState.lastResult
	else
		percentLbl.Text = "● " .. (Steal.AutoStealEnabled and "READY" or "IDLE")
	end
end)

task.spawn(function()
	while task.wait(1) do
		local now = tick()
		local elapsed = now - fpsWindowStart
		stealFPS = elapsed > 0 and math.floor(fpsFrames / elapsed) or 0
		fpsFrames = 0
		fpsWindowStart = now

		local ping = 0
		pcall(function()
			local stat = game:GetService("Stats").Network.ServerStatsItem:FindFirstChild("Data Ping")
			if stat then ping = math.floor(stat:GetValue()) end
		end)
		stealPing = ping or 0
	end
end)








	mkSect("Speed","Speed")
	do local row=mkRow(32);mkLabel(row,"Normal Speed");normalBox=mkBox(row,NS,50,48,function(v) if v>0 and v<=500 then NS=v end;saveConfig() end) end
	do local row=mkRow(32);mkLabel(row,"Carry Speed");carryBox=mkBox(row,CS,50,48,function(v) if v>0 and v<=500 then CS=v end;saveConfig() end) end
	do local row=mkRow(32);mkLabel(row,"Lagger Normal Speed");laggerBox=mkBox(row,LAGGER_SPEED,50,48,function(v) if v>0 and v<=500 then LAGGER_SPEED=v end;saveConfig() end) end
	do local row=mkRow(32);mkLabel(row,"Lagger Carry Speed");laggerCarryBox=mkBox(row,LAGGER_CARRY_SPEED,50,48,function(v) if v>0 and v<=500 then LAGGER_CARRY_SPEED=v end;saveConfig() end) end
	do
		local row=mkRow(32);mkLabel(row,"Mode")
		modeValLbl=Instance.new("TextLabel",row)
		modeValLbl.Size=UDim2.new(0,90,1,0);modeValLbl.Position=UDim2.new(1,-94,0,0)
		modeValLbl.BackgroundTransparency=1;modeValLbl.Text="Normal";modeValLbl.TextColor3=RED
		modeValLbl.Font=Enum.Font.GothamBlack;modeValLbl.TextSize=11;modeValLbl.TextXAlignment=Enum.TextXAlignment.Right
		local clk=Instance.new("TextButton",row);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=2
		clk.Activated:Connect(function()
			if _anyKeyListening then return end
			toggleCarryMode()
			saveConfig()
		end)
	end
	mkSect("Keybinds","Speed")
	do local row=mkRow(32);mkLabel(row,"Speed Key");mkKB(row,KB.SpeedToggle,function(k,isGp) if isGp then KB.SpeedToggle.gp=k;KB.SpeedToggle.kb=nil else KB.SpeedToggle.kb=k;KB.SpeedToggle.gp=nil end;saveConfig() end) end
	do local row=mkRow(32);mkLabel(row,"Lagger Key");mkKB(row,KB.LaggerToggle,function(k,isGp) if isGp then KB.LaggerToggle.gp=k;KB.LaggerToggle.kb=nil else KB.LaggerToggle.kb=k;KB.LaggerToggle.gp=nil end;saveConfig() end) end
mkSect("Combat","Combat")
	_G.setAutoSwingVisual=mkToggle("Auto Swing",function(on)
		autoSwingEnabled=on
		saveConfig()
	end)
	if _G.setAutoSwingVisual then _G.setAutoSwingVisual(autoSwingEnabled) end

	-- BAT TAB
	mkSect("Auto Bat","Bat")
	do
		local abRow=mkRow(32);mkLabel(abRow,"Auto Bat")
		mkKB(abRow,KB.AutoBat,function(k,isGp)
			if isGp then KB.AutoBat.gp=k;KB.AutoBat.kb=nil else KB.AutoBat.kb=k;KB.AutoBat.gp=nil end
			saveConfig()
		end)
		local abPill,abDot=mkPill(abRow,102)
		abPill.ZIndex=3;abDot.ZIndex=4
		local abOn=false
		local function svAutoBat(s) abOn=s;animPill(abPill,abDot,s) end
		autoBatSetVisual=svAutoBat
		local abClk=Instance.new("TextButton",abPill);abClk.Size=UDim2.new(1,0,1,0);abClk.BackgroundTransparency=1;abClk.Text="";abClk.ZIndex=5
		abClk.Activated:Connect(function()
			if _anyKeyListening then return end
			abOn=not abOn;svAutoBat(abOn)
			if abOn then queueAutoBatStart() else autoBatEnabled=false;disableAutoBat() end
			saveConfig()
		end)
	end

	mkSect("MwVane TP Bat","Bat")
	do
		local tpRow=mkRow(32);mkLabel(tpRow,"MwVane TP Bat")
		mkKB(tpRow,KB.TPBat,function(k,isGp)
			if isGp then KB.TPBat.gp=k;KB.TPBat.kb=nil else KB.TPBat.kb=k;KB.TPBat.gp=nil end
			saveConfig()
		end)
		local tpPill,tpDot=mkPill(tpRow,102)
		tpPill.ZIndex=3;tpDot.ZIndex=4
		local tpOn=false
		local function svTPBat(s) tpOn=s;animPill(tpPill,tpDot,s) end
		setMwVaneTPBatVisual=svTPBat
		local tpClk=Instance.new("TextButton",tpPill);tpClk.Size=UDim2.new(1,0,1,0);tpClk.BackgroundTransparency=1;tpClk.Text="";tpClk.ZIndex=5
		tpClk.Activated:Connect(function()
			if _anyKeyListening then return end
			tpOn=not tpOn;svTPBat(tpOn)
			_G.mwvaneTPBatToggled = tpOn
			if _G.mwvaneTPBatToggled then _G.startMwVaneTPBat() else _G.stopMwVaneTPBat() end
			saveConfig()
		end)
	end

	do local row=mkRow(32);mkLabel(row,"Range");mkBox(row,_G.MWVANE_TP_BAT_RANGE,50,56,function(v) if v>=10 and v<=1000 then _G.MWVANE_TP_BAT_RANGE=v;saveConfig() end end) end

	mkSect("Bat Counter","Bat")
	do
		setBatCounterVisual=mkToggle("Bat Counter",function(on)
			batCounterEnabled=on
			if on then startBatCounter() else stopBatCounter() end
			saveConfig()
		end)
	end

	mkSect("Steal","Combat")
	do
		local row=mkRow(32);mkLabel(row,"Radius")
		radInput=mkBox(row,Steal:getRadius(),50,56,function(v)
			if v>=0.5 and v<=300 then 
				Steal.Modes[Steal.StealMode].StealRadius=v
				if progressRadLbl then progressRadLbl.Text=string.format("Radius: %.2g",Steal:getRadius()) end 
			end
			saveConfig()
		end)
	end
	do
		local row = mkRow(32)
		mkLabel(row, "Steal Duration")
		local stealDurationBox = mkBox(row, Steal:getDuration(), 60, 66, function(v)
			if v >= 0.1 and v <= 10 then Steal.Modes[Steal.StealMode].StealDuration = v end
			saveConfig()
		end)
		-- Force visibility
		stealDurationBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		stealDurationBox.TextColor3 = Color3.fromRGB(0, 0, 0)
		stealDurationBox.TextStrokeTransparency = 1
		
		-- Store reference for updating when steal mode changes
		_G._stealDurationBox = stealDurationBox
	end
		do
			local stealRow = mkRow(32)
			mkLabel(stealRow, "Auto Steal")
			
			-- Toggle Pill
			local pill, dot = mkPill(stealRow, 42)
			local on = false
			local function sv(s) on = s; animPill(pill, dot, s) end
			_G.setInstaGrab = sv
			local clk = Instance.new("TextButton", pill)
			clk.Size = UDim2.new(1, 0, 1, 0)
			clk.BackgroundTransparency = 1
			clk.Text = ""
			clk.ZIndex = 5
			clk.Activated:Connect(function()
				on = not on; sv(on); Steal.AutoStealEnabled = on
				if on then if not pcall(startAutoSteal) then Steal.AutoStealEnabled = false; sv(false) end else stopAutoSteal() end
				saveConfig()
			end)
			pill.ZIndex = 3; dot.ZIndex = 4

			-- Chevron Button next to Pill
			local chevronBtn = Instance.new("Frame", stealRow)
			chevronBtn.Size = UDim2.new(0, 30, 0, 24)
			chevronBtn.Position = UDim2.new(1, -85, 0.5, -12)
			chevronBtn.BackgroundColor3 = Color3.fromRGB(18, 30, 20)
			chevronBtn.BackgroundTransparency = 0.5
			Instance.new("UICorner", chevronBtn).CornerRadius = UDim.new(0, 6)
			
					local chevronIcon = Instance.new("TextLabel", chevronBtn)
					chevronIcon.Size = UDim2.new(1, 0, 1, 0)
					chevronIcon.BackgroundTransparency = 1
					chevronIcon.Text = "▼"
					chevronIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
					chevronIcon.Font = Enum.Font.GothamBold
					chevronIcon.TextSize = 8
					_G._stealChevronIcon = chevronIcon
					
					local chevronClick = Instance.new("TextButton", chevronBtn)
					chevronClick.Size = UDim2.new(1, 0, 1, 0)
					chevronClick.BackgroundTransparency = 1
					chevronClick.Text = ""
					chevronClick.ZIndex = 6
	
				-- Tab Container (appears below Auto Steal row)
				local tabContainer = mkRow(36)
				tabContainer.Name = "StealModeTabs"
				tabContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
				tabContainer.Visible = false
				tabContainer.LayoutOrder = stealRow.LayoutOrder + 1
				
				local stealTabLayout = Instance.new("UIListLayout", tabContainer)
				stealTabLayout.FillDirection = Enum.FillDirection.Horizontal
				stealTabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				stealTabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
				stealTabLayout.Padding = UDim.new(0, 8)
	
				local function mkTab(name)
					local btn = Instance.new("TextButton", tabContainer)
					btn.Size = UDim2.new(0.46, 0, 0, 26)
					btn.BackgroundColor3 = Color3.fromRGB(15, 28, 18)
					btn.Text = name:upper()
					btn.TextColor3 = Color3.fromRGB(150,220,165)
					btn.Font = Enum.Font.GothamBold
					btn.TextSize = 10
					Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
					
						local function updateTabVisuals()
							local isSelected = (Steal.StealMode == name)
							btn.BackgroundColor3 = isSelected and Color3.fromRGB(40, 200, 90) or Color3.fromRGB(15, 28, 18)
							btn.TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150,220,165)
						end
						
						btn.ZIndex = 10
						btn.MouseButton1Click:Connect(function()
							Steal:setMode(name)
							if name == "Normal" then
								if radInput then radInput.Text = tostring(60) end
								if _G._stealDurationBox then _G._stealDurationBox.Text = tostring(1.4) end
							else
								if radInput then radInput.Text = tostring(9) end
								if _G._stealDurationBox then _G._stealDurationBox.Text = tostring(1.1) end
							end
							saveConfig()
							-- Refresh all tabs in this container
							for _, child in ipairs(tabContainer:GetChildren()) do
								if child:IsA("TextButton") then
									local isThis = (child.Text == "NORMAL" and name == "Normal") or (child.Text == "SEMI" and name == "Semi")
									child.BackgroundColor3 = isThis and Color3.fromRGB(40, 200, 90) or Color3.fromRGB(15, 28, 18)
									child.TextColor3 = isThis and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150,220,165)
								end
							end
						end)
					updateTabVisuals()
					return btn
				end
	
mkTab("Normal")
mkTab("Semi")
	
					chevronClick.Activated:Connect(function()
						tabContainer.Visible = not tabContainer.Visible
						chevronIcon.Text = tabContainer.Visible and "▲" or "▼"
					end)
		end
	mkSect("Combat Abilities","Combat")
	do
mkToggle("Player ESP", function(on)
			_G.espEnabled = on
			_G.lineEspEnabled = on
			if not on then
				for p, data in pairs(Conns.esp) do
					if data.box then pcall(function() data.box:Destroy() end) end
					if data.line then pcall(function() data.line:Remove() end) end
				end
				Conns.esp = {}
			end
			saveConfig()
		end)
	end
		do
			local jumpRow = mkRow(32)
			mkLabel(jumpRow, "Infinite Jump")
			
			-- Toggle Pill
			local pill, dot = mkPill(jumpRow, 42)
			local on = false
			local function sv(s) on = s; animPill(pill, dot, s) end
			_G.setInfJumpVisual = function(val) on = val; sv(val); infJumpEnabled = val end
			local clk = Instance.new("TextButton", pill)
			clk.Size = UDim2.new(1, 0, 1, 0)
			clk.BackgroundTransparency = 1
			clk.Text = ""
			clk.ZIndex = 5
			clk.Activated:Connect(function()
				on = not on; sv(on); infJumpEnabled = on
				saveConfig()
			end)
			pill.ZIndex = 3; dot.ZIndex = 4

			-- Chevron Button next to Pill
			local chevronBtn = Instance.new("Frame", jumpRow)
			chevronBtn.Size = UDim2.new(0, 30, 0, 24)
			chevronBtn.Position = UDim2.new(1, -85, 0.5, -12)
			chevronBtn.BackgroundColor3 = Color3.fromRGB(18, 30, 20)
			chevronBtn.BackgroundTransparency = 0.5
			Instance.new("UICorner", chevronBtn).CornerRadius = UDim.new(0, 6)
			
			local chevronIcon = Instance.new("TextLabel", chevronBtn)
			chevronIcon.Size = UDim2.new(1, 0, 1, 0)
			chevronIcon.BackgroundTransparency = 1
			chevronIcon.Text = "▼"
			chevronIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
			chevronIcon.Font = Enum.Font.GothamBold
			chevronIcon.TextSize = 8
			_G._jumpChevronIcon = chevronIcon
			
			local chevronClick = Instance.new("TextButton", chevronBtn)
			chevronClick.Size = UDim2.new(1, 0, 1, 0)
			chevronClick.BackgroundTransparency = 1
			chevronClick.Text = ""
			chevronClick.ZIndex = 6

			-- Tab Container (appears below Infinite Jump row)
			local tabContainer = mkRow(36)
			tabContainer.Name = "JumpModeTabs"
			tabContainer.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
			tabContainer.Visible = false
			tabContainer.LayoutOrder = jumpRow.LayoutOrder + 1
			
			local jumpTabLayout = Instance.new("UIListLayout", tabContainer)
			jumpTabLayout.FillDirection = Enum.FillDirection.Horizontal
			jumpTabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			jumpTabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			jumpTabLayout.Padding = UDim.new(0, 8)

			local function mkTab(name)
				local btn = Instance.new("TextButton", tabContainer)
				btn.Size = UDim2.new(0.46, 0, 0, 26)
				btn.BackgroundColor3 = Color3.fromRGB(15, 28, 18)
				btn.Text = name:upper()
				btn.TextColor3 = Color3.fromRGB(150,220,165)
				btn.Font = Enum.Font.GothamBold
				btn.TextSize = 10
				Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
				
				local function updateTabVisuals()
					local isSelected = (infJumpMode == name:lower())
					btn.BackgroundColor3 = isSelected and Color3.fromRGB(40, 200, 90) or Color3.fromRGB(15, 28, 18)
					btn.TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150,220,165)
				end
				
				btn.ZIndex = 10
				btn.MouseButton1Click:Connect(function()
					infJumpMode = name:lower()
					saveConfig()
					-- Refresh all tabs in this container
					for _, child in ipairs(tabContainer:GetChildren()) do
						if child:IsA("TextButton") then
							local isThis = (child.Text == name:upper())
							child.BackgroundColor3 = isThis and Color3.fromRGB(40, 200, 90) or Color3.fromRGB(15, 28, 18)
							child.TextColor3 = isThis and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150,220,165)
						end
					end
				end)
				updateTabVisuals()
				return btn
			end

mkTab("Manual")
mkTab("Hold")

			chevronClick.Activated:Connect(function()
				tabContainer.Visible = not tabContainer.Visible
				chevronIcon.Text = tabContainer.Visible and "▲" or "▼"
			end)
		end
	
	_G.setAntiRagVisual=mkToggle("Anti Ragdoll",function(on) antiRagdollEnabled=on;if on then startAntiRagdoll() else stopAntiRagdoll() end end)
	do
		local row=mkRow(32);mkLabel(row,"Medusa Counter")
		local pill,dot=mkPill(row,42)
		local on=false
		local function sv(s) on=s;animPill(pill,dot,s) end
		_G.setMedusaVisual=sv
		local clk=Instance.new("TextButton",pill);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=5
		clk.Activated:Connect(function()
			on=not on;sv(on)
			medusaCounterEnabled=on
			if on then setupMedusa(LP.Character)
			else stopMedusaCounter() end
			saveConfig()
		end)
		pill.ZIndex=3;dot.ZIndex=4
	end
	_G.setUnwalkVisual=mkToggle("Unwalk",function(on) unwalkEnabled=on;if on then startUnwalk() else stopUnwalk() end end)
	setTryhardAnimVisual=mkToggle("Tryhard Animation",function(on) tryhardAnimEnabled=on;if on then startTryhardAnim() else stopTryhardAnim() end end)
	do
		local row=mkRow(32);mkLabel(row,"Drop Brainrot")
		mkKB(row,KB.DropBrainrot,function(k,isGp) if isGp then KB.DropBrainrot.gp=k;KB.DropBrainrot.kb=nil else KB.DropBrainrot.kb=k;KB.DropBrainrot.gp=nil end;saveConfig() end)
		local clk=Instance.new("TextButton",row);clk.Size=UDim2.new(0.58,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=2
		clk.Activated:Connect(function() runDrop() end)
	end
	mkSect("Teleport","Combat")
	do
		local row=mkRow(32);mkLabel(row,"TP Down")
		mkKB(row,KB.TPFloor,function(k,isGp) if isGp then KB.TPFloor.gp=k;KB.TPFloor.kb=nil else KB.TPFloor.kb=k;KB.TPFloor.gp=nil end;saveConfig() end)
		local clk=Instance.new("TextButton",row);clk.Size=UDim2.new(0.58,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=2
		clk.Activated:Connect(function() runTPFloor() end)
	end
	do
		setAutoTPVisual=mkToggle("Auto TP",function(on)
			autoTPEnabled=on
			if on then startAutoTP() else stopAutoTP() end
			saveConfig()
		end)
	end
	do
		local row=mkRow(32);mkLabel(row,"Auto TP Height")
		autoTPHeightBox=mkBox(row,autoTPHeight,50,56,function(v)
			if v>=0 and v<=500 then autoTPHeight=v else autoTPHeightBox.Text=tostring(autoTPHeight) end
			saveConfig()
		end)
	end
	mkSect("Visual","Visual")
		-- Background picker removed: the menu uses only MAIN_BACKGROUND_ASSET.
		setAntiLagVisual=mkToggle("Anti Lag",function(on)
		antiLagEnabled=on
		if on then startAntiLag() else stopAntiLag() end
		saveConfig()
	end)
	setStretchRezVisual=mkToggle("Stretch Rez",function(on)
		if on then enableStretchRez() else disableStretchRez() end
		saveConfig()
	end)
	mkSect("Sky Themes","Visual")
	do
		local row=mkRow(32);mkLabel(row,"Sky Theme")
		local skyIndex = 1
		local current = _G._CandyHubSkyMode or "Off"
		for i, entry in ipairs(CandySkyOrder) do
			if entry[2] == current then skyIndex = i; break end
		end
		local skyVal = Instance.new("TextLabel",row)
		skyVal.Size=UDim2.new(0,150,1,0);skyVal.Position=UDim2.new(1,-158,0,0)
		skyVal.BackgroundTransparency=1;skyVal.Text=CandySkyOrder[skyIndex][2]
		skyVal.TextColor3=RED;skyVal.Font=Enum.Font.GothamBlack;skyVal.TextSize=11
		skyVal.TextXAlignment=Enum.TextXAlignment.Right;skyVal.ZIndex=3
		local skyBtn=Instance.new("TextButton",row);skyBtn.Size=UDim2.new(1,0,1,0)
		skyBtn.BackgroundTransparency=1;skyBtn.Text="";skyBtn.ZIndex=2
		skyBtn.Activated:Connect(function()
			skyIndex=skyIndex%#CandySkyOrder+1
			local label=CandySkyOrder[skyIndex][2]
			skyVal.Text=label
			CandyApplyCustomSky(label)
			saveConfig()
		end)
	end
	mkSect("Movement","Speed")
	do
		local sv=mkToggleKB("Auto Left",KB.AutoLeft,
			function(on)
				autoLeftEnabled=on
				if on then
					queueAutoLeftStart()
				else stopAutoLeft() end
			end,
			function(k,isGp) if isGp then KB.AutoLeft.gp=k;KB.AutoLeft.kb=nil else KB.AutoLeft.kb=k;KB.AutoLeft.gp=nil end;saveConfig() end)
		autoLeftSetVisual=sv
	end
	do
		local sv=mkToggleKB("Auto Right",KB.AutoRight,
			function(on)
				autoRightEnabled=on
				if on then
					queueAutoRightStart()
				else stopAutoRight() end
			end,
			function(k,isGp) if isGp then KB.AutoRight.gp=k;KB.AutoRight.kb=nil else KB.AutoRight.kb=k;KB.AutoRight.gp=nil end;saveConfig() end)
		autoRightSetVisual=sv
	end

	-- ============================================================
	-- SKIN CHANGER (ported from f society duels)
	-- ============================================================
	mkSect("Skin Changer","Visual")
	do
		-- Anim Pack cycle button
		local SC_PACK_NAMES = {}
		for name in pairs(SC_ANIMATION_PACKS) do table.insert(SC_PACK_NAMES, name) end
		table.sort(SC_PACK_NAMES)
		local scPackIndex = 1
		for i,v in ipairs(SC_PACK_NAMES) do if v==SC_selectedAnimPack then scPackIndex=i;break end end

		local packRow=mkRow(32);mkLabel(packRow,"Anim Pack")
		local packVal=Instance.new("TextLabel",packRow)
		packVal.Size=UDim2.new(0,120,1,0);packVal.Position=UDim2.new(1,-128,0,0)
		packVal.BackgroundTransparency=1;packVal.Text=SC_PACK_NAMES[scPackIndex]
		packVal.TextColor3=RED;packVal.Font=Enum.Font.GothamBlack;packVal.TextSize=9
		packVal.TextXAlignment=Enum.TextXAlignment.Right;packVal.ZIndex=3
		local packClk=Instance.new("TextButton",packRow);packClk.Size=UDim2.new(1,0,1,0)
		packClk.BackgroundTransparency=1;packClk.Text="";packClk.ZIndex=2
		packClk.Activated:Connect(function()
			scPackIndex=scPackIndex%#SC_PACK_NAMES+1
			SC_selectedAnimPack=SC_PACK_NAMES[scPackIndex]
			packVal.Text=SC_selectedAnimPack
			if SC_animationPackActive then
				task.spawn(function() SC_applyAnimPack(SC_selectedAnimPack,LP.Character) end)
			end
			saveConfig()
		end)
	end
	do
		-- Anim Pack toggle
		local svAnimPack=mkToggle("Enable Anim Pack",function(on)
			SC_animationPackActive=on
			if on then
				task.spawn(function() SC_applyAnimPack(SC_selectedAnimPack,LP.Character) end)
			else
				-- Restore default anims by resetting the Animate script
				local char=LP.Character
				if char then
					local animate=char:FindFirstChild("Animate")
					if animate and (animate:IsA("LocalScript") or animate:IsA("Script")) then
						pcall(function()
							local clone=animate:Clone()
							clone.Disabled=true; clone.Parent=char
							animate:Destroy(); clone.Name="Animate"; clone.Disabled=false
							RunService.Heartbeat:Wait()
						end)
					end
				end
			end
			saveConfig()
		end)
		if SC_animationPackActive then svAnimPack(true) end
	end
	do
		-- Headless toggle
		local svHL=mkToggle("Headless",function(on)
			SC_headlessEnabled=on
			SC_applyHeadless(LP.Character,on)
			saveConfig()
		end)
		if SC_headlessEnabled then svHL(true) end
	end
	do
		-- Korblox toggle
		local svKB=mkToggle("Korblox",function(on)
			SC_korbloxEnabled=on
			SC_applyKorblox(LP.Character,on)
			saveConfig()
		end)
		if SC_korbloxEnabled then svKB(true) end
	end
	do
		-- Outfit cycle button
		local SC_OUTFITS = {"Default","Outfit 1","Outfit 2","Outfit 3"}
		local scOutfitIndex = 1
		for i,v in ipairs(SC_OUTFITS) do if v==SC_currentOutfit then scOutfitIndex=i;break end end

		local outRow=mkRow(32);mkLabel(outRow,"Outfit")
		local outVal=Instance.new("TextLabel",outRow)
		outVal.Size=UDim2.new(0,100,1,0);outVal.Position=UDim2.new(1,-108,0,0)
		outVal.BackgroundTransparency=1;outVal.Text=SC_OUTFITS[scOutfitIndex]
		outVal.TextColor3=RED;outVal.Font=Enum.Font.GothamBlack;outVal.TextSize=10
		outVal.TextXAlignment=Enum.TextXAlignment.Right;outVal.ZIndex=3
		local outClk=Instance.new("TextButton",outRow);outClk.Size=UDim2.new(1,0,1,0)
		outClk.BackgroundTransparency=1;outClk.Text="";outClk.ZIndex=2
		outClk.Activated:Connect(function()
			scOutfitIndex=scOutfitIndex%#SC_OUTFITS+1
			SC_currentOutfit=SC_OUTFITS[scOutfitIndex]
			outVal.Text=SC_currentOutfit
			SC_applyOutfit(LP.Character,SC_currentOutfit)
			saveConfig()
		end)
	end

	mkSect("Interface","Config")
	do local row=mkRow(32);mkLabel(row,"Hide UI");mkKB(row,KB.GuiHide,function(k,isGp) if isGp then KB.GuiHide.gp=k;KB.GuiHide.kb=nil else KB.GuiHide.kb=k;KB.GuiHide.gp=nil end;saveConfig() end) end
	-- Lock UI toggle
	setLockUIVisual=mkToggle("Lock UI",function(on)
		uiLocked=on
		saveConfig()
	end)

	
	UIS.InputBegan:Connect(function(input,gpe)
		if _anyKeyListening then return end
		if input.UserInputType==Enum.UserInputType.Keyboard then
			if gpe or UIS:GetFocusedTextBox() then return end
		elseif not isGamepadInput(input) then return end
		if not isBindableInput(input) then return end
		local kc=input.KeyCode
		if kbMatch(KB.LaggerToggle,kc) then
			toggleLaggerMode()
			saveConfig()
		elseif kbMatch(KB.SpeedToggle,kc) then
			toggleCarryMode()
			saveConfig()
		elseif kbMatch(KB.DropBrainrot,kc) then runDrop()
		elseif kbMatch(KB.TPFloor,kc) then runTPFloor()
		elseif kbMatch(KB.AutoLeft,kc) then
			autoLeftEnabled=not autoLeftEnabled
			if autoLeftEnabled then
				queueAutoLeftStart()
			else stopAutoLeft() end
			if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
		elseif kbMatch(KB.AutoRight,kc) then
			autoRightEnabled=not autoRightEnabled
			if autoRightEnabled then
				queueAutoRightStart()
			else stopAutoRight() end
			if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
		elseif kbMatch(KB.AutoBat,kc) then
			if not autoBatEnabled then
				queueAutoBatStart()
				if autoBatSetVisual then autoBatSetVisual(true) end
			else
				autoBatEnabled=false;disableAutoBat()
				if autoBatSetVisual then autoBatSetVisual(false) end
			end
		elseif kbMatch(KB.TPBat,kc) then
			_G.mwvaneTPBatToggled = not _G.mwvaneTPBatToggled
			if _G.mwvaneTPBatToggled then _G.startMwVaneTPBat() else _G.stopMwVaneTPBat() end
			if setMwVaneTPBatVisual then setMwVaneTPBatVisual(_G.mwvaneTPBatToggled) end
		elseif kbMatch(KB.GuiHide,kc) then setMenuMinimized(not minimized)
		end
	end)
end
local _savedCfg = nil
local function loadConfigKeys()
	if not(isfile and isfile("fadeaway_settings.json")) then return end
	local ok,cfg=pcall(function() return HS:JSONDecode(readfile("fadeaway_settings.json")) end)
	if not ok or not cfg then return end
	_savedCfg=cfg
	local function lk(e,d) if type(d)~="table" then return end;if d.kb and Enum.KeyCode[d.kb] then e.kb=Enum.KeyCode[d.kb] end;if d.gp and Enum.KeyCode[d.gp] then e.gp=Enum.KeyCode[d.gp] end end
	lk(KB.DropBrainrot,cfg.dropBrainrotKey);lk(KB.AutoLeft,cfg.autoLeftKey);lk(KB.AutoRight,cfg.autoRightKey)
	lk(KB.AutoBat,cfg.autoBatKey);lk(KB.TPBat,cfg.mwvaneTPBatKey);lk(KB.LaggerToggle,cfg.laggerToggleKey)
	if not cfg.mwvaneTPBatKey then lk(KB.TPBat,cfg.batV2Key or cfg.candyTPBatKey) end
	lk(KB.TPFloor,cfg.tpFloorKey);lk(KB.GuiHide,cfg.guiHideKey);lk(KB.SpeedToggle,cfg.speedToggleKey)
	if cfg.normalSpeed then NS=cfg.normalSpeed end
	if cfg.carrySpeed then CS=cfg.carrySpeed end
	-- Load mode
	if cfg.stealMode then Steal:setMode(cfg.stealMode) else Steal:setMode("Normal") end
	-- Load custom overrides if they exist, otherwise use mode defaults
	if cfg.grabRadius and type(cfg.grabRadius)=="number" then 
		Steal.Modes[Steal.StealMode].StealRadius=cfg.grabRadius 
	end
	if cfg.stealDuration and type(cfg.stealDuration)=="number" then 
		Steal.Modes[Steal.StealMode].StealDuration=cfg.stealDuration 
	end
	if cfg.laggerSpeed and type(cfg.laggerSpeed)=="number" then LAGGER_SPEED=cfg.laggerSpeed end
	if cfg.laggerCarrySpeed and type(cfg.laggerCarrySpeed)=="number" then LAGGER_CARRY_SPEED=cfg.laggerCarrySpeed end
	if cfg.mwvaneTPBatRange and type(cfg.mwvaneTPBatRange)=="number" then _G.MWVANE_TP_BAT_RANGE=cfg.mwvaneTPBatRange elseif cfg.candyTPBatRange and type(cfg.candyTPBatRange)=="number" then _G.MWVANE_TP_BAT_RANGE=cfg.candyTPBatRange elseif cfg.batV2Speed and type(cfg.batV2Speed)=="number" then _G.MWVANE_TP_BAT_RANGE=cfg.batV2Speed end
			if cfg.autoTPHeight and type(cfg.autoTPHeight)=="number" then autoTPHeight=cfg.autoTPHeight end
		if cfg.autoSwing~=nil then autoSwingEnabled=cfg.autoSwing==true end
		if type(cfg.selectedBgIndex)=="number" then _G.selectedBgIndex=cfg.selectedBgIndex end

		-- Restore the selected sky/picture label before the GUI is built.
		if type(cfg.skyTheme)=="string" then
			for _,entry in ipairs(CandySkyOrder) do
				if entry[2]==cfg.skyTheme then break end
			end
		end
	end

local function loadConfigState()
	local cfg=_savedCfg;if not cfg then return end
	if normalBox then normalBox.Text=tostring(NS) end
	if carryBox then carryBox.Text=tostring(CS) end
	if radInput then radInput.Text=tostring(Steal:getRadius()) end
	if progressRadLbl then progressRadLbl.Text=string.format("Radius: %.2g",Steal:getRadius()) end
	if laggerBox then laggerBox.Text=tostring(LAGGER_SPEED) end
	if laggerCarryBox then laggerCarryBox.Text=tostring(LAGGER_CARRY_SPEED) end
	if autoTPHeightBox then autoTPHeightBox.Text=tostring(autoTPHeight) end
	task.spawn(function()
		task.wait(0.15)
		if cfg.antiRagdoll then antiRagdollEnabled=true;if _G.setAntiRagVisual then _G.setAntiRagVisual(true) end;startAntiRagdoll() end
		if cfg.autoStealEnabled then Steal.AutoStealEnabled=true;if _G.setInstaGrab then _G.setInstaGrab(true) end;pcall(startAutoSteal) end
		if cfg.infiniteJump then infJumpEnabled=true;if _G.setInfJumpVisual then _G.setInfJumpVisual(true) end end
		if cfg.infJumpMode then infJumpMode=cfg.infJumpMode end
			if cfg.medusaCounter then medusaCounterEnabled=true;if _G.setMedusaVisual then _G.setMedusaVisual(true) end end
			if medusaCounterEnabled then setupMedusa(LP.Character) end
		if cfg.batCounter then batCounterEnabled=true;if setBatCounterVisual then setBatCounterVisual(true) end;startBatCounter() end
		if cfg.laggerMode then laggerToggled=true;speedMode=false;laggerPhase=cfg.laggerCarryMode and 2 or 1;refreshSpeedModeLabel()
		elseif cfg.carryMode then speedMode=true;refreshSpeedModeLabel() end
		if cfg.autoTPEnabled then autoTPEnabled=true;if setAutoTPVisual then setAutoTPVisual(true) end;startAutoTP() end
		if cfg.autoSwing~=nil then autoSwingEnabled=cfg.autoSwing==true end;if _G.setAutoSwingVisual then _G.setAutoSwingVisual(autoSwingEnabled) end
		if cfg.autoBat then autoBatEnabled=true;if autoBatSetVisual then autoBatSetVisual(true) end;queueAutoBatStart() end
		if cfg.unwalkEnabled then unwalkEnabled=true;if _G.setUnwalkVisual then _G.setUnwalkVisual(true) end;task.spawn(function() task.wait(0.5);startUnwalk() end) end
		if cfg.tryhardAnim then tryhardAnimEnabled=true;if setTryhardAnimVisual then setTryhardAnimVisual(true) end;startTryhardAnim() end
		if cfg.antiLag or cfg.dawgOpt then antiLagEnabled=true;startAntiLag();if setAntiLagVisual then setAntiLagVisual(true) end end
		if cfg.stretchRez then enableStretchRez();if setStretchRezVisual then setStretchRezVisual(true) end end
					if type(cfg.skyTheme)=="string" then

				CandyApplyCustomSky(cfg.skyTheme)
			end

			-- Restore lock/hide states
			if cfg.uiLocked then uiLocked=true;if setLockUIVisual then setLockUIVisual(true) end end
			-- Restore skin changer state
			if type(cfg.sc_headless)=="boolean" then SC_headlessEnabled=cfg.sc_headless end
			if type(cfg.sc_korblox)=="boolean" then SC_korbloxEnabled=cfg.sc_korblox end
			if type(cfg.sc_outfit)=="string" then SC_currentOutfit=cfg.sc_outfit end
			if type(cfg.sc_animPack)=="string" and SC_ANIMATION_PACKS[cfg.sc_animPack] then SC_selectedAnimPack=cfg.sc_animPack end
			if type(cfg.sc_animPackActive)=="boolean" then SC_animationPackActive=cfg.sc_animPackActive end
		end)
end
-- Intro animation function removed

	loadConfigKeys()
	buildGui()
	loadConfigState()



	print("mwvane hub Loaded")

-- Intro animation removed