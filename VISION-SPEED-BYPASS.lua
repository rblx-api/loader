local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local localPlayer = Players.LocalPlayer

local uiScaleValue = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and 75 or 100
local isMobileDevice = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local desktopBypassPower = 97000
local mobileBypassPower = 72000
local text = isMobileDevice and "Mobile" or "PC"
local isSpeedBypassEnabled = false
local speedBypassPower = isMobileDevice and mobileBypassPower or desktopBypassPower
local thread = nil
local speedBypassPanel = nil
local isSpeedPanelDismissed = false
local blockListPayload = nil
local uiControl = nil
local keybindButton = nil
local secondaryButton = nil
local speedModeLabel = nil
local updateSpeedBypassVisual = nil
local speedPanelPosition = nil
local defaultPanelPosition = nil
local speedPanelScale = nil
local panelAnimationToken = 0
local speedPanelToggle = nil
local speedToggleScale = nil
local speedToggleImage = nil
local speedToggleStroke = nil
local speedToggleGradient = nil
local showSpeedBypassPanel = true
local primaryColor = Color3.fromRGB(255, 255, 255)

local KB = {
    SpeedBypassGui = { kb = nil, gp = nil },
    SpeedBypassToggle = { kb = nil, gp = nil },

local _anyKeyListening = false
local _keyListenBlockUntil = 0

local function isKeybindLocked()
    return _anyKeyListening or tick() < (_keyListenBlockUntil or 0)
end

local function refreshAllKeyButtons()
    if keybindButton then
        keybindButton.Text = KB.SpeedBypassToggle.gp and KB.SpeedBypassToggle.gp.Name
            or KB.SpeedBypassToggle.kb and KB.SpeedBypassToggle.kb.Name
            or "None"
    end
    if secondaryButton then
        secondaryButton.Text = KB.SpeedBypassGui.gp and KB.SpeedBypassGui.gp.Name
            or KB.SpeedBypassGui.kb and KB.SpeedBypassGui.kb.Name
            or "None"
    end
end

local function clearDuplicateKeybind(inputValue, isControllerInput, target)
    if not inputValue or inputValue == Enum.KeyCode.Unknown then return end
    for _, item in pairs(KB) do
        if item ~= target then
            if isControllerInput and item.gp == inputValue then
                item.gp = nil
            elseif not isControllerInput and item.kb == inputValue then
                item.kb = nil
            end
        end
    end
    refreshAllKeyButtons()
end

local function loadExternalUIImage(inputValue, secondaryInput)
    local genv = getgenv and getgenv() or _G
    local isfileFn = rawget(genv, "isfile")
    local writefileFn = rawget(genv, "writefile")

    if type(getAsset) == "function" and type(writefileFn) == "function" then
        local exists = type(isfileFn) == "function" and isfileFn(secondaryInput)
        if not exists then
            local ok, result = pcall(function()
            end)
            if ok and type(result) == "string" and #result > 0 then
                exists = pcall(writefileFn, secondaryInput, result)
            end
        end
        if exists then
            local ok, result = pcall(getAsset, secondaryInput)
            if ok and result then return result end
        end
    end
    return inputValue
end

local VISION_SPEED_BYPASS_IMAGE_URL = "https://files.catbox.moe/4s7q0i.png"

local function saveConfig()
    local writefileFn = rawget(getgenv and getgenv() or _G, "writefile")
    if type(writefileFn) ~= "function" then return end
    pcall(function()
        writefileFn("PrintedSpeedBypass.json", HttpService:JSONEncode({
            speedBypassPower = speedBypassPower,
            speedBypassPCPower = desktopBypassPower,
            speedBypassMobilePower = mobileBypassPower,
            speedBypassMode = text,
            speedBypassPosition = speedPanelPosition,
            speedBypassGuiKey = {
                kb = KB.SpeedBypassGui.kb and KB.SpeedBypassGui.kb.Name or nil,
                gp = KB.SpeedBypassGui.gp and KB.SpeedBypassGui.gp.Name or nil,
            speedBypassToggleKey = {
                kb = KB.SpeedBypassToggle.kb and KB.SpeedBypassToggle.kb.Name or nil,
                gp = KB.SpeedBypassToggle.gp and KB.SpeedBypassToggle.gp.Name or nil,
    end)
end

local function loadConfig()
    local isfileFn = rawget(getgenv and getgenv() or _G, "isfile")
    local readfileFn = rawget(getgenv and getgenv() or _G, "readfile")
    if type(isfileFn) ~= "function" or type(readfileFn) ~= "function" then return end
    if not isfileFn("PrintedSpeedBypass.json") then return end

    pcall(function()
        local data = HttpService:JSONDecode(readfileFn("PrintedSpeedBypass.json"))
        if type(data) ~= "table" then return end
        desktopBypassPower = tonumber(data.speedBypassPCPower) or desktopBypassPower
        mobileBypassPower = tonumber(data.speedBypassMobilePower) or mobileBypassPower
        text = data.speedBypassMode == "Mobile" and "Mobile" or "PC"
        speedBypassPower = tonumber(data.speedBypassPower) or (text == "PC" and desktopBypassPower or mobileBypassPower)
        speedPanelPosition = type(data.speedBypassPosition) == "table" and data.speedBypassPosition or nil

        local guiKey = data.speedBypassGuiKey
        if type(guiKey) == "table" then
            if guiKey.kb and Enum.KeyCode[guiKey.kb] then KB.SpeedBypassGui.kb = Enum.KeyCode[guiKey.kb] end
            if guiKey.gp and Enum.KeyCode[guiKey.gp] then KB.SpeedBypassGui.gp = Enum.KeyCode[guiKey.gp] end
        end

        local toggleKey = data.speedBypassToggleKey
        if type(toggleKey) == "table" then
            if toggleKey.kb and Enum.KeyCode[toggleKey.kb] then KB.SpeedBypassToggle.kb = Enum.KeyCode[toggleKey.kb] end
            if toggleKey.gp and Enum.KeyCode[toggleKey.gp] then KB.SpeedBypassToggle.gp = Enum.KeyCode[toggleKey.gp] end
        end
    end)
end

loadConfig()

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PrintedSpeedBypass"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999

pcall(function()
    screenGui.Parent = game:GetService("CoreGui")
end)
if not screenGui.Parent then
    screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
end

			featureHelperP = function()
		if updateSpeedBypassVisual then
			updateSpeedBypassVisual(isSpeedBypassEnabled)
		end

		if uiControl then
			uiControl.Text = tostring(speedBypassPower)
		end

		if keybindButton then
			keybindButton.Text = KB.SpeedBypassToggle.gp and KB.SpeedBypassToggle.gp.Name
				or KB.SpeedBypassToggle.kb and KB.SpeedBypassToggle.kb.Name
				or "None"
		end

		if secondaryButton then
			secondaryButton.Text = KB.SpeedBypassGui.gp and KB.SpeedBypassGui.gp.Name
				or KB.SpeedBypassGui.kb and KB.SpeedBypassGui.kb.Name
				or "None"
		end

		if speedModeLabel then
			speedModeLabel.Text = text
		end
	end

local function featureHelperS(inputValue)
			local workingData = {}
			local animationProperties = {}
			table.insert(animationProperties, {})
			local primaryValue = animationProperties[1]

			for i = 1, 296 do
				local scaleProperties = {}
				table.insert(primaryValue, scaleProperties)
				primaryValue = scaleProperties
			end

			local floor2 = math.floor
			local numericValue = tonumber(inputValue) or 0

			for i = 1, floor2(numericValue / 298) do
				table.insert(workingData, animationProperties)
			end

			return workingData
		end

		local function featureHelperT(inputValue)
			if not isSpeedBypassEnabled then
				return
			end
			isSpeedBypassEnabled = false

			pcall(function()
				game:GetService("NetworkClient"):SetOutgoingKBPSLimit(0)
			end)

			if thread then
				task.cancel(thread)
				thread = nil
			end

			blockListPayload = nil

			if not inputValue then
				featureHelperP()
			end
		end

		local function featureHelperU(inputValue)
			if isSpeedBypassEnabled then
				return
			end
			isSpeedBypassEnabled = true

			pcall(function()
				game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
			end)

			blockListPayload = featureHelperS(speedBypassPower)

			thread = task.spawn(function()
				while isSpeedBypassEnabled do
					if blockListPayload then
						pcall(function()
							game.RobloxReplicatedStorage.SetPlayerBlockList:FireServer(blockListPayload)
						end)
					end

					task.wait(0.12)
				end
			end)

			if not inputValue then
				featureHelperP()
			end
		end

		featureHelperQ = function()
			if not showSpeedBypassPanel and not isSpeedBypassEnabled then
				featureHelperP()
				return
			end

			if isSpeedBypassEnabled then
				featureHelperT()
			else
				featureHelperU()
			end
		end

		featureHelperR = function()
			if not isSpeedBypassEnabled then
				return
			end

			if thread then
				task.cancel(thread)
				thread = nil
			end

			blockListPayload = featureHelperS(speedBypassPower)

			thread = task.spawn(function()
				while isSpeedBypassEnabled do
					if blockListPayload then
						pcall(function()
							game.RobloxReplicatedStorage.SetPlayerBlockList:FireServer(blockListPayload)
						end)
					end

					task.wait(0.12)
				end
			end)
		end
	end
end

	local function featureHelperS()
		if not speedBypassPanel or not speedPanelScale then
			return
		end
		panelAnimationToken += 1
		local primaryValue = panelAnimationToken
		local isActive = showSpeedBypassPanel and not isSpeedPanelDismissed

		if speedPanelToggle then
			local secondaryValue = showSpeedBypassPanel and isSpeedPanelDismissed
			local visible = speedPanelToggle.Visible
			speedPanelToggle.Visible = secondaryValue

			if secondaryValue and not visible then
				speedPanelToggle.BackgroundTransparency = 1

				if speedToggleScale then
					speedToggleScale.Scale = 0.82
					local workingData = { Scale = 1 }
					TweenService:Create(
						TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
					):Play()
				end

				if speedToggleImage then
					speedToggleImage.ImageTransparency = 1
					local workingData = { ImageTransparency = 0 }
					TweenService:Create(
						TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					):Play()
				end

				if speedToggleStroke then
					speedToggleStroke.Transparency = 1
					speedToggleStroke.Thickness = 0
					local workingData = { Transparency = 0.28, Thickness = 2 }
					TweenService:Create(
						TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					):Play()
				end

				if speedToggleGradient then
					speedToggleGradient.Rotation = -18
					TweenService:Create(speedToggleGradient, TweenInfo.new(0.22), { Rotation = 18 }):Play()
				end

				TweenService:Create(
					TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{ BackgroundTransparency = 0.03 }
				):Play()
			end
		end

		local scale = (uiScaleValue or 100) / 100

		if isActive then
			speedBypassPanel.Visible = true
			speedPanelScale.Scale = scale * 0.82
			TweenService:Create(
				TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
				{ Scale = scale }
			):Play()
		else
			local tween = TweenService:Create(
				TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
				{ Scale = scale * 0.82 }
			tween:Play()

			tween.Completed:Connect(function()
				local isReady = primaryValue == panelAnimationToken

				if isReady then
					isReady = not (showSpeedBypassPanel and not isSpeedPanelDismissed)
				end

				if isReady then
					speedBypassPanel.Visible = false
					speedPanelScale.Scale = scale
				end
			end)
		end
	end

	local function featureHelperT()
		local viewportSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
		local clamp = math.clamp
		defaultPanelPosition = UDim2.fromOffset(
			math.max(12, math.floor((viewportSize.X - 230) / 2 + 0.5)) + 115,
			clamp(math.floor((viewportSize.Y - 252) / 2 + 0.5), 12, math.max(12, viewportSize.Y - 264)) + 126
		speedPanelPosition = nil

		if speedBypassPanel then
			speedBypassPanel.Position = defaultPanelPosition
		end
	end

	local function featureHelperU(inputValue, secondaryInput)
		local foregroundColor = Color3.fromRGB(255, 255, 255)
		local borderColor = Color3.fromRGB(34, 45, 62)
		local primaryControl = Instance.new("Frame", inputValue)
		speedBypassPanel = primaryControl
		primaryControl.Name = "SpeedBypass"
		primaryControl.Size = UDim2.new(0, 230, 0, 252)
		primaryControl.BackgroundColor3 = Color3.fromRGB(5, 5, 7)
		primaryControl.BackgroundTransparency = 0.02
		primaryControl.BorderSizePixel = 0
		primaryControl.ClipsDescendants = true
		primaryControl.ZIndex = 40
		primaryControl.AnchorPoint = Vector2.new(0.5, 0.5)
		local viewportSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
		local max = math.max
		local amount = viewportSize.Y - 264
		defaultPanelPosition = UDim2.fromOffset(
			math.max(12, math.floor((viewportSize.X - 230) / 2 + 0.5)) + 115,
			math.clamp(math.floor((viewportSize.Y - 252) / 2 + 0.5), 12, max(12, amount)) + 126
		primaryControl.Position = speedPanelPosition
				and UDim2.fromOffset(speedPanelPosition.x + 115, speedPanelPosition.y + 126)
			or defaultPanelPosition
		Instance.new("UICorner", primaryControl).CornerRadius = UDim.new(0, 14)
		local uiScale = Instance.new("UIScale", primaryControl)
		uiScale.Scale = (uiScaleValue or 100) / 100
		speedPanelScale = uiScale
		local floatingButton = Instance.new("TextButton", inputValue)
		speedPanelToggle = floatingButton
		floatingButton.Name = "VisionSpeedBypassToggle"
		floatingButton.Size = UDim2.new(0, 110, 0, 31)
		floatingButton.AnchorPoint = Vector2.new(0.5, 0.5)
		floatingButton.Position = UDim2.new(1, -55, 0, 113)
		floatingButton.BackgroundColor3 = Color3.fromRGB(5, 5, 9)
		floatingButton.BackgroundTransparency = 0.03
		floatingButton.BorderSizePixel = 0
		floatingButton.AutoButtonColor = false
		floatingButton.Text = ""
		floatingButton.ZIndex = 30
		floatingButton.ClipsDescendants = true
		floatingButton.Visible = false
		Instance.new("UICorner", floatingButton).CornerRadius = UDim.new(0, 12)
		local uiScale2 = Instance.new("UIScale", floatingButton)
		uiScale2.Scale = 1
		speedToggleScale = uiScale2
		local gradientControl = Instance.new("UIGradient", floatingButton)
		local colorSequence = ColorSequence.new
		local workingData = {}
		local primaryValue = ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 18, 22))
		local secondaryValue = ColorSequenceKeypoint.new(0.48, Color3.fromRGB(10, 10, 14))
		workingData[1] = primaryValue
		workingData[2] = secondaryValue

			local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 28, 34)))
			table.move(values, 1, values.n, 3, workingData)
		end

		gradientControl.Color = colorSequence(workingData)
		gradientControl.Rotation = 18
		speedToggleGradient = gradientControl
		local imageLabel = Instance.new("ImageLabel", floatingButton)
		imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		imageLabel.Size = UDim2.fromScale(1, 1)
		imageLabel.Position = UDim2.fromScale(0.5, 0.5)
		imageLabel.BackgroundTransparency = 1
		imageLabel.Image = ""
		imageLabel.ScaleType = Enum.ScaleType.Stretch
		imageLabel.ImageColor3 = foregroundColor
		imageLabel.ZIndex = 34
		speedToggleImage = imageLabel
		Instance.new("UICorner", imageLabel).CornerRadius = UDim.new(0, 12)

		task.spawn(function()
			local currentObject = loadExternalUIImage(VISION_SPEED_BYPASS_IMAGE_URL, "VisionSpeedBypassToggleV6.png")

			if imageLabel and imageLabel.Parent then
				imageLabel.Image = currentObject
			end
		end)

		local strokeControl = Instance.new("UIStroke", floatingButton)
		strokeControl.Color = Color3.fromRGB(210, 210, 235)
		strokeControl.Thickness = 2
		strokeControl.Transparency = 0.28
		speedToggleStroke = strokeControl
		local isActive = false
		local currentObject = nil
		local worldPosition = nil
		local secondaryPosition = nil
		local isReady = false

		floatingButton.InputBegan:Connect(function(input)
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				isActive = true
				currentObject = input
				worldPosition = input.Position
				secondaryPosition = floatingButton.Position
				isReady = false
			end

			return
		end)

		UserInputService.InputChanged:Connect(function(input)
				not isActive
				or input.UserInputType ~= Enum.UserInputType.MouseMovement
					and input.UserInputType ~= Enum.UserInputType.Touch
			then
				return
			end
			local calculatedValue = input.Position - worldPosition

			if 4 < calculatedValue.Magnitude then
				isReady = true
			end

			floatingButton.Position = UDim2.new(
				secondaryPosition.X.Offset + calculatedValue.X,
				secondaryPosition.Y.Offset + calculatedValue.Y
		end)

		UserInputService.InputEnded:Connect(function(input)
				and (
					input == currentObject
					or input.UserInputType == Enum.UserInputType.MouseButton1
					or input.UserInputType == Enum.UserInputType.Touch
			then
				isActive = false
				currentObject = nil
			end
		end)

		floatingButton.Activated:Connect(function()
			if isReady then
				isReady = false
				return
			end
			uiScale2.Scale = 0.9
			TweenService
				:Create(uiScale2, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Scale = 1 })
				:Play()
			isSpeedPanelDismissed = false
			featureHelperS()
		end)

		local overlayControl = Instance.new("Frame", primaryControl)
		overlayControl.Size = UDim2.new(1, 0, 0, 38)
		overlayControl.BackgroundTransparency = 1
		overlayControl.BorderSizePixel = 0
		overlayControl.ZIndex = 41
		overlayControl.Active = true
		local label = Instance.new("TextLabel", overlayControl)
		label.Size = UDim2.new(1, -52, 1, 0)
		label.Position = UDim2.new(0, 12, 0, 0)
		label.BackgroundTransparency = 1
		label.Text = "VISION SPEED BYPASS"
		label.TextColor3 = primaryColor
		label.TextSize = 14
		label.Font = Enum.Font.GothamBlack
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.ZIndex = 42
		local headerButton = Instance.new("TextButton", overlayControl)
		headerButton.Size = UDim2.new(1, -50, 1, 0)
		headerButton.BackgroundTransparency = 1
		headerButton.Text = ""
		headerButton.ZIndex = 43
		local toggleButton = Instance.new("TextButton", overlayControl)
		toggleButton.Size = UDim2.new(0, 28, 0, 28)
		toggleButton.Position = UDim2.new(1, -38, 0, 5)
		toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		toggleButton.BackgroundTransparency = 0
		toggleButton.BorderSizePixel = 0
		toggleButton.Text = ""
		toggleButton.AutoButtonColor = false
		toggleButton.ZIndex = 45
		Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 7)
		local detailControl = Instance.new("UIStroke", toggleButton)
		detailControl.Color = borderColor
		detailControl.Thickness = 1
		detailControl.Transparency = 0.52
		detailControl.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		local rowContainer = Instance.new("Frame", toggleButton)
		rowContainer.AnchorPoint = Vector2.new(0.5, 0.5)
		rowContainer.Size = UDim2.new(0, 5, 0, 2)
		rowContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
		rowContainer.BackgroundColor3 = foregroundColor
		rowContainer.BackgroundTransparency = 0.15
		rowContainer.BorderSizePixel = 0
		rowContainer.ZIndex = 44
		Instance.new("UICorner", rowContainer).CornerRadius = UDim.new(1, 0)

		toggleButton.Activated:Connect(function()
			isSpeedPanelDismissed = true
			featureHelperS()
		end)

		local isComplete = false

		headerButton.InputBegan:Connect(function(input)
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				isComplete = true
			end
		end)

		if secondaryInput then
			secondaryInput(headerButton, primaryControl)
		end

		UserInputService.InputEnded:Connect(function(input)
				and (
					input.UserInputType == Enum.UserInputType.MouseButton1
					or input.UserInputType == Enum.UserInputType.Touch
			then
				isComplete = false

				speedPanelPosition = {
					x = math.floor(primaryControl.Position.X.Offset - 115 + 0.5),
					y = math.floor(primaryControl.Position.Y.Offset - 126 + 0.5),

				saveConfig()
			end
		end)

		local innerContainer = Instance.new("Frame", primaryControl)
		innerContainer.Size = UDim2.new(1, -24, 0, 30)
		innerContainer.Position = UDim2.new(0, 12, 0, 38)
		innerContainer.BackgroundTransparency = 1
		innerContainer.ZIndex = 41
		local secondaryControl = Instance.new("TextButton", innerContainer)
		secondaryControl.AnchorPoint = Vector2.new(0.5, 0.5)
		secondaryControl.Size = UDim2.new(0.5, -3, 1, 0)
		secondaryControl.Position = UDim2.new(0.25, -1.5, 0.5, 0)
		secondaryControl.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		secondaryControl.BackgroundTransparency = 0
		secondaryControl.BorderSizePixel = 0
		secondaryControl.Text = "PC"
		secondaryControl.TextColor3 = foregroundColor
		secondaryControl.Font = Enum.Font.GothamBlack
		secondaryControl.TextSize = 11
		secondaryControl.ZIndex = 42
		secondaryControl.AutoButtonColor = false
		Instance.new("UICorner", secondaryControl).CornerRadius = UDim.new(0, 8)
		local modeButton = Instance.new("TextButton", innerContainer)
		modeButton.AnchorPoint = Vector2.new(0.5, 0.5)
		modeButton.Size = UDim2.new(0.5, -3, 1, 0)
		modeButton.Position = UDim2.new(0.75, 1.5, 0.5, 0)
		modeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		modeButton.BackgroundTransparency = 0
		modeButton.BorderSizePixel = 0
		modeButton.Text = "MOBILE"
		modeButton.TextColor3 = foregroundColor
		modeButton.Font = Enum.Font.GothamBlack
		modeButton.TextSize = 10
		modeButton.ZIndex = 42
		modeButton.AutoButtonColor = false
		Instance.new("UICorner", modeButton).CornerRadius = UDim.new(0, 8)
		local uiStroke = Instance.new("UIStroke", secondaryControl)
		uiStroke.Color = borderColor
		uiStroke.Thickness = 1
		uiStroke.Transparency = 0.52
		uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		local tertiaryControl = Instance.new("UIStroke", modeButton)
		tertiaryControl.Color = borderColor
		tertiaryControl.Thickness = 1
		tertiaryControl.Transparency = 0.52
		tertiaryControl.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		local uiScale3 = Instance.new("UIScale", secondaryControl)
		uiScale3.Scale = 1
		local uiScale4 = Instance.new("UIScale", modeButton)
		uiScale4.Scale = 1
		local obj2 = setmetatable({}, { __mode = "k" })

		local function featureHelperV(tertiaryInput)
			local calculatedValue = (obj2[tertiaryInput] or 0) + 1
			obj2[tertiaryInput] = calculatedValue
			tertiaryInput.Scale = 0.9
			local tween = TweenService:Create(
				TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
				{ Scale = 1.04 }
			tween:Play()

			tween.Completed:Connect(function()
				if calculatedValue ~= obj2[tertiaryInput] then
					return
				end
				local animationProperties = { Scale = 1 }
				TweenService:Create(
					TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
				):Play()
			end)
		end

		local function featureHelperW()
			secondaryControl.TextColor3 = foregroundColor
			modeButton.TextColor3 = foregroundColor
			TweenService:Create(
				TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ Transparency = text == "PC" and 0.12 or 0.52, Thickness = text == "PC" and 1.5 or 1 }
			):Play()

			TweenService
				:Create(tertiaryControl, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Transparency = text == "Mobile" and 0.12 or 0.52,
					Thickness = text == "Mobile" and 1.5 or 1,
				:Play()
		end

		local function featureHelperX(tertiaryInput)
			if isKeybindLocked() then
				return
			end

			if text == "PC" then
				desktopBypassPower = speedBypassPower
			else
				mobileBypassPower = speedBypassPower
			end

			text = tertiaryInput
			speedBypassPower = text == "PC" and desktopBypassPower or mobileBypassPower
			featureHelperW()
			featureHelperP()
			featureHelperR()
			saveConfig()
		end

		secondaryControl.Activated:Connect(function()
			featureHelperV(uiScale3)
			featureHelperX("PC")
		end)

		modeButton.Activated:Connect(function()
			featureHelperV(uiScale4)
			featureHelperX("Mobile")
		end)

		featureHelperW()

		local function createFrame(tertiaryInput, labelText)
			local controlContainer = Instance.new("Frame", primaryControl)
			controlContainer.Size = UDim2.new(1, -24, 0, 36)
			controlContainer.Position = UDim2.new(0, 12, 0, tertiaryInput)
			controlContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			controlContainer.BackgroundTransparency = 0
			controlContainer.BorderSizePixel = 0
			controlContainer.ZIndex = 41
			Instance.new("UICorner", controlContainer).CornerRadius = UDim.new(0, 8)
			local uiStroke2 = Instance.new("UIStroke", controlContainer)
			uiStroke2.Color = borderColor
			uiStroke2.Thickness = 1
			uiStroke2.Transparency = 0.52
			uiStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			local secondaryLabel = Instance.new("TextLabel", controlContainer)
			secondaryLabel.Size = UDim2.new(0.5, 0, 1, 0)
			secondaryLabel.Position = UDim2.new(0, 12, 0, 0)
			secondaryLabel.BackgroundTransparency = 1
			secondaryLabel.Text = labelText
			secondaryLabel.TextColor3 = foregroundColor
			secondaryLabel.TextSize = 11
			secondaryLabel.Font = Enum.Font.GothamBold
			secondaryLabel.TextXAlignment = Enum.TextXAlignment.Left
			secondaryLabel.ZIndex = 42
			return controlContainer
		end

		local uiToggle = createFrame(76, "UI Toggle")
		secondaryButton = Instance.new("TextButton", uiToggle)
		secondaryButton.Size = UDim2.new(0, 50, 0, 28)
		secondaryButton.Position = UDim2.new(1, -58, 0.5, -14)
		secondaryButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		secondaryButton.BackgroundTransparency = 0
		secondaryButton.BorderSizePixel = 0
		secondaryButton.Text = KB.SpeedBypassGui.gp and KB.SpeedBypassGui.gp.Name
			or KB.SpeedBypassGui.kb and KB.SpeedBypassGui.kb.Name
			or "None"
		secondaryButton.TextColor3 = foregroundColor
		secondaryButton.TextSize = 9
		secondaryButton.Font = Enum.Font.GothamBold
		secondaryButton.ZIndex = 42
		secondaryButton.AutoButtonColor = false
		Instance.new("UICorner", secondaryButton).CornerRadius = UDim.new(0, 8)
		local uiStroke2 = Instance.new("UIStroke", secondaryButton)
		uiStroke2.Color = borderColor
		uiStroke2.Thickness = 1
		uiStroke2.Transparency = 0.52
		uiStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

		secondaryButton.Activated:Connect(function()
			if isKeybindLocked() then
				return
			end
			_anyKeyListening = true
			_keyListenBlockUntil = tick() + 0.35
			secondaryButton.Text = "..."
			local isWaitingForInput = true
			local startTime = tick()
			local activeConnection = nil

			activeConnection = UserInputService.InputBegan:Connect(function(input)
				if input.KeyCode == Enum.KeyCode.Escape then
					isWaitingForInput = false
					_anyKeyListening = false
					local currentItem = 0.25
					_keyListenBlockUntil = tick() + currentItem
					activeConnection:Disconnect()
					featureHelperP()
					return
				end

				local isControllerInput = input.UserInputType and input.UserInputType.Name:match("^Gamepad") ~= nil
				if isControllerInput and tick() - startTime < 0.15 then
					return
				end

					input.KeyCode ~= Enum.KeyCode.Unknown
					and (input.UserInputType == Enum.UserInputType.Keyboard or isControllerInput)
				then
					clearDuplicateKeybind(input.KeyCode, isControllerInput, KB.SpeedBypassGui)

					if isControllerInput then
						KB.SpeedBypassGui.gp = input.KeyCode
						KB.SpeedBypassGui.kb = nil
					else
						KB.SpeedBypassGui.kb = input.KeyCode
						KB.SpeedBypassGui.gp = nil
					end

					isWaitingForInput = false
					_anyKeyListening = false
					local currentItem = 0.25
					_keyListenBlockUntil = tick() + currentItem
					activeConnection:Disconnect()
					refreshAllKeyButtons()
					featureHelperP()
					saveConfig()
				end
			end)

			task.delay(3, function()
				if isWaitingForInput then
					isWaitingForInput = false
					_anyKeyListening = false
					local currentItem = 0.25
					_keyListenBlockUntil = tick() + currentItem

					if activeConnection then
						activeConnection:Disconnect()
					end

					featureHelperP()
				end
			end)
		end)

		local keybind = createFrame(118, "Keybind")
		keybindButton = Instance.new("TextButton", keybind)
		keybindButton.Size = UDim2.new(0, 50, 0, 28)
		keybindButton.Position = UDim2.new(1, -58, 0.5, -14)
		keybindButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		keybindButton.BackgroundTransparency = 0
		keybindButton.BorderSizePixel = 0
		keybindButton.Text = KB.SpeedBypassToggle.gp and KB.SpeedBypassToggle.gp.Name
			or KB.SpeedBypassToggle.kb and KB.SpeedBypassToggle.kb.Name
			or "None"
		keybindButton.TextColor3 = foregroundColor
		keybindButton.TextSize = 9
		keybindButton.Font = Enum.Font.GothamBold
		keybindButton.ZIndex = 42
		keybindButton.AutoButtonColor = false
		Instance.new("UICorner", keybindButton).CornerRadius = UDim.new(0, 8)
		local auxiliaryControl = Instance.new("UIStroke", keybindButton)
		auxiliaryControl.Color = borderColor
		auxiliaryControl.Thickness = 1
		auxiliaryControl.Transparency = 0.52
		auxiliaryControl.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		local currentItem = createFrame(160, "Speed")
		uiControl = Instance.new("TextBox", currentItem)
		uiControl.Size = UDim2.new(0, 38, 0, 22)
		uiControl.Position = UDim2.new(1, -46, 0.5, -11)
		uiControl.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		uiControl.BackgroundTransparency = 0
		uiControl.BorderSizePixel = 0
		uiControl.Text = tostring(speedBypassPower)
		uiControl.TextColor3 = foregroundColor
		uiControl.TextSize = 9
		uiControl.Font = Enum.Font.GothamBold
		uiControl.ClearTextOnFocus = false
		uiControl.ZIndex = 42
		Instance.new("UICorner", uiControl).CornerRadius = UDim.new(0, 7)
		local uiStroke3 = Instance.new("UIStroke", uiControl)
		uiStroke3.Color = borderColor
		uiStroke3.Thickness = 1
		uiStroke3.Transparency = 0.52
		uiStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

		uiControl.FocusLost:Connect(function()
			local numericValue = tonumber(uiControl.Text)

			if numericValue then
				speedBypassPower = math.floor(math.clamp(numericValue, 10000, text == "PC" and 150000 or 100000))
			else
				speedBypassPower = text == "PC" and 97000 or 72000
			end

			if text == "PC" then
				desktopBypassPower = speedBypassPower
			else
				mobileBypassPower = speedBypassPower
			end

			featureHelperP()
			featureHelperR()
			saveConfig()
		end)

		keybindButton.Activated:Connect(function()
			if isKeybindLocked() then
				return
			end
			_anyKeyListening = true
			_keyListenBlockUntil = tick() + 0.35
			keybindButton.Text = "..."
			local isWaitingForInput = true
			local startTime = tick()
			local activeConnection = nil

			activeConnection = UserInputService.InputBegan:Connect(function(input)
				if input.KeyCode == Enum.KeyCode.Escape then
					isWaitingForInput = false
					_anyKeyListening = false
					local targetObject = 0.25
					_keyListenBlockUntil = tick() + targetObject
					activeConnection:Disconnect()
					featureHelperP()
					return
				end

				local isControllerInput = input.UserInputType and input.UserInputType.Name:match("^Gamepad") ~= nil
				if isControllerInput and tick() - startTime < 0.15 then
					return
				end

					input.KeyCode ~= Enum.KeyCode.Unknown
					and (input.UserInputType == Enum.UserInputType.Keyboard or isControllerInput)
				then
					clearDuplicateKeybind(input.KeyCode, isControllerInput, KB.SpeedBypassToggle)

					if isControllerInput then
						KB.SpeedBypassToggle.gp = input.KeyCode
						KB.SpeedBypassToggle.kb = nil
					else
						KB.SpeedBypassToggle.kb = input.KeyCode
						KB.SpeedBypassToggle.gp = nil
					end

					isWaitingForInput = false
					_anyKeyListening = false
					_keyListenBlockUntil = tick() + 0.25
					activeConnection:Disconnect()
					refreshAllKeyButtons()
					featureHelperP()
					saveConfig()
				end
			end)

			task.delay(3, function()
				if isWaitingForInput then
					isWaitingForInput = false
					_anyKeyListening = false
					_keyListenBlockUntil = tick() + 0.25

					if activeConnection then
						activeConnection:Disconnect()
					end

					featureHelperP()
				end
			end)
		end)

		local enableButton = Instance.new("TextButton", primaryControl)
		enableButton.AnchorPoint = Vector2.new(0.5, 0.5)
		enableButton.Size = UDim2.new(1, -24, 0, 38)
		enableButton.Position = UDim2.new(0.5, 0, 0, 223)
		enableButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		enableButton.BackgroundTransparency = 0
		enableButton.BorderSizePixel = 0
		enableButton.Text = "DISABLED"
		enableButton.TextColor3 = foregroundColor
		enableButton.TextSize = 11
		enableButton.Font = Enum.Font.GothamBold
		enableButton.ZIndex = 42
		enableButton.AutoButtonColor = false
		Instance.new("UICorner", enableButton).CornerRadius = UDim.new(0, 7)
		local uiStroke4 = Instance.new("UIStroke", enableButton)
		uiStroke4.Color = borderColor
		uiStroke4.Thickness = 1
		uiStroke4.Transparency = 0.52
		uiStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		local uiScale5 = Instance.new("UIScale", enableButton)
		uiScale5.Scale = 1
		local targetObject = isSpeedBypassEnabled
		local uiElement = 0

		updateSpeedBypassVisual = function(tertiaryInput)
			enableButton.Text = tertiaryInput and "ENABLED" or "DISABLED"
			enableButton.TextColor3 = foregroundColor
			enableButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			uiStroke4.Color = borderColor
			if targetObject == tertiaryInput then
				return
			end
			targetObject = tertiaryInput
			uiElement += 1
			local stateToken = uiElement
			local calculatedValue = tertiaryInput and 1.5 or 1
			tertiaryInput = tertiaryInput and 0.12 or 0.52
			uiScale5.Scale = 0.9
			uiStroke4.Thickness = 2.5
			uiStroke4.Transparency = 0.04
			enableButton.TextTransparency = 0.45
			local tween = TweenService:Create(
				TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
				{ Scale = 1.04 }
			tween:Play()
			TweenService:Create(
				TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ TextTransparency = 0 }
			):Play()
			TweenService:Create(
				TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ Thickness = calculatedValue, Transparency = tertiaryInput }
			):Play()

			tween.Completed:Connect(function()
				if stateToken ~= uiElement then
					return
				end
				TweenService
					:Create(
						TweenInfo.new(0.17, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
						{ Scale = 1 }
					:Play()
			end)
		end

		enableButton.Activated:Connect(function()
			if isKeybindLocked() then
				return
			end
			featureHelperQ()
		end)

		speedModeLabel = nil
		featureHelperP()
		featureHelperS()
	end

local function makeDraggable(inputValue, primaryValue, clampToViewport)
    local active, startInput, startPosition = false, nil, nil

    inputValue.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            active = true
            startInput = input.Position
            startPosition = primaryValue.Position
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            active = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not active then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then return end

        primaryValue.Position = UDim2.new(
    end)
end

local __printedSpeedInitOk, __printedSpeedInitErr = pcall(function()
    featureHelperU(screenGui, makeDraggable)
end)

if not __printedSpeedInitOk then
    print("prince"))
end

if speedBypassPanel then
    speedBypassPanel.Visible = true
    speedBypassPanel.ZIndex = 40
    if speedPanelScale then
        speedPanelScale.Scale = (uiScaleValue or 100) / 100
    end
end

if speedPanelToggle then
    speedPanelToggle.Visible = false
end

local brand = Instance.new("TextLabel")
brand.Name = "__printedBrand"
brand.Size = UDim2.fromOffset(150, 18)
brand.Position = UDim2.new(0.5, -75, 0, 6)
brand.BackgroundTransparency = 1
brand.TextColor3 = Color3.fromRGB(145, 145, 145)
brand.TextSize = 10
brand.Font = Enum.Font.GothamBold
brand.TextXAlignment = Enum.TextXAlignment.Center
brand.ZIndex = 10000
brand.Parent = screenGui

print("prince")