local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local MAX_SPEED = 10000
local spinEnabled = false
local spinSpeed = 100
local spinAngle = 0
local selectedImage = "rbxassetid://109740377478030"

local CONFIG_FILE = "MustSpinConfuser_Config.json"
local function saveConfig()
	pcall(function()
		if writefile then
			writefile(CONFIG_FILE, HttpService:JSONEncode({speed=spinSpeed,enabled=spinEnabled,image=selectedImage}))
		end
	end)
end
local function loadConfig()
	local ok, data = pcall(function()
		if isfile and readfile and isfile(CONFIG_FILE) then return HttpService:JSONDecode(readfile(CONFIG_FILE)) end
	end)
	if ok and type(data)=="table" then
		if tonumber(data.speed) then spinSpeed = math.clamp(math.floor(tonumber(data.speed)),1,MAX_SPEED) end
		if data.enabled==true then spinEnabled=true end
		if type(data.image)=="string" then selectedImage=data.image end
	end
end
loadConfig()

local function getParent()
	local ok,hui = pcall(function() return gethui() end)
	if ok and hui then return hui end
	local ok2,core = pcall(function() return game:GetService("CoreGui") end)
	if ok2 and core then return core end
	return LocalPlayer:WaitForChild("PlayerGui")
end

local parent = getParent()
local old = parent:FindFirstChild("MustSpinConfuserGui")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "MustSpinConfuserGui"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = parent



-- ══ VENTANA PRINCIPAL ══
local W, H = 220, 310
local frame = Instance.new("Frame")
frame.Name = "Main"
frame.Size = UDim2.new(0, W, 0, H)
frame.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
frame.BackgroundColor3 = Color3.fromRGB(9, 9, 9)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.Parent = gui
local fC = Instance.new("UICorner"); fC.CornerRadius = UDim.new(0,14); fC.Parent = frame
local fS = Instance.new("UIStroke"); fS.Color = Color3.fromRGB(150,0,0); fS.Thickness = 2.5; fS.Parent = frame

-- fondo imagen
local bgImg = Instance.new("ImageLabel")
bgImg.Size = UDim2.new(1,0,1,0)
bgImg.Image = selectedImage
bgImg.ScaleType = Enum.ScaleType.Crop
bgImg.ImageTransparency = 0.75
bgImg.BackgroundTransparency = 1
bgImg.ZIndex = 0
bgImg.Parent = frame

-- ══ HEADER ══
local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,38)
header.BackgroundColor3 = Color3.fromRGB(12,12,12)
header.BorderSizePixel = 0
header.ZIndex = 2
header.Parent = frame
local hC = Instance.new("UICorner"); hC.CornerRadius = UDim.new(0,14); hC.Parent = header
local hFix = Instance.new("Frame")
hFix.Size = UDim2.new(1,0,0,14); hFix.Position = UDim2.new(0,0,1,-14)
hFix.BackgroundColor3 = Color3.fromRGB(12,12,12); hFix.BorderSizePixel = 0; hFix.ZIndex = 2; hFix.Parent = header

local redBar = Instance.new("Frame")
redBar.Size = UDim2.new(1,0,0,2); redBar.Position = UDim2.new(0,0,1,-2)
redBar.BackgroundColor3 = Color3.fromRGB(160,0,0); redBar.BorderSizePixel = 0; redBar.ZIndex = 3; redBar.Parent = header

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(1,-50,1,0); titleLbl.Position = UDim2.new(0,12,0,0)
titleLbl.BackgroundTransparency = 1; titleLbl.Text = "MUST SPIN CONFUSER"
titleLbl.Font = Enum.Font.GothamBlack; titleLbl.TextSize = 11
titleLbl.TextColor3 = Color3.fromRGB(255,255,255)
titleLbl.TextXAlignment = Enum.TextXAlignment.Left; titleLbl.ZIndex = 3; titleLbl.Parent = header

local togglePanel = Instance.new("TextButton")
togglePanel.Size = UDim2.new(0,28,0,28)
togglePanel.Position = UDim2.new(1,-36,0.5,-14)
togglePanel.BackgroundColor3 = Color3.fromRGB(140,0,0)
togglePanel.Text = "−"
togglePanel.Font = Enum.Font.GothamBlack
togglePanel.TextSize = 20
togglePanel.TextColor3 = Color3.fromRGB(255,255,255)
togglePanel.BorderSizePixel = 0
togglePanel.ZIndex = 5
togglePanel.Parent = header
local tpC = Instance.new("UICorner"); tpC.CornerRadius = UDim.new(0,8); tpC.Parent = togglePanel

-- ══ TOGGLE SPIN ══
local spinBtn = Instance.new("TextButton")
spinBtn.Size = UDim2.new(0,190,0,36)
spinBtn.Position = UDim2.new(0.5,-95,0,50)
spinBtn.BackgroundColor3 = Color3.fromRGB(14,14,14)
spinBtn.Text = "SPIN  OFF"
spinBtn.Font = Enum.Font.GothamBlack; spinBtn.TextSize = 14
spinBtn.TextColor3 = Color3.fromRGB(255,255,255)
spinBtn.BorderSizePixel = 0; spinBtn.ZIndex = 3; spinBtn.Parent = frame
local sbC = Instance.new("UICorner"); sbC.CornerRadius = UDim.new(0,10); sbC.Parent = spinBtn
local sbS = Instance.new("UIStroke"); sbS.Color = Color3.fromRGB(130,0,0); sbS.Thickness = 2; sbS.Parent = spinBtn

-- ══ SPEED LABEL ══
local spdLbl = Instance.new("TextLabel")
spdLbl.Size = UDim2.new(0,190,0,16); spdLbl.Position = UDim2.new(0.5,-95,0,96)
spdLbl.BackgroundTransparency = 1; spdLbl.Text = "VELOCIDAD"
spdLbl.Font = Enum.Font.GothamBold; spdLbl.TextSize = 9
spdLbl.TextColor3 = Color3.fromRGB(160,0,0)
spdLbl.TextXAlignment = Enum.TextXAlignment.Left; spdLbl.ZIndex = 3; spdLbl.Parent = frame

-- ══ FILA − BOX + ══
local function mkBtn(txt, ox)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0,32,0,32); b.Position = UDim2.new(0.5,ox,0,114)
	b.BackgroundColor3 = Color3.fromRGB(140,0,0)
	b.Text = txt; b.Font = Enum.Font.GothamBlack; b.TextSize = 20
	b.TextColor3 = Color3.fromRGB(255,255,255); b.BorderSizePixel = 0; b.ZIndex = 4; b.Parent = frame
	local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,8); c.Parent = b
	return b
end
local minusBtn = mkBtn("−", -95)
local plusBtn  = mkBtn("+",  63)

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0,112,0,32); speedBox.Position = UDim2.new(0.5,-56,0,114)
speedBox.BackgroundColor3 = Color3.fromRGB(18,18,18)
speedBox.Text = tostring(spinSpeed)
speedBox.Font = Enum.Font.GothamBlack; speedBox.TextSize = 15
speedBox.TextColor3 = Color3.fromRGB(255,255,255)
speedBox.ClearTextOnFocus = false; speedBox.BorderSizePixel = 0; speedBox.ZIndex = 4; speedBox.Parent = frame
local sbxC = Instance.new("UICorner"); sbxC.CornerRadius = UDim.new(0,8); sbxC.Parent = speedBox
local sbxS = Instance.new("UIStroke"); sbxS.Color = Color3.fromRGB(60,60,60); sbxS.Thickness = 1.5; sbxS.Parent = speedBox

-- ══ DIVIDER ══
local div = Instance.new("Frame")
div.Size = UDim2.new(0,190,0,1.5); div.Position = UDim2.new(0.5,-95,0,160)
div.BackgroundColor3 = Color3.fromRGB(140,0,0); div.BorderSizePixel = 0; div.ZIndex = 3; div.Parent = frame

-- ══ IMAGE LABEL ══
local imgLbl = Instance.new("TextLabel")
imgLbl.Size = UDim2.new(0,190,0,16); imgLbl.Position = UDim2.new(0.5,-95,0,168)
imgLbl.BackgroundTransparency = 1; imgLbl.Text = "IMAGE"
imgLbl.Font = Enum.Font.GothamBlack; imgLbl.TextSize = 9
imgLbl.TextColor3 = Color3.fromRGB(160,0,0)
imgLbl.TextXAlignment = Enum.TextXAlignment.Left; imgLbl.ZIndex = 3; imgLbl.Parent = frame

-- ══ 4 BOTONES IMAGEN ══
local imageIds = {
	"rbxassetid://108138657702122",
	"rbxassetid://116110824615232",
	"rbxassetid://103873496799285",
	"rbxassetid://136327879483232",
}
local imgBtns = {}
local BS = 38; local GAP = 7
local totalW2 = #imageIds*BS + (#imageIds-1)*GAP
local sx = (W-totalW2)/2

for i, id in ipairs(imageIds) do
	local btn = Instance.new("ImageButton")
	btn.Size = UDim2.new(0,BS,0,BS)
	btn.Position = UDim2.new(0, sx+(i-1)*(BS+GAP), 0, 188)
	btn.Image = id; btn.ScaleType = Enum.ScaleType.Crop
	btn.BackgroundColor3 = Color3.fromRGB(14,14,14)
	btn.BorderSizePixel = 0; btn.ZIndex = 3; btn.Parent = frame
	local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0,8); bc.Parent = btn
	local bs = Instance.new("UIStroke")
	bs.Color = (selectedImage==id) and Color3.fromRGB(180,0,0) or Color3.fromRGB(45,45,45)
	bs.Thickness = 2; bs.Parent = btn
	imgBtns[i] = {btn=btn, stroke=bs, id=id}
end

-- ══ FOOTER ══
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1,0,0,24); footer.Position = UDim2.new(0,0,1,-24)
footer.BackgroundColor3 = Color3.fromRGB(10,10,10); footer.BorderSizePixel = 0
footer.Text = "must spin confuser  •  max "..MAX_SPEED
footer.Font = Enum.Font.Gotham; footer.TextSize = 9
footer.TextColor3 = Color3.fromRGB(80,80,80); footer.ZIndex = 3; footer.Parent = frame

-- ══ OPEN / CLOSE ══
-- Elementos que se ocultan (todo menos el header)
local hideable = {spinBtn, spdLbl, minusBtn, plusBtn, speedBox, div, imgLbl, footer}
for i = 1, #imageIds do hideable[#hideable+1] = imgBtns[i].btn end

local panelOpen = true
local function setPanel(open)
	panelOpen = open
	for _, el in ipairs(hideable) do el.Visible = open end
	frame.Size = open and UDim2.new(0,W,0,H) or UDim2.new(0,W,0,38)
	togglePanel.Text = open and "−" or "+"
end
togglePanel.MouseButton1Click:Connect(function() setPanel(not panelOpen) end)

-- ══ SELECTOR IMAGEN ══
local function selectImg(id)
	selectedImage = id; bgImg.Image = id
	for _, e in ipairs(imgBtns) do
		e.stroke.Color = (e.id==id) and Color3.fromRGB(180,0,0) or Color3.fromRGB(45,45,45)
	end
	saveConfig()
end
for _, e in ipairs(imgBtns) do
	e.btn.MouseButton1Click:Connect(function() selectImg(e.id) end)
end

-- ══ VELOCIDAD ══
local function applySpeed()
	local n = tonumber(speedBox.Text)
	if not n then speedBox.Text = tostring(spinSpeed); return end
	n = math.clamp(math.floor(n),1,MAX_SPEED)
	spinSpeed = n; speedBox.Text = tostring(n); saveConfig()
end
speedBox.FocusLost:Connect(function(e) if e then applySpeed() end end)
minusBtn.MouseButton1Click:Connect(function()
	spinSpeed = math.clamp(spinSpeed-50,1,MAX_SPEED)
	speedBox.Text = tostring(spinSpeed); saveConfig()
end)
plusBtn.MouseButton1Click:Connect(function()
	spinSpeed = math.clamp(spinSpeed+50,1,MAX_SPEED)
	speedBox.Text = tostring(spinSpeed); saveConfig()
end)

-- ══ SPIN LÓGICA ══
local function effectiveSpeed(n) return math.floor(n^1.15) end
local function getRoot()
	local c = LocalPlayer.Character
	return c and c:FindFirstChild("HumanoidRootPart")
end
local BIND = "SpinHubSpin"
local hbConn = nil
local disabled = {}

local function suppressMovers(char)
	for _, d in ipairs(char:GetDescendants()) do
		if (d:IsA("AlignOrientation") or d:IsA("BodyGyro") or d:IsA("BodyAngularVelocity") or d:IsA("AngularVelocity")) and not disabled[d] then
			pcall(function()
				if d:IsA("BodyGyro") or d:IsA("BodyAngularVelocity") then
					disabled[d]={kind="torque",value=d.MaxTorque}; d.MaxTorque=Vector3.zero
				else
					disabled[d]={kind="enabled",value=d.Enabled}; d.Enabled=false
				end
			end)
		end
	end
end
local function restoreMovers()
	for d,info in pairs(disabled) do
		pcall(function()
			if d.Parent then
				if info.kind=="torque" then d.MaxTorque=info.value else d.Enabled=info.value end
			end
		end)
	end
	disabled={}
end
local function applySpin()
	local root=getRoot(); if not root then return end
	local char=root.Parent
	local hum=char:FindFirstChildOfClass("Humanoid")
	if hum and hum.AutoRotate then hum.AutoRotate=false end
	suppressMovers(char)
	local vel=root.AssemblyLinearVelocity
	root.AssemblyAngularVelocity=Vector3.zero
	root.CFrame=CFrame.new(root.Position)*CFrame.Angles(0,math.rad(spinAngle),0)
	root.AssemblyLinearVelocity=vel
end
local function startSpin()
	pcall(function() RunService:UnbindFromRenderStep(BIND) end)
	if hbConn then hbConn:Disconnect() end
	RunService:BindToRenderStep(BIND,Enum.RenderPriority.Last.Value,function(dt)
		if not spinEnabled then return end
		dt=math.min(dt,1/30)
		spinAngle=(spinAngle+effectiveSpeed(spinSpeed)*dt)%360
		applySpin()
	end)
	hbConn=RunService.Heartbeat:Connect(function()
		if spinEnabled then applySpin() end
	end)
end
local function stopSpin()
	pcall(function() RunService:UnbindFromRenderStep(BIND) end)
	if hbConn then hbConn:Disconnect(); hbConn=nil end
	restoreMovers()
	local root=getRoot()
	local hum=root and root.Parent:FindFirstChildOfClass("Humanoid")
	if hum then hum.AutoRotate=true end
	if root then root.AssemblyAngularVelocity=Vector3.zero end
end

spinBtn.MouseButton1Click:Connect(function()
	spinEnabled=not spinEnabled
	if spinEnabled then
		spinBtn.Text="SPIN  ON"
		spinBtn.BackgroundColor3=Color3.fromRGB(130,0,0)
		sbS.Color=Color3.fromRGB(255,255,255)
		startSpin()
	else
		spinBtn.Text="SPIN  OFF"
		spinBtn.BackgroundColor3=Color3.fromRGB(14,14,14)
		sbS.Color=Color3.fromRGB(130,0,0)
		stopSpin()
	end
	saveConfig()
end)

LocalPlayer.CharacterAdded:Connect(function() disabled={}; spinAngle=0 end)

if spinEnabled then
	spinBtn.Text="SPIN  ON"
	spinBtn.BackgroundColor3=Color3.fromRGB(130,0,0)
	sbS.Color=Color3.fromRGB(255,255,255)
	startSpin()
end