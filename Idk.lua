if not LPH_OBFUSCATED then
    getfenv().LPH_NO_VIRTUALIZE = function(f) return f end;
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xwel33/hud/main/gui"))() --you can go into the github link and copy all of it and modify it for yourself.
local Window = Library:CreateWindow("a", Vector2.new(420, 420), Enum.KeyCode.RightControl) --you can change your UI keybind
local AimingTab = Window:CreateTab("Aiming") --you can rename this tab to whatever you want --you can also change the tabs code, for example "AimingTab" can be changed to "FunnyCoolTab" etc.
local VisualsTab = Window:CreateTab("Visuals") --you can rename this tab to whatever you want --you can also change the tabs code, for example "AimingTab" can be changed to "FunnyCoolTab" etc.
local MiscTab = Window:CreateTab("Misc") --you can rename this tab to whatever you want --you can also change the tabs code, for example "AimingTab" can be changed to "FunnyCoolTab" etc.



    

local notificationLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/laagginq/ui-libraries/main/xaxas-notification/src.lua"))();
local notifications = notificationLibrary.new({            
    NotificationLifetime = 5, 
    NotificationPosition = "Middle",
    
    TextFont = Enum.Font.Code,
    TextColor = Color3.fromRGB(255, 255, 255),
    TextSize = 15,
    
    TextStrokeTransparency = 0, 
    TextStrokeColor = Color3.fromRGB(0, 0, 0)
});

local AkaliNotif = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))();
local ANotify = AkaliNotif.Notify;


function Kick(Reason)
    game.Players.LocalPlayer:Kick(Reason)
end

getgenv().NotiMode = "Roblox"

function Notifications(NotiINFO)
    if getgenv().NotiMode == "Roblox" then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "Blazed", -- Required
            Text = NotiINFO, -- Required
            Icon = "rbxassetid://15115954522" -- Optional
        })
    else
        if getgenv().NotiMode == "Xaxa" then
            notifications:BuildNotificationUI();
            notifications:Notify(NotiINFO);
    else
        if getgenv().NotiMode == "Akali" then
            ANotify({
                Description = NotiINFO;
                Title = "Blazed";
                Duration = 1;
                });
            else
                Kick('Blazed | Notification Error, please contact on discord if this continues.')
    end
        end
            end
        end



-- Very Sexy variables :^)
local InputService, TeleportService, RunService, Workspace, Lighting, Players, HttpService, StarterGui, ReplicatedStorage, TweenService, VirtualUser, PathFindingService, Stats = game:GetService("UserInputService"), game:GetService("TeleportService"), game:GetService("RunService"), game:GetService("Workspace"), game:GetService("Lighting"), game:GetService("Players"), game:GetService("HttpService"), game:GetService("StarterGui"), game:GetService("ReplicatedStorage"), game:GetService("TweenService"), game:GetService("VirtualUser"), game:GetService("PathfindingService"), game:GetService("Stats")
local NewVector2, NewVector3, NewCFrame, NewAngle = Vector2.new, Vector3.new, CFrame.new, CFrame.Angles
local NewRGB, NewHex = Color3.fromRGB, Color3.fromHex
local Find, Clear, Sub, Upper, Lower, Insert = table.find, table.clear, string.sub, string.upper, string.lower, table.insert
local Mouse, Camera, LocalPlayer = Players.LocalPlayer:GetMouse(), Workspace.Camera, Players.LocalPlayer
local Huge, Pi, Clamp, Round, Abs, Floor, Random, Sin, Cos, Rad, Halfpi = math.huge, math.pi, math.clamp, math.round, math.abs, math.floor, math.random, math.sin, math.cos, math.rad, math.pi/2
local viewportSize = game.Workspace.Camera.ViewportSize;

getgenv().Lock = {
    Enabled = false, 
    Mode = "", 
    Locking = false, 
    Resolver = false, 
    LookAt = false, 
    ViewAt = false, 
    Target = {Player = nil, Part = nil, Position = nil, Angle = 0}, 
    ClosetPoint = false,
    AntiAimViewer = false,
    AntiCurve = false,
    UnlockOnDeath = false,
    ChatAlerts = false,
    Visualize = {
        Tracer = {false, nil}, 
        Highlight = nil,
        Dot = false, 
        Hitbox = false,
        Strafe = false,
        Notify = false,
        X = 5,
        Y = 8,
        Z = 5,
        TargetUI = nil,
    },
    Target_Strafe = {false, 0, 0, 0},
    Prediction = {
        Part = nil, -- Closest bodypart [Make it just {"HumanoidRootPart"} for just hrp]
        Air = false,
        Amount = 0.13,
        PingBased = false, 
    }, 
    Drawings = {} 
}
getgenv().offset = 0.06
local offset = getgenv().offset
-- Functions and Renders :3
    function Lock:GetPlayerStatus(Player)
        if not Player then Player = LocalPlayer end
        return Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health > 0 and true or false
    end
    -- 
    function Lock:GetClosestPlayer()
        local shortestDistance = math.huge
        --  
        local closestPlayer
        for _, Player in pairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer and Lock:GetPlayerStatus(Player) then
                local pos, OnScreen = Camera:WorldToViewportPoint(Player.Character.HumanoidRootPart.Position)
                local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(viewportSize.X/2, viewportSize.Y/2 + game:GetService("GuiService"):GetGuiInset().Y)).magnitude
                --
                if magnitude < shortestDistance and OnScreen then
                        closestPlayer = Player
                        shortestDistance = magnitude
                    end
                end
            end 
        return closestPlayer
    end
    -- 
    function Lock:newDrawing(type, prop)
        local obj = Drawing.new(type)
        --
        if prop then
            for i,v in next, prop do
                obj[i] = v
            end
        end
        return obj  
    end
    -- 
    function Lock:CalculateAbsolutePosition(Player)
        if Lock:GetPlayerStatus(Player) then
            local root = Player.Character["HumanoidRootPart"]
            --
            local currentPosition = root.Position
            local currentTime = tick() 
            --
            Wait()
            --
            local newPosition = root.Position
            local newTime = tick()
            --
            local distanceTraveled = (newPosition - currentPosition) 
            --
            local timeInterval = newTime - currentTime
            local velocity = distanceTraveled / timeInterval
            currentPosition = newPosition
            currentTime = newTime
            --
            return velocity
        end
    end 
    --
    function Lock:GetTool() 
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool") and Lock:GetPlayerStatus() then 
            return LocalPlayer.Character:FindFirstChildWhichIsA("Tool") 
        end 
    end 
    --
    function Lock:GetTracerOrigin(Origin) 
        if Origin == "Head" then 
            return Camera:WorldToViewportPoint(LocalPlayer.Character.Head.Position) 
        elseif Origin == "Gun" then
            local Tool = Lock:GetTool() 
            if Tool and Tool.Handle ~= nil then 
                return Camera:WorldToViewportPoint(Tool.Handle.Position)
            else 
                return nil 
            end 
        else 
            return Vector2.new(viewportSize.X/2, viewportSize.Y/2 + game:GetService("GuiService"):GetGuiInset().Y)
        end 
    end 
    -- Drawing and Rendering Everything
    Lock.Drawings.Tracer = Lock:newDrawing("Line", {Visible = false, Color = NewRGB(255, 255, 255), Thickness = 1, ZIndex = 2, Transparency = 1})
    Lock.Drawings.Dot = Lock:newDrawing("Circle", {Filled = true, Visible = false, Color = NewRGB(255, 255, 255), Thickness = 1, ZIndex = 2, Transparency = 1, Radius = 10})
    Lock.Drawings.FOV = Lock:newDrawing("Circle", {Visible = false, Color = NewRGB(255, 255, 255), Thickness = 1, ZIndex = 2, Transparency = 1, Radius = 2})
    -- 
    Lock.Drawings.FakeHitbox = Instance.new("Part")
    Lock.Drawings.FakeHitbox.Anchored = false 
    Lock.Drawings.FakeHitbox.CanCollide = false 
    Lock.Drawings.FakeHitbox.CFrame = CFrame.new(9999,9999,9999)
    Lock.Drawings.FakeHitbox.Parent = game.Workspace
    Lock.Drawings.FakeHitbox.Material = Enum.Material.Neon
    Lock.Drawings.FakeHitbox.Color = Color3.fromRGB(255,255,255)
    Lock.Drawings.FakeHitbox.Transparency = 0.8



local highlight = Instance.new("Highlight")



RunService.RenderStepped:Connect(function()
	if Lock.Locking and Lock.Visualize.Highlight then
    highlight.Parent = Lock.Target.Player.Character
    highlight.FillColor = getgenv().fillcolor
    highlight.OutlineColor = getgenv().outlinecolor
	else
		highlight.Parent = game.CoreGui
	end
end)




    

local gui = 
{
	targetui = Instance.new("ScreenGui"),
	Frame = Instance.new("Frame"),
	ImageLabel = Instance.new("ImageLabel"),
	LocalScript = Instance.new("LocalScript"),
	TextLabel = Instance.new("TextLabel"),
	LocalScript_1 = Instance.new("LocalScript"),
	Frame_1 = Instance.new("Frame"),
	TextLabel_1 = Instance.new("TextLabel"),
	LocalScript_2 = Instance.new("LocalScript"),
	Frame_2 = Instance.new("Frame"),
	TextLabel_2 = Instance.new("TextLabel"),
	LocalScript_3 = Instance.new("LocalScript"),
	UIGradient = Instance.new("UIGradient"),
	Shadow = Instance.new("ImageLabel"),
	Gradient = Instance.new("UIGradient"),
}


gui.targetui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.targetui.Name = "targetui"
gui.targetui.Parent = game:GetService("CoreGui")

gui.Frame.BorderSizePixel = 0
gui.Frame.Size = UDim2.new(0, 323, 0, 112)
gui.Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
gui.Frame.Name = "Frame"
gui.Frame.Position = UDim2.new(0.414371, 0, 0.854945, 0)
gui.Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
gui.Frame.Parent = gui.targetui

gui.ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
gui.ImageLabel.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
gui.ImageLabel.Size = UDim2.new(0, 75, 0, 75)
gui.ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
gui.ImageLabel.Name = "ImageLabel"
gui.ImageLabel.BackgroundTransparency = 1
gui.ImageLabel.Position = UDim2.new(0.0400908, 0, 0.151078, 0)
gui.ImageLabel.Parent = gui.Frame

gui.LocalScript.Name = "LocalScript"
gui.LocalScript.Parent = gui.ImageLabel

gui.TextLabel.TextStrokeTransparency = 0
gui.TextLabel.BorderSizePixel = 0
gui.TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
gui.TextLabel.Font = Enum.Font.Code
gui.TextLabel.TextSize = 13
gui.TextLabel.Position = UDim2.new(0.321981, 0, 0.3125, 0)
gui.TextLabel.Size = UDim2.new(0, 200, 0, 23)
gui.TextLabel.Name = "TextLabel"
gui.TextLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
gui.TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
gui.TextLabel.Text = "@nil"
gui.TextLabel.BackgroundTransparency = 1
gui.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
gui.TextLabel.Parent = gui.Frame

gui.LocalScript_1.Name = "LocalScript"
gui.LocalScript_1.Parent = gui.TextLabel

gui.Frame_1.BorderSizePixel = 0
gui.Frame_1.Size = UDim2.new(0, 211, 0, 22)
gui.Frame_1.BorderColor3 = Color3.fromRGB(0, 0, 0)
gui.Frame_1.Name = "Frame"
gui.Frame_1.Position = UDim2.new(0.321981, 0, 0.625, 0)
gui.Frame_1.BackgroundColor3 = Color3.fromRGB(227, 181, 200)
gui.Frame_1.Parent = gui.Frame

gui.TextLabel_1.TextStrokeTransparency = 0
gui.TextLabel_1.BorderSizePixel = 0
gui.TextLabel_1.BackgroundColor3 = Color3.fromRGB(227, 181, 200)
gui.TextLabel_1.Font = Enum.Font.Code
gui.TextLabel_1.TextSize = 14
gui.TextLabel_1.Position = UDim2.new(0.0584566, 0, 0, 0)
gui.TextLabel_1.Size = UDim2.new(0, 185, 0, 20)
gui.TextLabel_1.Name = "TextLabel"
gui.TextLabel_1.TextColor3 = Color3.fromRGB(255, 255, 255)
gui.TextLabel_1.BorderColor3 = Color3.fromRGB(0, 0, 0)
gui.TextLabel_1.Text = "Health: nan"
gui.TextLabel_1.BackgroundTransparency = 1
gui.TextLabel_1.Parent = gui.Frame_1

gui.LocalScript_2.Name = "LocalScript"
gui.LocalScript_2.Parent = gui.TextLabel_1

gui.Frame_2.BorderSizePixel = 0
gui.Frame_2.Size = UDim2.new(0, 323, 0, 2)
gui.Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
gui.Frame_2.Name = "Frame"
gui.Frame_2.BackgroundColor3 = Color3.fromRGB(227, 181, 200)
gui.Frame_2.Parent = gui.Frame

gui.TextLabel_2.TextStrokeTransparency = 0
gui.TextLabel_2.BorderSizePixel = 0
gui.TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
gui.TextLabel_2.Font = Enum.Font.Code
gui.TextLabel_2.TextSize = 18
gui.TextLabel_2.Position = UDim2.new(0.321981, 0, 4.07144, 0)
gui.TextLabel_2.Size = UDim2.new(0, 200, 0, 43)
gui.TextLabel_2.Name = "TextLabel"
gui.TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
gui.TextLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
gui.TextLabel_2.Text = "nil"
gui.TextLabel_2.BackgroundTransparency = 1
gui.TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left
gui.TextLabel_2.Parent = gui.Frame_2

gui.LocalScript_3.Name = "LocalScript"
gui.LocalScript_3.Parent = gui.TextLabel_2

gui.UIGradient.Name = "UIGradient"
gui.UIGradient.Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 170, 170)) }
gui.UIGradient.Rotation = 270
gui.UIGradient.Parent = gui.Frame

gui.Shadow.ImageColor3 = Color3.fromRGB(14, 14, 14)
gui.Shadow.ZIndex = 0
gui.Shadow.SliceCenter = Rect.new(18, 18, 20, 20)
gui.Shadow.ScaleType = Enum.ScaleType.Slice
gui.Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
gui.Shadow.Image = "http://www.roblox.com/asset/?id=12194054034"
gui.Shadow.Size = UDim2.new(1, 20, 1, 20)
gui.Shadow.Name = "Shadow"
gui.Shadow.BackgroundTransparency = 1
gui.Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
gui.Shadow.Parent = gui.Frame

gui.Gradient.Name = "Gradient"
gui.Gradient.Rotation = 90
gui.Gradient.Parent = gui.Shadow
gui.Frame.Visible = false

    for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if v:IsA("Script") and v.Name ~= "Health" and v.Name ~= "Sound" and v:FindFirstChild("LocalScript") then
            v:Destroy()
        end
    end
    game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
        repeat
            wait()
        until game.Players.LocalPlayer.Character
        char.ChildAdded:Connect(function(child)
            if child:IsA("Script") then 
                wait(0.1)
                if child:FindFirstChild("LocalScript") then
                    child.LocalScript:FireServer()
                end
            end
        end)
    end) 
            

             local Player = game:GetService("Players")["LocalPlayer"];
 
     Player["CharacterAdded"]:connect(function(v)
         repeat wait() until v and v:FindFirstChild("Humanoid")
     for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
         if v:IsA("Script") and v.Name ~= "Health" and v.Name ~= "Sound" and v:FindFirstChild("LocalScript") then
             v:Destroy()
         end
     end
     game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
         repeat
             wait()
         until game.Players.LocalPlayer.Character
         char.ChildAdded:Connect(function(child)
             if child:IsA("Script") then 
                 wait(0.1)
                 if child:FindFirstChild("LocalScript") then
                     child.LocalScript:FireServer()
                 end
             end
         end)
     end)
     end)


     getgenv().AimPart = "HumanoidRootPart" 
getgenv().OldAimPart = "HumanoidRootPart"
getgenv().AimlockKey = "q"
getgenv().AimRadius = 5
getgenv().ThirdPerson = true 
getgenv().FirstPerson = true
getgenv().TeamCheck = false 
getgenv().PredictMovement = false
getgenv().PredictionVelocity = 7.22

getgenv().Smoothness = false
getgenv().SmoothnessAmount = 1
getgenv().EasingStyle = Enum.EasingStyle.Elastic

getgenv().Notifications = false

getgenv().AutoPrediction = false
getgenv().UnlockOnDeath = false
getgenv().Shake = false
getgenv().ShakePower = 0

local Players, Uis, RService, SGui = game:GetService"Players", game:GetService"UserInputService", game:GetService"RunService", game:GetService"StarterGui";
local Client, Mouse, Camera, CF, RNew, Vec3, Vec2 = Players.LocalPlayer, Players.LocalPlayer:GetMouse(), workspace.CurrentCamera, CFrame.new, Ray.new, Vector3.new, Vector2.new;
local Aimlock, MousePressed, CanNotify = true, false, false;
local AimlockTarget
local OldPre;



getgenv().WorldToViewportPoint = function(P)
    return Camera:WorldToViewportPoint(P)
end

getgenv().WorldToScreenPoint = function(P) 
    return Camera.WorldToScreenPoint(Camera, P)
end

getgenv().GetObscuringObjects = function(T)
    if T and T:FindFirstChild(getgenv().AimPart) and Client and Client.Character:FindFirstChild("Head") then 
        local RayPos = workspace:FindPartOnRay(RNew(
            T[getgenv().AimPart].Position, Client.Character.Head.Position)
        )
        if RayPos then return RayPos:IsDescendantOf(T) end
    end
end

getgenv().GetNearestTarget = function()
    local players = {}
    local PLAYER_HOLD  = {}
    local DISTANCES = {}
    for i, v in pairs(Players:GetPlayers()) do
        if v ~= Client then
            table.insert(players, v)
        end
    end
    for i, v in pairs(players) do
        if v.Character ~= nil then
            local AIM = v.Character:FindFirstChild("Head")
            if getgenv().TeamCheck == true and v.Team ~= Client.Team then
                local DISTANCE = (v.Character:FindFirstChild("Head").Position - game.Workspace.CurrentCamera.CFrame.p).magnitude
                local RAY = Ray.new(game.Workspace.CurrentCamera.CFrame.p, (Mouse.Hit.p - game.Workspace.CurrentCamera.CFrame.p).unit * DISTANCE)
                local HIT,POS = game.Workspace:FindPartOnRay(RAY, game.Workspace)
                local DIFF = math.floor((POS - AIM.Position).magnitude)
                PLAYER_HOLD[v.Name .. i] = {}
                PLAYER_HOLD[v.Name .. i].dist= DISTANCE
                PLAYER_HOLD[v.Name .. i].plr = v
                PLAYER_HOLD[v.Name .. i].diff = DIFF
                table.insert(DISTANCES, DIFF)
            elseif getgenv().TeamCheck == false and v.Team == Client.Team then 
                local DISTANCE = (v.Character:FindFirstChild("Head").Position - game.Workspace.CurrentCamera.CFrame.p).magnitude
                local RAY = Ray.new(game.Workspace.CurrentCamera.CFrame.p, (Mouse.Hit.p - game.Workspace.CurrentCamera.CFrame.p).unit * DISTANCE)
                local HIT,POS = game.Workspace:FindPartOnRay(RAY, game.Workspace)
                local DIFF = math.floor((POS - AIM.Position).magnitude)
                PLAYER_HOLD[v.Name .. i] = {}
                PLAYER_HOLD[v.Name .. i].dist= DISTANCE
                PLAYER_HOLD[v.Name .. i].plr = v
                PLAYER_HOLD[v.Name .. i].diff = DIFF
                table.insert(DISTANCES, DIFF)
            end
        end
    end
    
    if unpack(DISTANCES) == nil then
        return nil
    end
    
    local L_DISTANCE = math.floor(math.min(unpack(DISTANCES)))
    if L_DISTANCE > getgenv().AimRadius then
        return nil
    end
    
    for i, v in pairs(PLAYER_HOLD) do
        if v.diff == L_DISTANCE then
            return v.plr
        end
    end
    return nil
end



RService.RenderStepped:Connect(function()
    if getgenv().ThirdPerson == true and getgenv().FirstPerson == true then 
        if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude > 1 or (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude <= 1 then 
            CanNotify = true 
        else 
            CanNotify = false 
        end
    elseif getgenv().ThirdPerson == true and getgenv().FirstPerson == false then 
        if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude > 1 then 
            CanNotify = true 
        else 
            CanNotify = false 
        end
    elseif getgenv().ThirdPerson == false and getgenv().FirstPerson == true then 
        if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude <= 1 then 
            CanNotify = true 
        else 
            CanNotify = false 
        end
    end
    if Aimlock == true and MousePressed == true then 
        if AimlockTarget and AimlockTarget.Character and AimlockTarget.Character:FindFirstChild(getgenv().AimPart) then 
            if getgenv().FirstPerson == true then
                if CanNotify == true then
                    if getgenv().PredictMovement == true then
                        if getgenv().Smoothness == true then
                            --// The part we're going to lerp/smoothen \\--
                            local Main = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position + AimlockTarget.Character[getgenv().AimPart].Velocity/PredictionVelocity)
                            
                            --// Making it work \\--
                            Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().SmoothnessAmount, getgenv().EasingStyle , Enum.EasingDirection.InOut)
                        else
                            Camera.CFrame = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position + AimlockTarget.Character[getgenv().AimPart].Velocity/PredictionVelocity)
                        end
                    elseif getgenv().PredictMovement == false then 
                        if getgenv().Smoothness == true then
                            --// The part we're going to lerp/smoothen \\--
                            local Main = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position)

                            --// Making it work \\--
                            Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().SmoothnessAmount, getgenv().EasingStyle , Enum.EasingDirection.InOut)
                        else
                            Camera.CFrame = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position)
                        end
                    end
                end
            end
        end
    end
   if getgenv().UnlockOnDeath  == true and AimlockTarget and AimlockTarget.Character:FindFirstChild("Humanoid") then
    if AimlockTarget.StarterPlayer.StarterCharacterScripts.BodyEffects['K.O'] then
        AimlockTarget = nil
        
        if getgenv().Notifications == true then
            Notify({
                Title = "Blazed",
                Description = "Unlocked",
                Duration = 1
            })
        end
        if getgenv().ChatNotis == true then
game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Unlocked","All")
        end
    end
end

            if getgenv().Shake == true and AimlockTarget and AimlockTarget.Character then
                local Main = CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position + AimlockTarget.Character[getgenv().AimPart].Velocity/PredictionVelocity +
                Vector3.new(
                    math.random(-getgenv().ShakePower, getgenv().ShakePower),
                    math.random(-getgenv().ShakePower, getgenv().ShakePower),
                    math.random(-getgenv().ShakePower, getgenv().ShakePower)
                ) * 0.1)
                Camera.CFrame = Camera.CFrame:Lerp(Main, getgenv().SmoothnessAmount, getgenv().EasingStyle , Enum.EasingDirection.InOut)
            end

   if getgenv().AutoPrediction == true then
    pingvalue = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
    split = string.split(pingvalue,'(')
    ping = tonumber(split[1])
if ping < 30 then
    getgenv().PredictionVelocity = 7.758
elseif ping < 40 then
    getgenv().PredictionVelocity = 7.364
elseif ping < 50 then
    getgenv().PredictionVelocity = 7.456 
elseif ping < 60 then
    getgenv().PredictionVelocity = 7.217
elseif ping < 70 then
    getgenv().PredictionVelocity = 6.972 
elseif ping < 80 then
    getgenv().PredictionVelocity = 6.782
elseif ping < 90 then
    getgenv().PredictionVelocity = 6.597 
elseif ping < 100 then
    getgenv().PredictionVelocity = 3.88
elseif ping < 110 then
    getgenv().PredictionVelocity = 6.099
end
end

end)

local aimlockSection = AimingTab:CreateSector("Aimlock", "left")  --you can  change the section code, for example "aimlockSection" can be changed to "FunnyCoolSection" etc.
local aimassistSection = AimingTab:CreateSector("Aim Assist", "Right")  --you can  change the section code, for example "aimlockSection" can be changed to "FunnyCoolSection" etc.

aimlockSection:AddToggle("Enable", false, function(ale)
    getgenv().AimlockEnabled = ale
end)
aimlockSection:AddButton("Lock Tool", function(IhateGayPeople)
    getgenv().keytoclick = "Q"
    tool = Instance.new("Tool")
    tool.RequiresHandle = false
    tool.Name = "CamlockTool"
    tool.Activated:connect(function()
        if AimlockEnabled then 
            Target = not Target
            --
            if AimlockTarget then
                AimlockTarget = nil
                MousePressed = false
                if getgenv().Notifications then
                    Notifications("Unlocked")
                end
            else
                if AimlockTarget == nil then
                    local Target;Target = GetNearestTarget()
                    if Target ~= nil then 
                        AimlockTarget = Target
                        if getgenv().Notifications then
                            notifications:BuildNotificationUI();
                            Notifications("Locked Onto"..tostring(Aimlock));
                        end
                        MousePressed = true
                    end
                end
            end
                end
    end)
    tool.Parent = game.Players.LocalPlayer.Backpack
    wait(0.2)
end)
aimlockSection:AddTextbox("Prediction", "7.72", function(int)
    getgenv().PredictionVelocity = int
    notifications:BuildNotificationUI();
    Notifications("Prediction Changed To: "..tostring(int));
end)
aimlockSection:AddToggle("Ping Based", false, function(pba)
    getgenv().AutoPrediction = pba
end)
aimlockSection:AddDropdown("Hitpart", {"HumanoidRootPart", "UpperTorso", "LowerTorso", "Head"}, "HumanoidRootPart", false, function(dropdown)
    getgenv().AimPart = dropdown
end)
aimlockSection:AddToggle("Notifications", false, function(n)
    getgenv().Notifications = n
end)
aimlockSection:AddToggle("Shake", false, function(shake)
    getgenv().Shake = shake
end)
aimlockSection:AddSlider("Shake Power", 0, 1, 5, 1, function(int)
    getgenv().ShakePower = int * 2
end)
aimlockSection:AddToggle("Smoothness", false, function(sm)
    getgenv().Smoothness = sm
end)
aimlockSection:AddTextbox("Smoothness Power", nil, function(int)
    getgenv().SmoothnessAmount = int
    notifications:BuildNotificationUI();
    Notifications("Smoothness Power Changed To: "..tostring(int));
end)

aimassistSection:AddToggle("Enable", false, function(first)
Lock.Enabled = first
end)
aimassistSection:AddDropdown("Mode", {"Target Aim", "Silent Aim"}, "Target Aim", false, function(dropdown)
Lock.Mode = dropdown
end)
aimassistSection:AddButton("Lock Tool", function(IhateGayPeople)
    getgenv().keytoclick = "Q"
    tool = Instance.new("Tool")
    tool.RequiresHandle = false
    tool.Name = "AimAssist Tool"
    tool.Activated:connect(function()
        if Lock.Enabled then 
            Lock.Locking = not Lock.Locking 
            -- 
            if Lock.Locking == true then 
                Lock.Target.Player = Lock:GetClosestPlayer() 
    
                -- target ui
                if Lock.Visualize.TargetUI then
                gui.TextLabel.Text = "@"..tostring(Lock.Target.Player)
                gui.TextLabel_2.Text = Lock.Target.Player.DisplayName
                RunService.RenderStepped:Connect(function()
                gui.TextLabel_1.Text = "Health: "..tostring(Lock.Target.Player.Character.Humanoid.Health)
                end)
    
                local player = Lock.Target.Player
    
                local userId = Lock.Target.Player.UserId
                local thumbType = Enum.ThumbnailType.HeadShot
                local thumbSize = Enum.ThumbnailSize.Size420x420
                local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
    
                local imageLabel = gui.ImageLabel
                imageLabel.Image = content
                imageLabel.Size = UDim2.new(0, 75,0, 75)
                gui.Frame.Visible = true
            end
                -- target ui
    
                if (Lock.Visualize.Notify == true) then 
                    if Lock.Mode == "Target Aim" then
                    notifications:BuildNotificationUI();
                    Notifications("Locked onto: ".. Lock.Target.Player.DisplayName);
                    wait(1) print(Lock.Target.Prediction)
                    else
                        notifications:BuildNotificationUI();
                        Notifications("Silent Aim Enabled");
                    end
                else
            end
                -- 
            if Lock.ViewAt then 
                Camera.CameraSubject = Lock.Target.Player.Character.Humanoid
            end     
        else 
            if Lock.Visualize.TargetUI then
            gui.Frame.Visible = false
        end
            Lock.Drawings.Dot.Visible = false 
            Lock.Drawings.Tracer.Visible = false 
            Camera.CameraSubject = LocalPlayer.Character.Humanoid
            LocalPlayer.Character.Humanoid.AutoRotate = true 
            -- 
            if (Lock.Visualize.Notify == true) then 
                if Lock.Mode == "Target Aim" then
                    notifications:BuildNotificationUI();
                    Notifications("Unlocked");
                    else
                        notifications:BuildNotificationUI();
                        Notifications("Silent Aim Disabled");
                    end
            end 
        end 
        end 
    end)
    tool.Parent = game.Players.LocalPlayer.Backpack
    wait(0.2)
end)
aimassistSection:AddToggle("Resolver", false, function(first)
    Lock.Resolver = first
end)
aimassistSection:AddTextbox("Prediction", nil, function(State)
    Lock.Target.Prediction = State
end)
aimassistSection:AddToggle("Notifications", false, function(first)
    Lock.Visualize.Notify = first
end)
aimassistSection:AddToggle("Ping Based", false, function(first)
    Lock.Prediction.PingBased = first
end)
aimassistSection:AddToggle("Air Prediction", false, function(first)
    Lock.Prediction.Air = first
end)
aimassistSection:AddDropdown("Hitpart", {"HumanoidRootPart", "UpperTorso", "LowerTorso", "Head"}, "HumanoidRootPart", false, function(dropdown)
Lock.Prediction.Part = dropdown
end)
aimassistSection:AddToggle("Look At", false, function(first)
Lock.LookAt = first
end)
aimassistSection:AddToggle("View At", false, function(first)
Lock.ViewAt = first
end)

local aimbotVisuals = VisualsTab:CreateSector("Aimbot", "left")  --you can  change the section code, for example "aimbotVisuals" can be changed to "FunnyCoolSection" etc.
local ColorToggle = aimbotVisuals:AddToggle("Fake Hitbox", false, function(e)
Lock.Visualize.Hitbox = e
end)

ColorToggle:AddColorpicker(Color3.fromRGB(255,0,255), function(ztx)
    Lock.Drawings.FakeHitbox.Color = ztx
end)
aimbotVisuals:AddDropdown("Hitbox Material", {"ForceField", "Neon", "Glass"}, "ForceField", false, function(dropdown)
    Lock.Drawings.FakeHitbox.Material = dropdown
end)
aimbotVisuals:AddSlider("Hitbox Size", 0, 4, 15, 1, function(State)
    Lock.Visualize.X = State
    Lock.Visualize.Y = State
    Lock.Visualize.Z = State
end)
local highlightToggle = aimbotVisuals:AddToggle("Highlight", false, function(e)
    Lock.Visualize.Highlight = e
end)

highlightToggle:AddColorpicker(Color3.fromRGB(255,0,255), function(ztx)
    getgenv().fillcolor = ztx
end)
highlightToggle:AddColorpicker(Color3.fromRGB(0,0,0), function(ztx)
    getgenv().outlinecolor = ztx
end)

local dotToggle = aimbotVisuals:AddToggle("Dot", false, function(e)
    Lock.Visualize.Dot = e
end)

dotToggle:AddColorpicker(Color3.fromRGB(255,0,255), function(ztx)
    Lock.Drawings.Dot.Color = ztx
end)
local tracerToggle = aimbotVisuals:AddToggle("Tracer", false, function(e)
    Lock.Visualize.Tracer[1] = e
end)

tracerToggle:AddColorpicker(Color3.fromRGB(255,0,255), function(ztx)
    Lock.Drawings.Tracer.Color = ztx
end)

aimbotVisuals:AddDropdown("Tracer Origin", {"Head", "Mouse", "Gun"}, "Gun", true, function(dropdown)
    Lock.Visualize.Tracer[2] = dropdown
end)
getgenv().CFMULTIPLIER = 1
local miscCharacter = MiscTab:CreateSector("Character", "left")  --you can  change the section code, for example "aimbotVisuals" can be changed to "FunnyCoolSection" etc.
miscCharacter:AddToggle("CFrame", false, function(state)
    if state then
        getgenv().cfrene = not getgenv().cfrene
    if getgenv().cfrene == true then
        repeat
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.Humanoid.MoveDirection * CFMULTIPLIER
            game:GetService("RunService").Stepped:wait()
        until getgenv().cfrene == false
end
end
end)

RunService.Heartbeat:Connect(function(FPS)
    if Lock.Drawings.FOV.Visible and Lock.Drawings.FOV.Position ~= NewVector2(viewportSize.X/2, viewportSize.Y/2 + offset) then 
        Lock.Drawings.FOV.Position = NewVector2(viewportSize.X/2, viewportSize.Y/2 + offset)
    end
    --   
    if Lock.Locking and Lock.Target.Player and Lock:GetPlayerStatus(Lock.Target.Player) then
        if Lock.Mode == "Silent Aim" then 
            Lock.Target.Player = Lock:GetClosestPlayer()
        end 
        -- 
        if Lock.Target.Player and Lock.Target.Player.Character then 
            Lock.Target.Status = Lock:GetPlayerStatus(Lock.Target.Player)
            Lock.Target.Velocity = Lock.Resolver and Lock:CalculateAbsolutePosition(Lock.Target.Player) or Lock.Target.Player.Character.HumanoidRootPart.Velocity
            
            
  --ELEGANT WORK ON THIS, DONT DO ANYTHING ELSE!
  if Lock.Prediction.PingBased then
    local pingvalue = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
    local split = string.split(pingvalue,'(')
    local ping = tonumber(split[1])    
    --[[ elegants 
    if ping < 100 then
        Lock.Target.Prediction = 0.141987
    elseif ping < 80 then
        Lock.Target.Prediction = 0.139340
    elseif ping < 70 then
        Lock.Target.Prediction = 0.12533
          elseif ping < 65 then
            Lock.Target.Prediction = 0.1264236
    elseif ping < 50 then
        Lock.Target.Prediction = 0.13544
    elseif ping < 30 then
        Lock.Target.Prediction = 0.11252476
        
        --[[ louls 
        if ping < 30 then
            Lock.Target.Prediction = 0.1099
        elseif
            ping < 35 then
                Lock.Target.Prediction = 0.2294
            elseif
                ping < 40 then
                    Lock.Target.Prediction = 0.1195
                elseif
                    ping < 45 then
                        Lock.Target.Prediction = 0.1207
                    elseif
                        ping < 50 then
                            Lock.Target.Prediction = 0.1219
                        elseif      
                            ping < 55 then
                                Lock.Target.Prediction = 0.1228
                            elseif
                                ping < 60 then
                                    Lock.Target.Prediction = 0.1237 
                                elseif
                                    ping < 65 then 
                                        Lock.Target.Prediction = 0.1264 
                                    elseif
                                        ping < 70 then
                                            Lock.Target.Prediction = 0.1291
                                        elseif
                                            ping < 75 then
                                                Lock.Target.Prediction = 0.1314
                                            elseif
                                                ping < 80 then 
                                                    Lock.Target.Prediction = 0.1337 
                                                elseif
                                                    ping < 85 then
                                                        Lock.Target.Prediction = 0.1343
                                                    elseif
                                                        ping < 90 then
                                                            Lock.Target.Prediction = 0.1349
                                                        elseif
                                                            ping < 95 then
                                                                Lock.Target.Prediction = 0.1363
                                                            elseif
                                                                ping < 100 then
                                                                    Lock.Target.Prediction = 0.1378
                                                                elseif
                                                                    ping < 105 then
                                                                        Lock.Target.Prediction = 0.1418 
                                                                    elseif
                                                                        ping < 110 then
                                                                        Lock.Target.Prediction = 0.1459
                                                                        ]]

                                                                        -- sosa sets

                                                                        if ping < 10 then
                                                                            Lock.Target.Prediction = 0.1112873
                                                                        elseif ping < 20 then
                                                                            Lock.Target.Prediction = 0.1211928
                                                                        elseif ping < 30 then
                                                                            Lock.Target.Prediction = 0.1254263
                                                                        elseif ping < 40 then
                                                                            Lock.Target.Prediction = 0.1314356
                                                                        elseif ping < 50 then
                                                                            Lock.Target.Prediction = 0.1368384
                                                                        elseif ping < 60 then
                                                                            Lock.Target.Prediction = 0.12671983
                                                                        elseif ping < 70 then
                                                                            Lock.Target.Prediction = 0.12862974
                                                                        elseif ping < 80 then
                                                                            Lock.Target.Prediction = 0.13581963
                                                                        elseif ping < 90 then
                                                                            Lock.Target.Prediction = 0.13873952
                                                                        elseif ping < 100 then
                                                                            Lock.Target.Prediction = 0.14173456
                                                                        elseif ping < 110 then
                                                                            Lock.Target.Prediction = 0.14362652
                                                                        elseif ping < 120 then
                                                                            Lock.Target.Prediction = 0.14683943
                                                                        elseif ping < 130 then
                                                                            Lock.Target.Prediction = 0.15175864
                                                                        elseif ping < 140 then
                                                                            Lock.Target.Prediction = 0.15382643
                                                                        elseif ping < 150 then
                                                                            Lock.Target.Prediction = 0.15873582
                                                                        end
                                                                    end

                                                                    if Lock.Target_Strafe[1] then 
                                                                        Lock.Target.Angle += Lock.Target_Strafe[2]
                                                                        LocalPlayer.Character.HumanoidRootPart.CFrame = 
                                                                        Lock.Target.Player.Character.HumanoidRootPart.CFrame 
                                                                        * NewAngle(0, Rad(Lock.Target.Angle), 0) 
                                                                        * NewCFrame(0, Lock.Target_Strafe[4], Lock.Target_Strafe[3])
                                                                    end 
                                                                    --
                                                                    if Lock.LookAt then 
                                                                        LocalPlayer.Character.Humanoid.AutoRotate = false 
                                                                        local NearestPos = CFrame.new(LocalPlayer.Character.PrimaryPart.Position, Vector3.new(Lock.Target.Player.Character.HumanoidRootPart.Position.X, LocalPlayer.Character.PrimaryPart.Position.Y, Lock.Target.Player.Character.HumanoidRootPart.Position.Z))
                                                                        LocalPlayer.Character:SetPrimaryPartCFrame(NearestPos)
                                                                    end 
                                                                    -- 
                                                                    if Lock.Target.Position then 
                                                                        local Position1, OnScreen = Camera:WorldToViewportPoint(Lock.Target.Position)
                                                                        local MousePosition = NewVector2(viewportSize.X/2, viewportSize.Y/2 + game:GetService("GuiService"):GetGuiInset().Y)
                                                                        local Magn = (MousePosition - NewVector2(Position1.X, Position1.Y)).Magnitude
                                                                        -- 
                                                                        if Lock.Drawings.FOV.Visible then 
                                                                            Lock.Drawings.FOV.Position = NewVector2(viewportSize.X/2, viewportSize.Y/2 + game:GetService("GuiService"):GetGuiInset().Y)
                                                                            if (Magn >= Lock.Drawings.FOV.Radius) then Lock.Target.Status = false end 
                                                                        end
                                                                        -- 
                                                                        if Lock.Visualize.Hitbox == true then 
                                                                            Lock.Drawings.FakeHitbox.CFrame = NewCFrame(Lock.Target.Position)
                                                                            Lock.Drawings.FakeHitbox.Size = NewVector3(Lock.Visualize.X, Lock.Visualize.Y, Lock.Visualize.Z)
                                                                        else 
                                                                            Lock.Drawings.FakeHitbox.CFrame = NewCFrame(999,9999,999)
                                                                        end 
                                                                        -- 
                                                                        if OnScreen then 
                                                                            if Lock.Visualize.Tracer[1] then 
                                                                                Lock.Drawings.Tracer.Visible = true 
                                                                                --
                                                                                if Lock:GetTracerOrigin(Lock.Visualize.Tracer[2]) ~= nil then 
                                                                                    local Position2, OnScreen = Lock:GetTracerOrigin(Lock.Visualize.Tracer[2])  
                                                                                    --
                                                                                    if Position2 then 
                                                                                        Lock.Drawings.Tracer.From = Vector2.new(Position2.X, Position2.Y)
                                                                                    end 
                                                                                end 
                                                                                Lock.Drawings.Tracer.To = Vector2.new(Position1.X, Position1.Y)
                                                                            end
                                                                            -- 
                                                                            if Lock.Visualize.Dot then 
                                                                                Lock.Drawings.Dot.Visible = true 
                                                                                Lock.Drawings.Dot.Position = NewVector2(Position1.X, Position1.Y)
                                                                            else 
                                                                                Lock.Drawings.Dot.Visible = false 
                                                                            end 
                                                                        else 
                                                                            Lock.Drawings.Dot.Visible = false 
                                                                            Lock.Drawings.Tracer.Visible = false 
                                                                        end  
                                                                    end 
                                                                end
                                                            end
                                                        end)
                                                        
                                                        if not LPH_OBFUSCATED then
                                                            getfenv().LPH_NO_VIRTUALIZE = function(f) return f end;
                                                            end
                                                            local Old
                                                            Old = hookmetamethod(game, "__index", LPH_NO_VIRTUALIZE(function(self, k)
                                                                if (self:IsA("Mouse") and (k == "Hit" or k == "Target")) and Lock.Locking and Lock.Target.Player then 
                                                                    local Part = Lock.Prediction.Part or "HumanoidRootPart"
                                                                    if Lock.Prediction.Air == true and Lock.Target.Player.Character.Humanoid.FloorMaterial == Enum.Material.Air then 
                                                                        SilentArg = Lock.Target.Player.Character["LeftFoot"].Position + (Lock.Target.Velocity * Lock.Target.Prediction)
                                                                    else 
                                                                        SilentArg = Lock.Target.Player.Character[Part].Position + (Lock.Target.Velocity * Lock.Target.Prediction)
                                                                    end 
                                                                    Lock.Target.Position = SilentArg
                                                                    -- 
                                                                    if Lock.Target.Status == true then  
                                                                        return (k == "Hit" and NewCFrame(SilentArg))
                                                                    end 
                                                                end 
                                                                return Old(self, k) 
                                                            end))