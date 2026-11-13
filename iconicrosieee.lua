-- HAZHUB  (mynxx UI + haz carpet/flash)  — layout fixed
if not game:IsLoaded() then game.Loaded:Wait() end

local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local UIS                = game:GetService("UserInputService")
local TweenService       = game:GetService("TweenService")
local HttpService        = game:GetService("HttpService")
local Workspace          = game:GetService("Workspace")
local PathfindingService = game:GetService("PathfindingService")
local LP                 = Players.LocalPlayer

_G.HazHub = _G.HazHub or {}
local H = _G.HazHub

H.AutoTP       = H.AutoTP or false
H.ManualTP     = H.ManualTP ~= false
H.AutoPriority = H.AutoPriority ~= false
H.Compact      = H.Compact or false
H.TPSpeedItem  = H.TPSpeedItem or "Flying Carpet"
H.FlySpeed     = H.FlySpeed or 310
H.ShortSpeed   = H.ShortSpeed or 270

local SETTINGS_FILE = "HazHub_settings.json"
local function loadSettings()
    local ok, data = pcall(function()
        if isfile and isfile(SETTINGS_FILE) then
            return HttpService:JSONDecode(readfile(SETTINGS_FILE))
        end
    end)
    if ok and type(data) == "table" then
        for k, v in pairs(data) do if H[k] ~= nil then H[k] = v end end
    end
end
local function saveSettings()
    pcall(function()
        if writefile then
            writefile(SETTINGS_FILE, HttpService:JSONEncode({
                AutoTP = H.AutoTP, ManualTP = H.ManualTP, AutoPriority = H.AutoPriority,
                Compact = H.Compact, TPSpeedItem = H.TPSpeedItem,
                FlySpeed = H.FlySpeed, ShortSpeed = H.ShortSpeed,
            }))
        end
    end)
end
loadSettings()

----------------------------------------------------------------
-- mynxx-style UI (purple)
----------------------------------------------------------------
local UI = {}
UI.C = {
    BG      = Color3.fromRGB(14, 12, 20),
    PANEL   = Color3.fromRGB(20, 16, 30),
    ROW     = Color3.fromRGB(32, 26, 46),
    ROW_HI  = Color3.fromRGB(44, 36, 62),
    BTN     = Color3.fromRGB(40, 32, 58),
    BTN_ON  = Color3.fromRGB(124, 92, 255),
    ACCENT  = Color3.fromRGB(124, 92, 255),
    ACCENT2 = Color3.fromRGB(180, 140, 255),
    TRACK   = Color3.fromRGB(42, 34, 60),
    TEXT    = Color3.fromRGB(235, 230, 250),
    MUTED   = Color3.fromRGB(155, 145, 175),
    DANGER  = Color3.fromRGB(230, 70, 90),
    STROKE  = Color3.fromRGB(70, 55, 100),
}
UI.FONT  = Enum.Font.GothamMedium
UI.FONTB = Enum.Font.GothamBold
UI.FONTK = Enum.Font.GothamBlack
UI.PAD   = 10

function UI.corner(inst, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 8); c.Parent = inst; return c
end
function UI.stroke(inst, color, t)
    local s = Instance.new("UIStroke"); s.Color = color or UI.C.STROKE; s.Thickness = t or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = inst; return s
end

function UI.screen(name, displayOrder)
    local parent = (gethui and gethui()) or game:GetService("CoreGui") or LP:WaitForChild("PlayerGui")
    pcall(function()
        local old = parent:FindFirstChild(name); if old then old:Destroy() end
        local pg = LP:FindFirstChild("PlayerGui")
        local old2 = pg and pg:FindFirstChild(name); if old2 then old2:Destroy() end
    end)
    local sg = Instance.new("ScreenGui")
    sg.Name = name; sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = displayOrder or 999999
    sg.IgnoreGuiInset = true
    pcall(function() sg.Parent = parent end)
    if not sg.Parent then sg.Parent = LP:WaitForChild("PlayerGui") end
    return sg
end

function UI.drag(handle, target, onDrop)
    local dragging, dStart, pStart
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dStart = i.Position; pStart = target.Position
        end
    end)
    handle.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            if dragging and onDrop then pcall(onDrop, target) end
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if not dragging then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            local d = i.Position - dStart
            target.Position = UDim2.new(pStart.X.Scale, pStart.X.Offset + d.X, pStart.Y.Scale, pStart.Y.Offset + d.Y)
        end
    end)
end

function UI.panel(opts)
    local f = Instance.new("Frame")
    f.Name = opts.name or "Panel"; f.Active = true; f.BorderSizePixel = 0
    f.Size = UDim2.fromOffset(opts.w or 260, opts.h or 300)
    f.Position = UDim2.fromOffset(opts.x or 200, opts.y or 200)
    f.BackgroundColor3 = UI.C.PANEL
    UI.corner(f, 12); UI.stroke(f)
    f.Parent = opts.parent

    local t = Instance.new("TextButton", f)
    t.Size = UDim2.new(1, 0, 0, 36); t.BackgroundTransparency = 1
    t.Text = opts.title or ""; t.Font = UI.FONTK; t.TextSize = 15
    t.TextColor3 = UI.C.TEXT; t.AutoButtonColor = false; t.Active = true

    local bar = Instance.new("Frame", f)
    bar.Size = UDim2.new(0, 40, 0, 2); bar.Position = UDim2.new(0.5, -20, 0, 34)
    bar.BackgroundColor3 = UI.C.ACCENT; bar.BorderSizePixel = 0
    UI.corner(bar, 2)

    local body = Instance.new("Frame", f)
    body.Name = "Body"; body.BackgroundTransparency = 1; body.BorderSizePixel = 0
    body.Position = UDim2.new(0, 0, 0, 42); body.Size = UDim2.new(1, 0, 1, -48)

    UI.drag(t, f, opts.onDrop)
    return f, body, t
end

function UI.button(opts)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -2 * UI.PAD, 0, opts.h or 32)
    b.Position = UDim2.fromOffset(UI.PAD, opts.y or 0)
    b.BackgroundColor3 = opts.accent and UI.C.ACCENT or UI.C.BTN
    b.Text = opts.text or ""; b.Font = UI.FONTB; b.TextSize = 13
    b.TextColor3 = UI.C.TEXT; b.BorderSizePixel = 0; b.AutoButtonColor = false
    UI.corner(b, 8)
    b.Parent = opts.parent
    local function setOn(on)
        b.BackgroundColor3 = on and UI.C.BTN_ON or UI.C.BTN
    end
    if opts.on ~= nil then setOn(opts.on) end
    b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.08), { BackgroundTransparency = 0.12 }):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.08), { BackgroundTransparency = 0 }):Play() end)
    if opts.onClick then b.MouseButton1Click:Connect(opts.onClick) end
    return b, setOn
end

function UI.smallButton(opts)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(opts.w or 28, opts.h or 22)
    b.Position = opts.pos or UDim2.fromOffset(opts.x or 0, opts.y or 0)
    b.BackgroundColor3 = UI.C.BTN; b.Text = opts.text or ""
    b.Font = UI.FONTB; b.TextSize = opts.textSize or 14
    b.TextColor3 = UI.C.TEXT; b.BorderSizePixel = 0; b.AutoButtonColor = false
    UI.corner(b, 6)
    b.Parent = opts.parent
    if opts.onClick then b.MouseButton1Click:Connect(opts.onClick) end
    return b
end

function UI.label(opts)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1; l.BorderSizePixel = 0
    l.Size = opts.size2 or UDim2.new(1, -2 * UI.PAD, 0, opts.h or 18)
    if opts.w then l.Size = UDim2.fromOffset(opts.w, opts.h or 18) end
    l.Position = opts.pos or UDim2.fromOffset(opts.x or UI.PAD, opts.y or 0)
    l.Text = opts.text or ""; l.Font = opts.bold and UI.FONTB or UI.FONT
    l.TextSize = opts.size or 12
    l.TextColor3 = opts.color or (opts.muted and UI.C.MUTED or UI.C.TEXT)
    l.TextXAlignment = opts.align or Enum.TextXAlignment.Left
    l.TextTruncate = Enum.TextTruncate.AtEnd
    l.Parent = opts.parent
    return l
end

----------------------------------------------------------------
-- haz tp core (same as before)
----------------------------------------------------------------
local function isMyPlot(plot)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if not sign then return false end
    local yb = sign:FindFirstChild("YourBase")
    if yb and yb:IsA("BillboardGui") and yb.Enabled then return true end
    local label = sign:FindFirstChildWhichIsA("TextLabel", true)
    if label then
        local t = tostring(label.Text or ""):lower()
        if t:find(LP.Name:lower(), 1, true) or t:find(LP.DisplayName:lower(), 1, true) then return true end
    end
    return false
end

local function isValidStealPrompt(prompt)
    if not prompt or not prompt.Parent or not prompt.Enabled then return false end
    local state = prompt:GetAttribute("State")
    local action = prompt.ActionText
    return state == "Steal" or state == "Grab" or action == "Steal" or action == "Grab"
end

local function parseGenNumber(text)
    if not text then return 0 end
    text = tostring(text):gsub(",", ""):gsub("%s", ""):upper()
    local num = text:match("([%d%.]+)")
    if not num then return 0 end
    num = tonumber(num) or 0
    if text:find("T") then return num * 1e12 end
    if text:find("B") then return num * 1e9 end
    if text:find("M") then return num * 1e6 end
    if text:find("K") then return num * 1e3 end
    return num
end

local function getPetValueBest(prompt, podium)
    if not prompt then return "?", 0 end
    local val = prompt:GetAttribute("Value") or prompt:GetAttribute("Price")
        or prompt:GetAttribute("Cash") or prompt:GetAttribute("Generation")
    if val then local s = tostring(val); return s, parseGenNumber(s) end
    local searchIn = podium
    if not searchIn and prompt.Parent then searchIn = prompt.Parent.Parent end
    if searchIn then
        for _, d in ipairs(searchIn:GetDescendants()) do
            if d:IsA("TextLabel") or d:IsA("TextButton") then
                local t = tostring(d.Text or "")
                if t:find("%$") or t:find("/s") or t:find("M/s") or t:find("K/s") or t:find("B/s") then
                    return t, parseGenNumber(t)
                end
            end
        end
    end
    return "?", 0
end

local function findTool(name)
    local char = LP.Character
    if char then
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") and t.Name:lower():find(name:lower()) then return t end
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and t.Name:lower():find(name:lower()) then return t end
        end
    end
    return nil
end

local function equipCarpet()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local tool = findTool(H.TPSpeedItem) or findTool("Flying Carpet") or findTool("carpet")
        or findTool("broom") or findTool("waverider") or findTool("sleigh") or findTool("wing")
    if not tool then return false end
    pcall(function()
        if tool.Parent ~= char then
            hum:UnequipTools(); task.wait(0.02); hum:EquipTool(tool)
        end
    end)
    task.wait(0.05)
    return tool.Parent == char
end

local function getTargetPos(entry)
    if not entry then return nil end
    if entry.prompt and entry.prompt.Parent then
        local p = entry.prompt.Parent
        if p:IsA("Attachment") then return p.WorldPosition end
        if p:IsA("BasePart") then return p.Position end
    end
    if entry.podium then
        local base = entry.podium:FindFirstChild("Base") or entry.podium
        local spawn = base and base:FindFirstChild("Spawn")
        if spawn and spawn:IsA("BasePart") then return spawn.Position end
    end
    return nil
end

local function buildPath(fromPos, toPos)
    local waypoints = {}
    local ok, path = pcall(function()
        local p = PathfindingService:CreatePath({
            AgentRadius = 2.2, AgentHeight = 5.5, AgentCanJump = true, AgentCanClimb = true, WaypointSpacing = 7,
        })
        p:ComputeAsync(fromPos, toPos); return p
    end)
    if ok and path and path.Status == Enum.PathStatus.Success then
        for _, wp in ipairs(path:GetWaypoints()) do
            table.insert(waypoints, wp.Position + Vector3.new(0, 1.6, 0))
        end
        if #waypoints >= 2 then return waypoints end
    end
    local dx, dz = toPos.X - fromPos.X, toPos.Z - fromPos.Z
    local horiz = math.sqrt(dx * dx + dz * dz)
    local isHigh = toPos.Y > 10
    local liftY = isHigh and math.max(fromPos.Y, toPos.Y) + 6 or math.max(fromPos.Y, toPos.Y) + 3.5
    if math.abs(toPos.Y - fromPos.Y) > 1.5 or horiz > 8 then
        table.insert(waypoints, Vector3.new(fromPos.X, liftY, fromPos.Z))
        if horiz > 18 then
            table.insert(waypoints, Vector3.new(fromPos.X + dx * 0.35, liftY, fromPos.Z + dz * 0.35))
            table.insert(waypoints, Vector3.new(fromPos.X + dx * 0.7, liftY, fromPos.Z + dz * 0.7))
        else
            table.insert(waypoints, Vector3.new(fromPos.X + dx * 0.5, liftY, fromPos.Z + dz * 0.5))
        end
        table.insert(waypoints, Vector3.new(toPos.X, liftY, toPos.Z))
    elseif horiz > 4 then
        table.insert(waypoints, Vector3.new(fromPos.X + dx * 0.5, math.max(fromPos.Y, toPos.Y) + 2.2, fromPos.Z + dz * 0.5))
    end
    table.insert(waypoints, Vector3.new(toPos.X, toPos.Y + 2.1, toPos.Z))
    return waypoints
end

local function hazFlash(slot)
    local char = LP.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    hum:UnequipTools(); task.wait(0.03)
    if slot and slot >= 19 and slot <= 27 then
        root.AssemblyLinearVelocity = Vector3.new(0, 48, 0); task.wait(0.04)
        root.AssemblyLinearVelocity = Vector3.zero
    end
    local flash = findTool("flash") or findTool("Flash") or findTool("teleport")
    if not flash then return end
    hum:EquipTool(flash); task.wait(0.04)
    pcall(function() flash:Activate() end); task.wait(0.08)
end

local isTPing, moveConn = false, nil
local STOP_DIST, STEAL_RANGE = 3.8, 7.5

local function stopFlight()
    isTPing = false
    if moveConn then pcall(function() moveConn:Disconnect() end); moveConn = nil end
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero end
end

local function carpetFollowPath(waypoints, speed, onDone)
    if isTPing then stopFlight() end
    isTPing = true; speed = speed or H.FlySpeed
    equipCarpet(); task.wait(0.04)
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root or not waypoints or #waypoints == 0 then
        stopFlight(); if onDone then task.spawn(onDone) end; return
    end
    local idx = 1
    moveConn = RunService.Heartbeat:Connect(function()
        if not isTPing then return end
        root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root or not root.Parent then stopFlight() return end
        root.AssemblyAngularVelocity = Vector3.zero
        local goal = waypoints[idx]
        if not goal then
            root.AssemblyLinearVelocity = Vector3.zero; stopFlight()
            if onDone then task.spawn(onDone) end; return
        end
        local dir = goal - root.Position
        local dist = dir.Magnitude
        if dist <= STOP_DIST then
            idx = idx + 1; root.AssemblyLinearVelocity = Vector3.zero
            if idx > #waypoints then stopFlight(); if onDone then task.spawn(onDone) end end
            return
        end
        local s = dist < 11 and math.max(38, speed * dist / 11) or speed
        root.AssemblyLinearVelocity = dir.Unit * s
    end)
end

local function carpetSpeedWalk(toPos, onDone)
    if isTPing then stopFlight() end
    isTPing = true; equipCarpet(); task.wait(0.04)
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root or not toPos then stopFlight(); if onDone then task.spawn(onDone) end; return end
    local goal = Vector3.new(toPos.X, toPos.Y + 1.15, toPos.Z)
    moveConn = RunService.Heartbeat:Connect(function()
        if not isTPing then return end
        root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root or not root.Parent then stopFlight() return end
        root.AssemblyAngularVelocity = Vector3.zero
        local dir = goal - root.Position
        local dist = dir.Magnitude
        if dist <= STOP_DIST then
            root.AssemblyLinearVelocity = Vector3.zero; stopFlight()
            if onDone then task.spawn(onDone) end; return
        end
        local s = dist < 7.5 and math.max(45, H.ShortSpeed * dist / 7.5) or H.ShortSpeed
        root.AssemblyLinearVelocity = dir.Unit * s
    end)
end

local function carpetPathTo(targetPos, onDone)
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root or not targetPos then if onDone then task.spawn(onDone) end; return end
    carpetFollowPath(buildPath(root.Position, targetPos), H.FlySpeed, onDone)
end

local function startTrip(entry)
    if not entry or not entry.prompt or not entry.prompt.Parent then return end
    local pos = getTargetPos(entry)
    if not pos then return end
    local slot = entry.slot
    carpetPathTo(pos, function()
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local livePos = getTargetPos(entry) or pos
        hazFlash(slot); task.wait(0.22)
        root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        livePos = getTargetPos(entry) or pos
        if LP:GetAttribute("Stealing") then return end
        if (root.Position - livePos).Magnitude > STEAL_RANGE then
            carpetSpeedWalk(livePos, function() end)
        end
    end)
end

local function scanBrainrots()
    local result = {}
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return result end
    for _, plot in ipairs(plots:GetChildren()) do
        if not isMyPlot(plot) then
            local podiums = plot:FindFirstChild("AnimalPodiums")
            if podiums then
                for _, podium in ipairs(podiums:GetChildren()) do
                    local slot = tonumber(podium.Name:match("%d+")) or 1
                    local base = podium:FindFirstChild("Base") or podium
                    local spawn = base:FindFirstChild("Spawn")
                    local att = spawn and spawn:FindFirstChild("PromptAttachment")
                    if att then
                        for _, child in ipairs(att:GetChildren()) do
                            if child:IsA("ProximityPrompt") and isValidStealPrompt(child) then
                                local name = tostring(child.ObjectText or "Pet")
                                    :gsub("%s*%[.-%]%s*", ""):gsub("^%s+", ""):gsub("%s+$", "")
                                local valStr, valNum = getPetValueBest(child, podium)
                                table.insert(result, {
                                    prompt = child, slot = slot, name = name,
                                    valueStr = valStr, valueNum = valNum, podium = podium,
                                    key = name .. " | " .. valStr .. " | #" .. slot
                                })
                            end
                        end
                    end
                end
            end
        end
    end
    table.sort(result, function(a, b)
        if a.valueNum == b.valueNum then return a.slot < b.slot end
        return a.valueNum > b.valueNum
    end)
    return result
end

local function getBest()
    return scanBrainrots()[1]
end

----------------------------------------------------------------
-- UI (fixed layout)
----------------------------------------------------------------
local sg = UI.screen("HAZHUB")

local main, body = UI.panel({
    name = "Main",
    title = "HAZHUB",
    w = 260,
    h = 290,          -- tall enough for everything
    parent = sg,
    x = 20,
    y = 160,
})

-- size toggle top-right
local sizeBtn = UI.smallButton({
    parent = main,
    text = H.Compact and "+" or "-",
    pos = UDim2.new(1, -36, 0, 6),
    w = 28, h = 24, textSize = 16,
})

local function applySize()
    if H.Compact then
        main.Size = UDim2.fromOffset(210, 210)
        sizeBtn.Text = "+"
    else
        main.Size = UDim2.fromOffset(260, 290)
        sizeBtn.Text = "-"
    end
end
applySize()

sizeBtn.MouseButton1Click:Connect(function()
    H.Compact = not H.Compact
    applySize()
    saveSettings()
end)

-- buttons (clean spacing)
local function btn(txt, y, fn)
    return UI.button({ text = txt, y = y, h = 34, parent = body, onClick = fn })
end

btn("TP BEST", 6, function()
    local best = getBest()
    if best then startTrip(best) end
end)

btn("TP #1", 48, function()
    local l = scanBrainrots()
    if l[1] then startTrip(l[1]) end
end)

btn("TP #2", 90, function()
    local l = scanBrainrots()
    if l[2] then startTrip(l[2]) end
end)

btn("REFRESH", 132, function()
    local list = scanBrainrots()
    print("[HAZHUB] " .. #list .. " targets")
    for i, e in ipairs(list) do
        if i <= 6 then print("  " .. i .. ". " .. e.key) end
    end
end)

-- toggles (properly inside the body)
local function makeToggle(label, y, key)
    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, -20, 0, 28)
    row.Position = UDim2.fromOffset(10, y)
    row.BackgroundTransparency = 1
    row.Text = ""
    row.Parent = body

    UI.label({
        parent = row,
        x = 2, y = 0, h = 28,
        size = 13,
        text = label
    })

    local box = Instance.new("Frame")
    box.Size = UDim2.fromOffset(22, 22)
    box.Position = UDim2.new(1, -26, 0.5, -11)
    box.BackgroundColor3 = H[key] and UI.C.ACCENT or UI.C.BTN
    box.BorderSizePixel = 0
    box.Parent = row
    UI.corner(box, 6)

    row.MouseButton1Click:Connect(function()
        H[key] = not H[key]
        box.BackgroundColor3 = H[key] and UI.C.ACCENT or UI.C.BTN
        saveSettings()
    end)
end

makeToggle("Auto TP", 182, "AutoTP")
makeToggle("T Key", 218, "ManualTP")

----------------------------------------------------------------
-- input + auto
----------------------------------------------------------------
UIS.InputBegan:Connect(function(inp, gpe)
    if gpe or not H.ManualTP then return end
    if inp.KeyCode == Enum.KeyCode.T then
        local best = getBest()
        if best then startTrip(best) end
    end
end)

local lastKey = ""
task.spawn(function()
    while true do
        task.wait(3)
        if H.AutoTP then
            local best = getBest()
            if best and best.key ~= lastKey then
                lastKey = best.key
                startTrip(best)
            end
        end
    end
end)

task.delay(1.2, function()
    if H.AutoPriority then
        local best = getBest()
        if best then startTrip(best) end
    end
end)