local CollectionService = game:GetService("CollectionService")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local Players           = game:GetService("Players")
local RS                = game:GetService("ReplicatedStorage")
local LP                = Players.LocalPlayer

local DELAY = 5

local G = (getgenv and getgenv()) or _G
G.RNGAutoSpin = false
G.__RNGRun    = (G.__RNGRun or 0) + 1
local myToken = G.__RNGRun

local Animals, Rarities, machine
pcall(function() Animals  = require(RS.Datas.Animals) end)
pcall(function() Rarities = require(RS.Datas.Rarities) end)
pcall(function() machine  = require(RS.Packages.ReplicatorClient).get("RNGMachine_" .. LP.UserId) end)

local FALLBACK = {
    Common = Color3.fromRGB(190, 195, 205), Uncommon = Color3.fromRGB(120, 210, 130),
    Rare = Color3.fromRGB(90, 150, 255), Epic = Color3.fromRGB(180, 100, 255),
    Legendary = Color3.fromRGB(255, 180, 55), Mythic = Color3.fromRGB(255, 85, 85),
    Secret = Color3.fromRGB(180, 90, 220), ["Brainrot God"] = Color3.fromRGB(255, 95, 200),
    OG = Color3.fromRGB(255, 215, 60),
}
local function rarityColor(r)
    local info = Rarities and Rarities[r]
    if info then
        local c = info.Color or info.Colour
        if typeof(c) == "Color3" then return c end
        if type(c) == "table" then
            if c[1] then return Color3.fromRGB(c[1], c[2], c[3]) end
            if c.R then return Color3.new(c.R, c.G, c.B) end
        end
    end
    return FALLBACK[r] or Color3.fromRGB(232, 232, 238)
end
local function short(n)
    n = tonumber(n) or 0
    local a = math.abs(n)
    if a >= 1e12 then return ("%.2fT"):format(n / 1e12) end
    if a >= 1e9  then return ("%.2fB"):format(n / 1e9) end
    if a >= 1e6  then return ("%.2fM"):format(n / 1e6) end
    if a >= 1e3  then return ("%.1fK"):format(n / 1e3) end
    return tostring(math.floor(n))
end

local function getSpinPrompt()
    for _, p in ipairs(CollectionService:GetTagged("RNGMachineSpinPrompt")) do
        if p:IsA("ProximityPrompt") and p:IsDescendantOf(workspace) then return p end
    end
    local ok, p = pcall(function() return workspace.RNGMachine.Prompt.RNGMachinePrompt end)
    if ok and typeof(p) == "Instance" and p:IsA("ProximityPrompt") then return p end
    return nil
end

local function doSpin(prompt)
    if fireproximityprompt then
        fireproximityprompt(prompt)
    else
        pcall(function()
            prompt.MaxActivationDistance = math.huge
            prompt.RequiresLineOfSight = false
        end)
        prompt:InputHoldBegin()
        task.wait((prompt.HoldDuration or 0) + 0.06)
        prompt:InputHoldEnd()
    end
end

local setStatus, showWin
local spins = 0

local function startLoop()
    task.spawn(function()
        while G.RNGAutoSpin and myToken == G.__RNGRun do
            local prompt = getSpinPrompt()
            if prompt and prompt.Enabled then
                setStatus("Spinning", Color3.fromRGB(250, 200, 90))
                pcall(doSpin, prompt)
                spins += 1
                local t0 = os.clock()
                while G.RNGAutoSpin and prompt.Parent and prompt.Enabled and os.clock() - t0 < 2 do
                    task.wait(0.05)
                end
                while G.RNGAutoSpin and prompt.Parent and not prompt.Enabled do
                    task.wait(0.1)
                end
                if G.RNGAutoSpin then
                    setStatus(("Active  \u{2022}  %d spins"):format(spins), Color3.fromRGB(52, 199, 123))
                    task.wait(DELAY)
                end
            else
                setStatus("Waiting for machine", Color3.fromRGB(150, 150, 165))
                task.wait(0.25)
            end
        end
    end)
end

if G.__RNGGui then pcall(function() G.__RNGGui:Destroy() end) end

local ON_COLOR  = Color3.fromRGB(52, 199, 123)
local OFF_COLOR = Color3.fromRGB(58, 58, 72)
local ACCENT_A  = Color3.fromRGB(138, 99, 255)
local ACCENT_B  = Color3.fromRGB(86, 138, 255)
local MUTED     = Color3.fromRGB(140, 140, 158)

local function corner(o, r) local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r); c.Parent = o end
local function tween(o, t, p) TweenService:Create(o, TweenInfo.new(t, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), p):Play() end

local gui = Instance.new("ScreenGui")
gui.Name = "RNGSpinToggle"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
pcall(function() if protectgui then protectgui(gui) end end)
local parent
pcall(function() parent = gethui and gethui() end)
if not parent then pcall(function() parent = game:GetService("CoreGui") end) end
if not parent then parent = LP:WaitForChild("PlayerGui") end
gui.Parent = parent
G.__RNGGui = gui

local card = Instance.new("Frame")
card.Size = UDim2.fromOffset(256, 190)
card.Position = UDim2.fromOffset(30, 230)
card.BackgroundColor3 = Color3.fromRGB(17, 17, 23)
card.BorderSizePixel = 0
card.Active = true
card.Parent = gui
corner(card, 16)
local cstroke = Instance.new("UIStroke", card)
cstroke.Color = Color3.fromRGB(42, 42, 56); cstroke.Thickness = 1.5; cstroke.Transparency = 0.1

local accent = Instance.new("Frame")
accent.Size = UDim2.new(1, -32, 0, 3); accent.Position = UDim2.fromOffset(16, 14)
accent.BorderSizePixel = 0; accent.Parent = card; corner(accent, 2)
Instance.new("UIGradient", accent).Color = ColorSequence.new(ACCENT_A, ACCENT_B)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -32, 0, 20); title.Position = UDim2.fromOffset(16, 26)
title.BackgroundTransparency = 1; title.Text = "RNG Auto-Spin"
title.TextXAlignment = Enum.TextXAlignment.Left; title.TextColor3 = Color3.fromRGB(240, 240, 248)
title.Font = Enum.Font.GothamBold; title.TextSize = 16; title.Parent = card

local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(1, -32, 0, 14); sub.Position = UDim2.fromOffset(16, 45)
sub.BackgroundTransparency = 1; sub.Text = "Steal a Brainrot"
sub.TextXAlignment = Enum.TextXAlignment.Left; sub.TextColor3 = MUTED
sub.Font = Enum.Font.Gotham; sub.TextSize = 11; sub.Parent = card

local div1 = Instance.new("Frame")
div1.Size = UDim2.new(1, -32, 0, 1); div1.Position = UDim2.fromOffset(16, 68)
div1.BackgroundColor3 = Color3.fromRGB(38, 38, 50); div1.BorderSizePixel = 0; div1.Parent = card

local rowLabel = Instance.new("TextLabel")
rowLabel.Size = UDim2.fromOffset(120, 24); rowLabel.Position = UDim2.fromOffset(16, 80)
rowLabel.BackgroundTransparency = 1; rowLabel.Text = "Auto Spin"
rowLabel.TextXAlignment = Enum.TextXAlignment.Left; rowLabel.TextColor3 = Color3.fromRGB(218, 218, 228)
rowLabel.Font = Enum.Font.GothamMedium; rowLabel.TextSize = 14; rowLabel.Parent = card

local track = Instance.new("Frame")
track.Size = UDim2.fromOffset(50, 26); track.Position = UDim2.new(1, -66, 0, 79)
track.BackgroundColor3 = OFF_COLOR; track.BorderSizePixel = 0; track.Parent = card; corner(track, 13)
local knob = Instance.new("Frame")
knob.Size = UDim2.fromOffset(20, 20); knob.Position = UDim2.fromOffset(3, 3)
knob.BackgroundColor3 = Color3.fromRGB(245, 245, 250); knob.BorderSizePixel = 0; knob.Parent = track; corner(knob, 10)
local hit = Instance.new("TextButton")
hit.Size = UDim2.fromScale(1, 1); hit.BackgroundTransparency = 1; hit.Text = ""; hit.Parent = track

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -32, 0, 16); status.Position = UDim2.fromOffset(16, 108)
status.BackgroundTransparency = 1; status.Text = "Idle"
status.TextXAlignment = Enum.TextXAlignment.Left; status.TextColor3 = MUTED
status.Font = Enum.Font.Gotham; status.TextSize = 12; status.Parent = card

local div2 = Instance.new("Frame")
div2.Size = UDim2.new(1, -32, 0, 1); div2.Position = UDim2.fromOffset(16, 130)
div2.BackgroundColor3 = Color3.fromRGB(38, 38, 50); div2.BorderSizePixel = 0; div2.Parent = card

local winHeader = Instance.new("TextLabel")
winHeader.Size = UDim2.new(1, -32, 0, 12); winHeader.Position = UDim2.fromOffset(16, 138)
winHeader.BackgroundTransparency = 1; winHeader.Text = "LAST WIN"
winHeader.TextXAlignment = Enum.TextXAlignment.Left; winHeader.TextColor3 = Color3.fromRGB(105, 105, 122)
winHeader.Font = Enum.Font.GothamBold; winHeader.TextSize = 10; winHeader.Parent = card

local winName = Instance.new("TextLabel")
winName.Size = UDim2.new(1, -32, 0, 18); winName.Position = UDim2.fromOffset(16, 150)
winName.BackgroundTransparency = 1; winName.Text = "\u{2014}"
winName.TextXAlignment = Enum.TextXAlignment.Left; winName.TextColor3 = Color3.fromRGB(232, 232, 238)
winName.Font = Enum.Font.GothamBold; winName.TextSize = 15; winName.TextTruncate = Enum.TextTruncate.AtEnd
winName.Parent = card

local winInfo = Instance.new("TextLabel")
winInfo.Size = UDim2.new(1, -32, 0, 14); winInfo.Position = UDim2.fromOffset(16, 169)
winInfo.BackgroundTransparency = 1; winInfo.Text = "no spins yet"
winInfo.TextXAlignment = Enum.TextXAlignment.Left; winInfo.TextColor3 = MUTED
winInfo.Font = Enum.Font.Gotham; winInfo.TextSize = 11; winInfo.Parent = card

function setStatus(text, color)
    status.Text = text
    tween(status, 0.15, {TextColor3 = color or MUTED})
end

function showWin(offer)
    if not offer or not offer.Name then return end
    local a = Animals and Animals[offer.Name]
    local rarity = (a and a.Rarity) or "?"
    local mult = offer.Multiplier or 1
    winName.Text = offer.Name
    winName.TextColor3 = rarityColor(rarity)
    local info = ("%s  \u{2022}  $%s"):format(rarity, short(offer.BuyPrice))
    if mult > 1 then info = info .. ("  \u{2022}  x%s luck"):format(mult) end
    winInfo.Text = info
end

if machine then
    task.spawn(function()
        local last
        while gui.Parent and myToken == G.__RNGRun do
            local d = machine.Data
            if d and d.Offer and d.Offer.Name and d.Offer.ExpiresAt ~= last then
                last = d.Offer.ExpiresAt
                showWin(d.Offer)
            end
            task.wait(0.25)
        end
    end)
end

local function setState(on)
    G.RNGAutoSpin = on and true or false
    if G.RNGAutoSpin then
        tween(track, 0.2, {BackgroundColor3 = ON_COLOR})
        tween(knob, 0.2, {Position = UDim2.fromOffset(27, 3)})
        setStatus("Active", ON_COLOR)
        startLoop()
    else
        tween(track, 0.2, {BackgroundColor3 = OFF_COLOR})
        tween(knob, 0.2, {Position = UDim2.fromOffset(3, 3)})
        setStatus(("Stopped  \u{2022}  %d spins"):format(spins), MUTED)
    end
end
hit.MouseButton1Click:Connect(function() setState(not G.RNGAutoSpin) end)

local dragging, dragStart, startPos
local function beginDrag(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = i.Position; startPos = card.Position
    end
end
title.InputBegan:Connect(beginDrag)
sub.InputBegan:Connect(beginDrag)
card.InputBegan:Connect(function(i)
    if i.Position.Y - card.AbsolutePosition.Y < 68 then beginDrag(i) end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - dragStart
        card.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)