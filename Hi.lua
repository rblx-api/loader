-- // ========================== //
-- //       MVP TP BATE          //
-- //   (GUI + Anti-Desync)      //
-- // ========================== //

-- // Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- // Local Player
local LP = Players.LocalPlayer
if not LP then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    LP = Players.LocalPlayer
end

-- // Multi-executor helpers (seguros, sin romper el script)
local function findGlobalFunc(...)
    local sources = {}
    pcall(function()
        if getgenv then table.insert(sources, getgenv()) end
    end)
    pcall(function()
        table.insert(sources, _G)
    end)
    pcall(function()
        if getfenv then table.insert(sources, getfenv()) end
    end)
    for i = 1, select("#", ...) do
        local name = select(i, ...)
        for _, env in ipairs(sources) do
            if type(env) == "table" then
                local ok, val = pcall(function() return env[name] end)
                if ok and type(val) == "function" then
                    return val
                end
            end
        end
    end
    return nil
end

local setHiddenProp = findGlobalFunc(
    "sethiddenproperty",
    "set_hidden_property",
    "sethiddenprop",
    "set_hidden_prop"
)

local function setHidden(instance, prop, value)
    if not instance then return false end
    if setHiddenProp then
        local ok = pcall(setHiddenProp, instance, prop, value)
        if ok then return true end
    end
    return false
end

local function parentGui(gui)
    local protect = findGlobalFunc("protect_gui", "protectgui", "ProtectGui")
    if protect then pcall(protect, gui) end

    local ok = pcall(function() gui.Parent = CoreGui end)
    if not ok or not gui.Parent then
        pcall(function()
            gui.Parent = LP:WaitForChild("PlayerGui", 8)
        end)
    end
end

-- // ========================== //
-- //          GUI              //
-- // ========================== //

pcall(function()
    local old = CoreGui:FindFirstChild("MvpTpBat")
    if old then old:Destroy() end
end)
pcall(function()
    local pg = LP:FindFirstChild("PlayerGui")
    if pg then
        local old = pg:FindFirstChild("MvpTpBat")
        if old then old:Destroy() end
    end
end)

local MvpTpBat = Instance.new("ScreenGui")
MvpTpBat.Name = "MvpTpBat"
MvpTpBat.IgnoreGuiInset = true
MvpTpBat.ResetOnSpawn = false
MvpTpBat.DisplayOrder = 999999
MvpTpBat.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
parentGui(MvpTpBat)

-- Main Frame (draggable)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = false
MainFrame.Position = UDim2.new(0.5, -148, 0.5, -48)
MainFrame.Size = UDim2.new(0, 296, 0, 96)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
MainFrame.BackgroundTransparency = 0.12
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MvpTpBat

local locked = false

local MainScale = Instance.new("UIScale")
MainScale.Scale = 1
MainScale.Parent = MainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = MainFrame

-- Halloween: borde naranja suave
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 210, 60)
UIStroke.Thickness = 1.4
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Transparency = 0.25
UIStroke.Parent = MainFrame

-- Background Image
local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Size = UDim2.new(1, 0, 1, 0)
ImageLabel.BackgroundTransparency = 1
ImageLabel.Image = "rbxassetid://90453834580322"
ImageLabel.ImageTransparency = 0.18
ImageLabel.ImageColor3 = Color3.fromRGB(255, 240, 200)
ImageLabel.ScaleType = Enum.ScaleType.Crop
ImageLabel.Parent = MainFrame

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 14)
UICorner2.Parent = ImageLabel

-- Overlay Halloween (morado suave, se lee el texto)
local Overlay = Instance.new("Frame")
Overlay.ZIndex = 2
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Overlay.BackgroundTransparency = 0.40
Overlay.BorderSizePixel = 0
Overlay.Parent = MainFrame

local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0, 14)
UICorner3.Parent = Overlay

local UIGradient = Instance.new("UIGradient")
UIGradient.Rotation = 90
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 12, 12)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
})
UIGradient.Transparency = NumberSequence.new(0.45, 0.70)
UIGradient.Parent = Overlay

-- Settings
local SettingsBtn = Instance.new("TextButton")
SettingsBtn.ZIndex = 8
SettingsBtn.Position = UDim2.new(0, 8, 0, 8)
SettingsBtn.Size = UDim2.new(0, 24, 0, 24)
SettingsBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
SettingsBtn.BackgroundTransparency = 0.08
SettingsBtn.BorderSizePixel = 0
SettingsBtn.Text = "⚙"
SettingsBtn.TextColor3 = Color3.fromRGB(255, 215, 70)
SettingsBtn.TextSize = 14
SettingsBtn.Font = Enum.Font.GothamBold
SettingsBtn.AutoButtonColor = false
SettingsBtn.Parent = MainFrame

local UICornerSettings = Instance.new("UICorner")
UICornerSettings.CornerRadius = UDim.new(1, 0)
UICornerSettings.Parent = SettingsBtn

local UIStrokeSettings = Instance.new("UIStroke")
UIStrokeSettings.Color = Color3.fromRGB(255, 210, 60)
UIStrokeSettings.Transparency = 0.3
UIStrokeSettings.Parent = SettingsBtn

-- Title (nombre bien visible + calabaza)
local TitleLabel = Instance.new("TextLabel")
TitleLabel.ZIndex = 6
TitleLabel.Position = UDim2.new(0, 38, 0, 10)
TitleLabel.Size = UDim2.new(1, -150, 0, 18)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🎃  MVP TP BATE"
TitleLabel.TextColor3 = Color3.fromRGB(255, 220, 70)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

local TitleStroke = Instance.new("UIStroke")
TitleStroke.Color = Color3.fromRGB(0, 0, 0)
TitleStroke.Thickness = 1.6
TitleStroke.Transparency = 0.15
TitleStroke.Parent = TitleLabel

-- Calabazas / fantasma solo decorativos (no afectan lógica)
local PumpkinLeft = Instance.new("TextLabel")
PumpkinLeft.ZIndex = 7
PumpkinLeft.Position = UDim2.new(0, 6, 1, -22)
PumpkinLeft.Size = UDim2.new(0, 20, 0, 18)
PumpkinLeft.BackgroundTransparency = 1
PumpkinLeft.Text = "🎃"
PumpkinLeft.TextSize = 12
PumpkinLeft.Font = Enum.Font.GothamBold
PumpkinLeft.Parent = MainFrame

local PumpkinRight = Instance.new("TextLabel")
PumpkinRight.ZIndex = 7
PumpkinRight.Position = UDim2.new(1, -24, 1, -22)
PumpkinRight.Size = UDim2.new(0, 20, 0, 18)
PumpkinRight.BackgroundTransparency = 1
PumpkinRight.Text = "🎃"
PumpkinRight.TextSize = 12
PumpkinRight.Font = Enum.Font.GothamBold
PumpkinRight.Parent = MainFrame

local GhostDeco = Instance.new("TextLabel")
GhostDeco.ZIndex = 7
GhostDeco.Position = UDim2.new(0.5, -10, 0, -2)
GhostDeco.Size = UDim2.new(0, 20, 0, 14)
GhostDeco.BackgroundTransparency = 1
GhostDeco.Text = "👻"
GhostDeco.TextSize = 11
GhostDeco.Font = Enum.Font.GothamBold
GhostDeco.Parent = MainFrame

-- Keybind (muestra la tecla) + Lock + Size controls
local KeybindBtn = Instance.new("TextButton")
KeybindBtn.ZIndex = 8
KeybindBtn.Position = UDim2.new(1, -148, 0, 8)
KeybindBtn.Size = UDim2.new(0, 58, 0, 24)
KeybindBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
KeybindBtn.BackgroundTransparency = 0.08
KeybindBtn.BorderSizePixel = 0
KeybindBtn.Text = "X"
KeybindBtn.TextColor3 = Color3.fromRGB(255, 220, 80)
KeybindBtn.TextSize = 10
KeybindBtn.Font = Enum.Font.GothamBold
KeybindBtn.AutoButtonColor = false
KeybindBtn.Parent = MainFrame

local UICornerKey = Instance.new("UICorner")
UICornerKey.CornerRadius = UDim.new(0, 8)
UICornerKey.Parent = KeybindBtn

local UIStrokeKey = Instance.new("UIStroke")
UIStrokeKey.Color = Color3.fromRGB(255, 210, 60)
UIStrokeKey.Transparency = 0.3
UIStrokeKey.Parent = KeybindBtn

local LockBtn = Instance.new("TextButton")
LockBtn.ZIndex = 8
LockBtn.Position = UDim2.new(1, -86, 0, 8)
LockBtn.Size = UDim2.new(0, 24, 0, 24)
LockBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
LockBtn.BackgroundTransparency = 0.08
LockBtn.BorderSizePixel = 0
LockBtn.Text = "🔓"
LockBtn.TextColor3 = Color3.fromRGB(255, 220, 80)
LockBtn.TextSize = 12
LockBtn.Font = Enum.Font.GothamBold
LockBtn.AutoButtonColor = false
LockBtn.Parent = MainFrame

local UICornerLock = Instance.new("UICorner")
UICornerLock.CornerRadius = UDim.new(1, 0)
UICornerLock.Parent = LockBtn

local UIStrokeLock = Instance.new("UIStroke")
UIStrokeLock.Color = Color3.fromRGB(255, 210, 60)
UIStrokeLock.Transparency = 0.3
UIStrokeLock.Parent = LockBtn

local SizeMinusBtn = Instance.new("TextButton")
SizeMinusBtn.ZIndex = 8
SizeMinusBtn.Position = UDim2.new(1, -58, 0, 8)
SizeMinusBtn.Size = UDim2.new(0, 24, 0, 24)
SizeMinusBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
SizeMinusBtn.BackgroundTransparency = 0.08
SizeMinusBtn.BorderSizePixel = 0
SizeMinusBtn.Text = "−"
SizeMinusBtn.TextColor3 = Color3.fromRGB(255, 220, 80)
SizeMinusBtn.TextSize = 16
SizeMinusBtn.Font = Enum.Font.GothamBold
SizeMinusBtn.AutoButtonColor = false
SizeMinusBtn.Parent = MainFrame

local UICornerMinus = Instance.new("UICorner")
UICornerMinus.CornerRadius = UDim.new(1, 0)
UICornerMinus.Parent = SizeMinusBtn

local UIStrokeMinus = Instance.new("UIStroke")
UIStrokeMinus.Color = Color3.fromRGB(255, 210, 60)
UIStrokeMinus.Transparency = 0.3
UIStrokeMinus.Parent = SizeMinusBtn

local SizePlusBtn = Instance.new("TextButton")
SizePlusBtn.ZIndex = 8
SizePlusBtn.Position = UDim2.new(1, -30, 0, 8)
SizePlusBtn.Size = UDim2.new(0, 24, 0, 24)
SizePlusBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
SizePlusBtn.BackgroundTransparency = 0.08
SizePlusBtn.BorderSizePixel = 0
SizePlusBtn.Text = "+"
SizePlusBtn.TextColor3 = Color3.fromRGB(255, 220, 80)
SizePlusBtn.TextSize = 16
SizePlusBtn.Font = Enum.Font.GothamBold
SizePlusBtn.AutoButtonColor = false
SizePlusBtn.Parent = MainFrame

local UICornerPlus = Instance.new("UICorner")
UICornerPlus.CornerRadius = UDim.new(1, 0)
UICornerPlus.Parent = SizePlusBtn

local UIStrokePlus = Instance.new("UIStroke")
UIStrokePlus.Color = Color3.fromRGB(255, 210, 60)
UIStrokePlus.Transparency = 0.3
UIStrokePlus.Parent = SizePlusBtn

-- Bottom bar
local Bar = Instance.new("Frame")
Bar.ZIndex = 5
Bar.Position = UDim2.new(0, 12, 0, 40)
Bar.Size = UDim2.new(1, -24, 0, 42)
Bar.BackgroundTransparency = 1
Bar.Parent = MainFrame

local ActionBubble = Instance.new("Frame")
ActionBubble.ZIndex = 7
ActionBubble.Size = UDim2.new(1, 0, 1, 0)
ActionBubble.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ActionBubble.BackgroundTransparency = 0.15
ActionBubble.BorderSizePixel = 0
ActionBubble.Parent = Bar

-- Más cuadrado (esquinas suaves, no pastilla)
local UICornerBubble = Instance.new("UICorner")
UICornerBubble.CornerRadius = UDim.new(0, 10)
UICornerBubble.Parent = ActionBubble

local UIStrokeBubble = Instance.new("UIStroke")
UIStrokeBubble.Color = Color3.fromRGB(255, 210, 60)
UIStrokeBubble.Transparency = 0.25
UIStrokeBubble.Thickness = 1.4
UIStrokeBubble.Parent = ActionBubble

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.ZIndex = 9
ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Text = "🎃 ACTIVATE TP BATE"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 225, 90)
ToggleBtn.TextSize = 13
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent = ActionBubble

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 210, 60)
ToggleStroke.Thickness = 1.3
ToggleStroke.Transparency = 0.15
ToggleStroke.Parent = ToggleBtn

-- ========================== //
-- //     SETTINGS PANEL     //
-- ========================== //

local settingsOpen = false

local SettingsPanel = Instance.new("Frame")
SettingsPanel.Name = "SettingsPanel"
SettingsPanel.ZIndex = 20
SettingsPanel.Position = UDim2.new(0, 0, 0, 102)
SettingsPanel.Size = UDim2.new(1, 0, 0, 130)
SettingsPanel.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
SettingsPanel.BackgroundTransparency = 0.04
SettingsPanel.BorderSizePixel = 0
SettingsPanel.Visible = false
SettingsPanel.Active = true
SettingsPanel.ClipsDescendants = false
SettingsPanel.Parent = MainFrame

local SettingsCorner = Instance.new("UICorner")
SettingsCorner.CornerRadius = UDim.new(0, 12)
SettingsCorner.Parent = SettingsPanel

local SettingsStroke = Instance.new("UIStroke")
SettingsStroke.Color = Color3.fromRGB(255, 210, 60)
SettingsStroke.Transparency = 0.3
SettingsStroke.Thickness = 1.1
SettingsStroke.Parent = SettingsPanel

local SettingsTitle = Instance.new("TextLabel")
SettingsTitle.ZIndex = 21
SettingsTitle.Position = UDim2.new(0, 12, 0, 8)
SettingsTitle.Size = UDim2.new(1, -24, 0, 16)
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Text = "🎃 TP BATE BYPASS"
SettingsTitle.TextColor3 = Color3.fromRGB(255, 220, 70)
SettingsTitle.TextSize = 11
SettingsTitle.Font = Enum.Font.GothamBlack
SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
SettingsTitle.Parent = SettingsPanel

-- Speed row
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.ZIndex = 21
SpeedLabel.Position = UDim2.new(0, 12, 0, 30)
SpeedLabel.Size = UDim2.new(0.5, 0, 0, 14)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Bat Speed"
SpeedLabel.TextColor3 = Color3.fromRGB(230, 220, 180)
SpeedLabel.TextSize = 11
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = SettingsPanel

local SpeedValueLabel = Instance.new("TextLabel")
SpeedValueLabel.ZIndex = 21
SpeedValueLabel.Position = UDim2.new(1, -50, 0, 30)
SpeedValueLabel.Size = UDim2.new(0, 40, 0, 14)
SpeedValueLabel.BackgroundTransparency = 1
SpeedValueLabel.Text = "40"
SpeedValueLabel.TextColor3 = Color3.fromRGB(255, 220, 70)
SpeedValueLabel.TextSize = 11
SpeedValueLabel.Font = Enum.Font.GothamBold
SpeedValueLabel.TextXAlignment = Enum.TextXAlignment.Right
SpeedValueLabel.Parent = SettingsPanel

local SpeedMinus = Instance.new("TextButton")
SpeedMinus.ZIndex = 22
SpeedMinus.Position = UDim2.new(0, 12, 0, 50)
SpeedMinus.Size = UDim2.new(0, 28, 0, 22)
SpeedMinus.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SpeedMinus.BackgroundTransparency = 0.25
SpeedMinus.BorderSizePixel = 0
SpeedMinus.Text = "−"
SpeedMinus.TextColor3 = Color3.fromRGB(235, 235, 240)
SpeedMinus.TextSize = 14
SpeedMinus.Font = Enum.Font.GothamBold
SpeedMinus.AutoButtonColor = false
SpeedMinus.Parent = SettingsPanel

local SpeedMinusCorner = Instance.new("UICorner")
SpeedMinusCorner.CornerRadius = UDim.new(0, 6)
SpeedMinusCorner.Parent = SpeedMinus

local SpeedPlus = Instance.new("TextButton")
SpeedPlus.ZIndex = 22
SpeedPlus.Position = UDim2.new(0, 44, 0, 50)
SpeedPlus.Size = UDim2.new(0, 28, 0, 22)
SpeedPlus.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SpeedPlus.BackgroundTransparency = 0.25
SpeedPlus.BorderSizePixel = 0
SpeedPlus.Text = "+"
SpeedPlus.TextColor3 = Color3.fromRGB(235, 235, 240)
SpeedPlus.TextSize = 14
SpeedPlus.Font = Enum.Font.GothamBold
SpeedPlus.AutoButtonColor = false
SpeedPlus.Parent = SettingsPanel

local SpeedPlusCorner = Instance.new("UICorner")
SpeedPlusCorner.CornerRadius = UDim.new(0, 6)
SpeedPlusCorner.Parent = SpeedPlus

local SpeedHint = Instance.new("TextLabel")
SpeedHint.ZIndex = 21
SpeedHint.Position = UDim2.new(0, 80, 0, 52)
SpeedHint.Size = UDim2.new(1, -90, 0, 18)
SpeedHint.BackgroundTransparency = 1
SpeedHint.Text = "↑ faster / precise   ↓ slower"
SpeedHint.TextColor3 = Color3.fromRGB(160, 160, 170)
SpeedHint.TextSize = 9
SpeedHint.Font = Enum.Font.Gotham
SpeedHint.TextXAlignment = Enum.TextXAlignment.Left
SpeedHint.Parent = SettingsPanel

-- Version row
local VersionLabel = Instance.new("TextLabel")
VersionLabel.ZIndex = 21
VersionLabel.Position = UDim2.new(0, 12, 0, 82)
VersionLabel.Size = UDim2.new(0.4, 0, 0, 14)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = "Version"
VersionLabel.TextColor3 = Color3.fromRGB(220, 220, 225)
VersionLabel.TextSize = 11
VersionLabel.Font = Enum.Font.GothamBold
VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
VersionLabel.Parent = SettingsPanel

local V1Btn = Instance.new("TextButton")
V1Btn.ZIndex = 22
V1Btn.Position = UDim2.new(0, 12, 0, 100)
V1Btn.Size = UDim2.new(0, 60, 0, 22)
V1Btn.BackgroundColor3 = Color3.fromRGB(40, 55, 40)
V1Btn.BorderSizePixel = 0
V1Btn.Text = "V1 Auto"
V1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
V1Btn.TextSize = 10
V1Btn.Font = Enum.Font.GothamBold
V1Btn.AutoButtonColor = false
V1Btn.Parent = SettingsPanel

local V1Corner = Instance.new("UICorner")
V1Corner.CornerRadius = UDim.new(0, 6)
V1Corner.Parent = V1Btn

local V2Btn = Instance.new("TextButton")
V2Btn.ZIndex = 22
V2Btn.Position = UDim2.new(0, 78, 0, 100)
V2Btn.Size = UDim2.new(0, 70, 0, 22)
V2Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
V2Btn.BorderSizePixel = 0
V2Btn.Text = "V2 Manual"
V2Btn.TextColor3 = Color3.fromRGB(200, 200, 210)
V2Btn.TextSize = 10
V2Btn.Font = Enum.Font.GothamBold
V2Btn.AutoButtonColor = false
V2Btn.Parent = SettingsPanel

local V2Corner = Instance.new("UICorner")
V2Corner.CornerRadius = UDim.new(0, 6)
V2Corner.Parent = V2Btn

local VersionHint = Instance.new("TextLabel")
VersionHint.ZIndex = 21
VersionHint.Position = UDim2.new(0, 155, 0, 102)
VersionHint.Size = UDim2.new(1, -165, 0, 18)
VersionHint.BackgroundTransparency = 1
VersionHint.Text = "V1=auto hit  V2=tap to hit"
VersionHint.TextColor3 = Color3.fromRGB(160, 160, 170)
VersionHint.TextSize = 9
VersionHint.Font = Enum.Font.Gotham
VersionHint.TextXAlignment = Enum.TextXAlignment.Left
VersionHint.Parent = SettingsPanel

-- ========================== //
-- //     TP BAT LOGIC       //
-- ========================== //

local autoBat = false
local silentAim = false
local cooldown = false

local TOGGLE_KEY = Enum.KeyCode.X
local HIT_KEY = Enum.KeyCode.ButtonR2 -- default manual hit key (controller R2 / can rebind with same system)
local listeningBind = false
local listeningHitBind = false

-- Nombres cortos para mostrar la tecla / botón del mando
local KEY_SHORT = {
    ["LeftShift"] = "LShift", ["RightShift"] = "RShift",
    ["LeftControl"] = "LCtrl", ["RightControl"] = "RCtrl",
    ["LeftAlt"] = "LAlt", ["RightAlt"] = "RAlt",
    ["Space"] = "Space", ["Return"] = "Enter", ["Backspace"] = "Bksp",
    ["ButtonA"] = "A", ["ButtonB"] = "B", ["ButtonX"] = "X", ["ButtonY"] = "Y",
    ["ButtonL1"] = "L1", ["ButtonR1"] = "R1", ["ButtonL2"] = "L2", ["ButtonR2"] = "R2",
    ["ButtonL3"] = "L3", ["ButtonR3"] = "R3",
    ["DPadUp"] = "D↑", ["DPadDown"] = "D↓", ["DPadLeft"] = "D←", ["DPadRight"] = "D→",
    ["Thumbstick1"] = "LS", ["Thumbstick2"] = "RS",
}

local function formatKeyName(keyCode)
    if not keyCode then return "?" end
    local name = keyCode.Name or tostring(keyCode)
    if KEY_SHORT[name] then return KEY_SHORT[name] end
    if #name > 7 then return name:sub(1, 6) .. "…" end
    return name
end

local function refreshKeybindLabel()
    if listeningBind then
        KeybindBtn.Text = "..."
        KeybindBtn.TextColor3 = Color3.fromRGB(255, 255, 120)
    else
        KeybindBtn.Text = formatKeyName(TOGGLE_KEY)
        KeybindBtn.TextColor3 = Color3.fromRGB(255, 220, 80)
    end
end

-- Settings state
local batSpeed = 40 -- 10-80, higher = faster/more precise hits
local MIN_BAT_SPEED = 10
local MAX_BAT_SPEED = 80
local currentVersion = "V1" -- V1 auto, V2 manual

local char, h, hrp = nil, nil, nil

local currentScale = 1
local MIN_SCALE = 0.7
local MAX_SCALE = 1.6

local function applyScale()
    MainScale.Scale = currentScale
end

local function updateSpeedLabel()
    SpeedValueLabel.Text = tostring(batSpeed)
end

local function updateVersionButtons()
    if currentVersion == "V1" then
        V1Btn.BackgroundColor3 = Color3.fromRGB(40, 55, 40)
        V1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        V2Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        V2Btn.TextColor3 = Color3.fromRGB(200, 200, 210)
    else
        V2Btn.BackgroundColor3 = Color3.fromRGB(40, 55, 40)
        V2Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        V1Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        V1Btn.TextColor3 = Color3.fromRGB(200, 200, 210)
    end
end

-- Velocidad de batazos (más speed = hits más seguidos / precisos)
local function getHitDelay()
    -- 10 -> ~0.10s | 40 -> ~0.045s | 80 -> ~0.015s
    local t = 0.12 - ((batSpeed - 10) / 70) * 0.105
    return math.clamp(t, 0.015, 0.12)
end

local function isBatTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local n = string.lower(tool.Name)
    return n == "bat" or n:find("bat", 1, true) ~= nil or n:find("slap", 1, true) ~= nil
end

local function getBat()
    local c = LP.Character or char
    if not c then return nil end
    local hum = c:FindFirstChildOfClass("Humanoid")

    -- Ya equipado
    for _, ch in ipairs(c:GetChildren()) do
        if isBatTool(ch) then return ch end
    end

    -- En backpack -> equipar
    local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    if bp then
        for _, ch in ipairs(bp:GetChildren()) do
            if isBatTool(ch) then
                if hum then
                    pcall(function() hum:EquipTool(ch) end)
                else
                    pcall(function() ch.Parent = c end)
                end
                return ch
            end
        end
    end
    return nil
end

-- Hit estable: Activate + todos los RemoteEvent del bate
local function tryHit()
    if cooldown then return end
    cooldown = true
    pcall(function()
        local bat = getBat()
        if not bat then return end
        pcall(function() bat:Activate() end)
        for _, d in ipairs(bat:GetDescendants()) do
            if d:IsA("RemoteEvent") then
                pcall(function() d:FireServer() end)
            end
        end
        local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
        if ev then
            pcall(function() ev:FireServer() end)
        end
    end)
    task.delay(getHitDelay(), function() cooldown = false end)
end

local function getClosest()
    local myHrp = hrp
    if not myHrp or not myHrp.Parent then
        local c = LP.Character
        myHrp = c and c:FindFirstChild("HumanoidRootPart")
        hrp = myHrp
    end
    if not myHrp then return nil, math.huge end

    local best, bestDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and tr and tr.Parent then
                local d = (myHrp.Position - tr.Position).Magnitude
                if d < bestDist then
                    bestDist = d
                    best = p
                end
            end
        end
    end
    return best, bestDist
end

local function setupChar(newChar)
    char = newChar
    task.wait(0.1)
    h = char:WaitForChild("Humanoid", 5)
    hrp = char:WaitForChild("HumanoidRootPart", 5)
end

local function setAutoBat(state)
    autoBat = state == true
    char = LP.Character
    if char then
        h = char:FindFirstChildOfClass("Humanoid")
        hrp = char:FindFirstChild("HumanoidRootPart")
    end
    ToggleBtn.Text = autoBat and "💀 DEACTIVATE TP BATE" or "🎃 ACTIVATE TP BATE"
    print("Auto Bat:", autoBat and "ON" or "OFF", "| Version:", currentVersion, "| Speed:", batSpeed)
end

LP.CharacterAdded:Connect(setupChar)
if LP.Character then task.spawn(function() setupChar(LP.Character) end) end

-- Core TP + hit (lógica restaurada / reforzada)
RunService.Heartbeat:Connect(function()
    if not autoBat then return end

    local c = LP.Character
    if not c then return end
    char = c
    hrp = c:FindFirstChild("HumanoidRootPart")
    h = c:FindFirstChildOfClass("Humanoid")
    if not hrp or not h or h.Health <= 0 then return end

    local target, dist = getClosest()
    if not target or not target.Character then return end
    local tr = target.Character:FindFirstChild("HumanoidRootPart")
    if not tr then return end

    -- desync
    setHidden(hrp, "PhysicsRepRootPart", tr)

    local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
    if dist > 4 then
        hrp.CFrame = CFrame.new(targetPos, tr.Position)
    elseif dist > 1.5 then
        hrp.CFrame = CFrame.new(hrp.Position:Lerp(targetPos, 0.55), tr.Position)
    else
        -- cerca: mantener encima / pegado para hit
        hrp.CFrame = CFrame.new(targetPos, tr.Position)
    end

    pcall(function()
        hrp.AssemblyAngularVelocity = Vector3.zero
    end)

    local cam = workspace.CurrentCamera
    if not silentAim and cam then
        cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position + Vector3.new(0, 0.5, 0))
    end

    if currentVersion == "V1" then
        tryHit()
    end
end)

local function isValidBindInput(inp)
    if not inp or not inp.KeyCode then return false end
    if inp.KeyCode == Enum.KeyCode.Unknown or inp.KeyCode == Enum.KeyCode.Escape then
        return false
    end
    local t = inp.UserInputType
    return t == Enum.UserInputType.Keyboard
        or t == Enum.UserInputType.Gamepad1
        or t == Enum.UserInputType.Gamepad2
        or t == Enum.UserInputType.Gamepad3
        or t == Enum.UserInputType.Gamepad4
end

local function isGamepad(inp)
    local t = inp.UserInputType
    return t == Enum.UserInputType.Gamepad1
        or t == Enum.UserInputType.Gamepad2
        or t == Enum.UserInputType.Gamepad3
        or t == Enum.UserInputType.Gamepad4
end

local toggleDebounce = false

UIS.InputBegan:Connect(function(inp, gp)
    -- Captura de keybind (PC / mando)
    if listeningBind then
        if isValidBindInput(inp) then
            TOGGLE_KEY = inp.KeyCode
            listeningBind = false
            refreshKeybindLabel()
            print("Toggle bind set to:", TOGGLE_KEY.Name)
        end
        return
    end

    if gp then return end
    if inp.UserInputState ~= Enum.UserInputState.Begin then return end

    -- Toggle key (solo 1 vez por pulsación, sin spam)
    if inp.KeyCode == TOGGLE_KEY then
        if toggleDebounce then return end
        toggleDebounce = true
        setAutoBat(not autoBat)
        task.delay(0.25, function() toggleDebounce = false end)
        return
    end

    -- V2 manual: click / touch / R2 / X / A / E / F
    if autoBat and currentVersion == "V2" then
        if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch
            or inp.KeyCode == Enum.KeyCode.ButtonR2
            or inp.KeyCode == Enum.KeyCode.ButtonX
            or inp.KeyCode == Enum.KeyCode.ButtonA
            or inp.KeyCode == Enum.KeyCode.E
            or inp.KeyCode == Enum.KeyCode.F
        then
            tryHit()
        end
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    setAutoBat(not autoBat)
end)

SizePlusBtn.MouseButton1Click:Connect(function()
    currentScale = math.clamp(currentScale + 0.1, MIN_SCALE, MAX_SCALE)
    applyScale()
end)

SizeMinusBtn.MouseButton1Click:Connect(function()
    currentScale = math.clamp(currentScale - 0.1, MIN_SCALE, MAX_SCALE)
    applyScale()
end)

LockBtn.MouseButton1Click:Connect(function()
    locked = not locked
    MainFrame.Draggable = not locked
    LockBtn.Text = locked and "🔒" or "🔓"
end)

KeybindBtn.MouseButton1Click:Connect(function()
    if listeningBind then return end
    listeningBind = true
    refreshKeybindLabel()
    print("Press a PC key or controller button to bind toggle...")
end)

refreshKeybindLabel()

SettingsBtn.MouseButton1Click:Connect(function()
    settingsOpen = not settingsOpen
    SettingsPanel.Visible = settingsOpen
    if settingsOpen then
        MainFrame.Size = UDim2.new(0, 296, 0, 240)
    else
        MainFrame.Size = UDim2.new(0, 296, 0, 96)
    end
end)

SpeedPlus.MouseButton1Click:Connect(function()
    batSpeed = math.clamp(batSpeed + 5, MIN_BAT_SPEED, MAX_BAT_SPEED)
    updateSpeedLabel()
end)

SpeedMinus.MouseButton1Click:Connect(function()
    batSpeed = math.clamp(batSpeed - 5, MIN_BAT_SPEED, MAX_BAT_SPEED)
    updateSpeedLabel()
end)

V1Btn.MouseButton1Click:Connect(function()
    currentVersion = "V1"
    updateVersionButtons()
    print("Version: V1 Auto hit")
end)

V2Btn.MouseButton1Click:Connect(function()
    currentVersion = "V2"
    updateVersionButtons()
    print("Version: V2 Manual hit (click / R2 / E / F)")
end)

updateSpeedLabel()
updateVersionButtons()

print("MVP TP BATE loaded.")
print("⚙ settings | ... bind (PC/controller) | V1 auto hit | V2 manual hit | speed = hit rate")