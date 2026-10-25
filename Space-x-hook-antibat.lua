local SpaceXHookAntiBat = Instance.new("ScreenGui")
SpaceXHookAntiBat.Name = "Space X Hook Anti Bat"
SpaceXHookAntiBat.ResetOnSpawn = false
SpaceXHookAntiBat.DisplayOrder = 10
SpaceXHookAntiBat.IgnoreGuiInset = true
SpaceXHookAntiBat.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SpaceXHookAntiBat.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Active = true
Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Position = UDim2.new(0.5, -135, 0.5, -130)
Main.Size = UDim2.new(0, 270, 0, 260)
Main.Parent = SpaceXHookAntiBat

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = Main

local SpaceBackground = Instance.new("ImageLabel")
SpaceBackground.Name = "SpaceBackground"
SpaceBackground.BackgroundTransparency = 1
SpaceBackground.Size = UDim2.new(1, 0, 1, 0)
SpaceBackground.ZIndex = 0
SpaceBackground.Image = "rbxassetid://118100574986629"
SpaceBackground.ScaleType = Enum.ScaleType.Crop
SpaceBackground.Parent = Main

local UICorner_2 = Instance.new("UICorner")
UICorner_2.CornerRadius = UDim.new(0, 16)
UICorner_2.Parent = SpaceBackground

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Active = true
Header.BackgroundTransparency = 1
Header.Size = UDim2.new(1, 0, 0, 48)
Header.ZIndex = 2
Header.Parent = Main

local HeaderIcon = Instance.new("Frame")
HeaderIcon.Name = "HeaderIcon"
HeaderIcon.BackgroundColor3 = Color3.fromRGB(120, 120, 130)
HeaderIcon.BorderSizePixel = 0
HeaderIcon.Position = UDim2.new(0, 16, 0.5, -5)
HeaderIcon.Size = UDim2.new(0, 10, 0, 10)
HeaderIcon.ZIndex = 5
HeaderIcon.Parent = Header

local UICorner_3 = Instance.new("UICorner")
UICorner_3.CornerRadius = UDim.new(1, 0)
UICorner_3.Parent = HeaderIcon

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 36, 0, 6)
Title.Size = UDim2.new(1, -130, 0, 18)
Title.ZIndex = 5
Title.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
Title.Text = "Space X Hook Anti bat"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 11
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Name = "SubTitle"
SubTitle.BackgroundTransparency = 1
SubTitle.Position = UDim2.new(0, 36, 0, 26)
SubTitle.Size = UDim2.new(1, -130, 0, 14)
SubTitle.ZIndex = 5
SubTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
SubTitle.Text = "discord.gg/space-duels"
SubTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
SubTitle.TextSize = 10
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header

local BgBtn = Instance.new("TextButton")
BgBtn.Name = "BgBtn"
BgBtn.AnchorPoint = Vector2.new(1, 0.5)
BgBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
BgBtn.BackgroundTransparency = 0.15000000596046448
BgBtn.Position = UDim2.new(1, -60, 0.5, 0)
BgBtn.Size = UDim2.new(0, 42, 0, 22)
BgBtn.ZIndex = 5
BgBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
BgBtn.Text = "BG"
BgBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BgBtn.TextSize = 10
BgBtn.Parent = Header

local UICorner_4 = Instance.new("UICorner")
UICorner_4.CornerRadius = UDim.new(0, 6)
UICorner_4.Parent = BgBtn

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(120, 120, 130)
UIStroke.Transparency = 0.15000000596046448
UIStroke.Parent = BgBtn

local MinBtn = Instance.new("TextButton")
MinBtn.Name = "MinBtn"
MinBtn.AnchorPoint = Vector2.new(1, 0.5)
MinBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MinBtn.BackgroundTransparency = 0.5
MinBtn.Position = UDim2.new(1, -12, 0.5, 0)
MinBtn.Size = UDim2.new(0, 24, 0, 24)
MinBtn.ZIndex = 5
MinBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 16
MinBtn.Parent = Header

local UICorner_5 = Instance.new("UICorner")
UICorner_5.CornerRadius = UDim.new(0, 6)
UICorner_5.Parent = MinBtn

local ContentHolder = Instance.new("Frame")
ContentHolder.Name = "ContentHolder"
ContentHolder.BackgroundTransparency = 1
ContentHolder.ClipsDescendants = true
ContentHolder.Position = UDim2.new(0, 0, 0, 48)
ContentHolder.Size = UDim2.new(1, 0, 1, -48)
ContentHolder.ZIndex = 2
ContentHolder.Parent = Main

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.BackgroundTransparency = 1
Content.Size = UDim2.new(1, 0, 1, 0)
Content.ZIndex = 2
Content.Parent = ContentHolder

local StatusRow = Instance.new("Frame")
StatusRow.Name = "StatusRow"
StatusRow.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
StatusRow.BackgroundTransparency = 0.5
StatusRow.Position = UDim2.new(0, 12, 0, 6)
StatusRow.Size = UDim2.new(1, -24, 0, 32)
StatusRow.ZIndex = 4
StatusRow.Parent = Content

local UICorner_6 = Instance.new("UICorner")
UICorner_6.CornerRadius = UDim.new(0, 12)
UICorner_6.Parent = StatusRow

local StatusDot = Instance.new("Frame")
StatusDot.Name = "StatusDot"
StatusDot.BackgroundColor3 = Color3.fromRGB(80, 255, 100)
StatusDot.BorderSizePixel = 0
StatusDot.Position = UDim2.new(0, 14, 0.5, -4)
StatusDot.Size = UDim2.new(0, 8, 0, 8)
StatusDot.ZIndex = 6
StatusDot.Parent = StatusRow

local UICorner_7 = Instance.new("UICorner")
UICorner_7.CornerRadius = UDim.new(1, 0)
UICorner_7.Parent = StatusDot

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 30, 0, 0)
StatusLabel.Size = UDim2.new(0, 100, 1, 0)
StatusLabel.ZIndex = 6
StatusLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
StatusLabel.Text = "Status"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 13
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = StatusRow

local StatusValue = Instance.new("TextLabel")
StatusValue.Name = "StatusValue"
StatusValue.BackgroundTransparency = 1
StatusValue.Position = UDim2.new(1, -114, 0, 0)
StatusValue.Size = UDim2.new(0, 100, 1, 0)
StatusValue.ZIndex = 6
StatusValue.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
StatusValue.Text = "ACTIVE"
StatusValue.TextColor3 = Color3.fromRGB(80, 255, 100)
StatusValue.TextSize = 14
StatusValue.TextXAlignment = Enum.TextXAlignment.Right
StatusValue.Parent = StatusRow

local AntiBatRow = Instance.new("Frame")
AntiBatRow.Name = "AntiBatRow"
AntiBatRow.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
AntiBatRow.BackgroundTransparency = 0.5
AntiBatRow.Position = UDim2.new(0, 12, 0, 46)
AntiBatRow.Size = UDim2.new(1, -24, 0, 50)
AntiBatRow.ZIndex = 4
AntiBatRow.Parent = Content

local UICorner_8 = Instance.new("UICorner")
UICorner_8.CornerRadius = UDim.new(0, 12)
UICorner_8.Parent = AntiBatRow

local AntiBatLabel = Instance.new("TextLabel")
AntiBatLabel.Name = "AntiBatLabel"
AntiBatLabel.BackgroundTransparency = 1
AntiBatLabel.Position = UDim2.new(0, 14, 0.5, -8)
AntiBatLabel.Size = UDim2.new(0, 150, 0, 18)
AntiBatLabel.ZIndex = 6
AntiBatLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
AntiBatLabel.Text = "Anti Bat"
AntiBatLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiBatLabel.TextSize = 14
AntiBatLabel.TextXAlignment = Enum.TextXAlignment.Left
AntiBatLabel.Parent = AntiBatRow

local ToggleBg = Instance.new("Frame")
ToggleBg.Name = "ToggleBg"
ToggleBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleBg.BorderSizePixel = 0
ToggleBg.Position = UDim2.new(1, -58, 0.5, -11)
ToggleBg.Size = UDim2.new(0, 44, 0, 22)
ToggleBg.ZIndex = 6
ToggleBg.Parent = AntiBatRow

local UICorner_9 = Instance.new("UICorner")
UICorner_9.CornerRadius = UDim.new(1, 0)
UICorner_9.Parent = ToggleBg

local ToggleDot = Instance.new("Frame")
ToggleDot.Name = "ToggleDot"
ToggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleDot.BorderSizePixel = 0
ToggleDot.Position = UDim2.new(1, -19, 0.5, -8)
ToggleDot.Size = UDim2.new(0, 16, 0, 16)
ToggleDot.ZIndex = 7
ToggleDot.Parent = ToggleBg

local UICorner_10 = Instance.new("UICorner")
UICorner_10.CornerRadius = UDim.new(1, 0)
UICorner_10.Parent = ToggleDot

local AntiBatClick = Instance.new("TextButton")
AntiBatClick.Name = "AntiBatClick"
AntiBatClick.BackgroundTransparency = 1
AntiBatClick.Position = UDim2.new(1, -65, 0, 0)
AntiBatClick.Size = UDim2.new(0, 50, 0, 50)
AntiBatClick.ZIndex = 10
AntiBatClick.Text = ""
AntiBatClick.Parent = AntiBatRow

local InfJumpRow = Instance.new("Frame")
InfJumpRow.Name = "InfJumpRow"
InfJumpRow.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
InfJumpRow.BackgroundTransparency = 0.5
InfJumpRow.Position = UDim2.new(0, 12, 0, 104)
InfJumpRow.Size = UDim2.new(1, -24, 0, 50)
InfJumpRow.ZIndex = 4
InfJumpRow.Parent = Content

local UICorner_11 = Instance.new("UICorner")
UICorner_11.CornerRadius = UDim.new(0, 12)
UICorner_11.Parent = InfJumpRow

local InfJumpLabel = Instance.new("TextLabel")
InfJumpLabel.Name = "InfJumpLabel"
InfJumpLabel.BackgroundTransparency = 1
InfJumpLabel.Position = UDim2.new(0, 14, 0.5, -8)
InfJumpLabel.Size = UDim2.new(0, 150, 0, 18)
InfJumpLabel.ZIndex = 6
InfJumpLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
InfJumpLabel.Text = "Inf Jump"
InfJumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
InfJumpLabel.TextSize = 14
InfJumpLabel.TextXAlignment = Enum.TextXAlignment.Left
InfJumpLabel.Parent = InfJumpRow

local InfToggleBg = Instance.new("Frame")
InfToggleBg.Name = "InfToggleBg"
InfToggleBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
InfToggleBg.BorderSizePixel = 0
InfToggleBg.Position = UDim2.new(1, -58, 0.5, -11)
InfToggleBg.Size = UDim2.new(0, 44, 0, 22)
InfToggleBg.ZIndex = 6
InfToggleBg.Parent = InfJumpRow

local UICorner_12 = Instance.new("UICorner")
UICorner_12.CornerRadius = UDim.new(1, 0)
UICorner_12.Parent = InfToggleBg

local InfToggleDot = Instance.new("Frame")
InfToggleDot.Name = "InfToggleDot"
InfToggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
InfToggleDot.BorderSizePixel = 0
InfToggleDot.Position = UDim2.new(1, -19, 0.5, -8)
InfToggleDot.Size = UDim2.new(0, 16, 0, 16)
InfToggleDot.ZIndex = 7
InfToggleDot.Parent = InfToggleBg

local UICorner_13 = Instance.new("UICorner")
UICorner_13.CornerRadius = UDim.new(1, 0)
UICorner_13.Parent = InfToggleDot

local InfJumpClick = Instance.new("TextButton")
InfJumpClick.Name = "InfJumpClick"
InfJumpClick.BackgroundTransparency = 1
InfJumpClick.Position = UDim2.new(1, -65, 0, 0)
InfJumpClick.Size = UDim2.new(0, 50, 0, 50)
InfJumpClick.ZIndex = 10
InfJumpClick.Text = ""
InfJumpClick.Parent = InfJumpRow

local KeybindRow = Instance.new("Frame")
KeybindRow.Name = "KeybindRow"
KeybindRow.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
KeybindRow.BackgroundTransparency = 0.5
KeybindRow.Position = UDim2.new(0, 12, 0, 162)
KeybindRow.Size = UDim2.new(1, -24, 0, 32)
KeybindRow.ZIndex = 4
KeybindRow.Parent = Content

local UICorner_14 = Instance.new("UICorner")
UICorner_14.CornerRadius = UDim.new(0, 12)
UICorner_14.Parent = KeybindRow

local KeybindLabel = Instance.new("TextLabel")
KeybindLabel.Name = "KeybindLabel"
KeybindLabel.BackgroundTransparency = 1
KeybindLabel.Position = UDim2.new(0, 14, 0, 0)
KeybindLabel.Size = UDim2.new(0, 80, 1, 0)
KeybindLabel.ZIndex = 6
KeybindLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
KeybindLabel.Text = "Keybind"
KeybindLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
KeybindLabel.TextSize = 12
KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
KeybindLabel.Parent = KeybindRow

local KeybindBtn = Instance.new("TextButton")
KeybindBtn.Name = "KeybindBtn"
KeybindBtn.AnchorPoint = Vector2.new(1, 0.5)
KeybindBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
KeybindBtn.BackgroundTransparency = 0.5
KeybindBtn.Position = UDim2.new(1, -14, 0.5, 0)
KeybindBtn.Size = UDim2.new(0, 50, 0, 20)
KeybindBtn.ZIndex = 10
KeybindBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
KeybindBtn.Text = "M"
KeybindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KeybindBtn.TextSize = 12
KeybindBtn.Parent = KeybindRow

local UICorner_15 = Instance.new("UICorner")
UICorner_15.CornerRadius = UDim.new(0, 6)
UICorner_15.Parent = KeybindBtn

local BackgroundPicker = Instance.new("Frame")
BackgroundPicker.Name = "BackgroundPicker"
BackgroundPicker.AnchorPoint = Vector2.new(0.5, 0.5)
BackgroundPicker.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BackgroundPicker.BorderSizePixel = 0
BackgroundPicker.Position = UDim2.new(0.5, 0, 0.5, 0)
BackgroundPicker.Size = UDim2.new(0, 260, 0, 180)
BackgroundPicker.Visible = false
BackgroundPicker.ZIndex = 20
BackgroundPicker.Parent = SpaceXHookAntiBat

local UICorner_16 = Instance.new("UICorner")
UICorner_16.CornerRadius = UDim.new(0, 12)
UICorner_16.Parent = BackgroundPicker

local UIStroke_2 = Instance.new("UIStroke")
UIStroke_2.Color = Color3.fromRGB(110, 110, 120)
UIStroke_2.Thickness = 1.5
UIStroke_2.Transparency = 0.15000000596046448
UIStroke_2.Parent = BackgroundPicker

local Header_2 = Instance.new("Frame")
Header_2.Name = "Header"
Header_2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Header_2.BackgroundTransparency = 0.15000000596046448
Header_2.BorderSizePixel = 0
Header_2.Size = UDim2.new(1, 0, 0, 38)
Header_2.ZIndex = 21
Header_2.Parent = BackgroundPicker

local UICorner_17 = Instance.new("UICorner")
UICorner_17.CornerRadius = UDim.new(0, 12)
UICorner_17.Parent = Header_2

local TextLabel = Instance.new("TextLabel")
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0, 12, 0, 0)
TextLabel.Size = UDim2.new(1, -54, 1, 0)
TextLabel.ZIndex = 22
TextLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
TextLabel.Text = "Change Background"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 16
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Parent = Header_2

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.AnchorPoint = Vector2.new(1, 0.5)
Close.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Close.BackgroundTransparency = 0.10000000149011612
Close.Position = UDim2.new(1, -9, 0.5, 0)
Close.Size = UDim2.new(0, 28, 0, 25)
Close.ZIndex = 22
Close.AutoButtonColor = false
Close.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextSize = 18
Close.Parent = Header_2

local UICorner_18 = Instance.new("UICorner")
UICorner_18.CornerRadius = UDim.new(0, 7)
UICorner_18.Parent = Close

local BackgroundGrid = Instance.new("Frame")
BackgroundGrid.Name = "BackgroundGrid"
BackgroundGrid.BackgroundTransparency = 1
BackgroundGrid.Position = UDim2.new(0, 12, 0, 48)
BackgroundGrid.Size = UDim2.new(1, -24, 1, -60)
BackgroundGrid.ZIndex = 21
BackgroundGrid.Parent = BackgroundPicker

local UIGridLayout = Instance.new("UIGridLayout")
UIGridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
UIGridLayout.CellSize = UDim2.new(0, 72, 0, 72)
UIGridLayout.FillDirectionMaxCells = 3
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.Parent = BackgroundGrid

local Default = Instance.new("ImageButton")
Default.Name = "Default"
Default.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Default.BackgroundTransparency = 0.10000000149011612
Default.LayoutOrder = 1
Default.ZIndex = 22
Default.AutoButtonColor = false
Default.Image = "rbxassetid://118100574986629"
Default.ScaleType = Enum.ScaleType.Crop
Default.Parent = BackgroundGrid

local UICorner_19 = Instance.new("UICorner")
UICorner_19.CornerRadius = UDim.new(0, 10)
UICorner_19.Parent = Default

local UIStroke_3 = Instance.new("UIStroke")
UIStroke_3.Color = Color3.fromRGB(120, 120, 130)
UIStroke_3.Transparency = 0.10000000149011612
UIStroke_3.Parent = Default

local Space1 = Instance.new("ImageButton")
Space1.Name = "Space 1"
Space1.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Space1.BackgroundTransparency = 0.10000000149011612
Space1.LayoutOrder = 2
Space1.ZIndex = 22
Space1.AutoButtonColor = false
Space1.Image = "rbxassetid://76835310118322"
Space1.ScaleType = Enum.ScaleType.Crop
Space1.Parent = BackgroundGrid

local UICorner_20 = Instance.new("UICorner")
UICorner_20.CornerRadius = UDim.new(0, 10)
UICorner_20.Parent = Space1

local UIStroke_4 = Instance.new("UIStroke")
UIStroke_4.Color = Color3.fromRGB(120, 120, 130)
UIStroke_4.Transparency = 0.10000000149011612
UIStroke_4.Parent = Space1

local Space2 = Instance.new("ImageButton")
Space2.Name = "Space 2"
Space2.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Space2.BackgroundTransparency = 0.10000000149011612
Space2.LayoutOrder = 3
Space2.ZIndex = 22
Space2.AutoButtonColor = false
Space2.Image = "rbxassetid://114138477258742"
Space2.ScaleType = Enum.ScaleType.Crop
Space2.Parent = BackgroundGrid

local UICorner_21 = Instance.new("UICorner")
UICorner_21.CornerRadius = UDim.new(0, 10)
UICorner_21.Parent = Space2

local UIStroke_5 = Instance.new("UIStroke")
UIStroke_5.Color = Color3.fromRGB(120, 120, 130)
UIStroke_5.Transparency = 0.10000000149011612
UIStroke_5.Parent = Space2

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local antiBatConn   = nil
local antiBatActive = false
local infJumpConn   = nil
local infJumpActive = false
local forceJump     = false

local config = {
    Keybind = "M",
}

local GREEN     = Color3.fromRGB(80, 255, 100)
local RED        = Color3.fromRGB(255, 80, 80)
local GRAY_TRACK = Color3.fromRGB(40, 40, 40)
local TOGGLE_ON  = Color3.fromRGB(255, 255, 255)

local function enableAntiBat()
    if antiBatConn then return end
    antiBatActive = true
    antiBatConn = RunService.Heartbeat:Connect(function()
        if not antiBatActive then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local vel = hrp.Velocity
        local y = vel.Y
        hrp.Velocity = Vector3.new(math.random(-4000, 4000), y, math.random(-4000, 4000))
        RunService.RenderStepped:Wait()
        if hrp then
            hrp.Velocity = vel
        end
    end)
end

local function disableAntiBat()
    antiBatActive = false
    if antiBatConn then
        antiBatConn:Disconnect()
        antiBatConn = nil
    end
end

local function enableInfJump()
    if infJumpConn then return end
    infJumpActive = true
    infJumpConn = RunService.Heartbeat:Connect(function()
        if not infJumpActive then return end
        local char = LocalPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not humanoid or not hrp then return end
        if humanoid.Jump or forceJump then
            local vel = hrp.Velocity
            if vel.Y < 50 then
                hrp.Velocity = Vector3.new(vel.X, 50, vel.Z)
            end
        end
    end)
end

local function disableInfJump()
    infJumpActive = false
    if infJumpConn then
        infJumpConn:Disconnect()
        infJumpConn = nil
    end
end

local function onJumping()
    if infJumpActive then
        forceJump = true
        task.wait(0.1)
        forceJump = false
    end
end

local function hookCharacter(char)
    task.wait(0.5)
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Jumping:Connect(onJumping)
    end
    if infJumpActive then
        enableInfJump()
    end
end

LocalPlayer.CharacterAdded:Connect(hookCharacter)
if LocalPlayer.Character then
    local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Jumping:Connect(onJumping) end
end

local function animateToggle(knob, track, on)
    TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Position = on and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
        BackgroundColor3 = on and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    }):Play()
    TweenService:Create(track, TweenInfo.new(0.2), {
        BackgroundColor3 = on and TOGGLE_ON or GRAY_TRACK
    }):Play()
end

local function updateStatus()
    local on = antiBatActive or infJumpActive
    if on then
        StatusValue.Text = "ACTIVE"
        StatusValue.TextColor3 = GREEN
        StatusDot.BackgroundColor3 = GREEN
    else
        StatusValue.Text = "INACTIVE"
        StatusValue.TextColor3 = RED
        StatusDot.BackgroundColor3 = RED
    end
end

AntiBatClick.MouseButton1Click:Connect(function()
    if not antiBatActive then
        enableAntiBat()
    else
        disableAntiBat()
    end
    animateToggle(ToggleDot, ToggleBg, antiBatActive)
    updateStatus()
end)

InfJumpClick.MouseButton1Click:Connect(function()
    if not infJumpActive then
        enableInfJump()
    else
        disableInfJump()
    end
    animateToggle(InfToggleDot, InfToggleBg, infJumpActive)
    updateStatus()
end)

local listening = false
local listenConn = nil

KeybindBtn.MouseButton1Click:Connect(function()
    if listening then
        if listenConn then listenConn:Disconnect() listenConn = nil end
        listening = false
        KeybindBtn.Text = config.Keybind
        return
    end
    listening = true
    KeybindBtn.Text = "..."
    listenConn = UserInputService.InputBegan:Connect(function(input)
        if not listening then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.Escape then
                listening = false
                KeybindBtn.Text = config.Keybind
                if listenConn then listenConn:Disconnect() listenConn = nil end
                return
            end
            config.Keybind = input.KeyCode.Name
            KeybindBtn.Text = config.Keybind
            listening = false
            if listenConn then listenConn:Disconnect() listenConn = nil end
        end
    end)
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if listening then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == config.Keybind then
        if not antiBatActive then
            enableAntiBat()
        else
            disableAntiBat()
        end
        animateToggle(ToggleDot, ToggleBg, antiBatActive)
        updateStatus()
    end
end)

BgBtn.MouseButton1Click:Connect(function()
    BackgroundPicker.Visible = not BackgroundPicker.Visible
end)

Close.MouseButton1Click:Connect(function()
    BackgroundPicker.Visible = false
end)

local bgOptions = {
    { btn = Default, image = "rbxassetid://118100574986629" },
    { btn = Space1,  image = "rbxassetid://76835310118322"  },
    { btn = Space2,  image = "rbxassetid://114138477258742" },
}

for _, opt in ipairs(bgOptions) do
    opt.btn.MouseButton1Click:Connect(function()
        SpaceBackground.Image = opt.image
        BackgroundPicker.Visible = false
    end)
end

local minimized = false
local EXPANDED_SIZE = UDim2.new(0, 270, 0, 260)
local COLLAPSED_SIZE = UDim2.new(0, 270, 0, 48)

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    MinBtn.Text = minimized and "+" or "-"
    if minimized then
        ContentHolder.Visible = false
        TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = COLLAPSED_SIZE
        }):Play()
    else
        ContentHolder.Visible = true
        TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = EXPANDED_SIZE
        }):Play()
    end
end)

local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = input.Position - dragStart
    Main.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

ToggleDot.Position = UDim2.new(0, 3, 0.5, -8)
ToggleBg.BackgroundColor3 = GRAY_TRACK
InfToggleDot.Position = UDim2.new(0, 3, 0.5, -8)
InfToggleBg.BackgroundColor3 = GRAY_TRACK
StatusValue.Text = "INACTIVE"
StatusValue.TextColor3 = RED
StatusDot.BackgroundColor3 = RED
KeybindBtn.Text = config.Keybind

SpaceXHookAntiBat.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")