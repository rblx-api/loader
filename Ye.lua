-- JESUS PACKET LAGGER - MINIMAL / GUARANTEED LOAD
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("JESUSPACKETLAGGER")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "JESUSPACKETLAGGER"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = playerGui

local card = Instance.new("Frame")
card.Size = UDim2.fromOffset(260, 180)
card.Position = UDim2.fromScale(0.5, 0.5)
card.AnchorPoint = Vector2.new(0.5, 0.5)
card.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
card.BorderSizePixel = 0
card.Parent = gui
Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", card)
stroke.Color = Color3.fromRGB(255, 215, 0)
stroke.Thickness = 2

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.fromOffset(10, 10)
title.BackgroundTransparency = 1
title.Text = "JESUS PACKET LAGGER"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = card

local btn = Instance.new("TextButton")
btn.Size = UDim2.fromOffset(220, 50)
btn.Position = UDim2.fromOffset(20, 55)
btn.BackgroundColor3 = Color3.fromRGB(30, 25, 5)
btn.Text = "START"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 20
btn.Parent = card
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 20)
status.Position = UDim2.fromOffset(10, 120)
status.BackgroundTransparency = 1
status.Text = "Lag Power: 10000"
status.TextColor3 = Color3.fromRGB(255, 245, 210)
status.Font = Enum.Font.Gotham
status.TextSize = 13
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = card

-- ORIGINAL LAG LOGIC - UNCHANGED
local Event
do
    local ok, net = pcall(function()
        local pkgs = ReplicatedStorage:WaitForChild("Packages", 5)
        return pkgs and pkgs:WaitForChild("Net", 5)
    end)
    if ok and net then
        local kids = net:GetChildren()
        Event = kids[6]
    end
end

local lagging = false
local lagThread
local function startLagging()
    if lagging then return end
    if not Event then
        status.Text = "NO EVENT FOUND - patched?"
        return
    end
    lagging = true
    local payload = table.create(10000, function() end)
    lagThread = task.spawn(function()
        while lagging do
            for _ = 1, 3 do
                pcall(function() Event:FireServer(payload) end)
            end
            task.wait(0.01)
        end
    end)
end
local function stopLagging()
    lagging = false
    if lagThread then pcall(task.cancel, lagThread) lagThread = nil end
end

local active = false
btn.MouseButton1Click:Connect(function()
    active = not active
    if active then
        btn.Text = "STOP"
        btn.TextColor3 = Color3.fromRGB(255, 215, 0)
        status.Text = "LAGGING..."
        startLagging()
    else
        btn.Text = "START"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        status.Text = "Lag Power: 10000"
        stopLagging()
    end
end)

-- drag
local dragging, startPos, startInput
card.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, startPos, startInput = true, card.Position, input.Position
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - startInput
        card.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
game:GetService("UserInputService").InputEnded:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        dragging = false
    end
end)

print("JESUS PACKET LAGGER LOADED - Event found:", Event ~= nil)