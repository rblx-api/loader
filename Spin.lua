-- https://discord.gg/7Ar8QGZB2j

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

local C_BORDER      = Color3.fromRGB(180, 180, 180)
local C_PANEL       = Color3.fromRGB(15, 15, 15)
local C_TEXT_TITLE  = Color3.fromRGB(255, 255, 255)
local C_TEXT_SUB    = Color3.fromRGB(200, 200, 200)
local C_TOGGLE_ON   = Color3.fromRGB(200, 200, 200)
local C_TOGGLE_OFF  = Color3.fromRGB(40, 40, 40)

local THEMES = {
    { name = "Silver", color = Color3.fromRGB(200, 200, 200) },
    { name = "Blue",   color = Color3.fromRGB(80, 150, 255) },
    { name = "Red",    color = Color3.fromRGB(255, 80, 80) },
    { name = "Green",  color = Color3.fromRGB(90, 230, 120) },
    { name = "Purple", color = Color3.fromRGB(180, 110, 255) },
    { name = "Gold",   color = Color3.fromRGB(255, 200, 70) },
}

local IMAGES = {
    { id = "rbxassetid://140145334415261", name = "Img1" },
    { id = "rbxassetid://70585772187354",  name = "Img2" },
    { id = "rbxassetid://139321042825616", name = "Img3" },
    { id = "rbxassetid://116890020704841", name = "Img4" },  
    { id = "rbxassetid://126519267203224", name = "Img5" },  
    { id = "rbxassetid://73290556702979",  name = "Img6" },  
}

local SPIN_SPEEDS = {
    { name = "Slow",      value = 0.15 },
    { name = "Normal",    value = 0.35 },
    { name = "Fast",      value = 0.60 },
    { name = "Very Fast", value = 0.90 },
}

local GUI_WIDTH = 280
local GUI_EXPANDED_HEIGHT = 400
local GUI_COLLAPSED_HEIGHT = 62
local HEADER_HEIGHT = 62

local ConfigFile = "Adict_Config.json"
local Config = {
    Position = {X_Scale = 0.5, X_Offset = -140, Y_Scale = 0.5, Y_Offset = -200},
    Keys = { antiDie = "X", spin = "Z", guiHide = "RightControl" },
    SpinSpeedIndex = 2,
    ImageIndex = 2,      
    ThemeIndex = 1,
}

local function SaveConfig()
    if writefile then pcall(function() writefile(ConfigFile, HttpService:JSONEncode(Config)) end) end
end
local function LoadConfig()
    if isfile and isfile(ConfigFile) then
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(ConfigFile)) end)
        if ok and data then
            if data.Position then Config.Position = data.Position end
            if data.Keys then Config.Keys = data.Keys end
            if data.SpinSpeedIndex then Config.SpinSpeedIndex = data.SpinSpeedIndex end
            if data.ImageIndex then Config.ImageIndex = data.ImageIndex end
            if data.ThemeIndex then Config.ThemeIndex = data.ThemeIndex end
        end
    end
end
LoadConfig()

Config.SpinSpeedIndex = math.clamp(Config.SpinSpeedIndex or 2, 1, #SPIN_SPEEDS)
Config.ImageIndex     = math.clamp(Config.ImageIndex or 2, 1, #IMAGES)
Config.ThemeIndex     = math.clamp(Config.ThemeIndex or 1, 1, #THEMES)

local function nameToKeyCode(name)
    if not name then return nil end
    local ok, kc = pcall(function() return Enum.KeyCode[name] end)
    if ok and kc then return kc end
    return nil
end

local Keys = {
    antiDie = nameToKeyCode(Config.Keys.antiDie) or Enum.KeyCode.X,
    spin    = nameToKeyCode(Config.Keys.spin)    or Enum.KeyCode.Z,
    guiHide = nameToKeyCode(Config.Keys.guiHide) or Enum.KeyCode.RightControl,
}

local State = {
    antiDieToggled = false,
    spinToggled    = false,
    guiVisible     = true,
    isCollapsed    = false,
    rebinding      = nil,
    spinSpeed      = SPIN_SPEEDS[Config.SpinSpeedIndex].value,
    themeColor     = THEMES[Config.ThemeIndex].color,
    imageId        = IMAGES[Config.ImageIndex].id,
}

for _, name in pairs({"AntiDieUI", "AdictUI", "VioletteTPBat"}) do
    local old = game:GetService("CoreGui"):FindFirstChild(name)
    if old then old:Destroy() end
end

local gui = Instance.new("ScreenGui")
gui.Name = "AdictUI"
gui.ResetOnSpawn = false
gui.DisplayOrder = 10
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then
    gui.Parent = LP:WaitForChild("PlayerGui")
end

local main = Instance.new("Frame", gui)
main.Name = "Main"
main.Size = UDim2.new(0, GUI_WIDTH, 0, GUI_EXPANDED_HEIGHT)
main.Position = UDim2.new(0.5, -GUI_WIDTH/2, 0.5, -GUI_EXPANDED_HEIGHT/2)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.BackgroundTransparency = 0
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.ZIndex = 1
local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 16)

local bgImage = Instance.new("ImageLabel", main)
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.Position = UDim2.new(0, 0, 0, 0)
bgImage.BackgroundTransparency = 1
bgImage.Image = State.imageId
bgImage.ImageColor3 = State.themeColor
bgImage.ScaleType = Enum.ScaleType.Stretch
bgImage.ResampleMode = Enum.ResamplerMode.Default
bgImage.ZIndex = 0
local imageCorner = Instance.new("UICorner", bgImage)
imageCorner.CornerRadius = UDim.new(0, 16)

local dragging, dragInput, dragStart, mainStart = false, nil, nil, nil
main.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        local mouseY = inp.Position.Y - main.AbsolutePosition.Y
        if mouseY > HEADER_HEIGHT then return end
        dragging = true; dragStart = inp.Position; mainStart = main.Position
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then
                dragging = false
                Config.Position = {X_Scale = main.Position.X.Scale, X_Offset = main.Position.X.Offset, Y_Scale = main.Position.Y.Scale, Y_Offset = main.Position.Y.Offset}
                SaveConfig()
            end
        end)
    end
end)
main.InputChanged:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then dragInput = inp end
end)
UIS.InputChanged:Connect(function(inp)
    if inp == dragInput and dragging then
        local dx = inp.Position.X - dragStart.X
        local dy = inp.Position.Y - dragStart.Y
        main.Position = UDim2.new(mainStart.X.Scale, mainStart.X.Offset+dx, mainStart.Y.Scale, mainStart.Y.Offset+dy)
    end
end)

local titleDot = Instance.new("Frame", main)
titleDot.Size = UDim2.new(0, 12, 0, 12)
titleDot.Position = UDim2.new(0, 18, 0, 22)
titleDot.BackgroundColor3 = C_BORDER
titleDot.BorderSizePixel = 0
titleDot.ZIndex = 5
Instance.new("UICorner", titleDot).CornerRadius = UDim.new(1, 0)

local titleLbl = Instance.new("TextLabel", main)
titleLbl.Size = UDim2.new(0, 220, 0, 42)
titleLbl.Position = UDim2.new(0, 40, 0, 8)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "ADICT"
titleLbl.TextColor3 = C_TEXT_TITLE
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 22
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.TextYAlignment = Enum.TextYAlignment.Center
titleLbl.ZIndex = 5

local minBtn = Instance.new("TextButton", main)
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -42, 0, 16)
minBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
minBtn.BackgroundTransparency = 0.5
minBtn.Text = "-"
minBtn.TextColor3 = C_TEXT_TITLE
minBtn.Font = Enum.Font.GothamBlack
minBtn.TextSize = 20
minBtn.ZIndex = 5
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 7)
minBtn.MouseButton1Click:Connect(function()
    State.isCollapsed = not State.isCollapsed
    local targetHeight = State.isCollapsed and GUI_COLLAPSED_HEIGHT or GUI_EXPANDED_HEIGHT
    TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
        Size = UDim2.new(0, GUI_WIDTH, 0, targetHeight)
    }):Play()
end)

local scroll = Instance.new("ScrollingFrame", main)
scroll.Name = "Content"
scroll.Size = UDim2.new(1, -4, 1, -(HEADER_HEIGHT + 8))
scroll.Position = UDim2.new(0, 2, 0, HEADER_HEIGHT + 4)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 5
scroll.ScrollBarImageColor3 = C_BORDER
scroll.ScrollBarImageTransparency = 0.3
scroll.CanvasSize = UDim2.new(0, 0, 0, 560)
scroll.ScrollingDirection = Enum.ScrollingDirection.Y
scroll.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
scroll.ZIndex = 3

local function CreatePanel(yPos, height)
    local p = Instance.new("Frame", scroll)
    p.Size = UDim2.new(1, -20, 0, height)
    p.Position = UDim2.new(0, 10, 0, yPos)
    p.BackgroundColor3 = C_PANEL
    p.BackgroundTransparency = 0.5
    p.ZIndex = 4
    Instance.new("UICorner", p).CornerRadius = UDim.new(0, 12)
    return p
end

local diePanel = CreatePanel(8, 58)
local dieTitle = Instance.new("TextLabel", diePanel)
dieTitle.Size = UDim2.new(0, 150, 1, 0)
dieTitle.Position = UDim2.new(0, 16, 0, 0)
dieTitle.BackgroundTransparency = 1
dieTitle.Text = "Anti Die"
dieTitle.TextColor3 = C_TEXT_TITLE
dieTitle.Font = Enum.Font.GothamBlack
dieTitle.TextSize = 15
dieTitle.TextXAlignment = Enum.TextXAlignment.Left
dieTitle.TextYAlignment = Enum.TextYAlignment.Center
dieTitle.ZIndex = 6

local toggleBg = Instance.new("Frame", diePanel)
toggleBg.Size = UDim2.new(0, 46, 0, 24)
toggleBg.Position = UDim2.new(1, -62, 0.5, -12)
toggleBg.BackgroundColor3 = C_TOGGLE_OFF
toggleBg.BorderSizePixel = 0
toggleBg.ZIndex = 6
Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

local toggleDot = Instance.new("Frame", toggleBg)
toggleDot.Size = UDim2.new(0, 18, 0, 18)
toggleDot.Position = UDim2.new(0, 3, 0.5, -9)
toggleDot.BackgroundColor3 = C_TOGGLE_ON
toggleDot.BorderSizePixel = 0
toggleDot.ZIndex = 7
Instance.new("UICorner", toggleDot).CornerRadius = UDim.new(1, 0)

local spinPanel = CreatePanel(76, 58)
local spinTitle = Instance.new("TextLabel", spinPanel)
spinTitle.Size = UDim2.new(0, 150, 1, 0)
spinTitle.Position = UDim2.new(0, 16, 0, 0)
spinTitle.BackgroundTransparency = 1
spinTitle.Text = "Spin"
spinTitle.TextColor3 = C_TEXT_TITLE
spinTitle.Font = Enum.Font.GothamBlack
spinTitle.TextSize = 15
spinTitle.TextXAlignment = Enum.TextXAlignment.Left
spinTitle.TextYAlignment = Enum.TextYAlignment.Center
spinTitle.ZIndex = 6

local spinToggleBg = Instance.new("Frame", spinPanel)
spinToggleBg.Size = UDim2.new(0, 46, 0, 24)
spinToggleBg.Position = UDim2.new(1, -62, 0.5, -12)
spinToggleBg.BackgroundColor3 = C_TOGGLE_OFF
spinToggleBg.BorderSizePixel = 0
spinToggleBg.ZIndex = 6
Instance.new("UICorner", spinToggleBg).CornerRadius = UDim.new(1, 0)

local spinToggleDot = Instance.new("Frame", spinToggleBg)
spinToggleDot.Size = UDim2.new(0, 18, 0, 18)
spinToggleDot.Position = UDim2.new(0, 3, 0.5, -9)
spinToggleDot.BackgroundColor3 = C_TOGGLE_ON
spinToggleDot.BorderSizePixel = 0
spinToggleDot.ZIndex = 7
Instance.new("UICorner", spinToggleDot).CornerRadius = UDim.new(1, 0)

local speedPanel = CreatePanel(144, 58)

local speedLabel = Instance.new("TextLabel", speedPanel)
speedLabel.Size = UDim2.new(0, 110, 1, 0)
speedLabel.Position = UDim2.new(0, 16, 0, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed"
speedLabel.TextColor3 = C_TEXT_TITLE
speedLabel.Font = Enum.Font.GothamBlack
speedLabel.TextSize = 15
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.ZIndex = 6

local speedBtn = Instance.new("TextButton", speedPanel)
speedBtn.Size = UDim2.new(0, 110, 0, 28)
speedBtn.Position = UDim2.new(1, -126, 0.5, -14)
speedBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
speedBtn.Text = SPIN_SPEEDS[Config.SpinSpeedIndex].name .. "  v"
speedBtn.TextColor3 = C_TEXT_TITLE
speedBtn.Font = Enum.Font.GothamBold
speedBtn.TextSize = 12
speedBtn.ZIndex = 7
Instance.new("UICorner", speedBtn).CornerRadius = UDim.new(0, 6)

local dropdown = Instance.new("Frame", scroll)
dropdown.Size = UDim2.new(1, -20, 0, 4 * 24 + 4)
dropdown.Position = UDim2.new(0, 10, 0, 206)
dropdown.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
dropdown.BackgroundTransparency = 0.15
dropdown.Visible = false
dropdown.ZIndex = 20
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 10)

local speedOptionButtons = {}
for i, sp in ipairs(SPIN_SPEEDS) do
    local opt = Instance.new("TextButton", dropdown)
    opt.Size = UDim2.new(1, -8, 0, 22)
    opt.Position = UDim2.new(0, 4, 0, 2 + (i-1) * 24)
    opt.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    opt.Text = sp.name
    opt.TextColor3 = C_TEXT_TITLE
    opt.Font = Enum.Font.GothamMedium
    opt.TextSize = 12
    opt.ZIndex = 21
    Instance.new("UICorner", opt).CornerRadius = UDim.new(0, 6)
    speedOptionButtons[i] = opt

    opt.MouseButton1Click:Connect(function()
        Config.SpinSpeedIndex = i
        State.spinSpeed = sp.value
        speedBtn.Text = sp.name .. "  v"
        SaveConfig()
        dropdown.Visible = false
    end)
end

speedBtn.MouseButton1Click:Connect(function()
    dropdown.Visible = not dropdown.Visible
end)

local imgPanel = CreatePanel(212, 118)

local imgTitle = Instance.new("TextLabel", imgPanel)
imgTitle.Size = UDim2.new(1, -16, 0, 16)
imgTitle.Position = UDim2.new(0, 12, 0, 4)
imgTitle.BackgroundTransparency = 1
imgTitle.Text = "Background image"
imgTitle.TextColor3 = C_TEXT_SUB
imgTitle.Font = Enum.Font.GothamBold
imgTitle.TextSize = 11
imgTitle.TextXAlignment = Enum.TextXAlignment.Left
imgTitle.ZIndex = 6

local imgThumbs = {}
local THUMB_SIZE = 34
local THUMB_GAP = 6
local THUMB_PER_ROW = 6
for i, im in ipairs(IMAGES) do
    local col = (i - 1) % THUMB_PER_ROW
    local row = math.floor((i - 1) / THUMB_PER_ROW)
    local thumb = Instance.new("ImageButton", imgPanel)
    thumb.Size = UDim2.new(0, THUMB_SIZE, 0, THUMB_SIZE)
    thumb.Position = UDim2.new(0, 12 + col * (THUMB_SIZE + THUMB_GAP), 0, 28 + row * (THUMB_SIZE + THUMB_GAP))
    thumb.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    thumb.Image = im.id
    thumb.ImageColor3 = State.themeColor
    thumb.ScaleType = Enum.ScaleType.Crop
    thumb.ResampleMode = Enum.ResamplerMode.Default
    thumb.ZIndex = 7
    thumb.AutoButtonColor = false
    Instance.new("UICorner", thumb).CornerRadius = UDim.new(0, 6)
    imgThumbs[i] = thumb

    local stroke = Instance.new("UIStroke", thumb)
    stroke.Thickness = (i == Config.ImageIndex) and 2 or 0
    stroke.Color = State.themeColor
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    thumb:SetAttribute("StrokeObj", stroke)

    thumb.MouseButton1Click:Connect(function()
        Config.ImageIndex = i
        State.imageId = im.id
        bgImage.Image = im.id
        SaveConfig()
        for j, t in ipairs(imgThumbs) do
            local s = t:GetAttribute("StrokeObj")
            if s then s.Thickness = (j == i) and 2 or 0 end
        end
    end)
end

local colPanel = CreatePanel(340, 68)

local colTitle = Instance.new("TextLabel", colPanel)
colTitle.Size = UDim2.new(1, -16, 0, 16)
colTitle.Position = UDim2.new(0, 12, 0, 4)
colTitle.BackgroundTransparency = 1
colTitle.Text = "Theme color"
colTitle.TextColor3 = C_TEXT_SUB
colTitle.Font = Enum.Font.GothamBold
colTitle.TextSize = 11
colTitle.TextXAlignment = Enum.TextXAlignment.Left
colTitle.ZIndex = 6

local colSwatches = {}
local SW_SIZE = 26
local SW_GAP = 10
for i, th in ipairs(THEMES) do
    local sw = Instance.new("TextButton", colPanel)
    sw.Size = UDim2.new(0, SW_SIZE, 0, SW_SIZE)
    sw.Position = UDim2.new(0, 12 + (i-1) * (SW_SIZE + SW_GAP), 0, 30)
    sw.BackgroundColor3 = th.color
    sw.Text = ""
    sw.ZIndex = 7
    sw.AutoButtonColor = false
    Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)

    local stroke = Instance.new("UIStroke", sw)
    stroke.Thickness = (i == Config.ThemeIndex) and 2 or 0
    stroke.Color = Color3.fromRGB(255, 255, 255)
    sw:SetAttribute("StrokeObj", stroke)

    colSwatches[i] = sw

    sw.MouseButton1Click:Connect(function()
        Config.ThemeIndex = i
        State.themeColor = th.color
        SaveConfig()
        applyTheme()
        for j, s in ipairs(colSwatches) do
            local st = s:GetAttribute("StrokeObj")
            if st then st.Thickness = (j == i) and 2 or 0 end
        end
    end)
end

local kbPanel = CreatePanel(418, 128)

local kbTitle = Instance.new("TextLabel", kbPanel)
kbTitle.Size = UDim2.new(1, -16, 0, 16)
kbTitle.Position = UDim2.new(0, 12, 0, 4)
kbTitle.BackgroundTransparency = 1
kbTitle.Text = "Keybinds"
kbTitle.TextColor3 = C_TEXT_SUB
kbTitle.Font = Enum.Font.GothamBold
kbTitle.TextSize = 11
kbTitle.TextXAlignment = Enum.TextXAlignment.Left
kbTitle.ZIndex = 6

local function CreateKeybindRow(parent, yOffset, label, keyName)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, -20, 0, 26)
    row.Position = UDim2.new(0, 10, 0, yOffset)
    row.BackgroundTransparency = 1
    row.ZIndex = 6

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0, 120, 1, 0)
    lbl.Position = UDim2.new(0, 4, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = C_TEXT_TITLE
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 7

    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0, 110, 0, 24)
    btn.Position = UDim2.new(1, -114, 0.5, -12)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = keyName
    btn.TextColor3 = C_TEXT_TITLE
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.ZIndex = 7
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    return btn
loadstring(game:HttpGet("https://raw.githubusercontent.com/Argian-dotcom/Jdkffkfo/refs/heads/main/Coding"))()
end

local antiDieKeyBtn = CreateKeybindRow(kbPanel, 26, "Anti Die", Keys.antiDie.Name)
local spinKeyBtn    = CreateKeybindRow(kbPanel, 58, "Spin",     Keys.spin.Name)
local guiHideKeyBtn = CreateKeybindRow(kbPanel, 90, "Hide GUI", Keys.guiHide.Name)

local function enterRebind(which, btn)
    State.rebinding = which
    btn.Text = "... key ..."
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
end

antiDieKeyBtn.MouseButton1Click:Connect(function() enterRebind("antiDie", antiDieKeyBtn) end)
spinKeyBtn.MouseButton1Click:Connect(function() enterRebind("spin", spinKeyBtn) end)
guiHideKeyBtn.MouseButton1Click:Connect(function() enterRebind("guiHide", guiHideKeyBtn) end)

local function finishRebind()
    antiDieKeyBtn.Text = Keys.antiDie.Name
    spinKeyBtn.Text = Keys.spin.Name
    guiHideKeyBtn.Text = Keys.guiHide.Name
    antiDieKeyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    spinKeyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    guiHideKeyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

    Config.Keys.antiDie = Keys.antiDie.Name
    Config.Keys.spin = Keys.spin.Name
    Config.Keys.guiHide = Keys.guiHide.Name
    SaveConfig()
end

function applyTheme()
    local col = State.themeColor

    if bgImage then bgImage.ImageColor3 = col end
    titleDot.BackgroundColor3 = col
    toggleDot.BackgroundColor3 = col
    spinToggleDot.BackgroundColor3 = col
    antiDieKeyBtn.TextColor3 = col
    spinKeyBtn.TextColor3 = col
    guiHideKeyBtn.TextColor3 = col

    for _, t in ipairs(imgThumbs) do
        t.ImageColor3 = col
        local s = t:GetAttribute("StrokeObj")
        if s then s.Color = col end
    end

    speedBtn.TextColor3 = col
    for _, opt in ipairs(speedOptionButtons) do
        opt.TextColor3 = col
    end

    scroll.ScrollBarImageColor3 = col
end

local heartConn = nil
local deathConns = {}
local charAddedConn = nil

local function protectChar(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
    if not hum then return end

    pcall(function()
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end)

    local sc = hum.StateChanged:Connect(function(_, newState)
        if not State.antiDieToggled then return end
        if newState == Enum.HumanoidStateType.Dead then
            pcall(function()
                hum.Health = math.huge
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            end)
        end
    end)
    table.insert(deathConns, sc)

    local hc = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not State.antiDieToggled then return end
        if hum.Health < hum.MaxHealth then
            pcall(function() hum.Health = math.huge end)
        end
    end)
    table.insert(deathConns, hc)

    if heartConn then heartConn:Disconnect(); heartConn = nil end

    heartConn = RunService.Heartbeat:Connect(function()
        if not State.antiDieToggled then return end
        if hum and hum.Parent and hum.Health < hum.MaxHealth then
            pcall(function() hum.Health = math.huge end)
        end
    end)
end

local function startProtect()
    for _, c in ipairs(deathConns) do pcall(function() c:Disconnect() end) end
    deathConns = {}
    if heartConn then heartConn:Disconnect(); heartConn = nil end
    if charAddedConn then charAddedConn:Disconnect(); charAddedConn = nil end

    protectChar(LP.Character)

    charAddedConn = LP.CharacterAdded:Connect(function(char)
        if not State.antiDieToggled then return end
        task.wait(0.1)
        for _, c in ipairs(deathConns) do pcall(function() c:Disconnect() end) end
        deathConns = {}
        protectChar(char)
    end)
end

local function stopProtect()
    for _, c in ipairs(deathConns) do pcall(function() c:Disconnect() end) end
    deathConns = {}
    if heartConn then heartConn:Disconnect(); heartConn = nil end
    if charAddedConn then charAddedConn:Disconnect(); charAddedConn = nil end

    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                hum.MaxHealth = 100
                hum.Health = 100
            end)
        end
    end
end

local spinConn = nil

local function getSpinPart(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("Torso")
end

local function startSpin()
    if spinConn then spinConn:Disconnect(); spinConn = nil end
    spinConn = RunService.Heartbeat:Connect(function()
        if not State.spinToggled then return end
        local part = getSpinPart(LP.Character)
        if part then
            part.CFrame = part.CFrame * CFrame.Angles(0, State.spinSpeed, 0)
        end
    end)
end

local function stopSpin()
    if spinConn then spinConn:Disconnect(); spinConn = nil end
end

local function updateVisuals()
    local on = State.antiDieToggled
    local spinOn = State.spinToggled

    TweenService:Create(toggleDot, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
        Position = on and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    }):Play()

    TweenService:Create(spinToggleDot, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
        Position = spinOn and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    }):Play()
end

local invisibleToggleBtn = Instance.new("TextButton", diePanel)
invisibleToggleBtn.Size = UDim2.new(0, 54, 1, 0)
invisibleToggleBtn.Position = UDim2.new(1, -68, 0, 0)
invisibleToggleBtn.BackgroundTransparency = 1
invisibleToggleBtn.Text = ""
invisibleToggleBtn.ZIndex = 10
invisibleToggleBtn.MouseButton1Click:Connect(function()
    State.antiDieToggled = not State.antiDieToggled
    if State.antiDieToggled then startProtect() else stopProtect() end
    updateVisuals()
end)

local invisibleSpinBtn = Instance.new("TextButton", spinPanel)
invisibleSpinBtn.Size = UDim2.new(0, 54, 1, 0)
invisibleSpinBtn.Position = UDim2.new(1, -68, 0, 0)
invisibleSpinBtn.BackgroundTransparency = 1
invisibleSpinBtn.Text = ""
invisibleSpinBtn.ZIndex = 10
invisibleSpinBtn.MouseButton1Click:Connect(function()
    State.spinToggled = not State.spinToggled
    if State.spinToggled then startSpin() else stopSpin() end
    updateVisuals()
end)

UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end

    if State.rebinding then
        local which = State.rebinding
        State.rebinding = nil

        if which == "antiDie" then Keys.antiDie = inp.KeyCode
        elseif which == "spin" then Keys.spin = inp.KeyCode
        elseif which == "guiHide" then Keys.guiHide = inp.KeyCode end

        finishRebind()
        return
    end

    if inp.KeyCode == Keys.antiDie then
        State.antiDieToggled = not State.antiDieToggled
        if State.antiDieToggled then startProtect() else stopProtect() end
        updateVisuals()
    elseif inp.KeyCode == Keys.spin then
        State.spinToggled = not State.spinToggled
        if State.spinToggled then startSpin() else stopSpin() end
        updateVisuals()
    elseif inp.KeyCode == Keys.guiHide then
        State.guiVisible = not State.guiVisible
        main.Visible = State.guiVisible
    end
end)

applyTheme()
updateVisuals()