local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer
local plrGui = plr:WaitForChild("PlayerGui")

local CONFIG_FILE = "BloomvsPingLagger_Config.json"
local DEFAULT_CFG = {
    power = 100000,
    interval = 0.125,
    keybindKb = "F",
    keybindGp = "ButtonR2",
    autoBrainrot = true,
}

local cfg = {
    power = DEFAULT_CFG.power,
    interval = DEFAULT_CFG.interval,
    keybindKb = DEFAULT_CFG.keybindKb,
    keybindGp = DEFAULT_CFG.keybindGp,
    autoBrainrot = DEFAULT_CFG.autoBrainrot,
}

local keybind = Enum.KeyCode.F
local listeningForInput = false

local activeColor = Color3.fromRGB(0, 80, 255)
local inactiveColor = Color3.fromRGB(255, 255, 255)

local function saveConfig()
    local data = {
        power = cfg.power,
        interval = cfg.interval,
        keybindKb = cfg.keybindKb,
        keybindGp = cfg.keybindGp,
        autoBrainrot = cfg.autoBrainrot,
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
bgImage.Image = "rbxassetid://131612898077173"
bgImage.ScaleType = Enum.ScaleType.Stretch
bgImage.ImageColor3 = Color3.fromRGB(255,255,255)
bgImage.Parent = mainFrame

local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 220, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 255)),
})
bgGradient.Rotation = 45
bgGradient.Enabled = false
bgGradient.Parent = bgImage

local bgCorner = Instance.new("UICorner", bgImage)
bgCorner.CornerRadius = UDim.new(0, 10)

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(0, 150, 255)
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0

makeDraggable(mainFrame)

local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size = UDim2.new(0, 180, 0, 20)
titleLabel.Position = UDim2.new(0, 8, 0, 4)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Bloom.vs Ping lagger"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 13
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextYAlignment = Enum.TextYAlignment.Center
titleLabel.ZIndex = 2

local gearContainer = Instance.new("Frame", mainFrame)
gearContainer.Size = UDim2.new(0, 50, 0, 22)
gearContainer.Position = UDim2.new(1, -56, 0, 5)
gearContainer.BackgroundColor3 = Color3.fromRGB(20,20,20)
gearContainer.BackgroundTransparency = 0
gearContainer.BorderSizePixel = 0
gearContainer.ZIndex = 50
local containerCorner = Instance.new("UICorner", gearContainer)
containerCorner.CornerRadius = UDim.new(0, 4)

local settingsBtn = Instance.new("TextButton", gearContainer)
settingsBtn.Size = UDim2.new(1, 0, 1, 0)
settingsBtn.Position = UDim2.new(0, 0, 0, 0)
settingsBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
settingsBtn.BackgroundTransparency = 0
settingsBtn.BorderSizePixel = 0
settingsBtn.AutoButtonColor = false
settingsBtn.Text = "Open"
settingsBtn.TextColor3 = Color3.fromRGB(180,180,180)
settingsBtn.Font = Enum.Font.GothamBold
settingsBtn.TextSize = 10
settingsBtn.ZIndex = 51
local btnCorner = Instance.new("UICorner", settingsBtn)
btnCorner.CornerRadius = UDim.new(0, 4)

local btnStroke = Instance.new("UIStroke", settingsBtn)
btnStroke.Color = Color3.fromRGB(0, 150, 255)
btnStroke.Thickness = 1
btnStroke.Transparency = 0

settingsBtn.MouseEnter:Connect(function()
    settingsBtn.TextColor3 = Color3.fromRGB(220,220,220)
    settingsBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
end)
settingsBtn.MouseLeave:Connect(function()
    settingsBtn.TextColor3 = Color3.fromRGB(180,180,180)
    settingsBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
end)

local pingFrame = Instance.new("Frame", mainFrame)
pingFrame.Size = UDim2.new(0, 205, 0, 38)
pingFrame.Position = UDim2.new(0, 7, 0, 32)
pingFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
pingFrame.BackgroundTransparency = 0
pingFrame.BorderSizePixel = 0
pingFrame.ZIndex = 2
Instance.new("UICorner", pingFrame).CornerRadius = UDim.new(0,4)

local toggleBtn = Instance.new("TextButton", pingFrame)
toggleBtn.Size = UDim2.new(0, 205, 0, 38)
toggleBtn.Position = UDim2.new(0, 0, 0.5, -19)
toggleBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
toggleBtn.BackgroundTransparency = 0
toggleBtn.BorderSizePixel = 0
toggleBtn.AutoButtonColor = false
toggleBtn.Text = "APAGADO"
toggleBtn.TextColor3 = Color3.fromRGB(0,0,0)
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.TextSize = 14
toggleBtn.ZIndex = 4
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0,4)

local toggleGradient = Instance.new("UIGradient")
toggleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 220, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 255)),
})
toggleGradient.Rotation = 45
toggleGradient.Enabled = false
toggleGradient.Parent = toggleBtn

local function updateToggleButton()
    if active then
        toggleBtn.Text = "ACTIVO"
        toggleBtn.BackgroundColor3 = activeColor
        toggleGradient.Enabled = false
        bgImage.ImageColor3 = activeColor
        bgGradient.Enabled = false
    else
        toggleBtn.Text = "APAGADO"
        toggleBtn.BackgroundColor3 = inactiveColor
        toggleGradient.Enabled = true
        bgImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
        bgGradient.Enabled = true
    end
    toggleBtn.TextColor3 = Color3.fromRGB(0,0,0)
end

toggleBtn.MouseButton1Click:Connect(function()
    flipLag(not active, true)
end)

local settingsOpen = false

-- ============================================================
--  SCROLLING FRAME (contenedor deslizante para los ajustes)
-- ============================================================
local settingsScroll = Instance.new("ScrollingFrame", mainFrame)
settingsScroll.Name = "SettingsScroll"
settingsScroll.Size = UDim2.new(1, 0, 1, -78)
settingsScroll.Position = UDim2.new(0, 0, 0, 74)
settingsScroll.BackgroundTransparency = 1
settingsScroll.BorderSizePixel = 0
settingsScroll.ScrollBarThickness = 6
settingsScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
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

-- Actualizar CanvasSize manualmente según el contenido real
local function updateCanvas()
    local contentH = scrollLayout.AbsoluteContentSize.Y
    local padB = scrollPad.PaddingBottom.Offset
    settingsScroll.CanvasSize = UDim2.new(0, 0, 0, contentH + padB + 8)
end

scrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

-- ============================================================
--  Helper: gradiente blanco -> negro claro
-- ============================================================
local function applyRowGradient(row)
    row.BackgroundColor3 = Color3.fromRGB(255,255,255)
    row.BackgroundTransparency = 0
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(30, 30, 30)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(130,130,130)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(255,255,255)),
    })
    grad.Rotation = 0
    grad.Parent = row
    local stroke = Instance.new("UIStroke", row)
    stroke.Color = Color3.fromRGB(255,255,255)
    stroke.Transparency = 0.7
    stroke.Thickness = 1
    return grad
end

-- ============================================================
--  Fila de input numérico (POWER / DELAY)
-- ============================================================
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
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 22

    local box = Instance.new("TextBox", row)
    box.Size = UDim2.new(0,65,0,22)
    box.Position = UDim2.new(1,-73,0.5,-11)
    box.BackgroundColor3 = Color3.fromRGB(10,10,10)
    box.BackgroundTransparency = 0.8
    box.BorderSizePixel = 0
    box.Text = tostring(getValue())
    box.TextColor3 = Color3.fromRGB(255,255,255)
    box.Font = Enum.Font.GothamBold
    box.TextSize = 10
    box.ClearTextOnFocus = false
    box.ZIndex = 23
    Instance.new("UICorner", box).CornerRadius = UDim.new(0,4)
    local bs = Instance.new("UIStroke",box)
    bs.Color = Color3.fromRGB(150,150,150)
    bs.Transparency = 0.5
    bs.Thickness=1

    box.Focused:Connect(function()
        tw(bs,{Color=Color3.fromRGB(200,200,200), Transparency=0.3},0.12)
    end)
    box.FocusLost:Connect(function()
        tw(bs,{Color=Color3.fromRGB(150,150,150), Transparency=0.5},0.12)
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

-- ============================================================
--  Fila AUTO BRAINROT
-- ============================================================
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
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 22

    local toggleBtn = Instance.new("TextButton", row)
    toggleBtn.Size = UDim2.new(0,50,0,22)
    toggleBtn.Position = UDim2.new(1,-58,0.5,-11)
    toggleBtn.BackgroundColor3 = cfg.autoBrainrot and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    toggleBtn.BackgroundTransparency = 0
    toggleBtn.BorderSizePixel = 0
    toggleBtn.AutoButtonColor = false
    toggleBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    toggleBtn.Font = Enum.Font.GothamBlack
    toggleBtn.TextSize = 9
    toggleBtn.ZIndex = 23
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)
    local tStr = Instance.new("UIStroke", toggleBtn)
    tStr.Color = Color3.fromRGB(150,150,150)
    tStr.Transparency = 0.5
    tStr.Thickness = 1

    toggleBtn.MouseButton1Click:Connect(function()
        cfg.autoBrainrot = not cfg.autoBrainrot
        toggleBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = cfg.autoBrainrot and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        toggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        saveConfig()
    end)
    autoBrainrotBtn = toggleBtn
    return toggleBtn
end

-- ============================================================
--  Fila de keybind (KEYBOARD / CONTROLLER)
-- ============================================================
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
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 22

    local kbBtn = Instance.new("TextButton", row)
    kbBtn.Size = UDim2.new(0,65,0,22)
    kbBtn.Position = UDim2.new(1,-73,0.5,-11)
    kbBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
    kbBtn.BackgroundTransparency = 0.6
    kbBtn.BorderSizePixel = 0
    kbBtn.AutoButtonColor = false
    local displayKey = which == "kb" and cfg.keybindKb or cfg.keybindGp
    kbBtn.Text = displayKey ~= "" and displayKey or "None"
    kbBtn.TextColor3 = Color3.fromRGB(255,255,255)
    kbBtn.Font = Enum.Font.GothamBlack
    kbBtn.TextSize = 9
    kbBtn.ZIndex = 23
    Instance.new("UICorner", kbBtn).CornerRadius = UDim.new(0,4)
    local kbStroke = Instance.new("UIStroke", kbBtn)
    kbStroke.Color = Color3.fromRGB(150,150,150)
    kbStroke.Transparency = 0.5
    kbStroke.Thickness = 1

    kbBtn.MouseButton1Click:Connect(function()
        if listeningForInput then return end
        listeningForInput = which
        kbBtn.Text = "[?]"
        kbBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        kbBtn.TextColor3 = Color3.fromRGB(255,255,255)
    end)

    if which == "kb" then keybindRow = kbBtn end
    return kbBtn
end

-- ============================================================
--  CREACIÓN DE FILAS (con LayoutOrder)
-- ============================================================
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

-- Separador
local div = Instance.new("Frame", settingsScroll)
div.Size = UDim2.new(1, 0, 0, 1)
div.LayoutOrder = ORDER
div.BackgroundColor3 = Color3.fromRGB(180,180,180)
div.BackgroundTransparency = 0.4
div.BorderSizePixel = 0
div.ZIndex = 21
ORDER = ORDER + 1

-- Botón RESET
local resetBtn = Instance.new("TextButton", settingsScroll)
resetBtn.Size = UDim2.new(1, 0, 0, 26)
resetBtn.LayoutOrder = ORDER
resetBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
resetBtn.BackgroundTransparency = 0
resetBtn.BorderSizePixel = 0
resetBtn.AutoButtonColor = false
resetBtn.Text = "RESET DEFAULTS"
resetBtn.TextColor3 = Color3.fromRGB(255,255,255)
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 10
resetBtn.ZIndex = 21
Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0,4)
do
    local rGrad = Instance.new("UIGradient")
    rGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(30, 30, 30)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(130,130,130)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(255,255,255)),
    })
    rGrad.Rotation = 0
    rGrad.Parent = resetBtn
    local resetStroke = Instance.new("UIStroke", resetBtn)
    resetStroke.Color = Color3.fromRGB(255,255,255)
    resetStroke.Transparency = 0.7
    resetStroke.Thickness = 1
end

resetBtn.MouseEnter:Connect(function()
    tw(resetBtn,{BackgroundTransparency=0.15},0.1)
end)
resetBtn.MouseLeave:Connect(function()
    tw(resetBtn,{BackgroundTransparency=0},0.1)
end)

-- Actualizar canvas tras crear todo
task.defer(updateCanvas)
task.delay(0.5, updateCanvas)

-- ============================================================
--  CONFIRM DIALOG
-- ============================================================
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
confirmBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
confirmBox.BackgroundTransparency = 0
confirmBox.BorderSizePixel = 0
confirmBox.ZIndex = 51
Instance.new("UICorner", confirmBox).CornerRadius = UDim.new(0,10)
local cStroke = Instance.new("UIStroke", confirmBox)
cStroke.Color = Color3.fromRGB(0, 150, 255)
cStroke.Thickness = 1.3

local confirmLbl = Instance.new("TextLabel", confirmBox)
confirmLbl.Size = UDim2.new(1,-16,0,50)
confirmLbl.Position = UDim2.new(0,8,0,8)
confirmLbl.BackgroundTransparency = 1
confirmLbl.Text = "RESET ALL SETTINGS?"
confirmLbl.TextWrapped = true
confirmLbl.TextColor3 = Color3.fromRGB(255,255,255)
confirmLbl.Font = Enum.Font.GothamBold
confirmLbl.TextSize = 10
confirmLbl.ZIndex = 52

local confirmYes = Instance.new("TextButton", confirmBox)
confirmYes.Size = UDim2.new(0,86,0,26)
confirmYes.Position = UDim2.new(0,8,1,-34)
confirmYes.BackgroundColor3 = Color3.fromRGB(0,0,0)
confirmYes.BorderSizePixel = 0
confirmYes.AutoButtonColor = false
confirmYes.Text = "CONFIRM"
confirmYes.TextColor3 = Color3.fromRGB(255,255,255)
confirmYes.Font = Enum.Font.GothamBlack
confirmYes.TextSize = 10
confirmYes.ZIndex = 52
Instance.new("UICorner", confirmYes).CornerRadius = UDim.new(0,4)
local yesStroke = Instance.new("UIStroke", confirmYes)
yesStroke.Color = Color3.fromRGB(0, 150, 255)
yesStroke.Thickness = 1

local confirmNo = Instance.new("TextButton", confirmBox)
confirmNo.Size = UDim2.new(0,86,0,26)
confirmNo.Position = UDim2.new(1,-94,1,-34)
confirmNo.BackgroundColor3 = Color3.fromRGB(0,0,0)
confirmNo.BorderSizePixel = 0
confirmNo.AutoButtonColor = false
confirmNo.Text = "CANCEL"
confirmNo.TextColor3 = Color3.fromRGB(200,200,200)
confirmNo.Font = Enum.Font.GothamBold
confirmNo.TextSize = 10
confirmNo.ZIndex = 52
Instance.new("UICorner", confirmNo).CornerRadius = UDim.new(0,4)
local noStroke = Instance.new("UIStroke", confirmNo)
noStroke.Color = Color3.fromRGB(0, 150, 255)
noStroke.Thickness = 1

confirmYes.MouseEnter:Connect(function()
    tw(confirmYes,{BackgroundColor3=Color3.fromRGB(20,20,20)},0.1)
end)
confirmYes.MouseLeave:Connect(function()
    tw(confirmYes,{BackgroundColor3=Color3.fromRGB(0,0,0)},0.1)
end)
confirmNo.MouseEnter:Connect(function()
    tw(confirmNo,{TextColor3=Color3.fromRGB(255,255,255)},0.1)
end)
confirmNo.MouseLeave:Connect(function()
    tw(confirmNo,{TextColor3=Color3.fromRGB(200,200,200)},0.1)
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
    powerBox.Text = tostring(cfg.power)
    delayBox.Text = tostring(cfg.interval)
    if autoBrainrotBtn then
        autoBrainrotBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
        autoBrainrotBtn.BackgroundColor3 = cfg.autoBrainrot and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        autoBrainrotBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    end
    if keybindRow then
        local display = cfg.keybindKb ~= "" and cfg.keybindKb or "None"
        keybindRow.Text = display
        keybindRow.BackgroundColor3 = Color3.fromRGB(0,0,0)
        keybindRow.TextColor3 = Color3.fromRGB(255,255,255)
    end
    updateToggleButton()
    saveConfig()
    hideConfirm()
end)

resetBtn.MouseButton1Click:Connect(function()
    confirmLbl.Text = "RESET ALL SETTINGS?"
    confirmBackdrop.Visible = true
end)

-- ============================================================
--  TOGGLE SETTINGS
-- ============================================================
local function toggleSettings()
    settingsOpen = not settingsOpen
    local targetHeight = settingsOpen and MAIN_EXPANDED_H or MAIN_BASE_H
    if settingsOpen then
        bgImage.Image = "rbxassetid://102014673546276"
    else
        bgImage.Image = "rbxassetid://131612898077173"
    end
    settingsScroll.Visible = settingsOpen
    if settingsOpen then
        settingsScroll.CanvasPosition = Vector2.new(0, 0)
        task.defer(updateCanvas)
        task.delay(0.25, updateCanvas)
    end
    if settingsOpen and keybindRow then
        local display = cfg.keybindKb ~= "" and cfg.keybindKb or "None"
        keybindRow.Text = display
        keybindRow.BackgroundColor3 = Color3.fromRGB(0,0,0)
        keybindRow.TextColor3 = Color3.fromRGB(255,255,255)
    end
    tw(mainFrame, {Size = UDim2.new(0, 220, 0, targetHeight)}, 0.2)
end

settingsBtn.MouseButton1Click:Connect(toggleSettings)

-- ============================================================
--  REMOTE / LAG LOGIC
-- ============================================================
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

-- ============================================================
--  INPUT
-- ============================================================
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
                keybindRow.BackgroundColor3 = Color3.fromRGB(0,0,0)
                keybindRow.TextColor3 = Color3.fromRGB(255,255,255)
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
updateToggleButton()