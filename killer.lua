-- LuaSecure trace: 77fb21d87c3a676833b0ca9b2513237038716921320fb71a1ae4e61758dfbd78
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ===== KILLERHUB THEME (Black, Dark Gray, & Red) =====
local COLORS = {
bg = Color3.fromRGB(12, 12, 14),
surface = Color3.fromRGB(20, 20, 24),
disabled = Color3.fromRGB(32, 32, 38),
border = Color3.fromRGB(80, 25, 25),
accent = Color3.fromRGB(200, 30, 30), -- Red
accentDark = Color3.fromRGB(120, 15, 15),
accentBright = Color3.fromRGB(255, 60, 60), -- Bright Red
text = Color3.fromRGB(240, 240, 245),
white = Color3.fromRGB(255, 255, 255),
black = Color3.fromRGB(0, 0, 0),
}

local FONT = Enum.Font.GothamBlack

-- ============================================================
-- VISION HUB PACKET LAGGER LOGIC MODULE (UNTOUCHED)
-- ============================================================
local SRC = [==[
local RS = game:GetService("ReplicatedStorage")

local Event
do
local ok, net = pcall(function()
return RS:WaitForChild("Packages"):WaitForChild("Net")
end)
if ok and net then
local kids = net:GetChildren()
Event = kids[230]
end
end

local state = { running = false, thread = nil }
local intensity = 10000

local function start()
if state.running then return end
if not Event then return end
state.running = true

local payload = table.create(intensity, function() end)

state.thread = task.spawn(function()
while state.running do
for _ = 1, 3 do
pcall(function()
if Event then
Event:FireServer(payload)
end
end)
end
task.wait(0.01)
end
end)
end

local function stop()
state.running = false
if state.thread then
pcall(task.cancel, state.thread)
state.thread = nil
end
end

return {
start = start,
stop = stop,
toggle = function() if state.running then stop() else start() end end,
isRunning = function() return state.running end,
}
]==]

local loader = coroutine.create(function()
local chunk = loadstring(SRC)
if not chunk then return end
local ok, api = pcall(chunk)
if ok and type(api) == "table" then
_G.__ALT = api
end
end)

coroutine.resume(loader)
loader = nil

local api = _G.__ALT
_G.__ALT = nil

-- ===== SAVE STATE (Session only) =====
local savedData = {
position = UDim2.new(0.5, 0, 0.5, 0),
active = false,
visible = true,
toggleKey = Enum.KeyCode.G,
toggleUserButton = nil
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KillerhubPacketLaggerUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- ===== Compact Layout constants =====
local WIDTH = 200
local HEIGHT = 126
local HEADER_H = 30
local TOGGLE_H = 34
local KEYBIND_H = 22

local main = Instance.new("Frame")
main.Name = "KillerhubMainFrame"
main.Size = UDim2.new(0, WIDTH, 0, HEIGHT)
main.Position = savedData.position
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = COLORS.bg
main.BorderSizePixel = 0
main.ClipsDescendants = false
main.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = main

local borderFrame = Instance.new("Frame")
borderFrame.Name = "BorderFrame"
borderFrame.Size = UDim2.new(1, 2, 1, 2)
borderFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
borderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
borderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
borderFrame.BorderSizePixel = 0
borderFrame.ZIndex = 0
borderFrame.Parent = main

local borderCorner = Instance.new("UICorner")
borderCorner.CornerRadius = UDim.new(0, 9)
borderCorner.Parent = borderFrame

local borderGrad = Instance.new("UIGradient")
borderGrad.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0.0, Color3.fromRGB(40, 10, 10)),
ColorSequenceKeypoint.new(0.25, Color3.fromRGB(180, 30, 30)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 100)),
ColorSequenceKeypoint.new(0.75, Color3.fromRGB(180, 30, 30)),
ColorSequenceKeypoint.new(1.0, Color3.fromRGB(40, 10, 10)),
})
borderGrad.Rotation = 0
borderGrad.Parent = borderFrame

local innerMask = Instance.new("Frame")
innerMask.Name = "InnerMask"
innerMask.Size = UDim2.new(1, -2, 1, -2)
innerMask.Position = UDim2.new(0.5, 0, 0.5, 0)
innerMask.AnchorPoint = Vector2.new(0.5, 0.5)
innerMask.BackgroundColor3 = COLORS.bg
innerMask.BorderSizePixel = 0
innerMask.ZIndex = 1
innerMask.Parent = main

local innerCorner = Instance.new("UICorner")
innerCorner.CornerRadius = UDim.new(0, 7)
innerCorner.Parent = innerMask

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -16, 0, HEADER_H)
title.Position = UDim2.new(0, 8, 0, 0)
title.BackgroundTransparency = 1
title.Font = FONT
title.Text = "Killerhub"
title.TextColor3 = COLORS.accentBright
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Center
title.ZIndex = 3
title.Parent = main

-- ===== Toggle Button =====
local toggle = Instance.new("TextButton")
toggle.Name = "Toggle"
toggle.Size = UDim2.new(1, -16, 0, TOGGLE_H)
toggle.Position = UDim2.new(0, 8, 0, HEADER_H + 4)
toggle.BackgroundColor3 = COLORS.disabled
toggle.BorderSizePixel = 0
toggle.Font = FONT
toggle.Text = ""
toggle.TextTransparency = 1
toggle.AutoButtonColor = false
toggle.ZIndex = 3
toggle.Parent = main

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggle

local toggleGrad = Instance.new("UIGradient")
toggleGrad.Color = ColorSequence.new(COLORS.disabled, Color3.fromRGB(45, 20, 20))
toggleGrad.Rotation = 135
toggleGrad.Parent = toggle

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = COLORS.border
toggleStroke.Thickness = 1.4
toggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
toggleStroke.Parent = toggle

local toggleLabel = Instance.new("TextLabel")
toggleLabel.Name = "Label"
toggleLabel.Size = UDim2.new(1, 0, 1, 0)
toggleLabel.Position = UDim2.new(0, 0, 0, 0)
toggleLabel.BackgroundTransparency = 1
toggleLabel.Font = FONT
toggleLabel.Text = "DISABLED"
toggleLabel.TextColor3 = COLORS.white
toggleLabel.TextSize = 12
toggleLabel.TextXAlignment = Enum.TextXAlignment.Center
toggleLabel.TextYAlignment = Enum.TextYAlignment.Center
toggleLabel.ZIndex = 5
toggleLabel.Parent = toggle

-- ===== Keybind Button =====
local keybindBtn = Instance.new("TextButton")
keybindBtn.Name = "KeybindBtn"
keybindBtn.Size = UDim2.new(1, -16, 0, KEYBIND_H)
keybindBtn.Position = UDim2.new(0, 8, 0, HEADER_H + TOGGLE_H + 10)
keybindBtn.BackgroundColor3 = COLORS.surface
keybindBtn.BorderSizePixel = 0
keybindBtn.Font = FONT
keybindBtn.Text = "Key: [" .. savedData.toggleKey.Name .. "]"
keybindBtn.TextColor3 = COLORS.text
keybindBtn.TextSize = 9
keybindBtn.AutoButtonColor = false
keybindBtn.ZIndex = 3
keybindBtn.Parent = main

local kbCorner = Instance.new("UICorner")
kbCorner.CornerRadius = UDim.new(0, 5)
kbCorner.Parent = keybindBtn

local kbStroke = Instance.new("UIStroke")
kbStroke.Color = COLORS.border
kbStroke.Thickness = 1
kbStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
kbStroke.Parent = keybindBtn

local active = false
local isBinding = false

-- ===== Active State Logic =====
RunService.RenderStepped:Connect(function(dt)
local speed = active and 160 or 60
borderGrad.Rotation = (borderGrad.Rotation + speed * dt) % 360
end)

local function setActive(state)
active = state
savedData.active = state

if state then
toggle.BackgroundColor3 = COLORS.accentBright
toggleGrad.Color = ColorSequence.new(COLORS.accent, COLORS.accentBright)
toggleGrad.Rotation = 0
toggleStroke.Color = COLORS.white
toggleLabel.Text = "ENABLED"
toggleLabel.TextColor3 = COLORS.white
if api and api.start then pcall(api.start) end
else
toggle.BackgroundColor3 = COLORS.disabled
toggleGrad.Color = ColorSequence.new(COLORS.disabled, Color3.fromRGB(45, 20, 20))
toggleGrad.Rotation = 135
toggleStroke.Color = COLORS.border
toggleLabel.Text = "DISABLED"
toggleLabel.TextColor3 = COLORS.white
if api and api.stop then pcall(api.stop) end
end
end

toggle.MouseButton1Click:Connect(function()
setActive(not active)
end)

-- ===== Keybind Button Logic =====
keybindBtn.MouseButton1Click:Connect(function()
if isBinding then return end
isBinding = true
keybindBtn.Text = "Press Key..."
keybindBtn.TextColor3 = COLORS.accentBright
kbStroke.Color = COLORS.accentBright
end)

-- ===== Dragging (via title bar only) =====
local dragging = false
local dragStart, startPos

title.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
dragStart = input.Position
startPos = main.Position
end
end)

UserInputService.InputChanged:Connect(function(input)
if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
local delta = input.Position - dragStart
main.Position = UDim2.new(
startPos.X.Scale, startPos.X.Offset + delta.X,
startPos.Y.Scale, startPos.Y.Offset + delta.Y
)
savedData.position = main.Position
end
end)

UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = false
end
end)

-- ===== GLOBAL INPUT (Keybinds) =====
UserInputService.InputBegan:Connect(function(input, gameProcessed)
if gameProcessed then return end

if isBinding then
if input.UserInputType == Enum.UserInputType.Keyboard then
savedData.toggleKey = input.KeyCode
savedData.toggleUserButton = nil
keybindBtn.Text = "Key: [" .. savedData.toggleKey.Name .. "]"
keybindBtn.TextColor3 = COLORS.text
kbStroke.Color = COLORS.border
isBinding = false
elseif input.UserInputType == Enum.UserInputType.Gamepad1 then
savedData.toggleKey = input.KeyCode
savedData.toggleUserButton = nil
keybindBtn.Text = "Key: [" .. savedData.toggleKey.Name .. "]"
keybindBtn.TextColor3 = COLORS.text
kbStroke.Color = COLORS.border
isBinding = false
end
return
end

if input.KeyCode == savedData.toggleKey then
setActive(not active)
end
end)