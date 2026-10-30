local Players     = game:GetService("Players")
local UIS         = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService  = game:GetService("RunService")
local TweenService= game:GetService("TweenService")
local NetworkClient = game:GetService("NetworkClient")
local LP          = Players.LocalPlayer
local PlayerGui   = LP:WaitForChild("PlayerGui")

local C = {
    bg        = Color3.fromRGB(0, 0, 0),
    rowBg     = Color3.fromRGB(10, 10, 10),
    rowBorder = Color3.fromRGB(50, 50, 50),
    inputBg   = Color3.fromRGB(15, 15, 15),
    button    = Color3.fromRGB(30, 30, 35),
    white     = Color3.fromRGB(255, 255, 255),
    text      = Color3.fromRGB(240, 240, 250),
    dim       = Color3.fromRGB(150, 150, 165),
    accent    = Color3.fromRGB(245, 245, 252),
    active    = Color3.fromRGB(0, 255, 100),
    inactive  = Color3.fromRGB(255, 91, 116),
}

local T = {
    row  = 0.70,
    inp  = 0.70,
    btn  = 0.50,
    stroke = 0.55,
}

local CONFIG_FILE = "VLEXUS_BYPASS_Config.json"

local Config = {
    Enabled      = false,
    AutoBrainrot = false,
    PowerValue   = 97000,
    Mode         = "PC",
    ToggleKey    = Enum.KeyCode.V,
    UILocked     = false,
    Minimized    = false,
    Position     = { X_Scale = 0.5, X_Offset = -100, Y_Scale = 0.5, Y_Offset = -110 },
}

local function SaveConfig()
    if writefile then
        pcall(function()
            writefile(CONFIG_FILE, HttpService:JSONEncode({
                Position     = Config.Position,
                PowerValue   = Config.PowerValue,
                Mode         = Config.Mode,
                ToggleKey    = Config.ToggleKey.Name,
                UILocked     = Config.UILocked,
                AutoBrainrot = Config.AutoBrainrot,
            }))
        end)
    end
end

local function LoadConfig()
    if isfile and isfile(CONFIG_FILE) then
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_FILE)) end)
        if ok and data then
            if data.Position     then Config.Position = data.Position end
            if data.PowerValue   then Config.PowerValue = data.PowerValue end
            if data.Mode         then Config.Mode = data.Mode end
            if data.ToggleKey    then Config.ToggleKey = Enum.KeyCode[data.ToggleKey] or Enum.KeyCode.V end
            if data.UILocked     ~= nil then Config.UILocked = data.UILocked end
            if data.AutoBrainrot ~= nil then Config.AutoBrainrot = data.AutoBrainrot end
        end
    end
end
LoadConfig()

local DEPTH      = 296
local SPAM_DELAY = 0.12
local running    = false
local bomb       = nil
local spamThread = nil
local lastStealState = nil

local function buildBomb(power)
    local maintable    = {}
    local spammedtable = { {} }
    local z = spammedtable[1]
    for _ = 1, DEPTH do
        local tableins = {}
        table.insert(z, tableins)
        z = tableins
    end
    local maxRep = math.floor(power / (DEPTH + 2))
    for _ = 1, maxRep do
        table.insert(maintable, spammedtable)
    end
    return maintable
end

local function stopBypass()
    running = false
    if spamThread then
        pcall(task.cancel, spamThread)
        spamThread = nil
    end
    bomb = nil
    pcall(function() NetworkClient:SetOutgoingKBPSLimit(0) end)
end

local function startBypass(power)
    stopBypass()
    running = true
    bomb = buildBomb(power)
    pcall(function() NetworkClient:SetOutgoingKBPSLimit(math.huge) end)
    spamThread = task.spawn(function()
        while running do
            if bomb then
                pcall(function()
                    game.RobloxReplicatedStorage.SetPlayerBlockList:FireServer(bomb)
                end)
            end
            task.wait(SPAM_DELAY)
        end
    end)
end

for _, n in ipairs({"Clean Speed Bypass", "Lust Bypass", "SpeedBypassUI", "BYPASS VLEXUS"}) do
    local old = PlayerGui:FindFirstChild(n)
    if old then old:Destroy() end
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "BYPASS VLEXUS"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

local Root = Instance.new("Frame")
Root.Name = "Root"
Root.Active = true
Root.BackgroundTransparency = 1
Root.BorderSizePixel = 0
Root.Position = UDim2.new(Config.Position.X_Scale, Config.Position.X_Offset, Config.Position.Y_Scale, Config.Position.Y_Offset)
Root.Size = UDim2.new(0, 350, 0, 280)
Root.ClipsDescendants = true
Root.Parent = Gui

local Frame = Instance.new("Frame")
Frame.Name = "Panel"
Frame.BackgroundColor3 = C.bg
Frame.BackgroundTransparency = 1
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Position = UDim2.new(0, 30, 0, 0)
Frame.Size = UDim2.new(0, 290, 0, 280)
Frame.Parent = Root

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = Frame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(30, 30, 30)
MainStroke.Thickness = 1
MainStroke.Transparency = 0
MainStroke.Parent = Frame

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 48)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = C.rowBg
Header.BackgroundTransparency = 0.35
Header.BorderSizePixel = 0
Header.ZIndex = 2
Header.ClipsDescendants = true
Header.Parent = Frame

local LustPhoto = Instance.new("ImageLabel")
LustPhoto.Name = "LustPhoto"
LustPhoto.BackgroundTransparency = 1
LustPhoto.BorderSizePixel = 0
LustPhoto.Size = UDim2.new(1, 0, 1, 0)
LustPhoto.Position = UDim2.new(0, 0, 0, 0)
LustPhoto.Image = "rbxassetid://91411557607071"
LustPhoto.ImageTransparency = 0
LustPhoto.ScaleType = Enum.ScaleType.Stretch
LustPhoto.ZIndex = 1
LustPhoto.Parent = Frame
Instance.new("UICorner", LustPhoto).CornerRadius = UDim.new(0, 14)

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = Header

local HeaderGrad = Instance.new("UIGradient")
HeaderGrad.Rotation = 90
HeaderGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 44)),
    ColorSequenceKeypoint.new(0.55, Color3.fromRGB(20, 20, 26)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(12, 12, 18)),
})
HeaderGrad.Parent = Header

local HeaderAccent = Instance.new("Frame")
HeaderAccent.Name = "HeaderAccent"
HeaderAccent.BackgroundColor3 = C.accent
HeaderAccent.BackgroundTransparency = 0.18
HeaderAccent.BorderSizePixel = 0
HeaderAccent.Position = UDim2.new(0.06, 0, 1, -3)
HeaderAccent.Size = UDim2.new(0.88, 0, 0, 2)
HeaderAccent.ZIndex = 6
HeaderAccent.Parent = Header
Instance.new("UICorner", HeaderAccent).CornerRadius = UDim.new(1, 0)

local BrandDot = Instance.new("Frame")
BrandDot.Name = "BrandDot"
BrandDot.Size = UDim2.new(0, 8, 0, 8)
BrandDot.Position = UDim2.new(0, 13, 0, 14)
BrandDot.BackgroundColor3 = C.accent
BrandDot.BorderSizePixel = 0
BrandDot.ZIndex = 5
BrandDot.Parent = Header
Instance.new("UICorner", BrandDot).CornerRadius = UDim.new(1, 0)

local BrandDotStroke = Instance.new("UIStroke", BrandDot)
BrandDotStroke.Color = Color3.fromRGB(180, 180, 200)
BrandDotStroke.Thickness = 2
BrandDotStroke.Transparency = 0.5

local TitleLbl = Instance.new("TextLabel")
TitleLbl.BackgroundTransparency = 1
TitleLbl.Position = UDim2.new(0, 30, 0, 8)
TitleLbl.Size = UDim2.new(1, -74, 0, 17)
TitleLbl.ZIndex = 20
TitleLbl.Font = Enum.Font.GothamBlack
TitleLbl.Text = "BYPASS VLEXUS"
TitleLbl.TextColor3 = C.white
TitleLbl.TextSize = 13
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
TitleLbl.Parent = Header

local SubLbl = Instance.new("TextLabel")
SubLbl.BackgroundTransparency = 1
SubLbl.Position = UDim2.new(0, 30, 0, 26)
SubLbl.Size = UDim2.new(1, -74, 0, 12)
SubLbl.ZIndex = 20
SubLbl.Font = Enum.Font.GothamMedium
SubLbl.Text = "SPEED BYPASS"
SubLbl.TextColor3 = C.dim
SubLbl.TextSize = 9
SubLbl.TextXAlignment = Enum.TextXAlignment.Left
SubLbl.Parent = Header

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.BackgroundColor3 = C.button
MinimizeBtn.BackgroundTransparency = 0.2
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Position = UDim2.new(1, -34, 0, 12)
MinimizeBtn.Size = UDim2.new(0, 22, 0, 22)
MinimizeBtn.ZIndex = 30
MinimizeBtn.AutoButtonColor = false
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = C.white
MinimizeBtn.TextSize = 15
MinimizeBtn.Parent = Header

local UICorner_4 = Instance.new("UICorner")
UICorner_4.CornerRadius = UDim.new(1, 0)
UICorner_4.Parent = MinimizeBtn

local MinStroke = Instance.new("UIStroke", MinimizeBtn)
MinStroke.Color = C.rowBorder
MinStroke.Thickness = 1
MinStroke.Transparency = 0.4

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ClipsDescendants = true
Content.Position = UDim2.new(0, 0, 0, 54)
Content.Size = UDim2.new(1, 0, 1, -54)
Content.ZIndex = 2
Content.Parent = Frame

local SectionLbl = Instance.new("TextLabel")
SectionLbl.Name = "SettingsLabel"
SectionLbl.BackgroundTransparency = 1
SectionLbl.Position = UDim2.new(0.36, 0, 0, 4)
SectionLbl.Size = UDim2.new(0.58, 0, 0, 12)
SectionLbl.ZIndex = 4
SectionLbl.Font = Enum.Font.GothamBold
SectionLbl.Text = "CONTROL PANEL"
SectionLbl.TextColor3 = C.dim
SectionLbl.TextSize = 8
SectionLbl.TextXAlignment = Enum.TextXAlignment.Left
SectionLbl.Parent = Content

local ActionLabel = Instance.new("TextLabel")
ActionLabel.Name = "ActionLabel"
ActionLabel.BackgroundTransparency = 1
ActionLabel.Position = UDim2.new(0.06, 0, 0, 4)
ActionLabel.Size = UDim2.new(0.27, 0, 0, 12)
ActionLabel.ZIndex = 4
ActionLabel.Font = Enum.Font.GothamBold
ActionLabel.Text = "MASTER SWITCH"
ActionLabel.TextColor3 = C.dim
ActionLabel.TextSize = 8
ActionLabel.TextXAlignment = Enum.TextXAlignment.Left
ActionLabel.Parent = Content

local function mkRow(height, yPos)
    local row = Instance.new("Frame")
    row.BackgroundColor3 = C.rowBg
    row.BackgroundTransparency = 0.26
    row.BorderSizePixel = 0
    row.Position = UDim2.new(0.36, 0, 0, yPos)
    row.Size = UDim2.new(0.58, 0, 0, height)
    row.ZIndex = 3
    row.Parent = Content
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke")
    s.Color = C.rowBorder
    s.Thickness = 1
    s.Transparency = 0.52
    s.Parent = row
    local rowGradient = Instance.new("UIGradient")
    rowGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.rowBg),
        ColorSequenceKeypoint.new(1, C.bg),
    })
    rowGradient.Rotation = 0
    rowGradient.Parent = row
    return row
end

local function mkLabel(parent, text)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Size = UDim2.new(0.45, 0, 1, 0)
    l.Position = UDim2.new(0, 16, 0, 0)
    l.ZIndex = 4
    l.Font = Enum.Font.GothamBold
    l.Text = text
    l.TextColor3 = C.text
    l.TextSize = 10
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

local EnableBtn = Instance.new("TextButton")
EnableBtn.BackgroundColor3 = C.rowBg
EnableBtn.BackgroundTransparency = T.row
EnableBtn.BorderSizePixel = 0
EnableBtn.Position = UDim2.new(0.06, 0, 0, 20)
EnableBtn.Size = UDim2.new(0.27, 0, 0, 170)
EnableBtn.ZIndex = 3
EnableBtn.AutoButtonColor = false
EnableBtn.Font = Enum.Font.GothamBold
EnableBtn.Text = "DESACTIVE"
EnableBtn.TextColor3 = C.white
EnableBtn.TextSize = 12
EnableBtn.Parent = Content

local ActionRail = Instance.new("Frame")
ActionRail.Name = "ActionRail"
ActionRail.BackgroundColor3 = C.accent
ActionRail.BackgroundTransparency = 0.18
ActionRail.BorderSizePixel = 0
ActionRail.Position = UDim2.new(0.06, 0, 0, 20)
ActionRail.Size = UDim2.new(0, 3, 0, 170)
ActionRail.ZIndex = 5
ActionRail.Parent = Content
Instance.new("UICorner", ActionRail).CornerRadius = UDim.new(1, 0)

local EnableCorner = Instance.new("UICorner")
EnableCorner.CornerRadius = UDim.new(0, 10)
EnableCorner.Parent = EnableBtn

local EnableStroke = Instance.new("UIStroke", EnableBtn)
EnableStroke.Color = C.rowBorder
EnableStroke.Thickness = 1
EnableStroke.Transparency = 0.3

local AutoRow = mkRow(28, 24)
mkLabel(AutoRow, "Auto Brainrot")

local AutoBtn = Instance.new("TextButton")
AutoBtn.BackgroundColor3 = C.inputBg
AutoBtn.BackgroundTransparency = T.inp
AutoBtn.BorderSizePixel = 0
AutoBtn.Position = UDim2.new(0.67, 0, 0.16, 0)
AutoBtn.Size = UDim2.new(0.27, 0, 0.68, 0)
AutoBtn.ZIndex = 4
AutoBtn.AutoButtonColor = false
AutoBtn.Font = Enum.Font.GothamBold
AutoBtn.Text = Config.AutoBrainrot and "ON" or "OFF"
AutoBtn.TextColor3 = C.white
AutoBtn.TextSize = 11
AutoBtn.Parent = AutoRow

local AutoCorner = Instance.new("UICorner")
AutoCorner.CornerRadius = UDim.new(0, 6)
AutoCorner.Parent = AutoBtn

local AutoStroke = Instance.new("UIStroke", AutoBtn)
AutoStroke.Color = C.rowBorder
AutoStroke.Thickness = 1
AutoStroke.Transparency = 0.3

local ModeRow = mkRow(28, 58)
mkLabel(ModeRow, "Mode")

local MobileBtn = Instance.new("TextButton")
MobileBtn.BackgroundColor3 = C.inputBg
MobileBtn.BackgroundTransparency = T.inp
MobileBtn.BorderSizePixel = 0
MobileBtn.Position = UDim2.new(0.54, 0, 0.16, 0)
MobileBtn.Size = UDim2.new(0.25, 0, 0.68, 0)
MobileBtn.ZIndex = 4
MobileBtn.AutoButtonColor = false
MobileBtn.Font = Enum.Font.GothamBold
MobileBtn.Text = "Mobile"
MobileBtn.TextColor3 = C.white
MobileBtn.TextSize = 9
MobileBtn.Parent = ModeRow

local MobileCorner = Instance.new("UICorner")
MobileCorner.CornerRadius = UDim.new(0, 6)
MobileCorner.Parent = MobileBtn

local MobileStroke = Instance.new("UIStroke", MobileBtn)
MobileStroke.Color = C.rowBorder
MobileStroke.Thickness = 1
MobileStroke.Transparency = 0.3

local PCBtn = Instance.new("TextButton")
PCBtn.BackgroundColor3 = C.inputBg
PCBtn.BackgroundTransparency = T.inp
PCBtn.BorderSizePixel = 0
PCBtn.Position = UDim2.new(0.81, 0, 0.16, 0)
PCBtn.Size = UDim2.new(0.14, 0, 0.68, 0)
PCBtn.ZIndex = 4
PCBtn.AutoButtonColor = false
PCBtn.Font = Enum.Font.GothamBold
PCBtn.Text = "PC"
PCBtn.TextColor3 = C.white
PCBtn.TextSize = 9
PCBtn.Parent = ModeRow

local PCCorner = Instance.new("UICorner")
PCCorner.CornerRadius = UDim.new(0, 6)
PCCorner.Parent = PCBtn

local PCStroke = Instance.new("UIStroke", PCBtn)
PCStroke.Color = C.rowBorder
PCStroke.Thickness = 1
PCStroke.Transparency = 0.3

local PowerRow = mkRow(28, 92)
mkLabel(PowerRow, "Power")

local PowerInput = Instance.new("TextBox")
PowerInput.BackgroundColor3 = C.inputBg
PowerInput.BackgroundTransparency = T.inp
PowerInput.BorderSizePixel = 0
PowerInput.Position = UDim2.new(0.52, 0, 0.16, 0)
PowerInput.Size = UDim2.new(0.40, 0, 0.68, 0)
PowerInput.ZIndex = 4
PowerInput.Font = Enum.Font.GothamBold
PowerInput.Text = tostring(Config.PowerValue)
PowerInput.TextColor3 = C.white
PowerInput.TextSize = 12
PowerInput.ClearTextOnFocus = false
PowerInput.Parent = PowerRow

local PowerCorner = Instance.new("UICorner")
PowerCorner.CornerRadius = UDim.new(0, 6)
PowerCorner.Parent = PowerInput

local PowerStroke = Instance.new("UIStroke", PowerInput)
PowerStroke.Color = C.rowBorder
PowerStroke.Thickness = 1
PowerStroke.Transparency = 0.3

local KeyRow = mkRow(28, 126)
mkLabel(KeyRow, "Keybind")

local KeyBtn = Instance.new("TextButton")
KeyBtn.BackgroundColor3 = C.inputBg
KeyBtn.BackgroundTransparency = T.inp
KeyBtn.BorderSizePixel = 0
KeyBtn.Position = UDim2.new(0.63, 0, 0.16, 0)
KeyBtn.Size = UDim2.new(0.30, 0, 0.68, 0)
KeyBtn.ZIndex = 4
KeyBtn.AutoButtonColor = false
KeyBtn.Font = Enum.Font.GothamBold
KeyBtn.Text = Config.ToggleKey.Name
KeyBtn.TextColor3 = C.white
KeyBtn.TextSize = 12
KeyBtn.Parent = KeyRow

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 6)
KeyCorner.Parent = KeyBtn

local KeyStroke = Instance.new("UIStroke", KeyBtn)
KeyStroke.Color = C.rowBorder
KeyStroke.Thickness = 1
KeyStroke.Transparency = 0.3

local LockRow = mkRow(28, 160)
LockRow.Size = UDim2.new(0.58, 0, 0, 28)
mkLabel(LockRow, "Lock UI")

local LockBtn = Instance.new("TextButton")
LockBtn.BackgroundColor3 = C.inputBg
LockBtn.BackgroundTransparency = T.inp
LockBtn.BorderSizePixel = 0
LockBtn.Position = UDim2.new(0.61, 0, 0.16, 0)
LockBtn.Size = UDim2.new(0.34, 0, 0.68, 0)
LockBtn.ZIndex = 4
LockBtn.AutoButtonColor = false
LockBtn.Font = Enum.Font.GothamBold
LockBtn.Text = Config.UILocked and "LOCKED" or "UNLOCK"
LockBtn.TextColor3 = C.white
LockBtn.TextSize = 9
LockBtn.Parent = LockRow

local LockCorner = Instance.new("UICorner")
LockCorner.CornerRadius = UDim.new(0, 6)
LockCorner.Parent = LockBtn

local LockStroke = Instance.new("UIStroke", LockBtn)
LockStroke.Color = C.rowBorder
LockStroke.Thickness = 1
LockStroke.Transparency = 0.3

local dragging, dragInput, dragStart, startPos
Root.InputBegan:Connect(function(input)
    if Config.UILocked then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Root.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                Config.Position = {
                    X_Scale = Root.Position.X.Scale, X_Offset = Root.Position.X.Offset,
                    Y_Scale = Root.Position.Y.Scale, Y_Offset = Root.Position.Y.Offset
                }
                SaveConfig()
            end
        end)
    end
end)
Root.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UIS.InputChanged:Connect(function(input)
    if Config.UILocked then return end
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local function updateUIState()
    if Config.Enabled then
        EnableBtn.Text = "ACTÍVATE"
        EnableBtn.BackgroundColor3 = Color3.fromRGB(20, 60, 40)
        EnableBtn.TextColor3 = C.active
        EnableStroke.Color = C.active
        EnableStroke.Transparency = 0.2
    else
        EnableBtn.Text = "DESACTIVE"
        EnableBtn.BackgroundColor3 = C.rowBg
        EnableBtn.TextColor3 = C.inactive
        EnableStroke.Color = C.inactive
        EnableStroke.Transparency = 0.3
    end

    AutoBtn.Text = Config.AutoBrainrot and "ON" or "OFF"
    if Config.AutoBrainrot then
        AutoBtn.BackgroundColor3 = Color3.fromRGB(20, 60, 40)
        AutoBtn.TextColor3 = C.active
        AutoStroke.Color = C.active
        AutoStroke.Transparency = 0.2
    else
        AutoBtn.BackgroundColor3 = C.inputBg
        AutoBtn.TextColor3 = C.white
        AutoStroke.Color = C.rowBorder
        AutoStroke.Transparency = 0.3
    end

    if Config.Mode == "PC" then
        PCBtn.BackgroundColor3 = C.accent
        PCBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        PCStroke.Color = C.accent
        PCStroke.Transparency = 0.2
        MobileBtn.BackgroundColor3 = C.inputBg
        MobileBtn.TextColor3 = C.white
        MobileStroke.Color = C.rowBorder
        MobileStroke.Transparency = 0.3
    else
        MobileBtn.BackgroundColor3 = C.accent
        MobileBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        MobileStroke.Color = C.accent
        MobileStroke.Transparency = 0.2
        PCBtn.BackgroundColor3 = C.inputBg
        PCBtn.TextColor3 = C.white
        PCStroke.Color = C.rowBorder
        PCStroke.Transparency = 0.3
    end

    PowerInput.Text = tostring(Config.PowerValue)
    KeyBtn.Text = Config.ToggleKey.Name
    LockBtn.Text = Config.UILocked and "LOCKED" or "UNLOCK"
    if Config.UILocked then
        LockBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        LockBtn.TextColor3 = C.accent
    else
        LockBtn.BackgroundColor3 = C.inputBg
        LockBtn.TextColor3 = C.white
    end
end

local function setEnabled(state)
    Config.Enabled = state
    if state then
        startBypass(Config.PowerValue)
    else
        stopBypass()
    end
    updateUIState()
end

EnableBtn.MouseButton1Click:Connect(function()
    setEnabled(not Config.Enabled)
    SaveConfig()
end)

AutoBtn.MouseButton1Click:Connect(function()
    Config.AutoBrainrot = not Config.AutoBrainrot
    if not Config.AutoBrainrot and Config.Enabled then
        setEnabled(false)
    end
    updateUIState()
    SaveConfig()
end)

PCBtn.MouseButton1Click:Connect(function()
    Config.Mode = "PC"
    Config.PowerValue = 97000
    if Config.Enabled then startBypass(Config.PowerValue) end
    updateUIState()
    SaveConfig()
end)

MobileBtn.MouseButton1Click:Connect(function()
    Config.Mode = "Mobile"
    Config.PowerValue = 65000
    if Config.Enabled then startBypass(Config.PowerValue) end
    updateUIState()
    SaveConfig()
end)

PowerInput.FocusLost:Connect(function()
    local val = tonumber(PowerInput.Text)
    if val then
        Config.PowerValue = math.clamp(math.floor(val + 0.5), 1, 999999)
        if Config.Enabled then startBypass(Config.PowerValue) end
        SaveConfig()
    end
    PowerInput.Text = tostring(Config.PowerValue)
end)

KeyBtn.MouseButton1Click:Connect(function()
    KeyBtn.Text = "..."
    KeyBtn.TextColor3 = Color3.fromRGB(255, 200, 100)
    local conn
    conn = UIS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            Config.ToggleKey = input.KeyCode
            KeyBtn.Text = input.KeyCode.Name
            KeyBtn.TextColor3 = C.white
            conn:Disconnect()
            SaveConfig()
        end
    end)
end)

LockBtn.MouseButton1Click:Connect(function()
    Config.UILocked = not Config.UILocked
    updateUIState()
    SaveConfig()
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    Config.Minimized = not Config.Minimized
    Content.Visible = not Config.Minimized
    if Config.Minimized then
        Root.Size  = UDim2.new(0, 250, 0, 54)
        Frame.Size = UDim2.new(0, 220, 0, 54)
        MinimizeBtn.Text = "+"
    else
        Root.Size  = UDim2.new(0, 350, 0, 280)
        Frame.Size = UDim2.new(0, 290, 0, 280)
        MinimizeBtn.Text = "-"
    end
end)

RunService.Heartbeat:Connect(function()
    if not Config.AutoBrainrot then
        lastStealState = nil
        return
    end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local ws = hum.WalkSpeed
    local hasSteal = (ws >= 10 and ws < 25)

    if lastStealState == nil then
        lastStealState = hasSteal
        return
    end

    if hasSteal and not lastStealState then
        lastStealState = true
        if not Config.Enabled then setEnabled(true) end
    elseif not hasSteal and lastStealState then
        lastStealState = false
        if Config.Enabled then setEnabled(false) end
    end
end)

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Config.ToggleKey then
            setEnabled(not Config.Enabled)
            SaveConfig()
        end
    end
end)

updateUIState()

return Gui