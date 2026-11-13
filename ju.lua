local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local ContextActionService = game:GetService("ContextActionService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local VirtualInput = Instance.new("VirtualInputManager")

local cloneref = (type(cloneref) == "function" and cloneref)
    or (syn and type(syn.cloneref) == "function" and syn.cloneref)
    or function(instance) return instance end

-- GUI PARENT (gethui -> CoreGui)
local function getGuiParent()
    local parent
    pcall(function()
        if type(gethui) == "function" then
            parent = gethui()
        end
    end)
    return parent or CoreGui
end

local HIDDEN_GUI = getGuiParent()

local function protectGui(gui)
    if not gui then return end
    pcall(function()
        if type(protect_gui) == "function" then
            protect_gui(gui)
        elseif syn and type(syn.protect_gui) == "function" then
            syn.protect_gui(gui)
        end
    end)
end

local ActiveConnections = {}
local thisScriptStopped = false

-- INSTANT RESET
local RESET_MAX_DURATION = 0.05
local resetCooldown = false
local resetThread = nil
local currentCharacter = nil
local resetSuccessful = false
local stopResetSequence = false
local cameraLocked = false
local lockedCameraCFrame = nil
local resetLockId = 0

local function forceUnlockEverything()
    cameraLocked = false
    lockedCameraCFrame = nil
    stopResetSequence = true
    resetCooldown = false
    currentCharacter = nil
    pcall(function()
        if resetThread then task.cancel(resetThread) end
    end)
    resetThread = nil
    pcall(function()
        local cam = workspace.CurrentCamera
        if cam then
            cam.CameraType = Enum.CameraType.Custom
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then cam.CameraSubject = hum end
        end
    end)
    local char = LocalPlayer.Character
    if char then
        pcall(function()
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                if hum.HipHeight > 10 or hum.HipHeight < 0 then hum.HipHeight = 2 end
                hum.PlatformStand = false
                hum.Sit = false
                hum.AutoRotate = true
            end
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then root.CanCollide = true end
            for _, p in ipairs(char:GetChildren()) do
                if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                    p.CanCollide = true
                end
            end
        end)
    end
end

_G.HugoForceUnlock = forceUnlockEverything

local function _resetIsAnyBase(plot)
    if not plot or not plot:IsA("Model") then return false end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local ok, cf, size = pcall(function() return plot:GetBoundingBox() end)
    if not ok or not cf or not size then return false end
    local pos = cf:PointToObjectSpace(root.Position)
    return math.abs(pos.X) <= size.X / 2 + 5 and math.abs(pos.Z) <= size.Z / 2 + 5
end

local function _equipResetCarpet()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if not char or not hum then return false end

    local carpet
    local function match(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local n = tool.Name:lower():gsub("%s+", " ")
        return n:find("carpet", 1, true) ~= nil
            or n:find("flying carpet", 1, true) ~= nil
            or n:find("carpet flying", 1, true) ~= nil
            or n:find("magic carpet", 1, true) ~= nil
    end
    for _, tool in ipairs(char:GetChildren()) do
        if match(tool) then carpet = tool break end
    end
    if not carpet and backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if match(tool) then carpet = tool break end
        end
    end
    if not carpet then return false end

    pcall(function()
        if carpet.Parent ~= char then hum:EquipTool(carpet) end
    end)
    local deadline = tick() + 0.5
    while carpet.Parent ~= char and tick() < deadline do task.wait() end
    return carpet.Parent == char
end

local function ResetPlayer()
    if resetCooldown then return end
    resetCooldown = true
    resetSuccessful = false
    stopResetSequence = false

    local character = LocalPlayer.Character
    if not character then resetCooldown = false return end

    -- Equipa o carpet primeiro; se não houver um disponível, o reset continua normalmente.
    pcall(_equipResetCarpet)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then resetCooldown = false return end

    resetLockId = resetLockId + 1
    local myLockId = resetLockId

    local camera = workspace.CurrentCamera
    if camera then
        lockedCameraCFrame = camera.CFrame
        cameraLocked = true
        camera.CameraType = Enum.CameraType.Scriptable
        camera.CFrame = lockedCameraCFrame
    end

    currentCharacter = character
    local originalHipHeight = humanoid.HipHeight
    if type(originalHipHeight) ~= "number" or originalHipHeight > 10 or originalHipHeight < 0 then
        originalHipHeight = 2
    end
    local isRespawning = false

    resetThread = task.spawn(function()
        local attempts = 0
        local maxAttempts = 25
        while character and character.Parent and humanoid and humanoid.Health > 0
            and not isRespawning and not stopResetSequence and myLockId == resetLockId do
            if LocalPlayer.Character ~= character then isRespawning = true break end
            pcall(function()
                humanoid.HipHeight = 1e30
                humanoid.AutoRotate = true
                local root = character:FindFirstChild("HumanoidRootPart")
                if root then root.CanCollide = false end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = false
                    end
                end
            end)
            if not character.Parent or humanoid.Health <= 0 or LocalPlayer.Character ~= character then
                resetSuccessful = true break
            end
            attempts = attempts + 1
            if attempts >= maxAttempts then break end
            task.wait(RESET_MAX_DURATION)
        end
        if character and character.Parent and humanoid then
            pcall(function() humanoid.HipHeight = originalHipHeight end)
        end
        if not resetSuccessful and not isRespawning and myLockId == resetLockId and not stopResetSequence then
            if character and character.Parent and humanoid and humanoid.Health > 0 then
                pcall(function() humanoid.Health = 0 end)
                task.wait(0.1)
                if not character.Parent or humanoid.Health <= 0 then resetSuccessful = true end
            end
        end
        if not resetSuccessful and character and character.Parent and myLockId == resetLockId then
            pcall(function()
                humanoid.HipHeight = originalHipHeight
                humanoid.PlatformStand = false
                humanoid.AutoRotate = true
                local root = character:FindFirstChild("HumanoidRootPart")
                if root then root.CanCollide = true end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end)
        end
        if myLockId == resetLockId then
            cameraLocked = false
            lockedCameraCFrame = nil
            resetCooldown = false
            resetThread = nil
            currentCharacter = nil
            stopResetSequence = false
            pcall(function()
                local cam = workspace.CurrentCamera
                if cam then
                    cam.CameraType = Enum.CameraType.Custom
                    local newChar = LocalPlayer.Character
                    local newHum = newChar and newChar:FindFirstChildOfClass("Humanoid")
                    if newHum then cam.CameraSubject = newHum end
                end
            end)
        end
    end)
end

local function StopResetSequence()
    forceUnlockEverything()
end

table.insert(ActiveConnections, LocalPlayer.CharacterAdded:Connect(function(newChar)
    resetLockId = resetLockId + 1
    forceUnlockEverything()
    resetSuccessful = false
    task.defer(function()
        task.wait(0.2)
        forceUnlockEverything()
        if newChar and newChar.Parent then
            pcall(function()
                local hum = newChar:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.HipHeight = 2
                    hum.PlatformStand = false
                    hum.AutoRotate = true
                end
                local cam = workspace.CurrentCamera
                if cam then
                    cam.CameraType = Enum.CameraType.Custom
                    cam.CameraSubject = hum
                end
            end)
        end
    end)
end))

task.spawn(function()
    while true do
        task.wait(0.016)
        if cameraLocked and lockedCameraCFrame then
            local camera = workspace.CurrentCamera
            if camera then
                camera.CameraType = Enum.CameraType.Scriptable
                camera.CFrame = lockedCameraCFrame
            end
        end
    end
end)

-- AUTO RESET (Balloon / Tiny / Jail)
do
    local cooldown = false
    local function tryReset()
        if cooldown or resetCooldown or thisScriptStopped then return end
        cooldown = true
        pcall(ResetPlayer)
        task.delay(1.2, function() cooldown = false end)
    end
    local function isBallooned(char)
        if not char then return false end
        if char:FindFirstChild("Balloon") or char:FindFirstChild("BalloonConstraint") then return true end
        for _, d in ipairs(char:GetDescendants()) do
            local n = string.lower(d.Name)
            if n:find("balloon") then return true end
        end
        if LocalPlayer:GetAttribute("jump higher") or LocalPlayer:GetAttribute("JumpHigher") then return true end
        if char:GetAttribute("jump higher") or char:GetAttribute("JumpHigher") then return true end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if hum:GetAttribute("jump higher") or hum:GetAttribute("JumpHigher") then return true end
            if hum.JumpHeight and hum.JumpHeight > 15 then return true end
        end
        return false
    end
    local function isTiny(char)
        if not char then return false end
        if char:FindFirstChild("Tiny") then return true end
        local scale = char:GetAttribute("Scale") or char:GetAttribute("Tiny") or char:GetAttribute("IsTiny")
        if type(scale) == "boolean" and scale then return true end
        if type(scale) == "number" and scale < 0.7 then return true end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            local hs = hum:FindFirstChild("BodyHeightScale")
            if hs and hs:IsA("NumberValue") and hs.Value < 0.7 then return true end
            if hum:GetAttribute("Tiny") or hum:GetAttribute("IsTiny") then return true end
        end
        for _, d in ipairs(char:GetChildren()) do
            if string.lower(d.Name):find("tiny") then return true end
        end
        return false
    end
    local function isJailed(char)
        if not char then return false end
        if LocalPlayer:GetAttribute("Jailed") or LocalPlayer:GetAttribute("Jail") or LocalPlayer:GetAttribute("InJail") then return true end
        if char:GetAttribute("Jailed") or char:GetAttribute("Jail") or char:GetAttribute("InJail") then return true end
        if char:FindFirstChild("Jail") or char:FindFirstChild("Jailed") then return true end
        for _, d in ipairs(char:GetChildren()) do
            if string.lower(d.Name):find("jail") then return true end
        end
        return false
    end
    local function hook(char)
        if not char then return end
        table.insert(ActiveConnections, char.DescendantAdded:Connect(function(obj)
            if thisScriptStopped then return end
            local n = string.lower(obj.Name or "")
            if _G.AutoResetOnBalloon and n:find("balloon") then tryReset()
            elseif _G.AutoResetOnTiny and n:find("tiny") then tryReset()
            elseif _G.AutoResetOnJail and n:find("jail") then tryReset()
            end
        end))
        local function watch(inst, attr, flag)
            pcall(function()
                table.insert(ActiveConnections, inst:GetAttributeChangedSignal(attr):Connect(function()
                    if thisScriptStopped or not _G[flag] then return end
                    if inst:GetAttribute(attr) then tryReset() end
                end))
            end)
        end
        for _, a in ipairs({"jump higher", "JumpHigher", "Balloon", "Ballooned"}) do
            watch(LocalPlayer, a, "AutoResetOnBalloon")
            watch(char, a, "AutoResetOnBalloon")
        end
        for _, a in ipairs({"Tiny", "IsTiny", "Scale"}) do
            watch(LocalPlayer, a, "AutoResetOnTiny")
            watch(char, a, "AutoResetOnTiny")
        end
        for _, a in ipairs({"Jailed", "Jail", "InJail"}) do
            watch(LocalPlayer, a, "AutoResetOnJail")
            watch(char, a, "AutoResetOnJail")
        end
    end
    task.spawn(function()
        while not thisScriptStopped do
            task.wait(0.2)
            local char = LocalPlayer.Character
            if char then
                if _G.AutoResetOnBalloon and isBallooned(char) then tryReset()
                elseif _G.AutoResetOnTiny and isTiny(char) then tryReset()
                elseif _G.AutoResetOnJail and isJailed(char) then tryReset()
                end
            end
        end
    end)
    table.insert(ActiveConnections, LocalPlayer.CharacterAdded:Connect(function(c)
        task.defer(function() task.wait(0.15) hook(c) end)
    end))
    if LocalPlayer.Character then
        task.defer(function() hook(LocalPlayer.Character) end)
    end
end

-- PING LAGGER
_G.LaggerOnFlash = _G.LaggerOnFlash or false
_G.LaggerPower = _G.LaggerPower or 50
local laggerActive = false

local function startFlashLagger()
    if not _G.LaggerOnFlash or laggerActive then return end
    laggerActive = true
    task.spawn(function()
        if not _G.LaggerOnFlash then laggerActive = false return end
        local strength = math.clamp(_G.LaggerPower / 30, 0.2, 3.0)
        pcall(function() settings().Network.IncomingReplicationLag = strength end)
        task.wait(2.5)
        pcall(function() settings().Network.IncomingReplicationLag = 0 end)
        laggerActive = false
    end)
end
local function stopFlashLagger()
    laggerActive = false
    pcall(function() settings().Network.IncomingReplicationLag = 0 end)
end

-- FLASH SPEED (dynamic: 200 sem TP V2, 800 com)
local FLASH_SPEED_MAX_BASE = 200
local FLASH_SPEED_MAX_TPV2 = 800
_G.FlashSpeed = _G.FlashSpeed or 150
local function getFlashSpeed()
    local maxV = _G.TPV2 and FLASH_SPEED_MAX_TPV2 or FLASH_SPEED_MAX_BASE
    local v = _G.FlashSpeed or 150
    if v > maxV then v = maxV end
    return v
end
local function getMaxFlashSpeed()
    return _G.TPV2 and FLASH_SPEED_MAX_TPV2 or FLASH_SPEED_MAX_BASE
end

-- SAFE ZONE
local FLASH_SAFE_ZONE = { minX = -337.34, maxX = -294.05, minZ = 91.94, maxZ = 135.06 }
local FLASH_SAFE_POS = Vector3.new(-356.39, -6.10, 100.21)
local function isInFlashSafeZone(pos)
    if not pos then return false end
    return pos.X >= FLASH_SAFE_ZONE.minX and pos.X <= FLASH_SAFE_ZONE.maxX
       and pos.Z >= FLASH_SAFE_ZONE.minZ and pos.Z <= FLASH_SAFE_ZONE.maxZ
end

-- SLOTS CONFIG
local SlotsConfig = {
    [1] = { Positions = { Vector3.new(-345.4766,-6.0291,1.5014) }, CamOffset = Vector3.new(-354.1492,4.0350,9.3823)-Vector3.new(-345.4766,-6.0291,1.5014), CamAngles = {-0.827500,-0.640100,-0.576243} },
    [2] = { Positions = { Vector3.new(-349.9259,-6.2791,-1.5767) }, CamOffset = Vector3.new(-363.2081,2.9403,3.3074)-Vector3.new(-349.9259,-6.2791,-1.5767), CamAngles = {-1.007271,-0.967909,-0.916433} },
    [3] = { Positions = { Vector3.new(-349.9259,-6.2791,-1.5758) }, CamOffset = Vector3.new(-367.7556,4.3232,3.4983)-Vector3.new(-349.9259,-6.2791,-1.5758), CamAngles = {-1.062718,-1.041500,-0.997864} },
    [4] = { Positions = { Vector3.new(-343.4199,-5.9197,10.5505) }, CamOffset = Vector3.new(-359.0885,4.0544,21.0001)-Vector3.new(-343.4199,-5.9197,10.5505), CamAngles = {-0.681953,-0.861073,-0.551998} },
    [5] = { Positions = { Vector3.new(-343.7608,-6.3272,-9.7994) }, CamOffset = Vector3.new(-363.9226,-0.3924,-9.1459)-Vector3.new(-343.7608,-6.3272,-9.7994), CamAngles = {-1.424811,-1.351549,-1.421283} },
    [6] = { Positions = { Vector3.new(-353.820709,-7.3017997,56.7122993), Vector3.new(-317.9427,-7.002,60.7723) }, CamOffset = Vector3.new(-298.584991,3.38974237,49.2246361)-Vector3.new(-300.422119,-7.30179977,34.2573051), CamAngles = {0,0.06,0}, FixedCFrame = CFrame.new(-323.0857,-2.2188,71.682)*CFrame.Angles(0,math.atan2(-0.4114,0.8728),0) },
    [7] = { Positions = { Vector3.new(-344.4383,-6.4281,41.8672) }, CamOffset = Vector3.new(-362.8094,-3.2299,51.1552)-Vector3.new(-344.4383,-6.4281,41.8672), CamAngles = {-0.181885,-1.095968,-0.162135} },
    [8] = { Positions = { Vector3.new(-348.5228,-6.4281,48.1022) }, CamOffset = Vector3.new(-369.4075,-0.1123,63.3763)-Vector3.new(-348.5228,-6.4281,48.1022), CamAngles = {-0.306020,-0.916511,-0.245634} },
    [9] = { Positions = { Vector3.new(-339.6349,-6.4281,60.4164) }, CamOffset = Vector3.new(-349.9293,-1.6218,84.4119)-Vector3.new(-339.6349,-6.4281,60.4164), CamAngles = {-0.137335,-0.401849,-0.054002} },
    [10] = { Positions = { Vector3.new(-355.3322,-6.4281,25.3526) }, CamOffset = Vector3.new(-377.7117,8.9106,25.7208)-Vector3.new(-355.3322,-6.4281,25.3526), CamAngles = {-1.544218,-1.016502,-1.539540} },
    [11] = { Positions = { Vector3.new(-354.9932,-6.4281,-47.3879), Vector3.new(-331.5262,-6.4281,-47.3607) }, CamOffset = Vector3.new(-333.2372,-9.9613,-64.2099)-Vector3.new(-331.5262,-6.4281,-47.3607), CamAngles = {2.851853,-0.097011,3.112724} },
    [12] = { Positions = { Vector3.new(-354.9584,-6.4208,-42.6520), Vector3.new(-338.7290,-6.4281,-43.4713) }, CamOffset = Vector3.new(-346.9807,-9.9578,-60.5865)-Vector3.new(-338.7290,-6.4281,-43.4713), CamAngles = {2.856299,-0.433315,3.019061} },
    [13] = { Positions = { Vector3.new(-354.8862,-6.2793,-37.9787), Vector3.new(-334.5183,-6.4281,-41.6819) }, CamOffset = Vector3.new(-343.9747,-9.9590,-57.3332)-Vector3.new(-334.5183,-6.4281,-41.6819), CamAngles = {2.831168,-0.522070,2.982964} },
    [14] = { Positions = { Vector3.new(-351.8463,-6.5022,-37.0529), Vector3.new(-319.8298,-6.4281,-45.1476) }, CamOffset = Vector3.new(-325.1408,-9.9618,-60.9837)-Vector3.new(-319.8298,-6.4281,-45.1476), CamAngles = {2.834406,-0.309406,3.045298} },
    [15] = { Positions = { Vector3.new(-351.0894,-6.2833,-32.7751), Vector3.new(-317.9170,-6.4281,-41.9999) }, CamOffset = Vector3.new(-327.9996,-9.9581,-57.8876)-Vector3.new(-317.9170,-6.4281,-41.9999), CamAngles = {2.835549,-0.544183,2.979445} },
    [16] = { Positions = { Vector3.new(-338.2857,-6.4281,57.2060) }, CamOffset = Vector3.new(-341.5551,-9.9642,72.3530)-Vector3.new(-338.2857,-6.4281,57.2060), CamAngles = {0.320392,-0.202067,0.066497} },
    [17] = { Positions = { Vector3.new(-337.9285,-6.4281,55.1757) }, CamOffset = Vector3.new(-344.4950,-9.9637,69.4787)-Vector3.new(-337.9285,-6.4281,55.1757), CamAngles = {0.337895,-0.408747,0.138758} },
    [18] = { Positions = { Vector3.new(-332.1088,-6.4281,53.1675) }, CamOffset = Vector3.new(-338.8290,-9.9674,65.6692)-Vector3.new(-332.1088,-6.4281,53.1675), CamAngles = {0.382481,-0.462609,0.177644} },
    [19] = { Positions = { Vector3.new(-347.9923,-6.2933,-34.0232), Vector3.new(-328.5790,-6.4281,-35.0857) }, CamOffset = Vector3.new(-328.6130,-10.0174,-40.4923)-Vector3.new(-328.5790,-6.4281,-35.0857), CamAngles = {2.387391,-0.004579,3.137291} },
    [20] = { Positions = { Vector3.new(-355.0801,-6.4404,-33.2302), Vector3.new(-321.5783,-6.4281,-33.5778) }, CamOffset = Vector3.new(-321.6123,-10.0174,-38.9844)-Vector3.new(-321.5783,-6.4281,-33.5778), CamAngles = {2.387391,-0.004579,3.137291} },
    [21] = { Positions = { Vector3.new(-351.5396,-7.5033,-41.797), Vector3.new(-314.088,-7.5033,-32.1806) }, CamOffset = Vector3.new(-314.1147,-10.0174,-36.4214)-Vector3.new(-314.088,-7.5033,-32.1806), CamAngles = {2.387391,-0.004579,3.137291}, NeedJump = true },
    [22] = { Positions = { Vector3.new(-351.5396,-7.5033,-41.797), Vector3.new(-306.8919,-7.5033,-33.9124) }, CamOffset = Vector3.new(-306.923,-10.008,-38.86)-Vector3.new(-306.8919,-7.5033,-33.9124), CamAngles = {2.4648,-0.004898,3.137657}, NeedJump = true },
    [23] = { Positions = { Vector3.new(-351.5396,-7.5033,-41.797), Vector3.new(-300.2759,-7.5033,-32.7047) }, CamOffset = Vector3.new(-300.4669,-10.016,-37.044)-Vector3.new(-300.2759,-7.5033,-32.7047), CamAngles = {2.399014,-0.032413,3.111857}, NeedJump = true },
    [24] = { Positions = { Vector3.new(-348.2407,-7.5033,74.3719), Vector3.new(-330.0484,-7.5033,48.183) }, CamOffset = Vector3.new(-330.1124,-10.0063,53.2779)-Vector3.new(-330.0484,-7.5033,48.183), CamAngles = {0.662308,-0.00991,0.007727}, NeedJump = true },
    [25] = { Positions = { Vector3.new(-348.2407,-7.5033,74.3719), Vector3.new(-325.4576,-7.5033,46.8182) }, CamOffset = Vector3.new(-326.0541,-10.0104,51.5397)-Vector3.new(-325.4576,-7.5033,46.8182), CamAngles = {0.700033,-0.09632,0.080833}, NeedJump = true },
    [26] = { Positions = { Vector3.new(-348.2407,-7.5033,74.3719), Vector3.new(-324.6721,-7.5033,47.2033) }, CamOffset = Vector3.new(-326.6859,-10.0057,51.9385)-Vector3.new(-324.6721,-7.5033,47.2033), CamAngles = {0.698024,-0.314979,0.254268}, NeedJump = true },
    [27] = { Positions = { Vector3.new(-348.2407,-7.5033,74.3719), Vector3.new(-320.4196,-7.5033,44.1) }, CamOffset = Vector3.new(-322.9213,-10.0122,49.5157)-Vector3.new(-320.4196,-7.5033,44.1), CamAngles = {0.876985,-0.422603,0.397417} },
}

-- 67 AUTO GRAB (integrado)
_G.HighAutoGrab = (function()
    local M = {
        enabled = false,
        radius = 100,
        delay = 1.30,
        halfFireRange = 12,
        halfHoldMin = 1.3,
        halfHoldMax = 2.6,
        halfEntryDelay = 0.3,
        targetEnabled = false,
        targetPlot = nil,
        targetSlot = nil,
        targetName = nil,
        Data = {},
    }

    local isStealing = false
    local stealStartTime = nil
    local autoConn = nil

    local function isMyPlot(plot)
        if not plot then return false end
        local sign = plot:FindFirstChild("PlotSign")
        if sign then
            local yb = sign:FindFirstChild("YourBase")
            if yb and yb:IsA("BillboardGui") and yb.Enabled then return true end
        end
        return false
    end

    local function isValidStealPrompt(prompt)
        if not prompt or not prompt.Parent or not prompt.Enabled then return false end
        local st = prompt:GetAttribute("State")
        local at = prompt.ActionText
        return st == "Steal" or st == "Grab" or at == "Steal" or at == "Grab"
    end

    local function getPromptForPodium(plot, slot)
        if not plot or not slot then return nil end
        local pods = plot:FindFirstChild("AnimalPodiums")
        if not pods then return nil end
        local podium = pods:FindFirstChild(tostring(slot))
        if not podium then return nil end
        local base = podium:FindFirstChild("Base")
        if base then
            local spawn = base:FindFirstChild("Spawn")
            if spawn then
                local att = spawn:FindFirstChild("PromptAttachment")
                if att then
                    for _, pr in ipairs(att:GetChildren()) do
                        if pr:IsA("ProximityPrompt") and pr.ActionText and string.find(pr.ActionText, "Steal") then
                            return pr
                        end
                    end
                end
                for _, pr in ipairs(spawn:GetDescendants()) do
                    if pr:IsA("ProximityPrompt") and pr.ActionText and string.find(pr.ActionText, "Steal") then
                        return pr
                    end
                end
            end
        end
        for _, pr in ipairs(podium:GetDescendants()) do
            if pr:IsA("ProximityPrompt") and pr.ActionText and string.find(pr.ActionText, "Steal") then
                return pr
            end
        end
        return nil
    end

    local function _promptDist(prompt)
        local char = LocalPlayer.Character
        if not char then return math.huge end
        local root = char:FindFirstChild("HumanoidRootPart")
            or char:FindFirstChild("UpperTorso")
            or char:FindFirstChild("Torso")
        if not root then return math.huge end
        local part = prompt.Parent
        if part and part:IsA("Attachment") then part = part.Parent end
        if part and part:IsA("BasePart") then
            return (part.Position - root.Position).Magnitude
        end
        return math.huge
    end

    local function findNearestPrompt()
        local char = LocalPlayer.Character
        if not char then return nil, nil end
        local root = char:FindFirstChild("HumanoidRootPart")
            or char:FindFirstChild("UpperTorso")
            or char:FindFirstChild("Torso")
        if not root then return nil, nil end
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return nil, nil end

        if M.targetEnabled and M.targetPlot and M.targetSlot ~= nil then
            local plot = plots:FindFirstChild(tostring(M.targetPlot))
            if plot and not isMyPlot(plot) then
                local prompt = getPromptForPodium(plot, M.targetSlot)
                if prompt and isValidStealPrompt(prompt) then
                    local d = _promptDist(prompt)
                    if d <= M.radius then
                        local nm = (prompt.ObjectText ~= "" and prompt.ObjectText) or M.targetName or "Brainrot"
                        return prompt, nm
                    end
                end
            end
            return nil, nil
        end

        local nearest, bestDist, nearestName = nil, math.huge, "Brainrot"
        local rootPos = root.Position
        for _, plot in ipairs(plots:GetChildren()) do
            if plot:IsA("Model") and not isMyPlot(plot) then
                local pods = plot:FindFirstChild("AnimalPodiums")
                if pods then
                    for _, pod in ipairs(pods:GetChildren()) do
                        local base = pod:FindFirstChild("Base")
                        local sp = base and base:FindFirstChild("Spawn")
                        if sp then
                            local d = (sp.Position - rootPos).Magnitude
                            if d <= M.radius and d < bestDist then
                                local prompt = getPromptForPodium(plot, tonumber(pod.Name) or pod.Name)
                                if prompt and isValidStealPrompt(prompt) then
                                    nearest = prompt
                                    bestDist = d
                                    nearestName = (prompt.ObjectText ~= "" and prompt.ObjectText) or "Brainrot"
                                end
                            end
                        end
                    end
                end
            end
        end
        return nearest, nearestName
    end

    local function executeSteal(prompt)
        if isStealing or not prompt or not prompt.Parent then return end
        if not M.Data[prompt] then
            M.Data[prompt] = { hold = {}, trigger = {}, ready = true }
            if getconnections then
                pcall(function()
                    for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan) or {}) do
                        if c.Function then table.insert(M.Data[prompt].hold, c.Function) end
                    end
                    for _, c in ipairs(getconnections(prompt.Triggered) or {}) do
                        if c.Function then table.insert(M.Data[prompt].trigger, c.Function) end
                    end
                end)
            end
        end
        local data = M.Data[prompt]
        if not data or not data.ready then return end
        data.ready = false
        isStealing = true
        stealStartTime = tick()
        task.spawn(function()
            for _, fn in ipairs(data.hold) do task.spawn(fn) end
            task.wait(M.halfHoldMin)
            local inRange = _promptDist(prompt) <= M.halfFireRange
            while true do
                local el = tick() - (stealStartTime or tick())
                if el > M.halfHoldMax or not prompt.Parent then break end
                if _promptDist(prompt) <= M.halfFireRange then
                    if not inRange then task.wait(M.halfEntryDelay) end
                    for _, fn in ipairs(data.trigger) do task.spawn(fn) end
                    break
                end
                task.wait()
            end
            task.wait(0.05)
            data.ready = true
            isStealing = false
        end)
    end

    local function startAutoGrab()
        if autoConn then return end
        M.enabled = true
        autoConn = RunService.Heartbeat:Connect(function()
            if not M.enabled or isStealing then return end
            if _G._HighSemiTPActive then return end
            for prompt, _ in pairs(M.Data) do
                if not prompt or not prompt.Parent then M.Data[prompt] = nil end
            end
            local prompt = findNearestPrompt()
            if prompt then executeSteal(prompt) end
        end)
    end

    local function stopAutoGrab()
        if autoConn then pcall(function() autoConn:Disconnect() end) autoConn = nil end
        isStealing = false
        stealStartTime = nil
    end

    M.start = startAutoGrab
    M.stop = stopAutoGrab
    M.set = function(on)
        on = on and true or false
        if on then startAutoGrab() else stopAutoGrab() end
    end
    M.findNearest = findNearestPrompt
    M.executeSteal = executeSteal
    return M
end)()

-- TINY RESET
local TinyState = { Enabled = false, Conns = {}, BoundRemotes = {}, AddConn = nil, LastFire = 0 }
local function _arbStringMatchesTiny(s)
    if type(s) ~= "string" then return false end
    return s:lower():find("tiny for 30", 1, true) ~= nil
end
local function _artHandleArgs(...)
    if not TinyState.Enabled then return end
    for i = 1, select("#", ...) do
        local arg = select(i, ...)
        if _arbStringMatchesTiny(arg) then
            local now = tick()
            if now - TinyState.LastFire < 3 then return end
            TinyState.LastFire = now
            ResetPlayer()
            return
        end
    end
end
local function _artBindRemote(obj)
    if not obj:IsA("RemoteEvent") then return end
    if TinyState.BoundRemotes[obj] then return end
    local ok, conn = pcall(function() return obj.OnClientEvent:Connect(_artHandleArgs) end)
    if ok and conn then
        table.insert(TinyState.Conns, conn)
        TinyState.BoundRemotes[obj] = true
    end
end
local function startAutoResetTiny()
    for _, conn in ipairs(TinyState.Conns) do pcall(function() conn:Disconnect() end) end
    TinyState.Conns = {}
    TinyState.BoundRemotes = {}
    if TinyState.AddConn then pcall(function() TinyState.AddConn:Disconnect() end) TinyState.AddConn = nil end
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do _artBindRemote(obj) end
    TinyState.AddConn = ReplicatedStorage.DescendantAdded:Connect(function(obj)
        if TinyState.Enabled then _artBindRemote(obj) end
    end)
end
local function stopAutoResetTiny()
    for _, conn in ipairs(TinyState.Conns) do pcall(function() conn:Disconnect() end) end
    TinyState.Conns = {}
    TinyState.BoundRemotes = {}
    if TinyState.AddConn then pcall(function() TinyState.AddConn:Disconnect() end) TinyState.AddConn = nil end
end

-- JAIL RESET
local JailState = { Enabled = false, Conns = {}, BoundRemotes = {}, AddConn = nil, LastFire = 0 }
local function _arbStringMatchesJail(s)
    if type(s) ~= "string" then return false end
    return s:lower():find("trapped for", 1, true) ~= nil
end
local function _arjHandleArgs(...)
    if not JailState.Enabled then return end
    for i = 1, select("#", ...) do
        local arg = select(i, ...)
        if _arbStringMatchesJail(arg) then
            local now = tick()
            if now - JailState.LastFire < 3 then return end
            JailState.LastFire = now
            ResetPlayer()
            return
        end
    end
end
local function _arjBindRemote(obj)
    if not obj:IsA("RemoteEvent") then return end
    if JailState.BoundRemotes[obj] then return end
    local ok, conn = pcall(function() return obj.OnClientEvent:Connect(_arjHandleArgs) end)
    if ok and conn then
        table.insert(JailState.Conns, conn)
        JailState.BoundRemotes[obj] = true
    end
end
local function startAutoResetJail()
    for _, conn in ipairs(JailState.Conns) do pcall(function() conn:Disconnect() end) end
    JailState.Conns = {}
    JailState.BoundRemotes = {}
    if JailState.AddConn then pcall(function() JailState.AddConn:Disconnect() end) JailState.AddConn = nil end
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do _arjBindRemote(obj) end
    JailState.AddConn = ReplicatedStorage.DescendantAdded:Connect(function(obj)
        if JailState.Enabled then _arjBindRemote(obj) end
    end)
end
local function stopAutoResetJail()
    for _, conn in ipairs(JailState.Conns) do pcall(function() conn:Disconnect() end) end
    JailState.Conns = {}
    JailState.BoundRemotes = {}
    if JailState.AddConn then pcall(function() JailState.AddConn:Disconnect() end) JailState.AddConn = nil end
end

-- QUICK PICKUP
local QuickPickup = (function()
    local enabled = false
    local orig = {}
    local hooked = false
    local scanRunning = false
    local function isMyPlot(plot)
        if not plot or not plot:IsA("Model") then return false end
        local sign = plot:FindFirstChild("PlotSign")
        return sign and sign:FindFirstChild("YourBase") and sign.YourBase.Enabled
    end
    local function inMyPlot(inst)
        if not inst or not inst.Parent then return false end
        local node = inst.Parent
        for _ = 1, 10 do
            if not node then return false end
            if node:IsA("Model") and node.Parent and node.Parent.Name == "Plots" then
                return isMyPlot(node)
            end
            node = node.Parent
        end
        return false
    end
    local function installHook()
        if hooked then return end
        local ok, mt = pcall(getrawmetatable, game)
        if not ok or not mt then return end
        local sok = pcall(setreadonly, mt, false)
        if not sok then return end
        local oldNewIndex = mt.__newindex
        local nc = newcclosure or function(f) return f end
        mt.__newindex = nc(function(self, key, value)
            if not thisScriptStopped
               and key == "HoldDuration"
               and enabled
               and typeof(self) == "Instance"
               and self:IsA("ProximityPrompt")
               and inMyPlot(self) then
                value = 0.1
            end
            return oldNewIndex(self, key, value)
        end)
        pcall(setreadonly, mt, true)
        hooked = true
    end
    local function scanPlots()
        if scanRunning or not enabled then return end
        scanRunning = true
        task.spawn(function()
            local root = Workspace:FindFirstChild("Plots") or Workspace
            local stack, si = { root }, 1
            local visited = 0
            while si > 0 and enabled do
                local cur = stack[si]; stack[si] = nil; si = si - 1
                local ch = cur:GetChildren()
                for i = 1, #ch do
                    local d = ch[i]
                    if d:IsA("ProximityPrompt") and inMyPlot(d) then
                        if orig[d] == nil then orig[d] = d.HoldDuration end
                        pcall(function() d.HoldDuration = 0.1 end)
                    end
                    si = si + 1; stack[si] = d
                end
                visited = visited + 1
                if visited % 20 == 0 then task.wait() end
            end
            scanRunning = false
        end)
    end
    local M = {}
    function M.set(v)
        enabled = v
        if v then
            installHook()
            scanPlots()
        else
            for p, o in pairs(orig) do
                if p and p.Parent then pcall(function() p.HoldDuration = o end) end
            end
            orig = {}
            scanRunning = false
        end
    end
    return M
end)()

-- AUTO CARPET SPEED
local HH_AutoCarpet = { enabled = false, conn = nil, speed = 140 }
local function hhIsCarpetTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local n = tool.Name:lower()
    return n:find("carpet", 1, true) or n:find("broom", 1, true) or n:find("wing", 1, true) or 
           n:find("sleigh", 1, true) or n:find("waverider", 1, true) or n:find("hover", 1, true) or
           n:find("flying", 1, true)
end
local function hhStartAutoCarpet()
    if HH_AutoCarpet.conn then return end
    HH_AutoCarpet.enabled = true
    HH_AutoCarpet.conn = RunService.Heartbeat:Connect(function()
        if not HH_AutoCarpet.enabled then return end
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local upperTorso = char and char:FindFirstChild("UpperTorso")
        if not hum or not upperTorso then return end
        local equipped = false
        if char then
            for _, tool in ipairs(char:GetChildren()) do
                if hhIsCarpetTool(tool) then equipped = true break end
            end
        end
        if equipped then
            local dir = hum.MoveDirection
            if dir.Magnitude > 0 then
                upperTorso.AssemblyLinearVelocity = Vector3.new(dir.X * HH_AutoCarpet.speed, upperTorso.AssemblyLinearVelocity.Y, dir.Z * HH_AutoCarpet.speed)
            else
                upperTorso.AssemblyLinearVelocity = Vector3.new(0, upperTorso.AssemblyLinearVelocity.Y, 0)
            end
        end
    end)
end
local function hhStopAutoCarpet()
    HH_AutoCarpet.enabled = false
    if HH_AutoCarpet.conn then
        HH_AutoCarpet.conn:Disconnect()
        HH_AutoCarpet.conn = nil
    end
end
-- ANTI DIE
local antiDieEnabled = false
local antiDieConnections = {}
local function startAntiDie()
    if antiDieEnabled then return end
    antiDieEnabled = true
    local function antiDieHandler()
        if not antiDieEnabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if hum.Health <= 0 then
            pcall(function()
                hum.Health = 100
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics or 
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown or
           state == Enum.HumanoidStateType.Dead then
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.Running)
                hum.PlatformStand = false
                hum.Sit = false
                hum.Health = 100
            end)
        end
    end
    local heartbeatConn = RunService.Heartbeat:Connect(antiDieHandler)
    table.insert(antiDieConnections, heartbeatConn)
    local function hookCharacter(char)
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local stateConn = hum.StateChanged:Connect(function(_, newState)
            if not antiDieEnabled then return end
            if newState == Enum.HumanoidStateType.Dead then
                pcall(function()
                    hum.Health = 100
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end)
            end
        end)
        table.insert(antiDieConnections, stateConn)
    end
    if LocalPlayer.Character then hookCharacter(LocalPlayer.Character) end
    local charAddedHook = LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(0.1)
        if antiDieEnabled then
            hookCharacter(char)
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health = 100 end
        end
    end)
    table.insert(antiDieConnections, charAddedHook)
end
local function stopAntiDie()
    antiDieEnabled = false
    for _, conn in ipairs(antiDieConnections) do
        pcall(function() conn:Disconnect() end)
    end
    antiDieConnections = {}
end

-- ANTI RAGDOLL
local antiRagdollEnabled = false
local antiRagdollRenderConn = nil
local antiRagdollCharacterConn = nil
local antiRagdollCached = {}

local function antiRagdollCacheCharacter()
    if not antiRagdollEnabled or _G.AntiRagdoll ~= true then return false end
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return false end
    antiRagdollCached = {
        character = char,
        humanoid = hum,
        root = root,
        upperTorso = char:FindFirstChild("UpperTorso"),
    }
    local camera = workspace.CurrentCamera
    if camera then camera.CameraSubject = hum end
    return true
end

local function antiRagdollIsRagdolled()
    if not antiRagdollEnabled or _G.AntiRagdoll ~= true then return false end
    local hum = antiRagdollCached.humanoid
    if not hum then return false end
    local state = hum:GetState()
    if state == Enum.HumanoidStateType.Physics
        or state == Enum.HumanoidStateType.Ragdoll
        or state == Enum.HumanoidStateType.FallingDown then
        return true
    end
    local endTime = LocalPlayer:GetAttribute("RagdollEndTime")
    return endTime and (endTime - workspace:GetServerTimeNow()) > 0 or false
end

local function antiRagdollRemoveConstraints()
    if not antiRagdollEnabled or _G.AntiRagdoll ~= true then return end
    local char = antiRagdollCached.character
    if not char then return end
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("BallSocketConstraint")
            or (obj:IsA("Attachment") and obj.Name:find("RagdollAttachment", 1, true)) then
            pcall(function() obj:Destroy() end)
        end
    end
end

local function antiRagdollForceExit()
    if not antiRagdollEnabled or _G.AntiRagdoll ~= true then return end
    local hum = antiRagdollCached.humanoid
    local root = antiRagdollCached.root
    if not hum or not root then return end
    pcall(function()
        LocalPlayer:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
    end)
    if hum.Health > 0 then
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            task.defer(function()
                if hum and hum.Parent and hum.Health > 0 and antiRagdollEnabled then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
        end)
    end
    pcall(function()
        root.Anchored = false
        local upperTorso = antiRagdollCached.upperTorso
        if upperTorso then
            upperTorso.AssemblyLinearVelocity = Vector3.zero
            upperTorso.AssemblyAngularVelocity = Vector3.zero
        end
        root.AssemblyAngularVelocity = Vector3.zero
        root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(root.Orientation.Y), 0)
    end)
    local camera = workspace.CurrentCamera
    if camera and camera.CameraSubject ~= hum then camera.CameraSubject = hum end
end

function startAntiRagdoll()
    if _G.AntiRagdoll ~= true or antiRagdollEnabled then return end
    antiRagdollEnabled = true
    antiRagdollCacheCharacter()
    if not antiRagdollRenderConn then
        antiRagdollRenderConn = RunService.Heartbeat:Connect(function()
            if not antiRagdollEnabled or _G.AntiRagdoll ~= true then return end
            if not antiRagdollCached.humanoid or not antiRagdollCached.humanoid.Parent then
                antiRagdollCacheCharacter()
                return
            end
            if antiRagdollIsRagdolled() then
                antiRagdollRemoveConstraints()
                antiRagdollForceExit()
            end
        end)
    end
    if not antiRagdollCharacterConn then
        antiRagdollCharacterConn = LocalPlayer.CharacterAdded:Connect(function()
            if not antiRagdollEnabled or _G.AntiRagdoll ~= true then return end
            task.wait(0.5)
            if antiRagdollEnabled and _G.AntiRagdoll == true then antiRagdollCacheCharacter() end
        end)
    end
end

function stopAntiRagdoll()
    antiRagdollEnabled = false
    if antiRagdollRenderConn then
        pcall(function() antiRagdollRenderConn:Disconnect() end)
        antiRagdollRenderConn = nil
    end
    if antiRagdollCharacterConn then
        pcall(function() antiRagdollCharacterConn:Disconnect() end)
        antiRagdollCharacterConn = nil
    end
    antiRagdollCached = {}
end

-- HEADLESS HORSEMAN
local HeadlessHorseman = {
    enabled = false,
    accessory = nil,
    guardConnection = nil,
    characterConnection = nil,
    originalHead = {},
}

local HEADLESS_HORSEMAN_ASSET = "rbxassetid://134082579"
local HEADLESS_GUARD_INTERVAL = 0.35

local function headlessHideHead(character)
    local head = character and character:FindFirstChild("Head")
    if not head then return end
    if not HeadlessHorseman.originalHead[character] then
        local face = head:FindFirstChildOfClass("Decal")
        HeadlessHorseman.originalHead[character] = {
            transparency = head.Transparency,
            face = face,
            faceTransparency = face and face.Transparency or nil,
        }
    end
    head.Transparency = 1
    local face = head:FindFirstChildOfClass("Decal")
    if face then face.Transparency = 1 end
end

local function headlessRestoreHead(character)
    local saved = character and HeadlessHorseman.originalHead[character]
    if not saved then return end
    local head = character:FindFirstChild("Head")
    if head then pcall(function() head.Transparency = saved.transparency end) end
    if saved.face and saved.face.Parent and saved.faceTransparency ~= nil then
        pcall(function() saved.face.Transparency = saved.faceTransparency end)
    end
    HeadlessHorseman.originalHead[character] = nil
end

local function headlessLoadAccessory()
    local ok, objects = pcall(function()
        return game:GetObjects(HEADLESS_HORSEMAN_ASSET)
    end)
    if not ok or not objects or #objects == 0 then
        warn("[Headless] Falha ao carregar asset: " .. tostring(objects))
        return nil
    end
    local root = objects[1]
    if root:IsA("Accessory") then return root end
    for _, obj in ipairs(root:GetDescendants()) do
        if obj:IsA("Accessory") then return obj end
    end
    return nil
end

local function headlessApplyOnce()
    local character = LocalPlayer.Character
    if not character then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    headlessHideHead(character)
    if HeadlessHorseman.accessory
        and HeadlessHorseman.accessory.Parent
        and HeadlessHorseman.accessory.Parent:IsDescendantOf(character) then
        return true
    end
    if HeadlessHorseman.accessory and not HeadlessHorseman.accessory.Parent then
        pcall(function() humanoid:AddAccessory(HeadlessHorseman.accessory) end)
        if HeadlessHorseman.accessory.Parent then return true end
    end
    local accessory = headlessLoadAccessory()
    if not accessory then return false end
    local ok = pcall(function() humanoid:AddAccessory(accessory) end)
    if ok and accessory.Parent then
        HeadlessHorseman.accessory = accessory
        return true
    end
    accessory.Parent = character
    HeadlessHorseman.accessory = accessory
    return true
end

local function headlessStopGuard()
    if HeadlessHorseman.guardConnection then
        pcall(function() HeadlessHorseman.guardConnection:Disconnect() end)
        HeadlessHorseman.guardConnection = nil
    end
end

local function headlessStartGuard()
    headlessStopGuard()
    local elapsed = 0
    HeadlessHorseman.guardConnection = RunService.Heartbeat:Connect(function(dt)
        if not HeadlessHorseman.enabled then return end
        elapsed += dt
        if elapsed < HEADLESS_GUARD_INTERVAL then return end
        elapsed = 0
        local character = LocalPlayer.Character
        if not character then return end
        headlessHideHead(character)
        local accessory = HeadlessHorseman.accessory
        local present = accessory and accessory.Parent and accessory.Parent:IsDescendantOf(character)
        if not present then headlessApplyOnce() end
    end)
end

function HeadlessHorseman.set(enabled)
    HeadlessHorseman.enabled = enabled == true
    headlessStopGuard()
    local character = LocalPlayer.Character
    if not HeadlessHorseman.enabled then
        if HeadlessHorseman.accessory then
            pcall(function() HeadlessHorseman.accessory:Destroy() end)
            HeadlessHorseman.accessory = nil
        end
        headlessRestoreHead(character)
        return
    end
    task.spawn(function()
        for _ = 1, 20 do
            if not HeadlessHorseman.enabled then return end
            if headlessApplyOnce() then
                headlessStartGuard()
                return
            end
            task.wait(0.15)
        end
        if HeadlessHorseman.enabled then headlessStartGuard() end
    end)
end

function HeadlessHorseman.isEnabled()
    return HeadlessHorseman.enabled == true
end

HeadlessHorseman.characterConnection = LocalPlayer.CharacterAdded:Connect(function(character)
    HeadlessHorseman.accessory = nil
    HeadlessHorseman.originalHead[character] = nil
    if HeadlessHorseman.enabled then
        task.spawn(function()
            local waited = 0
            repeat
                task.wait(0.2)
                waited += 1
            until (character:FindFirstChild("Head") and character:FindFirstChildOfClass("Humanoid")) or waited > 50
            if HeadlessHorseman.enabled and LocalPlayer.Character == character then
                headlessApplyOnce()
                headlessStartGuard()
            end
        end)
    end
end)
table.insert(ActiveConnections, HeadlessHorseman.characterConnection)
table.insert(ActiveConnections, function()
    headlessStopGuard()
    if HeadlessHorseman.accessory then
        pcall(function() HeadlessHorseman.accessory:Destroy() end)
        HeadlessHorseman.accessory = nil
    end
    headlessRestoreHead(LocalPlayer.Character)
end)

-- KORBLOX LEG
local KorbloxLeg = {
    enabled = false,
    original = {},
    character = nil,
}

local KORBLOX_RIGHT_LEG_ASSET = "rbxassetid://139607718"
local KORBLOX_RIGHT_LEG_NAME = "Korblox_RightLeg"

local function korbloxGetRigData(character)
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local isR15 = humanoid and humanoid.RigType == Enum.HumanoidRigType.R15
    if isR15 then
        return "RightUpperLeg", {"RightUpperLeg", "RightLowerLeg", "RightFoot"}
    end
    return "Right Leg", {"Right Leg"}
end

local function korbloxRestoreCharacter(character)
    if not character then return end
    local oldAsset = character:FindFirstChild(KORBLOX_RIGHT_LEG_NAME)
    if oldAsset then pcall(function() oldAsset:Destroy() end) end
    local saved = KorbloxLeg.original[character]
    if saved then
        for part, values in pairs(saved) do
            if part and part.Parent then
                pcall(function()
                    part.Transparency = values.transparency
                    part.CanCollide = values.canCollide
                end)
            end
        end
        KorbloxLeg.original[character] = nil
    end
end

local function korbloxFetchAsset()
    local ok, objects = pcall(function()
        return game:GetObjects(KORBLOX_RIGHT_LEG_ASSET)
    end)
    if not ok or not objects or #objects == 0 then return nil end
    local asset = objects[1]
    for _, obj in ipairs(asset:GetDescendants()) do
        if obj:IsA("Script") or obj:IsA("LocalScript") then
            pcall(function() obj:Destroy() end)
        end
    end
    return asset
end

local function korbloxApply(character)
    if not character then return false end
    local targetPartName, partsToHide = korbloxGetRigData(character)
    local targetPart = character:FindFirstChild(targetPartName)
    if not targetPart then return false end

    korbloxRestoreCharacter(character)
    KorbloxLeg.original[character] = {}
    for _, partName in ipairs(partsToHide) do
        local part = character:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            KorbloxLeg.original[character][part] = {
                transparency = part.Transparency,
                canCollide = part.CanCollide,
            }
            part.Transparency = 1
            part.CanCollide = false
        end
    end

    local asset = korbloxFetchAsset()
    if not asset then
        korbloxRestoreCharacter(character)
        return false
    end
    asset.Name = KORBLOX_RIGHT_LEG_NAME
    local mesh = asset:IsA("BasePart") and asset or asset:FindFirstChildWhichIsA("BasePart", true)
    if not mesh then
        pcall(function() asset:Destroy() end)
        korbloxRestoreCharacter(character)
        return false
    end

    local originalSize = mesh.Size
    local refWidth = math.max(targetPart.Size.X, targetPart.Size.Z)
    local meshWidth = math.max(originalSize.X, originalSize.Z)
    local widthRatio = 1
    if meshWidth > 0 and refWidth > 0 then
        widthRatio = math.clamp(refWidth / meshWidth, 0.8, 1.35)
    end
    mesh.Size = Vector3.new(originalSize.X * widthRatio, originalSize.Y, originalSize.Z * widthRatio)
    mesh.CanCollide = false
    mesh.Massless = true
    mesh.Anchored = false

    local centerPos = Vector3.new(
        targetPart.Position.X,
        targetPart.Position.Y + targetPart.Size.Y / 2 - mesh.Size.Y / 2,
        targetPart.Position.Z
    )
    local targetRotation = targetPart.CFrame - targetPart.CFrame.Position
    mesh.CFrame = CFrame.new(centerPos) * targetRotation

    local weld = Instance.new("Weld")
    weld.Name = "KorbloxWeld"
    weld.Part0 = targetPart
    weld.Part1 = mesh
    weld.C0 = targetPart.CFrame:Inverse() * mesh.CFrame
    weld.C1 = CFrame.new()
    weld.Parent = mesh
    asset.Parent = character
    KorbloxLeg.character = character
    return true
end

function KorbloxLeg.set(enabled)
    KorbloxLeg.enabled = enabled == true
    local character = LocalPlayer.Character
    if not KorbloxLeg.enabled then
        korbloxRestoreCharacter(character)
        KorbloxLeg.character = nil
        return
    end
    task.spawn(function()
        for _ = 1, 20 do
            if not KorbloxLeg.enabled then return end
            if korbloxApply(LocalPlayer.Character) then return end
            task.wait(0.15)
        end
    end)
end

function KorbloxLeg.isEnabled()
    return KorbloxLeg.enabled == true
end

table.insert(ActiveConnections, LocalPlayer.CharacterAdded:Connect(function(character)
    KorbloxLeg.original[character] = nil
    if KorbloxLeg.enabled then
        task.delay(1.5, function()
            if KorbloxLeg.enabled and LocalPlayer.Character == character then
                korbloxApply(character)
            end
        end)
    end
end))

-- SETTINGS
local SETTINGS_FILE = "high_pvp_settings.json"
local UI_LAYOUT_FILE = "high_pvp_ui_placement.json"
local function loadSettings()
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(SETTINGS_FILE)) end)
    if ok and type(data) == "table" then return data end
    return {}
end
local settingsGetters = {}

local function savedBool(data, key, defaultValue)
    if type(data) == "table" and data[key] ~= nil then
        return data[key] == true
    end
    return defaultValue == true
end

local function savedColor3(data, key, defaultValue)
    local value = type(data) == "table" and data[key]
    if type(value) == "table" then
        local r = tonumber(value[1] or value.r)
        local g = tonumber(value[2] or value.g)
        local b = tonumber(value[3] or value.b)
        if r and g and b then
            return Color3.fromRGB(
                math.clamp(math.floor(r + 0.5), 0, 255),
                math.clamp(math.floor(g + 0.5), 0, 255),
                math.clamp(math.floor(b + 0.5), 0, 255)
            )
        end
    end
    return defaultValue
end

-- FONT SELECTOR
local FontSelector = (function()
    local fonts = {
        { name = "Gotham Bold", enum = Enum.Font.GothamBold },
        { name = "Gotham", enum = Enum.Font.Gotham },
        { name = "Gotham Black", enum = Enum.Font.GothamBlack },
        { name = "Source Sans", enum = Enum.Font.SourceSansBold },
        { name = "Fredoka One", enum = Enum.Font.FredokaOne },
        { name = "Cartoon", enum = Enum.Font.Cartoon },
        { name = "Arcade", enum = Enum.Font.Arcade },
        { name = "Code", enum = Enum.Font.Code },
        { name = "Sci-Fi", enum = Enum.Font.SciFi },
        { name = "Fantasy", enum = Enum.Font.Fantasy },
        { name = "Highway", enum = Enum.Font.Highway },
    }
    local originalFonts = {}
    local watchers = {}
    local selectedName = "Gotham Bold"

    local function getFont(name)
        for _, item in ipairs(fonts) do
            if item.name == name then return item.enum end
        end
        return Enum.Font.GothamBold
    end

    local function isProtected(instance)
        local name = string.lower(instance.Name or "")
        local parentName = instance.Parent and string.lower(instance.Parent.Name or "") or ""
        local ancestor = instance.Parent
        while ancestor do
            if ancestor.Name == "HighBanner" then return false end
            ancestor = ancestor.Parent
        end
        for _, protected in ipairs({"logo", "menu", "topbar", "party"}) do
            if string.find(name, protected, 1, true) or string.find(parentName, protected, 1, true) then
                return true
            end
        end
        return false
    end

    local function rememberAndApply(instance)
        pcall(function()
            if isProtected(instance) then return end
            if not (instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox")) then return end
            if not originalFonts[instance] then
                originalFonts[instance] = { Font = instance.Font, FontFace = instance.FontFace }
            end
            instance.Font = getFont(selectedName)
        end)
    end

    local function stopWatchers()
        for _, connection in ipairs(watchers) do pcall(function() connection:Disconnect() end) end
        watchers = {}
    end

    local function restore()
        for instance, original in pairs(originalFonts) do
            pcall(function()
                if instance and instance.Parent then
                    instance.Font = original.Font
                    if original.FontFace then instance.FontFace = original.FontFace end
                end
            end)
        end
        originalFonts = {}
    end

    local function watch(root)
        if not root then return end
        pcall(function()
            for _, descendant in ipairs(root:GetDescendants()) do rememberAndApply(descendant) end
            table.insert(watchers, root.DescendantAdded:Connect(rememberAndApply))
        end)
    end

    local function set(name, root)
        if type(name) == "string" and getFont(name) then selectedName = name end
        stopWatchers()
        restore()
        if root then watch(root) end
    end

    local function addRoot(root)
        if root then watch(root) end
    end

    return {
        fonts = fonts,
        set = set,
        addRoot = addRoot,
        getName = function() return selectedName end,
        getFont = getFont,
    }
end)()

-- AIMBOT
do
    local aimbotEnabled = false
    local aimRemoteIndex = {}
    local aimRemoteObjects = {}
    local aimLastShot = 0
    local aimConnections = {}
    local aimCurrentCharacter = nil
    local AIM_VALID_TOOLS = {"Web Slinger", "Laser Cape", "Paintball Gun"}
    local AIM_TARGET_PARTS = {"HumanoidRootPart", "UpperTorso", "Torso", "Head"}
    local AIM_MAX_DISTANCE = 800
    local AIM_LEAD_TIME = 0.18

    local function resolveUseItemRemote()
        local cached = _G._FH_UseItemRemote
        if typeof(cached) == "Instance" and cached.Parent then return cached end
        local _getconnections = getconnections
        local _getconstants = (debug and debug.getconstants) or getconstants
        if type(_getconnections) ~= "function" or type(_getconstants) ~= "function" then return nil end
        local ok, netFolder = pcall(function()
            return ReplicatedStorage:WaitForChild("Packages", 15):WaitForChild("Net", 15)
        end)
        if not ok or not netFolder then return nil end
        local found
        for _, r in ipairs(netFolder:GetChildren()) do
            if r:IsA("RemoteEvent") and not found then
                local okc, conns = pcall(_getconnections, r.OnClientEvent)
                if okc and conns then
                    for _, c in ipairs(conns) do
                        if type(c.Function) == "function" then
                            local okk, consts = pcall(_getconstants, c.Function)
                            if okk and consts then
                                for _, k in ipairs(consts) do
                                    if k == "PaintballHitted" then found = r break end
                                end
                            end
                        end
                        if found then break end
                    end
                end
            end
            if found then break end
        end
        if found then _G._FH_UseItemRemote = found end
        return found
    end

    local function initRemotes()
        local ok, children = pcall(function()
            return ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):GetChildren()
        end)
        if not ok or not children then return end
        aimRemoteIndex = {}
        aimRemoteObjects = {}
        for i, obj in ipairs(children) do
            if obj:IsA("RemoteEvent") then
                local nextObj = children[i + 1]
                if nextObj then
                    aimRemoteIndex[obj.Name] = i + 1
                    aimRemoteObjects[i + 1] = nextObj
                end
            end
        end
    end

    local function fireRemote(name, ...)
        if name == "RE/UseItem" or name == "UseItem" then
            local r = resolveUseItemRemote()
            if r then r:FireServer(...) return true end
        end
        local index = aimRemoteIndex[name]
        if index and aimRemoteObjects[index] then
            aimRemoteObjects[index]:FireServer(...)
            return true
        end
        return false
    end

    local function getTool()
        local c = LocalPlayer.Character
        return c and c:FindFirstChildOfClass("Tool")
    end
    local function hasValidTool()
        local tool = getTool()
        if not tool then return false end
        for _, name in pairs(AIM_VALID_TOOLS) do
            if tool.Name == name then return true end
        end
        return false
    end
    local function isAlive(char)
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        return hum and hum.Health > 0
    end
    local function getNearestPlayer()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        local closest, bestDist = nil, AIM_MAX_DISTANCE
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local c = plr.Character
                local rp = c and c:FindFirstChild("HumanoidRootPart")
                if rp and isAlive(c) then
                    local d = (rp.Position - hrp.Position).Magnitude
                    if d < bestDist then bestDist = d closest = plr end
                end
            end
        end
        return closest
    end
    local function getBestPart(character)
        for _, name in pairs(AIM_TARGET_PARTS) do
            local p = character:FindFirstChild(name)
            if p then return p end
        end
        return nil
    end
    local function shoot()
        if not hasValidTool() then return false end
        local target = getNearestPlayer()
        if not target then return false end
        local char = target.Character
        if not char or not isAlive(char) then return false end
        local part = getBestPart(char)
        if not part then return false end
        local vel = Vector3.zero
        pcall(function()
            local upperTorso = char:FindFirstChild("UpperTorso")
            if upperTorso then vel = upperTorso.AssemblyLinearVelocity end
        end)
        local targetPos = part.Position + Vector3.new(0, 0.5, 0) + vel * AIM_LEAD_TIME
        if not (aimRemoteIndex["RE/UseItem"] or aimRemoteIndex["UseItem"]) then initRemotes() end
        local ok = fireRemote("RE/UseItem", targetPos, part)
        if not ok then initRemotes() ok = fireRemote("RE/UseItem", targetPos, part) end
        return ok
    end
    local function tryShoot()
        local now = tick()
        if now - aimLastShot < 0.04 then return end
        aimLastShot = now
        shoot()
    end
    local function hookTool(tool)
        if not tool then return end
        local conn = tool.Activated:Connect(tryShoot)
        table.insert(aimConnections, conn)
    end
    local function setupCharacter(char)
        aimCurrentCharacter = char
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then hookTool(tool) end
        local conn = char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then hookTool(child) end
        end)
        table.insert(aimConnections, conn)
    end
    local function startAimbot()
        initRemotes()
        local inputConn = UserInputService.InputBegan:Connect(function(inp, gp)
            if gp then return end
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or
               inp.UserInputType == Enum.UserInputType.Touch then
                tryShoot()
            end
        end)
        table.insert(aimConnections, inputConn)
        if LocalPlayer.Character then setupCharacter(LocalPlayer.Character) end
        local charConn = LocalPlayer.CharacterAdded:Connect(setupCharacter)
        table.insert(aimConnections, charConn)
    end
    local function stopAimbot()
        for _, c in ipairs(aimConnections) do pcall(c.Disconnect, c) end
        aimConnections = {}
        aimCurrentCharacter = nil
    end
    function _G.ToggleAimbot(state)
        aimbotEnabled = state
        if state then startAimbot() else stopAimbot() end
        _G.AimbotEnabled = state
        if type(saveSettings) == "function" then pcall(saveSettings) end
    end
    if _G.AimbotEnabled == nil then _G.AimbotEnabled = false end
    if _G.AimbotEnabled then task.defer(function() _G.ToggleAimbot(true) end) end
end

local function saveSettings()
    pcall(function()
        local out = {}
        for key, getter in pairs(settingsGetters) do out[key] = getter() end
        writefile(SETTINGS_FILE, HttpService:JSONEncode(out))
    end)
end

local function loadUILayout()
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(UI_LAYOUT_FILE)) end)
    if ok and type(data) == "table" then return data end
    return {}
end
local uiLayout = loadUILayout()
local saveUILayoutQueued = false
local function saveUILayout()
    if saveUILayoutQueued then return end
    saveUILayoutQueued = true
    task.delay(0.5, function()
        saveUILayoutQueued = false
        pcall(function() writefile(UI_LAYOUT_FILE, HttpService:JSONEncode(uiLayout)) end)
    end)
end
local function registerPanelLayout(panel, name, defaultMinW, defaultMinH)
    local saved = uiLayout[name]
    if saved then
        pcall(function()
            panel.Position = UDim2.new(0, saved.px, 0, saved.py)
            panel.Size = UDim2.new(0, saved.pw, 0, saved.ph)
        end)
    end
    local function persist()
        uiLayout[name] = {
            px = panel.Position.X.Offset, py = panel.Position.Y.Offset,
            pw = panel.Size.X.Offset, ph = panel.Size.Y.Offset,
        }
        saveUILayout()
    end
    panel:GetPropertyChangedSignal("Position"):Connect(persist)
    panel:GetPropertyChangedSignal("Size"):Connect(persist)
end

local savedSettings = loadSettings()
_G.AutoResetOnBalloon = savedBool(savedSettings, "AutoResetOnBalloon", false)
_G.AutoGiant = savedBool(savedSettings, "AutoGiant", false)
_G.RagdollBypass = savedBool(savedSettings, "RagdollBypass", false)
_G.AutoBlock = savedBool(savedSettings, "AutoBlock", false)
_G.BlockMode = savedSettings.BlockMode or "normal"
_G.LaggerOnFlash = savedBool(savedSettings, "LaggerOnFlash", false)
_G.LaggerPower = savedSettings.LaggerPower or 50
_G.FlashSpeed = savedSettings.FlashSpeed or 150
-- 🆕 TP V2
_G.TPV2 = savedBool(savedSettings, "TPV2", false)
_G.AntiBodySwap = savedBool(savedSettings, "AntiBodySwap", false)
-- clamp flash speed to current max
do
    local maxV = _G.TPV2 and FLASH_SPEED_MAX_TPV2 or FLASH_SPEED_MAX_BASE
    if type(_G.FlashSpeed) ~= "number" or _G.FlashSpeed < 0 then _G.FlashSpeed = 150 end
    if _G.FlashSpeed > maxV then _G.FlashSpeed = maxV end
end
_G.AimbotEnabled = savedBool(savedSettings, "Aimbot", false)
_G.AutoResetTiny = savedBool(savedSettings, "AutoResetTiny", false)
TinyState.Enabled = _G.AutoResetTiny
if TinyState.Enabled then startAutoResetTiny() end
_G.AutoResetJail = savedBool(savedSettings, "AutoResetJail", false)
JailState.Enabled = _G.AutoResetJail
if JailState.Enabled then startAutoResetJail() end
_G.APESP = savedBool(savedSettings, "APESP", false)
_G.EspTimer = savedBool(savedSettings, "EspTimer", false)
_G.QuickAP = savedBool(savedSettings, "QuickAP", false)
_G.BackpackESP = savedBool(savedSettings, "BackpackESP", false)
_G.ShowAPESP = savedBool(savedSettings, "ShowAPESP", true)
_G.ShowGiantPotion = savedBool(savedSettings, "ShowGiantPotion", true)
_G.ShowFlashTeleport = savedBool(savedSettings, "ShowFlashTeleport", true)
_G.ShowFlyingCarpet = savedBool(savedSettings, "ShowFlyingCarpet", true)
_G.QuickPickup = savedBool(savedSettings, "QuickPickup", false)
QuickPickup.set(_G.QuickPickup)
_G.AntiRagdoll = savedBool(savedSettings, "AntiRagdoll", false)
_G.AllowDisallowEnabled = savedBool(savedSettings, "AllowDisallowEnabled", true)
_G.PlayerESP = savedBool(savedSettings, "PlayerESP", false)
_G.PlayerESPShadow = savedBool(savedSettings, "PlayerESPShadow", true)
_G.EspBestBrainrot = savedBool(savedSettings, "EspBestBrainrot", false)
_G.AutoCarpetSpeed = savedBool(savedSettings, "AutoCarpetSpeed", false)
_G.AntiDie = savedBool(savedSettings, "AntiDie", false)
_G.AutoBalloonEnabled = savedBool(savedSettings, "AutoBalloon", false)
_G.CloneESPEnabled = savedBool(savedSettings, "CloneESP", false)
_G.AllowDisallowESPEnabled = savedBool(savedSettings, "AllowDisallowESP", false)
_G.InfiniteJumpEnabled = savedBool(savedSettings, "InfiniteJump", false)
_G.AutoTurretEnabled = savedBool(savedSettings, "AutoTurret", false)
_G.GummyBypassEnabled = savedBool(savedSettings, "GummyBypass", false)
_G.AntiAdminEnabled = savedBool(savedSettings, "AntiAdmin", false)
_G.SelectedFont = savedSettings.SelectedFont or "Gotham Bold"
_G.HideAdminPanel = savedBool(savedSettings, "HideAdminPanel", false)
_G.LineToBase = savedBool(savedSettings, "LineToBase", false)
_G.MineESPEnabled = savedBool(savedSettings, "MineESP", false)
_G.MineESPColorName = "ReezRed"
_G.MineESPColor = Color3.fromRGB(235, 50, 60)


_G.BypassProtectV1     = savedBool(savedSettings, "BypassProtectV1", false)
_G.BypassV1BlockRadius  = tonumber(savedSettings.BypassV1BlockRadius) or 4
_G.BypassV1BlockDelay   = tonumber(savedSettings.BypassV1BlockDelay) or 0.04
_G.BypassV1BlockEnabled  = savedBool(savedSettings, "BypassV1BlockEnabled", true)
_G.BypassV1GrabEnabled   = savedBool(savedSettings, "BypassV1GrabEnabled", true)
_G.AutoReturnBase      = savedBool(savedSettings, "AutoReturnBase", false)

-- AUTO BALLOON logic
local AutoBalloon = {enabled=false, active={}, cooldown={}, conn=nil}
local zones={
 {Vector3.new(-345.35,-6.55,39.19),5,"l"},{Vector3.new(-350.53,-6.55,38.67),20,"l"},{Vector3.new(-364.01,-6.55,38.94),20,"l"},{Vector3.new(-337.34,-6.55,39.18),20,"l"},
 {Vector3.new(-365.29,-6.95,-10.40),20,"s"},{Vector3.new(-354.68,-6.95,6.22),20,"s"},{Vector3.new(-343.15,-6.53,-13.20),20,"s"},{Vector3.new(-344.93,-6.95,25.73),20,"s"},{Vector3.new(-343.76,-6.95,-10.27),20,"s"},{Vector3.new(-354.42,-6.95,6.51),20,"s"},{Vector3.new(-340.48,-5.32,28.10),20,"s"},{Vector3.new(-361.10,-6.95,29.42),20,"s"},{Vector3.new(-354.83,27.19,31.22),20,"l"}
}
local function inZone(pos)
 for _,z in ipairs(zones) do local h=z[2]/2; local dx=math.abs(pos.X-z[1].X); local dz=math.abs(pos.Z-z[1].Z); if (z[3]=="l" and dx<=h and dz<=1.5) or (z[3]=="s" and dx<=h and dz<=h) then return true end end
 return false
end
local function commandBox()
 local g=PlayerGui:FindFirstChild("AdminPanel"); local p=g and g:FindFirstChild("AdminPanel"); local c=p and p:FindFirstChild("CommandBox"); return c and c:FindFirstChild("TextBox")
end
local function balloon(plr)
 local box=commandBox(); if not box then return end; local vis=box.Visible; box.Visible=false; box.Text=";balloon "..plr.Name; task.wait(.05); local ok=false
 if firesignal then ok=pcall(function() firesignal(box.FocusLost,true) end) end
 if not ok and getconnections then pcall(function() for _,c in pairs(getconnections(box.FocusLost)) do c:Fire(true) end end) end
 box.Text=""; box.Visible=vis
end
function AutoBalloon.set(on)
 AutoBalloon.enabled=on and true or false; if not AutoBalloon.enabled then AutoBalloon.active={}; AutoBalloon.cooldown={} end
 if AutoBalloon.conn then AutoBalloon.conn:Disconnect(); AutoBalloon.conn=nil end
 if AutoBalloon.enabled then AutoBalloon.conn=RunService.Heartbeat:Connect(function()
  local now=tick()
  for _,plr in ipairs(Players:GetPlayers()) do
   local ch=plr.Character; local root=ch and (ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("Torso")); local stealing=plr~=LocalPlayer and plr:GetAttribute("StealingPlayer")==true
   if stealing and root and inZone(root.Position) and not AutoBalloon.active[plr.UserId] and now-(AutoBalloon.cooldown[plr.UserId] or 0)>=0.1 then AutoBalloon.active[plr.UserId]=true; AutoBalloon.cooldown[plr.UserId]=now; task.spawn(balloon,plr)
   elseif not stealing then AutoBalloon.active[plr.UserId]=nil end
  end
 end) end
end
_G.AutoBalloon=AutoBalloon
_G.HeadlessHorsemanEnabled = savedBool(savedSettings, "HeadlessHorseman", false)
HeadlessHorseman.enabled = _G.HeadlessHorsemanEnabled == true
_G.KorbloxLegEnabled = savedBool(savedSettings, "KorbloxLeg", false)
KorbloxLeg.enabled = _G.KorbloxLegEnabled == true

local WalkItemOptions = { "Flying Carpet", "Cupid's Wings", "Witch's Broom", "Waverider", "Santa's Sleigh", "Flying Bee" }
if savedSettings.WalkItem ~= nil and table.find(WalkItemOptions, savedSettings.WalkItem) then
    _G.WalkItem = savedSettings.WalkItem
elseif _G.WalkItem == nil then
    _G.WalkItem = "Flying Carpet"
end

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")
local UpperTorso = Character:FindFirstChild("UpperTorso")
local Camera = Workspace.CurrentCamera
local autoStealEnabled = false
local stealDelay = 1.30
local isStealing = false
local currentMovement = nil
local selectedPrompt = nil
local selectedSlotNumber = nil
local player = LocalPlayer
local maxVelocity = 40
local clampVelocity = 25
local maxClamp = 15
do
    local BASE_TARGET = Vector3.new(-350.8919, -6.6011, 108.6947)
    local BASE_SPEED = 22
    local BASE_STOP_DIST = 5
    local BASE_SLOW_DIST = 22
    local FALLBACK_WALK = 32
    local returnMovement = nil
    local returnActive = false

    local function stopReturnToBase()
        returnActive = false
        if returnMovement then
            pcall(function() returnMovement:Disconnect() end)
            returnMovement = nil
        end
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            for _, n in ipairs({"ReturnVelocity", "LinearVelocity", "ReturnAttachment", "Attachment"}) do
                local o = root:FindFirstChild(n)
                if o then pcall(function() o:Destroy() end) end
            end
        end
    end

    local function startReturnToBase()
        if returnActive then return end
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root or not hum or hum.Health <= 0 then return end

        if currentMovement then
            pcall(function() currentMovement:Disconnect() end)
            currentMovement = nil
        end
        autoStealEnabled = false
        stopReturnToBase()
        returnActive = true

        local savedWalkSpeed = hum.WalkSpeed
        local savedJumpPower = hum.JumpPower

        -- Carpet (para voar bonito, mas não obrigatório)
        local carpet = nil
        local function findCarpet(container)
            if not container then return nil end
            for _, t in ipairs(container:GetChildren()) do
                if t:IsA("Tool") then
                    local n = t.Name:lower()
                    if n:find("carpet") or n:find("broom") or n:find("waverider")
                        or n:find("sleigh") or n:find("wings") or n:find("flying") then
                        return t
                    end
                end
            end
            return nil
        end
        carpet = findCarpet(char) or findCarpet(LocalPlayer:FindFirstChild("Backpack"))
        if carpet then
            pcall(function() hum:UnequipTools() end)
            task.wait(0.05)
            pcall(function() hum:EquipTool(carpet) end)
            task.wait(0.05)
        end

        -- cleanup velocity/attachment antigos
        for _, n in ipairs({"ReturnVelocity", "LinearVelocity", "ReturnAttachment", "Attachment"}) do
            local o = root:FindFirstChild(n)
            if o then pcall(function() o:Destroy() end) end
        end

        -- 🔧 WalkSpeed de fallback (se LinearVelocity falhar, ainda anda)
        pcall(function()
            hum.WalkSpeed = FALLBACK_WALK
            hum.JumpPower = 50
            hum.PlatformStand = false
            hum.AutoRotate = true
        end)

        local Attachment = Instance.new("Attachment")
        Attachment.Name = "ReturnAttachment"
        Attachment.Parent = root

        local Velocity = Instance.new("LinearVelocity")
        Velocity.Name = "ReturnVelocity"
        Velocity.Attachment0 = Attachment
        Velocity.RelativeTo = Enum.ActuatorRelativeTo.World
        Velocity.MaxForce = math.huge
        Velocity.VectorVelocity = Vector3.zero
        Velocity.Parent = root

        -- 🔧 Kickstart: pequeno pulo + seta velocidade inicial
        pcall(function()
            if UpperTorso then UpperTorso.AssemblyLinearVelocity = Vector3.new(0, 30, 0) end
        end)

        local floatStartTime = os.clock()
        local WAYPOINT = Vector3.new(-348.2184, -6.6011, 7.1711)
        local slot = selectedSlotNumber
        local useWaypoint = slot and slot >= 1 and slot <= 10
        local waypointReached = not useWaypoint

        -- 🔧 Setar velocidade inicial imediatamente (kickstart do LinearVelocity)
        local startTarget = waypointReached and BASE_TARGET or WAYPOINT
        local initDir = Vector3.new(
            startTarget.X - root.Position.X, 0,
            startTarget.Z - root.Position.Z
        )
        if initDir.Magnitude > 0.1 then
            Velocity.VectorVelocity = initDir.Unit * BASE_SPEED
        end

        local function restore()
            pcall(function()
                if hum and hum.Parent then
                    hum.WalkSpeed = savedWalkSpeed
                    hum.JumpPower = savedJumpPower
                    hum.AutoRotate = true
                end
            end)
            pcall(function() if Velocity then Velocity:Destroy() end end)
            pcall(function() if Attachment then Attachment:Destroy() end end)
        end

        returnMovement = RunService.Heartbeat:Connect(function()
            if thisScriptStopped or not returnActive then
                restore(); stopReturnToBase(); return
            end
            if not root or not root.Parent or not hum or hum.Health <= 0 then
                restore(); stopReturnToBase(); return
            end

            local rootPos = root.Position

            -- Fase 1: waypoint (slots 1–10)
            if not waypointReached then
                local wpDir = Vector3.new(WAYPOINT.X - rootPos.X, 0, WAYPOINT.Z - rootPos.Z)
                local wpDist = wpDir.Magnitude
                if wpDist <= BASE_STOP_DIST then
                    waypointReached = true
                else
                    local floatY = math.sin((os.clock() - floatStartTime) * 2) * 1.5
                    local targetY = WAYPOINT.Y + 3 + floatY
                    local vertVel = math.clamp((targetY - rootPos.Y) * 3, -8, 8)
                    local sm = wpDist < BASE_SLOW_DIST and math.max(0.25, wpDist / BASE_SLOW_DIST) or 1
                    if wpDir.Magnitude > 0.1 then
                        Velocity.VectorVelocity = Vector3.new(
                            wpDir.Unit.X * BASE_SPEED * sm,
                            vertVel,
                            wpDir.Unit.Z * BASE_SPEED * sm
                        )
                        -- Fallback: também empurra direto (se LinearVelocity falhar)
                        pcall(function()
                            if UpperTorso then
                                UpperTorso.AssemblyLinearVelocity = Vector3.new(
                                    wpDir.Unit.X * BASE_SPEED * sm,
                                    math.max(UpperTorso.AssemblyLinearVelocity.Y, 3),
                                    wpDir.Unit.Z * BASE_SPEED * sm
                                )
                            end
                        end)
                    end
                    return
                end
            end

            -- Fase 2: base
            local dir2D = Vector3.new(BASE_TARGET.X - rootPos.X, 0, BASE_TARGET.Z - rootPos.Z)
            local dist = dir2D.Magnitude
            if dist <= BASE_STOP_DIST then
                Velocity.VectorVelocity = Vector3.zero
                pcall(function() if UpperTorso then UpperTorso.AssemblyLinearVelocity = Vector3.zero end end)
                pcall(function() root.CFrame = CFrame.new(BASE_TARGET) end)
                restore()
                stopReturnToBase()
                return
            end

            local floatY = math.sin((os.clock() - floatStartTime) * 2) * 1.5
            local targetY = BASE_TARGET.Y + 3 + floatY
            local vertVel = math.clamp((targetY - rootPos.Y) * 3, -8, 8)
            local sm = dist < BASE_SLOW_DIST and math.max(0.25, dist / BASE_SLOW_DIST) or 1
            if dir2D.Magnitude > 0.1 then
                Velocity.VectorVelocity = Vector3.new(
                    dir2D.Unit.X * BASE_SPEED * sm,
                    vertVel,
                    dir2D.Unit.Z * BASE_SPEED * sm
                )
                -- Fallback direto
                pcall(function()
                    if UpperTorso then
                        UpperTorso.AssemblyLinearVelocity = Vector3.new(
                            dir2D.Unit.X * BASE_SPEED * sm,
                            math.max(UpperTorso.AssemblyLinearVelocity.Y, 3),
                            dir2D.Unit.Z * BASE_SPEED * sm
                        )
                    end
                end)
            end
        end)
    end

    _G._HighStartReturnBase = startReturnToBase
    _G._HighStopReturnBase  = stopReturnToBase

    local function isOnOwnPlotRough()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return false end
        local d = (root.Position - BASE_TARGET).Magnitude
        if d < 55 then return true end
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return false end
        for _, plot in ipairs(plots:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            local yb = sign and sign:FindFirstChild("YourBase")
            if yb and yb:IsA("BillboardGui") and yb.Enabled then
                local ok, cf = pcall(function() return plot:GetPivot() end)
                if ok and cf and (root.Position - cf.Position).Magnitude < 90 then
                    return true
                end
            end
        end
        return false
    end

    -- 🔧 check robusto: cobre os 3 nomes possíveis de atributo
    local function shouldAutoReturn()
        if not _G.AutoReturnBase or thisScriptStopped then return false end
        local stealing = false
        pcall(function()
            stealing = LocalPlayer:GetAttribute("Stealing") == true
                or LocalPlayer:GetAttribute("IsStealing") == true
                or LocalPlayer:GetAttribute("StealingPlayer") == true
        end)
        if not stealing then return false end
        if isOnOwnPlotRough() then return false end
        return true
    end

    -- 🔧 watcher por atributo (todos os 3 nomes)
    for _, attrName in ipairs({"Stealing", "IsStealing", "StealingPlayer"}) do
        table.insert(ActiveConnections, LocalPlayer:GetAttributeChangedSignal(attrName):Connect(function()
            if not shouldAutoReturn() then return end
            task.spawn(function()
                if shouldAutoReturn() and not returnActive then
                    startReturnToBase()
                end
            end)
        end))
    end

    -- 🔧 polling de fallback (caso os atributos não disparem evento)
    table.insert(ActiveConnections, task.spawn(function()
        while not thisScriptStopped do
            task.wait(0.4)
            if _G.AutoReturnBase and not returnActive and shouldAutoReturn() then
                pcall(startReturnToBase)
            end
        end
    end))
end

-- PLAYER ESP
local playerEspInstances = {}
local function clearPlayerESP()
    for userId, data in pairs(playerEspInstances) do
        pcall(function()
            if data.bb then data.bb:Destroy() end
            if data.highlight then data.highlight:Destroy() end
        end)
        playerEspInstances[userId] = nil
    end
end
local function createPlayerESP(player)
    if not _G.PlayerESP then return end
    local char = player.Character
    if not char then return end
    if playerEspInstances[player.UserId] then
        local data = playerEspInstances[player.UserId]
        if data.bb and data.bb.Adornee ~= char then data.bb.Adornee = char end
        return
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "67_ESP"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 25, 25)
    highlight.FillTransparency = 0.42
    highlight.OutlineTransparency = 0.2
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = char
    highlight.Parent = char
    local bb = Instance.new("BillboardGui")
    bb.Name = "67_ESP"
    bb.Size = UDim2.new(0, 120, 0, 28)
    bb.StudsOffset = Vector3.new(0, 3.5, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = hrp
    bb.MaxDistance = 250
    bb.Parent = char
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.DisplayName
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    nameLabel.TextScaled = true
    nameLabel.TextStrokeTransparency = 0.2
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Parent = bb
    playerEspInstances[player.UserId] = { bb = bb, highlight = highlight, character = char }
end
local function updatePlayerESP()
    if not _G.PlayerESP then
        clearPlayerESP()
        return
    end
    local currentPlayers = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            currentPlayers[p.UserId] = true
            createPlayerESP(p)
        end
    end
    for userId, data in pairs(playerEspInstances) do
        if not currentPlayers[userId] then
            pcall(function()
                if data.bb then data.bb:Destroy() end
                if data.highlight then data.highlight:Destroy() end
            end)
            playerEspInstances[userId] = nil
        end
    end
end
-- ESP PLAYER SHADOW REAL (derivado de EspShadow(REEZ): clone AH_SRVPOS atrasado)
do
    local running = false
    local connections = {}
    local posHistory = {}
    local srvClone = nil
    local srvParts = {}
    local ServerColor = Color3.fromRGB(255, 0, 0)
    local ServerDelay = 0.08
    local HistoryWindow = 1.1
    local JUNK = {
        Humanoid=1, Script=1, LocalScript=1, ModuleScript=1,
        Sound=1, ParticleEmitter=1, Decal=1, Texture=1,
        SurfaceAppearance=1, Beam=1, Trail=1, Fire=1,
        Smoke=1, Sparkles=1, Light=1, BillboardGui=1,
        SurfaceGui=1, Constraint=1, JointInstance=1, Tool=1,
    }
    local function clearConnections()
        for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
        connections = {}
    end
    local function destroySrvClone()
        if srvClone then pcall(function() srvClone:Destroy() end) end
        srvClone = nil
        srvParts = {}
        posHistory = {}
    end
    local function getRelPath(part, rootPart)
        local path, cur = {}, part
        while cur and cur ~= rootPart do
            table.insert(path, 1, cur.Name)
            cur = cur.Parent
        end
        return table.concat(path, "/")
    end
    local function applyFFColor(model)
        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then
                part:SetAttribute("__REEZ_SHADOW", true)
                part.Material = Enum.Material.ForceField
                part.Color = ServerColor
                part.Transparency = 0
                part.Reflectance = 0
            end
        end
    end
    local function buildSrvClone()
        destroySrvClone()
        local camera = Workspace.CurrentCamera
        local char = LocalPlayer.Character
        if not (camera and char and char:FindFirstChild("HumanoidRootPart")) then return end
        local wasArchivable = char.Archivable
        char.Archivable = true
        local clone = char:Clone()
        char.Archivable = wasArchivable
        if not (clone and clone:IsA("Model")) then return end
        local origMap = {}
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then origMap[getRelPath(part, char)] = part end
        end
        local baseParts, toDelete = {}, {}
        for _, child in ipairs(clone:GetDescendants()) do
            if child:IsA("BasePart") then
                table.insert(baseParts, { part = child, path = getRelPath(child, clone) })
            else
                for className in pairs(JUNK) do
                    if child:IsA(className) then table.insert(toDelete, child); break end
                end
            end
        end
        for _, obj in ipairs(toDelete) do pcall(function() obj:Destroy() end) end
        local paired = {}
        for _, entry in ipairs(baseParts) do
            local ghost, live = entry.part, origMap[entry.path]
            if not live or ghost.Transparency >= 0.95 then
                pcall(function() ghost:Destroy() end)
            else
                ghost.Anchored = true
                ghost.CanCollide = false
                ghost.CanQuery = false
                ghost.CanTouch = false
                ghost.Massless = true
                ghost.CastShadow = false
                table.insert(paired, { g = ghost, l = live })
            end
        end
        if #paired == 0 then pcall(function() clone:Destroy() end); return end
        clone.Name = "AH_SRVPOS"
        clone:SetAttribute("REEZ_ESP_SHADOW", true)
        clone.Parent = camera
        applyFFColor(clone)
        task.delay(0.25, function() if clone.Parent then applyFFColor(clone) end end)
        srvClone, srvParts = clone, paired
    end
    local function updateShadow()
        if not _G.PlayerESPShadow then destroySrvClone(); return end
        local char = LocalPlayer.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        local now = os.clock()
        posHistory[#posHistory + 1] = { t = now, cf = rootPart.CFrame }
        while #posHistory > 2 and now - posHistory[1].t > HistoryWindow do table.remove(posHistory, 1) end
        if not srvClone or not srvClone.Parent then buildSrvClone() end
        if not (srvClone and #srvParts > 0) then return end
        local targetCF = posHistory[1].cf
        for i = #posHistory, 1, -1 do
            local entry = posHistory[i]
            if entry and now - entry.t >= ServerDelay then targetCF = entry.cf; break end
        end
        local rootInv = rootPart.CFrame:Inverse()
        for _, entry in ipairs(srvParts) do
            if entry.g.Parent and entry.l.Parent then
                entry.g.CFrame = targetCF * rootInv * entry.l.CFrame
                entry.g.Color = ServerColor
                entry.g.Material = Enum.Material.ForceField
                entry.g.Transparency = 0
            end
        end
    end
    local function startShadow()
        if running then return end
        running = true
        connections[#connections + 1] = LocalPlayer.CharacterAdded:Connect(function()
            task.wait(0.15)
            if running then destroySrvClone() end
        end)
        connections[#connections + 1] = RunService.Heartbeat:Connect(function()
            if running then pcall(updateShadow) end
        end)
    end
    local function stopShadow()
        running = false
        clearConnections()
        destroySrvClone()
    end
    _G.ESPPlayerShadow = {
        set = function(on)
            _G.PlayerESPShadow = on == true
            if _G.PlayerESPShadow then startShadow() else stopShadow() end
        end,
        start = startShadow,
        stop = stopShadow,
    }
    if _G.PlayerESPShadow then startShadow() end
end

-- ESP BEST BRAINROT (integrado; controlado pelo toggle da aba Visual)
do
    local running = false
    local connections = {}
    local scanContainer = nil
    local petData = {}
    local isNotifying = false
    local NOTIFY_DURATION = 5
    local BEST_BLACKLIST = {
        "animalpodiums", "decorations", "invisiblewalls", "laser", "laserhitbox",
        "purchases", "skin", "unlock", "cash", "friendpanel", "animaltarget",
        "deliveryhitbox", "mainroot", "multiplier", "plotsign", "slope", "spawn",
        "stealthitbox", "root", "hitbox", "model", "part", "floor", "wall", "path", "grass", "barrier"
    }

    local function isBlacklisted(name)
        local lower = string.lower(tostring(name or ""))
        for _, word in ipairs(BEST_BLACKLIST) do
            if word == "model" or word == "part" then
                if lower == word then return true end
            elseif string.find(lower, word, 1, true) then
                return true
            end
        end
        return false
    end

    local function clearScan()
        for tracker in pairs(petData) do
            petData[tracker] = nil
        end
        if scanContainer then
            pcall(function() scanContainer:Destroy() end)
            scanContainer = nil
        end
    end

    local function getMoneyText(item)
        local best, fallback = nil, nil
        local primary = item:IsA("Model") and item.PrimaryPart
            or (item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart", true))
        local closestBest, closestFallback = 10, 10
        local function inspectGui(gui, distance)
            for _, label in ipairs(gui:GetDescendants()) do
                if (label:IsA("TextLabel") or label:IsA("TextButton") or label:IsA("TextBox")) and label.Text ~= "" then
                    local text = tostring(label.Text)
                    local lower = string.lower(text)
                    if string.find(text, "$", 1, true) and string.find(lower, "/s", 1, true) then
                        if distance <= closestBest then closestBest, best = distance, text end
                    elseif string.find(text, "$", 1, true) and distance <= closestFallback then
                        closestFallback, fallback = distance, text
                    end
                end
            end
        end
        inspectGui(item, 0)
        for _, gui in ipairs(Workspace:GetDescendants()) do
            if gui:IsA("BillboardGui") or gui:IsA("SurfaceGui") then
                local adornee = gui.Adornee
                if adornee and (adornee == item or adornee:IsDescendantOf(item)) then
                    inspectGui(gui, 0)
                elseif primary and gui.Parent and gui.Parent:IsA("BasePart") then
                    local distance = (gui.Parent.Position - primary.Position).Magnitude
                    if distance <= closestBest or distance <= closestFallback then inspectGui(gui, distance) end
                end
            end
        end
        if best then return best end
        if fallback then return fallback end
        local keywords = {"prod", "sec", "money", "cash", "coin", "income", "yield", "rate", "amount", "value", "give"}
        for name, value in pairs(item:GetAttributes()) do
            local lower = string.lower(tostring(name))
            for _, keyword in ipairs(keywords) do
                if string.find(lower, keyword, 1, true) then return "$" .. tostring(value) .. "/s" end
            end
        end
        for _, valueObject in ipairs(item:GetDescendants()) do
            if valueObject:IsA("ValueBase") then
                local lower = string.lower(valueObject.Name)
                for _, keyword in ipairs(keywords) do
                    if string.find(lower, keyword, 1, true) then return "$" .. tostring(valueObject.Value) .. "/s" end
                end
            end
        end
    end

    local function parseMoneyValue(text)
        if not text or text == "" then return 0 end
        local compact = tostring(text):gsub(",", ""):gsub("%s", "")
        local number = tonumber(compact:match("([%d%.]+)")) or 0
        local upper = string.upper(compact)
        if string.find(upper, "T", 1, true) then return number * 1e12 end
        if string.find(upper, "B", 1, true) then return number * 1e9 end
        if string.find(upper, "M", 1, true) then return number * 1e6 end
        if string.find(upper, "K", 1, true) then return number * 1e3 end
        return number
    end

    local function addActionsBorder(target, thickness)
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = thickness or 1.6
        stroke.Color = Color3.new(1, 1, 1)
        stroke.Transparency = 0
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.LineJoinMode = Enum.LineJoinMode.Round
        stroke.Parent = target
        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(0.22, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(0.38, Color3.fromRGB(235, 40, 52)),
            ColorSequenceKeypoint.new(0.55, Color3.fromRGB(255, 75, 85)),
            ColorSequenceKeypoint.new(0.72, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(0.86, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 40, 52)),
        })
        gradient.Parent = stroke
        table.insert(connections, RunService.Heartbeat:Connect(function()
            if gradient and gradient.Parent then gradient.Rotation = (tick() * 70) % 360 end
        end))
    end

    local function showBestNotification(name, valueLabel, model)
        if isNotifying or not running then return end
        isNotifying = true
        for _, gui in ipairs(PlayerGui:GetChildren()) do
            if gui.Name == "BestBrainrotNotify" then gui:Destroy() end
        end
        local gui = Instance.new("ScreenGui")
        gui.Name = "BestBrainrotNotify"
        gui.ResetOnSpawn = false
        gui.DisplayOrder = 9999
        gui.IgnoreGuiInset = true
        gui.Parent = PlayerGui
        local width, height = 260, 76
        local frame = Instance.new("Frame")
        frame.Size = UDim2.fromOffset(width, height)
        frame.Position = UDim2.new(1, width + 30, 0, 20)
        frame.BackgroundColor3 = Color3.fromRGB(15, 6, 8)
        frame.BorderSizePixel = 0
        frame.ClipsDescendants = false
        frame.Parent = gui
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
        addActionsBorder(frame, 1.6)
        local grad = Instance.new("UIGradient", frame)
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 10, 18)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 6, 10)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 10, 18)),
        })
        grad.Rotation = 90
        local preview = Instance.new("Frame", frame)
        preview.Size = UDim2.fromOffset(60, 60)
        preview.Position = UDim2.new(0, 8, 0.5, -30)
        preview.BackgroundColor3 = Color3.fromRGB(32, 10, 12)
        preview.BorderSizePixel = 0
        preview.ZIndex = 3
        preview.ClipsDescendants = true
        Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 10)
        addActionsBorder(preview, 1.2)
        local viewport = Instance.new("ViewportFrame", preview)
        viewport.Size = UDim2.new(1, -2, 1, -2)
        viewport.Position = UDim2.fromOffset(1, 1)
        viewport.BackgroundTransparency = 1
        viewport.ZIndex = 4
        local camera = Instance.new("Camera", viewport)
        viewport.CurrentCamera = camera
        if model and model.Parent then
            task.spawn(function()
                local ok, clone = pcall(function() return model:Clone() end)
                if not ok or not clone or not viewport.Parent then return end
                for _, descendant in ipairs(clone:GetDescendants()) do
                    if descendant:IsA("Script") or descendant:IsA("LocalScript") or descendant:IsA("Highlight") then descendant:Destroy() end
                end
                clone.Parent = viewport
                local _, size = clone:GetBoundingBox()
                local distance = math.max(size.Magnitude * 1.4, 2.5)
                local y = size.Y * 0.15
                for _, part in ipairs(clone:GetDescendants()) do if part:IsA("BasePart") then part.Anchored = true end end
                local primary = clone.PrimaryPart or clone:FindFirstChildWhichIsA("BasePart", true)
                if primary then clone.PrimaryPart = primary; clone:PivotTo(CFrame.new()) end
                local angle = 0
                local rotationConnection
                rotationConnection = RunService.Heartbeat:Connect(function(dt)
                    if not viewport.Parent or not gui.Parent then rotationConnection:Disconnect(); return end
                    angle = (angle + dt * 90) % 360
                    pcall(function() clone:PivotTo(CFrame.Angles(0, math.rad(angle), 0)) end)
                    camera.CFrame = CFrame.new(Vector3.new(0, y, distance), Vector3.new(0, y * 0.3, 0))
                end)
            end)
        end
        local function label(text, position, size, color, font)
            local result = Instance.new("TextLabel", frame)
            result.Size = UDim2.new(1, -80, 0, size)
            result.Position = position
            result.BackgroundTransparency = 1
            result.Text = text
            result.TextColor3 = color
            result.Font = font
            result.TextSize = size
            result.TextXAlignment = Enum.TextXAlignment.Left
            result.TextWrapped = true
            result.ZIndex = 4
            return result
        end
        label("BEST BRAINROT", UDim2.fromOffset(74, 12), 12, Color3.fromRGB(255, 110, 120), Enum.Font.GothamBold)
        label(name or "Pet", UDim2.fromOffset(74, 26), 20, Color3.fromRGB(255, 235, 235), Enum.Font.GothamBold)
        label("Value: " .. tostring(valueLabel or "?"), UDim2.fromOffset(74, 50), 14, Color3.fromRGB(255, 150, 155), Enum.Font.Gotham)
        local slideIn = TweenService:Create(frame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -width - 20, 0, 20)})
        slideIn:Play(); slideIn.Completed:Wait()
        task.wait(NOTIFY_DURATION)
        local slideOut = TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, width + 30, 0, 20)})
        slideOut:Play(); slideOut.Completed:Wait()
        if gui then gui:Destroy() end
        isNotifying = false
    end

    local function registerPet(item)
        if not running or not item or isBlacklisted(item.Name) then return end
        local primary = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart", true)) or (item:IsA("BasePart") and item)
        if not primary or not scanContainer then return end
        local tracker = Instance.new("BillboardGui")
        tracker.Name = string.sub(item:GetFullName(), 1, 100)
        tracker.Adornee = primary
        tracker.Size = UDim2.fromOffset(1, 1)
        tracker.AlwaysOnTop = false
        tracker.Parent = scanContainer
        task.spawn(function()
            while running and tracker.Parent and item.Parent do
                local moneyText = getMoneyText(item)
                local value = parseMoneyValue(moneyText)
                if value > 0 then petData[tracker] = {value = value, name = item.Name, model = item, label = moneyText} end
                task.wait(2)
            end
            petData[tracker] = nil
            pcall(function() tracker:Destroy() end)
        end)
        table.insert(connections, item.Destroying:Connect(function() petData[tracker] = nil; pcall(function() tracker:Destroy() end) end))
    end

    local function scanForPets(container)
        if not running or not container then return end
        for index, item in ipairs(container:GetChildren()) do
            if index % 100 == 0 then task.wait() end
            if not isBlacklisted(item.Name) then
                if item:IsA("Model") or item:IsA("BasePart") then registerPet(item)
                elseif item:IsA("Folder") or item:IsA("Configuration") then scanForPets(item) end
            end
        end
    end

    local function handlePlot(plot)
        if not running then return end
        task.spawn(function() scanForPets(plot) end)
        table.insert(connections, plot.ChildAdded:Connect(function(item)
            task.wait(0.5)
            if running and not isBlacklisted(item.Name) then
                if item:IsA("Model") or item:IsA("BasePart") then registerPet(item) else scanForPets(item) end
            end
        end))
    end

    local bestState = {
        pendingName = "",
        pendingTicks = 0,
        lastName = "",
        lastTime = 0,
    }
    local function start()
        if running then return end
        running = true
        bestState.pendingName = ""
        bestState.pendingTicks = 0
        scanContainer = Instance.new("Folder")
        scanContainer.Name = "BestBrainrot_Scan"
        scanContainer.Parent = CoreGui
        local plots = Workspace:FindFirstChild("Plots")
        if plots then
            for _, plot in ipairs(plots:GetChildren()) do handlePlot(plot) end
            table.insert(connections, plots.ChildAdded:Connect(handlePlot))
        end
        table.insert(connections, RunService.Heartbeat:Connect(function()
            if not running then return end
            local highest = {value = 0, name = "", model = nil, label = ""}
            for tracker, data in pairs(petData) do
                if tracker.Parent and data.value > highest.value then highest = data end
            end
            if highest.value > 0 and highest.name ~= "" then
                if bestState.pendingName == highest.name then
                    bestState.pendingTicks = bestState.pendingTicks + 1
                else
                    bestState.pendingName = highest.name
                    bestState.pendingTicks = 1
                end
                if bestState.pendingTicks >= 3 and highest.name ~= bestState.lastName and tick() - bestState.lastTime > 20 then
                    bestState.lastName, bestState.lastTime = highest.name, tick()
                    task.spawn(function() showBestNotification(highest.name, highest.label, highest.model) end)
                end
            else
                bestState.pendingName, bestState.pendingTicks = "", 0
            end
        end))
    end
    local function stop()
        running = false
        for _, connection in ipairs(connections) do pcall(function() connection:Disconnect() end) end
        connections = {}
        clearScan()
        for _, gui in ipairs(PlayerGui:GetChildren()) do if gui.Name == "BestBrainrotNotify" then gui:Destroy() end end
        isNotifying = false
    end
    local initialEnabled = _G.EspBestBrainrot == true
    _G.EspBestBrainrotController = { set = function(on) _G.EspBestBrainrot = on == true; if on then start() else stop() end end, start = start, stop = stop }
    if initialEnabled then _G.EspBestBrainrotController.set(true) end
end

Players.PlayerAdded:Connect(function(p) task.wait(0.5) updatePlayerESP() end)
Players.PlayerRemoving:Connect(function(p)
    if playerEspInstances[p.UserId] then
        pcall(function()
            local data = playerEspInstances[p.UserId]
            if data.bb then data.bb:Destroy() end
            if data.highlight then data.highlight:Destroy() end
        end)
        playerEspInstances[p.UserId] = nil
    end
end)
LocalPlayer.CharacterAdded:Connect(function() task.wait(0.5) updatePlayerESP() end)
task.spawn(function()
    while true do
        pcall(updatePlayerESP)
        task.wait(0.5)
    end
end)

-- CLONE ESP  (FIXED: 100% HIDDEN_GUI)
_G.CloneESP = (function()
    local _cr = (type(cloneref) == "function") and cloneref or function(o) return o end
    local Players    = _cr(game:GetService("Players"))
    local Workspace  = _cr(game:GetService("Workspace"))
    local RunService = _cr(game:GetService("RunService"))

    local enabled = false
    local conns = {}
    local labels = {}

    local function getPlayerFromClone(clone)
        if not clone:IsA("Model") then return nil end
        local hum = clone:FindFirstChildOfClass("Humanoid")
        if not hum then return nil end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then
                local ch = plr.Character:FindFirstChildOfClass("Humanoid")
                if ch and ch.DisplayName == hum.DisplayName then
                    return plr
                end
            end
        end
        local n = clone.Name
        local base = n:match("^(.-)_Clone$")
        if base then
            local plr = Players:FindFirstChild(base)
            if plr and plr:IsA("Player") then return plr end
        end
        return nil
    end

    local function highlightClone(clone)
        if not clone or not clone.Parent then return end
        local existing = clone:FindFirstChild("CloneHighlight")
        if existing then pcall(function() existing:Destroy() end) end
        if labels[clone] then
            pcall(function() labels[clone]:Destroy() end)
            labels[clone] = nil
        end

        local head = clone:FindFirstChild("Head")
        local plr = getPlayerFromClone(clone)

        local hl = Instance.new("Highlight")
        hl.Name = "CloneHighlight"
        hl.FillColor = Color3.fromRGB(235, 50, 60)
        hl.OutlineColor = Color3.fromRGB(255, 130, 140)
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.FillTransparency = 0.3
        hl.OutlineTransparency = 0.1
        hl.Adornee = clone
        hl.Parent = clone

        if head then
            local hum = clone:FindFirstChildOfClass("Humanoid")
            local dn = hum and hum.DisplayName or ""
            local pn = ""
            if plr then
                pn = plr.Name
                if dn == "" then dn = plr.DisplayName end
            end
            local who = pn ~= "" and pn or (dn ~= "" and dn or "?")
            local tag = string.format("%s's clone", who)

            local bb = Instance.new("BillboardGui")
            bb.Name = "CloneLabel"
            bb.Size = UDim2.new(0, 160, 0, 28)
            bb.StudsOffset = Vector3.new(0, 2.5, 0)
            bb.AlwaysOnTop = true
            bb.LightInfluence = 0
            bb.MaxDistance = 0
            bb.ClipsDescendants = false
            bb.Adornee = head
            bb.Parent = HIDDEN_GUI or head

            local background = Instance.new("Frame")
            background.Size = UDim2.new(1, 0, 1, 0)
            background.BackgroundColor3 = Color3.fromRGB(18, 16, 14)
            background.BackgroundTransparency = 0.3
            background.BorderSizePixel = 0
            background.Parent = bb

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 12)
            corner.Parent = background

            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(255, 130, 140)
            stroke.Thickness = 1
            stroke.Transparency = 0.3
            stroke.Parent = background

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = tag
            lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            lbl.TextSize = 11
            lbl.Font = Enum.Font.GothamBold
            lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            lbl.TextStrokeTransparency = 0.2
            lbl.TextXAlignment = Enum.TextXAlignment.Center
            lbl.TextYAlignment = Enum.TextYAlignment.Center
            lbl.Parent = background

            labels[clone] = bb
        end
    end

    local function clearAll()
        for clone, bb in pairs(labels) do
            pcall(function() bb:Destroy() end)
            labels[clone] = nil
        end
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj:IsA("Model") and obj.Name:find("_Clone") then
                local hl = obj:FindFirstChild("CloneHighlight")
                if hl then pcall(function() hl:Destroy() end) end
            end
        end
    end

    local function rescan()
        if not enabled then return end
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj:IsA("Model") and obj.Name:find("_Clone")
                and not obj:FindFirstChild("CloneHighlight") then
                pcall(highlightClone, obj)
            end
        end
    end

    local function start()
        clearAll()
        conns.added = Workspace.ChildAdded:Connect(function(child)
            if enabled and child:IsA("Model") and child.Name:find("_Clone") then
                task.wait(0.1)
                pcall(highlightClone, child)
            end
        end)
        local acc = 0
        conns.hb = RunService.Heartbeat:Connect(function(dt)
            if not enabled then return end
            acc = acc + (dt or 0.016)
            if acc < 0.5 then return end
            acc = 0
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj:IsA("Model") and obj.Name:find("_Clone")
                    and not obj:FindFirstChild("CloneHighlight") then
                    pcall(highlightClone, obj)
                end
            end
        end)
        rescan()
    end

    local function stop()
        for _, c in pairs(conns) do
            if c then pcall(function() c:Disconnect() end) end
        end
        conns = {}
        clearAll()
    end

    local M = {}
    function M.set(on)
        enabled = on and true or false
        if enabled then start() else stop() end
    end
    function M.isEnabled() return enabled end
    return M
end)()

table.insert(ActiveConnections, function()
    if _G.CloneESP and _G.CloneESP.set then _G.CloneESP.set(false) end
end)

-- ALLOW/DISALLOW ESP
_G.AllowDisallowESP = (function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP = Players.LocalPlayer

    local DISALLOW_IMAGE = "rbxassetid://110783679426495"
    local COL_ALLOW = Color3.fromRGB(60, 230, 110)
    local COL_DISALLOW = Color3.fromRGB(240, 60, 60)

    local M = {
        enabled = false,
        pool = {},
        conn = nil,
        childConns = {},
        plotsList = {},
    }

    local espParentGui

    local function getEspParent()
        if espParentGui and espParentGui.Parent then return espParentGui end
        local parent = HIDDEN_GUI
        if not parent then return nil end
        local gui
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("ScreenGui") and (child:GetAttribute("HighAllowDisallowESP") or child.Name == "HighAllowDisallowESP") then
                gui = child
                break
            end
        end
        if not gui then
            gui = Instance.new("ScreenGui")
            gui.Name = "67"
            gui:SetAttribute("HighAllowDisallowESP", true)
            gui.ResetOnSpawn = false
            gui.IgnoreGuiInset = true
            gui.DisplayOrder = 50
            gui.Parent = parent
        end
        gui.Name = "67"
        gui:SetAttribute("HighAllowDisallowESP", true)
        espParentGui = gui
        return gui
    end

    local function getOrCreate(key, adornee)
        local entry = M.pool[key]
        if not entry or not entry.bb or not entry.bb.Parent then
            local parent = getEspParent()
            if not parent then return nil end
            local bb = Instance.new("BillboardGui")
            bb.Name = "AD_ESP_" .. tostring(key):gsub("%W", "_")
            bb.Size = UDim2.new(0, 36, 0, 36)
            bb.StudsOffset = Vector3.new(0, 2.4, 0)
            bb.AlwaysOnTop = true
            bb.LightInfluence = 0
            bb.MaxDistance = math.huge
            bb.Enabled = false
            bb.Parent = parent

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.BorderSizePixel = 0
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 28
            lbl.Text = ""
            lbl.TextColor3 = COL_ALLOW
            lbl.TextStrokeTransparency = 0.35
            lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            lbl.Parent = bb

            entry = { bb = bb, lbl = lbl, used = false }
            M.pool[key] = entry
        end
        if adornee then entry.bb.Adornee = adornee end
        return entry
    end

    local function isDisallowed(friendPanel)
        local main = friendPanel:FindFirstChild("Main")
        if not main then return false end
        local sg = main:FindFirstChild("SurfaceGui")
        if not sg then return false end
        local img = sg:FindFirstChild("ImageLabel")
        if not img then
            for _, d in ipairs(sg:GetDescendants()) do
                if d:IsA("ImageLabel") then img = d break end
            end
        end
        if not img then return false end
        return img.Image == DISALLOW_IMAGE
    end

    local function getAdornee(friendPanel)
        if friendPanel:IsA("BasePart") then return friendPanel end
        if friendPanel.PrimaryPart then return friendPanel.PrimaryPart end
        return friendPanel:FindFirstChildWhichIsA("BasePart", true)
    end

    local function refreshPlotsList()
        M.plotsList = {}
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return end
        for _, p in ipairs(plots:GetChildren()) do
            if p:IsA("Model") then table.insert(M.plotsList, p) end
        end
    end

    local function clearAll()
        for _, entry in pairs(M.pool) do
            if entry.bb then pcall(function() entry.bb:Destroy() end) end
        end
        M.pool = {}
        if espParentGui then
            pcall(function() espParentGui:Destroy() end)
            espParentGui = nil
        end
    end

    local acc = 0
    local function onHeartbeat(dt)
        if not M.enabled then return end
        acc = acc + (dt or 0.016)
        if acc < 0.12 then return end
        acc = 0

        for _, e in pairs(M.pool) do e.used = false end
        if #M.plotsList == 0 then refreshPlotsList() end

        for _, plot in ipairs(M.plotsList) do
            if plot and plot.Parent then
                local friendPanel = plot:FindFirstChild("FriendPanel")
                if not friendPanel then friendPanel = plot:FindFirstChild("FriendPanel", true) end
                if friendPanel then
                    local adornee = getAdornee(friendPanel)
                    if adornee then
                        local entry = getOrCreate(plot.Name, adornee)
                        if entry then
                            local dis = isDisallowed(friendPanel)
                            local txt = dis and "X" or "✓"
                            local col = dis and COL_DISALLOW or COL_ALLOW
                            if entry.lbl.Text ~= txt then entry.lbl.Text = txt end
                            entry.lbl.TextColor3 = col
                            entry.bb.Enabled = true
                            entry.used = true
                        end
                    end
                end
            end
        end

        for _, e in pairs(M.pool) do
            if not e.used and e.bb and e.bb.Enabled then e.bb.Enabled = false end
        end
    end

    local function stopConns()
        if M.conn then pcall(function() M.conn:Disconnect() end) M.conn = nil end
        for _, c in ipairs(M.childConns) do pcall(function() c:Disconnect() end) end
        M.childConns = {}
    end

    function M.set(on)
        M.enabled = on and true or false
        stopConns()
        if not on then clearAll() return end
        refreshPlotsList()
        local plots = workspace:FindFirstChild("Plots")
        if plots then
            table.insert(M.childConns, plots.ChildAdded:Connect(function() task.defer(refreshPlotsList) end))
            table.insert(M.childConns, plots.ChildRemoved:Connect(function() task.defer(refreshPlotsList) end))
        end
        M.conn = RunService.Heartbeat:Connect(onHeartbeat)
    end

    function M.isEnabled() return M.enabled end
    return M
end)()

table.insert(ActiveConnections, function()
    if _G.AllowDisallowESP and _G.AllowDisallowESP.set then _G.AllowDisallowESP.set(false) end
end)

-- GAME STRETCHER & CAMERA FOV
_G.GameStretcher = (function()
    local RunService = game:GetService("RunService")
    local M = {
        enabled = false,
        originalFOV = nil,
        stretchConn = nil,
        stretchFactor = 0.75,
        targetFOV = 70,
        stretchCFrame = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.75, 0, 0, 0, 1),
    }

    local function applyStretch()
        if not M.enabled then return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        pcall(function()
            cam.CFrame = cam.CFrame * M.stretchCFrame
            local targetFov = M.targetFOV or 70
            if math.abs(cam.FieldOfView - targetFov) > 0.05 then
                cam.FieldOfView = targetFov
            end
        end)
    end

    local function enable()
        if M.enabled then return end
        M.enabled = true
        local cam = workspace.CurrentCamera
        if cam then M.originalFOV = cam.FieldOfView end
        pcall(function()
            RunService:BindToRenderStep("FH_GameStretch", Enum.RenderPriority.Camera.Value + 1, applyStretch)
        end)
        if not M.stretchConn then
            M.stretchConn = RunService.RenderStepped:Connect(function()
                if M.enabled then applyStretch() end
            end)
        end
    end

    local function disable()
        if not M.enabled then return end
        M.enabled = false
        pcall(function() RunService:UnbindFromRenderStep("FH_GameStretch") end)
        if M.stretchConn then pcall(function() M.stretchConn:Disconnect() end) M.stretchConn = nil end
        local cam = workspace.CurrentCamera
        if cam and M.originalFOV then pcall(function() cam.FieldOfView = M.originalFOV end) end
    end

    function M.set(on) if on then enable() else disable() end end
    function M.isEnabled() return M.enabled end
    function M.setFactor(factor)
        factor = tonumber(factor) or 0.75
        factor = math.clamp(factor, 0.1, 1.5)
        M.stretchFactor = factor
        M.stretchCFrame = CFrame.new(0, 0, 0, 1, 0, 0, 0, factor, 0, 0, 0, 1)
    end
    function M.setFOV(fov)
        fov = tonumber(fov) or 70
        fov = math.clamp(fov, 60, 120)
        M.targetFOV = fov
        if not M.enabled then
            local cam = workspace.CurrentCamera
            if cam then pcall(function() cam.FieldOfView = fov end) end
        end
    end
    return M
end)()

table.insert(ActiveConnections, function()
    if _G.GameStretcher and _G.GameStretcher.set then _G.GameStretcher.set(false) end
end)

-- INFINITE JUMP
_G.InfiniteJump = (function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local LP = Players.LocalPlayer

    local M = {
        enabled = false,
        conn = nil,
        holdConn = nil,
        characterConn = nil,
    }

    local function getUpperTorso(char)
        return char and char:FindFirstChild("UpperTorso")
    end

    local function setVerticalVelocity(upperTorso, y)
        if not upperTorso then return end
        local velocity = upperTorso.AssemblyLinearVelocity
        upperTorso.AssemblyLinearVelocity = Vector3.new(velocity.X, y, velocity.Z)
    end

    local function onJumpRequest()
        if not M.enabled then return end
        local char = LP.Character
        if not char then return end
        pcall(function() setVerticalVelocity(getUpperTorso(char), 55) end)
    end

    local function startHoldLoop()
        M.holdConn = task.spawn(function()
            while true do
                RunService.Heartbeat:Wait()
                if not M.enabled then break end
                local char = LP.Character
                local upperTorso = getUpperTorso(char)
                if upperTorso then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local jumpHeld = UserInputService:IsKeyDown(Enum.KeyCode.Space)
                        or (hum and hum.Jump == true)
                    local velocity = upperTorso.AssemblyLinearVelocity
                    if jumpHeld and velocity.Y < 30 then
                        setVerticalVelocity(upperTorso, 55)
                    elseif velocity.Y < -120 then
                        setVerticalVelocity(upperTorso, -120)
                    end
                end
            end
        end)
    end

    local function stopListening()
        if M.conn then pcall(function() M.conn:Disconnect() end); M.conn = nil end
        if M.holdConn then pcall(function() task.cancel(M.holdConn) end); M.holdConn = nil end
    end

    function M.set(on)
        M.enabled = on and true or false
        stopListening()
        if M.enabled then
            M.conn = UserInputService.JumpRequest:Connect(onJumpRequest)
            startHoldLoop()
        end
    end
    function M.isEnabled() return M.enabled end

    M.characterConn = LP.CharacterAdded:Connect(function()
        if M.enabled then task.defer(function() M.set(true) end) end
    end)
    return M
end)()

table.insert(ActiveConnections, function()
    if _G.InfiniteJump and _G.InfiniteJump.set then _G.InfiniteJump.set(false) end
end)

-- ANTI TURRET
_G.AutoTurret = (function()
    local cloneref = cloneref or function(o) return o end
    local Players = cloneref(game:GetService("Players"))
    local Workspace = cloneref(game:GetService("Workspace"))
    local lp = Players.LocalPlayer
    local autoTurretEnabled = false
    local turretConns = {}
    local turretLoopRunning = false
    local turretAttackBusy = setmetatable({}, { __mode = "k" })
    local turretAttackQueued = setmetatable({}, { __mode = "k" })
    local turretAttackCD = setmetatable({}, { __mode = "k" })
    local turretAttackActive = false
    local RETRY_DELAY = 0.3

    local function isEnemyTurret(obj)
        if not obj or not obj:IsA("BasePart") then return false end
        local ownerId = obj.Name:match("^Sentry_(%d+)$")
        return ownerId ~= nil and ownerId ~= tostring(lp.UserId)
    end

    local function setTurretNoClip(turret)
        if not isEnemyTurret(turret) then return end
        pcall(function() turret.CanCollide = false end)
    end

    local function getTurretTimeLabel(turret)
        if not turret or not turret.Parent then return nil end
        local sf = turret:FindFirstChild("SetupFrame")
        local mf = sf and sf:FindFirstChild("MainFrame")
        local lbl = mf and mf:FindFirstChild("Time")
        if lbl and lbl:IsA("TextLabel") then return lbl end
        return nil
    end

    local function shouldAttackTurret(turret)
        if not lp then return false end
        local okSteal, stealing = pcall(function() return lp:GetAttribute("Stealing") ~= nil end)
        if okSteal and stealing then return false end
        if not isEnemyTurret(turret) then return false end
        setTurretNoClip(turret)
        local lbl = getTurretTimeLabel(turret)
        if not lbl then return false end
        local ok, text = pcall(function() return lbl.Text end)
        if not ok then return false end
        text = tostring(text or ""):gsub("^%s+", ""):gsub("%s+$", "")
        return text ~= "" and string.find(text, "^%d+s!$") ~= nil
    end

    local function bringTurretInFront(turret, hrp)
        if not turret or not hrp then return end
        local fwd = hrp.CFrame.LookVector
        local pos = hrp.Position + fwd * 4 + Vector3.new(0, 1.2, 0)
        local cf = CFrame.lookAt(pos, pos + fwd)
        pcall(function()
            local upperTorso = hrp.Parent and hrp.Parent:FindFirstChild("UpperTorso")
            if upperTorso then upperTorso.AssemblyLinearVelocity = Vector3.zero end
            turret.RotVelocity = Vector3.zero
        end)
        pcall(function() turret.CFrame = cf end)
    end

    local function attackTurret(turret)
        local now = os.clock()
        if turretAttackBusy[turret] or turretAttackQueued[turret] or turretAttackActive or not shouldAttackTurret(turret) then return end
        if (turretAttackCD[turret] or 0) > now then return end
        turretAttackQueued[turret] = true
        turretAttackCD[turret] = now + RETRY_DELAY
        task.spawn(function()
            turretAttackQueued[turret] = nil
            if turretAttackActive or turretAttackBusy[turret] or not shouldAttackTurret(turret) then return end
            turretAttackActive = true
            turretAttackBusy[turret] = true
            pcall(function()
                local attempts = 0
                while attempts < 12 and autoTurretEnabled do
                    if not turret or not turret.Parent or not shouldAttackTurret(turret) then break end
                    local char = lp.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if not hrp or not hum or hum.Health <= 0 then break end
                    local okD, dist = pcall(function() return (turret.Position - hrp.Position).Magnitude end)
                    if okD and dist > 220 then break end
                    setTurretNoClip(turret)
                    bringTurretInFront(turret, hrp)
                    if not turret or not turret.Parent or not shouldAttackTurret(turret) then break end
                    local bp = lp:FindFirstChild("Backpack")
                    local bat = char:FindFirstChild("Bat") or (bp and bp:FindFirstChild("Bat"))
                    if bat and bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
                    bat = char:FindFirstChild("Bat") or bat
                    if bat then pcall(function() bat:Activate() end) end
                    task.wait(0.03)
                    if turret and turret.Parent and shouldAttackTurret(turret) then
                        setTurretNoClip(turret)
                        bringTurretInFront(turret, hrp)
                    end
                    attempts = attempts + 1
                    task.wait(0.09)
                end
            end)
            turretAttackBusy[turret] = nil
            turretAttackActive = false
        end)
    end

    local function disconnectAll()
        for _, c in ipairs(turretConns) do pcall(function() c:Disconnect() end) end
        turretConns = {}
    end

    local function startAutoTurret()
        disconnectAll()
        table.insert(turretConns, Workspace.DescendantAdded:Connect(function(obj)
            if isEnemyTurret(obj) then setTurretNoClip(obj) end
            if autoTurretEnabled and shouldAttackTurret(obj) then task.defer(attackTurret, obj) end
        end))
        if not turretLoopRunning then
            turretLoopRunning = true
            task.spawn(function()
                while autoTurretEnabled do
                    task.wait(0.4)
                    for _, obj in ipairs(Workspace:GetChildren()) do
                        if isEnemyTurret(obj) then setTurretNoClip(obj) end
                        if autoTurretEnabled and shouldAttackTurret(obj) then attackTurret(obj) end
                    end
                end
                turretLoopRunning = false
            end)
        end
    end

    local M = {}
    function M.set(state)
        autoTurretEnabled = state and true or false
        if autoTurretEnabled then startAutoTurret() else disconnectAll() end
    end
    function M.isOn() return autoTurretEnabled end
    return M
end)()

table.insert(ActiveConnections, function()
    if _G.AutoTurret and _G.AutoTurret.set then _G.AutoTurret.set(false) end
end)

-- ANTI GUMMY
_G.GummyBypass = (function()
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local Player = Players.LocalPlayer

    local M = { enabled = false }
    local antiGummyRespawnGraceUntil = 0
    local childAddedConn = nil
    local charAddedConn = nil
    local loopRunning = false

    local function clearGummyToolBlockState(char)
        if not char then return end
        pcall(function()
            for _, inst in ipairs({ Player, char }) do
                if inst then
                    if inst:GetAttribute("BlockTools") ~= nil then inst:SetAttribute("BlockTools", false) end
                    if inst:GetAttribute("Web") ~= nil then inst:SetAttribute("Web", false) end
                end
            end
            if char:GetAttribute("BackpackReady") == false then
                char:SetAttribute("BackpackReady", true)
            end
        end)
    end

    local function deleteGummyBears()
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj.Name == "GummyBear" then pcall(function() obj:Destroy() end) end
        end
    end

    local function stopLoops()
        loopRunning = false
        if childAddedConn then pcall(function() childAddedConn:Disconnect() end); childAddedConn = nil end
        if charAddedConn then pcall(function() charAddedConn:Disconnect() end); charAddedConn = nil end
    end

    local function startLoops()
        stopLoops()
        loopRunning = true
        charAddedConn = Player.CharacterAdded:Connect(function()
            task.wait(0.5)
            antiGummyRespawnGraceUntil = tick() + 1.5
        end)
        childAddedConn = Workspace.ChildAdded:Connect(function(child)
            if M.enabled and child.Name == "GummyBear" then pcall(function() child:Destroy() end) end
        end)
        task.spawn(function()
            while loopRunning and M.enabled do
                task.wait(0.1)
                if not M.enabled then break end
                local char = Player.Character
                if char and tick() >= antiGummyRespawnGraceUntil then clearGummyToolBlockState(char) end
            end
        end)
    end

    function M.set(on)
        on = on and true or false
        M.enabled = on
        if on then deleteGummyBears() startLoops() else stopLoops() end
    end
    function M.isEnabled() return M.enabled end

    table.insert(ActiveConnections, function() pcall(function() if M.set then M.set(false) end end) end)
    return M
end)()

-- ANTI AP / ANTI ADMIN
_G.AntiAdmin = (function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInput = game:GetService("UserInputService")
    local Player = Players.LocalPlayer
    local Camera = workspace.CurrentCamera

    local M = { enabled = false }
    local antiGummyRespawnGraceUntil = 0
    local originalScales = {}
    local originalHipHeight = nil
    local cameraLocked = false
    local lastValidCameraPosition = nil
    local lastValidCharacterPosition = nil
    local _ctrlCache = nil
    local _charController = nil
    local _jumpscareMod = nil
    local loopConn = nil
    local camLoopConn = nil
    local inputConn = nil
    local charAddedConn = nil
    local charAddedCtrlConn = nil

    local scaleNames = {
        "HeadScale", "BodyDepthScale", "BodyHeightScale",
        "BodyProportionScale", "BodyTypeScale", "BodyWidthScale",
    }

    local function captureOriginals()
        local char = Player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        originalHipHeight = hum.HipHeight
        originalScales = {}
        for _, name in ipairs(scaleNames) do
            local sv = hum:FindFirstChild(name)
            if sv then originalScales[name] = sv.Value end
        end
    end

    local function getControls()
        if _ctrlCache then return _ctrlCache end
        local ps = Player:FindFirstChild("PlayerScripts")
        local pm = ps and ps:FindFirstChild("PlayerModule")
        if not pm then return nil end
        local ok, mod = pcall(require, pm)
        if not ok or not mod then return nil end
        local ok2, c = pcall(function() return mod:GetControls() end)
        if ok2 and c then _ctrlCache = c end
        return _ctrlCache
    end

    local function tryRequireCharController()
        if _charController ~= nil then return _charController end
        local ok, mod = pcall(function()
            return require(game:GetService("ReplicatedStorage")
                :WaitForChild("Controllers", 2)
                :WaitForChild("CharacterController", 2))
        end)
        _charController = ok and mod or false
        return _charController
    end

    local function tryRequireJumpscare()
        if _jumpscareMod ~= nil then return _jumpscareMod end
        local ok, mod = pcall(function()
            return require(game:GetService("ReplicatedStorage")
                :WaitForChild("Datas", 2)
                :WaitForChild("AdminCommands", 2)
                :WaitForChild("jumpscare", 2))
        end)
        _jumpscareMod = ok and mod or false
        return _jumpscareMod
    end

    local function isFlightToolRelated(obj)
        if not obj then return false end
        local function nameLooksFlight(s)
            s = string.lower(tostring(s or ""))
            return s:find("carpet") or s:find("broom") or s:find("wing") or s:find("sleigh")
                or s:find("waverider") or s:find("hover") or s:find("jetpack") or s:find("cloud")
                or s:find("magic carpet") or s:find("fly")
        end
        if nameLooksFlight(obj.Name) then return true end
        local p = obj.Parent
        for _ = 1, 6 do
            if not p then break end
            if p:IsA("Tool") and nameLooksFlight(p.Name) then return true end
            if nameLooksFlight(p.Name) then return true end
            p = p.Parent
        end
        local char = Player and Player.Character
        if char then
            for _, t in ipairs(char:GetChildren()) do
                if t:IsA("Tool") and nameLooksFlight(t.Name) then return true end
            end
        end
        return false
    end

    local function isHubForce(obj)
        if not obj then return false end
        if isFlightToolRelated(obj) then return true end
        pcall(function()
            if Booster then
                if Booster._velocity and obj == Booster._velocity then return true end
                if Booster._attachment and (obj == Booster._attachment or obj.Parent == Booster._attachment) then return true end
            end
        end)
        if Booster and Booster._velocity and obj == Booster._velocity then return true end
        if Booster and Booster._attachment and (obj == Booster._attachment or obj.Parent == Booster._attachment) then return true end
        local n = string.lower(tostring(obj.Name or ""))
        if n:find("booster") or n:find("High") or n:find("gps") or n:find("giant") or n:find("carpet")
            or n:find("broom") or n:find("wing") or n:find("sleigh") or n:find("hover") then
            return true
        end
        local p = obj.Parent
        if p then
            local pn = string.lower(tostring(p.Name or ""))
            if pn:find("booster") or pn:find("High") or pn:find("gps") or pn:find("carpet")
                or pn:find("broom") or pn:find("wing") then
                return true
            end
        end
        return false
    end

    local function stripRocketForces(char)
        for _, obj in ipairs(char:GetDescendants()) do
            if (obj:IsA("BodyVelocity") or obj:IsA("BodyForce") or obj:IsA("BodyThrust")
                or obj:IsA("LinearVelocity") or obj:IsA("VectorForce")
                or obj:IsA("AlignPosition") or obj:IsA("Torque") or obj:IsA("AngularVelocity"))
                and not isHubForce(obj) then
                pcall(function() obj:Destroy() end)
            end
        end
    end

    local ROCKET_DURATION = 2.8
    local ROCKET_REARM_CD = 0.35
    local _rocketUntil = 0
    local _rocketRearmAfter = 0
    local _rocketNotified = false
    local _rocketWasActive = false

    local function isRocketWindowActive() return tick() < _rocketUntil end

    local function armRocketProtection(reason)
        local now = tick()
        if now < _rocketUntil then return end
        if now < _rocketRearmAfter then return end
        _rocketUntil = now + ROCKET_DURATION
        _rocketRearmAfter = _rocketUntil + ROCKET_REARM_CD
        if not _rocketNotified then
            _rocketNotified = true
            task.delay(ROCKET_DURATION + 0.05, function() _rocketNotified = false end)
        end
    end

    local function isInfiniteJumpOn()
        local ij = _G.InfiniteJump
        if not ij then return false end
        if type(ij.isEnabled) == "function" then
            local ok, on = pcall(ij.isEnabled)
            if ok and on then return true end
        end
        return ij.enabled and true or false
    end

    local function hasFlightToolEquipped(char)
        if not char then return false end
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") then
                local n = string.lower(t.Name or "")
                if n:find("carpet") or n:find("broom") or n:find("wing") or n:find("sleigh")
                    or n:find("waverider") or n:find("hover") or n:find("jetpack") or n:find("cloud") then
                    return true
                end
            end
        end
        return false
    end

    local function neutralizeRocket(char, hum, hrp)
        if hasFlightToolEquipped(char) then return end
        local now = tick()
        local upperTorso = char:FindFirstChild("UpperTorso")
        if not upperTorso then return end
        local v = upperTorso.AssemblyLinearVelocity
        local ijOn = isInfiniteJumpOn()

        if _rocketWasActive and now >= _rocketUntil then _rocketWasActive = false end

        if now >= _rocketUntil and now >= _rocketRearmAfter then
            local detected = false
            local yDetect = ijOn and 90 or 55
            if v.Y > yDetect then detected = true end
            if not detected then
                for _, obj in ipairs(char:GetDescendants()) do
                    if (obj:IsA("BodyVelocity") or obj:IsA("BodyForce") or obj:IsA("BodyThrust")
                        or obj:IsA("LinearVelocity") or obj:IsA("VectorForce")
                        or obj:IsA("AlignPosition")) and not isHubForce(obj) then
                        detected = true
                        break
                    end
                end
            end
            if detected then armRocketProtection("detect") end
        end

        if not isRocketWindowActive() then return end
        _rocketWasActive = true
        stripRocketForces(char)

        v = upperTorso.AssemblyLinearVelocity
        if ijOn then
            if v.Y > 90 then upperTorso.AssemblyLinearVelocity = Vector3.new(v.X, 55, v.Z) end
        elseif v.Y > 5 then
            upperTorso.AssemblyLinearVelocity = Vector3.new(v.X, 0, v.Z)
        end
        local av = hrp.AssemblyAngularVelocity
        if av.Magnitude > 20 then hrp.AssemblyAngularVelocity = Vector3.zero end

        pcall(function()
            hum.PlatformStand = false
            hum.Sit = false
            hum.AutoRotate = true
            local want = 16
            if hum.WalkSpeed < 8 then hum.WalkSpeed = math.max(want, 16) end
        end)
        local ctrl = getControls()
        if ctrl then pcall(function() ctrl:Enable() end) end
        if _G.AntiRagdoll == true then
            local state = hum:GetState()
            if state == Enum.HumanoidStateType.Physics
                or state == Enum.HumanoidStateType.Ragdoll
                or state == Enum.HumanoidStateType.FallingDown
                or state == Enum.HumanoidStateType.PlatformStanding then
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
            end
        end
    end

    local _rocketHooked = {}
    local function hookRocketOnChar(char)
        if not char or _rocketHooked[char] then return end
        _rocketHooked[char] = true
        char.DescendantAdded:Connect(function(obj)
            if not M.enabled then return end
            if (obj:IsA("BodyVelocity") or obj:IsA("BodyForce") or obj:IsA("BodyThrust")
                or obj:IsA("LinearVelocity") or obj:IsA("VectorForce")
                or obj:IsA("AlignPosition")) and not isHubForce(obj) then
                armRocketProtection("force")
                task.defer(function()
                    if M.enabled and isRocketWindowActive() then
                        pcall(function() obj:Destroy() end)
                    end
                end)
            end
        end)
        char.Destroying:Connect(function() _rocketHooked[char] = nil end)
    end

    local function protectTick()
        if not M.enabled then return end
        local char = Player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end

        Camera = workspace.CurrentCamera
        hookRocketOnChar(char)
        neutralizeRocket(char, hum, hrp)

        if _G.AntiRagdoll then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BallSocketConstraint") or v:IsA("HingeConstraint") then
                    pcall(function() v:Destroy() end)
                elseif v:IsA("Motor6D") then
                    v.Enabled = true
                end
            end
        end

        local ctrl = getControls()
        if ctrl then pcall(function() ctrl:Enable() end) end

        if _G.AntiRagdoll then
            local state = hum:GetState()
            if state ~= Enum.HumanoidStateType.Running
                and state ~= Enum.HumanoidStateType.Jumping
                and state ~= Enum.HumanoidStateType.Freefall
                and state ~= Enum.HumanoidStateType.Flying then
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
            end
        end

        if Camera and Camera.CameraSubject ~= hum then
            Camera.CameraSubject = hum
            cameraLocked = false
        end

        if _G.AntiRagdoll then
            local ragdollEnd = Player:GetAttribute("RagdollEndTime") or 0
            if ragdollEnd > 0 and ragdollEnd > workspace:GetServerTimeNow() then
                local upperTorso = char:FindFirstChild("UpperTorso")
                if upperTorso then upperTorso.AssemblyLinearVelocity = Vector3.zero end
                Player:SetAttribute("RagdollEndTime", 0)
            end
        end

        local cc = tryRequireCharController()
        if cc and ctrl then
            pcall(function()
                ctrl.moveFunction = function(p, x, z) cc:RequestMove(p, x, z) end
            end)
        end

        local jm = tryRequireJumpscare()
        if jm and type(jm) == "table" and jm.effects and jm.effects.Victim then
            jm.effects.Victim = function() end
        end

        if originalHipHeight and hum.HipHeight ~= originalHipHeight then
            hum.HipHeight = originalHipHeight
        end
        for _, name in ipairs(scaleNames) do
            local sv = hum:FindFirstChild(name)
            if sv and originalScales[name] and sv.Value ~= originalScales[name] then
                sv.Value = originalScales[name]
            end
        end

        for _, v in ipairs(char:GetChildren()) do
            if v:IsA("Model") and not v:IsA("BackpackItem")
                and not v.Name:find("Head") and not v.Name:find("Torso")
                and not v.Name:find("Arm") and not v.Name:find("Leg") then
                pcall(function() v:Destroy() end)
            end
        end

        if Camera and Camera.Parent == workspace then
            lastValidCameraPosition = Camera.CFrame
        end
    end

    local function camTick()
        if not M.enabled then return end
        local char = Player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        Camera = workspace.CurrentCamera
        if Camera and Camera.CameraSubject and Camera.CameraSubject ~= hum then
            Camera.CameraSubject = hum
        end
        if UserInput:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            cameraLocked = false
        end
    end

    local function stopLoops()
        if loopConn then pcall(function() task.cancel(loopConn) end); loopConn = nil end
        if camLoopConn then pcall(function() task.cancel(camLoopConn) end); camLoopConn = nil end
        if inputConn then pcall(function() inputConn:Disconnect() end); inputConn = nil end
        if charAddedConn then pcall(function() charAddedConn:Disconnect() end); charAddedConn = nil end
        if charAddedCtrlConn then pcall(function() charAddedCtrlConn:Disconnect() end); charAddedCtrlConn = nil end
    end

    local function startLoops()
        stopLoops()
        captureOriginals()
        charAddedConn = Player.CharacterAdded:Connect(function(char)
            local hum = char:WaitForChild("Humanoid", 5)
            if not hum then return end
            antiGummyRespawnGraceUntil = tick() + 1.5
            cameraLocked = false
            lastValidCameraPosition = nil
            lastValidCharacterPosition = nil
            task.wait(0.1)
            captureOriginals()
        end)
        charAddedCtrlConn = Player.CharacterAdded:Connect(function() _ctrlCache = nil end)
        loopConn = task.spawn(function()
            while M.enabled do pcall(protectTick) task.wait(0.05) end
        end)
        camLoopConn = task.spawn(function()
            while M.enabled do pcall(camTick) task.wait(0.05) end
        end)
        inputConn = UserInput.InputBegan:Connect(function(input, gameProcessed)
            if not M.enabled then return end
            if gameProcessed then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement then cameraLocked = false end
        end)
    end

    function M.set(on)
        on = on and true or false
        if M.enabled == on then return end
        M.enabled = on
        if on then startLoops() else stopLoops() end
    end
    function M.isEnabled() return M.enabled end
    return M
end)()

table.insert(ActiveConnections, function()
    if _G.AntiAdmin and _G.AntiAdmin.set then _G.AntiAdmin.set(false) end
end)

-- UTILITÁRIOS
local function FastConfirm()
    local res = GuiService:GetScreenResolution()
    local x = res.X * 0.5
    local y = res.Y * 0.58
    for i = 1, 10 do
        if thisScriptStopped then break end
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
        task.wait(0.01)
    end
end
local function getNearestPlayer()
    local hrp = Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local closest, dist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local d = (plr.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            if d < dist then dist = d closest = plr end
        end
    end
    return closest
end
local blockDelay = 0.05
local function PromptClick()
    task.wait(blockDelay)
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local centerX = viewportSize.X / 2
    local centerY = (viewportSize.Y / 2) + 30
    for _ = 1, 4 do
        VirtualInput:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
        VirtualInput:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
        task.wait(0.001)
    end
end
local function blockPlayer(plr)
    if not plr or plr == LocalPlayer then return end
    pcall(function()
        StarterGui:SetCore("PromptBlockPlayer", plr)
        PromptClick()
    end)
end
local function blockAllPlayers()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            blockPlayer(p)
            task.wait(1)
        end
    end
end

local charAddedConn = LocalPlayer.CharacterAdded:Connect(function(newChar)
    if currentMovement then pcall(function() currentMovement:Disconnect() end) currentMovement = nil end
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    Root = newChar:WaitForChild("HumanoidRootPart")
    UpperTorso = newChar:FindFirstChild("UpperTorso")
    Camera = Workspace.CurrentCamera
    autoStealEnabled = false isStealing = false
    task.wait()
    if Root then
        local oldVelocity = Root:FindFirstChild("LinearVelocity")
        if oldVelocity then oldVelocity:Destroy() end
        local oldAttachment = Root:FindFirstChild("Attachment")
        if oldAttachment then oldAttachment:Destroy() end
    end
end)
table.insert(ActiveConnections, charAddedConn)

local function stopWalkAnimations()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
        local animName = track.Animation and track.Animation.Name:lower() or ""
        if animName:find("walk") or animName:find("run") or animName:find("sprint") then
            pcall(function() track:Stop(0) end)
        end
    end
end

local function findTool(name)
    if not Character then return nil end
    for _, tool in ipairs(Character:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find(name:lower()) then return tool end
    end
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find(name:lower()) then return tool end
    end
    return nil
end

local function isMyPlot(plot)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yourBase = sign:FindFirstChild("YourBase")
        if yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled then return true end
    end
    return false
end

-- BYPASS PROTECT V1
local BypassProtectV1 = {
    enabled = false,
    activeThread = 0,
    blockTriggered = false,
    wasStealing = false,
    resetAnimationPlaying = false,
    currentCharacterId = 0,
    loop = nil,
    characterConnections = {},
}

local BYPASS_V1_RESET_ANIMATION_ID = "71186871415348"

local function bypassV1GetHRP()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("Torso")
end

local function bypassV1IsWithinBlockRadius()
    if BypassProtectV1.resetAnimationPlaying then return false end
    local hrp = bypassV1GetHRP()
    local plots = Workspace:FindFirstChild("Plots")
    if not hrp or not plots then return false end

    for _, plot in ipairs(plots:GetChildren()) do
        if not isMyPlot(plot) then
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                for _, pod in ipairs(pods:GetChildren()) do
                    local base = pod:FindFirstChild("Base")
                    local spawn = base and base:FindFirstChild("Spawn")
                    local radius = math.clamp(tonumber(_G.BypassV1BlockRadius) or 4, 1, 50)
                    if spawn and (spawn.Position - hrp.Position).Magnitude <= radius then
                        return true
                    end
                end
            end
        end
    end
    return false
end

local function bypassV1DrawClickDot(x, y)
    if not Drawing then return end
    local dot = Drawing.new("Circle")
    dot.Radius = 5
    dot.Position = Vector2.new(x, y)
    dot.Color = Color3.fromRGB(235, 50, 60)
    dot.Filled = true
    dot.Visible = true
    dot.Transparency = 0.6
    task.delay(0.25, function()
        pcall(function() dot:Remove() end)
    end)
end

local function bypassV1BlockPlayer(targetPlayer)
    if not targetPlayer or targetPlayer == LocalPlayer then return end

    pcall(function()
        StarterGui:SetCore("PromptBlockPlayer", targetPlayer)
    end)

    local cam = Workspace.CurrentCamera
    if not cam then return end
    local viewport = cam.ViewportSize
    local x = math.floor(viewport.X / 2) + math.random(-1, 1)
    local y = math.floor(viewport.Y / 2 + 50) + math.random(-1, 1)
    local char = LocalPlayer.Character
    local blockers = {}

    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                local blocked = true
                local conn = tool.Activated:Connect(function()
                    if blocked then return end
                end)
                table.insert(blockers, {
                    conn = conn,
                    release = function() blocked = false end,
                })
            end
        end
    end

    local blockDelay = math.clamp(tonumber(_G.BypassV1BlockDelay) or 0.04, 0, 4)
    task.wait(blockDelay)
    bypassV1DrawClickDot(x, y)
    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
    end)
    task.wait(0.008 + math.random() * 0.008)
    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
    end)

    task.delay(0.05, function()
        for _, blocker in ipairs(blockers) do
            blocker.release()
            pcall(function() blocker.conn:Disconnect() end)
        end
    end)
end

local function bypassV1DoBlock()
    local target = getNearestPlayer()
    if target then
        pcall(bypassV1BlockPlayer, target)
    end
end

local function bypassV1Reset()
    BypassProtectV1.activeThread += 1
    BypassProtectV1.blockTriggered = false
    BypassProtectV1.wasStealing = false
end

local function bypassV1HookCharacter(char)
    BypassProtectV1.currentCharacterId += 1
    local characterId = BypassProtectV1.currentCharacterId
    bypassV1Reset()

    local humanoid = char:WaitForChild("Humanoid", 5)
    if not humanoid then return end

    table.insert(BypassProtectV1.characterConnections, humanoid.Died:Connect(function()
        if characterId == BypassProtectV1.currentCharacterId then
            bypassV1Reset()
        end
    end))

    table.insert(BypassProtectV1.characterConnections, humanoid.AnimationPlayed:Connect(function(track)
        if characterId ~= BypassProtectV1.currentCharacterId then return end
        local animation = track.Animation
        if not animation or not tostring(animation.AnimationId):find(BYPASS_V1_RESET_ANIMATION_ID) then return end

        BypassProtectV1.resetAnimationPlaying = true
        bypassV1Reset()
        task.spawn(function()
            while characterId == BypassProtectV1.currentCharacterId and track.IsPlaying do
                task.wait()
            end
            if characterId == BypassProtectV1.currentCharacterId then
                BypassProtectV1.resetAnimationPlaying = false
            end
        end)
    end))
end

local function bypassV1Stop()
    BypassProtectV1.activeThread += 1
    BypassProtectV1.blockTriggered = false
    BypassProtectV1.wasStealing = false
    if BypassProtectV1.loop then
        pcall(function() task.cancel(BypassProtectV1.loop) end)
        BypassProtectV1.loop = nil
    end
end

local function bypassV1Start()
    bypassV1Stop()
    if not BypassProtectV1.enabled then return end
    BypassProtectV1.loop = task.spawn(function()
        while BypassProtectV1.enabled and not thisScriptStopped do
            local stealingNow = isStealing == true
            if stealingNow and not BypassProtectV1.wasStealing then
                BypassProtectV1.wasStealing = true
                BypassProtectV1.blockTriggered = false
                if _G.BypassV1GrabEnabled then
                    task.spawn(bypassV1DoBlock)
                end
            elseif not stealingNow then
                BypassProtectV1.wasStealing = false
                BypassProtectV1.blockTriggered = false
            elseif _G.BypassV1BlockEnabled
                and not BypassProtectV1.blockTriggered
                and bypassV1IsWithinBlockRadius() then
                BypassProtectV1.blockTriggered = true
                task.spawn(bypassV1DoBlock)
            end
            task.wait()
        end
        BypassProtectV1.loop = nil
    end)
end

function BypassProtectV1.set(enabled)
    BypassProtectV1.enabled = enabled == true
    _G.BypassProtectV1 = BypassProtectV1.enabled
    if BypassProtectV1.enabled then
        bypassV1Start()
    else
        bypassV1Stop()
    end
end

function BypassProtectV1.isEnabled()
    return BypassProtectV1.enabled
end

if LocalPlayer.Character then
    task.spawn(bypassV1HookCharacter, LocalPlayer.Character)
end
table.insert(ActiveConnections, LocalPlayer.CharacterAdded:Connect(function(char)
    BypassProtectV1.resetAnimationPlaying = false
    task.spawn(bypassV1HookCharacter, char)
end))
table.insert(ActiveConnections, {
    Disconnect = function()
        BypassProtectV1.enabled = false
        bypassV1Stop()
        for _, conn in ipairs(BypassProtectV1.characterConnections) do
            pcall(function() conn:Disconnect() end)
        end
        BypassProtectV1.characterConnections = {}
    end,
})
if _G.BypassProtectV1 then
    task.defer(function() BypassProtectV1.set(true) end)
end

-- EXTRA VISUALS / UI HELPERS
local hiddenAdminPanelRef
local hiddenAdminPanelParent

local function findAdminPanelTopbarItem()
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local topbar = playerGui and playerGui:FindFirstChild("TopbarStandard")
    local holders = topbar and topbar:FindFirstChild("Holders")
    local left = holders and holders:FindFirstChild("Left")
    if not left then return nil, nil end
    for _, child in ipairs(left:GetChildren()) do
        local childName = string.lower(child.Name or "")
        if childName:find("admin", 1, true) then return child, left end
    end
    local fallback = left:GetChildren()[4]
    return fallback, left
end

local function setHideAdminPanel(enabled)
    _G.HideAdminPanel = enabled == true
    task.spawn(function()
        for _ = 1, 20 do
            local ref, parent = findAdminPanelTopbarItem()
            if ref then
                if not hiddenAdminPanelRef then
                    hiddenAdminPanelRef = ref
                    hiddenAdminPanelParent = parent
                end
                break
            end
            task.wait(0.15)
        end
        local ref = hiddenAdminPanelRef
        local parent = hiddenAdminPanelParent
        if _G.HideAdminPanel then
            if ref and ref.Parent then pcall(function() ref.Parent = nil end) end
        elseif ref and parent and ref.Parent ~= parent then
            pcall(function() ref.Parent = parent end)
        end
    end)
end

-- MINE ESP
local mineESPData = {}
local mineESPConnections = {}
local mineESPFolderName = "ToolsAdds"

local function mineOwnerLabel(mineName)
    local username = mineName:match("SubspaceTripmine(.+)")
    if not username then return "Unknown" end
    local owner = Players:FindFirstChild(username)
    return owner and (owner.DisplayName .. " (@" .. username .. ")") or username
end

local function clearMineESPEntry(mine)
    local data = mineESPData[mine]
    if not data then return end
    if data.box and data.box.Parent then data.box:Destroy() end
    if data.label and data.label.Parent then data.label:Destroy() end
    mineESPData[mine] = nil
end

local function clearMineESP()
    for mine in pairs(mineESPData) do clearMineESPEntry(mine) end
end

local function addMineESP(mine)
    if not _G.MineESPEnabled or not mine or not mine:IsA("BasePart")
        or not mine.Name:match("^SubspaceTripmine") or mineESPData[mine] then
        return
    end
    local color = Color3.fromRGB(235, 50, 60)
    local box = Instance.new("SelectionBox")
    box.Name = "HighMineESPBox"
    box.Adornee = mine
    box.Color3 = color
    box.LineThickness = 0.06
    box.SurfaceTransparency = 1
    box.Parent = mine

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "HighMineESPLabel"
    billboard.Adornee = mine
    billboard.Size = UDim2.new(0, 220, 0, 34)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = mine

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = mineOwnerLabel(mine.Name) .. "'s Subspace Mine"
    label.TextColor3 = color
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Parent = billboard

    mineESPData[mine] = { box = box, label = billboard, text = label }
end

local function disconnectMineESP()
    for _, connection in ipairs(mineESPConnections) do
        pcall(function() connection:Disconnect() end)
    end
    mineESPConnections = {}
end

local function bindMineESPFolder(folder)
    table.insert(mineESPConnections, folder.ChildAdded:Connect(addMineESP))
    table.insert(mineESPConnections, folder.ChildRemoved:Connect(clearMineESPEntry))
    for _, child in ipairs(folder:GetChildren()) do addMineESP(child) end
end

local function setMineESP(enabled)
    _G.MineESPEnabled = enabled == true
    disconnectMineESP()
    clearMineESP()
    if not _G.MineESPEnabled then return end
    local folder = Workspace:FindFirstChild(mineESPFolderName)
    if folder then bindMineESPFolder(folder) end
    table.insert(mineESPConnections, Workspace.ChildAdded:Connect(function(child)
        if _G.MineESPEnabled and child.Name == mineESPFolderName then bindMineESPFolder(child) end
    end))
end

local function isValidStealPrompt(prompt)
    if not prompt or not prompt.Parent or not prompt.Enabled then return false end
    local state = prompt:GetAttribute("State")
    local actionText = prompt.ActionText
    if state == "Steal" or state == "Grab" or actionText == "Steal" or actionText == "Grab" then return true end
    return false
end

local function findFirstAvailableStealPrompt()
    local plotsFolder = Workspace:FindFirstChild("Plots")
    if not plotsFolder then return nil, nil end
    local candidates = {}
    for _, plot in ipairs(plotsFolder:GetChildren()) do
        if plot:IsA("Model") and not isMyPlot(plot) then
            local podiums = plot:FindFirstChild("AnimalPodiums")
            if podiums then
                for _, podium in ipairs(podiums:GetChildren()) do
                    local slotNumber = tonumber(podium.Name:match("%d+")) or 1
                    local base = podium:FindFirstChild("Base") or podium
                    local spawnPoint = base:FindFirstChild("Spawn")
                    local attachment = spawnPoint and spawnPoint:FindFirstChild("PromptAttachment")
                    if attachment then
                        for _, child in ipairs(attachment:GetChildren()) do
                            if child:IsA("ProximityPrompt") and isValidStealPrompt(child) then
                                table.insert(candidates, { prompt = child, slot = slotNumber })
                            end
                        end
                    end
                end
            end
        end
    end
    table.sort(candidates, function(a, b) return a.slot < b.slot end)
    local first = candidates[1]
    return first and first.prompt or nil, first and first.slot or nil
end

local function firePromptConnections(prompt, signalName)
    if not getconnections then return end
    local connections = getconnections(prompt[signalName])
    for _, conn in ipairs(connections) do
        if conn.Function then task.spawn(conn.Function) end
    end
end

local function executeSteal(prompt)
    if isStealing or not prompt or not prompt.Parent then return end
    isStealing = true
    firePromptConnections(prompt, "PromptButtonHoldBegan")
    task.wait(stealDelay)
    if prompt and prompt.Parent and prompt.Enabled and not thisScriptStopped then
        firePromptConnections(prompt, "Triggered")
    end
    isStealing = false
end

local STOP_DIST = 5
local SLOW_DIST = 20

local _resetWasByBalloon = false
local balloonConnection
balloonConnection = LocalPlayer:GetAttributeChangedSignal("Balloon"):Connect(function()
    if thisScriptStopped then pcall(function() balloonConnection:Disconnect() end) return end
    if _G.AutoResetOnBalloon == true and LocalPlayer:GetAttribute("Balloon") == true then
        _resetWasByBalloon = true
        task.spawn(function() ResetPlayer() end)
    end
end)
table.insert(ActiveConnections, balloonConnection)

for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
    if obj:IsA("RemoteEvent") then
        local conn = obj.OnClientEvent:Connect(function(...)
            if not _G.AutoResetOnBalloon then return end
            for _, arg in ipairs({...}) do
                if type(arg) == "string" and arg:lower():find("jump higher") then
                    task.spawn(function() ResetPlayer() end)
                end
            end
        end)
        table.insert(ActiveConnections, conn)
    end
end

local PREBLOCK_DIST_BY_SLOT = {
    [1] = 1.6, [2] = 1.6, [3] = 1.6, [4] = 1.6, [5] = 1.6,
    [6] = 1.6, [7] = 1.6, [8] = 1.6, [9] = 1.6,
    [11] = 7.8, [12] = 7.8, [13] = 7.8, [14] = 7.8, [15] = 7.8, [16] = 7.8,
    [19] = 7.8, [20] = 7.8, [21] = 7.8, [22] = 7.8, [23] = 7.8,
    [24] = 6.6, [25] = 6.6, [26] = 6.6, [27] = 6.6,
}


local function _getAdminCmdTextBox()
    local ok, tb = pcall(function()
        return LocalPlayer.PlayerGui
            .AdminPanel.AdminPanel.CommandBox.TextBox
    end)
    return ok and tb or nil
end

local function _fireRagdollCmd()
    local TextBox = _getAdminCmdTextBox()
    if not TextBox then return end
    local fullCmd = ";ragdoll " .. LocalPlayer.Name
    local vis = TextBox.Visible
    TextBox.Visible = false
    TextBox.Text    = fullCmd
    task.wait(0.05)

    local executed = false
    if firesignal then
        pcall(function() firesignal(TextBox.FocusLost, true); executed = true end)
    end
    if not executed and getconnections then
        pcall(function()
            for _, conn in pairs(getconnections(TextBox.FocusLost)) do
                conn:Fire(true)
            end
            executed = true
        end)
    end
    task.wait(0.05)
    TextBox.Text    = ""
    TextBox.Visible = vis
end

local function _hookGiantPotion(tool)
    if not tool or not tool:IsA("Tool") then return end
    if tool.Name ~= "Giant Potion" then return end
    if tool:GetAttribute("_HighRagdollHooked") then return end
    tool:SetAttribute("_HighRagdollHooked", true)
    tool.Activated:Connect(function()
        if not _G.RagdollBypass then return end
        if not autoStealEnabled then return end
        task.spawn(_fireRagdollCmd)
    end)
end

local function _hookCharForGiant(char)
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do _hookGiantPotion(child) end
    char.ChildAdded:Connect(function(child) _hookGiantPotion(child) end)
end

local function _hookBackpackForGiant(bp)
    if not bp then return end
    for _, child in ipairs(bp:GetChildren()) do _hookGiantPotion(child) end
    bp.ChildAdded:Connect(function(child) _hookGiantPotion(child) end)
end

task.spawn(function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    _hookCharForGiant(char)
    local bp = LocalPlayer:WaitForChild("Backpack", 10)
    if bp then _hookBackpackForGiant(bp) end
end)

table.insert(ActiveConnections, LocalPlayer.CharacterAdded:Connect(function(newChar)
    task.wait(0.3)
    _hookCharForGiant(newChar)
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    if bp then _hookBackpackForGiant(bp) end
end))

-- START TRIP (com TP V2: jump + trigger space maior)
local function startTripToPetSlot(prompt, slotNumber)
    local config = SlotsConfig[slotNumber] or SlotsConfig[1]
    local targetPositions = config.Positions
    local needJump = config.NeedJump == true
    if slotNumber >= 19 and slotNumber <= 27 then needJump = true end
    local rootNow = Root and Root.Position
    if rootNow and isInFlashSafeZone(rootNow) then
        local positions = { FLASH_SAFE_POS }
        for _, p in ipairs(targetPositions) do table.insert(positions, p) end
        targetPositions = positions
    end
    if currentMovement then pcall(function() currentMovement:Disconnect() end) currentMovement = nil end
    if not Root or not Humanoid then return end
    autoStealEnabled = true
    startFlashLagger()

    if _G.AutoReturnBase then
        task.spawn(function()
            local deadline = tick() + 12
            while tick() < deadline and not thisScriptStopped do
                local stealing = false
                pcall(function()
                    stealing = LocalPlayer:GetAttribute("Stealing") == true
                        or LocalPlayer:GetAttribute("IsStealing") == true
                        or LocalPlayer:GetAttribute("StealingPlayer") == true
                end)
                if stealing then
                    local onOwn = false
                    pcall(function()
                        local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if not r then return end
                        local plots = Workspace:FindFirstChild("Plots")
                        if plots then
                            for _, plot in ipairs(plots:GetChildren()) do
                                local sign = plot:FindFirstChild("PlotSign")
                                local yb = sign and sign:FindFirstChild("YourBase")
                                if yb and yb:IsA("BillboardGui") and yb.Enabled then
                                    local ok, piv = pcall(function() return plot:GetPivot().Position end)
                                    if ok and piv and (r.Position - piv).Magnitude < 90 then
                                        onOwn = true
                                    end
                                end
                            end
                        end
                    end)
                    if not onOwn then
                        if currentMovement then
                            pcall(function() currentMovement:Disconnect() end)
                            currentMovement = nil
                        end
                        autoStealEnabled = false
                        if _G._HighStartReturnBase then pcall(_G._HighStartReturnBase) end
                        return
                    end
                end
                task.wait(0.05)
            end
        end)
    end

    -- 🆕 TP V2: dá 1 pulo antes de ir para evitar erro de colisão no chão
    if _G.TPV2 and Root and Root.Parent and Humanoid and Humanoid.Health > 0 then
        pcall(function()
            Humanoid.Jump = true
        end)
        pcall(function()
            if UpperTorso then
                UpperTorso.AssemblyLinearVelocity = Vector3.new(
                    UpperTorso.AssemblyLinearVelocity.X, 60, UpperTorso.AssemblyLinearVelocity.Z
                )
            end
        end)
        task.wait(0.09)
    end

    local Speed = getFlashSpeed()
    -- 🆕 TP V2: trigger ampliado até 500; sem TP V2 permanece em 70
    local grabStartDistance = _G.TPV2 and 500 or 70
    local grabStarted = false
    -- TP V2: usa o grapple uma vez antes de equipar o carpet para estabilizar o deslocamento.
    if _G.TPV2 then
        local grapple = findTool("grapple") or findTool("grappling")
        if grapple then
            pcall(function()
                Humanoid:EquipTool(grapple)
                task.wait(0.04)
                grapple:Activate()
            end)
            task.wait(0.08)
            pcall(function() Humanoid:UnequipTools() end)
            task.wait(0.03)
        end
    end
    local carpet = findTool(_G.WalkItem or "Flying Carpet")
    if carpet then Humanoid:UnequipTools() task.wait(0.03) Humanoid:EquipTool(carpet) end
    stopWalkAnimations()
    if Root:FindFirstChild("LinearVelocity") then Root.LinearVelocity:Destroy() end
    if Root:FindFirstChild("Attachment") then Root.Attachment:Destroy() end
    local Attachment = Instance.new("Attachment")
    Attachment.Parent = Root
    local Velocity = Instance.new("LinearVelocity")
    Velocity.Attachment0 = Attachment
    Velocity.RelativeTo = Enum.ActuatorRelativeTo.World
    Velocity.MaxForce = math.huge
    Velocity.Parent = Root
    local currentPosIndex = 1
    local intermediatePauseActive = false
    local earlyBlockDone = false
    local savedWalkSpeed = Humanoid.WalkSpeed
    local savedJumpPower = Humanoid.JumpPower
    Humanoid.WalkSpeed = 0
    Humanoid.JumpPower = 0
    local animator = Humanoid:FindFirstChildOfClass("Animator")
    local animConn
    if animator then
        animConn = animator.AnimationPlayed:Connect(function(track)
            local animName = track.Animation and track.Animation.Name:lower() or ""
            if animName:find("walk") or animName:find("run") or animName:find("sprint") then
                pcall(function() track:Stop(0) end)
            end
        end)
    end
    currentMovement = RunService.Heartbeat:Connect(function()
        if thisScriptStopped then
            if currentMovement then pcall(function() currentMovement:Disconnect() end) currentMovement = nil end
            Humanoid.WalkSpeed = savedWalkSpeed Humanoid.JumpPower = savedJumpPower
            if animConn then pcall(function() animConn:Disconnect() end) end
            return
        end
        if not Root or not Humanoid or not Root.Parent or Humanoid.Health <= 0 then
            if currentMovement then pcall(function() currentMovement:Disconnect() end) currentMovement = nil end
            Humanoid.WalkSpeed = savedWalkSpeed Humanoid.JumpPower = savedJumpPower
            if animConn then pcall(function() animConn:Disconnect() end) end
            return
        end
        if intermediatePauseActive then Velocity.VectorVelocity = Vector3.zero return end
        local TargetPosition = targetPositions[currentPosIndex]
        if not TargetPosition then return end
        local rootPos = Root.Position
        local dir = Vector3.new(TargetPosition.X - rootPos.X, 0, TargetPosition.Z - rootPos.Z)
        local dist = dir.Magnitude
        if currentPosIndex == 1 and dist <= grabStartDistance and not grabStarted then
            grabStarted = true
            task.spawn(function() executeSteal(prompt) end)
        end
        local speedMult = 1
        if dist < SLOW_DIST then speedMult = math.max(0.15, dist / SLOW_DIST) end
        if dist <= STOP_DIST then
            if currentPosIndex < #targetPositions then
                intermediatePauseActive = true
                Velocity.VectorVelocity = Vector3.zero
                if UpperTorso then UpperTorso.AssemblyLinearVelocity = Vector3.zero end
                task.spawn(function()
                    currentPosIndex = currentPosIndex + 1
                    intermediatePauseActive = false
                end)
                return
            end
            Velocity.VectorVelocity = Vector3.zero
            if UpperTorso then UpperTorso.AssemblyLinearVelocity = Vector3.zero end
            Velocity:Destroy()
            Attachment:Destroy()
            Root.CFrame = CFrame.new(TargetPosition)
            if currentMovement then pcall(function() currentMovement:Disconnect() end) currentMovement = nil end
            if _G.AutoBlock and _G.BlockMode == "veryfast" and not earlyBlockDone then
                earlyBlockDone = true
                local blockDelay
                if slotNumber >= 19 and slotNumber <= 23 then
                    blockDelay = 0.065
                elseif slotNumber >= 11 and slotNumber <= 15 then
                    blockDelay = 0.14
                else
                    blockDelay = 0.2
                end
                task.spawn(function()
                    task.wait(blockDelay)
                    local target = getNearestPlayer()
                    if target then blockPlayer(target) end
                end)
            end
            task.wait(0.12)
            Camera.CameraType = Enum.CameraType.Scriptable
            if config.FixedCFrame then
                Camera.CFrame = config.FixedCFrame
            else
                Camera.CFrame = CFrame.new(Root.Position + config.CamOffset) * CFrame.Angles(unpack(config.CamAngles))
            end
            Humanoid:UnequipTools()
            task.wait(0.06)
            if needJump then
                if UpperTorso then UpperTorso.AssemblyLinearVelocity = Vector3.new(0, 55, 0) end
                task.wait(0.08)
            end
            local flash = findTool("flash")
            if flash then
                if _G.AutoBlock and _G.BlockMode == "veryfast" and not earlyBlockDone then
                    earlyBlockDone = true
                    task.spawn(function()
                        local target = getNearestPlayer()
                        if target then blockPlayer(target) end
                    end)
                end
                Humanoid:EquipTool(flash)
                task.wait(0.08)
                flash:Activate()
                if slotNumber == 6 then
                    pcall(function()
                        workspace.CurrentCamera.CFrame = CFrame.new(
                            -299.38,-3.06,29.14,
                            0.914,-0.035,0.405,
                            0,0.996,0.086,
                            -0.407,-0.078,0.910
                        )
                    end)
                end
            end
            task.wait(0.1)
            if _G.RagdollBypass then
                local giant = findTool("giant potion")
                if giant then
                    Humanoid:EquipTool(giant)
                    task.wait(0.08)
                    giant:Activate()
                    task.wait(0.02)
                    Humanoid:UnequipTools()
                end
            end
            Camera.CameraType = Enum.CameraType.Custom
            if _G.AutoBlock then
                local mode = _G.BlockMode or "normal"
                if mode ~= "veryfast" then
                    task.spawn(function()
                        if mode == "normal" then task.wait(0.13)
                        elseif mode == "fast" then task.wait(0.08) end
                        local target = getNearestPlayer()
                        if target then blockPlayer(target) end
                    end)
                end
            end
            Humanoid.WalkSpeed = savedWalkSpeed
            Humanoid.JumpPower = savedJumpPower
            if animConn then pcall(function() animConn:Disconnect() end) end
            task.spawn(function() task.wait(1.0) autoStealEnabled = false end)
            return
        end
        Velocity.VectorVelocity = Vector3.new(dir.Unit.X * Speed * speedMult, 0, dir.Unit.Z * Speed * speedMult)
    end)
    table.insert(ActiveConnections, currentMovement)
end

local scrollListRef = nil

-- UPDATE PET LIST
local function updatePetList()
    if isStealing or autoStealEnabled or thisScriptStopped then return end
    if not scrollListRef then return end
    for _, child in ipairs(scrollListRef:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    local plotsFolder = Workspace:FindFirstChild("Plots")
    if not plotsFolder then return end
    local tempPets = {}
    for _, plot in ipairs(plotsFolder:GetChildren()) do
        if not isMyPlot(plot) then
            local podiums = plot:FindFirstChild("AnimalPodiums")
            if podiums then
                for _, podium in ipairs(podiums:GetChildren()) do
                    local slotNumber = tonumber(podium.Name:match("%d+")) or 1
                    local base = podium:FindFirstChild("Base") or podium
                    local spawnPoint = base:FindFirstChild("Spawn")
                    local attachment = spawnPoint and spawnPoint:FindFirstChild("PromptAttachment")
                    if attachment then
                        for _, child in ipairs(attachment:GetChildren()) do
                            if child:IsA("ProximityPrompt") and isValidStealPrompt(child) then
                                local petName = child.ObjectText or "Pet"
                                table.insert(tempPets, { prompt = child, slot = slotNumber, name = petName })
                            end
                        end
                    end
                end
            end
        end
    end
    table.sort(tempPets, function(a, b) return a.slot < b.slot end)
    local C_list = {
        card = Color3.fromRGB(46, 24, 28),
        accent = Color3.fromRGB(235, 50, 60),
        stroke = Color3.fromRGB(150, 20, 30),
        bright = Color3.fromRGB(235, 235, 240),
        mute = Color3.fromRGB(190, 130, 135),
    }
    for index, petData in ipairs(tempPets) do
        if thisScriptStopped then break end
        local isSelected = (selectedPrompt == petData.prompt)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -8, 0, 40)
        row.BackgroundColor3 = isSelected and Color3.fromRGB(40, 20, 35) or C_list.card
        row.BorderSizePixel = 0
        row.LayoutOrder = index
        row.Parent = scrollListRef
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 12)
        local rStroke = Instance.new("UIStroke")
        rStroke.Color = isSelected and C_list.accent or C_list.stroke
        rStroke.Thickness = isSelected and 1.5 or 1
        rStroke.Parent = row
        local VP_SIZE = 60
        row.Size = UDim2.new(1, -8, 0, 66)
        local vp = Instance.new("ViewportFrame")
        vp.Size = UDim2.new(0, VP_SIZE, 0, VP_SIZE)
        vp.Position = UDim2.new(0, 3, 0.5, -VP_SIZE / 2)
        vp.BackgroundTransparency = 1
        vp.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        vp.BorderSizePixel = 0
        vp.ZIndex = 5
        vp.Parent = row
        local vpCam = Instance.new("Camera")
        vpCam.Parent = vp
        vp.CurrentCamera = vpCam
        task.spawn(function()
            local plotsFolder = Workspace:FindFirstChild("Plots")
            if not plotsFolder then return end
            local playerNames = {}
            for _, p in pairs(Players:GetPlayers()) do playerNames[p.Name] = true end
            local foundModel = nil
            for _, v in ipairs(plotsFolder:GetDescendants()) do
                if v:IsA("Model") and v.Name == petData.name and not playerNames[v.Name] then
                    foundModel = v
                    break
                end
            end
            if not foundModel then return end
            local clone = foundModel:Clone()
            for _, d in ipairs(clone:GetDescendants()) do
                if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("Highlight") then d:Destroy() end
            end
            clone.Parent = vp
            local cf, size = clone:GetBoundingBox()
            local dist = math.max(size.Magnitude * 1.2, 2)
            local center = cf.Position
            local height = size.Y * 0.2
            local angle = 0
            local rotConn
            rotConn = RunService.Heartbeat:Connect(function(dt)
                if not vp.Parent then rotConn:Disconnect() return end
                angle = angle + dt * 60
                local rad = math.rad(angle)
                vpCam.CFrame = CFrame.new(
                    center + Vector3.new(math.sin(rad) * dist, height, math.cos(rad) * dist),
                    center
                )
            end)
            table.insert(ActiveConnections, rotConn)
        end)
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Text = petData.name
        nameLabel.Size = UDim2.new(1, -(VP_SIZE + 18), 1, 0)
        nameLabel.Position = UDim2.new(0, VP_SIZE + 10, 0, -4)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Color3.fromRGB(235, 235, 240)
        nameLabel.Font = Enum.Font.GothamMedium
        nameLabel.TextSize = 13
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = row
        local nameGrad = Instance.new("UIGradient")
        nameGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(235, 235, 240)),
            ColorSequenceKeypoint.new(.5, Color3.fromRGB(255, 130, 140)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 235, 240))
        })
        nameGrad.Parent = nameLabel
        local slotLabel = Instance.new("TextLabel")
        slotLabel.Text = "slot " .. petData.slot
        slotLabel.Size = UDim2.new(1, -(VP_SIZE + 14), 1, 0)
        slotLabel.Position = UDim2.new(0, VP_SIZE + 2, 0, 6)
        slotLabel.BackgroundTransparency = 1
        slotLabel.TextColor3 = C_list.mute
        slotLabel.Font = Enum.Font.GothamMedium
        slotLabel.TextSize = 11
        slotLabel.TextXAlignment = Enum.TextXAlignment.Right
        slotLabel.Parent = row
        local clickBtn = Instance.new("TextButton")
        clickBtn.Size = UDim2.new(1, 0, 1, 0)
        clickBtn.BackgroundTransparency = 1
        clickBtn.Text = ""
        clickBtn.BorderSizePixel = 0
        clickBtn.Parent = row
        local rowBtnConn = clickBtn.MouseButton1Click:Connect(function()
            if not isStealing and not autoStealEnabled then
                selectedPrompt = petData.prompt
                selectedSlotNumber = petData.slot
                updatePetList()
            end
        end)
        table.insert(ActiveConnections, rowBtnConn)
    end
end

-- ESP TIMER
local baseEspInstances = {}
local function createBaseESP(plot, mainPart)
    if baseEspInstances[plot.Name] then baseEspInstances[plot.Name]:Destroy() end
    local bb = Instance.new("BillboardGui")
    bb.Name = "67_Timer"
    bb.Size = UDim2.new(0, 50, 0, 20)
    bb.StudsOffset = Vector3.new(0, 4, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = mainPart
    bb.MaxDistance = 1000
    bb.Parent = plot
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBold
    lbl.TextColor3 = Color3.fromRGB(235, 50, 60)
    lbl.TextStrokeTransparency = 0
    lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
    lbl.Parent = bb
    baseEspInstances[plot.Name] = bb
    return bb
end
local function clearBaseESP()
    for k, v in pairs(baseEspInstances) do v:Destroy() baseEspInstances[k] = nil end
end
local function toSecondsOnlyESP(text)
    if typeof(text) ~= "string" then return text end
    local m, s = text:match("(%d+):(%d+)")
    if m and s then
        local total = tonumber(m) * 60 + tonumber(s)
        return tostring(total)
    end
    local n = text:match("(%d+)")
    if n then return n end
    return text
end
local function updateBaseESP()
    if not _G.EspTimer then
        if next(baseEspInstances) then clearBaseESP() end
        return
    end
    local plotsFolder = Workspace:FindFirstChild("Plots")
    if not plotsFolder then return end
    for _, plot in ipairs(plotsFolder:GetChildren()) do
        local purchases = plot:FindFirstChild("Purchases")
        local plotBlock = purchases and purchases:FindFirstChild("PlotBlock")
        local mainPart = plotBlock and plotBlock:FindFirstChild("Main")
        local bb = baseEspInstances[plot.Name]
        local timeLabel = mainPart and mainPart:FindFirstChild("BillboardGui") and mainPart.BillboardGui:FindFirstChild("RemainingTime")
        if timeLabel and mainPart then
            bb = bb or createBaseESP(plot, mainPart)
            local lbl = bb:FindFirstChildWhichIsA("TextLabel")
            local converted = toSecondsOnlyESP(timeLabel.Text)
            if lbl then lbl.Text = converted end
        elseif bb then
            bb:Destroy() baseEspInstances[plot.Name] = nil
        end
    end
end
task.spawn(function()
    while true do
        pcall(updateBaseESP)
        task.wait(0.4)
    end
end)

local apEspInstances = {}
local function clearAPESP()
    for uid, bb in pairs(apEspInstances) do
        pcall(function() bb:Destroy() end)
        apEspInstances[uid] = nil
    end
end
local function updateAPESP()
    if not _G.BackpackESP or not _G.ShowAPESP then
        if next(apEspInstances) then clearAPESP() end
        return
    end
    local activePlayers = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        local char = p.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        activePlayers[p.UserId] = true
        local hasAP = pcall(function() return p:GetAttribute("AdminCommands") ~= nil end) and p:GetAttribute("AdminCommands") ~= nil
        if not hasAP then
            if apEspInstances[p.UserId] then
                pcall(function() apEspInstances[p.UserId]:Destroy() end)
                apEspInstances[p.UserId] = nil
            end
            continue
        end
        if not apEspInstances[p.UserId] then
            local bb = Instance.new("BillboardGui")
            bb.Name = "67_AP_ESP"
            bb.Size = UDim2.new(0, 52, 0, 52)
            bb.StudsOffset = Vector3.new(3.5, 7, 0)
            bb.AlwaysOnTop = true
            bb.Adornee = hrp
            bb.MaxDistance = 200
            bb.Parent = char
            local img = Instance.new("ImageLabel")
            img.Size = UDim2.new(1, 0, 1, 0)
            img.BackgroundTransparency = 1
            img.Image = "rbxassetid://95529031547606"
            img.ScaleType = Enum.ScaleType.Fit
            img.Parent = bb
            apEspInstances[p.UserId] = bb
        else
            apEspInstances[p.UserId].Adornee = hrp
        end
    end
    for uid, bb in pairs(apEspInstances) do
        if not activePlayers[uid] then
            pcall(function() bb:Destroy() end)
            apEspInstances[uid] = nil
        end
    end
end
task.spawn(function()
    while true do
        pcall(updateAPESP)
        task.wait(0.5)
    end
end)

local backpackEspInstances = {}
local function clearBackpackESP()
    for uid, bb in pairs(backpackEspInstances) do
        pcall(function() bb:Destroy() end)
        backpackEspInstances[uid] = nil
    end
end
local function buildBackpackBillboard(char, hrp, found)
    local count = #found
    local ICON = 48
    local GAP = 4
    local bb = Instance.new("BillboardGui")
    bb.Name = "67_BP_ESP"
    bb.Size = UDim2.new(0, ICON, 0, ICON * count + GAP * (count - 1))
    bb.StudsOffset = Vector3.new(3.5, 0, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = hrp
    bb.MaxDistance = 200
    bb.Parent = char
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Padding = UDim.new(0, GAP)
    layout.Parent = bb
    for _, data in ipairs(found) do
        local img = Instance.new("ImageLabel")
        img.Size = UDim2.new(0, ICON, 0, ICON)
        img.BackgroundTransparency = 1
        img.Image = data.texture ~= "" and data.texture or "rbxassetid://0"
        img.ScaleType = Enum.ScaleType.Fit
        img.Parent = bb
    end
    return bb
end
local function updateBackpackESP()
    if not _G.BackpackESP then
        if next(backpackEspInstances) then clearBackpackESP() end
        return
    end
    local activePlayers = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        local char = p.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        activePlayers[p.UserId] = true
        local bp = p:FindFirstChild("Backpack")
        local found = {}
        if bp then
            for _, tool in ipairs(bp:GetChildren()) do
                if tool:IsA("Tool") then
                    if tool.Name == "Giant Potion" and _G.ShowGiantPotion then
                        table.insert(found, { name = tool.Name, texture = tool.TextureId or "" })
                    elseif tool.Name == "Flash Teleport" and _G.ShowFlashTeleport then
                        table.insert(found, { name = tool.Name, texture = tool.TextureId or "" })
                    elseif tool.Name == "Flying Carpet" and _G.ShowFlyingCarpet then
                        table.insert(found, { name = tool.Name, texture = tool.TextureId or "" })
                    end
                end
            end
        end
        if #found == 0 then
            if backpackEspInstances[p.UserId] then
                pcall(function() backpackEspInstances[p.UserId]:Destroy() end)
                backpackEspInstances[p.UserId] = nil
            end
            continue
        end
        local existing = backpackEspInstances[p.UserId]
        local needRebuild = not existing or existing.Parent == nil or existing.Adornee ~= hrp
        if not needRebuild then
            local slots = 0
            for _, c in ipairs(existing:GetChildren()) do
                if c:IsA("Frame") then slots += 1 end
            end
            if slots ~= #found then needRebuild = true end
        end
        if needRebuild then
            if existing then pcall(function() existing:Destroy() end) end
            backpackEspInstances[p.UserId] = buildBackpackBillboard(char, hrp, found)
        end
    end
    for uid, bb in pairs(backpackEspInstances) do
        if not activePlayers[uid] then
            pcall(function() bb:Destroy() end)
            backpackEspInstances[uid] = nil
        end
    end
end
task.spawn(function()
    while true do
        pcall(updateBackpackESP)
        task.wait(0.5)
    end
end)
-- BUILD HUB
local function BuildHUB()
    local function destroyOldGui(name)
        for _, parent in ipairs({HIDDEN_GUI}) do
            if parent then
                local old = parent:FindFirstChild(name)
                if old then old:Destroy() end
            end
        end
    end
        destroyOldGui("HIGH")
        destroyOldGui("ReezHub")
        destroyOldGui("67")
        destroyOldGui("ResetUI")

    local C = {
        -- Vermelho Reez aplicado à paleta principal da GUI.
        accent = Color3.fromRGB(235, 50, 60),
        accentHi = Color3.fromRGB(255, 130, 140),
        deepPurple = Color3.fromRGB(60, 8, 15),
        body = Color3.fromRGB(18, 8, 10),
        panel = Color3.fromRGB(30, 12, 16),
        card = Color3.fromRGB(48, 18, 24),
        iconBg = Color3.fromRGB(65, 22, 30),
        stroke = Color3.fromRGB(235, 50, 60),
        strokeDim = Color3.fromRGB(150, 20, 30),
        textBright = Color3.fromRGB(255, 240, 242),
        textMauve = Color3.fromRGB(255, 130, 140),
        textMute = Color3.fromRGB(210, 150, 155),
        textDim = Color3.fromRGB(170, 95, 105),
        knobOn = Color3.fromRGB(255, 180, 185),
        knobOff = Color3.fromRGB(100, 55, 65),
        trackOff = Color3.fromRGB(40, 16, 22),
    }

    local function getDevice()
        local isMobil = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
        if isMobil then
            local s = workspace.CurrentCamera.ViewportSize
            if s.X >= 900 or s.Y >= 900 then return "ipad" end
            return "mobile"
        end
        return "pc"
    end
    local DEVICE = getDevice()
    local isMob = DEVICE ~= "pc"

    local HIGH_HUB_GUI = Instance.new("ScreenGui")
    HIGH_HUB_GUI.Name = "67"
    HIGH_HUB_GUI.ResetOnSpawn = false
    HIGH_HUB_GUI.DisplayOrder = 999
    HIGH_HUB_GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    HIGH_HUB_GUI.IgnoreGuiInset = false
    protectGui(HIGH_HUB_GUI)
    HIGH_HUB_GUI.Parent = getGuiParent()
    table.insert(ActiveConnections, HIGH_HUB_GUI.AncestryChanged:Connect(function()
        if thisScriptStopped or HIGH_HUB_GUI.Parent ~= nil then return end
        task.defer(function()
            if thisScriptStopped or not HIGH_HUB_GUI or not HIGH_HUB_GUI.Parent then
                if not thisScriptStopped and HIGH_HUB_GUI then
                    protectGui(HIGH_HUB_GUI)
                    HIGH_HUB_GUI.Parent = getGuiParent()
                end
            end
        end)
    end))

    local guiLocked = false
    local lockBtn = Instance.new("TextButton")
    lockBtn.Name = "LockButton"
    lockBtn.Size = UDim2.new(0, 32, 0, 32)
    lockBtn.Position = UDim2.new(0, 8, 0, 8)
    lockBtn.BackgroundColor3 = C.card
    lockBtn.BackgroundTransparency = 1
    lockBtn.BorderSizePixel = 0
    lockBtn.ZIndex = 50
    lockBtn.Text = "🔓"
    lockBtn.TextColor3 = C.textBright
    lockBtn.TextSize = 18
    lockBtn.Font = Enum.Font.GothamBold
    lockBtn.AutoButtonColor = false
    lockBtn.Parent = HIGH_HUB_GUI
    Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(0, 8)
    -- Somente o emoji fica visível; o fundo e a borda são removidos.

    local function updateLockState(locked)
        guiLocked = locked
        _G.ReezHubUILocked = locked
        lockBtn.Text = locked and "🔒" or "🔓"
        lockBtn.TextColor3 = locked and Color3.fromRGB(255, 200, 100) or C.textBright
        for _, child in ipairs(HIGH_HUB_GUI:GetChildren()) do
            if child:IsA("Frame") and child.Name ~= "67" then
                if locked then
                    child.Active = false
                    child.Selectable = false
                    local header = child:FindFirstChild("Header")
                    if header then header.Active = false end
                else
                    child.Active = true
                    child.Selectable = true
                    local header = child:FindFirstChild("Header")
                    if header then header.Active = true end
                end
            end
        end
    end
    lockBtn.MouseButton1Click:Connect(function() updateLockState(not guiLocked) end)
    task.defer(function() updateLockState(false) end)

    local screenW = workspace.CurrentCamera.ViewportSize.X
    local screenH = workspace.CurrentCamera.ViewportSize.Y

    local function makeDraggable(frame, handle)
        handle = handle or frame
        local dragging, dragStart, startPos
        handle.Active = true
        handle.InputBegan:Connect(function(inp)
            if guiLocked then return end
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = inp.Position
                startPos = frame.Position
                inp.Changed:Connect(function()
                    if inp.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(inp)
            if not dragging or guiLocked then return end
            if inp.UserInputType ~= Enum.UserInputType.MouseMovement
            and inp.UserInputType ~= Enum.UserInputType.Touch then return end
            local d = inp.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end)
    end

    local function makeResizable(panel, minW, minH)
        local grip = Instance.new("TextButton")
        grip.Size = UDim2.new(0, 18, 0, 18)
        grip.Position = UDim2.new(1, -20, 1, -20)
        grip.BackgroundTransparency = 1
        grip.BorderSizePixel = 0
        grip.ZIndex = 30
        grip.Text = "⋯"
        grip.TextColor3 = C.textMute
        grip.TextSize = 10
        grip.Font = Enum.Font.Gotham
        grip.AutoButtonColor = false
        grip.Parent = panel
        local resizing, resizeStart, startSz
        grip.InputBegan:Connect(function(inp)
            if guiLocked then return end
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch then
                resizing = true
                resizeStart = inp.Position
                startSz = Vector2.new(panel.AbsoluteSize.X, panel.AbsoluteSize.Y)
                inp.Changed:Connect(function()
                    if inp.UserInputState == Enum.UserInputState.End then resizing = false end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(inp)
            if not resizing or guiLocked then return end
            if inp.UserInputType ~= Enum.UserInputType.MouseMovement
            and inp.UserInputType ~= Enum.UserInputType.Touch then return end
            local d = inp.Position - resizeStart
            local viewport = workspace.CurrentCamera.ViewportSize
            local panelTopY = panel.AbsolutePosition.Y
            local panelLeftX = panel.AbsolutePosition.X
            local maxW = math.max(minW, viewport.X - panelLeftX - 6)
            local maxH = math.max(minH, viewport.Y - panelTopY - 6)
            local nW = math.clamp(startSz.X + d.X, minW, maxW)
            local nH = math.clamp(startSz.Y + d.Y, minH, maxH)
            panel.Size = UDim2.new(0, nW, 0, nH)
        end)
    end

    local HEADER_H = 34

    local function makePanel(name, titleText, px, py, pw, ph, minW, minH)
        local panel = Instance.new("Frame")
        panel.Name = name
        panel.Size = UDim2.new(0, pw, 0, ph)
        panel.Position = UDim2.new(0, px, 0, py)
        panel.BackgroundColor3 = C.body
        panel.BackgroundTransparency = 0.20
        panel.BorderSizePixel = 0
        panel.ClipsDescendants = false
        panel.ZIndex = 5
        panel.Parent = HIGH_HUB_GUI
        local pc = Instance.new("UICorner", panel); pc.CornerRadius = UDim.new(0, 14)

        local panelStroke = Instance.new("UIStroke")
        panelStroke.Thickness = 1.6
        panelStroke.Color = Color3.new(1, 1, 1)
        panelStroke.Transparency = 0
        panelStroke.Parent = panel
        local panelStrokeGradient = Instance.new("UIGradient")
        local isSettingsPanel = name == "SettingsPanel"
        local borderRotationSpeed = isSettingsPanel and 24 or 70
        if isSettingsPanel then
            panelStroke.Thickness = 1.25
            panelStroke.Transparency = 0.16
            panelStrokeGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(145, 24, 34)),
                ColorSequenceKeypoint.new(0.35, Color3.fromRGB(205, 38, 48)),
                ColorSequenceKeypoint.new(0.68, Color3.fromRGB(240, 52, 62)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(155, 26, 36))
            })
        else
            panelStrokeGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(0.22, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(0.38, Color3.fromRGB(235, 40, 52)),
                ColorSequenceKeypoint.new(0.55, Color3.fromRGB(255, 75, 85)),
                ColorSequenceKeypoint.new(0.72, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(0.86, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 40, 52))
            })
        end
        panelStrokeGradient.Parent = panelStroke
        table.insert(ActiveConnections, RunService.Heartbeat:Connect(function()
            if panelStrokeGradient and panelStrokeGradient.Parent then
                panelStrokeGradient.Rotation = (tick() * borderRotationSpeed) % 360
                if isSettingsPanel and panel.Visible then
                    panelStroke.Transparency = 0.12 + 0.08 * (0.5 + 0.5 * math.sin(tick() * 1.8))
                end
            end
        end))

        local hdr = Instance.new("Frame")
        hdr.Name = "Header"
        hdr.Size = UDim2.new(1, 0, 0, HEADER_H)
        hdr.BackgroundColor3 = C.panel
        hdr.BackgroundTransparency = 0.20
        hdr.BorderSizePixel = 0
        hdr.ZIndex = 6
        hdr.Active = true
        hdr.Parent = panel
        Instance.new("UICorner", hdr).CornerRadius = UDim.new(0, 14)

        local hExt = Instance.new("Frame")
        hExt.Size = UDim2.new(1, 0, 0, 14)
        hExt.Position = UDim2.new(0, 0, 1, -14)
        hExt.BackgroundColor3 = C.panel
        hExt.BackgroundTransparency = 0.20
        hExt.BorderSizePixel = 0
        hExt.ZIndex = 5
        hExt.Parent = hdr

        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 6, 0, 6)
        dot.Position = UDim2.new(0, 11, 0.5, -3)
        dot.BackgroundColor3 = C.accent
        dot.BorderSizePixel = 0
        dot.ZIndex = 8
        dot.Parent = hdr
        Instance.new("UICorner", dot).CornerRadius = UDim.new(0, 3)

        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size = UDim2.new(0, 0, 1, 0)
        titleLbl.AutomaticSize = Enum.AutomaticSize.X
        titleLbl.Position = UDim2.new(0, 22, 0, 0)
        titleLbl.BackgroundTransparency = 1
        titleLbl.BorderSizePixel = 0
        titleLbl.ZIndex = 8
        titleLbl.Text = titleText
        titleLbl.TextColor3 = C.textBright
        titleLbl.TextSize = isMob and 11 or 13
        titleLbl.Font = Enum.Font.GothamBold
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.Parent = hdr

        local titleGrad = Instance.new("UIGradient", titleLbl)
        titleGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.textBright),
            ColorSequenceKeypoint.new(.5, C.textMauve),
            ColorSequenceKeypoint.new(1, C.textBright)
        })
        table.insert(ActiveConnections, RunService.Heartbeat:Connect(function()
            if titleGrad and titleGrad.Parent then
                titleGrad.Rotation = (tick()*100)%360
            end
        end))

        local content = Instance.new("Frame")
        content.Name = "Content"
        content.Size = UDim2.new(1, 0, 1, -HEADER_H)
        content.Position = UDim2.new(0, 0, 0, HEADER_H)
        content.BackgroundTransparency = 1
        content.BorderSizePixel = 0
        content.ClipsDescendants = true
        content.ZIndex = 5
        content.Parent = panel

        makeDraggable(panel, hdr)
        makeResizable(panel, minW, minH)
        return panel, content, hdr, titleLbl
    end

    -- PANEL ACTIONS
    local FLASHTP, flashAccent, BLOCK, blockAccent, RESET, resetAccent
    do
        local AW = isMob and 400 or 380
        local ACT_BTN_W = isMob and 80 or 85
        local ACT_BTN_H = isMob and 32 or 36
        local ACT_PADDING = 6
        local AH_HORIZONTAL = HEADER_H + 12 + ACT_BTN_H + 8

        -- Migra o layout anterior para o novo nome do painel.
        if uiLayout["ActionsFlashPanel"] == nil and uiLayout["ActionsPanel"] ~= nil then
            uiLayout["ActionsFlashPanel"] = uiLayout["ActionsPanel"]
        end
        local actionsPanel, actionsContent, actionsHdr = makePanel(
            "ActionsFlashPanel", "ACTIONS FLASH",
            math.floor(screenW / 2 - AW / 2),
            math.floor(screenH * 0.07) - 25,
            AW, AH_HORIZONTAL, 180, AH_HORIZONTAL
        )
        registerPanelLayout(actionsPanel, "ActionsFlashPanel", 180, AH_HORIZONTAL)

        local btnContainer = Instance.new("Frame")
        btnContainer.Name = "ActionsContainer"
        btnContainer.Size = UDim2.new(1, -14, 1, -10)
        btnContainer.Position = UDim2.new(0, 7, 0, 6)
        btnContainer.BackgroundTransparency = 1
        btnContainer.ZIndex = 6
        btnContainer.Parent = actionsContent

        local UIListAct = Instance.new("UIListLayout")
        UIListAct.FillDirection = Enum.FillDirection.Horizontal
        UIListAct.VerticalAlignment = Enum.VerticalAlignment.Center
        UIListAct.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListAct.SortOrder = Enum.SortOrder.LayoutOrder
        UIListAct.Padding = UDim.new(0, ACT_PADDING)
        UIListAct.Parent = btnContainer


        local function mkActionBtn(name, txt, order)
            local b = Instance.new("TextButton")
            b.Name = name
            b.Size = UDim2.new(0, ACT_BTN_W, 0, ACT_BTN_H)
            b.BackgroundColor3 = C.card
            b.BackgroundTransparency = 0.2
            b.BorderSizePixel = 0
            b.ZIndex = 7
            b.Text = ""
            b.AutoButtonColor = false
            b.LayoutOrder = order
            b.Parent = btnContainer
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
            local bs = Instance.new("UIStroke", b)
            bs.Color = C.strokeDim
            bs.Thickness = 1
            bs.Transparency = 0.35
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -4, 1, 0)
            lbl.Position = UDim2.new(0, 2, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.ZIndex = 9
            lbl.Text = txt
            lbl.TextColor3 = C.textBright
            lbl.TextSize = isMob and 9 or 11
            lbl.Font = Enum.Font.GothamBold
            lbl.TextWrapped = true
            lbl.TextXAlignment = Enum.TextXAlignment.Center
            lbl.TextYAlignment = Enum.TextYAlignment.Center
            local labelGradient = Instance.new("UIGradient")
            labelGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, C.textBright),
                ColorSequenceKeypoint.new(0.5, C.accentHi),
                ColorSequenceKeypoint.new(1, C.textBright)
            })
            labelGradient.Parent = lbl
            table.insert(ActiveConnections, RunService.Heartbeat:Connect(function()
                if labelGradient and labelGradient.Parent then labelGradient.Rotation = (tick() * 90) % 360 end
            end))
            lbl.Parent = b
            local bar = Instance.new("Frame")
            bar.Name = "AccentBar"
            bar.Size = UDim2.new(0, 0, 0, 0)
            bar.BackgroundColor3 = C.stroke
            bar.BackgroundTransparency = 1
            bar.BorderSizePixel = 0
            bar.ZIndex = 1
            bar.Parent = b
            return b, bar, lbl
        end

        FLASHTP, flashAccent = mkActionBtn("FLASHTP", "FLASH TP", 1)
        BLOCK, blockAccent = mkActionBtn("BLOCK", "BLOCK", 2)
        RESET, resetAccent = mkActionBtn("RESET", "RESET", 3)
    end

    -- PANEL ALLOW/DISALLOW
    local ADW = isMob and 300 or 360
    local AD_BTN_W = isMob and 120 or 140
    local AD_BTN_H = isMob and 32 or 36
    local ADH = HEADER_H + 12 + AD_BTN_H + 8

    local allowPanel, allowContent, allowHdr = makePanel(
        "AllowPanel", "ALLOW/DISALLOW",
        math.floor(screenW / 2 - ADW / 2),
        math.floor(screenH * 0.07 + 35),
        ADW, ADH, 170, ADH
    )
    allowPanel.Visible = _G.AllowDisallowEnabled
    registerPanelLayout(allowPanel, "AllowPanel", 170, ADH)

    local allowBtnContainer = Instance.new("Frame")
    allowBtnContainer.Size = UDim2.new(1, -14, 1, -10)
    allowBtnContainer.Position = UDim2.new(0, 7, 0, 6)
    allowBtnContainer.BackgroundTransparency = 1
    allowBtnContainer.Parent = allowContent
    local UIListAllow = Instance.new("UIListLayout")
    UIListAllow.FillDirection = Enum.FillDirection.Horizontal
    UIListAllow.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListAllow.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListAllow.SortOrder = Enum.SortOrder.LayoutOrder
    UIListAllow.Padding = UDim.new(0, 6)
    UIListAllow.Parent = allowBtnContainer

    local allowBtn, allowAccent
    do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, AD_BTN_W, 0, AD_BTN_H)
        b.BackgroundColor3 = C.card
        b.BackgroundTransparency = 0.2
        b.BorderSizePixel = 0
        b.ZIndex = 7
        b.Text = ""
        b.AutoButtonColor = false
        b.LayoutOrder = 1
        b.Parent = allowBtnContainer
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        local bs = Instance.new("UIStroke", b); bs.Color = C.stroke; bs.Thickness = 1; bs.Transparency = 0.2
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -4, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.ZIndex = 9
        lbl.Text = "DISALLOW"
        lbl.TextColor3 = C.textBright
        lbl.TextSize = isMob and 9 or 11
        lbl.Font = Enum.Font.GothamBold
        lbl.TextWrapped = true
        lbl.TextXAlignment = Enum.TextXAlignment.Center
        lbl.TextYAlignment = Enum.TextYAlignment.Center
        lbl.Parent = b
        local bar = Instance.new("Frame")
        bar.BackgroundTransparency = 1
        bar.Parent = b
        local allowGrad = Instance.new("UIGradient", lbl)
        allowGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.textBright),
            ColorSequenceKeypoint.new(0.5, C.textMauve),
            ColorSequenceKeypoint.new(1, C.textBright)
        })
        table.insert(ActiveConnections, RunService.Heartbeat:Connect(function()
            if allowGrad and allowGrad.Parent then allowGrad.Rotation = (tick()*100)%360 end
        end))
        allowBtn = b
        allowAccent = bar
    end

    local allowState = false
    allowBtn.BackgroundColor3 = C.card
    local function toggleAllow()
        if not _G.AllowDisallowEnabled then return end
        allowState = not allowState
        local lbl = allowBtn:FindFirstChildOfClass("TextLabel")
        if lbl then
            lbl.Text = allowState and "ALLOW" or "DISALLOW"
            lbl.TextColor3 = C.textBright
        end
        local bs = allowBtn:FindFirstChildOfClass("UIStroke")
        if bs then bs.Color = C.stroke; bs.Transparency = 0.35 end
        allowBtn.BackgroundColor3 = C.card
        if allowAccent then
            allowAccent.BackgroundColor3 = C.accentHi
            TweenService:Create(allowAccent, TweenInfo.new(0.4), { BackgroundColor3 = C.stroke }):Play()
        end
        local cmdName = allowState and "allow" or "disallow"
        if ExecuteCommand then ExecuteCommand(cmdName, LocalPlayer.Name) return end
        local plotsFolder = Workspace:FindFirstChild("Plots")
        if plotsFolder then
            for _, plot in ipairs(plotsFolder:GetChildren()) do
                if isMyPlot(plot) then
                    local prompt = plot:FindFirstChild("FriendPanel")
                        and plot.FriendPanel:FindFirstChild("Main")
                        and plot.FriendPanel.Main:FindFirstChild("ProximityPrompt")
                    if prompt then pcall(fireproximityprompt, prompt) end
                end
            end
        end
    end
    allowBtn.MouseButton1Click:Connect(toggleAllow)

    -- PANEL ESP TIME FLASH TELEPORT
    local flashTimePanel, flashTimeContent, flashTimeMessage
    local flashTimeDeadline = 0
    local flashTimeRunning = false
    local flashTimeReadyRed = Color3.fromRGB(235, 50, 60)
    local flashTimeRed = Color3.fromRGB(245, 70, 80)
    local flashTimeText = "Ready Flash Teleport"

    local FTW = isMob and 300 or 360
    local FTH = HEADER_H + 12 + 42 + 8
    flashTimePanel, flashTimeContent, _ = makePanel(
        "EspTimeFlashTeleportPanel", "ESP TIME FLASH TELEPORT",
        math.floor(screenW / 2 - FTW / 2),
        math.floor(screenH * 0.07 + 112),
        FTW, FTH, 190, FTH
    )
    registerPanelLayout(flashTimePanel, "EspTimeFlashTeleportPanel", 190, FTH)

    local flashTimeBody = Instance.new("Frame")
    flashTimeBody.Size = UDim2.new(1, -14, 1, -10)
    flashTimeBody.Position = UDim2.new(0, 7, 0, 6)
    flashTimeBody.BackgroundTransparency = 1
    flashTimeBody.Parent = flashTimeContent

    flashTimeMessage = Instance.new("TextLabel")
    flashTimeMessage.Size = UDim2.new(1, -12, 1, 0)
    flashTimeMessage.Position = UDim2.new(0, 6, 0, 0)
    flashTimeMessage.BackgroundTransparency = 1
    flashTimeMessage.Text = flashTimeText
    flashTimeMessage.TextColor3 = flashTimeReadyRed
    flashTimeMessage.TextSize = isMob and 10 or 12
    flashTimeMessage.TextScaled = true
    flashTimeMessage.Font = Enum.Font.GothamBold
    flashTimeMessage.TextWrapped = false
    flashTimeMessage.TextTruncate = Enum.TextTruncate.AtEnd
    flashTimeMessage.TextXAlignment = Enum.TextXAlignment.Center
    flashTimeMessage.TextYAlignment = Enum.TextYAlignment.Center
    flashTimeMessage.Parent = flashTimeBody
    flashTimeMessage.TextColor3 = Color3.new(1, 1, 1)
    local flashTimeTextGradient = Instance.new("UIGradient")
    flashTimeTextGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(235, 50, 60)),
        ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
    })
    flashTimeTextGradient.Rotation = 0
    flashTimeTextGradient.Parent = flashTimeMessage
    local flashTimeTextLimit = Instance.new("UITextSizeConstraint", flashTimeMessage)
    flashTimeTextLimit.MinTextSize = 8
    flashTimeTextLimit.MaxTextSize = isMob and 11 or 14

    local flashTimeStroke = Instance.new("UIStroke", flashTimeBody)
    flashTimeStroke.Color = flashTimeRed
    flashTimeStroke.Transparency = 0.45
    flashTimeStroke.Thickness = 1
    local flashTimeCorner = Instance.new("UICorner", flashTimeBody)
    flashTimeCorner.CornerRadius = UDim.new(0, 8)

    local function setFlashTimeReady(ready)
        local color = ready and flashTimeReadyRed or flashTimeRed
        flashTimeMessage.TextColor3 = Color3.new(1, 1, 1)
        flashTimeStroke.Color = color
        flashTimePanel.BackgroundColor3 = C.body
    end

    local function startFlashTeleportTimer()
        if flashTimeRunning then return end
        flashTimeDeadline = tick() + 20
        flashTimeRunning = true
        flashTimeMessage.Text = "Cooldown Flash | 20.0s"
        setFlashTimeReady(false)
    end

    -- Também acompanha o uso real da ferramenta, e não apenas o botão da hub.
    local hookedFlashTools = {}
    local function hookFlashTeleportTool(tool)
        if not tool or not tool:IsA("Tool") then return end
        if string.lower(tool.Name) ~= "flash teleport" then return end
        if hookedFlashTools[tool] then return end
        hookedFlashTools[tool] = true
        table.insert(ActiveConnections, tool.Activated:Connect(function()
            startFlashTeleportTimer()
        end))
        table.insert(ActiveConnections, tool.Destroying:Connect(function()
            hookedFlashTools[tool] = nil
        end))
    end
    local function hookFlashTeleportContainer(container)
        if not container then return end
        for _, child in ipairs(container:GetChildren()) do hookFlashTeleportTool(child) end
        table.insert(ActiveConnections, container.ChildAdded:Connect(hookFlashTeleportTool))
    end
    hookFlashTeleportContainer(LocalPlayer.Character)
    hookFlashTeleportContainer(LocalPlayer:FindFirstChildOfClass("Backpack"))
    table.insert(ActiveConnections, LocalPlayer.CharacterAdded:Connect(function(character)
        task.defer(function() hookFlashTeleportContainer(character) end)
    end))

    -- Estado livre: não exibe segundos.
    setFlashTimeReady(true)
    table.insert(ActiveConnections, RunService.Heartbeat:Connect(function()
        if flashTimeTextGradient and flashTimeTextGradient.Parent then
            flashTimeTextGradient.Rotation = (tick() * 90) % 360
        end
        if not flashTimeRunning or not flashTimeMessage or not flashTimeMessage.Parent then return end
        local remaining = math.max(0, flashTimeDeadline - tick())
        local tenths = math.floor(remaining * 10 + 1e-6) / 10
        flashTimeMessage.Text = string.format("Cooldown Flash | %.1fs", tenths)
        if remaining <= 0 then
            flashTimeRunning = false
            flashTimeMessage.Text = flashTimeText
            setFlashTimeReady(true)
        end
    end))

    -- PANEL BRAINROTS
    local BW = isMob and 198 or 234
    local BH = isMob and 195 or 245
    local brainrotsPanel, brainrotsContent = makePanel(
        "BrainrotsPanel", "BRAINROTS",
        math.floor(screenW / 2 - BW / 2),
        math.floor(screenH * 0.22),
        BW, BH, 160, 130
    )
    registerPanelLayout(brainrotsPanel, "BrainrotsPanel", 160, 130)

    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "ScrollingFrame"
    ScrollingFrame.Size = UDim2.new(1, -4, 1, -4)
    ScrollingFrame.Position = UDim2.new(0, 2, 0, 2)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.ScrollBarThickness = 3
    ScrollingFrame.ScrollBarImageColor3 = C.accent
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.Parent = brainrotsContent
    local UIListLayout2 = Instance.new("UIListLayout")
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout2.Padding = UDim.new(0, 4)
    UIListLayout2.Parent = ScrollingFrame
    local UIPaddingList = Instance.new("UIPadding")
    UIPaddingList.PaddingTop = UDim.new(0, 6)
    UIPaddingList.PaddingBottom = UDim.new(0, 6)
    UIPaddingList.PaddingLeft = UDim.new(0, 5)
    UIPaddingList.PaddingRight = UDim.new(0, 5)
    UIPaddingList.Parent = ScrollingFrame
    scrollListRef = ScrollingFrame

    -- PANEL SETTINGS
    local SW = isMob and 320 or 380
    local SH = isMob and 350 or 420
    local settingsPanel, settingsContent, settingsHdr = makePanel(
        "SettingsPanel", "SETTINGS",
        math.floor(screenW / 2 + 14),
        math.floor(screenH * 0.10),
        SW, SH, 280, 280
    )
    registerPanelLayout(settingsPanel, "SettingsPanel", 280, 280)
    settingsPanel.Visible = false
    local settingsOpen = false
    local function setSettingsOpen(open)
        settingsOpen = open == true
        settingsPanel.Visible = settingsOpen
    end

    local TAB_PANEL_W = 52
    local TAB_BTN_H = 32
    local tabPanel = Instance.new("Frame")
    tabPanel.Size = UDim2.new(0, TAB_PANEL_W, 1, -10)
    tabPanel.Position = UDim2.new(0, 4, 0, 5)
    tabPanel.BackgroundTransparency = 1
    tabPanel.ZIndex = 6
    tabPanel.Parent = settingsContent
    local tabList = Instance.new("UIListLayout")
    tabList.FillDirection = Enum.FillDirection.Vertical
    tabList.VerticalAlignment = Enum.VerticalAlignment.Top
    tabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Padding = UDim.new(0, 4)
    tabList.Parent = tabPanel

    local tabButtons = {}
    local tabFrames = {}
    local function selectTab(key)
        for k, frame in pairs(tabFrames) do
            frame.Visible = (k == key)
        end
        for k, btn in pairs(tabButtons) do
            local active = (k == key)
            TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundTransparency = active and 0.2 or 0.7 }):Play()
            local bs = btn:FindFirstChildOfClass("UIStroke")
            if bs then
                TweenService:Create(bs, TweenInfo.new(0.12), {
                    Color = active and C.accent or C.strokeDim,
                    Transparency = active and 0 or 0.4,
                }):Play()
            end
            local lbl = btn:FindFirstChildOfClass("TextLabel")
            if lbl then lbl.TextColor3 = active and C.accent or C.textMute end
        end
    end
    local function makeTab(key, label, order)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, TAB_PANEL_W-8, 0, TAB_BTN_H)
        btn.BackgroundColor3 = C.card
        btn.BackgroundTransparency = 0.7
        btn.BorderSizePixel = 0
        btn.ZIndex = 7
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.LayoutOrder = order
        btn.Parent = tabPanel
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local bs = Instance.new("UIStroke", btn); bs.Color = C.strokeDim; bs.Thickness = 1; bs.Transparency = 0.4
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -4, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.ZIndex = 8
        lbl.Text = label
        lbl.TextColor3 = C.textMute
        lbl.TextSize = isMob and 9 or 10
        lbl.Font = Enum.Font.GothamBold
        lbl.TextWrapped = true
        lbl.TextXAlignment = Enum.TextXAlignment.Center
        lbl.TextYAlignment = Enum.TextYAlignment.Center
        lbl.Parent = btn

        local frame = Instance.new("ScrollingFrame")
        frame.Size = UDim2.new(1, -(TAB_PANEL_W + 14), 1, -8)
        frame.Position = UDim2.new(0, TAB_PANEL_W + 6, 0, 4)
        frame.BackgroundTransparency = 1
        frame.BorderSizePixel = 0
        frame.CanvasSize = UDim2.new(0, 0, 0, 0)
        frame.ScrollBarThickness = 3
        frame.ScrollBarImageColor3 = C.accent
        frame.ScrollingDirection = Enum.ScrollingDirection.Y
        frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        frame.Visible = false
        frame.Parent = settingsContent

        local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        listLayout.Padding = UDim.new(0, 4)
        listLayout.Parent = frame

        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 8)
        padding.PaddingBottom = UDim.new(0, 8)
        padding.PaddingLeft = UDim.new(0, 4)
        padding.PaddingRight = UDim.new(0, 4)
        padding.Parent = frame

        btn.MouseButton1Click:Connect(function() selectTab(key) end)
        tabButtons[key] = btn
        tabFrames[key] = frame
        return frame
    end

    makeTab("reset", "RESET", 1)
    makeTab("flash", "FLASH", 2)
    makeTab("block", "BLOCK", 3)
    makeTab("misc", "MISC", 4)
    makeTab("visual", "VISUAL", 5)
    makeTab("keybinds", "KEYBIRDS", 6)

    local ScrollReset, ScrollFlash, ScrollBlock, ScrollMisc, ScrollVisual, ScrollKeybinds =
        tabFrames.reset, tabFrames.flash, tabFrames.block, tabFrames.misc, tabFrames.visual, tabFrames.keybinds
    selectTab("reset")

    local sectionOrder = 0
    local toggleRefs = {}

    local function sectionHeader(parent, text)
        sectionOrder += 1
        local wrap = Instance.new("Frame")
        wrap.Size = UDim2.new(1, 0, 0, 22)
        wrap.BackgroundTransparency = 1
        wrap.ZIndex = 4
        wrap.LayoutOrder = sectionOrder
        wrap.Parent = parent
        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, 0, 0, 1)
        line.Position = UDim2.new(0, 0, 0.5, 0)
        line.BackgroundColor3 = C.stroke
        line.BorderSizePixel = 0
        line.ZIndex = 5
        line.Parent = wrap
        local pill = Instance.new("Frame")
        -- O pill cresce a partir do TextLabel, mantendo o título sempre dentro do fundo.
        pill.Size = UDim2.new(0, 0, 1, 0)
        pill.Position = UDim2.new(0.5, 0, 0, 0)
        pill.AnchorPoint = Vector2.new(0.5, 0)
        pill.BackgroundColor3 = C.panel
        pill.BorderSizePixel = 0
        pill.ZIndex = 6
        pill.AutomaticSize = Enum.AutomaticSize.X
        pill.Parent = wrap
        Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 5)
        local pillPadding = Instance.new("UIPadding")
        pillPadding.PaddingLeft = UDim.new(0, 8)
        pillPadding.PaddingRight = UDim.new(0, 8)
        pillPadding.Parent = pill
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0, 0, 1, 0)
        lbl.AutomaticSize = Enum.AutomaticSize.X
        lbl.BackgroundTransparency = 1
        lbl.ZIndex = 7
        lbl.Text = text
        lbl.TextColor3 = C.textMute
        lbl.TextSize = 10
        lbl.Font = Enum.Font.GothamBold
        lbl.TextXAlignment = Enum.TextXAlignment.Center
        lbl.TextYAlignment = Enum.TextYAlignment.Center
        lbl.TextTruncate = Enum.TextTruncate.AtEnd
        lbl.Parent = pill
        return wrap
    end

    local function toggleRow(parent, title, defaultOn, onToggle)
        sectionOrder += 1
        local row = Instance.new("Frame")
        row.Size = UDim2.new(0.92, 0, 0, 32)
        row.AnchorPoint = Vector2.new(0.5, 0)
        row.Position = UDim2.new(0.5, 0, 0, 0)
        row.BackgroundColor3 = C.card
        row.BackgroundTransparency = 0.6
        row.BorderSizePixel = 0
        row.ZIndex = 4
        row.LayoutOrder = sectionOrder
        row.Parent = parent
        Instance.new("UICorner", row).CornerRadius = UDim.new(1, 0)
        local s = Instance.new("UIStroke", row); s.Color = C.strokeDim; s.Thickness = 1; s.Transparency = 0.35

        local t1 = Instance.new("TextLabel")
        t1.Size = UDim2.new(1, -50, 1, 0)
        t1.Position = UDim2.new(0, 10, 0, 0)
        t1.BackgroundTransparency = 1
        t1.ZIndex = 5
        t1.Text = title
        t1.TextColor3 = C.textBright
        t1.TextSize = 12
        t1.Font = Enum.Font.GothamMedium
        t1.TextXAlignment = Enum.TextXAlignment.Left
        t1.TextYAlignment = Enum.TextYAlignment.Center
        t1.TextTruncate = Enum.TextTruncate.AtEnd
        t1.Parent = row

        local track = Instance.new("Frame")
        track.Size = UDim2.new(0, 34, 0, 18)
        track.Position = UDim2.new(1, -40, 0.5, -9)
        track.BackgroundColor3 = C.accent
        track.BorderSizePixel = 0
        track.ZIndex = 6
        track.ClipsDescendants = true
        track.Parent = row
        Instance.new("UICorner", track).CornerRadius = UDim.new(0, 9)
        local ts = Instance.new("UIStroke", track); ts.Color = C.accent

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 12, 0, 12)
        knob.Position = UDim2.new(0, 18, 0.5, -6)
        knob.BackgroundColor3 = C.knobOn
        knob.BorderSizePixel = 0
        knob.ZIndex = 7
        knob.ClipsDescendants = true
        knob.Parent = track
        Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 6)

        local hit = Instance.new("TextButton")
        hit.Size = UDim2.new(1, 0, 1, 0)
        hit.BackgroundTransparency = 1
        hit.ZIndex = 8
        hit.Text = ""
        hit.Parent = row

        local ref = { on = defaultOn ~= false, track = track, stroke = ts, knob = knob }
        local function render(animate)
            local info = TweenInfo.new(animate and 0.14 or 0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            if ref.on then
                TweenService:Create(track, info, { BackgroundColor3 = C.accent }):Play()
                TweenService:Create(ts, info, { Color = C.accent }):Play()
                TweenService:Create(knob, info, { Position = UDim2.new(0, 18, 0.5, -6), BackgroundColor3 = C.knobOn }):Play()
            else
                TweenService:Create(track, info, { BackgroundColor3 = C.trackOff }):Play()
                TweenService:Create(ts, info, { Color = C.stroke }):Play()
                TweenService:Create(knob, info, { Position = UDim2.new(0, 3, 0.5, -6), BackgroundColor3 = C.knobOff }):Play()
            end
        end
        ref.render = render
        render(false)
        if onToggle then task.defer(function() pcall(onToggle, ref.on) end) end
        hit.MouseButton1Click:Connect(function()
            ref.on = not ref.on
            render(true)
            if onToggle then pcall(onToggle, ref.on) end
            pcall(saveSettings)
        end)
        table.insert(toggleRefs, ref)
        return row, ref
    end

    local function dropdownRow(parent, title, options, defaultValue, onSelect)
        sectionOrder += 1
        local row = Instance.new("Frame")
        row.Size = UDim2.new(0.92, 0, 0, 32)
        row.AnchorPoint = Vector2.new(0.5, 0)
        row.Position = UDim2.new(0.5, 0, 0, 0)
        row.BackgroundColor3 = C.card
        row.BackgroundTransparency = 0.6
        row.BorderSizePixel = 0
        row.ZIndex = 4
        row.LayoutOrder = sectionOrder
        row.ClipsDescendants = false
        row.Parent = parent
        Instance.new("UICorner", row).CornerRadius = UDim.new(1, 0)
        local s = Instance.new("UIStroke", row); s.Color = C.strokeDim; s.Thickness = 1; s.Transparency = 0.35

        local t1 = Instance.new("TextLabel")
        t1.Size = UDim2.new(1, -120, 1, 0)
        t1.Position = UDim2.new(0, 10, 0, 0)
        t1.BackgroundTransparency = 1
        t1.ZIndex = 5
        t1.Text = title
        t1.TextColor3 = C.textBright
        t1.TextSize = 12
        t1.Font = Enum.Font.GothamMedium
        t1.TextXAlignment = Enum.TextXAlignment.Left
        t1.Parent = row

        local selectorBtn = Instance.new("TextButton")
        selectorBtn.Size = UDim2.new(0, 104, 0, 22)
        selectorBtn.Position = UDim2.new(1, -112, 0.5, -11)
        selectorBtn.BackgroundColor3 = C.iconBg
        selectorBtn.BorderSizePixel = 0
        selectorBtn.ZIndex = 6
        selectorBtn.Text = defaultValue
        selectorBtn.TextColor3 = C.textBright
        selectorBtn.TextSize = 11
        selectorBtn.TextTruncate = Enum.TextTruncate.AtEnd
        selectorBtn.Font = Enum.Font.GothamBold
        selectorBtn.AutoButtonColor = false
        selectorBtn.Parent = row
        Instance.new("UICorner", selectorBtn).CornerRadius = UDim.new(0, 6)
        local selStroke = Instance.new("UIStroke", selectorBtn); selStroke.Color = C.accent

        local arrow = Instance.new("TextLabel")
        arrow.Size = UDim2.new(0, 16, 1, 0)
        arrow.Position = UDim2.new(1, -18, 0, 0)
        arrow.BackgroundTransparency = 1
        arrow.ZIndex = 7
        arrow.Text = "v"
        arrow.TextColor3 = C.accent
        arrow.TextSize = 11
        arrow.Font = Enum.Font.GothamBold
        arrow.Parent = selectorBtn

        local list = Instance.new("Frame")
        list.Name = "DropList"
        list.Size = UDim2.new(0, 104, 0, #options * 24)
        list.BackgroundColor3 = C.panel
        list.BorderSizePixel = 0
        list.ZIndex = 50
        list.Visible = false
        list.Parent = settingsPanel
        Instance.new("UICorner", list).CornerRadius = UDim.new(0, 6)
        local listStroke = Instance.new("UIStroke", list); listStroke.Color = C.accent

        local listLayout2 = Instance.new("UIListLayout")
        listLayout2.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout2.Parent = list

        local open = false
        local function setOpen(state)
            open = state
            if state then
                local abs = selectorBtn.AbsolutePosition
                local panelAbs = settingsPanel.AbsolutePosition
                list.Position = UDim2.new(0, abs.X - panelAbs.X, 0, abs.Y - panelAbs.Y + selectorBtn.AbsoluteSize.Y + 4)
            end
            list.Visible = state
            arrow.Text = state and "^" or "v"
        end
        for i, optName in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 24)
            optBtn.BackgroundColor3 = C.card
            optBtn.BackgroundTransparency = (optName == defaultValue) and 0 or 1
            optBtn.BorderSizePixel = 0
            optBtn.ZIndex = 51
            optBtn.Text = optName
            optBtn.TextColor3 = C.textBright
            optBtn.TextSize = 10
            optBtn.Font = Enum.Font.GothamMedium
            optBtn.AutoButtonColor = false
            optBtn.LayoutOrder = i
            optBtn.Parent = list
            optBtn.MouseButton1Click:Connect(function()
                selectorBtn.Text = optName
                for _, child in ipairs(list:GetChildren()) do
                    if child:IsA("TextButton") then
                        child.BackgroundTransparency = (child == optBtn) and 0 or 1
                    end
                end
                setOpen(false)
                if onSelect then pcall(onSelect, optName) end
                saveSettings()
            end)
        end
        selectorBtn.MouseButton1Click:Connect(function() setOpen(not open) end)
        if onSelect then task.defer(function() pcall(onSelect, defaultValue) end) end
        return row
    end

    if DEVICE == "pc" then
        table.insert(ActiveConnections, UserInputService.InputBegan:Connect(function(inp, gpe)
            if gpe then return end
            if inp.KeyCode == Enum.KeyCode.LeftControl then
                setSettingsOpen(not settingsOpen)
            end
        end))
    end
    do
        local mBtn = Instance.new("TextButton")
        mBtn.Name = "SettingsToggle"
        mBtn.Size = UDim2.new(0, 86, 0, 36)
        mBtn.Position = UDim2.new(1, -96, 0, 10)
        mBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        mBtn.BackgroundTransparency = 0.18
        mBtn.BorderSizePixel = 0
        mBtn.ZIndex = 20
        mBtn.Text = ""
        mBtn.AutoButtonColor = false
        mBtn.Parent = HIGH_HUB_GUI
        Instance.new("UICorner", mBtn).CornerRadius = UDim.new(0, 10)

        -- Borda animada vermelho/preto, no estilo do contorno da GUI Actions.
        local toggleStroke = Instance.new("UIStroke", mBtn)
        toggleStroke.Thickness = 1.6
        toggleStroke.Color = Color3.fromRGB(255, 255, 255)
        toggleStroke.Transparency = 0
        toggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        toggleStroke.LineJoinMode = Enum.LineJoinMode.Round
        local toggleBorderGradient = Instance.new("UIGradient")
        toggleBorderGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(0.22, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(0.38, Color3.fromRGB(235, 40, 52)),
            ColorSequenceKeypoint.new(0.55, Color3.fromRGB(255, 75, 85)),
            ColorSequenceKeypoint.new(0.72, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(0.86, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 40, 52))
        })
        toggleBorderGradient.Rotation = 0
        toggleBorderGradient.Parent = toggleStroke

        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Name = "ReezLabel"
        toggleLabel.Size = UDim2.new(1, 0, 1, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.BorderSizePixel = 0
        toggleLabel.ZIndex = 21
        toggleLabel.Text = "Reez"
        toggleLabel.TextColor3 = C.textBright
        toggleLabel.TextSize = 16
        toggleLabel.Font = Enum.Font.GothamBold
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Center
        toggleLabel.TextYAlignment = Enum.TextYAlignment.Center
        toggleLabel.Parent = mBtn
        local toggleTextGradient = Instance.new("UIGradient")
        toggleTextGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.textBright),
            ColorSequenceKeypoint.new(0.5, C.accentHi),
            ColorSequenceKeypoint.new(1, C.textBright)
        })
        toggleTextGradient.Parent = toggleLabel

        -- 70 graus/segundo, igual ao contorno animado do painel Actions.
        table.insert(ActiveConnections, RunService.Heartbeat:Connect(function()
            local rotation = (tick() * 70) % 360
            if toggleBorderGradient and toggleBorderGradient.Parent then
                toggleBorderGradient.Rotation = rotation
            end
            if toggleTextGradient and toggleTextGradient.Parent then
                toggleTextGradient.Rotation = rotation
            end
        end))
        makeDraggable(mBtn)
        mBtn.MouseButton1Click:Connect(function()
            setSettingsOpen(not settingsOpen)
        end)
    end

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Visible = false
    TextLabel.Parent = HIGH_HUB_GUI

    -- PANEL QUICK ADMIN
    local QW = isMob and 300 or 340
    local QH = isMob and 220 or 260
    local centerX = math.floor(screenW / 2 - QW / 2)
    local centerY = math.floor(screenH / 2 - QH / 2)
    local qapPanel, qapContent, qapHdr = makePanel(
        "QuickAdminPanel", "QUICK ADMIN PANEL",
        centerX, centerY,
        QW, QH, 280, 60
    )
    -- Carrega antes dos listeners para não sobrescrever a posição salva com o padrão.
    local savedQAPLayout = uiLayout["QuickAdminPanel"] or uiLayout["QuickAPPanel"]
    if type(savedQAPLayout) == "table" then
        pcall(function()
            if savedQAPLayout.px and savedQAPLayout.py then
                qapPanel.Position = UDim2.fromOffset(savedQAPLayout.px, savedQAPLayout.py)
            end
            if savedQAPLayout.pw and savedQAPLayout.ph then
                qapPanel.Size = UDim2.fromOffset(savedQAPLayout.pw, savedQAPLayout.ph)
            end
        end)
    end
    local function saveQAPLayout()
        uiLayout["QuickAdminPanel"] = {
            px = qapPanel.Position.X.Offset, py = qapPanel.Position.Y.Offset,
            pw = qapPanel.Size.X.Offset, ph = qapPanel.Size.Y.Offset,
        }
        saveUILayout()
    end
    qapPanel:GetPropertyChangedSignal("Position"):Connect(saveQAPLayout)
    qapPanel:GetPropertyChangedSignal("Size"):Connect(saveQAPLayout)
    qapPanel:GetPropertyChangedSignal("Visible"):Connect(saveQAPLayout)
    qapPanel.Visible = _G.QuickAP or false

    local qapPlayerScroll = Instance.new("ScrollingFrame")
    qapPlayerScroll.Size = UDim2.new(1, -16, 1, -28)
    qapPlayerScroll.Position = UDim2.new(0, 6, 0, 6)
    qapPlayerScroll.BackgroundTransparency = 1
    qapPlayerScroll.ScrollBarThickness = 3
    qapPlayerScroll.ScrollBarImageColor3 = C.accent
    qapPlayerScroll.BorderSizePixel = 0
    qapPlayerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    qapPlayerScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    qapPlayerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    qapPlayerScroll.Parent = qapContent
    local qapListLayout = Instance.new("UIListLayout")
    qapListLayout.Padding = UDim.new(0, 6)
    qapListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    qapListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    qapListLayout.Parent = qapPlayerScroll

    local qapNoTargetLabel = Instance.new("TextLabel")
    qapNoTargetLabel.Size = UDim2.new(1, 0, 0, 28)
    qapNoTargetLabel.BackgroundTransparency = 1
    qapNoTargetLabel.Text = "No Player Seen"
    qapNoTargetLabel.Font = Enum.Font.GothamMedium
    qapNoTargetLabel.TextColor3 = C.textMute
    qapNoTargetLabel.TextSize = 12
    qapNoTargetLabel.TextXAlignment = Enum.TextXAlignment.Center
    qapNoTargetLabel.Parent = qapPlayerScroll

    local adminCommands = {
        { name = "tiny", emoji = "🤏" },
        { name = "jail", emoji = "🔒" },
        { name = "rocket", emoji = "🚀" },
        { name = "ragdoll", emoji = "🏃" },
        { name = "balloon", emoji = "🎈" },
    }
    local qapCooldownBtns = {}
    for _, cmd in ipairs(adminCommands) do qapCooldownBtns[cmd.name] = {} end

    local function qapGetInGameScrollFrame()
        local ok, sf = pcall(function() return LocalPlayer.PlayerGui.AdminPanel.AdminPanel.Content.ScrollingFrame end)
        return ok and sf or nil
    end
    local function qapIsOnCooldown(cmdName)
        local sf = qapGetInGameScrollFrame()
        if not sf then return false end
        local timer = sf:FindFirstChild(cmdName) and sf[cmdName]:FindFirstChild("Timer")
        return timer and timer.Visible == true
    end
    local function qapGetCooldownText(cmdName)
        local sf = qapGetInGameScrollFrame()
        if not sf then return nil end
        local timer = sf:FindFirstChild(cmdName) and sf[cmdName]:FindFirstChild("Timer")
        return timer and timer.Visible and timer.Text or ""
    end

    local _qapTextBox = nil
    task.spawn(function()
        local ok, tb = pcall(function()
            return LocalPlayer.PlayerGui
                :WaitForChild("AdminPanel")
                :WaitForChild("AdminPanel")
                :WaitForChild("CommandBox")
                :WaitForChild("TextBox")
        end)
        if ok and tb then _qapTextBox = tb end
    end)

    local function ExecuteCommand(cmd, playerName)
        if not playerName then return end
        local TextBox = _qapTextBox
        if not TextBox then return end
        local fullCmd = ";" .. cmd .. " " .. playerName
        local originalVisible = TextBox.Visible
        TextBox.Visible = false
        TextBox.Text = fullCmd
        task.wait(0.05)
        local executed = false
        if firesignal then
            pcall(function()
                firesignal(TextBox.FocusLost, true)
                executed = true
            end)
        end
        if not executed and getconnections then
            pcall(function()
                for _, conn in pairs(getconnections(TextBox.FocusLost)) do
                    conn:Fire(true)
                end
                executed = true
            end)
        end
        task.wait(0.05)
        TextBox.Text = ""
        TextBox.Visible = originalVisible
    end

    local function qapRunCommand(commandName, target)
        if not target then return end
        ExecuteCommand(commandName, target.Name)
    end

    local function createQAPPlayerRow(plr, order)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -8, 0, 40)
        row.BackgroundColor3 = C.card
        row.BackgroundTransparency = 0.6
        row.BorderSizePixel = 0
        row.LayoutOrder = order
        row.Parent = qapPlayerScroll
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
        local rs = Instance.new("UIStroke", row); rs.Color = C.strokeDim; rs.Thickness = 1; rs.Transparency = 0.35

        local avatar = Instance.new("ImageLabel")
        avatar.Size = UDim2.new(0, 26, 0, 26)
        avatar.Position = UDim2.new(0, 8, 0.5, -13)
        avatar.BackgroundTransparency = 1
        avatar.Parent = row
        Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
        task.spawn(function()
            local content, isReady = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
            if isReady and avatar.Parent then avatar.Image = content end
        end)

        local displayText = plr.DisplayName
        if plr.DisplayName ~= plr.Name then
            displayText = plr.DisplayName .. " (@" .. plr.Name .. ")"
        end

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(0, 120, 1, 0)
        nameLbl.Position = UDim2.new(0, 42, 0, 0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = displayText
        nameLbl.Font = Enum.Font.GothamMedium
        nameLbl.TextColor3 = C.textBright
        nameLbl.TextSize = 11
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
        nameLbl.Parent = row

        local btnSize = 26
        local btnGap = 4
        for i, cmd in ipairs(adminCommands) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, btnSize, 0, btnSize)
            btn.AnchorPoint = Vector2.new(1, 0.5)
            btn.Position = UDim2.new(1, -((#adminCommands - i) * (btnSize + btnGap) + 8), 0.5, 0)
            btn.BackgroundColor3 = C.card
            btn.BackgroundTransparency = 0.5
            btn.BorderSizePixel = 0
            btn.Text = cmd.emoji
            btn.TextSize = 13
            btn.Font = Enum.Font.SourceSans
            btn.AutoButtonColor = false
            btn.Parent = row
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            local bs = Instance.new("UIStroke", btn); bs.Color = C.strokeDim; bs.Thickness = 1; bs.Transparency = 0.35
            table.insert(qapCooldownBtns[cmd.name], { btn, cmd.emoji, bs })
            btn.MouseEnter:Connect(function()
                if not qapIsOnCooldown(cmd.name) then
                    TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundTransparency = 0.2 }):Play()
                    TweenService:Create(bs, TweenInfo.new(0.12), { Color = C.accent, Transparency = 0 }):Play()
                end
            end)
            btn.MouseLeave:Connect(function()
                if not qapIsOnCooldown(cmd.name) then
                    TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundTransparency = 0.5 }):Play()
                    TweenService:Create(bs, TweenInfo.new(0.12), { Color = C.strokeDim, Transparency = 0.35 }):Play()
                end
            end)
            local function fireCommand()
                if qapIsOnCooldown(cmd.name) then return end
                task.spawn(function() qapRunCommand(cmd.name, plr) end)
                TweenService:Create(btn, TweenInfo.new(0.08), { BackgroundColor3 = C.accentHi }):Play()
                task.delay(0.2, function()
                    TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = C.card }):Play()
                end)
            end
            btn.MouseButton1Click:Connect(fireCommand)
        end
        return row
    end

    local function refreshQAPPlayers()
        for _, cmd in ipairs(adminCommands) do qapCooldownBtns[cmd.name] = {} end
        for _, child in ipairs(qapPlayerScroll:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        local order = 1
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                createQAPPlayerRow(plr, order)
                order = order + 1
            end
        end
        qapNoTargetLabel.Visible = (order == 1)
    end
    Players.PlayerAdded:Connect(function() task.wait(0.3) refreshQAPPlayers() end)
    Players.PlayerRemoving:Connect(function() task.wait(0.3) refreshQAPPlayers() end)
    task.defer(refreshQAPPlayers)
    task.spawn(function()
        while task.wait(0.25) do
            if thisScriptStopped then break end
            if not qapPanel.Visible then continue end
            for _, cmd in ipairs(adminCommands) do
                local onCD = qapIsOnCooldown(cmd.name)
                local cdTxt = onCD and qapGetCooldownText(cmd.name) or nil
                for _, entry in ipairs(qapCooldownBtns[cmd.name]) do
                    local btn, emoji, bs = entry[1], entry[2], entry[3]
                    if btn and btn.Parent then
                        if onCD and cdTxt then
                            btn.Text = cdTxt
                            btn.TextSize = 10
                            btn.TextColor3 = Color3.fromRGB(200, 80, 80)
                            btn.BackgroundTransparency = 0.8
                            if bs then bs.Color = C.strokeDim bs.Transparency = 0.6 end
                        else
                            btn.Text = emoji
                            btn.TextSize = 13
                            btn.TextColor3 = C.textBright
                            btn.BackgroundTransparency = 0.5
                        end
                    end
                end
            end
        end
    end)

    -- SETTINGS GETTERS
    settingsGetters = {
        AutoResetOnBalloon = function() return _G.AutoResetOnBalloon end,
        RagdollBypass = function() return _G.RagdollBypass end,
        AutoGiant = function() return _G.AutoGiant end,
        AutoBlock = function() return _G.AutoBlock end,
        BlockMode = function() return _G.BlockMode end,
        BypassV1BlockDelay = function() return _G.BypassV1BlockDelay or 0.04 end,
        BypassV1BlockRadius = function() return _G.BypassV1BlockRadius or 4 end,
        BypassV1BlockEnabled = function() return _G.BypassV1BlockEnabled == true end,
        BypassV1GrabEnabled = function() return _G.BypassV1GrabEnabled == true end,
        AntiRagdoll = function() return _G.AntiRagdoll == true end,
        AutoResetTiny = function() return _G.AutoResetTiny end,
        AutoResetJail = function() return _G.AutoResetJail end,
        APESP = function() return _G.APESP end,
        EspTimer = function() return _G.EspTimer end,
        QuickAP = function() return _G.QuickAP end,
        WalkItem = function() return _G.WalkItem end,
        BackpackESP = function() return _G.BackpackESP end,
        ShowAPESP = function() return _G.ShowAPESP end,
        ShowGiantPotion = function() return _G.ShowGiantPotion end,
        ShowFlashTeleport = function() return _G.ShowFlashTeleport end,
        ShowFlyingCarpet = function() return _G.ShowFlyingCarpet end,
        Aimbot = function() return _G.AimbotEnabled or false end,
        QuickPickup = function() return _G.QuickPickup or false end,
        LaggerOnFlash = function() return _G.LaggerOnFlash or false end,
        LaggerPower = function() return _G.LaggerPower or 50 end,
        FlashSpeed = function() return _G.FlashSpeed or 150 end,
        TPV2 = function() return _G.TPV2 == true end,
        AllowDisallowEnabled = function() return _G.AllowDisallowEnabled == true end,
        PlayerESP = function() return _G.PlayerESP or false end,
        PlayerESPShadow = function() return _G.PlayerESPShadow or false end,
        EspBestBrainrot = function() return _G.EspBestBrainrot == true end,
        AutoCarpetSpeed = function() return _G.AutoCarpetSpeed or false end,
        AntiDie = function() return _G.AntiDie or false end,
        AutoBalloon = function() return _G.AutoBalloonEnabled == true end,
        SelectedFont = function() return _G.SelectedFont or "Gotham Bold" end,
        CloneESP = function() return _G.CloneESPEnabled == true end,
        AllowDisallowESP = function() return _G.AllowDisallowESPEnabled == true end,
        GameStretcher = function() return _G.GameStretcher and _G.GameStretcher.isEnabled() end,
        InfiniteJump = function() return _G.InfiniteJumpEnabled == true end,
        AutoTurret = function() return _G.AutoTurretEnabled == true end,
        GummyBypass = function() return _G.GummyBypassEnabled == true end,
        AntiAdmin = function() return _G.AntiAdminEnabled == true end,
        HideAdminPanel = function() return _G.HideAdminPanel == true end,
        LineToBase = function() return _G.LineToBase == true end,
        MineESP = function() return _G.MineESPEnabled == true end,
        BypassProtectV1    = function() return _G.BypassProtectV1 == true end,
        AutoReturnBase     = function() return _G.AutoReturnBase == true end,
    }

    sectionHeader(ScrollReset, "  AUTO RESET  ")
    toggleRow(ScrollReset, "Reset on Balloon", _G.AutoResetOnBalloon, function(v)
        _G.AutoResetOnBalloon = v
        saveSettings()
    end)
    toggleRow(ScrollReset, "Reset On Tiny", _G.AutoResetTiny, function(v)
        _G.AutoResetTiny = v
        TinyState.Enabled = v
        if v then startAutoResetTiny() else stopAutoResetTiny() end
        saveSettings()
    end)
    toggleRow(ScrollReset, "Reset On Jail", _G.AutoResetJail, function(v)
        _G.AutoResetJail = v
        JailState.Enabled = v
        if v then startAutoResetJail() else stopAutoResetJail() end
        saveSettings()
    end)

    sectionHeader(ScrollFlash, "  FLASH TP  ")
    -- 🆕 TP V2 toggle (libera speed 800 + jump + trigger extra)
    toggleRow(ScrollFlash, "TP V2", _G.TPV2, function(v)
        _G.TPV2 = v
        -- clamp speed when disabling
        if not v and _G.FlashSpeed and _G.FlashSpeed > FLASH_SPEED_MAX_BASE then
            _G.FlashSpeed = FLASH_SPEED_MAX_BASE
        end
        if _refreshSpeedSlider then pcall(_refreshSpeedSlider) end
        saveSettings()
    end)
    toggleRow(ScrollFlash, "Anti Body Swap", _G.AntiBodySwap == true, function(v)
        _G.AntiBodySwap = v
        saveSettings()
    end)
    toggleRow(ScrollFlash, "Ragdoll Bypass", _G.RagdollBypass, function(v) _G.RagdollBypass = v end)
    toggleRow(ScrollFlash, "Auto Giant", _G.AutoGiant, function(v) _G.AutoGiant = v end)
    toggleRow(ScrollFlash, "Lagger on Flash TP", _G.LaggerOnFlash, function(v)
        _G.LaggerOnFlash = v
        if not v then stopFlashLagger() end
        saveSettings()
    end)

    -- LAGGER POWER slider
    do
        sectionOrder += 1
        local lagLblRow = Instance.new("Frame")
        lagLblRow.Size = UDim2.new(0.92, 0, 0, 36)
        lagLblRow.AnchorPoint = Vector2.new(0.5, 0)
        lagLblRow.Position = UDim2.new(0.5, 0, 0, 0)
        lagLblRow.BackgroundTransparency = 1
        lagLblRow.LayoutOrder = sectionOrder
        lagLblRow.Parent = ScrollFlash
        local lagTitleLbl = Instance.new("TextLabel", lagLblRow)
        lagTitleLbl.Size = UDim2.new(1, 0, 0, 13)
        lagTitleLbl.BackgroundTransparency = 1
        lagTitleLbl.Text = "LAGGER POWER"
        lagTitleLbl.TextColor3 = C.textMute
        lagTitleLbl.Font = Enum.Font.GothamBold
        lagTitleLbl.TextSize = isMob and 9 or 10
        lagTitleLbl.TextXAlignment = Enum.TextXAlignment.Center
        lagTitleLbl.ZIndex = 6
        local lagValLbl = Instance.new("TextLabel", lagLblRow)
        lagValLbl.Size = UDim2.new(1, 0, 0, 13)
        lagValLbl.Position = UDim2.new(0, 0, 0, 12)
        lagValLbl.BackgroundTransparency = 1
        lagValLbl.Text = tostring(math.floor(_G.LaggerPower))
        lagValLbl.TextColor3 = C.accent
        lagValLbl.Font = Enum.Font.GothamBold
        lagValLbl.TextSize = isMob and 9 or 10
        lagValLbl.TextXAlignment = Enum.TextXAlignment.Center
        lagValLbl.ZIndex = 6
        local lagTrack = Instance.new("Frame", lagLblRow)
        lagTrack.Size = UDim2.new(0.92, 0, 0, 6)
        lagTrack.AnchorPoint = Vector2.new(0.5, 0)
        lagTrack.Position = UDim2.new(0.5, 0, 0, 26)
        lagTrack.BackgroundColor3 = C.card
        lagTrack.BackgroundTransparency = 0.3
        lagTrack.BorderSizePixel = 0
        lagTrack.ZIndex = 6
        Instance.new("UICorner", lagTrack).CornerRadius = UDim.new(1, 0)
        local lagFill = Instance.new("Frame", lagTrack)
        lagFill.Size = UDim2.new(_G.LaggerPower / 100, 0, 1, 0)
        lagFill.BackgroundColor3 = C.accent
        lagFill.BorderSizePixel = 0
        lagFill.ZIndex = 7
        Instance.new("UICorner", lagFill).CornerRadius = UDim.new(1, 0)
        local function updateLagger(pct)
            pct = math.clamp(pct, 0, 1)
            _G.LaggerPower = math.floor(pct * 100)
            lagFill.Size = UDim2.new(pct, 0, 1, 0)
            lagValLbl.Text = tostring(_G.LaggerPower)
            saveSettings()
        end
        local dragging = false
        lagTrack.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                updateLagger((inp.Position.X - lagTrack.AbsolutePosition.X) / lagTrack.AbsoluteSize.X)
            end
        end)
        UserInputService.InputChanged:Connect(function(inp)
            if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                updateLagger((inp.Position.X - lagTrack.AbsolutePosition.X) / lagTrack.AbsoluteSize.X)
            end
        end)
        UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    -- FLASH SPEED slider (dinâmico: 0–200 base / 0- 800 com TP V2)
    do
        sectionOrder += 1
        local speedLblRow = Instance.new("Frame")
        speedLblRow.Size = UDim2.new(0.92, 0, 0, 36)
        speedLblRow.AnchorPoint = Vector2.new(0.5, 0)
        speedLblRow.Position = UDim2.new(0.5, 0, 0, 0)
        speedLblRow.BackgroundTransparency = 1
        speedLblRow.LayoutOrder = sectionOrder
        speedLblRow.Parent = ScrollFlash
        local speedTitleLbl = Instance.new("TextLabel", speedLblRow)
        speedTitleLbl.Size = UDim2.new(1, 0, 0, 13)
        speedTitleLbl.BackgroundTransparency = 1
        speedTitleLbl.Text = "FLASH SPEED"
        speedTitleLbl.TextColor3 = C.textMute
        speedTitleLbl.Font = Enum.Font.GothamBold
        speedTitleLbl.TextSize = isMob and 9 or 10
        speedTitleLbl.TextXAlignment = Enum.TextXAlignment.Center
        speedTitleLbl.ZIndex = 6
        local speedValLbl = Instance.new("TextLabel", speedLblRow)
        speedValLbl.Size = UDim2.new(1, 0, 0, 13)
        speedValLbl.Position = UDim2.new(0, 0, 0, 12)
        speedValLbl.BackgroundTransparency = 1
        speedValLbl.Text = tostring(math.floor(_G.FlashSpeed or 150))
        speedValLbl.TextColor3 = C.accent
        speedValLbl.Font = Enum.Font.GothamBold
        speedValLbl.TextSize = isMob and 9 or 10
        speedValLbl.TextXAlignment = Enum.TextXAlignment.Center
        speedValLbl.ZIndex = 6
        local speedTrack = Instance.new("Frame", speedLblRow)
        speedTrack.Size = UDim2.new(0.92, 0, 0, 6)
        speedTrack.AnchorPoint = Vector2.new(0.5, 0)
        speedTrack.Position = UDim2.new(0.5, 0, 0, 26)
        speedTrack.BackgroundColor3 = C.card
        speedTrack.BackgroundTransparency = 0.3
        speedTrack.BorderSizePixel = 0
        speedTrack.ZIndex = 6
        Instance.new("UICorner", speedTrack).CornerRadius = UDim.new(1, 0)
        local speedFill = Instance.new("Frame", speedTrack)
        speedFill.BackgroundColor3 = C.accent
        speedFill.BorderSizePixel = 0
        speedFill.ZIndex = 7
        Instance.new("UICorner", speedFill).CornerRadius = UDim.new(1, 0)

        local function getMaxSpeedLocal()
            return _G.TPV2 and FLASH_SPEED_MAX_TPV2 or FLASH_SPEED_MAX_BASE
        end

        local function refreshSpeedSlider()
            local maxV = getMaxSpeedLocal()
            if _G.FlashSpeed > maxV then _G.FlashSpeed = maxV end
            local pct = math.clamp((_G.FlashSpeed or 150) / maxV, 0, 1)
            speedFill.Size = UDim2.new(pct, 0, 1, 0)
            speedValLbl.Text = tostring(math.floor(_G.FlashSpeed or 150)) .. " / " .. maxV
        end
        _refreshSpeedSlider = refreshSpeedSlider
        refreshSpeedSlider()

        local function updateSpeed(pct)
            pct = math.clamp(pct, 0, 1)
            local maxV = getMaxSpeedLocal()
            _G.FlashSpeed = math.floor(pct * maxV)
            speedFill.Size = UDim2.new(pct, 0, 1, 0)
            speedValLbl.Text = tostring(_G.FlashSpeed) .. " / " .. maxV
            saveSettings()
        end
        local dragging = false
        speedTrack.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                updateSpeed((inp.Position.X - speedTrack.AbsolutePosition.X) / speedTrack.AbsoluteSize.X)
            end
        end)
        UserInputService.InputChanged:Connect(function(inp)
            if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                updateSpeed((inp.Position.X - speedTrack.AbsolutePosition.X) / speedTrack.AbsoluteSize.X)
            end
        end)
        UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

    end

    -- BYPASS PROTECT V1 (integrado diretamente na aba FLASH)
    sectionHeader(ScrollFlash, "  BYPASS PROTECT V1  ")
    toggleRow(ScrollFlash, "Active Block", _G.BypassProtectV1, function(enabled)
        BypassProtectV1.set(enabled)
        saveSettings()
    end)
    toggleRow(ScrollFlash, "Block", _G.BypassV1BlockEnabled, function(enabled)
        _G.BypassV1BlockEnabled = enabled
        saveSettings()
    end)
    toggleRow(ScrollFlash, "Grab", _G.BypassV1GrabEnabled, function(enabled)
        _G.BypassV1GrabEnabled = enabled
        saveSettings()
    end)
    do
        local function bypassV1AdjustRow(title, getter, setter, minValue, maxValue, step, formatter)
            sectionOrder += 1
            local row = Instance.new("Frame")
            row.Size = UDim2.new(0.92, 0, 0, 32)
            row.AnchorPoint = Vector2.new(0.5, 0)
            row.BackgroundColor3 = C.card
            row.BackgroundTransparency = 0.6
            row.BorderSizePixel = 0
            row.LayoutOrder = sectionOrder
            row.Parent = ScrollFlash
            row.ZIndex = 4
            Instance.new("UICorner", row).CornerRadius = UDim.new(1, 0)
            local stroke = Instance.new("UIStroke", row)
            stroke.Color = C.strokeDim
            stroke.Transparency = 0.35

            local label = Instance.new("TextLabel", row)
            label.Size = UDim2.new(1, -112, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = title
            label.TextColor3 = C.textBright
            label.TextSize = 11
            label.Font = Enum.Font.GothamMedium
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextYAlignment = Enum.TextYAlignment.Center
            label.TextTruncate = Enum.TextTruncate.AtEnd

            local value = Instance.new("TextLabel", row)
            value.Size = UDim2.new(0, 52, 1, 0)
            value.Position = UDim2.new(1, -82, 0, 0)
            value.BackgroundTransparency = 1
            value.TextColor3 = C.accent
            value.TextSize = 11
            value.Font = Enum.Font.GothamBold
            value.TextXAlignment = Enum.TextXAlignment.Center
            value.TextYAlignment = Enum.TextYAlignment.Center
            value.TextTruncate = Enum.TextTruncate.AtEnd

            local function refresh()
                value.Text = formatter(getter())
            end
            local function change(delta)
                local nextValue = math.clamp((tonumber(getter()) or minValue) + delta, minValue, maxValue)
                nextValue = math.floor(nextValue / step + 0.5) * step
                setter(nextValue)
                refresh()
                saveSettings()
            end
            local function button(text, x, callback)
                local btn = Instance.new("TextButton", row)
                btn.Size = UDim2.new(0, 24, 0, 24)
                btn.Position = UDim2.new(1, x, 0.5, -12)
                btn.BackgroundColor3 = C.iconBg
                btn.BorderSizePixel = 0
                btn.Text = text
                btn.TextColor3 = C.textBright
                btn.TextSize = 14
                btn.Font = Enum.Font.GothamBold
                btn.AutoButtonColor = false
                Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
                btn.MouseButton1Click:Connect(callback)
            end
            button("−", -108, function() change(-step) end)
            button("+", -28, function() change(step) end)
            refresh()
        end

        bypassV1AdjustRow("Block Delay", function() return _G.BypassV1BlockDelay end,
            function(v) _G.BypassV1BlockDelay = v end, 0, 4, 0.01,
            function(v) return string.format("%.2fs", v) end)
        bypassV1AdjustRow("Block Radius", function() return _G.BypassV1BlockRadius end,
            function(v) _G.BypassV1BlockRadius = v end, 1, 50, 1,
            function(v) return string.format("%.0f", v) end)
    end

    sectionHeader(ScrollBlock, "  BLOCK  ")
    toggleRow(ScrollBlock, "Auto Block", _G.AutoBlock, function(v) _G.AutoBlock = v end)

    do
        local modes = {
            {key="normal", label="NORMAL"},
            {key="fast", label="FAST"},
            {key="veryfast", label="VERY FAST"},
        }
        local modeButtons = {}
        local function refreshModeButtons()
            for _, info in ipairs(modes) do
                local btn = modeButtons[info.key]
                if not btn then continue end
                local active = (_G.BlockMode == info.key)
                TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundTransparency = active and 0.2 or 0.7 }):Play()
                local bs = btn:FindFirstChildOfClass("UIStroke")
                if bs then
                    TweenService:Create(bs, TweenInfo.new(0.12), {
                        Color = active and C.accent or C.strokeDim,
                        Transparency = active and 0 or 0.35,
                    }):Play()
                end
                local lbl2 = btn:FindFirstChildOfClass("TextLabel")
                if lbl2 then lbl2.TextColor3 = active and C.accent or C.textMute end
            end
        end
        for i, info in ipairs(modes) do
            sectionOrder += 1
            local mbtn = Instance.new("TextButton")
            mbtn.Size = UDim2.new(0.92, 0, 0, 26)
            mbtn.AnchorPoint = Vector2.new(0.5, 0)
            mbtn.Position = UDim2.new(0.5, 0, 0, 0)
            mbtn.BackgroundColor3 = C.card
            mbtn.BackgroundTransparency = 0.6
            mbtn.BorderSizePixel = 0
            mbtn.ZIndex = 6
            mbtn.Text = ""
            mbtn.AutoButtonColor = false
            mbtn.LayoutOrder = sectionOrder
            mbtn.Parent = ScrollBlock
            Instance.new("UICorner", mbtn).CornerRadius = UDim.new(1, 0)
            local mbs = Instance.new("UIStroke", mbtn); mbs.Color = C.strokeDim; mbs.Thickness = 1; mbs.Transparency = 0.35
            local mlbl = Instance.new("TextLabel", mbtn)
            mlbl.Size = UDim2.new(1, -8, 1, 0)
            mlbl.BackgroundTransparency = 1
            mlbl.ZIndex = 7
            mlbl.Text = info.label
            mlbl.TextColor3 = C.textMute
            mlbl.TextSize = isMob and 11 or 12
            mlbl.Font = Enum.Font.GothamBold
            mlbl.TextXAlignment = Enum.TextXAlignment.Center
            mlbl.TextYAlignment = Enum.TextYAlignment.Center
            modeButtons[info.key] = mbtn
            mbtn.MouseButton1Click:Connect(function()
                _G.BlockMode = info.key
                saveSettings()
                refreshModeButtons()
            end)
        end
        refreshModeButtons()
    end

    sectionHeader(ScrollMisc, "  MISC  ")

    toggleRow(ScrollMisc, "Anti Ragdoll", _G.AntiRagdoll, function(v)
        _G.AntiRagdoll = v == true
        if _G.AntiRagdoll then startAntiRagdoll() else stopAntiRagdoll() end
        saveSettings()
    end)
    toggleRow(ScrollMisc, "Quick Admin Panel", _G.QuickAP, function(v)
        _G.QuickAP = v
        if qapPanel then qapPanel.Visible = v end
        saveSettings()
    end)
    toggleRow(ScrollMisc, "Quick Pickup", _G.QuickPickup, function(v)
        _G.QuickPickup = v
        QuickPickup.set(v)
        if not v then QuickPickup.set(false) end
        saveSettings()
    end)
    toggleRow(ScrollMisc, "Auto Balloon", _G.AutoBalloonEnabled, function(v)
        _G.AutoBalloonEnabled=v
        if _G.AutoBalloon then _G.AutoBalloon.set(v) end
        saveSettings()
    end)
    dropdownRow(ScrollMisc, "Walk Item", WalkItemOptions, _G.WalkItem, function(choice) _G.WalkItem = choice end)
    toggleRow(ScrollMisc, "Aimbot", _G.AimbotEnabled or false, function(v) _G.ToggleAimbot(v) end)
    toggleRow(ScrollMisc, "Allow/Disallow", _G.AllowDisallowEnabled, function(v)
        _G.AllowDisallowEnabled = v
        if allowPanel then allowPanel.Visible = v end
        saveSettings()
    end)
    toggleRow(ScrollMisc, "Auto Carpet Speed", _G.AutoCarpetSpeed or false, function(v)
        _G.AutoCarpetSpeed = v
        if v then hhStartAutoCarpet() else hhStopAutoCarpet() end
        saveSettings()
    end)
    toggleRow(ScrollMisc, "Anti Die", _G.AntiDie or false, function(v)
        _G.AntiDie = v
        if v then startAntiDie() else stopAntiDie() end
        saveSettings()
    end)
    toggleRow(ScrollMisc, "Infinite Jump", _G.InfiniteJumpEnabled, function(v)
        _G.InfiniteJumpEnabled = v
        if _G.InfiniteJump and _G.InfiniteJump.set then
            _G.InfiniteJump.set(v)
        end
        saveSettings()
    end)
    toggleRow(ScrollMisc, "Anti Turret", _G.AutoTurretEnabled, function(v)
        _G.AutoTurretEnabled = v
        if _G.AutoTurret and _G.AutoTurret.set then
            _G.AutoTurret.set(v)
        end
        saveSettings()
    end)
    toggleRow(ScrollMisc, "Anti Gummy", _G.GummyBypassEnabled, function(v)
        _G.GummyBypassEnabled = v
        if _G.GummyBypass and _G.GummyBypass.set then
            _G.GummyBypass.set(v)
        end
        saveSettings()
    end)
    toggleRow(ScrollMisc, "Anti AP", _G.AntiAdminEnabled, function(v)
        _G.AntiAdminEnabled = v
        if _G.AntiAdmin and _G.AntiAdmin.set then
            _G.AntiAdmin.set(v)
        end
        saveSettings()
    end)

    toggleRow(ScrollMisc, "Auto Return Base", _G.AutoReturnBase, function(v)
        _G.AutoReturnBase = v
        if not v and _G._HighStopReturnBase then pcall(_G._HighStopReturnBase) end
        saveSettings()
    end)

    toggleRow(ScrollMisc, "Hide Admin Panel", _G.HideAdminPanel, function(v)
        setHideAdminPanel(v)
        saveSettings()
    end)


    sectionHeader(ScrollMisc, "  FONTS  ")
    do
        sectionOrder += 1
        local fontRow = Instance.new("Frame")
        fontRow.Size = UDim2.new(0.92, 0, 0, 42)
        fontRow.AnchorPoint = Vector2.new(0.5, 0)
        fontRow.BackgroundColor3 = C.card
        fontRow.BackgroundTransparency = 0.35
        fontRow.BorderSizePixel = 0
        fontRow.LayoutOrder = sectionOrder
        fontRow.Parent = ScrollMisc
        fontRow.ZIndex = 6
        Instance.new("UICorner", fontRow).CornerRadius = UDim.new(0, 8)
        local fontStroke = Instance.new("UIStroke", fontRow)
        fontStroke.Color = C.strokeDim
        fontStroke.Transparency = 0.2

        local fontLabel = Instance.new("TextLabel", fontRow)
        fontLabel.Size = UDim2.new(1, -150, 1, 0)
        fontLabel.Position = UDim2.new(0, 12, 0, 0)
        fontLabel.BackgroundTransparency = 1
        fontLabel.Text = "Fonts"
        fontLabel.TextColor3 = C.textBright
        fontLabel.TextSize = 12
        fontLabel.Font = Enum.Font.GothamMedium
        fontLabel.TextXAlignment = Enum.TextXAlignment.Left
        fontLabel.ZIndex = 7

        local fontButton = Instance.new("TextButton", fontRow)
        fontButton.Size = UDim2.new(0, 126, 0, 26)
        fontButton.Position = UDim2.new(1, -136, 0.5, -13)
        fontButton.BackgroundColor3 = C.iconBg
        fontButton.BorderSizePixel = 0
        fontButton.AutoButtonColor = false
        fontButton.TextSize = 10
        fontButton.Font = Enum.Font.GothamBold
        fontButton.TextColor3 = C.textBright
        fontButton.Text = _G.SelectedFont
        fontButton.ZIndex = 8
        Instance.new("UICorner", fontButton).CornerRadius = UDim.new(0, 6)
        local fontButtonStroke = Instance.new("UIStroke", fontButton)
        fontButtonStroke.Color = C.accent
        fontButtonStroke.Transparency = 0.2

        sectionOrder += 1
        local fontList = Instance.new("Frame")
        fontList.Size = UDim2.new(0.92, 0, 0, 0)
        fontList.AnchorPoint = Vector2.new(0.5, 0)
        fontList.BackgroundColor3 = C.card
        fontList.BackgroundTransparency = 0.4
        fontList.BorderSizePixel = 0
        fontList.LayoutOrder = sectionOrder
        fontList.Visible = false
        fontList.ClipsDescendants = true
        fontList.Parent = ScrollMisc
        fontList.ZIndex = 5
        Instance.new("UICorner", fontList).CornerRadius = UDim.new(0, 8)
        local fontListStroke = Instance.new("UIStroke", fontList)
        fontListStroke.Color = C.strokeDim
        fontListStroke.Transparency = 0.35
        local fontLayout = Instance.new("UIListLayout", fontList)
        fontLayout.Padding = UDim.new(0, 3)
        fontLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        local fontPadding = Instance.new("UIPadding", fontList)
        fontPadding.PaddingTop = UDim.new(0, 5)
        fontPadding.PaddingBottom = UDim.new(0, 5)

        local expanded = false
        local fontButtons = {}
        local function refreshFontUI()
            fontButton.Text = FontSelector.getName()
            for name, button in pairs(fontButtons) do
                button.BackgroundColor3 = (name == FontSelector.getName()) and C.accent or C.iconBg
                button.TextColor3 = (name == FontSelector.getName()) and C.textBright or C.textMute
            end
        end
        local function setFontListVisible(on)
            expanded = on == true
            fontList.Visible = expanded
            fontList.Size = expanded and UDim2.new(0.92, 0, 0, 10 + (#FontSelector.fonts * 29)) or UDim2.new(0.92, 0, 0, 0)
        end
        fontButton.MouseButton1Click:Connect(function()
            setFontListVisible(not expanded)
        end)
        for i, item in ipairs(FontSelector.fonts) do
            local button = Instance.new("TextButton", fontList)
            button.Size = UDim2.new(0.92, 0, 0, 26)
            button.BackgroundColor3 = C.iconBg
            button.BackgroundTransparency = 0.15
            button.BorderSizePixel = 0
            button.AutoButtonColor = false
            button.Text = item.name
            button.TextSize = 11
            button.Font = item.enum
            button.TextColor3 = C.textBright
            button.LayoutOrder = i
            button.ZIndex = 7
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
            fontButtons[item.name] = button
            button.MouseButton1Click:Connect(function()
                _G.SelectedFont = item.name
                FontSelector.set(item.name, HIGH_HUB_GUI)
                refreshFontUI()
                setFontListVisible(false)
                saveSettings()
            end)
        end
        FontSelector.set(_G.SelectedFont, HIGH_HUB_GUI)
        refreshFontUI()
    end

    sectionHeader(ScrollVisual, "  ESP  ")
    toggleRow(ScrollVisual, "Esp Player", _G.PlayerESP, function(v)
        _G.PlayerESP = v
        if not v then clearPlayerESP() end
        saveSettings()
    end)
    toggleRow(ScrollVisual, "Esp Your Reflection", _G.PlayerESPShadow, function(v)
        _G.PlayerESPShadow = v
        if _G.ESPPlayerShadow and _G.ESPPlayerShadow.set then _G.ESPPlayerShadow.set(v) end
        saveSettings()
    end)
    toggleRow(ScrollVisual, "Esp Best Brainrot", _G.EspBestBrainrot, function(v)
        _G.EspBestBrainrot = v
        if _G.EspBestBrainrotController and _G.EspBestBrainrotController.set then
            _G.EspBestBrainrotController.set(v)
        end
        saveSettings()
    end)
    toggleRow(ScrollVisual, "Esp Time", _G.EspTimer, function(v)
        _G.EspTimer = v
        if not v then clearBaseESP() end
        saveSettings()
    end)
    toggleRow(ScrollVisual, "Clone ESP", _G.CloneESPEnabled, function(v)
        _G.CloneESPEnabled = v
        if _G.CloneESP and _G.CloneESP.set then
            _G.CloneESP.set(v)
        end
        saveSettings()
    end)
    toggleRow(ScrollVisual, "Allow/Disallow ESP", _G.AllowDisallowESPEnabled, function(v)
        _G.AllowDisallowESPEnabled = v
        if _G.AllowDisallowESP and _G.AllowDisallowESP.set then
            _G.AllowDisallowESP.set(v)
        end
        saveSettings()
    end)
    toggleRow(ScrollVisual, "Mine ESP", _G.MineESPEnabled, function(v)
        setMineESP(v)
        saveSettings()
    end)

    sectionHeader(ScrollVisual, "  BACKPACK ESP  ")
    do
        local mainRow, mainRef = toggleRow(ScrollVisual, "Backpack ESP", _G.BackpackESP, function(v)
            _G.BackpackESP = v
            if not v then clearBackpackESP() clearAPESP() end
        end)
        local gearBtn = Instance.new("TextButton")
        gearBtn.Size = UDim2.new(0, 22, 0, 22)
        gearBtn.Position = UDim2.new(1, -68, 0.5, -11)
        gearBtn.BackgroundColor3 = C.iconBg
        gearBtn.BorderSizePixel = 0
        gearBtn.ZIndex = 9
        gearBtn.Text = "⚙️"
        gearBtn.TextColor3 = C.textMute
        gearBtn.TextSize = 13
        gearBtn.Font = Enum.Font.GothamBold
        gearBtn.AutoButtonColor = false
        gearBtn.Parent = mainRow
        Instance.new("UICorner", gearBtn).CornerRadius = UDim.new(1, 0)

        sectionOrder += 1
        local subPanel = Instance.new("Frame")
        subPanel.Size = UDim2.new(0.92, 0, 0, 0)
        subPanel.AnchorPoint = Vector2.new(0.5, 0)
        subPanel.Position = UDim2.new(0.5, 0, 0, 0)
        subPanel.BackgroundColor3 = C.card
        subPanel.BackgroundTransparency = 0.4
        subPanel.BorderSizePixel = 0
        subPanel.ZIndex = 4
        subPanel.LayoutOrder = sectionOrder
        subPanel.ClipsDescendants = true
        subPanel.Visible = false
        subPanel.Parent = ScrollVisual
        Instance.new("UICorner", subPanel).CornerRadius = UDim.new(0, 10)
        local ss = Instance.new("UIStroke", subPanel); ss.Color = C.strokeDim; ss.Thickness = 1; ss.Transparency = 0.5
        local subLayout = Instance.new("UIListLayout", subPanel)
        subLayout.FillDirection = Enum.FillDirection.Vertical
        subLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        subLayout.Padding = UDim.new(0, 4)
        local subPad = Instance.new("UIPadding", subPanel)
        subPad.PaddingTop = UDim.new(0, 6)
        subPad.PaddingBottom = UDim.new(0, 6)
        local ITEM_H_SUB = 26
        local function makeCheckRow(label, stateKey)
            local row = Instance.new("Frame", subPanel)
            row.Size = UDim2.new(0.9, 0, 0, ITEM_H_SUB)
            row.BackgroundTransparency = 1
            local lbl = Instance.new("TextLabel", row)
            lbl.Size = UDim2.new(1, -34, 1, 0)
            lbl.Position = UDim2.new(0, 8, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = label
            lbl.TextColor3 = C.textBright
            lbl.TextSize = 11
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            local state = _G[stateKey] ~= false
            local box = Instance.new("TextButton", row)
            box.Size = UDim2.new(0, 18, 0, 18)
            box.Position = UDim2.new(1, -22, 0.5, -9)
            box.BackgroundColor3 = state and C.accent or C.trackOff
            box.BorderSizePixel = 0
            box.ZIndex = 6
            box.Text = state and "✓" or ""
            box.TextColor3 = C.body
            box.TextSize = 11
            box.Font = Enum.Font.GothamBold
            box.AutoButtonColor = false
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
            box.MouseButton1Click:Connect(function()
                state = not state
                _G[stateKey] = state
                box.BackgroundColor3 = state and C.accent or C.trackOff
                box.Text = state and "✓" or ""
                if not state then
                    if stateKey == "ShowAPESP" then clearAPESP()
                    elseif stateKey == "ShowGiantPotion" or stateKey == "ShowFlashTeleport" or stateKey == "ShowFlyingCarpet" then
                        clearBackpackESP()
                    end
                end
                saveSettings()
            end)
        end
        makeCheckRow("Admin Panel", "ShowAPESP")
        makeCheckRow("Giant Potion", "ShowGiantPotion")
        makeCheckRow("Flash Teleport", "ShowFlashTeleport")
        makeCheckRow("Flying Carpet", "ShowFlyingCarpet")

        local function refreshSubSize()
            local count = 0
            for _, c in ipairs(subPanel:GetChildren()) do
                if c:IsA("Frame") then count += 1 end
            end
            subPanel.Size = UDim2.new(0.92, 0, 0, count * (ITEM_H_SUB + 4) + 16)
        end
        refreshSubSize()

        local subOpen = false
        gearBtn.MouseButton1Click:Connect(function()
            subOpen = not subOpen
            subPanel.Visible = subOpen
            gearBtn.TextColor3 = subOpen and C.accent or C.textMute
        end)
    end

    -- BUTTON HOOKS
    local function hookButton(btn)
        local stroke = btn:FindFirstChildOfClass("UIStroke")
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundTransparency = 0.3 }):Play()
            if stroke then TweenService:Create(stroke, TweenInfo.new(0.12), { Color = C.accent, Transparency = 0 }):Play() end
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundTransparency = 0.6 }):Play()
            if stroke then TweenService:Create(stroke, TweenInfo.new(0.12), { Color = C.strokeDim, Transparency = 0.35 }):Play() end
        end)
    end
    hookButton(FLASHTP)
    hookButton(BLOCK)
    hookButton(RESET)

    local function flashBar(bar)
        bar.BackgroundColor3 = C.accentHi
        TweenService:Create(bar, TweenInfo.new(0.4), { BackgroundColor3 = C.stroke }):Play()
    end

    FLASHTP.MouseButton1Click:Connect(function()
        if not selectedPrompt or not selectedSlotNumber then
            selectedPrompt, selectedSlotNumber = findFirstAvailableStealPrompt()
        end
        if selectedPrompt and selectedSlotNumber then
            if not isStealing and not autoStealEnabled then
                flashBar(flashAccent)
                startFlashTeleportTimer()
                startTripToPetSlot(selectedPrompt, selectedSlotNumber)
            end
        end
    end)
    BLOCK.MouseButton1Click:Connect(function()
        flashBar(blockAccent)
        local target = getNearestPlayer()
        if target then blockPlayer(target) end
    end)
    RESET.MouseButton1Click:Connect(function()
        flashBar(resetAccent)
        ResetPlayer()
    end)

    task.spawn(function()
        while task.wait(1.5) do
            if thisScriptStopped then break end
            updatePetList()
        end
    end)
    updatePetList()

    table.insert(ActiveConnections, LocalPlayer.CharacterAdded:Connect(function(newChar)
        _resetWasByBalloon = false
    end))

    local keybinds = {
        flash = Enum.KeyCode.F,
        block = Enum.KeyCode.B,
        reset = Enum.KeyCode.R,
        allow = Enum.KeyCode.A,
    }
    local listeningAction = nil
    local justBound = false
    local keybindDisplayButtons = {}
    local beginKeybindCapture
    table.insert(ActiveConnections, UserInputService.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if listeningAction then return end
        if justBound then return end
        if inp.KeyCode == keybinds.flash then
            if not selectedPrompt or not selectedSlotNumber then
                selectedPrompt, selectedSlotNumber = findFirstAvailableStealPrompt()
            end
            if selectedPrompt and selectedSlotNumber and not isStealing and not autoStealEnabled then
                startFlashTeleportTimer()
                startTripToPetSlot(selectedPrompt, selectedSlotNumber)
            end
        elseif inp.KeyCode == keybinds.block then
            local target = getNearestPlayer()
            if target then blockPlayer(target) end
        elseif inp.KeyCode == keybinds.reset then
            ResetPlayer()
        elseif inp.KeyCode == keybinds.allow then
            toggleAllow()
        end
    end))

    local keyNames = { flash = "F", block = "B", reset = "R", allow = "A" }
    local KB_FILE = "high_keybinds.json"
    local function saveKeybinds()
        pcall(function()
            writefile(KB_FILE, HttpService:JSONEncode({
                flash = keyNames.flash,
                block = keyNames.block,
                reset = keyNames.reset,
                allow = keyNames.allow,
            }))
        end)
    end
    local function loadKeybinds()
        local ok, data = pcall(function()
            return HttpService:JSONDecode(readfile(KB_FILE))
        end)
        if ok and type(data) == "table" then
            for _, action in ipairs({"flash", "block", "reset", "allow"}) do
                if data[action] then
                    local ok2, kc = pcall(function() return Enum.KeyCode[data[action]] end)
                    if ok2 and kc then
                        keybinds[action] = kc
                        keyNames[action] = data[action]
                    end
                end
            end
        end
    end
    loadKeybinds()

    sectionHeader(ScrollKeybinds, "  KEYBIRDS  ")
    local keybindRows = {
        { action = "flash", title = "Flash TP" },
        { action = "block", title = "Block" },
        { action = "reset", title = "Reset" },
        { action = "allow", title = "Allow/Disallow" },
    }
    for _, item in ipairs(keybindRows) do
        sectionOrder += 1
        local row = Instance.new("Frame")
        row.Size = UDim2.new(0.92, 0, 0, 34)
        row.AnchorPoint = Vector2.new(0.5, 0)
        row.Position = UDim2.new(0.5, 0, 0, 0)
        row.BackgroundColor3 = C.card
        row.BackgroundTransparency = 0.6
        row.BorderSizePixel = 0
        row.LayoutOrder = sectionOrder
        row.Parent = ScrollKeybinds
        Instance.new("UICorner", row).CornerRadius = UDim.new(1, 0)
        local rowStroke = Instance.new("UIStroke", row)
        rowStroke.Color = C.strokeDim
        rowStroke.Thickness = 1
        rowStroke.Transparency = 0.35

        local nameLabel = Instance.new("TextLabel", row)
        nameLabel.Size = UDim2.new(1, -96, 1, 0)
        nameLabel.Position = UDim2.new(0, 10, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = item.title
        nameLabel.TextColor3 = C.textBright
        nameLabel.TextSize = 12
        nameLabel.Font = Enum.Font.GothamMedium
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left

        local keyButton = Instance.new("TextButton", row)
        keyButton.Size = UDim2.new(0, 76, 0, 24)
        keyButton.Position = UDim2.new(1, -84, 0.5, -12)
        keyButton.BackgroundColor3 = C.iconBg
        keyButton.BorderSizePixel = 0
        keyButton.Text = keyNames[item.action] or keybinds[item.action].Name
        keyButton.TextColor3 = C.textBright
        keyButton.TextSize = 11
        keyButton.Font = Enum.Font.GothamBold
        keyButton.AutoButtonColor = false
        keyButton.ZIndex = 6
        Instance.new("UICorner", keyButton).CornerRadius = UDim.new(0, 6)
        local keyStroke = Instance.new("UIStroke", keyButton)
        keyStroke.Color = C.accent
        keyStroke.Transparency = 0.25
        keybindDisplayButtons[item.action] = keyButton
        keyButton.MouseButton1Click:Connect(function()
            if beginKeybindCapture then
                beginKeybindCapture(item.action, keyButton, keyNames[item.action])
            end
        end)
    end

    beginKeybindCapture = function(actionName, displayButton, idleText)
        if listeningAction then return end
        listeningAction = actionName
        local originalText = idleText
        if displayButton then
            displayButton.Text = "Click For New Keybird..."
            displayButton.TextSize = 10
            displayButton.TextColor3 = C.accent
        end
        local conn
        conn = UserInputService.InputBegan:Connect(function(inp2, gpe)
            if gpe or inp2.UserInputType ~= Enum.UserInputType.Keyboard then return end
            if inp2.KeyCode == Enum.KeyCode.Unknown then return end
            conn:Disconnect()
            justBound = true
            listeningAction = nil
            task.defer(function() justBound = false end)
            keybinds[actionName] = inp2.KeyCode
            keyNames[actionName] = inp2.KeyCode.Name
            saveKeybinds()
            if displayButton then
                displayButton.Text = actionName == "flash" and "Flash TP"
                    or actionName == "block" and "BLOCK"
                    or actionName == "reset" and "RESET"
                    or actionName == "allow" and keyNames.allow
                    or originalText
                displayButton.TextSize = actionName == "allow" and 11 or (isMob and 9 or 11)
                displayButton.TextColor3 = C.textBright
            end
            local pageButton = keybindDisplayButtons[actionName]
            if pageButton and pageButton.Parent then
                pageButton.Text = keyNames[actionName]
                pageButton.TextColor3 = C.textBright
            end
        end)
    end

    local function attachKeybindRightClick(btn, actionName, labelPrefix)
        btn.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton2 then
                beginKeybindCapture(actionName, btn:FindFirstChildOfClass("TextLabel"), labelPrefix)
            end
        end)
    end
    attachKeybindRightClick(FLASHTP, "flash", "Flash TP")
    attachKeybindRightClick(BLOCK, "block", "BLOCK")
    attachKeybindRightClick(RESET, "reset", "RESET")

    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

    do
        local actionGradients = {}
        local function applyTitleStyle(btn)
            if not btn then return end
            local lbl = btn:FindFirstChildOfClass("TextLabel")
            if not lbl then return end
            lbl.TextColor3 = C.textBright
            local g = lbl:FindFirstChildOfClass("UIGradient")
            if not g then
                g = Instance.new("UIGradient")
                g.Parent = lbl
            end
            g.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, C.textBright),
                ColorSequenceKeypoint.new(.5, C.textMauve),
                ColorSequenceKeypoint.new(1, C.textBright)
            })
            table.insert(actionGradients, g)
        end
        applyTitleStyle(FLASHTP)
        applyTitleStyle(BLOCK)
        applyTitleStyle(RESET)
        table.insert(ActiveConnections, RunService.Heartbeat:Connect(function()
            local rot = (tick()*100)%360
            for _, g in ipairs(actionGradients) do
                if g and g.Parent then g.Rotation = rot end
            end
        end))
    end
    -- Reaplica a fonte depois de criar todas as abas e controles.
    FontSelector.set(_G.SelectedFont, HIGH_HUB_GUI)

    -- A GUI permanece visível; somente o botão do cadeado fica sem fundo e sem borda.
end

BuildHUB()
-- FPS + PING OVERLAY (drag / F8 hide-show)
local destroyCharacterDiscordBillboard = function() end

do
    local BannerC = {
        body = Color3.fromRGB(18, 8, 10),
        stroke = Color3.fromRGB(235, 50, 60),
        textBright = Color3.fromRGB(255, 240, 242),
        accent = Color3.fromRGB(235, 50, 60),
    }
    local function destroyOldBanner(parent)
        if not parent then return end
        for _, child in ipairs(parent:GetChildren()) do
            if child.Name == "HighBanner" or (child.Name == "67" and child:GetAttribute("HighBanner")) then
                child:Destroy()
            end
        end
    end
    if HIDDEN_GUI then
        destroyOldBanner(HIDDEN_GUI)
    end
    local guiParent = getGuiParent()
    if guiParent then
        local gui = Instance.new("ScreenGui")
        gui.Name = "67"
        gui:SetAttribute("HighBanner", true)
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.Enabled = true
        gui.DisplayOrder = 100
        gui.Parent = guiParent
        local root = Instance.new("Frame")
        root.Name = "Root"
        root.Position = UDim2.fromOffset(58, 38)
        root.Size = UDim2.fromOffset(252, 32)
        root.BackgroundColor3 = BannerC.body
        root.BackgroundTransparency = 0.38
        root.BorderSizePixel = 0
        root.Active = true
        root.Parent = gui
        Instance.new("UICorner", root).CornerRadius = UDim.new(0, 10)
        local logo = Instance.new("TextLabel", gui)
        logo.Name = "ReezLogo"
        logo.BackgroundColor3 = Color3.fromRGB(8, 0, 0)
        logo.BackgroundTransparency = 0.28
        logo.Position = UDim2.fromOffset(16, 39)
        logo.Size = UDim2.fromOffset(36, 32)
        logo.BorderSizePixel = 0
        Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 11)
        logo.Font = Enum.Font.GothamBold
        logo.Text = "R"
        -- Cor do R igual às demais (branco/vermelho claro)
        logo.TextColor3 = Color3.fromRGB(255, 35, 50)
        logo.TextSize = 22
        local brand = Instance.new("TextLabel", root)
        brand.Name = "BrandName"
        brand.BackgroundTransparency = 1
        brand.Position = UDim2.fromOffset(5, 1)
        brand.Size = UDim2.fromOffset(50, 17)
        brand.Font = Enum.Font.GothamBold
        brand.Text = "Reez"
        brand.TextColor3 = BannerC.textBright
        brand.TextSize = 14
        brand.TextXAlignment = Enum.TextXAlignment.Left
        local version = Instance.new("TextLabel", root)
        version.Name = "Version"
        version.BackgroundTransparency = 1
        version.Position = UDim2.fromOffset(6, 17)
        version.Size = UDim2.fromOffset(55, 12)
        version.Font = Enum.Font.GothamMedium
        version.Text = "v1.0.2"
        version.TextColor3 = Color3.fromRGB(190, 160, 164)
        version.TextSize = 9
        version.TextXAlignment = Enum.TextXAlignment.Left
        local info = Instance.new("TextLabel", root)
        info.Name = "FpsText"
        info.BackgroundTransparency = 1
        info.Position = UDim2.fromOffset(85, 0)
        info.Size = UDim2.fromOffset(50, 32)
        info.Font = Enum.Font.GothamSemibold
        info.Text = "0 FPS"
        info.TextColor3 = BannerC.textBright
        info.TextSize = 13
        info.TextXAlignment = Enum.TextXAlignment.Left
        do
            local p = Instance.new("TextLabel", root)
            p.Name = "PingText"
            p.BackgroundTransparency = 1
            p.Position = UDim2.fromOffset(191, 0)
            p.Size = UDim2.fromOffset(52, 32)
            p.Font = Enum.Font.GothamSemibold
            p.Text = "0 ms"
            p.TextColor3 = BannerC.textBright
            p.TextSize = 13
            p.TextXAlignment = Enum.TextXAlignment.Left
        end
        -- Ícones desenhados a partir do AuroraHub: monitor para FPS e barras para dados móveis/ping.
        do
            local fIcon = Instance.new("Frame", root)
            fIcon.Name = "ComputerIcon"
            fIcon.Position = UDim2.fromOffset(65, 9)
            fIcon.Size = UDim2.fromOffset(17, 18)
            fIcon.BackgroundTransparency = 1
            local mon = Instance.new("Frame", fIcon)
            mon.Position = UDim2.fromOffset(1, 1)
            mon.Size = UDim2.fromOffset(14, 9)
            mon.BackgroundTransparency = 1
            local monStroke = Instance.new("UIStroke", mon)
            monStroke.Color = Color3.fromRGB(255, 0, 0)
            monStroke.Thickness = 1.4
            monStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            Instance.new("UICorner", mon).CornerRadius = UDim.new(0, 1)
            local monBase = Instance.new("Frame", fIcon)
            monBase.Position = UDim2.fromOffset(5, 12)
            monBase.Size = UDim2.fromOffset(7, 1)
            monBase.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            monBase.BorderSizePixel = 0
            local monStem = Instance.new("Frame", fIcon)
            monStem.Position = UDim2.fromOffset(8, 10)
            monStem.Size = UDim2.fromOffset(1, 4)
            monStem.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            monStem.BorderSizePixel = 0
            local pIcon = Instance.new("Frame", root)
            pIcon.Name = "MobileDataIcon"
            pIcon.Position = UDim2.fromOffset(168, 6)
            pIcon.Size = UDim2.fromOffset(20, 20)
            pIcon.BackgroundTransparency = 1
            -- Barras de sinal alinhadas pela base e centralizadas no espaço do ícone.
            for _, bar in ipairs({ { 3, 4 }, { 8, 9 }, { 13, 14 } }) do
                local f = Instance.new("Frame", pIcon)
                f.Position = UDim2.fromOffset(bar[1], 18 - bar[2])
                f.Size = UDim2.fromOffset(3, bar[2])
                f.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                f.BorderSizePixel = 0
                Instance.new("UICorner", f).CornerRadius = UDim.new(0, 1)
            end
        end
        do
            -- Mesma implementação da borda da GUI Actions: UIStroke + UIGradient rotacionado.
            local function addActionsBorder(target, thickness)
                local panelStroke = Instance.new("UIStroke", target)
                panelStroke.Thickness = thickness or 1.6
                panelStroke.Color = Color3.new(1, 1, 1)
                panelStroke.Transparency = 0
                panelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                panelStroke.LineJoinMode = Enum.LineJoinMode.Round
                local panelStrokeGradient = Instance.new("UIGradient", panelStroke)
                panelStrokeGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                    ColorSequenceKeypoint.new(0.22, Color3.fromRGB(0, 0, 0)),
                    ColorSequenceKeypoint.new(0.38, Color3.fromRGB(235, 40, 52)),
                    ColorSequenceKeypoint.new(0.55, Color3.fromRGB(255, 75, 85)),
                    ColorSequenceKeypoint.new(0.72, Color3.fromRGB(0, 0, 0)),
                    ColorSequenceKeypoint.new(0.86, Color3.fromRGB(0, 0, 0)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 40, 52))
                })
                table.insert(ActiveConnections, RunService.Heartbeat:Connect(function()
                    if panelStrokeGradient and panelStrokeGradient.Parent then
                        panelStrokeGradient.Rotation = (tick() * 70) % 360
                    end
                end))
            end
            addActionsBorder(root, 1.6)
            addActionsBorder(logo, 1.6)
        end
        local bannerGradients = {}
        for _, label in ipairs({brand, version, info, root:FindFirstChild("PingText")}) do
            local gradient = Instance.new("UIGradient")
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, BannerC.textBright),
                ColorSequenceKeypoint.new(0.5, BannerC.accent),
                ColorSequenceKeypoint.new(1, BannerC.textBright),
            })
            gradient.Rotation = 0
            gradient.Parent = label
            table.insert(bannerGradients, gradient)
        end
        table.insert(ActiveConnections, RunService.Heartbeat:Connect(function()
            local rotation = (tick() * 100) % 360
            for _, gradient in ipairs(bannerGradients) do
                if gradient and gradient.Parent then gradient.Rotation = rotation end
            end
        end))
        FontSelector.addRoot(gui)
        local frames, elapsed, fps = 0, 0, 0
        local renderConn = RunService.RenderStepped:Connect(function(dt)
            frames += 1; elapsed += dt
            if elapsed >= 0.5 then fps = math.clamp(math.floor(frames / elapsed + 0.5), 0, 999); frames = 0; elapsed = 0 end
        end)
        task.spawn(function()
            while gui.Parent and not thisScriptStopped do
                local ping = 0
                pcall(function()
                    local n = Stats:FindFirstChild("Network")
                    local ss = n and n:FindFirstChild("ServerStatsItem")
                    local dp = ss and ss:FindFirstChild("Data Ping")
                    if dp then ping = tonumber(string.match(dp:GetValueString(), "%d+%.?%d*")) or 0 else ping = (LocalPlayer:GetNetworkPing() or 0) * 1000 end
                end)
                info.Text = string.format("%d FPS", fps)
                root:FindFirstChild("PingText").Text = string.format("%d ms", math.max(0, math.floor(ping + 0.5)))
                task.wait(0.5)
            end
        end)

        local characterDiscordBillboard
        destroyCharacterDiscordBillboard = function()
            if characterDiscordBillboard then
                pcall(function() characterDiscordBillboard:Destroy() end)
                characterDiscordBillboard = nil
            end
        end

        local function addDiscordAboveCharacter(character)
            destroyCharacterDiscordBillboard()
            if thisScriptStopped or not character or not character.Parent then return end

            local head = character:FindFirstChild("Head")
            if not head then
                head = character:WaitForChild("Head", 5)
            end
            if thisScriptStopped or not head or not head.Parent then return end

            local previous = head:FindFirstChild("HighDiscordAboveCharacter")
            if previous then previous:Destroy() end

            local billboard = Instance.new("BillboardGui")
            billboard.Name = "HighDiscordAboveCharacter"
            billboard.Adornee = head
            billboard.Size = UDim2.fromOffset(220, 24)
            billboard.StudsOffset = Vector3.new(0, 2.6, 0)
            billboard.AlwaysOnTop = true
            billboard.LightInfluence = 0
            billboard.MaxDistance = 1000
            billboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            billboard.Parent = head

            local label = Instance.new("TextLabel")
            label.Name = "Discord"
            label.BackgroundTransparency = 1
            label.Size = UDim2.fromScale(1, 1)
            label.Font = Enum.Font.GothamBold
            label.Text = ""
            label.TextColor3 = BannerC.accent
            label.TextSize = 13
            label.TextStrokeColor3 = Color3.fromRGB(5, 8, 14)
            label.TextStrokeTransparency = 0.35
            label.TextXAlignment = Enum.TextXAlignment.Center
            label.Parent = billboard

            characterDiscordBillboard = billboard
        end

        table.insert(ActiveConnections, LocalPlayer.CharacterAdded:Connect(function(character)
            task.defer(function()
                task.wait(0.15)
                addDiscordAboveCharacter(character)
            end)
        end))
        if LocalPlayer.Character then
            task.defer(addDiscordAboveCharacter, LocalPlayer.Character)
        end

        local dragging, dragStart, startPos = false, nil, nil
        root.InputBegan:Connect(function(input)
            if _G.ReezHubUILocked then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging, dragStart, startPos = true, input.Position, root.Position
                input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if _G.ReezHubUILocked or not dragging then return end
            if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
            local d = input.Position - dragStart
            root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            logo.Position = UDim2.new(root.Position.X.Scale, root.Position.X.Offset - 42, root.Position.Y.Scale, root.Position.Y.Offset + 1)
            uiLayout.FpsPingOverlay = {px=root.Position.X.Offset, py=root.Position.Y.Offset, pw=root.Size.X.Offset, ph=root.Size.Y.Offset}
            saveUILayout()
        end)
        if uiLayout.FpsPingOverlay then
            root.Position = UDim2.fromOffset(
                uiLayout.FpsPingOverlay.px + 42,
                uiLayout.FpsPingOverlay.py
            )
            logo.Position = UDim2.fromOffset(root.Position.X.Offset - 42, root.Position.Y.Offset + 1)
        end
        UserInputService.InputBegan:Connect(function(input, gp) if not gp and input.KeyCode == Enum.KeyCode.F8 then gui.Enabled = not gui.Enabled end end)
        table.insert(ActiveConnections, function() pcall(function() renderConn:Disconnect() end); pcall(function() gui:Destroy() end) end)
    end
end

-- AUTO-ENABLE SAVED TOGGLES
task.defer(function()
    pcall(function()
        if _G.AutoBalloonEnabled and _G.AutoBalloon then _G.AutoBalloon.set(true) end
        if _G.QuickPickup and QuickPickup and QuickPickup.set then QuickPickup.set(true) end
        if _G.AutoCarpetSpeed then hhStartAutoCarpet() end
        if _G.AntiDie then startAntiDie() end
        if _G.AntiRagdoll then startAntiRagdoll() end
        if _G.CloneESPEnabled and _G.CloneESP and _G.CloneESP.set then _G.CloneESP.set(true) end
        if _G.AllowDisallowESPEnabled and _G.AllowDisallowESP and _G.AllowDisallowESP.set then _G.AllowDisallowESP.set(true) end
        if _G.InfiniteJumpEnabled and _G.InfiniteJump and _G.InfiniteJump.set then _G.InfiniteJump.set(true) end
        if _G.AutoTurretEnabled and _G.AutoTurret and _G.AutoTurret.set then _G.AutoTurret.set(true) end
        if _G.GummyBypassEnabled and _G.GummyBypass and _G.GummyBypass.set then _G.GummyBypass.set(true) end
        if _G.AntiAdminEnabled and _G.AntiAdmin and _G.AntiAdmin.set then _G.AntiAdmin.set(true) end
    end)
end)

-- CLEANUP
local function cleanup()
    thisScriptStopped = true
    for _, conn in ipairs(ActiveConnections) do
        pcall(function() conn:Disconnect() end)
    end
    ActiveConnections = {}
    stopFlashLagger()
    if _G._HighStopReturnBase then pcall(_G._HighStopReturnBase) end
    if _G.AutoBalloon then _G.AutoBalloon.set(false) end
    stopAutoResetTiny()
    stopAutoResetJail()
    clearBaseESP()
    clearBackpackESP()
    clearAPESP()
    clearPlayerESP()
    KorbloxLeg.set(false)
    hhStopAutoCarpet()
    stopAntiDie()
    if BypassProtectV1 and BypassProtectV1.set then BypassProtectV1.set(false) end
    if _G.CloneESP and _G.CloneESP.set then _G.CloneESP.set(false) end
    if _G.AllowDisallowESP and _G.AllowDisallowESP.set then _G.AllowDisallowESP.set(false) end
    if _G.GameStretcher and _G.GameStretcher.set then _G.GameStretcher.set(false) end
    if _G.InfiniteJump and _G.InfiniteJump.set then _G.InfiniteJump.set(false) end
    if _G.AutoTurret and _G.AutoTurret.set then _G.AutoTurret.set(false) end
    if _G.GummyBypass and _G.GummyBypass.set then _G.GummyBypass.set(false) end
    if _G.AntiAdmin and _G.AntiAdmin.set then _G.AntiAdmin.set(false) end
    pcall(destroyCharacterDiscordBillboard)
end

game:GetService("ScriptContext"):GetScriptsAddedSignal():Connect(function()
    if thisScriptStopped then return end
    local errorHandler = function(err)
        warn("[67] Error:", err)
        if string.find(err, "Script requires") then
            cleanup()
        end
    end
    xpcall(function() end, errorHandler)
end)