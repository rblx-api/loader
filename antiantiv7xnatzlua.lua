--maded by rzgr1ks at fpsl
print("LEAKED AT FPSL")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

connections = connections or {}
connections.FreezePlayer = connections.FreezePlayer or {}
featureStates = featureStates or {}
featureStates.FreezePlayer = featureStates.FreezePlayer or false

print("LEAKED AT FPSL")

-- ====================== VELOCITY SPOOF ======================
local spoofedVelocity = Vector3.zero

local oldIndex
oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
	if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") then
		if typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" and self:IsDescendantOf(LocalPlayer.Character) then
			return spoofedVelocity
		end
	end
	return oldIndex(self, key)
end))

local oldNewIndex
oldNewIndex = hookmetamethod(game, "__newindex", newcclosure(function(self, key, value)
	if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") then
		if typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" and self:IsDescendantOf(LocalPlayer.Character) then
			spoofedVelocity = value
			return
		end
	end
	return oldNewIndex(self, key, value)
end))

-- ====================== WALKFLING LOGIC ======================
local function walkfling(enabled)
    print("LEAKED AT FPSL")
    local walkflinging = false

    if enabled then
        featureStates.FreezePlayer = true

        local function disablePlayerCollisions()
            local conn = RunService.Stepped:Connect(function()
                if not featureStates.FreezePlayer then
                    conn:Disconnect()
                    return
                end
                local myChar = LocalPlayer.Character
                if myChar then
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= LocalPlayer and plr.Character then
                            for _, part in ipairs(plr.Character:GetChildren()) do
                                if part:IsA("BasePart") then
                                    part.CanCollide = false
                                end
                            end
                        end
                    end
                end
            end)
            table.insert(connections.FreezePlayer, conn)
        end

        local function stopWalkFling()
            walkflinging = false
        end

        local function startWalkFling()
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local humanoid = character:FindFirstChildWhichIsA("Humanoid")
            if humanoid then
                local diedConn = humanoid.Died:Connect(function()
                    stopWalkFling()
                end)
                table.insert(connections.FreezePlayer, diedConn)
            end

            walkflinging = true

            local flingConn = coroutine.create(function()
                local movel = 0.1
                repeat
                    RunService.Heartbeat:Wait()
                    if not featureStates.FreezePlayer then break end

                    character = LocalPlayer.Character
                    local root = character and character:FindFirstChild("HumanoidRootPart")

                    while not (character and character.Parent and root and root.Parent) do
                        RunService.Heartbeat:Wait()
                        if not featureStates.FreezePlayer then break end
                        character = LocalPlayer.Character
                        root = character and character:FindFirstChild("HumanoidRootPart")
                    end

                    if not featureStates.FreezePlayer then break end

                    local vel = root.AssemblyLinearVelocity
                    spoofedVelocity = vel

                    -- Yüksek Güçlü Fling Mantığı
                    root.AssemblyLinearVelocity = vel * 100 + Vector3.new(-9e25, -9e25, -9e25)
                    
                    RunService.RenderStepped:Wait()
                    if character and character.Parent and root and root.Parent then
                        root.AssemblyLinearVelocity = vel
                    end

                    RunService.Stepped:Wait()
                    if character and character.Parent and root and root.Parent then
                        root.AssemblyLinearVelocity = vel + Vector3.new(0, movel, 0)
                        movel = movel * -1
                    end

                until walkflinging == false or not featureStates.FreezePlayer
            end)

            coroutine.resume(flingConn)
            table.insert(connections.FreezePlayer, flingConn)
        end

        disablePlayerCollisions()
        startWalkFling()
    else
        -- KAPATILDIĞINDA: Önce Gücü 0 Yap
        featureStates.FreezePlayer = false
        walkflinging = false

        local character = LocalPlayer.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if root then
            root.AssemblyLinearVelocity = Vector3.zero
        end
        spoofedVelocity = Vector3.zero

        -- Sonra Bağlantıları Temizle ve Durdur
        for _, conn in ipairs(connections.FreezePlayer) do
            if conn then
                if typeof(conn) == "RBXScriptConnection" then
                    conn:Disconnect()
                elseif typeof(conn) == "thread" then
                    task.cancel(conn)
                end
            end
        end
        connections.FreezePlayer = {}
    end
end

print("LEAKED AT FPSL")

-- ====================== GUI SETUP ======================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnomalyHubGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.ClipsDescendants = true -- Kesin sınır koruması
MainFrame.AnchorPoint = Vector2.new(0, 0)
MainFrame.Position = UDim2.new(0.5, -150, 0.4, 0)
MainFrame.Size = UDim2.new(0, 300, 0, 120)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(80, 80, 120)
MainStroke.Thickness = 1.4
MainStroke.Parent = MainFrame

-- Background Image (Sınırlandırılmış 60x60 İkon Mantığı)
local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Name = "BackgroundImage"
BackgroundImage.AnchorPoint = Vector2.new(0.5, 0.5)
BackgroundImage.Position = UDim2.new(0.5, 0, 0.65, 0)
BackgroundImage.Size = UDim2.new(0, 250, 0, 250)
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.Image = "rbxassetid://114138477258742"
BackgroundImage.ScaleType = Enum.ScaleType.Fit
BackgroundImage.ClipsDescendants = true
BackgroundImage.ZIndex = 1
BackgroundImage.Parent = MainFrame

local ImageAspect = Instance.new("UIAspectRatioConstraint")
ImageAspect.AspectRatio = 1
ImageAspect.Parent = BackgroundImage

print("LEAKED AT FPSL")

-- Topbar
local Topbar = Instance.new("Frame")
Topbar.Name = "Topbar"
Topbar.Size = UDim2.new(1, 0, 0, 38)
Topbar.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
Topbar.BackgroundTransparency = 0.1
Topbar.BorderSizePixel = 0
Topbar.ZIndex = 3
Topbar.Parent = MainFrame

local TopbarCorner = Instance.new("UICorner")
TopbarCorner.CornerRadius = UDim.new(0, 10)
TopbarCorner.Parent = Topbar

local Title = Instance.new("TextLabel")
Title.Position = UDim2.new(0, 14, 0, 0)
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "V7xnatz Hub Anti Anti Desync"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 4
Title.Parent = Topbar

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.AnchorPoint = Vector2.new(1, 0.5)
MinimizeButton.Position = UDim2.new(1, -10, 0.5, 0)
MinimizeButton.Size = UDim2.new(0, 24, 0, 24)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MinimizeButton.Text = "—"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 12
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.AutoButtonColor = false
MinimizeButton.ZIndex = 4
MinimizeButton.Parent = Topbar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 6)
MinimizeCorner.Parent = MinimizeButton

-- Feature Item Frame
local FeatureFrame = Instance.new("Frame")
FeatureFrame.Position = UDim2.new(0, 14, 0, 52)
FeatureFrame.Size = UDim2.new(1, -28, 0, 48)
FeatureFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
FeatureFrame.BackgroundTransparency = 0.35
FeatureFrame.BorderSizePixel = 0
FeatureFrame.ZIndex = 3
FeatureFrame.Parent = MainFrame

local FeatureCorner = Instance.new("UICorner")
FeatureCorner.CornerRadius = UDim.new(0, 8)
FeatureCorner.Parent = FeatureFrame

local FeatureLabel = Instance.new("TextLabel")
FeatureLabel.AnchorPoint = Vector2.new(0, 0.5)
FeatureLabel.Position = UDim2.new(0, 14, 0.5, 0)
FeatureLabel.Size = UDim2.new(0.6, 0, 1, 0)
FeatureLabel.BackgroundTransparency = 1
FeatureLabel.Text = "Anti Anti Desync"
FeatureLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
FeatureLabel.TextSize = 13
FeatureLabel.Font = Enum.Font.GothamMedium
FeatureLabel.TextXAlignment = Enum.TextXAlignment.Left
FeatureLabel.ZIndex = 4
FeatureLabel.Parent = FeatureFrame

-- Right Toggle Button
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.AnchorPoint = Vector2.new(1, 0.5)
ToggleBtn.Position = UDim2.new(1, -12, 0.5, 0)
ToggleBtn.Size = UDim2.new(0, 46, 0, 24)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
ToggleBtn.Text = ""
ToggleBtn.AutoButtonColor = false
ToggleBtn.ZIndex = 4
ToggleBtn.Parent = FeatureFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

local ToggleKnob = Instance.new("Frame")
ToggleKnob.AnchorPoint = Vector2.new(0, 0.5)
ToggleKnob.Position = UDim2.new(0, 4, 0.5, 0)
ToggleKnob.Size = UDim2.new(0, 16, 0, 16)
ToggleKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
ToggleKnob.BorderSizePixel = 0
ToggleKnob.ZIndex = 5
ToggleKnob.Parent = ToggleBtn

local KnobCorner = Instance.new("UICorner")
KnobCorner.CornerRadius = UDim.new(1, 0)
KnobCorner.Parent = ToggleKnob

-- Toggle Action
local isToggled = false
local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

ToggleBtn.MouseButton1Click:Connect(function()
	print("LEAKED AT FPSL")
	isToggled = not isToggled
	walkfling(isToggled)

	if isToggled then
		TweenService:Create(ToggleBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(0, 170, 120)}):Play()
		TweenService:Create(ToggleKnob, tweenInfo, {
			Position = UDim2.new(1, -20, 0.5, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		}):Play()
	else
		TweenService:Create(ToggleBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}):Play()
		TweenService:Create(ToggleKnob, tweenInfo, {
			Position = UDim2.new(0, 4, 0.5, 0),
			BackgroundColor3 = Color3.fromRGB(200, 200, 200)
		}):Play()
	end
end)

-- Minimize Button Event
local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
	print("LEAKED AT FPSL")
	isMinimized = not isMinimized
	local targetSize = isMinimized and UDim2.new(0, 300, 0, 38) or UDim2.new(0, 300, 0, 120)
	
	FeatureFrame.Visible = not isMinimized
	BackgroundImage.Visible = not isMinimized
	TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize}):Play()
end)

-- UI DRAGGING
local dragging = false
local dragInput, dragStart, startPos

Topbar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Topbar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

print("LEAKED AT FPSL")