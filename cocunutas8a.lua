-- [Roblox · Client]
-- if u are reading this, uve sucessfully deobfed hazhub!

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local CMDS = { "tiny", "inverse", "rocket", "balloon", "ragdoll", "morph", "jumpscare", "jail", "nightvision", "nil" }
local adminTextBox = nil
local busy = false
local rangeVal = 40

local function findAdminTextBox()
    if adminTextBox and adminTextBox.Parent then return adminTextBox end
    local ok, res = pcall(function()
        return PlayerGui:WaitForChild("AdminPanel", 20):WaitForChild("AdminPanel", 10):WaitForChild("CommandBox", 10):WaitForChild("TextBox", 10)
    end)
    if ok and res then adminTextBox = res; return adminTextBox end
    local found = nil
    pcall(function()
        for _, d in ipairs(PlayerGui:GetDescendants()) do
            if d:IsA("TextBox") then
                local p = d:GetFullName():lower()
                if p:find("adminpanel") and p:find("commandbox") then found = d; break end
            end
        end
    end)
    adminTextBox = found
    return adminTextBox
end

local function fireCmdOneFrame(cmd, name)
    local tb = adminTextBox
    if not tb or not tb.Parent then tb = findAdminTextBox(); if not tb then return false end end
    tb.Text = ";" .. cmd .. " " .. name
    local fired = false
    if firesignal then
        fired = pcall(firesignal, tb.FocusLost, true)
    elseif getconnections then
        for _, c in pairs(getconnections(tb.FocusLost)) do
            pcall(function() c:Fire(true) end)
            fired = true
        end
    end
    if not fired then
        pcall(function()
            tb:CaptureFocus()
            tb:ReleaseFocus(true)
        end)
    end
    RunService.Heartbeat:Wait()
    if tb and tb.Parent then tb.Text = "" end
    return true
end

local function sendAll(name)
    local tb = findAdminTextBox()
    if not tb then return end
    local vis = tb.Visible
    tb.Visible = false
    for _, cmd in ipairs(CMDS) do
        fireCmdOneFrame(cmd, name)
    end
    if tb and tb.Parent then tb.Visible = vis end
end

local old = PlayerGui:FindFirstChild("HazApSpamGui")
if old then old:Destroy() end

local GUI = Instance.new("ScreenGui")
GUI.Name = "HazApSpamGui"
GUI.ResetOnSpawn = false
GUI.DisplayOrder = 999999
pcall(function() if gethui then GUI.Parent = gethui() end end)
if not GUI.Parent then pcall(function() GUI.Parent = game:GetService("CoreGui") end) end
if not GUI.Parent then GUI.Parent = PlayerGui end

local C = {
    bg       = Color3.fromRGB(20, 13, 34),
    card     = Color3.fromRGB(36, 24, 56),
    cardHov  = Color3.fromRGB(46, 32, 70),
    stroke   = Color3.fromRGB(105, 65, 175),
    accent   = Color3.fromRGB(175, 95, 255),
    text     = Color3.fromRGB(238, 228, 255),
    mute     = Color3.fromRGB(155, 135, 185),
    pill     = Color3.fromRGB(50, 32, 88),
    proxy    = Color3.fromRGB(185, 65, 155),
}

local Win = Instance.new("Frame")
Win.Size = UDim2.fromOffset(380, 520)
-- locked to the right side like your screenshot
Win.Position = UDim2.new(1, -400, 0.5, -260)
Win.BackgroundColor3 = C.bg
Win.BorderSizePixel = 0
Win.ClipsDescendants = true
Win.Active = true
Win.Parent = GUI
Instance.new("UICorner", Win).CornerRadius = UDim.new(0, 14)
local ws = Instance.new("UIStroke", Win)
ws.Color = C.stroke
ws.Thickness = 1.2
ws.Transparency = 0.45

local Header = Instance.new("Frame", Win)
Header.Size = UDim2.new(1, 0, 0, 36)
Header.BackgroundColor3 = C.bg
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.fromOffset(14, 0)
Title.BackgroundTransparency = 1
Title.Text = "{PAID} HAZ AP SPAM"
Title.TextColor3 = C.accent
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.fromOffset(24, 24)
CloseBtn.Position = UDim2.new(1, -32, 0.5, -12)
CloseBtn.BackgroundColor3 = C.card
CloseBtn.Text = "×"
CloseBtn.TextColor3 = C.mute
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 15
CloseBtn.BorderSizePixel = 0
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size = UDim2.fromOffset(24, 24)
MinBtn.Position = UDim2.new(1, -60, 0.5, -12)
MinBtn.BackgroundColor3 = C.card
MinBtn.Text = "–"
MinBtn.TextColor3 = C.mute
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 15
MinBtn.BorderSizePixel = 0
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local TopBar = Instance.new("Frame", Win)
TopBar.Size = UDim2.new(1, -20, 0, 32)
TopBar.Position = UDim2.fromOffset(10, 42)
TopBar.BackgroundTransparency = 1

local function makeTopPill(txt, order, isProxy)
    local b = Instance.new("TextButton", TopBar)
    b.Size = UDim2.new(0.32, -4, 1, 0)
    b.Position = UDim2.new((order - 1) * 0.333, 2, 0, 0)
    b.BackgroundColor3 = isProxy and C.proxy or C.pill
    b.Text = txt
    b.TextColor3 = C.text
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 12
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", b)
    s.Color = C.stroke
    s.Thickness = 1
    s.Transparency = 0.55
    return b
end

local ProxyBtn = makeTopPill("Proxy", 1, true)
local CCBtn = makeTopPill("CC", 2, false)
local RagSelfBtn = makeTopPill("Ragdoll Self", 3, false)

local RangeFrame = Instance.new("Frame", Win)
RangeFrame.Size = UDim2.new(1, -20, 0, 28)
RangeFrame.Position = UDim2.fromOffset(10, 80)
RangeFrame.BackgroundTransparency = 1

local RangeLabel = Instance.new("TextLabel", RangeFrame)
RangeLabel.Size = UDim2.fromOffset(50, 28)
RangeLabel.BackgroundTransparency = 1
RangeLabel.Text = "Range"
RangeLabel.TextColor3 = C.mute
RangeLabel.Font = Enum.Font.Gotham
RangeLabel.TextSize = 12
RangeLabel.TextXAlignment = Enum.TextXAlignment.Left

local RangeValLabel = Instance.new("TextLabel", RangeFrame)
RangeValLabel.Size = UDim2.fromOffset(30, 28)
RangeValLabel.Position = UDim2.new(1, -30, 0, 0)
RangeValLabel.BackgroundTransparency = 1
RangeValLabel.Text = tostring(rangeVal)
RangeValLabel.TextColor3 = C.accent
RangeValLabel.Font = Enum.Font.GothamBold
RangeValLabel.TextSize = 13

local RangeBarBg = Instance.new("Frame", RangeFrame)
RangeBarBg.Size = UDim2.new(1, -90, 0, 6)
RangeBarBg.Position = UDim2.fromOffset(52, 11)
RangeBarBg.BackgroundColor3 = Color3.fromRGB(42, 28, 68)
RangeBarBg.BorderSizePixel = 0
Instance.new("UICorner", RangeBarBg).CornerRadius = UDim.new(1, 0)

local RangeFill = Instance.new("Frame", RangeBarBg)
RangeFill.Size = UDim2.new(rangeVal / 100, 0, 1, 0)
RangeFill.BackgroundColor3 = C.accent
RangeFill.BorderSizePixel = 0
Instance.new("UICorner", RangeFill).CornerRadius = UDim.new(1, 0)

local List = Instance.new("ScrollingFrame", Win)
List.Size = UDim2.new(1, -20, 1, -140)
List.Position = UDim2.fromOffset(10, 114)
List.BackgroundTransparency = 1
List.BorderSizePixel = 0
List.ScrollBarThickness = 3
List.ScrollBarImageColor3 = C.stroke
List.CanvasSize = UDim2.new(0, 0, 0, 0)
List.AutomaticCanvasSize = Enum.AutomaticSize.Y
List.ScrollingDirection = Enum.ScrollingDirection.Y

local LL = Instance.new("UIListLayout", List)
LL.Padding = UDim.new(0, 5)
LL.SortOrder = Enum.SortOrder.LayoutOrder

local function doSpam(plr)
    if busy then return end
    busy = true
    task.spawn(function()
        sendAll(plr.Name)
        busy = false
    end)
end

local function makeActionPill(parent, txt, offset)
    local p = Instance.new("TextButton", parent)
    p.Size = UDim2.fromOffset(30, 22)
    p.Position = UDim2.new(1, offset, 0.5, -11)
    p.BackgroundColor3 = C.pill
    p.Text = txt
    p.TextColor3 = C.text
    p.Font = Enum.Font.GothamBold
    p.TextSize = 10
    p.BorderSizePixel = 0
    Instance.new("UICorner", p).CornerRadius = UDim.new(0, 6)
    local s = Instance.new("UIStroke", p)
    s.Color = C.stroke
    s.Thickness = 1
    s.Transparency = 0.6
    return p
end

local function makeRow(plr)
    local row = Instance.new("Frame")
    row.Name = "P_" .. plr.UserId
    row.Size = UDim2.new(1, -4, 0, 48)
    row.BackgroundColor3 = C.card
    row.BorderSizePixel = 0
    row.LayoutOrder = plr.UserId
    row.Parent = List
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)

    local av = Instance.new("ImageLabel", row)
    av.Size = UDim2.fromOffset(34, 34)
    av.Position = UDim2.fromOffset(7, 7)
    av.BackgroundColor3 = Color3.fromRGB(48, 32, 78)
    av.BorderSizePixel = 0
    Instance.new("UICorner", av).CornerRadius = UDim.new(1, 0)
    task.spawn(function()
        pcall(function()
            av.Image = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)
    end)

    local name = Instance.new("TextLabel", row)
    name.Size = UDim2.new(1, -160, 0, 20)
    name.Position = UDim2.fromOffset(48, 5)
    name.BackgroundTransparency = 1
    name.Text = plr.DisplayName
    name.TextColor3 = C.text
    name.Font = Enum.Font.GothamMedium
    name.TextSize = 13
    name.TextXAlignment = Enum.TextXAlignment.Left
    name.TextTruncate = Enum.TextTruncate.AtEnd

    local user = Instance.new("TextLabel", row)
    user.Size = UDim2.new(1, -160, 0, 16)
    user.Position = UDim2.fromOffset(48, 25)
    user.BackgroundTransparency = 1
    user.Text = "@" .. plr.Name
    user.TextColor3 = C.mute
    user.Font = Enum.Font.Gotham
    user.TextSize = 11
    user.TextXAlignment = Enum.TextXAlignment.Left
    user.TextTruncate = Enum.TextTruncate.AtEnd

    local ja = makeActionPill(row, "JA", -132)
    local ra = makeActionPill(row, "RA", -98)
    local ro = makeActionPill(row, "RO", -64)
    local ba = makeActionPill(row, "BA", -30)

    ja.MouseButton1Click:Connect(function() fireCmdOneFrame("jail", plr.Name) end)
    ra.MouseButton1Click:Connect(function() fireCmdOneFrame("ragdoll", plr.Name) end)
    ro.MouseButton1Click:Connect(function() fireCmdOneFrame("rocket", plr.Name) end)
    ba.MouseButton1Click:Connect(function() fireCmdOneFrame("balloon", plr.Name) end)

    local hit = Instance.new("TextButton", row)
    hit.Size = UDim2.new(1, -145, 1, 0)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.ZIndex = 2
    hit.MouseButton1Click:Connect(function() doSpam(plr) end)

    row.MouseEnter:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.1), {BackgroundColor3 = C.cardHov}):Play()
    end)
    row.MouseLeave:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.1), {BackgroundColor3 = C.card}):Play()
    end)
end

local function rebuild()
    for _, c in ipairs(List:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then makeRow(plr) end
    end
end

Players.PlayerAdded:Connect(function(p)
    task.wait(0.25)
    if p ~= LocalPlayer then rebuild() end
end)
Players.PlayerRemoving:Connect(function()
    task.wait(0.15)
    rebuild()
end)

-- still draggable if you want to move it
do
    local dragging, dragStart, startPos = false, nil, nil
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Win.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local d = input.Position - dragStart
        Win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    MinBtn.Text = minimized and "+" or "–"
    TweenService:Create(Win, TweenInfo.new(0.15), {
        Size = UDim2.fromOffset(380, minimized and 36 or 520)
    }):Play()
    List.Visible = not minimized
    TopBar.Visible = not minimized
    RangeFrame.Visible = not minimized
end)

CloseBtn.MouseButton1Click:Connect(function()
    GUI:Destroy()
    adminTextBox = nil
end)

ProxyBtn.MouseButton1Click:Connect(function() end)
CCBtn.MouseButton1Click:Connect(function() end)
RagSelfBtn.MouseButton1Click:Connect(function()
    fireCmdOneFrame("ragdoll", LocalPlayer.Name)
end)

local Status = Instance.new("TextLabel", Win)
Status.Size = UDim2.new(1, -20, 0, 20)
Status.Position = UDim2.new(0, 10, 1, -24)
Status.BackgroundTransparency = 1
Status.Text = "You: Good"
Status.TextColor3 = C.mute
Status.Font = Enum.Font.Gotham
Status.TextSize = 12
Status.TextXAlignment = Enum.TextXAlignment.Left

findAdminTextBox()
rebuild()