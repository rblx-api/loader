--[[ RECONSTRUCTED SOURCE ]]
--[[ LUARMOR LOG REVERSE ENGINEERING — TIGY FPS DEVOUR ]]
--[[ FIDELITY TARGET: MAXIMUM POSSIBLE ]]

-- [1] GLOBAL SERVICES
local Players          = game:GetService("Players")
local CoreGui          = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- [2] SHARED DATA
local LocalPlayer  = Players.LocalPlayer
local selectedMode = "Slaps"

-- [3] FPS CLEANUP
local function cleanWorkspace()
    local targets = {
        {"Events.FatSammy.Model.Sammy",      {"Spyder ChainAccessory","head","Headphones","RedWhiteTopHat","katana","Spider"}},
        {"Events.Witching Hour.Model.Sammy", {"Spider","Accessory (Mesh_0)","Headphones","katana","Spyder ChainAccessory","head"}},
        {"Events.Winter Hour.Model.Sammy",   {"head","katana","Spider","Spyder ChainAccessory","Headphones","Accessory (C Santa Hat)","Accessory (Santa Mustache Beard)"}},
        {"Events.Fishing.Model.Fisherman",   {"Accessory (Meshes/biggest beard)","Accessory (defaultAccessory)","Accessory (Meshes/Pochete4Accessory)","Accessory (Rucksack Backpack)"}},
        {"Events.Extinct.Model.Sammy",       {"Accessory (MeshPartAccessory)","head","Accessory (Mesh_0)","Spyder ChainAccessory","Spider","Meshes/MilitaryBackpackAccessory","Headphones"}},
        {"Stock.Model.Sammy",                {"Spyder ChainAccessory","head","Headphones","RedWhiteTopHat","katana","Spider"}},
    }
    local merchants = {
        {"Santa Merchant.Rig",  {"That Whole Santa Suit","Accessory (defaultAccessory)","Accessory (BEARD_NORMAL)"}},
        {"BrainrotTrader.Rig",  {"Accessory (Red royal vampire coat )","Accessory (Meshes/Hair2 final ver1Accessory)"}},
        {"Merchant.Rig",        {"Accessory (Red royal vampire coat )","Accessory (Meshes/Hair2 final ver1Accessory)"}},
    }

    local function destroyIn(parent, names)
        for _, name in ipairs(names) do
            local obj = parent:FindFirstChild(name)
            if obj then obj:Destroy() end
        end
    end

    local function navPath(pathStr)
        local cur = workspace
        for part in pathStr:gmatch("[^%.]+") do
            cur = cur:FindFirstChild(part)
            if not cur then return nil end
        end
        return cur
    end

    for _, entry in ipairs(targets) do
        local obj = navPath(entry[1])
        if obj then destroyIn(obj, entry[2]) end
    end
    for _, entry in ipairs(merchants) do
        local obj = navPath(entry[1])
        if obj then destroyIn(obj, entry[2]) end
    end

    local ecc = workspace:FindFirstChild("EzzClappBtwmelvl1")
    if ecc then
        local crown = ecc:FindFirstChild("GingerbreadCrown_AccAccessory")
        if crown then crown:Destroy() end
    end

    workspace.DescendantAdded:Connect(function() end)
end

-- [4] DESTROY OLD INSTANCE
local existing = CoreGui:FindFirstChild("TIGY_FPS_Devour")
if existing then existing:Destroy() end

-- [5] DRAG HELPER
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- [6] UI CONSTRUCTION

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name         = "TIGY_FPS_Devour"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent       = CoreGui

-- Toggle button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name             = "ToggleButton"
ToggleButton.Size             = UDim2.new(0, 45, 0, 45)
ToggleButton.Position         = UDim2.new(0, 10, 0.5, -22)
ToggleButton.BackgroundColor3 = Color3.new(0.0392157, 0.0392157, 0.0392157)
ToggleButton.Text             = "T"
ToggleButton.TextColor3       = Color3.new(0, 0.588235, 1)
ToggleButton.Font             = Enum.Font.GothamBlack
ToggleButton.TextSize         = 20
ToggleButton.Parent           = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent       = ToggleButton

local ToggleBorder = Instance.new("Frame")
ToggleBorder.Size             = UDim2.new(1, 4, 1, 4)
ToggleBorder.Position         = UDim2.new(0, -2, 0, -2)
ToggleBorder.BackgroundColor3 = Color3.new(0, 0.588235, 1)
ToggleBorder.ZIndex           = 0
ToggleBorder.Parent           = ToggleButton

local ToggleBorderCorner = Instance.new("UICorner")
ToggleBorderCorner.CornerRadius = UDim.new(1, 0)
ToggleBorderCorner.Parent       = ToggleBorder

-- Main frame
local MainFrame = Instance.new("Frame")
MainFrame.Name             = "MainFrame"
MainFrame.Size             = UDim2.new(0, 320, 0, 300)
MainFrame.Position         = UDim2.new(0.5, -160, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.new(0.0392157, 0.0392157, 0.0392157)
MainFrame.BorderSizePixel  = 0
MainFrame.Active           = true
MainFrame.Parent           = ScreenGui

local MainFrameCorner = Instance.new("UICorner")
MainFrameCorner.CornerRadius = UDim.new(0, 14)
MainFrameCorner.Parent       = MainFrame

-- Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size                   = UDim2.new(1, 0, 0, 35)
TitleLabel.Position               = UDim2.new(0, 0, 0, 8)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text                   = "TIGY'S FPS DEVOUR"
TitleLabel.TextColor3             = Color3.new(1, 1, 1)
TitleLabel.Font                   = Enum.Font.GothamBlack
TitleLabel.TextSize               = 18
TitleLabel.Parent                 = MainFrame

-- Discord row
local DiscordRow = Instance.new("Frame")
DiscordRow.Size                   = UDim2.new(1, 0, 0, 25)
DiscordRow.Position               = UDim2.new(0, 0, 0, 40)
DiscordRow.BackgroundTransparency = 1
DiscordRow.Parent                 = MainFrame

local DiscordLabel = Instance.new("TextLabel")
DiscordLabel.Size                   = UDim2.new(0.7, 0, 1, 0)
DiscordLabel.Position               = UDim2.new(0, 15, 0, 0)
DiscordLabel.BackgroundTransparency = 1
DiscordLabel.Text                   = "https://discord.gg/EesJC34QEu"
DiscordLabel.TextColor3             = Color3.new(0, 0.588235, 1)
DiscordLabel.Font                   = Enum.Font.GothamMedium
DiscordLabel.TextSize               = 10
DiscordLabel.TextXAlignment         = Enum.TextXAlignment.Left
DiscordLabel.Parent                 = DiscordRow

local CopyButton = Instance.new("TextButton")
CopyButton.Size             = UDim2.new(0, 60, 0, 20)
CopyButton.Position         = UDim2.new(1, -75, 0, 0)
CopyButton.BackgroundColor3 = Color3.new(0.117647, 0.117647, 0.117647)
CopyButton.Text             = "COPY"
CopyButton.TextColor3       = Color3.new(1, 1, 1)
CopyButton.Font             = Enum.Font.GothamBold
CopyButton.TextSize         = 10
CopyButton.Parent           = DiscordRow

local CopyCorner = Instance.new("UICorner")
CopyCorner.CornerRadius = UDim.new(0, 4)
CopyCorner.Parent       = CopyButton

-- Dropdown
local DropdownFrame = Instance.new("Frame")
DropdownFrame.Size             = UDim2.new(0.9, 0, 0, 40)
DropdownFrame.Position         = UDim2.new(0.05, 0, 0, 85)
DropdownFrame.BackgroundColor3 = Color3.new(0.0784314, 0.0784314, 0.0784314)
DropdownFrame.ClipsDescendants = false
DropdownFrame.Parent           = MainFrame

local DropdownFrameCorner = Instance.new("UICorner")
DropdownFrameCorner.CornerRadius = UDim.new(0, 12)
DropdownFrameCorner.Parent       = DropdownFrame

local DropdownLabel = Instance.new("TextLabel")
DropdownLabel.Size                   = UDim2.new(1, -40, 1, 0)
DropdownLabel.Position               = UDim2.new(0, 12, 0, 0)
DropdownLabel.BackgroundTransparency = 1
DropdownLabel.Text                   = "Selected: Slaps"
DropdownLabel.TextColor3             = Color3.new(0.784314, 0.784314, 0.784314)
DropdownLabel.Font                   = Enum.Font.GothamBold
DropdownLabel.TextSize               = 14
DropdownLabel.TextXAlignment         = Enum.TextXAlignment.Left
DropdownLabel.Parent                 = DropdownFrame

local DropdownArrow = Instance.new("TextButton")
DropdownArrow.Size                   = UDim2.new(1, 0, 1, 0)
DropdownArrow.BackgroundTransparency = 1
DropdownArrow.Text                   = "▼ "
DropdownArrow.TextColor3             = Color3.new(0.784314, 0.784314, 0.784314)
DropdownArrow.Font                   = Enum.Font.GothamBold
DropdownArrow.TextSize               = 14
DropdownArrow.TextXAlignment         = Enum.TextXAlignment.Right
DropdownArrow.Parent                 = DropdownFrame

local DropdownList = Instance.new("Frame")
DropdownList.Size             = UDim2.new(1, 0, 0, 80)
DropdownList.Position         = UDim2.new(0, 0, 1, 5)
DropdownList.BackgroundColor3 = Color3.new(0.0588235, 0.0588235, 0.0588235)
DropdownList.Visible          = false
DropdownList.ZIndex           = 10
DropdownList.Parent           = DropdownFrame

local DropdownListCorner = Instance.new("UICorner")
DropdownListCorner.CornerRadius = UDim.new(0, 8)
DropdownListCorner.Parent       = DropdownList

local OptionSlaps = Instance.new("TextButton")
OptionSlaps.Size                   = UDim2.new(1, 0, 0, 40)
OptionSlaps.Position               = UDim2.new(0, 0, 0, 0)
OptionSlaps.BackgroundColor3       = Color3.new(0.156863, 0.156863, 0.156863)
OptionSlaps.BackgroundTransparency = 0.9
OptionSlaps.Text                   = "Slaps"
OptionSlaps.TextColor3             = Color3.new(1, 1, 1)
OptionSlaps.Font                   = Enum.Font.Gotham
OptionSlaps.TextSize               = 14
OptionSlaps.ZIndex                 = 11
OptionSlaps.Parent                 = DropdownList

local OptionAllGears = Instance.new("TextButton")
OptionAllGears.Size                   = UDim2.new(1, 0, 0, 40)
OptionAllGears.Position               = UDim2.new(0, 0, 0, 40)
OptionAllGears.BackgroundColor3       = Color3.new(0.156863, 0.156863, 0.156863)
OptionAllGears.BackgroundTransparency = 0.9
OptionAllGears.Text                   = "All Gears (Stronger)"
OptionAllGears.TextColor3             = Color3.new(1, 1, 1)
OptionAllGears.Font                   = Enum.Font.Gotham
OptionAllGears.TextSize               = 14
OptionAllGears.ZIndex                 = 11
OptionAllGears.Parent                 = DropdownList

-- Devour button
local DevourButton = Instance.new("TextButton")
DevourButton.Size             = UDim2.new(0.9, 0, 0, 50)
DevourButton.Position         = UDim2.new(0.05, 0, 0, 185)
DevourButton.BackgroundColor3 = Color3.new(0, 0.588235, 1)
DevourButton.Text             = "FPS Devour (needs auras)"
DevourButton.TextColor3       = Color3.new(1, 1, 1)
DevourButton.Font             = Enum.Font.GothamBlack
DevourButton.TextSize         = 15
DevourButton.Parent           = MainFrame

local DevourCorner = Instance.new("UICorner")
DevourCorner.CornerRadius = UDim.new(0, 12)
DevourCorner.Parent       = DevourButton

-- Status label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size                   = UDim2.new(1, 0, 0, 30)
StatusLabel.Position               = UDim2.new(0, 0, 0, 245)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text                   = "Status: Waiting..."
StatusLabel.TextColor3             = Color3.new(0.470588, 0.470588, 0.470588)
StatusLabel.Font                   = Enum.Font.GothamMedium
StatusLabel.TextSize               = 12
StatusLabel.TextXAlignment         = Enum.TextXAlignment.Center
StatusLabel.Parent                 = MainFrame

-- Close button
local CloseButton = Instance.new("TextButton")
CloseButton.Size                   = UDim2.new(0, 40, 0, 40)
CloseButton.Position               = UDim2.new(1, -45, 0, 5)
CloseButton.BackgroundTransparency = 1
CloseButton.Text                   = "×"
CloseButton.TextColor3             = Color3.new(1, 1, 1)
CloseButton.Font                   = Enum.Font.GothamBlack
CloseButton.TextSize               = 24
CloseButton.Parent                 = MainFrame

-- [7] APPLY DRAG
makeDraggable(MainFrame)
makeDraggable(ToggleButton)

-- [8] EVENT CONNECTIONS

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

CopyButton.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/EesJC34QEu")
end)

DropdownArrow.MouseButton1Click:Connect(function()
    DropdownList.Visible = not DropdownList.Visible
end)

OptionSlaps.MouseButton1Click:Connect(function()
    selectedMode = "Slaps"
    DropdownLabel.Text = "Selected: Slaps"
    DropdownList.Visible = false
end)

OptionAllGears.MouseButton1Click:Connect(function()
    selectedMode = "All Gears (Stronger)"
    DropdownLabel.Text = "Selected: All Gears (Stronger)"
    DropdownList.Visible = false
end)

-- [9] CORE LOGIC

local function runDevour()
    local char     = LocalPlayer.Character
    local backpack = LocalPlayer.Backpack

    if not char then
        StatusLabel.Text = "Status: No character"
        return
    end

    StatusLabel.Text = "Status: Equipping..."

    -- snapshot before loop so reparenting doesn't cut iteration short
    local snapshot = {}
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local name = tool.Name:lower()
            if selectedMode == "Slaps" then
                if name:find("slap") then
                    table.insert(snapshot, tool)
                end
            else
                table.insert(snapshot, tool)
            end
        end
    end

    -- equip all at once, no yields between so game can't kick them off
    for _, tool in ipairs(snapshot) do
        tool.Parent = char
    end

    StatusLabel.Text = "Status: Cloning..."
    task.wait(0.05)

    local cloner = char:FindFirstChild("Quantum Cloner")
    if cloner then
        cloner:Activate()
    end

    task.wait(0.1)

    StatusLabel.Text = "Status: Clearing..."
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Tool") then
            obj.Parent = backpack
        end
    end

    StatusLabel.Text = "Status: SUCCESS"
end

DevourButton.MouseButton1Click:Connect(function()
    runDevour()
end)

-- [10] INIT
cleanWorkspace()
MainFrame.Visible = true