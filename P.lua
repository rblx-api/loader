local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

-- // THEME (BLACK + WHITE)
local C_WHITE     = Color3.fromRGB(255, 255, 255)
local C_WHITE_DIM = Color3.fromRGB(180, 180, 180)
local C_WHITE_DARK= Color3.fromRGB(120, 120, 120)

local C_BG        = Color3.fromRGB(8, 8, 8)
local C_PANEL     = Color3.fromRGB(12, 12, 12)
local C_ROW       = Color3.fromRGB(16, 16, 16)
local C_ROW_HOV   = Color3.fromRGB(24, 24, 24)
local C_BORDER    = Color3.fromRGB(40, 40, 40)
local C_BORDER2   = Color3.fromRGB(60, 60, 60)
local C_HEADER    = Color3.fromRGB(5, 5, 5)
local C_ACCENT    = C_WHITE
local C_ACCENT2   = Color3.fromRGB(255, 255, 255)
local C_DIM       = Color3.fromRGB(100, 100, 100)
local C_ON_BG     = Color3.fromRGB(25, 25, 25)
local C_OFF_BG    = Color3.fromRGB(18, 18, 18)
local C_KEY_BG    = Color3.fromRGB(12, 12, 12)
local C_MOBILE_BTN = Color3.fromRGB(45, 45, 45)
local C_MOBILE_BTN_HOV = Color3.fromRGB(55, 55, 55)

-- // CONFIG SAVE/LOAD
local ConfigFile = "MwvaneDesyncAutoBat_Config.json"
local Config = {
    Position = {X_Scale = 0.5, X_Offset = -124, Y_Scale = 0.5, Y_Offset = -87}
}

local function SaveConfig()
    if writefile then
        pcall(function() writefile(ConfigFile, HttpService:JSONEncode(Config)) end)
    end
end

local function LoadConfig()
    if isfile and isfile(ConfigFile) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(ConfigFile)) end)
        if success and data and data.Position then
            Config.Position = data.Position
        end
    end
end
LoadConfig()

-- // STATE
local State = {
    autoBatToggled = false,
    hittingCooldown = false,
    guiVisible = true,
}

local Keys = {
    autoBat            = Enum.KeyCode.X,
    guiHide            = Enum.KeyCode.LeftControl,
    controller_autoBat = Enum.KeyCode.ButtonX,
    controller_guiHide = Enum.KeyCode.ButtonSelect,
}

local h, hrp = nil, nil

-- // CLEANUP OLD GUI
for _, name in pairs({"Mwvane Desync Auto Bat", "MwvaneNewaBatDesyncGUI", "PhazeAutoBatDesyncGUI"}) do
    local old = game:GetService("CoreGui"):FindFirstChild(name)
    if old then old:Destroy() end
end

-- // DRAGGABLE
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    frame.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=inp.Position; startPos=frame.Position
            inp.Changed:Connect(function()
                if inp.UserInputState==Enum.UserInputState.End then dragging=false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then dragInput=inp end
    end)
    UIS.InputChanged:Connect(function(inp)
        if inp==dragInput and dragging then
            local dx = inp.Position.X - dragStart.X
            local dy = inp.Position.Y - dragStart.Y
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+dx, startPos.Y.Scale, startPos.Y.Offset+dy)
        end
    end)
end

-- // GUI
local gui = Instance.new("ScreenGui")
gui.Name="Mwvane Desync Auto Bat"; gui.ResetOnSpawn=false; gui.DisplayOrder=10
gui.IgnoreGuiInset=true; gui.Parent=LP:WaitForChild("PlayerGui")

-- Shadow
local shadow = Instance.new("Frame",gui)
shadow.Size=UDim2.new(0,260,0,185)
shadow.Position=UDim2.new(Config.Position.X_Scale, Config.Position.X_Offset+3, Config.Position.Y_Scale, Config.Position.Y_Offset+3)
shadow.BackgroundColor3=Color3.fromRGB(0,0,0); shadow.BackgroundTransparency=0.6; shadow.BorderSizePixel=0
Instance.new("UICorner",shadow).CornerRadius=UDim.new(0,14)

local main = Instance.new("Frame",gui)
main.Name="Main"; main.Size=UDim2.new(0,254,0,179)
main.Position=UDim2.new(Config.Position.X_Scale, Config.Position.X_Offset, Config.Position.Y_Scale, Config.Position.Y_Offset)
main.BackgroundColor3=C_BG; main.BorderSizePixel=0; main.Active=true; main.ClipsDescendants=true
Instance.new("UICorner",main).CornerRadius=UDim.new(0,12)
local mainStroke = Instance.new("UIStroke",main); mainStroke.Color=C_BORDER2; mainStroke.Thickness=1.5

do
    local dragging, dragInput, dragStart, mainStart, shadowStart = false, nil, nil, nil, nil
    main.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=inp.Position; mainStart=main.Position; shadowStart=shadow.Position
            inp.Changed:Connect(function()
                if inp.UserInputState==Enum.UserInputState.End then 
                    dragging=false
                    -- Save position when drag ends
                    Config.Position = {
                        X_Scale = main.Position.X.Scale,
                        X_Offset = main.Position.X.Offset,
                        Y_Scale = main.Position.Y.Scale,
                        Y_Offset = main.Position.Y.Offset
                    }
                    SaveConfig()
                end
            end)
        end
    end)
    main.InputChanged:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then dragInput=inp end
    end)
    UIS.InputChanged:Connect(function(inp)
        if inp==dragInput and dragging then
            local dx = inp.Position.X - dragStart.X
            local dy = inp.Position.Y - dragStart.Y
            main.Position = UDim2.new(mainStart.X.Scale, mainStart.X.Offset+dx, mainStart.Y.Scale, mainStart.Y.Offset+dy)
            shadow.Position = UDim2.new(shadowStart.X.Scale, shadowStart.X.Offset+dx, shadowStart.Y.Scale, shadowStart.Y.Offset+dy)
        end
    end)
end

-- // HEADER
local header = Instance.new("Frame",main)
header.Size=UDim2.new(1,0,0,44); header.BackgroundColor3=C_HEADER; header.BorderSizePixel=0; header.ZIndex=5
local headerDiv = Instance.new("Frame",header)
headerDiv.Size=UDim2.new(1,0,0,1); headerDiv.Position=UDim2.new(0,0,1,-1)
headerDiv.BackgroundColor3=C_DIM; headerDiv.BorderSizePixel=0; headerDiv.ZIndex=6

local titleLbl = Instance.new("TextLabel",header)
titleLbl.Size=UDim2.new(0,200,0,16); titleLbl.Position=UDim2.new(0,14,0,8)
titleLbl.BackgroundTransparency=1; titleLbl.Text="MWVANE DESYNC AUTO BAT"
titleLbl.TextColor3=C_WHITE; titleLbl.Font=Enum.Font.GothamBlack; titleLbl.TextSize=11
titleLbl.TextXAlignment=Enum.TextXAlignment.Left; titleLbl.ZIndex=6

local closeBtn = Instance.new("TextButton",main)
closeBtn.Size=UDim2.new(0,24,0,24); closeBtn.Position=UDim2.new(1,-32,0,10)
closeBtn.BackgroundColor3=Color3.fromRGB(20,20,20); closeBtn.BorderSizePixel=0
closeBtn.Text="X"; closeBtn.TextColor3=C_WHITE; closeBtn.Font=Enum.Font.GothamBlack
closeBtn.TextSize=12; closeBtn.ZIndex=10
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)
local closeBtnStroke = Instance.new("UIStroke",closeBtn); closeBtnStroke.Color=C_BORDER2
closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(255,60,60),TextColor3=Color3.fromRGB(255,255,255)}):Play()
    TweenService:Create(closeBtnStroke,TweenInfo.new(0.12),{Color=Color3.fromRGB(255,60,60)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(20,20,20),TextColor3=C_WHITE}):Play()
    TweenService:Create(closeBtnStroke,TweenInfo.new(0.12),{Color=C_BORDER2}):Play()
end)
closeBtn.MouseButton1Click:Connect(function()
    State.autoBatToggled = false
    gui:Destroy(); shadow:Destroy()
end)

-- // CONTENT AREA
local content = Instance.new("Frame",main)
content.Size=UDim2.new(1,-20,1,-52); content.Position=UDim2.new(0,10,0,48)
content.BackgroundTransparency=1; content.BorderSizePixel=0
local listLayout = Instance.new("UIListLayout",content)
listLayout.SortOrder=Enum.SortOrder.LayoutOrder; listLayout.Padding=UDim.new(0,5)

local lo = 0
local function LO() lo+=1; return lo end

local function makeGap(px)
    local f=Instance.new("Frame",content); f.Size=UDim2.new(1,0,0,px or 4)
    f.BackgroundTransparency=1; f.BorderSizePixel=0; f.LayoutOrder=LO()
end

-- // STATUS ROW
local statusRow = Instance.new("Frame",content)
statusRow.Size=UDim2.new(1,0,0,28); statusRow.BackgroundColor3=C_ROW; statusRow.BorderSizePixel=0; statusRow.LayoutOrder=LO()
Instance.new("UICorner",statusRow).CornerRadius=UDim.new(0,6)
local statusRowStroke = Instance.new("UIStroke",statusRow); statusRowStroke.Color=C_BORDER
local statusLbl = Instance.new("TextLabel",statusRow)
statusLbl.Size=UDim2.new(0.5,0,1,0); statusLbl.Position=UDim2.new(0,12,0,0)
statusLbl.BackgroundTransparency=1; statusLbl.Text="Status"; statusLbl.TextColor3=C_WHITE
statusLbl.Font=Enum.Font.GothamBold; statusLbl.TextSize=11; statusLbl.TextXAlignment=Enum.TextXAlignment.Left
local statusVal = Instance.new("TextLabel",statusRow)
statusVal.Size=UDim2.new(0.45,-10,1,0); statusVal.Position=UDim2.new(0.52,0,0,0)
statusVal.BackgroundTransparency=1; statusVal.Text="OFF"; statusVal.TextColor3=Color3.fromRGB(255,60,60)
statusVal.Font=Enum.Font.GothamBlack; statusVal.TextSize=11; statusVal.TextXAlignment=Enum.TextXAlignment.Right

makeGap(2)

-- // AUTO BAT TOGGLE ROW (with mobile clickable area)
local toggleRow = Instance.new("Frame",content)
toggleRow.Size=UDim2.new(1,0,0,42); toggleRow.BackgroundColor3=C_ROW; toggleRow.BorderSizePixel=0; toggleRow.LayoutOrder=LO()
Instance.new("UICorner",toggleRow).CornerRadius=UDim.new(0,6)
local toggleRowStroke = Instance.new("UIStroke",toggleRow); toggleRowStroke.Color=C_BORDER
local toggleLbl = Instance.new("TextLabel",toggleRow)
toggleLbl.Size=UDim2.new(0,100,1,0); toggleLbl.Position=UDim2.new(0,12,0,0)
toggleLbl.BackgroundTransparency=1; toggleLbl.Text="Auto Bat"; toggleLbl.TextColor3=C_WHITE
toggleLbl.Font=Enum.Font.GothamBold; toggleLbl.TextSize=11; toggleLbl.TextXAlignment=Enum.TextXAlignment.Left

-- Keybind button
local keyBtn = Instance.new("TextButton",toggleRow)
keyBtn.Size=UDim2.new(0,58,0,22); keyBtn.Position=UDim2.new(1,-115,0.5,-11)
keyBtn.BackgroundColor3=C_KEY_BG; keyBtn.BorderSizePixel=0; keyBtn.Text=Keys.autoBat.Name
keyBtn.TextColor3=C_WHITE; keyBtn.Font=Enum.Font.GothamBold; keyBtn.TextSize=10; keyBtn.ZIndex=5
Instance.new("UICorner",keyBtn).CornerRadius=UDim.new(0,4)
local ks = Instance.new("UIStroke",keyBtn); ks.Color=C_BORDER2; ks.Thickness=1
local kListening = false; local kConn
keyBtn.MouseButton1Click:Connect(function()
    if kListening then kListening=false; if kConn then kConn:Disconnect(); kConn=nil end
        TweenService:Create(ks,TweenInfo.new(0.12),{Color=C_BORDER2}):Play(); keyBtn.TextColor3=C_WHITE; return end
    kListening=true; keyBtn.Text="..."; keyBtn.TextColor3=Color3.fromRGB(255,200,100)
    TweenService:Create(ks,TweenInfo.new(0.12),{Color=C_WHITE}):Play()
    kConn=UIS.InputBegan:Connect(function(inp)
        if not kListening then return end
        local isKB  = inp.UserInputType==Enum.UserInputType.Keyboard
        local isGP  = inp.UserInputType==Enum.UserInputType.Gamepad1
                   or inp.UserInputType==Enum.UserInputType.Gamepad2
        if not isKB and not isGP then return end
        if inp.KeyCode==Enum.KeyCode.Escape then kListening=false; if kConn then kConn:Disconnect(); kConn=nil end
            TweenService:Create(ks,TweenInfo.new(0.12),{Color=C_BORDER2}):Play(); keyBtn.TextColor3=C_WHITE; return end
        if isGP then
            Keys.controller_autoBat=inp.KeyCode
        else
            Keys.autoBat=inp.KeyCode
        end
        keyBtn.Text=inp.KeyCode.Name; kListening=false
        if kConn then kConn:Disconnect(); kConn=nil end
        TweenService:Create(ks,TweenInfo.new(0.12),{Color=C_BORDER2}):Play(); keyBtn.TextColor3=C_WHITE
    end)
end)
keyBtn.ZIndex=6

-- Toggle pill
local pillBg = Instance.new("Frame",toggleRow)
pillBg.Size=UDim2.new(0,44,0,20); pillBg.Position=UDim2.new(1,-52,0.5,-10)
pillBg.BackgroundColor3=C_OFF_BG; pillBg.BorderSizePixel=0; pillBg.ZIndex=7
Instance.new("UICorner",pillBg).CornerRadius=UDim.new(1,0)
local pStroke = Instance.new("UIStroke",pillBg); pStroke.Color=Color3.fromRGB(60,60,60); pStroke.Thickness=1
local dot = Instance.new("Frame",pillBg)
dot.Size=UDim2.new(0,14,0,14); dot.Position=UDim2.new(0,3,0.5,-7)
dot.BackgroundColor3=Color3.fromRGB(100,100,100); dot.BorderSizePixel=0; dot.ZIndex=8
Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)

-- MOBILE CLICKABLE BUTTON (big clickable area below the row)
local mobileClickBtn = Instance.new("TextButton",content)
mobileClickBtn.Size=UDim2.new(1,0,0,38); mobileClickBtn.LayoutOrder=LO()
mobileClickBtn.BackgroundColor3=C_MOBILE_BTN; mobileClickBtn.BorderSizePixel=0
mobileClickBtn.Text="CLICK TO TOGGLE AUTO BAT"; mobileClickBtn.TextColor3=C_WHITE_DIM
mobileClickBtn.Font=Enum.Font.GothamBold; mobileClickBtn.TextSize=11
Instance.new("UICorner",mobileClickBtn).CornerRadius=UDim.new(0,8)
local mobileBtnStroke = Instance.new("UIStroke",mobileClickBtn); mobileBtnStroke.Color=Color3.fromRGB(80,80,80); mobileBtnStroke.Thickness=1.5

local function setToggleVisual(on)
    TweenService:Create(pillBg,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{BackgroundColor3=on and C_ON_BG or C_OFF_BG}):Play()
    TweenService:Create(pStroke,TweenInfo.new(0.2),{Color=on and C_WHITE or Color3.fromRGB(60,60,60)}):Play()
    TweenService:Create(dot,TweenInfo.new(0.2,Enum.EasingStyle.Back),{
        Position=on and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),
        BackgroundColor3=on and C_WHITE or Color3.fromRGB(100,100,100)
    }):Play()
    statusVal.Text = on and "ON" or "OFF"
    statusVal.TextColor3 = on and Color3.fromRGB(0,255,100) or Color3.fromRGB(255,60,60)
    mobileClickBtn.Text = on and "AUTO BAT: ON" or "CLICK TO TOGGLE AUTO BAT"
    mobileClickBtn.TextColor3 = on and Color3.fromRGB(0,255,100) or C_WHITE
    mobileClickBtn.BackgroundColor3 = on and Color3.fromRGB(35,55,35) or C_MOBILE_BTN
    if on then
        TweenService:Create(mobileBtnStroke,TweenInfo.new(0.2),{Color=Color3.fromRGB(0,255,100)}):Play()
    else
        TweenService:Create(mobileBtnStroke,TweenInfo.new(0.2),{Color=Color3.fromRGB(80,80,80)}):Play()
    end
end

mobileClickBtn.MouseButton1Click:Connect(function()
    State.autoBatToggled=not State.autoBatToggled
    setToggleVisual(State.autoBatToggled)
end)
mobileClickBtn.MouseEnter:Connect(function() 
    if not State.autoBatToggled then
        TweenService:Create(mobileClickBtn,TweenInfo.new(0.1),{BackgroundColor3=C_MOBILE_BTN_HOV}):Play() 
    end
end)
mobileClickBtn.MouseLeave:Connect(function() 
    if not State.autoBatToggled then
        TweenService:Create(mobileClickBtn,TweenInfo.new(0.1),{BackgroundColor3=C_MOBILE_BTN}):Play() 
    end
end)

local toggleClk = Instance.new("TextButton",toggleRow)
toggleClk.Size=UDim2.new(1,0,1,0); toggleClk.BackgroundTransparency=1; toggleClk.Text=""; toggleClk.ZIndex=3
toggleClk.MouseButton1Click:Connect(function()
    State.autoBatToggled=not State.autoBatToggled
    setToggleVisual(State.autoBatToggled)
end)
toggleClk.MouseEnter:Connect(function() TweenService:Create(toggleRow,TweenInfo.new(0.1),{BackgroundColor3=C_ROW_HOV}):Play() end)
toggleClk.MouseLeave:Connect(function() TweenService:Create(toggleRow,TweenInfo.new(0.1),{BackgroundColor3=C_ROW}):Play() end)

-- // FOOTER
local footerLbl = Instance.new("TextLabel",content)
footerLbl.Size=UDim2.new(1,0,0,14); footerLbl.BackgroundTransparency=1; footerLbl.LayoutOrder=LO()
footerLbl.Text="mwvane desync auto bat  v1.0"; footerLbl.TextColor3=C_WHITE_DARK
footerLbl.Font=Enum.Font.Gotham; footerLbl.TextSize=9; footerLbl.TextXAlignment=Enum.TextXAlignment.Center

-- // BAT LOGIC
local function getBat()
    local char=LP.Character; if not char then return nil end
    local tool=char:FindFirstChild("Bat"); if tool then return tool end
    local bp2=LP:FindFirstChild("Backpack")
    if bp2 then tool=bp2:FindFirstChild("Bat"); if tool then tool.Parent=char; return tool end end
    return nil
end

local function tryHitBat()
    if State.hittingCooldown then return end; State.hittingCooldown=true
    pcall(function()
        local bat=getBat(); if bat then
            bat:Activate(); local ev=bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end
    end)
    task.delay(0.08, function() State.hittingCooldown=false end)
end

local function getClosestPlayer()
    if not hrp then return nil,math.huge end
    local cp,cd=nil,math.huge
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            local tr=p.Character:FindFirstChild("HumanoidRootPart")
            if tr then local d=(hrp.Position-tr.Position).Magnitude; if d<cd then cd=d; cp=p end end
        end
    end
    return cp,cd
end

-- // CHARACTER SETUP
local function setupChar(char)
    task.wait(0.1)
    h=char:WaitForChild("Humanoid",5); hrp=char:WaitForChild("HumanoidRootPart",5)
    if not h or not hrp then return end
end

LP.CharacterAdded:Connect(setupChar)
if LP.Character then task.spawn(function() setupChar(LP.Character) end) end

-- // BAT AIMBOT HEARTBEAT
RunService.Heartbeat:Connect(function()
    if not (State.autoBatToggled and h and hrp) then
        return
    end
    local target,dist=getClosestPlayer()
    if target and target.Character then
        local tr=target.Character:FindFirstChild("HumanoidRootPart")
        if tr then
            if sethiddenproperty then
                sethiddenproperty(hrp, "PhysicsRepRootPart", tr)
            end
            local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
            if (hrp.Position - targetPos).Magnitude > 8 then
                hrp.CFrame = CFrame.new(targetPos)
            end
            local cam = workspace.CurrentCamera
            cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position)
            tryHitBat()
        end
    end
end)

-- // KEYBIND HANDLER
UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end
    local isKB = inp.UserInputType==Enum.UserInputType.Keyboard
    local isGP = inp.UserInputType==Enum.UserInputType.Gamepad1
              or inp.UserInputType==Enum.UserInputType.Gamepad2
    if not isKB and not isGP then return end
    local kc=inp.KeyCode
    if kc==Keys.autoBat or kc==Keys.controller_autoBat then
        State.autoBatToggled=not State.autoBatToggled
        setToggleVisual(State.autoBatToggled)
    elseif kc==Keys.guiHide or kc==Keys.controller_guiHide then
        State.guiVisible=not State.guiVisible
        main.Visible=State.guiVisible; shadow.Visible=State.guiVisible
    end
end)

print("[Mwvane Desync Auto Bat] Loaded!")