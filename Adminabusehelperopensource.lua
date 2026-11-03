local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local Keybinds = {
    AnchorKey = Enum.KeyCode.F,
    InstantBuyKey = Enum.KeyCode.H,
    AutoBuyKey = Enum.KeyCode.G
}

local Toggles = {
    Anchor = false,
    InstantBuy = false,
    AutoBuy = false
}

local AccentColor = Color3.fromRGB(255, 140, 40)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FxAdminAbuseGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 240)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -120)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 8, 2)
MainFrame.BackgroundTransparency = 0.08
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)

local BorderStroke = Instance.new("UIStroke", MainFrame)
BorderStroke.Color = AccentColor
BorderStroke.Thickness = 2
BorderStroke.Transparency = 0

local BorderGradient = Instance.new("UIGradient")
BorderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 15, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 140, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 15, 0))
})
BorderGradient.Rotation = 0
BorderGradient.Parent = BorderStroke

local RotationValue = 0
RunService.RenderStepped:Connect(function()
    RotationValue = (RotationValue + 2) % 360
    BorderGradient.Rotation = RotationValue
end)

local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(22, 10, 3)
TitleBar.BackgroundTransparency = 0.1
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 16)

local TitleBarBottom = Instance.new("Frame", TitleBar)
TitleBarBottom.Size = UDim2.new(1, 0, 0, 16)
TitleBarBottom.Position = UDim2.new(0, 0, 1, -16)
TitleBarBottom.BackgroundColor3 = Color3.fromRGB(22, 10, 3)
TitleBarBottom.BackgroundTransparency = 0.1
TitleBarBottom.BorderSizePixel = 0

local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size = UDim2.new(0, 220, 1, 0)
TitleLabel.Position = UDim2.new(0, 14, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Fx Admin Abuse"
TitleLabel.TextSize = 15
TitleLabel.TextColor3 = Color3.fromRGB(255, 210, 160)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local SubtitleLabel = Instance.new("TextLabel", TitleBar)
SubtitleLabel.Size = UDim2.new(0, 220, 0, 14)
SubtitleLabel.Position = UDim2.new(0, 14, 0, 30)
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.Font = Enum.Font.Gotham
SubtitleLabel.Text = "Admin Abuse Tools"
SubtitleLabel.TextSize = 10
SubtitleLabel.TextColor3 = Color3.fromRGB(180, 120, 60)
SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local MinimizeButton = Instance.new("TextButton", TitleBar)
MinimizeButton.Size = UDim2.new(0, 28, 0, 28)
MinimizeButton.Position = UDim2.new(1, -38, 0.5, -14)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(40, 18, 5)
MinimizeButton.BackgroundTransparency = 0.1
MinimizeButton.Text = ""
MinimizeButton.AutoButtonColor = false
Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(0, 7)

local MinimizeStroke = Instance.new("UIStroke", MinimizeButton)
MinimizeStroke.Color = Color3.fromRGB(220, 110, 20)
MinimizeStroke.Transparency = 0.5

local MinimizeLabel = Instance.new("TextLabel", MinimizeButton)
MinimizeLabel.Size = UDim2.new(1, 0, 1, 0)
MinimizeLabel.BackgroundTransparency = 1
MinimizeLabel.Font = Enum.Font.GothamBold
MinimizeLabel.Text = "Ã"
MinimizeLabel.TextSize = 22
MinimizeLabel.TextColor3 = Color3.fromRGB(255, 140, 40)

local FloatingButton = Instance.new("TextButton", ScreenGui)
FloatingButton.Size = UDim2.new(0, 44, 0, 44)
FloatingButton.Position = UDim2.new(0, 20, 0.5, -22)
FloatingButton.BackgroundColor3 = Color3.fromRGB(22, 10, 3)
FloatingButton.BackgroundTransparency = 0.1
FloatingButton.Text = "F.x"
FloatingButton.Font = Enum.Font.GothamBold
FloatingButton.TextSize = 13
FloatingButton.TextColor3 = Color3.fromRGB(255, 140, 40)
FloatingButton.AutoButtonColor = false
FloatingButton.Visible = false
FloatingButton.Active = true
FloatingButton.Draggable = true
Instance.new("UICorner", FloatingButton).CornerRadius = UDim.new(0, 10)

local FloatingStroke = Instance.new("UIStroke", FloatingButton)
FloatingStroke.Color = AccentColor
FloatingStroke.Thickness = 2
FloatingStroke.Transparency = 0.2

MinimizeButton.MouseButton1Click:Connect(function()
    local Tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    })
    Tween:Play()
    task.wait(0.3)
    MainFrame.Visible = false
    FloatingButton.Visible = true
end)

FloatingButton.MouseButton1Click:Connect(function()
    FloatingButton.Visible = false
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    local Tween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 300, 0, 240)
    })
    Tween:Play()
end)

MinimizeButton.MouseEnter:Connect(function()
    local Tween = TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(80, 30, 5)
    })
    Tween:Play()
end)

MinimizeButton.MouseLeave:Connect(function()
    local Tween = TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(40, 18, 5)
    })
    Tween:Play()
end)

local ScrollingFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollingFrame.Size = UDim2.new(1, -20, 1, -68)
ScrollingFrame.Position = UDim2.new(0, 10, 0, 58)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 3
ScrollingFrame.ScrollBarImageColor3 = AccentColor
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local OptionsContainer = Instance.new("Frame", ScrollingFrame)
OptionsContainer.Size = UDim2.new(1, 0, 0, 0)
OptionsContainer.BackgroundTransparency = 1
OptionsContainer.AutomaticSize = Enum.AutomaticSize.Y

local UILayout = Instance.new("UIListLayout", OptionsContainer)
UILayout.Padding = UDim.new(0, 8)
UILayout.SortOrder = Enum.SortOrder.LayoutOrder

local function CreateToggleOption(title, description, layoutOrder, toggleName, keybindName)
    local OptionFrame = Instance.new("Frame", OptionsContainer)
    OptionFrame.Size = UDim2.new(1, -4, 0, 58)
    OptionFrame.BackgroundColor3 = Color3.fromRGB(22, 10, 3)
    OptionFrame.BackgroundTransparency = 0.2
    OptionFrame.BorderSizePixel = 0
    OptionFrame.LayoutOrder = layoutOrder
    Instance.new("UICorner", OptionFrame).CornerRadius = UDim.new(0, 10)

    local OptionStroke = Instance.new("UIStroke", OptionFrame)
    OptionStroke.Color = Color3.fromRGB(60, 25, 5)
    OptionStroke.Thickness = 1
    OptionStroke.Transparency = 0.4

    local TitleText = Instance.new("TextLabel", OptionFrame)
    TitleText.Size = UDim2.new(0, 190, 0, 20)
    TitleText.Position = UDim2.new(0, 12, 0, 10)
    TitleText.BackgroundTransparency = 1
    TitleText.Font = Enum.Font.GothamBold
    TitleText.Text = title
    TitleText.TextSize = 12
    TitleText.TextColor3 = Color3.fromRGB(255, 210, 160)
    TitleText.TextXAlignment = Enum.TextXAlignment.Left

    local DescText = Instance.new("TextLabel", OptionFrame)
    DescText.Size = UDim2.new(0, 190, 0, 16)
    DescText.Position = UDim2.new(0, 12, 0, 32)
    DescText.BackgroundTransparency = 1
    DescText.Font = Enum.Font.Gotham
    DescText.Text = description
    DescText.TextSize = 9
    DescText.TextColor3 = Color3.fromRGB(180, 120, 60)
    DescText.TextXAlignment = Enum.TextXAlignment.Left

    local ToggleButton = Instance.new("TextButton", OptionFrame)
    ToggleButton.Size = UDim2.new(0, 44, 0, 22)
    ToggleButton.Position = UDim2.new(1, -56, 0.5, -11)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 14, 4)
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = false
    ToggleButton.ZIndex = 2
    Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)

    local ToggleIndicator = Instance.new("Frame", ToggleButton)
    ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
    ToggleIndicator.Position = UDim2.new(0, 3, 0.5, -8)
    ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 140, 40)
    ToggleIndicator.BorderSizePixel = 0
    ToggleIndicator.ZIndex = 3
    Instance.new("UICorner", ToggleIndicator).CornerRadius = UDim.new(1, 0)

    local function Toggle()
        Toggles[toggleName] = not Toggles[toggleName]
        local isEnabled = Toggles[toggleName]
        
        local targetPosition = isEnabled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        local targetColor = isEnabled and Color3.fromRGB(60, 25, 5) or Color3.fromRGB(30, 14, 4)
        local targetTransparency = isEnabled and 0.1 or 0.4
        
        local Tween1 = TweenService:Create(ToggleIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = targetPosition
        })
        Tween1:Play()
        
        local Tween2 = TweenService:Create(ToggleButton, TweenInfo.new(0.3), {
            BackgroundColor3 = targetColor
        })
        Tween2:Play()
        
        local Tween3 = TweenService:Create(OptionStroke, TweenInfo.new(0.3), {
            Transparency = targetTransparency
        })
        Tween3:Play()
        
        warn(title .. " : " .. (isEnabled and "ON" or "OFF"))
    end

    ToggleButton.MouseButton1Click:Connect(Toggle)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Keybinds[keybindName] then
            Toggle()
        end
    end)

    return ToggleButton
end

CreateToggleOption("Anchor Character", "Press F â¢ Freeze character in place", 1, "Anchor", "AnchorKey")
CreateToggleOption("Instant Buy", "Press H â¢ Buy items instantly", 2, "InstantBuy", "InstantBuyKey")
CreateToggleOption("Auto Buy", "Press G â¢ Auto buy nearby items", 3, "AutoBuy", "AutoBuyKey")

MainFrame.Size = UDim2.new(0, 0, 0, 0)
local OpenTween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 300, 0, 240)
})
OpenTween:Play()

local function GetPromptModel(prompt)
    if not prompt then return false end
    local attachment = prompt.Parent
    if not attachment or attachment.Name ~= "PromptAttachment" then return false end
    local part = attachment.Parent
    if not part or part.Name ~= "Part" then return false end
    local model = part.Parent
    return model and model:IsA("Model") and model or false
end

local function GetPromptPosition(prompt)
    if not prompt then return nil end
    local attachment = prompt.Parent
    if attachment and attachment:IsA("BasePart") then
        return attachment.Position
    end
    local model = GetPromptModel(prompt)
    if model and model.PrimaryPart then
        return model.PrimaryPart.Position
    end
    return nil
end

local ActivePrompts = {}
local AutoBuyConnection = nil
local DescendantConnection = nil

local function AddPrompt(prompt)
    if GetPromptModel(prompt) then
        ActivePrompts[prompt] = true
    end
end

local function StartAutoBuy()
    if AutoBuyConnection then AutoBuyConnection:Disconnect() end
    if DescendantConnection then DescendantConnection:Disconnect() end
    
    for _, descendant in ipairs(Workspace:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") then
            AddPrompt(descendant)
        end
    end
    
    DescendantConnection = Workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("ProximityPrompt") then
            AddPrompt(descendant)
        end
    end)
    
    AutoBuyConnection = RunService.RenderStepped:Connect(function()
        for prompt, _ in pairs(ActivePrompts) do
            if prompt and prompt.Parent then
                local promptPos = GetPromptPosition(prompt)
                if promptPos and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - promptPos).Magnitude
                    if distance < 15 then
                        for _, key in pairs(Enum.KeyCode:GetEnumItems()) do
                            pcall(function()
                                prompt:InputHoldBegin(key)
                            end)
                        end
                        task.wait(0.05)
                        for _, key in pairs(Enum.KeyCode:GetEnumItems()) do
                            pcall(function()
                                prompt:InputHoldEnd(key)
                            end)
                        end
                    end
                end
                ActivePrompts[prompt] = nil
            else
                ActivePrompts[prompt] = nil
            end
        end
    end)
end

local function StopAutoBuy()
    if AutoBuyConnection then
        AutoBuyConnection:Disconnect()
        AutoBuyConnection = nil
    end
    if DescendantConnection then
        DescendantConnection:Disconnect()
        DescendantConnection = nil
    end
    for prompt, _ in pairs(ActivePrompts) do
        for _, key in pairs(Enum.KeyCode:GetEnumItems()) do
            pcall(function()
                prompt:InputHoldEnd(key)
            end)
        end
    end
    ActivePrompts = {}
end

task.spawn(function()
    while task.wait() do
        pcall(function()
            if Toggles.Anchor and LocalPlayer.Character then
                local character = LocalPlayer.Character
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Anchored = true
                    end
                end
            elseif not Toggles.Anchor and LocalPlayer.Character then
                local character = LocalPlayer.Character
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Anchored = false
                    end
                end
            end
        end)
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if Toggles.Anchor then
        pcall(function()
            local character = LocalPlayer.Character
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Anchored = true
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if Toggles.InstantBuy then
                for _, prompt in ipairs(Workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        prompt.HoldDuration = 0
                        prompt.MaxActivationDistance = 20
                    end
                end
            end
        end)
    end
end)

Workspace.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("ProximityPrompt") and Toggles.InstantBuy then
        descendant.HoldDuration = 0
        descendant.MaxActivationDistance = 20
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if Toggles.AutoBuy then
                StartAutoBuy()
            else
                StopAutoBuy()
            end
        end)
    end
end)

LocalPlayer.CharacterRemoving:Connect(function()
    StopAutoBuy()
end)