loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();
repeat task.wait() until game:IsLoaded()
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local TextService      = game:GetService("TextService")
local SoundService     = game:GetService("SoundService")
local Lighting         = game:GetService("Lighting")
local HttpService      = game:GetService("HttpService")
local LocalPlayer      = Players.LocalPlayer

_G._VioletteGen = (_G._VioletteGen or 0) + 1
local HUB_GEN = _G._VioletteGen
local function hubStale() return _G._VioletteGen ~= HUB_GEN end
do
    for _, name in ipairs({
        "_VioletteAutoSpeedRuntime", "_VioletteAntiRagdollRuntime", "_VioletteAutoStealRuntime",
        "_VioletteAnimPackRuntime", "_VioletteBatAimbotRuntime",
        "_VioletteDropRuntime", "_VioletteTPDownRuntime", "_VioletteCountersRuntime",
        "_VioletteGuardsRuntime", "_VioletteAutoPathRuntime", "_VioletteVisualRuntime",
        "_VioletteBodyLockRuntime", "_VioletteAvatarESPRuntime", "_VioletteRagdollCDRuntime",
        "_VioletteKickWarningRuntime",
        "_VioletteAutoSaveRuntime", "_VioletteCosmeticsRuntime", "_VioletteSkinGalleryRuntime",
    }) do
        local rt = _G[name]
        if type(rt) == "table" and type(rt.Destroy) == "function" then pcall(rt.Destroy) end
    end
    if _G._VioletteResetPanels then pcall(_G._VioletteResetPanels) end

    local parents = {}
    pcall(function() if type(gethui) == "function" then parents[#parents + 1] = gethui() end end)
    pcall(function() parents[#parents + 1] = game:GetService("CoreGui") end)
    pcall(function() parents[#parents + 1] = LocalPlayer:FindFirstChild("PlayerGui") end)
    local EXACT = {
        KrixHubGUI = true, VioletteLoadIntro = true, VioletteAvatarESP = true,
        ViolettePanel_duelLagger = true, ViolettePanel_pingLagger = true,
        ViolettePanel_speedBypass = true,
        VezyMobileButtons = true, VioletteWordmarkBanner = true,
        KawatanAvatarCatalog = true,
    }
    for _, parent in ipairs(parents) do
        if parent then
            for _, ch in ipairs(parent:GetChildren()) do
                if EXACT[ch.Name] or ch.Name:sub(1, 13) == "ViolettePanel" then
                    pcall(function() ch:Destroy() end)
                end
            end
        end
    end
    pcall(function()
        local b = Lighting:FindFirstChild("VioletteLoadIntroBlur")
        if b then b:Destroy() end
    end)
end

pcall(function()
    if isfile and readfile and isfile("VioletteHub_Auto.json") then
        local cfg = HttpService:JSONDecode(readfile("VioletteHub_Auto.json"))
        if type(cfg) == "table" and type(cfg.globals) == "table" then
            if type(cfg.globals._VioletteIntroSong) == "string" then
                _G._VioletteIntroSong = cfg.globals._VioletteIntroSong
            end
            if type(cfg.globals._VioletteSkipIntro) == "boolean" then
                _G._VioletteSkipIntro = cfg.globals._VioletteSkipIntro
            end
        end
    end
end)

local function textWidth(text, size, font)
    local ok, w = pcall(function()
        return TextService:GetTextSize(text, size, font, Vector2.new(10000, 100)).X
    end)
    if ok and w and w > 0 then return math.ceil(w) end
    return math.ceil(#text * size * 0.55) + 2
end

local _cam = workspace.CurrentCamera
local _vp = _cam and _cam.ViewportSize or Vector2.new(1280, 720)
local _shortSide = math.min(_vp.X, _vp.Y)
local _longSide  = math.max(_vp.X, _vp.Y)
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local isTablet = isMobile and (_shortSide >= 700 or _longSide >= 1100)

local DEVICE_UI_SCALE = 1.0
if isMobile then DEVICE_UI_SCALE = isTablet and 0.9 or 0.8 end
_G._VioletteDeviceScale = DEVICE_UI_SCALE
local function getMobileOptimized(pc, mobile)
    if isMobile and not isTablet then return mobile end
    return pc
end

local NORMAL_SPEED = 60
local CARRY_SPEED  = 29
local LAGGER_SPEED = 50
local FOV_VALUE    = 70
local UI_SCALE     = 1.0
_G._BASE_NORMAL = NORMAL_SPEED
_G._BASE_CARRY  = CARRY_SPEED

local Keybinds = {
    AutoBat        = Enum.KeyCode.Unknown,
    SpeedToggle    = Enum.KeyCode.Unknown,
    LaggerToggle   = Enum.KeyCode.Unknown,
    InfiniteJump   = Enum.KeyCode.Unknown,
    UIToggle       = Enum.KeyCode.Unknown,
    DropBrainrot   = Enum.KeyCode.Unknown,
    TPDown         = Enum.KeyCode.Unknown,
    AntiDie        = Enum.KeyCode.Unknown,
    InstaReset     = Enum.KeyCode.Unknown,
    LaggerSpeed    = Enum.KeyCode.Unknown,
    DesyncSpeed    = Enum.KeyCode.Unknown,
    NormalSpeed    = Enum.KeyCode.Unknown,
    AutoLeft       = Enum.KeyCode.Unknown,
    AutoRight      = Enum.KeyCode.Unknown,
}

local function _kbActionName(k)
    local pretty = {
        AutoBat="Bat Aimbot", SpeedToggle="Carry Mode", LaggerToggle="Lagger Mode",
        InfiniteJump="Infinite Jump", UIToggle="UI Toggle", DropBrainrot="Drop Brainrot",
        TPDown="TP Down",
        LaggerSpeed="Lagger Speed", DesyncSpeed="Custom Speed", NormalSpeed="Normal Speed", AntiDie="Anti Die",

        InstaReset="Insta Reset",
        AutoLeft="Auto Left", AutoRight="Auto Right",
    }
    return pretty[k] or k
end
local function _kbConflict(kc, selfKey)
    if not kc or kc == Enum.KeyCode.Unknown then return nil end
    for k, v in pairs(Keybinds) do
        if k ~= selfKey and v == kc then return _kbActionName(k) end
    end
    local ap = _G._AdaptAPKeybinds
    if type(ap) == "table" then
        for k, v in pairs(ap) do
            if k ~= selfKey and v == kc then return _kbActionName(k) end
        end
    end
    if selfKey ~= "InstaReset" and _G._VynxInstaResetKey == kc.Name then
        return _kbActionName("InstaReset")
    end
    return nil
end
_G._AdaptKeybindConflict = _kbConflict

local GAMEPAD_TYPES = {
    [Enum.UserInputType.Gamepad1] = true, [Enum.UserInputType.Gamepad2] = true,
    [Enum.UserInputType.Gamepad3] = true, [Enum.UserInputType.Gamepad4] = true,
    [Enum.UserInputType.Gamepad5] = true, [Enum.UserInputType.Gamepad6] = true,
    [Enum.UserInputType.Gamepad7] = true, [Enum.UserInputType.Gamepad8] = true,
}
local function _isGamepadInput(input)
    return input ~= nil and GAMEPAD_TYPES[input.UserInputType] == true
end
local function _isBindableInput(input)
    if input == nil then return false end
    return input.UserInputType == Enum.UserInputType.Keyboard or _isGamepadInput(input)
end
_G._VioletteIsGamepadInput = _isGamepadInput
_G._VioletteIsBindableInput = _isBindableInput

local GAMEPAD_LABELS = {
    ButtonA = "A (X)",       ButtonB = "B (O)",
    ButtonX = "X (SQ)",      ButtonY = "Y (TRI)",
    ButtonL1 = "LB (L1)",    ButtonR1 = "RB (R1)",
    ButtonL2 = "LT (L2)",    ButtonR2 = "RT (R2)",
    ButtonL3 = "LS (L3)",    ButtonR3 = "RS (R3)",
    ButtonStart = "Start",   ButtonSelect = "Select",
    DPadLeft = "D-Left",     DPadRight = "D-Right",
    DPadUp = "D-Up",         DPadDown = "D-Down",
    ButtonCross = "X (A)",   ButtonCircle = "O (B)",
    ButtonSquare = "SQ (X)", ButtonTriangle = "TRI (Y)",
    Thumbstick1 = "LS",      Thumbstick2 = "RS",
}
local function _keyName(kc)
    if typeof(kc) ~= "EnumItem" or kc == Enum.KeyCode.Unknown then return "None" end
    return GAMEPAD_LABELS[kc.Name] or kc.Name
end
_G._VioletteKeyName = _keyName
_G._VioletteGamepadLabels = GAMEPAD_LABELS

local STEAL_DURATION_FIXED = 1.30
local Settings = {
    AutoStealEnabled = true,
    StealRadius      = 62,
    StealDuration    = STEAL_DURATION_FIXED,
}
local Values = {
    STEAL_RADIUS   = 62,
    STEAL_DURATION = STEAL_DURATION_FIXED,
}
local Enabled = {
    AntiRagdoll = false, AutoSteal = false, InfiniteJump = false,
    ShinyGraphics = false, Optimizer = false, Unwalk = false, RemoveAccessories = false,
}
local VisualSetters = {}
local BC = { enabled = false, followMode = false }
local KB = {}
local waitingForKey = nil

_G._VioletteKeyCaptureUntil = 0
_G._VioletteBeginKeyCapture = function()
    _G._VioletteKeyCapture = true
    _G._VioletteKeyCaptureUntil = tick() + 0.35
end
_G._VioletteEndKeyCapture = function()
    _G._VioletteKeyCapture = false
    _G._VioletteKeyCaptureUntil = tick() + 0.25
end
_G._VioletteKeyCaptureActive = function()
    return _G._VioletteKeyCapture == true
        or (tonumber(_G._VioletteKeyCaptureUntil) or 0) > tick()
end

local Spd = { family = "normal", carry = false }
_G._VioletteSpd = Spd

Spd.Refresh = function() end

function Spd.Values()
    if Spd.family == "lagger" then
        return tonumber(_G.LaggerSpeed_Normal) or 50, tonumber(_G.LaggerSpeed_Carry) or 25
    elseif Spd.family == "custom" then
        return tonumber(_G.DesyncSpeed_Normal) or 65, tonumber(_G.DesyncSpeed_Carry) or 33
    end
    return tonumber(_G.NormalSpeed_Normal) or 60, tonumber(_G.NormalSpeed_Carry) or 29
end

function Spd.SetProfile(family, carrying)
    if family == "desync" then family = "custom" end
    Spd.family = (family == "lagger" or family == "custom") and family or "normal"
    Spd.carry  = carrying and true or false
    local char = LocalPlayer and LocalPlayer.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if hum then hum.PlatformStand = false; hum.AutoRotate = true end
    if root then root.AssemblyAngularVelocity = Vector3.zero end
    Spd.Refresh()
    if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
end

function Spd.Method()
    return (_G._VynxSpeedMethod == "V2") and "V2" or "V1"
end

function Spd.Carry()
    _G._VynxCarryUserOverride = true
    if Spd.Method() == "V2" then
        return Spd.SetProfile(Spd.family, not Spd.carry)
    end
    if Spd.family ~= "normal" then
        return Spd.SetProfile("normal", true)
    end
    return Spd.SetProfile("normal", not Spd.carry)
end

function Spd.Family(fam)
    _G._VynxCarryUserOverride = true
    if Spd.Method() == "V2" then
        if Spd.family == fam then
            return Spd.SetProfile("normal", false)
        end
        return Spd.SetProfile(fam, false)
    end
    if Spd.family ~= fam then
        return Spd.SetProfile(fam, Spd.carry)
    end
    return Spd.SetProfile(fam, not Spd.carry)
end
function Spd.Lagger() return Spd.Family("lagger") end
function Spd.Custom() return Spd.Family("custom") end

function Spd.Normal()
    _G._VynxCarryUserOverride = true
    if Spd.Method() == "V2" then
        return Spd.SetProfile(Spd.family, not Spd.carry)
    end
    if Spd.family ~= "normal" then
        return Spd.SetProfile("normal", Spd.carry)
    end
    return Spd.SetProfile("normal", not Spd.carry)
end

function Spd.Button(fam, wantCarry)
    _G._VynxCarryUserOverride = true
    if fam == "desync" then fam = "custom" end
    wantCarry = wantCarry and true or false
    if Spd.family == fam and Spd.carry == wantCarry
       and not (fam == "normal" and not wantCarry) then
        return Spd.SetProfile("normal", false)
    end
    return Spd.SetProfile(fam, wantCarry)
end

_G._VioletteSetSpeedProfile = Spd.SetProfile
_G._VioletteToggleCarry     = Spd.Carry
_G._VioletteToggleLagger    = Spd.Lagger
_G._VioletteToggleCustom    = Spd.Custom
_G._VioletteToggleDesync    = Spd.Custom
_G._VioletteToggleNormal    = Spd.Normal
_G._VioletteSpeedButton     = Spd.Button
local autoBatToggled, autoSwingEnabled = false, false
local harderHitAnimEnabled, medusaCounterEnabled = false, false
local desyncEnabled, stretchRezEnabled = false, false
local noCamCollisionEnabled, ultraModeEnabled = false, false
local fastestStealEnabled = false
local brainrotReturnLeftEnabled, brainrotReturnRightEnabled = false, false

_G._VioletteGetSpeed = function()
    local aimbot = _G._VioletteGetAimbotSpeed and _G._VioletteGetAimbotSpeed()
    if aimbot then return aimbot end
    local n, c = Spd.Values()
    return Spd.carry and c or n
end
_G._VioletteAutoPathActive = function() return false end
local G_tpAutoEnabled, G_autoPlayAfterTP = false, false
local tpMode = "Manuel"
local TP_DOWN_OFFSET = 0.1
local dropMobileSetter, setDropBrainrotVisual
local RadiusInput, DurationInput
local ProgressBarFill, ProgressLabel, ProgressPercentLabel
local apMain
local nsb, csb, lsb, carryV, laggerV, modeSR

local function _noop() end
local startAutoSteal, stopAutoSteal            = _noop, _noop
local startAntiRagdoll, stopAntiRagdoll        = _noop, _noop
local startInfiniteJump, stopInfiniteJump      = _noop, _noop
local startUnwalk, stopUnwalk                  = _noop, _noop
local startRemoveAccessories, stopRemoveAccessories = _noop, _noop
local enableOptimizer, disableOptimizer        = _noop, _noop
local enableUltraMode, disableUltraMode        = _noop, _noop
local enableNoCameraCollision, disableNoCameraCollision = _noop, _noop
local setupMedusaCounter, stopMedusaCounter    = _noop, _noop
local startHarderHitAnim, stopHarderHitAnim    = _noop, _noop
local runDropBrainrot, refreshMyPlotSide       = _noop, _noop
local saveOriginalAnims, applyAnimPack         = _noop, _noop

_G.VezyStartBatAimbot        = _noop
_G.VezyStopBatAimbot         = _noop
_G.VezyStartBatAimbotDispatch= _noop
_G.VezyStartBatCounter       = _noop
_G.VezyStopBatCounter        = _noop
_G.VezyEnableInfJump         = _noop
_G.VezyDisableInfJump        = _noop
_G.VezyEnableFOV             = _noop
_G.VezyDisableFOV            = _noop
_G.VezyEnableCustomFont      = _noop
_G.VezyDisableCustomFont     = _noop
_G.VezyApplyCustomSky        = _noop
_G._VynxEnableStretchRez     = _noop
_G._VynxDisableStretchRez    = _noop
_G._VynxApplyDesync          = _noop
_G._VynxRunTPDown            = _noop
_G.VynxEmergencyUnlock       = _noop
_G.VezySetupRagdollTimer     = _noop

_G._VezyBatAimbotSpeed       = 58
_G._VezyBatAimbotSpeedLagger = 40
_G._VezyBatAimbotSpeedCustom = 58
_G._VezyBatAimbotMode        = "new"
_G._VezyBatAimbotOn          = false
_G._VezyCustomFOV            = 120
_G._VezyStretchFOV           = 120
_G._VezyCustomSkyMode        = "Off"
_G._VezyJumpMode             = "Hold"
_G._VezyRotateLockRange      = 50
_G._VynxDropType             = "Jump Drop"
_G._VynxRagdollMode          = "V2"
_G._VynxAutoStealMode        = "Normal"
_G._VynxAutoGrabPause        = 75
_G._VynxSpeedMethod          = (_G._VynxSpeedMethod == "V2") and "V2" or "V1"
_G._VynxMirrorTPDown         = true
_G._VynxAutoTPDownEnabled    = false
_G._VynxAutoTPDownHeightTrigger = 20
_G._VynxMobileBtnScale       = 1.20
_G._VynxInstaResetKey        = nil
_G.NormalSpeed_Normal = 60
_G.NormalSpeed_Carry  = 29
_G.LaggerSpeed_Normal = 50
_G.LaggerSpeed_Carry  = 25
_G.DesyncSpeed_Normal = 65
_G.DesyncSpeed_Carry  = 33
_G.NormalSpeedActive = false
_G.LaggerSpeedActive = false
_G.DesyncSpeedActive = false

local function saveConfig() end
_G.KRIXSaveNow        = _noop
_G.KRIXSaveNowInstant = _noop
_G.VezyResetAllToDefaults = _noop
_G.VezySaveUserConfigs    = _noop
_G.VezyLoadUserConfigs    = _noop

local function _formatSpeed(v)
    if type(v) ~= "number" then return tostring(v) end
    return (v == math.floor(v)) and tostring(math.floor(v)) or string.format("%.1f", v)
end
local ACC = Color3.fromRGB(235,235,235)


;(function()

local BG      = Color3.fromRGB(8, 8, 8)
local BG_DARK = Color3.fromRGB(0, 0, 0)
local CARD    = Color3.fromRGB(18, 18, 18)
local CARD2   = Color3.fromRGB(32, 32, 32)
ACC           = Color3.fromRGB(254, 254, 254)
local SW_OFF  = Color3.fromRGB(40, 40, 40)
local WHITE   = Color3.fromRGB(255,255,255)
local DIM     = Color3.fromRGB(150, 150, 155)

local G_29 = 1

local function mountOnTop(sg, order)
    sg.ResetOnSpawn = false
    sg.DisplayOrder = order or 1000000
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() sg.OnTopOfCoreBlur = true end)
    pcall(function()
        if type(gethui) == "function" then sg.Parent = gethui() end
    end)
    if not sg.Parent then
        pcall(function() sg.Parent = game:GetService("CoreGui") end)
    end
    if not sg.Parent then
        sg.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    return sg
end
_G._VioletteMountOnTop = mountOnTop

local gui = Instance.new("ScreenGui")
gui.Name = "KrixHubGUI"
mountOnTop(gui, 1000000)

local PW = 330
local PH = 470

local outer = Instance.new("Frame", gui)
outer.Name = "Outer"
outer.Size = UDim2.new(0,PW,0,PH)
outer.Position = UDim2.new(0,20,0,110)
outer.BackgroundTransparency = 1
outer.BorderSizePixel = 0
outer.Active = true
outer.ClipsDescendants = false

outer.Visible = false
_G.VynxOuterRef = outer

local innerPanel = Instance.new("Frame", outer)
innerPanel.Name = "Inner"
innerPanel.Size = UDim2.new(1,0,1,0)
innerPanel.AnchorPoint = Vector2.new(0.5, 0.5)
innerPanel.Position = UDim2.new(0.5,0,0.5,0)
innerPanel.BackgroundColor3 = BG
innerPanel.BackgroundTransparency = 1
innerPanel.BorderSizePixel = 0
innerPanel.ClipsDescendants = true
innerPanel.ZIndex = 1
Instance.new("UICorner", innerPanel).CornerRadius = UDim.new(0,24)

local panelPop = Instance.new("UIScale", innerPanel)
panelPop.Name = "PanelPop"
panelPop.Scale = 1
local _hubAnimToken = 0
local _hubShown = false
local reopenBtn
local function setHubVisible(v)
    _hubAnimToken = _hubAnimToken + 1
    local token = _hubAnimToken
    v = v and true or false
    _hubShown = v
    if reopenBtn and reopenBtn.Parent then reopenBtn.Visible = not v end
    if v then
        outer.Visible = true
        panelPop.Scale = 0.92
        TweenService:Create(panelPop,
            TweenInfo.new(0.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Scale = 1}):Play()
    else
        TweenService:Create(panelPop,
            TweenInfo.new(0.13, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {Scale = 0.92}):Play()
        task.delay(0.13, function()
            if token == _hubAnimToken then outer.Visible = false end
        end)
    end
end
_G._VioletteSetHubVisible = setHubVisible
_G._VioletteHubShown = function() return _hubShown end

_G._VezyBgOpacity  = _G._VezyBgOpacity  or 1
_G._VezyBtnOpacity = _G._VezyBtnOpacity or 0.5
_G._VezyBgImageId  = _G._VezyBgImageId  or ""

local bgGrad = Instance.new("Frame", innerPanel)
bgGrad.Name = "BgGradient"
bgGrad.Size = UDim2.new(1, 0, 1, 0)
bgGrad.BackgroundColor3 = Color3.fromRGB(15, 10, 18)
bgGrad.BorderSizePixel = 0
bgGrad.ZIndex = 0
Instance.new("UICorner", bgGrad).CornerRadius = UDim.new(0, 24)
local grad = Instance.new("UIGradient", bgGrad)
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(26, 26, 26)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(12, 12, 12)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(22, 22, 22)),
})
grad.Rotation = 135

local bgImg = Instance.new("ImageLabel", innerPanel)
bgImg.Name = "BackgroundImage"
bgImg.Size = UDim2.new(1, 0, 1, 0)
bgImg.Position = UDim2.new(0, 0, 0, 0)
bgImg.BackgroundColor3 = Color3.fromRGB(15, 10, 18)
bgImg.BackgroundTransparency = 1
bgImg.Image = ""
bgImg.ImageColor3 = Color3.fromRGB(255, 255, 255)
bgImg.ScaleType = Enum.ScaleType.Stretch
bgImg.ImageTransparency = 1 - _G._VezyBgOpacity
bgImg.Visible = false
bgImg.ZIndex = 2
Instance.new("UICorner", bgImg).CornerRadius = UDim.new(0, 24)
_G._VezyBgImageRef = bgImg

_G.VezySetBgOpacity = function(v)
    v = math.clamp(v, 0, 1)
    _G._VezyBgOpacity = v
    if _G._VezyBgImageRef then _G._VezyBgImageRef.ImageTransparency = 1 - v end
end

_G.VezySetBgImage = function(id)
    if not _G._VezyBgImageRef then
        warn("[EUGENE] No _VezyBgImageRef")
        return
    end
    if id == nil or id == "" then
        _G._VezyBgImageRef.Visible = false
        _G._VezyBgImageRef.Image   = ""
        _G._VezyBgImageId = ""
        print("[EUGENE] BG image cleared")
        return
    end
    local s = tostring(id)
    s = s:gsub("rbxassetid://", "")
    s = s:gsub("rbxasset://", "")
    s = s:gsub("%s+", "")
    if s == "" or not tonumber(s) then
        _G._VezyBgImageRef.Visible = false
        warn("[EUGENE] Bad BG ID: " .. tostring(id))
        return
    end
    _G._VezyBgImageId = s
    _G._VezyBgImageRef.Image    = "rbxassetid://" .. s
    _G._VezyBgImageRef.Visible  = true

    _G._VezyBgImageRef.ImageTransparency = 0
    print("[EUGENE] BG image set: rbxassetid://" .. s)
end

local _originalBgTrans = {}
local _skipNames = {
    BackgroundImage = true,
    BgBacking       = true,
    BgTint          = true,
    BgGradient      = true,
    SliderKnob      = true,
}
local _originalBgColor = {}
_G._VezyBtnColor = _G._VezyBtnColor or Color3.fromRGB(20, 20, 26)

_G.VezySetBtnOpacity = function(v)
    v = math.clamp(v or 1, 0, 1)
    _G._VezyBtnOpacity = v
    if not innerPanel then return end
    for _, d in ipairs(innerPanel:GetDescendants()) do
        if not _skipNames[d.Name]
           and (d:IsA("Frame") or d:IsA("TextButton") or d:IsA("ImageButton")) then

            if _originalBgTrans[d] == nil then
                _originalBgTrans[d] = d.BackgroundTransparency
            end
            local orig = _originalBgTrans[d]
            if orig < 0.95 then
                d.BackgroundTransparency = orig + (1 - orig) * (1 - v)
            end
        end
    end
end

_G.VezySetBtnColor = function(color)
    _G._VezyBtnColor = color
    if not innerPanel then return end
    for _, d in ipairs(innerPanel:GetDescendants()) do
        if not _skipNames[d.Name]
           and d:IsA("Frame")
           and not d:IsA("ScrollingFrame")
           and d.Parent ~= innerPanel
           then
            if _originalBgColor[d] == nil then
                _originalBgColor[d] = d.BackgroundColor3
            end
            local orig = _originalBgColor[d]

            local r, g, b = orig.R, orig.G, orig.B
            local brightness = (r + g + b) / 3
            if brightness < 0.25 then
                d.BackgroundColor3 = color
            end
        end
    end
end

do local drag,ds,sp=false
    outer.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            drag=true;ds=i.Position;sp=outer.Position
            i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then drag=false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local v=i.Position-ds
            outer.Position=UDim2.new(sp.X.Scale,sp.X.Offset+v.X,sp.Y.Scale,sp.Y.Offset+v.Y)
        end
    end)
end

local HDR = getMobileOptimized(112, 98)
local hdr = Instance.new("Frame", innerPanel)
hdr.Size = UDim2.new(1,0,0,HDR)
hdr.Position = UDim2.new(0,0,0,0)
hdr.BackgroundTransparency = 1
hdr.BorderSizePixel = 0
hdr.ZIndex = 5

local hdrSepLine = Instance.new("Frame", innerPanel)
hdrSepLine.Name = "HeaderSeparator"
hdrSepLine.Size = UDim2.new(1, -28, 0, 1)
hdrSepLine.Position = UDim2.new(0, 14, 0, HDR)
hdrSepLine.BackgroundColor3 = ACC
hdrSepLine.BackgroundTransparency = 0.4
hdrSepLine.BorderSizePixel = 0
hdrSepLine.ZIndex = 4

local sepGrad = Instance.new("UIGradient", hdrSepLine)
sepGrad.Color = ColorSequence.new(ACC)
sepGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0,    1),
    NumberSequenceKeypoint.new(0.15, 0.3),
    NumberSequenceKeypoint.new(0.5,  0),
    NumberSequenceKeypoint.new(0.85, 0.3),
    NumberSequenceKeypoint.new(1,    1),
})

local hdrBanner = Instance.new("Frame", hdr)
hdrBanner.Name = "VioletteWordmarkBanner"
hdrBanner.BackgroundTransparency = 1
hdrBanner.BorderSizePixel = 0
hdrBanner.AnchorPoint = Vector2.new(0.5, 0.5)
hdrBanner.Position = UDim2.new(0.5, -8, 0.5, 0)
hdrBanner.Size = UDim2.new(0, getMobileOptimized(300, 250), 0, getMobileOptimized(92, 80))
hdrBanner.ZIndex = 6
hdrBanner.ClipsDescendants = false

local hdrWordmark = {}
do
    local logo = Instance.new("ImageLabel", hdrBanner)
    logo.Name = "VioletteHeaderLogo"
    logo.BackgroundTransparency = 1
    logo.BorderSizePixel = 0
    logo.Image = "rbxassetid://123917878419147"
    logo.ImageColor3 = Color3.fromRGB(255, 255, 255)
    logo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    logo.BackgroundTransparency = 1
    logo.BorderSizePixel = 0
    logo.ScaleType = Enum.ScaleType.Fit
    logo.AnchorPoint = Vector2.new(0.5, 0.5)
    logo.Position = UDim2.fromScale(0.5, 0.5)
    logo.Size = UDim2.fromScale(1.35, 1.35)
    logo.ZIndex = 7
    hdrWordmark[1] = logo
end


local xb = Instance.new("TextButton", hdr)
xb.Size = UDim2.new(0,30,0,22); xb.Position = UDim2.new(1,-40,0,7)
xb.BackgroundColor3 = Color3.fromRGB(20,20,20); xb.BorderSizePixel = 0
xb.Text = "-"; xb.TextColor3 = WHITE
xb.Font = Enum.Font.GothamBold; xb.TextSize = 14; xb.ZIndex = 6
Instance.new("UICorner",xb).CornerRadius = UDim.new(0,8)

local lockBtn = Instance.new("TextButton", hdr)
lockBtn.Name = "HdrLock"
lockBtn.Size = UDim2.new(0,30,0,22); lockBtn.Position = UDim2.new(1,-40,0,33)
lockBtn.BackgroundColor3 = Color3.fromRGB(20,20,20); lockBtn.BorderSizePixel = 0
lockBtn.AutoButtonColor = false
lockBtn.Text = utf8.char(0x1F513); lockBtn.TextColor3 = WHITE
lockBtn.Font = Enum.Font.GothamBold; lockBtn.TextSize = 13; lockBtn.ZIndex = 8
Instance.new("UICorner",lockBtn).CornerRadius = UDim.new(0,8)

_G._VynxRefreshHdrLockIcon = function()
    if lockBtn and lockBtn.Parent then
        lockBtn.Text = (_G._VynxUILocked == true)
            and utf8.char(0x1F512) or utf8.char(0x1F513)
    end
end
_G._VynxRefreshHdrLockIcon()

lockBtn.MouseButton1Click:Connect(function()
    _G._VynxUILocked = not (_G._VynxUILocked == true)
    _G._VynxRefreshHdrLockIcon()
    if VisualSetters.LockUI then pcall(VisualSetters.LockUI, _G._VynxUILocked) end
    if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
    if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
end)

local hdrLine = Instance.new("Frame", hdr)
hdrLine.Size = UDim2.new(0,0,0,0); hdrLine.Position = UDim2.new(0,0,0,0)
hdrLine.BackgroundTransparency = 1
hdrLine.BorderSizePixel = 0; hdrLine.ZIndex = 6

local TABBAR_H = getMobileOptimized(48, 44)

local tabBar = Instance.new("ScrollingFrame", innerPanel)
tabBar.Name = "TopTabBar"
tabBar.Visible = true
tabBar.Size = UDim2.new(1, -16, 0, TABBAR_H - 6)
tabBar.Position = UDim2.new(0, 8, 0, HDR + 4)
tabBar.BackgroundTransparency = 1
tabBar.BorderSizePixel = 0
tabBar.ZIndex = 5
tabBar.ScrollBarThickness = 0
tabBar.ScrollingDirection = Enum.ScrollingDirection.X
tabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
tabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
tabBar.ClipsDescendants = false
tabBar.ElasticBehavior = Enum.ElasticBehavior.Always

local tabBarDivider = Instance.new("Frame", innerPanel)
tabBarDivider.Visible = true
tabBarDivider.Size = UDim2.new(1, -28, 0, 1)
tabBarDivider.Position = UDim2.new(0, 14, 0, HDR + TABBAR_H)
tabBarDivider.BackgroundColor3 = ACC
tabBarDivider.BackgroundTransparency = 0.55
tabBarDivider.BorderSizePixel = 0
tabBarDivider.ZIndex = 4

local tbdGrad = Instance.new("UIGradient", tabBarDivider)
tbdGrad.Color = ColorSequence.new(ACC)
tbdGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0,    1),
    NumberSequenceKeypoint.new(0.15, 0.35),
    NumberSequenceKeypoint.new(0.5,  0),
    NumberSequenceKeypoint.new(0.85, 0.35),
    NumberSequenceKeypoint.new(1,    1),
})

local sidebar = Instance.new("Frame", innerPanel)
sidebar.Size = UDim2.new(0, 0, 0, 0)
sidebar.BackgroundTransparency = 1
sidebar.Visible = false

local tabButtons = {}
local tabPages = {}
local currentTab = "Speed"
local tabLayout = Instance.new("UIListLayout", tabBar)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 8)
local tabPad = Instance.new("UIPadding", tabBar)
tabPad.PaddingLeft = UDim.new(0, 4); tabPad.PaddingRight = UDim.new(0, 6)
tabPad.PaddingTop = UDim.new(0, 3); tabPad.PaddingBottom = UDim.new(0, 3)

local function makeTab(name, order)
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.fromOffset(getMobileOptimized(78, 72), getMobileOptimized(34, 30))
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    btn.BackgroundTransparency = 0.35
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = getMobileOptimized(13, 12)
    btn.TextColor3 = Color3.fromRGB(220, 220, 230)
    btn.AutoButtonColor = false
    btn.LayoutOrder = order
    btn.ZIndex = 6
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    local st = Instance.new("UIStroke", btn)
    st.Name = "UIStroke"
    st.Color = Color3.fromRGB(255, 255, 255)
    st.Thickness = 1.0
    st.Transparency = 0.35
    st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local sc = Instance.new("UIScale", btn)
    sc.Name = "TabPop"
    sc.Scale = 1

    local lbl = Instance.new("TextLabel", btn)
    lbl.Name = "Label"
    lbl.Size = UDim2.fromScale(1, 1)
    lbl.BackgroundTransparency = 1
    lbl.Text = ""
    lbl.TextTransparency = 1
    lbl.ZIndex = 7
    local underline = Instance.new("Frame", btn)
    underline.Name = "Underline"
    underline.BackgroundTransparency = 1
    underline.Size = UDim2.new(0, 0, 0, 0)

    btn.MouseEnter:Connect(function()
        if currentTab ~= name then
            TweenService:Create(btn, TweenInfo.new(0.14), {
                BackgroundTransparency = 0.2,
                TextColor3 = Color3.fromRGB(255, 255, 255),
            }):Play()
            TweenService:Create(st, TweenInfo.new(0.14), {Transparency = 0.15}):Play()
            TweenService:Create(sc, TweenInfo.new(0.14, Enum.EasingStyle.Back), {Scale = 1.05}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if currentTab ~= name then
            TweenService:Create(btn, TweenInfo.new(0.14), {
                BackgroundTransparency = 0.35,
                TextColor3 = Color3.fromRGB(220, 220, 230),
            }):Play()
            TweenService:Create(st, TweenInfo.new(0.14), {Transparency = 0.35}):Play()
            TweenService:Create(sc, TweenInfo.new(0.14), {Scale = 1}):Play()
        end
    end)

    tabButtons[name] = btn
    return btn
end


_G._VioletteRepaintTabs = function()
    local accent = _G._VioletteAccent or ACC
    for tn, btn in pairs(tabButtons) do
        if tn == currentTab then
            btn.TextColor3 = accent
            local st = btn:FindFirstChildOfClass("UIStroke")
            if st then st.Color = accent; st.Transparency = 0; st.Thickness = 1.5 end
        end
    end
end

local contentArea = Instance.new("ScrollingFrame", innerPanel)
contentArea.Size = UDim2.new(1, 0, 1, -HDR-TABBAR_H-12)
contentArea.Position = UDim2.new(0, 0, 0, HDR + TABBAR_H + 4)
contentArea.BackgroundTransparency = 1
contentArea.BorderSizePixel = 0
contentArea.ClipsDescendants = true
contentArea.ZIndex = 3
contentArea.ScrollBarThickness = 3
contentArea.ScrollBarImageColor3 = ACC
contentArea.ScrollBarImageTransparency = 0.4
contentArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
contentArea.ScrollingDirection = Enum.ScrollingDirection.Y
local _contentLL = Instance.new("UIListLayout", contentArea)
_contentLL.SortOrder = Enum.SortOrder.LayoutOrder
_contentLL.Padding = UDim.new(0, 0)
_contentLL.HorizontalAlignment = Enum.HorizontalAlignment.Center

local _contentPad = Instance.new("UIPadding", contentArea)
_contentPad.PaddingTop    = UDim.new(0, 2)
_contentPad.PaddingBottom = UDim.new(0, 8)
_contentPad.PaddingLeft   = UDim.new(0, 4)
_contentPad.PaddingRight  = UDim.new(0, 4)

local _mobilePageOrder = 0
local function makePage(name)
    _mobilePageOrder = _mobilePageOrder + 1

    local page = Instance.new("Frame", contentArea)
    page.Name = "Page_"..name
    page.Size = UDim2.new(1, 0, 0, 0)
    page.AutomaticSize = Enum.AutomaticSize.Y
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.Visible = false
    page.ZIndex = 3
    page.LayoutOrder = _mobilePageOrder * 1000 + 1
    local ll = Instance.new("UIListLayout", page)
    ll.Padding = UDim.new(0, 10)
    ll.SortOrder = Enum.SortOrder.LayoutOrder
    local pd = Instance.new("UIPadding", page)
    pd.PaddingLeft = UDim.new(0, 12); pd.PaddingRight = UDim.new(0, 12)
    pd.PaddingTop = UDim.new(0, 10); pd.PaddingBottom = UDim.new(0, 0)
    tabPages[name] = page
    return page
end

local function switchTab(name)
    currentTab = name
    for tn, pg in pairs(tabPages) do
        pg.Visible = (tn == name)
    end
    local accent = _G._VioletteAccent or ACC
    for tn, btn in pairs(tabButtons) do
        local active = (tn == name)
        local st = btn:FindFirstChildOfClass("UIStroke")
        local sc = btn:FindFirstChild("TabPop")
        if active then
            TweenService:Create(btn, TweenInfo.new(0.22), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 48),
                BackgroundTransparency = 0.12,
                TextColor3 = accent,
            }):Play()
            if st then
                TweenService:Create(st, TweenInfo.new(0.22), {
                    Color = accent,
                    Thickness = 1.5,
                    Transparency = 0,
                }):Play()
            end
            if sc then
                TweenService:Create(sc, TweenInfo.new(0.28, Enum.EasingStyle.Back), {Scale = 1.06}):Play()
            end
        else
            TweenService:Create(btn, TweenInfo.new(0.22), {
                BackgroundColor3 = Color3.fromRGB(28, 28, 34),
                BackgroundTransparency = 0.35,
                TextColor3 = Color3.fromRGB(220, 220, 230),
            }):Play()
            if st then
                TweenService:Create(st, TweenInfo.new(0.22), {
                    Color = Color3.fromRGB(255, 255, 255),
                    Thickness = 1.0,
                    Transparency = 0.35,
                }):Play()
            end
            if sc then
                TweenService:Create(sc, TweenInfo.new(0.18), {Scale = 1}):Play()
            end
        end
    end
    if contentArea then
        contentArea.CanvasPosition = Vector2.new(0, 0)
    end
end

local _firstSectionDone = false
local function sectionHeader(parent, text, order)
    local top = _firstSectionDone and 20 or 2
    _firstSectionDone = true
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1,0,0,top + 22); f.BackgroundTransparency = 1
    f.BorderSizePixel = 0
    f.LayoutOrder = order or 1
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1,0,0,16); l.Position = UDim2.new(0,0,0,top); l.BackgroundTransparency = 1
    l.Text = text:upper()
    l.TextColor3 = ACC; l.Font = Enum.Font.GothamBlack
    l.TextSize = getMobileOptimized(13, 12)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextTruncate = Enum.TextTruncate.AtEnd
    l.ZIndex = 4
    local line = Instance.new("Frame", f)
    line.Size = UDim2.new(1,0,0,1); line.Position = UDim2.new(0,0,0,top + 18)
    line.BackgroundColor3 = ACC; line.BackgroundTransparency = 0.7
    line.BorderSizePixel = 0; line.ZIndex = 3
    return f
end

local RH = math.floor(40*G_29)

local function addPressPop(target, btn)
    if not target or not btn then return end
    local pop = target:FindFirstChild("PressPop")
    if not pop then
        pop = Instance.new("UIScale", target)
        pop.Name = "PressPop"
        pop.Scale = 1
    end
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(pop, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {Scale = 0.98}):Play()
    end)
    local function release()
        TweenService:Create(pop,
            TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Scale = 1}):Play()
    end
    btn.MouseButton1Up:Connect(release)
    btn.MouseLeave:Connect(release)
end

local function makeRowBase(page, order)
    local f = Instance.new("Frame", page)
    f.Size = UDim2.new(1,0,0,RH); f.BackgroundColor3 = CARD
    f.BorderSizePixel = 0; f.LayoutOrder = order or 1; f.ZIndex = 4
    Instance.new("UICorner",f).CornerRadius = UDim.new(0,10)

    local st = Instance.new("UIStroke", f)
    st.Color = Color3.fromRGB(28, 28, 34)
    st.Thickness = 1
    st.Transparency = 0
    f.MouseEnter:Connect(function()
        TweenService:Create(st,TweenInfo.new(0.15),{Color=Color3.fromRGB(48, 48, 56)}):Play()
    end)
    f.MouseLeave:Connect(function()
        TweenService:Create(st,TweenInfo.new(0.15),{Color=Color3.fromRGB(28, 28, 34)}):Play()
    end)
    return f,st
end

local function nameWithUnderline(parent, text)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(0.6,0,0,16); lbl.Position = UDim2.new(0,12,0.5,-9)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = WHITE; lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = getMobileOptimized(12,11)
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 5

    local ul = Instance.new("Frame", parent)
    local txtW = textWidth(text, lbl.TextSize, lbl.Font)
    ul.Size = UDim2.new(0,txtW,0,1); ul.Position = UDim2.new(0,12,0.5,7); ul.Visible = false
    ul.BackgroundColor3 = ACC; ul.BorderSizePixel = 0; ul.ZIndex = 5
    return lbl, ul
end


local function addGlow(btn, radius)
    local s = btn:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke", btn)
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Thickness = 1.4
    s.Color = ACC
    s.Transparency = 0.25
    local old = s:FindFirstChildOfClass("UIGradient")
    if old then old:Destroy() end
    local grad = Instance.new("UIGradient", s)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromRGB(90, 90, 90)),
        ColorSequenceKeypoint.new(0.48, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1,    Color3.fromRGB(90, 90, 90)),
    })
end

local function addFillHover(btn, lbl)
    local baseBg  = btn.BackgroundColor3
    local baseTxt = lbl and lbl.TextColor3
    local function fill(on)
        TweenService:Create(btn, TweenInfo.new(0.14), {
            BackgroundColor3 = on and ACC or baseBg
        }):Play()
        if lbl then
            lbl.TextColor3 = on and Color3.fromRGB(0, 0, 0) or baseTxt
            lbl.ZIndex = (btn.ZIndex or 1) + 8
        end
    end
    local function unfillIfIdle()
        if not btn:GetAttribute("Held") and not btn:GetAttribute("Open") then fill(false) end
    end
    btn.MouseEnter:Connect(function() fill(true) end)
    btn.MouseLeave:Connect(unfillIfIdle)
    btn.MouseButton1Down:Connect(function() btn:SetAttribute("Held", true); fill(true) end)
    btn.MouseButton1Up:Connect(function() btn:SetAttribute("Held", false); unfillIfIdle() end)
    return fill
end
local _openDropdown = nil
local function makeDropdown(row, options, getV, setV, width, rightPad, title, multi)
    local BS = 32
    local H = 22

    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0, BS, 0, H)
    btn.Position = UDim2.new(1, -(BS + (rightPad or 12)), 0.5, -H/2)
    btn.BackgroundColor3 = BG_DARK
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Text = ""
    btn.ZIndex = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local btnSt = Instance.new("UIStroke", btn)
    btnSt.Color = ACC; btnSt.Thickness = 1; btnSt.Transparency = 0.5
    btnSt.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    addGlow(btn, 6)

    local chev = Instance.new("TextLabel", btn)
    chev.Size = UDim2.new(1, 0, 1, 0)
    chev.BackgroundTransparency = 1
    chev.Text = utf8.char(0x25BC)
    chev.TextColor3 = ACC
    chev.Font = Enum.Font.GothamBlack
    chev.TextSize = 15
    chev.ZIndex = 20

    local _fill = addFillHover(btn, chev)
    local panel = Instance.new("Frame", row.Parent)
    panel.Name = "DropdownPanel"
    panel.Size = UDim2.new(1, 0, 0, getMobileOptimized(38, 34))
    panel.BackgroundColor3 = CARD
    panel.BorderSizePixel = 0
    panel.LayoutOrder = (row.LayoutOrder or 1) + 1
    panel.ZIndex = 4
    panel.Visible = false
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)
    local pSt = Instance.new("UIStroke", panel)
    pSt.Color = ACC; pSt.Thickness = 1; pSt.Transparency = 0.5
    pSt.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    if not title then
        for _, c in ipairs(row:GetChildren()) do
            if c:IsA("TextLabel") and c.Text ~= "" then title = c.Text; break end
        end
    end
    if title and title ~= "" then
        local pl = Instance.new("TextLabel", panel)
        pl.Size = UDim2.new(0.5, 0, 0, 16)
        pl.Position = UDim2.new(0, 12, 0.5, -9)
        pl.BackgroundTransparency = 1
        pl.Text = title
        pl.TextColor3 = WHITE
        pl.Font = Enum.Font.GothamBold
        pl.TextSize = getMobileOptimized(12, 11)
        pl.TextXAlignment = Enum.TextXAlignment.Left
        pl.ZIndex = 5
        local pu = Instance.new("Frame", panel)
        pu.Size = UDim2.new(0, textWidth(title, pl.TextSize, pl.Font), 0, 1)
        pu.Visible = false
        pu.Position = UDim2.new(0, 12, 0.5, 7)
        pu.BackgroundColor3 = ACC
        pu.BorderSizePixel = 0
        pu.ZIndex = 5
    end
    local optBtns = {}
    local BW = width or 78
    local BH = 24
    local GAP = 6

    local PANEL_H = getMobileOptimized(38, 34)
    local avail = PW - 24 - 110
    local perRow = math.max(1, math.floor((avail + GAP) / (BW + GAP)))
    if perRow > #options then perRow = #options end
    local lineCount = math.ceil(#options / perRow)
    if lineCount > 1 then
        panel.Size = UDim2.new(1, 0, 0, PANEL_H + (lineCount - 1) * (BH + GAP))
    end

    local function refresh()
        local sel = (not multi) and getV() or nil
        for _, v in ipairs(options) do
            local b = optBtns[v]
            if b then
                local on
                if multi then on = getV(v) == true else on = (v == sel) end
                b.BackgroundColor3 = on and ACC or Color3.fromRGB(30, 30, 30)
                b.TextColor3 = on and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(165, 165, 170)
            end
        end
    end

    for i, opt in ipairs(options) do
        local lineIdx = math.floor((i - 1) / perRow)
        local colIdx  = (i - 1) % perRow
        local inLine  = math.min(perRow, #options - lineIdx * perRow)
        local lineTotal = inLine * BW + (inLine - 1) * GAP
        local yTop = (PANEL_H - BH) / 2 + lineIdx * (BH + GAP)

        local b = Instance.new("TextButton", panel)
        b.Size = UDim2.new(0, BW, 0, BH)
        b.Position = UDim2.new(1, -(lineTotal + 12) + colIdx * (BW + GAP), 0, yTop)
        b.BackgroundColor3 = CARD2
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.Text = tostring(opt)
        b.TextColor3 = DIM
        b.Font = Enum.Font.GothamBold
        b.TextSize = getMobileOptimized(11, 10)
        b.ZIndex = 5
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        optBtns[opt] = b
        b.MouseButton1Click:Connect(function()
            setV(opt)
            refresh()
            if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
            if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
        end)
    end

    local function closeList()
        panel.Visible = false
        chev.Rotation = 0
        btn:SetAttribute("Open", false)
        _fill(false)
        if _openDropdown == closeList then _openDropdown = nil end
    end

    btn.MouseButton1Click:Connect(function()
        if panel.Visible then
            closeList()
        else
            if _openDropdown then _openDropdown() end
            panel.Visible = true
            chev.Rotation = 180
            _openDropdown = closeList
            btn:SetAttribute("Open", true)
            _fill(true)
        end
    end)

    refresh()
    return refresh, panel
end
_G._AdaptMakeDropdown = makeDropdown

local function makeSliderRow(page, order, labelTxt, minV, maxV, getV, setV, step)
    step = step or 1
    local dec = (step < 1) and 1 or 0
    local f = Instance.new("Frame", page)
    f.Size = UDim2.new(1, 0, 0, getMobileOptimized(62, 58))
    f.BackgroundColor3 = CARD
    f.BorderSizePixel = 0
    f.LayoutOrder = order
    f.ZIndex = 4
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
    local st = Instance.new("UIStroke", f)
    st.Color = Color3.fromRGB(35, 35, 45); st.Thickness = 1; st.Transparency = 0.4

    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(0.6, 0, 0, 16)
    lbl.Position = UDim2.new(0, 12, 0, 11)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelTxt
    lbl.TextColor3 = WHITE
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = getMobileOptimized(12, 11)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 5
    local und = Instance.new("Frame", f)
    und.Size = UDim2.new(0, textWidth(labelTxt, lbl.TextSize, lbl.Font), 0, 1)
    und.Visible = false
    und.Position = UDim2.new(0, 12, 0, 27)
    und.BackgroundColor3 = ACC
    und.BorderSizePixel = 0
    und.ZIndex = 5

    local box = Instance.new("Frame", f)
    box.Size = UDim2.new(0, 52, 0, 24)
    box.Position = UDim2.new(1, -64, 0, 9)
    box.BackgroundColor3 = BG_DARK
    box.BorderSizePixel = 0
    box.ZIndex = 5
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
    local boxSt = Instance.new("UIStroke", box)
    boxSt.Color = ACC; boxSt.Thickness = 1; boxSt.Transparency = 0.45
    addGlow(box, 8)
    boxSt.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local val = Instance.new("TextLabel", box)
    val.Size = UDim2.new(1, 0, 1, 0)
    val.BackgroundTransparency = 1
    val.TextColor3 = WHITE
    val.Font = Enum.Font.GothamBold
    val.TextSize = getMobileOptimized(12, 11)
    val.ZIndex = 6

    local track = Instance.new("Frame", f)
    track.Size = UDim2.new(1, -24, 0, 6)
    track.Position = UDim2.new(0, 12, 1, -18)
    track.BackgroundColor3 = BG_DARK
    track.BorderSizePixel = 0
    track.ZIndex = 5
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local trkSt = Instance.new("UIStroke", track)
    trkSt.Color = ACC; trkSt.Thickness = 1; trkSt.Transparency = 0.75
    trkSt.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = ACC
    fill.BorderSizePixel = 0
    fill.ZIndex = 6
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", track)
    knob.Name = "SliderKnob"
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(0, 0, 0.5, 0)
    knob.BackgroundColor3 = WHITE
    knob.BorderSizePixel = 0
    knob.ZIndex = 8
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local knobSt = Instance.new("UIStroke", knob)
    knobSt.Color = ACC; knobSt.Thickness = 1.5; knobSt.Transparency = 0.2
    knobSt.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local function snap(v)
        v = math.clamp(v, minV, maxV)
        v = math.floor((v - minV) / step + 0.5) * step + minV
        v = math.floor(v * 100 + 0.5) / 100
        return math.clamp(v, minV, maxV)
    end
    local function refresh()
        local v = snap(getV() or minV)
        local a = (maxV > minV) and ((v - minV) / (maxV - minV)) or 0
        fill.Size = UDim2.new(a, 0, 1, 0)
        knob.Position = UDim2.new(a, 0, 0.5, 0)
        val.Text = string.format("%." .. dec .. "f", v)
    end

    local hit = Instance.new("TextButton", f)
    hit.Size = UDim2.new(1, -24, 0, 26)
    hit.Position = UDim2.new(0, 12, 1, -28)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.AutoButtonColor = false
    hit.ZIndex = 9

    local dragging = false
    local function setFromX(x)
        local w = track.AbsoluteSize.X
        if w <= 0 then return end
        local a = math.clamp((x - track.AbsolutePosition.X) / w, 0, 1)
        setV(snap(minV + a * (maxV - minV)))
        refresh()
    end
    hit.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            setFromX(i.Position.X)
        end
    end)
    hit.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch) then
            setFromX(i.Position.X)
        end
    end)

    refresh()
    return refresh, f
end
local function makeStepper(f, getV, setV, minV, maxV, step, fmt)
    local BS, VW, GAP = 28, 50, 6
    local W = BS * 2 + VW + GAP * 2
    local wrap = Instance.new("Frame", f)
    wrap.Size = UDim2.new(0, W, 0, BS)
    wrap.Position = UDim2.new(1, -(W + 12), 0.5, -BS/2)
    wrap.BackgroundTransparency = 1
    wrap.ZIndex = 5

    local box = Instance.new("Frame", wrap)
    box.Size = UDim2.new(0, VW, 0, BS)
    box.Position = UDim2.new(0, BS + GAP, 0, 0)
    box.BackgroundColor3 = BG_DARK
    box.BorderSizePixel = 0
    box.ZIndex = 6
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
    local boxSt = Instance.new("UIStroke", box)
    boxSt.Color = ACC; boxSt.Thickness = 1; boxSt.Transparency = 0.45
    addGlow(box, 8)

    local val = Instance.new("TextLabel", box)
    val.Size = UDim2.new(1, 0, 1, 0)
    val.BackgroundTransparency = 1
    val.TextColor3 = WHITE
    val.Font = Enum.Font.GothamBlack
    val.TextSize = getMobileOptimized(12, 11)
    val.ZIndex = 7

    local function refresh()
        local v = getV() or 1
        if fmt == "%d" then v = math.floor(v + 0.5) end
        val.Text = string.format(fmt or "%.2f", v)
    end

    local function mkArrow(txt, xOff, delta)
        local b = Instance.new("TextButton", wrap)
        b.Size = UDim2.new(0, BS, 0, BS)
        b.Position = UDim2.new(0, xOff, 0, 0)
        b.BackgroundColor3 = CARD2
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.Text = txt
        b.TextColor3 = ACC
        b.Font = Enum.Font.GothamBlack
        b.TextSize = getMobileOptimized(15, 14)
        b.ZIndex = 6
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        local s = Instance.new("UIStroke", b)
        s.Color = ACC; s.Thickness = 1; s.Transparency = 0.45; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        addGlow(b, 8)
        local lastClick = 0
        b.MouseButton1Click:Connect(function()
            local now = os.clock()
            if now - lastClick < 0.08 then return end
            lastClick = now
            local cur = getV() or minV
            local snapped = math.floor((cur - minV) / step + 0.5) * step + minV
            local nv = math.clamp(snapped + delta, minV, maxV)
            nv = math.floor(nv * 100 + 0.5) / 100
            setV(nv)
            refresh()
        end)
    end
    mkArrow("-", 0, -step)
    mkArrow("+", BS + VW + GAP * 2, step)
    refresh()
    return refresh
end

local SW_W = getMobileOptimized(36,32)
local SW_H = getMobileOptimized(18,16)
local SW_C = getMobileOptimized(14,12)

local function mkSwitch(parent, defOn)
    local bg = Instance.new("Frame", parent)
    bg.Size = UDim2.new(0,SW_W,0,SW_H)
    bg.Position = UDim2.new(1,-(SW_W+12),0.5,-SW_H/2)
    bg.BackgroundColor3 = defOn and ACC or SW_OFF
    bg.BorderSizePixel = 0; bg.ZIndex = 6
    Instance.new("UICorner",bg).CornerRadius = UDim.new(1,0)

    local bgSt = Instance.new("UIStroke", bg)
    bgSt.Color = defOn and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(70, 70, 70)
    bgSt.Thickness = 1
    bgSt.Transparency = defOn and 0.4 or 0.5
    bgSt.ZIndex = 6

    local knob = Instance.new("Frame", bg)
    knob.Size = UDim2.new(0,SW_C,0,SW_C)
    knob.Position = defOn and UDim2.new(0,SW_W-SW_C-2,0.5,-SW_C/2) or UDim2.new(0,2,0.5,-SW_C/2)
    knob.BackgroundColor3 = defOn and WHITE or Color3.fromRGB(120, 120, 120)
    knob.BorderSizePixel = 0; knob.ZIndex = 7
    Instance.new("UICorner",knob).CornerRadius = UDim.new(1,0)
    local function setV(on)
        TweenService:Create(bg, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {BackgroundColor3 = on and ACC or SW_OFF}):Play()
        TweenService:Create(bgSt, TweenInfo.new(0.2), {
            Color = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(70, 70, 70),
            Thickness = 1,
            Transparency = on and 0.4 or 0.5
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
            BackgroundColor3 = on and WHITE or Color3.fromRGB(120, 120, 120)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.22, Enum.EasingStyle.Back), {
            Position = on and UDim2.new(0,SW_W-SW_C-2,0.5,-SW_C/2) or UDim2.new(0,2,0.5,-SW_C/2)
        }):Play()
    end
    return setV
end

local function mkNumberBox(parent, val)
    local bx = Instance.new("Frame", parent)
    bx.Size = UDim2.new(0, getMobileOptimized(54,46), 0, getMobileOptimized(24,22))
    bx.Position = UDim2.new(1, -getMobileOptimized(66,54), 0.5, -getMobileOptimized(12,11))
    bx.BackgroundColor3 = BG_DARK
    bx.BorderSizePixel = 0
    bx.ZIndex = 6
    Instance.new("UICorner", bx).CornerRadius = UDim.new(0, 8)
    local bxSt = Instance.new("UIStroke", bx)
    bxSt.Color = ACC
    bxSt.Thickness = 1
    bxSt.Transparency = 0.45
    bxSt.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    addGlow(bx, 8)

    local tb = Instance.new("TextBox", bx)
    tb.Size = UDim2.new(1, 0, 1, 0)
    tb.BackgroundTransparency = 1
    tb.Text = (type(val) == "number" and val == math.floor(val)) and tostring(math.floor(val)) or tostring(val)
    tb.TextColor3 = WHITE
    tb.Font = Enum.Font.GothamBold
    tb.TextSize = getMobileOptimized(12, 11)
    tb.TextXAlignment = Enum.TextXAlignment.Center
    tb.ClearTextOnFocus = false
    tb.ZIndex = 7

    tb.Focused:Connect(function()
        TweenService:Create(bxSt, TweenInfo.new(0.15), {Transparency = 0}):Play()
    end)
    tb.FocusLost:Connect(function()
        TweenService:Create(bxSt, TweenInfo.new(0.2), {Transparency = 0.45}):Play()
    end)
    return tb
end

local KB = {}
local waitingForKey = nil

local function _kbSteal(kc, selfKey)
    if not kc or kc == Enum.KeyCode.Unknown then return false end
    local stole = false
    for k, v in pairs(Keybinds) do
        if k ~= selfKey and v == kc then
            Keybinds[k] = Enum.KeyCode.Unknown
            local lbl = KB[k]
            if lbl and lbl.Parent then lbl.Text = "None" end
            stole = true
        end
    end
    local ap = _G._AdaptAPKeybinds
    if type(ap) == "table" then
        for k, v in pairs(ap) do
            if k ~= selfKey and v == kc then
                ap[k] = Enum.KeyCode.Unknown
                stole = true
            end
        end
    end
    if selfKey ~= "InstaReset" and _G._VynxInstaResetKey == kc.Name then
        _G._VynxInstaResetKey = nil
        if _G._VynxRefreshInstaResetKey then pcall(_G._VynxRefreshInstaResetKey) end
        stole = true
    end
    local panelStates = {
        ["panel:duelLagger"]  = _G._VioletteDuelLagger,
        ["panel:pingLagger"]  = _G._ViolettePingLagger,
        ["panel:speedBypass"] = _G._VioletteSpeedBypass,
    }
    for tag, st in pairs(panelStates) do
        if tag ~= selfKey and type(st) == "table" and st.key == kc.Name then
            st.key = nil
            stole = true
        end
    end
    if _G._VioletteRefreshAllPanelKeys then pcall(_G._VioletteRefreshAllPanelKeys) end
    if _G._VynxRefreshDuelLaggerKey then pcall(_G._VynxRefreshDuelLaggerKey) end
    return stole
end
_G._AdaptKeybindSteal = _kbSteal

local function TR(page, order, name, kbKey, enabledKey, defOn, onToggle, noSwitch)
    local f = makeRowBase(page, order)
    nameWithUnderline(f, name)
    local _bdRef
    local rawSetV = noSwitch and function(v)
        if _bdRef then
            _bdRef.BackgroundTransparency = v and 0 or 0.65
            local lb = _bdRef:FindFirstChildOfClass("TextLabel")
            if lb then lb.TextColor3 = v and Color3.fromRGB(0, 0, 0) or WHITE end
        end
    end or mkSwitch(f, defOn)
    local isOn = defOn or false

    local _inSetV = false
    local setV = function(v)
        if _inSetV then return end
        _inSetV = true
        local prev = isOn
        isOn = v and true or false
        rawSetV(v)
        if prev ~= isOn then
            if enabledKey then Enabled[enabledKey] = isOn end
            if onToggle then pcall(onToggle, isOn) end
        end
        _inSetV = false
    end
    if enabledKey then VisualSetters[enabledKey] = setV end

    local kbLbl = nil
    if kbKey and kbKey ~= "" then
        local BW = noSwitch and SW_W or getMobileOptimized(42,38)
        local BH = noSwitch and 22 or getMobileOptimized(18,16)
        local bd = Instance.new("Frame", f)
        bd.Size = UDim2.new(0,BW,0,BH)

        bd.Position = noSwitch and UDim2.new(1,-(BW+12),0.5,-BH/2) or UDim2.new(1,-(SW_W+20+BW),0.5,-BH/2)
        bd.BackgroundColor3 = ACC; bd.BackgroundTransparency = 0.2
        bd.BorderSizePixel = 0; bd.ZIndex = 9
        Instance.new("UICorner",bd).CornerRadius = UDim.new(0, noSwitch and 8 or 6)
        kbLbl = Instance.new("TextLabel", bd)
        kbLbl.Size = UDim2.new(1,0,1,0); kbLbl.BackgroundTransparency = 1
        kbLbl.Text = (Keybinds[kbKey] and Keybinds[kbKey] ~= Enum.KeyCode.Unknown) and _G._VioletteKeyName(Keybinds[kbKey]) or "None"
        _bdRef = bd
        if noSwitch then bd.BackgroundTransparency = defOn and 0 or 0.65 end
        kbLbl.TextColor3 = WHITE; kbLbl.Font = Enum.Font.GothamBold
        kbLbl.TextSize = getMobileOptimized(11,10); kbLbl.ZIndex = 10
        kbLbl.TextScaled = true
        do local c = Instance.new("UITextSizeConstraint", kbLbl); c.MaxTextSize = getMobileOptimized(11,10); c.MinTextSize = 6 end
        bd.ClipsDescendants = true
        if noSwitch and defOn then kbLbl.TextColor3 = Color3.fromRGB(0, 0, 0) end
        KB[kbKey] = kbLbl
    end

    local function startKB()
        if not kbKey or not kbLbl then return end
        waitingForKey = kbKey; kbLbl.Text = "..."; _G._VioletteBeginKeyCapture()
        local conn; conn = UserInputService.InputBegan:Connect(function(i, g)
            if waitingForKey ~= kbKey then conn:Disconnect(); return end

            if i.UserInputType ~= Enum.UserInputType.Keyboard
               and true
               and not _isGamepadInput(i) then return end
            local kc = i.KeyCode
            if kc == Enum.KeyCode.Escape then kbLbl.Text = (Keybinds[kbKey] ~= Enum.KeyCode.Unknown) and _G._VioletteKeyName(Keybinds[kbKey]) or "None"; waitingForKey = nil; _G._VioletteEndKeyCapture(); conn:Disconnect(); return end
            if kc == Enum.KeyCode.Backspace then
                Keybinds[kbKey] = Enum.KeyCode.Unknown; kbLbl.Text = "None"
                waitingForKey = nil; _G._VioletteEndKeyCapture(); conn:Disconnect()
                if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
                if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
                return
            end
            if kc == Enum.KeyCode.Unknown then return end
            _kbSteal(kc, kbKey)
            Keybinds[kbKey] = kc; kbLbl.Text = _G._VioletteKeyName(kc)
            if _G._VynxRefreshAPKeys then pcall(_G._VynxRefreshAPKeys) end
            waitingForKey = nil; _G._VioletteEndKeyCapture(); conn:Disconnect()

            if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
            if _G.KRIXSaveNow        then pcall(_G.KRIXSaveNow) end
        end)
    end

    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1
    btn.Text = ""; btn.ZIndex = 8
    addPressPop(f, btn)
    local ih = false; local hs = 0
    btn.MouseButton1Click:Connect(function()
        if not ih then
            setV(not isOn)

            if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
            if _G.KRIXSaveNow        then pcall(_G.KRIXSaveNow) end
        end
        ih = false; hs = 0
    end)
    btn.MouseButton2Click:Connect(startKB)
    btn.MouseButton1Down:Connect(function()
        ih = false; hs = tick()
        task.delay(0.6, function() if hs > 0 and tick()-hs >= 0.6 then ih = true; startKB() end end)
    end)
    btn.MouseButton1Up:Connect(function() if tick()-hs < 0.6 then hs = 0 end end)

    if kbLbl then
        local kbBtn = Instance.new("TextButton", kbLbl.Parent)
        kbBtn.Size = UDim2.new(1,0,1,0); kbBtn.BackgroundTransparency = 1
        kbBtn.Text = ""; kbBtn.ZIndex = 11
        kbBtn.MouseButton1Click:Connect(startKB)
        kbBtn.MouseButton2Click:Connect(startKB)
    end
    return setV, f
end

local function makeModeRow(page, order, labelTxt)
    local r = Instance.new("Frame", page)
    r.Size = UDim2.new(1, 0, 0, getMobileOptimized(38, 34))
    r.BackgroundColor3 = CARD
    r.BorderSizePixel = 0
    r.LayoutOrder = order
    r.ZIndex = 4
    Instance.new("UICorner", r).CornerRadius = UDim.new(0, 12)
    local st = Instance.new("UIStroke", r)
    st.Color = Color3.fromRGB(35, 35, 45); st.Thickness = 1; st.Transparency = 0.4
    nameWithUnderline(r, labelTxt)
    return r
end

local function KR(page, order, name, kbKey, width)
    local f = makeRowBase(page, order)
    nameWithUnderline(f, name)
    local BW = width or 84
    local BH = 22
    local bd = Instance.new("Frame", f)
    bd.Size = UDim2.new(0, BW, 0, BH)
    bd.Position = UDim2.new(1, -(BW + 12), 0.5, -BH/2)
    bd.BackgroundColor3 = ACC
    bd.BackgroundTransparency = 0.2
    bd.BorderSizePixel = 0
    bd.ZIndex = 9
    Instance.new("UICorner", bd).CornerRadius = UDim.new(0, 8)
    local kbLbl = Instance.new("TextLabel", bd)
    kbLbl.Size = UDim2.new(1, 0, 1, 0)
    kbLbl.BackgroundTransparency = 1
    kbLbl.Text = (Keybinds[kbKey] and Keybinds[kbKey] ~= Enum.KeyCode.Unknown) and _G._VioletteKeyName(Keybinds[kbKey]) or "None"
    kbLbl.TextColor3 = WHITE
    kbLbl.Font = Enum.Font.GothamBold
    kbLbl.TextSize = getMobileOptimized(11, 10)
    kbLbl.ZIndex = 10
    kbLbl.TextScaled = true
    do local c = Instance.new("UITextSizeConstraint", kbLbl); c.MaxTextSize = getMobileOptimized(11,10); c.MinTextSize = 6 end
    bd.ClipsDescendants = true
    KB[kbKey] = kbLbl

    local function startKB()
        waitingForKey = kbKey; kbLbl.Text = "..."; _G._VioletteBeginKeyCapture()
        local conn; conn = UserInputService.InputBegan:Connect(function(i, g)
            if waitingForKey ~= kbKey then conn:Disconnect(); return end
            if i.UserInputType ~= Enum.UserInputType.Keyboard
               and true
               and not _isGamepadInput(i) then return end
            local kc = i.KeyCode
            if kc == Enum.KeyCode.Escape then
                kbLbl.Text = (Keybinds[kbKey] and Keybinds[kbKey] ~= Enum.KeyCode.Unknown) and _G._VioletteKeyName(Keybinds[kbKey]) or "None"
                waitingForKey = nil; _G._VioletteEndKeyCapture(); conn:Disconnect(); return
            end
            if kc == Enum.KeyCode.Backspace then
                Keybinds[kbKey] = Enum.KeyCode.Unknown; kbLbl.Text = "None"
                waitingForKey = nil; _G._VioletteEndKeyCapture(); conn:Disconnect()
                if _G._VynxRefreshAPKeys then pcall(_G._VynxRefreshAPKeys) end
                if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
                if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
                return
            end
            if kc == Enum.KeyCode.Unknown then return end
            _kbSteal(kc, kbKey)
            Keybinds[kbKey] = kc; kbLbl.Text = _G._VioletteKeyName(kc)
            if _G._VynxRefreshAPKeys then pcall(_G._VynxRefreshAPKeys) end
            waitingForKey = nil; _G._VioletteEndKeyCapture(); conn:Disconnect()
            if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
            if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
        end)
    end

    local kbBtn = Instance.new("TextButton", bd)
    kbBtn.Size = UDim2.new(1, 0, 1, 0)
    kbBtn.BackgroundTransparency = 1
    kbBtn.Text = ""
    kbBtn.AutoButtonColor = false
    kbBtn.ZIndex = 11
    kbBtn.MouseButton1Click:Connect(startKB)
    kbBtn.MouseButton2Click:Connect(startKB)
    return f
end

local function NR(page, order, name, val, cb)
    local f = makeRowBase(page, order)
    nameWithUnderline(f, name)
    local tb = mkNumberBox(f, val)
    tb.FocusLost:Connect(function()
        if cb then cb(tb.Text, tb) end

        if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
        if _G.KRIXSaveNow        then pcall(_G.KRIXSaveNow) end
    end)
    return tb, f
end


local function CR(page, order, name, initValue, values, onChange)
    local AW = 34
    local f = Instance.new("Frame", page)
    f.Size = UDim2.new(1, 0, 0, getMobileOptimized(68, 62))
    f.BackgroundColor3 = CARD
    f.BorderSizePixel = 0
    f.LayoutOrder = order
    f.ZIndex = 4
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
    local st = Instance.new("UIStroke", f)
    st.Color = Color3.fromRGB(35, 35, 45); st.Thickness = 1; st.Transparency = 0.4

    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(0.7, 0, 0, 16)
    lbl.Position = UDim2.new(0, 12, 0, 8)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = WHITE
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = getMobileOptimized(12, 11)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 5
    local und = Instance.new("Frame", f)
    und.Size = UDim2.new(0, textWidth(name, lbl.TextSize, lbl.Font), 0, 1)
    und.Visible = false
    und.Position = UDim2.new(0, 12, 0, 26)
    und.BackgroundColor3 = ACC
    und.BorderSizePixel = 0
    und.ZIndex = 5

    local val = Instance.new("TextLabel", f)
    val.Size = UDim2.new(1, -(24 + AW * 2 + 16), 0, 26)
    val.Position = UDim2.new(0, 12 + AW + 8, 1, -34)
    val.BackgroundTransparency = 1
    val.Text = tostring(initValue):upper()
    val.TextColor3 = WHITE
    val.Font = Enum.Font.GothamBold
    val.TextSize = getMobileOptimized(12, 11)
    val.ZIndex = 6

    local function step(dir)
        local idx = 1
        for i, v in ipairs(values) do
            if tostring(v):upper() == val.Text then idx = i; break end
        end
        idx = ((idx - 1 + dir) % #values) + 1
        val.Text = tostring(values[idx]):upper()
        if onChange then onChange(values[idx]) end
        if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
        if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
    end

    local function mkArrow(txt, xPos, dir)
        local a = Instance.new("TextButton", f)
        a.Size = UDim2.new(0, AW, 0, 26)
        a.Position = UDim2.new(xPos, (xPos == 0) and 12 or -(AW + 12), 1, -34)
        a.BackgroundColor3 = BG_DARK
        a.BorderSizePixel = 0
        a.AutoButtonColor = false
        a.Text = txt
        a.TextColor3 = ACC
        a.Font = Enum.Font.GothamBlack
        a.TextSize = getMobileOptimized(14, 13)
        a.ZIndex = 7
        Instance.new("UICorner", a).CornerRadius = UDim.new(0, 8)
        addFillHover(a, a)
        local ast = Instance.new("UIStroke", a)
        ast.Color = ACC; ast.Thickness = 1; ast.Transparency = 0.5
        ast.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        addGlow(a, 8)
        a.MouseButton1Click:Connect(function() step(dir) end)
    end
    mkArrow("<", 0, -1)
    mkArrow(">", 1, 1)

    return val
end

makeTab("Speed",    1)
makeTab("Steal",    2)
makeTab("Combat",   3)
makeTab("Visual",   4)
makeTab("Auto",     5)
makeTab("Settings", 6)

local pSpeed    = makePage("Speed")
local pSteal    = makePage("Steal")
local pMovement = makePage("Combat")
local pVisual   = makePage("Visual")
local pAuto     = makePage("Auto")
local pSettings = makePage("Settings")

for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        local pop = btn:FindFirstChild("TabPop")
        if not pop then
            pop = Instance.new("UIScale", btn)
            pop.Name = "TabPop"
        end
        pop.Scale = 0.92
        TweenService:Create(pop,
            TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Scale = (name == currentTab) and 1.06 or 1}):Play()
        switchTab(name)
    end)
end

switchTab("Speed")

local nsb, csb, lsb, carryV, laggerV, modeSR, laggerSR

sectionHeader(pSpeed, "SPEED CONFIGURATION", 8)

local laggerSpeedV, desyncSpeedV, normalSpeedV
local lagNormalInput, lagCarryInput, dsyNormalInput, dsyCarryInput, normNormalInput, normCarryInput

local function _formatSpeed(v)
    return (v == math.floor(v)) and tostring(math.floor(v)) or string.format("%.1f", v)
end

local function applyLaggerSpeedPreset(on)
    Spd.Lagger()
end
_G._VynxApplyLaggerSpeed = applyLaggerSpeedPreset

local function applyDesyncSpeedPreset(on)
    Spd.Custom()
end
_G._VynxApplyDesyncSpeed = applyDesyncSpeedPreset

local function applyNormalSpeedPreset(on)
    Spd.Normal()
end
_G._VynxApplyNormalSpeed = applyNormalSpeedPreset

local function makePresetCard(parent, order, title, subtitle, kbKey, getNorm, setNorm, getCarry, setCarry, isActive, onToggle)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1,0,0,getMobileOptimized(46,44))
    f.BackgroundColor3 = CARD
    f.BorderSizePixel = 0
    f.LayoutOrder = order
    f.ZIndex = 4
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
    local st = Instance.new("UIStroke", f); st.Color = Color3.fromRGB(38, 38, 38)
    st.Thickness = 1; st.Transparency = 0.5

    local titleLbl = Instance.new("TextLabel", f)
    titleLbl.Size = UDim2.new(0, 110, 0, 18)
    titleLbl.Position = UDim2.new(0, 12, 0.5, -9)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = WHITE
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = getMobileOptimized(13, 12)
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 5

    local ul = Instance.new("Frame", f)
    ul.Size = UDim2.new(0, textWidth(title, titleLbl.TextSize, titleLbl.Font), 0, 1)
    ul.Visible = false
    ul.Position = UDim2.new(0, 12, 0.5, 9)
    ul.BackgroundColor3 = ACC; ul.BorderSizePixel = 0; ul.ZIndex = 5

    local function makeInputBox(xOffset, defaultVal, header, onDone)

        local bx = Instance.new("Frame", f)
        bx.Size = UDim2.new(0, 44, 0, 26)
        bx.Position = UDim2.new(1, xOffset, 0.5, -13)
        bx.BackgroundColor3 = BG_DARK
        bx.BorderSizePixel = 0
        bx.ZIndex = 6
        Instance.new("UICorner", bx).CornerRadius = UDim.new(0, 8)
        local bxSt = Instance.new("UIStroke", bx); bxSt.Color = ACC
        bxSt.Thickness = 1; bxSt.Transparency = 0.45; bxSt.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        addGlow(bx, 8)
        local tb = Instance.new("TextBox", bx)
        tb.Size = UDim2.new(1, 0, 1, 0)
        tb.Position = UDim2.new(0, 0, 0, 0)
        tb.BackgroundTransparency = 1
        tb.Text = (type(defaultVal)=="number" and defaultVal==math.floor(defaultVal)) and tostring(math.floor(defaultVal)) or tostring(defaultVal)
        tb.TextColor3 = WHITE
        tb.Font = Enum.Font.GothamBold
        tb.TextSize = getMobileOptimized(12, 10)
        tb.TextXAlignment = Enum.TextXAlignment.Center
        tb.ClearTextOnFocus = false
        tb.ZIndex = 7
        tb.FocusLost:Connect(function()
            if onDone then onDone(tb.Text, tb) end
            if _G.KRIXSaveNow then _G.KRIXSaveNow() end
        end)
        return tb, bxSt
    end

    local carryTb, carryStroke = makeInputBox(-56, getCarry(), "carry", function(v, b)
        local n = tonumber(v)
        if n then
            setCarry(n)
            b.Text = (n == math.floor(n)) and tostring(math.floor(n)) or string.format("%.1f", n)

            if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
        else
            local cur = getCarry()
            b.Text = (cur == math.floor(cur)) and tostring(math.floor(cur)) or string.format("%.1f", cur)
        end
    end)
    local normalTb, normalStroke = makeInputBox(-112, getNorm(), "normal", function(v, b)
        local n = tonumber(v)
        if n then
            setNorm(n)
            b.Text = (n == math.floor(n)) and tostring(math.floor(n)) or string.format("%.1f", n)

            if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
        else
            local cur = getNorm()
            b.Text = (cur == math.floor(cur)) and tostring(math.floor(cur)) or string.format("%.1f", cur)
        end
    end)

    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Position = UDim2.new(0, 0, 0, 0)
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 4

    local function setVisual(on, carryOn)
        if on then
            TweenService:Create(f, TweenInfo.new(0.18), {BackgroundColor3 = CARD2}):Play()
            TweenService:Create(st, TweenInfo.new(0.18), {Transparency = 0.2, Color = ACC, Thickness = 1.4}):Play()
        else
            TweenService:Create(f, TweenInfo.new(0.18), {BackgroundColor3 = CARD}):Play()
            TweenService:Create(st, TweenInfo.new(0.18), {Transparency = 0.5, Color = Color3.fromRGB(38, 38, 38), Thickness = 1}):Play()
        end
        ul.Visible = on and true or false
        local function lit(stroke, live)
            if not stroke then return end
            TweenService:Create(stroke, TweenInfo.new(0.18), {
                Transparency = live and 0.05 or 0.45,
                Thickness    = live and 1.8 or 1,
            }):Play()
        end
        lit(normalStroke, on and not carryOn)
        lit(carryStroke,  on and carryOn == true)
    end

    local kbWrap = Instance.new("Frame", f)
    kbWrap.Size = UDim2.new(0, 46, 0, 22)
    kbWrap.Position = UDim2.new(0, 128, 0.5, -11)
    kbWrap.BackgroundColor3 = ACC
    kbWrap.BackgroundTransparency = 0.2
    kbWrap.BorderSizePixel = 0
    kbWrap.ZIndex = 8
    Instance.new("UICorner", kbWrap).CornerRadius = UDim.new(0, 8)

    if kbKey and not Keybinds[kbKey] then
        if kbKey == "NormalSpeed" then Keybinds[kbKey] = Enum.KeyCode.K
        elseif kbKey == "LaggerSpeed" then Keybinds[kbKey] = Enum.KeyCode.B
        elseif kbKey == "DesyncSpeed" then Keybinds[kbKey] = Enum.KeyCode.N
        end
    end
    local kbLbl = Instance.new("TextLabel", kbWrap)
    kbLbl.Size = UDim2.new(1, 0, 1, 0)
    kbLbl.BackgroundTransparency = 1
    kbLbl.Text = (Keybinds[kbKey] and Keybinds[kbKey] ~= Enum.KeyCode.Unknown) and _G._VioletteKeyName(Keybinds[kbKey]) or "None"
    kbLbl.TextColor3 = WHITE
    kbLbl.Font = Enum.Font.GothamBold
    kbLbl.TextSize = 12
    kbLbl.ZIndex = 9
    kbLbl.TextScaled = true
    do local c = Instance.new("UITextSizeConstraint", kbLbl); c.MaxTextSize = 12; c.MinTextSize = 6 end
    kbWrap.ClipsDescendants = true
    KB[kbKey] = kbLbl

    local kbClick = Instance.new("TextButton", kbWrap)
    kbClick.Size = UDim2.new(1, 4, 1, 4)
    kbClick.Position = UDim2.new(0, -2, 0, -2)
    kbClick.BackgroundTransparency = 1
    kbClick.Text = ""
    kbClick.ZIndex = 10
    kbClick.AutoButtonColor = false

    local function startKB()
        waitingForKey = kbKey; _G._VioletteBeginKeyCapture()
        kbLbl.Text = "..."

        local conn; conn = UserInputService.InputBegan:Connect(function(i)
            if waitingForKey ~= kbKey then conn:Disconnect(); return end

            if i.UserInputType ~= Enum.UserInputType.Keyboard
               and true
               and not _isGamepadInput(i) then return end
            local kc = i.KeyCode
            if kc == Enum.KeyCode.Escape then
                kbLbl.Text = (Keybinds[kbKey] ~= Enum.KeyCode.Unknown) and _G._VioletteKeyName(Keybinds[kbKey]) or "None"
                waitingForKey = nil; _G._VioletteEndKeyCapture()
                conn:Disconnect()
                return
            end
            if kc == Enum.KeyCode.Backspace then
                Keybinds[kbKey] = Enum.KeyCode.Unknown; kbLbl.Text = "None"
                waitingForKey = nil; _G._VioletteEndKeyCapture(); conn:Disconnect()
                if _G._VynxRefreshAPKeys then pcall(_G._VynxRefreshAPKeys) end
                if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
                if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
                if saveConfig then pcall(saveConfig) end
                return
            end
            if kc == Enum.KeyCode.Unknown then return end
            _kbSteal(kc, kbKey)
            Keybinds[kbKey] = kc
            kbLbl.Text = _G._VioletteKeyName(kc)
            if _G._VynxRefreshAPKeys then pcall(_G._VynxRefreshAPKeys) end
            waitingForKey = nil; _G._VioletteEndKeyCapture()
            conn:Disconnect()
            if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
            if _G.KRIXSaveNow        then pcall(_G.KRIXSaveNow) end
            if saveConfig then pcall(saveConfig) end
        end)
    end

    local ih, hs = false, 0
    btn.MouseButton1Click:Connect(function()
        if not ih then
            local newOn = not (isActive and isActive() or false)
            if onToggle then onToggle(newOn) end
        end
        ih = false; hs = 0
    end)
    btn.MouseButton2Click:Connect(startKB)
    btn.MouseButton1Down:Connect(function()
        ih = false; hs = tick()
        task.delay(0.6, function() if hs > 0 and tick()-hs >= 0.6 then ih = true; startKB() end end)
    end)
    btn.MouseButton1Up:Connect(function() if tick()-hs < 0.6 then hs = 0 end end)

    kbClick.MouseButton1Click:Connect(startKB)

    return setVisual, carryTb, normalTb
end

laggerSpeedV, lagCarryInput, lagNormalInput = makePresetCard(
    pSpeed, 12,
    "Lagger Speed", "use again lagger", "LaggerSpeed",
    function() return _G.LaggerSpeed_Normal end,
    function(n)
        _G.LaggerSpeed_Normal = math.clamp(n, 1, 9999)
        Spd.Refresh()
        if _G.KRIXSaveNow then _G.KRIXSaveNow() end
    end,
    function() return _G.LaggerSpeed_Carry end,
    function(n)
        _G.LaggerSpeed_Carry = math.clamp(n, 1, 9999)
        Spd.Refresh()
        if _G.KRIXSaveNow then _G.KRIXSaveNow() end
    end,
    function() return Spd.family == "lagger" end,
    function(on) applyLaggerSpeedPreset(on) end
)

desyncSpeedV, dsyCarryInput, dsyNormalInput = makePresetCard(
    pSpeed, 14,
    "Custom Speed", "use if desynced", "DesyncSpeed",
    function() return _G.DesyncSpeed_Normal end,
    function(n)
        _G.DesyncSpeed_Normal = math.clamp(n, 1, 9999)
        Spd.Refresh()
        if _G.KRIXSaveNow then _G.KRIXSaveNow() end
    end,
    function() return _G.DesyncSpeed_Carry end,
    function(n)
        _G.DesyncSpeed_Carry = math.clamp(n, 0.1, 9999)
        Spd.Refresh()
        if _G.KRIXSaveNow then _G.KRIXSaveNow() end
    end,
    function() return Spd.family == "custom" end,
    function(on) applyDesyncSpeedPreset(on) end
)

normalSpeedV, normCarryInput, normNormalInput = makePresetCard(
    pSpeed, 10,
    "Normal Speed", "your preferred preset", "NormalSpeed",
    function() return _G.NormalSpeed_Normal end,
    function(n)
        _G.NormalSpeed_Normal = math.clamp(n, 0.1, 9999)
        Spd.Refresh()
        if _G.KRIXSaveNow then _G.KRIXSaveNow() end
    end,
    function() return _G.NormalSpeed_Carry end,
    function(n)
        _G.NormalSpeed_Carry = math.clamp(n, 0.1, 9999)
        Spd.Refresh()
        if _G.KRIXSaveNow then _G.KRIXSaveNow() end
    end,
    function() return Spd.family == "normal" end,
    function(on) applyNormalSpeedPreset(on) end
)

VisualSetters.LaggerSpeed = laggerSpeedV
VisualSetters.DesyncSpeed = desyncSpeedV

Spd.Refresh = function()
    local n, c = Spd.Values()
    NORMAL_SPEED = n
    CARRY_SPEED  = c
    LAGGER_SPEED = tonumber(_G.LaggerSpeed_Normal) or LAGGER_SPEED

    _G.NormalSpeedActive = (Spd.family == "normal")
    _G.LaggerSpeedActive = (Spd.family == "lagger")
    _G.DesyncSpeedActive = (Spd.family == "custom")

    if normalSpeedV then pcall(normalSpeedV, _G.NormalSpeedActive, Spd.carry) end
    if laggerSpeedV then pcall(laggerSpeedV, _G.LaggerSpeedActive, Spd.carry) end
    if desyncSpeedV then pcall(desyncSpeedV, _G.DesyncSpeedActive, Spd.carry) end

    if nsb then nsb.Text = _formatSpeed(NORMAL_SPEED) end
    if csb then csb.Text = _formatSpeed(CARRY_SPEED) end
    if lsb then lsb.Text = _formatSpeed(LAGGER_SPEED) end
    if carryV  then pcall(carryV,  Spd.carry) end
    if laggerV then pcall(laggerV, Spd.family == "lagger") end
    if modeSR then
        local fam = (Spd.family == "lagger" and "Lagger")
                 or (Spd.family == "custom" and "Custom")
                 or "Normal"
        modeSR.Text = Spd.carry and (fam .. " Carry") or fam
    end
    if _G._VioletteSyncMobileSpeedBtns then pcall(_G._VioletteSyncMobileSpeedBtns) end
end
_G._VioletteRefreshSpeedModes = Spd.Refresh
_G._VynxRefreshSpeedModes  = Spd.Refresh

_G._VynxRefreshSpeedInputs = function()
    local function _fmt(v)
        if type(v) ~= "number" then return "" end
        return (v == math.floor(v)) and tostring(math.floor(v)) or string.format("%.1f", v)
    end
    if lagNormalInput  then lagNormalInput.Text  = _fmt(_G.LaggerSpeed_Normal) end
    if lagCarryInput   then lagCarryInput.Text   = _fmt(_G.LaggerSpeed_Carry)  end
    if dsyNormalInput  then dsyNormalInput.Text  = _fmt(_G.DesyncSpeed_Normal) end
    if dsyCarryInput   then dsyCarryInput.Text   = _fmt(_G.DesyncSpeed_Carry)  end
    if normNormalInput then normNormalInput.Text = _fmt(_G.NormalSpeed_Normal) end
    if normCarryInput  then normCarryInput.Text  = _fmt(_G.NormalSpeed_Carry)  end
end

Spd.Refresh()

_G._VynxSpeedMethod = (_G._VynxSpeedMethod == "V2") and "V2" or "V1"
do
    local r = makeModeRow(pSpeed, 9, "Speed Change Method")
    local btns = {}
    local BW, BH, GAP = getMobileOptimized(58, 50), 24, 6
    local vals = {"V1", "V2"}
    local total = #vals * BW + (#vals - 1) * GAP
    do
        local smLbl = r:FindFirstChildOfClass("TextLabel")
        if smLbl then
            smLbl.Size = UDim2.new(1, -(total + 30), 0, 16)
            smLbl.TextTruncate = Enum.TextTruncate.AtEnd
        end
    end
    local function refreshSM()
        for k, b in pairs(btns) do
            local on = (k == _G._VynxSpeedMethod)
            TweenService:Create(b, TweenInfo.new(0.15), {
                BackgroundColor3 = on and ACC or Color3.fromRGB(30, 30, 30),
                TextColor3 = on and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(165, 165, 170),
            }):Play()
        end
    end
    for i, v in ipairs(vals) do
        local b = Instance.new("TextButton", r)
        b.Size = UDim2.new(0, BW, 0, BH)
        b.Position = UDim2.new(1, -(total + 12) + (i - 1) * (BW + GAP), 0.5, -BH/2)
        b.BackgroundColor3 = CARD2
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.Text = v
        b.TextColor3 = DIM
        b.Font = Enum.Font.GothamBold
        b.TextSize = getMobileOptimized(11, 10)
        b.ZIndex = 5
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        btns[v] = b
        b.MouseButton1Click:Connect(function()
            _G._VynxSpeedMethod = v
            Spd.Refresh()
            refreshSM()
            if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
            if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
        end)
    end
    _G._VynxRefreshSpeedMethod = refreshSM
    refreshSM()
end
VisualSetters.NormalSpeed = normalSpeedV

do
if _G._VynxAutoSpeedMode == "On Carry" then _G._VynxAutoSpeedMode = "On Pick Up" end
_G._VynxAutoSpeedMode = _G._VynxAutoSpeedMode or "On Pick Up"
_G._VynxAutoSpeedOn = _G._VynxAutoSpeedOn or false
local sAutoSpd, _autoSpdRow = TR(pSpeed, 16, "Auto Speed", "", nil, _G._VynxAutoSpeedOn, function(on)
    _G._VynxAutoSpeedOn = on
    if _G.KRIXSaveNow then _G.KRIXSaveNow() end
end)
VisualSetters.AutoSpeed = sAutoSpd
_G._VynxRefreshAutoSpeedMode = makeDropdown(_autoSpdRow, {"On Pick Up", "Soft Steal"},
    function()
        if _G._VynxAutoSpeedMode == "On Carry" then _G._VynxAutoSpeedMode = "On Pick Up" end
        return _G._VynxAutoSpeedMode or "On Pick Up"
    end,
    function(v)
        _G._VynxAutoSpeedMode = v
        if _G.KRIXSaveNow then _G.KRIXSaveNow() end
    end, nil, SW_W + 20, "Auto Speed")
end


sectionHeader(pMovement, "COUNTERS CONFIGURATION", 55)
sectionHeader(pMovement, "AIMBOT CONFIGURATION", 18)

_aimRows = {}
_aimPanels = {}
_batRow = KR(pMovement, 20, "Bat Aimbot", "AutoBat", SW_W)

do
local applied = false
batClk = function(on)
    on = on and true or false
    if applied == on then return end
    applied = on
    autoBatToggled = on
    _G._VezyBatAimbotOn = on
    if on then

        if _G.VezyStartBatAimbotDispatch then
            _G.VezyStartBatAimbotDispatch()
        else
            _G.VezyStartBatAimbot()
        end

    else
        _G.VezyStopBatAimbot()
    end
end
end
VisualSetters.AutoBat = batClk

do
    local function makeAimSpeedRow(order, labelTxt, getV, setV)
        local r = Instance.new("Frame", pMovement)
        r.Size = UDim2.new(1, 0, 0, getMobileOptimized(38, 34))
        r.BackgroundColor3 = CARD
        r.BorderSizePixel = 0
        r.LayoutOrder = order
        r.ZIndex = 4
        Instance.new("UICorner", r).CornerRadius = UDim.new(0, 12)
        local st = Instance.new("UIStroke", r)
        st.Color = Color3.fromRGB(35, 35, 45); st.Thickness = 1; st.Transparency = 0.4

        local lbl = Instance.new("TextLabel", r)
        lbl.Size = UDim2.new(0.55, 0, 0, 16)
        lbl.Position = UDim2.new(0, 12, 0.5, -9)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelTxt
        lbl.TextColor3 = WHITE
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = getMobileOptimized(12, 11)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 5

        local und = Instance.new("Frame", r)
        und.Size = UDim2.new(0, textWidth(labelTxt, lbl.TextSize, lbl.Font), 0, 1)
        und.Visible = false
        und.Position = UDim2.new(0, 12, 0.5, 7)
        und.BackgroundColor3 = ACC
        und.BorderSizePixel = 0
        und.ZIndex = 5

        local input = Instance.new("TextBox", r)
        input.Size = UDim2.new(0, 70, 0, 24)
        input.Position = UDim2.new(1, -82, 0.5, -12)
        input.BackgroundColor3 = BG_DARK
        input.BorderSizePixel = 0
        input.Text = tostring(getV())
        input.TextColor3 = WHITE
        input.Font = Enum.Font.GothamBold
        input.TextSize = 12
        input.ClearTextOnFocus = false
        input.ZIndex = 5
        Instance.new("UICorner", input).CornerRadius = UDim.new(0, 8)
        local inSt = Instance.new("UIStroke", input); inSt.Color = ACC; inSt.Thickness = 1; inSt.Transparency = 0.45; inSt.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        addGlow(input, 8)
        input.FocusLost:Connect(function()
            local n = tonumber(input.Text)
            if n and n > 0 and n < 200 then
                setV(n)
                input.Text = tostring(n)
            else
                input.Text = tostring(getV())
            end
            if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
            if _G.KRIXSaveNow then _G.KRIXSaveNow() end
        end)
        r.Visible = false
        table.insert(_aimRows, r)
        return input
    end

    _G._VezyAimbotSpeedInputRef = makeAimSpeedRow(24, "Aimbot Normal Speed",
        function() return _G._VezyBatAimbotSpeed or 58 end,
        function(v) _G._VezyBatAimbotSpeed = v end)

    makeAimSpeedRow(26, "Aimbot Lagger Speed",
        function() return _G._VezyBatAimbotSpeedLagger or 40 end,
        function(v) _G._VezyBatAimbotSpeedLagger = v end)

    makeAimSpeedRow(28, "Aimbot Custom Speed",
        function() return _G._VezyBatAimbotSpeedCustom or 58 end,
        function(v) _G._VezyBatAimbotSpeedCustom = v end)

    if _G._VioletteAimbotAutoSwing == nil then _G._VioletteAimbotAutoSwing = true end
    local sAimSwing, _aimSwingRow = TR(pMovement, 29, "Auto Swing", "", nil,
        _G._VioletteAimbotAutoSwing == true, function(on)
            _G._VioletteAimbotAutoSwing = on and true or false
            if _G.KRIXSaveNow then _G.KRIXSaveNow() end
        end)
    VisualSetters.AimbotAutoSwing = sAimSwing
    _aimSwingRow.Visible = false
    table.insert(_aimRows, _aimSwingRow)
end


_tpRows = {}
_tpPanels = {}
_G._VynxRemoveCamShake = _G._VynxRemoveCamShake or false
sCamShake, _camShakeRow = TR(pMovement, 38, "Remove Camera Shake", "", nil, _G._VynxRemoveCamShake, function(on)
    _G._VynxRemoveCamShake = on
    if _G.KRIXSaveNow then _G.KRIXSaveNow() end
end)
VisualSetters.RemoveCamShake = sCamShake
_camShakeRow.Visible = false
table.insert(_tpRows, _camShakeRow)

do
    local BS, H = 32, 22
    local eb = Instance.new("TextButton", _batRow)
    eb.Size = UDim2.new(0, BS, 0, H)
    eb.Position = UDim2.new(1, -(BS + SW_W + 20), 0.5, -H/2)
    eb.BackgroundColor3 = BG_DARK
    eb.BorderSizePixel = 0
    eb.AutoButtonColor = false
    eb.Text = ""
    eb.ZIndex = 12
    Instance.new("UICorner", eb).CornerRadius = UDim.new(0, 6)
    local ebSt = Instance.new("UIStroke", eb)
    ebSt.Color = ACC; ebSt.Thickness = 1; ebSt.Transparency = 0.5
    ebSt.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    addGlow(eb, 6)
    local ec = Instance.new("TextLabel", eb)
    ec.Size = UDim2.new(1, 0, 1, 0)
    ec.BackgroundTransparency = 1
    ec.Text = utf8.char(0x25BC)
    ec.TextColor3 = ACC
    ec.Font = Enum.Font.GothamBlack
    ec.TextSize = 15
    ec.ZIndex = 20
    local _ebFill = addFillHover(eb, ec)
    local open = false
    eb.MouseButton1Click:Connect(function()
        open = not open
        ec.Rotation = open and 180 or 0
        eb:SetAttribute("Open", open)
        _ebFill(open)
        for _, r in ipairs(_aimRows) do r.Visible = open end
        if not open then for _, p in ipairs(_aimPanels) do p.Visible = false end end
    end)
end

sAS, _asRow = TR(pMovement, 36, "Auto Swing", "", nil, false, function(on)
    autoSwingEnabled = on
    _G._VezyAutoSwingEnabled = on
    if _G.KRIXSaveNow then _G.KRIXSaveNow() end
end)
VisualSetters.AutoSwing = sAS
_asRow.Visible = false
table.insert(_tpRows, _asRow)

_G._VynxMirrorTPDown = _G._VynxMirrorTPDown or false
sMTP, _mtpRow = TR(pMovement, 30, "Mirror TP Down", "", nil, _G._VynxMirrorTPDown, function(on)
    _G._VynxMirrorTPDown = on
    if _G.KRIXSaveNow then _G.KRIXSaveNow() end
end)
VisualSetters.MirrorTPDown = sMTP
_mtpRow.Visible = false
table.insert(_aimRows, _mtpRow)
sMV = TR(pMovement, 56, "Medusa Counter", "", nil, false, function(on)
    medusaCounterEnabled = on
    if on then setupMedusaCounter(LocalPlayer.Character) else stopMedusaCounter() end
    if _G.KRIXSaveNow then _G.KRIXSaveNow() end
end); VisualSetters.MedusaCounter = sMV
sBC = TR(pMovement, 57, "Bat Counter", "", nil, false, function(on)

    _G._VezyBatCounterOn = on
    if on then _G.VezyStartBatCounter() else _G.VezyStopBatCounter() end

    if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
    if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
end); VisualSetters.BatCounter = sBC

_G._VynxBodyLockOn = _G._VynxBodyLockOn or false
_G._VynxBodyLockRange = tonumber(_G._VynxBodyLockRange) or 15
sBL, _blRow = TR(pMovement, 58, "Body Lock", "", nil, _G._VynxBodyLockOn, function(on)
    _G._VynxBodyLockOn = on
    if on then
        if _G._VioletteStartBodyLock then _G._VioletteStartBodyLock() end
    else
        if _G._VioletteStopBodyLock then _G._VioletteStopBodyLock() end
    end
    if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
end); VisualSetters.BodyLock = sBL

_blRangeBox, _blRangeRow = NR(pMovement, 59, "Lock Range", _G._VynxBodyLockRange, function(txt, b)
    local n = tonumber(txt)
    if n and n > 0 then
        n = math.clamp(math.floor(n * 10 + 0.5) / 10, 1, 9999)
        _G._VynxBodyLockRange = n
        b.Text = tostring(n)
    else
        b.Text = tostring(_G._VynxBodyLockRange or 15)
    end
end)
_blRangeRow.Visible = false
_G._VynxRefreshBodyLockRange = function()
    if _blRangeBox then _blRangeBox.Text = tostring(_G._VynxBodyLockRange or 15) end
end
do
    local BS, H = 32, 22
    local eb = Instance.new("TextButton", _blRow)
    eb.Size = UDim2.new(0, BS, 0, H)
    eb.Position = UDim2.new(1, -(BS + SW_W + 20), 0.5, -H/2)
    eb.BackgroundColor3 = BG_DARK
    eb.BorderSizePixel = 0
    eb.AutoButtonColor = false
    eb.Text = ""
    eb.ZIndex = 12
    Instance.new("UICorner", eb).CornerRadius = UDim.new(0, 6)
    local ebSt = Instance.new("UIStroke", eb)
    ebSt.Color = ACC; ebSt.Thickness = 1; ebSt.Transparency = 0.5
    ebSt.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    addGlow(eb, 6)
    local ec = Instance.new("TextLabel", eb)
    ec.Size = UDim2.new(1, 0, 1, 0)
    ec.BackgroundTransparency = 1
    ec.Text = utf8.char(0x25BC)
    ec.TextColor3 = ACC
    ec.Font = Enum.Font.GothamBlack
    ec.TextSize = 15
    ec.ZIndex = 20
    local _blFill = addFillHover(eb, ec)
    local open = false
    eb.MouseButton1Click:Connect(function()
        open = not open
        ec.Rotation = open and 180 or 0
        eb:SetAttribute("Open", open)
        _blFill(open)
        _blRangeRow.Visible = open
    end)
end

_G._VezyRotateLockOn    = false
_G._VezyRotateLockRange = 50
_G._VezyRotateLockConn  = nil

_G.VezyStartRotateLock = function() end

_G.VezyStopRotateLock = function()
    if _G._VezyRotateLockConn then
        _G._VezyRotateLockConn:Disconnect()
        _G._VezyRotateLockConn = nil
    end
end

sRL = TR(pMovement, 58, "Rotate Lock", "", nil, false, function(on)
    _G._VezyRotateLockOn = on
    if on then _G.VezyStartRotateLock() else _G.VezyStopRotateLock() end
    if _G.KRIXSaveNow then _G.KRIXSaveNow() end
end); VisualSetters.RotateLock = sRL

task.defer(function()

    for _, child in ipairs(pMovement:GetChildren()) do
        if child:IsA("Frame") then
            for _, sub in ipairs(child:GetDescendants()) do
                if sub:IsA("TextLabel") and sub.Text == "Rotate Lock" then
                    child:Destroy()
                    return
                end
            end
        end
    end
end)

do
    local mRow = Instance.new("Frame", pMovement)
    mRow.Size = UDim2.new(1, 0, 0, getMobileOptimized(38, 34))
    mRow.BackgroundColor3 = CARD
    mRow.BorderSizePixel = 0
    mRow.LayoutOrder = 22
    mRow.ZIndex = 4
    Instance.new("UICorner", mRow).CornerRadius = UDim.new(0, 12)
    mRow.Visible = false
    table.insert(_aimRows, mRow)
    local mSt = Instance.new("UIStroke", mRow)
    mSt.Color = Color3.fromRGB(35, 35, 45); mSt.Thickness = 1; mSt.Transparency = 0.4

    local mLbl = Instance.new("TextLabel", mRow)
    mLbl.Size = UDim2.new(0, 110, 1, 0)
    mLbl.Position = UDim2.new(0, 12, 0, 0)
    mLbl.BackgroundTransparency = 1
    mLbl.Text = "Aimbot Mode"
    mLbl.TextColor3 = WHITE
    mLbl.Font = Enum.Font.GothamBold
    mLbl.TextSize = getMobileOptimized(11, 10)
    mLbl.TextXAlignment = Enum.TextXAlignment.Left
    mLbl.ZIndex = 5
    Instance.new("UIStroke", mLbl).Transparency = 1

    local mUnd = Instance.new("Frame", mLbl)
    mUnd.Size = UDim2.new(0, textWidth(mLbl.Text, mLbl.TextSize, mLbl.Font), 0, 1)
    mUnd.Visible = false
    mUnd.Position = UDim2.new(0, 0, 0.5, 9)
    mUnd.BackgroundColor3 = ACC
    mUnd.BorderSizePixel = 0
    mUnd.ZIndex = 5

    local amBtns = {}
    local MBW, MBH, MGAP = 62, 24, 6
    local mTotal = 2 * MBW + MGAP
    local function refreshAimMode()
        for k, b in pairs(amBtns) do
            local on = (k == ((_G._VezyBatAimbotMode == "old") and "Bypass" or "Normal"))
            b.BackgroundColor3 = on and ACC or Color3.fromRGB(30, 30, 30)
            b.TextColor3 = on and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(165, 165, 170)
        end
    end
    for i, v in ipairs({"Normal", "Bypass"}) do
        local b = Instance.new("TextButton", mRow)
        b.Size = UDim2.new(0, MBW, 0, MBH)
        b.Position = UDim2.new(1, -(mTotal + 12) + (i - 1) * (MBW + MGAP), 0.5, -MBH/2)
        b.BackgroundColor3 = CARD2
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.Text = v
        b.TextColor3 = DIM
        b.Font = Enum.Font.GothamBold
        b.TextSize = getMobileOptimized(11, 10)
        b.ZIndex = 5
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        amBtns[v] = b
        b.MouseButton1Click:Connect(function()
            _G._VezyBatAimbotMode = (v == "Bypass") and "old" or "new"
            refreshAimMode()
            if _G._VezyBatAimbotOn then
                if _G.VezyStopBatAimbot then pcall(_G.VezyStopBatAimbot) end
                task.wait(0.05)
                if _G.VezyStartBatAimbotDispatch then pcall(_G.VezyStartBatAimbotDispatch) end
            end
            if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
            if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
        end)
    end
    _G._VynxRefreshAimbotModeBtns = refreshAimMode
    refreshAimMode()
end

do
    local rlRow = Instance.new("Frame", pMovement)
    rlRow.Size = UDim2.new(1, 0, 0, getMobileOptimized(38, 34))
    rlRow.BackgroundColor3 = CARD
    rlRow.BorderSizePixel = 0
    rlRow.LayoutOrder = 59
    rlRow.ZIndex = 4
    rlRow.Visible = false
    Instance.new("UICorner", rlRow).CornerRadius = UDim.new(0, 12)
    local rlSt = Instance.new("UIStroke", rlRow)
    rlSt.Color = Color3.fromRGB(35, 35, 45); rlSt.Thickness = 1; rlSt.Transparency = 0.4

    local rlLbl = Instance.new("TextLabel", rlRow)
    rlLbl.Size = UDim2.new(0.55, 0, 1, 0)
    rlLbl.Position = UDim2.new(0, 12, 0, 0)
    rlLbl.BackgroundTransparency = 1
    rlLbl.Text = "Rotate Lock Range"
    rlLbl.TextColor3 = WHITE
    rlLbl.Font = Enum.Font.GothamBold
    rlLbl.TextSize = getMobileOptimized(12, 11)
    rlLbl.TextXAlignment = Enum.TextXAlignment.Left
    rlLbl.ZIndex = 5

    local rlInput = Instance.new("TextBox", rlRow)
    rlInput.Size = UDim2.new(0, 70, 0, 24)
    rlInput.Position = UDim2.new(1, -82, 0.5, -12)
    rlInput.BackgroundColor3 = BG_DARK
    rlInput.BorderSizePixel = 0
    rlInput.Text = tostring(_G._VezyRotateLockRange or 50)
    rlInput.TextColor3 = WHITE
    rlInput.Font = Enum.Font.GothamBold
    rlInput.TextSize = 12
    rlInput.PlaceholderText = "50"
    rlInput.ClearTextOnFocus = false
    rlInput.ZIndex = 5
    Instance.new("UICorner", rlInput).CornerRadius = UDim.new(0, 8)
    local rlSt = Instance.new("UIStroke", rlInput); rlSt.Color = ACC; rlSt.Thickness = 1; rlSt.Transparency = 0.45; rlSt.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    addGlow(rlInput, 8)
    rlInput.FocusLost:Connect(function()
        local n = tonumber(rlInput.Text)
        if n and n > 0 and n <= 500 then
            _G._VezyRotateLockRange = n
            rlInput.Text = tostring(n)
        else
            rlInput.Text = tostring(_G._VezyRotateLockRange or 50)
        end
        if _G.KRIXSaveNow then _G.KRIXSaveNow() end
    end)
end

BC.followMode = false
VisualSetters.CBMode = function(_) BC.followMode = false end

VisualSetters.BatCounterChase = function(_) end
local bLV = function(_) end
local bRV = function(_) end
VisualSetters.BrainrotL = bLV
VisualSetters.BrainrotR = bRV
VisualSetters.FastestSteal = function(_) end
_G.V7BRSetters = {left=bLV, right=bRV}

sectionHeader(pSteal, "STEAL CONFIGURATION", 1)

_G._VynxStealRadiusNormal = tonumber(_G._VynxStealRadiusNormal) or tonumber(Settings.StealRadius) or 62
_G._VynxStealRadiusSemi   = tonumber(_G._VynxStealRadiusSemi)   or 8.7
_G._VynxAutoGrabPause = tonumber(_G._VynxAutoGrabPause) or 75

_G._VynxNormalizeStealMode = function()
    local mode = tostring(_G._VynxAutoStealMode or "Normal")
    if mode == "75" or mode == "80" or mode == "85" or mode == "90" then
        _G._VynxAutoGrabPause = tonumber(mode)
        mode = "Normal"
    elseif mode ~= "Semi" then
        mode = "Normal"
    end
    _G._VynxAutoStealMode = mode
    local pause = tonumber(_G._VynxAutoGrabPause) or 75
    if pause ~= 75 and pause ~= 80 and pause ~= 85 then pause = 75 end
    _G._VynxAutoGrabPause = pause
    return mode
end
_G._VynxNormalizeStealMode()

local function _curStealMode()
    return (tostring(_G._VynxAutoStealMode or "Normal") == "Semi") and "Semi" or "Normal"
end
local function _curStealRadius()
    return (_curStealMode() == "Semi") and _G._VynxStealRadiusSemi or _G._VynxStealRadiusNormal
end
local function _applyStealRadius(n)
    if _curStealMode() == "Semi" then
        _G._VynxStealRadiusSemi = n
        if _G.CandySemiAutoStealSetRadius then pcall(_G.CandySemiAutoStealSetRadius, n) end
    else
        _G._VynxStealRadiusNormal = n
        Settings.StealRadius = n; Values.STEAL_RADIUS = n
        if _G.CandyNormalAutoStealSetRadius then pcall(_G.CandyNormalAutoStealSetRadius, n) end
    end
end
RadiusInput = NR(pSteal, 13, "Radius", _curStealRadius(), function(v,b)
    local n = tonumber(v)
    if n then
        n = math.clamp(n,0.5,500); n = math.floor(n*10+0.5)/10
        _applyStealRadius(n)
        b.Text = tostring(n); cachedPrompts = {}; promptCacheTime = 0
        if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
    else b.Text = tostring(_curStealRadius()) end
end)
_G._VynxRefreshStealRadius = function()
    if RadiusInput then RadiusInput.Text = tostring(_curStealRadius()) end
end
Settings.StealDuration = STEAL_DURATION_FIXED
Values.STEAL_DURATION  = STEAL_DURATION_FIXED

do
    local f = makeRowBase(pSteal, 10)
    nameWithUnderline(f, "Auto Steal")
    local setV = mkSwitch(f, Enabled.AutoSteal)
    _G._KRIXAutoStealSet = function(on) setV(on) end
    VisualSetters.AutoSteal = function(on) setV(on == true) end
    _G._VynxRefreshAutoSteal = function() setV(Enabled.AutoSteal == true) end
    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1
    btn.Text = ""; btn.ZIndex = 8
    btn.MouseButton1Click:Connect(function()
        Enabled.AutoSteal = not Enabled.AutoSteal
        Settings.AutoStealEnabled = Enabled.AutoSteal
        setV(Enabled.AutoSteal)
        if Enabled.AutoSteal then startAutoSteal() else stopAutoSteal() end
        if _G.KRIXSaveNow then _G.KRIXSaveNow() end
    end)
    _G._VynxNormalizeStealMode()
    local _setModeDrop, _modePanel = makeDropdown(f, {"Normal", "Semi"},
        function() return _curStealMode() end,
        function(v)
            _G._VynxAutoStealMode = (v == "Semi") and "Semi" or "Normal"
            if _G._VynxRefreshStealRadius then pcall(_G._VynxRefreshStealRadius) end
            if _G._VynxRefreshAutoGrabPause then pcall(_G._VynxRefreshAutoGrabPause) end
            if Enabled.AutoSteal then pcall(startAutoSteal) end
            if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
        end, nil, SW_W + 20, "Steal Mode")

    local _beforeBtns = {}
    for _, c in ipairs(f:GetChildren()) do
        if c:IsA("TextButton") then _beforeBtns[c] = true end
    end

    local _setPauseDrop, _pausePanel = makeDropdown(f, {"75%", "80%", "85%"},
        function() return tostring(tonumber(_G._VynxAutoGrabPause) or 75) .. "%" end,
        function(v)
            _G._VynxAutoGrabPause = tonumber((tostring(v):gsub("%%", ""))) or 75
            if Enabled.AutoSteal then pcall(startAutoSteal) end
            if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
        end, 58, SW_W + 20, "Grab Pause")

    for _, c in ipairs(f:GetChildren()) do
        if c:IsA("TextButton") and not _beforeBtns[c] then
            c.Visible = false
            c.Active = false
        end
    end

    _pausePanel.Name = "AutoGrabPausePanel"
    _pausePanel.LayoutOrder = (_modePanel.LayoutOrder or 11) + 1
    _pausePanel.Visible = false

    local function _syncPausePanel()
        _pausePanel.Visible = false
    end
    _modePanel:GetPropertyChangedSignal("Visible"):Connect(_syncPausePanel)

    _G._VynxRefreshAutoGrabPause = function()
        _G._VynxNormalizeStealMode()
        if _setPauseDrop then pcall(_setPauseDrop) end
        _syncPausePanel()
    end

    _G._VynxRefreshAutoStealMode = function()
        _G._VynxNormalizeStealMode()
        if _setModeDrop then pcall(_setModeDrop) end
        if _G._VynxRefreshAutoGrabPause then pcall(_G._VynxRefreshAutoGrabPause) end
    end
    _G._VynxRefreshAutoGrabPause()
end

do
_G._VynxRagdollSteal = _G._VynxRagdollSteal or false
local sRagSteal = TR(pSteal, 16, "Ragdoll Steal", "", nil, _G._VynxRagdollSteal, function(on)
    _G._VynxRagdollSteal = on
    if _G.KRIXSaveNow then _G.KRIXSaveNow() end
end)
VisualSetters.RagdollSteal = sRagSteal
end


sectionHeader(pMovement, "MOVEMENT CONFIGURATION", 1)

_ijSet, _ijRow = TR(pMovement, 10, "Infinite Jump", "", "InfiniteJump", Enabled.InfiniteJump, function(s)
    Enabled.InfiniteJump = s
    if s then _G.VezyEnableInfJump() else _G.VezyDisableInfJump() end
end)
_G._VezyRefreshJumpModeBtns = makeDropdown(_ijRow, {"Single", "Hold"},
    function() return _G._VezyJumpMode or "Single" end,
    function(v) _G._VezyJumpMode = v end, nil, SW_W + 20, "Jump Mode")

_arSet, _arRow = TR(pMovement, 12, "Anti Ragdoll", "", "AntiRagdoll", Enabled.AntiRagdoll, function(s)
    if s then startAntiRagdoll() else stopAntiRagdoll() end
end)
_G._VynxRagdollMode = _G._VynxRagdollMode or "V1"
_G._VynxRefreshRagdollMode = makeDropdown(_arRow, {"V1", "V2"},
    function() return _G._VynxRagdollMode or "V1" end,
    function(v)
        _G._VynxRagdollMode = v
        if Enabled.AntiRagdoll then pcall(startAntiRagdoll) end
        if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
    end, nil, SW_W + 20, "Ragdoll Mode")

if _G._VynxAnimPack == "None" or _G._VynxAnimPack == nil then _G._VynxAnimPack = "Off" end
local ANIM_PACK_NAMES = {
    "Off", "Unwalk", "Try Hard",
    "Adidas Sports", "Adidas Community", "Adidas Aura", "Amazon Unboxed", "Astronaut",
    "Bubbly", "Cartoon", "Catwalk Glam", "Dancing Through Life", "Elder", "Knight",
    "Levitate", "Mage", "NFL", "Ninja", "No Boundaries", "Pirate", "Robot", "Rthro",
    "Stylish", "Superhero", "Toy", "Vampire", "Werewolf", "Wicked Popular", "Zombie",
}
_G._VynxAnimPackList = ANIM_PACK_NAMES
local _animPackLbl = CR(pMovement, 14, "Anim Pack", _G._VynxAnimPack,
   ANIM_PACK_NAMES,
   function(nv)
       _G._VynxAnimPack = nv
       if _G._RaVeApplySelectedAnimation then pcall(_G._RaVeApplySelectedAnimation, nv) end
   end)
_G._VynxRefreshAnimPack = function()
    if _animPackLbl then _animPackLbl.Text = tostring(_G._VynxAnimPack or "Off"):upper() end
end

sectionHeader(pMovement, "UTILITIES CONFIGURATION", 40)


do
    local r = KR(pMovement, 42, "Drop Brainrot", "DropBrainrot", SW_W)
    _G._VynxRefreshDropType = makeDropdown(r, {"Stand Drop", "Jump Drop"},
        function() return _G._VynxDropType or "Jump Drop" end,
        function(v)
            _G._VynxDropType = v
            if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
        end, nil, SW_W + 20, "Drop Type")
end
setDropBrainrotVisual = function(_) end
_G.VynxEmergencyUnlock = function() end

KR(pMovement, 44, "TP Down", "TPDown", SW_W + 38)
VisualSetters.TPDown = function(_) end
VisualSetters.TPDownReset = function() end

KR(pMovement, 45, "Insta Reset", "InstaReset", SW_W)

sAutoTPD, _atpRow = TR(pMovement, 46, "Auto TP Down", "", nil, _G._VynxAutoTPDownEnabled, function(on)
    _G._VynxAutoTPDownEnabled = on
    if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
end); VisualSetters.AutoTPDown = sAutoTPD
_atpBox, _atpThRow = NR(pMovement, 47, "Trigger Height", _G._VynxAutoTPDownHeightTrigger or 20, function(txt)
    local n = tonumber(txt)
    if n and n > 0 then _G._VynxAutoTPDownHeightTrigger = n end
end)
_atpThRow.Visible = false
do
    local BS, H = 32, 22
    local eb = Instance.new("TextButton", _atpRow)
    eb.Size = UDim2.new(0, BS, 0, H)
    eb.Position = UDim2.new(1, -(BS + SW_W + 20), 0.5, -H/2)
    eb.BackgroundColor3 = BG_DARK
    eb.BorderSizePixel = 0
    eb.AutoButtonColor = false
    eb.Text = ""
    eb.ZIndex = 12
    Instance.new("UICorner", eb).CornerRadius = UDim.new(0, 6)
    local ebSt = Instance.new("UIStroke", eb)
    ebSt.Color = ACC; ebSt.Thickness = 1; ebSt.Transparency = 0.5
    ebSt.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    addGlow(eb, 6)
    local ec = Instance.new("TextLabel", eb)
    ec.Size = UDim2.new(1, 0, 1, 0)
    ec.BackgroundTransparency = 1
    ec.Text = utf8.char(0x25BC)
    ec.TextColor3 = ACC
    ec.Font = Enum.Font.GothamBlack
    ec.TextSize = 15
    ec.ZIndex = 20
    local _ebFill = addFillHover(eb, ec)
    local open = false
    eb.MouseButton1Click:Connect(function()
        open = not open
        ec.Rotation = open and 180 or 0
        eb:SetAttribute("Open", open)
        _ebFill(open)
        _atpThRow.Visible = open
    end)
end
VisualSetters.AutoTPDownY = function(v)
    if _atpBox then _atpBox.Text = tostring(v) end
    _G._VynxAutoTPDownHeightTrigger = tonumber(v) or _G._VynxAutoTPDownHeightTrigger
end


do

_G._VynxAntiDie = _G._VynxAntiDie or false
local sAntiDie = TR(pMovement, 62, "Anti Die", "AntiDie", nil, _G._VynxAntiDie, function(on)
    _G._VynxAntiDie = on
    if _G.KRIXSaveNow then _G.KRIXSaveNow() end
end)
VisualSetters.AntiDie = sAntiDie

_G._VynxAntiFling = _G._VynxAntiFling or false
local sAntiFling = TR(pMovement, 64, "Anti Fling", "", nil, _G._VynxAntiFling, function(on)
    _G._VynxAntiFling = on
    if _G.KRIXSaveNow then _G.KRIXSaveNow() end
end)
VisualSetters.AntiFling = sAntiFling

_G._VynxSafeMode = _G._VynxSafeMode or false
local sSafeMode = TR(pMovement, 66, "Safe Mode", "", nil, _G._VynxSafeMode, function(on)
    _G._VynxSafeMode = on
    if _G.KRIXSaveNow then _G.KRIXSaveNow() end
end)
VisualSetters.SafeMode = sSafeMode

_G._VynxKickWarning = _G._VynxKickWarning or false
local sKickWarning = TR(pMovement, 67, "Kick Warning", "", nil, _G._VynxKickWarning, function(on)
    _G._VynxKickWarning = on == true
    if _G._VioletteKickWarningSet then pcall(_G._VioletteKickWarningSet, _G._VynxKickWarning) end
    if _G.KRIXSaveNow then _G.KRIXSaveNow() end
end)
VisualSetters.KickWarning = sKickWarning
end


sectionHeader(pVisual, "SKY THEME", 1)
sectionHeader(pVisual, "VISUAL", 20)
sectionHeader(pVisual, "PERFORMANCE CONFIGURATION", 40)

local BG_OPTIONS = {
    {key = "off",  label = "None",   id = ""},
    {key = "bg1",  label = "BG 1",   id = "104655087931499"},
    {key = "bg2",  label = "BG 2",   id = "84045934794798"},
    {key = "bg3",  label = "BG 3",   id = "102548023412554"},
    {key = "bg4",  label = "BG 4",   id = "140209043610417"},
    {key = "bg5",  label = "BG 5",   id = "122654220875697"},
    {key = "bg6",  label = "BG 6",   id = "97009588976542"},
    {key = "bg7",  label = "BG 7",   id = "94548581722612"},
    {key = "bg8",  label = "BG 8",   id = "71705427133616"},
    {key = "bg9",  label = "BG 9",   id = "97563242966497"},
}

local BG_ACCENTS = {
    off  = Color3.fromRGB(254, 254, 254),
    bg1  = Color3.fromRGB(254, 254, 254),
    bg2  = Color3.fromRGB(60, 235, 90),
    bg3  = Color3.fromRGB(254, 254, 254),
    bg4  = Color3.fromRGB(175, 95, 255),
    bg5  = Color3.fromRGB(60, 110, 255),
    bg6  = Color3.fromRGB(255, 55, 55),
    bg7  = Color3.fromRGB(255, 220, 40),
    bg8  = Color3.fromRGB(255, 45, 160),
    bg9  = Color3.fromRGB(255, 120, 30),
}

_G._VioletteAccent = ACC

local function applyAccent(newColor)
    if typeof(newColor) ~= "Color3" then return end
    local old = _G._VioletteAccent or ACC
    if newColor == old then return end

    local function swap(c) return c == old end
    for _, d in ipairs(gui:GetDescendants()) do
        pcall(function()
            if d:IsA("UIStroke") then
                if swap(d.Color) then d.Color = newColor end
            elseif d:IsA("UIGradient") then
                local changed = false
                local kps = {}
                for _, kp in ipairs(d.Color.Keypoints) do
                    if swap(kp.Value) then
                        changed = true
                        kps[#kps + 1] = ColorSequenceKeypoint.new(kp.Time, newColor)
                    else
                        kps[#kps + 1] = ColorSequenceKeypoint.new(kp.Time, kp.Value)
                    end
                end
                if changed then d.Color = ColorSequence.new(kps) end
            else
                if d:IsA("GuiObject") and swap(d.BackgroundColor3) then
                    d.BackgroundColor3 = newColor
                end
                if (d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox"))
                    and swap(d.TextColor3) then
                    d.TextColor3 = newColor
                end
            end
        end)
    end

    ACC = newColor
    _G._VioletteAccent = newColor
    -- Header logo keeps its own colors (no accent multiply; avoids washing the art)
    for _, letter in ipairs(hdrWordmark) do
        if letter and letter.Parent then
            letter.ImageColor3 = Color3.fromRGB(255, 255, 255)
            letter.BackgroundTransparency = 1
        end
    end
    if _G._VioletteRepaintTabs then pcall(_G._VioletteRepaintTabs) end
    if _G._VioletteSetTagColor then pcall(_G._VioletteSetTagColor, newColor) end
    if _G._VioletteRefreshAvatarESPColor then pcall(_G._VioletteRefreshAvatarESPColor) end
    if _G._VioletteRefreshRagdollCDColor then pcall(_G._VioletteRefreshRagdollCDColor) end
    if _G._AdaptRefreshESPColor then pcall(_G._AdaptRefreshESPColor, newColor) end
    if _G._VioletteRefreshPanels then pcall(_G._VioletteRefreshPanels) end
end

_G._VioletteApplyAccent = applyAccent
_G._VioletteAccentForBg = function(key)
    return BG_ACCENTS[key or "off"] or BG_ACCENTS.off
end

do

    local row = Instance.new("Frame", pSettings)
    row.Size = UDim2.new(1, 0, 0, getMobileOptimized(110, 104))
    row.BackgroundColor3 = CARD
    row.BorderSizePixel = 0
    row.LayoutOrder = 4
    row.ZIndex = 4
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 12)
    local rStroke = Instance.new("UIStroke", row)
    rStroke.Color = Color3.fromRGB(40, 44, 56)
    rStroke.Thickness = 1
    rStroke.Transparency = 0.5

    local titleLbl = Instance.new("TextLabel", row)
    titleLbl.Size = UDim2.new(1, -24, 0, 20)
    titleLbl.Position = UDim2.new(0, 12, 0, 6)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "Background Image"
    titleLbl.TextColor3 = WHITE
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = getMobileOptimized(13, 12)
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 5
    local titleUnd = Instance.new("Frame", row)
    titleUnd.Size = UDim2.new(0, textWidth("Background Image", titleLbl.TextSize, titleLbl.Font), 0, 1)
    titleUnd.Visible = false
    titleUnd.Position = UDim2.new(0, 12, 0, 26)
    titleUnd.BackgroundColor3 = ACC
    titleUnd.BorderSizePixel = 0
    titleUnd.ZIndex = 5

    local AW, CW, CGAP = 22, 56, 8

    local strip = Instance.new("ScrollingFrame", row)
    strip.Size = UDim2.new(1, -(24 + AW * 2 + 16), 0, 64)
    strip.Position = UDim2.new(0, 12 + AW + 8, 0, 34)
    strip.BackgroundTransparency = 1
    strip.BorderSizePixel = 0
    strip.ScrollBarThickness = 0
    strip.ScrollingDirection = Enum.ScrollingDirection.X
    strip.AutomaticCanvasSize = Enum.AutomaticSize.X
    strip.CanvasSize = UDim2.new(0, 0, 0, 0)
    strip.ClipsDescendants = true
    strip.ZIndex = 5
    local sl = Instance.new("UIListLayout", strip)
    sl.FillDirection = Enum.FillDirection.Horizontal
    sl.Padding = UDim.new(0, CGAP)
    sl.SortOrder = Enum.SortOrder.LayoutOrder
    sl.VerticalAlignment = Enum.VerticalAlignment.Center
    local sp = Instance.new("UIPadding", strip)
    sp.PaddingLeft = UDim.new(0, 4)
    sp.PaddingRight = UDim.new(0, 4)

    local function mkArrowBtn(txt, xPos)
        local a = Instance.new("TextButton", row)
        a.Size = UDim2.new(0, AW, 0, 40)
        a.Position = UDim2.new(xPos, (xPos == 0) and 12 or -(AW + 12), 0, 43)
        a.BackgroundColor3 = BG_DARK
        a.BorderSizePixel = 0
        a.AutoButtonColor = false
        a.Text = txt
        a.TextColor3 = ACC
        a.Font = Enum.Font.GothamBlack
        a.TextSize = getMobileOptimized(14, 13)
        a.ZIndex = 6
        Instance.new("UICorner", a).CornerRadius = UDim.new(0, 8)
        addFillHover(a, a)
        local ast = Instance.new("UIStroke", a)
        ast.Color = ACC; ast.Thickness = 1; ast.Transparency = 0.5
        ast.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        addGlow(a, 8)
        return a
    end
    local leftBtn  = mkArrowBtn("<", 0)
    local rightBtn = mkArrowBtn(">", 1)

    local function page(dir)
        local step = (CW + CGAP) * 2
        local maxX = math.max(0, strip.AbsoluteCanvasSize.X - strip.AbsoluteSize.X)
        local target = math.clamp(strip.CanvasPosition.X + dir * step, 0, maxX)
        TweenService:Create(strip, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            CanvasPosition = Vector2.new(target, 0)
        }):Play()
    end
    leftBtn.MouseButton1Click:Connect(function()  page(-1) end)
    rightBtn.MouseButton1Click:Connect(function() page(1)  end)

    local bgPickerBtns = {}

    local function getCurrentKey()
        for _, opt in ipairs(BG_OPTIONS) do
            if (_G._VezyBgImageId or "") == opt.id and opt.id ~= "" then return opt.key end
        end
        return "off"
    end

    local function setActiveBtn(activeKey)
        local accent = _G._VioletteAccent or ACC
        for k, btn in pairs(bgPickerBtns) do
            local isActive = (k == activeKey)
            local s = btn:FindFirstChildOfClass("UIStroke")
            if s then
                s.Color = isActive and accent or Color3.fromRGB(50, 52, 60)
                TweenService:Create(s, TweenInfo.new(0.15), {
                    Thickness = isActive and 2 or 1,
                    Transparency = isActive and 0 or 0.4,
                }):Play()
            end
            local tick = btn:FindFirstChild("Tick")
            if tick then
                tick.Visible = isActive
                tick.TextColor3 = accent
            end
            TweenService:Create(btn, TweenInfo.new(0.15), {
                ImageTransparency = isActive and 0 or 0.35,
            }):Play()
        end
    end

    for i, opt in ipairs(BG_OPTIONS) do
        local b = Instance.new("ImageButton", strip)
        b.Size = UDim2.new(0, CW, 0, 56)
        b.BackgroundColor3 = BG_DARK
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.Image = (opt.id ~= "") and ("rbxassetid://" .. opt.id) or ""
        b.ScaleType = Enum.ScaleType.Crop
        b.LayoutOrder = i
        b.ZIndex = 6
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        local bs = Instance.new("UIStroke", b)
        bs.Color = Color3.fromRGB(50, 52, 60)
        bs.Thickness = 1
        bs.Transparency = 0.4

        if opt.id == "" then
            local ph = Instance.new("TextLabel", b)
            ph.Size = UDim2.new(1, 0, 1, 0)
            ph.BackgroundTransparency = 1
            ph.Text = opt.label
            ph.TextColor3 = DIM
            ph.Font = Enum.Font.GothamBold
            ph.TextSize = getMobileOptimized(10, 9)
            ph.ZIndex = 7
        end

        local tick = Instance.new("TextLabel", b)
        tick.Name = "Tick"
        tick.Size = UDim2.new(0, 16, 0, 16)
        tick.Position = UDim2.new(1, -18, 0, 2)
        tick.BackgroundTransparency = 1
        tick.Text = utf8.char(0x2713)
        tick.TextColor3 = ACC
        tick.Font = Enum.Font.GothamBlack
        tick.TextSize = 13
        tick.Visible = false
        tick.ZIndex = 8

        b.MouseButton1Click:Connect(function()
            _G.VezySetBgImage(opt.id)
            applyAccent(BG_ACCENTS[opt.key] or BG_ACCENTS.off)
            setActiveBtn(opt.key)
            if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
        end)
        bgPickerBtns[opt.key] = b
    end

    task.defer(function()
        applyAccent(BG_ACCENTS[getCurrentKey()] or BG_ACCENTS.off)
        setActiveBtn(getCurrentKey())
    end)
    setActiveBtn(getCurrentKey())

    VisualSetters.BgImage = function(on)

        if type(on) == "boolean" then
            _G.VezySetBgImage(on and BG_OPTIONS[2].id or "")
            setActiveBtn(on and "bg1" or "off")
        end
    end

    _G.VezySyncBgPicker = function()
        applyAccent(BG_ACCENTS[getCurrentKey()] or BG_ACCENTS.off)
        setActiveBtn(getCurrentKey())
    end
end


_G._VezyCustomSkyMode = _G._VezyCustomSkyMode or "Off"

_G.VezyApplyCustomSky = function(mode) _G._VezyCustomSkyMode = mode end



local SKY_THEME_NAMES = {
    "Off","Crimson","Neon City","Amethyst","Golden Hour","Frost Moon","Rose Gold",
    "Abyss","Matrix","Candy","Retro Sun","Night","Aurora","Sunset","Galaxy","Cyber",
    "Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic",
    "Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven",
    "Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky",
}
_G._VezySkyThemeNames = SKY_THEME_NAMES
local _skyLbl = CR(pVisual, 2, "Custom Sky", _G._VezyCustomSkyMode,
   SKY_THEME_NAMES,
   function(nv)
       _G._VezyCustomSkyMode = nv
       pcall(_G.VezyApplyCustomSky, nv)

       if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
       if _G.KRIXSaveNow        then pcall(_G.KRIXSaveNow)        end
   end)
_G._VezyRefreshSkyTheme = function()
    if _skyLbl then _skyLbl.Text = tostring(_G._VezyCustomSkyMode or "Off"):upper() end
end


do
    _G._VezyStretchFOV = _G._VezyStretchFOV or 120
    _G._VezyDisplayMode = _G._VezyDisplayMode or "DEFAULT"

    local dRow = Instance.new("Frame", pVisual)
    dRow.Size = UDim2.new(1, 0, 0, getMobileOptimized(42, 38))
    dRow.BackgroundColor3 = CARD
    dRow.BorderSizePixel = 0
    dRow.LayoutOrder = 22
    dRow.ZIndex = 4
    Instance.new("UICorner", dRow).CornerRadius = UDim.new(0, 12)
    local dSt = Instance.new("UIStroke", dRow)
    dSt.Color = Color3.fromRGB(35, 35, 45); dSt.Thickness = 1; dSt.Transparency = 0.4
    local dLbl = Instance.new("TextLabel", dRow)
    dLbl.Size = UDim2.new(0, 70, 0, 16)
    dLbl.Position = UDim2.new(0, 12, 0.5, -9)
    dLbl.BackgroundTransparency = 1
    dLbl.Text = "Display"
    dLbl.TextColor3 = WHITE
    dLbl.Font = Enum.Font.GothamBold
    dLbl.TextSize = getMobileOptimized(12, 11)
    dLbl.TextXAlignment = Enum.TextXAlignment.Left
    local dUnd = Instance.new("Frame", dRow)
    dUnd.Size = UDim2.new(0, textWidth("Display", dLbl.TextSize, dLbl.Font), 0, 1)
    dUnd.Visible = false
    dUnd.Position = UDim2.new(0, 12, 0.5, 7)
    dUnd.BackgroundColor3 = ACC
    dUnd.BorderSizePixel = 0
    dUnd.ZIndex = 5
    dLbl.ZIndex = 5

    local modeBtns = {}
    local function mkMode(key, label, xOffset)
        local b = Instance.new("TextButton", dRow)
        b.Size = UDim2.new(0, 56, 0, 24)
        b.Position = UDim2.new(1, xOffset, 0.5, -12)
        b.BackgroundColor3 = CARD2
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.Text = label
        b.TextColor3 = DIM
        b.Font = Enum.Font.GothamBold
        b.TextSize = getMobileOptimized(11, 10)
        b.ZIndex = 5
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        modeBtns[key] = b
        return b
    end
    local bDefault = mkMode("DEFAULT", "Default", -186)
    local bFov     = mkMode("FOV",     "FOV",     -126)
    local bStretch = mkMode("STRETCH", "Stretch", -66)

    local function mkValueRow(order, labelTxt)
        local r = Instance.new("Frame", pVisual)
        r.Size = UDim2.new(1, 0, 0, getMobileOptimized(38, 34))
        r.BackgroundColor3 = CARD
        r.BorderSizePixel = 0
        r.LayoutOrder = order
        r.ZIndex = 4
        r.Visible = false
        Instance.new("UICorner", r).CornerRadius = UDim.new(0, 12)
        local s = Instance.new("UIStroke", r)
        s.Color = Color3.fromRGB(35, 35, 45); s.Thickness = 1; s.Transparency = 0.4
        local l = Instance.new("TextLabel", r)
        l.Size = UDim2.new(0.5, 0, 1, 0)
        l.Position = UDim2.new(0, 12, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = labelTxt
        l.TextColor3 = WHITE
        l.Font = Enum.Font.GothamBold
        l.TextSize = getMobileOptimized(12, 11)
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.ZIndex = 5
        return r
    end

    local function makePresets(row, values, getV, setV)
        local btns = {}
        local BW, BH, GAP = 42, 24, 6
        local total = #values * BW + (#values - 1) * GAP
        local function refresh()
            for v, b in pairs(btns) do
                local on = (v == getV())
                TweenService:Create(b, TweenInfo.new(0.15), {
                    BackgroundColor3 = on and ACC or Color3.fromRGB(30, 30, 30),
                    TextColor3 = on and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(165, 165, 170),
                }):Play()
            end
        end
        for i, v in ipairs(values) do
            local b = Instance.new("TextButton", row)
            b.Size = UDim2.new(0, BW, 0, BH)
            b.Position = UDim2.new(1, -(total + 12) + (i - 1) * (BW + GAP), 0.5, -BH/2)
            b.BackgroundColor3 = CARD2
            b.BorderSizePixel = 0
            b.AutoButtonColor = false
            b.Text = tostring(v)
            b.TextColor3 = DIM
            b.Font = Enum.Font.GothamBold
            b.TextSize = getMobileOptimized(11, 10)
            b.ZIndex = 5
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
            btns[v] = b
            b.MouseButton1Click:Connect(function()
                setV(v)
                refresh()
                if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
                if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
            end)
        end
        refresh()
        return refresh
    end

    local FOV_MIN, FOV_MAX = 70, 120
    local function clampFov(v)
        return math.clamp(math.floor((tonumber(v) or FOV_MAX) + 0.5), FOV_MIN, FOV_MAX)
    end

    local fovValRow = mkValueRow(23, "Normal FOV")
    _G._VezyCustomFOV = clampFov(_G._VezyCustomFOV)
    _G._VezyRefreshCustomFOV = makeStepper(fovValRow,
        function() return clampFov(_G._VezyCustomFOV) end,
        function(v)
            v = clampFov(v)
            if _G.VezySetCustomFOV then _G.VezySetCustomFOV(v) else _G._VezyCustomFOV = v end
            if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
            if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
        end, FOV_MIN, FOV_MAX, 10, "%d")

    local STRETCH_MIN, STRETCH_MAX, STRETCH_DEFAULT = 0.3, 1.0, 0.70
    local function clampStretch(v)
        v = tonumber(v)
        if not v then return STRETCH_DEFAULT end
        return math.clamp(v, STRETCH_MIN, STRETCH_MAX)
    end
    _G._VynxStretchValue = clampStretch(_G._VynxStretchValue or STRETCH_DEFAULT)
    local stretchValRow
    _G._VezyRefreshStretchFOV, stretchValRow = makeSliderRow(pVisual, 24, "Stretch Rez",
        STRETCH_MIN, STRETCH_MAX,
        function() return clampStretch(_G._VynxStretchValue) end,
        function(v)
            _G._VynxStretchValue = clampStretch(v)
            if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
            if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
        end, 0.05)
    stretchValRow.Visible = false

    local function refreshMode()
        local mode = _G._VezyDisplayMode
        for k, b in pairs(modeBtns) do
            local on = (k == mode)
            TweenService:Create(b, TweenInfo.new(0.15), {
                BackgroundColor3 = on and ACC or Color3.fromRGB(30, 30, 30),
                TextColor3 = on and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(165, 165, 170),
            }):Play()
        end
        fovValRow.Visible     = (mode == "FOV")
        stretchValRow.Visible = (mode == "STRETCH")
    end

    local function applyMode(mode)
        _G._VezyDisplayMode = mode
        stretchRezEnabled = (mode == "STRETCH")
        if mode == "STRETCH" then
            if _G._VynxEnableStretchRez then pcall(_G._VynxEnableStretchRez) end
        else
            if _G._VynxDisableStretchRez then pcall(_G._VynxDisableStretchRez) end
        end
        if mode == "FOV" then
            if _G.VezyEnableFOV then pcall(_G.VezyEnableFOV) end
        else
            if _G.VezyDisableFOV then pcall(_G.VezyDisableFOV) end
        end
        refreshMode()
        if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
        if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
    end

    bDefault.MouseButton1Click:Connect(function() applyMode("DEFAULT") end)
    bFov.MouseButton1Click:Connect(function()     applyMode("FOV")     end)
    bStretch.MouseButton1Click:Connect(function() applyMode("STRETCH") end)

    VisualSetters.StretchRez = function(on)
        applyMode(on and "STRETCH" or "DEFAULT")
    end
    VisualSetters.CustomFOV = function(on)
        applyMode(on and "FOV" or "DEFAULT")
    end
    _G._VezyRefreshDisplayMode = refreshMode

    refreshMode()
end

sNC = TR(pVisual, 26, "No Cam Collision", "", nil, false, function(on)
    noCamCollisionEnabled = on
    if on then enableNoCameraCollision() else disableNoCameraCollision() end
    if _G.KRIXSaveNow then _G.KRIXSaveNow() end
end); VisualSetters.NoCam = sNC

do
sectionHeader(pVisual, "ESP CONFIGURATION", 27)

_G._VynxAuraESP        = _G._VynxAuraESP or false
_G._VynxBoxedESP       = _G._VynxBoxedESP or false
_G._VynxShowTracker    = _G._VynxShowTracker or false
_G._VynxAvatarESP      = _G._VynxAvatarESP or false
_G._VynxRagdollCountdown = _G._VynxRagdollCountdown or false

local ESP_KINDS = { "Aura", "Box", "Tracer", "Avatar", "Timer" }

local ESP_BINDINGS = {
    ["Aura"]   = { key = "_VynxAuraESP",          setter = "AuraESP" },
    ["Box"]    = { key = "_VynxBoxedESP",         setter = "BoxedESP" },
    ["Tracer"] = { key = "_VynxShowTracker",      setter = "ShowTracker" },
    ["Avatar"] = { key = "_VynxAvatarESP",        setter = "AvatarESP" },
    ["Timer"]  = { key = "_VynxRagdollCountdown", setter = "RagdollCountdown" },
}

local function espKindOn(kind)
    local b = ESP_BINDINGS[kind]
    return b ~= nil and _G[b.key] == true
end

local function setESPKind(kind, on)
    local b = ESP_BINDINGS[kind]
    if not b then return end
    _G[b.key] = on and true or false
    if kind == "Avatar" and _G._VioletteSetAvatarESP then
        pcall(_G._VioletteSetAvatarESP, _G[b.key])
    end
    if kind == "Aura" and _G._AdaptESPSetEnabled then
        pcall(_G._AdaptESPSetEnabled, _G[b.key])
    end
    if VisualSetters[b.setter] then pcall(VisualSetters[b.setter], _G[b.key]) end
    if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
end

local function anyESPOn()
    for _, kind in ipairs(ESP_KINDS) do
        if espKindOn(kind) then return true end
    end
    return false
end

local espSel = {}

local function anySelected()
    for _, kind in ipairs(ESP_KINDS) do
        if espSel[kind] then return true end
    end
    return false
end

local function espSelSave()
    local list = {}
    for _, kind in ipairs(ESP_KINDS) do
        if espSel[kind] then list[#list + 1] = kind end
    end
    _G._VynxESPSelection = table.concat(list, ",")
end

local function espSelLoad()
    for _, kind in ipairs(ESP_KINDS) do espSel[kind] = nil end
    local raw = _G._VynxESPSelection
    if type(raw) == "string" and raw ~= "" then
        for kind in string.gmatch(raw, "[^,]+") do
            if ESP_BINDINGS[kind] then espSel[kind] = true end
        end
    elseif type(raw) ~= "string" then
        for _, kind in ipairs(ESP_KINDS) do
            if espKindOn(kind) then espSel[kind] = true end
        end
        espSelSave()
    end
end
espSelLoad()
if _G._VynxESPOn == nil then _G._VynxESPOn = anyESPOn() end

local sESP, _espRow
local refreshESPOptions = function() end

local applyingESP = false

local function applyESP()
    applyingESP = true
    for _, kind in ipairs(ESP_KINDS) do
        setESPKind(kind, _G._VynxESPOn and espSel[kind] or false)
    end
    applyingESP = false
    espSelSave()
    refreshESPOptions()
end

sESP, _espRow = TR(pVisual, 28, "ESP", "", nil, _G._VynxESPOn, function(on)
    _G._VynxESPOn = on and true or false
    if _G._VynxESPOn and not anySelected() then espSel["Aura"] = true end
    applyESP()
    if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
    if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
end)
VisualSetters.ESPMain = sESP

_G._VynxRefreshESPKind = makeDropdown(_espRow, ESP_KINDS,
    function(kind) return espSel[kind] == true end,
    function(kind)
        espSel[kind] = not espSel[kind] or nil
        if espSel[kind] and not _G._VynxESPOn then
            _G._VynxESPOn = true
            pcall(sESP, true)
        end
        applyESP()
        if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
        if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
    end, 52, SW_W + 20, "ESP Type", true)
refreshESPOptions = _G._VynxRefreshESPKind

for _, kind in ipairs(ESP_KINDS) do
    local b = ESP_BINDINGS[kind]
    VisualSetters[b.setter] = function(on)
        if applyingESP then return end
        if on ~= nil then
            espSel[kind] = on and true or nil
            if on then _G._VynxESPOn = true end
            espSelSave()
        end
        refreshESPOptions()
        pcall(sESP, _G._VynxESPOn)
    end
end

_G._VynxSyncESPRow = function()
    espSelLoad()
    if _G._VynxESPOn == nil then _G._VynxESPOn = anyESPOn() end
    applyESP()
    pcall(sESP, _G._VynxESPOn)
end
end

do
_G._VynxKorblox = _G._VynxKorblox or "Off"
local _korbloxLbl = CR(pVisual, 39, "Korblox", _G._VynxKorblox,
   {"Off", "Left Leg", "Right Leg", "Both"},
   function(nv)
       _G._VynxKorblox = nv
       if _G.KRIXSaveNow then _G.KRIXSaveNow() end
   end)
_G._VynxRefreshKorblox = function()
    if _korbloxLbl then _korbloxLbl.Text = tostring(_G._VynxKorblox or "Off"):upper() end
end

_G._VynxHeadless = _G._VynxHeadless or false
local sHeadless = TR(pVisual, 38, "Headless", "", nil, _G._VynxHeadless, function(on)
    _G._VynxHeadless = on
    if _G.KRIXSaveNow then _G.KRIXSaveNow() end
end)
VisualSetters.Headless = sHeadless
end
TR(pVisual, 42, "Anti Lag", "", "Optimizer", Enabled.Optimizer, function(s)
    if s then enableOptimizer() else disableOptimizer() end
    if _G.KRIXSaveNow then _G.KRIXSaveNow() end
end)
sUM = TR(pVisual, 44, "Potato Graphics", "", nil, false, function(s)
    ultraModeEnabled = s
    if s then enableUltraMode() else disableUltraMode() end
    if _G.KRIXSaveNow then _G.KRIXSaveNow() end
end); VisualSetters.UltraMode = sUM
TR(pVisual, 46, "Shiny Mode", "", "RemoveAccessories", Enabled.RemoveAccessories, function(s)
    if s then startRemoveAccessories() else stopRemoveAccessories() end
end)


_G._VezyNukeOn = false
_G._VezyNukeThreads = _G._VezyNukeThreads or {}
_G._VezyNukeConns = _G._VezyNukeConns or {}

local function _vezyNukeStart() end
local function _vezyNukeStop() end


do
_G._VynxDarkness = _G._VynxDarkness or 2
local _dmSet, _dmRow = TR(pVisual, 48, "Dark Mode", "", nil, false, function(on)
    _G._VynxDarkModeOn = on
    if on then _vezyNukeStart() else _vezyNukeStop() end
end)
VisualSetters.DarkMode = _dmSet

local _dmRefresh, _dmSliderRow = makeSliderRow(pVisual, 49, "Darkness", 0, 10,
    function() return _G._VynxDarkness or 2 end,
    function(v) _G._VynxDarkness = v end, 0.1)
_G._VynxRefreshDarkness = _dmRefresh
_dmSliderRow.Visible = false

sectionHeader(pVisual, "COSMETICS", 60)

do
    local f = makeRowBase(pVisual, 61)
    nameWithUnderline(f, "Avatar Catalog")

    local BW, BH = getMobileOptimized(62, 56), 24
    local open = Instance.new("TextButton", f)
    open.Size = UDim2.new(0, BW, 0, BH)
    open.Position = UDim2.new(1, -(BW + 12), 0.5, -BH / 2)
    open.BackgroundColor3 = BG_DARK
    open.BorderSizePixel = 0
    open.AutoButtonColor = false
    open.Text = "OPEN"
    open.TextColor3 = ACC
    open.Font = Enum.Font.GothamBlack
    open.TextSize = getMobileOptimized(11, 10)
    open.ZIndex = 12
    Instance.new("UICorner", open).CornerRadius = UDim.new(0, 8)
    local openSt = Instance.new("UIStroke", open)
    openSt.Color = ACC; openSt.Thickness = 1; openSt.Transparency = 0.5
    openSt.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    addGlow(open, 8)
    addFillHover(open, open)
    addPressPop(open, open)

    open.MouseButton1Click:Connect(function()
        if _G._KawatanOpenSkinGallery then pcall(_G._KawatanOpenSkinGallery) end
    end)
end

_G._VynxCustomSkin = _G._VynxCustomSkin or false
local _skinSet = TR(pVisual, 62, "Custom Skin", "", nil, _G._VynxCustomSkin, function(on)
    _G._VynxCustomSkin = on
    if _G._VioletteSetCustomSkin then pcall(_G._VioletteSetCustomSkin, on) end
    if _G.KRIXSaveNow then _G.KRIXSaveNow() end
end)
VisualSetters.CustomSkin = _skinSet
_G._VynxRefreshCustomSkin = function()
    if _skinSet then pcall(_skinSet, _G._VynxCustomSkin == true) end
end

_G._VlonEBodyType = _G._VlonEBodyType or "OFF"
local _bodyTypeLbl = CR(pVisual, 63, "Body Type", _G._VlonEBodyType,
    {"OFF", "WOMAN", "CLASSIC"},
    function(nv)
        _G._VlonEBodyType = nv
        if _G._VioletteSetBodyType then pcall(_G._VioletteSetBodyType, nv) end
        if _G.KRIXSaveNow then _G.KRIXSaveNow() end
    end)
_G._VynxRefreshBodyType = function()
    if _bodyTypeLbl then _bodyTypeLbl.Text = tostring(_G._VlonEBodyType or "OFF"):upper() end
end

-- Picking a card in the gallery swaps the active set; re-apply if the skin is on.
_G._KawatanOnSetPicked = function(name)
    _G._KawatanSkinColor = name
    if _G._VynxCustomSkin == true and _G._VioletteSetCustomSkin then
        task.spawn(function() pcall(_G._VioletteSetCustomSkin, true) end)
    end
    if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
end

do
    local BS, H = 32, 22
    local eb = Instance.new("TextButton", _dmRow)
    eb.Size = UDim2.new(0, BS, 0, H)
    eb.Position = UDim2.new(1, -(BS + SW_W + 20), 0.5, -H/2)
    eb.BackgroundColor3 = BG_DARK
    eb.BorderSizePixel = 0
    eb.AutoButtonColor = false
    eb.Text = ""
    eb.ZIndex = 12
    Instance.new("UICorner", eb).CornerRadius = UDim.new(0, 6)
    local ebSt = Instance.new("UIStroke", eb)
    ebSt.Color = ACC; ebSt.Thickness = 1; ebSt.Transparency = 0.5
    ebSt.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    addGlow(eb, 6)
    local ec = Instance.new("TextLabel", eb)
    ec.Size = UDim2.new(1, 0, 1, 0)
    ec.BackgroundTransparency = 1
    ec.Text = utf8.char(0x25BC)
    ec.TextColor3 = ACC
    ec.Font = Enum.Font.GothamBlack
    ec.TextSize = 15
    ec.ZIndex = 20
    local _dmFill = addFillHover(eb, ec)
    local open = false
    eb.MouseButton1Click:Connect(function()
        open = not open
        ec.Rotation = open and 180 or 0
        eb:SetAttribute("Open", open)
        _dmFill(open)
        _dmSliderRow.Visible = open
    end)
end
end


sectionHeader(pAuto, "AUTO PATH CONFIGURATION", 10)
KR(pAuto, 11, "Auto Left",  "AutoLeft",  SW_W)
KR(pAuto, 12, "Auto Right", "AutoRight", SW_W)
do
    local apContainer = Instance.new("Frame", pAuto)
    apContainer.Size = UDim2.new(1,0,0,0)
    apContainer.AutomaticSize = Enum.AutomaticSize.Y
    apContainer.BackgroundTransparency = 1
    apContainer.BorderSizePixel = 0
    apContainer.LayoutOrder = 13
    _G._V7AutoPlayPage = apContainer
end

sectionHeader(pSettings, "PANELS", -10)
_G._ViolettePanelOpen = _G._ViolettePanelOpen or {}
do
    local PANEL_BTNS = {
        { key = "duelLagger", label = "Duel Lagger" },
        { key = "pingLagger", label = "Ping Lagger" },
        { key = "speedBypass", label = "Speed Bypass" },
    }
    local panelBtnRefs = {}

    local function paintPanelBtn(key)
        local ref = panelBtnRefs[key]
        if not ref then return end
        local on = _G._ViolettePanelOpen[key] == true
        local acc = _G._VioletteAccent or ACC
        TweenService:Create(ref.btn, TweenInfo.new(0.14), {
            BackgroundColor3 = on and acc or BG_DARK,
        }):Play()
        TweenService:Create(ref.stroke, TweenInfo.new(0.14), {
            Transparency = on and 0.1 or 0.45,
        }):Play()
        ref.lbl.TextColor3 = on and Color3.fromRGB(0, 0, 0) or acc
    end
    _G._VioletteSyncPanelBtn = paintPanelBtn

    for i, def in ipairs(PANEL_BTNS) do
        local row = Instance.new("Frame", pSettings)
        row.Size = UDim2.new(1, 0, 0, getMobileOptimized(40, 36))
        row.BackgroundTransparency = 1
        row.BorderSizePixel = 0
        row.LayoutOrder = -10 + i
        row.ZIndex = 4

        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundColor3 = BG_DARK
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Text = ""
        btn.ZIndex = 5
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
        local bSt = Instance.new("UIStroke", btn)
        bSt.Color = ACC
        bSt.Thickness = 1
        bSt.Transparency = 0.45
        bSt.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        addGlow(btn, 10)

        local lbl = Instance.new("TextLabel", btn)
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.Position = UDim2.new(0, 0, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = def.label
        lbl.TextColor3 = ACC
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextSize = getMobileOptimized(12, 11)
        lbl.TextXAlignment = Enum.TextXAlignment.Center
        lbl.ZIndex = 6

        panelBtnRefs[def.key] = { btn = btn, stroke = bSt, lbl = lbl }

        btn.MouseEnter:Connect(function()
            if _G._ViolettePanelOpen[def.key] ~= true then
                TweenService:Create(bSt, TweenInfo.new(0.14), {Transparency = 0.15}):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            if _G._ViolettePanelOpen[def.key] ~= true then
                TweenService:Create(bSt, TweenInfo.new(0.14), {Transparency = 0.45}):Play()
            end
        end)
        btn.MouseButton1Click:Connect(function()
            local want = _G._ViolettePanelOpen[def.key] ~= true
            _G._ViolettePanelOpen[def.key] = want
            if _G._VioletteShowPanel then pcall(_G._VioletteShowPanel, def.key, want) end
            paintPanelBtn(def.key)
            if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
            if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
        end)
    end

    _G._VioletteRefreshPanelBtns = function()
        for _, def in ipairs(PANEL_BTNS) do
            paintPanelBtn(def.key)
        end
    end
end

sectionHeader(pSettings, "INTERFACE", 2)

_G._VynxUILocked = _G._VynxUILocked or false
local sLockUI = TR(pSettings, 5, "Lock UI", "", nil, _G._VynxUILocked, function(on)
    _G._VynxUILocked = on

    if _G._VynxRefreshHdrLockIcon then pcall(_G._VynxRefreshHdrLockIcon) end
    if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
    if _G.KRIXSaveNow then _G.KRIXSaveNow() end
end); VisualSetters.LockUI = sLockUI

_G._VioletteIntroSong = _G._VioletteIntroSong or "Song 2"
local INTRO_SONG_NAMES = {
    "Off",
    "Song 1", "Song 2", "Song 3", "Song 4", "Song 5", "Song 6",
    "Song 7", "Song 8", "Song 9", "Song 10", "Song 11", "Song 12",
    "Song 13", "Song 14", "Song 15", "Song 16",
}
local _introSongLbl = CR(pSettings, 6, "Intro Song", _G._VioletteIntroSong,
    INTRO_SONG_NAMES,
    function(nv)
        _G._VioletteIntroSong = nv
        _G._RaVeIntroSong  = nv
        if _G._ViolettePlayIntroSong then pcall(_G._ViolettePlayIntroSong, nv, true) end
        if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
    end)
_G._VynxRefreshIntroSong = function()
    if _introSongLbl then
        _introSongLbl.Text = tostring(_G._VioletteIntroSong or "Song 1"):upper()
    end
end

_G._VioletteSkipIntro = _G._VioletteSkipIntro == true
local sSkipIntro = TR(pSettings, 7, "Skip Intro", "", nil, _G._VioletteSkipIntro, function(on)
    _G._VioletteSkipIntro = on and true or false
    if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
    if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
end); VisualSetters.SkipIntro = sSkipIntro

do
    local f = makeRowBase(pSettings, 8)
    nameWithUnderline(f, "UI Toggle Key")
    local bx = Instance.new("Frame", f)
    bx.Size = UDim2.new(0,getMobileOptimized(70,60),0,getMobileOptimized(26,22))
    bx.Position = UDim2.new(1,-getMobileOptimized(80,68),0.5,-getMobileOptimized(13,11))
    bx.BackgroundColor3 = BG_DARK; bx.BorderSizePixel = 0; bx.ZIndex = 6
    Instance.new("UICorner",bx).CornerRadius = UDim.new(0,10)
    local kt = Instance.new("TextLabel", bx)
    kt.Size = UDim2.new(1,0,1,0); kt.BackgroundTransparency = 1
    kt.Text = (Keybinds.UIToggle ~= Enum.KeyCode.Unknown) and _G._VioletteKeyName(Keybinds.UIToggle) or "None"; kt.TextColor3 = ACC
    kt.Font = Enum.Font.GothamBold; kt.TextSize = getMobileOptimized(11,10); kt.ZIndex = 7
    kt.TextScaled = true
    do local c = Instance.new("UITextSizeConstraint", kt); c.MaxTextSize = getMobileOptimized(11,10); c.MinTextSize = 6 end
    bx.ClipsDescendants = true
    local btn = Instance.new("TextButton", bx)
    btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1
    btn.Text = ""; btn.ZIndex = 8
    btn.MouseButton1Click:Connect(function()
        kt.Text = "..."
        _G._VioletteBeginKeyCapture()
        local conn; conn = UserInputService.InputBegan:Connect(function(i, g)

            if i.UserInputType ~= Enum.UserInputType.Keyboard
               and true
               and not _isGamepadInput(i) then return end
            local kc = i.KeyCode
            if kc == Enum.KeyCode.Escape then kt.Text = (Keybinds.UIToggle ~= Enum.KeyCode.Unknown) and _G._VioletteKeyName(Keybinds.UIToggle) or "None"; _G._VioletteEndKeyCapture(); conn:Disconnect(); return end
            if kc == Enum.KeyCode.Backspace then
                Keybinds.UIToggle = Enum.KeyCode.Unknown; kt.Text = "None"
                _G._VioletteEndKeyCapture(); conn:Disconnect()
                if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
                if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
                return
            end
            if kc == Enum.KeyCode.Unknown then return end
            if _G._AdaptKeybindSteal then _G._AdaptKeybindSteal(kc, "UIToggle") end
            Keybinds.UIToggle = kc; kt.Text = _G._VioletteKeyName(kc)
            _G._VioletteEndKeyCapture()
            conn:Disconnect()
            if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
            if _G.KRIXSaveNow        then pcall(_G.KRIXSaveNow) end
        end)
    end)
    _G._VynxRefreshUIToggleKey = function()
        kt.Text = (Keybinds.UIToggle ~= Enum.KeyCode.Unknown) and _G._VioletteKeyName(Keybinds.UIToggle) or "None"
    end
end


sectionHeader(pSettings, "CUSTOM CONFIGURATION", 10)

do
    local f = makeRowBase(pSettings, 12)
    nameWithUnderline(f, "UI Size")
    local refreshActive = makeStepper(f,
        function() return UI_SCALE or 1 end,
        function(v)
            UI_SCALE = v
            if _G._VynxApplyUIScale then pcall(_G._VynxApplyUIScale, v) end
            if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
            if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
        end, 0.5, 2.0, 0.05)

    _G._VynxRefreshUISizeButtons = refreshActive
end

do
    _G._AdaptStealBarScale = _G._AdaptStealBarScale or 1.0
    local f = makeRowBase(pSettings, 13)
    nameWithUnderline(f, "Steal Bar Scale")
    _G._VynxRefreshStealBarScale = makeStepper(f,
        function() return _G._AdaptStealBarScale or 1.0 end,
        function(v)
            _G._AdaptStealBarScale = v
            if _G._RaVeSetStealBarScale then pcall(_G._RaVeSetStealBarScale, v * 100 * DEVICE_UI_SCALE) end
            if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
            if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
        end, 0.5, 2.0, 0.05)
end

do
    local f = makeRowBase(pSettings, 14)
    nameWithUnderline(f, "Mobile Btn Size")
    local refreshActive = makeStepper(f,
        function() return _G._VynxMobileBtnScale or 1.20 end,
        function(v)
            _G._VynxMobileBtnScale = v
            if _G._VynxApplyMobileBtnScale then pcall(_G._VynxApplyMobileBtnScale, v) end
            if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
            if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
        end, 0.7, 2.0, 0.05)

    _G._VynxRefreshMobileBtnSizeButtons = refreshActive
end

do
    _G._VynxMobileCircle = _G._VynxMobileCircle or false
    _G._VynxMobileShown  = _G._VynxMobileShown or {}

    if _G._VezyHideSideBtns == nil then
        _G._VezyHideSideBtns = not isMobile
    end

    local function applyHideMobile(on)
        _G._VezyHideSideBtns = on and true or false
        if _G._VynxRefreshMobileButtons then
            pcall(_G._VynxRefreshMobileButtons)
        else
            for _, child in ipairs(gui:GetChildren()) do
                if child:IsA("TextButton") and child.Name:sub(1, 3) == "MB_" then
                    child.Visible = not on
                end
            end
        end
        local frame = _G._VezyMobileButtonsFrame or gui:FindFirstChild("VezyMobileButtons")
        if frame then frame.Visible = not on end
    end
    _G._VynxApplyHideMobile = applyHideMobile

    local sHideSide, _hideRow = TR(pSettings, 15, "Hide Mobile Buttons", "", nil,
        _G._VezyHideSideBtns, function(on)
            applyHideMobile(on)
            if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
            if _G.KRIXSaveNow then _G.KRIXSaveNow() end
        end)
    VisualSetters.HideSideBtns = sHideSide

    task.defer(function() applyHideMobile(_G._VezyHideSideBtns) end)

    local pickRows = {}
    local picksOpen = false
    task.defer(function()
        local order = 16
        for _, entry in ipairs(_G._VynxMobileButtonList or {}) do
            local key, label = entry.key, entry.label
            local setter, row = TR(pSettings, order, label, "", nil,
                _G._VynxMobileShown[key] ~= false, function(on)
                    if _G._VynxSetMobileButtonShown then
                        pcall(_G._VynxSetMobileButtonShown, key, on)
                    else
                        _G._VynxMobileShown[key] = on and true or false
                    end
                    if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
                end)
            row.Visible = picksOpen
            pickRows[#pickRows + 1] = { row = row, setter = setter, key = key }
            order = order + 1
        end
    end)

    _G._VynxRefreshMobilePickRows = function()
        for _, p in ipairs(pickRows) do
            pcall(p.setter, _G._VynxMobileShown[p.key] ~= false)
        end
        if _G._VynxRefreshMobileButtons then pcall(_G._VynxRefreshMobileButtons) end
    end

    local sCircle = TR(pSettings, 28, "Circle Buttons", "", nil, _G._VynxMobileCircle, function(on)
        _G._VynxMobileCircle = on
        if _G._VynxSetMobileCircle then pcall(_G._VynxSetMobileCircle, on) end
        if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
        if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
    end)
    VisualSetters.MobileCircle = sCircle

    do
        local BS, H = 32, 22
        local eb = Instance.new("TextButton", _hideRow)
        eb.Size = UDim2.new(0, BS, 0, H)
        eb.Position = UDim2.new(1, -(BS + SW_W + 20), 0.5, -H/2)
        eb.BackgroundColor3 = BG_DARK
        eb.BorderSizePixel = 0
        eb.AutoButtonColor = false
        eb.Text = ""
        eb.ZIndex = 12
        Instance.new("UICorner", eb).CornerRadius = UDim.new(0, 6)
        local ebSt = Instance.new("UIStroke", eb)
        ebSt.Color = ACC; ebSt.Thickness = 1; ebSt.Transparency = 0.5
        ebSt.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        addGlow(eb, 6)
        local ec = Instance.new("TextLabel", eb)
        ec.Size = UDim2.new(1, 0, 1, 0)
        ec.BackgroundTransparency = 1
        ec.Text = utf8.char(0x25BC)
        ec.TextColor3 = ACC
        ec.Font = Enum.Font.GothamBlack
        ec.TextSize = 15
        ec.ZIndex = 20
        local _mbFill = addFillHover(eb, ec)
        local open = false
        eb.MouseButton1Click:Connect(function()
            open = not open
            picksOpen = open
            ec.Rotation = open and 180 or 0
            eb:SetAttribute("Open", open)
            _mbFill(open)
            for _, p in ipairs(pickRows) do p.row.Visible = open end
        end)
    end
end

do
    local row = Instance.new("Frame", pSettings)
    row.Size = UDim2.new(1, 0, 0, getMobileOptimized(40, 36))
    row.BackgroundTransparency = 1
    row.BorderSizePixel = 0
    row.LayoutOrder = 29
    row.ZIndex = 4

    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundColor3 = BG_DARK
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Text = ""
    btn.ZIndex = 5
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    local bSt = Instance.new("UIStroke", btn)
    bSt.Color = ACC
    bSt.Thickness = 1
    bSt.Transparency = 0.45
    bSt.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    addGlow(btn, 10)

    local lbl = Instance.new("TextLabel", btn)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "RESET MOBILE BUTTONS"
    lbl.TextColor3 = ACC
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = getMobileOptimized(12, 11)
    lbl.ZIndex = 6

    btn.MouseEnter:Connect(function()
        TweenService:Create(bSt, TweenInfo.new(0.14), {Transparency = 0.1}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(bSt, TweenInfo.new(0.14), {Transparency = 0.45}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        if _G._VynxResetMobileBtnPos then pcall(_G._VynxResetMobileBtnPos) end
        _G._VynxMobileBtnScale = 1.20
        if _G._VynxApplyMobileBtnScale then pcall(_G._VynxApplyMobileBtnScale, 1.20) end
        if _G._VynxRefreshMobileBtnSizeButtons then pcall(_G._VynxRefreshMobileBtnSizeButtons) end
        lbl.Text = "DONE"
        task.delay(1.2, function()
            if lbl.Parent then lbl.Text = "RESET MOBILE BUTTONS" end
        end)
    end)
end

do

    local R_BG       = Color3.fromRGB(18, 12, 20)
    local R_BG_HOV   = Color3.fromRGB(26, 26, 26)
    local R_BG_DONE  = Color3.fromRGB(14, 28, 18)
    local R_RED      = ACC
    local R_RED_DARK = Color3.fromRGB(200, 200, 200)
    local R_RED_DEEP = Color3.fromRGB(90, 90, 90)
    local R_GREEN    = Color3.fromRGB(215, 215, 215)

    local resetRow = Instance.new("Frame", pSettings)
    resetRow.Size = UDim2.new(1, 0, 0, getMobileOptimized(54, 48))
    resetRow.BackgroundTransparency = 1
    resetRow.BorderSizePixel = 0
    resetRow.LayoutOrder = 200
    resetRow.ZIndex = 4
    resetRow.ClipsDescendants = false

    local resetGlow = Instance.new("ImageLabel", resetRow)
    resetGlow.Size = UDim2.new(1, 20, 1, 20)
    resetGlow.Position = UDim2.new(0, -10, 0, -10)
    resetGlow.BackgroundTransparency = 1
    resetGlow.Image = "rbxassetid://5028857084"
    resetGlow.ImageColor3 = R_RED
    resetGlow.ImageTransparency = 0.88
    resetGlow.ScaleType = Enum.ScaleType.Slice
    resetGlow.SliceCenter = Rect.new(24, 24, 276, 276)
    resetGlow.ZIndex = 4

    local resetBtn = Instance.new("TextButton", resetRow)
    resetBtn.Size = UDim2.new(1, 0, 0, getMobileOptimized(40, 36))
    resetBtn.Position = UDim2.new(0, 0, 0.5, -getMobileOptimized(20, 18))
    resetBtn.BackgroundColor3 = R_BG
    resetBtn.BorderSizePixel = 0
    resetBtn.Text = ""
    resetBtn.AutoButtonColor = false
    resetBtn.ZIndex = 5
    Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 10)

    local resetGrad = Instance.new("UIGradient", resetBtn)
    resetGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(30, 16, 32)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(16, 10, 20)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(30, 16, 32)),
    })
    resetGrad.Rotation = 135

    local resetStroke = Instance.new("UIStroke", resetBtn)
    resetStroke.Thickness = 1.4
    resetStroke.Color = R_RED
    resetStroke.Transparency = 0.2
    resetStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local strokeGrad = Instance.new("UIGradient", resetStroke)
    strokeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    R_RED_DEEP),
        ColorSequenceKeypoint.new(0.3,  R_RED_DARK),
        ColorSequenceKeypoint.new(0.5,  R_RED),
        ColorSequenceKeypoint.new(0.7,  R_RED_DARK),
        ColorSequenceKeypoint.new(1,    R_RED_DEEP),
    })

    local resetTxt = Instance.new("TextLabel", resetBtn)
    resetTxt.Size = UDim2.new(1, 0, 1, 0)
    resetTxt.BackgroundTransparency = 1
    resetTxt.Text = "RESET ALL CONFIG"
    resetTxt.TextColor3 = R_RED
    resetTxt.Font = Enum.Font.GothamBlack
    resetTxt.TextSize = getMobileOptimized(13, 12)
    resetTxt.ZIndex = 7
    local txtGrad = Instance.new("UIGradient", resetTxt)
    txtGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, R_RED),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(245, 245, 245)),
        ColorSequenceKeypoint.new(1, R_RED),
    })

    resetBtn.MouseEnter:Connect(function()
        TweenService:Create(resetBtn, TweenInfo.new(0.15), {BackgroundColor3 = R_BG_HOV}):Play()
        TweenService:Create(resetStroke, TweenInfo.new(0.15), {Transparency = 0.05, Thickness = 1.8}):Play()
    end)
    resetBtn.MouseLeave:Connect(function()
        TweenService:Create(resetBtn, TweenInfo.new(0.15), {BackgroundColor3 = R_BG}):Play()
        TweenService:Create(resetStroke, TweenInfo.new(0.15), {Transparency = 0.2, Thickness = 1.4}):Play()
    end)

    local confirmState = false
    local confirmTimer = nil

    local function setRedTheme()
        TweenService:Create(resetBtn, TweenInfo.new(0.2), {BackgroundColor3 = R_BG}):Play()
        TweenService:Create(resetStroke, TweenInfo.new(0.2), {Color = R_RED}):Play()
        resetTxt.Text = "RESET ALL CONFIG"
        resetTxt.TextColor3 = R_RED
        txtGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, R_RED),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(245, 245, 245)),
            ColorSequenceKeypoint.new(1, R_RED),
        })
        strokeGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,    R_RED_DEEP),
            ColorSequenceKeypoint.new(0.3,  R_RED_DARK),
            ColorSequenceKeypoint.new(0.5,  R_RED),
            ColorSequenceKeypoint.new(0.7,  R_RED_DARK),
            ColorSequenceKeypoint.new(1,    R_RED_DEEP),
        })
        resetGlow.ImageColor3 = R_RED
    end


    local function setGreenTheme()
        TweenService:Create(resetBtn, TweenInfo.new(0.2), {BackgroundColor3 = R_BG_DONE}):Play()
        TweenService:Create(resetStroke, TweenInfo.new(0.2), {Color = R_GREEN}):Play()
        resetTxt.TextColor3 = R_GREEN
        txtGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, R_GREEN),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 255, 220)),
            ColorSequenceKeypoint.new(1, R_GREEN),
        })
        strokeGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(40, 100, 60)),
            ColorSequenceKeypoint.new(0.5, R_GREEN),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(40, 100, 60)),
        })
        resetGlow.ImageColor3 = R_GREEN
    end

    resetBtn.MouseButton1Click:Connect(function()

        if confirmTimer then pcall(function() task.cancel(confirmTimer) end); confirmTimer = nil end
        resetTxt.Text = "RESETTING..."

        pcall(function()
            local files = {
                "Velt7Config.json",
                "KrixBtnPosV2.json",
                "AutoPlayConfig.json",
                "KrixDesync_settings.json",
                "HazeHub.json",
                "VynxHub.json",
                "VynxHubConfig.json",
                "VezyUserConfigs.json",
            }
            for _, fname in ipairs(files) do
                pcall(function()
                    if isfile and isfile(fname) and delfile then
                        delfile(fname)
                    end
                end)
            end
        end)

        pcall(function()
            if _G.VezyResetAllToDefaults then _G.VezyResetAllToDefaults() end
        end)

        task.wait(0.4)
        setGreenTheme()
        resetTxt.Text = "DONE"

        confirmState = false
        confirmTimer = task.delay(1.6, function()
            confirmTimer = nil
            if resetBtn.Parent then setRedTheme() end
        end)
    end)

end

do
    local _isF = isfile or (syn and syn.isfile) or (getgenv and getgenv().isfile)
    local _rdF = readfile or (syn and syn.readfile) or (getgenv and getgenv().readfile)


end

sectionHeader(pSettings, "CONFIGS", 30)




_G._VezyUserConfigs = _G._VezyUserConfigs or {}
_G._VezyUserConfigButtons = _G._VezyUserConfigButtons or {}
_G._VezyUserConfigOrder = _G._VezyUserConfigOrder or 40

_G.VezyBuildConfigSnapshot = function()
    if type(_G._VioletteCollectConfig) == "function" then
        local ok, full = pcall(_G._VioletteCollectConfig)
        if ok and type(full) == "table" then return full end
    end
    local snap = {}
    pcall(function()
        snap.StealRadius = Settings.StealRadius
        snap.StealDuration = Settings.StealDuration
        snap.LAGGER_SPEED = LAGGER_SPEED
        snap.SpeedFamily  = Spd.family
        snap.SpeedCarry   = Spd.carry
        snap.SpeedMethod  = _G._VynxSpeedMethod
        snap.LaggerSpeed_Normal = _G.LaggerSpeed_Normal
        snap.LaggerSpeed_Carry = _G.LaggerSpeed_Carry
        snap.DesyncSpeed_Normal = _G.DesyncSpeed_Normal
        snap.DesyncSpeed_Carry = _G.DesyncSpeed_Carry
        snap.NormalSpeed_Normal = _G.NormalSpeed_Normal
        snap.NormalSpeed_Carry = _G.NormalSpeed_Carry
        snap.SpeedToggleKey = Keybinds.SpeedToggle.Name
        snap.LaggerToggleKey = Keybinds.LaggerToggle.Name
        snap.AutoBatKey = Keybinds.AutoBat.Name
        snap.DropBrainrotKey = Keybinds.DropBrainrot.Name
        snap.TPDownKey = Keybinds.TPDown.Name
        snap.LaggerSpeedKey = Keybinds.LaggerSpeed and Keybinds.LaggerSpeed.Name or "B"
        snap.DesyncSpeedKey = Keybinds.DesyncSpeed and Keybinds.DesyncSpeed.Name or "N"
        snap.NormalSpeedKey = Keybinds.NormalSpeed and Keybinds.NormalSpeed.Name or "K"
        snap.InstaResetKey = _G._VynxInstaResetKey
        snap.MedusaCounter = medusaCounterEnabled
        snap.BatCounter = BC and BC.enabled
        snap.AntiRagdoll = Enabled.AntiRagdoll
        snap.InfiniteJump = Enabled.InfiniteJump
        snap.Unwalk = Enabled.Unwalk
    end)
    return snap
end

_G.VezyApplyConfig = function(snap)
    if not snap then return end

    if type(snap.globals) == "table" and type(_G._VioletteApplyConfig) == "function" then
        pcall(_G._VioletteApplyConfig, snap)
        if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
        return
    end

    if _G.VezyResetAllToDefaults then pcall(_G.VezyResetAllToDefaults) end
    task.wait(0.05)
    pcall(function()
        if snap.StealRadius then
            Settings.StealRadius = snap.StealRadius
            Values.STEAL_RADIUS = snap.StealRadius
            if RadiusInput then RadiusInput.Text = tostring(snap.StealRadius) end
        end
        Settings.StealDuration = STEAL_DURATION_FIXED
        Values.STEAL_DURATION  = STEAL_DURATION_FIXED
        if snap.LAGGER_SPEED then
            LAGGER_SPEED = snap.LAGGER_SPEED
            if lsb then lsb.Text = tostring(snap.LAGGER_SPEED) end
        end
        if snap.LaggerSpeed_Normal then _G.LaggerSpeed_Normal = snap.LaggerSpeed_Normal end
        if snap.LaggerSpeed_Carry then _G.LaggerSpeed_Carry = snap.LaggerSpeed_Carry end
        if snap.DesyncSpeed_Normal then _G.DesyncSpeed_Normal = snap.DesyncSpeed_Normal end
        if snap.DesyncSpeed_Carry then _G.DesyncSpeed_Carry = snap.DesyncSpeed_Carry end
        if snap.NormalSpeed_Normal then _G.NormalSpeed_Normal = snap.NormalSpeed_Normal end
        if snap.NormalSpeed_Carry then _G.NormalSpeed_Carry = snap.NormalSpeed_Carry end
        if snap.SpeedMethod == "V1" or snap.SpeedMethod == "V2" then
            _G._VynxSpeedMethod = snap.SpeedMethod
            if _G._VynxRefreshSpeedMethod then pcall(_G._VynxRefreshSpeedMethod) end
        end
        Spd.SetProfile(snap.SpeedFamily or "normal", snap.SpeedCarry == true)
        local function _f(v) return (v == math.floor(v)) and tostring(math.floor(v)) or string.format("%.1f", v) end
        if lagNormalInput then lagNormalInput.Text = _f(_G.LaggerSpeed_Normal) end
        if lagCarryInput  then lagCarryInput.Text  = _f(_G.LaggerSpeed_Carry)  end
        if dsyNormalInput then dsyNormalInput.Text = _f(_G.DesyncSpeed_Normal) end
        if dsyCarryInput  then dsyCarryInput.Text  = _f(_G.DesyncSpeed_Carry)  end
        if normNormalInput then normNormalInput.Text = _f(_G.NormalSpeed_Normal) end
        if normCarryInput  then normCarryInput.Text  = _f(_G.NormalSpeed_Carry)  end
        if snap.SpeedToggleKey and Enum.KeyCode[snap.SpeedToggleKey] then Keybinds.SpeedToggle = Enum.KeyCode[snap.SpeedToggleKey] end
        if snap.LaggerToggleKey and Enum.KeyCode[snap.LaggerToggleKey] then Keybinds.LaggerToggle = Enum.KeyCode[snap.LaggerToggleKey] end
        if snap.AutoBatKey and Enum.KeyCode[snap.AutoBatKey] then Keybinds.AutoBat = Enum.KeyCode[snap.AutoBatKey] end
        if snap.DropBrainrotKey and Enum.KeyCode[snap.DropBrainrotKey] then Keybinds.DropBrainrot = Enum.KeyCode[snap.DropBrainrotKey] end
        if snap.TPDownKey and Enum.KeyCode[snap.TPDownKey] then Keybinds.TPDown = Enum.KeyCode[snap.TPDownKey] end
        if snap.LaggerSpeedKey and Enum.KeyCode[snap.LaggerSpeedKey] then Keybinds.LaggerSpeed = Enum.KeyCode[snap.LaggerSpeedKey] end
        if snap.DesyncSpeedKey and Enum.KeyCode[snap.DesyncSpeedKey] then Keybinds.DesyncSpeed = Enum.KeyCode[snap.DesyncSpeedKey] end
        if snap.NormalSpeedKey and Enum.KeyCode[snap.NormalSpeedKey] then Keybinds.NormalSpeed = Enum.KeyCode[snap.NormalSpeedKey] end
        if snap.InstaResetKey then _G._VynxInstaResetKey = snap.InstaResetKey end
        if snap.MedusaCounter ~= nil then
            medusaCounterEnabled = snap.MedusaCounter
            if VisualSetters.MedusaCounter then VisualSetters.MedusaCounter(snap.MedusaCounter) end
        end
        if snap.BatCounter ~= nil and BC then
            BC.enabled = snap.BatCounter
            if VisualSetters.BatCounter then VisualSetters.BatCounter(snap.BatCounter) end
        end

        for kName, lbl in pairs(KB) do
            if Keybinds[kName] and lbl and lbl.Parent then lbl.Text = _G._VioletteKeyName(Keybinds[kName]) end
        end
    end)
    if _G.KRIXSaveNow then _G.KRIXSaveNow() end
end

_G.VezyResetAllToDefaults = function()
    _G._VioletteSettingsReset = true
    pcall(function()

        for k in pairs(Keybinds) do
            Keybinds[k] = Enum.KeyCode.Unknown
        end
        if type(_G._AdaptAPKeybinds) == "table" then
            for k in pairs(_G._AdaptAPKeybinds) do
                _G._AdaptAPKeybinds[k] = Enum.KeyCode.Unknown
            end
        end
        _G._VynxInstaResetKey = nil
        for _, lbl in pairs(KB) do
            if typeof(lbl) == "Instance" and lbl:IsA("TextLabel") then lbl.Text = "..." end
        end

        NORMAL_SPEED = 60
        CARRY_SPEED  = 29
        LAGGER_SPEED = 50
        _G._BASE_NORMAL = 60
        _G._BASE_CARRY  = 29
        _G.NormalSpeed_Normal = 60
        _G.NormalSpeed_Carry  = 29
        _G.LaggerSpeed_Normal = 50
        _G.LaggerSpeed_Carry  = 25
        _G.DesyncSpeed_Normal = 65
        _G.DesyncSpeed_Carry  = 33
        _G._VynxSpeedMethod = "V1"
        if _G._VynxRefreshSpeedMethod then pcall(_G._VynxRefreshSpeedMethod) end
        Spd.SetProfile("normal", false)

        Settings.StealRadius   = 62
        Settings.StealDuration = STEAL_DURATION_FIXED
        Values.STEAL_RADIUS    = 62
        Values.STEAL_DURATION  = STEAL_DURATION_FIXED

        if RadiusInput then RadiusInput.Text = "62" end
        if nsb then nsb.Text = tostring(NORMAL_SPEED) end
        if csb then csb.Text = tostring(CARRY_SPEED) end
        if lsb then lsb.Text = tostring(LAGGER_SPEED) end
        local function _f(v) return (v == math.floor(v)) and tostring(math.floor(v)) or string.format("%.1f", v) end
        if lagNormalInput then lagNormalInput.Text = _f(_G.LaggerSpeed_Normal) end
        if lagCarryInput  then lagCarryInput.Text  = _f(_G.LaggerSpeed_Carry)  end
        if dsyNormalInput then dsyNormalInput.Text = _f(_G.DesyncSpeed_Normal) end
        if dsyCarryInput  then dsyCarryInput.Text  = _f(_G.DesyncSpeed_Carry)  end
        if normNormalInput then normNormalInput.Text = _f(_G.NormalSpeed_Normal) end
        if normCarryInput  then normCarryInput.Text  = _f(_G.NormalSpeed_Carry)  end

        Enabled.AutoSteal = false
        if VisualSetters.AutoSteal then pcall(VisualSetters.AutoSteal, false) end

        Enabled.AutoBat = false
        autoBatToggled = false
        if VisualSetters.AutoBat then pcall(VisualSetters.AutoBat, false) end

        if VisualSetters.AutoSwing then pcall(VisualSetters.AutoSwing, false) end
        if VisualSetters.HarderHitAnim then pcall(VisualSetters.HarderHitAnim, false) end
        medusaCounterEnabled = false
        if VisualSetters.MedusaCounter then pcall(VisualSetters.MedusaCounter, false) end
        if BC then BC.enabled = false end
        if VisualSetters.BatCounter then pcall(VisualSetters.BatCounter, false) end
        if VisualSetters.BatCounterChase then pcall(VisualSetters.BatCounterChase, false) end
        if VisualSetters.FastestSteal then pcall(VisualSetters.FastestSteal, false) end
        if VisualSetters.Desync then pcall(VisualSetters.Desync, false) end
        if VisualSetters.BrainrotReturnL then pcall(VisualSetters.BrainrotReturnL, false) end
        if VisualSetters.BrainrotReturnR then pcall(VisualSetters.BrainrotReturnR, false) end

        Enabled.InfiniteJump = false
        if VisualSetters.InfiniteJump then pcall(VisualSetters.InfiniteJump, false) end
        Enabled.AntiRagdoll = false
        if VisualSetters.AntiRagdoll then pcall(VisualSetters.AntiRagdoll, false) end
        Enabled.Unwalk = false
        if VisualSetters.Unwalk then pcall(VisualSetters.Unwalk, false) end

        if VisualSetters.StretchRez then pcall(VisualSetters.StretchRez, false) end
        if VisualSetters.NoCamCollision then pcall(VisualSetters.NoCamCollision, false) end
        if VisualSetters.AntiLag then pcall(VisualSetters.AntiLag, false) end
        if VisualSetters.UltraMode then pcall(VisualSetters.UltraMode, false) end
        Enabled.RemoveAccessories = false
        if VisualSetters.RemoveAccessories then pcall(VisualSetters.RemoveAccessories, false) end
        Enabled.Optimizer = false

        _G._VezyJumpMode = "Single"
        if _G._VezyCustomFontOn then
            _G._VezyCustomFontOn = false
            if _G.VezyDisableCustomFont then pcall(_G.VezyDisableCustomFont) end
        end

        _G._VezyStretchFOV = 120

        _G._VezyBatAimbotSpeed = 58
        _G._VezyBatAimbotSpeedLagger = 40
        _G._VezyBatAimbotSpeedCustom = 58
        _G._VezyBatAimbotOn = false
        if _G.VezyStopBatAimbot then pcall(_G.VezyStopBatAimbot) end
        _G._VezyBatCounterOn = false
        if _G.VezyStopBatCounter then pcall(_G.VezyStopBatCounter) end

        for _, setter in pairs(VisualSetters) do pcall(setter, false) end
        for eName in pairs(Enabled) do Enabled[eName] = false end

        for kName, lbl in pairs(KB) do
            if lbl and lbl.Parent then
                local kc = Keybinds[kName]
                lbl.Text = _G._VioletteKeyName(kc)
            end
        end
        if _G._VynxRefreshDuelLaggerKey then pcall(_G._VynxRefreshDuelLaggerKey) end
        if _G._VynxRefreshInstaResetKey then pcall(_G._VynxRefreshInstaResetKey) end

        pcall(function()
            _G._VezyMobileBtnPos = {}
            _G._VynxMobileBtnScale = 1.20
            if _G._VynxResetMobileBtnPos then _G._VynxResetMobileBtnPos() end
            if _G._VynxApplyMobileBtnScale then _G._VynxApplyMobileBtnScale(1.20) end
            if _G._VynxRefreshMobileBtnSizeButtons then _G._VynxRefreshMobileBtnSizeButtons() end
        end)
        pcall(function()
            _G._AdaptStealBarScale = 1.0
            if _G._VynxResetStealBarPos then _G._VynxResetStealBarPos() end
            if _G._RaVeSetStealBarScale then _G._RaVeSetStealBarScale(100 * (_G._VioletteDeviceScale or 1)) end
            if _G._VynxRefreshStealBarScale then pcall(_G._VynxRefreshStealBarScale) end
        end)
        pcall(function()
            if _G._VioletteResetPanels then _G._VioletteResetPanels() end
            for _, st in ipairs({ _G._VioletteDuelLagger, _G._ViolettePingLagger, _G._VioletteSpeedBypass }) do
                if type(st) == "table" then st.key = nil end
            end
            if _G._VioletteRefreshAllPanelKeys then pcall(_G._VioletteRefreshAllPanelKeys) end
        end)
        pcall(function()
            local outer = _G.VynxOuterRef
            if outer and outer.Parent then
                outer.Position = UDim2.new(0, 20, 0, 110)
                outer.Size = UDim2.new(0, 330, 0, 470)
            end
            UI_SCALE = 1.0
            if _G._VynxApplyUIScale then _G._VynxApplyUIScale(1.0) end
            if _G._VynxRefreshUISizeButtons then pcall(_G._VynxRefreshUISizeButtons) end
        end)
    end)
    _G._VioletteSettingsReset = false
    if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
end

_G.VezySaveUserConfigs = function()
    if not writefile then return end
    pcall(function()
        local json = HttpService:JSONEncode(_G._VezyUserConfigs)
        writefile("VezyUserConfigs.json", json)
    end)
end

_G.VezyLoadUserConfigs = function()
    if not readfile then return end
    pcall(function()
        if isfile and isfile("VezyUserConfigs.json") then
            local data = readfile("VezyUserConfigs.json")
            local ok, decoded = pcall(function() return HttpService:JSONDecode(data) end)
            if ok and type(decoded) == "table" then
                _G._VezyUserConfigs = decoded
            end
        end
    end)
end

local function makeUserConfigRow(name)
    local row = Instance.new("Frame", pSettings)
    row.Name = "UserConfig_" .. name
    row.Size = UDim2.new(1, 0, 0, getMobileOptimized(38, 34))
    row.BackgroundColor3 = CARD
    row.BorderSizePixel = 0
    _G._VezyUserConfigOrder = _G._VezyUserConfigOrder + 1
    row.LayoutOrder = _G._VezyUserConfigOrder
    row.ZIndex = 4
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 12)
    local rSt = Instance.new("UIStroke", row)
    rSt.Color = ACC; rSt.Thickness = 1; rSt.Transparency = 0.5

    local loadBtn = Instance.new("TextButton", row)
    loadBtn.Size = UDim2.new(1, -42, 1, 0)
    loadBtn.Position = UDim2.new(0, 0, 0, 0)
    loadBtn.BackgroundTransparency = 1
    loadBtn.Text = string.upper(name)
    loadBtn.TextColor3 = WHITE
    loadBtn.Font = Enum.Font.GothamBold
    loadBtn.TextSize = getMobileOptimized(11, 10)
    loadBtn.AutoButtonColor = false
    loadBtn.ZIndex = 5

    local delBtn = Instance.new("TextButton", row)
    delBtn.Size = UDim2.new(0, 30, 0, 22)
    delBtn.Position = UDim2.new(1, -36, 0.5, -11)
    delBtn.BackgroundColor3 = Color3.fromRGB(35, 22, 22)
    delBtn.BorderSizePixel = 0
    delBtn.Text = "x"
    delBtn.TextColor3 = Color3.fromRGB(230, 110, 110)
    delBtn.Font = Enum.Font.GothamBold
    delBtn.TextSize = 12
    delBtn.AutoButtonColor = false
    delBtn.ZIndex = 6
    Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 6)

    row.MouseEnter:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = CARD2}):Play()
        TweenService:Create(rSt, TweenInfo.new(0.15), {Transparency = 0.1}):Play()
    end)
    row.MouseLeave:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = CARD}):Play()
        TweenService:Create(rSt, TweenInfo.new(0.15), {Transparency = 0.5}):Play()
    end)

    loadBtn.MouseButton1Click:Connect(function()
        if _G._VezyUserConfigs[name] then
            _G.VezyApplyConfig(_G._VezyUserConfigs[name])
            TweenService:Create(row, TweenInfo.new(0.1), {BackgroundColor3 = ACC}):Play()
            loadBtn.Text = "LOADED!"
            loadBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            task.delay(1.2, function()
                if row and row.Parent then
                    TweenService:Create(row, TweenInfo.new(0.3), {BackgroundColor3 = CARD}):Play()
                    loadBtn.Text = string.upper(name)
                    loadBtn.TextColor3 = WHITE
                end
            end)
        end
    end)

    delBtn.MouseEnter:Connect(function()
        TweenService:Create(delBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(70, 30, 30)}):Play()
    end)
    delBtn.MouseLeave:Connect(function()
        TweenService:Create(delBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 22, 22)}):Play()
    end)
    delBtn.MouseButton1Click:Connect(function()
        _G._VezyUserConfigs[name] = nil
        _G._VezyUserConfigButtons[name] = nil
        if _G.VezySaveUserConfigs then _G.VezySaveUserConfigs() end

        TweenService:Create(row, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
        task.delay(0.25, function() if row and row.Parent then row:Destroy() end end)
    end)

    _G._VezyUserConfigButtons[name] = row
    return row
end

do
    local saveRow = Instance.new("Frame", pSettings)
    saveRow.Size = UDim2.new(1, 0, 0, getMobileOptimized(38, 34))
    saveRow.BackgroundTransparency = 1
    saveRow.BorderSizePixel = 0
    saveRow.LayoutOrder = 31
    saveRow.ZIndex = 4

    local inputBg = Instance.new("Frame", saveRow)
    inputBg.Size = UDim2.new(0.65, -4, 1, 0)
    inputBg.Position = UDim2.new(0, 0, 0, 0)
    inputBg.BackgroundColor3 = CARD
    inputBg.BorderSizePixel = 0
    Instance.new("UICorner", inputBg).CornerRadius = UDim.new(0, 12)
    local inSt = Instance.new("UIStroke", inputBg)
    inSt.Color = ACC; inSt.Thickness = 1; inSt.Transparency = 0.5

    local nameBox = Instance.new("TextBox", inputBg)
    nameBox.Size = UDim2.new(1, -16, 1, 0)
    nameBox.Position = UDim2.new(0, 8, 0, 0)
    nameBox.BackgroundTransparency = 1
    nameBox.Text = ""
    nameBox.PlaceholderText = "Config name..."
    nameBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
    nameBox.TextColor3 = WHITE
    nameBox.Font = Enum.Font.GothamBold
    nameBox.TextSize = getMobileOptimized(11, 10)
    nameBox.TextXAlignment = Enum.TextXAlignment.Left
    nameBox.ClearTextOnFocus = false
    nameBox.ZIndex = 5

    nameBox.Focused:Connect(function()
        TweenService:Create(inSt, TweenInfo.new(0.15), {Color = ACC, Transparency = 0}):Play()
    end)
    nameBox.FocusLost:Connect(function()
        TweenService:Create(inSt, TweenInfo.new(0.15), {Color = ACC, Transparency = 0.5}):Play()
    end)

    local saveBtn = Instance.new("TextButton", saveRow)
    saveBtn.Size = UDim2.new(0.35, -4, 1, 0)
    saveBtn.Position = UDim2.new(0.65, 4, 0, 0)
    saveBtn.BackgroundColor3 = ACC
    saveBtn.BorderSizePixel = 0
    saveBtn.Text = "SAVE"
    saveBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    saveBtn.Font = Enum.Font.GothamBlack
    saveBtn.TextSize = getMobileOptimized(11, 10)
    saveBtn.AutoButtonColor = false
    saveBtn.ZIndex = 5
    Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 12)

    saveBtn.MouseEnter:Connect(function()
        TweenService:Create(saveBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(225, 225, 225)}):Play()
    end)
    saveBtn.MouseLeave:Connect(function()
        TweenService:Create(saveBtn, TweenInfo.new(0.15), {BackgroundColor3 = ACC}):Play()
    end)

    saveBtn.MouseButton1Click:Connect(function()
        local name = (nameBox.Text or ""):gsub("^%s*(.-)%s*$", "%1")
        if name == "" then

            local origPos = inputBg.Position
            for i = 1, 3 do
                TweenService:Create(inputBg, TweenInfo.new(0.04), {Position = UDim2.new(origPos.X.Scale, origPos.X.Offset + 6, origPos.Y.Scale, origPos.Y.Offset)}):Play()
                task.wait(0.05)
                TweenService:Create(inputBg, TweenInfo.new(0.04), {Position = UDim2.new(origPos.X.Scale, origPos.X.Offset - 6, origPos.Y.Scale, origPos.Y.Offset)}):Play()
                task.wait(0.05)
            end
            TweenService:Create(inputBg, TweenInfo.new(0.05), {Position = origPos}):Play()
            return
        end

        if #name > 20 then name = name:sub(1, 20) end

        _G._VezyUserConfigs[name] = _G.VezyBuildConfigSnapshot()
        if _G.VezySaveUserConfigs then _G.VezySaveUserConfigs() end

        if not _G._VezyUserConfigButtons[name] then
            makeUserConfigRow(name)
        end
        nameBox.Text = ""

        TweenService:Create(saveBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(235, 235, 235)}):Play()
        saveBtn.Text = "SAVED!"
        task.delay(1.0, function()
            if saveBtn and saveBtn.Parent then
                TweenService:Create(saveBtn, TweenInfo.new(0.3), {BackgroundColor3 = ACC}):Play()
                saveBtn.Text = "SAVE"
            end
        end)
    end)
end

task.spawn(function()
    task.wait(0.5)
    pcall(function() _G.VezyLoadUserConfigs() end)
    if _G._VezyUserConfigs then
        for name, _ in pairs(_G._VezyUserConfigs) do
            if not _G._VezyUserConfigButtons[name] then
                pcall(function() makeUserConfigRow(name) end)
            end
        end
    end
end)

local RE_W = getMobileOptimized(92, 82)
local RE_H = getMobileOptimized(26, 24)

reopenBtn = Instance.new("TextButton", gui)
reopenBtn.Name = "VioletteReopen"
reopenBtn.Size = UDim2.new(0, RE_W, 0, RE_H)
reopenBtn.AnchorPoint = Vector2.new(0.5, 0)
reopenBtn.Position = UDim2.new(0, 144, 0, 0)
reopenBtn.BackgroundColor3 = Color3.fromRGB(5, 5, 7)
reopenBtn.BackgroundTransparency = 0.02
reopenBtn.BorderSizePixel = 0
reopenBtn.AutoButtonColor = false
reopenBtn.Text = "VIOLETTE"
reopenBtn.TextColor3 = ACC
reopenBtn.Font = Enum.Font.GothamBlack
reopenBtn.TextSize = getMobileOptimized(11, 10)
reopenBtn.Active = true
reopenBtn.Visible = false
reopenBtn.ZIndex = 40
Instance.new("UICorner", reopenBtn).CornerRadius = UDim.new(1, 0)
local reopenStroke = Instance.new("UIStroke", reopenBtn)
reopenStroke.Color = Color3.fromRGB(55, 57, 63)
reopenStroke.Thickness = 1
reopenStroke.Transparency = 0.55
reopenStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

do
    local dragging, dragStart, startPos, moved, activeInput
    reopenBtn.InputBegan:Connect(function(input)
        if _G._VynxUILocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging, dragStart, startPos = true, input.Position, reopenBtn.Position
            moved, activeInput = false, input
            reopenBtn:SetAttribute("_Moved", false)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
           and input ~= activeInput then return end
        local delta = input.Position - dragStart
        if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
            moved = true
            reopenBtn:SetAttribute("_Moved", true)
        end
        reopenBtn.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end)
    UserInputService.InputEnded:Connect(function(input)
        if not dragging then return end
        if input == activeInput or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging, activeInput = false, nil
            if moved then
                task.delay(0.15, function() reopenBtn:SetAttribute("_Moved", false) end)
            end
        end
    end)
end

do

    _G._VynxMobileBtnScale = _G._VynxMobileBtnScale or 1.20
    local function _bsize() return math.clamp(_G._VynxMobileBtnScale or 1.0, 0.7, 2.0) * DEVICE_UI_SCALE end
    -- Keep the buttons compact so their touch targets do not interfere with
    -- Roblox's native movement and jump controls.
    local MB_BASE_W, MB_BASE_H = 60, 48
    local MB_BASE_GX, MB_BASE_GY = 68, 56
    local MB_W = math.floor(MB_BASE_W * _bsize() + 0.5)
    local MB_H = math.floor(MB_BASE_H * _bsize() + 0.5)
    local MB_GX = math.floor(MB_BASE_GX * _bsize() + 0.5)
    local MB_GY = math.floor(MB_BASE_GY * _bsize() + 0.5)
    local MB_BG        = Color3.fromRGB(8, 8, 10)
    local MB_BG_HOV    = Color3.fromRGB(20, 18, 24)
    local MB_TXT       = Color3.fromRGB(255, 255, 255)
    local MB_TXT_ON    = Color3.fromRGB(0, 0, 0)

    local MB_FULL_W = MB_GX * 2 + MB_W
    local MB_FULL_H = MB_GY * 3 + MB_H

    local mobileFrame = Instance.new("Frame", gui)
    mobileFrame.Name = "VezyMobileButtons"
    mobileFrame.Size = UDim2.new(0, MB_FULL_W, 0, MB_FULL_H)
    mobileFrame.Position = UDim2.new(1, -(MB_FULL_W + 18), 0.5, -MB_FULL_H / 2)
    mobileFrame.BackgroundTransparency = 1
    -- This transparent layout helper must never capture touch input.
    mobileFrame.Active = false
    mobileFrame.Selectable = false
    mobileFrame.ZIndex = 100
    _G._VezyMobileButtonsFrame = mobileFrame

    -- Layout 5 matches Kawatan: a two-column grid pinned to the right edge and
    -- centred vertically, clear of Roblox's movement and jump controls.
    local MOBILE_LAYOUT_VERSION = 6
    if _G._VynxMobileAppliedLayoutVersion ~= MOBILE_LAYOUT_VERSION then
        _G._VezyMobileBtnPos = nil
        _G._VynxMobileAppliedLayoutVersion = MOBILE_LAYOUT_VERSION
    end
    _G._VynxMobileLayoutVersion = MOBILE_LAYOUT_VERSION

    local mobileBtnDefs = {
        {name = "AUTO\nLEFT",    key = "autoLeft",    col = 0, row = 0},
        {name = "DROP",          key = "drop",        col = 1, row = 0},
        {name = "CUSTOM\nCARRY", key = "customCarry", col = 2, row = 0},
        {name = "AUTO\nRIGHT",   key = "autoRight",   col = 0, row = 1},
        {name = "AIMBOT",        key = "batLock",     col = 1, row = 1},
        {name = "CUSTOM\nSPEED", key = "customSpeed", col = 2, row = 1},
        {name = "CARRY\nSPEED",  key = "carry",       col = 0, row = 2},
        {name = "TP DOWN",       key = "tpDown",      col = 1, row = 2},
        {name = "LAGGER\nSPEED", key = "laggerSpeed", col = 0, row = 3},
        {name = "LAGGER\nCARRY", key = "laggerCarry", col = 1, row = 3},
        {name = "INSTA\nRESET",  key = "reset",       col = 0, row = 4},
    }

    -- Kawatan's grid geometry: 8px between cells, 12px in from the screen edge,
    -- rows centred on the vertical midpoint. col counts outward from the right
    -- screen edge, so col 0 sits flush right.
    local MB_CELL_GAP = 8
    local MB_EDGE_PAD = 12
    local MB_ROWS = 1
    for _, def in ipairs(mobileBtnDefs) do
        if def.row + 1 > MB_ROWS then MB_ROWS = def.row + 1 end
    end

    local mobileButtonRefs = {}
    for _, def in ipairs(mobileBtnDefs) do
        local btn = Instance.new("TextButton", gui)
        btn.Name = "MB_" .. def.key
        btn.Size = UDim2.new(0, MB_W, 0, MB_H)

        local baseX = -((def.col + 1) * MB_W + def.col * MB_CELL_GAP + MB_EDGE_PAD)
        local baseY = (def.row - (MB_ROWS - 1) / 2) * (MB_H + MB_CELL_GAP) - MB_H / 2

        local savedPos = _G._VezyMobileBtnPos and _G._VezyMobileBtnPos[def.key]
        if savedPos then
            btn.Position = UDim2.new(savedPos.xs, savedPos.xo, savedPos.ys, savedPos.yo)
        else
            btn.Position = UDim2.new(1, baseX, 0.5, baseY)
        end
        btn.BackgroundColor3 = MB_BG
        btn.BorderSizePixel = 0
        btn.Text = def.name
        btn.TextColor3 = MB_TXT
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = math.floor(13 * _bsize() + 0.5)
        btn.TextWrapped = true
        btn.AutoButtonColor = false
        btn.ZIndex = 101
        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 16)
        btn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        btn.TextStrokeTransparency = 1
        addGlow(btn, 16)
        local bSt = btn:FindFirstChildOfClass("UIStroke")
        bSt.Thickness = 3.5
        bSt.Transparency = 1
        mobileButtonRefs[def.key] = {btn = btn, stroke = bSt, corner = btnCorner, active = false, dragGuard = false}

        btn.MouseEnter:Connect(function()
            if mobileButtonRefs[def.key].active then return end
            TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = MB_BG_HOV}):Play()
        end)
        btn.MouseLeave:Connect(function()
            if mobileButtonRefs[def.key].active then return end
            TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = MB_BG}):Play()
        end)

        do
            local ref = mobileButtonRefs[def.key]
            local pressing, dragging = false, false
            local pressPos, btnStart = nil, nil
            local DRAG_THRESHOLD = 6

            btn.InputBegan:Connect(function(input)
                if _G._VynxUILocked then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1
                   or input.UserInputType == Enum.UserInputType.Touch then
                    pressing = true
                    dragging = false
                    pressPos = input.Position
                    btnStart = btn.Position
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType ~= Enum.UserInputType.MouseButton1
                   and input.UserInputType ~= Enum.UserInputType.Touch then return end
                if not pressing then return end
                pressing = false
                if dragging then
                    dragging = false
                    _G._VezyMobileBtnPos = _G._VezyMobileBtnPos or {}
                    _G._VezyMobileBtnPos[def.key] = {
                        xs = btn.Position.X.Scale, xo = btn.Position.X.Offset,
                        ys = btn.Position.Y.Scale, yo = btn.Position.Y.Offset,
                    }
                    if _G.KRIXSaveNow then _G.KRIXSaveNow() end
                    task.delay(0.15, function() ref.dragGuard = false end)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if not pressing then return end
                if input.UserInputType ~= Enum.UserInputType.MouseMovement
                   and input.UserInputType ~= Enum.UserInputType.Touch then return end
                local delta = input.Position - pressPos
                if not dragging then
                    if math.abs(delta.X) > DRAG_THRESHOLD or math.abs(delta.Y) > DRAG_THRESHOLD then
                        dragging = true
                        ref.dragGuard = true
                    end
                end
                if dragging then
                    btn.Position = UDim2.new(
                        btnStart.X.Scale, btnStart.X.Offset + delta.X,
                        btnStart.Y.Scale, btnStart.Y.Offset + delta.Y
                    )
                end
            end)
        end
    end

    local function setMobileBtnState(key, on)
        local ref = mobileButtonRefs[key]
        if not ref then return end
        ref.active = on
        TweenService:Create(ref.btn, TweenInfo.new(0.12), {
            BackgroundColor3 = on and (_G._VioletteAccent or ACC) or MB_BG,
            TextColor3 = on and MB_TXT_ON or MB_TXT,
            TextStrokeTransparency = 1,
        }):Play()
        TweenService:Create(ref.stroke, TweenInfo.new(0.12), {
            Transparency = on and 0 or 1,
            Thickness = 3.5,
        }):Play()
    end
    _G._VynxSetMobileBtnState = setMobileBtnState

    _G._VynxMobileDropBR = function()
        if runDropBrainrot then task.spawn(runDropBrainrot) end
        setMobileBtnState("drop", true)
        task.delay(0.15, function() setMobileBtnState("drop", false) end)
    end

    local function apState()
        local ap = _G._AutoPath
        return (ap and ap.L) == true, (ap and ap.R) == true
    end

    _G._VynxMobileAutoLeft = function()
        local l = apState()
        if _G._VynxToggleAutoLeft then pcall(_G._VynxToggleAutoLeft) end
        local nl, nr = apState()
        setMobileBtnState("autoLeft", nl)
        setMobileBtnState("autoRight", nr)
    end

    _G._VynxMobileAutoRight = function()
        local _, r = apState()
        if _G._VynxToggleAutoRight then pcall(_G._VynxToggleAutoRight) end
        local nl, nr = apState()
        setMobileBtnState("autoLeft", nl)
        setMobileBtnState("autoRight", nr)
    end

    _G._VynxMobileTPDown = function()
        if _G._VynxRunTPDown then _G._VynxRunTPDown() end
        setMobileBtnState("tpDown", true)
        task.delay(0.15, function() setMobileBtnState("tpDown", false) end)
    end

    _G._VynxMobileCarry = function()
        Spd.Button("normal", true)
    end

    _G._VynxMobileBatBot = function()
        local newOn = not (_G._VezyBatAimbotOn or false)
        local setter = VisualSetters.AutoBat
        if setter then pcall(setter, newOn) end
        setMobileBtnState("batLock", _G._VezyBatAimbotOn == true)
        if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
    end

    _G._VynxMobileBatCtr = function()
        _G._VynxBatCounterActive = not (_G._VynxBatCounterActive or false)
        setMobileBtnState("batCounter", _G._VynxBatCounterActive)
        _G._VezyBatCounterOn = _G._VynxBatCounterActive
        if _G._VynxBatCounterActive then
            if _G.VezyStartBatCounter then _G.VezyStartBatCounter() end
        else
            if _G.VezyStopBatCounter then _G.VezyStopBatCounter() end
        end
        if VisualSetters.BatCounter then pcall(VisualSetters.BatCounter, _G._VynxBatCounterActive) end
    end

    _G._VynxMobileLagger = function()
        Spd.Button("lagger", true)
    end

    _G._VynxMobileReset = function()
        if _G.VynxDoInstaReset then pcall(_G.VynxDoInstaReset) end
        setMobileBtnState("reset", true)
        task.delay(0.15, function() setMobileBtnState("reset", false) end)
    end

    _G._VynxMobileLaggerSpeed = function()
        Spd.Button("lagger", false)
    end

    _G._VynxMobileCustomSpeed = function()
        Spd.Button("custom", false)
    end

    _G._VynxMobileCustomCarry = function()
        Spd.Button("custom", true)
    end

    _G._VioletteSyncMobileSpeedBtns = function()
        local want = {
            carry       = (Spd.family == "normal") and Spd.carry,
            customSpeed = (Spd.family == "custom") and not Spd.carry,
            customCarry = (Spd.family == "custom") and Spd.carry,
            laggerCarry = (Spd.family == "lagger") and Spd.carry,
            laggerSpeed = (Spd.family == "lagger") and not Spd.carry,
        }
        for key, on in pairs(want) do
            local ref = mobileButtonRefs[key]
            if ref and ref.active ~= (on and true or false) then
                setMobileBtnState(key, on and true or false)
            end
        end
    end

    local mobileActions = {
        drop        = function() _G._VynxMobileDropBR() end,
        autoLeft    = function() _G._VynxMobileAutoLeft() end,
        reset       = function() _G._VynxMobileReset() end,
        batLock     = function() _G._VynxMobileBatBot() end,
        autoRight   = function() _G._VynxMobileAutoRight() end,
        tpDown      = function() _G._VynxMobileTPDown() end,
        carry       = function() _G._VynxMobileCarry() end,
        customSpeed = function() _G._VynxMobileCustomSpeed() end,
        customCarry = function() _G._VynxMobileCustomCarry() end,
        laggerCarry = function() _G._VynxMobileLagger() end,
        laggerSpeed = function() _G._VynxMobileLaggerSpeed() end,
    }
    for key, fn in pairs(mobileActions) do
        local ref = mobileButtonRefs[key]
        if ref then
            ref.btn.MouseButton1Click:Connect(function()
                if ref.dragGuard then return end
                fn()
            end)
        end
    end

    task.spawn(function()
        while task.wait(0.15) do
            if hubStale() then break end
            local ap = _G._AutoPath
            local apL, apR = (ap and ap.L) == true, (ap and ap.R) == true
            if mobileButtonRefs["autoLeft"] and mobileButtonRefs["autoLeft"].active ~= apL then
                setMobileBtnState("autoLeft", apL)
            end
            if mobileButtonRefs["autoRight"] and mobileButtonRefs["autoRight"].active ~= apR then
                setMobileBtnState("autoRight", apR)
            end
            _G._VioletteSyncMobileSpeedBtns()
            if mobileButtonRefs["batLock"] and mobileButtonRefs["batLock"].active ~= (_G._VezyBatAimbotOn or false) then
                setMobileBtnState("batLock", _G._VezyBatAimbotOn or false)
            end
        end
    end)

    local MB_GAP = MB_BASE_GX - MB_BASE_W
    local function mbMetrics(s)
        local circle = _G._VynxMobileCircle == true
        local w   = math.floor(MB_BASE_W * s + 0.5)
        local h   = circle and w or math.floor(MB_BASE_H * s + 0.5)
        local gap = math.floor(MB_GAP * s + 0.5)
        local gx  = circle and (w + gap) or math.floor(MB_BASE_GX * s + 0.5)
        local gy  = circle and (h + gap) or math.floor(MB_BASE_GY * s + 0.5)
        return w, h, gx, gy
    end

    local function mbDefaultPos(def, s)
        local w, h = mbMetrics(s)
        local xOffset = -((def.col + 1) * w + def.col * MB_CELL_GAP + MB_EDGE_PAD)
        local yOffset = (def.row - (MB_ROWS - 1) / 2) * (h + MB_CELL_GAP) - h / 2
        return UDim2.new(1, xOffset, 0.5, yOffset)
    end

    _G._VynxResetMobileBtnPos = function()
        _G._VezyMobileBtnPos = {}
        local s = math.clamp(_G._VynxMobileBtnScale or 1.0, 0.7, 2.0)
        for _, def in ipairs(mobileBtnDefs) do
            local ref = mobileButtonRefs[def.key]
            if ref and ref.btn then
                TweenService:Create(ref.btn, TweenInfo.new(0.18), {Position = mbDefaultPos(def, s)}):Play()
            end
        end
        if _G.KRIXSaveNowInstant then pcall(_G.KRIXSaveNowInstant) end
        if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
    end

    _G._VynxMobileCircle = _G._VynxMobileCircle or false
    _G._VynxMobileShown  = _G._VynxMobileShown or {}

    _G._VynxMobileButtonList = {}
    for _, def in ipairs(mobileBtnDefs) do
        table.insert(_G._VynxMobileButtonList, {
            key = def.key,
            label = (def.name:gsub("\n", " ")),
        })
    end

    local function mbShown(key)
        if _G._VezyHideSideBtns == true then return false end
        return _G._VynxMobileShown[key] ~= false
    end

    _G._VynxApplyMobileBtnScale = function(newScale)
        _G._VynxMobileBtnScale = math.clamp(newScale or 1.0, 0.7, 2.0)
        local s = _G._VynxMobileBtnScale * DEVICE_UI_SCALE
        local circle = _G._VynxMobileCircle == true
        local nw, nh = mbMetrics(s)
        local newTextSize = math.floor((circle and 11 or 13) * s + 0.5)
        for _, def in ipairs(mobileBtnDefs) do
            local ref = mobileButtonRefs[def.key]
            if ref and ref.btn then
                ref.btn.Size = UDim2.new(0, nw, 0, nh)
                ref.btn.TextSize = newTextSize
                ref.btn.Visible = mbShown(def.key)
                if ref.corner then
                    ref.corner.CornerRadius = circle and UDim.new(1, 0) or UDim.new(0, 16)
                end
                if not (_G._VezyMobileBtnPos and _G._VezyMobileBtnPos[def.key]) then
                    ref.btn.Position = mbDefaultPos(def, s)
                end
            end
        end
    end

    _G._VynxSetMobileCircle = function(on)
        _G._VynxMobileCircle = on and true or false
        _G._VynxApplyMobileBtnScale(_G._VynxMobileBtnScale)
    end

    _G._VynxSetMobileButtonShown = function(key, on)
        _G._VynxMobileShown[key] = (on ~= false) and true or false
        local ref = mobileButtonRefs[key]
        if ref and ref.btn then ref.btn.Visible = mbShown(key) end
    end

    _G._VynxRefreshMobileButtons = function()
        _G._VynxApplyMobileBtnScale(_G._VynxMobileBtnScale)
    end

    _G._VynxApplyMobileBtnScale(_G._VynxMobileBtnScale)
end

reopenBtn.MouseButton1Click:Connect(function()
    if reopenBtn:GetAttribute("_Moved") then return end
    setHubVisible(true)
    if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
end)

xb.MouseButton1Click:Connect(function()
    setHubVisible(false)
    if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
end)

_G._VioletteSetMinimized = function(mini)
    setHubVisible(not mini)
end
UserInputService.InputBegan:Connect(function(i,g)
    if hubStale() then return end
    if g then return end
    if _G._VioletteKeyCaptureActive and _G._VioletteKeyCaptureActive() then return end
    if i.UserInputType == Enum.UserInputType.Keyboard then
        if i.KeyCode == Keybinds.UIToggle then
            setHubVisible(not _hubShown)
        end
    elseif _isGamepadInput(i) then
        if i.KeyCode == Enum.KeyCode.ButtonStart then
            setHubVisible(not _hubShown)
        end
    end
end)

local pb = Instance.new("Frame", gui)
pb.Name = "StealBar"
pb.Size = UDim2.new(0, 324, 0, 58)
pb.AnchorPoint = Vector2.new(0.5, 1)
pb.Position = UDim2.new(0.5, 0, 1, -24)
pb.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
pb.BackgroundTransparency = 0
pb.BorderSizePixel = 0
pb.Active = true
pb.ClipsDescendants = false
pb.ZIndex = 50
Instance.new("UICorner", pb).CornerRadius = UDim.new(0, 16)
local pbGrad = Instance.new("UIGradient", pb)
pbGrad.Rotation = 90
pbGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 110, 118)),
})
addGlow(pb, 16)
local pbRing = pb:FindFirstChildOfClass("UIStroke")
if pbRing then pbRing.Thickness = 2.4 end

local pbEdge = Instance.new("Frame", pb)
pbEdge.Name = "Edge"
pbEdge.Size = UDim2.new(1, 8, 1, 8)
pbEdge.Position = UDim2.new(0, -4, 0, -4)
pbEdge.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
pbEdge.BackgroundTransparency = 0
pbEdge.BorderSizePixel = 0
pbEdge.ZIndex = 49
Instance.new("UICorner", pbEdge).CornerRadius = UDim.new(0, 20)

local pbScale = Instance.new("UIScale", pb)
pbScale.Scale = math.clamp((_G._AdaptStealBarScale or 1.0), 0.5, 2.0) * DEVICE_UI_SCALE
_G._RaVeSetStealBarScale = function(percent)
    local p = math.clamp(tonumber(percent) or 100, 50, 200)
    pbScale.Scale = p / 100
end

_G._VynxResetStealBarPos = function()
    pb.Position = UDim2.new(0.5, 0, 1, -24)
    _G._VlPbPos = nil
    if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
end

local pctMiniLbl = Instance.new("TextLabel", pb)
pctMiniLbl.Name = "StealPercent"
pctMiniLbl.Size = UDim2.new(0, 90, 0, 18)
pctMiniLbl.Position = UDim2.new(0, 11, 0, 2)
pctMiniLbl.BackgroundTransparency = 1
pctMiniLbl.Text = "0%"
pctMiniLbl.TextColor3 = WHITE
pctMiniLbl.Font = Enum.Font.GothamBlack
pctMiniLbl.TextSize = 17
pctMiniLbl.TextXAlignment = Enum.TextXAlignment.Left
pctMiniLbl.ZIndex = 54

local INFO_Y, INFO_H, INFO_SIZE = 21, 13, 11

local sbFps = Instance.new("TextLabel", pb)
sbFps.Name = "StealFps"
sbFps.Size = UDim2.new(0, 90, 0, INFO_H)
sbFps.Position = UDim2.new(0, 11, 0, INFO_Y)
sbFps.BackgroundTransparency = 1
sbFps.Text = "FPS: 0"
sbFps.TextColor3 = Color3.fromRGB(190, 190, 198)
sbFps.Font = Enum.Font.GothamBold
sbFps.TextSize = INFO_SIZE
sbFps.TextXAlignment = Enum.TextXAlignment.Left
sbFps.ZIndex = 54

local sbMode = Instance.new("TextLabel", pb)
sbMode.Name = "StealModeInfo"
sbMode.Size = UDim2.new(0, 160, 0, INFO_H)
sbMode.Position = UDim2.new(0.5, -80, 0, INFO_Y)
sbMode.BackgroundTransparency = 1
sbMode.Text = "NORMAL 62 RADIUS"
sbMode.TextColor3 = Color3.fromRGB(190, 190, 198)
sbMode.Font = Enum.Font.GothamBold
sbMode.TextSize = INFO_SIZE
sbMode.TextXAlignment = Enum.TextXAlignment.Center
sbMode.ZIndex = 54

local sbPing = Instance.new("TextLabel", pb)
sbPing.Name = "StealPing"
sbPing.Size = UDim2.new(0, 90, 0, INFO_H)
sbPing.Position = UDim2.new(1, -101, 0, INFO_Y)
sbPing.BackgroundTransparency = 1
sbPing.Text = "PING: 0ms"
sbPing.TextColor3 = Color3.fromRGB(190, 190, 198)
sbPing.Font = Enum.Font.GothamBold
sbPing.TextSize = INFO_SIZE
sbPing.TextXAlignment = Enum.TextXAlignment.Right
sbPing.ZIndex = 54

local BAR_H = 16
local pt = Instance.new("Frame", pb)
pt.Name = "StealBarTrack"
pt.Size = UDim2.new(1, -18, 0, BAR_H)
pt.Position = UDim2.new(0, 9, 1, -(BAR_H + 6))
pt.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
pt.BackgroundTransparency = 0
pt.BorderSizePixel = 0
pt.ZIndex = 51
pt.ClipsDescendants = true
Instance.new("UICorner", pt).CornerRadius = UDim.new(1, 0)

ProgressBarFill = Instance.new("Frame", pt)
ProgressBarFill.Name = "Fill"
ProgressBarFill.Size = UDim2.fromScale(0, 1)
ProgressBarFill.BackgroundColor3 = ACC
ProgressBarFill.BackgroundTransparency = 0
ProgressBarFill.BorderSizePixel = 0
ProgressBarFill.ZIndex = 52
Instance.new("UICorner", ProgressBarFill).CornerRadius = UDim.new(1, 0)
local fillGrad = Instance.new("UIGradient", ProgressBarFill)
fillGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 150, 150)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 150)),
})

ProgressPercentLabel = pctMiniLbl
ProgressLabel = sbMode

_G._VynxApplyStealBarPos = function()
    local saved = _G._VlPbPos
    if type(saved) ~= "table" or #saved ~= 4 then return end
    pcall(function()
        pb.Position = UDim2.new(saved[1], saved[2], saved[3], saved[4])
    end)
end
_G._VynxApplyStealBarPos()

local function sbRadiusText(value)
    local text = string.format("%.1f", tonumber(value) or 0)
    return (text:gsub("%.0$", ""))
end
local function sbAimbotSpeed()
    local fam = Spd and Spd.family
    if fam == "lagger" then return tonumber(_G._VezyBatAimbotSpeedLagger) or 40
    elseif fam == "custom" then return tonumber(_G._VezyBatAimbotSpeedCustom) or 58 end
    return tonumber(_G._VezyBatAimbotSpeed) or 58
end
local function sbModeText()
    if _G._VezyBatAimbotOn == true then
        return "AIMBOT " .. sbRadiusText(sbAimbotSpeed()) .. " SPEED"
    end
    local mode = (tostring(_G._VynxAutoStealMode or "Normal") == "Semi") and "Semi" or "Normal"
    if mode == "Semi" then
        local radius = tonumber(_G._VynxStealRadiusSemi) or 8.7
        return "SEMI " .. sbRadiusText(radius) .. " RADIUS"
    end
    local radius = tonumber(_G._VynxStealRadiusNormal) or tonumber(Settings.StealRadius) or 62
    return "NORMAL " .. sbRadiusText(radius) .. " RADIUS"
end

local Stats = game:GetService("Stats")
task.spawn(function()
    local lastFrame = tick()
    local fpsSamples, fpsAvg = {}, 60
    RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
        if hubStale() then return end
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
    end))
    while pb.Parent do
        local ping = 0
        local ok = pcall(function()
            local stat = Stats.Network.ServerStatsItem["Data Ping"]
            if stat then ping = tonumber(stat:GetValue()) or 0 end
        end)
        if not ok or ping <= 0 then
            pcall(function() ping = LocalPlayer:GetNetworkPing() * 1000 end)
        end
        sbFps.Text = string.format("FPS: %d", math.floor(fpsAvg + 0.5))
        sbPing.Text = string.format("PING: %dms", math.floor(ping + 0.5))
        sbMode.Text = sbModeText()
        task.wait(0.4)
    end
end)

do
    local dragging, dStart, sPos, activeInp
    pb.InputBegan:Connect(function(input)
        if _G._VynxUILocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dStart = input.Position; sPos = pb.Position; activeInp = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or (input.UserInputType == Enum.UserInputType.Touch and input == activeInp) then
            local d = input.Position - dStart
            pb.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.Touch
            and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        dragging = false; activeInp = nil
        local p = pb.Position
        _G._VlPbPos = {p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset}
        if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
    end)
end

local sbFillTween, sbResetTween
local function ResetProgressBar()
    pctMiniLbl.Text = "0%"
    if sbFillTween then pcall(function() sbFillTween:Cancel() end); sbFillTween = nil end
    if sbResetTween then pcall(function() sbResetTween:Cancel() end) end
    sbResetTween = TweenService:Create(ProgressBarFill,
        TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Size = UDim2.fromScale(0, 1) })
    sbResetTween:Play()
end

_G.StealBar = {
    SetProgress = function(v)
        v = math.clamp(tonumber(v) or 0, 0, 1)
        if sbFillTween then pcall(function() sbFillTween:Cancel() end); sbFillTween = nil end
        ProgressBarFill.Size = UDim2.fromScale(v, 1)
        ProgressBarFill.BackgroundColor3 = _G._VioletteAccent or ACC
        pctMiniLbl.Text = math.floor(v * 100 + 0.5) .. "%"
    end,
    SetState = function() end,
    Reset = function() ResetProgressBar() end,
}


local function hkb(kc)
    if _G._VioletteKeyCaptureActive and _G._VioletteKeyCaptureActive() then return end
    if waitingForKey then return end

    if kc == Enum.KeyCode.Unknown then return end

    do
        local irKeyName = _G._VynxInstaResetKey
        if (Keybinds.InstaReset and Keybinds.InstaReset ~= Enum.KeyCode.Unknown
                and kc == Keybinds.InstaReset)
            or (irKeyName and kc.Name == irKeyName) then
            if _G.VynxDoInstaReset then _G.VynxDoInstaReset() end
            return
        end
    end

    if Keybinds.AntiDie and Keybinds.AntiDie ~= Enum.KeyCode.Unknown
        and kc == Keybinds.AntiDie then
        _G._VynxAntiDie = not (_G._VynxAntiDie == true)
        if VisualSetters.AntiDie then pcall(VisualSetters.AntiDie, _G._VynxAntiDie) end
        if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
        return
    end
    if kc == Keybinds.SpeedToggle then
        Spd.Carry()
    elseif kc == Keybinds.LaggerToggle or kc == Keybinds.LaggerSpeed then
        Spd.Lagger()
    elseif kc == Keybinds.DesyncSpeed then
        Spd.Custom()
    elseif kc == Keybinds.NormalSpeed then
        Spd.Normal()
    end
    if kc == Keybinds.AutoBat then

        if batClk then batClk(not (_G._VezyBatAimbotOn or false)) end
        if _G.KRIXSaveNow then _G.KRIXSaveNow() end
    end
    if kc == Keybinds.InfiniteJump then
        Enabled.InfiniteJump = not Enabled.InfiniteJump
        if VisualSetters.InfiniteJump then VisualSetters.InfiniteJump(Enabled.InfiniteJump) end
        if Enabled.InfiniteJump then startInfiniteJump() else stopInfiniteJump() end
        if _G.KRIXSaveNow then _G.KRIXSaveNow() end
    end
    if kc == Keybinds.DropBrainrot then
        if setDropBrainrotVisual then setDropBrainrotVisual(true) end
        task.spawn(runDropBrainrot)
    end

    if kc == Keybinds.TPDown then if _G._VynxRunTPDown then pcall(_G._VynxRunTPDown) end end

end
UserInputService.InputBegan:Connect(function(i,g)
    if hubStale() then return end
    if g then return end
    if i.UserInputType == Enum.UserInputType.Keyboard then hkb(i.KeyCode)
    elseif _isGamepadInput(i) then hkb(i.KeyCode) end
end)


local dropMobileSetter = function() end


print("v LazerDim loaded")

;(function()
local function applyUIScale(val)
    local prevScale = (UI_SCALE or 1) * DEVICE_UI_SCALE
    UI_SCALE = math.clamp(val, 0.5, 2.0)
    local newScale = UI_SCALE * DEVICE_UI_SCALE

    local function recentre()
        if not outer or prevScale == newScale then return end
        local cam = workspace.CurrentCamera
        local vp  = cam and cam.ViewportSize or Vector2.new(1280, 720)
        local baseW, baseH = outer.Size.X.Offset, outer.Size.Y.Offset
        if baseW <= 0 or baseH <= 0 then return end

        local p  = outer.Position
        local ox = p.X.Offset - baseW * (newScale - prevScale) / 2
        local oy = p.Y.Offset - baseH * (newScale - prevScale) / 2

        local w, h = baseW * newScale, baseH * newScale
        local minX, minY = 8 - p.X.Scale * vp.X, 8 - p.Y.Scale * vp.Y
        ox = math.clamp(ox, minX, math.max(minX, vp.X - w - 8 - p.X.Scale * vp.X))
        oy = math.clamp(oy, minY, math.max(minY, vp.Y - h - 8 - p.Y.Scale * vp.Y))
        outer.Position = UDim2.new(p.X.Scale, ox, p.Y.Scale, oy)
    end

    local function applyToFrame(frame)
        if not frame then return end
        local s = frame:FindFirstChildOfClass("UIScale")
        if not s then s = Instance.new("UIScale"); s.Parent = frame end
        s.Scale = UI_SCALE * DEVICE_UI_SCALE
    end
    local function doApply()
        applyToFrame(outer)
        recentre()
        if not apMain then return end
        if apMain:IsDescendantOf(outer) then
            local s = apMain:FindFirstChildOfClass("UIScale")
            if s then s.Scale = 1 end
        else
            applyToFrame(apMain)
        end
    end
    if outer then doApply()
    else task.spawn(function() repeat task.wait(0.05) until outer and apMain; doApply() end) end
end

_G._VynxApplyUIScale = applyUIScale

if UI_SCALE then pcall(applyUIScale, UI_SCALE) end
local function loadConfig()

    local fname = nil
    if isfile and isfile("VynxHubConfig.json") then
        fname = "VynxHubConfig.json"
    elseif isfile and isfile("Velt7Config.json") then
        fname = "Velt7Config.json"
    end
    if not fname then return end
    local ok,cfg = pcall(function() return HttpService:JSONDecode(readfile(fname)) end)
    if not ok or not cfg then
        warn("[VynxHub] loadConfig failed to decode: " .. tostring(cfg))
        return
    end
    print("[VynxHub] Config loaded from " .. fname)

    NORMAL_SPEED = 59.5
    CARRY_SPEED  = 28.5
    if cfg.laggerSpeed then LAGGER_SPEED = cfg.laggerSpeed end
    if cfg.fovValue then FOV_VALUE = cfg.fovValue end

    if cfg.uiScalePercent and type(cfg.uiScalePercent) == "number" then
        local savedScale = math.clamp(cfg.uiScalePercent / 100, 0.5, 2.0)
        UI_SCALE = savedScale; applyUIScale(savedScale)
    else
        UI_SCALE = 1.0; applyUIScale(1.0)
    end

    if cfg.mobileBtnScale and type(cfg.mobileBtnScale) == "number" then
        _G._VynxMobileBtnScale = math.clamp(cfg.mobileBtnScale, 0.7, 2.0)
        if _G._VynxApplyMobileBtnScale then pcall(_G._VynxApplyMobileBtnScale, _G._VynxMobileBtnScale) end
        if _G._VynxRefreshMobileBtnSizeButtons then pcall(_G._VynxRefreshMobileBtnSizeButtons) end
    end

    if cfg.batAimbotMode and (cfg.batAimbotMode == "old" or cfg.batAimbotMode == "new") then
        _G._VezyBatAimbotMode = cfg.batAimbotMode
        if _G._VynxRefreshAimbotModeBtns then pcall(_G._VynxRefreshAimbotModeBtns) end
    end

    if cfg.customFOVOn ~= nil then
        if VisualSetters.CustomFOV then
            pcall(VisualSetters.CustomFOV, cfg.customFOVOn, true)
        end
        if cfg.customFOVOn then
            if _G.VezyEnableFOV then pcall(_G.VezyEnableFOV) end
        else
            if _G.VezyDisableFOV then pcall(_G.VezyDisableFOV) end
        end
    end
    if cfg.autoBatKey and Enum.KeyCode[cfg.autoBatKey] then Keybinds.AutoBat = Enum.KeyCode[cfg.autoBatKey] end
    if cfg.speedToggleKey and Enum.KeyCode[cfg.speedToggleKey] then Keybinds.SpeedToggle = Enum.KeyCode[cfg.speedToggleKey] end
    if cfg.laggerToggleKey and Enum.KeyCode[cfg.laggerToggleKey] then Keybinds.LaggerToggle = Enum.KeyCode[cfg.laggerToggleKey] end
    if cfg.infiniteJumpKey and Enum.KeyCode[cfg.infiniteJumpKey] then Keybinds.InfiniteJump = Enum.KeyCode[cfg.infiniteJumpKey] end
    if cfg.uiToggle and Enum.KeyCode[cfg.uiToggle] then Keybinds.UIToggle = Enum.KeyCode[cfg.uiToggle] end
    if cfg.grabRadius then

        if cfg.grabRadius == 55 or cfg.grabRadius == 8 then cfg.grabRadius = 62 end
        Settings.StealRadius = cfg.grabRadius; Values.STEAL_RADIUS = cfg.grabRadius
    end
    if cfg.stealDuration then

        if cfg.stealDuration == 1.50 or cfg.stealDuration == 0.19 then cfg.stealDuration = 1.30 end
        Settings.StealDuration = STEAL_DURATION_FIXED; Values.STEAL_DURATION = STEAL_DURATION_FIXED
    end
    if cfg.antiRagdoll ~= nil then Enabled.AntiRagdoll = cfg.antiRagdoll end

    if cfg.autoStealEnabled ~= nil then
        Enabled.AutoSteal = cfg.autoStealEnabled
        Settings.AutoStealEnabled = cfg.autoStealEnabled
    else
        Enabled.AutoSteal = true
        Settings.AutoStealEnabled = true
    end
    if cfg.infiniteJump ~= nil then Enabled.InfiniteJump = cfg.infiniteJump end
    if cfg.optimizer ~= nil then Enabled.Optimizer = cfg.optimizer end
    if cfg.unwalk ~= nil then Enabled.Unwalk = cfg.unwalk end
    if cfg.removeAccessories ~= nil then Enabled.RemoveAccessories = cfg.removeAccessories end
    if cfg.galaxyGravity then Values.GalaxyGravityPercent = cfg.galaxyGravity end
    if cfg.hopPower then Values.HOP_POWER = cfg.hopPower end

    if cfg.dropBrainrotKey and Enum.KeyCode[cfg.dropBrainrotKey] then Keybinds.DropBrainrot = Enum.KeyCode[cfg.dropBrainrotKey] end

    if cfg.tpDownKey and Enum.KeyCode[cfg.tpDownKey] then Keybinds.TPDown = Enum.KeyCode[cfg.tpDownKey] end
    if cfg.laggerSpeedKey and Enum.KeyCode[cfg.laggerSpeedKey] then Keybinds.LaggerSpeed = Enum.KeyCode[cfg.laggerSpeedKey] end
    if cfg.desyncSpeedKey and Enum.KeyCode[cfg.desyncSpeedKey] then Keybinds.DesyncSpeed = Enum.KeyCode[cfg.desyncSpeedKey] end
    if cfg.normalSpeedKey and Enum.KeyCode[cfg.normalSpeedKey] then Keybinds.NormalSpeed = Enum.KeyCode[cfg.normalSpeedKey] end
    if cfg.laggerSpeedNormal then _G.LaggerSpeed_Normal = cfg.laggerSpeedNormal end
    if cfg.laggerSpeedCarry then _G.LaggerSpeed_Carry = cfg.laggerSpeedCarry end
    if cfg.desyncSpeedNormal then _G.DesyncSpeed_Normal = cfg.desyncSpeedNormal end
    if cfg.desyncSpeedCarry then _G.DesyncSpeed_Carry = cfg.desyncSpeedCarry end
    if cfg.normalSpeedPresetNormal then _G.NormalSpeed_Normal = cfg.normalSpeedPresetNormal end
    if cfg.normalSpeedPresetCarry then _G.NormalSpeed_Carry = cfg.normalSpeedPresetCarry end
    if cfg.tpDownOffset then TP_DOWN_OFFSET = cfg.tpDownOffset end
        if cfg.autoTpDown ~= nil then
            _G._VynxAutoTPDownEnabled = cfg.autoTpDown
            if VisualSetters.AutoTPDown then pcall(VisualSetters.AutoTPDown, cfg.autoTpDown) end
        end
        if cfg.autoTpDownY and type(cfg.autoTpDownY) == "number" then
            _G._VynxAutoTPDownHeightTrigger = cfg.autoTpDownY
            if VisualSetters.AutoTPDownY then pcall(VisualSetters.AutoTPDownY, cfg.autoTpDownY) end
        end
    Spd.Refresh()
    task.spawn(function()
        task.wait(0.8)
        if cfg.autoStealEnabled ~= nil then
            Enabled.AutoSteal = cfg.autoStealEnabled; Settings.AutoStealEnabled = cfg.autoStealEnabled
            if _G._KRIXAutoStealSet then _G._KRIXAutoStealSet(cfg.autoStealEnabled) end
            if cfg.autoStealEnabled then startAutoSteal() end
        end
        if cfg.antiRagdoll ~= nil then
            Enabled.AntiRagdoll = cfg.antiRagdoll
            if VisualSetters.AntiRagdoll then VisualSetters.AntiRagdoll(cfg.antiRagdoll) end

            if cfg.antiRagdoll then startAntiRagdoll() end
        end
        if cfg.infiniteJump ~= nil then
            Enabled.InfiniteJump = cfg.infiniteJump
            if VisualSetters.InfiniteJump then VisualSetters.InfiniteJump(cfg.infiniteJump) end

            if cfg.infiniteJump then
                task.spawn(function()

                    for _ = 1, 20 do
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            break
                        end
                        task.wait(0.2)
                    end
                    pcall(startInfiniteJump)
                end)
            end
        end
        if cfg.optimizer ~= nil then
            Enabled.Optimizer = cfg.optimizer
            if VisualSetters.Optimizer then VisualSetters.Optimizer(cfg.optimizer) end
            if cfg.optimizer then enableOptimizer() end
        end
        if cfg.unwalk ~= nil then
            Enabled.Unwalk = cfg.unwalk
            if VisualSetters.Unwalk then VisualSetters.Unwalk(cfg.unwalk) end
            if cfg.unwalk then startUnwalk() end
        end
        if cfg.removeAccessories ~= nil then
            Enabled.RemoveAccessories = cfg.removeAccessories
            if VisualSetters.RemoveAccessories then VisualSetters.RemoveAccessories(cfg.removeAccessories) end
            if cfg.removeAccessories then startRemoveAccessories() end
        end
        if cfg.ultraMode ~= nil then
            ultraModeEnabled = cfg.ultraMode
            if VisualSetters.UltraMode then VisualSetters.UltraMode(cfg.ultraMode) end
            if cfg.ultraMode then enableUltraMode() end
        end
        if cfg.harderHitAnim ~= nil then
            harderHitAnimEnabled = cfg.harderHitAnim
            if VisualSetters.HarderHitAnim then VisualSetters.HarderHitAnim(cfg.harderHitAnim) end
            harderHitAnimEnabled = false
        end
        if cfg.medusaCounter ~= nil then
            medusaCounterEnabled = cfg.medusaCounter
            if VisualSetters.MedusaCounter then VisualSetters.MedusaCounter(cfg.medusaCounter) end
            if cfg.medusaCounter then setupMedusaCounter(LocalPlayer.Character) end
        end
        if cfg.batCounter ~= nil then

            _G._VezyBatCounterOn = cfg.batCounter
            if VisualSetters.BatCounter then VisualSetters.BatCounter(cfg.batCounter, true) end
            if cfg.batCounter then
                if _G.VezyStartBatCounter then pcall(_G.VezyStartBatCounter) end
            else
                if _G.VezyStopBatCounter then pcall(_G.VezyStopBatCounter) end
            end
        end
        if cfg.fastestSteal ~= nil then
            fastestStealEnabled = cfg.fastestSteal
            if VisualSetters.FastestSteal then VisualSetters.FastestSteal(cfg.fastestSteal) end
        end
        if cfg.autoSwing ~= nil then
            autoSwingEnabled = cfg.autoSwing
            _G._VezyAutoSwingEnabled = cfg.autoSwing
            if VisualSetters.AutoSwing then VisualSetters.AutoSwing(cfg.autoSwing) end
        end
        if cfg.noCamCollision ~= nil then
            noCamCollisionEnabled = cfg.noCamCollision
            if VisualSetters.NoCam then VisualSetters.NoCam(cfg.noCamCollision) end
            if cfg.noCamCollision then enableNoCameraCollision() end
        end
        if cfg.tpAutoEnabled ~= nil then
            G_tpAutoEnabled = cfg.tpAutoEnabled
            if VisualSetters.AutoTP then VisualSetters.AutoTP(cfg.tpAutoEnabled) end
            if cfg.tpAutoEnabled then task.spawn(refreshMyPlotSide) end
        end
        if cfg.autoPlayAfterTP ~= nil then
            G_autoPlayAfterTP = cfg.autoPlayAfterTP
            if VisualSetters.APAfterTP then VisualSetters.APAfterTP(cfg.autoPlayAfterTP) end
        end

        if cfg.brainrotReturnLeft ~= nil then
            brainrotReturnLeftEnabled = cfg.brainrotReturnLeft
            if VisualSetters.BrainrotL then VisualSetters.BrainrotL(cfg.brainrotReturnLeft) end
            if _G.V7BRSetters and _G.V7BRSetters.left then _G.V7BRSetters.left(cfg.brainrotReturnLeft) end
        end
        if cfg.brainrotReturnRight ~= nil then
            brainrotReturnRightEnabled = cfg.brainrotReturnRight
            if VisualSetters.BrainrotR then VisualSetters.BrainrotR(cfg.brainrotReturnRight) end
            if _G.V7BRSetters and _G.V7BRSetters.right then _G.V7BRSetters.right(cfg.brainrotReturnRight) end
        end
        if cfg.tpMode and (cfg.tpMode=="Manuel" or cfg.tpMode=="Semi" or cfg.tpMode=="Medusa") then tpMode = cfg.tpMode end
        if cfg.stretchRez ~= nil then
            stretchRezEnabled = cfg.stretchRez
            if VisualSetters.StretchRez then VisualSetters.StretchRez(cfg.stretchRez) end
            if cfg.stretchRez then if _G._VynxEnableStretchRez then _G._VynxEnableStretchRez() end end
        end
        if cfg.desyncEnabled ~= nil then
            desyncEnabled = cfg.desyncEnabled
            if VisualSetters.Desync then VisualSetters.Desync(cfg.desyncEnabled) end
            if _G._VynxApplyDesync then _G._VynxApplyDesync(cfg.desyncEnabled) end
        end
        if cfg.autoBatEnabled ~= nil then
            autoBatToggled = cfg.autoBatEnabled
            if VisualSetters.AutoBat then VisualSetters.AutoBat(cfg.autoBatEnabled) end
        end

        if cfg.instaResetKey then _G._VynxInstaResetKey = cfg.instaResetKey end

        if cfg.jumpMode then _G._VezyJumpMode = cfg.jumpMode end
        if cfg.dropType then _G._VynxDropType = cfg.dropType; if _G._VynxRefreshDropType then pcall(_G._VynxRefreshDropType) end end
        _G._VezyCustomFontOn = false

        if cfg.stretchFOV then _G._VezyStretchFOV = cfg.stretchFOV end

        if cfg.hitDist and type(cfg.hitDist) == "number" then
            _G._VezyHitDist = cfg.hitDist
        end
        if cfg.batAimbotOn ~= nil then
            _G._VezyBatAimbotOn = cfg.batAimbotOn

            if cfg.batAimbotOn then
                task.delay(0.5, function()
                    if _G.VezyStartBatAimbotDispatch then
                        pcall(_G.VezyStartBatAimbotDispatch)
                    elseif _G.VezyStartBatAimbot then
                        pcall(_G.VezyStartBatAimbot)
                    end
                end)
            end
        end
        if cfg.aimbotSpeed and type(cfg.aimbotSpeed) == "number" then
            _G._VezyBatAimbotSpeed = cfg.aimbotSpeed

            if _G._VezyAimbotSpeedInputRef then
                pcall(function() _G._VezyAimbotSpeedInputRef.Text = tostring(cfg.aimbotSpeed) end)
            end
        end

        if cfg.btnOpacity and type(cfg.btnOpacity) == "number" then
            _G._VezyBtnOpacity = cfg.btnOpacity
        end
        if cfg.bgOpacity and type(cfg.bgOpacity) == "number" then
            _G._VezyBgOpacity = cfg.bgOpacity
            if _G._VezyBgImageRef then
                _G._VezyBgImageRef.ImageTransparency = 1 - cfg.bgOpacity
            end
        end

        if cfg.bgImageId and type(cfg.bgImageId) == "string" then
            _G._VezyBgImageId = cfg.bgImageId
            task.delay(0.3, function()
                if _G.VezySetBgImage then pcall(_G.VezySetBgImage, cfg.bgImageId) end

                if _G.VezySyncBgPicker then pcall(_G.VezySyncBgPicker) end

            end)
        end

        if cfg.uiLocked ~= nil then
            _G._VynxUILocked = cfg.uiLocked
            task.delay(0.5, function()
                if VisualSetters.LockUI then pcall(VisualSetters.LockUI, cfg.uiLocked) end
            end)
        end
        if cfg.hideSideBtns ~= nil then
            _G._VezyHideSideBtns = cfg.hideSideBtns
            task.delay(0.5, function()

                local gui = _G._VezyMobileButtonsFrame and _G._VezyMobileButtonsFrame.Parent
                if gui then
                    for _, child in ipairs(gui:GetChildren()) do
                        if child:IsA("TextButton") and child.Name:sub(1, 3) == "MB_" then
                            child.Visible = not cfg.hideSideBtns
                        end
                    end
                end
                if _G._VezyMobileButtonsFrame then
                    _G._VezyMobileButtonsFrame.Visible = not cfg.hideSideBtns
                end
                if VisualSetters.HideSideBtns then pcall(VisualSetters.HideSideBtns, cfg.hideSideBtns) end
            end)
        end

        if cfg.customSky and type(cfg.customSky) == "string" then
            _G._VezyCustomSkyMode = cfg.customSky
            task.delay(0.5, function()
                if _G.VezyApplyCustomSky then pcall(_G.VezyApplyCustomSky, cfg.customSky) end
            end)
        end

        if cfg.controllerBinds and type(cfg.controllerBinds) == "table" then
            _G._VynxControllerBinds = _G._VynxControllerBinds or {}
            for k, name in pairs(cfg.controllerBinds) do
                if type(name) == "string" and Enum.KeyCode[name] then
                    _G._VynxControllerBinds[k] = Enum.KeyCode[name]
                end
            end
        end

        if cfg.mobileBtnPos and type(cfg.mobileBtnPos) == "table"
            and cfg.mobileBtnLayout == _G._VynxMobileLayoutVersion then
            _G._VezyMobileBtnPos = cfg.mobileBtnPos

            task.delay(0.3, function()
                local gui = _G._VezyMobileButtonsFrame and _G._VezyMobileButtonsFrame.Parent
                if gui then
                    for key, pos in pairs(cfg.mobileBtnPos) do
                        local btn = gui:FindFirstChild("MB_" .. key)
                        if btn and pos.xs then
                            btn.Position = UDim2.new(pos.xs, pos.xo, pos.ys, pos.yo)
                        end
                    end
                end
            end)
        end

        task.delay(0.5, function()
            if _G.VezySetBtnOpacity and _G._VezyBtnOpacity then
                pcall(_G.VezySetBtnOpacity, _G._VezyBtnOpacity)
            end
        end)

        if _G._VynxRefreshDuelLaggerKey then pcall(_G._VynxRefreshDuelLaggerKey) end
        if _G._VynxRefreshInstaResetKey then pcall(_G._VynxRefreshInstaResetKey) end
        if RadiusInput then RadiusInput.Text = tostring(Settings.StealRadius) end
        if DurationInput then DurationInput.Text = string.format("%.2f", Settings.StealDuration) end
        if nsb then nsb.Text = tostring(NORMAL_SPEED) end
        if csb then csb.Text = tostring(CARRY_SPEED) end
        if lsb then lsb.Text = tostring(LAGGER_SPEED) end

        local function _fmtV(v)
            return (v == math.floor(v)) and tostring(math.floor(v)) or string.format("%.1f", v)
        end
        if lagNormalInput then lagNormalInput.Text = _fmtV(_G.LaggerSpeed_Normal) end
        if lagCarryInput  then lagCarryInput.Text  = _fmtV(_G.LaggerSpeed_Carry)  end
        if dsyNormalInput then dsyNormalInput.Text = _fmtV(_G.DesyncSpeed_Normal) end
        if dsyCarryInput  then dsyCarryInput.Text  = _fmtV(_G.DesyncSpeed_Carry)  end
        if normNormalInput then normNormalInput.Text = _fmtV(_G.NormalSpeed_Normal) end
        if normCarryInput  then normCarryInput.Text  = _fmtV(_G.NormalSpeed_Carry)  end
        for kName, lbl in pairs(KB) do
            if Keybinds[kName] and lbl and lbl.Parent then lbl.Text = _G._VioletteKeyName(Keybinds[kName]) end
        end

    end)
end
loadConfig()

task.spawn(function()
    for _, t in ipairs({0.3, 0.8, 1.5, 3, 5}) do
        task.wait(t)
        pcall(function()
            for kName, lbl in pairs(KB) do
                if Keybinds[kName] and lbl and lbl.Parent then
                    lbl.Text = _G._VioletteKeyName(Keybinds[kName])
                end
            end
            if _G._VynxRefreshDuelLaggerKey then pcall(_G._VynxRefreshDuelLaggerKey) end
            if _G._VynxRefreshInstaResetKey then pcall(_G._VynxRefreshInstaResetKey) end
        end)
    end
end)

task.spawn(function()
    for _, t in ipairs({0.3, 0.8, 1.5, 3, 5}) do
        task.wait(t)
        if _G.VezySetBtnOpacity then
            pcall(_G.VezySetBtnOpacity, _G._VezyBtnOpacity or 0.5)
        end
        if _G.VezySetBgOpacity then
            pcall(_G.VezySetBgOpacity, _G._VezyBgOpacity or 1)
        end

        if _G._VezyBgImageId and _G._VezyBgImageId ~= "" and _G.VezySetBgImage then
            pcall(_G.VezySetBgImage, _G._VezyBgImageId)
        end
    end
end)

end)()

end)()

;(function()
local TweenService=game:GetService("TweenService"); local HttpService=game:GetService("HttpService")

local AP_C_CARD=Color3.fromRGB(18,18,18); local AP_C_ACC=Color3.fromRGB(254, 254, 254); local AP_C_DIM=Color3.fromRGB(150, 150, 155); local AP_C_SW_OFF=Color3.fromRGB(40,40,40); local AP_C_WHITE=Color3.fromRGB(255,255,255)

local SAVE_FILE="AutoPlayConfig.json"
local function apSaveConfig()
    pcall(function()
        if not writefile then return end
        writefile(SAVE_FILE, HttpService:JSONEncode({ mode = _G._AdaptAutoPlayMode }))
    end)
end
pcall(function()
    if not (isfile and isfile(SAVE_FILE)) then return end
    local ok, cfg = pcall(function() return HttpService:JSONDecode(readfile(SAVE_FILE)) end)
    if not ok or not cfg then return end
    if cfg.mode == "Normal" or cfg.mode == "Auto Play" then _G._AdaptAutoPlayMode = cfg.mode end
end)

local autoPlayPage=_G._V7AutoPlayPage
local _apFrame=Instance.new("Frame",autoPlayPage)
_apFrame.Size=UDim2.new(1,0,0,0); _apFrame.AutomaticSize=Enum.AutomaticSize.Y
_apFrame.BackgroundTransparency=1; _apFrame.BorderSizePixel=0; _apFrame.LayoutOrder=1
local apVstack=_apFrame
local apLayout=Instance.new("UIListLayout",apVstack)
apLayout.SortOrder=Enum.SortOrder.LayoutOrder; apLayout.Padding=UDim.new(0,4)
local _apPad=Instance.new("UIPadding",apVstack)
_apPad.PaddingLeft=UDim.new(0,2); _apPad.PaddingRight=UDim.new(0,2); _apPad.PaddingTop=UDim.new(0,4)
apMain=autoPlayPage
local apOrder=0; local function APO() apOrder=apOrder+1; return apOrder end

_G._AdaptAutoPlayMode = (_G._AdaptAutoPlayMode == "Auto Play") and "Auto Play" or "Normal"
do
    local mRow = Instance.new("Frame", apVstack)
    mRow.Size = UDim2.new(1, 0, 0, 42)
    mRow.BackgroundColor3 = AP_C_CARD
    mRow.BorderSizePixel = 0
    mRow.LayoutOrder = APO()
    mRow.ZIndex = 3
    Instance.new("UICorner", mRow).CornerRadius = UDim.new(0, 10)
    local mSt = Instance.new("UIStroke", mRow)
    mSt.Color = AP_C_ACC; mSt.Thickness = 1; mSt.Transparency = 0.8
    mSt.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local mLbl = Instance.new("TextLabel", mRow)
    mLbl.Size = UDim2.new(0.5, 0, 0, 18)
    mLbl.Position = UDim2.new(0, 12, 0.5, -9)
    mLbl.BackgroundTransparency = 1
    mLbl.Text = "Auto Play Mode"
    mLbl.TextColor3 = AP_C_WHITE
    mLbl.Font = Enum.Font.GothamBold
    mLbl.TextSize = 13
    mLbl.TextXAlignment = Enum.TextXAlignment.Left
    mLbl.ZIndex = 4

    local apModeBtns = {}
    local ABW, ABH, AGAP = 66, 24, 6
    local aTotal = 2 * ABW + AGAP
    local function refreshApMode()
        for k, b in pairs(apModeBtns) do
            local on = (k == _G._AdaptAutoPlayMode)
            b.BackgroundColor3 = on and (_G._VioletteAccent or AP_C_ACC) or Color3.fromRGB(30, 30, 30)
            b.TextColor3 = on and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(165, 165, 170)
        end
    end
    for i, v in ipairs({"Normal", "Auto Play"}) do
        local b = Instance.new("TextButton", mRow)
        b.Size = UDim2.new(0, ABW, 0, ABH)
        b.Position = UDim2.new(1, -(aTotal + 12) + (i - 1) * (ABW + AGAP), 0.5, -ABH/2)
        b.BackgroundColor3 = AP_C_SW_OFF
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.Text = v
        b.TextColor3 = AP_C_DIM
        b.Font = Enum.Font.GothamBold
        b.TextSize = 11
        b.ZIndex = 5
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        apModeBtns[v] = b
        b.MouseButton1Click:Connect(function()
            _G._AdaptAutoPlayMode = v
            _G._KawatanPathMode = (v == "Auto Play") and "AUTO PLAY" or "NORMAL"
            if _G._VynxOnPathModeChanged then pcall(_G._VynxOnPathModeChanged) end
            refreshApMode()
            apSaveConfig()
            if _G.KRIXSaveNow then _G.KRIXSaveNow() end
        end)
    end
    _G._AdaptRefreshAutoPlayMode = refreshApMode
    refreshApMode()
end

end)()

;(function()

local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local SETTINGS_FILE = "KrixDesync_settings.json"

local desyncActive = false
local function setDesync(state) desyncActive = state and true or false end
local waitingForKey = false
local toggleKey = Enum.KeyCode.Y

local unwalkActive = false
local unwalkConn = nil

local winPos = UDim2.new(0, 20, 1, -195)

local function saveSettings()
    local ok = pcall(function()
        local cfg = {
            hotkey = toggleKey.Name,
            winX = winPos.X.Offset,
            winY = winPos.Y.Offset,
            winXS = winPos.X.Scale,
            winYS = winPos.Y.Scale,
        }

        local parts = {}
        for k, v in pairs(cfg) do
            local vStr = (type(v) == "string") and ('"' .. v .. '"') or tostring(v)
            table.insert(parts, '"' .. k .. '":' .. vStr)
        end
        writefile(SETTINGS_FILE, "{" .. table.concat(parts, ",") .. "}")
    end)
end

local function loadSettings()
    pcall(function()
        local ok, data = pcall(readfile, SETTINGS_FILE)
        if not ok or not data or data == "" then return end
        local function toVal(s)
            s = s:match("^%s*(.-)%s*$")
            if s:sub(1, 1) == '"' then return s:sub(2, -2) end
            return tonumber(s)
        end
        for k, v in data:gmatch('"([^"]+)"%s*:%s*("?[^",}]+"?)') do
            local val = toVal(v)
            if k == "hotkey" and type(val) == "string" then
                local kc = Enum.KeyCode[val]
                if kc then toggleKey = kc end
            elseif k == "winX" then winPos = UDim2.new(winPos.X.Scale, val, winPos.Y.Scale, winPos.Y.Offset)
            elseif k == "winY" then winPos = UDim2.new(winPos.X.Scale, winPos.X.Offset, winPos.Y.Scale, val)
            elseif k == "winXS" then winPos = UDim2.new(val, winPos.X.Offset, winPos.Y.Scale, winPos.Y.Offset)
            elseif k == "winYS" then winPos = UDim2.new(winPos.X.Scale, winPos.X.Offset, val, winPos.Y.Offset)
            end
        end
    end)
end
loadSettings()

local function startUnwalkLoop() end

local function setUnwalk(state, btn)
    if state then
        unwalkActive = true
        startUnwalkLoop()
        if btn then
            tween(btn, 0.25, {
                BackgroundColor3 = Color3.fromRGB(235, 235, 235),
                TextColor3 = Color3.fromRGB(0, 0, 0)
            })
            btn.Text = "UNWALK: ON"
        end
    else
        unwalkActive = false
        if unwalkConn then
            unwalkConn:Disconnect()
            unwalkConn = nil
        end
        if btn then
            tween(btn, 0.25, {
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                TextColor3 = Color3.fromRGB(240, 240, 240)
            })
            btn.Text = "UNWALK: OFF"
        end
    end
end

local updateVisual

local function buildUI()
    local old = CoreGui:FindFirstChild("KrixDesyncUI")
    if old then old:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KrixDesyncUI"
    ScreenGui.IgnoreGuiInset = true
    if _G._VioletteMountOnTop then
        _G._VioletteMountOnTop(ScreenGui, 1000002)
    else
        ScreenGui.ResetOnSpawn = false
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui.Parent = CoreGui
    end

    local PANEL_W, PANEL_H = 230, 200

    local C_BG       = Color3.fromRGB(10, 10, 10)
    local C_BG2      = Color3.fromRGB(22, 22, 22)
    local C_HOVER    = Color3.fromRGB(30, 30, 30)
    local C_PURPLE   = Color3.fromRGB(220, 220, 220)
    local C_PUR_DARK = Color3.fromRGB(100, 100, 100)
    local C_PUR_DEEP = Color3.fromRGB(35, 35, 35)
    local C_WHITE    = Color3.fromRGB(245, 245, 245)
    local C_DIM      = Color3.fromRGB(150, 150, 150)
    local C_DIM2     = Color3.fromRGB(110, 110, 110)
    local C_STROKE   = Color3.fromRGB(45, 45, 45)

    local Panel = Instance.new("Frame", ScreenGui)
    Panel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
    Panel.Position = winPos
    Panel.BackgroundColor3 = C_BG
    Panel.BorderSizePixel = 0
    Panel.Active = true
    Panel.ClipsDescendants = false
    Panel.Visible = false
    Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 12)

    local bgGrad = Instance.new("UIGradient", Panel)
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 18)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 8)),
    })
    bgGrad.Rotation = 135

    local PanelStroke = Instance.new("UIStroke", Panel)
    PanelStroke.Thickness = 1.2
    PanelStroke.Transparency = 0.15
    PanelStroke.Color = C_PURPLE
    PanelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local strokeGrad = Instance.new("UIGradient", PanelStroke)
    strokeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    C_PUR_DEEP),
        ColorSequenceKeypoint.new(0.3,  C_PUR_DARK),
        ColorSequenceKeypoint.new(0.5,  C_PURPLE),
        ColorSequenceKeypoint.new(0.7,  C_PUR_DARK),
        ColorSequenceKeypoint.new(1,    C_PUR_DEEP),
    })

    local Glow = Instance.new("ImageLabel", Panel)
    Glow.Size = UDim2.new(1, 24, 1, 24)
    Glow.Position = UDim2.new(0, -12, 0, -12)
    Glow.BackgroundTransparency = 1
    Glow.Image = "rbxassetid://5028857084"
    Glow.ImageColor3 = C_PURPLE
    Glow.ImageTransparency = 0.85
    Glow.ScaleType = Enum.ScaleType.Slice
    Glow.SliceCenter = Rect.new(24, 24, 276, 276)
    Glow.ZIndex = 0

    Glow.ImageTransparency = 0.85
    Glow.ImageColor3 = C_PURPLE

    local Header = Instance.new("Frame", Panel)
    Header.Size = UDim2.new(1, 0, 0, 36)
    Header.BackgroundTransparency = 1

    local DragBtn = Instance.new("TextButton", Header)
    DragBtn.Size = UDim2.new(1, 0, 1, 0)
    DragBtn.BackgroundTransparency = 1
    DragBtn.Text = ""
    DragBtn.AutoButtonColor = false
    DragBtn.ZIndex = 2

    local LogoDot = Instance.new("ImageLabel", Header)
    LogoDot.Size = UDim2.new(0, 18, 0, 18)
    LogoDot.Position = UDim2.new(0, 8, 0.5, -9)
    LogoDot.BackgroundTransparency = 1
    LogoDot.Image = "rbxassetid://139397937948846"
    LogoDot.ScaleType = Enum.ScaleType.Fit
    LogoDot.ZIndex = 3

    local logoGlow = Instance.new("UIStroke", LogoDot)
    logoGlow.Color = C_PURPLE
    logoGlow.Thickness = 0
    logoGlow.Transparency = 1

    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(1, -70, 1, 0)
    Title.Position = UDim2.new(0, 30, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "DESYNC"
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 13
    Title.TextColor3 = C_WHITE
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 3
    local titleGrad = Instance.new("UIGradient", Title)
    titleGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   C_PURPLE),
        ColorSequenceKeypoint.new(0.5, C_WHITE),
        ColorSequenceKeypoint.new(1,   C_PURPLE),
    })
    local CloseBtn = Instance.new("TextButton", Header)
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.Position = UDim2.new(1, -28, 0.5, -10)
    CloseBtn.BackgroundColor3 = C_BG2
    CloseBtn.Text = "—"
    CloseBtn.TextColor3 = C_DIM
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 12
    CloseBtn.AutoButtonColor = false
    CloseBtn.BorderSizePixel = 0
    CloseBtn.ZIndex = 3
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)

    local dragging, dragStart, startPos = false, nil, nil
    DragBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = Panel.Position
        end
    end)
    DragBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then dragging = false; saveSettings() end
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            winPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            Panel.Position = winPos
        end
    end)

    local StatusPill = Instance.new("Frame", Panel)
    StatusPill.Size = UDim2.new(1, -24, 0, 30)
    StatusPill.Position = UDim2.new(0, 12, 0, 44)
    StatusPill.BackgroundColor3 = C_BG2
    StatusPill.BorderSizePixel = 0
    Instance.new("UICorner", StatusPill).CornerRadius = UDim.new(0, 8)
    local pillStroke = Instance.new("UIStroke", StatusPill)
    pillStroke.Color = C_STROKE
    pillStroke.Thickness = 1
    pillStroke.Transparency = 0.55

    local StatusDot = Instance.new("Frame", StatusPill)
    StatusDot.Size = UDim2.new(0, 6, 0, 6)
    StatusDot.Position = UDim2.new(0, 12, 0.5, -3)
    StatusDot.BackgroundColor3 = C_DIM2
    StatusDot.BorderSizePixel = 0
    Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(1, 0)

    local StatusLabel = Instance.new("TextLabel", StatusPill)
    StatusLabel.Size = UDim2.new(0.6, -22, 1, 0)
    StatusLabel.Position = UDim2.new(0, 24, 0, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Inactive"
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.TextSize = 11
    StatusLabel.TextColor3 = C_DIM
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

    local HotkeyDisplay = Instance.new("TextLabel", StatusPill)
    HotkeyDisplay.Size = UDim2.new(0.4, -10, 1, 0)
    HotkeyDisplay.Position = UDim2.new(0.6, 0, 0, 0)
    HotkeyDisplay.BackgroundTransparency = 1
    HotkeyDisplay.Text = "[" .. toggleKey.Name .. "]"
    HotkeyDisplay.Font = Enum.Font.GothamBold
    HotkeyDisplay.TextSize = 10
    HotkeyDisplay.TextColor3 = C_PURPLE
    HotkeyDisplay.TextXAlignment = Enum.TextXAlignment.Right

    local ActivateBtn = Instance.new("TextButton", Panel)
    ActivateBtn.Size = UDim2.new(1, -24, 0, 34)
    ActivateBtn.Position = UDim2.new(0, 12, 0, 82)
    ActivateBtn.BackgroundColor3 = C_BG2
    ActivateBtn.Text = "ACTIVATE"
    ActivateBtn.Font = Enum.Font.GothamBlack
    ActivateBtn.TextSize = 12
    ActivateBtn.TextColor3 = C_WHITE
    ActivateBtn.AutoButtonColor = false
    ActivateBtn.BorderSizePixel = 0
    Instance.new("UICorner", ActivateBtn).CornerRadius = UDim.new(0, 8)
    local actStroke = Instance.new("UIStroke", ActivateBtn)
    actStroke.Color = C_PUR_DARK
    actStroke.Thickness = 1.2
    actStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    actStroke.Transparency = 0.4

    local UnwalkBtn = Instance.new("TextButton", Panel)
    UnwalkBtn.Size = UDim2.new(1, -24, 0, 28)
    UnwalkBtn.Position = UDim2.new(0, 12, 0, 124)
    UnwalkBtn.BackgroundColor3 = C_BG2
    UnwalkBtn.Text = "UNWALK    OFF"
    UnwalkBtn.Font = Enum.Font.GothamBold
    UnwalkBtn.TextSize = 10
    UnwalkBtn.TextColor3 = C_DIM
    UnwalkBtn.AutoButtonColor = false
    UnwalkBtn.BorderSizePixel = 0
    Instance.new("UICorner", UnwalkBtn).CornerRadius = UDim.new(0, 6)
    local uwStroke = Instance.new("UIStroke", UnwalkBtn)
    uwStroke.Color = C_STROKE
    uwStroke.Thickness = 1
    uwStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    uwStroke.Transparency = 0.55

    local KeyRow = Instance.new("Frame", Panel)
    KeyRow.Size = UDim2.new(1, -24, 0, 24)
    KeyRow.Position = UDim2.new(0, 12, 0, 160)
    KeyRow.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    KeyRow.BorderSizePixel = 0
    Instance.new("UICorner", KeyRow).CornerRadius = UDim.new(0, 6)
    local keyStrokeRow = Instance.new("UIStroke", KeyRow)
    keyStrokeRow.Color = C_STROKE
    keyStrokeRow.Thickness = 1
    keyStrokeRow.Transparency = 0.6

    local KeyLbl = Instance.new("TextLabel", KeyRow)
    KeyLbl.Size = UDim2.new(0.6, 0, 1, 0)
    KeyLbl.Position = UDim2.new(0, 10, 0, 0)
    KeyLbl.BackgroundTransparency = 1
    KeyLbl.Text = "Hotkey"
    KeyLbl.Font = Enum.Font.Gotham
    KeyLbl.TextSize = 9
    KeyLbl.TextColor3 = C_DIM2
    KeyLbl.TextXAlignment = Enum.TextXAlignment.Left

    local KeyBtn = Instance.new("TextButton", KeyRow)
    KeyBtn.Size = UDim2.new(0, 50, 0, 18)
    KeyBtn.Position = UDim2.new(1, -56, 0.5, -9)
    KeyBtn.BackgroundColor3 = C_BG2
    KeyBtn.Text = toggleKey.Name
    KeyBtn.Font = Enum.Font.GothamBold
    KeyBtn.TextSize = 9
    KeyBtn.TextColor3 = C_PURPLE
    KeyBtn.AutoButtonColor = false
    KeyBtn.BorderSizePixel = 0
    Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 4)
    local keyStroke = Instance.new("UIStroke", KeyBtn)
    keyStroke.Color = C_PUR_DARK
    keyStroke.Thickness = 1
    keyStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    keyStroke.Transparency = 0.4

    KeyBtn.MouseButton1Click:Connect(function()
        waitingForKey = true
        KeyBtn.Text = "..."
        tween(keyStroke, 0.2, { Color = C_WHITE, Transparency = 0.1, Thickness = 1.5 })
    end)

    updateVisual = function()
        if desyncActive then
            tween(StatusDot, 0.25, { BackgroundColor3 = C_PURPLE })
            tween(StatusLabel, 0.25, { TextColor3 = C_WHITE })
            StatusLabel.Text = "Active"
            tween(ActivateBtn, 0.25, {
                BackgroundColor3 = C_PUR_DARK,
                TextColor3 = C_WHITE,
            })
            tween(actStroke, 0.25, { Color = C_PURPLE, Transparency = 0.15 })
            tween(pillStroke, 0.25, { Color = C_PURPLE, Transparency = 0.4 })
            ActivateBtn.Text = "DEACTIVATE"
            tween(logoGlow, 0.25, { Transparency = 0.3 })
        else
            tween(StatusDot, 0.25, { BackgroundColor3 = C_DIM2 })
            tween(StatusLabel, 0.25, { TextColor3 = C_DIM })
            StatusLabel.Text = "Inactive"
            tween(ActivateBtn, 0.25, {
                BackgroundColor3 = C_BG2,
                TextColor3 = C_WHITE,
            })
            tween(actStroke, 0.25, { Color = C_PUR_DARK, Transparency = 0.4 })
            tween(pillStroke, 0.25, { Color = C_STROKE, Transparency = 0.55 })
            ActivateBtn.Text = "ACTIVATE"
            tween(logoGlow, 0.25, { Transparency = 0.55 })
        end
    end

    ActivateBtn.MouseButton1Click:Connect(function()
        setDesync(not desyncActive)
        if updateVisual then updateVisual() end
    end)

    UnwalkBtn.MouseButton1Click:Connect(function()
        local newState = not unwalkActive
        setUnwalk(newState, nil)
        if newState then
            tween(UnwalkBtn, 0.25, {
                BackgroundColor3 = C_PUR_DARK,
                TextColor3 = C_WHITE,
            })
            tween(uwStroke, 0.25, { Color = C_PURPLE, Transparency = 0.25 })
            UnwalkBtn.Text = "UNWALK    ON"
        else
            tween(UnwalkBtn, 0.25, {
                BackgroundColor3 = C_BG2,
                TextColor3 = C_DIM,
            })
            tween(uwStroke, 0.25, { Color = C_STROKE, Transparency = 0.55 })
            UnwalkBtn.Text = "UNWALK    OFF"
        end
    end)

    ActivateBtn.MouseEnter:Connect(function()
        if not desyncActive then
            tween(ActivateBtn, 0.15, { BackgroundColor3 = C_HOVER })
        end
    end)
    ActivateBtn.MouseLeave:Connect(function()
        if not desyncActive then
            tween(ActivateBtn, 0.15, { BackgroundColor3 = C_BG2 })
        end
    end)
    UnwalkBtn.MouseEnter:Connect(function()
        if not unwalkActive then
            tween(UnwalkBtn, 0.15, { BackgroundColor3 = C_HOVER })
        end
    end)
    UnwalkBtn.MouseLeave:Connect(function()
        if not unwalkActive then
            tween(UnwalkBtn, 0.15, { BackgroundColor3 = C_BG2 })
        end
    end)
    CloseBtn.MouseEnter:Connect(function()
        tween(CloseBtn, 0.15, { BackgroundColor3 = C_HOVER })
    end)
    CloseBtn.MouseLeave:Connect(function()
        tween(CloseBtn, 0.15, { BackgroundColor3 = C_BG2 })
    end)
    KeyBtn.MouseEnter:Connect(function()
        tween(KeyBtn, 0.15, { BackgroundColor3 = C_HOVER })
    end)
    KeyBtn.MouseLeave:Connect(function()
        tween(KeyBtn, 0.15, { BackgroundColor3 = C_BG2 })
    end)

    Panel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
    Panel.Position = winPos
    Panel.Visible = false

    return ScreenGui, Panel, KeyBtn, keyStroke, UnwalkBtn, PANEL_W, PANEL_H
end

local ScreenGui, Panel, KeyBtn, keyStroke, UnwalkBtn, PANEL_W, PANEL_H = buildUI()

UIS.InputBegan:Connect(function(input, gpe)
    if hubStale() then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard
       and true
       and not _isGamepadInput(input) then return end

    if waitingForKey then
        if gpe then return end
        toggleKey = input.KeyCode
        if KeyBtn then KeyBtn.Text = "[ " .. toggleKey.Name .. " ]" end
        if keyStroke then tween(keyStroke, 0.2, {Color = Color3.fromRGB(60, 60, 60), Thickness = 1}) end
        waitingForKey = false
        saveSettings()
        return
    end

    if gpe then return end
    if _G._VioletteKeyCaptureActive and _G._VioletteKeyCaptureActive() then return end
    if input.KeyCode == toggleKey then
        setDesync(not desyncActive)
        if updateVisual then updateVisual() end
    end
end)

_G.KrixDesyncToggle = function(on)
    setDesync(on and true or false)
    if updateVisual then updateVisual() end
end


_G.KrixDesyncShowPanel = function()
    Panel.Visible = true
    Panel.Size = UDim2.new(0, PANEL_W, 0, 0)
    Panel.Position = UDim2.new(winPos.X.Scale, winPos.X.Offset, winPos.Y.Scale, winPos.Y.Offset + (PANEL_H / 2))
    TS:Create(Panel, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, PANEL_W, 0, PANEL_H),
        Position = winPos
    }):Play()
end

_G.KrixDesyncHidePanel = function()
    TS:Create(Panel, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
        Size = UDim2.new(0, PANEL_W, 0, 0)
    }):Play()
    task.delay(0.27, function() Panel.Visible = false end)
end

_G.KrixDesyncTogglePanel = function()
    if Panel.Visible then
        _G.KrixDesyncHidePanel()
    else
        _G.KrixDesyncShowPanel()
    end
end

print("[LazerDim DESYNC] loaded - press " .. toggleKey.Name .. " to toggle")
end)()

local function playVioletteLoadIntro(onFinished)
    if _G._VioletteLoadIntroCleanup then pcall(_G._VioletteLoadIntroCleanup) end

    if _G._ViolettePlayIntroSong then
        pcall(_G._ViolettePlayIntroSong, _G._VioletteIntroSong or "Song 1", false)
    end

    local introIsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local oldIntro = playerGui:FindFirstChild("VioletteLoadIntro")
    if oldIntro then oldIntro:Destroy() end
    local oldBlur = Lighting:FindFirstChild("VioletteLoadIntroBlur")
    if oldBlur then oldBlur:Destroy() end

    local introGui = Instance.new("ScreenGui")
    introGui.Name = "VioletteLoadIntro"
    if _G._VioletteMountOnTop then
        _G._VioletteMountOnTop(introGui, 1000005)
    else
        introGui.ResetOnSpawn = false
        introGui.DisplayOrder = 1000005
        introGui.Parent = playerGui
    end
    introGui.IgnoreGuiInset = true

    local ACCENT = Color3.fromRGB(255, 255, 255)
    local DIM    = Color3.fromRGB(160, 160, 168)
    local PINK   = Color3.fromRGB(200, 80, 255)

    local intro = Instance.new("Frame")
    intro.BackgroundColor3 = Color3.fromRGB(4, 4, 6)
    intro.BackgroundTransparency = 1
    intro.BorderSizePixel = 0
    intro.Size = UDim2.fromScale(1, 1)
    intro.ZIndex = 1000
    intro.Parent = introGui

    -- soft radial glow behind title
    local glow = Instance.new("Frame")
    glow.Name = "CenterGlow"
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.Position = UDim2.fromScale(0.5, 0.42)
    glow.Size = introIsMobile and UDim2.fromOffset(280, 280) or UDim2.fromOffset(420, 420)
    glow.BackgroundColor3 = Color3.fromRGB(40, 10, 55)
    glow.BackgroundTransparency = 1
    glow.BorderSizePixel = 0
    glow.ZIndex = 1001
    glow.Parent = intro
    Instance.new("UICorner", glow).CornerRadius = UDim.new(1, 0)
    local glowGrad = Instance.new("UIGradient", glow)
    glowGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.35),
        NumberSequenceKeypoint.new(0.55, 0.85),
        NumberSequenceKeypoint.new(1, 1),
    })

    -- ambient floating particles
    local particleField = Instance.new("Frame")
    particleField.BackgroundTransparency = 1
    particleField.Size = UDim2.fromScale(1, 1)
    particleField.ClipsDescendants = true
    particleField.ZIndex = 1001
    particleField.Parent = intro
    local particles = {}
    for i = 1, introIsMobile and 28 or 48 do
        local p = Instance.new("Frame")
        p.BackgroundColor3 = (i % 5 == 0) and PINK or Color3.fromRGB(230, 230, 240)
        p.BackgroundTransparency = 1
        p.BorderSizePixel = 0
        p.AnchorPoint = Vector2.new(0.5, 0.5)
        local sz = (i % 6 == 0) and 3 or 2
        p.Size = UDim2.fromOffset(sz, sz)
        p.ZIndex = 1001
        p.Parent = particleField
        Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
        particles[i] = {
            frame = p,
            x = ((i * 41) % 100) / 100,
            y = ((i * 67) % 100) / 100,
            speed = 0.012 + (i % 4) * 0.006,
            phase = i * 0.91,
            opacity = 0.25 + (i % 5) * 0.08,
        }
    end

    -- top accent bar
    local topBar = Instance.new("Frame")
    topBar.AnchorPoint = Vector2.new(0.5, 0)
    topBar.Position = UDim2.new(0.5, 0, 0, 0)
    topBar.Size = UDim2.new(0, 0, 0, 2)
    topBar.BackgroundColor3 = ACCENT
    topBar.BorderSizePixel = 0
    topBar.ZIndex = 1012
    topBar.Parent = intro
    local topBarGrad = Instance.new("UIGradient", topBar)
    topBarGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1),
    })

    -- bottom accent bar
    local botBar = Instance.new("Frame")
    botBar.AnchorPoint = Vector2.new(0.5, 1)
    botBar.Position = UDim2.new(0.5, 0, 1, 0)
    botBar.Size = UDim2.new(0, 0, 0, 2)
    botBar.BackgroundColor3 = ACCENT
    botBar.BorderSizePixel = 0
    botBar.ZIndex = 1012
    botBar.Parent = intro
    local botBarGrad = Instance.new("UIGradient", botBar)
    botBarGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1),
    })

    -- title container
    local titleWrap = Instance.new("Frame")
    titleWrap.Name = "TitleWrap"
    titleWrap.BackgroundTransparency = 1
    titleWrap.AnchorPoint = Vector2.new(0.5, 0.5)
    titleWrap.Position = UDim2.fromScale(0.5, 0.40)
    titleWrap.Size = introIsMobile and UDim2.fromOffset(340, 120) or UDim2.fromOffset(640, 160)
    titleWrap.ZIndex = 1005
    titleWrap.Parent = intro
    local titleScale = Instance.new("UIScale", titleWrap)
    titleScale.Scale = 0.55

    -- main title
    local title = Instance.new("TextLabel")
    title.Name = "MainTitle"
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, introIsMobile and 54 or 78)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.Font = Enum.Font.GothamBlack
    title.Text = "VIOLETTE"
    title.TextColor3 = ACCENT
    title.TextSize = introIsMobile and 42 or 68
    title.TextTransparency = 1
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.ZIndex = 1006
    title.Parent = titleWrap

    -- title underline
    local underline = Instance.new("Frame")
    underline.AnchorPoint = Vector2.new(0.5, 0)
    underline.Position = UDim2.new(0.5, 0, 0, introIsMobile and 56 or 82)
    underline.Size = UDim2.new(0, 0, 0, 2)
    underline.BackgroundColor3 = ACCENT
    underline.BorderSizePixel = 0
    underline.ZIndex = 1006
    underline.Parent = titleWrap
    local ulGrad = Instance.new("UIGradient", underline)
    ulGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.2, 0.15),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(0.8, 0.15),
        NumberSequenceKeypoint.new(1, 1),
    })

    -- CC badge
    local badge = Instance.new("Frame")
    badge.Name = "CCBadge"
    badge.AnchorPoint = Vector2.new(0.5, 0)
    badge.Position = UDim2.new(0.5, 0, 0, introIsMobile and 68 or 98)
    badge.Size = introIsMobile and UDim2.fromOffset(72, 26) or UDim2.fromOffset(96, 32)
    badge.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    badge.BackgroundTransparency = 1
    badge.BorderSizePixel = 0
    badge.ZIndex = 1007
    badge.Parent = titleWrap
    Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 8)
    local badgeStroke = Instance.new("UIStroke", badge)
    badgeStroke.Color = ACCENT
    badgeStroke.Thickness = 1.4
    badgeStroke.Transparency = 1
    local badgeLbl = Instance.new("TextLabel")
    badgeLbl.BackgroundTransparency = 1
    badgeLbl.Size = UDim2.fromScale(1, 1)
    badgeLbl.Font = Enum.Font.GothamBlack
    badgeLbl.Text = "CC"
    badgeLbl.TextColor3 = ACCENT
    badgeLbl.TextSize = introIsMobile and 14 or 16
    badgeLbl.TextTransparency = 1
    badgeLbl.ZIndex = 1008
    badgeLbl.Parent = badge

    -- tagline
    local tagline = Instance.new("TextLabel")
    tagline.BackgroundTransparency = 1
    tagline.AnchorPoint = Vector2.new(0.5, 0)
    tagline.Position = UDim2.new(0.5, 0, 0.40, introIsMobile and 72 or 95)
    tagline.Size = UDim2.new(0.8, 0, 0, 22)
    tagline.Font = Enum.Font.GothamBold
    tagline.Text = "SCRIPT HUB"
    tagline.TextColor3 = DIM
    tagline.TextSize = introIsMobile and 11 or 14
    tagline.TextTransparency = 1
    tagline.TextXAlignment = Enum.TextXAlignment.Center
    tagline.ZIndex = 1005
    tagline.Parent = intro

    -- discord
    local discord = Instance.new("TextLabel")
    discord.BackgroundTransparency = 1
    discord.Text = "discord.gg/VIOLETTEHUB"
    discord.TextColor3 = Color3.fromRGB(150, 150, 160)
    discord.TextTransparency = 1
    discord.TextSize = introIsMobile and 10 or 13
    discord.Font = Enum.Font.GothamMedium
    discord.AnchorPoint = Vector2.new(0.5, 0.5)
    discord.Position = introIsMobile and UDim2.new(0.5, 0, 0.40, 110) or UDim2.new(0.5, 0, 0.40, 130)
    discord.Size = UDim2.new(0.8, 0, 0, 20)
    discord.ZIndex = 1005
    discord.Parent = intro

    -- tap / skip prompt
    local tapPrompt = Instance.new("TextLabel")
    tapPrompt.BackgroundTransparency = 1
    tapPrompt.Text = introIsMobile and "TAP TO CONTINUE" or "CLICK OR PRESS ANY KEY"
    tapPrompt.TextColor3 = Color3.fromRGB(120, 120, 130)
    tapPrompt.TextTransparency = 1
    tapPrompt.TextSize = introIsMobile and 10 or 12
    tapPrompt.Font = Enum.Font.GothamBold
    tapPrompt.AnchorPoint = Vector2.new(0.5, 1)
    tapPrompt.Position = UDim2.new(0.5, 0, 1, -36)
    tapPrompt.Size = UDim2.new(0.8, 0, 0, 20)
    tapPrompt.ZIndex = 1010
    tapPrompt.Parent = intro

    local skipBtn = Instance.new("TextButton")
    skipBtn.BackgroundTransparency = 1
    skipBtn.Text = ""
    skipBtn.Size = UDim2.fromScale(1, 1)
    skipBtn.ZIndex = 1020
    skipBtn.Parent = intro

    local blur = Instance.new("BlurEffect")
    blur.Name = "VioletteLoadIntroBlur"
    blur.Size = 0
    blur.Parent = Lighting

    local finished = false
    local animToken = 0

    local function finish()
        if finished then return end
        finished = true
        animToken = animToken + 1

        if _G._VioletteFadeIntroSong then pcall(_G._VioletteFadeIntroSong, 0.8) end

        local fade = TweenInfo.new(0.38, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        TweenService:Create(intro, fade, {BackgroundTransparency = 1}):Play()
        TweenService:Create(title, fade, {TextTransparency = 1}):Play()
        TweenService:Create(badgeLbl, fade, {TextTransparency = 1}):Play()
        TweenService:Create(badge, fade, {BackgroundTransparency = 1}):Play()
        TweenService:Create(badgeStroke, fade, {Transparency = 1}):Play()
        TweenService:Create(tagline, fade, {TextTransparency = 1}):Play()
        TweenService:Create(discord, fade, {TextTransparency = 1}):Play()
        TweenService:Create(tapPrompt, fade, {TextTransparency = 1}):Play()
        TweenService:Create(glow, fade, {BackgroundTransparency = 1}):Play()
        TweenService:Create(titleScale, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0.7}):Play()
        TweenService:Create(blur, TweenInfo.new(0.35), {Size = 0}):Play()

        task.delay(0.42, function()
            if introGui.Parent then introGui:Destroy() end
            if blur.Parent then blur:Destroy() end
            _G._VioletteLoadIntroCleanup = nil
            if onFinished then pcall(onFinished) end
        end)
    end

    _G._VioletteLoadIntroCleanup = function()
        finished = true
        animToken = animToken + 1
        if _G._VioletteStopIntroSong then pcall(_G._VioletteStopIntroSong) end
        if introGui.Parent then introGui:Destroy() end
        if blur.Parent then blur:Destroy() end
        _G._VioletteLoadIntroCleanup = nil
    end

    -- entrance
    TweenService:Create(intro, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.18}):Play()
    TweenService:Create(blur, TweenInfo.new(0.4), {Size = 12}):Play()
    TweenService:Create(glow, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.55}):Play()

    -- bars expand
    TweenService:Create(topBar, TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0.55, 0, 0, 2)}):Play()
    TweenService:Create(botBar, TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0.55, 0, 0, 2)}):Play()

    -- title slam in
    task.delay(0.12, function()
        if finished then return end
        TweenService:Create(titleScale, TweenInfo.new(0.48, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        TweenService:Create(title, TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
        TweenService:Create(underline, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(introIsMobile and 0.55 or 0.42, 0, 0, 2)
        }):Play()
    end)

    -- badge + tagline
    task.delay(0.38, function()
        if finished then return end
        TweenService:Create(badge, TweenInfo.new(0.28), {BackgroundTransparency = 0.15}):Play()
        TweenService:Create(badgeStroke, TweenInfo.new(0.28), {Transparency = 0.25}):Play()
        TweenService:Create(badgeLbl, TweenInfo.new(0.28), {TextTransparency = 0}):Play()
        TweenService:Create(tagline, TweenInfo.new(0.35), {TextTransparency = 0.15}):Play()
        TweenService:Create(discord, TweenInfo.new(0.4), {TextTransparency = 0.25}):Play()
        TweenService:Create(tapPrompt, TweenInfo.new(0.45), {TextTransparency = 0.35}):Play()
    end)

    -- subtle glitch flash on title
    task.delay(0.55, function()
        if finished then return end
        title.TextColor3 = PINK
        task.delay(0.06, function()
            if finished then return end
            title.TextColor3 = ACCENT
        end)
        task.delay(0.14, function()
            if finished then return end
            title.TextTransparency = 0.35
            task.delay(0.05, function()
                if not finished then title.TextTransparency = 0 end
            end)
        end)
    end)

    -- live animation loop (particles + pulse)
    local token = animToken
    task.spawn(function()
        local t0 = os.clock()
        while not finished and token == animToken and introGui.Parent do
            local elapsed = os.clock() - t0
            local pulse = (math.sin(elapsed * 2.4) + 1) * 0.5

            -- particles drift
            for _, starData in ipairs(particles) do
                local x = (starData.x + elapsed * starData.speed * 0.15) % 1.05 - 0.025
                local y = (starData.y + math.sin(elapsed * 0.7 + starData.phase) * 0.04) % 1.05 - 0.025
                local twinkle = (math.sin(elapsed * 2.1 + starData.phase) + 1) * 0.5
                starData.frame.Position = UDim2.fromScale(x, y)
                starData.frame.BackgroundTransparency = 1 - (0.55 + pulse * 0.25) * (starData.opacity + twinkle * 0.15)
            end

            -- title micro pulse
            if titleScale and titleScale.Parent then
                titleScale.Scale = 1 + pulse * 0.012
            end
            if glow and glow.Parent then
                glow.BackgroundTransparency = 0.50 + pulse * 0.12
            end

            -- prompt blink
            if tapPrompt and tapPrompt.Parent and elapsed > 0.9 then
                local blink = (math.sin(elapsed * 3.2) + 1) * 0.5
                tapPrompt.TextTransparency = 0.25 + blink * 0.45
            end

            RunService.RenderStepped:Wait()
        end
    end)

    skipBtn.MouseButton1Click:Connect(finish)
    local keyConn
    keyConn = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe or finished then return end
        if input.UserInputType == Enum.UserInputType.Keyboard
            or input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
            or (input.UserInputType.Name and input.UserInputType.Name:sub(1, 7) == "Gamepad") then
            if keyConn then keyConn:Disconnect() end
            finish()
        end
    end)

    task.delay(5.5, finish)
end

task.defer(function()
    local hubGui = gui
    local function revealHub()
        _G._VioletteIntroActive = false
        if hubGui then hubGui.Enabled = true end
        if _G._VioletteWantMinimized and _G._VioletteSetMinimized then
            _G._VioletteSetMinimized(true)
        else
            local outerRef = _G.VynxOuterRef
            if outerRef and outerRef.Parent then
                if _G._VioletteSetHubVisible then _G._VioletteSetHubVisible(true)
                else outerRef.Visible = true end
            end
        end
        if _G._VioletteRevealPanels then pcall(_G._VioletteRevealPanels) end
    end

    if _G._VioletteSkipIntro == true then
        revealHub()
        return
    end

    _G._VioletteIntroActive = true
    if hubGui then hubGui.Enabled = false end
    for _, key in ipairs({ "duelLagger", "pingLagger", "speedBypass" }) do
        if _G._VioletteShowPanel then pcall(_G._VioletteShowPanel, key, false) end
    end
    playVioletteLoadIntro(revealHub)
end)




;(function()
    local Players     = game:GetService("Players")
    local RunService  = game:GetService("RunService")
    local LP          = Players.LocalPlayer

    local VIOLETTE_COLOR   = Color3.fromRGB(255, 255, 255)
    local DISCORD_TEXT  = "discord.gg/violettehub"

    local selfSpeedLabel = nil
    local otherLabels = {}

    local function buildSelfTag(char)
        if not char then return end
        local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 5)
        if not head then return end
        local old = head:FindFirstChild("VioletteHeadBB")
        if old then old:Destroy() end

        local bb = Instance.new("BillboardGui", head)
        bb.Name = "VioletteHeadBB"
        bb.Size = UDim2.fromScale(4.6, 1.4)
        bb.StudsOffset = Vector3.new(0, 1.9, 0)
        bb.AlwaysOnTop = true
        bb.ResetOnSpawn = false
        bb.LightInfluence = 0
        bb.MaxDistance = 150

        local disc = Instance.new("TextLabel", bb)
        disc.Name = "Discord"
        disc.Size = UDim2.new(1, 0, 0.46, 0)
        disc.BackgroundTransparency = 1
        disc.Text = DISCORD_TEXT
        disc.Font = Enum.Font.GothamBlack
        disc.TextScaled = true
        disc.TextColor3 = VIOLETTE_COLOR
        disc.TextStrokeTransparency = 0
        disc.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        local dcon = Instance.new("UITextSizeConstraint", disc)
        dcon.MinTextSize = 6
        dcon.MaxTextSize = 15

        local val = Instance.new("TextLabel", bb)
        val.Name = "Speed"
        val.Size = UDim2.new(1, 0, 0.46, 0)
        val.Position = UDim2.new(0, 0, 0.54, 0)
        val.BackgroundTransparency = 1
        val.Text = "0"
        val.Font = Enum.Font.GothamBlack
        val.TextScaled = true
        val.TextColor3 = VIOLETTE_COLOR
        val.TextStrokeTransparency = 0
        val.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        local vcon = Instance.new("UITextSizeConstraint", val)
        vcon.MinTextSize = 6
        vcon.MaxTextSize = 15

        selfSpeedLabel = val
    end

    local function buildOtherTag(player)
        local char = player.Character
        if not char then return end
        local head = char:FindFirstChild("Head")
        if not head then return end
        local old = head:FindFirstChild("VioletteSpeedBB")
        if old then old:Destroy() end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                hum.NameDisplayDistance = 0
                hum.HealthDisplayDistance = 0
            end)
        end

        local bb = Instance.new("BillboardGui", head)
        bb.Name = "VioletteSpeedBB"
        bb.Size = UDim2.fromScale(2.5, 1.02)
        bb.StudsOffset = Vector3.new(0, 2.6, 0)
        bb.AlwaysOnTop = true
        bb.ResetOnSpawn = false
        bb.LightInfluence = 0
        bb.MaxDistance = 220

        local val = Instance.new("TextLabel", bb)
        val.Name = "Speed"
        val.Size = UDim2.new(1, 0, 1, 0)
        val.BackgroundTransparency = 1
        val.Text = "0"
        val.Font = Enum.Font.GothamBlack
        val.TextScaled = true
        val.TextColor3 = VIOLETTE_COLOR
        val.TextStrokeTransparency = 0
        val.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        local con = Instance.new("UITextSizeConstraint", val)
        con.MinTextSize = 7
        con.MaxTextSize = 21

        otherLabels[player] = val
    end

    local function watchPlayer(player)
        if player == LP then return end
        if player.Character then task.spawn(function() task.wait(0.3); pcall(buildOtherTag, player) end) end
        player.CharacterAdded:Connect(function()
            task.wait(0.4)
            pcall(buildOtherTag, player)
        end)
    end

    for _, player in ipairs(Players:GetPlayers()) do watchPlayer(player) end
    Players.PlayerAdded:Connect(watchPlayer)
    Players.PlayerRemoving:Connect(function(player) otherLabels[player] = nil end)

    if LP.Character then
        task.spawn(function() task.wait(0.3); pcall(buildSelfTag, LP.Character) end)
    end
    LP.CharacterAdded:Connect(function(char)
        task.wait(0.3)
        pcall(buildSelfTag, char)
    end)

    task.spawn(function()
        while task.wait(1) do
            local char = LP.Character
            local head = char and char:FindFirstChild("Head")
            if head and not head:FindFirstChild("VioletteHeadBB") then
                pcall(buildSelfTag, char)
            end
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LP then
                    local pc = player.Character
                    local ph = pc and pc:FindFirstChild("Head")
                    if ph and not ph:FindFirstChild("VioletteSpeedBB") then
                        pcall(buildOtherTag, player)
                    elseif pc then
                        local phum = pc:FindFirstChildOfClass("Humanoid")
                        if phum and phum.DisplayDistanceType ~= Enum.HumanoidDisplayDistanceType.None then
                            pcall(function()
                                phum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                                phum.NameDisplayDistance = 0
                                phum.HealthDisplayDistance = 0
                            end)
                        end
                    end
                end
            end
        end
    end)

    local smoothed = 0
    RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function(deltaTime)
        if selfSpeedLabel and selfSpeedLabel.Parent then
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if hrp then
                local routing = (_G._VioletteAutoPathActive and _G._VioletteAutoPathActive()) or false
                local aimbotting = (_G._VioletteGetAimbotSpeed and _G._VioletteGetAimbotSpeed()) ~= nil
                if humanoid and not routing and not aimbotting
                    and humanoid.MoveDirection.Magnitude == 0 then
                    smoothed = 0
                    selfSpeedLabel.Text = "0"
                else
                    local vel = hrp.AssemblyLinearVelocity
                    local horizontal = Vector3.new(vel.X, 0, vel.Z).Magnitude

                    local ceiling = 0
                    if not routing then
                        ceiling = tonumber(_G._VioletteGetSpeed and _G._VioletteGetSpeed()) or 0
                        if ceiling > 0 then
                            horizontal = math.min(horizontal, ceiling)
                            smoothed = math.min(smoothed, ceiling)
                        end
                    end

                    local step = math.clamp(deltaTime or 1 / 60, 1 / 240, 1 / 15)
                    local response = (horizontal > smoothed) and 14 or 2.2
                    smoothed = smoothed + (horizontal - smoothed) * (1 - math.exp(-response * step))
                    if ceiling > 0 and smoothed >= ceiling * 0.9 then smoothed = ceiling end
                    if smoothed < 0.15 then smoothed = 0 end
                    selfSpeedLabel.Text = string.format("%d", math.floor(smoothed + 0.5))
                end
            end
        end

        local SPEED_TAG_NEAR = 24
        local SPEED_TAG_FAR  = 160
        local SPEED_TAG_MAX  = 1.9
        local speedTagCam = workspace.CurrentCamera
        local camCF = speedTagCam and speedTagCam.CFrame

        for player, label in pairs(otherLabels) do
            if label and label.Parent then
                local pc = player.Character
                local prp = pc and pc:FindFirstChild("HumanoidRootPart")
                if prp then
                    local vel = prp.AssemblyLinearVelocity or prp.Velocity
                    label.Text = string.format("%d", math.floor(Vector3.new(vel.X, 0, vel.Z).Magnitude + 0.5))

                    local bb = label.Parent
                    if camCF and bb and bb:IsA("BillboardGui") then
                        local dist = (camCF.Position - prp.Position).Magnitude
                        local grow = math.clamp(dist / SPEED_TAG_NEAR, 1, SPEED_TAG_FAR / SPEED_TAG_NEAR)
                        grow = math.min(grow, SPEED_TAG_MAX)
                        bb.Size = UDim2.fromScale(2.5 * grow, 1.02 * grow)
                    end
                end
            else
                otherLabels[player] = nil
            end
        end
    end))

    _G._VioletteHeadTagColor = VIOLETTE_COLOR
    _G._VioletteDiscordText = DISCORD_TEXT

    _G._VioletteSetTagColor = function(c)
        if typeof(c) ~= "Color3" then return end
        VIOLETTE_COLOR = c
        _G._VioletteHeadTagColor = c
        if selfSpeedLabel and selfSpeedLabel.Parent then
            selfSpeedLabel.TextColor3 = c
            local disc = selfSpeedLabel.Parent:FindFirstChild("Discord")
            if disc then disc.TextColor3 = c end
        end
        for _, label in pairs(otherLabels) do
            if label and label.Parent then label.TextColor3 = c end
        end
    end
    if _G._VioletteAccent then pcall(_G._VioletteSetTagColor, _G._VioletteAccent) end
end)()

;(function()

    _G._VioletteFakeSpeed = tonumber(_G._VioletteFakeSpeed) or 16

    local HIJACK = _G._VelHijackStore
    if type(HIJACK) ~= "table" then
        HIJACK = { v = Vector3.zero }
        _G._VelHijackStore = HIJACK
    end
    HIJACK.v = Vector3.zero

    local LP = LocalPlayer

    if not _G._VelHijackInstalled then
        local ok = pcall(function()
            local _mt = getrawmetatable(game)
            setreadonly(_mt, false)

            local _oi = _mt.__index
            local _on = _mt.__newindex

            local function isOurRoot(t, k)
                local _tk = tostring(k)
                if _tk ~= "AssemblyLinearVelocity" and _tk ~= "Velocity" then return false end
                if typeof(t) ~= "Instance" or not t:IsA("BasePart") then return false end
                local _tn = t.Name
                if _tn ~= "HumanoidRootPart" and _tn ~= "Torso" and _tn ~= "UpperTorso" then return false end
                local char = LP.Character
                return char ~= nil and t:IsDescendantOf(char)
            end

            _mt.__index = newcclosure(LPH_NO_VIRTUALIZE(function(t, k)
                if not checkcaller() then
                    local good, mine = pcall(isOurRoot, t, k)
                    if good and mine then return HIJACK.v end
                end
                return _oi(t, k)
            end))

            _mt.__newindex = newcclosure(LPH_NO_VIRTUALIZE(function(t, k, v)
                if not checkcaller() then
                    local good, mine = pcall(isOurRoot, t, k)
                    if good and mine then
                        HIJACK.v = v
                        return
                    end
                end
                return _on(t, k, v)
            end))

            setreadonly(_mt, true)
        end)
        _G._VelHijackInstalled = ok
    end

    local _r = Random.new()
    local _acc = 0

    local function _gc()
        local c = LP.Character
        if not c then return nil, nil, nil end
        local h = c:FindFirstChildOfClass("Humanoid")
        local r = c:FindFirstChild("HumanoidRootPart")
        if h and h.Health > 0 and r then return c, h, r end
        return nil, nil, nil
    end

    RunService.PreSimulation:Connect(function(dt)
        _acc = _acc + dt
        if _acc < 0.016 then return end
        _acc = 0

        local c, h, r = _gc()
        if not c or not h or not r then return end

        local st = h:GetState()
        if h.PlatformStand
            or st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown then
            HIJACK.v = Vector3.new(0, r.AssemblyLinearVelocity.Y, 0)
            return
        end

        local m = h.MoveDirection
        if m.Magnitude > 0.05 then
            pcall(function()
                if r.SetNetworkOwner then r:SetNetworkOwner(LP) end
            end)

            local u    = m.Unit
            local fake = tonumber(_G._VioletteFakeSpeed) or 16
            local real = math.clamp(tonumber(_G._VioletteGetSpeed and _G._VioletteGetSpeed()) or 0, 0, 10000)
            local jx   = _r:NextNumber(-0.003, 0.003)
            local jz   = _r:NextNumber(-0.003, 0.003)
            local y    = r.AssemblyLinearVelocity.Y

            HIJACK.v = Vector3.new(u.X * fake + jx, y, u.Z * fake + jz)
            r.AssemblyLinearVelocity = Vector3.new(u.X * real + jx, y, u.Z * real + jz)
            _G._RaVeLiveSpeed = { t = os.clock(), v = real }
        else
            HIJACK.v = Vector3.new(0, r.AssemblyLinearVelocity.Y, 0)
        end
    end)
end)()

;(function()

    local LP = LocalPlayer

    local _conns = {}
    local function hubConnect(signal, handler)
        local c = signal:Connect(handler)
        _conns[#_conns + 1] = c
        return c
    end

    local infJumpEnabled = false

    local CFG = {
        jumpPower     = 37,
        maxJumpHeight = 55,
        roofClearance = 4.2,
    }

    local JUMP_COOLDOWN     = 0.08
    local INF_JUMP_PULSE    = 0.06
    local HOLD_JUMP_REFRESH = 0.12

    local Controller = {}
    if _G.VX7InfinityJump and _G.VX7InfinityJump.Destroy then pcall(_G.VX7InfinityJump.Destroy) end
    Controller.Enabled = false

    local _groundY         = nil
    local _roofBlockUntil  = 0
    local _lastJumpTime    = 0
    local _jumpWasGrounded = true
    local _holdStall       = 0
    local _padJumpHeld     = false
    local _hic             = {}
    local _pulseTokens     = setmetatable({}, {__mode = "k"})

    local function holdModeOn()
        return _G._VezyJumpMode == "Hold" or _G._AdaptInfJumpMode == "HOLD"
    end

    local function isAliveRoot(root)
        if not (root and root.Parent) then return false end
        local char = root.Parent
        if char ~= LP.Character then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        return hum ~= nil and hum.Health > 0
    end

    local function stopNamed(root, prefix)
        if not root then return end
        local lv = root:FindFirstChild(prefix .. "LinearVelocity")
        if lv and lv:IsA("LinearVelocity") then
            _pulseTokens[lv] = nil
            pcall(function() lv.Enabled = false; lv.LineVelocity = 0; lv:Destroy() end)
        end
        local att = root:FindFirstChild(prefix .. "Attachment")
        if att and att:IsA("Attachment") then pcall(function() att:Destroy() end) end
    end

    local function getVertical(root, prefix)
        if not isAliveRoot(root) then return nil end
        local attName, lvName = prefix .. "Attachment", prefix .. "LinearVelocity"
        local att = root:FindFirstChild(attName)
        if not (att and att:IsA("Attachment")) then
            att = Instance.new("Attachment"); att.Name = attName; att.Parent = root
        end
        local lv = root:FindFirstChild(lvName)
        if not (lv and lv:IsA("LinearVelocity")) then
            lv = Instance.new("LinearVelocity"); lv.Name = lvName; lv.Parent = root
        end
        lv.Attachment0 = att
        lv.RelativeTo = Enum.ActuatorRelativeTo.World
        lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
        lv.LineDirection = Vector3.new(0, 1, 0)
        pcall(function() lv.ForceLimitsEnabled = false end)
        return lv
    end

    local function pulseVertical(root, prefix, speed, duration)
        local lv = getVertical(root, prefix)
        if not lv then return nil end
        local token = {}
        _pulseTokens[lv] = token
        lv.LineVelocity = speed or 0
        lv.Enabled = true
        task.delay(duration or 0.1, function()
            if _pulseTokens[lv] ~= token then return end
            _pulseTokens[lv] = nil
            if lv.Parent then stopNamed(root, prefix) end
        end)
        return lv
    end

    local function readRootVelocity(root)
        if not (root and root.Parent) then return Vector3.zero end
        local ok, v = pcall(function() return root:GetVelocityAtPosition(root.Position) end)
        return ok and v or Vector3.zero
    end

    local _roofParams = RaycastParams.new()
    _roofParams.FilterType = Enum.RaycastFilterType.Exclude
    pcall(function() _roofParams.RespectCanCollide = true end)

    local function checkRoofCollision(root, dt)
        local char = LP.Character
        if not (char and root and root.Parent) then return false end

        _roofParams.FilterDescendantsInstances = { char }

        local upwardSpeed = math.max(readRootVelocity(root).Y, 0)
        if upwardSpeed <= 0.25 then return false end

        local frameTime = math.clamp(dt or (1 / 60), 1 / 240, 1 / 15)
        local roofDistance = (CFG.roofClearance or 4.2) + math.min(upwardSpeed * frameTime, 0.9)

        local roofHit = workspace:Raycast(root.Position, Vector3.new(0, roofDistance, 0), _roofParams)
        if not roofHit then return false end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.Jump = false end

        local roofVel = root.AssemblyLinearVelocity
        local infJumpActive = root:FindFirstChild("InfJumpLinearVelocity") ~= nil
        if roofVel.Y > 0 and (infJumpActive or roofVel.Y > 60) then
            root.AssemblyLinearVelocity = Vector3.new(roofVel.X, 0, roofVel.Z)
        end

        _roofBlockUntil = tick() + 0.12
        return true
    end

    local function jumpPower()
        return math.clamp(tonumber(CFG.jumpPower) or 37, 35, 48)
    end

    local function jumpCapped(root)
        if not root or not _groundY then return false end
        return (root.Position.Y - _groundY) >= (tonumber(CFG.maxJumpHeight) or 55)
    end

    local function tryPulse(root, hum, manualRequest)
        if not (root and hum) or not isAliveRoot(root) then return false end
        local now = tick()
        if now < _roofBlockUntil then return false end
        if jumpCapped(root) then
            if root:FindFirstChild("InfJumpLinearVelocity") then stopNamed(root, "InfJump") end
            return false
        end
        if hum.FloorMaterial ~= Enum.Material.Air then
            _jumpWasGrounded = true; _lastJumpTime = 0; _groundY = root.Position.Y
            return false
        end
        if _jumpWasGrounded then _jumpWasGrounded = false; return false end
        if now - _lastJumpTime < JUMP_COOLDOWN then return false end
        if not manualRequest and readRootVelocity(root).Y > 32 then return false end
        _lastJumpTime = now
        pulseVertical(root, "InfJump", jumpPower(), INF_JUMP_PULSE)
        return true
    end

    local function isGamepad(input)
        return input.UserInputType.Name:sub(1, 7) == "Gamepad"
    end

    local function startHoldInfJump()
        if _hic.loop then return end

        _hic.padDown = hubConnect(UserInputService.InputBegan, function(input)
            if input.KeyCode == Enum.KeyCode.ButtonA and isGamepad(input) then
                _padJumpHeld = true
            end
        end)
        _hic.padUp = hubConnect(UserInputService.InputEnded, function(input)
            if input.KeyCode == Enum.KeyCode.ButtonA and isGamepad(input) then
                _padJumpHeld = false
            end
        end)

        _hic.jumpReq = hubConnect(UserInputService.JumpRequest, function()
            if not infJumpEnabled then return end
            local char = LP.Character; if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            local hum  = char:FindFirstChildOfClass("Humanoid")
            if root and hum then tryPulse(root, hum, true) end
        end)

        _hic.loop = hubConnect(RunService.Heartbeat, LPH_NO_VIRTUALIZE(function(dt)
            if not infJumpEnabled then return end
            local char = LP.Character; if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
            local hum  = char:FindFirstChildOfClass("Humanoid");   if not hum then return end

            checkRoofCollision(root, dt)

            if hum.FloorMaterial ~= Enum.Material.Air then
                _jumpWasGrounded = true; _lastJumpTime = 0
                _groundY = root.Position.Y; _holdStall = 0
                if root:FindFirstChild("InfJumpLinearVelocity") then stopNamed(root, "InfJump") end
                return
            end
            if _jumpWasGrounded then _jumpWasGrounded = false end

            local jumpHeld = holdModeOn()
                and (UserInputService:IsKeyDown(Enum.KeyCode.Space) or _padJumpHeld or hum.Jump == true)
            local currentY = readRootVelocity(root).Y

            if currentY < -120 then
                _holdStall = 0
                pulseVertical(root, "InfJump", -120, 0.08)

            elseif jumpHeld then
                local blocked = (tick() < _roofBlockUntil) or jumpCapped(root)
                if not blocked then
                    local cmd = jumpPower()
                    if currentY < cmd * 0.35 then _holdStall = _holdStall + 1 else _holdStall = 0 end
                    if _holdStall >= 4 then
                        blocked = true; _roofBlockUntil = tick() + 0.45; _holdStall = 0
                    end
                end
                if blocked then
                    if root:FindFirstChild("InfJumpLinearVelocity") then stopNamed(root, "InfJump") end
                else
                    _lastJumpTime = tick()
                    pulseVertical(root, "InfJump", jumpPower(), HOLD_JUMP_REFRESH)
                end

            else
                _holdStall = 0
                if root:FindFirstChild("InfJumpLinearVelocity") then stopNamed(root, "InfJump") end
            end
        end))
    end

    local function stopHoldInfJump()
        for _, key in ipairs({"jumpReq", "loop", "padDown", "padUp"}) do
            local connection = _hic[key]
            if connection then pcall(function() connection:Disconnect() end) end
        end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then stopNamed(root, "InfJump") end
        _hic = {}
        _lastJumpTime = 0
        _jumpWasGrounded = true
        _holdStall = 0
        _roofBlockUntil = 0
        _padJumpHeld = false
    end

    hubConnect(LP.CharacterAdded, function()
        _groundY = nil; _jumpWasGrounded = true
        _lastJumpTime = 0; _holdStall = 0; _roofBlockUntil = 0
        _padJumpHeld = false
    end)

    local function setInfJumpEnabled(on)
        infJumpEnabled = on and true or false
        Controller.Enabled = infJumpEnabled
        Enabled.InfiniteJump = infJumpEnabled
        if infJumpEnabled then
            startHoldInfJump()
        else
            stopHoldInfJump()
        end
    end

    function Controller.SetEnabled(enabled)
        setInfJumpEnabled(enabled == true)
        return Controller.Enabled
    end
    function Controller.GetEnabled()
        return Controller.Enabled == true
    end
    function Controller.Toggle()
        Controller.SetEnabled(not Controller.Enabled)
        return Controller.Enabled
    end
    function Controller.ClearVelocity()
        local char = LP.Character
        stopNamed(char and char:FindFirstChild("HumanoidRootPart"), "InfJump")
    end
    function Controller.Destroy()
        setInfJumpEnabled(false)
        for _, c in ipairs(_conns) do pcall(function() c:Disconnect() end) end
        _conns = {}
        if _G.VX7InfinityJump == Controller then _G.VX7InfinityJump = nil end
        if _G._CandyInfinityJump == Controller then _G._CandyInfinityJump = nil end
        if _G.HoldInfJump and _G.HoldInfJump.cfg == CFG then _G.HoldInfJump = nil end
    end

    _G.VX7InfinityJump    = Controller
    _G._CandyInfinityJump = Controller
    _G.HoldInfJump = {
        cfg   = CFG,
        start = startHoldInfJump,
        stop  = stopHoldInfJump,
    }

    startInfiniteJump     = function() setInfJumpEnabled(true)  end
    stopInfiniteJump      = function() setInfJumpEnabled(false) end
    _G.VezyEnableInfJump  = startInfiniteJump
    _G.VezyDisableInfJump = stopInfiniteJump

    _G._VezyJumpMode      = _G._VezyJumpMode or "Single"
    _G._AdaptInfJumpMode  = _G._AdaptInfJumpMode or "TAP"

    setInfJumpEnabled(Enabled.InfiniteJump == true)
end)()

;(function()

    local LP = LocalPlayer

    if _G._VioletteNoPlayerCollision and _G._VioletteNoPlayerCollision.Destroy then
        pcall(_G._VioletteNoPlayerCollision.Destroy)
    end

    local _wfConns = {}
    local function track(c)
        _wfConns[#_wfConns + 1] = c
        return c
    end

    local function clearCharacter(char)
        if not char then return end
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end

    local function disableOtherCollisions()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                clearCharacter(plr.Character)
            end
        end
    end

    local function watchCharacter(char)
        task.spawn(function()
            for _ = 1, 12 do
                if not char.Parent then return end
                clearCharacter(char)
                task.wait(0.1)
            end
        end)
    end

    local function watchPlayer(plr)
        if plr == LP then return end
        if plr.Character then watchCharacter(plr.Character) end
        track(plr.CharacterAdded:Connect(watchCharacter))
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        watchPlayer(plr)
    end
    track(Players.PlayerAdded:Connect(watchPlayer))

    local _acc = 0
    track(RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function(dt)
        _acc = _acc + dt
        if _acc < 0.2 then return end
        _acc = 0
        pcall(disableOtherCollisions)
    end)))

    _G._VioletteNoPlayerCollision = {
        Refresh = disableOtherCollisions,
        Destroy = function()
            for _, c in ipairs(_wfConns) do pcall(function() c:Disconnect() end) end
            _wfConns = {}
            if _G._VioletteNoPlayerCollision then _G._VioletteNoPlayerCollision = nil end
        end,
    }
end)()

;(function()

    local LP = LocalPlayer

    if _G._VioletteAutoSpeedRuntime and _G._VioletteAutoSpeedRuntime.Destroy then
        pcall(_G._VioletteAutoSpeedRuntime.Destroy)
    end

    local _conns = {}
    local function hubConnect(signal, handler)
        local c = signal:Connect(handler)
        _conns[#_conns + 1] = c
        return c
    end

    _G._VynxAutoSpeedRange = tonumber(_G._VynxAutoSpeedRange) or 15

    local RT = { active = false, previous = nil, graceUntil = 0, conn = nil }

    local function paintCarryModes()
        pcall(Spd.Refresh)
        if _G._VioletteSyncMobileSpeedBtns then pcall(_G._VioletteSyncMobileSpeedBtns) end
    end

    local function isIgnoredCarryTool(name)
        local n = tostring(name or ""):lower()
        return n:find("bat") or n:find("slap") or n:find("medusa")
            or n:find("head") or n:find("stone")
    end

    local function isCarryingBrainrot(char)
        if not char then return false end
        if LP:GetAttribute("Stealing") == true or LP:GetAttribute("AntiKick") == true
            or char:GetAttribute("Stealing") == true then return true end
        for _, name in ipairs({"Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab"}) do
            local value = char:FindFirstChild(name, true)
            if value and ((value:IsA("BoolValue") and value.Value)
                or (value:IsA("ObjectValue") and value.Value)
                or (value:IsA("StringValue") and value.Value ~= "")) then return true end
        end
        for _, child in ipairs(char:GetChildren()) do
            local n = child.Name:lower()
            if child:IsA("Tool") and not isIgnoredCarryTool(n) then return true end
            if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true)
                and (n:find("brainrot") or n:find("animal") or n:find("carry")
                    or n:find("grab") or n:find("steal") or n:find("hold")) then return true end
        end
        return false
    end

    local function enableAutoCarrySpeed()
        if RT.active then RT.graceUntil = tick() + 0.75; return end
        RT.previous = { family = Spd.family, carry = Spd.carry }
        RT.active = true
        RT.graceUntil = tick() + 0.75
        Spd.carry = true
        paintCarryModes()
    end

    local function disableAutoCarrySpeed()
        if not RT.active then return end
        local previous = RT.previous
        RT.active, RT.previous = false, nil
        if previous then Spd.family, Spd.carry = previous.family, previous.carry end
        paintCarryModes()
    end

    local softSteal = { spots = {}, nextScan = 0, latched = false, held = false, armed = true }

    local function softStealScan()
        local spots = {}
        local plots = workspace:FindFirstChild("Plots")
        if not plots then softSteal.spots = spots; return end
        for _, plot in ipairs(plots:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            local yourBase = sign and sign:FindFirstChild("YourBase")
            local mine = yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled == true
            if not mine then
                local podiums = plot:FindFirstChild("AnimalPodiums")
                if podiums then
                    for _, podium in ipairs(podiums:GetChildren()) do
                        local base = podium:FindFirstChild("Base")
                        local spawnPart = base and base:FindFirstChild("Spawn")
                        if spawnPart then spots[#spots + 1] = spawnPart.Position end
                    end
                end
            end
        end
        softSteal.spots = spots
    end

    local function softStealApply()
        if not RT.active then
            RT.previous = { family = Spd.family, carry = Spd.carry }
            RT.active = true
        end
        RT.graceUntil = tick() + 0.75
        Spd.carry = true
        paintCarryModes()
    end

    local function softStealInRange(char)
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return false end
        local range = tonumber(_G._VynxAutoSpeedRange) or 15
        local target = _G._VioletteStealTargetPos or _G._RaVeStealTargetPos
        if typeof(target) == "Vector3" and (root.Position - target).Magnitude <= range then
            return true
        end
        local now = tick()
        if now >= softSteal.nextScan then
            softSteal.nextScan = now + 0.5
            softStealScan()
        end
        for _, spot in ipairs(softSteal.spots) do
            if (root.Position - spot).Magnitude <= range then return true end
        end
        return false
    end

    local function startAutoSpeed()
        if RT.conn then RT.conn:Disconnect() end
        RT.conn = hubConnect(RunService.RenderStepped, LPH_NO_VIRTUALIZE(function()
            if not _G._VynxAutoSpeedOn then disableAutoCarrySpeed(); return end
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not char or not hum or hum.Health <= 0 then disableAutoCarrySpeed(); return end

            if _G._VynxAutoSpeedMode == "Soft Steal" then
                local inRange = softStealInRange(char)
                local carrying = isCarryingBrainrot(char)
                if not inRange then softSteal.armed = true end
                if not inRange or Spd.carry ~= true then softSteal.latched = false end
                if inRange and softSteal.armed and not softSteal.latched then
                    softSteal.latched = true
                    softSteal.held = false
                    softStealApply()
                end
                if RT.active then
                    if carrying then
                        softSteal.held = true
                        RT.graceUntil = tick() + 0.75
                    elseif softSteal.held then
                        softSteal.held = false
                        softSteal.latched = false
                        softSteal.armed = false
                        disableAutoCarrySpeed()
                    elseif not inRange and tick() > RT.graceUntil then
                        softSteal.latched = false
                        disableAutoCarrySpeed()
                    end
                end
                return
            end

            if isCarryingBrainrot(char) then
                enableAutoCarrySpeed()
            elseif RT.active then
                disableAutoCarrySpeed()
            end
        end))
    end

    local function stopAutoSpeed()
        if RT.conn then RT.conn:Disconnect(); RT.conn = nil end
        softSteal.latched, softSteal.held, softSteal.armed = false, false, true
        disableAutoCarrySpeed()
    end

    hubConnect(LP.CharacterAdded, function()
        softSteal.latched, softSteal.held, softSteal.armed = false, false, true
    end)

    _G._VioletteStartAutoSpeed = startAutoSpeed
    _G._VioletteStopAutoSpeed  = stopAutoSpeed

    _G._AdaptStartAutoCarry = startAutoSpeed
    _G._AdaptStopAutoCarry  = stopAutoSpeed
    _G._CandyIsCarrying     = isCarryingBrainrot
    _G.AutoCarrySpeed = {
        IsCarryingBrainrot = isCarryingBrainrot,
        Enable  = enableAutoCarrySpeed,
        Disable = disableAutoCarrySpeed,
    }

    _G._VioletteAutoSpeedRuntime = {
        Destroy = function()
            stopAutoSpeed()
            for _, c in ipairs(_conns) do pcall(function() c:Disconnect() end) end
            _conns = {}
            _G._VioletteAutoSpeedRuntime = nil
        end,
    }

    startAutoSpeed()
end)()

;(function()

    local LP = LocalPlayer

    if _G._VioletteAntiRagdollRuntime and _G._VioletteAntiRagdollRuntime.Destroy then
        pcall(_G._VioletteAntiRagdollRuntime.Destroy)
    end

    local antiRagdollConn = nil
    local antiRagdollMode = nil
    local ragdollConnections = {}
    local cachedCharData = {}
    local isBoosting = false
    local BOOST_SPEED = 400
    local AR_DEFAULT_SPEED = 16

    local function arV2ResetCharacter(char)
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end

        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hum:ChangeState(Enum.HumanoidStateType.Running)
            root.Velocity = Vector3.zero
            root.RotVelocity = Vector3.zero
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            hum.PlatformStand = false
            hum.Sit = false
            hum.AutoRotate = true
            hum.JumpPower = hum.JumpPower > 0 and hum.JumpPower or 50
            hum.WalkSpeed = hum.WalkSpeed > 0 and hum.WalkSpeed or AR_DEFAULT_SPEED

            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("Motor6D") then
                    obj.Enabled = true
                elseif obj:IsA("Constraint") or obj:IsA("BallSocketConstraint") or obj:IsA("HingeConstraint") then
                    obj.Enabled = true
                elseif obj:IsA("BasePart") then
                    obj.CanCollide = true
                    obj.AssemblyLinearVelocity = Vector3.zero
                    obj.AssemblyAngularVelocity = Vector3.zero
                end
            end

            if workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject = hum end
            local playerModule = LP:FindFirstChild("PlayerScripts") and LP.PlayerScripts:FindFirstChild("PlayerModule")
            local controlModule = playerModule and playerModule:FindFirstChild("ControlModule")
            if controlModule then
                local loaded, module = pcall(require, controlModule)
                if loaded and module and module.Enable then module:Enable() end
            end
        end)
    end

    local function arCacheCharacterData()
        local char = LP.Character
        if not char then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return false end
        cachedCharData = { character = char, humanoid = hum, root = root }
        _G._VioletteRagdollCache = cachedCharData
        return true
    end

    local function arDisconnectAll()
        for _, conn in ipairs(ragdollConnections) do
            pcall(function() conn:Disconnect() end)
        end
        ragdollConnections = {}
    end

    local function arIsRagdolled()
        if not cachedCharData.humanoid then return false end
        local state = cachedCharData.humanoid:GetState()
        local ragdollStates = {
            [Enum.HumanoidStateType.Physics] = true,
            [Enum.HumanoidStateType.Ragdoll] = true,
            [Enum.HumanoidStateType.FallingDown] = true,
        }
        if ragdollStates[state] then return true end
        local endTime = LP:GetAttribute("RagdollEndTime")
        if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then return true end
        return false
    end

    local function arForceExitRagdoll()
        if not cachedCharData.humanoid or not cachedCharData.root then return end
        pcall(function()
            LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
        end)
        for _, descendant in ipairs(cachedCharData.character:GetDescendants()) do
            if descendant:IsA("BallSocketConstraint") or
               (descendant:IsA("Attachment") and descendant.Name:find("RagdollAttachment")) then
                descendant:Destroy()
            end
        end
        if not isBoosting then
            isBoosting = true
            cachedCharData.humanoid.WalkSpeed = BOOST_SPEED
        end
        if cachedCharData.humanoid.Health > 0 then
            cachedCharData.humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
        cachedCharData.root.Anchored = false
    end

    local function arHeartbeatLoop()
        while antiRagdollMode == "v1" do
            task.wait()
            local currentlyRagdolled = arIsRagdolled()
            if currentlyRagdolled then
                arForceExitRagdoll()
            elseif isBoosting and not currentlyRagdolled then
                isBoosting = false
                if cachedCharData.humanoid then
                    cachedCharData.humanoid.WalkSpeed = AR_DEFAULT_SPEED
                end
            end
        end
    end

    local function arStart()
        Enabled.AntiRagdoll = true
        local requestedMode = (_G._VynxRagdollMode == "V2") and "v2" or "v1"
        if antiRagdollMode == requestedMode then return end

        antiRagdollMode = nil
        if antiRagdollConn then
            antiRagdollConn:Disconnect()
            antiRagdollConn = nil
        end
        if isBoosting and cachedCharData.humanoid then
            cachedCharData.humanoid.WalkSpeed = AR_DEFAULT_SPEED
        end
        isBoosting = false
        arDisconnectAll()
        cachedCharData = {}

        if not arCacheCharacterData() then return end
        antiRagdollMode = requestedMode

        if requestedMode == "v2" then
            antiRagdollConn = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
                if antiRagdollMode ~= "v2" or not Enabled.AntiRagdoll then return end
                local char = LP.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if not hum then return end
                local state = hum:GetState()
                if state == Enum.HumanoidStateType.Physics
                    or state == Enum.HumanoidStateType.Ragdoll
                    or state == Enum.HumanoidStateType.FallingDown
                    or state == Enum.HumanoidStateType.Dead
                    or hum.PlatformStand == true
                    or hum.Sit == true then
                    arV2ResetCharacter(char)
                end
            end))
            return
        end

        local camConn = RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
            local cam = workspace.CurrentCamera
            if cam and cachedCharData.humanoid then
                cam.CameraSubject = cachedCharData.humanoid
            end
        end))
        table.insert(ragdollConnections, camConn)

        local respawnConn = LP.CharacterAdded:Connect(function()
            isBoosting = false
            task.wait(0.5)
            arCacheCharacterData()
        end)
        table.insert(ragdollConnections, respawnConn)

        task.spawn(arHeartbeatLoop)
    end

    local function arStop()
        Enabled.AntiRagdoll = false
        antiRagdollMode = nil
        if antiRagdollConn then
            antiRagdollConn:Disconnect()
            antiRagdollConn = nil
        end
        if isBoosting and cachedCharData.humanoid then
            cachedCharData.humanoid.WalkSpeed = AR_DEFAULT_SPEED
        end
        isBoosting = false
        arDisconnectAll()
        cachedCharData = {}
        _G._VioletteRagdollCache = {}
    end

    local _rebindConn = LP.CharacterAdded:Connect(function()
        if not Enabled.AntiRagdoll then return end
        task.wait(0.5)
        if not Enabled.AntiRagdoll then return end
        antiRagdollMode = nil
        arStart()
    end)

    startAntiRagdoll = arStart
    stopAntiRagdoll  = arStop
    _G._VioletteStartAntiRagdoll = arStart
    _G._VioletteStopAntiRagdoll  = arStop

    _G._VioletteAntiRagdollRuntime = {
        IsRagdolled = arIsRagdolled,
        Destroy = function()
            arStop()
            pcall(function() _rebindConn:Disconnect() end)
            _G._VioletteAntiRagdollRuntime = nil
        end,
    }

    if Enabled.AntiRagdoll then arStart() end
end)()

;(function()

    local LP = LocalPlayer

    if _G._VioletteAutoStealRuntime and _G._VioletteAutoStealRuntime.Destroy then
        pcall(_G._VioletteAutoStealRuntime.Destroy)
    end

    local _conns = {}
    local function hubConnect(signal, handler)
        local c = signal:Connect(handler)
        _conns[#_conns + 1] = c
        return c
    end

    _G._KawatanStealRadii = _G._KawatanStealRadii or {}
    local StealRadii = _G._KawatanStealRadii
    StealRadii.Normal = tonumber(_G._VynxStealRadiusNormal) or tonumber(Settings.StealRadius) or 62
    StealRadii.Semi   = tonumber(_G._VynxStealRadiusSemi) or 8.7

    local function stealMode()
        return (_G._VynxAutoStealMode == "Semi") and "Semi" or "Normal"
    end
    local function autoStealOn()
        return Enabled.AutoSteal == true
    end
    local function stealDuration()
        return tonumber(Settings.StealDuration) or STEAL_DURATION_FIXED
    end

    _G.K7NormalSteal = _G.K7NormalSteal or {
        enabled = false, radius = 62, duration = STEAL_DURATION_FIXED,
        animals = {}, promptCache = {}, internalCache = {},
        scannerStarted = false, isStealing = false,
        stealConn = nil, lastSteal = 0, cooldown = 0.05,
    }

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
                                })
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
            local t0 = tick(); local dur = A.duration or STEAL_DURATION_FIXED
            while A.enabled and stealMode()=="Normal" and tick()-t0 < dur do
                local p = math.min((tick()-t0)/dur, FILL_CAP)
                pcall(function() if _G.StealBar then _G.StealBar.SetProgress(p) end end)
                if p >= FILL_CAP then break end
                task.wait(0.02)
            end
            if not A.enabled or stealMode()~="Normal" then
                data.ready=true; A.isStealing=false
                pcall(function() if _G.StealBar then _G.StealBar.Reset() end end)
                return
            end
            local holdT0 = tick(); local completed = false
            while A.enabled and stealMode()=="Normal" and tick()-holdT0 < HOLD_TIME do
                pcall(function() if _G.StealBar then _G.StealBar.SetProgress(FILL_CAP) end end)
                if inCompleteRange() then completed = true break end
                task.wait(0.02)
            end
            if not A.enabled or stealMode()~="Normal" or not completed then
                data.ready=true; A.isStealing=false
                pcall(function() if _G.StealBar then _G.StealBar.Reset() end end)
                return
            end
            local t1 = tick(); local fillDur = dur*(1-FILL_CAP)
            while A.enabled and stealMode()=="Normal" and tick()-t1 < fillDur do
                local p = FILL_CAP + math.min((tick()-t1)/fillDur, 1)*(1-FILL_CAP)
                pcall(function() if _G.StealBar then _G.StealBar.SetProgress(p) end end)
                task.wait(0.02)
            end
            if not A.enabled or stealMode()~="Normal" then
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
        A.radius   = tonumber(Settings.StealRadius) or StealRadii.Normal
        A.duration = stealDuration()
        A.enabled  = true
        _normalEnsureScanner()
        pcall(_normalScanPlots)
        if A.stealConn then A.stealConn:Disconnect(); A.stealConn=nil end
        A.stealConn = hubConnect(RunService.Heartbeat, LPH_NO_VIRTUALIZE(function()
            if not A.enabled then return end
            if stealMode()~="Normal" then _G.K7NormalAutoStealStop(); return end
            A.radius   = tonumber(Settings.StealRadius) or A.radius
            A.duration = stealDuration()
            if A.isStealing then return end
            local target = _normalNearestAnimal()
            if not target then return end
            local prompt = _normalFindPrompt(target)
            if prompt then _normalDoSteal(prompt, target) end
        end))
    end

    _G.K7NormalAutoStealSync = function()
        if stealMode()=="Normal" and autoStealOn() then
            _G.K7NormalAutoStealStart()
        else
            _G.K7NormalAutoStealStop()
        end
    end

    _G.K7SemiSteal = _G.K7SemiSteal or {}
    local AS = _G.K7SemiSteal
    AS.enabled      = false
    AS.holdMin      = 1.3
    AS.holdMax      = 2.6
    AS.entryDelay   = 0.3
    AS.cooldown     = 0.05
    AS.primeRange   = 80
    AS.radius       = StealRadii.Semi
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
            AS.plots = workspace:WaitForChild("Plots", 10)
            local rs = game:GetService("ReplicatedStorage")
            local pkgs = rs:WaitForChild("Packages", 10)
            local datas = rs:WaitForChild("Datas", 10)
            if not (pkgs and datas and AS.plots) then return end
            AS.animalsData = require(datas:WaitForChild("Animals", 10))
            local sync = pkgs:WaitForChild("Synchronizer", 10)
            AS.channelFolder = sync:WaitForChild("Channel", 10)
            AS.routeRemote   = sync:WaitForChild("CommunicationRoute", 10)
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
            while AS.enabled and stealMode()=="Semi" and tick()-t0 < (AS.holdMin or 1.3) do
                _semiBarSet((tick()-t0)/(AS.holdMax or 2.6), "STEALING")
                task.wait()
            end
            AS.state.phase = "waitingRange"
            local alreadyInRange = _semiDistToAnimal(animalData) <= (tonumber(AS.radius) or 10)
            local fired = false
            while AS.enabled and stealMode()=="Semi" and prompt.Parent do
                local elapsed = tick()-t0
                if elapsed > (AS.holdMax or 2.6) then break end
                _semiBarSet(elapsed/(AS.holdMax or 2.6), "STEALING")
                if _semiDistToAnimal(animalData) <= (tonumber(AS.radius) or 10) then
                    if not alreadyInRange then task.wait(AS.entryDelay or 0.3) end
                    if AS.enabled and stealMode()=="Semi" then
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
                            })
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
                if AS.enabled or stealMode()=="Semi" then pcall(_semiScanAllPlots) end
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
        AS.radius  = StealRadii.Semi
        AS.enabled = true
        pcall(_semiEnsureSync)
        _semiEnsureScanThread()
        pcall(_semiScanAllPlots)
        if AS.conn then AS.conn:Disconnect(); AS.conn=nil end
        AS.conn = hubConnect(RunService.Heartbeat, LPH_NO_VIRTUALIZE(function()
            if not AS.enabled then return end
            if stealMode()~="Semi" then _G.K7SemiAutoStealStop(); return end
            if AS.state.active then return end
            local target = _semiPickClosest()
            if not target then return end
            local prompt = _semiFindPrompt(target)
            if prompt then _semiExecute(prompt, target) end
        end))
    end

    _G.K7SemiAutoStealSync = function()
        if stealMode()=="Semi" and autoStealOn() then
            _G.K7SemiAutoStealStart()
        else
            _G.K7SemiAutoStealStop()
        end
    end

    local function startAutoStealByMode()
        if not autoStealOn() then
            _G.K7NormalAutoStealStop()
            _G.K7SemiAutoStealStop()
            return
        end
        if stealMode()=="Normal" then
            _G.K7SemiAutoStealStop()
            _G.K7NormalAutoStealSync()
        else
            _G.K7NormalAutoStealStop()
            _G.K7SemiAutoStealSync()
        end
    end

    local function stopAllAutoSteal()
        _G.K7NormalAutoStealStop()
        _G.K7SemiAutoStealStop()
    end

    local function setNormalRadius(v)
        StealRadii.Normal = tonumber(v) or StealRadii.Normal
        Settings.StealRadius = StealRadii.Normal
        _G.K7NormalSteal.radius = StealRadii.Normal
    end
    local function setSemiRadius(v)
        StealRadii.Semi = tonumber(v) or StealRadii.Semi
        AS.radius = StealRadii.Semi
    end
    _G.CandyNormalAutoStealSetRadius = setNormalRadius
    _G.AceNormalAutoStealSetRadius   = setNormalRadius
    _G.CandySemiAutoStealSetRadius   = setSemiRadius
    _G.AceSemiAutoStealSetRadius     = setSemiRadius
    _G._KawatanStealAnyLive = function()
        return _G.K7NormalSteal.enabled == true or AS.enabled == true
    end

    do
        _G._RaVeRagdollStealState = _G._RaVeRagdollStealState or {}
        local RS = _G._RaVeRagdollStealState
        RS.active = false
        RS.triggered = false
        RS.startTime = 0
        RS.savedAutoSteal = nil
        RS.autoStealPaused = false

        local function ragdollStealOn()
            return _G._VynxRagdollSteal == true
        end
        local function syncStealRow()
            if _G._KRIXAutoStealSet then pcall(_G._KRIXAutoStealSet, true) end
        end
        local function pauseSteal()
            Enabled.AutoSteal = false
            pcall(stopAllAutoSteal)
        end
        local function resumeSteal()
            Enabled.AutoSteal = true
            pcall(stopAllAutoSteal)
            pcall(startAutoStealByMode)
            syncStealRow()
        end
        local function clearState(restore)
            if restore and RS.savedAutoSteal and RS.autoStealPaused then resumeSteal() end
            RS.active = false
            RS.triggered = false
            RS.startTime = 0
            RS.savedAutoSteal = nil
            RS.autoStealPaused = false
        end

        _G._CandyAutoStealIntent = function()
            if RS.autoStealPaused and RS.savedAutoSteal then return true end
            return Enabled.AutoSteal == true
        end

        _G._CandyRagdollDelays = _G._CandyRagdollDelays or { normal = 1.35, semi = 1.4 }
        local function ragdollDelay()
            local delays = _G._CandyRagdollDelays
            if stealMode() == "Semi" then return tonumber(delays.semi) or 1.4 end
            return tonumber(delays.normal) or 1.35
        end

        hubConnect(RunService.RenderStepped, LPH_NO_VIRTUALIZE(function()
            if not ragdollStealOn() then
                if RS.active then clearState(true) end
                return
            end
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum then clearState(true); return end
            local state = hum:GetState()
            local ragdolled = state == Enum.HumanoidStateType.Physics
                or state == Enum.HumanoidStateType.Ragdoll
                or state == Enum.HumanoidStateType.FallingDown
            if ragdolled and not RS.active then
                RS.active = true
                RS.triggered = false
                RS.startTime = tick()
                RS.savedAutoSteal = Enabled.AutoSteal == true
                if RS.savedAutoSteal then
                    RS.autoStealPaused = true
                    pauseSteal()
                end
            end
            if not RS.active then return end
            local elapsed = tick() - RS.startTime
            local delay = ragdollDelay()
            if elapsed >= delay and not RS.triggered then
                RS.triggered = true
                if RS.savedAutoSteal then
                    resumeSteal()
                    RS.autoStealPaused = false
                end
            elseif elapsed >= delay + 1.25 and not ragdolled then
                clearState(false)
            end
        end))
    end

    startAutoSteal = function()
        Enabled.AutoSteal = true
        Settings.AutoStealEnabled = true
        startAutoStealByMode()
    end
    stopAutoSteal = function()
        Enabled.AutoSteal = false
        Settings.AutoStealEnabled = false
        stopAllAutoSteal()
    end
    _G._VioletteStartAutoSteal = startAutoSteal
    _G._VioletteStopAutoSteal  = stopAutoSteal

    _G._VioletteAutoStealRuntime = {
        Destroy = function()
            stopAllAutoSteal()
            for _, c in ipairs(_conns) do pcall(function() c:Disconnect() end) end
            _conns = {}
            _G._VioletteAutoStealRuntime = nil
        end,
    }

    if Enabled.AutoSteal then startAutoStealByMode() end
end)()

;(function()

    local LP = LocalPlayer

    if _G._VioletteAnimPackRuntime and _G._VioletteAnimPackRuntime.Destroy then
        pcall(_G._VioletteAnimPackRuntime.Destroy)
    end

    local _conns = {}
    local function hubConnect(signal, handler)
        local c = signal:Connect(handler)
        _conns[#_conns + 1] = c
        return c
    end

    _G._VynxAnimPack  = _G._VynxAnimPack or "Off"
    _G._AdaptAnimPack = _G._VynxAnimPack

    _G._AdaptUnwalk = _G._AdaptUnwalk or { enabled = false, savedAnimate = nil }
    _G._AdaptStartUnwalk = function()
        local c = LP.Character; if not c then return end
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum then for _, t in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() t:Stop() end) end end
        local anim = c:FindFirstChild("Animate")
        if anim then _G._AdaptUnwalk.savedAnimate = anim:Clone(); anim:Destroy() end
    end
    _G._AdaptStopUnwalk = function()
        _G._AdaptUnwalk.enabled = false
        local c = LP.Character
        if c and _G._AdaptUnwalk.savedAnimate then
            _G._AdaptUnwalk.savedAnimate:Clone().Parent = c
            _G._AdaptUnwalk.savedAnimate = nil
        end
    end

    _G._AdaptTryHard = _G._AdaptTryHard or { enabled = false, conn = nil, originalAnims = nil }
    _G._AdaptApplyTryHard = function()
        local Anims = {
            idle1    = "rbxassetid://133806214992291",
            idle2    = "rbxassetid://94970088341563",
            walk     = "rbxassetid://707897309",
            run      = "rbxassetid://707861613",
            jump     = "rbxassetid://116936326516985",
            fall     = "rbxassetid://116936326516985",
            climb    = "rbxassetid://116936326516985",
            swim     = "rbxassetid://116936326516985",
            swimidle = "rbxassetid://116936326516985",
        }
        local function isPackAnim(id)
            if not id then return false end
            for _, v in pairs(Anims) do if v == id then return true end end
            return false
        end
        local function _saveOriginalAnims(char)
            local animate = char and char:FindFirstChild("Animate"); if not animate then return end
            local function g(obj) return obj and obj.AnimationId or nil end
            local ids = {
                idle1    = g(animate.idle     and animate.idle.Animation1),
                idle2    = g(animate.idle     and animate.idle.Animation2),
                walk     = g(animate.walk     and animate.walk.WalkAnim),
                run      = g(animate.run      and animate.run.RunAnim),
                jump     = g(animate.jump     and animate.jump.JumpAnim),
                fall     = g(animate.fall     and animate.fall.FallAnim),
                climb    = g(animate.climb    and animate.climb.ClimbAnim),
                swim     = g(animate.swim     and animate.swim.Swim),
                swimidle = g(animate.swimidle and animate.swimidle.SwimIdle),
            }
            if not isPackAnim(ids.walk) then _G._AdaptTryHard.originalAnims = ids end
        end
        local function _applyAnimPack(char)
            local animate = char and char:FindFirstChild("Animate"); if not animate then return end
            local function s(obj, id) if obj then obj.AnimationId = id end end
            s(animate.idle     and animate.idle.Animation1,     Anims.idle1)
            s(animate.idle     and animate.idle.Animation2,     Anims.idle2)
            s(animate.walk     and animate.walk.WalkAnim,       Anims.walk)
            s(animate.run      and animate.run.RunAnim,         Anims.run)
            s(animate.jump     and animate.jump.JumpAnim,       Anims.jump)
            s(animate.fall     and animate.fall.FallAnim,       Anims.fall)
            s(animate.climb    and animate.climb.ClimbAnim,     Anims.climb)
            s(animate.swim     and animate.swim.Swim,           Anims.swim)
            s(animate.swimidle and animate.swimidle.SwimIdle,   Anims.swimidle)
        end
        if _G._AdaptTryHard.conn then _G._AdaptTryHard.conn:Disconnect(); _G._AdaptTryHard.conn = nil end
        local char = LP.Character
        if char then
            _saveOriginalAnims(char); _applyAnimPack(char)
            local hum2 = char:FindFirstChildOfClass("Humanoid")
            if hum2 then
                for _, track in ipairs(hum2:GetPlayingAnimationTracks()) do pcall(function() track:Stop(0) end) end
                pcall(function() hum2:ChangeState(Enum.HumanoidStateType.Running) end)
            end
        end
        _G._AdaptTryHard.conn = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
            local c = LP.Character; if c then _applyAnimPack(c) end
        end))
        _G._AdaptTryHardSave = _saveOriginalAnims
        _G._AdaptTryHardApplyPack = _applyAnimPack
        saveOriginalAnims = _saveOriginalAnims
        applyAnimPack     = _applyAnimPack
    end
    _G._AdaptStopTryHard = function()
        _G._AdaptTryHard.enabled = false
        if _G._AdaptTryHard.conn then _G._AdaptTryHard.conn:Disconnect(); _G._AdaptTryHard.conn = nil end
        local char = LP.Character
        local animate = char and char:FindFirstChild("Animate")
        local orig = _G._AdaptTryHard.originalAnims
        if animate and orig then
            local function s(obj, id) if obj and id then obj.AnimationId = id end end
            s(animate.idle     and animate.idle.Animation1,     orig.idle1)
            s(animate.idle     and animate.idle.Animation2,     orig.idle2)
            s(animate.walk     and animate.walk.WalkAnim,       orig.walk)
            s(animate.run      and animate.run.RunAnim,         orig.run)
            s(animate.jump     and animate.jump.JumpAnim,       orig.jump)
            s(animate.fall     and animate.fall.FallAnim,       orig.fall)
            s(animate.climb    and animate.climb.ClimbAnim,     orig.climb)
            s(animate.swim     and animate.swim.Swim,           orig.swim)
            s(animate.swimidle and animate.swimidle.SwimIdle,   orig.swimidle)
        end
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then for _, t in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end end
    end

    _G._RaVeAnimationPackList = _G._VynxAnimPackList or {
        "Off", "Unwalk", "Try Hard",
        "Adidas Sports", "Adidas Community", "Adidas Aura", "Amazon Unboxed", "Astronaut",
        "Bubbly", "Cartoon", "Catwalk Glam", "Dancing Through Life", "Elder", "Knight",
        "Levitate", "Mage", "NFL", "Ninja", "No Boundaries", "Pirate", "Robot", "Rthro",
        "Stylish", "Superhero", "Toy", "Vampire", "Werewolf", "Wicked Popular", "Zombie",
    }
    _G._RaVeAnimationPacks = {
        Zombie={{616158929,616158929},616168032,616163682,616161997,616157476,616156119},
        Knight={{657595757,657595757},657552124,657564596,658409194,657600338,658360781},
        Elder={{845397899,845397899},845403856,845386501,845398858,845397673,845392038},
        Astronaut={{891621366,891621366},891636393,891636393,891627522,891617961,891609353},
        Pirate={{750781874,750781874},750785693,750783738,750782230,750780242,750779899},
        Toy={{782841498,782841498},782843345,782842708,782847020,782846423,782843869},
        Vampire={{1083445855,1083445855},1083473930,1083462077,1083455352,1083443587,1083439238},
        Werewolf={{1083195517,1083195517},1083178339,1083216690,1083218792,1083189019,1083182000},
        Rthro={{2510196951,2510196951},2510202577,2510198475,2510197830,2510195892,2510192778},
        Stylish={{616136790,616136790},616146177,616140816,616139451,616134815,616133594,616143378,616144772},
        ["Adidas Sports"]={{18537376492,18537371272},18537392113,18537384940,18537380791,18537367238,18537363391,18537389531,18537387180},
        ["Adidas Community"]={{122257458498464,102357151005774},122150855457006,82598234841035,75290611992385,98600215928904,88763136693023,133308483266208,109346520324160},
        ["Adidas Aura"]={{110211186840347,114191137265065},83842218823011,118320322718866,109996626521204,95603166884636,97824616490448,134530128383903,94922130551805},
        ["Wicked Popular"]={{118832222982049,76049494037641},92072849924640,72301599441680,104325245285198,121152442762481,131326830509784,99384245425157,113199415118199},
        ["Dancing Through Life"]={{92849173543269,132238900951109},73718308412641,135515454877967,78508480717326,78147885297412,129447497744818,110657013921774,129183123083281},
        ["Catwalk Glam"]={{133806214992291,94970088341563},109168724482748,81024476153754,116936326516985,92294537340807,119377220967554,134591743181628,98854111361360},
        ["No Boundaries"]={{18747067405,18747063918},18747074203,18747070484,18747069148,18747062535,18747060903,18747073181,18747071682},
        ["Amazon Unboxed"]={{98281136301627,98281136301627},90478085024465,134824450619865,121454505477205,94788218468396,121145883950231,105962919001086,129126268464847},
        NFL={{92080889861410,74451233229259},110358958299415,117333533048078,119846112151352,129773241321032,134630013742019,132697394189921,79090109939093},
        Mage={{10921144709,10921145797},10921152678,10921148209,10921149743,10921148939,10921143404,10921150788,10921151661},
        Superhero={{10921288909,10921290167},10921298616,10921291831,10921294559,10921293373,10921286911,10921295495,10921297391},
        Robot={{616088211,616089559},616095330,616091570,616090535,616087089,616086039,616092998,616094091},
        Bubbly={{910004836,910009958},910034870,910025107,910016857,910001910,909997997,910028158,910030921},
        Cartoon={{742637544,742638445},742640026,742638842,742637942,742637151,742636889,742639220,742639812},
        Ninja={{656117400,656117400},656121766,656118852,656117878,656115606,656114359,656119721,656121397},
        Levitate={{616006778,616006778},616013216,616013216,616008936,616005863,616003713,616011509,616012453},
    }
    _G._RaVeAnimationOriginals = _G._RaVeAnimationOriginals or setmetatable({}, {__mode="k"})

    _G._RaVeApplyAnimationPack = function(name)
        name = name or "Off"
        _G._AdaptAnimPack = name
        _G._VynxAnimPack  = name
        local char = LP.Character
        local animate = char and char:FindFirstChild("Animate")
        if not animate then return end
        local function ref(folder, child) local f=animate:FindFirstChild(folder); return f and f:FindFirstChild(child) end
        local refs={ref("idle","Animation1"),ref("idle","Animation2"),ref("walk","WalkAnim"),ref("run","RunAnim"),ref("jump","JumpAnim"),ref("fall","FallAnim"),ref("climb","ClimbAnim")}
        if not _G._RaVeAnimationOriginals[char] then
            local original={}
            for i,a in ipairs(refs) do original[i]=a and a.AnimationId or nil end
            _G._RaVeAnimationOriginals[char]=original
        end
        local values=_G._RaVeAnimationOriginals[char]
        local pack=_G._RaVeAnimationPacks[name]
        if pack then values={"rbxassetid://"..pack[1][1],"rbxassetid://"..pack[1][2],"rbxassetid://"..pack[2],"rbxassetid://"..pack[3],"rbxassetid://"..pack[4],"rbxassetid://"..pack[5],"rbxassetid://"..pack[6]} end
        local hum=char:FindFirstChildOfClass("Humanoid")
        if hum then for _,track in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() track:Stop(0) end) end end
        for i,a in ipairs(refs) do if a and values and values[i] then a.AnimationId=values[i] end end
        pcall(function() animate.Disabled=true; task.wait(); animate.Disabled=false end)
    end

    _G._RaVeApplySelectedAnimation = function(name)
        name = name or "Off"
        if _G._AdaptUnwalk and _G._AdaptUnwalk.enabled and name ~= "Unwalk" then
            _G._AdaptUnwalk.enabled = false
            pcall(_G._AdaptStopUnwalk)
        end
        if _G._AdaptTryHard and _G._AdaptTryHard.enabled and name ~= "Try Hard" then
            _G._AdaptTryHard.enabled = false
            pcall(_G._AdaptStopTryHard)
        end
        if name == "Unwalk" then
            _G._AdaptAnimPack = "Unwalk"; _G._VynxAnimPack = "Unwalk"
            Enabled.Unwalk = true
            if _G._AdaptUnwalk then _G._AdaptUnwalk.enabled = true end
            task.spawn(function() pcall(_G._AdaptStartUnwalk) end)
            return
        end
        Enabled.Unwalk = false
        if name == "Try Hard" then
            _G._AdaptAnimPack = "Try Hard"; _G._VynxAnimPack = "Try Hard"
            if _G._AdaptTryHard then _G._AdaptTryHard.enabled = true end
            task.spawn(function() pcall(_G._AdaptApplyTryHard) end)
            return
        end
        pcall(_G._RaVeApplyAnimationPack, name)
    end

    hubConnect(LP.CharacterAdded, function(char)
        if _G._AdaptUnwalk.enabled then task.wait(0.5); pcall(_G._AdaptStartUnwalk) end
        if _G._AdaptTryHard.enabled then
            task.wait(0.5)
            if _G._AdaptTryHardSave then pcall(_G._AdaptTryHardSave, char) end
            if _G._AdaptTryHardApplyPack then pcall(_G._AdaptTryHardApplyPack, char) end
        end
        local sel = _G._VynxAnimPack
        if sel and sel ~= "Off" and sel ~= "Unwalk" and sel ~= "Try Hard" then
            task.wait(0.2); pcall(_G._RaVeApplyAnimationPack, sel)
        end
    end)

    startUnwalk = function()
        Enabled.Unwalk = true
        _G._AdaptUnwalk.enabled = true
        _G._VynxAnimPack = "Unwalk"; _G._AdaptAnimPack = "Unwalk"
        if _G._VynxRefreshAnimPack then pcall(_G._VynxRefreshAnimPack) end
        pcall(_G._AdaptStartUnwalk)
    end
    stopUnwalk = function()
        Enabled.Unwalk = false
        pcall(_G._AdaptStopUnwalk)
        if _G._VynxAnimPack == "Unwalk" then
            _G._VynxAnimPack = "Off"; _G._AdaptAnimPack = "Off"
            if _G._VynxRefreshAnimPack then pcall(_G._VynxRefreshAnimPack) end
        end
    end

    _G._VioletteAnimPackRuntime = {
        Destroy = function()
            pcall(_G._AdaptStopTryHard)
            for _, c in ipairs(_conns) do pcall(function() c:Disconnect() end) end
            _conns = {}
            _G._VioletteAnimPackRuntime = nil
        end,
    }

    if _G._VynxAnimPack and _G._VynxAnimPack ~= "Off" then
        task.spawn(function() pcall(_G._RaVeApplySelectedAnimation, _G._VynxAnimPack) end)
    end
end)()

;(function()

    local LP = LocalPlayer

    if _G._VioletteBatAimbotRuntime and _G._VioletteBatAimbotRuntime.Destroy then
        pcall(_G._VioletteBatAimbotRuntime.Destroy)
    end

    local _conns = {}
    local function hubConnect(signal, handler)
        local c = signal:Connect(handler)
        _conns[#_conns + 1] = c
        return c
    end
    local Conns = {}

    local BAT_SLAP_LIST = {
        "Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap",
        "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap",
        "Nuclear Slap", "Galaxy Slap", "Glitched Slap",
    }

    local function findBat()
        local char = LP.Character; if not char then return nil end
        for _, name in ipairs(BAT_SLAP_LIST) do
            local t = char:FindFirstChild(name)
            if t and t:IsA("Tool") then return t end
        end
        local bp = LP:FindFirstChildOfClass("Backpack")
        if bp then
            for _, name in ipairs(BAT_SLAP_LIST) do
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
        local bp2 = LP:FindFirstChild("Backpack")
        if bp2 then for _, t in ipairs(bp2:GetChildren()) do
            if t:IsA("Tool") and (t.Name:lower():find("bat") or t.Name:lower():find("slap")) then return t end
        end end
        return nil
    end

    local BYPASS_CHASE_SPEED = 58.76
    local BYPASS_HIT_DIST    = 8
    local BYPASS_SWING_CD    = 0.15
    local bypassHitCD = false

    local function bypassSwing()
        if bypassHitCD then return end
        bypassHitCD = true
        pcall(function()
            local char = LP.Character
            if not char then return end
            local bat = findBat()
            if not bat then return end
            if bat.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            pcall(function() bat:Activate() end)

            local handle = bat:FindFirstChild("Handle")
            if not (handle and firetouchinterest) then return end
            local myHRP = char:FindFirstChild("HumanoidRootPart")
            if not myHRP then return end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
                    if tHRP and (tHRP.Position - myHRP.Position).Magnitude <= BYPASS_HIT_DIST then
                        for _, part in ipairs(plr.Character:GetChildren()) do
                            if part:IsA("BasePart") then
                                pcall(function()
                                    firetouchinterest(handle, part, 0)
                                    firetouchinterest(handle, part, 1)
                                end)
                            end
                        end
                    end
                end
            end
        end)
        task.delay(BYPASS_SWING_CD, function() bypassHitCD = false end)
    end

    local function closestPlayerRoot()
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        local best, bd = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local tr = p.Character:FindFirstChild("HumanoidRootPart")
                local hm = p.Character:FindFirstChildOfClass("Humanoid")
                if tr and hm and hm.Health > 0 then
                    local d = (tr.Position - root.Position).Magnitude
                    if d < bd then bd = d; best = tr end
                end
            end
        end
        return best
    end

    local function closestPlayerRootAndDist()
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then return nil, math.huge end
        local best, bd = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local tr = p.Character:FindFirstChild("HumanoidRootPart")
                local hm = p.Character:FindFirstChildOfClass("Humanoid")
                if tr and hm and hm.Health > 0 then
                    local d = (tr.Position - root.Position).Magnitude
                    if d < bd then bd = d; best = tr end
                end
            end
        end
        return best, bd
    end

    local AIMBOT_ATTACHMENT_NAME = "AceAimbotMoveAttachment"
    local AIMBOT_MOVER_NAME = "AceAimbotMoveVelocity"
    local function clearAimbotMoverOn(root)
        local mover = root and root:FindFirstChild(AIMBOT_MOVER_NAME)
        if mover and mover:IsA("LinearVelocity") then mover:Destroy() end
        local attachment = root and root:FindFirstChild(AIMBOT_ATTACHMENT_NAME)
        if attachment and attachment:IsA("Attachment") then attachment:Destroy() end
    end
    _G._AceClearAimbotMover = function()
        local char = LP.Character
        clearAimbotMoverOn(char and char:FindFirstChild("HumanoidRootPart"))
    end


    local function aimbotSpeed()
        if Spd.family == "lagger" then
            return tonumber(_G._VezyBatAimbotSpeedLagger) or 56.5
        elseif Spd.family == "custom" then
            return tonumber(_G._VezyBatAimbotSpeedCustom) or 56.5
        end
        return tonumber(_G._VezyBatAimbotSpeed) or 56.5
    end
    local function aimbotGateBlocked()
        if _G._VynxSafeMode ~= true then return false end
        if _G._RaVeSafeMode and _G._RaVeSafeMode.IsLocked then
            local ok, locked = pcall(_G._RaVeSafeMode.IsLocked)
            if ok then return locked == true end
        end
        return false
    end
    local function aimbotOn()
        return autoBatToggled == true or _G._VezyBatAimbotOn == true
    end
    local function swingOn()
        return autoSwingEnabled == true or _G._VezyAutoSwingEnabled == true
    end
    local function usesBypassLoop()
        return _G._VezyBatAimbotMode == "old"
    end

    -- The speed engine and the speed ESP both drive off the walk/carry profile.
    -- While the aimbot is flying the character they must use the aimbot speed
    -- for the current speed family instead, or the carry speed clamps it.
    _G._VioletteGetAimbotSpeed = function()
        if not aimbotOn() or aimbotGateBlocked() then return nil end
        local spd
        if usesBypassLoop() then
            spd = tonumber(_G._VezyBypassChaseSpeed) or aimbotSpeed()
        else
            spd = aimbotSpeed()
        end
        spd = tonumber(spd)
        if spd and spd > 0 then return spd end
        return nil
    end

    local ZBAT_SPEED        = 56
    local ZBAT_VERT_SPEED   = 52
    local ZBAT_DIST         = -2.8
    local ZBAT_HEIGHT       = 4.75
    local ZBAT_VERT_OFFSET  = 1
    local ZBAT_TURN_SPEED   = 285
    local ZBAT_MAX_TURN_RATE = 28

    local function startBatAimbot()
        _G._AdaptTPMirrorEnabled = (_G._VynxMirrorTPDown == true) or (desyncEnabled == true)
        if Conns.aimbot then Conns.aimbot:Disconnect(); Conns.aimbot = nil end
        if Conns.aimbotNew then Conns.aimbotNew:Disconnect(); Conns.aimbotNew = nil end
        _G._AdaptNormalAimbot = _G._AdaptNormalAimbot or { target = nil, swingCooldown = false }
        local aimbotState = _G._AdaptNormalAimbot
        aimbotState.target = nil
        aimbotState.swingCooldown = false
        aimbotState.equipped = false
        local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum0 then hum0.AutoRotate = false end

        Conns.aimbot = RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
            if not aimbotOn() or usesBypassLoop() then return end
            if aimbotGateBlocked() then pcall(_G._AceClearAimbotMover); return end
            local char = LP.Character
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root or not hum then return end

            if not aimbotState.equipped then
                aimbotState.equipped = true
                if not char:FindFirstChildOfClass("Tool") then
                    local b = findBat()
                    if b then pcall(function() hum:EquipTool(b) end) end
                end
            end

            local target = closestPlayerRoot()
            aimbotState.target = target
            if not target then hum.AutoRotate = true; return end

            local tv = target.AssemblyLinearVelocity or Vector3.zero
            local aimAt = target.Position
                + tv * math.clamp(tv.Magnitude / 130, 0.05, 0.15)
                + Vector3.new(0, ZBAT_VERT_OFFSET, 0)
            hum.AutoRotate = false

            local toAim = aimAt - root.Position
            local flat  = Vector3.new(toAim.X, 0, toAim.Z)
            if toAim.Magnitude > 0.01 and flat.Magnitude > 0.01 then
                local wantYaw = math.deg(math.atan2(-flat.X, -flat.Z))
                local yawErr  = (wantYaw - root.Orientation.Y + 180) % 360 - 180
                local yawVel  = math.clamp(math.rad(yawErr) * ZBAT_TURN_SPEED, -ZBAT_MAX_TURN_RATE, ZBAT_MAX_TURN_RATE)
                root.AssemblyAngularVelocity = Vector3.new(0, yawVel, 0)

                local unit  = flat.Unit
                local spot  = aimAt + unit * ZBAT_DIST + Vector3.new(0, ZBAT_HEIGHT, 0)
                local toSpot = spot - root.Position
                local spotFlat = Vector3.new(toSpot.X, 0, toSpot.Z)
                local spd   = aimbotSpeed() or ZBAT_SPEED
                local horiz = (spotFlat.Magnitude > 0.2) and (spotFlat.Unit * spd) or Vector3.zero
                local vert  = math.clamp(toSpot.Y * 2.5, -ZBAT_VERT_SPEED, ZBAT_VERT_SPEED)
                root.AssemblyLinearVelocity = Vector3.new(horiz.X, vert, horiz.Z)

                if spotFlat.Magnitude > 0.5 then hum:Move(spotFlat.Unit, false) end
            end

            local bat = char:FindFirstChildOfClass("Tool") or findBat()
            if _G._VioletteAimbotAutoSwing ~= false and bat and bat.Parent == char and not aimbotState.swingCooldown then
                aimbotState.swingCooldown = true
                pcall(function() bat:Activate() end)
                task.delay(0.08, function()
                    if _G._AdaptNormalAimbot == aimbotState then aimbotState.swingCooldown = false end
                end)
            end
        end))

        Conns.aimbotNew = RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
            if not aimbotOn() or not usesBypassLoop() then return end
            if aimbotGateBlocked() then pcall(_G._AceClearAimbotMover); return end
            local char = LP.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end

            if not char:FindFirstChildOfClass("Tool") then
                local bat = findBat()
                if bat then pcall(function() hum:EquipTool(bat) end) end
            end

            local target, targetDist = closestPlayerRootAndDist()
            aimbotState.target = target
            if not target then
                hum.AutoRotate = true
                return
            end
            hum.AutoRotate = false

            local myPos = root.Position
            local targetPos = target.Position

            local direction = targetPos - myPos
            local flatDir = Vector3.new(direction.X, 0, direction.Z)
            if flatDir.Magnitude > 0 then flatDir = flatDir.Unit else flatDir = Vector3.zero end

            local desiredHeight = targetPos.Y + 3.7
            local yVel = (desiredHeight - myPos.Y) * 19.5
            if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
            yVel = math.clamp(yVel, -70, 110)

            local chase = tonumber(_G._VezyBypassChaseSpeed) or aimbotSpeed() or BYPASS_CHASE_SPEED
            local desiredVel = Vector3.new(flatDir.X * chase, yVel, flatDir.Z * chase)
            root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)

            local toTarget = targetPos - myPos
            if toTarget.Magnitude > 0.1 then
                local goalCF = CFrame.lookAt(myPos, targetPos)
                local diffCF = root.CFrame:Inverse() * goalCF
                local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
                rx = math.clamp(rx, -2.5, 2.5)
                ry = math.clamp(ry, -2.5, 2.5)
                rz = math.clamp(rz, -2.5, 2.5)
                root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42))
            end

            if _G._VioletteAimbotAutoSwing ~= false and targetDist <= BYPASS_HIT_DIST then bypassSwing() end
        end))
    end

    local function stopBatAimbot()
        _G._AdaptTPMirrorEnabled = (desyncEnabled == true)
        if Conns.aimbot then Conns.aimbot:Disconnect(); Conns.aimbot = nil end
        if Conns.aimbotNew then Conns.aimbotNew:Disconnect(); Conns.aimbotNew = nil end
        if _G._AdaptNormalAimbot then
            _G._AdaptNormalAimbot.target = nil
            _G._AdaptNormalAimbot.swingCooldown = false
            _G._AdaptNormalAimbot.equipped = false
        end
        local c = LP.Character; if not c then return end
        local r = c:FindFirstChild("HumanoidRootPart")
        local h2 = c:FindFirstChildOfClass("Humanoid")
        if h2 then
            h2.AutoRotate = true
            h2.PlatformStand = false
            pcall(function() h2:Move(Vector3.zero, false) end)
            pcall(function() h2:ChangeState(Enum.HumanoidStateType.Running) end)
        end
        if r then
            clearAimbotMoverOn(r)
            r.Anchored = false
            r.AssemblyLinearVelocity = Vector3.zero
            r.AssemblyAngularVelocity = Vector3.zero
            if sethiddenproperty then pcall(sethiddenproperty, r, "PhysicsRepRootPart", nil) end
            local cf = r.CFrame
            local look = cf.LookVector
            local flatLook = Vector3.new(look.X, 0, look.Z)
            if flatLook.Magnitude < 0.01 then flatLook = Vector3.new(0, 0, -1) else flatLook = flatLook.Unit end
            r.CFrame = CFrame.lookAt(cf.Position, cf.Position + flatLook)
            r.AssemblyLinearVelocity = Vector3.zero
            r.AssemblyAngularVelocity = Vector3.zero
        end
        task.spawn(function()
            for i = 1, 12 do
                task.wait(0.05)
                local c2 = LP.Character; if not c2 then return end
                local r2 = c2:FindFirstChild("HumanoidRootPart")
                local h3 = c2:FindFirstChildOfClass("Humanoid")
                if h3 then
                    h3.AutoRotate = true
                    h3.PlatformStand = false
                end
                if r2 then r2.AssemblyAngularVelocity = Vector3.zero end
            end
        end)
    end

    local hitCool = false
    local function tryHitBat()
        if hitCool then return end; hitCool = true
        pcall(function()
            local bat = findBat()
            if bat then
                bat:Activate()
                local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
                if ev then ev:FireServer() end
            end
        end)
        task.delay(0.08, function() hitCool = false end)
    end

    local MIRROR_TP_DROP_THRESHOLD = 3
    local MIRROR_TP_DOWN_Y = -7.00
    local mirrorTPPreviousY = {}
    local mirrorTPLastTeleport = 0

    local function mirrorTPAimbotActive()
        return aimbotOn() or desyncEnabled == true
    end

    local function mirrorTPTeleportDown()
        local character = LP.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid or humanoid.Health <= 0 then return end
        local now = tick()
        if now - mirrorTPLastTeleport < 0.08 then return end
        mirrorTPLastTeleport = now
        local _, yaw = root.CFrame:ToEulerAnglesYXZ()
        root.CFrame = CFrame.new(root.Position.X, MIRROR_TP_DOWN_Y, root.Position.Z) * CFrame.Angles(0, yaw, 0)
        root.Velocity = Vector3.zero
        pcall(function() root.AssemblyLinearVelocity = Vector3.zero end)
    end

    local mirrorTPNextCheck = 0
    hubConnect(RunService.Heartbeat, LPH_NO_VIRTUALIZE(function()
        local now = tick()
        if now < mirrorTPNextCheck then return end
        mirrorTPNextCheck = now + 0.10
        if _G._VynxMirrorTPDown ~= true or not mirrorTPAimbotActive() then
            table.clear(mirrorTPPreviousY)
            return
        end
        local character = LP.Character
        local localRoot = character and character:FindFirstChild("HumanoidRootPart")
        if not localRoot then return end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if targetRoot and humanoid and humanoid.Health > 0 then
                    local dx = targetRoot.Position.X - localRoot.Position.X
                    local dz = targetRoot.Position.Z - localRoot.Position.Z
                    if (dx * dx + dz * dz) <= 64 then
                        local currentY = targetRoot.Position.Y
                        local previousY = mirrorTPPreviousY[player.UserId]
                        if previousY and previousY - currentY >= MIRROR_TP_DROP_THRESHOLD then
                            pcall(mirrorTPTeleportDown)
                            table.clear(mirrorTPPreviousY)
                        end
                        mirrorTPPreviousY[player.UserId] = currentY
                    else
                        mirrorTPPreviousY[player.UserId] = nil
                    end
                end
            end
        end
    end))

    _G.VezyStartBatAimbot         = startBatAimbot
    _G.VezyStopBatAimbot          = stopBatAimbot
    _G.VezyStartBatAimbotDispatch = startBatAimbot
    _G._AdaptStartBatAimbot       = startBatAimbot
    _G._AdaptStopBatAimbot        = stopBatAimbot
    _G._AdaptTryHitBat            = tryHitBat
    _G._VioletteFindBat              = findBat

    _G._VioletteBatAimbotRuntime = {
        Destroy = function()
            pcall(stopBatAimbot)
            for _, c in ipairs(_conns) do pcall(function() c:Disconnect() end) end
            _conns = {}
            _G._VioletteBatAimbotRuntime = nil
        end,
    }

    if aimbotOn() then startBatAimbot() end
end)()

;(function()

    local LP = LocalPlayer

    if _G._VioletteDropRuntime and _G._VioletteDropRuntime.Destroy then
        pcall(_G._VioletteDropRuntime.Destroy)
    end

    local _conns = {}
    local function hubConnect(signal, handler)
        local c = signal:Connect(handler)
        _conns[#_conns + 1] = c
        return c
    end

    local Drop = _G._AdaptDrop or { active = false }
    _G._AdaptDrop = Drop

    local function dropMode()
        return (_G._VynxDropType == "Stand Drop") and "STAND" or "JUMP"
    end
    local function combatLive()
        return autoBatToggled == true or _G._VezyBatAimbotOn == true
            or desyncEnabled == true
    end

    local findBat = _G._VioletteFindBat or function()
        local char = LP.Character; if not char then return nil end
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") and (t.Name:lower():find("bat") or t.Name:lower():find("slap")) then return t end
        end
        local bp = LP:FindFirstChild("Backpack")
        if bp then for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and (t.Name:lower():find("bat") or t.Name:lower():find("slap")) then return t end
        end end
        return nil
    end

    local function closestPlayerRoot()
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        local best, bd = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local tr = p.Character:FindFirstChild("HumanoidRootPart")
                local hm = p.Character:FindFirstChildOfClass("Humanoid")
                if tr and hm and hm.Health > 0 then
                    local d = (tr.Position - root.Position).Magnitude
                    if d < bd then bd = d; best = tr end
                end
            end
        end
        return best
    end

    local hitCool = false
    local function tryHitBat()
        if _G._AdaptTryHitBat then return _G._AdaptTryHitBat() end
        if hitCool then return end; hitCool = true
        pcall(function()
            local bat = findBat()
            if bat then
                bat:Activate()
                local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
                if ev then ev:FireServer() end
            end
        end)
        task.delay(0.08, function() hitCool = false end)
    end

    local JUMP_ASCEND_DURATION, JUMP_ASCEND_SPEED = 0.18, 155

    local function runDropJump()
        if Drop.active then return end
        Drop.active = true
        _G._RaVeDropToken = (_G._RaVeDropToken or 0) + 1
        local dropToken = _G._RaVeDropToken
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not root then Drop.active = false; return end
        local rayParams = _G._RaVeDropRayParams
        if not rayParams then
            rayParams = RaycastParams.new()
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            pcall(function() rayParams.RespectCanCollide = true end)
            _G._RaVeDropRayParams = rayParams
        end
        rayParams.FilterDescendantsInstances = { char }
        local initialFloor = workspace:Raycast(root.Position + Vector3.new(0, 0.35, 0), Vector3.new(0, -2000, 0), rayParams)
        if not initialFloor then Drop.active = false; return end
        local savedRotation = root.CFrame.Rotation
        local savedX, savedZ = root.Position.X, root.Position.Z
        local startedAt = tick()
        local conn
        conn = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
            local r = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if dropToken ~= _G._RaVeDropToken or not r or not hum or hum.Health <= 0 then
                conn:Disconnect()
                Drop.active = false
                return
            end
            if tick() - startedAt >= JUMP_ASCEND_DURATION then
                conn:Disconnect()
                rayParams.FilterDescendantsInstances = { char }
                local rayResult = workspace:Raycast(r.Position + Vector3.new(0, 0.35, 0), Vector3.new(0, -2000, 0), rayParams)
                local surface = rayResult or initialFloor
                if surface then
                    local offset = hum.HipHeight + (r.Size.Y * 0.5) + 0.20
                    r.CFrame = CFrame.new(savedX, surface.Position.Y + offset, savedZ) * savedRotation
                    r.AssemblyLinearVelocity = Vector3.zero
                    r.AssemblyAngularVelocity = Vector3.zero
                end
                Drop.active = false
                return
            end
            r.AssemblyLinearVelocity = Vector3.new(0, JUMP_ASCEND_SPEED, 0)
        end))
    end

    local standConns = {}
    local function runDropStand()
        if Drop.active then return end
        Drop.active = true
        local colConn = RunService.Stepped:Connect(LPH_NO_VIRTUALIZE(function()
            if not Drop.active then return end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    for _, part in ipairs(p.Character:GetChildren()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end
        end))
        table.insert(standConns, colConn)
        local thr = coroutine.create(function()
            while Drop.active do
                RunService.Heartbeat:Wait()
                local c = LP.Character
                local root = c and c:FindFirstChild("HumanoidRootPart")
                if not root then break end
                local vel = root.Velocity
                root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if root and root.Parent then root.Velocity = vel end
                RunService.Stepped:Wait()
                if root and root.Parent then root.Velocity = vel + Vector3.new(0, 0.1, 0) end
            end
        end)
        table.insert(standConns, thr)
        coroutine.resume(thr)
        task.delay(0.1, function()
            Drop.active = false
            for _, c in ipairs(standConns) do
                if typeof(c) == "RBXScriptConnection" then pcall(function() c:Disconnect() end)
                elseif type(c) == "thread" then pcall(coroutine.close, c) end
            end
            standConns = {}
        end)
    end

    local function runDrop()
        local autoTPWasOn = (_G._VynxAutoTPDownEnabled == true)
        local savedAutoTPHeight = tonumber(_G._VynxAutoTPDownHeightTrigger) or 20
        if autoTPWasOn then _G._VynxAutoTPDownEnabled = false end
        local function restoreAutoTPState()
            _G._VynxAutoTPDownHeightTrigger = savedAutoTPHeight
            if _atpBox then _atpBox.Text = tostring(savedAutoTPHeight) end
            if autoTPWasOn then _G._VynxAutoTPDownEnabled = true end
        end
        task.delay(0.75, restoreAutoTPState)

        if dropMode() == "STAND" then runDropStand() else runDropJump() end

        local target = closestPlayerRoot()
        if target and combatLive() then
            task.spawn(function()
                task.wait(0.06)
                local c = LP.Character; if not c then return end
                local r = c:FindFirstChild("HumanoidRootPart"); if not r then return end
                r.AssemblyAngularVelocity = Vector3.zero
                r.CFrame = CFrame.new(target.Position + Vector3.new(0, 0.9, 0))
                r.AssemblyLinearVelocity = Vector3.new(0, -200, 0)
                r.AssemblyAngularVelocity = Vector3.zero
                tryHitBat()
                task.wait(0.08)
                tryHitBat()
            end)
        end
    end

    runDropBrainrot      = runDrop
    _G._AdaptRunDrop     = runDrop
    _G._VynxRunDrop      = runDrop
    _G._AdaptSetDropMode = function(m)
        _G._VynxDropType = (m == "STAND" or m == "Stand Drop") and "Stand Drop" or "Jump Drop"
        if _G._VynxRefreshDropType then pcall(_G._VynxRefreshDropType) end
    end

    _G._VioletteDropRuntime = {
        Destroy = function()
            Drop.active = false
            for _, c in ipairs(_conns) do pcall(function() c:Disconnect() end) end
            _conns = {}
            _G._VioletteDropRuntime = nil
        end,
    }
end)()

;(function()

    local LP = LocalPlayer

    if _G._VioletteTPDownRuntime and _G._VioletteTPDownRuntime.Destroy then
        pcall(_G._VioletteTPDownRuntime.Destroy)
    end

    local _conns = {}
    local function hubConnect(signal, handler)
        local c = signal:Connect(handler)
        _conns[#_conns + 1] = c
        return c
    end

    _G._VynxTPDownMode = (_G._VynxTPDownMode == "half") and "half" or "full"

    local function isCarrying(char)
        if _G._CandyIsCarrying then
            local ok, res = pcall(_G._CandyIsCarrying, char)
            if ok then return res == true end
        end
        if not char then return false end
        if LP:GetAttribute("Stealing") == true or char:GetAttribute("Stealing") == true then return true end
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Tool") then
                local n = child.Name:lower()
                if not (n:find("bat") or n:find("slap")) then return true end
            end
        end
        return false
    end

    local function _runTPDownHalf()
        pcall(function()
            local c = LP.Character; if not c then return end
            local hrp = c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
            local hum = c:FindFirstChildOfClass("Humanoid"); if not hum then return end
            local rp = RaycastParams.new()
            rp.FilterDescendantsInstances = {c}
            rp.FilterType = Enum.RaycastFilterType.Exclude
            local hit = workspace:Raycast(hrp.Position, Vector3.new(0, -500, 0), rp)
            if hit then
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
                local hh = hum.HipHeight or 2
                local hy = hrp.Size.Y / 2
                hrp.CFrame = CFrame.new(hit.Position.X, hit.Position.Y + hh + hy + (TP_DOWN_OFFSET or 0.1), hit.Position.Z)
                hrp.AssemblyLinearVelocity = Vector3.zero
            end
        end)
    end

    local function _runTPDownFull()
        pcall(function()
            local c = LP.Character; if not c then return end
            local hrp = c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
            hrp.CFrame = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z)
                * CFrame.Angles(0, select(2, hrp.CFrame:ToEulerAnglesYXZ()), 0)
            hrp.AssemblyLinearVelocity = Vector3.zero
        end)
    end

    local function runTPDown()
        if _G._VynxTPDownMode == "half" then _runTPDownHalf() else _runTPDownFull() end
    end

    hubConnect(RunService.Heartbeat, LPH_NO_VIRTUALIZE(function()
        if _G._VynxAutoTPDownEnabled ~= true then return end
        local char = LP.Character; if not char then return end
        if not isCarrying(char) then return end
        local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
        local rp = RaycastParams.new()
        rp.FilterDescendantsInstances = {char}
        rp.FilterType = Enum.RaycastFilterType.Exclude
        local hit = workspace:Raycast(root.Position, Vector3.new(0, -2000, 0), rp)
        if not hit then return end
        local trigger = tonumber(_G._VynxAutoTPDownHeightTrigger) or 20
        if root.Position.Y - hit.Position.Y > trigger then runTPDown() end
    end))

    _G._VynxRunTPDown    = runTPDown
    _G._AdaptRunTPDown   = runTPDown
    _G._VynxSetTPDownMode = function(m)
        _G._VynxTPDownMode = (m == "half") and "half" or "full"
        return _G._VynxTPDownMode
    end
    _G._AdaptSetTpMode   = _G._VynxSetTPDownMode

    _G._AdaptAutoTP = setmetatable({}, {
        __index = function(_, k)
            if k == "enabled" then return _G._VynxAutoTPDownEnabled == true end
            if k == "height" then return tonumber(_G._VynxAutoTPDownHeightTrigger) or 20 end
            return nil
        end,
        __newindex = function(_, k, v)
            if k == "enabled" then _G._VynxAutoTPDownEnabled = (v == true)
            elseif k == "height" then _G._VynxAutoTPDownHeightTrigger = tonumber(v) or 20 end
        end,
    })
    _G._AdaptStartAutoTP = function() _G._VynxAutoTPDownEnabled = true end
    _G._AdaptStopAutoTP  = function() _G._VynxAutoTPDownEnabled = false end

    _G._VioletteTPDownRuntime = {
        Destroy = function()
            for _, c in ipairs(_conns) do pcall(function() c:Disconnect() end) end
            _conns = {}
            _G._VioletteTPDownRuntime = nil
        end,
    }
end)()

;(function()

    local LP = LocalPlayer

    _G._AceInstaResetState = _G._AceInstaResetState or {}
    local aceInstaResetState = _G._AceInstaResetState
    for _, connection in ipairs(aceInstaResetState.connections or {}) do
        pcall(function() connection:Disconnect() end)
    end
    if aceInstaResetState.cameraConnection then
        pcall(function() aceInstaResetState.cameraConnection:Disconnect() end)
        aceInstaResetState.cameraConnection = nil
    end
    aceInstaResetState.connections = {}
    aceInstaResetState.busy = false
    aceInstaResetState.busyAt = 0
    aceInstaResetState.queued = false
    aceInstaResetState.queuedUntil = 0
    aceInstaResetState.token = 0
    aceInstaResetState.cameraHeld = false
    aceInstaResetState.cameraHeldAt = 0
    aceInstaResetState.wantDie = nil
    aceInstaResetState.wantFling = nil
    aceInstaResetState.suspendAt = nil
    aceInstaResetState.speed = tonumber(aceInstaResetState.speed) or 1000000

    local ACE_RESET_HOLD = 1.5
    local ACE_RESET_FALLBACK = 1.2
    local ACE_RESET_WAIT = 8
    local aceResetStepOk, aceResetStepSignal = pcall(function() return RunService.PreSimulation end)
    local aceResetStep = (aceResetStepOk and aceResetStepSignal) or RunService.Heartbeat

    local function aceResetTrack(connection)
        table.insert(aceInstaResetState.connections, connection)
        return connection
    end
    local function aceResetFlingApi()
        return _G._AceAntiFling or _G._CandyAntiFling
    end
    local function aceResetSyncGuardVisuals()
        if VisualSetters and VisualSetters.AntiDie then
            pcall(VisualSetters.AntiDie, _G._VynxAntiDie == true)
        end
        local AG = _G._AceGuards or _G._CandyGuards
        if not AG then return end
        if AG.tglDie and AG.tglDie.SetVisual and type(AG.DieIsOn) == "function" then
            pcall(AG.tglDie.SetVisual, AG.DieIsOn())
        end
        if AG.tglFling and AG.tglFling.SetVisual and type(AG.FlingIsOn) == "function" then
            pcall(AG.tglFling.SetVisual, AG.FlingIsOn())
        end
    end

    local function aceResetSuspendGuards()
        if _G._VynxAntiDie == true then
            aceInstaResetState.wantDie = true
            _G._VynxAntiDie = false
        end

        local antiDie = _G._CandyAntiDie
        if antiDie and antiDie.enabled then
            aceInstaResetState.wantDie = true
            if type(_G.stopAntiDie) == "function" then pcall(_G.stopAntiDie) else antiDie.enabled = false end
        end
        local antiFling = aceResetFlingApi()
        if antiFling and type(antiFling.IsEnabled) == "function" and antiFling.IsEnabled() then
            aceInstaResetState.wantFling = true
            pcall(antiFling.SetEnabled, false)
        end
        if _G._AdaptAntiDie and _G._AdaptAntiDie.enabled and type(_G._AdaptStopAntiDie) == "function" then
            pcall(_G._AdaptStopAntiDie)
        end
        if _G._CandyAntiVoid and type(_G._CandyAntiVoid.Suspend) == "function" then
            pcall(_G._CandyAntiVoid.Suspend, 6)
        end
        aceInstaResetState.suspendAt = os.clock()
        aceResetSyncGuardVisuals()
        return {
            antiDie   = aceInstaResetState.wantDie == true,
            antiFling = aceInstaResetState.wantFling == true,
        }
    end

    local function aceResetRestoreGuards(restore)
        local wantDie = aceInstaResetState.wantDie == true or (restore and restore.antiDie == true) or false
        local wantFling = aceInstaResetState.wantFling == true or (restore and restore.antiFling == true) or false

        aceInstaResetState.suspendAt = nil
        local flingApi = aceResetFlingApi()
        if wantFling and flingApi and type(flingApi.SetEnabled) == "function" then pcall(flingApi.SetEnabled, true) end
        if wantDie then
            _G._VynxAntiDie = true
            if type(_G.startAntiDie) == "function" then pcall(_G.startAntiDie)
            elseif _G._CandyAntiDie then _G._CandyAntiDie.enabled = true end
        end
        aceResetSyncGuardVisuals()
    end

    local function aceResetHoldCamera(oldCharacter)
        local camera = workspace.CurrentCamera
        if not camera then return end
        if aceInstaResetState.cameraHeld and (os.clock() - (aceInstaResetState.cameraHeldAt or 0)) < 5 then return end
        aceInstaResetState.cameraHeld = true
        aceInstaResetState.cameraHeldAt = os.clock()
        local heldCFrame, heldFocus = camera.CFrame, camera.Focus
        local function aceResetReleaseCamera(newCharacter)
            if aceInstaResetState.cameraConnection then
                pcall(function() aceInstaResetState.cameraConnection:Disconnect() end)
                aceInstaResetState.cameraConnection = nil
            end
            local active = workspace.CurrentCamera or camera
            if active then
                pcall(function()
                    active.CameraType = Enum.CameraType.Custom
                    local humanoid = newCharacter and newCharacter:FindFirstChildOfClass("Humanoid")
                    if humanoid then active.CameraSubject = humanoid end
                end)
            end
            aceInstaResetState.cameraHeld = false
        end
        pcall(function()
            camera.CameraType = Enum.CameraType.Scriptable
            camera.CFrame = heldCFrame
            camera.Focus = heldFocus
        end)
        aceInstaResetState.cameraConnection = RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
            if workspace.CurrentCamera ~= camera then return end
            camera.CameraType = Enum.CameraType.Scriptable
            camera.CFrame = heldCFrame
            camera.Focus = heldFocus
        end))
        task.spawn(function()
            local elapsed = 0
            while LP.Character == oldCharacter and elapsed < 3 do elapsed = elapsed + task.wait() end
            local replacement = LP.Character
            if replacement == oldCharacter then replacement = nil end
            aceResetReleaseCamera(replacement)
            if not replacement then return end
            local humanoid = replacement:FindFirstChildOfClass("Humanoid") or replacement:WaitForChild("Humanoid", 3)
            local active = workspace.CurrentCamera
            if active then
                pcall(function()
                    active.CameraType = Enum.CameraType.Custom
                    if humanoid then active.CameraSubject = humanoid end
                end)
            end
        end)
    end

    local function aceResetFling(character)
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
        local function aceResetPulse()
            if not root.Parent then return false end
            return (pcall(function()
                root.AssemblyAngularVelocity = Vector3.zero
                root.AssemblyLinearVelocity = velocity
            end))
        end
        if not aceResetPulse() then return false end
        task.spawn(function()
            local elapsed = 0
            while elapsed < ACE_RESET_HOLD do
                elapsed = elapsed + aceResetStep:Wait()
                if not root.Parent then return end
                if LP.Character ~= character then return end
                aceResetPulse()
            end
        end)
        return true
    end

    local function aceResetHardKill(character)
        local hum = character and character:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        pcall(function()
            hum.PlatformStand = false
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum.BreakJointsOnDeath = true
            if hum.MaxHealth == math.huge or hum.MaxHealth <= 0 then hum.MaxHealth = 100 end
            hum.Health = 0
        end)
        pcall(function() character:BreakJoints() end)
    end

    local aceInstaReset
    local function aceResetQueue()
        aceInstaResetState.queued = true
        aceInstaResetState.queuedUntil = os.clock() + 12
    end

    aceInstaReset = function()
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not (character and humanoid and root and root:IsA("BasePart")) then aceResetQueue(); return end
        if aceInstaResetState.busy and (os.clock() - (aceInstaResetState.busyAt or 0)) < 5 then return end
        aceInstaResetState.busy = true
        aceInstaResetState.busyAt = os.clock()
        aceInstaResetState.token = aceInstaResetState.token + 1
        local token = aceInstaResetState.token
        local restore = aceResetSuspendGuards()
        task.spawn(function()
            aceResetHoldCamera(character)
            if not aceResetFling(character) then aceResetHardKill(character) end
            local elapsed = 0
            while LP.Character == character and elapsed < ACE_RESET_FALLBACK do elapsed = elapsed + task.wait() end
            if LP.Character == character then
                local hum = character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then aceResetHardKill(character) end
            end
            local waited = 0
            while LP.Character == character and waited < ACE_RESET_WAIT do waited = waited + task.wait() end
            if aceInstaResetState.token ~= token then return end
            aceInstaResetState.busy = false
            aceResetRestoreGuards(restore)
        end)
    end

    aceResetTrack(aceResetStep:Connect(function()
        local st = aceInstaResetState
        if not (st.wantDie or st.wantFling) then return end
        if st.busy and (os.clock() - (st.busyAt or 0)) < 10 then return end
        if (os.clock() - (st.suspendAt or 0)) < 12 then return end
        st.busy = false
        aceResetRestoreGuards(nil)
    end))

    aceResetTrack(LP.CharacterAdded:Connect(function(character)
        if not aceInstaResetState.queued then return end
        if os.clock() > (aceInstaResetState.queuedUntil or 0) then aceInstaResetState.queued = false; return end
        aceInstaResetState.queued = false
        task.spawn(function()
            local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
            local root = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 5)
            task.wait(0.15)
            if humanoid and root and humanoid.Health > 0 and LP.Character == character then aceInstaReset() end
        end)
    end))

    _G._AceInstaReset   = aceInstaReset
    _G._CandyInstaReset = aceInstaReset
    _G.VynxDoInstaReset = aceInstaReset

    _G._AceInstaResetTune = function(speed)
        local parsed = tonumber(speed)
        if parsed then aceInstaResetState.speed = math.clamp(math.abs(parsed), 1000, 10000000) end
        return aceInstaResetState.speed
    end
    _G._CandyInstaResetTune = _G._AceInstaResetTune
end)()

;(function()

    local LP = LocalPlayer

    if _G._VioletteCountersRuntime and _G._VioletteCountersRuntime.Destroy then
        pcall(_G._VioletteCountersRuntime.Destroy)
    end

    local _conns = {}
    local function hubConnect(signal, handler)
        local c = signal:Connect(handler)
        _conns[#_conns + 1] = c
        return c
    end

    local batApi = { Enabled = false, Connection = nil }
    if _G.VX7BatCounter and type(_G.VX7BatCounter.Stop) == "function" then
        pcall(_G.VX7BatCounter.Stop)
    end
    _G._VezyBatCounterOn = false
    local batDebounce = false
    local batLastTrigger = 0
    local BAT_TRIGGER_COOLDOWN = 0.1
    local BAT_NAMES = {
        "Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap", "Emerald Slap",
        "Ruby Slap", "Dark Matter Slap", "Flame Slap", "Nuclear Slap",
        "Galaxy Slap", "Glitched Slap",
    }

    local function batFind()
        local char = LP.Character
        if not char then return nil end
        local backpack = LP:FindFirstChildOfClass("Backpack")
        for _, name in ipairs(BAT_NAMES) do
            local tool = char:FindFirstChild(name) or (backpack and backpack:FindFirstChild(name))
            if tool then return tool end
        end
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:lower():find("bat") then return tool end
        end
        if backpack then
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") and tool.Name:lower():find("bat") then return tool end
            end
        end
        return nil
    end

    local function batNearest(fromPosition)
        local best, bestDistance = nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if root and hum and hum.Health > 0 then
                    local distance = (root.Position - fromPosition).Magnitude
                    if distance < bestDistance then
                        bestDistance = distance
                        best = player
                    end
                end
            end
        end
        return best
    end

    local function batTrigger()
        if not batApi.Enabled or batDebounce then return end
        local now = os.clock()
        if now - batLastTrigger < BAT_TRIGGER_COOLDOWN then return end
        batDebounce = true
        batLastTrigger = now
        task.spawn(function()
            local char = LP.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not char or not root or not hum then batDebounce = false; return end
            local victim = batNearest(root.Position)
            if not victim then batDebounce = false; return end
            local tool = batFind()
            if tool then
                if tool.Parent ~= char then
                    pcall(function() hum:EquipTool(tool) end)
                end
                task.wait(0.02)
            end
            char = LP.Character
            root = char and char:FindFirstChild("HumanoidRootPart")
            hum = char and char:FindFirstChildOfClass("Humanoid")
            local victimChar = victim.Character
            local victimRoot = victimChar and victimChar:FindFirstChild("HumanoidRootPart")
            if not char or not root or not hum or not victimRoot then batDebounce = false; return end
            hum.AutoRotate = false
            local victimPosition = victimRoot.Position
            local lookAt = Vector3.new(victimPosition.X, root.Position.Y, victimPosition.Z)
            if (lookAt - root.Position).Magnitude > 0.001 then
                pcall(function()
                    root.RotVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                    root.CFrame = CFrame.lookAt(root.Position, lookAt)
                end)
            end
            task.wait(0.03)
            local swing = batFind()
            if swing and swing.Parent == char then
                pcall(function()
                    swing:Activate()
                    local remote = swing:FindFirstChildWhichIsA("RemoteEvent")
                    if remote then remote:FireServer() end
                end)
            end
            task.wait(0.2)
            if root and root.Parent then
                root.RotVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end
            if hum and hum.Parent and not (autoBatToggled == true or _G._VezyBatAimbotOn == true) then
                hum.AutoRotate = true
            end
            batDebounce = false
        end)
    end

    function batApi.Start()
        batApi.Enabled = true
        if batApi.Connection then return end
        local wasRagdolled = false
        batApi.Connection = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
            if not batApi.Enabled then wasRagdolled = false; return end
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum then wasRagdolled = false; return end
            local ragdolled = hum:GetState() == Enum.HumanoidStateType.Physics
            if ragdolled and not wasRagdolled and not batDebounce then batTrigger() end
            wasRagdolled = ragdolled
        end))
    end
    function batApi.Stop()
        batApi.Enabled = false
        batDebounce = false
        if batApi.Connection then
            batApi.Connection:Disconnect()
            batApi.Connection = nil
        end
    end
    function batApi.SetEnabled(on)
        if on then batApi.Start() else batApi.Stop() end
    end

    _G.VezyStartBatCounter = function()
        _G._VezyBatCounterOn = true
        if BC then BC.enabled = true end
        batApi.Start()
    end
    _G.VezyStopBatCounter = function()
        _G._VezyBatCounterOn = false
        if BC then BC.enabled = false end
        batApi.Stop()
    end
    _G.VX7BatCounter = batApi

    local MEDUSA_COOLDOWN, medusaLastUsed = 25, 0
    local medusaDebounce = false
    local medusaAnchorConns = {}

    local function findMedusa()
        local char = LP.Character; if not char then return nil end
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                local tn = tool.Name:lower()
                if tn:find("medusa") or tn:find("head") or tn:find("stone") then return tool end
            end
        end
        local bp = LP:FindFirstChild("Backpack")
        if bp then
            for _, tool in ipairs(bp:GetChildren()) do
                if tool:IsA("Tool") then
                    local tn = tool.Name:lower()
                    if tn:find("medusa") or tn:find("head") or tn:find("stone") then return tool end
                end
            end
        end
        return nil
    end

    local function useMedusaCounter()
        if medusaDebounce then return end
        if tick() - medusaLastUsed < MEDUSA_COOLDOWN then return end
        local char = LP.Character; if not char then return end
        medusaDebounce = true
        local med = findMedusa()
        if not med then medusaDebounce = false; return end
        if med.Parent ~= char then
            local hum2 = char:FindFirstChildOfClass("Humanoid")
            if hum2 then pcall(function() hum2:EquipTool(med) end) end
        end
        pcall(function() med:Activate() end)
        medusaLastUsed = tick()
        medusaDebounce = false
    end

    local function _stopMedusaCounter()
        for _, c in pairs(medusaAnchorConns) do pcall(function() c:Disconnect() end) end
        medusaAnchorConns = {}
    end

    local function _setupMedusaCounter(char)
        _stopMedusaCounter()
        char = char or LP.Character
        if not char then return end
        local function onAnchorChanged(part)
            return part:GetPropertyChangedSignal("Anchored"):Connect(function()
                if medusaCounterEnabled and part.Anchored and part.Transparency == 1 then useMedusaCounter() end
            end)
        end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then table.insert(medusaAnchorConns, onAnchorChanged(part)) end
        end
        table.insert(medusaAnchorConns, char.DescendantAdded:Connect(function(part)
            if part:IsA("BasePart") then table.insert(medusaAnchorConns, onAnchorChanged(part)) end
        end))
    end

    setupMedusaCounter = _setupMedusaCounter
    stopMedusaCounter  = _stopMedusaCounter

    hubConnect(LP.CharacterAdded, function(char)
        task.wait(0.3)
        if medusaCounterEnabled then _setupMedusaCounter(char) end
    end)

    _G._AdaptStartMedusaCounter = function()
        medusaCounterEnabled = true
        _setupMedusaCounter(LP.Character)
    end
    _G._AdaptStopMedusaCounter = function()
        medusaCounterEnabled = false
        _stopMedusaCounter()
    end
    _G._AdaptMedusaCounterOn = function() return medusaCounterEnabled end
    _G._AdaptStartBatCounter = _G.VezyStartBatCounter
    _G._AdaptStopBatCounter  = _G.VezyStopBatCounter

    _G._VioletteCountersRuntime = {
        Destroy = function()
            batApi.Stop()
            _stopMedusaCounter()
            for _, c in ipairs(_conns) do pcall(function() c:Disconnect() end) end
            _conns = {}
            _G._VioletteCountersRuntime = nil
        end,
    }

    if medusaCounterEnabled then _setupMedusaCounter(LP.Character) end
    if _G._VezyBatCounterOn or (BC and BC.enabled) then _G.VezyStartBatCounter() end
end)()

;(function()

    local LP = LocalPlayer

    if _G._VioletteGuardsRuntime and _G._VioletteGuardsRuntime.Destroy then
        pcall(_G._VioletteGuardsRuntime.Destroy)
    end

    local _conns = {}
    local function hubConnect(signal, handler)
        local c = signal:Connect(handler)
        _conns[#_conns + 1] = c
        return c
    end

    local function dropActive()
        local d = _G._AdaptDrop
        return (d and d.active == true) or false
    end
    local function aimActive()
        return autoBatToggled == true or _G._VezyBatAimbotOn == true
            or desyncEnabled == true
    end
    local function autoPlayActive()
        if _G._VioletteAutoPathActive then
            local ok, active = pcall(_G._VioletteAutoPathActive)
            if ok then return active == true end
        end
        return false
    end

    do
        _G._AceAntiFlingState = _G._AceAntiFlingState or {}
        local st = _G._AceAntiFlingState
        if st.connection then
            pcall(function() st.connection:Disconnect() end)
            st.connection = nil
        end
        st.threshold = tonumber(st.threshold) or 80
        st.spinThreshold = tonumber(st.spinThreshold) or 40
        local DRIVE_GRACE = 0.3

        local function hubSpeedLive()
            local live = _G._RaVeLiveSpeed
            if type(live) ~= "table" then return false end
            local stamp, speed = tonumber(live.t), tonumber(live.v)
            if not stamp or not speed or speed <= 0 then return false end
            return (os.clock() - stamp) <= DRIVE_GRACE
        end
        local function isHubMover(child)
            local name = child.Name
            if not (name:match("^Ace") or name:match("^Candy") or name:match("^RaVe")
                or name:match("^VlonE") or name:match("^Vilon") or name:match("^Kawatan")
                or name:match("^InfJump")) then
                return false
            end
            if child:IsA("LinearVelocity") then
                if child.Enabled == false then return false end
                local ok, magnitude = pcall(function()
                    local mode = child.VelocityConstraintMode
                    if mode == Enum.VelocityConstraintMode.Vector then
                        return child.VectorVelocity.Magnitude
                    elseif mode == Enum.VelocityConstraintMode.Line then
                        return math.abs(child.LineVelocity)
                    end
                    return child.PlaneVelocity.Magnitude
                end)
                return ok and (tonumber(magnitude) or 0) > 1
            end
            return child:IsA("BodyVelocity") or child:IsA("BodyPosition") or child:IsA("BodyGyro")
                or child:IsA("AlignPosition") or child:IsA("AlignOrientation")
                or child:IsA("AngularVelocity") or child:IsA("VectorForce")
        end
        local function hubMoverActive(root)
            for _, child in ipairs(root:GetChildren()) do
                local ok, active = pcall(isHubMover, child)
                if ok and active then return true end
            end
            return false
        end

        st.connection = hubConnect(RunService.Heartbeat, LPH_NO_VIRTUALIZE(function()
            if _G._VynxAntiFling ~= true then return end
            local character = LP.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and (humanoid.Health <= 0 or humanoid.SeatPart) then return end
            if dropActive() or aimActive() or autoPlayActive() then return end
            if hubSpeedLive() or hubMoverActive(root) then return end
            local velocity = root.AssemblyLinearVelocity
            local flat = Vector3.new(velocity.X, 0, velocity.Z)
            if flat.Magnitude > st.threshold then
                pcall(function()
                    root.AssemblyLinearVelocity = Vector3.new(0, velocity.Y, 0)
                    root.AssemblyAngularVelocity = Vector3.zero
                end)
                return
            end
            if root.AssemblyAngularVelocity.Magnitude > st.spinThreshold then
                pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
            end
        end))

        _G._AceAntiFling = {
            SetEnabled = function(enabled)
                _G._VynxAntiFling = enabled ~= false
                if VisualSetters and VisualSetters.AntiFling then
                    pcall(VisualSetters.AntiFling, _G._VynxAntiFling)
                end
            end,
            IsEnabled = function() return _G._VynxAntiFling == true end,
            SetThreshold = function(v) st.threshold = tonumber(v) or st.threshold end,
            SetSpinThreshold = function(v) st.spinThreshold = tonumber(v) or st.spinThreshold end,
            Destroy = function()
                if st.connection then st.connection:Disconnect(); st.connection = nil end
                _G._VynxAntiFling = false
            end,
        }
        _G._CandyAntiFling = _G._AceAntiFling
    end

    local startAntiDie, stopAntiDie
    do
        local AntiDie = _G._CandyAntiDie
        if AntiDie then
            pcall(function() if AntiDie.loop then AntiDie.loop:Disconnect() end end)
            pcall(function() if AntiDie.healthConn then AntiDie.healthConn:Disconnect() end end)
            pcall(function() if AntiDie.charConn then AntiDie.charConn:Disconnect() end end)
        end
        AntiDie = {
            enabled = false, loop = nil, healthConn = nil, charConn = nil,
            lastHealTime = 0, invincibleUntil = 0,
            config = { healthThreshold = 50, invincibilityFrames = 0.75,
                fallDamageProtection = false, ragdollProtection = true, autoRevive = true },
        }

        local function _adSuperHeal(hum)
            if not hum or not hum.Parent then return end
            local maxHealth = hum.MaxHealth or 100
            if maxHealth <= 0 or maxHealth == math.huge then maxHealth = 100 end
            pcall(function()
                hum.Health = maxHealth
                if hum.MaxHealth < maxHealth then hum.MaxHealth = maxHealth end
            end)
            AntiDie.invincibleUntil = tick() + AntiDie.config.invincibilityFrames
            AntiDie.lastHealTime = tick()
            pcall(function()
                local char = hum.Parent
                if not char then return end
                for _, child in ipairs(char:GetChildren()) do
                    if child:IsA("NumberValue") then
                        local name = child.Name:lower()
                        if name:find("health") or name:find("hp") or name:find("life") then child.Value = maxHealth end
                    end
                    if child:IsA("BoolValue") and child.Name:lower():find("dead") then child.Value = false end
                end
            end)
        end

        local function _adPreventDamage(root, hum)
            if not hum then return end
            if hum.Health < (hum.MaxHealth or 100) then _adSuperHeal(hum) end
            if tick() < AntiDie.invincibleUntil then
                if hum.Health < (hum.MaxHealth or 100) then hum.Health = hum.MaxHealth or 100 end
            end
            if AntiDie.config.ragdollProtection then
                local state = hum:GetState()
                if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll
                    or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Dead then
                    pcall(function()
                        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                        hum:ChangeState(Enum.HumanoidStateType.Running)
                    end)
                    _adSuperHeal(hum)
                    if root then pcall(function() root.AssemblyAngularVelocity = Vector3.zero end) end
                end
            end
            if hum.Health <= 0 then
                _adSuperHeal(hum)
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end)
                if root then
                    pcall(function()
                        root.CFrame = CFrame.new(root.Position + Vector3.new(0, 2, 0))
                        root.AssemblyLinearVelocity = Vector3.zero
                    end)
                end
            end
        end

        local function _adAutoRevive()
            if not AntiDie.config.autoRevive then return end
            local char = LP.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            if not hum then return end
            if hum.Health <= 0 then
                _adSuperHeal(hum)
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end)
                if root then
                    pcall(function()
                        root.CFrame = CFrame.new(root.Position + Vector3.new(0, 3, 0))
                        root.AssemblyLinearVelocity = Vector3.zero
                    end)
                end
            end
        end

        local function _adAttachHealth(char)
            if AntiDie.healthConn then AntiDie.healthConn:Disconnect(); AntiDie.healthConn = nil end
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum then hum = char and char:WaitForChild("Humanoid", 3) end
            if not hum then return end
            AntiDie.healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
                if not AntiDie.enabled then return end
                if hum.Health < (hum.MaxHealth or 100) then _adSuperHeal(hum) end
                if hum.Health <= 0 then _adAutoRevive() end
            end)
            if hum.Health < (hum.MaxHealth or 100) then _adSuperHeal(hum) end
        end

        startAntiDie = function()
            _G._VynxAntiDie = true
            if AntiDie.enabled and AntiDie.loop then return end
            AntiDie.enabled = true
            if AntiDie.loop then AntiDie.loop:Disconnect(); AntiDie.loop = nil end
            if AntiDie.healthConn then AntiDie.healthConn:Disconnect(); AntiDie.healthConn = nil end
            AntiDie.loop = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
                if not AntiDie.enabled then return end
                local char = LP.Character
                if not char then return end
                local hum = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                if not hum then return end
                if hum.Health <= 0 then _adAutoRevive()
                elseif hum.Health <= AntiDie.config.healthThreshold then _adSuperHeal(hum)
                elseif hum.Health < (hum.MaxHealth or 100) then _adSuperHeal(hum) end
                _adPreventDamage(root, hum)
            end))
            if LP.Character then _adAttachHealth(LP.Character) end
            if AntiDie.charConn then AntiDie.charConn:Disconnect(); AntiDie.charConn = nil end
            AntiDie.charConn = LP.CharacterAdded:Connect(function(char)
                if not AntiDie.enabled then return end
                task.wait(0.05)
                _adAttachHealth(char)
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then _adSuperHeal(hum) end
            end)
        end

        stopAntiDie = function()
            _G._VynxAntiDie = false
            AntiDie.enabled = false
            if AntiDie.loop then AntiDie.loop:Disconnect(); AntiDie.loop = nil end
            if AntiDie.healthConn then AntiDie.healthConn:Disconnect(); AntiDie.healthConn = nil end
            if AntiDie.charConn then AntiDie.charConn:Disconnect(); AntiDie.charConn = nil end
            pcall(function()
                local char = LP.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if not hum then return end
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                hum.BreakJointsOnDeath = true
                if hum.MaxHealth == math.huge or hum.MaxHealth <= 0 then
                    hum.MaxHealth = 100
                    hum.Health = math.min(hum.Health, 100)
                end
            end)
        end

        _G._CandyAntiDie = AntiDie
        _G.startAntiDie  = startAntiDie
        _G.stopAntiDie   = stopAntiDie

        local lastDie = nil
        hubConnect(RunService.Heartbeat, LPH_NO_VIRTUALIZE(function()
            local want = _G._VynxAntiDie == true
            if want == lastDie then return end
            lastDie = want
            if want then startAntiDie() else stopAntiDie() end
        end))
    end

    do
        local SafeMode = {
            Enabled = false, Actions = {}, _connections = {}, _running = false, _lastCheck = 0,
            _state = { countdown = false, holding = false, timerPhase = "unknown", timerStartUsed = false,
                timerRoundSeen = false, timerSawInactive = false, timerInactiveSince = nil },
        }
        _G._CandySafeMode = SafeMode

        local SafeGui = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui")
        local CARRY_MARKERS = { Stealing = true, Carrying = true, IsCarrying = true, HoldingBrainrot = true, HasBrainrot = true }
        local safeGuarded = { "Bat Aimbot", "Auto Swing" }

        local function safeDisconnect(connection)
            if connection then pcall(function() connection:Disconnect() end) end
        end

        local safeTimerLabel = nil
        local function safeResolveTimerLabel()
            if safeTimerLabel and safeTimerLabel.Parent then return safeTimerLabel end
            safeTimerLabel = nil
            local top = SafeGui:FindFirstChild("DuelsMachineTopFrame", true)
            local timer = top and top:FindFirstChild("Timer", true)
            local label = timer and timer:FindFirstChild("Label", true)
            if label and label:IsA("TextLabel") then safeTimerLabel = label end
            return safeTimerLabel
        end

        function SafeMode:IsHoldingBrainrotFast()
            for marker in pairs(CARRY_MARKERS) do
                if LP:GetAttribute(marker) == true then return true end
            end
            local character = LP.Character
            if not character then return false end
            for marker in pairs(CARRY_MARKERS) do
                if character:GetAttribute(marker) == true then return true end
            end
            return false
        end

        function SafeMode:IsHoldingBrainrot()
            for marker in pairs(CARRY_MARKERS) do
                if LP:GetAttribute(marker) == true then return true end
            end
            local character = LP.Character
            if not character then return false end
            for marker in pairs(CARRY_MARKERS) do
                if character:GetAttribute(marker) == true then return true end
                local value = character:FindFirstChild(marker, true)
                if value and value:IsA("BoolValue") and value.Value then return true end
            end
            return false
        end

        function SafeMode:IsRoundCountdownActive()
            local state = self._state
            local function inactive()
                state.timerInactiveSince = state.timerInactiveSince or os.clock()
                if os.clock() - state.timerInactiveSince >= 0.75 then
                    state.timerPhase = "inactive"
                    state.timerStartUsed = false
                    state.timerRoundSeen = false
                    state.timerSawInactive = true
                end
                return false
            end
            local label = safeResolveTimerLabel()
            if not label then return inactive() end
            local node = label
            while node and node ~= SafeGui do
                if node:IsA("GuiObject") and not node.Visible then return inactive() end
                if node:IsA("ScreenGui") and not node.Enabled then return inactive() end
                node = node.Parent
            end
            local text = tostring(label.Text or ""):upper():gsub("<.->", ""):gsub("%s+", "")
            state.timerInactiveSince = nil
            if text == "READY" or text == "STARTING" or text == "GETREADY" then
                state.timerPhase, state.timerStartUsed, state.timerRoundSeen = "starting", true, false
                return true
            end
            if text == "GO" or text == "FIGHT" then
                state.timerPhase, state.timerStartUsed, state.timerRoundSeen = "round", true, true
                return false
            end
            local minutes, seconds = text:match("^(%d+):(%d+)$")
            if minutes and seconds then
                local total = tonumber(minutes) * 60 + tonumber(seconds)
                if total <= 0 then
                    state.timerPhase, state.timerStartUsed, state.timerRoundSeen, state.timerSawInactive = "inactive", false, false, true
                else
                    state.timerPhase, state.timerStartUsed, state.timerRoundSeen = "round", true, true
                end
                return false
            end
            local number = tonumber(text)
            if not number then return false end
            if number > 10 then
                state.timerPhase, state.timerStartUsed, state.timerRoundSeen = "round", true, true
                return false
            end
            if number <= 0 then
                if state.timerRoundSeen then
                    state.timerPhase, state.timerStartUsed, state.timerRoundSeen, state.timerSawInactive = "inactive", false, false, true
                end
                return false
            end
            if state.timerRoundSeen or (state.timerStartUsed and state.timerPhase ~= "starting") then return false end
            if state.timerPhase == "starting" then return true end
            if not state.timerStartUsed and state.timerSawInactive then
                state.timerPhase, state.timerStartUsed, state.timerSawInactive = "starting", true, false
                return true
            end
            return false
        end

        function SafeMode:GetBlockReason()
            if not self.Enabled then return nil end
            if self._state.countdown then return "ROUND COUNTDOWN" end
            if self._state.holding then return "BRAINROT HELD" end
            return nil
        end

        function SafeMode:BindAction(name, getter, setter, conflicts)
            self.Actions[name] = { get = getter, set = setter, conflicts = conflicts or {} }
        end
        function SafeMode:_disable(action)
            local entry = self.Actions[action]
            if entry then pcall(entry.set, false) end
        end
        function SafeMode:Request(action, wantsOn)
            local entry = self.Actions[action]
            if not entry then return false, "UNBOUND ACTION" end
            if wantsOn ~= true then self:_disable(action); return true end
            local reason = self:GetBlockReason()
            if reason then self:_disable(action); return false, reason end
            for _, other in ipairs(entry.conflicts) do self:_disable(other) end
            entry.set(true)
            return true
        end
        function SafeMode:Toggle(action)
            local entry = self.Actions[action]
            return entry and self:Request(action, not entry.get()) or false
        end

        function SafeMode:Evaluate()
            local state = self._state
            local countdown = self:IsRoundCountdownActive()
            local holding = self:IsHoldingBrainrot()
            state.countdown, state.holding = countdown, holding
            self.Enabled = (_G._VynxSafeMode == true)
            if not self.Enabled then return end
            local reason = self:GetBlockReason()
            if not reason then return end
            for action, entry in pairs(self.Actions) do
                if entry.get() then self:_disable(action) end
            end
        end

        function SafeMode:SetEnabled(enabled)
            _G._VynxSafeMode = enabled == true
            self.Enabled = _G._VynxSafeMode
            if VisualSetters and VisualSetters.SafeMode then
                pcall(VisualSetters.SafeMode, self.Enabled)
            end
            if self.Enabled then
                self._state.countdown, self._state.holding = false, false
                self:Evaluate()
            end
        end

        function SafeMode:_watchCarryState()
            local function evaluateSoon()
                task.defer(function()
                    if SafeMode._running and _G._VynxSafeMode == true then
                        pcall(function() SafeMode:Evaluate() end)
                    end
                end)
            end
            for marker in pairs(CARRY_MARKERS) do
                self._connections["player_" .. marker] = LP:GetAttributeChangedSignal(marker):Connect(evaluateSoon)
            end
            local function watchCharacter(character)
                for key, connection in pairs(self._connections) do
                    if key:sub(1, 5) == "char_" then
                        safeDisconnect(connection)
                        self._connections[key] = nil
                    end
                end
                if not character then return end
                for marker in pairs(CARRY_MARKERS) do
                    self._connections["char_attr_" .. marker] = character:GetAttributeChangedSignal(marker):Connect(evaluateSoon)
                end
                self._connections.char_added = character.DescendantAdded:Connect(function(item)
                    if item:IsA("Tool") or CARRY_MARKERS[item.Name] then evaluateSoon() end
                end)
                self._connections.char_removed = character.DescendantRemoving:Connect(function(item)
                    if item:IsA("Tool") or CARRY_MARKERS[item.Name] then evaluateSoon() end
                end)
            end
            self._connections.character = hubConnect(LP.CharacterAdded, function(character)
                watchCharacter(character)
                evaluateSoon()
            end)
            watchCharacter(LP.Character)
        end

        function SafeMode:Start()
            if self._running then return self end
            self._running = true
            self:_watchCarryState()
            self._connections.monitor = hubConnect(RunService.Heartbeat, LPH_NO_VIRTUALIZE(function()
                if _G._VynxSafeMode ~= true or os.clock() - SafeMode._lastCheck < 0.1 then return end
                SafeMode._lastCheck = os.clock()
                pcall(function() SafeMode:Evaluate() end)
            end))
            self.Enabled = (_G._VynxSafeMode == true)
            if self.Enabled then self:Evaluate() end
            return self
        end

        SafeMode:BindAction("Bat Aimbot",
            function() return autoBatToggled == true or _G._VezyBatAimbotOn == true end,
            function(on)
                autoBatToggled = on and true or false
                _G._VezyBatAimbotOn = autoBatToggled
                if on then
                    if _G.VezyStartBatAimbotDispatch then pcall(_G.VezyStartBatAimbotDispatch) end
                else
                    if _G.VezyStopBatAimbot then pcall(_G.VezyStopBatAimbot) end
                end
                if VisualSetters and VisualSetters.AutoBat then pcall(VisualSetters.AutoBat, autoBatToggled) end
            end)


        SafeMode:BindAction("Auto Swing",
            function() return autoSwingEnabled == true or _G._VezyAutoSwingEnabled == true end,
            function(on)
                autoSwingEnabled = on and true or false
                _G._VezyAutoSwingEnabled = autoSwingEnabled
                if VisualSetters and VisualSetters.AutoSwing then pcall(VisualSetters.AutoSwing, autoSwingEnabled) end
            end)

        local safeGateAt, safeGateValue = 0, false
        local function safeGateBlocked()
            if _G._VynxSafeMode ~= true then return false end
            local now = os.clock()
            if now - safeGateAt < 0.015 then return safeGateValue end
            safeGateAt = now
            local state = SafeMode._state
            local countdown, holding = false, false
            pcall(function() countdown = SafeMode:IsRoundCountdownActive() end)
            pcall(function() holding = SafeMode:IsHoldingBrainrotFast() or state.holding == true end)
            state.countdown, state.holding = countdown, holding
            safeGateValue = countdown or holding
            return safeGateValue
        end
        local function safeForceStop()
            for _, name in ipairs(safeGuarded) do
                local entry = SafeMode.Actions[name]
                if entry and entry.get() then SafeMode:_disable(name) end
            end
        end

        SafeMode.IsLocked = safeGateBlocked
        SafeMode.GateBlocked = safeGateBlocked
        SafeMode.ForceStop = safeForceStop
        _G._CandySafeIsLocked = safeGateBlocked
        _G._CandySafeGateBlocked = safeGateBlocked
        _G._CandySafeForceStop = safeForceStop

        _G._RaVeSafeMode = {
            IsLocked = safeGateBlocked,
            SetEnabled = function(on) SafeMode:SetEnabled(on) end,
            HoldingBrainrot = function() return SafeMode:IsHoldingBrainrot() end,
            ForceStop = safeForceStop,
            GetBlockReason = function() return SafeMode:GetBlockReason() end,
        }
        SafeMode:Start()
    end

    do
        local KW = {
            enabled = _G._VynxKickWarning == true,
            active = false,
            wasLow = false,
            generation = 0,
            gui = nil,
            connection = nil,
        }
        _G._VioletteKickWarningState = KW

        local function destroyWarning()
            KW.generation = KW.generation + 1
            KW.active = false
            if KW.gui then pcall(function() KW.gui:Destroy() end); KW.gui = nil end
        end

        local function showWarning()
            if KW.active or not KW.enabled then return end
            KW.active = true
            KW.generation = KW.generation + 1
            local myGeneration = KW.generation
            local DURATION = 2.35
            local FRAME_W, FRAME_H = 420, 52
            local parent = (gui and gui.Parent) or LP:FindFirstChildOfClass("PlayerGui")
            if not parent then KW.active = false; return end

            local warningGui = Instance.new("ScreenGui")
            warningGui.Name = "VioletteKickWarning"
            warningGui.ResetOnSpawn = false
            warningGui.IgnoreGuiInset = true
            warningGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            warningGui.DisplayOrder = 99999
            warningGui.Parent = parent
            KW.gui = warningGui

            local frame = Instance.new("Frame")
            frame.Name = "WarningFrame"
            frame.Size = UDim2.new(0, FRAME_W, 0, FRAME_H)
            frame.Position = UDim2.new(0.5, -FRAME_W / 2, 0, -60)
            frame.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
            frame.BorderSizePixel = 0
            frame.ClipsDescendants = true
            frame.Parent = warningGui
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
            local edge = Instance.new("UIStroke", frame)
            edge.Color = Color3.fromRGB(255, 80, 80)
            edge.Thickness = 2
            edge.Transparency = 0.12

            local fill = Instance.new("Frame")
            fill.Name = "FillFrame"
            fill.Size = UDim2.new(0, 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(28, 165, 78)
            fill.BorderSizePixel = 0
            fill.ZIndex = 2
            fill.Parent = frame
            Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 12)

            local icon = Instance.new("TextLabel")
            icon.Name = "WarningIcon"
            icon.Size = UDim2.new(0, 38, 1, 0)
            icon.Position = UDim2.new(0, 8, 0, 0)
            icon.BackgroundTransparency = 1
            icon.Text = "!"
            icon.TextColor3 = Color3.fromRGB(255, 255, 255)
            icon.Font = Enum.Font.GothamBlack
            icon.TextSize = 28
            icon.TextXAlignment = Enum.TextXAlignment.Center
            icon.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            icon.TextStrokeTransparency = 0.2
            icon.ZIndex = 3
            icon.Parent = frame

            local text = Instance.new("TextLabel")
            text.Name = "WarningText"
            text.Size = UDim2.new(1, -58, 1, 0)
            text.Position = UDim2.new(0, 52, 0, 0)
            text.BackgroundTransparency = 1
            text.Text = "DONT COLLECT"
            text.TextColor3 = Color3.fromRGB(255, 255, 255)
            text.Font = Enum.Font.GothamBlack
            text.TextSize = 16
            text.TextXAlignment = Enum.TextXAlignment.Left
            text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            text.TextStrokeTransparency = 0.2
            text.ZIndex = 3
            text.Parent = frame

            TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, -FRAME_W / 2, 0, 18)
            }):Play()

            task.spawn(function()
                local started = tick()
                while KW.active and KW.generation == myGeneration and warningGui.Parent do
                    local char = LP.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if not hum or hum.WalkSpeed >= 25 then break end
                    local progress = math.clamp((tick() - started) / DURATION, 0, 1)
                    fill.Size = UDim2.new(progress, 0, 1, 0)
                    if progress >= 1 then break end
                    task.wait()
                end
                if KW.generation ~= myGeneration or not warningGui.Parent then return end
                TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Position = UDim2.new(0.5, -FRAME_W / 2, 0, -60),
                    BackgroundTransparency = 1,
                }):Play()
                TweenService:Create(text, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
                TweenService:Create(icon, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
                task.wait(0.35)
                if KW.generation == myGeneration then
                    pcall(function() warningGui:Destroy() end)
                    KW.gui = nil
                    KW.active = false
                end
            end)
        end

        _G._VioletteKickWarningSet = function(on)
            KW.enabled = on == true
            _G._VynxKickWarning = KW.enabled
            if not KW.enabled then
                destroyWarning()
            else
                local char = LP.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                KW.wasLow = hum and hum.WalkSpeed < 25 or false
            end
        end
        _G._VioletteDestroyKickWarning = destroyWarning

        KW.connection = hubConnect(RunService.Heartbeat, LPH_NO_VIRTUALIZE(function()
            if KW.enabled ~= (_G._VynxKickWarning == true) then
                _G._VioletteKickWarningSet(_G._VynxKickWarning == true)
            end
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            if _G._RaVeSafeMode and _G._RaVeSafeMode.IsLocked then
                local ok, locked = pcall(_G._RaVeSafeMode.IsLocked)
                if ok and locked then
                    if KW.active then destroyWarning() end
                    KW.wasLow = false
                    return
                end
            end
            local low = hum.WalkSpeed < 25
            if not KW.enabled then
                KW.wasLow = low
                return
            end
            if low ~= KW.wasLow then
                KW.wasLow = low
                if low then showWarning() end
            end
        end))

        _G._VioletteKickWarningRuntime = {
            Destroy = function()
                destroyWarning()
                if KW.connection then pcall(function() KW.connection:Disconnect() end); KW.connection = nil end
                _G._VioletteKickWarningRuntime = nil
            end,
        }
        _G._VioletteKickWarningSet(KW.enabled)
    end

    do
        local AG = _G._AceGuards or {}
        _G._AceGuards = AG
        _G._CandyGuards = AG
        AG.autoDie = false
        AG.autoFling = false
        AG.prevAim = false
        AG.last = 0

        local function guardFlingApi()
            return _G._AceAntiFling or _G._CandyAntiFling
        end
        local function guardBusy()
            local st = _G._AceInstaResetState
            return (st and st.busy and (os.clock() - (st.busyAt or 0)) < 10) or false
        end

        function AG.DieIsOn()
            local antiDie = _G._CandyAntiDie
            return (antiDie and antiDie.enabled == true and antiDie.loop ~= nil) or false
        end
        function AG.SetDie(on)
            on = on and true or false
            local antiDie = _G._CandyAntiDie
            local st = _G._AceInstaResetState
            if st then st.wantDie = nil end
            if on then
                if antiDie and antiDie.enabled and not antiDie.loop then antiDie.enabled = false end
                if type(_G.startAntiDie) == "function" then pcall(_G.startAntiDie)
                elseif antiDie then antiDie.enabled = true end
            else
                if type(_G.stopAntiDie) == "function" then pcall(_G.stopAntiDie)
                elseif antiDie then antiDie.enabled = false end
            end
            if VisualSetters and VisualSetters.AntiDie then pcall(VisualSetters.AntiDie, AG.DieIsOn()) end
        end

        function AG.FlingIsOn()
            local api = guardFlingApi()
            return (api and type(api.IsEnabled) == "function" and api.IsEnabled() == true) or false
        end
        function AG.SetFling(on)
            on = on and true or false
            local api = guardFlingApi()
            if api and type(api.SetEnabled) == "function" then pcall(api.SetEnabled, on) end
            if VisualSetters and VisualSetters.AntiFling then pcall(VisualSetters.AntiFling, on) end
        end

        function AG.AimOn()
            return aimActive()
        end

        function AG.Sync()
            if guardBusy() then return end
            local aim = AG.AimOn()
            if aim then
                if not AG.DieIsOn() then AG.autoDie = true; AG.SetDie(true) end
                if not AG.FlingIsOn() then AG.autoFling = true; AG.SetFling(true) end
            elseif AG.prevAim then
                if AG.autoDie then AG.autoDie = false; AG.SetDie(false) end
                if AG.autoFling then AG.autoFling = false; AG.SetFling(false) end
            end
            AG.prevAim = aim
            if VisualSetters and VisualSetters.AntiDie then pcall(VisualSetters.AntiDie, AG.DieIsOn()) end
            if VisualSetters and VisualSetters.AntiFling then pcall(VisualSetters.AntiFling, AG.FlingIsOn()) end
        end

        if AG.watch then pcall(function() AG.watch:Disconnect() end); AG.watch = nil end
        AG.watch = hubConnect(RunService.Heartbeat, LPH_NO_VIRTUALIZE(function()
            local now = os.clock()
            if now - AG.last < 0.15 then return end
            AG.last = now
            AG.Sync()
        end))
        AG.Sync()
    end

    _G._VioletteGuardsRuntime = {
        Destroy = function()
            pcall(function() if _G._AceAntiFling then _G._AceAntiFling.Destroy() end end)
            pcall(function() if _G.stopAntiDie then _G.stopAntiDie() end end)
            for _, c in ipairs(_conns) do pcall(function() c:Disconnect() end) end
            _conns = {}
            _G._VioletteGuardsRuntime = nil
        end,
    }

    if _G._VynxAntiDie == true then startAntiDie() end
end)()


;(function()

    _G._AdaptSkyOrder = _G._VezySkyThemeNames or {
        "Off","Crimson","Neon City","Amethyst","Golden Hour","Frost Moon","Rose Gold",
        "Abyss","Matrix","Candy","Retro Sun","Night","Aurora","Sunset","Galaxy","Cyber",
        "Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic",
        "Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven",
        "Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky",
    }

    _G._AdaptSkyPresets = {
        ["Off"]={kind="off"},
        ["Crimson"]={clock=20.5,brightness=2.1,ambient={160,50,60},outAmb={180,60,70},sky={stars=2500,moon=16,sun=0,moonTex=true},atm={dens=0.55,color={232,52,68},decay={130,20,35},glare=1.6,haze=2.2},clouds={cover=0.45,dens=0.6,color={150,40,55}}},
        ["Neon City"]={clock=21.5,brightness=2.3,ambient={110,90,170},outAmb={120,100,180},sky={stars=3000,moon=14},atm={dens=0.5,color={90,240,255},decay={255,40,180},glare=2.4,haze=2.6},clouds={cover=0.35,dens=0.55,color={130,110,220}}},
        ["Amethyst"]={clock=19,brightness=2.4,ambient={150,110,200},outAmb={160,120,210},sky={stars=1800,moon=18,sun=0},atm={dens=0.45,color={170,110,255},decay={90,50,170},glare=1.5,haze=1.9},clouds={cover=0.5,dens=0.5,color={190,150,255}}},
        ["Golden Hour"]={clock=17.6,brightness=3,ambient={230,180,110},outAmb={240,190,120},sky={sun=24,stars=0,moon=0},atm={dens=0.42,color={255,200,90},decay={255,150,60},glare=2.6,haze=2},clouds={cover=0.45,dens=0.45,color={255,225,170}}},
        ["Frost Moon"]={clock=23.5,brightness=1.9,ambient={140,170,210},outAmb={150,180,220},sky={stars=5500,moon=26,sun=0,moonTex=true},atm={dens=0.4,color={150,200,255},decay={70,110,180},glare=0.8,haze=1.4}},
        ["Rose Gold"]={clock=7,brightness=2.9,ambient={230,170,150},outAmb={240,180,160},sky={sun=18,stars=0,moon=0},atm={dens=0.38,color={255,170,150},decay={230,130,110},glare=2,haze=1.8},clouds={cover=0.5,dens=0.4,color={255,215,200}}},
        ["Abyss"]={clock=0.5,brightness=1.1,ambient={40,50,70},outAmb={50,60,80},sky={stars=9000,moon=10,sun=0},atm={dens=0.7,color={10,25,50},decay={0,10,30},glare=0.2,haze=2.8}},
        ["Matrix"]={clock=22,brightness=1.8,ambient={70,150,80},outAmb={80,160,90},sky={stars=4000,moon=12,sun=0},atm={dens=0.55,color={30,220,70},decay={10,110,30},glare=1.2,haze=2.4},clouds={cover=0.55,dens=0.7,color={40,110,55}}},
        ["Candy"]={clock=12.5,brightness=3.4,ambient={220,170,210},outAmb={230,180,220},sky={sun=12,stars=0},atm={dens=0.35,color={255,170,230},decay={170,200,255},glare=1.8,haze=1.7},clouds={cover=0.65,dens=0.45,color={255,235,250}}},
        ["Retro Sun"]={clock=18.2,brightness=2.5,ambient={210,110,150},outAmb={220,120,160},sky={sun=30,stars=800,moon=0},atm={dens=0.5,color={255,90,140},decay={120,40,200},glare=3,haze=2.6},clouds={cover=0.3,dens=0.5,color={255,150,190}}},
        ["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
        ["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,160},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
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
        ["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.5,dens=0.55,color={200,150,255}}},
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

    _G._AdaptSkyMode = _G._VezyCustomSkyMode or _G._AdaptSkyMode or "Off"

    _G._AdaptClearSky = function()
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:GetAttribute("_AdaptSky") then pcall(function() v:Destroy() end) end
        end
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            for _, v in ipairs(terrain:GetChildren()) do
                if v:GetAttribute("_AdaptSky") then pcall(function() v:Destroy() end) end
            end
        end
    end

    _G._AdaptStartSky = function(mode)
        _G._AdaptClearSky()
        local L = Lighting
        mode = mode or _G._AdaptSkyMode or "Off"
        local preset = _G._AdaptSkyPresets[mode]
        local c3 = function(t) return Color3.fromRGB(t[1], t[2], t[3]) end
        if not preset or preset.kind == "off" then
            pcall(function()
                L.FogEnd = 100000; L.FogStart = 0; L.FogColor = Color3.fromRGB(192, 192, 192)
                L.Brightness = 2; L.ClockTime = 14; L.GlobalShadows = true
                L.Ambient = Color3.fromRGB(0, 0, 0); L.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
            end)
            _G._AdaptSkyMode = "Off"; _G._VezyCustomSkyMode = "Off"
            return
        end
        pcall(function()
            L.FogEnd = 100000; L.FogStart = 0; L.FogColor = Color3.fromRGB(200, 200, 200)
            L.ColorShift_Top = Color3.fromRGB(0, 0, 0); L.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
            L.GlobalShadows = true; L.ClockTime = preset.clock or 14; L.Brightness = preset.brightness or 2
            if preset.outAmb  then L.OutdoorAmbient = c3(preset.outAmb) end
            if preset.ambient then L.Ambient        = c3(preset.ambient) end
        end)
        if preset.sky then
            pcall(function()
                local sky = Instance.new("Sky"); sky:SetAttribute("_AdaptSky", true)
                if preset.sky.stars then sky.StarCount = preset.sky.stars end
                if preset.sky.moon  then sky.MoonAngularSize = preset.sky.moon end
                if preset.sky.sun   then sky.SunAngularSize  = preset.sky.sun end
                if preset.sky.moonTex then sky.MoonTextureId = "rbxasset://sky/moon.jpg" end
                sky.Parent = L
            end)
        end
        if preset.atm then
            pcall(function()
                local atm = Instance.new("Atmosphere"); atm:SetAttribute("_AdaptSky", true)
                atm.Density = preset.atm.dens or 0.3
                atm.Color = c3(preset.atm.color); atm.Decay = c3(preset.atm.decay)
                atm.Glare = preset.atm.glare or 1; atm.Haze = preset.atm.haze or 1
                atm.Parent = L
            end)
        end
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if preset.clouds and terrain then
            pcall(function()
                local clouds = Instance.new("Clouds"); clouds:SetAttribute("_AdaptSky", true)
                clouds.Cover = preset.clouds.cover or 0.5
                clouds.Density = preset.clouds.dens or 0.5
                clouds.Color = c3(preset.clouds.color); clouds.Parent = terrain
            end)
        end
        _G._AdaptSkyMode = mode
        _G._VezyCustomSkyMode = mode
    end

    _G._AdaptStopSky = function()
        _G._AdaptClearSky()
        pcall(function()
            Lighting.ClockTime = 14; Lighting.Brightness = 2
            Lighting.Ambient = Color3.fromRGB(0, 0, 0)
            Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        end)
        _G._AdaptSkyMode = "Off"
        _G._VezyCustomSkyMode = "Off"
    end

    _G._AdaptSkyApply = _G._AdaptStartSky
    _G._AdaptSkyClear = _G._AdaptStopSky

    _G.VezyApplyCustomSky = function(mode)
        _G._VezyCustomSkyMode = mode or "Off"
        _G._AdaptStartSky(_G._VezyCustomSkyMode)
        if _G._VezyRefreshSkyTheme then pcall(_G._VezyRefreshSkyTheme) end
    end

    if _G._VezyCustomSkyMode and _G._VezyCustomSkyMode ~= "Off" then
        pcall(_G._AdaptStartSky, _G._VezyCustomSkyMode)
    end
end)()

;(function()

    local LP = LocalPlayer

    if _G._VioletteVisualRuntime and _G._VioletteVisualRuntime.Destroy then
        pcall(_G._VioletteVisualRuntime.Destroy)
    end

    local _conns = {}
    local function hubConnect(signal, handler)
        local c = signal:Connect(handler)
        _conns[#_conns + 1] = c
        return c
    end

    local Util = _G._AdaptUtil or { antilag = false, potato = false, shiny = false,
        stretch = false, fov = false }
    _G._AdaptUtil = Util

    do
        if _G._AdaptAntiLagDescConn then
            pcall(function() _G._AdaptAntiLagDescConn:Disconnect() end)
        end
        _G._AdaptAntiLagDescConn = nil
        _G._AdaptAntiLagScanToken = {}
        if type(_G._AdaptAntiLagHiddenObstacleVolumes) == "table" then
            for part in pairs(_G._AdaptAntiLagHiddenObstacleVolumes) do
                pcall(function() if part and part.Parent then part.LocalTransparencyModifier = 0 end end)
            end
        end

        local defaults, terrainDefaults = {}, {}
        local active, descConn = false, nil
        local queue, queueHead, queueTail, queueRunning = {}, 1, 0, false
        local hiddenObstacleVolumes = {}
        _G._AdaptAntiLagHiddenObstacleVolumes = hiddenObstacleVolumes

        local function isBaseObstacleVolume(obj)
            if not obj:IsA("BasePart") then return false end
            local events = workspace:FindFirstChild("Events")
            if not events or not obj:IsDescendantOf(events) then return false end
            local parent = obj.Parent
            while parent and parent ~= events do
                if parent.Name == "ObstacleVolumes" then return true end
                parent = parent.Parent
            end
            return false
        end

        local function apply(obj)
            pcall(function()
                if obj:IsA("BasePart") then
                    if isBaseObstacleVolume(obj) then
                        if hiddenObstacleVolumes[obj] == nil then
                            hiddenObstacleVolumes[obj] = obj.LocalTransparencyModifier
                        end
                        obj.LocalTransparencyModifier = 1
                    end
                    obj.Material = Enum.Material.Plastic
                    obj.Reflectance = 0
                    obj.CastShadow = false
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = 1
                elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
                    or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                    obj.Enabled = false
                elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                    obj.Enabled = false
                elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
                    for _, track in ipairs(obj:GetPlayingAnimationTracks()) do
                        pcall(function() track:Stop(0) end)
                    end
                end
            end)
        end

        local function queueObject(obj)
            if not active or not obj then return end
            queueTail = queueTail + 1
            queue[queueTail] = obj
            if queueRunning then return end
            queueRunning = true
            local token = _G._AdaptAntiLagScanToken
            task.spawn(function()
                while active and token == _G._AdaptAntiLagScanToken and queueHead <= queueTail do
                    local remaining = queueTail - queueHead + 1
                    for _ = 1, math.min(80, remaining) do
                        local nextObject = queue[queueHead]
                        queue[queueHead] = nil
                        queueHead = queueHead + 1
                        if nextObject then apply(nextObject) end
                    end
                    task.wait()
                end
                if queueHead > queueTail then queue, queueHead, queueTail = {}, 1, 0 end
                queueRunning = false
            end)
        end

        _G._AdaptStartAntiLag = function()
            active = true
            queue, queueHead, queueTail = {}, 1, 0
            _G._AdaptAntiLagScanToken = {}
            local scanToken = _G._AdaptAntiLagScanToken

            defaults.Brightness = defaults.Brightness or Lighting.Brightness
            defaults.FogEnd = defaults.FogEnd or Lighting.FogEnd
            defaults.FogStart = defaults.FogStart or Lighting.FogStart
            defaults.Diffuse = defaults.Diffuse or Lighting.EnvironmentDiffuseScale
            defaults.Specular = defaults.Specular or Lighting.EnvironmentSpecularScale
            defaults.Ambient = defaults.Ambient or Lighting.Ambient

            pcall(function()
                Lighting.GlobalShadows = false
                Lighting.FogEnd = 1e10
                Lighting.FogStart = 1e10
                Lighting.EnvironmentDiffuseScale = 0
                Lighting.EnvironmentSpecularScale = 0
                Lighting.Brightness = 1.5
                Lighting.Ambient = Color3.fromRGB(60, 60, 60)
            end)

            pcall(function()
                local terrain = workspace.Terrain
                terrainDefaults.Decoration = terrainDefaults.Decoration ~= nil and terrainDefaults.Decoration or terrain.Decoration
                terrainDefaults.WaterWaveSize = terrainDefaults.WaterWaveSize or terrain.WaterWaveSize
                terrainDefaults.WaterWaveSpeed = terrainDefaults.WaterWaveSpeed or terrain.WaterWaveSpeed
                terrainDefaults.WaterReflectance = terrainDefaults.WaterReflectance or terrain.WaterReflectance
                terrainDefaults.WaterTransparency = terrainDefaults.WaterTransparency or terrain.WaterTransparency
                terrain.Decoration = false
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end)
            pcall(function()
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
                settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
            end)
            for _, effect in ipairs(Lighting:GetChildren()) do
                pcall(function()
                    if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("ColorCorrectionEffect")
                        or effect:IsA("BloomEffect") or effect:IsA("DepthOfFieldEffect") then
                        effect.Enabled = false
                    end
                end)
            end
            task.spawn(function()
                for index, obj in ipairs(workspace:GetDescendants()) do
                    if not active or scanToken ~= _G._AdaptAntiLagScanToken then return end
                    apply(obj)
                    if index % 200 == 0 then task.wait() end
                end
            end)
            if descConn then descConn:Disconnect() end
            descConn = workspace.DescendantAdded:Connect(function(obj)
                if active then queueObject(obj) end
            end)
            _G._AdaptAntiLagDescConn = descConn
        end

        _G._AdaptStopAntiLag = function()
            active = false
            _G._AdaptAntiLagScanToken = {}
            queue, queueHead, queueTail = {}, 1, 0
            if descConn then descConn:Disconnect(); descConn = nil end
            _G._AdaptAntiLagDescConn = nil
            for part, originalTransparency in pairs(hiddenObstacleVolumes) do
                pcall(function()
                    if part and part.Parent then part.LocalTransparencyModifier = originalTransparency end
                end)
            end
            table.clear(hiddenObstacleVolumes)
            pcall(function()
                Lighting.GlobalShadows = true
                if defaults.Brightness ~= nil then Lighting.Brightness = defaults.Brightness end
                if defaults.FogEnd ~= nil then Lighting.FogEnd = defaults.FogEnd end
                if defaults.FogStart ~= nil then Lighting.FogStart = defaults.FogStart end
                if defaults.Diffuse ~= nil then Lighting.EnvironmentDiffuseScale = defaults.Diffuse end
                if defaults.Specular ~= nil then Lighting.EnvironmentSpecularScale = defaults.Specular end
                if defaults.Ambient ~= nil then Lighting.Ambient = defaults.Ambient end
                local terrain = workspace.Terrain
                if terrainDefaults.Decoration ~= nil then terrain.Decoration = terrainDefaults.Decoration end
                if terrainDefaults.WaterWaveSize ~= nil then terrain.WaterWaveSize = terrainDefaults.WaterWaveSize end
                if terrainDefaults.WaterWaveSpeed ~= nil then terrain.WaterWaveSpeed = terrainDefaults.WaterWaveSpeed end
                if terrainDefaults.WaterReflectance ~= nil then terrain.WaterReflectance = terrainDefaults.WaterReflectance end
                if terrainDefaults.WaterTransparency ~= nil then terrain.WaterTransparency = terrainDefaults.WaterTransparency end
                for _, effect in ipairs(Lighting:GetChildren()) do
                    pcall(function()
                        if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("ColorCorrectionEffect")
                            or effect:IsA("BloomEffect") or effect:IsA("DepthOfFieldEffect") then
                            effect.Enabled = true
                        end
                    end)
                end
            end)
        end
    end

    do
        _G._AdaptStartVisualStrip = function()
            if _G._AdaptVisualStripOn then return end
            _G._AdaptVisualStripOn = true
            _G._AdaptVisualStripConnections = _G._AdaptVisualStripConnections or {}
            for _, conn in ipairs(_G._AdaptVisualStripConnections) do pcall(function() conn:Disconnect() end) end
            _G._AdaptVisualStripConnections = {}

            local function isBrainrotVisual(obj)
                local heldTool = obj:FindFirstAncestorOfClass("Tool")
                if heldTool and LP.Character and obj:IsDescendantOf(LP.Character)
                    and LP:GetAttribute("Stealing") == true then
                    return true
                end
                for _, player in ipairs(Players:GetPlayers()) do
                    if player.Character and obj:IsDescendantOf(player.Character) then return false end
                end
                local current = obj
                local inAnimalPodiums, animatedModel = false, false
                for _ = 1, 10 do
                    if not current then break end
                    local name = string.lower(current.Name or "")
                    if string.find(name, "brainrot", 1, true) then return true end
                    if name == "animalpodiums" then inAnimalPodiums = true end
                    if current:IsA("Model") and (current:FindFirstChildOfClass("AnimationController")
                        or current:FindFirstChildOfClass("Animator")) then
                        animatedModel = true
                    end
                    current = current.Parent
                end
                return inAnimalPodiums and animatedModel
            end

            local function strip(obj)
                if not _G._AdaptVisualStripOn then return end
                pcall(function()
                    local brainrotVisual = isBrainrotVisual(obj)
                    if obj:IsA("BasePart") then
                        if not brainrotVisual then
                            obj.Material = Enum.Material.SmoothPlastic
                            obj.MaterialVariant = ""
                        end
                        obj.Reflectance = 0
                        obj.CastShadow = false
                        local partName = string.lower(obj.Name or "")
                        if obj:FindFirstChildWhichIsA("Light", true) or string.find(partName, "light", 1, true)
                            or string.find(partName, "lamp", 1, true) then
                            obj.LocalTransparencyModifier = 1
                        end
                        if obj:FindFirstAncestorOfClass("Accessory") then
                            obj.LocalTransparencyModifier = 1
                        end
                    elseif obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("CharacterMesh") then
                        obj:Destroy()
                    elseif obj:IsA("FaceControls") then
                        obj:Destroy()
                    elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("SurfaceAppearance") then
                        if not brainrotVisual then obj:Destroy() end
                    elseif obj:IsA("SpecialMesh") then
                        if not brainrotVisual then obj.TextureId = "" end
                    elseif obj:IsA("Animator") then
                        local model = obj:FindFirstAncestorOfClass("Model")
                        if not (model and Players:GetPlayerFromCharacter(model)) then
                            for _, track in ipairs(obj:GetPlayingAnimationTracks()) do
                                pcall(function() track:Stop(0); track:AdjustSpeed(0) end)
                            end
                            table.insert(_G._AdaptVisualStripConnections, obj.AnimationPlayed:Connect(function(track)
                                if _G._AdaptVisualStripOn then pcall(function() track:Stop(0); track:AdjustSpeed(0) end) end
                            end))
                        end
                    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Smoke")
                        or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Highlight") then
                        if obj.Name ~= "AdaptESP_HL" then obj:Destroy() end
                    elseif obj:IsA("Light") then
                        local sourcePart = obj:FindFirstAncestorWhichIsA("BasePart")
                        if sourcePart then sourcePart.LocalTransparencyModifier = 1 end
                        obj:Destroy()
                    elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                        obj.Image = ""
                    elseif obj:IsA("Sky") or obj:IsA("Atmosphere") or obj:IsA("Clouds") or obj:IsA("PostEffect") then
                        if not obj:GetAttribute("_AdaptSky") then obj:Destroy() end
                    end
                end)
            end

            pcall(function()
                Lighting.GlobalShadows = false
                Lighting.EnvironmentDiffuseScale = 0
                Lighting.EnvironmentSpecularScale = 0
                Lighting.FogStart = 1e9
                Lighting.FogEnd = 1e9
                local terrain = workspace:FindFirstChildOfClass("Terrain")
                if terrain then
                    terrain.Decoration = false
                    terrain.WaterWaveSize = 0
                    terrain.WaterWaveSpeed = 0
                    terrain.WaterReflectance = 0
                    terrain.WaterTransparency = 1
                end
                for _, effect in ipairs(Lighting:GetDescendants()) do strip(effect) end
            end)

            task.spawn(function()
                for index, obj in ipairs(workspace:GetDescendants()) do
                    if not _G._AdaptVisualStripOn then return end
                    strip(obj)
                    if index % 200 == 0 then task.wait() end
                end
            end)
            table.insert(_G._AdaptVisualStripConnections, workspace.DescendantAdded:Connect(function(obj)
                task.defer(strip, obj)
            end))
            table.insert(_G._AdaptVisualStripConnections, Lighting.DescendantAdded:Connect(function(obj)
                task.defer(strip, obj)
            end))
        end

        _G._AdaptStopVisualStrip = function()
            _G._AdaptVisualStripOn = false
            for _, conn in ipairs(_G._AdaptVisualStripConnections or {}) do pcall(function() conn:Disconnect() end) end
            _G._AdaptVisualStripConnections = {}
        end
    end

    local _stretchConn, _fovConn

    local function startStretch()
        Util.stretch = true
        if _stretchConn then _stretchConn:Disconnect(); _stretchConn = nil end
        _G._VynxStretchValue = math.clamp(tonumber(_G._VynxStretchValue) or 0.70, 0.3, 1.0)
        _stretchConn = RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
            if not Util.stretch then return end
            local cam = workspace.CurrentCamera
            if not cam then return end
            local value = math.clamp(tonumber(_G._VynxStretchValue) or 0.70, 0.3, 1.0)
            pcall(function()
                local wantFov = math.clamp(tonumber(_G._VezyStretchFOV) or 120, 70, 120)
                if cam.FieldOfView ~= wantFov then cam.FieldOfView = wantFov end
                cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, value, 0, 0, 0, 1)
            end)
        end))
    end
    local function stopStretch()
        Util.stretch = false
        if _stretchConn then _stretchConn:Disconnect(); _stretchConn = nil end
        pcall(function() workspace.CurrentCamera.FieldOfView = 70 end)
    end

    local function startFov()
        Util.fov = true
        if _fovConn then _fovConn:Disconnect(); _fovConn = nil end
        _fovConn = RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
            if not Util.fov then return end
            local c = workspace.CurrentCamera
            local want = math.clamp(tonumber(_G._VezyCustomFOV) or 120, 70, 120)
            if c and c.FieldOfView ~= want then pcall(function() c.FieldOfView = want end) end
        end))
    end
    local function stopFov()
        Util.fov = false
        if _fovConn then _fovConn:Disconnect(); _fovConn = nil end
        pcall(function() workspace.CurrentCamera.FieldOfView = 70 end)
    end

    _G.VezyEnableFOV          = startFov
    _G.VezyDisableFOV         = stopFov
    _G._VynxEnableStretchRez  = startStretch
    _G._VynxDisableStretchRez = stopStretch

    local function setNoCamCollision(on)
        pcall(function()
            LP.DevCameraOcclusionMode = on and Enum.DevCameraOcclusionMode.Invisicam
                or Enum.DevCameraOcclusionMode.Zoom
        end)
    end
    enableNoCameraCollision  = function() setNoCamCollision(true)  end
    disableNoCameraCollision = function() setNoCamCollision(false) end

    local function setHeadless(character, enabled)
        local head = character and character:FindFirstChild("Head")
        if not head then return end
        local transparency = enabled and 1 or 0
        head.Transparency = transparency
        head.LocalTransparencyModifier = transparency
        for _, object in ipairs(head:GetChildren()) do
            if object:IsA("Decal") or object:IsA("Texture") or object:IsA("BasePart") then
                object.Transparency = transparency
                if object:IsA("BasePart") then object.LocalTransparencyModifier = transparency end
            end
        end
    end
    _G._KawatanSetHeadless = setHeadless

    _G._RaVeKorbloxMode = _G._RaVeKorbloxMode or "Off"
    _G._RaVeKorbloxAssets = {
        ["Left Leg"] = {
            id = "rbxassetid://139607673",
            targetBodyPart = "LeftUpperLeg",
            partsToHide = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot"},
            scale = Vector3.new(1, 1, 1),
            audio = "rbxassetid://87998522263554",
            offset = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0),
        },
        ["Right Leg"] = {
            id = "rbxassetid://139607718",
            targetBodyPart = "RightUpperLeg",
            partsToHide = {"RightUpperLeg", "RightLowerLeg", "RightFoot"},
            scale = Vector3.new(1, 1, 1),
            audio = "rbxassetid://135315310485417",
            offset = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0),
        },
    }

    _G._RaVeClearKorblox = function()
        local character = LP.Character
        if not character then return end
        for _, name in ipairs({
            "Korblox_LeftLeg", "Korblox_RightLeg",
            "RaVeKorblox_Left", "RaVeKorblox_Right",
        }) do
            local old = character:FindFirstChild(name)
            if old then pcall(function() old:Destroy() end) end
        end
        for _, name in ipairs({
            "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
            "RightUpperLeg", "RightLowerLeg", "RightFoot",
        }) do
            local limb = character:FindFirstChild(name)
            if limb and limb:IsA("BasePart") then
                limb.Transparency = 0
                limb.LocalTransparencyModifier = 0
            end
        end
    end

    _G._RaVeAttachKorblox = function(itemName)
        local config = _G._RaVeKorbloxAssets[itemName]
        local character = LP.Character
        if not config or not character then return false, "No character" end
        local targetPart = character:FindFirstChild(config.targetBodyPart)
        if not targetPart then return false, "Target part missing" end

        local oldAsset = character:FindFirstChild("Korblox_" .. itemName:gsub("%s+", ""))
        if oldAsset then oldAsset:Destroy() end

        for _, partName in ipairs(config.partsToHide) do
            local limb = character:FindFirstChild(partName)
            if limb and limb:IsA("BasePart") then
                limb.Transparency = 1
            end
        end

        local success, objects = pcall(function() return game:GetObjects(config.id) end)
        if not success or not objects or #objects == 0 then
            return false, "Asset fetch failed"
        end
        local assetModel = objects[1]
        assetModel.Name = "Korblox_" .. itemName:gsub("%s+", "")
        local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
        if not mainMesh then
            pcall(function() assetModel:Destroy() end)
            return false, "No MeshPart in asset"
        end

        mainMesh.Size = mainMesh.Size * config.scale
        mainMesh.CanCollide = false
        mainMesh.CanTouch = false
        mainMesh.CanQuery = false
        mainMesh.Massless = true
        mainMesh.CFrame = targetPart.CFrame * config.offset
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = targetPart
        weld.Part1 = mainMesh
        weld.Parent = mainMesh
        assetModel.Parent = character

        if config.audio then
            local sound = Instance.new("Sound")
            sound.SoundId = config.audio
            sound.Volume = 0.5
            sound.Parent = mainMesh
            sound:Play()
            game:GetService("Debris"):AddItem(sound, 3)
        end
        return true, nil
    end

    _G._RaVeApplyKorblox = function(mode)
        if mode == "Left Leg" then mode = "Left" elseif mode == "Right Leg" then mode = "Right" end
        mode = (mode == "Left" or mode == "Right" or mode == "Both") and mode or "Off"
        _G._RaVeClearKorblox()
        _G._RaVeKorbloxMode = mode
        if mode == "Left" or mode == "Both" then pcall(_G._RaVeAttachKorblox, "Left Leg") end
        if mode == "Right" or mode == "Both" then pcall(_G._RaVeAttachKorblox, "Right Leg") end
    end

    local startShiny, stopShiny
    do
        _G.AceShinyGraphics = _G.AceShinyGraphics
            or { shinyEnabled = false, runtimeOn = false, shinyConns = {}, shinyOriginals = {} }
        local SH = _G.AceShinyGraphics
        for _, conn in ipairs(SH.shinyConns or {}) do pcall(function() conn:Disconnect() end) end
        SH.shinyConns = {}
        SH.shinyOriginals = SH.shinyOriginals or {}
        SH.runtimeOn = false
        SH.shinyEnabled = false

        local function shinePart(obj)
            pcall(function()
                if obj:IsA("BasePart") then
                    SH.shinyOriginals[obj] = SH.shinyOriginals[obj]
                        or { Material = obj.Material, Reflectance = obj.Reflectance, CastShadow = obj.CastShadow }
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.Reflectance = 0.75
                    obj.CastShadow = false
                end
            end)
        end
        local function effect(class, name)
            local inst = Lighting:FindFirstChild(name)
            if inst and not inst:IsA(class) then
                pcall(function() inst:Destroy() end)
                inst = nil
            end
            if not inst then
                inst = Instance.new(class)
                inst.Name = name
                inst.Parent = Lighting
            end
            return inst
        end
        local function applyEffects()
            local bloom = effect("BloomEffect", "AceShinyBloom")
            bloom.Intensity, bloom.Size, bloom.Threshold, bloom.Enabled = 1.6, 52, 0.75, true
            local rays = effect("SunRaysEffect", "AceShinySunRays")
            rays.Intensity, rays.Spread, rays.Enabled = 0.55, 1, true
            local cc = effect("ColorCorrectionEffect", "AceShinyColorCorrection")
            cc.Saturation, cc.Contrast, cc.Brightness, cc.Enabled = 0.9, 0.22, 0.07, true
        end

        startShiny = function()
            Util.shiny = true
            SH.shinyEnabled = true
            if SH.runtimeOn then pcall(applyEffects); return end
            SH.runtimeOn = true
            for _, obj in ipairs(workspace:GetDescendants()) do shinePart(obj) end
            for _, conn in ipairs(SH.shinyConns) do pcall(function() conn:Disconnect() end) end
            SH.shinyConns = {}
            table.insert(SH.shinyConns, workspace.DescendantAdded:Connect(function(obj)
                if SH.shinyEnabled then shinePart(obj) end
            end))
            pcall(applyEffects)
        end

        stopShiny = function()
            Util.shiny = false
            SH.shinyEnabled = false
            SH.runtimeOn = false
            for _, conn in ipairs(SH.shinyConns) do pcall(function() conn:Disconnect() end) end
            SH.shinyConns = {}
            for obj, saved in pairs(SH.shinyOriginals) do
                pcall(function()
                    obj.Material = saved.Material
                    obj.Reflectance = saved.Reflectance
                    obj.CastShadow = saved.CastShadow
                end)
            end
            SH.shinyOriginals = {}
            for _, name in ipairs({"AceShinyBloom", "AceShinySunRays", "AceShinyColorCorrection"}) do
                local inst = Lighting:FindFirstChild(name)
                if inst then pcall(function() inst:Destroy() end) end
            end
        end
    end

    do
        _G._RaVeDarkMode = _G._RaVeDarkMode or { enabled = false, saved = nil }
        if type(_G._RaVeDarkLevel) ~= "number" then _G._RaVeDarkLevel = 2 end

        _G._RaVeSetDarkLevel = function(value)
            _G._RaVeDarkLevel = math.clamp(tonumber(value) or 2, 0.5, 6)
            if _G._RaVeDarkMode and _G._RaVeDarkMode.enabled then
                pcall(function() Lighting.ExposureCompensation = -_G._RaVeDarkLevel end)
            end
        end

        _G._RaVeSetDarkMode = function(on)
            local state = _G._RaVeDarkMode
            if on == true then
                if not state.saved then
                    state.saved = {
                        brightness = Lighting.Brightness,
                        clock = Lighting.ClockTime,
                        outdoor = Lighting.OutdoorAmbient,
                        exposure = Lighting.ExposureCompensation,
                    }
                end
                state.enabled = true
                pcall(function()
                    local sky = Lighting:FindFirstChild("RaVeDarkModeSky")
                    if not sky or not sky:IsA("Sky") then
                        if sky then sky:Destroy() end
                        sky = Instance.new("Sky")
                        sky.Name = "RaVeDarkModeSky"
                    end
                    sky.SkyboxBk = "rbxassetid://159454299"
                    sky.SkyboxDn = "rbxassetid://159454296"
                    sky.SkyboxFt = "rbxassetid://159454293"
                    sky.SkyboxLf = "rbxassetid://159454286"
                    sky.SkyboxRt = "rbxassetid://159454289"
                    sky.SkyboxUp = "rbxassetid://159454291"
                    sky.Parent = Lighting
                    Lighting.Brightness = 0
                    Lighting.ClockTime = 0
                    Lighting.ExposureCompensation = -(_G._RaVeDarkLevel or 2)
                    Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
                end)
                return
            end
            state.enabled = false
            pcall(function()
                local sky = Lighting:FindFirstChild("RaVeDarkModeSky")
                if sky then sky:Destroy() end
                local saved = state.saved
                if saved then
                    Lighting.Brightness = saved.brightness
                    Lighting.ClockTime = saved.clock
                    Lighting.ExposureCompensation = saved.exposure
                    Lighting.OutdoorAmbient = saved.outdoor
                end
            end)
            state.saved = nil
        end
    end

    do
        _G._AdaptESPColor = _G._VioletteAccent or ACC
        _G._AdaptESPEnabled = _G._VynxAuraESP == true
        _G._AdaptESPShowBox = _G._VynxBoxedESP == true
        if type(_G._AdaptESPBoxFill) ~= "number" then _G._AdaptESPBoxFill = 0.72 end
        _G._AdaptESPShowTracer = _G._VynxShowTracker == true

        local espData = {}
        local espSG = Instance.new("ScreenGui")
        espSG.Name = "AdaptESP_Visual"
        espSG.ResetOnSpawn = false
        espSG.IgnoreGuiInset = true
        espSG.DisplayOrder = -1000
        pcall(function() espSG.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
        if not espSG.Parent then espSG.Parent = LP:WaitForChild("PlayerGui") end

        local function attachHL(player, char)
            if not char then return end
            local old = char:FindFirstChild("AdaptESP_HL"); if old then old:Destroy() end
            local col = _G._AdaptESPColor
            local hl = Instance.new("Highlight")
            hl.Name = "AdaptESP_HL"
            hl.FillColor = col; hl.OutlineColor = col
            hl.FillTransparency = 0.4; hl.OutlineTransparency = 1
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Enabled = _G._AdaptESPEnabled
            hl.Adornee = char; hl.Parent = char
            return hl
        end

        local function buildVisuals(player)
            local col = _G._AdaptESPColor
            local box = Instance.new("Frame", espSG)
            box.Name = "ESP_BOX_" .. player.Name
            box.BackgroundColor3 = col
            box.BackgroundTransparency = 1
            box.BorderSizePixel = 0
            box.Visible = false; box.ZIndex = 9999
            local boxSt = Instance.new("UIStroke", box)
            boxSt.Color = col; boxSt.Thickness = 1.5
            boxSt.Transparency = 0.1
            boxSt.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            local tracer = Instance.new("Frame", espSG)
            tracer.Name = "ESP_TRACER_" .. player.Name
            tracer.AnchorPoint = Vector2.new(0.5, 0.5)
            tracer.BackgroundColor3 = col
            tracer.BackgroundTransparency = 0.05
            tracer.BorderSizePixel = 0; tracer.Visible = false; tracer.ZIndex = 9998

            local offscreen = Instance.new("TextLabel", espSG)
            offscreen.Name = "ESP_DIRECTION_" .. player.Name
            offscreen.AnchorPoint = Vector2.new(0.5, 0.5)
            offscreen.Size = UDim2.fromOffset(24, 24)
            offscreen.BackgroundTransparency = 1
            offscreen.Text = utf8.char(0x25B2)
            offscreen.TextColor3 = col
            offscreen.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            offscreen.TextStrokeTransparency = 0.1
            offscreen.Font = Enum.Font.GothamBlack
            offscreen.TextSize = 21
            offscreen.Visible = false
            offscreen.ZIndex = 10002

            return box, tracer, offscreen
        end

        local function refreshESPColor(newColor)
            _G._AdaptESPColor = newColor
            for _, d in pairs(espData) do
                if d.box then
                    local st = d.box:FindFirstChildOfClass("UIStroke")
                    if st then st.Color = newColor end
                    d.box.BackgroundColor3 = newColor
                end
                if d.tracer then d.tracer.BackgroundColor3 = newColor end
                if d.offscreen then d.offscreen.TextColor3 = newColor end
                if d.hl then d.hl.FillColor = newColor; d.hl.OutlineColor = newColor end
            end
        end
        _G._AdaptRefreshESPColor = refreshESPColor

        local function createForPlayer(player)
            if player == LP then return end
            if espData[player] then return end
            local box, tracer, offscreen = buildVisuals(player)
            local d = {box=box, tracer=tracer, offscreen=offscreen, hl=nil}
            espData[player] = d
            if player.Character then d.hl = attachHL(player, player.Character) end
            d.charConn = player.CharacterAdded:Connect(function(char)
                task.wait(0.4)
                d.hl = attachHL(player, char)
            end)
        end
        local function clearPlayer(player)
            local d = espData[player]; if not d then return end
            if d.charConn then pcall(function() d.charConn:Disconnect() end) end
            for _, key in ipairs({"box", "tracer", "offscreen", "hl"}) do
                if d[key] then pcall(function() d[key]:Destroy() end) end
            end
            espData[player] = nil
        end

        hubConnect(Players.PlayerAdded, createForPlayer)
        hubConnect(Players.PlayerRemoving, clearPlayer)

        task.spawn(function()
            while espSG.Parent do
                task.wait(2)
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LP then
                        if not espData[p] then
                            pcall(createForPlayer, p)
                        else
                            local d = espData[p]
                            local char = p.Character
                            if char and (not d.hl or d.hl.Parent ~= char) then
                                pcall(function() if d.hl then d.hl:Destroy() end end)
                                d.hl = attachHL(p, char)
                            end
                        end
                    end
                end
            end
        end)

        hubConnect(RunService.RenderStepped, LPH_NO_VIRTUALIZE(function()
            local cam = workspace.CurrentCamera; if not cam then return end
            local boxOn    = _G._AdaptESPShowBox == true
            local tracerOn = _G._AdaptESPShowTracer == true
            local on = boxOn or tracerOn
            local viewSize = cam.ViewportSize
            local startX, startY
            local myChar = LP.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then
                local myScr = cam:WorldToViewportPoint(myHRP.Position + Vector3.new(0, -0.5, 0))
                if myScr.Z > 0 then
                    startX = math.clamp(myScr.X, 10, viewSize.X - 10)
                    startY = math.clamp(myScr.Y, 10, viewSize.Y - 10)
                end
            end
            if not startX then startX = viewSize.X / 2; startY = viewSize.Y * 0.85 end

            for player, d in pairs(espData) do
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if not on or not hrp or not hum or hum.Health <= 0 then
                    d.box.Visible = false; d.tracer.Visible = false
                    d.offscreen.Visible = false
                else
                    local topS = cam:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3.2, 0))
                    local botS = cam:WorldToViewportPoint(hrp.Position + Vector3.new(0, -3.0, 0))
                    if topS.Z > 0 then
                        local boxH = math.abs(botS.Y - topS.Y)
                        local boxW = boxH * 0.55
                        local cx = (topS.X + botS.X) / 2
                        local cy = (topS.Y + botS.Y) / 2
                        d.box.Position = UDim2.new(0, cx - boxW/2, 0, cy - boxH/2)
                        d.box.Size = UDim2.new(0, boxW, 0, boxH)
                        d.box.Visible = boxOn
                        local dx, dy = cx - startX, cy - startY
                        local length = math.sqrt(dx*dx + dy*dy)
                        d.tracer.Position = UDim2.new(0, (startX+cx)/2, 0, (startY+cy)/2)
                        d.tracer.Size = UDim2.new(0, length, 0, 1)
                        d.tracer.Rotation = math.deg(math.atan2(dy, dx))
                        d.tracer.Visible = tracerOn
                        d.offscreen.Visible = false
                    else
                        d.box.Visible = false
                        local rootS = cam:WorldToViewportPoint(hrp.Position)
                        local centerX, centerY = viewSize.X * 0.5, viewSize.Y * 0.5
                        local targetX, targetY = rootS.X, rootS.Y
                        if rootS.Z <= 0 then
                            targetX = viewSize.X - targetX
                            targetY = viewSize.Y - targetY
                        end
                        local dx, dy = targetX - centerX, targetY - centerY
                        if math.abs(dx) < 0.001 and math.abs(dy) < 0.001 then dy = -1 end
                        local margin = 30
                        local tx = (centerX - margin) / math.max(math.abs(dx), 0.001)
                        local ty = (centerY - margin) / math.max(math.abs(dy), 0.001)
                        local edgeScale = math.min(tx, ty)
                        local edgeX = centerX + dx * edgeScale
                        local edgeY = centerY + dy * edgeScale
                        local lineDx, lineDy = edgeX - startX, edgeY - startY
                        local length = math.sqrt(lineDx * lineDx + lineDy * lineDy)
                        d.tracer.Position = UDim2.fromOffset((startX + edgeX) * 0.5, (startY + edgeY) * 0.5)
                        d.tracer.Size = UDim2.fromOffset(length, 1)
                        d.tracer.Rotation = math.deg(math.atan2(lineDy, lineDx))
                        d.tracer.Visible = _G._AdaptESPShowTracer == true
                        d.offscreen.Position = UDim2.fromOffset(edgeX, edgeY)
                        d.offscreen.Rotation = math.deg(math.atan2(dy, dx)) + 90
                        d.offscreen.Visible = false
                    end
                end
            end
        end))

        _G._AdaptESPSetEnabled = function(on)
            _G._AdaptESPEnabled = on and true or false
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and not espData[p] then pcall(createForPlayer, p) end
            end
            for _, d in pairs(espData) do
                if d.hl then d.hl.Enabled = _G._AdaptESPEnabled end
            end
        end
        _G._AdaptESPSetShowTracer = function(on) _G._AdaptESPShowTracer = on and true or false end
        _G._AdaptESPSetShowBox    = function(on) _G._AdaptESPShowBox    = on and true or false end

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then pcall(createForPlayer, p) end
        end
        _G._AdaptESPSetEnabled(_G._VynxAuraESP == true)
    end

    enableOptimizer  = function() Util.antilag = true;  Enabled.Optimizer = true;  pcall(_G._AdaptStartAntiLag)   end
    disableOptimizer = function() Util.antilag = false; Enabled.Optimizer = false; pcall(_G._AdaptStopAntiLag)    end
    enableUltraMode  = function() Util.potato = true;  ultraModeEnabled = true;  pcall(_G._AdaptStartVisualStrip) end
    disableUltraMode = function() Util.potato = false; ultraModeEnabled = false; pcall(_G._AdaptStopVisualStrip)  end
    startRemoveAccessories = function() Enabled.ShinyGraphics = true;  Enabled.RemoveAccessories = true;  pcall(startShiny) end
    stopRemoveAccessories  = function() Enabled.ShinyGraphics = false; Enabled.RemoveAccessories = false; pcall(stopShiny)  end

    _G._AdaptSetNoCamCollision = setNoCamCollision
    _G._AdaptSetAuraESP  = function(on) pcall(_G._AdaptESPSetEnabled, on) end
    _G._AdaptSetHeadless = function(on)
        _G._VynxHeadless = on and true or false
        pcall(setHeadless, LP.Character, _G._VynxHeadless)
    end
    _G._AdaptSetKorblox  = function(m) pcall(_G._RaVeApplyKorblox, m or "Off") end
    _G._AdaptSetAntiLag  = function(on) if on then enableOptimizer() else disableOptimizer() end end
    _G._AdaptSetPotato   = function(on) if on then enableUltraMode() else disableUltraMode() end end
    _G._AdaptSetShiny    = function(on) if on then startRemoveAccessories() else stopRemoveAccessories() end end
    _G._AdaptSetDarkMode = function(on) pcall(_G._RaVeSetDarkMode, on) end

    do
        local lastESP, lastBox, lastTrk = nil, nil, nil
        local lastHeadless, lastKorblox = nil, nil
        local lastDark, lastDarkLevel = nil, nil
        local acc = 0
        hubConnect(RunService.Heartbeat, LPH_NO_VIRTUALIZE(function(dt)
            acc = acc + dt
            if acc < 0.2 then return end
            acc = 0

            local esp = _G._VynxAuraESP == true
            if esp ~= lastESP then lastESP = esp; pcall(_G._AdaptESPSetEnabled, esp) end

            local box = _G._VynxBoxedESP == true
            if box ~= lastBox then lastBox = box; _G._AdaptESPShowBox = box end

            local trk = _G._VynxShowTracker == true
            if trk ~= lastTrk then lastTrk = trk; _G._AdaptESPShowTracer = trk end

            local hl = _G._VynxHeadless == true
            if hl ~= lastHeadless then
                lastHeadless = hl
                pcall(setHeadless, LP.Character, hl)
            end

            local kb = _G._VynxKorblox or "Off"
            if kb ~= lastKorblox then lastKorblox = kb; pcall(_G._RaVeApplyKorblox, kb) end

            local dark = _G._VynxDarkModeOn == true
            if dark ~= lastDark then lastDark = dark; pcall(_G._RaVeSetDarkMode, dark) end

            local lvl = tonumber(_G._VynxDarkness) or 2
            if lvl ~= lastDarkLevel then lastDarkLevel = lvl; pcall(_G._RaVeSetDarkLevel, lvl) end
        end))
    end

    hubConnect(LP.CharacterAdded, function(char)
        task.wait(0.3)
        if _G._VynxHeadless then pcall(setHeadless, char, true) end
        for _ = 1, 10 do
            task.wait(0.5)
            if char.Parent == nil then return end
            local mode = _G._RaVeKorbloxMode
            if mode == "Off" then return end
            local needLeft  = (mode == "Left"  or mode == "Both") and char:FindFirstChild("Korblox_LeftLeg")  == nil
            local needRight = (mode == "Right" or mode == "Both") and char:FindFirstChild("Korblox_RightLeg") == nil
            if needLeft or needRight then pcall(_G._RaVeApplyKorblox, mode) end
        end
    end)

    _G._VioletteVisualRuntime = {
        Destroy = function()
            pcall(_G._AdaptStopAntiLag)
            pcall(_G._AdaptStopVisualStrip)
            pcall(stopShiny)
            pcall(_G._RaVeSetDarkMode, false)
            pcall(stopFov); pcall(stopStretch)
            for _, c in ipairs(_conns) do pcall(function() c:Disconnect() end) end
            _conns = {}
            _G._VioletteVisualRuntime = nil
        end,
    }

    if Enabled.Optimizer then enableOptimizer() end
    if _G._VezyDisplayMode == "FOV" then startFov()
    elseif _G._VezyDisplayMode == "STRETCH" then startStretch() end
    if noCamCollisionEnabled then setNoCamCollision(true) end
end)()

;(function()

    local LP = LocalPlayer
    local SAVE_FILE = "VioletteHub_Auto.json"

    if _G._VioletteAutoSaveRuntime and _G._VioletteAutoSaveRuntime.Destroy then
        pcall(_G._VioletteAutoSaveRuntime.Destroy)
    end

    local _conns = {}
    local function hubConnect(signal, handler)
        local c = signal:Connect(handler)
        _conns[#_conns + 1] = c
        return c
    end

    local canWrite = (writefile ~= nil)
    local canRead  = (readfile ~= nil and isfile ~= nil)

    local GLOBAL_KEYS = {
        "_VynxSpeedMethod", "NormalSpeed_Normal", "NormalSpeed_Carry",
        "LaggerSpeed_Normal", "LaggerSpeed_Carry", "DesyncSpeed_Normal", "DesyncSpeed_Carry",
        "_VynxAutoSpeedOn", "_VynxAutoSpeedMode", "_VynxAutoSpeedRange",
        "_VioletteFakeSpeed",
        "_VynxAutoStealMode", "_VynxAutoGrabPause", "_VynxRagdollSteal", "_AdaptStealBarScale",
        "_VynxStealRadiusNormal", "_VynxStealRadiusSemi",
        "_VezyBatAimbotSpeed", "_VezyBatAimbotSpeedLagger", "_VezyBatAimbotSpeedCustom",
        "_VezyBatAimbotMode", "_VezyBatAimbotOn", "_VezyAutoSwingEnabled",
        "_VioletteAimbotAutoSwing",
        "_VezyBatCounterOn",
        "_VynxMirrorTPDown", "_VynxRemoveCamShake",
        "_VezyBypassChaseSpeed",
        "_VezyJumpMode", "_AdaptInfJumpMode", "_VynxRagdollMode",
        "_VynxDropType", "_VynxTPDownMode",
        "_VynxAutoTPDownEnabled", "_VynxAutoTPDownHeightTrigger",
        "_VynxAnimPack", "_AdaptAnimPack",
        "_VioletteIntroSong", "_VioletteSkipIntro",
        "_VynxAntiDie", "_VynxAntiFling", "_VynxSafeMode", "_VynxKickWarning",
        "_AdaptAutoPlayMode", "_KawatanPathMode",
        "_VezyDisplayMode", "_VezyCustomFOV", "_VezyStretchFOV", "_VynxStretchValue",
        "_VezyCustomSkyMode", "_VynxAuraESP", "_VynxBoxedESP", "_VynxShowTracker",
        "_VynxHeadless", "_VynxKorblox", "_VynxDarkModeOn", "_VynxDarkness",
        "_VynxCustomSkin", "_KawatanSkinColor", "_VlonEBodyType",
        "_VynxAvatarESP", "_VynxRagdollCountdown",
        "_VynxESPSelection", "_VynxESPOn",
        "_VynxBodyLockOn", "_VynxBodyLockRange",
        "_VynxMobileBtnScale", "_VynxMobileCircle", "_VezyHideSideBtns",
        "_VezyBgOpacity", "_VezyBtnOpacity", "_VezyBgImageId",
        "_VynxInstaResetKey",
    }

    local function isScalar(v)
        local t = type(v)
        return t == "string" or t == "number" or t == "boolean"
    end

    local function collect()
        local cfg = { version = 1 }

        cfg.globals = {}
        for _, key in ipairs(GLOBAL_KEYS) do
            local v = _G[key]
            if isScalar(v) then cfg.globals[key] = v end
        end

        cfg.keybinds = {}
        pcall(function()
            for name, kc in pairs(Keybinds) do
                if typeof(kc) == "EnumItem" then cfg.keybinds[name] = kc.Name end
            end
        end)

        cfg.enabled = {}
        pcall(function()
            for name, on in pairs(Enabled) do cfg.enabled[name] = on == true end
        end)
        cfg.settings = {}
        pcall(function()
            cfg.settings.StealRadius = Settings.StealRadius
            cfg.settings.AutoStealEnabled = Settings.AutoStealEnabled == true
        end)

        pcall(function()
            cfg.speed = { family = Spd.family, carry = Spd.carry == true }
        end)

        cfg.flags = {}
        pcall(function()
            cfg.flags.autoBat        = autoBatToggled == true
            cfg.flags.autoSwing      = autoSwingEnabled == true
            cfg.flags.medusaCounter  = medusaCounterEnabled == true
            cfg.flags.batCounter     = (BC and BC.enabled) == true
            cfg.flags.noCamCollision = noCamCollisionEnabled == true
            cfg.flags.ultraMode      = ultraModeEnabled == true
            cfg.flags.desync         = desyncEnabled == true
        end)

        pcall(function()
            local c = _G._VioletteAccent
            if typeof(c) == "Color3" then
                cfg.accent = { math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5) }
            end
        end)

        cfg.ui = {}
        pcall(function() cfg.ui.scale = UI_SCALE end)
        pcall(function()
            local outer = _G.VynxOuterRef
            if outer and outer.Parent then
                local p, s = outer.Position, outer.Size
                cfg.ui.winPos  = { p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset }
                cfg.ui.winSize = { s.X.Scale, s.X.Offset, s.Y.Scale, s.Y.Offset }
                cfg.ui.winVisible = (_G._VioletteHubShown and _G._VioletteHubShown()) or (outer.Visible == true)
            end
        end)

        pcall(function()
            if type(_G._VlPbPos) == "table" and #_G._VlPbPos == 4 then
                cfg.stealBarPos = _G._VlPbPos
            end
            cfg.stealBarScale = tonumber(_G._AdaptStealBarScale) or 1.0
        end)

        pcall(function()
            local frame = _G._VezyMobileButtonsFrame
            local parent = frame and frame.Parent
            if parent then
                local out = {}
                for _, child in ipairs(parent:GetChildren()) do
                    if child:IsA("TextButton") and child.Name:sub(1, 3) == "MB_" then
                        local p = child.Position
                        out[child.Name:sub(4)] = { xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset }
                    end
                end
                if next(out) then
                    cfg.mobileBtnPos = out
                    cfg.mobileBtnLayout = _G._VynxMobileLayoutVersion
                end
                if type(_G._VynxMobileShown) == "table" then
                    local hidden = {}
                    for k, v in pairs(_G._VynxMobileShown) do
                        if v == false then hidden[k] = false end
                    end
                    if next(hidden) then cfg.mobileBtnShown = hidden end
                end
                if frame then cfg.ui.mobileVisible = frame.Visible == true end
            end
        end)

        pcall(function()
            if _G._VioletteCollectPanels then cfg.panels = _G._VioletteCollectPanels() end
        end)

        return cfg
    end

    local function apply(cfg)
        if type(cfg) ~= "table" then return end

        if type(cfg.globals) == "table" then
            for key, v in pairs(cfg.globals) do
                if isScalar(v) then _G[key] = v end
            end
        end

        if type(cfg.keybinds) == "table" then
            pcall(function()
                for name, keyName in pairs(cfg.keybinds) do
                    if Keybinds[name] ~= nil and type(keyName) == "string" and Enum.KeyCode[keyName] then
                        Keybinds[name] = Enum.KeyCode[keyName]
                    end
                end
            end)
        end

        if type(cfg.settings) == "table" then
            pcall(function()
                if tonumber(cfg.settings.StealRadius) then
                    Settings.StealRadius = tonumber(cfg.settings.StealRadius)
                    Values.STEAL_RADIUS = Settings.StealRadius
                    if RadiusInput then RadiusInput.Text = tostring(Settings.StealRadius) end
                end
                if cfg.settings.AutoStealEnabled ~= nil then
                    Settings.AutoStealEnabled = cfg.settings.AutoStealEnabled == true
                end
            end)
        end

        if type(cfg.accent) == "table" and #cfg.accent == 3 then
            pcall(function()
                local c = Color3.fromRGB(cfg.accent[1], cfg.accent[2], cfg.accent[3])
                if _G._VioletteApplyAccent then _G._VioletteApplyAccent(c)
                elseif _G._VioletteSetTagColor then _G._VioletteSetTagColor(c) end
            end)
        end

        if type(cfg.ui) == "table" then
            pcall(function()
                if tonumber(cfg.ui.scale) and _G._VynxApplyUIScale then
                    _G._VynxApplyUIScale(math.clamp(tonumber(cfg.ui.scale), 0.5, 2.0))
                end
            end)
            pcall(function()
                local outer = _G.VynxOuterRef
                if not (outer and outer.Parent) then return end
                local p, s = cfg.ui.winPos, cfg.ui.winSize
                if type(p) == "table" and #p == 4 then
                    outer.Position = UDim2.new(p[1], p[2], p[3], p[4])
                end
                if type(s) == "table" and #s == 4 and (s[2] > 0 or s[4] > 0) then
                    outer.Size = UDim2.new(s[1], s[2], s[3], s[4])
                end
            end)
            pcall(function()
                if cfg.ui.winVisible ~= nil then
                    _G._VioletteWantMinimized = cfg.ui.winVisible == false
                    if _G._VioletteSetMinimized then _G._VioletteSetMinimized(_G._VioletteWantMinimized) end
                end
            end)
        end

        pcall(function()
            if type(cfg.stealBarPos) == "table" and #cfg.stealBarPos == 4 then
                _G._VlPbPos = cfg.stealBarPos
                if _G._VynxApplyStealBarPos then _G._VynxApplyStealBarPos() end
            end
            local sc = tonumber(cfg.stealBarScale)
            if sc then
                _G._AdaptStealBarScale = sc
                if _G._RaVeSetStealBarScale then _G._RaVeSetStealBarScale(sc * 100 * (_G._VioletteDeviceScale or 1)) end
                if _G._VynxRefreshStealBarScale then pcall(_G._VynxRefreshStealBarScale) end
            end
        end)

        pcall(function()
            if type(cfg.mobileBtnPos) ~= "table" then return end
            if cfg.mobileBtnLayout ~= _G._VynxMobileLayoutVersion then
                _G._VezyMobileBtnPos = nil
                return
            end
            _G._VezyMobileBtnPos = cfg.mobileBtnPos
            local frame = _G._VezyMobileButtonsFrame
            local parent = frame and frame.Parent
            if not parent then return end
            for key, pos in pairs(cfg.mobileBtnPos) do
                local btn = parent:FindFirstChild("MB_" .. key)
                if btn and tonumber(pos.xs) then
                    btn.Position = UDim2.new(pos.xs, pos.xo, pos.ys, pos.yo)
                end
            end
        end)
        pcall(function()
            if cfg.ui and cfg.ui.mobileVisible ~= nil and _G._VezyMobileButtonsFrame then
                _G._VezyMobileButtonsFrame.Visible = cfg.ui.mobileVisible == true
            end
            _G._VynxMobileShown = _G._VynxMobileShown or {}
            if type(cfg.mobileBtnShown) == "table" then
                for k, v in pairs(cfg.mobileBtnShown) do
                    if v == false then _G._VynxMobileShown[k] = false end
                end
            end
            if _G._VynxApplyMobileBtnScale and tonumber(_G._VynxMobileBtnScale) then
                _G._VynxApplyMobileBtnScale(_G._VynxMobileBtnScale)
            end
            if VisualSetters.MobileCircle then
                pcall(VisualSetters.MobileCircle, _G._VynxMobileCircle == true)
            end
            if _G._VynxApplyHideMobile then
                pcall(_G._VynxApplyHideMobile, _G._VezyHideSideBtns == true)
            end
            if VisualSetters.HideSideBtns then
                pcall(VisualSetters.HideSideBtns, _G._VezyHideSideBtns == true)
            end
            if VisualSetters.SkipIntro then
                pcall(VisualSetters.SkipIntro, _G._VioletteSkipIntro == true)
            end
            if _G._VynxRefreshMobilePickRows then pcall(_G._VynxRefreshMobilePickRows) end
        end)

        pcall(function()
            if type(cfg.speed) == "table" then
                Spd.SetProfile(cfg.speed.family or "normal", cfg.speed.carry == true)
            end
        end)

        local en = type(cfg.enabled) == "table" and cfg.enabled or {}
        local fl = type(cfg.flags) == "table" and cfg.flags or {}

        pcall(function()
            for name, v in pairs(en) do Enabled[name] = v == true end
        end)

        pcall(function()
            if en.InfiniteJump then _G.VezyEnableInfJump() end
            if en.AntiRagdoll then startAntiRagdoll() end
            if en.AutoSteal then startAutoSteal() end
            if en.Optimizer then enableOptimizer() end
            if fl.ultraMode then enableUltraMode() end
            if en.RemoveAccessories or en.ShinyGraphics then startRemoveAccessories() end
            if en.Unwalk then startUnwalk() end
            if fl.noCamCollision then noCamCollisionEnabled = true; enableNoCameraCollision() end
            if fl.medusaCounter then medusaCounterEnabled = true; setupMedusaCounter(LP.Character) end
            if fl.batCounter then _G.VezyStartBatCounter() end
            if _G._VynxBodyLockOn and _G._VioletteStartBodyLock then _G._VioletteStartBodyLock() end
            if _G._VioletteSetAvatarESP then _G._VioletteSetAvatarESP(_G._VynxAvatarESP == true) end
            if fl.autoSwing then
                autoSwingEnabled = true
                _G._VezyAutoSwingEnabled = true
            end
            if fl.autoBat then
                autoBatToggled = true
                _G._VezyBatAimbotOn = true
                if _G.VezyStartBatAimbotDispatch then _G.VezyStartBatAimbotDispatch() end
            end
        end)

        pcall(function()
            for name, v in pairs(en) do
                local setter = VisualSetters[name]
                if setter then pcall(setter, v == true) end
            end
            if VisualSetters.AutoBat then pcall(VisualSetters.AutoBat, fl.autoBat == true) end
            if VisualSetters.AutoSwing then pcall(VisualSetters.AutoSwing, fl.autoSwing == true) end
            if VisualSetters.AimbotAutoSwing then pcall(VisualSetters.AimbotAutoSwing, _G._VioletteAimbotAutoSwing ~= false) end
            if VisualSetters.MedusaCounter then pcall(VisualSetters.MedusaCounter, fl.medusaCounter == true) end
            if VisualSetters.BatCounter then pcall(VisualSetters.BatCounter, fl.batCounter == true) end
            if VisualSetters.BodyLock then pcall(VisualSetters.BodyLock, _G._VynxBodyLockOn == true) end
            if VisualSetters.NoCam then pcall(VisualSetters.NoCam, fl.noCamCollision == true) end
            if VisualSetters.UltraMode then pcall(VisualSetters.UltraMode, fl.ultraMode == true) end
            if VisualSetters.AntiDie then pcall(VisualSetters.AntiDie, _G._VynxAntiDie == true) end
            if VisualSetters.AntiFling then pcall(VisualSetters.AntiFling, _G._VynxAntiFling == true) end
            if VisualSetters.SafeMode then pcall(VisualSetters.SafeMode, _G._VynxSafeMode == true) end
            if VisualSetters.MirrorTPDown then pcall(VisualSetters.MirrorTPDown, _G._VynxMirrorTPDown == true) end
            if VisualSetters.RemoveCamShake then pcall(VisualSetters.RemoveCamShake, _G._VynxRemoveCamShake == true) end
            if VisualSetters.Headless then pcall(VisualSetters.Headless, _G._VynxHeadless == true) end
            if VisualSetters.DarkMode then pcall(VisualSetters.DarkMode, _G._VynxDarkModeOn == true) end
            if VisualSetters.AutoSpeed then pcall(VisualSetters.AutoSpeed, _G._VynxAutoSpeedOn == true) end
            if VisualSetters.RagdollSteal then pcall(VisualSetters.RagdollSteal, _G._VynxRagdollSteal == true) end
            if VisualSetters.CustomSkin then pcall(VisualSetters.CustomSkin, _G._VynxCustomSkin == true) end
            if _G._VlonEBodyType and _G._VlonEBodyType ~= "OFF" and _G._VioletteSetBodyType then
                task.spawn(function() pcall(_G._VioletteSetBodyType, _G._VlonEBodyType) end)
            end
            if _G._VynxCustomSkin == true and _G._VioletteSetCustomSkin then
                task.spawn(function() pcall(_G._VioletteSetCustomSkin, true) end)
            end
            if VisualSetters.AutoTPDown then pcall(VisualSetters.AutoTPDown, _G._VynxAutoTPDownEnabled == true) end
        end)

        pcall(function()
            for name, lbl in pairs(KB) do
                local kc = Keybinds[name]
                if lbl and lbl.Parent then
                    lbl.Text = _G._VioletteKeyName(kc)
                end
            end
        end)
        for _, fn in ipairs({
            "_VynxRefreshSpeedModes", "_VynxRefreshSpeedMethod", "_VynxRefreshAutoSpeedMode",
            "_VynxRefreshAutoStealMode", "_VynxRefreshRagdollMode",
            "_VynxRefreshAimbotModeBtns",
            "_VezyRefreshJumpModeBtns", "_VynxRefreshDropType", "_VynxRefreshAnimPack",
            "_VynxRefreshIntroSong",
            "_VezyRefreshSkyTheme", "_VezyRefreshDisplayMode", "_VynxRefreshDarkness",
            "_VezyRefreshCustomFOV", "_VezyRefreshStretchFOV",
            "_VynxRefreshESPKind", "_VynxSyncESPRow", "_VynxRefreshBodyLockRange",
            "_VynxRefreshCustomSkin", "_VynxRefreshBodyType",
            "_VynxRefreshHdrLockIcon",
            "_AdaptRefreshAutoPlayMode",
            "_VynxRefreshInstaResetKey", "_VynxRefreshDuelLaggerKey", "_VezyRefreshStealBarScale",
            "_VioletteSyncMobileSpeedBtns", "_VynxSyncMobileBtns",
            "_VynxRefreshSpeedInputs", "_VynxRefreshUISizeButtons",
            "_VynxRefreshMobileBtnSizeButtons", "_VynxRefreshUIToggleKey",
            "VezySyncBgPicker", "_VynxRefreshAutoSteal", "_VynxRefreshKorblox",
            "_VynxRefreshAutoGrabPause",
            "_VynxRefreshStealRadius",
        }) do
            if type(_G[fn]) == "function" then pcall(_G[fn]) end
        end

        task.delay(0.6, function()
            pcall(function()
                if _G.VezyApplyCustomSky and _G._VezyCustomSkyMode then
                    _G.VezyApplyCustomSky(_G._VezyCustomSkyMode)
                end
                if _G._RaVeApplySelectedAnimation and _G._VynxAnimPack then
                    _G._RaVeApplySelectedAnimation(_G._VynxAnimPack)
                end
                if _G._VezyDisplayMode == "FOV" and _G.VezyEnableFOV then _G.VezyEnableFOV()
                elseif _G._VezyDisplayMode == "STRETCH" and _G._VynxEnableStretchRez then _G._VynxEnableStretchRez() end
                if _G._VioletteRestorePanels then _G._VioletteRestorePanels(cfg.panels) end
                if _G._VioletteRefreshPanelBtns then _G._VioletteRefreshPanelBtns() end
            end)
        end)
    end

    local lastJson = nil
    local pending = false

    _G._VioletteBootDone = false

    local function writeNow()
        if not canWrite then return end
        if not _G._VioletteBootDone then return end
        if _G._VioletteSettingsReset == true then return end
        pending = false
        local ok, json = pcall(function() return HttpService:JSONEncode(collect()) end)
        if not ok or type(json) ~= "string" then return end
        if json == lastJson then return end
        lastJson = json
        pcall(writefile, SAVE_FILE, json)
    end

    local function writeSoon()
        if pending then return end
        pending = true
        task.delay(0.6, function()
            if pending then writeNow() end
        end)
    end

    _G.KRIXSaveNow        = writeSoon
    _G.KRIXSaveNowInstant = writeNow
    saveConfig            = writeSoon
    _G._VioletteSaveNow      = writeNow
    _G._VioletteCollectConfig = collect
    _G._VioletteApplyConfig  = apply

    local acc = 0
    hubConnect(RunService.Heartbeat, LPH_NO_VIRTUALIZE(function(dt)
        acc = acc + dt
        if acc < 5 then return end
        acc = 0
        writeNow()
    end))

    pcall(function()
        hubConnect(LP.AncestryChanged, function(_, parent)
            if not parent then writeNow() end
        end)
    end)
    pcall(function()
        game:BindToClose(function() writeNow() end)
    end)

    _G._VioletteAutoSaveRuntime = {
        Destroy = function()
            for _, c in ipairs(_conns) do pcall(function() c:Disconnect() end) end
            _conns = {}
            _G._VioletteAutoSaveRuntime = nil
        end,
    }

    if canRead and isfile(SAVE_FILE) then
        task.spawn(function()
            local ok, raw = pcall(readfile, SAVE_FILE)
            if not ok or type(raw) ~= "string" then
                task.wait(2); _G._VioletteBootDone = true
                return
            end
            local ok2, cfg = pcall(function() return HttpService:JSONDecode(raw) end)
            if not ok2 or type(cfg) ~= "table" then
                task.wait(2); _G._VioletteBootDone = true
                return
            end
            lastJson = raw
            task.wait(0.4)
            pcall(apply, cfg)
            task.wait(1.2)
            pcall(function()
                for name, lbl in pairs(KB) do
                    local kc = Keybinds[name]
                    if lbl and lbl.Parent then
                        lbl.Text = _G._VioletteKeyName(kc)
                    end
                end
            end)
            _G._VioletteBootDone = true
        end)
    else
        task.spawn(function()
            task.wait(0.5)
            local DEFAULT_CFG = {
                version = 1,
                globals = {
                    _VynxSpeedMethod = "V1", _VynxAutoSpeedOn = false,
                    NormalSpeed_Normal = 60, NormalSpeed_Carry = 29,
                    LaggerSpeed_Normal = 50, LaggerSpeed_Carry = 25,
                    DesyncSpeed_Normal = 65, DesyncSpeed_Carry = 33,
                    _VynxAutoStealMode = "Normal", _VynxAutoGrabPause = 75, _VynxRagdollSteal = false,
                    _VezyBatAimbotOn = false, _VezyBatAimbotMode = "new",
                    _VezyBatAimbotSpeed = 58, _VezyBatAimbotSpeedLagger = 40,
                    _VezyBatAimbotSpeedCustom = 58, _VioletteAimbotAutoSwing = true,
                    _VynxMirrorTPDown = false,
                    _VynxRemoveCamShake = false,
                    _VezyJumpMode = "Hold", _VynxRagdollMode = "V2",
                    _VynxDropType = "Jump Drop",
                    _VynxAutoTPDownEnabled = false, _VynxAutoTPDownHeightTrigger = 20,
                    _VynxBodyLockOn = false, _VynxBodyLockRange = 15,
                    _VynxAnimPack = "Off",
                    _VynxAntiDie = false, _VynxAntiFling = false, _VynxSafeMode = false, _VynxKickWarning = false,
                    _AdaptAutoPlayMode = "Normal",
                    _VezyCustomSkyMode = "Off", _VynxHeadless = false, _VynxKorblox = "Off",
                    _VynxCustomSkin = false, _KawatanSkinColor = "1", _VlonEBodyType = "OFF",
                    _VynxAuraESP = false, _VynxBoxedESP = false, _VynxShowTracker = false,
                    _VynxAvatarESP = false, _VynxRagdollCountdown = false, _VynxESPOn = false,
                    _VioletteIntroSong = "Song 2",
                    _VynxInstaResetKey = nil,
                },
                enabled = {
                    AutoSteal = false, InfiniteJump = false, AntiRagdoll = false,
                    Optimizer = false, RemoveAccessories = false, Unwalk = false,
                },
                flags = {
                    autoBat = false, autoSwing = false, batCounter = false,
                    noCamCollision = false, medusaCounter = false,
                    ultraMode = false, desync = false,
                },
                settings = { StealRadius = 62, AutoStealEnabled = false },
                speed = { family = "normal", carry = false },
            }
            pcall(apply, DEFAULT_CFG)
            task.wait(0.8)
            _G._VioletteBootDone = true
            writeNow()
        end)
    end
end)()

;(function()

    local LP = LocalPlayer

    if _G._VioletteAvatarESPRuntime and _G._VioletteAvatarESPRuntime.Destroy then
        pcall(_G._VioletteAvatarESPRuntime.Destroy)
    end

    local _conns = {}
    local function hubConnect(signal, handler)
        local c = signal:Connect(handler)
        _conns[#_conns + 1] = c
        return c
    end

    local billboards = {}

    local holder = Instance.new("ScreenGui")
    holder.Name = "VioletteAvatarESP"
    holder.ResetOnSpawn = false
    holder.IgnoreGuiInset = true
    holder.DisplayOrder = -999
    pcall(function() holder.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
    if not holder.Parent then holder.Parent = LP:WaitForChild("PlayerGui") end

    local function accent()
        return _G._VioletteAccent or _G._AdaptESPColor or Color3.fromRGB(46, 166, 255)
    end

    local function createAvatarBillboard(player)
        if billboards[player] and billboards[player].Parent then return billboards[player] end

        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "AvatarRond_" .. player.Name
        billboardGui.Size = UDim2.fromScale(1.9, 1.9)
        billboardGui.StudsOffset = Vector3.new(3.4, 2.2, 0)
        billboardGui.AlwaysOnTop = true
        billboardGui.Enabled = false
        billboardGui.Parent = holder

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        frame.Parent = billboardGui

        local avatarFrame = Instance.new("Frame")
        avatarFrame.Name = "Ring"
        avatarFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        avatarFrame.Size = UDim2.fromScale(0.82, 0.82)
        avatarFrame.Position = UDim2.fromScale(0.5, 0.5)
        avatarFrame.BackgroundTransparency = 1
        avatarFrame.BorderSizePixel = 0
        avatarFrame.Parent = frame

        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(1, 0)
        uiCorner.Parent = avatarFrame

        local stroke = Instance.new("UIStroke")
        stroke.Color = accent()
        stroke.Thickness = 2
        stroke.Parent = avatarFrame

        local avatarImage = Instance.new("ImageLabel")
        avatarImage.Size = UDim2.new(1, 0, 1, 0)
        avatarImage.BackgroundTransparency = 1
        avatarImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=48&h=48"
        avatarImage.Parent = avatarFrame

        local avatarCorner = Instance.new("UICorner")
        avatarCorner.CornerRadius = UDim.new(1, 0)
        avatarCorner.Parent = avatarImage

        billboards[player] = billboardGui
        return billboardGui
    end

    local function clearPlayer(player)
        local bb = billboards[player]
        if bb then pcall(function() bb:Destroy() end) end
        billboards[player] = nil
    end

    hubConnect(Players.PlayerAdded, function(p)
        if p ~= LP then pcall(createAvatarBillboard, p) end
    end)
    hubConnect(Players.PlayerRemoving, clearPlayer)

    local AVA_BASE = 1.9
    local AVA_NEAR = 24
    local AVA_FAR  = 160
    local AVA_MAX  = 1.9

    hubConnect(RunService.Heartbeat, LPH_NO_VIRTUALIZE(function()
        local on = _G._VynxAvatarESP == true
        local cam = workspace.CurrentCamera
        local camPos = cam and cam.CFrame.Position
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP then
                local bb = billboards[player]
                if on and not bb then bb = createAvatarBillboard(player) end
                if bb then
                    local char = player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if on and root and hum and hum.Health > 0 then
                        bb.Adornee = root
                        bb.Enabled = true
                        if camPos then
                            local dist = (camPos - root.Position).Magnitude
                            local grow = math.clamp(dist / AVA_NEAR, 1, AVA_FAR / AVA_NEAR)
                            grow = math.min(grow, AVA_MAX)
                            bb.Size = UDim2.fromScale(AVA_BASE * grow, AVA_BASE * grow)
                        end
                    else
                        bb.Enabled = false
                    end
                end
            end
        end
    end))

    local function setEnabled(on)
        _G._VynxAvatarESP = on and true or false
        if _G._VynxAvatarESP then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP then pcall(createAvatarBillboard, p) end
            end
        else
            for _, bb in pairs(billboards) do
                if bb and bb.Parent then bb.Enabled = false end
            end
        end
    end

    _G._VioletteRefreshAvatarESPColor = function()
        local col = accent()
        for _, bb in pairs(billboards) do
            if bb and bb.Parent then
                local ring = bb:FindFirstChild("Ring", true)
                local st = ring and ring:FindFirstChildOfClass("UIStroke")
                if st then st.Color = col end
            end
        end
    end

    _G._VioletteSetAvatarESP = setEnabled
    _G._VioletteAvatarESPRuntime = {
        Destroy = function()
            for _, bb in pairs(billboards) do pcall(function() bb:Destroy() end) end
            billboards = {}
            pcall(function() holder:Destroy() end)
            for _, c in ipairs(_conns) do pcall(function() c:Disconnect() end) end
            _conns = {}
            _G._VioletteAvatarESPRuntime = nil
        end,
    }

    if _G._VynxAvatarESP then setEnabled(true) end
end)()

;(function()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

if _G._VioletteBodyLockRuntime and _G._VioletteBodyLockRuntime.Destroy then
    pcall(_G._VioletteBodyLockRuntime.Destroy)
end

local BodyLock = {
    Enabled = false,
    PlayersOnly = true,
    UseRange = true,
    Range = tonumber(_G._VynxBodyLockRange) or 9,
    TurnSpeed = 30,
}
_G._VioletteBodyLock = BodyLock

local connection
local charConn
local character
local rootPart
local humanoid

local function validTarget(targetHumanoid, targetRoot)
    if not targetHumanoid or not targetRoot or targetHumanoid.Health <= 0 then
        return false
    end

    if BodyLock.PlayersOnly then
        local targetPlayer = Players:GetPlayerFromCharacter(targetHumanoid.Parent)
        if not targetPlayer or targetPlayer == LocalPlayer then
            return false
        end
    end

    return true
end

local function getTarget()
    BodyLock.Range = tonumber(_G._VynxBodyLockRange) or BodyLock.Range

    for _, model in ipairs(workspace:GetChildren()) do
        if model ~= character then
            local targetRoot = model:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = model:FindFirstChildOfClass("Humanoid")

            if validTarget(targetHumanoid, targetRoot) then
                if BodyLock.UseRange and rootPart then
                    local distance = (rootPart.Position - targetRoot.Position).Magnitude
                    if distance <= BodyLock.Range then
                        return targetRoot
                    end
                else
                    return targetRoot
                end
            end
        end
    end

    return nil
end

local function stop()
    BodyLock.Enabled = false
    _G._VynxBodyLockOn = false

    if connection then
        connection:Disconnect()
        connection = nil
    end

    if rootPart then
        rootPart.RotVelocity = Vector3.zero
    end

    if humanoid then
        humanoid.AutoRotate = true
    end
end

local function start()
    BodyLock.Enabled = true
    _G._VynxBodyLockOn = true

    if connection then
        connection:Disconnect()
    end

    connection = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
        if not BodyLock.Enabled
            or not character
            or not character.Parent
            or not rootPart
            or not humanoid then
            return
        end

        local target = getTarget()
        if not target then
            rootPart.RotVelocity = Vector3.zero
            humanoid.AutoRotate = true
            return
        end

        humanoid.AutoRotate = false

        local lookVector = rootPart.CFrame.LookVector
        local currentDirection = Vector3.new(lookVector.X, 0, lookVector.Z)
        local offset = target.Position - rootPart.Position
        local targetDirection = Vector3.new(offset.X, 0, offset.Z)

        if currentDirection.Magnitude <= 0.001 or targetDirection.Magnitude <= 0.001 then
            return
        end

        currentDirection = currentDirection.Unit
        targetDirection = targetDirection.Unit

        local angle = math.acos(math.clamp(currentDirection:Dot(targetDirection), -1, 1))
        local cross = currentDirection:Cross(targetDirection)
        rootPart.RotVelocity = Vector3.new(0, cross.Y * angle * BodyLock.TurnSpeed, 0)
    end))
end

local function setupCharacter(newCharacter)
    character = newCharacter
    rootPart = newCharacter:WaitForChild("HumanoidRootPart", 10)
    humanoid = newCharacter:WaitForChild("Humanoid", 10)

    if BodyLock.Enabled then
        task.delay(0.3, start)
    end
end

if LocalPlayer.Character then
    task.spawn(setupCharacter, LocalPlayer.Character)
end

charConn = LocalPlayer.CharacterAdded:Connect(setupCharacter)

BodyLock.Start = start
BodyLock.Stop = stop
BodyLock.Toggle = function(enabled)
    if enabled == nil then
        enabled = not BodyLock.Enabled
    end

    if enabled then
        start()
    else
        stop()
    end

    if VisualSetters and VisualSetters.BodyLock then
        pcall(VisualSetters.BodyLock, BodyLock.Enabled)
    end
    return BodyLock.Enabled
end

_G._VioletteStartBodyLock  = start
_G._VioletteStopBodyLock   = stop
_G._VioletteToggleBodyLock = BodyLock.Toggle

_G._VioletteBodyLockRuntime = {
    Destroy = function()
        stop()
        if charConn then pcall(function() charConn:Disconnect() end) end
        charConn = nil
        _G._VioletteBodyLockRuntime = nil
    end,
}

if _G._VynxBodyLockOn then start() end
end)()

;(function()

local LP = LocalPlayer
local UIS = UserInputService

if _G._VioletteAutoPathRuntime and _G._VioletteAutoPathRuntime.Destroy then
    pcall(_G._VioletteAutoPathRuntime.Destroy)
end

local _conns = {}
local function hubConnect(signal, handler)
    local c = signal:Connect(handler)
    _conns[#_conns + 1] = c
    return c
end

local AP = { L = false, R = false, lRef = nil, rRef = nil }
_G._AutoPath = AP

_G._KawatanPathMode = (_G._KawatanPathMode == "AUTO PLAY") and "AUTO PLAY" or "NORMAL"

local WAYPOINT_ORDER = {"L1", "LEND", "LFINAL", "R1", "REND", "RFINAL"}
local WAYPOINT_DEFAULTS = {
    L1     = Vector3.new(-474.92, -7.29,  94.61),
    LEND   = Vector3.new(-481.07, -5.33,  94.88),
    LFINAL = Vector3.new(-471.56, -6.83,   6.73),
    R1     = Vector3.new(-474.75, -7.29,  25.36),
    REND   = Vector3.new(-481.09, -5.33,  25.49),
    RFINAL = Vector3.new(-470.93, -6.83, 113.65),
}

local NORMAL_L1 = Vector3.new(-476.48, -6.28, 92.73)
local NORMAL_L2 = Vector3.new(-483.12, -4.95, 94.80)
local NORMAL_R1 = Vector3.new(-476.16, -6.52, 25.62)
local NORMAL_R2 = Vector3.new(-483.06, -5.03, 25.48)

local function pathIsAutoPlay()
    if _G._AdaptAutoPlayMode == "Auto Play" then _G._KawatanPathMode = "AUTO PLAY"
    elseif _G._AdaptAutoPlayMode == "Normal" then _G._KawatanPathMode = "NORMAL" end
    return _G._KawatanPathMode == "AUTO PLAY"
end

local function getHRP()
    local char = LP.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end
local function getHum()
    local char = LP.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end
local function flatTo(root, target)
    return Vector3.new(target.X - root.Position.X, 0, target.Z - root.Position.Z)
end

local function speedPair()
    local n, c = Spd.Values()
    return tonumber(n) or 60, tonumber(c) or 29
end
local function autoRouteSpeed() local n = speedPair(); return n end
local function forwardSpeed()   local n = speedPair(); return n end
local function returnSpeed()    local _, c = speedPair(); return c end

local function routeStep(target)
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 then return false, nil end
    local offset = Vector3.new(target.X - root.Position.X, 0, target.Z - root.Position.Z)
    if offset.Magnitude <= 1 then return true, root end
    local direction = offset.Unit
    local speed = autoRouteSpeed()
    _G._RaVeLiveSpeed = {v = speed, t = os.clock()}
    local velocity = root.AssemblyLinearVelocity
    humanoid:Move(direction, false)
    root.AssemblyLinearVelocity =
        Vector3.new(direction.X * speed, velocity.Y, direction.Z * speed)
    return false, root
end

local function tryAutoRouteSteal()
    local hook = _G._RaVeTryAutoRouteSteal
    if type(hook) == "function" then pcall(hook) end
end

local function clearAutoRouteMotion()
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid:Move(Vector3.zero, false) end
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
end

local WAYPOINT_FILE = "KawatanAutoPathWaypoints.json"
local Waypoints = {}
for key, value in pairs(WAYPOINT_DEFAULTS) do Waypoints[key] = value end
_G._KawatanAutoPathWaypoints = Waypoints

local function saveWaypoints()
    if not writefile then return end
    local plain = {}
    for _, key in ipairs(WAYPOINT_ORDER) do
        local v = Waypoints[key]
        plain[key] = {x = v.X, y = v.Y, z = v.Z}
    end
    local ok, json = pcall(function() return HttpService:JSONEncode(plain) end)
    if ok then pcall(writefile, WAYPOINT_FILE, json) end
end

local function loadWaypoints()
    if not (isfile and isfile(WAYPOINT_FILE)) then return end
    local ok, data = pcall(readfile, WAYPOINT_FILE)
    if not ok then return end
    local ok2, saved = pcall(function() return HttpService:JSONDecode(data) end)
    if not (ok2 and type(saved) == "table") then return end
    for _, key in ipairs(WAYPOINT_ORDER) do
        local entry = saved[key]
        if type(entry) == "table" and tonumber(entry.x) and tonumber(entry.y) and tonumber(entry.z) then
            Waypoints[key] = Vector3.new(tonumber(entry.x), tonumber(entry.y), tonumber(entry.z))
        end
    end
end
pcall(loadWaypoints)

_G._KawatanAutoPathSetWaypoint = function(key, position)
    if not Waypoints[key] then return false end
    position = position or (getHRP() and getHRP().Position)
    if not position then return false end
    Waypoints[key] = position
    saveWaypoints()
    return true
end
_G._KawatanAutoPathResetWaypoints = function()
    for key, value in pairs(WAYPOINT_DEFAULTS) do Waypoints[key] = value end
    saveWaypoints()
end

local SPEED_MAX_ACCEL       = 1600
local SPEED_DECEL_RESPONSE  = 24
local SPEED_TURN_RESPONSE   = 34

local speedLV, speedAttachment
local smoothedVelocity    = Vector2.zero
local lastTargetMagnitude = 0

local function destroySpeedActuator()
    if speedLV then
        pcall(function()
            speedLV.PlaneVelocity = Vector2.zero
            speedLV.Enabled = false
            speedLV:Destroy()
        end)
    end
    if speedAttachment then pcall(function() speedAttachment:Destroy() end) end
    speedLV, speedAttachment = nil, nil
    smoothedVelocity = Vector2.zero
    lastTargetMagnitude = 0
end

local function getSpeedActuator(root)
    if not (root and root.Parent) then return nil end
    if not (speedLV and speedLV.Parent == root) then
        destroySpeedActuator()
        speedAttachment = root:FindFirstChild("VilonPathAttachment")
        if not (speedAttachment and speedAttachment:IsA("Attachment")) then
            speedAttachment = Instance.new("Attachment")
            speedAttachment.Name = "VilonPathAttachment"
            speedAttachment.Parent = root
        end
        speedLV = root:FindFirstChild("VilonPathLinearVelocity")
        if not (speedLV and speedLV:IsA("LinearVelocity")) then
            speedLV = Instance.new("LinearVelocity")
            speedLV.Name = "VilonPathLinearVelocity"
            speedLV.Parent = root
        end
        speedLV.Attachment0 = speedAttachment
        speedLV.RelativeTo = Enum.ActuatorRelativeTo.World
        speedLV.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
        speedLV.PrimaryTangentAxis = Vector3.new(1, 0, 0)
        speedLV.SecondaryTangentAxis = Vector3.new(0, 0, 1)
        speedLV.ForceLimitsEnabled = true
        speedLV.ForceLimitMode = Enum.ForceLimitMode.PerAxis
        speedLV.PlaneVelocity = Vector2.zero
    end
    local force = math.max(root.AssemblyMass, 1) * SPEED_MAX_ACCEL
    speedLV.MaxPlanarAxesForce = Vector2.new(force, force)
    return speedLV
end

local function driveTowards(root, humanoid, moveDir, speed, dt)
    local lv = getSpeedActuator(root)
    if not lv then return end
    dt = math.clamp(dt or (1 / 60), 1 / 240, 1 / 30)
    local target = Vector2.new(moveDir.X * speed, moveDir.Z * speed)
    local magnitude = target.Magnitude
    if magnitude > lastTargetMagnitude + 0.01
        or (magnitude >= 0.01 and smoothedVelocity.Magnitude < 0.01) then
        smoothedVelocity = target
    else
        local response = SPEED_DECEL_RESPONSE
        if magnitude >= 0.01 and smoothedVelocity.Magnitude >= 0.01 then
            response = smoothedVelocity.Unit:Dot(target.Unit) < 0.96
                and SPEED_TURN_RESPONSE or SPEED_DECEL_RESPONSE
        end
        smoothedVelocity = smoothedVelocity:Lerp(target, 1 - math.exp(-response * dt))
    end
    lastTargetMagnitude = magnitude
    _G._RaVeLiveSpeed = {v = speed, t = os.clock()}
    pcall(function() humanoid:Move(Vector3.zero, false) end)
    lv.Enabled = true
    lv.PlaneVelocity = smoothedVelocity
end

local function haltMovement(root, humanoid)
    smoothedVelocity = Vector2.zero
    lastTargetMagnitude = 0
    if humanoid then pcall(function() humanoid:Move(Vector3.zero, false) end) end
    if speedLV and speedLV.Parent then
        pcall(function()
            speedLV.PlaneVelocity = Vector2.zero
            speedLV.Enabled = false
        end)
    end
end

local movementLock = {
    active = false, controls = nil, jumpConn = nil, watchdog = nil,
    originalMoveFunction = nil, usedDisableFallback = false,
}
local function noopMove() end

local function getPlayerControls()
    local ok, controls = pcall(function()
        local ps = LP:FindFirstChild("PlayerScripts")
        local pm = ps and ps:FindFirstChild("PlayerModule")
        if not pm then return nil end
        return require(pm):GetControls()
    end)
    return ok and controls or nil
end

local function applyMoveLock(controls)
    if not controls then return false end
    if controls.moveFunction == nil then return false end
    if controls.moveFunction ~= noopMove then
        movementLock.originalMoveFunction = controls.moveFunction
    end
    controls.moveFunction = noopMove
    return true
end

local function unlockMovement()
    if not movementLock.active then return end
    movementLock.active = false
    if movementLock.jumpConn then
        movementLock.jumpConn:Disconnect()
        movementLock.jumpConn = nil
    end
    movementLock.watchdog = nil
    local controls = movementLock.controls or getPlayerControls()
    if controls then
        pcall(function()
            if controls.moveFunction == noopMove then
                controls.moveFunction = movementLock.originalMoveFunction or LP.Move
            end
            if movementLock.usedDisableFallback then controls:Enable() end
        end)
    end
    movementLock.originalMoveFunction = nil
    movementLock.usedDisableFallback = false
    movementLock.controls = nil
end

local function lockMovement()
    if movementLock.active then return end
    movementLock.active = true
    movementLock.controls = getPlayerControls()
    movementLock.usedDisableFallback = false

    local ok = true
    if movementLock.controls then
        ok = false
        pcall(function() ok = applyMoveLock(movementLock.controls) end)
    end

    if not ok then
        movementLock.usedDisableFallback = true
        if movementLock.controls then
            pcall(function() movementLock.controls:Disable() end)
        end
        movementLock.jumpConn = UIS.JumpRequest:Connect(function()
            if not movementLock.active then return end
            local humanoid = getHum()
            if humanoid and humanoid.Health > 0 then humanoid.Jump = true end
        end)
    end

    local token = {}
    movementLock.watchdog = token
    task.spawn(function()
        while movementLock.active and movementLock.watchdog == token do
            if not (AP.L or AP.R) then unlockMovement() break end
            local controls = movementLock.controls
            if not controls then
                controls = getPlayerControls()
                movementLock.controls = controls
            end
            if controls then
                pcall(function()
                    if movementLock.usedDisableFallback then
                        controls:Disable()
                    else
                        applyMoveLock(controls)
                    end
                end)
            end
            task.wait(0.2)
        end
    end)
end

local orientConstraint = {
    hiddenPart = nil, targetAttach = nil, alignOrient = nil,
    charAttach = nil, charAttachOwned = false, originalAutoRotate = true,
}

local function cleanupOrientConstraint()
    if orientConstraint.hiddenPart then
        pcall(function() orientConstraint.hiddenPart:Destroy() end)
    end
    if orientConstraint.charAttachOwned and orientConstraint.charAttach
        and orientConstraint.charAttach.Parent then
        pcall(function() orientConstraint.charAttach:Destroy() end)
    end
    local humanoid = getHum()
    if humanoid and orientConstraint.originalAutoRotate ~= nil then
        pcall(function() humanoid.AutoRotate = orientConstraint.originalAutoRotate end)
    end
    orientConstraint.originalAutoRotate = nil
    orientConstraint.alignOrient = nil
    orientConstraint.targetAttach = nil
    orientConstraint.hiddenPart = nil
    orientConstraint.charAttach = nil
    orientConstraint.charAttachOwned = false
end

local function setupOrientConstraint()
    local root, humanoid = getHRP(), getHum()
    if not root or not humanoid then return end
    cleanupOrientConstraint()

    local hiddenPart = Instance.new("Part")
    hiddenPart.Name = "TerrainHelper"
    hiddenPart.Anchored = true
    hiddenPart.CanCollide, hiddenPart.CanQuery, hiddenPart.CanTouch = false, false, false
    hiddenPart.Transparency = 1
    hiddenPart.Size = Vector3.new(0.1, 0.1, 0.1)
    hiddenPart.CFrame = CFrame.new(0, -1000, 0)
    hiddenPart.Parent = workspace:FindFirstChild("Terrain") or workspace

    local targetAttach = Instance.new("Attachment")
    targetAttach.Name = "RootAttachment"
    targetAttach.Parent = hiddenPart

    local charAttach = root:FindFirstChild("RootRigAttachment")
    local charAttachOwned = false
    if not charAttach then
        charAttach = Instance.new("Attachment")
        charAttach.Name = "RootRigAttachment"
        charAttach.Parent = root
        charAttachOwned = true
    end

    local alignOrient = Instance.new("AlignOrientation")
    alignOrient.Name = "PhysicsConstraint"
    alignOrient.Mode = Enum.OrientationAlignmentMode.OneAttachment
    alignOrient.Attachment0 = charAttach
    alignOrient.CFrame = CFrame.lookAt(root.Position, root.Position + Vector3.new(-1, 0, 0))
    alignOrient.MaxTorque = math.huge
    alignOrient.MaxAngularVelocity = 90
    alignOrient.Responsiveness = 10
    alignOrient.RigidityEnabled = false
    alignOrient.PrimaryAxisOnly = false
    alignOrient.Parent = hiddenPart

    orientConstraint.hiddenPart = hiddenPart
    orientConstraint.targetAttach = targetAttach
    orientConstraint.charAttach = charAttach
    orientConstraint.charAttachOwned = charAttachOwned
    orientConstraint.alignOrient = alignOrient
    orientConstraint.originalAutoRotate = humanoid.AutoRotate
    humanoid.AutoRotate = false
end

local function updateOrientConstraint(root)
    local ao = orientConstraint.alignOrient
    if ao and ao.Parent and root then
        ao.CFrame = CFrame.lookAt(root.Position, root.Position + Vector3.new(-1, 0, 0))
    end
end

local function engageAssists()
    lockMovement()
    local ok = pcall(setupOrientConstraint)
    if not ok then
        pcall(cleanupOrientConstraint)
        unlockMovement()
        return false
    end
    return true
end
local function releaseAssists()
    unlockMovement()
    cleanupOrientConstraint()
end

hubConnect(LP.CharacterRemoving, function()
    if AP.L then pcall(function() AP.stopL() end) end
    if AP.R then pcall(function() AP.stopR() end) end
    pcall(releaseAssists)
end)

hubConnect(LP.CharacterAdded, function()
    destroySpeedActuator()
    if not (AP.L or AP.R) then pcall(releaseAssists) end
end)

local alConn, arConn = nil, nil
local alPhase, arPhase = 1, 1

AP.stopL = function()
    if alConn then alConn:Disconnect(); alConn = nil end
    alPhase = 1
    AP.L = false
    haltMovement(getHRP(), getHum())
    clearAutoRouteMotion()
    destroySpeedActuator()
    if not AP.R then releaseAssists() end
    if AP.lRef and AP.lRef.SetVisual then AP.lRef.SetVisual(false) end
end

AP.stopR = function()
    if arConn then arConn:Disconnect(); arConn = nil end
    arPhase = 1
    AP.R = false
    haltMovement(getHRP(), getHum())
    clearAutoRouteMotion()
    destroySpeedActuator()
    if not AP.L then releaseAssists() end
    if AP.rRef and AP.rRef.SetVisual then AP.rRef.SetVisual(false) end
end

AP.startL = function()
    if alConn then alConn:Disconnect() end
    alPhase = 1
    AP.L = true
    if pathIsAutoPlay() then engageAssists() end
    alConn = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function(dt)
        if not AP.L then return end
        local root, humanoid = getHRP(), getHum()
        if not root or not humanoid then return end
        if pathIsAutoPlay() then updateOrientConstraint(root) end

        if not pathIsAutoPlay() then
            local reached, hit = routeStep(alPhase == 1 and NORMAL_L1 or NORMAL_L2)
            if not reached then return end
            if alPhase == 1 then alPhase = 2 return end
            if hit then hit.CFrame = CFrame.new(hit.Position) end
            tryAutoRouteSteal()
            AP.stopL()
            return
        end

        if alPhase == 1 then
            local d = flatTo(root, Waypoints.L1)
            if d.Magnitude < 1 then alPhase = 2 return end
            driveTowards(root, humanoid, d.Unit, forwardSpeed(), dt)

        elseif alPhase == 2 then
            local d = flatTo(root, Waypoints.LEND)
            if d.Magnitude < 1 then
                alPhase = 0
                haltMovement(root, humanoid)
                task.delay(0.2, function() if AP.L then alPhase = 3 end end)
                return
            end
            driveTowards(root, humanoid, d.Unit, forwardSpeed(), dt)

        elseif alPhase == 0 then
            return

        elseif alPhase == 3 then
            local d = flatTo(root, Waypoints.L1)
            if d.Magnitude < 1 then alPhase = 4 return end
            driveTowards(root, humanoid, d.Unit, returnSpeed(), dt)

        elseif alPhase == 4 then
            local d = flatTo(root, Waypoints.LFINAL)
            if d.Magnitude < 1 then
                haltMovement(root, humanoid)
                AP.stopL()
                return
            end
            driveTowards(root, humanoid, d.Unit, returnSpeed(), dt)
        end
    end))
end

AP.startR = function()
    if arConn then arConn:Disconnect() end
    arPhase = 1
    AP.R = true
    if pathIsAutoPlay() then engageAssists() end
    arConn = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function(dt)
        if not AP.R then return end
        local root, humanoid = getHRP(), getHum()
        if not root or not humanoid then return end
        if pathIsAutoPlay() then updateOrientConstraint(root) end

        if not pathIsAutoPlay() then
            local reached, hit = routeStep(arPhase == 1 and NORMAL_R1 or NORMAL_R2)
            if not reached then return end
            if arPhase == 1 then arPhase = 2 return end
            if hit then
                hit.CFrame = CFrame.new(hit.Position) * CFrame.Angles(0, math.rad(180), 0)
            end
            tryAutoRouteSteal()
            AP.stopR()
            return
        end

        if arPhase == 1 then
            local d = flatTo(root, Waypoints.R1)
            if d.Magnitude < 1 then arPhase = 2 return end
            driveTowards(root, humanoid, d.Unit, forwardSpeed(), dt)

        elseif arPhase == 2 then
            local d = flatTo(root, Waypoints.REND)
            if d.Magnitude < 1 then
                arPhase = 0
                haltMovement(root, humanoid)
                task.delay(0.2, function() if AP.R then arPhase = 3 end end)
                return
            end
            driveTowards(root, humanoid, d.Unit, forwardSpeed(), dt)

        elseif arPhase == 0 then
            return

        elseif arPhase == 3 then
            local d = flatTo(root, Waypoints.R1)
            if d.Magnitude < 1 then arPhase = 4 return end
            driveTowards(root, humanoid, d.Unit, returnSpeed(), dt)

        elseif arPhase == 4 then
            local d = flatTo(root, Waypoints.RFINAL)
            if d.Magnitude < 1 then
                haltMovement(root, humanoid)
                AP.stopR()
                return
            end
            driveTowards(root, humanoid, d.Unit, returnSpeed(), dt)
        end
    end))
end

local function safeBlocked()
    if _G._RaVeSafeMode and _G._RaVeSafeMode.IsLocked then
        local ok, locked = pcall(_G._RaVeSafeMode.IsLocked)
        if ok and locked then
            pcall(_G._RaVeSafeMode.ForceStop)
            return true
        end
    end
    return false
end

local function setAutoLeft(on)
    if on and safeBlocked() then return end
    if on then
        if AP.R then AP.stopR() end
        AP.startL()
    else
        AP.stopL()
    end
end
local function setAutoRight(on)
    if on and safeBlocked() then return end
    if on then
        if AP.L then AP.stopL() end
        AP.startR()
    else
        AP.stopR()
    end
end

_G._VynxStartFullAutoLeft  = function() setAutoLeft(true)   end
_G._VynxStopFullAutoLeft   = function() setAutoLeft(false)  end
_G._VynxStartFullAutoRight = function() setAutoRight(true)  end
_G._VynxStopFullAutoRight  = function() setAutoRight(false) end
_G._VynxToggleAutoLeft     = function() setAutoLeft(not AP.L)  end
_G._VynxToggleAutoRight    = function() setAutoRight(not AP.R) end
_G._AdaptSetAutoLeft  = setAutoLeft
_G._AdaptSetAutoRight = setAutoRight

_G._VynxOnPathModeChanged = function()
    setAutoLeft(false)
    setAutoRight(false)
    pathIsAutoPlay()
end

hubConnect(UIS.InputBegan, function(input, gp)
    if gp then return end
    if not _isBindableInput(input) then return end
    if waitingForKey then return end
    local kc = input.KeyCode
    if Keybinds.AutoLeft and Keybinds.AutoLeft ~= Enum.KeyCode.Unknown
        and kc == Keybinds.AutoLeft then
        setAutoLeft(not AP.L)
    elseif Keybinds.AutoRight and Keybinds.AutoRight ~= Enum.KeyCode.Unknown
        and kc == Keybinds.AutoRight then
        setAutoRight(not AP.R)
    end
end)

_G._VioletteAutoPathActive = function()
    return AP.L == true or AP.R == true
end

_G._VioletteAutoPathRuntime = {
    Destroy = function()
        pcall(AP.stopL); pcall(AP.stopR)
        pcall(releaseAssists)
        destroySpeedActuator()
        for _, c in ipairs(_conns) do pcall(function() c:Disconnect() end) end
        _conns = {}
        _G._VioletteAutoPathRuntime = nil
    end,
}
end)()

;(function()

    local LP = LocalPlayer

    if _G._VioletteRagdollCDRuntime and _G._VioletteRagdollCDRuntime.Destroy then
        pcall(_G._VioletteRagdollCDRuntime.Destroy)
    end

    local _conns = {}
    local function hubConnect(signal, handler)
        local c = signal:Connect(handler)
        _conns[#_conns + 1] = c
        return c
    end

    local HIT_TIME    = 2.6
    local MEDUSA_TIME = 4.5

    local lbl = nil

    local function accent()
        return _G._VioletteAccent or _G._AdaptESPColor or Color3.fromRGB(46, 166, 255)
    end

    local function buildTag(char)
        if not char then return end
        local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 5)
        if not head then return end
        local old = head:FindFirstChild("RaVeRagdollBB")
        if old then old:Destroy() end

        local bb = Instance.new("BillboardGui", head)
        bb.Name           = "RaVeRagdollBB"
        bb.Size           = UDim2.new(0, 120, 0, 44)
        bb.StudsOffset    = Vector3.new(0, 4.4, 0)
        bb.AlwaysOnTop    = true
        bb.ResetOnSpawn   = false
        bb.LightInfluence = 0

        local t = Instance.new("TextLabel", bb)
        t.Size                   = UDim2.new(1, 0, 1, 0)
        t.BackgroundTransparency = 1
        t.Text                   = ""
        t.Font                   = Enum.Font.GothamBlack
        t.TextScaled             = true
        t.TextColor3             = Color3.fromRGB(255, 255, 255)
        t.TextStrokeTransparency = 0
        t.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
        local g = Instance.new("UIGradient", t)
        g.Name  = "CDTint"
        g.Color = ColorSequence.new(accent())
        lbl = t
    end

    if LP.Character then buildTag(LP.Character) end
    hubConnect(LP.CharacterAdded, function(char)
        task.wait(0.3)
        pcall(function() buildTag(char) end)
    end)

    _G._VioletteRefreshRagdollCDColor = function()
        if lbl and lbl.Parent then
            local g = lbl:FindFirstChild("CDTint")
            if g then g.Color = ColorSequence.new(accent()) end
        end
    end

    local function isMedusa(char)
        if not char then return false end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart")
                and part.Anchored
                and (part.Name == "HumanoidRootPart" or part.Transparency == 1) then
                return true
            end
        end
        return false
    end

    local function isDown(hum)
        if not hum then return false end
        local st = hum:GetState()
        return hum.PlatformStand
            or st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown
    end

    local function hasRagdollMarker(char, hum)
        if isDown(hum) then return true end
        for _, holder in ipairs({char, hum}) do
            for _, name in ipairs({"Ragdoll", "Ragdolled", "IsRagdolled", "Stun", "Stunned"}) do
                local attr = holder:GetAttribute(name)
                if attr == true or (type(attr) == "number" and attr > 0) then return true end
                local value = holder:FindFirstChild(name, true)
                if value and value:IsA("BoolValue") and value.Value then return true end
                if value and (value:IsA("NumberValue") or value:IsA("IntValue")) and value.Value > 0 then return true end
            end
        end
        local endTime = LP:GetAttribute("RagdollEndTime")
        if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then return true end
        return false
    end

    local active, locked, wasTriggered = false, false, false
    local startedAt, endsAt, total, goUntil = 0, 0, HIT_TIME, 0

    hubConnect(RunService.Heartbeat, LPH_NO_VIRTUALIZE(function()
        local char = LP.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")

        _G._RaVeRagdollCountdown = _G._VynxRagdollCountdown == true
        if _G._VynxRagdollCountdown ~= true then
            if lbl and lbl.Parent and lbl.Text ~= "" then lbl.Text = "" end
            active, locked, wasTriggered, goUntil = false, false, false, 0
            return
        end

        if not lbl or not lbl.Parent then
            if char then pcall(function() buildTag(char) end) end
            return
        end

        if not hum or not root or hum.Health <= 0 then
            if active then active = false; lbl.Text = "" end
            return
        end

        local now       = tick()
        local medusa    = isMedusa(char)
        local triggered = hasRagdollMarker(char, hum) or medusa

        if triggered and not wasTriggered and not active and not locked then
            active    = true
            total     = medusa and MEDUSA_TIME or HIT_TIME
            startedAt = now
            endsAt    = startedAt + total
            lbl.Text  = string.format("%.1f", total)
        elseif active and medusa and total ~= MEDUSA_TIME then
            total  = MEDUSA_TIME
            endsAt = startedAt + total
        end

        wasTriggered = triggered
        if not triggered and not active then locked = false end

        if active then
            local left = endsAt - now
            if left <= 0 then
                active   = false
                locked   = true
                lbl.Text = "GO"
                goUntil  = now + 0.65
            else
                lbl.Text = string.format("%.1f", left)
            end
        elseif goUntil > 0 and now >= goUntil then
            lbl.Text = ""
            goUntil  = 0
        end
    end))

    _G._RaVeRagdollTimer = {
        setTimes = function(hit, medusa)
            if type(hit)    == "number" then HIT_TIME    = hit end
            if type(medusa) == "number" then MEDUSA_TIME = medusa end
        end,
    }

    _G._VioletteRagdollCDRuntime = {
        Destroy = function()
            for _, c in ipairs(_conns) do pcall(function() c:Disconnect() end) end
            _conns = {}
            local char = LP.Character
            local head = char and char:FindFirstChild("Head")
            local bb = head and head:FindFirstChild("RaVeRagdollBB")
            if bb then pcall(function() bb:Destroy() end) end
            lbl = nil
            _G._VioletteRagdollCDRuntime = nil
        end,
    }
end)()


;(function()

    local SoundService = game:GetService("SoundService")
    local TweenService = game:GetService("TweenService")

    _G._VioletteIntroSongOrder = {
        "Off",
        "Song 1", "Song 2", "Song 3", "Song 4", "Song 5", "Song 6",
        "Song 7", "Song 8", "Song 9", "Song 10", "Song 11", "Song 12",
        "Song 13", "Song 14", "Song 15", "Song 16",
    }

    _G._VioletteIntroSongs = {
        ["Song 1"]  = { url = "https://files.catbox.moe/rcgr9f.mp3", file = "VioletteIntroSong_rcgr9f.mp3" },
        ["Song 2"]  = { url = "https://files.catbox.moe/18dpz9.mp3", file = "VioletteIntroSong_18dpz9.mp3" },
        ["Song 3"]  = { url = "https://files.catbox.moe/2obj4i.mp3", file = "VioletteIntroSong_2obj4i.mp3" },
        ["Song 4"]  = { url = "https://files.catbox.moe/dqcahr.mp3", file = "VioletteIntroSong_dqcahr.mp3" },
        ["Song 5"]  = { url = "https://files.catbox.moe/pza10u.mp3", file = "VioletteIntroSong_pza10u.mp3" },
        ["Song 6"]  = { url = "https://files.catbox.moe/ul7tt5.mp3", file = "VioletteIntroSong_ul7tt5.mp3" },
        ["Song 7"]  = { url = "https://files.catbox.moe/fhwgff.mp3", file = "VioletteIntroSong_fhwgff.mp3" },
        ["Song 8"]  = { url = "https://files.catbox.moe/kq5dc7.mp3", file = "VioletteIntroSong_kq5dc7.mp3" },
        ["Song 9"]  = { url = "https://files.catbox.moe/9tcnu0.mp3", file = "VioletteIntroSong_9tcnu0.mp3" },
        ["Song 10"] = { url = "https://files.catbox.moe/k3loa6.mp3", file = "VioletteIntroSong_k3loa6.mp3" },
        ["Song 11"] = { url = "https://files.catbox.moe/fri8xn.mp3", file = "VioletteIntroSong_fri8xn.mp3" },
        ["Song 12"] = { url = "https://files.catbox.moe/d3krby.mp3", file = "VioletteIntroSong_d3krby.mp3" },
        ["Song 13"] = { url = "https://files.catbox.moe/pvx0up.mp3", file = "VioletteIntroSong_pvx0up.mp3" },
        ["Song 14"] = { url = "https://files.catbox.moe/bsnqf4.mp3", file = "VioletteIntroSong_bsnqf4.mp3" },
        ["Song 15"] = { url = "https://files.catbox.moe/ob69m0.mp3", file = "VioletteIntroSong_ob69m0.mp3" },
        ["Song 16"] = { url = "https://files.catbox.moe/jrppsj.mp3", file = "VioletteIntroSong_jrppsj.mp3" },
    }

    local INTRO_VOLUME = 0.65
    local MAX_PLAY     = 10

    if not _G._VioletteIntroSongs[_G._VioletteIntroSong] and _G._VioletteIntroSong ~= "Off" then
        _G._VioletteIntroSong = "Song 1"
    end
    _G._VioletteIntroSongCache = _G._VioletteIntroSongCache or {}
    _G._VioletteIntroSongToken = _G._VioletteIntroSongToken or 0

    _G._VioletteStopIntroSong = function()
        _G._VioletteIntroSongToken = (_G._VioletteIntroSongToken or 0) + 1
        local snd = _G._VioletteIntroSound
        _G._VioletteIntroSound = nil
        if snd then
            pcall(function() snd:Stop() end)
            pcall(function() snd:Destroy() end)
        end
    end

    _G._VioletteFadeIntroSong = function(dur)
        dur = tonumber(dur) or 0.42
        local snd = _G._VioletteIntroSound
        _G._VioletteIntroSongToken = (_G._VioletteIntroSongToken or 0) + 1
        _G._VioletteIntroSound = nil
        if not snd then return end
        pcall(function()
            TweenService:Create(snd, TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Volume = 0}):Play()
        end)
        task.delay(dur + 0.05, function()
            pcall(function() snd:Stop() end)
            pcall(function() snd:Destroy() end)
        end)
    end

    _G._VioletteGetIntroSongAsset = function(name)
        local entry = _G._VioletteIntroSongs[name]
        if not entry then return nil end
        if _G._VioletteIntroSongCache[name] then return _G._VioletteIntroSongCache[name] end

        local asset = getcustomasset or getsynasset
        if type(asset) ~= "function" or type(writefile) ~= "function" then return nil end

        local onDisk = false
        pcall(function()
            onDisk = type(isfile) == "function" and isfile(entry.file) and true or false
        end)
        if not onDisk then
            local ok, body = pcall(function() return game:HttpGet(entry.url) end)
            if not ok or type(body) ~= "string" or #body == 0 then return nil end
            if not pcall(writefile, entry.file, body) then return nil end
        end

        local ok, id = pcall(asset, entry.file)
        if not ok or not id then return nil end
        _G._VioletteIntroSongCache[name] = id
        return id
    end

    _G._ViolettePlayIntroSong = function(name, preview)
        _G._VioletteStopIntroSong()
        if name == nil then name = _G._VioletteIntroSong end
        if name == "Off" then _G._VioletteIntroSong = "Off"; return end
        if not _G._VioletteIntroSongs[name] then return end
        _G._VioletteIntroSong = name

        local token = _G._VioletteIntroSongToken
        task.spawn(function()
            local id = _G._VioletteGetIntroSongAsset(name)
            if token ~= _G._VioletteIntroSongToken or not id then return end
            local snd = Instance.new("Sound")
            snd.Name    = preview and "VioletteIntroPreview" or "VioletteIntroMusic"
            snd.SoundId = id
            snd.Volume  = INTRO_VOLUME
            snd.Looped  = false
            snd.Parent  = SoundService
            _G._VioletteIntroSound = snd
            pcall(function() snd:Play() end)
            task.delay(MAX_PLAY - 1, function()
                if token == _G._VioletteIntroSongToken then _G._VioletteFadeIntroSong(1) end
            end)
        end)
    end

    _G._RaVeIntroSong         = _G._VioletteIntroSong
    _G._RaVeIntroSongOrder    = _G._VioletteIntroSongOrder
    _G._RaVeIntroSongs        = _G._VioletteIntroSongs
    _G._RaVePlayIntroSong     = _G._ViolettePlayIntroSong
    _G._RaVeStopIntroSong     = _G._VioletteStopIntroSong
    _G._RaVeGetIntroSongAsset = _G._VioletteGetIntroSongAsset
end)()


;(function()

    local Players       = game:GetService("Players")
    local RunService    = game:GetService("RunService")
    local UIS           = game:GetService("UserInputService")
    local TweenService  = game:GetService("TweenService")
    local NetworkClient  = game:GetService("NetworkClient")
    local LP = Players.LocalPlayer

    local isPhone = UIS.TouchEnabled and not UIS.KeyboardEnabled
    local _cam0 = workspace.CurrentCamera
    local _vp0  = _cam0 and _cam0.ViewportSize or Vector2.new(1280, 720)
    local isSmall = isPhone and math.min(_vp0.X, _vp0.Y) < 600

    local function accent() return _G._VioletteAccent or Color3.fromRGB(235, 235, 235) end
    local function isGamepad(input)
        local t = input.UserInputType
        return t == Enum.UserInputType.Gamepad1 or t == Enum.UserInputType.Gamepad2
            or t == Enum.UserInputType.Gamepad3 or t == Enum.UserInputType.Gamepad4
    end

    local C_CARD    = Color3.fromRGB(15, 15, 19)
    local C_KEY     = Color3.fromRGB(27, 27, 33)
    local C_CTRL    = Color3.fromRGB(22, 22, 27)
    local C_LINE    = Color3.fromRGB(46, 46, 56)
    local C_DIM     = Color3.fromRGB(150, 150, 160)
    local C_TXT     = Color3.fromRGB(238, 238, 242)

    _G._VioletteDuelLagger  = _G._VioletteDuelLagger  or { enabled = false, mode = "LOW", key = "T", scale = 1.0, minimized = false, locked = false }
    if not _G._VioletteDuelLagger.mode then _G._VioletteDuelLagger.mode = "LOW" end
    if not tonumber(_G._VioletteDuelLagger.scale) then _G._VioletteDuelLagger.scale = 1.0 end
    _G._VioletteSpeedBypass = _G._VioletteSpeedBypass or { enabled = false, power = 100000, key = nil }
    if not tonumber(_G._VioletteSpeedBypass.power) then _G._VioletteSpeedBypass.power = 100000 end
    _G._VioletteSpeedBypass.power = math.clamp(math.floor(_G._VioletteSpeedBypass.power), 10000, 150000)
    _G._ViolettePingLagger  = _G._ViolettePingLagger  or { enabled = false, speed = 100000, interval = 0.125, autoBrainrot = false, key = nil }
    _G._ViolettePanelOpen   = _G._ViolettePanelOpen   or {}
    _G._ViolettePanelPos    = _G._ViolettePanelPos    or {}

    local function blockRemote()
        local rrs = game:FindFirstChild("RobloxReplicatedStorage")
        if not rrs then return nil end
        for _, name in ipairs({ "SetPlayerBlockList", "UpdatePlayerBlockList", "SetBlockList", "UpdateBlockList" }) do
            local r = rrs:FindFirstChild(name)
            if r and r:IsA("RemoteEvent") then return r end
        end
        for _, c in ipairs(rrs:GetChildren()) do
            if c:IsA("RemoteEvent") and c.Name:find("Block") then return c end
        end
        return nil
    end
    local function fireBlockList(payload)
        local r = blockRemote()
        if not r then return false end
        return pcall(function() r:FireServer(payload) end)
    end

    local SB_DEPTH = 90
    local SB_DELAY = 0.12
    local sbState = { running = false, thread = nil, bomb = nil }
    local function sbBuild(power, depth)
        local maintable = {}
        local spammed = { {} }
        local z = spammed[1]
        for _ = 1, depth do local t = {}; table.insert(z, t); z = t end
        local maximum = math.floor((power or 100000) / (depth + 2))
        for _ = 1, maximum do table.insert(maintable, spammed) end
        return maintable
    end
    local function sbFire(bomb)
        local rrs = game:FindFirstChild("RobloxReplicatedStorage")
        local direct = rrs and rrs:FindFirstChild("SetPlayerBlockList")
        if direct then
            pcall(function() direct:FireServer(bomb) end)
        else
            fireBlockList(bomb)
        end
    end
    local function sbStop()
        if not sbState.running then return end
        sbState.running = false
        if sbState.thread then pcall(function() task.cancel(sbState.thread) end); sbState.thread = nil end
        sbState.bomb = nil
        pcall(function() NetworkClient:SetOutgoingKBPSLimit(0) end)
    end
    local function sbStart()
        if sbState.running then return end
        sbState.running = true
        pcall(function() NetworkClient:SetOutgoingKBPSLimit(math.huge) end)
        local power = math.clamp(tonumber(_G._VioletteSpeedBypass and _G._VioletteSpeedBypass.power) or 100000, 10000, 150000)
        sbState.bomb = sbBuild(power, SB_DEPTH)
        sbState.thread = task.spawn(function()
            while sbState.running do
                if sbState.bomb then sbFire(sbState.bomb) end
                task.wait(SB_DELAY)
            end
        end)
    end
    _G._VioletteSpeedBypassApply = function(on) if on then sbStart() else sbStop() end end

    local DL_MODES = { "LOW", "MID", "HIGH", "ULTRA" }
    local DL_IS_PC = UIS.KeyboardEnabled and UIS.MouseEnabled and not UIS.TouchEnabled
    local DL_PC = {
        ULTRA = { amt = 270, waitTime = 0.25 },
        HIGH  = { amt = 210, waitTime = 0.30 },
        MID   = { amt = 140, waitTime = 0.42 },
        LOW   = { amt = 100, waitTime = 0.55 },
    }
    local DL_MOBILE = {
        ULTRA = { power = 115, waitTime = 0.14 },
        HIGH  = { power =  48, waitTime = 0.15 },
        MID   = { power =  38, waitTime = 0.16 },
        LOW   = { power =  28, waitTime = 0.18 },
    }
    local dlThread = nil
    local function dlBombPC(amt)
        local main, spam = {}, { {} }
        local z = spam[1]
        for _ = 1, amt do local t = {}; table.insert(z, t); z = t end
        local max = math.min(499999 / (amt + 2), 1500)
        for _ = 1, max do table.insert(main, spam) end
        fireBlockList(main)
    end
    local function dlBombMobile(power)
        local payload, nested = {}, { {} }
        local ptr = nested[1]
        for _ = 1, 25 do local t = {}; table.insert(ptr, t); ptr = t end
        local maxIter = math.min(16000, power * 60)
        for _ = 1, maxIter do table.insert(payload, nested) end
        fireBlockList(payload)
    end
    local function dlStop()
        if dlThread then pcall(function() task.cancel(dlThread) end); dlThread = nil end
    end
    local function dlStart()
        dlStop()
        dlThread = task.spawn(function()
            while _G._VioletteDuelLagger.enabled do
                local mode = _G._VioletteDuelLagger.mode or "LOW"
                if DL_IS_PC then
                    local cfg = DL_PC[mode] or DL_PC.LOW
                    pcall(function() NetworkClient:SetOutgoingKBPSLimit(math.huge) end)
                    dlBombPC(cfg.amt)
                    task.wait(cfg.waitTime)
                else
                    local cfg = DL_MOBILE[mode] or DL_MOBILE.LOW
                    pcall(function() NetworkClient:SetOutgoingKBPSLimit(80000) end)
                    dlBombMobile(cfg.power)
                    task.wait(cfg.waitTime)
                end
            end
            dlThread = nil
        end)
    end
    _G._VioletteDuelLaggerApply = function(on)
        if on then dlStart() else dlStop() end
    end

    local plState = { running = false, remote = nil }
    local plBrainrotMode, plLastBrainrot, plManualOverride = false, false, false
    local function plFindRemote() return blockRemote() end
    local function plPayload(power)
        local main = {}
        local nested = { {} }
        local current = nested[1]
        for _ = 1, 186 do local t = {}; table.insert(current, t); current = t end
        local maxRep = math.min(math.floor((power or 100000) / 188), 10000)
        for _ = 1, maxRep do table.insert(main, nested) end
        return main
    end
    local function plLoop()
        local st = _G._ViolettePingLagger
        local delay = tonumber(st and st.interval) or 0.125
        while plState.running do
            if not (plState.remote and plState.remote.Parent) then plState.remote = plFindRemote() end
            if not plState.remote then break end
            local ok = pcall(function()
                plState.remote:FireServer(plPayload(tonumber(st and st.speed) or 100000))
            end)
            if ok then delay = math.max(delay * 0.995, 0.05) else delay = math.min(delay * 1.5, 0.5) end
            task.wait(delay)
        end
        plState.running = false
    end
    local function plStart()
        if plState.running then return end
        plState.remote = plFindRemote()
        if not plState.remote then return false end
        plState.running = true
        task.spawn(plLoop)
        return true
    end
    local function plStop() plState.running = false end

    _G._ViolettePingLaggerFlip = function(state, isManual)
        state = state == true
        local st = _G._ViolettePingLagger
        if isManual then
            plManualOverride = plBrainrotMode and not state or false
        end
        st.enabled = state
        if state then
            if plStart() == false then st.enabled = false end
        else
            plStop()
        end
        if _G._ViolettePingLaggerRefresh then pcall(_G._ViolettePingLaggerRefresh) end
    end
    _G._ViolettePingLaggerApply = function(on) _G._ViolettePingLaggerFlip(on, false) end

    RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
        local st = _G._ViolettePingLagger
        if not st or not st.autoBrainrot or _G._ViolettePanelOpen.pingLagger ~= true then
            if plBrainrotMode then plBrainrotMode, plLastBrainrot = false, false end
            return
        end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local hasBrainrot = hum.WalkSpeed < 25
        if hasBrainrot and not plLastBrainrot then
            plBrainrotMode, plLastBrainrot, plManualOverride = true, true, false
            _G._ViolettePingLaggerFlip(true, false)
        elseif not hasBrainrot and plLastBrainrot then
            plBrainrotMode, plLastBrainrot, plManualOverride = false, false, false
            _G._ViolettePingLaggerFlip(false, false)
        end
    end))

    local PANEL_W = isSmall and 190 or 232
    local ROW_H   = 34
    local pnlRefresh = {}
    local pnlHomes   = {}
    local panelList  = {}

    local function corner(o, r) local c = Instance.new("UICorner", o); c.CornerRadius = UDim.new(0, r); return c end
    local function stroke(o, col, th, tr)
        local s = Instance.new("UIStroke", o)
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.Color = col; s.Thickness = th or 1; s.Transparency = tr or 0.4
        return s
    end
    local function glow(o, pad)
        local g = Instance.new("ImageLabel", o)
        g.Name = "Glow"
        g.BackgroundTransparency = 1
        g.Image = "rbxassetid://5028857084"
        g.ImageColor3 = accent()
        g.ImageTransparency = 0.82
        g.ScaleType = Enum.ScaleType.Slice
        g.SliceCenter = Rect.new(24, 24, 276, 276)
        g.Size = UDim2.new(1, (pad or 12) * 2, 1, (pad or 12) * 2)
        g.Position = UDim2.new(0, -(pad or 12), 0, -(pad or 12))
        g.ZIndex = 55
        return g
    end

    local function pnlDrag(frame, handle, key)
        local held, from, start, ref
        pnlHomes[key] = { frame = frame, home = frame.Position }
        local saved = _G._ViolettePanelPos and _G._ViolettePanelPos[key]
        if type(saved) == "table" and #saved == 4 then
            frame.Position = UDim2.new(saved[1], saved[2], saved[3], saved[4])
        end
        handle.InputBegan:Connect(function(p)
            local t = p.UserInputType
            if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
                held, from, start, ref = true, p.Position, frame.Position, p
            end
        end)
        UIS.InputChanged:Connect(function(p)
            if not held then return end
            if p.UserInputType == Enum.UserInputType.MouseMovement or p == ref then
                local dl = p.Position - from
                frame.Position = UDim2.new(start.X.Scale, start.X.Offset + dl.X, start.Y.Scale, start.Y.Offset + dl.Y)
            end
        end)
        UIS.InputEnded:Connect(function(p)
            if held and (p == ref or p.UserInputType == Enum.UserInputType.MouseButton1 or p.UserInputType == Enum.UserInputType.Touch) then
                held, ref = false, nil
                local la = frame.Position
                _G._ViolettePanelPos = _G._ViolettePanelPos or {}
                _G._ViolettePanelPos[key] = { la.X.Scale, la.X.Offset, la.Y.Scale, la.Y.Offset }
                if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
            end
        end)
    end

    local function newPanel(key, titleText, anchorX, anchorY, onClose)
        local gui = Instance.new("ScreenGui")
        gui.Name = "ViolettePanel_" .. key
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Enabled = false
        if _G._VioletteMountOnTop then _G._VioletteMountOnTop(gui, 999998) else gui.Parent = LP:WaitForChild("PlayerGui") end

        local card = Instance.new("Frame", gui)
        card.Name = "Panel"
        card.AnchorPoint = Vector2.new(0.5, 0.5)
        card.Position = UDim2.new(0.5, anchorX, 0.5, anchorY or 0)
        card.Size = UDim2.fromOffset(PANEL_W, 60)
        card.BackgroundColor3 = C_CARD
        card.BorderSizePixel = 0
        card.AutomaticSize = Enum.AutomaticSize.Y
        card.ZIndex = 60
        corner(card, 12)
        local cardStroke = stroke(card, C_LINE, 1, 0.35)
        local pad = Instance.new("UIPadding", card)
        pad.PaddingTop = UDim.new(0, 12); pad.PaddingBottom = UDim.new(0, 12)
        pad.PaddingLeft = UDim.new(0, 12); pad.PaddingRight = UDim.new(0, 12)
        local list = Instance.new("UIListLayout", card)
        list.Padding = UDim.new(0, 8); list.SortOrder = Enum.SortOrder.LayoutOrder

        local bar = Instance.new("Frame", card)
        bar.Name = "TitleBar"; bar.BackgroundTransparency = 1
        bar.Size = UDim2.new(1, 0, 0, 22); bar.LayoutOrder = 0; bar.ZIndex = 61
        local dragBtn = Instance.new("TextButton", bar)
        dragBtn.BackgroundTransparency = 1; dragBtn.Text = ""; dragBtn.AutoButtonColor = false
        dragBtn.Size = UDim2.fromScale(1, 1); dragBtn.ZIndex = 61
        pnlDrag(card, dragBtn, key)
        local title = Instance.new("TextLabel", bar)
        title.BackgroundTransparency = 1
        title.Size = UDim2.new(1, 0, 1, 0)
        title.Text = titleText
        title.TextColor3 = C_TXT
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Center
        title.ZIndex = 62

        local body
        local collapse = Instance.new("TextButton", bar)
        collapse.Name = "Collapse"; collapse.AnchorPoint = Vector2.new(0, 0.5)
        collapse.Position = UDim2.new(0, 0, 0.5, 0)
        collapse.Size = UDim2.fromOffset(20, 20)
        collapse.BackgroundColor3 = C_KEY; collapse.BorderSizePixel = 0; collapse.AutoButtonColor = false
        collapse.Text = "\u{2212}"; collapse.TextColor3 = accent()
        collapse.Font = Enum.Font.GothamBlack; collapse.TextSize = 15; collapse.ZIndex = 63
        corner(collapse, 6)
        local closeBtn = Instance.new("TextButton", bar)
        closeBtn.Name = "Close"; closeBtn.AnchorPoint = Vector2.new(1, 0.5)
        closeBtn.Position = UDim2.new(1, 0, 0.5, 0)
        closeBtn.Size = UDim2.fromOffset(20, 20)
        closeBtn.BackgroundColor3 = C_KEY; closeBtn.BorderSizePixel = 0; closeBtn.AutoButtonColor = false
        closeBtn.Text = "X"; closeBtn.TextColor3 = C_TXT
        closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 11; closeBtn.ZIndex = 63
        corner(closeBtn, 6)

        body = Instance.new("Frame", card)
        body.Name = "Body"; body.BackgroundTransparency = 1
        body.Size = UDim2.new(1, 0, 0, 0); body.AutomaticSize = Enum.AutomaticSize.Y
        body.LayoutOrder = 2; body.ZIndex = 60
        local bodyList = Instance.new("UIListLayout", body)
        bodyList.Padding = UDim.new(0, 8); bodyList.SortOrder = Enum.SortOrder.LayoutOrder
        Instance.new("UIPadding", body).PaddingTop = UDim.new(0, 8)

        local collapsed = false
        collapse.MouseButton1Click:Connect(function()
            collapsed = not collapsed
            body.Visible = not collapsed
            collapse.Text = collapsed and "+" or "\u{2212}"
        end)
        closeBtn.MouseButton1Click:Connect(function()
            gui.Enabled = false
            _G._ViolettePanelOpen[key] = false
            if onClose then pcall(onClose) end
            if _G._VioletteSyncPanelBtn then pcall(_G._VioletteSyncPanelBtn, key) end
            if _G._VioletteRefreshPanelBtns then pcall(_G._VioletteRefreshPanelBtns) end
            if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
        end)

        local lit = false
        local function setLit(on)
            lit = on == true
            cardStroke.Color = lit and accent() or C_LINE
            cardStroke.Transparency = lit and 0.1 or 0.35
            cardStroke.Thickness = lit and 1.6 or 1
        end

        table.insert(pnlRefresh, function()
            collapse.TextColor3 = accent()
            local g = card:FindFirstChild("Glow"); if g then g.ImageColor3 = accent() end
            setLit(lit)
        end)

        return gui, body, card, setLit
    end

    local function addPower(card, order, onFlip, setLit)
        local btn = Instance.new("TextButton", card)
        btn.Name = "PowerButton"
        btn.Size = UDim2.new(1, 0, 0, 34); btn.LayoutOrder = order
        btn.BackgroundColor3 = C_CTRL; btn.BorderSizePixel = 0; btn.AutoButtonColor = false
        btn.Text = "Enable"; btn.TextColor3 = C_DIM
        btn.Font = Enum.Font.GothamBold; btn.TextSize = 14; btn.ZIndex = 61
        corner(btn, 9)
        local bStroke = stroke(btn, C_LINE, 1, 0.5)
        local api = {}
        function api.SetVisual(on)
            btn.Text = on and "Disable" or "Enable"
            TweenService:Create(btn, TweenInfo.new(0.14), {
                BackgroundColor3 = on and accent() or C_CTRL,
                TextColor3 = on and Color3.fromRGB(0, 0, 0) or C_DIM,
            }):Play()
            bStroke.Color = on and accent() or C_LINE
            bStroke.Transparency = on and 0.1 or 0.5
            if setLit then setLit(on) end
        end
        btn.MouseButton1Click:Connect(onFlip)
        table.insert(pnlRefresh, function() if api.Refresh then api.Refresh() end end)
        return api, btn
    end

    local function addRow(parent, order, labelText, chipW)
        local row = Instance.new("Frame", parent)
        row.Name = labelText; row.Size = UDim2.new(1, 0, 0, ROW_H); row.LayoutOrder = order
        row.BackgroundColor3 = C_KEY; row.BorderSizePixel = 0; row.ZIndex = 61
        corner(row, 8)
        local rowStroke = stroke(row, C_LINE, 1, 0.55)
        local label = Instance.new("TextLabel", row)
        label.BackgroundTransparency = 1; label.Position = UDim2.fromOffset(10, 0)
        label.Size = UDim2.new(1, -(chipW + 20), 1, 0)
        label.Text = labelText; label.TextColor3 = C_TXT
        label.Font = Enum.Font.GothamMedium; label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left; label.ZIndex = 62
        table.insert(pnlRefresh, function() rowStroke.Color = C_LINE end)
        return row
    end

    local function addChip(row, chipW, text, editable)
        local chip
        if editable then
            chip = Instance.new("TextBox", row); chip.ClearTextOnFocus = false
        else
            chip = Instance.new("TextButton", row); chip.AutoButtonColor = false
        end
        chip.Name = "Chip"; chip.AnchorPoint = Vector2.new(1, 0.5)
        chip.Position = UDim2.new(1, -8, 0.5, 0)
        chip.Size = UDim2.fromOffset(chipW, 22)
        chip.BackgroundColor3 = accent(); chip.BorderSizePixel = 0
        chip.Text = text; chip.TextColor3 = Color3.fromRGB(0, 0, 0)
        chip.Font = Enum.Font.GothamBold; chip.TextSize = 11; chip.ZIndex = 63
        chip.TextScaled = true; chip.ClipsDescendants = true
        do local c = Instance.new("UITextSizeConstraint", chip); c.MaxTextSize = 11; c.MinTextSize = 6 end
        corner(chip, 7)
        table.insert(pnlRefresh, function() chip.BackgroundColor3 = accent() end)
        return chip
    end

    local function panelTag(st)
        if st == _G._VioletteDuelLagger  then return "panel:duelLagger"
        elseif st == _G._ViolettePingLagger  then return "panel:pingLagger"
        elseif st == _G._VioletteSpeedBypass then return "panel:speedBypass" end
        return nil
    end
    local panelKeyDraws = {}

    local function bindKey(chip, state, onPress)
        local function draw()
            local kc = state.key and Enum.KeyCode[state.key]
            chip.Text = kc and _G._VioletteKeyName(kc) or "None"
        end
        draw()
        panelKeyDraws[#panelKeyDraws + 1] = draw
        chip.MouseButton1Click:Connect(function()
            chip.Text = "..."
            if _G._VioletteBeginKeyCapture then _G._VioletteBeginKeyCapture() end
            local conn; conn = UIS.InputBegan:Connect(function(i, g)
                if not (i.UserInputType == Enum.UserInputType.Keyboard or isGamepad(i)) then return end
                local kc = i.KeyCode
                if kc == Enum.KeyCode.Escape then
                    draw(); if _G._VioletteEndKeyCapture then _G._VioletteEndKeyCapture() end; conn:Disconnect(); return
                end
                if kc == Enum.KeyCode.Backspace then
                    state.key = nil; draw()
                    if _G._VioletteEndKeyCapture then _G._VioletteEndKeyCapture() end
                    conn:Disconnect()
                    if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
                    return
                end
                if kc == Enum.KeyCode.Unknown then return end
                state.key = kc.Name
                if _G._AdaptKeybindSteal then pcall(_G._AdaptKeybindSteal, kc, panelTag(state)) end
                draw()
                if _G._VioletteEndKeyCapture then _G._VioletteEndKeyCapture() end
                conn:Disconnect()
                if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
            end)
        end)
        panelList[#panelList + 1] = { state = state, onPress = onPress }
        return draw
    end

    _G._VioletteRefreshAllPanelKeys = function()
        for _, d in ipairs(panelKeyDraws) do pcall(d) end
    end

    do
        local st = _G._VioletteDuelLagger
        local gui, body, card, setLit = newPanel("duelLagger", "Duel Lagger", -270, 0, function()
            st.enabled = false
        end)

        local power, drawKey
        local function flip(force)
            local want = force
            if want == nil then want = not st.enabled end
            if want and not gui.Enabled then want = false end
            st.enabled = want
            power.SetVisual(st.enabled)
            pcall(_G._VioletteDuelLaggerApply, st.enabled)
            if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
        end

        local modeRow = Instance.new("Frame", body)
        modeRow.Name = "Modes"; modeRow.LayoutOrder = 1
        modeRow.BackgroundTransparency = 1
        modeRow.Size = UDim2.new(1, 0, 0, 30)
        local ml = Instance.new("UIListLayout", modeRow)
        ml.FillDirection = Enum.FillDirection.Horizontal
        ml.SortOrder = Enum.SortOrder.LayoutOrder
        ml.VerticalAlignment = Enum.VerticalAlignment.Center
        ml.Padding = UDim.new(0, 5)
        local modeBtns = {}
        local function refreshModes()
            for _, m in ipairs(DL_MODES) do
                local b = modeBtns[m]
                if b then
                    local on = (m == st.mode)
                    b.BackgroundColor3 = on and accent() or C_KEY
                    b.TextColor3 = on and Color3.fromRGB(0, 0, 0) or C_DIM
                end
            end
        end
        for i, m in ipairs(DL_MODES) do
            local b = Instance.new("TextButton", modeRow)
            b.LayoutOrder = i
            b.Size = UDim2.new(0.25, -4, 1, 0)
            b.BackgroundColor3 = C_KEY; b.BorderSizePixel = 0; b.AutoButtonColor = false
            b.Text = m; b.TextColor3 = C_DIM
            b.Font = Enum.Font.GothamBold; b.TextSize = 11; b.ZIndex = 62
            corner(b, 8); stroke(b, C_LINE, 1, 0.6)
            modeBtns[m] = b
            b.MouseEnter:Connect(function()
                if st.mode ~= m then b.BackgroundColor3 = C_CTRL; b.TextColor3 = C_TXT end
            end)
            b.MouseLeave:Connect(function()
                if st.mode ~= m then b.BackgroundColor3 = C_KEY; b.TextColor3 = C_DIM end
            end)
            b.MouseButton1Click:Connect(function()
                if st.mode == m then return end
                st.mode = m
                refreshModes()
                if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
            end)
        end
        table.insert(pnlRefresh, refreshModes)

        power = addPower(card, 1, function() flip() end, setLit)

        local keyRow = addRow(body, 3, "Keybind", 62)
        local keyChip = addChip(keyRow, 62, "None", false)
        drawKey = bindKey(keyChip, st, function() flip() end)

        power.Refresh = function() power.SetVisual(st.enabled) end
        power.SetVisual(st.enabled)
        refreshModes()

        _G._VioletteShowDuelLagger = function(on)
            gui.Enabled = on == true
            if not gui.Enabled then flip(false) end
        end
        _G._VioletteDuelLaggerRefresh = function()
            drawKey(); refreshModes(); power.SetVisual(st.enabled)
        end
    end

    do
        local st = _G._ViolettePingLagger
        local gui, body, card, setLit = newPanel("pingLagger", "Ping Lagger", 0, 0, function()
            st.enabled = false
        end)
        local power, drawKey
        local function flip(force)
            local want = force
            if want == nil then want = not st.enabled end
            if want and not gui.Enabled then want = false end
            pcall(_G._ViolettePingLaggerFlip, want, true)
            power.SetVisual(st.enabled)
            if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
        end
        power = addPower(card, 1, function() flip() end, setLit)
        local powRow = addRow(body, 1, "Power", 72)
        local powChip = addChip(powRow, 72, tostring(st.speed), true)
        powChip.FocusLost:Connect(function()
            local n = tonumber(powChip.Text)
            if n then st.speed = math.clamp(math.floor(n), 1000, 500000) end
            powChip.Text = tostring(st.speed)
            if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
        end)
        local delRow = addRow(body, 2, "Delay", 72)
        local delChip = addChip(delRow, 72, tostring(st.interval), true)
        delChip.FocusLost:Connect(function()
            local n = tonumber(delChip.Text)
            if n then st.interval = math.clamp(n, 0.01, 1) end
            delChip.Text = tostring(st.interval)
            if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
        end)
        local autoRow = addRow(body, 3, "Auto Brainrot", 52)
        local autoChip = addChip(autoRow, 52, st.autoBrainrot and "ON" or "OFF", false)
        autoChip.MouseButton1Click:Connect(function()
            st.autoBrainrot = not st.autoBrainrot
            autoChip.Text = st.autoBrainrot and "ON" or "OFF"
            if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
        end)
        local keyRow = addRow(body, 4, "Keybind", 62)
        local keyChip = addChip(keyRow, 62, "None", false)
        drawKey = bindKey(keyChip, st, function() flip() end)
        power.Refresh = function() power.SetVisual(st.enabled) end
        power.SetVisual(st.enabled)
        _G._VioletteShowPingLagger = function(on)
            gui.Enabled = on == true
            if not gui.Enabled then flip(false) end
        end
        _G._ViolettePingLaggerRefresh = function()
            drawKey()
            powChip.Text = tostring(st.speed)
            delChip.Text = tostring(st.interval)
            autoChip.Text = st.autoBrainrot and "ON" or "OFF"
            power.SetVisual(st.enabled)
        end
    end

    do
        local st = _G._VioletteSpeedBypass
        local gui, body, card, setLit = newPanel("speedBypass", "Speed Bypass", 270, 0, function()
            st.enabled = false
        end)
        local power, drawKey
        local function flip(force)
            local want = force
            if want == nil then want = not st.enabled end
            if want and not gui.Enabled then want = false end
            st.enabled = want
            power.SetVisual(st.enabled)
            pcall(_G._VioletteSpeedBypassApply, st.enabled)
            if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
        end
        power = addPower(card, 1, function() flip() end, setLit)
        local powRow = addRow(body, 1, "Power", 72)
        local powChip = addChip(powRow, 72, tostring(st.power), true)
        powChip.FocusLost:Connect(function()
            local n = tonumber(powChip.Text)
            st.power = n and math.clamp(math.floor(n), 10000, 150000) or 100000
            powChip.Text = tostring(st.power)
            if st.enabled then
                pcall(_G._VioletteSpeedBypassApply, false)
                pcall(_G._VioletteSpeedBypassApply, true)
            end
            if _G.KRIXSaveNow then pcall(_G.KRIXSaveNow) end
        end)
        local keyRow = addRow(body, 2, "Keybind", 62)
        local keyChip = addChip(keyRow, 62, "None", false)
        drawKey = bindKey(keyChip, st, function() flip() end)
        power.Refresh = function() power.SetVisual(st.enabled) end
        power.SetVisual(st.enabled)
        _G._VioletteShowSpeedBypass = function(on)
            gui.Enabled = on == true
            flip(false)
        end
        _G._VioletteSpeedBypassRefresh = function()
            drawKey(); powChip.Text = tostring(st.power); power.SetVisual(st.enabled)
        end
    end

    _G._VioletteShowPanel = function(key, on)
        if on and _G._VioletteIntroActive then
            _G._ViolettePanelOpen[key] = true
            return
        end
        if key == "duelLagger"  and _G._VioletteShowDuelLagger  then _G._VioletteShowDuelLagger(on)
        elseif key == "pingLagger"  and _G._VioletteShowPingLagger  then _G._VioletteShowPingLagger(on)
        elseif key == "speedBypass" and _G._VioletteShowSpeedBypass then _G._VioletteShowSpeedBypass(on) end
    end

    _G._VioletteRefreshPanels = function()
        for _, fn in ipairs(pnlRefresh) do pcall(fn) end
    end
    _G._VioletteResetPanels = function()
        _G._ViolettePanelPos = {}
        for _, nh in pairs(pnlHomes) do pcall(function() nh.frame.Position = nh.home end) end
        for _, key in ipairs({ "duelLagger", "pingLagger", "speedBypass" }) do
            _G._ViolettePanelOpen[key] = false
            pcall(_G._VioletteShowPanel, key, false)
        end
        if _G._VioletteRefreshPanelBtns then pcall(_G._VioletteRefreshPanelBtns) end
    end

    _G._VioletteRevealPanels = function()
        local queue = {
            { "duelLagger", _G._ViolettePanelOpen.duelLagger == true },
            { "pingLagger", _G._ViolettePanelOpen.pingLagger == true },
            { "speedBypass", _G._ViolettePanelOpen.speedBypass == true },
        }
        local step = 0
        for _, q in ipairs(queue) do
            if q[2] then
                task.delay(step * 0.12, function() pcall(_G._VioletteShowPanel, q[1], true) end)
                step = step + 1
            else
                pcall(_G._VioletteShowPanel, q[1], false)
            end
        end
        if _G._VioletteRefreshPanels then pcall(_G._VioletteRefreshPanels) end
        if _G._VioletteRefreshPanelBtns then pcall(_G._VioletteRefreshPanelBtns) end
    end

    UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if _G._VioletteKeyCaptureActive and _G._VioletteKeyCaptureActive() then return end
        if not (input.UserInputType == Enum.UserInputType.Keyboard or isGamepad(input)) then return end
        local name = input.KeyCode.Name
        for _, p in ipairs(panelList) do
            if p.state.key and p.state.key == name then pcall(p.onPress) end
        end
    end)

    _G._VioletteCollectPanels = function()
        local dl, sb, pl = _G._VioletteDuelLagger, _G._VioletteSpeedBypass, _G._ViolettePingLagger
        return {
            open = {
                duelLagger  = _G._ViolettePanelOpen.duelLagger == true,
                pingLagger  = _G._ViolettePanelOpen.pingLagger == true,
                speedBypass = _G._ViolettePanelOpen.speedBypass == true,
            },
            pos = _G._ViolettePanelPos,
            keys = { duelLagger = dl.key, speedBypass = sb.key, pingLagger = pl.key },
            bypassPower = sb.power,
            pingSpeed = pl.speed, pingDelay = pl.interval, pingAuto = pl.autoBrainrot == true,
            duelMode = dl.mode, duelScale = dl.scale,
            duelMini = dl.minimized == true, duelLocked = dl.locked == true,
        }
    end
    _G._VioletteRestorePanels = function(saved)
        if type(saved) ~= "table" then return end
        if type(saved.pos) == "table" then
            _G._ViolettePanelPos = saved.pos
            for key, nh in pairs(pnlHomes) do
                local p = saved.pos[key]
                if nh.frame and type(p) == "table" and #p == 4 then
                    nh.frame.Position = UDim2.new(p[1], p[2], p[3], p[4])
                end
            end
        end
        if type(saved.open) == "table" then
            for k, v in pairs(saved.open) do _G._ViolettePanelOpen[k] = v == true end
        end
        local dl, sb, pl = _G._VioletteDuelLagger, _G._VioletteSpeedBypass, _G._ViolettePingLagger
        if type(saved.keys) == "table" then
            dl.key, sb.key, pl.key = saved.keys.duelLagger, saved.keys.speedBypass, saved.keys.pingLagger
        end
        do
            local m = saved.duelMode
            if m == "LOW" or m == "MID" or m == "HIGH" or m == "ULTRA" then dl.mode = m end
            if tonumber(saved.duelScale) then dl.scale = math.clamp(tonumber(saved.duelScale), 0.7, 1.5) end
            dl.minimized = saved.duelMini == true
            dl.locked = saved.duelLocked == true
        end
        if tonumber(saved.bypassPower) then sb.power = math.clamp(math.floor(saved.bypassPower), 10000, 150000) end
        if tonumber(saved.pingSpeed) then pl.speed = math.clamp(math.floor(saved.pingSpeed), 1000, 500000) end
        if tonumber(saved.pingDelay) then pl.interval = math.clamp(saved.pingDelay, 0.01, 1) end
        pl.autoBrainrot = saved.pingAuto == true
        if _G._VioletteDuelLaggerRefresh then pcall(_G._VioletteDuelLaggerRefresh) end
        if _G._ViolettePingLaggerRefresh then pcall(_G._ViolettePingLaggerRefresh) end
        if _G._VioletteSpeedBypassRefresh then pcall(_G._VioletteSpeedBypassRefresh) end
        if _G._VioletteRevealPanels then pcall(_G._VioletteRevealPanels) end
    end
end)()

;(function()

    local LP  = LocalPlayer
    local UIS = UserInputService

    if _G._VioletteCosmeticsRuntime and _G._VioletteCosmeticsRuntime.Destroy then
        pcall(_G._VioletteCosmeticsRuntime.Destroy)
    end

    local _conns = {}
    local function hubConnect(signal, handler)
        local c = signal:Connect(handler)
        _conns[#_conns + 1] = c
        return c
    end
local setVlonESkinEnabled, setVlonEBodyType
do
local VLONE_SKINS = {
    ["1"] = {
        displayName = "1",
        hats = "1744060292,439945661,1125510,1029025",
        hair = "",
        headless = true,
        korblox = "Right",
        accessories = {
            1744060292,
            439945661,
            1125510,
            1029025,
            11748356,
            8465506143,
            11444217173,
        },
        clothing = {
            7424637509,
            7689651773,
        },
    
    },
    ["2"] = {
        displayName = "2",
        hats = "74891470",
        hair = "16630147,6346833550,6594911228,6594919952,6823338112,7097747842",
        headless = true,
        korblox = "Right",
        accessories = {
            74891470,
            16630147,
            6346833550,
            6594911228,
            6594919952,
            6823338112,
            7097747842,
        },
        clothing = {
            18423061209,
            18423154566,
        },
    
    },
    ["3"] = {
        displayName = "3",
        hats = "215718515,439945661",
        hair = "7183785281",
        headless = true,
        korblox = "Right",
        accessories = {
            215718515,
            439945661,
            7183785281,
        },
        clothing = {
            15998365201,
            7689651773,
        },
    
    },
    ["4"] = {
        displayName = "4",
        hats = "10159600649,439946249,17798262442,92482095662016",
        hair = "139101716417676",
        headless = true,
        korblox = "Right",
        accessories = {
            10159600649,
            439946249,
            17798262442,
            92482095662016,
            139101716417676,
            12490213797,
        },
        clothing = {
            18766106994,
            13925390578,
        },
    
    },
    ["5"] = {
        displayName = "5",
        hats = "553970961,1744060292",
        hair = "93268856876777",
        headless = true,
        korblox = "Right",
        accessories = {
            553970961,
            1744060292,
            93268856876777,
        },
        clothing = {
            9478068776,
            6348682339,
        },
    
    },
    ["6"] = {
        hats = "74891470,215718515,439945661,1016143686,1744060292,"
            .. "10159600649,89012651581593,88365652378427",
        hair = "126447390530523",
        headless = true,
        korblox = "Right",
        accessories = {
            74891470,
            215718515,
            439945661,
            1016143686,
            1744060292,
            10159600649,
            89012651581593,
            126447390530523,
        },
        clothing = {
            88032876921227,
            108259950755140,
        },
        displayName = "6",
    
    },
    ["7"] = {
        hats = "", hair = "111149505826763", headless = false, korblox = "Off",
        accessories = { 111149505826763 }, clothing = { 9733132546, 101481154733615 },
        displayName = "7",
    
    },
    ["8"] = {
        hats = "", hair = "111149505826763", headless = false, korblox = "Off",
        accessories = { 111149505826763 }, clothing = { 10796276786, 101481154733615 },
        displayName = "8",
    
    },
    ["9"] = {
        hats = "", hair = "111149505826763", headless = false, korblox = "Off",
        accessories = { 111149505826763 }, clothing = { 8844377623, 101481154733615 },
        displayName = "9",
    
    },
    ["10"] = {
        hats = "", hair = "111149505826763", headless = false, korblox = "Off",
        accessories = { 111149505826763 }, clothing = { 16107371158, 101481154733615 },
        displayName = "10",
    
    },
    ["11"] = {
        hats = "", hair = "111149505826763", headless = false, korblox = "Off",
        accessories = { 111149505826763 }, clothing = { 15970848598, 101481154733615 },
        displayName = "11",
    
    },
    ["12"] = {
        hats = "", hair = "111149505826763", headless = false, korblox = "Off",
        accessories = { 111149505826763 }, clothing = { 8844377623, 101481154733615 },
        displayName = "12",
    
    },
    ["13"] = {
        hats = "17274218093", hair = "", headless = false, korblox = "Off",
        accessories = { 111553288808103, 17274218093, 17387240647 },
        clothing = { 130666125397672, 91321960147976 },
        displayName = "13",
    
    },
    ["14"] = {
        hats = "127788745429250", hair = "", headless = false, korblox = "Off",
        accessories = { 127788745429250, 143803235928952 },
        clothing = { 77038549270215, 16717004839 },
        displayName = "14",
    
    },
    ["15"] = {
        hats = "8261840689", hair = "", headless = true, korblox = "Right",
        accessories = { 8261840689 }, clothing = { 7884186381, 13063157758 },
        displayName = "15",
    
    },
    ["16"] = {
        hats = "91950080535908", hair = "96954292222783", headless = true, korblox = "Right",
        accessories = { 91950080535908, 96954292222783, 17309352545, 132404403424262 },
        clothing = { 9683332649, 13063157758 },
        displayName = "16",
    
    },
    ["17"] = {
        hats = "10997283529", hair = "", headless = true, korblox = "Off",
        accessories = {
            10997283529, 125085889448130,
            115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322,
        },
        clothing = {},
        displayName = "17",
    
    },
    ["18"] = {
        hats = "125157548394108", hair = "", headless = false, korblox = "Off",
        accessories = {
            125157548394108, 123231522991173, 74827642361405,
            115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322,
        },
        clothing = {},
        displayName = "18",
    
    },
    ["19"] = {
        hats = "136644276218918", hair = "", headless = false, korblox = "Off",
        accessories = {
            136644276218918, 132022106987543, 131740907052260,
            115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322,
        },
        clothing = {},
        displayName = "19",
    
    },
    ["20"] = {
        hats = "119331031817124", hair = "", headless = true, korblox = "Off",
        accessories = {
            119331031817124, 84952305140948,
            115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322,
        },
        clothing = {},
        displayName = "20",
    
    },
    ["21"] = {
        hats = "18902416696", hair = "", headless = true, korblox = "Off",
        accessories = {
            18902416696, 17739456422, 116750288839357, 12842417046, 122223069519702,
            115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322,
        },
        clothing = {},
        displayName = "21",
    
    },
    ["22"] = {
        hats = "13935333090", hair = "", headless = false, korblox = "Off",
        accessories = { 13935333090, 16110951997, 10632503818 },
        clothing = {},
        displayName = "22",
    
    },
    ["23"] = {
        hats = "74891470", hair = "", headless = true, korblox = "Off",
        accessories = { 74891470, 4390891467, 91274263831244, 128424248603010, 91151766440767, 17044638424 },
        clothing = {},
        displayName = "23",
    
    },
    ["24"] = {
        hats = "76479271580913", hair = "", headless = true, korblox = "Right",
        accessories = { 76479271580913, 1402432199, 140627490971265, 128912609563885, 17449551560, 5796531729, 139607718 },
        clothing = {},
        displayName = "24",
    
    },
    ["25"] = {
        hats = "", hair = "", headless = false, korblox = "Both",
        accessories = { 70414871864071, 14863917259, 133498027006138, 82277826177074 },
        clothing = {},
        displayName = "25",
    
    },
}
_G._KawatanSkinSets = VLONE_SKINS
_G._KawatanSkinSetOrder = {
    "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25",
}
_G._VlonESkinPreset = "ORIGINAL"
if not VLONE_SKINS[_G._KawatanSkinColor or ""] then _G._KawatanSkinColor = nil end
_G._KawatanSkinColor = _G._KawatanSkinColor or "1"
local function getVlonESkin()
    return VLONE_SKINS[_G._KawatanSkinColor or "1"] or VLONE_SKINS["1"]
end
local KAWATAN_SKIN_COLORS = {}
local function applyKawatanSkinColor(character)
    local char = character or LP.Character
    local tint = KAWATAN_SKIN_COLORS[_G._KawatanSkinColor or "1"]
    if not char or not tint then return end
    for _, object in ipairs(char:GetDescendants()) do
        if object:IsA("BasePart") then
            local current = object
            local belongsToSkin = false
            while current and current ~= char do
                if current:GetAttribute("_VlonESkin") then belongsToSkin = true; break end
                current = current.Parent
            end
            if belongsToSkin then object.Color = tint end
        end
    end
end
_G._KawatanApplySkinColor = applyKawatanSkinColor
local vloneSkinEnabled = false
local vloneSkinToken = 0
local vlonePreviousKorbloxMode = "Off"
local vloneOriginalDescriptions = setmetatable({}, {__mode = "k"})
local vloneAccessoryWatchers = setmetatable({}, {__mode = "k"})
local function isVlonEAccessoryAllowed(assetId)
    local id = tonumber(assetId)
    if not id then return false end
    local skin = getVlonESkin()
    for _, allowed in ipairs(skin.accessories or {}) do if id == allowed then return true end end
    for _, allowed in ipairs(skin.clothing or {}) do if id == allowed then return true end end
    for _, list in ipairs({skin.hats, skin.hair}) do
        for entry in tostring(list or ""):gmatch("%d+") do
            if id == tonumber(entry) then return true end
        end
    end
    return false
end

local function markVlonESkin(instance)
    pcall(function() instance:SetAttribute("_VlonESkin", true) end)
    return instance
end

local function clearVlonESkinObjects(character)
    if not character then return end
    for _, object in ipairs(character:GetDescendants()) do
        if object:GetAttribute("_VlonESkin") then
            pcall(function() object:Destroy() end)
        end
    end
end

local function restoreVlonEBodyTransparency(character)
    if not character then return end
    for _, partName in ipairs({
        "UpperTorso", "LowerTorso", "LeftUpperArm", "LeftLowerArm", "LeftHand",
        "RightUpperArm", "RightLowerArm", "RightHand", "LeftUpperLeg", "LeftLowerLeg",
        "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot",
    }) do
        local part = character:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            part.Transparency = 0
            part.LocalTransparencyModifier = 0
        end
    end
end

clearVlonESkinObjects(LP.Character)
restoreVlonEBodyTransparency(LP.Character)

_G._VlonEBodyType = _G._VlonEBodyType or "OFF"
;(function()
    local SCALE_VALUES = {
        "BodyDepthScale", "BodyHeightScale", "BodyWidthScale",
        "HeadScale", "BodyProportionScale", "BodyTypeScale",
    }
    local BODY_TYPES = {
        WOMAN = {bundle = 239, fallback = {Torso = 86499666, RightArm = 86499698,
            LeftArm = 86499716, LeftLeg = 86499753, RightLeg = 86499793}},
        CLASSIC = {scale = {BodyTypeScale = 0, BodyProportionScale = 0,
            BodyHeightScale = 1, BodyWidthScale = 1, BodyDepthScale = 1,
            HeadScale = 1}},
    }
    _G._KawatanBodyTypes = BODY_TYPES
    _G._KawatanBodyTypeOrder = {"OFF", "WOMAN", "CLASSIC"}
    if _G._VlonEBodyType ~= "OFF" and not BODY_TYPES[_G._VlonEBodyType or ""] then
        _G._VlonEBodyType = "OFF"
    end

    local originalDescriptions = setmetatable({}, {__mode = "k"})
    local originalScales       = setmetatable({}, {__mode = "k"})
    local packageActive        = false
    local scaleToken           = 0

    local function captureOriginal(character)
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        if not originalDescriptions[character] then
            local ok, description = pcall(function() return humanoid:GetAppliedDescription() end)
            if ok and description then originalDescriptions[character] = description:Clone() end
        end
        if not originalScales[character] then
            local scales = {}
            for _, name in ipairs(SCALE_VALUES) do
                local value = humanoid:FindFirstChild(name)
                if value then scales[name] = value.Value end
            end
            originalScales[character] = scales
        end
    end
    _G._KawatanCaptureBody = captureOriginal

    local function getOriginalDescription(character)
        local saved = originalDescriptions[character]
        if saved then return saved:Clone() end
        local ok, description = pcall(function()
            return Players:GetHumanoidDescriptionFromUserId(LP.UserId)
        end)
        if ok and description then return description end
        return nil
    end

    local function writeScales(character, scales)
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid or not scales then return end
        for name, target in pairs(scales) do
            local value = humanoid:FindFirstChild(name)
            if value and value:IsA("NumberValue") and value.Value ~= target then
                pcall(function() value.Value = target end)
            end
        end
    end

    local function watchScales(character, scales)
        scaleToken = scaleToken + 1
        local token = scaleToken
        task.spawn(function()
            while token == scaleToken and character.Parent do
                writeScales(character, scales)
                task.wait(0.5)
            end
        end)
    end

    local function restoreScales(character)
        scaleToken = scaleToken + 1
        writeScales(character, originalScales[character])
    end

    local function resolvePackageParts(spec)
        local result = {}
        for property, id in pairs(spec.fallback or {}) do result[property] = id end
        if not spec.bundle then return result end
        local ok, details = pcall(function()
            return game:GetService("AssetService"):GetBundleDetailsAsync(spec.bundle)
        end)
        if ok and type(details) == "table" then
            local valid = {Torso = true, RightArm = true, LeftArm = true,
                LeftLeg = true, RightLeg = true}
            for _, item in ipairs(details.Items or {}) do
                local property = tostring(item.AssetType or ""):gsub("^Enum%.AvatarAssetType%.", "")
                if valid[property] and item.Id then result[property] = item.Id end
            end
        end
        return result
    end

    local SWAPPABLE = {
        {"UpperTorso", Enum.BodyPartR15.UpperTorso},
        {"LowerTorso", Enum.BodyPartR15.LowerTorso},
        {"LeftUpperLeg", Enum.BodyPartR15.LeftUpperLeg},
        {"LeftLowerLeg", Enum.BodyPartR15.LeftLowerLeg},
        {"LeftFoot", Enum.BodyPartR15.LeftFoot},
        {"RightUpperLeg", Enum.BodyPartR15.RightUpperLeg},
        {"RightLowerLeg", Enum.BodyPartR15.RightLowerLeg},
        {"RightFoot", Enum.BodyPartR15.RightFoot},
    }

    local function buildRig(description)
        local ok, rig = pcall(function()
            return Players:CreateHumanoidModelFromDescriptionAsync(description, Enum.HumanoidRigType.R15)
        end)
        if not ok or not rig then
            ok, rig = pcall(function()
                return Players:CreateHumanoidModelFromDescription(description, Enum.HumanoidRigType.R15)
            end)
        end
        if ok then return rig end
        return nil
    end

    local function reassertCosmetics(character)
        task.defer(function()
            if _G._RaVeKorbloxMode ~= "Off" then
                pcall(_G._RaVeApplyKorblox, _G._RaVeKorbloxMode)
            end
            local wantHeadless = _G._VlonEStandaloneHeadless == true
            if vloneSkinEnabled then
                wantHeadless = wantHeadless or getVlonESkin().headless ~= false
            end
            if wantHeadless and _G._KawatanSetHeadless then
                pcall(_G._KawatanSetHeadless, character, true)
            end
        end)
    end

    local function swapParts(character, humanoid, description)
        local rig = buildRig(description)
        if not rig then return false end
        for _, entry in ipairs(SWAPPABLE) do
            local source = rig:FindFirstChild(entry[1])
            if source and source:IsA("BasePart") then
                local replacement = source:Clone()
                local replaced = false
                pcall(function() replaced = humanoid:ReplaceBodyPartR15(entry[2], replacement) end)
                if not replaced and replacement.Parent == nil then replacement:Destroy() end
            end
        end
        rig:Destroy()
        reassertCosmetics(character)
        return true
    end

    local function restorePackage(character, humanoid)
        if not packageActive then return true end
        local description = getOriginalDescription(character)
        if not description then return false end
        local ok = swapParts(character, humanoid, description)
        if ok then packageActive = false end
        return ok
    end

    local function applyPackage(character, humanoid, spec)
        local description
        pcall(function() description = humanoid:GetAppliedDescription() end)
        if not description then description = getOriginalDescription(character) end
        if not description then return false end
        for property, id in pairs(resolvePackageParts(spec)) do
            pcall(function() description[property] = id end)
        end
        local ok = swapParts(character, humanoid, description)
        if ok then packageActive = true end
        return ok
    end

    setVlonEBodyType = function(mode)
        if mode ~= "OFF" and not BODY_TYPES[mode] then mode = "OFF" end
        _G._VlonEBodyType = mode

        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return false end
        captureOriginal(character)
        if humanoid.RigType ~= Enum.HumanoidRigType.R15 then return false end

        restoreScales(character)
        restorePackage(character, humanoid)
        if mode == "OFF" then
            reassertCosmetics(character)
            return true
        end

        local spec = BODY_TYPES[mode]
        local ok = true
        if spec.bundle then ok = applyPackage(character, humanoid, spec) end
        if spec.scale then
            writeScales(character, spec.scale)
            watchScales(character, spec.scale)
        end
        return ok
    end

    if LP.Character then captureOriginal(LP.Character) end
    hubConnect(LP.CharacterAdded, function(character)
        packageActive = false
        scaleToken = scaleToken + 1
        character:WaitForChild("Humanoid", 5)
        captureOriginal(character)
        if _G._VlonEBodyType ~= "OFF" then
            task.wait(0.5)
            pcall(setVlonEBodyType, _G._VlonEBodyType)
        end
    end)

    task.spawn(function()
        task.wait(1.1)
        if _G._VlonEBodyType and _G._VlonEBodyType ~= "OFF" then
            pcall(setVlonEBodyType, _G._VlonEBodyType)
        end
    end)
end)()

local vloneDescriptionPropertyByAssetType = {
    [8] = "HatAccessory", [41] = "HairAccessory", [42] = "FaceAccessory",
    [43] = "NeckAccessory", [44] = "ShouldersAccessory", [45] = "FrontAccessory",
    [46] = "BackAccessory", [47] = "WaistAccessory", [64] = "TShirtAccessory",
    [65] = "ShirtAccessory", [66] = "PantsAccessory", [67] = "JacketAccessory",
    [68] = "SweaterAccessory", [69] = "ShortsAccessory", [70] = "LeftShoeAccessory",
    [71] = "RightShoeAccessory", [72] = "DressSkirtAccessory",
}

local function attachVlonEAccessory(character, humanoid, accessory)
    if not accessory or not accessory:IsA("Accessory") then return false end
    markVlonESkin(accessory)
    pcall(function() humanoid:AddAccessory(accessory) end)
    if accessory.Parent ~= character then accessory.Parent = character end

    local handle = accessory:FindFirstChild("Handle")
    if not handle or not handle:IsA("BasePart") then return accessory.Parent == character end
    if handle:FindFirstChild("AccessoryWeld") then return true end
    local handleAttachment = handle:FindFirstChildWhichIsA("Attachment")
    if not handleAttachment then return accessory.Parent == character end
    local bodyAttachment
    for _, object in ipairs(character:GetDescendants()) do
        if object:IsA("Attachment") and object.Name == handleAttachment.Name
            and not object:IsDescendantOf(accessory) then
            bodyAttachment = object
            break
        end
    end
    local bodyPart = bodyAttachment and bodyAttachment.Parent
    if bodyPart and bodyPart:IsA("BasePart") then
        handle.Anchored = false
        handle.CanCollide = false
        handle.CanTouch = false
        handle.CanQuery = false
        handle.Massless = true
        handle.CFrame = bodyPart.CFrame * bodyAttachment.CFrame * handleAttachment.CFrame:Inverse()
        local weld = Instance.new("WeldConstraint")
        weld.Name = "VlonEAccessoryWeld"
        weld.Part0, weld.Part1, weld.Parent = bodyPart, handle, handle
    end
    return true
end

local function ensureVlonEHats(character, humanoid)
    local skin = getVlonESkin()
    local description = Instance.new("HumanoidDescription")
    description.HatAccessory = skin.hats or ""
    local rig
    local ok = pcall(function()
        rig = Players:CreateHumanoidModelFromDescription(description, Enum.HumanoidRigType.R15)
    end)
    if not ok or not rig then
        pcall(function()
            rig = Players:CreateHumanoidModelFromDescriptionAsync(description, Enum.HumanoidRigType.R15)
        end)
    end
    description:Destroy()
    if not rig then return false end
    local added = false
    for _, sourceAccessory in ipairs(rig:GetChildren()) do
        if sourceAccessory:IsA("Accessory") then
            local duplicate = character:FindFirstChild(sourceAccessory.Name)
            if not duplicate then
                local clone = sourceAccessory:Clone()
                if attachVlonEAccessory(character, humanoid, clone) then added = true end
            end
        end
    end
    rig:Destroy()
    return added
end

local function addVlonEAssetToDescription(description, assetId)
    local ok, info = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(assetId, Enum.InfoType.Asset)
    end)
    if not ok or not info then return false end
    local assetType = tonumber(info.AssetTypeId)
    if assetType == 11 then
        description.Shirt = assetId
        return true
    elseif assetType == 12 then
        description.Pants = assetId
        return true
    elseif assetType == 2 then
        description.GraphicTShirt = assetId
        return true
    end
    local property = vloneDescriptionPropertyByAssetType[assetType]
    if not property then return false end
    local current = ""
    pcall(function() current = tostring(description[property] or "") end)
    pcall(function()
        description[property] = current == "" and tostring(assetId) or (current .. "," .. tostring(assetId))
    end)
    return true
end

;(function()
    local function idInList(list, id)
        for entry in tostring(list or ""):gmatch("%d+") do
            if tonumber(entry) == id then return true end
        end
        return false
    end
    local PREVIEW_CLEAR = {
        "HatAccessory", "HairAccessory", "FaceAccessory", "NeckAccessory",
        "ShouldersAccessory", "FrontAccessory", "BackAccessory", "WaistAccessory",
        "ShirtAccessory", "PantsAccessory", "JacketAccessory", "SweaterAccessory",
        "ShortsAccessory", "TShirtAccessory", "DressSkirtAccessory",
    }

    _G._KawatanBuildSetDescription = function(setName)
        local skin = VLONE_SKINS[setName]
        if not skin then return nil end

        local base
        pcall(function()
            local humanoid = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then base = humanoid:GetAppliedDescription() end
        end)
        if not base then
            pcall(function() base = Players:GetHumanoidDescriptionFromUserId(LP.UserId) end)
        end

        local description = base and base:Clone() or Instance.new("HumanoidDescription")
        if not base then
            local tone = Color3.fromRGB(204, 142, 105)
            for _, property in ipairs({"HeadColor", "TorsoColor", "LeftArmColor",
                "RightArmColor", "LeftLegColor", "RightLegColor"}) do
                pcall(function() description[property] = tone end)
            end
        end
        for _, property in ipairs(PREVIEW_CLEAR) do
            pcall(function() description[property] = "" end)
        end
        pcall(function() description.Shirt = 0 end)
        pcall(function() description.Pants = 0 end)
        pcall(function() description.GraphicTShirt = 0 end)
        pcall(function()
            description.HatAccessory = skin.hats or ""
            description.HairAccessory = skin.hair or ""
        end)
        for _, assetId in ipairs(skin.accessories or {}) do
            if not idInList(skin.hats, assetId) and not idInList(skin.hair, assetId) then
                pcall(addVlonEAssetToDescription, description, assetId)
            end
        end
        for _, assetId in ipairs(skin.clothing or {}) do
            pcall(addVlonEAssetToDescription, description, assetId)
        end
        return description
    end
end)()

local function addVlonEAsset(character, humanoid, assetId)
    for _, existing in ipairs(character:GetChildren()) do
        if existing:IsA("Accessory") then
            local sameAsset = false
            pcall(function() sameAsset = tonumber(existing.SourceAssetId) == tonumber(assetId) end)
            if sameAsset then return true end
        end
    end
    local ok, objects = pcall(function()
        return game:GetObjects("rbxassetid://" .. tostring(assetId))
    end)
    if not ok or type(objects) ~= "table" or #objects == 0 then
        local loaded
        local insertOk = pcall(function()
            loaded = game:GetService("InsertService"):LoadAsset(assetId)
        end)
        if insertOk and loaded then objects = {loaded} else return false end
    end
    local added = false
    for _, rootObject in ipairs(objects) do
        local candidates = {}
        if rootObject:IsA("Accessory") or rootObject:IsA("Shirt")
            or rootObject:IsA("Pants") or rootObject:IsA("ShirtGraphic") then
            table.insert(candidates, rootObject)
        else
            for _, child in ipairs(rootObject:GetDescendants()) do
                if child:IsA("Accessory") or child:IsA("Shirt")
                    or child:IsA("Pants") or child:IsA("ShirtGraphic") then
                    table.insert(candidates, child)
                end
            end
        end
        for _, candidate in ipairs(candidates) do
            local clone = markVlonESkin(candidate:Clone())
            if clone:IsA("Accessory") then
                attachVlonEAccessory(character, humanoid, clone)
            else
                for _, existing in ipairs(character:GetChildren()) do
                    if existing.ClassName == clone.ClassName then existing:Destroy() end
                end
                clone.Parent = character
            end
            added = true
        end
        pcall(function() rootObject:Destroy() end)
    end
    return added
end

local function addVlonEBodyPart(character, property, assetId)
    local ok, objects = pcall(function()
        return game:GetObjects("rbxassetid://" .. tostring(assetId))
    end)
    if not ok or not objects or not objects[1] then return false end
    local source = objects[1]
    local container = markVlonESkin(Instance.new("Folder"))
    container.Name = "VlonEBody_" .. property
    container.Parent = character
    local matched = false
    local sourceParts = source:IsA("BasePart") and {source} or source:GetDescendants()
    for _, part in ipairs(sourceParts) do
        if part:IsA("BasePart") then
            local target = character:FindFirstChild(part.Name)
            if target and target:IsA("BasePart") and target.Name ~= "HumanoidRootPart" then
                target.Transparency = 1
                local clone = markVlonESkin(part:Clone())
                clone.Anchored = false; clone.CanCollide = false; clone.CanTouch = false
                clone.CanQuery = false; clone.Massless = true; clone.CFrame = target.CFrame
                for _, joint in ipairs(clone:GetDescendants()) do
                    if joint:IsA("JointInstance") or joint:IsA("Constraint") then joint:Destroy() end
                end
                clone.Parent = container
                local weld = Instance.new("WeldConstraint")
                weld.Part0, weld.Part1, weld.Parent = target, clone, clone
                matched = true
            end
        end
    end
    pcall(function() source:Destroy() end)
    if not matched then container:Destroy() end
    return matched
end

local function setVlonEHeadless(character, enabled)
    local head = character and character:FindFirstChild("Head")
    if not head then return end
    local transparency = enabled and 1 or 0
    head.Transparency = transparency
    head.LocalTransparencyModifier = transparency
    for _, object in ipairs(head:GetChildren()) do
        if object:IsA("Decal") or object:IsA("Texture") or object:IsA("BasePart") then
            object.Transparency = transparency
            if object:IsA("BasePart") then object.LocalTransparencyModifier = transparency end
        end
    end
end
_G._KawatanSetHeadless = setVlonEHeadless

local function applyVlonESkin(character)
    local char = character or LP.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    vloneSkinToken = vloneSkinToken + 1
    local token = vloneSkinToken
    restoreVlonEBodyTransparency(char)
    clearVlonESkinObjects(char)

    local original
    pcall(function() original = humanoid:GetAppliedDescription() end)
    if original and not vloneOriginalDescriptions[char] then
        vloneOriginalDescriptions[char] = original:Clone()
    end
    for _, object in ipairs(char:GetChildren()) do
        if object:IsA("Accessory") or object:IsA("Accoutrement") then
            pcall(function() object:Destroy() end)
        end
    end
    if vloneAccessoryWatchers[char] then vloneAccessoryWatchers[char]:Disconnect() end
    vloneAccessoryWatchers[char] = char.ChildAdded:Connect(function(object)
        if not vloneSkinEnabled or not (object:IsA("Accessory") or object:IsA("Accoutrement")) then return end
        task.defer(function()
            if not object.Parent or object:GetAttribute("_VlonESkin") then return end
            local sourceId = 0
            pcall(function() sourceId = tonumber(object.SourceAssetId) or 0 end)
            if not isVlonEAccessoryAllowed(sourceId) then
                pcall(function() object:Destroy() end)
            end
        end)
    end)
    local appliedDescription
    if original then
        local skinDescription = original:Clone()
        for _, property in ipairs({
            "HatAccessory", "HairAccessory", "FaceAccessory", "NeckAccessory",
            "ShouldersAccessory", "FrontAccessory", "BackAccessory", "WaistAccessory",
            "ShirtAccessory", "PantsAccessory", "JacketAccessory", "SweaterAccessory",
            "ShortsAccessory", "TShirtAccessory", "DressSkirtAccessory",
        }) do
            pcall(function() skinDescription[property] = "" end)
        end
        pcall(function() skinDescription.Shirt = 0 end)
        pcall(function() skinDescription.Pants = 0 end)
        pcall(function() skinDescription.GraphicTShirt = 0 end)
        pcall(function()
            skinDescription.HatAccessory = getVlonESkin().hats or ""
            skinDescription.HairAccessory = getVlonESkin().hair or ""
        end)
        for _, assetId in ipairs(getVlonESkin().clothing) do
            pcall(addVlonEAssetToDescription, skinDescription, assetId)
        end

        pcall(function() humanoid:ApplyDescription(skinDescription) end)
    end

    task.wait()
    if not vloneSkinEnabled or token ~= vloneSkinToken or not char.Parent then return false end
    pcall(function() appliedDescription = humanoid:GetAppliedDescription() end)
    for _, assetId in ipairs(getVlonESkin().accessories) do addVlonEAsset(char, humanoid, assetId) end
    pcall(ensureVlonEHats, char, humanoid)
    for _, assetId in ipairs(getVlonESkin().clothing) do addVlonEAsset(char, humanoid, assetId) end
    applyKawatanSkinColor(char)
    task.delay(0.35, function() if char.Parent then applyKawatanSkinColor(char) end end)
    setVlonEHeadless(char, getVlonESkin().headless ~= false
        or _G._VlonEStandaloneHeadless == true)
    local korbloxLegs = getVlonESkin().korblox or "Right"
    if _G._KawatanKorbloxUserSet then
        korbloxLegs = _G._RaVeKorbloxMode or korbloxLegs
    end
    _G._RaVeKorbloxMode = korbloxLegs
    pcall(_G._RaVeApplyKorblox, korbloxLegs)
    if _G._VlonEBodyType ~= "OFF" then task.defer(setVlonEBodyType, _G._VlonEBodyType) end
    return true
end

local function clearVlonESkin(character)
    vloneSkinToken = vloneSkinToken + 1
    local char = character or LP.Character
    if not char then return end
    if vloneAccessoryWatchers[char] then
        vloneAccessoryWatchers[char]:Disconnect()
        vloneAccessoryWatchers[char] = nil
    end
    clearVlonESkinObjects(char)
    restoreVlonEBodyTransparency(char)
    pcall(_G._RaVeClearKorblox)
    _G._RaVeKorbloxMode = vlonePreviousKorbloxMode or "Off"
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local original = vloneOriginalDescriptions[char]
    if humanoid and original then
        local restored = pcall(function() humanoid:ApplyDescriptionClientServer(original:Clone()) end)
        if not restored then restored = pcall(function() humanoid:ApplyDescriptionReset(original:Clone()) end) end
        if not restored then pcall(function() humanoid:ApplyDescription(original:Clone()) end) end
    end
    local keepHeadless = _G._VlonEStandaloneHeadless == true
    setVlonEHeadless(char, keepHeadless)
    if keepHeadless then task.delay(0.25, function() setVlonEHeadless(char, true) end) end
    if _G._RaVeKorbloxMode ~= "Off" then
        task.delay(0.2, function() pcall(_G._RaVeApplyKorblox, _G._RaVeKorbloxMode) end)
    end
end

setVlonESkinEnabled = function(on)
    if on and not vloneSkinEnabled then
        vlonePreviousKorbloxMode = _G._RaVeKorbloxMode or "Off"
    end
    vloneSkinEnabled = on and true or false
    if vloneSkinEnabled then
        task.spawn(applyVlonESkin, LP.Character)
    else
        clearVlonESkin(LP.Character)
    end
end

hubConnect(LP.CharacterAdded, function(character)
    if not vloneSkinEnabled then return end
    character:WaitForChild("Humanoid", 3)
    if vloneSkinEnabled then task.spawn(applyVlonESkin, character) end
end)
end

    _G._VioletteSetCustomSkin = function(on) return setVlonESkinEnabled(on) end
    _G._VioletteSetBodyType   = function(mode) return setVlonEBodyType(mode) end

    _G._VioletteCosmeticsRuntime = {
        Destroy = function()
            for _, c in ipairs(_conns) do pcall(function() c:Disconnect() end) end
            _conns = {}
            _G._VioletteCosmeticsRuntime = nil
        end,
    }
end)()


;(function()

    local LP  = LocalPlayer
    local UIS = UserInputService

    if _G._VioletteSkinGalleryRuntime and _G._VioletteSkinGalleryRuntime.Destroy then
        pcall(_G._VioletteSkinGalleryRuntime.Destroy)
    end

    local _conns = {}
    local function hubConnect(signal, handler)
        local c = signal:Connect(handler)
        _conns[#_conns + 1] = c
        return c
    end
;(function()
    local function new(class, props, kids)
        local o = Instance.new(class)
        for k, v in pairs(props or {}) do o[k] = v end
        for _, c in ipairs(kids or {}) do c.Parent = o end
        return o
    end
    local function corner(r) return new("UICorner", {CornerRadius = UDim.new(0, r)}) end
    local function stroke(c, t, tr)
        return new("UIStroke", {Color = c, Thickness = t or 1, Transparency = tr or 0,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
    end
    local Q = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local function tw(o, ti, p)
        if typeof(o) ~= "Instance" then return end
        TweenService:Create(o, ti, p):Play()
    end
    local CAT_ACCENT = Color3.fromRGB(254, 254, 254)
    local CAT_PANEL  = Color3.fromRGB(18, 18, 18)
    local CAT_PANEL2 = Color3.fromRGB(32, 32, 32)
    local CAT_CARD   = Color3.fromRGB(10, 10, 10)
    local CAT_EDGE   = Color3.fromRGB(28, 28, 34)
    local CAT_EDGE_H = Color3.fromRGB(48, 48, 56)
    local CAT_DARK   = Color3.fromRGB(0, 0, 0)
    local CAT_TEXT   = Color3.fromRGB(255, 255, 255)
    local CAT_DIM    = Color3.fromRGB(150, 150, 155)
    local function accent()
        local a = _G._VioletteAccent
        return (typeof(a) == "Color3") and a or CAT_ACCENT
    end

    for _, root in ipairs({game:GetService("CoreGui"), LP:FindFirstChild("PlayerGui")}) do
        if root then
            local old = root:FindFirstChild("KawatanAvatarCatalog")
            if old then pcall(function() old:Destroy() end) end
        end
    end

    local gui = new("ScreenGui", {
        Name = "KawatanAvatarCatalog", ResetOnSpawn = false, IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 100001,
    })
    pcall(function() gui.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
    if not gui.Parent then gui.Parent = LP:WaitForChild("PlayerGui") end
    gui.Archivable = false
    pcall(function() gui:SetAttribute("_VlonEProtected", true) end)

    local compact = UIS.TouchEnabled and not UIS.KeyboardEnabled
    local PANEL_W, PANEL_H = (compact and 424 or 616), (compact and 456 or 632)
    local CELL_W, CELL_H = (compact and 126 or 190), (compact and 184 or 272)
    local PAD_X, PAD_Y = (compact and 2 or 5), (compact and 3 or 6)
    local SPIN_SPEED = 0.8
    local CAM_DIST, CAM_HEIGHT = 9.6, 0.5
    local HOVER_ZOOM = 0.86
    local DOLLY_RESPONSE = 9

    local backdrop = new("TextButton", {
        Parent = gui, Name = "CatalogBackdrop", Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 1,
        Text = "", AutoButtonColor = false, BorderSizePixel = 0,
        Visible = false, ZIndex = 200,
    })

    local panel = new("Frame", {
        Parent = backdrop, Name = "CatalogPanel",
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(PANEL_W, PANEL_H),
        BackgroundColor3 = CAT_PANEL, BorderSizePixel = 0,
        Active = true, ZIndex = 201,
    }, {corner(14)})
    local panelEdge = stroke(accent(), 1.2, 0.55)
    panelEdge.Parent = panel
    local panelScale = new("UIScale", {Parent = panel, Scale = 1})
    new("UIGradient", {Parent = panel, Rotation = 35,
        Color = ColorSequence.new(CAT_PANEL, CAT_PANEL2)})

    local head = new("Frame", {
        Parent = panel, BackgroundTransparency = 1, Active = true,
        Position = UDim2.fromOffset(14, 8), Size = UDim2.new(1, -28, 0, 46), ZIndex = 202,
    })
    new("TextLabel", {
        Parent = head, Size = UDim2.new(1, -40, 0, 22), Position = UDim2.fromOffset(0, 2),
        BackgroundTransparency = 1, Text = "AVATAR CATALOG", Font = Enum.Font.GothamBlack,
        TextSize = compact and 16 or 18, TextColor3 = CAT_TEXT,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 203,
    })
    local subtitle = new("TextLabel", {
        Parent = head, Size = UDim2.new(1, -40, 0, 12), Position = UDim2.fromOffset(0, 24),
        BackgroundTransparency = 1, Text = "PICK A SET", Font = Enum.Font.GothamBold,
        TextSize = 9, TextColor3 = accent(), TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 203,
    })
    local closeBtn = new("TextButton", {
        Parent = head, Name = "CloseCatalog", BackgroundTransparency = 1,
        Text = "\u{00D7}", TextSize = 20, TextColor3 = CAT_TEXT,
        Font = Enum.Font.GothamMedium, AutoButtonColor = false,
        Position = UDim2.new(1, -30, 0, 2), Size = UDim2.fromOffset(30, 30), ZIndex = 204,
    })

    local scrolling = new("ScrollingFrame", {
        Parent = panel, Name = "SetCards", BackgroundTransparency = 1, BorderSizePixel = 0,
        Position = UDim2.fromOffset(14, 58), Size = UDim2.new(1, -28, 1, -72),
        CanvasSize = UDim2.new(), ScrollBarThickness = 0, ZIndex = 202,
    })
    new("UIPadding", {Parent = scrolling,
        PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4)})
    local grid = new("UIGridLayout", {
        Parent = scrolling, CellSize = UDim2.fromOffset(CELL_W, CELL_H),
        CellPadding = UDim2.fromOffset(PAD_X, PAD_Y),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrolling.CanvasSize = UDim2.fromOffset(0, grid.AbsoluteContentSize.Y + 12)
    end)

    local cards, shots = {}, {}
    local built, catalogOpen = false, false
    local panelDragging, panelDragEndedAt = false, 0
    local refreshCards

    local function dressPreview(rig, skin)
        rig.PrimaryPart = rig:FindFirstChild("HumanoidRootPart") or rig.PrimaryPart
        for _, object in ipairs(rig:GetDescendants()) do
            if object:IsA("BasePart") then
                object.CanCollide = false
                object.CastShadow = false
            elseif object:IsA("Script") or object:IsA("LocalScript") then
                object:Destroy()
            end
        end
        if skin.headless ~= false then
            local rigHead = rig:FindFirstChild("Head")
            if rigHead then
                rigHead.Transparency = 1
                for _, object in ipairs(rigHead:GetChildren()) do
                    if object:IsA("Decal") or object:IsA("Texture") then object.Transparency = 1 end
                end
            end
        end
        local mode = skin.korblox or "Off"
        for _, entry in ipairs({{"Left", "Left Leg"}, {"Right", "Right Leg"}}) do
            if mode == "Both" or mode == entry[1] then
                local config = _G._RaVeKorbloxAssets and _G._RaVeKorbloxAssets[entry[2]]
                local target = config and rig:FindFirstChild(config.targetBodyPart)
                if target then
                    for _, partName in ipairs(config.partsToHide) do
                        local limb = rig:FindFirstChild(partName)
                        if limb and limb:IsA("BasePart") then limb.Transparency = 1 end
                    end
                    local ok, objects = pcall(function() return game:GetObjects(config.id) end)
                    local source = ok and objects and objects[1]
                    local mesh = source and (source:IsA("BasePart") and source
                        or source:FindFirstChildWhichIsA("BasePart", true))
                    if mesh then
                        mesh.CanCollide = false
                        mesh.CastShadow = false
                        mesh.CFrame = target.CFrame * (config.offset or CFrame.new())
                        local weld = Instance.new("WeldConstraint")
                        weld.Part0, weld.Part1, weld.Parent = target, mesh, mesh
                        mesh.Parent = rig
                    end
                    if source and source ~= mesh and source.Parent ~= rig then
                        pcall(function() source:Destroy() end)
                    end
                end
            end
        end
    end

    local function seatStrays(rig)
        local root = rig:FindFirstChild("HumanoidRootPart")
        if not root then return end
        for _, accessory in ipairs(rig:GetChildren()) do
            if accessory:IsA("Accessory") then
                pcall(function()
                    local handle = accessory:FindFirstChild("Handle")
                    if not (handle and handle:IsA("BasePart")) then return end
                    if (handle.Position - root.Position).Magnitude <= 8 then return end

                    local handleAttachment = handle:FindFirstChildWhichIsA("Attachment")
                    local bodyAttachment
                    if handleAttachment then
                        for _, object in ipairs(rig:GetDescendants()) do
                            if object:IsA("Attachment") and object.Name == handleAttachment.Name
                                and not object:IsDescendantOf(accessory) then
                                bodyAttachment = object
                                break
                            end
                        end
                    end
                    local bodyPart = bodyAttachment and bodyAttachment.Parent
                    if bodyPart and bodyPart:IsA("BasePart") then
                        handle.CFrame = bodyPart.CFrame * bodyAttachment.CFrame
                            * handleAttachment.CFrame:Inverse()
                    else
                        local rigHead = rig:FindFirstChild("Head")
                        if rigHead then handle.CFrame = rigHead.CFrame end
                    end
                end)
            end
        end
    end

    local function loadCard(setName, card)
        task.spawn(function()
            local description = _G._KawatanBuildSetDescription
                and _G._KawatanBuildSetDescription(setName)
            if not description then card.loading.Text = "N/A" return end
            local rig
            local ok = pcall(function()
                rig = Players:CreateHumanoidModelFromDescriptionAsync(description, Enum.HumanoidRigType.R15)
            end)
            if not ok or not rig then
                pcall(function()
                    rig = Players:CreateHumanoidModelFromDescription(description, Enum.HumanoidRigType.R15)
                end)
            end
            pcall(function() description:Destroy() end)
            if not rig or not (rig:FindFirstChild("UpperTorso") or rig:FindFirstChild("Torso")) then
                if rig then pcall(function() rig:Destroy() end) end
                card.loading.Text = "N/A"
                return
            end

            pcall(dressPreview, rig, _G._KawatanSkinSets[setName])
            rig.Parent = card.world

            task.wait()
            pcall(seatStrays, rig)
            for _, object in ipairs(rig:GetDescendants()) do
                if object:IsA("BasePart") then object.Anchored = true end
            end
            pcall(function() rig:PivotTo(CFrame.new()) end)
            card.shot.rig = rig
            card.loading.Visible = false
        end)
    end

    local function selectSet(name)
        _G._KawatanSkinColor = name
        if _G._KawatanOnSetPicked then
            pcall(_G._KawatanOnSetPicked, name)
        end
        if refreshCards then refreshCards() end
    end

    for index, setName in ipairs(_G._KawatanSkinSetOrder or {}) do
        local card = new("TextButton", {
            Parent = scrolling, Name = setName .. "Preview", LayoutOrder = index,
            BackgroundColor3 = CAT_CARD, BackgroundTransparency = 0,
            BorderSizePixel = 0, Text = "", AutoButtonColor = false, ZIndex = 203,
        }, {corner(10)})
        local cardStroke = stroke(CAT_EDGE, 1, 0)
        cardStroke.Parent = card

        local viewport = new("ViewportFrame", {
            Parent = card, Name = "AvatarPreview",
            BackgroundColor3 = CAT_DARK, BackgroundTransparency = 0,
            BorderSizePixel = 0, Position = UDim2.fromOffset(7, 7),
            Size = UDim2.new(1, -14, 1, -34),
            Ambient = Color3.fromRGB(255, 255, 255), LightColor = Color3.fromRGB(255, 255, 255),
            LightDirection = Vector3.new(-0.25, -0.5, -0.83), ZIndex = 204,
        }, {corner(8)})

        local world = new("WorldModel", {Parent = viewport})
        local camera = new("Camera", {Parent = viewport, FieldOfView = 42,
            CFrame = CFrame.lookAt(Vector3.new(0, CAM_HEIGHT, CAM_DIST),
                Vector3.new(0, CAM_HEIGHT, 0))})
        viewport.CurrentCamera = camera

        local loading = new("TextLabel", {
            Parent = viewport, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
            Text = "LOADING", Font = Enum.Font.GothamBold, TextSize = 9,
            TextColor3 = CAT_DIM, ZIndex = 205,
        })

        local label = new("TextLabel", {
            Parent = card, Position = UDim2.new(0, 8, 1, -24),
            Size = UDim2.new(1, -16, 0, 19), BackgroundTransparency = 1, Text = ((_G._KawatanSkinSets or {})[setName] or {}).displayName or tostring(setName):gsub("_", " "),
            Font = Enum.Font.GothamBlack, TextSize = 10,
            TextColor3 = CAT_DIM,
            TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 204,
        })

        local shot = {camera = camera, rig = nil, phase = index * 0.47,
            distance = CAM_DIST, current = CAM_DIST, target = CAM_DIST}
        shots[#shots + 1] = shot

        card.Activated:Connect(function() selectSet(setName) end)
        card.MouseEnter:Connect(function()
            shot.target = shot.distance * HOVER_ZOOM
            if _G._KawatanSkinColor ~= setName then
                tw(cardStroke, Q, {Color = CAT_EDGE_H, Transparency = 0})
                tw(label, Q, {TextColor3 = CAT_TEXT})
            end
        end)
        card.MouseLeave:Connect(function()
            shot.target = shot.distance
            if refreshCards then refreshCards() end
        end)

        cards[setName] = {card = card, stroke = cardStroke, viewport = viewport,
            world = world, camera = camera, label = label, loading = loading,
            shot = shot}
    end

    refreshCards = function()
        local live = accent()
        panelEdge.Color = live
        subtitle.TextColor3 = live
        for setName, entry in pairs(cards) do
            local on = setName == _G._KawatanSkinColor
            tw(entry.stroke, Q, {
                Color = on and live or CAT_EDGE,
                Thickness = on and 2 or 1, Transparency = 0,
            })
            tw(entry.label, Q, {TextColor3 = on and CAT_TEXT or CAT_DIM})
        end
    end
    refreshCards()
    _G._KawatanRefreshGalleryCards = refreshCards

    local elapsed = 0
    hubConnect(RunService.RenderStepped, LPH_NO_VIRTUALIZE(function(dt)
        if not catalogOpen then return end
        elapsed = elapsed + dt
        local ease = math.min(dt * DOLLY_RESPONSE, 1)
        for _, shot in ipairs(shots) do
            if shot.rig and shot.rig.Parent then
                local breath = math.cos(elapsed * 3 + shot.phase) * 0.035
                pcall(function()
                    shot.rig:PivotTo(CFrame.new(0, breath, 0)
                        * CFrame.Angles(0, math.pi + elapsed * SPIN_SPEED + shot.phase, 0))
                end)
            end
            if shot.camera.Parent then
                shot.current = shot.current + (shot.target - shot.current) * ease
                shot.camera.CFrame = CFrame.lookAt(
                    Vector3.new(0, CAM_HEIGHT, shot.current), Vector3.new(0, CAM_HEIGHT, 0))
            end
        end
    end))

    local function closeCatalog()
        catalogOpen = false
        tw(backdrop, Q, {BackgroundTransparency = 1})
        tw(panelScale, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {Scale = 0.9})
        task.delay(0.16, function()
            if not catalogOpen then backdrop.Visible = false end
        end)
    end

    _G._KawatanOpenSkinGallery = function()
        catalogOpen = true
        refreshCards()
        for _, shot in ipairs(shots) do shot.target = shot.distance end
        backdrop.Visible = true
        backdrop.BackgroundTransparency = 1
        panelScale.Scale = 0.9
        tw(backdrop, TweenInfo.new(0.2), {BackgroundTransparency = 0.42})
        tw(panelScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Scale = 1})
        if built then return end
        built = true
        task.spawn(function()
            for _, setName in ipairs(_G._KawatanSkinSetOrder or {}) do
                local entry = cards[setName]
                if entry then loadCard(setName, entry) end
                task.wait(0.12)
            end
        end)
    end
    _G._KawatanCloseSkinGallery = closeCatalog

    closeBtn.Activated:Connect(closeCatalog)
    backdrop.MouseButton1Click:Connect(function()
        if panelDragging or (os.clock() - panelDragEndedAt) < 0.25 then return end
        closeCatalog()
    end)

    do
        local startInput, startPosition, dragInput
        head.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then return end
            panelDragging, startInput, startPosition, dragInput =
                true, input.Position, panel.Position, input
        end)
        head.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        hubConnect(UIS.InputChanged, function(input)
            if not panelDragging then return end
            if input ~= dragInput and input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
            local delta = input.Position - startInput
            panel.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X,
                startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        end)
        hubConnect(UIS.InputEnded, function(input)
            if not panelDragging then return end
            if input == dragInput
                or input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                panelDragging, dragInput = false, nil
                panelDragEndedAt = os.clock()
            end
        end)
    end
end)()

    _G._VioletteSkinGalleryRuntime = {
        Destroy = function()
            for _, c in ipairs(_conns) do pcall(function() c:Disconnect() end) end
            _conns = {}
            _G._VioletteSkinGalleryRuntime = nil
        end,
    }
end)()