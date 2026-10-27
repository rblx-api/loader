warn("[Braintopia] Script Start")

local HttpService      = game:GetService("HttpService")
local TeleportService  = game:GetService("TeleportService")
local Players          = game:GetService("Players")
local SoundService     = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local CoreGui          = game:GetService("CoreGui")

local localPlayer = Players.LocalPlayer
local placeId = game.PlaceId

local LOG_URL = "https://autojoiner2-2d181-default-rtdb.firebaseio.com/logs.json?orderBy=%22%24key%22&limitToLast=30"
local POLL = 2
local TTL  = 180

local T = {
    Bg      = Color3.fromRGB(14, 18, 38),
    Sidebar = Color3.fromRGB(18, 24, 48),
    Card    = Color3.fromRGB(24, 30, 58),
    Element = Color3.fromRGB(32, 38, 70),
    Accent  = Color3.fromRGB(70, 130, 255),
    Accent2 = Color3.fromRGB(110, 160, 255),
    Text    = Color3.fromRGB(235, 240, 255),
    Dim     = Color3.fromRGB(135, 150, 195),
    Good    = Color3.fromRGB(60, 200, 150),
    Bad     = Color3.fromRGB(235, 90, 110),
    Stroke  = Color3.fromRGB(40, 50, 95),
}

local cfg = {
    AutoJoin       = false,
    Attempts       = 40,
    BruteForceJoin = true,
    SoundId        = "5348162330",
    SoundVolume    = 10,
    HotkeyMinimize = "Z",
    HotkeyAutoTP   = "X",
}

pcall(function()
    if isfile and isfile("Braintopia_Config.json") then
        local raw = HttpService:JSONDecode(readfile("Braintopia_Config.json"))
        if type(raw) == "table" then for k,v in pairs(raw) do cfg[k] = v end end
    end
end)

local function save()
    if writefile then writefile("Braintopia_Config.json", HttpService:JSONEncode(cfg)) end
end
task.spawn(function() while true do task.wait(6) save() end end)

local rawRequest = (syn and syn.request) or request or http_request or function(t)
    return { Body = game:HttpGet(t.Url, true) }
end

local alert = Instance.new("Sound")
alert.Name = "BraintopiaAlert"
alert.SoundId = "rbxassetid://" .. cfg.SoundId
alert.Volume = cfg.SoundVolume
alert.Parent = SoundService
local function beep() pcall(function() alert:Play() end) end

local joining = false
local forceTarget = nil
local seen = {}

local function fmt(n)
    n = tonumber(n) or 0
    if n >= 1e9 then return string.format("$%.1fB/s", n/1e9):gsub("%.0B","B") end
    if n >= 1e6 then return string.format("$%.0fM/s", n/1e6) end
    if n >= 1e3 then return string.format("$%.1fK/s", n/1e3):gsub("%.0K","K") end
    return "$"..tostring(n).."/s"
end

local function doTeleport(jobId)
    if not jobId or jobId == "" then return false end
    local ok, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(placeId, tostring(jobId), localPlayer)
    end)
    return ok
end

local function tryJoin(jobId, force)
    if not jobId or jobId == "" then return end
    jobId = tostring(jobId)

    if force then
        forceTarget = jobId
        if joining then return end
        joining = true
        task.spawn(function()
            local tries = 0
            while forceTarget == jobId and tries < cfg.Attempts do
                tries += 1
                doTeleport(jobId)
                task.wait(2.2)
            end
            joining = false
            if forceTarget == jobId then forceTarget = nil end
        end)
    else
        doTeleport(jobId)
    end
end

local function stopForce()
    forceTarget = nil
end

pcall(function()
    local h = gethui and gethui() or CoreGui
    local old = h:FindFirstChild("Braintopia")
    if old then old:Destroy() end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "Braintopia"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false
gui.Parent = (gethui and gethui()) or CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(800, 540)
main.Position = UDim2.new(0.5, -400, 0.5, -270)
main.BackgroundColor3 = T.Bg
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.ClipsDescendants = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = T.Accent
mainStroke.Thickness = 1.3
mainStroke.Transparency = 0.35

local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 46)
top.BackgroundColor3 = T.Sidebar
top.BorderSizePixel = 0
top.Parent = main
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 14)
local topFix = Instance.new("Frame")
topFix.Size = UDim2.new(1, 0, 0, 18)
topFix.Position = UDim2.new(0, 0, 1, -18)
topFix.BackgroundColor3 = T.Sidebar
topFix.BorderSizePixel = 0
topFix.Parent = top

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 360, 1, 0)
title.Position = UDim2.fromOffset(18, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextColor3 = T.Text
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "Braintopia  |  Connected to Germany"
title.Parent = top

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(28, 28)
closeBtn.Position = UDim2.new(1, -40, 0, 9)
closeBtn.BackgroundColor3 = T.Element
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.TextColor3 = T.Bad
closeBtn.Parent = top
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 7)
closeBtn.MouseButton1Click:Connect(function()
    stopForce()
    gui:Destroy()
end)

local side = Instance.new("Frame")
side.Size = UDim2.new(0, 132, 1, -46)
side.Position = UDim2.fromOffset(0, 46)
side.BackgroundColor3 = T.Sidebar
side.BorderSizePixel = 0
side.Parent = main

local function makeTab(name, y, active)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -14, 0, 38)
    b.Position = UDim2.fromOffset(7, y)
    b.BackgroundColor3 = active and T.Element or Color3.new(0,0,0)
    b.BackgroundTransparency = active and 0 or 1
    b.Text = name
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 13
    b.TextColor3 = active and T.Text or T.Dim
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.Parent = side
    local pad = Instance.new("UIPadding", b)
    pad.PaddingLeft = UDim.new(0, 14)
    if active then
        local ind = Instance.new("Frame")
        ind.Size = UDim2.new(0, 3, 0.55, 0)
        ind.Position = UDim2.new(0, 0, 0.225, 0)
        ind.BackgroundColor3 = T.Accent
        ind.Parent = b
        Instance.new("UICorner", ind).CornerRadius = UDim.new(1, 0)
    end
end

makeTab("Servers", 16, true)
makeTab("Settings", 60, false)
makeTab("Interface", 104, false)

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -148, 1, -60)
content.Position = UDim2.fromOffset(140, 54)
content.BackgroundTransparency = 1
content.Parent = main

local autoHead = Instance.new("TextLabel")
autoHead.Size = UDim2.new(1, 0, 0, 20)
autoHead.BackgroundTransparency = 1
autoHead.Font = Enum.Font.GothamBold
autoHead.TextSize = 15
autoHead.TextColor3 = T.Text
autoHead.TextXAlignment = Enum.TextXAlignment.Left
autoHead.Text = "Auto Join"
autoHead.Parent = content

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, 0, 0, 16)
statusLbl.Position = UDim2.fromOffset(0, 24)
statusLbl.BackgroundTransparency = 1
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextSize = 12
statusLbl.TextColor3 = T.Dim
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.Text = "Waiting..."
statusLbl.Parent = content

local autoCard = Instance.new("Frame")
autoCard.Size = UDim2.new(1, 0, 0, 60)
autoCard.Position = UDim2.fromOffset(0, 50)
autoCard.BackgroundColor3 = T.Card
autoCard.Parent = content
Instance.new("UICorner", autoCard).CornerRadius = UDim.new(0, 11)

local autoTitle = Instance.new("TextLabel")
autoTitle.Size = UDim2.new(1, -90, 0, 18)
autoTitle.Position = UDim2.fromOffset(16, 11)
autoTitle.BackgroundTransparency = 1
autoTitle.Font = Enum.Font.GothamBold
autoTitle.TextSize = 13
autoTitle.TextColor3 = T.Text
autoTitle.TextXAlignment = Enum.TextXAlignment.Left
autoTitle.Text = "Auto-join"
autoTitle.Parent = autoCard

local autoDesc = Instance.new("TextLabel")
autoDesc.Size = UDim2.new(1, -90, 0, 16)
autoDesc.Position = UDim2.fromOffset(16, 32)
autoDesc.BackgroundTransparency = 1
autoDesc.Font = Enum.Font.Gotham
autoDesc.TextSize = 11
autoDesc.TextColor3 = T.Dim
autoDesc.TextXAlignment = Enum.TextXAlignment.Left
autoDesc.Text = "Teleport to servers that match your settings"
autoDesc.Parent = autoCard

local ajToggle = Instance.new("TextButton")
ajToggle.Size = UDim2.fromOffset(50, 26)
ajToggle.Position = UDim2.new(1, -66, 0.5, -13)
ajToggle.BackgroundColor3 = T.Element
ajToggle.Text = ""
ajToggle.Parent = autoCard
Instance.new("UICorner", ajToggle).CornerRadius = UDim.new(1, 0)
local ajKnob = Instance.new("Frame")
ajKnob.Size = UDim2.fromOffset(20, 20)
ajKnob.Position = UDim2.fromOffset(3, 3)
ajKnob.BackgroundColor3 = Color3.new(1,1,1)
ajKnob.Parent = ajToggle
Instance.new("UICorner", ajKnob).CornerRadius = UDim.new(1, 0)

local function setAJ(on)
    cfg.AutoJoin = on
    TweenService:Create(ajToggle, TweenInfo.new(0.15), {BackgroundColor3 = on and T.Accent or T.Element}):Play()
    TweenService:Create(ajKnob, TweenInfo.new(0.15), {Position = on and UDim2.new(1, -23, 0, 3) or UDim2.fromOffset(3, 3)}):Play()
    if not on then
        stopForce()
        statusLbl.Text = "Waiting..."
        statusLbl.TextColor3 = T.Dim
    else
        statusLbl.Text = "Auto-join enabled"
        statusLbl.TextColor3 = T.Good
    end
end
ajToggle.MouseButton1Click:Connect(function() setAJ(not cfg.AutoJoin) end)
setAJ(cfg.AutoJoin)

local itemsHead = Instance.new("TextLabel")
itemsHead.Size = UDim2.new(1, 0, 0, 18)
itemsHead.Position = UDim2.fromOffset(0, 124)
itemsHead.BackgroundTransparency = 1
itemsHead.Font = Enum.Font.GothamBold
itemsHead.TextSize = 13
itemsHead.TextColor3 = T.Text
itemsHead.TextXAlignment = Enum.TextXAlignment.Left
itemsHead.Text = "Items"
itemsHead.Parent = content

local itemsDesc = Instance.new("TextLabel")
itemsDesc.Size = UDim2.new(1, 0, 0, 14)
itemsDesc.Position = UDim2.fromOffset(0, 144)
itemsDesc.BackgroundTransparency = 1
itemsDesc.Font = Enum.Font.Gotham
itemsDesc.TextSize = 11
itemsDesc.TextColor3 = T.Dim
itemsDesc.TextXAlignment = Enum.TextXAlignment.Left
itemsDesc.Text = "Pick the items you want to join for"
itemsDesc.Parent = content

local btnRow = Instance.new("Frame")
btnRow.Size = UDim2.new(1, 0, 0, 34)
btnRow.Position = UDim2.fromOffset(0, 168)
btnRow.BackgroundTransparency = 1
btnRow.Parent = content

local jobBox = Instance.new("TextBox")
jobBox.Size = UDim2.new(0.42, 0, 1, 0)
jobBox.BackgroundColor3 = T.Element
jobBox.Font = Enum.Font.Gotham
jobBox.TextSize = 12
jobBox.TextColor3 = T.Text
jobBox.PlaceholderText = "Job ID"
jobBox.PlaceholderColor3 = T.Dim
jobBox.Text = ""
jobBox.ClearTextOnFocus = false
jobBox.Parent = btnRow
Instance.new("UICorner", jobBox).CornerRadius = UDim.new(0, 8)
local jobPad = Instance.new("UIPadding", jobBox)
jobPad.PaddingLeft = UDim.new(0, 12)

local rejoinBtn = Instance.new("TextButton")
rejoinBtn.Size = UDim2.new(0.26, -6, 1, 0)
rejoinBtn.Position = UDim2.new(0.44, 0, 0, 0)
rejoinBtn.BackgroundColor3 = T.Element
rejoinBtn.Font = Enum.Font.GothamBold
rejoinBtn.TextSize = 12
rejoinBtn.TextColor3 = T.Text
rejoinBtn.Text = "Rejoin"
rejoinBtn.Parent = btnRow
Instance.new("UICorner", rejoinBtn).CornerRadius = UDim.new(0, 8)
rejoinBtn.MouseButton1Click:Connect(function()
    pcall(function() TeleportService:TeleportReconnect() end)
end)

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0.26, -6, 1, 0)
clearBtn.Position = UDim2.new(0.72, 0, 0, 0)
clearBtn.BackgroundColor3 = T.Element
clearBtn.Font = Enum.Font.GothamBold
clearBtn.TextSize = 12
clearBtn.TextColor3 = T.Text
clearBtn.Text = "Clear"
clearBtn.Parent = btnRow
Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0, 8)

local feedHead = Instance.new("TextLabel")
feedHead.Size = UDim2.new(1, 0, 0, 18)
feedHead.Position = UDim2.fromOffset(0, 216)
feedHead.BackgroundTransparency = 1
feedHead.Font = Enum.Font.GothamBold
feedHead.TextSize = 13
feedHead.TextColor3 = T.Text
feedHead.TextXAlignment = Enum.TextXAlignment.Left
feedHead.Text = "Feed"
feedHead.Parent = content

local feed = Instance.new("ScrollingFrame")
feed.Size = UDim2.new(1, 0, 1, -242)
feed.Position = UDim2.fromOffset(0, 240)
feed.BackgroundTransparency = 1
feed.BorderSizePixel = 0
feed.ScrollBarThickness = 3
feed.ScrollBarImageColor3 = T.Accent
feed.CanvasSize = UDim2.new(0,0,0,0)
feed.Parent = content
local list = Instance.new("UIListLayout", feed)
list.Padding = UDim.new(0, 6)
list.SortOrder = Enum.SortOrder.LayoutOrder
list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    feed.CanvasSize = UDim2.new(0,0,0, list.AbsoluteContentSize.Y + 4)
end)

clearBtn.MouseButton1Click:Connect(function()
    for _, c in ipairs(feed:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    seen = {}
    stopForce()
end)

local function addCard(e)
    local age = os.time() - (e.timestamp or os.time())
    if age > TTL then return end
    if not e.job_id or e.job_id == "" then return end

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 52)
    card.BackgroundColor3 = T.Card
    card.LayoutOrder = -(e.value or 0)
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.fromOffset(30, 30)
    icon.Position = UDim2.fromOffset(12, 11)
    icon.BackgroundColor3 = T.Element
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 15
    icon.TextColor3 = T.Accent2
    icon.Text = "🧠"
    icon.Parent = card
    Instance.new("UICorner", icon).CornerRadius = UDim.new(0, 8)

    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1, -200, 0, 17)
    name.Position = UDim2.fromOffset(52, 9)
    name.BackgroundTransparency = 1
    name.Font = Enum.Font.GothamBold
    name.TextSize = 13
    name.TextColor3 = T.Text
    name.TextXAlignment = Enum.TextXAlignment.Left
    name.TextTruncate = Enum.TextTruncate.AtEnd
    name.Text = e.name or "?"
    name.Parent = card

    local meta = Instance.new("TextLabel")
    meta.Size = UDim2.new(1, -200, 0, 14)
    meta.Position = UDim2.fromOffset(52, 28)
    meta.BackgroundTransparency = 1
    meta.Font = Enum.Font.Gotham
    meta.TextSize = 11
    meta.TextColor3 = T.Dim
    meta.TextXAlignment = Enum.TextXAlignment.Left
    meta.Text = fmt(e.value) .. "  ·  " .. age .. "s ago"
    meta.Parent = card

    local joinBtn = Instance.new("TextButton")
    joinBtn.Size = UDim2.fromOffset(52, 28)
    joinBtn.Position = UDim2.new(1, -120, 0.5, -14)
    joinBtn.BackgroundColor3 = T.Good
    joinBtn.Font = Enum.Font.GothamBold
    joinBtn.TextSize = 11
    joinBtn.TextColor3 = Color3.new(1,1,1)
    joinBtn.Text = "Join"
    joinBtn.Parent = card
    Instance.new("UICorner", joinBtn).CornerRadius = UDim.new(0, 7)
    joinBtn.MouseButton1Click:Connect(function()
        statusLbl.Text = "Joining " .. fmt(e.value)
        statusLbl.TextColor3 = T.Good
        tryJoin(e.job_id, false)
    end)

    local forceBtn = Instance.new("TextButton")
    forceBtn.Size = UDim2.fromOffset(52, 28)
    forceBtn.Position = UDim2.new(1, -60, 0.5, -14)
    forceBtn.BackgroundColor3 = T.Accent
    forceBtn.Font = Enum.Font.GothamBold
    forceBtn.TextSize = 11
    forceBtn.TextColor3 = Color3.new(1,1,1)
    forceBtn.Text = "Force"
    forceBtn.Parent = card
    Instance.new("UICorner", forceBtn).CornerRadius = UDim.new(0, 7)
    forceBtn.MouseButton1Click:Connect(function()
        statusLbl.Text = "Force joining " .. fmt(e.value)
        statusLbl.TextColor3 = T.Accent2
        tryJoin(e.job_id, true)
    end)

    card.Parent = feed
end

local mini = Instance.new("TextButton")
mini.Size = UDim2.fromOffset(160, 44)
mini.Position = UDim2.new(0, 16, 0.5, -22)
mini.BackgroundColor3 = T.Bg
mini.Text = ""
mini.Visible = false
mini.Parent = gui
Instance.new("UICorner", mini).CornerRadius = UDim.new(0, 10)
local mStroke = Instance.new("UIStroke", mini)
mStroke.Color = T.Accent
mStroke.Thickness = 1.3
local mText = Instance.new("TextLabel")
mText.Size = UDim2.new(1, -12, 1, 0)
mText.Position = UDim2.fromOffset(12, 0)
mText.BackgroundTransparency = 1
mText.Font = Enum.Font.GothamBold
mText.TextSize = 13
mText.TextColor3 = T.Text
mText.TextXAlignment = Enum.TextXAlignment.Left
mText.Text = "Braintopia"
mText.Parent = mini

local minimised = false
local function toggleMini()
    minimised = not minimised
    main.Visible = not minimised
    mini.Visible = minimised
end
mini.MouseButton1Click:Connect(toggleMini)

UserInputService.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.KeyCode.Name == cfg.HotkeyMinimize then toggleMini()
    elseif inp.KeyCode.Name == cfg.HotkeyAutoTP then setAJ(not cfg.AutoJoin) end
end)

task.spawn(function()
    while gui.Parent do
        pcall(function()
            local resp = rawRequest({
                Url = LOG_URL .. "&t=" .. tostring(tick()),
                Method = "GET",
                Headers = { ["Cache-Control"] = "no-cache" }
            })
            if not resp or not resp.Body then return end
            local data = HttpService:JSONDecode(resp.Body)
            if type(data) ~= "table" then return end

            local batch = {}
            for k, v in pairs(data) do
                if type(v) == "table" and v.jobId and tostring(v.jobId) ~= "" then
                    local val = tonumber(v.numValue) or 0
                    table.insert(batch, {
                        id = k,
                        job_id = tostring(v.jobId),
                        name = (v.name and v.name ~= "") and v.name or "Unknown",
                        value = val,
                        timestamp = os.time(),
                    })
                end
            end
            table.sort(batch, function(a,b) return (a.value or 0) > (b.value or 0) end)

            for _, e in ipairs(batch) do
                if not seen[e.id] then
                    seen[e.id] = true
                    addCard(e)
                    beep()
                    if cfg.AutoJoin then
                        statusLbl.Text = "Auto joining " .. fmt(e.value)
                        statusLbl.TextColor3 = T.Good
                        tryJoin(e.job_id, true)
                    end
                end
            end
        end)
        task.wait(POLL)
    end
end)

warn("[Braintopia] online · .gg/braintopia")