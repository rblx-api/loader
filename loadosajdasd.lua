-- skyro util (basic)
-- Kick button: kicks you and clears the error so you don't get sent to the menu.
-- Execute box: paste a loadstring (or just the URL) and press Execute.

local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local LP = Players.LocalPlayer

local SAVE_FILE = "haz_util.txt"
local POS_FILE = "haz_util_pos.txt"

local function clearError()
    pcall(GuiService.ClearError, GuiService)
    pcall(function()
        local overlay = CoreGui.RobloxPromptGui.promptOverlay
        overlay.BackgroundTransparency = 1
        for _, c in ipairs(overlay:GetChildren()) do
            if c:IsA("GuiObject") then c.Visible = false end
        end
    end)
end

-- still connected = the client replicator is still there
local function connected()
    local ok, res = pcall(function()
        return game:GetService("NetworkClient"):FindFirstChildOfClass("ClientReplicator") ~= nil
    end)
    return not ok or res
end

local kicking = false
local function kick()
    if kicking then return end
    kicking = true

    -- wipe the error the moment it shows (only hooked once you press kick)
    local conns = {}
    table.insert(conns, GuiService.ErrorMessageChanged:Connect(function() task.defer(clearError) end))
    pcall(function()
        table.insert(conns, CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function() task.defer(clearError) end))
    end)

    task.spawn(function()
        -- try a few ways in case one is blocked (anti-kick hooks on :Kick)
        local tries = {
            function() LP.Kick(LP, "") end,         -- skips __namecall hooks
            function() LP:Kick("") end,
            function() Players.LocalPlayer:Kick("") end,
        }
        for _, try in ipairs(tries) do
            pcall(try)
            local t0 = os.clock()
            while connected() and os.clock() - t0 < 0.5 do task.wait(0.05) end
            if not connected() then break end
        end

        -- keep clearing for a bit, the prompt can show up late
        local t0 = os.clock()
        while os.clock() - t0 < 6 do
            clearError()
            task.wait(0.1)
        end
        for _, c in ipairs(conns) do c:Disconnect() end

        -- still in? let the button be pressed again
        if connected() then kicking = false end
    end)
end

local function execute(src)
    src = (src or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if src == "" then return false, "nothing to run" end
    if src:match("^https?://") and not src:find("%s") then
        local ok, body = pcall(game.HttpGet, game, src)
        if not ok then return false, "HttpGet failed" end
        src = body
    end
    local fn, err = loadstring(src)
    if not fn then return false, tostring(err) end
    task.spawn(fn)
    return true, "executed"
end

-- gui
local parent = (gethui and gethui()) or CoreGui
local old = parent:FindFirstChild("skyro_util")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "hazhub_util"
gui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(240, 150)
main.Position = UDim2.new(0, 20, 0.5, -75)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local title = Instance.new("TextLabel")
title.Text = "hazhub utils"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -30, 0, 26)
title.Position = UDim2.fromOffset(8, 0)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local close = Instance.new("TextButton")
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 13
close.TextColor3 = Color3.fromRGB(200, 200, 200)
close.BackgroundTransparency = 1
close.Size = UDim2.fromOffset(26, 26)
close.Position = UDim2.new(1, -26, 0, 0)
close.Parent = main

local function makeButton(text, y, color)
    local b = Instance.new("TextButton")
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.TextColor3 = Color3.new(1, 1, 1)
    b.BackgroundColor3 = color
    b.BorderSizePixel = 0
    b.Size = UDim2.new(1, -16, 0, 28)
    b.Position = UDim2.fromOffset(8, y)
    b.Parent = main
    return b
end

local kickBtn = makeButton("Kick", 30, Color3.fromRGB(200, 60, 70))
local setBtn = makeButton("Set Loadstring", 62, Color3.fromRGB(45, 45, 55))

local box = Instance.new("TextBox")
box.Text = ""
box.PlaceholderText = "paste loadstring (or URL), click off to save"
box.Font = Enum.Font.Code
box.TextSize = 12
box.TextColor3 = Color3.new(1, 1, 1)
box.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
box.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
box.BorderSizePixel = 0
box.ClearTextOnFocus = false
box.MultiLine = true
box.TextWrapped = true
box.TextXAlignment = Enum.TextXAlignment.Left
box.TextYAlignment = Enum.TextYAlignment.Top
box.Size = UDim2.new(1, -16, 0, 60)
box.Position = UDim2.fromOffset(8, 94)
box.Visible = false
box.Parent = main

local execBtn = makeButton("execute aj", 94, Color3.fromRGB(100, 70, 220))

local status = Instance.new("TextLabel")
status.Text = ""
status.Font = Enum.Font.Gotham
status.TextSize = 11
status.TextColor3 = Color3.fromRGB(160, 160, 170)
status.BackgroundTransparency = 1
status.Size = UDim2.new(1, -16, 0, 16)
status.Position = UDim2.fromOffset(8, 126)
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextTruncate = Enum.TextTruncate.AtEnd
status.Parent = main

local function setStatus(msg, ok)
    status.Text = msg
    if ok == nil then
        status.TextColor3 = Color3.fromRGB(160, 160, 170)
    else
        status.TextColor3 = ok and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(230, 80, 80)
    end
end

-- saved loadstring lives here, never shown in the box
local saved = ""
if isfile and readfile then
    pcall(function()
        if isfile(SAVE_FILE) then saved = readfile(SAVE_FILE) end
    end)
end
setStatus(saved ~= "" and "loadstring set" or "no loadstring set")

-- open / close the hidden box
local function setBoxOpen(open)
    box.Visible = open
    box.Text = ""
    local shift = open and 64 or 0
    execBtn.Position = UDim2.fromOffset(8, 94 + shift)
    status.Position = UDim2.fromOffset(8, 126 + shift)
    main.Size = UDim2.fromOffset(240, 150 + shift)
    setBtn.Text = open and "Close" or "Set Loadstring"
end

local closedAt = 0

setBtn.MouseButton1Click:Connect(function()
    -- clicking this while typing already closed the box via FocusLost
    if os.clock() - closedAt < 0.4 then return end
    setBoxOpen(not box.Visible)
    if box.Visible then box:CaptureFocus() end
end)

box.FocusLost:Connect(function()
    closedAt = os.clock()
    local txt = box.Text
    if txt:match("%S") then
        saved = txt
        if writefile then pcall(writefile, SAVE_FILE, saved) end
        setStatus("loadstring saved", true)
    end
    setBoxOpen(false)
end)

kickBtn.MouseButton1Click:Connect(kick)

execBtn.MouseButton1Click:Connect(function()
    local ok, msg = execute(saved)
    setStatus(msg, ok)
end)

-- save / load gui position
local function savePos()
    if not writefile then return end
    local p = main.Position
    pcall(writefile, POS_FILE, table.concat({ p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset }, ","))
end

if isfile and readfile then
    pcall(function()
        if not isfile(POS_FILE) then return end
        local a, b, c, d = readfile(POS_FILE):match("([^,]+),([^,]+),([^,]+),([^,]+)")
        if a then main.Position = UDim2.new(tonumber(a), tonumber(b), tonumber(c), tonumber(d)) end
    end)
end

main.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        task.defer(savePos)
    end
end)

close.MouseButton1Click:Connect(function()
    savePos()
    gui:Destroy()
end)

gui.Parent = parent