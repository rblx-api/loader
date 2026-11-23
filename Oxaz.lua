--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--// LAG CONFIGURATION
local LagPower = 290 -- Higher = more lag
local LagActive = false
local FrameSkip = 0
local LagFrameCount = 0

--// REMOVE OLD GUI
if PlayerGui:FindFirstChild("OXG_Duel_GUI") then
	PlayerGui.OXG_Duel_GUI:Destroy()
end

--// SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OXG_Duel_GUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

--// MAIN FRAME
local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.new(0, 320, 0, 160)
Main.Position = UDim2.new(0.5, -160, 0.5, -80)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

--// TITLE
local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 10)
Title.Size = UDim2.new(1, -20, 0, 30)
Title.Font = Enum.Font.Code
Title.Text = "0XG Duel Lagger"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left

--// LAG POWER DISPLAY
local PowerLabel = Instance.new("TextLabel")
PowerLabel.Parent = Main
PowerLabel.BackgroundTransparency = 1
PowerLabel.Position = UDim2.new(0, 15, 0, 40)
PowerLabel.Size = UDim2.new(1, -20, 0, 20)
PowerLabel.Font = Enum.Font.GothamMedium
PowerLabel.Text = "LAG POWER: 290"
PowerLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
PowerLabel.TextSize = 14
PowerLabel.TextXAlignment = Enum.TextXAlignment.Left

--// TOGGLE HOLDER
local Holder = Instance.new("Frame")
Holder.Parent = Main
Holder.Size = UDim2.new(0, 290, 0, 52)
Holder.Position = UDim2.new(0.5, -145, 0, 80)
Holder.BackgroundColor3 = Color3.fromRGB(15,15,15)
Holder.BorderSizePixel = 0

local HolderCorner = Instance.new("UICorner")
HolderCorner.CornerRadius = UDim.new(0, 10)
HolderCorner.Parent = Holder

--// STATUS TEXT
local Status = Instance.new("TextLabel")
Status.Parent = Holder
Status.BackgroundTransparency = 1
Status.Position = UDim2.new(0, 15, 0, 0)
Status.Size = UDim2.new(0, 180, 1, 0)
Status.Font = Enum.Font.GothamMedium
Status.Text = "INACTIVE"
Status.TextColor3 = Color3.fromRGB(90,90,90)
Status.TextSize = 16

--// TOGGLE BACKGROUND
local ToggleBG = Instance.new("Frame")
ToggleBG.Parent = Holder
ToggleBG.Size = UDim2.new(0, 70, 0, 34)
ToggleBG.Position = UDim2.new(1, -85, 0.5, -17)
ToggleBG.BackgroundColor3 = Color3.fromRGB(25,25,25)
ToggleBG.BorderSizePixel = 0

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBG

--// TOGGLE BUTTON
local Toggle = Instance.new("TextButton")
Toggle.Parent = ToggleBG
Toggle.Size = UDim2.new(0, 28, 0, 28)
Toggle.Position = UDim2.new(0, 3, 0.5, -14)
Toggle.BackgroundColor3 = Color3.fromRGB(255,255,255)
Toggle.Text = ""
Toggle.AutoButtonColor = false
Toggle.BorderSizePixel = 0

local ToggleBtnCorner = Instance.new("UICorner")
ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
ToggleBtnCorner.Parent = Toggle

--// LAG SWITCHER FUNCTIONS
local LagConnections = {}

local function HeavyLag()
	-- Method 1: Frame skipping (most effective)
	local frameBypass = 0
	RunService.Stepped:Connect(function()
		if LagActive then
			frameBypass = frameBypass + 1
			if frameBypass >= LagPower then
				task.wait(5) -- Long delay
				frameBypass = 0
			elseif frameBypass % math.floor(LagPower/20) == 0 then
				task.wait() -- Short delay
			end
		end
	end)
	
	-- Method 2: Network spam
	local networkSpam
	networkSpam = game:GetService("RunService").Heartbeat:Connect(function()
		if LagActive then
			for i = 1, math.floor(LagPower / 20) do
				pcall(function()
					-- Spam remote events if available
					local remotes = ReplicatedStorage:FindFirstChild("Remotes")
					if remotes then
						for _, remote in pairs(remotes:GetChildren()) do
							if remote:IsA("RemoteEvent") then
								pcall(function() remote:FireServer() end)
							end
						end
					end
				end)
			end
		end
	end)
	table.insert(LagConnections, networkSpam)
	
	-- Method 3: Memory flooding
	local floodLoop
	floodLoop = game:GetService("RunService").RenderStepped:Connect(function()
		if LagActive then
			local floodCount = math.floor(LagPower / 15)
			for i = 1, floodCount do
				-- Create temporary instances to flood memory
				local tempPart = Instance.new("Part")
				tempPart.Size = Vector3.new(100, 100, 100)
				tempPart.CFrame = CFrame.new(0, -1000, 0)
				tempPart.Parent = game:GetService("Workspace")
				tempPart.Anchored = true
				tempPart.Transparency = 1
				task.defer(function()
					task.wait(0.1)
					tempPart:Destroy()
				end)
			end
		end
	end)
	table.insert(LagConnections, floodLoop)
end

local function LagLoop()
	while true do
		if LagActive then
			-- Extreme lag for 0.5 seconds
			local startTime = tick()
			while tick() - startTime < 0.5 and LagActive do
				-- Heavy computation loop
				local x = 0
				for i = 1, 5000 do
					x = x + math.sqrt(i) * math.sin(i)
				end
				game:GetService("RunService").Heartbeat:Wait()
			end
			-- Brief normal moment
			task.wait(0.05)
		else
			task.wait(0.1)
		end
	end
end

--// TOGGLE LOGIC
local Enabled = false

local function UpdateLagState()
	if Enabled then
		LagActive = true
	else
		LagActive = false
	end
end

local function UpdateToggle()
	if Enabled then
		Status.Text = "ACTIVE"
		Status.TextColor3 = Color3.fromRGB(255,50,50)
		PowerLabel.TextColor3 = Color3.fromRGB(255,50,50)

		TweenService:Create(
			Toggle,
			TweenInfo.new(0.2),
			{Position = UDim2.new(1, -31, 0.5, -14)}
		):Play()

		TweenService:Create(
			ToggleBG,
			TweenInfo.new(0.2),
			{BackgroundColor3 = Color3.fromRGB(200,30,30)}
		):Play()
		
		print("LAG ENABLED - Power: " .. LagPower)
	else
		Status.Text = "INACTIVE"
		Status.TextColor3 = Color3.fromRGB(90,90,90)
		PowerLabel.TextColor3 = Color3.fromRGB(255,100,100)

		TweenService:Create(
			Toggle,
			TweenInfo.new(0.2),
			{Position = UDim2.new(0, 3, 0.5, -14)}
		):Play()

		TweenService:Create(
			ToggleBG,
			TweenInfo.new(0.2),
			{BackgroundColor3 = Color3.fromRGB(25,25,25)}
		):Play()
		
		print("LAG DISABLED")
	end
end

Toggle.MouseButton1Click:Connect(function()
	Enabled = not Enabled
	UpdateLagState()
	UpdateToggle()
end)

-- Start lag systems
HeavyLag()
task.spawn(LagLoop)

--// KEYBIND (Press L to toggle)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == Enum.KeyCode.L then
		Enabled = not Enabled
		UpdateLagState()
		UpdateToggle()
	end
end)

UpdateToggle()
print("0XG Duel Lagger loaded - Lag Power: " .. LagPower)