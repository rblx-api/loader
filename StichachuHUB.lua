--[[
    STICHACHU HUB
    RED & BLACK EDITION
    Powered by Stichachu HUB
]]

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local function getGuiParent()
    local ok, result = pcall(function()
        if gethui then
            return gethui()
        end
        return LocalPlayer:WaitForChild("PlayerGui")
    end)

    if ok and result then
        return result
    end

    return LocalPlayer:WaitForChild("PlayerGui")
end

local Parent = getGuiParent()

local RED = Color3.fromRGB(190, 25, 45)
local DARK_RED = Color3.fromRGB(85, 12, 22)
local BLACK = Color3.fromRGB(13, 13, 16)
local PANEL = Color3.fromRGB(25, 22, 26)
local WHITE = Color3.fromRGB(245, 245, 245)
local GREY = Color3.fromRGB(165, 165, 175)

local old = Parent:FindFirstChild("StichachuHUB")
if old then
    old:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StichachuHUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = Parent

local function corner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = object
end

local function stroke(object, color)
    local s = Instance.new("UIStroke")
    s.Color = color or RED
    s.Thickness = 1.5
    s.Parent = object
end

local function makeDraggable(object, handle)
    local dragging = false
    local dragStart
    local startPos

    handle = handle or object

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - dragStart

            object.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- MAIN WINDOW

local Main = Instance.new("Frame")
Main.Name = "MainWindow"
Main.Size = UDim2.fromOffset(280, 105)
Main.Position = UDim2.new(0, 15, 0.4, 0)
Main.BackgroundColor3 = BLACK
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui
corner(Main, 12)
stroke(Main)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, -16, 0, 34)
Header.Position = UDim2.fromOffset(8, 5)
Header.BackgroundTransparency = 1
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "STICHACHU HUB"
Title.TextColor3 = WHITE
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(1, -16, 0, 18)
Version.Position = UDim2.fromOffset(8, 39)
Version.BackgroundTransparency = 1
Version.Text = "RED EDITION  •  PLAYER TOOLS"
Version.TextColor3 = RED
Version.Font = Enum.Font.GothamBold
Version.TextSize = 10
Version.TextXAlignment = Enum.TextXAlignment.Left
Version.Parent = Main

local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.fromOffset(60, 25)
Toggle.Position = UDim2.new(1, -68, 0, 70)
Toggle.BackgroundColor3 = RED
Toggle.Text = "OPEN"
Toggle.TextColor3 = WHITE
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 11
Toggle.Parent = Main
corner(Toggle, 6)

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -85, 0, 25)
Status.Position = UDim2.fromOffset(10, 70)
Status.BackgroundTransparency = 1
Status.Text = "SYSTEM READY"
Status.TextColor3 = GREY
Status.Font = Enum.Font.GothamMedium
Status.TextSize = 10
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Main

-- PLAYER PANEL

local PlayerPanel = Instance.new("Frame")
PlayerPanel.Name = "PlayerPanel"
PlayerPanel.Size = UDim2.fromOffset(280, 190)
PlayerPanel.Position = UDim2.new(0, 15, 0, 180)
PlayerPanel.BackgroundColor3 = BLACK
PlayerPanel.BorderSizePixel = 0
PlayerPanel.Visible = false
PlayerPanel.Parent = ScreenGui
corner(PlayerPanel, 12)
stroke(PlayerPanel)

local PlayerTitle = Instance.new("TextLabel")
PlayerTitle.Size = UDim2.new(1, -45, 0, 32)
PlayerTitle.Position = UDim2.fromOffset(10, 5)
PlayerTitle.BackgroundTransparency = 1
PlayerTitle.Text = "PLAYER MANAGEMENT"
PlayerTitle.TextColor3 = WHITE
PlayerTitle.Font = Enum.Font.GothamBold
PlayerTitle.TextSize = 12
PlayerTitle.TextXAlignment = Enum.TextXAlignment.Left
PlayerTitle.Parent = PlayerPanel

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(25, 25)
Close.Position = UDim2.new(1, -32, 0, 7)
Close.BackgroundColor3 = DARK_RED
Close.Text = "X"
Close.TextColor3 = WHITE
Close.Font = Enum.Font.GothamBold
Close.TextSize = 12
Close.Parent = PlayerPanel
corner(Close, 5)

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -16, 1, -48)
Scroll.Position = UDim2.fromOffset(8, 40)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 3
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.Parent = PlayerPanel

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 5)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Scroll

local function updatePlayers()
    for _, child in ipairs(Scroll:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local Row = Instance.new("Frame")
            Row.Size = UDim2.new(1, -4, 0, 32)
            Row.BackgroundColor3 = PANEL
            Row.BorderSizePixel = 0
            Row.Parent = Scroll
            corner(Row, 6)

            local Name = Instance.new("TextLabel")
            Name.Size = UDim2.new(1, -12, 1, 0)
            Name.Position = UDim2.fromOffset(8, 0)
            Name.BackgroundTransparency = 1
            Name.Text = player.DisplayName
            Name.TextColor3 = WHITE
            Name.TextSize = 11
            Name.Font = Enum.Font.GothamMedium
            Name.TextXAlignment = Enum.TextXAlignment.Left
            Name.Parent = Row
        end
    end
end

local OpenPlayers = Instance.new("TextButton")
OpenPlayers.Name = "PlayersButton"
OpenPlayers.Size = UDim2.fromOffset(45, 45)
OpenPlayers.Position = UDim2.new(0, 15, 0, 385)
OpenPlayers.BackgroundColor3 = RED
OpenPlayers.Text = "👥"
OpenPlayers.TextSize = 19
OpenPlayers.Font = Enum.Font.GothamBold
OpenPlayers.TextColor3 = WHITE
OpenPlayers.Parent = ScreenGui
corner(OpenPlayers, 10)
stroke(OpenPlayers)

OpenPlayers.Activated:Connect(function()
    PlayerPanel.Visible = not PlayerPanel.Visible
    if PlayerPanel.Visible then
        updatePlayers()
    end
end)

Close.Activated:Connect(function()
    PlayerPanel.Visible = false
end)

Toggle.Activated:Connect(function()
    PlayerPanel.Visible = not PlayerPanel.Visible
    if PlayerPanel.Visible then
        updatePlayers()
    end
end)

Players.PlayerAdded:Connect(updatePlayers)
Players.PlayerRemoving:Connect(updatePlayers)

makeDraggable(Main, Header)
makeDraggable(PlayerPanel, PlayerTitle)
makeDraggable(OpenPlayers)

-- FOOTER

local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 18)
Footer.Position = UDim2.new(0, 0, 1, -20)
Footer.BackgroundTransparency = 1
Footer.Text = "POWERED BY STICHACHU HUB"
Footer.TextColor3 = GREY
Footer.Font = Enum.Font.GothamBold
Footer.TextSize = 9
Footer.Parent = PlayerPanel

print("[STICHACHU HUB] Red Edition loaded successfully.")