local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local NetworkClient = game:GetService("NetworkClient")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local existing = CoreGui:FindFirstChild("fa4e7xxspeedbypass")
if existing then existing:Destroy() end

local ConfigFolder = "Fa4e7xx"
local ConfigFile = ConfigFolder .. "/speed_bypass_config.json"
local Config = { 
    Keybind = "V",
    ControllerKeybind = "ButtonR2",
    PCPower = 97000,
    MobilePower = 72000,
    Mode = "PC",

local function EnsureConfigFolder()
    if makefolder and isfolder then
        pcall(function()
            if not isfolder(ConfigFolder) then
                makefolder(ConfigFolder)
            end
        end)
    end
end

local function SaveConfig()
    if not (writefile and HttpService) then
        return false
    end

    EnsureConfigFolder()

    local payload = {
        Keybind = tostring(Config.Keybind or "V"),
        ControllerKeybind = tostring(Config.ControllerKeybind or "ButtonR2"),
        PCPower = tonumber(Config.PCPower) or 97000,
        MobilePower = tonumber(Config.MobilePower) or 72000,
        Mode = (Config.Mode == "Mobile") and "Mobile" or "PC"

    local ok = pcall(function()
        writefile(ConfigFile, HttpService:JSONEncode(payload))
    end)

    return ok
end

local function LoadConfig()
    if not (readfile and isfile and HttpService) then
        return false
    end

    EnsureConfigFolder()

    local exists = false
    pcall(function()
        exists = isfile(ConfigFile)
    end)

    if not exists then return false end

    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(readfile(ConfigFile))
    end)

    if not ok or type(decoded) ~= "table" then return false end

    if type(decoded.Keybind) == "string" and decoded.Keybind ~= "" then
        Config.Keybind = decoded.Keybind
    end
    if type(decoded.ControllerKeybind) == "string" and decoded.ControllerKeybind ~= "" then
        Config.ControllerKeybind = decoded.ControllerKeybind
    end
    if type(decoded.PCPower) == "number" then
        Config.PCPower = math.clamp(decoded.PCPower, 10000, 150000)
    end
    if type(decoded.MobilePower) == "number" then
        Config.MobilePower = math.clamp(decoded.MobilePower, 10000, 100000)
    end
    if decoded.Mode == "PC" or decoded.Mode == "Mobile" then
        Config.Mode = decoded.Mode
    end

    return true
end

LoadConfig()

local DEPTH = 296

local function buildBomb(power)
    local maintable = {}
    local spammedtable = {}
    table.insert(spammedtable, {})
    local z = spammedtable[1]
    for i = 1, DEPTH do
        local tableins = {}
        table.insert(z, tableins)
        z = tableins
    end
    local maxRep = math.floor(power / (DEPTH + 2))
    for i = 1, maxRep do
        table.insert(maintable, spammedtable)
    end
    return maintable
end

local running = false
local bomb = nil
local spamThread = nil
local currentMode = Config.Mode
local SPAM_DELAY = 0.12

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "fa4e7xxspeedbypass"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 13, 9)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Position = UDim2.new(0, 12, 1, -224)
MainFrame.Size = UDim2.new(0, 195, 0, 200)
MainFrame.Active = true
MainFrame.ClipsDescendants = true
local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 18)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(35, 145, 255)
MainStroke.Thickness = 1.2

local BackgroundImage = Instance.new("ImageLabel", MainFrame)
BackgroundImage.Name = "BackgroundImage"
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.Position = UDim2.new(0, 0, 0, 0)
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.Image = "rbxassetid://139366202171973"
BackgroundImage.ImageTransparency = 0.15
BackgroundImage.ScaleType = Enum.ScaleType.Crop
BackgroundImage.ZIndex = 0
local BgImageCorner = Instance.new("UICorner", BackgroundImage)
BgImageCorner.CornerRadius = UDim.new(0, 18)

local ImageOverlay = Instance.new("Frame", MainFrame)
ImageOverlay.Size = UDim2.new(1, 0, 1, 0)
ImageOverlay.BackgroundColor3 = Color3.fromRGB(5, 12, 22)
ImageOverlay.BackgroundTransparency = 0.55
ImageOverlay.BorderSizePixel = 0
ImageOverlay.ZIndex = 1
local OverlayCorner = Instance.new("UICorner", ImageOverlay)
OverlayCorner.CornerRadius = UDim.new(0, 18)

local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.BackgroundTransparency = 1
Header.Size = UDim2.new(1, 0, 0, 46)
Header.ZIndex = 2
Header.Active = true

local Title = Instance.new("TextLabel", Header)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Font = Enum.Font.GothamBlack
Title.Text = "Fa4e7xx Speed Bypass"
Title.TextColor3 = Color3.fromRGB(45, 155, 255)
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.ZIndex = 3

local ContentFrame = Instance.new("Frame")
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 9, 0, 49)
ContentFrame.Size = UDim2.new(1, -18, 1, -49)
ContentFrame.ZIndex = 2
ContentFrame.Active = true

local Container = Instance.new("Frame")
Container.Parent = ContentFrame
Container.BackgroundTransparency = 1
Container.Size = UDim2.new(1, 0, 1, 0)
Container.Active = true
Container.ZIndex = 2

local UIList = Instance.new("UIListLayout", Container)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 3)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.VerticalAlignment = Enum.VerticalAlignment.Top

local function bindClick(button, callback)
    if not button then return end
    button.Active = true
    button.Selectable = true

    local lastClick = 0
    local function fire()
        local now = tick()
        if now - lastClick < 0.2 then return end
        lastClick = now
        callback()
    end

    button.MouseButton1Click:Connect(fire)
    button.Activated:Connect(fire)
end

local function AddHoverEffect(button)
    if not button or not button:IsA("GuiButton") then return end

    local original = button.BackgroundColor3
    local originalTransparency = button.BackgroundTransparency
    local hoverColor = Color3.fromRGB(20, 125, 255)

    button.AutoButtonColor = false
    button.Active = true
    button.Selectable = true

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.16), {
            BackgroundColor3 = hoverColor,
            BackgroundTransparency = math.max(0, originalTransparency - 0.08)
        }):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.20), {
            BackgroundColor3 = original,
            BackgroundTransparency = originalTransparency
        }):Play()
    end)
end

local ModeSelector = Instance.new("Frame", Container)
ModeSelector.Size = UDim2.new(1, 0, 0, 33)
ModeSelector.BackgroundTransparency = 1
ModeSelector.Active = true
ModeSelector.ZIndex = 2

local PCModeBtn = Instance.new("TextButton", ModeSelector)
PCModeBtn.Size = UDim2.new(0.48, 0, 1, 0)
PCModeBtn.Position = UDim2.new(0, 0, 0, 0)
PCModeBtn.BackgroundColor3 = Color3.fromRGB(15, 25, 38)
PCModeBtn.BackgroundTransparency = 0.05
PCModeBtn.Font = Enum.Font.GothamBold
PCModeBtn.Text = "PC"
PCModeBtn.TextSize = 11
PCModeBtn.TextColor3 = Color3.fromRGB(200, 230, 255)
PCModeBtn.AutoButtonColor = false
PCModeBtn.Active = true
PCModeBtn.Selectable = true
PCModeBtn.ZIndex = 3
local PCModeCorner = Instance.new("UICorner", PCModeBtn)
PCModeCorner.CornerRadius = UDim.new(0, 10)
local PCModeStroke = Instance.new("UIStroke", PCModeBtn)
PCModeStroke.Color = Color3.fromRGB(20, 125, 255)
PCModeStroke.Thickness = 1.2

local MobileModeBtn = Instance.new("TextButton", ModeSelector)
MobileModeBtn.Size = UDim2.new(0.48, 0, 1, 0)
MobileModeBtn.Position = UDim2.new(0.52, 0, 0, 0)
MobileModeBtn.BackgroundColor3 = Color3.fromRGB(15, 25, 38)
MobileModeBtn.BackgroundTransparency = 0.05
MobileModeBtn.Font = Enum.Font.GothamBold
MobileModeBtn.Text = "MOBILE"
MobileModeBtn.TextSize = 11
MobileModeBtn.TextColor3 = Color3.fromRGB(200, 230, 255)
MobileModeBtn.AutoButtonColor = false
MobileModeBtn.Active = true
MobileModeBtn.Selectable = true
MobileModeBtn.ZIndex = 3
local MobileModeCorner = Instance.new("UICorner", MobileModeBtn)
MobileModeCorner.CornerRadius = UDim.new(0, 10)
local MobileModeStroke = Instance.new("UIStroke", MobileModeBtn)
MobileModeStroke.Color = Color3.fromRGB(35, 70, 110)
MobileModeStroke.Thickness = 1.2

local PCElements = Instance.new("Frame", Container)
PCElements.Size = UDim2.new(1, 0, 0, 0)
PCElements.AutomaticSize = Enum.AutomaticSize.Y
PCElements.BackgroundTransparency = 1
PCElements.Visible = true
PCElements.Active = true
PCElements.ZIndex = 2

local PCUIList = Instance.new("UIListLayout", PCElements)
PCUIList.SortOrder = Enum.SortOrder.LayoutOrder
PCUIList.Padding = UDim.new(0, 7)

local PCCard = Instance.new("Frame", PCElements)
PCCard.Size = UDim2.new(1, 0, 0, 39)
PCCard.BackgroundColor3 = Color3.fromRGB(11, 20, 32)
PCCard.BackgroundTransparency = 0.25
PCCard.ZIndex = 3
local PCCardCorner = Instance.new("UICorner", PCCard)
PCCardCorner.CornerRadius = UDim.new(0, 12)
local PCCardStroke = Instance.new("UIStroke", PCCard)
PCCardStroke.Color = Color3.fromRGB(25, 80, 145)
PCCardStroke.Thickness = 0.3

local PCToggleBtn = Instance.new("TextButton", PCCard)
PCToggleBtn.Size = UDim2.new(1, -18, 1, -8)
PCToggleBtn.Position = UDim2.new(0, 9, 0, 4)
PCToggleBtn.BackgroundColor3 = Color3.fromRGB(14, 25, 40)
PCToggleBtn.BackgroundTransparency = 0.2
PCToggleBtn.Font = Enum.Font.GothamBold
PCToggleBtn.Text = "INACTIVE"
PCToggleBtn.TextColor3 = Color3.fromRGB(20, 135, 255)
PCToggleBtn.TextSize = 12
PCToggleBtn.AutoButtonColor = false
PCToggleBtn.Active = true
PCToggleBtn.Selectable = true
PCToggleBtn.ZIndex = 4
local PCToggleCorner = Instance.new("UICorner", PCToggleBtn)
PCToggleCorner.CornerRadius = UDim.new(0, 9)

local PCKeyCard = Instance.new("Frame", PCElements)
PCKeyCard.Size = UDim2.new(1, 0, 0, 31)
PCKeyCard.BackgroundColor3 = Color3.fromRGB(11, 20, 32)
PCKeyCard.BackgroundTransparency = 0.25
PCKeyCard.ZIndex = 3
local PCKeyCorner = Instance.new("UICorner", PCKeyCard)
PCKeyCorner.CornerRadius = UDim.new(0, 12)
local PCKeyStroke = Instance.new("UIStroke", PCKeyCard)
PCKeyStroke.Color = Color3.fromRGB(25, 80, 145)
PCKeyStroke.Thickness = 0.3

local PCKeyLabel = Instance.new("TextLabel", PCKeyCard)
PCKeyLabel.Size = UDim2.new(0.5, -9, 1, 0)
PCKeyLabel.Position = UDim2.new(0, 9, 0, 0)
PCKeyLabel.BackgroundTransparency = 1
PCKeyLabel.Font = Enum.Font.Gotham
PCKeyLabel.Text = "Keybind"
PCKeyLabel.TextColor3 = Color3.fromRGB(35, 145, 255)
PCKeyLabel.TextSize = 10
PCKeyLabel.TextXAlignment = Enum.TextXAlignment.Left
PCKeyLabel.ZIndex = 4

local PCKeybindBtn = Instance.new("TextButton", PCKeyCard)
PCKeybindBtn.Position = UDim2.new(0.65, 0, 0.5, -9)
PCKeybindBtn.Size = UDim2.new(0, 52, 0, 18)
PCKeybindBtn.BackgroundColor3 = Color3.fromRGB(15, 25, 38)
PCKeybindBtn.BackgroundTransparency = 0.2
PCKeybindBtn.Font = Enum.Font.GothamBold
PCKeybindBtn.Text = Config.Keybind
PCKeybindBtn.TextColor3 = Color3.fromRGB(200, 230, 255)
PCKeybindBtn.TextSize = 10
PCKeybindBtn.Active = true
PCKeybindBtn.Selectable = true
PCKeybindBtn.ZIndex = 4
local PCKeyCornerBtn = Instance.new("UICorner", PCKeybindBtn)
PCKeyCornerBtn.CornerRadius = UDim.new(0, 7)

local PCPowerCard = Instance.new("Frame", PCElements)
PCPowerCard.Size = UDim2.new(1, 0, 0, 31)
PCPowerCard.BackgroundColor3 = Color3.fromRGB(11, 20, 32)
PCPowerCard.BackgroundTransparency = 0.25
PCPowerCard.ZIndex = 3
local PCPowerCorner = Instance.new("UICorner", PCPowerCard)
PCPowerCorner.CornerRadius = UDim.new(0, 12)
local PCPowerStroke = Instance.new("UIStroke", PCPowerCard)
PCPowerStroke.Color = Color3.fromRGB(25, 80, 145)
PCPowerStroke.Thickness = 0.3

local PCPowerLabel = Instance.new("TextLabel", PCPowerCard)
PCPowerLabel.Size = UDim2.new(0.5, -9, 1, 0)
PCPowerLabel.Position = UDim2.new(0, 9, 0, 0)
PCPowerLabel.BackgroundTransparency = 1
PCPowerLabel.Font = Enum.Font.Gotham
PCPowerLabel.Text = "Power"
PCPowerLabel.TextColor3 = Color3.fromRGB(35, 145, 255)
PCPowerLabel.TextSize = 10
PCPowerLabel.TextXAlignment = Enum.TextXAlignment.Left
PCPowerLabel.ZIndex = 4

local PCPowerInput = Instance.new("TextBox", PCPowerCard)
PCPowerInput.Position = UDim2.new(0.65, 0, 0.5, -9)
PCPowerInput.Size = UDim2.new(0, 60, 0, 18)
PCPowerInput.BackgroundColor3 = Color3.fromRGB(15, 25, 38)
PCPowerInput.BackgroundTransparency = 0.2
PCPowerInput.Font = Enum.Font.GothamBold
PCPowerInput.Text = tostring(Config.PCPower)
PCPowerInput.TextColor3 = Color3.fromRGB(200, 230, 255)
PCPowerInput.TextSize = 9
PCPowerInput.ClearTextOnFocus = false
PCPowerInput.Active = true
PCPowerInput.Selectable = true
PCPowerInput.TextEditable = true
PCPowerInput.ZIndex = 4
local PCPowerInputCorner = Instance.new("UICorner", PCPowerInput)
PCPowerInputCorner.CornerRadius = UDim.new(0, 7)

local MobileElements = Instance.new("Frame", Container)
MobileElements.Size = UDim2.new(1, 0, 0, 0)
MobileElements.AutomaticSize = Enum.AutomaticSize.Y
MobileElements.BackgroundTransparency = 1
MobileElements.Visible = false
MobileElements.Active = true
MobileElements.ZIndex = 2

local MobileUIList = Instance.new("UIListLayout", MobileElements)
MobileUIList.SortOrder = Enum.SortOrder.LayoutOrder
MobileUIList.Padding = UDim.new(0, 7)

local MobileCard = Instance.new("Frame", MobileElements)
MobileCard.Size = UDim2.new(1, 0, 0, 39)
MobileCard.BackgroundColor3 = Color3.fromRGB(11, 20, 32)
MobileCard.BackgroundTransparency = 0.25
MobileCard.ZIndex = 3
local MobileCardCorner = Instance.new("UICorner", MobileCard)
MobileCardCorner.CornerRadius = UDim.new(0, 12)

local MobileToggleBtn = Instance.new("TextButton", MobileCard)
MobileToggleBtn.Size = UDim2.new(1, -18, 1, -8)
MobileToggleBtn.Position = UDim2.new(0, 9, 0, 4)
MobileToggleBtn.BackgroundColor3 = Color3.fromRGB(14, 25, 40)
MobileToggleBtn.BackgroundTransparency = 0.2
MobileToggleBtn.Font = Enum.Font.GothamBold
MobileToggleBtn.Text = "INACTIVE"
MobileToggleBtn.TextColor3 = Color3.fromRGB(20, 135, 255)
MobileToggleBtn.TextSize = 12
MobileToggleBtn.AutoButtonColor = false
MobileToggleBtn.Active = true
MobileToggleBtn.Selectable = true
MobileToggleBtn.ZIndex = 4
local MobileToggleCorner = Instance.new("UICorner", MobileToggleBtn)
MobileToggleCorner.CornerRadius = UDim.new(0, 9)

local MobilePowerCard = Instance.new("Frame", MobileElements)
MobilePowerCard.Size = UDim2.new(1, 0, 0, 31)
MobilePowerCard.BackgroundColor3 = Color3.fromRGB(11, 20, 32)
MobilePowerCard.BackgroundTransparency = 0.25
MobilePowerCard.ZIndex = 3
local MobilePowerCorner = Instance.new("UICorner", MobilePowerCard)
MobilePowerCorner.CornerRadius = UDim.new(0, 12)

local MobilePowerLabel = Instance.new("TextLabel", MobilePowerCard)
MobilePowerLabel.Size = UDim2.new(0.5, -9, 1, 0)
MobilePowerLabel.Position = UDim2.new(0, 9, 0, 0)
MobilePowerLabel.BackgroundTransparency = 1
MobilePowerLabel.Font = Enum.Font.Gotham
MobilePowerLabel.Text = "Power"
MobilePowerLabel.TextColor3 = Color3.fromRGB(35, 145, 255)
MobilePowerLabel.TextSize = 10
MobilePowerLabel.TextXAlignment = Enum.TextXAlignment.Left
MobilePowerLabel.ZIndex = 4

local MobilePowerInput = Instance.new("TextBox", MobilePowerCard)
MobilePowerInput.Position = UDim2.new(0.65, 0, 0.5, -9)
MobilePowerInput.Size = UDim2.new(0, 60, 0, 18)
MobilePowerInput.BackgroundColor3 = Color3.fromRGB(15, 25, 38)
MobilePowerInput.BackgroundTransparency = 0.2
MobilePowerInput.Font = Enum.Font.GothamBold
MobilePowerInput.Text = tostring(Config.MobilePower)
MobilePowerInput.TextColor3 = Color3.fromRGB(200, 230, 255)
MobilePowerInput.TextSize = 9
MobilePowerInput.ClearTextOnFocus = false
MobilePowerInput.Active = true
MobilePowerInput.Selectable = true
MobilePowerInput.TextEditable = true
MobilePowerInput.ZIndex = 4
local MobilePowerInputCorner = Instance.new("UICorner", MobilePowerInput)
MobilePowerInputCorner.CornerRadius = UDim.new(0, 7)

local MobileControllerCard = Instance.new("Frame", MobileElements)
MobileControllerCard.Size = UDim2.new(1, 0, 0, 31)
MobileControllerCard.BackgroundColor3 = Color3.fromRGB(11, 20, 32)
MobileControllerCard.BackgroundTransparency = 0.25
MobileControllerCard.ZIndex = 3
local MobileControllerCorner = Instance.new("UICorner", MobileControllerCard)
MobileControllerCorner.CornerRadius = UDim.new(0, 12)
local MobileControllerStroke = Instance.new("UIStroke", MobileControllerCard)
MobileControllerStroke.Color = Color3.fromRGB(25, 80, 145)
MobileControllerStroke.Thickness = 0.3

local MobileControllerLabel = Instance.new("TextLabel", MobileControllerCard)
MobileControllerLabel.Size = UDim2.new(0.5, -9, 1, 0)
MobileControllerLabel.Position = UDim2.new(0, 9, 0, 0)
MobileControllerLabel.BackgroundTransparency = 1
MobileControllerLabel.Font = Enum.Font.Gotham
MobileControllerLabel.Text = "Controller Keybind"
MobileControllerLabel.TextColor3 = Color3.fromRGB(35, 145, 255)
MobileControllerLabel.TextSize = 10
MobileControllerLabel.TextXAlignment = Enum.TextXAlignment.Left
MobileControllerLabel.ZIndex = 4

local MobileControllerKeybindBtn = Instance.new("TextButton", MobileControllerCard)
MobileControllerKeybindBtn.Position = UDim2.new(0.65, 0, 0.5, -9)
MobileControllerKeybindBtn.Size = UDim2.new(0, 60, 0, 18)
MobileControllerKeybindBtn.BackgroundColor3 = Color3.fromRGB(15, 25, 38)
MobileControllerKeybindBtn.BackgroundTransparency = 0.2
MobileControllerKeybindBtn.Font = Enum.Font.GothamBold
MobileControllerKeybindBtn.Text = Config.ControllerKeybind or "R2"
MobileControllerKeybindBtn.TextColor3 = Color3.fromRGB(200, 230, 255)
MobileControllerKeybindBtn.TextSize = 9
MobileControllerKeybindBtn.AutoButtonColor = false
MobileControllerKeybindBtn.Active = true
MobileControllerKeybindBtn.Selectable = true
MobileControllerKeybindBtn.ZIndex = 4
local MobileControllerKeyCorner = Instance.new("UICorner", MobileControllerKeybindBtn)
MobileControllerKeyCorner.CornerRadius = UDim.new(0, 7)

local DelayCard = Instance.new("Frame", Container)
DelayCard.Size = UDim2.new(1, 0, 0, 31)
DelayCard.BackgroundColor3 = Color3.fromRGB(11, 20, 32)
DelayCard.BackgroundTransparency = 0.25
DelayCard.ZIndex = 3
local DelayCorner = Instance.new("UICorner", DelayCard)
DelayCorner.CornerRadius = UDim.new(0, 12)
local DelayStroke = Instance.new("UIStroke", DelayCard)
DelayStroke.Color = Color3.fromRGB(25, 80, 145)
DelayStroke.Thickness = 0.3

local DelayLabel = Instance.new("TextLabel", DelayCard)
DelayLabel.Size = UDim2.new(0.5, -9, 1, 0)
DelayLabel.Position = UDim2.new(0, 9, 0, 0)
DelayLabel.BackgroundTransparency = 1
DelayLabel.Font = Enum.Font.Gotham
DelayLabel.Text = "Spam Delay"
DelayLabel.TextColor3 = Color3.fromRGB(35, 145, 255)
DelayLabel.TextSize = 10
DelayLabel.TextXAlignment = Enum.TextXAlignment.Left
DelayLabel.ZIndex = 4

local DelayInput = Instance.new("TextBox", DelayCard)
DelayInput.Position = UDim2.new(0.65, 0, 0.5, -9)
DelayInput.Size = UDim2.new(0, 60, 0, 18)
DelayInput.BackgroundColor3 = Color3.fromRGB(15, 25, 38)
DelayInput.BackgroundTransparency = 0.2
DelayInput.Font = Enum.Font.GothamBold
DelayInput.Text = tostring(SPAM_DELAY)
DelayInput.TextColor3 = Color3.fromRGB(200, 230, 255)
DelayInput.TextSize = 9
DelayInput.ClearTextOnFocus = false
DelayInput.Active = true
DelayInput.Selectable = true
DelayInput.TextEditable = true
DelayInput.ZIndex = 4
local DelayInputCorner = Instance.new("UICorner", DelayInput)
DelayInputCorner.CornerRadius = UDim.new(0, 7)

local function getCurrentPower()
    return currentMode == "PC" and Config.PCPower or Config.MobilePower
end

local function restartSpamLoop()
    if running then
        if spamThread then task.cancel(spamThread) end
        local power = getCurrentPower()
        bomb = buildBomb(power)
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
end

local function updateToggleVisuals(enabled)
    if currentMode == "PC" then
        if enabled then
            PCToggleBtn.Text = "ACTIVE"
            PCToggleBtn.TextColor3 = Color3.fromRGB(180, 255, 180)
            PCCardStroke.Color = Color3.fromRGB(35, 145, 255)
        else
            PCToggleBtn.Text = "INACTIVE"
            PCToggleBtn.TextColor3 = Color3.fromRGB(20, 135, 255)
            PCCardStroke.Color = Color3.fromRGB(25, 80, 145)
        end
    else
        if enabled then
            MobileToggleBtn.Text = "ON"
            MobileToggleBtn.TextColor3 = Color3.fromRGB(180, 255, 180)
        else
            MobileToggleBtn.Text = "INACTIVE"
            MobileToggleBtn.TextColor3 = Color3.fromRGB(20, 135, 255)
        end
    end
end

local function TogglePCBypass()
    running = not running
    updateToggleVisuals(running)
    if running then
        NetworkClient:SetOutgoingKBPSLimit(math.huge)
        restartSpamLoop()
    else
        if spamThread then task.cancel(spamThread) end
        bomb = nil
        NetworkClient:SetOutgoingKBPSLimit(0)
    end
end

local function ToggleMobileBypass()
    running = not running
    updateToggleVisuals(running)
    if running then
        NetworkClient:SetOutgoingKBPSLimit(math.huge)
        restartSpamLoop()
    else
        if spamThread then task.cancel(spamThread) end
        bomb = nil
        NetworkClient:SetOutgoingKBPSLimit(0)
    end
end

bindClick(PCToggleBtn, function()
    if currentMode == "PC" then TogglePCBypass() end
end)
bindClick(MobileToggleBtn, function()
    if currentMode == "Mobile" then ToggleMobileBypass() end
end)

PCPowerInput.FocusLost:Connect(function()
    local n = tonumber(PCPowerInput.Text)
        local c = math.clamp(n, 10000, 150000)
        Config.PCPower = c
        PCPowerInput.Text = tostring(c)
    else
        Config.PCPower = 97000
        PCPowerInput.Text = "97000"
    end
    SaveConfig()
    if running and currentMode == "PC" then restartSpamLoop() end
end)

MobilePowerInput.FocusLost:Connect(function()
    local n = tonumber(MobilePowerInput.Text)
        local c = math.clamp(n, 10000, 100000)
        Config.MobilePower = c
        MobilePowerInput.Text = tostring(c)
    else
        Config.MobilePower = 72000
        MobilePowerInput.Text = "72000"
    end
    SaveConfig()
    if running and currentMode == "Mobile" then restartSpamLoop() end
end)

DelayInput.FocusLost:Connect(function()
    local n = tonumber(DelayInput.Text)
        local c = math.clamp(n, 0.01, 5)
        SPAM_DELAY = c
        DelayInput.Text = tostring(c)
    else
        SPAM_DELAY = 0.12
        DelayInput.Text = "0.12"
    end
    if running then restartSpamLoop() end
end)

local listeningForKey = false
bindClick(PCKeybindBtn, function()
    listeningForKey = true
    PCKeybindBtn.Text = "..."
    PCKeybindBtn.TextColor3 = Color3.fromRGB(55, 165, 255)
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if listeningForKey then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            Config.Keybind = input.KeyCode.Name
            PCKeybindBtn.Text = Config.Keybind
            PCKeybindBtn.TextColor3 = Color3.fromRGB(200, 230, 255)
            listeningForKey = false
            SaveConfig()
        end
    else
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == Config.Keybind then
            if currentMode == "PC" then TogglePCBypass() end
        end
    end
end)

local function SaveCurrentMode(mode)
    if mode ~= "PC" and mode ~= "Mobile" then return end
    currentMode = mode
    Config.Mode = mode
    SaveConfig()
end

local function updateModeVisuals()
    local selectedColor = Color3.fromRGB(20, 125, 255)
    local unselectedColor = Color3.fromRGB(15, 25, 38)
    local selectedText = Color3.fromRGB(255, 255, 255)
    local unselectedText = Color3.fromRGB(190, 220, 245)

    if currentMode == "PC" then
        PCElements.Visible = true
        MobileElements.Visible = false

        PCModeBtn.Text = "PC"
        PCModeBtn.BackgroundColor3 = selectedColor
        PCModeBtn.BackgroundTransparency = 0
        PCModeBtn.TextColor3 = selectedText
        PCModeBtn.Font = Enum.Font.GothamBlack

        MobileModeBtn.Text = "MOBILE"
        MobileModeBtn.BackgroundColor3 = unselectedColor
        MobileModeBtn.BackgroundTransparency = 0
        MobileModeBtn.TextColor3 = unselectedText
        MobileModeBtn.Font = Enum.Font.GothamBold

        PCModeStroke.Color = selectedColor
        PCModeStroke.Transparency = 0
        MobileModeStroke.Color = Color3.fromRGB(35, 70, 110)
        MobileModeStroke.Transparency = 0.25
    else
        PCElements.Visible = false
        MobileElements.Visible = true

        PCModeBtn.Text = "PC"
        PCModeBtn.BackgroundColor3 = unselectedColor
        PCModeBtn.BackgroundTransparency = 0
        PCModeBtn.TextColor3 = unselectedText
        PCModeBtn.Font = Enum.Font.GothamBold

        MobileModeBtn.Text = "MOBILE"
        MobileModeBtn.BackgroundColor3 = selectedColor
        MobileModeBtn.BackgroundTransparency = 0
        MobileModeBtn.TextColor3 = selectedText
        MobileModeBtn.Font = Enum.Font.GothamBlack

        PCModeStroke.Color = Color3.fromRGB(35, 70, 110)
        PCModeStroke.Transparency = 0.25
        MobileModeStroke.Color = selectedColor
        MobileModeStroke.Transparency = 0
    end
end

bindClick(PCModeBtn, function()
    if running then
        running = false
        if spamThread then task.cancel(spamThread) end
        bomb = nil
        NetworkClient:SetOutgoingKBPSLimit(0)
    end
    SaveCurrentMode("PC")
    updateModeVisuals()
end)

bindClick(MobileModeBtn, function()
    if running then
        running = false
        if spamThread then task.cancel(spamThread) end
        bomb = nil
        NetworkClient:SetOutgoingKBPSLimit(0)
    end
    SaveCurrentMode("Mobile")
    updateModeVisuals()
end)

local listeningForControllerKey = false

bindClick(MobileControllerKeybindBtn, function()
    listeningForControllerKey = true
    MobileControllerKeybindBtn.Text = "..."
    MobileControllerKeybindBtn.TextColor3 = Color3.fromRGB(55, 165, 255)
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end

    if listeningForControllerKey then
        local t = input.UserInputType
        if t == Enum.UserInputType.Gamepad1
            or t == Enum.UserInputType.Gamepad2
            or t == Enum.UserInputType.Gamepad3
            or t == Enum.UserInputType.Gamepad4
            or t == Enum.UserInputType.Gamepad5
            or t == Enum.UserInputType.Gamepad6
            or t == Enum.UserInputType.Gamepad7
            or t == Enum.UserInputType.Gamepad8 then

            Config.ControllerKeybind = input.KeyCode.Name
            MobileControllerKeybindBtn.Text = Config.ControllerKeybind
            MobileControllerKeybindBtn.TextColor3 = Color3.fromRGB(200, 230, 255)
            listeningForControllerKey = false
            SaveConfig()
        end
    else
        local t = input.UserInputType
        local isGamepad =
            t == Enum.UserInputType.Gamepad1
            or t == Enum.UserInputType.Gamepad2
            or t == Enum.UserInputType.Gamepad3
            or t == Enum.UserInputType.Gamepad4
            or t == Enum.UserInputType.Gamepad5
            or t == Enum.UserInputType.Gamepad6
            or t == Enum.UserInputType.Gamepad7
            or t == Enum.UserInputType.Gamepad8

        if currentMode == "Mobile"
            and isGamepad
            and input.KeyCode.Name == Config.ControllerKeybind then
            ToggleMobileBypass()
        end
    end
end)

local dragging = false
local dragStart = nil
local startPos = nil
local dragInput = nil

local function updateDrag(input)
    MainFrame.Position = UDim2.new(
end

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        dragInput = input

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                dragInput = nil
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateDrag(input)
    end
end)

local function AddCardHover(card)
    if not card then return end
    local stroke = card:FindFirstChildOfClass("UIStroke")
    local oldStroke = stroke and stroke.Color or Color3.fromRGB(20, 105, 210)

    card.MouseEnter:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.16), {BackgroundTransparency = 0.15}):Play()
        if stroke then
            TweenService:Create(stroke, TweenInfo.new(0.16), {
                Color = Color3.fromRGB(20, 125, 255),
                Transparency = 0.05
            }):Play()
        end
    end)

    card.MouseLeave:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.20), {BackgroundTransparency = 0.25}):Play()
        if stroke then
            TweenService:Create(stroke, TweenInfo.new(0.20), {
                Color = oldStroke,
                Transparency = 0.15
            }):Play()
        end
    end)
end

AddHoverEffect(PCToggleBtn)
AddHoverEffect(PCKeybindBtn)
AddHoverEffect(MobileToggleBtn)
AddHoverEffect(MobileControllerKeybindBtn)
AddCardHover(PCCard)
AddCardHover(PCKeyCard)
AddCardHover(PCPowerCard)
AddCardHover(MobileCard)
AddCardHover(MobilePowerCard)
AddCardHover(MobileControllerCard)
AddCardHover(DelayCard)

ScreenGui.Destroying:Connect(function()
    Config.Mode = currentMode
    SaveConfig()
end)

PCKeybindBtn.Text = Config.Keybind
PCPowerInput.Text = tostring(Config.PCPower)
MobilePowerInput.Text = tostring(Config.MobilePower)
MobileControllerKeybindBtn.Text = Config.ControllerKeybind or "ButtonR2"
PCToggleBtn.Text = "INACTIVE"
MobileToggleBtn.Text = "INACTIVE"
DelayInput.Text = tostring(SPAM_DELAY)

if Config.Mode == "Mobile" then
    currentMode = "Mobile"
else
    currentMode = "PC"
    Config.Mode = "PC"
end

updateModeVisuals()