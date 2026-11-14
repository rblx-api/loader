local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")
local MaterialService = game:GetService("MaterialService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

local Xlu0AutoMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
_G.Xlu0IsMobile = Xlu0AutoMobile
_G.Xlu0DeviceMode = Xlu0AutoMobile and "MOBILE" or "PC"
_G.Xlu0CursedResetRemote = _G.Xlu0CursedResetRemote or nil
_G.Xlu0CursedResetGuid = _G.Xlu0CursedResetGuid or "f888ee6e-c86d-46e1-93d7-0639d6635d42"
pcall(function()
if not _G.Xlu0CursedResetHooked and hookfunction and newcclosure then
_G.Xlu0CursedResetHooked = true
local oldFire
oldFire = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
if not _G.Xlu0CursedResetRemote and typeof(self) == "Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3) == "RE/" then
_G.Xlu0CursedResetRemote = self
end
return oldFire(self, ...)
end))
end
end)
function _G.Xlu0CursedInstaReset()
if _G.Xlu0AntiResetEnabled then
_G.Xlu0RestoreAntiDieAfterReset = true
_G.Xlu0SetAntiReset(false)
if _G.Xlu0AntiResetVisual then
pcall(function() _G.Xlu0AntiResetVisual(false) end)
end
do end
end
local character = LP.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")

if not _G.Xlu0CursedResetRemote then
for _, desc in ipairs(ReplicatedStorage:GetDescendants()) do
if desc:IsA("RemoteEvent") and desc.Name:sub(1,3) == "RE/" then
_G.Xlu0CursedResetRemote = desc
break
end
end
end

if humanoid and humanoid.Health > 0 then
pcall(function()
humanoid.Health = 0
end)
end

if _G.Xlu0CursedResetRemote then
task.spawn(function()
for _ = 1, 12 do
pcall(function()
_G.Xlu0CursedResetRemote:FireServer(_G.Xlu0CursedResetGuid, LP, "balloon")
end)
task.wait(0.025)
end
end)
end
end
function cursedInstaReset()
if _G.Xlu0AntiResetEnabled then
_G.Xlu0RestoreAntiDieAfterReset = true
_G.Xlu0SetAntiReset(false)
if _G.Xlu0AntiResetVisual then
pcall(function() _G.Xlu0AntiResetVisual(false) end)
end
do end
end
return _G.Xlu0CursedInstaReset()
end
for _, name in ipairs({"Xlu0DuelsAdaptReconstruct", "AdaptHubPolished", "CyberHub"}) do
local old = PlayerGui:FindFirstChild(name)
if old then old:Destroy() end
end
local NS = 59.5
local CS = 28.8
local LAGGER_SPEED = 29
local LAGGER_CARRY_SPEED = 15
local currentSpeedMode = "Normal"
autoCarrySpeedEnabled = false
setAutoCarrySpeedVisual = nil
_G.Xlu0AutoCarryWasCarrying = false
_G.Xlu0AutoCarrySavedMode = nil
local autoStealEnabled = false
local selectedStealMode = "Auto Steal V3"
local autoStealRadius = 63
_G.Xlu0StealRadii = _G.Xlu0StealRadii or {["Auto Steal V3"] = 63, Semi = 9}
_G.Xlu0StealRadii["Auto Steal V3"] = tonumber(_G.Xlu0StealRadii["Auto Steal V3"] or _G.Xlu0StealRadii.Normal) or 63
local autoStealRadiusBox = nil
local selectedAimbotMode = "Normal"
local AIMBOT_SPEED = 58
local LAGGER_AIMBOT_SPEED = 40
_G.Xlu0AntiBypassAimbotSpeed = _G.Xlu0AntiBypassAimbotSpeed or 58
if _G.Xlu0AntiBypassLaggerAimbotSpeed == nil or tonumber(_G.Xlu0AntiBypassLaggerAimbotSpeed) == 58 then _G.Xlu0AntiBypassLaggerAimbotSpeed = 40 end
local autoSwingEnabled = false
local mirrorTPDownEnabled = false
_G.Xlu0NormalAimbotOn = _G.Xlu0NormalAimbotOn or false
_G.Xlu0AntiBypassAimbotOn = _G.Xlu0AntiBypassAimbotOn or false
local antiDesyncAutoSwingEnabled = false
_G.Xlu0AntiDesyncAimbotOn = _G.Xlu0AntiDesyncAimbotOn or false
local ANTI_DESYNC_AIMBOT_SPEED = 58
local batCounterEnabled = false
local medCounterEnabled = false
local antiKickEnabled = false
local setSafeModeVisual = nil
local autoResetOnMedEnabled = false
local espEnabled = false
local showTracerEnabled = false
local ragdollCountdownEnabled = false
local fpsBoostEnabled = false
local antiLagVisualEnabled = false
local nukeOptimiserEnabled = false
local fovEnabled = false
local fovValue = 70
local noCamCollisionEnabled = false
_G.Xlu0NoPlayerCollisionEnabled = _G.Xlu0NoPlayerCollisionEnabled or false
local customFontVisualEnabled = false
_G.Xlu0CustomFontSelected = _G.Xlu0CustomFontSelected or "None"
local skyTheme = "Night"
local setPlayerESPVisual = nil
local setTracerESPVisual = nil
local setRagdollCountdownVisual = nil
local setFPSBoostVisual = nil
local setAntiLagVisual = nil
local setNukeOptimiserVisual = nil
local setFOVVisual = nil
local setNoCamCollisionVisual = nil
_G.Xlu0SetNoPlayerCollisionVisual = _G.Xlu0SetNoPlayerCollisionVisual or nil
local setCustomFontVisual = nil
local skyValueLabel = nil
local autoLeftEnabled = false
local autoRightEnabled = false
local DEFAULT_SPEED_KEYBINDS = {
SpeedToggle = Enum.KeyCode.Q,
LaggerToggle = Enum.KeyCode.R,
DropBrainrot = Enum.KeyCode.X,
Aimbot = Enum.KeyCode.E,
AntiDesyncAimbot = Enum.KeyCode.V,
AutoLeft = Enum.KeyCode.Z,
AutoRight = Enum.KeyCode.C,
InstantReset = Enum.KeyCode.T,
ToggleUI = Enum.KeyCode.LeftControl,
}
local DEFAULT_TP_DOWN_KEYBIND = Enum.KeyCode.F
local speedKeybinds = {
SpeedToggle = DEFAULT_SPEED_KEYBINDS.SpeedToggle,
LaggerToggle = DEFAULT_SPEED_KEYBINDS.LaggerToggle,
DropBrainrot = DEFAULT_SPEED_KEYBINDS.DropBrainrot,
Aimbot = DEFAULT_SPEED_KEYBINDS.Aimbot,
AntiDesyncAimbot = DEFAULT_SPEED_KEYBINDS.AntiDesyncAimbot,
AutoLeft = DEFAULT_SPEED_KEYBINDS.AutoLeft,
AutoRight = DEFAULT_SPEED_KEYBINDS.AutoRight,
InstantReset = DEFAULT_SPEED_KEYBINDS.InstantReset,
ToggleUI = DEFAULT_SPEED_KEYBINDS.ToggleUI,
}
local speedKeybindButtons = {}
local listeningForSpeedKey = nil
local autoTPEnabled = false
local autoTPHeight = 20
local autoTPConn = nil
local autoTPLastRun = 0
local autoTPClickDebounce = false
local tpDownKeybind = Enum.KeyCode.F
local tpDownKeybindButton = nil
local listeningForTPDownKey = false
local keybindListenStartedAt = 0
local setAutoTPVisual = nil
local function doAutoTPDown(force)
local char=LP.Character;if not char then return end
local hrp=char:FindFirstChild("HumanoidRootPart");if not hrp then return end
local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
if not force then
if hum2.FloorMaterial~=Enum.Material.Air then return end
if hrp.Position.Y<autoTPHeight then return end
end
hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z)
*CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0)
hrp.AssemblyLinearVelocity=Vector3.zero
end
local function _clearAutoTPConnection()
if autoTPConn then
pcall(function() autoTPConn:Disconnect() end)
pcall(function() task.cancel(autoTPConn) end)
autoTPConn = nil
end
end
local function startAutoTP()
autoTPEnabled = true
_clearAutoTPConnection()
autoTPLastRun = 0
autoTPConn = RunService.Heartbeat:Connect(function()
if not autoTPEnabled then
_clearAutoTPConnection()
return
end
local now = tick()
if now - autoTPLastRun < 0.1 then return end
autoTPLastRun = now
pcall(function() doAutoTPDown(false) end)
end)
if setAutoTPVisual then setAutoTPVisual(true) end
end
local function stopAutoTP()
autoTPEnabled = false
_clearAutoTPConnection()
if setAutoTPVisual then setAutoTPVisual(false) end
end
local function runTPFloor()
pcall(function() doAutoTPDown(true) end)
end
local function toggleAutoTP(on)
if on then
startAutoTP()
else
stopAutoTP()
end
do end
end
function _G.Xlu0StopAutoTPForAction()
if autoTPEnabled then
stopAutoTP()
pcall(function() if setAutoTPVisual then setAutoTPVisual(false) end end)
do end
end
end
local dropBrainrotActive = false
local _xlu0DropConns = {}

_G.Xlu0DropMode = (_G.Xlu0DropMode == "Jump Drop") and "Jump Drop" or "Stand Drop"

local function runStandDrop()
if dropBrainrotActive then return end
if _G.Xlu0StopAutoTPForAction then _G.Xlu0StopAutoTPForAction() end

for _, item in ipairs(_xlu0DropConns) do
if typeof(item) == "RBXScriptConnection" then
pcall(function() item:Disconnect() end)
elseif type(item) == "thread" then
pcall(coroutine.close, item)
end
end
_xlu0DropConns = {}

local char = LP.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
if not char or not root then return end

pcall(function() root.Anchored = false end)
local hum = char:FindFirstChildOfClass("Humanoid")
if hum then
pcall(function() hum.PlatformStand = false end)
pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
end

dropBrainrotActive = true
local changedCollisions = {}

local function cleanupDrop()
dropBrainrotActive = false
for _, item in ipairs(_xlu0DropConns) do
if typeof(item) == "RBXScriptConnection" then
pcall(function() item:Disconnect() end)
elseif type(item) == "thread" then
pcall(coroutine.close, item)
end
end
_xlu0DropConns = {}
for part, oldCanCollide in pairs(changedCollisions) do
if typeof(part) == "Instance" and part.Parent then
pcall(function() part.CanCollide = oldCanCollide end)
end
end
end

local collisionConn = RunService.Stepped:Connect(function()
if not dropBrainrotActive then return end
for _, player in ipairs(Players:GetPlayers()) do
if player ~= LP and player.Character then
for _, part in ipairs(player.Character:GetDescendants()) do
if part:IsA("BasePart") then
if changedCollisions[part] == nil then
changedCollisions[part] = part.CanCollide
end
pcall(function() part.CanCollide = false end)
end
end
end
end
end)
table.insert(_xlu0DropConns, collisionConn)

local flingThread = coroutine.create(function()
while dropBrainrotActive do
RunService.Heartbeat:Wait()
local currentChar = LP.Character
local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
if not currentRoot then break end
pcall(function() currentRoot.Anchored = false end)
local oldVelocity = currentRoot.Velocity
pcall(function()
currentRoot.Velocity = oldVelocity * 10000 + Vector3.new(0, 10000, 0)
end)
RunService.RenderStepped:Wait()
if currentRoot and currentRoot.Parent then
pcall(function() currentRoot.Velocity = oldVelocity end)
end
RunService.Stepped:Wait()
if currentRoot and currentRoot.Parent then
pcall(function() currentRoot.Velocity = oldVelocity + Vector3.new(0, 0.1, 0) end)
end
end
end)
table.insert(_xlu0DropConns, flingThread)
local ok = coroutine.resume(flingThread)
if not ok then
cleanupDrop()
return
end

task.delay(0.25, cleanupDrop)
end

_G.Xlu0JumpDropActive = false
_G.Xlu0JumpDropAscendDuration = 0.2
_G.Xlu0JumpDropAscendSpeed = 150

function _G.Xlu0RunJumpDrop()
if _G.Xlu0JumpDropActive then return end
if _G.Xlu0StopAutoTPForAction then pcall(_G.Xlu0StopAutoTPForAction) end

local char = LP.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
if not char or not root then return end

_G.Xlu0JumpDropActive = true
local startTime = tick()

_G.Xlu0JumpDropConn = RunService.Heartbeat:Connect(function()
local currentChar = LP.Character
local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")

if not currentChar or not currentRoot then
if _G.Xlu0JumpDropConn then
pcall(function() _G.Xlu0JumpDropConn:Disconnect() end)
_G.Xlu0JumpDropConn = nil
end
_G.Xlu0JumpDropActive = false
return
end

if tick() - startTime >= _G.Xlu0JumpDropAscendDuration then
if _G.Xlu0JumpDropConn then
pcall(function() _G.Xlu0JumpDropConn:Disconnect() end)
_G.Xlu0JumpDropConn = nil
end

local rayParams = RaycastParams.new()
rayParams.FilterDescendantsInstances = {currentChar}
rayParams.FilterType = Enum.RaycastFilterType.Exclude

local rayResult = workspace:Raycast(currentRoot.Position, Vector3.new(0, -2000, 0), rayParams)
if rayResult then
local hum = currentChar:FindFirstChildOfClass("Humanoid")
local offset = (hum and hum.HipHeight or 2) + (currentRoot.Size.Y / 2)
currentRoot.CFrame = CFrame.new(currentRoot.Position.X, rayResult.Position.Y + offset, currentRoot.Position.Z)
currentRoot.AssemblyLinearVelocity = Vector3.zero
currentRoot.AssemblyAngularVelocity = Vector3.zero
end

_G.Xlu0JumpDropActive = false
return
end

currentRoot.Velocity = Vector3.new(
currentRoot.Velocity.X,
_G.Xlu0JumpDropAscendSpeed,
currentRoot.Velocity.Z
)
end)
end

function runDrop()
if _G.Xlu0DropMode == "Jump Drop" then
_G.Xlu0RunJumpDrop()
else
runStandDrop()
end
end

function runDropBrainrot()
runDrop()
end

local infJumpEnabled = false
local antiRagdollEnabled = false
local antiRagdollConn = nil
_G.Xlu0AntiRagdollMode = (_G.Xlu0AntiRagdollMode == "V2") and "V2" or "V1"

_G.Xlu0AntiVoidEnabled = _G.Xlu0AntiVoidEnabled == true
_G.Xlu0AntiVoidConnection = _G.Xlu0AntiVoidConnection or nil
_G.Xlu0AntiVoidSafeCFrame = _G.Xlu0AntiVoidSafeCFrame or nil

function _G.Xlu0AntiVoidSaveSafe()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end
    if hum.FloorMaterial ~= Enum.Material.Air then
        _G.Xlu0AntiVoidSafeCFrame = root.CFrame
    end
end

function _G.Xlu0AntiVoidStop()
    if _G.Xlu0AntiVoidConnection then
        pcall(function() _G.Xlu0AntiVoidConnection:Disconnect() end)
        _G.Xlu0AntiVoidConnection = nil
    end
end

function _G.Xlu0AntiVoidSet(on)
    _G.Xlu0AntiVoidEnabled = on == true
    _G.Xlu0AntiVoidStop()
    if not _G.Xlu0AntiVoidEnabled then return end

    _G.Xlu0AntiVoidSaveSafe()

    _G.Xlu0AntiVoidConnection = RunService.Heartbeat:Connect(function()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not _G.Xlu0AntiVoidEnabled or not hum or not root or hum.Health <= 0 then return end

        local voidY = Workspace.FallenPartsDestroyHeight + 30
        if hum.FloorMaterial ~= Enum.Material.Air and root.Position.Y > voidY + 12 then
            _G.Xlu0AntiVoidSafeCFrame = root.CFrame
        elseif root.Position.Y <= voidY and _G.Xlu0AntiVoidSafeCFrame then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            root.CFrame = _G.Xlu0AntiVoidSafeCFrame + Vector3.new(0, 4, 0)
            hum.PlatformStand = false
            hum.Sit = false
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        end
    end)
end
local unwalkEnabled = false
local unwalkSavedAnimate = nil
local hitHarderAnimEnabled = false
local hitHarderOriginalAnims = {}
local selectedAnimationPack = "OFF"

local AnimationPacks = {
["Zombie"] = {
idle = {{"rbxassetid://616158929", 1}, {"rbxassetid://616160636", 1}},
walk = "rbxassetid://616168032",
run = "rbxassetid://616163682",
jump = "rbxassetid://616161997",
fall = "rbxassetid://616157476",
climb = "rbxassetid://616156119",
swim = "rbxassetid://616165109",
swimidle = "rbxassetid://616166655",
},
["Ninja"] = {
idle = {{"rbxassetid://656117400", 1}, {"rbxassetid://656117400", 1}},
walk = "rbxassetid://656121766",
run = "rbxassetid://656118852",
jump = "rbxassetid://656117878",
fall = "rbxassetid://656115606",
climb = "rbxassetid://656114359",
},
["Knight"] = {
idle = {{"rbxassetid://657595757", 1}, {"rbxassetid://657595757", 1}},
walk = "rbxassetid://657552124",
run = "rbxassetid://657564596",
jump = "rbxassetid://658409194",
fall = "rbxassetid://657600338",
climb = "rbxassetid://658360781",
},
["Elder"] = {
idle = {{"rbxassetid://845397899", 1}, {"rbxassetid://845397899", 1}},
walk = "rbxassetid://845403856",
run = "rbxassetid://845386501",
jump = "rbxassetid://845398858",
fall = "rbxassetid://845397673",
climb = "rbxassetid://845392038",
},
["Levitate"] = {
idle = {{"rbxassetid://616006778", 1}, {"rbxassetid://616006778", 1}},
walk = "rbxassetid://616013216",
run = "rbxassetid://616013216",
jump = "rbxassetid://616008936",
fall = "rbxassetid://616005863",
climb = "rbxassetid://616003713",
},
["Astronaut"] = {
idle = {{"rbxassetid://891621366", 1}, {"rbxassetid://891621366", 1}},
walk = "rbxassetid://891636393",
run = "rbxassetid://891636393",
jump = "rbxassetid://891627522",
fall = "rbxassetid://891617961",
climb = "rbxassetid://891609353",
},
["Pirate"] = {
idle = {{"rbxassetid://750781874", 1}, {"rbxassetid://750781874", 1}},
walk = "rbxassetid://750785693",
run = "rbxassetid://750783738",
jump = "rbxassetid://750782230",
fall = "rbxassetid://750780242",
climb = "rbxassetid://750779899",
},
["Toy"] = {
idle = {{"rbxassetid://782841498", 1}, {"rbxassetid://782841498", 1}},
walk = "rbxassetid://782843345",
run = "rbxassetid://782842708",
jump = "rbxassetid://782847020",
fall = "rbxassetid://782846423",
climb = "rbxassetid://782843869",
},
["Vampire"] = {
idle = {{"rbxassetid://1083445855", 1}, {"rbxassetid://1083445855", 1}},
walk = "rbxassetid://1083473930",
run = "rbxassetid://1083462077",
jump = "rbxassetid://1083455352",
fall = "rbxassetid://1083443587",
climb = "rbxassetid://1083439238",
},
["Werewolf"] = {
idle = {{"rbxassetid://1083195517", 1}, {"rbxassetid://1083195517", 1}},
walk = "rbxassetid://1083178339",
run = "rbxassetid://1083216690",
jump = "rbxassetid://1083218792",
fall = "rbxassetid://1083189019",
climb = "rbxassetid://1083182000",
},
["Rthro"] = {
idle = {{"rbxassetid://2510196951", 1}, {"rbxassetid://2510196951", 1}},
walk = "rbxassetid://2510202577",
run = "rbxassetid://2510198475",
jump = "rbxassetid://2510197830",
fall = "rbxassetid://2510195892",
climb = "rbxassetid://2510192778",
},
["Stylish"] = {
idle = {{"rbxassetid://616136790", 1}, {"rbxassetid://616136790", 1}},
walk = "rbxassetid://616146177",
run = "rbxassetid://616140816",
jump = "rbxassetid://616139451",
fall = "rbxassetid://616134815",
climb = "rbxassetid://616133594",
},
}

local AnimationPackList = {"OFF","Zombie","Ninja","Knight","Elder","Levitate","Astronaut","Pirate","Toy","Vampire","Werewolf","Rthro","Stylish"}
local AnimationPackIndex = 1
local OriginalAnims = {}
local animationPackValueLabel = nil
local refreshAnimationPackRow = nil

_G.Xlu0AnimationSystem = _G.Xlu0AnimationSystem or {
    conn = nil,
    original = nil,
    activePack = "OFF",
}

function _G.Xlu0AnimGetAnimate(char)
    char = char or LP.Character
    return char and char:FindFirstChild("Animate") or nil
end

function _G.Xlu0AnimReadOriginal(char)
    if _G.Xlu0AnimationSystem.original then return end
    local animate = _G.Xlu0AnimGetAnimate(char)
    if not animate then return end

    local function g(obj)
        return obj and obj.AnimationId or nil
    end

    _G.Xlu0AnimationSystem.original = {
        idle1 = g(animate.idle and animate.idle:FindFirstChild("Animation1")),
        idle2 = g(animate.idle and animate.idle:FindFirstChild("Animation2")),
        walk = g(animate.walk and animate.walk:FindFirstChild("WalkAnim")),
        run = g(animate.run and animate.run:FindFirstChild("RunAnim")),
        jump = g(animate.jump and animate.jump:FindFirstChild("JumpAnim")),
        fall = g(animate.fall and animate.fall:FindFirstChild("FallAnim")),
        climb = g(animate.climb and animate.climb:FindFirstChild("ClimbAnim")),
        swim = g(animate.swim and animate.swim:FindFirstChild("Swim")),
        swimidle = g(animate.swimidle and animate.swimidle:FindFirstChild("SwimIdle")),
    }
end

function _G.Xlu0AnimGetPack(packName)
    return AnimationPacks[packName]
end

function _G.Xlu0AnimApplyPack(char, packName)
    local animate = _G.Xlu0AnimGetAnimate(char)
    local pack = _G.Xlu0AnimGetPack(packName)
    if not animate or not pack then return false end

    local function s(obj, id)
        if obj and id then
            obj.AnimationId = tostring(id)
        end
    end

    s(animate.idle and animate.idle:FindFirstChild("Animation1"), pack.idle and pack.idle[1] and pack.idle[1][1])
    s(animate.idle and animate.idle:FindFirstChild("Animation2"), pack.idle and pack.idle[2] and pack.idle[2][1])
    s(animate.walk and animate.walk:FindFirstChild("WalkAnim"), pack.walk)
    s(animate.run and animate.run:FindFirstChild("RunAnim"), pack.run)
    s(animate.jump and animate.jump:FindFirstChild("JumpAnim"), pack.jump)
    s(animate.fall and animate.fall:FindFirstChild("FallAnim"), pack.fall)
    s(animate.climb and animate.climb:FindFirstChild("ClimbAnim"), pack.climb)
    s(animate.swim and animate.swim:FindFirstChild("Swim"), pack.swim)
    s(animate.swimidle and animate.swimidle:FindFirstChild("SwimIdle"), pack.swimidle)

    return true
end

function _G.Xlu0AnimRestore(char)
    local animate = _G.Xlu0AnimGetAnimate(char)
    local o = _G.Xlu0AnimationSystem.original
    if not animate or not o then return end

    local function s(obj,id)
        if obj and id then obj.AnimationId = id end
    end

    s(animate.idle and animate.idle:FindFirstChild("Animation1"), o.idle1)
    s(animate.idle and animate.idle:FindFirstChild("Animation2"), o.idle2)
    s(animate.walk and animate.walk:FindFirstChild("WalkAnim"), o.walk)
    s(animate.run and animate.run:FindFirstChild("RunAnim"), o.run)
    s(animate.jump and animate.jump:FindFirstChild("JumpAnim"), o.jump)
    s(animate.fall and animate.fall:FindFirstChild("FallAnim"), o.fall)
    s(animate.climb and animate.climb:FindFirstChild("ClimbAnim"), o.climb)
    s(animate.swim and animate.swim:FindFirstChild("Swim"), o.swim)
    s(animate.swimidle and animate.swimidle:FindFirstChild("SwimIdle"), o.swimidle)
end

function _G.Xlu0AnimStop()
    if _G.Xlu0AnimationSystem.conn then
        pcall(function() _G.Xlu0AnimationSystem.conn:Disconnect() end)
        _G.Xlu0AnimationSystem.conn = nil
    end

    _G.Xlu0AnimRestore(LP.Character)
    _G.Xlu0AnimationSystem.activePack = "OFF"
end

function _G.Xlu0AnimStart(packName)
    if packName == "OFF" then
        _G.Xlu0AnimStop()
        return
    end

    if _G.Xlu0AnimationSystem.conn then
        pcall(function() _G.Xlu0AnimationSystem.conn:Disconnect() end)
        _G.Xlu0AnimationSystem.conn = nil
    end

    local char = LP.Character
    if not char then return end

    local pack = _G.Xlu0AnimGetPack(packName)
    if not pack then return end

    _G.Xlu0AnimReadOriginal(char)
    _G.Xlu0AnimationSystem.activePack = packName

    -- Working Zombie Hub method: preload first.
    task.spawn(function()
        local list = {}
        for _, v in pairs(pack) do
            if type(v) == "string" then
                table.insert(list, v)
            elseif type(v) == "table" then
                for _, a in ipairs(v) do
                    if type(a) == "table" and a[1] then
                        table.insert(list, tostring(a[1]))
                    end
                end
            end
        end
        pcall(function()
            game:GetService("ContentProvider"):PreloadAsync(list)
        end)
    end)

    _G.Xlu0AnimApplyPack(char, packName)

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
            pcall(function() track:Stop(0) end)
        end
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end

    -- Core difference: continuously force the selected IDs just like Zombie Hub.
    _G.Xlu0AnimationSystem.conn = RunService.Heartbeat:Connect(function()
        if selectedAnimationPack == "OFF" then return end
        local c = LP.Character
        if c then
            _G.Xlu0AnimApplyPack(c, selectedAnimationPack)
        end
    end)
end

function syncAnimationPackIndex()
    local found = 1
    for i, name in ipairs(AnimationPackList) do
        if name == selectedAnimationPack then
            found = i
            break
        end
    end
    AnimationPackIndex = found
end

function applyAnimationPack(packName)
    selectedAnimationPack = packName or "OFF"
    syncAnimationPackIndex()

    if selectedAnimationPack == "OFF" then
        _G.Xlu0AnimStop()
    else
        _G.Xlu0AnimStart(selectedAnimationPack)
    end

    if refreshAnimationPackRow then
        pcall(refreshAnimationPackRow)
    end
end

-- Keep legacy names alive so existing UI/config code does not break.
enableUnwalk = function()
    selectedAnimationPack = "OFF"
    _G.Xlu0AnimStop()
end

disableUnwalk = function()
end

enableHitHarderAnim = function()
    applyAnimationPack("Zombie")
end

disableHitHarderAnim = function()
    applyAnimationPack("OFF")
end

resetAnimations = function()
    applyAnimationPack("OFF")
end

stopCurrentAnimations = function(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
        pcall(function() track:Stop(0) end)
    end
end

getAnimate = function(char)
    return _G.Xlu0AnimGetAnimate(char)
end

setAnimId = function(obj,id)
    if obj and id then obj.AnimationId = tostring(id) end
end

reloadAnimate = function(animate)
    if not animate then return end
    pcall(function()
        animate.Disabled = true
        task.wait()
        animate.Disabled = false
    end)
end

backupAnimations = function(char)
    _G.Xlu0AnimReadOriginal(char)
end

LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    _G.Xlu0AnimationSystem.original = nil
    if selectedAnimationPack and selectedAnimationPack ~= "OFF" then
        _G.Xlu0AnimStart(selectedAnimationPack)
    end
end)

local antiRagdollResetCooldown = 0

local function forceAntiRagdollReset()
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

        local playerModule = LP:FindFirstChild("PlayerScripts")
            and LP.PlayerScripts:FindFirstChild("PlayerModule")
        if playerModule then
            local ok, controlModule = pcall(function()
                return require(playerModule:FindFirstChild("ControlModule"))
            end)
            if ok and controlModule then
                pcall(function() controlModule:Enable() end)
            end
        end

        hum.AutoRotate = true
        hum.PlatformStand = false
        hum.Sit = false
    end)
end


_G.Xlu0AntiRagdollV2Conn = _G.Xlu0AntiRagdollV2Conn or nil
_G.Xlu0AntiRagdollV2Cooldown = _G.Xlu0AntiRagdollV2Cooldown or 0

function _G.Xlu0StopAntiRagdollV2()
if _G.Xlu0AntiRagdollV2Conn then
pcall(function() _G.Xlu0AntiRagdollV2Conn:Disconnect() end)
_G.Xlu0AntiRagdollV2Conn = nil
end
_G.Xlu0AntiRagdollV2Cooldown = 0
end

function _G.Xlu0StartAntiRagdollV2()
_G.Xlu0StopAntiRagdollV2()

_G.Xlu0AntiRagdollV2Conn = RunService.Heartbeat:Connect(function()
if not antiRagdollEnabled or _G.Xlu0AntiRagdollMode ~= "V2" then return end

local char = LP.Character
if not char then return end

local hum = char:FindFirstChildOfClass("Humanoid")
local root = char:FindFirstChild("HumanoidRootPart")
if not hum or not root or hum.Health <= 0 then return end

local state = hum:GetState()
local now = tick()

if state == Enum.HumanoidStateType.Physics
or state == Enum.HumanoidStateType.Ragdoll
or state == Enum.HumanoidStateType.FallingDown then

if now - (_G.Xlu0AntiRagdollV2Cooldown or 0) > 0.15 then
_G.Xlu0AntiRagdollV2Cooldown = now

pcall(function()
hum:ChangeState(Enum.HumanoidStateType.GettingUp)

root.Velocity = Vector3.zero
root.RotVelocity = Vector3.zero
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero

for _, obj in ipairs(char:GetDescendants()) do
if obj:IsA("Motor6D") then
obj.Enabled = true
end
end

for _, obj in ipairs(char:GetDescendants()) do
if obj:IsA("Constraint") then
obj.Enabled = true
end
end

workspace.CurrentCamera.CameraSubject = hum

local PM = LP.PlayerScripts:FindFirstChild("PlayerModule")
if PM then
local CM = PM:FindFirstChild("ControlModule")
if CM then
local ok, controls = pcall(require, CM)
if ok and controls and controls.Enable then
pcall(function() controls:Enable() end)
end
end
end

hum.AutoRotate = true
hum.PlatformStand = false
hum.Sit = false
end)
end
end
end)
end

local function startAntiRagdoll()
    if antiRagdollConn then return end
    antiRagdollEnabled = true
    antiRagdollConn = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end

        local state = hum:GetState()
        local isRagdolled = (
            state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
        )

        if isRagdolled then
            local now = tick()
            if now - antiRagdollResetCooldown > 0.15 then
                antiRagdollResetCooldown = now
                forceAntiRagdollReset()
            end
        end
    end)
end

local function stopAntiRagdoll()
if antiRagdollConn then
antiRagdollConn:Disconnect()
antiRagdollConn = nil
end
end
local function setAntiRagdoll(on)
antiRagdollEnabled = on and true or false

stopAntiRagdoll()
_G.Xlu0StopAntiRagdollV2()

if not antiRagdollEnabled then return end

if _G.Xlu0AntiRagdollMode == "V2" then
_G.Xlu0StartAntiRagdollV2()
else
startAntiRagdoll()
end
end
_G.Xlu0NormalInfJump = _G.Xlu0NormalInfJump or {holdPressed=false, holdActive=false, controllerActive=false, mobilePressed=false, mobileActive=false, hooked={}}
_G.Xlu0InfJumpMode = (_G.Xlu0InfJumpMode == "Hold") and "Hold" or "Tap"
function _G.Xlu0StopNormalInfJumpHoldState()
local S = _G.Xlu0NormalInfJump
S.holdPressed = false
S.holdActive = false
S.controllerActive = false
S.mobilePressed = false
S.mobileActive = false
end
function _G.Xlu0ApplyNormalInfJumpBoost(boost)
if not infJumpEnabled then return end
local char = LP.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
local hum = char and char:FindFirstChildOfClass("Humanoid")
if not root or not hum or hum.Health <= 0 then return end
root.Velocity = Vector3.new(root.Velocity.X, boost or 50, root.Velocity.Z)
end
UserInputService.JumpRequest:Connect(function()
_G.Xlu0ApplyNormalInfJumpBoost(50)
end)
UserInputService.InputBegan:Connect(function(input)
if UserInputService:GetFocusedTextBox() then return end
local S = _G.Xlu0NormalInfJump
if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
S.holdPressed = true
task.delay(0.12, function()
if _G.Xlu0InfJumpMode == "Hold" and _G.Xlu0NormalInfJump.holdPressed and infJumpEnabled then
_G.Xlu0NormalInfJump.holdActive = true
_G.Xlu0ApplyNormalInfJumpBoost(50)
end
end)
elseif input.KeyCode == Enum.KeyCode.ButtonA and input.UserInputType.Name:match("^Gamepad") then
S.controllerActive = (_G.Xlu0InfJumpMode == "Hold")
end
end)
UserInputService.InputEnded:Connect(function(input)
local S = _G.Xlu0NormalInfJump
if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
S.holdPressed = false
S.holdActive = false
end
if input.KeyCode == Enum.KeyCode.ButtonA and input.UserInputType.Name:match("^Gamepad") then
S.controllerActive = false
end
end)
function _G.Xlu0HookNormalInfMobileJumpButton(obj)
local S = _G.Xlu0NormalInfJump
if not obj or obj.Name ~= "JumpButton" or not obj:IsA("GuiButton") or S.hooked[obj] then return end
S.hooked[obj] = true
obj.InputBegan:Connect(function(input)
if input.UserInputType ~= Enum.UserInputType.Touch or not infJumpEnabled then return end
_G.Xlu0NormalInfJump.mobilePressed = true
task.delay(0.12, function()
if _G.Xlu0InfJumpMode == "Hold" and _G.Xlu0NormalInfJump.mobilePressed and infJumpEnabled then
_G.Xlu0NormalInfJump.mobileActive = true
_G.Xlu0ApplyNormalInfJumpBoost(50)
end
end)
end)
obj.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.Touch then
_G.Xlu0NormalInfJump.mobilePressed = false
_G.Xlu0NormalInfJump.mobileActive = false
end
end)
obj.AncestryChanged:Connect(function(_, parent)
if not parent then
_G.Xlu0NormalInfJump.hooked[obj] = nil
_G.Xlu0NormalInfJump.mobilePressed = false
_G.Xlu0NormalInfJump.mobileActive = false
end
end)
end
for _, obj in ipairs(PlayerGui:GetDescendants()) do
_G.Xlu0HookNormalInfMobileJumpButton(obj)
end
PlayerGui.DescendantAdded:Connect(function(obj)
task.defer(_G.Xlu0HookNormalInfMobileJumpButton, obj)
end)
RunService.Heartbeat:Connect(function()
local S = _G.Xlu0NormalInfJump
if infJumpEnabled and _G.Xlu0InfJumpMode == "Hold" and (S.holdActive or S.mobileActive or S.controllerActive) then
_G.Xlu0ApplyNormalInfJumpBoost(50)
end
end)
setInfJumpInternal = function(on)
infJumpEnabled = on and true or false
if not infJumpEnabled then
_G.Xlu0StopNormalInfJumpHoldState()
end
end

_G.Xlu0AntiResetEnabled = _G.Xlu0AntiResetEnabled == true

function _G.Xlu0ApplyAntiReset()
    pcall(function()
        StarterGui:SetCore("ResetButtonCallback", false)
    end)
end

function _G.Xlu0RestoreReset()
    pcall(function()
        StarterGui:SetCore("ResetButtonCallback", true)
    end)
end

function _G.Xlu0SetAntiReset(on)
    _G.Xlu0AntiResetEnabled = on == true

    if _G.Xlu0AntiResetEnabled then
        -- SetCore may fail before CoreScripts are ready, retry a few times.
        task.spawn(function()
            for _ = 1, 12 do
                if not _G.Xlu0AntiResetEnabled then return end
                _G.Xlu0ApplyAntiReset()
                task.wait(0.25)
            end
        end)
    else
        _G.Xlu0RestoreReset()
    end
end


-- Extra Anti Die protection for reset/death requests
_G.Xlu0AntiDieHealthConn = _G.Xlu0AntiDieHealthConn or nil
_G.Xlu0AntiDieCharConn = _G.Xlu0AntiDieCharConn or nil

function _G.Xlu0HookAntiDieCharacter(char)
    if _G.Xlu0AntiDieHealthConn then
        pcall(function() _G.Xlu0AntiDieHealthConn:Disconnect() end)
        _G.Xlu0AntiDieHealthConn = nil
    end

    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    _G.Xlu0AntiDieHealthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not _G.Xlu0AntiResetEnabled then return end
        if hum.Health <= 0 then
            pcall(function()
                hum.Health = 1
                hum.PlatformStand = false
                hum.Sit = false
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end)
        end
    end)
end

if _G.Xlu0AntiDieCharConn then
    pcall(function() _G.Xlu0AntiDieCharConn:Disconnect() end)
end
_G.Xlu0AntiDieCharConn = LP.CharacterAdded:Connect(function(char)
    task.wait(0.2)
    _G.Xlu0HookAntiDieCharacter(char)

    if _G.Xlu0RestoreAntiDieAfterReset then
        _G.Xlu0RestoreAntiDieAfterReset = false
        task.wait(0.35)
        _G.Xlu0SetAntiReset(true)
        if _G.Xlu0AntiResetVisual then
            pcall(function() _G.Xlu0AntiResetVisual(true) end)
        end
        do end
    end
end)

if LP.Character then
    task.defer(function()
        _G.Xlu0HookAntiDieCharacter(LP.Character)
    end)
end


_G.Xlu0HeadlessEnabled = _G.Xlu0HeadlessEnabled == true
_G.Xlu0KorbloxEnabled = _G.Xlu0KorbloxEnabled == true
_G.Xlu0HeadlessMeshId = "rbxassetid://1095708"
_G.Xlu0KorbloxMeshId = "rbxassetid://101851696"
_G.Xlu0KorbloxTextureId = "rbxassetid://101851254"

function _G.Xlu0ApplyHeadless(char, enabled)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    if enabled then
        head.Transparency = 1
        head.CanCollide = false
        local face = head:FindFirstChild("face")
        if face then face:Destroy() end

        local old = head:FindFirstChild("Xlu0HeadlessMesh")
        if old then old:Destroy() end

        local mesh = Instance.new("SpecialMesh")
        mesh.Name = "Xlu0HeadlessMesh"
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = _G.Xlu0HeadlessMeshId
        mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
        mesh.Parent = head
    else
        head.Transparency = 0
        head.CanCollide = true
        local old = head:FindFirstChild("Xlu0HeadlessMesh")
        if old then old:Destroy() end
    end
end

function _G.Xlu0ApplyKorblox(char, enabled)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    if hum.RigType == Enum.HumanoidRigType.R6 then
        local leg = char:FindFirstChild("Right Leg")
        if not leg then return end

        local old = leg:FindFirstChild("Xlu0KorbloxMesh")
        if old then old:Destroy() end

        if enabled then
            leg.Color = Color3.fromRGB(64,64,64)
            local mesh = Instance.new("SpecialMesh")
            mesh.Name = "Xlu0KorbloxMesh"
            mesh.MeshType = Enum.MeshType.FileMesh
            mesh.MeshId = _G.Xlu0KorbloxMeshId
            mesh.TextureId = _G.Xlu0KorbloxTextureId
            mesh.Scale = Vector3.new(1,1,1)
            mesh.Parent = leg
        else
            leg.Color = Color3.fromRGB(255,255,255)
        end
    else
        local upper = char:FindFirstChild("RightUpperLeg")
        local lower = char:FindFirstChild("RightLowerLeg")
        local foot = char:FindFirstChild("RightFoot")
        if not upper then return end

        local oldLeg = char:FindFirstChild("Xlu0KorbloxLeg")
        if oldLeg then oldLeg:Destroy() end

        if enabled then
            upper.Transparency = 1
            if lower then lower.Transparency = 1 end
            if foot then foot.Transparency = 1 end

            local kleg = Instance.new("Part")
            kleg.Name = "Xlu0KorbloxLeg"
            kleg.Size = Vector3.new(1,2,1)
            kleg.Anchored = false
            kleg.CanCollide = false
            kleg.Massless = true
            kleg.Color = Color3.fromRGB(64,64,64)
            kleg.Parent = char

            local mesh = Instance.new("SpecialMesh")
            mesh.Name = "Xlu0KorbloxMesh"
            mesh.MeshType = Enum.MeshType.FileMesh
            mesh.MeshId = _G.Xlu0KorbloxMeshId
            mesh.TextureId = _G.Xlu0KorbloxTextureId
            mesh.Scale = Vector3.new(1,1,1)
            mesh.Parent = kleg

            local weld = Instance.new("Weld")
            weld.Name = "Xlu0KorbloxWeld"
            weld.Part0 = upper
            weld.Part1 = kleg
            weld.C0 = CFrame.new(0,-0.8,0)
            weld.Parent = kleg
        else
            upper.Transparency = 0
            if lower then lower.Transparency = 0 end
            if foot then foot.Transparency = 0 end
        end
    end
end

function _G.Xlu0ApplyCharacterVisuals(char)
    char = char or LP.Character
    if not char then return end
    pcall(function() _G.Xlu0ApplyHeadless(char, _G.Xlu0HeadlessEnabled) end)
    pcall(function() _G.Xlu0ApplyKorblox(char, _G.Xlu0KorbloxEnabled) end)
end


_G.Xlu0AutoInstantResetOnDeath = _G.Xlu0AutoInstantResetOnDeath == true
_G.Xlu0AutoInstantResetDeathConns = _G.Xlu0AutoInstantResetDeathConns or {}
_G.Xlu0AutoInstantResetBusy = false

function _G.Xlu0StopAutoInstantResetDeathWatch()
for _, c in ipairs(_G.Xlu0AutoInstantResetDeathConns) do
pcall(function() c:Disconnect() end)
end
_G.Xlu0AutoInstantResetDeathConns = {}
end

function _G.Xlu0FireAutoInstantReset()
if not _G.Xlu0AutoInstantResetOnDeath then return end
if _G.Xlu0AutoInstantResetBusy then return end
_G.Xlu0AutoInstantResetBusy = true

task.defer(function()
-- Anti Die açıksa resetin gerçekleşebilmesi için geçici kapat.
local restoreAntiDie = _G.Xlu0AntiResetEnabled == true
if restoreAntiDie then
_G.Xlu0RestoreAntiDieAfterReset = true
_G.Xlu0SetAntiReset(false)
if _G.Xlu0AntiResetVisual then
pcall(function() _G.Xlu0AntiResetVisual(false) end)
end
end

task.wait(0.03)

if _G.Xlu0CursedInstaReset then
pcall(_G.Xlu0CursedInstaReset)
elseif cursedInstaReset then
pcall(cursedInstaReset)
elseif _G.Xlu0AutoResetCursedInstaReset then
pcall(_G.Xlu0AutoResetCursedInstaReset)
end

task.wait(0.8)
_G.Xlu0AutoInstantResetBusy = false
end)
end

function _G.Xlu0StartAutoInstantResetDeathWatch(char)
_G.Xlu0StopAutoInstantResetDeathWatch()
if not _G.Xlu0AutoInstantResetOnDeath then return end

char = char or LP.Character
if not char then return end

local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
if hum then
table.insert(_G.Xlu0AutoInstantResetDeathConns,
hum.Died:Connect(function()
_G.Xlu0FireAutoInstantReset()
end))

table.insert(_G.Xlu0AutoInstantResetDeathConns,
hum:GetPropertyChangedSignal("Health"):Connect(function()
if hum.Health <= 0 then
_G.Xlu0FireAutoInstantReset()
end
end))
end

table.insert(_G.Xlu0AutoInstantResetDeathConns,
char.AncestryChanged:Connect(function(_, parent)
if not parent then
_G.Xlu0FireAutoInstantReset()
end
end))
end

function _G.Xlu0SetAutoInstantResetOnDeath(on)
_G.Xlu0AutoInstantResetOnDeath = on == true
if _G.Xlu0AutoInstantResetOnDeath then
_G.Xlu0StartAutoInstantResetDeathWatch(LP.Character)
else
_G.Xlu0StopAutoInstantResetDeathWatch()
end
if saveXlu0Config then do end end
end

LP.CharacterAdded:Connect(function(char)
if _G.Xlu0AutoInstantResetOnDeath then
task.wait(0.2)
_G.Xlu0StartAutoInstantResetDeathWatch(char)
end
end)


_G.Xlu0BodyLockEnabled = _G.Xlu0BodyLockEnabled == true
_G.Xlu0BodyLockRadius = tonumber(_G.Xlu0BodyLockRadius) or 60
_G.Xlu0BodyLockConn = _G.Xlu0BodyLockConn or nil

function _G.Xlu0GetNearestBodyLockTarget()
local character = LP.Character
local root = character and character:FindFirstChild("HumanoidRootPart")
if not root then return nil end

local nearest = nil
local shortest = math.huge

for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
local tr = plr.Character:FindFirstChild("HumanoidRootPart")
local hum = plr.Character:FindFirstChildOfClass("Humanoid")
if tr and hum and hum.Health > 0 then
local d = (tr.Position - root.Position).Magnitude
if d <= (_G.Xlu0BodyLockRadius or 60) and d < shortest then
shortest = d
nearest = plr
end
end
end
end

return nearest
end

function _G.Xlu0StartBodyLock()
if _G.Xlu0BodyLockConn then return end
_G.Xlu0BodyLockEnabled = true

_G.Xlu0BodyLockConn = RunService.Heartbeat:Connect(function()
if not _G.Xlu0BodyLockEnabled then return end

local character = LP.Character
local myRoot = character and character:FindFirstChild("HumanoidRootPart")
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if not myRoot or not humanoid or humanoid.Health <= 0 then return end

local target = _G.Xlu0GetNearestBodyLockTarget()
if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
local targetPos = target.Character.HumanoidRootPart.Position
local myPos = myRoot.Position
local offset = Vector3.new(targetPos.X, myPos.Y, targetPos.Z) - myPos

if offset.Magnitude > 0.1 then
humanoid.AutoRotate = false
local lookDir = offset.Unit
local currentDir = myRoot.CFrame.LookVector
local cross = currentDir:Cross(lookDir)
local currentVel = myRoot.AssemblyAngularVelocity
myRoot.AssemblyAngularVelocity = Vector3.new(currentVel.X, cross.Y * 40, currentVel.Z)
end
else
humanoid.AutoRotate = true
end
end)
end

function _G.Xlu0StopBodyLock()
_G.Xlu0BodyLockEnabled = false

if _G.Xlu0BodyLockConn then
pcall(function() _G.Xlu0BodyLockConn:Disconnect() end)
_G.Xlu0BodyLockConn = nil
end

local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
if hum then
hum.AutoRotate = true
end
end

function _G.Xlu0SetBodyLock(on)
_G.Xlu0BodyLockEnabled = on == true
if _G.Xlu0BodyLockEnabled then
_G.Xlu0StartBodyLock()
else
_G.Xlu0StopBodyLock()
end

if _G.Xlu0BodyLockVisual then
pcall(function() _G.Xlu0BodyLockVisual(_G.Xlu0BodyLockEnabled) end)
end
end

LP.CharacterAdded:Connect(function()
if _G.Xlu0BodyLockEnabled then
task.wait(0.3)
_G.Xlu0StopBodyLock()
_G.Xlu0StartBodyLock()
end
end)

local currentBackground = 0
local aceGuiScaleValue = Xlu0AutoMobile and 0.67 or 1.00
local aceProgressBarScaleValue = Xlu0AutoMobile and 0.83 or 1.00
CONFIG_FILE = "Xlu0Duels_MainGUI_Config_DefaultsV2.json"
KEYBINDS_CONFIG_FILE = "Xlu0Duels_Keybinds_DefaultsV2.json"
_ace_isfile = isfile or (syn and syn.isfile) or function(path)
local ok, result = pcall(function() return readfile(path) end)
return ok and result ~= nil
end
_ace_readfile = readfile or (syn and syn.readfile)
_ace_writefile = writefile or (syn and syn.writefile)
canSaveConfig = (type(_ace_readfile) == "function" and type(_ace_writefile) == "function")

--// Xlu0 Duels Intro + Songs (ported from old source only)
selectedIntroMusic = 4 -- Intro music fixed to Song 4
_introEnabled = (_introEnabled ~= false)
setIntroVisual = nil
setIntroSongVisual = nil
INTRO_MUSIC_OPTIONS = INTRO_MUSIC_OPTIONS or {
{name="Song 1", url="https://files.catbox.moe/mzvrir.mp3", file="Xlu0DuelsIntroSong_1.mp3"},
{name="Song 2", url="https://files.catbox.moe/2a7jyx.mp3", file="Xlu0DuelsIntroSong_2.mp3"},
{name="Song 3", url="https://files.catbox.moe/rcgr9f.mp3", file="Xlu0DuelsIntroSong_3.mp3"},
{name="Song 4", url="https://files.catbox.moe/iknfuh.mp3", file="Xlu0DuelsIntroSong_4.mp3"},
{name="Song 5", url="https://files.catbox.moe/6eigoh.mp3", file="Xlu0DuelsIntroSong_5.mp3"},
{name="Song 6", url="https://files.catbox.moe/dvjtjk.mp3", file="Xlu0DuelsIntroSong_6.mp3"},
{name="Song 7", url="https://files.catbox.moe/iyw1cb.mp3", file="Xlu0DuelsIntroSong_7.mp3"},
}
function getIntroSongName()
local opt = INTRO_MUSIC_OPTIONS[selectedIntroMusic]
return opt and opt.name or "No Songs Added"
end
introPreviewSound = nil
introPlaybackSound = nil
introPreviewToken = 0
introPlaybackToken = 0
introSongCache = introSongCache or {}
introSongDownloading = introSongDownloading or {}
function stopIntroPreview()
introPreviewToken = introPreviewToken + 1
if introPreviewSound then
pcall(function() introPreviewSound:Stop() end)
pcall(function() introPreviewSound:Destroy() end)
introPreviewSound = nil
end
end
function stopIntroPlayback()
introPlaybackToken = introPlaybackToken + 1
if introPlaybackSound then
pcall(function() introPlaybackSound:Stop() end)
pcall(function() introPlaybackSound:Destroy() end)
introPlaybackSound = nil
end
end
function _safeNotify(msg)
if showActionNotification then pcall(function() showActionNotification(msg) end) end
end
function cacheIntroSong(option, allowDownload)
if not option or not option.url or option.url == "" then return nil end
if not (writefile and getcustomasset) then return nil end
local fileName = option.file or ("Xlu0DuelsIntroSong_" .. tostring(option.name or "song") .. ".mp3")
local function loadExisting()
if introSongCache[fileName] then return introSongCache[fileName] end
local hasFile = false
pcall(function() hasFile = isfile and isfile(fileName) end)
if hasFile then
local ok = pcall(function() introSongCache[fileName] = getcustomasset(fileName) end)
if ok and introSongCache[fileName] then return introSongCache[fileName] end
end
return nil
end
local cached = loadExisting()
if cached then return cached end
if allowDownload == false then return nil end
if introSongDownloading[fileName] then
local waitStart = tick()
while introSongDownloading[fileName] and tick() - waitStart < 12 do task.wait(0.05) end
cached = loadExisting()
if cached then return cached end
end
introSongDownloading[fileName] = true
local ok = pcall(function()
local data = game:HttpGet(option.url)
if data and #data > 0 then
writefile(fileName, data)
introSongCache[fileName] = getcustomasset(fileName)
end
end)
introSongDownloading[fileName] = nil
if ok and introSongCache[fileName] then return introSongCache[fileName] end
return loadExisting()
end
function preloadIntroSongs()
task.spawn(function()
cacheIntroSong(INTRO_MUSIC_OPTIONS[selectedIntroMusic], true)
for _, option in ipairs(INTRO_MUSIC_OPTIONS) do
if option ~= INTRO_MUSIC_OPTIONS[selectedIntroMusic] then
cacheIntroSong(option, true)
task.wait(0.05)
end
end
end)
end
function makeIntroSoundFromId(soundId, name, parent)
if not soundId then return nil end
local sound = Instance.new("Sound")
sound.Name = name or "Xlu0DuelsIntroMusic"
sound.Volume = 0.65
sound.Looped = false
sound.SoundId = soundId
sound.Parent = parent or SoundService
return sound
end
function createIntroSound(option, fileName, parent, allowDownload)
if not option then return nil end
local soundId = cacheIntroSong(option, allowDownload)
if not soundId then return nil end
return makeIntroSoundFromId(soundId, fileName, parent)
end
function previewIntroMusic(index)
stopIntroPreview()
stopIntroPlayback()
if not INTRO_MUSIC_OPTIONS[index] then _safeNotify("ADD SONG LINKS"); return end
local token = introPreviewToken
task.spawn(function()
local option = INTRO_MUSIC_OPTIONS[index]
local sound = createIntroSound(option, "Xlu0DuelsIntroPreview_" .. tostring(token), SoundService, true)
if token ~= introPreviewToken then if sound then sound:Destroy() end; return end
introPreviewSound = sound
if not sound then _safeNotify("SONG LOADING..."); return end
sound.TimePosition = 0
pcall(function() sound:Play() end)
task.delay(15, function() if token == introPreviewToken then stopIntroPreview() end end)
end)
end
function playIntroMusic()
stopIntroPreview()
stopIntroPlayback()
if not _introEnabled then return end
local option = INTRO_MUSIC_OPTIONS[selectedIntroMusic]
if not option then return end
local token = introPlaybackToken
task.spawn(function()
local sound = createIntroSound(option, "Xlu0DuelsIntroMusic_" .. tostring(token), SoundService, true)
if token ~= introPlaybackToken or not _introEnabled then if sound then pcall(function() sound:Destroy() end) end; return end
introPlaybackSound = sound
if not sound then _safeNotify("SONG FAILED"); return end
sound.TimePosition = 0
local loadStart = tick()
while sound and not sound.IsLoaded and tick() - loadStart < 10 do task.wait(0.05) end
pcall(function() sound:Play() end)
task.delay(15, function() if token == introPlaybackToken then stopIntroPlayback() end end)
end)
end
preloadIntroSongs()

savedConfig = {}
_G.Xlu0GuiLocked = _G.Xlu0GuiLocked == true
if _G.Xlu0HideMobileButtons == nil then
_G.Xlu0HideMobileButtons = not Xlu0AutoMobile
else
_G.Xlu0HideMobileButtons = _G.Xlu0HideMobileButtons == true
_G.Xlu0MobileButtonScale = tonumber(_G.Xlu0MobileButtonScale) or 0.75
end
_G.Xlu0MobileButtonScale = Xlu0AutoMobile and 0.90 or 1.00
_G.Xlu0MobileButtonPositions = _G.Xlu0MobileButtonPositions or {}
_G.Xlu0MobileButtonImage = _G.Xlu0MobileButtonImage or ""
_G.Xlu0MobileButtonShape = _G.Xlu0MobileButtonShape or "ROUNDED"
_G.Xlu0StealUIImage = _G.Xlu0StealUIImage or ""
savedMainPositionTable = nil
savedMiniPositionTable = nil
function udim2ToTable(u)
return {xs = u.X.Scale, xo = u.X.Offset, ys = u.Y.Scale, yo = u.Y.Offset}
end
function tableToUDim2(t, fallback)
if type(t) == "table" then
return UDim2.new(tonumber(t.xs) or 0, tonumber(t.xo) or 0, tonumber(t.ys) or 0, tonumber(t.yo) or 0)
end
return fallback
end
function collectXlu0MobileButtonPositions()
local out = {}
for key, entry in pairs(_G.Xlu0MobileButtonRefs or {}) do
local holder = entry and entry.holder
if holder then out[key] = udim2ToTable(holder.Position) end
end
if next(out) == nil and type(_G.Xlu0MobileButtonPositions) == "table" then
return _G.Xlu0MobileButtonPositions
end
_G.Xlu0MobileButtonPositions = out
return out
end
function keyToString(key)
if not key then return "None" end
return tostring(key):gsub("Enum.KeyCode.", "")
end
function stringToKeyCode(value)
if type(value) ~= "string" or value == "" or value == "None" then return nil end
return Enum.KeyCode[value]
end
function keybindsToTable()
local out = {}
for keyId in pairs(DEFAULT_SPEED_KEYBINDS) do
out[keyId] = keyToString(speedKeybinds[keyId])
end
for keyId, key in pairs(speedKeybinds) do
out[keyId] = keyToString(key)
end
return out
end
function collectXlu0KeybindConfig()
return {
keybinds = keybindsToTable(),
tpDownKeybind = keyToString(tpDownKeybind),
}
end
function applySavedKeybinds(t)
if type(t) ~= "table" then return end
for keyId in pairs(speedKeybinds) do
if t[keyId] ~= nil then
speedKeybinds[keyId] = stringToKeyCode(t[keyId])
end
end
end
function applyDefaultXlu0Keybinds()
for keyId, key in pairs(DEFAULT_SPEED_KEYBINDS) do
speedKeybinds[keyId] = key
end
tpDownKeybind = DEFAULT_TP_DOWN_KEYBIND
end
function collectXlu0Config()
return {
mainPosition = savedMainPositionTable,
keybinds = keybindsToTable(),
tpDownKeybind = keyToString(tpDownKeybind),
NS = NS,
CS = CS,
LAGGER_SPEED = LAGGER_SPEED,
LAGGER_CARRY_SPEED = LAGGER_CARRY_SPEED,
currentSpeedMode = currentSpeedMode,
dropMode = _G.Xlu0DropMode,
autoCarrySpeedEnabled = autoCarrySpeedEnabled == true,
autoTPEnabled = autoTPEnabled,
autoTPHeight = autoTPHeight,
infJumpEnabled = infJumpEnabled,
infJumpMode = _G.Xlu0InfJumpMode,
antiRagdollEnabled = antiRagdollEnabled,
antiRagdollMode = _G.Xlu0AntiRagdollMode,
antiVoidEnabled = _G.Xlu0AntiVoidEnabled == true,
antiResetEnabled = _G.Xlu0AntiResetEnabled == true,
selectedAnimationPack = selectedAnimationPack,
selectedMoreAnimationBundle = _G.Xlu0SelectedMoreAnimationBundle,
selectedStealMode = selectedStealMode,
autoStealEnabled = autoStealEnabled,
autoStealRadius = autoStealRadius,
aceStealRadii = _G.Xlu0StealRadii,
selectedAimbotMode = selectedAimbotMode,
AIMBOT_SPEED = AIMBOT_SPEED,
LAGGER_AIMBOT_SPEED = LAGGER_AIMBOT_SPEED,
ANTI_BYPASS_AIMBOT_SPEED = _G.Xlu0AntiBypassAimbotSpeed,
ANTI_BYPASS_LAGGER_AIMBOT_SPEED = _G.Xlu0AntiBypassLaggerAimbotSpeed,
ANTI_DESYNC_AIMBOT_SPEED = ANTI_DESYNC_AIMBOT_SPEED,
autoSwingEnabled = autoSwingEnabled,
mirrorTPDownEnabled = mirrorTPDownEnabled,
normalAimbotEnabled = _G.Xlu0NormalAimbotOn == true,
antiBypassAimbotEnabled = _G.Xlu0AntiBypassAimbotOn == true,
antiDesyncAutoSwingEnabled = antiDesyncAutoSwingEnabled,
antiDesyncAimbotEnabled = _G.Xlu0AntiDesyncAimbotOn == true,
batCounterEnabled = batCounterEnabled,
medCounterEnabled = medCounterEnabled,
safeMode = antiKickEnabled == true,
autoResetOnMedEnabled = autoResetOnMedEnabled,
espEnabled = espEnabled,
showTracerEnabled = showTracerEnabled,
ragdollCountdownEnabled = false,
fpsBoostEnabled = fpsBoostEnabled,
antiLagVisualEnabled = antiLagVisualEnabled,
nukeOptimiserEnabled = nukeOptimiserEnabled,
fovEnabled = fovEnabled,
fovValue = fovValue,
noCamCollisionEnabled = noCamCollisionEnabled,
noPlayerCollisionEnabled = _G.Xlu0NoPlayerCollisionEnabled,
customFontVisualEnabled = (_G.Xlu0CustomFontSelected or "None") ~= "None",
customFontSelected = _G.Xlu0CustomFontSelected or "None",
skyTheme = skyTheme,
autoLeftEnabled = autoLeftEnabled,
autoRightEnabled = autoRightEnabled,
currentBackground = currentBackground,
bodyLockEnabled = _G.Xlu0BodyLockEnabled == true,
bodyLockRadius = tonumber(_G.Xlu0BodyLockRadius) or 60,
mobileButtonScale = tonumber(_G.Xlu0MobileButtonScale) or 0.75,
guiScaleValue = tonumber(_G.Xlu0GuiScaleValue) or tonumber(xlu0GuiScaleValue) or tonumber(aceGuiScaleValue) or 0.52,
stealUiScaleValue = tonumber(_G.Xlu0ProgressBarScaleValue) or tonumber(xlu0ProgressBarScaleValue) or tonumber(aceProgressBarScaleValue) or 0.83,
autoInstantResetOnDeath = _G.Xlu0AutoInstantResetOnDeath == true,
headlessEnabled = _G.Xlu0HeadlessEnabled == true,
korbloxEnabled = _G.Xlu0KorbloxEnabled == true,
currentThemeName = _G.Xlu0ThemeName,
aceGuiScaleValue = aceGuiScaleValue,
aceProgressBarScaleValue = aceProgressBarScaleValue,
introEnabled = _introEnabled == true,
selectedIntroMusic = selectedIntroMusic,
guiLocked = _G.Xlu0GuiLocked == true,
hideMobileButtons = _G.Xlu0HideMobileButtons == true,
aceMobileButtonScale = _G.Xlu0MobileButtonScale,
mobileButtonPositions = collectXlu0MobileButtonPositions(),
mobileButtonImage = _G.Xlu0MobileButtonImage or "",
mobileButtonShape = _G.Xlu0MobileButtonShape or "ROUNDED",
stealUIImage = _G.Xlu0StealUIImage or "",
autoStealV3Radius = tonumber((_G.Xlu0StealRadii and _G.Xlu0StealRadii["Auto Steal V3"]) or autoStealRadius) or 63,
aceStealRadii = {
    ["Auto Steal V3"] = tonumber((_G.Xlu0StealRadii and _G.Xlu0StealRadii["Auto Steal V3"]) or autoStealRadius) or 63,
    Semi = tonumber((_G.Xlu0StealRadii and _G.Xlu0StealRadii.Semi) or 9) or 9,
},
duelMode = _G.Xlu0DuelMode or "half",
autoMoveSpeed = tonumber(_G.Xlu0AutoMoveSpeed) or 60,
autoMoveCarrySpeed = tonumber(_G.Xlu0AutoMoveCarrySpeed) or 30,
stretchValue = tonumber(_G.Xlu0StretchValue) or 0.7,
stretchPreset = _G.Xlu0StretchPreset or "Medium",
avatarChangerUserId = (_G.Xlu0AvatarChangerCleared and 0) or ((_G.Xlu0AvatarChangerState and _G.Xlu0AvatarChangerState.lastUserId) or 0),
avatarChangerUsername = (_G.Xlu0AvatarChangerCleared and "") or ((_G.Xlu0AvatarChangerState and _G.Xlu0AvatarChangerState.lastUsername) or ""),
}
end
function saveXlu0Config()
if not canSaveConfig then return end
pcall(function()
_ace_writefile(CONFIG_FILE, HttpService:JSONEncode(collectXlu0Config()))
_ace_writefile(KEYBINDS_CONFIG_FILE, HttpService:JSONEncode(collectXlu0KeybindConfig()))
end)
end
function loadXlu0Config()
_G.Xlu0ManualSaveConfig = saveXlu0Config
if _G.Xlu0GuiScaleValue then
pcall(function()
if xlu0GuiScaleValue ~= nil then xlu0GuiScaleValue = tonumber(_G.Xlu0GuiScaleValue) or xlu0GuiScaleValue end
if aceGuiScaleValue ~= nil then aceGuiScaleValue = tonumber(_G.Xlu0GuiScaleValue) or aceGuiScaleValue end
end)
end
if _G.Xlu0ProgressBarScaleValue then
pcall(function()
if xlu0ProgressBarScaleValue ~= nil then xlu0ProgressBarScaleValue = tonumber(_G.Xlu0ProgressBarScaleValue) or xlu0ProgressBarScaleValue end
if aceProgressBarScaleValue ~= nil then aceProgressBarScaleValue = tonumber(_G.Xlu0ProgressBarScaleValue) or aceProgressBarScaleValue end
end)
end
if not canSaveConfig or not _ace_isfile(CONFIG_FILE) then return end
local ok, data = pcall(function()
return HttpService:JSONDecode(_ace_readfile(CONFIG_FILE))
end)
if not ok or type(data) ~= "table" then return end
savedConfig = data
local keybindData = data
pcall(function()
if _ace_isfile(KEYBINDS_CONFIG_FILE) then
local kb = HttpService:JSONDecode(_ace_readfile(KEYBINDS_CONFIG_FILE))
if type(kb) == "table" then keybindData = kb end
end
end)
savedMainPositionTable = data.mainPosition
savedMiniPositionTable = nil
_G.Xlu0GuiLocked = data.guiLocked == true
-- Her acilista cihaza gore varsayilan: PC gizli, mobil gorunur.
-- Settings anahtari bu oturumda kullanicinin elle acip kapatmasina devam eder.
_G.Xlu0HideMobileButtons = not Xlu0AutoMobile
_G.Xlu0MobileButtonScale = Xlu0AutoMobile and 0.90 or 1.00
_G.Xlu0MobileButtonPositions = {}
_G.Xlu0MobileButtonImage = tostring(data.mobileButtonImage or "")
_G.Xlu0MobileButtonShape = tostring(data.mobileButtonShape or "ROUNDED"):upper()
if _G.Xlu0MobileButtonShape ~= "CIRCLE" and _G.Xlu0MobileButtonShape ~= "SQUARE" and _G.Xlu0MobileButtonShape ~= "ROUNDED" then
_G.Xlu0MobileButtonShape = "ROUNDED"
end
_G.Xlu0StealUIImage = tostring(data.stealUIImage or "")
if data.autoStealV3Radius ~= nil then
    _G.Xlu0StealRadii = _G.Xlu0StealRadii or {}
    _G.Xlu0StealRadii["Auto Steal V3"] = tonumber(data.autoStealV3Radius) or 63
    if selectedStealMode == "Auto Steal V3" then
        autoStealRadius = _G.Xlu0StealRadii["Auto Steal V3"]
        if autoStealRadiusBox then
            autoStealRadiusBox.Text = tostring(autoStealRadius)
        end
    end
end

_G.Xlu0DuelMode = (tostring(data.duelMode or "half") == "full") and "full" or "half"
_G.Xlu0AutoMoveSpeed = tonumber(data.autoMoveSpeed) or _G.Xlu0AutoMoveSpeed or 60
_G.Xlu0AutoMoveCarrySpeed = tonumber(data.autoMoveCarrySpeed) or _G.Xlu0AutoMoveCarrySpeed or 30
_G.Xlu0StretchValue = tonumber(data.stretchValue) or _G.Xlu0StretchValue or 0.7
_G.Xlu0StretchPreset = tostring(data.stretchPreset or _G.Xlu0StretchPreset or "Medium")
_G.Xlu0SavedAvatarChangerUserId = tonumber(data.avatarChangerUserId)
if _G.Xlu0SavedAvatarChangerUserId == 0 then _G.Xlu0SavedAvatarChangerUserId = nil; _G.Xlu0AvatarChangerCleared = true else _G.Xlu0AvatarChangerCleared = false end
_G.Xlu0SavedAvatarChangerUsername = tostring(data.avatarChangerUsername or "")
applySavedKeybinds(keybindData.keybinds)
if keybindData.tpDownKeybind ~= nil then
if tostring(keybindData.tpDownKeybind) == "None" then
tpDownKeybind = nil
else
tpDownKeybind = stringToKeyCode(keybindData.tpDownKeybind) or DEFAULT_TP_DOWN_KEYBIND
end
end
for keyId, defaultKey in pairs(DEFAULT_SPEED_KEYBINDS) do
local savedKeys = keybindData and keybindData.keybinds
if (not savedKeys or savedKeys[keyId] == nil) and speedKeybinds[keyId] == nil then
speedKeybinds[keyId] = defaultKey
end
end
NS = tonumber(data.NS) or NS
CS = tonumber(data.CS) or CS
LAGGER_SPEED = tonumber(data.LAGGER_SPEED) or LAGGER_SPEED
LAGGER_CARRY_SPEED = tonumber(data.LAGGER_CARRY_SPEED) or LAGGER_CARRY_SPEED
currentSpeedMode = data.currentSpeedMode or currentSpeedMode
_G.Xlu0DropMode = (data.dropMode == "Jump Drop") and "Jump Drop" or "Stand Drop"
if currentSpeedMode ~= "Normal" and currentSpeedMode ~= "Carry" and currentSpeedMode ~= "Lagger" and currentSpeedMode ~= "Lagger Carry" then currentSpeedMode = "Normal" end
autoCarrySpeedEnabled = data.autoCarrySpeedEnabled == true
autoTPEnabled = data.autoTPEnabled == true
autoTPHeight = tonumber(data.autoTPHeight) or autoTPHeight
infJumpEnabled = data.infJumpEnabled == true
_G.Xlu0InfJumpMode = (data.infJumpMode == "Hold") and "Hold" or "Tap"
antiRagdollEnabled = data.antiRagdollEnabled == true
_G.Xlu0AntiRagdollMode = (data.antiRagdollMode == "V2") and "V2" or "V1"
_G.Xlu0AntiVoidEnabled = data.antiVoidEnabled == true
_G.Xlu0AntiResetEnabled = data.antiResetEnabled == true
selectedAnimationPack = data.selectedAnimationPack or selectedAnimationPack
_G.Xlu0SelectedMoreAnimationBundle = data.selectedMoreAnimationBundle
selectedStealMode = data.selectedStealMode or selectedStealMode
if selectedStealMode == "Auto Steal V3" then selectedStealMode = "Auto Steal V3" end
if selectedStealMode ~= "Semi" then selectedStealMode = "Auto Steal V3" end
autoStealEnabled = data.autoStealEnabled == true
if type(data.aceStealRadii) == "table" then
_G.Xlu0StealRadii["Auto Steal V3"] = tonumber(
    data.aceStealRadii["Auto Steal V3"]
    or data.aceStealRadii.Normal
    or data.autoStealV3Radius
) or _G.Xlu0StealRadii["Auto Steal V3"] or 63
_G.Xlu0StealRadii.Semi = tonumber(data.aceStealRadii.Semi) or _G.Xlu0StealRadii.Semi or 9
end
autoStealRadius = tonumber(data.autoStealRadius) or autoStealRadius
_G.Xlu0StealRadii = _G.Xlu0StealRadii or {["Auto Steal V3"] = 63, Semi = 9}

if selectedStealMode == "Auto Steal V3" then
    autoStealRadius = tonumber(
        data.autoStealV3Radius
        or _G.Xlu0StealRadii["Auto Steal V3"]
        or autoStealRadius
        or 63
    ) or 63
    _G.Xlu0StealRadii["Auto Steal V3"] = autoStealRadius
else
    autoStealRadius = tonumber(_G.Xlu0StealRadii.Semi) or 9
end
selectedAimbotMode = data.selectedAimbotMode or selectedAimbotMode
if selectedAimbotMode ~= "Anti Bypass" then selectedAimbotMode = "Normal" end
AIMBOT_SPEED = tonumber(data.AIMBOT_SPEED) or AIMBOT_SPEED
LAGGER_AIMBOT_SPEED = tonumber(data.LAGGER_AIMBOT_SPEED) or LAGGER_AIMBOT_SPEED
_G.Xlu0AntiBypassAimbotSpeed = tonumber(data.ANTI_BYPASS_AIMBOT_SPEED) or _G.Xlu0AntiBypassAimbotSpeed or 58
if data.ANTI_BYPASS_LAGGER_AIMBOT_SPEED == nil or tonumber(data.ANTI_BYPASS_LAGGER_AIMBOT_SPEED) == 58 then
_G.Xlu0AntiBypassLaggerAimbotSpeed = 40
else
_G.Xlu0AntiBypassLaggerAimbotSpeed = tonumber(data.ANTI_BYPASS_LAGGER_AIMBOT_SPEED) or 40
end
ANTI_DESYNC_AIMBOT_SPEED = tonumber(data.ANTI_DESYNC_AIMBOT_SPEED) or ANTI_DESYNC_AIMBOT_SPEED or 58
autoSwingEnabled = data.autoSwingEnabled == true
mirrorTPDownEnabled = data.mirrorTPDownEnabled == true
_G.Xlu0NormalAimbotOn = data.normalAimbotEnabled == true
_G.Xlu0AntiBypassAimbotOn = data.antiBypassAimbotEnabled == true
antiDesyncAutoSwingEnabled = data.antiDesyncAutoSwingEnabled == true
_G.Xlu0AntiDesyncAimbotOn = data.antiDesyncAimbotEnabled == true
batCounterEnabled = data.batCounterEnabled == true
medCounterEnabled = data.medCounterEnabled == true
antiKickEnabled = data.safeMode == true
autoResetOnMedEnabled = data.autoResetOnMedEnabled == true
espEnabled = data.espEnabled == true
showTracerEnabled = false
ragdollCountdownEnabled = false
fpsBoostEnabled = data.fpsBoostEnabled == true
antiLagVisualEnabled = data.antiLagVisualEnabled == true
nukeOptimiserEnabled = data.nukeOptimiserEnabled == true
fovEnabled = data.fovEnabled == true
fovValue = tonumber(data.fovValue) or fovValue
noCamCollisionEnabled = data.noCamCollisionEnabled == true
_G.Xlu0NoPlayerCollisionEnabled = data.noPlayerCollisionEnabled == true
_G.Xlu0CustomFontSelected = (type(data.customFontSelected) == "string" and data.customFontSelected) or "None"
customFontVisualEnabled = _G.Xlu0CustomFontSelected ~= "None"
skyTheme = (type(data.skyTheme) == "string" and data.skyTheme) or skyTheme
autoLeftEnabled = data.autoLeftEnabled == true
autoRightEnabled = data.autoRightEnabled == true
if data.introEnabled ~= nil then _introEnabled = data.introEnabled == true end
selectedIntroMusic = 4 -- Ignore saved song selection
if autoLeftEnabled and autoRightEnabled then autoRightEnabled = false end
end
loadXlu0Config()
local function syncAnimationPackIndex()
for i, name in ipairs(AnimationPackList) do
if name == selectedAnimationPack then
AnimationPackIndex = i
return
end
end
selectedAnimationPack = "OFF"
AnimationPackIndex = 1
end
local function applySavedAnimationPackToCharacter(char)
syncAnimationPackIndex()
if refreshAnimationPackRow then pcall(refreshAnimationPackRow) end
if not char then char = LP.Character end
if not char then return end
local animate = char:FindFirstChild("Animate") or char:WaitForChild("Animate", 6)
if not animate then return end
task.wait(0.2)
OriginalAnims = {}
unwalkSavedAnimate = nil
if selectedAnimationPack and selectedAnimationPack ~= "OFF" then
    pcall(function() applyAnimationPack(selectedAnimationPack) end)
elseif _G.Xlu0SelectedMoreAnimationBundle and applyFullAnimationBundle then
    -- MORE bundle: reapply after every fresh character/Animate instance.
    task.wait(0.15)
    pcall(function()
        applyFullAnimationBundle(_G.Xlu0SelectedMoreAnimationBundle)
    end)
else
    pcall(function() resetAnimations() end)
end
end
syncAnimationPackIndex()
task.defer(function()
applySavedAnimationPackToCharacter(LP.Character)
end)
LP.CharacterAdded:Connect(function(char)
task.wait(0.65)
task.defer(function()
task.wait(0.2)
_G.Xlu0ApplyCharacterVisuals(char)
end)
if _G.Xlu0AntiVoidEnabled then pcall(_G.Xlu0AntiVoidSaveSafe) end
applySavedAnimationPackToCharacter(char)

-- Roblox may rewrite Animate shortly after spawn; apply once more.
if _G.Xlu0SelectedMoreAnimationBundle then
    task.delay(1.25, function()
        if char == LP.Character and char.Parent and applyFullAnimationBundle then
            pcall(function()
                applyFullAnimationBundle(_G.Xlu0SelectedMoreAnimationBundle)
            end)
        end
    end)
end
end)
_G.Xlu0AutoResetOnMed = _G.Xlu0AutoResetOnMed or {}
_G.Xlu0AutoResetOnMed.conns = _G.Xlu0AutoResetOnMed.conns or {}
_G.Xlu0AutoResetOnMed.enabled = autoResetOnMedEnabled == true
_G.Xlu0AutoResetOnMed.medTriggered = false
_G.Xlu0AutoResetOnMed.lastFire = _G.Xlu0AutoResetOnMed.lastFire or 0
_G.Xlu0AutoResetOnMed.cooldown = 2.25
_G.Xlu0AutoResetOnMed.charAddedConn = _G.Xlu0AutoResetOnMed.charAddedConn
_G.Xlu0CursedResetGuid = _G.Xlu0CursedResetGuid or "f888ee6e-c86d-46e1-93d7-0639d6635d42"
_G.Xlu0CursedResetRemote = _G.Xlu0CursedResetRemote or nil
pcall(function()
if hookfunction and newcclosure and not _G.Xlu0CursedResetHooked and not _G.Xlu0AutoResetOnMed.remoteHooked then
_G.Xlu0AutoResetOnMed.remoteHooked = true
local oldFire
oldFire = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
if not _G.Xlu0CursedResetRemote
and typeof(self) == "Instance"
and self:IsA("RemoteEvent")
and self.Name:sub(1, 3) == "RE/" then
_G.Xlu0CursedResetRemote = self
end
return oldFire(self, ...)
end))
end
end)
function _G.Xlu0FindCursedResetRemote()
if _G.Xlu0CursedResetRemote then return _G.Xlu0CursedResetRemote end
for _, desc in ipairs(ReplicatedStorage:GetDescendants()) do
if desc:IsA("RemoteEvent") and desc.Name:sub(1, 3) == "RE/" then
_G.Xlu0CursedResetRemote = desc
break
end
end
return _G.Xlu0CursedResetRemote
end
function _G.Xlu0AutoResetCursedInstaReset()
if _G.Xlu0AntiResetEnabled then
_G.Xlu0RestoreAntiDieAfterReset = true
_G.Xlu0SetAntiReset(false)
if _G.Xlu0AntiResetVisual then
pcall(function() _G.Xlu0AntiResetVisual(false) end)
end
do end
end
local remote = _G.Xlu0FindCursedResetRemote and _G.Xlu0FindCursedResetRemote() or _G.Xlu0CursedResetRemote
if not remote then return end
local character = LP.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if humanoid and humanoid.Health <= 0 then
pcall(function()
remote:FireServer(_G.Xlu0CursedResetGuid, LP, "balloon")
end)
return
end
local resetDetected = false
local resetConns = {}
if humanoid then
table.insert(resetConns, humanoid.Died:Connect(function()
resetDetected = true
end))
table.insert(resetConns, humanoid:GetPropertyChangedSignal("Health"):Connect(function()
if humanoid.Health <= 0 then
resetDetected = true
end
end))
end
if character then
table.insert(resetConns, character.AncestryChanged:Connect(function(_, parent)
if not parent then
resetDetected = true
end
end))
end
task.spawn(function()
for _ = 1, 10 do
if resetDetected then break end
pcall(function()
remote:FireServer(_G.Xlu0CursedResetGuid, LP, "balloon")
end)
task.wait(0.05)
end
for _, conn in ipairs(resetConns) do
pcall(function()
conn:Disconnect()
end)
end
end)
end
function _G.Xlu0AutoResetShouldFire(part)
local state = _G.Xlu0AutoResetOnMed
if not state or not state.enabled then return false end
if state.medTriggered then return false end
if tick() - (state.lastFire or 0) < (state.cooldown or 2.25) then return false end
if not part or not part.Parent then return false end
if part:FindFirstAncestorOfClass("Tool") or part:FindFirstAncestorOfClass("Accessory") then
return false
end
return part.Anchored and part.Transparency == 1
end
function _G.Xlu0AutoResetFireOnce(part)
if not _G.Xlu0AutoResetShouldFire(part) then return end
local state = _G.Xlu0AutoResetOnMed
state.medTriggered = true
state.lastFire = tick()
task.delay(2.3, function()
if state.enabled then
if _G.Xlu0AutoResetCursedInstaReset then
_G.Xlu0AutoResetCursedInstaReset()
elseif cursedInstaReset then
cursedInstaReset()
end
end
end)
end
function _G.Xlu0AutoResetOnAnchorChanged(part)
return part:GetPropertyChangedSignal("Anchored"):Connect(function()
_G.Xlu0AutoResetFireOnce(part)
end)
end
function _G.Xlu0StopAutoResetOnMed()
local state = _G.Xlu0AutoResetOnMed
if not state then return end
for _, conn in ipairs(state.conns or {}) do
pcall(function()
conn:Disconnect()
end)
end
state.conns = {}
state.medTriggered = false
end
function _G.Xlu0StartAutoResetOnMed(char)
local state = _G.Xlu0AutoResetOnMed
if not state then return end
_G.Xlu0StopAutoResetOnMed()
state.medTriggered = false
char = char or LP.Character
if not char then return end
for _, part in ipairs(char:GetDescendants()) do
if part:IsA("BasePart") then
table.insert(state.conns, _G.Xlu0AutoResetOnAnchorChanged(part))
_G.Xlu0AutoResetFireOnce(part)
end
end
table.insert(state.conns, char.DescendantAdded:Connect(function(part)
if part:IsA("BasePart") then
table.insert(state.conns, _G.Xlu0AutoResetOnAnchorChanged(part))
_G.Xlu0AutoResetFireOnce(part)
end
end))
table.insert(state.conns, char.AncestryChanged:Connect(function(_, parent)
if not parent then
state.medTriggered = false
end
end))
end
function _G.Xlu0EnableAutoResetOnMed()
autoResetOnMedEnabled = true
_G.Xlu0AutoResetOnMed.enabled = true
_G.Xlu0StartAutoResetOnMed(LP.Character)
end
function _G.Xlu0DisableAutoResetOnMed()
autoResetOnMedEnabled = false
_G.Xlu0AutoResetOnMed.enabled = false
_G.Xlu0StopAutoResetOnMed()
end
function _G.Xlu0SetAutoResetOnMed(state, noSave)
autoResetOnMedEnabled = state == true
if autoResetOnMedEnabled then
_G.Xlu0EnableAutoResetOnMed()
else
_G.Xlu0DisableAutoResetOnMed()
end
if setAutoResetOnMedVisual then
setAutoResetOnMedVisual(autoResetOnMedEnabled)
end
if not noSave and saveXlu0Config then do end end
end
function enableAutoResetOnMed()
_G.Xlu0SetAutoResetOnMed(true)
end
function disableAutoResetOnMed()
_G.Xlu0SetAutoResetOnMed(false)
end
function toggleAutoResetOnMed(on)
_G.Xlu0SetAutoResetOnMed(on == true)
end
if not _G.Xlu0AutoResetOnMed.charAddedConn then
_G.Xlu0AutoResetOnMed.charAddedConn = LP.CharacterAdded:Connect(function(char)
if _G.Xlu0AutoResetOnMed and _G.Xlu0AutoResetOnMed.enabled then
task.wait(0.25)
_G.Xlu0StartAutoResetOnMed(char)
end
end)
end
_G.Xlu0CounterState = _G.Xlu0CounterState or {}
_G.Xlu0CounterState.batConn = nil
_G.Xlu0CounterState.batDebounce = false
_G.Xlu0CounterState.medConns = _G.Xlu0CounterState.medConns or {}
_G.Xlu0CounterState.medDebounce = false
_G.Xlu0CounterState.medLastUsed = _G.Xlu0CounterState.medLastUsed or 0
_G.Xlu0MedusaCooldown = 25
function _G.Xlu0FindMedusa()
local c = LP.Character
if not c then return nil end
for _, t in ipairs(c:GetChildren()) do
if t:IsA("Tool") then
local n = t.Name:lower()
if n:find("medusa") or n:find("head") or n:find("stone") then return t end
end
end
local bp = LP:FindFirstChild("Backpack") or LP:FindFirstChildOfClass("Backpack")
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
function _G.Xlu0UseMedusaCounter()
if not medCounterEnabled then return end
if _G.Xlu0CounterState.medDebounce then return end
if tick() - (_G.Xlu0CounterState.medLastUsed or 0) < _G.Xlu0MedusaCooldown then return end
local c = LP.Character
if not c then return end
_G.Xlu0CounterState.medDebounce = true
local med = _G.Xlu0FindMedusa()
if not med then
_G.Xlu0CounterState.medDebounce = false
return
end
if med.Parent ~= c then
local hum = c:FindFirstChildOfClass("Humanoid")
if hum then pcall(function() hum:EquipTool(med) end) end
task.wait(0.05)
end
pcall(function() med:Activate() end)
_G.Xlu0CounterState.medLastUsed = tick()
_G.Xlu0CounterState.medDebounce = false
end
function _G.Xlu0OnMedusaAnchorChanged(part)
return part:GetPropertyChangedSignal("Anchored"):Connect(function()
if medCounterEnabled and part.Anchored and part.Transparency == 1 then
_G.Xlu0UseMedusaCounter()
end
end)
end
function _G.Xlu0StartMedCounter(char)
_G.Xlu0StopMedCounter()
char = char or LP.Character
if not char then return end
for _, part in ipairs(char:GetDescendants()) do
if part:IsA("BasePart") then
table.insert(_G.Xlu0CounterState.medConns, _G.Xlu0OnMedusaAnchorChanged(part))
end
end
table.insert(_G.Xlu0CounterState.medConns, char.DescendantAdded:Connect(function(part)
if part:IsA("BasePart") then
table.insert(_G.Xlu0CounterState.medConns, _G.Xlu0OnMedusaAnchorChanged(part))
end
end))
end
function _G.Xlu0StopMedCounter()
for _, c in pairs(_G.Xlu0CounterState.medConns or {}) do
pcall(function() c:Disconnect() end)
end
_G.Xlu0CounterState.medConns = {}
_G.Xlu0CounterState.medDebounce = false
end
_G.Xlu0BatCounterSlapList = {"Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap", "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap", "Nuclear Slap", "Galaxy Slap", "Glitched Slap"}
function _G.Xlu0FindBatForCounter()
local c = LP.Character
if not c then return nil end
local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
for _, name in ipairs(_G.Xlu0BatCounterSlapList) do
local t = c:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
if t then return t end
end
for _, ch in ipairs(c:GetChildren()) do
if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
end
if bp then
for _, ch in ipairs(bp:GetChildren()) do
if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
end
end
return nil
end
function _G.Xlu0SwingBatForCounter(bat, char)
if not bat or not char then return end
local hum = char:FindFirstChildOfClass("Humanoid")
if bat.Parent ~= char then
if hum then pcall(function() hum:EquipTool(bat) end) end
task.wait(0.05)
end
local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
if remote and remote:IsA("RemoteEvent") then
pcall(function() remote:FireServer() end)
task.wait(0.15)
pcall(function() remote:FireServer() end)
else
pcall(function() bat:Activate() end)
task.wait(0.15)
pcall(function() bat:Activate() end)
end
end
function _G.Xlu0CounterIsRagdoll(hum)
if not hum then return false end
local st = hum:GetState()
return st == Enum.HumanoidStateType.Physics
or st == Enum.HumanoidStateType.Ragdoll
or st == Enum.HumanoidStateType.FallingDown
or hum.PlatformStand == true
end
function _G.Xlu0StartBatCounter()
if _G.Xlu0CounterState.batConn then return end
_G.Xlu0CounterState.batDebounce = false
_G.Xlu0CounterState.batConn = RunService.Heartbeat:Connect(function()
if not batCounterEnabled then return end
if _G.Xlu0CounterState.batDebounce then return end
local char = LP.Character
if not char then return end
local hum = char:FindFirstChildOfClass("Humanoid")
if not hum then return end
if _G.Xlu0CounterIsRagdoll(hum) then
_G.Xlu0CounterState.batDebounce = true
task.spawn(function()
local bat = _G.Xlu0FindBatForCounter()
if bat then _G.Xlu0SwingBatForCounter(bat, char) end
task.wait(0.5)
_G.Xlu0CounterState.batDebounce = false
end)
end
end)
end
function _G.Xlu0StopBatCounter()
if _G.Xlu0CounterState.batConn then
_G.Xlu0CounterState.batConn:Disconnect()
_G.Xlu0CounterState.batConn = nil
end
_G.Xlu0CounterState.batDebounce = false
end
startBatCounter = _G.Xlu0StartBatCounter
stopBatCounter = _G.Xlu0StopBatCounter
setupMedusaCounter = _G.Xlu0StartMedCounter
stopMedusaCounter = _G.Xlu0StopMedCounter
_G.Xlu0NoPlayerCollisionState = _G.Xlu0NoPlayerCollisionState or {connections = {}}
function _G.Xlu0SetOtherPlayerCollision(state)
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
function enableNoPlayerCollision()
if _G.Xlu0NoPlayerCollisionState.running then return end
_G.Xlu0NoPlayerCollisionEnabled = true
_G.Xlu0NoPlayerCollisionState.running = true
for _, conn in ipairs(_G.Xlu0NoPlayerCollisionState.connections or {}) do
pcall(function() conn:Disconnect() end)
end
_G.Xlu0NoPlayerCollisionState.connections = {}
_G.Xlu0SetOtherPlayerCollision(false)
table.insert(_G.Xlu0NoPlayerCollisionState.connections, LP.CharacterAdded:Connect(function()
task.wait(0.5)
if _G.Xlu0NoPlayerCollisionEnabled then _G.Xlu0SetOtherPlayerCollision(false) end
end))
table.insert(_G.Xlu0NoPlayerCollisionState.connections, Players.PlayerAdded:Connect(function(plr)
local c = plr.CharacterAdded:Connect(function()
task.wait(0.5)
if _G.Xlu0NoPlayerCollisionEnabled then _G.Xlu0SetOtherPlayerCollision(false) end
end)
table.insert(_G.Xlu0NoPlayerCollisionState.connections, c)
end))
local collisionScanElapsed = 0
table.insert(_G.Xlu0NoPlayerCollisionState.connections, RunService.Heartbeat:Connect(function(dt)
if not _G.Xlu0NoPlayerCollisionEnabled then return end
collisionScanElapsed = collisionScanElapsed + (dt or 0)
if collisionScanElapsed < 0.25 then return end
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
function disableNoPlayerCollision()
if not _G.Xlu0NoPlayerCollisionState.running then
_G.Xlu0NoPlayerCollisionEnabled = false
return
end
_G.Xlu0NoPlayerCollisionEnabled = false
_G.Xlu0NoPlayerCollisionState.running = false
for _, conn in ipairs(_G.Xlu0NoPlayerCollisionState.connections or {}) do
pcall(function() conn:Disconnect() end)
end
_G.Xlu0NoPlayerCollisionState.connections = {}
_G.Xlu0SetOtherPlayerCollision(true)
end
function _G.Xlu0SafeModeGetCountdownLabel()
local ok, label = pcall(function()
return LP.PlayerGui
and LP.PlayerGui:FindFirstChild("DuelsMachineTopFrame")
and LP.PlayerGui.DuelsMachineTopFrame:FindFirstChild("DuelsMachineTopFrame")
and LP.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame:FindFirstChild("Timer")
and LP.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame.Timer:FindFirstChild("Label")
end)
return (ok and label) or nil
end
function _G.Xlu0SafeModeCountdownNumber(text)
local t = tostring(text or ""):upper():gsub("^%s+", ""):gsub("%s+$", "")
if t == "GO" or t == "START" or t == "READY" then return true end
local n = tonumber(t)
return n ~= nil and n >= 0 and n <= 10
end
function _G.Xlu0SafeModeInDuelCountdown()
local label = _G.Xlu0SafeModeGetCountdownLabel()
return label and _G.Xlu0SafeModeCountdownNumber(label.Text) or false
end
_G.Xlu0SafeModeBlockedTools = {
bat=true, slap=true, sword=true, gun=true, pistol=true, rifle=true,
medusa=true, hammer=true, axe=true, knife=true, katana=true, blade=true, fist=true,
}
function _G.Xlu0SafeModeIsCarryableTool(tool)
if not tool or not tool:IsA("Tool") then return false end
local name = tool.Name:lower()
for word in pairs(_G.Xlu0SafeModeBlockedTools) do
if name:find(word, 1, true) then return false end
end
return true
end
function _G.Xlu0SafeModeHoldingBrainrot()
local ok, val = pcall(function() return LP:GetAttribute("Stealing") end)
if ok and val == true then return true end
local ok2, val2 = pcall(function() return LP:GetAttribute("AntiKick") end)
if ok2 and val2 == true then return true end
local char = LP.Character
if not char then return false end
local ok3, val3 = pcall(function() return char:GetAttribute("Stealing") end)
if ok3 and val3 == true then return true end
if _G.AutoCarrySpeed and type(_G.AutoCarrySpeed.IsCarryingBrainrot) == "function" then
local okCarry, carrying = pcall(function() return _G.AutoCarrySpeed.IsCarryingBrainrot(char) end)
if okCarry and carrying then return true end
end
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
function _G.Xlu0SafeModeIsLocked()
if not antiKickEnabled then return false end
return _G.Xlu0SafeModeInDuelCountdown() or _G.Xlu0SafeModeHoldingBrainrot()
end
function _G.Xlu0SafeModeForceStop(reason)
local stopped = false
if _G.Xlu0NormalAimbotOn and _G.Xlu0StopNormalAimbot then _G.Xlu0StopNormalAimbot(); stopped = true end
if _G.Xlu0AntiBypassAimbotOn and _G.Xlu0StopAntiBypassAimbot then _G.Xlu0StopAntiBypassAimbot(false); stopped = true end
if _G.Xlu0AntiDesyncAimbotOn and _G.Xlu0StopAntiDesyncAimbot then _G.Xlu0StopAntiDesyncAimbot(); stopped = true end
if autoLeftEnabled then
autoLeftEnabled = false
if _G.Xlu0SetAutoLeftVisual then _G.Xlu0SetAutoLeftVisual(false) end
if _G.Xlu0StopAutoLeft then _G.Xlu0StopAutoLeft() end
stopped = true
end
if autoRightEnabled then
autoRightEnabled = false
if _G.Xlu0SetAutoRightVisual then _G.Xlu0SetAutoRightVisual(false) end
if _G.Xlu0StopAutoRight then _G.Xlu0StopAutoRight() end
stopped = true
end
if stopped and showActionNotification then pcall(function() showActionNotification(reason or "SAFE MODE LOCK") end) end
end
function _G.Xlu0SafeModeTryStart()
if _G.Xlu0SafeModeIsLocked and _G.Xlu0SafeModeIsLocked() then
_G.Xlu0SafeModeForceStop("SAFE MODE LOCK")
return false
end
return true
end
_G.Xlu0SafeModeMonitorStarted = _G.Xlu0SafeModeMonitorStarted or false
if not _G.Xlu0SafeModeMonitorStarted then
_G.Xlu0SafeModeMonitorStarted = true
RunService.Heartbeat:Connect(function()
if antiKickEnabled and _G.Xlu0SafeModeIsLocked and _G.Xlu0SafeModeIsLocked() then
_G.Xlu0SafeModeForceStop("SAFE MODE LOCK")
end
end)
end
LP.CharacterAdded:Connect(function(char)
task.wait(0.5)
if medCounterEnabled then _G.Xlu0StartMedCounter(char) end
if batCounterEnabled then _G.Xlu0StartBatCounter() end
end)
_G.Xlu0NormalAimbot = _G.Xlu0NormalAimbot or {conn = nil, target = nil, swingCooldown = false}
function _G.Xlu0FindAimbotBat()
local char = LP.Character
if not char then return nil end
for _, tool in ipairs(char:GetChildren()) do
if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
return tool
end
end
local bp = LP:FindFirstChild("Backpack")
if bp then
for _, tool in ipairs(bp:GetChildren()) do
if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
return tool
end
end
end
return nil
end
function _G.Xlu0GetClosestAimbotTarget()
local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
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
function _G.Xlu0GetNormalAimbotSpeed()
if currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry" then
return tonumber(LAGGER_AIMBOT_SPEED) or 40
end
return tonumber(AIMBOT_SPEED) or 58
end
function _G.Xlu0GetAntiBypassAimbotSpeed()
if currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry" then
return tonumber(_G.Xlu0AntiBypassLaggerAimbotSpeed) or 40
end
return tonumber(_G.Xlu0AntiBypassAimbotSpeed) or 58
end
function _G.Xlu0GetSelectedAimbotSpeedValues()
if selectedAimbotMode == "Anti Bypass" then
return tonumber(_G.Xlu0AntiBypassAimbotSpeed) or 58, tonumber(_G.Xlu0AntiBypassLaggerAimbotSpeed) or 40
end
return tonumber(AIMBOT_SPEED) or 58, tonumber(LAGGER_AIMBOT_SPEED) or 40
end
function _G.Xlu0SetSelectedAimbotSpeedValues(normalValue, laggerValue)
if selectedAimbotMode == "Anti Bypass" then
if normalValue then _G.Xlu0AntiBypassAimbotSpeed = normalValue end
if laggerValue then _G.Xlu0AntiBypassLaggerAimbotSpeed = laggerValue end
else
if normalValue then AIMBOT_SPEED = normalValue end
if laggerValue then LAGGER_AIMBOT_SPEED = laggerValue end
end
end
function _G.Xlu0RefreshAimbotSpeedBoxes()
local n, l = _G.Xlu0GetSelectedAimbotSpeedValues()
if _G.Xlu0AimbotSpeedBox then _G.Xlu0AimbotSpeedBox.Text = tostring(n) end
if _G.Xlu0LaggerAimbotSpeedBox then _G.Xlu0LaggerAimbotSpeedBox.Text = tostring(l) end
end
-- Normal Aimbot: Envy_aimbot_2 movement/prediction logic, integrated into XLU0 menu.

--// Donor aimbot logic + Xlu0 LinearVelocity movement
_G.Xlu0NormalAimbot = _G.Xlu0NormalAimbot or {
    conn = nil,
    target = nil,
    lastScan = 0,
    attachment = nil,
    linearVelocity = nil,
}

local function _Xlu0AimbotEnsureLinearVelocity(root)
    local S = _G.Xlu0NormalAimbot

    if S.linearVelocity
        and S.linearVelocity.Parent
        and S.attachment
        and S.attachment.Parent == root then
        S.linearVelocity.Enabled = true
        return S.linearVelocity
    end

    if S.linearVelocity then
        pcall(function() S.linearVelocity:Destroy() end)
    end
    if S.attachment then
        pcall(function() S.attachment:Destroy() end)
    end

    local att = Instance.new("Attachment")
    att.Name = "Xlu0AimbotAttachment"
    att.Parent = root

    local lv = Instance.new("LinearVelocity")
    lv.Name = "Xlu0AimbotLinearVelocity"
    lv.Attachment0 = att
    lv.RelativeTo = Enum.ActuatorRelativeTo.World
    lv.ForceLimitMode = Enum.ForceLimitMode.Magnitude
    lv.MaxForce = math.huge
    lv.VectorVelocity = Vector3.zero
    lv.Enabled = true
    lv.Parent = att

    S.attachment = att
    S.linearVelocity = lv
    return lv
end

local function _Xlu0AimbotReleaseLinearVelocity()
    local S = _G.Xlu0NormalAimbot
    if S.linearVelocity and S.linearVelocity.Parent then
        S.linearVelocity.VectorVelocity = Vector3.zero
        S.linearVelocity.Enabled = false
    end
end

function _G.Xlu0StartNormalAimbot()
    if _G.Xlu0SafeModeTryStart and not _G.Xlu0SafeModeTryStart() then
        return false
    end

    if _G.Xlu0StopAntiBypassAimbot then
        _G.Xlu0StopAntiBypassAimbot(false)
    end
    _G.Xlu0AntiBypassAimbotOn = false

    if _G.Xlu0NormalAimbot.conn then
        pcall(function() _G.Xlu0NormalAimbot.conn:Disconnect() end)
        _G.Xlu0NormalAimbot.conn = nil
    end

    _G.Xlu0NormalAimbotAutoTPWasEnabled = false
    if autoTPEnabled then
        _G.Xlu0NormalAimbotAutoTPWasEnabled = true
        stopAutoTP()
        if setAutoTPVisual then setAutoTPVisual(false) end
    end

    _G.Xlu0NormalAimbotOn = true
    _G.Xlu0NormalAimbot.target = nil
    _G.Xlu0NormalAimbot.lastScan = 0

    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate = false end

    _G.Xlu0NormalAimbot.conn = RunService.Heartbeat:Connect(function()
        if not _G.Xlu0NormalAimbotOn or selectedAimbotMode ~= "Normal" then
            return
        end

        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hum or not root or hum.Health <= 0 then
            return
        end

        -- Donor behavior: equip a bat once needed.
        if not char:FindFirstChildOfClass("Tool") then
            local bat = _G.Xlu0FindAimbotBat()
            if bat then
                pcall(function() hum:EquipTool(bat) end)
            end
        end

        -- Donor target scan/cache behavior.
        local now = tick()
        local target = _G.Xlu0NormalAimbot.target

        if now - (_G.Xlu0NormalAimbot.lastScan or 0) > 0.1
            or not target
            or not target.Parent then

            _G.Xlu0NormalAimbot.lastScan = now
            local closest, minDist = nil, math.huge

            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                    local th = plr.Character:FindFirstChildOfClass("Humanoid")

                    if tRoot and th and th.Health > 0 then
                        local dist = (tRoot.Position - root.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            closest = tRoot
                        end
                    end
                end
            end

            target = closest
            _G.Xlu0NormalAimbot.target = target
        end

        if not target then
            hum.AutoRotate = true
            root.AssemblyAngularVelocity = Vector3.zero
            _Xlu0AimbotReleaseLinearVelocity()
            return
        end

        local targetHum = target.Parent and target.Parent:FindFirstChildOfClass("Humanoid")
        if not targetHum or targetHum.Health <= 0 then
            _G.Xlu0NormalAimbot.target = nil
            _Xlu0AimbotReleaseLinearVelocity()
            return
        end

        hum.AutoRotate = false

        -- Exact donor-style prediction values.
        local targetVel = target.AssemblyLinearVelocity
        local aimTargetPos =
            target.Position
            + (targetVel * math.clamp(targetVel.Magnitude / 130, 0.05, 0.15))
            + Vector3.new(0, 1, 0)

        local look = aimTargetPos - root.Position
        local flatLook = Vector3.new(look.X, 0, look.Z)

        -- Donor turning system.
        if look.Magnitude > 0.01 and flatLook.Magnitude > 0.01 then
            local targetYaw = math.deg(math.atan2(-flatLook.X, -flatLook.Z))
            local yawDelta = (targetYaw - root.Orientation.Y + 180) % 360 - 180

            local targetPitch = math.deg(math.atan2(look.Y, flatLook.Magnitude))
            local pitchDelta = (targetPitch - root.Orientation.X + 180) % 360 - 180

            local yawRate = math.clamp(
                math.rad(yawDelta) * 285,
                -28,
                28
            )

            local pitchRate = math.clamp(
                math.rad(pitchDelta) * 285,
                -28,
                28
            )

            local yawRad = math.rad(root.Orientation.Y)
            local rightAxis = Vector3.new(
                math.cos(yawRad),
                0,
                -math.sin(yawRad)
            )

            root.AssemblyAngularVelocity =
                Vector3.new(0, yawRate, 0)
                + (rightAxis * pitchRate)
        else
            root.AssemblyAngularVelocity = Vector3.zero
        end

        -- Donor stand-position math.
        local dir = look.Magnitude > 0.01 and look.Unit or Vector3.zero
        local standPos =
            aimTargetPos
            - (dir * -2.8)
            + Vector3.new(0, 4.75, 0)

        local moveDir = standPos - root.Position
        local hDir = Vector3.new(moveDir.X, 0, moveDir.Z)

        local selectedSpeed =
            (currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry")
            and (tonumber(LAGGER_AIMBOT_SPEED) or 40)
            or (tonumber(AIMBOT_SPEED) or 58)

        local hVel =
            hDir.Magnitude > 0.1
            and (hDir.Unit * selectedSpeed)
            or Vector3.zero

        local verticalSpeed = 52
        local vVel =
            math.abs(moveDir.Y) > 0.1
            and Vector3.new(
                0,
                math.sign(moveDir.Y) * verticalSpeed,
                0
            )
            or Vector3.new(0, -2, 0)

        -- IMPORTANT: movement stays on LinearVelocity.
        local lv = _Xlu0AimbotEnsureLinearVelocity(root)
        lv.VectorVelocity = hVel + vVel

        if hDir.Magnitude > 0.5 then
            hum:Move(hDir.Unit, false)
        end

        if autoSwingEnabled then
            local bat = char:FindFirstChild("Bat") or _G.Xlu0FindAimbotBat()
            if bat and bat:IsA("Tool") then
                pcall(function() bat:Activate() end)
            end
        end
    end)

    if _G.Xlu0RefreshAimbotVisual then
        _G.Xlu0RefreshAimbotVisual()
    end

    return true
end

function _G.Xlu0StopNormalAimbot()
    _G.Xlu0NormalAimbotOn = false

    if _G.Xlu0NormalAimbot and _G.Xlu0NormalAimbot.conn then
        pcall(function() _G.Xlu0NormalAimbot.conn:Disconnect() end)
        _G.Xlu0NormalAimbot.conn = nil
    end

    if _G.Xlu0NormalAimbot then
        _G.Xlu0NormalAimbot.target = nil
        _G.Xlu0NormalAimbot.lastScan = 0
    end

    _Xlu0AimbotReleaseLinearVelocity()

    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if root then
        root.AssemblyAngularVelocity = Vector3.zero
    end

    if hum then
        hum.AutoRotate = true
    end

    if _G.Xlu0NormalAimbotAutoTPWasEnabled then
        _G.Xlu0NormalAimbotAutoTPWasEnabled = false
        autoTPEnabled = true
        if setAutoTPVisual then setAutoTPVisual(true) end
        startAutoTP()
    end

    if _G.Xlu0RefreshAimbotVisual then
        _G.Xlu0RefreshAimbotVisual()
    end
end

_G.Xlu0AntiBypassAimbot = _G.Xlu0AntiBypassAimbot or {conn = nil, swingCooldown = false, prevAutoRotate = nil}
_G.Xlu0AntiBypassSettings = {
SPEED = 63,
VERT_SPEED = 52,
DISTANCE = -2.8,
HEIGHT = 4.75,
V_OFFSET = 1,
TURN_SPEED = 285,
MAX_TURN_RATE = 28,
AUTO_SWING = true,
}
_G.Xlu0AntiBypassSlapList = _G.Xlu0AntiBypassSlapList or {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
function _G.Xlu0AntiBypassFindBat()
local char = LP.Character
if not char then return nil end
for _, tool in ipairs(char:GetChildren()) do
if tool:IsA("Tool") then
local name = tool.Name:lower()
if name:find("bat") or name:find("slap") then return tool end
end
end
local bp = LP:FindFirstChildOfClass("Backpack")
if bp then
for _, tool in ipairs(bp:GetChildren()) do
if tool:IsA("Tool") then
local name = tool.Name:lower()
if name:find("bat") or name:find("slap") then return tool end
end
end
end
return nil
end
function _G.Xlu0AntiBypassEnsureBat()
local char = LP.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
if not char or not hum then return nil end
local equipped = char:FindFirstChildOfClass("Tool")
if equipped then return equipped end
local bat = _G.Xlu0AntiBypassFindBat()
if bat then pcall(function() hum:EquipTool(bat) end) end
return bat
end
function _G.Xlu0AntiBypassTrySwing()
if _G.Xlu0AntiBypassAimbot.swingCooldown then return end
_G.Xlu0AntiBypassAimbot.swingCooldown = true
pcall(function()
local bat = _G.Xlu0AntiBypassEnsureBat()
if bat and bat:IsA("Tool") then bat:Activate() end
end)
task.delay(0.3, function()
if _G.Xlu0AntiBypassAimbot then _G.Xlu0AntiBypassAimbot.swingCooldown = false end
end)
end
function _G.Xlu0AntiBypassGetClosest()
local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
if not root then return nil, math.huge end
local closest, minDist = nil, math.huge
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
local hum = plr.Character:FindFirstChildOfClass("Humanoid")
if tRoot and hum and hum.Health > 0 then
local dist = (tRoot.Position - root.Position).Magnitude
if dist < minDist then minDist, closest = dist, tRoot end
end
end
end
return closest, minDist
end
function _G.Xlu0StartAntiBypassAimbot()
if _G.Xlu0SafeModeTryStart and not _G.Xlu0SafeModeTryStart() then return false end
if _G.Xlu0StopAutoTPForAction then _G.Xlu0StopAutoTPForAction() end
if _G.Xlu0StopNormalAimbot then _G.Xlu0StopNormalAimbot() end
_G.Xlu0AntiBypassAimbotOn = true
selectedAimbotMode = "Anti Bypass"
if _G.Xlu0AntiBypassAimbot.conn then _G.Xlu0AntiBypassAimbot.conn:Disconnect() end
local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
if hum0 then
_G.Xlu0AntiBypassAimbot.prevAutoRotate = hum0.AutoRotate
hum0.AutoRotate = false
end
_G.Xlu0AntiBypassAimbot.conn = RunService.Heartbeat:Connect(function()
if not _G.Xlu0AntiBypassAimbotOn or selectedAimbotMode ~= "Anti Bypass" then return end
local char = LP.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
local root = char and char:FindFirstChild("HumanoidRootPart")
if not char or not hum or not root or hum.Health <= 0 then return end
local S = _G.Xlu0AntiBypassSettings
hum.AutoRotate = false
_G.Xlu0AntiBypassEnsureBat()
local target, targetDist = _G.Xlu0AntiBypassGetClosest()
if not target then
root.AssemblyAngularVelocity = Vector3.zero
return
end
local aimTargetPos = target.Position + Vector3.new(0, S.V_OFFSET, 0)
local look = aimTargetPos - root.Position
local flatLook = Vector3.new(look.X, 0, look.Z)
if flatLook.Magnitude > 0.01 then
local targetYaw = math.deg(math.atan2(-flatLook.X, -flatLook.Z))
local yawDelta = (targetYaw - root.Orientation.Y + 180) % 360 - 180
local yawRate = math.clamp(yawDelta * 8, -S.MAX_TURN_RATE, S.MAX_TURN_RATE)
root.AssemblyAngularVelocity = Vector3.new(0, yawRate, 0)
else
root.AssemblyAngularVelocity = Vector3.zero
end
if look.Magnitude > 0.01 then
local dir = look.Unit
local standPos = aimTargetPos - (dir * S.DISTANCE) + Vector3.new(0, S.HEIGHT, 0)
local moveDir = standPos - root.Position
local hDir = Vector3.new(moveDir.X, 0, moveDir.Z)
local hVel = hDir.Magnitude > 0.1 and hDir.Unit * S.SPEED or Vector3.zero
local vVel = Vector3.new(0, math.clamp(moveDir.Y * 3, -S.VERT_SPEED, S.VERT_SPEED), 0)
root.AssemblyLinearVelocity = hVel + vVel
if hDir.Magnitude > 0.5 then hum:Move(hDir.Unit, false) end
end
if S.AUTO_SWING and autoSwingEnabled and targetDist < 5 then _G.Xlu0AntiBypassTrySwing() end
end)
if _G.Xlu0RefreshAimbotVisual then _G.Xlu0RefreshAimbotVisual() end
return true
end
function _G.Xlu0StopAntiBypassAimbot(keepVisual)
_G.Xlu0AntiBypassAimbotOn = false
if _G.Xlu0AntiBypassAimbot and _G.Xlu0AntiBypassAimbot.conn then
_G.Xlu0AntiBypassAimbot.conn:Disconnect()
_G.Xlu0AntiBypassAimbot.conn = nil
end
if _G.Xlu0AntiBypassAimbot then _G.Xlu0AntiBypassAimbot.swingCooldown = false end
local char = LP.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
local hum = char and char:FindFirstChildOfClass("Humanoid")
if root then
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero
end
if hum then
hum.AutoRotate = (_G.Xlu0AntiBypassAimbot.prevAutoRotate == nil) and true or _G.Xlu0AntiBypassAimbot.prevAutoRotate
end
_G.Xlu0AntiBypassAimbot.prevAutoRotate = nil
if keepVisual ~= false and _G.Xlu0RefreshAimbotVisual then _G.Xlu0RefreshAimbotVisual() end
end
function _G.Xlu0ToggleSelectedAimbot()
if selectedAimbotMode == "Anti Bypass" then
if _G.Xlu0AntiBypassAimbotOn then
if _G.Xlu0StopAntiBypassAimbot then _G.Xlu0StopAntiBypassAimbot() else _G.Xlu0AntiBypassAimbotOn = false end
else
if _G.Xlu0StopNormalAimbot then _G.Xlu0StopNormalAimbot() end
if _G.Xlu0StartAntiBypassAimbot then _G.Xlu0StartAntiBypassAimbot() else _G.Xlu0AntiBypassAimbotOn = true end
end
else
if _G.Xlu0NormalAimbotOn then
_G.Xlu0StopNormalAimbot()
else
if _G.Xlu0StopAntiBypassAimbot then _G.Xlu0StopAntiBypassAimbot(false) else _G.Xlu0AntiBypassAimbotOn = false end
_G.Xlu0StartNormalAimbot()
end
end
if _G.Xlu0RefreshAimbotVisual then _G.Xlu0RefreshAimbotVisual() end
do end
end
function _G.Xlu0RefreshAimbotVisual()
if _G.Xlu0AimbotSetVisual then
if selectedAimbotMode == "Anti Bypass" then
_G.Xlu0AimbotSetVisual(_G.Xlu0AntiBypassAimbotOn == true)
else
_G.Xlu0AimbotSetVisual(_G.Xlu0NormalAimbotOn == true)
end
end
end
_G.Xlu0NormalAimbotStart = _G.Xlu0StartNormalAimbot
_G.Xlu0NormalAimbotStop = _G.Xlu0StopNormalAimbot
_G.Xlu0AntiBypassStart = _G.Xlu0StartAntiBypassAimbot
_G.Xlu0AntiBypassStop = _G.Xlu0StopAntiBypassAimbot

-- Mirror TP Down: VYNX 2 logic adapted to Xlu0 Duels.
local MIRROR_TP_DROP_THRESHOLD = 3
local MIRROR_TP_DOWN_Y = -7.00
local mirrorTPPreviousY = {}
local mirrorTPLastTeleport = 0

local function mirrorTPAimbotActive()
return (_G.Xlu0NormalAimbotOn == true) or (_G.Xlu0AntiBypassAimbotOn == true)
end

local function mirrorTPTeleportDown()
local character = LP.Character
local root = character and character:FindFirstChild("HumanoidRootPart")
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if not root or not humanoid or humanoid.Health <= 0 then return end

local now = tick()
if now - (mirrorTPLastTeleport or 0) < 0.08 then return end
mirrorTPLastTeleport = now

local _, yaw = root.CFrame:ToEulerAnglesYXZ()
local y = (MIRROR_TP_DOWN_Y or -7) + (math.random() * 0.6 - 0.3)
root.CFrame = CFrame.new(root.Position.X, y, root.Position.Z) * CFrame.Angles(0, yaw, 0)
root.AssemblyLinearVelocity = Vector3.new((math.random() - 0.5) * 0.4, 0, (math.random() - 0.5) * 0.4)
end

RunService.Heartbeat:Connect(function()
if not mirrorTPDownEnabled or not mirrorTPAimbotActive() then
if next(mirrorTPPreviousY) then
table.clear(mirrorTPPreviousY)
end
return
end

for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LP and plr.Character then
local root = plr.Character:FindFirstChild("HumanoidRootPart")
if root then
local currentY = root.Position.Y
local previousY = mirrorTPPreviousY[plr.UserId]
if previousY and previousY - currentY >= (MIRROR_TP_DROP_THRESHOLD or 3) then
pcall(mirrorTPTeleportDown)
table.clear(mirrorTPPreviousY)
return
end
mirrorTPPreviousY[plr.UserId] = currentY
end
end
end
end)

function _G.Xlu0SetMirrorTPDown(enabled)
mirrorTPDownEnabled = enabled == true
if not mirrorTPDownEnabled then
table.clear(mirrorTPPreviousY)
end
if _G.Xlu0MirrorTPDownSetVisual then
_G.Xlu0MirrorTPDownSetVisual(mirrorTPDownEnabled)
end
end

_G.Xlu0AntiDesync = _G.Xlu0AntiDesync or {conn = nil, hittingCooldown = false, h = nil, hrp = nil}
function _G.Xlu0AntiDesyncGetBat()
    local char = LP.Character; if not char then return nil end
    local tool = char:FindFirstChild("Bat"); if tool then return tool end
    local bp2 = LP:FindFirstChild("Backpack")
    if bp2 then tool = bp2:FindFirstChild("Bat"); if tool then tool.Parent = char; return tool end end
    return nil
end

function _G.Xlu0AntiDesyncTrySwing()
    if not _G.Xlu0AntiDesync then return end
    if _G.Xlu0AntiDesync.hittingCooldown then return end
    _G.Xlu0AntiDesync.hittingCooldown = true
    pcall(function() local bat = _G.Xlu0AntiDesyncGetBat(); if bat then bat:Activate(); local ev = bat:FindFirstChildWhichIsA("RemoteEvent"); if ev then ev:FireServer() end end end)
    task.delay(0.08, function() if _G.Xlu0AntiDesync then _G.Xlu0AntiDesync.hittingCooldown = false end end)
end

function _G.Xlu0AntiDesyncGetClosestPlayer()
    local hrp = _G.Xlu0AntiDesync and _G.Xlu0AntiDesync.hrp; if not hrp then return nil, math.huge end
    local cp, cd = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            if tr then local d = (hrp.Position - tr.Position).Magnitude; if d < cd then cd = d; cp = p end end
        end
    end
    return cp, cd
end

function _G.Xlu0AntiDesyncSetupChar(char)
    task.wait(0.1)
    if not _G.Xlu0AntiDesync then return end
    _G.Xlu0AntiDesync.h = char and char:WaitForChild("Humanoid", 5) or nil
    _G.Xlu0AntiDesync.hrp = char and char:WaitForChild("HumanoidRootPart", 5) or nil
end
LP.CharacterAdded:Connect(function(char) pcall(function() _G.Xlu0AntiDesyncSetupChar(char) end) end)
if LP.Character then task.spawn(function() pcall(function() _G.Xlu0AntiDesyncSetupChar(LP.Character) end) end) end

function _G.Xlu0StartAntiDesyncAimbot()
    if _G.Xlu0SafeModeTryStart and not _G.Xlu0SafeModeTryStart() then return false end
    if _G.Xlu0StopAutoTPForAction then _G.Xlu0StopAutoTPForAction() end
    if _G.Xlu0StopNormalAimbot then _G.Xlu0StopNormalAimbot() end
    if _G.Xlu0StopAntiBypassAimbot then _G.Xlu0StopAntiBypassAimbot(false) end
    _G.Xlu0AntiDesyncAimbotOn = true
    if _G.Xlu0AntiDesync.conn then _G.Xlu0AntiDesync.conn:Disconnect(); _G.Xlu0AntiDesync.conn = nil end
    if LP.Character then pcall(function() _G.Xlu0AntiDesyncSetupChar(LP.Character) end) end
    _G.Xlu0AntiDesync.conn = RunService.Heartbeat:Connect(function()
        if not (_G.Xlu0AntiDesyncAimbotOn and _G.Xlu0AntiDesync.h and _G.Xlu0AntiDesync.hrp) then return end
        local target, dist = _G.Xlu0AntiDesyncGetClosestPlayer()
        _aimbotTargetPlr = target; _G.Xlu0CurrentAimbotTarget = target; _G.Xlu0AntiDesyncBatTarget = target
        if target and target.Character then
            local tr = target.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                if sethiddenproperty then pcall(function() sethiddenproperty(_G.Xlu0AntiDesync.hrp, "PhysicsRepRootPart", tr) end) end
                -- Adapt TP Bat hareket mantigi (guvenli entegrasyon)
                local ghost = workspace:FindFirstChild("ServerGhost")
                local targetCF = tr.CFrame
                local targetPos = tr.Position
                if ghost and ghost:IsA("BasePart") and (tr.Position - ghost.Position).Magnitude < 25 then
                    targetCF = ghost.CFrame
                    targetPos = ghost.Position
                end

                local offsetPos = targetPos + targetCF.LookVector * 1.2
                local delta = offsetPos - _G.Xlu0AntiDesync.hrp.Position
                if delta.Magnitude > 18 then
                    _G.Xlu0AntiDesync.hrp.CFrame = CFrame.new(offsetPos)
                elseif delta.Magnitude > 0.05 then
                    _G.Xlu0AntiDesync.hrp.Velocity = delta.Unit * 60
                end

                local cam = workspace.CurrentCamera
                if cam then cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position) end
                if dist < 8 and (antiDesyncAutoSwingEnabled or autoSwingEnabled) then
                    _G.Xlu0AntiDesyncTrySwing()
                end
            end
        end
    end)
    if _G.Xlu0AntiDesyncSetVisual then _G.Xlu0AntiDesyncSetVisual(true) end
    do end
    return true
end

function _G.Xlu0StopAntiDesyncAimbot()
    _G.Xlu0AntiDesyncAimbotOn = false
    if _G.Xlu0AntiDesync and _G.Xlu0AntiDesync.conn then _G.Xlu0AntiDesync.conn:Disconnect(); _G.Xlu0AntiDesync.conn = nil end
    if _G.Xlu0AntiDesync then _G.Xlu0AntiDesync.hittingCooldown = false end
    _G.Xlu0AntiDesyncBatTarget = nil
    if _G.Xlu0CurrentAimbotTarget == _aimbotTargetPlr then _G.Xlu0CurrentAimbotTarget = nil end
    _aimbotTargetPlr = nil
    if _G.Xlu0AntiDesyncSetVisual then _G.Xlu0AntiDesyncSetVisual(false) end
    do end
end

function _G.Xlu0ToggleAntiDesyncAimbot()
    if _G.Xlu0AntiDesyncAimbotOn then _G.Xlu0StopAntiDesyncAimbot() else _G.Xlu0StartAntiDesyncAimbot() end
end

_G.__Xlu0SetupNormalAutoSteal = function()
local getconnections_v3 = getconnections or get_signal_cons or getconnects or (syn and syn.get_signal_cons)
_G.Xlu0GalaxyV3 = _G.Xlu0GalaxyV3 or {
conn=nil, active=false, progress=0, paused=false, pauseTime=nil,
startTime=nil, progressConn=nil, dataCache={}, enabled=false,
StealRadius=63, StealDuration=1.3, TriggerRadius=10
}
local GS = _G.Xlu0GalaxyV3

local function getHRP()
local c=LP.Character
return c and c:FindFirstChild("HumanoidRootPart")
end

local function isMyPlot(plotName)
local plots=workspace:FindFirstChild("Plots")
if not plots then return false end
local plot=plots:FindFirstChild(plotName)
if not plot then return false end
local sign=plot:FindFirstChild("PlotSign")
if sign then
local yb=sign:FindFirstChild("YourBase")
if yb and yb:IsA("BillboardGui") then return yb.Enabled==true end
end
return false
end

local function findPrompt()
local hrp=getHRP()
if not hrp then return nil,nil end
local plots=workspace:FindFirstChild("Plots")
if not plots then return nil,nil end
local bestPrompt,bestDist,bestSpawn=nil,math.huge,nil

for _,plot in ipairs(plots:GetChildren()) do
if not plot:IsA("Model") then continue end
if isMyPlot(plot.Name) then continue end
local pods=plot:FindFirstChild("AnimalPodiums")
if not pods then continue end

for _,pod in ipairs(pods:GetChildren()) do
pcall(function()
local base=pod:FindFirstChild("Base")
local spawn=base and base:FindFirstChild("Spawn")
if not spawn then return end
local dist=(spawn.Position-hrp.Position).Magnitude
if dist>=bestDist or dist>GS.StealRadius then return end

local function tryPrompt(container)
for _,ch in ipairs(container:GetChildren()) do
if ch:IsA("ProximityPrompt") and ch.Enabled then
bestPrompt=ch
bestDist=dist
bestSpawn=spawn
return true
end
end
end

local att=spawn:FindFirstChild("PromptAttachment")
if not (att and tryPrompt(att)) then
for _,ch in ipairs(spawn:GetDescendants()) do
if ch:IsA("ProximityPrompt") and ch.Enabled then
bestPrompt=ch
bestDist=dist
bestSpawn=spawn
break
end
end
end
end)
end
end
return bestPrompt,bestSpawn
end

local function distToSpawn(spawnPart)
local hrp=getHRP()
if not hrp then return math.huge end
if not spawnPart or not spawnPart.Parent then
local _,ns=findPrompt()
return ns and (hrp.Position-ns.Position).Magnitude or math.huge
end
return (hrp.Position-spawnPart.Position).Magnitude
end

local function updateBar(p,state)
if _G.StealBar then
pcall(function()
_G.StealBar.SetProgress(p or 0)
if state then _G.StealBar.SetState(state) end
end)
end
end

local function execute(prompt,spawnPart)
if GS.active then return end

if not GS.dataCache[prompt] then
local data={hold={},trigger={},ready=true}
if getconnections_v3 then
pcall(function()
for _,c in ipairs(getconnections_v3(prompt.PromptButtonHoldBegan)) do
if c.Function then table.insert(data.hold,c.Function) end
end
for _,c in ipairs(getconnections_v3(prompt.Triggered)) do
if c.Function then table.insert(data.trigger,c.Function) end
end
end)
end
GS.dataCache[prompt]=data
end

local data=GS.dataCache[prompt]
if not data.ready then return end

data.ready=false
GS.active=true
GS.paused=false
GS.startTime=tick()-(GS.progress*GS.StealDuration)
local pauseArmed=true

if GS.progressConn then GS.progressConn:Disconnect() end
updateBar(GS.progress,"STEALING")

GS.progressConn=RunService.Heartbeat:Connect(function()
if not GS.active then
if GS.progressConn then GS.progressConn:Disconnect();GS.progressConn=nil end
return
end

if not GS.enabled or not autoStealEnabled or selectedStealMode~="Auto Steal V3" then
GS.active=false
GS.progress=0
GS.paused=false
data.ready=true
updateBar(0,autoStealEnabled and "READY" or "IDLE")
return
end

if GS.paused then
local dist=distToSpawn(spawnPart)
if dist<=GS.TriggerRadius then
GS.paused=false
GS.pauseTime=nil
GS.startTime=tick()-(0.8*GS.StealDuration)
else
if not GS.pauseTime then
GS.pauseTime=tick()
elseif tick()-GS.pauseTime>=1.3 then
GS.pauseTime=nil
GS.paused=false
GS.active=false
GS.progress=0
data.ready=true
pauseArmed=true
if GS.progressConn then GS.progressConn:Disconnect();GS.progressConn=nil end
updateBar(0,autoStealEnabled and "READY" or "IDLE")
return
end
GS.progress=0.8
updateBar(0.8,"STEALING")
return
end
end

local elapsed=tick()-GS.startTime
local prog=math.clamp(elapsed/GS.StealDuration,0,1)
GS.progress=prog

if pauseArmed and prog>=0.8 then
GS.paused=true
pauseArmed=false
GS.progress=0.8
updateBar(0.8,"STEALING")
return
end

updateBar(prog,"STEALING")

if prog>=1 then
GS.active=false
GS.progress=0
GS.paused=false
pauseArmed=true
if GS.progressConn then GS.progressConn:Disconnect();GS.progressConn=nil end

for _,fn in ipairs(data.trigger) do
task.spawn(function() pcall(fn) end)
end

data.ready=true
updateBar(0,autoStealEnabled and "READY" or "IDLE")
end
end)

for _,fn in ipairs(data.hold) do
task.spawn(function() pcall(fn) end)
end
end

_G.Xlu0NormalAutoStealSetRadius=function(v)
GS.StealRadius=tonumber(v) or GS.StealRadius or 63
end

_G.Xlu0NormalAutoStealStart=function()
if GS.conn then GS.conn:Disconnect();GS.conn=nil end
GS.enabled=true
GS.StealRadius=tonumber(autoStealRadius) or 63
GS.StealDuration=1.3
GS.TriggerRadius=10
GS.conn=RunService.Heartbeat:Connect(function()
if not GS.enabled or GS.active then return end
if not autoStealEnabled or selectedStealMode~="Auto Steal V3" then return end
local prompt,spawnPart=findPrompt()
if prompt then execute(prompt,spawnPart) end
end)
updateBar(0,"READY")
end

_G.Xlu0NormalAutoStealStop=function()
GS.enabled=false
if GS.conn then GS.conn:Disconnect();GS.conn=nil end
if GS.progressConn then GS.progressConn:Disconnect();GS.progressConn=nil end
GS.active=false
GS.progress=0
GS.paused=false
GS.pauseTime=nil
GS.dataCache={}
updateBar(0,autoStealEnabled and "READY" or "IDLE")
end

_G.Xlu0NormalAutoStealSync=function()
if autoStealEnabled and selectedStealMode=="Auto Steal V3" then
_G.Xlu0NormalAutoStealStart()
else
_G.Xlu0NormalAutoStealStop()
end
end
end
_G.__Xlu0SetupNormalAutoSteal()
_G.__Xlu0SetupSemiAutoSteal = function()
local A = _G.Xlu0SemiSteal
if not A then
A = {
enabled = false,
conn = nil,
scanThread = nil,
syncReady = false,
plots = nil,
animalsData = {},
syncRemotes = nil,
plotSync = {caches = {}, connections = {}},
animals = {},
promptCache = {},
internalCache = {},
radius = 9,
primeRange = 80,
holdMin = 1.3,
holdMax = 2.6,
entryDelay = 0.3,
cooldown = 0.05,
state = {
active = false,
startTime = 0,
phase = "idle",
label = "",
lastResult = "",
lastResultTime = 0,
totalSteals = 0,
failedSteals = 0,
},
}
_G.Xlu0SemiSteal = A
end
local function rootPart()
local char = LP.Character
return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
end
local function barSet(pct, status)
pct = math.clamp(pct or 0, 0, 1)
-- Steal UI daha sonra olusturuldugu icin lokal progressFill burada gorunmuyor.
-- UI'nin disariya actigi StealBar API'sini kullan.
if _G.StealBar then
    _G.StealBar.SetProgress(pct)
    _G.StealBar.SetState(status or "STEALING")
end
end
local function barReset()
if _G.StealBar then
    _G.StealBar.SetProgress(0)
    _G.StealBar.SetState(autoStealEnabled and "READY" or "IDLE")
end
end
local function splitSyncPath(path)
if typeof(path) == "table" then return path end
local out = {}
for part in string.gmatch(tostring(path), "[^%.]+") do table.insert(out, tonumber(part) or part) end
return out
end
local function resolveSyncPath(path, root)
local current, parent, key = root, nil, nil
for _, part in ipairs(splitSyncPath(path)) do
parent, key = current, part
current = current and current[part] or nil
end
return current, parent, key
end
local function applyPlotSyncDiff(channelName, packet)
local cache = A.plotSync.caches[channelName]
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
if not A.syncRemotes or A.plotSync.connections[remote] then return end
local channelName = tostring(remote.Name)
if not A.plots:FindFirstChild(channelName) then return end
if A.syncRemotes.requestData and A.plotSync.caches[channelName] == nil then
local ok, data = pcall(function() return A.syncRemotes.requestData:InvokeServer(channelName) end)
A.plotSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
elseif A.plotSync.caches[channelName] == nil then
A.plotSync.caches[channelName] = {}
end
A.plotSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
for _, packet in ipairs(queue) do applyPlotSyncDiff(channelName, packet) end
end)
end
local function ensureSync()
if A.syncReady then return true end
local ok = pcall(function()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
A.plots = workspace:WaitForChild("Plots")
local Packages = ReplicatedStorage:WaitForChild("Packages", 10)
local Datas = ReplicatedStorage:WaitForChild("Datas", 10)
if not Packages or not Datas then return end
A.animalsData = require(Datas:WaitForChild("Animals"))
local folder = Packages:WaitForChild("Synchronizer")
A.syncRemotes = {
channelFolder = folder:WaitForChild("Channel"),
routeRemote = folder:WaitForChild("CommunicationRoute"),
requestData = folder:FindFirstChild("RequestData"),
}
for _, child in ipairs(A.syncRemotes.channelFolder:GetChildren()) do
if child:IsA("RemoteEvent") then attachPlotChannel(child) end
end
A.syncRemotes.channelFolder.ChildAdded:Connect(function(child)
if child:IsA("RemoteEvent") then attachPlotChannel(child) end
end)
A.syncRemotes.routeRemote.OnClientEvent:Connect(function(actions)
for _, actionData in ipairs(actions) do
local kind, channelName = actionData[1], tostring(actionData[2])
if A.plots:FindFirstChild(channelName) then
if kind == "ListenerAdded" then
local remote = A.syncRemotes.channelFolder:FindFirstChild(channelName)
if remote and remote:IsA("RemoteEvent") then attachPlotChannel(remote) end
elseif kind == "ListenerRemoved" then
for remote, conn in pairs(A.plotSync.connections) do
if tostring(remote.Name) == channelName then
conn:Disconnect()
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
return owner == LP.DisplayName or owner == LP.Name
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
local function scanAllPlots()
if not ensureSync() then return 0 end
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
local function buildStealCallbacks(prompt)
if A.internalCache[prompt] then return end
local data = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}
local ok1, conns1 = false, nil
if getconnections then ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan) end
if ok1 and type(conns1) == "table" then
for _, conn in ipairs(conns1) do
if type(conn.Function) == "function" then table.insert(data.holdCallbacks, conn.Function) end
end
end
local ok2, conns2 = false, nil
if getconnections then ok2, conns2 = pcall(getconnections, prompt.Triggered) end
if ok2 and type(conns2) == "table" then
for _, conn in ipairs(conns2) do
if type(conn.Function) == "function" then table.insert(data.triggerCallbacks, conn.Function) end
end
end
if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then A.internalCache[prompt] = data end
end
local function executeCandySemi(prompt, animalData)
if not prompt or not prompt.Parent or not animalData then return false end
buildStealCallbacks(prompt)
local data = A.internalCache[prompt]
if not data or not data.ready then return false end
data.ready = false
local label = animalData.name or "Animal"
A.state.active = true
A.state.startTime = tick()
A.state.phase = "holding"
A.state.label = label
task.spawn(function()
for _, fn in ipairs(data.holdCallbacks) do task.spawn(function() pcall(fn) end) end
local holdStart = A.state.startTime
while A.enabled and selectedStealMode == "Semi" and tick() - holdStart < (A.holdMin or 1.3) do
barSet((tick() - holdStart) / (A.holdMax or 2.6), "STEALING")
task.wait()
end
A.state.phase = "waitingRange"
local alreadyInRange = distToAnimal(animalData) <= (tonumber(A.radius) or 9)
local fired = false
while A.enabled and selectedStealMode == "Semi" do
local elapsed = tick() - A.state.startTime
if elapsed > (A.holdMax or 2.6) or not prompt.Parent then break end
barSet(elapsed / (A.holdMax or 2.6), "WAITING RANGE")
if distToAnimal(animalData) <= (tonumber(A.radius) or 9) then
if not alreadyInRange then task.wait(A.entryDelay or 0.3) end
if A.enabled and selectedStealMode == "Semi" then
for _, fn in ipairs(data.triggerCallbacks) do task.spawn(function() pcall(fn) end) end
pcall(function() if _G.AutoCarrySpeed and _G.AutoCarrySpeed.WatchPickup then _G.AutoCarrySpeed.WatchPickup(1.25) end end)
fired = true
end
break
end
task.wait()
end
if fired then
A.state.totalSteals = (A.state.totalSteals or 0) + 1
A.state.lastResult = "Stole " .. label
A.state.phase = "success"
barSet(1, "SUCCESS")
else
A.state.failedSteals = (A.state.failedSteals or 0) + 1
A.state.lastResult = "Missed window: " .. label
A.state.phase = "failed"
barSet(1, "FAILED")
end
A.state.active = false
A.state.lastResultTime = tick()
task.wait(A.cooldown or 0.05)
data.ready = true
task.delay(0.8, function()
if not A.state.active then barReset() end
end)
end)
return true
end
local function ensureScanThread()
if A.scanThread then return end
A.scanThread = task.spawn(function()
while _G.Xlu0SemiSteal do
if A.enabled or selectedStealMode == "Semi" then pcall(scanAllPlots) end
task.wait(5)
end
end)
end
_G.Xlu0SemiAutoStealSetRadius = function(v)
local n = tonumber(v)
if n then A.radius = n end
end
_G.Xlu0SemiAutoStealStop = function()
A.enabled = false
if A.conn then A.conn:Disconnect(); A.conn = nil end
A.state.active = false
A.state.phase = "idle"
barReset()
end
_G.Xlu0SemiAutoStealStart = function()
A.radius = tonumber(autoStealRadius) or A.radius or 9
A.enabled = true
if not ensureSync() then return end
ensureScanThread()
pcall(scanAllPlots)
if A.conn then A.conn:Disconnect(); A.conn = nil end
A.conn = RunService.Heartbeat:Connect(function()
if not A.enabled then return end
if selectedStealMode ~= "Semi" then _G.Xlu0SemiAutoStealStop(); return end
if A.state.active then return end
local target = pickClosest()
if not target then return end
local prompt = A.promptCache[target.uid]
if not prompt or not prompt.Parent then prompt = findPromptForAnimal(target) end
if prompt then executeCandySemi(prompt, target) end
end)
end
_G.Xlu0SemiAutoStealSync = function()
if selectedStealMode == "Semi" and autoStealEnabled then
_G.Xlu0SemiAutoStealStart()
else
_G.Xlu0SemiAutoStealStop()
end
end
end
_G.__Xlu0SetupSemiAutoSteal()
_G.Xlu0AutoStealSync = function()
if not autoStealEnabled then
if _G.Xlu0NormalAutoStealStop then _G.Xlu0NormalAutoStealStop() end
if _G.Xlu0SemiAutoStealStop then _G.Xlu0SemiAutoStealStop() end
return
end
if selectedStealMode == "Auto Steal V3" then
if _G.Xlu0SemiAutoStealStop then _G.Xlu0SemiAutoStealStop() end
if _G.Xlu0NormalAutoStealSync then _G.Xlu0NormalAutoStealSync() end
elseif selectedStealMode == "Semi" then
if _G.Xlu0NormalAutoStealStop then _G.Xlu0NormalAutoStealStop() end
if _G.Xlu0SemiAutoStealSync then _G.Xlu0SemiAutoStealSync() end
end
end
task.spawn(function()
while task.wait(30) do
do end
end
end)
local lastMoveDir = Vector3.new(0, 0, 0)
local function getCurrentSpeedValue()
if currentSpeedMode == "Carry" then
return CS
elseif currentSpeedMode == "Lagger" then
return LAGGER_SPEED
elseif currentSpeedMode == "Lagger Carry" then
return LAGGER_CARRY_SPEED
end
return NS
end
local refreshSpeedModeRows = nil
local function setSpeedMode(mode)
if mode ~= "Normal" and mode ~= "Carry" and mode ~= "Lagger" and mode ~= "Lagger Carry" then
mode = "Normal"
end
currentSpeedMode = mode
if refreshSpeedModeRows then
refreshSpeedModeRows()
end
do end
end
local function toggleCarryMode()
if currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry" then
setSpeedMode("Carry")
elseif currentSpeedMode == "Carry" then
setSpeedMode("Normal")
else
setSpeedMode("Carry")
end
end
local function toggleLaggerMode()
if currentSpeedMode ~= "Lagger" and currentSpeedMode ~= "Lagger Carry" then
setSpeedMode("Lagger Carry")
elseif currentSpeedMode == "Lagger Carry" then
setSpeedMode("Lagger")
else
setSpeedMode("Lagger Carry")
end
end
State = State or {}
State.normalSpeed = NS
State.carrySpeed = CS
State.laggerSpeed = LAGGER_SPEED
State.speedToggled = (currentSpeedMode == "Carry" or currentSpeedMode == "Lagger Carry")
State.laggerEnabled = (currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry")
toggleRefs = toggleRefs or {}
function setCarry(on)
if on then
setSpeedMode("Carry")
else
if currentSpeedMode == "Carry" or currentSpeedMode == "Lagger Carry" then
setSpeedMode("Normal")
end
end
State.speedToggled = on == true
end
function setLagger(on)
if on then
setSpeedMode("Lagger")
else
if currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry" then
setSpeedMode("Normal")
end
end
State.laggerEnabled = on == true
end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
State = State or {}
State.normalSpeed = State.normalSpeed or 59
State.carrySpeed = State.carrySpeed or 30
State.laggerSpeed = State.laggerSpeed or 60
State.speedToggled = State.speedToggled or false
State.laggerEnabled = State.laggerEnabled or false
State._autoCarryFromSteal = State._autoCarryFromSteal or false
State._autoCarryGraceUntil = State._autoCarryGraceUntil or 0
State._waitingForCarryPickup = State._waitingForCarryPickup or false
State._carryPickupWatchUntil = State._carryPickupWatchUntil or 0
State._autoCarryReturnMode = State._autoCarryReturnMode or nil
toggleRefs = toggleRefs or {}
local function safeSaveConfig()
if type(saveConfig) == "function" then
task.spawn(saveConfig)
end
end
local function isCarryName(name)
local n = tostring(name or ""):lower()
return n:find("brainrot")
or n:find("animal")
or n:find("carry")
or n:find("grab")
or n:find("steal")
or n:find("hold")
end
local function isIgnoredCarryTool(name)
local n = tostring(name or ""):lower()
return n:find("bat")
or n:find("slap")
or n:find("medusa")
or n:find("head")
or n:find("stone")
end
local function isCarryingBrainrot(char)
if not char then return false end
for _, name in ipairs({"Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab"}) do
local v = char:FindFirstChild(name, true)
if v then
if v:IsA("BoolValue") and v.Value then
return true
end
if v:IsA("ObjectValue") and v.Value then
return true
end
if v:IsA("StringValue") and v.Value ~= "" then
return true
end
end
end
for _, child in ipairs(char:GetChildren()) do
if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
if child:FindFirstChildOfClass("Humanoid") and child:FindFirstChild("HumanoidRootPart") then
return true
end
if isCarryName(child.Name) then
return true
end
elseif child:IsA("Tool") and not isIgnoredCarryTool(child.Name) then
return true
end
end
return false
end
local function setCarrySpeedMode(on)
State.speedToggled = on
if toggleRefs.carryMode then
toggleRefs.carryMode(on)
end
if type(setCarry) == "function" then
setCarry(on)
end
end
local function setLaggerMode(on)
State.laggerEnabled = on
if toggleRefs.laggerMode then
toggleRefs.laggerMode(on)
end
if type(setLagger) == "function" then
setLagger(on)
end
end
local function enableCarrySpeedForSteal()
State._waitingForCarryPickup = false
State._carryPickupWatchUntil = 0
if not State._autoCarryFromSteal then
State._autoCarryReturnMode = currentSpeedMode
end
State._autoCarryFromSteal = true
State._autoCarryGraceUntil = tick() + 0.75
local wasLagger = (State._autoCarryReturnMode == "Lagger" or State._autoCarryReturnMode == "Lagger Carry"
or currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry")
if wasLagger then
State.laggerEnabled = true
State.speedToggled = true
if toggleRefs.laggerMode then toggleRefs.laggerMode(true) end
if toggleRefs.carryMode then toggleRefs.carryMode(true) end
setSpeedMode("Lagger Carry")
else
setLaggerMode(false)
setCarrySpeedMode(true)
end
safeSaveConfig()
end
local function disableAutoCarrySpeed()
if not State._autoCarryFromSteal and not State._waitingForCarryPickup then return end
local wasAutoApplied = State._autoCarryFromSteal == true
local returnMode = State._autoCarryReturnMode
State._autoCarryFromSteal = false
State._waitingForCarryPickup = false
State._autoCarryGraceUntil = 0
State._carryPickupWatchUntil = 0
State._autoCarryReturnMode = nil
if not wasAutoApplied then
return
end
if returnMode == "Lagger" or returnMode == "Lagger Carry" then
State.laggerEnabled = true
State.speedToggled = false
if toggleRefs.laggerMode then toggleRefs.laggerMode(true) end
if toggleRefs.carryMode then toggleRefs.carryMode(false) end
setSpeedMode("Lagger")
elseif returnMode == "Carry" then
State.laggerEnabled = false
State.speedToggled = true
if toggleRefs.laggerMode then toggleRefs.laggerMode(false) end
if toggleRefs.carryMode then toggleRefs.carryMode(true) end
setSpeedMode("Carry")
else
setLaggerMode(false)
setCarrySpeedMode(false)
end
safeSaveConfig()
end
local function startAutoCarryPickupWatch(seconds)
if autoCarrySpeedEnabled ~= true then return end
State._waitingForCarryPickup = true
State._carryPickupWatchUntil = tick() + (seconds or 1.25)
end
local _stealAttrWasActive = false
RunService.RenderStepped:Connect(function()
if autoCarrySpeedEnabled ~= true then
disableAutoCarrySpeed()
return
end
local char = LP.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
local root = char and char:FindFirstChild("HumanoidRootPart")
if not char or not hum or not root then
disableAutoCarrySpeed()
_stealAttrWasActive = false
return
end
local st = hum:GetState()
local gotHit = st == Enum.HumanoidStateType.Physics
or st == Enum.HumanoidStateType.Ragdoll
or st == Enum.HumanoidStateType.FallingDown
local stealingAttr = LP:GetAttribute("Stealing") == true
local carryingBrainrot = isCarryingBrainrot(char)
if stealingAttr and not _stealAttrWasActive then
_stealAttrWasActive = true
enableCarrySpeedForSteal()
elseif not stealingAttr then
_stealAttrWasActive = false
end
if State._waitingForCarryPickup then
if gotHit or tick() > (State._carryPickupWatchUntil or 0) then
State._waitingForCarryPickup = false
State._carryPickupWatchUntil = 0
elseif carryingBrainrot then
enableCarrySpeedForSteal()
end
end
if carryingBrainrot and not State._autoCarryFromSteal then
enableCarrySpeedForSteal()
end
if State._autoCarryFromSteal then
local graceDone = tick() > (State._autoCarryGraceUntil or 0)
if gotHit or (graceDone and not carryingBrainrot and not stealingAttr) then
disableAutoCarrySpeed()
end
end
end)
_G.AutoCarrySpeed = {
IsCarryingBrainrot = isCarryingBrainrot,
Enable = enableCarrySpeedForSteal,
Disable = disableAutoCarrySpeed,
WatchPickup = startAutoCarryPickupWatch,
}
_G.Xlu0AutoPathState = _G.Xlu0AutoPathState or {leftConn=nil,rightConn=nil,leftPhase=1,rightPhase=1}
_G.Xlu0AutoPathPoints = _G.Xlu0AutoPathPoints or {
L1=Vector3.new(-476.48,-6.28,92.73), L2=Vector3.new(-483.12,-4.95,94.80), LFace=Vector3.new(-482.25,-4.96,92.09),
R1=Vector3.new(-476.16,-6.52,25.62), R2=Vector3.new(-483.06,-5.03,25.48), RFace=Vector3.new(-482.06,-6.93,35.47),
}
function _G.Xlu0AutoPathSpeed()
if currentSpeedMode == "Lagger" or currentSpeedMode == "Lagger Carry" then
return LAGGER_SPEED
end
return NS
end
function _G.Xlu0StopAutoLeft()
local S=_G.Xlu0AutoPathState
if S.leftConn then S.leftConn:Disconnect(); S.leftConn=nil end
S.leftPhase=1
local char=LP.Character
local hum=char and char:FindFirstChildOfClass("Humanoid")
local hrp=char and char:FindFirstChild("HumanoidRootPart")
if hum then hum:Move(Vector3.zero,false) end
if hrp then hrp.AssemblyLinearVelocity=Vector3.new(0,hrp.AssemblyLinearVelocity.Y,0) end
end
function _G.Xlu0StopAutoRight()
local S=_G.Xlu0AutoPathState
if S.rightConn then S.rightConn:Disconnect(); S.rightConn=nil end
S.rightPhase=1
local char=LP.Character
local hum=char and char:FindFirstChildOfClass("Humanoid")
local hrp=char and char:FindFirstChild("HumanoidRootPart")
if hum then hum:Move(Vector3.zero,false) end
if hrp then hrp.AssemblyLinearVelocity=Vector3.new(0,hrp.AssemblyLinearVelocity.Y,0) end
end
function _G.Xlu0SetAutoLeft(on, skipSave)
if on and _G.Xlu0SafeModeTryStart and not _G.Xlu0SafeModeTryStart() then
autoLeftEnabled = false
if _G.Xlu0SetAutoLeftVisual then _G.Xlu0SetAutoLeftVisual(false) end
if not skipSave then do end end
return false
end
autoLeftEnabled = on and true or false
if _G.Xlu0SetAutoLeftVisual then _G.Xlu0SetAutoLeftVisual(autoLeftEnabled) end
if autoLeftEnabled then
autoRightEnabled=false
if _G.Xlu0SetAutoRightVisual then _G.Xlu0SetAutoRightVisual(false) end
if _G.Xlu0StopAutoRight then _G.Xlu0StopAutoRight() end
if _G.Xlu0StartAutoLeft then _G.Xlu0StartAutoLeft() end
else
if _G.Xlu0StopAutoLeft then _G.Xlu0StopAutoLeft() end
end
if not skipSave then do end end
end
function _G.Xlu0SetAutoRight(on, skipSave)
if on and _G.Xlu0SafeModeTryStart and not _G.Xlu0SafeModeTryStart() then
autoRightEnabled = false
if _G.Xlu0SetAutoRightVisual then _G.Xlu0SetAutoRightVisual(false) end
if not skipSave then do end end
return false
end
autoRightEnabled = on and true or false
if _G.Xlu0SetAutoRightVisual then _G.Xlu0SetAutoRightVisual(autoRightEnabled) end
if autoRightEnabled then
autoLeftEnabled=false
if _G.Xlu0SetAutoLeftVisual then _G.Xlu0SetAutoLeftVisual(false) end
if _G.Xlu0StopAutoLeft then _G.Xlu0StopAutoLeft() end
if _G.Xlu0StartAutoRight then _G.Xlu0StartAutoRight() end
else
if _G.Xlu0StopAutoRight then _G.Xlu0StopAutoRight() end
end
if not skipSave then do end end
end

--// ==================== ZOMBIE HUB MOVEMENT BACKEND ====================
_G.Xlu0ZombieMove = _G.Xlu0ZombieMove or {
    leftConn = nil,
    rightConn = nil,
    leftPhase = 1,
    rightPhase = 1,
    attachment = nil,
    linearVelocity = nil,
}

_G.Xlu0AutoMoveSpeed = tonumber(_G.Xlu0AutoMoveSpeed) or 60
_G.Xlu0AutoMoveCarrySpeed = tonumber(_G.Xlu0AutoMoveCarrySpeed) or 30
_G.Xlu0DuelMode = (_G.Xlu0DuelMode == "full") and "full" or "half"

_G.Xlu0ZombieMovePoints = _G.Xlu0ZombieMovePoints or {
    L1 = Vector3.new(-476.48, -6.28, 92.73),
    L2 = Vector3.new(-483.12, -4.95, 94.80),
    LFace = Vector3.new(-482.25, -4.96, 92.09),

    R1 = Vector3.new(-476.16, -6.52, 25.62),
    R2 = Vector3.new(-483.06, -5.03, 25.48),
    RFace = Vector3.new(-482.06, -6.93, 35.47),

    FullLeft = {
        Vector3.new(-474.0, -7.3, 90.2),
        Vector3.new(-484.9, -5.1, 97.2),
        Vector3.new(-473.6, -7.3, 93.5),
        Vector3.new(-473.0, -7.3, 27.6),
        Vector3.new(-487.2, -5.3, 20.9),
    },

    FullRight = {
        Vector3.new(-472.5, -7.3, 30.9),
        Vector3.new(-483.8, -5.4, 25.5),
        Vector3.new(-472.4, -7.3, 30.5),
        Vector3.new(-472.0, -7.3, 93.6),
        Vector3.new(-482.8, -5.4, 97.8),
    }
}

function _G.Xlu0ZombieEnsureLinearVelocity(hrp)
    local S = _G.Xlu0ZombieMove

    if S.linearVelocity and S.linearVelocity.Parent and S.attachment and S.attachment.Parent == hrp then
        return S.linearVelocity
    end

    if S.linearVelocity then
        pcall(function() S.linearVelocity:Destroy() end)
    end
    if S.attachment then
        pcall(function() S.attachment:Destroy() end)
    end

    local att = Instance.new("Attachment")
    att.Name = "Xlu0ZombieMoveAttachment"
    att.Parent = hrp

    local lv = Instance.new("LinearVelocity")
    lv.Name = "Xlu0ZombieMoveVelocity"
    lv.Attachment0 = att
    lv.RelativeTo = Enum.ActuatorRelativeTo.World
    lv.ForceLimitMode = Enum.ForceLimitMode.PerAxis
    lv.MaxAxesForce = Vector3.new(math.huge, 0, math.huge)
    lv.VectorVelocity = Vector3.zero
    lv.Parent = att

    S.attachment = att
    S.linearVelocity = lv
    return lv
end

function _G.Xlu0ZombieStopVelocity()
    local S = _G.Xlu0ZombieMove
    if S.linearVelocity and S.linearVelocity.Parent then
        S.linearVelocity.VectorVelocity = Vector3.zero
        S.linearVelocity.MaxAxesForce = Vector3.zero
        S.linearVelocity.Enabled = false
    end
end

function _G.Xlu0StopAutoLeft()
    local S = _G.Xlu0ZombieMove
    if S.leftConn then
        S.leftConn:Disconnect()
        S.leftConn = nil
    end
    S.leftPhase = 1

    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum:Move(Vector3.zero, false) end
    _G.Xlu0ZombieStopVelocity()

    if _G.Xlu0SetAutoLeftVisual then
        pcall(function() _G.Xlu0SetAutoLeftVisual(false) end)
    end
end

function _G.Xlu0StopAutoRight()
    local S = _G.Xlu0ZombieMove
    if S.rightConn then
        S.rightConn:Disconnect()
        S.rightConn = nil
    end
    S.rightPhase = 1

    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum:Move(Vector3.zero, false) end
    _G.Xlu0ZombieStopVelocity()

    if _G.Xlu0SetAutoRightVisual then
        pcall(function() _G.Xlu0SetAutoRightVisual(false) end)
    end
end

function _G.Xlu0ZombieMoveIsFull()
    return (_G.Xlu0DuelMode == "full")
        or (_G.Xlu0DuelMode == "Full")
        or (typeof(State) == "table" and State.duelMode == "full")
end

function _G.Xlu0StartAutoLeft()
    if autoRightEnabled then
        autoRightEnabled = false
        _G.Xlu0StopAutoRight()
    end

    local S = _G.Xlu0ZombieMove
    if S.leftConn then S.leftConn:Disconnect() end
    S.leftPhase = 1

    S.leftConn = RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        if dropBrainrotActive then return end

        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end

        local st = hum:GetState()
        if hum.PlatformStand
            or st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown then
            hum:Move(Vector3.zero, false)
            _G.Xlu0ZombieStopVelocity()
            return
        end

        local lv = _G.Xlu0ZombieEnsureLinearVelocity(hrp)
        lv.Enabled = true
        lv.MaxAxesForce = Vector3.new(math.huge, 0, math.huge)
        local P = _G.Xlu0ZombieMovePoints
        local spd = tonumber(_G.Xlu0AutoMoveSpeed) or NS or 60

        if _G.Xlu0ZombieMoveIsFull() then
            local points = P.FullLeft
            if S.leftPhase > #points then
                _G.Xlu0ZombieStopVelocity()
                local prev = points[#points - 1] or points[#points]
                hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(prev.X, hrp.Position.Y, prev.Z))
                hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                hum:Move(Vector3.zero, false)
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
                autoLeftEnabled = false
                if S.leftConn then S.leftConn:Disconnect(); S.leftConn = nil end
                S.leftPhase = 1
                if _G.Xlu0SetAutoLeftVisual then _G.Xlu0SetAutoLeftVisual(false) end
                return
            end

            local tgt = points[S.leftPhase]
            local flat = Vector3.new(tgt.X, hrp.Position.Y, tgt.Z)
            if (flat - hrp.Position).Magnitude < 1 then
                S.leftPhase += 1
                return
            end

            local dir = (flat - hrp.Position).Unit
            local fspd = (S.leftPhase <= 2)
                and (tonumber(_G.Xlu0AutoMoveSpeed) or 60)
                or (tonumber(_G.Xlu0AutoMoveCarrySpeed) or 30)

            lv.VectorVelocity = Vector3.new(dir.X * fspd, 0, dir.Z * fspd)
        else
            if S.leftPhase == 1 then
                local tgt = Vector3.new(P.L1.X, hrp.Position.Y, P.L1.Z)
                if (tgt - hrp.Position).Magnitude < 1 then
                    S.leftPhase = 2
                    return
                end

                local d = P.L1 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                lv.VectorVelocity = Vector3.new(mv.X * spd, 0, mv.Z * spd)
            else
                local tgt = Vector3.new(P.L2.X, hrp.Position.Y, P.L2.Z)
                if (tgt - hrp.Position).Magnitude < 1 then
                    hum:Move(Vector3.zero, false)
                    _G.Xlu0ZombieStopVelocity()
                    hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                    hum:Move(Vector3.zero, false)
                    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
                    autoLeftEnabled = false
                    if S.leftConn then S.leftConn:Disconnect(); S.leftConn = nil end
                    S.leftPhase = 1
                    if _G.Xlu0SetAutoLeftVisual then _G.Xlu0SetAutoLeftVisual(false) end
                    if P.LFace and (P.LFace - hrp.Position).Magnitude > 0.01 then
                        hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(P.LFace.X, hrp.Position.Y, P.LFace.Z))
                    end
                    return
                end

                local d = P.L2 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                lv.VectorVelocity = Vector3.new(mv.X * spd, 0, mv.Z * spd)
            end
        end
    end)
end

function _G.Xlu0StartAutoRight()
    if autoLeftEnabled then
        autoLeftEnabled = false
        _G.Xlu0StopAutoLeft()
    end

    local S = _G.Xlu0ZombieMove
    if S.rightConn then S.rightConn:Disconnect() end
    S.rightPhase = 1

    S.rightConn = RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        if dropBrainrotActive then return end

        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end

        local st = hum:GetState()
        if hum.PlatformStand
            or st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown then
            hum:Move(Vector3.zero, false)
            _G.Xlu0ZombieStopVelocity()
            return
        end

        local lv = _G.Xlu0ZombieEnsureLinearVelocity(hrp)
        lv.Enabled = true
        lv.MaxAxesForce = Vector3.new(math.huge, 0, math.huge)
        local P = _G.Xlu0ZombieMovePoints
        local spd = tonumber(_G.Xlu0AutoMoveSpeed) or NS or 60

        if _G.Xlu0ZombieMoveIsFull() then
            local points = P.FullRight
            if S.rightPhase > #points then
                _G.Xlu0ZombieStopVelocity()
                local prev = points[#points - 1] or points[#points]
                hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(prev.X, hrp.Position.Y, prev.Z))
                hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                hum:Move(Vector3.zero, false)
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
                autoRightEnabled = false
                if S.rightConn then S.rightConn:Disconnect(); S.rightConn = nil end
                S.rightPhase = 1
                if _G.Xlu0SetAutoRightVisual then _G.Xlu0SetAutoRightVisual(false) end
                return
            end

            local tgt = points[S.rightPhase]
            local flat = Vector3.new(tgt.X, hrp.Position.Y, tgt.Z)
            if (flat - hrp.Position).Magnitude < 1 then
                S.rightPhase += 1
                return
            end

            local dir = (flat - hrp.Position).Unit
            local fspd = (S.rightPhase <= 2)
                and (tonumber(_G.Xlu0AutoMoveSpeed) or 60)
                or (tonumber(_G.Xlu0AutoMoveCarrySpeed) or 30)

            lv.VectorVelocity = Vector3.new(dir.X * fspd, 0, dir.Z * fspd)
        else
            if S.rightPhase == 1 then
                local tgt = Vector3.new(P.R1.X, hrp.Position.Y, P.R1.Z)
                if (tgt - hrp.Position).Magnitude < 1 then
                    S.rightPhase = 2
                    return
                end

                local d = P.R1 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                lv.VectorVelocity = Vector3.new(mv.X * spd, 0, mv.Z * spd)
            else
                local tgt = Vector3.new(P.R2.X, hrp.Position.Y, P.R2.Z)
                if (tgt - hrp.Position).Magnitude < 1 then
                    hum:Move(Vector3.zero, false)
                    _G.Xlu0ZombieStopVelocity()
                    hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                    hum:Move(Vector3.zero, false)
                    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
                    autoRightEnabled = false
                    if S.rightConn then S.rightConn:Disconnect(); S.rightConn = nil end
                    S.rightPhase = 1
                    if _G.Xlu0SetAutoRightVisual then _G.Xlu0SetAutoRightVisual(false) end
                    if P.RFace and (P.RFace - hrp.Position).Magnitude > 0.01 then
                        hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(P.RFace.X, hrp.Position.Y, P.RFace.Z))
                    end
                    return
                end

                local d = P.R2 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                lv.VectorVelocity = Vector3.new(mv.X * spd, 0, mv.Z * spd)
            end
        end
    end)
end

-- Keep old setters but route them into Zombie movement backend.
function _G.Xlu0SetAutoLeft(on, skipSave)
    autoLeftEnabled = on == true
    if autoLeftEnabled then
        autoRightEnabled = false
        _G.Xlu0StopAutoRight()
        _G.Xlu0StartAutoLeft()
    else
        _G.Xlu0StopAutoLeft()
    end
    if _G.Xlu0SetAutoLeftVisual then _G.Xlu0SetAutoLeftVisual(autoLeftEnabled) end
end

function _G.Xlu0SetAutoRight(on, skipSave)
    autoRightEnabled = on == true
    if autoRightEnabled then
        autoLeftEnabled = false
        _G.Xlu0StopAutoLeft()
        _G.Xlu0StartAutoRight()
    else
        _G.Xlu0StopAutoRight()
    end
    if _G.Xlu0SetAutoRightVisual then _G.Xlu0SetAutoRightVisual(autoRightEnabled) end
end
--// ==================== END ZOMBIE HUB MOVEMENT BACKEND ====================

LP.CharacterAdded:Connect(function()
task.wait(0.5)
if autoLeftEnabled and _G.Xlu0StartAutoLeft then _G.Xlu0StartAutoLeft() end
if autoRightEnabled and _G.Xlu0StartAutoRight then _G.Xlu0StartAutoRight() end
end)
local overheadGui = nil
local overheadSpeedLabel = nil
local function setupOverheadInfo(char)
if overheadGui then
pcall(function() overheadGui:Destroy() end)
overheadGui = nil
overheadSpeedLabel = nil
end
if not char then return end
local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 5)
if not head then return end
overheadGui = Instance.new("BillboardGui")
overheadGui.Name = "Xlu0DuelsOverheadInfo"
overheadGui.Size = UDim2.new(0, 250, 0, 88)
overheadGui.StudsOffset = Vector3.new(0, 1.75, 0)
overheadGui.AlwaysOnTop = true
overheadGui.LightInfluence = 0
overheadGui.Parent = head
ragdollCountdownLabel = Instance.new("TextLabel")
ragdollCountdownLabel.Name = "RagdollCountdown"
ragdollCountdownLabel.Size = UDim2.new(1, 0, 0, 26)
ragdollCountdownLabel.Position = UDim2.new(0, 0, 0, 0)
ragdollCountdownLabel.BackgroundTransparency = 1
ragdollCountdownLabel.Text = ""
ragdollCountdownLabel.Visible = false
ragdollCountdownLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
ragdollCountdownLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
ragdollCountdownLabel.TextStrokeTransparency = 1
ragdollCountdownLabel.Font = Enum.Font.Arcade
ragdollCountdownLabel.TextSize = 22
ragdollCountdownLabel.TextXAlignment = Enum.TextXAlignment.Center
ragdollCountdownLabel.ZIndex = 10
ragdollCountdownLabel.Parent = overheadGui
local discordLbl = Instance.new("TextLabel")
discordLbl.Name = "Discord"
discordLbl.Size = UDim2.new(1, 0, 0, 30)
discordLbl.Position = UDim2.new(0, 0, 0, 26)
discordLbl.BackgroundTransparency = 1
discordLbl.Text = "Xlu0.vs"
discordLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
discordLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
discordLbl.TextStrokeTransparency = 1
discordLbl.Font = Enum.Font.Arcade
discordLbl.TextSize = 21
discordLbl.TextXAlignment = Enum.TextXAlignment.Center
discordLbl.ZIndex = 10
discordLbl.Parent = overheadGui
overheadSpeedLabel = Instance.new("TextLabel")
overheadSpeedLabel.Name = "Speed"
overheadSpeedLabel.Size = UDim2.new(1, 0, 0, 26)
overheadSpeedLabel.Position = UDim2.new(0, 0, 0, 54)
overheadSpeedLabel.BackgroundTransparency = 1
overheadSpeedLabel.Text = "Speed: 0"
overheadSpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
overheadSpeedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
overheadSpeedLabel.TextStrokeTransparency = 1
overheadSpeedLabel.Font = Enum.Font.Arcade
overheadSpeedLabel.TextSize = 19
overheadSpeedLabel.TextXAlignment = Enum.TextXAlignment.Center
overheadSpeedLabel.ZIndex = 10
overheadSpeedLabel.Parent = overheadGui
end
local ragdollCountdownConn = nil
local ragdollCountdownCharConn = nil
local ragdollCountdownEndTime = 0
local RAGDOLL_COUNTDOWN_SECONDS = 2.6
function stopRagdollCountdown()
if ragdollCountdownConn then ragdollCountdownConn:Disconnect(); ragdollCountdownConn = nil end
if ragdollCountdownCharConn then ragdollCountdownCharConn:Disconnect(); ragdollCountdownCharConn = nil end
if ragdollCountdownLabel then
ragdollCountdownLabel.Visible = false
ragdollCountdownLabel.Text = ""
end
end
function hookRagdollCountdown(char)
stopRagdollCountdown()
if not ragdollCountdownEnabled then return end
char = char or LP.Character
if not char then return end
local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 4)
if not hum then return end
local function beginCountdown()
ragdollCountdownEndTime = tick() + RAGDOLL_COUNTDOWN_SECONDS
if ragdollCountdownLabel then
ragdollCountdownLabel.Visible = true
end
end
local function isRagdollStateForCountdown()
local st = hum:GetState()
return hum.PlatformStand
or st == Enum.HumanoidStateType.Physics
or st == Enum.HumanoidStateType.Ragdoll
or st == Enum.HumanoidStateType.FallingDown
end
ragdollCountdownCharConn = hum.StateChanged:Connect(function(_, newState)
if newState == Enum.HumanoidStateType.Physics
or newState == Enum.HumanoidStateType.Ragdoll
or newState == Enum.HumanoidStateType.FallingDown then
beginCountdown()
end
end)
ragdollCountdownConn = RunService.RenderStepped:Connect(function()
if not ragdollCountdownEnabled then stopRagdollCountdown(); return end
if not ragdollCountdownLabel or not ragdollCountdownLabel.Parent then return end
if isRagdollStateForCountdown() and ragdollCountdownEndTime < tick() then
beginCountdown()
end
local left = math.max(0, ragdollCountdownEndTime - tick())
if left > 0 then
ragdollCountdownLabel.Visible = true
ragdollCountdownLabel.Text = string.format("RAGDOLL %.1f", left)
if left <= 1 then
ragdollCountdownLabel.TextColor3 = Color3.fromRGB(255, 230, 90)
else
ragdollCountdownLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
end
else
ragdollCountdownLabel.Visible = false
ragdollCountdownLabel.Text = ""
end
end)
end
if LP.Character then
task.spawn(function()
setupOverheadInfo(LP.Character)
end)
end
LP.CharacterAdded:Connect(function(char)
task.wait(0.5)
setupOverheadInfo(char)
if ragdollCountdownEnabled then hookRagdollCountdown(char) end
end)
local function getHorizontalSpeedLinearVelocity(hrp)
local attachment = hrp:FindFirstChild("Xlu0SpeedAttachment")
if not attachment then
attachment = Instance.new("Attachment")
attachment.Name = "Xlu0SpeedAttachment"
attachment.Parent = hrp
end
local linearVelocity = hrp:FindFirstChild("Xlu0HorizontalSpeed")
if not linearVelocity then
linearVelocity = Instance.new("LinearVelocity")
linearVelocity.Name = "Xlu0HorizontalSpeed"
linearVelocity.Attachment0 = attachment
linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
linearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
linearVelocity.PrimaryTangentAxis = Vector3.new(1, 0, 0)
linearVelocity.SecondaryTangentAxis = Vector3.new(0, 0, 1)
linearVelocity.ForceLimitsEnabled = true
linearVelocity.MaxForce = 18000
linearVelocity.PlaneVelocity = Vector2.zero
linearVelocity.Parent = hrp
end
return linearVelocity
end
RunService.RenderStepped:Connect(function()
local char = LP.Character
if not char then return end
local hum = char:FindFirstChildOfClass("Humanoid")
local hrp = char:FindFirstChild("HumanoidRootPart")
if not hum or not hrp then return end
local speedVelocity = getHorizontalSpeedLinearVelocity(hrp)
local state = hum:GetState()
if hum.PlatformStand
or state == Enum.HumanoidStateType.Physics
or state == Enum.HumanoidStateType.Ragdoll
or state == Enum.HumanoidStateType.FallingDown then
lastMoveDir = Vector3.new(0, 0, 0)
speedVelocity.PlaneVelocity = Vector2.zero
speedVelocity.Enabled = false
return
end
local aimbotActive = _G.Xlu0NormalAimbotOn == true
or _G.Xlu0AntiBypassAimbotOn == true
or _G.Xlu0AntiDesyncAimbotOn == true
if autoLeftEnabled or autoRightEnabled then
speedVelocity.PlaneVelocity = Vector2.zero
speedVelocity.Enabled = false
elseif aimbotActive then
-- Aimbot kendi AssemblyLinearVelocity değerini üretir; LinearVelocity bunu yatayda korur.
local aimVelocity = hrp.AssemblyLinearVelocity
speedVelocity.Enabled = true
speedVelocity.PlaneVelocity = Vector2.new(aimVelocity.X, aimVelocity.Z)
else
speedVelocity.Enabled = true
local md = hum.MoveDirection
local spd = getCurrentSpeedValue()
if md.Magnitude > 0 then
lastMoveDir = md
speedVelocity.PlaneVelocity = Vector2.new(md.X * spd, md.Z * spd)
else
lastMoveDir = Vector3.new(0, 0, 0)
speedVelocity.PlaneVelocity = Vector2.zero
speedVelocity.Enabled = false
end
end
if overheadSpeedLabel then
local v = hrp.AssemblyLinearVelocity
local speedMag = Vector3.new(v.X, 0, v.Z).Magnitude
local rounded = math.floor(speedMag * 10 + 0.5) / 10
if math.abs(rounded - math.floor(rounded)) < 0.05 then
overheadSpeedLabel.Text = string.format("Speed: %d", math.floor(rounded + 0.5))
else
overheadSpeedLabel.Text = string.format("Speed: %.1f", rounded)
end
end
end)
local COLORS = {
bg = Color3.fromRGB(0, 0, 0),
row = Color3.fromRGB(6, 6, 9),
row2 = Color3.fromRGB(8, 8, 12),
stroke = Color3.fromRGB(90, 90, 105),
strokeSoft = Color3.fromRGB(60, 60, 72),
white = Color3.fromRGB(255, 255, 255),
textDim = Color3.fromRGB(180, 180, 190),
toggleBg = Color3.fromRGB(18, 18, 26),
knob = Color3.fromRGB(238, 238, 245),
}
function corner(parent, radius)
local c = Instance.new("UICorner")
c.CornerRadius = UDim.new(0, radius or 8)
c.Parent = parent
return c
end
function stroke(parent, color, thickness, transparency)
local s = Instance.new("UIStroke")
s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
s.Color = color or COLORS.stroke
s.Thickness = thickness or 1
s.Transparency = transparency or 0.35
s.Parent = parent
local g = Instance.new("UIGradient")
g.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(155, 160, 185)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
})
g.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0.55),
NumberSequenceKeypoint.new(0.5, 0.1),
NumberSequenceKeypoint.new(1, 0.55),
})
g.Parent = s
return s
end
function tween(obj, props, time)
TweenService:Create(obj, TweenInfo.new(time or 0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

function _G.Xlu0AddMovingEdgeLight(btn)
if not btn or not btn:IsA("GuiButton") then return end
if btn.Name ~= "ArrowButton" then return end
if btn:FindFirstChild("Xlu0MovingEdge") then return end

local edge = Instance.new("UIStroke")
edge.Name = "Xlu0MovingEdge"
edge.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
edge.Color = Color3.fromRGB(255,255,255)
edge.Thickness = 2
edge.Transparency = 0.08
edge.LineJoinMode = Enum.LineJoinMode.Round
edge.Parent = btn

local grad = Instance.new("UIGradient")
grad.Name = "MovingLight"
grad.Rotation = 0
grad.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0.00, Color3.fromRGB(95,95,95)),
ColorSequenceKeypoint.new(0.38, Color3.fromRGB(125,125,125)),
ColorSequenceKeypoint.new(0.46, Color3.fromRGB(235,235,235)),
ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.54, Color3.fromRGB(235,235,235)),
ColorSequenceKeypoint.new(0.62, Color3.fromRGB(125,125,125)),
ColorSequenceKeypoint.new(1.00, Color3.fromRGB(95,95,95))
})
grad.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0.00, 0.90),
NumberSequenceKeypoint.new(0.37, 0.82),
NumberSequenceKeypoint.new(0.45, 0.28),
NumberSequenceKeypoint.new(0.50, 0.00),
NumberSequenceKeypoint.new(0.55, 0.28),
NumberSequenceKeypoint.new(0.63, 0.82),
NumberSequenceKeypoint.new(1.00, 0.90)
})
grad.Parent = edge

local glow = Instance.new("UIStroke")
glow.Name = "Xlu0MovingEdgeGlow"
glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
glow.Color = Color3.fromRGB(255,255,255)
glow.Thickness = 4.2
glow.Transparency = 0.66
glow.LineJoinMode = Enum.LineJoinMode.Round
glow.Parent = btn

local glowGrad = grad:Clone()
glowGrad.Name = "MovingGlow"
glowGrad.Parent = glow

local info = TweenInfo.new(1.15, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false, 0)
pcall(function()
TweenService:Create(grad, info, {Rotation = 360}):Play()
TweenService:Create(glowGrad, info, {Rotation = 360}):Play()
end)
end

function _G.Xlu0ApplyMovingEdgeLights(root)
root = root or PlayerGui
if not root then return end

for _, obj in ipairs(root:GetDescendants()) do
if (obj:IsA("TextButton") or obj:IsA("ImageButton")) and obj.Name == "ArrowButton" then
pcall(function() _G.Xlu0AddMovingEdgeLight(obj) end)
end
end

root.DescendantAdded:Connect(function(obj)
if (obj:IsA("TextButton") or obj:IsA("ImageButton")) and obj.Name == "ArrowButton" then
task.defer(function()
task.wait()
pcall(function() _G.Xlu0AddMovingEdgeLight(obj) end)
end)
end
end)
end

function makeDraggable(frame)
local dragging = false
local dragStart
local startPos
local dragInput
frame.InputBegan:Connect(function(input)
if _G.Xlu0GuiLocked == true then return end
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
frame.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
dragInput = input
end
end)
UserInputService.InputChanged:Connect(function(input)
if _G.Xlu0GuiLocked == true then return end
if input == dragInput and dragging then
local delta = input.Position - dragStart
frame.Position = UDim2.new(
startPos.X.Scale,
startPos.X.Offset + delta.X,
startPos.Y.Scale,
startPos.Y.Offset + delta.Y
)
end
end)
end
local Gui = Instance.new("ScreenGui")
Gui.Name = "Xlu0DuelsAdaptReconstruct"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui
local FULL_MAIN_SIZE = UDim2.new(0, 356, 0, 536)
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(0, 0.5)
Main.Size = FULL_MAIN_SIZE
Main.Position = tableToUDim2(savedMainPositionTable, UDim2.new(0, 20, 0.5, 0))
savedMainPositionTable = udim2ToTable(Main.Position)
Main.BackgroundColor3 = COLORS.bg
Main.BorderSizePixel = 0
Main.Active = true
Main.ClipsDescendants = false
Main.Parent = Gui
corner(Main, 14)
stroke(Main, COLORS.stroke, 1.1, 0.35)
makeDraggable(Main)
Main:GetPropertyChangedSignal("Position"):Connect(function()
savedMainPositionTable = udim2ToTable(Main.Position)
end)
local MiniFrame = Instance.new("Frame")
MiniFrame.Name = "MiniFrame"
MiniFrame.AnchorPoint = Vector2.new(0, 0)
MiniFrame.Size = UDim2.new(0, 136, 0, 42)
local MINI_DEFAULT_POSITION = UDim2.new(0, 132, 0, 112)
MiniFrame.Position = MINI_DEFAULT_POSITION
savedMiniPositionTable = nil
MiniFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MiniFrame.BackgroundTransparency = 0
MiniFrame.BorderSizePixel = 0
MiniFrame.Visible = false
MiniFrame.Active = true
MiniFrame.ZIndex = 20
MiniFrame.Parent = Gui
corner(MiniFrame, 21)
local MiniButton = Instance.new("TextButton")
MiniButton.Name = "MiniButton"
MiniButton.Size = UDim2.new(1, 0, 1, 0)
MiniButton.BackgroundTransparency = 1
MiniButton.Text = "XLU0 DUELS"
MiniButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
MiniButton.TextStrokeTransparency = 1
MiniButton.TextSize = 11
MiniButton.Font = Enum.Font.Arcade
MiniButton.TextXAlignment = Enum.TextXAlignment.Center
MiniButton.AutoButtonColor = false
MiniButton.ZIndex = 24
MiniButton.Parent = MiniFrame

-- Video-style white glow shimmer for minimized XLU0 DUELS title.
local MiniShimmerText = Instance.new("TextLabel")
MiniShimmerText.Name = "MiniShimmerText"
MiniShimmerText.Size = UDim2.new(1, 0, 1, 0)
MiniShimmerText.Position = UDim2.new(0, 0, 0, 0)
MiniShimmerText.BackgroundTransparency = 1
MiniShimmerText.Text = "XLU0 DUELS"
MiniShimmerText.TextColor3 = Color3.fromRGB(255,255,255)
MiniShimmerText.TextTransparency = 0
MiniShimmerText.TextStrokeTransparency = 1
MiniShimmerText.TextSize = 11
MiniShimmerText.Font = Enum.Font.Arcade
MiniShimmerText.TextXAlignment = Enum.TextXAlignment.Center
MiniShimmerText.Active = false
MiniShimmerText.Selectable = false
MiniShimmerText.ZIndex = 22
MiniShimmerText.Parent = MiniFrame

-- wider bright core + softer glow on both sides
local MiniShimmerGradient = Instance.new("UIGradient")
MiniShimmerGradient.Rotation = 8
MiniShimmerGradient.Offset = Vector2.new(-1.45, 0)
MiniShimmerGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(0.44, Color3.fromRGB(235,235,235)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(0.56, Color3.fromRGB(235,235,235)),
    ColorSequenceKeypoint.new(0.65, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255,255,255))
})
MiniShimmerGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0.00, 1.00),
    NumberSequenceKeypoint.new(0.34, 1.00),
    NumberSequenceKeypoint.new(0.40, 0.88),
    NumberSequenceKeypoint.new(0.44, 0.55),
    NumberSequenceKeypoint.new(0.48, 0.16),
    NumberSequenceKeypoint.new(0.50, 0.00),
    NumberSequenceKeypoint.new(0.52, 0.16),
    NumberSequenceKeypoint.new(0.56, 0.55),
    NumberSequenceKeypoint.new(0.60, 0.88),
    NumberSequenceKeypoint.new(0.66, 1.00),
    NumberSequenceKeypoint.new(1.00, 1.00)
})
MiniShimmerGradient.Parent = MiniShimmerText

-- soft halo layer to mimic the video's bloom
local MiniGlowText = MiniShimmerText:Clone()
MiniGlowText.Name = "MiniGlowText"
MiniGlowText.TextTransparency = 0.42
MiniGlowText.TextStrokeTransparency = 1
MiniGlowText.ZIndex = 21
MiniGlowText.Parent = MiniFrame

local MiniGlowGradient = MiniShimmerGradient:Clone()
MiniGlowGradient.Parent = MiniGlowText

task.spawn(function()
    while MiniShimmerText and MiniShimmerText.Parent do
        MiniShimmerGradient.Offset = Vector2.new(-1.45, 0)
        MiniGlowGradient.Offset = Vector2.new(-1.45, 0)

        local t1 = TweenService:Create(
            MiniShimmerGradient,
            TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            {Offset = Vector2.new(1.45, 0)}
        )
        local t2 = TweenService:Create(
            MiniGlowGradient,
            TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            {Offset = Vector2.new(1.45, 0)}
        )

        t1:Play()
        t2:Play()
        t1.Completed:Wait()

        -- small pause like the reference video
        task.wait(1.1)
    end
end)

local MiniShade = Instance.new("Frame")
MiniShade.Name = "MiniShade"
MiniShade.Size = UDim2.new(1, -4, 1, -4)
MiniShade.Position = UDim2.new(0, 2, 0, 2)
MiniShade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniShade.BackgroundTransparency = 0.12
MiniShade.BorderSizePixel = 0
MiniShade.ZIndex = 20
MiniShade.Parent = MiniFrame
MiniButton.MouseEnter:Connect(function()
TweenService:Create(MiniFrame, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(28, 28, 34)}):Play()
end)
MiniButton.MouseLeave:Connect(function()
TweenService:Create(MiniFrame, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(18, 18, 22)}):Play()
end)
corner(MiniShade, 19)
do
local miniDragging = false
local miniDragStart = nil
local miniStartPos = nil
local miniMoved = false
local miniHeldInput = nil
local DRAG_DEADZONE = 6
MiniButton.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
miniDragging = true
miniMoved = false
miniHeldInput = input
miniDragStart = input.Position
miniStartPos = MiniFrame.Position
end
end)
UserInputService.InputChanged:Connect(function(input)
if not miniDragging then return end
if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
if not miniDragStart or not miniStartPos then return end
local delta = input.Position - miniDragStart
if math.abs(delta.X) > DRAG_DEADZONE or math.abs(delta.Y) > DRAG_DEADZONE then
miniMoved = true
end
MiniFrame.Position = UDim2.new(
miniStartPos.X.Scale,
miniStartPos.X.Offset + delta.X,
miniStartPos.Y.Scale,
miniStartPos.Y.Offset + delta.Y
)
end)
UserInputService.InputEnded:Connect(function(input)
if input ~= miniHeldInput then return end
local wasDrag = miniMoved
miniDragging = false
miniHeldInput = nil
miniDragStart = nil
miniStartPos = nil
if wasDrag then
return
end
Main.Visible = true
MiniFrame.Visible = false
Main.Size = FULL_MAIN_SIZE
savedMainPositionTable = udim2ToTable(Main.Position)
end)
end
local BackgroundIDs = {
"90631990302263",
"109619268613730",
"88369503310562",
"80708025126373",
"102253425322931",
"90453834580322",
"135181794444219",
"129700697019613",
"108697485255882",
"71211662493854",
"118953269416540",
}

_G.Xlu0ThemeColors = _G.Xlu0ThemeColors or {
PURPLE = Color3.fromRGB(207, 159, 255),
BLUE   = Color3.fromRGB(58, 128, 245),
RED    = Color3.fromRGB(232, 52, 68),
PINK   = Color3.fromRGB(255, 105, 180),
YELLOW = Color3.fromRGB(255, 214, 0),
GREY   = Color3.fromRGB(90, 90, 90),
WHITE  = Color3.fromRGB(255, 255, 255),
FOREST = Color3.fromRGB(46, 139, 87),
}

_G.Xlu0ThemeName = tostring(savedConfig.currentThemeName or _G.Xlu0ThemeName or "WHITE")
currentBackground = tonumber(savedConfig.currentBackground) or currentBackground
_G.Xlu0BodyLockEnabled = savedConfig.bodyLockEnabled == true
_G.Xlu0BodyLockRadius = tonumber(savedConfig.bodyLockRadius) or _G.Xlu0BodyLockRadius or 60
if savedConfig.mobileButtonScale ~= nil then _G.Xlu0MobileButtonScale = tonumber(savedConfig.mobileButtonScale) or _G.Xlu0MobileButtonScale or 0.75 end
if savedConfig.guiScaleValue ~= nil then _G.Xlu0GuiScaleValue = tonumber(savedConfig.guiScaleValue) or _G.Xlu0GuiScaleValue end
if savedConfig.stealUiScaleValue ~= nil then _G.Xlu0ProgressBarScaleValue = tonumber(savedConfig.stealUiScaleValue) or _G.Xlu0ProgressBarScaleValue end
_G.Xlu0AutoInstantResetOnDeath = savedConfig.autoInstantResetOnDeath == true
_G.Xlu0HeadlessEnabled = savedConfig.headlessEnabled == true
_G.Xlu0KorbloxEnabled = savedConfig.korbloxEnabled == true
local BgImage = Instance.new("ImageLabel")
BgImage.Name = "CustomBackground"
BgImage.BackgroundTransparency = 1
BgImage.ImageTransparency = 0
BgImage.ScaleType = Enum.ScaleType.Crop
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.Position = UDim2.new(0, 0, 0, 0)
BgImage.Visible = false
BgImage.ZIndex = 1
BgImage.Parent = Main
corner(BgImage, 14)
function applyBackground(index)
currentBackground = index or 0
if currentBackground == 0 then
Main.BackgroundColor3 = COLORS.bg
BgImage.Visible = false
do end
return "None"
end
local id = BackgroundIDs[currentBackground]
if id then
BgImage.Image = "rbxassetid://" .. id
BgImage.ImageColor3 = _G.Xlu0ThemeColors[_G.Xlu0ThemeName] or _G.Xlu0ThemeColors.WHITE
BgImage.Visible = true
do end
return "Image " .. tostring(currentBackground)
end
currentBackground = 0
BgImage.Visible = false
do end
return "None"
end
applyBackground(currentBackground)
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -110, 0, 44)
Title.Position = UDim2.new(0, 55, 0, 24)
Title.Text = "XLU0 DUELS"
Title.TextColor3 = COLORS.white
Title.TextStrokeTransparency = 1
Title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.Arcade
Title.TextSize = 38
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.ZIndex = 6
Title.Parent = Main

-- Siyah gecis yalnizca harflerin icinden gecer
local TitleSweepText = Title:Clone()
TitleSweepText.Name = "TitleSweepText"
TitleSweepText.TextColor3 = Color3.fromRGB(0, 0, 0)
TitleSweepText.TextTransparency = 0
TitleSweepText.TextStrokeTransparency = 1
TitleSweepText.BackgroundTransparency = 1
TitleSweepText.ZIndex = Title.ZIndex + 1
TitleSweepText.Parent = Main

local SweepGradient = Instance.new("UIGradient")
SweepGradient.Rotation = 12
SweepGradient.Offset = Vector2.new(-1.25, 0)
SweepGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0.00, 1),
    NumberSequenceKeypoint.new(0.43, 1),
    NumberSequenceKeypoint.new(0.49, 0.55),
    NumberSequenceKeypoint.new(0.50, 0.00),
    NumberSequenceKeypoint.new(0.51, 0.55),
    NumberSequenceKeypoint.new(0.57, 1),
    NumberSequenceKeypoint.new(1.00, 1)
})
SweepGradient.Parent = TitleSweepText

task.spawn(function()
    while TitleSweepText and TitleSweepText.Parent do
        SweepGradient.Offset = Vector2.new(-1.25, 0)
        local sweepTween = TweenService:Create(
            SweepGradient,
            TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Offset = Vector2.new(1.25, 0)}
        )
        sweepTween:Play()
        sweepTween.Completed:Wait()
        task.wait(1.2)
    end
end)
local HeaderDivider = Instance.new("Frame")
HeaderDivider.Name = "HeaderDivider"
HeaderDivider.BackgroundColor3 = Color3.fromRGB(70, 70, 82)
HeaderDivider.BackgroundTransparency = 0.45
HeaderDivider.BorderSizePixel = 0
HeaderDivider.Size = UDim2.new(1, -34, 0, 1)
HeaderDivider.Position = UDim2.new(0, 17, 0, 96)
HeaderDivider.ZIndex = 6
HeaderDivider.Parent = Main
local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Close.BackgroundTransparency = 0.28
Close.Text = "-"
Close.TextColor3 = COLORS.white
Close.TextSize = 22
Close.Font = Enum.Font.Arcade
Close.Size = UDim2.new(0, 32, 0, 28)
Close.Position = UDim2.new(1, -42, 0, 14)
Close.AutoButtonColor = false
Close.ZIndex = 5
Close.Parent = Main
corner(Close, 8)
stroke(Close, COLORS.stroke, 1, 0.35)
-- Ust LOCK/UNLOCK butonu tamamen kaldirildi
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.BackgroundTransparency = 1
Content.Position = UDim2.new(0, 13, 0, 103)
Content.Size = UDim2.new(1, -26, 1, -153)
Content.ZIndex = 3
Content.Parent = Main
local Tabs = Instance.new("Frame")
Tabs.Name = "Tabs"
Tabs.BackgroundTransparency = 1
Tabs.Position = UDim2.new(0, 12, 1, -42)
Tabs.Size = UDim2.new(1, -24, 0, 34)
Tabs.ZIndex = 3
Tabs.Parent = Main

-- MENU IDLE MODE: Mouse 5 saniye menu disinda kalirsa kontroller yavasca siliklesir.
-- Tamamen kaybolmaz; hafif gorunur kalir. Mouse geri gelince yumusakca eski haline doner.
do
local IDLE_DELAY = 5
local FADE_TIME = 0.65
local idleToken = 0
local idleCollapsed = false
local savedTransparency = setmetatable({}, {__mode = "k"})
local activeTweens = setmetatable({}, {__mode = "k"})

local function rememberObject(obj)
    if savedTransparency[obj] then return end
    local data = {}
    if obj:IsA("GuiObject") then
        data.BackgroundTransparency = obj.BackgroundTransparency
    end
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        data.TextTransparency = obj.TextTransparency
        data.TextStrokeTransparency = obj.TextStrokeTransparency
    end
    if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
        data.ImageTransparency = obj.ImageTransparency
    end
    if obj:IsA("UIStroke") then
        data.Transparency = obj.Transparency
    end
    savedTransparency[obj] = data
end

local function tweenObject(obj, collapsed)
    rememberObject(obj)
    local base = savedTransparency[obj]
    if not base then return end

    if activeTweens[obj] then
        pcall(function() activeTweens[obj]:Cancel() end)
        activeTweens[obj] = nil
    end

    local goal = {}
    if base.BackgroundTransparency ~= nil then
        goal.BackgroundTransparency = collapsed and math.max(base.BackgroundTransparency, 0.78) or base.BackgroundTransparency
    end
    if base.TextTransparency ~= nil then
        goal.TextTransparency = collapsed and math.max(base.TextTransparency, 0.58) or base.TextTransparency
    end
    if base.TextStrokeTransparency ~= nil then
        goal.TextStrokeTransparency = collapsed and math.max(base.TextStrokeTransparency, 0.82) or base.TextStrokeTransparency
    end
    if base.ImageTransparency ~= nil then
        goal.ImageTransparency = collapsed and math.max(base.ImageTransparency, 0.68) or base.ImageTransparency
    end
    if base.Transparency ~= nil then
        goal.Transparency = collapsed and math.max(base.Transparency, 0.72) or base.Transparency
    end

    if next(goal) then
        local tw = TweenService:Create(
            obj,
            TweenInfo.new(FADE_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            goal
        )
        activeTweens[obj] = tw
        tw:Play()
    end
end

local restoreToken = 0

local function forceOriginalTransparency()
    for obj, base in pairs(savedTransparency) do
        if obj and obj.Parent and base then
            if activeTweens[obj] then
                pcall(function() activeTweens[obj]:Cancel() end)
                activeTweens[obj] = nil
            end
            pcall(function()
                if base.BackgroundTransparency ~= nil then obj.BackgroundTransparency = base.BackgroundTransparency end
                if base.TextTransparency ~= nil then obj.TextTransparency = base.TextTransparency end
                if base.TextStrokeTransparency ~= nil then obj.TextStrokeTransparency = base.TextStrokeTransparency end
                if base.ImageTransparency ~= nil then obj.ImageTransparency = base.ImageTransparency end
                if base.Transparency ~= nil then obj.Transparency = base.Transparency end
            end)
        end
    end
end

local function setMenuIdleCollapsed(state)
    local newState = state == true
    restoreToken += 1
    local myRestoreToken = restoreToken

    -- Yalnizca tamamen acik durumdayken normal degerleri kaydet.
    -- Onceki geri-acilma tweeninin ortasindaki yari seffaf degerler asla kaynak alinmaz.
    if newState and not idleCollapsed then
        savedTransparency = setmetatable({}, {__mode = "k"})
        for _, root in ipairs({Content, Tabs, Close, HeaderDivider}) do
            rememberObject(root)
            for _, obj in ipairs(root:GetDescendants()) do
                rememberObject(obj)
            end
        end
    end

    idleCollapsed = newState

    Content.Visible = true
    Tabs.Visible = true
    Close.Visible = true
    HeaderDivider.Visible = true

    for _, root in ipairs({Content, Tabs, Close, HeaderDivider}) do
        tweenObject(root, idleCollapsed)
        for _, obj in ipairs(root:GetDescendants()) do
            tweenObject(obj, idleCollapsed)
        end
    end

    if not newState then
        -- Tween bitince tum degerleri birebir eski haline zorla.
        -- Baska UI guncellemeleri tweeni yarida kesse bile yazi seffaf kalmaz.
        task.delay(FADE_TIME + 0.08, function()
            if myRestoreToken ~= restoreToken or idleCollapsed then return end
            -- Bazi menu guncelleme donguleri tween bittikten sonra yazi saydamligini tekrar degistirebiliyor.
            -- Yaklasik 1.5 saniye boyunca orijinal degerleri yeniden uygula.
            local untilTime = tick() + 1.5
            repeat
                if myRestoreToken ~= restoreToken or idleCollapsed then return end
                forceOriginalTransparency()
                RunService.RenderStepped:Wait()
            until tick() >= untilTime
            forceOriginalTransparency()
            -- Kayitlari burada silme; mouse menudeyken sonradan calisan UI kodlarina karsi kullanmaya devam et.
        end)
    end
end

local function cancelIdleAndRestore()
    idleToken += 1
    if idleCollapsed then
        setMenuIdleCollapsed(false)
    elseif next(savedTransparency) then
        -- Menu acik gorundugu halde bazi yazilar yari saydam kalirsa aninda toparla.
        forceOriginalTransparency()
    end
end

local function scheduleIdleCollapse()
    -- Dokunmatik cihazlarda mouse olmadigi icin otomatik siliklesme uygulanmaz.
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then return end
    idleToken += 1
    local myToken = idleToken
    task.delay(IDLE_DELAY, function()
        if myToken ~= idleToken then return end
        if not Main or not Main.Parent or not Main.Visible then return end
        setMenuIdleCollapsed(true)
    end)
end

Main.MouseEnter:Connect(cancelIdleAndRestore)
Main.MouseLeave:Connect(scheduleIdleCollapse)

-- MouseEnter bazen ust uste binen GUI nesnelerinde kacabiliyor.
-- Mouse koordinatini kontrol ederek menu icindeyse geri acilmayi garanti et.
RunService.RenderStepped:Connect(function()
    if not Main or not Main.Parent or not Main.Visible then return end
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then return end
    local mousePos = UserInputService:GetMouseLocation()
    local pos = Main.AbsolutePosition
    local size = Main.AbsoluteSize
    local inside = mousePos.X >= pos.X and mousePos.X <= pos.X + size.X
        and mousePos.Y >= pos.Y and mousePos.Y <= pos.Y + size.Y
    if inside then
        if idleCollapsed then
            cancelIdleAndRestore()
        else
            -- Eski fade kayitlari yari saydam kalmis olsa bile mouse menu icindeyken
            -- gorunur yazilari kesin olarak tam parlak tut.
            for _, root in ipairs({Content, Tabs, Close, HeaderDivider}) do
                if root:IsA("TextLabel") or root:IsA("TextButton") or root:IsA("TextBox") then
                    root.TextTransparency = 0
                end
                for _, obj in ipairs(root:GetDescendants()) do
                    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                        if obj.Visible then
                            obj.TextTransparency = 0
                        end
                    end
                end
            end
        end
    end
end)

-- Sonradan olusan kontroller de acikken kendi normal saydamliklariyla kaydedilsin.
Main.DescendantAdded:Connect(function(obj)
    -- Normal modda nesneyi erken kaydetme; Roblox ozellikleri daha sonra ayarlaniyor olabilir.
    -- Silik moddayken eklenirse once kurulumunun bitmesini bekleyip mevcut degerini kaydet.
    if idleCollapsed then
        task.defer(function()
            if obj and obj.Parent then
                savedTransparency[obj] = nil
                tweenObject(obj, true)
            end
        end)
    end
end)

-- Script acildiginda mouse menu uzerinde degilse sayac baslasin.
task.defer(scheduleIdleCollapse)
end

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 4)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.Parent = Tabs
local pages = {}
local tabButtons = {}
local tabNames = {"MOVEMENT", "COMBAT", "KEYBINDS", "VISUALS", "MENU", "SETTINGS"}
local activeTab = "MOVEMENT"
function addPage(name)
local page = Instance.new("ScrollingFrame")
page.Name = name
page.BackgroundTransparency = 1
page.BorderSizePixel = 0
page.ScrollBarThickness = 0
page.ScrollBarImageTransparency = 1
page.CanvasSize = UDim2.new(0, 0, 0, 0)
page.AutomaticCanvasSize = Enum.AutomaticSize.Y
page.Size = UDim2.new(1, 0, 1, 0)
page.ZIndex = 3
page.Visible = false
page.Parent = Content
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 7)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = page
pages[name] = page
return page
end
function setTab(name)
activeTab = name
for pageName, page in pairs(pages) do
page.Visible = pageName == name
end
for tabName, btn in pairs(tabButtons) do
local on = tabName == name
btn.TextColor3 = on and COLORS.white or Color3.fromRGB(235, 235, 240)
btn.BackgroundTransparency = on and 0.05 or 0.45
local st = btn:FindFirstChildOfClass("UIStroke")
if st then
st.Transparency = on and 0.0 or 0.2
st.Color = on and Color3.fromRGB(230, 230, 235) or Color3.fromRGB(30, 30, 36)
end
end
end
for _, name in ipairs(tabNames) do
addPage(name)
local btn = Instance.new("TextButton")
btn.Name = name
btn.Size = UDim2.new(0, 55, 0, 34)
btn.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
btn.BackgroundTransparency = 0.45
btn.BorderSizePixel = 0
btn.Text = name
btn.TextColor3 = Color3.fromRGB(235, 235, 240)
btn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
btn.TextStrokeTransparency = 0.65
btn.TextSize = 9
btn.Font = Enum.Font.Arcade
btn.AutoButtonColor = false
btn.ZIndex = 4
btn.Parent = Tabs
corner(btn, 11)
stroke(btn, Color3.fromRGB(30, 30, 36), 1.2, 0.2)
tabButtons[name] = btn
btn.MouseButton1Click:Connect(function()
setTab(name)
end)
end
function section(parent, text, order)
local label = Instance.new("TextLabel")
label.Name = text
label.BackgroundTransparency = 1
label.Text = text
label.TextColor3 = Color3.fromRGB(245, 245, 255)
label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
label.TextStrokeTransparency = 1
label.TextSize = 11
label.Font = Enum.Font.Arcade
label.TextXAlignment = Enum.TextXAlignment.Left
label.Size = UDim2.new(1, -6, 0, 15)
label.LayoutOrder = order
label.ZIndex = 8
label.Parent = parent
return label
end
function baseRow(parent, labelText, order)
local row = Instance.new("Frame")
row.Name = labelText
row.BackgroundColor3 = COLORS.row
row.BackgroundTransparency = 0.3
row.Size = UDim2.new(1, -4, 0, 34)
row.BorderSizePixel = 0
row.LayoutOrder = order
row.ZIndex = 4
row.Parent = parent
corner(row, 9)
stroke(row, COLORS.strokeSoft, 1.15, 0.38)
local label = Instance.new("TextLabel")
label.Name = "Label"
label.BackgroundTransparency = 1
label.Text = labelText
label.TextColor3 = Color3.fromRGB(245, 245, 255)
label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
label.TextStrokeTransparency = 1
label.TextSize = 12
label.Font = Enum.Font.Arcade
label.TextXAlignment = Enum.TextXAlignment.Left
label.Position = UDim2.new(0, 12, 0, 0)
label.Size = UDim2.new(1, -132, 1, 0)
label.ZIndex = 5
label.Parent = row
row.MouseEnter:Connect(function()
tween(row, {BackgroundTransparency = 0.22})
end)
row.MouseLeave:Connect(function()
tween(row, {BackgroundTransparency = 0.3})
end)
return row
end
function textboxRow(parent, labelText, value, order)
local row = baseRow(parent, labelText, order)
local box = Instance.new("TextBox")
box.Name = "ValueBox"
box.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
box.BackgroundTransparency = 0.18
box.Text = tostring(value or "")
box.TextColor3 = COLORS.white
box.TextSize = 12
box.Font = Enum.Font.Arcade
box.ClearTextOnFocus = false
box.Size = UDim2.new(0, 58, 0, 24)
box.Position = UDim2.new(1, -68, 0.5, -12)
box.BorderSizePixel = 0
box.ZIndex = 6
box.Parent = row
corner(box, 7)
stroke(box, COLORS.strokeSoft, 1, 0.45)
return row, box
end
function toggleRow(parent, labelText, default, order)
local row = baseRow(parent, labelText, order)
local button = Instance.new("TextButton")
button.Name = "ToggleButton"
button.BackgroundTransparency = 1
button.Text = ""
button.Size = UDim2.new(1, 0, 1, 0)
button.Position = UDim2.new(0, 0, 0, 0)
button.AutoButtonColor = false
button.ZIndex = 7
button.Parent = row
local track = Instance.new("Frame")
track.Name = "Track"
track.BackgroundColor3 = COLORS.toggleBg
track.BackgroundTransparency = 0.2
track.Size = UDim2.new(0, 34, 0, 18)
track.Position = UDim2.new(1, -44, 0.5, -9)
track.BorderSizePixel = 0
track.ZIndex = 5
track.Parent = button
corner(track, 9)
stroke(track, COLORS.strokeSoft, 1, 0.45)
local knob = Instance.new("Frame")
knob.Name = "Knob"
knob.BackgroundColor3 = COLORS.knob
knob.Size = UDim2.new(0, 13, 0, 13)
knob.Position = default and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
knob.BorderSizePixel = 0
knob.ZIndex = 6
knob.Parent = track
corner(knob, 999)
local shine = Instance.new("Frame")
shine.Name = "Shine"
shine.BackgroundColor3 = COLORS.white
shine.BackgroundTransparency = 0.72
shine.Size = UDim2.new(1, -4, 0, 4)
shine.Position = UDim2.new(0, 2, 0, 2)
shine.BorderSizePixel = 0
shine.ZIndex = 7
shine.Parent = knob
corner(shine, 4)
local state = default and true or false
local trackStroke = track:FindFirstChildOfClass("UIStroke")
local rowStroke = row:FindFirstChildOfClass("UIStroke")
local function setVisual(on)
state = on and true or false
tween(knob, {Position = state and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)})
tween(track, {
BackgroundTransparency = state and 0.03 or 0.2,
BackgroundColor3 = state and Color3.fromRGB(36, 36, 46) or COLORS.toggleBg
})
if trackStroke then
tween(trackStroke, {
Color = state and Color3.fromRGB(255, 255, 255) or COLORS.strokeSoft,
Transparency = state and 0.05 or 0.45,
Thickness = state and 1.25 or 1
})
end
if rowStroke then
tween(rowStroke, {
Color = state and Color3.fromRGB(245, 245, 255) or COLORS.strokeSoft,
Transparency = state and 0.12 or 0.38,
Thickness = state and 1.25 or 1.15
})
end
tween(row, {BackgroundTransparency = state and 0.16 or 0.3})
end
setVisual(state)
button.Activated:Connect(function()
end)
return row, setVisual
end
_G.Xlu0SyncToggleVisuals = function()
pcall(function() if setAutoStealVisual then setAutoStealVisual(autoStealEnabled == true) end end)
pcall(function() if setInfJumpVisual then setInfJumpVisual(infJumpEnabled == true) end end)
pcall(function() if setAntiRagdollVisual then setAntiRagdollVisual(antiRagdollEnabled == true) end end)
pcall(function() if setAutoCarrySpeedVisual then setAutoCarrySpeedVisual(autoCarrySpeedEnabled == true) end end)
pcall(function() if setAutoTPVisual then setAutoTPVisual(autoTPEnabled == true) end end)
pcall(function() if setAutoResetOnMedVisual then setAutoResetOnMedVisual(autoResetOnMedEnabled == true) end end)
end
_G.Xlu0ActionToggleRow = function(parent, labelText, default, order)
local row = baseRow(parent, labelText, order)
local button = Instance.new("TextButton")
button.Name = "ToggleButton"
button.BackgroundTransparency = 1
button.Text = ""
button.Size = UDim2.new(1, 0, 1, 0)
button.Position = UDim2.new(0, 0, 0, 0)
button.AutoButtonColor = false
button.ZIndex = 7
button.Parent = row
local track = Instance.new("Frame")
track.Name = "Track"
track.BackgroundColor3 = COLORS.toggleBg
track.BackgroundTransparency = 0.2
track.Size = UDim2.new(0, 34, 0, 18)
track.Position = UDim2.new(1, -44, 0.5, -9)
track.BorderSizePixel = 0
track.ZIndex = 5
track.Parent = button
corner(track, 9)
stroke(track, COLORS.strokeSoft, 1, 0.45)
local knob = Instance.new("Frame")
knob.Name = "Knob"
knob.BackgroundColor3 = COLORS.knob
knob.Size = UDim2.new(0, 13, 0, 13)
knob.Position = default and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
knob.BorderSizePixel = 0
knob.ZIndex = 6
knob.Parent = track
corner(knob, 999)
local shine = Instance.new("Frame")
shine.Name = "Shine"
shine.BackgroundColor3 = COLORS.white
shine.BackgroundTransparency = 0.72
shine.Size = UDim2.new(1, -4, 0, 4)
shine.Position = UDim2.new(0, 2, 0, 2)
shine.BorderSizePixel = 0
shine.ZIndex = 7
shine.Parent = knob
corner(shine, 4)
local trackStroke = track:FindFirstChildOfClass("UIStroke")
local rowStroke = row:FindFirstChildOfClass("UIStroke")
local function setVisual(on)
local state = on and true or false
tween(knob, {Position = state and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)})
tween(track, {
BackgroundTransparency = state and 0.03 or 0.2,
BackgroundColor3 = state and Color3.fromRGB(36, 36, 46) or COLORS.toggleBg
})
if trackStroke then
tween(trackStroke, {
Color = state and Color3.fromRGB(255, 255, 255) or COLORS.strokeSoft,
Transparency = state and 0.05 or 0.45,
Thickness = state and 1.25 or 1
})
end
if rowStroke then
tween(rowStroke, {
Color = state and Color3.fromRGB(245, 245, 255) or COLORS.strokeSoft,
Transparency = state and 0.12 or 0.38,
Thickness = state and 1.25 or 1.15
})
end
tween(row, {BackgroundTransparency = state and 0.16 or 0.3})
end
setVisual(default)
return row, setVisual, button
end
function dropdownRow(parent, labelText, value, order)
local row = baseRow(parent, labelText, order)
local select = Instance.new("TextButton")
select.Name = "Dropdown"
select.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
select.BackgroundTransparency = 0.18
select.Text = tostring(value or "None") .. "  ▼"
select.TextColor3 = COLORS.white
select.TextSize = 11
select.Font = Enum.Font.Arcade
select.Size = UDim2.new(0, 70, 0, 24)
select.Position = UDim2.new(1, -80, 0.5, -12)
select.BorderSizePixel = 0
select.ZIndex = 6
select.Parent = row
corner(select, 7)
stroke(select, COLORS.strokeSoft, 1, 0.45)
return row, select
end
local animationPackValueLabel = nil
function refreshAnimationPackRow()
if animationPackValueLabel then
animationPackValueLabel.Text = selectedAnimationPack
end
end
function animationPackRow(parent, order)
local row = baseRow(parent, "Animation Pack", order)
row.Size = UDim2.new(1, -4, 0, 42)
local label = row:FindFirstChild("Label")
if label then
label.Text = "Animation Pack"
label.Size = UDim2.new(0, 112, 1, 0)
label.TextSize = 11
end
local left = Instance.new("TextButton")
left.Name = "LeftArrow"
left.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
left.BackgroundTransparency = 0.18
left.Text = "<"
left.TextColor3 = COLORS.white
left.TextSize = 12
left.Font = Enum.Font.Arcade
left.Size = UDim2.new(0, 42, 0, 28)
left.Position = UDim2.new(1, -156, 0.5, -14)
left.BorderSizePixel = 0
left.ZIndex = 6
left.Parent = row
corner(left, 8)
stroke(left, COLORS.strokeSoft, 1, 0.45)
animationPackValueLabel = Instance.new("TextLabel")
animationPackValueLabel.Name = "AnimationPackValue"
animationPackValueLabel.BackgroundTransparency = 1
animationPackValueLabel.Text = selectedAnimationPack
animationPackValueLabel.TextColor3 = COLORS.white
animationPackValueLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
animationPackValueLabel.TextStrokeTransparency = 1
animationPackValueLabel.TextSize = 11
animationPackValueLabel.Font = Enum.Font.Arcade
animationPackValueLabel.TextXAlignment = Enum.TextXAlignment.Center
animationPackValueLabel.Size = UDim2.new(0, 62, 1, 0)
animationPackValueLabel.Position = UDim2.new(1, -112, 0, 0)
animationPackValueLabel.ZIndex = 6
animationPackValueLabel.Parent = row

local more = Instance.new("TextButton")
more.Name = "MoreAnimations"
more.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
more.BackgroundTransparency = 0.18
more.Text = "MORE"
more.TextColor3 = COLORS.white
more.TextSize = 9
more.Font = Enum.Font.Arcade
more.Size = UDim2.new(0, 52, 0, 28)
more.Position = UDim2.new(0, 116, 0.5, -14)
more.BorderSizePixel = 0
more.ZIndex = 6
more.Parent = row
corner(more, 8)
stroke(more, COLORS.strokeSoft, 1, 0.45)

local function getPackThumb(packName)
    if packName == "OFF" then
        local ok, img = pcall(function()
            return Players:GetUserThumbnailAsync(
                LP.UserId,
                Enum.ThumbnailType.AvatarBust,
                Enum.ThumbnailSize.Size150x150
            )
        end)
        if ok then return img end
        return ""
    end
    if packName == "Unwalk" then
        return "rbxassetid://71408678974152"
    end
    local pack = AnimationPacks[packName]
    local idle = pack and pack.idle and pack.idle[1] and pack.idle[1][1]
    local id = idle and tostring(idle):match("(%d+)")
    if id then
        return "rbxthumb://type=Asset&id=" .. id .. "&w=150&h=150"
    end
    return ""
end



local function resolveBundleMappings(bundledItems)
    local mappings = {}
    if type(bundledItems) ~= "table" then return mappings end

    for _, assetIds in pairs(bundledItems) do
        if type(assetIds) == "table" then
            for _, assetId in pairs(assetIds) do
                local success, objects = pcall(function()
                    return game:GetObjects("rbxassetid://" .. tostring(assetId))
                end)
                if success and objects then
                    local function searchTree(parent, parentPath)
                        for _, child in pairs(parent:GetChildren()) do
                            if child:IsA("Animation") then
                                local animationPath = parentPath .. "." .. child.Name
                                local pathParts = animationPath:split(".")
                                table.insert(mappings, {
                                    category = pathParts[#pathParts - 1],
                                    name = pathParts[#pathParts],
                                    animationId = child.AnimationId
                                })
                            elseif #child:GetChildren() > 0 then
                                searchTree(child, parentPath .. "." .. child.Name)
                            end
                        end
                    end

                    for _, obj in pairs(objects) do
                        searchTree(obj, obj.Name)
                        pcall(function() obj:Destroy() end)
                    end
                end
            end
        end
    end
    return mappings
end

applyFullAnimationBundle = function(animationData)
    local char = LP.Character
    local animate = char and char:FindFirstChild("Animate")
    if not char or not animate then return end

    backupAnimations(char)
    if unwalkEnabled then
        disableUnwalk()
        animate = char:FindFirstChild("Animate") or char:WaitForChild("Animate", 2)
        if not animate then return end
    end

    local mappings = resolveBundleMappings(animationData.bundledItems)
    if #mappings == 0 then
        if showActionNotification then
            pcall(function() showActionNotification("ANIMATION DATA NOT FOUND") end)
        end
        return
    end

    stopCurrentAnimations(char)

    for _, m in ipairs(mappings) do
        local cat = tostring(m.category or ""):lower()
        local name = tostring(m.name or "")
        local folder = animate:FindFirstChild(cat)
        if folder then
            local target = folder:FindFirstChild(name)
            if not target then
                if cat == "walk" then target = folder:FindFirstChild("WalkAnim")
                elseif cat == "run" then target = folder:FindFirstChild("RunAnim")
                elseif cat == "jump" then target = folder:FindFirstChild("JumpAnim")
                elseif cat == "fall" then target = folder:FindFirstChild("FallAnim")
                elseif cat == "climb" then target = folder:FindFirstChild("ClimbAnim")
                elseif cat == "swim" then target = folder:FindFirstChild("Swim")
                elseif cat == "swimidle" then target = folder:FindFirstChild("SwimIdle")
                elseif cat == "idle" then
                    target = folder:FindFirstChild(name) or folder:FindFirstChild("Animation1")
                end
            end
            setAnimId(target, m.animationId)
        end
    end

    reloadAnimate(animate)

    _G.Xlu0SelectedMoreAnimationBundle = {
        id = animationData.id,
        name = animationData.name,
        bundledItems = animationData.bundledItems
    }

    selectedAnimationPack = "OFF"
    syncAnimationPackIndex()
    if refreshAnimationPackRow then refreshAnimationPackRow() end
    if saveXlu0Config then do end end

    if showActionNotification then
        pcall(function() showActionNotification("ANIMATION - " .. tostring(animationData.name or animationData.id)) end)
    end
end

local function openAnimationGallery()
    local existing = PlayerGui:FindFirstChild("Xlu0AnimationGallery")
    if existing then existing:Destroy() end

    local sg = Instance.new("ScreenGui")
    sg.Name = "Xlu0AnimationGallery"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 99999
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.Parent = PlayerGui

    local shade = Instance.new("TextButton")
    shade.Text = ""
    shade.AutoButtonColor = false
    shade.BackgroundColor3 = Color3.fromRGB(0,0,0)
    shade.BackgroundTransparency = 0.25
    shade.Size = UDim2.fromScale(1,1)
    shade.ZIndex = 1
    shade.Parent = sg

    local panel = Instance.new("Frame")
    panel.AnchorPoint = Vector2.new(0.5,0.5)
    panel.Position = UDim2.fromScale(0.5,0.5)
    panel.Size = UDim2.new(0, 540, 0, 480)
    panel.BackgroundColor3 = Color3.fromRGB(10,10,15)
    panel.BackgroundTransparency = 0.04
    panel.BorderSizePixel = 0
    panel.ZIndex = 2
    panel.Parent = sg
    corner(panel,16)
    stroke(panel,COLORS.strokeSoft,1.2,0.15)

    -- EXACT Xlu0 background sync: use the same rbxasset and tint as the main menu.
    pcall(function()
        local selectedColor = (_G.Xlu0ThemeColors and _G.Xlu0ThemeColors[_G.Xlu0ThemeName])
            or Color3.fromRGB(255,255,255)

        panel.BackgroundColor3 = selectedColor:Lerp(Color3.fromRGB(8,8,12), 0.78)

        local exactImage = nil
        local exactColor = selectedColor
        local exactTransparency = 0

        -- Main menu's real background object.
        if BgImage and BgImage.Parent and BgImage.Visible and BgImage.Image and BgImage.Image ~= "" then
            exactImage = BgImage.Image
            exactColor = BgImage.ImageColor3
            exactTransparency = BgImage.ImageTransparency
        elseif currentBackground and tonumber(currentBackground) and tonumber(currentBackground) > 0
            and BackgroundIDs and BackgroundIDs[tonumber(currentBackground)] then
            exactImage = "rbxassetid://" .. tostring(BackgroundIDs[tonumber(currentBackground)])
        end

        if exactImage and exactImage ~= "" then
            local image = Instance.new("ImageLabel")
            image.Name = "ThemeBackground"
            image.BackgroundTransparency = 1
            image.Size = UDim2.fromScale(1,1)
            image.Position = UDim2.fromScale(0,0)
            image.Image = exactImage
            image.ImageColor3 = exactColor
            image.ImageTransparency = exactTransparency
            image.ScaleType = Enum.ScaleType.Crop
            image.ZIndex = 2
            image.Parent = panel
            corner(image,16)

            local wash = Instance.new("Frame")
            wash.Name = "BackgroundWash"
            wash.BackgroundColor3 = Color3.fromRGB(0,0,0)
            wash.BackgroundTransparency = 0.52
            wash.BorderSizePixel = 0
            wash.Size = UDim2.fromScale(1,1)
            wash.ZIndex = 2
            wash.Parent = panel
            corner(wash,16)
        end
    end)

    if UserInputService.TouchEnabled then
        panel.Size = UDim2.new(0.95,0,0.80,0)
    end

    -- Draggable animation gallery
    do
        local dragging = false
        local dragStart = nil
        local startPos = nil

        local function updateDrag(input)
            if not dragging or not dragStart or not startPos then return end
            local delta = input.Position - dragStart
            panel.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end

        panel.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = panel.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then
                updateDrag(input)
            end
        end)
    end

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Text = "ALL ANIMATION BUNDLES"
    title.TextColor3 = COLORS.white
    title.Font = Enum.Font.Arcade
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Position = UDim2.new(0,16,0,10)
    title.Size = UDim2.new(1,-60,0,28)
    title.ZIndex = 3
    title.Parent = panel

    local sub = Instance.new("TextLabel")
    sub.BackgroundTransparency = 1
    sub.Text = "Online + Offsale animation bundles"
    sub.TextColor3 = Color3.fromRGB(175,175,185)
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 11
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Position = UDim2.new(0,16,0,34)
    sub.Size = UDim2.new(1,-60,0,20)
    sub.ZIndex = 3
    sub.Parent = panel

    local close = Instance.new("TextButton")
    close.Text = "X"
    close.Font = Enum.Font.Arcade
    close.TextSize = 12
    close.TextColor3 = COLORS.white
    close.BackgroundColor3 = Color3.fromRGB(18,18,24)
    close.BackgroundTransparency = 0.08
    close.Size = UDim2.fromOffset(32,32)
    close.Position = UDim2.new(1,-42,0,8)
    close.BorderSizePixel = 0
    close.ZIndex = 4
    close.Parent = panel
    corner(close,9)

    local searchBox = Instance.new("TextBox")
    searchBox.PlaceholderText = "Search bundle / ID..."
    searchBox.Text = ""
    searchBox.ClearTextOnFocus = false
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 12
    searchBox.TextColor3 = COLORS.white
    searchBox.PlaceholderColor3 = Color3.fromRGB(135,135,145)
    searchBox.BackgroundColor3 = Color3.fromRGB(16,16,22)
    searchBox.BackgroundTransparency = 0.06
    searchBox.BorderSizePixel = 0
    searchBox.Position = UDim2.new(0,14,0,60)
    searchBox.Size = UDim2.new(1,-28,0,32)
    searchBox.ZIndex = 3
    searchBox.Parent = panel
    corner(searchBox,9)
    stroke(searchBox,COLORS.strokeSoft,1,0.5)

    local scroll = Instance.new("ScrollingFrame")
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.Position = UDim2.new(0,10,0,102)
    scroll.Size = UDim2.new(1,-20,1,-116)
    scroll.ScrollBarThickness = 4
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.CanvasSize = UDim2.new(0,0,0,0)
    scroll.ZIndex = 3
    scroll.Parent = panel

    local grid = Instance.new("UIGridLayout")
    grid.CellSize = UDim2.fromOffset(122,145)
    grid.CellPadding = UDim2.fromOffset(8,8)
    grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
    grid.SortOrder = Enum.SortOrder.LayoutOrder
    grid.Parent = scroll

    local status = Instance.new("TextLabel")
    status.BackgroundTransparency = 1
    status.Text = "Loading..."
    status.TextColor3 = Color3.fromRGB(160,160,170)
    status.Font = Enum.Font.Gotham
    status.TextSize = 10
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Position = UDim2.new(0,16,1,-27)
    status.Size = UDim2.new(1,-32,0,20)
    status.ZIndex = 4
    status.Parent = panel

    local allAnimations = {}

    local function clearCards()
        for _, child in ipairs(scroll:GetChildren()) do
            if child:IsA("GuiButton") then child:Destroy() end
        end
    end

    local function addCard(item, order)
        local card = Instance.new("TextButton")
        card.Text = ""
        card.AutoButtonColor = false
        card.BackgroundColor3 = Color3.fromRGB(16,16,22)
        card.BackgroundTransparency = 0.07
        card.BorderSizePixel = 0
        card.LayoutOrder = order
        card.ZIndex = 4
        card.Parent = scroll
        corner(card,11)
        stroke(card,COLORS.strokeSoft,1,0.55)

        local img = Instance.new("ImageLabel")
        img.BackgroundColor3 = Color3.fromRGB(7,7,11)
        img.BackgroundTransparency = 0.12
        img.BorderSizePixel = 0
        img.Image = "rbxthumb://type=BundleThumbnail&id=" .. tostring(item.id) .. "&w=150&h=150"
        img.ScaleType = Enum.ScaleType.Fit
        img.Position = UDim2.new(0,7,0,7)
        img.Size = UDim2.new(1,-14,0,92)
        img.ZIndex = 5
        img.Parent = card
        corner(img,8)

        local name = Instance.new("TextLabel")
        name.BackgroundTransparency = 1
        name.Text = tostring(item.name or ("Animation " .. tostring(item.id)))
        name.TextColor3 = COLORS.white
        name.Font = Enum.Font.GothamBold
        name.TextSize = 10
        name.TextWrapped = true
        name.TextYAlignment = Enum.TextYAlignment.Top
        name.Position = UDim2.new(0,6,0,104)
        name.Size = UDim2.new(1,-12,0,32)
        name.ZIndex = 5
        name.Parent = card

        card.MouseButton1Click:Connect(function()
            applyFullAnimationBundle(item)
            if sg and sg.Parent then
                sg:Destroy()
            end
        end)
    end

    local function render()
        clearCards()
        local q = (searchBox.Text or ""):lower()
        local count = 0
        for _, item in ipairs(allAnimations) do
            local match = q == "" or tostring(item.id) == q or tostring(item.name or ""):lower():find(q,1,true)
            if match then
                count += 1
                addCard(item,count)
            end
        end
        status.Text = tostring(count) .. " animation bundles"
    end

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        task.defer(render)
    end)

    close.MouseButton1Click:Connect(function() sg:Destroy() end)
    -- Background click no longer closes the gallery.

    task.spawn(function()
        local seen = {}
        local urls = {
            "https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/AnimationSniper.json",
            "https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/AnimationSniperoffsale.json"
        }

        for _, url in ipairs(urls) do
            local ok, body = pcall(function() return game:HttpGet(url) end)
            if ok and body and body ~= "" then
                local ok2, data = pcall(function() return HttpService:JSONDecode(body) end)
                if ok2 and data then
                    for _, item in pairs(data.data or {}) do
                        local id = tonumber(item.id)
                        if id and id > 0 and not seen[id] and item.bundledItems then
                            seen[id] = true
                            table.insert(allAnimations, {
                                id = id,
                                name = item.name or ("Animation_" .. tostring(id)),
                                bundledItems = item.bundledItems
                            })
                        end
                    end
                end
            end
        end

        table.sort(allAnimations,function(a,b)
            return tostring(a.name or ""):lower() < tostring(b.name or ""):lower()
        end)
        render()
    end)
end

more.MouseButton1Click:Connect(openAnimationGallery)

local right = Instance.new("TextButton")
right.Name = "RightArrow"
right.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
right.BackgroundTransparency = 0.18
right.Text = ">"
right.TextColor3 = COLORS.white
right.TextSize = 12
right.Font = Enum.Font.Arcade
right.Size = UDim2.new(0, 42, 0, 28)
right.Position = UDim2.new(1, -48, 0.5, -14)
right.BorderSizePixel = 0
right.ZIndex = 6
right.Parent = row
corner(right, 8)
stroke(right, COLORS.strokeSoft, 1, 0.45)
local function setPackIndex(nextIndex)
if nextIndex < 1 then nextIndex = #AnimationPackList end
if nextIndex > #AnimationPackList then nextIndex = 1 end
AnimationPackIndex = nextIndex
selectedAnimationPack = AnimationPackList[AnimationPackIndex]
_G.Xlu0SelectedMoreAnimationBundle = nil
refreshAnimationPackRow()
applyAnimationPack(selectedAnimationPack)
if saveXlu0Config then do end end
end
left.MouseButton1Click:Connect(function()
setPackIndex(AnimationPackIndex - 1)
end)
right.MouseButton1Click:Connect(function()
setPackIndex(AnimationPackIndex + 1)
end)
return row
end
function keyName(key)
if not key then return "None" end
local name = tostring(key):gsub("Enum.KeyCode.", "")
name = name:gsub("Button", "BTN ")
name = name:gsub("DPad", "DPad ")
return name
end
function refreshSpeedKeybindButton(keyId)
local btn = speedKeybindButtons[keyId]
if btn then
if listeningForSpeedKey == keyId then
btn.Text = "Press..."
else
btn.Text = keyName(speedKeybinds[keyId])
end
end
end
function refreshAllSpeedKeybinds()
for keyId in pairs(speedKeybindButtons) do
refreshSpeedKeybindButton(keyId)
end
end
function refreshTPDownKeybind()
if tpDownKeybindButton then
tpDownKeybindButton.Text = listeningForTPDownKey and "Press..." or keyName(tpDownKeybind)
end
end
function tpDownKeybindRow(parent, order)
local row = baseRow(parent, "TP Down", order)
local btn = Instance.new("TextButton")
btn.Name = "TPDownKeybindButton"
btn.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
btn.BackgroundTransparency = 0.18
btn.Text = keyName(tpDownKeybind)
btn.TextColor3 = COLORS.white
btn.TextSize = 11
btn.Font = Enum.Font.Arcade
btn.Size = UDim2.new(0, 56, 0, 24)
btn.Position = UDim2.new(1, -64, 0.5, -12)
btn.BorderSizePixel = 0
btn.ZIndex = 6
btn.AutoButtonColor = false
btn.Parent = row
corner(btn, 14)
stroke(btn, COLORS.strokeSoft, 1, 0.45)
local clearBtn = Instance.new("TextButton")
clearBtn.Name = "ClearKeybindButton"
clearBtn.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
clearBtn.BackgroundTransparency = 0.18
clearBtn.Text = "×"
clearBtn.TextColor3 = COLORS.white
clearBtn.TextSize = 14
clearBtn.Font = Enum.Font.Arcade
clearBtn.Size = UDim2.new(0, 22, 0, 24)
clearBtn.Position = UDim2.new(1, -90, 0.5, -12)
clearBtn.BorderSizePixel = 0
clearBtn.ZIndex = 6
clearBtn.AutoButtonColor = false
clearBtn.Parent = row
corner(clearBtn, 7)
stroke(clearBtn, COLORS.strokeSoft, 1, 0.45)
tpDownKeybindButton = btn
btn.Activated:Connect(function()
listeningForSpeedKey = nil
listeningForTPDownKey = true
keybindListenStartedAt = tick()
refreshAllSpeedKeybinds()
refreshTPDownKeybind()
end)
clearBtn.Activated:Connect(function()
listeningForSpeedKey = nil
listeningForTPDownKey = false
tpDownKeybind = nil
if tpDownKeybindButton then tpDownKeybindButton.Text = "None" end
refreshAllSpeedKeybinds()
refreshTPDownKeybind()
do end
end)
return row, btn
end
function speedKeybindRow(parent, labelText, keyId, order)
local row = baseRow(parent, labelText, order)
local btn = Instance.new("TextButton")
btn.Name = "KeybindButton"
btn.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
btn.BackgroundTransparency = 0.18
btn.Text = keyName(speedKeybinds[keyId])
btn.TextColor3 = COLORS.white
btn.TextSize = 11
btn.Font = Enum.Font.Arcade
btn.Size = UDim2.new(0, 56, 0, 24)
btn.Position = UDim2.new(1, -64, 0.5, -12)
btn.BorderSizePixel = 0
btn.ZIndex = 6
btn.AutoButtonColor = false
btn.Parent = row
corner(btn, 14)
stroke(btn, COLORS.strokeSoft, 1, 0.45)
local clearBtn = Instance.new("TextButton")
clearBtn.Name = "ClearKeybindButton"
clearBtn.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
clearBtn.BackgroundTransparency = 0.18
clearBtn.Text = "×"
clearBtn.TextColor3 = COLORS.white
clearBtn.TextSize = 14
clearBtn.Font = Enum.Font.Arcade
clearBtn.Size = UDim2.new(0, 22, 0, 24)
clearBtn.Position = UDim2.new(1, -90, 0.5, -12)
clearBtn.BorderSizePixel = 0
clearBtn.ZIndex = 6
clearBtn.AutoButtonColor = false
clearBtn.Parent = row
corner(clearBtn, 7)
stroke(clearBtn, COLORS.strokeSoft, 1, 0.45)
speedKeybindButtons[keyId] = btn
btn.Activated:Connect(function()
listeningForSpeedKey = keyId
listeningForTPDownKey = false
keybindListenStartedAt = tick()
refreshAllSpeedKeybinds()
refreshTPDownKeybind()
end)
clearBtn.Activated:Connect(function()
listeningForSpeedKey = nil
listeningForTPDownKey = false
speedKeybinds[keyId] = nil
if speedKeybindButtons[keyId] then speedKeybindButtons[keyId].Text = "None" end
refreshAllSpeedKeybinds()
refreshTPDownKeybind()
do end
end)
return row, btn
end
local normalModeValueLabel = nil
local laggerModeValueLabel = nil
local aimbotButtonLabel = nil
local aimbotSpeedLabel = nil
local laggerAimbotSpeedLabel = nil
local combatAimbotKeybindLabel = nil
function getAimbotModeDisplay()
if selectedAimbotMode == "Anti Bypass" or selectedAimbotMode == "Bypass" then
return "Anti Bypass"
end
return "Normal"
end
function refreshAimbotButtonLabel()
if aimbotButtonLabel then
aimbotButtonLabel.Text = getAimbotModeDisplay() .. " Aimbot"
end
end
function refreshAimbotModeLabels()
local modeName = getAimbotModeDisplay()
if aimbotSpeedLabel then
aimbotSpeedLabel.Text = modeName .. " Aimbot Speed"
end
if laggerAimbotSpeedLabel then
laggerAimbotSpeedLabel.Text = modeName .. " Lagger Aimbot Speed"
end
if combatAimbotKeybindLabel then
combatAimbotKeybindLabel.Text = modeName .. " Aimbot"
end
refreshAimbotButtonLabel()
end
refreshSpeedModeRows = function()
if normalModeValueLabel then
normalModeValueLabel.Text = (currentSpeedMode == "Carry") and "Carry" or "Normal"
end
if laggerModeValueLabel then
laggerModeValueLabel.Text = (currentSpeedMode == "Lagger Carry") and "Lagger Carry" or "Lagger"
end
end
function modeDisplayRow(parent, order, side)
local row = baseRow(parent, "Mode", order)
row.Size = UDim2.new(1, -4, 0, 42)
row.BackgroundTransparency = 0.42
local label = row:FindFirstChild("Label")
if label then
label.Text = "Mode"
label.TextSize = 11
label.Size = UDim2.new(0, 110, 1, 0)
label.Position = UDim2.new(0, 12, 0, 0)
label.TextColor3 = Color3.fromRGB(245, 245, 255)
end
local value = Instance.new("TextLabel")
value.Name = "ModeValue"
value.BackgroundTransparency = 1
value.Text = side == "Normal" and "Normal" or "Lagger"
value.TextColor3 = Color3.fromRGB(255, 255, 255)
value.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
value.TextStrokeTransparency = 1
value.TextSize = 12
value.Font = Enum.Font.Arcade
value.TextXAlignment = Enum.TextXAlignment.Right
value.Position = UDim2.new(1, -132, 0, 0)
value.Size = UDim2.new(0, 120, 1, 0)
value.ZIndex = 6
value.Parent = row
local click = Instance.new("TextButton")
click.Name = "ModeClick"
click.BackgroundTransparency = 1
click.Text = ""
click.Size = UDim2.new(1, 0, 1, 0)
click.Position = UDim2.new(0, 0, 0, 0)
click.AutoButtonColor = false
click.ZIndex = 8
click.Parent = row
if side == "Normal" then
normalModeValueLabel = value
click.MouseButton1Click:Connect(function()
setSpeedMode(currentSpeedMode == "Normal" and "Carry" or "Normal")
end)
else
laggerModeValueLabel = value
click.MouseButton1Click:Connect(function()
setSpeedMode(currentSpeedMode == "Lagger" and "Lagger Carry" or "Lagger")
end)
end
refreshSpeedModeRows()
return row, value
end
function aimbotModeButtonRow(parent, order)
local row, setVisual = toggleRow(parent, tostring(selectedAimbotMode) .. " Aimbot", false, order)
aimbotButtonLabel = row and row:FindFirstChild("Label")
_G.Xlu0AimbotSetVisual = setVisual
refreshAimbotButtonLabel()
if _G.Xlu0RefreshAimbotVisual then _G.Xlu0RefreshAimbotVisual() end

local toggleBtn = row and row:FindFirstChild("ToggleButton")
if toggleBtn then
toggleBtn.Size = UDim2.new(0, 54, 1, 0)
toggleBtn.Position = UDim2.new(1, -54, 0, 0)
toggleBtn.Activated:Connect(function()
if _G.Xlu0ToggleSelectedAimbot then
_G.Xlu0ToggleSelectedAimbot()
end
end)
end

local arrow = Instance.new("TextButton")
arrow.Name = "ArrowButton"
arrow.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
arrow.BackgroundTransparency = 0.18
arrow.BorderSizePixel = 0
arrow.Text = "▼"
arrow.TextColor3 = COLORS.white
arrow.TextSize = 18
arrow.Font = Enum.Font.GothamBlack
arrow.AutoButtonColor = false
arrow.Size = UDim2.new(0, 38, 0, 26)
arrow.Position = UDim2.new(1, -100, 0.5, -13)
arrow.ZIndex = 20
arrow.Parent = row
corner(arrow, 7)
stroke(arrow, COLORS.strokeSoft, 1.2, 0.25)

return row, setVisual, arrow
end
_G.Xlu0AimbotSelectorRow = function(parent, order)
local holder = Instance.new("Frame")
holder.Name = "Aimbot Mode"
holder.BackgroundColor3 = COLORS.row
holder.BackgroundTransparency = 0.28
holder.Size = UDim2.new(1, -4, 0, 42)
holder.BorderSizePixel = 0
holder.LayoutOrder = order
holder.ZIndex = 4
holder.ClipsDescendants = true
holder.Parent = parent
corner(holder, 9)
stroke(holder, COLORS.strokeSoft, 1.15, 0.38)
local slide = Instance.new("Frame")
slide.Name = "SelectedSlide"
slide.BackgroundColor3 = Color3.fromRGB(58, 58, 64)
slide.BackgroundTransparency = 0.08
slide.Size = UDim2.new(0.5, -3, 1, -8)
slide.Position = UDim2.new(0, 4, 0, 4)
slide.BorderSizePixel = 0
slide.ZIndex = 5
slide.Parent = holder
corner(slide, 9)
local slideStroke = Instance.new("UIStroke")
slideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
slideStroke.Color = Color3.fromRGB(235, 235, 245)
slideStroke.Thickness = 1
slideStroke.Transparency = 0.08
slideStroke.Parent = slide
local slideGradient = Instance.new("UIGradient")
slideGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 28)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(46, 46, 52)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 22)),
})
slideGradient.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0.08),
NumberSequenceKeypoint.new(0.5, 0.02),
NumberSequenceKeypoint.new(1, 0.08),
})
slideGradient.Parent = slide
local normalText = Instance.new("TextLabel")
normalText.Name = "NormalText"
normalText.BackgroundTransparency = 1
normalText.Text = "NORMAL"
normalText.TextColor3 = COLORS.white
normalText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
normalText.TextStrokeTransparency = 1
normalText.TextSize = 11
normalText.Font = Enum.Font.Arcade
normalText.TextXAlignment = Enum.TextXAlignment.Center
normalText.Size = UDim2.new(0.5, 0, 1, 0)
normalText.Position = UDim2.new(0, 0, 0, 0)
normalText.ZIndex = 8
normalText.Parent = holder
local bypassText = Instance.new("TextLabel")
bypassText.Name = "BypassText"
bypassText.BackgroundTransparency = 1
bypassText.Text = "BYPASS"
bypassText.TextColor3 = COLORS.white
bypassText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
bypassText.TextStrokeTransparency = 1
bypassText.TextSize = 10
bypassText.Font = Enum.Font.Arcade
bypassText.TextXAlignment = Enum.TextXAlignment.Center
bypassText.Size = UDim2.new(0.5, 0, 1, 0)
bypassText.Position = UDim2.new(0.5, 0, 0, 0)
bypassText.ZIndex = 8
bypassText.Parent = holder
local normalClick = Instance.new("TextButton")
normalClick.Name = "NormalClick"
normalClick.BackgroundTransparency = 1
normalClick.Text = ""
normalClick.AutoButtonColor = false
normalClick.Size = UDim2.new(0.5, 0, 1, 0)
normalClick.Position = UDim2.new(0, 0, 0, 0)
normalClick.ZIndex = 10
normalClick.Parent = holder
local bypassClick = Instance.new("TextButton")
bypassClick.Name = "BypassClick"
bypassClick.BackgroundTransparency = 1
bypassClick.Text = ""
bypassClick.AutoButtonColor = false
bypassClick.Size = UDim2.new(0.5, 0, 1, 0)
bypassClick.Position = UDim2.new(0.5, 0, 0, 0)
bypassClick.ZIndex = 10
bypassClick.Parent = holder
local function setMode(mode)
if mode == "Bypass" then
mode = "Anti Bypass"
elseif mode ~= "Anti Bypass" then
mode = "Normal"
end
selectedAimbotMode = mode
refreshAimbotModeLabels()
if _G.Xlu0RefreshAimbotSpeedBoxes then _G.Xlu0RefreshAimbotSpeedBoxes() end
if _G.Xlu0RefreshAimbotVisual then _G.Xlu0RefreshAimbotVisual() end
do end
local onBypass = selectedAimbotMode == "Anti Bypass"
tween(slide, {
Position = onBypass and UDim2.new(0.5, -1, 0, 4) or UDim2.new(0, 4, 0, 4)
}, 0.18)
tween(normalText, {
TextTransparency = onBypass and 0.18 or 0,
TextStrokeTransparency = onBypass and 0.38 or 0.2
}, 0.14)
tween(bypassText, {
TextTransparency = onBypass and 0 or 0.18,
TextStrokeTransparency = onBypass and 0.2 or 0.38
}, 0.14)
end
normalClick.MouseButton1Click:Connect(function()
setMode("Normal")
end)
bypassClick.MouseButton1Click:Connect(function()
setMode("Anti Bypass")
end)
setMode(selectedAimbotMode)
return holder, setMode
end
function autoStealSelectorRow(parent, order)
local holder = Instance.new("Frame")
holder.Name = "Auto Steal Mode"
holder.BackgroundColor3 = COLORS.row
holder.BackgroundTransparency = 0.28
holder.Size = UDim2.new(1, -4, 0, 42)
holder.BorderSizePixel = 0
holder.LayoutOrder = order
holder.ZIndex = 4
holder.ClipsDescendants = true
holder.Parent = parent
corner(holder, 9)
stroke(holder, COLORS.strokeSoft, 1.15, 0.38)
local slide = Instance.new("Frame")
slide.Name = "SelectedSlide"
slide.BackgroundColor3 = Color3.fromRGB(58, 58, 64)
slide.BackgroundTransparency = 0.08
slide.Size = UDim2.new(0.5, -3, 1, -8)
slide.Position = UDim2.new(0, 4, 0, 4)
slide.BorderSizePixel = 0
slide.ZIndex = 5
slide.Parent = holder
corner(slide, 9)
local slideStroke = Instance.new("UIStroke")
slideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
slideStroke.Color = Color3.fromRGB(235, 235, 245)
slideStroke.Thickness = 1
slideStroke.Transparency = 0.08
slideStroke.Parent = slide
local slideGradient = Instance.new("UIGradient")
slideGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 28)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(46, 46, 52)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 22)),
})
slideGradient.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0.08),
NumberSequenceKeypoint.new(0.5, 0.02),
NumberSequenceKeypoint.new(1, 0.08),
})
slideGradient.Parent = slide
local normalText = Instance.new("TextLabel")
normalText.Name = "NormalText"
normalText.BackgroundTransparency = 1
normalText.Text = "AUTO STEAL V3"
normalText.TextColor3 = COLORS.white
normalText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
normalText.TextStrokeTransparency = 1
normalText.TextSize = 11
normalText.Font = Enum.Font.Arcade
normalText.TextXAlignment = Enum.TextXAlignment.Center
normalText.Size = UDim2.new(0.5, 0, 1, 0)
normalText.Position = UDim2.new(0, 0, 0, 0)
normalText.ZIndex = 8
normalText.Parent = holder
local semiText = Instance.new("TextLabel")
semiText.Name = "SemiText"
semiText.BackgroundTransparency = 1
semiText.Text = "SEMI"
semiText.TextColor3 = COLORS.white
semiText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
semiText.TextStrokeTransparency = 1
semiText.TextSize = 11
semiText.Font = Enum.Font.Arcade
semiText.TextXAlignment = Enum.TextXAlignment.Center
semiText.Size = UDim2.new(0.5, 0, 1, 0)
semiText.Position = UDim2.new(0.5, 0, 0, 0)
semiText.ZIndex = 8
semiText.Parent = holder
local normalClick = Instance.new("TextButton")
normalClick.Name = "NormalClick"
normalClick.BackgroundTransparency = 1
normalClick.Text = ""
normalClick.AutoButtonColor = false
normalClick.Size = UDim2.new(0.5, 0, 1, 0)
normalClick.Position = UDim2.new(0, 0, 0, 0)
normalClick.ZIndex = 10
normalClick.Parent = holder
local semiClick = Instance.new("TextButton")
semiClick.Name = "SemiClick"
semiClick.BackgroundTransparency = 1
semiClick.Text = ""
semiClick.AutoButtonColor = false
semiClick.Size = UDim2.new(0.5, 0, 1, 0)
semiClick.Position = UDim2.new(0.5, 0, 0, 0)
semiClick.ZIndex = 10
semiClick.Parent = holder
local function setMode(mode)
if mode ~= "Semi" then
mode = "Auto Steal V3"
end
_G.Xlu0StealRadii = _G.Xlu0StealRadii or {Normal = 62, Semi = 9}
_G.Xlu0StealRadii[selectedStealMode] = tonumber(autoStealRadius) or _G.Xlu0StealRadii[selectedStealMode]
selectedStealMode = mode
autoStealRadius = _G.Xlu0StealRadii[selectedStealMode] or ((selectedStealMode == "Semi") and 9 or 63)
if autoStealRadiusBox then
autoStealRadiusBox.Text = tostring(autoStealRadius)
end
do end
if _G.Xlu0NormalAutoStealSetRadius then _G.Xlu0NormalAutoStealSetRadius(_G.Xlu0StealRadii.Normal or 62) end
if _G.Xlu0SemiAutoStealSetRadius then _G.Xlu0SemiAutoStealSetRadius(_G.Xlu0StealRadii.Semi or 9) end
if _G.Xlu0AutoStealSync then _G.Xlu0AutoStealSync() end
local onSemi = selectedStealMode == "Semi"
tween(slide, {
Position = onSemi and UDim2.new(0.5, -1, 0, 4) or UDim2.new(0, 4, 0, 4)
}, 0.18)
tween(normalText, {
TextTransparency = onSemi and 0.18 or 0,
TextStrokeTransparency = onSemi and 0.38 or 0.2
}, 0.14)
tween(semiText, {
TextTransparency = onSemi and 0 or 0.18,
TextStrokeTransparency = onSemi and 0.2 or 0.38
}, 0.14)
end
normalClick.MouseButton1Click:Connect(function()
setMode("Auto Steal V3")
end)
semiClick.MouseButton1Click:Connect(function()
setMode("Semi")
end)
setMode(selectedStealMode)
return holder, setMode
end

function infiniteJumpSelectorRow(parent, order)
local holder = Instance.new("Frame")
holder.Name = "Infinite Jump Mode"
holder.BackgroundColor3 = COLORS.row
holder.BackgroundTransparency = 0.28
holder.Size = UDim2.new(1, -4, 0, 42)
holder.BorderSizePixel = 0
holder.LayoutOrder = order
holder.ZIndex = 4
holder.ClipsDescendants = true
holder.Parent = parent
corner(holder, 9)
stroke(holder, COLORS.strokeSoft, 1.15, 0.38)

local slide = Instance.new("Frame")
slide.Name = "SelectedSlide"
slide.BackgroundColor3 = Color3.fromRGB(58, 58, 64)
slide.BackgroundTransparency = 0.08
slide.Size = UDim2.new(0.5, -3, 1, -8)
slide.Position = UDim2.new(0, 4, 0, 4)
slide.BorderSizePixel = 0
slide.ZIndex = 5
slide.Parent = holder
corner(slide, 9)

local slideStroke = Instance.new("UIStroke")
slideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
slideStroke.Color = Color3.fromRGB(235, 235, 245)
slideStroke.Thickness = 1
slideStroke.Transparency = 0.08
slideStroke.Parent = slide

local slideGradient = Instance.new("UIGradient")
slideGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 28)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(46, 46, 52)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 22)),
})
slideGradient.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0.08),
NumberSequenceKeypoint.new(0.5, 0.02),
NumberSequenceKeypoint.new(1, 0.08),
})
slideGradient.Parent = slide

local tapText = Instance.new("TextLabel")
tapText.Name = "TapText"
tapText.BackgroundTransparency = 1
tapText.Text = "TAP"
tapText.TextColor3 = COLORS.white
tapText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
tapText.TextStrokeTransparency = 1
tapText.TextSize = 11
tapText.Font = Enum.Font.Arcade
tapText.TextXAlignment = Enum.TextXAlignment.Center
tapText.Size = UDim2.new(0.5, 0, 1, 0)
tapText.Position = UDim2.new(0, 0, 0, 0)
tapText.ZIndex = 8
tapText.Parent = holder

local holdText = Instance.new("TextLabel")
holdText.Name = "HoldText"
holdText.BackgroundTransparency = 1
holdText.Text = "HOLD"
holdText.TextColor3 = COLORS.white
holdText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
holdText.TextStrokeTransparency = 1
holdText.TextSize = 11
holdText.Font = Enum.Font.Arcade
holdText.TextXAlignment = Enum.TextXAlignment.Center
holdText.Size = UDim2.new(0.5, 0, 1, 0)
holdText.Position = UDim2.new(0.5, 0, 0, 0)
holdText.ZIndex = 8
holdText.Parent = holder

local tapClick = Instance.new("TextButton")
tapClick.Name = "TapClick"
tapClick.BackgroundTransparency = 1
tapClick.Text = ""
tapClick.AutoButtonColor = false
tapClick.Size = UDim2.new(0.5, 0, 1, 0)
tapClick.Position = UDim2.new(0, 0, 0, 0)
tapClick.ZIndex = 10
tapClick.Parent = holder

local holdClick = Instance.new("TextButton")
holdClick.Name = "HoldClick"
holdClick.BackgroundTransparency = 1
holdClick.Text = ""
holdClick.AutoButtonColor = false
holdClick.Size = UDim2.new(0.5, 0, 1, 0)
holdClick.Position = UDim2.new(0.5, 0, 0, 0)
holdClick.ZIndex = 10
holdClick.Parent = holder

local function setMode(mode)
if mode ~= "Hold" then
mode = "Tap"
end
_G.Xlu0InfJumpMode = mode
if _G.Xlu0StopNormalInfJumpHoldState then
_G.Xlu0StopNormalInfJumpHoldState()
end
do end

local onHold = _G.Xlu0InfJumpMode == "Hold"
tween(slide, {
Position = onHold and UDim2.new(0.5, -1, 0, 4) or UDim2.new(0, 4, 0, 4)
}, 0.18)
tween(tapText, {
TextTransparency = onHold and 0.18 or 0,
TextStrokeTransparency = onHold and 0.38 or 0.2
}, 0.14)
tween(holdText, {
TextTransparency = onHold and 0 or 0.18,
TextStrokeTransparency = onHold and 0.2 or 0.38
}, 0.14)
end

tapClick.MouseButton1Click:Connect(function()
setMode("Tap")
end)

holdClick.MouseButton1Click:Connect(function()
setMode("Hold")
end)

setMode(_G.Xlu0InfJumpMode)
return holder, setMode
end


function antiRagdollSelectorRow(parent, order)
local holder = Instance.new("Frame")
holder.Name = "Anti Ragdoll Mode"
holder.BackgroundColor3 = COLORS.row
holder.BackgroundTransparency = 0.28
holder.Size = UDim2.new(1, -4, 0, 42)
holder.BorderSizePixel = 0
holder.LayoutOrder = order
holder.ZIndex = 4
holder.ClipsDescendants = true
holder.Parent = parent
corner(holder, 9)
stroke(holder, COLORS.strokeSoft, 1.15, 0.38)

local slide = Instance.new("Frame")
slide.Name = "SelectedSlide"
slide.BackgroundColor3 = Color3.fromRGB(58,58,64)
slide.BackgroundTransparency = 0.08
slide.Size = UDim2.new(0.5, -3, 1, -8)
slide.Position = UDim2.new(0, 4, 0, 4)
slide.BorderSizePixel = 0
slide.ZIndex = 5
slide.Parent = holder
corner(slide, 9)

local slideStroke = Instance.new("UIStroke")
slideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
slideStroke.Color = Color3.fromRGB(235,235,245)
slideStroke.Thickness = 1
slideStroke.Transparency = 0.08
slideStroke.Parent = slide

local slideGradient = Instance.new("UIGradient")
slideGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(24,24,28)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(46,46,52)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(18,18,22)),
})
slideGradient.Parent = slide

local v1Text = Instance.new("TextLabel")
v1Text.BackgroundTransparency = 1
v1Text.Text = "ANTI RAGDOLL V1"
v1Text.TextColor3 = COLORS.white
v1Text.TextSize = 9
v1Text.Font = Enum.Font.Arcade
v1Text.Size = UDim2.new(0.5, 0, 1, 0)
v1Text.ZIndex = 8
v1Text.Parent = holder

local v2Text = Instance.new("TextLabel")
v2Text.BackgroundTransparency = 1
v2Text.Text = "ANTI RAGDOLL V2"
v2Text.TextColor3 = COLORS.white
v2Text.TextSize = 9
v2Text.Font = Enum.Font.Arcade
v2Text.Size = UDim2.new(0.5, 0, 1, 0)
v2Text.Position = UDim2.new(0.5, 0, 0, 0)
v2Text.ZIndex = 8
v2Text.Parent = holder

local v1Click = Instance.new("TextButton")
v1Click.BackgroundTransparency = 1
v1Click.Text = ""
v1Click.AutoButtonColor = false
v1Click.Size = UDim2.new(0.5, 0, 1, 0)
v1Click.ZIndex = 10
v1Click.Parent = holder

local v2Click = Instance.new("TextButton")
v2Click.BackgroundTransparency = 1
v2Click.Text = ""
v2Click.AutoButtonColor = false
v2Click.Size = UDim2.new(0.5, 0, 1, 0)
v2Click.Position = UDim2.new(0.5, 0, 0, 0)
v2Click.ZIndex = 10
v2Click.Parent = holder

local function setMode(mode)
_G.Xlu0AntiRagdollMode = (mode == "V2") and "V2" or "V1"

local onV2 = _G.Xlu0AntiRagdollMode == "V2"
tween(slide, {
Position = onV2 and UDim2.new(0.5, -1, 0, 4) or UDim2.new(0, 4, 0, 4)
}, 0.18)

tween(v1Text, {
TextTransparency = onV2 and 0.18 or 0,
TextStrokeTransparency = onV2 and 0.38 or 0.2
}, 0.14)

tween(v2Text, {
TextTransparency = onV2 and 0 or 0.18,
TextStrokeTransparency = onV2 and 0.2 or 0.38
}, 0.14)

if antiRagdollEnabled then
setAntiRagdoll(true)
end

do end
end

v1Click.MouseButton1Click:Connect(function()
setMode("V1")
end)

v2Click.MouseButton1Click:Connect(function()
setMode("V2")
end)

setMode(_G.Xlu0AntiRagdollMode)
return holder, setMode
end


function dropModeSelectorRow(parent, order)
local holder = Instance.new("Frame")
holder.Name = "Drop Mode"
holder.BackgroundColor3 = COLORS.row
holder.BackgroundTransparency = 0.28
holder.Size = UDim2.new(1, -4, 0, 42)
holder.BorderSizePixel = 0
holder.LayoutOrder = order
holder.ZIndex = 4
holder.ClipsDescendants = true
holder.Parent = parent
corner(holder, 9)
stroke(holder, COLORS.strokeSoft, 1.15, 0.38)

local slide = Instance.new("Frame")
slide.Name = "SelectedSlide"
slide.BackgroundColor3 = Color3.fromRGB(58,58,64)
slide.BackgroundTransparency = 0.08
slide.Size = UDim2.new(0.5, -3, 1, -8)
slide.Position = UDim2.new(0, 4, 0, 4)
slide.BorderSizePixel = 0
slide.ZIndex = 5
slide.Parent = holder
corner(slide, 9)

local st = Instance.new("UIStroke")
st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
st.Color = Color3.fromRGB(235,235,245)
st.Thickness = 1
st.Transparency = 0.08
st.Parent = slide

local standText = Instance.new("TextLabel")
standText.BackgroundTransparency = 1
standText.Text = "STAND DROP"
standText.TextColor3 = COLORS.white
standText.TextSize = 10
standText.Font = Enum.Font.Arcade
standText.Size = UDim2.new(0.5,0,1,0)
standText.ZIndex = 8
standText.Parent = holder

local jumpText = Instance.new("TextLabel")
jumpText.BackgroundTransparency = 1
jumpText.Text = "JUMP DROP"
jumpText.TextColor3 = COLORS.white
jumpText.TextSize = 10
jumpText.Font = Enum.Font.Arcade
jumpText.Size = UDim2.new(0.5,0,1,0)
jumpText.Position = UDim2.new(0.5,0,0,0)
jumpText.ZIndex = 8
jumpText.Parent = holder

local standClick = Instance.new("TextButton")
standClick.BackgroundTransparency = 1
standClick.Text = ""
standClick.AutoButtonColor = false
standClick.Size = UDim2.new(0.5,0,1,0)
standClick.ZIndex = 10
standClick.Parent = holder

local jumpClick = Instance.new("TextButton")
jumpClick.BackgroundTransparency = 1
jumpClick.Text = ""
jumpClick.AutoButtonColor = false
jumpClick.Size = UDim2.new(0.5,0,1,0)
jumpClick.Position = UDim2.new(0.5,0,0,0)
jumpClick.ZIndex = 10
jumpClick.Parent = holder

local function setMode(mode)
_G.Xlu0DropMode = (mode == "Jump Drop") and "Jump Drop" or "Stand Drop"
local jump = _G.Xlu0DropMode == "Jump Drop"

tween(slide, {
Position = jump and UDim2.new(0.5,-1,0,4) or UDim2.new(0,4,0,4)
}, 0.18)

tween(standText, {TextTransparency = jump and 0.18 or 0}, 0.14)
tween(jumpText, {TextTransparency = jump and 0 or 0.18}, 0.14)

do end
end

standClick.MouseButton1Click:Connect(function() setMode("Stand Drop") end)
jumpClick.MouseButton1Click:Connect(function() setMode("Jump Drop") end)

setMode(_G.Xlu0DropMode)
return holder, setMode
end

-- Spread the large one-time UI build over several frames so executing the
-- loadstring does not monopolize the client thread and visibly freeze play.
task.wait()
Movement = pages.MOVEMENT

section(Movement, "AUTO SPEED", -2)
_, setAutoCarrySpeedVisual = toggleRow(Movement, "Auto Carry Speed", autoCarrySpeedEnabled, -1)
do
local row = Movement:FindFirstChild("Auto Carry Speed")
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
autoCarrySpeedEnabled = not autoCarrySpeedEnabled
if autoCarrySpeedEnabled ~= true and _G.AutoCarrySpeed and _G.AutoCarrySpeed.Disable then
_G.AutoCarrySpeed.Disable()
end
if setAutoCarrySpeedVisual then setAutoCarrySpeedVisual(autoCarrySpeedEnabled == true) end
do end
end)
end
end
section(Movement, "NORMAL SPEED", 1)
_, normalSpeedBox = textboxRow(Movement, "Normal Speed", tostring(NS), 2)
normalSpeedBox.FocusLost:Connect(function()
local v = tonumber(normalSpeedBox.Text)
if v and v > 0 and v <= 250 then
NS = v
end
normalSpeedBox.Text = tostring(NS)
end)
_, carrySpeedBox = textboxRow(Movement, "Carry Speed", tostring(CS), 3)
carrySpeedBox.FocusLost:Connect(function()
local v = tonumber(carrySpeedBox.Text)
if v and v > 0 and v <= 250 then
CS = v
end
carrySpeedBox.Text = tostring(CS)
end)
modeDisplayRow(Movement, 4, "Normal")
section(Movement, "LAGGER SPEED", 5)
_, laggerSpeedBox = textboxRow(Movement, "Lagger Speed", tostring(LAGGER_SPEED), 6)
laggerSpeedBox.FocusLost:Connect(function()
local v = tonumber(laggerSpeedBox.Text)
if v and v > 0 and v <= 250 then
LAGGER_SPEED = v
end
laggerSpeedBox.Text = tostring(LAGGER_SPEED)
end)
_, laggerCarrySpeedBox = textboxRow(Movement, "Lagger Carry Speed", tostring(LAGGER_CARRY_SPEED), 7)
laggerCarrySpeedBox.FocusLost:Connect(function()
local v = tonumber(laggerCarrySpeedBox.Text)
if v and v > 0 and v <= 250 then
LAGGER_CARRY_SPEED = v
end
laggerCarrySpeedBox.Text = tostring(LAGGER_CARRY_SPEED)
end)
modeDisplayRow(Movement, 8, "Lagger")
section(Movement, "TELEPORT", 9)
autoTPRow = nil
autoTPRow, setAutoTPVisual = toggleRow(Movement, "Auto TP Down", autoTPEnabled, 10)
do
local autoTPButton = autoTPRow and autoTPRow:FindFirstChild("ToggleButton")
if autoTPButton then
autoTPButton.MouseButton1Click:Connect(function()
if autoTPClickDebounce then return end
autoTPClickDebounce = true
local nextState = not autoTPEnabled
toggleAutoTP(nextState)
task.delay(0.15, function()
autoTPClickDebounce = false
if setAutoTPVisual then setAutoTPVisual(autoTPEnabled) end
end)
end)
end
if autoTPEnabled then
startAutoTP()
else
stopAutoTP()
end
end
_, autoTPHeightBox = textboxRow(Movement, "Auto TP Height", tostring(autoTPHeight), 11)
autoTPHeightBox.FocusLost:Connect(function()
local v = tonumber(autoTPHeightBox.Text)
if v and v >= -500 and v <= 500 then
autoTPHeight = v
end
autoTPHeightBox.Text = tostring(autoTPHeight)
do end
end)
section(Movement, "JUMP", 15)
_, setInfJumpVisual = toggleRow(Movement, "Infinite Jump", infJumpEnabled, 16)

_G.Xlu0InfJumpMainRow = Movement:FindFirstChild("Infinite Jump")
_G.Xlu0InfJumpToggleBtn = _G.Xlu0InfJumpMainRow and _G.Xlu0InfJumpMainRow:FindFirstChild("ToggleButton")
if _G.Xlu0InfJumpToggleBtn then
_G.Xlu0InfJumpToggleBtn.Size = UDim2.new(0, 54, 1, 0)
_G.Xlu0InfJumpToggleBtn.Position = UDim2.new(1, -54, 0, 0)
end

_G.Xlu0InfJumpArrow = Instance.new("TextButton")
_G.Xlu0InfJumpArrow.Name = "ArrowButton"
_G.Xlu0InfJumpArrow.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
_G.Xlu0InfJumpArrow.BackgroundTransparency = 0.18
_G.Xlu0InfJumpArrow.BorderSizePixel = 0
_G.Xlu0InfJumpArrow.Text = "▼"
_G.Xlu0InfJumpArrow.TextColor3 = COLORS.white
_G.Xlu0InfJumpArrow.TextSize = 18
_G.Xlu0InfJumpArrow.Font = Enum.Font.GothamBlack
_G.Xlu0InfJumpArrow.AutoButtonColor = false
_G.Xlu0InfJumpArrow.Size = UDim2.new(0, 38, 0, 26)
_G.Xlu0InfJumpArrow.Position = UDim2.new(1, -100, 0.5, -13)
_G.Xlu0InfJumpArrow.ZIndex = 20
_G.Xlu0InfJumpArrow.Parent = _G.Xlu0InfJumpMainRow
corner(_G.Xlu0InfJumpArrow, 7)
stroke(_G.Xlu0InfJumpArrow, COLORS.strokeSoft, 1.2, 0.25)

_G.Xlu0InfJumpSelector = infiniteJumpSelectorRow(Movement, 16.1)
_G.Xlu0InfJumpSelector.Visible = false
_G.Xlu0InfJumpSelector.Size = UDim2.new(1, -4, 0, 0)
_G.Xlu0InfJumpExpanded = false

_G.Xlu0InfJumpArrow.MouseButton1Click:Connect(function()
_G.Xlu0InfJumpExpanded = not _G.Xlu0InfJumpExpanded
if _G.Xlu0InfJumpExpanded then
_G.Xlu0InfJumpSelector.Visible = true
tween(_G.Xlu0InfJumpSelector, {Size = UDim2.new(1, -4, 0, 42)}, 0.2)
tween(_G.Xlu0InfJumpArrow, {Rotation = 180}, 0.15)
else
tween(_G.Xlu0InfJumpArrow, {Rotation = 0}, 0.15)
tween(_G.Xlu0InfJumpSelector, {Size = UDim2.new(1, -4, 0, 0)}, 0.2)
task.delay(0.2, function()
if not _G.Xlu0InfJumpExpanded then
_G.Xlu0InfJumpSelector.Visible = false
end
end)
end
end)

do
local row = Movement:FindFirstChild("Infinite Jump")
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
setInfJumpInternal(not infJumpEnabled)
if setInfJumpVisual then setInfJumpVisual(infJumpEnabled == true) end
do end
end)
end
end
_, setAntiRagdollVisual = toggleRow(Movement, "Anti Ragdoll", antiRagdollEnabled, 17)

_G.Xlu0AntiRagdollMainRow = Movement:FindFirstChild("Anti Ragdoll")
_G.Xlu0AntiRagdollToggleBtn = _G.Xlu0AntiRagdollMainRow and _G.Xlu0AntiRagdollMainRow:FindFirstChild("ToggleButton")
if _G.Xlu0AntiRagdollToggleBtn then
_G.Xlu0AntiRagdollToggleBtn.Size = UDim2.new(0, 54, 1, 0)
_G.Xlu0AntiRagdollToggleBtn.Position = UDim2.new(1, -54, 0, 0)
end

_G.Xlu0AntiRagdollArrow = Instance.new("TextButton")
_G.Xlu0AntiRagdollArrow.Name = "ArrowButton"
_G.Xlu0AntiRagdollArrow.BackgroundColor3 = Color3.fromRGB(8,8,12)
_G.Xlu0AntiRagdollArrow.BackgroundTransparency = 0.18
_G.Xlu0AntiRagdollArrow.BorderSizePixel = 0
_G.Xlu0AntiRagdollArrow.Text = "▼"
_G.Xlu0AntiRagdollArrow.TextColor3 = COLORS.white
_G.Xlu0AntiRagdollArrow.TextSize = 18
_G.Xlu0AntiRagdollArrow.Font = Enum.Font.GothamBlack
_G.Xlu0AntiRagdollArrow.AutoButtonColor = false
_G.Xlu0AntiRagdollArrow.Size = UDim2.new(0, 38, 0, 26)
_G.Xlu0AntiRagdollArrow.Position = UDim2.new(1, -100, 0.5, -13)
_G.Xlu0AntiRagdollArrow.ZIndex = 20
_G.Xlu0AntiRagdollArrow.Parent = _G.Xlu0AntiRagdollMainRow
corner(_G.Xlu0AntiRagdollArrow, 7)
stroke(_G.Xlu0AntiRagdollArrow, COLORS.strokeSoft, 1.2, 0.25)

_G.Xlu0AntiRagdollSelector = antiRagdollSelectorRow(Movement, 17.1)
_G.Xlu0AntiRagdollSelector.Visible = false
_G.Xlu0AntiRagdollSelector.Size = UDim2.new(1, -4, 0, 0)
_G.Xlu0AntiRagdollExpanded = false

_G.Xlu0AntiRagdollArrow.MouseButton1Click:Connect(function()
_G.Xlu0AntiRagdollExpanded = not _G.Xlu0AntiRagdollExpanded

if _G.Xlu0AntiRagdollExpanded then
_G.Xlu0AntiRagdollSelector.Visible = true
tween(_G.Xlu0AntiRagdollSelector, {Size = UDim2.new(1, -4, 0, 42)}, 0.2)
tween(_G.Xlu0AntiRagdollArrow, {Rotation = 180}, 0.15)
else
tween(_G.Xlu0AntiRagdollArrow, {Rotation = 0}, 0.15)
tween(_G.Xlu0AntiRagdollSelector, {Size = UDim2.new(1, -4, 0, 0)}, 0.2)
task.delay(0.2, function()
if not _G.Xlu0AntiRagdollExpanded then
_G.Xlu0AntiRagdollSelector.Visible = false
end
end)
end
end)

do
local row = Movement:FindFirstChild("Anti Ragdoll")
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
setAntiRagdoll(not antiRagdollEnabled)
if setAntiRagdollVisual then
setAntiRagdollVisual(antiRagdollEnabled == true)
end
do end
end)
end
end

animationPackRow(Movement, 18)
refreshSpeedModeRows()
task.wait()
Combat = pages.COMBAT
section(Combat, "AUTO STEAL", 1)

_aceRow, setAutoStealVisual = toggleRow(Combat, "Auto Steal", autoStealEnabled, 2)
do
_aceBtn = _aceRow and _aceRow:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Size = UDim2.new(0, 54, 1, 0)
_aceBtn.Position = UDim2.new(1, -54, 0, 0)
_aceBtn.Activated:Connect(function()
autoStealEnabled = not autoStealEnabled
if setAutoStealVisual then
setAutoStealVisual(autoStealEnabled)
end
if _G.Xlu0AutoStealSync then _G.Xlu0AutoStealSync() end
do end
end)
end
end

_G.Xlu0StealArrow = Instance.new("TextButton")
_G.Xlu0StealArrow.Name = "ArrowButton"
_G.Xlu0StealArrow.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
_G.Xlu0StealArrow.BackgroundTransparency = 0.18
_G.Xlu0StealArrow.BorderSizePixel = 0
_G.Xlu0StealArrow.Text = "▼"
_G.Xlu0StealArrow.TextColor3 = COLORS.white
_G.Xlu0StealArrow.TextSize = 18
_G.Xlu0StealArrow.Font = Enum.Font.GothamBlack
_G.Xlu0StealArrow.AutoButtonColor = false
_G.Xlu0StealArrow.Size = UDim2.new(0, 38, 0, 26)
_G.Xlu0StealArrow.Position = UDim2.new(1, -100, 0.5, -13)
_G.Xlu0StealArrow.ZIndex = 20
_G.Xlu0StealArrow.Parent = _aceRow
corner(_G.Xlu0StealArrow, 7)
stroke(_G.Xlu0StealArrow, COLORS.strokeSoft, 1.2, 0.25)

_G.Xlu0StealSelector = autoStealSelectorRow(Combat, 2.1)
_G.Xlu0StealSelector.Visible = false
_G.Xlu0StealSelector.Size = UDim2.new(1, -4, 0, 0)
_G.Xlu0StealExpanded = false

_G.Xlu0StealArrow.MouseButton1Click:Connect(function()
_G.Xlu0StealExpanded = not _G.Xlu0StealExpanded
if _G.Xlu0StealExpanded then
_G.Xlu0StealSelector.Visible = true
tween(_G.Xlu0StealSelector, {Size = UDim2.new(1, -4, 0, 42)}, 0.2)
tween(_G.Xlu0StealArrow, {Rotation = 180}, 0.15)
else
tween(_G.Xlu0StealArrow, {Rotation = 0}, 0.15)
tween(_G.Xlu0StealSelector, {Size = UDim2.new(1, -4, 0, 0)}, 0.2)
task.delay(0.2, function()
if not _G.Xlu0StealExpanded then
_G.Xlu0StealSelector.Visible = false
end
end)
end
end)

_, radiusBox = textboxRow(Combat, "Radius", tostring(autoStealRadius), 3)
autoStealRadiusBox = radiusBox
radiusBox.FocusLost:Connect(function()
local v = tonumber(radiusBox.Text)
if v and v > 0 and v <= 500 then
autoStealRadius = v
if selectedStealMode == "Auto Steal V3" then
    _G.Xlu0StealRadii = _G.Xlu0StealRadii or {}
    _G.Xlu0StealRadii["Auto Steal V3"] = v
end
end
_G.Xlu0StealRadii = _G.Xlu0StealRadii or {Normal = 62, Semi = 9}
_G.Xlu0StealRadii[selectedStealMode] = autoStealRadius
radiusBox.Text = tostring(autoStealRadius)
if _G.Xlu0NormalAutoStealSetRadius then _G.Xlu0NormalAutoStealSetRadius(_G.Xlu0StealRadii.Normal or 62) end
if _G.Xlu0SemiAutoStealSetRadius then _G.Xlu0SemiAutoStealSetRadius(_G.Xlu0StealRadii.Semi or 9) end
if _G.Xlu0AutoStealSync then _G.Xlu0AutoStealSync() end
if saveXlu0Config then
    pcall(saveXlu0Config)
end
do end
end)
local aimbotMainRow, _, aimbotArrow = aimbotModeButtonRow(Combat, 5)
local aimbotSelector = _G.Xlu0AimbotSelectorRow(Combat, 5.1)
aimbotSelector.Visible = false
aimbotSelector.Size = UDim2.new(1, -4, 0, 0)

local aimbotExpanded = false
if aimbotArrow then
aimbotArrow.MouseButton1Click:Connect(function()
aimbotExpanded = not aimbotExpanded
if aimbotExpanded then
aimbotSelector.Visible = true
tween(aimbotSelector, {Size = UDim2.new(1, -4, 0, 42)}, 0.2)
tween(aimbotArrow, {Rotation = 180}, 0.15)
else
tween(aimbotArrow, {Rotation = 0}, 0.15)
tween(aimbotSelector, {Size = UDim2.new(1, -4, 0, 0)}, 0.2)
task.delay(0.2, function()
if not aimbotExpanded then
aimbotSelector.Visible = false
end
end)
end
end)
end

if _G.Xlu0RefreshAimbotVisual then
_G.Xlu0RefreshAimbotVisual()
end
_G.Xlu0NormalAutoSwingRow, _G.Xlu0NormalAutoSwingSetVisual, _G.Xlu0NormalAutoSwingBtn = _G.Xlu0ActionToggleRow(Combat, "Auto Swing", autoSwingEnabled, 7)
do
if _G.Xlu0NormalAutoSwingBtn then
_G.Xlu0NormalAutoSwingBtn.MouseButton1Click:Connect(function()
if _G.Xlu0AutoSwingClickBusy then return end
_G.Xlu0AutoSwingClickBusy = true
autoSwingEnabled = not autoSwingEnabled
if _G.Xlu0NormalAutoSwingSetVisual then _G.Xlu0NormalAutoSwingSetVisual(autoSwingEnabled) end
do end
task.delay(0.12, function() _G.Xlu0AutoSwingClickBusy = false end)
end)
end
end
_G.Xlu0MirrorTPDownRow, _G.Xlu0MirrorTPDownSetVisual, _G.Xlu0MirrorTPDownBtn = _G.Xlu0ActionToggleRow(Combat, "Mirror TP Down (Recommended)", mirrorTPDownEnabled, 7.1)
local mirrorTPDownLabel = _G.Xlu0MirrorTPDownRow and _G.Xlu0MirrorTPDownRow:FindFirstChild("Label")
if mirrorTPDownLabel then mirrorTPDownLabel.TextSize = 10 end
if _G.Xlu0MirrorTPDownBtn then
_G.Xlu0MirrorTPDownBtn.MouseButton1Click:Connect(function()
if _G.Xlu0MirrorTPDownClickBusy then return end
_G.Xlu0MirrorTPDownClickBusy = true
_G.Xlu0SetMirrorTPDown(not mirrorTPDownEnabled)
do end
task.delay(0.12, function() _G.Xlu0MirrorTPDownClickBusy = false end)
end)
end
aimbotSpeedRow, aimbotSpeedBox = textboxRow(Combat, "Normal Aimbot Speed", tostring(AIMBOT_SPEED), 8)
_G.Xlu0AimbotSpeedBox = aimbotSpeedBox
aimbotSpeedLabel = aimbotSpeedRow and aimbotSpeedRow:FindFirstChild("Label")
refreshAimbotModeLabels()
aimbotSpeedBox.FocusLost:Connect(function()
local v = tonumber(aimbotSpeedBox.Text)
if v and v > 0 and v <= 250 then
_G.Xlu0SetSelectedAimbotSpeedValues(v, nil)
end
if _G.Xlu0RefreshAimbotSpeedBoxes then _G.Xlu0RefreshAimbotSpeedBoxes() else aimbotSpeedBox.Text = tostring(AIMBOT_SPEED) end
do end
end)
laggerAimbotSpeedRow, laggerAimbotSpeedBox = textboxRow(Combat, "Normal Lagger Aimbot Speed", tostring(LAGGER_AIMBOT_SPEED), 9)
_G.Xlu0LaggerAimbotSpeedBox = laggerAimbotSpeedBox
laggerAimbotSpeedLabel = laggerAimbotSpeedRow and laggerAimbotSpeedRow:FindFirstChild("Label")
refreshAimbotModeLabels()
if _G.Xlu0RefreshAimbotSpeedBoxes then _G.Xlu0RefreshAimbotSpeedBoxes() end
laggerAimbotSpeedBox.FocusLost:Connect(function()
local v = tonumber(laggerAimbotSpeedBox.Text)
if v and v > 0 and v <= 250 then
_G.Xlu0SetSelectedAimbotSpeedValues(nil, v)
end
if _G.Xlu0RefreshAimbotSpeedBoxes then _G.Xlu0RefreshAimbotSpeedBoxes() else laggerAimbotSpeedBox.Text = tostring(LAGGER_AIMBOT_SPEED) end
do end
end)

_, _G.Xlu0BodyLockVisual = toggleRow(Combat, "Body Lock", _G.Xlu0BodyLockEnabled, 6.5)

_G.Xlu0BodyLockMainRow = Combat:FindFirstChild("Body Lock")
_G.Xlu0BodyLockToggleBtn = _G.Xlu0BodyLockMainRow and _G.Xlu0BodyLockMainRow:FindFirstChild("ToggleButton")
if _G.Xlu0BodyLockToggleBtn then
_G.Xlu0BodyLockToggleBtn.Size = UDim2.new(0, 54, 1, 0)
_G.Xlu0BodyLockToggleBtn.Position = UDim2.new(1, -54, 0, 0)
end

_G.Xlu0BodyLockArrow = Instance.new("TextButton")
_G.Xlu0BodyLockArrow.Name = "ArrowButton"
_G.Xlu0BodyLockArrow.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
_G.Xlu0BodyLockArrow.BackgroundTransparency = 0.18
_G.Xlu0BodyLockArrow.BorderSizePixel = 0
_G.Xlu0BodyLockArrow.Text = "▼"
_G.Xlu0BodyLockArrow.TextColor3 = COLORS.white
_G.Xlu0BodyLockArrow.TextSize = 18
_G.Xlu0BodyLockArrow.Font = Enum.Font.GothamBlack
_G.Xlu0BodyLockArrow.AutoButtonColor = false
_G.Xlu0BodyLockArrow.Size = UDim2.new(0, 38, 0, 26)
_G.Xlu0BodyLockArrow.Position = UDim2.new(1, -100, 0.5, -13)
_G.Xlu0BodyLockArrow.ZIndex = 20
_G.Xlu0BodyLockArrow.Parent = _G.Xlu0BodyLockMainRow
corner(_G.Xlu0BodyLockArrow, 7)
stroke(_G.Xlu0BodyLockArrow, COLORS.strokeSoft, 1.2, 0.25)

_G.Xlu0BodyLockSettings = baseRow(Combat, "", 6.6)
_G.Xlu0BodyLockSettings.Visible = false
_G.Xlu0BodyLockSettings.Size = UDim2.new(1, -4, 0, 0)
_G.Xlu0BodyLockSettings.ClipsDescendants = true

_G.Xlu0BodyLockRadiusLabel = Instance.new("TextLabel")
_G.Xlu0BodyLockRadiusLabel.BackgroundTransparency = 1
_G.Xlu0BodyLockRadiusLabel.Text = "RADIUS"
_G.Xlu0BodyLockRadiusLabel.TextColor3 = COLORS.white
_G.Xlu0BodyLockRadiusLabel.TextSize = 10
_G.Xlu0BodyLockRadiusLabel.Font = Enum.Font.Arcade
_G.Xlu0BodyLockRadiusLabel.TextXAlignment = Enum.TextXAlignment.Left
_G.Xlu0BodyLockRadiusLabel.Size = UDim2.new(0.45, 0, 1, 0)
_G.Xlu0BodyLockRadiusLabel.Position = UDim2.new(0, 12, 0, 0)
_G.Xlu0BodyLockRadiusLabel.ZIndex = 7
_G.Xlu0BodyLockRadiusLabel.Parent = _G.Xlu0BodyLockSettings

_G.Xlu0BodyLockRadiusBox = Instance.new("TextBox")
_G.Xlu0BodyLockRadiusBox.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
_G.Xlu0BodyLockRadiusBox.BackgroundTransparency = 0.18
_G.Xlu0BodyLockRadiusBox.Text = tostring(_G.Xlu0BodyLockRadius)
_G.Xlu0BodyLockRadiusBox.TextColor3 = COLORS.white
_G.Xlu0BodyLockRadiusBox.TextSize = 11
_G.Xlu0BodyLockRadiusBox.Font = Enum.Font.Arcade
_G.Xlu0BodyLockRadiusBox.ClearTextOnFocus = false
_G.Xlu0BodyLockRadiusBox.Size = UDim2.new(0, 76, 0, 28)
_G.Xlu0BodyLockRadiusBox.Position = UDim2.new(1, -88, 0.5, -14)
_G.Xlu0BodyLockRadiusBox.BorderSizePixel = 0
_G.Xlu0BodyLockRadiusBox.ZIndex = 7
_G.Xlu0BodyLockRadiusBox.Parent = _G.Xlu0BodyLockSettings
corner(_G.Xlu0BodyLockRadiusBox, 7)
stroke(_G.Xlu0BodyLockRadiusBox, COLORS.strokeSoft, 1, 0.35)

_G.Xlu0BodyLockRadiusBox.FocusLost:Connect(function()
local n = tonumber(_G.Xlu0BodyLockRadiusBox.Text)
if n then
_G.Xlu0BodyLockRadius = math.clamp(n, 5, 200)
end
_G.Xlu0BodyLockRadiusBox.Text = tostring(_G.Xlu0BodyLockRadius)
end)

_G.Xlu0BodyLockExpanded = false
_G.Xlu0BodyLockArrow.MouseButton1Click:Connect(function()
_G.Xlu0BodyLockExpanded = not _G.Xlu0BodyLockExpanded

if _G.Xlu0BodyLockExpanded then
_G.Xlu0BodyLockArrow.Text = "▲"
_G.Xlu0BodyLockSettings.Visible = true
tween(_G.Xlu0BodyLockSettings, {Size = UDim2.new(1, -4, 0, 42)}, 0.2)
else
_G.Xlu0BodyLockArrow.Text = "▼"
tween(_G.Xlu0BodyLockSettings, {Size = UDim2.new(1, -4, 0, 0)}, 0.2)
task.delay(0.2, function()
if not _G.Xlu0BodyLockExpanded and _G.Xlu0BodyLockSettings then
_G.Xlu0BodyLockSettings.Visible = false
end
end)
end
end)

_G.Xlu0BodyLockButton = _G.Xlu0BodyLockToggleBtn
if _G.Xlu0BodyLockButton then
_G.Xlu0BodyLockButton.Activated:Connect(function()
_G.Xlu0SetBodyLock(not _G.Xlu0BodyLockEnabled)
if _G.Xlu0BodyLockVisual then
_G.Xlu0BodyLockVisual(_G.Xlu0BodyLockEnabled)
end
end)
end

task.defer(function()
task.wait(0.5)
if _G.Xlu0BodyLockEnabled then
_G.Xlu0StartBodyLock()
end
if _G.Xlu0BodyLockVisual then
_G.Xlu0BodyLockVisual(_G.Xlu0BodyLockEnabled)
end
end)

section(Combat, "TP BAT", 10)
_G.Xlu0AntiDesyncAutoSwingRow, _G.Xlu0AntiDesyncAutoSwingSetVisual, _G.Xlu0AntiDesyncAutoSwingBtn = _G.Xlu0ActionToggleRow(Combat, "Auto Swing", antiDesyncAutoSwingEnabled, 11)
do
if _G.Xlu0AntiDesyncAutoSwingBtn then
_G.Xlu0AntiDesyncAutoSwingBtn.MouseButton1Click:Connect(function()
if _G.Xlu0AntiDesyncAutoSwingClickBusy then return end
_G.Xlu0AntiDesyncAutoSwingClickBusy = true
antiDesyncAutoSwingEnabled = not antiDesyncAutoSwingEnabled
if _G.Xlu0AntiDesyncAutoSwingSetVisual then _G.Xlu0AntiDesyncAutoSwingSetVisual(antiDesyncAutoSwingEnabled) end
do end
task.delay(0.12, function() _G.Xlu0AntiDesyncAutoSwingClickBusy = false end)
end)
end
end
_G.Xlu0AntiDesyncSetVisual = function(_) end
section(Combat, "COUNTERS", 13)
_aceRow, setBatCounterVisual = _G.Xlu0ActionToggleRow(Combat, "Bat Counter", batCounterEnabled, 14)
do
_aceBtn = _aceRow and _aceRow:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
batCounterEnabled = not batCounterEnabled
if setBatCounterVisual then
setBatCounterVisual(batCounterEnabled)
end
if batCounterEnabled then
if _G.Xlu0StartBatCounter then _G.Xlu0StartBatCounter() end
else
if _G.Xlu0StopBatCounter then _G.Xlu0StopBatCounter() end
end
do end
end)
end
end
_aceRow, setMedCounterVisual = _G.Xlu0ActionToggleRow(Combat, "Med Counter", medCounterEnabled, 15)
do
_aceBtn = _aceRow and _aceRow:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
medCounterEnabled = not medCounterEnabled
if setMedCounterVisual then
setMedCounterVisual(medCounterEnabled)
end
if medCounterEnabled then
if _G.Xlu0StartMedCounter then _G.Xlu0StartMedCounter(LP.Character) end
else
if _G.Xlu0StopMedCounter then _G.Xlu0StopMedCounter() end
end
do end
end)
end
end
_aceRow, _G.Xlu0SetNoPlayerCollisionVisual = _G.Xlu0ActionToggleRow(Combat, "No Player Collision", _G.Xlu0NoPlayerCollisionEnabled, 16)
do
_aceBtn = _aceRow and _aceRow:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
_G.Xlu0NoPlayerCollisionEnabled = not _G.Xlu0NoPlayerCollisionEnabled
if _G.Xlu0SetNoPlayerCollisionVisual then _G.Xlu0SetNoPlayerCollisionVisual(_G.Xlu0NoPlayerCollisionEnabled) end
if _G.Xlu0NoPlayerCollisionEnabled then
if enableNoPlayerCollision then enableNoPlayerCollision() end
else
if disableNoPlayerCollision then disableNoPlayerCollision() end
end
do end
end)
end
end
_aceRow, setSafeModeVisual = _G.Xlu0ActionToggleRow(Combat, "Safe Mode", antiKickEnabled, 17)
do
_aceBtn = _aceRow and _aceRow:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
antiKickEnabled = not antiKickEnabled
if setSafeModeVisual then setSafeModeVisual(antiKickEnabled) end
if antiKickEnabled and _G.Xlu0SafeModeForceStop then _G.Xlu0SafeModeForceStop("SAFE MODE") end
do end
end)
end
end

_, _G.Xlu0AntiResetVisual = toggleRow(Combat, "Anti Die", _G.Xlu0AntiResetEnabled, 18)
_G.Xlu0AntiResetRow = Combat:FindFirstChild("Anti Die")
_G.Xlu0AntiResetButton = _G.Xlu0AntiResetRow and _G.Xlu0AntiResetRow:FindFirstChild("ToggleButton")
if _G.Xlu0AntiResetButton then
_G.Xlu0AntiResetButton.Activated:Connect(function()
_G.Xlu0SetAntiReset(not _G.Xlu0AntiResetEnabled)
if _G.Xlu0AntiResetVisual then _G.Xlu0AntiResetVisual(_G.Xlu0AntiResetEnabled == true) end
do end
end)
end


_, _G.Xlu0AutoInstantResetVisual = toggleRow(Combat, "Auto Instant Reset", _G.Xlu0AutoInstantResetOnDeath, 18.4)
_G.Xlu0AutoInstantResetRow = Combat:FindFirstChild("Auto Instant Reset")
_G.Xlu0AutoInstantResetButton = _G.Xlu0AutoInstantResetRow and _G.Xlu0AutoInstantResetRow:FindFirstChild("ToggleButton")

if _G.Xlu0AutoInstantResetButton then
_G.Xlu0AutoInstantResetButton.Activated:Connect(function()
_G.Xlu0SetAutoInstantResetOnDeath(not _G.Xlu0AutoInstantResetOnDeath)
if _G.Xlu0AutoInstantResetVisual then
_G.Xlu0AutoInstantResetVisual(_G.Xlu0AutoInstantResetOnDeath == true)
end
end)
end

task.defer(function()
task.wait(0.6)
if _G.Xlu0AutoInstantResetOnDeath then
_G.Xlu0StartAutoInstantResetDeathWatch(LP.Character)
end
if _G.Xlu0AutoInstantResetVisual then
_G.Xlu0AutoInstantResetVisual(_G.Xlu0AutoInstantResetOnDeath == true)
end
end)

_G.Xlu0DropModeMainRow = baseRow(Combat, "Drop", 18.5)

_G.Xlu0DropAction = Instance.new("TextButton")
_G.Xlu0DropAction.Name = "DropAction"
_G.Xlu0DropAction.BackgroundTransparency = 1
_G.Xlu0DropAction.Text = ""
_G.Xlu0DropAction.AutoButtonColor = false
_G.Xlu0DropAction.Size = UDim2.new(1, -50, 1, 0)
_G.Xlu0DropAction.Position = UDim2.new(0, 0, 0, 0)
_G.Xlu0DropAction.ZIndex = 15
_G.Xlu0DropAction.Parent = _G.Xlu0DropModeMainRow

_G.Xlu0DropArrow = Instance.new("TextButton")
_G.Xlu0DropArrow.Name = "ArrowButton"
_G.Xlu0DropArrow.BackgroundColor3 = Color3.fromRGB(8,8,12)
_G.Xlu0DropArrow.BackgroundTransparency = 0.18
_G.Xlu0DropArrow.BorderSizePixel = 0
_G.Xlu0DropArrow.Text = "▼"
_G.Xlu0DropArrow.TextColor3 = COLORS.white
_G.Xlu0DropArrow.TextSize = 18
_G.Xlu0DropArrow.Font = Enum.Font.GothamBlack
_G.Xlu0DropArrow.AutoButtonColor = false
_G.Xlu0DropArrow.Size = UDim2.new(0,38,0,26)
_G.Xlu0DropArrow.Position = UDim2.new(1,-42,0.5,-13)
_G.Xlu0DropArrow.ZIndex = 20
_G.Xlu0DropArrow.Parent = _G.Xlu0DropModeMainRow
corner(_G.Xlu0DropArrow, 7)
stroke(_G.Xlu0DropArrow, COLORS.strokeSoft, 1.2, 0.25)

_G.Xlu0DropSelector = dropModeSelectorRow(Combat, 18.6)
_G.Xlu0DropSelector.Visible = false
_G.Xlu0DropSelector.Size = UDim2.new(1,-4,0,0)
_G.Xlu0DropExpanded = false

_G.Xlu0DropAction.MouseButton1Click:Connect(function()
pcall(runDrop)
end)

_G.Xlu0DropArrow.MouseButton1Click:Connect(function()
-- click effect
tween(_G.Xlu0DropArrow, {
BackgroundTransparency = 0.02,
TextColor3 = Color3.fromRGB(255,255,255)
}, 0.08)

task.delay(0.09, function()
if _G.Xlu0DropArrow then
tween(_G.Xlu0DropArrow, {
BackgroundTransparency = 0.18
}, 0.12)
end
end)

_G.Xlu0DropExpanded = not _G.Xlu0DropExpanded

if _G.Xlu0DropExpanded then
_G.Xlu0DropArrow.Text = "▲"
_G.Xlu0DropSelector.Visible = true
tween(_G.Xlu0DropSelector, {Size = UDim2.new(1,-4,0,42)}, 0.2)
else
_G.Xlu0DropArrow.Text = "▼"
tween(_G.Xlu0DropSelector, {Size = UDim2.new(1,-4,0,0)}, 0.2)
task.delay(0.2, function()
if not _G.Xlu0DropExpanded and _G.Xlu0DropSelector then
_G.Xlu0DropSelector.Visible = false
end
end)
end
end)


_, _G.Xlu0AntiVoidVisual = toggleRow(Combat, "Anti Void", _G.Xlu0AntiVoidEnabled, 19)
_G.Xlu0AntiVoidRow = Combat:FindFirstChild("Anti Void")
_G.Xlu0AntiVoidButton = _G.Xlu0AntiVoidRow and _G.Xlu0AntiVoidRow:FindFirstChild("ToggleButton")
if _G.Xlu0AntiVoidButton then
_G.Xlu0AntiVoidButton.Activated:Connect(function()
_G.Xlu0AntiVoidSet(not _G.Xlu0AntiVoidEnabled)
if _G.Xlu0AntiVoidVisual then _G.Xlu0AntiVoidVisual(_G.Xlu0AntiVoidEnabled == true) end
do end
end)
end

_aceRow, setAutoResetOnMedVisual = toggleRow(Combat, "Auto Reset On Med Fling", autoResetOnMedEnabled, 18)
do
_aceBtn = _aceRow and _aceRow:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
if _G.Xlu0SetAutoResetOnMed then
_G.Xlu0SetAutoResetOnMed(not autoResetOnMedEnabled)
else
autoResetOnMedEnabled = not autoResetOnMedEnabled
if setAutoResetOnMedVisual then setAutoResetOnMedVisual(autoResetOnMedEnabled) end
do end
end
end)
end
end

-- Zombie Hub Auto Play / Duel Mode selector
section(Movement, "AUTO PLAY", 100)

do
    local duelModeRow = baseRow(Movement, "Duel Mode", 101)
    duelModeRow.Size = UDim2.new(1,-4,0,42)

    local lbl = duelModeRow:FindFirstChild("Label")
    if lbl then
        lbl.Text = "Duel Mode"
        lbl.Size = UDim2.new(0.35,0,1,0)
    end

    local halfBtn = Instance.new("TextButton")
    halfBtn.Name = "HalfButton"
    halfBtn.Size = UDim2.new(0,58,0,28)
    halfBtn.Position = UDim2.new(1,-134,0.5,-14)
    halfBtn.BackgroundTransparency = 1
    halfBtn.BorderSizePixel = 0
    halfBtn.Text = "HALF"
    halfBtn.Font = Enum.Font.Arcade
    halfBtn.TextSize = 10
    halfBtn.ZIndex = 20
    halfBtn.Parent = duelModeRow
    corner(halfBtn,6)
    stroke(halfBtn,COLORS.strokeSoft,1,0.45)

    local fullBtn = Instance.new("TextButton")
    fullBtn.Name = "FullButton"
    fullBtn.Size = UDim2.new(0,58,0,28)
    fullBtn.Position = UDim2.new(1,-70,0.5,-14)
    fullBtn.BackgroundTransparency = 1
    fullBtn.BorderSizePixel = 0
    fullBtn.Text = "FULL"
    fullBtn.Font = Enum.Font.Arcade
    fullBtn.TextSize = 10
    fullBtn.ZIndex = 20
    fullBtn.Parent = duelModeRow
    corner(fullBtn,6)
    stroke(fullBtn,COLORS.strokeSoft,1,0.45)

    local function refreshDuelBtns()
        halfBtn.TextColor3 = (_G.Xlu0DuelMode == "half")
            and Color3.fromRGB(255,255,255)
            or Color3.fromRGB(140,140,140)

        fullBtn.TextColor3 = (_G.Xlu0DuelMode == "full")
            and Color3.fromRGB(255,255,255)
            or Color3.fromRGB(140,140,140)

        if _G.Xlu0AutoMoveCarrySpeedBox then
            local row = _G.Xlu0AutoMoveCarrySpeedBox.Parent
            if row then
                row.Visible = (_G.Xlu0DuelMode == "full")
            end
        end
    end

    _G.Xlu0RefreshDuelModeButtons = refreshDuelBtns

    halfBtn.MouseButton1Click:Connect(function()
        _G.Xlu0DuelMode = "half"
        refreshDuelBtns()
        if saveXlu0Config then pcall(saveXlu0Config) end
    end)

    fullBtn.MouseButton1Click:Connect(function()
        _G.Xlu0DuelMode = "full"
        refreshDuelBtns()
        if saveXlu0Config then pcall(saveXlu0Config) end
    end)

    refreshDuelBtns()
end


task.wait()
MenuCustomize = pages.MENU

task.wait()
Keybinds = pages.KEYBINDS
section(Keybinds, "MOVEMENT KEYBINDS", 1)
speedKeybindRow(Keybinds, "Speed Key", "SpeedToggle", 2)
speedKeybindRow(Keybinds, "Lagger Mode Key", "LaggerToggle", 3)
tpDownKeybindRow(Keybinds, 4)
speedKeybindRow(Keybinds, "Drop Brainrot", "DropBrainrot", 5)
section(Keybinds, "COMBAT KEYBINDS", 6)
aimbotKeybindRow = speedKeybindRow(Keybinds, "Normal Aimbot", "Aimbot", 7)
combatAimbotKeybindLabel = aimbotKeybindRow and aimbotKeybindRow:FindFirstChild("Label")
refreshAimbotModeLabels()
speedKeybindRow(Keybinds, "TP BAT", "AntiDesyncAimbot", 8)
speedKeybindRow(Keybinds, "Auto Left", "AutoLeft", 9)
speedKeybindRow(Keybinds, "Auto Right", "AutoRight", 10)
speedKeybindRow(Keybinds, "Instant Reset", "InstantReset", 12)
do
THEME_ACCENT = THEME_ACCENT or Color3.fromRGB(230, 230, 230)
THEME_ACCENT_DIM = THEME_ACCENT_DIM or Color3.fromRGB(145, 145, 145)
PlayerESP = PlayerESP or {enabled=false, playerData={}, conns={}, discordText="discord.gg/gr7eqCS2a"}
BoxedESPOptions = BoxedESPOptions or {box=false, tracer=false}
BoxedESPData = BoxedESPData or {}
BoxedESPConn = BoxedESPConn or nil
stretchRezConn = stretchRezConn or nil
antiLagDescConn = antiLagDescConn or nil
noCamCollisionConn = noCamCollisionConn or nil
noCamCollisionParts = noCamCollisionParts or {}
_aceNukeConns = _aceNukeConns or {}
_aceNukeOn = _aceNukeOn or false
_aceCustomFontOrig = _aceCustomFontOrig or {}
_aceCustomFontConn = _aceCustomFontConn or nil
_aceCustomFont = _aceCustomFont or nil
function startPlayerESP()
if PlayerESP.enabled then return end
PlayerESP.enabled = true
function cleanup(plr)
local d=PlayerESP.playerData[plr]; if not d then return end
pcall(function() if d.highlight then d.highlight:Destroy() end end)
pcall(function() if d.billboard then d.billboard:Destroy() end end)
if d.conns then for _,c in ipairs(d.conns) do pcall(function() c:Disconnect() end) end end
PlayerESP.playerData[plr]=nil
end
function setup(plr,char)
if not PlayerESP.enabled or plr==LP then return end
cleanup(plr)
local hrp=char and (char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart",5))
local head=char and (char:FindFirstChild("Head") or char:WaitForChild("Head",5))
if not hrp or not head then return end
local hl=Instance.new("Highlight")
hl.Name="Xlu0DuelsESP"; hl.Adornee=char; hl.FillColor=(_G.Xlu0ThemeColors and _G.Xlu0ThemeColors[_G.Xlu0ThemeName]) or THEME_ACCENT; hl.FillTransparency=0.72
hl.OutlineColor=(_G.Xlu0ThemeColors and _G.Xlu0ThemeColors[_G.Xlu0ThemeName]) or THEME_ACCENT; hl.OutlineTransparency=0; hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent=char
local bb=Instance.new("BillboardGui")
bb.Name="Xlu0DuelsESPTag"; bb.Adornee=head; bb.Size=UDim2.new(0,124,0,34); bb.StudsOffset=Vector3.new(0,2.7,0); bb.AlwaysOnTop=true; bb.LightInfluence=0; bb.Parent=head
local box=Instance.new("Frame",bb); box.Size=UDim2.new(1,0,1,0); box.BackgroundTransparency=1; box.BorderSizePixel=0
Instance.new("UICorner",box).CornerRadius=UDim.new(0,9)
local n=Instance.new("TextLabel",box); n.Size=UDim2.new(1,-10,0,17); n.Position=UDim2.new(0,5,0,2); n.BackgroundTransparency=1; n.TextColor3=Color3.fromRGB(255,255,255); n.Font=Enum.Font.Arcade; n.TextSize=15; n.TextStrokeTransparency = 1
local sub=Instance.new("TextLabel",box); sub.Size=UDim2.new(1,-10,0,11); sub.Position=UDim2.new(0,5,0,19); sub.BackgroundTransparency=1; sub.TextColor3=Color3.fromRGB(180,180,180); sub.Font=Enum.Font.Arcade; sub.TextSize=10; sub.TextStrokeTransparency = 1
local conn=RunService.Heartbeat:Connect(function()
if not PlayerESP.enabled or not hrp.Parent then return end
local v=hrp.AssemblyLinearVelocity or hrp.Velocity
n.Text=string.format("%d speed", math.floor(Vector3.new(v.X,0,v.Z).Magnitude+0.5)); sub.Text=plr.Name
end)
PlayerESP.playerData[plr]={highlight=hl,billboard=bb,conns={conn}}
end
for _,plr in ipairs(Players:GetPlayers()) do if plr~=LP then if plr.Character then setup(plr,plr.Character) end; table.insert(PlayerESP.conns, plr.CharacterAdded:Connect(function(c) task.defer(setup,plr,c) end)) end end
table.insert(PlayerESP.conns, Players.PlayerAdded:Connect(function(plr) if plr~=LP then table.insert(PlayerESP.conns, plr.CharacterAdded:Connect(function(c) task.defer(setup,plr,c) end)) end end))
table.insert(PlayerESP.conns, Players.PlayerRemoving:Connect(cleanup))
end
function stopPlayerESP()
PlayerESP.enabled=false
for _,c in ipairs(PlayerESP.conns or {}) do pcall(function() c:Disconnect() end) end
PlayerESP.conns={}
for plr,d in pairs(PlayerESP.playerData or {}) do pcall(function() if d.highlight then d.highlight:Destroy() end end); pcall(function() if d.billboard then d.billboard:Destroy() end end) end
PlayerESP.playerData={}
end
function _aceEspColor()
return THEME_ACCENT or Color3.fromRGB(230,230,230)
end
function _safeDrawing(kind, props)
if not Drawing or not Drawing.new then return nil end
local ok, obj = pcall(function() return Drawing.new(kind) end)
if not ok or not obj then return nil end
for k,v in pairs(props or {}) do pcall(function() obj[k]=v end) end
return obj
end
function _cleanupBoxedESPPlayer(player)
local data = BoxedESPData[player]
if not data then return end
for _,obj in pairs(data) do
pcall(function()
obj.Visible = false
if obj.Remove then obj:Remove() end
end)
end
BoxedESPData[player] = nil
end
function _cleanupBoxedESP()
for player,_ in pairs(BoxedESPData) do _cleanupBoxedESPPlayer(player) end
end
function _updateBoxedESP()
local cam = workspace.CurrentCamera
if not cam then return end
local anyOn = BoxedESPOptions.box or BoxedESPOptions.tracer
if not anyOn then
_cleanupBoxedESP()
return
end
for _,player in ipairs(Players:GetPlayers()) do
if player == LP then continue end
local char = player.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
local head = char and char:FindFirstChild("Head")
if not root or not head then
_cleanupBoxedESPPlayer(player)
continue
end
local rootPos,onScreen = cam:WorldToViewportPoint(root.Position)
local headPos = cam:WorldToViewportPoint(head.Position + Vector3.new(0,0.55,0))
local data = BoxedESPData[player]
if not data then
data = {
box = _safeDrawing("Square",{Thickness=2,Filled=false,Transparency=1,Color=_aceEspColor()}),
tracer = _safeDrawing("Line",{Thickness=2,Transparency=1,Color=_aceEspColor()}),
}
BoxedESPData[player] = data
end
local color = _aceEspColor()
local height = math.abs(headPos.Y - rootPos.Y) * 2.15
if height < 20 or height ~= height then height = 65 end
local width = height / 2.15
local view = cam.ViewportSize
local centerX, centerY = view.X/2, view.Y/2
local targetX, targetY = rootPos.X, rootPos.Y + height/2
local targetVisible = onScreen and rootPos.Z > 0
if not targetVisible then
local dx = rootPos.X - centerX
local dy = rootPos.Y - centerY
if rootPos.Z <= 0 then
dx = -dx
dy = -dy
end
if math.abs(dx) < 1 and math.abs(dy) < 1 then
local rel = cam.CFrame:PointToObjectSpace(root.Position)
dx = rel.X
dy = -rel.Y
if rootPos.Z <= 0 then
dx = -dx
dy = -dy
end
end
local edgePad = 10
local scaleX = (dx ~= 0) and ((view.X/2 - edgePad) / math.abs(dx)) or math.huge
local scaleY = (dy ~= 0) and ((view.Y/2 - edgePad) / math.abs(dy)) or math.huge
local scale = math.min(scaleX, scaleY)
if scale == math.huge or scale ~= scale then scale = 1 end
targetX = math.clamp(centerX + dx * scale, edgePad, view.X - edgePad)
targetY = math.clamp(centerY + dy * scale, edgePad, view.Y - edgePad)
end
if data.box then
data.box.Color = color
data.box.Size = Vector2.new(width,height)
data.box.Position = Vector2.new(rootPos.X - width/2, rootPos.Y - height/2)
data.box.Visible = false
end
if data.tracer then
data.tracer.Color = color
local localChar = LP.Character
local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
local localHead = localChar and localChar:FindFirstChild("Head")
local fromX, fromY
if localRoot then
local localScreen = cam:WorldToViewportPoint(localRoot.Position)
fromX = localScreen.X
fromY = localScreen.Y + 15
end
if not fromX or not fromY then
fromX = cam.ViewportSize.X/2
fromY = cam.ViewportSize.Y - 88
end
data.tracer.From = Vector2.new(fromX, fromY)
data.tracer.To = Vector2.new(targetX, targetY)
data.tracer.Visible = BoxedESPOptions.tracer == true
end
end
end
function refreshBoxedESP()
local anyOn = BoxedESPOptions.box or BoxedESPOptions.tracer
if anyOn and not BoxedESPConn then
BoxedESPConn = RunService.RenderStepped:Connect(_updateBoxedESP)
elseif (not anyOn) and BoxedESPConn then
BoxedESPConn:Disconnect()
BoxedESPConn = nil
_cleanupBoxedESP()
end
end
Players.PlayerRemoving:Connect(_cleanupBoxedESPPlayer)
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


local function _vC3(t)
    return Color3.fromRGB(t[1], t[2], t[3])
end

function _v4mpClearSky()
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:GetAttribute("_Xlu0DuelsSky") then
            pcall(function() child:Destroy() end)
        end
    end

    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, child in ipairs(terrain:GetChildren()) do
            if child:GetAttribute("_Xlu0DuelsSky") then
                pcall(function() child:Destroy() end)
            end
        end
    end
end

function applyCustomSky(mode)
    _v4mpClearSky()

    local preset = SKY_PRESETS[mode]
    if not preset or preset.kind == "off" then
        Lighting.ClockTime = 14
        Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
        Lighting.Ambient = Color3.fromRGB(127,127,127)
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
        skyTheme = "Off"
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

    if preset.outAmb then
        Lighting.OutdoorAmbient = _vC3(preset.outAmb)
    end

    if preset.ambient then
        Lighting.Ambient = _vC3(preset.ambient)
    end

    if preset.sky then
        local skyInst = Instance.new("Sky")
        skyInst:SetAttribute("_Xlu0DuelsSky", true)

        if preset.sky.stars then skyInst.StarCount = preset.sky.stars end
        if preset.sky.moon then skyInst.MoonAngularSize = preset.sky.moon end
        if preset.sky.sun then skyInst.SunAngularSize = preset.sky.sun end
        if preset.sky.moonTex then skyInst.MoonTextureId = "rbxasset://sky/moon.jpg" end

        skyInst.Parent = Lighting
    end

    if preset.atm then
        local atm = Instance.new("Atmosphere")
        atm:SetAttribute("_Xlu0DuelsSky", true)
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
        clouds:SetAttribute("_Xlu0DuelsSky", true)
        clouds.Cover = preset.clouds.cover or 0.5
        clouds.Density = preset.clouds.dens or 0.5
        clouds.Color = _vC3(preset.clouds.color)
        clouds.Parent = terrain
    end

    skyTheme = mode
end

_G.Xlu0StretchValue = tonumber(_G.Xlu0StretchValue) or 0.7
_G.Xlu0StretchPreset = _G.Xlu0StretchPreset or "Medium"

_G.Xlu0StretchPresets = {
    ["Light"] = 0.85,
    ["Medium"] = 0.70,
    ["Strong"] = 0.55,
    ["Extreme"] = 0.40,
}

function enableStretchRez()
    fpsBoostEnabled = true
    if stretchRezConn then stretchRezConn:Disconnect(); stretchRezConn=nil end

    stretchRezConn = RunService.RenderStepped:Connect(function()
        if not fpsBoostEnabled then
            if stretchRezConn then stretchRezConn:Disconnect(); stretchRezConn=nil end
            return
        end

        local cam = Workspace.CurrentCamera or workspace.CurrentCamera
        if cam then
            local sv = math.clamp(tonumber(_G.Xlu0StretchValue) or 0.7, 0.1, 1.0)
            -- Zombie Hub exact stretch method: Y-axis compression matrix
            cam.CFrame = cam.CFrame * CFrame.new(
                0,0,0,
                1,0,0,
                0,sv,0,
                0,0,1
            )
        end
    end)
end

function disableStretchRez()
    fpsBoostEnabled = false
    if stretchRezConn then
        stretchRezConn:Disconnect()
        stretchRezConn = nil
    end
end

function _G.Xlu0SetStretchPreset(name)
    local v = _G.Xlu0StretchPresets[name]
    if not v then return end
    _G.Xlu0StretchPreset = name
    _G.Xlu0StretchValue = v
end

function enableCustomFov() fovEnabled=true; workspace.CurrentCamera.FieldOfView=fovValue; if customFovConn then customFovConn:Disconnect() end; customFovConn=RunService.RenderStepped:Connect(function() if not fovEnabled then customFovConn:Disconnect(); customFovConn=nil; return end; workspace.CurrentCamera.FieldOfView=fovValue end) end
function disableCustomFov() fovEnabled=false; if customFovConn then customFovConn:Disconnect(); customFovConn=nil end; workspace.CurrentCamera.FieldOfView=fpsBoostEnabled and 107 or 70 end
_G.Xlu0ZombieAntiLag = _G.Xlu0ZombieAntiLag or {
    conn=nil,
    active=false,
    defBrightness=nil,
    defFog=nil,
    defDiffuse=nil,
    defSpecular=nil,
}

function _applyAntiLagObj(obj)
    pcall(function()
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter")
            or obj:IsA("Trail")
            or obj:IsA("Beam")
            or obj:IsA("Fire")
            or obj:IsA("Smoke")
            or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
            for _,tr in ipairs(obj:GetPlayingAnimationTracks()) do
                pcall(function() tr:Stop(0) end)
            end
        end
    end)
end

function enableAntiLag()
    antiLagVisualEnabled = true
    local S = _G.Xlu0ZombieAntiLag
    S.active = true
    S.defBrightness = S.defBrightness or Lighting.Brightness
    S.defFog = S.defFog or Lighting.FogEnd
    S.defDiffuse = S.defDiffuse or Lighting.EnvironmentDiffuseScale
    S.defSpecular = S.defSpecular or Lighting.EnvironmentSpecularScale

    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e10
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0

    for _,e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect")
                or e:IsA("SunRaysEffect")
                or e:IsA("ColorCorrectionEffect")
                or e:IsA("BloomEffect")
                or e:IsA("DepthOfFieldEffect") then
                e.Enabled = false
            end
        end)
    end

    for _,obj in ipairs(workspace:GetDescendants()) do
        _applyAntiLagObj(obj)
    end

    if S.conn then S.conn:Disconnect() end
    S.conn = workspace.DescendantAdded:Connect(function(obj)
        if S.active then _applyAntiLagObj(obj) end
    end)
    antiLagDescConn = S.conn
end

function disableAntiLag()
    antiLagVisualEnabled = false
    local S = _G.Xlu0ZombieAntiLag
    S.active = false

    if S.conn then
        S.conn:Disconnect()
        S.conn = nil
    end
    antiLagDescConn = nil

    pcall(function()
        Lighting.GlobalShadows = true
        if S.defBrightness then Lighting.Brightness = S.defBrightness end
        if S.defFog then Lighting.FogEnd = S.defFog end
        if S.defDiffuse then Lighting.EnvironmentDiffuseScale = S.defDiffuse end
        if S.defSpecular then Lighting.EnvironmentSpecularScale = S.defSpecular end

        for _,e in pairs(Lighting:GetChildren()) do
            pcall(function()
                if e:IsA("BlurEffect")
                    or e:IsA("SunRaysEffect")
                    or e:IsA("ColorCorrectionEffect")
                    or e:IsA("BloomEffect")
                    or e:IsA("DepthOfFieldEffect") then
                    e.Enabled = true
                end
            end)
        end
    end)
end

function applyKTMOptimization()
    enableAntiLag()
end

function enableNukeOptimizer()
nukeOptimiserEnabled=true; _aceNukeOn=true; applyKTMOptimization(); applyCustomSky("Off")
for _,c in ipairs(_aceNukeConns) do pcall(function() c:Disconnect() end) end; _aceNukeConns={}
table.insert(_aceNukeConns, workspace.DescendantAdded:Connect(function(o) if nukeOptimiserEnabled then _applyAntiLagObj(o) end end))
task.spawn(function() while nukeOptimiserEnabled do pcall(function() setfpscap(240) end); task.wait(3) end end)
end
function disableNukeOptimizer() nukeOptimiserEnabled=false; _aceNukeOn=false; for _,c in ipairs(_aceNukeConns) do pcall(function() c:Disconnect() end) end; _aceNukeConns={} end
function enableNoCamCollision()
noCamCollisionEnabled=true; if noCamCollisionConn then noCamCollisionConn:Disconnect() end
noCamCollisionConn=RunService.RenderStepped:Connect(function()
if not noCamCollisionEnabled then return end
local cam=workspace.CurrentCamera; local char=LP.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart"); if not cam or not hrp then return end
local params=RaycastParams.new(); params.FilterType=Enum.RaycastFilterType.Exclude; params.FilterDescendantsInstances=workspace.CurrentCamera and workspace.CurrentCamera:FindFirstChild("_Xlu0AvatarOverlay") and {char,workspace.CurrentCamera:FindFirstChild("_Xlu0AvatarOverlay")} or {char}; params.IgnoreWater=true
local res=workspace:Raycast(cam.CFrame.Position,(hrp.Position+Vector3.new(0,1.5,0))-cam.CFrame.Position,params)
local hit={}
if res and res.Instance and res.Instance:IsA("BasePart") then hit[res.Instance]=true; if noCamCollisionParts[res.Instance]==nil then noCamCollisionParts[res.Instance]=res.Instance.LocalTransparencyModifier end; res.Instance.LocalTransparencyModifier=1 end
for part,orig in pairs(noCamCollisionParts) do if not hit[part] then pcall(function() if part and part.Parent then part.LocalTransparencyModifier=orig end end); noCamCollisionParts[part]=nil end end
end)
end
function disableNoCamCollision() noCamCollisionEnabled=false; if noCamCollisionConn then noCamCollisionConn:Disconnect(); noCamCollisionConn=nil end; for p,orig in pairs(noCamCollisionParts) do pcall(function() if p and p.Parent then p.LocalTransparencyModifier=orig end end) end; noCamCollisionParts={} end
function enableCustomFont() customFontVisualEnabled=false; if V then V.customFontEnabled=false end end
function disableCustomFont() customFontVisualEnabled=false; if V then V.customFontEnabled=false end end
end
V = V or {}
V.skyTheme = skyTheme or V.skyTheme or "Off"
V.nukeOptEnabled = nukeOptimiserEnabled == true
V.customFontEnabled = false
V.potatoGraphicsEnabled = V.potatoGraphicsEnabled or false
function enableNoCamCollision()
noCamCollisionEnabled = true
if noCamCollisionConn then noCamCollisionConn:Disconnect() end
noCamCollisionConn = RunService.RenderStepped:Connect(function()
if not noCamCollisionEnabled then
if noCamCollisionConn then noCamCollisionConn:Disconnect();noCamCollisionConn=nil end
return
end
local cam = workspace.CurrentCamera
local char = LP.Character
if not cam or not char then return end
local hrp = char:FindFirstChild("HumanoidRootPart")
if not hrp then return end
local camPos = cam.CFrame.Position
local charPos = hrp.Position + Vector3.new(0,1.5,0)
local toChar = charPos - camPos
if toChar.Magnitude < 0.3 then return end
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances = workspace.CurrentCamera and workspace.CurrentCamera:FindFirstChild("_Xlu0AvatarOverlay") and {char, workspace.CurrentCamera:FindFirstChild("_Xlu0AvatarOverlay")} or {char}
params.IgnoreWater = true
local hit = {}
local origin = camPos
local remaining = toChar
for _ = 1,12 do
if remaining.Magnitude < 0.2 then break end
local res = workspace:Raycast(origin,remaining,params)
if not res then break end
local part = res.Instance
if part and part:IsA("BasePart") and not part:IsDescendantOf(char) then
hit[part] = true
if noCamCollisionParts[part] == nil then noCamCollisionParts[part] = part.LocalTransparencyModifier end
part.LocalTransparencyModifier = 1
end
origin = res.Position + remaining.Unit * 0.02
remaining = charPos - origin
end
for part,orig in pairs(noCamCollisionParts) do
if not hit[part] then
pcall(function() if part and part.Parent then part.LocalTransparencyModifier = orig end end)
noCamCollisionParts[part] = nil
end
end
end)
end
function disableNoCamCollision()
noCamCollisionEnabled = false
if noCamCollisionConn then noCamCollisionConn:Disconnect();noCamCollisionConn=nil end
for part,orig in pairs(noCamCollisionParts) do
pcall(function() if part and part.Parent then part.LocalTransparencyModifier = orig end end)
end
noCamCollisionParts = {}
end
SKY_PRESETS_LIST = {"Off","Night","Aurora","Sunset","Galaxy","Tech","Sakura","Pink Night",
"Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse",
"Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}
SKY_PRESETS = {
["Off"] = {kind = "off"},
["Night"] = {clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
["Aurora"] = {clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
["Sunset"] = {clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
["Galaxy"] = {clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
["Tech"] = {clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
["Sakura"] = {clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
["Pink Night"] = {clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
["Blood Moon"] = {clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
["Emerald Dawn"] = {clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
["Volcanic"] = {clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
["Arctic"] = {clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
["Midnight Ocean"] = {clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
["Vaporwave"] = {clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.5,dens=0.55,color={200,150,255}}},
["Toxic"] = {clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
["Solar Eclipse"] = {clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
["Hellscape"] = {clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
["Heaven"] = {clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
["Storm"] = {clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
["Sunrise"] = {clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
["Deep Space"] = {clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
["Lavender Dream"] = {clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
["Inferno"] = {clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
["Mint Sky"] = {clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}
function _vC3(t) return Color3.fromRGB(t[1], t[2], t[3]) end
function _v4mpClearSky()
for _, v in ipairs(Lighting:GetChildren()) do
if v:GetAttribute("_Xlu0DuelsSky") then pcall(function() v:Destroy() end) end
end
local terrain = workspace:FindFirstChildOfClass("Terrain")
if terrain then
for _, v in ipairs(terrain:GetChildren()) do
if v:GetAttribute("_Xlu0DuelsSky") then pcall(function() v:Destroy() end) end
end
end
end
function applyCustomSky(mode)
_v4mpClearSky()
local preset = SKY_PRESETS[mode]
if not preset or preset.kind == "off" then
Lighting.FogEnd = 100000; Lighting.FogStart = 0
Lighting.FogColor = Color3.fromRGB(192,192,192)
Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.GlobalShadows = true
V.skyTheme = "Off"
return
end
Lighting.FogEnd = 100000; Lighting.FogStart = 0
Lighting.FogColor = Color3.fromRGB(200,200,200)
Lighting.GlobalShadows = true
Lighting.ClockTime = preset.clock or 14
Lighting.Brightness = preset.brightness or 2
if preset.outAmb then Lighting.OutdoorAmbient = _vC3(preset.outAmb) end
if preset.ambient then Lighting.Ambient = _vC3(preset.ambient) end
if preset.sky then
local sky = Instance.new("Sky")
sky:SetAttribute("_Xlu0DuelsSky", true)
if preset.sky.stars then sky.StarCount = preset.sky.stars end
if preset.sky.moon then sky.MoonAngularSize = preset.sky.moon end
if preset.sky.sun then sky.SunAngularSize = preset.sky.sun end
if preset.sky.moonTex then sky.MoonTextureId = "rbxasset://sky/moon.jpg" end
sky.Parent = Lighting
end
if preset.atm then
local atm = Instance.new("Atmosphere")
atm:SetAttribute("_Xlu0DuelsSky", true)
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
clouds:SetAttribute("_Xlu0DuelsSky", true)
clouds.Cover = preset.clouds.cover or 0.5
clouds.Density = preset.clouds.dens or 0.5
clouds.Color = _vC3(preset.clouds.color)
clouds.Parent = terrain
end
V.skyTheme = mode
end
function enableUltraMode()
V.ultraModeEnabled = true
applyKTMOptimization()
end
function disableUltraMode()
V.ultraModeEnabled = false
end
function enableRemoveAccessories()
V.removeAccessoriesEnabledSep = true
removeAccessoriesEnabled = true
removeAllAccessories()
if V.removeAccConn then V.removeAccConn:Disconnect() end
V.removeAccConn = Players.PlayerAdded:Connect(function(player)
player.CharacterAdded:Connect(function(char)
task.wait(0.5)
if V.removeAccessoriesEnabledSep or removeAccessoriesEnabled then
for _,obj in ipairs(char:GetDescendants()) do processAntiLagDescendant(obj) end
end
end)
end)
if antiLagDescConn then antiLagDescConn:Disconnect() end
antiLagDescConn = Workspace.DescendantAdded:Connect(function(obj)
if antiLagEnabled or V.ultraModeEnabled or removeAccessoriesEnabled or V.removeAccessoriesEnabledSep then
processAntiLagDescendant(obj)
end
end)
end
function disableRemoveAccessories()
V.removeAccessoriesEnabledSep = false
removeAccessoriesEnabled = false
if V.removeAccConn then V.removeAccConn:Disconnect(); V.removeAccConn = nil end
if not antiLagEnabled and not V.ultraModeEnabled and antiLagDescConn then antiLagDescConn:Disconnect(); antiLagDescConn = nil end
end
_nukeOptimizerOn = false
_nukeOptimizerConns = {}
_nukeOptimizerThreads = {}
function enableNukeOptimizer()
if _nukeOptimizerOn then return end
_nukeOptimizerOn = true
nukeOptimiserEnabled = true
V.nukeOptEnabled = true
local MaterialService = game:GetService("MaterialService")
local XMin, XMax = -560, -240
local ClothingClasses = {"Shirt","Pants","ShirtGraphic","Accessory","Hat","HairAccessory","FaceAccessory","NeckAccessory","ShoulderAccessory","FrontAccessory","BackAccessory","WaistAccessory"}
local BASE_NAMES = {"baseplate","spawnlocation","spawn location","spawn"}
function SafeDestroy(obj)
if obj and obj.Name == "Overhead" then return end
pcall(function() obj:Destroy() end)
end
function IsClothing(obj)
for _, className in ipairs(ClothingClasses) do
if obj:IsA(className) then return true end
end
return false
end
function IsCharacterPart(obj)
for _, plr in ipairs(Players:GetPlayers()) do
if plr.Character and obj:IsDescendantOf(plr.Character) then return true end
end
return false
end
function IsOutOfRange(obj)
if obj:IsA("BasePart") then
local x = obj.Position.X
return x < XMin or x > XMax
end
return false
end
function IsBase(obj)
if not obj:IsA("BasePart") then return false end
local nl = obj.Name:lower()
for _, n in ipairs(BASE_NAMES) do
if nl:find(n, 1, true) then return true end
end
return false
end
function IsInBase(obj)
local p = obj.Parent
while p and p ~= workspace do
if IsBase(p) then return true end
p = p.Parent
end
return false
end
function MakeTransparent(obj)
pcall(function()
if IsBase(obj) and not IsCharacterPart(obj) then
obj.Transparency = 1
obj.CastShadow = false
end
end)
end
function StripObject(obj)
pcall(function()
if obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("SpecialMesh") then
SafeDestroy(obj)
elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
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
function CleanObject(obj)
pcall(function()
if obj:IsA("SurfaceAppearance") then
SafeDestroy(obj)
elseif obj:IsA("Decal") or obj:IsA("Texture") then
if not (obj.Name == "face" and obj.Parent and obj.Parent.Name == "Head") then SafeDestroy(obj) end
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
function ApplyGreySky()
pcall(function()
for _, obj in ipairs(Lighting:GetChildren()) do
if obj:IsA("Sky") then obj:Destroy() end
end
local sky = Instance.new("Sky")
sky.SkyboxBk = ""; sky.SkyboxDn = ""; sky.SkyboxFt = ""
sky.SkyboxLf = ""; sky.SkyboxRt = ""; sky.SkyboxUp = ""
sky.CelestialBodiesShown = false
sky.Name = "_Xlu0DuelsNukeSky"
sky.Parent = Lighting
end)
end
function OptimizeLighting()
pcall(function()
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.FogStart = 9e9
Lighting.EnvironmentDiffuseScale = 0
Lighting.EnvironmentSpecularScale = 0
Lighting.Brightness = 1.5
Lighting.Ambient = Color3.fromRGB(60,60,60)
for _, v in ipairs(Lighting:GetChildren()) do
if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Atmosphere") or v:IsA("Clouds") then
v:Destroy()
end
end
ApplyGreySky()
end)
end
function ApplyTerrain()
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
end
function OptimizeCharacter(char)
if not char then return end
task.spawn(function()
task.wait(0.3)
if not _nukeOptimizerOn then return end
for _, obj in ipairs(char:GetDescendants()) do
if IsClothing(obj) then SafeDestroy(obj) else CleanObject(obj) end
end
end)
end
pcall(function()
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
end)
pcall(function() if setfpscap then setfpscap(999) end end)
table.insert(_nukeOptimizerThreads, task.spawn(function()
if not game:IsLoaded() then game.Loaded:Wait() end
OptimizeLighting()
ApplyTerrain()
for _, obj in ipairs(workspace:GetDescendants()) do
if not _nukeOptimizerOn then return end
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
for _, obj in ipairs(workspace:GetDescendants()) do MakeTransparent(obj) end
end))
table.insert(_nukeOptimizerConns, workspace.DescendantAdded:Connect(function(obj)
if not _nukeOptimizerOn then return end
task.defer(function()
if not _nukeOptimizerOn then return end
if IsBase(obj) then MakeTransparent(obj); return end
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
table.insert(_nukeOptimizerConns, Lighting.DescendantAdded:Connect(function(obj)
if not _nukeOptimizerOn then return end
if obj:IsA("Atmosphere") or obj:IsA("Clouds") or obj:IsA("PostEffect") then SafeDestroy(obj) end
end))
table.insert(_nukeOptimizerConns, MaterialService.DescendantAdded:Connect(function(obj)
if not _nukeOptimizerOn then return end
SafeDestroy(obj)
end))
for _, plr in ipairs(Players:GetPlayers()) do
OptimizeCharacter(plr.Character)
table.insert(_nukeOptimizerConns, plr.CharacterAdded:Connect(OptimizeCharacter))
end
table.insert(_nukeOptimizerConns, Players.PlayerAdded:Connect(function(plr)
table.insert(_nukeOptimizerConns, plr.CharacterAdded:Connect(OptimizeCharacter))
end))
table.insert(_nukeOptimizerThreads, task.spawn(function()
while _nukeOptimizerOn do
task.wait(15)
pcall(function() collectgarbage("collect") end)
end
end))
end
function disableNukeOptimizer()
_nukeOptimizerOn = false
nukeOptimiserEnabled = false
V.nukeOptEnabled = false
for _, c in ipairs(_nukeOptimizerConns) do pcall(function() c:Disconnect() end) end
_nukeOptimizerConns = {}
_nukeOptimizerThreads = {}
end
function enableCustomFont() customFontVisualEnabled=false; if V then V.customFontEnabled=false end end
function disableCustomFont() customFontVisualEnabled=false; if V then V.customFontEnabled=false end end
__ace_src_enableNoCamCollision = enableNoCamCollision
function enableNoCamCollision()
__ace_src_enableNoCamCollision()
noCamCollisionEnabled = true
end
__ace_src_disableNoCamCollision = disableNoCamCollision
function disableNoCamCollision()
__ace_src_disableNoCamCollision()
noCamCollisionEnabled = false
end

--// ==================== XLU0 AVATAR CHANGER MODULE ====================
_G.Xlu0InstallAvatarChanger = function()
    local XAC = {
        model = nil,
        renderConn = nil,
        fpConn = nil,
        hideConn = nil,
        hideEnforceConn = nil,
        motorPairs = {},
        fpHidden = {},
        hiddenParts = {},
        paused = false,
        lastUserId = nil,
        lastUsername = nil,
    }
    _G.Xlu0AvatarChangerState = XAC

    local function getFolder()
        local cam = workspace.CurrentCamera
        if not cam then return nil end
        local folder = cam:FindFirstChild("_Xlu0AvatarOverlay")
        if not folder then
            folder = Instance.new("Folder")
            folder.Name = "_Xlu0AvatarOverlay"
            folder.Parent = cam
        end
        return folder
    end

    local function stopConn(name)
        local c = XAC[name]
        if c then pcall(function() c:Disconnect() end) end
        XAC[name] = nil
    end

    local function restoreReal()
        for inst, old in pairs(XAC.hiddenParts) do
            if inst and inst.Parent then
                pcall(function()
                    if inst:IsA("BasePart") then
                        inst.LocalTransparencyModifier = old
                    elseif inst:IsA("Decal") or inst:IsA("Texture") then
                        inst.Transparency = old
                    end
                end)
            end
        end
        table.clear(XAC.hiddenParts)
    end

    local function setRealHidden(on)
        stopConn("hideConn")
        stopConn("hideEnforceConn")
        restoreReal()
        if not on then return end

        local function hideOne(inst)
            if inst:IsA("BasePart") then
                if XAC.hiddenParts[inst] == nil then
                    XAC.hiddenParts[inst] = inst.LocalTransparencyModifier
                end
                inst.LocalTransparencyModifier = 1
            elseif inst:IsA("Decal") or inst:IsA("Texture") then
                if XAC.hiddenParts[inst] == nil then
                    XAC.hiddenParts[inst] = inst.Transparency
                end
                inst.Transparency = 1
            end
        end

        local char = LP.Character
        if not char then return end
        for _, inst in ipairs(char:GetDescendants()) do pcall(hideOne, inst) end

        XAC.hideConn = char.DescendantAdded:Connect(function(inst)
            task.defer(function()
                if inst and inst.Parent then pcall(hideOne, inst) end
            end)
        end)

        XAC.hideEnforceConn = RunService.RenderStepped:Connect(function()
            local c = LP.Character
            if not c or not XAC.model then return end
            for _, inst in ipairs(c:GetDescendants()) do pcall(hideOne, inst) end
        end)
    end

    local function restoreOverlay()
        for inst, old in pairs(XAC.fpHidden) do
            if inst and inst.Parent then
                pcall(function()
                    if inst:IsA("BasePart") then
                        inst.LocalTransparencyModifier = old
                    elseif inst:IsA("Decal") or inst:IsA("Texture") then
                        inst.Transparency = old
                    end
                end)
            end
        end
        table.clear(XAC.fpHidden)
    end

    local function hideOverlay()
        if not XAC.model then return end
        for _, inst in ipairs(XAC.model:GetDescendants()) do
            if inst:IsA("BasePart") then
                if XAC.fpHidden[inst] == nil then
                    XAC.fpHidden[inst] = inst.LocalTransparencyModifier
                end
                inst.LocalTransparencyModifier = 1
            elseif inst:IsA("Decal") or inst:IsA("Texture") then
                if XAC.fpHidden[inst] == nil then
                    XAC.fpHidden[inst] = inst.Transparency
                end
                inst.Transparency = 1
            end
        end
    end

    local function startFirstPerson()
        stopConn("fpConn")
        local hidden = false
        XAC.fpConn = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            local char = LP.Character
            local head = char and char:FindFirstChild("Head")
            if not XAC.model or not cam or not head then return end

            local d = (cam.CFrame.Position - head.Position).Magnitude
            local lockFP = LP.CameraMode == Enum.CameraMode.LockFirstPerson

            -- Çok dar eşikler: No Cam Collision / zıplama bunu yanlışlıkla tetiklemesin.
            if hidden then
                if not lockFP and d > 1.15 then hidden = false end
            else
                if lockFP or d <= 0.95 then hidden = true end
            end

            if hidden then
                -- Her frame tekrar uygula; zıplama/kamera bob sırasında 1 frame görünmeyi engeller.
                hideOverlay()
                for _, inst in ipairs(XAC.model:GetDescendants()) do
                    if inst:IsA("BasePart") then
                        inst.LocalTransparencyModifier = 1
                    elseif inst:IsA("Decal") or inst:IsA("Texture") then
                        inst.Transparency = 1
                    end
                end
            elseif next(XAC.fpHidden) ~= nil then
                restoreOverlay()
            end
        end)
    end

    local function destroyOverlay()
        stopConn("renderConn")
        stopConn("fpConn")
        restoreOverlay()
        if XAC.model then pcall(function() XAC.model:Destroy() end) end
        XAC.model = nil
        XAC.paused = false
    end

    local function prepare(model)
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("Script") or d:IsA("LocalScript") then
                d.Disabled = true
            elseif d:IsA("BasePart") then
                d.CanCollide = false
                d.CanTouch = false
                d.CanQuery = false
                d.Massless = true
            end
        end
        local hum = model:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = true
            hum.AutoRotate = false
            hum.Sit = true
            hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            hum.NameDisplayDistance = 0
            hum.HealthDisplayDistance = 0
        end
        return model
    end

    local function motorKey(m)
        return m.Name .. "|" ..
            ((m.Part0 and m.Part0.Name) or "nil") .. ">" ..
            ((m.Part1 and m.Part1.Name) or "nil")
    end

    local function buildPairs(srcChar, target)
        table.clear(XAC.motorPairs)
        local a, b = {}, {}
        for _, d in ipairs(srcChar:GetDescendants()) do
            if d:IsA("Motor6D") then a[motorKey(d)] = d end
        end
        for _, d in ipairs(target:GetDescendants()) do
            if d:IsA("Motor6D") then b[motorKey(d)] = d end
        end
        for k, src in pairs(a) do
            if b[k] then table.insert(XAC.motorPairs, {src = src, tgt = b[k]}) end
        end
    end

    local function startMirror()
        stopConn("renderConn")
        XAC.renderConn = RunService.RenderStepped:Connect(function()
            if XAC.paused or not XAC.model then return end
            for _, pair in ipairs(XAC.motorPairs) do
                if pair.src and pair.tgt and pair.src.Parent and pair.tgt.Parent then
                    pair.tgt.Transform = pair.src.Transform
                end
            end
        end)
    end

    local function resolve(value)
        value = tostring(value or ""):gsub("^%s+",""):gsub("%s+$","")
        if value == "" then return false, "ENTER USERNAME / USER ID" end
        local n = tonumber(value)
        if n then
            local uid = math.floor(n)
            local ok, name = pcall(function() return Players:GetNameFromUserIdAsync(uid) end)
            if not ok or not name then return false, "USER NOT FOUND" end
            return true, uid, name
        end
        local ok, uid = pcall(function() return Players:GetUserIdFromNameAsync(value) end)
        if not ok or not uid then return false, "USER NOT FOUND" end
        return true, uid, value
    end

    local function spawnAvatar(uid, username, status)
        status = status or function() end
        status("SPAWNING...")
        destroyOverlay()

        local ok, model = pcall(function()
            return Players:CreateHumanoidModelFromUserIdAsync(uid)
        end)
        if not ok or typeof(model) ~= "Instance" then
            status("FAILED")
            return
        end

        model = prepare(model)
        model.Name = "Xlu0AvatarOverlay_" .. tostring(uid)

        local folder = getFolder()
        local char = LP.Character
        local myHRP = char and char:FindFirstChild("HumanoidRootPart")
        local oHRP = model:FindFirstChild("HumanoidRootPart")
        if not folder or not myHRP or not oHRP then
            model:Destroy()
            status("HRP NOT READY")
            return
        end

        model.Parent = folder
        model:PivotTo(myHRP.CFrame)

        local weld = Instance.new("WeldConstraint")
        weld.Part0 = oHRP
        weld.Part1 = myHRP
        weld.Parent = oHRP

        XAC.model = model
        XAC.lastUserId = uid
        XAC.lastUsername = username
        _G.Xlu0AvatarChangerCleared = false
        XAC.paused = false

        -- Mevcut Headless / Korblox ayarlarını görünür overlay avatara da uygula.
        pcall(function()
            if _G.Xlu0ApplyHeadless then
                _G.Xlu0ApplyHeadless(model, _G.Xlu0HeadlessEnabled == true)
            end
            if _G.Xlu0ApplyKorblox then
                _G.Xlu0ApplyKorblox(model, _G.Xlu0KorbloxEnabled == true)
            end
        end)

        setRealHidden(true)
        buildPairs(char, model)
        startMirror()
        startFirstPerson()
        status("ACTIVE - " .. tostring(username))
    end

    _G.Xlu0AvatarChangerSpawn = spawnAvatar
    _G.Xlu0AvatarChangerRemove = function()
        destroyOverlay()
        setRealHidden(false)
        XAC.lastUserId = nil
        XAC.lastUsername = nil
        _G.Xlu0AvatarChangerCleared = true
    end
    _G.Xlu0AvatarChangerResolve = resolve

    _G.Xlu0OpenAvatarChanger = function()
        local old = PlayerGui:FindFirstChild("Xlu0AvatarChangerGallery")
        if old then old:Destroy() end

        local sg = Instance.new("ScreenGui")
        sg.Name = "Xlu0AvatarChangerGallery"
        sg.IgnoreGuiInset = true
        sg.ResetOnSpawn = false
        sg.DisplayOrder = 99999
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        sg.Parent = PlayerGui

        local shade = Instance.new("TextButton")
        shade.Text = ""
        shade.AutoButtonColor = false
        shade.BackgroundColor3 = Color3.fromRGB(0,0,0)
        shade.BackgroundTransparency = 0.25
        shade.Size = UDim2.fromScale(1,1)
        shade.ZIndex = 1
        shade.Parent = sg

        local panel = Instance.new("Frame")
        panel.AnchorPoint = Vector2.new(0.5,0.5)
        panel.Position = UDim2.fromScale(0.5,0.5)
        panel.Size = UDim2.new(0, 620, 0, 500)
        panel.BackgroundColor3 = Color3.fromRGB(10,10,15)
        panel.BackgroundTransparency = 0.04
        panel.BorderSizePixel = 0
        panel.ZIndex = 2
        panel.Parent = sg
        corner(panel,16)
        stroke(panel,COLORS.strokeSoft,1.2,0.15)

        pcall(function()
            local bg = Main and Main:FindFirstChild("CustomBackground")
            if bg and bg:IsA("ImageLabel") and bg.Visible and bg.Image ~= "" then
                local pbg = bg:Clone()
                pbg.Name = "PanelBackground"
                pbg.Size = UDim2.fromScale(1,1)
                pbg.Position = UDim2.fromScale(0,0)
                pbg.ZIndex = 2
                pbg.ImageTransparency = math.max(bg.ImageTransparency,0.18)
                pbg.Parent = panel
                corner(pbg,16)
            end
        end)

        local title = Instance.new("TextLabel")
        title.BackgroundTransparency = 1
        title.Text = "XLU0 AVATAR CHANGER (NOT WORKING)"
        title.TextColor3 = COLORS.white
        title.Font = Enum.Font.Arcade
        title.TextSize = 19
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Position = UDim2.new(0,18,0,10)
        title.Size = UDim2.new(1,-70,0,38)
        title.ZIndex = 4
        title.Parent = panel

        local close = Instance.new("TextButton")
        close.Text = "X"
        close.Font = Enum.Font.Arcade
        close.TextSize = 11
        close.TextColor3 = COLORS.white
        close.BackgroundColor3 = Color3.fromRGB(16,16,22)
        close.Size = UDim2.fromOffset(34,30)
        close.Position = UDim2.new(1,-46,0,14)
        close.ZIndex = 5
        close.Parent = panel
        corner(close,9)
        stroke(close,COLORS.strokeSoft,1,0.45)

        local input = Instance.new("TextBox")
        input.PlaceholderText = "SEARCH ANY ROBLOX USER..."
        input.ClearTextOnFocus = false
        input.Text = ""
        input.Font = Enum.Font.Arcade
        input.TextSize = 11
        input.TextColor3 = COLORS.white
        input.PlaceholderColor3 = Color3.fromRGB(140,140,150)
        input.BackgroundColor3 = Color3.fromRGB(16,16,22)
        input.BackgroundTransparency = 0.06
        input.Position = UDim2.new(0,18,0,58)
        input.Size = UDim2.new(1,-36,0,36)
        input.ZIndex = 4
        input.Parent = panel
        corner(input,9)
        stroke(input,COLORS.strokeSoft,1,0.5)

        local sectionLabel = Instance.new("TextLabel")
        sectionLabel.BackgroundTransparency = 1
        sectionLabel.Text = "FEATURED"
        sectionLabel.TextColor3 = COLORS.white
        sectionLabel.Font = Enum.Font.Arcade
        sectionLabel.TextSize = 10
        sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        sectionLabel.Position = UDim2.new(0,18,0,98)
        sectionLabel.Size = UDim2.new(1,-36,0,20)
        sectionLabel.ZIndex = 4
        sectionLabel.Parent = panel

        local status = Instance.new("TextLabel")
        status.BackgroundTransparency = 1
        status.Text = "LOADING FEATURED..."
        status.TextColor3 = Color3.fromRGB(180,180,190)
        status.Font = Enum.Font.Arcade
        status.TextSize = 9
        status.TextXAlignment = Enum.TextXAlignment.Left
        status.Position = UDim2.new(0,18,1,-28)
        status.Size = UDim2.new(1,-36,0,20)
        status.ZIndex = 4
        status.Parent = panel
        status.Size = UDim2.new(1,-190,0,20)

        -- REMOVE AVATAR - sadece Avatar Changer MORE menüsü
        local removeAvatarBtn = Instance.new("TextButton")
        removeAvatarBtn.Name = "RemoveAvatarButton"
        removeAvatarBtn.Text = "REMOVE AVATAR"
        removeAvatarBtn.Font = Enum.Font.Arcade
        removeAvatarBtn.TextSize = 9
        removeAvatarBtn.TextColor3 = Color3.fromRGB(255,255,255)
        removeAvatarBtn.BackgroundColor3 = Color3.fromRGB(170,35,35)
        removeAvatarBtn.BackgroundTransparency = 0
        removeAvatarBtn.BorderSizePixel = 0
        removeAvatarBtn.Position = UDim2.new(1,-168,1,-34)
        removeAvatarBtn.Size = UDim2.new(0,150,0,26)
        removeAvatarBtn.ZIndex = 6
        removeAvatarBtn.Parent = panel
        corner(removeAvatarBtn,8)
        stroke(removeAvatarBtn,Color3.fromRGB(235,75,75),1,0.15)

        removeAvatarBtn.MouseButton1Click:Connect(function()
            if _G.Xlu0AvatarChangerRemove then
                pcall(_G.Xlu0AvatarChangerRemove)
                status.Text = "AVATAR REMOVED"
            else
                status.Text = "REMOVE FAILED"
            end
        end)

        local scroll = Instance.new("ScrollingFrame")
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.Position = UDim2.new(0,12,0,122)
        scroll.Size = UDim2.new(1,-24,1,-160)
        scroll.ScrollBarThickness = 4
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.CanvasSize = UDim2.new(0,0,0,0)
        scroll.ZIndex = 4
        scroll.Parent = panel

        local grid = Instance.new("UIGridLayout")
        grid.CellSize = UDim2.fromOffset(132,160)
        grid.CellPadding = UDim2.fromOffset(10,10)
        grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
        grid.SortOrder = Enum.SortOrder.LayoutOrder
        grid.Parent = scroll

        local famousSeeds = {
            "Roblox","Builderman","KreekCraft","Flamingo","ItsFunneh",
            "DenisDaily","RussoTalks","MeganPlays","LeahAshe","Thinknoodles",
            "SharkBlox","InquisitorMaster","GamingWithKev","Sketch","Bandites",
            "TanqR","DVPlays","NightFoxx","iamSanna","Temprist",
            "MiniToon","asimo3089","badcc","NewFissy","Coeptus",
            "Wolfpaq","BelowNatural","callmehbob"
        }

        local featuredUsers = {}
        local searchResults = {}
        local searchToken = 0

        local function clearCards()
            for _, child in ipairs(scroll:GetChildren()) do
                if child:IsA("GuiButton") then child:Destroy() end
            end
        end

        local function addCard(userData, order)
            local card = Instance.new("TextButton")
            card.Text = ""
            card.AutoButtonColor = false
            card.BackgroundColor3 = Color3.fromRGB(16,16,22)
            card.BackgroundTransparency = 0.07
            card.BorderSizePixel = 0
            card.LayoutOrder = order
            card.ZIndex = 5
            card.Parent = scroll
            corner(card,11)
            stroke(card,COLORS.strokeSoft,1,0.55)

            local thumb = Instance.new("ImageLabel")
            thumb.BackgroundColor3 = Color3.fromRGB(10,10,14)
            thumb.BackgroundTransparency = 0.08
            thumb.BorderSizePixel = 0
            thumb.Position = UDim2.new(0,8,0,8)
            thumb.Size = UDim2.new(1,-16,0,108)
            thumb.ScaleType = Enum.ScaleType.Crop
            thumb.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(userData.id) .. "&w=150&h=150"
            thumb.ZIndex = 6
            thumb.Parent = card
            corner(thumb,9)

            if userData.hasVerifiedBadge == true then
                local verified = Instance.new("TextLabel")
                verified.BackgroundColor3 = Color3.fromRGB(255,255,255)
                verified.BackgroundTransparency = 0.08
                verified.Text = "✓"
                verified.TextColor3 = Color3.fromRGB(10,10,15)
                verified.Font = Enum.Font.GothamBold
                verified.TextSize = 12
                verified.Size = UDim2.fromOffset(20,20)
                verified.Position = UDim2.new(1,-26,0,14)
                verified.ZIndex = 8
                verified.Parent = card
                corner(verified,999)
            end

            local display = Instance.new("TextLabel")
            display.BackgroundTransparency = 1
            display.Text = tostring(userData.displayName or userData.name)
            display.TextColor3 = COLORS.white
            display.Font = Enum.Font.Arcade
            display.TextSize = 9
            display.TextWrapped = true
            display.TextXAlignment = Enum.TextXAlignment.Center
            display.Position = UDim2.new(0,5,0,119)
            display.Size = UDim2.new(1,-10,0,17)
            display.ZIndex = 6
            display.Parent = card

            local username = Instance.new("TextLabel")
            username.BackgroundTransparency = 1
            username.Text = "@" .. tostring(userData.name)
            username.TextColor3 = Color3.fromRGB(160,160,175)
            username.Font = Enum.Font.Gotham
            username.TextSize = 9
            username.TextXAlignment = Enum.TextXAlignment.Center
            username.Position = UDim2.new(0,5,0,137)
            username.Size = UDim2.new(1,-10,0,15)
            username.ZIndex = 6
            username.Parent = card

            card.MouseButton1Click:Connect(function()
                spawnAvatar(userData.id, userData.name, function(v)
                    status.Text = tostring(v)
                end)
                task.defer(function()
                    if sg and sg.Parent then
                        sg:Destroy()
                    end
                end)
            end)
        end

        local function renderFeatured()
            clearCards()
            sectionLabel.Text = "FEATURED"
            local count = 0
            for _, u in ipairs(featuredUsers) do
                count += 1
                addCard(u, count)
            end
            status.Text = tostring(count) .. " FEATURED AVATARS"
        end

        local function renderSearch()
            clearCards()
            sectionLabel.Text = "SEARCH RESULTS"
            local count = 0
            for _, u in ipairs(searchResults) do
                count += 1
                addCard(u, count)
            end
            status.Text = tostring(count) .. " RESULTS"
        end

        local function searchAnyUser(query)
            query = tostring(query or ""):gsub("^%s+",""):gsub("%s+$","")
            searchToken += 1
            local myToken = searchToken

            if query == "" then
                searchResults = {}
                renderFeatured()
                return
            end

            status.Text = "SEARCHING..."
            sectionLabel.Text = "SEARCH RESULTS"

            task.spawn(function()
                local results = {}

                -- Fast username exact lookup first
                local okId, uid = pcall(function()
                    return Players:GetUserIdFromNameAsync(query)
                end)

                if myToken ~= searchToken then return end

                if okId and uid and uid > 0 then
                    local okInfo, body = pcall(function()
                        return game:HttpGet("https://users.roblox.com/v1/users/" .. tostring(uid))
                    end)
                    if okInfo and body and body ~= "" then
                        local okJson, data = pcall(function()
                            return HttpService:JSONDecode(body)
                        end)
                        if okJson and type(data) == "table" then
                            table.insert(results, {
                                id = tonumber(data.id) or uid,
                                name = tostring(data.name or query),
                                displayName = tostring(data.displayName or data.name or query),
                                hasVerifiedBadge = data.hasVerifiedBadge == true
                            })
                        end
                    end
                end

                -- Broader search: normal/non-famous users included
                local encoded = HttpService:UrlEncode(query)
                local okSearch, body = pcall(function()
                    return game:HttpGet(
                        "https://users.roblox.com/v1/users/search?keyword=" ..
                        encoded .. "&limit=20"
                    )
                end)

                if myToken ~= searchToken then return end

                if okSearch and body and body ~= "" then
                    local okJson, data = pcall(function()
                        return HttpService:JSONDecode(body)
                    end)
                    if okJson and type(data) == "table" and type(data.data) == "table" then
                        local seen = {}
                        for _, r in ipairs(results) do seen[r.id] = true end

                        for _, item in ipairs(data.data) do
                            local id = tonumber(item.id)
                            if id and not seen[id] then
                                seen[id] = true
                                table.insert(results, {
                                    id = id,
                                    name = tostring(item.name or id),
                                    displayName = tostring(item.displayName or item.name or id),
                                    hasVerifiedBadge = item.hasVerifiedBadge == true
                                })
                            end
                        end
                    end
                end

                if myToken ~= searchToken then return end
                searchResults = results
                renderSearch()
            end)
        end

        input:GetPropertyChangedSignal("Text"):Connect(function()
            local current = input.Text
            task.delay(0.18, function()
                if input.Text == current then
                    searchAnyUser(current)
                end
            end)
        end)

        close.MouseButton1Click:Connect(function()
            sg:Destroy()
        end)

        -- Load featured in parallel instead of one-by-one.
        task.spawn(function()
            local pending = #famousSeeds
            local seen = {}

            if pending == 0 then
                status.Text = "NO FEATURED USERS"
                return
            end

            for _, seedName in ipairs(famousSeeds) do
                task.spawn(function()
                    local okId, uid = pcall(function()
                        return Players:GetUserIdFromNameAsync(seedName)
                    end)

                    if okId and uid and uid > 0 and not seen[uid] then
                        seen[uid] = true

                        local okInfo, body = pcall(function()
                            return game:HttpGet("https://users.roblox.com/v1/users/" .. tostring(uid))
                        end)

                        if okInfo and body and body ~= "" then
                            local okJson, data = pcall(function()
                                return HttpService:JSONDecode(body)
                            end)

                            if okJson and type(data) == "table" then
                                -- FEATURED = verified OR manually curated famous account
                                table.insert(featuredUsers, {
                                    id = tonumber(data.id) or uid,
                                    name = tostring(data.name or seedName),
                                    displayName = tostring(data.displayName or data.name or seedName),
                                    hasVerifiedBadge = data.hasVerifiedBadge == true
                                })

                                table.sort(featuredUsers, function(a,b)
                                    return string.lower(a.displayName or a.name)
                                        < string.lower(b.displayName or b.name)
                                end)

                                if input.Text == "" and sg.Parent then
                                    renderFeatured()
                                end
                            end
                        end
                    end

                    pending -= 1
                    if pending <= 0 and input.Text == "" and sg.Parent then
                        renderFeatured()
                    end
                end)
            end
        end)
    end

    LP.CharacterAdded:Connect(function()
        task.wait(0.35)
        if XAC.lastUserId then
            local uid, name = XAC.lastUserId, XAC.lastUsername
            task.defer(function()
                spawnAvatar(uid,name or tostring(uid),function() end)
            end)
        end
    end)

    -- Script ilk çalıştığında kayıtlı avatar varsa otomatik yükle.
    task.defer(function()
        task.wait(0.5)
        if XAC.lastUserId and LP.Character then
            spawnAvatar(XAC.lastUserId, XAC.lastUsername or tostring(XAC.lastUserId), function() end)
        end
    end)
end

_G.Xlu0InstallAvatarChanger()
_G.Xlu0InstallAvatarChanger = nil

-- Saved avatar selection sync
if _G.Xlu0AvatarChangerState then
    _G.Xlu0AvatarChangerState.lastUserId = _G.Xlu0SavedAvatarChangerUserId
    _G.Xlu0AvatarChangerState.lastUsername = (_G.Xlu0SavedAvatarChangerUsername ~= "" and _G.Xlu0SavedAvatarChangerUsername) or nil
end

--// Avatar Changer <-> Headless / Korblox compatibility
do
    local originalApplyHeadless = _G.Xlu0ApplyHeadless
    local originalApplyKorblox = _G.Xlu0ApplyKorblox
    local originalApplyCharacterVisuals = _G.Xlu0ApplyCharacterVisuals

    if originalApplyHeadless then
        _G.Xlu0ApplyHeadless = function(char, enabled)
            originalApplyHeadless(char, enabled)

            local state = _G.Xlu0AvatarChangerState
            local overlay = state and state.model
            if overlay and overlay.Parent and overlay ~= char then
                pcall(function()
                    originalApplyHeadless(overlay, enabled)
                end)
            end
        end
    end

    if originalApplyKorblox then
        _G.Xlu0ApplyKorblox = function(char, enabled)
            originalApplyKorblox(char, enabled)

            local state = _G.Xlu0AvatarChangerState
            local overlay = state and state.model
            if overlay and overlay.Parent and overlay ~= char then
                pcall(function()
                    originalApplyKorblox(overlay, enabled)
                end)
            end
        end
    end

    if originalApplyCharacterVisuals then
        _G.Xlu0ApplyCharacterVisuals = function(char)
            originalApplyCharacterVisuals(char)

            local state = _G.Xlu0AvatarChangerState
            local overlay = state and state.model
            if overlay and overlay.Parent and overlay ~= char then
                pcall(function()
                    if originalApplyHeadless then
                        originalApplyHeadless(overlay, _G.Xlu0HeadlessEnabled == true)
                    end
                    if originalApplyKorblox then
                        originalApplyKorblox(overlay, _G.Xlu0KorbloxEnabled == true)
                    end
                end)
            end
        end
    end
end

--// ==================== END XLU0 AVATAR CHANGER MODULE ====================

function __Xlu0DuelsSetupVisualsUI()
local Utility = pages.VISUALS
local skyThemes = SKY_PRESETS_LIST or {"Off", "Night", "Aurora", "Sunset", "Galaxy", "Tech", "Sakura"}
local skyIndex = 1
for i, name in ipairs(skyThemes) do if name == skyTheme then skyIndex = i break end end
function skyThemeSelectorRow(parent, order)
local row = baseRow(parent, "Sky Theme", order)
row.Size = UDim2.new(1, -4, 0, 42)
row.ClipsDescendants = true
local label = row:FindFirstChild("Label")
if label then
label.Size = UDim2.new(0, 92, 1, 0)
label.TextSize = 11
end
local left = Instance.new("TextButton")
left.Name = "SkyLeft"
left.BackgroundColor3 = Color3.fromRGB(7, 7, 10)
left.BackgroundTransparency = 0.04
left.Text = "<"
left.TextColor3 = COLORS.white
left.TextSize = 12
left.Font = Enum.Font.Arcade
left.Size = UDim2.new(0, 42, 0, 28)
left.Position = UDim2.new(1, -186, 0.5, -14)
left.BorderSizePixel = 0
left.ZIndex = 8
left.AutoButtonColor = false
left.Parent = row
corner(left, 8)
stroke(left, COLORS.strokeSoft, 1, 0.42)
local holder = Instance.new("Frame")
holder.Name = "SkyValueHolder"
holder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
holder.BackgroundTransparency = 0.28
holder.BorderSizePixel = 0
holder.Size = UDim2.new(0, 92, 0, 28)
holder.Position = UDim2.new(1, -139, 0.5, -14)
holder.ClipsDescendants = true
holder.ZIndex = 7
holder.Parent = row
corner(holder, 8)
stroke(holder, Color3.fromRGB(235, 235, 245), 1, 0.35)
local smoky = Instance.new("ImageLabel")
smoky.Name = "SmokyBackground"
smoky.BackgroundTransparency = 1
smoky.Image = "rbxassetid://85127407374728"
smoky.ImageTransparency = 1
smoky.ScaleType = Enum.ScaleType.Crop
smoky.Size = UDim2.new(1, 0, 1, 0)
smoky.Position = UDim2.new(0, 0, 0, 0)
smoky.Visible = false
smoky.ZIndex = 7
smoky.Parent = holder
corner(smoky, 8)
skyValueLabel = Instance.new("TextLabel")
skyValueLabel.Name = "SkyValue"
skyValueLabel.BackgroundTransparency = 1
skyValueLabel.Text = skyThemes[skyIndex]
skyValueLabel.TextColor3 = COLORS.white
skyValueLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
skyValueLabel.TextStrokeTransparency = 1
skyValueLabel.TextSize = 11
skyValueLabel.Font = Enum.Font.Arcade
skyValueLabel.TextXAlignment = Enum.TextXAlignment.Center
skyValueLabel.Size = UDim2.new(1, 0, 1, 0)
skyValueLabel.ZIndex = 9
skyValueLabel.Parent = holder
local right = Instance.new("TextButton")
right.Name = "SkyRight"
right.BackgroundColor3 = Color3.fromRGB(7, 7, 10)
right.BackgroundTransparency = 0.04
right.Text = ">"
right.TextColor3 = COLORS.white
right.TextSize = 12
right.Font = Enum.Font.Arcade
right.Size = UDim2.new(0, 42, 0, 28)
right.Position = UDim2.new(1, -42, 0.5, -14)
right.BorderSizePixel = 0
right.ZIndex = 8
right.AutoButtonColor = false
right.Parent = row
corner(right, 8)
stroke(right, COLORS.strokeSoft, 1, 0.42)
local function setSkyIndex(nextIndex)
if nextIndex < 1 then nextIndex = #skyThemes end
if nextIndex > #skyThemes then nextIndex = 1 end
skyIndex = nextIndex
skyTheme = skyThemes[skyIndex]
if applyCustomSky then applyCustomSky(skyTheme) end
if skyValueLabel then skyValueLabel.Text = skyTheme end
do end
end
left.Activated:Connect(function()
setSkyIndex(skyIndex - 1)
end)
right.Activated:Connect(function()
setSkyIndex(skyIndex + 1)
end)
return row
end
section(Utility, "CHARACTER VISUALS", -3)

_, _G.Xlu0HeadlessVisual = toggleRow(Utility, "Headless", _G.Xlu0HeadlessEnabled, -2)
_G.Xlu0HeadlessRow = Utility:FindFirstChild("Headless")
_G.Xlu0HeadlessButton = _G.Xlu0HeadlessRow and _G.Xlu0HeadlessRow:FindFirstChild("ToggleButton")
if _G.Xlu0HeadlessButton then
_G.Xlu0HeadlessButton.Activated:Connect(function()
_G.Xlu0HeadlessEnabled = not _G.Xlu0HeadlessEnabled
_G.Xlu0ApplyHeadless(LP.Character, _G.Xlu0HeadlessEnabled)
if _G.Xlu0HeadlessVisual then _G.Xlu0HeadlessVisual(_G.Xlu0HeadlessEnabled) end
do end
end)
end

_, _G.Xlu0KorbloxVisual = toggleRow(Utility, "Korblox", _G.Xlu0KorbloxEnabled, -1)
_G.Xlu0KorbloxRow = Utility:FindFirstChild("Korblox")
_G.Xlu0KorbloxButton = _G.Xlu0KorbloxRow and _G.Xlu0KorbloxRow:FindFirstChild("ToggleButton")
if _G.Xlu0KorbloxButton then
_G.Xlu0KorbloxButton.Activated:Connect(function()
_G.Xlu0KorbloxEnabled = not _G.Xlu0KorbloxEnabled
_G.Xlu0ApplyKorblox(LP.Character, _G.Xlu0KorbloxEnabled)
if _G.Xlu0KorbloxVisual then _G.Xlu0KorbloxVisual(_G.Xlu0KorbloxEnabled) end
do end
end)
end

task.defer(function()
task.wait(0.8)
_G.Xlu0ApplyCharacterVisuals(LP.Character)
if _G.Xlu0HeadlessVisual then _G.Xlu0HeadlessVisual(_G.Xlu0HeadlessEnabled) end
if _G.Xlu0KorbloxVisual then _G.Xlu0KorbloxVisual(_G.Xlu0KorbloxEnabled) end
end)


do
    local avatarRow = baseRow(Utility, "Xlu0 Avatar Changer (Not Working)", 0)
    avatarRow.Size = UDim2.new(1, -4, 0, 42)
    local avatarLabel = avatarRow:FindFirstChild("Label")
    if avatarLabel then
        avatarLabel.Text = "Xlu0 Avatar Changer (Not Working)"
        avatarLabel.Size = UDim2.new(1, -82, 1, 0)
        avatarLabel.TextSize = 10
    end

    local avatarMore = Instance.new("TextButton")
    avatarMore.Name = "Xlu0AvatarChangerMore"
    avatarMore.BackgroundColor3 = Color3.fromRGB(8,8,12)
    avatarMore.BackgroundTransparency = 0.18
    avatarMore.Text = "MORE"
    avatarMore.TextColor3 = COLORS.white
    avatarMore.TextSize = 9
    avatarMore.Font = Enum.Font.Arcade
    avatarMore.Size = UDim2.new(0,62,0,28)
    avatarMore.Position = UDim2.new(1,-70,0.5,-14)
    avatarMore.BorderSizePixel = 0
    avatarMore.ZIndex = 8
    avatarMore.Parent = avatarRow
    corner(avatarMore,8)
    stroke(avatarMore,COLORS.strokeSoft,1,0.45)

    avatarMore.MouseButton1Click:Connect(function()
        if _G.Xlu0OpenAvatarChanger then
            _G.Xlu0OpenAvatarChanger()
        end
    end)
end

section(Utility, "ESP", 1)
do
local espRow, setESPVisual = toggleRow(Utility, "ESP", espEnabled, 2)
setPlayerESPVisual = setESPVisual
_aceBtn = espRow and espRow:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
espEnabled = not espEnabled
if espEnabled then
if startPlayerESP then startPlayerESP() end
if BoxedESPOptions then BoxedESPOptions.box = false end
else
if stopPlayerESP then stopPlayerESP() end
if BoxedESPOptions then BoxedESPOptions.box = false end
end
if refreshBoxedESP then refreshBoxedESP() end
if setESPVisual then setESPVisual(espEnabled) end
do end
end)
end
end
section(Utility, "SKY THEME", 5)
skyThemeSelectorRow(Utility, 6)
section(Utility, "PERFORMANCE", 7)
do
local row, setVisual = toggleRow(Utility, "Stretch Rez", fpsBoostEnabled, 8)
setFPSBoostVisual = setVisual
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
fpsBoostEnabled = not fpsBoostEnabled
if fpsBoostEnabled then enableStretchRez() else disableStretchRez() end
if setVisual then setVisual(fpsBoostEnabled) end
do end
end)
end
end

do
local presetRow = baseRow(Utility, "Stretch Level", 9)
presetRow.Size = UDim2.new(1,-4,0,42)

local lbl = presetRow:FindFirstChild("Label")
if lbl then
    lbl.Text = "Stretch Level"
    lbl.Size = UDim2.new(0.42,0,1,0)
end

local values = {"Light","Medium","Strong","Extreme"}
local idx = table.find(values, _G.Xlu0StretchPreset or "Medium") or 2

local left = Instance.new("TextButton")
left.Text = "<"
left.Font = Enum.Font.Arcade
left.TextSize = 11
left.TextColor3 = COLORS.white
left.BackgroundColor3 = Color3.fromRGB(16,16,22)
left.Size = UDim2.new(0,28,0,26)
left.Position = UDim2.new(1,-170,0.5,-13)
left.BorderSizePixel = 0
left.Parent = presetRow
corner(left,7)
stroke(left,COLORS.strokeSoft,1,0.45)

local value = Instance.new("TextLabel")
value.BackgroundTransparency = 1
value.Text = values[idx]
value.TextColor3 = COLORS.white
value.Font = Enum.Font.Arcade
value.TextSize = 9
value.TextXAlignment = Enum.TextXAlignment.Center
value.Size = UDim2.new(0,92,0,26)
value.Position = UDim2.new(1,-138,0.5,-13)
value.Parent = presetRow

local right = Instance.new("TextButton")
right.Text = ">"
right.Font = Enum.Font.Arcade
right.TextSize = 11
right.TextColor3 = COLORS.white
right.BackgroundColor3 = Color3.fromRGB(16,16,22)
right.Size = UDim2.new(0,28,0,26)
right.Position = UDim2.new(1,-42,0.5,-13)
right.BorderSizePixel = 0
right.Parent = presetRow
corner(right,7)
stroke(right,COLORS.strokeSoft,1,0.45)

local function refreshStretchPreset()
    value.Text = values[idx]
    _G.Xlu0SetStretchPreset(values[idx])
    if saveXlu0Config then pcall(saveXlu0Config) end
end

left.MouseButton1Click:Connect(function()
    idx = idx - 1
    if idx < 1 then idx = #values end
    refreshStretchPreset()
end)

right.MouseButton1Click:Connect(function()
    idx = idx + 1
    if idx > #values then idx = 1 end
    refreshStretchPreset()
end)
end

do
local row, setVisual = toggleRow(Utility, "Anti Lag", antiLagVisualEnabled, 10)
setAntiLagVisual = setVisual
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
if antiLagVisualEnabled then disableAntiLag() else enableAntiLag() end
if setVisual then setVisual(antiLagVisualEnabled) end
do end
end)
end
end
do
local row, setVisual = _G.Xlu0ActionToggleRow(Utility, "Nuke Optimiser", nukeOptimiserEnabled, 11)
setNukeOptimiserVisual = setVisual
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
if nukeOptimiserEnabled then disableNukeOptimizer() else enableNukeOptimizer() end
if setVisual then setVisual(nukeOptimiserEnabled) end
do end
end)
end
end
section(Utility, "CAMERA", 12)
do
local row, setVisual = toggleRow(Utility, "FOV", fovEnabled, 13)
setFOVVisual = setVisual
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
if fovEnabled then disableCustomFov() else enableCustomFov() end
if setVisual then setVisual(fovEnabled) end
do end
end)
end
end
do
local _, box = textboxRow(Utility, "FOV Value", tostring(fovValue), 14)
box.FocusLost:Connect(function()
local v = tonumber(box.Text)
if v and v >= 30 and v <= 120 then
fovValue = v
if fovEnabled and workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = fovValue end
end
box.Text = tostring(fovValue)
do end
end)
end
do
local row, setVisual = toggleRow(Utility, "No Cam Collision", noCamCollisionEnabled, 15)
setNoCamCollisionVisual = setVisual
_aceBtn = row and row:FindFirstChild("ToggleButton")
if _aceBtn then
_aceBtn.Activated:Connect(function()
if noCamCollisionEnabled then disableNoCamCollision() else enableNoCamCollision() end
if setVisual then setVisual(noCamCollisionEnabled) end
do end
end)
end
end
end
task.wait()
__Xlu0DuelsSetupVisualsUI()

--// Xlu0 VYNX-style font switcher (isolated from main UI builder)
function _G.Xlu0RestoreFonts()
    if _G.Xlu0FontAddedConn then
        pcall(function() _G.Xlu0FontAddedConn:Disconnect() end)
        _G.Xlu0FontAddedConn = nil
    end
    if _G.Xlu0FontBackup then
        for obj, oldFont in pairs(_G.Xlu0FontBackup) do
            pcall(function()
                if obj and obj.Parent then obj.Font = oldFont end
            end)
        end
    end
    _G.Xlu0FontBackup = {}
end

function _G.Xlu0FontEnum(name)
    if name == "Coding Font" then return Enum.Font.Code end
    if name == "Summer" then return Enum.Font.Cartoon end
    if name == "Beachy" then return Enum.Font.GothamBold end
    if name == "Scary" then return Enum.Font.SciFi end
    if name == "Bangers" then return Enum.Font.Bangers end
    return nil
end

function _G.Xlu0ApplyFontToObject(obj)
    if not obj then return end
    if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return end
    if not _G.Xlu0FontBackup then _G.Xlu0FontBackup = {} end
    if _G.Xlu0FontBackup[obj] == nil then
        pcall(function() _G.Xlu0FontBackup[obj] = obj.Font end)
    end
    local f = _G.Xlu0FontEnum(_G.Xlu0CustomFontSelected or "None")
    if f then pcall(function() obj.Font = f end) end
end

function _G.Xlu0ApplyCustomFont(name)
    _G.Xlu0RestoreFonts()
    _G.Xlu0CustomFontSelected = name or "None"
    customFontVisualEnabled = _G.Xlu0CustomFontSelected ~= "None"

    if customFontVisualEnabled then
        for _, obj in ipairs(PlayerGui:GetDescendants()) do
            _G.Xlu0ApplyFontToObject(obj)
        end
        _G.Xlu0FontAddedConn = PlayerGui.DescendantAdded:Connect(function(obj)
            if (_G.Xlu0CustomFontSelected or "None") ~= "None" then
                _G.Xlu0ApplyFontToObject(obj)
            end
        end)
    end

    pcall(function()
        if saveXlu0Config then saveXlu0Config() end
    end)
end

function _G.Xlu0InstallFontRow()
    local targetPage = MenuCustomize or pages.MENU
    if not targetPage or not targetPage.Parent then return end
    local old = targetPage:FindFirstChild("Custom Font")
    if old then old:Destroy() end

    local row = Instance.new("Frame")
    row.Name = "Custom Font"
    row.BackgroundColor3 = COLORS.row
    row.BackgroundTransparency = 0.22
    row.Size = UDim2.new(1, -4, 0, 138)
    row.BorderSizePixel = 0
    row.LayoutOrder = 2
    row.ZIndex = 4
    row.Parent = targetPage
    corner(row,10)
    stroke(row,COLORS.strokeSoft,1.15,0.32)

    local title = Instance.new("TextLabel")
    title.Name = "Label"
    title.BackgroundTransparency = 1
    title.Text = "Custom Font"
    title.TextColor3 = COLORS.white
    title.TextSize = 11
    title.Font = Enum.Font.Arcade
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Position = UDim2.new(0,12,0,7)
    title.Size = UDim2.new(1,-24,0,20)
    title.ZIndex = 5
    title.Parent = row

    local names = {"None","Coding Font","Summer","Beachy","Scary","Bangers"}

    local function getPreviewFont(name)
        if name == "Coding Font" then return Enum.Font.Code end
        if name == "Summer" then return Enum.Font.Cartoon end
        if name == "Beachy" then return Enum.Font.GothamBold end
        if name == "Scary" then return Enum.Font.SciFi end
        if name == "Bangers" then return Enum.Font.Bangers end
        return Enum.Font.Arcade
    end

    local buttons = {}

    local function refreshSelected()
        for name, btn in pairs(buttons) do
            local selected = name == (_G.Xlu0CustomFontSelected or "None")
            btn.BackgroundTransparency = selected and 0.03 or 0.18
            local st = btn:FindFirstChildOfClass("UIStroke")
            if st then
                st.Transparency = selected and 0.05 or 0.5
                st.Thickness = selected and 1.4 or 1
            end
        end
    end

    for i, name in ipairs(names) do
        local col = (i - 1) % 3
        local rowIndex = math.floor((i - 1) / 3)

        local btn = Instance.new("TextButton")
        btn.Name = "Font_" .. name
        btn.BackgroundColor3 = Color3.fromRGB(10,10,14)
        btn.BackgroundTransparency = 0.18
        btn.BorderSizePixel = 0
        btn.Text = "Abc"
        btn.TextColor3 = COLORS.white
        btn.TextSize = 18
        btn.Font = getPreviewFont(name)
        btn.AutoButtonColor = false
        btn.Size = UDim2.new(0, 92, 0, 42)
        btn.Position = UDim2.new(0, 12 + col * 98, 0, 34 + rowIndex * 48)
        btn.ZIndex = 6
        btn.Parent = row
        corner(btn,8)
        stroke(btn,COLORS.strokeSoft,1,0.5)

        local nameLabel = Instance.new("TextLabel")
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = name
        nameLabel.TextColor3 = COLORS.white
        nameLabel.TextTransparency = 0.22
        nameLabel.TextSize = 8
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.Size = UDim2.new(1,0,0,12)
        nameLabel.Position = UDim2.new(0,0,1,-13)
        nameLabel.ZIndex = 7
        nameLabel.Parent = btn

        buttons[name] = btn

        btn.MouseButton1Click:Connect(function()
            pcall(function()
                _G.Xlu0ApplyCustomFont(name)
            end)
            refreshSelected()
        end)
    end

    refreshSelected()
end

Settings = pages.SETTINGS
-- Cihaz tipi otomatik belirlenir; eski kayıtlı GUI ölçeği cihaz ayarını bozmaz.
aceGuiScaleValue = Xlu0AutoMobile and 0.67 or 1.00
aceGuiScaleValue = math.clamp(aceGuiScaleValue, 0.50, 1.50)
_G.Xlu0GuiScaleValue = aceGuiScaleValue
aceProgressBarScaleValue = Xlu0AutoMobile and 0.83 or 1.00
aceMainScale = Main:FindFirstChild("Xlu0MainScale") or Instance.new("UIScale")
aceMainScale.Name = "Xlu0MainScale"
aceMainScale.Scale = aceGuiScaleValue
aceMainScale.Parent = Main
local function applyXlu0ProgressBarScale()
local sg = PlayerGui:FindFirstChild("StealBarGui")
local bar = sg and sg:FindFirstChild("StealBar")
if not bar then return end
local sc = bar:FindFirstChild("Xlu0ProgressBarScale") or Instance.new("UIScale")
sc.Name = "Xlu0ProgressBarScale"
sc.Scale = aceProgressBarScaleValue
sc.Parent = bar
end
_G.__Xlu0DuelsSetupSettingsUI = function()
section(MenuCustomize, "MENU CUSTOMIZE", 1)
local bgRow = Instance.new("Frame")
bgRow.Name = "Background Image Picker"
bgRow.BackgroundColor3 = COLORS.row
bgRow.BackgroundTransparency = 0.3
bgRow.Size = UDim2.new(1, -4, 0, compactMobile and 136 or 154)
bgRow.BorderSizePixel = 0
bgRow.LayoutOrder = 2
bgRow.ZIndex = 4
bgRow.Parent = MenuCustomize
corner(bgRow, 9)
stroke(bgRow, COLORS.strokeSoft, 1.15, 0.38)
local bgButtons = {}
function updateBackgroundButtons()
for index, button in pairs(bgButtons) do
local selected = index == currentBackground
button.BackgroundTransparency = selected and 0.12 or 0.42
local st = button:FindFirstChildOfClass("UIStroke")
if st then
st.Color = selected and Color3.fromRGB(245, 245, 255) or COLORS.strokeSoft
st.Transparency = selected and 0.12 or 0.55
st.Thickness = selected and 1.15 or 1
end
end
end
function makeNoneButton(index, x, y)
local btn = Instance.new("TextButton")
btn.Name = "None"
btn.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
btn.BackgroundTransparency = 0.12
btn.BorderSizePixel = 0
btn.Text = "None"
btn.TextColor3 = COLORS.white
btn.TextSize = 11
btn.Font = Enum.Font.Arcade
btn.AutoButtonColor = false
btn.Size = UDim2.new(0, 52, 0, 40)
btn.Position = UDim2.new(0, x, 0, y)
btn.ZIndex = 6
btn.ClipsDescendants = true
btn.Parent = bgRow
corner(btn, 8)
stroke(btn, Color3.fromRGB(245, 245, 255), 1.15, 0.12)
bgButtons[index] = btn
btn.MouseButton1Click:Connect(function()
applyBackground(index)
updateBackgroundButtons()
end)
end
function makeImageButton(index, x, y)
local holder = Instance.new("Frame")
holder.Name = "Image " .. tostring(index)
holder.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
holder.BackgroundTransparency = 0.35
holder.BorderSizePixel = 0
holder.Size = UDim2.new(0, compactMobile and 48 or 58, 0, compactMobile and 32 or 40)
holder.Position = UDim2.new(0, x, 0, y)
holder.ZIndex = 6
holder.ClipsDescendants = true
holder.Parent = bgRow
corner(holder, 8)
stroke(holder, COLORS.strokeSoft, 1, 0.45)
local img = Instance.new("ImageLabel")
img.Name = "Preview"
img.BackgroundTransparency = 1
img.Image = "rbxassetid://" .. BackgroundIDs[index]
img.ScaleType = Enum.ScaleType.Crop
img.Size = UDim2.new(1, 0, 1, 0)
img.Position = UDim2.new(0, 0, 0, 0)
img.ZIndex = 6
img.Parent = holder
corner(img, 8)
local click = Instance.new("TextButton")
click.Name = "Click"
click.BackgroundTransparency = 1
click.Text = ""
click.AutoButtonColor = false
click.Size = UDim2.new(1, 0, 1, 0)
click.Position = UDim2.new(0, 0, 0, 0)
click.ZIndex = 7
click.Parent = holder
bgButtons[index] = holder
click.MouseButton1Click:Connect(function()
applyBackground(index)
updateBackgroundButtons()
end)
end
function stepperRow(parent, labelText, defaultValue, order, callback, minValue, maxValue)
local row = Instance.new("Frame")
row.Name = labelText
row.BackgroundColor3 = COLORS.row
row.BackgroundTransparency = 0.22
row.Size = UDim2.new(1, -4, 0, 42)
row.BorderSizePixel = 0
row.LayoutOrder = order
row.ZIndex = 4
row.Parent = parent
corner(row, 10)
stroke(row, COLORS.strokeSoft, 1.15, 0.32)
local label = Instance.new("TextLabel")
label.Name = "Label"
label.BackgroundTransparency = 1
label.Text = labelText
label.TextColor3 = Color3.fromRGB(245, 245, 255)
label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
label.TextStrokeTransparency = 1
label.TextSize = 11
label.Font = Enum.Font.Arcade
label.TextXAlignment = Enum.TextXAlignment.Left
label.Position = UDim2.new(0, 12, 0, 0)
label.Size = UDim2.new(1, -155, 1, 0)
label.ZIndex = 5
label.Parent = row
local value = defaultValue
local minus = Instance.new("TextButton")
minus.Name = "Minus"
minus.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
minus.BackgroundTransparency = 0.1
minus.BorderSizePixel = 0
minus.Text = "-"
minus.TextColor3 = Color3.fromRGB(245, 245, 255)
minus.TextSize = 14
minus.Font = Enum.Font.Arcade
minus.AutoButtonColor = false
minus.Size = UDim2.new(0, 28, 0, 26)
minus.Position = UDim2.new(1, -118, 0.5, -13)
minus.ZIndex = 6
minus.Parent = row
corner(minus, 7)
stroke(minus, COLORS.strokeSoft, 1, 0.5)
local valueBox = Instance.new("TextLabel")
valueBox.Name = "Value"
valueBox.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
valueBox.BackgroundTransparency = 0.05
valueBox.BorderSizePixel = 0
valueBox.Text = string.format("%.2f", value)
valueBox.TextColor3 = Color3.fromRGB(245, 245, 255)
valueBox.TextSize = 13
valueBox.Font = Enum.Font.Arcade
valueBox.TextXAlignment = Enum.TextXAlignment.Center
valueBox.Size = UDim2.new(0, 48, 0, 26)
valueBox.Position = UDim2.new(1, -84, 0.5, -13)
valueBox.ZIndex = 6
valueBox.Parent = row
corner(valueBox, 7)
stroke(valueBox, COLORS.strokeSoft, 1, 0.5)
local plus = Instance.new("TextButton")
plus.Name = "Plus"
plus.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
plus.BackgroundTransparency = 0.1
plus.BorderSizePixel = 0
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(245, 245, 255)
plus.TextSize = 14
plus.Font = Enum.Font.Arcade
plus.AutoButtonColor = false
plus.Size = UDim2.new(0, 28, 0, 26)
plus.Position = UDim2.new(1, -30, 0.5, -13)
plus.ZIndex = 6
plus.Parent = row
corner(plus, 7)
stroke(plus, COLORS.strokeSoft, 1, 0.5)
local function setValue(nextValue)
value = math.clamp(math.floor((nextValue * 100) + 0.5) / 100, minValue or 0.50, maxValue or 1.50)
valueBox.Text = string.format("%.2f", value)
if callback then callback(value) end
end
minus.MouseButton1Click:Connect(function()
setValue(value - 0.05)
end)
plus.MouseButton1Click:Connect(function()
setValue(value + 0.05)
end)
return row
end
makeNoneButton(0, 8, 8)
for index = 1, #BackgroundIDs do
local slot = index
local column = slot % 5
local rowIndex = math.floor(slot / 5)
makeImageButton(index, 8 + (column * 61), 8 + (rowIndex * 48))
end
updateBackgroundButtons()

-- ADAPT COLOR PICKER
do
local colorRow = Instance.new("Frame")
colorRow.Name = "ColorThemePicker"
colorRow.BackgroundColor3 = COLORS.row
colorRow.BackgroundTransparency = 0.3
colorRow.BorderSizePixel = 0
colorRow.Size = UDim2.new(1, -4, 0, 34)
colorRow.LayoutOrder = 3
colorRow.ZIndex = 4
colorRow.Parent = MenuCustomize
corner(colorRow, 9)
stroke(colorRow, COLORS.strokeSoft, 1.15, 0.38)

local colorOrder = {"PURPLE","BLUE","RED","PINK","YELLOW","GREY","WHITE","FOREST"}
local activeButton

local function applyThemeColor()
local tint = _G.Xlu0ThemeColors[_G.Xlu0ThemeName] or _G.Xlu0ThemeColors.WHITE
BgImage.ImageColor3 = tint
if TitleSweepText then TitleSweepText.TextColor3 = tint end
if _G.Xlu0IntroTitleSweep and _G.Xlu0IntroTitleSweep.Parent then
_G.Xlu0IntroTitleSweep.TextColor3 = tint
end

THEME_ACCENT = tint
THEME_ACCENT_DIM = Color3.new(tint.R * 0.62, tint.G * 0.62, tint.B * 0.62)

if PlayerESP and PlayerESP.playerData then
for _, data in pairs(PlayerESP.playerData) do
if data.highlight then
data.highlight.FillColor = tint
data.highlight.OutlineColor = tint
end
if data.billboard then
for _, obj in ipairs(data.billboard:GetDescendants()) do
if obj:IsA("TextLabel") then
obj.TextColor3 = tint
end
end
end
end
end

if BoxedESPData then
for _, data in pairs(BoxedESPData) do
if data.box then data.box.Color = tint end
if data.tracer then data.tracer.Color = tint end
end
end

if _G.Xlu0ApplyMobileButtonImage then
pcall(_G.Xlu0ApplyMobileButtonImage)
end

if _G.Xlu0ApplyStealUIImage then
pcall(_G.Xlu0ApplyStealUIImage)
end

do end
end

for i, colorName in ipairs(colorOrder) do
local btn = Instance.new("TextButton")
btn.Name = colorName
btn.Size = UDim2.new(0, 30, 0, 14)
btn.Position = UDim2.new(0, 8 + ((i - 1) * 36), 0.5, -7)
btn.BackgroundColor3 = _G.Xlu0ThemeColors[colorName]
btn.BorderSizePixel = 0
btn.Text = ""
btn.AutoButtonColor = false
btn.ZIndex = 6
btn.Parent = colorRow
corner(btn, 4)

local border = stroke(btn, COLORS.white, 1, 0.5)
if colorName == _G.Xlu0ThemeName then
activeButton = btn
border.Transparency = 0
border.Thickness = 2
end

btn.MouseButton1Click:Connect(function()
if activeButton then
local oldBorder = activeButton:FindFirstChildOfClass("UIStroke")
if oldBorder then
oldBorder.Transparency = 0.5
oldBorder.Thickness = 1
end
end

activeButton = btn
_G.Xlu0ThemeName = colorName

local newBorder = btn:FindFirstChildOfClass("UIStroke")
if newBorder then
newBorder.Transparency = 0
newBorder.Thickness = 2
end

applyThemeColor()
end)
end
end

stepperRow(Settings, "GUI Scale", aceGuiScaleValue, 6, function(v)
aceGuiScaleValue = v
aceMainScale.Scale = v
do end
end)
section(MenuCustomize, "STEAL UI", 20)
stepperRow(MenuCustomize, "Progress Bar Size", aceProgressBarScaleValue, 7, function(v)
aceProgressBarScaleValue = v
applyXlu0ProgressBarScale()
do end
end)
speedKeybindRow(Settings, "Toggle UI", "ToggleUI", 8)
section(Settings, "MOBILE BUTTONS", 4)
do
local row, setVisual = _G.Xlu0ActionToggleRow(Settings, "Lock GUI", _G.Xlu0GuiLocked == true, 9)
setLockGuiVisual = setVisual
local btn = row and row:FindFirstChild("ToggleButton")
if btn then
btn.Activated:Connect(function()
_G.Xlu0GuiLocked = not (_G.Xlu0GuiLocked == true)
if setVisual then setVisual(_G.Xlu0GuiLocked == true) end
if Xlu0UpdateGuiLockVisual then Xlu0UpdateGuiLockVisual() end
do end
end)
end
end
do
local row, setVisual = _G.Xlu0ActionToggleRow(Settings, "Hide Mobile Buttons", _G.Xlu0HideMobileButtons == true, 10)
setHideMobileButtonsVisual = setVisual
local btn = row and row:FindFirstChild("ToggleButton")
if btn then
btn.Activated:Connect(function()
_G.Xlu0HideMobileButtons = not (_G.Xlu0HideMobileButtons == true)
if setVisual then setVisual(_G.Xlu0HideMobileButtons == true) end
if _G.Xlu0ApplyMobileButtonsHidden then _G.Xlu0ApplyMobileButtonsHidden() end
do end
end)
end
end
stepperRow(Settings, "Mobile Buttons Size", tonumber(_G.Xlu0MobileButtonScale) or 1.00, 11, function(v)
_G.Xlu0MobileButtonScale = math.clamp(tonumber(v) or 0.35, 0.30, 1.35)
if _G.Xlu0ApplyMobileButtonSize then _G.Xlu0ApplyMobileButtonSize() end
do end
end, 0.30, 1.35)
do
local row = baseRow(Settings, "Mobile Button Shape", 12)
local shapeButton = Instance.new("TextButton")
shapeButton.Name = "MobileButtonShapeSelector"
shapeButton.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
shapeButton.BackgroundTransparency = 0.05
shapeButton.BorderSizePixel = 0
shapeButton.TextColor3 = Color3.fromRGB(245, 245, 255)
shapeButton.TextSize = 10
shapeButton.Font = Enum.Font.Arcade
shapeButton.AutoButtonColor = false
shapeButton.Size = UDim2.new(0, 112, 0, 27)
shapeButton.Position = UDim2.new(1, -122, 0.5, -13)
shapeButton.ZIndex = 7
shapeButton.Parent = row
corner(shapeButton, 7)
stroke(shapeButton, COLORS.strokeSoft, 1, 0.45)
local shapeOrder = {"CIRCLE", "ROUNDED", "SQUARE"}
local shapeDisplay = {CIRCLE = "CIRCLE", ROUNDED = "ROUNDED", SQUARE = "SQUARE"}
local function refreshShapeText()
shapeButton.Text = shapeDisplay[_G.Xlu0MobileButtonShape] or "ROUNDED"
end
shapeButton.MouseButton1Click:Connect(function()
local currentIndex = 1
for i, shape in ipairs(shapeOrder) do
if shape == _G.Xlu0MobileButtonShape then currentIndex = i break end
end
currentIndex = (currentIndex % #shapeOrder) + 1
_G.Xlu0MobileButtonShape = shapeOrder[currentIndex]
refreshShapeText()
if _G.Xlu0ApplyMobileButtonShape then _G.Xlu0ApplyMobileButtonShape() end
do end
end)
refreshShapeText()
end
do
function createHorizontalImagePicker(parent, name, layoutOrder, selectedGetter, selectedSetter)
local pickerRow = Instance.new("Frame")
pickerRow.Name = name
pickerRow.BackgroundColor3 = COLORS.row
pickerRow.BackgroundTransparency = 0.3
pickerRow.Size = UDim2.new(1, -4, 0, 58)
pickerRow.BorderSizePixel = 0
pickerRow.LayoutOrder = layoutOrder
pickerRow.ZIndex = 4
pickerRow.Parent = parent
corner(pickerRow, 9)
stroke(pickerRow, COLORS.strokeSoft, 1.15, 0.38)

local leftArrow = Instance.new("TextButton")
leftArrow.Name = "LeftArrow"
leftArrow.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
leftArrow.BackgroundTransparency = 0.12
leftArrow.BorderSizePixel = 0
leftArrow.Text = "<"
leftArrow.TextColor3 = COLORS.white
leftArrow.TextSize = 15
leftArrow.Font = Enum.Font.Arcade
leftArrow.AutoButtonColor = false
leftArrow.Size = UDim2.new(0, 24, 0, 40)
leftArrow.Position = UDim2.new(0, 5, 0.5, -20)
leftArrow.ZIndex = 8
leftArrow.Parent = pickerRow
corner(leftArrow, 7)
stroke(leftArrow, COLORS.strokeSoft, 1, 0.45)

local rightArrow = Instance.new("TextButton")
rightArrow.Name = "RightArrow"
rightArrow.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
rightArrow.BackgroundTransparency = 0.12
rightArrow.BorderSizePixel = 0
rightArrow.Text = ">"
rightArrow.TextColor3 = COLORS.white
rightArrow.TextSize = 15
rightArrow.Font = Enum.Font.Arcade
rightArrow.AutoButtonColor = false
rightArrow.Size = UDim2.new(0, 24, 0, 40)
rightArrow.Position = UDim2.new(1, -29, 0.5, -20)
rightArrow.ZIndex = 8
rightArrow.Parent = pickerRow
corner(rightArrow, 7)
stroke(rightArrow, COLORS.strokeSoft, 1, 0.45)

local scroll = Instance.new("ScrollingFrame")
scroll.Name = "HorizontalPicker"
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.Size = UDim2.new(1, -64, 1, -10)
scroll.Position = UDim2.new(0, 32, 0, 5)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.None
scroll.ScrollingDirection = Enum.ScrollingDirection.X
scroll.ScrollBarThickness = 0
scroll.ScrollBarImageTransparency = 1
scroll.Active = false
scroll.ScrollingEnabled = false
scroll.ElasticBehavior = Enum.ElasticBehavior.Never
scroll.ZIndex = 5
scroll.Parent = pickerRow

local list = Instance.new("UIListLayout")
list.FillDirection = Enum.FillDirection.Horizontal
list.HorizontalAlignment = Enum.HorizontalAlignment.Left
list.VerticalAlignment = Enum.VerticalAlignment.Center
list.Padding = UDim.new(0, 5)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = scroll

local pad = Instance.new("UIPadding")
pad.PaddingLeft = UDim.new(0, 2)
pad.PaddingRight = UDim.new(0, 2)
pad.Parent = scroll

local buttons = {}
local selected = 0

local function selectedIndex()
local current = tostring(selectedGetter() or "")
local id = current:match("(%d+)")
if not id then return 0 end
for index, assetId in ipairs(BackgroundIDs) do
if tostring(assetId) == tostring(id) then return index end
end
return 0
end

local function updateButtons()
selected = selectedIndex()
for index, button in pairs(buttons) do
local on = index == selected
button.BackgroundTransparency = on and 0.12 or 0.42
local st = button:FindFirstChildOfClass("UIStroke")
if st then
st.Color = on and Color3.fromRGB(245, 245, 255) or COLORS.strokeSoft
st.Transparency = on and 0.12 or 0.55
st.Thickness = on and 1.15 or 1
end
end
end

local function centerSelected()
task.defer(function()
local target = buttons[selected]
if not target then return end
local maxX = math.max(0, list.AbsoluteContentSize.X - scroll.AbsoluteWindowSize.X + 4)
local targetX = math.clamp(target.AbsolutePosition.X - scroll.AbsolutePosition.X + scroll.CanvasPosition.X - 4, 0, maxX)
TweenService:Create(scroll, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
CanvasPosition = Vector2.new(targetX, 0)
}):Play()
end)
end

local function choose(index)
selectedSetter(index == 0 and "" or ("rbxassetid://" .. tostring(BackgroundIDs[index])))
updateButtons()
centerSelected()
do end
end

local noneBtn = Instance.new("TextButton")
noneBtn.Name = "None"
noneBtn.LayoutOrder = 0
noneBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
noneBtn.BackgroundTransparency = 0.12
noneBtn.BorderSizePixel = 0
noneBtn.Text = "NONE"
noneBtn.TextColor3 = COLORS.white
noneBtn.TextSize = 10
noneBtn.Font = Enum.Font.Arcade
noneBtn.AutoButtonColor = false
noneBtn.Size = UDim2.new(0, 52, 0, 40)
noneBtn.ZIndex = 6
noneBtn.ClipsDescendants = true
noneBtn.Parent = scroll
corner(noneBtn, 8)
stroke(noneBtn, Color3.fromRGB(245, 245, 255), 1.15, 0.12)
buttons[0] = noneBtn
noneBtn.MouseButton1Click:Connect(function() choose(0) end)

for index = 1, #BackgroundIDs do
local holder = Instance.new("Frame")
holder.Name = "Image " .. tostring(index)
holder.LayoutOrder = index
holder.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
holder.BackgroundTransparency = 0.35
holder.BorderSizePixel = 0
holder.Size = UDim2.new(0, 58, 0, 40)
holder.ZIndex = 6
holder.ClipsDescendants = true
holder.Parent = scroll
corner(holder, 8)
stroke(holder, COLORS.strokeSoft, 1, 0.45)

local img = Instance.new("ImageLabel")
img.Name = "Preview"
img.BackgroundTransparency = 1
img.Image = "rbxassetid://" .. BackgroundIDs[index]
img.ScaleType = Enum.ScaleType.Crop
img.Size = UDim2.new(1, 0, 1, 0)
img.ZIndex = 6
img.Parent = holder
corner(img, 8)

local click = Instance.new("TextButton")
click.Name = "Click"
click.BackgroundTransparency = 1
click.Text = ""
click.AutoButtonColor = false
click.Size = UDim2.new(1, 0, 1, 0)
click.ZIndex = 7
click.Parent = holder
buttons[index] = holder
click.MouseButton1Click:Connect(function() choose(index) end)
end

local function step(direction)
local nextIndex = selected + direction
if nextIndex < 0 then nextIndex = #BackgroundIDs end
if nextIndex > #BackgroundIDs then nextIndex = 0 end
choose(nextIndex)
end

leftArrow.MouseButton1Click:Connect(function() step(-1) end)
rightArrow.MouseButton1Click:Connect(function() step(1) end)

list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
scroll.CanvasSize = UDim2.new(0, list.AbsoluteContentSize.X + 4, 0, 0)
end)
scroll.CanvasSize = UDim2.new(0, list.AbsoluteContentSize.X + 4, 0, 0)

updateButtons()
centerSelected()
return pickerRow
end

section(Settings, "STEAL UI BACKGROUND IMAGE", 48)
createHorizontalImagePicker(MenuCustomize, "Steal UI Image", 49,
function()
return _G.Xlu0StealUIImage
end,
function(value)
_G.Xlu0StealUIImage = value
if _G.Xlu0ApplyStealUIImage then
_G.Xlu0ApplyStealUIImage()
end
do end
end)

do
local mobilePickerGap = Instance.new("Frame")
mobilePickerGap.Name = "MobilePickerGap"
mobilePickerGap.BackgroundTransparency = 1
mobilePickerGap.BorderSizePixel = 0
mobilePickerGap.Size = UDim2.new(1, 0, 0, 7)
mobilePickerGap.LayoutOrder = 13
mobilePickerGap.Parent = MenuCustomize
end

createHorizontalImagePicker(MenuCustomize, "Mobile Button Image Picker", 14,
function() return _G.Xlu0MobileButtonImage end,
function(value)
_G.Xlu0MobileButtonImage = value
if _G.Xlu0ApplyMobileButtonImage then _G.Xlu0ApplyMobileButtonImage() end
end)

end

do
local row = baseRow(Settings, "Reset Mobile Buttons", 15)
local button = Instance.new("TextButton")
button.Name = "ResetMobileButtons"
button.BackgroundColor3 = Color3.fromRGB(232, 232, 238)
button.BackgroundTransparency = 0
button.BorderSizePixel = 0
button.Text = "RESET"
button.TextColor3 = Color3.fromRGB(0, 0, 0)
button.TextSize = 11
button.Font = Enum.Font.Arcade
button.AutoButtonColor = false
button.Size = UDim2.new(0, 78, 0, 26)
button.Position = UDim2.new(1, -88, 0.5, -13)
button.ZIndex = 7
button.Parent = row
corner(button, 8)
stroke(button, Color3.fromRGB(255, 255, 255), 1, 0.18)
button.Activated:Connect(function()
if _G.Xlu0ResetMobileButtons then
_G.Xlu0ResetMobileButtons()
else
_G.Xlu0MobileButtonScale = Xlu0AutoMobile and 0.90 or 1.00
_G.Xlu0HideMobileButtons = false
if _G.Xlu0ApplyMobileButtonsHidden then _G.Xlu0ApplyMobileButtonsHidden() end
if _G.Xlu0ApplyMobileButtonSize then _G.Xlu0ApplyMobileButtonSize() end
do end
end
end)
end

section(Settings, "INTRO", 50)
do
local row, setVisual = toggleRow(Settings, "Intro", _introEnabled, 51)
setIntroVisual = setVisual
local btn = row and row:FindFirstChild("ToggleButton")
if btn then
btn.Activated:Connect(function()
_introEnabled = not _introEnabled
if not _introEnabled then stopIntroPlayback(); stopIntroPreview() end
if setIntroVisual then setIntroVisual(_introEnabled) end
do end
end)
end
if setIntroVisual then setIntroVisual(_introEnabled) end
end
-- Intro song selector removed; Song 4 is always used.

section(Settings, "SETTINGS", 999)
local resetHolder = Instance.new("Frame")
resetHolder.Name = "Reset All Settings Holder"
resetHolder.BackgroundTransparency = 1
resetHolder.BorderSizePixel = 0
resetHolder.Size = UDim2.new(1, -4, 0, 44)
resetHolder.LayoutOrder = 1000
resetHolder.ZIndex = 5
resetHolder.Parent = Settings
local resetBtn = Instance.new("TextButton")
resetBtn.Name = "Reset All Settings"
resetBtn.BackgroundColor3 = Color3.fromRGB(232, 232, 238)
resetBtn.BackgroundTransparency = 0
resetBtn.BorderSizePixel = 0
resetBtn.Text = "Reset All Settings"
resetBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
resetBtn.TextStrokeTransparency = 1
resetBtn.TextSize = 12
resetBtn.Font = Enum.Font.Arcade
resetBtn.AutoButtonColor = false
resetBtn.Size = UDim2.new(1, -16, 0, 42)
resetBtn.Position = UDim2.new(0, 8, 0, 1)
resetBtn.ZIndex = 6
resetBtn.Parent = resetHolder
corner(resetBtn, 10)
local resetStroke = Instance.new("UIStroke")
resetStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
resetStroke.Color = Color3.fromRGB(255, 255, 255)
resetStroke.Thickness = 1
resetStroke.Transparency = 0.12
resetStroke.Parent = resetBtn
local resetDefaultBg = Color3.fromRGB(232, 232, 238)
local resetHoverBg = Color3.fromRGB(245, 245, 250)
local resetConfirmBg = Color3.fromRGB(35, 35, 38)
local resetDoneBg = Color3.fromRGB(28, 40, 30)
local resetDefaultText = Color3.fromRGB(0, 0, 0)
local resetConfirmText = Color3.fromRGB(255, 210, 80)
local resetDoneText = Color3.fromRGB(140, 230, 160)
local confirmState = false
local confirmTimer = nil
function setResetDefaultTheme()
confirmState = false
resetBtn.Text = "RESET ALL SETTINGS"
resetBtn.TextColor3 = resetDefaultText
tween(resetBtn, {BackgroundColor3 = resetDefaultBg}, 0.18)
tween(resetStroke, {Color = Color3.fromRGB(255, 255, 255), Transparency = 0.12, Thickness = 1}, 0.18)
end
function setResetConfirmTheme()
resetBtn.Text = "CLICK AGAIN TO CONFIRM"
resetBtn.TextColor3 = resetConfirmText
tween(resetBtn, {BackgroundColor3 = resetConfirmBg}, 0.18)
tween(resetStroke, {Color = resetConfirmText, Transparency = 0.02, Thickness = 1.4}, 0.18)
end
function setResetDoneTheme()
resetBtn.Text = "DONE - REJOINING..."
resetBtn.TextColor3 = resetDoneText
tween(resetBtn, {BackgroundColor3 = resetDoneBg}, 0.18)
tween(resetStroke, {Color = resetDoneText, Transparency = 0.02, Thickness = 1.4}, 0.18)
end
resetBtn.Text = "RESET ALL SETTINGS"
resetBtn.MouseEnter:Connect(function()
if not confirmState then
tween(resetBtn, {BackgroundColor3 = resetHoverBg}, 0.12)
end
end)


-- Manual Save Config button - same model as Reset Config
local saveHolder = Instance.new("Frame")
saveHolder.Name = "Save Config Holder"
saveHolder.BackgroundTransparency = 1
saveHolder.BorderSizePixel = 0
saveHolder.Size = UDim2.new(1, -4, 0, 44)
saveHolder.LayoutOrder = 1001
saveHolder.ZIndex = 5
saveHolder.Parent = Settings

local saveBtn = Instance.new("TextButton")
saveBtn.Name = "Save Config"
saveBtn.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
saveBtn.BackgroundTransparency = 0
saveBtn.BorderSizePixel = 0
saveBtn.Text = "SAVE CONFIG"
saveBtn.TextColor3 = resetDefaultText
saveBtn.TextStrokeTransparency = 1
saveBtn.TextSize = 12
saveBtn.Font = Enum.Font.Arcade
saveBtn.AutoButtonColor = false
saveBtn.Size = UDim2.new(1, -16, 0, 42)
saveBtn.Position = UDim2.new(0, 8, 0, 1)
saveBtn.ZIndex = 6
saveBtn.Parent = saveHolder
corner(saveBtn, 10)

local saveStroke = Instance.new("UIStroke")
saveStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
saveStroke.Color = Color3.fromRGB(255, 255, 255)
saveStroke.Thickness = 1
saveStroke.Transparency = 0.12
saveStroke.Parent = saveBtn

saveBtn.MouseEnter:Connect(function()
tween(saveBtn, {BackgroundColor3 = Color3.fromRGB(46, 170, 46)}, 0.12)
end)

saveBtn.MouseLeave:Connect(function()
tween(saveBtn, {BackgroundColor3 = Color3.fromRGB(34, 139, 34)}, 0.12)
end)

saveBtn.MouseButton1Click:Connect(function()
if _G.Xlu0ManualSaveConfig then
local ok = pcall(_G.Xlu0ManualSaveConfig)
if ok then
saveBtn.Text = "SAVED"
saveBtn.TextColor3 = resetDoneText
tween(saveBtn, {BackgroundColor3 = resetDoneBg}, 0.18)
tween(saveStroke, {Color = resetDoneText, Transparency = 0.02, Thickness = 1.4}, 0.18)
task.delay(0.8, function()
if saveBtn and saveBtn.Parent then
saveBtn.Text = "SAVE CONFIG"
saveBtn.TextColor3 = resetDefaultText
tween(saveBtn, {BackgroundColor3 = Color3.fromRGB(34, 139, 34)}, 0.18)
tween(saveStroke, {Color = Color3.fromRGB(255,255,255), Transparency = 0.12, Thickness = 1}, 0.18)
end
end)
else
saveBtn.Text = "SAVE FAILED"
task.delay(0.8, function()
if saveBtn and saveBtn.Parent then
saveBtn.Text = "SAVE CONFIG"
saveBtn.TextColor3 = resetDefaultText
end
end)
end
end
end)

resetBtn.MouseLeave:Connect(function()
if not confirmState then
tween(resetBtn, {BackgroundColor3 = resetDefaultBg}, 0.12)
end
end)
resetBtn.MouseButton1Click:Connect(function()
if not confirmState then
confirmState = true
setResetConfirmTheme()
if confirmTimer then task.cancel(confirmTimer) end
confirmTimer = task.delay(3, function()
setResetDefaultTheme()
end)
return
end
if confirmTimer then
task.cancel(confirmTimer)
confirmTimer = nil
end
resetBtn.Text = "RESETTING..."
pcall(function()
local files = {
CONFIG_FILE,
KEYBINDS_CONFIG_FILE,
"Xlu0Duels_MainGUI_Config.json",
"Xlu0DuelsConfig.json",
"Xlu0Duels_Settings.json",
"Xlu0Duels_Keybinds.json",
"Xlu0Duels_GUI.json",
}
for _, fname in ipairs(files) do
pcall(function()
if fname and isfile and isfile(fname) and delfile then
delfile(fname)
end
end)
end
end)
pcall(function()
aceGuiScaleValue = Xlu0AutoMobile and 0.67 or 1.00
aceProgressBarScaleValue = Xlu0AutoMobile and 0.83 or 1.00
NS = 59.5; CS = 28.8; LAGGER_SPEED = 29; LAGGER_CARRY_SPEED = 15
currentSpeedMode = "Normal"
autoCarrySpeedEnabled = false
autoTPHeight = 20
autoStealEnabled = false; selectedStealMode = "Auto Steal V3"; autoStealRadius = 63
_G.Xlu0StealRadii = {Normal = 62, Semi = 9}
selectedAnimationPack = "OFF"; selectedAimbotMode = "Normal"
AIMBOT_SPEED = 58; LAGGER_AIMBOT_SPEED = 40
_G.Xlu0AntiBypassAimbotSpeed = 58; _G.Xlu0AntiBypassLaggerAimbotSpeed = 40; ANTI_DESYNC_AIMBOT_SPEED = 58
autoSwingEnabled = false; mirrorTPDownEnabled = false; antiDesyncAutoSwingEnabled = false
_G.Xlu0NormalAimbotOn = false; _G.Xlu0AntiBypassAimbotOn = false; _G.Xlu0AntiDesyncAimbotOn = false
antiRagdollEnabled = false; infJumpEnabled = false; autoTPEnabled = false
batCounterEnabled = false; medCounterEnabled = false; antiKickEnabled = false; autoResetOnMedEnabled = false
espEnabled = false; showTracerEnabled = false; ragdollCountdownEnabled = false
fpsBoostEnabled = false; antiLagVisualEnabled = false; nukeOptimiserEnabled = false
fovEnabled = false; fovValue = 70; noCamCollisionEnabled = false; _G.Xlu0NoPlayerCollisionEnabled = false
skyTheme = "Off"; currentBackground = 0
selectedIntroMusic = 4; _introEnabled = true
if setIntroVisual then setIntroVisual(_introEnabled) end
if setIntroSongVisual then setIntroSongVisual() end
stopIntroPlayback(); stopIntroPreview()
autoLeftEnabled = false; autoRightEnabled = false
_G.Xlu0GuiLocked = false; _G.Xlu0HideMobileButtons = false; _G.Xlu0MobileButtonScale = Xlu0AutoMobile and 0.90 or 1.00; _G.Xlu0MobileButtonShape = "ROUNDED"
_G.Xlu0MobileButtonImage = ""
_G.Xlu0StealUIImage = ""
aceMainScale.Scale = aceGuiScaleValue
applyXlu0ProgressBarScale()
applyBackground(0)
updateBackgroundButtons()
applyDefaultXlu0Keybinds()
refreshAllSpeedKeybinds()
refreshTPDownKeybind()
if stopAutoTP then stopAutoTP() end
if stopAntiRagdoll then stopAntiRagdoll() end
if normalSpeedBox then normalSpeedBox.Text = tostring(NS) end
if carrySpeedBox then carrySpeedBox.Text = tostring(CS) end
if laggerSpeedBox then laggerSpeedBox.Text = tostring(LAGGER_SPEED) end
if laggerCarrySpeedBox then laggerCarrySpeedBox.Text = tostring(LAGGER_CARRY_SPEED) end
if autoTPHeightBox then autoTPHeightBox.Text = tostring(autoTPHeight) end
if radiusBox then radiusBox.Text = tostring(autoStealRadius) end
if _G.Xlu0RefreshAimbotSpeedBoxes then _G.Xlu0RefreshAimbotSpeedBoxes() end
if type(applyCustomSky) == "function" then applyCustomSky("Off") end
if skyValueLabel then skyValueLabel.Text = "Off" end
if _G.Xlu0ResetMobileButtons then _G.Xlu0ResetMobileButtons() end
pcall(function() if _G.Xlu0ApplyMobileButtonImage then _G.Xlu0ApplyMobileButtonImage() end end)
pcall(function() if _G.Xlu0ApplyStealUIImage then _G.Xlu0ApplyStealUIImage() end end)
if _G.Xlu0DuelsApplySavedGameplayStates then _G.Xlu0DuelsApplySavedGameplayStates() end
do end
end)
task.wait(0.35)
setResetDoneTheme()
task.wait(0.6)
pcall(function()
local TeleportService = game:GetService("TeleportService")
TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
end)
end)
end
task.wait()
_G.__Xlu0DuelsSetupSettingsUI()
pcall(function() _G.Xlu0InstallFontRow() end)
if (_G.Xlu0CustomFontSelected or "None") ~= "None" then
    task.defer(function()
        task.wait(0.2)
        pcall(function() _G.Xlu0ApplyCustomFont(_G.Xlu0CustomFontSelected) end)
    end)
end
if Xlu0UpdateGuiLockVisual then Xlu0UpdateGuiLockVisual() end
if _G.Xlu0ApplyMobileButtonsHidden then _G.Xlu0ApplyMobileButtonsHidden() end
UserInputService.InputBegan:Connect(function(input, gameProcessed)
local isControllerInput = tostring(input.UserInputType):find("Gamepad") ~= nil
if gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard and not listeningForSpeedKey and not listeningForTPDownKey then return end
if UserInputService:GetFocusedTextBox() then return end
if input.UserInputType ~= Enum.UserInputType.Keyboard and not isControllerInput then return end
if input.KeyCode == Enum.KeyCode.Unknown then return end
if speedKeybinds.ToggleUI and input.KeyCode == speedKeybinds.ToggleUI then
if Main.Visible then
Main.Visible = false
MiniFrame.Visible = true
else
Main.Visible = true
MiniFrame.Visible = false
Main.Size = FULL_MAIN_SIZE
end
do end
return
end
if listeningForSpeedKey then
if tick() - (keybindListenStartedAt or 0) < 0.18 then return end
local targetKey = listeningForSpeedKey
if input.KeyCode == Enum.KeyCode.Escape then
listeningForSpeedKey = nil
refreshAllSpeedKeybinds()
return
end
if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete then
speedKeybinds[targetKey] = nil
else
for otherKeyId, boundKey in pairs(speedKeybinds) do
if otherKeyId ~= targetKey and boundKey == input.KeyCode then
speedKeybinds[otherKeyId] = nil
end
end
if tpDownKeybind == input.KeyCode then
tpDownKeybind = nil
refreshTPDownKeybind()
end
speedKeybinds[targetKey] = input.KeyCode
end
listeningForSpeedKey = nil
refreshAllSpeedKeybinds()
do end
return
end
if listeningForTPDownKey then
if tick() - (keybindListenStartedAt or 0) < 0.18 then return end
if input.KeyCode == Enum.KeyCode.Escape then
listeningForTPDownKey = false
refreshTPDownKeybind()
return
end
if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete then
tpDownKeybind = nil
else
for keyId, boundKey in pairs(speedKeybinds) do
if boundKey == input.KeyCode then
speedKeybinds[keyId] = nil
end
end
tpDownKeybind = input.KeyCode
end
listeningForTPDownKey = false
refreshAllSpeedKeybinds()
refreshTPDownKeybind()
do end
return
end
if speedKeybinds.SpeedToggle and input.KeyCode == speedKeybinds.SpeedToggle then
toggleCarryMode()
return
end
if speedKeybinds.LaggerToggle and input.KeyCode == speedKeybinds.LaggerToggle then
toggleLaggerMode()
return
end
if speedKeybinds.Aimbot and input.KeyCode == speedKeybinds.Aimbot then
if _G.Xlu0SafeModeIsLocked and _G.Xlu0SafeModeIsLocked() then
if _G.Xlu0SafeModeForceStop then _G.Xlu0SafeModeForceStop("SAFE MODE LOCK") end
return
end
if _G.Xlu0ToggleSelectedAimbot then
_G.Xlu0ToggleSelectedAimbot()
elseif selectedAimbotMode == "Anti Bypass" and _G.Xlu0StartAntiBypassAimbot and _G.Xlu0StopAntiBypassAimbot then
if _G.Xlu0AntiBypassAimbotOn then _G.Xlu0StopAntiBypassAimbot() else _G.Xlu0StartAntiBypassAimbot() end
elseif _G.Xlu0StartNormalAimbot and _G.Xlu0StopNormalAimbot then
if _G.Xlu0NormalAimbotOn then _G.Xlu0StopNormalAimbot() else _G.Xlu0StartNormalAimbot() end
end
if _G.Xlu0RefreshAimbotVisual then _G.Xlu0RefreshAimbotVisual() end
return
end
if speedKeybinds.AntiDesyncAimbot and input.KeyCode == speedKeybinds.AntiDesyncAimbot then
if _G.Xlu0SafeModeIsLocked and _G.Xlu0SafeModeIsLocked() then
if _G.Xlu0SafeModeForceStop then _G.Xlu0SafeModeForceStop("SAFE MODE LOCK") end
return
end
if _G.Xlu0ToggleAntiDesyncAimbot then
_G.Xlu0ToggleAntiDesyncAimbot()
elseif _G.Xlu0StartAntiDesyncAimbot and _G.Xlu0StopAntiDesyncAimbot then
if _G.Xlu0AntiDesyncAimbotOn then _G.Xlu0StopAntiDesyncAimbot() else _G.Xlu0StartAntiDesyncAimbot() end
end
return
end
if speedKeybinds.DropBrainrot and input.KeyCode == speedKeybinds.DropBrainrot then
runDropBrainrot()
return
end
if speedKeybinds.AutoLeft and input.KeyCode == speedKeybinds.AutoLeft then
if _G.Xlu0SetAutoLeft then _G.Xlu0SetAutoLeft(not autoLeftEnabled) end
return
end
if speedKeybinds.AutoRight and input.KeyCode == speedKeybinds.AutoRight then
if _G.Xlu0SetAutoRight then _G.Xlu0SetAutoRight(not autoRightEnabled) end
return
end
if speedKeybinds.InstantReset and input.KeyCode == speedKeybinds.InstantReset then
if _G.Xlu0CursedInstaReset then _G.Xlu0CursedInstaReset() end
return
end
if tpDownKeybind and input.KeyCode == tpDownKeybind then
runTPFloor()
return
end
end)
setTab("MOVEMENT")
_G.__Xlu0DuelsSetupStealBar = function()
local RunService   = game:GetService("RunService")
local UIS = UserInputService
local TS = TweenService
local Stats        = game:GetService("Stats")
local existingStealBar = LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild("StealBarGui")
if existingStealBar then existingStealBar:Destroy() end
local gui = Instance.new("ScreenGui")
gui.Name = "StealBarGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PlayerGui
function drag(frame)
local dragging, dragStart, startPos = false, nil, nil
frame.InputBegan:Connect(function(input)
if _G.Xlu0GuiLocked == true then return end
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
dragStart = input.Position
startPos = frame.Position
input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then dragging = false end
end)
end
end)
UIS.InputChanged:Connect(function(input)
if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
local delta = input.Position - dragStart
frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
end)
end

-- STEAL HUD (widened card + liquid-glass progress bar)
local pbFrame = Instance.new("Frame", gui)
pbFrame.Name = "StealBar"
pbFrame.Size = UDim2.new(0, 300, 0, 56)
pbFrame.Position = UDim2.new(0.5, -150, 1, -70)
pbFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
pbFrame.BorderSizePixel = 0
pbFrame.Active = true
pbFrame.ClipsDescendants = true

-- White steal-start glow overlay
local stealWhiteGlow = Instance.new("Frame")
stealWhiteGlow.Name = "StealWhiteGlow"
stealWhiteGlow.Size = UDim2.new(1, 0, 1, 0)
stealWhiteGlow.Position = UDim2.new(0, 0, 0, 0)
stealWhiteGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
stealWhiteGlow.BackgroundTransparency = 1
stealWhiteGlow.BorderSizePixel = 0
stealWhiteGlow.ZIndex = 1
stealWhiteGlow.Parent = pbFrame
Instance.new("UICorner", stealWhiteGlow).CornerRadius = UDim.new(0, 10)

local stealWhiteGradient = Instance.new("UIGradient")
stealWhiteGradient.Rotation = 90
stealWhiteGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.55),
    NumberSequenceKeypoint.new(0.45, 0.15),
    NumberSequenceKeypoint.new(1, 0.65)
})
stealWhiteGradient.Parent = stealWhiteGlow

local stealBgImage = Instance.new("ImageLabel")
stealBgImage.Name = "StealUIBackground"
stealBgImage.BackgroundTransparency = 1
stealBgImage.Size = UDim2.new(1, 0, 1, 0)
stealBgImage.Position = UDim2.new(0, 0, 0, 0)
stealBgImage.ScaleType = Enum.ScaleType.Crop
stealBgImage.ImageTransparency = 0.28
stealBgImage.ZIndex = 0
stealBgImage.Parent = pbFrame
Instance.new("UICorner", stealBgImage).CornerRadius = UDim.new(0, 10)
local function normalizeStealUIImage(value)
value = tostring(value or "")
if value == "" then return "" end
if value:match("^rbxassetid://%d+$") then return value end
local id = value:match("(%d+)")
return id and ("rbxassetid://" .. id) or ""
end
function _G.Xlu0ApplyStealUIImage()
local image = normalizeStealUIImage(_G.Xlu0StealUIImage)
stealBgImage.Image = image
stealBgImage.ImageColor3 = _G.Xlu0ThemeColors[_G.Xlu0ThemeName] or _G.Xlu0ThemeColors.WHITE
stealBgImage.Visible = image ~= ""
pbFrame.BackgroundTransparency = image ~= "" and 0.18 or 0
end
_G.Xlu0ApplyStealUIImage()
Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 10)
local pbSt = Instance.new("UIStroke", pbFrame)
pbSt.Color = Color3.fromRGB(55, 55, 55)
pbSt.Thickness = 1
drag(pbFrame)
local pbScale = Instance.new("UIScale")
pbScale.Name = "Xlu0ProgressBarScale"
pbScale.Scale = aceProgressBarScaleValue or 1
pbScale.Parent = pbFrame

-- "STEAL" label (left)
local stealLbl = Instance.new("TextLabel", pbFrame)
stealLbl.Size = UDim2.new(0, 70, 0, 20)
stealLbl.Position = UDim2.new(0, 10, 0, 6)
stealLbl.BackgroundTransparency = 1
stealLbl.Text = "STEAL"
stealLbl.TextColor3 = Color3.fromRGB(220, 220, 220)
stealLbl.Font = Enum.Font.GothamBlack
stealLbl.TextSize = 12
stealLbl.TextXAlignment = Enum.TextXAlignment.Left

-- FPS | PING label (right)
local pingBarLbl = Instance.new("TextLabel", pbFrame)
pingBarLbl.Size = UDim2.new(0, 130, 0, 20)
pingBarLbl.Position = UDim2.new(1, -138, 0, 6)
pingBarLbl.BackgroundTransparency = 1
pingBarLbl.Text = "0 FPS | 0ms"
pingBarLbl.TextColor3 = Color3.fromRGB(140, 140, 140)
pingBarLbl.Font = Enum.Font.GothamBold
pingBarLbl.TextSize = 11
pingBarLbl.TextXAlignment = Enum.TextXAlignment.Right

-- Radius / Mode sub-line
local progressRadLbl = Instance.new("TextLabel", pbFrame)
progressRadLbl.Size = UDim2.new(1, -20, 0, 14)
progressRadLbl.Position = UDim2.new(0, 10, 0, 24)
progressRadLbl.BackgroundTransparency = 1
progressRadLbl.Text = string.format("Radius: %s  |  Mode: %s", tostring(autoStealRadius), tostring(selectedStealMode))
progressRadLbl.TextColor3 = Color3.fromRGB(100, 100, 100)
progressRadLbl.Font = Enum.Font.GothamBold
progressRadLbl.TextSize = 10
progressRadLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Progress track (liquid-glass: frosted translucent track, glossy fill)
local pbg = Instance.new("Frame", pbFrame)
pbg.Size = UDim2.new(1, -18, 0, 12)
pbg.Position = UDim2.new(0, 9, 1, -17)
pbg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
pbg.BackgroundTransparency = 0.85
pbg.BorderSizePixel = 0
pbg.ClipsDescendants = true
Instance.new("UICorner", pbg).CornerRadius = UDim.new(1, 0)
local pbgStroke = Instance.new("UIStroke", pbg)
pbgStroke.Color = Color3.fromRGB(255, 255, 255)
pbgStroke.Transparency = 0.65
pbgStroke.Thickness = 1
local progressFill = Instance.new("Frame", pbg)
progressFill.Name = "Fill"
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
progressFill.BackgroundTransparency = 0.12
progressFill.BorderSizePixel = 0
Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)
local progressFillGrad = Instance.new("UIGradient", progressFill)
progressFillGrad.Rotation = 90
progressFillGrad.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0.05),
NumberSequenceKeypoint.new(0.45, 0.35),
NumberSequenceKeypoint.new(1, 0.05),
})
local progressShine = Instance.new("Frame", progressFill)
progressShine.Size = UDim2.new(1, 0, 0, 3)
progressShine.Position = UDim2.new(0, 0, 0, 1)
progressShine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
progressShine.BackgroundTransparency = 0.35
progressShine.BorderSizePixel = 0
Instance.new("UICorner", progressShine).CornerRadius = UDim.new(1, 0)

-- Pct label (bottom-right)
local progressPct = Instance.new("TextLabel", pbFrame)
progressPct.Size = UDim2.new(0, 40, 0, 14)
progressPct.Position = UDim2.new(1, -48, 1, -18)
progressPct.BackgroundTransparency = 1
progressPct.Text = "0%"
progressPct.TextColor3 = Color3.fromRGB(200, 200, 200)
progressPct.Font = Enum.Font.GothamBlack
progressPct.TextSize = 10
progressPct.TextXAlignment = Enum.TextXAlignment.Right

local barState = "IDLE"
function setBarState(state)
barState = state
if state == "STEALING" then
TS:Create(stealLbl, TweenInfo.new(0.18), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
TS:Create(pbSt, TweenInfo.new(0.22), {
    Color = Color3.fromRGB(255, 255, 255),
    Transparency = 0.05,
    Thickness = 1.6
}):Play()
TS:Create(stealWhiteGlow, TweenInfo.new(0.28, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
    BackgroundTransparency = 0.72
}):Play()
TS:Create(progressRadLbl, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(230, 230, 230)}):Play()
TS:Create(progressPct, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
elseif state == "READY" then
TS:Create(stealLbl, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
TS:Create(pbSt, TweenInfo.new(0.25), {
    Color = Color3.fromRGB(90, 90, 90),
    Transparency = 0,
    Thickness = 1
}):Play()
TS:Create(stealWhiteGlow, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
TS:Create(progressRadLbl, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(120, 120, 120)}):Play()
else
TS:Create(stealLbl, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
TS:Create(pbSt, TweenInfo.new(0.25), {
    Color = Color3.fromRGB(55, 55, 55),
    Transparency = 0,
    Thickness = 1
}):Play()
TS:Create(stealWhiteGlow, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
TS:Create(progressRadLbl, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(100, 100, 100)}):Play()
TS:Create(progressPct, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
end
end

task.spawn(function()
local lastFrame = tick()
local fpsSamples = {}
local fpsAvg = 60
RunService.RenderStepped:Connect(function()
local now = tick()
local dt = now - lastFrame
lastFrame = now
if dt > 0 then
table.insert(fpsSamples, 1 / dt)
if #fpsSamples > 30 then table.remove(fpsSamples, 1) end
local sum = 0
for _, v in ipairs(fpsSamples) do sum = sum + v end
fpsAvg = sum / #fpsSamples
end
end)
while pbFrame and pbFrame.Parent do
local ping = 0
pcall(function()
local stat = Stats.Network.ServerStatsItem["Data Ping"]
if stat then ping = tonumber(stat:GetValue()) or 0 end
end)
pingBarLbl.Text = string.format("%d FPS | %dms", math.floor(fpsAvg + 0.5), math.floor(ping + 0.5))
pingBarLbl.TextColor3 = ping < 100 and Color3.fromRGB(140,220,140) or (ping < 200 and Color3.fromRGB(220,200,100) or Color3.fromRGB(220,100,100))
progressRadLbl.Text = string.format("Radius: %s  |  Mode: %s", tostring(autoStealRadius), tostring(selectedStealMode))
task.wait(0.5)
end
end)

local StealBar = {}
function StealBar.SetProgress(p)
p = math.clamp(p, 0, 1)
progressFill.Size = UDim2.new(p, 0, 1, 0)
progressPct.Text = math.floor(p * 100 + 0.5) .. "%"

if barState == "STEALING" then
    -- Starts subtle and becomes whiter as stealing progresses.
    stealWhiteGlow.BackgroundTransparency = 0.84 - (p * 0.26)
    progressFill.BackgroundTransparency = 0.18 - (p * 0.12)
    pbSt.Transparency = math.max(0.02, 0.18 - (p * 0.16))
end
end
function StealBar.Reset()
StealBar.SetProgress(0)
setBarState("IDLE")
end
function StealBar.SetState(state)
setBarState(state)
end
setBarState("IDLE")
_G.StealBar = StealBar
end
_G.__Xlu0DuelsSetupStealBar()
if _G.Xlu0AutoStealSync then task.defer(_G.Xlu0AutoStealSync) end
_G.__Xlu0DuelsSetupMinimizeToggle = function()
_G.__Xlu0DuelsMinimized = false
Close.MouseButton1Click:Connect(function()
_G.__Xlu0DuelsMinimized = not _G.__Xlu0DuelsMinimized
if _G.__Xlu0DuelsMinimized then
Main.Visible = false
MiniFrame.Visible = true
else
Main.Visible = true
MiniFrame.Visible = false
Main.Size = FULL_MAIN_SIZE
end
do end
end)
end
_G.__Xlu0DuelsSetupMinimizeToggle()

_G.__Xlu0DuelsRunIntro = function()
    local introGuiParent = Gui and Gui.Parent or PlayerGui
    local origSize = FULL_MAIN_SIZE or Main.Size
    local wasMinimizedBeforeIntro = (_G.__Xlu0DuelsMinimized == true)

    if not _introEnabled then
        stopIntroPlayback()
        stopIntroPreview()
        Main.Size = origSize
        Main.Visible = not wasMinimizedBeforeIntro
        MiniFrame.Visible = wasMinimizedBeforeIntro
        return
    end

    playIntroMusic()
    Main.Visible = false
    MiniFrame.Visible = false
    Main.Size = UDim2.new(0, 0, 0, 0)

    task.spawn(function()
    -- AdaptHub Intro - referans videodaki temiz sürüm
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")

    local LocalPlayer = Players.LocalPlayer
    local DARKER_BG = Color3.fromRGB(5, 5, 8)
    local WHITE = Color3.fromRGB(255, 255, 255)
    local TRAIL_COLOR = Color3.fromRGB(205, 215, 235)

    local function applyProps(inst, props)
        for k, v in pairs(props) do
            if k ~= "Parent" then
                inst[k] = v
            end
        end
        if props.Parent then
            inst.Parent = props.Parent
        end
        return inst
    end

    local function new(class, props)
        return applyProps(Instance.new(class), props)
    end

    local function tween(obj, duration, props, style, dir)
        local info = TweenInfo.new(duration, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
        local t = TweenService:Create(obj, info, props)
        t:Play()
        return t
    end

    local AdaptHubPolished = new("ScreenGui", {
        Name = "Xlu0DuelsIntro",
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        DisplayOrder = 100,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = introGuiParent,
    })

    -- INTRO SCREEN
    --------------------------------------------------------------------------------
    local AdaptIntro = new("Frame", {
        Name = "AdaptIntro",
        ZIndex = 1000,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = DARKER_BG,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = AdaptHubPolished,
    })

    -- Adamın arkasındaki ekstra görsel kaldırıldı
    local IntroBackdropImage = nil

    -- Chain Spear Animation Stage
    local ChainSpearStage = new("Frame", {
        Name = "ChainSpearStage",
        Visible = false, -- Videoda işaretlenen gri halkalar/uzantılar kaldırıldı
        ZIndex = 1000,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.42, 0),
        Size = UDim2.new(0.64, 0, 0.64, 0),
        BackgroundTransparency = 1,
        Parent = AdaptIntro,
    })
    new("UIAspectRatioConstraint", {Parent = ChainSpearStage})
    new("UISizeConstraint", {MinSize = Vector2.new(200, 200), MaxSize = Vector2.new(280, 280), Parent = ChainSpearStage})

    -- Create 11 chain spear rotors in a loop
    local rotorData = {
        {rot = -1094.822, trans = 0.998},
        {rot = -1095.4,   trans = 0.998},
        {rot = -1095.978, trans = 0.996},
        {rot = -1096.515, trans = 0.995},
        {rot = -1097.052, trans = 0.993},
        {rot = -1097.548, trans = 0.991},
        {rot = -1098.004, trans = 0.988},
        {rot = -1098.419, trans = 0.985},
        {rot = -1098.794, trans = 0.982},
        {rot = -1099.128, trans = 0.978},
        {rot = -1099.421, trans = 0.973},
    }

    for i, data in ipairs(rotorData) do
        local rotor = new("Frame", {
            Name = "ChainSpearRotor" .. i,
            ZIndex = 1000,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Rotation = data.rot,
            Parent = ChainSpearStage,
        })

        new("ImageLabel", {
            Name = "ChainSpearTrail" .. i,
            ZIndex = 1000,
            AnchorPoint = Vector2.new(0.73, 0.02),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0.553, 0, 0.829, 0),
            BackgroundTransparency = 1,
            Image = "rbxassetid://118963313877514",
            ImageColor3 = TRAIL_COLOR,
            ImageTransparency = data.trans,
            ScaleType = Enum.ScaleType.Fit,
            Parent = rotor,
        })
    end

    -- Toji Cutout Stage
    local TojiCutoutStage = new("Frame", {
        Name = "TojiCutoutStage",
        Visible = false,
        ZIndex = 1000,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = Xlu0AutoMobile and UDim2.new(0.62, 0, 0.62, 0) or UDim2.new(0.72, 0, 0.72, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Rotation = -2,
        Parent = AdaptIntro,
    })
    new("UIScale", {Parent = TojiCutoutStage})

    -- Pants white fill
    new("ImageLabel", {
        Name = "TojiPantsWhiteFill",
        ZIndex = 998,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://82757811555212",
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Fit,
        Parent = TojiCutoutStage,
    })

    -- Toji pieces with seam fills (10 pieces, each with 4 directional seam fills)
    local tojiPieceImages = {
        "rbxassetid://130451097419605",
        "rbxassetid://129030262345273",
        "rbxassetid://76292842640935",
        "rbxassetid://82757811555212",
        "rbxassetid://92910922537368",
        "rbxassetid://105960347086002",
        "rbxassetid://116720305084998",
        "rbxassetid://90341354549871",
        "rbxassetid://72399600208480",
        "rbxassetid://81834484116440",
    }

    local seamOffsets = {
        {x = -1, y = 0},
        {x = 1,  y = 0},
        {x = 0,  y = -1},
        {x = 0,  y = 1},
    }

    for i, imageId in ipairs(tojiPieceImages) do
        -- Seam fills (dark outline effect)
        for j, offset in ipairs(seamOffsets) do
            new("ImageLabel", {
                Name = "TojiSeamFill" .. i,
                ZIndex = 999,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, offset.x, 0.5, offset.y),
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Image = imageId,
                ImageColor3 = DARKER_BG,
                ImageTransparency = 1,
                ScaleType = Enum.ScaleType.Fit,
                Parent = TojiCutoutStage,
            })
        end

        -- Main piece (Settings'ten seçilen tema rengiyle boyanır)
        new("ImageLabel", {
            Name = "TojiPiece" .. i,
            ZIndex = 1000,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = imageId,
            ImageColor3 = (_G.Xlu0ThemeColors and _G.Xlu0ThemeColors[_G.Xlu0ThemeName]) or Color3.fromRGB(255, 255, 255),
            ImageTransparency = 1,
            ScaleType = Enum.ScaleType.Fit,
            Parent = TojiCutoutStage,
        })

        -- Sword shine on piece 2
        if i == 2 then
            local shine = new("ImageLabel", {
                Name = "TojiSwordShine",
                ZIndex = 1001,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Image = imageId,
                ImageColor3 = (_G.Xlu0ThemeColors and _G.Xlu0ThemeColors[_G.Xlu0ThemeName]) or Color3.fromRGB(255, 255, 255),
                ImageTransparency = 1,
                ScaleType = Enum.ScaleType.Fit,
                Parent = TojiCutoutStage,
            })
            new("UIGradient", {
                Rotation = -25,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1, 0),
                    NumberSequenceKeypoint.new(0.5, 0.14, 0),
                    NumberSequenceKeypoint.new(1, 1, 0),
                }),
                Parent = shine,
            })
        end

        -- Moving hand white fills on piece 6
        if i == 6 then
            for k = 1, 4 do
                new("ImageLabel", {
                    Name = "TojiMovingHandWhiteFill" .. (k > 1 and k or ""),
                    ZIndex = 998,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, seamOffsets[k].x, 0.5, seamOffsets[k].y),
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Image = imageId,
                    ImageColor3 = WHITE,
                    ImageTransparency = 1,
                    ScaleType = Enum.ScaleType.Fit,
                    Parent = TojiCutoutStage,
                })
            end
        end
    end

    -- XLU0 DUELS intro başlığı
    local IntroTitle = new("TextLabel", {
        Name = "IntroTitle",
        ZIndex = 1002,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.42, 0),
        Size = UDim2.new(0, 430, 0, 90),
        BackgroundTransparency = 1,
        Text = "XLU0 DUELS",
        TextColor3 = WHITE,
        TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
        TextStrokeTransparency = 0.5,
        Font = Enum.Font.Arcade,
        TextSize = 54,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = AdaptIntro,
    })

    -- Kaynak koddaki gibi, siyah geçiş sadece harflerin içinden geçer
    local IntroTitleSweep = IntroTitle:Clone()
    IntroTitleSweep.Name = "IntroTitleSweep"
    IntroTitleSweep.TextColor3 = (_G.Xlu0ThemeColors and _G.Xlu0ThemeColors[_G.Xlu0ThemeName]) or Color3.fromRGB(255, 255, 255)
    IntroTitleSweep.TextTransparency = 0
    IntroTitleSweep.TextStrokeTransparency = 1
    IntroTitleSweep.ZIndex = IntroTitle.ZIndex + 1
    IntroTitleSweep.Parent = AdaptIntro
    _G.Xlu0IntroTitleSweep = IntroTitleSweep

    local IntroSweepGradient = Instance.new("UIGradient")
    IntroSweepGradient.Rotation = 12
    IntroSweepGradient.Offset = Vector2.new(-1.25, 0)
    IntroSweepGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0.00, 1),
        NumberSequenceKeypoint.new(0.42, 1),
        NumberSequenceKeypoint.new(0.50, 0.08),
        NumberSequenceKeypoint.new(0.58, 1),
        NumberSequenceKeypoint.new(1.00, 1)
    })
    IntroSweepGradient.Parent = IntroTitleSweep

    task.spawn(function()
        while IntroTitleSweep and IntroTitleSweep.Parent do
            IntroSweepGradient.Offset = Vector2.new(-1.25, 0)
            local sweepTween = TweenService:Create(
                IntroSweepGradient,
                TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {Offset = Vector2.new(1.25, 0)}
            )
            sweepTween:Play()
            sweepTween.Completed:Wait()
            task.wait(0.8)
        end
    end)

    -- Tap Anywhere shadow
    new("TextLabel", {
        Name = "TapAnywhereShadow",
        ZIndex = 1002,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 3, 0.42, 61),
        Size = UDim2.new(0, 300, 0, 38),
        BackgroundTransparency = 1,
        Text = "TAP ANYWHERE TO SKIP",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextTransparency = 0.18,
        TextSize = 18,
        Font = Enum.Font.GothamBlack,
        Parent = AdaptIntro,
    })

    -- Tap Anywhere
    local TapAnywhereLabel = new("TextLabel", {
        Name = "TapAnywhere",
        ZIndex = 1003,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.42, 58),
        Size = UDim2.new(0, 300, 0, 38),
        BackgroundTransparency = 1,
        Text = "TAP ANYWHERE TO SKIP",
        TextColor3 = WHITE,
        TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
        TextStrokeTransparency = 0.45,
        TextSize = 18,
        Font = Enum.Font.GothamBlack,
        Parent = AdaptIntro,
    })

    -- Discord shadow
    new("TextLabel", {
        Name = "DiscordInviteShadow",
        ZIndex = 1002,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 3, 0.42, 85),
        Size = UDim2.new(0, 250, 0, 34),
        BackgroundTransparency = 1,
        Text = "discord.gg/SvYDTcQXN",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextTransparency = 0.2,
        TextSize = 16,
        Font = Enum.Font.GothamBlack,
        Parent = AdaptIntro,
    })

    -- Discord Invite
    local DiscordInviteLabel = new("TextLabel", {
        Name = "DiscordInvite",
        ZIndex = 1003,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.42, 82),
        Size = UDim2.new(0, 250, 0, 34),
        BackgroundTransparency = 1,
        Text = "discord.gg/SvYDTcQXN",
        TextColor3 = WHITE,
        TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
        TextStrokeTransparency = 0.5,
        TextSize = 16,
        Font = Enum.Font.GothamBlack,
        Parent = AdaptIntro,
    })

    -- Intro yazıları cihaz tipine göre otomatik ölçeklenir.
    local introTextScaleValue = Xlu0AutoMobile and 0.82 or 1.00
    for _, introTextObject in ipairs({IntroTitle, IntroTitleSweep, TapAnywhereLabel, DiscordInviteLabel}) do
        local introScale = Instance.new("UIScale")
        introScale.Name = "Xlu0AutoDeviceScale"
        introScale.Scale = introTextScaleValue
        introScale.Parent = introTextObject
    end
    for _, shadowName in ipairs({"TapAnywhereShadow", "DiscordInviteShadow"}) do
        local shadowObject = AdaptIntro:FindFirstChild(shadowName)
        if shadowObject then
            local shadowScale = Instance.new("UIScale")
            shadowScale.Name = "Xlu0AutoDeviceScale"
            shadowScale.Scale = introTextScaleValue
            shadowScale.Parent = shadowObject
        end
    end

    -- Caption Shield
    local IntroCaptionShield = new("Frame", {
        Name = "IntroCaptionShield",
        Visible = false, -- Yatay siyah şerit kaldırıldı
        ZIndex = 1002,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.42, 70),
        Size = UDim2.new(0.58, 0, 0, 48),
        BackgroundColor3 = DARKER_BG,
        BackgroundTransparency = 0.08,
        BorderSizePixel = 0,
        Parent = AdaptIntro,
    })
    new("UICorner", {CornerRadius = UDim.new(0, 14), Parent = IntroCaptionShield})
    new("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.94, 0),
            NumberSequenceKeypoint.new(0.16, 0.14, 0),
            NumberSequenceKeypoint.new(0.84, 0.14, 0),
            NumberSequenceKeypoint.new(1, 0.94, 0),
        }),
        Parent = IntroCaptionShield,
    })

    -- Tap Catcher
    new("TextButton", {
        Name = "TapCatcher",
        ZIndex = 1004,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        Parent = AdaptIntro,
    })

    local introSkipped = false
    local introFinished = false

    local TapCatcher = AdaptIntro:FindFirstChild("TapCatcher")
    local TapAnywhere = AdaptIntro:FindFirstChild("TapAnywhere")

    local function skipIntro()
        if introSkipped then return end
        introSkipped = true
        stopIntroPlayback()

        _G.Xlu0IntroTitleSweep = nil
        tween(AdaptIntro, 0.4, {BackgroundTransparency = 1})
        for _, child in ipairs(AdaptIntro:GetChildren()) do
            if child:IsA("ImageLabel") then
                tween(child, 0.3, {ImageTransparency = 1})
            elseif child:IsA("TextLabel") then
                tween(child, 0.3, {TextTransparency = 1})
            elseif child:IsA("Frame") then
                tween(child, 0.3, {BackgroundTransparency = 1})
                for _, sub in ipairs(child:GetDescendants()) do
                    if sub:IsA("ImageLabel") then tween(sub, 0.3, {ImageTransparency = 1}) end
                    if sub:IsA("TextLabel") then tween(sub, 0.3, {TextTransparency = 1}) end
                end
            end
        end

        task.delay(0.45, function()
            introFinished = true
            Main.Visible = true
            MiniFrame.Visible = false
            Main.Size = UDim2.new(0, 0, 0, 0)
            pcall(function()
                TweenService:Create(Main, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = origSize}):Play()
            end)
            if AdaptHubPolished then AdaptHubPolished:Destroy() end
        end)
    end

    if TapCatcher then
        TapCatcher.MouseButton1Click:Connect(skipIntro)
    end

    task.spawn(function()
        task.wait(0.2)
        if introSkipped then return end

        -- ChainSpear animasyonu kaldırıldı; referans videodaki temiz görünüm korunuyor.

        task.wait(0.6)
        if introSkipped then return end

        TojiCutoutStage.Visible = true
        local tojiScale = TojiCutoutStage:FindFirstChild("UIScale")
        if tojiScale then
            tojiScale.Scale = 0.78
            tween(tojiScale, 0.6, {Scale = 1}, Enum.EasingStyle.Back)
        end

        -- Karakter parçaları videodaki gibi farklı yönlerden birleşir.
        local pieceOffsets = {
            {-42, -26, -10}, {38, -34, 9}, {-34, 18, -7}, {30, 28, 8},
            {-48, 6, -11}, {46, 10, 10}, {-25, 38, -6}, {28, 42, 7},
            {-18, -44, -5}, {20, -38, 5},
        }

        for i = 1, 10 do
            if introSkipped then return end
            local data = pieceOffsets[i]
            local piece = TojiCutoutStage:FindFirstChild("TojiPiece" .. i)

            if piece then
                piece.Position = UDim2.new(0.5, data[1], 0.5, data[2])
                piece.Rotation = data[3]
                piece.ImageTransparency = 1
                tween(piece, 0.42, {
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Rotation = 0,
                    ImageTransparency = 0,
                }, Enum.EasingStyle.Back)
            end

            for _, child in ipairs(TojiCutoutStage:GetChildren()) do
                if child.Name == "TojiSeamFill" .. i then
                    child.Position = UDim2.new(0.5, data[1], 0.5, data[2])
                    child.Rotation = data[3]
                    child.ImageTransparency = 1
                    tween(child, 0.42, {
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        Rotation = 0,
                        ImageTransparency = 0,
                    }, Enum.EasingStyle.Back)
                end
            end
            task.wait(0.065)
        end

        -- Birleşme sonrası kısa vurgu ve hafif canlı duruş.
        tween(tojiScale, 0.16, {Scale = 1.06}, Enum.EasingStyle.Quad)
        task.wait(0.16)
        tween(tojiScale, 0.24, {Scale = 1}, Enum.EasingStyle.Back)

        task.spawn(function()
            while not introSkipped and TojiCutoutStage.Parent do
                tween(TojiCutoutStage, 1.15, {
                    Rotation = 0.8,
                    Position = UDim2.new(0.5, 0, 0.5, -5),
                }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                task.wait(1.15)
                if introSkipped or not TojiCutoutStage.Parent then return end
                tween(TojiCutoutStage, 1.15, {
                    Rotation = -0.8,
                    Position = UDim2.new(0.5, 0, 0.5, 5),
                }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                task.wait(1.15)
            end
        end)

        task.wait(0.3)
        if introSkipped then return end

        local shine = TojiCutoutStage:FindFirstChild("TojiSwordShine")
        if shine then
            tween(shine, 0.4, {ImageTransparency = 0.2})
            task.wait(0.3)
            if not introSkipped then
                tween(shine, 0.3, {ImageTransparency = 0.7})
            end
        end

        task.wait(0.5)
        if introSkipped then return end

        -- CaptionShield kaldırıldı; alttaki yazılar doğrudan görünür.

        task.spawn(function()
            while not introSkipped do
                tween(TapAnywhere, 0.8, {TextTransparency = 0.5})
                task.wait(0.8)
                if introSkipped then return end
                tween(TapAnywhere, 0.8, {TextTransparency = 0})
                task.wait(0.8)
            end
        end)

        task.wait(6)
        if not introSkipped then skipIntro() end
    end)

    end)
end
_G.__Xlu0DuelsRunIntro()

_G.Xlu0DuelsForceSyncLoadedButtons = function()
pcall(function()
if setAutoTPVisual then setAutoTPVisual(autoTPEnabled) end
if autoTPEnabled then startAutoTP() else stopAutoTP() end
end)
pcall(function()
if setInfJumpVisual then setInfJumpVisual(infJumpEnabled) end
if setInfJumpInternal then setInfJumpInternal(infJumpEnabled) end
end)
pcall(function()
if setAntiRagdollVisual then setAntiRagdollVisual(antiRagdollEnabled) end
setAntiRagdoll(antiRagdollEnabled)
end)
pcall(function()
if _G.Xlu0SetAutoLeft then _G.Xlu0SetAutoLeft(autoLeftEnabled, true) end
if _G.Xlu0SetAutoRight then _G.Xlu0SetAutoRight(autoRightEnabled, true) end
end)
pcall(function()
if setAutoStealVisual then setAutoStealVisual(autoStealEnabled) end
if _G.Xlu0AutoStealSync then _G.Xlu0AutoStealSync() end
end)
pcall(function()
if _G.Xlu0NormalAutoSwingSetVisual then _G.Xlu0NormalAutoSwingSetVisual(autoSwingEnabled) end
if _G.Xlu0MirrorTPDownSetVisual then _G.Xlu0MirrorTPDownSetVisual(mirrorTPDownEnabled) end
if _G.Xlu0AntiDesyncAutoSwingSetVisual then _G.Xlu0AntiDesyncAutoSwingSetVisual(antiDesyncAutoSwingEnabled) end
if _G.Xlu0AntiDesyncSetVisual then _G.Xlu0AntiDesyncSetVisual(_G.Xlu0AntiDesyncAimbotOn == true) end
if _G.Xlu0AntiDesyncAimbotOn and _G.Xlu0StartAntiDesyncAimbot then
_G.Xlu0StartAntiDesyncAimbot()
elseif _G.Xlu0StopAntiDesyncAimbot then
_G.Xlu0StopAntiDesyncAimbot()
end
end)
pcall(function()
if selectedAimbotMode == "Anti Bypass" then
if _G.Xlu0NormalAimbotStop then _G.Xlu0NormalAimbotStop() end
if _G.Xlu0AntiBypassAimbotOn and _G.Xlu0AntiBypassStart then
_G.Xlu0AntiBypassStart()
elseif _G.Xlu0AntiBypassStop then
_G.Xlu0AntiBypassStop()
end
else
if _G.Xlu0AntiBypassStop then _G.Xlu0AntiBypassStop() end
if _G.Xlu0NormalAimbotOn and _G.Xlu0NormalAimbotStart then
_G.Xlu0NormalAimbotStart()
elseif _G.Xlu0NormalAimbotStop then
_G.Xlu0NormalAimbotStop()
end
end
if _G.Xlu0RefreshAimbotVisual then _G.Xlu0RefreshAimbotVisual() end
end)
pcall(function()
if setBatCounterVisual then setBatCounterVisual(batCounterEnabled) end
if setMedCounterVisual then setMedCounterVisual(medCounterEnabled) end
if setSafeModeVisual then setSafeModeVisual(antiKickEnabled) end
if batCounterEnabled then
if _G.Xlu0StartBatCounter then _G.Xlu0StartBatCounter() end
else
if _G.Xlu0StopBatCounter then _G.Xlu0StopBatCounter() end
end
if medCounterEnabled then
if _G.Xlu0StartMedCounter then _G.Xlu0StartMedCounter(LP.Character) end
else
if _G.Xlu0StopMedCounter then _G.Xlu0StopMedCounter() end
end
if _G.Xlu0SetNoPlayerCollisionVisual then _G.Xlu0SetNoPlayerCollisionVisual(_G.Xlu0NoPlayerCollisionEnabled) end
if _G.Xlu0NoPlayerCollisionEnabled then
if enableNoPlayerCollision then enableNoPlayerCollision() end
else
if disableNoPlayerCollision then disableNoPlayerCollision() end
end
if _G.Xlu0SetAutoResetOnMed then
_G.Xlu0SetAutoResetOnMed(autoResetOnMedEnabled, true)
else
if setAutoResetOnMedVisual then setAutoResetOnMedVisual(autoResetOnMedEnabled) end
end
end)
pcall(function()
if setPlayerESPVisual then setPlayerESPVisual(espEnabled) end
if espEnabled then if startPlayerESP then startPlayerESP() end; if BoxedESPOptions then BoxedESPOptions.box = false end else if stopPlayerESP then stopPlayerESP() end; if BoxedESPOptions then BoxedESPOptions.box = false end end
if setTracerESPVisual then setTracerESPVisual(showTracerEnabled) end
if BoxedESPOptions then BoxedESPOptions.tracer = false end
if refreshBoxedESP then refreshBoxedESP() end
if setRagdollCountdownVisual then setRagdollCountdownVisual(ragdollCountdownEnabled) end
if ragdollCountdownEnabled then hookRagdollCountdown(LP.Character) else stopRagdollCountdown() end
if setFPSBoostVisual then setFPSBoostVisual(fpsBoostEnabled) end
if fpsBoostEnabled then enableStretchRez() else disableStretchRez() end
if setAntiLagVisual then setAntiLagVisual(antiLagVisualEnabled) end
if antiLagVisualEnabled then enableAntiLag() else disableAntiLag() end
if setNukeOptimiserVisual then setNukeOptimiserVisual(nukeOptimiserEnabled) end
if nukeOptimiserEnabled then enableNukeOptimizer() else disableNukeOptimizer() end
if setFOVVisual then setFOVVisual(fovEnabled) end
if fovEnabled then enableCustomFov() else disableCustomFov() end
if setNoCamCollisionVisual then setNoCamCollisionVisual(noCamCollisionEnabled) end
if noCamCollisionEnabled then enableNoCamCollision() else disableNoCamCollision() end
if type(applyCustomSky) == "function" then
applyCustomSky((skyTheme and skyTheme ~= "") and skyTheme or "Off")
end
if skyValueLabel then skyValueLabel.Text = skyTheme or "Off" end
end)
do end
end
task.defer(function()
task.wait(0.35)
if type(applyCustomSky) == "function" then
pcall(function() applyCustomSky((skyTheme and skyTheme ~= "") and skyTheme or "Off") end)
end
if skyValueLabel then skyValueLabel.Text = skyTheme or "Off" end
end)
task.defer(_G.Xlu0DuelsForceSyncLoadedButtons)
task.delay(1, function()
if _G.Xlu0DuelsForceSyncLoadedButtons then _G.Xlu0DuelsForceSyncLoadedButtons() end
end)
task.defer(function()
task.wait(0.2)
if _G.Xlu0SyncToggleVisuals then _G.Xlu0SyncToggleVisuals() end
end)
customFontVisualEnabled = false
if V then V.customFontEnabled = false end
function enableCustomFont() customFontVisualEnabled=false; if V then V.customFontEnabled=false end end
function disableCustomFont() customFontVisualEnabled=false; if V then V.customFontEnabled=false end end
_G.Xlu0DuelsApplySavedGameplayStates = function()
pcall(function()
if setAutoTPVisual then setAutoTPVisual(autoTPEnabled == true) end
if autoTPEnabled then startAutoTP() else stopAutoTP() end
end)
pcall(function()
if setInfJumpVisual then setInfJumpVisual(infJumpEnabled == true) end
if setInfJumpInternal then setInfJumpInternal(infJumpEnabled == true) end
end)
pcall(function()
if setAntiRagdollVisual then setAntiRagdollVisual(antiRagdollEnabled == true) end
if setAntiRagdoll then setAntiRagdoll(antiRagdollEnabled == true) end
end)
pcall(function()
if _G.Xlu0AntiVoidVisual then _G.Xlu0AntiVoidVisual(_G.Xlu0AntiVoidEnabled == true) end
_G.Xlu0AntiVoidSet(_G.Xlu0AntiVoidEnabled == true)
end)
pcall(function()
if _G.Xlu0AntiResetVisual then _G.Xlu0AntiResetVisual(_G.Xlu0AntiResetEnabled == true) end
_G.Xlu0SetAntiReset(_G.Xlu0AntiResetEnabled == true)
end)
pcall(function()
if setAutoStealVisual then setAutoStealVisual(autoStealEnabled == true) end
if _G.Xlu0AutoStealSync then _G.Xlu0AutoStealSync() end
end)
pcall(function()
if setBatCounterVisual then setBatCounterVisual(batCounterEnabled == true) end
if batCounterEnabled and _G.Xlu0StartBatCounter then _G.Xlu0StartBatCounter() elseif _G.Xlu0StopBatCounter then _G.Xlu0StopBatCounter() end
end)
pcall(function()
if setMedCounterVisual then setMedCounterVisual(medCounterEnabled == true) end
if medCounterEnabled and _G.Xlu0StartMedCounter then _G.Xlu0StartMedCounter(LP.Character) elseif _G.Xlu0StopMedCounter then _G.Xlu0StopMedCounter() end
end)
pcall(function()
if _G.Xlu0SetNoPlayerCollisionVisual then _G.Xlu0SetNoPlayerCollisionVisual(_G.Xlu0NoPlayerCollisionEnabled == true) end
if _G.Xlu0NoPlayerCollisionEnabled then enableNoPlayerCollision() else disableNoPlayerCollision() end
end)
pcall(function()
if setSafeModeVisual then setSafeModeVisual(antiKickEnabled == true) end
end)
pcall(function()
if _G.Xlu0SetAutoResetOnMed then _G.Xlu0SetAutoResetOnMed(autoResetOnMedEnabled == true, true) end
end)
pcall(function()
if setPlayerESPVisual then setPlayerESPVisual(espEnabled == true) end
if espEnabled then if startPlayerESP then startPlayerESP() end else if stopPlayerESP then stopPlayerESP() end end
end)
pcall(function()
if setTracerESPVisual then setTracerESPVisual(showTracerEnabled == true) end
if BoxedESPOptions then BoxedESPOptions.tracer = showTracerEnabled == true end
if refreshBoxedESP then refreshBoxedESP() end
end)
pcall(function()
if setRagdollCountdownVisual then setRagdollCountdownVisual(ragdollCountdownEnabled == true) end
if ragdollCountdownEnabled then hookRagdollCountdown(LP.Character) else stopRagdollCountdown() end
end)
pcall(function()
if setFPSBoostVisual then setFPSBoostVisual(fpsBoostEnabled == true) end
if fpsBoostEnabled then enableStretchRez() else disableStretchRez() end
end)
pcall(function()
if setAntiLagVisual then setAntiLagVisual(antiLagVisualEnabled == true) end
if antiLagVisualEnabled then enableAntiLag() else disableAntiLag() end
end)
pcall(function()
if setNukeOptimiserVisual then setNukeOptimiserVisual(nukeOptimiserEnabled == true) end
if nukeOptimiserEnabled then enableNukeOptimizer() else disableNukeOptimizer() end
end)
pcall(function()
if setFOVVisual then setFOVVisual(fovEnabled == true) end
if fovEnabled then enableCustomFov() else disableCustomFov() end
end)
pcall(function()
if setNoCamCollisionVisual then setNoCamCollisionVisual(noCamCollisionEnabled == true) end
if noCamCollisionEnabled then enableNoCamCollision() else disableNoCamCollision() end
end)
pcall(function()
if type(applyCustomSky) == "function" then applyCustomSky((skyTheme and skyTheme ~= "") and skyTheme or "Off") end
if skyValueLabel then skyValueLabel.Text = skyTheme or "Off" end
end)
pcall(function()
if syncAnimationPackIndex then syncAnimationPackIndex() end
if refreshAnimationPackRow then refreshAnimationPackRow() end
if applySavedAnimationPackToCharacter then applySavedAnimationPackToCharacter(LP.Character) end
end)
end
task.defer(function()
task.wait(0.25)
if _G.Xlu0DuelsApplySavedGameplayStates then _G.Xlu0DuelsApplySavedGameplayStates() end
end)
task.delay(1.25, function()
if _G.Xlu0DuelsApplySavedGameplayStates then _G.Xlu0DuelsApplySavedGameplayStates() end
end)
task.delay(3, function()
if antiLagVisualEnabled and type(applyKTMOptimization) == "function" then pcall(applyKTMOptimization) end
if nukeOptimiserEnabled and type(applyKTMOptimization) == "function" then pcall(applyKTMOptimization) end
end)
_G.Xlu0AutoTPRestoreWanted = _G.Xlu0AutoTPRestoreWanted or false
_G.Xlu0AutoTPRestoreBlockedUntil = _G.Xlu0AutoTPRestoreBlockedUntil or 0
function aceAnyAimbotActive()
return (_G.Xlu0NormalAimbotOn == true) or (_G.Xlu0AntiBypassAimbotOn == true) or (_G.Xlu0AntiDesyncAimbotOn == true) or (_G.Xlu0AntiDesyncAimbotOn == true)
end
_G.Xlu0StopAutoTPForAction = function()
if autoTPEnabled then
_G.Xlu0AutoTPRestoreWanted = true
_G.Xlu0AutoTPRestoreBlockedUntil = tick() + 0.35
stopAutoTP()
if setAutoTPVisual then setAutoTPVisual(false) end
end
end
function aceTryRestoreAutoTP()
if not _G.Xlu0AutoTPRestoreWanted then return end
if tick() < (_G.Xlu0AutoTPRestoreBlockedUntil or 0) then return end
if aceAnyAimbotActive() then return end
if dropBrainrotActive then return end
_G.Xlu0AutoTPRestoreWanted = false
startAutoTP()
if setAutoTPVisual then setAutoTPVisual(true) end
do end
end
RunService.Heartbeat:Connect(aceTryRestoreAutoTP)
_G._oldXlu0StopNormalAimbot = _G.Xlu0StopNormalAimbot
_G.Xlu0StopNormalAimbot = function(...)
local r = {_G._oldXlu0StopNormalAimbot(...)}
_G.Xlu0AutoTPRestoreBlockedUntil = tick() + 0.05
task.delay(0.08, aceTryRestoreAutoTP)
return unpack(r)
end
_G.Xlu0NormalAimbotStop = _G.Xlu0StopNormalAimbot
_G._oldXlu0StopAntiBypassAimbot = _G.Xlu0StopAntiBypassAimbot
_G.Xlu0StopAntiBypassAimbot = function(...)
local r = {_G._oldXlu0StopAntiBypassAimbot(...)}
_G.Xlu0AutoTPRestoreBlockedUntil = tick() + 0.05
task.delay(0.08, aceTryRestoreAutoTP)
return unpack(r)
end
_G.Xlu0AntiBypassStop = _G.Xlu0StopAntiBypassAimbot
_G._oldXlu0StopAntiDesyncAimbot = _G.Xlu0StopAntiDesyncAimbot
_G.Xlu0StopAntiDesyncAimbot = function(...)
local r = {_G._oldXlu0StopAntiDesyncAimbot(...)}
_G.Xlu0AutoTPRestoreBlockedUntil = tick() + 0.05
task.delay(0.08, aceTryRestoreAutoTP)
return unpack(r)
end
task.spawn(function()
local wasDropping = false
while task.wait(0.05) do
if dropBrainrotActive then
wasDropping = true
elseif wasDropping then
wasDropping = false
_G.Xlu0AutoTPRestoreBlockedUntil = tick() + 0.05
task.delay(0.08, aceTryRestoreAutoTP)
end
end
end)
function aceRepairKeybinds()
for keyId, defaultKey in pairs(DEFAULT_SPEED_KEYBINDS) do
if speedKeybinds[keyId] == nil or speedKeybinds[keyId] == Enum.KeyCode.Unknown then
speedKeybinds[keyId] = defaultKey
end
end
-- TP BAT keybind boş/eski config yüzünden silinmişse V'ye geri döndür.
if speedKeybinds.AntiDesyncAimbot == nil then
speedKeybinds.AntiDesyncAimbot = Enum.KeyCode.V
end
if tpDownKeybind == Enum.KeyCode.Unknown then tpDownKeybind = DEFAULT_TP_DOWN_KEYBIND end
if refreshAllSpeedKeybinds then refreshAllSpeedKeybinds() end
if refreshTPDownKeybind then refreshTPDownKeybind() end
end
_G._oldSaveXlu0ConfigStable = saveXlu0Config
saveXlu0Config = function()
aceRepairKeybinds()
return _G._oldSaveXlu0ConfigStable()
end
aceRepairKeybinds()
task.defer(function()
task.wait(0.2)
aceRepairKeybinds()
do end
end)
task.defer(function()
task.wait(0.35)
local TS = game:GetService("TweenService")
for _, oldName in ipairs({"Xlu0MobileButtons", "Xlu0MobileButtons"}) do
local old = PlayerGui:FindFirstChild(oldName)
if old then old:Destroy() end
end
local mobileGui = Instance.new("ScreenGui")
mobileGui.Name = "Xlu0MobileButtons"
mobileGui.ResetOnSpawn = false
mobileGui.IgnoreGuiInset = true
mobileGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
mobileGui.DisplayOrder = 1000
mobileGui.Parent = PlayerGui
mobileGui.Enabled = not (_G.Xlu0HideMobileButtons == true)
_G.Xlu0MobileButtonRefs = {}
local mobileButtons = _G.Xlu0MobileButtonRefs
function _G.Xlu0ApplyMobileButtonsHidden()
local g = PlayerGui:FindFirstChild("Xlu0MobileButtons")
local shouldHide = (_G.Xlu0HideMobileButtons == true)
if g then g.Enabled = not shouldHide end
if setHideMobileButtonsVisual then
pcall(setHideMobileButtonsVisual, shouldHide)
end
end
local function normalizeMobileImage(value)
value = tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", "")
if value == "" then return "" end
local id = value:match("^(%d+)$")
if id then return "rbxassetid://" .. id end
local embedded = value:match("[?&]id=(%d+)") or value:match("/(%d+)[/%?]?")
if embedded then return "rbxassetid://" .. embedded end
return value
end
function _G.Xlu0ApplyMobileButtonImage()
local image = normalizeMobileImage(_G.Xlu0MobileButtonImage)
for _, entry in pairs(mobileButtons) do
local btn = entry and entry.btn
local img = btn and btn:FindFirstChild("MobileBackgroundImage")
if img then
img.Image = image
img.ImageColor3 = _G.Xlu0ThemeColors[_G.Xlu0ThemeName] or _G.Xlu0ThemeColors.WHITE
img.Visible = image ~= ""
end
end
end
function _G.Xlu0ApplyMobileButtonShape()
local shape = tostring(_G.Xlu0MobileButtonShape or "ROUNDED"):upper()
if shape ~= "CIRCLE" and shape ~= "SQUARE" and shape ~= "ROUNDED" then shape = "ROUNDED" end
_G.Xlu0MobileButtonShape = shape
for _, entry in pairs(mobileButtons) do
local btn = entry and entry.btn
local holder = entry and entry.holder
if btn and holder then
local isSquare = shape == "SQUARE"
holder.Size = isSquare and UDim2.new(0, 96, 0, 68) or UDim2.new(0, 84, 0, 84)
btn.Font = isSquare and Enum.Font.Bangers or Enum.Font.Arcade
btn.TextSize = isSquare and 16 or 15
local textOverlay = btn:FindFirstChild("MobileButtonText")
if textOverlay then
textOverlay.Font = btn.Font
textOverlay.TextSize = btn.TextSize
end
local radius = UDim.new(0, 22)
if shape == "CIRCLE" then radius = UDim.new(1, 0) end
if isSquare then radius = UDim.new(0, 10) end
local c = btn:FindFirstChildOfClass("UICorner")
if c then c.CornerRadius = radius end
local img = btn:FindFirstChild("MobileBackgroundImage")
local ic = img and img:FindFirstChildOfClass("UICorner")
if ic then ic.CornerRadius = radius end
local glow = holder:FindFirstChild("Glow")
local gc = glow and glow:FindFirstChildOfClass("UICorner")
if gc then gc.CornerRadius = radius end
local dot = btn:FindFirstChild("Dot")
if isSquare then
if not dot then
 dot = Instance.new("Frame")
 dot.Name = "Dot"
 dot.Size = UDim2.new(0, 6, 0, 6)
 dot.Position = UDim2.new(1, -12, 0, 7)
 dot.BackgroundColor3 = Color3.fromRGB(80,80,95)
 dot.BorderSizePixel = 0
 dot.ZIndex = btn.ZIndex + 2
 dot.Parent = btn
 Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
end
dot.Visible = true
else
if dot then dot.Visible = false end
end
end
end
end
function _G.Xlu0ApplyMobileButtonSize()
_G.Xlu0MobileButtonScale = math.clamp(tonumber(_G.Xlu0MobileButtonScale) or 1.00, 0.30, 1.35)
for _, entry in pairs(mobileButtons) do
local holder = entry and entry.holder
if holder then
local sc = holder:FindFirstChild("MobileButtonScale") or Instance.new("UIScale")
sc.Name = "MobileButtonScale"
sc.Scale = _G.Xlu0MobileButtonScale
sc.Parent = holder
end
end
pcall(function()
local gui = PlayerGui:FindFirstChild("Xlu0DuelsAdaptReconstruct") or PlayerGui:FindFirstChild("AdaptHubPolished") or PlayerGui:FindFirstChild("CyberHub")
local root = gui or PlayerGui
for _, obj in ipairs(root:GetDescendants()) do
if obj.Name == "Mobile Buttons Size" then
local valueBox = obj:FindFirstChild("Value")
if valueBox and valueBox:IsA("TextLabel") then
valueBox.Text = string.format("%.2f", _G.Xlu0MobileButtonScale)
end
end
end
end)
end
local function setActive(btn, state)
if not btn then return end
local pressed = btn:GetAttribute("Xlu0MobilePressed") == true
state = (state == true) or pressed
local visualState = state and "on" or "off"
if btn:GetAttribute("Xlu0MobileVisualState") == visualState then return end
btn:SetAttribute("Xlu0MobileVisualState", visualState)
local holder = btn.Parent
local glow = holder and holder:FindFirstChild("Glow")
local st = btn:FindFirstChildOfClass("UIStroke")
local textOverlay = btn:FindFirstChild("MobileButtonText")
local dot = btn:FindFirstChild("Dot")
TS:Create(btn, TweenInfo.new(0.18), {
BackgroundColor3 = state and Color3.fromRGB(238,238,238) or Color3.fromRGB(8,8,8),
}):Play()
if textOverlay then
TS:Create(textOverlay, TweenInfo.new(0.18), {
TextColor3 = state and Color3.fromRGB(0,0,0) or Color3.fromRGB(225,225,225),
}):Play()
end
if st then
TS:Create(st, TweenInfo.new(0.18), {
Color = state and Color3.fromRGB(190,190,190) or Color3.fromRGB(85,85,85),
Thickness = 1,
Transparency = state and 0 or 0.4,
}):Play()
end
if dot and dot.Visible then
TS:Create(dot, TweenInfo.new(0.16), {
BackgroundColor3 = state and Color3.fromRGB(0,0,0) or Color3.fromRGB(80,80,95),
}):Play()
end
if glow then
glow.Visible = false
glow.BackgroundTransparency = 1
local gs = glow:FindFirstChildOfClass("UIStroke")
if gs then gs.Transparency = 1 end
end
end
local function pulse(btn)
if not btn then return end
btn:SetAttribute("Xlu0MobilePressed", true)
setActive(btn, true)
task.delay(0.18, function()
if btn and btn.Parent then
btn:SetAttribute("Xlu0MobilePressed", false)
setActive(btn, false)
end
end)
end
local function makeButton(key, label, pos, onPress)
local holder = Instance.new("Frame")
holder.Name = "MBH_" .. key
holder.Size = UDim2.new(0, 84, 0, 84)
holder.Position = pos
holder.BackgroundTransparency = 1
holder.BorderSizePixel = 0
holder.ZIndex = 1000
holder.Active = true
holder.Parent = mobileGui
local glow = Instance.new("Frame", holder)
glow.Name = "Glow"
glow.Size = UDim2.new(1, 4, 1, 4)
glow.Position = UDim2.new(0, -2, 0, -2)
glow.BackgroundColor3 = Color3.fromRGB(255,255,255)
glow.BackgroundTransparency = 1
glow.BorderSizePixel = 0
glow.ZIndex = 1000
Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 13)
local glowStroke = Instance.new("UIStroke", glow)
glowStroke.Color = Color3.fromRGB(255,255,255)
glowStroke.Thickness = 0.8
glowStroke.Transparency = 1
glowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
local btn = Instance.new("TextButton", holder)
btn.Name = "MB_" .. key
btn.Size = UDim2.new(1, 0, 1, 0)
btn.Position = UDim2.new(0, 0, 0, 0)
btn.BackgroundColor3 = Color3.fromRGB(8,8,8)
btn.BackgroundTransparency = 0
btn.BorderSizePixel = 0
btn.Text = label
btn.TextColor3 = Color3.fromRGB(225,225,225)
btn.Font = Enum.Font.Arcade
btn.TextSize = 15
btn.TextWrapped = true
btn.AutoButtonColor = false
btn.ZIndex = 1002
btn.Active = true
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 22)
local bgImage = Instance.new("ImageLabel", btn)
bgImage.Name = "MobileBackgroundImage"
bgImage.BackgroundTransparency = 1
bgImage.BorderSizePixel = 0
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.Position = UDim2.new(0, 0, 0, 0)
bgImage.Image = normalizeMobileImage(_G.Xlu0MobileButtonImage)
bgImage.ImageColor3 = _G.Xlu0ThemeColors[_G.Xlu0ThemeName] or _G.Xlu0ThemeColors.WHITE
bgImage.ImageTransparency = 0.18
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.Visible = bgImage.Image ~= ""
bgImage.ZIndex = btn.ZIndex
local bgCorner = Instance.new("UICorner", bgImage)
bgCorner.CornerRadius = UDim.new(0, 22)
local textOverlay = Instance.new("TextLabel", btn)
textOverlay.Name = "MobileButtonText"
textOverlay.BackgroundTransparency = 1
textOverlay.Size = UDim2.new(1, -8, 1, -8)
textOverlay.Position = UDim2.new(0, 4, 0, 4)
textOverlay.Text = label
textOverlay.TextColor3 = btn.TextColor3
textOverlay.TextStrokeColor3 = Color3.fromRGB(0,0,0)
textOverlay.TextStrokeTransparency = 0.2
textOverlay.Font = btn.Font
textOverlay.TextSize = btn.TextSize
textOverlay.TextWrapped = true
textOverlay.ZIndex = btn.ZIndex + 1
btn.TextTransparency = 1
local stroke = Instance.new("UIStroke", btn)
stroke.Color = Color3.fromRGB(85,85,85)
stroke.Thickness = 1
stroke.Transparency = 0.4
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
local pressing, dragging = false, false
local pressPos, holderStart = nil, nil
btn.InputBegan:Connect(function(i)
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
pressing = true
dragging = false
pressPos = i.Position
holderStart = holder.Position
btn:SetAttribute("Xlu0MobilePressed", true)
setActive(btn, true)
pcall(function()
TS:Create(btn, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
Position = UDim2.new(0, 0, 0, 4),
Size = UDim2.new(1, 0, 1, -4)
}):Play()
end)
end
end)
btn.InputEnded:Connect(function(i)
if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
if pressing and not dragging then pcall(onPress, btn) end
if dragging then do end end
pressing = false
dragging = false
btn:SetAttribute("Xlu0MobilePressed", false)
pcall(function()
TS:Create(btn, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
Position = UDim2.new(0, 0, 0, 0),
Size = UDim2.new(1, 0, 1, 0)
}):Play()
end)
task.delay(0.08, function()
if btn and btn.Parent then
local keepOn = false
if key == "autoLeft" then keepOn = autoLeftEnabled == true
elseif key == "autoRight" then keepOn = autoRightEnabled == true
elseif key == "aimbot" then keepOn = (_G.Xlu0NormalAimbotOn == true) or (_G.Xlu0AntiBypassAimbotOn == true)
elseif key == "antiDesync" then keepOn = _G.Xlu0AntiDesyncAimbotOn == true
elseif key == "carry" then keepOn = currentSpeedMode == "Carry"
elseif key == "laggerNormal" then keepOn = currentSpeedMode == "Lagger"
elseif key == "laggerCarry" then keepOn = currentSpeedMode == "Lagger Carry"
end
setActive(btn, keepOn)
end
end)
end
end)
UserInputService.InputChanged:Connect(function(i)
if _G.Xlu0GuiLocked == true or not pressing then return end
if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
local delta = i.Position - pressPos
if not dragging and (math.abs(delta.X) > 6 or math.abs(delta.Y) > 6) then dragging = true end
if dragging then
holder.Position = UDim2.new(holderStart.X.Scale, holderStart.X.Offset + delta.X, holderStart.Y.Scale, holderStart.Y.Offset + delta.Y)
end
end)
mobileButtons[key] = {holder = holder, btn = btn, setActive = function(state) setActive(btn, state) end}
return btn
end
local x1, x2 = -218, -140
local y1, y2, y3, y4 = -150, -78, -6, 66
local defaults = {
insta     = UDim2.new(1, x1, 0.5, y1),
drop      = UDim2.new(1, x2, 0.5, y1),
autoLeft  = UDim2.new(1, x1, 0.5, y2),
autoRight = UDim2.new(1, x2, 0.5, y2),
aimbot      = UDim2.new(1, x1, 0.5, y3),
tp          = UDim2.new(1, x2, 0.5, y3),
carry       = UDim2.new(1, x1, 0.5, y4),
antiDesync  = UDim2.new(1, x2, 0.5, y4),
}

function _G.Xlu0ResetMobileButtons()
_G.Xlu0MobileButtonScale = Xlu0AutoMobile and 0.90 or 1.00
_G.Xlu0MobileButtonImage = ""
_G.Xlu0HideMobileButtons = false
_G.Xlu0MobileButtonShape = "ROUNDED"
for key, defaultPos in pairs(defaults) do
local entry = mobileButtons[key]
local holder = entry and entry.holder
if holder then
holder.Position = defaultPos
end
end
_G.Xlu0ApplyMobileButtonSize()
_G.Xlu0ApplyMobileButtonsHidden()
_G.Xlu0ApplyMobileButtonShape()
_G.Xlu0ApplyMobileButtonImage()
_G.Xlu0ApplyMobileButtonShape()
do end
end

makeButton("drop", "DROP\nBR", defaults.drop, function(btn)
if runDropBrainrot then runDropBrainrot() elseif runDrop then runDrop() end
pulse(btn)
end)

makeButton("autoLeft", "AUTO\nLEFT", defaults.autoLeft, function()
if _G.Xlu0SetAutoLeft then _G.Xlu0SetAutoLeft(not autoLeftEnabled) end
end)

makeButton("aimbot", "AIM\nBOT", defaults.aimbot, function(btn)
if _G.Xlu0SafeModeIsLocked and _G.Xlu0SafeModeIsLocked() then return end
selectedAimbotMode = "Normal"
if _G.Xlu0ToggleSelectedAimbot then _G.Xlu0ToggleSelectedAimbot() end
task.delay(0.03, function()
setActive(btn, _G.Xlu0NormalAimbotOn == true)
end)
end)

makeButton("autoRight", "AUTO\nRIGHT", defaults.autoRight, function()
if _G.Xlu0SetAutoRight then _G.Xlu0SetAutoRight(not autoRightEnabled) end
end)

makeButton("antiDesync", "TP\nBAT", defaults.antiDesync, function(btn)
if _G.Xlu0SafeModeIsLocked and _G.Xlu0SafeModeIsLocked() then return end
if _G.Xlu0ToggleAntiDesyncAimbot then
_G.Xlu0ToggleAntiDesyncAimbot()
end
task.delay(0.03, function()
setActive(btn, _G.Xlu0AntiDesyncAimbotOn == true)
end)
end)

makeButton("tp", "TP\nDOWN", defaults.tp, function(btn)
if runTPFloor then runTPFloor() end
pulse(btn)
end)

makeButton("carry", "CARRY\nSPD", defaults.carry, function()
if setSpeedMode then
setSpeedMode(currentSpeedMode == "Carry" and "Normal" or "Carry")
end
end)

makeButton("insta", "INSTA\nRESET", defaults.insta, function(btn)
if _G.Xlu0CursedInstaReset then
_G.Xlu0CursedInstaReset()
elseif cursedInstaReset then
cursedInstaReset()
end
pulse(btn)
end)

_G.Xlu0ApplyMobileButtonSize()
_G.Xlu0ApplyMobileButtonsHidden()

RunService.Heartbeat:Connect(function()
if mobileButtons.autoLeft then mobileButtons.autoLeft.setActive(autoLeftEnabled == true) end
if mobileButtons.autoRight then mobileButtons.autoRight.setActive(autoRightEnabled == true) end
if mobileButtons.aimbot then mobileButtons.aimbot.setActive(_G.Xlu0NormalAimbotOn == true) end
if mobileButtons.antiDesync then mobileButtons.antiDesync.setActive(_G.Xlu0AntiDesyncAimbotOn == true) end
if mobileButtons.carry then mobileButtons.carry.setActive(currentSpeedMode == "Carry") end
end)
end)

--// Modern Ragdoll End Time UI
do
-- Servisler ve Değişkenler
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local ragdollGuiEnabled = true
local activeBatBillboard = nil

-- Modern renk paleti
local COLORS = {
    BackgroundTop = Color3.fromRGB(22, 18, 28),
    BackgroundBottom = Color3.fromRGB(10, 8, 14),
    Accent = Color3.fromRGB(255, 255, 255),
    AccentSoft = Color3.fromRGB(220, 220, 220),
    White = Color3.fromRGB(250, 250, 255),
    Muted = Color3.fromRGB(175, 167, 185),
    Shadow = Color3.fromRGB(0, 0, 0),
}

-- Yavaş shimmer
local function addShimmerToLabel(textLabel, primaryColor, shimmerColor)
    local gradient = Instance.new("UIGradient")
    gradient.Name = "ModernShimmer"
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, primaryColor),
        ColorSequenceKeypoint.new(0.36, primaryColor),
        ColorSequenceKeypoint.new(0.50, shimmerColor),
        ColorSequenceKeypoint.new(0.64, primaryColor),
        ColorSequenceKeypoint.new(1.00, primaryColor),
    })
    gradient.Offset = Vector2.new(-1.2, 0)
    gradient.Parent = textLabel

    task.spawn(function()
        while textLabel.Parent and gradient.Parent do
            gradient.Offset = Vector2.new(-1.2, 0)
            local tween = TweenService:Create(
                gradient,
                TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {Offset = Vector2.new(1.2, 0)}
            )
            tween:Play()
            tween.Completed:Wait()
            task.wait(0.8)
        end
    end)

    return gradient
end

local function createModernStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.Transparency = transparency
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

-- Modern Ragdoll Timer
local function createRagdollBillboard(duration, labelText, color)
    if not ragdollGuiEnabled then return nil end

    local accent = color or COLORS.Accent
    local guiName = "Xlu0ModernTimer_" .. tostring(labelText)

    pcall(function()
        local coreGui = game:GetService("CoreGui")
        local oldCore = coreGui:FindFirstChild(guiName)
        if oldCore then oldCore:Destroy() end

        local playerGui = LP:FindFirstChild("PlayerGui")
        if playerGui then
            local oldPlayer = playerGui:FindFirstChild(guiName)
            if oldPlayer then oldPlayer:Destroy() end
        end
    end)

    local sg = Instance.new("ScreenGui")
    sg.Name = guiName
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 1000

    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(sg)
        end
    end)

    if not pcall(function()
        sg.Parent = game:GetService("CoreGui")
    end) then
        sg.Parent = LP:WaitForChild("PlayerGui")
    end

    -- Ana taşıyıcı
    local holder = Instance.new("Frame")
    holder.Name = "ModernTimerHolder"
    holder.AnchorPoint = Vector2.new(0.5, 0)
    holder.Position = UDim2.new(0.5, 0, 0, 42)
    holder.Size = UDim2.new(0, 300, 0, 112)
    holder.BackgroundTransparency = 1
    holder.Parent = sg

    -- Kart
    local card = Instance.new("Frame")
    card.Name = "Card"
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.new(0.5, 0, 0.5, 0)
    card.Size = UDim2.new(1, 0, 1, 0)
    card.BackgroundColor3 = COLORS.BackgroundTop
    card.BackgroundTransparency = 0.06
    card.BorderSizePixel = 0
    card.ZIndex = 2
    card.Active = true
    card.Parent = holder
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 22)

    local cardGradient = Instance.new("UIGradient")
    cardGradient.Rotation = 90
    cardGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLORS.BackgroundTop),
        ColorSequenceKeypoint.new(1, COLORS.BackgroundBottom),
    })
    cardGradient.Parent = card

    -- Kart arka plan resmi
    local cardImage = Instance.new("ImageLabel")
    cardImage.Name = "CardBackgroundImage"
    cardImage.Size = UDim2.new(1, 0, 1, 0)
    cardImage.Position = UDim2.new(0, 0, 0, 0)
    cardImage.BackgroundTransparency = 1
    cardImage.Image = "rbxassetid://85127407374728"
    cardImage.ScaleType = Enum.ScaleType.Crop
    cardImage.ImageTransparency = 0.42
    cardImage.ZIndex = 3
    cardImage.ClipsDescendants = true
    cardImage.Parent = card
    Instance.new("UICorner", cardImage).CornerRadius = UDim.new(0, 22)

    local imageFade = Instance.new("UIGradient")
    imageFade.Rotation = 0
    imageFade.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0.00, 0.18),
        NumberSequenceKeypoint.new(0.58, 0.48),
        NumberSequenceKeypoint.new(1.00, 0.88),
    })
    imageFade.Parent = cardImage

    local stroke = createModernStroke(card, accent, 1.6, 0.18)

    -- Başlık
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -32, 0, 32)
    titleLbl.Position = UDim2.new(0, 18, 0, 16)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = (labelText == "RAGDOLL" and "RAGDOLL END TIME" or tostring(labelText) .. " TIMER")
    titleLbl.TextColor3 = COLORS.White
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 18
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 7
    titleLbl.Parent = card

    -- Timer
    local timerLbl = Instance.new("TextLabel")
    timerLbl.Size = UDim2.new(0, 100, 0, 42)
    timerLbl.AnchorPoint = Vector2.new(1, 0.5)
    timerLbl.Position = UDim2.new(1, -18, 0.5, 12)
    timerLbl.BackgroundTransparency = 1
    timerLbl.Text = string.format("%.1f", duration) .. "s"
    timerLbl.TextColor3 = accent
    timerLbl.Font = Enum.Font.GothamBlack
    timerLbl.TextSize = 32
    timerLbl.TextXAlignment = Enum.TextXAlignment.Right
    timerLbl.ZIndex = 7
    timerLbl.Parent = card

    addShimmerToLabel(timerLbl, accent, COLORS.White)

    -- Alt progress bar
    local progressBack = Instance.new("Frame")
    progressBack.Size = UDim2.new(1, -36, 0, 5)
    progressBack.Position = UDim2.new(0, 18, 1, -16)
    progressBack.BackgroundColor3 = Color3.fromRGB(50, 44, 58)
    progressBack.BackgroundTransparency = 0.2
    progressBack.BorderSizePixel = 0
    progressBack.ZIndex = 7
    progressBack.Parent = card
    Instance.new("UICorner", progressBack).CornerRadius = UDim.new(1, 0)

    local progress = Instance.new("Frame")
    progress.Size = UDim2.new(1, 0, 1, 0)
    progress.BackgroundColor3 = accent
    progress.BorderSizePixel = 0
    progress.ZIndex = 8
    progress.Parent = progressBack
    Instance.new("UICorner", progress).CornerRadius = UDim.new(1, 0)

    local progressGradient = Instance.new("UIGradient")
    progressGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLORS.AccentSoft),
        ColorSequenceKeypoint.new(1, accent),
    })
    progressGradient.Parent = progress

    -- Giriş animasyonu
    holder.Position = UDim2.new(0.5, 0, 0, 12)
    holder.Size = UDim2.new(0, 250, 0, 86)
    card.BackgroundTransparency = 1

    TweenService:Create(
        holder,
        TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {
            Position = UDim2.new(0.5, 0, 0, 42),
            Size = UDim2.new(0, 300, 0, 112),
        }
    ):Play()

    TweenService:Create(card, TweenInfo.new(0.35), {BackgroundTransparency = 0.06}):Play()

    -- Kenarlık pulse
    task.spawn(function()
        while stroke.Parent do
            TweenService:Create(stroke, TweenInfo.new(0.8), {Transparency = 0.38}):Play()
            task.wait(0.8)
            TweenService:Create(stroke, TweenInfo.new(0.8), {Transparency = 0.12}):Play()
            task.wait(0.8)
        end
    end)

    -- Sürükleme
    local dragging = false
    local dragStart
    local startPos

    card.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = holder.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not dragging then return end

        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            holder.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Geri sayım
    local startTime = tick()
    local connection

    connection = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        local remaining = math.max(0, duration - elapsed)
        local ratio = math.clamp(remaining / duration, 0, 1)

        if timerLbl.Parent then
            timerLbl.Text = string.format("%.1f", remaining) .. "s"
        end

        if progress.Parent then
            progress.Size = UDim2.new(ratio, 0, 1, 0)
        end

        if remaining <= 0 then
            connection:Disconnect()

            TweenService:Create(
                holder,
                TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
                {
                    Position = UDim2.new(0.5, 0, 0, 12),
                    Size = UDim2.new(0, 250, 0, 86),
                }
            ):Play()

            TweenService:Create(card, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()

            task.delay(0.32, function()
                pcall(function()
                    sg:Destroy()
                end)
            end)
        end
    end)

    return sg
end

-- Humanoid Durum Kontrolü
local function onHumanoidStateChanged(_, newState)
    local char = LP.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local isRagdoll =
        newState == Enum.HumanoidStateType.Physics
        or newState == Enum.HumanoidStateType.Ragdoll
        or newState == Enum.HumanoidStateType.FallingDown

    if isRagdoll and not hum.PlatformStand and not activeBatBillboard then
        activeBatBillboard = createRagdollBillboard(
            2.6,
            "RAGDOLL",
            COLORS.Accent
        )

        task.delay(2.9, function()
            if activeBatBillboard then
                pcall(function()
                    activeBatBillboard:Destroy()
                end)
                activeBatBillboard = nil
            end
        end)
    end
end

local function hookCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.StateChanged:Connect(onHumanoidStateChanged)
end

LP.CharacterAdded:Connect(hookCharacter)

if LP.Character then
    task.spawn(hookCharacter, LP.Character)
end
end

task.defer(function()
task.wait(1)
pcall(function()
_G.Xlu0ApplyMovingEdgeLights(PlayerGui)
end)
end)