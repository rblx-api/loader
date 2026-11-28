-- F5 • Auto Steal (Futuristic Compact)
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TS = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local LP = Players.LocalPlayer

local Steal = {
	Enabled = false,
	Radius = 61,       -- Radio de cancelación (si te alejás más de esto, se cancela)
	TriggerRadius = 14, -- Solo empieza a robar si estás a ≤14 studs del brainrot
	Duration = 1.3,
	Mode = "NX1", -- NX1 = 90% | NX2 = 80%
	Data = {}
}

local isStealing = false
local stopTime = 0.96
local stopRadius = 9
local scale = 1
local locked = true
local conn = nil
local fill, pct, radLbl, main

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
					-- Solo detecta si estás dentro del TriggerRadius (14 studs)
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

		-- Fase 1
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

		-- Espera acercarse
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

		-- Fase final
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
		-- findNearest ya filtra por TriggerRadius (14 studs), así que si hay resultado = estás cerca
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
local function createGUI()
	local old = CoreGui:FindFirstChild("AutoStealBar")
	if old then old:Destroy() end

	local gui = Instance.new("ScreenGui")
	gui.Name = "AutoStealBar"
	gui.ResetOnSpawn = false
	gui.DisplayOrder = 999
	gui.Parent = CoreGui

	local w, h = 320 * scale, 58 * scale

	main = Instance.new("Frame", gui)
	main.Size = UDim2.new(0, w, 0, h)
	main.Position = UDim2.new(0.5, -w/2, 0.5, -h/2)
	-- Fondo verde oscuro navideño
	main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	main.BackgroundTransparency = 0.08
	main.BorderSizePixel = 0
	main.Active = true
	main.Draggable = not locked
	main.ClipsDescendants = true
	Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)


	-- Fondo monocromático estático
	local panelGrad = Instance.new("UIGradient", main)
	panelGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.0, Color3.fromRGB(28, 28, 28)),
		ColorSequenceKeypoint.new(1.0, Color3.fromRGB(10, 10, 10))
	})
	panelGrad.Rotation = 90

	-- Borde gris estático
	local stroke = Instance.new("UIStroke", main)
	stroke.Thickness = 1.5
	stroke.Transparency = 0.1
	stroke.Color = Color3.fromRGB(150, 150, 150)

	-- Detalles decorativos estáticos en escala de grises
	local lightColors = {
		Color3.fromRGB(90, 90, 90), Color3.fromRGB(150, 150, 150),
		Color3.fromRGB(210, 210, 210), Color3.fromRGB(120, 120, 120),
		Color3.fromRGB(170, 170, 170), Color3.fromRGB(90, 90, 90),
		Color3.fromRGB(200, 200, 200),
	}
	for li, lc in ipairs(lightColors) do
		local bulb = Instance.new("Frame", main)
		bulb.Size = UDim2.new(0, 5*scale, 0, 5*scale)
		bulb.Position = UDim2.new(0, (li * 40 - 20)*scale, 0, 2*scale)
		bulb.BackgroundColor3 = lc
		bulb.ZIndex = 8
		bulb.BorderSizePixel = 0
		Instance.new("UICorner", bulb).CornerRadius = UDim.new(1, 0)
	end

	-- Título
	local title = Instance.new("TextLabel", main)
	title.Size = UDim2.new(0, 110*scale, 0, 18*scale)
	title.Position = UDim2.new(0, 12*scale, 0, 6*scale)
	title.BackgroundTransparency = 1
	title.Text = "GUEST HUB"
	title.TextColor3 = Color3.fromRGB(208, 208, 208)
	title.Font = Enum.Font.GothamBlack
	title.TextSize = 14*scale
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 5


	local sub = Instance.new("TextLabel", main)
	sub.Size = UDim2.new(0, 130*scale, 0, 12*scale)
	sub.Position = UDim2.new(0, 12*scale, 0, 21*scale)
	sub.BackgroundTransparency = 1
	sub.Text = "AUTO STEAL  •  GUEST EDITION"
	sub.TextColor3 = Color3.fromRGB(217, 217, 217)
	sub.Font = Enum.Font.GothamBold
	sub.TextSize = 9*scale
	sub.TextXAlignment = Enum.TextXAlignment.Left
	sub.ZIndex = 5

	radLbl = Instance.new("TextLabel", main)
	radLbl.Size = UDim2.new(0, 90*scale, 0, 14*scale)
	radLbl.Position = UDim2.new(1, -100*scale, 0, 5*scale)
	radLbl.BackgroundTransparency = 1
	radLbl.Text = ""
	radLbl.TextColor3 = Color3.fromRGB(234, 234, 234)
	radLbl.Font = Enum.Font.GothamBold
	radLbl.TextSize = 11*scale
	radLbl.TextXAlignment = Enum.TextXAlignment.Right
	radLbl.ZIndex = 5

	-- Barra de progreso
	local barBg = Instance.new("Frame", main)
	barBg.Size = UDim2.new(0.68, 0, 0, 16*scale)
	barBg.Position = UDim2.new(0, 12*scale, 0, 33*scale)
	barBg.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
	barBg.BackgroundTransparency = 0.1
	barBg.ZIndex = 4
	Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)
	local barStroke = Instance.new("UIStroke", barBg)
	barStroke.Thickness = 1.4
	barStroke.Color = Color3.fromRGB(221, 221, 221)
	barStroke.Transparency = 0.2

	fill = Instance.new("Frame", barBg)
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	fill.ZIndex = 5
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

	-- Barra de progreso blanca/gris, sin animación decorativa
	fill.BackgroundColor3 = Color3.fromRGB(220, 220, 220)


	-- Remate gris estático de la barra
	local glow = Instance.new("Frame", fill)
	glow.Size = UDim2.new(0, 8, 0.7, 0)
	glow.Position = UDim2.new(1, -4, 0.5, 0)
	glow.AnchorPoint = Vector2.new(0.5, 0.5)
	glow.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
	glow.BackgroundTransparency = 0
	glow.ZIndex = 6
	Instance.new("UICorner", glow).CornerRadius = UDim.new(1, 0)

	pct = Instance.new("TextLabel", main)
	pct.Size = UDim2.new(0, 42*scale, 0, 16*scale)
	pct.Position = UDim2.new(0.70, 0, 0, 33*scale)
	pct.BackgroundTransparency = 1
	pct.Text = "0%"
	pct.TextColor3 = Color3.fromRGB(233, 233, 233)
	pct.Font = Enum.Font.GothamBlack
	pct.TextSize = 13*scale
	pct.ZIndex = 6

	Steal.Mode = "NX1"

	-- Candado
	local lock = Instance.new("TextButton", main)
	lock.Size = UDim2.new(0, 20*scale, 0, 20*scale)
	lock.Position = UDim2.new(0.5, -10*scale, 0, 5*scale)
	lock.BackgroundTransparency = 1
	lock.Text = "🔒"
	lock.TextColor3 = Color3.fromRGB(208, 208, 208)
	lock.Font = Enum.Font.GothamBlack
	lock.TextSize = 14*scale
	lock.ZIndex = 7
	lock.MouseButton1Click:Connect(function()
		locked = not locked
		lock.Text = locked and "🔒" or "🔓"
		main.Draggable = not locked
	end)

	-- Escala
	local function scaleBtn(txt, x, delta)
		local b = Instance.new("TextButton", main)
		b.Size = UDim2.new(0, 18*scale, 0, 18*scale)
		b.Position = UDim2.new(0.5, x, 0, 6*scale)
		b.BackgroundTransparency = 1
		b.Text = txt
		b.TextColor3 = Color3.fromRGB(208, 208, 208)
		b.Font = Enum.Font.GothamBlack
		b.TextSize = 16*scale
		b.ZIndex = 7
		b.MouseButton1Click:Connect(function()
			scale = math.clamp(scale + delta, 0.6, 1.6)
			createGUI()
		end)
	end
	scaleBtn("−", 55*scale, -0.1)
	scaleBtn("+", 75*scale, 0.1)

	-- Toggle
	local tog = Instance.new("TextButton", main)
	tog.Size = UDim2.new(0, 54*scale, 0, 24*scale)
	tog.Position = UDim2.new(1, -62*scale, 0.5, -12*scale)
	tog.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	tog.BackgroundTransparency = 0.15
	tog.Text = "OFF"
	tog.TextColor3 = Color3.fromRGB(180, 180, 180)
	tog.Font = Enum.Font.GothamBlack
	tog.TextSize = 11*scale
	tog.ZIndex = 6
	Instance.new("UICorner", tog).CornerRadius = UDim.new(0, 8)
	local ts = Instance.new("UIStroke", tog)
	ts.Color = Color3.fromRGB(86, 86, 86)
	ts.Thickness = 1.6
	ts.Transparency = 0.2

	tog.MouseButton1Click:Connect(function()
		Steal.Enabled = not Steal.Enabled
		if Steal.Enabled then
			tog.Text = "ON"
			tog.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
			tog.TextColor3 = Color3.fromRGB(234, 234, 234)
			ts.Color = Color3.fromRGB(167, 167, 167)
			ts.Transparency = 0.1
			start()
		else
			tog.Text = "OFF"
			tog.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			tog.TextColor3 = Color3.fromRGB(180, 180, 180)
			ts.Color = Color3.fromRGB(86, 86, 86)
			ts.Transparency = 0.2
			stop()
		end
	end)
end

createGUI()
print("GUEST HUB • Auto Steal cargado")