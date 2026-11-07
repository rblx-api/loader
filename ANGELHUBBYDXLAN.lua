-- ANGEL HUB FARM

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = game:GetService("Players").LocalPlayer
local func6
local SoundService = game:GetService("SoundService")
local sound = Instance.new("Sound")
sound.Name = "SB_IntroSound"
sound.SoundId = "rbxassetid://5447057472"
sound.Volume = 0.5
sound.Looped = false
sound.Parent = SoundService
local sound1 = Instance.new("Sound")
sound1.Name = "SB_BgMusic"
sound1.SoundId = "rbxassetid://113169105768074"
sound1.Volume = 0.4
sound1.Looped = true
sound1.Parent = SoundService
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AccessOverlayUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
	screenGui.Parent = CoreGui
end)

if not screenGui.Parent then
	screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local frame = Instance.new("Frame")
frame.Name = "MainCanvas"
frame.Size = UDim2.new(1, 0, 1, 0)
frame.Position = UDim2.new(0, 0, 0, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0
frame.Parent = screenGui
local frame1 = Instance.new("Frame")
frame1.Name = "IntroTextContainer"
frame1.Size = UDim2.new(1, 0, 0, 80)
frame1.Position = UDim2.new(0.5, 0, 0.5, 0)
frame1.AnchorPoint = Vector2.new(0.5, 0.5)
frame1.BackgroundTransparency = 1
frame1.Parent = frame
local textLabel = Instance.new("TextLabel")
textLabel.Name = "IntroTextLabel"
textLabel.Size = UDim2.new(1, 0, 1, 0)
textLabel.Position = UDim2.new(0, 0, 0, 0)
textLabel.BackgroundTransparency = 1
textLabel.RichText = true
textLabel.Text = 'ANGEL <font color="rgb(160, 32, 240)">HUB FARM</font>'
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextSize = 36
textLabel.Font = Enum.Font.Garamond
textLabel.TextTransparency = 1
textLabel.TextScaled = true
textLabel.Parent = frame1
local uITextSizeConstraint = Instance.new("UITextSizeConstraint")
uITextSizeConstraint.MaxTextSize = 42
uITextSizeConstraint.MinTextSize = 20
uITextSizeConstraint.Parent = textLabel
local frame2 = Instance.new("Frame")
frame2.Name = "Card"
frame2.Size = UDim2.new(0.9, 0, 0.9, 0)
frame2.Position = UDim2.new(0.5, 0, 0.42, 0)
frame2.AnchorPoint = Vector2.new(0.5, 0.5)
frame2.BackgroundTransparency = 1
frame2.Visible = false
frame2.Parent = frame
local uISizeConstraint = Instance.new("UISizeConstraint")
uISizeConstraint.MaxSize = Vector2.new(420, 380)
uISizeConstraint.MinSize = Vector2.new(280, 280)
uISizeConstraint.Parent = frame2
local uIListLayout = Instance.new("UIListLayout")
uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
uIListLayout.Padding = UDim.new(0, 10)
uIListLayout.Parent = frame2
local textLabel1 = Instance.new("TextLabel")
textLabel1.Name = "CreditsLabel"
textLabel1.LayoutOrder = 0
textLabel1.Size = UDim2.new(1, 0, 0, 20)
textLabel1.BackgroundTransparency = 1
textLabel1.RichText = true
textLabel1.Text = '<font color="rgb(0, 255, 120)"><b>ANGEL HUB</b></font> | @carlosvlq02'
textLabel1.TextColor3 = Color3.fromRGB(200, 200, 200)
textLabel1.TextSize = 12
textLabel1.Font = Enum.Font.SourceSansBold
textLabel1.TextTransparency = 1
textLabel1.Parent = frame2
local textLabel2 = Instance.new("TextLabel")
textLabel2.Name = "BrandLabel"
textLabel2.LayoutOrder = 1
textLabel2.Size = UDim2.new(1, 0, 0, 28)
textLabel2.BackgroundTransparency = 1
textLabel2.RichText = true
textLabel2.Text = 'ANGEL HUB FARM'
textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel2.TextSize = 24
textLabel2.Font = Enum.Font.Garamond
textLabel2.TextTransparency = 1
textLabel2.Parent = frame2
local textLabel3 = Instance.new("TextLabel")
textLabel3.Name = "TitleLabel"
textLabel3.LayoutOrder = 2
textLabel3.Size = UDim2.new(1, 0, 0, 28)
textLabel3.BackgroundTransparency = 1
textLabel3.Text = "Script Actualizado el 12/10/26"
textLabel3.TextColor3 = Color3.fromRGB(245, 245, 245)
textLabel3.TextSize = 20
textLabel3.Font = Enum.Font.Garamond
textLabel3.TextScaled = false
textLabel3.TextWrapped = true
textLabel3.TextTransparency = 1
textLabel3.Parent = frame2
local textLabel4 = Instance.new("TextLabel")
textLabel4.Name = "SubtitleLabel"
textLabel4.LayoutOrder = 3
textLabel4.Size = UDim2.new(1, 0, 0, 18)
textLabel4.BackgroundTransparency = 1
textLabel4.Text = "Ingrese contraseña por favor"
textLabel4.TextColor3 = Color3.fromRGB(140, 140, 145)
textLabel4.TextSize = 14
textLabel4.Font = Enum.Font.SourceSans
textLabel4.TextScaled = false
textLabel4.TextTransparency = 1
textLabel4.Parent = frame2
local frame3 = Instance.new("Frame")
frame3.Name = "Spacer"
frame3.LayoutOrder = 4
frame3.Size = UDim2.new(1, 0, 0, 4)
frame3.BackgroundTransparency = 1
frame3.Parent = frame2
local frame4 = Instance.new("Frame")
frame4.Name = "InputContainer"
frame4.LayoutOrder = 5
frame4.Size = UDim2.new(1, 0, 0, 48)
frame4.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
frame4.BorderSizePixel = 0
frame4.BackgroundTransparency = 1
frame4.Parent = frame2
local uICorner = Instance.new("UICorner")
uICorner.CornerRadius = UDim.new(0, 8)
uICorner.Parent = frame4
local uIStroke = Instance.new("UIStroke")
uIStroke.Color = Color3.fromRGB(40, 40, 48)
uIStroke.Thickness = 1
uIStroke.Transparency = 1
uIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uIStroke.Parent = frame4
local textLabel5 = Instance.new("TextLabel")
textLabel5.Name = "DisplayLabel"
textLabel5.Size = UDim2.new(1, -24, 1, 0)
textLabel5.Position = UDim2.new(0, 12, 0, 0)
textLabel5.BackgroundTransparency = 1
textLabel5.Text = ""
textLabel5.TextColor3 = Color3.fromRGB(230, 230, 230)
textLabel5.TextSize = 15
textLabel5.Font = Enum.Font.SourceSans
textLabel5.TextXAlignment = Enum.TextXAlignment.Left
textLabel5.TextTransparency = 1
textLabel5.ZIndex = 2
textLabel5.Parent = frame4
local textBox = Instance.new("TextBox")
textBox.Name = "RealInput"
textBox.Size = UDim2.new(1, 0, 1, 0)
textBox.Position = UDim2.new(0, 0, 0, 0)
textBox.BackgroundTransparency = 1
textBox.Text = ""
textBox.PlaceholderText = ""
textBox.TextColor3 = Color3.fromRGB(0, 0, 0)
textBox.TextTransparency = 1
textBox.CursorPosition = -1
textBox.ClearTextOnFocus = false
textBox.Font = Enum.Font.SourceSans
textBox.TextSize = 15
textBox.ZIndex = 3
textBox.Parent = frame4
local textLabel6 = Instance.new("TextLabel")
textLabel6.Name = "PlaceholderLabel"
textLabel6.Size = UDim2.new(1, -24, 1, 0)
textLabel6.Position = UDim2.new(0, 12, 0, 0)
textLabel6.BackgroundTransparency = 1
textLabel6.Text = "Contraseña..."
textLabel6.TextColor3 = Color3.fromRGB(80, 80, 88)
textLabel6.TextSize = 15
textLabel6.Font = Enum.Font.SourceSans
textLabel6.TextXAlignment = Enum.TextXAlignment.Left
textLabel6.TextTransparency = 1
textLabel6.ZIndex = 1
textLabel6.Parent = frame4
local textLabel7 = Instance.new("TextLabel")
textLabel7.Name = "ErrorLabel"
textLabel7.LayoutOrder = 6
textLabel7.Size = UDim2.new(1, 0, 0, 16)
textLabel7.BackgroundTransparency = 1
textLabel7.Text = ""
textLabel7.TextColor3 = Color3.fromRGB(180, 70, 70)
textLabel7.TextSize = 13
textLabel7.Font = Enum.Font.SourceSans
textLabel7.TextTransparency = 1
textLabel7.Parent = frame2
local textButton = Instance.new("TextButton")
textButton.Name = "SubmitButton"
textButton.LayoutOrder = 7
textButton.Size = UDim2.new(1, 0, 0, 48)
textButton.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
textButton.BorderSizePixel = 0
textButton.Text = "Confirmar"
textButton.TextColor3 = Color3.fromRGB(220, 220, 225)
textButton.TextSize = 15
textButton.Font = Enum.Font.SourceSansSemibold
textButton.AutoButtonColor = false
textButton.BackgroundTransparency = 1
textButton.TextTransparency = 1
textButton.Parent = frame2
local uICorner1 = Instance.new("UICorner")
uICorner1.CornerRadius = UDim.new(0, 8)
uICorner1.Parent = textButton
local uIStroke1 = Instance.new("UIStroke")
uIStroke1.Color = Color3.fromRGB(50, 50, 60)
uIStroke1.Thickness = 1
uIStroke1.Transparency = 1
uIStroke1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uIStroke1.Parent = textButton

textBox:GetPropertyChangedSignal("Text"):Connect(function()
	local Text = textBox.Text
	textLabel5.Text = string.rep("*", string.len(Text))

	if string.len(Text) > 0 then
		textLabel6.TextTransparency = 1
	else
		textLabel6.TextTransparency = 0
	end
end)

textBox.Focused:Connect(function()
	TweenService:Create(uIStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(90, 90, 105)}):Play()
	TweenService:Create(frame4, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(24, 24, 28)}):Play()
end)

textBox.FocusLost:Connect(function()
	TweenService:Create(uIStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(40, 40, 48)}):Play()
	TweenService:Create(frame4, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 24)}):Play()
end)

local function func()
	TweenService:Create(textButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(32, 32, 38)}):Play()
	TweenService:Create(textButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(220, 220, 225)}):Play()
end

local function func1()
	TweenService:Create(textButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(42, 42, 50)}):Play()
	TweenService:Create(textButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end

textButton.MouseEnter:Connect(func1)
textButton.MouseLeave:Connect(func)

textButton.MouseButton1Down:Connect(function()
	TweenService:Create(textButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(25, 25, 30)}):Play()
end)

textButton.MouseButton1Up:Connect(func1)

local function func2()
	local uDim2 = UDim2.new(0, 12, 0, 0)
	task.spawn(function()
		textLabel5.Position = UDim2.new(0, 18, 0, 0)
		task.wait(0.04)
		textLabel5.Position = UDim2.new(0, 6, 0, 0)
		task.wait(0.04)
		textLabel5.Position = UDim2.new(0, 15, 0, 0)
		task.wait(0.04)
		textLabel5.Position = UDim2.new(0, 9, 0, 0)
		task.wait(0.04)
		textLabel5.Position = uDim2
	end)
end

local function func3(text)
	textLabel7.Text = text
	TweenService:Create(textLabel7, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
	TweenService:Create(uIStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(150, 50, 50)}):Play()
	func2()

	task.delay(2.5, function()
		if textLabel7.Text == text then
			TweenService:Create(textLabel7, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
			TweenService:Create(uIStroke, TweenInfo.new(0.4), {Color = Color3.fromRGB(40, 40, 48)}):Play()
		end
	end)
end

local flag = false

local function func4()
	if flag then
		return
	end

	flag = true

	if sound1 then
		TweenService:Create(sound1, TweenInfo.new(0.5), {Volume = 0}):Play()
		task.delay(0.5, function()
			sound1:Stop()
			sound1:Destroy()
		end)
	end

	local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 1}):Play()
	TweenService:Create(textLabel1, tweenInfo, {TextTransparency = 1}):Play()
	TweenService:Create(textLabel2, tweenInfo, {TextTransparency = 1}):Play()
	TweenService:Create(textLabel3, tweenInfo, {TextTransparency = 1}):Play()
	TweenService:Create(textLabel4, tweenInfo, {TextTransparency = 1}):Play()
	TweenService:Create(frame4, tweenInfo, {BackgroundTransparency = 1}):Play()
	TweenService:Create(textLabel5, tweenInfo, {TextTransparency = 1}):Play()
	TweenService:Create(textLabel6, tweenInfo, {TextTransparency = 1}):Play()
	TweenService:Create(textLabel7, tweenInfo, {TextTransparency = 1}):Play()
	TweenService:Create(textButton, tweenInfo, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
	TweenService:Create(uIStroke, tweenInfo, {Transparency = 1}):Play()
	TweenService:Create(uIStroke1, tweenInfo, {Transparency = 1}):Play()
	task.wait(0.45)

	if screenGui and screenGui.Parent then
		screenGui:Destroy()
	end

	if sound then
		sound:Destroy()
	end
end

local MouseButton1Click = textButton.MouseButton1Click

local function func5()
	local v1 = string.gsub(textBox.Text, "^%s*(.-)%s*$", "%1")

	if v1 == "" then
		func3("Por favor ingrese la contraseña")
		return
	end

	if v1 ~= "ANGEL" then
		func3("Key incorrecta")
		textBox.Text = ""
		return
	end

	func4()
	func6()
end

MouseButton1Click:Connect(func5)

-- Key required

textBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		func5()
	end
end)

task.spawn(function()
	task.wait(0.6)
	sound:Play()
	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(textLabel, tweenInfo, {TextTransparency = 0}):Play()
	task.wait(2.2)
	local tweenInfo1 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(textLabel, tweenInfo1, {TextTransparency = 1})
	tween:Play()
	tween.Completed:Wait()
	frame1:Destroy()
	frame2.Visible = true
	sound1:Play()
	local tweenInfo2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(textLabel1, tweenInfo2, {TextTransparency = 0}):Play()
	TweenService:Create(textLabel2, tweenInfo2, {TextTransparency = 0}):Play()
	TweenService:Create(textLabel3, tweenInfo2, {TextTransparency = 0}):Play()
	TweenService:Create(textLabel4, tweenInfo2, {TextTransparency = 0}):Play()
	task.wait(0.1)
	TweenService:Create(frame4, tweenInfo2, {BackgroundTransparency = 0}):Play()
	TweenService:Create(textLabel5, tweenInfo2, {TextTransparency = 0}):Play()

	if string.len(textBox.Text) == 0 then
		TweenService:Create(textLabel6, tweenInfo2, {TextTransparency = 0}):Play()
	end

	TweenService:Create(uIStroke, tweenInfo2, {Transparency = 0}):Play()
	task.wait(0.1)
	TweenService:Create(textButton, tweenInfo2, {BackgroundTransparency = 0}):Play()
	TweenService:Create(textButton, tweenInfo2, {TextTransparency = 0}):Play()
	TweenService:Create(uIStroke1, tweenInfo2, {Transparency = 0}):Play()
end)

function func6()
	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local VirtualUser = game:GetService("VirtualUser")

	UserInputService.WindowFocusReleased:Connect(function()
		pcall(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
		end)
	end)

	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
	local ClothingGUI = PlayerGui:FindFirstChild("ClothingGUI")

	if ClothingGUI then
		ClothingGUI:Destroy()
	end

	PlayerGui.ChildAdded:Connect(function(child)
		if child.Name == "ClothingGUI" then
			child:Destroy()
		end
	end)

	task.spawn(function()
		local ok, result = pcall(function()
			return ReplicatedStorage:WaitForChild("ClothingShopEvent", 10)
		end)

		if not (ok and result) then
			return
		end

		pcall(function()
			result:FireServer("EQUIP", "Hat", "Gangster Hat+Face")
		end)

		task.wait(0.3)

		pcall(function()
			result:FireServer("EQUIP", "Suit", "Outfit_Sheikh")
		end)
	end)

	local tbl = {
		Sparkles = "rbxassetid://136365218255099",
		Minus = "rbxassetid://94928568214894",
		Maximize = "rbxassetid://131246110913732",
		Close = "rbxassetid://77236530693648",
	}

	local tbl1 = {
		Background = Color3.fromRGB(10, 10, 13),
		Panel = Color3.fromRGB(15, 15, 19),
		Card = Color3.fromRGB(22, 22, 28),
		CardHover = Color3.fromRGB(27, 27, 34),
		Stroke = Color3.fromRGB(42, 42, 51),
		Text = Color3.fromRGB(244, 244, 247),
		Muted = Color3.fromRGB(145, 145, 158),
		Purple = Color3.fromRGB(151, 82, 255),
		Purple2 = Color3.fromRGB(111, 53, 205),
		PurpleSoft = Color3.fromRGB(202, 171, 255),
	}

	local tweenInfo = TweenInfo.new(0.14, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	local tweenInfo1 = TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	local tweenInfo2 = TweenInfo.new(0.42, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	local tbl2 = {}

	local function func()
		for _, v1 in ipairs(tbl2) do
			pcall(function()
				v1:Disconnect()
			end)
		end
		table.clear(tbl2)
	end

	local tbl3 = {UnderDepth = 10}
	local v2

	pcall(function()
		v2 = gethui and gethui():FindFirstChild("DXLANPROYECTHub") or nil
	end)

	if v2 then
		v2:Destroy()
	end

	local v1

	pcall(function()
		if gethui then
			v1 = gethui()
		end
	end)

	v1 = v1 or LocalPlayer:WaitForChild("PlayerGui")
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "DXLANPROYECTHub"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = v1

	local function func1(parent, arg2)
		local uICorner = Instance.new("UICorner")
		uICorner.CornerRadius = UDim.new(0, arg2 or 8)
		uICorner.Parent = parent
		return uICorner
	end

	local function func2(parent, arg2, arg3, arg4)
		local uIStroke = Instance.new("UIStroke")
		uIStroke.Color = arg2 or tbl1.Stroke
		uIStroke.Transparency = arg3 or 0
		uIStroke.Thickness = arg4 or 1
		uIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		uIStroke.Parent = parent
		return uIStroke
	end

	local function func3(parent, arg2, arg3, arg4, arg5)
		local uIPadding = Instance.new("UIPadding")
		uIPadding.PaddingLeft = UDim.new(0, arg2 or 0)
		uIPadding.PaddingRight = UDim.new(0, arg3 or 0)
		uIPadding.PaddingTop = UDim.new(0, arg4 or 0)
		uIPadding.PaddingBottom = UDim.new(0, arg5 or 0)
		uIPadding.Parent = parent
		return uIPadding
	end

	local function func4(parent, image, size, arg4)
		local imageLabel = Instance.new("ImageLabel")
		imageLabel.BackgroundTransparency = 1
		imageLabel.Image = image
		imageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
		imageLabel.Size = size
		imageLabel.Position = arg4 or UDim2.fromOffset(0, 0)
		imageLabel.ScaleType = Enum.ScaleType.Fit
		imageLabel.Parent = parent
		return imageLabel
	end

	local tbl4 = {}

	local function func5(parent, text, textSize, arg4, arg5, arg6)
		local textLabel = Instance.new("TextLabel")
		textLabel.BackgroundTransparency = 1
		textLabel.Text = text
		textLabel.TextSize = textSize
		textLabel.TextColor3 = arg4 or tbl1.Text
		textLabel.Font = arg5 or Enum.Font.GothamMedium
		textLabel.TextXAlignment = arg6 or Enum.TextXAlignment.Left
		textLabel.TextYAlignment = Enum.TextYAlignment.Center
		textLabel.Parent = parent
		return textLabel
	end

	tbl4.Tabs = {}
	tbl4.CurrentTab = nil
	tbl4.Minimized = false
	tbl4.Maximized = false
	tbl4.FloatingPos = UDim2.new(0.88, 0, 0.82, 0)

	function tbl4:CreateWindow()
		local frame = Instance.new("Frame")
		frame.Name = "Main"
		frame.AnchorPoint = Vector2.new(0.5, 0.5)
		frame.Position = UDim2.fromScale(0.5, 0.5)
		frame.Size = UDim2.new(0, 720, 0, 485)
		frame.BackgroundColor3 = tbl1.Background
		frame.BorderSizePixel = 0
		frame.ClipsDescendants = true
		frame.Active = true
		frame.Parent = screenGui
		self.Main = frame
		local uIScale = Instance.new("UIScale")
		uIScale.Parent = frame
		self.Scale = uIScale

		local function func()
			local CurrentCamera = workspace.CurrentCamera

			if not CurrentCamera then
				return
			end

			local ViewportSize = CurrentCamera.ViewportSize
			local v1 = math.clamp(ViewportSize.X / 900, 0.72, 1)
			local v2 = math.clamp(ViewportSize.Y / 620, 0.7, 1)
			uIScale.Scale = math.min(v1, v2)
		end

		local connection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(func)
		table.insert(tbl2, connection)

		if workspace.CurrentCamera then
			local connection1 = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(func)
			table.insert(tbl2, connection1)
		end

		func()
		frame.Size = UDim2.new(0, 650, 0, 430)
		frame.BackgroundTransparency = 1
		local tbl3 = {Size = UDim2.new(0, 720, 0, 485), BackgroundTransparency = 0}
		TweenService:Create(frame, tweenInfo2, tbl3):Play()
		local frame1 = Instance.new("Frame")
		frame1.Name = "Header"
		frame1.Size = UDim2.new(1, 0, 0, 66)
		frame1.BackgroundColor3 = tbl1.Panel
		frame1.BorderSizePixel = 0
		frame1.Active = true
		frame1.Parent = frame
		local frame2 = Instance.new("Frame")
		frame2.Size = UDim2.new(1, -36, 0, 1)
		frame2.Position = UDim2.new(0, 18, 1, -1)
		frame2.BackgroundColor3 = tbl1.Stroke
		frame2.BorderSizePixel = 0
		frame2.Parent = frame1
		local frame3 = Instance.new("Frame")
		frame3.BackgroundTransparency = 1
		frame3.Position = UDim2.fromOffset(20, 0)
		frame3.Size = UDim2.new(0, 320, 1, 0)
		frame3.Parent = frame1
		local FredokaOne = Enum.Font.FredokaOne
		local v1 = func5(frame3, "DXLAN", 21, tbl1.Text, FredokaOne)
		v1.Position = UDim2.fromOffset(0, 8)
		v1.Size = UDim2.fromOffset(48, 30)
		local v2 = func5(frame3, "Boy", 21, tbl1.Purple, FredokaOne)
		v2.Position = UDim2.fromOffset(48, 8)
		v2.Size = UDim2.fromOffset(42, 30)
		local frame4 = Instance.new("Frame")
		frame4.Position = UDim2.fromOffset(92, 11)
		frame4.Size = UDim2.fromOffset(42, 24)
		frame4.BackgroundColor3 = tbl1.Purple2
		frame4.Parent = frame3
		func1(frame4, 7)
		local color3 = Color3.new(1, 1, 1)
		func5(frame4, "Hub", 11, color3, Enum.Font.GothamBold, Enum.TextXAlignment.Center).Size = UDim2.fromScale(1, 1)
		local v3 = func5(frame3, "AutoFarm Pesca by @carlosvlq02", 10, tbl1.Muted, Enum.Font.GothamMedium)
		v3.Position = UDim2.fromOffset(0, 38)
		v3.Size = UDim2.fromOffset(250, 16)
		local frame5 = Instance.new("Frame")
		frame5.BackgroundTransparency = 1
		frame5.AnchorPoint = Vector2.new(1, 0)
		frame5.Position = UDim2.new(1, -14, 0, 13)
		frame5.Size = UDim2.fromOffset(105, 40)
		frame5.Parent = frame1

		local function func6(arg1, arg2, arg3)
			local textButton = Instance.new("TextButton")
			textButton.Text = ""
			textButton.AutoButtonColor = false
			textButton.Size = UDim2.fromOffset(32, 32)
			textButton.BackgroundColor3 = tbl1.Card
			textButton.Parent = frame5
			func1(textButton, 8)
			func2(textButton, tbl1.Stroke, 0, 1)
			local v1 = func4(textButton, arg1, UDim2.fromOffset(14, 14), UDim2.fromOffset(9, 9))
			v1.ImageColor3 = tbl1.Muted

			local connection = textButton.MouseEnter:Connect(function()
				TweenService:Create(textButton, tweenInfo, {BackgroundColor3 = tbl1.CardHover}):Play()
				TweenService:Create(v1, tweenInfo, {ImageColor3 = arg3 or tbl1.Text}):Play()
			end)

			table.insert(tbl2, connection)

			local connection1 = textButton.MouseLeave:Connect(function()
				TweenService:Create(textButton, tweenInfo, {BackgroundColor3 = tbl1.Card}):Play()
				TweenService:Create(v1, tweenInfo, {ImageColor3 = tbl1.Muted}):Play()
			end)

			table.insert(tbl2, connection1)

			local connection2 = textButton.MouseButton1Down:Connect(function()
				local tbl = {Size = UDim2.fromOffset(29, 29)}
				TweenService:Create(textButton, tweenInfo, tbl):Play()
			end)

			table.insert(tbl2, connection2)

			local connection3 = textButton.MouseButton1Up:Connect(function()
				local tbl = {Size = UDim2.fromOffset(32, 32)}
				TweenService:Create(textButton, tweenInfo, tbl):Play()
			end)

			table.insert(tbl2, connection3)
			local connection4 = textButton.Activated:Connect(arg2)
			table.insert(tbl2, connection4)
			return textButton, v1
		end

		func6(tbl.Minus, function()
			self:Minimize()
		end).Position = UDim2.fromOffset(0, 0)

		func6(tbl.Maximize, function()
			self:ToggleMaximize()
		end).Position = UDim2.fromOffset(36, 0)

		func6(tbl.Close, function()
			self:ConfirmClose()
		end).Position = UDim2.fromOffset(72, 0)

		local frame6 = Instance.new("Frame")
		frame6.Name = "Body"
		frame6.Position = UDim2.fromOffset(0, 66)
		frame6.Size = UDim2.new(1, 0, 1, -66)
		frame6.BackgroundTransparency = 1
		frame6.Active = true
		frame6.ClipsDescendants = true
		frame6.Parent = frame
		self.Body = frame6
		local frame7 = Instance.new("Frame")
		frame7.Name = "Sidebar"
		frame7.Size = UDim2.new(0, 72, 1, 0)
		frame7.BackgroundColor3 = tbl1.Panel
		frame7.BorderSizePixel = 0
		frame7.Active = true
		frame7.Parent = frame6
		func3(frame7, 12, 12, 14, 12)
		local uIListLayout = Instance.new("UIListLayout")
		uIListLayout.Padding = UDim.new(0, 9)
		uIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uIListLayout.Parent = frame7
		self.Sidebar = frame7
		local frame8 = Instance.new("Frame")
		frame8.Name = "Content"
		frame8.Position = UDim2.fromOffset(72, 0)
		frame8.Size = UDim2.new(1, -72, 1, 0)
		frame8.BackgroundColor3 = tbl1.Background
		frame8.BorderSizePixel = 0
		frame8.ClipsDescendants = true
		frame8.Active = true
		frame8.Parent = frame6
		self.Content = frame8
		local uIStroke = Instance.new("UIStroke")
		uIStroke.Name = "AnimatedGlowStroke"
		uIStroke.Thickness = 1.5
		uIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		uIStroke.Color = Color3.fromRGB(255, 255, 255)
		uIStroke.Parent = frame
		local uIGradient = Instance.new("UIGradient")

		uIGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, tbl1.Stroke),
			ColorSequenceKeypoint.new(0.45, tbl1.Purple),
			ColorSequenceKeypoint.new(0.55, tbl1.PurpleSoft),
			ColorSequenceKeypoint.new(1, tbl1.Stroke),
		})

		uIGradient.Parent = uIStroke

		local connection2 = RunService.RenderStepped:Connect(function(deltaTime)
			if frame and frame.Parent then
				uIGradient.Rotation = (uIGradient.Rotation + deltaTime * 60) % 360
			end
		end)

		table.insert(tbl2, connection2)
		self:_SetupDragging(frame1)
		return self
	end

	function tbl4:_SetupDragging(arg2)
		local flag = false
		local Position
		local Position1

		local function func(arg1)
			if arg1.UserInputType == Enum.UserInputType.MouseButton1 or arg1.UserInputType == Enum.UserInputType.Touch then
				if not self.Maximized then
					flag = true
					Position = arg1.Position
					Position1 = self.Main.Position
				end
			end
		end

		local function func1(arg1)
			if not flag then
				return
			end

			local v1 = arg1.Position - Position
			local CurrentCamera = workspace.CurrentCamera

			if not CurrentCamera then
				return
			end

			local ViewportSize = CurrentCamera.ViewportSize
			local v2 = Position1.X.Offset + v1.X
			local v3 = Position1.Y.Offset + v1.Y
			local v4 = self.Main.AbsoluteSize.X / 2
			local v5 = self.Main.AbsoluteSize.Y / 2
			local v6 = -ViewportSize.X / 2 + v4
			local X = ViewportSize.X
			local v7 = v6 - 8
			local v8 = X / 2 - v4
			local Y = ViewportSize.Y
			local v9 = v8 + 8
			local v10 = -Y / 2 + v5 - 8
			local v11 = ViewportSize.Y / 2 - v5 + 8
			local v12 = math.clamp(v2, v7, v9)
			local v13 = math.clamp(v3, v10, v11)
			self.Main.Position = UDim2.new(0.5, v12, 0.5, v13)
		end

		local connection = arg2.InputBegan:Connect(func)
		table.insert(tbl2, connection)

		local connection1 = UserInputService.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				func1(input)
			end
		end)

		table.insert(tbl2, connection1)

		local connection2 = UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				flag = false
			end
		end)

		table.insert(tbl2, connection2)
	end

	function tbl4:Minimize()
		if self.Minimized then
			return
		end

		self.Minimized = true

		if self.Main then
			local Main = self.Main
			local tbl = {Size = UDim2.new(0, 720, 0, 0), BackgroundTransparency = 1}
			TweenService:Create(Main, tweenInfo1, tbl):Play()
		end

		task.delay(0.18, function()
			if self.Main then
				self.Main.Visible = false
			end
			self:_CreateFloating()
		end)
	end

	function tbl4:_CreateFloating()
		if self.Floating then
			return
		end

		local textButton = Instance.new("TextButton")
		textButton.Name = "FloatingDXLANPROYECT"
		textButton.Text = ""
		textButton.AutoButtonColor = false
		textButton.AnchorPoint = Vector2.new(0.5, 0.5)
		textButton.Position = self.FloatingPos
		textButton.Size = UDim2.fromOffset(62, 62)
		textButton.BackgroundColor3 = tbl1.Panel
		textButton.Active = true
		textButton.Parent = screenGui
		func1(textButton, 18)
		func2(textButton, tbl1.Purple2, 0, 1.5)
		local imageLabel = Instance.new("ImageLabel")
		imageLabel.Name = "CustomLogo"
		imageLabel.BackgroundTransparency = 1
		imageLabel.Size = UDim2.fromOffset(42, 42)
		imageLabel.Position = UDim2.fromOffset(10, 10)
		imageLabel.ScaleType = Enum.ScaleType.Fit
		imageLabel.Parent = textButton

		pcall(function()
			if writefile and getcustomasset then
				if not isfile("DXLANPROYECTLogo.png") then
					writefile(
						"DXLANPROYECTLogo.png",
						game:HttpGet("https://raw.githubusercontent.com/moisess011/dxlanproyecthub/main/logo2.png")
					)
				end
				imageLabel.Image = getcustomasset("DXLANPROYECTLogo.png")
			else
				imageLabel.Image = "https://raw.githubusercontent.com/moisess011/dxlanproyecthub/main/logo2.png"
			end
		end)

		self.Floating = textButton

		local connection = textButton.MouseEnter:Connect(function()
			local tbl = {Size = UDim2.fromOffset(67, 67)}
			TweenService:Create(textButton, tweenInfo, tbl):Play()
			local tbl1 = {Size = UDim2.fromOffset(46, 46), Position = UDim2.fromOffset(10, 10)}
			TweenService:Create(imageLabel, tweenInfo, tbl1):Play()
		end)

		table.insert(tbl2, connection)

		local connection1 = textButton.MouseLeave:Connect(function()
			local tbl = {Size = UDim2.fromOffset(62, 62)}
			TweenService:Create(textButton, tweenInfo, tbl):Play()
			local tbl1 = {Size = UDim2.fromOffset(42, 42), Position = UDim2.fromOffset(10, 10)}
			TweenService:Create(imageLabel, tweenInfo, tbl1):Play()
		end)

		table.insert(tbl2, connection1)

		local connection2 = textButton.Activated:Connect(function()
			self:Restore()
		end)

		table.insert(tbl2, connection2)
		local flag = false
		local Position
		local Position1

		local connection3 = textButton.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				flag, Position = true, input.Position
				Position1 = textButton.Position
			end
		end)

		table.insert(tbl2, connection3)

		local connection4 = UserInputService.InputChanged:Connect(function(input)
			if not flag then
				return
			end

			if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			local v1 = input.Position - Position
			local ViewportSize = workspace.CurrentCamera.ViewportSize
			local clamp = math.clamp
			local Offset = Position1.X.Offset
			local X = v1.X
			local X1 = ViewportSize.X
			local v2 = clamp(Offset + X, -X1 / 2 + 40, ViewportSize.X / 2 - 40)
			local clamp1 = math.clamp
			local Y = ViewportSize.Y
			local v3 = Position1.Y.Offset + v1.Y
			local v4 = -Y / 2
			local Y1 = ViewportSize.Y
			local v5 = clamp1(v3, v4 + 40, Y1 / 2 - 40)
			local uDim2 = UDim2.new(0.5, v2, 0.5, v5)
			textButton.Position = uDim2
			self.FloatingPos = uDim2
		end)

		table.insert(tbl2, connection4)

		local connection5 = UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				flag = false
			end
		end)

		table.insert(tbl2, connection5)
	end

	function tbl4:Restore()
		if not self.Minimized then
			return
		end

		self.Minimized = false

		if self.Floating then
			self.Floating:Destroy()
			self.Floating = nil
		end

		self.Main.Visible = true
		self.Main.Size = UDim2.new(0, 720, 0, 0)
		self.Main.BackgroundTransparency = 1
		local Main = self.Main

		local tbl = {
			Size = self.Maximized and UDim2.new(0, 860, 0, 560) or UDim2.new(0, 720, 0, 485),
			BackgroundTransparency = 0,
		}

		TweenService:Create(Main, tweenInfo2, tbl):Play()
	end

	function tbl4:ToggleMaximize()
		if self.Minimized then
			return
		end

		self.Maximized = not self.Maximized

		if self.Maximized then
			local Main = self.Main
			local tbl = {Size = UDim2.new(0, 860, 0, 560), Position = UDim2.fromScale(0.5, 0.5)}
			TweenService:Create(Main, tweenInfo2, tbl):Play()
		else
			local Main1 = self.Main
			local tbl1 = {Size = UDim2.new(0, 720, 0, 485), Position = UDim2.fromScale(0.5, 0.5)}
			TweenService:Create(Main1, tweenInfo2, tbl1):Play()
		end
	end

	function tbl4:Close()
		func()

		if self.Floating then
			self.Floating:Destroy()
		end

		local Main = self.Main
		local tbl = {Size = UDim2.new(0, 650, 0, 0), BackgroundTransparency = 1}
		local tween = TweenService:Create(Main, tweenInfo1, tbl)
		tween:Play()

		tween.Completed:Connect(function()
			if screenGui then
				screenGui:Destroy()
			end
		end)
	end

	function tbl4:ConfirmClose()
		if screenGui:FindFirstChild("SB_CloseConfirm") then
			return
		end

		local frame = Instance.new("Frame")
		frame.Name = "SB_CloseConfirm"
		frame.Size = UDim2.fromScale(1, 1)
		frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		frame.BackgroundTransparency = 0.45
		frame.ZIndex = 200
		frame.Parent = screenGui
		local frame1 = Instance.new("Frame")
		frame1.Size = UDim2.fromOffset(300, 150)
		frame1.Position = UDim2.fromScale(0.5, 0.5)
		frame1.AnchorPoint = Vector2.new(0.5, 0.5)
		frame1.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
		frame1.BorderSizePixel = 0
		frame1.ZIndex = 201
		frame1.Parent = frame
		func1(frame1, 14)
		func2(frame1, Color3.fromRGB(80, 60, 120), 1, 0)
		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(1, -24, 0, 28)
		textLabel.Position = UDim2.fromOffset(12, 16)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = "Cerrar DXLAN PROYECT?"
		textLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
		textLabel.TextSize = 16
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.ZIndex = 202
		textLabel.Parent = frame1
		local textLabel1 = Instance.new("TextLabel")
		textLabel1.Size = UDim2.new(1, -24, 0, 36)
		textLabel1.Position = UDim2.fromOffset(12, 48)
		textLabel1.BackgroundTransparency = 1
		textLabel1.Text = "Se cierra el menu y se apagan las funciones activas."
		textLabel1.TextColor3 = Color3.fromRGB(150, 150, 160)
		textLabel1.TextSize = 12
		textLabel1.Font = Enum.Font.Gotham
		textLabel1.TextWrapped = true
		textLabel1.TextXAlignment = Enum.TextXAlignment.Left
		textLabel1.ZIndex = 202
		textLabel1.Parent = frame1

		local function func(text, arg2, backgroundColor3, arg4)
			local textButton = Instance.new("TextButton")
			textButton.Size = UDim2.fromOffset(120, 34)
			textButton.Position = UDim2.new(0, arg2, 1, -48)
			textButton.BackgroundColor3 = backgroundColor3
			textButton.BorderSizePixel = 0
			textButton.Text = text
			textButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			textButton.TextSize = 13
			textButton.Font = Enum.Font.GothamSemibold
			textButton.AutoButtonColor = false
			textButton.ZIndex = 202
			textButton.Parent = frame1
			func1(textButton, 8)
			textButton.Activated:Connect(arg4)
			return textButton
		end

		func("Cancelar", 20, Color3.fromRGB(40, 40, 48), function()
			frame:Destroy()
		end)

		func("Cerrar", 160, Color3.fromRGB(160, 50, 80), function()
			frame:Destroy()
			self:Close()
		end)
	end

	function tbl4:CreateTab(arg2, arg3, arg4)
		local tbl3 = {Id = arg2, Title = arg4 or arg2, Buttons = {}}
		local textButton = Instance.new("TextButton")
		textButton.Name = "Tab_" .. arg2
		textButton.Text = ""
		textButton.AutoButtonColor = false
		textButton.Size = UDim2.fromOffset(46, 44)
		textButton.BackgroundColor3 = tbl1.Panel
		textButton.Parent = self.Sidebar
		func1(textButton, 11)
		local v1 = func2(textButton, tbl1.Stroke, 1, 1)
		local v2 = func4(textButton, arg3 or tbl.Sparkles, UDim2.fromOffset(20, 20), UDim2.fromOffset(13, 12))
		v2.ImageColor3 = tbl1.Muted
		tbl3.Button = textButton
		tbl3.Icon = v2
		tbl3.Stroke = v1

		local connection = textButton.MouseEnter:Connect(function()
			if self.CurrentTab ~= tbl3 then
				TweenService:Create(textButton, tweenInfo, {BackgroundColor3 = tbl1.CardHover}):Play()
				TweenService:Create(v2, tweenInfo, {ImageColor3 = tbl1.Text}):Play()
			end
		end)

		table.insert(tbl2, connection)

		local connection1 = textButton.MouseLeave:Connect(function()
			if self.CurrentTab ~= tbl3 then
				TweenService:Create(textButton, tweenInfo, {BackgroundColor3 = tbl1.Panel}):Play()
				TweenService:Create(v2, tweenInfo, {ImageColor3 = tbl1.Muted}):Play()
			end
		end)

		table.insert(tbl2, connection1)

		local connection2 = textButton.Activated:Connect(function()
			self:SelectTab(tbl3)
		end)

		table.insert(tbl2, connection2)
		local scrollingFrame = Instance.new("ScrollingFrame")
		scrollingFrame.Name = "Page_" .. arg2
		scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
		scrollingFrame.BackgroundTransparency = 1
		scrollingFrame.BorderSizePixel = 0
		scrollingFrame.ScrollBarThickness = 3
		scrollingFrame.ScrollBarImageColor3 = tbl1.Purple2
		scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
		scrollingFrame.Active = true
		scrollingFrame.ScrollingEnabled = true
		scrollingFrame.ElasticBehavior = Enum.ElasticBehavior.Always
		scrollingFrame.ClipsDescendants = true
		scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
		scrollingFrame.Visible = false
		scrollingFrame.Parent = self.Content
		func3(scrollingFrame, 22, 22, 22, 40)
		local uIListLayout = Instance.new("UIListLayout")
		uIListLayout.Padding = UDim.new(0, 10)
		uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uIListLayout.Parent = scrollingFrame
		tbl3.Page = scrollingFrame
		self.Tabs[arg2] = tbl3

		if not self.CurrentTab then
			self:SelectTab(tbl3)
		end

-- ANGEL HUB FARM
		return tbl3
	end

	function tbl4:SelectTab(currentTab)
		if self.CurrentTab == currentTab then
			return
		end

		local CurrentTab
		self.CurrentTab, CurrentTab = currentTab, self.CurrentTab

		for _, tab in pairs(self.Tabs) do
			local v1 = tab == currentTab
			tab.Page.Visible = v1
			local Button = tab.Button
			local tbl = {BackgroundColor3 = v1 and Color3.fromRGB(34, 24, 48) or tbl1.Panel}
			TweenService:Create(Button, tweenInfo1, tbl):Play()
			TweenService:Create(tab.Icon, tweenInfo1, {ImageColor3 = v1 and tbl1.PurpleSoft or tbl1.Muted}):Play()

			TweenService:Create(
				tab.Stroke,
				tweenInfo1,
				{Transparency = v1 and 0.25 or 1, Color = v1 and tbl1.Purple2 or tbl1.Stroke}
			):Play()
		end

		if CurrentTab and CurrentTab.Page then
			CurrentTab.Page.Position = UDim2.fromOffset(-8, 0)
			local Page = CurrentTab.Page
			local tbl2 = {Position = UDim2.fromOffset(0, 0)}
			TweenService:Create(Page, tweenInfo, tbl2):Play()
		end
	end

	function tbl4:CreateLabel(parent, arg3, arg4)
		local frame = Instance.new("Frame")
		frame.BackgroundTransparency = 1
		frame.Size = UDim2.new(1, 0, 0, arg4 and 44 or 28)
		frame.Parent = parent
		func5(frame, arg3, 19, tbl1.Text, Enum.Font.GothamBold).Size = UDim2.new(1, 0, 0, 25)

		if arg4 then
			local v1 = func5(frame, arg4, 11, tbl1.Muted, Enum.Font.GothamMedium)
			v1.Position = UDim2.fromOffset(0, 25)
			v1.Size = UDim2.new(1, 0, 0, 18)
		end

		return frame
	end

	function tbl4.CreateDivider(_, parent, arg3)
		local frame = Instance.new("Frame")
		frame.BackgroundTransparency = 1
		frame.Size = UDim2.new(1, 0, 0, 30)
		frame.Parent = parent
		local frame1 = Instance.new("Frame")
		frame1.BackgroundColor3 = tbl1.Stroke
		frame1.BorderSizePixel = 0
		frame1.Position = UDim2.new(0, 0, 0.55, 0)
		frame1.Size = UDim2.new(1, 0, 0, 1)
		frame1.Parent = frame

		if arg3 then
			local frame2 = Instance.new("Frame")
			frame2.BackgroundColor3 = tbl1.Background
			frame2.Size = UDim2.fromOffset(120, 22)
			frame2.Position = UDim2.fromOffset(0, 4)
			frame2.Parent = frame
			func5(frame2, arg3:upper(), 9, tbl1.Muted, Enum.Font.GothamBold).Size = UDim2.fromScale(1, 1)
		end

		return frame
	end

	function tbl4:CreateSection(parent, arg3, arg4)
		local frame = Instance.new("Frame")
		frame.BackgroundColor3 = tbl1.Panel
		frame.Size = UDim2.new(1, 0, 0, 0)
		frame.AutomaticSize = Enum.AutomaticSize.Y
		frame.ClipsDescendants = false
		frame.Parent = parent
		func1(frame, 11)
		func2(frame, tbl1.Stroke, 0, 1)
		func3(frame, 12, 12, 12, 12)
		local frame1 = Instance.new("Frame")
		frame1.BackgroundTransparency = 1
		frame1.Size = UDim2.new(1, 0, 0, arg4 and 43 or 26)
		frame1.Parent = frame
		func5(frame1, arg3, 13, tbl1.Text, Enum.Font.GothamBold).Size = UDim2.new(1, 0, 0, 22)

		if arg4 then
			local v1 = func5(frame1, arg4, 10, tbl1.Muted, Enum.Font.GothamMedium)
			v1.Position = UDim2.fromOffset(0, 21)
			v1.Size = UDim2.new(1, 0, 0, 18)
		end

		local uIListLayout = Instance.new("UIListLayout")
		uIListLayout.Padding = UDim.new(0, 8)
		uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uIListLayout.Parent = frame
		frame1.LayoutOrder = 0
		return frame
	end

	function tbl4:CreateButton(parent, arg3)
		local v1 = arg3.IsToggle ~= false
		local textButton = Instance.new("TextButton")
		textButton.Name = arg3.Name or arg3.Title or "Button"
		textButton.Text = ""
		textButton.AutoButtonColor = false
		textButton.Size = UDim2.new(1, 0, 0, 62)
		textButton.BackgroundColor3 = tbl1.Card
		textButton.Parent = parent
		func1(textButton, 9)
		local v2 = func2(textButton, tbl1.Stroke, 0, 1)
		local v3 = func4(textButton, arg3.Icon or tbl.Sparkles, UDim2.fromOffset(22, 22), UDim2.fromOffset(14, 20))
		v3.ImageColor3 = tbl1.PurpleSoft
		local v4 = func5(textButton, arg3.Title or "Demo Button", 12, tbl1.Text, Enum.Font.GothamBold)
		v4.Position = UDim2.fromOffset(50, 9)
		v4.Size = UDim2.new(1, -140, 0, 20)
		local v5 = func5(textButton, arg3.Description or "", 9, tbl1.Muted, Enum.Font.GothamMedium)
		v5.Position = UDim2.fromOffset(50, 29)
		v5.Size = UDim2.new(1, v1 and -140 or -60, 0, 18)
		local v6 = func5(textButton, "OFF", 8, tbl1.Muted, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
		v6.Position = UDim2.new(1, -78, 0, 22)
		v6.Size = UDim2.fromOffset(58, 18)
		v6.Visible = v1
		local frame = Instance.new("Frame")
		frame.Size = UDim2.fromOffset(3, 30)
		frame.Position = UDim2.new(1, -7, 0.5, -15)
		frame.BackgroundColor3 = tbl1.Stroke
		frame.BorderSizePixel = 0
		frame.Visible = v1
		frame.Parent = textButton
		func1(frame, 2)

		local connection = textButton.MouseEnter:Connect(function()
			TweenService:Create(textButton, tweenInfo, {BackgroundColor3 = tbl1.CardHover}):Play()
			TweenService:Create(v2, tweenInfo, {Color = tbl1.Purple2, Transparency = 0.45}):Play()
		end)

		table.insert(tbl2, connection)

		local connection1 = textButton.MouseLeave:Connect(function()
			TweenService:Create(textButton, tweenInfo, {BackgroundColor3 = tbl1.Card}):Play()
			TweenService:Create(v2, tweenInfo, {Color = tbl1.Stroke, Transparency = 0}):Play()
		end)

		table.insert(tbl2, connection1)

		local connection2 = textButton.MouseButton1Down:Connect(function()
			local tbl = {Size = UDim2.new(1, -2, 0, 60)}
			TweenService:Create(textButton, tweenInfo, tbl):Play()
		end)

		table.insert(tbl2, connection2)

		local connection3 = textButton.MouseButton1Up:Connect(function()
			local tbl = {Size = UDim2.new(1, 0, 0, 62)}
			TweenService:Create(textButton, tweenInfo, tbl):Play()
		end)

		table.insert(tbl2, connection3)
		local v7 = arg3.Default or false

		if v7 and v1 then
			v6.Text = "ON"
			v6.TextColor3 = tbl1.PurpleSoft
			frame.BackgroundColor3 = tbl1.Purple
			v3.ImageColor3 = tbl1.Text
			textButton.BackgroundColor3 = Color3.fromRGB(28, 22, 38)
		end

		local tbl3 = {
			SetState = function(_, arg2)
				v7 = arg2
				if v1 then
					v6.Text = v7 and "ON" or "OFF"
					v6.TextColor3 = v7 and tbl1.PurpleSoft or tbl1.Muted
					frame.BackgroundColor3 = v7 and tbl1.Purple or tbl1.Stroke
					TweenService:Create(v3, tweenInfo, {ImageColor3 = v7 and tbl1.Text or tbl1.PurpleSoft}):Play()
					local tbl = {BackgroundColor3 = v7 and Color3.fromRGB(28, 22, 38) or tbl1.Card}
					TweenService:Create(textButton, tweenInfo, tbl):Play()
				end
			end,
			GetState = function(_)
				return v7
			end,
		}

		local connection4 = textButton.Activated:Connect(function()
			if v1 then
				v7 = not v7
				tbl3:SetState(v7)
			end
			if arg3.Callback then
				pcall(arg3.Callback, v7)
			end
		end)

		table.insert(tbl2, connection4)
		return tbl3
	end

	function tbl4:CreateSlider(parent, arg3)
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 0, 70)
		frame.BackgroundColor3 = tbl1.Card
		frame.Parent = parent
		func1(frame, 9)
		func2(frame, tbl1.Stroke, 0, 1)
		local v1 = func5(frame, arg3.Title or "Slider", 11, tbl1.Text, Enum.Font.GothamBold)
		v1.Position = UDim2.fromOffset(12, 8)
		v1.Size = UDim2.new(1, -90, 0, 20)
		local v2 = func5(frame, "", 10, tbl1.PurpleSoft, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
		v2.Position = UDim2.new(1, -70, 0, 8)
		v2.Size = UDim2.fromOffset(58, 20)
		local v3 = func5(frame, arg3.Description or "", 9, tbl1.Muted, Enum.Font.GothamMedium)
		v3.Position = UDim2.fromOffset(12, 28)
		v3.Size = UDim2.new(1, -24, 0, 16)
		local frame1 = Instance.new("Frame")
		frame1.Position = UDim2.new(0, 12, 1, -16)
		frame1.Size = UDim2.new(1, -24, 0, 4)
		frame1.BackgroundColor3 = tbl1.Stroke
		frame1.BorderSizePixel = 0
		frame1.Parent = frame
		func1(frame1, 3)
		local frame2 = Instance.new("Frame")
		frame2.Size = UDim2.fromScale(0.5, 1)
		frame2.BackgroundColor3 = tbl1.Purple2
		frame2.BorderSizePixel = 0
		frame2.Parent = frame1
		func1(frame2, 3)
		local frame3 = Instance.new("Frame")
		frame3.AnchorPoint = Vector2.new(0.5, 0.5)
		frame3.Position = UDim2.fromScale(0.5, 0.5)
		frame3.Size = UDim2.fromOffset(12, 12)
		frame3.BackgroundColor3 = tbl1.Text
		frame3.Parent = frame1
		func1(frame3, 6)
		func2(frame3, tbl1.Purple2, 0, 2)
		local v4 = arg3.Min or 0
		local v5 = arg3.Max or 100
		local v6 = math.clamp(arg3.Default or v4, v4, v5)
		local flag = false

		local function func(arg1)
			local v1 = math.clamp((arg1 - frame1.AbsolutePosition.X) / frame1.AbsoluteSize.X, 0, 1)
			local v3 = v4 + (v5 - v4) * v1
			local v7 = arg3.Step or 1
			v6 = math.floor(v3 / v7 + 0.5) * v7
			v6 = math.clamp(v6, v4, v5)
			local v8 = (v6 - v4) / (v5 - v4)
			frame2.Size = UDim2.fromScale(v8, 1)
			frame3.Position = UDim2.fromScale(v8, 0.5)
			v2.Text = tostring(v6)

			if arg3.Callback then
				pcall(arg3.Callback, v6)
			end
		end

		local InputBegan = frame1.InputBegan

		local function func3(arg1)
			local Position = arg1.Position
			flag = true
			func(Position.X)
			local tbl = {Size = UDim2.fromOffset(15, 15)}
			TweenService:Create(frame3, tweenInfo, tbl):Play()
		end

		local connection = InputBegan:Connect(function(arg1)
			if arg1.UserInputType == Enum.UserInputType.MouseButton1 or arg1.UserInputType == Enum.UserInputType.Touch then
				func3(arg1)
			end
		end)

		table.insert(tbl2, connection)

		local connection1 = UserInputService.InputChanged:Connect(function(input)
			if flag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				func(input.Position.X)
			end
		end)

		table.insert(tbl2, connection1)

		local connection2 = UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				if flag then
					flag = false
					local tbl = {Size = UDim2.fromOffset(12, 12)}
					TweenService:Create(frame3, tweenInfo, tbl):Play()
				end
			end
		end)

		table.insert(tbl2, connection2)
		local v7 = v6 - v4
		local v8 = v5 - v4
		local v9 = v7 / v8
		frame2.Size = UDim2.fromScale(v9, 1)
		frame3.Position = UDim2.fromScale(v9, 0.5)
		v2.Text = tostring(v6)
		return frame
	end

	tbl4:CreateWindow()
	local Page = ({Autofarm = tbl4:CreateTab("Autofarm", "rbxassetid://111021382463121", "Autofarm")}).Autofarm.Page
	tbl4:CreateLabel(Page, "Autofarm", "Farms automáticos del mapa.")
	local Section = tbl4:CreateSection(Page, "AutoFarm Pesca", "Autofarm disimulado, funcional! ¡Tira la Caña una sola vez!.")
	local Section1 = tbl4:CreateSection(Page, "Under Map", "Crea un soporte invisible bajo el mapa y te baja ahí.")

	xpcall(function()
		local VirtualInputManager = game:GetService("VirtualInputManager")

		if _G.FS_CLEANUP then
			pcall(_G.FS_CLEANUP)
		end

		if _G.AF_CLEANUP then
			pcall(_G.AF_CLEANUP)
		end

		local flag = true
		local tbl = {}
		local flag1 = false
		local tbl1 = {Safe = 60, CastDelay = 2, AutoCast = true, UseRemote = false}
		local v1
		local v2
		local Name
		local str = "idle"
		local num = 0
		local num1 = 0
		local num2 = 0
		local num3 = 0
		local num4 = 0
		local tbl5 = {period = 1.2, width = 0.3}
		local FishingTiming
		local tbl10
		local flag2 = false
		local AF_HOOK = _G.AF_HOOK

		if not AF_HOOK then
			local tbl6 = {installed = false}
			tbl6.remote = nil
			tbl6.cb = nil
			AF_HOOK = tbl6
			_G.AF_HOOK = AF_HOOK
		end

		local tbl7 = {}

		local function func(arg1, arg2)
			local v1 = arg2 or 0
			local v2 = typeof(arg1)

			if v2 == "table" then
				if v1 > 3 then
					return "{...}"
				end

				local tbl = {}
				local num = 0

				for k, v3 in pairs(arg1) do
					num = num + 1

					if num > 20 then
						tbl[#tbl + 1] = "..."
						break
					end

					tbl[#tbl + 1] = tostring(k) .. "=" .. func(v3, v1 + 1)
				end

				return "{" .. table.concat(tbl, ", ") .. "}"
			end

			if v2 == "string" then
				return '"' .. arg1 .. '"'
			end

			if v2 == "number" then
				if arg1 % 1 == 0 then
					return tostring(arg1)
				end
				return string.format("%.4f", arg1)
			end

			return tostring(arg1)
		end

		local function func1(...)
			local v1 = table.pack(...)
			local tbl = {}

			for i = 1, v1.n do
				tbl[i] = func(v1[i])
			end

			return table.concat(tbl, " | ")
		end

		local function func2()
			return table.concat(tbl7, "\n")
		end

		local function func3(arg1, arg2)
			local v1 = string.format("[%.3f] %-4s %s", workspace:GetServerTimeNow(), arg1, arg2)
			tbl7[#tbl7 + 1] = v1

			if #tbl7 > 300 then
				table.remove(tbl7, 1)
			end
		end

		_G.AF_LOG = func2
		local tbl8 = {}
		tbl8.part = nil
		tbl8.originalY = nil
		tbl8.active = false
		tbl8.busy = false

		local function func4()
			if tbl8.part and tbl8.part.Parent then
				tbl8.part:Destroy()
			end

			tbl8.part = nil
			tbl8.originalY = nil
		end

		local function func5()
			if tbl8.busy then
				return false
			end

			local Character = LocalPlayer.Character
			local v1 = Character and Character:FindFirstChild("HumanoidRootPart")
			local v2 = Character and Character:FindFirstChildOfClass("Humanoid")

			if not v1 or not v2 then
				func3("INFO", "No hay personaje para bajar bajo el mapa")
				return false
			end

			tbl8.busy = true
			func4()
			local v3 = tbl3.UnderDepth or 10
			tbl8.originalY = v1.Position.Y
			local v4 = tbl8.originalY - v3
			local part = Instance.new("Part")
			part.Name = "AF_UnderCarpet"
			part.Anchored = true
			part.CanCollide = true
			part.Transparency = 1
			part.Size = Vector3.new(40, 2, 40)
			part.CFrame = CFrame.new(v1.Position.X, v4 - 1, v1.Position.Z)
			part.Parent = workspace
			tbl8.part = part

			local ok, result = pcall(function()
				v1.AssemblyLinearVelocity = Vector3.zero
				v1.AssemblyAngularVelocity = Vector3.zero
				v1.Anchored = true
				local v2 = CFrame.new(v1.Position.X, v4 + 3, v1.Position.Z) * (v1.CFrame - v1.CFrame.Position)
				local tween = TweenService:Create(v1, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = v2})
				tween:Play()
				tween.Completed:Wait()
			end)

			pcall(function()
				v1.Anchored = false
				v1.AssemblyLinearVelocity = Vector3.zero
			end)

			if not ok then
				func3("INFO", "Error al bajar: " .. tostring(result))
				func4()
				tbl8.busy = false
				return false
			end

			tbl8.active = true
			tbl8.busy = false

			func3(
				"INFO",
				string.format("Bajaste %d bajo el mapa (Y %.1f -> %.1f)", v3, tbl8.originalY, v1.Position.Y)
			)

			return true
		end

		local function func6()
			if tbl8.busy then
				return
			end

			tbl8.busy = true
			local Character = LocalPlayer.Character
			local v1 = Character and Character:FindFirstChild("HumanoidRootPart")

			if v1 and tbl8.originalY then
				pcall(function()
					v1.AssemblyLinearVelocity = Vector3.zero
					v1.Anchored = true
					local v2 = CFrame.new(v1.Position.X, tbl8.originalY + 2, v1.Position.Z) * (v1.CFrame - v1.CFrame.Position)
					local tween = TweenService:Create(v1, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = v2})
					tween:Play()
					tween.Completed:Wait()
				end)

				pcall(function()
					v1.Anchored = false
					v1.AssemblyLinearVelocity = Vector3.zero
				end)

				func3("INFO", "Volviste a la superficie")
			end

			func4()
			tbl8.active = false
			tbl8.busy = false
		end

		local function func7(underDepth)
			tbl3.UnderDepth = underDepth
			if tbl8.active and not tbl8.busy and tbl8.part and tbl8.originalY then
				local Character = LocalPlayer.Character
				local v1 = Character and Character:FindFirstChild("HumanoidRootPart")

				if v1 then
					local part = tbl8.part
					local v2 = tbl8.originalY - underDepth
					part.CFrame = CFrame.new(tbl8.part.Position.X, v2 - 1, tbl8.part.Position.Z)
					v1.AssemblyLinearVelocity = Vector3.zero
					local new = CFrame.new
					local X = v1.Position.X
					local Position = v1.Position
					v1.CFrame = new(X, v2 + 3, Position.Z) * (v1.CFrame - v1.CFrame.Position)
				end
			end
		end

		local function func8()
			if FishingTiming and FishingTiming.Parent then
				return FishingTiming
			end

			local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")

			if not PlayerGui then
				return nil
			end

			FishingTiming = PlayerGui:FindFirstChild("FishingTiming", true)
			return FishingTiming
		end

		local function func9(arg1)
			func3("GUI", "Estructura de " .. arg1:GetFullName())
			local num = 0

			for _, descendant in ipairs(arg1:GetDescendants()) do
				if descendant:IsA("GuiObject") then
					num = num + 1

					if num > 25 then
						break
					end

					local v1 = string.format(
						"  %s (%s) padre=%s x=%.0f ancho=%.0f",
						descendant.Name,
						descendant.ClassName,
						descendant.Parent and descendant.Parent.Name or "?",
						descendant.AbsolutePosition.X,
						descendant.AbsoluteSize.X
					)

					local v2 = string.format("[%.3f] %-4s %s", workspace:GetServerTimeNow(), "GUI", v1)
					tbl7[#tbl7 + 1] = v2

					if #tbl7 > 300 then
						table.remove(tbl7, 1)
					end
				end
			end
		end

		local function func10(arg1, arg2, arg3, arg4)
			local tbl = {}

			for _, descendant in ipairs(arg1:GetDescendants()) do
				if descendant:IsA("GuiObject") then
					tbl[#tbl + 1] = descendant
				end
			end

			if #tbl == 0 then
				return nil
			end

			local tbl1 = {}
			local tbl2 = {}
			local v1 = os.clock()

			while os.clock() - v1 < 0.45 do
				if arg4 ~= num4 or not flag then
					return nil
				end

				for i, v2 in ipairs(tbl) do
					local X = v2.AbsolutePosition.X
					local v3 = v2.AbsoluteSize.X / 2
					local Parent = v2.Parent
					local v4 = X + v3
					local v5

					if Parent and Parent:IsA("GuiObject") then
						v5 = v4 - Parent.AbsolutePosition.X
					else
						v5 = v4
					end

					if not tbl2[i] or v5 < tbl2[i] then
						tbl2[i] = v5
					end

					if not tbl1[i] or v5 > tbl1[i] then
						tbl1[i] = v5
					end
				end

				RunService.RenderStepped:Wait()
			end

			local v9
			local v8

			for i1, v6 in ipairs(tbl) do
				local v7 = (tbl1[i1] or 0) - (tbl2[i1] or 0)
				if v7 > 4 and (not v9 or v7 > v9) then
					v8 = v6
					v9 = v7
				end
			end

			if not v8 then
				return nil
			end

			local Parent1 = v8.Parent

			if not (Parent1 and Parent1:IsA("GuiObject") and Parent1.AbsoluteSize.X > 0) then
				Parent1 = arg1
			end

			local v15
			local v14

			for i2, v10 in ipairs(tbl) do
				if v10 ~= v8 and Parent1.AbsoluteSize.X > 0 then
					local v11 = (tbl1[i2] or 0) - (tbl2[i2] or 0)
					local v12 = v10.AbsoluteSize.X / Parent1.AbsoluteSize.X - arg3
					local v13 = math.abs(v12)

					if v11 < 2 and v13 < 0.05 and (not v14 or v13 < v14) then
						v14 = v13
						v15 = v10
					end
				end
			end

			func3("AUTO", string.format("Aguja = %s (recorrio %.0fpx) | pista = %s", v8.Name, v9, Parent1.Name))

			if v15 then
				local v16 = v15.AbsolutePosition.X + v15.AbsoluteSize.X / 2
				local X1 = Parent1.AbsolutePosition.X
				local AbsoluteSize = Parent1.AbsoluteSize
				local v17 = (v16 - X1) / AbsoluteSize.X
				func3("AUTO", string.format("Zona verde UI = %s | centro UI %.3f vs servidor %.3f", v15.Name, v17, arg2))
			else
				func3("AUTO", "No identifique la zona verde en la UI (no es grave)")
			end

			return v8, Parent1
		end

		local function func11(arg1, arg2)
			if not (arg1.Parent and arg2.Parent) then
				return nil
			end

			local X = arg2.AbsoluteSize.X

			if X <= 0 then
				return nil
			end

			return (arg1.AbsolutePosition.X + arg1.AbsoluteSize.X / 2 - arg2.AbsolutePosition.X) / X
		end

		local function func12()
			local CurrentCamera = workspace.CurrentCamera
			local v1 = CurrentCamera and CurrentCamera.ViewportSize or Vector2.new(800, 600)
			local X = v1.X
			local new = Vector2.new
			local Y = v1.Y
			local v2 = new(X * 0.5, Y * 0.5)
			local vector2 = Vector2.new(v1.X * 0.5, v1.Y * 0.78)
			local new1 = Vector2.new
			local X1 = v1.X
			local Y1 = v1.Y
			local v3 = new1(X1 * 0.88, Y1 * 0.5)
			local new2 = Vector2.new
			local X2 = v1.X
			local Y2 = v1.Y
			local tbl = {v2, vector2, v3, new2(X2 * 0.12, Y2 * 0.5), Vector2.new(v1.X * 0.5, v1.Y * 0.2)}

			for _, v4 in ipairs(tbl) do
				local flag = false

				for _, child in ipairs(screenGui:GetChildren()) do
					if
						child:IsA("GuiObject")
						and child.Visible
						and child.AbsoluteSize.X > 40
						and child.AbsoluteSize.Y > 40
					then
						local AbsolutePosition = child.AbsolutePosition
						local AbsoluteSize = child.AbsoluteSize

						if
							v4.X >= AbsolutePosition.X
							and v4.X <= AbsolutePosition.X + AbsoluteSize.X
							and v4.Y >= AbsolutePosition.Y
							and v4.Y <= AbsolutePosition.Y + AbsoluteSize.Y
						then
							flag = true
							break
						end
					end
				end

				if not flag then
					return v4
				end
			end

			return tbl[1]
		end

		local function func13(arg1)
			if tbl1.UseRemote and v1 then
				local ServerTimeNow = workspace:GetServerTimeNow()
				v1:FireServer("Reel", {at = ServerTimeNow, round = arg1})
				func3("AUTO", string.format("Reel round %s enviado (at=%.4f)", tostring(arg1), ServerTimeNow))
			else
				local v2 = func12()

				pcall(function()
					VirtualInputManager:SendMouseButtonEvent(v2.X, v2.Y, 0, true, game, 0)
					task.wait(0.03)
					VirtualInputManager:SendMouseButtonEvent(v2.X, v2.Y, 0, false, game, 0)
				end)

				func3("AUTO", "Clic simulado round " .. tostring(arg1))
			end
		end

		local function func14(arg1)
			num4 = num4 + 1
			local v1 = num4
			local v2 = arg1.round or 1
			local start = arg1.start
			local center = arg1.center
			local v3 = arg1.period or tbl5.period
			local v4 = arg1.width or tbl5.width
			tbl5.period = v3
			tbl5.width = v4
			local v5 = v4 / 2 * (tbl1.Safe / 100)
			num2 = num2 + 1

			func3(
				"AUTO",
				string.format("round %s | centro %.3f | ancho %.2f | periodo %.2f", tostring(v2), center, v4, v3)
			)

			local v6 = func8()
			local v7 = os.clock()

			while flag and v1 == num4 and not (v6 and v6.Visible) and os.clock() - v7 < 1.5 do
				RunService.RenderStepped:Wait()
				if FishingTiming and FishingTiming.Parent then
					v6 = FishingTiming
				else
					local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
					if not PlayerGui then
						v6 = nil
					else
						FishingTiming = PlayerGui:FindFirstChild("FishingTiming", true)
						v6 = FishingTiming
					end
				end
			end

			if not flag or v1 ~= num4 then
				return
			end

			local needle
			local track

			if v6 then
				if tbl10 and tbl10.timing == v6 and tbl10.needle.Parent and tbl10.track.Parent then
					track = tbl10.track
					needle = tbl10.needle
				else
					local v8, v9 = func10(v6, center, v4, v1)
					needle = v8
					track = v9

					if v8 then
						tbl10 = {timing = v6, needle = v8, track = v9}
					end
				end
			end

			if not flag or v1 ~= num4 then
				return
			end

			if not needle then
				func3("AUTO", "No detecte la aguja en la UI: uso formula ESTIMADA")
				if v6 then
					func9(v6)
				end
			end

			local v10 = os.clock() + 12

			while flag and flag1 and v1 == num4 and os.clock() < v10 do
				local ServerTimeNow = workspace:GetServerTimeNow()

				if ServerTimeNow >= start then
					local v11

					if needle then
						v11 = func11(needle, track)
					else
						local v12 = (ServerTimeNow - start) / v3 % 1
						if v12 < 0.5 then
							v11 = v12 * 2
						else
							v11 = 2 - v12 * 2
						end
					end

					local v13 = v11

					if v11 then
						local v14 = v11 - center
						v13 = math.abs(v14) <= v5
					end

					if v13 then
						func13(v2)
						return
					end
				end

				RunService.RenderStepped:Wait()
			end

			if v1 == num4 then
				func3("AUTO", "Timeout: la aguja no entro en la zona")
			end
		end

		task.spawn(function()
			v1 = ReplicatedStorage:FindFirstChild("MD_FishingRemote") or ReplicatedStorage:WaitForChild("MD_FishingRemote", 10)

			if not v1 then
				warn("[AutoFish] No existe ReplicatedStorage.MD_FishingRemote")
				return
			end

			if hookmetamethod and newcclosure and getnamecallmethod then
				if not AF_HOOK.installed then
					if pcall(function()
						local v1
						v1 = hookmetamethod(game, "__namecall", newcclosure(function(arg1, ...)
							local v2 = getnamecallmethod()

							if v2 == "FireServer" and arg1 == AF_HOOK.remote then
								local cb = AF_HOOK.cb
								if cb then
									task.defer(cb, ...)
								end
							end

							if setnamecallmethod then
								setnamecallmethod(v2)
							end

							return v1(arg1, ...)
						end))
					end) then
						AF_HOOK.installed = true
					end
				end

				flag2 = AF_HOOK.installed
				AF_HOOK.remote = v1

				function AF_HOOK.cb(arg1, arg2)
					if arg1 == "Cast" and typeof(arg2) == "Vector3" then
						v2 = arg2
						local Character = LocalPlayer.Character
						local v1 = Character and Character:FindFirstChildOfClass("Tool")

						if v1 then
							Name = v1.Name
						end

						func3("OUT", "Cast " .. tostring(arg2) .. " (guardado)")

						if str == "idle" then
							str = "waiting"
							num1 = os.clock()
						end
					elseif arg1 == "Reel" then
						func3("OUT", "Reel " .. func(arg2))
					end
				end
			end

			pcall(function()
				local connection = v1.OnClientEvent:Connect(function(arg1, arg2, ...)
					func3("IN", func1(arg1, arg2, ...))
					if
						typeof(arg2) == "table"
						and typeof(arg2.center) == "number"
						and typeof(arg2.start) == "number"
					then
						str = "reeling"
						if flag1 then
							task.spawn(func14, arg2)
						end
					elseif arg1 == "End" then
						str = "idle"
						num = os.clock()
						num3 = num3 + 1
						num4 = num4 + 1
					end
				end)
				tbl[#tbl + 1] = connection
			end)
		end)

		local function func15()
			local Character = LocalPlayer.Character

			if not Character then
				return false
			end

			if Character:FindFirstChildOfClass("Tool") then
				return true
			end

			local Backpack = LocalPlayer:FindFirstChild("Backpack")

			if not Backpack then
				return false
			end

			local v1 = Name and Backpack:FindFirstChild(Name)

			if not v1 then
				for _, child in ipairs(Backpack:GetChildren()) do
					if child:IsA("Tool") and (string.find(string.lower(child.Name), "rod", 1, true) ~= nil or string.find(string.lower(child.Name), "fish", 1, true) ~= nil or string.find(string.lower(child.Name), "cana", 1, true) ~= nil) then
						v1 = child
						break
					end
				end
			end

			local Humanoid = Character:FindFirstChildOfClass("Humanoid")

			if v1 and Humanoid then
				Humanoid:EquipTool(v1)
				task.wait(0.4)
				return true
			end

			return false
		end

		task.spawn(function()
			while flag do
				task.wait(0.5)
				if flag1 and tbl1.AutoCast and v1 then
					if str == "idle" and v2 and os.clock() - num > tbl1.CastDelay then
						if func15() then
							str = "waiting"
							num1 = os.clock()
							v1:FireServer("Cast", v2)
							local v3 = string.format("[%.3f] %-4s %s", workspace:GetServerTimeNow(), "AUTO", "Lanzando la caña")
							tbl7[#tbl7 + 1] = v3

							if #tbl7 > 300 then
								table.remove(tbl7, 1)
							end
						end
					elseif str == "waiting" and os.clock() - num1 > 45 then
						local v4 = string.format("[%.3f] %-4s %s", workspace:GetServerTimeNow(), "AUTO", "Sin pique en 45s: reintento")
						tbl7[#tbl7 + 1] = v4

						if #tbl7 > 300 then
							table.remove(tbl7, 1)
						end

						str = "idle"
						num = 0
					end
				end
			end
		end)

		local Button

		tbl4:CreateButton(Section, {
			Title = "AutoFarm Pesca",
			Description = "Recoge solo (clic disimulado) y vuelve a lanzar",
			Icon = "rbxassetid://122078605083855",
			Default = false,
			Callback = function(value)
				flag1 = value
				if not value then
					num4 = num4 + 1
				end
			end,
		})

		local tbl9 = {}

		Button = tbl4:CreateButton(Section1, {
			Title = "Under Map",
			Description = "Baja debajo del mapa y pesca sin molestias",
			Icon = "rbxassetid://135885973924927",
			Default = false,
			Callback = function(value)
				if value then
					task.spawn(function()
						if not func5() and Button then
							Button:SetState(false)
						end
					end)
				else
					task.spawn(func6)
				end
			end,
		})

		tbl9.Title = "Under Map (metros)"
		tbl9.Description = "Cuánto baja el soporte debajo del mapa"
		tbl9.Min = 3
		tbl9.Max = 100
		tbl9.Default = tbl3.UnderDepth
		tbl9.Step = 1

		function tbl9.Callback(arg1)
			func7(arg1)
		end

		tbl4:CreateSlider(Section1, tbl9)
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 0, 44)
		frame.BackgroundTransparency = 1
		frame.Parent = Section
		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.fromScale(1, 1)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = ""
		textLabel.TextColor3 = Color3.fromRGB(150, 150, 165)
		textLabel.TextSize = 11
		textLabel.Font = Enum.Font.Gotham
		textLabel.TextWrapped = true
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.TextYAlignment = Enum.TextYAlignment.Top
		textLabel.Parent = frame

		task.spawn(function()
			while flag do
				task.wait(0.3)
				local v1 = str == "idle" and "libre" or (str == "waiting" and "esperando pique" or "recogiendo")
				local str1

				if v2 then
					str1 = "guardado"
				elseif flag2 then
					str1 = "falta: lanza la caña a mano 1 vez"
				else
					str1 = "sin hook (lanza a mano)"
				end

				textLabel.Text = "Estado: " .. v1 .. " | Lanzamiento: " .. str1 .. "\nRondas: " .. num2 .. " | Pescas terminadas: " .. num3
			end
		end)

		local connection = LocalPlayer.CharacterAdded:Connect(function()
			tbl8.busy = false
			tbl8.active = false
			func4()

			if Button then
				Button:SetState(false)
			end
		end)

		table.insert(tbl2, connection)

		local function func16()
			flag1 = false
			flag = false
			num4 = num4 + 1

			if tbl8.active then
				local Character = LocalPlayer.Character
				local v1 = Character and Character:FindFirstChild("HumanoidRootPart")

				if v1 and tbl8.originalY then
					pcall(function()
						v1.Anchored = false
						v1.AssemblyLinearVelocity = Vector3.zero
						v1.CFrame = CFrame.new(v1.Position.X, tbl8.originalY + 2, v1.Position.Z) * (v1.CFrame - v1.CFrame.Position)
					end)
				end
			end

			func4()
			tbl8.active = false
			AF_HOOK.cb = nil
			AF_HOOK.remote = nil

			for _, v2 in ipairs(tbl) do
				pcall(function()
					v2:Disconnect()
				end)
			end

			table.clear(tbl)
			_G.AF_CLEANUP = nil
		end

		_G.AF_CLEANUP = func16
		screenGui.Destroying:Connect(func16)
		func3("INFO", "Listo. Lanza la caña a mano una vez para guardar la posicion.")
	end, function(arg1)
		warn("[Autofarm] error al crear: " .. tostring(arg1))
	end)

	print("ANGEL HUB FARM cargado exitosamente.")
end

-- ANGEL HUB FARM