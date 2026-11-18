-- HAZ DISCONNECT
-- Full Updated Script

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Cleanup old GUI
local oldGui = playerGui:FindFirstChild("HazDisconnect")
if oldGui then
    oldGui:Destroy()
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "HazDisconnect"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Disconnect Button
local button = Instance.new("TextButton")
button.Name = "Disconnect"
button.Size = UDim2.fromOffset(110, 110)
button.Position = UDim2.fromOffset(16, 16)
button.BackgroundColor3 = Color3.fromRGB(210, 25, 35)
button.Text = "Disconnect"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 15
button.Font = Enum.Font.GothamBold
button.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = button

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 80, 80)
stroke.Thickness = 2
stroke.Parent = button

-- Dragging
local dragging = false
local dragStart
local startPos
local dragInput
local dragMoved = false

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragMoved = false
        dragStart = input.Position
        startPos = button.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart

        if delta.Magnitude > 5 then
            dragMoved = true
        end

        button.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Manual Disconnect
button.Activated:Connect(function()
    if dragMoved then
        dragMoved = false
        return
    end

    player:Kick("Disconnected.")
end)

-- KICK ON STEAL
local alreadyKicked = false

-- Clean RichText / HTML
local function cleanText(text)
    text = text:gsub("<[^>]->", "")
    text = text:gsub("&quot;", '"')
    text = text:gsub("&amp;", "&")
    text = text:gsub("&lt;", "<")
    text = text:gsub("&gt;", ">")
    text = text:gsub("&nbsp;", " ")

    return text
end

-- Detect stolen item
local function checkText(object)
    if alreadyKicked then return end

    if not (
        object:IsA("TextLabel")
        or object:IsA("TextButton")
        or object:IsA("TextBox")
    ) then
        return
    end

    local success, text = pcall(function()
        return object.Text
    end)

    if not success or type(text) ~= "string" then
        return
    end

    text = cleanText(text)

    local stolenItem = text:match("[Yy]ou%s+[Ss]tole%s+(.+)")

    if stolenItem then
        stolenItem = stolenItem:gsub("^%s+", "")
        stolenItem = stolenItem:gsub("%s+$", "")

        alreadyKicked = true
        player:Kick("You stole: " .. stolenItem)
    end
end

-- Scan existing UI
for _, object in ipairs(playerGui:GetDescendants()) do
    checkText(object)

    if alreadyKicked then
        return
    end
end

-- Detect newly created UI
playerGui.DescendantAdded:Connect(function(object)
    task.defer(checkText, object)
end)

-- Detect text changes
local function monitorObject(object)
    if object:IsA("TextLabel")
    or object:IsA("TextButton")
    or object:IsA("TextBox") then

        object:GetPropertyChangedSignal("Text"):Connect(function()
            checkText(object)
        end)
    end
end

for _, object in ipairs(playerGui:GetDescendants()) do
    monitorObject(object)
end

playerGui.DescendantAdded:Connect(monitorObject)