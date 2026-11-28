-- F5 • XYRON AUTO STEAL (Professional Dark)
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TS = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

local Steal = {
	Enabled = false,
	Radius = 61,
	TriggerRadius = 14,
	Duration = 1.3,
	Mode = "NX1",
	Data = {}
}

local isStealing = false
local stopTime = 0.96
local stopRadius = 9
local scale = 1
local locked = true
local conn = nil
local fill, pct, main
local currentPosition = nil
local saveFile = "xyron_autosteal_config.json"
local isAnimatingScale = false

-- ===================== SAVE / LOAD =====================
local function saveConfig()
	if not main then return end
	pcall(function()
		local data = {
			pos = {
				main.Position.X.Scale,
				main.Position.X.Offset,
				main.Position.Y.Scale,
				main.Position.Y.Offset
			},
			scale = scale,
			locked = locked,
			enabled = Steal.Enabled
		}
		writefile(saveFile, HttpService:JSONEncode(data))
	end)
end

local function loadConfig()
	pcall(function()
		if isfile and isfile(saveFile) then
			local data = HttpService:JSONDecode(readfile(saveFile))
			if data.scale then
				scale = math.clamp(tonumber(data.scale) or 1, 0.6, 1.6)
			end
			if data.locked ~= nil then
				locked = data.locked
			end
			if data.enabled ~= nil then
				Steal.Enabled = data.enabled
			end
			if data.pos and #data.pos == 4 then
				currentPosition = UDim2.new(data.pos[1], data.pos[2], data.pos[3], data.pos[4])
			end
		end
	end)
end

loadConfig()

-- ===================== UTIL =====================
local function isMyPlot(name)
	local plot = workspace:FindFirstChild("Plots") and workspace.Plots:FindFirstChild(name)
	if not plot then return false end
	local sign = plot:FindFirstChild("PlotSign")
	local yb = sign and sign:FindFirstChild("YourBase")
	return yb and yb:IsA("BillboardGui") and yb.Enabled
end

local function findNearest()
	local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local plots = workspace:FindFirstChild("Plots")
	if not plots then return end

	local best, bestDist, bestName = nil, math.huge, nil
	for _, plot in ipairs(plots:GetChildren()) do
		if isMyPlot(plot.Name) then continue end
		local pods = plot:FindFirstChild("AnimalPodiums")
		if not pods then continue end
		for _, pod in ipairs(pods:GetChildren()) do
			pcall(function()
				local spawn = pod.Base and pod.Base:FindFirstChild("Spawn")
				if spawn then
					local dist = (spawn.Position - root.Position).Magnitude
					if dist < bestDist and dist <= Steal.TriggerRadius then
						local att = spawn:FindFirstChild("PromptAttachment")
						if att then
							for _, c in ipairs(att:GetChildren()) do
								if c:IsA("ProximityPrompt") and c.ActionText and c.ActionText:find("Steal") then
									best, bestDist, bestName = c, dist, pod.Name
									break
								end
							end
						end
					end
				end
			end)
		end
	end
	return best, bestName
end

-- ===================== STEAL =====================
local function doSteal(prompt, name)
	if isStealing then return end
	if not Steal.Data[prompt] then
		Steal.Data[prompt] = {hold = {}, trigger = {}, ready = true}
		pcall(function()
			if getconnections then
				for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
					if c.Function then table.insert(Steal.Data[prompt].hold, c.Function) end
				end
				for _, c in ipairs(getconnections(prompt.Triggered)) do
					if c.Function then table.insert(Steal.Data[prompt].trigger, c.Function) end
				end
			end
		end)
	end

	local data = Steal.Data[prompt]
	if not data.ready then return end
	data.ready = false
	isStealing = true

	task.spawn(function()
		for _, f in ipairs(data.hold) do task.spawn(f) end
		local start = tick()
		local stopAt = Steal.Mode == "NX2" and 0.80 or 0.90
		local fired = false

		while isStealing and Steal.Enabled do
			local t = tick() - start
			if t >= stopTime then break end
			local p = math.clamp(t / Steal.Duration, 0, 1)
			if fill then fill.Size = UDim2.new(p, 0, 1, 0) end
			if pct then pct.Text = math.floor(p * 100) .. "%" end
			if not prompt.Parent then break end
			local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
			if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.Radius then break end
			task.wait()
		end

		if fill then fill.Size = UDim2.new(stopAt, 0, 1, 0) end
		if pct then pct.Text = math.floor(stopAt * 100) .. "%" end

		local t2 = tick()
		while isStealing and Steal.Enabled do
			if tick() - t2 > 2.2 then
				data.ready = true
				isStealing = false
				if fill then fill.Size = UDim2.new(0,0,1,0) end
				if pct then pct.Text = "0%" end
				local np, nn = findNearest()
				if np then doSteal(np, nn) end
				return
			end
			if not prompt.Parent then break end
			local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				local d = (hrp.Position - prompt.Parent.Parent.Position).Magnitude
				if d <= stopRadius then break end
				if d > Steal.Radius then
					data.ready = true
					isStealing = false
					if fill then fill.Size = UDim2.new(0,0,1,0) end
					if pct then pct.Text = "0%" end
					return
				end
			end
			task.wait()
		end

		if isStealing and Steal.Enabled then
			local fs = tick()
			local fd = math.max(Steal.Duration - stopTime, 0.05)
			while true do
				local fp = math.clamp((tick() - fs) / fd, 0, 1)
				if fill then fill.Size = UDim2.new(stopAt + fp * (1 - stopAt), 0, 1, 0) end
				if pct then pct.Text = math.floor((stopAt + fp * (1 - stopAt)) * 100) .. "%" end
				if fp >= 1 and not fired then
					fired = true
					pcall(function()
						for _, f in ipairs(data.trigger) do task.spawn(f) end
						local r = ReplicatedStorage:FindFirstChild("StealAnimal")
						if r and name then r:FireServer(name) end
						if prompt then prompt:Fire() end
					end)
					break
				end
				task.wait()
			end
		end

		if fill then fill.Size = UDim2.new(0,0,1,0) end
		if pct then pct.Text = "0%" end
		data.ready = true
		isStealing = false
	end)
end

local function start()
	if conn then return end
	conn = RunService.Heartbeat:Connect(function()
		if not Steal.Enabled or isStealing then return end
		local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
		if not root then return end
		local p, n = findNearest()
		if p then doSteal(p, n) end
	end)
end

local function stop()
	if conn then conn:Disconnect() conn = nil end
	isStealing = false
	if fill then fill.Size = UDim2.new(0,0,1,0) end
	if pct then pct.Text = "0%" end
end

-- ===================== GUI =====================
local function createGUI(animateFromScale)
	local old = CoreGui:FindFirstChild("XYRONAutoSteal")
	local oldSize = nil

	if old and old:FindFirstChild("Main") then
		currentPosition = old.Main.Position
		oldSize = old.Main.Size
	end

	if old then old:Destroy() end

	local gui = Instance.new("ScreenGui")
	gui.Name = "XYRONAutoSteal"
	gui.ResetOnSpawn = false
	gui.DisplayOrder = 999
	gui.Parent = CoreGui

	local w, h = 340 * scale, 78 * scale

	-- Centro, un poquito más abajo
	local defaultPos = UDim2.new(0.5, -w/2, 0.58, -h/2)

	main = Instance.new("Frame", gui)
	main.Name = "Main"
	main.Size = (animateFromScale and oldSize) and oldSize or UDim2.new(0, w, 0, h)
	main.Position = currentPosition or defaultPos
	main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	main.BackgroundTransparency = 0.04
	main.BorderSizePixel = 0
	main.Active = true
	main.Draggable = not locked
	main.ClipsDescendants = true
	main.ZIndex = 1

	Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

	local panelGrad = Instance.new("UIGradient", main)
	panelGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.0, Color3.fromRGB(20, 20, 20)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(12, 12, 12)),
		ColorSequenceKeypoint.new(1.0, Color3.fromRGB(7, 7, 7))
	})
	panelGrad.Rotation = 90

	local stroke = Instance.new("UIStroke", main)
	stroke.Thickness = 1.5
	stroke.Transparency = 0.2
	stroke.Color = Color3.fromRGB(160, 160, 160)

	-- Línea superior sutil
	local topLine = Instance.new("Frame", main)
	topLine.Size = UDim2.new(1, 0, 0, 1.2)
	topLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	topLine.BackgroundTransparency = 0.75
	topLine.BorderSizePixel = 0
	topLine.ZIndex = 10
	Instance.new("UICorner", topLine).CornerRadius = UDim.new(1, 0)
	local topGrad = Instance.new("UIGradient", topLine)
	topGrad.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.25, 0.3),
		NumberSequenceKeypoint.new(0.75, 0.3),
		NumberSequenceKeypoint.new(1, 1)
	})

	-- ========== TITLE ==========
	local title = Instance.new("TextLabel", main)
	title.Size = UDim2.new(0, 90 * scale, 0, 18 * scale)
	title.Position = UDim2.new(0, 14 * scale, 0, 8 * scale)
	title.BackgroundTransparency = 1
	title.Text = "XYRON"
	title.TextColor3 = Color3.fromRGB(245, 245, 245)
	title.Font = Enum.Font.GothamBlack
	title.TextSize = 15 * scale
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 5

	local sub = Instance.new("TextLabel", main)
	sub.Size = UDim2.new(0, 90 * scale, 0, 12 * scale)
	sub.Position = UDim2.new(0, 14 * scale, 0, 25 * scale)
	sub.BackgroundTransparency = 1
	sub.Text = "AUTO STEAL"
	sub.TextColor3 = Color3.fromRGB(150, 150, 150)
	sub.Font = Enum.Font.GothamBold
	sub.TextSize = 9 * scale
	sub.TextXAlignment = Enum.TextXAlignment.Left
	sub.ZIndex = 5

	-- ========== TOGGLE ==========
	local tog = Instance.new("TextButton", main)
	tog.Size = UDim2.new(0, 50 * scale, 0, 24 * scale)
	tog.Position = UDim2.new(0, 110 * scale, 0, 10 * scale)
	tog.BackgroundColor3 = Steal.Enabled and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(22, 22, 22)
	tog.BackgroundTransparency = 0.1
	tog.Text = Steal.Enabled and "ON" or "OFF"
	tog.TextColor3 = Steal.Enabled and Color3.fromRGB(240, 240, 240) or Color3.fromRGB(140, 140, 140)
	tog.Font = Enum.Font.GothamBlack
	tog.TextSize = 12 * scale
	tog.ZIndex = 6
	Instance.new("UICorner", tog).CornerRadius = UDim.new(0, 7)

	local ts = Instance.new("UIStroke", tog)
	ts.Color = Steal.Enabled and Color3.fromRGB(150, 150, 150) or Color3.fromRGB(60, 60, 60)
	ts.Thickness = 1.3
	ts.Transparency = 0.25

	tog.MouseButton1Click:Connect(function()
		Steal.Enabled = not Steal.Enabled
		if Steal.Enabled then
			tog.Text = "ON"
			TS:Create(tog, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.fromRGB(50, 50, 50),
				TextColor3 = Color3.fromRGB(240, 240, 240)
			}):Play()
			TS:Create(ts, TweenInfo.new(0.2), {Color = Color3.fromRGB(150, 150, 150)}):Play()
			start()
		else
			tog.Text = "OFF"
			TS:Create(tog, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.fromRGB(22, 22, 22),
				TextColor3 = Color3.fromRGB(140, 140, 140)
			}):Play()
			TS:Create(ts, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 60, 60)}):Play()
			stop()
		end
		saveConfig()
	end)

	tog.MouseEnter:Connect(function()
		TS:Create(tog, TweenInfo.new(0.12), {BackgroundTransparency = 0}):Play()
	end)
	tog.MouseLeave:Connect(function()
		TS:Create(tog, TweenInfo.new(0.12), {BackgroundTransparency = 0.1}):Play()
	end)

	-- ========== LOCK + SCALE (bien separados, no aplastados) ==========
	local lock = Instance.new("TextButton", main)
	lock.Size = UDim2.new(0, 26 * scale, 0, 26 * scale)
	lock.Position = UDim2.new(0, 175 * scale, 0, 9 * scale)
	lock.BackgroundTransparency = 1
	lock.Text = locked and "🔒" or "🔓"
	lock.TextColor3 = Color3.fromRGB(200, 200, 200)
	lock.Font = Enum.Font.GothamBlack
	lock.TextSize = 15 * scale
	lock.ZIndex = 7
	lock.MouseButton1Click:Connect(function()
		locked = not locked
		lock.Text = locked and "🔒" or "🔓"
		main.Draggable = not locked
		saveConfig()
	end)

	local function makeScaleBtn(txt, xPos, delta)
		local b = Instance.new("TextButton", main)
		b.Size = UDim2.new(0, 26 * scale, 0, 26 * scale)
		b.Position = UDim2.new(0, xPos * scale, 0, 9 * scale)
		b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		b.BackgroundTransparency = 0.2
		b.Text = txt
		b.TextColor3 = Color3.fromRGB(230, 230, 230)
		b.Font = Enum.Font.GothamBlack
		b.TextSize = 16 * scale
		b.ZIndex = 7
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

		local bs = Instance.new("UIStroke", b)
		bs.Thickness = 1.1
		bs.Color = Color3.fromRGB(80, 80, 80)
		bs.Transparency = 0.25

		b.MouseButton1Click:Connect(function()
			if isAnimatingScale then return end
			local newScale = math.clamp(scale + delta, 0.6, 1.6)
			if newScale == scale then return end

			isAnimatingScale = true
			currentPosition = main.Position
			scale = newScale
			createGUI(true)
			saveConfig()
		end)

		b.MouseEnter:Connect(function()
			TS:Create(b, TweenInfo.new(0.12), {BackgroundTransparency = 0}):Play()
		end)
		b.MouseLeave:Connect(function()
			TS:Create(b, TweenInfo.new(0.12), {BackgroundTransparency = 0.2}):Play()
		end)
	end

	makeScaleBtn("−", 208, -0.1)
	makeScaleBtn("+", 240, 0.1)

	-- ========== PROGRESS BAR (choncha) ==========
	local barBg = Instance.new("Frame", main)
	barBg.Size = UDim2.new(0, 230 * scale, 0, 22 * scale)
	barBg.Position = UDim2.new(0, 14 * scale, 1, -32 * scale)
	barBg.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
	barBg.BackgroundTransparency = 0.08
	barBg.ZIndex = 4
	Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

	local barStroke = Instance.new("UIStroke", barBg)
	barStroke.Thickness = 1.2
	barStroke.Color = Color3.fromRGB(70, 70, 70)
	barStroke.Transparency = 0.3

	fill = Instance.new("Frame", barBg)
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
	fill.ZIndex = 5
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

	local fillGrad = Instance.new("UIGradient", fill)
	fillGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1.0, Color3.fromRGB(185, 185, 185))
	})

	-- % dentro de la barra
	pct = Instance.new("TextLabel", barBg)
	pct.Size = UDim2.new(1, 0, 1, 0)
	pct.BackgroundTransparency = 1
	pct.Text = "0%"
	pct.TextColor3 = Color3.fromRGB(15, 15, 15)
	pct.Font = Enum.Font.GothamBlack
	pct.TextSize = 12 * scale
	pct.ZIndex = 7
	pct.TextStrokeTransparency = 0.65
	pct.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)

	-- ========== THUMBNAIL (donde estaban los FPS, sin pegar con la barra) ==========
	local thumbFrame = Instance.new("Frame", main)
	thumbFrame.Size = UDim2.new(0, 42 * scale, 0, 42 * scale)
	thumbFrame.Position = UDim2.new(1, -54 * scale, 1, -52 * scale) -- abajo a la derecha, encima de donde estaría el borde
	thumbFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
	thumbFrame.BorderSizePixel = 0
	thumbFrame.ZIndex = 5
	Instance.new("UICorner", thumbFrame).CornerRadius = UDim.new(1, 0)

	local thumbStroke = Instance.new("UIStroke", thumbFrame)
	thumbStroke.Thickness = 1.5
	thumbStroke.Color = Color3.fromRGB(130, 130, 130)
	thumbStroke.Transparency = 0.25

	local thumb = Instance.new("ImageLabel", thumbFrame)
	thumb.Size = UDim2.new(1, -4, 1, -4)
	thumb.Position = UDim2.new(0, 2, 0, 2)
	thumb.BackgroundTransparency = 1
	thumb.Image = ""
	thumb.ScaleType = Enum.ScaleType.Crop
	thumb.ZIndex = 6
	Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)

	task.spawn(function()
		local ok, content = pcall(function()
			return Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
		end)
		if ok and content and thumb and thumb.Parent then
			thumb.Image = content
		end
	end)

	-- Animación de escala
	if animateFromScale and oldSize then
		main.Size = oldSize
		local tween = TS:Create(main, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, w, 0, h)
		})
		tween:Play()
		tween.Completed:Connect(function()
			isAnimatingScale = false
		end)
	else
		isAnimatingScale = false
	end

	-- Guardar posición
	main:GetPropertyChangedSignal("Position"):Connect(function()
		currentPosition = main.Position
		task.delay(0.4, function()
			if main and main.Parent then
				saveConfig()
			end
		end)
	end)

	if Steal.Enabled then
		start()
	end
end

createGUI(false)
print("XYRON AUTO STEAL • Cargado correctamente")