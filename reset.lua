-- ============================================
-- CÓDIGO DEL USUARIO (INICIO)
-- ============================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LocalizationService = game:GetService("LocalizationService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer

-- // [2] CONFIGURATION //

local CONFIG = {

    Names = {
        ScreenGui = "AceFreeInstaReset",
        MainFrame = "Main",
        TitleBar = "TitleBar",
        Title = "Title",
        HideButton = "Hide",
        LockButton = "Lock",
        Body = "Body",
        ControlsRow = "ControlsRow",
        ChangeGuiButton = "ChangeGui",
        BindButton = "Bind",
        ResetButton = "InstaReset",
        BillboardGui = "AceInstaResetTag",
        TagPanel = "Panel",
        TagTitle = "TagTitle",
        TagSub = "TagSub"
    },

    Sizes = {
        MainFrame = UDim2.new(0, 310, 0, 174),
        TitleBar = UDim2.new(1, 0, 0, 54),
        HideButton = UDim2.new(0, 48, 0, 24),
        LockButton = UDim2.new(0, 28, 0, 24),
        Body = UDim2.new(1, 0, 1, -64),
        ControlsRow = UDim2.new(1, -32, 0, 30),
        ChangeGuiButton = UDim2.new(1, -88, 1, 0),
        BindButton = UDim2.new(0, 80, 1, 0),
        ResetButton = UDim2.new(1, -32, 0, 52),
        HeaderLine = UDim2.new(1, -32, 0, 1),
        BillboardGui = UDim2.new(3.9, 0, 1.15, 0),
        TagPanel = UDim2.new(1, 0, 1, 0),
        TagTitle = UDim2.new(0.94, 0, 0.46, 0),
        TagSub = UDim2.new(0.94, 0, 0.3, 0)
    },

    Positions = {
        MainFrame = UDim2.new(0.5, -155, 0.15, 0),
        Title = UDim2.new(0, 16, 0, 0),
        HideButton = UDim2.new(1, -64, 0.5, -12),
        LockButton = UDim2.new(1, -96, 0.5, -12),
        HeaderLine = UDim2.new(0, 16, 0, 54),
        Body = UDim2.new(0, 0, 0, 64),
        ControlsRow = UDim2.new(0, 16, 0, 0),
        ChangeGuiButton = UDim2.new(0, 0, 0, 0),
        BindButton = UDim2.new(1, -80, 0, 0),
        ResetButton = UDim2.new(0, 16, 0, 42),
        TagTitle = UDim2.new(0.03, 0, 0.08, 0),
        TagSub = UDim2.new(0.03, 0, 0.58, 0)
    },

    Colors = {
        MainFrame = Color3.fromRGB(255, 255, 255),
        MainFrameTransparency = 0,
        TitleBar = Color3.new(1, 1, 1),
        TitleText = Color3.fromRGB(255, 255, 255),
        TitleStroke = Color3.fromRGB(0, 0, 0),
        HideButton = Color3.fromRGB(0, 0, 0),
        HideButtonText = Color3.fromRGB(255, 255, 255),
        LockButton = Color3.fromRGB(0, 0, 0),
        LockButtonText = Color3.fromRGB(255, 255, 255),
        HeaderLine = Color3.fromRGB(255, 255, 255),
        ControlsRow = Color3.new(1, 1, 1),
        ChangeGuiButton = Color3.fromRGB(0, 0, 0),
        ChangeGuiText = Color3.fromRGB(255, 255, 255),
        BindButton = Color3.fromRGB(0, 0, 0),
        BindText = Color3.fromRGB(255, 255, 255),
        ResetButton = Color3.fromRGB(0, 0, 0),
        ResetText = Color3.fromRGB(255, 255, 255),
        ResetStroke = Color3.fromRGB(255, 255, 255),
        TagPanel = Color3.fromRGB(0, 0, 0),
        TagTitleText = Color3.fromRGB(255, 255, 255),
        TagSubText = Color3.fromRGB(255, 255, 255),
    },

    ThemeColors = {
        BLUE = {
            MainFrame = Color3.fromRGB(150, 195, 240),
            ResetButton = Color3.fromRGB(150, 195, 240),
            ResetText = Color3.fromRGB(0, 0, 0),
            ResetStroke = Color3.fromRGB(150, 195, 240),
            TitleText = Color3.fromRGB(150, 195, 240),
            TitleStroke = Color3.fromRGB(0, 0, 0),
            HeaderLine = Color3.fromRGB(255, 255, 255),
            TagPanel = Color3.fromRGB(0, 0, 0),
            TagTitleText = Color3.fromRGB(150, 195, 240),
            TagSubText = Color3.fromRGB(255, 255, 255),
            TagSubStroke = Color3.fromRGB(0, 0, 0),
            ImageLabel = "rbxassetid://78202480778397"
        },
        RED = {
            MainFrame = Color3.fromRGB(235, 20, 26),
            ResetButton = Color3.fromRGB(235, 20, 26),
            ResetText = Color3.fromRGB(0, 0, 0),
            ResetStroke = Color3.fromRGB(235, 20, 26),
            TitleText = Color3.fromRGB(235, 20, 26),
            TitleStroke = Color3.fromRGB(0, 0, 0),
            HeaderLine = Color3.fromRGB(255, 255, 255),
            TagPanel = Color3.fromRGB(0, 0, 0),
            TagTitleText = Color3.fromRGB(235, 20, 26),
            TagSubText = Color3.fromRGB(255, 255, 255),
            TagSubStroke = Color3.fromRGB(0, 0, 0),
            ImageLabel = "rbxassetid://100434137957726"
        },
        NONE = {
            MainFrame = Color3.fromRGB(255, 255, 255),
            ResetButton = Color3.fromRGB(0, 0, 0),
            ResetText = Color3.fromRGB(255, 255, 255),
            ResetStroke = Color3.fromRGB(255, 255, 255),
            TitleText = Color3.fromRGB(255, 255, 255),
            TitleStroke = Color3.fromRGB(0, 0, 0),
            HeaderLine = Color3.fromRGB(255, 255, 255),
            TagPanel = Color3.fromRGB(0, 0, 0),
            TagTitleText = Color3.fromRGB(255, 255, 255),
            TagSubText = Color3.fromRGB(255, 255, 255),
            TagSubStroke = Color3.fromRGB(0, 0, 0),
            ImageLabel = ""
        },
        BLACK = {
            MainFrame = Color3.fromRGB(245, 245, 245),
            ResetButton = Color3.fromRGB(245, 245, 245),
            ResetText = Color3.fromRGB(0, 0, 0),
            ResetStroke = Color3.fromRGB(245, 245, 245),
            TitleText = Color3.fromRGB(245, 245, 245),
            TitleStroke = Color3.fromRGB(0, 0, 0),
            HeaderLine = Color3.fromRGB(255, 255, 255),
            TagPanel = Color3.fromRGB(0, 0, 0),
            TagTitleText = Color3.fromRGB(245, 245, 245),
            TagSubText = Color3.fromRGB(255, 255, 255),
            TagSubStroke = Color3.fromRGB(0, 0, 0),
            ImageLabel = "rbxassetid://113906905812241"
        },
        PINK = {
            MainFrame = Color3.fromRGB(255, 20, 130),
            ResetButton = Color3.fromRGB(255, 20, 130),
            ResetText = Color3.fromRGB(0, 0, 0),
            ResetStroke = Color3.fromRGB(255, 20, 130),
            TitleText = Color3.fromRGB(255, 20, 130),
            TitleStroke = Color3.fromRGB(0, 0, 0),
            HeaderLine = Color3.fromRGB(255, 255, 255),
            TagPanel = Color3.fromRGB(0, 0, 0),
            TagTitleText = Color3.fromRGB(255, 20, 130),
            TagSubText = Color3.fromRGB(255, 255, 255),
            TagSubStroke = Color3.fromRGB(0, 0, 0),
            ImageLabel = "rbxassetid://115817911806608"
        }
    },

    DefaultTheme = "BLUE",
    BindKey = Enum.KeyCode.R,
    ResetCooldown = 0.5,
    IsLocked = false,
    IsVisible = true,
}

local ThemeNames = {"BLUE", "RED", "NONE", "BLACK", "PINK"}
local CurrentThemeIndex = 1

-- // [3] OBJECT REFERENCES //

local ScreenGui = nil
local MainFrame = nil
local TitleBar = nil
local TitleLabel = nil
local HideButton = nil
local LockButton = nil
local BodyFrame = nil
local ControlsRow = nil
local ChangeGuiButton = nil
local BindButton = nil
local ResetButton = nil
local HeaderLine = nil
local BackgroundImage = nil
local UICornerMain = nil
local UIGradientMain = nil
local UIStrokeMain = nil
local UIScaleMain = nil
local BillboardGui = nil
local TagPanel = nil
local TagTitle = nil
local TagSub = nil

local currentBindKey = CONFIG.BindKey
local resetCooldown = false
local themeTable = CONFIG.ThemeColors[CONFIG.DefaultTheme]

-- // [4] UTILITY FUNCTIONS //

local function getCharacter()
    return LocalPlayer.Character
end

local function getHumanoid()
    local char = getCharacter()
    if char then
        return char:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

local function getHRP()
    local char = getCharacter()
    if char then
        return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
    end
    return nil
end

local function getHead()
    local char = getCharacter()
    if char then
        return char:FindFirstChild("Head")
    end
    return nil
end

local function applyTheme(themeName)
    local theme = CONFIG.ThemeColors[themeName]
    if not theme then return end

    MainFrame.BackgroundColor3 = theme.MainFrame
    MainFrame.BackgroundTransparency = 0

    TitleLabel.TextColor3 = theme.TitleText
    if TitleLabel:FindFirstChild("UIStroke") then
        TitleLabel.UIStroke.Color = theme.TitleStroke
    end

    ResetButton.BackgroundColor3 = theme.ResetButton
    ResetButton.TextColor3 = theme.ResetText
    if ResetButton:FindFirstChild("UIStroke") then
        ResetButton.UIStroke.Color = theme.ResetStroke
    end

    HeaderLine.BackgroundColor3 = theme.HeaderLine

    TagTitle.TextColor3 = theme.TagTitleText
    TagSub.TextColor3 = theme.TagSubText
    if TagPanel:FindFirstChild("UIStroke") then
        TagPanel.UIStroke.Color = theme.TagTitleText
    end

    if theme.ImageLabel and theme.ImageLabel ~= "" then
        BackgroundImage.Image = theme.ImageLabel
        BackgroundImage.ImageTransparency = 0.15
        BackgroundImage.Visible = true
    else
        BackgroundImage.Image = ""
        BackgroundImage.Visible = false
    end

    ChangeGuiButton.Text = "Color Theme: " .. themeName
end

local function cycleTheme()
    CurrentThemeIndex = CurrentThemeIndex % #ThemeNames + 1
    local themeName = ThemeNames[CurrentThemeIndex]
    applyTheme(themeName)
end

local function performReset()
    if resetCooldown then return end
    resetCooldown = true

    local origColor = ResetButton.BackgroundColor3
    local origTextColor = ResetButton.TextColor3
    ResetButton.BackgroundColor3 = themeTable.ResetButton
    ResetButton.TextColor3 = themeTable.ResetText
    ResetButton.BackgroundTransparency = 0
    ResetButton.TextStrokeTransparency = 1

    local char = getCharacter()
    if not char then
        resetCooldown = false
        ResetButton.Text = "INSTA RESET"
        ResetButton.BackgroundTransparency = 0
        ResetButton.TextStrokeTransparency = 0.6
        return
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = getHRP()
    if not hrp then
        resetCooldown = false
        ResetButton.Text = "INSTA RESET"
        ResetButton.BackgroundTransparency = 0
        ResetButton.TextStrokeTransparency = 0.6
        return
    end

    local cam = Workspace.CurrentCamera
    if cam then
        cam.CameraType = Enum.CameraType.Scriptable
        cam.CFrame = CFrame.new(-337.938599, -0.585044861, 106.739204, 0.133411571, -0.379638135, 0.915465117, 0, 0.923722506, 0.383062422, -0.991060734, -0.0511049591, 0.123235278)
        cam.Focus = CFrame.new(-349.381927, -5.37332535, 105.198761, 1, 0, 0, 0, 1, 0, 0, 0, 1)

        task.delay(0.1, function()
            if cam then
                cam.CameraType = Enum.CameraType.Custom
                cam.CameraSubject = hum
            end
        end)
    end

    if hum then
        hum.BreakJointsOnDeath = true
        hum.PlatformStand = true
        hum:ChangeState(Enum.HumanoidStateType.Physics)
    end

    hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    hrp.AssemblyLinearVelocity = Vector3.new(0, 1000000, 0)

    task.delay(CONFIG.ResetCooldown, function()
        resetCooldown = false
        ResetButton.Text = "INSTA RESET"
        ResetButton.BackgroundTransparency = 0
        ResetButton.TextStrokeTransparency = 0.6
        ResetButton.BackgroundColor3 = origColor
        ResetButton.TextColor3 = origTextColor
    end)
end

-- // [5] GUI CREATION //

local function createGUI()
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = CONFIG.Names.ScreenGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = CoreGui

    MainFrame = Instance.new("Frame")
    MainFrame.Name = CONFIG.Names.MainFrame
    MainFrame.Size = CONFIG.Sizes.MainFrame
    MainFrame.Position = CONFIG.Positions.MainFrame
    MainFrame.BackgroundColor3 = CONFIG.Colors.MainFrame
    MainFrame.BackgroundTransparency = 0
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    UICornerMain = Instance.new("UICorner")
    UICornerMain.CornerRadius = UDim.new(0, 16)
    UICornerMain.Parent = MainFrame

    UIGradientMain = Instance.new("UIGradient")
    UIGradientMain.Rotation = 90
    UIGradientMain.Parent = MainFrame

    UIStrokeMain = Instance.new("UIStroke")
    UIStrokeMain.Color = CONFIG.Colors.TitleStroke
    UIStrokeMain.Thickness = 3
    UIStrokeMain.Transparency = 0
    UIStrokeMain.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStrokeMain.Parent = MainFrame

    UIScaleMain = Instance.new("UIScale")
    UIScaleMain.Scale = 0.62
    UIScaleMain.Parent = MainFrame

    BackgroundImage = Instance.new("ImageLabel")
    BackgroundImage.Name = "Background"
    BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
    BackgroundImage.Position = UDim2.new(0, 0, 0, 0)
    BackgroundImage.BackgroundTransparency = 1
    BackgroundImage.BorderSizePixel = 0
    BackgroundImage.Image = ""
    BackgroundImage.ImageTransparency = 0.15
    BackgroundImage.ScaleType = Enum.ScaleType.Crop
    BackgroundImage.Visible = false
    BackgroundImage.ZIndex = 1
    BackgroundImage.Parent = MainFrame

    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 16)
    bgCorner.Parent = BackgroundImage

    TitleBar = Instance.new("Frame")
    TitleBar.Name = CONFIG.Names.TitleBar
    TitleBar.Size = CONFIG.Sizes.TitleBar
    TitleBar.BackgroundTransparency = 1
    TitleBar.BorderSizePixel = 0
    TitleBar.Active = true
    TitleBar.ZIndex = 3
    TitleBar.Parent = MainFrame

    TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = CONFIG.Names.Title
    TitleLabel.Size = UDim2.new(1, -120, 1, 0)
    TitleLabel.Position = CONFIG.Positions.Title
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "ACE INSTA RESET"
    TitleLabel.TextColor3 = CONFIG.Colors.TitleText
    TitleLabel.TextStrokeColor3 = CONFIG.Colors.TitleStroke
    TitleLabel.TextStrokeTransparency = 0.55
    TitleLabel.Font = Enum.Font.GothamBlack
    TitleLabel.TextSize = 19
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    TitleLabel.ZIndex = 4
    TitleLabel.Parent = TitleBar

    local titleStroke = Instance.new("UIStroke")
    titleStroke.Color = CONFIG.Colors.TitleStroke
    titleStroke.Thickness = 1.6
    titleStroke.Transparency = 0.35
    titleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    titleStroke.Parent = TitleLabel

    HideButton = Instance.new("TextButton")
    HideButton.Name = CONFIG.Names.HideButton
    HideButton.Size = CONFIG.Sizes.HideButton
    HideButton.Position = CONFIG.Positions.HideButton
    HideButton.BackgroundColor3 = CONFIG.Colors.HideButton
    HideButton.BackgroundTransparency = 0
    HideButton.BorderSizePixel = 0
    HideButton.AutoButtonColor = false
    HideButton.Text = "Hide"
    HideButton.TextColor3 = CONFIG.Colors.HideButtonText
    HideButton.TextStrokeTransparency = 1
    HideButton.Font = Enum.Font.GothamBold
    HideButton.TextSize = 12
    HideButton.ZIndex = 4
    HideButton.Parent = TitleBar

    local hideCorner = Instance.new("UICorner")
    hideCorner.CornerRadius = UDim.new(0, 8)
    hideCorner.Parent = HideButton

    LockButton = Instance.new("TextButton")
    LockButton.Name = CONFIG.Names.LockButton
    LockButton.Size = CONFIG.Sizes.LockButton
    LockButton.Position = CONFIG.Positions.LockButton
    LockButton.BackgroundColor3 = CONFIG.Colors.LockButton
    LockButton.BackgroundTransparency = 0
    LockButton.BorderSizePixel = 0
    LockButton.AutoButtonColor = false
    LockButton.Text = CONFIG.IsLocked and "🔒" or "🔓"
    LockButton.TextColor3 = CONFIG.Colors.LockButtonText
    LockButton.TextStrokeTransparency = 1
    LockButton.Font = Enum.Font.GothamBold
    LockButton.TextSize = 14
    LockButton.ZIndex = 4
    LockButton.Parent = TitleBar

    local lockCorner = Instance.new("UICorner")
    lockCorner.CornerRadius = UDim.new(0, 8)
    lockCorner.Parent = LockButton

    HeaderLine = Instance.new("Frame")
    HeaderLine.Name = "HeaderLine"
    HeaderLine.Size = CONFIG.Sizes.HeaderLine
    HeaderLine.Position = CONFIG.Positions.HeaderLine
    HeaderLine.BackgroundColor3 = CONFIG.Colors.HeaderLine
    HeaderLine.BackgroundTransparency = 0
    HeaderLine.BorderSizePixel = 0
    HeaderLine.ZIndex = 3
    HeaderLine.Parent = MainFrame

    BodyFrame = Instance.new("Frame")
    BodyFrame.Name = CONFIG.Names.Body
    BodyFrame.Size = CONFIG.Sizes.Body
    BodyFrame.Position = CONFIG.Positions.Body
    BodyFrame.BackgroundTransparency = 1
    BodyFrame.BorderSizePixel = 0
    BodyFrame.ZIndex = 3
    BodyFrame.Parent = MainFrame

    ControlsRow = Instance.new("Frame")
    ControlsRow.Name = CONFIG.Names.ControlsRow
    ControlsRow.Size = CONFIG.Sizes.ControlsRow
    ControlsRow.Position = CONFIG.Positions.ControlsRow
    ControlsRow.BackgroundTransparency = 1
    ControlsRow.BorderSizePixel = 0
    ControlsRow.ZIndex = 4
    ControlsRow.Parent = BodyFrame

    ChangeGuiButton = Instance.new("TextButton")
    ChangeGuiButton.Name = CONFIG.Names.ChangeGuiButton
    ChangeGuiButton.Size = CONFIG.Sizes.ChangeGuiButton
    ChangeGuiButton.Position = CONFIG.Positions.ChangeGuiButton
    ChangeGuiButton.BackgroundColor3 = CONFIG.Colors.ChangeGuiButton
    ChangeGuiButton.BackgroundTransparency = 0
    ChangeGuiButton.BorderSizePixel = 0
    ChangeGuiButton.AutoButtonColor = false
    ChangeGuiButton.Text = "Color Theme: " .. ThemeNames[CurrentThemeIndex]
    ChangeGuiButton.TextColor3 = CONFIG.Colors.ChangeGuiText
    ChangeGuiButton.TextStrokeTransparency = 1
    ChangeGuiButton.Font = Enum.Font.GothamBold
    ChangeGuiButton.TextSize = 12
    ChangeGuiButton.ZIndex = 5
    ChangeGuiButton.Parent = ControlsRow

    local changeCorner = Instance.new("UICorner")
    changeCorner.CornerRadius = UDim.new(0, 9)
    changeCorner.Parent = ChangeGuiButton

    BindButton = Instance.new("TextButton")
    BindButton.Name = CONFIG.Names.BindButton
    BindButton.Size = CONFIG.Sizes.BindButton
    BindButton.Position = CONFIG.Positions.BindButton
    BindButton.BackgroundColor3 = CONFIG.Colors.BindButton
    BindButton.BackgroundTransparency = 0
    BindButton.BorderSizePixel = 0
    BindButton.AutoButtonColor = false
    BindButton.Text = CONFIG.BindKey.Name
    BindButton.TextColor3 = CONFIG.Colors.BindText
    BindButton.TextStrokeTransparency = 1
    BindButton.Font = Enum.Font.GothamBold
    BindButton.TextSize = 12
    BindButton.TextTruncate = Enum.TextTruncate.AtEnd
    BindButton.ZIndex = 5
    BindButton.Parent = ControlsRow

    local bindCorner = Instance.new("UICorner")
    bindCorner.CornerRadius = UDim.new(0, 9)
    bindCorner.Parent = BindButton

    ResetButton = Instance.new("TextButton")
    ResetButton.Name = CONFIG.Names.ResetButton
    ResetButton.Size = CONFIG.Sizes.ResetButton
    ResetButton.Position = CONFIG.Positions.ResetButton
    ResetButton.BackgroundColor3 = CONFIG.Colors.ResetButton
    ResetButton.BackgroundTransparency = 0
    ResetButton.BorderSizePixel = 0
    ResetButton.AutoButtonColor = false
    ResetButton.Text = "INSTA RESET"
    ResetButton.TextColor3 = CONFIG.Colors.ResetText
    ResetButton.TextStrokeColor3 = CONFIG.Colors.TitleStroke
    ResetButton.TextStrokeTransparency = 0.6
    ResetButton.Font = Enum.Font.GothamBlack
    ResetButton.TextSize = 20
    ResetButton.ZIndex = 4
    ResetButton.Parent = BodyFrame

    local resetCorner = Instance.new("UICorner")
    resetCorner.CornerRadius = UDim.new(0, 12)
    resetCorner.Parent = ResetButton

    local resetStroke = Instance.new("UIStroke")
    resetStroke.Color = CONFIG.Colors.ResetStroke
    resetStroke.Thickness = 1.5
    resetStroke.Transparency = 0.6
    resetStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    resetStroke.Parent = ResetButton

    BillboardGui = Instance.new("BillboardGui")
    BillboardGui.Name = CONFIG.Names.BillboardGui
    BillboardGui.Size = CONFIG.Sizes.BillboardGui
    BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
    BillboardGui.AlwaysOnTop = true
    BillboardGui.ResetOnSpawn = false
    BillboardGui.LightInfluence = 0
    BillboardGui.MaxDistance = 250
    BillboardGui.Parent = CoreGui

    TagPanel = Instance.new("Frame")
    TagPanel.Name = CONFIG.Names.TagPanel
    TagPanel.Size = CONFIG.Sizes.TagPanel
    TagPanel.BackgroundColor3 = CONFIG.Colors.TagPanel
    TagPanel.BackgroundTransparency = 0
    TagPanel.BorderSizePixel = 0
    TagPanel.Parent = BillboardGui

    local tagCorner = Instance.new("UICorner")
    tagCorner.CornerRadius = UDim.new(0, 12)
    tagCorner.Parent = TagPanel

    local tagStroke = Instance.new("UIStroke")
    tagStroke.Color = CONFIG.Colors.TitleText
    tagStroke.Thickness = 1.6
    tagStroke.Transparency = 0.35
    tagStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    tagStroke.Parent = TagPanel

    TagTitle = Instance.new("TextLabel")
    TagTitle.Name = CONFIG.Names.TagTitle
    TagTitle.Size = CONFIG.Sizes.TagTitle
    TagTitle.Position = CONFIG.Positions.TagTitle
    TagTitle.BackgroundTransparency = 1
    TagTitle.Text = "INSTA RESET"
    TagTitle.TextColor3 = CONFIG.Colors.TagTitleText
    TagTitle.TextStrokeColor3 = CONFIG.Colors.TitleStroke
    TagTitle.TextStrokeTransparency = 0.4
    TagTitle.Font = Enum.Font.GothamBlack
    TagTitle.TextScaled = true
    TagTitle.Parent = TagPanel

    local tagTitleSize = Instance.new("UITextSizeConstraint")
    tagTitleSize.MaxTextSize = 18
    tagTitleSize.MinTextSize = 1
    tagTitleSize.Parent = TagTitle

    TagSub = Instance.new("TextLabel")
    TagSub.Name = CONFIG.Names.TagSub
    TagSub.Size = CONFIG.Sizes.TagSub
    TagSub.Position = CONFIG.Positions.TagSub
    TagSub.BackgroundTransparency = 1
    TagSub.Text = "discord.gg/aceduels"
    TagSub.TextColor3 = CONFIG.Colors.TagSubText
    TagSub.TextStrokeColor3 = CONFIG.Colors.TitleStroke
    TagSub.TextStrokeTransparency = 0.5
    TagSub.Font = Enum.Font.GothamBold
    TagSub.TextScaled = true
    TagSub.Parent = TagPanel

    local tagSubSize = Instance.new("UITextSizeConstraint")
    tagSubSize.MaxTextSize = 12
    tagSubSize.MinTextSize = 1
    tagSubSize.Parent = TagSub

    local head = getHead()
    if head then
        BillboardGui.Adornee = head
    end

    applyTheme(ThemeNames[CurrentThemeIndex])
    CONFIG.IsLocked = false
    LockButton.Text = "🔓"
end

-- // [6] FUNCTIONALITY //

local function setupDrag()
    local dragging = false
    local dragOffset = Vector2.new()

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if not CONFIG.IsLocked then
                dragging = true
                local mousePos = input.Position
                local framePos = MainFrame.AbsolutePosition
                dragOffset = Vector2.new(mousePos.X - framePos.X, mousePos.Y - framePos.Y)
            end
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            if CONFIG.IsLocked then
                dragging = false
                return
            end
            local mousePos = input.Position
            local parent = MainFrame.Parent
            if parent then
                local parentAbsSize = parent.AbsoluteSize
                local newX = (mousePos.X - dragOffset.X) / parentAbsSize.X
                local newY = (mousePos.Y - dragOffset.Y) / parentAbsSize.Y
                MainFrame.Position = UDim2.new(newX, 0, newY, 0)
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local function setupEvents()
    HideButton.MouseButton1Click:Connect(function()
        CONFIG.IsVisible = not CONFIG.IsVisible
        -- Hide or show the body content, keeping the title bar, title label, hide button, and lock button fully visible and usable
        BodyFrame.Visible = CONFIG.IsVisible
        HeaderLine.Visible = CONFIG.IsVisible
        HideButton.Text = CONFIG.IsVisible and "Hide" or "Show"
        
        if CONFIG.IsVisible then
            MainFrame.Size = CONFIG.Sizes.MainFrame
        else
            -- Shrink the MainFrame down so only the title bar remains visible
            MainFrame.Size = UDim2.new(0, 310, 0, 54)
        end
    end)

    LockButton.MouseButton1Click:Connect(function()
        CONFIG.IsLocked = not CONFIG.IsLocked
        LockButton.Text = CONFIG.IsLocked and "🔒" or "🔓"
    end)

    ChangeGuiButton.MouseButton1Click:Connect(function()
        cycleTheme()
    end)

    BindButton.MouseButton1Click:Connect(function()
        BindButton.Text = "..."
        BindButton.TextColor3 = CONFIG.Colors.BindText
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                currentBindKey = input.KeyCode
                BindButton.Text = input.KeyCode.Name
                CONFIG.BindKey = input.KeyCode
                connection:Disconnect()
            end
        end)
        task.delay(5, function()
            if connection and connection.Connected then
                connection:Disconnect()
                BindButton.Text = currentBindKey.Name
            end
        end)
    end)

    ResetButton.MouseButton1Click:Connect(function()
        performReset()
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentBindKey then
            performReset()
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function(char)
        local head = char:FindFirstChild("Head")
        if head and BillboardGui then
            BillboardGui.Adornee = head
        end
    end)

    local head = getHead()
    if head and BillboardGui then
        BillboardGui.Adornee = head
    end
end

-- // [7] INITIALIZATION //
createGUI()
setupDrag()
setupEvents()

ResetButton.Text = "INSTA RESET"
ResetButton.BackgroundTransparency = 0
ResetButton.TextStrokeTransparency = 0.6
-- ============================================
-- CÓDIGO DEL USUARIO (FIN)
-- ============================================