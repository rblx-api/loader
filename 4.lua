--- LEAKED AT FPSL AND CRYPTIC SRCS
---- LEAKED BY CRYPTIC AND CASUAL ON DISCORD ============================================================
-- PHANTOM DUELS | AMIR HUB REMAKE
-- 3 Draggable GUIs: Main Panel | Mobile Buttons | Auto-Steal Bar
-- All features wired to Phantom Duels logic
-- ============================================================

local Players         = game:GetService("Players")
local RunService      = game:GetService("RunService")
local UIS             = game:GetService("UserInputService")
local TweenService    = game:GetService("TweenService")
local HttpService     = game:GetService("HttpService")
local Lighting        = game:GetService("Lighting")
local LP              = Players.LocalPlayer

local _isfile    = isfile   or (syn and syn.isfile)   or function() return false end
local _readfile  = readfile  or (syn and syn.readfile)  or function() return nil  end
local _writefile = writefile or (syn and syn.writefile) or function() end
local getconnections = getconnections or get_signal_cons or getconnects or (syn and syn.get_signal_cons)

-- ============================================================
-- STATE
-- ============================================================
local State = {
    normalSpeed=59, carrySpeed=30, laggerSpeed=60, lagCarrySpeed=45,
    aimbotSpeed=56.5,
    speedToggled=false, laggerEnabled=false, laggerMode=0,
    infJumpEnabled=false, antiRagdollEnabled=false,
    uiLocked=false,
    isStealing=false, stealStartTime=nil, lastStealTick=0,
    autoLeftEnabled=false, autoRightEnabled=false,
    autoLeftPhase=1, autoRightPhase=1,
    medusaLastUsed=0, medusaDebounce=false, medusaCounterEnabled=false,
    batAimbotToggled=false,
    hittingCooldown=false,
    batCounterEnabled=false, batCounterDebounce=false,
    dropEnabled=false,
    lastMoveDir=Vector3.new(0,0,0),
    unwalkEnabled=false,
    _prevCarry=30, _prevSpeed=false,
    _laggerOriginalCarry=30,
    autoStealEnabled=false,
    infJumpMode="manual",
    autoMoveSpeedMode="autoswitch",
    espEnabled=true,
    darkMode=false,
    removeAccessories=false,
    fovValue=70,
    uiScale=1.0,
}

local Keys = {
    speed      = Enum.KeyCode.Q,
    lagger     = Enum.KeyCode.R,
    autoLeft   = Enum.KeyCode.Z,
    autoRight  = Enum.KeyCode.C,
    drop       = Enum.KeyCode.H,
    tpDown     = Enum.KeyCode.V,
    aimbot     = Enum.KeyCode.E,
    autoSteal  = Enum.KeyCode.N,
}

local Steal = {
    AutoStealEnabled=false, StealRadius=63,
    Data={}, plotCache={}, plotCacheTime={}, cachedPrompts={}, promptCacheTime=0,
}

local SavedPositions = {}
local Configs = {}
local CONFIG_SAVE_FILE = "phantomduelsConfigs.json"
local LAST_CONFIG_FILE = "phantomduelsLastConfig.json"
local CONFIG_FILE      = "phantomduelsConfig.json"

local POS={
    L1=Vector3.new(-476.48,-6.28,92.73), L2=Vector3.new(-483.12,-4.95,94.80),
    R1=Vector3.new(-476.16,-6.52,25.62), R2=Vector3.new(-483.04,-5.09,23.14),
}

local Conns={
    autoSteal=nil,antiRag=nil,autoLeft=nil,autoRight=nil,aimbot=nil,
    anchor={},progress=nil,batCounter=nil,unwalk=nil,
    infJumpHold=nil, infJumpFall=nil,
}

local PLOT_CACHE_DURATION  = 2
local PROMPT_CACHE_REFRESH = 0.15
local STEAL_DURATION       = 1.3
local STEAL_COOLDOWN       = 0.1
local MEDUSA_COOLDOWN      = 25
local DROP_AUTO_OFF_DELAY  = 0.15

local h, hrp
local speedBoxRefs    = {}
local keybindBtnRefs  = {}
local toggleRefs      = {}
local pageButtons     = {}
local pages           = {}
local statsRefs       = {}
local setAL, setAR, setAB, setCS, setLG
local reopenBtn
local stealPctLbl, progressFill, radValLbl, progressGui
local resetProgressBar
local configNameBox
local configListFrame
local rebuildConfigList
local performSaveNamedConfig
local laggerModeBtn
local lagCarrySpeedBox
local mbGroup, toggleFrame
local espBillboards = {}
local espRemConns   = {}
local mainOuter
local uiScaleObj

-- ============================================================
-- HELPERS
-- ============================================================
local function getKeyName(kc)
    if kc==nil or kc==Enum.KeyCode.Unknown then return "--" end
    local n=kc.Name
    if n=="Unknown" then return "--" end
    if n=="LeftControl" then return "CTRL" end
    if n=="RightControl" then return "RCTL" end
    if n=="LeftShift" then return "SHFT" end
    if n=="Space" then return "SPC" end
    return n:sub(1,4):upper()
end

local function serializePos(pos)
    return {xScale=pos.X.Scale,xOffset=pos.X.Offset,yScale=pos.Y.Scale,yOffset=pos.Y.Offset}
end
local function deserializePos(data,fallback)
    if type(data)~="table" then return fallback end
    return UDim2.new(tonumber(data.xScale) or fallback.X.Scale,tonumber(data.xOffset) or fallback.X.Offset,
        tonumber(data.yScale) or fallback.Y.Scale,tonumber(data.yOffset) or fallback.Y.Offset)
end
local function applySavedPosition(frame,key)
    if SavedPositions[key] then frame.Position=deserializePos(SavedPositions[key],frame.Position) end
end
local function saveFramePosition(key,frame)
    SavedPositions[key]=serializePos(frame.Position)
    task.spawn(function() pcall(function()
        local ok,enc=pcall(function() return HttpService:JSONEncode({positions=SavedPositions}) end)
        if ok then pcall(function() _writefile(CONFIG_FILE,enc) end) end
    end) end)
end
local function watchFramePosition(key,frame)
    frame:GetPropertyChangedSignal("Position"):Connect(function()
        SavedPositions[key]=serializePos(frame.Position)
    end)
end

-- ============================================================
-- CONFIG SAVE/LOAD
-- ============================================================
local function buildConfigSnapshot()
    return {
        normalSpeed=State.normalSpeed, carrySpeed=State.carrySpeed,
        laggerSpeed=State.laggerSpeed, lagCarrySpeed=State.lagCarrySpeed,
        stealRadius=Steal.StealRadius, infJump=State.infJumpEnabled,
        antiRagdoll=State.antiRagdollEnabled, medusaCounter=State.medusaCounterEnabled,
        batCounter=State.batCounterEnabled, autoSteal=Steal.AutoStealEnabled,
        speedToggled=State.speedToggled, laggerEnabled=State.laggerEnabled,
        laggerMode=State.laggerMode, unwalkEnabled=State.unwalkEnabled,
        batAimbotToggled=State.batAimbotToggled,
        keys={
            speed=Keys.speed and Keys.speed.Name or "Unknown",
            lagger=Keys.lagger and Keys.lagger.Name or "Unknown",
            autoLeft=Keys.autoLeft and Keys.autoLeft.Name or "Unknown",
            autoRight=Keys.autoRight and Keys.autoRight.Name or "Unknown",
            drop=Keys.drop and Keys.drop.Name or "Unknown",
            tpDown=Keys.tpDown and Keys.tpDown.Name or "Unknown",
            aimbot=Keys.aimbot and Keys.aimbot.Name or "Unknown",
            autoSteal=Keys.autoSteal and Keys.autoSteal.Name or "Unknown",
        },
    }
end

local function saveConfigsFile()
    local ok,encoded=pcall(function() return HttpService:JSONEncode(Configs) end)
    if ok then pcall(function() _writefile(CONFIG_SAVE_FILE,encoded) end) end
end
local function loadConfigsFile()
    local has=false; pcall(function() has=_isfile(CONFIG_SAVE_FILE) end)
    if not has then return end
    local raw; pcall(function() raw=_readfile(CONFIG_SAVE_FILE) end)
    if not raw then return end
    local ok,decoded=pcall(function() return HttpService:JSONDecode(raw) end)
    if ok and decoded then Configs=decoded end
end
local function saveLastConfigName(name)
    local ok,enc=pcall(function() return HttpService:JSONEncode({lastConfig=name}) end)
    if ok then pcall(function() _writefile(LAST_CONFIG_FILE,enc) end) end
end
local function loadLastConfigName()
    local has=false; pcall(function() has=_isfile(LAST_CONFIG_FILE) end)
    if not has then return nil end
    local raw; pcall(function() raw=_readfile(LAST_CONFIG_FILE) end)
    if not raw then return nil end
    local ok,decoded=pcall(function() return HttpService:JSONDecode(raw) end)
    if ok and decoded then return decoded.lastConfig end
    return nil
end

local activeConfigName = nil
local function syncActiveConfigSnapshot()
    if not activeConfigName or activeConfigName=="" then return end
    for i,cfg in ipairs(Configs) do
        if cfg.name==activeConfigName then
            Configs[i].data=buildConfigSnapshot()
            saveConfigsFile()
            if rebuildConfigList then rebuildConfigList() end
            return
        end
    end
end

-- ============================================================
-- DESTROY OLD GUIs
-- ============================================================
for _,name in pairs({"phantomDuelsV5_3","phantomDuelsV5_4","PhantomDuels","AmirHub"}) do
    pcall(function() local o=game:GetService("CoreGui"):FindFirstChild(name); if o then o:Destroy() end end)
    pcall(function() local o=LP:WaitForChild("PlayerGui"):FindFirstChild(name); if o then o:Destroy() end end)
end

-- ============================================================
-- GUI ROOT
-- ============================================================
local gui=Instance.new("ScreenGui")
gui.Name="AmirHub"
gui.ResetOnSpawn=false
gui.DisplayOrder=999
gui.IgnoreGuiInset=true
pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
pcall(function() gui.Parent=game:GetService("CoreGui") end)
if not gui.Parent then pcall(function() gui.Parent=LP.PlayerGui end) end

uiScaleObj=Instance.new("UIScale",gui)
uiScaleObj.Scale=1.0

-- ============================================================
-- COLOR PALETTE (matches HTML design)
-- ============================================================
local C={
    bg          = Color3.fromRGB(8,8,8),
    panel       = Color3.fromRGB(10,10,10),
    card        = Color3.fromRGB(18,18,18),
    border      = Color3.fromRGB(255,255,255),
    borderDim   = Color3.fromRGB(55,55,55),
    text        = Color3.fromRGB(224,224,224),
    textSub     = Color3.fromRGB(160,160,160),
    textDim     = Color3.fromRGB(110,110,110),
    accent      = Color3.fromRGB(91,140,255),
    pillOff     = Color3.fromRGB(28,28,28),
    pillOn      = Color3.fromRGB(56,56,56),
    dotOff      = Color3.fromRGB(100,100,100),
    dotOn       = Color3.fromRGB(255,255,255),
    header      = Color3.fromRGB(12,12,12),
    chipBg      = Color3.fromRGB(22,22,22),
    navIdle     = Color3.fromRGB(15,15,15),
    navActive   = Color3.fromRGB(40,40,40),
    statBg      = Color3.fromRGB(18,18,18),
    groupBg     = Color3.fromRGB(10,10,10),
}

-- ============================================================
-- UI PRIMITIVES
-- ============================================================
local function mkCorner(p,r)
    local c=Instance.new("UICorner",p); c.CornerRadius=UDim.new(0,r or 8); return c
end
local function mkStroke(p,col,th)
    local s=Instance.new("UIStroke",p)
    s.Color=col or C.borderDim; s.Thickness=th or 1
    s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; return s
end

-- ============================================================
-- DRAGGABLE (shared utility)
-- ============================================================
local function makeDraggable(frame, handle)
    local src=handle or frame
    local dragging,dragInput,dragStart,startPos=false,nil,nil,nil
    src.InputBegan:Connect(function(inp)
        if State.uiLocked then return end
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=inp.Position; startPos=frame.Position
            inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    src.InputChanged:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then
            dragInput=inp
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if inp==dragInput and dragging and not State.uiLocked then
            local dx=inp.Position.X-dragStart.X; local dy=inp.Position.Y-dragStart.Y
            frame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+dx,startPos.Y.Scale,startPos.Y.Offset+dy)
        end
    end)
end

local function bindTapOnly(button,onTap)
    local pressedPos,moved=nil,false
    button.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            pressedPos=inp.Position; moved=false
        end
    end)
    button.InputChanged:Connect(function(inp)
        if not pressedPos then return end
        if (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
            if (inp.Position-pressedPos).Magnitude>8 then moved=true end
        end
    end)
    button.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            local should=pressedPos and not moved; pressedPos=nil
            if should and onTap then onTap() end
        end
    end)
end

-- ============================================================
-- KEYBIND CHIP builder
-- ============================================================
local function makeKeybindChip(parent, keyRef, posX, posY)
    local chip=Instance.new("TextButton",parent)
    chip.Size=UDim2.new(0,36,0,22); chip.Position=UDim2.new(0,posX,0.5,posY or -11)
    chip.BackgroundColor3=C.chipBg; chip.BorderSizePixel=0
    chip.Text=getKeyName(Keys[keyRef] or Enum.KeyCode.Unknown)
    chip.TextColor3=C.textSub; chip.Font=Enum.Font.GothamBold
    chip.TextSize=9; chip.ZIndex=9; mkCorner(chip,5); mkStroke(chip,C.borderDim,1)
    keybindBtnRefs[keyRef]=chip

    local listening=false; local lkb,lgp
    local function stopListening(key)
        listening=false
        if lkb then lkb:Disconnect(); lkb=nil end
        if lgp then lgp:Disconnect(); lgp=nil end
        chip.TextColor3=C.textSub
        if key~=nil then
            Keys[keyRef]=key; chip.Text=getKeyName(key)
            task.spawn(syncActiveConfigSnapshot)
        else chip.Text=getKeyName(Keys[keyRef] or Enum.KeyCode.Unknown) end
    end
    chip.MouseButton1Click:Connect(function()
        if listening then stopListening(nil); return end
        listening=true; chip.Text="..."; chip.TextColor3=C.text
        lkb=UIS.InputBegan:Connect(function(inp)
            if not listening or inp.UserInputType~=Enum.UserInputType.Keyboard then return end
            if inp.KeyCode==Enum.KeyCode.Escape then stopListening(nil); return end
            stopListening(inp.KeyCode)
        end)
    end)
    chip.MouseButton2Click:Connect(function()
        listening=false; if lkb then lkb:Disconnect(); lkb=nil end
        Keys[keyRef]=Enum.KeyCode.Unknown; chip.Text="--"; chip.TextColor3=C.textSub
        task.spawn(syncActiveConfigSnapshot)
    end)
    return chip
end

-- ============================================================
-- TOGGLE ROW
-- ============================================================
local function makeToggleRow(parent, label, defaultOn, onToggle, keyRef)
    local row=Instance.new("Frame",parent)
    row.Size=UDim2.new(1,0,0,44); row.BackgroundColor3=C.card
    row.BorderSizePixel=0; row.ZIndex=7
    row.LayoutOrder=#parent:GetChildren()+1; mkCorner(row,7)
    mkStroke(row,C.borderDim,1)

    local lblX=10
    if keyRef then
        makeKeybindChip(row, keyRef, 10, -11)
        lblX=54
    end

    local lbl=Instance.new("TextLabel",row)
    lbl.Size=UDim2.new(1,-(lblX+60),1,0); lbl.Position=UDim2.new(0,lblX,0,0)
    lbl.BackgroundTransparency=1; lbl.Text=label; lbl.TextColor3=C.text
    lbl.Font=Enum.Font.GothamBold; lbl.TextSize=12
    lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=8

    local pill=Instance.new("Frame",row)
    pill.Size=UDim2.new(0,40,0,20); pill.Position=UDim2.new(1,-52,0.5,-10)
    pill.BackgroundColor3=defaultOn and C.pillOn or C.pillOff
    pill.BorderSizePixel=0; pill.ZIndex=9; mkCorner(pill,10); mkStroke(pill,C.borderDim,1)

    local dot=Instance.new("Frame",pill)
    dot.Size=UDim2.new(0,14,0,14)
    dot.Position=defaultOn and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
    dot.BackgroundColor3=defaultOn and C.dotOn or C.dotOff
    dot.BorderSizePixel=0; dot.ZIndex=10; mkCorner(dot,7)

    local isOn=defaultOn or false
    local function setV(on)
        isOn=on
        TweenService:Create(pill,TweenInfo.new(0.18,Enum.EasingStyle.Quad),{BackgroundColor3=on and C.pillOn or C.pillOff}):Play()
        TweenService:Create(dot,TweenInfo.new(0.18,Enum.EasingStyle.Back),{
            Position=on and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),
            BackgroundColor3=on and C.dotOn or C.dotOff
        }):Play()
    end
    local function toggle()
        isOn=not isOn; setV(isOn); if onToggle then pcall(onToggle,isOn) end
    end
    local clk=Instance.new("TextButton",row)
    clk.Size=UDim2.new(1,-50,1,0); clk.Position=UDim2.new(0,lblX,0,0)
    clk.BackgroundTransparency=1; clk.Text=""; clk.ZIndex=9; clk.BorderSizePixel=0
    clk.MouseButton1Click:Connect(toggle)
    local pClk=Instance.new("TextButton",pill)
    pClk.Size=UDim2.new(1,0,1,0); pClk.BackgroundTransparency=1
    pClk.Text=""; pClk.ZIndex=11; pClk.BorderSizePixel=0
    pClk.MouseButton1Click:Connect(toggle)
    return setV
end

-- ============================================================
-- INPUT ROW
-- ============================================================
local function makeInputRow(parent, label, default, onChange)
    local row=Instance.new("Frame",parent)
    row.Size=UDim2.new(1,0,0,44); row.BackgroundColor3=C.card
    row.BorderSizePixel=0; row.ZIndex=7
    row.LayoutOrder=#parent:GetChildren()+1; mkCorner(row,7); mkStroke(row,C.borderDim,1)

    local lbl=Instance.new("TextLabel",row)
    lbl.Size=UDim2.new(0.6,0,1,0); lbl.Position=UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency=1; lbl.Text=label; lbl.TextColor3=C.text
    lbl.Font=Enum.Font.GothamBold; lbl.TextSize=12
    lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=8

    local boxWrap=Instance.new("Frame",row)
    boxWrap.Size=UDim2.new(0,68,0,28); boxWrap.Position=UDim2.new(1,-80,0.5,-14)
    boxWrap.BackgroundColor3=C.bg; boxWrap.BorderSizePixel=0; mkCorner(boxWrap,6)
    local bs=mkStroke(boxWrap,C.borderDim,1)

    local box=Instance.new("TextBox",boxWrap)
    box.Size=UDim2.new(1,-8,1,0); box.Position=UDim2.new(0,4,0,0)
    box.BackgroundTransparency=1; box.Text=tostring(default)
    box.TextColor3=C.text; box.Font=Enum.Font.GothamBold; box.TextSize=12
    box.ClearTextOnFocus=false; box.ZIndex=9; box.TextXAlignment=Enum.TextXAlignment.Center
    box.Focused:Connect(function() TweenService:Create(bs,TweenInfo.new(0.15),{Color=C.border}):Play() end)
    box.FocusLost:Connect(function()
        TweenService:Create(bs,TweenInfo.new(0.15),{Color=C.borderDim}):Play()
        if onChange then
            local n=tonumber(box.Text)
            if n then onChange(n) else box.Text=tostring(default) end
        end
    end)
    return box
end

-- ============================================================
-- SLIDER ROW
-- ============================================================
local function makeSliderRow(parent, label, minV, maxV, defaultV, onChanged, fmtFn)
    local row=Instance.new("Frame",parent)
    row.Size=UDim2.new(1,0,0,58); row.BackgroundColor3=C.card
    row.BorderSizePixel=0; row.ZIndex=7
    row.LayoutOrder=#parent:GetChildren()+1; mkCorner(row,7); mkStroke(row,C.borderDim,1)

    local lbl=Instance.new("TextLabel",row)
    lbl.Size=UDim2.new(1,-70,0,22); lbl.Position=UDim2.new(0,10,0,6)
    lbl.BackgroundTransparency=1; lbl.Text=label; lbl.TextColor3=C.text
    lbl.Font=Enum.Font.GothamBold; lbl.TextSize=12; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=8

    local valLbl=Instance.new("TextLabel",row)
    valLbl.Size=UDim2.new(0,52,0,22); valLbl.Position=UDim2.new(1,-62,0,6)
    valLbl.BackgroundTransparency=1; valLbl.TextColor3=C.text
    valLbl.Font=Enum.Font.GothamBlack; valLbl.TextSize=12
    valLbl.TextXAlignment=Enum.TextXAlignment.Right; valLbl.ZIndex=8
    valLbl.Text=fmtFn and fmtFn(defaultV) or tostring(defaultV)

    local trackBg=Instance.new("Frame",row)
    trackBg.Size=UDim2.new(1,-20,0,5); trackBg.Position=UDim2.new(0,10,1,-14)
    trackBg.BackgroundColor3=Color3.fromRGB(55,55,55); trackBg.BorderSizePixel=0; trackBg.ZIndex=8; mkCorner(trackBg,3)

    local curVal=defaultV
    local function getT() return (curVal-minV)/(maxV-minV) end

    local fill=Instance.new("Frame",trackBg)
    fill.Size=UDim2.new(getT(),0,1,0); fill.BackgroundColor3=C.accent
    fill.BorderSizePixel=0; fill.ZIndex=9; mkCorner(fill,3)

    local thumb=Instance.new("Frame",trackBg)
    thumb.Size=UDim2.new(0,13,0,13); thumb.Position=UDim2.new(getT(),-6,0.5,-6)
    thumb.BackgroundColor3=Color3.fromRGB(255,255,255); thumb.BorderSizePixel=0; thumb.ZIndex=10; mkCorner(thumb,7)

    local hit=Instance.new("TextButton",trackBg)
    hit.Size=UDim2.new(1,0,0,28); hit.Position=UDim2.new(0,0,0.5,-14)
    hit.BackgroundTransparency=1; hit.Text=""; hit.ZIndex=11; hit.BorderSizePixel=0

    local function setValue(v)
        v=math.clamp(v,minV,maxV); curVal=v
        local t=getT(); fill.Size=UDim2.new(t,0,1,0); thumb.Position=UDim2.new(t,-6,0.5,-6)
        valLbl.Text=fmtFn and fmtFn(v) or tostring(v)
        if onChanged then onChanged(v) end
    end
    local isDrag=false
    local function fromInput(inp)
        local abs=trackBg.AbsolutePosition; local w=trackBg.AbsoluteSize.X
        local rx=math.clamp(inp.Position.X-abs.X,0,w)
        setValue(minV+(rx/w)*(maxV-minV))
    end
    hit.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            isDrag=true; fromInput(inp)
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if not isDrag then return end
        if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then fromInput(inp) end
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then isDrag=false end
    end)
    return setValue
end

-- ============================================================
-- PAGE creator
-- ============================================================
local function createPage(parent)
    local page=Instance.new("ScrollingFrame",parent)
    page.Size=UDim2.new(1,0,1,0); page.BackgroundTransparency=1
    page.BorderSizePixel=0; page.ScrollBarThickness=2
    page.ScrollBarImageColor3=C.borderDim; page.CanvasSize=UDim2.new(0,0,0,0)
    page.AutomaticCanvasSize=Enum.AutomaticSize.Y; page.Visible=false; page.ZIndex=6
    local pad=Instance.new("UIPadding",page)
    pad.PaddingLeft=UDim.new(0,8); pad.PaddingRight=UDim.new(0,8)
    pad.PaddingTop=UDim.new(0,8); pad.PaddingBottom=UDim.new(0,8)
    local ll=Instance.new("UIListLayout",page)
    ll.SortOrder=Enum.SortOrder.LayoutOrder; ll.Padding=UDim.new(0,5)
    return page
end

-- ============================================================
-- SECTION LABEL
-- ============================================================
local function makeSectionLabel(parent, text)
    local lbl=Instance.new("TextLabel",parent)
    lbl.Size=UDim2.new(1,0,0,18); lbl.BackgroundTransparency=1
    lbl.Text=text:upper(); lbl.TextColor3=C.textDim
    lbl.Font=Enum.Font.GothamBold; lbl.TextSize=9
    lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=7
    lbl.LayoutOrder=#parent:GetChildren()+1
    return lbl
end

-- ============================================================
-- ACTION BUTTON (full-width, colored)
-- ============================================================
local function makeActionButton(parent, text, bgColor, onClick)
    local btn=Instance.new("TextButton",parent)
    btn.Size=UDim2.new(1,0,0,36); btn.BackgroundColor3=bgColor or C.navIdle
    btn.BorderSizePixel=0; btn.Text=text; btn.TextColor3=C.text
    btn.Font=Enum.Font.GothamBold; btn.TextSize=12; btn.ZIndex=8
    btn.LayoutOrder=#parent:GetChildren()+1; mkCorner(btn,7); mkStroke(btn,C.borderDim,1)
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.08),{BackgroundColor3=Color3.fromRGB(60,60,60)}):Play()
        task.delay(0.2,function() TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=bgColor or C.navIdle}):Play() end)
        if onClick then onClick() end
    end)
    return btn
end

-- ============================================================
-- MAIN WINDOW CONSTRUCTION
-- ============================================================
local WIN_W=480; local WIN_H=390
local HEADER_H=44; local STATS_H=50; local SIDEBAR_W=118

mainOuter=Instance.new("Frame",gui)
mainOuter.Name="MainOuter"
mainOuter.Size=UDim2.new(0,WIN_W,0,WIN_H)
mainOuter.Position=UDim2.new(0,8,0,8)
mainOuter.BackgroundColor3=C.panel; mainOuter.BorderSizePixel=0
mainOuter.ClipsDescendants=false; mkCorner(mainOuter,12); mkStroke(mainOuter,C.borderDim,1)
applySavedPosition(mainOuter,"mainOuter"); watchFramePosition("mainOuter",mainOuter)

-- HEADER
local headerFrame=Instance.new("Frame",mainOuter)
headerFrame.Size=UDim2.new(1,0,0,HEADER_H)
headerFrame.BackgroundColor3=C.header; headerFrame.BorderSizePixel=0; headerFrame.ZIndex=3; mkCorner(headerFrame,12)

-- drag handle = header
makeDraggable(mainOuter, headerFrame)

local titleLbl=Instance.new("TextLabel",headerFrame)
titleLbl.Size=UDim2.new(1,-110,1,0); titleLbl.Position=UDim2.new(0,14,0,0)
titleLbl.BackgroundTransparency=1; titleLbl.Text="Phantom Duels"
titleLbl.TextColor3=C.text; titleLbl.Font=Enum.Font.GothamBlack; titleLbl.TextSize=17
titleLbl.TextXAlignment=Enum.TextXAlignment.Left; titleLbl.ZIndex=4

local subLbl=Instance.new("TextLabel",headerFrame)
subLbl.Size=UDim2.new(0,80,0,14); subLbl.Position=UDim2.new(0,14,1,-16)
subLbl.BackgroundTransparency=1; subLbl.Text="AMIR HUB"
subLbl.TextColor3=C.accent; subLbl.Font=Enum.Font.GothamBold; subLbl.TextSize=9
subLbl.TextXAlignment=Enum.TextXAlignment.Left; subLbl.ZIndex=4

local function makeHeaderBtn(text, posX)
    local btn=Instance.new("TextButton",headerFrame)
    btn.Size=UDim2.new(0,26,0,26); btn.Position=UDim2.new(1,posX,0.5,-13)
    btn.BackgroundColor3=C.card; btn.BorderSizePixel=0
    btn.Text=text; btn.TextColor3=C.textSub; btn.Font=Enum.Font.GothamBold; btn.TextSize=12
    btn.ZIndex=5; mkCorner(btn,5); mkStroke(btn,C.borderDim,1)
    return btn
end

local lockBtn=makeHeaderBtn("🔓",-76)
local minBtn=makeHeaderBtn("−",-44)
local closeBtn=makeHeaderBtn("×",-12)

lockBtn.MouseButton1Click:Connect(function()
    State.uiLocked=not State.uiLocked
    lockBtn.Text=State.uiLocked and "🔒" or "🔓"
end)

-- STATS BAR
local statsRow=Instance.new("Frame",mainOuter)
statsRow.Size=UDim2.new(1,-16,0,STATS_H-8); statsRow.Position=UDim2.new(0,8,0,HEADER_H+4)
statsRow.BackgroundTransparency=1; statsRow.ZIndex=3

local statTitles={
    {"Normal",  function() return tostring(State.normalSpeed) end},
    {"Carry",   function() return tostring(State.carrySpeed) end},
    {"Lagger",  function() return tostring(State.laggerSpeed) end},
    {"Lag Carry",function() return tostring(State.lagCarrySpeed) end},
}
statsRefs={}
for i,stat in ipairs(statTitles) do
    local cell=Instance.new("Frame",statsRow)
    cell.Size=UDim2.new(0.25,-4,1,0); cell.Position=UDim2.new((i-1)*0.25,4,0,0)
    cell.BackgroundColor3=C.statBg; cell.BorderSizePixel=0; cell.ZIndex=4; mkCorner(cell,7); mkStroke(cell,C.borderDim,1)
    local top=Instance.new("TextLabel",cell)
    top.Size=UDim2.new(1,-6,0,14); top.Position=UDim2.new(0,3,0,5)
    top.BackgroundTransparency=1; top.Text=stat[1]; top.TextColor3=C.textSub
    top.Font=Enum.Font.GothamBold; top.TextSize=8; top.ZIndex=5
    local val=Instance.new("TextLabel",cell)
    val.Size=UDim2.new(1,-6,0,18); val.Position=UDim2.new(0,3,0,17)
    val.BackgroundTransparency=1; val.Text=stat[2]()
    val.TextColor3=C.text; val.Font=Enum.Font.GothamBlack; val.TextSize=13; val.ZIndex=5
    statsRefs[i]={label=val,getter=stat[2]}
end

-- BODY
local bodyFrame=Instance.new("Frame",mainOuter)
bodyFrame.Size=UDim2.new(1,-12,1,-(HEADER_H+STATS_H+10))
bodyFrame.Position=UDim2.new(0,6,0,HEADER_H+STATS_H+4)
bodyFrame.BackgroundColor3=C.bg; bodyFrame.BorderSizePixel=0; bodyFrame.ZIndex=3; mkCorner(bodyFrame,10); mkStroke(bodyFrame,C.borderDim,1)

-- SIDEBAR
local sideBar=Instance.new("Frame",bodyFrame)
sideBar.Size=UDim2.new(0,SIDEBAR_W,1,0)
sideBar.BackgroundColor3=C.header; sideBar.BorderSizePixel=0; sideBar.ZIndex=4; mkCorner(sideBar,10)

local navWrap=Instance.new("Frame",sideBar)
navWrap.Size=UDim2.new(1,-12,1,-10); navWrap.Position=UDim2.new(0,6,0,6)
navWrap.BackgroundTransparency=1; navWrap.ZIndex=5
local navList=Instance.new("UIListLayout",navWrap)
navList.SortOrder=Enum.SortOrder.LayoutOrder; navList.Padding=UDim.new(0,4)

-- CONTENT
local contentWrap=Instance.new("Frame",bodyFrame)
contentWrap.Size=UDim2.new(1,-(SIDEBAR_W+8),1,-8)
contentWrap.Position=UDim2.new(0,SIDEBAR_W+4,0,4)
contentWrap.BackgroundColor3=C.bg; contentWrap.BorderSizePixel=0; contentWrap.ZIndex=4

-- PAGE SYSTEM
local function showPage(name)
    for pn,page in pairs(pages) do page.Visible=(pn==name) end
    for pn,ref in pairs(pageButtons) do
        local active=(pn==name)
        TweenService:Create(ref.button,TweenInfo.new(0.12),{
            BackgroundColor3=active and C.navActive or C.navIdle,
            TextColor3=active and C.text or C.textSub
        }):Play()
        if ref.stroke then TweenService:Create(ref.stroke,TweenInfo.new(0.12),{Color=active and C.borderDim or Color3.fromRGB(30,30,30)}):Play() end
    end
end

local function addPage(name, icon)
    local page=createPage(contentWrap)
    pages[name]=page
    local btn=Instance.new("TextButton",navWrap)
    btn.Size=UDim2.new(1,0,0,28); btn.BackgroundColor3=C.navIdle
    btn.BorderSizePixel=0; btn.Text=(icon and icon.." " or "")..name
    btn.TextColor3=C.textSub; btn.Font=Enum.Font.GothamBold; btn.TextSize=10
    btn.ZIndex=6; mkCorner(btn,6)
    local stroke=mkStroke(btn,Color3.fromRGB(30,30,30),1)
    btn.MouseButton1Click:Connect(function() showPage(name) end)
    pageButtons[name]={button=btn,stroke=stroke}
    return page
end

-- ============================================================
-- ██████╗  █████╗  ██████╗ ███████╗███████╗
-- ██╔══██╗██╔══██╗██╔════╝ ██╔════╝██╔════╝
-- ██████╔╝███████║██║  ███╗█████╗  ███████╗
-- ██╔═══╝ ██╔══██║██║   ██║██╔══╝  ╚════██║
-- ██║     ██║  ██║╚██████╔╝███████╗███████║
-- ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝
-- ============================================================

-- ============================================================
-- ALL GAME LOGIC FUNCTIONS (from Phantom Duels)
-- ============================================================

local function getSpeedModeLabel()
    if State.laggerMode==1 then return "[Lagger]"
    elseif State.laggerMode==2 then return "[LagCarry]"
    elseif State.speedToggled then return "[Carry]"
    else return "[Normal]" end
end
local function getCurrentModeSpeed()
    if State.laggerMode==1 then return State.laggerSpeed
    elseif State.laggerMode==2 then return State.lagCarrySpeed
    elseif State.speedToggled then return State.carrySpeed
    else return State.normalSpeed end
end

local function createSpeedLabel(char)
    local c=char or LP.Character; if not c then return end
    local hrp2=c:FindFirstChild("HumanoidRootPart"); if not hrp2 then return end
    local old=hrp2:FindFirstChild("PhantomSpeedLabel"); if old then old:Destroy() end
    local bb=Instance.new("BillboardGui")
    bb.Name="PhantomSpeedLabel"; bb.AlwaysOnTop=false
    bb.Size=UDim2.new(0,200,0,36); bb.StudsOffset=Vector3.new(0,3.2,0)
    bb.MaxDistance=60; bb.Adornee=hrp2; bb.Parent=hrp2
    local lbl2=Instance.new("TextLabel",bb)
    lbl2.Name="PhantomSpeedLbl"; lbl2.Size=UDim2.new(1,0,1,0)
    lbl2.BackgroundTransparency=1; lbl2.Text="0 [Normal]"
    lbl2.TextColor3=Color3.fromRGB(255,255,255); lbl2.TextStrokeColor3=Color3.fromRGB(0,0,0)
    lbl2.TextStrokeTransparency=0; lbl2.Font=Enum.Font.GothamBold; lbl2.TextSize=22
    lbl2.TextXAlignment=Enum.TextXAlignment.Center
end
task.spawn(function() task.wait(1); createSpeedLabel() end)
LP.CharacterAdded:Connect(function(char) task.wait(0.5); createSpeedLabel(char) end)

local _spdT=0
RunService.Heartbeat:Connect(function()
    local now=tick(); if now-_spdT<0.1 then return end; _spdT=now
    local c=LP.Character; if not c then return end
    local hrp2=c:FindFirstChild("HumanoidRootPart"); if not hrp2 then return end
    local bb=hrp2:FindFirstChild("PhantomSpeedLabel")
    if not bb then createSpeedLabel(c); return end
    local lbl2=bb:FindFirstChildOfClass("TextLabel")
    if lbl2 then
        local flatVel=Vector3.new(hrp2.AssemblyLinearVelocity.X,0,hrp2.AssemblyLinearVelocity.Z).Magnitude
        if flatVel>2 then lbl2.Text=string.format("%d %s",getCurrentModeSpeed(),getSpeedModeLabel())
        else lbl2.Text=string.format("0 %s",getSpeedModeLabel()) end
    end
end)

-- ESP
local _espT=0
local function espRemoveFor(p)
    if espBillboards[p] then pcall(function() espBillboards[p]:Destroy() end); espBillboards[p]=nil end
    if espRemConns[p] then espRemConns[p]:Disconnect(); espRemConns[p]=nil end
end
local function espAttach(p,char)
    if p==LP then return end
    local hrp2=char:FindFirstChild("HumanoidRootPart"); if not hrp2 then return end
    espRemoveFor(p)
    local bb=Instance.new("BillboardGui"); bb.Name="PhantomSESP"
    bb.AlwaysOnTop=true; bb.Size=UDim2.new(0,160,0,28)
    bb.StudsOffset=Vector3.new(0,4,0); bb.Adornee=hrp2; bb.Parent=hrp2
    local lbl2=Instance.new("TextLabel",bb)
    lbl2.Size=UDim2.new(1,0,1,0); lbl2.BackgroundTransparency=1
    lbl2.TextColor3=Color3.fromRGB(255,255,255); lbl2.TextStrokeColor3=Color3.fromRGB(0,0,0)
    lbl2.TextStrokeTransparency=0; lbl2.Font=Enum.Font.GothamBold; lbl2.TextSize=22
    lbl2.Text="0"; lbl2.TextXAlignment=Enum.TextXAlignment.Center
    espBillboards[p]=bb
    espRemConns[p]=char.AncestryChanged:Connect(function() if not char.Parent then espRemoveFor(p) end end)
end
local function initOthersSpeedESP()
    for _,p in ipairs(Players:GetPlayers()) do if p~=LP and p.Character then espAttach(p,p.Character) end end
    Players.PlayerAdded:Connect(function(p)
        if p==LP then return end
        p.CharacterAdded:Connect(function(char) task.wait(0.5); espAttach(p,char) end)
    end)
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP then p.CharacterAdded:Connect(function(char) task.wait(0.5); espAttach(p,char) end) end
    end
    RunService.Heartbeat:Connect(function()
        local now=tick(); if now-_espT<0.1 then return end; _espT=now
        if not State.espEnabled then return end
        for p,bb in pairs(espBillboards) do
            pcall(function()
                local hrp2=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                local lbl2=bb:FindFirstChildOfClass("TextLabel")
                if hrp2 and lbl2 then lbl2.Text=tostring(math.floor(hrp2.AssemblyLinearVelocity.Magnitude*10)/10) end
            end)
        end
    end)
end

-- INF JUMP
local function stopInfiniteJump()
    if Conns.infJumpHold then Conns.infJumpHold:Disconnect(); Conns.infJumpHold=nil end
    if Conns.infJumpFall then Conns.infJumpFall:Disconnect(); Conns.infJumpFall=nil end
end
local function startInfiniteJump()
    stopInfiniteJump()
    Conns.infJumpFall=RunService.Heartbeat:Connect(function()
        if not State.infJumpEnabled then return end
        local c=LP.Character; local r=c and c:FindFirstChild("HumanoidRootPart"); if not r then return end
        if r.AssemblyLinearVelocity.Y<-120 then
            r.AssemblyLinearVelocity=Vector3.new(r.AssemblyLinearVelocity.X,-120,r.AssemblyLinearVelocity.Z)
        end
    end)
    if State.infJumpMode=="manual" then
        Conns.infJumpHold=UIS.JumpRequest:Connect(function()
            if not State.infJumpEnabled then return end
            local c=LP.Character; local r=c and c:FindFirstChild("HumanoidRootPart"); if not r then return end
            r.AssemblyLinearVelocity=Vector3.new(r.AssemblyLinearVelocity.X,55,r.AssemblyLinearVelocity.Z)
        end)
    else
        Conns.infJumpHold=RunService.Heartbeat:Connect(function()
            if not State.infJumpEnabled then return end
            if not UIS:IsKeyDown(Enum.KeyCode.Space) then return end
            local c=LP.Character; local r=c and c:FindFirstChild("HumanoidRootPart"); if not r then return end
            if r.AssemblyLinearVelocity.Y<55 then
                r.AssemblyLinearVelocity=Vector3.new(r.AssemblyLinearVelocity.X,55,r.AssemblyLinearVelocity.Z)
            end
        end)
    end
end

-- TP DOWN
local function doTpDown()
    pcall(function()
        local c=LP.Character; if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart"); if not root then return end
        local rp=RaycastParams.new(); rp.FilterDescendantsInstances={c}; rp.FilterType=Enum.RaycastFilterType.Exclude
        local res=workspace:Raycast(root.Position,Vector3.new(0,-1000,0),rp)
        if res then
            root.CFrame=CFrame.new(res.Position+Vector3.new(0,root.Size.Y/2+0.5,0))
            root.AssemblyLinearVelocity=Vector3.zero
        end
    end)
end

-- DROP BRAINROT
local function runDropBrainrot()
    if State.dropEnabled then return end
    State.dropEnabled=true
    task.spawn(function()
        local colConn=RunService.Stepped:Connect(function()
            if not State.dropEnabled then return end
            for _,p in ipairs(Players:GetPlayers()) do
                if p~=LP and p.Character then
                    for _,part in ipairs(p.Character:GetChildren()) do
                        if part:IsA("BasePart") then part.CanCollide=false end
                    end
                end
            end
        end)
        task.spawn(function()
            while State.dropEnabled do
                RunService.Heartbeat:Wait()
                local c=LP.Character; local root=c and c:FindFirstChild("HumanoidRootPart")
                if not root then continue end
                local vel=root.Velocity
                root.Velocity=vel*10000+Vector3.new(0,10000,0)
                RunService.RenderStepped:Wait()
                if root and root.Parent then root.Velocity=vel end
                RunService.Stepped:Wait()
                if root and root.Parent then root.Velocity=vel+Vector3.new(0,0.1,0) end
            end
        end)
        task.wait(DROP_AUTO_OFF_DELAY)
        State.dropEnabled=false; colConn:Disconnect()
    end)
end

-- ANTI RAGDOLL
local function startAntiRagdoll()
    if Conns.antiRag then Conns.antiRag:Disconnect() end
    Conns.antiRag=RunService.Heartbeat:Connect(function()
        if not State.antiRagdollEnabled then return end
        local c=LP.Character; if not c then return end
        local hum2=c:FindFirstChildOfClass("Humanoid"); local root=c:FindFirstChild("HumanoidRootPart")
        if not hum2 or not root then return end
        if hum2.Health<=0 then return end
        local st=hum2:GetState()
        if st==Enum.HumanoidStateType.Dead then return end
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
            pcall(function() hum2:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            pcall(function() workspace.CurrentCamera.CameraSubject=hum2 end)
            root.Velocity=Vector3.new(0,0,0); root.RotVelocity=Vector3.new(0,0,0)
        end
        for _,obj in ipairs(c:GetDescendants()) do
            pcall(function() if obj:IsA("Motor6D") and obj.Enabled==false then obj.Enabled=true end end)
        end
    end)
end
local function stopAntiRagdoll()
    if Conns.antiRag then Conns.antiRag:Disconnect(); Conns.antiRag=nil end
end

-- UNWALK
local _unwalkAnimations={}
local function _disableAnimations()
    local char=LP.Character; if not char then return end
    local hum2=char:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
    for _,t in pairs(_unwalkAnimations) do pcall(function() t:Stop() end) end
    _unwalkAnimations={}
    local animator=hum2:FindFirstChildOfClass("Animator")
    if animator then
        for _,t in pairs(animator:GetPlayingAnimationTracks()) do t:Stop(); table.insert(_unwalkAnimations,t) end
    end
end
local function startUnwalk()
    _disableAnimations()
    if Conns.unwalk then Conns.unwalk:Disconnect() end
    Conns.unwalk=RunService.Heartbeat:Connect(function() if State.unwalkEnabled then _disableAnimations() end end)
end
local function stopUnwalk()
    if Conns.unwalk then Conns.unwalk:Disconnect(); Conns.unwalk=nil end
    _unwalkAnimations={}
end

-- MEDUSA COUNTER
local function findMedusa()
    local c=LP.Character; if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do
        if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end
    end
    local bp=LP:FindFirstChild("Backpack")
    if bp then
        for _,t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end
        end
    end
    return nil
end
local function useMedusaCounter()
    if State.medusaDebounce then return end
    if tick()-State.medusaLastUsed<MEDUSA_COOLDOWN then return end
    local c=LP.Character; if not c then return end
    State.medusaDebounce=true
    local med=findMedusa()
    if not med then State.medusaDebounce=false; return end
    if med.Parent~=c then
        local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:EquipTool(med) end
    end
    pcall(function() med:Activate() end)
    State.medusaLastUsed=tick(); State.medusaDebounce=false
end
local function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if part.Anchored and part.Transparency==1 then useMedusaCounter() end
    end)
end
local function setupMedusaCounter(char)
    for _,c2 in pairs(Conns.anchor) do pcall(function() c2:Disconnect() end) end
    Conns.anchor={}
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end
    end
    table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end
    end))
end
local function stopMedusaCounter()
    for _,c2 in pairs(Conns.anchor) do pcall(function() c2:Disconnect() end) end
    Conns.anchor={}
end

-- BAT AIMBOT
local function getNearestEnemy()
    local char=LP.Character; if not char then return nil,nil,nil end
    local myHRP=char:FindFirstChild("HumanoidRootPart"); if not myHRP then return nil,nil,nil end
    local pos=myHRP.Position; local nd=math.huge; local nearHRP,nearTorso,nearHum=nil,nil,nil
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character then
            local eHRP=plr.Character:FindFirstChild("HumanoidRootPart")
            local eHum=plr.Character:FindFirstChildOfClass("Humanoid")
            local eTorso=plr.Character:FindFirstChild("UpperTorso") or plr.Character:FindFirstChild("Torso")
            if eHRP and eHum and eHum.Health>0 then
                local d=(eHRP.Position-pos).Magnitude
                if d<nd then nd=d; nearHRP=eHRP; nearTorso=eTorso or eHRP; nearHum=eHum end
            end
        end
    end
    return nearHRP,nearTorso,nearHum
end
local function startBatAimbot()
    if Conns.aimbot then return end
    Conns.aimbot=RunService.RenderStepped:Connect(function()
        if not State.batAimbotToggled then return end
        pcall(function()
            local char=LP.Character; if not char then return end
            local myHRP=char:FindFirstChild("HumanoidRootPart"); local myHum=char:FindFirstChildOfClass("Humanoid")
            if not myHRP or not myHum then return end
            local eHRP,eTorso=getNearestEnemy()
            if not eHRP then myHRP.AssemblyLinearVelocity=Vector3.new(0,myHRP.AssemblyLinearVelocity.Y,0); return end
            local ePos=(eTorso or eHRP).Position
            local eLook=(eTorso or eHRP).CFrame.LookVector
            local eVel=eHRP.AssemblyLinearVelocity
            local front=Vector3.new(eLook.X,0,eLook.Z)
            if front.Magnitude>0.1 then front=front.Unit*3.5 end
            local goal=ePos+front; local toGoal=goal-myHRP.Position
            local flat=Vector3.new(toGoal.X,0,toGoal.Z); local flatDist=flat.Magnitude
            local yDiff=ePos.Y-myHRP.Position.Y
            local yVel=myHRP.AssemblyLinearVelocity.Y
            if myHum.FloorMaterial~=Enum.Material.Air then
                if yDiff>0.5 or eVel.Y>5 then yVel=55 end
            else yVel=math.clamp(yDiff*20+eVel.Y*0.5,-100,100) end
            local spd=56.5
            if flatDist>1 then
                local mv=flat.Unit
                myHRP.AssemblyLinearVelocity=Vector3.new(mv.X*spd,yVel,mv.Z*spd)
            else
                myHRP.AssemblyLinearVelocity=Vector3.new(eVel.X+eLook.X*5,yVel,eVel.Z+eLook.Z*5)
            end
        end)
    end)
end
local function stopBatAimbot()
    if Conns.aimbot then Conns.aimbot:Disconnect(); Conns.aimbot=nil end
    local char=LP.Character; local myHRP=char and char:FindFirstChild("HumanoidRootPart")
    if myHRP then myHRP.AssemblyLinearVelocity=Vector3.new(0,myHRP.AssemblyLinearVelocity.Y,0) end
    State.hittingCooldown=false
end

-- BAT COUNTER
local BAT_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
local function findBatForCounter()
    local c=LP.Character; if not c then return nil end
    local bp=LP:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(BAT_LIST) do
        local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name)); if t then return t end
    end
    for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
    if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
    return nil
end
local function swingBat(bat,char)
    local hum2=char:FindFirstChildOfClass("Humanoid")
    if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end; task.wait(0.05) end
    local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end); task.wait(0.15); pcall(function() remote:FireServer() end)
    else pcall(function() bat:Activate() end); task.wait(0.15); pcall(function() bat:Activate() end) end
end
local function startBatCounter()
    if Conns.batCounter then return end
    Conns.batCounter=RunService.Heartbeat:Connect(function()
        if not State.batCounterEnabled or State.batCounterDebounce then return end
        local char=LP.Character; if not char then return end
        local hum2=char:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
        local st=hum2:GetState()
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
            State.batCounterDebounce=true
            task.spawn(function()
                local bat=findBatForCounter(); if bat then swingBat(bat,char) end
                task.wait(0.5); State.batCounterDebounce=false
            end)
        end
    end)
end
local function stopBatCounter()
    if Conns.batCounter then Conns.batCounter:Disconnect(); Conns.batCounter=nil end
    State.batCounterDebounce=false
end

-- AUTO LEFT / RIGHT
local function faceSouth()
    pcall(function()
        local c=LP.Character; if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart"); if not root then return end
        root.CFrame=CFrame.new(root.Position)*CFrame.Angles(0,0,0)
    end)
end
local function faceNorth()
    pcall(function()
        local c=LP.Character; if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart"); if not root then return end
        root.CFrame=CFrame.new(root.Position)*CFrame.Angles(0,math.rad(180),0)
    end)
end
local function setAutoMoveTravelMode()
    State.laggerEnabled=false; State.laggerMode=0; State.speedToggled=false
    if toggleRefs.laggerMode then toggleRefs.laggerMode(false) end
    if toggleRefs.carryMode then toggleRefs.carryMode(false) end
    if setLG then setLG(false) end; if setCS then setCS(false) end
end
local function setAutoMoveFinishMode()
    State.laggerEnabled=false; State.laggerMode=0
    if State.autoMoveSpeedMode=="autoswitch" then
        State.speedToggled=true
        if toggleRefs.carryMode then toggleRefs.carryMode(true) end
        if setCS then setCS(true) end
    end
    if setLG then setLG(false) end
end
local function stopAutoLeft()
    if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end
    State.autoLeftPhase=1; State.autoLeftEnabled=false
    local c=LP.Character; if c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:Move(Vector3.zero,false) end end
    if toggleRefs.autoLeft then toggleRefs.autoLeft(false) end; if setAL then setAL(false) end
end
local function stopAutoRight()
    if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end
    State.autoRightPhase=1; State.autoRightEnabled=false
    local c=LP.Character; if c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:Move(Vector3.zero,false) end end
    if toggleRefs.autoRight then toggleRefs.autoRight(false) end; if setAR then setAR(false) end
end
local function startAutoLeft()
    if Conns.autoLeft then Conns.autoLeft:Disconnect() end
    State.autoLeftPhase=1; setAutoMoveTravelMode()
    Conns.autoLeft=RunService.Heartbeat:Connect(function()
        if not State.autoLeftEnabled then return end
        local c=LP.Character; if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart"); local hum2=c:FindFirstChildOfClass("Humanoid")
        if not root or not hum2 then return end
        local spd=State.normalSpeed
        if State.autoLeftPhase==1 then
            local tgt=Vector3.new(POS.L1.X,root.Position.Y,POS.L1.Z)
            if (tgt-root.Position).Magnitude<1 then
                State.autoLeftPhase=2
                local d=(POS.L2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit
                hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd); return
            end
            local d=(POS.L1-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit
            hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif State.autoLeftPhase==2 then
            local tgt=Vector3.new(POS.L2.X,root.Position.Y,POS.L2.Z)
            if (tgt-root.Position).Magnitude<1 then
                hum2:Move(Vector3.zero,false); root.AssemblyLinearVelocity=Vector3.zero
                State.autoLeftEnabled=false; if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end
                State.autoLeftPhase=1; setAutoMoveFinishMode()
                if toggleRefs.autoLeft then toggleRefs.autoLeft(false) end; if setAL then setAL(false) end; faceSouth(); return
            end
            local d=(POS.L2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit
            hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end
local function startAutoRight()
    if Conns.autoRight then Conns.autoRight:Disconnect() end
    State.autoRightPhase=1; setAutoMoveTravelMode()
    Conns.autoRight=RunService.Heartbeat:Connect(function()
        if not State.autoRightEnabled then return end
        local c=LP.Character; if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart"); local hum2=c:FindFirstChildOfClass("Humanoid")
        if not root or not hum2 then return end
        local spd=State.normalSpeed
        if State.autoRightPhase==1 then
            local tgt=Vector3.new(POS.R1.X,root.Position.Y,POS.R1.Z)
            if (tgt-root.Position).Magnitude<1 then
                State.autoRightPhase=2
                local d=(POS.R2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit
                hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd); return
            end
            local d=(POS.R1-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit
            hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif State.autoRightPhase==2 then
            local tgt=Vector3.new(POS.R2.X,root.Position.Y,POS.R2.Z)
            if (tgt-root.Position).Magnitude<1 then
                hum2:Move(Vector3.zero,false); root.AssemblyLinearVelocity=Vector3.zero
                State.autoRightEnabled=false; if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end
                State.autoRightPhase=1; setAutoMoveFinishMode()
                if toggleRefs.autoRight then toggleRefs.autoRight(false) end; if setAR then setAR(false) end; faceNorth(); return
            end
            local d=(POS.R2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit
            hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end

-- AUTO STEAL
local function isMyPlotByName(plotName)
    local ct=tick()
    if Steal.plotCache[plotName] and (ct-(Steal.plotCacheTime[plotName] or 0))<PLOT_CACHE_DURATION then return Steal.plotCache[plotName] end
    local plots=workspace:FindFirstChild("Plots")
    if not plots then Steal.plotCache[plotName]=false; Steal.plotCacheTime[plotName]=ct; return false end
    local plot=plots:FindFirstChild(plotName)
    if not plot then Steal.plotCache[plotName]=false; Steal.plotCacheTime[plotName]=ct; return false end
    local sign=plot:FindFirstChild("PlotSign")
    if sign then local yb=sign:FindFirstChild("YourBase"); if yb and yb:IsA("BillboardGui") then local r=yb.Enabled==true; Steal.plotCache[plotName]=r; Steal.plotCacheTime[plotName]=ct; return r end end
    Steal.plotCache[plotName]=false; Steal.plotCacheTime[plotName]=ct; return false
end
local function findNearestPrompt()
    local char=LP.Character; if not char then return nil end
    local root=char:FindFirstChild("HumanoidRootPart"); if not root then return nil end
    local ct=tick()
    if ct-Steal.promptCacheTime<PROMPT_CACHE_REFRESH and #Steal.cachedPrompts>0 then
        local np,nd,nn=nil,math.huge,nil
        for _,data in ipairs(Steal.cachedPrompts) do
            if data.spawn then
                local dist=(data.spawn.Position-root.Position).Magnitude
                if dist<=Steal.StealRadius and dist<nd then np=data.prompt; nd=dist; nn=data.name end
            end
        end
        if np then return np,nd,nn end
    end
    Steal.cachedPrompts={}; Steal.promptCacheTime=ct
    local plots=workspace:FindFirstChild("Plots"); if not plots then return nil end
    local np,nd,nn=nil,math.huge,nil
    for _,plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local pods=plot:FindFirstChild("AnimalPodiums"); if not pods then continue end
        for _,pod in ipairs(pods:GetChildren()) do
            pcall(function()
                local base=pod:FindFirstChild("Base"); local sp=base and base:FindFirstChild("Spawn")
                if sp then
                    local att=sp:FindFirstChild("PromptAttachment")
                    if att then
                        for _,child in ipairs(att:GetChildren()) do
                            if child:IsA("ProximityPrompt") then
                                local dist=(sp.Position-root.Position).Magnitude
                                table.insert(Steal.cachedPrompts,{prompt=child,spawn=sp,name=pod.Name})
                                if dist<=Steal.StealRadius and dist<nd then np=child; nd=dist; nn=pod.Name end
                                break
                            end
                        end
                    end
                end
            end)
        end
    end
    return np,nd,nn
end
local function executeSteal(prompt)
    local ct=tick()
    if ct-State.lastStealTick<STEAL_COOLDOWN or State.isStealing then return end
    if not Steal.Data[prompt] then
        Steal.Data[prompt]={hold={},trigger={},ready=true}
        pcall(function()
            if getconnections then
                for _,c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do if c.Function then table.insert(Steal.Data[prompt].hold,c.Function) end end
                for _,c in ipairs(getconnections(prompt.Triggered)) do if c.Function then table.insert(Steal.Data[prompt].trigger,c.Function) end end
            else Steal.Data[prompt].useFallback=true end
        end)
    end
    local data=Steal.Data[prompt]
    if not data.ready then return end
    data.ready=false; State.isStealing=true; State.stealStartTime=ct; State.lastStealTick=ct
    if Conns.progress then Conns.progress:Disconnect(); Conns.progress=nil end
    Conns.progress=RunService.Heartbeat:Connect(function()
        if not State.isStealing then if Conns.progress then Conns.progress:Disconnect(); Conns.progress=nil end; return end
        local prog=math.clamp((tick()-State.stealStartTime)/STEAL_DURATION,0,1)
        if progressFill then progressFill.Size=UDim2.new(prog,0,1,0) end
        if stealPctLbl then stealPctLbl.Text=math.floor(prog*100).."%  " end
        if radValLbl then radValLbl.Text=tostring(Steal.StealRadius) end
    end)
    task.spawn(function()
        local ok=false
        pcall(function()
            if not data.useFallback then
                for _,fn in ipairs(data.hold) do task.spawn(fn) end
                task.wait(STEAL_DURATION)
                for _,fn in ipairs(data.trigger) do task.spawn(fn) end
                ok=true
            end
        end)
        if not ok and fireproximityprompt then pcall(function() fireproximityprompt(prompt); ok=true end) end
        if not ok then pcall(function() prompt:InputHoldBegin(); task.wait(STEAL_DURATION); prompt:InputHoldEnd() end) end
        task.wait(STEAL_DURATION*0.3)
        if Conns.progress then Conns.progress:Disconnect(); Conns.progress=nil end
        if resetProgressBar then resetProgressBar() end
        task.wait(0.05); data.ready=true; State.isStealing=false
    end)
end
local function startAutoSteal()
    if Conns.autoSteal then return end
    Conns.autoSteal=RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or State.isStealing then return end
        local p=findNearestPrompt(); if p then executeSteal(p) end
    end)
end
local function stopAutoSteal()
    if Conns.autoSteal then Conns.autoSteal:Disconnect(); Conns.autoSteal=nil end
    if Conns.progress then Conns.progress:Disconnect(); Conns.progress=nil end
    State.isStealing=false; State.lastStealTick=0
    Steal.plotCache={}; Steal.plotCacheTime={}; Steal.cachedPrompts={}
    if resetProgressBar then resetProgressBar() end
end

-- LAGGER MODE helper
local LAGGER_MODE_COLORS={[0]=Color3.fromRGB(18,18,18),[1]=Color3.fromRGB(80,60,0),[2]=Color3.fromRGB(0,40,80)}
local function advanceLaggerMode()
    State.laggerMode=(State.laggerMode+1)%3
    if State.laggerMode==0 then
        State.laggerEnabled=false; State.carrySpeed=State._laggerOriginalCarry or 30; State.speedToggled=State._prevSpeed or false
        if speedBoxRefs.carrySpeed then speedBoxRefs.carrySpeed.Text=tostring(State.carrySpeed) end
    elseif State.laggerMode==1 then
        State._laggerOriginalCarry=State.carrySpeed; State._prevSpeed=State.speedToggled
        State.laggerEnabled=true; State.speedToggled=false
    elseif State.laggerMode==2 then
        State.laggerEnabled=true; State.speedToggled=false
    end
    if setLG then setLG(State.laggerMode>0) end
    if toggleRefs.laggerMode then toggleRefs.laggerMode(State.laggerMode>0) end
    task.spawn(syncActiveConfigSnapshot)
end

-- ============================================================
-- ████████╗ █████╗ ██████╗ ███████╗
--    ██╔══╝██╔══██╗██╔══██╗██╔════╝
--    ██║   ███████║██████╔╝███████╗
--    ██║   ██╔══██║██╔══██╗╚════██║
--    ██║   ██║  ██║██████╔╝███████║
--    ╚═╝   ╚═╝  ╚═╝╚═════╝ ╚══════╝
-- ============================================================

-- ─── AUTO PAGE ───────────────────────────────────────────────
local autoPage=addPage("AUTO","⚡")

makeSectionLabel(autoPage,"Stealing")
toggleRefs.autoSteal=makeToggleRow(autoPage,"Auto Steal",false,function(on)
    Steal.AutoStealEnabled=on; State.autoStealEnabled=on
    if on then
        if not pcall(startAutoSteal) then
            Steal.AutoStealEnabled=false; State.autoStealEnabled=false
            if toggleRefs.autoSteal then toggleRefs.autoSteal(false) end
        end
    else stopAutoSteal() end
    task.spawn(syncActiveConfigSnapshot)
end,"autoSteal")

local stealRadiusBox=makeInputRow(autoPage,"Steal Radius",Steal.StealRadius,function(n)
    if n>=5 and n<=300 then
        Steal.StealRadius=math.floor(n); Steal.cachedPrompts={}; Steal.promptCacheTime=0
        if radValLbl then radValLbl.Text=tostring(Steal.StealRadius) end
        task.spawn(syncActiveConfigSnapshot)
    end
end)

makeSectionLabel(autoPage,"Auto Movement")

-- Group: Auto Left + Right + speed mode
do
    local grp=Instance.new("Frame",autoPage)
    grp.Size=UDim2.new(1,0,0,0); grp.AutomaticSize=Enum.AutomaticSize.Y
    grp.BackgroundColor3=C.groupBg; grp.BorderSizePixel=0; grp.ZIndex=7
    grp.LayoutOrder=#autoPage:GetChildren()+1; mkCorner(grp,8); mkStroke(grp,C.borderDim,1)
    local gl=Instance.new("UIListLayout",grp); gl.SortOrder=Enum.SortOrder.LayoutOrder; gl.Padding=UDim.new(0,0)

    toggleRefs.autoLeft=makeToggleRow(grp,"Auto Left",false,function(on)
        State.autoLeftEnabled=on
        if on and State.batAimbotToggled then State.batAimbotToggled=false; stopBatAimbot(); if toggleRefs.aimbot then toggleRefs.aimbot(false) end; if setAB then setAB(false) end end
        if on then startAutoLeft() else stopAutoLeft() end
        task.spawn(syncActiveConfigSnapshot)
    end,"autoLeft")

    toggleRefs.autoRight=makeToggleRow(grp,"Auto Right",false,function(on)
        State.autoRightEnabled=on
        if on and State.batAimbotToggled then State.batAimbotToggled=false; stopBatAimbot(); if toggleRefs.aimbot then toggleRefs.aimbot(false) end; if setAB then setAB(false) end end
        if on then startAutoRight() else stopAutoRight() end
        task.spawn(syncActiveConfigSnapshot)
    end,"autoRight")

    local modeNames={"AUTO SWITCH SPD","MANUAL SPD"}
    local modeColors={Color3.fromRGB(50,160,90),Color3.fromRGB(70,70,70)}
    local smbWrap=Instance.new("Frame",grp); smbWrap.Size=UDim2.new(1,0,0,40); smbWrap.BackgroundTransparency=1; smbWrap.BorderSizePixel=0; smbWrap.LayoutOrder=99
    local smb=Instance.new("TextButton",smbWrap)
    smb.Size=UDim2.new(1,-16,1,-8); smb.Position=UDim2.new(0,8,0,4)
    smb.BackgroundColor3=modeColors[1]; smb.BorderSizePixel=0; smb.Text=modeNames[1]
    smb.TextColor3=Color3.fromRGB(255,255,255); smb.Font=Enum.Font.GothamBold; smb.TextSize=11; smb.ZIndex=8; mkCorner(smb,7)
    smb.MouseButton1Click:Connect(function()
        if State.autoMoveSpeedMode=="autoswitch" then
            State.autoMoveSpeedMode="manual"; smb.Text=modeNames[2]
            TweenService:Create(smb,TweenInfo.new(0.15),{BackgroundColor3=modeColors[2]}):Play()
        else
            State.autoMoveSpeedMode="autoswitch"; smb.Text=modeNames[1]
            TweenService:Create(smb,TweenInfo.new(0.15),{BackgroundColor3=modeColors[1]}):Play()
        end
    end)
end

-- ─── COMBAT PAGE ─────────────────────────────────────────────
local combatPage=addPage("COMBAT","⚔")

makeSectionLabel(combatPage,"Aimbot")
toggleRefs.aimbot=makeToggleRow(combatPage,"Bat Aimbot",false,function(on)
    State.batAimbotToggled=on
    if on then
        if State.autoLeftEnabled then State.autoLeftEnabled=false; stopAutoLeft(); if toggleRefs.autoLeft then toggleRefs.autoLeft(false) end; if setAL then setAL(false) end end
        if State.autoRightEnabled then State.autoRightEnabled=false; stopAutoRight(); if toggleRefs.autoRight then toggleRefs.autoRight(false) end; if setAR then setAR(false) end end
        pcall(startBatAimbot)
    else stopBatAimbot() end
    task.spawn(syncActiveConfigSnapshot)
end,"aimbot")

makeSectionLabel(combatPage,"Counters")
toggleRefs.batCounter=makeToggleRow(combatPage,"Bat Counter",false,function(on)
    State.batCounterEnabled=on; if on then startBatCounter() else stopBatCounter() end; task.spawn(syncActiveConfigSnapshot)
end)
toggleRefs.medusaCounter=makeToggleRow(combatPage,"Medusa Counter",false,function(on)
    State.medusaCounterEnabled=on; if on then setupMedusaCounter(LP.Character) else stopMedusaCounter() end; task.spawn(syncActiveConfigSnapshot)
end)

makeSectionLabel(combatPage,"Actions")
makeActionButton(combatPage,"🎯 Manual Steal",Color3.fromRGB(18,18,60),function()
    local p=findNearestPrompt(); if p then executeSteal(p) end
end)
makeActionButton(combatPage,"📍 Face South",C.navIdle,function() faceSouth() end)
makeActionButton(combatPage,"📍 Face North",C.navIdle,function() faceNorth() end)

-- ─── SPEED PAGE ──────────────────────────────────────────────
local speedPage=addPage("SPEED","💨")

makeSectionLabel(speedPage,"Modes")
toggleRefs.carryMode=makeToggleRow(speedPage,"Carry Mode",false,function(on)
    State.speedToggled=on; task.spawn(syncActiveConfigSnapshot)
end,"speed")

-- Lagger row with cycle button
do
    local row=Instance.new("Frame",speedPage)
    row.Size=UDim2.new(1,0,0,44); row.BackgroundColor3=C.card
    row.BorderSizePixel=0; row.ZIndex=7; row.LayoutOrder=#speedPage:GetChildren()+1; mkCorner(row,7); mkStroke(row,C.borderDim,1)

    makeKeybindChip(row,"lagger",10,-11)

    local modeNames={"Lagger Mode","Lagger Speed","Lag Carry"}
    local modeColors={C.textDim,Color3.fromRGB(255,200,80),Color3.fromRGB(120,200,255)}

    laggerModeBtn=Instance.new("TextLabel",row)
    laggerModeBtn.Size=UDim2.new(1,-130,1,0); laggerModeBtn.Position=UDim2.new(0,54,0,0)
    laggerModeBtn.BackgroundTransparency=1; laggerModeBtn.Text=modeNames[State.laggerMode+1]
    laggerModeBtn.TextColor3=modeColors[State.laggerMode+1]; laggerModeBtn.Font=Enum.Font.GothamBold
    laggerModeBtn.TextSize=12; laggerModeBtn.TextXAlignment=Enum.TextXAlignment.Left; laggerModeBtn.ZIndex=8

    local cycleBtn=Instance.new("TextButton",row)
    cycleBtn.Size=UDim2.new(0,54,0,24); cycleBtn.Position=UDim2.new(1,-66,0.5,-12)
    cycleBtn.BackgroundColor3=C.chipBg; cycleBtn.BorderSizePixel=0; cycleBtn.Text="CYCLE"
    cycleBtn.TextColor3=C.textSub; cycleBtn.Font=Enum.Font.GothamBold; cycleBtn.TextSize=9; cycleBtn.ZIndex=9; mkCorner(cycleBtn,5); mkStroke(cycleBtn,C.borderDim,1)
    cycleBtn.MouseButton1Click:Connect(function()
        advanceLaggerMode()
        laggerModeBtn.Text=modeNames[State.laggerMode+1]; laggerModeBtn.TextColor3=modeColors[State.laggerMode+1]
    end)

    local clkArea=Instance.new("TextButton",row)
    clkArea.Size=UDim2.new(1,-130,1,0); clkArea.Position=UDim2.new(0,54,0,0)
    clkArea.BackgroundTransparency=1; clkArea.Text=""; clkArea.ZIndex=9; clkArea.BorderSizePixel=0
    clkArea.MouseButton1Click:Connect(function()
        advanceLaggerMode()
        laggerModeBtn.Text=modeNames[State.laggerMode+1]; laggerModeBtn.TextColor3=modeColors[State.laggerMode+1]
    end)
    toggleRefs.laggerMode=function(on) end
end

makeSectionLabel(speedPage,"Values")
do local box=makeInputRow(speedPage,"Normal Speed",State.normalSpeed,function(n)
    if n>=1 and n<=500 then State.normalSpeed=n; task.spawn(syncActiveConfigSnapshot)
    elseif speedBoxRefs.normalSpeed then speedBoxRefs.normalSpeed.Text=tostring(State.normalSpeed) end
end); speedBoxRefs.normalSpeed=box end
do local box=makeInputRow(speedPage,"Carry Speed",State.carrySpeed,function(n)
    if n>=1 and n<=500 then State.carrySpeed=n; task.spawn(syncActiveConfigSnapshot)
    elseif speedBoxRefs.carrySpeed then speedBoxRefs.carrySpeed.Text=tostring(State.carrySpeed) end
end); speedBoxRefs.carrySpeed=box end
do local box=makeInputRow(speedPage,"Lagger Speed",State.laggerSpeed,function(n)
    if n>=1 and n<=500 then State.laggerSpeed=n; task.spawn(syncActiveConfigSnapshot)
    elseif speedBoxRefs.laggerSpeed then speedBoxRefs.laggerSpeed.Text=tostring(State.laggerSpeed) end
end); speedBoxRefs.laggerSpeed=box end
do local box=makeInputRow(speedPage,"Lag Carry Speed",State.lagCarrySpeed,function(n)
    if n>=1 and n<=500 then State.lagCarrySpeed=n; task.spawn(syncActiveConfigSnapshot)
    elseif lagCarrySpeedBox then lagCarrySpeedBox.Text=tostring(State.lagCarrySpeed) end
end); lagCarrySpeedBox=box end

makeActionButton(speedPage,"⚡ Apply Speeds Now",Color3.fromRGB(20,20,50),function()
    -- speeds are applied in RenderStepped loop automatically
    local lbl=speedPage:FindFirstChildWhichIsA("TextButton",true)
end)

-- ─── MOVEMENT PAGE ───────────────────────────────────────────
local movePage=addPage("MOVEMENT","🏃")

makeSectionLabel(movePage,"Protection")
toggleRefs.antiRagdoll=makeToggleRow(movePage,"Anti Ragdoll",false,function(on)
    State.antiRagdollEnabled=on; if on then startAntiRagdoll() else stopAntiRagdoll() end; task.spawn(syncActiveConfigSnapshot)
end)
toggleRefs.unwalk=makeToggleRow(movePage,"Unwalk",false,function(on)
    State.unwalkEnabled=on; if on then startUnwalk() else stopUnwalk() end; task.spawn(syncActiveConfigSnapshot)
end)

makeSectionLabel(movePage,"Jump")
do
    local grp=Instance.new("Frame",movePage)
    grp.Size=UDim2.new(1,0,0,0); grp.AutomaticSize=Enum.AutomaticSize.Y
    grp.BackgroundColor3=C.groupBg; grp.BorderSizePixel=0; grp.ZIndex=7
    grp.LayoutOrder=#movePage:GetChildren()+1; mkCorner(grp,8); mkStroke(grp,C.borderDim,1)
    local gl=Instance.new("UIListLayout",grp); gl.SortOrder=Enum.SortOrder.LayoutOrder; gl.Padding=UDim.new(0,0)

    toggleRefs.infJump=makeToggleRow(grp,"Infinite Jump",false,function(on)
        State.infJumpEnabled=on; if on then startInfiniteJump() else stopInfiniteJump() end; task.spawn(syncActiveConfigSnapshot)
    end)

    local jmNames={"MANUAL MODE","HOLD MODE"}
    local jmColors={Color3.fromRGB(50,50,50),Color3.fromRGB(30,80,200)}
    local jmbWrap=Instance.new("Frame",grp); jmbWrap.Size=UDim2.new(1,0,0,40); jmbWrap.BackgroundTransparency=1; jmbWrap.BorderSizePixel=0; jmbWrap.LayoutOrder=99
    local jmb=Instance.new("TextButton",jmbWrap)
    jmb.Size=UDim2.new(1,-16,1,-8); jmb.Position=UDim2.new(0,8,0,4)
    jmb.BackgroundColor3=jmColors[1]; jmb.BorderSizePixel=0; jmb.Text=jmNames[1]
    jmb.TextColor3=Color3.fromRGB(255,255,255); jmb.Font=Enum.Font.GothamBold; jmb.TextSize=11; jmb.ZIndex=8; mkCorner(jmb,7)
    jmb.MouseButton1Click:Connect(function()
        if State.infJumpMode=="manual" then
            State.infJumpMode="hold"; jmb.Text=jmNames[2]; TweenService:Create(jmb,TweenInfo.new(0.15),{BackgroundColor3=jmColors[2]}):Play()
        else
            State.infJumpMode="manual"; jmb.Text=jmNames[1]; TweenService:Create(jmb,TweenInfo.new(0.15),{BackgroundColor3=jmColors[1]}):Play()
        end
        if State.infJumpEnabled then startInfiniteJump() end
    end)
end

makeSectionLabel(movePage,"Actions")
makeActionButton(movePage,"⬇ TP Down",C.navIdle,function() doTpDown() end,"tpDown")
makeToggleRow(movePage,"Drop Brainrot",false,function(on) if on and not State.dropEnabled then runDropBrainrot() end end,"drop")
makeActionButton(movePage,"🔄 Respawn Character",Color3.fromRGB(40,10,10),function()
    pcall(function() LP:LoadCharacter() end)
end)

-- ─── VISUALS PAGE ────────────────────────────────────────────
local visualsPage=addPage("VISUALS","👁")

makeSectionLabel(visualsPage,"Players")
toggleRefs.removeAccessories=makeToggleRow(visualsPage,"Remove Accessories",false,function(on)
    if on then
        for _,p in pairs(Players:GetPlayers()) do
            if p.Character then
                for _,obj in ipairs(p.Character:GetDescendants()) do
                    if obj:IsA("Accessory") or obj:IsA("Hat") then pcall(function() obj:Destroy() end) end
                end
            end
        end
    end
end)
toggleRefs.espEnabled=makeToggleRow(visualsPage,"Speed ESP (Others)",true,function(on)
    State.espEnabled=on
    for _,bb in pairs(espBillboards) do
        local lbl2=bb:FindFirstChildOfClass("TextLabel")
        if lbl2 then lbl2.Visible=on end
    end
end)

makeSectionLabel(visualsPage,"Environment")
local defBright=Lighting.Brightness; local defClock=Lighting.ClockTime
local defOutdoor=Lighting.OutdoorAmbient; local defExposure=Lighting.ExposureCompensation
toggleRefs.darkMode=makeToggleRow(visualsPage,"Dark Mode",false,function(on)
    if on then
        local sky=Lighting:FindFirstChild("AmirDarkSky") or Instance.new("Sky")
        sky.Name="AmirDarkSky"
        sky.SkyboxBk="rbxassetid://159454299"; sky.SkyboxDn="rbxassetid://159454296"
        sky.SkyboxFt="rbxassetid://159454293"; sky.SkyboxLf="rbxassetid://159454286"
        sky.SkyboxRt="rbxassetid://159454289"; sky.SkyboxUp="rbxassetid://159454291"
        sky.Parent=Lighting
        Lighting.Brightness=0; Lighting.ClockTime=0; Lighting.ExposureCompensation=-2; Lighting.OutdoorAmbient=Color3.fromRGB(0,0,0)
    else
        local s=Lighting:FindFirstChild("AmirDarkSky"); if s then s:Destroy() end
        Lighting.Brightness=defBright; Lighting.ClockTime=defClock; Lighting.ExposureCompensation=defExposure; Lighting.OutdoorAmbient=defOutdoor
    end
end)

makeSectionLabel(visualsPage,"Camera")
do
    local cam=workspace.CurrentCamera; local curFOV=math.clamp(cam.FieldOfView,60,120)
    makeSliderRow(visualsPage,"Field of View",60,120,curFOV,function(v)
        curFOV=math.floor(v); pcall(function() workspace.CurrentCamera.FieldOfView=curFOV end)
    end,function(v) return tostring(math.floor(v)) end)
    RunService.RenderStepped:Connect(function()
        if workspace.CurrentCamera.FieldOfView~=curFOV then pcall(function() workspace.CurrentCamera.FieldOfView=curFOV end) end
    end)
end

makeSectionLabel(visualsPage,"Interface")
do
    makeSliderRow(visualsPage,"UI Scale",0.5,1.0,1.0,function(v)
        local sv=math.clamp(math.floor(v*20+0.5)/20,0.5,1.0)
        if uiScaleObj then uiScaleObj.Scale=sv end
    end,function(v) return string.format("%.2f",math.clamp(math.floor(v*20+0.5)/20,0.5,1.0)) end)
end

-- ─── CONFIGS PAGE ────────────────────────────────────────────
local cfgPage=addPage("CONFIGS","💾")

makeSectionLabel(cfgPage,"Save Config")
do
    local wrap=Instance.new("Frame",cfgPage); wrap.Size=UDim2.new(1,0,0,44)
    wrap.BackgroundColor3=C.card; wrap.BorderSizePixel=0; wrap.ZIndex=7
    wrap.LayoutOrder=#cfgPage:GetChildren()+1; mkCorner(wrap,7); mkStroke(wrap,C.borderDim,1)
    local bw=Instance.new("Frame",wrap); bw.Size=UDim2.new(1,-16,0,30); bw.Position=UDim2.new(0,8,0.5,-15)
    bw.BackgroundColor3=C.bg; bw.BorderSizePixel=0; mkCorner(bw,6); mkStroke(bw,C.borderDim,1)
    configNameBox=Instance.new("TextBox",bw)
    configNameBox.Size=UDim2.new(1,-12,1,0); configNameBox.Position=UDim2.new(0,6,0,0)
    configNameBox.BackgroundTransparency=1; configNameBox.PlaceholderText="Config name..."
    configNameBox.PlaceholderColor3=C.textDim; configNameBox.Text=""
    configNameBox.TextColor3=C.text; configNameBox.Font=Enum.Font.GothamBold; configNameBox.TextSize=12
    configNameBox.ClearTextOnFocus=false; configNameBox.ZIndex=8
    configNameBox.TextXAlignment=Enum.TextXAlignment.Left
end

local savePBtn=makeActionButton(cfgPage,"💾  Save Config",C.navIdle,function()
    local nm=configNameBox.Text:match("^%s*(.-)%s*$")
    if nm=="" then savePBtn.Text="⚠ Name required!"; task.delay(1.5,function() savePBtn.Text="💾  Save Config" end); return end
    if performSaveNamedConfig then performSaveNamedConfig(nm) end
    configNameBox.Text=""; savePBtn.Text="✅ Saved!"; task.delay(1.5,function() savePBtn.Text="💾  Save Config" end)
end)

makeSectionLabel(cfgPage,"Saved Configs")
configListFrame=Instance.new("Frame",cfgPage)
configListFrame.Size=UDim2.new(1,0,0,0); configListFrame.AutomaticSize=Enum.AutomaticSize.Y
configListFrame.BackgroundTransparency=1; configListFrame.BorderSizePixel=0
configListFrame.LayoutOrder=#cfgPage:GetChildren()+1; configListFrame.ZIndex=7
local cll=Instance.new("UIListLayout",configListFrame); cll.SortOrder=Enum.SortOrder.LayoutOrder; cll.Padding=UDim.new(0,4)
local emptyLbl=Instance.new("TextLabel",configListFrame)
emptyLbl.Name="EmptyLabel"; emptyLbl.Size=UDim2.new(1,0,0,28); emptyLbl.BackgroundTransparency=1
emptyLbl.Text="No configs saved yet."; emptyLbl.TextColor3=C.textSub
emptyLbl.Font=Enum.Font.Gotham; emptyLbl.TextSize=11; emptyLbl.TextXAlignment=Enum.TextXAlignment.Center; emptyLbl.LayoutOrder=1; emptyLbl.ZIndex=8

-- ─── DISCORD PAGE ────────────────────────────────────────────
local discordPage=addPage("DISCORD","💬")
do
    local LINK="https://discord.gg/wk2tfk36bZ"
    local card=Instance.new("Frame",discordPage)
    card.Size=UDim2.new(1,0,0,80); card.BackgroundColor3=Color3.fromRGB(88,101,242)
    card.BorderSizePixel=0; card.LayoutOrder=1; card.ZIndex=8; mkCorner(card,10); mkStroke(card,Color3.fromRGB(120,130,255),1)
    local dIcon=Instance.new("TextLabel",card)
    dIcon.Size=UDim2.new(1,0,0,28); dIcon.Position=UDim2.new(0,0,0,8)
    dIcon.BackgroundTransparency=1; dIcon.Text="DISCORD"; dIcon.TextColor3=Color3.fromRGB(255,255,255)
    dIcon.Font=Enum.Font.GothamBlack; dIcon.TextSize=20; dIcon.TextXAlignment=Enum.TextXAlignment.Center; dIcon.ZIndex=9
    local dUrl=Instance.new("TextLabel",card)
    dUrl.Size=UDim2.new(1,-20,0,22); dUrl.Position=UDim2.new(0,10,0,38)
    dUrl.BackgroundTransparency=1; dUrl.Text="discord.gg/wk2tfk36bZ"; dUrl.TextColor3=Color3.fromRGB(210,215,255)
    dUrl.Font=Enum.Font.GothamBold; dUrl.TextSize=13; dUrl.TextXAlignment=Enum.TextXAlignment.Center; dUrl.ZIndex=9
    makeActionButton(discordPage,"📋  Copy Discord Link",Color3.fromRGB(88,101,242),function()
        pcall(function() setclipboard(LINK) end)
    end)
    local credCard=Instance.new("Frame",discordPage)
    credCard.Size=UDim2.new(1,0,0,60); credCard.BackgroundColor3=C.card
    credCard.BorderSizePixel=0; credCard.LayoutOrder=#discordPage:GetChildren()+2; credCard.ZIndex=8; mkCorner(credCard,10); mkStroke(credCard,C.borderDim,1)
    local credLbl=Instance.new("TextLabel",credCard)
    credLbl.Size=UDim2.new(1,-16,1,0); credLbl.Position=UDim2.new(0,8,0,0)
    credLbl.BackgroundTransparency=1; credLbl.Text="Phantom Duels V5.4\nAmir Hub Remake"
    credLbl.TextColor3=C.textSub; credLbl.Font=Enum.Font.GothamBold; credLbl.TextSize=11
    credLbl.TextXAlignment=Enum.TextXAlignment.Center; credLbl.ZIndex=9
end

-- ============================================================
-- CONFIG LIST BUILDER
-- ============================================================
rebuildConfigList=function()
    if not configListFrame then return end
    for _,child in ipairs(configListFrame:GetChildren()) do
        if child.Name~="EmptyLabel" and not child:IsA("UIListLayout") then child:Destroy() end
    end
    local el=configListFrame:FindFirstChild("EmptyLabel")
    if el then el.Visible=(#Configs==0) end
    for i,cfg in ipairs(Configs) do
        local row=Instance.new("Frame",configListFrame)
        row.Name="Config_"..i; row.Size=UDim2.new(1,0,0,38)
        row.BackgroundColor3=C.card; row.BorderSizePixel=0; row.LayoutOrder=i+1; row.ZIndex=8; mkCorner(row,7); mkStroke(row,C.borderDim,1)
        local nl=Instance.new("TextLabel",row)
        nl.Size=UDim2.new(1,-102,1,0); nl.Position=UDim2.new(0,10,0,0); nl.BackgroundTransparency=1
        nl.Text=cfg.name; nl.TextColor3=cfg.name==activeConfigName and C.text or C.textSub
        nl.Font=Enum.Font.GothamBold; nl.TextSize=12; nl.TextXAlignment=Enum.TextXAlignment.Left; nl.TextTruncate=Enum.TextTruncate.AtEnd; nl.ZIndex=9
        local lb=Instance.new("TextButton",row)
        lb.Size=UDim2.new(0,44,0,26); lb.Position=UDim2.new(1,-96,0.5,-13)
        lb.BackgroundColor3=C.navIdle; lb.BorderSizePixel=0; lb.Text="Load"; lb.TextColor3=C.text
        lb.Font=Enum.Font.GothamBold; lb.TextSize=11; lb.ZIndex=9; mkCorner(lb,5); mkStroke(lb,C.borderDim,1)
        lb.MouseButton1Click:Connect(function()
            if cfg.data then
                -- apply speeds
                if cfg.data.normalSpeed then State.normalSpeed=cfg.data.normalSpeed; if speedBoxRefs.normalSpeed then speedBoxRefs.normalSpeed.Text=tostring(State.normalSpeed) end end
                if cfg.data.carrySpeed then State.carrySpeed=cfg.data.carrySpeed; if speedBoxRefs.carrySpeed then speedBoxRefs.carrySpeed.Text=tostring(State.carrySpeed) end end
                if cfg.data.laggerSpeed then State.laggerSpeed=cfg.data.laggerSpeed; if speedBoxRefs.laggerSpeed then speedBoxRefs.laggerSpeed.Text=tostring(State.laggerSpeed) end end
                if cfg.data.lagCarrySpeed then State.lagCarrySpeed=cfg.data.lagCarrySpeed; if lagCarrySpeedBox then lagCarrySpeedBox.Text=tostring(State.lagCarrySpeed) end end
                if cfg.data.stealRadius then Steal.StealRadius=cfg.data.stealRadius; if radValLbl then radValLbl.Text=tostring(Steal.StealRadius) end end
                if cfg.data.infJump~=nil and toggleRefs.infJump then State.infJumpEnabled=cfg.data.infJump; toggleRefs.infJump(cfg.data.infJump); if cfg.data.infJump then startInfiniteJump() else stopInfiniteJump() end end
                if cfg.data.antiRagdoll~=nil and toggleRefs.antiRagdoll then State.antiRagdollEnabled=cfg.data.antiRagdoll; toggleRefs.antiRagdoll(cfg.data.antiRagdoll); if cfg.data.antiRagdoll then startAntiRagdoll() else stopAntiRagdoll() end end
                if cfg.data.medusaCounter~=nil and toggleRefs.medusaCounter then State.medusaCounterEnabled=cfg.data.medusaCounter; toggleRefs.medusaCounter(cfg.data.medusaCounter); if cfg.data.medusaCounter then setupMedusaCounter(LP.Character) else stopMedusaCounter() end end
                if cfg.data.batCounter~=nil and toggleRefs.batCounter then State.batCounterEnabled=cfg.data.batCounter; toggleRefs.batCounter(cfg.data.batCounter); if cfg.data.batCounter then startBatCounter() else stopBatCounter() end end
                if cfg.data.autoSteal~=nil and toggleRefs.autoSteal then Steal.AutoStealEnabled=cfg.data.autoSteal; toggleRefs.autoSteal(cfg.data.autoSteal); if cfg.data.autoSteal then pcall(startAutoSteal) else stopAutoSteal() end end
            end
            activeConfigName=cfg.name; saveLastConfigName(cfg.name); rebuildConfigList()
            lb.Text="✅"; task.delay(1.2,function() if lb and lb.Parent then lb.Text="Load" end end)
        end)
        local db=Instance.new("TextButton",row)
        db.Size=UDim2.new(0,34,0,26); db.Position=UDim2.new(1,-42,0.5,-13)
        db.BackgroundColor3=Color3.fromRGB(45,12,12); db.BorderSizePixel=0; db.Text="✕"; db.TextColor3=Color3.fromRGB(255,120,120)
        db.Font=Enum.Font.GothamBold; db.TextSize=12; db.ZIndex=9; mkCorner(db,5)
        db.MouseButton1Click:Connect(function()
            if activeConfigName==cfg.name then activeConfigName=nil end
            table.remove(Configs,i); saveConfigsFile(); rebuildConfigList()
        end)
    end
end

performSaveNamedConfig=function(nm)
    local snapshot=buildConfigSnapshot()
    local found=false
    for i,p in ipairs(Configs) do if p.name==nm then Configs[i].data=snapshot; found=true; break end end
    if not found then table.insert(Configs,{name=nm,data=snapshot}) end
    activeConfigName=nm; saveLastConfigName(nm); saveConfigsFile(); rebuildConfigList()
end

-- Close/Reopen
reopenBtn=Instance.new("TextButton",gui)
reopenBtn.Name="AmirHubReopenBtn"; reopenBtn.Size=UDim2.new(0,140,0,30)
reopenBtn.Position=UDim2.new(0,10,0,86); reopenBtn.BackgroundColor3=Color3.fromRGB(8,8,8)
reopenBtn.BorderSizePixel=0; reopenBtn.Text="Phantom Duels"; reopenBtn.TextColor3=Color3.fromRGB(200,200,200)
reopenBtn.Font=Enum.Font.GothamBold; reopenBtn.TextSize=11; reopenBtn.ZIndex=200; reopenBtn.Visible=false
mkCorner(reopenBtn,6); mkStroke(reopenBtn,C.borderDim,1)
applySavedPosition(reopenBtn,"mainReopen"); watchFramePosition("mainReopen",reopenBtn)
makeDraggable(reopenBtn)

closeBtn.MouseButton1Click:Connect(function() mainOuter.Visible=false; reopenBtn.Visible=true end)
minBtn.MouseButton1Click:Connect(function() mainOuter.Visible=false; reopenBtn.Visible=true end)
bindTapOnly(reopenBtn,function() mainOuter.Visible=true; reopenBtn.Visible=false end)

-- ============================================================
-- GUI #2: AUTO-STEAL PROGRESS BAR (draggable)
-- ============================================================
progressGui=Instance.new("Frame",gui)
progressGui.Name="AmirAutoStealBar"; progressGui.Size=UDim2.new(0,240,0,52)
progressGui.Position=UDim2.new(0.5,-120,1,-64); progressGui.BackgroundColor3=Color3.fromRGB(8,8,8)
progressGui.BorderSizePixel=0; progressGui.Active=true; progressGui.ZIndex=120; mkCorner(progressGui,10); mkStroke(progressGui,Color3.fromRGB(25,25,25),1)
applySavedPosition(progressGui,"autoStealBar"); watchFramePosition("autoStealBar",progressGui)
makeDraggable(progressGui)

stealPctLbl=Instance.new("TextLabel",progressGui)
stealPctLbl.Size=UDim2.new(0,38,0,18); stealPctLbl.Position=UDim2.new(0,8,0,7)
stealPctLbl.BackgroundTransparency=1; stealPctLbl.Text="0%"
stealPctLbl.TextColor3=Color3.fromRGB(210,210,210); stealPctLbl.Font=Enum.Font.GothamBlack; stealPctLbl.TextSize=14
stealPctLbl.TextXAlignment=Enum.TextXAlignment.Left; stealPctLbl.ZIndex=121

local radLbl=Instance.new("TextLabel",progressGui)
radLbl.Size=UDim2.new(0,52,0,16); radLbl.Position=UDim2.new(0,50,0,8)
radLbl.BackgroundTransparency=1; radLbl.Text="Radius:"; radLbl.TextColor3=Color3.fromRGB(110,110,110)
radLbl.Font=Enum.Font.GothamBold; radLbl.TextSize=10; radLbl.TextXAlignment=Enum.TextXAlignment.Left; radLbl.ZIndex=121

radValLbl=Instance.new("TextLabel",progressGui)
radValLbl.Size=UDim2.new(0,36,0,16); radValLbl.Position=UDim2.new(0,104,0,8)
radValLbl.BackgroundColor3=Color3.fromRGB(22,22,22); radValLbl.BorderSizePixel=0
radValLbl.Text=tostring(Steal.StealRadius); radValLbl.TextColor3=Color3.fromRGB(210,210,210)
radValLbl.Font=Enum.Font.GothamBlack; radValLbl.TextSize=10; radValLbl.TextXAlignment=Enum.TextXAlignment.Center; radValLbl.ZIndex=121; mkCorner(radValLbl,5)

local barTitle=Instance.new("TextLabel",progressGui)
barTitle.Size=UDim2.new(1,-160,0,14); barTitle.Position=UDim2.new(0,148,0,5)
barTitle.BackgroundTransparency=1; barTitle.Text="AUTO STEAL"; barTitle.TextColor3=C.textDim
barTitle.Font=Enum.Font.GothamBold; barTitle.TextSize=9; barTitle.TextXAlignment=Enum.TextXAlignment.Right; barTitle.ZIndex=121

local pTrack=Instance.new("Frame",progressGui)
pTrack.Size=UDim2.new(1,-10,0,12); pTrack.Position=UDim2.new(0,5,1,-16)
pTrack.BackgroundColor3=Color3.fromRGB(28,28,28); pTrack.BorderSizePixel=0; pTrack.ZIndex=121; mkCorner(pTrack,5)

progressFill=Instance.new("Frame",pTrack)
progressFill.Size=UDim2.new(0,0,1,0); progressFill.BackgroundColor3=Color3.fromRGB(91,140,255)
progressFill.BorderSizePixel=0; progressFill.ZIndex=122; mkCorner(progressFill,5)

resetProgressBar=function()
    if stealPctLbl then stealPctLbl.Text="0%" end
    if progressFill then progressFill.Size=UDim2.new(0,0,1,0) end
    if radValLbl then radValLbl.Text=tostring(Steal.StealRadius) end
end

-- ============================================================
-- GUI #3: MOBILE BUTTONS PANEL (draggable)
-- ============================================================
local PANEL_W=148; local PANEL_H=260
local CELL_W=math.floor((PANEL_W-20)/2)
local CELL_H=math.floor((PANEL_H-48)/4)

local Q_OFF=Color3.fromRGB(18,18,18); local Q_ON=Color3.fromRGB(60,60,60)
local Q_TXT=Color3.fromRGB(210,210,210)

mbGroup=Instance.new("Frame",gui)
mbGroup.Name="MobileButtons"; mbGroup.Size=UDim2.new(0,PANEL_W,0,PANEL_H)
mbGroup.Position=UDim2.new(1,-PANEL_W-8,0.5,-PANEL_H/2)
mbGroup.BackgroundColor3=Color3.fromRGB(0,0,0); mbGroup.BorderSizePixel=0
mbGroup.Active=true; mbGroup.ZIndex=100; mkCorner(mbGroup,12); mkStroke(mbGroup,C.borderDim,1)
applySavedPosition(mbGroup,"mobilePanel"); watchFramePosition("mobilePanel",mbGroup)

local mbTitle=Instance.new("TextLabel",mbGroup)
mbTitle.Size=UDim2.new(1,0,0,22); mbTitle.Position=UDim2.new(0,0,0,4)
mbTitle.BackgroundTransparency=1; mbTitle.Text="QUICK ACCESS"
mbTitle.TextColor3=C.textDim; mbTitle.Font=Enum.Font.GothamBold; mbTitle.TextSize=9
mbTitle.TextXAlignment=Enum.TextXAlignment.Center; mbTitle.ZIndex=101

-- drag handle = mbGroup itself
makeDraggable(mbGroup)

local mbWrap=Instance.new("Frame",mbGroup)
mbWrap.Size=UDim2.new(1,-12,1,-34); mbWrap.Position=UDim2.new(0,6,0,28)
mbWrap.BackgroundTransparency=1; mbWrap.ZIndex=101
local mbGrid=Instance.new("UIGridLayout",mbWrap)
mbGrid.CellSize=UDim2.new(0,CELL_W,0,CELL_H); mbGrid.CellPadding=UDim2.new(0,5,0,5)
mbGrid.SortOrder=Enum.SortOrder.LayoutOrder; mbGrid.FillDirectionMaxCells=2

local function makeMobileBtn(topText, botText, lo, isToggle, onAction, specialColor)
    local frame=Instance.new("Frame",mbWrap)
    frame.LayoutOrder=lo; frame.BackgroundColor3=specialColor or Q_OFF
    frame.BorderSizePixel=0; frame.Active=true; frame.ZIndex=102; mkCorner(frame,9)

    local btn=Instance.new("TextButton",frame)
    btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Text=""
    btn.ZIndex=103; btn.BorderSizePixel=0; btn.AutoButtonColor=false

    local tL=Instance.new("TextLabel",btn)
    tL.Size=UDim2.new(1,0,0.52,0); tL.Position=UDim2.new(0,0,0.06,0)
    tL.BackgroundTransparency=1; tL.Text=topText; tL.TextColor3=Q_TXT
    tL.Font=Enum.Font.GothamBlack; tL.TextSize=11; tL.TextXAlignment=Enum.TextXAlignment.Center; tL.ZIndex=104

    local bL=Instance.new("TextLabel",btn)
    bL.Size=UDim2.new(1,0,0.44,0); bL.Position=UDim2.new(0,0,0.52,0)
    bL.BackgroundTransparency=1; bL.Text=botText; bL.TextColor3=Q_TXT
    bL.Font=Enum.Font.GothamBlack; bL.TextSize=11; bL.TextXAlignment=Enum.TextXAlignment.Center; bL.ZIndex=104

    local isOn=false
    local function setter(s)
        isOn=s
        TweenService:Create(frame,TweenInfo.new(0.15),{BackgroundColor3=s and Q_ON or (specialColor or Q_OFF)}):Play()
    end
    btn.MouseButton1Click:Connect(function()
        if isToggle then
            isOn=not isOn; setter(isOn); if onAction then onAction(isOn) end
        else
            TweenService:Create(frame,TweenInfo.new(0.08),{BackgroundColor3=Q_ON}):Play()
            task.delay(0.22,function() TweenService:Create(frame,TweenInfo.new(0.15),{BackgroundColor3=specialColor or Q_OFF}):Play() end)
            if onAction then onAction() end
        end
    end)
    return frame,setter,tL,bL
end

-- Row 0
makeMobileBtn("DROP","BR",1,false,function() if not State.dropEnabled then runDropBrainrot() end end)
local _,setALfn=makeMobileBtn("AUTO","LEFT",2,true,function(on)
    State.autoLeftEnabled=on; if toggleRefs.autoLeft then toggleRefs.autoLeft(on) end
    if on then
        if State.autoRightEnabled then State.autoRightEnabled=false; if setAR then setAR(false) end; stopAutoRight() end
        if State.batAimbotToggled then State.batAimbotToggled=false; if setAB then setAB(false) end; stopBatAimbot() end
        startAutoLeft()
    else stopAutoLeft() end
end); setAL=setALfn

-- Row 1
local _,setABfn=makeMobileBtn("BAT","LOCK",3,true,function(on)
    State.batAimbotToggled=on; if toggleRefs.aimbot then toggleRefs.aimbot(on) end
    if on then
        if State.autoLeftEnabled then State.autoLeftEnabled=false; if setAL then setAL(false) end; stopAutoLeft() end
        if State.autoRightEnabled then State.autoRightEnabled=false; if setAR then setAR(false) end; stopAutoRight() end
        startBatAimbot()
    else stopBatAimbot() end
end); setAB=setABfn

local _,setARfn=makeMobileBtn("AUTO","RIGHT",4,true,function(on)
    State.autoRightEnabled=on; if toggleRefs.autoRight then toggleRefs.autoRight(on) end
    if on then
        if State.autoLeftEnabled then State.autoLeftEnabled=false; if setAL then setAL(false) end; stopAutoLeft() end
        if State.batAimbotToggled then State.batAimbotToggled=false; if setAB then setAB(false) end; stopBatAimbot() end
        startAutoRight()
    else stopAutoRight() end
end); setAR=setARfn

-- Row 2
makeMobileBtn("TP","DOWN",5,false,function() doTpDown() end)
local _,setCSfn=makeMobileBtn("CARRY","SPD",6,true,function(on)
    State.speedToggled=on; if toggleRefs.carryMode then toggleRefs.carryMode(on) end
end); setCS=setCSfn

-- Row 3
makeMobileBtn("BAT","CTR",7,true,function(on)
    State.batCounterEnabled=on; if on then startBatCounter() else stopBatCounter() end
end)

local lagFrame,_,lagTopLbl,lagBotLbl=makeMobileBtn("LAG","MODE",8,false,function()
    advanceLaggerMode()
    local modeNames={"Lagger Mode","Lagger Speed","Lag Carry"}
    local modeColors={C.textDim,Color3.fromRGB(255,200,80),Color3.fromRGB(120,200,255)}
    if laggerModeBtn then laggerModeBtn.Text=modeNames[State.laggerMode+1]; laggerModeBtn.TextColor3=modeColors[State.laggerMode+1] end
    TweenService:Create(lagFrame,TweenInfo.new(0.15),{BackgroundColor3=LAGGER_MODE_COLORS[State.laggerMode]}):Play()
end)
setLG=function(on) end

-- Hide/Show toggle for mobile panel
toggleFrame=Instance.new("Frame",gui)
toggleFrame.Name="MobileToggle"; toggleFrame.Size=UDim2.new(0,PANEL_W,0,30)
toggleFrame.Position=UDim2.new(mbGroup.Position.X.Scale,mbGroup.Position.X.Offset,mbGroup.Position.Y.Scale,mbGroup.Position.Y.Offset+PANEL_H+5)
toggleFrame.BackgroundColor3=Color3.fromRGB(0,0,0); toggleFrame.BorderSizePixel=0
toggleFrame.Active=true; toggleFrame.ZIndex=100; mkCorner(toggleFrame,7); mkStroke(toggleFrame,C.borderDim,1)
applySavedPosition(toggleFrame,"mobileToggle"); watchFramePosition("mobileToggle",toggleFrame)

local toggleButton=Instance.new("TextButton",toggleFrame)
toggleButton.Size=UDim2.new(1,-4,1,-4); toggleButton.Position=UDim2.new(0,2,0,2)
toggleButton.BackgroundTransparency=1; toggleButton.Text="HIDE BTNS"
toggleButton.TextColor3=Color3.fromRGB(200,200,200); toggleButton.Font=Enum.Font.GothamBold; toggleButton.TextSize=10
toggleButton.ZIndex=101; toggleButton.AutoButtonColor=false; mkCorner(toggleButton,6)

local panelVisible=true
toggleButton.MouseButton1Click:Connect(function()
    panelVisible=not panelVisible; mbGroup.Visible=panelVisible
    toggleButton.Text=panelVisible and "HIDE BTNS" or "SHOW BTNS"
end)
makeDraggable(toggleFrame)

-- Sync toggle position when mbGroup moves
mbGroup:GetPropertyChangedSignal("Position"):Connect(function()
    toggleFrame.Position=UDim2.new(mbGroup.Position.X.Scale,mbGroup.Position.X.Offset,
        mbGroup.Position.Y.Scale,mbGroup.Position.Y.Offset+PANEL_H+5)
end)

-- ============================================================
-- CHARACTER SETUP + MAIN GAME LOOP
-- ============================================================
local function setupChar(char)
    task.wait(0.1)
    h=char:WaitForChild("Humanoid",5); hrp=char:WaitForChild("HumanoidRootPart",5)
    if not h or not hrp then return end
    createSpeedLabel(char)
    if Conns.unwalk then Conns.unwalk:Disconnect(); Conns.unwalk=nil end; _unwalkAnimations={}
    if State.unwalkEnabled then task.wait(0.3); startUnwalk() end
    stopAntiRagdoll(); if State.antiRagdollEnabled then task.wait(0.5); startAntiRagdoll() end
    if State.medusaCounterEnabled then setupMedusaCounter(char) end
    if State.batAimbotToggled then stopBatAimbot(); task.wait(0.2); pcall(startBatAimbot) end
    if State.batCounterEnabled then task.wait(0.3); startBatCounter() end
    if State.infJumpEnabled then stopInfiniteJump(); task.wait(0.1); startInfiniteJump() end
    task.spawn(function()
        task.wait(0.6)
        for p2 in pairs(espBillboards) do espRemoveFor(p2) end; espBillboards={}; espRemConns={}
        for _,p2 in ipairs(Players:GetPlayers()) do if p2~=LP and p2.Character then espAttach(p2,p2.Character) end end
    end)
end
LP.CharacterAdded:Connect(setupChar)
if LP.Character then task.spawn(function() setupChar(LP.Character) end) end

RunService.Stepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            for _,part in ipairs(p.Character:GetChildren()) do
                if part:IsA("BasePart") then part.CanCollide=false end
            end
        end
    end
end)

local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}

RunService.RenderStepped:Connect(function()
    if not (h and hrp) then return end
    if not State.batAimbotToggled and not State.autoLeftEnabled and not State.autoRightEnabled then
        local md=h.MoveDirection
        local spd
        if State.laggerMode==1 then spd=State.laggerSpeed
        elseif State.laggerMode==2 then spd=State.lagCarrySpeed
        elseif State.speedToggled then spd=State.carrySpeed
        else spd=State.normalSpeed end
        if md.Magnitude>0 then
            State.lastMoveDir=md
            hrp.Velocity=Vector3.new(md.X*spd,hrp.Velocity.Y,md.Z*spd)
        elseif State.antiRagdollEnabled and State.lastMoveDir.Magnitude>0 then
            local anyHeld=false
            for key in pairs(MOVE_KEYS) do if UIS:IsKeyDown(key) then anyHeld=true; break end end
            if anyHeld then hrp.Velocity=Vector3.new(State.lastMoveDir.X*spd,hrp.Velocity.Y,State.lastMoveDir.Z*spd) end
        end
    end
    for _,ref in ipairs(statsRefs) do if ref and ref.label and ref.getter then ref.label.Text=tostring(ref.getter()) end end
end)

-- KEYBINDS
UIS.InputBegan:Connect(function(inp,gp)
    if gp then return end
    local t=inp.UserInputType
    local isKb=t==Enum.UserInputType.Keyboard
    local isGP=t==Enum.UserInputType.Gamepad1 or t==Enum.UserInputType.Gamepad2
    if not isKb and not isGP then return end
    local kc=inp.KeyCode; if kc==Enum.KeyCode.Unknown then return end

    if Keys.speed~=Enum.KeyCode.Unknown and kc==Keys.speed then
        State.speedToggled=not State.speedToggled
        if toggleRefs.carryMode then toggleRefs.carryMode(State.speedToggled) end
        if setCS then setCS(State.speedToggled) end
    elseif Keys.lagger~=Enum.KeyCode.Unknown and kc==Keys.lagger then
        advanceLaggerMode()
        local modeNames={"Lagger Mode","Lagger Speed","Lag Carry"}
        local modeColors={C.textDim,Color3.fromRGB(255,200,80),Color3.fromRGB(120,200,255)}
        if laggerModeBtn then laggerModeBtn.Text=modeNames[State.laggerMode+1]; laggerModeBtn.TextColor3=modeColors[State.laggerMode+1] end
        TweenService:Create(lagFrame,TweenInfo.new(0.15),{BackgroundColor3=LAGGER_MODE_COLORS[State.laggerMode]}):Play()
    elseif Keys.autoLeft~=Enum.KeyCode.Unknown and kc==Keys.autoLeft then
        State.autoLeftEnabled=not State.autoLeftEnabled
        if toggleRefs.autoLeft then toggleRefs.autoLeft(State.autoLeftEnabled) end
        if setAL then setAL(State.autoLeftEnabled) end
        if State.autoLeftEnabled and State.batAimbotToggled then State.batAimbotToggled=false; stopBatAimbot(); if setAB then setAB(false) end; if toggleRefs.aimbot then toggleRefs.aimbot(false) end end
        if State.autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
    elseif Keys.autoRight~=Enum.KeyCode.Unknown and kc==Keys.autoRight then
        State.autoRightEnabled=not State.autoRightEnabled
        if toggleRefs.autoRight then toggleRefs.autoRight(State.autoRightEnabled) end
        if setAR then setAR(State.autoRightEnabled) end
        if State.autoRightEnabled and State.batAimbotToggled then State.batAimbotToggled=false; stopBatAimbot(); if setAB then setAB(false) end; if toggleRefs.aimbot then toggleRefs.aimbot(false) end end
        if State.autoRightEnabled then startAutoRight() else stopAutoRight() end
    elseif Keys.drop~=Enum.KeyCode.Unknown and kc==Keys.drop then
        if not State.dropEnabled then runDropBrainrot() end
    elseif Keys.tpDown~=Enum.KeyCode.Unknown and kc==Keys.tpDown then
        doTpDown()
    elseif Keys.aimbot~=Enum.KeyCode.Unknown and kc==Keys.aimbot then
        State.batAimbotToggled=not State.batAimbotToggled
        if toggleRefs.aimbot then toggleRefs.aimbot(State.batAimbotToggled) end
        if setAB then setAB(State.batAimbotToggled) end
        if State.batAimbotToggled then
            if State.autoLeftEnabled then State.autoLeftEnabled=false; stopAutoLeft(); if setAL then setAL(false) end end
            if State.autoRightEnabled then State.autoRightEnabled=false; stopAutoRight(); if setAR then setAR(false) end end
            pcall(startBatAimbot)
        else stopBatAimbot() end
    elseif Keys.autoSteal~=Enum.KeyCode.Unknown and kc==Keys.autoSteal then
        Steal.AutoStealEnabled=not Steal.AutoStealEnabled; State.autoStealEnabled=Steal.AutoStealEnabled
        if toggleRefs.autoSteal then toggleRefs.autoSteal(Steal.AutoStealEnabled) end
        if Steal.AutoStealEnabled then
            if not pcall(startAutoSteal) then Steal.AutoStealEnabled=false; State.autoStealEnabled=false; if toggleRefs.autoSteal then toggleRefs.autoSteal(false) end end
        else stopAutoSteal() end
    end
end)

-- ============================================================
-- STARTUP
-- ============================================================
loadConfigsFile()
applySavedPosition(mainOuter,"mainOuter")
applySavedPosition(reopenBtn,"mainReopen")
applySavedPosition(mbGroup,"mobilePanel")
if progressGui then applySavedPosition(progressGui,"autoStealBar") end
rebuildConfigList()

do
    local last=loadLastConfigName()
    if last and last~="" then
        for _,cfg in ipairs(Configs) do
            if cfg.name==last and cfg.data then
                activeConfigName=cfg.name
                if cfg.data.normalSpeed then State.normalSpeed=cfg.data.normalSpeed end
                if cfg.data.carrySpeed then State.carrySpeed=cfg.data.carrySpeed end
                if cfg.data.laggerSpeed then State.laggerSpeed=cfg.data.laggerSpeed end
                if cfg.data.lagCarrySpeed then State.lagCarrySpeed=cfg.data.lagCarrySpeed end
                break
            end
        end
    end
end

-- Update speed boxes
if speedBoxRefs.normalSpeed then speedBoxRefs.normalSpeed.Text=tostring(State.normalSpeed) end
if speedBoxRefs.carrySpeed then speedBoxRefs.carrySpeed.Text=tostring(State.carrySpeed) end
if speedBoxRefs.laggerSpeed then speedBoxRefs.laggerSpeed.Text=tostring(State.laggerSpeed) end
if lagCarrySpeedBox then lagCarrySpeedBox.Text=tostring(State.lagCarrySpeed) end
if stealRadiusBox then stealRadiusBox.Text=tostring(Steal.StealRadius) end
if radValLbl then radValLbl.Text=tostring(Steal.StealRadius) end

task.spawn(function() task.wait(1); initOthersSpeedESP() end)

showPage("AUTO")

-- Animate in
mainOuter.Size=UDim2.new(0,0,0,0); mainOuter.Visible=true; reopenBtn.Visible=false
TweenService:Create(mainOuter,TweenInfo.new(0.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
    Size=UDim2.new(0,WIN_W,0,WIN_H)
}):Play()

-- Auto-save loop
task.spawn(function() while task.wait(10) do pcall(syncActiveConfigSnapshot) end end)

print("[Amir Hub | Phantom Duels V5.4] Loaded! 3 draggable GUIs active.")