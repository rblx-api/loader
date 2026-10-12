local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local LP               = Players.LocalPlayer
if not LP then LP = Players.PlayerAdded:Wait() end
if not game:IsLoaded() then
    local t0 = os.clock()
    while not game:IsLoaded() and (os.clock() - t0) < 1.5 do
        task.wait(0.03)
    end
end
local PlayerGui = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 3)
print("leak by https://discord.gg/TBBAUZu8cW")
_G._NoxaIntroHidingUI  = false
_G.NoxaHub_MainExecuted = false

pcall(function()
    if _G.K7NormalAutoStealStop then _G.K7NormalAutoStealStop() end
end)
pcall(function()
    if _G.K7SemiAutoStealStop then _G.K7SemiAutoStealStop() end
end)
pcall(function()
    for _, name in ipairs({"NoxaHub", "NoxaMobileButtons", "NoxaStealBar", "AutoGrab", "K7StealBarGui", "NoxaRitualStealBar", "NoxaBackgroundGalleryLayer", "NoxaKuRuSkin", "NoxaVx7Skin"}) do
        local old = PlayerGui:FindFirstChild(name)
        if old then old:Destroy() end
    end
end)
pcall(function()
    local cg = game:GetService("CoreGui")
    for _, name in ipairs({"K7StealBarGui", "NoxaStealBar", "NoxaRitualStealBar", "NoxaBackgroundGalleryLayer", "NoxaKuRuSkin", "NoxaVx7Skin"}) do
        local old = cg:FindFirstChild(name)
        if old then old:Destroy() end
    end
end)
_G.StealBar = nil
_G._K7AutoGrabGui = nil
_G._K7AutoGrabFrame = nil
_G._K7StealModeChip = nil

pcall(function()
    if type(_G._NoxaCleanup) == "function" then
        _G._NoxaCleanup()
    end
end)
_G._NoxaRSConns = {}
_G._NoxaTrackConn = function(conn)
    if not conn then return conn end
    _G._NoxaRSConns = _G._NoxaRSConns or {}
    table.insert(_G._NoxaRSConns, conn)
    return conn
end
_G._NoxaCleanup = function()
    for _, c in ipairs(_G._NoxaRSConns or {}) do
        pcall(function() c:Disconnect() end)
    end
    _G._NoxaRSConns = {}
    pcall(function()
        local ss = rawget(_G, "SpeedSystem") or nil
        if _G.NoxaDisableNoPlayerCollision then _G.NoxaDisableNoPlayerCollision() end
    end)
    for _, key in ipairs({
        "_NoxaSpaceProgConn", "_NoxaBatConn", "_NoxaSpeedConn",
        "_NoxaAutoCarryConn", "_NoxaInfJumpConn", "_NoxaAntiRagConn",
        "_NoxaDropBRConn", "_NoxaTPBatConn", "_NoxaSafeModeConn",
        "_NoxaMobileSyncConn", "_NoxaFxPulseConn", "_NoxaAutoTpDownConn",
        "_NoxaRagTimerConn",
    }) do
        local c = _G[key]
            pcall(function() c:Disconnect() end)
            _G[key] = nil
        end
    end
end

IS_MOBILE = (UserInputService.TouchEnabled == true)
_G.NoxaIsMobile = IS_MOBILE

if not fireproximityprompt then
    fireproximityprompt = function(prompt)
        pcall(function()
            prompt:InputHoldBegin()
            task.wait(0.05)
            prompt:InputHoldEnd()
        end)
    end
end

local SpeedSystem = {

    NoxaVisual = { stretchResEnabled = false },
    AutoPath   = { leftEnabled = false, rightEnabled = false, leftPhase = 1, rightPhase = 1 },
    NoxaChar   = { headlessEnabled = false, korbloxEnabled = false },

    fov = 70,
    skyTheme = "Noxa",

    bgImageTransparency = 0.05,

    bgImageEnabled = not IS_MOBILE,
    bgImageIndex = 1,
    stealBarStyle = "V3",
    uiSkin = "Noxa",
    v3BarScale = 1,
    removeAccessoriesEnabled = false,

    antiDieEnabled = false,
    bodyLockEnabled = false,
    safeModeEnabled = false,
    noPlayerCollisionEnabled = false,
    antiFlingShieldEnabled = false,
    saturatedColorsEnabled = false,

    NS = 60,
    CS = 30,
    LAGGER_NORMAL = 15,
    LAGGER_CARRY = 24.5,

    speedMethod = "V1",
    laggerPhase = 0,

    carryActive = false,
    laggerActive = false,

    method = "Velocity Lerp",

    _bodyVel = nil,

    keybinds = {
        Carry = Enum.KeyCode.A,
        Lagger = Enum.KeyCode.V,
        AutoLeft = Enum.KeyCode.Z,
        AutoRight = Enum.KeyCode.C,
        BatAimbot = Enum.KeyCode.E,
        TPBat = Enum.KeyCode.T,

    uiScale = 0.75,
    menuOpen = true,

    introEnabled = false,
    introColor = nil,
    introColorLocked = false,

    autoPlayMode = "2btn",
    autoPlayEnabled = false,

    mobileButtons = {
        locked = false,
        hidden = false,
        style = "squircle",
        scale = 0.85,
        positions = {},

    autoCarryEnabled = false,
    autoTpDownEnabled = false,
    autoTpDownHeight = 12,
    _autoCarryActive = false,

    autoStealEnabled = false,
    stealRadius = 60,
    stealDuration = 1.3,
    stealMode = "V2 SEMI",
    tabPos = "Right",

    v2SemiRadius = 50,
    v2SemiHoldMin = 1.3,
    v2SemiHoldMax = 2.6,
    v2SemiEntryDelay = 0.3,
    v2SemiPrimeRange = 80,

    v3Radius = 62,
    v3Duration = 0.3,
    v3HalfFireRange = 10,
    v3HalfHoldMin = 1.3,
    v3HalfHoldMax = 2.6,
    v3HalfEntryDelay = 0.3,

    v4Threshold = 0.75,
    v4NearDist = 10,
    v4WaitNearMax = 4,
    v4ModeLevel = 1,
    _autoCarryReturnMode = nil,
    _autoCarryGraceUntil = 0,
    _autoCarryWatchUntil = 0,
    _autoCarryWaiting = false,

    infJumpEnabled = false,
    infJumpMode = "hold",
    _infJumpBoosting = false,
    _infJumpLastBoost = 0,
    INF_JUMP_BOOST_FORCE = 25,
    INF_JUMP_BOOST_FRAMES = 2,
    INF_JUMP_BOOST_COOLDOWN = 0.12,
    jumpHeld = false,
    _gamepadJumpHeld = false,
    _infJumpThread = nil,
    _holdInfJumpConn = nil,

    antiRagdollEnabled = false,
    antiRagdollMode = "Splatter",
    _antiRagdollConn = nil,
    _antiRagdollNoSplatterCooldown = 0,

    antiDesyncAutoSwingEnabled = false,

    animPack = "Tryard",
    _animApplying = false,

    autoDodgeEnabled = false,
    autoDodgeKeybind = Enum.KeyCode.H,
    _autoDodgeThread = nil,
    _autoDodgeTpUpDebounce = false,

    dropBrainrotEnabled = false,
    dropBrainrotKeybind = Enum.KeyCode.G,
    dropMode = 1,
    DROP_ASCEND_DURATION = 0.2,
    DROP_ASCEND_SPEED = 160,
    _dropBrainrotActive = false,
    _dropBrainrotConn = nil,
    _dropLastTime = 0,
    _dropConnections = {},

    tpDownKeybind = Enum.KeyCode.F,
    _tpDownActive = false,

    instantResetKeybind = Enum.KeyCode.R,
    instaResetOnDeathEnabled = false,
    resetTpPos = CFrame.new(2000.5, 9911.9, 4000.2),
    _instantResetCooldown = false,
    _instantResetStop = false,
    _instantResetCamBound = false,
    _instantResetRespawnConn = nil,
    _instaResetOnDeathConn = nil,
    _instaResetOnDeathHealthConn = nil,

    antiDesyncAimbotEnabled = false,
    tpBatVersion            = "V1",
    tpBatHittingCooldown    = false,
    tpBatCurrentTarget      = nil,
    tpBatSwingCooldown      = 0.12,
    tpBatTeleportDistance   = 5.5,
    tpBatHoldDistance       = 4.2,
    tpBatVelocitySpeed      = 60,
    tpBatCameraLock         = false,
    tpBatAutoDisableOnHit   = false,
    _tpBatConn              = nil,
    _tpBatLastTP            = 0,

local PACKS = {

	["Hit Harder"] = {
		WalkAnim = 707897309,
		RunAnim  = 707861613,
		JumpAnim = 116936326516985,
		FallAnim = 116936326516985,
		SwimIdle = 116936326516985,
		Swim     = 116936326516985,
		ClimbAnim = 116936326516985,
		Animation1 = 133806214992291,
		Animation2 = 94970088341563,
	["Tryard"] = {
		WalkAnim = 707897309,
		RunAnim  = 707861613,
		JumpAnim = 116936326516985,
		FallAnim = 116936326516985,
		SwimIdle = 116936326516985,
		Swim     = 116936326516985,
		ClimbAnim = 116936326516985,
		Animation1 = 133806214992291,
		Animation2 = 94970088341563,
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

	["Ninja"] = {
		Run=656118852, Walk=656121766, Jump=656117878, Fall=656115606,
		Swim=656119721, SwimIdle=656121397, Climb=656114359,
		Idle={656117400,656118341,886742569}
	["Robot"] = {
		Run=616091570, Walk=616095330, Jump=616090535, Fall=616087089,
		Swim=616092998, SwimIdle=616094091, Climb=616086039,
		Idle={616088211,616089559,885531463}
	["Levitation"] = {
		Run=616010382, Walk=616013216, Jump=616008936, Fall=616005863,
		Swim=616011509, SwimIdle=616012453, Climb=616003713,
		Idle={616006778,616008087,886862142}
	["Stylish"] = {
		Run=616140816, Walk=616146177, Jump=616139451, Fall=616134815,
		Swim=616143378, SwimIdle=616144772, Climb=616133594,
		Idle={616136790,616138447,886888594}
	["Bubbly"] = {
		Run=910025107, Walk=910034870, Jump=910016857, Fall=910001910,
		Swim=910028158, SwimIdle=910030921, Climb=909997997,
		Idle={910004836,910009958,1018536639}
	["Cartoon"] = {
		Run=742638842, Walk=742640026, Jump=742637942, Fall=742637151,
		Swim=742639220, SwimIdle=742639812, Climb=742636889,
		Idle={742637544,742638445,885477856}

local AnimPack = {}
function AnimPack.waitForAnimate(char)
	for _ = 1, 8 do
		local a = char:FindFirstChild("Animate")
		if a and a:FindFirstChild("idle") and a:FindFirstChild("run") and a:FindFirstChild("walk") then
			return a
		end
		task.wait(0.03)
	end
	return char and char:FindFirstChild("Animate")
end

function AnimPack.setAnim(animObj, id)
	if animObj and id then
		animObj.AnimationId = "rbxassetid://" .. tostring(id)
	end
end

function AnimPack.stopAllTracks(hum)
	if not hum then return end
	for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
		pcall(function() t:Stop(0) end)
	end
end

function AnimPack.ensureAnim(folder, name)
	if not folder then return nil end
	local a = folder:FindFirstChild(name)
	if not a then
		a = Instance.new("Animation")
		a.Name = name
		a.Parent = folder
	end
	return a
end

function AnimPack.ensureIdleSlots(idleFolder, n)
	if not idleFolder then return end
	n = n or 2
	for i=1,n do
		AnimPack.ensureAnim(idleFolder, "Animation" .. i)
	end
end

function AnimPack.pick(pack, ...)
	for i = 1, select("#", ...) do
		local k = select(i, ...)
		local v = pack[k]
		if v ~= nil then return v end
	end
	return nil
end

ATTR_LAST = "AnimPack_Last"
local applying = false

function AnimPack.applyPack(packName)
	if applying then return false end
	applying = true

	local pack = PACKS[packName]
	if not pack then
		applying = false
		return false
	end

	local char = LP.Character or LP.CharacterAdded:Wait()
	local animate = AnimPack.waitForAnimate(char)
	if not animate then
		applying = false
		return false
	end

	local hum = char:FindFirstChildOfClass("Humanoid")
	AnimPack.stopAllTracks(hum)

	local runObj   = AnimPack.ensureAnim(animate:FindFirstChild("run"),   "RunAnim")
	local walkObj  = AnimPack.ensureAnim(animate:FindFirstChild("walk"),  "WalkAnim")
	local jumpObj  = AnimPack.ensureAnim(animate:FindFirstChild("jump"),  "JumpAnim")
	local fallObj  = AnimPack.ensureAnim(animate:FindFirstChild("fall"),  "FallAnim")
	local climbObj = AnimPack.ensureAnim(animate:FindFirstChild("climb"), "ClimbAnim")
	local swimObj  = AnimPack.ensureAnim(animate:FindFirstChild("swim"),     "Swim")
	local swimIdleObj = AnimPack.ensureAnim(animate:FindFirstChild("swimidle"), "SwimIdle")
	local idleFolder = animate:FindFirstChild("idle")

	AnimPack.setAnim(walkObj,  AnimPack.pick(pack, "WalkAnim", "Walk"))
	AnimPack.setAnim(runObj,   AnimPack.pick(pack, "RunAnim", "Run"))
	AnimPack.setAnim(jumpObj,  AnimPack.pick(pack, "JumpAnim", "Jump"))
	AnimPack.setAnim(fallObj,  AnimPack.pick(pack, "FallAnim", "Fall"))
	AnimPack.setAnim(climbObj, AnimPack.pick(pack, "ClimbAnim", "Climb"))

	AnimPack.setAnim(swimObj,      AnimPack.pick(pack, "Swim"))
	AnimPack.setAnim(swimIdleObj,  AnimPack.pick(pack, "SwimIdle") or AnimPack.pick(pack, "Swim"))

	if idleFolder then
		local a1 = AnimPack.pick(pack, "Animation1")
		local a2 = AnimPack.pick(pack, "Animation2")

		if a1 or a2 then
			AnimPack.ensureIdleSlots(idleFolder, 2)
			local id1 = a1 or a2
			local id2 = a2 or a1 or id1
			AnimPack.setAnim(idleFolder:FindFirstChild("Animation1"), id1)
			AnimPack.setAnim(idleFolder:FindFirstChild("Animation2"), id2)
		elseif pack.Idle and #pack.Idle > 0 then
			AnimPack.ensureIdleSlots(idleFolder, math.max(2, #pack.Idle))
			AnimPack.setAnim(idleFolder:FindFirstChild("Animation1"), pack.Idle[1])
			AnimPack.setAnim(idleFolder:FindFirstChild("Animation2"), pack.Idle[2] or pack.Idle[1])
			for i = 3, #pack.Idle do
				local a = idleFolder:FindFirstChild("Animation" .. i)
				if a then AnimPack.setAnim(a, pack.Idle[i]) end
			end
		end
	end

	animate.Disabled = true
	task.wait(0.02)
	animate.Disabled = false

	if hum then
		pcall(function()
			hum:ChangeState(Enum.HumanoidStateType.Running)
		end)
	end

	pcall(function() LP:SetAttribute(ATTR_LAST, packName) end)

	applying = false
	return true
end

LP.CharacterAdded:Connect(function(char)
    task.wait(0.2)
    local saved = LP:GetAttribute("AnimPack_Last")
    if type(saved) ~= "string" or saved == "" or not PACKS[saved] then
        saved = SpeedSystem.animPack or "Tryard"
    end
    if type(saved) == "string" and saved ~= "" and saved ~= "OFF" and PACKS[saved] then
        AnimPack.applyPack(saved)
    end
end)

function SpeedSystem:getActiveSpeed(humanoid)

    if self.autoCarryEnabled and humanoid then
        local isCarry = humanoid.WalkSpeed < 25
        if self.laggerActive then
            return isCarry and self.LAGGER_CARRY or self.LAGGER_NORMAL
        else
            return isCarry and self.CS or self.NS
        end
    end

    if self.laggerActive then
        if self.carryActive then
            return self.LAGGER_CARRY
        else
            return self.LAGGER_NORMAL
        end
    else
        if self.carryActive then
            return self.CS
        else
            return self.NS
        end
    end
end

function SpeedSystem:getCurrentMode(humanoid)
    if self.autoCarryEnabled and humanoid then
        local isCarry = humanoid.WalkSpeed < 25
        if self.laggerActive then
            return isCarry and "LAGGER_CARRY" or "LAGGER_NORMAL"
        else
            return isCarry and "CARRY" or "NORMAL"
        end
    end
    if self.laggerActive and self.carryActive then
        return "LAGGER_CARRY"
    elseif self.laggerActive then
        return "LAGGER_NORMAL"
    elseif self.carryActive then
        return "CARRY"
    else
        return "NORMAL"
    end
end

function SpeedSystem:getModeLabel(humanoid)
    local m = self:getCurrentMode(humanoid)
    if m == "LAGGER_CARRY" then return "LAGGER CARRY"
    elseif m == "LAGGER_NORMAL" then return "LAGGER"
    elseif m == "CARRY" then return "CARRY"
    else return "NORMAL" end
end

function SpeedSystem:toggleCarry()
    if self.speedMethod == "V2" then

        self.laggerActive = false
        self.laggerPhase = 0
        self.carryActive = not self.carryActive
    else

        self.carryActive = not self.carryActive
        if self.laggerActive then
            self.laggerPhase = self.carryActive and 2 or 1
        end
    end
    self:updateUI()
    return self.carryActive
end

function SpeedSystem:toggleLagger()
    if self.speedMethod == "V2" then
        if not self.laggerActive then
            self.laggerActive = true
            self.carryActive = false
            self.laggerPhase = 1
        else
            self.carryActive = not self.carryActive
            self.laggerPhase = self.carryActive and 2 or 1
        end
    else

        self.laggerActive = not self.laggerActive
        if self.laggerActive then
            self.laggerPhase = self.carryActive and 2 or 1
        else
            self.laggerPhase = 0
        end
    end
    self:updateUI()
    return self.laggerActive
end

function SpeedSystem:setCarry(on)
    on = on and true or false
    if self.speedMethod == "V2" then
        self.laggerActive = false
        self.laggerPhase = 0
        self.carryActive = on
        self:updateUI()
        return
    end
    self.carryActive = on
    if self.laggerActive then
        self.laggerPhase = on and 2 or 1
    end
    self:updateUI()
end

function SpeedSystem:setLagger(on)
    on = on and true or false
    if self.speedMethod == "V2" then
        if on then
            self.laggerActive = true
            self.carryActive = false
            self.laggerPhase = 1
        else
            self.laggerActive = false
            self.laggerPhase = 0
        end
        self:updateUI()
        return
    end
    self.laggerActive = on
    self.laggerPhase = on and (self.carryActive and 2 or 1) or 0
    self:updateUI()
end

function SpeedSystem:setSpeedMode(mode)
    mode = mode or "NORMAL"
    if mode == "CARRY" then
        self.carryActive = true
        self.laggerActive = false
        self.laggerPhase = 0
    elseif mode == "LAGGER_NORMAL" or mode == "LAGGER" then
        self.laggerActive = true
        self.carryActive = false
        self.laggerPhase = 1
    elseif mode == "LAGGER_CARRY" then
        self.laggerActive = true
        self.carryActive = true
        self.laggerPhase = 2
    else
        self.carryActive = false
        self.laggerActive = false
        self.laggerPhase = 0
    end
    self:updateUI()
end

function SpeedSystem:updateUI()
    if self.onUIUpdate then
        self.onUIUpdate()
    end
end

function SpeedSystem:applySpeed(hrp, hum, dir, spd, dt)
    if not hrp or not hum then return end
    local flat = Vector3.new(dir.X, 0, dir.Z)
    if flat.Magnitude < 0.05 then
        hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
        return
    end
    flat = flat.Unit
    pcall(function()
        if hrp.SetNetworkOwner then hrp:SetNetworkOwner(LP) end
    end)
    hrp.AssemblyLinearVelocity = Vector3.new(flat.X * spd, hrp.AssemblyLinearVelocity.Y, flat.Z * spd)
end

function SpeedSystem:destroySpeedObjects()
    if self._bodyVel then
        pcall(function() self._bodyVel:Destroy() end)
        self._bodyVel = nil
    end
end

function SpeedSystem:isCarryingBrainrot(char)
    if not char then return false end

    local okA, vA = pcall(function() return LP:GetAttribute("Stealing") end)
    if okA and vA == true then return true end
    local okC, vC = pcall(function() return char:GetAttribute("Stealing") end)
    if okC and vC == true then return true end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.WalkSpeed > 0 and hum.WalkSpeed < 25 then

    end
    local keywords = {
        "brainrot", "brain rot", "animal", "pet", "carry", "grab", "steal",
        "hold", "item", "cash", "money", "trophy", "cup", "bag"
    local function nameMatch(n)
        n = tostring(n or ""):lower()
        for _, k in ipairs(keywords) do
            if n:find(k, 1, true) then return true end
        end
        return false
    end

    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") and nameMatch(child.Name) then return true end
        if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) and nameMatch(child.Name) then
            return true
        end

        if child:IsA("BasePart") and nameMatch(child.Name) then return true end
    end

    local bp = LP:FindFirstChild("Backpack")

    for _, v in ipairs(char:GetChildren()) do
        if v:IsA("BoolValue") and v.Value and nameMatch(v.Name) then return true end
        if v:IsA("ObjectValue") and v.Value and nameMatch(v.Name) then return true end
        if v:IsA("StringValue") and v.Value ~= "" and nameMatch(v.Name) then return true end
    end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("Weld") or d:IsA("WeldConstraint") or d:IsA("Motor6D") then
                local p0, p1 = d.Part0, d.Part1
                local other = (p0 == hrp and p1) or (p1 == hrp and p0)
                if other and other.Parent and other.Parent ~= char then
                    if nameMatch(other.Parent.Name) or nameMatch(other.Name) then
                        return true
                    end
                end
            end
        end
    end
    return false
end

function SpeedSystem:isHoldingBrainrot()
    if _G.NoxaSafeModeHoldingBrainrot then
        local ok, r = pcall(_G.NoxaSafeModeHoldingBrainrot)
        if ok and r then return true end
    end
    return self:isCarryingBrainrot(LP.Character) == true
end

function SpeedSystem:isActionBlocked(kind)

    if not self.safeModeEnabled then return false, nil end
    if kind ~= "aimbot" and kind ~= "tpbat" and kind ~= "autoplay" and kind ~= "path" then
        return false, nil
    end
    if _G.NoxaSafeModeIsLocked then
        local ok, locked = pcall(_G.NoxaSafeModeIsLocked)
        if ok and locked then
            return true, "Safe Mode"
        end
    end
    if self:isHoldingBrainrot() then
        return true, "Safe Mode · brainrot"
    end
    return false, nil
end

    _G.NoxaNoPlayerCollisionState = _G.NoxaNoPlayerCollisionState or { connections = {}, running = false }

    function _G.NoxaSetOtherPlayerCollision(state)
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                for _, part in ipairs(plr.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        pcall(function() part.CanCollide = state end)
                    end
                end
            end
        end
    end

    function _G.NoxaEnableNoPlayerCollision()
        local st = _G.NoxaNoPlayerCollisionState
        if st.running then return end
        SpeedSystem.noPlayerCollisionEnabled = true
        st.running = true
            pcall(function() conn:Disconnect() end)
        end
        _G.NoxaSetOtherPlayerCollision(false)
            task.wait(0.5)
            if SpeedSystem.noPlayerCollisionEnabled then
                _G.NoxaSetOtherPlayerCollision(false)
            end
        end))
            local c = plr.CharacterAdded:Connect(function()
                task.wait(0.5)
                if SpeedSystem.noPlayerCollisionEnabled then
                    _G.NoxaSetOtherPlayerCollision(false)
                end
            end)
        end))
        local collisionScanElapsed = 0
            if not SpeedSystem.noPlayerCollisionEnabled then return end
            collisionScanElapsed = collisionScanElapsed + (dt or 0)
            if collisionScanElapsed < 0.5 then return end
            collisionScanElapsed = 0
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    for _, part in ipairs(plr.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide == true then
                            pcall(function() part.CanCollide = false end)
                        end
                    end
                end
            end
        end))
    end

    function _G.NoxaDisableNoPlayerCollision()
        local st = _G.NoxaNoPlayerCollisionState
        if not st.running then
            SpeedSystem.noPlayerCollisionEnabled = false
            return
        end
        SpeedSystem.noPlayerCollisionEnabled = false
        st.running = false
            pcall(function() conn:Disconnect() end)
        end
        _G.NoxaSetOtherPlayerCollision(true)
    end
end

function SpeedSystem:softFaceTarget(root, targetPos, targetVel)
    if not root or not targetPos then return end
    local myPos = root.Position
    targetVel = targetVel or Vector3.zero
    local speed3 = targetVel.Magnitude
    local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
    local predictedPos = targetPos + targetVel * predictTime
    local flatTarget = Vector3.new(predictedPos.X, myPos.Y, predictedPos.Z)
    if (flatTarget - myPos).Magnitude < 0.1 then return end
    local goalCF = CFrame.lookAt(myPos, flatTarget)
    local _, ry, _ = (root.CFrame:Inverse() * goalCF):ToEulerAnglesXYZ()
    ry = math.clamp(ry, -2.5, 2.5)
    root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(0, ry * 42, 0))
end

function SpeedSystem:_tpBatGetMeleeTool()
    local char = LP.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local n = tool.Name:lower()
            if n:find("bat") or n:find("sword") or n:find("knife")
            or n:find("blade") or n:find("mace") then
                return tool
            end
            if tool:FindFirstChildWhichIsA("RemoteEvent")
            or tool:FindFirstChild("Activate") then
                return tool
            end
        end
    end

    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") then
                local n = tool.Name:lower()
                if n:find("bat") or n:find("sword") or n:find("knife")
                or n:find("blade") or n:find("mace") then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then pcall(function() hum:EquipTool(tool) end) end
                    return tool
                end
            end
        end
    end
    return nil
end

function SpeedSystem:_tpBatTryHit()
    if self.tpBatHittingCooldown then return end
    self.tpBatHittingCooldown = true
    pcall(function()
        local tool = self:_tpBatGetMeleeTool()
        if tool then
            pcall(function()
                if tool.Parent ~= LP.Character then
                    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                    if hum then hum:EquipTool(tool) end
                end
            end)

            if self.antiDesyncAutoSwingEnabled then
                pcall(function() tool:Activate() end)
                local ev = tool:FindFirstChildWhichIsA("RemoteEvent")
                if ev then pcall(function() ev:FireServer() end) end
            end
        end

    end)
    task.delay(self.tpBatSwingCooldown or 0.08, function()
        self.tpBatHittingCooldown = false
    end)
end

function SpeedSystem:_tpBatGetClosestPlayer(hrp)
    if not hrp then return nil, nil end
    local bestPlr, bestHrp, bestDist = nil, nil, 1e9
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            local c = plr.Character
                local th = c:FindFirstChild("HumanoidRootPart")
                local hum = c:FindFirstChildOfClass("Humanoid")
                if th and hum and hum.Health > 0 then
                    local d = (th.Position - hrp.Position).Magnitude
                    if d < bestDist then
                        bestDist = d
                        bestPlr = plr
                        bestHrp = th
                    end
                end
            end
        end
    end
    return bestPlr, bestHrp
end

function SpeedSystem:_tpBatTryHitBubble()
    if not self.antiDesyncAutoSwingEnabled and not self.tpBatAutoDisableOnHit then

    end
    if self.tpBatHittingCooldown then return end
    if not self.antiDesyncAutoSwingEnabled then return end
    self.tpBatHittingCooldown = true
    pcall(function()
        local tool = self:_tpBatGetMeleeTool()
        if tool then
            tool:Activate()
            local ev = tool:FindFirstChildWhichIsA("RemoteEvent")
            if ev then pcall(function() ev:FireServer() end) end
        end
    end)
    task.delay(self.tpBatSwingCooldown or 0.12, function()
        self.tpBatHittingCooldown = false
    end)
end

function SpeedSystem:startAntiDesyncAimbotV2()
    local blocked, reason = self:isActionBlocked("tpbat")
    if blocked then
        self.antiDesyncAimbotEnabled = false
        pcall(function() if notify then notify("Blocked · " .. tostring(reason or "Safe Mode"), 1.6) end end)
        return
    end
    self:stopAntiDesyncAimbot()
    self.antiDesyncAimbotEnabled = true
    pcall(function()
        local BA = rawget(_G, "NoxaBatAimbot") or (NoxaMods and NoxaMods.BatAimbotRef)
        if BA and BA.enabled then
            BA.enabled = false
            local stopFn = (NoxaMods and NoxaMods._batAimbotStop) or _G._batStop
            if type(stopFn) == "function" then stopFn() end
        end
    end)
    self._tpBatConn = RunService.Heartbeat:Connect(function()
        if not self.antiDesyncAimbotEnabled then return end
        if self.safeModeEnabled and self:isHoldingBrainrot() then
            self.antiDesyncAimbotEnabled = false
            task.defer(function()
                pcall(function() self:stopAntiDesyncAimbot() end)
                if notify then notify("Blocked · Safe Mode · brainrot", 1.5) end
            end)
            return
        end
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end
        local targetPlr, targetHrp = self:_tpBatGetClosestPlayer(hrp)
        self.tpBatCurrentTarget = targetPlr
        if not targetHrp then return end
        local tr = targetHrp
        local tvel = tr.AssemblyLinearVelocity
        local predict = Vector3.new(tvel.X, 0, tvel.Z) * 0.05
        local targetPos = tr.Position + Vector3.new(0, 0.9, 0) + predict
        if targetPos.Y < -20 then
            targetPos = Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z)
        end
        local facing = Vector3.new(tr.CFrame.LookVector.X, 0, tr.CFrame.LookVector.Z)
        if facing.Magnitude < 0.01 then
            local flat = Vector3.new(tr.Position.X - hrp.Position.X, 0, tr.Position.Z - hrp.Position.Z)
            facing = flat.Magnitude > 0.01 and flat.Unit or Vector3.new(0, 0, -1)
        else
            facing = facing.Unit
        end
        local engCF = CFrame.lookAt(targetPos, targetPos + facing)
        pcall(function()
            hrp.CFrame = engCF
            hrp.AssemblyLinearVelocity = Vector3.new(tvel.X, 0, tvel.Z)
            hrp.AssemblyAngularVelocity = Vector3.zero

            local lv = hrp:FindFirstChild("NoxaSpeedLV")
            if lv then lv.Enabled = false; lv.PlaneVelocity = Vector2.zero end
        end)
        if sethiddenproperty then
            pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", tr) end)
        end
        if self.tpBatCameraLock then
            local cam = workspace.CurrentCamera
            if cam then pcall(function() cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position) end) end
        end

        if self.antiDesyncAutoSwingEnabled or self.tpBatAutoDisableOnHit then
            self:_tpBatTryHit()
        end
    end)
end

function SpeedSystem:startAntiDesyncAimbotV1()
    local blocked, reason = self:isActionBlocked("tpbat")
    if blocked then
        self.antiDesyncAimbotEnabled = false
        pcall(function() if notify then notify("Blocked · " .. tostring(reason or "Safe Mode"), 1.6) end end)
        return
    end
    self:stopAntiDesyncAimbot()
    self.antiDesyncAimbotEnabled = true
    self.tpBatHittingCooldown = false
    pcall(function()
        local BA = rawget(_G, "NoxaBatAimbot") or (NoxaMods and NoxaMods.BatAimbotRef)
        if BA and BA.enabled then
            BA.enabled = false
            local stopFn = (NoxaMods and NoxaMods._batAimbotStop) or _G._batStop
            if type(stopFn) == "function" then stopFn() end
        end
    end)

    local function existGetBat(char)
        if not char then return nil end
        local tool = char:FindFirstChild("Bat")
        if tool and tool:IsA("Tool") then return tool end
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") then
                local n = string.lower(t.Name)
                if n:find("bat", 1, true) or n:find("slap", 1, true) then return t end
            end
        end
        local bp = LP:FindFirstChild("Backpack")
        if bp then
            tool = bp:FindFirstChild("Bat")
            if tool and tool:IsA("Tool") then
                pcall(function() tool.Parent = char end)
                return tool
            end
            for _, t in ipairs(bp:GetChildren()) do
                if t:IsA("Tool") then
                    local n = string.lower(t.Name)
                    if n:find("bat", 1, true) or n:find("slap", 1, true) then
                        pcall(function() t.Parent = char end)
                        return t
                    end
                end
            end
        end
        return nil
    end

    local function existTryHit(char)
        if self.tpBatHittingCooldown then return end
        self.tpBatHittingCooldown = true
        pcall(function()
            local bat = existGetBat(char)
            if bat then
                bat:Activate()
                local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
                if ev then pcall(function() ev:FireServer() end) end
            end
        end)
        task.delay(0.08, function() self.tpBatHittingCooldown = false end)
    end

    self._tpBatConn = RunService.Heartbeat:Connect(function()
        if not self.antiDesyncAimbotEnabled then return end
        if self.safeModeEnabled and self:isHoldingBrainrot() then
            self.antiDesyncAimbotEnabled = false
            task.defer(function()
                pcall(function() self:stopAntiDesyncAimbot() end)
                if notify then notify("Blocked · Safe Mode · brainrot", 1.5) end
            end)
            return
        end
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end

        local targetPlr, tr = self:_tpBatGetClosestPlayer(hrp)
        self.tpBatCurrentTarget = targetPlr
        if not tr then return end

        pcall(function()
            local lv = hrp:FindFirstChild("NoxaSpeedLV")
            if lv then lv.Enabled = false; lv.PlaneVelocity = Vector2.zero end
        end)
        if sethiddenproperty then
            pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", tr) end)
        end
        local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
        if (hrp.Position - targetPos).Magnitude > 8 then
            pcall(function()
                hrp.CFrame = CFrame.new(targetPos)
            end)
        end
        local cam = workspace.CurrentCamera
        if cam then
            pcall(function()
                cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position)
            end)
        end
        existTryHit(char)
    end)
end

function SpeedSystem:startAntiDesyncAimbot()
    local ver = tostring(self.tpBatVersion or "V1")
    if ver == "V2" then
        return self:startAntiDesyncAimbotV2()
    end
    return self:startAntiDesyncAimbotV1()
end

function SpeedSystem:stopAntiDesyncAimbot()
    if self._tpBatConn then
        self._tpBatConn:Disconnect()
        self._tpBatConn = nil
    end
    self.antiDesyncAimbotEnabled = false
    self.tpBatCurrentTarget = nil
    self.tpBatHittingCooldown = false
    self._tpBatLastTP = 0
end

function SpeedSystem:enableAutoCarry()
    if not self.autoCarryEnabled then return end
    if self._autoCarryActive then return end
    self._autoCarryReturnMode = self:getCurrentMode()
    self._autoCarryActive = true
    self._autoCarryGraceUntil = tick() + 0.75
    self:setLagger(false)
    self:setCarry(true)
    self:updateUI()
end

function SpeedSystem:disableAutoCarry()
    if not self._autoCarryActive then return end
    self._autoCarryActive = false
    self._autoCarryWaiting = false
    self._autoCarryWatchUntil = 0
    self._autoCarryGraceUntil = 0
    local returnMode = self._autoCarryReturnMode or "NORMAL"
    self._autoCarryReturnMode = nil
    if returnMode == "LAGGER" then
        self:setCarry(false); self:setLagger(true)
    elseif returnMode == "LAGGER_CARRY" then
        self:setCarry(true); self:setLagger(true)
    elseif returnMode == "CARRY" then
        self:setCarry(true); self:setLagger(false)
    else
        self:setCarry(false); self:setLagger(false)
    end
    self:updateUI()
end

function SpeedSystem:watchPickup(seconds)
    if not self.autoCarryEnabled then return end
    self._autoCarryWaiting = true
    self._autoCarryWatchUntil = tick() + (seconds or 1.25)
end

function SpeedSystem:startAutoCarryMonitor()
    if self._autoCarryMonitor then return end
    self._autoCarryMonitor = RunService.Heartbeat:Connect(function()
        if not self.autoCarryEnabled then
            if self._autoCarryActive then self:disableAutoCarry() end
            return
        end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hum or not root then
            self:disableAutoCarry()
            return
        end
        local st = hum:GetState()
        local gotHit = st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown
        local stealingAttr = LP:GetAttribute("Stealing") == true
        local carrying = self:isCarryingBrainrot(char)

        if self._autoCarryWaiting then
            if gotHit or tick() > (self._autoCarryWatchUntil or 0) then
                self._autoCarryWaiting = false
                self._autoCarryWatchUntil = 0
            elseif carrying then
                self:enableAutoCarry()
            end
        end
        if carrying and not self._autoCarryActive then
            self:enableAutoCarry()
        end
        if self._autoCarryActive then
            local graceDone = tick() > (self._autoCarryGraceUntil or 0)
            if gotHit or (graceDone and not carrying and not stealingAttr) then
                self:disableAutoCarry()
            end
        end
        if stealingAttr and not self._autoCarryActive then
            self:enableAutoCarry()
        end
    end)
end

function SpeedSystem:stopAutoCarryMonitor()
    if self._autoCarryMonitor then
        self._autoCarryMonitor:Disconnect()
        self._autoCarryMonitor = nil
    end
end

    local _lastInfJump = 0
    local _gamepadBtnHeld = false
    local _activeTouches = {}
    local _lastTouchStart = nil
    local _holdTouch = nil

    local function applyImpulse(root, hum, yVel)
        if not root then return end
        local attachment = root:FindFirstChild("InfJumpAttachment")
        if not attachment then
            attachment = Instance.new("Attachment")
            attachment.Name = "InfJumpAttachment"
            attachment.Parent = root
        end
        local currentX = root.AssemblyLinearVelocity.X
        local currentZ = root.AssemblyLinearVelocity.Z
        local targetY = yVel or 50
        local lv = Instance.new("LinearVelocity")
        lv.Name = "InfJumpVelocity"
        lv.MaxForce = 999999
        lv.VectorVelocity = Vector3.new(currentX, targetY, currentZ)
        lv.RelativeTo = Enum.ActuatorRelativeTo.World
        lv.Attachment0 = attachment
        lv.Parent = root
        task.delay(0.08, function()
            if lv then pcall(function() lv:Destroy() end) end
            if attachment and attachment.Parent == nil then
                pcall(function() attachment:Destroy() end)
            end
        end)
    end

    local function doInfJump(yVel)
        local now = os.clock()
        if now - _lastInfJump < 0.1 then return end
        _lastInfJump = now
        local c = LP.Character
        if not c then return end
        local hum = c:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local root = c:FindFirstChild("HumanoidRootPart")
        if not root then return end
        hum.Jump = true
        applyImpulse(root, hum, yVel)
    end

    function SpeedSystem:applyInfJumpBoost(root)
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        applyImpulse(root, hum, 50)
    end

    function SpeedSystem:startManualInfJumpLoop()
        if self._infJumpThread then
            pcall(function() self._infJumpThread:Disconnect() end)
            self._infJumpThread = nil
        end
    end

    function SpeedSystem:stopManualInfJumpLoop()
        if self._infJumpThread then
            pcall(function() self._infJumpThread:Disconnect() end)
            self._infJumpThread = nil
        end
        self.jumpHeld = false
        self._infJumpBoosting = false
    end

    function SpeedSystem:startHoldInfJump()
        if self._holdInfJumpConn then
            pcall(function() self._holdInfJumpConn:Disconnect() end)
            self._holdInfJumpConn = nil
        end
        self._holdInfJumpConn = RunService.Heartbeat:Connect(function()
            if not self.infJumpEnabled or self.infJumpMode ~= "hold" then return end
            local c = LP.Character
            if not c then return end
            local root = c:FindFirstChild("HumanoidRootPart")
            local hum = c:FindFirstChildOfClass("Humanoid")
            if not root or not hum or hum.Health <= 0 then return end
            local jumpHeld = UserInputService:IsKeyDown(Enum.KeyCode.Space)
                or _gamepadBtnHeld
                or self.jumpHeld == true
                or (_holdTouch ~= nil)
            if jumpHeld and root.AssemblyLinearVelocity.Y < 30 then
                hum.Jump = true
                applyImpulse(root, hum, 52)
            end
            if root.AssemblyLinearVelocity.Y < -120 then
                applyImpulse(root, hum, -120)
            end
        end)
        pcall(function()
            if _G._NoxaTrackConn then _G._NoxaTrackConn(self._holdInfJumpConn) end
        end)
    end

    function SpeedSystem:stopHoldInfJump()
        if self._holdInfJumpConn then
            pcall(function() self._holdInfJumpConn:Disconnect() end)
            self._holdInfJumpConn = nil
        end
    end

    function SpeedSystem:setInfJumpMode(mode)
        mode = string.lower(tostring(mode or "hold"))
        if mode == "tap" or mode == "manual" then
            self.infJumpMode = "manual"
        else
            self.infJumpMode = "hold"
        end
        self:stopManualInfJumpLoop()
        self:stopHoldInfJump()
        if self.infJumpEnabled then
            if self.infJumpMode == "hold" then
                self:startHoldInfJump()
            end
        end
        pcall(function()
            if _G.NoxaSetInfJumpModeUI then
                _G.NoxaSetInfJumpModeUI(self.infJumpMode)
            end
        end)
    end

    function SpeedSystem:setInfJumpEnabled(on)
        self.infJumpEnabled = on == true
        self:stopManualInfJumpLoop()
        self:stopHoldInfJump()
        if self.infJumpEnabled then
            if self.infJumpMode == "hold" then
                self:startHoldInfJump()
            end
        else
            self.jumpHeld = false
            self._gamepadJumpHeld = false
            self._infJumpBoosting = false
            _gamepadBtnHeld = false
            _holdTouch = nil
        end
    end

    local function isGamepadType(uit)
        return uit == Enum.UserInputType.Gamepad1
            or uit == Enum.UserInputType.Gamepad2
            or uit == Enum.UserInputType.Gamepad3
            or uit == Enum.UserInputType.Gamepad4
            or uit == Enum.UserInputType.Gamepad5
            or uit == Enum.UserInputType.Gamepad6
            or uit == Enum.UserInputType.Gamepad7
            or uit == Enum.UserInputType.Gamepad8
    end

    UserInputService.JumpRequest:Connect(function()
        if not SpeedSystem.infJumpEnabled then return end
        if SpeedSystem.infJumpMode == "hold" then
            if _holdTouch == nil and _lastTouchStart ~= nil and _activeTouches[_lastTouchStart] then
                _holdTouch = _lastTouchStart
            end
            return
        end
        doInfJump(50)
    end)

    UserInputService.InputBegan:Connect(function(inp)
        if not SpeedSystem.infJumpEnabled then return end
        if inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == Enum.KeyCode.Space then
            SpeedSystem.jumpHeld = true
            if SpeedSystem.infJumpMode == "manual" then
                doInfJump(50)
            end
            return
        end
        if inp.KeyCode == Enum.KeyCode.ButtonA and isGamepadType(inp.UserInputType) then
            _gamepadBtnHeld = true
            SpeedSystem._gamepadJumpHeld = true
            SpeedSystem.jumpHeld = true
            if SpeedSystem.infJumpMode == "manual" then
                doInfJump(50)
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == Enum.KeyCode.Space then
            SpeedSystem.jumpHeld = false
            return
        end
        if inp.KeyCode == Enum.KeyCode.ButtonA then
            _gamepadBtnHeld = false
            SpeedSystem._gamepadJumpHeld = false
            if not UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                SpeedSystem.jumpHeld = false
            end
        end
    end)

    UserInputService.TouchStarted:Connect(function(touch)
        if not SpeedSystem.infJumpEnabled or SpeedSystem.infJumpMode ~= "hold" then return end
        _activeTouches[touch] = true
        _lastTouchStart = touch
    end)
    UserInputService.TouchEnded:Connect(function(touch)
        _activeTouches[touch] = nil
        if _lastTouchStart == touch then _lastTouchStart = nil end
        if _holdTouch == touch then _holdTouch = nil end
    end)

    task.spawn(function()
        local pg = LP:WaitForChild("PlayerGui", 10)
        if not pg then return end
        local function hookBtn(btn)
            if btn:IsA("GuiButton") and btn.Name == "JumpButton" and not btn:GetAttribute("NoxaIJHooked") then
                btn:SetAttribute("NoxaIJHooked", true)
                btn.MouseButton1Down:Connect(function()
                    if not SpeedSystem.infJumpEnabled then return end
                    SpeedSystem.jumpHeld = true
                    if SpeedSystem.infJumpMode == "manual" then
                        doInfJump(50)
                    end
                end)
                btn.MouseButton1Up:Connect(function() SpeedSystem.jumpHeld = false end)
                btn.MouseLeave:Connect(function() SpeedSystem.jumpHeld = false end)
            end
        end
        for _, d in ipairs(pg:GetDescendants()) do pcall(hookBtn, d) end
        pg.DescendantAdded:Connect(function(d) pcall(hookBtn, d) end)
    end)
end

function SpeedSystem:forceNoSplatterReset()
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

function SpeedSystem:startAntiRagdoll()
    if self._antiRagdollConn then return end
    self._antiRagdollConn = RunService.Heartbeat:Connect(function()
        if not self.antiRagdollEnabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end

        local state = hum:GetState()
        local isRagdolled = (state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown)

        if self.antiRagdollMode == "No Splatter" then
            if isRagdolled then
                local now = tick()
                if now - (self._antiRagdollNoSplatterCooldown or 0) > 0.15 then
                    self._antiRagdollNoSplatterCooldown = now
                    self:forceNoSplatterReset()
                end
            end
            return
        end

        if isRagdolled then
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                for _, obj in ipairs(char:GetDescendants()) do
                    if obj:IsA("Motor6D") then obj.Enabled = true end
                    if obj:IsA("Constraint") then obj.Enabled = true end
                end
                root.Velocity = Vector3.zero
                root.RotVelocity = Vector3.zero
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
    end)
end

function SpeedSystem:stopAntiRagdoll()
    if self._antiRagdollConn then
        self._antiRagdollConn:Disconnect()
        self._antiRagdollConn = nil
    end
end

function SpeedSystem:_autoDodgeTpUp()
    if self._autoDodgeTpUpDebounce then return end
    self._autoDodgeTpUpDebounce = true
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = CFrame.new(root.Position + Vector3.new(0, 8.7, 0))
    end
    task.delay(0.37, function()
        self._autoDodgeTpUpDebounce = false
    end)
end

function SpeedSystem:_autoDodgeTpDown()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {char}
    params.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(root.Position, Vector3.new(0, -500, 0), params)
    local targetY = result and (result.Position.Y + 2.5) or (root.Position.Y - 175)
    root.CFrame = CFrame.new(root.Position.X, targetY, root.Position.Z)
end

function SpeedSystem:startAutoDodge()
    if self._autoDodgeThread then return end
    self.autoDodgeEnabled = true
    self._autoDodgeThread = task.spawn(function()
        while self.autoDodgeEnabled do
            local char = LP.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 52, root.AssemblyLinearVelocity.Z)
                task.wait(0.08)
                root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 52, root.AssemblyLinearVelocity.Z)
            end
            task.wait(0.1)
            self:_autoDodgeTpUp()
            task.wait(0.18)
            self:_autoDodgeTpDown()
            task.wait(0.15)
        end
        self._autoDodgeThread = nil
    end)
end

function SpeedSystem:stopAutoDodge()
    self.autoDodgeEnabled = false
    self._autoDodgeThread = nil
end

function SpeedSystem:setAutoDodge(on)
    if on then self:startAutoDodge() else self:stopAutoDodge() end
end

function SpeedSystem:toggleAutoDodge()
    self:setAutoDodge(not self.autoDodgeEnabled)
    return self.autoDodgeEnabled
end

function SpeedSystem:stopDropBrainrot()
    self._dropBrainrotActive = false
    if self._dropBrainrotConn then
        pcall(function() self._dropBrainrotConn:Disconnect() end)
        self._dropBrainrotConn = nil
    end
    for _, t in ipairs(self._dropConnections or {}) do
        if type(t) == "thread" then
            pcall(task.cancel, t)
        elseif typeof(t) == "RBXScriptConnection" then
            pcall(function() t:Disconnect() end)
        end
    end
    self._dropConnections = {}
    local c = LP.Character
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end
end

function SpeedSystem:runDropBrainrot()
    if self._dropBrainrotActive then return end
    if _G.KawaiStopAutoTPForAction then pcall(_G.KawaiStopAutoTPForAction) end
    if _G.AceStopAutoTPForAction then pcall(_G.AceStopAutoTPForAction) end
    if _G.K7StopAutoTPForAction then pcall(_G.K7StopAutoTPForAction) end

    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    local mode = tonumber(self.dropMode) or 1
    local DROP_ASCEND_DURATION = tonumber(self.DROP_ASCEND_DURATION) or 0.2
    local DROP_ASCEND_SPEED = tonumber(self.DROP_ASCEND_SPEED) or 160

    if mode == 1 then
        local speedH = 0
            local vel = root.AssemblyLinearVelocity
            speedH = Vector3.new(vel.X, 0, vel.Z).Magnitude
        end
        local cooldown = (speedH > 5) and 0.6 or 0.25
        if tick() - (self._dropLastTime or 0) < cooldown then return end
        self._dropLastTime = tick()
        self._dropBrainrotActive = true

        local function finishDrop(threadRef)
            if threadRef and self._dropConnections then
                for i = #self._dropConnections, 1, -1 do
                    if self._dropConnections[i] == threadRef then
                        table.remove(self._dropConnections, i)
                        break
                    end
                end
            end
            self._dropBrainrotActive = false
            local c = LP.Character
                local r = c:FindFirstChild("HumanoidRootPart")
                local h = c:FindFirstChildOfClass("Humanoid")
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
                    if h and h.Health > 0 then
                        h:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end
            end
        end

        local flingThread
        flingThread = task.spawn(function()
            local startTime = tick()
            while self._dropBrainrotActive and (tick() - startTime) < 0.25 do
                RunService.Heartbeat:Wait()
                local c = LP.Character
                if not r then break end
                local vel = r.AssemblyLinearVelocity
                vel = Vector3.new(0, vel.Y, 0)
                r.AssemblyLinearVelocity = vel * 10000 + Vector3.new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if r and r.Parent then
                    r.AssemblyLinearVelocity = vel
                end
                RunService.Stepped:Wait()
                if r and r.Parent then
                    r.AssemblyLinearVelocity = vel + Vector3.new(0, 0.1, 0)
                end
            end
            finishDrop(flingThread)
        end)
        self._dropConnections = self._dropConnections or {}
        table.insert(self._dropConnections, flingThread)
        task.delay(0.35, function()
            if self._dropBrainrotActive then
                finishDrop(flingThread)
            end
        end)
        return
    end

    self._dropBrainrotActive = true
    local t0 = tick()
    if self._dropBrainrotConn then
        pcall(function() self._dropBrainrotConn:Disconnect() end)
        self._dropBrainrotConn = nil
    end
    self._dropBrainrotConn = RunService.Heartbeat:Connect(function()
        local c = LP.Character
        if not r then
            if self._dropBrainrotConn then
                pcall(function() self._dropBrainrotConn:Disconnect() end)
                self._dropBrainrotConn = nil
            end
            self._dropBrainrotActive = false
            return
        end
        if not self._dropBrainrotActive then
            if self._dropBrainrotConn then
                pcall(function() self._dropBrainrotConn:Disconnect() end)
                self._dropBrainrotConn = nil
            end
            return
        end
        if tick() - t0 >= DROP_ASCEND_DURATION then
            if self._dropBrainrotConn then
                pcall(function() self._dropBrainrotConn:Disconnect() end)
                self._dropBrainrotConn = nil
            end
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
                    if hum2 and hum2.Health > 0 then
                        hum2:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end
            end)
            self._dropBrainrotActive = false
            return
        end
        local lv = r.AssemblyLinearVelocity
        r.AssemblyLinearVelocity = Vector3.new(lv.X, DROP_ASCEND_SPEED, lv.Z)
    end)
end

function SpeedSystem:runTPDown()

    if self._tpDownActive then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    self._tpDownActive = true

    pcall(function()
        local _, yaw = root.CFrame:ToEulerAnglesYXZ()

        for _, inst in ipairs(root:GetChildren()) do
            if inst:IsA("LinearVelocity") or inst:IsA("BodyVelocity") or inst:IsA("VectorForce") then
                pcall(function()
                    inst.Enabled = false
                    if inst:IsA("LinearVelocity") and inst.PlaneVelocity ~= nil then
                        inst.PlaneVelocity = Vector2.zero
                    end
                end)
            end
        end
        root.CFrame = CFrame.new(root.Position.X, -7, root.Position.Z) * CFrame.Angles(0, yaw, 0)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        if root.Velocity then root.Velocity = Vector3.zero end
        if root.RotVelocity then root.RotVelocity = Vector3.zero end
    end)

    self._tpDownActive = false
end

function SpeedSystem:_unbindInstantResetCam()
    if self._instantResetCamBound then
        pcall(function()
            RunService:UnbindFromRenderStep("InstaResetCam")
        end)
        self._instantResetCamBound = false
    end
end

function SpeedSystem:_restoreInstantResetCam()
    self:_unbindInstantResetCam()
    pcall(function()
        local cam = workspace.CurrentCamera
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if cam then
            if hum then cam.CameraSubject = hum end
            cam.CameraType = Enum.CameraType.Custom
        end
    end)
end

function SpeedSystem:stopInstantReset()
    self._instantResetStop = true
    self:_unbindInstantResetCam()
    if self._instantResetRespawnConn then
        pcall(function() self._instantResetRespawnConn:Disconnect() end)
        self._instantResetRespawnConn = nil
    end
    self:_restoreInstantResetCam()
    self._instantResetCooldown = false
    self._instantResetStop = false
end

function SpeedSystem:runInstantReset()
    if self._instantResetCooldown then return end
    local character = LP.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    self._instantResetCooldown = true
    self._instantResetStop = false

    pcall(function()
        hrp.AssemblyLinearVelocity = Vector3.new(
            10000000,
    end)

    task.delay(0.5, function()
        self._instantResetCooldown = false
        self._instantResetStop = false
    end)
end

function SpeedSystem:_wireInstaResetOnDeath(char)
    if not char or not self.instaResetOnDeathEnabled then return end
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 2)
    if not hum then return end

    if self._instaResetOnDeathHealthConn then
        pcall(function() self._instaResetOnDeathHealthConn:Disconnect() end)
        self._instaResetOnDeathHealthConn = nil
    end

    local function tryReset()
        if not self.instaResetOnDeathEnabled then return end
        if self._instantResetCooldown then return end
        pcall(function() self:runInstantReset() end)
    end

    self._instaResetOnDeathHealthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not self.instaResetOnDeathEnabled then return end
        if hum.Health <= 0 then tryReset() end
    end)
    hum.Died:Connect(function()
        if not self.instaResetOnDeathEnabled then return end
        tryReset()
    end)
end

function SpeedSystem:startInstaResetOnDeath()
    if self._instaResetOnDeathConn then
        pcall(function() self._instaResetOnDeathConn:Disconnect() end)
        self._instaResetOnDeathConn = nil
    end

    if not self.instaResetOnDeathEnabled then return end

    self:_wireInstaResetOnDeath(LP.Character)
    self._instaResetOnDeathConn = LP.CharacterAdded:Connect(function(char)
        if not self.instaResetOnDeathEnabled then return end
        task.delay(0.12, function()
            if self.instaResetOnDeathEnabled then
                self:_wireInstaResetOnDeath(char)
            end
        end)
    end)
end

function SpeedSystem:stopInstaResetOnDeath()
    self.instaResetOnDeathEnabled = false
    if self._instaResetOnDeathConn then
        pcall(function() self._instaResetOnDeathConn:Disconnect() end)
        self._instaResetOnDeathConn = nil
    end
    if self._instaResetOnDeathHealthConn then
        pcall(function() self._instaResetOnDeathHealthConn:Disconnect() end)
        self._instaResetOnDeathHealthConn = nil
    end
end

function SpeedSystem:setInstaResetOnDeath(on)
    on = on and true or false
    self.instaResetOnDeathEnabled = on
    if on then
        self:startInstaResetOnDeath()
    else
        self:stopInstaResetOnDeath()
    end
end

LP.CharacterAdded:Connect(function()
    if not SpeedSystem._instantResetCooldown then
        SpeedSystem:stopInstantReset()
    end
end)

function SpeedSystem:setAntiRagdoll(on)
    self.antiRagdollEnabled = on
    if on then
        self:startAntiRagdoll()
    else
        self:stopAntiRagdoll()
    end
end

CONFIG_FILE = "NoxaVynx_MainGUI_Config.json"
CONFIG_BACKUP = "NoxaVynx_MainGUI_Config.bak"
CONFIG_VERSION = 2
KEYBINDS_CONFIG_FILE = "NoxaVynx_Keybinds_Config.json"

local NoxaCfg = {
    http = game:GetService("HttpService"),
    extras = {},
    modules = {},
    pending = nil,
    dirty = false,
    loaded = false,
    autoSaveStarted = false,
    _extrasApplied = false,
    pendingMods = nil,

local function _cfgEnv()
    local g = (type(getgenv) == "function" and getgenv()) or _G or {}
    local wf = writefile or g.writefile or (syn and syn.writefile)
    local rf = readfile or g.readfile or (syn and syn.readfile)
    local isf = isfile or g.isfile or (syn and syn.isfile)
    if type(isf) ~= "function" and type(rf) == "function" then
        isf = function(path)
            local ok, res = pcall(rf, path)
            return ok and res ~= nil and res ~= ""
        end
    end
    return wf, rf, isf
end

local function _keyName(key)
    if typeof(key) ~= "EnumItem" then return nil end
    return key.Name
end
local function _keyFrom(name)
    if type(name) ~= "string" or name == "" or name == "None" then return nil end
    local ok, k = pcall(function() return Enum.KeyCode[name] end)
    return (ok and k) or nil
end

local function _posOf(frame)
    if not frame then return nil end
    local p = frame.Position
    return { xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset }
end
local function _applyPos(frame, d)
    if not frame or type(d) ~= "table" or d.xs == nil then return end
    frame.Position = UDim2.new(d.xs, d.xo or 0, d.ys, d.yo or 0)
end

function NoxaCfg.registerModule(name, getTable)
    if type(name) == "string" and type(getTable) == "function" then
        NoxaCfg.modules[name] = getTable
    end
end
_G.NoxaRegisterModule = NoxaCfg.registerModule

NoxaCfg.registerConfigExtra = function(name, getter, setter)
    if type(name) == "string" then
        NoxaCfg.extras[name] = { get = getter, set = setter }
    end
end
_G.NoxaRegisterConfigExtra = NoxaCfg.registerConfigExtra

function NoxaCfg.env() return _cfgEnv() end
function NoxaCfg.canSave()
    local wf = select(1, _cfgEnv())
    return type(wf) == "function"
end
function NoxaCfg.keyToString(key) return _keyName(key) or "None" end
function NoxaCfg.stringToKey(value) return _keyFrom(value) end
NoxaCfg.serialize = function(v) return v end
NoxaCfg.deserialize = function(v) return v end
NoxaCfg.collectTablePublic = function() return nil end
NoxaCfg.applyTablePublic = function(tbl, saved)
    if type(tbl) ~= "table" or type(saved) ~= "table" then return end
    for k, v in pairs(saved) do
        if type(k) == "string" and k:sub(1, 1) ~= "_" then tbl[k] = v end
    end
end
NoxaCfg.reapplyPendingModules = function() end
NoxaCfg.applyExtras = function() end
NoxaCfg.apply = function() end
NoxaCfg.collectKeybinds = function() return {} end
NoxaCfg.applyKeybinds = function() end
function NoxaCfg.shouldBlockInput(inp, gp)
    if gp then return true end
    if _G.NoxaKeyListening then return true end
    return false
end

function NoxaCfg.collect()
    local kb = SpeedSystem.keybinds or {}
    local mods = rawget(_G, "NoxaMods") or NoxaCfg.modules.NoxaMods and (select(1, pcall(NoxaCfg.modules.NoxaMods)))
    if type(mods) ~= "table" then mods = {} end
    local bat = rawget(_G, "BatAimbot") or rawget(_G, "NoxaBatAimbot")
    if type(bat) ~= "table" then bat = {} end

    local cfg = {
        version = CONFIG_VERSION,
        NS = SpeedSystem.NS,
        CS = SpeedSystem.CS,
        LAGGER_NORMAL = SpeedSystem.LAGGER_NORMAL,
        LAGGER_CARRY = SpeedSystem.LAGGER_CARRY,
        speedMethod = SpeedSystem.speedMethod,
        carryActive = SpeedSystem.carryActive == true,
        laggerActive = SpeedSystem.laggerActive == true,

        autoCarryEnabled = SpeedSystem.autoCarryEnabled == true,
        autoStealEnabled = SpeedSystem.autoStealEnabled == true,
        stealMode = SpeedSystem.stealMode,
        stealRadius = SpeedSystem.stealRadius,
        stealDuration = SpeedSystem.stealDuration,
        stealBarStyle = SpeedSystem.stealBarStyle,
        v3BarScale = SpeedSystem.v3BarScale,
        infJumpEnabled = SpeedSystem.infJumpEnabled == true,
        infJumpMode = SpeedSystem.infJumpMode,
        antiRagdollEnabled = SpeedSystem.antiRagdollEnabled == true,
        antiRagdollMode = SpeedSystem.antiRagdollMode,
        autoDodgeEnabled = SpeedSystem.autoDodgeEnabled == true,
        autoTpDownEnabled = SpeedSystem.autoTpDownEnabled == true,
        autoTpDownHeight = SpeedSystem.autoTpDownHeight,
        antiDesyncAimbotEnabled = SpeedSystem.antiDesyncAimbotEnabled == true,
        antiDesyncAutoSwingEnabled = SpeedSystem.antiDesyncAutoSwingEnabled == true,
        tpBatVersion = SpeedSystem.tpBatVersion,
        instaResetOnDeathEnabled = SpeedSystem.instaResetOnDeathEnabled == true,
        removeAccessoriesEnabled = SpeedSystem.removeAccessoriesEnabled == true,
        noPlayerCollisionEnabled = SpeedSystem.noPlayerCollisionEnabled == true,
        safeModeEnabled = SpeedSystem.safeModeEnabled == true,
        antiDieEnabled = SpeedSystem.antiDieEnabled == true,
        bodyLockEnabled = SpeedSystem.bodyLockEnabled == true,
        dropMode = SpeedSystem.dropMode,

        uiScale = SpeedSystem.uiScale,
        uiSkin = SpeedSystem.uiSkin,
        menuOpen = SpeedSystem.menuOpen ~= false,
        tabPos = SpeedSystem.tabPos,
        bgImageIndex = SpeedSystem.bgImageIndex,
        bgImageEnabled = SpeedSystem.bgImageEnabled ~= false,
        bgImageTransparency = SpeedSystem.bgImageTransparency,
        fov = SpeedSystem.fov,
        animPack = SpeedSystem.animPack,
        introEnabled = false,

        key_Carry = _keyName(kb.Carry),
        key_Lagger = _keyName(kb.Lagger),
        key_AutoLeft = _keyName(kb.AutoLeft),
        key_AutoRight = _keyName(kb.AutoRight),
        key_BatAimbot = _keyName(kb.BatAimbot),
        key_TPBat = _keyName(kb.TPBat),
        key_Drop = _keyName(SpeedSystem.dropBrainrotKeybind),
        key_TPDown = _keyName(SpeedSystem.tpDownKeybind),
        key_Reset = _keyName(SpeedSystem.instantResetKeybind),
        key_AutoDodge = _keyName(SpeedSystem.autoDodgeKeybind),

        autoLeft = SpeedSystem.AutoPath and SpeedSystem.AutoPath.leftEnabled == true,
        autoRight = SpeedSystem.AutoPath and SpeedSystem.AutoPath.rightEnabled == true,

        mobileButtons = SpeedSystem.mobileButtons,

        antiLag = mods.antiLagEnabled == true,
        nuke = mods.nukeEnabled == true,
        batCounter = mods.batCounterEnabled == true,
        batCounterMode = mods.batCounterMode,
        medusaCounter = mods.medusaCounterEnabled == true,

        batAimbot = bat.enabled == true,
        batAimbotVersion = bat.version,
        batAimbotSpeed = bat.speed,

        mainPos = (function()
            local ok, f = pcall(function() return rawget(_G, "MainClip") or MainClip end)
            return ok and _posOf(f) or nil
        end)(),
        floatPos = (function()
            local ok, f = pcall(function() return rawget(_G, "FloatOpen") or FloatOpen end)
            return ok and _posOf(f) or nil
        end)(),

    local function packVal(val, depth)
        depth = depth or 0
        local t = typeof(val)
        if t == "boolean" or t == "number" or t == "string" then return val end
        if t == "EnumItem" then return val.Name end
        if t == "UDim2" then
            return { xs = val.X.Scale, xo = val.X.Offset, ys = val.Y.Scale, yo = val.Y.Offset }
        end
        if t == "table" and depth < 3 then
            local out, n = {}, 0
            for k, v in pairs(val) do
                if type(k) == "string" or type(k) == "number" then
                    local pv = packVal(v, depth + 1)
                    if pv ~= nil then out[k] = pv; n = n + 1 end
                end
            end
            return n > 0 and out or nil
        end
        return nil
    end
    for name, def in pairs(NoxaCfg.extras) do
        if def and type(def.get) == "function" then
            local ok, val = pcall(def.get)
            if ok and val ~= nil then
                local packed = packVal(val)
                if packed ~= nil then
                    cfg["x_" .. name] = packed
                end
            end
        end
    end
    return cfg
end

NoxaCfg._writePending = false
NoxaCfg._writing = false
NoxaCfg._lastSaveOk = nil
NoxaCfg._saveToken = 0
NoxaCfg._lastBackupAt = 0

local function _cfgDelfile()
    local g = (type(getgenv) == "function" and getgenv()) or _G or {}
    return delfile or g.delfile or (syn and syn.delfile)
end

NoxaCfg._doWrite = function()
    if NoxaCfg._writing then
        NoxaCfg.dirty = true
        return
    end
    NoxaCfg._writing = true
    NoxaCfg._writePending = false
    NoxaCfg._saveToken = (NoxaCfg._saveToken or 0) + 1
    local token = NoxaCfg._saveToken

    task.spawn(function()
        local success = false
        pcall(function()
            local wf, rf, isf = _cfgEnv()
            if type(wf) ~= "function" then return end

            local cfg = NoxaCfg.collect()
            local enc = NoxaCfg.http:JSONEncode(cfg)
            if type(enc) ~= "string" or #enc < 3 then return end

            local now = os.clock()
            if type(rf) == "function" and (now - (NoxaCfg._lastBackupAt or 0)) > 30 then
                local oldRaw
                pcall(function()
                    local has = true
                    if type(isf) == "function" then has = isf(CONFIG_FILE) end
                    if has then oldRaw = rf(CONFIG_FILE) end
                end)
                if type(oldRaw) == "string" and #oldRaw > 2 then
                    pcall(function() wf(CONFIG_BACKUP, oldRaw) end)
                    NoxaCfg._lastBackupAt = now
                end
            end

            wf(CONFIG_FILE, enc)
            success = true
        end)

        if token == NoxaCfg._saveToken then
            NoxaCfg._lastSaveOk = success
            if success then
                NoxaCfg.dirty = false
            end
            NoxaCfg._writing = false
            if NoxaCfg.dirty and not NoxaCfg._writePending then
                NoxaCfg._writePending = true
                task.delay(0.25, function()
                    NoxaCfg._writePending = false
                    if NoxaCfg.dirty then
                        NoxaCfg._doWrite()
                    end
                end)
            end
        else
            NoxaCfg._writing = false
        end
    end)
end

NoxaCfg.saveConfig = function(force)
    NoxaCfg.dirty = true
    if NoxaCfg._writePending then return true end
    NoxaCfg._writePending = true
    local delaySec = (force == true) and 0.08 or 0.35
    task.delay(delaySec, function()
        NoxaCfg._writePending = false
        if NoxaCfg.dirty then
            NoxaCfg._doWrite()
        end
    end)
    return true
end
_G.NoxaSaveConfig = function() return NoxaCfg.saveConfig(true) end

NoxaCfg.markConfigDirty = function()
    NoxaCfg.dirty = true
    if not NoxaCfg._writePending then
        NoxaCfg.saveConfig(false)
    end
end
_G.NoxaMarkDirty = NoxaCfg.markConfigDirty

NoxaCfg.loadConfig = function()
    if NoxaCfg.loaded then return end
    NoxaCfg.loaded = true
    local wf, rf, isf = _cfgEnv()
    if type(rf) ~= "function" then return end

    local raw = nil
    local function tryRead(path)
        local has = false
        pcall(function()
            if type(isf) == "function" then has = isf(path) else has = true end
        end)
        if not has then return nil end
        local content
        pcall(function() content = rf(path) end)
        if type(content) == "string" and content ~= "" then return content end
        return nil
    end
    raw = tryRead(CONFIG_FILE)
    if not raw then
        raw = tryRead(CONFIG_BACKUP)
        if raw then
            print("leak by https://discord.gg/TBBAUZu8cW")
        end
    end
    if not raw then
        print("leak by https://discord.gg/TBBAUZu8cW")
        return
    end

    local cfg
    local okDecode = pcall(function() cfg = NoxaCfg.http:JSONDecode(raw) end)
    if not okDecode or type(cfg) ~= "table" then
        local df = _cfgDelfile()
        if type(df) == "function" then
            pcall(function() df(CONFIG_FILE) end)
            pcall(function() df(CONFIG_BACKUP) end)
        end
        print("leak by https://discord.gg/TBBAUZu8cW")
        return
    end
    NoxaCfg.pending = cfg

    local numMap = {
        NS = "NS", CS = "CS", LAGGER_NORMAL = "LAGGER_NORMAL", LAGGER_CARRY = "LAGGER_CARRY",
        stealRadius = "stealRadius", stealDuration = "stealDuration", v3BarScale = "v3BarScale",
        autoTpDownHeight = "autoTpDownHeight", uiScale = "uiScale",
        bgImageIndex = "bgImageIndex", bgImageTransparency = "bgImageTransparency", fov = "fov",
        dropMode = "dropMode",
    for src, dst in pairs(numMap) do
        if type(cfg[src]) == "number" then SpeedSystem[dst] = cfg[src] end
    end
    local strMap = {
        speedMethod = true, stealMode = true, stealBarStyle = true, infJumpMode = true,
        antiRagdollMode = true, tpBatVersion = true, uiSkin = true, tabPos = true,
        animPack = true,
    for k in pairs(strMap) do
        if type(cfg[k]) == "string" then SpeedSystem[k] = cfg[k] end
    end
    local boolMap = {
        "carryActive", "laggerActive", "autoCarryEnabled", "autoStealEnabled",
        "infJumpEnabled", "antiRagdollEnabled", "autoDodgeEnabled", "autoTpDownEnabled",
        "antiDesyncAimbotEnabled", "antiDesyncAutoSwingEnabled", "instaResetOnDeathEnabled",
        "removeAccessoriesEnabled", "noPlayerCollisionEnabled", "safeModeEnabled",
        "antiDieEnabled", "bodyLockEnabled", "bgImageEnabled", "menuOpen",
    for _, k in ipairs(boolMap) do
        if cfg[k] ~= nil then SpeedSystem[k] = cfg[k] == true end
    end
    SpeedSystem.introEnabled = false

    local function setKb(id, name)
        local k = _keyFrom(name)
        if k and SpeedSystem.keybinds then SpeedSystem.keybinds[id] = k end
    end
    setKb("Carry", cfg.key_Carry)
    setKb("Lagger", cfg.key_Lagger)
    setKb("AutoLeft", cfg.key_AutoLeft)
    setKb("AutoRight", cfg.key_AutoRight)
    setKb("BatAimbot", cfg.key_BatAimbot)
    setKb("TPBat", cfg.key_TPBat)
        local k = _keyFrom(cfg.key_Drop); if k then SpeedSystem.dropBrainrotKeybind = k end
        k = _keyFrom(cfg.key_TPDown); if k then SpeedSystem.tpDownKeybind = k end
        k = _keyFrom(cfg.key_Reset); if k then SpeedSystem.instantResetKeybind = k end
        k = _keyFrom(cfg.key_AutoDodge); if k then SpeedSystem.autoDodgeKeybind = k end
    end

    if type(cfg.mobileButtons) == "table" and type(SpeedSystem.mobileButtons) == "table" then
        for k, v in pairs(cfg.mobileButtons) do SpeedSystem.mobileButtons[k] = v end
    end
    if SpeedSystem.AutoPath then
        if cfg.autoLeft ~= nil then SpeedSystem.AutoPath.leftEnabled = cfg.autoLeft == true end
        if cfg.autoRight ~= nil then SpeedSystem.AutoPath.rightEnabled = cfg.autoRight == true end
    end

    NoxaCfg.dirty = false
    NoxaCfg._extrasApplied = false
end
_G.NoxaLoadConfig = NoxaCfg.loadConfig

NoxaCfg.reapplyConfigExtras = function()
    if NoxaCfg._extrasApplied then return end
    NoxaCfg._extrasApplied = true
    local cfg = NoxaCfg.pending
    if type(cfg) ~= "table" then return end

    local function unpackVal(val)
        if type(val) == "table" and val.xs ~= nil and val.ys ~= nil and val.xo ~= nil then
            return UDim2.new(val.xs, val.xo or 0, val.ys, val.yo or 0)
        end
        return val
    end

    local mods = rawget(_G, "NoxaMods")
    if type(mods) == "table" then
        local antiLag = cfg.antiLag
        if antiLag == nil and cfg.x_antiLagEnabled ~= nil then antiLag = cfg.x_antiLagEnabled end
        if antiLag ~= nil then
            mods.antiLagEnabled = antiLag == true
            pcall(function() if mods.setAntiLag then mods:setAntiLag(mods.antiLagEnabled) end end)
        end
        local nuke = cfg.nuke
        if nuke == nil and cfg.x_nukeEnabled ~= nil then nuke = cfg.x_nukeEnabled end
        if nuke ~= nil then
            mods.nukeEnabled = nuke == true
            pcall(function() if mods.setNukeOptimizer then mods:setNukeOptimizer(mods.nukeEnabled) end end)
        end
        local bc = cfg.batCounter
        if bc == nil and cfg.x_batCounterEnabled ~= nil then bc = cfg.x_batCounterEnabled end
        if bc ~= nil then mods.batCounterEnabled = bc == true end
        if type(cfg.batCounterMode) == "string" then mods.batCounterMode = cfg.batCounterMode
        elseif type(cfg.x_batCounterMode) == "string" then mods.batCounterMode = cfg.x_batCounterMode end
        if cfg.medusaCounter ~= nil then mods.medusaCounterEnabled = cfg.medusaCounter == true end
    end

    local bat = rawget(_G, "BatAimbot") or rawget(_G, "NoxaBatAimbot")
    if type(bat) == "table" then
        if cfg.batAimbot ~= nil then bat.enabled = cfg.batAimbot == true end
        if type(cfg.batAimbotVersion) == "string" then
            local v = cfg.batAimbotVersion
            if v ~= "V2" and v ~= "V3" then v = "V2" end
            bat.version = v
        end
        if type(cfg.batAimbotSpeed) == "number" then bat.speed = cfg.batAimbotSpeed end
    end

    for name, def in pairs(NoxaCfg.extras) do
        local val = cfg["x_" .. name]
        if val == nil and cfg[name] ~= nil then val = cfg[name] end
        if val ~= nil and def and type(def.set) == "function" then
            pcall(def.set, unpackVal(val))
        end
    end

    task.defer(function()
        task.wait(0.1)
        pcall(function()
            local main = rawget(_G, "MainClip") or MainClip
            local flt = rawget(_G, "FloatOpen") or FloatOpen
            local mp = cfg.mainPos or cfg.x_mainPosition
            local fp = cfg.floatPos or cfg.x_floatPosition
            _applyPos(main, mp)
            _applyPos(flt, fp)
        end)
        pcall(function()
            if type(_G.NoxaMobileApplyHidden) == "function" then _G.NoxaMobileApplyHidden() end
            if type(_G.NoxaMobileApplyStyle) == "function" then _G.NoxaMobileApplyStyle() end
            if type(_G.NoxaMobileApplyLock) == "function" then _G.NoxaMobileApplyLock() end
        end)
    end)
end

NoxaCfg.startAutoSave = function()
    if NoxaCfg.autoSaveStarted then return end
    NoxaCfg.autoSaveStarted = true
    task.spawn(function()
        while true do
            task.wait(12)
            if NoxaCfg.dirty then
                pcall(NoxaCfg._doWrite)
            end
        end
    end)
    pcall(function()
        Players.PlayerRemoving:Connect(function(plr)
            if plr == LP then task.spawn(NoxaCfg._doWrite) end
        end)
    end)
    pcall(function()
        if LP.OnTeleport then
            LP.OnTeleport:Connect(function()
                task.spawn(NoxaCfg._doWrite)
            end)
        end
    end)
end

pcall(NoxaCfg.loadConfig)

for _, n in ipairs({
    "NoxaStealBarGui","NoxaMobileButtons","NoxaEspDraw","NoxaRagdollToast",
    "AutoGrab","K7StealBarGui"
}) do
    local old = PlayerGui:FindFirstChild(n)
    if old then old:Destroy() end
end

pcall(function()
    local cg = game:GetService("CoreGui")
    for _, n in ipairs({"NoxaHub","NoxaStealBarGui","AutoGrab","K7StealBarGui"}) do
        local o = cg:FindFirstChild(n)
        if o then o:Destroy() end
    end
end)

local ACCENT       = Color3.fromRGB( 70, 170, 255)
local FX = {}
FX.A2              = Color3.fromRGB(150, 210, 255)
FX.AD              = Color3.fromRGB( 30, 100, 190)
local BG_MAIN      = Color3.fromRGB(  9,  12,  18)
BG_DARKER    = Color3.fromRGB(  4,   6,  10)
local ROW_BG       = Color3.fromRGB( 16,  22,  32)
local INPUT_BG     = Color3.fromRGB( 12,  18,  26)
local WHITE        = Color3.fromRGB(255, 255, 255)
local TEXT_MAIN    = Color3.fromRGB(240, 248, 255)
local TEXT_DIM     = Color3.fromRGB(125, 145, 165)
TEXT_SECTION = Color3.fromRGB(110, 190, 255)
TOGGLE_OFF   = Color3.fromRGB( 32,  38,  52)
local TOGGLE_ON    = ACCENT
KNOB_OFF     = Color3.fromRGB(200, 210, 225)
KNOB_ON      = Color3.fromRGB(  8,  12,  16)

FX.SEQ = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB( 40, 130, 230)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 190, 255)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB( 40, 130, 230)),

local G = {
    FAST = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    MED  = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    BACK = TweenInfo.new(0.40, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    DK_C = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromRGB( 40, 130, 230)),
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(100, 190, 255)),
        ColorSequenceKeypoint.new(0.65, Color3.fromRGB(100, 190, 255)),
        ColorSequenceKeypoint.new(1,    Color3.fromRGB( 40, 130, 230)),
    DK_T = NumberSequence.new({
        NumberSequenceKeypoint.new(0,    0.42, 0),
        NumberSequenceKeypoint.new(0.35, 0.72, 0),
        NumberSequenceKeypoint.new(0.7,  0.72, 0),
        NumberSequenceKeypoint.new(1,    0.45, 0),
    LT_C = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromRGB(160,200,255)),
        ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(160,200,255)),
        ColorSequenceKeypoint.new(1,    Color3.fromRGB(160,200,255)),

    LT_T = NumberSequence.new({
        NumberSequenceKeypoint.new(0,    0.55, 0),
        NumberSequenceKeypoint.new(0.25, 0.15, 0),
        NumberSequenceKeypoint.new(0.5,  0,    0),
        NumberSequenceKeypoint.new(0.75, 0.15, 0),
        NumberSequenceKeypoint.new(1,    0.55, 0),
    ARROW_GLOW_T = NumberSequence.new({
        NumberSequenceKeypoint.new(0,    0.82, 0),
        NumberSequenceKeypoint.new(0.28, 0.06, 0),
        NumberSequenceKeypoint.new(0.52, 0.22, 0),
        NumberSequenceKeypoint.new(1,    0.82, 0),

local NoxaUI = {}
function NoxaUI.tw(obj, info, props)
    TweenService:Create(obj, info, props):Play()
end

function NoxaUI.new(cls, props)
    local i = Instance.new(cls)
    for k, v in pairs(props) do
        if k ~= "Parent" then i[k] = v end
    end
    if props.Parent then i.Parent = props.Parent end
    return i
end

function NoxaUI.corner(parent, r)

    r = r or 10
    if r >= 99 then
        return NoxaUI.new("UICorner", {CornerRadius = UDim.new(1, 0), Parent = parent})
    end
    return NoxaUI.new("UICorner", {CornerRadius = UDim.new(0, r), Parent = parent})
end

function NoxaUI.darkStroke(parent, thick)

    local s = NoxaUI.new("UIStroke", {
        Color = WHITE, Thickness = 0,
        Transparency = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = parent,
    return s
end

function NoxaUI.lightStroke(parent, thick)

    local s = NoxaUI.new("UIStroke", {
        Color = WHITE, Thickness = 0,
        Transparency = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = parent,
    return s
end

    local shimmerTargets = {}
    local pulseTargets   = {}

    function FX.shimmer(grad, speed)
        table.insert(shimmerTargets, {grad=grad, speed=speed or 26, offset=math.random()*360})
    end

    function FX.pulse(stroke, base, amp, speed)
        table.insert(pulseTargets, {stroke=stroke, base=base or 0.72, amp=amp or 0.16, speed=speed or 2.2})
    end

    local _fxAcc = 0
    if _G._NoxaFxPulseConn then pcall(function() _G._NoxaFxPulseConn:Disconnect() end) end
    _G._NoxaFxPulseConn = _G._NoxaTrackConn(RunService.Heartbeat:Connect(function(dt)
        _fxAcc = _fxAcc + (dt or 0.016)
        if _fxAcc < 0.16 then return end
        _fxAcc = 0
        if MainClip and not MainClip.Visible then return end
        local t = tick()
        for _, d in ipairs(shimmerTargets) do
            if d.grad and d.grad.Parent then
                d.grad.Rotation = (d.offset + t * d.speed) % 360
            end
        end
        for _, d in ipairs(pulseTargets) do
            if d.stroke and d.stroke.Parent then
                d.stroke.Transparency = d.base + math.sin(t * d.speed) * d.amp
            end
        end
    end))

    function FX.shadow(_frame, _spread, _alpha)
        return nil
    end

    function FX.interactive(el, opts)
        opts = opts or {}
        local baseT = opts.baseT or el.BackgroundTransparency
        local hoverT = opts.hoverT or math.max(baseT - 0.14, 0)
        local glow = NoxaUI.new("UIStroke", {
            Name = "HoverGlow", Color = ACCENT, Thickness = 3,
            Transparency = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Parent = el,
        FX.shimmer(NoxaUI.new("UIGradient", {Color = FX.SEQ, Parent = glow}), 40)
        local function enter()
            NoxaUI.tw(el, G.FAST, {BackgroundTransparency = hoverT})
            NoxaUI.tw(glow, G.FAST, {Transparency = 0.55})
        end
        local function leave()
            NoxaUI.tw(el, G.FAST, {BackgroundTransparency = baseT})
            NoxaUI.tw(glow, G.FAST, {Transparency = 1})
        end
        el.MouseEnter:Connect(enter)
        el.MouseLeave:Connect(leave)
        return glow
    end

    function FX.ripple(el)
        el.InputBegan:Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.MouseButton1
            and i.UserInputType ~= Enum.UserInputType.Touch then return end
            local host = el:IsA("GuiObject") and el or el.Parent
            local ring = NoxaUI.new("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0, i.Position.X - host.AbsolutePosition.X,
                                     0, i.Position.Y - host.AbsolutePosition.Y),
                Size = UDim2.new(0, 0, 0, 0),
                BackgroundColor3 = ACCENT, BackgroundTransparency = 0.55,
                BorderSizePixel = 0, ZIndex = 30, Parent = host,
            NoxaUI.new("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ring})
            NoxaUI.tw(ring, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
               {Size = UDim2.new(0, 240, 0, 240), BackgroundTransparency = 1})
            task.delay(0.5, function() ring:Destroy() end)
        end)
    end
end

local ToggleStates = {}

ToggleStates.__cbs = {}
ToggleStates.__on = function(row, fn)
    if not row or not fn then return end
    local t = ToggleStates.__cbs
    t[row] = t[row] or {}
    table.insert(t[row], fn)
end

local AccentRegistry = {}
function NoxaUI.regAccent(inst, prop)
    table.insert(AccentRegistry, {inst=inst, prop=prop or "BackgroundColor3"})
end

THEMES = {
    {name="Noxa Blue",  accent=Color3.fromRGB(70, 170, 255), a2=Color3.fromRGB(140,190,255), ad=Color3.fromRGB(40,90,170)},
    {name="Noxa Ice",   accent=Color3.fromRGB(100,180,255), a2=Color3.fromRGB(180,220,255), ad=Color3.fromRGB(50,110,180)},
    {name="Noxa Night", accent=Color3.fromRGB(50,100,200), a2=Color3.fromRGB(110,160,240), ad=Color3.fromRGB(25,60,140)},

function NoxaUI.mixC(a, b, t) return a:Lerp(b, t) end
function NoxaUI.lighten(c, t) return NoxaUI.mixC(c, Color3.fromRGB(255,255,255), t) end
function NoxaUI.darken(c, t)  return NoxaUI.mixC(c, Color3.fromRGB(0,0,0), t) end

function NoxaUI.ckey(c)
    return string.format("%d,%d,%d",
        math.floor(c.R*255+0.5), math.floor(c.G*255+0.5), math.floor(c.B*255+0.5))
end

local ROLE = {}
function NoxaUI.role(baseRGB, fn) ROLE[NoxaUI.ckey(Color3.fromRGB(unpack(baseRGB)))] = fn end
NoxaUI.role({ 80,180,255}, function(t) return t.accent end)
NoxaUI.role({100,200,255}, function(t) return t.a2 end)
NoxaUI.role({ 80,180,255}, function(t) return t.ad end)
NoxaUI.role({158,226,206}, function(t) return NoxaUI.lighten(t.accent, 0.45) end)
NoxaUI.role({150,235,205}, function(t) return NoxaUI.lighten(t.accent, 0.35) end)
NoxaUI.role({160,255,224}, function(t) return NoxaUI.lighten(t.accent, 0.40) end)
NoxaUI.role({178,255,228}, function(t) return NoxaUI.lighten(t.accent, 0.45) end)
NoxaUI.role({ 70,225,175}, function(t) return t.accent end)
NoxaUI.role({ 70,190,160}, function(t) return NoxaUI.darken(t.accent, 0.25) end)
NoxaUI.role({168,230,255}, function(t) return NoxaUI.lighten(t.a2, 0.35) end)
NoxaUI.role({160,220,255}, function(t) return NoxaUI.lighten(t.a2, 0.35) end)
NoxaUI.role({ 78,168,205}, function(t) return NoxaUI.darken(t.a2, 0.30) end)
NoxaUI.role({ 90,190,255}, function(t) return t.a2 end)
NoxaUI.role({ 16, 54, 47}, function(t) return NoxaUI.darken(t.ad, 0.55) end)
NoxaUI.role({ 12, 38, 52}, function(t) return NoxaUI.darken(t.a2, 0.78) end)
NoxaUI.role({  8, 46, 40}, function(t) return NoxaUI.darken(t.accent, 0.85) end)
NoxaUI.role({  8, 34, 56}, function(t) return NoxaUI.darken(t.a2, 0.85) end)
NoxaUI.role({140,190,180}, function(t) return NoxaUI.lighten(NoxaUI.darken(t.accent, 0.35), 0.45) end)

PROPS = {"BackgroundColor3","TextColor3","ImageColor3","Color","ScrollBarImageColor3"}
_orig = setmetatable({}, {__mode="k"})

function NoxaUI.remap(inst, prop, t)
    local ok, cur = pcall(function() return inst[prop] end)
    if not ok or cur == nil then return end
    local store = _orig[inst]
    if not store then store = {}; _orig[inst] = store end

    if typeof(cur) == "Color3" then
        local base = store[prop] or cur
        store[prop] = base
        local fn = ROLE[NoxaUI.ckey(base)]
        if fn then pcall(function() inst[prop] = fn(t) end) end
    elseif typeof(cur) == "ColorSequence" then
        local base = store[prop] or cur
        store[prop] = base
        local kps, changed = {}, false
        for _, kp in ipairs(base.Keypoints) do
            local fn = ROLE[NoxaUI.ckey(kp.Value)]
            if fn then changed = true end
            table.insert(kps, ColorSequenceKeypoint.new(kp.Time, fn and fn(t) or kp.Value))
        end
        if changed then pcall(function() inst[prop] = ColorSequence.new(kps) end) end
    end
end

CurrentTheme = THEMES[1]

ORIG_BLUES = {
    Color3.fromRGB( 55, 130, 210),
    Color3.fromRGB( 80, 180, 255),
    Color3.fromRGB( 80, 160, 230),
    Color3.fromRGB( 45, 110, 185),
    Color3.fromRGB(100, 180, 255),
    Color3.fromRGB(120, 200, 255),
    Color3.fromRGB( 70, 150, 220),
    Color3.fromRGB( 60, 140, 215),
    Color3.fromRGB( 90, 170, 240),
    Color3.fromRGB( 40, 100, 180),
    Color3.fromRGB(255, 105, 180),
    Color3.fromRGB(230,  60,  60),
    Color3.fromRGB(160,  90, 255),
    Color3.fromRGB(255, 220,  50),
    Color3.fromRGB(255, 140,  40),

local function colorDist(a, b)
    local dr, dg, db = a.R - b.R, a.G - b.G, a.B - b.B
    return dr*dr + dg*dg + db*db
end

local function isOrigBlue(c)
    if typeof(c) ~= "Color3" then return false end

    for _, b in ipairs(ORIG_BLUES) do
        if colorDist(c, b) < 0.018 then return true end
    end
    return false
end

local function mapBlueToAccent(c, t)
    local prev = _G.NoxaPrevAccent
    local matched = isOrigBlue(c)
    if not matched and prev then
        for _, b in ipairs({prev.accent, prev.a2, prev.ad}) do
            if typeof(b) == "Color3" and colorDist(c, b) < 0.02 then
                matched = true
                break
            end
        end
    end
    if not matched then return nil end
    local lum = c.R * 0.3 + c.G * 0.5 + c.B * 0.2
    if lum > 0.72 then return t.a2 end
    if lum < 0.42 then return t.ad end
    return t.accent
end

local function recolorInstance(inst, t)
    for _, prop in ipairs(PROPS) do
        local ok, val = pcall(function() return inst[prop] end)
        if not ok or val == nil then

        elseif typeof(val) == "Color3" then
            local mapped = mapBlueToAccent(val, t)
            if mapped then pcall(function() inst[prop] = mapped end) end
        elseif typeof(val) == "ColorSequence" then
            local kps, changed = {}, false
            for _, kp in ipairs(val.Keypoints) do
                local mapped = mapBlueToAccent(kp.Value, t)
                if mapped then
                    changed = true
                    table.insert(kps, ColorSequenceKeypoint.new(kp.Time, mapped))
                else
                    table.insert(kps, kp)
                end
            end
            if changed then pcall(function() inst[prop] = ColorSequence.new(kps) end) end
        end
    end
end

local function recolorTree(root, t)
    if not root then return end
    recolorInstance(root, t)
    for _, d in ipairs(root:GetDescendants()) do
        recolorInstance(d, t)
    end
end

function NoxaUI.applyTheme(t)
    _G.NoxaPrevAccent = {
        accent = ACCENT,
        a2 = FX.A2,
        ad = FX.AD,
    CurrentTheme = t
    ACCENT       = t.accent
    FX.A2        = t.a2
    FX.AD        = t.ad
    TOGGLE_ON    = t.accent
    TEXT_SECTION = NoxaUI.lighten(t.accent, 0.45)
    FX.SEQ = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   t.ad),
        ColorSequenceKeypoint.new(0.5, t.accent),
        ColorSequenceKeypoint.new(1,   t.a2),

    if G then
        G.DK_C = ColorSequence.new({
            ColorSequenceKeypoint.new(0, t.ad),
            ColorSequenceKeypoint.new(0.35, t.accent),
            ColorSequenceKeypoint.new(0.65, t.accent),
            ColorSequenceKeypoint.new(1, t.a2),
        G.LT_C = ColorSequence.new({
            ColorSequenceKeypoint.new(0, t.a2),
            ColorSequenceKeypoint.new(0.5, t.accent),
            ColorSequenceKeypoint.new(1, t.a2),
    end

    _G._NoxaThemeGen = (_G._NoxaThemeGen or 0) + 1
    local themeGen = _G._NoxaThemeGen
    local themeRef = t
    task.spawn(function()
        local roots = {}
        local hub = PlayerGui:FindFirstChild("NoxaHub")
        if hub then table.insert(roots, hub) end
        local mobile = PlayerGui:FindFirstChild("NoxaMobileButtons")
        if mobile then table.insert(roots, mobile) end
        local stealGui = PlayerGui:FindFirstChild("NoxaStealBarGui")
        if stealGui then table.insert(roots, stealGui) end
        if stealProgressBar and stealProgressBar.Parent then
            table.insert(roots, stealProgressBar)
        end
        for _, root in ipairs(roots) do
            if _G._NoxaThemeGen ~= themeGen then return end
            local descs = root:GetDescendants()
            for _, d in ipairs(descs) do
                if _G._NoxaThemeGen ~= themeGen then return end
                for _, prop in ipairs(PROPS) do
                    pcall(NoxaUI.remap, d, prop, themeRef)
                end
                recolorInstance(d, themeRef)
                n = n + 1
                if n % 180 == 0 then task.wait() end
            end
            recolorInstance(root, themeRef)
        end
    end)

    for i = #AccentRegistry, 1, -1 do
        local e = AccentRegistry[i]
        if not e.inst or not e.inst.Parent then
            table.remove(AccentRegistry, i)
        else
            pcall(function() e.inst[e.prop] = ACCENT end)
        end
    end

    for _, entry in ipairs(AllToggleTracks or {}) do
        local track = entry.track
        if track and track.Parent then
            local on = ToggleStates[entry.rowRef] == true
            if on then
                pcall(function()
                    track.BackgroundColor3 = ACCENT
                    local glow = track:FindFirstChild("Glow")
                    if glow and glow:IsA("UIStroke") then glow.Color = ACCENT end
                end)
            end
        end
    end

    pcall(function()
        local bb = _G.NoxaBillboard
        if bb then
            if bb.dc then bb.dc.TextColor3 = ACCENT end
            if bb.speed then bb.speed.TextColor3 = ACCENT end
            if bb.ul then bb.ul.BackgroundColor3 = ACCENT end
            if bb.rag and bb.rag.TextColor3 ~= Color3.fromRGB(255, 120, 120) then
                bb.rag.TextColor3 = ACCENT
            end
        end
    end)

    pcall(function()
        local esp = rawget(_G, "NoxaESP") or NoxaESP
        if esp then
            esp.boxColor = ACCENT
            esp.tracerColor = (FX and FX.A2) or ACCENT
            if type(esp.applyAccentColors) == "function" then
                esp:applyAccentColors(ACCENT, esp.tracerColor)
            end
        end
    end)

    pcall(function()
        if SpeedSystem and not SpeedSystem.introColorLocked then
            SpeedSystem.introColor = ACCENT
        end
    end)

    pcall(function()
        if _G.NoxaUpdateHeaderTitleAccent then
            _G.NoxaUpdateHeaderTitleAccent(ACCENT)
        end
    end)

    pcall(function()
        local refs = _G.NoxaMobileRefs
        if type(refs) ~= "table" then return end
        local onCol = ACCENT
        for _, e in pairs(refs) do
            if e.btn then
                local st = e.btn:FindFirstChildOfClass("UIStroke")

                local isOn = false
                if st and st.Transparency < 0.2 then isOn = true end
                local bg = e.btn.BackgroundColor3
                if bg and (bg.R + bg.G + bg.B) > 0.35 then isOn = true end
                if isOn then
                    e.btn.BackgroundColor3 = onCol
                    if st then st.Color = onCol; st.Transparency = 0.05 end
                elseif st and isOrigBlue(st.Color) then
                    st.Color = onCol
                end
            end
        end
    end)

    pcall(function()
        if type(_G.NoxaRefreshStealBarAccent) == "function" then
            _G.NoxaRefreshStealBarAccent(ACCENT)
        else
            if stealProgressFill then
                stealProgressFill.BackgroundColor3 = ACCENT
                local g = stealProgressFill:FindFirstChildOfClass("UIGradient")
                    g.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, FX.AD or ACCENT),
                        ColorSequenceKeypoint.new(0.55, ACCENT),
                        ColorSequenceKeypoint.new(1, FX.A2 or ACCENT),
                end
            end
            if pbStroke then pbStroke.Color = ACCENT end
            if stealProgressBar then
                local chip = stealProgressBar:FindFirstChild("NoxaV3ModeChip")
                if chip then chip.BackgroundColor3 = ACCENT end
                local st = stealProgressBar:FindFirstChildOfClass("UIStroke")
                if st then st.Color = ACCENT end
            end
            local v3 = _G._NoxaStealV3
            if v3 and v3.fill then
                v3.fill.BackgroundColor3 = ACCENT
            end
        end
    end)
end

function _G.NoxaRefreshStealBarAccent(col)
    col = col or (typeof(ACCENT) == "Color3" and ACCENT) or Color3.fromRGB(70, 170, 255)
    local r, g, b = col.R, col.G, col.B
    local dark = Color3.new(r * 0.35, g * 0.35, b * 0.4)
    local mid = Color3.new(math.clamp(r * 0.55, 0, 1), math.clamp(g * 0.55, 0, 1), math.clamp(b * 0.6, 0, 1))
    local light = Color3.new(math.clamp(r * 1.1, 0, 1), math.clamp(g * 1.1, 0, 1), math.clamp(b * 1.05, 0, 1))
    local frameBg = Color3.new(r * 0.08, g * 0.12, b * 0.2)
    local trackBg = Color3.new(r * 0.25, g * 0.3, b * 0.4)

    local function paintGui(gui)
        if not gui then return end
        for _, d in ipairs(gui:GetDescendants()) do
            pcall(function()
                if d:IsA("UIStroke") then
                    d.Color = col
                elseif d:IsA("Frame") then
                    if d.Name == "ProgressFill" or d.Name == "SideAccent" or d.Name == "Dot" then
                        d.BackgroundColor3 = col
                        local fg = d:FindFirstChildOfClass("UIGradient")
                        if fg and d.Name == "ProgressFill" then
                            fg.Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0, dark),
                                ColorSequenceKeypoint.new(0.3, col),
                                ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 255, 255)),
                                ColorSequenceKeypoint.new(0.82, col),
                                ColorSequenceKeypoint.new(1, dark),
                        end
                    elseif d.Name == "Track" then
                        d.BackgroundColor3 = trackBg
                    elseif d.Name == "StealBarFrame" then
                        d.BackgroundColor3 = frameBg
                        local bg = d:FindFirstChildOfClass("UIGradient")
                        if bg then
                            bg.Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0, mid),
                                ColorSequenceKeypoint.new(0.55, frameBg),
                                ColorSequenceKeypoint.new(1, Color3.new(r*0.04, g*0.06, b*0.1)),
                        end
                    elseif d.Size.X.Offset <= 3 and d.Size.Y.Offset >= 16 then
                        d.BackgroundColor3 = col
                    end
                elseif d:IsA("TextLabel") then
                    local n = d.Name or ""
                    local t = (d.Text or ""):upper()
                    if n == "PctLbl" or n == "ProgressPct" or t:find("%%") then
                        d.TextColor3 = col
                    elseif n == "PerfLbl" or t:find("FPS") or t:find("MS") then
                        d.TextColor3 = light
                    elseif n == "StateLbl" or t == "OFF" or t == "IDLE" or t == "STEALING" or t == "HOLD" then
                        d.TextColor3 = light
                    elseif t:find("AUTO") or t:find("STEAL") then
                        d.TextColor3 = Color3.fromRGB(255, 255, 255)
                    end
                end
            end)
        end

        local fr = gui:FindFirstChild("StealBarFrame", true)
        if fr then
            local st = fr:FindFirstChildOfClass("UIStroke")
            if st then st.Color = col end
        end
    end

    pcall(function()
        local rb = _G._NoxaRitualBar
        if rb then
            if rb.stroke then rb.stroke.Color = col end
            if rb.side then rb.side.BackgroundColor3 = col end
            if rb.dot then rb.dot.BackgroundColor3 = col end
            if rb.fill then
                rb.fill.BackgroundColor3 = col
                local fg = rb.fill:FindFirstChildOfClass("UIGradient")
                if fg then
                    fg.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, dark),
                        ColorSequenceKeypoint.new(0.3, col),
                        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(0.82, col),
                        ColorSequenceKeypoint.new(1, dark),
                end
            end
            if rb.pct then rb.pct.TextColor3 = col end
            if rb.perf then rb.perf.TextColor3 = light end
            if rb.state then rb.state.TextColor3 = light end
            if rb.track then rb.track.BackgroundColor3 = trackBg end
            if rb.frame then
                rb.frame.BackgroundColor3 = frameBg
                if rb.bgGrad then
                    rb.bgGrad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, mid),
                        ColorSequenceKeypoint.new(0.55, frameBg),
                        ColorSequenceKeypoint.new(1, Color3.new(r*0.04, g*0.06, b*0.1)),
                end
            end
            if rb.gui then paintGui(rb.gui) end
        end
    end)

    pcall(function()
        local parents = { PlayerGui }
        pcall(function() table.insert(parents, game:GetService("CoreGui")) end)
        pcall(function() if Gui then table.insert(parents, Gui) end end)
        for _, parent in ipairs(parents) do
            if parent then
                local gui = parent:FindFirstChild("NoxaRitualStealBar")
                if gui then paintGui(gui) end
                local gui2 = parent:FindFirstChild("NoxaStealBarGui")
                if gui2 then paintGui(gui2) end
            end
        end
    end)

    pcall(function()
        if stealProgressFill then
            stealProgressFill.BackgroundColor3 = col
            local g = stealProgressFill:FindFirstChildOfClass("UIGradient")
                g.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, dark),
                    ColorSequenceKeypoint.new(0.55, col),
                    ColorSequenceKeypoint.new(1, light),
            end
        end
        if pbStroke then pbStroke.Color = col end
        if stealProgressBar then
            local st = stealProgressBar:FindFirstChildOfClass("UIStroke")
            if st then st.Color = col end
            local chip = stealProgressBar:FindFirstChild("NoxaV3ModeChip")
            if chip then chip.BackgroundColor3 = col end
        end
        local v3 = _G._NoxaStealV3
            if v3.fill then v3.fill.BackgroundColor3 = col end
            if v3.modeChip then v3.modeChip.BackgroundColor3 = col end
            if v3.pct then v3.pct.TextColor3 = col end
            if v3.fps then v3.fps.TextColor3 = light end
            if v3.ping then v3.ping.TextColor3 = light end
        end
    end)
end

function NoxaUI.applyAccentAll(newColor)
    NoxaUI.applyTheme({
        name = "Custom",
        accent = newColor,
        a2 = NoxaUI.lighten(newColor, 0.35),
        ad = NoxaUI.darken(newColor, 0.45),
end

function NoxaUI.applyAccentLight(newColor)
    if typeof(newColor) ~= "Color3" then return end
    ACCENT = newColor
    FX.A2 = NoxaUI.lighten(newColor, 0.35)
    FX.AD = NoxaUI.darken(newColor, 0.45)
    TOGGLE_ON = newColor
    TEXT_SECTION = NoxaUI.lighten(newColor, 0.45)
    FX.SEQ = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   FX.AD),
        ColorSequenceKeypoint.new(0.5, ACCENT),
        ColorSequenceKeypoint.new(1,   FX.A2),
    if G then
        G.DK_C = ColorSequence.new({
            ColorSequenceKeypoint.new(0, FX.AD),
            ColorSequenceKeypoint.new(0.35, ACCENT),
            ColorSequenceKeypoint.new(0.65, ACCENT),
            ColorSequenceKeypoint.new(1, FX.A2),
        G.LT_C = ColorSequence.new({
            ColorSequenceKeypoint.new(0, FX.A2),
            ColorSequenceKeypoint.new(0.5, ACCENT),
            ColorSequenceKeypoint.new(1, FX.A2),
    end
    for i = #AccentRegistry, 1, -1 do
        local e = AccentRegistry[i]
        if not e.inst or not e.inst.Parent then
            table.remove(AccentRegistry, i)
        else
            pcall(function() e.inst[e.prop] = ACCENT end)
        end
    end
    pcall(function()
        if mainStroke then mainStroke.Color = ACCENT end
        if mainStrokeGrad then
            mainStrokeGrad.Color = FX.SEQ
        end
        if HeaderTitle then HeaderTitle.TextColor3 = ACCENT end
        if FloatTitle then FloatTitle.TextColor3 = ACCENT end
    end)
    pcall(function()
        local bb = _G.NoxaBillboard
        if bb then
            if bb.dc then bb.dc.TextColor3 = ACCENT end
            if bb.speed then bb.speed.TextColor3 = ACCENT end
            if bb.ul then bb.ul.BackgroundColor3 = ACCENT end
        end
    end)
end

NoxaCfg.registerConfigExtra("theme",
    function() return CurrentTheme and CurrentTheme.name end,
    function(name)
        if type(name) ~= "string" then return end
        for _, th in ipairs(THEMES) do
            if th.name == name then NoxaUI.applyTheme(th) return end
        end
    end)

AllToggleTracks = {}

function NoxaUI.setToggleVisual(track, knob, state)
    NoxaUI.tw(track, G.FAST, {
        BackgroundColor3       = state and TOGGLE_ON or TOGGLE_OFF,
        BackgroundTransparency = state and 0 or 0.15,
    local glow = track:FindFirstChild("Glow")
    if glow then
        NoxaUI.tw(glow, G.FAST, {Transparency = state and 0.45 or 1, Thickness = state and 2 or 0})
        glow:SetAttribute("On", state and true or false)
    end
    NoxaUI.tw(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position         = state and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,3,0.5,-7),
        BackgroundColor3 = state and KNOB_ON or KNOB_OFF,
end

function NoxaUI.mkSection(parent, text)
    local r = NoxaUI.new("Frame", {
        Size = UDim2.new(1, -2, 0, 30),
        BackgroundTransparency = 1, Parent = parent,
    local chip = NoxaUI.new("Frame", {
        Position = UDim2.new(0, 0, 0.5, -11),
        Size = UDim2.new(0, 0, 0, 22),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = ACCENT,
        BackgroundTransparency = 0.82,
        BorderSizePixel = 0, Parent = r,
    NoxaUI.corner(chip, 8)
    local st = NoxaUI.new("UIStroke", {
        Color = ACCENT, Thickness = 1, Transparency = 0.55,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = chip,
    NoxaUI.regAccent(st)
    NoxaUI.new("UIPadding", {
        PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 2),
        Parent = chip,
    local lbl = NoxaUI.new("TextLabel", {
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = string.upper(tostring(text or "")),
        TextColor3 = ACCENT, TextSize = 10,
        Font = Enum.Font.GothamBlack, RichText = true,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = chip,
    NoxaUI.regAccent(lbl)
    local line = NoxaUI.new("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = ACCENT, BackgroundTransparency = 0.92,
        BorderSizePixel = 0, ZIndex = 0, Parent = r,
    return r
end

function NoxaUI.mkRow(parent, h)
    local r = NoxaUI.new("Frame", {
        Size = UDim2.new(1, -2, 0, h or 40),
        BackgroundColor3 = Color3.fromRGB(14, 20, 30),
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0, Parent = parent,
    NoxaUI.corner(r, 12)
    local edge = NoxaUI.new("UIStroke", {
        Color = Color3.fromRGB(50, 90, 140),
        Thickness = 1,
        Transparency = 0.6,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = r,
    local rail = NoxaUI.new("Frame", {
        Name = "RowRail",
        Size = UDim2.new(0, 3, 1, -12),
        Position = UDim2.new(0, 5, 0, 6),
        BackgroundColor3 = ACCENT,
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0, ZIndex = 3, Parent = r,
    NoxaUI.corner(rail, 2)
    NoxaUI.regAccent(rail)
    NoxaUI.new("UIGradient", {Color = FX.SEQ, Rotation = 90, Parent = rail})
    FX.interactive(r, {baseT = 0.1, hoverT = 0.02})
    return r
end

function NoxaUI.mkLabel(parent, text, fs)
    return NoxaUI.new("TextLabel", {
        ZIndex = 4, Position = UDim2.new(0, 16, 0, 0),
        Size = UDim2.new(1, -148, 1, 0),
        BackgroundTransparency = 1, Text = text,
        TextColor3 = TEXT_MAIN, TextSize = fs or 12,
        Font = Enum.Font.GothamBold,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = parent,
end

function NoxaUI.mkToggle(parent, label, startOn, hasArrow)
    local r = NoxaUI.mkRow(parent, 34)
    local displayLabel = label
    local keyBadge = nil
    local extracted = label:match("%[(.-)%]")
    if extracted then
        displayLabel = label:gsub("%s*%[.-%]", ""):match("^%s*(.-)%s*$")
        keyBadge = extracted
    end
    NoxaUI.mkLabel(r, displayLabel)

    local area = NoxaUI.new("TextButton", {
        Name = "ToggleArea", Position = UDim2.new(1, -54, 0, 0),
        Size = UDim2.new(0, 54, 1, 0),
        BackgroundTransparency = 1, Text = "",
        AutoButtonColor = false, ZIndex = 10, Parent = r,
    local track = NoxaUI.new("Frame", {
        Position = UDim2.new(0.5, -17, 0.5, -9), Size = UDim2.new(0, 34, 0, 18),
        BackgroundColor3 = startOn and TOGGLE_ON or TOGGLE_OFF,
        BackgroundTransparency = startOn and 0 or 0.15,
        BorderSizePixel = 0, ZIndex = 5, Parent = area,
    NoxaUI.corner(track, 10); NoxaUI.darkStroke(track, 1)
    NoxaUI.new("UIGradient", {Color = FX.SEQ, Rotation = 0, Parent = track})
    local tglow = NoxaUI.new("UIStroke", {Name = "Glow", Color = ACCENT, Thickness = 0,
        Transparency = 1, Parent = track})
    if startOn then NoxaUI.regAccent(track) end
    table.insert(AllToggleTracks, {track=track, rowRef=r})
    local knob = NoxaUI.new("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = startOn and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,3,0.5,-7),
        BackgroundColor3 = startOn and KNOB_ON or KNOB_OFF,
        BorderSizePixel = 0, ZIndex = 6, Parent = track,
    NoxaUI.corner(knob, 7)
    local shine = NoxaUI.new("Frame", {
        Position = UDim2.new(0, 2, 0, 2), Size = UDim2.new(1, -4, 0, 4),
        BackgroundColor3 = WHITE, BackgroundTransparency = 0.72,
        BorderSizePixel = 0, ZIndex = 7, Parent = knob,
    NoxaUI.corner(shine, 4)
    local click = NoxaUI.new("TextButton", {
        Name = "ToggleClick", ZIndex = 100,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, Text = "",
        AutoButtonColor = false, Parent = area,

    FX.ripple(click)
    ToggleStates[r] = startOn or false
    click.MouseButton1Click:Connect(function()
        ToggleStates[r] = not ToggleStates[r]
        NoxaUI.setToggleVisual(track, knob, ToggleStates[r])
        local state = ToggleStates[r]
        local cbs = ToggleStates.__cbs[r]
        if cbs then
            for _, cb in ipairs(cbs) do
                pcall(cb, state)
            end
        end
        NoxaCfg.saveConfig()
    end)

    if keyBadge then
        local bindName = nil
        if label:match("Speed Key") or label:match("Carry") then bindName = "Carry"
        elseif label:match("Lagger") then bindName = "Lagger"
        elseif label:match("Auto Left") then bindName = "AutoLeft"
        elseif label:match("Auto Right") then bindName = "AutoRight"
        elseif label:match("Bat Aimbot") then bindName = "BatAimbot"
        elseif label:match("TP Bat") then bindName = "TPBat"
        end
        if bindName and SpeedSystem.keybinds[bindName] then
            keyBadge = SpeedSystem.keybinds[bindName].Name
        end
        local kbOffset = hasArrow and -116 or -62
        local kbBadge = NoxaUI.new("TextButton", {
            ZIndex=20,
            Position=UDim2.new(1, kbOffset - 56, 0.5, -13),
            Size=UDim2.new(0,52,0,26),
            BackgroundColor3=ACCENT,
            BackgroundTransparency=0.72,
            BorderSizePixel=0, Text=keyBadge,
            TextColor3=ACCENT, TextSize=11,
            Font=Enum.Font.GothamBlack,
            AutoButtonColor=false, Parent=r,
        NoxaUI.corner(kbBadge, 13)
        NoxaUI.regAccent(kbBadge)
            local ks = Instance.new("UIStroke")
            ks.Color = ACCENT
            ks.Thickness = 1
            ks.Transparency = 0.2
            ks.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            ks.Parent = kbBadge
            NoxaUI.regAccent(ks)
        end

        local listening = false
        kbBadge.MouseButton1Click:Connect(function()
            if listening then return end
            listening = true
            _G.NoxaKeyListening = true
            kbBadge.Text = "..."
            local c; c = UserInputService.InputBegan:Connect(function(inp, gp)
                local t = inp.UserInputType
                local okPad = (t == Enum.UserInputType.Gamepad1 or t == Enum.UserInputType.Gamepad2
                    or t == Enum.UserInputType.Gamepad3 or t == Enum.UserInputType.Gamepad4)
                if t ~= Enum.UserInputType.Keyboard and not okPad then return end
                if inp.KeyCode == Enum.KeyCode.Unknown then return end
                local bindName = nil
                if label:match("Carry") then bindName = "Carry"
                elseif label:match("Lagger") then bindName = "Lagger"
                elseif label:match("Auto Left") then bindName = "AutoLeft"
                elseif label:match("Auto Right") then bindName = "AutoRight"
                elseif label:match("Bat Aimbot") then bindName = "BatAimbot"
                elseif label:match("TP Bat") then bindName = "TPBat"
                end
                if bindName then

                    local kc = inp.KeyCode
                    for id, key in pairs(SpeedSystem.keybinds or {}) do
                        if id ~= bindName and key == kc then
                            SpeedSystem.keybinds[id] = Enum.KeyCode.Unknown
                        end
                    end
                    for _, id in ipairs({"dropBrainrotKeybind","tpDownKeybind","instantResetKeybind","autoDodgeKeybind"}) do
                        if SpeedSystem[id] == kc then
                            SpeedSystem[id] = Enum.KeyCode.Unknown
                        end
                    end
                    SpeedSystem.keybinds[bindName] = kc
                    kbBadge.Text = kc.Name
                end
                listening = false
                _G.NoxaKeyListening = false
                c:Disconnect()
                NoxaCfg.saveConfig()
            end)
        end)
    end

    if hasArrow then
        local arrow = NoxaUI.new("TextButton", {
            Name = "ArrowButton", ZIndex = 5,
            Position = UDim2.new(1, -108, 0.5, -13),
            Size = UDim2.new(0, 38, 0, 26),
            BackgroundColor3 = INPUT_BG, BackgroundTransparency = 0.18,
            Text = "▼", TextColor3 = WHITE,
            TextSize = 18, Font = Enum.Font.GothamBlack,
            AutoButtonColor = false, Parent = r,
        NoxaUI.corner(arrow, 7)
        local ab = NoxaUI.new("UIStroke", {Color=WHITE, Thickness=1.8,
            ApplyStrokeMode=Enum.ApplyStrokeMode.Border, Transparency=0.05, Parent=arrow})
        NoxaUI.new("UIGradient", {Rotation=135, Transparency=G.ARROW_GLOW_T, Parent=ab})
        local glw = NoxaUI.new("UIStroke", {Color=WHITE, Thickness=3.6,
            ApplyStrokeMode=Enum.ApplyStrokeMode.Border, Transparency=0.58, Parent=arrow})
        NoxaUI.new("UIGradient", {Rotation=180, Transparency=G.ARROW_GLOW_T, Parent=glw})
        return r, arrow
    end
    return r, nil
end

function NoxaUI.mkExpandable(parent, opt1, opt2)
    local r = NoxaUI.new("Frame", {
        Size = UDim2.new(1, -4, 0, 0),
        BackgroundColor3 = ROW_BG, BackgroundTransparency = 0.42,
        BorderSizePixel = 0, Visible = false,
        ClipsDescendants = true, Parent = parent,
    NoxaUI.corner(r, 10); NoxaUI.darkStroke(r, 1.2)
    local hl = NoxaUI.new("Frame", {
        ZIndex = 4, Position = UDim2.new(0, 4, 0, 4),
        Size = UDim2.new(0.5, -4, 1, -8),
        BackgroundColor3 = WHITE, BackgroundTransparency = 0.84,
        BorderSizePixel = 0, Parent = r,
    NoxaUI.corner(hl); NoxaUI.lightStroke(hl, 1)
    local b1 = NoxaUI.new("TextButton", {
        ZIndex=5, Size=UDim2.new(0.5,0,1,0), BackgroundTransparency=1,
        Text=opt1, TextColor3=TEXT_MAIN, TextSize=12,
        Font=Enum.Font.GothamMedium, AutoButtonColor=false, Parent=r,
    local b2 = NoxaUI.new("TextButton", {
        ZIndex=5, Position=UDim2.new(0.5,0,0,0), Size=UDim2.new(0.5,0,1,0),
        BackgroundTransparency=1, Text=opt2, TextColor3=TEXT_DIM,
        TextSize=12, Font=Enum.Font.GothamMedium, AutoButtonColor=false, Parent=r,
    b1.MouseButton1Click:Connect(function()
        NoxaUI.tw(hl, G.FAST, {Position=UDim2.new(0,4,0,4), Size=UDim2.new(0.5,-4,1,-8)})
        b1.TextColor3=TEXT_MAIN; b2.TextColor3=TEXT_DIM
    end)
    b2.MouseButton1Click:Connect(function()
        NoxaUI.tw(hl, G.FAST, {Position=UDim2.new(0.5,0,0,4), Size=UDim2.new(0.5,-4,1,-8)})
        b2.TextColor3=TEXT_MAIN; b1.TextColor3=TEXT_DIM
    end)
    return r
end

function NoxaUI.wireArrow(arrow, expRow)
    local expanded = false
    arrow.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            expRow.Visible = true
            NoxaUI.tw(expRow, G.MED, {Size=UDim2.new(1,-4,0,34)})
            NoxaUI.tw(arrow,  G.FAST, {Rotation=180})
        else
            NoxaUI.tw(arrow,  G.FAST, {Rotation=0})
            NoxaUI.tw(expRow, G.MED,  {Size=UDim2.new(1,-4,0,0)})
            task.delay(0.3, function()
                if not expanded then expRow.Visible = false end
            end)
        end
    end)
end

function NoxaUI.mkValue(parent, label, default)
    local r = NoxaUI.mkRow(parent, 34)
    NoxaUI.mkLabel(r, label)
    local box = NoxaUI.new("TextBox", {
        ZIndex=5, Position=UDim2.new(1,-82,0.5,-12),
        Size=UDim2.new(0,72,0,24),
        BackgroundColor3=INPUT_BG, BackgroundTransparency=0.18,
        BorderSizePixel=0, Text=tostring(default),
        TextColor3=ACCENT, TextSize=12,
        Font=Enum.Font.GothamMedium,
        ClearTextOnFocus=false, Parent=r,
    NoxaUI.corner(box, 6); NoxaUI.darkStroke(box, 1)
    NoxaUI.regAccent(box, "TextColor3")
    local last = tostring(default)
    box.FocusLost:Connect(function()
        if not tonumber(box.Text) then box.Text=last else last=box.Text end
        NoxaCfg.saveConfig()
    end)
    return r, box
end

function NoxaUI.mkAction(parent, label, keybind)
    local r = NoxaUI.mkRow(parent, 34)
    local bar = NoxaUI.new("Frame", {
        Position=UDim2.new(0,0,0.5,-10), Size=UDim2.new(0,3,0,20),
        BackgroundColor3=ACCENT, BackgroundTransparency=1,
        BorderSizePixel=0, Parent=r,
    NoxaUI.corner(bar, 2)
    NoxaUI.regAccent(bar)
    local btn = NoxaUI.new("TextButton", {
        Size=UDim2.new(1, keybind and -60 or 0, 1, 0),
        BackgroundTransparency=1, Text=label,
        TextColor3=TEXT_MAIN, TextSize=13,
        Font=Enum.Font.GothamBold,
        AutoButtonColor=false, ZIndex=5, Parent=r,
    btn.MouseButton1Click:Connect(function()
        NoxaUI.tw(bar, G.FAST, {BackgroundTransparency=0})
        task.delay(0.35, function() NoxaUI.tw(bar, G.MED, {BackgroundTransparency=1}) end)
        NoxaUI.tw(r, G.FAST, {BackgroundTransparency=0.05})
        task.delay(0.18, function() NoxaUI.tw(r, G.MED, {BackgroundTransparency=0.25}) end)
    end)
    if keybind then
        local kb = NoxaUI.new("TextButton", {
            ZIndex=5, Position=UDim2.new(1,-64,0.5,-13),
            Size=UDim2.new(0,52,0,26),
            BackgroundColor3=ACCENT, BackgroundTransparency=0.72,
            BorderSizePixel=0, Text=keybind,
            TextColor3=ACCENT, TextSize=11,
            Font=Enum.Font.GothamBlack,
            AutoButtonColor=false, Parent=r,
        NoxaUI.corner(kb, 13)
        NoxaUI.regAccent(kb)
    end
    return r, btn
end

function NoxaUI.mkBigBtn(parent, label)
    local r = NoxaUI.new("Frame", {
        Size=UDim2.new(1,-4,0,44),
        BackgroundColor3=ROW_BG, BackgroundTransparency=0.25,
        BorderSizePixel=0, Parent=parent,
    NoxaUI.corner(r, 10); NoxaUI.darkStroke(r, 1.4)
    NoxaUI.new("UIGradient", {
        Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(22,10,18)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(8, 5, 8)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(22,10,18)),
        Rotation=25, Parent=r,
    NoxaUI.new("TextLabel", {
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1, Text=label,
        TextColor3=TEXT_MAIN, TextSize=16,
        Font=Enum.Font.GothamBlack,
        TextXAlignment=Enum.TextXAlignment.Center, Parent=r,
    local click = NoxaUI.new("TextButton", {
        ZIndex=200, Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1, Text="",
        AutoButtonColor=false, Parent=r,
    click.MouseButton1Click:Connect(function()
        NoxaUI.tw(r, G.FAST, {BackgroundTransparency=0.05})
        task.delay(0.2, function() NoxaUI.tw(r, G.MED, {BackgroundTransparency=0.25}) end)
    end)
    return r, click
end

function NoxaUI.mkPicker(parent, label, options, defaultIdx, callback)
    local idx = defaultIdx or 1
    local r = NoxaUI.mkRow(parent, 34)
    NoxaUI.mkLabel(r, label)
    local prev = NoxaUI.new("TextButton", {
        ZIndex=5, Position=UDim2.new(1,-138,0.5,-12),
        Size=UDim2.new(0,28,0,24),
        BackgroundColor3=INPUT_BG, BackgroundTransparency=0.18,
        BorderSizePixel=0, Text="<",
        TextColor3=TEXT_MAIN, TextSize=12,
        Font=Enum.Font.GothamBold,
        AutoButtonColor=false, Parent=r,
    NoxaUI.corner(prev, 7); NoxaUI.darkStroke(prev, 1)
    local val = NoxaUI.new("TextButton", {
        ZIndex=5, Position=UDim2.new(1,-106,0.5,-12),
        Size=UDim2.new(0,72,0,24),
        BackgroundColor3=INPUT_BG, BackgroundTransparency=0.18,
        BorderSizePixel=0, Text=options[idx],
        TextColor3=TEXT_MAIN, TextSize=10,
        Font=Enum.Font.GothamMedium,
        AutoButtonColor=false, Parent=r,
    NoxaUI.corner(val, 7); NoxaUI.darkStroke(val, 1)
    local nxt = NoxaUI.new("TextButton", {
        ZIndex=5, Position=UDim2.new(1,-30,0.5,-12),
        Size=UDim2.new(0,24,0,24),
        BackgroundColor3=INPUT_BG, BackgroundTransparency=0.18,
        BorderSizePixel=0, Text=">",
        TextColor3=TEXT_MAIN, TextSize=12,
        Font=Enum.Font.GothamBold,
        AutoButtonColor=false, Parent=r,
    NoxaUI.corner(nxt, 7); NoxaUI.darkStroke(nxt, 1)
    local function update()
        val.Text = options[idx]
        if callback then callback(options[idx]) end
        pcall(function()
            if NoxaCfg and NoxaCfg.markConfigDirty then
                NoxaCfg.markConfigDirty()
            elseif NoxaCfg and NoxaCfg.saveConfig then
                NoxaCfg.saveConfig(false)
            end
        end)
    end
    prev.MouseButton1Click:Connect(function()
        idx = idx-1; if idx<1 then idx=#options end; update()
        NoxaUI.tw(prev,G.FAST,{Size=UDim2.new(0,24,0,20)})
        task.delay(0.08,function() NoxaUI.tw(prev,G.FAST,{Size=UDim2.new(0,28,0,24)}) end)
    end)
    nxt.MouseButton1Click:Connect(function()
        idx = idx%#options+1; update()
        NoxaUI.tw(nxt,G.FAST,{Size=UDim2.new(0,20,0,20)})
        task.delay(0.08,function() NoxaUI.tw(nxt,G.FAST,{Size=UDim2.new(0,24,0,24)}) end)
    end)
    return r, val, function(newIdx) idx = newIdx; update() end
end

function NoxaUI.mkPage(parent, name, visible)
    local p = NoxaUI.new("ScrollingFrame", {
        Name=name, Visible=visible~=false,
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1, BorderSizePixel=0,
        ScrollBarThickness=3, ScrollBarImageColor3=ACCENT,
        ScrollBarImageTransparency=0.35,
        ScrollingDirection=Enum.ScrollingDirection.Y,
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        Parent=parent,
    NoxaUI.regAccent(p, "ScrollBarImageColor3")
    NoxaUI.new("UIListLayout", {Padding=UDim.new(0,7), SortOrder=Enum.SortOrder.LayoutOrder, Parent=p})
    NoxaUI.new("UIPadding", {
        PaddingTop=UDim.new(0,6), PaddingBottom=UDim.new(0,10),
        PaddingLeft=UDim.new(0,2), PaddingRight=UDim.new(0,6),
        Parent=p,
    return p
end

local Gui = NoxaUI.new("ScreenGui", {
    Name="NoxaHub", IgnoreGuiInset=true,
    ResetOnSpawn=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    Parent=PlayerGui,

Intro = NoxaUI.new("Frame", {
    Name="Intro", ZIndex=1000,
    Size=UDim2.new(1,0,1,0),
    BackgroundColor3=Color3.fromRGB(6,8,10), BackgroundTransparency=1,
    BorderSizePixel=0, Visible=false, Parent=Gui,
pcall(function() if Intro then Intro.Visible = false end end)

EmberLayer = NoxaUI.new("Frame", {
    Name="EmberLayer", ZIndex=1001,
    Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Parent=Intro,
CSStageBG = EmberLayer

IntroTitle = NoxaUI.new("TextLabel", {
    ZIndex=1003, AnchorPoint=Vector2.new(0.5,0.5),
    Position=UDim2.new(0.5,0,0.46,0),
    Size=UDim2.new(0.9,0,0,64),
    BackgroundTransparency=1,
    Text="NOXA HUB",
    TextColor3=Color3.fromRGB(70, 170, 255), TextSize=42,
    Font=Enum.Font.GothamBlack, Parent=Intro,
    local g = NoxaUI.new("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 170, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100,170,255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 170, 255)),
        Rotation = 90, Parent = IntroTitle,
    _G.NoxaIntroTitleGrad = g
end
tapLbl = NoxaUI.new("TextLabel", {
    Name="TapLbl", ZIndex=1003,
    AnchorPoint=Vector2.new(0.5,0.5),
    Position=UDim2.new(0.5,0,0.46,52),
    Size=UDim2.new(0.7,0,0,20),
    BackgroundTransparency=1, Text="TAP TO SKIP",
    TextColor3=TEXT_DIM, TextSize=11,
    Font=Enum.Font.GothamMedium, Parent=Intro,
NoxaUI.new("TextLabel", {
    ZIndex=1003, AnchorPoint=Vector2.new(0.5,0.5),
    Position=UDim2.new(0.5,0,0.46,74),
    Size=UDim2.new(0.7,0,0,18),
    BackgroundTransparency=1, Text="https://discord.gg/TBBAUZu8cW",
    TextColor3=FX.A2, TextSize=10,
    Font=Enum.Font.GothamMedium, Parent=Intro,
TapCatch = NoxaUI.new("TextButton", {
    ZIndex=1004, Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1, Text="",
    AutoButtonColor=false, Parent=Intro,

MainClip = NoxaUI.new("Frame", {
    Name="MainClip",
    AnchorPoint=Vector2.new(0,0.5),
    Position=UDim2.new(0,18,0.5,0),
    Size=UDim2.new(0,408,0,528),
    BackgroundColor3=BG_MAIN,
    BackgroundTransparency=1,
    BorderSizePixel=0, Visible=false,
    Parent=Gui,
NoxaUI.new("UICorner",{CornerRadius=UDim.new(0,22), Parent=MainClip})

    local g = NoxaUI.new("UIStroke", {
        Color=Color3.fromRGB(70, 170, 255), Thickness=0, Transparency=1,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border, Parent=MainClip,
end
mainStroke = NoxaUI.new("UIStroke", {
    Color=Color3.fromRGB(70, 170, 255), Thickness=0, Transparency=1,
    ApplyStrokeMode=Enum.ApplyStrokeMode.Border,
    Parent=MainClip,
mainStrokeGrad = NoxaUI.new("UIGradient", {
    Color=FX.SEQ,
    Rotation=135, Parent=mainStroke,
NoxaUI.new("UIScale",{Scale=tonumber(SpeedSystem.uiScale) or 0.75, Parent=MainClip})

local Main = NoxaUI.new("Frame", {
    Name="Main", ClipsDescendants=true,
    Size=UDim2.new(1,0,1,0),
    BackgroundColor3=BG_MAIN, BackgroundTransparency=0.12, BorderSizePixel=0,
    Parent=MainClip,
NoxaUI.new("UICorner",{CornerRadius=UDim.new(0,22), Parent=Main})

local NOXA_BG_IMAGES = {

    [1]  = "rbxassetid://87175665223686",
    [2]  = "rbxassetid://103458796266207",
    [3]  = "rbxassetid://90211231416942",
    [4]  = "rbxassetid://138472956105442",
    [5]  = "rbxassetid://100991726480504",
    [6]  = "rbxassetid://96977932125631",
    [7]  = "rbxassetid://111719992911480",
    [8]  = "rbxassetid://105866335213335",
    [9]  = "rbxassetid://94450580704799",
    [10] = "rbxassetid://113332849734803",
_G.NoxaBgImages = NOXA_BG_IMAGES

local function noxaBgRangeForSkin(skin)
    skin = skin or (SpeedSystem and SpeedSystem.uiSkin) or "Noxa"
    if skin == "KuRu" then return 5, 8
    elseif skin == "Vx7" then return 9, 10
    else return 1, 4 end
end

local function noxaApplyBgImage(idx)
    local lo, hi = noxaBgRangeForSkin()
    local maxN = (NOXA_BG_IMAGES and #NOXA_BG_IMAGES) or 10
    hi = math.min(hi, maxN)
    lo = math.clamp(lo, 1, hi)
    idx = math.clamp(tonumber(idx) or lo, lo, hi)

    SpeedSystem.bgImageIndex = idx
    local img = NOXA_BG_IMAGES and NOXA_BG_IMAGES[idx]
    local tr = tonumber(SpeedSystem.bgImageTransparency)
    if tr == nil then tr = 0.05 end
    tr = math.clamp(tr, 0, 0.85)
    local vis = SpeedSystem.bgImageEnabled ~= false

    local function paint(label)
        if not label or not label.Parent then return end
        label.Visible = vis
        if vis and img and img ~= "" then
            label.Image = img
            label.ImageTransparency = tr
        end
    end

    if BgAsset then paint(BgAsset) end

    pcall(function() paint(_G._NoxaKuRuBG) end)

    pcall(function() paint(_G._NoxaVx7BG) end)

    pcall(function()
        for _, name in ipairs({"NoxaKuRuSkin", "NoxaVx7Skin"}) do
            local g = PlayerGui:FindFirstChild(name)
                local sb = g:FindFirstChild("SelectedBackground", true)
                if sb and sb:IsA("ImageLabel") then paint(sb) end
            end
        end
    end)

    pcall(function()
        if stealProgressBar and SpeedSystem.stealBarStyle == "V3" then
            local v3bg = stealProgressBar:FindFirstChild("NoxaV3BgImg")
            if v3bg then v3bg:Destroy() end
            stealProgressBar.BackgroundTransparency = 0.52
        end
    end)
end
_G.NoxaApplyBgImage = noxaApplyBgImage

    local lo = 1
    pcall(function() lo = select(1, noxaBgRangeForSkin(SpeedSystem.uiSkin or "Noxa")) end)
    local initIdx = math.clamp(tonumber(SpeedSystem.bgImageIndex) or lo, lo, lo+3)
    if (SpeedSystem.uiSkin or "Noxa") == "Noxa" then
        initIdx = math.clamp(tonumber(SpeedSystem.bgImageIndex) or 1, 1, 4)
    end
    SpeedSystem.bgImageIndex = initIdx
BgAsset = NoxaUI.new("ImageLabel", {
    Name="BgAsset", Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1,
    Image=NOXA_BG_IMAGES[initIdx] or NOXA_BG_IMAGES[1],
    ImageTransparency=math.clamp(tonumber(SpeedSystem.bgImageTransparency) or 0.05, 0, 0.85),
    ImageColor3=Color3.fromRGB(255,255,255),
    ScaleType=Enum.ScaleType.Crop, ZIndex=0, Parent=Main,
    Visible = SpeedSystem.bgImageEnabled ~= false,
end
NoxaUI.corner(BgAsset, 22)

BgVeil = NoxaUI.new("Frame", {
    Name="BgVeil", Size=UDim2.new(1,0,1,0),
    BackgroundColor3=Color3.fromRGB(6, 10, 14), BackgroundTransparency=0.68,
    BorderSizePixel=0, ZIndex=1, Parent=Main,
NoxaUI.new("UICorner",{CornerRadius=UDim.new(0,22), Parent=BgVeil})
NoxaUI.new("UIGradient", {
    Rotation=125,
    Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(0, 50, 55)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(8, 10, 16)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(0, 40, 70)),
    Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,   0.50, 0),
        NumberSequenceKeypoint.new(0.5, 0.28, 0),
        NumberSequenceKeypoint.new(1,   0.55, 0),
    Parent=BgVeil,
end

SleepOverlay = NoxaUI.new("Frame", {Visible=false,
    ZIndex=500, Size=UDim2.new(1,0,1,0),
    BackgroundColor3=BG_MAIN, BackgroundTransparency=1,
    BorderSizePixel=0, Parent=Main,
NoxaUI.new("UICorner",{CornerRadius=UDim.new(0,22), Parent=SleepOverlay})

Header = NoxaUI.new("Frame", {
    Position=UDim2.new(0, 0, 0, 0),
    Size=UDim2.new(1, 0, 0, 50),
    BackgroundTransparency=1, ZIndex=3, Parent=Main,

HeaderTitle = NoxaUI.new("TextLabel", {
    ZIndex=4,
    Position=UDim2.new(0, 15, 0, 8),
    Size=UDim2.new(0, 160, 0, 36),
    BackgroundTransparency=1, RichText=true,
    Text='<font color="#EAF2FF">NOXA</font> <font color="#46AAFF">DUELS</font>',
    TextColor3=Color3.fromRGB(255,255,255), TextSize=18,
    Font=Enum.Font.GothamBlack,
    TextXAlignment=Enum.TextXAlignment.Left,
    Parent=Header,
_G.NoxaHeaderTitle = HeaderTitle
function _G.NoxaUpdateHeaderTitleAccent(col)
    col = col or ACCENT
    local hex = string.format("#%02X%02X%02X",
        math.floor(col.R * 255 + 0.5),
        math.floor(col.G * 255 + 0.5),
        math.floor(col.B * 255 + 0.5))
    if HeaderTitle then
        HeaderTitle.Text = '<font color="#EAF2FF">NOXA</font> <font color="' .. hex .. '">DUELS</font>'
    end
end

HeaderAvatar = NoxaUI.new("ImageLabel", {
    Name="HeaderAvatar", Visible=false, Parent=Header,

local ScaleBox = NoxaUI.new("Frame", {
    Name="ScaleBox", ZIndex=6,
    AnchorPoint=Vector2.new(1,0),
    Position=UDim2.new(1,-52,0,10),
    Size=UDim2.new(0,118,0,30),
    BackgroundColor3=INPUT_BG or Color3.fromRGB(20,24,28),
    BackgroundTransparency=0.25,
    BorderSizePixel=0, Parent=Header,
NoxaUI.corner(ScaleBox, 8)
NoxaUI.darkStroke(ScaleBox, 1)

ScaleMinus = NoxaUI.new("TextButton", {
    Name="ScaleMinus", ZIndex=7,
    Position=UDim2.new(0,4,0.5,-11),
    Size=UDim2.new(0,26,0,22),
    BackgroundTransparency=1,
    Text="−", TextColor3=TEXT_MAIN or Color3.fromRGB(230,230,235),
    TextSize=18, Font=Enum.Font.GothamBold,
    AutoButtonColor=false, Parent=ScaleBox,
ScalePct = NoxaUI.new("TextLabel", {
    Name="ScalePct", ZIndex=7,
    Position=UDim2.new(0,30,0,0),
    Size=UDim2.new(1,-60,1,0),
    BackgroundTransparency=1,
    Text=tostring(math.floor((tonumber(SpeedSystem.uiScale) or 0.75)*100)) .. "%",
    TextColor3=TEXT_MAIN or Color3.fromRGB(230,230,235),
    TextSize=13, Font=Enum.Font.GothamBold,
    TextXAlignment=Enum.TextXAlignment.Center, Parent=ScaleBox,
ScalePlus = NoxaUI.new("TextButton", {
    Name="ScalePlus", ZIndex=7,
    Position=UDim2.new(1,-30,0.5,-11),
    Size=UDim2.new(0,26,0,22),
    BackgroundTransparency=1,
    Text="+", TextColor3=TEXT_MAIN or Color3.fromRGB(230,230,235),
    TextSize=18, Font=Enum.Font.GothamBold,
    AutoButtonColor=false, Parent=ScaleBox,

local function applyUiScale(delta)
    local cur = tonumber(SpeedSystem.uiScale) or 0.75
    local nextS = math.clamp(cur + delta, 0.55, 1.25)
    SpeedSystem.uiScale = nextS
    local sc = MainClip:FindFirstChildOfClass("UIScale")
    if sc then
        TweenService:Create(sc, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Scale = nextS}):Play()
    end
    ScalePct.Text = tostring(math.floor(nextS * 100 + 0.5)) .. "%"
    pcall(function() if NoxaCfg and NoxaCfg.saveConfig then NoxaCfg.saveConfig() end end)
end
ScaleMinus.MouseButton1Click:Connect(function() applyUiScale(-0.05) end)
ScalePlus.MouseButton1Click:Connect(function() applyUiScale(0.05) end)

CloseBtn = NoxaUI.new("TextButton", {
    Name="Close", ZIndex=8,
    AnchorPoint=Vector2.new(1,0),
    Position=UDim2.new(1,-12,0,12),
    Size=UDim2.new(0,28,0,28),
    BackgroundColor3=Color3.fromRGB(18, 24, 34),
    BackgroundTransparency=0.1,
    Text="−", TextColor3=TEXT_MAIN or Color3.fromRGB(230,230,235),
    TextSize=18, Font=Enum.Font.GothamBold,
    AutoButtonColor=false, Parent=Header,
NoxaUI.corner(CloseBtn, 8)
NoxaUI.darkStroke(CloseBtn, 1)
CloseBtn.MouseEnter:Connect(function()
    NoxaUI.tw(CloseBtn, G.FAST, {BackgroundTransparency=0, TextColor3=ACCENT or Color3.fromRGB(70, 170, 255)})
end)
CloseBtn.MouseLeave:Connect(function()
    NoxaUI.tw(CloseBtn, G.FAST, {BackgroundTransparency=0.2, TextColor3=TEXT_MAIN or Color3.fromRGB(230,230,235)})
end)

Div = NoxaUI.new("Frame", {
    Position=UDim2.new(0,84,0,50),
    Size=UDim2.new(1,-96,0,1),
    BackgroundColor3=ACCENT or Color3.fromRGB(70,170,255), BorderSizePixel=0, Parent=Main,
NoxaUI.new("UIGradient", {
    Color=FX.SEQ,
    Transparency=NumberSequence.new({
        NumberSequenceKeypoint.new(0,   0.9, 0),
        NumberSequenceKeypoint.new(0.5, 0.15, 0),
        NumberSequenceKeypoint.new(1,   0.9, 0),
    Parent=Div,

stealProgressBar = NoxaUI.new("Frame", {
    Name="StealProgressBar",
    ZIndex=1000,
    Position=UDim2.new(0.5,-160,1,-90),
    Size=UDim2.new(0,320,0,44),
    BackgroundColor3=Color3.fromRGB(10,10,16),
    BackgroundTransparency=0.05,
    BorderSizePixel=0,
    Visible=false,
    Active=true,
    ClipsDescendants=true,
    Parent=Gui,
NoxaUI.corner(stealProgressBar, 999)

stealProgressBar:GetPropertyChangedSignal("Position"):Connect(function()
    NoxaCfg.saveConfig()
end)

pbStroke = NoxaUI.new("UIStroke", {
    Color=Color3.fromRGB(255,255,255),
    Thickness=0,
    Transparency=1,
    Parent=stealProgressBar,
NoxaUI.new("UIGradient", {Color=FX.SEQ, Rotation=0, Parent=pbStroke})

modeBtn = NoxaUI.new("TextButton", {
    ZIndex=1003,
    Position=UDim2.new(0,8,0.5,-11),
    Size=UDim2.new(0,28,0,22),
    BackgroundColor3=Color3.fromRGB(20,20,20),
    BackgroundTransparency=0,
    BorderSizePixel=0,
    Text="N",
    TextColor3=Color3.fromRGB(70, 170, 255),
    Font=Enum.Font.GothamBold,
    TextSize=11,
    AutoButtonColor=false,
    Parent=stealProgressBar,
NoxaUI.corner(modeBtn, 999)

modeStroke = NoxaUI.new("UIStroke", {
    Color=Color3.fromRGB(70, 170, 255),
    Thickness=0,
    Transparency=1,
    Parent=modeBtn,

track = NoxaUI.new("Frame", {
    Name="Track",
    ZIndex=1002,
    Position=UDim2.new(0,44,0.5,2),
    Size=UDim2.new(1,-100,0,8),
    BackgroundColor3=Color3.fromRGB(22,22,22),
    BackgroundTransparency=0,
    BorderSizePixel=0,
    ClipsDescendants=true,
    Parent=stealProgressBar,
NoxaUI.corner(track, 999)

stealProgressFill = NoxaUI.new("Frame", {
    Name="ProgressFill",
    ZIndex=1003,
    Position=UDim2.new(0,0,0,0),
    Size=UDim2.new(0,0,1,0),
    BackgroundColor3=Color3.fromRGB(70, 170, 255),
    BorderSizePixel=0,
    Parent=track,
NoxaUI.corner(stealProgressFill, 999)

fillGrad = NoxaUI.new("UIGradient", {
    Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0, ACCENT),
        ColorSequenceKeypoint.new(1, ACCENT),
    Parent=stealProgressFill,

progressPct = NoxaUI.new("TextLabel", {
    ZIndex=1003,
    Position=UDim2.new(1,-48,0,0),
    Size=UDim2.new(0,40,1,0),
    BackgroundTransparency=1,
    Text="0%",
    TextColor3=Color3.fromRGB(200,200,200),
    Font=Enum.Font.GothamBold,
    TextSize=12,
    TextXAlignment=Enum.TextXAlignment.Right,
    Parent=stealProgressBar,

progressRadLbl = NoxaUI.new("TextLabel", {
    ZIndex=1004,
    Position=UDim2.new(0,44,0,3),
    Size=UDim2.new(0,90,0,14),
    BackgroundTransparency=1,
    Text="60 FPS  |  0ms",
    TextColor3=Color3.fromRGB(120,120,120),
    Font=Enum.Font.Gotham,
    TextSize=10,
    TextXAlignment=Enum.TextXAlignment.Left,
    Parent=stealProgressBar,

local stealModeVisual = "N"

local function updateModeVisual()
    if SpeedSystem.stealMode == "V1" then
        stealModeVisual = "N"
    elseif SpeedSystem.stealMode == "V2 SEMI" then
        stealModeVisual = "S"
    elseif SpeedSystem.stealMode == "V3" then
        stealModeVisual = "V"
    elseif SpeedSystem.stealMode == "V4" then
        stealModeVisual = "4"
    else
        stealModeVisual = "S"
    end
    local barStyle = SpeedSystem.stealBarStyle or "V1"
    if modeBtn and modeBtn.Parent then
        modeBtn.Text = stealModeVisual
        modeBtn.TextColor3 = ACCENT or Color3.fromRGB(70, 170, 255)

        modeBtn.Visible = (barStyle == "V1")
    end
    pcall(function()
        if not stealProgressBar then return end
        local chip = stealProgressBar:FindFirstChild("NoxaV3ModeChip")
        if chip then
            local modeName = tostring(SpeedSystem.stealMode or "V1"):upper()
            if modeName == "V2 SEMI" then modeName = "SEMI" end
            chip.Text = modeName
        end

        local styleLbl = stealProgressBar:FindFirstChild("StealStyleLabel")
        if styleLbl then
            styleLbl.Visible = (barStyle == "V2")
            if barStyle == "V2" then
                styleLbl.Text = "STEAL"
            end
        end

        local tr = stealProgressBar:FindFirstChild("Track")
        if tr then tr.Visible = (barStyle == "V1") end
        local ace = stealProgressBar:FindFirstChild("AceFillRegion")
        if ace then ace.Visible = (barStyle == "V2") end
    end)
end

local pulseTween = nil
local function startStealPulse()
    if pulseTween then pulseTween:Cancel() end

    if pbStroke then pbStroke.Transparency = 1; pbStroke.Thickness = 0 end
end

local function stopStealPulse()
    if pulseTween then pulseTween:Cancel(); pulseTween = nil end
    if pbStroke then pbStroke.Transparency = 1; pbStroke.Thickness = 0 end
end

local stealDragging, stealDragStart, stealStartPos = false, nil, nil
stealProgressBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then
        stealDragging = true
        stealDragStart = inp.Position
        stealStartPos = stealProgressBar.Position
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then
                stealDragging = false
            end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(inp)
    if stealDragging and (inp.UserInputType == Enum.UserInputType.MouseMovement
        or inp.UserInputType == Enum.UserInputType.Touch) then
        local delta = inp.Position - stealDragStart
        stealProgressBar.Position = UDim2.new(
            stealStartPos.X.Scale, stealStartPos.X.Offset + delta.X,
            stealStartPos.Y.Scale, stealStartPos.Y.Offset + delta.Y
    end
end)
UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then
        stealDragging = false
    end
end)

local StealRT = {
    isStealing = false,
    progressConn = nil,
    dataCache = {},
    lastProgress = 0,
    isShaking = false,
    stealConn = nil,

local _spaceProg = {
    lastFillPct = 0,
    active = false,
    startTime = 0,
    duration = 1.3,
    holdMin = 1.3,
local function _spaceEnsureRefs()
    local style = SpeedSystem.stealBarStyle or "V3"

    if style == "V1" then
        local rb = rawget(_G, "_NoxaRitualBar")
        if rb and rb.fill and rb.fill.Parent then
            stealProgressFill = rb.fill
            if rb.pct and rb.pct.Parent then progressPct = rb.pct end
            return
        end
        for _, parent in ipairs({PlayerGui, game:GetService("CoreGui")}) do
            local gui = parent:FindFirstChild("NoxaRitualStealBar")
            if gui then
                local track = gui:FindFirstChild("Track", true)
                local f = track and track:FindFirstChild("ProgressFill") or gui:FindFirstChild("ProgressFill", true)
                local p = gui:FindFirstChild("PctLbl", true)
                if f then stealProgressFill = f end
                if p then progressPct = p end
                if f then return end
            end
        end
        return
    end

    if not stealProgressBar then return end

    if style == "V2" then
        local ace = stealProgressBar:FindFirstChild("AceFillRegion")
        if ace then
            local f = ace:FindFirstChild("ProgressFill")
                stealProgressFill = f
            elseif stealProgressFill and stealProgressFill.Parent ~= ace then

                stealProgressFill.Parent = ace
                stealProgressFill.Position = UDim2.new(0, 0, 0, 0)
                stealProgressFill.Size = UDim2.new(0, 0, 1, 0)
            end
        end
        local pct = stealProgressBar:FindFirstChild("ProgressPct")
            or stealProgressBar:FindFirstChild("ProgressPct", true)
        if pct then progressPct = pct end
        return
    end

    if style == "V3" then
        local barBg = stealProgressBar:FindFirstChild("NoxaV3FillBg")
        if barBg then
            local f = barBg:FindFirstChild("ProgressFill")
                stealProgressFill = f
            elseif stealProgressFill and stealProgressFill.Parent ~= barBg then
                stealProgressFill.Parent = barBg
                stealProgressFill.Position = UDim2.new(0, 0, 0, 0)
                stealProgressFill.Size = UDim2.new(0, 0, 1, 0)
            end
        end
        local v3 = rawget(_G, "_NoxaStealV3")
        if v3 and v3.pctLbl then
            progressPct = v3.pctLbl
        else
            local pct = stealProgressBar:FindFirstChild("ProgressPct", true)
            if pct then progressPct = pct end
        end
        return
    end

    if not stealProgressFill or not stealProgressFill.Parent then
        local f = stealProgressBar:FindFirstChild("ProgressFill", true)
        if f then stealProgressFill = f end
    end
    if not progressPct or not progressPct.Parent then
        local p = stealProgressBar:FindFirstChild("ProgressPct", true)
        if p then progressPct = p end
    end
end

if not _G._NoxaSpaceProgConn then
    _G._NoxaSpaceProgConn = RunService.RenderStepped:Connect(function(dt)
        _spaceEnsureRefs()
        local fill = stealProgressFill
        local pctLbl = progressPct
        if not fill or not fill.Parent then return end

        local active = StealRT.isStealing or _spaceProg.active
        if active then
            local dur = math.max(_spaceProg.duration or SpeedSystem.stealDuration or 1.3, 0.05)
            local elapsed = tick() - (_spaceProg.startTime > 0 and _spaceProg.startTime or (stealStartTimeRender or tick()))
            local targetPct = math.clamp(elapsed / dur, 0, 1)

            _spaceProg.lastFillPct = _spaceProg.lastFillPct + (targetPct - _spaceProg.lastFillPct) * math.min(dt * 14, 1)
            pcall(function()

                fill.Size = UDim2.new(math.clamp(_spaceProg.lastFillPct, 0, 1), 0, 1, 0)
                fill.Position = UDim2.new(0, 0, 0, 0)
                fill.Visible = true
            end)
            if pctLbl and pctLbl.Parent then
                local style = SpeedSystem.stealBarStyle or "V1"
                if style == "V2" or style == "V3" then
                    pctLbl.Visible = false
                    pctLbl.Text = ""
                else
                    pctLbl.Text = math.floor(_spaceProg.lastFillPct * 100 + 0.5) .. "%"
                    pctLbl.Visible = true
                end
            end
        else
            if _spaceProg.lastFillPct > 0.001 then

                _spaceProg.lastFillPct = _spaceProg.lastFillPct * math.max(0, 1 - dt * 8)
                if _spaceProg.lastFillPct < 0.02 then
                    _spaceProg.lastFillPct = 0
                end
                pcall(function()
                    fill.Size = UDim2.new(_spaceProg.lastFillPct, 0, 1, 0)
                end)
                if pctLbl and pctLbl.Parent then
                    local style = SpeedSystem.stealBarStyle or "V1"
                    if style == "V2" or style == "V3" then
                        pctLbl.Visible = false
                        pctLbl.Text = ""
                    else
                        if _spaceProg.lastFillPct <= 0 then
                            pctLbl.Text = "0%"
                        else
                            pctLbl.Text = math.floor(_spaceProg.lastFillPct * 100 + 0.5) .. "%"
                        end
                    end
                end
            end
        end
    end)
end

local function shake()
    if StealRT.isShaking then return end
    StealRT.isShaking = true
    local origin = stealProgressBar.Position
    local sequence = {2, -2, 1, -1, 0}
    task.spawn(function()
        for _, x in ipairs(sequence) do
            stealProgressBar.Position = UDim2.new(origin.X.Scale, origin.X.Offset + x, origin.Y.Scale, origin.Y.Offset)
            task.wait(0.018)
        end
        stealProgressBar.Position = origin
        StealRT.isShaking = false
    end)
end

local function applyStealBarStyle(style)
    style = "V3"
    SpeedSystem.stealBarStyle = "V3"
    if style ~= "V1" then
        pcall(function()
            local rb = rawget(_G, "_NoxaRitualBar")
            if rb and rb.gui then rb.gui.Enabled = false end
            for _, parent in ipairs({PlayerGui, game:GetService("CoreGui")}) do
                local o = parent:FindFirstChild("NoxaRitualStealBar")
                if o then o.Enabled = false end
            end
            if stealProgressBar then stealProgressBar.Visible = true end
        end)
    end
    if not stealProgressBar or not stealProgressBar.Parent then
        local gui = PlayerGui:FindFirstChild("NoxaHub")
        if gui then
            local sp = gui:FindFirstChild("StealProgressBar", true)
            if sp then stealProgressBar = sp end
        end
    end

    if not stealProgressBar and style ~= "V1" then return end

    pcall(function()
        if style == "V1" then
            stealProgressBar.Visible = false
        else
            stealProgressBar.Visible = true
            if style == "V3" then
                stealProgressBar.Size = UDim2.new(0, 580, 0, 70)
            else
                stealProgressBar.Size = UDim2.new(0, 320, 0, 44)
            end
        end
    end)

    if style == "V3" then
        pcall(function()
            if stealProgressBar then stealProgressBar.Visible = true end
            local rb = rawget(_G, "_NoxaRitualBar")
            if rb and rb.gui then rb.gui.Enabled = false end

            local ACC = (typeof(ACCENT) == "Color3" and ACCENT) or Color3.fromRGB(70, 170, 255)
            local MAIN_DARK = Color3.fromRGB(8, 8, 10)
            local PROGRESS_BG = Color3.fromRGB(8, 8, 10)

            for _, n in ipairs({
                "SodaBubble","AluminumRim","SodaCanWash","NoxaV3BrandDisc"
            }) do
                local o = stealProgressBar:FindFirstChild(n)
                if o then o:Destroy() end
            end
            for _, ch in ipairs(stealProgressBar:GetChildren()) do
                if ch.Name:find("SodaBubble") or ch.Name:find("AluminumRim") or ch.Name == "SodaCanWash" then
                    ch:Destroy()
                end
            end

            if modeBtn then modeBtn.Visible = false end
            if track then track.Visible = false end
            if stealLbl then stealLbl.Visible = false end
            if progressRadLbl then progressRadLbl.Visible = false end
            local aceFill = stealProgressBar:FindFirstChild("AceFillRegion")
            if aceFill then aceFill.Visible = false end
            local styleLbl = stealProgressBar:FindFirstChild("StealStyleLabel")
            if styleLbl then styleLbl.Visible = false end

            stealProgressBar.Size = UDim2.new(0, 580, 0, 70)
            stealProgressBar.AnchorPoint = Vector2.new(0.5, 0.5)
            if not stealProgressBar:GetAttribute("_v3PosSet") then
                stealProgressBar.Position = UDim2.new(0.5, 0, 0.91, 0)
                stealProgressBar:SetAttribute("_v3PosSet", true)
            end
            stealProgressBar:SetAttribute("_fromV3", true)

            stealProgressBar.BackgroundColor3 = Color3.fromRGB(10, 12, 16)
            stealProgressBar.BackgroundTransparency = 0.52
            stealProgressBar.BorderSizePixel = 0
            stealProgressBar.ClipsDescendants = true
            stealProgressBar.Visible = true

            local corner = stealProgressBar:FindFirstChildOfClass("UICorner")
            if not corner then corner = Instance.new("UICorner", stealProgressBar) end
            corner.CornerRadius = UDim.new(1, 0)

            local stroke = stealProgressBar:FindFirstChildOfClass("UIStroke")
            if not stroke then stroke = Instance.new("UIStroke", stealProgressBar) end
            stroke.Color = ACC
            stroke.Thickness = 1.1
            stroke.Transparency = 0.55
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            local oldBg = stealProgressBar:FindFirstChild("NoxaV3BgImg")
            if oldBg then oldBg:Destroy() end

            local canWash = Instance.new("Frame")
            canWash.Name = "NoxaV3CanWash"
            canWash.Size = UDim2.new(1, 0, 1, 0)
            canWash.BackgroundColor3 = Color3.fromRGB(8, 10, 14)
            canWash.BackgroundTransparency = 0.72
            canWash.BorderSizePixel = 0
            canWash.ZIndex = 1
            canWash.Active = false
            canWash.Parent = stealProgressBar
            Instance.new("UICorner", canWash).CornerRadius = UDim.new(1, 0)

            local modeChip = Instance.new("TextLabel")
            modeChip.Name = "NoxaV3ModeChip"
            modeChip.Size = UDim2.new(0, 48, 0, 26)
            modeChip.Position = UDim2.new(0, 408, 0, 22)
            modeChip.BackgroundColor3 = ACC
            modeChip.BackgroundTransparency = 0.08
            modeChip.BorderSizePixel = 0
            local modeName = tostring(SpeedSystem.stealMode or "V1"):upper()
            if modeName == "V2 SEMI" then modeName = "SEMI" end
            modeChip.Text = modeName
            modeChip.TextColor3 = Color3.fromRGB(255, 255, 255)
            modeChip.Font = Enum.Font.GothamBlack
            modeChip.TextSize = 10
            modeChip.TextWrapped = true
            modeChip.ZIndex = 6
            modeChip.Parent = stealProgressBar
            Instance.new("UICorner", modeChip).CornerRadius = UDim.new(1, 0)

            local function makeScaleBtn(symbol, xOff, delta)
                local btn = Instance.new("TextButton")
                btn.Name = (symbol == "-") and "NoxaV3ScaleMinus" or "NoxaV3ScalePlus"
                btn.Size = UDim2.new(0, 22, 0, 22)
                btn.Position = UDim2.new(0, xOff, 0.5, -11)
                btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                btn.BackgroundTransparency = 0.3
                btn.BorderSizePixel = 0
                btn.Text = symbol
                btn.TextColor3 = ACC
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 17
                btn.ZIndex = 7
                btn.AutoButtonColor = false
                btn.Parent = stealProgressBar
                Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
                btn.MouseButton1Click:Connect(function()

                    if SpeedSystem.stealBarStyle ~= "V3" then return end
                    local sc = stealProgressBar:FindFirstChild("V3BarScale")
                    if not sc then
                        sc = Instance.new("UIScale")
                        sc.Name = "V3BarScale"
                        sc.Scale = tonumber(stealProgressBar:GetAttribute("V3Scale")) or 1
                        sc.Parent = stealProgressBar
                    end
                    local ns = math.clamp((sc.Scale or 1) + delta, 0.6, 1.6)
                    sc.Scale = ns
                    stealProgressBar:SetAttribute("V3Scale", ns)
                    SpeedSystem.v3BarScale = ns
                    pcall(function() NoxaCfg.markConfigDirty() end)
                    pcall(function() NoxaCfg.saveConfig(true) end)
                end)
            end
            makeScaleBtn("-", 16, -0.1)
            makeScaleBtn("+", 42, 0.1)

                local saved = tonumber(stealProgressBar:GetAttribute("V3Scale")) or 1
                local sc = stealProgressBar:FindFirstChild("V3BarScale")
                if not sc then
                    sc = Instance.new("UIScale")
                    sc.Name = "V3BarScale"
                    sc.Parent = stealProgressBar
                end
                sc.Scale = saved
            end

            local barBg = Instance.new("Frame")
            barBg.Name = "NoxaV3FillBg"
            barBg.Size = UDim2.new(0, 256, 0, 48)
            barBg.Position = UDim2.new(0, 144, 0.5, -24)
            barBg.BackgroundColor3 = PROGRESS_BG
            barBg.BackgroundTransparency = 0.08
            barBg.BorderSizePixel = 0
            barBg.ClipsDescendants = true
            barBg.ZIndex = 2
            barBg.Parent = stealProgressBar
            Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)
            local bgGrad = Instance.new("UIGradient", barBg)
            bgGrad.Color = ColorSequence.new(Color3.fromRGB(18, 52, 30), Color3.fromRGB(4, 18, 10))
            bgGrad.Rotation = 90

            if not stealProgressFill or not stealProgressFill.Parent then
                local existing = barBg:FindFirstChild("ProgressFill")
                if existing and existing:IsA("Frame") then
                    stealProgressFill = existing
                else
                    stealProgressFill = Instance.new("Frame")
                    stealProgressFill.Name = "ProgressFill"
                    Instance.new("UICorner", stealProgressFill).CornerRadius = UDim.new(1, 0)
                end
            end

            if track then track.Visible = false end
            local ace = stealProgressBar:FindFirstChild("AceFillRegion")
            if ace then ace.Visible = false end
            for _, child in ipairs(stealProgressBar:GetDescendants()) do
                if child.Name == "ProgressFill" and child.Parent ~= barBg then
                    child.Visible = false
                    child.Size = UDim2.new(0, 0, 1, 0)
                end
            end
            barBg.ClipsDescendants = true
            barBg.Visible = true
            stealProgressFill.Parent = barBg
            stealProgressFill.Name = "ProgressFill"
            stealProgressFill.Size = UDim2.new(0, 0, 1, 0)
            stealProgressFill.Position = UDim2.new(0, 0, 0, 0)
            stealProgressFill.BackgroundColor3 = ACC
            stealProgressFill.BackgroundTransparency = 0
            stealProgressFill.BorderSizePixel = 0
            stealProgressFill.ZIndex = 3
            stealProgressFill.Visible = true
            local fc = stealProgressFill:FindFirstChildOfClass("UICorner")
            if not fc then fc = Instance.new("UICorner", stealProgressFill) end
            fc.CornerRadius = UDim.new(1, 0)
            local oldGrad = stealProgressFill:FindFirstChildOfClass("UIGradient")
            if oldGrad then oldGrad:Destroy() end
            local fillGrad = Instance.new("UIGradient", stealProgressFill)
            local ad = (typeof(FX) == "table" and FX.AD) or ACC:Lerp(Color3.new(0,0,0), 0.35)
            local a2 = (typeof(FX) == "table" and FX.A2) or ACC:Lerp(Color3.new(1,1,1), 0.35)
            fillGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, ad),
                ColorSequenceKeypoint.new(0.55, ACC),
                ColorSequenceKeypoint.new(1, a2),
            fillGrad.Rotation = 5
            stealProgressFill.BackgroundColor3 = ACC

            local stateLbl = Instance.new("TextLabel")
            stateLbl.Name = "NoxaV3Brainrot"
            stateLbl.Size = UDim2.new(1, -92, 1, 0)
            stateLbl.Position = UDim2.new(0, 12, 0, 0)
            stateLbl.BackgroundTransparency = 1
            stateLbl.Text = "BRAINROT"
            stateLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            stateLbl.Font = Enum.Font.GothamBlack
            stateLbl.TextSize = 12
            stateLbl.TextXAlignment = Enum.TextXAlignment.Left
            stateLbl.TextTruncate = Enum.TextTruncate.AtEnd
            stateLbl.ZIndex = 5
            stateLbl.Parent = barBg

            if not progressPct or not progressPct.Parent then
                progressPct = Instance.new("TextLabel")
                progressPct.Name = "ProgressPct"
            end
            progressPct.Parent = barBg
            progressPct.Size = UDim2.new(0, 54, 1, 0)
            progressPct.Position = UDim2.new(1, -64, 0, 0)
            progressPct.BackgroundTransparency = 1
            progressPct.Text = ""
            progressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
            progressPct.Font = Enum.Font.GothamBold
            progressPct.TextSize = 13
            progressPct.TextXAlignment = Enum.TextXAlignment.Right
            progressPct.TextYAlignment = Enum.TextYAlignment.Center
            progressPct.ZIndex = 8
            progressPct.Visible = false

            local fpsLbl = Instance.new("TextLabel")
            fpsLbl.Name = "NoxaV3Fps"
            fpsLbl.Size = UDim2.new(0, 78, 0, 27)
            fpsLbl.Position = UDim2.new(1, -88, 0, 6)
            fpsLbl.BackgroundColor3 = Color3.fromRGB(2, 22, 11)
            fpsLbl.BackgroundTransparency = 0.16
            fpsLbl.Text = "--FPS"
            fpsLbl.TextColor3 = Color3.fromRGB(230, 230, 230)
            fpsLbl.Font = Enum.Font.GothamBlack
            fpsLbl.TextSize = 14
            fpsLbl.TextXAlignment = Enum.TextXAlignment.Center
            fpsLbl.ZIndex = 6
            fpsLbl.Parent = stealProgressBar
            Instance.new("UICorner", fpsLbl).CornerRadius = UDim.new(1, 0)

            local pingLbl = Instance.new("TextLabel")
            pingLbl.Name = "NoxaV3Ms"
            pingLbl.Size = UDim2.new(0, 78, 0, 27)
            pingLbl.Position = UDim2.new(1, -88, 0, 37)
            pingLbl.BackgroundColor3 = Color3.fromRGB(2, 22, 11)
            pingLbl.BackgroundTransparency = 0.16
            pingLbl.Text = "--ms"
            pingLbl.TextColor3 = Color3.fromRGB(230, 230, 230)
            pingLbl.Font = Enum.Font.GothamBlack
            pingLbl.TextSize = 14
            pingLbl.TextXAlignment = Enum.TextXAlignment.Center
            pingLbl.ZIndex = 6
            pingLbl.Parent = stealProgressBar
            Instance.new("UICorner", pingLbl).CornerRadius = UDim.new(1, 0)

            task.spawn(function()
                local Stats = game:GetService("Stats")
                while pingLbl and pingLbl.Parent do
                    task.wait(1)
                    pcall(function()
                        local stat = Stats.Network.ServerStatsItem["Data Ping"]
                        local p = stat and math.floor(stat:GetValue() or 0) or 0
                        pingLbl.Text = tostring(p) .. "ms"
                        if p < 70 then pingLbl.TextColor3 = ACC
                        elseif p < 120 then pingLbl.TextColor3 = Color3.fromRGB(255, 220, 80)
                        else pingLbl.TextColor3 = Color3.fromRGB(255, 80, 80) end
                    end)
                end
            end)

            task.spawn(function()
                local fc, lt = 0, tick()
                local rc = game:GetService("RunService").RenderStepped:Connect(function()
                    fc = fc + 1
                end)
                while fpsLbl and fpsLbl.Parent do
                    task.wait(1)
                    local now = tick()
                    local el = now - lt
                    local fps = el > 0 and math.floor(fc / el) or 0
                    fc = 0
                    lt = now
                    pcall(function()
                        fpsLbl.Text = tostring(fps) .. " FPS"
                        if fps >= 50 then fpsLbl.TextColor3 = ACC
                        elseif fps >= 30 then fpsLbl.TextColor3 = Color3.fromRGB(255, 220, 80)
                        else fpsLbl.TextColor3 = Color3.fromRGB(255, 80, 80) end
                    end)
                end
                if rc then rc:Disconnect() end
            end)

            _G._NoxaStealV3 = {
                bar = stealProgressBar,
                bgImg = bgImg,
                canWash = canWash,
                modeChip = modeChip,
                fill = stealProgressFill,
                stateLbl = stateLbl,
                pct = progressPct,
                fps = fpsLbl,
                ping = pingLbl,
        end)
        return
    end

    pcall(function()
        if stealProgressFill and stealProgressFill.Parent then
            stealProgressFill.Parent = stealProgressBar
        end
        if progressPct and progressPct.Parent then
            progressPct.Parent = stealProgressBar
        end
        if progressRadLbl and progressRadLbl.Parent then
            progressRadLbl.Parent = stealProgressBar
        end
        for _, n in ipairs({
            "NoxaV3Ms","NoxaV3ScaleMinus","NoxaV3ScalePlus","NoxaV3BrandDisc"
        }) do
            local o = stealProgressBar:FindFirstChild(n)
            if o then o:Destroy() end
        end
        _G._NoxaStealV3 = nil

        stealProgressBar.AnchorPoint = Vector2.new(0, 0)
        stealProgressBar:SetAttribute("_v3PosSet", nil)

        local v3sc = stealProgressBar:FindFirstChild("V3BarScale")
        if v3sc then v3sc:Destroy() end
        stealProgressBar.BackgroundTransparency = 0.05
        stealProgressBar.ClipsDescendants = true
        local corner = stealProgressBar:FindFirstChildOfClass("UICorner")
        if corner then corner.CornerRadius = UDim.new(1, 0) end
        if pbStroke then
            pbStroke.Thickness = 0
            pbStroke.Transparency = 1
            pbStroke.Color = ACCENT or Color3.fromRGB(70, 170, 255)
            pbStroke.Enabled = false
        end

        if not stealProgressFill or not stealProgressFill.Parent then
            stealProgressFill = Instance.new("Frame")
            stealProgressFill.Name = "ProgressFill"
            stealProgressFill.ZIndex = 1003
            stealProgressFill.Position = UDim2.new(0, 0, 0, 0)
            stealProgressFill.Size = UDim2.new(0, 0, 1, 0)
            stealProgressFill.BackgroundColor3 = ACCENT or Color3.fromRGB(70, 170, 255)
            stealProgressFill.BorderSizePixel = 0
            stealProgressFill.Parent = track or stealProgressBar
            Instance.new("UICorner", stealProgressFill).CornerRadius = UDim.new(1, 0)
            local fg = Instance.new("UIGradient")
            fg.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, ACCENT or Color3.fromRGB(70, 170, 255)),
                ColorSequenceKeypoint.new(1, ACCENT or Color3.fromRGB(70, 170, 255)),
            fg.Parent = stealProgressFill
        end
    end)

    local fillRegion = stealProgressBar:FindFirstChild("AceFillRegion")
    local stealLbl = stealProgressBar:FindFirstChild("StealStyleLabel")

    if style == "V1" then

        if stealProgressBar then
            stealProgressBar.Visible = false
        end

        pcall(function()
            for _, parent in ipairs({PlayerGui, game:GetService("CoreGui")}) do
                local o = parent:FindFirstChild("NoxaRitualStealBar")
                if o then o:Destroy() end
            end
            if Gui then
                local o = Gui:FindFirstChild("NoxaRitualStealBar")
                if o then o:Destroy() end
            end
        end)

        local function _liveAcc()
            return (typeof(ACCENT) == "Color3" and ACCENT) or Color3.fromRGB(70, 170, 255)
        end
        local ACC = _liveAcc()
        local ACC_DARK = Color3.new(ACC.R * 0.4, ACC.G * 0.4, ACC.B * 0.45)
        local SB_W, SB_H = 220, 46

        local stealGui = Instance.new("ScreenGui")
        stealGui.Name = "NoxaRitualStealBar"
        stealGui.ResetOnSpawn = false
        stealGui.IgnoreGuiInset = true
        stealGui.DisplayOrder = 999
        stealGui.Enabled = true

        local parented = false
        pcall(function()
            if Gui and Gui.Parent then
                stealGui.Parent = Gui
                parented = true
            end
        end)
        if not parented then
            pcall(function()
                stealGui.Parent = PlayerGui
                parented = true
            end)
        end
        if not parented then
            pcall(function()
                stealGui.Parent = game:GetService("CoreGui")
                parented = true
            end)
        end

        local frame = Instance.new("Frame")
        frame.Name = "StealBarFrame"
        frame.AnchorPoint = Vector2.new(0.5, 1)
        frame.Position = UDim2.new(0.5, 0, 1, -24)
        frame.Size = UDim2.new(0, SB_W, 0, SB_H)
        frame.BackgroundColor3 = Color3.new(ACC.R * 0.08, ACC.G * 0.12, ACC.B * 0.2)
        frame.BackgroundTransparency = 0.25
        frame.BorderSizePixel = 0
        frame.ZIndex = 100
        frame.ClipsDescendants = true
        frame.Active = true
        frame.Visible = true
        frame.Parent = stealGui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = frame

        local sbStroke = Instance.new("UIStroke")
        sbStroke.Color = ACC
        sbStroke.Thickness = 1.15
        sbStroke.Transparency = 0.3
        sbStroke.Parent = frame

        local sbBgGrad = Instance.new("UIGradient")
        sbBgGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(math.clamp(ACC.R*0.55,0,1), math.clamp(ACC.G*0.55,0,1), math.clamp(ACC.B*0.6,0,1))),
            ColorSequenceKeypoint.new(0.55, Color3.new(ACC.R*0.15, ACC.G*0.18, ACC.B*0.28)),
            ColorSequenceKeypoint.new(1, Color3.new(ACC.R*0.04, ACC.G*0.06, ACC.B*0.1)),
        sbBgGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.08),
            NumberSequenceKeypoint.new(0.55, 0.22),
            NumberSequenceKeypoint.new(1, 0.34),
        sbBgGrad.Rotation = 18
        sbBgGrad.Parent = frame

        local sideAccent = Instance.new("Frame")
        sideAccent.Name = "SideAccent"
        sideAccent.Size = UDim2.new(0, 2, 0, 24)
        sideAccent.Position = UDim2.new(0, 0, 0.5, -12)
        sideAccent.BackgroundColor3 = ACC
        sideAccent.BackgroundTransparency = 0.18
        sideAccent.BorderSizePixel = 0
        sideAccent.ZIndex = 102
        sideAccent.Parent = frame
        Instance.new("UICorner", sideAccent).CornerRadius = UDim.new(0, 2)

        local dot = Instance.new("Frame")
        dot.Name = "Dot"
        dot.Size = UDim2.new(0, 6, 0, 6)
        dot.Position = UDim2.new(0, 12, 0, 11)
        dot.BackgroundColor3 = ACC_DARK
        dot.BackgroundTransparency = 0.12
        dot.BorderSizePixel = 0
        dot.ZIndex = 102
        dot.Parent = frame
        Instance.new("UICorner", dot).CornerRadius = UDim.new(0, 4)

        local stealLbl = Instance.new("TextLabel")
        stealLbl.Size = UDim2.new(0, 105, 0, 16)
        stealLbl.Position = UDim2.new(0, 24, 0, 5)
        stealLbl.BackgroundTransparency = 1
        stealLbl.Text = "AUTO STEAL"
        stealLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        stealLbl.Font = Enum.Font.GothamBold
        stealLbl.TextSize = 10
        stealLbl.TextXAlignment = Enum.TextXAlignment.Left
        stealLbl.ZIndex = 102
        stealLbl.Parent = frame

        local stateLbl = Instance.new("TextLabel")
        stateLbl.Name = "StateLbl"
        stateLbl.Size = UDim2.new(0, 70, 0, 12)
        stateLbl.Position = UDim2.new(0, 12, 0, 22)
        stateLbl.BackgroundTransparency = 1
        stateLbl.Text = "OFF"
        stateLbl.TextColor3 = Color3.new(math.clamp(ACC.R*0.85,0,1), math.clamp(ACC.G*0.85,0,1), math.clamp(ACC.B*0.9,0,1))
        stateLbl.TextSize = 8
        stateLbl.Font = Enum.Font.GothamBold
        stateLbl.TextXAlignment = Enum.TextXAlignment.Left
        stateLbl.ZIndex = 102
        stateLbl.Parent = frame

        local perfLbl = Instance.new("TextLabel")
        perfLbl.Name = "PerfLbl"
        perfLbl.Size = UDim2.new(0, 92, 0, 12)
        perfLbl.Position = UDim2.new(0, 66, 0, 22)
        perfLbl.BackgroundTransparency = 1
        perfLbl.Text = "FPS --  /  --ms"
        perfLbl.TextColor3 = Color3.new(math.clamp(ACC.R*0.95,0,1), math.clamp(ACC.G*0.95,0,1), math.clamp(ACC.B,0,1))
        perfLbl.TextSize = 8
        perfLbl.Font = Enum.Font.GothamMedium
        perfLbl.TextXAlignment = Enum.TextXAlignment.Center
        perfLbl.ZIndex = 102
        perfLbl.Parent = frame

        local pctLbl = Instance.new("TextLabel")
        pctLbl.Name = "PctLbl"
        pctLbl.Size = UDim2.new(0, 42, 0, 14)
        pctLbl.Position = UDim2.new(1, -50, 0, 21)
        pctLbl.BackgroundTransparency = 1
        pctLbl.Text = "0%"
        pctLbl.TextColor3 = ACC
        pctLbl.Font = Enum.Font.GothamBlack
        pctLbl.TextSize = 10
        pctLbl.TextXAlignment = Enum.TextXAlignment.Right
        pctLbl.ZIndex = 102
        pctLbl.Parent = frame

        local rTrack = Instance.new("Frame")
        rTrack.Name = "Track"
        rTrack.Size = UDim2.new(1, -24, 0, 6)
        rTrack.Position = UDim2.new(0, 12, 1, -10)
        rTrack.BackgroundColor3 = Color3.new(ACC.R*0.25, ACC.G*0.3, ACC.B*0.4)
        rTrack.BackgroundTransparency = 0.35
        rTrack.BorderSizePixel = 0
        rTrack.ZIndex = 101
        rTrack.ClipsDescendants = true
        rTrack.Parent = frame
        Instance.new("UICorner", rTrack).CornerRadius = UDim.new(0, 3)

        local fillLine = Instance.new("Frame")
        fillLine.Name = "ProgressFill"
        fillLine.Size = UDim2.new(0, 0, 1, 0)
        fillLine.Position = UDim2.new(0, 0, 0, 0)
        fillLine.BackgroundColor3 = ACC
        fillLine.BackgroundTransparency = 0
        fillLine.BorderSizePixel = 0
        fillLine.ZIndex = 102
        fillLine.Visible = true
        fillLine.Parent = rTrack
        Instance.new("UICorner", fillLine).CornerRadius = UDim.new(0, 3)
        local fillGrad = Instance.new("UIGradient")
        fillGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, ACC_DARK),
            ColorSequenceKeypoint.new(0.3, ACC),
            ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.82, ACC),
            ColorSequenceKeypoint.new(1, ACC_DARK),
        fillGrad.Parent = fillLine

        stealProgressFill = fillLine
        progressPct = pctLbl

        _G._NoxaRitualBar = {
            gui = stealGui,
            frame = frame,
            fill = fillLine,
            pct = pctLbl,
            state = stateLbl,
            perf = perfLbl,
            dot = dot,
            stroke = sbStroke,
            bgGrad = sbBgGrad,
            track = rTrack,
            side = sideAccent,
            getAcc = _liveAcc,

        task.defer(function()
            pcall(function()
                if _G.NoxaRefreshStealBarAccent then
                    _G.NoxaRefreshStealBarAccent(_liveAcc())
                end
            end)
        end)

        pcall(function()
            local dragging, dragStart, startPos = false, nil, nil
            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    dragStart = input.Position
                    startPos = frame.Position
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                        end
                    end)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch) then
                    local d = input.Position - dragStart
                    frame.Position = UDim2.new(
                        startPos.X.Scale, startPos.X.Offset + d.X,
                        startPos.Y.Scale, startPos.Y.Offset + d.Y)
                end
            end)
        end)

        if not _G._NoxaRitualV1Loop then
            _G._NoxaRitualV1Loop = true
            task.spawn(function()
                while true do
                    task.wait(0.05)
                    local rb = rawget(_G, "_NoxaRitualBar")
                    if SpeedSystem.stealBarStyle ~= "V1" then
                        if rb and rb.gui then pcall(function() rb.gui.Enabled = false end) end
                    else
                        if not rb or not rb.gui or not rb.gui.Parent then

                            _G._NoxaRitualV1Loop = false
                            break
                        end
                        rb.gui.Enabled = true
                        if rb.frame then rb.frame.Visible = true end
                        if stealProgressBar then stealProgressBar.Visible = false end
                        if rb.fill and rb.fill.Parent then
                            stealProgressFill = rb.fill
                            progressPct = rb.pct
                            if _spaceProg and (_spaceProg.active or (StealRT and StealRT.isStealing)) then
                                p = math.clamp(tonumber(_spaceProg.lastFillPct) or 0, 0, 1)
                                if not _spaceProg.active and StealRT and StealRT.isStealing then
                                    _spaceProg.active = true
                                    _spaceProg.startTime = stealStartTimeRender or tick()
                                    _spaceProg.duration = SpeedSystem.stealDuration or 1.3
                                end
                            else
                                pcall(function() p = math.clamp(rb.fill.Size.X.Scale or 0, 0, 1) end)
                            end
                            rb.fill.Size = UDim2.new(p, 0, 1, 0)
                            rb.fill.Visible = true
                            if rb.pct then rb.pct.Text = math.floor(p * 100 + 0.5) .. "%" end
                        end
                        local ready = SpeedSystem.autoStealEnabled == true
                        local stealing = StealRT and StealRT.isStealing == true

                        local live = (typeof(ACCENT) == "Color3" and ACCENT)
                            or (rb.getAcc and rb.getAcc())
                            or Color3.fromRGB(70, 170, 255)
                        local liveDark = Color3.new(live.R * 0.4, live.G * 0.4, live.B * 0.45)
                        local liveLight = Color3.new(
                            math.clamp(live.R * 1.05, 0, 1),
                            math.clamp(live.G * 1.05, 0, 1),
                            math.clamp(live.B * 1.02, 0, 1)
                        if rb.state then
                            if not ready then
                                rb.state.Text = "OFF"
                                rb.state.TextColor3 = liveLight
                            elseif stealing then
                                rb.state.Text = "STEALING"
                                rb.state.TextColor3 = live
                            else
                                rb.state.Text = "SEARCHING"
                                rb.state.TextColor3 = liveLight
                            end
                        end
                        if rb.dot then
                            rb.dot.BackgroundColor3 = (ready and stealing) and live or liveDark
                        end
                        if rb.stroke then
                            rb.stroke.Color = ready and live or liveDark
                        end
                        if rb.side then rb.side.BackgroundColor3 = live end
                        if rb.pct then rb.pct.TextColor3 = live end
                        if rb.perf then
                            local fps, ping = 0, 0
                            pcall(function() fps = math.floor(workspace:GetRealPhysicsFPS() + 0.5) end)
                            pcall(function()
                                local s = game:GetService("Stats")
                                    and s.Network.ServerStatsItem["Data Ping"]
                                if item then ping = math.floor((item:GetValue() or 0) + 0.5) end
                            end)
                            rb.perf.Text = "FPS " .. tostring(fps) .. "  /  " .. tostring(ping) .. "ms"
                            rb.perf.TextColor3 = liveLight
                        end
                        if rb.fill then
                            rb.fill.BackgroundColor3 = live
                        end
                    end
                end
            end)
        else
            local rb = rawget(_G, "_NoxaRitualBar")
            if rb and rb.gui then
                rb.gui.Enabled = true
                if rb.frame then rb.frame.Visible = true end
            end
        end

    end

    if style == "V2" then

        pcall(function()
            if stealProgressBar then stealProgressBar.Visible = true end
            local rb = rawget(_G, "_NoxaRitualBar")
            if rb and rb.gui then rb.gui.Enabled = false end
        end)
        stealProgressBar.Size = UDim2.new(0, 370, 0, 40)

        stealProgressBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        stealProgressBar.BackgroundTransparency = 1
        stealProgressBar.ClipsDescendants = false
        local corner = stealProgressBar:FindFirstChildOfClass("UICorner")
        if not corner then
            corner = Instance.new("UICorner")
            corner.Parent = stealProgressBar
        end
        corner.CornerRadius = UDim.new(1, 0)
        if pbStroke then
            pbStroke.Color = ACCENT or Color3.fromRGB(70, 170, 255)
            pbStroke.Thickness = 0
            pbStroke.Transparency = 1
            pbStroke.Enabled = false
        end

        if modeBtn then modeBtn.Visible = false end
        if track then track.Visible = false end
        if progressRadLbl then progressRadLbl.Visible = true end

        if not fillRegion then
            fillRegion = Instance.new("Frame")
            fillRegion.Name = "AceFillRegion"
            fillRegion.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
            fillRegion.BackgroundTransparency = 0
            fillRegion.BorderSizePixel = 0
            fillRegion.ClipsDescendants = true
            fillRegion.ZIndex = 2
            fillRegion.Parent = stealProgressBar
            Instance.new("UICorner", fillRegion).CornerRadius = UDim.new(1, 0)
            local frStroke = Instance.new("UIStroke")
            frStroke.Name = "AceFillStroke"
            frStroke.Color = ACCENT
            frStroke.Thickness = 1
            frStroke.Transparency = 0.6
            frStroke.Parent = fillRegion
        end
        fillRegion.Size = UDim2.new(0, 230, 1, -10)
        fillRegion.Position = UDim2.new(0, 6, 0, 5)
        fillRegion.Visible = true
        fillRegion.ClipsDescendants = true
        fillRegion.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        fillRegion.BackgroundTransparency = 0
            local fc = fillRegion:FindFirstChildOfClass("UICorner")
            if not fc then fc = Instance.new("UICorner", fillRegion) end
            fc.CornerRadius = UDim.new(1, 0)
        end
        if track then track.Visible = false end
        local _v3bg = stealProgressBar:FindFirstChild("NoxaV3FillBg")
        if _v3bg then _v3bg.Visible = false end
        for _, child in ipairs(stealProgressBar:GetDescendants()) do
            if child.Name == "ProgressFill" and child.Parent ~= fillRegion then
                child.Visible = false
                child.Size = UDim2.new(0, 0, 1, 0)
            end
        end
        local aceFill = fillRegion:FindFirstChild("ProgressFill") or stealProgressFill
        if aceFill then
            stealProgressFill = aceFill
            stealProgressFill.Parent = fillRegion
            stealProgressFill.Size = UDim2.new(0, 0, 1, 0)
            stealProgressFill.Position = UDim2.new(0, 0, 0, 0)

            stealProgressFill.BackgroundColor3 = ACCENT or Color3.fromRGB(70, 170, 255)
            stealProgressFill.BackgroundTransparency = 0
            stealProgressFill.BorderSizePixel = 0
            stealProgressFill.Visible = true
            stealProgressFill.ZIndex = 3
            local fillCorner = stealProgressFill:FindFirstChildOfClass("UICorner")
            if not fillCorner then
                fillCorner = Instance.new("UICorner")
                fillCorner.Parent = stealProgressFill
            end
            fillCorner.CornerRadius = UDim.new(1, 0)
            fillRegion.ClipsDescendants = true
            local fg = stealProgressFill:FindFirstChildOfClass("UIGradient")
            if fg then
                local A = ACCENT or Color3.fromRGB(70, 170, 255)
                fg.Color = ColorSequence.new(
                    Color3.new(math.min(1, A.R + 0.2), math.min(1, A.G + 0.2), math.min(1, A.B + 0.2)),
                    Color3.new(A.R * 0.7, A.G * 0.7, A.B * 0.7)
            end
        end

        if not stealLbl then
            stealLbl = Instance.new("TextLabel")
            stealLbl.Name = "StealStyleLabel"
            stealLbl.BackgroundTransparency = 1
            stealLbl.Font = Enum.Font.GothamSemibold
            stealLbl.TextSize = 13
            stealLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            stealLbl.TextXAlignment = Enum.TextXAlignment.Left
            stealLbl.ZIndex = 5
            stealLbl.Parent = fillRegion
        else
            stealLbl.Parent = fillRegion
        end
        stealLbl.Text = "STEAL"
        stealLbl.Size = UDim2.new(0, 55, 1, 0)
        stealLbl.Position = UDim2.new(0, 10, 0, 0)
        stealLbl.Visible = true

        if not progressPct or not progressPct.Parent then
            progressPct = Instance.new("TextLabel")
            progressPct.Name = "ProgressPct"
            progressPct.BackgroundTransparency = 1
        end

        progressPct.Parent = fillRegion
        progressPct.Size = UDim2.new(0, 50, 1, 0)
        progressPct.Position = UDim2.new(1, -55, 0, 0)
        progressPct.Visible = false
        progressPct.Text = ""
        progressPct.ZIndex = 10

        if not progressRadLbl or not progressRadLbl.Parent then
            progressRadLbl = Instance.new("TextLabel")
            progressRadLbl.Name = "ProgressRad"
            progressRadLbl.BackgroundTransparency = 1
        end

        stealProgressBar.ClipsDescendants = false
        local fpsBg = stealProgressBar:FindFirstChild("AceFpsBg")
        if not fpsBg then
            fpsBg = Instance.new("Frame")
            fpsBg.Name = "AceFpsBg"
            fpsBg.BorderSizePixel = 0
            fpsBg.Parent = stealProgressBar
            Instance.new("UICorner", fpsBg).CornerRadius = UDim.new(1, 0)
        end
        fpsBg.Size = UDim2.new(0, 128, 1, -10)
        fpsBg.Position = UDim2.new(1, -134, 0, 5)
        fpsBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        fpsBg.BackgroundTransparency = 0
        fpsBg.Visible = true
        fpsBg.ZIndex = 2

        progressRadLbl.Parent = fpsBg
        progressRadLbl.Size = UDim2.new(1, -12, 1, 0)
        progressRadLbl.Position = UDim2.new(0, 6, 0, 0)
        progressRadLbl.TextXAlignment = Enum.TextXAlignment.Center
        progressRadLbl.TextYAlignment = Enum.TextYAlignment.Center
        progressRadLbl.Font = Enum.Font.GothamMedium
        progressRadLbl.TextSize = 11
        progressRadLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
        progressRadLbl.BackgroundTransparency = 1
        progressRadLbl.Visible = true
        progressRadLbl.ZIndex = 20
        if not progressRadLbl.Text or progressRadLbl.Text == "" then
            progressRadLbl.Text = "60 FPS  |  0ms"
        end

        if modeBtn then modeBtn.Visible = false end
        if track then track.Visible = false end

        if stealLbl then
            stealLbl.Size = UDim2.new(0, 70, 1, 0)
            stealLbl.Text = "STEAL"
            stealLbl.TextTruncate = Enum.TextTruncate.None
        end
    end

    pcall(function()
        local barStyle = SpeedSystem.stealBarStyle or "V3"

        if barStyle == "V1" then
            if stealProgressBar then stealProgressBar.Visible = false end
            local rb = rawget(_G, "_NoxaRitualBar")
            if rb and rb.gui then
                pcall(function() rb.gui.Enabled = true end)
                pcall(function() if rb.frame then rb.frame.Visible = true end end)
                if rb.fill and rb.fill.Parent then
                    stealProgressFill = rb.fill
                    stealProgressFill.Visible = true
                end
                if rb.pct then progressPct = rb.pct end
            end
            return
        end

        if stealProgressBar then stealProgressBar.Visible = true end
        local rb = rawget(_G, "_NoxaRitualBar")
        if rb and rb.gui then rb.gui.Enabled = false end
        for _, parent in ipairs({PlayerGui, game:GetService("CoreGui")}) do
            local o = parent:FindFirstChild("NoxaRitualStealBar")
            if o then o.Enabled = false end
        end

        if modeBtn and modeBtn.Parent then
            modeBtn.Visible = false
        end
        local styleLbl = stealProgressBar and stealProgressBar:FindFirstChild("StealStyleLabel")
        if styleLbl then styleLbl.Visible = (barStyle == "V2") end
        local tr = stealProgressBar and stealProgressBar:FindFirstChild("Track")
        if tr then tr.Visible = false end
        local ace = stealProgressBar and stealProgressBar:FindFirstChild("AceFillRegion")
        if ace then ace.Visible = (barStyle == "V2") end
        local fpsBg2 = stealProgressBar and stealProgressBar:FindFirstChild("AceFpsBg")
        if fpsBg2 then fpsBg2.Visible = (barStyle == "V2") end

        if ensureStealBarRefs then ensureStealBarRefs() end
        if stealProgressFill and stealProgressFill.Parent then
            stealProgressFill.Visible = true
            stealProgressFill.Size = UDim2.new(0, 0, 1, 0)
        end
        if barStyle == "V3" and stealProgressBar then
            local saved = tonumber(stealProgressBar:GetAttribute("V3Scale"))
                or tonumber(SpeedSystem.v3BarScale) or 1
            saved = math.clamp(saved, 0.6, 1.6)
            local sc = stealProgressBar:FindFirstChild("V3BarScale")
            if not sc then
                sc = Instance.new("UIScale")
                sc.Name = "V3BarScale"
                sc.Parent = stealProgressBar
            end
            sc.Scale = saved
            stealProgressBar:SetAttribute("V3Scale", saved)
            SpeedSystem.v3BarScale = saved
        end
    end)
end

local function setBarState(state)
    if progressPct then
        local style = SpeedSystem.stealBarStyle or "V1"
        if style == "V2" or style == "V3" then
            progressPct.Visible = false
            progressPct.Text = ""
        else
            progressPct.Visible = true
            progressPct.TextColor3 = Color3.fromRGB(255,255,255)
            if not progressPct.Text or progressPct.Text == "" then
                progressPct.Text = "0%"
            end
        end
    end
    if pbStroke and SpeedSystem.stealBarStyle ~= "V3" then
        if state == "STEALING" then
            TweenService:Create(pbStroke, TweenInfo.new(0.15), {Transparency = 0.25}):Play()
        else
            TweenService:Create(pbStroke, TweenInfo.new(0.15), {Transparency = 0.55}):Play()
        end
    end

    pcall(function()
        if not stealProgressBar then return end
        local s = tostring(state or "IDLE"):upper()

        local v3 = _G._NoxaStealV3
        if v3 and v3.stateLbl then
            if s == "STEALING" or s == "HOLD" or s == "AUTO" then
                v3.stateLbl.Text = "BRAINROT"
            else
                v3.stateLbl.Text = "BRAINROT"
            end
        end
        if v3 and v3.modeChip then
            local modeName = tostring(SpeedSystem.stealMode or "V1"):upper()
            if modeName == "V2 SEMI" then modeName = "SEMI" end
            if s == "STEALING" or s == "HOLD" then
                v3.modeChip.Text = "STEAL"
            else
                v3.modeChip.Text = modeName
            end
        end
        local pill = stealProgressBar:FindFirstChild("ModePill") or stealProgressBar:FindFirstChild("NoxaV3ModeChip")
        if pill then
            if s == "STEALING" or s == "HOLD" or s == "AUTO" then
                pill.Text = "STEAL"
                pill.BackgroundColor3 = Color3.fromRGB(224, 38, 45)
                pill.TextColor3 = Color3.fromRGB(255,255,255)
            else
                local modeName = tostring(SpeedSystem.stealMode or "V1"):upper()
                if modeName == "V2 SEMI" then modeName = "SEMI" end
                pill.Text = modeName
                pill.BackgroundColor3 = (typeof(ACCENT) == "Color3" and ACCENT) or Color3.fromRGB(70, 170, 255)
                pill.TextColor3 = Color3.fromRGB(255,255,255)
            end
        end
        local br = stealProgressBar:FindFirstChild("BrainrotLbl") or stealProgressBar:FindFirstChild("NoxaV3Brainrot", true)
        if br then br.Text = "BRAINROT" end
    end)
end

local function ensureStealBarRefs()

    if not stealProgressBar or not stealProgressBar.Parent then
        local gui = PlayerGui:FindFirstChild("NoxaHub")
        if gui then
            local sp = gui:FindFirstChild("StealProgressBar", true)
            if sp then stealProgressBar = sp end
        end
        if not stealProgressBar or not stealProgressBar.Parent then
            for _, g in ipairs(PlayerGui:GetChildren()) do
                local sp = g:FindFirstChild("StealProgressBar", true)
                if sp then stealProgressBar = sp; break end
            end
        end
    end
    if not stealProgressBar then return false end

    local style = SpeedSystem.stealBarStyle or "V3"

    if style == "V1" then
        local rb = rawget(_G, "_NoxaRitualBar")
        if rb and rb.fill and rb.fill.Parent then
            stealProgressFill = rb.fill
            if rb.pct then progressPct = rb.pct end
            return true
        end
    end

    if style == "V2" then
        local ace = stealProgressBar:FindFirstChild("AceFillRegion")
        if ace then
            local fill = ace:FindFirstChild("ProgressFill")
            if fill and fill:IsA("Frame") then
                stealProgressFill = fill
            end
        end

    elseif style == "V3" then
        local barBg = stealProgressBar:FindFirstChild("NoxaV3FillBg")
        if barBg then
            local fill = barBg:FindFirstChild("ProgressFill")
            if fill and fill:IsA("Frame") then
                stealProgressFill = fill
            end
        end
    else
        local fill = stealProgressBar:FindFirstChild("ProgressFill", true)
        if fill and fill:IsA("Frame") then
            stealProgressFill = fill
        end
    end

    local fill = stealProgressFill
    if fill and fill:IsA("Frame") then
        stealProgressFill = fill
        pcall(function()
            stealProgressFill.Visible = true
            if stealProgressFill.Size.X.Scale == 0 and stealProgressFill.Size.X.Offset == 0 then

            end
        end)
    else

        local parent = stealProgressBar:FindFirstChild("NoxaV3FillBg")
            or stealProgressBar:FindFirstChild("AceFillRegion")
            or stealProgressBar:FindFirstChild("Track")
            or stealProgressBar
        if parent then
            local nf = Instance.new("Frame")
            nf.Name = "ProgressFill"
            nf.BackgroundColor3 = ACCENT or Color3.fromRGB(70, 170, 255)
            nf.BorderSizePixel = 0
            nf.Size = UDim2.new(0, 0, 1, 0)
            nf.ZIndex = (parent.ZIndex or 1) + 1
            nf.Parent = parent
            Instance.new("UICorner", nf).CornerRadius = UDim.new(1, 0)
            stealProgressFill = nf
        end
    end
    local tr = stealProgressBar:FindFirstChild("Track")
    if tr then track = tr end
    local pct = stealProgressBar:FindFirstChild("ProgressPct", true)
    if pct and pct:IsA("TextLabel") then
        progressPct = pct
    end
    local rad = stealProgressBar:FindFirstChild("ProgressRad", true)
    if rad and rad:IsA("TextLabel") then
        progressRadLbl = rad
    end
    local mb = stealProgressBar:FindFirstChild("ModeBtn") or stealProgressBar:FindFirstChildWhichIsA("TextButton")
    if mb and mb:IsA("TextButton") and (mb.Text == "N" or mb.Text == "S" or mb.Name == "ModeBtn") then
        modeBtn = mb
    end
    local st = stealProgressBar:FindFirstChildOfClass("UIStroke")
    if st then pbStroke = st end
    return stealProgressFill ~= nil and stealProgressFill.Parent ~= nil
end

local function updateProgressBar(progress)
    progress = math.clamp(tonumber(progress) or 0, 0, 1)
    ensureStealBarRefs()
    _spaceEnsureRefs()

    if progress > 0 then
        _spaceProg.active = true
        if _spaceProg.startTime <= 0 then
            _spaceProg.startTime = stealStartTimeRender or tick()
        end
        _spaceProg.duration = SpeedSystem.stealDuration or 1.3
    end
    if progress >= 1 then
        _spaceProg.lastFillPct = 1
    end

    local fill = stealProgressFill
    if SpeedSystem.stealBarStyle == "V1" then
        local rb = rawget(_G, "_NoxaRitualBar")
        if rb and rb.fill and rb.fill.Parent then
            fill = rb.fill
            stealProgressFill = fill
            if rb.pct then progressPct = rb.pct end
        end
    elseif not fill or not fill.Parent then
        if stealProgressBar then
            local style = SpeedSystem.stealBarStyle or "V3"
            if style == "V2" then
                local ace = stealProgressBar:FindFirstChild("AceFillRegion")
                fill = ace and ace:FindFirstChild("ProgressFill")
            elseif style == "V3" then
                local bg = stealProgressBar:FindFirstChild("NoxaV3FillBg")
                fill = bg and bg:FindFirstChild("ProgressFill")
            end
            if not fill then
                fill = stealProgressBar:FindFirstChild("ProgressFill", true)
            end
            stealProgressFill = fill
        end
    end
    if fill and fill.Parent then
        pcall(function()
            fill.Visible = true
            fill.Size = UDim2.new(progress, 0, 1, 0)
            TweenService:Create(fill, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {
                Size = UDim2.new(progress, 0, 1, 0)
            }):Play()
        end)
    end
        local style = SpeedSystem.stealBarStyle or "V1"
        if style == "V2" or style == "V3" then
            if progressPct then
                progressPct.Visible = false
                progressPct.Text = ""
            end
        else
            if progressPct and progressPct.Parent then
                progressPct.Visible = true
                progressPct.Text = math.floor(progress * 100 + 0.5) .. "%"
            elseif stealProgressBar then
                local pct = stealProgressBar:FindFirstChild("ProgressPct", true)
                if pct then
                    progressPct = pct
                    pct.Visible = true
                    pct.Text = math.floor(progress * 100 + 0.5) .. "%"
                end
            end
        end
    end

    if progress >= 1 and StealRT.lastProgress < 1 then
        shake()
    end
    StealRT.lastProgress = progress
end

local function resetProgressBar()
    _spaceProg.active = false
    _spaceProg.startTime = 0
    _spaceProg.lastFillPct = 0
    updateProgressBar(0)
    setBarState("IDLE")
end

local function getHRP()
    local char = LP.Character
    if char then
        return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    end
    return nil
end

local V4_MODE_CFG = {
    [1] = { threshold = 0.75, nearDist = 10 },
    [2] = { threshold = 0.80, nearDist = 11 },
    [3] = { threshold = 0.85, nearDist = 12 },
    [4] = { threshold = 0.90, nearDist = 14 },

local V4_DEFAULTS = {
    modeLevel     = 1,
    threshold     = V4_MODE_CFG[1].threshold,
    nearDist      = V4_MODE_CFG[1].nearDist,
    waitNearMax   = 4,
    stealRadius   = 60,
    stealDuration = 1.3,
_G.NoxaV4Defaults = V4_DEFAULTS
_G.NoxaV4ModeCfg  = V4_MODE_CFG

local function getPromptPosition(prompt)
    if not prompt then return nil end
    local att = prompt:FindFirstChild("Attachment")
    if att and att:IsA("Attachment") then
        return att.WorldPosition or att.Position
    end
    local parent = prompt.Parent
    if parent and parent:IsA("Attachment") then
        return parent.WorldPosition or parent.Position
    end
    if parent and parent:IsA("BasePart") then return parent.Position end
    if parent and parent.Parent and parent.Parent:IsA("BasePart") then return parent.Parent.Position end
    if parent and parent.Parent and parent.Parent.Parent and parent.Parent.Parent:IsA("BasePart") then
        return parent.Parent.Parent.Position
    end
    return nil
end

local function isMyPlot(plotName)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
    end
    return false
end

local function findNearestPrompt()
    local hrp = getHRP()
    if not hrp then return nil end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local bestPrompt, bestDist = nil, math.huge
    local radius = SpeedSystem.stealRadius

    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") and not isMyPlot(plot.Name) then
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                for _, pod in ipairs(pods:GetChildren()) do
                    local base = pod:FindFirstChild("Base")
                    if base then
                        local spawn = base:FindFirstChild("Spawn")
                        if spawn then
                            local dist = (spawn.Position - hrp.Position).Magnitude
                            if dist <= radius and dist < bestDist then
                                local att = spawn:FindFirstChild("PromptAttachment")
                                if att then
                                    for _, prompt in ipairs(att:GetChildren()) do
                                        if prompt:IsA("ProximityPrompt") and prompt.ActionText and prompt.ActionText:find("Steal") then
                                            bestPrompt, bestDist = prompt, dist
                                        end
                                    end
                                end
                                if not bestPrompt then
                                    for _, prompt in ipairs(spawn:GetDescendants()) do
                                        if prompt:IsA("ProximityPrompt") and prompt.ActionText and prompt.ActionText:find("Steal") then
                                            bestPrompt, bestDist = prompt, dist
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return bestPrompt
end

local function executeSteal(prompt)
    if StealRT.isStealing then return end
    if not StealRT.dataCache[prompt] then
        local data = {hold = {}, trigger = {}, ready = true}
        if getconnections then
            local holds = getconnections(prompt.PromptButtonHoldBegan)
            for _, conn in ipairs(holds) do
                if conn.Function then table.insert(data.hold, conn.Function) end
            end
            local triggers = getconnections(prompt.Triggered)
            for _, conn in ipairs(triggers) do
                if conn.Function then table.insert(data.trigger, conn.Function) end
            end
        end
        StealRT.dataCache[prompt] = data
    end
    local data = StealRT.dataCache[prompt]
    if not data.ready then return end
    data.ready = false
    StealRT.isStealing = true
    stealStartTimeRender = tick()
    local startTime = tick()
    local duration = SpeedSystem.stealDuration

    _spaceProg.active = true
    _spaceProg.startTime = startTime
    _spaceProg.duration = duration or 1.3
    _spaceProg.lastFillPct = 0
    setBarState("STEALING")
    pcall(function() updateProgressBar(0.02) end)

    if SpeedSystem.stealMode == "V2 SEMI" then

        local hrp = getHRP()
        local spawnPos = nil

        local plots = workspace:FindFirstChild("Plots")
        if plots then
            for _, plot in ipairs(plots:GetChildren()) do
                if plot:IsA("Model") and not isMyPlot(plot.Name) then
                    local pods = plot:FindFirstChild("AnimalPodiums")
                    if pods then
                        for _, pod in ipairs(pods:GetChildren()) do
                            local base = pod:FindFirstChild("Base")
                            local spawn = base and base:FindFirstChild("Spawn")
                            if spawn then
                                local att = spawn:FindFirstChild("PromptAttachment")
                                if att then
                                    for _, p in ipairs(att:GetChildren()) do
                                        if p == prompt then
                                            spawnPos = spawn.Position
                                            break
                                        end
                                    end
                                end
                                if spawnPos then break end
                            end
                        end
                    end
                    if spawnPos then break end
                end
            end
        end

        task.spawn(function()
            for _, fn in ipairs(data.hold) do task.spawn(function() pcall(fn) end) end
            local holdMin = SpeedSystem.v2SemiHoldMin or 1.3
            local holdMax = SpeedSystem.v2SemiHoldMax or 2.6
            local entryDelay = SpeedSystem.v2SemiEntryDelay or 0.3
            local radius = SpeedSystem.v2SemiRadius or 10

            while SpeedSystem.autoStealEnabled and SpeedSystem.stealMode == "V2 SEMI" and tick() - startTime < holdMin do
                local elapsed = tick() - startTime
                local prog = math.clamp(elapsed / holdMax, 0, 1)
                updateProgressBar(prog)
                task.wait()
            end

            local alreadyInRange = spawnPos and hrp and (spawnPos - hrp.Position).Magnitude <= radius
            local fired = false
            while SpeedSystem.autoStealEnabled and SpeedSystem.stealMode == "V2 SEMI" and prompt.Parent do
                local elapsed = tick() - startTime
                if elapsed > holdMax then break end
                local prog = math.clamp(elapsed / holdMax, 0, 1)
                updateProgressBar(prog)

                if spawnPos and hrp then
                    local dist = (spawnPos - hrp.Position).Magnitude
                    if dist <= radius then
                        if not alreadyInRange then task.wait(entryDelay) end
                        if SpeedSystem.autoStealEnabled and SpeedSystem.stealMode == "V2 SEMI" then
                            for _, fn in ipairs(data.trigger) do task.spawn(function() pcall(fn) end) end
                            fired = true
                            break
                        end
                    end
                end
                task.wait()
            end

            if fired then updateProgressBar(1) end
            task.wait(0.05)
            data.ready = true
            StealRT.isStealing = false
            resetProgressBar()
        end)
    elseif SpeedSystem.stealMode == "V3" then

        local function promptDist()
            local hrp = getHRP()
            if not hrp then return math.huge end
            local part = prompt.Parent
            if part and part:IsA("Attachment") then part = part.Parent end
            if part and part:IsA("BasePart") then return (part.Position - hrp.Position).Magnitude end
            local ok, cf = pcall(function() return prompt.Parent and prompt.Parent.WorldPosition end)
            if ok and cf then return (cf - hrp.Position).Magnitude end
            return math.huge
        end

        local halfHoldMin = SpeedSystem.v3HalfHoldMin or 1.3
        local halfHoldMax = SpeedSystem.v3HalfHoldMax or 2.6
        local halfFireRange = SpeedSystem.v3HalfFireRange or 10
        local halfEntryDelay = SpeedSystem.v3HalfEntryDelay or 0.3

        task.spawn(function()
            for _, fn in ipairs(data.hold) do task.spawn(fn) end

            if StealRT.progressConn then StealRT.progressConn:Disconnect() end
            StealRT.progressConn = RunService.Heartbeat:Connect(function()
                if not StealRT.isStealing then
                    if StealRT.progressConn then StealRT.progressConn:Disconnect(); StealRT.progressConn = nil end
                    return
                end
                local elapsed = tick() - startTime

                if elapsed < halfHoldMin then
                    local prog = math.clamp(elapsed / halfHoldMin * 0.8, 0, 0.8)
                    updateProgressBar(prog)

                elseif elapsed < halfHoldMax then
                    local remainingTime = halfHoldMax - halfHoldMin
                    local timeSince80 = elapsed - halfHoldMin
                    local prog = 0.8 + (timeSince80 / remainingTime) * 0.2
                    updateProgressBar(math.clamp(prog, 0.8, 1))
                else
                    updateProgressBar(1)
                end
            end)

            task.wait(halfHoldMin)
            local inRange = promptDist() <= halfFireRange
            while true do
                local el = tick() - startTime
                if el > halfHoldMax or not prompt.Parent then break end
                if promptDist() <= halfFireRange then
                    if not inRange then task.wait(halfEntryDelay) end
                    for _, fn in ipairs(data.trigger) do task.spawn(fn) end
                    break
                end
                task.wait()
            end
            task.wait(0.05)
            if StealRT.progressConn then StealRT.progressConn:Disconnect(); StealRT.progressConn = nil end
            resetProgressBar()
            data.ready = true
            StealRT.isStealing = false
        end)
    elseif SpeedSystem.stealMode == "V4" then

        local level = math.clamp(tonumber(SpeedSystem.v4ModeLevel) or V4_DEFAULTS.modeLevel, 1, 4)
        local cfg = V4_MODE_CFG[level] or V4_MODE_CFG[V4_DEFAULTS.modeLevel]

        local threshold = cfg.threshold or V4_DEFAULTS.threshold
        local nearDist = cfg.nearDist or V4_DEFAULTS.nearDist
        SpeedSystem.v4Threshold = threshold
        SpeedSystem.v4NearDist = nearDist
        local waitNearMax = tonumber(SpeedSystem.v4WaitNearMax) or V4_DEFAULTS.waitNearMax
        local totalTime = (duration and duration > 0) and duration
            or (tonumber(SpeedSystem.stealDuration) or V4_DEFAULTS.stealDuration)
        local timeToThreshold = totalTime * threshold
        local timeAfterThreshold = totalTime - timeToThreshold

        local phase = "to_threshold"
        local phaseStart = startTime
        local frozenProg = threshold

        if StealRT.progressConn then StealRT.progressConn:Disconnect() end
        StealRT.progressConn = RunService.Heartbeat:Connect(function()
            if not StealRT.isStealing then
                if StealRT.progressConn then StealRT.progressConn:Disconnect(); StealRT.progressConn = nil end
                return
            end
            if phase == "to_threshold" then
                local elapsed = tick() - startTime
                local prog = math.clamp(elapsed / totalTime, 0, threshold)
                updateProgressBar(prog)
            elseif phase == "wait_near" then

                updateProgressBar(frozenProg)
            elseif phase == "after_threshold" then
                local elapsedAfter = tick() - phaseStart
                local prog = math.clamp(threshold + (elapsedAfter / totalTime), 0, 1)

                if timeAfterThreshold > 0 then
                    prog = math.clamp(threshold + (elapsedAfter / timeAfterThreshold) * (1 - threshold), 0, 1)
                else
                    prog = 1
                end
                updateProgressBar(prog)
            end
        end)

        task.spawn(function()

            for _, fn in ipairs(data.hold) do
                pcall(fn)
            end

            while tick() - startTime < timeToThreshold do
                if not SpeedSystem.autoStealEnabled or SpeedSystem.stealMode ~= "V4" then
                    if StealRT.progressConn then StealRT.progressConn:Disconnect(); StealRT.progressConn = nil end
                    data.ready = true
                    StealRT.isStealing = false
                    resetProgressBar()
                    return
                end
                task.wait()
            end

            phase = "wait_near"
            frozenProg = threshold
            updateProgressBar(threshold)

            local stillNear = false
            local hrp = getHRP()
            local targetPos = getPromptPosition(prompt)
            if hrp and targetPos then
                if (targetPos - hrp.Position).Magnitude <= nearDist then
                    stillNear = true
                end
            end

            if not stillNear then
                local holdStart = tick()
                while tick() - holdStart < waitNearMax do
                    if not SpeedSystem.autoStealEnabled or SpeedSystem.stealMode ~= "V4" then
                        if StealRT.progressConn then StealRT.progressConn:Disconnect(); StealRT.progressConn = nil end
                        data.ready = true
                        StealRT.isStealing = false
                        resetProgressBar()
                        return
                    end
                    local hrp2 = getHRP()
                    local tp = getPromptPosition(prompt)
                    if hrp2 and tp and (tp - hrp2.Position).Magnitude <= nearDist then
                        stillNear = true
                        break
                    end

                    updateProgressBar(threshold)
                    task.wait()
                end
                if not stillNear then

                    if StealRT.progressConn then StealRT.progressConn:Disconnect(); StealRT.progressConn = nil end
                    data.ready = true
                    StealRT.isStealing = false
                    resetProgressBar()
                    return
                end
            end

            phase = "after_threshold"
            phaseStart = tick()
            while tick() - phaseStart < timeAfterThreshold do
                if not SpeedSystem.autoStealEnabled or SpeedSystem.stealMode ~= "V4" then
                    if StealRT.progressConn then StealRT.progressConn:Disconnect(); StealRT.progressConn = nil end
                    data.ready = true
                    StealRT.isStealing = false
                    resetProgressBar()
                    return
                end
                task.wait()
            end

            for _, fn in ipairs(data.trigger) do
                pcall(fn)
            end
            task.wait(0.05)
            phase = "done"
            if StealRT.progressConn then StealRT.progressConn:Disconnect(); StealRT.progressConn = nil end
            updateProgressBar(1)
            data.ready = true
            StealRT.isStealing = false
            resetProgressBar()
        end)
    else

        if StealRT.progressConn then StealRT.progressConn:Disconnect() end
        StealRT.progressConn = RunService.Heartbeat:Connect(function()
            if not StealRT.isStealing then
                if StealRT.progressConn then StealRT.progressConn:Disconnect(); StealRT.progressConn = nil end
                return
            end
            local elapsed = tick() - startTime
            local prog = math.clamp(elapsed / duration, 0, 1)
            updateProgressBar(prog)
        end)

        task.spawn(function()
            for _, fn in ipairs(data.hold) do task.spawn(fn) end
            local elapsed = 0
            while elapsed < duration do elapsed = elapsed + task.wait() end
            for _, fn in ipairs(data.trigger) do task.spawn(fn) end
            task.wait(0.05)
            if StealRT.progressConn then StealRT.progressConn:Disconnect(); StealRT.progressConn = nil end
            resetProgressBar()
            data.ready = true
            StealRT.isStealing = false
        end)
    end
end

local function _noxaIsNormalMode()
    local m = tostring(SpeedSystem.stealMode or "Normal")
    return m == "Normal" or m == "V1"
end

local function _noxaIsSemiMode()
    local m = tostring(SpeedSystem.stealMode or "")
    return m == "V2 SEMI" or m == "Semi" or m == "V2" or m == "SEMI"
end

StealRadii = { Normal = 62, Semi = 10 }

_G.K7NormalSteal = _G.K7NormalSteal or {
    enabled = false, radius = 62, duration = 1.3,
    animals = {}, promptCache = {}, internalCache = {},
    scannerStarted = false, isStealing = false,
    stealConn = nil, lastSteal = 0, cooldown = 0.05,

local function _normalGetRoot()
    local c = LP.Character
    if not c then return nil end
    return c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("UpperTorso")
end

local function _normalIsMyBase(plotName)
    local plots = workspace:FindFirstChild("Plots")
    local plot  = plots and plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign   = plot:FindFirstChild("PlotSign")
    local yourBase = sign and sign:FindFirstChild("YourBase")
    return yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled == true
end

local function _normalScanPlots()
    local A = _G.K7NormalSteal
    A.animals = {}
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") and not _normalIsMyBase(plot.Name) then
            local podiums = plot:FindFirstChild("AnimalPodiums")
            if podiums then
                for _, podium in ipairs(podiums:GetChildren()) do
                    if podium:IsA("Model") then
                        local base  = podium:FindFirstChild("Base")
                        local spawn = base and base:FindFirstChild("Spawn")
                        if spawn then
                            table.insert(A.animals, {
                                plot = plot.Name, slot = podium.Name,
                                worldPosition = spawn.Position,
                                uid = plot.Name.."_"..podium.Name,
                        end
                    end
                end
            end
        end
    end
end

local function _normalEnsureScanner()
    local A = _G.K7NormalSteal
    if A.scannerStarted then return end
    A.scannerStarted = true
    task.spawn(function()
        task.wait(1)
        while _G.K7NormalSteal do
            if A.enabled then pcall(_normalScanPlots) end
            task.wait(3)
        end
    end)
end

local function _normalFindPrompt(data)
    if not data then return nil end
    local A = _G.K7NormalSteal
    local cached = A.promptCache[data.uid]
    if cached and cached.Parent then return cached end
    local plots  = workspace:FindFirstChild("Plots")
    local plot   = plots and plots:FindFirstChild(data.plot)
    local pds    = plot and plot:FindFirstChild("AnimalPodiums")
    local pod    = pds  and pds:FindFirstChild(data.slot)
    local base   = pod  and pod:FindFirstChild("Base")
    local spawn  = base and base:FindFirstChild("Spawn")
    local attach = spawn and spawn:FindFirstChild("PromptAttachment")
    if not attach then return nil end
    for _, p in ipairs(attach:GetChildren()) do
        if p:IsA("ProximityPrompt") then
            A.promptCache[data.uid] = p; return p
        end
    end
    return nil
end

local function _normalCacheCallbacks(prompt)
    local A = _G.K7NormalSteal
    if A.internalCache[prompt] then return end
    local data = {hold={}, trigger={}, ready=true}
    pcall(function()
        if getconnections then
            for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                if type(c.Function)=="function" then table.insert(data.hold, c.Function) end
            end
            for _, c in ipairs(getconnections(prompt.Triggered)) do
                if type(c.Function)=="function" then table.insert(data.trigger, c.Function) end
            end
        end
    end)
    if #data.hold>0 or #data.trigger>0 then A.internalCache[prompt]=data end
end

local function _normalDoSteal(prompt, animalData)
    local A = _G.K7NormalSteal
    if not prompt or not prompt.Parent or A.isStealing then return end
    if tick()-(A.lastSteal or 0) < (A.cooldown or 0.08) then return end
    _normalCacheCallbacks(prompt)
    local data = A.internalCache[prompt]
    if not data or not data.ready then return end
    data.ready = false; A.isStealing = true; A.lastSteal = tick()

    pcall(function()
        StealRT.isStealing = true
        stealStartTimeRender = tick()
        _spaceProg.active = true
        _spaceProg.startTime = tick()
        _spaceProg.duration = A.duration or SpeedSystem.stealDuration or 1.3
        _spaceProg.lastFillPct = 0
    end)
    pcall(function() if _G.StealBar then _G.StealBar.SetState("STEALING") end end)
    task.spawn(function()
        if #data.hold>0 then
            for _, fn in ipairs(data.hold) do task.spawn(function() pcall(fn) end) end
        end
        local FILL_CAP = 0.8
        local HOLD_TIME = 2
        local COMPLETE_RADIUS = 9
        local function inCompleteRange()
            local root = _normalGetRoot()
            if not root or not animalData or not animalData.worldPosition then return false end
            return (root.Position-animalData.worldPosition).Magnitude <= COMPLETE_RADIUS
        end
        local t0 = tick(); local dur = A.duration or 1.3
        while A.enabled and _noxaIsNormalMode() and tick()-t0 < dur do
            local p = math.min((tick()-t0)/dur, FILL_CAP)
            pcall(function() if _G.StealBar then _G.StealBar.SetProgress(p) end end)
            if p >= FILL_CAP then break end
            task.wait(0.02)
        end
        if not A.enabled or not _noxaIsNormalMode() then
            data.ready=true; A.isStealing=false
            pcall(function() StealRT.isStealing = false end)
            pcall(function() if _G.StealBar then _G.StealBar.Reset() end end)
            return
        end
        local holdT0 = tick(); local completed = false
        while A.enabled and _noxaIsNormalMode() and tick()-holdT0 < HOLD_TIME do
            pcall(function() if _G.StealBar then _G.StealBar.SetProgress(FILL_CAP) end end)
            if inCompleteRange() then completed = true break end
            task.wait(0.02)
        end
        if not A.enabled or not _noxaIsNormalMode() or not completed then
            data.ready=true; A.isStealing=false
            pcall(function() if _G.StealBar then _G.StealBar.Reset() end end)
            return
        end
        local t1 = tick(); local fillDur = dur*(1-FILL_CAP)
        while A.enabled and _noxaIsNormalMode() and tick()-t1 < fillDur do
            local p = FILL_CAP + math.min((tick()-t1)/fillDur, 1)*(1-FILL_CAP)
            pcall(function() if _G.StealBar then _G.StealBar.SetProgress(p) end end)
            task.wait(0.02)
        end
        if not A.enabled or not _noxaIsNormalMode() then
            data.ready=true; A.isStealing=false
            pcall(function() if _G.StealBar then _G.StealBar.Reset() end end)
            return
        end
        pcall(function() if _G.StealBar then _G.StealBar.SetProgress(1) end end)
        if #data.trigger>0 then
            for _, fn in ipairs(data.trigger) do task.spawn(function() pcall(fn) end) end
        end
        task.wait(0.12)
        data.ready=true; A.isStealing=false
        pcall(function() StealRT.isStealing = false end)
        pcall(function() if _G.StealBar then _G.StealBar.Reset() end end)
    end)
end

local function _normalNearestAnimal()
    local A = _G.K7NormalSteal
    local root = _normalGetRoot()
    if not root then return nil end
    local best, bestDist = nil, math.huge
    for _, data in ipairs(A.animals) do
        if data.worldPosition and not _normalIsMyBase(data.plot) then
            local dist = (root.Position-data.worldPosition).Magnitude
            if dist < bestDist then best=data; bestDist=dist end
        end
    end
    if best and bestDist <= (tonumber(A.radius) or 62) then return best end
    return nil
end

_G.K7NormalAutoStealStop = function()
    local A = _G.K7NormalSteal
    A.enabled = false; A.isStealing = false
    if A.stealConn then A.stealConn:Disconnect(); A.stealConn=nil end
    pcall(function() if _G.StealBar then _G.StealBar.Reset() end end)
end

_G.K7NormalAutoStealStart = function()
    local A = _G.K7NormalSteal
    A.radius  = tonumber(SpeedSystem.stealRadius) or StealRadii.Normal or 62
    A.duration = tonumber(SpeedSystem.stealDuration) or 1.3
    A.enabled  = true
    _normalEnsureScanner()
    pcall(_normalScanPlots)
    if A.stealConn then A.stealConn:Disconnect(); A.stealConn=nil end
    A.stealConn = RunService.Heartbeat:Connect(function()
        if not A.enabled then return end
        if not _noxaIsNormalMode() then _G.K7NormalAutoStealStop(); return end
        if A.isStealing then return end
        local target = _normalNearestAnimal()
        if not target then return end
        local prompt = _normalFindPrompt(target)
        if prompt then _normalDoSteal(prompt, target) end
    end)
end

_G.K7NormalAutoStealSync = function()
    if _noxaIsNormalMode() and SpeedSystem.autoStealEnabled then
        _G.K7NormalAutoStealStart()
    else
        _G.K7NormalAutoStealStop()
    end
end

_G.K7SemiSteal = _G.K7SemiSteal or {}
local AS = _G.K7SemiSteal
AS.conn         = AS.conn
AS.scanThread   = AS.scanThread
AS.enabled      = false
AS.holdMin      = 1.3
AS.holdMax      = 2.6
AS.entryDelay   = 0.3
AS.cooldown     = 0.05
AS.primeRange   = 80
AS.radius       = tonumber(SpeedSystem.v2SemiRadius) or StealRadii.Semi or 10
AS.plotSync     = AS.plotSync or {caches={}, connections={}}
AS.animals      = AS.animals or {}
AS.promptCache  = AS.promptCache or {}
AS.internalCache = AS.internalCache or {}
AS.state        = AS.state or {active=false, startTime=0, phase="idle", label="", lastResult="", lastResultTime=0}

local function _semiBarSet(p, label)
    pcall(function()
        if _G.StealBar then
            _G.StealBar.SetState(label or "STEALING")
            _G.StealBar.SetProgress(math.clamp(tonumber(p) or 0, 0, 1))
        end
    end)
end
local function _semiBarReset()
    pcall(function() if _G.StealBar then _G.StealBar.Reset() end end)
end

local function _semiRoot()
    local c = LP.Character
    return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("UpperTorso")) or nil
end

local function _splitPath(path)
    if typeof(path)=="table" then return path end
    local out = {}
    for p in string.gmatch(tostring(path), "[^%.]+") do
        table.insert(out, tonumber(p) or p)
    end
    return out
end
local function _resolvePath(path, root)
    local cur, par, key = root, nil, nil
    for _, p in ipairs(_splitPath(path)) do par=cur; key=p; cur=cur and cur[p] or nil end
    return cur, par, key
end
local function _applyDiff(channelName, packet)
    local cache = AS.plotSync.caches[channelName]
    if typeof(cache)~="table" then return end
    local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
    local cur, par, key = _resolvePath(path, cache)
    if action=="Changed" then if par then par[key]=a end
    elseif action=="ArrayInsert" then if cur then table.insert(cur, b, a) end
    elseif action=="ArrayRemoved" then if cur then table.remove(cur, b) end
    elseif action=="DictionaryInsert" then if cur then cur[b]=a end
    elseif action=="DictionaryRemoved" then if cur then cur[b]=nil end
    end
end

local function _semiAttachChannel(remote, plots, requestData)
    if AS.plotSync.connections[remote] then return end
    local channelName = tostring(remote.Name)
    if not plots:FindFirstChild(channelName) then return end
    if requestData and AS.plotSync.caches[channelName]==nil then
        local ok, data = pcall(function() return requestData:InvokeServer(channelName) end)
        AS.plotSync.caches[channelName] = (ok and typeof(data)=="table") and data or {}
    elseif AS.plotSync.caches[channelName]==nil then
        AS.plotSync.caches[channelName] = {}
    end
    AS.plotSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
        for _, packet in ipairs(queue) do _applyDiff(channelName, packet) end
    end)
end

local function _semiEnsureSync()
    if AS.syncReady then return true end
    local ok = pcall(function()
        AS.plots = workspace:WaitForChild("Plots", 3)
        local rs = game:GetService("ReplicatedStorage")
        local pkgs = rs:WaitForChild("Packages", 3)
        local datas = rs:WaitForChild("Datas", 3)
        if not (pkgs and datas and AS.plots) then return end
        AS.animalsData = require(datas:WaitForChild("Animals", 3))
        local sync = pkgs:WaitForChild("Synchronizer", 3)
        AS.channelFolder = sync:WaitForChild("Channel", 3)
        AS.routeRemote   = sync:WaitForChild("CommunicationRoute", 3)
        AS.requestData   = sync:FindFirstChild("RequestData")
        for _, child in ipairs(AS.channelFolder:GetChildren()) do
            if child:IsA("RemoteEvent") then _semiAttachChannel(child, AS.plots, AS.requestData) end
        end
        AS.channelFolder.ChildAdded:Connect(function(child)
            if child:IsA("RemoteEvent") then _semiAttachChannel(child, AS.plots, AS.requestData) end
        end)
        AS.routeRemote.OnClientEvent:Connect(function(actions)
            for _, action in ipairs(actions) do
                local kind, cn = action[1], tostring(action[2])
                if AS.plots and AS.plots:FindFirstChild(cn) then
                    if kind=="ListenerAdded" then
                        local r = AS.channelFolder and AS.channelFolder:FindFirstChild(cn)
                        if r and r:IsA("RemoteEvent") then _semiAttachChannel(r, AS.plots, AS.requestData) end
                    elseif kind=="ListenerRemoved" then
                        for remote, conn in pairs(AS.plotSync.connections) do
                            if tostring(remote.Name)==cn then
                                pcall(function() conn:Disconnect() end)
                                AS.plotSync.connections[remote] = nil
                                AS.plotSync.caches[cn] = nil
                                break
                            end
                        end
                    end
                end
            end
        end)
        AS.syncReady = true
    end)
    return ok and AS.syncReady==true
end

local function _semiPlotOwner(plot)
    local sign  = plot and plot:FindFirstChild("PlotSign")
    local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
    local label = frame and frame:FindFirstChild("TextLabel")
    if not label or label.Text=="Empty Base" then return nil end
    return label.Text:gsub("'s [Bb]ase$",""):gsub("%s+$","")
end
local function _semiIsMyBase(animalData)
    if not animalData or not animalData.plot or not AS.plots then return false end
    local plot = AS.plots:FindFirstChild(animalData.plot)
    if not plot then return false end
    local owner = _semiPlotOwner(plot)
    return owner==LP.DisplayName or owner==LP.Name
end
local function _semiPodiumFor(animalData)
    local plot = AS.plots and AS.plots:FindFirstChild(animalData.plot)
    local pds  = plot and plot:FindFirstChild("AnimalPodiums")
    return pds and pds:FindFirstChild(animalData.slot) or nil
end
local function _semiAnimalPos(animalData)
    local pod = _semiPodiumFor(animalData)
    return pod and pod:GetPivot().Position or nil
end
local function _semiDistToAnimal(animalData)
    local root = _semiRoot()
    local pos  = _semiAnimalPos(animalData)
    return root and pos and (root.Position-pos).Magnitude or math.huge
end
local function _semiFindPrompt(animalData)
    if not animalData then return nil end
    local cached = AS.promptCache[animalData.uid]
    if cached and cached.Parent then return cached end
    local pod    = _semiPodiumFor(animalData)
    local base   = pod and pod:FindFirstChild("Base")
    local spawn  = base and base:FindFirstChild("Spawn")
    local attach = spawn and spawn:FindFirstChild("PromptAttachment")
    if not attach then return nil end
    for _, p in ipairs(attach:GetChildren()) do
        if p:IsA("ProximityPrompt") then AS.promptCache[animalData.uid]=p; return p end
    end
    return nil
end
local function _semiBuildCallbacks(prompt)
    if AS.internalCache[prompt] then return end
    local data = {holdCallbacks={}, triggerCallbacks={}, ready=true}
    local okH, holds = pcall(getconnections, prompt.PromptButtonHoldBegan)
    if okH and type(holds)=="table" then
        for _, c in ipairs(holds) do if type(c.Function)=="function" then table.insert(data.holdCallbacks, c.Function) end end
    end
    local okT, triggers = pcall(getconnections, prompt.Triggered)
    if okT and type(triggers)=="table" then
        for _, c in ipairs(triggers) do if type(c.Function)=="function" then table.insert(data.triggerCallbacks, c.Function) end end
    end
    if #data.holdCallbacks>0 or #data.triggerCallbacks>0 then AS.internalCache[prompt]=data end
end
local function _semiExecute(prompt, animalData)
    if not prompt or not prompt.Parent or not animalData then return false end
    if AS.state.active then return false end
    if tick()-(AS.state.lastResultTime or 0) < (AS.cooldown or 0.05) then return false end
    _semiBuildCallbacks(prompt)
    local data = AS.internalCache[prompt]
    if not data or not data.ready then return false end
    data.ready=false; AS.state.active=true
    AS.state.startTime=tick(); AS.state.phase="holding"
    AS.state.label = animalData.name or "Animal"
    task.spawn(function()
        local t0 = AS.state.startTime
        for _, fn in ipairs(data.holdCallbacks) do task.spawn(function() pcall(fn) end) end
        while AS.enabled and _noxaIsSemiMode() and tick()-t0 < (AS.holdMin or 1.3) do
            _semiBarSet((tick()-t0)/(AS.holdMax or 2.6), "STEALING")
            task.wait()
        end
        AS.state.phase = "waitingRange"
        local alreadyInRange = _semiDistToAnimal(animalData) <= (tonumber(AS.radius) or 10)
        local fired = false
        while AS.enabled and _noxaIsSemiMode() and prompt.Parent do
            local elapsed = tick()-t0
            if elapsed > (AS.holdMax or 2.6) then break end
            _semiBarSet(elapsed/(AS.holdMax or 2.6), "STEALING")
            if _semiDistToAnimal(animalData) <= (tonumber(AS.radius) or 10) then
                if not alreadyInRange then task.wait(AS.entryDelay or 0.3) end
                if AS.enabled and _noxaIsSemiMode() then
                    for _, fn in ipairs(data.triggerCallbacks) do task.spawn(function() pcall(fn) end) end
                    fired = true
                end
                break
            end
            task.wait()
        end
        AS.state.lastResult = fired and ("Stole "..tostring(AS.state.label)) or ("Missed: "..tostring(AS.state.label))
        AS.state.active=false; AS.state.phase="idle"; AS.state.lastResultTime=tick()
        if fired then _semiBarSet(1, "STEALING") end
        task.wait(AS.cooldown or 0.05)
        data.ready=true
        _semiBarReset()
    end)
    return true
end
local function _semiScanAllPlots()
    if not _semiEnsureSync() then return 0 end
    local newCache = {}
    for _, plot in ipairs(AS.plots:GetChildren()) do
        local cache = AS.plotSync.caches[plot.Name]
        local animalList = cache and cache.AnimalList
        if typeof(animalList)=="table" then
            for slot, animalData in pairs(animalList) do
                if type(animalData)=="table" then
                    local animalName = animalData.Index
                    local info = AS.animalsData and AS.animalsData[animalName]
                    if info then
                        table.insert(newCache, {
                            name = info.DisplayName or animalName,
                            plot = plot.Name,
                            slot = tostring(slot),
                            uid  = plot.Name.."_"..tostring(slot),
                    end
                end
            end
        end
    end
    AS.animals = newCache
    return #newCache
end
local function _semiPickClosest()
    local root = _semiRoot()
    if not root then return nil end
    local best, bestDist = nil, math.huge
    for _, data in ipairs(AS.animals) do
        if not _semiIsMyBase(data) then
            local pos  = _semiAnimalPos(data)
            local dist = pos and (root.Position-pos).Magnitude or math.huge
            if dist <= (AS.primeRange or 80) and dist < bestDist then
                best, bestDist = data, dist
            end
        end
    end
    return best
end
local function _semiEnsureScanThread()
    if AS.scanThread then return end
    AS.scanThread = task.spawn(function()
        while _G.K7SemiSteal do
            if AS.enabled or _noxaIsSemiMode() then pcall(_semiScanAllPlots) end
            task.wait(5)
        end
    end)
end

_G.K7SemiAutoStealStop = function()
    AS.enabled = false
    if AS.conn then AS.conn:Disconnect(); AS.conn=nil end
    AS.state.active=false; AS.state.phase="idle"
    _semiBarReset()
end

_G.K7SemiAutoStealStart = function()
    AS.radius  = tonumber(SpeedSystem.v2SemiRadius) or StealRadii.Semi or 10
    AS.holdMin = tonumber(SpeedSystem.v2SemiHoldMin) or 1.3
    AS.holdMax = tonumber(SpeedSystem.v2SemiHoldMax) or 2.6
    AS.entryDelay = tonumber(SpeedSystem.v2SemiEntryDelay) or 0.3
    AS.primeRange = tonumber(SpeedSystem.v2SemiPrimeRange) or 80
    AS.enabled = true
    pcall(_semiEnsureSync)
    _semiEnsureScanThread()
    pcall(_semiScanAllPlots)
    if AS.conn then AS.conn:Disconnect(); AS.conn=nil end
    AS.conn = RunService.Heartbeat:Connect(function()
        if not AS.enabled then return end
        if not _noxaIsSemiMode() then _G.K7SemiAutoStealStop(); return end
        if AS.state.active then return end
        local target = _semiPickClosest()
        if not target then return end
        local prompt = _semiFindPrompt(target)
        if prompt then _semiExecute(prompt, target) end
    end)
end

_G.K7SemiAutoStealSync = function()
    if _noxaIsSemiMode() and SpeedSystem.autoStealEnabled then
        _G.K7SemiAutoStealStart()
    else
        _G.K7SemiAutoStealStop()
    end
end

if not _G.StealBar then
    _G.StealBar = {
        SetState = function(s)
            pcall(function() if setBarState then setBarState(tostring(s or "IDLE")) end end)
            if tostring(s or ""):upper() == "STEALING" or tostring(s or ""):upper() == "HOLD" then
                pcall(function()
                    _spaceProg.active = true
                    if _spaceProg.startTime <= 0 then
                        _spaceProg.startTime = tick()
                        _spaceProg.duration = SpeedSystem.stealDuration or 1.3
                    end
                end)
            end
        end,
        SetProgress = function(p)
            p = math.clamp(tonumber(p) or 0, 0, 1)

            pcall(function()
                if updateProgressBar then
                    updateProgressBar(p)
                else
                    if stealProgressFill and stealProgressFill.Parent then
                        stealProgressFill.Size = UDim2.new(p, 0, 1, 0)
                        stealProgressFill.Visible = true
                    end
                    local lbl = progressPct or (stealProgressBar and stealProgressBar:FindFirstChild("ProgressPct", true))
                    if lbl then
                        local style = SpeedSystem.stealBarStyle or "V1"
                        if style == "V2" or style == "V3" then
                            lbl.Text = ""
                            lbl.Visible = false
                        else
                            lbl.Text = tostring(math.floor(p * 100 + 0.5)) .. "%"
                            lbl.Visible = true
                        end
                    end
                end
            end)
            pcall(function()
                _spaceProg.active = p > 0 and p < 1
                _spaceProg.lastFillPct = p
                if p >= 1 then _spaceProg.active = false end
            end)
        end,
        Reset = function()
            pcall(function()
                _spaceProg.active = false
                _spaceProg.startTime = 0
                _spaceProg.lastFillPct = 0
            end)
            pcall(function() if resetProgressBar then resetProgressBar() end end)
        end,
end

local function startAutoSteal()
    if not SpeedSystem.autoStealEnabled then
        if stopAutoSteal then pcall(stopAutoSteal) end
        return
    end

    if _G.K7NormalAutoStealStop then pcall(_G.K7NormalAutoStealStop) end
    if _G.K7SemiAutoStealStop then pcall(_G.K7SemiAutoStealStop) end
    if StealRT and StealRT.stealConn then
        StealRT.stealConn:Disconnect()
        StealRT.stealConn = nil
    end

    local mode = tostring(SpeedSystem.stealMode or "Normal")
    if mode == "V1" then mode = "Normal" end
    if mode == "Semi" or mode == "V2" or mode == "SEMI" then mode = "V2 SEMI" end

    if mode == "Normal" then

        if _G.K7NormalSteal then
            _G.K7NormalSteal.radius = tonumber(SpeedSystem.stealRadius) or 62
            _G.K7NormalSteal.duration = tonumber(SpeedSystem.stealDuration) or 1.3
        end
        if _G.K7NormalAutoStealStart then _G.K7NormalAutoStealStart() end
        return
    end

    if mode == "V2 SEMI" then

        if _G.K7SemiSteal then
            _G.K7SemiSteal.radius = tonumber(SpeedSystem.v2SemiRadius) or 10
        end
        if _G.K7SemiAutoStealStart then _G.K7SemiAutoStealStart() end
        return
    end

    if StealRT.stealConn then return end
    StealRT.stealConn = RunService.Heartbeat:Connect(function()
        if not SpeedSystem.autoStealEnabled or StealRT.isStealing then return end
        local m = tostring(SpeedSystem.stealMode or "")
        if m == "Normal" or m == "V1" or m == "V2 SEMI" or m == "Semi" then return end
        local success, prompt = pcall(findNearestPrompt)
        if success and prompt then
            if setBarState then setBarState("STEALING") end
            pcall(executeSteal, prompt)
        end
    end)
end

local function stopAutoSteal()
    if _G.K7NormalAutoStealStop then pcall(_G.K7NormalAutoStealStop) end
    if _G.K7SemiAutoStealStop then pcall(_G.K7SemiAutoStealStop) end
    if StealRT and StealRT.stealConn then
        StealRT.stealConn:Disconnect()
        StealRT.stealConn = nil
    end
    if StealRT and StealRT.progressConn then
        StealRT.progressConn:Disconnect()
        StealRT.progressConn = nil
    end
    if StealRT then
        StealRT.isStealing = false
        StealRT.dataCache = {}
    end
    pcall(function() if resetProgressBar then resetProgressBar() end end)
end

lastFrameTime = tick()
local frameSamples = {}
avgFPS = 60

RunService.RenderStepped:Connect(function()
    local now = tick()
    local dt = now - lastFrameTime
    lastFrameTime = now
    if dt > 0 then
        table.insert(frameSamples, 1 / dt)
        if #frameSamples > 20 then table.remove(frameSamples, 1) end
        local sum = 0
        for _, v in ipairs(frameSamples) do sum = sum + v end
        avgFPS = sum / #frameSamples
    end
end)

task.spawn(function()
    local StatsSvc = game:GetService("Stats")
    while true do
        if not stealProgressBar or not stealProgressBar.Parent then
            task.wait(1)
        else
            local ping = 0
            pcall(function()
                local item = StatsSvc.Network.ServerStatsItem:FindFirstChild("Data Ping")
                if item then
                    ping = tonumber(item:GetValue()) or 0
                end
            end)
            if ping == 0 then
                pcall(function()
                    ping = tonumber(StatsSvc.Network:GetPing()) or 0
                end)
            end
            local fpsN = math.floor((avgFPS or 60) + 0.5)
            local pingN = math.floor((ping or 0) + 0.5)

            if SpeedSystem.stealBarStyle ~= "V3" and progressRadLbl and progressRadLbl.Parent then
                progressRadLbl.Text = string.format("%d FPS  |  %dms", fpsN, pingN)
                progressRadLbl.Visible = true
            end
            task.wait(0.5)
        end
    end
end)

Content = NoxaUI.new("Frame", {
    Name="Content", ZIndex=3,
    Position=UDim2.new(0,84,0,56),
    Size=UDim2.new(1,-96,1,-66),
    BackgroundTransparency=1, Parent=Main,

local P_MOVEMENT = NoxaUI.mkPage(Content,"P_MOVEMENT", true)
local P_COMBAT   = NoxaUI.mkPage(Content,"P_COMBAT",   false)
local P_UTILITY  = NoxaUI.mkPage(Content,"P_UTILITY",  false)
local P_CUSTOM   = NoxaUI.mkPage(Content,"P_CUSTOM",   false)
local P_SETTINGS = NoxaUI.mkPage(Content,"P_SETTINGS", false)
pcall(function()
    if MainClip then MainClip.Visible = true end
    if FloatOpen then FloatOpen.Visible = false end
end)
task.wait()

allPages = {
    Movement=P_MOVEMENT, Combat=P_COMBAT,
    Utility=P_UTILITY, Custom=P_CUSTOM, Settings=P_SETTINGS,

local function noxaKeyDisplay(kc)
    if typeof(kc) ~= "EnumItem" then return "-" end
    local map = {
        ButtonA = "A/X", ButtonB = "B/O", ButtonX = "X/Sq", ButtonY = "Y/Tri",
        ButtonL1 = "LB / L1", ButtonR1 = "RB / R1", ButtonL2 = "LT / L2", ButtonR2 = "RT / R2",
        ButtonL3 = "L3", ButtonR3 = "R3",
        ButtonStart = "Start", ButtonSelect = "Select",
        DPadLeft = "D-Left", DPadRight = "D-Right", DPadUp = "D-Up", DPadDown = "D-Down",
    return map[kc.Name] or kc.Name
end
local function noxaIsBindableKey(input)
    if not input or input.KeyCode == Enum.KeyCode.Unknown then return false end
    local ut = input.UserInputType
    if ut == Enum.UserInputType.Keyboard then return true end
    if ut == Enum.UserInputType.Gamepad1 or ut == Enum.UserInputType.Gamepad2
        or ut == Enum.UserInputType.Gamepad3 or ut == Enum.UserInputType.Gamepad4 then
        local n = input.KeyCode.Name
        if n == "Thumbstick1" or n == "Thumbstick2" then return false end
        if n:find("Thumbstick", 1, true) then return false end
        return true
    end
    return false
end

local function noxaClearKeyConflicts(kc, keepId)
    if not kc or kc == Enum.KeyCode.Unknown then return end
    for id, key in pairs(SpeedSystem.keybinds or {}) do
        if id ~= keepId and key == kc then
            SpeedSystem.keybinds[id] = Enum.KeyCode.Unknown
        end
    end
    for _, id in ipairs({
        "dropBrainrotKeybind", "tpDownKeybind",
        "instantResetKeybind", "autoDodgeKeybind",
    }) do
        if id ~= keepId and SpeedSystem[id] == kc then
            SpeedSystem[id] = Enum.KeyCode.Unknown
        end
    end
end

local function mkKeybindActionRow(parent, title, getKey, setKey, bindId)
    local r = NoxaUI.mkRow(parent, 40)
    NoxaUI.mkLabel(r, title)
    local function shortName(kc)
        if typeof(kc) ~= "EnumItem" then return "-" end
        local n = kc.Name
        if n == "LeftControl" then return "LCtrl" end
        if n == "RightControl" then return "RCtrl" end
        if n == "LeftShift" then return "LShift" end
        if n == "RightShift" then return "RShift" end
        if #n > 4 and (n:sub(1,6) == "Button" or n:sub(1,4) == "DPad") then
            return noxaKeyDisplay(kc)
        end
        return n
    end
    local kb = NoxaUI.new("TextButton", {
        ZIndex=20, Position=UDim2.new(1,-64,0.5,-13),
        Size=UDim2.new(0,52,0,26),
        BackgroundColor3=ACCENT,
        BackgroundTransparency=0.72, BorderSizePixel=0,
        Text=shortName(getKey()),
        TextColor3=ACCENT,
        TextSize=11, Font=Enum.Font.GothamBlack,
        AutoButtonColor=false, Parent=r,
    NoxaUI.corner(kb, 13)
    NoxaUI.regAccent(kb)
        local ks = Instance.new("UIStroke")
        ks.Name = "KeyStroke"
        ks.Color = ACCENT
        ks.Thickness = 1
        ks.Transparency = 0.2
        ks.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        ks.Parent = kb
        NoxaUI.regAccent(ks)
    end
    local listening = false
    local conn
    kb.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        _G.NoxaKeyListening = true
        kb.Text = "..."
        if conn then pcall(function() conn:Disconnect() end) conn = nil end
        conn = UserInputService.InputBegan:Connect(function(input, gp)
            if not noxaIsBindableKey(input) then return end
            if input.KeyCode == Enum.KeyCode.Escape then
                if conn then pcall(function() conn:Disconnect() end) conn = nil end
                listening = false
                _G.NoxaKeyListening = false
                kb.Text = shortName(getKey())
                return
            end
            if conn then pcall(function() conn:Disconnect() end) conn = nil end
            listening = false
            _G.NoxaKeyListening = false
            local kc = input.KeyCode
            if bindId and noxaClearKeyConflicts then
                pcall(function() noxaClearKeyConflicts(kc, bindId) end)
            end
            setKey(kc)
            kb.Text = shortName(kc)
            NoxaCfg.saveConfig(true)
            pcall(function()
                if type(notify) == "function" then
                    notify(title .. " · " .. shortName(kc), 1.2)
                end
            end)
        end)
        task.delay(8, function()
            if listening then
                if conn then pcall(function() conn:Disconnect() end) conn = nil end
                listening = false
                _G.NoxaKeyListening = false
                kb.Text = shortName(getKey())
            end
        end)
    end)
    return r, kb
end

NoxaUI.mkSection(P_MOVEMENT, "SPEED")

methodCard = NoxaUI.mkRow(P_MOVEMENT, 64)
    local lbl = NoxaUI.new("TextLabel", {
        ZIndex=5, Position=UDim2.new(0,14,0,6),
        Size=UDim2.new(1,-28,0,16),
        BackgroundTransparency=1,
        Text="Speed Changed Method",
        TextColor3=TEXT_DIM or Color3.fromRGB(150,160,170),
        TextSize=11, Font=Enum.Font.GothamMedium,
        TextXAlignment=Enum.TextXAlignment.Left, Parent=methodCard,
    local track = NoxaUI.new("Frame", {
        ZIndex=5, Position=UDim2.new(0,12,0,28),
        Size=UDim2.new(1,-24,0,28),
        BackgroundColor3=INPUT_BG or Color3.fromRGB(22,26,32),
        BackgroundTransparency=0.1, BorderSizePixel=0, Parent=methodCard,
    NoxaUI.corner(track, 999)
    NoxaUI.darkStroke(track, 1)
    local slider = NoxaUI.new("Frame", {
        Name="MethodSlider", ZIndex=6,
        Position = (SpeedSystem.speedMethod == "V2") and UDim2.new(0.5,2,0,2) or UDim2.new(0,2,0,2),
        Size=UDim2.new(0.5,-4,1,-4),
        BackgroundColor3=ACCENT or Color3.fromRGB(70, 170, 255),
        BorderSizePixel=0, Parent=track,
    NoxaUI.corner(slider, 999)
    NoxaUI.regAccent(slider)
    local v1Btn = NoxaUI.new("TextButton", {
        ZIndex=7, Size=UDim2.new(0.5,0,1,0),
        BackgroundTransparency=1, Text="V1",
        TextColor3 = (SpeedSystem.speedMethod ~= "V2") and Color3.fromRGB(255,255,255) or (TEXT_DIM or Color3.fromRGB(140,150,160)),
        TextSize=12, Font=Enum.Font.GothamBold,
        AutoButtonColor=false, Parent=track,
    local v2Btn = NoxaUI.new("TextButton", {
        ZIndex=7, Position=UDim2.new(0.5,0,0,0), Size=UDim2.new(0.5,0,1,0),
        BackgroundTransparency=1, Text="V2",
        TextColor3 = (SpeedSystem.speedMethod == "V2") and Color3.fromRGB(255,255,255) or (TEXT_DIM or Color3.fromRGB(140,150,160)),
        TextSize=12, Font=Enum.Font.GothamBold,
        AutoButtonColor=false, Parent=track,
    local function setMethod(v)
        SpeedSystem.speedMethod = v
        if v == "V1" then SpeedSystem.laggerPhase = 0 end
        local isV2 = (v == "V2")
        TweenService:Create(slider, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {
            Position = isV2 and UDim2.new(0.5,2,0,2) or UDim2.new(0,2,0,2)
        }):Play()
        v1Btn.TextColor3 = (not isV2) and Color3.fromRGB(255,255,255) or (TEXT_DIM or Color3.fromRGB(140,150,160))
        v2Btn.TextColor3 = isV2 and Color3.fromRGB(255,255,255) or (TEXT_DIM or Color3.fromRGB(140,150,160))
        NoxaCfg.saveConfig()
        pcall(function()
            if type(notify) == "function" then notify("Speed Method · " .. tostring(v), 1.5) end
        end)
    end
    v1Btn.MouseButton1Click:Connect(function() setMethod("V1") end)
    v2Btn.MouseButton1Click:Connect(function() setMethod("V2") end)
    _G.NoxaSpeedMethodSet = function(idx)
        setMethod((idx == 2) and "V2" or "V1")
    end
end

local function mkVX7SpeedRow(parent, opts)

    local r = NoxaUI.mkRow(parent, 58)

    pcall(function()
        local c = r:FindFirstChildOfClass("UICorner")
        if c then c.CornerRadius = UDim.new(0, 10) end
    end)

    local radio = NoxaUI.new("TextButton", {
        Name="Radio", ZIndex=6,
        Position=UDim2.new(0,12,0.5,-9),
        Size=UDim2.new(0,18,0,18),
        BackgroundColor3 = opts.startOn and (ACCENT or Color3.fromRGB(70, 170, 255)) or Color3.fromRGB(40,48,56),
        BackgroundTransparency = opts.startOn and 0 or 0.3,
        BorderSizePixel=0, Text="", AutoButtonColor=false, Parent=r,
    NoxaUI.corner(radio, 999)
    local radioInner = NoxaUI.new("Frame", {
        AnchorPoint=Vector2.new(0.5,0.5),
        Position=UDim2.new(0.5,0,0.5,0),
        Size=UDim2.new(0,8,0,8),
        BackgroundColor3=Color3.fromRGB(10,12,14),
        BackgroundTransparency = opts.startOn and 0 or 1,
        BorderSizePixel=0, Parent=radio,
    NoxaUI.corner(radioInner, 999)
    local state = opts.startOn == true
    local function setRadio(on)
        state = on == true
        TweenService:Create(radio, TweenInfo.new(0.18), {
            BackgroundColor3 = state and (ACCENT or Color3.fromRGB(70, 170, 255)) or Color3.fromRGB(40,48,56),
            BackgroundTransparency = state and 0 or 0.3,
        }):Play()
        TweenService:Create(radioInner, TweenInfo.new(0.18), {
            BackgroundTransparency = state and 0 or 1,
        }):Play()
    end
    radio.MouseButton1Click:Connect(function()
        setRadio(not state)
        if opts.onToggle then opts.onToggle(state) end
        NoxaCfg.saveConfig()
    end)

    local titleText = opts.title or ""
    local isBlueGreen = true
    local title = NoxaUI.new("TextLabel", {
        ZIndex=5,
        Position = isBlueGreen and UDim2.new(0,40,0,18) or UDim2.new(0,40,0,8),
        Size = isBlueGreen and UDim2.new(0.42,0,0,22) or UDim2.new(0.38,0,0,18),
        BackgroundTransparency=1,
        Text=titleText,
        TextColor3=TEXT_MAIN or Color3.fromRGB(235,235,240),
        TextSize = isBlueGreen and 15 or 13,
        Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left,
        TextYAlignment=Enum.TextYAlignment.Center,
        Parent=r,
    local sub = NoxaUI.new("TextLabel", {
        ZIndex=5, Position=UDim2.new(0,40,0,28),
        Size=UDim2.new(0.38,0,0,14),
        BackgroundTransparency=1,
        Text=opts.sub or "",
        TextColor3=TEXT_DIM or Color3.fromRGB(130,140,150),
        TextSize=10, Font=Enum.Font.GothamMedium,
        TextXAlignment=Enum.TextXAlignment.Left, Parent=r,
        Visible = (opts.sub and opts.sub ~= "") and true or false,
    pcall(function()
        if not _G._NoxaSpeedTitleLabels then _G._NoxaSpeedTitleLabels = {} end
        table.insert(_G._NoxaSpeedTitleLabels, {label = title, full = titleText, subLbl = sub})
        if false and (titleText == "Normal Speed" or titleText == "Lagger Speed") then
            title.Text = (titleText == "Normal Speed") and "Normal\nSpeed" or "Lagger\nSpeed"
            title.TextWrapped = true
            title.Size = UDim2.new(0.38, 0, 0, 36)
            title.Position = UDim2.new(0, 40, 0, 4)
            title.TextYAlignment = Enum.TextYAlignment.Top
            title.TextSize = 13
            sub.Visible = false
        end
    end)

    local keyBtn = nil

    local nLbl = NoxaUI.new("TextLabel", {
        ZIndex=5, Position=UDim2.new(1,-132,0,6),
        Size=UDim2.new(0,48,0,12),
        BackgroundTransparency=1, Text="NORMAL",
        TextColor3=TEXT_DIM or Color3.fromRGB(130,140,150),
        TextSize=8, Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Center, Parent=r,
    local nBox = NoxaUI.new("TextBox", {
        ZIndex=6, Position=UDim2.new(1,-132,0.5,-2),
        Size=UDim2.new(0,48,0,22),
        BackgroundColor3=Color3.fromRGB(255,255,255),
        BackgroundTransparency=1, BorderSizePixel=0,
        Text=tostring(opts.normalVal or 0),
        TextColor3=Color3.fromRGB(245,248,255),
        TextSize=12, Font=Enum.Font.GothamBold,
        ClearTextOnFocus=false, Parent=r,
    NoxaUI.corner(nBox, 999)
        local ns = Instance.new("UIStroke")
        ns.Color = Color3.fromRGB(255, 255, 255)
        ns.Thickness = 1.4
        ns.Transparency = 0.15
        ns.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        ns.Parent = nBox
    end

    local sLbl = NoxaUI.new("TextLabel", {
        ZIndex=5, Position=UDim2.new(1,-76,0,6),
        Size=UDim2.new(0,48,0,12),
        BackgroundTransparency=1, Text="STEAL",
        TextColor3=TEXT_DIM or Color3.fromRGB(130,140,150),
        TextSize=8, Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Center, Parent=r,
    local sBox = NoxaUI.new("TextBox", {
        ZIndex=6, Position=UDim2.new(1,-76,0.5,-2),
        Size=UDim2.new(0,48,0,22),
        BackgroundColor3=Color3.fromRGB(255,255,255),
        BackgroundTransparency=1, BorderSizePixel=0,
        Text=tostring(opts.stealVal or 0),
        TextColor3=Color3.fromRGB(245,248,255),
        TextSize=12, Font=Enum.Font.GothamBold,
        ClearTextOnFocus=false, Parent=r,
    NoxaUI.corner(sBox, 999)
        local ss = Instance.new("UIStroke")
        ss.Color = Color3.fromRGB(255, 255, 255)
        ss.Thickness = 1.4
        ss.Transparency = 0.15
        ss.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        ss.Parent = sBox
    end

    local lastN, lastS = tostring(opts.normalVal), tostring(opts.stealVal)
    nBox.FocusLost:Connect(function()
        local n = tonumber(nBox.Text)
        if not n then nBox.Text = lastN else lastN = nBox.Text; if opts.onNormal then opts.onNormal(n) end end
        NoxaCfg.saveConfig()
    end)
    sBox.FocusLost:Connect(function()
        local n = tonumber(sBox.Text)
        if not n then sBox.Text = lastS else lastS = sBox.Text; if opts.onSteal then opts.onSteal(n) end end
        NoxaCfg.saveConfig()
    end)

    return r, nBox, sBox, setRadio, keyBtn, function() return state end
end

function _G.NoxaRefreshSpeedTitleLayout()
    pcall(function()
        local rose = false
        local list = _G._NoxaSpeedTitleLabels
        if not list then return end
        for _, e in ipairs(list) do
            local full = e.full or ""
            if not t or not t.Parent then continue end
            if rose and (full == "Normal Speed" or full == "Lagger Speed") then
                t.Text = (full == "Normal Speed") and "Normal\nSpeed" or "Lagger\nSpeed"
                t.TextWrapped = true
                t.TextYAlignment = Enum.TextYAlignment.Top
                t.Size = UDim2.new(0.38, 0, 0, 36)
                t.Position = UDim2.new(0, 40, 0, 4)
                t.TextSize = 13
                if e.subLbl then e.subLbl.Text = ""; e.subLbl.Visible = false end
            else

                t.Text = full
                t.TextWrapped = false
                t.TextYAlignment = Enum.TextYAlignment.Center
                t.Size = UDim2.new(0.42, 0, 0, 22)
                t.Position = UDim2.new(0, 40, 0, 18)
                t.TextSize = 15
                if e.subLbl then
                    e.subLbl.Visible = false
                    e.subLbl.Text = ""
                end
            end
        end
    end)
end

carryRow, nsBox, csBox, setCarryRadio, carryKeyBtn, getCarryState = mkVX7SpeedRow(P_MOVEMENT, {
    title = "Normal Speed",
    sub = "",
    bindName = "Carry",
    keyText = "A",
    normalVal = SpeedSystem.NS,
    stealVal = SpeedSystem.CS,
    startOn = SpeedSystem.carryActive == true,
    onToggle = function(state)
        if SpeedSystem.speedMethod == "V2" then
            SpeedSystem:setCarry(state and true or false)
        else
            SpeedSystem.carryActive = state and true or false
            if SpeedSystem.laggerActive then
                SpeedSystem.laggerPhase = state and 2 or 1
            end
            SpeedSystem:updateUI()
        end
    end,
    onNormal = function(n) SpeedSystem.NS = n end,
    onSteal = function(n) SpeedSystem.CS = n end,
carryArrow = nil

laggerRow, lsBox, lcBox, setLaggerRadio, laggerKeyBtn, getLaggerState = mkVX7SpeedRow(P_MOVEMENT, {
    title = "Lagger Speed",
    sub = "",
    bindName = "Lagger",
    keyText = "V",
    normalVal = SpeedSystem.LAGGER_NORMAL,
    stealVal = SpeedSystem.LAGGER_CARRY,
    startOn = SpeedSystem.laggerActive == true,
    onToggle = function(state)
        if SpeedSystem.speedMethod == "V2" then
            SpeedSystem:toggleLagger()
            if setLaggerRadio then setLaggerRadio(SpeedSystem.laggerActive) end
        else
            SpeedSystem.laggerActive = state and true or false
            SpeedSystem.laggerPhase = state and (SpeedSystem.carryActive and 2 or 1) or 0
            SpeedSystem:updateUI()
        end
    end,
    onNormal = function(n) SpeedSystem.LAGGER_NORMAL = n end,
    onSteal = function(n) SpeedSystem.LAGGER_CARRY = n end,
laggerArrow = nil

_G.NoxaSetCarryRadio = setCarryRadio
_G.NoxaSetLaggerRadio = setLaggerRadio

task.wait()
NoxaUI.mkSection(P_MOVEMENT, "KEYBINDS")
mkKeybindActionRow(P_MOVEMENT, "Speed Key",
    function() return SpeedSystem.keybinds and SpeedSystem.keybinds.Carry end,
    function(kc)
        if not SpeedSystem.keybinds then SpeedSystem.keybinds = {} end
        SpeedSystem.keybinds.Carry = kc
        pcall(function() NoxaCfg.saveConfig() end)
        pcall(function()
            if carryKeyBtn and carryKeyBtn.Parent then
                carryKeyBtn.Text = (typeof(kc) == "EnumItem") and kc.Name or "?"
            end
        end)
    end,
    "Carry")
mkKeybindActionRow(P_MOVEMENT, "Lagger Speed Key",
    function() return SpeedSystem.keybinds and SpeedSystem.keybinds.Lagger end,
    function(kc)
        if not SpeedSystem.keybinds then SpeedSystem.keybinds = {} end
        SpeedSystem.keybinds.Lagger = kc
        pcall(function() NoxaCfg.saveConfig() end)
        pcall(function()
            if laggerKeyBtn and laggerKeyBtn.Parent then
                laggerKeyBtn.Text = (typeof(kc) == "EnumItem") and kc.Name or "?"
            end
        end)
    end,
    "Lagger")

NoxaUI.mkSection(P_MOVEMENT, "AUTO CARRY")
local autoCarryRow, _ = NoxaUI.mkToggle(P_MOVEMENT, "Auto Carry Speed", SpeedSystem.autoCarryEnabled, false)
if autoCarryRow then
    local area = autoCarryRow:FindFirstChild("ToggleArea")
    local toggleClick = area and area:FindFirstChild("ToggleClick")
    if toggleClick then
        toggleClick.MouseButton1Click:Connect(function()
            SpeedSystem.autoCarryEnabled = not SpeedSystem.autoCarryEnabled
            if not SpeedSystem.autoCarryEnabled and SpeedSystem._autoCarryActive then
                SpeedSystem:disableAutoCarry()
            end
            SpeedSystem:updateUI()
            NoxaCfg.saveConfig()
        end)
    end
end

NoxaUI.mkSection(P_MOVEMENT, "DROP BRAINROT")
dropRow, dropKeyBtn = mkKeybindActionRow(P_MOVEMENT, "Drop Brainrot",
    function() return SpeedSystem.dropBrainrotKeybind end,
    function(kc) SpeedSystem.dropBrainrotKeybind = kc end,
    "dropBrainrotKeybind"
dropLabel = dropRow
    local modes = {"Fling", "Jump Drop"}
    local cur = tonumber(SpeedSystem.dropMode) or 1
    if cur ~= 1 and cur ~= 2 then cur = 1 end
    NoxaUI.mkPicker(P_MOVEMENT, "Drop Mode", modes, cur, function(v)
        if v == "Jump Drop" then
            SpeedSystem.dropMode = 2
        else
            SpeedSystem.dropMode = 1
        end
        pcall(function() if NoxaCfg then NoxaCfg.saveConfig() end end)
    end)
end
NoxaUI.mkSection(P_MOVEMENT,"TP DOWN")

tpDownRow, tpDownKeyBtn = mkKeybindActionRow(P_MOVEMENT, "TP Down",
    function() return SpeedSystem.tpDownKeybind end,
    function(kc) SpeedSystem.tpDownKeybind = kc end,
    "tpDownKeybind"
tpDownLabel = tpDownRow

NoxaUI.mkSection(P_MOVEMENT,"INSTANT RESET")
local resetRow, resetKeyBtn = mkKeybindActionRow(P_MOVEMENT, "Insta Reset",
    function() return SpeedSystem.instantResetKeybind end,
    function(kc) SpeedSystem.instantResetKeybind = kc end,
    "instantResetKeybind"
resetLabel = resetRow

instaResetOnDeathRow = NoxaUI.mkToggle(P_MOVEMENT, "Insta Reset On Death",
    SpeedSystem.instaResetOnDeathEnabled == true, false)
if instaResetOnDeathRow then
    ToggleStates.__on(instaResetOnDeathRow, function(state)
        SpeedSystem:setInstaResetOnDeath(state == true)
        pcall(function() NoxaCfg.saveConfig(true) end)
    end)
end
_G.NoxaInstaResetOnDeathRow = instaResetOnDeathRow

NoxaUI.mkSection(P_MOVEMENT, "JUMP")

local infJumpRow, infJumpArrow = NoxaUI.mkToggle(P_MOVEMENT, "Infinite Jump", SpeedSystem.infJumpEnabled, true)
if infJumpRow then
    local toggleClick = infJumpRow:FindFirstChild("ToggleArea")
        and infJumpRow:FindFirstChild("ToggleArea"):FindFirstChild("ToggleClick")
    if toggleClick then
        toggleClick.MouseButton1Click:Connect(function()
            SpeedSystem:setInfJumpEnabled(not SpeedSystem.infJumpEnabled)
            pcall(function()
                NoxaCfg.dirty = true
                NoxaCfg.saveConfig(true)
            end)
        end)
    end
end

infModeCard = NoxaUI.mkRow(P_MOVEMENT, 72)
infModeCard.Visible = false
infModeCard.Name = "InfJumpModeCard"
    local sub = NoxaUI.new("TextLabel", {
        ZIndex=5, Position=UDim2.new(0,14,0,6),
        Size=UDim2.new(1,-28,0,12),
        BackgroundTransparency=1, Text="SUB OPTIONS",
        TextColor3=TEXT_DIM or Color3.fromRGB(130,140,150),
        TextSize=9, Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left, Parent=infModeCard,
    local title = NoxaUI.new("TextLabel", {
        ZIndex=5, Position=UDim2.new(0,14,0,20),
        Size=UDim2.new(1,-28,0,16),
        BackgroundTransparency=1, Text="Inf Jump Mode",
        TextColor3=TEXT_MAIN or Color3.fromRGB(230,230,235),
        TextSize=12, Font=Enum.Font.GothamMedium,
        TextXAlignment=Enum.TextXAlignment.Left, Parent=infModeCard,
    local track = NoxaUI.new("Frame", {
        ZIndex=5, Position=UDim2.new(0,12,0,40),
        Size=UDim2.new(1,-24,0,26),
        BackgroundColor3=INPUT_BG or Color3.fromRGB(22,26,32),
        BackgroundTransparency=0.1, BorderSizePixel=0, Parent=infModeCard,
    NoxaUI.corner(track, 999)
    NoxaUI.darkStroke(track, 1)
    local isHold = (SpeedSystem.infJumpMode ~= "manual")
    local slider = NoxaUI.new("Frame", {
        Name="InfModeSlider", ZIndex=6,
        Position = isHold and UDim2.new(0.5,2,0,2) or UDim2.new(0,2,0,2),
        Size=UDim2.new(0.5,-4,1,-4),
        BackgroundColor3=ACCENT or Color3.fromRGB(70, 170, 255),
        BorderSizePixel=0, Parent=track,
    NoxaUI.corner(slider, 999)
    NoxaUI.regAccent(slider)
    local manBtn = NoxaUI.new("TextButton", {
        ZIndex=7, Size=UDim2.new(0.5,0,1,0),
        BackgroundTransparency=1, Text="Manual",
        TextColor3 = (not isHold) and Color3.fromRGB(255,255,255) or (TEXT_DIM or Color3.fromRGB(140,150,160)),
        TextSize=11, Font=Enum.Font.GothamBold,
        AutoButtonColor=false, Parent=track,
    local holdBtn = NoxaUI.new("TextButton", {
        ZIndex=7, Position=UDim2.new(0.5,0,0,0), Size=UDim2.new(0.5,0,1,0),
        BackgroundTransparency=1, Text="Hold",
        TextColor3 = isHold and Color3.fromRGB(255,255,255) or (TEXT_DIM or Color3.fromRGB(140,150,160)),
        TextSize=11, Font=Enum.Font.GothamBold,
        AutoButtonColor=false, Parent=track,
    local function setInfModeUI(mode)
        local hold = (mode == "hold")
        TweenService:Create(slider, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
            Position = hold and UDim2.new(0.5,2,0,2) or UDim2.new(0,2,0,2)
        }):Play()
        manBtn.TextColor3 = (not hold) and Color3.fromRGB(255,255,255) or (TEXT_DIM or Color3.fromRGB(140,150,160))
        holdBtn.TextColor3 = hold and Color3.fromRGB(255,255,255) or (TEXT_DIM or Color3.fromRGB(140,150,160))
    end
    manBtn.MouseButton1Click:Connect(function()
        SpeedSystem:setInfJumpMode("manual")
        setInfModeUI("manual")
        pcall(function()
            NoxaCfg.dirty = true
            NoxaCfg.saveConfig(true)
        end)
    end)
    holdBtn.MouseButton1Click:Connect(function()
        SpeedSystem:setInfJumpMode("hold")
        setInfModeUI("hold")
        pcall(function()
            NoxaCfg.dirty = true
            NoxaCfg.saveConfig(true)
        end)
    end)
    _G.NoxaSetInfJumpModeUI = setInfModeUI

    local open = false
    if infJumpArrow then
        infJumpArrow.MouseButton1Click:Connect(function()
            open = not open
            if infModeCard then infModeCard.Visible = open end
            infJumpArrow.Text = open and "▲" or "▼"
        end)
    end
end

    setInfModeUI((SpeedSystem.infJumpMode == "manual") and "manual" or "hold")
end

NoxaUI.mkSection(P_MOVEMENT, "ANTI-RAGDOLL")
antiRagRow, antiRagSetter = NoxaUI.mkToggle(P_MOVEMENT, "Anti Ragdoll", SpeedSystem.antiRagdollEnabled, false)
if antiRagRow then
    local toggleClick = antiRagRow:FindFirstChild("ToggleArea"):FindFirstChild("ToggleClick")
    if toggleClick then
        toggleClick.MouseButton1Click:Connect(function()
            SpeedSystem:setAntiRagdoll(not SpeedSystem.antiRagdollEnabled)
            NoxaCfg.saveConfig()
        end)
    end
end

NoxaUI.mkSection(P_MOVEMENT, "SAFE MODE")
safeModeRow = NoxaUI.mkToggle(P_MOVEMENT, "Safe Mode", SpeedSystem.safeModeEnabled == true, false)
if safeModeRow then
    _G.NoxaSafeModeRow = safeModeRow
    ToggleStates.__on(safeModeRow, function(state)
        SpeedSystem.safeModeEnabled = state == true
        NoxaCfg.saveConfig()
        if state then
            pcall(notify, "Safe Mode ON · bloque Aimbot/TP Bat/Auto si brainrot", 2)
            task.defer(function()
                if _G.NoxaSafeModeIsLocked and _G.NoxaSafeModeIsLocked() then
                    _G.NoxaSafeModeForceStop("SAFE MODE LOCK")
                end
            end)
        else
            pcall(notify, "Safe Mode OFF", 1.2)
        end
    end)
end

local NoxaMods = {
    antiLagEnabled = false,
    nukeEnabled = false,
    batCounterEnabled = false,
    batCounterMode = "V1",
    medusaCounterEnabled = false,
    _antiLagActive = false,
    _antiLagConn = nil,
    _antiLagDef = {},
    _batConn = nil,
    _batDebounce = false,
    _batCounterWatchConn = nil,
    _batCounterActivatedAimbot = false,
    _batCounterActivatedTP = false,
    _batCounterTarget = nil,
    _medusaConns = {},
    _medusaLastUsed = 0,
    _medusaDebounce = false,

    local Lighting  = game:GetService("Lighting")
    local Workspace = game:GetService("Workspace")

    local function applyAntiLagObj(obj)
        pcall(function()
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.Plastic; obj.Reflectance = 0; obj.CastShadow = false
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 1
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
            or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                obj.Enabled = false
            elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
                for _, t in ipairs(obj:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end
            end
        end)
    end

    function NoxaMods:enableAntiLag()
        if self._antiLagActive then return end
        self._antiLagActive = true
        local def = self._antiLagDef
        def.Brightness = def.Brightness or Lighting.Brightness
        def.FogEnd = def.FogEnd or Lighting.FogEnd
        def.Diffuse = def.Diffuse or Lighting.EnvironmentDiffuseScale
        def.Specular = def.Specular or Lighting.EnvironmentSpecularScale
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e10
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        for _, e in pairs(Lighting:GetChildren()) do
            pcall(function()
                if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect")
                or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                    e.Enabled = false
                end
            end)
        end
        for _, obj in ipairs(workspace:GetDescendants()) do
            applyAntiLagObj(obj)
        end
        if self._antiLagConn then self._antiLagConn:Disconnect() end
        self._antiLagConn = workspace.DescendantAdded:Connect(function(obj)
            if self._antiLagActive then applyAntiLagObj(obj) end
        end)
    end

    function NoxaMods:disableAntiLag()
        self._antiLagActive = false
        if self._antiLagConn then self._antiLagConn:Disconnect(); self._antiLagConn = nil end
        pcall(function()
            Lighting.GlobalShadows = true
            local def = self._antiLagDef
            if def.Brightness then Lighting.Brightness = def.Brightness end
            if def.FogEnd then Lighting.FogEnd = def.FogEnd end
            if def.Diffuse then Lighting.EnvironmentDiffuseScale = def.Diffuse end
            if def.Specular then Lighting.EnvironmentSpecularScale = def.Specular end
            for _, e in pairs(Lighting:GetChildren()) do
                pcall(function()
                    if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect")
                    or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                        e.Enabled = true
                    end
                end)
            end
        end)
    end

    function NoxaMods:setAntiLag(on)
        on = on == true
        if self.antiLagEnabled == on and self._antiLagActive == on then
            return
        end
        self.antiLagEnabled = on
        if on then
            self:enableAntiLag()
        else
            self:disableAntiLag()
        end
    end

    _G._NukeOn = false; _G._NukeConns = {}; _G._NukeThreads = {}
    _G._nukeStart = function()
        if _G._NukeOn then return end
        _G._NukeOn = true
        local Lighting = game:GetService("Lighting")
        local MaterialService = game:GetService("MaterialService")
        local XMin, XMax = -560, -240
        local ClothingClasses = {
        local BASE_NAMES = {"baseplate","spawnlocation","spawn location","spawn"}

        local function SafeDestroy(obj)
            if obj.Name == "Overhead" then return end
            pcall(function() obj:Destroy() end)
        end
        local function IsClothing(obj)
            for _, c in ipairs(ClothingClasses) do
                if obj:IsA(c) then return true end
            end
            return false
        end
        local function IsCharacterPart(obj)
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character and obj:IsDescendantOf(plr.Character) then return true end
            end
            return false
        end
        local function IsOutOfRange(obj)
            if obj:IsA("BasePart") then
                local x = obj.Position.X
                return x < XMin or x > XMax
            end
            return false
        end
        local function IsBase(obj)
            if not obj:IsA("BasePart") then return false end
            local nl = obj.Name:lower()
            for _, n in ipairs(BASE_NAMES) do
                if nl:find(n, 1, true) then return true end
            end
            return false
        end
        local function IsInBase(obj)
            local p = obj.Parent
            while p and p ~= workspace do
                if IsBase(p) then return true end
                p = p.Parent
            end
            return false
        end
        local function MakeTransparent(obj)
            pcall(function()
                if IsBase(obj) and not IsCharacterPart(obj) then
                    obj.Transparency = 1
                    obj.CastShadow = false
                end
            end)
        end
        local function StripObject(obj)
            pcall(function()
                if obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("SpecialMesh") then
                    SafeDestroy(obj)
                elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
                    or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                    pcall(function() obj.Enabled = false end)
                    SafeDestroy(obj)
                elseif obj:IsA("SurfaceAppearance") then
                    SafeDestroy(obj)
                elseif obj:IsA("BasePart") then
                    obj.CastShadow = false
                    obj.Material = Enum.Material.Plastic
                    obj.MaterialVariant = ""
                    obj.Reflectance = 0
                end
            end)
        end
        local function CleanObject(obj)
            pcall(function()
                if obj:IsA("SurfaceAppearance") then
                    SafeDestroy(obj)
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    if not (obj.Name == "face" and obj.Parent and obj.Parent.Name == "Head") then
                        SafeDestroy(obj)
                    end
                elseif obj:IsA("SpecialMesh") then
                    obj.TextureId = ""
                elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                    SafeDestroy(obj)
                elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                    SafeDestroy(obj)
                elseif obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Explosion") then
                    SafeDestroy(obj)
                elseif obj:IsA("Animation") or obj:IsA("AnimationController") then
                    SafeDestroy(obj)
                elseif obj:IsA("BasePart") then
                    obj.CastShadow = false
                    obj.Material = Enum.Material.Plastic
                    obj.MaterialVariant = ""
                    obj.Reflectance = 0
                end
            end)
        end
        local function ApplyGreySky()
            pcall(function()
                for _, obj in ipairs(Lighting:GetChildren()) do
                    if obj:IsA("Sky") then obj:Destroy() end
                end
                local sky = Instance.new("Sky")
                sky.SkyboxBk = ""
                sky.SkyboxDn = ""
                sky.SkyboxFt = ""
                sky.SkyboxLf = ""
                sky.SkyboxRt = ""
                sky.SkyboxUp = ""
                sky.CelestialBodiesShown = false
                sky.Name = "_VezyNukeSky"
                sky.Parent = Lighting
            end)
        end
        local function OptimizeLighting()
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            Lighting.FogStart = 9e9
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
            Lighting.Brightness = 1.5
            Lighting.Ambient = Color3.fromRGB(60, 60, 60)
            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect")
                    or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect")
                    or v:IsA("Atmosphere") or v:IsA("Clouds") then
                    v:Destroy()
                end
            end
            ApplyGreySky()
        end
        local function ApplyTerrain()
            pcall(function()
                local T = workspace.Terrain
                T.Decoration = false
                T.WaterWaveSize = 0
                T.WaterWaveSpeed = 0
                T.WaterReflectance = 0
                T.WaterTransparency = 1
            end)
        end
        local function OptimizeCharacter(char)
            if not char then return end
            task.spawn(function()
                task.wait(0.3)
                if not _G._NukeOn then return end
                for _, obj in ipairs(char:GetDescendants()) do
                    if IsClothing(obj) then
                        SafeDestroy(obj)
                    else
                        CleanObject(obj)
                    end
                end
            end)
        end

        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
        end)
        pcall(function()
            if setfpscap then setfpscap(999) end
        end)

        table.insert(_G._NukeThreads, task.spawn(function()
            if not game:IsLoaded() then game.Loaded:Wait() end
            OptimizeLighting()
            ApplyTerrain()
            for _, obj in ipairs(workspace:GetDescendants()) do
                if not _G._NukeOn then return end
                if IsBase(obj) then
                    MakeTransparent(obj)
                elseif IsClothing(obj) then
                    SafeDestroy(obj)
                elseif IsInBase(obj) then
                elseif IsCharacterPart(obj) then
                elseif IsOutOfRange(obj) then
                    SafeDestroy(obj)
                else
                    CleanObject(obj)
                    StripObject(obj)
                end
            end
            for _, obj in ipairs(workspace:GetDescendants()) do
                MakeTransparent(obj)
            end
        end))

        table.insert(_G._NukeConns, workspace.DescendantAdded:Connect(function(obj)
            if not _G._NukeOn then return end
            task.defer(function()
                if not _G._NukeOn then return end
                if IsBase(obj) then
                    MakeTransparent(obj)
                    return
                end
                if IsClothing(obj) then
                    SafeDestroy(obj)
                elseif IsInBase(obj) then
                elseif IsCharacterPart(obj) then
                elseif IsOutOfRange(obj) then
                    SafeDestroy(obj)
                else
                    CleanObject(obj)
                    StripObject(obj)
                end
            end)
        end))
        table.insert(_G._NukeConns, Lighting.DescendantAdded:Connect(function(obj)
            if not _G._NukeOn then return end
            if obj:IsA("Atmosphere") or obj:IsA("Clouds") or obj:IsA("PostEffect") then
                SafeDestroy(obj)
            end
        end))
        table.insert(_G._NukeConns, MaterialService.DescendantAdded:Connect(function(obj)
            if not _G._NukeOn then return end
            SafeDestroy(obj)
        end))
        for _, plr in ipairs(Players:GetPlayers()) do
            OptimizeCharacter(plr.Character)
            table.insert(_G._NukeConns, plr.CharacterAdded:Connect(OptimizeCharacter))
        end
        table.insert(_G._NukeConns, Players.PlayerAdded:Connect(function(plr)
            table.insert(_G._NukeConns, plr.CharacterAdded:Connect(OptimizeCharacter))
        end))
        table.insert(_G._NukeThreads, task.spawn(function()
            while _G._NukeOn do
                task.wait(15)
                pcall(function() collectgarbage("collect") end)
            end
        end))
    end

    _G._nukeStop = function()
        _G._NukeOn = false
        for _, c in ipairs(_G._NukeConns) do
            pcall(function() c:Disconnect() end)
        end
        _G._NukeConns = {}
        _G._NukeThreads = {}
    end

    function NoxaMods:setNukeOptimizer(on)
        on = on == true
        if self.nukeEnabled == on and ((_G._NukeOn == true) == on) then
            return
        end
        self.nukeEnabled = on
        if on then
            _G._nukeStart()
        else
            _G._nukeStop()
        end
    end

    local BAT_LIST = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
    local function findBat()
        local c = LP.Character; if not c then return nil end
        local bp = LP:FindFirstChildOfClass("Backpack")
        for _, name in ipairs(BAT_LIST) do
            local t = c:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
            if t then return t end
        end
        for _, ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
        if bp then for _, ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
        return nil
    end
    local function swingBat(bat, char)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if bat.Parent ~= char then
            if hum then pcall(function() hum:EquipTool(bat) end) end
            task.wait(0.05)
        end
        local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
        if remote and remote:IsA("RemoteEvent") then
            pcall(function() remote:FireServer() end); task.wait(0.15); pcall(function() remote:FireServer() end)
        else
            pcall(function() bat:Activate() end); task.wait(0.15); pcall(function() bat:Activate() end)
        end
    end

    local function _isRagdollHum(hum)
        if not hum then return false end
        local st = hum:GetState()
        return st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown
            or hum.PlatformStand == true
    end

    local function _closestEnemy()
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        local best, bd = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local tr = p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if tr and hum and hum.Health > 0 then
                    local d = (tr.Position - root.Position).Magnitude
                    if d < bd then bd = d; best = p end
                end
            end
        end
        return best
    end

    function NoxaMods:_syncToggleRow(row, state)
        if not row then return end
        pcall(function()
            ToggleStates[row] = state and true or false
            local area = row:FindFirstChild("ToggleArea")
            local track = area and area:FindFirstChildWhichIsA("Frame")
            local knob  = track and track:FindFirstChildWhichIsA("Frame")
            if track and knob and setToggleVisual then
                NoxaUI.setToggleVisual(track, knob, state and true or false)
            end
        end)
    end

    function NoxaMods:_stopCounterActivatedTools()
        if self._batCounterWatchConn then
            pcall(function() self._batCounterWatchConn:Disconnect() end)
            self._batCounterWatchConn = nil
        end
        local stopped = false
        if self._batCounterActivatedAimbot then
            self._batCounterActivatedAimbot = false
            if self.BatAimbotRef then
                self.BatAimbotRef.enabled = false
            end
            if type(self._batAimbotStop) == "function" then
                pcall(self._batAimbotStop)
            end
            self:_syncToggleRow(self._batAimbotRow, false)
            stopped = true
        end
        if self._batCounterActivatedTP then
            self._batCounterActivatedTP = false
            SpeedSystem.antiDesyncAimbotEnabled = false
            pcall(function() SpeedSystem:stopAntiDesyncAimbot() end)
            self:_syncToggleRow(self._tpBatRow, false)
            if SpeedSystem.onUIUpdate then pcall(function() SpeedSystem:onUIUpdate() end) end
            stopped = true
        end
        if stopped then
            pcall(function() if notify then notify("Counter · cible ragdoll · OFF", 1.8) end end)
        end
        self._batCounterTarget = nil
    end

    function NoxaMods:_watchTargetRagdoll(target)
        if self._batCounterWatchConn then
            pcall(function() self._batCounterWatchConn:Disconnect() end)
            self._batCounterWatchConn = nil
        end
        self._batCounterTarget = target
        local started = tick()
        self._batCounterWatchConn = RunService.Heartbeat:Connect(function()
            if not NoxaMods.batCounterEnabled then
                NoxaMods:_stopCounterActivatedTools()
                return
            end

            if tick() - started > 8 then
                NoxaMods:_stopCounterActivatedTools()
                return
            end
            local t = NoxaMods._batCounterTarget
            if not t then
                NoxaMods:_stopCounterActivatedTools()
                return
            end
            local char = t.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not char or not hum or hum.Health <= 0 or _isRagdollHum(hum) then
                NoxaMods:_stopCounterActivatedTools()
            end
        end)
    end

    function NoxaMods:_activateCounterMode()
        local mode = self.batCounterMode or "V1"
        local target = _closestEnemy()
        if mode == "V1" then
            local char = LP.Character
            local bat = findBat()
            if bat and char then swingBat(bat, char) end
            pcall(function() if notify then notify("Counter V1 · Swing", 1.6) end end)
            return
        end
        if mode == "V2" then
            if not self._batCounterActivatedAimbot then
                self._batCounterActivatedAimbot = true
                if self.BatAimbotRef then self.BatAimbotRef.enabled = true end
                if type(self._batAimbotStart) == "function" then
                    pcall(self._batAimbotStart)
                end
                self:_syncToggleRow(self._batAimbotRow, true)
                pcall(function() if notify then notify("Counter V2 · Bat Aimbot ON", 2) end end)
            end
            self:_watchTargetRagdoll(target)
            return
        end
        if mode == "V3" then
            if not self._batCounterActivatedTP then
                self._batCounterActivatedTP = true
                SpeedSystem.antiDesyncAimbotEnabled = true
                pcall(function() SpeedSystem:startAntiDesyncAimbot() end)
                self:_syncToggleRow(self._tpBatRow, true)
                if SpeedSystem.onUIUpdate then pcall(function() SpeedSystem:onUIUpdate() end) end
                pcall(function() if notify then notify("Counter V3 · TP Bat ON", 2) end end)
            end
            self:_watchTargetRagdoll(target)
        end
    end

    function NoxaMods:startBatCounter()
        if self._batConn then return end
        self._batConn = RunService.Heartbeat:Connect(function()
            if not NoxaMods.batCounterEnabled or NoxaMods._batDebounce then return end
            local char = LP.Character; if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
            if _isRagdollHum(hum) then
                NoxaMods._batDebounce = true
                task.spawn(function()
                    NoxaMods:_activateCounterMode()
                    task.wait(0.55)
                    NoxaMods._batDebounce = false
                end)
            end
        end)
    end

    function NoxaMods:stopBatCounter()
        if self._batConn then self._batConn:Disconnect(); self._batConn = nil end
        self._batDebounce = false
        self:_stopCounterActivatedTools()
    end

    function NoxaMods:setBatCounter(on)
        self.batCounterEnabled = on
        if on then self:startBatCounter() else self:stopBatCounter() end
    end

    function NoxaMods:setBatCounterMode(mode)
        if mode ~= "V1" and mode ~= "V2" and mode ~= "V3" then mode = "V1" end
        self.batCounterMode = mode

        self:_stopCounterActivatedTools()
    end

    local MEDUSA_COOLDOWN = 0.5
    local function findMedusa()
        local c = LP.Character; if not c then return nil end
        for _, t in ipairs(c:GetChildren()) do
            if t:IsA("Tool") then local n = t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end
        end
        local bp = LP:FindFirstChildOfClass("Backpack")
        if bp then
            for _, t in ipairs(bp:GetChildren()) do
                if t:IsA("Tool") then local n = t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end
            end
        end
        return nil
    end
    local function useMedusa()
        if NoxaMods._medusaDebounce then return end
        if tick() - NoxaMods._medusaLastUsed < MEDUSA_COOLDOWN then return end
        local c = LP.Character; if not c then return end
        NoxaMods._medusaDebounce = true
        local med = findMedusa()
        if not med then NoxaMods._medusaDebounce = false; return end
        if med.Parent ~= c then local hum = c:FindFirstChildOfClass("Humanoid"); if hum then pcall(function() hum:EquipTool(med) end) end end
        pcall(function() med:Activate() end)
        NoxaMods._medusaLastUsed = tick(); NoxaMods._medusaDebounce = false
    end
    local function watchAnchor(part)
        return part:GetPropertyChangedSignal("Anchored"):Connect(function()
            if NoxaMods.medusaCounterEnabled and part.Anchored and part.Transparency == 1 then useMedusa() end
        end)
    end

    function NoxaMods:stopMedusaCounter()
        for _, c in pairs(self._medusaConns) do pcall(function() c:Disconnect() end) end
        self._medusaConns = {}
    end

    function NoxaMods:setupMedusaCounter(char)
        self:stopMedusaCounter()
        char = char or LP.Character
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then table.insert(self._medusaConns, watchAnchor(part)) end
        end
        table.insert(self._medusaConns, char.DescendantAdded:Connect(function(part)
            if part:IsA("BasePart") then table.insert(NoxaMods._medusaConns, watchAnchor(part)) end
        end))
    end

    function NoxaMods:setMedusaCounter(on)
        self.medusaCounterEnabled = on
        if on then self:setupMedusaCounter(LP.Character) else self:stopMedusaCounter() end
    end

    LP.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if NoxaMods.medusaCounterEnabled then NoxaMods:setupMedusaCounter(char) end
    end)
end

local NoxaESP = {

    boxEnabled       = false,
    userESPEnabled   = false,
    boxStyle         = "Normal",
    tracerEnabled    = false,
    highlightEnabled = false,
    ragdollTimer     = false,
    ragdollNotify    = false,
    boxColor         = Color3.fromRGB(70, 170, 255),
    tracerColor      = Color3.fromRGB(70, 170, 255),
    _disabled        = true,

    local RunS   = game:GetService("RunService")
    local TweenS = game:GetService("TweenService")
    local Camera = workspace.CurrentCamera
    local LINE_T = 1
    local ESP    = {}
    local drawGui

    NoxaESP.STYLES = {"Normal", "Oval", "Squircle"}

    local function ragdollLeft(plr)
        plr = plr or LP
        local endTime = plr:GetAttribute("RagdollEndTime")
        if type(endTime) ~= "number" then
            local char = plr.Character
            if char then endTime = char:GetAttribute("RagdollEndTime") end
        end
        if type(endTime) ~= "number" then return 0 end
        local left = endTime - workspace:GetServerTimeNow()
        if left < 0.05 or left > 15 then return 0 end
        return left
    end

    local nGui, nCard, nTitle, nSub, nTimer, nBarFill, nIcon, nGlow
    local nShowing, nHideToken, nMax = false, 0, 1

    local function ensureToast()
        if nGui and nGui.Parent then return end
        nGui = NoxaUI.new("ScreenGui", {
            Name = "NoxaRagdollToast", ResetOnSpawn = false,
            IgnoreGuiInset = true, DisplayOrder = 90, Parent = PlayerGui,
        nCard = NoxaUI.new("Frame", {
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, -110),
            Size = UDim2.new(0, 306, 0, 66),
            BackgroundColor3 = BG_MAIN, BackgroundTransparency = 0.06,
            BorderSizePixel = 0, Visible = false, Parent = nGui,
        NoxaUI.corner(nCard, 10)
        NoxaUI.new("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 26, 27)),
                ColorSequenceKeypoint.new(1, BG_DARKER),
            Rotation = 90, Parent = nCard,
        local st = NoxaUI.new("UIStroke", {Color = Color3.fromRGB(70, 170, 255), Thickness = 0,
            Transparency = 1, Parent = nCard})
        nGlow = NoxaUI.new("UIStroke", {Color = Color3.fromRGB(70, 170, 255), Thickness = 0,
            Transparency = 1, Parent = nCard})

        nIcon = NoxaUI.new("Frame", {
            Position = UDim2.new(0, 12, 0.5, -19), Size = UDim2.new(0, 38, 0, 38),
            BackgroundColor3 = Color3.fromRGB(70, 170, 255), BackgroundTransparency = 0.82,
            BorderSizePixel = 0, Parent = nCard,
        NoxaUI.corner(nIcon, 8)
        NoxaUI.new("UIStroke", {Color = Color3.fromRGB(70, 170, 255), Thickness = 0, Transparency = 1, Parent = nIcon})
        NoxaUI.new("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            Text = "!", TextColor3 = Color3.fromRGB(70, 170, 255), TextSize = 22,
            Font = Enum.Font.GothamBlack, Parent = nIcon,

        nTitle = NoxaUI.new("TextLabel", {
            Position = UDim2.new(0, 60, 0, 11), Size = UDim2.new(1, -130, 0, 18),
            BackgroundTransparency = 1, Text = "",
            TextColor3 = TEXT_MAIN, TextSize = 14,
            Font = Enum.Font.GothamBlack,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd, Parent = nCard,
        nSub = NoxaUI.new("TextLabel", {
            Position = UDim2.new(0, 60, 0, 29), Size = UDim2.new(1, -130, 0, 14),
            BackgroundTransparency = 1, Text = "RAGDOLL",
            TextColor3 = TEXT_DIM, TextSize = 10,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left, Parent = nCard,
        nTimer = NoxaUI.new("TextLabel", {
            Position = UDim2.new(1, -74, 0.5, -14), Size = UDim2.new(0, 62, 0, 28),
            BackgroundTransparency = 1, Text = "",
            TextColor3 = Color3.fromRGB(70, 170, 255), TextSize = 20,
            Font = Enum.Font.GothamBlack,
            TextXAlignment = Enum.TextXAlignment.Right, Parent = nCard,

        local track = NoxaUI.new("Frame", {
            Position = UDim2.new(0, 60, 1, -14), Size = UDim2.new(1, -132, 0, 4),
            BackgroundColor3 = TOGGLE_OFF, BackgroundTransparency = 0.25,
            BorderSizePixel = 0, Parent = nCard,
        NoxaUI.corner(track, 2)
        nBarFill = NoxaUI.new("Frame", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(70, 170, 255),
            BorderSizePixel = 0, Parent = track,
        NoxaUI.corner(nBarFill, 2)
        NoxaUI.new("UIGradient", {Color = FX.SEQ, Parent = nBarFill})
    end

    local function toastIn(title, seconds)
        ensureToast()
        nMax = math.max(seconds or 1, 0.1)
        nTitle.Text = title
        nTimer.Text = string.format("%.1fs", seconds or 0)
        nBarFill.Size = UDim2.new(1, 0, 1, 0)
        nCard.Visible = true
        nCard.Position = UDim2.new(0.5, 0, 0, -110)
        nCard.Size = UDim2.new(0, 286, 0, 66)
        nShowing = true
        NoxaUI.tw(nCard, TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5, 0, 0, 74), Size = UDim2.new(0, 306, 0, 66)})
        if nGlow then
            nGlow.Transparency = 0.35
            NoxaUI.tw(nGlow, TweenInfo.new(0.6), {Transparency = 0.82})
        end
    end

    local function toastOut()
        if not nCard or not nShowing then return end
        nShowing = false
        nHideToken = nHideToken + 1
        local token = nHideToken
        local t = TweenS:Create(nCard, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {Position = UDim2.new(0.5, 0, 0, -110)})
        t:Play()
        t.Completed:Connect(function()
            if token == nHideToken and nCard then nCard.Visible = false end
        end)
    end

    local function toastUpdate(title, sub, seconds)
        ensureToast()
        if seconds and seconds > 0 then
            if not nShowing then
                toastIn(title, seconds)
            else
                nTitle.Text = title
                nTimer.Text = string.format("%.1fs", seconds)
            end
            nSub.Text = sub or "RAGDOLL"
            nBarFill.Size = UDim2.new(math.clamp(seconds / nMax, 0, 1), 0, 1, 0)
            local hot = seconds < 1
            nTimer.TextColor3 = hot and Color3.fromRGB(255, 120, 120) or (NoxaESP.boxColor or Color3.fromRGB(70, 170, 255))
        elseif nShowing then
            toastOut()
        end
    end

    local function ensureBillboard(char)
        local head = char:FindFirstChild("Head")
        if not head then return nil end
        local bb = head:FindFirstChild("NoxaRagdollBB")
        if bb then
            local t = bb:FindFirstChild("Timer")
            if t then return t end
            bb:Destroy()
        end

        bb = Instance.new("BillboardGui")
        bb.Name = "NoxaRagdollBB"
        bb.Size = UDim2.new(0, 90, 0, 28)
        bb.StudsOffset = Vector3.new(0, 3.4, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 250
        bb.LightInfluence = 0
        bb.Parent = head
        local bg = Instance.new("Frame")
        bg.Name = "Bg"
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        bg.BackgroundTransparency = 0.35
        bg.BorderSizePixel = 0
        bg.Parent = bb
        Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
        local st = Instance.new("UIStroke")
        st.Color = (typeof(ACCENT) == "Color3" and ACCENT) or Color3.fromRGB(70, 170, 255)
        st.Thickness = 1.2
        st.Transparency = 0.25
        st.Parent = bg
        local lbl = Instance.new("TextLabel")
        lbl.Name = "Timer"
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = ""
        lbl.TextColor3 = Color3.fromRGB(255, 90, 90)
        lbl.TextSize = 14
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextStrokeTransparency = 0.4
        lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        lbl.Visible = false
        lbl.Parent = bg
        return lbl
    end

    local function clearBillboard(char)
        if not char then return end
        local head = char:FindFirstChild("Head")
        if head then
            local bb = head:FindFirstChild("NoxaRagdollBB")
            if bb then bb:Destroy() end
        end
    end

    local function ensureDraw()
        if drawGui and drawGui.Parent then return drawGui end
        drawGui = NoxaUI.new("ScreenGui", {
            Name = "NoxaEspDraw", ResetOnSpawn = false,
            IgnoreGuiInset = true, DisplayOrder = 55, Parent = PlayerGui,
        return drawGui
    end

    local function makeBox()
        local folder = NoxaUI.new("Folder", {Name = "NoxaEspBox", Parent = ensureDraw()})
        local function mkLine()
            return NoxaUI.new("Frame", {
                BorderSizePixel = 0, BackgroundColor3 = NoxaESP.boxColor,
                AnchorPoint = Vector2.new(0.5, 0.5), Visible = false, Parent = folder,
        end
        local lines = {mkLine(), mkLine(), mkLine(), mkLine()}
        local ring = NoxaUI.new("Frame", {
            Name = "Ring", BackgroundTransparency = 1,
            BorderSizePixel = 0, Visible = false, Parent = folder,
        local ringStroke = NoxaUI.new("UIStroke", {
            Thickness = LINE_T, Color = NoxaESP.boxColor,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = ring,
        local ringCorner = NoxaUI.new("UICorner", {CornerRadius = UDim.new(0, 0), Parent = ring})
        return {folder = folder, lines = lines, ring = ring,
                ringStroke = ringStroke, ringCorner = ringCorner}
    end

        local function makeTracer()

        if Drawing and Drawing.new then
            local ok, line = pcall(function()
                local l = Drawing.new("Line")
                l.Thickness = 2
                l.Transparency = 1
                l.Color = NoxaESP.tracerColor or Color3.fromRGB(70, 170, 255)
                l.Visible = false
                return l
            end)
            if ok and line then
                return { __drawing = true, line = line }
            end
        end
        local f = NoxaUI.new("Frame", {
            Name = "NoxaEspTracer", BorderSizePixel = 0,
            BackgroundColor3 = NoxaESP.tracerColor,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Visible = false, Parent = ensureDraw(),
        return { __drawing = false, frame = f }
    end
    local function hideBox(box)
        if not box then return end
        for _, l in ipairs(box.lines) do l.Visible = false end
        box.ring.Visible = false
    end

    local function updateBox(box, topLeft, size)
        hideBox(box)
        local w = math.max(6, size.X)
        local h = math.max(10, size.Y)
        local x, y = topLeft.X, topLeft.Y
        local style, col = NoxaESP.boxStyle, NoxaESP.boxColor
        if style == "Normal" then
            local t = LINE_T
            local set = function(i, sz, ps)
                box.lines[i].Visible = true
                box.lines[i].BackgroundColor3 = col
                box.lines[i].Size = sz
                box.lines[i].Position = ps
            end
            set(1, UDim2.fromOffset(w, t), UDim2.fromOffset(x + w * 0.5, y))
            set(2, UDim2.fromOffset(w, t), UDim2.fromOffset(x + w * 0.5, y + h))
            set(3, UDim2.fromOffset(t, h), UDim2.fromOffset(x, y + h * 0.5))
            set(4, UDim2.fromOffset(t, h), UDim2.fromOffset(x + w, y + h * 0.5))
        else
            box.ring.Visible = true
            box.ring.Position = UDim2.fromOffset(x, y)
            box.ring.Size = UDim2.fromOffset(w, h)
            box.ringStroke.Color = col
            box.ringStroke.Thickness = LINE_T
            if style == "Squircle" then
                box.ringCorner.CornerRadius = UDim.new(0, math.clamp(math.min(w, h) * 0.12, 3, 8))
            else
                box.ringCorner.CornerRadius = UDim.new(1, 0)
            end
        end
    end

    local function updateTracer(tr, from, to, targetVisible)
        if not tr then return end
        local col = NoxaESP.tracerColor or Color3.fromRGB(70, 170, 255)

        if type(tr) == "table" and tr.__drawing and tr.line then
            local line = tr.line
            line.Color = col
            line.From = from
            line.To = to
            line.Visible = NoxaESP.tracerEnabled == true
            line.Thickness = 2
            line.Transparency = 1
            return
        end
        local frame = (type(tr) == "table" and tr.frame) or tr
        if not frame then return end
        local dx, dy = to.X - from.X, to.Y - from.Y
        local dist = math.sqrt(dx * dx + dy * dy)
        if dist < 2 then frame.Visible = false; return end
        frame.Visible = true
        frame.BackgroundColor3 = col
        frame.Size = UDim2.fromOffset(dist, LINE_T)
        frame.Position = UDim2.fromOffset((from.X + to.X) * 0.5, (from.Y + to.Y) * 0.5)
        frame.Rotation = math.deg(math.atan2(dy, dx))
    end

    local function w2s(pos)
        local v, on = Camera:WorldToViewportPoint(pos)
        return Vector2.new(v.X, v.Y), on and v.Z > 0
    end

    local function bounds(char)
        local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
        local any = false
        for _, p in ipairs(char:GetChildren()) do
            if p:IsA("BasePart") and (p.Name == "Head" or p.Name == "Torso"
                or p.Name == "UpperTorso" or p.Name == "LowerTorso"
                or p.Name == "HumanoidRootPart" or p.Name:find("Arm")
                or p.Name:find("Leg") or p.Name:find("Hand") or p.Name:find("Foot")) then
                local cf, size = p.CFrame, p.Size
                for ox = -1, 1, 2 do for oy = -1, 1, 2 do for oz = -1, 1, 2 do
                    local wp = (cf * CFrame.new(ox * size.X * 0.5, oy * size.Y * 0.5, oz * size.Z * 0.5)).Position
                    local scr, on = w2s(wp)
                    if on then
                        any = true
                        minX = math.min(minX, scr.X); minY = math.min(minY, scr.Y)
                        maxX = math.max(maxX, scr.X); maxY = math.max(maxY, scr.Y)
                    end
                end end end
            end
        end
        if not any then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local scr, on = w2s(hrp.Position)
                if on then return Vector2.new(scr.X - 25, scr.Y - 45), Vector2.new(50, 90) end
            end
            return nil
        end
        local pad = 2
        return Vector2.new(minX - pad, minY - pad),
               Vector2.new(math.max(8, maxX - minX + pad * 2), math.max(12, maxY - minY + pad * 2))
    end

    local function removeESP(plr)
        local d = ESP[plr]
        if not d then return end
        if d.box and d.box.folder then d.box.folder:Destroy() end
        if d.tracer then
            if type(d.tracer) == "table" and d.tracer.__drawing and d.tracer.line then
                pcall(function() d.tracer.line.Visible = false; d.tracer.line:Remove() end)
            elseif type(d.tracer) == "table" and d.tracer.frame then
                pcall(function() d.tracer.frame:Destroy() end)
            else
                pcall(function() d.tracer:Destroy() end)
            end
        end
        if d.highlight then d.highlight:Destroy() end
        if d.char then clearBillboard(d.char) end
        ESP[plr] = nil
    end

    local function setupESP(plr)
        if plr == LP then return end
        removeESP(plr)
        ESP[plr] = {box = makeBox(), tracer = makeTracer(), highlight = nil, char = nil, nameTag = nil}

        pcall(function()
            local bb = Instance.new("BillboardGui")
            bb.Name = "NoxaUserESPTag"
            bb.Size = UDim2.new(0, 120, 0, 28)
            bb.StudsOffset = Vector3.new(0, 3.2, 0)
            bb.AlwaysOnTop = true
            bb.Enabled = false
            local lbl = Instance.new("TextLabel")
            lbl.Name = "Name"
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = plr.DisplayName or plr.Name
            lbl.TextColor3 = NoxaESP.boxColor or Color3.fromRGB(70, 170, 255)
            lbl.TextStrokeTransparency = 0.4
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 13
            lbl.Parent = bb
            ESP[plr].nameTag = bb
        end)
    end

    local function ensureHighlight(plr, char)
        local d = ESP[plr]
        if not d then return end
        if not NoxaESP.highlightEnabled then
            if d.highlight then d.highlight:Destroy(); d.highlight = nil end
            return
        end
        if d.highlight and d.highlight.Parent == char then return end
        if d.highlight then d.highlight:Destroy() end
        local fillCol = NoxaESP.boxColor or Color3.fromRGB(70, 170, 255)
        d.highlight = NoxaUI.new("Highlight", {
            Name = "NoxaEspHighlight",
            FillColor = fillCol, OutlineColor = WHITE,
            FillTransparency = 0.75, OutlineTransparency = 0,
            DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Parent = char,
    end

    local function onChar(plr, char)
        if plr == LP then return end
        if not ESP[plr] then setupESP(plr) end
        local d = ESP[plr]
            d.char = char
            if NoxaESP.highlightEnabled then ensureHighlight(plr, char) end
        end
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            setupESP(plr)
            if plr.Character then onChar(plr, plr.Character) end
            plr.CharacterAdded:Connect(function(c) onChar(plr, c) end)
        end
    end
    Players.PlayerAdded:Connect(function(plr)
        setupESP(plr)
        plr.CharacterAdded:Connect(function(c) onChar(plr, c) end)
    end)
    Players.PlayerRemoving:Connect(removeESP)

    task.spawn(function()
        while true do
            pcall(function()
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LP and not ESP[plr] then
                        setupESP(plr)
                        if plr.Character then onChar(plr, plr.Character) end
                    end
                end
                for plr in pairs(ESP) do
                    if not plr.Parent then removeESP(plr) end
                end
            end)
            task.wait(0.4)
        end
    end)

    RunS.RenderStepped:Connect(function()

        if NoxaESP._disabled then return end
        Camera = workspace.CurrentCamera
        if not Camera then return end

        local myLeft = ragdollLeft(LP)

        if LP.Character then
            clearBillboard(LP.Character)
        end

        if NoxaESP.ragdollNotify then
            if myLeft > 0 then
                toastUpdate("YOU ARE RAGDOLL", "RÉCUPÉRATION EN COURS", myLeft)
            else
                local bestName, bestLeft = nil, 0
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LP then
                        local left = ragdollLeft(plr)
                        if left > bestLeft then
                            bestLeft = left
                            bestName = string.upper(plr.DisplayName or plr.Name)
                        end
                    end
                end
                if bestName then
                    toastUpdate(bestName .. " IS RAGDOLL", "CIBLE AU SOL", bestLeft)
                else
                    toastUpdate("", nil, 0)
                end
            end
        else
            toastUpdate("", nil, 0)
        end

        if not (NoxaESP.boxEnabled or NoxaESP.tracerEnabled
            or NoxaESP.highlightEnabled or NoxaESP.ragdollTimer) then
            for _, d in pairs(ESP) do
                hideBox(d.box)
                if d.tracer then d.tracer.Visible = false end
            end
            return
        end

        local vs = Camera.ViewportSize

        local from = Vector2.new(vs.X * 0.5, vs.Y - 88)
            local lc = LP.Character
            local lr = lc and lc:FindFirstChild("HumanoidRootPart")
            if lr then
                local lp, lon = Camera:WorldToViewportPoint(lr.Position)
                if lon and lp.Z > 0 then
                    from = Vector2.new(lp.X, lp.Y + 15)
                end
            end
        end

        local function hideTracer(tr)
            if not tr then return end
            if type(tr) == "table" and tr.__drawing and tr.line then
                pcall(function() tr.line.Visible = false end)
            elseif type(tr) == "table" and tr.frame then
                tr.frame.Visible = false
            else
                pcall(function() tr.Visible = false end)
            end
        end

        local function aceTracerTo(hrp)
            local rootPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            local targetX, targetY = rootPos.X, rootPos.Y
            local targetVisible = onScreen and rootPos.Z > 0
            if not targetVisible then
                local centerX, centerY = vs.X / 2, vs.Y / 2
                local dx = rootPos.X - centerX
                local dy = rootPos.Y - centerY
                if rootPos.Z <= 0 then dx = -dx; dy = -dy end
                if math.abs(dx) < 1 and math.abs(dy) < 1 then
                    local rel = Camera.CFrame:PointToObjectSpace(hrp.Position)
                    dx = rel.X; dy = -rel.Y
                    if rootPos.Z <= 0 then dx = -dx; dy = -dy end
                end
                local edgePad = 10
                local scaleX = (dx ~= 0) and ((vs.X / 2 - edgePad) / math.abs(dx)) or math.huge
                local scaleY = (dy ~= 0) and ((vs.Y / 2 - edgePad) / math.abs(dy)) or math.huge
                local scale = math.min(scaleX, scaleY)
                if scale == math.huge or scale ~= scale then scale = 1 end
                targetX = math.clamp(centerX + dx * scale, edgePad, vs.X - edgePad)
                targetY = math.clamp(centerY + dy * scale, edgePad, vs.Y - edgePad)
            end
            return Vector2.new(targetX, targetY)
        end

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                if not ESP[plr] then setupESP(plr) end
                local d = ESP[plr]
                local char = plr.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not (char and hum and hrp and hum.Health > 0) then
                    hideBox(d.box)
                    hideTracer(d.tracer)
                    if d.nameTag then d.nameTag.Enabled = false end
                else
                    d.char = char
                    if NoxaESP.highlightEnabled then ensureHighlight(plr, char) end

                    if NoxaESP.ragdollTimer then
                        local lbl = ensureBillboard(char)
                        local left = ragdollLeft(plr)
                        if lbl then
                            if left > 0 then
                                lbl.Visible = true
                                lbl.Text = string.format("RAG %.1fs", left)
                                if left < 1 then
                                    lbl.TextColor3 = Color3.fromRGB(255, 80, 80)
                                else
                                    lbl.TextColor3 = Color3.fromRGB(255, 200, 80)
                                end
                            else
                                lbl.Visible = false
                                lbl.Text = ""
                            end
                        end
                    else
                        clearBillboard(char)
                    end

                    if NoxaESP.boxEnabled then
                        local tl, sz = bounds(char)
                        if tl and sz then updateBox(d.box, tl, sz) else hideBox(d.box) end
                    else
                        hideBox(d.box)
                    end

                    if d.nameTag then
                        local show = NoxaESP.userESPEnabled == true
                        d.nameTag.Enabled = show
                        if show then
                            local head = char:FindFirstChild("Head") or hrp
                            if head then
                                d.nameTag.Adornee = head
                                d.nameTag.Parent = head
                            end
                            local nl = d.nameTag:FindFirstChild("Name")
                            if nl then
                                nl.Text = plr.DisplayName or plr.Name
                                nl.TextColor3 = NoxaESP.boxColor or Color3.fromRGB(70, 170, 255)
                            end
                        end
                    end

                    if NoxaESP.tracerEnabled and d.tracer then
                        local to = aceTracerTo(hrp)
                        updateTracer(d.tracer, from, to, true)
                    else
                        hideTracer(d.tracer)
                    end
                end
            end
        end
    end)

    function NoxaESP:setBox(on)
        self.boxEnabled = false
        for _, d in pairs(ESP) do if d.box then hideBox(d.box) end end
    end
    function NoxaESP:setBoxStyle(s) self.boxStyle = s or "Normal" end
    function NoxaESP:setTracer(on)
        self.tracerEnabled = false
        for _, d in pairs(ESP) do
            if d.tracer then
                if type(d.tracer) == "table" and d.tracer.__drawing and d.tracer.line then
                    pcall(function() d.tracer.line.Visible = false end)
                elseif type(d.tracer) == "table" and d.tracer.frame then
                    d.tracer.frame.Visible = false
                else
                    pcall(function() d.tracer.Visible = false end)
                end
            end
        end
    end
    function NoxaESP:setHighlight(on)
        self.highlightEnabled = false
        for _, d in pairs(ESP) do
            if d.highlight then d.highlight:Destroy(); d.highlight = nil end
        end
    end
    function NoxaESP:setRagdollTimer(on)
        self.ragdollTimer = false
        for _, d in pairs(ESP) do if d.char then clearBillboard(d.char) end end
        if LP.Character then clearBillboard(LP.Character) end
    end
    function NoxaESP:setUserESP(on)
        self.userESPEnabled = false
        for _, d in pairs(ESP) do
            if d.nameTag then d.nameTag.Enabled = false end
        end
    end
    function NoxaESP:setRagdollNotify(on)
        self.ragdollNotify = false
        toastOut()
    end

    function NoxaESP:applyAccentColors(boxCol, tracerCol)
        self.boxColor = boxCol or self.boxColor or ACCENT
        self.tracerColor = tracerCol or self.tracerColor or self.boxColor
        local col = self.boxColor
        local tCol = self.tracerColor
        for _, d in pairs(ESP) do

            if d.highlight and d.highlight.Parent then
                pcall(function() d.highlight.FillColor = col end)
            end

            if d.box then
                pcall(function()
                    if d.box.lines then
                        for _, ln in ipairs(d.box.lines) do
                            if ln then ln.BackgroundColor3 = col end
                        end
                    end
                    if d.box.ringStroke then d.box.ringStroke.Color = col end
                    if d.box.ring then d.box.ring.BackgroundColor3 = col end
                end)
            end

            if d.tracer then
                pcall(function()
                    if type(d.tracer) == "table" and d.tracer.__drawing and d.tracer.line then
                        d.tracer.line.Color = tCol
                    elseif type(d.tracer) == "table" and d.tracer.frame then
                        d.tracer.frame.BackgroundColor3 = tCol
                    elseif d.tracer.BackgroundColor3 ~= nil then
                        d.tracer.BackgroundColor3 = tCol
                    end
                end)
            end
        end

        pcall(function()
            for _, plr in ipairs(Players:GetPlayers()) do
                local char = plr.Character
                local head = char and char:FindFirstChild("Head")
                if head then
                    local rbb = head:FindFirstChild("NoxaRagdollBB")
                    if rbb then
                        local t = rbb:FindFirstChild("Timer")
                        if t and t.TextColor3 ~= Color3.fromRGB(255, 120, 120) then
                            t.TextColor3 = col
                        end
                    end
                end
            end
            local bb = _G.NoxaBillboard
            if bb and bb.rag then
                if bb.rag.TextColor3 ~= Color3.fromRGB(255, 120, 120) then
                    bb.rag.TextColor3 = col
                end
            end
        end)

        pcall(function()
            if nCard then
                local st = nCard:FindFirstChildOfClass("UIStroke")
                if st then st.Color = col end
            end
            if nGlow then nGlow.Color = col end
            if nIcon then
                nIcon.BackgroundColor3 = col
                local ist = nIcon:FindFirstChildOfClass("UIStroke")
                if ist then ist.Color = col end
                local bang = nIcon:FindFirstChildOfClass("TextLabel")
                if bang then bang.TextColor3 = col end
            end
            if nTitle then nTitle.TextColor3 = col end
            if nBarFill then nBarFill.BackgroundColor3 = col end
            if nTimer and nTimer.TextColor3 ~= Color3.fromRGB(255, 120, 120) then
                nTimer.TextColor3 = col
            end
        end)
    end
end

task.wait()
NoxaUI.mkSection(P_COMBAT,"AUTO GRAB")
    local function wire(row, fn)
        if not row then return end
        ToggleStates.__on(row, function(state)
            fn(state == true)
            NoxaCfg.saveConfig()
        end)
    end

    local function setMode(mode)
        SpeedSystem.stealMode = mode
        if mode == "V1" then
            SpeedSystem.stealRadius = 60
            SpeedSystem.stealDuration = 1.3
        elseif mode == "V2 SEMI" then
            SpeedSystem.stealRadius = SpeedSystem.v2SemiRadius
            SpeedSystem.stealDuration = SpeedSystem.v2SemiHoldMax
        elseif mode == "V3" then
            SpeedSystem.stealRadius = 60
            SpeedSystem.stealDuration = SpeedSystem.v3HalfHoldMax
        elseif mode == "V4" then
            SpeedSystem.stealRadius = V4_DEFAULTS.stealRadius
            SpeedSystem.stealDuration = V4_DEFAULTS.stealDuration
            local lvl = math.clamp(tonumber(SpeedSystem.v4ModeLevel) or V4_DEFAULTS.modeLevel, 1, 4)
            local cfg = V4_MODE_CFG[lvl] or V4_MODE_CFG[V4_DEFAULTS.modeLevel]
            SpeedSystem.v4ModeLevel = lvl
            SpeedSystem.v4Threshold = cfg.threshold or V4_DEFAULTS.threshold
            SpeedSystem.v4NearDist = cfg.nearDist or V4_DEFAULTS.nearDist
            SpeedSystem.v4WaitNearMax = tonumber(SpeedSystem.v4WaitNearMax) or V4_DEFAULTS.waitNearMax
        end
        updateModeVisual()
    end

    local grabRow, grabArrow = NoxaUI.mkToggle(P_COMBAT, "Auto Steal", SpeedSystem.autoStealEnabled, true)
    wire(grabRow, function(v)
        SpeedSystem.autoStealEnabled = v == true
        if stealProgressBar then
            if SpeedSystem.stealBarStyle ~= "V1" then
                stealProgressBar.Visible = true
            end
            if SpeedSystem.autoStealEnabled then
                stealProgressFill.Size = UDim2.new(0,0,1,0)
                progressPct.Text = "0%"
                progressRadLbl.Text = "--FPS · --ms"
                startStealPulse()
                startAutoSteal()
            else
                stopStealPulse()
                stopAutoSteal()
                setBarState("IDLE")
                progressPct.Text = "0%"
                if stealProgressFill then stealProgressFill.Size = UDim2.new(0,0,1,0) end
            end
        elseif SpeedSystem.autoStealEnabled then
            startAutoSteal()
        else
            stopAutoSteal()
        end
        pcall(function() NoxaCfg.dirty = true; NoxaCfg.saveConfig(true) end)
    end)

        SpeedSystem.stealBarStyle = "V3"
        pcall(applyStealBarStyle, "V3")
    end

    local grabModeCard = NoxaUI.new("Frame", {
        Name = "GrabModeCard",
        Size = UDim2.new(1, -4, 0, 64),
        BackgroundColor3 = ROW_BG, BackgroundTransparency = 0.12,
        BorderSizePixel = 0, Visible = false, Parent = P_COMBAT,
        local open = false
        if grabArrow then
            grabArrow.MouseButton1Click:Connect(function()
                open = not open
                grabModeCard.Visible = open
                grabArrow.Text = open and "▲" or "▼"
            end)
        end
    end
    NoxaUI.corner(grabModeCard, 10); NoxaUI.darkStroke(grabModeCard, 1)
    NoxaUI.new("TextLabel", {
        Position = UDim2.new(0, 12, 0, 6), Size = UDim2.new(1, -24, 0, 12),
        BackgroundTransparency = 1, Text = "SUB OPTIONS",
        TextColor3 = TEXT_DIM, TextSize = 9, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = grabModeCard,
    NoxaUI.new("TextLabel", {
        Position = UDim2.new(0, 12, 0, 20), Size = UDim2.new(1, -24, 0, 14),
        BackgroundTransparency = 1, Text = "Steal Mode",
        TextColor3 = TEXT_MAIN or Color3.fromRGB(230,230,235),
        TextSize = 12, Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = grabModeCard,

    local grabTrack = NoxaUI.new("Frame", {
        Position = UDim2.new(0, 10, 0, 38),
        Size = UDim2.new(1, -20, 0, 22),
        BackgroundColor3 = Color3.fromRGB(18,20,26),
        BackgroundTransparency = 0.15, BorderSizePixel = 0, Parent = grabModeCard,
    NoxaUI.corner(grabTrack, 999)
    local grabSlider = NoxaUI.new("Frame", {
        Name = "GrabModeSlider", ZIndex = 6,
        Size = UDim2.new(1/3, -4, 1, -4),
        Position = UDim2.new(0, 2, 0, 2),
        BackgroundColor3 = ACCENT or Color3.fromRGB(70, 170, 255),
        BorderSizePixel = 0, Parent = grabTrack,
    NoxaUI.corner(grabSlider, 999)
    NoxaUI.regAccent(grabSlider)

    local GRAB_LABELS = {"Semi", "V3"}
    local GRAB_MODES  = {"V2 SEMI", "V3"}
    local grabBtns = {}

    local function currentGrabIdx()
        local m = SpeedSystem.stealMode or "V2 SEMI"
        if m == "V3" then return 1 end
        return 0
    end

    local function setGrabModeUI(idx)
        idx = math.clamp(idx, 0, 1)
        TweenService:Create(grabSlider, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
            Position = UDim2.new(idx / 2, 2, 0, 2),
            Size = UDim2.new(1/2, -4, 1, -4),
        }):Play()
        for i, btn in ipairs(grabBtns) do
            btn.TextColor3 = ((i - 1) == idx)
                and Color3.fromRGB(255,255,255)
                or (TEXT_DIM or Color3.fromRGB(140,150,160))
        end
    end

    local function applyGrabMode(idx)
        idx = math.clamp(idx, 0, 1)
        local mode = GRAB_MODES[idx + 1]
        setMode(mode)
        setGrabModeUI(idx)
        if SpeedSystem.autoStealEnabled then
            pcall(stopAutoSteal)
            task.defer(function()
                if SpeedSystem.autoStealEnabled then pcall(startAutoSteal) end
            end)
        end
        pcall(function() NoxaCfg.dirty = true; NoxaCfg.saveConfig(true) end)
    end

    grabSlider.Size = UDim2.new(1/2, -4, 1, -4)

    for i, name in ipairs(GRAB_LABELS) do
        local btn = NoxaUI.new("TextButton", {
            ZIndex = 7,
            Position = UDim2.new((i - 1) / 2, 0, 0, 0),
            Size = UDim2.new(1/2, 0, 1, 0),
            BackgroundTransparency = 1, Text = name,
            TextColor3 = TEXT_DIM or Color3.fromRGB(140,150,160),
            TextSize = 11, Font = Enum.Font.GothamBold,
            AutoButtonColor = false, Parent = grabTrack,
        grabBtns[i] = btn
        btn.MouseButton1Click:Connect(function()
            applyGrabMode(i - 1)
        end)
    end
    setGrabModeUI(currentGrabIdx())

        local m = SpeedSystem.stealMode
        if m == "V4" or m == "V1" or m == "Normal" then
            setMode("V2 SEMI")
        end
        setGrabModeUI(currentGrabIdx())
    end
    _G.NoxaSetGrabModeUI = function()
        setGrabModeUI(currentGrabIdx())
    end
end

task.wait()
NoxaUI.mkSection(P_COMBAT,"BAT AIMBOT")

local BatAimbot = {
    enabled        = false,
    version        = "V2",
    speed          = 58,
    laggerSpeed    = 40,
    bypassEnabled  = false,
    autoDisableOnHit = false,
    _conn          = nil,
    _sphere        = nil,
    _velHistory    = {},
    _accelHistory  = {},
    _aerialVelHist = {},
    _vertVelHist   = {},
    _smoothedVel   = Vector3.zero,
    _aerialSmooth  = Vector3.zero,
    _airTime       = 0,
    _lastYVel      = 0,
    _lastTargetPos = nil,
    _targetVel     = Vector3.zero,
    _lastActivTime = 0,
    _v1NotifGui    = nil,
    _v1ShimConn    = nil,
    _v1SignModel   = nil,

local function _batFind()
    local char = LP.Character
    if not char then return nil end
    for _, t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") then
            local n = t.Name:lower()
            if n:find("bat") or n:find("slap") or n:find("sword") or n:find("blade") then return t end
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                if n:find("bat") or n:find("slap") or n:find("sword") or n:find("blade") then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then pcall(function() hum:EquipTool(t) end) end
                    return t
                end
            end
        end
    end
    return nil
end

local function _batClosest()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local best, bd = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if tr and hum and hum.Health > 0 then
                local d = (tr.Position - root.Position).Magnitude
                if d < bd then bd = d; best = tr end
            end
        end
    end
    return best
end

local function _v2AvgVec(t)
    if #t == 0 then return Vector3.zero end
    local s = Vector3.zero
    for _, v in ipairs(t) do s = s + v end
    return s / #t
end
local function _v2AvgY(t)
    if #t == 0 then return 0 end
    for _, y in ipairs(t) do s = s + y end
    return s / #t
end
local function _v2Push(t, v, max)
    table.insert(t, v)
    if #t > max then table.remove(t, 1) end
end
local function _v2IsErratic(hist)
    if #hist < 3 then return false end
    for i = 2, #hist do
        local a = Vector3.new(hist[i-1].X,0,hist[i-1].Z)
        local b = Vector3.new(hist[i].X,0,hist[i].Z)
        if a.Magnitude > 5 and b.Magnitude > 5 and a.Unit:Dot(b.Unit) < 0.3 then c = c + 1 end
    end
    return c >= 3
end
local function _v2IsInfJump(hist)
    if #hist < 3 then return false end
    for i = 2, #hist do
        if math.abs(hist[i].Y - hist[i-1].Y) > 15 then c = c + 1 end
    end
    return c >= 2
end
local function _v2CreateSphere()
    if BatAimbot._sphere then
        pcall(function()
            if BatAimbot._sphere.model then BatAimbot._sphere.model:Destroy() end
        end)
        BatAimbot._sphere = nil
    end

    local model = Instance.new("Model")
    model.Name = "NoxaAimbotV2"
    model.Parent = workspace

    local function makePart(sz, col, tr)
        local p = Instance.new("Part")
        p.Anchored    = true
        p.CanCollide  = false
        p.CastShadow  = false
        p.Material    = Enum.Material.Neon
        p.Shape       = Enum.PartType.Block
        p.Size        = sz
        p.Color       = col
        p.Transparency = tr
        p.Parent      = model
        return p
    end

    local cube = makePart(Vector3.new(1.2,1.2,1.2), Color3.fromRGB(80,180,255), 0.55)

    local ringX = makePart(Vector3.new(0.06, 2.6, 2.6), Color3.fromRGB(80,180,255),  0.15)
    local ringY = makePart(Vector3.new(2.6,  0.06, 2.6), Color3.fromRGB(80,180,255), 0.15)
    local ringZ = makePart(Vector3.new(2.6,  2.6, 0.06), Color3.fromRGB(80,180,255),  0.15)

    local light = Instance.new("PointLight", cube)
    light.Color      = Color3.fromRGB(80,180,255)
    light.Range      = 14
    light.Brightness = 4

    local att0 = Instance.new("Attachment", cube)
    local att1 = Instance.new("Attachment", cube)
    att1.Position = Vector3.new(0, 0.8, 0)
    local trail = Instance.new("Trail")
    trail.Attachment0  = att0
    trail.Attachment1  = att1
    trail.Lifetime     = 0.18
    trail.MinLength    = 0
    trail.FaceCamera   = true
    trail.Color        = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(80,180,255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80,180,255)),
        ColorSequenceKeypoint.new(1,   Color3.new(1,1,1)),
    trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1, 0),
        NumberSequenceKeypoint.new(1, 1,   0),
    trail.WidthScale = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1, 0),
        NumberSequenceKeypoint.new(1, 0, 0),
    trail.Parent = cube

    BatAimbot._sphere = {
        model = model,
        cube  = cube,
        ringX = ringX,
        ringY = ringY,
        ringZ = ringZ,
        angle = 0,
    return BatAimbot._sphere
end
local function _v2DestroySphere()
    if BatAimbot._sphere then
        pcall(function() BatAimbot._sphere.model:Destroy() end)
        BatAimbot._sphere = nil
    end
end

local function _batStartV1()
    local char = LP.Character
    local hum0 = char and char:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate = false end

        local sgui = Instance.new("ScreenGui")
        sgui.Name           = "NoxaV1Sign"
        sgui.ResetOnSpawn   = false
        sgui.IgnoreGuiInset = true
        sgui.DisplayOrder   = 950
        sgui.Parent         = PlayerGui

        local SIGN_W = 300
        local SIGN_H = 105
        local PIEU_H = 52

        local container = Instance.new("Frame")
        container.AnchorPoint        = Vector2.new(0.5, 0)
        container.Position           = UDim2.new(0.5, 0, 0, -(SIGN_H + PIEU_H + 20))
        container.Size               = UDim2.new(0, SIGN_W, 0, SIGN_H + PIEU_H)
        container.BackgroundTransparency = 1
        container.BorderSizePixel    = 0
        container.ClipsDescendants   = false
        container.Parent             = sgui

        local planche = Instance.new("Frame")
        planche.Size             = UDim2.new(1, 0, 0, SIGN_H)
        planche.Position         = UDim2.new(0, 0, 0, 0)
        planche.BackgroundColor3 = Color3.fromRGB(212, 170, 112)
        planche.BorderSizePixel  = 0
        planche.ZIndex           = 2
        planche.Parent           = container
        Instance.new("UICorner", planche).CornerRadius = UDim.new(0, 10)

        local wg = Instance.new("UIGradient")
        wg.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(232, 192, 136)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 156, 92)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(224, 178, 118)),
        wg.Rotation = 95
        wg.Parent   = planche

        local ps = Instance.new("UIStroke")
        ps.Color           = Color3.fromRGB(108, 62, 14)
        ps.Thickness       = 3
        ps.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        ps.Parent          = planche

        local ts = Instance.new("TextLabel")
        ts.Size = UDim2.new(1,0,0,38); ts.Position = UDim2.new(0,2,0,12)
        ts.BackgroundTransparency=1; ts.Text="YOU NEED TO CLICK"
        ts.TextColor3=Color3.fromRGB(142,88,22); ts.Font=Enum.Font.GothamBlack
        ts.TextSize=18; ts.TextScaled=false
        ts.TextXAlignment=Enum.TextXAlignment.Center; ts.ZIndex=3; ts.Parent=planche

        local tl = Instance.new("TextLabel")
        tl.Size = UDim2.new(1,0,0,38); tl.Position = UDim2.new(0,0,0,10)
        tl.BackgroundTransparency=1; tl.Text="YOU NEED TO CLICK"
        tl.TextColor3=Color3.fromRGB(58,28,4); tl.Font=Enum.Font.GothamBlack
        tl.TextSize=18; tl.TextScaled=false
        tl.TextXAlignment=Enum.TextXAlignment.Center; tl.ZIndex=4; tl.Parent=planche

        local sep = Instance.new("Frame")
        sep.Size=UDim2.new(0.62,0,0,1); sep.Position=UDim2.new(0.19,0,0,50)
        sep.BackgroundColor3=Color3.fromRGB(138,88,28); sep.BackgroundTransparency=0.5
        sep.BorderSizePixel=0; sep.ZIndex=4; sep.Parent=planche
        Instance.new("UICorner",sep).CornerRadius=UDim.new(1,0)

        local ss = Instance.new("TextLabel")
        ss.Size=UDim2.new(1,0,0,28); ss.Position=UDim2.new(0,2,0,58)
        ss.BackgroundTransparency=1; ss.Text="V1 DON'T HAVE AUTO SWING"
        ss.TextColor3=Color3.fromRGB(148,96,34); ss.Font=Enum.Font.GothamBold
        ss.TextSize=12; ss.TextScaled=false
        ss.TextXAlignment=Enum.TextXAlignment.Center; ss.ZIndex=3; ss.Parent=planche

        local sl = Instance.new("TextLabel")
        sl.Size=UDim2.new(1,0,0,28); sl.Position=UDim2.new(0,0,0,56)
        sl.BackgroundTransparency=1; sl.Text="V1 DON'T HAVE AUTO SWING"
        sl.TextColor3=Color3.fromRGB(78,44,10); sl.Font=Enum.Font.GothamBold
        sl.TextSize=12; sl.TextScaled=false
        sl.TextXAlignment=Enum.TextXAlignment.Center; sl.ZIndex=4; sl.Parent=planche

        local pieu = Instance.new("Frame")
        pieu.AnchorPoint       = Vector2.new(0.5, 0)
        pieu.Position          = UDim2.new(0.5, 0, 0, SIGN_H - 6)
        pieu.Size              = UDim2.new(0, 18, 0, PIEU_H)
        pieu.BackgroundColor3  = Color3.fromRGB(138, 88, 42)
        pieu.BorderSizePixel   = 0
        pieu.ZIndex            = 1
        pieu.Parent            = container
        Instance.new("UICorner", pieu).CornerRadius = UDim.new(0, 5)
        local pg = Instance.new("UIGradient")
        pg.Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,Color3.fromRGB(162,112,55)),
            ColorSequenceKeypoint.new(1,Color3.fromRGB(98,58,16)),
        }); pg.Rotation=90; pg.Parent=pieu
        local pst = Instance.new("UIStroke")
        pst.Color=Color3.fromRGB(72,42,8); pst.Thickness=2; pst.Parent=pieu

        local fG = Instance.new("Frame")
        fG.AnchorPoint=Vector2.new(1,0.5)
        fG.Position=UDim2.new(0.5,-11,0,SIGN_H+14)
        fG.Size=UDim2.new(0,26,0,13)
        fG.BackgroundColor3=Color3.fromRGB(98,178,70)
        fG.BorderSizePixel=0; fG.ZIndex=3; fG.Rotation=38; fG.Parent=container
        Instance.new("UICorner",fG).CornerRadius=UDim.new(1,0)
        local fGs=Instance.new("UIStroke",fG); fGs.Color=Color3.fromRGB(52,112,32); fGs.Thickness=1.5

        local fD = Instance.new("Frame")
        fD.AnchorPoint=Vector2.new(0,0.5)
        fD.Position=UDim2.new(0.5,11,0,SIGN_H+10)
        fD.Size=UDim2.new(0,22,0,11)
        fD.BackgroundColor3=Color3.fromRGB(120,198,82)
        fD.BorderSizePixel=0; fD.ZIndex=3; fD.Rotation=-30; fD.Parent=container
        Instance.new("UICorner",fD).CornerRadius=UDim.new(1,0)
        local fDs=Instance.new("UIStroke",fD); fDs.Color=Color3.fromRGB(52,112,32); fDs.Thickness=1.5

        pieu.Position    = UDim2.new(0.5,0, 0, 0)
        planche.Position = UDim2.new(0,0, 0, PIEU_H - 6)
        fG.Position      = UDim2.new(0.5,-11, 0, PIEU_H - 18)
        fD.Position      = UDim2.new(0.5,11,  0, PIEU_H - 22)

        local DEST_Y = 8
        TweenService:Create(container,
            TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5, 0, 0, DEST_Y)}
        ):Play()

        local swayConn
        task.delay(0.6, function()
            swayConn = RunService.RenderStepped:Connect(function()
                if not container.Parent then
                    if swayConn then swayConn:Disconnect() end; return
                end
                container.Rotation = math.sin(tick() * 1.4) * 1.4
            end)
        end)

        BatAimbot._v1SignModel = sgui
        BatAimbot._v1ShimConn = swayConn

        task.delay(5, function()
            if swayConn then swayConn:Disconnect(); swayConn = nil end
            if container and container.Parent then
                container.Rotation = 0
                TweenService:Create(container,
                    TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                    {Position = UDim2.new(0.5, 0, 0, -(SIGN_H + PIEU_H + 20))}
                ):Play()
                task.delay(0.45, function()
                    pcall(function() sgui:Destroy() end)
                    if BatAimbot._v1SignModel == sgui then
                        BatAimbot._v1SignModel = nil
                        BatAimbot._v1ShimConn  = nil
                    end
                end)
            end
        end)
    end

    BatAimbot._conn = RunService.RenderStepped:Connect(function()
        if not BatAimbot.enabled then return end
            local blocked = false
            pcall(function()
                if SpeedSystem.isActionBlocked then
                    blocked = select(1, SpeedSystem:isActionBlocked("aimbot")) == true
                elseif SpeedSystem.safeModeEnabled and SpeedSystem:isHoldingBrainrot() then
                    blocked = true
                end
            end)
            if blocked then
                BatAimbot.enabled = false
                pcall(function() if type(_batStop) == "function" then _batStop() end end)
                return
            end
        end
        local c = LP.Character; if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart"); if not root then return end
        local hum  = c:FindFirstChildOfClass("Humanoid");  if not hum  then return end

        if not c:FindFirstChildOfClass("Tool") then
            local bat = _batFind()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end

        local target = _batClosest(); if not target then return end

        local tVel      = target.AssemblyLinearVelocity
        local myPos     = root.Position
        local tPos      = target.Position
        local spd       = SpeedSystem.laggerActive and BatAimbot.laggerSpeed or BatAimbot.speed

        local predictPos = tPos + tVel * 0.12
        local dir        = predictPos - myPos
        local flat       = Vector3.new(dir.X, 0, dir.Z)
        local flatDir    = flat.Magnitude > 0.05 and flat.Unit or Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)
        if flatDir.Magnitude < 0.01 then flatDir = Vector3.new(0, 0, -1) else flatDir = flatDir.Unit end

        local desiredH  = tPos.Y + 2.2
        local yVel      = (desiredH - myPos.Y) * 22 + tVel.Y * 0.55
        if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 8) end
        yVel = math.clamp(yVel, -80, 120)

        local desiredVel = Vector3.new(flatDir.X * spd, yVel, flatDir.Z * spd)
        root.AssemblyLinearVelocity = desiredVel
        pcall(function()
            if root:FindFirstChild("NoxaSpeedLV") then
                root.NoxaSpeedLV.Enabled = false
                root.NoxaSpeedLV.PlaneVelocity = Vector2.zero
            end
        end)

        local speed3      = tVel.Magnitude
        local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
        local predictedPos = tPos + tVel * predictTime
        local toPredict    = predictedPos - myPos
        if toPredict.Magnitude > 0.1 then
            local goalCF  = CFrame.lookAt(myPos, predictedPos)
            local diffCF  = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5)
            ry = math.clamp(ry, -2.5, 2.5)
            rz = math.clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(
                Vector3.new(rx * 42, ry * 42, rz * 42)
        end

        if (tPos - myPos).Magnitude < 12 then
            if SpeedSystem.antiDesyncAutoSwingEnabled then
                local tool = c:FindFirstChildOfClass("Tool")
                if tool then pcall(function() tool:Activate() end) end
            end
            if BatAimbot.autoDisableOnHit then
            end
        end
    end)
end

local function _batStartV2()
    local char = LP.Character
    local hum0 = char and char:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate = false end

    _v2CreateSphere()

    BatAimbot._velHistory    = {}
    BatAimbot._accelHistory  = {}
    BatAimbot._aerialVelHist = {}
    BatAimbot._vertVelHist   = {}
    BatAimbot._smoothedVel   = Vector3.zero
    BatAimbot._aerialSmooth  = Vector3.zero
    BatAimbot._airTime       = 0
    BatAimbot._lastYVel      = 0
    BatAimbot._lastTargetPos = nil
    BatAimbot._targetVel     = Vector3.zero
    BatAimbot._lastActivTime = 0

    local FOLLOW_SPEED    = 55
    local MAX_SPEED       = 59
    local ACTIVATE_DIST   = 13
    local ACTIVATION_DELAY = 0.2
    local VEL_SMOOTH      = 0.2
    local AERIAL_SMOOTH   = 0.15
    local MIN_AIRBORNE    = 0.08
    local JUMP_THRESHOLD  = 8
    local JUMP_SPEED_BOOST = 1.5
    local SPHERE_SMOOTH   = 15

    BatAimbot._conn = RunService.RenderStepped:Connect(function(dt)
        if not BatAimbot.enabled then return end
        dt = tonumber(dt) or 0
        if dt < 1e-4 then dt = 1/60 end
        local c = LP.Character; if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart"); if not root then return end
        local hum  = c:FindFirstChildOfClass("Humanoid");  if not hum  then return end

        if not c:FindFirstChildOfClass("Tool") then
            local bat = _batFind()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end

        local target = _batClosest()
        if not target then
            if BatAimbot._sphere and BatAimbot._sphere.ring then
                BatAimbot._sphere.ring.Transparency = 1
            end
            BatAimbot._lastTargetPos = nil
            BatAimbot._targetVel     = Vector3.zero
            BatAimbot._velHistory    = {}
            BatAimbot._accelHistory  = {}
            BatAimbot._aerialVelHist = {}
            BatAimbot._vertVelHist   = {}
            BatAimbot._airTime       = 0
            return
        end

        local tPos = target.Position
        local myPos = root.Position

        if BatAimbot._lastTargetPos then
            local rawVel = (tPos - BatAimbot._lastTargetPos) / dt
            local hVel   = Vector3.new(rawVel.X, 0, rawVel.Z)
            if hVel.Magnitude > 80 then rawVel = Vector3.new((hVel.Unit * 80).X, rawVel.Y, (hVel.Unit * 80).Z) end
            local prevAccel = (rawVel - BatAimbot._targetVel) / dt
            _v2Push(BatAimbot._accelHistory, prevAccel, 4)
            _v2Push(BatAimbot._vertVelHist,  rawVel.Y,  5)
            BatAimbot._targetVel    = rawVel
            BatAimbot._smoothedVel  = BatAimbot._smoothedVel:Lerp(rawVel, VEL_SMOOTH)
            _v2Push(BatAimbot._velHistory, rawVel, 8)
        end
        BatAimbot._lastTargetPos = tPos

        local rp = RaycastParams.new()
        rp.FilterType = Enum.RaycastFilterType.Exclude
        pcall(function() rp.FilterDescendantsInstances = {c, LP.Character} end)
        local gr = workspace:Raycast(target.Position, Vector3.new(0, -100, 0), rp)
        local isAirborne = (gr == nil)
        if isAirborne then
            BatAimbot._airTime = BatAimbot._airTime + dt
            _v2Push(BatAimbot._aerialVelHist, BatAimbot._targetVel, 6)
            BatAimbot._aerialSmooth = BatAimbot._aerialSmooth:Lerp(BatAimbot._targetVel, AERIAL_SMOOTH)
        else
            BatAimbot._airTime      = 0
            BatAimbot._aerialVelHist = {}
            BatAimbot._aerialSmooth  = Vector3.zero
        end
        local isTrulyAirborne = isAirborne and BatAimbot._airTime >= MIN_AIRBORNE

        local avgVel   = _v2AvgVec(BatAimbot._velHistory)
        local avgAccel = _v2AvgVec(BatAimbot._accelHistory)
        local avgYVel  = _v2AvgY(BatAimbot._vertVelHist)
        local isErratic  = _v2IsErratic(BatAimbot._velHistory)
        local isInfJump  = _v2IsInfJump(BatAimbot._velHistory)
        local isJumping  = math.abs(BatAimbot._targetVel.Y) > JUMP_THRESHOLD

        local predVel = BatAimbot._targetVel
        local predAccel = avgAccel
        if isInfJump then
            local ah = Vector3.new(avgVel.X, 0, avgVel.Z)
            predVel = Vector3.new(ah.X, BatAimbot._targetVel.Y * 0.5, ah.Z)
            predAccel = Vector3.new(avgAccel.X * 0.5, 0, avgAccel.Z * 0.5)
        elseif isTrulyAirborne then
            local ah = _v2AvgVec(BatAimbot._aerialVelHist)
            predVel = Vector3.new(
                BatAimbot._aerialSmooth.X * 0.6 + ah.X * 0.4,
                avgYVel,
                BatAimbot._aerialSmooth.Z * 0.6 + ah.Z * 0.4
            predAccel = Vector3.zero
        elseif isErratic then
            predVel = Vector3.new(BatAimbot._smoothedVel.X, BatAimbot._targetVel.Y, BatAimbot._smoothedVel.Z)
            predAccel = Vector3.new(avgAccel.X * 0.7, 0, avgAccel.Z * 0.7)
        end

        local ping = 0.1
        local serverDelay = ping + 1/60
        local predictedPos
        if isTrulyAirborne then
            local hv = Vector3.new(predVel.X, 0, predVel.Z) * 0.95
            local vertDisp = predVel.Y * serverDelay - 0.5 * 196.2 * serverDelay * serverDelay
            predictedPos = tPos + hv * serverDelay + Vector3.new(0, vertDisp, 0)
        else
            predictedPos = tPos + predVel * serverDelay
            if predAccel.Magnitude > 1 then
                predictedPos = predictedPos + predAccel * 0.3 * serverDelay * serverDelay * 0.5
            end
        end

        local interceptPoint = predictedPos
        local hVel2 = Vector3.new(predVel.X, 0, predVel.Z)
        if hVel2.Magnitude > 1 then
            interceptPoint = interceptPoint + hVel2.Unit * 3
        end

        if BatAimbot._sphere and BatAimbot._sphere.cube then
            local sp = BatAimbot._sphere
            sp.angle = (sp.angle or 0) + dt * 2.8
            local cf = CFrame.new(interceptPoint)
                * CFrame.Angles(sp.angle * 0.7, sp.angle, sp.angle * 1.3)
            sp.cube.CFrame  = cf
            sp.ringX.CFrame = cf * CFrame.Angles(0, 0, 0)
            sp.ringY.CFrame = cf * CFrame.Angles(math.pi/2, 0, 0)
            sp.ringZ.CFrame = cf * CFrame.Angles(0, math.pi/2, 0)

            local pulse = 0.45 + math.sin(tick() * 6) * 0.15
            sp.cube.Transparency  = pulse
            sp.ringX.Transparency = 0.1 + math.sin(tick() * 4 + 1) * 0.08
            sp.ringY.Transparency = 0.1 + math.sin(tick() * 4 + 2) * 0.08
            sp.ringZ.Transparency = 0.1 + math.sin(tick() * 4 + 3) * 0.08
        end

        local toTarget = interceptPoint - myPos
        if toTarget.Magnitude > 0.1 then
            local currLook = root.CFrame.LookVector
            local tDir     = toTarget.Unit
            local axis     = currLook:Cross(tDir)
            local angle    = math.asin(math.clamp(axis.Magnitude, -1, 1))
            if axis.Magnitude > 0.01 then
                root.AssemblyAngularVelocity = axis.Unit * angle * 80
            end
        end

        local actualDist = (tPos - myPos).Magnitude
        if actualDist <= ACTIVATE_DIST then
            local now = tick()
            if now - BatAimbot._lastActivTime >= ACTIVATION_DELAY then
                BatAimbot._lastActivTime = now
                local tool = c:FindFirstChildOfClass("Tool")
                if tool then pcall(function() tool:Activate() end) end
                if BatAimbot.autoDisableOnHit then
                    local tgt = _batClosest and _batClosest()
                    if tgt then
                    end
                end
            end
        end

        local direction = interceptPoint - myPos
        if direction.Magnitude > 1 then
            local spd = SpeedSystem.laggerActive and BatAimbot.laggerSpeed or FOLLOW_SPEED
            if isJumping then spd = spd * JUMP_SPEED_BOOST end
            if isInfJump then spd = spd * 1.15 end
            spd = math.min(spd, MAX_SPEED)
            root.AssemblyLinearVelocity = direction.Unit * spd
            pcall(function()
                local lv = root:FindFirstChild("NoxaSpeedLV")
                if lv then lv.Enabled = false; lv.PlaneVelocity = Vector2.zero end
            end)
        else
            root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y * 0.5, 0)
        end

        BatAimbot._lastYVel = BatAimbot._targetVel.Y
    end)
end

local function _batStartV3()

    local char = LP.Character
    local hum0 = char and char:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate = false end

    BatAimbot._conn = RunService.RenderStepped:Connect(function()
        if not BatAimbot.enabled then return end
        local c = LP.Character; if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart"); if not root then return end
        local hum  = c:FindFirstChildOfClass("Humanoid");  if not hum  then return end

        if not c:FindFirstChildOfClass("Tool") then
            local bat = _batFind()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end

        local target = _batClosest(); if not target then return end

        local tVel  = target.AssemblyLinearVelocity
        local myPos = root.Position
        local tPos  = target.Position
        local spd   = SpeedSystem.laggerActive and BatAimbot.laggerSpeed or BatAimbot.speed

        if BatAimbot.bypassEnabled then
            if sethiddenproperty then
                pcall(function() sethiddenproperty(root, "PhysicsRepRootPart", target) end)
            end
        end

        local predTime  = math.clamp(tVel.Magnitude / 150, 0.06, 0.22)
        local predAccel = tVel * 0.08
        local predictPos = tPos + tVel * predTime + predAccel * predTime * predTime * 0.5
        predictPos = predictPos + target.CFrame.LookVector * 0.4

        local dir     = predictPos - myPos
        local flat    = Vector3.new(dir.X, 0, dir.Z)
        local flatDir = flat.Magnitude > 0.05 and flat.Unit or Vector3.new(0, 0, -1)

        local desiredH = tPos.Y + 2.5
        local yVel     = (desiredH - myPos.Y) * 22 + tVel.Y * 0.6
        if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 10) end
        yVel = math.clamp(yVel, -80, 120)

        local desiredVel = Vector3.new(flatDir.X * spd, yVel, flatDir.Z * spd)
        root.AssemblyLinearVelocity = desiredVel
        pcall(function()
            local lv = root:FindFirstChild("NoxaSpeedLV")
            if lv then lv.Enabled = false; lv.PlaneVelocity = Vector2.zero end
        end)

        local speed3       = tVel.Magnitude
        local rotPredTime  = math.clamp(speed3 / 150, 0.04, 0.18)
        local rotPredicted = tPos + tVel * rotPredTime
        local toPredict    = rotPredicted - myPos
        if toPredict.Magnitude > 0.1 then
            local goalCF  = CFrame.lookAt(myPos, rotPredicted)
            local diffCF  = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5)
            ry = math.clamp(ry, -2.5, 2.5)
            rz = math.clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(
                Vector3.new(rx * 45, ry * 45, rz * 45)
        end

        if (tPos - myPos).Magnitude < 11 then
            local tool = c:FindFirstChildOfClass("Tool")
            if tool then pcall(function() tool:Activate() end) end
        end
    end)
end

local function _batStop()
    if BatAimbot._conn then
        BatAimbot._conn:Disconnect()
        BatAimbot._conn = nil
    end
    _v2DestroySphere()

    if BatAimbot._v1ShimConn then
        pcall(function() BatAimbot._v1ShimConn:Disconnect() end)
        BatAimbot._v1ShimConn = nil
    end
    if BatAimbot._v1SignModel then
        pcall(function() BatAimbot._v1SignModel:Destroy() end)
        BatAimbot._v1SignModel = nil
    end
    if BatAimbot._v1NotifGui then
        pcall(function() BatAimbot._v1NotifGui:Destroy() end)
        BatAimbot._v1NotifGui = nil
    end
    local c    = LP.Character
    if root then
        pcall(function()
            root.AssemblyLinearVelocity  = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end)
    end
    if hum then pcall(function() hum.AutoRotate = true end) end
end

local function _batStart()
    local blocked, reason = false, nil
    pcall(function()
        if SpeedSystem and SpeedSystem.isActionBlocked then
            blocked, reason = SpeedSystem:isActionBlocked("aimbot")
        end
    end)
    if blocked then
        BatAimbot.enabled = false
        pcall(function() if notify then notify("Blocked · " .. tostring(reason or "Safe Mode"), 1.6) end end)
        return
    end
    _batStop()

    local ver = BatAimbot.version
    if ver ~= "V2" and ver ~= "V3" then ver = "V2" end
    BatAimbot.version = ver
    if ver == "V3" then
        BatAimbot.bypassEnabled = true
        _batStartV3()
    else
        BatAimbot.bypassEnabled = false
        _batStartV2()
    end
end

LP.CharacterAdded:Connect(function()
    if BatAimbot.enabled then
        task.wait(0.4)
        _batStart()
    end
end)

local batAimbotRow, batAimbotArrow = NoxaUI.mkToggle(P_COMBAT, "Bat Aimbot  [E]", false, true)
NoxaMods._batAimbotRow = batAimbotRow

local batOptCard = NoxaUI.new("Frame", {
    Name = "BatAimbotOptions",
    Size = UDim2.new(1, -4, 0, 0),
    BackgroundColor3 = ROW_BG, BackgroundTransparency = 0.12,
    BorderSizePixel = 0, Visible = false,
    ClipsDescendants = false, Parent = P_COMBAT,
    local open = false
    if batAimbotArrow then
        batAimbotArrow.MouseButton1Click:Connect(function()
            open = not open
            batOptCard.Visible = open
            batAimbotArrow.Text = open and "▲" or "▼"
        end)
    end
end
NoxaUI.corner(batOptCard, 10); NoxaUI.darkStroke(batOptCard, 1.2)
NoxaUI.new("UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder, Parent = batOptCard,
NoxaUI.new("UIPadding", {
    PaddingTop = UDim.new(0, 9), PaddingBottom = UDim.new(0, 9),
    PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8),
    Parent = batOptCard,

    local head = NoxaUI.new("Frame", {
        Size = UDim2.new(1, -4, 0, 14),
        BackgroundTransparency = 1, Parent = batOptCard,
    NoxaUI.new("TextLabel", {
        Position = UDim2.new(0, 4, 0, 0), Size = UDim2.new(1, -8, 1, 0),
        BackgroundTransparency = 1, Text = "SUB OPTIONS",
        TextColor3 = TEXT_DIM, TextSize = 9,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = head,
end

local batModeCard = NoxaUI.new("Frame", {
    Size = UDim2.new(1, -4, 0, 56),
    BackgroundColor3 = INPUT_BG or Color3.fromRGB(22,26,32),
    BackgroundTransparency = 0.25, BorderSizePixel = 0, Parent = batOptCard,
NoxaUI.corner(batModeCard, 10)
NoxaUI.darkStroke(batModeCard, 1)
NoxaUI.new("TextLabel", {
    Position = UDim2.new(0, 12, 0, 6), Size = UDim2.new(1, -24, 0, 14),
    BackgroundTransparency = 1, Text = "Aimbot Mode",
    TextColor3 = TEXT_MAIN or Color3.fromRGB(230,230,235),
    TextSize = 12, Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left, Parent = batModeCard,
batModeTrack = NoxaUI.new("Frame", {
    Position = UDim2.new(0, 10, 0, 26),
    Size = UDim2.new(1, -20, 0, 24),
    BackgroundColor3 = Color3.fromRGB(18,20,26),
    BackgroundTransparency = 0.15, BorderSizePixel = 0, Parent = batModeCard,
NoxaUI.corner(batModeTrack, 999)
batModeSlider = NoxaUI.new("Frame", {
    Name = "BatModeSlider", ZIndex = 6,
    Size = UDim2.new(1/3, -4, 1, -4),
    Position = UDim2.new(0, 2, 0, 2),
    BackgroundColor3 = ACCENT or Color3.fromRGB(70, 170, 255),
    BorderSizePixel = 0, Parent = batModeTrack,
NoxaUI.corner(batModeSlider, 999)
NoxaUI.regAccent(batModeSlider)
batModeBtns = {}
local function setBatModeUI(ver)
    ver = (ver == "V3") and "V3" or "V2"
    local idx = (ver == "V2") and 0 or 1
    TweenService:Create(batModeSlider, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
        Position = UDim2.new(idx / 2, 2, 0, 2)
    }):Play()
    for name, btn in pairs(batModeBtns) do
        btn.TextColor3 = (name == ver)
            and Color3.fromRGB(255,255,255)
            or (TEXT_DIM or Color3.fromRGB(140,150,160))
    end
end
batModeSlider.Size = UDim2.new(1/2, -4, 1, -4)
for i, name in ipairs({"V2", "V3"}) do
    local btn = NoxaUI.new("TextButton", {
        ZIndex = 7,
        Position = UDim2.new((i - 1) / 2, 0, 0, 0),
        Size = UDim2.new(1/2, 0, 1, 0),
        BackgroundTransparency = 1, Text = name,
        TextColor3 = TEXT_DIM or Color3.fromRGB(140,150,160),
        TextSize = 11, Font = Enum.Font.GothamBold,
        AutoButtonColor = false, Parent = batModeTrack,
    batModeBtns[name] = btn
    btn.MouseButton1Click:Connect(function()
        BatAimbot.version = name
        if name == "V3" then BatAimbot.bypassEnabled = true
        else BatAimbot.bypassEnabled = false end
        setBatModeUI(name)
        if BatAimbot.enabled then _batStart() end
        pcall(function() NoxaCfg.dirty = true; NoxaCfg.saveConfig(true) end)
    end)
end
setBatModeUI(BatAimbot.version or "V2")
_G.NoxaSetBatModeUI = setBatModeUI

local autoSwingRow = NoxaUI.mkToggle(batOptCard, "Auto Swing", SpeedSystem.antiDesyncAutoSwingEnabled == true)
if autoSwingRow then
    ToggleStates.__on(autoSwingRow, function(state)
        SpeedSystem.antiDesyncAutoSwingEnabled = state == true
        NoxaCfg.saveConfig()
    end)
end

approachRow = NoxaUI.mkRow(batOptCard, 36)
NoxaUI.mkLabel(approachRow, "Approach Speed")
local aimSpeedBox = NoxaUI.new("TextBox", {
    ZIndex = 6, Position = UDim2.new(1, -72, 0.5, -12),
    Size = UDim2.new(0, 58, 0, 24),
    BackgroundColor3 = INPUT_BG or Color3.fromRGB(22,26,32),
    BackgroundTransparency = 0.12, BorderSizePixel = 0,
    Text = tostring(BatAimbot.speed or 58),
    TextColor3 = ACCENT or Color3.fromRGB(70, 170, 255),
    TextSize = 12, Font = Enum.Font.GothamBold,
    ClearTextOnFocus = false, Parent = approachRow,
NoxaUI.corner(aimSpeedBox, 8)
NoxaUI.darkStroke(aimSpeedBox, 1)
NoxaUI.regAccent(aimSpeedBox, "TextColor3")
aimSpeedBox.FocusLost:Connect(function()
    local raw = tostring(aimSpeedBox.Text or ""):gsub("[^%d%.]", "")
    local n = tonumber(raw)
        BatAimbot.speed = math.clamp(n, 10, 120)
        BatAimbot.laggerSpeed = BatAimbot.speed
        aimSpeedBox.Text = tostring(BatAimbot.speed)
        NoxaCfg.saveConfig(true)
    else
        aimSpeedBox.Text = tostring(BatAimbot.speed or 58)
    end
end)

_G.NoxaBatAimbotUI = {
    speedBox = aimSpeedBox,
    autoSwingRow = autoSwingRow,

    local BAT_OPT_H = 9 + 14 + 6 + 56 + 6 + 34 + 6 + 36 + 9
    batOptCard.Size = UDim2.new(1, -4, 0, BAT_OPT_H)
end

ToggleStates.__on(batAimbotRow, function(state)
    BatAimbot.enabled = state == true
    if BatAimbot.enabled then
        _batStart()
    else
        _batStop()
    end
    NoxaCfg.saveConfig()
end)

UserInputService.InputBegan:Connect(function(inp, gp)
    if _G.NoxaKeyListening then return end
    if NoxaCfg.shouldBlockInput(inp, gp) then return end
    if not noxaIsBindableKey(inp) then return end
    if not SpeedSystem.keybinds or not SpeedSystem.keybinds.BatAimbot then return end
    if inp.KeyCode ~= SpeedSystem.keybinds.BatAimbot then return end
    BatAimbot.enabled = not BatAimbot.enabled
    if batAimbotRow then
        ToggleStates[batAimbotRow] = BatAimbot.enabled
        local area = batAimbotRow:FindFirstChild("ToggleArea")
        local track = area and area:FindFirstChildWhichIsA("Frame")
        local knob  = track and track:FindFirstChildWhichIsA("Frame")
        if track and knob then NoxaUI.setToggleVisual(track, knob, BatAimbot.enabled) end
    end
    if BatAimbot.enabled then _batStart() else _batStop() end
end)

    NoxaMods._batAimbotStart = _batStart
    NoxaMods._batAimbotStop  = _batStop
    NoxaMods.BatAimbotRef    = BatAimbot
    _G.NoxaBatAimbot         = BatAimbot
    _G._batStart = _batStart
    _G._batStop  = _batStop
end

task.wait()
NoxaUI.mkSection(P_COMBAT, "TP BAT")
local antiDesyncRow = NoxaUI.mkToggle(P_COMBAT,"TP Bat  [V]",SpeedSystem.antiDesyncAimbotEnabled,false)
NoxaMods._tpBatRow = antiDesyncRow

local tpBatModeCard = NoxaUI.new("Frame", {
    Size = UDim2.new(1, -4, 0, 56),
    BackgroundColor3 = ROW_BG, BackgroundTransparency = 0.12,
    BorderSizePixel = 0, Parent = P_COMBAT,
NoxaUI.corner(tpBatModeCard, 10); NoxaUI.darkStroke(tpBatModeCard, 1)
NoxaUI.new("TextLabel", {
    Position = UDim2.new(0, 12, 0, 6), Size = UDim2.new(1, -24, 0, 14),
    BackgroundTransparency = 1, Text = "TP Bat Mode",
    TextColor3 = TEXT_MAIN or Color3.fromRGB(230,230,235),
    TextSize = 12, Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left, Parent = tpBatModeCard,
local tpTrack = NoxaUI.new("Frame", {
    Position = UDim2.new(0, 10, 0, 26),
    Size = UDim2.new(1, -20, 0, 24),
    BackgroundColor3 = Color3.fromRGB(18,20,26),
    BackgroundTransparency = 0.15, BorderSizePixel = 0, Parent = tpBatModeCard,
NoxaUI.corner(tpTrack, 999)
tpSlider = NoxaUI.new("Frame", {
    Name = "TPBatModeSlider", ZIndex = 6,
    Size = UDim2.new(0.5, -4, 1, -4),
    Position = (SpeedSystem.tpBatVersion == "V2") and UDim2.new(0.5, 2, 0, 2) or UDim2.new(0, 2, 0, 2),
    BackgroundColor3 = ACCENT or Color3.fromRGB(70, 170, 255),
    BorderSizePixel = 0, Parent = tpTrack,
NoxaUI.corner(tpSlider, 999)
NoxaUI.regAccent(tpSlider)
tpV1Btn = NoxaUI.new("TextButton", {
    ZIndex = 7, Size = UDim2.new(0.5, 0, 1, 0),
    BackgroundTransparency = 1, Text = "V1",
    TextColor3 = (SpeedSystem.tpBatVersion ~= "V2") and Color3.fromRGB(255,255,255) or (TEXT_DIM or Color3.fromRGB(140,150,160)),
    TextSize = 11, Font = Enum.Font.GothamBold,
    AutoButtonColor = false, Parent = tpTrack,
tpV2Btn = NoxaUI.new("TextButton", {
    ZIndex = 7, Position = UDim2.new(0.5, 0, 0, 0), Size = UDim2.new(0.5, 0, 1, 0),
    BackgroundTransparency = 1, Text = "V2",
    TextColor3 = (SpeedSystem.tpBatVersion == "V2") and Color3.fromRGB(255,255,255) or (TEXT_DIM or Color3.fromRGB(140,150,160)),
    TextSize = 11, Font = Enum.Font.GothamBold,
    AutoButtonColor = false, Parent = tpTrack,
local function setTPBatModeUI(ver)
    local isV2 = (ver == "V2")
    TweenService:Create(tpSlider, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
        Position = isV2 and UDim2.new(0.5, 2, 0, 2) or UDim2.new(0, 2, 0, 2)
    }):Play()
    tpV1Btn.TextColor3 = (not isV2) and Color3.fromRGB(255,255,255) or (TEXT_DIM or Color3.fromRGB(140,150,160))
    tpV2Btn.TextColor3 = isV2 and Color3.fromRGB(255,255,255) or (TEXT_DIM or Color3.fromRGB(140,150,160))
end
local function applyTPBatVersion(ver)
    SpeedSystem.tpBatVersion = (ver == "V2") and "V2" or "V1"
    setTPBatModeUI(SpeedSystem.tpBatVersion)
    if SpeedSystem.antiDesyncAimbotEnabled then
        SpeedSystem:startAntiDesyncAimbot()
    end
    pcall(function() NoxaCfg.dirty = true; NoxaCfg.saveConfig(true) end)
    pcall(function() if notify then notify("TP Bat · " .. SpeedSystem.tpBatVersion, 1.2) end end)
end
tpV1Btn.MouseButton1Click:Connect(function() applyTPBatVersion("V1") end)
tpV2Btn.MouseButton1Click:Connect(function() applyTPBatVersion("V2") end)
_G.NoxaSetTPBatModeUI = setTPBatModeUI

if antiDesyncRow then
    local toggleClick = antiDesyncRow:FindFirstChild("ToggleArea") and antiDesyncRow:FindFirstChild("ToggleArea"):FindFirstChild("ToggleClick")
    if toggleClick then
        toggleClick.MouseButton1Click:Connect(function()
            SpeedSystem.antiDesyncAimbotEnabled = not SpeedSystem.antiDesyncAimbotEnabled
            if SpeedSystem.antiDesyncAimbotEnabled then
                SpeedSystem:startAntiDesyncAimbot()
            else
                SpeedSystem:stopAntiDesyncAimbot()
            end
            NoxaCfg.saveConfig()
        end)
    end
end

_G.NoxaSafeModeBlockedTools = {
    bat=true,slap=true,sword=true,gun=true,pistol=true,rifle=true,
    medusa=true,hammer=true,axe=true,knife=true,katana=true,blade=true,fist=true,
function _G.NoxaSafeModeGetCountdownLabel()
    local ok, label = pcall(function()
        return LP.PlayerGui
            and LP.PlayerGui:FindFirstChild("DuelsMachineTopFrame")
            and LP.PlayerGui.DuelsMachineTopFrame:FindFirstChild("DuelsMachineTopFrame")
            and LP.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame:FindFirstChild("Timer")
            and LP.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame.Timer:FindFirstChild("Label")
    end)
    return (ok and label) or nil
end
function _G.NoxaSafeModeCountdownNumber(text)
    local t = tostring(text or ""):upper():gsub("^%s+",""):gsub("%s+$","")
    if t=="GO" or t=="START" or t=="READY" then return true end
    local n = tonumber(t)
    return n ~= nil and n >= 0 and n <= 10
end
function _G.NoxaSafeModeInDuelCountdown()
    local label = _G.NoxaSafeModeGetCountdownLabel()
    return label and _G.NoxaSafeModeCountdownNumber(label.Text) or false
end
function _G.NoxaSafeModeHoldingBrainrot()
    local okA, vA = pcall(function() return LP:GetAttribute("Stealing") end)
    if okA and vA == true then return true end
    local char = LP.Character; if not char then return false end
    local okC, vC = pcall(function() return char:GetAttribute("Stealing") end)
    if okC and vC == true then return true end
    if SpeedSystem and SpeedSystem.isCarryingBrainrot and SpeedSystem:isCarryingBrainrot(char) then return true end
    return false
end
function _G.NoxaSafeModeIsLocked()
    if not (SpeedSystem and SpeedSystem.safeModeEnabled) then return false end
    if _G.NoxaSafeModeInDuelCountdown and _G.NoxaSafeModeInDuelCountdown() then return true end
    if _G.NoxaSafeModeHoldingBrainrot and _G.NoxaSafeModeHoldingBrainrot() then return true end
    return false
end
function _G.NoxaSafeModeForceStop(reason)
    local stopped = false

    if SpeedSystem and SpeedSystem.antiDesyncAimbotEnabled then
        SpeedSystem.antiDesyncAimbotEnabled = false
        pcall(function() SpeedSystem:stopAntiDesyncAimbot() end)
        stopped = true
        pcall(function()
            if SpeedSystem.onUIUpdate then SpeedSystem:onUIUpdate() end
        end)
    end

    if BatAimbot and BatAimbot.enabled then
        BatAimbot.enabled = false
        pcall(function()
            if type(_batStop) == "function" then _batStop()
            elseif NoxaMods and NoxaMods._batAimbotStop then NoxaMods._batAimbotStop() end
        end)
        pcall(function()
            local row = (NoxaMods and NoxaMods._batAimbotRow)
            if row and ToggleStates then
                ToggleStates[row] = false
                local area = row:FindFirstChild("ToggleArea")
                local track = area and area:FindFirstChildWhichIsA("Frame")
                local knob = track and track:FindFirstChildWhichIsA("Frame")
                if track and knob and NoxaUI.setToggleVisual then
                    NoxaUI.setToggleVisual(track, knob, false)
                end
            end
        end)
        stopped = true
    end

    if SpeedSystem and SpeedSystem.AutoPath then
        if SpeedSystem.AutoPath.leftEnabled or SpeedSystem.AutoPath.rightEnabled then
            pcall(function()
                if SpeedSystem.AutoPath.set then
                    SpeedSystem.AutoPath.set("left", false)
                    SpeedSystem.AutoPath.set("right", false)
                else
                    SpeedSystem.AutoPath.leftEnabled = false
                    SpeedSystem.AutoPath.rightEnabled = false
                end
            end)
            stopped = true
        end
    end
    if stopped and type(notify) == "function" then
        pcall(notify, reason or "SAFE MODE LOCK", 1.5)
    end
end
if not _G.NoxaSafeModeMonitorStarted then
    _G.NoxaSafeModeMonitorStarted = true
    local _lastSafeNotify = 0
    local _safeAcc = 0
    if _G._NoxaSafeModeConn then pcall(function() _G._NoxaSafeModeConn:Disconnect() end) end
    _G._NoxaSafeModeConn = _G._NoxaTrackConn(RunService.Heartbeat:Connect(function(dt)
        _safeAcc = _safeAcc + (dt or 0.016)
        if _safeAcc < 0.1 then return end
        _safeAcc = 0
        if not (SpeedSystem and SpeedSystem.safeModeEnabled) then return end
        local locked = false
        pcall(function()
            if _G.NoxaSafeModeIsLocked then locked = _G.NoxaSafeModeIsLocked() == true end
        end)
        if not locked then
            pcall(function()
                if SpeedSystem.isHoldingBrainrot and SpeedSystem:isHoldingBrainrot() then locked = true end
            end)
        end
        if not locked then return end
        local need = (SpeedSystem.antiDesyncAimbotEnabled == true)
            or (BatAimbot and BatAimbot.enabled == true)
            or (SpeedSystem.AutoPath and (SpeedSystem.AutoPath.leftEnabled or SpeedSystem.AutoPath.rightEnabled))
        if not need then return end
        local reason = "SAFE MODE LOCK"
        if tick() - _lastSafeNotify > 2.5 then
            _lastSafeNotify = tick()
            _G.NoxaSafeModeForceStop(reason)
        else

            notify = nil
            pcall(function() _G.NoxaSafeModeForceStop(nil) end)
            notify = n
        end
    end))
end

local AntiDie = {
    enabled = false,
    _conn = nil,
    _healthConn = nil,
    _charConn = nil,
    invincibleUntil = 0,
    config = {
        healthThreshold = 50,
        invincibilityFrames = 0.75,
        ragdollProtection = true,
        autoRevive = true,

local function _adSuperHeal(hum)
    if not hum or not hum.Parent then return end
    local maxHealth = hum.MaxHealth or 100
    if maxHealth <= 0 then maxHealth = 100 end
    pcall(function()
        hum.Health = maxHealth
        if hum.MaxHealth < maxHealth then hum.MaxHealth = maxHealth end
    end)
    AntiDie.invincibleUntil = tick() + (AntiDie.config.invincibilityFrames or 0.75)
    pcall(function()
        local char = hum.Parent
        if not char then return end
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("NumberValue") then
                local name = child.Name:lower()
                if name:find("health") or name:find("hp") or name:find("life") then
                    child.Value = maxHealth
                end
            end
            if child:IsA("BoolValue") and child.Name:lower():find("dead") then
                child.Value = false
            end
        end
    end)
end

local function _adPreventDamage(root, hum)
    if not hum then return end
    if hum.Health < (hum.MaxHealth or 100) then
        _adSuperHeal(hum)
    end
    if tick() < (AntiDie.invincibleUntil or 0) then
        if hum.Health < (hum.MaxHealth or 100) then
            hum.Health = hum.MaxHealth or 100
        end
    end
    if AntiDie.config.ragdollProtection then
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
            or state == Enum.HumanoidStateType.Dead then
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
            _adSuperHeal(hum)
            if root then
                pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
            end
        end
    end
end

local function stopAntiDie()
    AntiDie.enabled = false
    SpeedSystem.antiDieEnabled = false
    if AntiDie._conn then AntiDie._conn:Disconnect(); AntiDie._conn = nil end
    if AntiDie._healthConn then AntiDie._healthConn:Disconnect(); AntiDie._healthConn = nil end
end

local function startAntiDie()
    AntiDie.enabled = true
    SpeedSystem.antiDieEnabled = true
    if AntiDie._conn then AntiDie._conn:Disconnect() end
    AntiDie._conn = RunService.Heartbeat:Connect(function()
        if not AntiDie.enabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum then return end
        pcall(function()
            hum.BreakJointsOnDeath = false
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        end)
        if hum.Health <= 0 or hum.Health <= (AntiDie.config.healthThreshold or 50) then
            _adSuperHeal(hum)
        end
        _adPreventDamage(root, hum)
    end)
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if AntiDie._healthConn then AntiDie._healthConn:Disconnect() end
            AntiDie._healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
                if not AntiDie.enabled then return end
                if hum.Health <= (AntiDie.config.healthThreshold or 50) then
                    _adSuperHeal(hum)
                end
            end)
        end
    end
end

function AntiDie:enable()
    startAntiDie()
    self.enabled = true
end
function AntiDie:disable()
    stopAntiDie()
    self.enabled = false
end

local AntiFlingShield = {
    enabled = false,
    loop = nil,
    velocityThreshold = 80,

local function _afsStabilizeRoot(root)
    if not root or not root.Parent then return end
    local velocity
    local ok = pcall(function() velocity = root.AssemblyLinearVelocity end)
    if not ok or typeof(velocity) ~= "Vector3" then return end
    if velocity.Magnitude <= AntiFlingShield.velocityThreshold then return end
    local stabilized = Vector3.new(0, velocity.Y, 0)
    pcall(function() root.AssemblyLinearVelocity = stabilized end)
    pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
end

local function startAntiFlingShield()
    AntiFlingShield.enabled = true
    SpeedSystem.antiFlingShieldEnabled = true
    if AntiFlingShield.loop then AntiFlingShield.loop:Disconnect() end
    AntiFlingShield.loop = RunService.Heartbeat:Connect(function()
        if not AntiFlingShield.enabled then return end
        local char = LP.Character
        _afsStabilizeRoot(char and char:FindFirstChild("HumanoidRootPart"))
    end)
end

local function stopAntiFlingShield()
    AntiFlingShield.enabled = false
    SpeedSystem.antiFlingShieldEnabled = false
    if AntiFlingShield.loop then
        AntiFlingShield.loop:Disconnect()
        AntiFlingShield.loop = nil
    end
end

_G.NoxaAntiFlingShield = {
    enable = function() startAntiFlingShield() end,
    disable = function() stopAntiFlingShield() end,

local BodyLock = {
    enabled = false,
    maxDistance = 150,
    _conn = nil,
    _target = nil,

local function bodyLockGetClosestEnemy()
    local char = LP.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local best, bestDist = nil, BodyLock.maxDistance
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            local c = plr.Character
                local th = c:FindFirstChild("HumanoidRootPart")
                local hum = c:FindFirstChildOfClass("Humanoid")
                if th and hum and hum.Health > 0 then
                    local d = (th.Position - hrp.Position).Magnitude
                    if d < bestDist then
                        bestDist = d
                        best = th
                    end
                end
            end
        end
    end
    return best
end

local function bodyLockStart()
    if BodyLock._conn then return end
    BodyLock._conn = RunService.Heartbeat:Connect(function()
        if not BodyLock.enabled then return end
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local target = bodyLockGetClosestEnemy()
        BodyLock._target = target
        if not target then return end
        local pos = hrp.Position
        local lookAt = Vector3.new(target.Position.X, pos.Y, target.Position.Z)
        if (lookAt - pos).Magnitude < 0.08 then return end

        hrp.CFrame = CFrame.lookAt(pos, lookAt)
    end)
end

local function bodyLockStop()
    if BodyLock._conn then
        BodyLock._conn:Disconnect()
        BodyLock._conn = nil
    end
    BodyLock._target = nil
end

function BodyLock:enable()

    self.enabled = false
    SpeedSystem.bodyLockEnabled = false
    bodyLockStop()
end

function BodyLock:disable()
    self.enabled = false
    SpeedSystem.bodyLockEnabled = false
    bodyLockStop()
end

function BodyLock:toggle()
    if self.enabled then
        self:disable()
    else
        self:enable()
    end
    return self.enabled
end

_G.NoxaAntiDie = AntiDie
_G.NoxaBodyLock = BodyLock

task.wait()
NoxaUI.mkSection(P_COMBAT, "PROTECTION")
antiDieRow = NoxaUI.mkToggle(P_COMBAT, "Anti Die",
    SpeedSystem.antiDieEnabled == true or AntiDie.enabled == true)

antiFlingRow = NoxaUI.mkToggle(P_COMBAT, "Anti-Fling Shield",
    SpeedSystem.antiFlingShieldEnabled == true)
if antiFlingRow then
    ToggleStates.__on(antiFlingRow, function(state)
        if state then startAntiFlingShield() else stopAntiFlingShield() end
        SpeedSystem.antiFlingShieldEnabled = state == true
        pcall(function() NoxaCfg.saveConfig(true) end)
    end)
end
_G.NoxaAntiFlingRow = antiFlingRow

bodyLockRow = nil
if antiDieRow then
    ToggleStates.__on(antiDieRow, function(state)
        if state then AntiDie:enable() else AntiDie:disable() end
        SpeedSystem.antiDieEnabled = state == true
        pcall(function() NoxaCfg.saveConfig(true) end)
    end)
end
_G.NoxaAntiDieRow = antiDieRow
_G.NoxaBodyLockRow = nil

NoxaUI.mkSection(P_COMBAT,"COUNTERS")

batCounterRow = NoxaUI.mkToggle(P_COMBAT, "Bat Counter", false, false)
    ToggleStates.__on(batCounterRow, function(state)
        NoxaMods:setBatCounter(state == true)
        NoxaCfg.saveConfig()
    end)

    local bcCard = NoxaUI.new("Frame", {
        Size = UDim2.new(1, -4, 0, 56),
        BackgroundColor3 = ROW_BG, BackgroundTransparency = 0.12,
        BorderSizePixel = 0, Parent = P_COMBAT,
    NoxaUI.corner(bcCard, 10); NoxaUI.darkStroke(bcCard, 1)
    NoxaUI.new("TextLabel", {
        Position = UDim2.new(0, 12, 0, 6), Size = UDim2.new(1, -24, 0, 14),
        BackgroundTransparency = 1, Text = "Counter Mode",
        TextColor3 = TEXT_MAIN or Color3.fromRGB(230,230,235),
        TextSize = 12, Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = bcCard,
    local bcTrack = NoxaUI.new("Frame", {
        Position = UDim2.new(0, 10, 0, 26),
        Size = UDim2.new(1, -20, 0, 24),
        BackgroundColor3 = Color3.fromRGB(18,20,26),
        BackgroundTransparency = 0.15, BorderSizePixel = 0, Parent = bcCard,
    NoxaUI.corner(bcTrack, 999)
    local curMode = NoxaMods.batCounterMode or "V1"
    local bcIdx = (curMode == "V2" and 1) or (curMode == "V3" and 2) or 0
    local bcSlider = NoxaUI.new("Frame", {
        Name = "BCModeSlider", ZIndex = 6,
        Size = UDim2.new(1/3, -4, 1, -4),
        Position = UDim2.new(bcIdx / 3, 2, 0, 2),
        BackgroundColor3 = ACCENT or Color3.fromRGB(70, 170, 255),
        BorderSizePixel = 0, Parent = bcTrack,
    NoxaUI.corner(bcSlider, 999)
    NoxaUI.regAccent(bcSlider)
    local bcBtns = {}
    local function setBCModeUI(ver)
        ver = (ver == "V2" or ver == "V3") and ver or "V1"
        local idx = (ver == "V1" and 0) or (ver == "V2" and 1) or 2
        TweenService:Create(bcSlider, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
            Position = UDim2.new(idx / 3, 2, 0, 2)
        }):Play()
        for name, btn in pairs(bcBtns) do
            btn.TextColor3 = (name == ver)
                and Color3.fromRGB(255,255,255)
                or (TEXT_DIM or Color3.fromRGB(140,150,160))
        end
    end
    for i, name in ipairs({"V1", "V2", "V3"}) do
        local btn = NoxaUI.new("TextButton", {
            ZIndex = 7,
            Position = UDim2.new((i - 1) / 3, 0, 0, 0),
            Size = UDim2.new(1/3, 0, 1, 0),
            BackgroundTransparency = 1, Text = name,
            TextColor3 = TEXT_DIM or Color3.fromRGB(140,150,160),
            TextSize = 11, Font = Enum.Font.GothamBold,
            AutoButtonColor = false, Parent = bcTrack,
        bcBtns[name] = btn
        btn.MouseButton1Click:Connect(function()
            NoxaMods:setBatCounterMode(name)
            setBCModeUI(name)
            pcall(function() NoxaCfg.dirty = true; NoxaCfg.saveConfig(true) end)
        end)
    end
    setBCModeUI(curMode)
    _G.NoxaSetBatCounterModeUI = setBCModeUI
    _G.NoxaBatCounterModeRows = nil
end

medusaCounterRow, _ = NoxaUI.mkToggle(P_COMBAT,"Medusa Counter",  false)
if medusaCounterRow then
    local tc = medusaCounterRow:FindFirstChild("ToggleArea"):FindFirstChild("ToggleClick")
    if tc then
        tc.MouseButton1Click:Connect(function()
            NoxaMods:setMedusaCounter(not NoxaMods.medusaCounterEnabled)
            NoxaCfg.saveConfig()
        end)
    end
end

task.wait()

NoxaUI.mkSection(P_UTILITY, "PERFORMANCE")
local antiLagRow, _ = NoxaUI.mkToggle(P_UTILITY, "Anti-Lag", NoxaMods.antiLagEnabled == true, false)
if antiLagRow then
    ToggleStates.__on(antiLagRow, function(state)
        NoxaMods:setAntiLag(state == true)
        pcall(function() NoxaCfg.saveConfig(true) end)
    end)
end
local nukeOptRow, _ = NoxaUI.mkToggle(P_UTILITY, "Nuke Optimizer", NoxaMods.nukeEnabled == true, false)
if nukeOptRow then
    ToggleStates.__on(nukeOptRow, function(state)
        NoxaMods:setNukeOptimizer(state == true)
        pcall(function() NoxaCfg.saveConfig(true) end)
    end)
end

task.wait()
NoxaUI.mkSection(P_CUSTOM, "ANIMATION")
    local animPackList = {"OFF"}
    for name in pairs(PACKS) do table.insert(animPackList, name) end
    table.sort(animPackList, function(a, b)
        if a == "OFF" then return true end
        if b == "OFF" then return false end
        return a:lower() < b:lower()
    end)

    local currentName = SpeedSystem.animPack or "Tryard"
    if currentName ~= "OFF" and not PACKS[currentName] then currentName = "Tryard" end
    local animIdx = 1
    for i, n in ipairs(animPackList) do
        if n == currentName then animIdx = i break end
    end

    local function selectPack(name)
        SpeedSystem.animPack = name
        if name == "OFF" then
            pcall(function() LP:SetAttribute("AnimPack_Last", "") end)
        else
            pcall(function()
                AnimPack.applyPack(name)
                LP:SetAttribute("AnimPack_Last", name)
            end)
        end
        pcall(function()
            if notify then notify("Anim · " .. tostring(name), 1.2) end
        end)
    end

    NoxaUI.mkPicker(P_CUSTOM, "Animation Pack", animPackList, animIdx, function(v)
        selectPack(v)
    end)
end

task.wait()
NoxaUI.mkSection(P_UTILITY, "CHARACTER")
    local headlessRow = NoxaUI.mkToggle(P_UTILITY, "Headless",
        (SpeedSystem.NoxaChar and SpeedSystem.NoxaChar.headlessEnabled) == true, false)
    local korbloxRow = NoxaUI.mkToggle(P_UTILITY, "Korblox",
        (SpeedSystem.NoxaChar and SpeedSystem.NoxaChar.korbloxEnabled) == true, false)
    _G.NoxaHeadlessRow = headlessRow
    _G.NoxaKorbloxRow = korbloxRow
    ToggleStates.__on(headlessRow, function(state)
        if SpeedSystem.NoxaChar then
            SpeedSystem.NoxaChar.headlessEnabled = state == true
            pcall(function()
                if SpeedSystem.NoxaChar.applyHeadless then
                    SpeedSystem.NoxaChar.applyHeadless(LP.Character, state == true)
                end
            end)
        end
        pcall(NoxaCfg.saveConfig)
    end)
    ToggleStates.__on(korbloxRow, function(state)
        if SpeedSystem.NoxaChar then
            SpeedSystem.NoxaChar.korbloxEnabled = state == true
            pcall(function()
                if SpeedSystem.NoxaChar.applyKorblox then
                    SpeedSystem.NoxaChar.applyKorblox(LP.Character, state == true)
                end
            end)
        end
        pcall(NoxaCfg.saveConfig)
    end)
end

    local BLEED_PACKS = {
        ["Bleed 1"] = {
            accessory = 306969564,
            headMesh = "http://www.roblox.com/asset/?id=134079402",
            headTexture = "http://www.roblox.com/asset/?id=133940918",
            shirt = "http://www.roblox.com/asset/?id=10632503795",
            pants = "http://www.roblox.com/asset/?id=123161592384863",
            korblox = "right",
        ["Bleed 2"] = {
            accessory = 1744060292,
            headMesh = "http://www.roblox.com/asset/?id=134079402",
            headTexture = "http://www.roblox.com/asset/?id=133940918",
            shirt = "http://www.roblox.com/asset/?id=11526718530",
            pants = "http://www.roblox.com/asset/?id=93710523210027",
            korblox = "right",
        ["Bleed 3"] = {
            accessory = 112564966849233,
            headMesh = "http://www.roblox.com/asset/?id=134079402",
            headTexture = "http://www.roblox.com/asset/?id=133940918",
            shirt = "http://www.roblox.com/asset/?id=11849088376",
            pants = "http://www.roblox.com/asset/?id=16534673928",
            korblox = "right",
    local PACK_ORDER = {"Off", "Bleed 1", "Bleed 2", "Bleed 3"}
    SpeedSystem.skinPack = SpeedSystem.skinPack or "Off"
    if SpeedSystem.skinPack == "Bart Skin" then SpeedSystem.skinPack = "Bleed 1" end
    local _origOutfit = { shirt = nil, pants = nil }
    local _origAcc = {}

    local function clearOutfit(char)
        if not char then return end
        for _, obj in ipairs(char:GetChildren()) do
            if obj:IsA("Shirt") or obj:IsA("Pants") then pcall(function() obj:Destroy() end) end
        end
    end
    local function clearAcc(char)
        if not char then return end
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Accessory") or child:IsA("Hat") or child.Name == "AuFfitAccessory" or child.Name == "NoxaSkinAcc" then
                pcall(function() child:Destroy() end)
            end
        end
    end
    local function saveOrig(char)
        if not char then return end
        if not _origOutfit.shirt and not _origOutfit.pants then
            local s = char:FindFirstChildWhichIsA("Shirt")
            local p = char:FindFirstChildWhichIsA("Pants")
        end
        if #_origAcc == 0 then
            for _, child in ipairs(char:GetChildren()) do
                if child:IsA("Accessory") or child:IsA("Hat") then
                    table.insert(_origAcc, child:Clone())
                end
            end
        end
    end
    local function restoreOrig(char)
        if not char then return end
        clearOutfit(char)
        clearAcc(char)
        if _origOutfit.shirt then
            local s = Instance.new("Shirt"); s.ShirtTemplate = _origOutfit.shirt; s.Parent = char
        end
        if _origOutfit.pants then
            local p = Instance.new("Pants"); p.PantsTemplate = _origOutfit.pants; p.Parent = char
        end
        for _, clone in ipairs(_origAcc) do
            pcall(function() clone:Clone().Parent = char end)
        end
    end

    local function applyBleed(packName)
        local config = BLEED_PACKS[packName]
        if not config then return false end
        local char = LP.Character
        if not char then return false end
        local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 5)
        if not head then return false end

        if config.bodyColor then
            pcall(function()
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    local desc = hum:GetAppliedDescription()
                    if config.headId then desc.Head = config.headId end
                    desc.HeadColor = config.bodyColor
                    desc.LeftArmColor = config.bodyColor
                    desc.RightArmColor = config.bodyColor
                    desc.LeftLegColor = config.bodyColor
                    desc.RightLegColor = config.bodyColor
                    desc.TorsoColor = config.bodyColor
                    hum:ApplyDescription(desc)
                end
            end)
            for _, part in ipairs(char:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    pcall(function() part.Color = config.bodyColor end)
                end
            end
        end

        if config.headMesh then
            for _, d in ipairs(char:GetChildren()) do
                if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
                    pcall(function() d:Destroy() end)
                end
            end
            local done = false
            if head:IsA("MeshPart") then
                done = pcall(function()
                    head.MeshId = config.headMesh
                    if config.headTexture then head.TextureID = config.headTexture end
                end)
            end
            if not done then
                local sm = head:FindFirstChildWhichIsA("SpecialMesh") or Instance.new("SpecialMesh")
                sm.Parent = head
                sm.MeshType = Enum.MeshType.FileMesh
                sm.MeshId = config.headMesh
                sm.TextureId = config.headTexture or ""
            end
        end
        if config.shirt then
            local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
            s.Name = "Shirt"; s.ShirtTemplate = config.shirt; s.Parent = char
        end
        if config.pants then
            local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
            p.Name = "Pants"; p.PantsTemplate = config.pants; p.Parent = char
        end
        if config.accessory and head then
            local old = char:FindFirstChild("NoxaSkinAcc") or char:FindFirstChild("AuFfitAccessory")
            if old then old:Destroy() end
            local objs
            local ok, res = pcall(function()
                return game:GetObjects("rbxassetid://" .. tostring(config.accessory))
            end)
            if ok and type(res) == "table" and #res > 0 then objs = res
            else
                ok, res = pcall(function()
                    return game:GetService("InsertService"):LoadAsset(config.accessory)
                end)
                if ok and res then objs = {res} end
            end
            if objs then
                local handle
                for _, o in ipairs(objs) do
                    if o:IsA("BasePart") then handle = o; break end
                    local f = o:FindFirstChildWhichIsA("BasePart", true)
                    if f then handle = f; break end
                end
                if handle then
                    local h = handle:Clone()
                    h.Name = "NoxaSkinAcc"
                    h.CanCollide = false
                    h.Massless = true
                    h.CFrame = head.CFrame
                    local w = Instance.new("WeldConstraint")
                    w.Part0 = head
                    w.Part1 = h
                    w.Parent = h
                    h.Parent = char
                end
                for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
            end
        end
        if config.korblox == "right" or config.korblox == "left" then
            local side = config.korblox
            local ids = { left = 139607673, right = 139607718 }
            local targets = { left = "LeftUpperLeg", right = "RightUpperLeg" }
            local hides = {
                left = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot"},
                right = {"RightUpperLeg", "RightLowerLeg", "RightFoot"},
            local targetPart = char:FindFirstChild(targets[side])
            if targetPart then
                for _, partName in ipairs(hides[side]) do
                    local limb = char:FindFirstChild(partName)
                    if limb and limb:IsA("BasePart") then limb.Transparency = 1 end
                end
                local ok2, objects = pcall(function()
                    return game:GetObjects("rbxassetid://" .. ids[side])
                end)
                if ok2 and objects and #objects > 0 then
                    local assetModel = objects[1]
                    local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
                    if mainMesh then
                        mainMesh.CanCollide = false
                        mainMesh.Massless = true
                        mainMesh.CFrame = targetPart.CFrame
                        local weld = Instance.new("WeldConstraint")
                        weld.Part0 = targetPart
                        weld.Part1 = mainMesh
                        weld.Parent = mainMesh
                        assetModel.Parent = char
                    end
                end
            end
        end
        return true
    end

    local function applySkinPack(packName)
        packName = packName or "Off"
        SpeedSystem.skinPack = packName
        local char = LP.Character
        if not char then return false end
        pcall(function() char:WaitForChild("Head", 3) end)
        pcall(function() char:WaitForChild("Humanoid", 3) end)
        if packName == "Off" then
            restoreOrig(char)
            return true
        end
        saveOrig(char)
        clearOutfit(char)
        clearAcc(char)
        local ok = applyBleed(packName)
        return ok ~= false
    end
    _G.NoxaApplySkinPack = applySkinPack

    local function forceApplySavedSkin(reason)
        local p = SpeedSystem.skinPack
        if not p or p == "Off" or p == "" then return end
        task.spawn(function()
            for attempt = 1, 8 do
                local char = LP.Character
                if char and char:FindFirstChild("Head") and char:FindFirstChildOfClass("Humanoid") then
                    local ok = false
                    pcall(function() ok = applySkinPack(p) end)
                    if ok then return end
                end
                task.wait(0.35)
            end
        end)
    end
    _G.NoxaForceApplySavedSkin = forceApplySavedSkin

    task.defer(function()
        task.wait(0.4)
        forceApplySavedSkin("init")
    end)

    NoxaUI.mkSection(P_CUSTOM, "SKIN CHANGER")
    local skins = PACK_ORDER
    local cur = SpeedSystem.skinPack or "Off"
    local idx = 1
    for i, n in ipairs(skins) do
        if n == cur then idx = i break end
    end
    NoxaUI.mkPicker(P_CUSTOM, "Skin Pack", skins, idx, function(v)
        applySkinPack(v)
        pcall(function() if NoxaCfg then NoxaCfg.saveConfig(true) end end)
        pcall(function() if notify then notify("Skin · " .. tostring(v), 1.2) end end)
    end)

    LP.CharacterAdded:Connect(function()
        task.wait(0.6)
        local p = SpeedSystem.skinPack
        if p and p ~= "Off" then
            pcall(function() applySkinPack(p) end)
        end
    end)
end

    local SoundService = game:GetService("SoundService")
    local function accent()
        return (typeof(ACCENT) == "Color3" and ACCENT) or Color3.fromRGB(0, 204, 102)
    end
    local function soft()
        local a = accent()
        return Color3.new(math.clamp(a.R*1.2,0,1), math.clamp(a.G*1.15,0,1), math.clamp(a.B*1.1,0,1))
    end

    local PlayerESP = { enabled = false, conns = {}, playerData = {} }
    local function cleanupPlayer(plr)
        local d = PlayerESP.playerData[plr]; if not d then return end
        pcall(function() if d.highlight then d.highlight:Destroy() end end)
        pcall(function() if d.billboard then d.billboard:Destroy() end end)
        if d.conns then for _,c in ipairs(d.conns) do pcall(function() c:Disconnect() end) end end
        PlayerESP.playerData[plr] = nil
    end
    local function setupPlayer(plr, char)
        if not PlayerESP.enabled or plr == LP then return end
        cleanupPlayer(plr)
        local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5))
        local head = char and (char:FindFirstChild("Head") or char:WaitForChild("Head", 5))
        if not hrp or not head then return end
        local hl = Instance.new("Highlight")
        hl.Name = "K7ESP"; hl.Adornee = char
        hl.FillColor = Color3.fromRGB(35, 35, 35); hl.FillTransparency = 0.72
        hl.OutlineColor = accent(); hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent = char
        local bb = Instance.new("BillboardGui")
        bb.Name = "K7ESPTag"; bb.Adornee = head
        bb.Size = UDim2.new(0,150,0,104); bb.StudsOffset = Vector3.new(0,3.4,0)
        bb.AlwaysOnTop = true; bb.LightInfluence = 0; bb.Parent = head
        local box = Instance.new("Frame", bb)
        box.Size = UDim2.new(1,0,1,0); box.BackgroundTransparency = 1; box.BorderSizePixel = 0
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 12)
        local list = Instance.new("UIListLayout", box)
        list.FillDirection = Enum.FillDirection.Vertical
        list.HorizontalAlignment = Enum.HorizontalAlignment.Center
        list.VerticalAlignment = Enum.VerticalAlignment.Center
        list.Padding = UDim.new(0, 2)
        local ava = Instance.new("ImageLabel", box)
        ava.Name = "Avatar"; ava.Size = UDim2.new(0,56,0,56)
        ava.BackgroundColor3 = Color3.fromRGB(8,8,10); ava.BackgroundTransparency = 0
        ava.BorderSizePixel = 0; ava.Image = ""
        Instance.new("UICorner", ava).CornerRadius = UDim.new(1,0)
        local avStroke = Instance.new("UIStroke", ava)
        avStroke.Color = accent(); avStroke.Thickness = 2
        local n = Instance.new("TextLabel", box)
        n.Size = UDim2.new(1,-10,0,17); n.Name = "OtherPlayerSpeedLabel"
        n.BackgroundTransparency = 1; n.TextColor3 = accent()
        n.Font = Enum.Font.GothamBlack; n.TextSize = 15; n.TextStrokeTransparency = 0.38
        local sub = Instance.new("TextLabel", box)
        sub.Size = UDim2.new(1,-10,0,11); sub.Name = "OtherPlayerNameLabel"
        sub.BackgroundTransparency = 1; sub.TextColor3 = soft()
        sub.Font = Enum.Font.GothamBold; sub.TextSize = 10; sub.TextStrokeTransparency = 0.58
        task.spawn(function()
            pcall(function()
                local thumb = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
                if thumb ~= "" and ava.Parent then ava.Image = thumb end
            end)
        end)
        local conn = RunService.Heartbeat:Connect(function()
            if not PlayerESP.enabled or not hrp.Parent then return end
            local v = hrp.AssemblyLinearVelocity or hrp.Velocity
            n.Text = string.format("%d speed", math.floor(Vector3.new(v.X,0,v.Z).Magnitude + 0.5))
            sub.Text = plr.Name
            n.TextColor3 = accent()
            sub.TextColor3 = soft()
            hl.OutlineColor = accent()
            avStroke.Color = accent()
        end)
        PlayerESP.playerData[plr] = {highlight = hl, billboard = bb, conns = {conn}}
    end
    local function startPlayerESP()
        if PlayerESP.enabled then return end
        PlayerESP.enabled = true
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                if plr.Character then task.spawn(setupPlayer, plr, plr.Character) end
                table.insert(PlayerESP.conns, plr.CharacterAdded:Connect(function(c) task.defer(setupPlayer, plr, c) end))
            end
        end
        table.insert(PlayerESP.conns, Players.PlayerAdded:Connect(function(plr)
            if plr ~= LP then
                table.insert(PlayerESP.conns, plr.CharacterAdded:Connect(function(c) task.defer(setupPlayer, plr, c) end))
                if plr.Character then task.spawn(setupPlayer, plr, plr.Character) end
            end
        end))
        table.insert(PlayerESP.conns, Players.PlayerRemoving:Connect(cleanupPlayer))
    end
    local function stopPlayerESP()
        PlayerESP.enabled = false
        for _, c in ipairs(PlayerESP.conns) do pcall(function() c:Disconnect() end) end
        PlayerESP.conns = {}
        for plr in pairs(PlayerESP.playerData) do cleanupPlayer(plr) end
        PlayerESP.playerData = {}
    end

    local TracerESP = { drawings = {}, conn = nil, gui = nil }
    local function _tracerCleanup(plr)
        local d = TracerESP.drawings[plr]
        if not d then return end
        pcall(function() if d.line then d.line:Destroy() end end)
        TracerESP.drawings[plr] = nil
    end
    local function startTracerESP()
        if TracerESP.conn then return end
        local gui = Instance.new("ScreenGui")
        gui.Name = "SevenUpTracerReliable"
        gui.IgnoreGuiInset = true; gui.ResetOnSpawn = false; gui.DisplayOrder = 60
        pcall(function() gui.Parent = PlayerGui end)
        if not gui.Parent then pcall(function() gui.Parent = game:GetService("CoreGui") end) end
        TracerESP.gui = gui
        TracerESP.conn = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            if not cam then return end
            local origin = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y)
            local seen = {}
            local col = accent()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local sp, on = cam:WorldToViewportPoint(hrp.Position)
                        if on and sp.Z > 0 then
                            seen[plr] = true
                            local to = Vector2.new(sp.X, sp.Y)
                            local mid = (origin + to) / 2
                            local dist = (to - origin).Magnitude
                            local ang = math.deg(math.atan2(to.Y - origin.Y, to.X - origin.X))
                            local d = TracerESP.drawings[plr]
                            if not d or not d.line or not d.line.Parent then
                                local line = Instance.new("Frame")
                                line.Name = "TracerLine"
                                line.AnchorPoint = Vector2.new(0.5, 0.5)
                                line.BorderSizePixel = 0
                                line.BackgroundTransparency = 0.12
                                line.ZIndex = 20
                                line.Parent = gui
                                d = { line = line }
                                TracerESP.drawings[plr] = d
                            end
                            d.line.BackgroundColor3 = col
                            d.line.Size = UDim2.new(0, dist, 0, 1.6)
                            d.line.Position = UDim2.new(0, mid.X, 0, mid.Y)
                            d.line.Rotation = ang
                            d.line.Visible = true
                        end
                    end
                end
            end
            for plr in pairs(TracerESP.drawings) do
                if not seen[plr] then _tracerCleanup(plr) end
            end
        end)
    end
    local function stopTracerESP()
        if TracerESP.conn then pcall(function() TracerESP.conn:Disconnect() end); TracerESP.conn = nil end
        for plr in pairs(TracerESP.drawings) do _tracerCleanup(plr) end
        if TracerESP.gui then pcall(function() TracerESP.gui:Destroy() end); TracerESP.gui = nil end
    end

    local BART = {
        hatId = "127854264346577",
        shirtId = 135553740919809,
        pantsId = 5309277694,
        headId = 18913474191,
        bodyColor = Color3.fromRGB(245, 205, 45),
    local function applyBartSkin(char)
        if not char then return false end
        local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
        if not hum then return false end
        pcall(function()
            local desc = hum:GetAppliedDescription()
            desc.Shirt = BART.shirtId
            desc.Pants = BART.pantsId
            desc.Head = BART.headId
            desc.HeadColor = BART.bodyColor
            desc.LeftArmColor = BART.bodyColor
            desc.RightArmColor = BART.bodyColor
            desc.LeftLegColor = BART.bodyColor
            desc.RightLegColor = BART.bodyColor
            desc.TorsoColor = BART.bodyColor
            hum:ApplyDescription(desc)
        end)

        for _, p in ipairs(char:GetChildren()) do
            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                pcall(function() p.Color = BART.bodyColor end)
            end
        end

        pcall(function()
            local old = char:FindFirstChild("NoxaBartHat")
            if old then old:Destroy() end
            local objs
            local ok, res = pcall(function() return game:GetObjects("rbxassetid://" .. BART.hatId) end)
            if ok and type(res)=="table" and #res>0 then objs = res
            else
                ok, res = pcall(function() return game:GetService("InsertService"):LoadAsset(tonumber(BART.hatId)) end)
                if ok and res then objs = {res} end
            end
            if objs then
                local hat = objs[1]
                if hat then
                    hat.Name = "NoxaBartHat"
                    pcall(function() hum:AddAccessory(hat) end)
                    if not hat.Parent then hat.Parent = char end
                end
            end
        end)
        return true
    end
    _G.NoxaApplyBartSkin = applyBartSkin

    _G._Noxa7UpPort = {
        startPlayerESP = startPlayerESP,
        stopPlayerESP = stopPlayerESP,
        startTracerESP = startTracerESP,
        stopTracerESP = stopTracerESP,
        applyBartSkin = applyBartSkin,
        PlayerESP = PlayerESP,
        TracerESP = TracerESP,
end

task.wait()
NoxaUI.mkSection(P_UTILITY, "ESP")
    local port = _G._Noxa7UpPort
    SpeedSystem.playerESP = SpeedSystem.playerESP == true
    SpeedSystem.tracerESP = SpeedSystem.tracerESP == true
    local playerRow = NoxaUI.mkToggle(P_UTILITY, "Player ESP", SpeedSystem.playerESP == true, false)
    local tracerRow = NoxaUI.mkToggle(P_UTILITY, "Tracer ESP", SpeedSystem.tracerESP == true, false)
    ToggleStates.__on(playerRow, function(state)
        SpeedSystem.playerESP = state == true
        if port then
            if state then port.startPlayerESP() else port.stopPlayerESP() end
        end
        pcall(function() if NoxaCfg then NoxaCfg.saveConfig(true) end end)
    end)
    ToggleStates.__on(tracerRow, function(state)
        SpeedSystem.tracerESP = state == true
        if port then
            if state then port.startTracerESP() else port.stopTracerESP() end
        end
        pcall(function() if NoxaCfg then NoxaCfg.saveConfig(true) end end)
    end)
    task.defer(function()
        if not port then return end
        if SpeedSystem.playerESP then port.startPlayerESP() end
        if SpeedSystem.tracerESP then port.startTracerESP() end
    end)
end

NoxaUI.mkSection(P_UTILITY, "CAMERA")

    local fovOptions = {70, 90, 120, 140}
    local fovConn = nil
    local function applyFOV(val)
        SpeedSystem.fov = val
        if fovConn then fovConn:Disconnect() end
        fovConn = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            if cam then pcall(function() cam.FieldOfView = val end) end
        end)
    end
    local function stopFOV()
        if fovConn then fovConn:Disconnect(); fovConn = nil end
        pcall(function()
            local cam = workspace.CurrentCamera
            if cam then cam.FieldOfView = 70 end
        end)
    end

    local curFov = SpeedSystem.fov or 70
    local fovIdx = 0
    for i, v in ipairs(fovOptions) do
        if v == curFov then fovIdx = i - 1 break end
    end

    local fovCard = NoxaUI.new("Frame", {
        Size = UDim2.new(1, -4, 0, 56),
        BackgroundColor3 = ROW_BG, BackgroundTransparency = 0.12,
        BorderSizePixel = 0, Parent = P_UTILITY,
    NoxaUI.corner(fovCard, 10); NoxaUI.darkStroke(fovCard, 1)
    NoxaUI.new("TextLabel", {
        Position = UDim2.new(0, 12, 0, 6), Size = UDim2.new(1, -24, 0, 14),
        BackgroundTransparency = 1, Text = "FOV",
        TextColor3 = TEXT_MAIN or Color3.fromRGB(230,230,235),
        TextSize = 12, Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = fovCard,
    local fovTrack = NoxaUI.new("Frame", {
        Position = UDim2.new(0, 10, 0, 26),
        Size = UDim2.new(1, -20, 0, 24),
        BackgroundColor3 = Color3.fromRGB(18,20,26),
        BackgroundTransparency = 0.15, BorderSizePixel = 0, Parent = fovCard,
    NoxaUI.corner(fovTrack, 999)
    local fovSlider = NoxaUI.new("Frame", {
        ZIndex = 6, Size = UDim2.new(1/4, -4, 1, -4),
        Position = UDim2.new(fovIdx / 4, 2, 0, 2),
        BackgroundColor3 = ACCENT or Color3.fromRGB(70, 170, 255),
        BorderSizePixel = 0, Parent = fovTrack,
    NoxaUI.corner(fovSlider, 999)
    NoxaUI.regAccent(fovSlider)
    local fovBtns = {}
    local function setFovUI(idx)
        idx = math.clamp(idx, 0, 3)
        TweenService:Create(fovSlider, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
            Position = UDim2.new(idx / 4, 2, 0, 2)
        }):Play()
        for i, btn in ipairs(fovBtns) do
            btn.TextColor3 = ((i - 1) == idx)
                and Color3.fromRGB(255,255,255)
                or (TEXT_DIM or Color3.fromRGB(140,150,160))
        end
    end
    for i, val in ipairs(fovOptions) do
        local btn = NoxaUI.new("TextButton", {
            ZIndex = 7,
            Position = UDim2.new((i - 1) / 4, 0, 0, 0),
            Size = UDim2.new(1/4, 0, 1, 0),
            BackgroundTransparency = 1, Text = tostring(val),
            TextColor3 = TEXT_DIM or Color3.fromRGB(140,150,160),
            TextSize = 11, Font = Enum.Font.GothamBold,
            AutoButtonColor = false, Parent = fovTrack,
        fovBtns[i] = btn
        btn.MouseButton1Click:Connect(function()
            applyFOV(val)
            setFovUI(i - 1)
            pcall(function() NoxaCfg.saveConfig(true) end)
        end)
    end
    setFovUI(fovIdx)
    if curFov ~= 70 then applyFOV(curFov) end
    _G.NoxaFOV = { apply = applyFOV, stop = stopFOV, options = fovOptions }
end

    local stretchRow = NoxaUI.mkToggle(P_UTILITY, "Stretch Rez", SpeedSystem.NoxaVisual.stretchResEnabled == true, false)
    local stretchConn, originalCFrame = nil, nil
    _G.NoxaStretchRow = stretchRow

    local function applyStretchRes()
        if stretchConn then return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        originalCFrame = cam.CFrame
        stretchConn = RunService.RenderStepped:Connect(function()
            if not SpeedSystem.NoxaVisual.stretchResEnabled then return end
            local c = workspace.CurrentCamera
                c.CFrame = c.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.65, 0, 0, 0, 1)
            end
        end)
    end
    local function stopStretchRes()
        if stretchConn then pcall(function() stretchConn:Disconnect() end); stretchConn = nil end
        local cam = workspace.CurrentCamera
        if cam and originalCFrame then pcall(function() cam.CFrame = originalCFrame end) end
        originalCFrame = nil
    end
    function SpeedSystem.NoxaVisual.setStretchRes(self, on)
        self.stretchResEnabled = on and true or false
        if self.stretchResEnabled then applyStretchRes() else stopStretchRes() end
    end
    ToggleStates.__on(stretchRow, function(state)
        SpeedSystem.NoxaVisual:setStretchRes(state)
        pcall(NoxaCfg.saveConfig)
    end)
    if SpeedSystem.NoxaVisual.stretchResEnabled then
        SpeedSystem.NoxaVisual:setStretchRes(true)
    end
end

    local raRow = NoxaUI.mkToggle(P_UTILITY, "Remove Accessories", SpeedSystem.removeAccessoriesEnabled == true, false)
    local raOn, raConn, raRemoved = false, nil, {}
    _G.NoxaRemoveAccRow = raRow

    local function raDo()
        if not raOn then return end
        local char = LP.Character
        if not char then return end
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Accessory") or obj:IsA("Hat") then
                if not raRemoved[obj] then
                    raRemoved[obj] = true
                    pcall(function() obj:Destroy() end)
                end
            end
        end
    end
    local function raStart()
        if raOn then return end
        raOn = true
        SpeedSystem.removeAccessoriesEnabled = true
        raDo()
        raConn = LP.CharacterAdded:Connect(function()
            task.wait(0.5)
            if raOn then raDo() end
        end)
    end
    local function raStop()
        raOn = false
        SpeedSystem.removeAccessoriesEnabled = false
        if raConn then pcall(function() raConn:Disconnect() end); raConn = nil end
        raRemoved = {}
    end
    ToggleStates.__on(raRow, function(state)
        if state then raStart() else raStop() end
        pcall(NoxaCfg.saveConfig)
    end)
    if SpeedSystem.removeAccessoriesEnabled then
        raStart()
        ToggleStates[raRow] = true
    end
end

    local npcRow = NoxaUI.mkToggle(P_UTILITY, "No Player Collision", SpeedSystem.noPlayerCollisionEnabled == true, false)
    _G.NoxaNoPlayerCollisionRow = npcRow
    ToggleStates.__on(npcRow, function(state)
        local on = state == true
        SpeedSystem.noPlayerCollisionEnabled = on
        if on then
            if _G.NoxaEnableNoPlayerCollision then _G.NoxaEnableNoPlayerCollision() end
            pcall(function() if notify then notify("No Player Collision ON", 1.3) end end)
        else
            if _G.NoxaDisableNoPlayerCollision then _G.NoxaDisableNoPlayerCollision() end
            pcall(function() if notify then notify("No Player Collision OFF", 1.2) end end)
        end
        pcall(NoxaCfg.saveConfig)
    end)
    if SpeedSystem.noPlayerCollisionEnabled then
        pcall(function() if _G.NoxaEnableNoPlayerCollision then _G.NoxaEnableNoPlayerCollision() end end)
        ToggleStates[npcRow] = true
    end
end

pcall(function()
    if NoxaUI.applyAccentAll and not SpeedSystem.bgImageIndex then
        NoxaUI.applyAccentAll(Color3.fromRGB(70, 170, 255))
    end
end)

task.wait()
NoxaUI.mkSection(P_UTILITY,"AUTO PATH")

    local AP_L1, AP_L2 = Vector3.new(-476.47, -6.28, 92.73), Vector3.new(-483.12, -4.95, 94.81)
    local AP_R1, AP_R2 = Vector3.new(-476.16, -6.52, 25.62), Vector3.new(-483.06, -5.03, 25.48)

    local function rowParts(r)
        if not r then return nil, nil end
        local area = r:FindFirstChild("ToggleArea")
        if not area then return nil, nil end
        local track
        for _, c in ipairs(area:GetChildren()) do
            if c:IsA("Frame") then track = c break end
        end
        if not track then return nil, nil end
        local knob
        for _, c in ipairs(track:GetChildren()) do
            if c:IsA("Frame") then knob = c break end
        end
        return track, knob
    end

    local function setRowVisual(r, state)
        if not r then return end
        ToggleStates[r] = state and true or false
        local track, knob = rowParts(r)
        if track and knob then NoxaUI.setToggleVisual(track, knob, state and true or false) end
    end

    local function pathSpeed()
        if SpeedSystem.laggerActive then return tonumber(SpeedSystem.LAGGER_NORMAL) or 15 end
        return tonumber(SpeedSystem.NS) or 60
    end

    local function stepTo(hum, hrp, target, spd)
        if not hum or not hrp then return end
        local d = target - hrp.Position
        local mv = Vector3.new(d.X, 0, d.Z)
        if mv.Magnitude < 0.05 then return end
        mv = mv.Unit
        pcall(function() hum:Move(mv, false) end)
        pcall(function() SpeedSystem:applySpeed(hrp, hum, mv, spd, 1/60) end)
    end

    SpeedSystem.autoPlayMode = "2btn"
    SpeedSystem.autoPlayEnabled = false

    local autoLeftRow  = NoxaUI.mkToggle(P_UTILITY, "Auto Left  [Z]",  SpeedSystem.AutoPath.leftEnabled == true)
    local autoRightRow = NoxaUI.mkToggle(P_UTILITY, "Auto Right [C]", SpeedSystem.AutoPath.rightEnabled == true)

    SpeedSystem.AutoPath.stop = function(side)
        local conn = SpeedSystem.AutoPath[side .. "Conn"]
        if conn then pcall(function() conn:Disconnect() end) end
        SpeedSystem.AutoPath[side .. "Conn"] = nil
        SpeedSystem.AutoPath[side .. "Phase"] = 1
        SpeedSystem.AutoPath[side .. "Enabled"] = false
        SpeedSystem:destroySpeedObjects()
        local char = LP.Character
        if char then
            local h = char:FindFirstChildOfClass("Humanoid")
            if h then pcall(function() h:Move(Vector3.new(0,0,0), false) end) end
        end
        if side == "left" then setRowVisual(autoLeftRow, false)
        elseif side == "right" then setRowVisual(autoRightRow, false) end
    end

    SpeedSystem.AutoPath.start = function(side)
        local blocked = false
        pcall(function()
            if SpeedSystem.safeModeEnabled and SpeedSystem.isActionBlocked then
                blocked = select(1, SpeedSystem:isActionBlocked("autoplay")) == true
            end
        end)
        if blocked then
            pcall(function() if notify then notify("Blocked · Safe Mode", 1.4) end end)
            return
        end
        SpeedSystem.AutoPath.stop(side == "left" and "right" or "left")
        SpeedSystem.AutoPath.stop(side)
        SpeedSystem.AutoPath[side .. "Enabled"] = true
        SpeedSystem.AutoPath[side .. "Phase"] = 1
        setRowVisual(side == "left" and autoLeftRow or autoRightRow, true)
        pcall(function()
            if _G.NoxaMobileSyncAutoPlay then _G.NoxaMobileSyncAutoPlay() end
        end)
        local P1 = side == "left" and AP_L1 or AP_R1
        local P2 = side == "left" and AP_L2 or AP_R2
        local conn = RunService.Heartbeat:Connect(function()
            if not SpeedSystem.AutoPath[side .. "Enabled"] then return end
            if SpeedSystem.safeModeEnabled then
                local lock = false
                pcall(function()
                    if _G.NoxaSafeModeIsLocked then lock = _G.NoxaSafeModeIsLocked() end
                end)
                if lock then
                    SpeedSystem.AutoPath.stop(side)
                    return
                end
            end
            local char = LP.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum or hum.Health <= 0 then return end
            local st = hum:GetState()
            if hum.PlatformStand or st == Enum.HumanoidStateType.Physics
                or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
                pcall(function()
                    hum.PlatformStand = false
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                    hum:Move(Vector3.new(0,0,0), false)
                end)
                return
            end
            local spd = pathSpeed()
            if SpeedSystem.AutoPath[side .. "Phase"] == 1 then
                local tgt = Vector3.new(P1.X, hrp.Position.Y, P1.Z)
                if (Vector3.new(tgt.X, 0, tgt.Z) - Vector3.new(hrp.Position.X, 0, hrp.Position.Z)).Magnitude < 1.5 then
                    SpeedSystem.AutoPath[side .. "Phase"] = 2
                    stepTo(hum, hrp, P2, spd)
                    return
                end
                stepTo(hum, hrp, P1, spd)
            else
                local tgt = Vector3.new(P2.X, hrp.Position.Y, P2.Z)
                if (Vector3.new(tgt.X, 0, tgt.Z) - Vector3.new(hrp.Position.X, 0, hrp.Position.Z)).Magnitude < 1.5 then
                    SpeedSystem.AutoPath.stop(side)
                    pcall(function()
                        if _G.NoxaMobileSyncAutoPlay then _G.NoxaMobileSyncAutoPlay() end
                    end)
                    return
                end
                stepTo(hum, hrp, P2, spd)
            end
        end)
        SpeedSystem.AutoPath[side .. "Conn"] = conn
        pcall(function()
            if _G._NoxaTrackConn then _G._NoxaTrackConn(conn) end
        end)
    end

    SpeedSystem.AutoPath.set = function(side, on)
        if on then SpeedSystem.AutoPath.start(side) else SpeedSystem.AutoPath.stop(side) end
    end

    SpeedSystem.AutoPath.setYusf = function(on)

        if on then SpeedSystem.AutoPath.set("left", true) else
            SpeedSystem.AutoPath.stop("left"); SpeedSystem.AutoPath.stop("right")
        end
    end
    SpeedSystem.AutoPath.setYusfDirection = function() end

    ToggleStates.__on(autoLeftRow,  function(state)
        SpeedSystem.AutoPath.set("left", state)
        NoxaCfg.saveConfig()
    end)
    ToggleStates.__on(autoRightRow, function(state)
        SpeedSystem.AutoPath.set("right", state)
        NoxaCfg.saveConfig()
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if _G.NoxaKeyListening then return end
        if gp and input.UserInputType == Enum.UserInputType.Keyboard then return end
        if not noxaIsBindableKey(input) then return end
        if input.KeyCode == Enum.KeyCode.Unknown then return end
        if SpeedSystem.keybinds and input.KeyCode == SpeedSystem.keybinds.AutoLeft then
            SpeedSystem.AutoPath.set("left", not SpeedSystem.AutoPath.leftEnabled)
            NoxaCfg.saveConfig()
        elseif SpeedSystem.keybinds and input.KeyCode == SpeedSystem.keybinds.AutoRight then
            SpeedSystem.AutoPath.set("right", not SpeedSystem.AutoPath.rightEnabled)
            NoxaCfg.saveConfig()
        end
    end)

    LP.CharacterAdded:Connect(function()
        SpeedSystem.AutoPath.stop("left"); SpeedSystem.AutoPath.stop("right")
    end)

    _G.NoxaAutoPlayRows = {
        left = autoLeftRow, right = autoRightRow,
        setRowVisual = setRowVisual,
end

if SpeedSystem.animPack ~= "OFF" and PACKS[SpeedSystem.animPack] then
    task.delay(1, function()
        pcall(function() AnimPack.applyPack(SpeedSystem.animPack) end)
    end)
end

task.wait()
NoxaUI.mkSection(P_SETTINGS, "MOBILE")
    local lockRow = NoxaUI.mkToggle(P_SETTINGS, "Lock Mobile Buttons", SpeedSystem.mobileButtons.locked == true)
    ToggleStates.__on(lockRow, function(state)
        SpeedSystem.mobileButtons.locked = state == true
        pcall(function() if _G.NoxaMobileApplyLock then _G.NoxaMobileApplyLock() end end)
        NoxaCfg.saveConfig()
    end)
    local hideRow = NoxaUI.mkToggle(P_SETTINGS, "Hide Mobile Buttons", SpeedSystem.mobileButtons.hidden == true)
    ToggleStates.__on(hideRow, function(state)
        SpeedSystem.mobileButtons.hidden = state == true
        pcall(function() if _G.NoxaMobileApplyHidden then _G.NoxaMobileApplyHidden() end end)
        NoxaCfg.saveConfig()
    end)

    local styleKeys = {"round", "squircle", "rect1", "rect2"}
    local styleLabels = {"Round", "Squircle", "Rect L", "Rect T"}
    local curStyle = SpeedSystem.mobileButtons.style or "squircle"
    local styleIdx = 1
    for i, s in ipairs(styleKeys) do
        if s == curStyle then styleIdx = i - 1 break end
    end
    local stCard = NoxaUI.new("Frame", {
        Size = UDim2.new(1, -4, 0, 56),
        BackgroundColor3 = ROW_BG, BackgroundTransparency = 0.12,
        BorderSizePixel = 0, Parent = P_SETTINGS,
    NoxaUI.corner(stCard, 10); NoxaUI.darkStroke(stCard, 1)
    NoxaUI.new("TextLabel", {
        Position = UDim2.new(0, 12, 0, 6), Size = UDim2.new(1, -24, 0, 14),
        BackgroundTransparency = 1, Text = "Mobile Style",
        TextColor3 = TEXT_MAIN, TextSize = 12, Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = stCard,
    local stTrack = NoxaUI.new("Frame", {
        Position = UDim2.new(0, 10, 0, 26),
        Size = UDim2.new(1, -20, 0, 24),
        BackgroundColor3 = Color3.fromRGB(18,20,26),
        BackgroundTransparency = 0.15, BorderSizePixel = 0, Parent = stCard,
    NoxaUI.corner(stTrack, 999)
    local stSlider = NoxaUI.new("Frame", {
        ZIndex = 6, Size = UDim2.new(1/4, -4, 1, -4),
        Position = UDim2.new(styleIdx / 4, 2, 0, 2),
        BackgroundColor3 = ACCENT or Color3.fromRGB(70, 170, 255),
        BorderSizePixel = 0, Parent = stTrack,
    NoxaUI.corner(stSlider, 999)
    NoxaUI.regAccent(stSlider)
    local stBtns = {}
    local function setStyleUI(idx)
        idx = math.clamp(idx, 0, 3)
        TweenService:Create(stSlider, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
            Position = UDim2.new(idx / 4, 2, 0, 2)
        }):Play()
        for i, btn in ipairs(stBtns) do
            btn.TextColor3 = ((i - 1) == idx)
                and Color3.fromRGB(255,255,255) or TEXT_DIM
        end
    end
    for i, label in ipairs(styleLabels) do
        local btn = NoxaUI.new("TextButton", {
            ZIndex = 7,
            Position = UDim2.new((i - 1) / 4, 0, 0, 0),
            Size = UDim2.new(1/4, 0, 1, 0),
            BackgroundTransparency = 1, Text = label,
            TextColor3 = TEXT_DIM, TextSize = 10, Font = Enum.Font.GothamBold,
            AutoButtonColor = false, Parent = stTrack,
        stBtns[i] = btn
        btn.MouseButton1Click:Connect(function()
            SpeedSystem.mobileButtons.style = styleKeys[i]
            setStyleUI(i - 1)
            pcall(function() if _G.NoxaMobileApplyStyle then _G.NoxaMobileApplyStyle() end end)
            pcall(function() NoxaCfg.saveConfig() end)
            pcall(function() if notify then notify("Mobile style · " .. label, 1.2) end end)
        end)
    end
    setStyleUI(styleIdx)

    local resetRow, resetClick = NoxaUI.mkBigBtn(P_SETTINGS, "RESET MOBILE POS")

    if resetClick then
        resetClick.MouseButton1Click:Connect(function()
            SpeedSystem.mobileButtons.positions = {}
            pcall(function() if _G.NoxaMobileResetPos then _G.NoxaMobileResetPos() end end)
            NoxaCfg.saveConfig()
            pcall(function() if notify then notify("Mobile positions reset", 2) end end)
        end)
    end
end

task.wait()
NoxaUI.mkSection(P_CUSTOM, "BACKGROUND")
    local bgImageRow = NoxaUI.mkToggle(P_CUSTOM, "Background Image", SpeedSystem.bgImageEnabled ~= false, false)
    _G.NoxaBgImageRow = bgImageRow
    ToggleStates.__on(bgImageRow, function(state)
        SpeedSystem.bgImageEnabled = state == true

        pcall(function()
            if type(noxaApplyBgImage) == "function" then
                noxaApplyBgImage(SpeedSystem.bgImageIndex or 1)
            elseif type(_G.NoxaApplyBgImage) == "function" then
                _G.NoxaApplyBgImage(SpeedSystem.bgImageIndex or 1)
            end
        end)

        local vis = SpeedSystem.bgImageEnabled == true
        pcall(function() if BgAsset then BgAsset.Visible = vis end end)
        pcall(function() if _G._NoxaKuRuBG then _G._NoxaKuRuBG.Visible = vis end end)
        pcall(function() if _G._NoxaVx7BG then _G._NoxaVx7BG.Visible = vis end end)
        pcall(function()
            for _, name in ipairs({"NoxaKuRuSkin", "NoxaVx7Skin"}) do
                local g = PlayerGui:FindFirstChild(name)
                    local sb = g:FindFirstChild("SelectedBackground", true)
                    if sb then sb.Visible = vis end
                    local gb = g:FindFirstChild("GeneralBackground", true)
                    if gb then gb.Visible = vis end
                end
            end
        end)
        pcall(function()
            NoxaCfg.dirty = true
            NoxaCfg.saveConfig(true)
        end)
    end)

    if BgAsset then BgAsset.Visible = SpeedSystem.bgImageEnabled ~= false end

    local openRow = NoxaUI.new("Frame", {
        ZIndex = 802, Size = UDim2.new(1, -4, 0, 38),
        BackgroundColor3 = ROW_BG, BackgroundTransparency = 0.42,
        BorderSizePixel = 0, Parent = P_CUSTOM,
    NoxaUI.corner(openRow, 9); NoxaUI.darkStroke(openRow, 1)
    local openBtn = NoxaUI.new("TextButton", {
        ZIndex = 803, Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "OPEN BACKGROUND STYLES",
        TextColor3 = ACCENT or Color3.fromRGB(82, 170, 255),
        TextSize = 12, Font = Enum.Font.GothamBold,
        AutoButtonColor = false, Parent = openRow,
    NoxaUI.regAccent(openBtn, "TextColor3")

    local function openRitualBgGallery()
        if PlayerGui:FindFirstChild("NoxaBackgroundGalleryLayer") then return end
        local lo, hi = 1, 4
        pcall(function() lo, hi = noxaBgRangeForSkin(SpeedSystem.uiSkin or "Noxa") end)
        hi = math.min(hi, #NOXA_BG_IMAGES)
        lo = math.clamp(lo, 1, hi)
        local selectedIndex = math.clamp(tonumber(SpeedSystem.bgImageIndex) or lo, lo, hi)
        local closing = false
        local cardRefs = {}

        local modalGui = Instance.new("ScreenGui")
        modalGui.Name = "NoxaBackgroundGalleryLayer"
        modalGui.ResetOnSpawn = false
        modalGui.IgnoreGuiInset = true
        modalGui.DisplayOrder = 999
        modalGui.Parent = PlayerGui

        local Lighting = game:GetService("Lighting")
        local blur = Instance.new("BlurEffect")
        blur.Name = "NoxaBgGalleryBlur"
        blur.Size = 0
        blur.Parent = Lighting

        local overlay = Instance.new("TextButton")
        overlay.Size = UDim2.fromScale(1, 1)
        overlay.BackgroundColor3 = Color3.fromRGB(2, 3, 8)
        overlay.BackgroundTransparency = 1
        overlay.BorderSizePixel = 0
        overlay.Text = ""
        overlay.AutoButtonColor = false
        overlay.ZIndex = 100
        overlay.Parent = modalGui

        local popup = Instance.new("CanvasGroup")
        popup.AnchorPoint = Vector2.new(0.5, 0.5)
        popup.Position = UDim2.fromScale(0.5, 0.5)
        popup.Size = UDim2.fromOffset(720, 470)
        popup.BackgroundColor3 = Color3.fromRGB(7, 8, 14)
        popup.BackgroundTransparency = 0.34
        popup.BorderSizePixel = 0
        popup.ClipsDescendants = true
        popup.GroupTransparency = 1
        popup.ZIndex = 101
        popup.Parent = overlay
        Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 20)
        local pst = Instance.new("UIStroke", popup)
        pst.Color = Color3.fromRGB(104, 112, 138)
        pst.Thickness = 1.4
        pst.Transparency = 0.34

        local popupScale = Instance.new("UIScale", popup)
        local function getTargetScale()
            local cam = workspace.CurrentCamera
            local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
            return math.clamp(math.min((vp.X - 28) / 720, (vp.Y - 28) / 470), 0.42, 1)
        end
        local targetScale = getTargetScale()
        popupScale.Scale = targetScale * 0.78

        local title = Instance.new("TextLabel", popup)
        title.Position = UDim2.fromOffset(24, 22)
        title.Size = UDim2.new(1, -80, 0, 28)
        title.BackgroundTransparency = 1
        title.RichText = true
        title.Text = 'NOXA <font color="rgb(120,190,255)">BACKGROUNDS</font>'
        title.TextColor3 = Color3.fromRGB(247, 248, 255)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 18
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 104

        local closeBtn = Instance.new("TextButton", popup)
        closeBtn.AnchorPoint = Vector2.new(1, 0)
        closeBtn.Position = UDim2.new(1, -20, 0, 18)
        closeBtn.Size = UDim2.fromOffset(36, 36)
        closeBtn.BackgroundColor3 = Color3.fromRGB(24, 26, 38)
        closeBtn.BackgroundTransparency = 0.5
        closeBtn.BorderSizePixel = 0
        closeBtn.Text = "X"
        closeBtn.TextColor3 = Color3.fromRGB(211, 215, 231)
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 12
        closeBtn.ZIndex = 110
        Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 10)

        local previewPanel = Instance.new("Frame", popup)
        previewPanel.Position = UDim2.fromOffset(20, 70)
        previewPanel.Size = UDim2.fromOffset(420, 380)
        previewPanel.BackgroundColor3 = Color3.fromRGB(11, 12, 19)
        previewPanel.BackgroundTransparency = 0.32
        previewPanel.BorderSizePixel = 0
        previewPanel.ZIndex = 103
        Instance.new("UICorner", previewPanel).CornerRadius = UDim.new(0, 16)

        local hero = Instance.new("ImageLabel", previewPanel)
        hero.Position = UDim2.fromOffset(8, 8)
        hero.Size = UDim2.new(1, -16, 1, -90)
        hero.BackgroundColor3 = Color3.fromRGB(5, 6, 10)
        hero.BorderSizePixel = 0
        hero.Image = NOXA_BG_IMAGES[selectedIndex]
        hero.ScaleType = Enum.ScaleType.Crop
        hero.ZIndex = 104
        Instance.new("UICorner", hero).CornerRadius = UDim.new(0, 12)

        local selectedTitle = Instance.new("TextLabel", previewPanel)
        selectedTitle.Position = UDim2.fromOffset(18, 310)
        selectedTitle.Size = UDim2.fromOffset(180, 20)
        selectedTitle.BackgroundTransparency = 1
        selectedTitle.TextColor3 = Color3.fromRGB(241, 243, 252)
        selectedTitle.Font = Enum.Font.GothamBlack
        selectedTitle.TextSize = 12
        selectedTitle.TextXAlignment = Enum.TextXAlignment.Left
        selectedTitle.ZIndex = 108
        selectedTitle.Text = string.format("STYLE %02d", selectedIndex)

        local applyBtn = Instance.new("TextButton", previewPanel)
        applyBtn.AnchorPoint = Vector2.new(1, 1)
        applyBtn.Position = UDim2.new(1, -12, 1, -12)
        applyBtn.Size = UDim2.fromOffset(166, 46)
        applyBtn.BackgroundColor3 = Color3.fromRGB(18, 67, 116)
        applyBtn.BackgroundTransparency = 0.04
        applyBtn.BorderSizePixel = 0
        applyBtn.Text = "APPLY BACKGROUND"
        applyBtn.TextColor3 = Color3.fromRGB(120, 190, 255)
        applyBtn.Font = Enum.Font.GothamBlack
        applyBtn.TextSize = 10
        applyBtn.AutoButtonColor = false
        applyBtn.ZIndex = 109
        Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 12)

        local libraryPanel = Instance.new("Frame", popup)
        libraryPanel.Position = UDim2.fromOffset(454, 70)
        libraryPanel.Size = UDim2.new(1, -474, 1, -90)
        libraryPanel.BackgroundColor3 = Color3.fromRGB(10, 11, 18)
        libraryPanel.BackgroundTransparency = 0.38
        libraryPanel.BorderSizePixel = 0
        libraryPanel.ZIndex = 103
        Instance.new("UICorner", libraryPanel).CornerRadius = UDim.new(0, 16)

        local libraryTitle = Instance.new("TextLabel", libraryPanel)
        libraryTitle.Position = UDim2.fromOffset(14, 10)
        libraryTitle.Size = UDim2.new(1, -28, 0, 20)
        libraryTitle.BackgroundTransparency = 1
        libraryTitle.Text = "IMAGE LIBRARY"
        libraryTitle.TextColor3 = Color3.fromRGB(220, 223, 237)
        libraryTitle.Font = Enum.Font.GothamBlack
        libraryTitle.TextSize = 10
        libraryTitle.TextXAlignment = Enum.TextXAlignment.Left
        libraryTitle.ZIndex = 105

        local gallery = Instance.new("ScrollingFrame", libraryPanel)
        gallery.Position = UDim2.fromOffset(10, 38)
        gallery.Size = UDim2.new(1, -20, 1, -48)
        gallery.BackgroundTransparency = 1
        gallery.BorderSizePixel = 0
        gallery.ScrollBarThickness = 2
        gallery.ScrollBarImageColor3 = Color3.fromRGB(82, 170, 255)
        gallery.CanvasSize = UDim2.fromOffset(0, 0)
        gallery.AutomaticCanvasSize = Enum.AutomaticSize.Y
        gallery.ZIndex = 104
        local gridLay = Instance.new("UIGridLayout", gallery)
        gridLay.CellSize = UDim2.fromOffset(100, 72)
        gridLay.CellPadding = UDim2.fromOffset(8, 8)
        gridLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
        gridLay.SortOrder = Enum.SortOrder.LayoutOrder

        local function refreshSelection()
            selectedIndex = math.clamp(selectedIndex, 1, #NOXA_BG_IMAGES)
            hero.Image = NOXA_BG_IMAGES[selectedIndex]
            selectedTitle.Text = string.format("STYLE %02d", selectedIndex)
            local active = selectedIndex == (SpeedSystem.bgImageIndex or 1) and (SpeedSystem.bgImageEnabled ~= false)
            applyBtn.Text = active and "CURRENTLY ACTIVE" or "APPLY BACKGROUND"
            applyBtn.TextColor3 = active and Color3.fromRGB(132, 230, 168) or Color3.fromRGB(120, 190, 255)
            for index, ref in ipairs(cardRefs) do
                local selected = index == selectedIndex
                local current = index == (SpeedSystem.bgImageIndex or 1)
                ref.stroke.Color = selected and Color3.fromRGB(82, 170, 255)
                    or (current and Color3.fromRGB(84, 180, 116) or Color3.fromRGB(48, 51, 66))
                ref.stroke.Thickness = selected and 2.2 or 1
                ref.stroke.Transparency = selected and 0.02 or 0.25
                ref.badge.Text = current and "ON" or string.format("%02d", index)
            end
        end

        local function closeGallery()
            if closing then return end
            closing = true
            TweenService:Create(blur, TweenInfo.new(0.22), {Size = 0}):Play()
            TweenService:Create(overlay, TweenInfo.new(0.24), {BackgroundTransparency = 1}):Play()
            TweenService:Create(popup, TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.In), {GroupTransparency = 1}):Play()
            TweenService:Create(popupScale, TweenInfo.new(0.26), {Scale = targetScale * 0.8}):Play()
            task.delay(0.28, function()
                pcall(function() blur:Destroy() end)
                pcall(function() modalGui:Destroy() end)
            end)
        end

        for index, asset in ipairs(NOXA_BG_IMAGES) do
            if index < lo or index > hi then continue end
            local card = Instance.new("ImageButton", gallery)
            card.LayoutOrder = index
            card.BackgroundColor3 = Color3.fromRGB(12, 13, 20)
            card.BorderSizePixel = 0
            card.Image = asset
            card.ScaleType = Enum.ScaleType.Crop
            card.AutoButtonColor = false
            card.ZIndex = 105
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 11)
            local cardStroke = Instance.new("UIStroke", card)
            cardStroke.Color = Color3.fromRGB(48, 51, 66)
            cardStroke.Thickness = 1
            local badge = Instance.new("TextLabel", card)
            badge.AnchorPoint = Vector2.new(1, 1)
            badge.Position = UDim2.new(1, -6, 1, -6)
            badge.Size = UDim2.fromOffset(34, 18)
            badge.BackgroundColor3 = Color3.fromRGB(10, 11, 17)
            badge.BorderSizePixel = 0
            badge.Text = string.format("%02d", index)
            badge.TextColor3 = Color3.fromRGB(197, 201, 218)
            badge.Font = Enum.Font.GothamBlack
            badge.TextSize = 8
            badge.ZIndex = 108
            Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 6)
            cardRefs[index] = {stroke = cardStroke, badge = badge}
            card.MouseButton1Click:Connect(function()
                selectedIndex = index
                refreshSelection()
            end)
        end

        applyBtn.MouseButton1Click:Connect(function()
            SpeedSystem.bgImageIndex = selectedIndex
            SpeedSystem.bgImageEnabled = true
            if type(_G.NoxaApplyBgImage) == "function" then
                _G.NoxaApplyBgImage(selectedIndex)
            else
                if BgAsset and NOXA_BG_IMAGES[selectedIndex] then
                    BgAsset.Image = NOXA_BG_IMAGES[selectedIndex]
                    BgAsset.ImageTransparency = tonumber(SpeedSystem.bgImageTransparency) or 0.05
                    BgAsset.Visible = true
                end
            end

            pcall(function()
                local img = NOXA_BG_IMAGES[selectedIndex]
                for _, ref in ipairs({_G._NoxaKuRuBG, _G._NoxaVx7BG}) do
                    if ref and img then
                        ref.Image = img
                        ref.ImageTransparency = tonumber(SpeedSystem.bgImageTransparency) or 0.05
                        ref.Visible = true
                    end
                end
            end)
            pcall(function() NoxaCfg.saveConfig() end)
            refreshSelection()
        end)

        closeBtn.MouseButton1Click:Connect(closeGallery)
        overlay.MouseButton1Click:Connect(closeGallery)
        refreshSelection()

        TweenService:Create(blur, TweenInfo.new(0.3), {Size = 14}):Play()
        TweenService:Create(overlay, TweenInfo.new(0.28), {BackgroundTransparency = 0.32}):Play()
        TweenService:Create(popup, TweenInfo.new(0.44, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
        TweenService:Create(popupScale, TweenInfo.new(0.44, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = targetScale}):Play()
    end

    openBtn.MouseButton1Click:Connect(openRitualBgGallery)
end

    local HEADLESS_MESH_ID = "rbxassetid://1095708"

    local KORBLOX_MESH_ID  = "rbxassetid://101851696"
    local KORBLOX_TEX_ID   = "rbxassetid://101851254"
    local DARK_GREY        = Color3.fromRGB(64, 64, 64)

    local function removeFace(head)
        local face = head:FindFirstChild("face")
        if face then pcall(function() face:Destroy() end) end
    end

    SpeedSystem.NoxaChar.applyHeadless = function(char, enabled)
        if not char then return end
        local head = char:FindFirstChild("Head")
        if not head then return end
        if enabled then
            head.Transparency = 1
            head.CanCollide = false
            removeFace(head)
            for _, child in ipairs(head:GetChildren()) do
                if child:IsA("SpecialMesh") and child.Name == "HeadlessMesh" then child:Destroy() end
            end
            local mesh = Instance.new("SpecialMesh")
            mesh.MeshType = Enum.MeshType.FileMesh
            mesh.MeshId = HEADLESS_MESH_ID
            mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
            mesh.Name = "HeadlessMesh"
            mesh.Parent = head
            head:GetPropertyChangedSignal("Transparency"):Connect(function()
                if SpeedSystem.NoxaChar.headlessEnabled and head.Transparency ~= 1 then head.Transparency = 1 end
            end)
            head.ChildAdded:Connect(function(child)
                if SpeedSystem.NoxaChar.headlessEnabled and child.Name == "face" and child:IsA("Decal") then
                    pcall(function() child:Destroy() end)
                end
            end)
        else
            head.Transparency = 0
            head.CanCollide = true
            for _, child in ipairs(head:GetChildren()) do
                if child:IsA("SpecialMesh") and child.Name == "HeadlessMesh" then child:Destroy() end
            end
        end
    end

    SpeedSystem.NoxaChar.applyKorblox = function(char, enabled)
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if enabled then
            if hum.RigType == Enum.HumanoidRigType.R6 then
                local leg = char:FindFirstChild("Right Leg")
                if leg then
                    for _, child in ipairs(leg:GetChildren()) do
                        if child:IsA("SpecialMesh") or child:IsA("CharacterMesh") then child:Destroy() end
                    end
                    leg.Color = DARK_GREY
                    leg:GetPropertyChangedSignal("Color"):Connect(function()
                        if SpeedSystem.NoxaChar.korbloxEnabled and leg.Color ~= DARK_GREY then leg.Color = DARK_GREY end
                    end)
                    local mesh = Instance.new("SpecialMesh")
                    mesh.MeshType = Enum.MeshType.FileMesh
                    mesh.MeshId = KORBLOX_MESH_ID
                    mesh.TextureId = KORBLOX_TEX_ID
                    mesh.Name = "KorbloxMesh"
                    mesh.Parent = leg
                end
            else
                local upper = char:FindFirstChild("RightUpperLeg")
                if upper then
                    upper.Transparency = 1
                    local lower = char:FindFirstChild("RightLowerLeg")
                    local foot  = char:FindFirstChild("RightFoot")
                    if lower then lower.Transparency = 1 end
                    if foot  then foot.Transparency  = 1 end
                    local old = char:FindFirstChild("KorbloxLeg")
                    if old then old:Destroy() end
                    local part = Instance.new("Part")
                    part.Name = "KorbloxLeg"
                    part.Size = Vector3.new(1, 2, 1)
                    part.Anchored = false
                    part.CanCollide = false
                    part.Color = DARK_GREY
                    part.Parent = char
                    local mesh = Instance.new("SpecialMesh")
                    mesh.MeshType = Enum.MeshType.FileMesh
                    mesh.MeshId = KORBLOX_MESH_ID
                    mesh.TextureId = KORBLOX_TEX_ID
                    mesh.Name = "KorbloxMesh"
                    mesh.Parent = part
                    local weld = Instance.new("Weld")
                    weld.Part0 = upper
                    weld.Part1 = part
                    weld.C0 = CFrame.new(0, -0.8, 0)
                    weld.Name = "KorbloxWeld"
                    weld.Parent = part
                end
            end
        else
            if hum.RigType == Enum.HumanoidRigType.R6 then
                local leg = char:FindFirstChild("Right Leg")
                if leg then
                    for _, child in ipairs(leg:GetChildren()) do
                        if child:IsA("SpecialMesh") and child.Name == "KorbloxMesh" then child:Destroy() end
                    end
                    leg.Color = Color3.fromRGB(255, 255, 255)
                end
            else
                local upper = char:FindFirstChild("RightUpperLeg")
                if upper then
                    upper.Transparency = 0
                    local lower = char:FindFirstChild("RightLowerLeg")
                    local foot  = char:FindFirstChild("RightFoot")
                    if lower then lower.Transparency = 0 end
                    if foot  then foot.Transparency  = 0 end
                end
                local kl = char:FindFirstChild("KorbloxLeg")
                if kl then kl:Destroy() end
            end
        end
    end

    SpeedSystem.NoxaChar.applyAll = function(char)
        if not char then return end
        pcall(SpeedSystem.NoxaChar.applyHeadless, char, SpeedSystem.NoxaChar.headlessEnabled)
        pcall(SpeedSystem.NoxaChar.applyKorblox,  char, SpeedSystem.NoxaChar.korbloxEnabled)
    end

    LP.CharacterAdded:Connect(function(char)
        task.wait(0.6)
        SpeedSystem.NoxaChar.applyAll(char)
    end)
    if LP.Character then
        task.defer(function()
            SpeedSystem.NoxaChar.applyAll(LP.Character)

        end)
    end
end

task.wait()

TAB_W = 70

TabBase = NoxaUI.new("Frame", {
    Name="TabBase", ZIndex=10,
    Position=UDim2.new(0, 6, 0, 52),
    Size=UDim2.new(0, TAB_W, 1, -60),
    BackgroundColor3=Color3.fromRGB(8, 10, 20),
    BackgroundTransparency=0.05,
    BorderSizePixel=0, Parent=Main,
NoxaUI.corner(TabBase, 18)
    local rail = NoxaUI.new("Frame", {
        Size=UDim2.new(0, 2, 1, -16),
        Position=UDim2.new(1, -1, 0, 8),
        BackgroundColor3=ACCENT,
        BackgroundTransparency=0.7,
        BorderSizePixel=0, Parent=TabBase,
    NoxaUI.regAccent(rail)
end

TabBar = NoxaUI.new("Frame", {
    Name="TabBar", ZIndex=12,
    Position=UDim2.new(0, 0, 0, 8),
    Size=UDim2.new(1, 0, 1, -16),
    BackgroundTransparency=1, Parent=TabBase,
local TabLayout = NoxaUI.new("UIListLayout", {
    FillDirection=Enum.FillDirection.Vertical,
    Padding=UDim.new(0, 40),
    HorizontalAlignment=Enum.HorizontalAlignment.Center,
    VerticalAlignment=Enum.VerticalAlignment.Top,
    SortOrder=Enum.SortOrder.LayoutOrder,
    Parent=TabBar,
tabHorizontal = false
local function tabBtnSize()
    return UDim2.new(1, -14, 0, 30)
end

TAB_DEFS = {
    {"Movement","MOVE",   1, true },
    {"Combat",  "FIGHT",  2, false},
    {"Utility", "FX",     3, false},
    {"Custom",  "CUSTOM", 4, false},
    {"Settings","CFG",    5, false},

local tabBtns = {}
local curTab  = "Movement"

local function buildTabBtn(def)
    local name,text,order,active = def[1],def[2],def[3],def[4]
    local btn = NoxaUI.new("TextButton", {
        Name=name, ZIndex=8, LayoutOrder=order,
        Size=tabBtnSize(),
        BackgroundColor3 = active and ACCENT or Color3.fromRGB(18, 22, 32),
        BackgroundTransparency = active and 0.12 or 0.45,
        Text=text,
        TextColor3 = active and Color3.fromRGB(6, 10, 12) or TEXT_DIM,
        TextSize=10,
        Font=Enum.Font.GothamBlack,
        TextWrapped=true,
        TextTruncate=Enum.TextTruncate.None,
        AutoButtonColor=false, Parent=TabBar,
    NoxaUI.corner(btn, 14)
    local s = NoxaUI.new("UIStroke", {
        Color = active and ACCENT or Color3.fromRGB(35, 45, 60),
        Thickness=1.1,
        Transparency = active and 0.2 or 0.65,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border, Parent=btn,
    local glow = NoxaUI.new("UIStroke", {
        Name="TabGlow", Color=ACCENT, Thickness=2,
        Transparency=active and 0.6 or 1,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border, Parent=btn,
    local ind = NoxaUI.new("Frame", {
        Name="TabInd",
        Size=UDim2.new(0, 3, 0.55, 0),
        Position=UDim2.new(0, 3, 0.5, 0),
        AnchorPoint=Vector2.new(0, 0.5),
        BackgroundColor3=ACCENT,
        BackgroundTransparency=active and 0 or 1,
        BorderSizePixel=0, ZIndex=9, Parent=btn,
    NoxaUI.corner(ind, 2)
    FX.ripple(btn)
    btn.MouseEnter:Connect(function()
        if curTab ~= name then
            NoxaUI.tw(btn, G.FAST, {TextColor3=TEXT_MAIN, BackgroundTransparency=0.25})
        end
    end)
    btn.MouseLeave:Connect(function()
        if curTab ~= name then
            NoxaUI.tw(btn, G.FAST, {TextColor3=TEXT_DIM, BackgroundTransparency=0.45})
        end
    end)
    tabBtns[name] = {btn=btn, stroke=s, glow=glow, ind=ind}
    return btn
end

for _, def in ipairs(TAB_DEFS) do buildTabBtn(def) end

function applyTabLayout(pos)
    SpeedSystem.tabPos = "Left"
    tabHorizontal = false
    TabBase.AnchorPoint = Vector2.new(0, 0)
    TabBase.Position = UDim2.new(0, 6, 0, 52)
    TabBase.Size = UDim2.new(0, TAB_W, 1, -60)
    TabBar.AnchorPoint = Vector2.new(0, 0)
    TabBar.Position = UDim2.new(0, 0, 0, 8)
    TabBar.Size = UDim2.new(1, 0, 1, -16)
    Content.Position = UDim2.new(0, 84, 0, 56)
    Content.Size = UDim2.new(1, -96, 1, -66)
    for _, td in pairs(tabBtns) do
        td.btn.Size = tabBtnSize()
    end
end

applyTabLayout("Left")

local function switchTab(name)
    if curTab==name then return end
    curTab=name
    for k,pg in pairs(allPages) do pg.Visible=(k==name) end
    for k,td in pairs(tabBtns) do
        local act=(k==name)
        NoxaUI.tw(td.btn, G.MED, {
            BackgroundTransparency = act and 0.12 or 0.45,
            BackgroundColor3 = act and ACCENT or Color3.fromRGB(18, 22, 32),
            TextColor3 = act and Color3.fromRGB(6, 10, 12) or TEXT_DIM,
        if td.stroke then
            NoxaUI.tw(td.stroke, G.MED, {
                Color = act and ACCENT or Color3.fromRGB(35, 45, 60),
                Transparency = act and 0.2 or 0.65,
        end
        if td.glow then NoxaUI.tw(td.glow, G.MED, {Transparency=act and 0.6 or 1}) end
        if td.ind then
            NoxaUI.tw(td.ind, G.FAST, {BackgroundTransparency = act and 0 or 1})
        end
    end
end

for k,td in pairs(tabBtns) do
    local name=k
    td.btn.MouseButton1Click:Connect(function() switchTab(name) end)
end

FloatOpen = NoxaUI.new("Frame", {
    Name="FloatOpen", Visible=false, Active=true, ZIndex=500,
    Position=UDim2.new(0,16,0.38,0),
    Size=UDim2.new(0,148,0,40),
    BackgroundColor3=Color3.fromRGB(10,14,18),
    BackgroundTransparency=0.04,
    BorderSizePixel=0, Parent=Gui,
NoxaUI.corner(FloatOpen, 12)
floatStroke = NoxaUI.new("UIStroke",{Color=Color3.fromRGB(70, 170, 255), Thickness=1.5, Transparency=0.25, Parent=FloatOpen})

FX.shadow(FloatOpen, 22, 0.45)
FloatTitle = NoxaUI.new("TextLabel", {
    Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1, RichText=true,
    Text='NOXA DUELS',
    TextColor3=Color3.fromRGB(70, 170, 255), TextSize=14,
    Font=Enum.Font.GothamBlack, Parent=FloatOpen,
FloatBtn = NoxaUI.new("TextButton", {
    ZIndex=501, Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1, Text="",
    AutoButtonColor=false, Parent=FloatOpen,
FX.ripple(FloatBtn)
local floatScale = Instance.new("UIScale")
floatScale.Name = "FloatScale"
floatScale.Scale = 1
floatScale.Parent = FloatOpen
FloatBtn.MouseButton1Down:Connect(function()

    NoxaUI.tw(FloatOpen, G.FAST, {Size=UDim2.new(0,114,0,32)})
end)
FloatBtn.MouseButton1Up:Connect(function()
    NoxaUI.tw(FloatOpen, G.BACK, {Size=UDim2.new(0,120,0,34)})
end)
    local g = NoxaUI.new("UIGradient", {
        Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(70, 170, 255)),
            ColorSequenceKeypoint.new(0.6, Color3.fromRGB(70, 170, 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(70, 170, 255)),
        Rotation=90, Parent=FloatTitle,
end

    local function makeDraggableAnywhere(target)
        if not target then return end
        pcall(function() target.Active = true end)
        local dragging, pending = false, false
        local dStart, tStart
        local THRESH = 6

        local function overTarget(pos)
            if not target or not target.Parent or not target.Visible then return false end
            local ap = target.AbsolutePosition
            local asz = target.AbsoluteSize
            return pos.X >= ap.X and pos.X <= ap.X + asz.X
               and pos.Y >= ap.Y and pos.Y <= ap.Y + asz.Y
        end

        UserInputService.InputBegan:Connect(function(i)
            if _G.NoxaKeyListening then return end
            if i.UserInputType ~= Enum.UserInputType.MouseButton1
            and i.UserInputType ~= Enum.UserInputType.Touch then return end
            local focused = UserInputService:GetFocusedTextBox()
            if focused then return end
            if not overTarget(i.Position) then return end
            pending = true
            dragging = false
            dStart = i.Position
            tStart = target.Position
        end)

        UserInputService.InputChanged:Connect(function(i)
            if not pending and not dragging then return end
            if i.UserInputType ~= Enum.UserInputType.MouseMovement
            and i.UserInputType ~= Enum.UserInputType.Touch then return end
            local d = i.Position - dStart
            if not dragging then
                if math.abs(d.X) < THRESH and math.abs(d.Y) < THRESH then return end
                dragging = true
                pending = false
            end
            if tStart then
                target.Position = UDim2.new(
                    tStart.X.Scale, tStart.X.Offset + d.X,
                    tStart.Y.Scale, tStart.Y.Offset + d.Y)
            end
        end)

        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                pending = false
            end
        end)
    end

    makeDraggableAnywhere(MainClip)
    makeDraggableAnywhere(FloatOpen)

    NoxaCfg.registerConfigExtra("mainPosition", function() return MainClip.Position end,
        function(v) if typeof(v) == "UDim2" then MainClip.Position = v end end)
    NoxaCfg.registerConfigExtra("floatPosition", function() return FloatOpen.Position end,
        function(v) if typeof(v) == "UDim2" then FloatOpen.Position = v end end)
end

NotifFrame = NoxaUI.new("Frame", {
    ZIndex=600,
    Position=UDim2.new(1,-264,1,-400),
    Size=UDim2.new(0,252,0,384),
    BackgroundTransparency=1, Parent=Gui,
NoxaUI.new("UIListLayout", {
    Padding=UDim.new(0,8),
    VerticalAlignment=Enum.VerticalAlignment.Bottom,
    SortOrder=Enum.SortOrder.LayoutOrder,
    Parent=NotifFrame,

local function notify(text, dur)
    dur=dur or 3
    local n=NoxaUI.new("Frame", {
        ZIndex=601, Size=UDim2.new(1,0,0,36),
        BackgroundColor3=Color3.fromRGB(12,12,20),
        BackgroundTransparency=0.05, BorderSizePixel=0,
        Parent=NotifFrame,
    NoxaUI.corner(n, 10)
        local edge = NoxaUI.new("Frame", {
            Position=UDim2.new(0,0,0,6), Size=UDim2.new(0,3,1,-12),
            BackgroundColor3=Color3.fromRGB(70, 170, 255), BorderSizePixel=0, ZIndex=605, Parent=n,
        NoxaUI.corner(edge, 2)
        NoxaUI.new("UIGradient", {Color=FX.SEQ, Rotation=90, Parent=edge})
        FX.shadow(n, 16, 0.5)
    end
    local ns=NoxaUI.new("UIStroke",{Color=Color3.fromRGB(70, 170, 255), Thickness=0, Transparency=1, Parent=n})
    local nl=NoxaUI.new("TextLabel", {
        ZIndex=602, Position=UDim2.new(0,10,0,0),
        Size=UDim2.new(1,-14,1,0),
        BackgroundTransparency=1, Text=text,
        TextColor3=TEXT_MAIN, TextSize=11,
        Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left, Parent=n,
    task.delay(dur, function()
        NoxaUI.tw(n,  TweenInfo.new(0.4),{BackgroundTransparency=1})
        NoxaUI.tw(nl, TweenInfo.new(0.4),{TextTransparency=1})
        NoxaUI.tw(ns, TweenInfo.new(0.4),{Transparency=1})
        task.delay(0.45, function() n:Destroy() end)
    end)
end

local function openMain()
    FloatOpen.Visible = false
    MainClip.Visible = true
    SpeedSystem.menuOpen = true
    local sc = MainClip:FindFirstChildOfClass("UIScale")
    local target = tonumber(SpeedSystem.uiScale) or 0.75
    if sc then
        sc.Scale = math.max(0.45, target * 0.88)
        TweenService:Create(sc, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = target}):Play()
    end
    MainClip.BackgroundTransparency = 1
    Main.BackgroundTransparency = 1
    NoxaUI.tw(MainClip, G.MED, {BackgroundTransparency = 0})
    NoxaUI.tw(Main, G.MED, {BackgroundTransparency = 0})

    if floatScale then floatScale.Scale = 1 end
end

local function closeMain()
    SpeedSystem.menuOpen = false
    local sc = MainClip:FindFirstChildOfClass("UIScale")
    if sc then
        TweenService:Create(sc, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Scale = math.max(0.4, (tonumber(SpeedSystem.uiScale) or 0.75) * 0.9)
        }):Play()
    end
    NoxaUI.tw(MainClip, G.FAST, {BackgroundTransparency = 1})
    NoxaUI.tw(Main, G.FAST, {BackgroundTransparency = 1})
    task.delay(0.2, function()
        MainClip.Visible = false
        FloatOpen.Visible = true
        if floatScale then
            floatScale.Scale = 0.85
            TweenService:Create(floatScale, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        end
        FloatOpen.BackgroundTransparency = 1
        TweenService:Create(FloatOpen, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundTransparency = 0.06}):Play()
    end)
end

CloseBtn.MouseButton1Click:Connect(closeMain)
FloatBtn.MouseButton1Click:Connect(openMain)

local introSkipped=true
_G._NoxaIntroHidingUI = false

local function skipIntro()
    introSkipped = true
    _G._NoxaIntroHidingUI = false
    pcall(function()
        if Intro then Intro.Visible = false end
    end)
    pcall(function()
        if type(openMain) == "function" then openMain() end
    end)
end

local function startNoxaIntro()
    skipIntro()
end
_G.NoxaStartIntro = startNoxaIntro
_G.NoxaSkipIntro = skipIntro

    local bbSpeedLabel = nil
    local _rtTimerActive = false
    local _rtTimerToken = 0

    local function isLocalRagdolled(hum)
        if not hum then return false end
        local st = hum:GetState()
        return st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown
            or hum.PlatformStand == true
    end

    local function getNoxaRagTimerLbl()
        local char = LP.Character
        if not char then return nil end
        local head = char:FindFirstChild("Head")
        if not head then return nil end
        local bb = head:FindFirstChild("NoxaSpeedBB")
        if not bb then return nil end
        return bb:FindFirstChild("RagTimer")
    end

    local function startNoxaRagTimerGui()
        if _rtTimerActive then return end
        _rtTimerActive = true
        _rtTimerToken = _rtTimerToken + 1
        local token = _rtTimerToken
        task.spawn(function()
            local t = 3.0
            while t >= 0 and token == _rtTimerToken do
                local lbl = getNoxaRagTimerLbl()
                if lbl then
                    lbl.Visible = true
                    lbl.Text = string.format("%.1f", t)
                    local accent = (typeof(ACCENT) == "Color3" and ACCENT) or Color3.fromRGB(70, 170, 255)
                    if t <= 1.0 then
                        lbl.TextColor3 = Color3.fromRGB(255, 90, 90)
                    else
                        lbl.TextColor3 = accent
                    end
                end
                task.wait(0.1)
                t = math.floor(((t - 0.1) * 10) + 0.5) / 10
            end
            if token ~= _rtTimerToken then
                _rtTimerActive = false
                return
            end
            local lbl = getNoxaRagTimerLbl()
            if lbl then
                lbl.Visible = true
                lbl.Text = "STEAL!"
                local accentLight = (typeof(ACCENT) == "Color3" and ACCENT) or Color3.fromRGB(120, 190, 255)
                lbl.TextColor3 = accentLight
            end
            repeat
                task.wait(0.1)
                if token ~= _rtTimerToken then break end
                local c = LP.Character
                if not hum or not isLocalRagdolled(hum) then break end
            until false
            if token == _rtTimerToken then
                local lbl2 = getNoxaRagTimerLbl()
                if lbl2 then
                    lbl2.Text = ""
                    lbl2.Visible = false
                end
                _rtTimerActive = false
            end
        end)
    end

    local function setupSpeedBillboard(char)
        local head = char:WaitForChild("Head", 5)
        local hrp  = char:FindFirstChild("HumanoidRootPart")
        if not head then return end

        local old = head:FindFirstChild("NoxaSpeedBB")
        if old then old:Destroy() end

        local oldRag = head:FindFirstChild("NoxaRagdollBB")
        if oldRag then oldRag:Destroy() end

        _rtTimerActive = false
        _rtTimerToken = _rtTimerToken + 1

        local bb = Instance.new("BillboardGui")
        bb.Name           = "NoxaSpeedBB"
        bb.Size           = UDim2.new(0, 190, 0, 100)
        bb.StudsOffset    = Vector3.new(0, 3.2, 0)
        bb.AlwaysOnTop    = true
        bb.LightInfluence = 0
        bb.Parent         = head

        local speedLbl = Instance.new("TextLabel", bb)
        speedLbl.Size                 = UDim2.new(1, 0, 0, 24)
        speedLbl.Position             = UDim2.new(0, 0, 0, 2)
        speedLbl.BackgroundTransparency = 1
        speedLbl.Text                 = "NORMAL: 60"
        speedLbl.TextColor3           = Color3.fromRGB(70, 170, 255)
        speedLbl.Font                 = Enum.Font.GothamBlack
        speedLbl.TextScaled           = true
        speedLbl.TextStrokeTransparency = 0
        speedLbl.TextStrokeColor3     = Color3.fromRGB(0, 0, 0)

        local ul = Instance.new("Frame", bb)
        ul.Size             = UDim2.new(0.7, 0, 0, 2)
        ul.Position         = UDim2.new(0.15, 0, 0, 28)
        ul.BackgroundColor3 = Color3.fromRGB(70, 170, 255)
        ul.BorderSizePixel  = 0
        Instance.new("UICorner", ul).CornerRadius = UDim.new(1, 0)

        local dcLbl = Instance.new("TextLabel", bb)
        dcLbl.Size                 = UDim2.new(1, 0, 0, 20)
        dcLbl.Position             = UDim2.new(0, 0, 0, 34)
        dcLbl.BackgroundTransparency = 1
        dcLbl.Text                 = "https://discord.gg/TBBAUZu8cW"
        dcLbl.TextColor3           = Color3.fromRGB(70, 170, 255)
        dcLbl.Font                 = Enum.Font.GothamBlack
        dcLbl.TextScaled           = true
        dcLbl.TextStrokeTransparency = 0
        dcLbl.TextStrokeColor3     = Color3.fromRGB(0, 0, 0)

        local ragLbl = Instance.new("TextLabel", bb)
        ragLbl.Name                 = "RagTimer"
        ragLbl.Size                 = UDim2.new(1, 0, 0, 28)
        ragLbl.Position             = UDim2.new(0, 0, 0, 56)
        ragLbl.BackgroundTransparency = 1
        ragLbl.Text                 = ""
        ragLbl.TextColor3           = Color3.fromRGB(70, 170, 255)
        ragLbl.Font                 = Enum.Font.GothamBlack
        ragLbl.TextScaled           = true
        ragLbl.TextStrokeTransparency = 0.1
        ragLbl.TextStrokeColor3     = Color3.fromRGB(0, 0, 0)
        ragLbl.Visible              = false

        bbSpeedLabel = speedLbl

        _G.NoxaBillboard = {dc = dcLbl, speed = speedLbl, ul = ul, rag = ragLbl}
        pcall(function()
            dcLbl.TextColor3 = ACCENT
            speedLbl.TextColor3 = ACCENT
            ul.BackgroundColor3 = ACCENT
            ragLbl.TextColor3 = ACCENT
        end)

        task.spawn(function()
            local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
            if not hum then return end
            if _G._NoxaRagTimerConn then pcall(function() _G._NoxaRagTimerConn:Disconnect() end) end
            local _ragAcc = 0
            _G._NoxaRagTimerConn = _G._NoxaTrackConn(RunService.Heartbeat:Connect(function(dt)
                if not char.Parent or not hum.Parent then
                    if _G._NoxaRagTimerConn then pcall(function() _G._NoxaRagTimerConn:Disconnect() end) end
                    _G._NoxaRagTimerConn = nil
                    return
                end
                _ragAcc = _ragAcc + (dt or 0.016)
                if _ragAcc < 0.15 then return end
                _ragAcc = 0
                if isLocalRagdolled(hum) then
                    startNoxaRagTimerGui()
                end
            end))
        end)

        task.spawn(function()
            while speedLbl and speedLbl.Parent do
                local c = LP.Character
                if root then
                    hrp = root
                    local mode = SpeedSystem:getModeLabel(hum)
                    local activeSpeed = SpeedSystem:getActiveSpeed(hum)
                    speedLbl.Text = string.format("%s: %d", mode, math.floor(tonumber(activeSpeed) or 0))
                end
                task.wait(0.1)
            end
        end)
    end

    LP.CharacterAdded:Connect(function(char)
        task.wait(0.3)
        setupSpeedBillboard(char)
    end)
    if LP.Character then
        task.spawn(function()
            task.wait(0.3)
            setupSpeedBillboard(LP.Character)
        end)
    end
end

speedConn = nil
lastMoveDir = Vector3.new(0, 0, 0)

local function isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand or st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.FallingDown
end

pcall(function() if SleepOverlay then SleepOverlay.Visible = false end end)

function SpeedSystem:startSpeedLoop()
    if self._speedConn then
        pcall(function() self._speedConn:Disconnect() end)
        self._speedConn = nil
    end

    self._s2VelChecked = self._s2VelChecked or {}
    self._s2HookedVelParts = self._s2HookedVelParts or {}
    self._s2LastMoveDir = self._s2LastMoveDir or Vector3.zero
    local MOVE_KEYS = {
        [Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true,
        [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,

    local function setupVelChecked(char)
        self._s2VelChecked = {}
        if not char then return nil end
        local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
        if hrp then self._s2VelChecked[hrp] = true end
        return hrp
    end

    local function hookVelHRP(hrp)
        if not hrp or self._s2HookedVelParts[hrp] then return end
        if type(getrawmetatable) ~= "function" or type(newcclosure) ~= "function" then return end
        self._s2HookedVelParts[hrp] = true
        local ok = pcall(function()
            local mt = getrawmetatable(hrp)
            if not mt then return end
            setreadonly(mt, false)
            local originalVelIndex = rawget(mt, "__index")
            mt.__index = newcclosure(function(selfPart, key)
                if not checkcaller() and self._s2VelChecked[selfPart] and (key == "AssemblyLinearVelocity" or key == "Velocity") then
                    local real
                    if type(originalVelIndex) == "function" then
                        real = originalVelIndex(selfPart, key)
                    elseif type(originalVelIndex) == "table" then
                        real = originalVelIndex[key]
                    end
                    if typeof(real) == "Vector3" and real.Magnitude > 20 then
                        return real.Unit * 20
                    end
                    return real
                end
                if type(originalVelIndex) == "function" then
                    return originalVelIndex(selfPart, key)
                elseif type(originalVelIndex) == "table" then
                    return originalVelIndex[key]
                end
            end)
            setreadonly(mt, true)
        end)
        if not ok then
            self._s2HookedVelParts[hrp] = nil
        end
    end

    local function hookCurrentChar()
        local char = LP.Character
        if not char then return end
        local hrp = setupVelChecked(char)
        hookVelHRP(hrp)
    end

    pcall(hookCurrentChar)
    if not self._s2CharHook then
        self._s2CharHook = LP.CharacterAdded:Connect(function(char)
            self._s2HookedVelParts = {}
            task.defer(function()
                local hrp = setupVelChecked(char)
                hookVelHRP(hrp)
            end)
        end)
        pcall(function()
            _G._NoxaRSConns = _G._NoxaRSConns or {}
            table.insert(_G._NoxaRSConns, self._s2CharHook)
        end)
    end

    pcall(function()
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local lv = hrp:FindFirstChild("NoxaSpeedLV")
            if lv then lv:Destroy() end
            local att = hrp:FindFirstChild("NoxaSpeedAtt")
            if att then att:Destroy() end
        end
    end)

    if _G._NoxaSpeedConn then pcall(function() _G._NoxaSpeedConn:Disconnect() end) end
    self._speedConn = _G._NoxaTrackConn(RunService.RenderStepped:Connect(function()
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end

        local batOn = false
        pcall(function()
            if BatAimbot and BatAimbot.enabled then batOn = true end
            if _G.NoxaBatAimbot and _G.NoxaBatAimbot.enabled then batOn = true end
            if NoxaMods and NoxaMods.BatAimbotRef and NoxaMods.BatAimbotRef.enabled then batOn = true end
        end)
        if batOn then
            self._s2LastMoveDir = Vector3.zero
            return
        end
        if self.antiDesyncAimbotEnabled then
            self._s2LastMoveDir = Vector3.zero
            return
        end
        if self._dropBrainrotActive or self._tpDownActive then
            self._s2LastMoveDir = Vector3.zero
            return
        end

        local st = hum:GetState()
        if hum.PlatformStand
            or st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown then
            self._s2LastMoveDir = Vector3.zero
            return
        end

        local spd = self:getActiveSpeed(hum)
        local md = hum.MoveDirection
        local dir = nil
        if md.Magnitude > 0 then
            self._s2LastMoveDir = md
            dir = md
        elseif self._s2LastMoveDir.Magnitude > 0 then
            for key in pairs(MOVE_KEYS) do
                if UserInputService:IsKeyDown(key) then
                    dir = self._s2LastMoveDir
                    break
                end
            end
        end

        if dir and dir.Magnitude > 0.05 then
            pcall(function()
                if hrp.SetNetworkOwner then hrp:SetNetworkOwner(LP) end
            end)
            local unit = dir.Unit
            hrp.AssemblyLinearVelocity = Vector3.new(unit.X * spd, hrp.AssemblyLinearVelocity.Y, unit.Z * spd)
        else
            hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
        end
    end))
    _G._NoxaSpeedConn = self._speedConn
end

    local _lastTpDown = 0
    local _tpAcc = 0
    if _G._NoxaAutoTpDownConn then pcall(function() _G._NoxaAutoTpDownConn:Disconnect() end) end
    _G._NoxaAutoTpDownConn = _G._NoxaTrackConn(RunService.Heartbeat:Connect(function(dt)
        if not SpeedSystem.autoTpDownEnabled then return end
        _tpAcc = _tpAcc + (dt or 0.016)
        if _tpAcc < 0.2 then return end
        _tpAcc = 0
        if tick() - _lastTpDown < 0.55 then return end
        if SpeedSystem._tpDownActive or SpeedSystem._dropBrainrotActive then return end
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end
        local minH = tonumber(SpeedSystem.autoTpDownHeight) or 12
        local should = false

        local rp = RaycastParams.new()
        rp.FilterDescendantsInstances = {char}
        rp.FilterType = Enum.RaycastFilterType.Exclude
        local ray = workspace:Raycast(hrp.Position, Vector3.new(0, -120, 0), rp)
        if ray then
            if (hrp.Position.Y - ray.Position.Y) > minH then should = true end
        else

            if hrp.Position.Y > (minH + 2) then should = true end
        end

        if not should then
            local st = hum:GetState()
            if st == Enum.HumanoidStateType.Freefall or st == Enum.HumanoidStateType.Jumping then
                if hrp.Position.Y > minH then should = true end
            end
        end
        if should then
            _lastTpDown = tick()
            pcall(function() SpeedSystem:runTPDown() end)
        end
    end))
end

local function isBindInput(input)
    return noxaIsBindableKey(input) == true
end

local _noxaKeyDebounce = {}
local function noxaKeyReady(id, cd)
    cd = cd or 0.12
    local now = tick()
    if (_noxaKeyDebounce[id] or 0) > now then return false end
    _noxaKeyDebounce[id] = now + cd
    return true
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if _G.NoxaKeyListening then return end
    if not isBindInput(input) then return end
    local isPad = input.UserInputType == Enum.UserInputType.Gamepad1
        or input.UserInputType == Enum.UserInputType.Gamepad2
        or input.UserInputType == Enum.UserInputType.Gamepad3
        or input.UserInputType == Enum.UserInputType.Gamepad4
    if gameProcessed and not isPad then return end
    local key = input.KeyCode
    if key == Enum.KeyCode.Unknown then return end
    local binds = SpeedSystem.keybinds or {}

    if binds.Carry and key == binds.Carry then
        if noxaKeyReady("Carry") then
            SpeedSystem:toggleCarry()
            NoxaCfg.saveConfig()
        end
        return
    end

    if binds.Lagger and key == binds.Lagger then
        if noxaKeyReady("Lagger") then
            SpeedSystem:toggleLagger()
            NoxaCfg.saveConfig()
        end
        return
    end

    if SpeedSystem.autoDodgeKeybind and key == SpeedSystem.autoDodgeKeybind then
        if noxaKeyReady("AutoDodge") then
            local on = SpeedSystem:toggleAutoDodge()
            pcall(function()
                if _G.NoxaAutoDodgeRow and ToggleStates then
                    ToggleStates[_G.NoxaAutoDodgeRow] = on
                    local area = _G.NoxaAutoDodgeRow:FindFirstChild("ToggleArea")
                    local track = area and area:FindFirstChildWhichIsA("Frame")
                    local knob = track and track:FindFirstChildWhichIsA("Frame")
                    if track and knob and NoxaUI.setToggleVisual then
                        NoxaUI.setToggleVisual(track, knob, on)
                    end
                end
            end)
            NoxaCfg.saveConfig()
        end
        return
    end

    if SpeedSystem.dropBrainrotKeybind and key == SpeedSystem.dropBrainrotKeybind then
        if noxaKeyReady("DropBR") then
            SpeedSystem:runDropBrainrot()
        end
        return
    end

    if SpeedSystem.tpDownKeybind and key == SpeedSystem.tpDownKeybind then
        if noxaKeyReady("TPDown") then
            SpeedSystem:runTPDown()
        end
        return
    end

    if SpeedSystem.instantResetKeybind and key == SpeedSystem.instantResetKeybind then
        if noxaKeyReady("InstaReset") then
            SpeedSystem:runInstantReset()
        end
        return
    end

    if binds.TPBat and key == binds.TPBat then
        if noxaKeyReady("TPBat") then
            SpeedSystem.antiDesyncAimbotEnabled = not SpeedSystem.antiDesyncAimbotEnabled
            if SpeedSystem.antiDesyncAimbotEnabled then
                SpeedSystem:startAntiDesyncAimbot()
            else
                SpeedSystem:stopAntiDesyncAimbot()
            end
            SpeedSystem:updateUI()
            NoxaCfg.saveConfig()
        end
        return
    end
end)

carryToggleRow = carryRow
laggerToggleRow = laggerRow
antiDesyncToggleRow = nil

for _, child in ipairs(P_COMBAT:GetChildren()) do
    if child:IsA("Frame") and child:FindFirstChild("TextLabel") then
        local label = child:FindFirstChild("TextLabel")
        if label and label.Text and label.Text:match("TP Bat") then
            antiDesyncToggleRow = child
            break
        end
    end
end

local function syncToggleRow(row, state)
    if not row then return end
    ToggleStates[row] = state and true or false
    local area = row:FindFirstChild("ToggleArea")
    if not area then return end
    local track = area:FindFirstChildWhichIsA("Frame")
    if not track then return end
    local knob = track:FindFirstChildWhichIsA("Frame")
    if knob then NoxaUI.setToggleVisual(track, knob, state and true or false) end
end

function refreshUIFromConfig()

    if nsBox then nsBox.Text = tostring(SpeedSystem.NS) end
    if csBox then csBox.Text = tostring(SpeedSystem.CS) end
    if lsBox then lsBox.Text = tostring(SpeedSystem.LAGGER_NORMAL) end
    if lcBox then lcBox.Text = tostring(SpeedSystem.LAGGER_CARRY) end

    pcall(function()
        if carryKeyBtn and SpeedSystem.keybinds and SpeedSystem.keybinds.Carry then
            carryKeyBtn.Text = SpeedSystem.keybinds.Carry.Name
        end
        if laggerKeyBtn and SpeedSystem.keybinds and SpeedSystem.keybinds.Lagger then
            laggerKeyBtn.Text = SpeedSystem.keybinds.Lagger.Name
        end
    end)

    syncToggleRow(autoCarryRow,  SpeedSystem.autoCarryEnabled)
    syncToggleRow(infJumpRow,    SpeedSystem.infJumpEnabled)
    syncToggleRow(antiRagRow,    SpeedSystem.antiRagdollEnabled)

    pcall(function()
        local m = SpeedSystem.infJumpMode
        if m ~= "manual" and m ~= "hold" then
            SpeedSystem.infJumpMode = (tostring(m):lower() == "manual" or tostring(m):lower() == "tap") and "manual" or "hold"
        end
        if _G.NoxaSetInfJumpModeUI then
            _G.NoxaSetInfJumpModeUI(SpeedSystem.infJumpMode == "manual" and "manual" or "hold")
        end
        SpeedSystem:setInfJumpEnabled(SpeedSystem.infJumpEnabled == true)
    end)

    pcall(function()
        if _G.NoxaSetCarryRadio then _G.NoxaSetCarryRadio(SpeedSystem.carryActive == true) end
        if _G.NoxaSetLaggerRadio then _G.NoxaSetLaggerRadio(SpeedSystem.laggerActive == true) end
        if _G.NoxaSpeedMethodSet then
            _G.NoxaSpeedMethodSet((SpeedSystem.speedMethod == "V2") and 2 or 1)
        end
    end)

    pcall(function()
        local function short(kc)
            if typeof(kc) ~= "EnumItem" then return "-" end
            return kc.Name
        end
        if dropKeyBtn then dropKeyBtn.Text = short(SpeedSystem.dropBrainrotKeybind) end
        if tpDownKeyBtn then tpDownKeyBtn.Text = short(SpeedSystem.tpDownKeybind) end
        if resetKeyBtn then resetKeyBtn.Text = short(SpeedSystem.instantResetKeybind) end
    end)

    syncToggleRow(batCounterRow,     NoxaMods.batCounterEnabled)
    syncToggleRow(medusaCounterRow,  NoxaMods.medusaCounterEnabled)
    syncToggleRow(grabRow,           SpeedSystem.autoStealEnabled)
    syncToggleRow(batAimbotRow,      BatAimbot.enabled)
    syncToggleRow(antiDesyncRow,     SpeedSystem.antiDesyncAimbotEnabled)

        local ui = _G.NoxaBatAimbotUI
        if ui then
            if ui.speedBox then
                ui.speedBox.Text = tostring(BatAimbot.speed or 58)
            end

            if ui.autoSwingRow then
                syncToggleRow(ui.autoSwingRow, SpeedSystem.antiDesyncAutoSwingEnabled)
            end
        end
        local ver = BatAimbot.version or "V2"
        if ver ~= "V2" and ver ~= "V3" then ver = "V2" end
        BatAimbot.version = ver
        pcall(function()
            if _G.NoxaSetBatModeUI then _G.NoxaSetBatModeUI(ver) end
        end)
    end

    pcall(function()
        if _G.NoxaSetBatCounterModeUI then
            _G.NoxaSetBatCounterModeUI(NoxaMods.batCounterMode or "V1")
        end
    end)

    syncToggleRow(antiLagRow,  NoxaMods.antiLagEnabled)
    syncToggleRow(nukeOptRow,  NoxaMods.nukeEnabled)
    if _G.NoxaStretchRow then syncToggleRow(_G.NoxaStretchRow, SpeedSystem.NoxaVisual.stretchResEnabled) end
    if _G.NoxaRemoveAccRow then syncToggleRow(_G.NoxaRemoveAccRow, SpeedSystem.removeAccessoriesEnabled) end

    pcall(function()
        NoxaESP._disabled = true
        NoxaESP.boxEnabled = false
        NoxaESP.tracerEnabled = false
        NoxaESP.highlightEnabled = false
        NoxaESP.userESPEnabled = false
        NoxaESP.ragdollTimer = false
        NoxaESP.ragdollNotify = false
        if NoxaESP.setBox then NoxaESP:setBox(false) end
        if NoxaESP.setTracer then NoxaESP:setTracer(false) end
        if NoxaESP.setHighlight then NoxaESP:setHighlight(false) end
        if NoxaESP.setUserESP then NoxaESP:setUserESP(false) end
        if NoxaESP.setRagdollTimer then NoxaESP:setRagdollTimer(false) end
        if NoxaESP.setRagdollNotify then NoxaESP:setRagdollNotify(false) end

        local oldDraw = PlayerGui:FindFirstChild("NoxaEspDraw")
        if oldDraw then oldDraw:Destroy() end
        local cg = game:GetService("CoreGui")
        local oldDraw2 = cg:FindFirstChild("NoxaEspDraw")
        if oldDraw2 then oldDraw2:Destroy() end
    end)

        local antiOn = (SpeedSystem.antiDieEnabled == true)
            or (_G.NoxaAntiDie and _G.NoxaAntiDie.enabled == true)
        if _G.NoxaAntiDieRow then syncToggleRow(_G.NoxaAntiDieRow, antiOn) end

        if _G.NoxaAntiDie then
            if antiOn then

                pcall(function()
                    _G.NoxaAntiDie.enabled = false
                    _G.NoxaAntiDie:disable()
                    _G.NoxaAntiDie:enable()
                end)
                SpeedSystem.antiDieEnabled = true
            else
                pcall(function() _G.NoxaAntiDie:disable() end)
                SpeedSystem.antiDieEnabled = false
            end
        end

        SpeedSystem.bodyLockEnabled = false
        pcall(function() if _G.NoxaBodyLock then _G.NoxaBodyLock:disable() end end)

        pcall(function()
            local on = SpeedSystem.noPlayerCollisionEnabled == true
            if _G.NoxaNoPlayerCollisionRow then
                ToggleStates[_G.NoxaNoPlayerCollisionRow] = on
                local area = _G.NoxaNoPlayerCollisionRow:FindFirstChild("ToggleArea")
                local track = area and area:FindFirstChildWhichIsA("Frame")
                local knob = track and track:FindFirstChildWhichIsA("Frame")
                if track and knob and NoxaUI.setToggleVisual then
                    NoxaUI.setToggleVisual(track, knob, on)
                end
            end
            if on and _G.NoxaEnableNoPlayerCollision then
                _G.NoxaEnableNoPlayerCollision()
            elseif (not on) and _G.NoxaDisableNoPlayerCollision then
                _G.NoxaDisableNoPlayerCollision()
            end
        end)

        local onDeath = SpeedSystem.instaResetOnDeathEnabled == true
        if _G.NoxaInstaResetOnDeathRow then syncToggleRow(_G.NoxaInstaResetOnDeathRow, onDeath) end
        pcall(function()
            if onDeath then
                SpeedSystem:startInstaResetOnDeath()
            else
                SpeedSystem:stopInstaResetOnDeath()
                SpeedSystem.instaResetOnDeathEnabled = false
            end
        end)
    end

    if _G.NoxaHeadlessRow then syncToggleRow(_G.NoxaHeadlessRow, SpeedSystem.NoxaChar.headlessEnabled) end
    if _G.NoxaKorbloxRow then syncToggleRow(_G.NoxaKorbloxRow, SpeedSystem.NoxaChar.korbloxEnabled) end

    SpeedSystem.bodyLockEnabled = false
    pcall(function() if _G.NoxaBodyLock then _G.NoxaBodyLock:disable() end end)
    if _G.NoxaBgImageRow then syncToggleRow(_G.NoxaBgImageRow, SpeedSystem.bgImageEnabled ~= false) end
    if BgAsset then
        BgAsset.Visible = SpeedSystem.bgImageEnabled ~= false
        BgAsset.ImageTransparency = SpeedSystem.bgImageTransparency or 0.05

        pcall(function()
            if type(_G.NoxaApplyBgImage) == "function" then
                _G.NoxaApplyBgImage(SpeedSystem.bgImageIndex or 1)
            elseif _G.NoxaBgImages then
                local img = _G.NoxaBgImages[tonumber(SpeedSystem.bgImageIndex) or 1]
                if img then BgAsset.Image = img end
            end
        end)
    end

    if _G.NoxaFOV and _G.NoxaFOV.apply then
        local fv = SpeedSystem.fov or 70
        if _G.NoxaFOV.setIdx and _G.NoxaFOV.options then
            local fi = 1
            for i, v in ipairs(_G.NoxaFOV.options) do
                if v == fv then fi = i break end
            end
            pcall(_G.NoxaFOV.setIdx, fi)
        end
        if fv ~= 70 then _G.NoxaFOV.apply(fv) end
    end

    if SpeedSystem.NoxaVisual and SpeedSystem.NoxaVisual.setStretchRes then
        SpeedSystem.NoxaVisual:setStretchRes(SpeedSystem.NoxaVisual.stretchResEnabled == true)
    end
    if SpeedSystem.NoxaChar and SpeedSystem.NoxaChar.applyAll and LP.Character then
        pcall(SpeedSystem.NoxaChar.applyAll, LP.Character)
    end

    if type(_G.NoxaApplyUIScale) == "function" then
        pcall(_G.NoxaApplyUIScale, SpeedSystem.uiScale or 0.75)
    elseif MainUIScale then
        MainUIScale.Scale = tonumber(SpeedSystem.uiScale) or 0.75
    end

    if stealProgressBar then
        stealProgressBar.Visible = (SpeedSystem.stealBarStyle ~= "V1")
    end

    if SpeedSystem.tabPos then
        applyTabLayout(SpeedSystem.tabPos)
    end

    updateModeVisual()

    SpeedSystem:setInfJumpEnabled(SpeedSystem.infJumpEnabled)
    SpeedSystem:setAntiRagdoll(SpeedSystem.antiRagdollEnabled)

    if SpeedSystem.antiDesyncAimbotEnabled then
        SpeedSystem:startAntiDesyncAimbot()
    end

    pcall(function()
        local style = SpeedSystem.stealBarStyle or "V1"
        if applyStealBarStyle then applyStealBarStyle(style) end
        if ensureStealBarRefs then ensureStealBarRefs() end
        if stealProgressBar then
            stealProgressBar.Visible = (SpeedSystem.stealBarStyle ~= "V1")
        end
        if setBarState then setBarState("IDLE") end
        if updateModeVisual then updateModeVisual() end
    end)
    if SpeedSystem.autoStealEnabled then
        pcall(function()
            if stopAutoSteal then stopAutoSteal() end
        end)
        startAutoSteal()
    end

    pcall(function()
        if NoxaMods.setAntiLag then
            NoxaMods:setAntiLag(NoxaMods.antiLagEnabled == true)
        elseif NoxaMods.antiLagEnabled then
            NoxaMods:enableAntiLag()
        end
    end)
    pcall(function()
        if NoxaMods.setNukeOptimizer then
            NoxaMods:setNukeOptimizer(NoxaMods.nukeEnabled == true)
        elseif NoxaMods.nukeEnabled and _G._nukeStart then
            _G._nukeStart()
        end
    end)
    if NoxaMods.batCounterEnabled then NoxaMods:startBatCounter() end
    if NoxaMods.medusaCounterEnabled then NoxaMods:setupMedusaCounter(LP.Character) end
    if BatAimbot.enabled then
        local startFn = (NoxaMods and NoxaMods._batAimbotStart) or _G._batStart
        if type(startFn) == "function" then pcall(startFn) end
    end

    SpeedSystem:updateUI()
end

SpeedSystem.onUIUpdate = function()

    pcall(function()
        if _G.NoxaSetCarryRadio then _G.NoxaSetCarryRadio(SpeedSystem.carryActive == true) end
        if _G.NoxaSetLaggerRadio then _G.NoxaSetLaggerRadio(SpeedSystem.laggerActive == true) end
    end)
    if antiDesyncToggleRow then
        local area = antiDesyncToggleRow:FindFirstChild("ToggleArea")
        local track = area and area:FindFirstChild("Frame")
        local knob = track and track:FindFirstChild("Frame")
        if track and knob then
            NoxaUI.setToggleVisual(track, knob, SpeedSystem.antiDesyncAimbotEnabled)
        end
    end
end

if nsBox then
    nsBox.FocusLost:Connect(function()
        local n = tonumber(nsBox.Text)
        if n and n >= 1 and n <= 500 then
            SpeedSystem.NS = n
            NoxaCfg.saveConfig()
        else
            nsBox.Text = tostring(SpeedSystem.NS)
        end
    end)
end

if csBox then
    csBox.FocusLost:Connect(function()
        local n = tonumber(csBox.Text)
        if n and n >= 1 and n <= 500 then
            SpeedSystem.CS = n
            NoxaCfg.saveConfig()
        else
            csBox.Text = tostring(SpeedSystem.CS)
        end
    end)
end

if lsBox then
    lsBox.FocusLost:Connect(function()
        local n = tonumber(lsBox.Text)
        if n and n >= 1 and n <= 500 then
            SpeedSystem.LAGGER_NORMAL = n
            NoxaCfg.saveConfig()
        else
            lsBox.Text = tostring(SpeedSystem.LAGGER_NORMAL)
        end
    end)
end

if lcBox then
    lcBox.FocusLost:Connect(function()
        local n = tonumber(lcBox.Text)
        if n and n >= 1 and n <= 500 then
            SpeedSystem.LAGGER_CARRY = n
            NoxaCfg.saveConfig()
        else
            lcBox.Text = tostring(SpeedSystem.LAGGER_CARRY)
        end
    end)
end

pcall(function()
    NoxaCfg.registerConfigExtra("introEnabled",
        function() return false end,
        function(v) SpeedSystem.introEnabled = false end)
    NoxaCfg.registerConfigExtra("introColorLocked",
        function() return SpeedSystem.introColorLocked == true end,
        function(v) SpeedSystem.introColorLocked = v == true end)
    NoxaCfg.registerConfigExtra("autoPlayMode",
        function() return SpeedSystem.autoPlayMode or "2btn" end,
        function(v) if v == "1btn" or v == "2btn" then SpeedSystem.autoPlayMode = v end end)
    NoxaCfg.registerConfigExtra("mobileButtons",
        function() return SpeedSystem.mobileButtons end,
        function(v)
            if type(v) == "table" then
                for k, val in pairs(v) do SpeedSystem.mobileButtons[k] = val end
            end
        end)
    NoxaCfg.registerConfigExtra("batCounterMode",
        function() return NoxaMods.batCounterMode or "V1" end,
        function(v)
            if type(v) == "string" and (v == "OLD" or v == "NEW" or v == "V1" or v == "V2" or v == "V3") then
                NoxaMods.batCounterMode = v
            end
        end)
    NoxaCfg.registerConfigExtra("batCounterEnabled",
        function() return NoxaMods.batCounterEnabled == true end,
        function(v)
            NoxaMods.batCounterEnabled = v == true
        end)

    NoxaCfg.registerConfigExtra("antiLagEnabled",
        function() return NoxaMods.antiLagEnabled == true end,
        function(v)
            local on = v == true
            NoxaMods.antiLagEnabled = on
            pcall(function()
                if NoxaMods.setAntiLag then
                    NoxaMods:setAntiLag(on)
                elseif on and NoxaMods.enableAntiLag then
                    NoxaMods:enableAntiLag()
                elseif (not on) and NoxaMods.disableAntiLag then
                    NoxaMods:disableAntiLag()
                end
            end)
        end)

    NoxaCfg.registerConfigExtra("nukeEnabled",
        function() return NoxaMods.nukeEnabled == true end,
        function(v)
            local on = v == true
            NoxaMods.nukeEnabled = on
            pcall(function()
                if NoxaMods.setNukeOptimizer then
                    NoxaMods:setNukeOptimizer(on)
                elseif on and _G._nukeStart then
                    _G._nukeStart()
                elseif (not on) and _G._nukeStop then
                    _G._nukeStop()
                end
            end)
        end)

    NoxaCfg.registerConfigExtra("carryActive",
        function() return SpeedSystem.carryActive == true end,
        function(v) SpeedSystem.carryActive = v == true end)

    NoxaCfg.registerConfigExtra("laggerActive",
        function() return SpeedSystem.laggerActive == true end,
        function(v) SpeedSystem.laggerActive = v == true end)

    NoxaCfg.registerConfigExtra("autoCarryEnabled",
        function() return SpeedSystem.autoCarryEnabled == true end,
        function(v) SpeedSystem.autoCarryEnabled = v == true end)

    NoxaCfg.registerConfigExtra("autoStealEnabled",
        function() return SpeedSystem.autoStealEnabled == true end,
        function(v) SpeedSystem.autoStealEnabled = v == true end)

    NoxaCfg.registerConfigExtra("stealMode",
        function()
            local m = SpeedSystem.stealMode or "V2 SEMI"
            if m == "V1" or m == "Normal" or m == "V4" then m = "V2 SEMI" end
            return m
        end,
        function(v)
            if type(v) == "string" then
                if v == "V1" or v == "Normal" or v == "Auto Steal V3" then v = "V2 SEMI" end
                if v == "Semi" then v = "V2 SEMI" end
                if v == "V2 SEMI" or v == "V3" then
                    SpeedSystem.stealMode = v
                elseif v == "V4" then
                    SpeedSystem.stealMode = "V2 SEMI"
                end
                pcall(function()
                    if _G.NoxaSetGrabModeUI then _G.NoxaSetGrabModeUI() end
                end)
            end
        end)

    NoxaCfg.registerConfigExtra("v4Threshold",
        function() return tonumber(SpeedSystem.v4Threshold) or (V4_DEFAULTS and V4_DEFAULTS.threshold) or 0.75 end,
        function(v) if type(v) == "number" then SpeedSystem.v4Threshold = v end end)
    NoxaCfg.registerConfigExtra("v4NearDist",
        function() return tonumber(SpeedSystem.v4NearDist) or (V4_DEFAULTS and V4_DEFAULTS.nearDist) or 10 end,
        function(v) if type(v) == "number" then SpeedSystem.v4NearDist = v end end)
    NoxaCfg.registerConfigExtra("v4WaitNearMax",
        function() return tonumber(SpeedSystem.v4WaitNearMax) or (V4_DEFAULTS and V4_DEFAULTS.waitNearMax) or 4 end,
        function(v) if type(v) == "number" then SpeedSystem.v4WaitNearMax = v end end)
    NoxaCfg.registerConfigExtra("v4ModeLevel",
        function() return tonumber(SpeedSystem.v4ModeLevel) or (V4_DEFAULTS and V4_DEFAULTS.modeLevel) or 1 end,
        function(v)
            if type(v) == "number" then
                local lvl = math.clamp(math.floor(v), 1, 4)
                SpeedSystem.v4ModeLevel = lvl
                local cfg = V4_MODE_CFG and V4_MODE_CFG[lvl]
                if cfg then
                    SpeedSystem.v4Threshold = cfg.threshold
                    SpeedSystem.v4NearDist = cfg.nearDist
                end
            end
        end)

    NoxaCfg.registerConfigExtra("infJumpEnabled",
        function() return SpeedSystem.infJumpEnabled == true end,
        function(v)

            SpeedSystem.infJumpEnabled = (v == true)
        end)

    NoxaCfg.registerConfigExtra("infJumpMode",
        function()
            local m = SpeedSystem.infJumpMode
            if m == "manual" or m == "tap" then return "manual" end
            return "hold"
        end,
        function(v)
            local m = string.lower(tostring(v or "hold"))
            if m == "tap" or m == "manual" then
                SpeedSystem.infJumpMode = "manual"
            else
                SpeedSystem.infJumpMode = "hold"
            end

            if SpeedSystem.infJumpEnabled then
                pcall(function() SpeedSystem:setInfJumpMode(SpeedSystem.infJumpMode) end)
            else
                pcall(function()
                    if _G.NoxaSetInfJumpModeUI then
                        _G.NoxaSetInfJumpModeUI(SpeedSystem.infJumpMode)
                    end
                end)
            end
        end)

    NoxaCfg.registerConfigExtra("antiRagdollEnabled",

        function() return SpeedSystem.antiRagdollEnabled == true end,
        function(v) SpeedSystem.antiRagdollEnabled = v == true end)

    NoxaCfg.registerConfigExtra("antiRagdollMode",
        function() return SpeedSystem.antiRagdollMode or "Splatter" end,
        function(v)
            if type(v) == "string" and (v == "Splatter" or v == "No Splatter") then
                SpeedSystem.antiRagdollMode = v
            end
        end)

    NoxaCfg.registerConfigExtra("antiDesyncAimbotEnabled",
        function() return SpeedSystem.antiDesyncAimbotEnabled == true end,
        function(v) SpeedSystem.antiDesyncAimbotEnabled = v == true end)

    NoxaCfg.registerConfigExtra("animPack",
        function() return SpeedSystem.animPack or "OFF" end,
        function(v)
            if type(v) == "string" then
                SpeedSystem.animPack = v
            end
        end)

    NoxaCfg.registerConfigExtra("NS",
        function() return SpeedSystem.NS end,
        function(v)
            if type(v) == "number" then SpeedSystem.NS = v end
        end)

    NoxaCfg.registerConfigExtra("CS",
        function() return SpeedSystem.CS end,
        function(v)
            if type(v) == "number" then SpeedSystem.CS = v end
        end)

    NoxaCfg.registerConfigExtra("LAGGER_NORMAL",
        function() return SpeedSystem.LAGGER_NORMAL end,
        function(v)
            if type(v) == "number" then SpeedSystem.LAGGER_NORMAL = v end
        end)

    NoxaCfg.registerConfigExtra("LAGGER_CARRY",
        function() return SpeedSystem.LAGGER_CARRY end,
        function(v)
            if type(v) == "number" then SpeedSystem.LAGGER_CARRY = v end
        end)

    NoxaCfg.registerConfigExtra("uiScale",
        function() return tonumber(SpeedSystem.uiScale) or 0.75 end,
        function(v)
            if type(v) == "number" then
                SpeedSystem.uiScale = v
                pcall(function()
                    if type(_G.NoxaApplyUIScale) == "function" then
                        _G.NoxaApplyUIScale(v)
                    else
                        local sc = MainClip and MainClip:FindFirstChildOfClass("UIScale")
                        if sc then sc.Scale = v end
                    end
                end)
            end
        end)

    NoxaCfg.registerConfigExtra("espBoxEnabled",
        function() return false end,
        function(v)
            if NoxaESP then
                NoxaESP.boxEnabled = false
                pcall(function() if NoxaESP.setBox then NoxaESP:setBox(false) end end)
            end
        end)

    NoxaCfg.registerConfigExtra("espBoxStyle",
        function() return (NoxaESP and NoxaESP.boxStyle) or "Normal" end,
        function(v)
            if NoxaESP and type(v) == "string" then
                NoxaESP.boxStyle = v
            end
        end)

    NoxaCfg.registerConfigExtra("espUserESPEnabled",
        function() return false end,
        function(v)
            if NoxaESP then
                NoxaESP.userESPEnabled = false
                pcall(function() if NoxaESP.setUserESP then NoxaESP:setUserESP(false) end end)
            end
        end)

    NoxaCfg.registerConfigExtra("espTracerEnabled",
        function() return false end,
        function(v)
            if NoxaESP then
                NoxaESP.tracerEnabled = false
                pcall(function() if NoxaESP.setTracer then NoxaESP:setTracer(false) end end)
            end
        end)
    NoxaCfg.registerConfigExtra("espHighlightEnabled",
        function() return false end,
        function(v)
            if NoxaESP then
                NoxaESP.highlightEnabled = false
                pcall(function() if NoxaESP.setHighlight then NoxaESP:setHighlight(false) end end)
            end
        end)
    NoxaCfg.registerConfigExtra("espRagdollTimer",
        function() return false end,
        function(v)
            if NoxaESP then
                NoxaESP.ragdollTimer = false
                pcall(function() if NoxaESP.setRagdollTimer then NoxaESP:setRagdollTimer(false) end end)
            end
        end)
    NoxaCfg.registerConfigExtra("espRagdollNotify",
        function() return false end,
        function(v)
            if NoxaESP then
                NoxaESP.ragdollNotify = false
                pcall(function() if NoxaESP.setRagdollNotify then NoxaESP:setRagdollNotify(false) end end)
            end
        end)

    NoxaCfg.registerConfigExtra("bgImageTransparency",
        function() return SpeedSystem.bgImageTransparency end,
        function(v)
            if type(v) == "number" then
                SpeedSystem.bgImageTransparency = v
                pcall(function()
                    if BgAsset then BgAsset.ImageTransparency = v end
                end)
            end
        end)

    NoxaCfg.registerConfigExtra("bgImageEnabled",
        function() return SpeedSystem.bgImageEnabled ~= false end,
        function(v)
            SpeedSystem.bgImageEnabled = v ~= false
            pcall(function()
                if type(_G.NoxaApplyBgImage) == "function" then
                    _G.NoxaApplyBgImage(SpeedSystem.bgImageIndex or 1)
                end
            end)
            local vis = SpeedSystem.bgImageEnabled == true
            pcall(function() if BgAsset then BgAsset.Visible = vis end end)
            pcall(function() if _G._NoxaKuRuBG then _G._NoxaKuRuBG.Visible = vis end end)
            pcall(function() if _G._NoxaVx7BG then _G._NoxaVx7BG.Visible = vis end end)
        end)

    NoxaCfg.registerConfigExtra("bgImageIndex",
        function() return tonumber(SpeedSystem.bgImageIndex) or 1 end,
        function(v)
            if type(v) == "number" then
                local maxIdx = (_G.NoxaBgImages and #_G.NoxaBgImages) or 10
                SpeedSystem.bgImageIndex = math.clamp(math.floor(v), 1, maxIdx)
                pcall(function()
                    if type(_G.NoxaApplyBgImage) == "function" then
                        _G.NoxaApplyBgImage(SpeedSystem.bgImageIndex)
                    elseif BgAsset and _G.NoxaBgImages then
                        local img = _G.NoxaBgImages[SpeedSystem.bgImageIndex]
                        if img then BgAsset.Image = img end
                    end
                end)

                pcall(function()
                    if NoxaUI.applyAccentAll then
                        NoxaUI.applyAccentAll(Color3.fromRGB(70, 170, 255))
                    end
                end)
            end
        end)

    NoxaCfg.registerConfigExtra("playerESP",
        function() return SpeedSystem.playerESP == true end,
        function(v)
            SpeedSystem.playerESP = v == true
            task.defer(function()
                local port = rawget(_G, "_Noxa7UpPort")
                if not port then return end
                if SpeedSystem.playerESP then
                    pcall(port.startPlayerESP)
                else
                    pcall(port.stopPlayerESP)
                end
            end)
        end)
    NoxaCfg.registerConfigExtra("tracerESP",
        function() return SpeedSystem.tracerESP == true end,
        function(v)
            SpeedSystem.tracerESP = v == true
            task.defer(function()
                local port = rawget(_G, "_Noxa7UpPort")
                if not port then return end
                if SpeedSystem.tracerESP then
                    pcall(port.startTracerESP)
                else
                    pcall(port.stopTracerESP)
                end
            end)
        end)

    NoxaCfg.registerConfigExtra("skinPack",
        function() return SpeedSystem.skinPack or "Off" end,
        function(v)
            if type(v) == "string" then
                SpeedSystem.skinPack = v
                task.defer(function()
                    if _G.NoxaForceApplySavedSkin then
                        _G.NoxaForceApplySavedSkin("config")
                    elseif _G.NoxaApplySkinPack then
                        pcall(function() _G.NoxaApplySkinPack(v) end)
                    end
                end)
            end
        end)

        NoxaCfg.registerConfigExtra("dropMode",
        function() return tonumber(SpeedSystem.dropMode) or 1 end,
        function(v)
            local n = tonumber(v)
            if n == 1 or n == 2 then SpeedSystem.dropMode = n end
        end)
    NoxaCfg.registerConfigExtra("uiSkin",
        function() return "Noxa" end,
        function(v)
            SpeedSystem.uiSkin = "Noxa"
        end)

    NoxaCfg.registerConfigExtra("stealBarStyle",
        function() return "V3" end,
        function(v)
            SpeedSystem.stealBarStyle = "V3"
            pcall(function() if applyStealBarStyle then applyStealBarStyle("V3") end end)
        end)

    NoxaCfg.registerConfigExtra("v3BarScale",
        function()
            if stealProgressBar then
                local a = tonumber(stealProgressBar:GetAttribute("V3Scale"))
                if a then return a end
            end
            return tonumber(SpeedSystem.v3BarScale) or 1
        end,
        function(v)
            local s = tonumber(v) or 1
            s = math.clamp(s, 0.6, 1.6)
            SpeedSystem.v3BarScale = s
            if stealProgressBar then
                stealProgressBar:SetAttribute("V3Scale", s)
                local sc = stealProgressBar:FindFirstChild("V3BarScale")
                if not sc then
                    sc = Instance.new("UIScale")
                    sc.Name = "V3BarScale"
                    sc.Parent = stealProgressBar
                end
                sc.Scale = s
            end
        end)

    NoxaCfg.registerConfigExtra("speedMethod",
        function() return SpeedSystem.speedMethod or "V1" end,
        function(v)
            if v == "V1" or v == "V2" then SpeedSystem.speedMethod = v end
        end)

    NoxaCfg.registerConfigExtra("tabPos",
        function() return SpeedSystem.tabPos or "Right" end,
        function(v)
            if type(v) == "string" and (v == "Left" or v == "Right" or v == "Top" or v == "Bottom") then
                SpeedSystem.tabPos = v
            end
        end)

    NoxaCfg.registerConfigExtra("stealBarPosition",
        function()
            if stealProgressBar then
                return {xs = stealProgressBar.Position.X.Scale, xo = stealProgressBar.Position.X.Offset,
                        ys = stealProgressBar.Position.Y.Scale, yo = stealProgressBar.Position.Y.Offset}
            end
            return nil
        end,
        function(v)
            if type(v) == "table" and stealProgressBar then
                stealProgressBar.Position = UDim2.new(
                    v.xs or 0.5, v.xo or -160,
                    v.ys or 1, v.yo or -90
end
        end)

    NoxaCfg.registerConfigExtra("autoTpDownHeight",
        function() return tonumber(SpeedSystem.autoTpDownHeight) or 12 end,
        function(v)
            local n = tonumber(v)
            if n then SpeedSystem.autoTpDownHeight = math.clamp(n, 2, 80) end
        end)
    NoxaCfg.registerConfigExtra("autoTpDownEnabled",
        function() return SpeedSystem.autoTpDownEnabled == true end,
        function(v) SpeedSystem.autoTpDownEnabled = v == true end)
    NoxaCfg.registerConfigExtra("saturatedColorsEnabled",
        function() return SpeedSystem.saturatedColorsEnabled == true end,
        function(v)
            SpeedSystem.saturatedColorsEnabled = v == true
            pcall(function()
                local Lighting = game:GetService("Lighting")
                local cc = Lighting:FindFirstChild("NoxaSaturatedCC")
                    if not cc then
                        cc = Instance.new("ColorCorrectionEffect")
                        cc.Name = "NoxaSaturatedCC"
                        cc.Parent = Lighting
                    end
                    cc.Saturation = 0.55
                    cc.Contrast = 0.12
                    cc.Enabled = true
                elseif cc then
                    cc.Enabled = false
                end
            end)
        end)
    NoxaCfg.registerConfigExtra("antiFlingShieldEnabled",
        function() return SpeedSystem.antiFlingShieldEnabled == true end,
        function(v)
            SpeedSystem.antiFlingShieldEnabled = v == true
            if v then pcall(startAntiFlingShield) else pcall(stopAntiFlingShield) end
        end)
    NoxaCfg.registerConfigExtra("safeModeEnabled",
        function() return SpeedSystem.safeModeEnabled == true end,
        function(v) SpeedSystem.safeModeEnabled = v == true end)
    NoxaCfg.registerConfigExtra("noPlayerCollisionEnabled",
        function() return SpeedSystem.noPlayerCollisionEnabled == true end,
        function(v)
            local on = v == true
            SpeedSystem.noPlayerCollisionEnabled = on
            pcall(function()
                if on and _G.NoxaEnableNoPlayerCollision then
                    _G.NoxaEnableNoPlayerCollision()
                elseif (not on) and _G.NoxaDisableNoPlayerCollision then
                    _G.NoxaDisableNoPlayerCollision()
                end
            end)
            pcall(function()
                if _G.NoxaNoPlayerCollisionRow and ToggleStates then
                    ToggleStates[_G.NoxaNoPlayerCollisionRow] = on
                    local area = _G.NoxaNoPlayerCollisionRow:FindFirstChild("ToggleArea")
                    local track = area and area:FindFirstChildWhichIsA("Frame")
                    local knob = track and track:FindFirstChildWhichIsA("Frame")
                    if track and knob and NoxaUI.setToggleVisual then
                        NoxaUI.setToggleVisual(track, knob, on)
                    end
                end
            end)
        end)
    NoxaCfg.registerConfigExtra("tpBatVersion",
        function() return SpeedSystem.tpBatVersion or "V1" end,
        function(v)
            if v == "V1" or v == "V2" then SpeedSystem.tpBatVersion = v end
        end)
    NoxaCfg.registerConfigExtra("tpBatAutoDisableOnHit",
        function() return false end,
        function(v) SpeedSystem.tpBatAutoDisableOnHit = false end)
    NoxaCfg.registerConfigExtra("batAutoDisableOnHit",
        function() return false end,
        function(v)
            if BatAimbot then BatAimbot.autoDisableOnHit = false end
        end)
    NoxaCfg.registerConfigExtra("antiDieEnabled",
        function()
            if _G.NoxaAntiDie then return _G.NoxaAntiDie.enabled == true end
            return SpeedSystem.antiDieEnabled == true
        end,
        function(v)
            local on = v == true
            SpeedSystem.antiDieEnabled = on
            if _G.NoxaAntiDie then
                if on then _G.NoxaAntiDie:enable() else _G.NoxaAntiDie:disable() end
            end
            pcall(function()
                if _G.NoxaAntiDieRow and type(syncToggleRow) == "function" then

                end
                if _G.NoxaAntiDieRow then
                    ToggleStates[_G.NoxaAntiDieRow] = on
                    local area = _G.NoxaAntiDieRow:FindFirstChild("ToggleArea")
                    local track = area and area:FindFirstChildWhichIsA("Frame")
                    local knob = track and track:FindFirstChildWhichIsA("Frame")
                    if track and knob and NoxaUI.setToggleVisual then
                        NoxaUI.setToggleVisual(track, knob, on)
                    end
                end
            end)
        end)

    NoxaCfg.registerConfigExtra("bodyLockEnabled",
        function() return false end,
        function(v)
            SpeedSystem.bodyLockEnabled = false
            pcall(function() if _G.NoxaBodyLock then _G.NoxaBodyLock:disable() end end)
        end)
    NoxaCfg.registerConfigExtra("instaResetOnDeathEnabled",
        function() return SpeedSystem.instaResetOnDeathEnabled == true end,
        function(v)
            local on = v == true
            SpeedSystem.instaResetOnDeathEnabled = on
            pcall(function()
                if on then
                    SpeedSystem:startInstaResetOnDeath()
                else
                    SpeedSystem:stopInstaResetOnDeath()
                    SpeedSystem.instaResetOnDeathEnabled = false
                end
            end)
            pcall(function()
                if _G.NoxaInstaResetOnDeathRow then
                    ToggleStates[_G.NoxaInstaResetOnDeathRow] = on
                    local area = _G.NoxaInstaResetOnDeathRow:FindFirstChild("ToggleArea")
                    local track = area and area:FindFirstChildWhichIsA("Frame")
                    local knob = track and track:FindFirstChildWhichIsA("Frame")
                    if track and knob and NoxaUI.setToggleVisual then
                        NoxaUI.setToggleVisual(track, knob, on)
                    end
                end
            end)
        end)

    NoxaCfg.registerConfigExtra("autoDodgeEnabled",
        function() return SpeedSystem.autoDodgeEnabled == true end,
        function(v)
            SpeedSystem:setAutoDodge(v == true)
            pcall(function()
                if _G.NoxaAutoDodgeRow then
                    ToggleStates[_G.NoxaAutoDodgeRow] = v == true
                    local area = _G.NoxaAutoDodgeRow:FindFirstChild("ToggleArea")
                    local track = area and area:FindFirstChildWhichIsA("Frame")
                    local knob = track and track:FindFirstChildWhichIsA("Frame")
                    if track and knob and NoxaUI.setToggleVisual then
                        NoxaUI.setToggleVisual(track, knob, v == true)
                    end
                end
            end)
        end)
    NoxaCfg.registerConfigExtra("autoDodgeKeybind",
        function()
            local k = SpeedSystem.autoDodgeKeybind
            return (typeof(k) == "EnumItem") and k.Name or "H"
        end,
        function(v)
            if type(v) == "string" and Enum.KeyCode[v] then
                SpeedSystem.autoDodgeKeybind = Enum.KeyCode[v]
                pcall(function()
                    if _G.NoxaAutoDodgeKeyBtn then
                        _G.NoxaAutoDodgeKeyBtn.Text = v
                    end
                end)
            end
        end)

end)

pcall(function()
    if NoxaCfg and NoxaCfg.registerModule then
        NoxaCfg.registerModule("NoxaMods", function() return NoxaMods end)
        NoxaCfg.registerModule("NoxaESP", function() return NoxaESP end)
        NoxaCfg.registerModule("BatAimbot", function() return BatAimbot end)
        NoxaCfg.registerModule("NoxaAntiDie", function() return _G.NoxaAntiDie or AntiDie end)
    end
    _G.NoxaMods = NoxaMods
end)

NoxaCfg._extrasApplied = false
task.defer(function() pcall(NoxaCfg.startAutoSave) end)

if not _G.NoxaHub_MainExecuted then
    _G.NoxaHub_MainExecuted = true
    _G._NoxaIntroHidingUI = false
    task.defer(function()
        pcall(function()
            NoxaCfg.reapplyConfigExtras()
            if refreshUIFromConfig then refreshUIFromConfig() end
        end)
    end)
    pcall(function()
        if type(skipIntro) == "function" then
            skipIntro()
        end
    end)
    pcall(function()
        SpeedSystem.uiSkin = "Noxa"
        local tr = tonumber(SpeedSystem.bgImageTransparency) or 0.05
        if tr > 0.25 then
            SpeedSystem.bgImageTransparency = 0.05
            tr = 0.05
        end
        pcall(function()
            if type(_G.NoxaApplyBgImage) == "function" then
                _G.NoxaApplyBgImage(SpeedSystem.bgImageIndex or 1)
            elseif BgAsset then
                BgAsset.ImageTransparency = tr
                BgAsset.Visible = SpeedSystem.bgImageEnabled ~= false
            end
        end)
        if MainClip then MainClip.Visible = SpeedSystem.menuOpen ~= false end
        if FloatOpen then FloatOpen.Visible = not (MainClip and MainClip.Visible) end
        if type(openMain) == "function" and SpeedSystem.menuOpen ~= false then
            openMain()
        end
    end)
    print("leak by https://discord.gg/TBBAUZu8cW")
end

    SpeedSystem.uiSkin = "Noxa"
    if MainClip and not MainClip.Visible and SpeedSystem.menuOpen ~= false then
        MainClip.Visible = true
    end
end

pcall(function()
    if type(SpeedSystem.onUIUpdate) == "function" then
        SpeedSystem.onUIUpdate()
    end
end)

pcall(function()
    if NoxaUI.applyAccentAll then
        NoxaUI.applyAccentAll(Color3.fromRGB(70, 170, 255))
    end

    if type(_G.NoxaApplyBgImage) == "function" then
        _G.NoxaApplyBgImage(SpeedSystem.bgImageIndex or 1)
    end
end)

task.defer(function()
    pcall(function()
        if type(SpeedSystem.startSpeedLoop) == "function" then
            SpeedSystem:startSpeedLoop()
        end
    end)
end)

task.defer(function()
    SpeedSystem.stealBarStyle = "V3"
    local style = "V3"

    pcall(function()
        if applyStealBarStyle then applyStealBarStyle("V3") end
    end)
    pcall(function()
        if ensureStealBarRefs then ensureStealBarRefs() end
        if updateModeVisual then updateModeVisual() end
        if setBarState then setBarState("IDLE") end
        if resetProgressBar then resetProgressBar() end

        if style == "V1" then

            if stealProgressBar then stealProgressBar.Visible = false end
            local rb = rawget(_G, "_NoxaRitualBar")
            if rb and rb.gui then
                rb.gui.Enabled = true
                if rb.fill then
                    stealProgressFill = rb.fill
                    stealProgressFill.Visible = true
                    stealProgressFill.Size = UDim2.new(0, 0, 1, 0)
                end
                if rb.pct then progressPct = rb.pct end
            end
        else
            if stealProgressBar then
                stealProgressBar.Visible = true
                stealProgressBar.ZIndex = math.max(stealProgressBar.ZIndex or 1, 50)
            end
            if stealProgressFill and stealProgressFill.Parent then
                stealProgressFill.Visible = true
                stealProgressFill.Size = UDim2.new(0, 0, 1, 0)
                stealProgressFill.BackgroundTransparency = 0
            end
            if style == "V3" and stealProgressBar then
                local s = tonumber(SpeedSystem.v3BarScale) or tonumber(stealProgressBar:GetAttribute("V3Scale")) or 1
                s = math.clamp(s, 0.6, 1.6)
                local sc = stealProgressBar:FindFirstChild("V3BarScale")
                if not sc then
                    sc = Instance.new("UIScale")
                    sc.Name = "V3BarScale"
                    sc.Parent = stealProgressBar
                end
                sc.Scale = s
                stealProgressBar:SetAttribute("V3Scale", s)
                SpeedSystem.v3BarScale = s
            end
        end
    end)
    pcall(function()
        if SpeedSystem.autoStealEnabled then
            if stopAutoSteal then stopAutoSteal() end
            if startAutoSteal then startAutoSteal() end
            if setBarState then setBarState("IDLE") end
        end
    end)
end)

pcall(function()
    local idx = tonumber(SpeedSystem.bgImageIndex) or 1
    if type(_G.NoxaApplyBgImage) == "function" then
        _G.NoxaApplyBgImage(idx)
    elseif BgAsset and _G.NoxaBgImages then
        local img = _G.NoxaBgImages[idx]
        if img then BgAsset.Image = img end
    end
    task.defer(function()
        pcall(function()
            if NoxaUI.applyAccentAll then
                NoxaUI.applyAccentAll(Color3.fromRGB(70, 170, 255))
            end
        end)
    end)
end)

    local mb = SpeedSystem.mobileButtons
    local old = PlayerGui:FindFirstChild("NoxaMobileButtons")
    if old then old:Destroy() end
    local mobileGui = Instance.new("ScreenGui")
    mobileGui.Name = "NoxaMobileButtons"
    mobileGui.ResetOnSpawn = false
    mobileGui.IgnoreGuiInset = true
    mobileGui.DisplayOrder = 1000
    mobileGui.Parent = PlayerGui

    local refs = {}
    _G.NoxaMobileRefs = refs

    local function styleSize()
        local s = mb.style or "squircle"
        if s == "round" then return UDim2.new(0, 58, 0, 58), 1
        elseif s == "rect1" then return UDim2.new(0, 92, 0, 42), 10
        elseif s == "rect2" then return UDim2.new(0, 52, 0, 68), 10
        else return UDim2.new(0, 72, 0, 52), 14 end
    end

    local function setActive(btn, on)
        if not btn then return end
        local st = btn:FindFirstChildOfClass("UIStroke")
        local onCol = Color3.fromRGB(70, 170, 255)
        local offStroke = Color3.fromRGB(40, 90, 160)
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = on and onCol or Color3.fromRGB(10,12,16),
            BackgroundTransparency = 0,
            TextColor3 = on and Color3.fromRGB(8,10,12) or Color3.fromRGB(230,230,235),
        }):Play()
        if st then
            TweenService:Create(st, TweenInfo.new(0.15), {
                Color = on and onCol or offStroke,
                Transparency = on and 0.05 or 0.4,
            }):Play()
        end
    end

    function _G.NoxaMobileRefreshActive()
        pcall(function()
            local r = _G.NoxaMobileRefs
            if not r then return end
            for key, btn in pairs(r) do
                if typeof(btn) == "Instance" and btn:IsA("TextButton") then
                    local bg = btn.BackgroundColor3
                    local isOn = (bg.R + bg.G + bg.B) > 0.35
                    setActive(btn, isOn)
                end
            end
        end)
    end

    local function makeBtn(key, label, defaultPos, onPress)
        local sz, rad = styleSize()
        local holder = Instance.new("Frame")
        holder.Name = "MBH_" .. key
        holder.Size = sz
        local saved = mb.positions and mb.positions[key]
        if type(saved) == "table" then
            holder.Position = UDim2.new(saved.xs or 1, saved.xo or 0, saved.ys or 0.5, saved.yo or 0)
        else
            holder.Position = defaultPos
        end
        holder.BackgroundTransparency = 1
        holder.Parent = mobileGui

        local sc = Instance.new("UIScale")
        sc.Name = "MobileButtonScale"
        sc.Scale = tonumber(mb.scale) or 0.85
        sc.Parent = holder

        local btn = Instance.new("TextButton")
        btn.Name = "MB_" .. key
        btn.Size = UDim2.new(1,0,1,0)
        btn.BackgroundColor3 = Color3.fromRGB(10,12,16)
        btn.Text = label
        btn.TextColor3 = Color3.fromRGB(230,230,235)
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = 10
        btn.TextWrapped = true
        btn.AutoButtonColor = false
        btn.Parent = holder
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, rad)
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(40, 90, 160)
        stroke.Thickness = 0
        stroke.Transparency = 1

        local pressing, dragging = false, false
        local pressPos, holderStart
        btn.InputBegan:Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.MouseButton1 and i.UserInputType ~= Enum.UserInputType.Touch then return end
            pressing = true; dragging = false
            pressPos = i.Position; holderStart = holder.Position
            setActive(btn, true)
        end)
        btn.InputEnded:Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.MouseButton1 and i.UserInputType ~= Enum.UserInputType.Touch then return end
            if pressing and not dragging then pcall(onPress, btn) end
            if dragging then
                mb.positions[key] = {
                    xs = holder.Position.X.Scale, xo = holder.Position.X.Offset,
                    ys = holder.Position.Y.Scale, yo = holder.Position.Y.Offset,
                NoxaCfg.saveConfig()
            end
            pressing = false; dragging = false
        end)
        UserInputService.InputChanged:Connect(function(i)
            if mb.locked or not pressing then return end
            if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
            local delta = i.Position - pressPos
            if not dragging and (math.abs(delta.X) > 6 or math.abs(delta.Y) > 6) then dragging = true end
            if dragging then
                holder.Position = UDim2.new(
                    holderStart.X.Scale, holderStart.X.Offset + delta.X,
                    holderStart.Y.Scale, holderStart.Y.Offset + delta.Y)
            end
        end)

        refs[key] = {holder = holder, btn = btn, setActive = function(s) setActive(btn, s) end}
        return btn
    end

    local x1, x2, x3 = -210, -132, -54
    local y1, y2, y3, y4 = -150, -90, -30, 30
    local defaults = {
        insta = UDim2.new(1, x1, 0.55, y1),
        drop = UDim2.new(1, x2, 0.55, y1),
        tpDown = UDim2.new(1, x3, 0.55, y1),
        aimbot = UDim2.new(1, x1, 0.55, y2),
        tpbat = UDim2.new(1, x2, 0.55, y2),
        autoLeft = UDim2.new(1, x3, 0.55, y2),
        autoRight = UDim2.new(1, x1, 0.55, y3),
        carry = UDim2.new(1, x2, 0.55, y3),
        laggerNormal = UDim2.new(1, x3, 0.55, y3),
        laggerCarry = UDim2.new(1, x2, 0.55, y4),
        autoDodge = UDim2.new(1, x1, 0.55, y4),

    makeBtn("insta", "INSTA\nRESET", defaults.insta, function(btn)
        SpeedSystem:runInstantReset()
        refs.insta.setActive(true)
        task.delay(0.2, function() refs.insta.setActive(false) end)
    end)
    makeBtn("drop", "DROP\nBR", defaults.drop, function(btn)
        SpeedSystem:runDropBrainrot()
        refs.drop.setActive(true)
        task.delay(0.2, function() refs.drop.setActive(false) end)
    end)
    makeBtn("tpDown", "TP\nDOWN", defaults.tpDown, function(btn)
        SpeedSystem:runTPDown()
        refs.tpDown.setActive(true)
        task.delay(0.2, function() refs.tpDown.setActive(false) end)
    end)
    makeBtn("aimbot", "BAT\nAIM", defaults.aimbot, function()
        if NoxaMods and NoxaMods.BatAimbotRef then
            local B = NoxaMods.BatAimbotRef
            B.enabled = not B.enabled
            if B.enabled and NoxaMods._batAimbotStart then NoxaMods._batAimbotStart()
            elseif NoxaMods._batAimbotStop then NoxaMods._batAimbotStop() end
            refs.aimbot.setActive(B.enabled)
            pcall(function() NoxaMods:_syncToggleRow(NoxaMods._batAimbotRow, B.enabled) end)
        end
    end)
    makeBtn("tpbat", "TP\nBAT", defaults.tpbat, function()
        SpeedSystem.antiDesyncAimbotEnabled = not SpeedSystem.antiDesyncAimbotEnabled
        if SpeedSystem.antiDesyncAimbotEnabled then SpeedSystem:startAntiDesyncAimbot()
        else SpeedSystem:stopAntiDesyncAimbot() end
        refs.tpbat.setActive(SpeedSystem.antiDesyncAimbotEnabled)
        if SpeedSystem.onUIUpdate then SpeedSystem:onUIUpdate() end
        NoxaCfg.saveConfig()
    end)
    makeBtn("autoLeft", "AUTO\nLEFT", defaults.autoLeft, function()
        SpeedSystem.AutoPath.set("left", not SpeedSystem.AutoPath.leftEnabled)
        refs.autoLeft.setActive(SpeedSystem.AutoPath.leftEnabled)
        NoxaCfg.saveConfig()
    end)
    makeBtn("autoRight", "AUTO\nRIGHT", defaults.autoRight, function()
        SpeedSystem.AutoPath.set("right", not SpeedSystem.AutoPath.rightEnabled)
        refs.autoRight.setActive(SpeedSystem.AutoPath.rightEnabled)
        NoxaCfg.saveConfig()
    end)
    makeBtn("carry", "CARRY\nSPEED", defaults.carry, function()
        local on = not (SpeedSystem.carryActive and not SpeedSystem.laggerActive)
        if on then SpeedSystem:setSpeedMode("CARRY") else SpeedSystem:setSpeedMode("NORMAL") end
        NoxaCfg.saveConfig()
    end)
    makeBtn("laggerNormal", "LAGGER\nNORMAL", defaults.laggerNormal, function()
        local on = not (SpeedSystem.laggerActive and not SpeedSystem.carryActive)
        if on then SpeedSystem:setSpeedMode("LAGGER_NORMAL") else SpeedSystem:setSpeedMode("NORMAL") end
        NoxaCfg.saveConfig()
    end)
    makeBtn("laggerCarry", "LAGGER\nCARRY", defaults.laggerCarry, function()
        local on = not (SpeedSystem.laggerActive and SpeedSystem.carryActive)
        if on then SpeedSystem:setSpeedMode("LAGGER_CARRY") else SpeedSystem:setSpeedMode("NORMAL") end
        NoxaCfg.saveConfig()
    end)
    makeBtn("autoDodge", "AUTO\nDODGE", defaults.autoDodge, function()
        local on = SpeedSystem:toggleAutoDodge()
        refs.autoDodge.setActive(on == true)
        pcall(function()
            if _G.NoxaAutoDodgeRow and ToggleStates then
                ToggleStates[_G.NoxaAutoDodgeRow] = on == true
                local area = _G.NoxaAutoDodgeRow:FindFirstChild("ToggleArea")
                local track = area and area:FindFirstChildWhichIsA("Frame")
                local knob = track and track:FindFirstChildWhichIsA("Frame")
                if track and knob and NoxaUI.setToggleVisual then
                    NoxaUI.setToggleVisual(track, knob, on == true)
                end
            end
        end)
        NoxaCfg.saveConfig(true)
    end)

    function _G.NoxaMobileApplyAutoPlayMode(one)
        if refs.autoLeft and refs.autoLeft.holder then refs.autoLeft.holder.Visible = true end
        if refs.autoRight and refs.autoRight.holder then refs.autoRight.holder.Visible = true end
    end
    function _G.NoxaMobileSyncAutoPlay()
        if refs.autoLeft then refs.autoLeft.setActive(SpeedSystem.AutoPath.leftEnabled) end
        if refs.autoRight then refs.autoRight.setActive(SpeedSystem.AutoPath.rightEnabled) end
    end
    function _G.NoxaMobileApplyLock() end
    function _G.NoxaMobileApplyHidden()
        mobileGui.Enabled = not (mb.hidden == true)
    end
    function _G.NoxaMobileApplyStyle()
        local sz, rad = styleSize()
        for _, e in pairs(refs) do
            if e.holder then e.holder.Size = sz end
            if e.btn then
                local c = e.btn:FindFirstChildOfClass("UICorner")
                if c then c.CornerRadius = UDim.new(0, rad) end
            end
        end
    end
    function _G.NoxaMobileResetPos()
        for k, pos in pairs(defaults) do
            local e = refs[k]
            if e and e.holder then e.holder.Position = pos end
        end
        mb.positions = {}
    end

    _G.NoxaMobileApplyHidden()
    _G.NoxaMobileApplyStyle()

    local _mbLastSync = 0
    if _G._NoxaMobileSyncConn then pcall(function() _G._NoxaMobileSyncConn:Disconnect() end) end
    _G._NoxaMobileSyncConn = _G._NoxaTrackConn(RunService.Heartbeat:Connect(function()
        local now = tick()
        if now - _mbLastSync < 0.2 then return end
        _mbLastSync = now
        if not mobileGui.Enabled then return end
        if refs.aimbot and NoxaMods and NoxaMods.BatAimbotRef then
            refs.aimbot.setActive(NoxaMods.BatAimbotRef.enabled == true)
        end
        if refs.tpbat then refs.tpbat.setActive(SpeedSystem.antiDesyncAimbotEnabled == true) end
        if refs.carry then refs.carry.setActive(SpeedSystem.carryActive and not SpeedSystem.laggerActive) end
        if refs.laggerNormal then refs.laggerNormal.setActive(SpeedSystem.laggerActive and not SpeedSystem.carryActive) end
        if refs.laggerCarry then refs.laggerCarry.setActive(SpeedSystem.laggerActive and SpeedSystem.carryActive) end
        if refs.autoLeft then refs.autoLeft.setActive(SpeedSystem.AutoPath.leftEnabled == true) end
        if refs.autoRight then refs.autoRight.setActive(SpeedSystem.AutoPath.rightEnabled == true) end
        if refs.autoDodge then refs.autoDodge.setActive(SpeedSystem.autoDodgeEnabled == true) end
    end))
end

    SpeedSystem.uiSkin = "Noxa"
    function _G.NoxaApplyUISkin(skin)
        SpeedSystem.uiSkin = "Noxa"
        pcall(function()
            local k = PlayerGui:FindFirstChild("NoxaKuRuSkin")
            if k then k:Destroy() end
            local v = PlayerGui:FindFirstChild("NoxaVx7Skin")
            if v then v:Destroy() end
        end)
        pcall(function()
            if MainClip then MainClip.Visible = SpeedSystem.menuOpen ~= false end
            if FloatOpen then FloatOpen.Visible = not (MainClip and MainClip.Visible) end
        end)
        pcall(function()
            if NoxaUI and NoxaUI.applyTheme then
                NoxaUI.applyTheme({
                    name = "Noxa Neon",
                    accent = Color3.fromRGB(70, 170, 255),
                    a2 = Color3.fromRGB(150, 210, 255),
                    ad = Color3.fromRGB(30, 100, 190),
            end
        end)
        pcall(function()
            if NoxaUI.applyAccentAll then
                NoxaUI.applyAccentAll(Color3.fromRGB(70, 170, 255))
            end
        end)
    end
    task.defer(function()
        pcall(function()
            if NoxaCfg and NoxaCfg.reapplyConfigExtras then NoxaCfg.reapplyConfigExtras() end
        end)
        SpeedSystem.uiSkin = "Noxa"
        pcall(function() if _G.NoxaApplyUISkin then _G.NoxaApplyUISkin("Noxa") end end)
        pcall(function()
            if _G.NoxaForceApplySavedSkin then
                _G.NoxaForceApplySavedSkin("final")
            elseif _G.NoxaApplySkinPack and SpeedSystem.skinPack and SpeedSystem.skinPack ~= "Off" then
                _G.NoxaApplySkinPack(SpeedSystem.skinPack)
            end
        end)
    end)
end

return {
    Gui       = Gui,
    Main      = MainClip,
    notify    = notify,
    switchTab = switchTab,
    openMain  = openMain,
    closeMain = closeMain,