-- // HAZ REDEEMER INTRO
-- // Proper Blue Winter Theme
-- // Potassium-friendly

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local IMAGE_URL = "https://files.catbox.moe/8ksue7.png"
local AUDIO_URL = "https://files.catbox.moe/ej3at8.mp3"

local function downloadAsset(url, filename)
	local success, data = pcall(function()
		if request then
			local res = request({Url = url, Method = "GET"})
			return res.Body
		else
			return game:HttpGet(url)
		end
	end)
	if not success or not data then
		warn("[HAZ] failed to download:", url)
		return nil
	end
	writefile(filename, data)
	return getcustomasset(filename)
end

local imageAsset = downloadAsset(IMAGE_URL, "haz_logo.png")
local audioAsset = downloadAsset(AUDIO_URL, "haz_theme.mp3")

if not imageAsset or not audioAsset then
	warn("[HAZ] assets failed to load")
	return
end

local AssetFolder = Instance.new("Folder")
AssetFolder.Name = "HazAssets"
AssetFolder.Parent = workspace

local SoundHolder = Instance.new("Sound")
SoundHolder.Name = "HazTheme"
SoundHolder.SoundId = audioAsset
SoundHolder.Volume = 0.7
SoundHolder.Looped = true
SoundHolder.Parent = AssetFolder

-- // GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HazIntro"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- proper visible blue background
local Background = Instance.new("Frame")
Background.Name = "BlueVoid"
Background.Size = UDim2.fromScale(1, 1)
Background.BackgroundColor3 = Color3.fromRGB(20, 55, 120) -- actual blue
Background.BackgroundTransparency = 0
Background.BorderSizePixel = 0
Background.Active = true
Background.Parent = ScreenGui

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(30, 80, 160)),
	ColorSequenceKeypoint.new(0.45, Color3.fromRGB(18, 50, 110)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(10, 30, 75))
}
Gradient.Rotation = 90
Gradient.Parent = Background

-- logo
local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Name = "HazLogo"
ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
ImageLabel.Position = UDim2.fromScale(0.5, 0.38)
ImageLabel.Size = UDim2.fromOffset(380, 380)
ImageLabel.BackgroundTransparency = 1
ImageLabel.Image = imageAsset
ImageLabel.ScaleType = Enum.ScaleType.Fit
ImageLabel.ImageTransparency = 1
ImageLabel.ZIndex = 5
ImageLabel.Parent = Background

-- title
local Title = Instance.new("TextLabel")
Title.Name = "HazText"
Title.AnchorPoint = Vector2.new(0.5, 0)
Title.Position = UDim2.fromScale(0.5, 0.70)
Title.Size = UDim2.fromOffset(800, 60)
Title.BackgroundTransparency = 1
Title.Text = "HAZ REDEEMER"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 48
Title.TextStrokeTransparency = 0.25
Title.TextStrokeColor3 = Color3.fromRGB(0, 20, 60)
Title.TextTransparency = 1
Title.ZIndex = 5
Title.Parent = Background

-- hint
local Hint = Instance.new("TextLabel")
Hint.Name = "ClickHint"
Hint.AnchorPoint = Vector2.new(0.5, 0)
Hint.Position = UDim2.fromScale(0.5, 0.82)
Hint.Size = UDim2.fromOffset(500, 28)
Hint.BackgroundTransparency = 1
Hint.Text = "click anywhere to close"
Hint.Font = Enum.Font.Gotham
Hint.TextSize = 17
Hint.TextColor3 = Color3.fromRGB(160, 210, 255)
Hint.TextTransparency = 1
Hint.ZIndex = 5
Hint.Parent = Background

-- // snowflakes
local snowContainer = Instance.new("Folder")
snowContainer.Name = "Snow"
snowContainer.Parent = Background

local snowChars = {"❄", "❅", "❆", "✻", "✼"}
local snowflakes = {}

for i = 1, 60 do
	local flake = Instance.new("TextLabel")
	flake.Name = "Flake"
	flake.BackgroundTransparency = 1
	flake.Text = snowChars[math.random(1, #snowChars)]
	flake.TextColor3 = Color3.fromRGB(210, 235, 255)
	flake.TextTransparency = math.random(10, 40) / 100
	flake.TextSize = math.random(13, 26)
	flake.Font = Enum.Font.Gotham
	flake.Size = UDim2.fromOffset(28, 28)
	flake.Position = UDim2.new(math.random(), 0, math.random(-0.15, 0.05), 0)
	flake.Rotation = math.random(0, 360)
	flake.ZIndex = 2
	flake.Parent = snowContainer

	snowflakes[i] = {
		label = flake,
		speed = math.random(22, 65) / 100,
		drift = math.random(-18, 18) / 100,
		rotSpeed = math.random(-35, 35)
	}
end

-- // snowmen
local snowmen = {}
local snowmanPositions = {
	{0.10, 0.78}, {0.90, 0.76}, {0.15, 0.20}, {0.85, 0.18},
	{0.06, 0.48}, {0.94, 0.50}, {0.22, 0.90}, {0.78, 0.88}
}

for i, pos in ipairs(snowmanPositions) do
	local snowman = Instance.new("TextLabel")
	snowman.Name = "Snowman"
	snowman.BackgroundTransparency = 1
	snowman.Text = "⛄"
	snowman.TextSize = math.random(30, 44)
	snowman.TextTransparency = 0.1
	snowman.Size = UDim2.fromOffset(50, 50)
	snowman.AnchorPoint = Vector2.new(0.5, 0.5)
	snowman.Position = UDim2.fromScale(pos[1], pos[2])
	snowman.ZIndex = 3
	snowman.Parent = Background

	snowmen[i] = {
		label = snowman,
		baseY = pos[2],
		offset = math.random() * math.pi * 2,
		bobSpeed = math.random(7, 13) / 10
	}
end

-- // fade in
local fadeInfo = TweenInfo.new(1.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
TweenService:Create(ImageLabel, fadeInfo, {ImageTransparency = 0}):Play()
TweenService:Create(Title, fadeInfo, {TextTransparency = 0}):Play()
TweenService:Create(Hint, fadeInfo, {TextTransparency = 0}):Play()

task.delay(0.25, function()
	SoundHolder:Play()
end)

-- // animation
local hue = 0
local startTime = tick()
local animConn

animConn = RunService.RenderStepped:Connect(function(dt)
	hue = (hue + dt * 0.32) % 1
	Title.TextColor3 = Color3.fromHSV(hue, 0.8, 1)

	local t = tick() - startTime

	for _, s in ipairs(snowflakes) do
		local pos = s.label.Position
		local newY = pos.Y.Scale + s.speed * dt * 0.32
		local newX = pos.X.Scale + s.drift * dt * 0.14

		if newY > 1.1 then
			newY = -0.08
			newX = math.random()
		end
		if newX < -0.05 then newX = 1.05 end
		if newX > 1.05 then newX = -0.05 end

		s.label.Position = UDim2.new(newX, 0, newY, 0)
		s.label.Rotation = s.label.Rotation + s.rotSpeed * dt
	end

	for _, sm in ipairs(snowmen) do
		local bob = math.sin(t * sm.bobSpeed + sm.offset) * 0.011
		sm.label.Position = UDim2.fromScale(sm.label.Position.X.Scale, sm.baseY + bob)
	end
end)

-- // close
local closed = false
local function closeIntro()
	if closed then return end
	closed = true
	if animConn then animConn:Disconnect() end

	local outInfo = TweenInfo.new(0.85, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
	TweenService:Create(ImageLabel, outInfo, {ImageTransparency = 1}):Play()
	TweenService:Create(Title, outInfo, {TextTransparency = 1}):Play()
	TweenService:Create(Hint, outInfo, {TextTransparency = 1}):Play()
	TweenService:Create(Background, outInfo, {BackgroundTransparency = 1}):Play()

	task.delay(0.95, function()
		ScreenGui:Destroy()
		AssetFolder:Destroy()
		pcall(delfile, "haz_logo.png")
		pcall(delfile, "haz_theme.mp3")
	end)
end

local function connectClick(obj)
	obj.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			closeIntro()
		end
	end)
end

connectClick(Background)
connectClick(ImageLabel)
connectClick(Title)
connectClick(Hint)