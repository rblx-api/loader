local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer

-- // NEXX ANTI DIE THEME (negro + gris plateado)
local C_BORDER = Color3.fromRGB(180, 180, 180)
local C_PANEL = Color3.fromRGB(15, 15, 15)
local C_TEXT_TITLE = Color3.fromRGB(255, 255, 255)
local C_TEXT_SUB = Color3.fromRGB(200, 200, 200)
local C_INACTIVE = Color3.fromRGB(255, 80, 100)
local C_ACTIVE = Color3.fromRGB(100, 255, 120)
local C_TOGGLE_ON = Color3.fromRGB(200, 200, 200)
local C_TOGGLE_OFF = Color3.fromRGB(40, 40, 40)

local GUI_WIDTH = 250
local GUI_EXPANDED_HEIGHT = 195
local GUI_COLLAPSED_HEIGHT = 50

local ConfigFile = "AntiDie_Config.json"
local Config = {
    Position = {
        X_Scale = 0.5,
        X_Offset = -125,
        Y_Scale = 0.5,
        Y_Offset = -100
    }
}

local function SaveConfig()
    if writefile then
        pcall(function()
            writefile(ConfigFile, HttpService:JSONEncode(Config))
        end)
    end
end

local function LoadConfig()
    if isfile and isfile(ConfigFile) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(ConfigFile))
        end)

        if success and data and data.Position then
            Config.Position = data.Position
        end
    end
end

LoadConfig()

local State = {
    antiDieToggled = false,
    guiVisible = true,
    isCollapsed = false
}

local Keys = {
    antiDie = Enum.KeyCode.X,
    guiHide = Enum.KeyCode.RightControl
}

-- // Eliminar GUI antigua
for _, name in pairs({"AntiDieUI", "VioletteTPBat"}) do
    local old = game:GetService("CoreGui"):FindFirstChild(name)
    if old then
        old:Destroy()
    end
end

local gui = Instance.new("ScreenGui")
gui.Name = "AntiDieUI"
gui.ResetOnSpawn = false
gui.DisplayOrder = 10
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if not pcall(function()
    gui.Parent = game:GetService("CoreGui")
end) then
    gui.Parent = LP:WaitForChild("PlayerGui")
end

local main = Instance.new("Frame", gui)
main.Name = "Main"
main.Size = UDim2.new(0, GUI_WIDTH, 0, GUI_EXPANDED_HEIGHT)
main.Position = UDim2.new(
    Config.Position.X_Scale,
    Config.Position.X_Offset,
    Config.Position.Y_Scale,
    Config.Position.Y_Offset
)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.BackgroundTransparency = 0
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.ZIndex = 1

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 16)

-- Fondo con imagen
local bgImage = Instance.new("ImageLabel", main)
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.BackgroundTransparency = 1
bgImage.Image = "rbxassetid://101894744159774"
bgImage.ScaleType = Enum.ScaleType.Stretch
bgImage.ZIndex = 0

local imageCorner = Instance.new("UICorner", bgImage)
imageCorner.CornerRadius = UDim.new(0, 16)

-- Arrastre
local dragging, dragInput, dragStart, mainStart = false, nil, nil, nil

main.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = inp.Position
        mainStart = main.Position

        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then
                dragging = false

                Config.Position = {
                    X_Scale = main.Position.X.Scale,
                    X_Offset = main.Position.X.Offset,
                    Y_Scale = main.Position.Y.Scale,
                    Y_Offset = main.Position.Y.Offset
                }

                SaveConfig()
            end
        end)
    end
end)

main.InputChanged:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseMovement
        or inp.UserInputType == Enum.UserInputType.Touch then
        dragInput = inp
    end
end)

UIS.InputChanged:Connect(function(inp)
    if inp == dragInput and dragging then
        local dx = inp.Position.X - dragStart.X
        local dy = inp.Position.Y - dragStart.Y

        main.Position = UDim2.new(
            mainStart.X.Scale,
            mainStart.X.Offset + dx,
            mainStart.Y.Scale,
            mainStart.Y.Offset + dy
        )
    end
end)

-- CABECERA
local titleDot = Instance.new("Frame", main)
titleDot.Size = UDim2.new(0, 10, 0, 10)
titleDot.Position = UDim2.new(0, 16, 0, 12)
titleDot.BackgroundColor3 = C_BORDER
titleDot.BorderSizePixel = 0
titleDot.ZIndex = 5

Instance.new("UICorner", titleDot).CornerRadius = UDim.new(1, 0)

local titleLbl = Instance.new("TextLabel", main)
titleLbl.Size = UDim2.new(0, 180, 0, 18)
titleLbl.Position = UDim2.new(0, 36, 0, 6)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "NEXX ANTI DIE"
titleLbl.TextColor3 = C_TEXT_TITLE
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 15
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 5

local subLbl = Instance.new("TextLabel", main)
subLbl.Size = UDim2.new(0, 180, 0, 14)
subLbl.Position = UDim2.new(0, 36, 0, 26)
subLbl.BackgroundTransparency = 1
subLbl.Text = "discord.gg/a3hm4fb54"
subLbl.TextColor3 = C_TEXT_SUB
subLbl.Font = Enum.Font.Gotham
subLbl.TextSize = 10
subLbl.TextXAlignment = Enum.TextXAlignment.Left
subLbl.ZIndex = 5

-- Botón minimizar
local minBtn = Instance.new("TextButton", main)
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Position = UDim2.new(1, -32, 0, 10)
minBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
minBtn.BackgroundTransparency = 0.5
minBtn.Text = "-"
minBtn.TextColor3 = C_TEXT_TITLE
minBtn.Font = Enum.Font.GothamBlack
minBtn.TextSize = 16
minBtn.ZIndex = 5

Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

minBtn.MouseButton1Click:Connect(function()
    State.isCollapsed = not State.isCollapsed

    local targetHeight = State.isCollapsed
        and GUI_COLLAPSED_HEIGHT
        or GUI_EXPANDED_HEIGHT

    TweenService:Create(
        main,
        TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
        {
            Size = UDim2.new(0, GUI_WIDTH, 0, targetHeight)
        }
    ):Play()
end)

local function CreatePanel(yPos, height)
    local p = Instance.new("Frame", main)
    p.Size = UDim2.new(1, -24, 0, height)
    p.Position = UDim2.new(0, 12, 0, yPos)
    p.BackgroundColor3 = C_PANEL
    p.BackgroundTransparency = 0.5
    p.ZIndex = 4

    Instance.new("UICorner", p).CornerRadius = UDim.new(0, 12)

    return p
end

local statusPanel = CreatePanel(62, 32)

local statusDot = Instance.new("Frame", statusPanel)
statusDot.Size = UDim2.new(0, 8, 0, 8)
statusDot.Position = UDim2.new(0, 14, 0.5, -4)
statusDot.BackgroundColor3 = C_INACTIVE
statusDot.BorderSizePixel = 0
statusDot.ZIndex = 6

Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

local statusTxt = Instance.new("TextLabel", statusPanel)
statusTxt.Size = UDim2.new(0, 100, 1, 0)
statusTxt.Position = UDim2.new(0, 30, 0, 0)
statusTxt.BackgroundTransparency = 1
statusTxt.Text = "Status"
statusTxt.TextColor3 = C_TEXT_TITLE
statusTxt.Font = Enum.Font.GothamBold
statusTxt.TextSize = 13
statusTxt.TextXAlignment = Enum.TextXAlignment.Left
statusTxt.ZIndex = 6

local statusVal = Instance.new("TextLabel", statusPanel)
statusVal.Size = UDim2.new(0, 100, 1, 0)
statusVal.Position = UDim2.new(1, -114, 0, 0)
statusVal.BackgroundTransparency = 1
statusVal.Text = "INACTIVE"
statusVal.TextColor3 = C_INACTIVE
statusVal.Font = Enum.Font.GothamBlack
statusVal.TextSize = 14
statusVal.TextXAlignment = Enum.TextXAlignment.Right
statusVal.ZIndex = 6

local diePanel = CreatePanel(102, 50)

local dieTitle = Instance.new("TextLabel", diePanel)
dieTitle.Size = UDim2.new(0, 150, 0, 18)
dieTitle.Position = UDim2.new(0, 14, 0, 6)
dieTitle.BackgroundTransparency = 1
dieTitle.Text = "Anti Die"
dieTitle.TextColor3 = C_TEXT_TITLE
dieTitle.Font = Enum.Font.GothamBlack
dieTitle.TextSize = 14
dieTitle.TextXAlignment = Enum.TextXAlignment.Left
dieTitle.ZIndex = 6

local dieSub = Instance.new("TextLabel", diePanel)
dieSub.Size = UDim2.new(0, 200, 0, 14)
dieSub.Position = UDim2.new(0, 14, 0, 28)
dieSub.BackgroundTransparency = 1
dieSub.Text = "Previene la muerte"
dieSub.TextColor3 = C_TEXT_SUB
dieSub.Font = Enum.Font.Gotham
dieSub.TextSize = 10
dieSub.TextXAlignment = Enum.TextXAlignment.Left
dieSub.ZIndex = 6

local keybindLbl = Instance.new("TextLabel", diePanel)
keybindLbl.Size = UDim2.new(0, 30, 0, 20)
keybindLbl.Position = UDim2.new(1, -100, 0.5, -10)
keybindLbl.BackgroundTransparency = 1
keybindLbl.Text = Keys.antiDie.Name
keybindLbl.TextColor3 = C_BORDER
keybindLbl.Font = Enum.Font.GothamBlack
keybindLbl.TextSize = 12
keybindLbl.ZIndex = 6

local toggleBg = Instance.new("Frame", diePanel)
toggleBg.Size = UDim2.new(0, 44, 0, 22)
toggleBg.Position = UDim2.new(1, -58, 0.5, -11)
toggleBg.BackgroundColor3 = C_TOGGLE_OFF
toggleBg.BorderSizePixel = 0
toggleBg.ZIndex = 6

Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

local toggleDot = Instance.new("Frame", toggleBg)
toggleDot.Size = UDim2.new(0, 16, 0, 16)
toggleDot.Position = UDim2.new(0, 3, 0.5, -8)
toggleDot.BackgroundColor3 = C_TOGGLE_ON
toggleDot.BorderSizePixel = 0
toggleDot.ZIndex = 7

Instance.new("UICorner", toggleDot).CornerRadius = UDim.new(1, 0)

local btnPanel = CreatePanel(160, 32)

local mainBtn = Instance.new("TextButton", btnPanel)
mainBtn.Size = UDim2.new(1, 0, 1, 0)
mainBtn.BackgroundTransparency = 1
mainBtn.Text = ""
mainBtn.ZIndex = 6

local function updateVisuals()
    local on = State.antiDieToggled

    statusVal.Text = on and "ACTIVE" or "INACTIVE"
    statusVal.TextColor3 = on and C_ACTIVE or C_INACTIVE
    statusDot.BackgroundColor3 = on and C_ACTIVE or C_INACTIVE

    TweenService:Create(
        toggleDot,
        TweenInfo.new(0.2, Enum.EasingStyle.Back),
        {
            Position = on
                and UDim2.new(1, -21, 0.5, -8)
                or UDim2.new(0, 3, 0.5, -8)
        }
    ):Play()
end

-- // Lógica Anti Die
local heartConn = nil
local deathConns = {}
local charAddedConn = nil

local function protectChar(char)
    if not char then return end

    local hum = char:WaitForChild("Humanoid", 5)
    if not hum then return end

    hum.MaxHealth = math.huge
    hum.Health = math.huge

    local sc = hum.StateChanged:Connect(function(_, new)
        if not State.antiDieToggled then return end

        if new == Enum.HumanoidStateType.Dead then
            hum.Health = math.huge
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        end
    end)

    table.insert(deathConns, sc)

    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

    local hc = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not State.antiDieToggled then return end

        if hum.Health < hum.MaxHealth then
            hum.Health = math.huge
        end
    end)

    table.insert(deathConns, hc)

    if heartConn then
        heartConn:Disconnect()
    end

    heartConn = RunService.Heartbeat:Connect(function()
        if not State.antiDieToggled then return end

        if hum and hum.Parent and hum.Health < hum.MaxHealth then
            hum.Health = math.huge
        end
    end)
end

local function startProtect()
    for _, c in ipairs(deathConns) do
        pcall(function()
            c:Disconnect()
        end)
    end

    deathConns = {}

    if heartConn then
        heartConn:Disconnect()
        heartConn = nil
    end

    if charAddedConn then
        charAddedConn:Disconnect()
        charAddedConn = nil
    end

    local char = LP.Character
    protectChar(char)

    charAddedConn = LP.CharacterAdded:Connect(function(c)
        if not State.antiDieToggled then return end

        task.wait(0.1)

        for _, c2 in ipairs(deathConns) do
            pcall(function()
                c2:Disconnect()
            end)
        end

        deathConns = {}
        protectChar(c)
    end)
end

local function stopProtect()
    for _, c in ipairs(deathConns) do
        pcall(function()
            c:Disconnect()
        end)
    end

    deathConns = {}

    if heartConn then
        heartConn:Disconnect()
        heartConn = nil
    end

    if charAddedConn then
        charAddedConn:Disconnect()
        charAddedConn = nil
    end

    local char = LP.Character

    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")

        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            hum.MaxHealth = 100
            hum.Health = 100
        end
    end
end

-- Eventos de los botones
mainBtn.MouseButton1Click:Connect(function()
    State.antiDieToggled = not State.antiDieToggled

    if State.antiDieToggled then
        startProtect()
    else
        stopProtect()
    end

    updateVisuals()
end)

local invisibleToggleBtn = Instance.new("TextButton", diePanel)
invisibleToggleBtn.Size = UDim2.new(0, 50, 1, 0)
invisibleToggleBtn.Position = UDim2.new(1, -65, 0, 0)
invisibleToggleBtn.BackgroundTransparency = 1
invisibleToggleBtn.Text = ""
invisibleToggleBtn.ZIndex = 10

invisibleToggleBtn.MouseButton1Click:Connect(function()
    State.antiDieToggled = not State.antiDieToggled

    if State.antiDieToggled then
        startProtect()
    else
        stopProtect()
    end

    updateVisuals()
end)

-- Cambiar keybind
local kListening = false
local kConn = nil

local invisibleKeyBtn = Instance.new("TextButton", diePanel)
invisibleKeyBtn.Size = UDim2.new(0, 40, 1, 0)
invisibleKeyBtn.Position = UDim2.new(1, -110, 0, 0)
invisibleKeyBtn.BackgroundTransparency = 1
invisibleKeyBtn.Text = ""
invisibleKeyBtn.ZIndex = 10

invisibleKeyBtn.MouseButton1Click:Connect(function()
    if kListening then return end

    kListening = true
    keybindLbl.Text = "..."

    kConn = UIS.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Keyboard then
            Keys.antiDie = inp.KeyCode
            keybindLbl.Text = inp.KeyCode.Name
            kListening = false
            kConn:Disconnect()
        end
    end)
end)

-- Atajos de teclado
UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end

    if inp.UserInputType == Enum.UserInputType.Keyboard then

        if inp.KeyCode == Keys.antiDie and not kListening then
            State.antiDieToggled = not State.antiDieToggled

            if State.antiDieToggled then
                startProtect()
            else
                stopProtect()
            end

            updateVisuals()

        elseif inp.KeyCode == Keys.guiHide then
            State.guiVisible = not State.guiVisible
            main.Visible = State.guiVisible
        end
    end
end)

updateVisuals()