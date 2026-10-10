-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Create Main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AmbitiosGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Create Frame (AMBITIOS TP BAT)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "AMBITIOS TP BAT"
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Background Image
local bgImage = Instance.new("ImageLabel")
bgImage.Name = "BackgroundImage"
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.Position = UDim2.new(0, 0, 0, 0)
bgImage.Image = "rbxassetid://107324692752415"
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.BackgroundTransparency = 1
bgImage.Parent = mainFrame

-- Title Header
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.BackgroundTransparency = 0.5
titleLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
titleLabel.Text = "AMBITIOS TP BAT"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = mainFrame

-- Action Button
local tpButton = Instance.new("TextButton")
tpButton.Name = "TPBATButton"
tpButton.Size = UDim2.new(0, 200, 0, 50)
tpButton.Position = UDim2.new(0.5, -100, 0.6, -25)
tpButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
tpButton.Text = "TP BAT"
tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
tpButton.TextSize = 22
tpButton.Font = Enum.Font.SourceSansBold
tpButton.Parent = mainFrame

-- Rounded Corners for Button
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = tpButton

---------------------------------------------------------
-- Teleport & Follow Logic
---------------------------------------------------------
local following = false
local followConnection = nil

-- Find Nearest Player Function
local function getNearestPlayer()
	local myCharacter = LocalPlayer.Character
	if not myCharacter or not myCharacter:FindFirstChild("HumanoidRootPart") then return nil end

	local myPos = myCharacter.HumanoidRootPart.Position
	local nearestPlayer = nil
	local shortestDistance = math.huge

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local targetPos = player.Character.HumanoidRootPart.Position
			local distance = (myPos - targetPos).Magnitude

			if distance < shortestDistance then
				shortestDistance = distance
				nearestPlayer = player
			end
		end
	end

	return nearestPlayer
end

-- Button Click Toggle
tpButton.MouseButton1Click:Connect(function()
	following = not following

	if following then
		local targetPlayer = getNearestPlayer()

		if targetPlayer and targetPlayer.Character then
			tpButton.Text = "FOLLOWING"
			tpButton.BackgroundColor3 = Color3.fromRGB(30, 200, 30)

			-- Initial Teleport behind the target
			local myChar = LocalPlayer.Character
			if myChar and myChar:FindFirstChild("HumanoidRootPart") and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
				myChar.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
			end

			-- Continuous Follow Loop
			followConnection = RunService.RenderStepped:Connect(function()
				local currentMyChar = LocalPlayer.Character
				if following and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
					local myHumanoid = currentMyChar and currentMyChar:FindFirstChild("Humanoid")
					local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
					
					if myHumanoid and targetRoot then
						myHumanoid:MoveTo(targetRoot.Position)
					end
				else
					following = false
					if followConnection then followConnection:Disconnect() end
					tpButton.Text = "TP BAT"
					tpButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
				end
			end)
		else
			tpButton.Text = "NO PLAYER NEAR"
			task.wait(1.5)
			tpButton.Text = "TP BAT"
			following = false
		end
	else
		if followConnection then
			followConnection:Disconnect()
		end
		tpButton.Text = "TP BAT"
		tpButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
	end
end)