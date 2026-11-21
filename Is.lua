-- Clean by Prince Bot | .gg/freesource

local Players      = game:GetService("Players")
local UIS          = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RS           = game:GetService("ReplicatedStorage")
local HttpService  = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")

local LP = Players.LocalPlayer
local CONFIG_FILE = "MNLPacketLagger_Config.json"

local ACCENT       = Color3.fromRGB(0, 170, 255)
local ACCENT_GLOW  = Color3.fromRGB(0, 255, 255)
local BG_DARK      = Color3.fromRGB(8, 12, 20)
local BG_PANEL     = Color3.fromRGB(15, 25, 40)
local TEXT_WHITE   = Color3.fromRGB(255, 255, 255)
local TEXT_DIM     = Color3.fromRGB(140, 170, 200)

local sfxFolder = Instance.new("Folder")
sfxFolder.Name = "MNLSFX"
sfxFolder.Parent = SoundService

local function makeSfx(name, id, vol, pitch)
    local s = Instance.new("Sound")
    s.Name = name
    s.SoundId = "rbxassetid://" .. tostring(id)
    s.Volume = vol or 0.5
    s.PlaybackSpeed = pitch or 1
    s.Parent = sfxFolder
    return s
end

local SFX = {
    Click   = makeSfx("Click",   9114282417, 0.35, 1.0),
    Hover   = makeSfx("Hover",   9114294822, 0.15, 1.4),
    Start   = makeSfx("Start",   9114300981, 0.55, 0.9),
    Stop    = makeSfx("Stop",    9114303932, 0.45, 0.75),
    Toggle  = makeSfx("Toggle",  9114307441, 0.40, 1.2),
    Keybind = makeSfx("Keybind", 9114310303, 0.40, 1.6),
    Saved   = makeSfx("Saved",   9114313755, 0.40, 1.3),
    Error   = makeSfx("Error",   9114316718, 0.40, 0.6),
}

local function playSfx(name)
    local s = SFX[name]
    if not s then return end
    s:Stop()
    s:Play()
end

local gui = Instance.new("ScreenGui")
gui.Name = "MNLPacketLagger"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
gui.Parent = LP:WaitForChild("PlayerGui")

local DEF_W, DEF_H = 280, 300
local MIN_W, MAX_W = 240, 400
local MIN_H, MAX_H = 260, 450
local MINI_H = 100

local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, DEF_W, 0, DEF_H)
Main.Position = UDim2.new(0.5, -DEF_W/2, 0.5, -DEF_H/2)
Main.BackgroundColor3 = BG_DARK
Main.BackgroundTransparency = 0.1
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

local BGImage = Instance.new("ImageLabel", Main)
BGImage.Size = UDim2.new(1, 0, 1, 0)
BGImage.BackgroundTransparency = 1
BGImage.Image = "rbxassetid://104214283904459"
BGImage.ScaleType = Enum.ScaleType.Crop
BGImage.ZIndex = 0
Instance.new("UICorner", BGImage).CornerRadius = UDim.new(0, 16)

local BGOverlay = Instance.new("Frame", Main)
BGOverlay.Size = UDim2.new(1, 0, 1, 0)
BGOverlay.BackgroundColor3 = Color3.fromRGB(5, 10, 20)
BGOverlay.BackgroundTransparency = 0.4
BGOverlay.BorderSizePixel = 0
BGOverlay.ZIndex = 1
Instance.new("UICorner", BGOverlay).CornerRadius = UDim.new(0, 16)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = ACCENT
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.2
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.ZIndex = 10

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 48)
TopBar.BackgroundTransparency = 1
TopBar.ZIndex = 3

local Stripe = Instance.new("Frame", TopBar)
Stripe.Size = UDim2.new(1, -24, 0, 1)
Stripe.Position = UDim2.new(0, 12, 1, -1)
Stripe.BackgroundColor3 = ACCENT
Stripe.BackgroundTransparency = 0.4
Stripe.BorderSizePixel = 0
Stripe.ZIndex = 4

local Logo = Instance.new("ImageLabel", TopBar)
Logo.Position = UDim2.new(0, 12, 0.5, -14)
Logo.Size = UDim2.new(0, 28, 0, 28)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://82014603994812"
Logo.ZIndex = 4
Logo.ScaleType = Enum.ScaleType.Fit

local Title = Instance.new("TextLabel", TopBar)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 44, 0, 0)
Title.Size = UDim2.new(1, -140, 1, 0)
Title.Text = "MNL PACKET"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextColor3 = TEXT_WHITE
Title.ZIndex = 4

local TitleGrad = Instance.new("UIGradient", Title)
TitleGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, TEXT_WHITE),
    ColorSequenceKeypoint.new(0.3, ACCENT_GLOW),
    ColorSequenceKeypoint.new(1, TEXT_WHITE),
}

task.spawn(function()
    while Title.Parent do
        local tweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local t1 = TweenService:Create(Title, tweenInfo, {TextSize = 15})
        local t2 = TweenService:Create(Title, tweenInfo, {TextSize = 14})
        t1:Play()
        t1.Completed:Wait()
        t2:Play()
        t2.Completed:Wait()
    end
end)

task.spawn(function()
    local offset = 0
    while TitleGrad.Parent do
        offset = offset + 0.02
        if offset > 1 then offset = -0.5 end
        TitleGrad.Offset = Vector2.new(offset, 0)
        task.wait(0.03)
    end
end)

local function makeTopBtn(text, xOffset)
    local b = Instance.new("TextButton", TopBar)
    b.Size = UDim2.new(0, 20, 0, 20)
    b.Position = UDim2.new(1, xOffset, 0.5, -10)
    b.BackgroundColor3 = BG_PANEL
    b.BackgroundTransparency = 0.2
    b.BorderSizePixel = 0
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.TextColor3 = TEXT_WHITE
    b.AutoButtonColor = false
    b.ZIndex = 4
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", b)
    stroke.Color = ACCENT
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    return b
end

local CollapseBtn = makeTopBtn("−", -26)
local SizePlus  = makeTopBtn("+", -50)
local SizeMinus = makeTopBtn("-", -74)

local Body = Instance.new("Frame", Main)
Body.Position = UDim2.new(0, 0, 0, 48)
Body.Size = UDim2.new(1, 0, 1, -48)
Body.BackgroundTransparency = 1
Body.ZIndex = 3

local UIPad = Instance.new("UIPadding", Body)
UIPad.PaddingTop = UDim.new(0, 10)
UIPad.PaddingBottom = UDim.new(0, 10)
UIPad.PaddingLeft = UDim.new(0, 14)
UIPad.PaddingRight = UDim.new(0, 14)

local List = Instance.new("UIListLayout", Body)
List.SortOrder = Enum.SortOrder.LayoutOrder
List.Padding = UDim.new(0, 8)
List.HorizontalAlignment = Enum.HorizontalAlignment.Center

local IntLabel = Instance.new("TextLabel", Body)
IntLabel.BackgroundTransparency = 1
IntLabel.Size = UDim2.new(1, 0, 0, 12)
IntLabel.Text = "POWER VALUE"
IntLabel.Font = Enum.Font.GothamBold
IntLabel.TextSize = 10
IntLabel.TextXAlignment = Enum.TextXAlignment.Left
IntLabel.TextColor3 = TEXT_DIM
IntLabel.LayoutOrder = 1

local IntBox = Instance.new("TextBox", Body)
IntBox.Size = UDim2.new(1, 0, 0, 38) 
IntBox.BackgroundColor3 = BG_PANEL
IntBox.BackgroundTransparency = 0.15
IntBox.BorderSizePixel = 0
IntBox.Text = "15000"
IntBox.Font = Enum.Font.GothamBlack
IntBox.TextSize = 18
IntBox.TextColor3 = ACCENT_GLOW
IntBox.ClearTextOnFocus = false
IntBox.LayoutOrder = 2
Instance.new("UICorner", IntBox).CornerRadius = UDim.new(0, 8)
local IntStroke = Instance.new("UIStroke", IntBox)
IntStroke.Color = ACCENT
IntStroke.Thickness = 1
IntStroke.Transparency = 0.6

local KeyLabel = Instance.new("TextLabel", Body)
KeyLabel.BackgroundTransparency = 1
KeyLabel.Size = UDim2.new(1, 0, 0, 12)
KeyLabel.Text = "TOGGLE KEYBIND"
KeyLabel.Font = Enum.Font.GothamBold
KeyLabel.TextSize = 10
KeyLabel.TextXAlignment = Enum.TextXAlignment.Left
KeyLabel.TextColor3 = TEXT_DIM
KeyLabel.LayoutOrder = 3

local KeyBoxFrame = Instance.new("Frame", Body)
KeyBoxFrame.Size = UDim2.new(1, 0, 0, 40)
KeyBoxFrame.BackgroundColor3 = BG_PANEL
KeyBoxFrame.BackgroundTransparency = 0.15
KeyBoxFrame.BorderSizePixel = 0
KeyBoxFrame.LayoutOrder = 4
Instance.new("UICorner", KeyBoxFrame).CornerRadius = UDim.new(0, 10)
local KeyBoxStroke = Instance.new("UIStroke", KeyBoxFrame)
KeyBoxStroke.Color = ACCENT
KeyBoxStroke.Thickness = 1
KeyBoxStroke.Transparency = 0.6

local KeyBtn = Instance.new("TextButton", KeyBoxFrame)
KeyBtn.Size = UDim2.new(1, 0, 1, 0)
KeyBtn.BackgroundTransparency = 1
KeyBtn.Text = "G"
KeyBtn.Font = Enum.Font.GothamBlack
KeyBtn.TextSize = 18
KeyBtn.TextColor3 = ACCENT_GLOW
KeyBtn.TextXAlignment = Enum.TextXAlignment.Center 
KeyBtn.AutoButtonColor = false
KeyBtn.ZIndex = 4

local listeningForKey = false

local StartBtn = Instance.new("TextButton", Body)
StartBtn.Size = UDim2.new(1, 0, 0, 46)
StartBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 220)
StartBtn.BorderSizePixel = 0
StartBtn.Text = "START LAG"
StartBtn.Font = Enum.Font.GothamBlack
StartBtn.TextSize = 16
StartBtn.TextColor3 = TEXT_WHITE
StartBtn.AutoButtonColor = false
StartBtn.LayoutOrder = 5
Instance.new("UICorner", StartBtn).CornerRadius = UDim.new(0, 10)

local StartGrad = Instance.new("UIGradient", StartBtn)
StartGrad.Rotation = 90
StartGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 80, 180)),
}

local StartGlow = Instance.new("UIStroke", StartBtn)
StartGlow.Color = ACCENT_GLOW
StartGlow.Thickness = 1.5
StartGlow.Transparency = 0.2

local MiniStart = Instance.new("TextButton", Main)
MiniStart.AnchorPoint = Vector2.new(0.5, 0)
MiniStart.Position = UDim2.new(0.5, 0, 0, 52)
MiniStart.Size = UDim2.new(1, -28, 0, 38)
MiniStart.BackgroundColor3 = Color3.fromRGB(0, 100, 220)
MiniStart.BorderSizePixel = 0
MiniStart.Text = "START LAG"
MiniStart.Font = Enum.Font.GothamBlack
MiniStart.TextSize = 14
MiniStart.TextColor3 = TEXT_WHITE
MiniStart.AutoButtonColor = false
MiniStart.Visible = false
MiniStart.ZIndex = 5
Instance.new("UICorner", MiniStart).CornerRadius = UDim.new(0, 8)

local lagging = false
local lagThread
local intensity = 15000
local toggleKey = Enum.KeyCode.G
local toggleKeyName = "G"
local collapsed = false
local currentW, currentH = DEF_W, DEF_H

local function tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function updateIntensity()
    intensity = math.clamp(math.floor(tonumber(IntBox.Text) or intensity), 1, 100000)
    IntBox.Text = tostring(intensity)
end

local function applyKeybind(name)
    toggleKeyName = name or "G"
    local ok, key = pcall(function() return Enum.KeyCode[toggleKeyName] end)
    toggleKey = ok and key or Enum.KeyCode.G
    KeyBtn.Text = toggleKeyName
end

local function saveConfig()
    updateIntensity()
    local cfg = {
        Intensity = intensity, Keybind = toggleKeyName, Collapsed = collapsed,
        Width = currentW, Height = currentH,
        PX_S = Main.Position.X.Scale, PX_O = Main.Position.X.Offset,
        PY_S = Main.Position.Y.Scale, PY_O = Main.Position.Y.Offset,
    }
    if writefile then pcall(function() writefile(CONFIG_FILE, HttpService:JSONEncode(cfg)) end) end
end

local function loadConfig()
    if not readfile or not isfile or not isfile(CONFIG_FILE) then return end
    local ok, cfg = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_FILE)) end)
    if ok and type(cfg) == "table" then
        if tonumber(cfg.Intensity) then
            intensity = math.clamp(cfg.Intensity, 1, 100000)
            IntBox.Text = tostring(intensity)
        end
        if cfg.Keybind then applyKeybind(cfg.Keybind) end
        if tonumber(cfg.Width) and tonumber(cfg.Height) then
            currentW = math.clamp(cfg.Width, MIN_W, MAX_W)
            currentH = math.clamp(cfg.Height, MIN_H, MAX_H)
            if not cfg.Collapsed then Main.Size = UDim2.new(0, currentW, 0, currentH) end
        end
        if tonumber(cfg.PX_O) and tonumber(cfg.PY_O) then
            Main.Position = UDim2.new(cfg.PX_S, cfg.PX_O, cfg.PY_S, cfg.PY_O)
        end
        if cfg.Collapsed then
            collapsed = true
            CollapseBtn.Text = "+"
            Main.Size = UDim2.new(0, currentW, 0, MINI_H)
            Body.Visible = false
            MiniStart.Visible = true
        end
    end
end

local Event
do
    local ok, net = pcall(function() return RS:WaitForChild("Packages"):WaitForChild("Net") end)
    if ok and net then Event = net:GetChildren()[230] end
end

local function paintRunning()
    tween(StartBtn, {BackgroundColor3 = Color3.fromRGB(0, 180, 255)}, 0.15)
    StartBtn.Text = "STOP LAG"
    tween(StartGlow, {Transparency = 0, Color = Color3.fromRGB(255, 255, 255)}, 0.15)
    
    tween(MiniStart, {BackgroundColor3 = Color3.fromRGB(0, 180, 255)}, 0.15)
    MiniStart.Text = "STOP LAG"
end
local function paintIdle()
    tween(StartBtn, {BackgroundColor3 = Color3.fromRGB(0, 100, 220)}, 0.15)
    StartBtn.Text = "START LAG"
    tween(StartGlow, {Transparency = 0.2, Color = ACCENT_GLOW}, 0.15)
    
    tween(MiniStart, {BackgroundColor3 = Color3.fromRGB(0, 100, 220)}, 0.15)
    MiniStart.Text = "START LAG"
end

local function toggleLag()
    if lagging then
        lagging = false
        if lagThread then pcall(task.cancel, lagThread); lagThread = nil end
        paintIdle()
        playSfx("Stop")
    else
        if not Event then playSfx("Error"); return end
        updateIntensity()
        lagging = true
        paintRunning()
        playSfx("Start")
        local payload = table.create(intensity, function() end)
        lagThread = task.spawn(function()
            while lagging do
                for _ = 1, 3 do pcall(function() Event:FireServer(payload) end) end
                task.wait(0.01)
            end
        end)
    end
end

local function attachHover(b)
    b.MouseEnter:Connect(function() tween(b, {BackgroundTransparency = 0.1}, 0.1); playSfx("Hover") end)
    b.MouseLeave:Connect(function() tween(b, {BackgroundTransparency = 0.2}, 0.1) end)
end

attachHover(CollapseBtn)
attachHover(SizePlus)
attachHover(SizeMinus)
attachHover(StartBtn)

IntBox.FocusLost:Connect(function()
    updateIntensity()
    playSfx("Click")
    saveConfig()
end)

StartBtn.MouseButton1Click:Connect(function() playSfx("Click"); toggleLag() end)
MiniStart.MouseButton1Click:Connect(function() playSfx("Click"); toggleLag() end)

local function updateSize(changeW, changeH)
    currentW = math.clamp(currentW + changeW, MIN_W, MAX_W)
    currentH = math.clamp(currentH + changeH, MIN_H, MAX_H)
    if not collapsed then tween(Main, {Size = UDim2.new(0, currentW, 0, currentH)}, 0.2) end
    playSfx("Click")
    saveConfig()
end

SizePlus.MouseButton1Click:Connect(function() updateSize(20, 20) end)
SizeMinus.MouseButton1Click:Connect(function() updateSize(-20, -20) end)

KeyBtn.MouseButton1Click:Connect(function()
    if listeningForKey then return end
    listeningForKey = true
    KeyBtn.Text = "..."
    tween(KeyBoxStroke, {Transparency = 0, Color = ACCENT_GLOW}, 0.15)
    playSfx("Keybind")
end)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if listeningForKey then
        local newKey = nil
        if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType.Name:match("Gamepad") then
            newKey = input.KeyCode.Name
        end
        if newKey and newKey ~= "Unknown" then
            listeningForKey = false
            applyKeybind(newKey)
            tween(KeyBoxStroke, {Transparency = 0.6, Color = ACCENT}, 0.15)
            playSfx("Keybind")
            saveConfig()
        end
        return
    end
    if input.KeyCode == toggleKey then playSfx("Toggle"); toggleLag() end
end)

CollapseBtn.MouseButton1Click:Connect(function()
    collapsed = not collapsed
    if collapsed then
        CollapseBtn.Text = "+"
        Body.Visible = false
        MiniStart.Visible = true
        tween(Main, {Size = UDim2.new(0, currentW, 0, MINI_H)}, 0.3)
    else
        CollapseBtn.Text = "−"
        MiniStart.Visible = false
        Body.Visible = true
        tween(Main, {Size = UDim2.new(0, currentW, 0, currentH)}, 0.3)
    end
    playSfx("Click")
    saveConfig()
end)

local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false; saveConfig() end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

task.defer(loadConfig)
paintIdle()