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
	if fill then TS:Create(fill, TweenInfo.new(0.2), {Size = UDim2.new(0,0,1,0)}):Play() end
	if pct then pct.Text = "0%" end
end

-- ===================== KYRON AUTO STEAL GUI =====================
local function createGUI()
	local old = CoreGui:FindFirstChild("AutoStealBar")
	if old then old:Destroy() end

	local gui = Instance.new("ScreenGui")
	gui.Name = "AutoStealBar"
	gui.ResetOnSpawn = false
	gui.DisplayOrder = 999
	gui.Parent = CoreGui

	local w, h = 340 * scale, 88 * scale

	-- Sombra exterior
	local shadow = Instance.new("Frame", gui)
	shadow.Name = "PanelShadow"
	shadow.Size = UDim2.new(0, w + 8*scale, 0, h + 8*scale)
	shadow.Position = UDim2.new(0.5, -w/2 - 4*scale, 0.5, -h/2 + 5*scale)
	shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	shadow.BackgroundTransparency = 0.35
	shadow.BorderSizePixel = 0
	shadow.ZIndex = 0
	Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 17*scale)

	main = Instance.new("Frame", gui)
	main.Name = "KyronMain"
	main.Size = UDim2.new(0, w, 0, h)
	main.Position = UDim2.new(0.5, -w/2, 0.5, -h/2)
	main.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
	main.BackgroundTransparency = 0.03
	main.BorderSizePixel = 0
	main.Active = true
	main.Draggable = not locked
	main.ClipsDescendants = true
	main.ZIndex = 1
	Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14*scale)

	local panelGrad = Instance.new("UIGradient", main)
	panelGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(29, 29, 32)),
		ColorSequenceKeypoint.new(0.48, Color3.fromRGB(13, 13, 15)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(23, 23, 26))
	})
	panelGrad.Rotation = 35

	local stroke = Instance.new("UIStroke", main)
	stroke.Color = Color3.fromRGB(125, 125, 132)
	stroke.Thickness = 1.35
	stroke.Transparency = 0.18

	-- Reflejo superior discreto
	local accent = Instance.new("Frame", main)
	accent.Size = UDim2.new(0.42, 0, 0, 2*scale)
	accent.Position = UDim2.new(0.06, 0, 0, 0)
	accent.BackgroundColor3 = Color3.fromRGB(235, 235, 240)
	accent.BorderSizePixel = 0
	accent.ZIndex = 3
	Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)

	-- Puntos blancos decorativos
	for i = 1, 9 do
		local dot = Instance.new("Frame", main)
		local d = (i % 3 == 0) and 3 or 2
		dot.Size = UDim2.new(0, d*scale, 0, d*scale)
		dot.Position = UDim2.new((i*11 % 93)/100, 0, (i*17 % 78)/100, 0)
		dot.BackgroundColor3 = Color3.fromRGB(225, 225, 230)
		dot.BackgroundTransparency = 0.55 + (i % 3)*0.1
		dot.BorderSizePixel = 0
		dot.ZIndex = 2
		Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
	end

	local title = Instance.new("TextLabel", main)
	title.Name = "Title"
	title.Size = UDim2.new(0, 205*scale, 0, 21*scale)
	title.Position = UDim2.new(0, 14*scale, 0, 9*scale)
	title.BackgroundTransparency = 1
	title.Text = "KYRON AUTO STEAL"
	title.TextColor3 = Color3.fromRGB(245, 245, 248)
	title.Font = Enum.Font.GothamBlack
	title.TextSize = 14*scale
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 4

	local sub = Instance.new("TextLabel", main)
	sub.Size = UDim2.new(0, 190*scale, 0, 13*scale)
	sub.Position = UDim2.new(0, 15*scale, 0, 29*scale)
	sub.BackgroundTransparency = 1
	sub.Text = "MONOCHROME  /  PREMIUM UI"
	sub.TextColor3 = Color3.fromRGB(145, 145, 153)
	sub.Font = Enum.Font.GothamMedium
	sub.TextSize = 8*scale
	sub.TextXAlignment = Enum.TextXAlignment.Left
	sub.ZIndex = 4

	radLbl = Instance.new("TextLabel", main)
	radLbl.Size = UDim2.new(0, 80*scale, 0, 14*scale)
	radLbl.Position = UDim2.new(1, -94*scale, 0, 10*scale)
	radLbl.BackgroundTransparency = 1
	radLbl.Text = ""
	radLbl.TextColor3 = Color3.fromRGB(190, 190, 198)
	radLbl.Font = Enum.Font.GothamBold
	radLbl.TextSize = 10*scale
	radLbl.TextXAlignment = Enum.TextXAlignment.Right
	radLbl.ZIndex = 4

	-- Barra de progreso
	local barBg = Instance.new("Frame", main)
	barBg.Name = "ProgressBackground"
	barBg.Size = UDim2.new(0, 205*scale, 0, 13*scale)
	barBg.Position = UDim2.new(0, 15*scale, 0, 58*scale)
	barBg.BackgroundColor3 = Color3.fromRGB(5, 5, 6)
	barBg.BorderSizePixel = 0
	barBg.ZIndex = 4
	Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

	local barStroke = Instance.new("UIStroke", barBg)
	barStroke.Thickness = 1
	barStroke.Color = Color3.fromRGB(85, 85, 92)
	barStroke.Transparency = 0.2

	fill = Instance.new("Frame", barBg)
	fill.Name = "ProgressFill"
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(225, 225, 230)
	fill.BorderSizePixel = 0
	fill.ZIndex = 5
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

	local fillGrad = Instance.new("UIGradient", fill)
	fillGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(115, 115, 122)),
		ColorSequenceKeypoint.new(0.55, Color3.fromRGB(245, 245, 248)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(175, 175, 182))
	})

	pct = Instance.new("TextLabel", main)
	pct.Size = UDim2.new(0, 43*scale, 0, 16*scale)
	pct.Position = UDim2.new(0, 226*scale, 0, 56*scale)
	pct.BackgroundTransparency = 1
	pct.Text = "0%"
	pct.TextColor3 = Color3.fromRGB(245, 245, 248)
	pct.Font = Enum.Font.GothamBlack
	pct.TextSize = 12*scale
	pct.TextXAlignment = Enum.TextXAlignment.Center
	pct.ZIndex = 6

	Steal.Mode = "NX1"

	-- Candado
	local lock = Instance.new("TextButton", main)
	lock.Name = "LockButton"
	lock.Size = UDim2.new(0, 25*scale, 0, 23*scale)
	lock.Position = UDim2.new(1, -91*scale, 0, 31*scale)
	lock.BackgroundColor3 = Color3.fromRGB(35, 35, 39)
	lock.BackgroundTransparency = 0.12
	lock.BorderSizePixel = 0
	lock.Text = "LOCK"
	lock.TextColor3 = Color3.fromRGB(225, 225, 230)
	lock.Font = Enum.Font.GothamBold
	lock.TextSize = 7*scale
	lock.ZIndex = 6
	Instance.new("UICorner", lock).CornerRadius = UDim.new(0, 6*scale)
	local lockStroke = Instance.new("UIStroke", lock)
	lockStroke.Color = Color3.fromRGB(105, 105, 112)
	lockStroke.Thickness = 1
	lock.MouseButton1Click:Connect(function()
		locked = not locked
		lock.Text = locked and "LOCK" or "MOVE"
		main.Draggable = not locked
	end)

	-- Escala
	local function scaleBtn(txt, x, delta)
		local b = Instance.new("TextButton", main)
		b.Size = UDim2.new(0, 22*scale, 0, 23*scale)
		b.Position = UDim2.new(1, x*scale, 0, 31*scale)
		b.BackgroundColor3 = Color3.fromRGB(35, 35, 39)
		b.BackgroundTransparency = 0.12
		b.BorderSizePixel = 0
		b.Text = txt
		b.TextColor3 = Color3.fromRGB(240, 240, 244)
		b.Font = Enum.Font.GothamBlack
		b.TextSize = 15*scale
		b.ZIndex = 6
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6*scale)
		local bs = Instance.new("UIStroke", b)
		bs.Color = Color3.fromRGB(100, 100, 108)
		bs.Thickness = 1
		b.MouseButton1Click:Connect(function()
			scale = math.clamp(scale + delta, 0.6, 1.6)
			createGUI()
		end)
	end
	scaleBtn("−", -61, -0.1)
	scaleBtn("+", -35, 0.1)

	-- Interruptor ON / OFF
	local tog = Instance.new("TextButton", main)
	tog.Name = "AutoStealToggle"
	tog.Size = UDim2.new(0, 72*scale, 0, 27*scale)
	tog.Position = UDim2.new(1, -85*scale, 0, 58*scale)
	tog.BackgroundColor3 = Color3.fromRGB(43, 43, 48)
	tog.BackgroundTransparency = 0.05
	tog.BorderSizePixel = 0
	tog.Text = "OFF"
	tog.TextColor3 = Color3.fromRGB(190, 190, 198)
	tog.Font = Enum.Font.GothamBlack
	tog.TextSize = 11*scale
	tog.ZIndex = 6
	Instance.new("UICorner", tog).CornerRadius = UDim.new(0, 8*scale)
	local ts = Instance.new("UIStroke", tog)
	ts.Color = Color3.fromRGB(115, 115, 123)
	ts.Thickness = 1.25
	ts.Transparency = 0.12

	tog.MouseButton1Click:Connect(function()
		Steal.Enabled = not Steal.Enabled
		if Steal.Enabled then
			tog.Text = "ON"
			tog.BackgroundColor3 = Color3.fromRGB(225, 225, 230)
			tog.TextColor3 = Color3.fromRGB(15, 15, 17)
			ts.Color = Color3.fromRGB(250, 250, 255)
			ts.Transparency = 0
			start()
		else
			tog.Text = "OFF"
			tog.BackgroundColor3 = Color3.fromRGB(43, 43, 48)
			tog.TextColor3 = Color3.fromRGB(190, 190, 198)
			ts.Color = Color3.fromRGB(115, 115, 123)
			ts.Transparency = 0.12
			stop()
		end
	end)

	-- Mantener la sombra alineada al mover la ventana
	main:GetPropertyChangedSignal("Position"):Connect(function()
		if shadow and shadow.Parent then
			shadow.Position = UDim2.new(
				main.Position.X.Scale, main.Position.X.Offset - 4*scale,
				main.Position.Y.Scale, main.Position.Y.Offset + 5*scale
			)
		end
	end)
end

createGUI()
print("KYRON AUTO STEAL • Monochrome UI cargado")