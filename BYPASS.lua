-- ⏱ KEY CON EXPIRACIÓN
local keyExpiry = 1798233923169
local now = os.time() * 1000
if now > keyExpiry then
  pcall(function()
    game:GetService("Players").LocalPlayer:Kick("KEY EXPIRADA")
  end)
  return
end

-- 🔐 USUARIOS AUTORIZADOS
local authorizedUsers = {"Guardadosloyolaxbox"}
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
if not localPlayer then return end
local isAuthorized = false
for _, u in ipairs(authorizedUsers) do if u == localPlayer.Name then isAuthorized = true break end end
if not isAuthorized then pcall(function() localPlayer:Kick("RESET HWID - No autorizado") end) return end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local DEPTH = 296
local SPAM_DELAY = 0.12
local running = false
local bomb = nil
local spamThread = nil

-- ===== FONCTIONS DU BYPASS =====
function buildBomb(power)
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

function stopBypass()
    running = false
    if spamThread then task.cancel(spamThread) end
    bomb = nil
    spamThread = nil
end

function startBypass(power)
    stopBypass()
    running = true
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

-- ===== GUI NOXASPEEDBYPASS =====
local NoxaSpeedBypass = Instance.new("ScreenGui")
NoxaSpeedBypass.Name = "NoxaSpeedBypass"
NoxaSpeedBypass.IgnoreGuiInset = true
NoxaSpeedBypass.ResetOnSpawn = false
NoxaSpeedBypass.DisplayOrder = 131
NoxaSpeedBypass.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NoxaSpeedBypass.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Protection GUI
if type(syn) == "table" and type(syn.protect_gui) == "function" then
    pcall(syn.protect_gui, NoxaSpeedBypass)
elseif typeof(protectgui) == "function" then
    pcall(protectgui, NoxaSpeedBypass)
end

-- ===== BILLBOARD =====
local NoxaBillboard = Instance.new("BillboardGui")
NoxaBillboard.Name = "NoxaBillboard"
NoxaBillboard.Size = UDim2.new(0,300,0,45)
NoxaBillboard.Adornee = nil
NoxaBillboard.AlwaysOnTop = true
NoxaBillboard.MaxDistance = 100
NoxaBillboard.Parent = NoxaSpeedBypass

local Frame = Instance.new("Frame")
Frame.Name = "Frame"
Frame.Size = UDim2.new(1,0,1,0)
Frame.BackgroundColor3 = Color3.fromRGB(10,16,26)
Frame.BackgroundTransparency = 0.142
Frame.BorderSizePixel = 0
Frame.Parent = NoxaBillboard

local UICorner = Instance.new("UICorner")
UICorner.Name = "UICorner"
UICorner.CornerRadius = UDim.new(0,12)
UICorner.Parent = Frame

local UIStroke = Instance.new("UIStroke")
UIStroke.Name = "UIStroke"
UIStroke.Color = Color3.fromRGB(125,200,255)
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.113
UIStroke.Parent = Frame

local TextLabel = Instance.new("TextLabel")
TextLabel.Name = "TextLabel"
TextLabel.Size = UDim2.new(1,0,1,0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "BYPASS: DISCORD.GG/NOXADUELS"
TextLabel.TextColor3 = Color3.fromRGB(125,200,255)
TextLabel.TextSize = 20
TextLabel.Font = Enum.Font.FredokaOne
TextLabel.TextStrokeTransparency = 0.3
TextLabel.Parent = Frame

local UIGradient = Instance.new("UIGradient")
UIGradient.Name = "UIGradient"
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(125,200,255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,120,220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(125,200,255))
})
UIGradient.Rotation = 90
UIGradient.Parent = TextLabel

-- ===== PHONE BODY =====
local PhoneBody = Instance.new("Frame")
PhoneBody.Name = "PhoneBody"
PhoneBody.AnchorPoint = Vector2.new(0.5,0.5)
PhoneBody.Position = UDim2.new(0.5,392,0.5,90)
PhoneBody.Size = UDim2.new(0,300,0,420)
PhoneBody.BackgroundColor3 = Color3.fromRGB(16,24,36)
PhoneBody.BorderSizePixel = 0
PhoneBody.Parent = NoxaSpeedBypass

local UICorner2 = Instance.new("UICorner")
UICorner2.Name = "UICorner"
UICorner2.CornerRadius = UDim.new(0,28)
UICorner2.Parent = PhoneBody

local UIGradient2 = Instance.new("UIGradient")
UIGradient2.Name = "UIGradient"
UIGradient2.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(110,150,190)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(16,24,36)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120,164,205))
})
UIGradient2.Rotation = 125
UIGradient2.Parent = PhoneBody

local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.ZIndex = 0
Shadow.AnchorPoint = Vector2.new(0.5,0.5)
Shadow.Position = UDim2.new(0.5,0,0.5,4)
Shadow.Size = UDim2.new(1,36,1,36)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://6014261993"
Shadow.ImageColor3 = Color3.fromRGB(0,0,0)
Shadow.ImageTransparency = 0.38
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(49,49,450,450)
Shadow.Parent = PhoneBody

local UIScale = Instance.new("UIScale")
UIScale.Name = "UIScale"
UIScale.Scale = 0.9
UIScale.Parent = PhoneBody

local Frame2 = Instance.new("Frame")
Frame2.Name = "Frame"
Frame2.ClipsDescendants = true
Frame2.AnchorPoint = Vector2.new(0.5,0.5)
Frame2.Position = UDim2.new(0.5,0,0.5,0)
Frame2.Size = UDim2.new(1,-12,1,-12)
Frame2.BackgroundColor3 = Color3.fromRGB(9,14,22)
Frame2.BorderSizePixel = 0
Frame2.Parent = PhoneBody

local UICorner3 = Instance.new("UICorner")
UICorner3.Name = "UICorner"
UICorner3.CornerRadius = UDim.new(0,22)
UICorner3.Parent = Frame2

local UIStroke2 = Instance.new("UIStroke")
UIStroke2.Name = "UIStroke"
UIStroke2.Color = Color3.fromRGB(125,200,255)
UIStroke2.Thickness = 1.1
UIStroke2.Transparency = 0.5
UIStroke2.Parent = Frame2

local Frame3 = Instance.new("Frame")
Frame3.Name = "Frame"
Frame3.ClipsDescendants = true
Frame3.Size = UDim2.new(1,0,1,0)
Frame3.BackgroundColor3 = Color3.fromRGB(9,14,22)
Frame3.BorderSizePixel = 0
Frame3.Parent = Frame2

local UICorner4 = Instance.new("UICorner")
UICorner4.Name = "UICorner"
UICorner4.CornerRadius = UDim.new(0,22)
UICorner4.Parent = Frame3

local BgAsset = Instance.new("ImageLabel")
BgAsset.Name = "BgAsset"
BgAsset.Size = UDim2.new(1,0,1,0)
BgAsset.BackgroundTransparency = 1
BgAsset.Image = "rbxassetid://90453834580322"
BgAsset.ImageColor3 = Color3.fromRGB(168,169,250)
BgAsset.ImageTransparency = 0.6
BgAsset.ScaleType = Enum.ScaleType.Crop
BgAsset.Parent = Frame3

local UICorner5 = Instance.new("UICorner")
UICorner5.Name = "UICorner"
UICorner5.CornerRadius = UDim.new(0,22)
UICorner5.Parent = BgAsset

-- Décorations
local Frame4 = Instance.new("Frame")
Frame4.Name = "Frame"
Frame4.ZIndex = 2
Frame4.ClipsDescendants = true
Frame4.Size = UDim2.new(1,0,1,0)
Frame4.BackgroundTransparency = 1
Frame4.Parent = Frame3

local function createDecor(posX, posY, sizeX, sizeY, rot, color, trans)
    local f = Instance.new("Frame")
    f.ZIndex = 2
    f.Position = UDim2.new(posX,0,posY,0)
    f.Size = UDim2.new(0,sizeX,0,sizeY)
    f.BackgroundColor3 = color
    f.BackgroundTransparency = trans or 0.3
    f.BorderSizePixel = 0
    f.Rotation = rot
    f.Parent = Frame4
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,99)
    c.Parent = f
    return f
end

createDecor(0.63582, 0.706575, 4, 5, 17.5, Color3.fromRGB(150,212,255))
createDecor(0.567781, 0.339383, 5, 6, 34.5, Color3.fromRGB(160,224,255))
createDecor(0.593664, 0.658813, 6, 7, 51.5, Color3.fromRGB(170,200,255))
createDecor(0.25668, 0.773416, 3, 4, 68.5, Color3.fromRGB(180,212,255))
createDecor(0.146099, 0.605208, 4, 5, 85.5, Color3.fromRGB(140,224,255))
createDecor(0.767875, 0.32388, 5, 6, 102.5, Color3.fromRGB(150,200,255))
createDecor(0.797721, 0.940254, 6, 7, 119.5, Color3.fromRGB(160,212,255))
createDecor(0.175108, 0.566838, 3, 4, 136.5, Color3.fromRGB(170,224,255))
createDecor(0.360791, 0.280091, 4, 5, 153.5, Color3.fromRGB(180,200,255))
createDecor(0.506264, 0.396815, 5, 6, 170.5, Color3.fromRGB(140,212,255))

-- Header
local Frame15 = Instance.new("Frame")
Frame15.Name = "Frame"
Frame15.ZIndex = 5
Frame15.Position = UDim2.new(0,0,0,20)
Frame15.Size = UDim2.new(1,0,0,50)
Frame15.BackgroundTransparency = 1
Frame15.Parent = Frame3

local TextLabel2 = Instance.new("TextLabel")
TextLabel2.Name = "TextLabel"
TextLabel2.ZIndex = 6
TextLabel2.AnchorPoint = Vector2.new(0.5,0.5)
TextLabel2.Position = UDim2.new(0.5,0,0.5,0)
TextLabel2.Size = UDim2.new(0.9,0,0,32)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Text = "NOXA BYPASS"
TextLabel2.TextColor3 = Color3.fromRGB(125,200,255)
TextLabel2.TextSize = 22
TextLabel2.Font = Enum.Font.FredokaOne
TextLabel2.Parent = Frame15

local UIGradient3 = Instance.new("UIGradient")
UIGradient3.Name = "UIGradient"
UIGradient3.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(125,200,255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,120,220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255))
})
UIGradient3.Parent = TextLabel2

local TextButton = Instance.new("TextButton")
TextButton.Name = "TextButton"
TextButton.ZIndex = 6
TextButton.ClipsDescendants = true
TextButton.Position = UDim2.new(1,-36,0,8)
TextButton.Size = UDim2.new(0,26,0,26)
TextButton.BackgroundColor3 = Color3.fromRGB(24,36,52)
TextButton.BackgroundTransparency = 0.1
TextButton.Text = "-"
TextButton.TextColor3 = Color3.fromRGB(232,243,255)
TextButton.TextSize = 16
TextButton.Font = Enum.Font.GothamBold
TextButton.AutoButtonColor = false
TextButton.Parent = Frame15

local UICorner16 = Instance.new("UICorner")
UICorner16.Name = "UICorner"
UICorner16.CornerRadius = UDim.new(0,999)
UICorner16.Parent = TextButton

local UIStroke3 = Instance.new("UIStroke")
UIStroke3.Name = "UIStroke"
UIStroke3.Transparency = 0.55
UIStroke3.Parent = TextButton

local Frame16 = Instance.new("Frame")
Frame16.Name = "Frame"
Frame16.ZIndex = 5
Frame16.AnchorPoint = Vector2.new(0.5,0)
Frame16.Position = UDim2.new(0.5,0,0,72)
Frame16.Size = UDim2.new(0.82,0,0,1)
Frame16.BackgroundColor3 = Color3.fromRGB(125,200,255)
Frame16.BackgroundTransparency = 0.366
Frame16.BorderSizePixel = 0
Frame16.Parent = Frame3

-- Corps principal
local Frame17 = Instance.new("Frame")
Frame17.Name = "Frame"
Frame17.ZIndex = 5
Frame17.Position = UDim2.new(0,12,0,80)
Frame17.Size = UDim2.new(1,-24,1,-88)
Frame17.BackgroundTransparency = 1
Frame17.Parent = Frame3

-- Cercle d'affichage
local Frame18 = Instance.new("Frame")
Frame18.Name = "Frame"
Frame18.ZIndex = 6
Frame18.AnchorPoint = Vector2.new(0.5,0)
Frame18.Position = UDim2.new(0.5,-2,0,5)
Frame18.Size = UDim2.new(0,130,0,130)
Frame18.BackgroundTransparency = 1
Frame18.Parent = Frame17

local Frame19 = Instance.new("Frame")
Frame19.Name = "Frame"
Frame19.ZIndex = 6
Frame19.AnchorPoint = Vector2.new(0.5,0.5)
Frame19.Position = UDim2.new(0.5,0,0.5,0)
Frame19.Size = UDim2.new(0,120,0,120)
Frame19.BackgroundColor3 = Color3.fromRGB(13,20,31)
Frame19.BorderSizePixel = 0
Frame19.Parent = Frame18

local UICorner17 = Instance.new("UICorner")
UICorner17.Name = "UICorner"
UICorner17.CornerRadius = UDim.new(0,999)
UICorner17.Parent = Frame19

local UIStroke4 = Instance.new("UIStroke")
UIStroke4.Name = "UIStroke"
UIStroke4.Color = Color3.fromRGB(125,200,255)
UIStroke4.Thickness = 2.267
UIStroke4.Transparency = 0.46
UIStroke4.Parent = Frame19

local Frame20 = Instance.new("Frame")
Frame20.Name = "Frame"
Frame20.ZIndex = 9
Frame20.AnchorPoint = Vector2.new(0.5,0.5)
Frame20.Position = UDim2.new(0.5,0,0.5,0)
Frame20.Size = UDim2.new(0,96,0,96)
Frame20.BackgroundColor3 = Color3.fromRGB(8,13,20)
Frame20.BorderSizePixel = 0
Frame20.Parent = Frame19

local UICorner18 = Instance.new("UICorner")
UICorner18.Name = "UICorner"
UICorner18.CornerRadius = UDim.new(0,999)
UICorner18.Parent = Frame20

local UIStroke5 = Instance.new("UIStroke")
UIStroke5.Name = "UIStroke"
UIStroke5.Color = Color3.fromRGB(125,200,255)
UIStroke5.Transparency = 0.75
UIStroke5.Parent = Frame20

local TextLabel3 = Instance.new("TextLabel")
TextLabel3.Name = "TextLabel"
TextLabel3.ZIndex = 10
TextLabel3.AnchorPoint = Vector2.new(0.5,0)
TextLabel3.Position = UDim2.new(0.5,0,0,14)
TextLabel3.Size = UDim2.new(1,-8,0,12)
TextLabel3.BackgroundTransparency = 1
TextLabel3.Text = "OFFLINE"
TextLabel3.TextColor3 = Color3.fromRGB(136,156,180)
TextLabel3.TextSize = 9
TextLabel3.Font = Enum.Font.GothamBold
TextLabel3.Parent = Frame20

local TextLabel4 = Instance.new("TextLabel")
TextLabel4.Name = "TextLabel"
TextLabel4.ZIndex = 10
TextLabel4.AnchorPoint = Vector2.new(0.5,0.5)
TextLabel4.Position = UDim2.new(0.5,0,0.5,2)
TextLabel4.Size = UDim2.new(1,-8,0,34)
TextLabel4.BackgroundTransparency = 1
TextLabel4.Text = "97K"
TextLabel4.TextColor3 = Color3.fromRGB(255,255,255)
TextLabel4.TextSize = 28
TextLabel4.Font = Enum.Font.GothamBlack
TextLabel4.Parent = Frame20

local UIScale2 = Instance.new("UIScale")
UIScale2.Name = "UIScale"
UIScale2.Parent = TextLabel4

local UIGradient4 = Instance.new("UIGradient")
UIGradient4.Name = "UIGradient"
UIGradient4.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(190,230,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(125,200,255))
})
UIGradient4.Rotation = 90
UIGradient4.Parent = TextLabel4

local TextLabel5 = Instance.new("TextLabel")
TextLabel5.Name = "TextLabel"
TextLabel5.ZIndex = 10
TextLabel5.AnchorPoint = Vector2.new(0.5,1)
TextLabel5.Position = UDim2.new(0.5,0,1,-12)
TextLabel5.Size = UDim2.new(1,-8,0,12)
TextLabel5.BackgroundTransparency = 1
TextLabel5.Text = "00:00"
TextLabel5.TextColor3 = Color3.fromRGB(136,156,180)
TextLabel5.TextSize = 10
TextLabel5.Font = Enum.Font.GothamMedium
TextLabel5.Parent = Frame20

local Frame21 = Instance.new("Frame")
Frame21.Name = "Frame"
Frame21.ZIndex = 5
Frame21.AnchorPoint = Vector2.new(0.5,0.5)
Frame21.Position = UDim2.new(0.5,0,0.5,0)
Frame21.Size = UDim2.new(0,122,0,122)
Frame21.BackgroundTransparency = 1
Frame21.BorderSizePixel = 0
Frame21.Parent = Frame18

local UICorner19 = Instance.new("UICorner")
UICorner19.Name = "UICorner"
UICorner19.CornerRadius = UDim.new(0,999)
UICorner19.Parent = Frame21

local UIStroke6 = Instance.new("UIStroke")
UIStroke6.Name = "UIStroke"
UIStroke6.Color = Color3.fromRGB(125,200,255)
UIStroke6.Thickness = 5
UIStroke6.Transparency = 0.86
UIStroke6.Parent = Frame21

-- Power Input
local TextBox = Instance.new("TextBox")
TextBox.Name = "TextBox"
TextBox.ZIndex = 6
TextBox.AnchorPoint = Vector2.new(0.5,0)
TextBox.Position = UDim2.new(0.5,0,0,140)
TextBox.Size = UDim2.new(1,0,0,34)
TextBox.BackgroundColor3 = Color3.fromRGB(24,36,52)
TextBox.BorderSizePixel = 0
TextBox.Text = "97000"
TextBox.TextColor3 = Color3.fromRGB(232,243,255)
TextBox.TextSize = 13
TextBox.Font = Enum.Font.GothamBold
TextBox.PlaceholderText = "Custom power…"
TextBox.PlaceholderColor3 = Color3.fromRGB(136,156,180)
TextBox.ClearTextOnFocus = false
TextBox.Parent = Frame17

local UICorner20 = Instance.new("UICorner")
UICorner20.Name = "UICorner"
UICorner20.CornerRadius = UDim.new(0,12)
UICorner20.Parent = TextBox

local UIStroke7 = Instance.new("UIStroke")
UIStroke7.Name = "UIStroke"
UIStroke7.Color = Color3.fromRGB(125,200,255)
UIStroke7.Thickness = 1.2
UIStroke7.Transparency = 0.5
UIStroke7.Parent = TextBox

local UIScale3 = Instance.new("UIScale")
UIScale3.Name = "UIScale"
UIScale3.Parent = TextBox

-- Preset Label
local TextLabel6 = Instance.new("TextLabel")
TextLabel6.Name = "TextLabel"
TextLabel6.ZIndex = 6
TextLabel6.Position = UDim2.new(0,0,0,178)
TextLabel6.Size = UDim2.new(1,0,0,12)
TextLabel6.BackgroundTransparency = 1
TextLabel6.Text = "PRESET"
TextLabel6.TextColor3 = Color3.fromRGB(168,214,255)
TextLabel6.TextSize = 9
TextLabel6.Font = Enum.Font.GothamBlack
TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
TextLabel6.Parent = Frame17

-- Preset Buttons
local Frame22 = Instance.new("Frame")
Frame22.Name = "Frame"
Frame22.ZIndex = 6
Frame22.Position = UDim2.new(0,0,0,194)
Frame22.Size = UDim2.new(1,0,0,34)
Frame22.BackgroundTransparency = 1
Frame22.Parent = Frame17

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Name = "UIListLayout"
UIListLayout.Padding = UDim.new(0,8)
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Parent = Frame22

local TextButton2 = Instance.new("TextButton")
TextButton2.Name = "TextButton"
TextButton2.ZIndex = 6
TextButton2.ClipsDescendants = true
TextButton2.Size = UDim2.new(0,120,0,34)
TextButton2.BackgroundColor3 = Color3.fromRGB(125,200,255)
TextButton2.BorderSizePixel = 0
TextButton2.Text = "V1"
TextButton2.TextColor3 = Color3.fromRGB(8,20,32)
TextButton2.TextSize = 14
TextButton2.Font = Enum.Font.GothamBlack
TextButton2.AutoButtonColor = false
TextButton2.Parent = Frame22

local UICorner21 = Instance.new("UICorner")
UICorner21.Name = "UICorner"
UICorner21.CornerRadius = UDim.new(0,12)
UICorner21.Parent = TextButton2

local UIStroke8 = Instance.new("UIStroke")
UIStroke8.Name = "UIStroke"
UIStroke8.Color = Color3.fromRGB(125,200,255)
UIStroke8.Thickness = 1.2
UIStroke8.Transparency = 0.5
UIStroke8.Parent = TextButton2

local TextButton3 = Instance.new("TextButton")
TextButton3.Name = "TextButton"
TextButton3.ZIndex = 6
TextButton3.ClipsDescendants = true
TextButton3.Size = UDim2.new(0,120,0,34)
TextButton3.BackgroundColor3 = Color3.fromRGB(24,36,52)
TextButton3.BorderSizePixel = 0
TextButton3.Text = "V2"
TextButton3.TextColor3 = Color3.fromRGB(232,243,255)
TextButton3.TextSize = 14
TextButton3.Font = Enum.Font.GothamBlack
TextButton3.AutoButtonColor = false
TextButton3.Parent = Frame22

local UICorner22 = Instance.new("UICorner")
UICorner22.Name = "UICorner"
UICorner22.CornerRadius = UDim.new(0,12)
UICorner22.Parent = TextButton3

local UIStroke9 = Instance.new("UIStroke")
UIStroke9.Name = "UIStroke"
UIStroke9.Color = Color3.fromRGB(125,200,255)
UIStroke9.Thickness = 1.2
UIStroke9.Transparency = 0.5
UIStroke9.Parent = TextButton3

-- Enable section
local Frame23 = Instance.new("Frame")
Frame23.Name = "Frame"
Frame23.ZIndex = 6
Frame23.Position = UDim2.new(0,0,0,238)
Frame23.Size = UDim2.new(1,0,0,40)
Frame23.BackgroundColor3 = Color3.fromRGB(20,30,44)
Frame23.BackgroundTransparency = 0.22
Frame23.BorderSizePixel = 0
Frame23.Parent = Frame17

local UICorner23 = Instance.new("UICorner")
UICorner23.Name = "UICorner"
UICorner23.CornerRadius = UDim.new(0,12)
UICorner23.Parent = Frame23

local UIStroke10 = Instance.new("UIStroke")
UIStroke10.Name = "UIStroke"
UIStroke10.Transparency = 0.55
UIStroke10.Parent = Frame23

local TextLabel7 = Instance.new("TextLabel")
TextLabel7.Name = "TextLabel"
TextLabel7.ZIndex = 7
TextLabel7.Position = UDim2.new(0,12,0,0)
TextLabel7.Size = UDim2.new(0,70,1,0)
TextLabel7.BackgroundTransparency = 1
TextLabel7.Text = "ENABLE"
TextLabel7.TextColor3 = Color3.fromRGB(232,243,255)
TextLabel7.TextSize = 11
TextLabel7.Font = Enum.Font.GothamBlack
TextLabel7.TextXAlignment = Enum.TextXAlignment.Left
TextLabel7.Parent = Frame23

local TextButton4 = Instance.new("TextButton")
TextButton4.Name = "TextButton"
TextButton4.ZIndex = 7
TextButton4.Position = UDim2.new(0,80,0.5,-11)
TextButton4.Size = UDim2.new(0,64,0,22)
TextButton4.BackgroundTransparency = 1
TextButton4.Text = "[V]"
TextButton4.TextColor3 = Color3.fromRGB(136,156,180)
TextButton4.TextSize = 10
TextButton4.Font = Enum.Font.GothamBold
TextButton4.AutoButtonColor = false
TextButton4.Parent = Frame23

local TextButton5 = Instance.new("TextButton")
TextButton5.Name = "TextButton"
TextButton5.ZIndex = 7
TextButton5.ClipsDescendants = true
TextButton5.Position = UDim2.new(1,-100,0.5,-15)
TextButton5.Size = UDim2.new(0,92,0,30)
TextButton5.BackgroundColor3 = Color3.fromRGB(24,36,52)
TextButton5.BorderSizePixel = 0
TextButton5.Text = "ACTIVATE"
TextButton5.TextColor3 = Color3.fromRGB(125,200,255)
TextButton5.TextSize = 10
TextButton5.Font = Enum.Font.GothamBlack
TextButton5.AutoButtonColor = false
TextButton5.Parent = Frame23

local UICorner24 = Instance.new("UICorner")
UICorner24.Name = "UICorner"
UICorner24.CornerRadius = UDim.new(0,12)
UICorner24.Parent = TextButton5

local UIStroke11 = Instance.new("UIStroke")
UIStroke11.Name = "UIStroke"
UIStroke11.Color = Color3.fromRGB(125,200,255)
UIStroke11.Thickness = 1.2
UIStroke11.Transparency = 0.45
UIStroke11.Parent = TextButton5

-- Background Button
local BackgroundBtn = Instance.new("TextButton")
BackgroundBtn.Name = "BackgroundBtn"
BackgroundBtn.ZIndex = 8
BackgroundBtn.ClipsDescendants = true
BackgroundBtn.AnchorPoint = Vector2.new(0.5,0)
BackgroundBtn.Position = UDim2.new(0.5,0,0,282)
BackgroundBtn.Size = UDim2.new(0.8,0,0,30)
BackgroundBtn.BackgroundColor3 = Color3.fromRGB(24,36,52)
BackgroundBtn.BackgroundTransparency = 0.05
BackgroundBtn.Text = "BACKGROUND"
BackgroundBtn.TextColor3 = Color3.fromRGB(125,200,255)
BackgroundBtn.TextSize = 12
BackgroundBtn.Font = Enum.Font.GothamBlack
BackgroundBtn.AutoButtonColor = false
BackgroundBtn.Parent = Frame17

local UICorner25 = Instance.new("UICorner")
UICorner25.Name = "UICorner"
UICorner25.CornerRadius = UDim.new(0,10)
UICorner25.Parent = BackgroundBtn

local UIStroke12 = Instance.new("UIStroke")
UIStroke12.Name = "UIStroke"
UIStroke12.Color = Color3.fromRGB(125,200,255)
UIStroke12.Thickness = 1.2
UIStroke12.Transparency = 0.45
UIStroke12.Parent = BackgroundBtn

local UIScale4 = Instance.new("UIScale")
UIScale4.Name = "UIScale"
UIScale4.Parent = BackgroundBtn

-- ===== FLOAT BAR =====
local FloatBar = Instance.new("Frame")
FloatBar.Name = "FloatBar"
FloatBar.Visible = false
FloatBar.ZIndex = 50
FloatBar.ClipsDescendants = true
FloatBar.AnchorPoint = Vector2.new(0.5,0.5)
FloatBar.Position = UDim2.new(0.5,0,0.55,0)
FloatBar.Size = UDim2.new(0,220,0,118)
FloatBar.BackgroundColor3 = Color3.fromRGB(9,14,22)
FloatBar.BorderSizePixel = 0
FloatBar.Parent = NoxaSpeedBypass

local UICorner26 = Instance.new("UICorner")
UICorner26.Name = "UICorner"
UICorner26.CornerRadius = UDim.new(0,18)
UICorner26.Parent = FloatBar

local UIStroke13 = Instance.new("UIStroke")
UIStroke13.Name = "UIStroke"
UIStroke13.Color = Color3.fromRGB(125,200,255)
UIStroke13.Thickness = 1.4
UIStroke13.Transparency = 0.3
UIStroke13.Parent = FloatBar

local UIScale5 = Instance.new("UIScale")
UIScale5.Name = "UIScale"
UIScale5.Scale = 0.9
UIScale5.Parent = FloatBar

local Shadow2 = Instance.new("ImageLabel")
Shadow2.Name = "Shadow"
Shadow2.ZIndex = 49
Shadow2.AnchorPoint = Vector2.new(0.5,0.5)
Shadow2.Position = UDim2.new(0.5,0,0.5,4)
Shadow2.Size = UDim2.new(1,24,1,24)
Shadow2.BackgroundTransparency = 1
Shadow2.Image = "rbxassetid://6014261993"
Shadow2.ImageColor3 = Color3.fromRGB(0,0,0)
Shadow2.ImageTransparency = 0.42
Shadow2.ScaleType = Enum.ScaleType.Slice
Shadow2.SliceCenter = Rect.new(49,49,450,450)
Shadow2.Parent = FloatBar

local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Name = "ImageLabel"
ImageLabel.ZIndex = 50
ImageLabel.Size = UDim2.new(1,0,1,0)
ImageLabel.BackgroundTransparency = 1
ImageLabel.Image = "rbxassetid://90453834580322"
ImageLabel.ImageColor3 = Color3.fromRGB(168,169,250)
ImageLabel.ImageTransparency = 0.6
ImageLabel.ScaleType = Enum.ScaleType.Crop
ImageLabel.Parent = FloatBar

local UICorner27 = Instance.new("UICorner")
UICorner27.Name = "UICorner"
UICorner27.CornerRadius = UDim.new(0,18)
UICorner27.Parent = ImageLabel

local TextLabel8 = Instance.new("TextLabel")
TextLabel8.Name = "TextLabel"
TextLabel8.ZIndex = 52
TextLabel8.AnchorPoint = Vector2.new(0.5,0)
TextLabel8.Position = UDim2.new(0.5,0,0,10)
TextLabel8.Size = UDim2.new(1,-24,0,22)
TextLabel8.BackgroundTransparency = 1
TextLabel8.Text = "Noxa Bypass"
TextLabel8.TextColor3 = Color3.fromRGB(125,200,255)
TextLabel8.TextSize = 15
TextLabel8.Font = Enum.Font.FredokaOne
TextLabel8.Parent = FloatBar

local TextLabel9 = Instance.new("TextLabel")
TextLabel9.Name = "TextLabel"
TextLabel9.ZIndex = 52
TextLabel9.AnchorPoint = Vector2.new(0.5,0)
TextLabel9.Position = UDim2.new(0.5,0,0,30)
TextLabel9.Size = UDim2.new(1,-24,0,12)
TextLabel9.BackgroundTransparency = 1
TextLabel9.Text = "discord.gg/noxaduels"
TextLabel9.TextColor3 = Color3.fromRGB(136,156,180)
TextLabel9.TextSize = 9
TextLabel9.Font = Enum.Font.GothamMedium
TextLabel9.Parent = FloatBar

local TextButton6 = Instance.new("TextButton")
TextButton6.Name = "TextButton"
TextButton6.ZIndex = 53
TextButton6.ClipsDescendants = true
TextButton6.AnchorPoint = Vector2.new(0.5,0)
TextButton6.Position = UDim2.new(0.5,0,0,48)
TextButton6.Size = UDim2.new(1,-24,0,32)
TextButton6.BackgroundColor3 = Color3.fromRGB(24,36,52)
TextButton6.BorderSizePixel = 0
TextButton6.Text = "ACTIVATE"
TextButton6.TextColor3 = Color3.fromRGB(125,200,255)
TextButton6.TextSize = 12
TextButton6.Font = Enum.Font.GothamBlack
TextButton6.AutoButtonColor = false
TextButton6.Parent = FloatBar

local UICorner28 = Instance.new("UICorner")
UICorner28.Name = "UICorner"
UICorner28.CornerRadius = UDim.new(0,10)
UICorner28.Parent = TextButton6

local UIStroke14 = Instance.new("UIStroke")
UIStroke14.Name = "UIStroke"
UIStroke14.Color = Color3.fromRGB(125,200,255)
UIStroke14.Thickness = 1.2
UIStroke14.Transparency = 0.4
UIStroke14.Parent = TextButton6

local TextButton7 = Instance.new("TextButton")
TextButton7.Name = "TextButton"
TextButton7.ZIndex = 53
TextButton7.AnchorPoint = Vector2.new(0.5,0)
TextButton7.Position = UDim2.new(0.5,0,0,86)
TextButton7.Size = UDim2.new(1,-24,0,24)
TextButton7.BackgroundColor3 = Color3.fromRGB(28,24,34)
TextButton7.BorderSizePixel = 0
TextButton7.Text = "Open"
TextButton7.TextColor3 = Color3.fromRGB(136,156,180)
TextButton7.TextSize = 11
TextButton7.Font = Enum.Font.GothamBold
TextButton7.AutoButtonColor = false
TextButton7.Parent = FloatBar

local UICorner29 = Instance.new("UICorner")
UICorner29.Name = "UICorner"
UICorner29.Parent = TextButton7

local UIStroke15 = Instance.new("UIStroke")
UIStroke15.Name = "UIStroke"
UIStroke15.Color = Color3.fromRGB(125,200,255)
UIStroke15.Transparency = 0.55
UIStroke15.Parent = TextButton7

-- ===== CUSTOMIZE PANEL (CORRIGÉ AVEC PLUS D'ESPACE) =====
local CustomizePanel = Instance.new("Frame")
CustomizePanel.Name = "CustomizePanel"
CustomizePanel.Visible = false
CustomizePanel.ZIndex = 60
CustomizePanel.AnchorPoint = Vector2.new(0.5,0.5)
CustomizePanel.Position = UDim2.new(0.5,170,0.5,0)
CustomizePanel.Size = UDim2.new(0,250,0,420)
CustomizePanel.BackgroundColor3 = Color3.fromRGB(10,16,26)
CustomizePanel.BorderSizePixel = 0
CustomizePanel.Parent = NoxaSpeedBypass

local UICorner30 = Instance.new("UICorner")
UICorner30.Name = "UICorner"
UICorner30.CornerRadius = UDim.new(0,16)
UICorner30.Parent = CustomizePanel

local UIStroke16 = Instance.new("UIStroke")
UIStroke16.Name = "UIStroke"
UIStroke16.Color = Color3.fromRGB(125,200,255)
UIStroke16.Thickness = 1.3
UIStroke16.Transparency = 0.35
UIStroke16.Parent = CustomizePanel

local Shadow3 = Instance.new("ImageLabel")
Shadow3.Name = "Shadow"
Shadow3.ZIndex = 59
Shadow3.AnchorPoint = Vector2.new(0.5,0.5)
Shadow3.Position = UDim2.new(0.5,0,0.5,4)
Shadow3.Size = UDim2.new(1,28,1,28)
Shadow3.BackgroundTransparency = 1
Shadow3.Image = "rbxassetid://6014261993"
Shadow3.ImageColor3 = Color3.fromRGB(0,0,0)
Shadow3.ImageTransparency = 0.4
Shadow3.ScaleType = Enum.ScaleType.Slice
Shadow3.SliceCenter = Rect.new(49,49,450,450)
Shadow3.Parent = CustomizePanel

local UIScale6 = Instance.new("UIScale")
UIScale6.Name = "UIScale"
UIScale6.Scale = 0.9
UIScale6.Parent = CustomizePanel

local TextLabel10 = Instance.new("TextLabel")
TextLabel10.Name = "TextLabel"
TextLabel10.ZIndex = 62
TextLabel10.Position = UDim2.new(0,12,0,8)
TextLabel10.Size = UDim2.new(1,-44,0,18)
TextLabel10.BackgroundTransparency = 1
TextLabel10.Text = "Customize"
TextLabel10.TextColor3 = Color3.fromRGB(255,255,255)
TextLabel10.TextSize = 13
TextLabel10.Font = Enum.Font.GothamBlack
TextLabel10.Parent = CustomizePanel

local TextButton8 = Instance.new("TextButton")
TextButton8.Name = "TextButton"
TextButton8.ZIndex = 63
TextButton8.Position = UDim2.new(1,-30,0,6)
TextButton8.Size = UDim2.new(0,24,0,24)
TextButton8.BackgroundColor3 = Color3.fromRGB(14,22,34)
TextButton8.Text = "X"
TextButton8.TextColor3 = Color3.fromRGB(136,156,180)
TextButton8.TextSize = 12
TextButton8.Font = Enum.Font.GothamBold
TextButton8.AutoButtonColor = false
TextButton8.Parent = CustomizePanel

local UICorner31 = Instance.new("UICorner")
UICorner31.Name = "UICorner"
UICorner31.CornerRadius = UDim.new(0,7)
UICorner31.Parent = TextButton8

local Frame24 = Instance.new("Frame")
Frame24.Name = "Frame"
Frame24.ZIndex = 62
Frame24.Position = UDim2.new(0,10,0,32)
Frame24.Size = UDim2.new(1,-20,0,1)
Frame24.BackgroundColor3 = Color3.fromRGB(125,200,255)
Frame24.BorderSizePixel = 0
Frame24.Parent = CustomizePanel

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Name = "ScrollingFrame"
ScrollingFrame.ZIndex = 61
ScrollingFrame.Position = UDim2.new(0,8,0,38)
ScrollingFrame.Size = UDim2.new(1,-16,1,-46)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(125,200,255)
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollingFrame.CanvasSize = UDim2.new(0,0,0,0)
ScrollingFrame.Parent = CustomizePanel

local UIListLayout2 = Instance.new("UIListLayout")
UIListLayout2.Name = "UIListLayout"
UIListLayout2.Padding = UDim.new(0,12)
UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout2.Parent = ScrollingFrame

local UIPadding = Instance.new("UIPadding")
UIPadding.Name = "UIPadding"
UIPadding.PaddingTop = UDim.new(0,4)
UIPadding.PaddingBottom = UDim.new(0,8)
UIPadding.Parent = ScrollingFrame

-- ===== BACKGROUND =====
local TextLabel15 = Instance.new("TextLabel")
TextLabel15.Name = "TextLabel"
TextLabel15.ZIndex = 62
TextLabel15.Size = UDim2.new(1,0,0,14)
TextLabel15.BackgroundTransparency = 1
TextLabel15.Text = "BACKGROUND"
TextLabel15.TextColor3 = Color3.fromRGB(168,214,255)
TextLabel15.TextSize = 9
TextLabel15.Font = Enum.Font.GothamBlack
TextLabel15.TextXAlignment = Enum.TextXAlignment.Left
TextLabel15.Parent = ScrollingFrame

local Frame33 = Instance.new("Frame")
Frame33.Name = "Frame"
Frame33.ZIndex = 62
-- La grille contient 6 images sur 2 rangées.
-- 64 px ne suffisait que pour une seule rangée et faisait
-- déborder la seconde sous "IMAGE VISIBILITY".
Frame33.Size = UDim2.new(1,0,0,134)
Frame33.BackgroundTransparency = 1
Frame33.Parent = ScrollingFrame

local UIGridLayout = Instance.new("UIGridLayout")
UIGridLayout.Name = "UIGridLayout"
UIGridLayout.CellPadding = UDim2.new(0,4,0,4)
UIGridLayout.CellSize = UDim2.new(0,65,0,65)
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.Parent = Frame33

-- Garde la hauteur de la zone d'images synchronisée avec la grille.
-- Cela évite tout chevauchement si le nombre d'images change.
local function resizeBackgroundGrid()
    Frame33.Size = UDim2.new(1,0,0,UIGridLayout.AbsoluteContentSize.Y)
end

UIGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(resizeBackgroundGrid)

local bgButtons = {}
local selectedBg = "rbxassetid://90453834580322"

local function createBgButton(order, imageId, label)
    local btn = Instance.new("ImageButton")
    btn.Name = "ImageButton"
    btn.ZIndex = 63
    btn.LayoutOrder = order
    btn.BackgroundColor3 = Color3.fromRGB(10,10,14)
    btn.BorderSizePixel = 0
    btn.Image = imageId or ""
    btn.ImageTransparency = 0.15
    btn.ScaleType = Enum.ScaleType.Crop
    btn.AutoButtonColor = false
    btn.Parent = Frame33
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,7)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = (imageId == selectedBg) and Color3.fromRGB(125,200,255) or Color3.fromRGB(55,55,65)
    stroke.Thickness = 1.5
    stroke.Transparency = (imageId == selectedBg) and 0 or 0.35
    stroke.Parent = btn
    
    if label and label ~= "" then
        local lbl = Instance.new("TextLabel")
        lbl.ZIndex = 64
        lbl.Size = UDim2.new(1,0,1,0)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = Color3.fromRGB(200,200,220)
        lbl.Font = Enum.Font.GothamBold
        lbl.Parent = btn
    end
    
    table.insert(bgButtons, {btn = btn, stroke = stroke, imageId = imageId})
    
    btn.Activated:Connect(function()
        selectedBg = imageId
        BgAsset.Image = imageId
        for _, data in ipairs(bgButtons) do
            if data.imageId == imageId then
                data.stroke.Color = Color3.fromRGB(125,200,255)
                data.stroke.Transparency = 0
            else
                data.stroke.Color = Color3.fromRGB(55,55,65)
                data.stroke.Transparency = 0.35
            end
        end
    end)
    
    return btn
end

createBgButton(1, "", "None")
createBgButton(2, "rbxassetid://90631990302263")
createBgButton(3, "rbxassetid://109619268613730")
createBgButton(4, "rbxassetid://88369503310562")
createBgButton(5, "rbxassetid://90453834580322")
createBgButton(6, "rbxassetid://135181794444219")

-- ===== ESPACEUR (plus grand pour séparer BACKGROUND de IMAGE VISIBILITY) =====
local Spacer1 = Instance.new("Frame")
Spacer1.Name = "Spacer"
Spacer1.ZIndex = 62
Spacer1.Size = UDim2.new(1,0,0,16)
Spacer1.BackgroundTransparency = 1
Spacer1.Parent = ScrollingFrame

-- ===== IMAGE VISIBILITY =====
local TextLabel22 = Instance.new("TextLabel")
TextLabel22.Name = "TextLabel"
TextLabel22.ZIndex = 62
TextLabel22.Size = UDim2.new(1,0,0,14)
TextLabel22.BackgroundTransparency = 1
TextLabel22.Text = "IMAGE VISIBILITY"
TextLabel22.TextColor3 = Color3.fromRGB(168,214,255)
TextLabel22.TextSize = 9
TextLabel22.Font = Enum.Font.GothamBlack
TextLabel22.TextXAlignment = Enum.TextXAlignment.Left
TextLabel22.Parent = ScrollingFrame

local Frame35 = Instance.new("Frame")
Frame35.Name = "Frame"
Frame35.ZIndex = 62
Frame35.Size = UDim2.new(1,0,0,36)
Frame35.BackgroundColor3 = Color3.fromRGB(20,30,44)
Frame35.BackgroundTransparency = 0.3
Frame35.BorderSizePixel = 0
Frame35.Parent = ScrollingFrame

local UICorner46 = Instance.new("UICorner")
UICorner46.Name = "UICorner"
UICorner46.Parent = Frame35

local visibilityValue = 40

-- Bouton -
local TextButton9 = Instance.new("TextButton")
TextButton9.Name = "TextButton"
TextButton9.ZIndex = 63
TextButton9.Position = UDim2.new(0.12,0,0.5,-13)
TextButton9.Size = UDim2.new(0,32,0,26)
TextButton9.BackgroundColor3 = Color3.fromRGB(24,36,52)
TextButton9.Text = "-"
TextButton9.TextColor3 = Color3.fromRGB(255,255,255)
TextButton9.TextSize = 15
TextButton9.Font = Enum.Font.GothamBlack
TextButton9.AutoButtonColor = false
TextButton9.Parent = Frame35

local UICorner47 = Instance.new("UICorner")
UICorner47.Name = "UICorner"
UICorner47.CornerRadius = UDim.new(0,7)
UICorner47.Parent = TextButton9

-- Valeur affichée
local TextLabel23 = Instance.new("TextLabel")
TextLabel23.Name = "TextLabel"
TextLabel23.ZIndex = 63
TextLabel23.Position = UDim2.new(0.5,-20,0.5,-10)
TextLabel23.Size = UDim2.new(0,40,0,20)
TextLabel23.BackgroundTransparency = 1
TextLabel23.Text = "40%"
TextLabel23.TextColor3 = Color3.fromRGB(125,200,255)
TextLabel23.TextSize = 12
TextLabel23.Font = Enum.Font.GothamBlack
TextLabel23.TextXAlignment = Enum.TextXAlignment.Center
TextLabel23.Parent = Frame35

-- Bouton +
local TextButton10 = Instance.new("TextButton")
TextButton10.Name = "TextButton"
TextButton10.ZIndex = 63
TextButton10.Position = UDim2.new(0.88,-32,0.5,-13)
TextButton10.Size = UDim2.new(0,32,0,26)
TextButton10.BackgroundColor3 = Color3.fromRGB(24,36,52)
TextButton10.Text = "+"
TextButton10.TextColor3 = Color3.fromRGB(255,255,255)
TextButton10.TextSize = 15
TextButton10.Font = Enum.Font.GothamBlack
TextButton10.AutoButtonColor = false
TextButton10.Parent = Frame35

local UICorner48 = Instance.new("UICorner")
UICorner48.Name = "UICorner"
UICorner48.CornerRadius = UDim.new(0,7)
UICorner48.Parent = TextButton10

-- Fonction pour l'IMAGE VISIBILITY
local function updateVisibility(value)
    visibilityValue = math.clamp(value, 0, 100)
    TextLabel23.Text = tostring(visibilityValue) .. "%"
    BgAsset.ImageTransparency = 1 - (visibilityValue / 100)
    ImageLabel.ImageTransparency = 1 - (visibilityValue / 100)
end

TextButton9.Activated:Connect(function()
    updateVisibility(visibilityValue - 10)
end)

TextButton10.Activated:Connect(function()
    updateVisibility(visibilityValue + 10)
end)

-- ===== ESPACEUR (pour séparer IMAGE VISIBILITY de NOXA THEME) =====
local Spacer2 = Instance.new("Frame")
Spacer2.Name = "Spacer"
Spacer2.ZIndex = 62
Spacer2.Size = UDim2.new(1,0,0,16)
Spacer2.BackgroundTransparency = 1
Spacer2.Parent = ScrollingFrame

-- ===== NOXA THEME =====
local TextLabel24 = Instance.new("TextLabel")
TextLabel24.Name = "TextLabel"
TextLabel24.ZIndex = 62
TextLabel24.Size = UDim2.new(1,0,0,14)
TextLabel24.BackgroundTransparency = 1
TextLabel24.Text = "NOXA THEME"
TextLabel24.TextColor3 = Color3.fromRGB(168,214,255)
TextLabel24.TextSize = 9
TextLabel24.Font = Enum.Font.GothamBlack
TextLabel24.TextXAlignment = Enum.TextXAlignment.Left
TextLabel24.Parent = ScrollingFrame

local Frame36 = Instance.new("Frame")
Frame36.Name = "Frame"
Frame36.ZIndex = 62
Frame36.Size = UDim2.new(1,0,0,120)
Frame36.BackgroundTransparency = 1
Frame36.Parent = ScrollingFrame

local UIGridLayout2 = Instance.new("UIGridLayout")
UIGridLayout2.Name = "UIGridLayout"
UIGridLayout2.CellPadding = UDim2.new(0,4,0,4)
UIGridLayout2.CellSize = UDim2.new(0,52,0,36)
UIGridLayout2.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout2.Parent = Frame36

local function createThemeButton(order, color1, color2, color3, label)
    local btn = Instance.new("TextButton")
    btn.ZIndex = 63
    btn.LayoutOrder = order
    btn.BackgroundColor3 = color1
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = Frame36
    
    local corner = Instance.new("UICorner")
    corner.Parent = btn
    
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(0.5, color2),
        ColorSequenceKeypoint.new(1, color3)
    })
    grad.Rotation = 25
    grad.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(55,55,65)
    stroke.Thickness = 1.3
    stroke.Transparency = 0.35
    stroke.Parent = btn
    
    local lbl = Instance.new("TextLabel")
    lbl.ZIndex = 64
    lbl.AnchorPoint = Vector2.new(0.5,1)
    lbl.Position = UDim2.new(0.5,0,1,-2)
    lbl.Size = UDim2.new(1,-2,0,10)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(12,12,14)
    lbl.TextSize = 7
    lbl.Font = Enum.Font.GothamBlack
    lbl.Parent = btn
    
    btn.Activated:Connect(function()
        TextLabel2.TextColor3 = color2
        UIGradient3.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, color1),
            ColorSequenceKeypoint.new(0.5, color2),
            ColorSequenceKeypoint.new(1, color3)
        })
        UIStroke2.Color = color2
        TextLabel.TextColor3 = color2
        UIStroke4.Color = color2
        UIStroke6.Color = color2
        Frame27.BackgroundColor3 = color2
        Frame31.BackgroundColor3 = color2
        Frame28.BackgroundColor3 = Color3.fromRGB(255,255,255)
        Frame32.BackgroundColor3 = Color3.fromRGB(255,255,255)
        UIStroke17.Color = color2
        UIStroke18.Color = color2
        TextButton5.TextColor3 = color2
        TextButton6.TextColor3 = color2
        UIStroke11.Color = color2
        UIStroke14.Color = color2
        BackgroundBtn.TextColor3 = color2
        UIStroke12.Color = color2
        UIStroke16.Color = color2
        UIStroke13.Color = color2
        TextLabel15.TextColor3 = color2
        TextLabel22.TextColor3 = color2
        TextLabel24.TextColor3 = color2
    end)
    
    return btn
end

createThemeButton(1, Color3.fromRGB(24,82,140), Color3.fromRGB(125,200,255), Color3.fromRGB(190,230,255), "NOXA")
createThemeButton(2, Color3.fromRGB(16,100,116), Color3.fromRGB(96,220,235), Color3.fromRGB(176,245,250), "AQUA")
createThemeButton(3, Color3.fromRGB(18,70,132), Color3.fromRGB(80,180,255), Color3.fromRGB(150,215,255), "CYAN")
createThemeButton(4, Color3.fromRGB(60,110,150), Color3.fromRGB(170,225,255), Color3.fromRGB(225,245,255), "GLACIER")
createThemeButton(5, Color3.fromRGB(168,58,74), Color3.fromRGB(255,166,180), Color3.fromRGB(255,214,196), "MOMO")
createThemeButton(6, Color3.fromRGB(140,20,68), Color3.fromRGB(255,96,150), Color3.fromRGB(255,158,196), "UME")
createThemeButton(7, Color3.fromRGB(102,48,158), Color3.fromRGB(206,150,255), Color3.fromRGB(255,170,216), "FUJI")
createThemeButton(8, Color3.fromRGB(158,52,26), Color3.fromRGB(255,124,92), Color3.fromRGB(255,182,150), "KITSUNE")
createThemeButton(9, Color3.fromRGB(78,116,48), Color3.fromRGB(178,222,140), Color3.fromRGB(226,246,190), "MATCHA")
createThemeButton(10, Color3.fromRGB(40,96,150), Color3.fromRGB(150,210,255), Color3.fromRGB(206,236,255), "MIZU")
createThemeButton(11, Color3.fromRGB(104,20,116), Color3.fromRGB(255,110,220), Color3.fromRGB(140,120,255), "YOZAKURA")

-- ===== VARIABLES DE CONTRÔLE =====
local active = false
local startedAt = 0
local boundKey = Enum.KeyCode.V
local hidden = false
local customizeVisible = false

-- ===== FONCTIONS =====
function formatPower(num)
    if num >= 1000 then
        return string.format("%dK", math.floor(num / 1000 + 0.5))
    end
    return tostring(num)
end

function getCurrentPower()
    local n = tonumber(TextBox.Text)
    if not n then n = 97000 end
    return math.clamp(math.floor(n + 0.5), 1, 999999)
end

function syncButtons()
    local label = active and "DEACTIVATE" or "ACTIVATE"
    TextButton5.Text = label
    TextButton6.Text = label
end

function setActive(state)
    active = state
    if state then
        startedAt = os.clock()
        TextLabel3.Text = "ONLINE"
        TextLabel3.TextColor3 = Color3.fromRGB(125,200,255)
        TextButton5.BackgroundColor3 = Color3.fromRGB(200,40,40)
        TextButton5.TextColor3 = Color3.fromRGB(255,255,255)
        TextButton6.BackgroundColor3 = Color3.fromRGB(200,40,40)
        TextButton6.TextColor3 = Color3.fromRGB(255,255,255)
        startBypass(getCurrentPower())
    else
        TextLabel3.Text = "OFFLINE"
        TextLabel3.TextColor3 = Color3.fromRGB(136,156,180)
        TextButton5.BackgroundColor3 = Color3.fromRGB(24,36,52)
        TextButton5.TextColor3 = Color3.fromRGB(125,200,255)
        TextButton6.BackgroundColor3 = Color3.fromRGB(24,36,52)
        TextButton6.TextColor3 = Color3.fromRGB(125,200,255)
        TextLabel5.Text = "00:00"
        stopBypass()
    end
    syncButtons()
end

function updateBillboard()
    local char = LocalPlayer.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if head then
        NoxaBillboard.Adornee = head
        NoxaBillboard.Parent = NoxaSpeedBypass
    end
end

function toggleCustomize()
    customizeVisible = not customizeVisible
    CustomizePanel.Visible = customizeVisible
    if customizeVisible then
        CustomizePanel.Position = UDim2.new(0.5,170,0.5,0)
    end
end

-- ===== BILLBOARD ATTACHMENT =====
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local head = char:FindFirstChild("Head")
    if head then
        NoxaBillboard.Adornee = head
        NoxaBillboard.Parent = NoxaSpeedBypass
    end
end)

if LocalPlayer.Character then
    task.wait(0.5)
    local head = LocalPlayer.Character:FindFirstChild("Head")
    if head then
        NoxaBillboard.Adornee = head
        NoxaBillboard.Parent = NoxaSpeedBypass
    end
end

-- ===== ÉVÉNEMENTS GUI =====
TextButton5.Activated:Connect(function()
    setActive(not active)
end)

TextButton6.Activated:Connect(function()
    setActive(not active)
end)

TextButton.Activated:Connect(function()
    hidden = not hidden
    PhoneBody.Visible = not hidden
    FloatBar.Visible = hidden
end)

TextButton7.Activated:Connect(function()
    hidden = false
    PhoneBody.Visible = true
    FloatBar.Visible = false
end)

BackgroundBtn.Activated:Connect(function()
    toggleCustomize()
end)

TextButton8.Activated:Connect(function()
    CustomizePanel.Visible = false
    customizeVisible = false
end)

TextBox.FocusLost:Connect(function()
    local n = tonumber(TextBox.Text)
    if not n then n = 97000 end
    n = math.clamp(math.floor(n + 0.5), 1, 999999)
    TextBox.Text = tostring(n)
    TextLabel4.Text = formatPower(n)
    if active then startBypass(n) end
end)

TextButton2.Activated:Connect(function()
    local power = 97000
    TextBox.Text = tostring(power)
    TextLabel4.Text = formatPower(power)
    if active then startBypass(power) end
    TextButton2.BackgroundColor3 = Color3.fromRGB(125,200,255)
    TextButton2.TextColor3 = Color3.fromRGB(8,20,32)
    TextButton3.BackgroundColor3 = Color3.fromRGB(24,36,52)
    TextButton3.TextColor3 = Color3.fromRGB(232,243,255)
end)

TextButton3.Activated:Connect(function()
    local power = 50000
    TextBox.Text = tostring(power)
    TextLabel4.Text = formatPower(power)
    if active then startBypass(power) end
    TextButton3.BackgroundColor3 = Color3.fromRGB(125,200,255)
    TextButton3.TextColor3 = Color3.fromRGB(8,20,32)
    TextButton2.BackgroundColor3 = Color3.fromRGB(24,36,52)
    TextButton2.TextColor3 = Color3.fromRGB(232,243,255)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == boundKey then
            setActive(not active)
        end
    end
end)

RunService.RenderStepped:Connect(function(dt)
    if active then
        local elapsed = math.floor(os.clock() - startedAt)
        TextLabel5.Text = string.format("%02d:%02d", math.floor(elapsed / 60), elapsed % 60)
    end
end)

-- ===== DRAGGING =====
local dragging, dragStart, startPos, dragTarget = false, nil, nil, nil

local function beginDrag(input, target)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        dragTarget = target
        startPos = target.Position
    end
end

PhoneBody.InputBegan:Connect(function(input)
    beginDrag(input, PhoneBody)
end)

FloatBar.InputBegan:Connect(function(input)
    beginDrag(input, FloatBar)
end)

CustomizePanel.InputBegan:Connect(function(input)
    beginDrag(input, CustomizePanel)
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and dragTarget and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        dragTarget.Position = newPos
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        dragTarget = nil
    end
end)

TextBox.Text = "97000"
TextLabel4.Text = "97K"
updateVisibility(40)
setActive(false)
syncButtons()