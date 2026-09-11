-- ROLEX Spam Grab | Tiny GUI | Super Fast | Buttons 100% Working
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Get remote
local RF
pcall(function()
    RF = game:GetService("ReplicatedStorage").Packages.Knit.Services.CombatService.RF.Grab
end)

if not RF then
    warn("ROLEX: Grab remote not found!")
    return
end

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ROLEX_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function()
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = game:GetService("CoreGui")
end

-- Main Frame
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 90, 0, 78)
Main.Position = UDim2.new(0, 10, 0, 60)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 6)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 215, 0)
MainStroke.Thickness = 1
MainStroke.Parent = Main

-- ROLEX Title (drag handle only - prevents button conflicts)
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 18)
Title.BackgroundTransparency = 1
Title.Text = "ROLEX"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.Active = true
Title.Parent = Main

-- Toggle Button
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, -8, 0, 26)
ToggleBtn.Position = UDim2.new(0, 4, 0, 20)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
ToggleBtn.Text = "START"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 12
ToggleBtn.AutoButtonColor = true
ToggleBtn.Active = true
ToggleBtn.Parent = Main

local TCorner = Instance.new("UICorner")
TCorner.CornerRadius = UDim.new(0, 4)
TCorner.Parent = ToggleBtn

-- Speed Button
local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Size = UDim2.new(1, -8, 0, 26)
SpeedBtn.Position = UDim2.new(0, 4, 0, 48)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
SpeedBtn.Text = "INSANE"
SpeedBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
SpeedBtn.Font = Enum.Font.GothamBold
SpeedBtn.TextSize = 11
SpeedBtn.AutoButtonColor = true
SpeedBtn.Active = true
SpeedBtn.Parent = Main

local SCorner = Instance.new("UICorner")
SCorner.CornerRadius = UDim.new(0, 4)
SCorner.Parent = SpeedBtn

-- ===== DRAG LOGIC (only on Title, not on buttons!) =====
local dragging = false
local dragStart, startPos

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

Title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- ===== SPAM LOGIC =====
local spamming = false
local speedIdx = 1
local loopThread = nil

local speedModes = {
    {name = "INSANE", delay = 0.01},
    {name = "SUPER",  delay = 0.005},
    {name = "ULTRA",  delay = 0.001},
    {name = "MAX",    delay = 0},
}

local function stopSpam()
    spamming = false
    if loopThread then
        pcall(function() task.cancel(loopThread) end)
        loopThread = nil
    end
end

local function startSpam()
    stopSpam()
    spamming = true
    local mode = speedModes[speedIdx]

    if mode.delay <= 0 then
        loopThread = task.spawn(function()
            while spamming do
                pcall(function() RF:InvokeServer() end)
                RunService.Heartbeat:Wait()
            end
        end)
    else
        loopThread = task.spawn(function()
            while spamming do
                pcall(function() RF:InvokeServer() end)
                task.wait(mode.delay)
            end
        end)
    end
end

-- ===== BUTTON HANDLERS =====
local function onToggle()
    if spamming then
        stopSpam()
        ToggleBtn.Text = "START"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    else
        startSpam()
        ToggleBtn.Text = "STOP"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    end
end

local function onSpeed()
    speedIdx = speedIdx + 1
    if speedIdx > #speedModes then speedIdx = 1 end
    SpeedBtn.Text = speedModes[speedIdx].name
    if spamming then startSpam() end
end

-- ===== THE FIX: use Activated ONLY (works on PC + mobile, no double-fire) =====
-- Activated fires for: mouse click, touch tap, gamepad, AND keyboard.
-- Using ONLY Activated prevents the double/triple firing that
-- MouseButton1Click + TouchTap + Activated together cause.
ToggleBtn.Activated:Connect(onToggle)
SpeedBtn.Activated:Connect(onSpeed)

print("⚡ ROLEX loaded! Buttons working on PC + Mobile.")