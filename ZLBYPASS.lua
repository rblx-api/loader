local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local function fn(arg)
	if not arg then
		return
	end
	local position = arg.Position
	local tbl = { X = position.X.Scale, XOffset = position.X.Offset, Y = position.Y.Scale, YOffset = position.Y.Offset }

	pcall(function()
		writefile("ChocolaBypassPos.txt", HttpService:JSONEncode(tbl))
	end)
end

local function fn2()
	local udim2 = nil

	pcall(function()
		local data = HttpService:JSONDecode(readfile("ChocolaBypassPos.txt"))

		if data then
			udim2 = UDim2.new(data.X, data.XOffset, data.Y, data.YOffset)
		end
	end)

	return udim2
end

local v = fn2()

if CoreGui.RobloxGui:FindFirstChild("ChocolaBypassUI") then
	CoreGui.RobloxGui.ChocolaBypassUI:Destroy()
end

if playerGui:FindFirstChild("ZlhubReloadUI") then
	playerGui.ZlhubReloadUI:Destroy()
end

local tbl = {
	Dark = Color3.fromRGB(8, 18, 40),
	Light = Color3.fromRGB(0, 200, 255),
	Border = Color3.fromRGB(100, 200, 255),
	Gradient1 = Color3.fromRGB(0, 80, 255),
	Gradient2 = Color3.fromRGB(0, 200, 255),
	Discord = Color3.fromRGB(160, 200, 255),
	Red = Color3.fromRGB(200, 50, 50),
	Gold = Color3.fromRGB(255, 200, 0),
	GreenNeon = Color3.fromRGB(0, 255, 180),
	Success = Color3.fromRGB(0, 255, 180),
	Error = Color3.fromRGB(255, 100, 100),
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChocolaBypassUI"
screenGui.Parent = CoreGui.RobloxGui
screenGui.ResetOnSpawn = false
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 0)

if v then
	frame.Position = v
else
	frame.Position = UDim2.new(0.5, -130, 0.6, 0)
end

frame.BackgroundColor3 = tbl.Dark
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
local uiStroke = Instance.new("UIStroke", frame)
uiStroke.Color = tbl.Border
uiStroke.Thickness = 2
local frame2 = Instance.new("Frame", frame)
frame2.Size = UDim2.new(1, 0, 0, 30)
frame2.BackgroundTransparency = 1
local textLabel = Instance.new("TextLabel", frame2)
textLabel.Size = UDim2.new(1, -40, 1, 0)
textLabel.Position = UDim2.new(0, 10, 0, 0)
textLabel.Text = "CHOCOLA BYPASS ZL HUB"
textLabel.Font = Enum.Font.GothamBlack
textLabel.TextSize = 12
textLabel.TextColor3 = Color3.new(1, 1, 1)
textLabel.BackgroundTransparency = 1
textLabel.TextXAlignment = Enum.TextXAlignment.Left
local uiGradient = Instance.new("UIGradient", textLabel)
local colorSequence = ColorSequence.new
local tbl2 = {}
local v2 = ColorSequenceKeypoint.new(0, tbl.Gradient1)
local v3 = ColorSequenceKeypoint.new(0.5, tbl.Gradient2)
local new = ColorSequenceKeypoint.new
local color = Color3.fromRGB
tbl2[1] = v2
tbl2[2] = v3

do
	local values = table.pack(new(1, color(255, 255, 255)))
	table.move(values, 1, values.n, 3, tbl2)
end

uiGradient.Color = colorSequence(tbl2)
local frame3 = Instance.new("Frame", frame2)
frame3.BackgroundColor3 = Color3.fromRGB(25, 40, 70)
frame3.Size = UDim2.new(0, 20, 0, 20)
frame3.Position = UDim2.new(1, -26, 0.5, -10)
Instance.new("UICorner", frame3).CornerRadius = UDim.new(0, 5)
local textButton = Instance.new("TextButton", frame3)
textButton.Text = "-"
textButton.Font = Enum.Font.GothamBold
textButton.TextSize = 15
textButton.TextColor3 = tbl.Light
textButton.BackgroundTransparency = 1
textButton.Size = UDim2.new(1, 0, 1, 0)
local frame4 = Instance.new("Frame", frame)
frame4.Size = UDim2.new(1, -16, 1, -45)
frame4.Position = UDim2.new(0, 8, 0, 35)
frame4.BackgroundTransparency = 1
frame4.ClipsDescendants = true
local uiListLayout = Instance.new("UIListLayout", frame4)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Padding = UDim.new(0, 6)
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function fn3()
	task.wait()
	frame.Size = UDim2.new(0, 260, 0, uiListLayout.AbsoluteContentSize.Y + 45)
end

uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fn3)
local textLabel2 = Instance.new("TextLabel", frame4)
textLabel2.Size = UDim2.new(0.95, 0, 0, 22)
textLabel2.Text = "Ready. Press BYPASS."
textLabel2.Font = Enum.Font.GothamBold
textLabel2.TextSize = 12
textLabel2.TextColor3 = tbl.GreenNeon
textLabel2.BackgroundColor3 = Color3.fromRGB(20, 35, 60)
textLabel2.BorderSizePixel = 0
Instance.new("UICorner", textLabel2).CornerRadius = UDim.new(0, 6)
textLabel2.TextXAlignment = Enum.TextXAlignment.Center
local textButton2 = Instance.new("TextButton", frame4)
textButton2.Size = UDim2.new(0.95, 0, 0, 40)
textButton2.Text = "BYPASS"
textButton2.Font = Enum.Font.GothamBold
textButton2.TextSize = 16
textButton2.TextColor3 = Color3.new(1, 1, 1)
textButton2.BackgroundColor3 = Color3.fromRGB(30, 60, 120)
textButton2.BorderSizePixel = 2
textButton2.BorderColor3 = tbl.Border
Instance.new("UICorner", textButton2).CornerRadius = UDim.new(0, 8)
local textLabel3 = Instance.new("TextLabel", frame4)
textLabel3.Size = UDim2.new(0.95, 0, 0, 18)
textLabel3.Text = "discord.gg/74GMyygaMy"
textLabel3.Font = Enum.Font.GothamBold
textLabel3.TextSize = 12
textLabel3.TextColor3 = tbl.Discord
textLabel3.BackgroundTransparency = 1
textLabel3.TextXAlignment = Enum.TextXAlignment.Center
local flag = false
local n = 0

textButton.MouseButton1Click:Connect(function()
	flag = not flag

	if flag then
		n = frame.Size.Y.Offset
		frame.Size = UDim2.new(0, 260, 0, 30)
		frame4.Visible = false
		textButton.Text = "+"
	else
		frame.Size = UDim2.new(0, 260, 0, n)
		frame4.Visible = true
		textButton.Text = "-"
		task.wait(0.05)
		local n2 = uiListLayout.AbsoluteContentSize.Y + 45

		if n2 ~= n then
			n = n2
			frame.Size = UDim2.new(0, 260, 0, n)
		end
	end

	task.wait(0.1)
	fn(frame)
end)

local flag2 = false
local position = nil
local position2 = nil

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		flag2 = true
		position = input.Position
		position2 = frame.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if flag2 and input.UserInputType == Enum.UserInputType.MouseMovement then
		local n2 = input.Position - position
		frame.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n2.X, position2.Y.Scale, position2.Y.Offset + n2.Y)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		flag2 = false
		fn(frame)
	end
end)

local flag3 = false

textButton2.MouseButton1Click:Connect(function()
	if flag3 then
		textLabel2.Text = "Bypass in progress..."
		textLabel2.TextColor3 = tbl.Gold
		return
	end

	flag3 = true
	textButton2.Text = "CLEANING..."
	textButton2.BackgroundColor3 = tbl.Red
	textLabel2.Text = "Removing old GUIs..."
	textLabel2.TextColor3 = tbl.Gold

	for _, v4 in pairs({ CoreGui, playerGui, CoreGui.RobloxGui }) do
		if v4 then
			for _, child in pairs(v4:GetChildren()) do
				if child ~= screenGui then
					local str = child.Name:lower()

					if str:find("zl") or str:find("zlpv") or str:find("xspeed") or str:find("chocola") then
						pcall(function()
							child:Destroy()
							textLabel2.Text = "Removed: " .. child.Name
							task.wait(0.1)
						end)
					end
				end
			end
		end
	end

	textLabel2.Text = "Cleaning globals..."

	pcall(function()
		if getgenv then
			for k in pairs(getgenv()) do
				if type(k) == "string" then
					local str = k:lower()

					if str:find("zl") or str:find("zlpv") or str:find("xspeed") or str:find("chocola") then
						getgenv()[k] = nil
					end
				end
			end
		end
	end)

	task.wait(0.8)
	textLabel2.Text = "Downloading..."
	textLabel2.TextColor3 = tbl.Light

	local ok, result = pcall(function()
		local response = game:HttpGet("https://raw.githubusercontent.com/xspeedHub0/Zlhub/main/ZLPVPreview.lua")

		if response and #response > 100 then
			loadstring(response)()
		else
			error("Script is empty or invalid.")
		end
	end)

	if ok then
		textLabel2.Text = "Bypass successful."
		textLabel2.TextColor3 = tbl.Success
		textButton2.Text = "BYPASS"
		textButton2.BackgroundColor3 = Color3.fromRGB(30, 60, 120)
	else
		textLabel2.Text = "Error: " .. tostring(result):sub(1, 50)
		textLabel2.TextColor3 = tbl.Error
		textButton2.Text = "RETRY"
		textButton2.BackgroundColor3 = tbl.Red
	end

	task.wait(2)

	if not textLabel2.Text:find("Error") then
		textLabel2.Text = "Ready. Press BYPASS."
		textLabel2.TextColor3 = tbl.GreenNeon
	end

	flag3 = false
end)

task.wait(0.5)
fn3()
textLabel2.Text = "Ready. Press BYPASS."
textLabel2.TextColor3 = tbl.GreenNeon