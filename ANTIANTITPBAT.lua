-- Fade Hub - Fade Anti Anti Desync
-- Converted to Fade Hub UI with Black/White Theme
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local NetworkClient = game:GetService("NetworkClient")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local environment = if getgenv then getgenv() else _G
local RUNTIME_KEY = "__FADE_ANTI_ANTI_DESYNC"
local previousRuntime = environment[RUNTIME_KEY]
if type(previousRuntime) == "table" and type(previousRuntime.destroy) == "function" then
pcall(previousRuntime.destroy)
end
local runtime = {
alive = true,
enabled = false,
awaitingKey = false,
boundKey = Enum.KeyCode.Delete,
character = nil,
rootPart = nil,
fakeRoot = nil,
repRootOwner = nil,
stepConnection = nil,
connections = {},
settingsRestore = {},
captureGeneration = 0,
gui = nil,
}
environment[RUNTIME_KEY] = runtime
-- Color Scheme: Black & White
local COLORS = {
main = Color3.fromRGB(10, 10, 10),
background = Color3.fromRGB(20, 20, 20),
surface = Color3.fromRGB(30, 30, 30),
surfaceHover = Color3.fromRGB(45, 45, 45),
accent = Color3.fromRGB(255, 255, 255),
text = Color3.fromRGB(255, 255, 255),
textSecondary = Color3.fromRGB(160, 160, 160),
border = Color3.fromRGB(60, 60, 60),
shadow = Color3.fromRGB(0, 0, 0),
active = Color3.fromRGB(255, 255, 255),
inactive = Color3.fromRGB(50, 50, 50),
}
local function connect(signal, callback)
local connection = signal:Connect(callback)
table.insert(runtime.connections, connection)
return connection
end
local function disconnect(connection)
if connection then
pcall(function()
connection:Disconnect()
end)
end
end
local function createInstance(className, properties, parent)
local object = Instance.new(className)
for property, value in pairs(properties or {}) do
object[property] = value
end
if parent then
object.Parent = parent
end
return object
end
local function addCorner(parent, radius)
return createInstance("UICorner", {
CornerRadius = typeof(radius) == "UDim" and radius or UDim.new(0, radius),
}, parent)
end
local function addStroke(parent, color, transparency, thickness)
return createInstance("UIStroke", {
ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
Color = color,
Transparency = transparency,
Thickness = thickness,
}, parent)
end
local function playTween(object, duration, goals)
local animation = TweenService:Create(
object,
TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
goals
)
end
animation:Play()
return animation
local function isBasePart(instance)
if not instance then
return false
end
local ok, result = pcall(function()
return instance:IsA("BasePart")
end)
return ok and result == true
end
local function getCurrentRoot(character)
character = character or LocalPlayer.Character
if not character then
return nil
end
local ok, root = pcall(function()
return character:FindFirstChild("HumanoidRootPart")
end)
if ok and isBasePart(root) then
return root
end
return nil
end
local function findGlobalFunction(...)
for index = 1, select("#", ...) do
local name = select(index, ...)
local value = rawget(environment, name)
if type(value) == "function" then
return value
end
end
return nil
end
local function setHidden(instance, property, value)
if not instance then
return false
end
local setter = findGlobalFunction(
"sethiddenproperty",
"set_hidden_property",
"sethiddenprop",
"set_hidden_prop"
)
if setter then
local ok = pcall(setter, instance, property, value)
if ok then
return true
end
end
return pcall(function()
instance[property] = value
end)
end
local function getHidden(instance, property)
if not instance then
return false, nil
end
local getter = findGlobalFunction(
"gethiddenproperty",
"get_hidden_property",
"gethiddenprop",
"get_hidden_prop"
)
if getter then
local ok, value = pcall(getter, instance, property)
if ok then
return true, value
end
end
local ok, value = pcall(function()
return instance[property]
end)
return ok, value
end
local function rememberSetting(instance, property)
local ok, value = pcall(function()
return instance[property]
end)
if ok then
table.insert(runtime.settingsRestore, {
instance = instance,
property = property,
value = value,
})
end
end
local function applyPublicSetting(instance, property, value)
if not instance then
return false
end
rememberSetting(instance, property)
return pcall(function()
instance[property] = value
end)
end
local function configurePhysics()
setHidden(LocalPlayer, "MaximumSimulationRadius", math.huge)
setHidden(LocalPlayer, "SimulationRadius", math.huge)
pcall(function()
local networkSettings = settings().Network
applyPublicSetting(
networkSettings,
"InterpolationThrottling",
Enum.InterpolationThrottlingMode.Disabled
)
end)
pcall(function()
local physicsSettings = settings().Physics
applyPublicSetting(
physicsSettings,
"PhysicsEnvironmentalThrottle",
Enum.EnviromentalPhysicsThrottle.Disabled
)
end)
applyPublicSetting(physicsSettings, "AllowSleep", false)
pcall(function()
NetworkClient:SetOutgoingKBPSLimit(math.huge)
end)
end
configurePhysics()
local FAKE_ROOT_NAME = "FadeDesyncRoot"
local FAKE_ROOT_Y = -2500
local FAKE_ROOT_VELOCITY = Vector3.new(0, -1000, 0)
local function fakeRootIsUsable()
local fake = runtime.fakeRoot
if not isBasePart(fake) then
return false
end
local ok, parent = pcall(function()
return fake.Parent
end)
return ok and parent ~= nil
end
local function destroyFakeRoot()
local fake = runtime.fakeRoot
runtime.fakeRoot = nil
if fake then
pcall(function()
fake:Destroy()
end)
end
end
local function restoreReplicationRoot()
local owner = runtime.repRootOwner or runtime.rootPart
if isBasePart(owner) then
setHidden(owner, "PhysicsRepRootPart", owner)
end
end
runtime.repRootOwner = nil
local function createFakeRoot(rootPart)
destroyFakeRoot()
local fake = createInstance("Part", {
Name = FAKE_ROOT_NAME,
Size = Vector3.new(2, 2, 1),
Anchored = true,
CanCollide = false,
CanTouch = false,
CanQuery = false,
Transparency = 1,
CFrame = CFrame.new(0, FAKE_ROOT_Y, 0),
AssemblyLinearVelocity = FAKE_ROOT_VELOCITY,
}, Workspace)
local ok, position = pcall(function()
return rootPart.Position
end)
if ok then
end
fake.CFrame = CFrame.new(position.X, FAKE_ROOT_Y, position.Z)
runtime.fakeRoot = fake
return fake
end
local function assignFakeReplicationRoot(rootPart, fake)
if not isBasePart(rootPart) or not isBasePart(fake) then
return false
end
setHidden(rootPart, "PhysicsRepRootPart", rootPart)
runtime.repRootOwner = rootPart
return setHidden(rootPart, "PhysicsRepRootPart", fake)
end
local function stepDesync()
if not runtime.alive or not runtime.enabled then
return
end
local root = runtime.rootPart
if not isBasePart(root) then
root = getCurrentRoot(runtime.character)
runtime.rootPart = root
end
if not root then
return
end
if not fakeRootIsUsable() then
local fake = createFakeRoot(root)
assignFakeReplicationRoot(root, fake)
return
end
local fake = runtime.fakeRoot
local ok, rootPosition, fakePosition = pcall(function()
return root.Position, fake.Position
end)
if ok and (
math.abs(rootPosition.X - fakePosition.X) > 0.01
or math.abs(rootPosition.Z - fakePosition.Z) > 0.01
or math.abs(fakePosition.Y - FAKE_ROOT_Y) > 0.01
) then
pcall(function()
fake.CFrame = CFrame.new(rootPosition.X, FAKE_ROOT_Y, rootPosition.Z)
end)
end
pcall(function()
fake.Anchored = true
fake.AssemblyLinearVelocity = FAKE_ROOT_VELOCITY
end)
local gotValue, current = getHidden(root, "PhysicsRepRootPart")
if not gotValue or current ~= fake then
setHidden(root, "PhysicsRepRootPart", fake)
end
end
local function stopStepConnection()
disconnect(runtime.stepConnection)
runtime.stepConnection = nil
end
local function startStepConnection()
stopStepConnection()
runtime.stepConnection = RunService.Stepped:Connect(stepDesync)
end
local function bindCharacter(character)
local oldRoot = runtime.rootPart
runtime.character = character
runtime.rootPart = getCurrentRoot(character)
if runtime.enabled then
if isBasePart(oldRoot) and oldRoot ~= runtime.rootPart then
setHidden(oldRoot, "PhysicsRepRootPart", oldRoot)
end
destroyFakeRoot()
local root = runtime.rootPart
if not root and character then
local ok, waitedRoot = pcall(function()
return character:WaitForChild("HumanoidRootPart", 8)
end)
if ok and isBasePart(waitedRoot) then
root = waitedRoot
runtime.rootPart = root
end
end
if root then
local fake = createFakeRoot(root)
assignFakeReplicationRoot(root, fake)
startStepConnection()
end
end
end
bindCharacter(LocalPlayer.Character)
connect(LocalPlayer.CharacterAdded, function(character)
task.defer(bindCharacter, character)
end)
-- ===== UI REFERENCES =====
local UI = {
statusLabel = nil,
statusDot = nil,
toggleTrack = nil,
toggleKnob = nil,
glow = nil,
keybindButton = nil,
}
-- ===== UI FUNCTIONS =====
local function applyEnabledVisual(value, instant)
if not UI.statusLabel then return end
UI.statusLabel.Text = value and "ACTIVE" or "OFF"
UI.statusLabel.TextColor3 = value and COLORS.text or COLORS.textSecondary
UI.statusDot.BackgroundColor3 = value and COLORS.text or COLORS.inactive
local trackColor = value and COLORS.text or COLORS.inactive
local knobPosition = value and UDim2.new(1, -20, 0, 4) or UDim2.new(0, 4, 0, 4)
local glowTransparency = value and 0.7 or 0.9
if instant then
UI.toggleTrack.BackgroundColor3 = trackColor
UI.toggleKnob.Position = knobPosition
UI.glow.BackgroundTransparency = glowTransparency
else
playTween(UI.toggleTrack, 0.2, { BackgroundColor3 = trackColor })
playTween(UI.toggleKnob, 0.2, { Position = knobPosition })
playTween(UI.glow, 0.2, { BackgroundTransparency = glowTransparency })
end
end
local function setEnabled(value)
if not runtime.alive then
return false
end
value = value == true
if runtime.enabled == value then
applyEnabledVisual(value, false)
return value
end
runtime.enabled = value
applyEnabledVisual(value, false)
if value then
local root = getCurrentRoot(runtime.character)
runtime.rootPart = root
if not root then
runtime.enabled = false
applyEnabledVisual(false, false)
return false
end
local fake = createFakeRoot(root)
assignFakeReplicationRoot(root, fake)
startStepConnection()
else
end
stopStepConnection()
restoreReplicationRoot()
destroyFakeRoot()
return runtime.enabled
end
local function toggleEnabled()
return setEnabled(not runtime.enabled)
end
-- ===== CREATE UI =====
local function CreateFadeUI()
-- Clean up old UI
local uiParent = CoreGui
local oldGui = uiParent:FindFirstChild("FadeAntiAntiDesync")
if oldGui then
oldGui:Destroy()
end
-- Create ScreenGui
local screenGui = createInstance("ScreenGui", {
Name = "FadeAntiAntiDesync",
DisplayOrder = 999,
ResetOnSpawn = false,
IgnoreGuiInset = true,
ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
local parented = pcall(function()
screenGui.Parent = uiParent
end)
if not parented then
local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
or LocalPlayer:WaitForChild("PlayerGui")
uiParent = playerGui
local stale = uiParent:FindFirstChild("FadeAntiAntiDesync")
if stale then
stale:Destroy()
end
screenGui.Parent = uiParent
end
runtime.gui = screenGui
-- Main Frame
local main = createInstance("Frame", {
Name = "Main",
Active = true,
ClipsDescendants = true,
BackgroundTransparency = 0.08,
BackgroundColor3 = COLORS.main,
BorderSizePixel = 0,
Position = UDim2.new(0.5, -155, 0.5, -90),
Size = UDim2.new(0, 310, 0, 170),
}, screenGui)
addCorner(main, 12)
addStroke(main, COLORS.border, 0.5, 1.5)
-- Shadow
local shadow = createInstance("ImageLabel", {
Name = "Shadow",
BackgroundTransparency = 1,
Image = "rbxassetid://1316045217",
ImageColor3 = COLORS.shadow,
ImageTransparency = 0.6,
ScaleType = Enum.ScaleType.Slice,
SliceCenter = Rect.new(10, 10, 10, 10),
Position = UDim2.new(0, -5, 0, -5),
Size = UDim2.new(1, 10, 1, 10),
ZIndex = 0,
}, main)
-- Header
local header = createInstance("Frame", {
Name = "Header",
BackgroundTransparency = 1,
Position = UDim2.new(0, 16, 0, 8),
ZIndex = 10,
Size = UDim2.new(1, -24, 0, 36),
}, main)
 local title = createInstance("TextLabel", {
Name = "Title",
BackgroundTransparency = 1,
Text = "FADE ANTI ANTI",
TextColor3 = COLORS.text,
Font = Enum.Font.GothamBlack,
Position = UDim2.new(0, 0, 0, 0),
TextXAlignment = Enum.TextXAlignment.Left,
ZIndex = 11,
TextSize = 16,
Size = UDim2.new(1, -40, 1, 0),
}, header)
-- Status indicator dot
local statusDot = createInstance("Frame", {
Name = "StatusDot",
BackgroundColor3 = COLORS.inactive,
BorderSizePixel = 0,
AnchorPoint = Vector2.new(1, 0.5),
Position = UDim2.new(1, 0, 0.5, 0),
Size = UDim2.new(0, 8, 0, 8),
ZIndex = 11,
}, header)
addCorner(statusDot, 4)
UI.statusDot = statusDot
-- Content
local content = createInstance("Frame", {
Name = "Content",
BackgroundTransparency = 1,
Position = UDim2.new(0, 16, 0, 50),
ZIndex = 5,
Size = UDim2.new(1, -28, 1, -58),
}, main)
createInstance("UIListLayout", {
Padding = UDim.new(0, 10),
SortOrder = Enum.SortOrder.LayoutOrder,
}, content)
-- Toggle Row
local toggleRow = createInstance("Frame", {
Name = "ToggleRow",
BackgroundColor3 = COLORS.surface,
BackgroundTransparency = 0.3,
BorderSizePixel = 0,
Size = UDim2.new(1, 0, 0, 46),
LayoutOrder = 1,
ZIndex = 5,
}, content)
addCorner(toggleRow, 8)
addStroke(toggleRow, COLORS.border, 0.4, 1)
-- Hover effect
local hoverEffect = createInstance("Frame", {
Name = "Hover",
BackgroundColor3 = COLORS.text,
BackgroundTransparency = 0.95,
BorderSizePixel = 0,
Size = UDim2.new(1, 0, 1, 0),
ZIndex = 1,
}, toggleRow)
addCorner(hoverEffect, 8)
-- Label
local toggleLabel = createInstance("TextLabel", {
Name = "Label",
BackgroundTransparency = 1,
Text = "Enable Anti Anti",
TextColor3 = COLORS.text,
Font = Enum.Font.GothamBold,
Position = UDim2.new(0, 14, 0, 0),
TextXAlignment = Enum.TextXAlignment.Left,
ZIndex = 6,
TextSize = 13,
Size = UDim2.new(1, -74, 1, 0),
}, toggleRow)
-- Status label
local statusLabel = createInstance("TextLabel", {
Name = "Status",
BackgroundTransparency = 1,
Text = "OFF",
TextColor3 = COLORS.textSecondary,
Font = Enum.Font.GothamMedium,
Position = UDim2.new(0, 14, 0, 20),
TextXAlignment = Enum.TextXAlignment.Left,
ZIndex = 6,
TextSize = 10,
Size = UDim2.new(1, -74, 1, 0),
}, toggleRow)
UI.statusLabel = statusLabel
-- Toggle Switch
local toggleTrack = createInstance("Frame", {
Name = "Toggle",
AnchorPoint = Vector2.new(1, 0.5),
BackgroundColor3 = COLORS.inactive,
BorderSizePixel = 0,
Position = UDim2.new(1, -12, 0.5, 0),
ZIndex = 7,
Size = UDim2.new(0, 46, 0, 24),
}, toggleRow)
addCorner(toggleTrack, 12)
addStroke(toggleTrack, COLORS.border, 0.3, 1)
UI.toggleTrack = toggleTrack
-- Glow effect
local glow = createInstance("Frame", {
Name = "Glow",
BackgroundColor3 = COLORS.text,
BackgroundTransparency = 0.9,
BorderSizePixel = 0,
Size = UDim2.new(1, 8, 1, 8),
Position = UDim2.new(0, -4, 0, -4),
ZIndex = 0,
}, toggleTrack)
addCorner(glow, 14)
UI.glow = glow
local toggleKnob = createInstance("Frame", {
Name = "Knob",
BackgroundColor3 = COLORS.text,
BorderSizePixel = 0,
Size = UDim2.new(0, 16, 0, 16),
Position = UDim2.new(0, 4, 0, 4),
ZIndex = 8,
}, toggleTrack)
addCorner(toggleKnob, 8)
UI.toggleKnob = toggleKnob
-- Inner shadow on knob
local knobInner = createInstance("Frame", {
Name = "Inner",
BackgroundColor3 = COLORS.surface,
BackgroundTransparency = 0.5,
BorderSizePixel = 0,
Size = UDim2.new(0, 12, 0, 12),
Position = UDim2.new(0, 2, 0, 2),
ZIndex = 9,
}, toggleKnob)
addCorner(knobInner, 6)
-- Click area
local toggleHit = createInstance("TextButton", {
Name = "ToggleHit",
BackgroundTransparency = 1,
BorderSizePixel = 0,
Text = "",
AutoButtonColor = false,
ZIndex = 9,
Size = UDim2.new(1, 0, 1, 0),
}, toggleRow)
-- Keybind Row
local keybindRow = createInstance("Frame", {
Name = "KeybindRow",
BackgroundColor3 = COLORS.surface,
BackgroundTransparency = 0.3,
BorderSizePixel = 0,
Size = UDim2.new(1, 0, 0, 46),
LayoutOrder = 2,
ZIndex = 5,
}, content)
addCorner(keybindRow, 8)
addStroke(keybindRow, COLORS.border, 0.4, 1)
local keybindLabel = createInstance("TextLabel", {
Name = "Label",
BackgroundTransparency = 1,
Text = "Keybind",
TextColor3 = COLORS.text,
Font = Enum.Font.GothamBold,
Position = UDim2.new(0, 14, 0, 0),
TextXAlignment = Enum.TextXAlignment.Left,
ZIndex = 6,
TextSize = 13,
Size = UDim2.new(1, -84, 1, 0),
}, keybindRow)
-- Keybind Button
local keybindButton = createInstance("TextButton", {
Name = "KeybindBtn",
AutoButtonColor = false,
AnchorPoint = Vector2.new(1, 0.5),
BackgroundColor3 = COLORS.surface,
BackgroundTransparency = 0.2,
BorderSizePixel = 0,
Position = UDim2.new(1, -12, 0.5, 0),
Size = UDim2.new(0, 80, 0, 28),
Text = "Delete",
TextColor3 = COLORS.text,
Font = Enum.Font.GothamBlack,
TextSize = 12,
ZIndex = 7,
}, keybindRow)
addCorner(keybindButton, 6)
addStroke(keybindButton, COLORS.border, 0.4, 1.2)
UI.keybindButton = keybindButton
-- Bind key display
local bindHint = createInstance("TextLabel", {
Name = "BindHint",
BackgroundTransparency = 1,
Text = "Click to change",
TextColor3 = COLORS.textSecondary,
Font = Enum.Font.Gotham,
Position = UDim2.new(0, 14, 0, 22),
TextXAlignment = Enum.TextXAlignment.Left,
ZIndex = 6,
TextSize = 9,
Size = UDim2.new(1, -84, 1, 0),
}, keybindRow)
-- ===== EVENT CONNECTIONS =====
-- Toggle Button Click
toggleHit.MouseButton1Click:Connect(function()
toggleEnabled()
end)
-- Also make clicking the row work
toggleRow.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
toggleEnabled()
end
end)
-- Keybind Button Click
keybindButton.MouseButton1Click:Connect(function()
if not runtime.alive or runtime.awaitingKey then
return
end
runtime.awaitingKey = true
runtime.captureGeneration += 1
local generation = runtime.captureGeneration
task.spawn(function()
local texts = {"Press", "Press.", "Press..", "Press..."}
for _, text in ipairs(texts) do
if not runtime.alive or not runtime.awaitingKey or generation ~=
runtime.captureGeneration then
return
end
keybindButton.Text = text
task.wait(0.15)
end
end)
end)
-- Keyboard Input
connect(UserInputService.InputBegan, function(input, gameProcessed)
if not runtime.alive then
return
end
-- Keybind capture
if runtime.awaitingKey then
if input.UserInputType == Enum.UserInputType.Keyboard
and input.KeyCode ~= Enum.KeyCode.Unknown
then
if input.KeyCode ~= Enum.KeyCode.Escape then
runtime.boundKey = input.KeyCode
keybindButton.Text = input.KeyCode.Name
end
runtime.awaitingKey = false
runtime.captureGeneration += 1
end
return
end
-- Toggle with keybind
if not gameProcessed and input.KeyCode == runtime.boundKey then
toggleEnabled()
end
end)
-- Also handle console/controller input
connect(UserInputService.InputBegan, function(input, gameProcessed)
if not runtime.alive or runtime.awaitingKey then
return
end
-- Check for button presses on console/controller
if input.UserInputType == Enum.UserInputType.Gamepad1 or
input.UserInputType == Enum.UserInputType.Gamepad2 or
input.UserInputType == Enum.UserInputType.Gamepad3 or
input.UserInputType == Enum.UserInputType.Gamepad4 then
-- Map some common controller buttons to toggle
if input.KeyCode == Enum.KeyCode.ButtonX or
input.KeyCode == Enum.KeyCode.ButtonY or
input.KeyCode == Enum.KeyCode.ButtonR1 or
input.KeyCode == Enum.KeyCode.ButtonL1 then
if not gameProcessed then
toggleEnabled()
end
end
end
end)
-- ===== DRAGGING =====
local dragging = false
local dragInput = nil
local dragStart = nil
local startPosition = nil
main.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch
then
dragging = true
dragInput = input
dragStart = input.Position
startPosition = main.Position
local changedConnection
changedConnection = input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then
dragging = false
dragInput = nil
disconnect(changedConnection)
end
end)
end
end)
main.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement
or input.UserInputType == Enum.UserInputType.Touch
then
end
end)
dragInput = input
connect(UserInputService.InputChanged, function(input)
if not dragging or input ~= dragInput or not dragStart or not startPosition then
return
end
local delta = input.Position - dragStart
main.Position = UDim2.new(
startPosition.X.Scale,
startPosition.X.Offset + delta.X,
startPosition.Y.Scale,
startPosition.Y.Offset + delta.Y
)
end)
-- ===== RIPPLE EFFECT =====
local function createRipple(row)
if not runtime.alive or not row or not row.Parent then
return
end
local mousePosition = UserInputService:GetMouseLocation()
local absolutePosition = row.AbsolutePosition
local absoluteSize = row.AbsoluteSize
local x = mousePosition.X - absolutePosition.X
local y = mousePosition.Y - absolutePosition.Y
local diameter = math.max(absoluteSize.X, absoluteSize.Y) * 1.35
local image = createInstance("ImageLabel", {
Name = "Ripple",
BackgroundTransparency = 1,
Image = "rbxassetid://266543268",
ImageColor3 = COLORS.text,
ImageTransparency = 0.6,
AnchorPoint = Vector2.new(0.5, 0.5),
Position = UDim2.new(0, x, 0, y),
Size = UDim2.new(0, 0, 0, 0),
ZIndex = 30,
}, row)
local animation = playTween(image, 0.45, {
Size = UDim2.new(0, diameter, 0, diameter),
ImageTransparency = 1,
})
animation.Completed:Connect(function()
if image then
image:Destroy()
end
end)
end
-- Add ripple to toggle
toggleHit.MouseButton1Click:Connect(function()
createRipple(toggleRow)
end)
-- Add ripple to keybind
keybindButton.MouseButton1Click:Connect(function()
createRipple(keybindRow)
end)
-- Hover effect
local function setupHover(row, effect)
row.MouseEnter:Connect(function()
playTween(effect, 0.15, { BackgroundTransparency = 0.9 })
end)
row.MouseLeave:Connect(function()
playTween(effect, 0.15, { BackgroundTransparency = 0.95 })
end)
end
setupHover(toggleRow, hoverEffect)
-- Apply initial state
applyEnabledVisual(false, true)
return main
end
-- ===== CREATE UI =====
CreateFadeUI()
-- ===== DESTROY FUNCTION =====
local function destroy()
if not runtime.alive then
return
end
runtime.alive = false
runtime.enabled = false
runtime.awaitingKey = false
runtime.captureGeneration += 1
stopStepConnection()
restoreReplicationRoot()
destroyFakeRoot()
for _, connection in ipairs(runtime.connections) do
disconnect(connection)
end
table.clear(runtime.connections)
for index = #runtime.settingsRestore, 1, -1 do
local entry = runtime.settingsRestore[index]
pcall(function()
entry.instance[entry.property] = entry.value
end)
end
table.clear(runtime.settingsRestore)
if runtime.gui then
pcall(function()
runtime.gui:Destroy()
end)
end
if environment[RUNTIME_KEY] == runtime then
environment[RUNTIME_KEY] = nil
end
end
-- ===== EXPOSE FUNCTIONS =====
runtime.setEnabled = setEnabled
runtime.toggle = toggleEnabled
runtime.step = stepDesync
runtime.bindCharacter = bindCharacter
runtime.setHidden = setHidden
runtime.getHidden = getHidden
runtime.destroy = destroy
runtime.getBoundKey = function()
return runtime.boundKey
end
runtime.setBoundKey = function(keyCode)
if keyCode and keyCode ~= Enum.KeyCode.Unknown then
runtime.boundKey = keyCode
if UI.keybindButton then
UI.keybindButton.Text = keyCode.Name
end
return true
end
return false
end
print("Fade Anti Anti Desync loaded successfully!")
print("Press " .. runtime.boundKey.Name .. " to toggle")