-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab
-- 0.1 instant grab

repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local Steal = {
	AutoStealEnabled=false, StealRadius=55, StealDuration=0.1,
	Mode="half",
	HalfFireRange=10, HalfHoldMin=1.3, HalfHoldMax=2.6, HalfEntryDelay=0.3,
	Data={}
}
local isStealing = false
local stealStartTime = nil
local autoConn = nil
local progressFill, progressPct

local function isMyPlotByName(plotName)
	local plots=workspace:FindFirstChild("Plots"); if not plots then return false end
	local plot=plots:FindFirstChild(plotName); if not plot then return false end
	local sign=plot:FindFirstChild("PlotSign")
	if sign then local yb=sign:FindFirstChild("YourBase"); if yb and yb:IsA("BillboardGui") then return yb.Enabled==true end end
	return false
end

local function findNearestPrompt()
	local char=LP.Character; if not char then return nil end
	local root=char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
	if not root then return nil end
	local plots=workspace:FindFirstChild("Plots"); if not plots then return nil end
	local nearest,dist=nil,math.huge
	for _,plot in ipairs(plots:GetChildren()) do
		if plot:IsA("Model") and not isMyPlotByName(plot.Name) then
			local pods=plot:FindFirstChild("AnimalPodiums")
			if pods then
				for _,pod in ipairs(pods:GetChildren()) do
					local base=pod:FindFirstChild("Base")
					local sp=base and base:FindFirstChild("Spawn")
					if sp then
						local d=(sp.Position-root.Position).Magnitude
						if d<=Steal.StealRadius and d<dist then
							local found=nil
							local att=sp:FindFirstChild("PromptAttachment")
							if att then for _,pr in ipairs(att:GetChildren()) do if pr:IsA("ProximityPrompt") and pr.ActionText and pr.ActionText:find("Steal") then found=pr end end end
							if not found then for _,pr in ipairs(sp:GetDescendants()) do if pr:IsA("ProximityPrompt") and pr.ActionText and pr.ActionText:find("Steal") then found=pr end end end
							if found then nearest,dist=found,d end
						end
					end
				end
			end
		end
	end
	return nearest
end

local function _promptDist(prompt)
	local char=LP.Character; if not char then return math.huge end
	local root=char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
	if not root then return math.huge end
	local part=prompt.Parent
	if part and part:IsA("Attachment") then part=part.Parent end
	if part and part:IsA("BasePart") then return (part.Position-root.Position).Magnitude end
	local ok,cf=pcall(function() return prompt.Parent and prompt.Parent.WorldPosition end)
	if ok and cf then return (cf-root.Position).Magnitude end
	return math.huge
end

local function executeSteal(prompt)
	if isStealing then return end
	if not Steal.Data[prompt] then
		Steal.Data[prompt]={hold={},trigger={},ready=true}
		if getconnections then
			for _,c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do if c.Function then table.insert(Steal.Data[prompt].hold,c.Function) end end
			for _,c in ipairs(getconnections(prompt.Triggered)) do if c.Function then table.insert(Steal.Data[prompt].trigger,c.Function) end end
		end
	end
	local data=Steal.Data[prompt]; if not data.ready then return end
	data.ready=false; isStealing=true; stealStartTime=tick()
	if Steal.Mode=="half" then
		task.spawn(function()
			for _,fn in ipairs(data.hold) do task.spawn(fn) end
			task.wait(Steal.HalfHoldMin)
			local inRange=_promptDist(prompt)<=Steal.HalfFireRange
			while true do
				local el=tick()-stealStartTime
				if el>Steal.HalfHoldMax or not prompt.Parent then break end
				if _promptDist(prompt)<=Steal.HalfFireRange then
					if not inRange then task.wait(Steal.HalfEntryDelay) end
					for _,fn in ipairs(data.trigger) do task.spawn(fn) end; break
				end
				task.wait()
			end
			task.wait(0.05); data.ready=true; isStealing=false
		end)
	else
		task.spawn(function()
			for _,fn in ipairs(data.hold) do task.spawn(fn) end
			local el=0; while el<Steal.StealDuration do el=el+task.wait() end
			for _,fn in ipairs(data.trigger) do task.spawn(fn) end
			task.wait(0.05); data.ready=true; isStealing=false
		end)
	end
end

local function startAutoSteal()
	if autoConn then return end
	autoConn=RunService.Heartbeat:Connect(function()
		if not Steal.AutoStealEnabled or isStealing then return end
		local p=findNearestPrompt(); if p then executeSteal(p) end
	end)
end

local function stopAutoSteal()
	if autoConn then autoConn:Disconnect(); autoConn=nil end
	isStealing=false
end
_G.AutoSteal = Steal

do
	local _oldSPG = LP.PlayerGui:FindFirstChild("StealProgressScreenGui")
	if _oldSPG then _oldSPG:Destroy() end
	local spScreenGui=Instance.new("ScreenGui")
	spScreenGui.Name="StealProgressScreenGui";spScreenGui.ResetOnSpawn=false
	spScreenGui.DisplayOrder=200;spScreenGui.IgnoreGuiInset=true
	spScreenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
	spScreenGui.Parent=LP.PlayerGui

	local spFrame=Instance.new("Frame",spScreenGui)
	spFrame.Name="StealProgressGui"
	spFrame.Size=UDim2.new(0,320,0,24)
	spFrame.Position=UDim2.new(0.5,0,1,-90)
	spFrame.AnchorPoint=Vector2.new(0.5,1)
	spFrame.BackgroundTransparency=1
	spFrame.BorderSizePixel=0;spFrame.Active=true;spFrame.Visible=true
	spFrame.ZIndex=300;spFrame.ClipsDescendants=true
	Instance.new("UICorner",spFrame).CornerRadius=UDim.new(1,0)

	local shadow=Instance.new("Frame",spScreenGui)
	shadow.Name="PillShadow"
	shadow.Size=UDim2.new(0,330,0,30)
	shadow.Position=UDim2.new(0.5,0,1,-87)
	shadow.AnchorPoint=Vector2.new(0.5,1)
	shadow.BackgroundColor3=Color3.fromRGB(255,255,255)
	shadow.BackgroundTransparency=0.8
	shadow.BorderSizePixel=0
	shadow.ZIndex=299
	local shadowCorner=Instance.new("UICorner",shadow)
	shadowCorner.CornerRadius=UDim.new(1,0)
	local shadowBlur=Instance.new("BlurEffect",shadow)
	shadowBlur.Size=8
	shadow.ClipsDescendants=true

	local bgImage=Instance.new("ImageLabel",spFrame)
	bgImage.Name="BgImage"
	bgImage.Size=UDim2.new(1,0,1,0)
	bgImage.Position=UDim2.new(0,0,0,0)
	bgImage.BackgroundTransparency=1
	bgImage.Image="rbxassetid://115292342024385"
	bgImage.ZIndex=300
	bgImage.ScaleType=Enum.ScaleType.Slice
	bgImage.SliceCenter=Rect.new(4,4,4,4)

	local border=Instance.new("UIStroke",spFrame)
	border.Color=Color3.fromRGB(255,255,255)
	border.Thickness=2
	border.Transparency=0.3
	border.ApplyStrokeMode=Enum.ApplyStrokeMode.Border

	local shine=Instance.new("Frame",spFrame)
	shine.Name="Shine"
	shine.Size=UDim2.new(0.5,0,1,0)
	shine.Position=UDim2.new(-0.5,0,0,0)
	shine.BackgroundColor3=Color3.fromRGB(255,255,255)
	shine.BackgroundTransparency=0.6
	shine.BorderSizePixel=0
	shine.ZIndex=302
	shine.ClipsDescendants=true
	local shineCorner=Instance.new("UICorner",shine)
	shineCorner.CornerRadius=UDim.new(1,0)
	task.spawn(function()
		while true do
			shine.Position=UDim2.new(-0.5,0,0,0)
			TS:Create(shine,TweenInfo.new(1.2,Enum.EasingStyle.Linear),{Position=UDim2.new(1.5,0,0,0)}):Play()
			task.wait(1.2)
		end
	end)

	local spFill=Instance.new("Frame",spFrame)
	spFill.Name="ProgressFill"
	spFill.Size=UDim2.new(0,0,1,-6)
	spFill.Position=UDim2.new(0,3,0,3)
	spFill.BackgroundColor3=Color3.fromRGB(200,0,0)
	spFill.BackgroundTransparency=0
	spFill.BorderSizePixel=0
	spFill.ZIndex=301
	spFill.ClipsDescendants=true
	local fillCorner=Instance.new("UICorner",spFill)
	fillCorner.CornerRadius=UDim.new(1,0)
	local gradient=Instance.new("UIGradient",spFill)
	gradient.Color=ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(120,0,0)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200,0,0)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255,60,60))
	}
	gradient.Rotation=90

	local spPct=Instance.new("TextLabel",spFrame)
	spPct.Size=UDim2.new(1,-28,1,0)
	spPct.Position=UDim2.new(0,14,0,0)
	spPct.BackgroundTransparency=1
	spPct.Text="UNREADY"
	spPct.TextColor3=Color3.fromRGB(255,255,255)
	spPct.Font=Enum.Font.GothamBold
	spPct.TextSize=14
	spPct.TextStrokeTransparency=0.5
	spPct.TextStrokeColor3=Color3.fromRGB(0,0,0)
	spPct.TextXAlignment=Enum.TextXAlignment.Center
	spPct.TextYAlignment=Enum.TextYAlignment.Center
	spPct.ZIndex=304
	local textShadow=spPct:Clone()
	textShadow.Name="TextShadow"
	textShadow.Parent=spFrame
	textShadow.TextColor3=Color3.fromRGB(0,0,0)
	textShadow.TextStrokeTransparency=1
	textShadow.TextTransparency=0.8
	textShadow.ZIndex=303
	textShadow.Position=UDim2.new(0,14,0,1)

	progressFill=spFill
	progressPct=spPct

	local spToggleBtn=Instance.new("TextButton",spFrame)
	spToggleBtn.Name="ToggleGUIBtn"
	spToggleBtn.Size=UDim2.new(1,0,1,0)
	spToggleBtn.BackgroundTransparency=1
	spToggleBtn.Text=""
	spToggleBtn.AutoButtonColor=false
	spToggleBtn.ZIndex=310
	local _spWasDragged=false
	spToggleBtn.Activated:Connect(function()
		if _spWasDragged then return end
		local base=spFrame.Size
		TS:Create(spFrame,TweenInfo.new(0.08),{Size=UDim2.new(base.X.Scale,base.X.Offset*0.95,base.Y.Scale,base.Y.Offset*0.9)}):Play()
		task.delay(0.1,function() TS:Create(spFrame,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Size=base}):Play() end)
	end)

	local FILL_DURATION = 0.1
	local _lastPct=0
	RunService.RenderStepped:Connect(function()
		if not spFrame.Visible then return end
		local pct=0
		if isStealing and stealStartTime then
			pct=math.clamp((tick()-stealStartTime)/FILL_DURATION,0,1)
		elseif Steal.AutoStealEnabled then
			pct=(findNearestPrompt() and 1 or 0)
		end
		_lastPct=_lastPct+(pct-_lastPct)*0.2
		local f=math.clamp(_lastPct,0,1)
		spFill.Size=UDim2.new(f,-6*f,1,-6)
		if _lastPct>=0.87 then
			spPct.Text="READY"
			spPct.TextColor3=Color3.fromRGB(120,255,140)
			textShadow.TextColor3=Color3.fromRGB(0,0,0)
		else
			spPct.Text="UNREADY"
			spPct.TextColor3=Color3.fromRGB(255,255,255)
			textShadow.TextColor3=Color3.fromRGB(0,0,0)
		end
	end)

	local dragging,dragStart,startPos=false,nil,nil
	spToggleBtn.InputBegan:Connect(function(inp)
		if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
			dragging=true;_spWasDragged=false;dragStart=inp.Position;startPos=spFrame.Position
			inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then dragging=false end end)
		end
	end)
	UIS.InputChanged:Connect(function(inp)
		if not dragging then return end
		if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then
			local dx=inp.Position.X-dragStart.X
			local dy=inp.Position.Y-dragStart.Y
			if math.abs(dx)>5 or math.abs(dy)>5 then _spWasDragged=true end
			local cam=workspace.CurrentCamera
			local vp=cam and cam.ViewportSize or Vector2.new(1000,1000)
			local sz=spFrame.AbsoluteSize
			local newXScalePx=startPos.X.Scale*vp.X
			local newX=math.clamp(newXScalePx+startPos.X.Offset+dx,sz.X/2,vp.X-sz.X/2)
			local newY=math.clamp(startPos.Y.Scale*vp.Y+startPos.Y.Offset+dy,sz.Y,vp.Y)
			spFrame.Position=UDim2.new(startPos.X.Scale,newX-newXScalePx,startPos.Y.Scale,newY-startPos.Y.Scale*vp.Y)
			shadow.Position=UDim2.new(spFrame.Position.X.Scale,spFrame.Position.X.Offset,spFrame.Position.Y.Scale,spFrame.Position.Y.Offset+3)
		end
	end)
	local function updateShadow()
		shadow.Position=UDim2.new(spFrame.Position.X.Scale,spFrame.Position.X.Offset,spFrame.Position.Y.Scale,spFrame.Position.Y.Offset+3)
	end
	spFrame:GetPropertyChangedSignal("Position"):Connect(updateShadow)
	updateShadow()

	_G._CursedSetProgressBarVisible=function(v) spFrame.Visible=v; shadow.Visible=v end
end

Steal.AutoStealEnabled=true
pcall(startAutoSteal)

do
	local Workspace = game:GetService("Workspace")
	local connections = {}

	local function enableAntiDie()
		local char = LP.Character
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hum then return end

		local healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
			if hum.Health <= 0 then
				hum.Health = hum.MaxHealth
			end
		end)
		table.insert(connections, healthConn)

		local diedConn = hum.Died:Connect(function()
			task.wait()
			pcall(function()
				local newHum = Instance.new("Humanoid")
				newHum.Name = "Humanoid"
				newHum.Parent = char
				if Workspace.CurrentCamera then
					Workspace.CurrentCamera.CameraSubject = newHum
				end
				hum:Destroy()
			end)
		end)
		table.insert(connections, diedConn)
	end

	local function setup()
		for _, conn in pairs(connections) do
			pcall(conn.Disconnect, conn)
		end
		connections = {}
		enableAntiDie()
	end

	setup()
	LP.CharacterAdded:Connect(function()
		task.wait(0.1)
		setup()
	end)
end

-- GET TROLLED NIGGA
-- GET TROLLED NIGGA
-- GET TROLLED NIGGA
-- GET TROLLED NIGGA
-- GET TROLLED NIGGA
-- GET TROLLED NIGGA
-- GET TROLLED NIGGA
-- GET TROLLED NIGGA
-- GET TROLLED NIGGA
-- GET TROLLED NIGGA
-- GET TROLLED NIGGA
-- GET TROLLED NIGGA
-- GET TROLLED NIGGA
-- GET TROLLED NIGGA
-- GET TROLLED NIGGA
-- GET TROLLED NIGGA
-- GET TROLLED NIGGA
-- GET TROLLED NIGGA
-- GET TROLLED NIGGA
-- GET TROLLED NIGGA