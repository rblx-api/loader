--[[
  KYRON CLEAN — built from scratch
  Only UI + features that have menu / mobile buttons.
  No dead code, no CoreGui hijack, settings persist with writefile/readfile.
]]

if _G._KYRONCleanRunning then
  warn("[KYRON] Already running. Rejoin before loading again.")
  return
end
_G._KYRONCleanRunning = true

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

local IS_MOBILE = UIS.TouchEnabled and not UIS.KeyboardEnabled

----------------------------------------------------------------
-- CoreGui: never hide chat / leave / topbar
----------------------------------------------------------------
local function ensureCoreGui()
  for _, t in ipairs({
    Enum.CoreGuiType.Chat,
    Enum.CoreGuiType.PlayerList,
    Enum.CoreGuiType.Backpack,
    Enum.CoreGuiType.EmotesMenu,
    Enum.CoreGuiType.Health,
  }) do
    pcall(function()
      StarterGui:SetCoreGuiEnabled(t, true)
    end)
  end
  pcall(function()
    StarterGui:SetCore("TopbarEnabled", true)
  end)
  pcall(function()
    StarterGui:SetCore("ResetButtonCallback", true)
  end)
end
ensureCoreGui()
task.spawn(function()
  for _ = 1, 15 do
    task.wait(1)
    ensureCoreGui()
  end
  while _G._KYRONCleanRunning do
    task.wait(5)
    ensureCoreGui()
  end
end)

----------------------------------------------------------------
-- State
----------------------------------------------------------------
local S = {
  -- Speed
  NS = 60,
  CS = 28,
  LG_N = 34,
  LG_C = 20,
  family = "normal", -- normal | lagger
  carry = false,
  autoCarry = false,
  autoCarryMode = "WHEN NEAR", -- ON STEAL | WHEN NEAR
  autoCarrySpeed = false,
  autoCarryEnemyBase = false,
  enemyBaseRange = 35,

  -- Movement
  autoTP = false,
  autoTPHeight = 10,
  infJump = true,
  antiRagdoll = true,
  bodylock = false,
  bodylockRadius = 24,

  -- Combat
  autoSteal = true,
  stealMode = "NORMAL", -- NORMAL | SEMI
  stealRadius = 60,
  semiRange = 8.7,
  pausePercent = 75,
  ragdollSteal = true,
  batAimbot = false,
  batMode = "DEFAULT", -- DEFAULT | BYPASS
  aimSpd = 58,
  autoSwing = false,
  mirrorTP = false,
  tpBat = false,
  tpBatMode = "HIGH PING", -- LOW PING | HIGH PING
  autoLeft = false,
  autoRight = false,
  matchSpeed = false,
  batCounter = true,
  batCounterMode = "V1",
  medusaCounter = false,
  hardHit = false,
  hardHitRange = 10,
  perfectHit = false,
  perfectHitRange = 175,

  -- Visual
  esp = false,
  showTracer = true,
  antiTpEsp = false,
  antiLag = true,
  potato = false,
  fov = false,
  fovVal = 120,
  stretch = false,
  fontMode = "DEFAULT", -- DEFAULT | PIXEL
  skyMode = "Off",
  animPack = "Off",

  -- Settings
  safeMode = IS_MOBILE,
  kickWarning = true,
  intro = false,
  themeIdx = 1,
  uiScale = IS_MOBILE and 70 or 100,
  stealBarScale = 70,
  circleButtons = false,
  advancedLagger = true,
  mobileBtnScale = 1,
  bgColorMatch = false,
  stealBarMatch = false,

  -- Positions / binds
  mainPos = nil,
  floatPos = nil,
  stealBarPos = nil,
  mobilePos = {},
  keys = {
    ["Speed Key"] = "Q",
    ["Lagger Mode Key"] = "R",
    ["Drop Key"] = "X",
    ["TP Down Key"] = "F",
    ["Insta Reset Key"] = "G",
    ["Bat Aimbot Key"] = "E",
    ["TP Bat Key"] = "V",
    ["Auto Left Key"] = "Z",
    ["Auto Right Key"] = "C",
    ["UI Toggle Key"] = "N",
  },
}

local THEMES = {
  { name = "PURPLE", accent = Color3.fromRGB(150, 101, 255), dark = Color3.fromRGB(104, 55, 210) },
  { name = "BLUE",   accent = Color3.fromRGB(58, 128, 245),  dark = Color3.fromRGB(30, 82, 170) },
  { name = "RED",    accent = Color3.fromRGB(230, 42, 57),   dark = Color3.fromRGB(155, 24, 40) },
  { name = "PINK",   accent = Color3.fromRGB(255, 105, 180), dark = Color3.fromRGB(190, 65, 145) },
  { name = "YELLOW", accent = Color3.fromRGB(255, 214, 0),   dark = Color3.fromRGB(200, 160, 0) },
  { name = "GREY",   accent = Color3.fromRGB(120, 120, 128), dark = Color3.fromRGB(70, 70, 78) },
  { name = "WHITE",  accent = Color3.fromRGB(255, 255, 255), dark = Color3.fromRGB(200, 210, 210) },
  { name = "FOREST", accent = Color3.fromRGB(46, 139, 87),   dark = Color3.fromRGB(34, 70, 45) },
}

local function accent()
  return THEMES[S.themeIdx] and THEMES[S.themeIdx].accent or THEMES[1].accent
end

----------------------------------------------------------------
-- Save / Load
----------------------------------------------------------------
local SAVE_FILE = "KYRON_Clean_" .. tostring(LP.UserId) .. ".json"
local canSave = typeof(writefile) == "function" and typeof(readfile) == "function"

local function saveSettings()
  if not canSave then
    return false, "no file api"
  end
  local ok, err = pcall(function()
    writefile(SAVE_FILE, HttpService:JSONEncode(S))
  end)
  return ok, err
end

local function loadSettings()
  if not canSave then
    return
  end
  if typeof(isfile) == "function" and not isfile(SAVE_FILE) then
    return
  end
  local ok, data = pcall(function()
    return HttpService:JSONDecode(readfile(SAVE_FILE))
  end)
  if ok and type(data) == "table" then
    for k, v in pairs(data) do
      if S[k] ~= nil then
        S[k] = v
      end
    end
  end
end
loadSettings()

----------------------------------------------------------------
-- Helpers
----------------------------------------------------------------
local function char()
  return LP.Character
end
local function hum()
  local c = char()
  return c and c:FindFirstChildOfClass("Humanoid")
end
local function root()
  local c = char()
  return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso"))
end

local function getSpeed()
  if S.family == "lagger" then
    return S.carry and S.LG_N or S.LG_C
  end
  return S.carry and S.CS or S.NS
end

local conns = {}
local function track(c)
  conns[#conns + 1] = c
  return c
end

----------------------------------------------------------------
-- Feature runners
----------------------------------------------------------------
-- WalkSpeed
track(RunService.Heartbeat:Connect(function()
  local h = hum()
  if h then
    h.WalkSpeed = getSpeed()
  end
end))

-- Infinite Jump
track(UIS.JumpRequest:Connect(function()
  if not S.infJump then
    return
  end
  local h = hum()
  if h then
    h:ChangeState(Enum.HumanoidStateType.Jumping)
  end
end))

-- Anti Ragdoll
track(RunService.Heartbeat:Connect(function()
  if not S.antiRagdoll then
    return
  end
  local h = hum()
  if not h then
    return
  end
  local st = h:GetState()
  if st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown or h.PlatformStand then
    h.PlatformStand = false
    h:ChangeState(Enum.HumanoidStateType.GettingUp)
  end
end))

-- Auto TP Down
local autoTPThread = nil
local function syncAutoTP()
  if autoTPThread then
    task.cancel(autoTPThread)
    autoTPThread = nil
  end
  if not S.autoTP then
    return
  end
  autoTPThread = task.spawn(function()
    while S.autoTP do
      local r = root()
      if r then
        r.CFrame = r.CFrame + Vector3.new(0, -S.autoTPHeight, 0)
      end
      task.wait(0.35)
    end
  end)
end

-- Bodylock (face nearest enemy)
track(RunService.RenderStepped:Connect(function()
  if not S.bodylock then
    return
  end
  local r = root()
  local h = hum()
  if not r or not h then
    return
  end
  local nearest, dist = nil, S.bodylockRadius
  for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LP and p.Character then
      local tr = p.Character:FindFirstChild("HumanoidRootPart")
      local th = p.Character:FindFirstChildOfClass("Humanoid")
      if tr and th and th.Health > 0 then
        local d = (tr.Position - r.Position).Magnitude
        if d < dist then
          dist = d
          nearest = tr
        end
      end
    end
  end
  if nearest then
    h.AutoRotate = false
    local look = Vector3.new(nearest.Position.X, r.Position.Y, nearest.Position.Z)
    r.CFrame = CFrame.lookAt(r.Position, look)
  else
    h.AutoRotate = true
  end
end))

-- FOV
track(RunService.RenderStepped:Connect(function()
  if S.fov and Camera then
    Camera.FieldOfView = S.fovVal
  end
end))

-- Perfect Hit (nearest target auto-activate tool)
local phCd = false
track(RunService.Heartbeat:Connect(function()
  if not S.perfectHit or phCd then
    return
  end
  local r = root()
  local c = char()
  if not r or not c then
    return
  end
  local tool = c:FindFirstChildOfClass("Tool")
  if not tool then
    return
  end
  local nearest, dist = nil, S.perfectHitRange
  for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LP and p.Character then
      local tr = p.Character:FindFirstChild("HumanoidRootPart")
      local th = p.Character:FindFirstChildOfClass("Humanoid")
      if tr and th and th.Health > 0 then
        local d = (tr.Position - r.Position).Magnitude
        if d < dist then
          dist = d
          nearest = true
        end
      end
    end
  end
  if nearest then
    phCd = true
    pcall(function()
      tool:Activate()
    end)
    task.delay(0.045, function()
      phCd = false
    end)
  end
end))

-- Simple Auto Steal (ProximityPrompt "Steal" in range)
local stealBusy = false
track(RunService.Heartbeat:Connect(function()
  if not S.autoSteal or stealBusy then
    return
  end
  local r = root()
  if not r then
    return
  end
  local plots = workspace:FindFirstChild("Plots")
  if not plots then
    return
  end
  local best, bestPrompt, bestDist = nil, nil, S.stealRadius
  for _, plot in ipairs(plots:GetChildren()) do
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if podiums then
      for _, slot in ipairs(podiums:GetChildren()) do
        local base = slot:FindFirstChild("Base")
        local spawn = base and base:FindFirstChild("Spawn")
        if spawn then
          local d = (spawn.Position - r.Position).Magnitude
          if d < bestDist then
            for _, desc in ipairs(spawn:GetDescendants()) do
              if desc:IsA("ProximityPrompt") and tostring(desc.ActionText):lower():find("steal") then
                bestDist = d
                best = slot
                bestPrompt = desc
                break
              end
            end
          end
        end
      end
    end
  end
  if bestPrompt and bestDist <= (S.stealMode == "SEMI" and S.semiRange or S.stealRadius) then
    stealBusy = true
    task.spawn(function()
      pcall(function()
        bestPrompt.HoldDuration = 0
        if fireproximityprompt then
          fireproximityprompt(bestPrompt)
        else
          bestPrompt:InputHoldBegin()
          task.wait(0.05)
          bestPrompt:InputHoldEnd()
        end
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("StealAnimal")
        if remote and best then
          remote:FireServer(best.Name)
        end
      end)
      task.wait(0.15)
      stealBusy = false
    end)
  end
end))

-- Insta Reset
local function instaReset()
  local c = char()
  local h = hum()
  local r = root()
  if not c or not h then
    return
  end
  pcall(function()
    h.Health = 0
    h:ChangeState(Enum.HumanoidStateType.Dead)
    c:BreakJoints()
  end)
  if r then
    pcall(function()
      r.AssemblyLinearVelocity = Vector3.new(0, -500, 0)
    end)
  end
end

-- Drop (unequip tools)
local function dropBrainrot()
  local c = char()
  local h = hum()
  if h then
    h:UnequipTools()
  end
end

-- TP Down once
local function tpDown()
  local r = root()
  if r then
    r.CFrame = r.CFrame + Vector3.new(0, -S.autoTPHeight, 0)
  end
end

----------------------------------------------------------------
-- UI BUILD
----------------------------------------------------------------
local old = PlayerGui:FindFirstChild("KYRONCleanHub")
if old then
  old:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "KYRONCleanHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 5
pcall(function()
  gui.ClipToDeviceSafeArea = true
end)
gui.Parent = PlayerGui

local function corner(p, r)
  local c = Instance.new("UICorner")
  c.CornerRadius = UDim.new(0, r or 8)
  c.Parent = p
  return c
end
local function stroke(p, col, th)
  local s = Instance.new("UIStroke")
  s.Color = col or Color3.fromRGB(70, 70, 80)
  s.Thickness = th or 1
  s.Transparency = 0.35
  s.Parent = p
  return s
end

-- Main panel
local main = Instance.new("Frame")
main.Name = "Main"
main.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
main.BackgroundTransparency = 0.05
main.BorderSizePixel = 0
main.Size = UDim2.fromOffset(460, 560)
main.AnchorPoint = Vector2.new(0, 0.5)
main.Position = S.mainPos and UDim2.new(S.mainPos.xs, S.mainPos.xo or 0, S.mainPos.ys, S.mainPos.yo or 0)
  or UDim2.new(0, 20, 0.5, 0)
main.Visible = false
main.ClipsDescendants = true
main.Parent = gui
corner(main, 14)
stroke(main, accent(), 1.2)

local uiScale = Instance.new("UIScale", main)
uiScale.Scale = (S.uiScale or 100) / 100

-- Drag main
do
  local dragging, startPos, startInput
  main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
      dragging = true
      startPos = main.Position
      startInput = input.Position
    end
  end)
  UIS.InputEnded:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
      dragging = false
      S.mainPos = {
        xs = main.Position.X.Scale,
        xo = main.Position.X.Offset,
        ys = main.Position.Y.Scale,
        yo = main.Position.Y.Offset,
      }
    end
  end)
  UIS.InputChanged:Connect(function(input)
    if not dragging then
      return
    end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
      local d = input.Position - startInput
      main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
  end)
end

-- Top bar
local top = Instance.new("Frame")
top.BackgroundTransparency = 1
top.Size = UDim2.new(1, 0, 0, 48)
top.Parent = main

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Text = "KYRON"
title.Font = Enum.Font.GothamBlack
title.TextSize = 18
title.TextColor3 = accent()
title.TextXAlignment = Enum.TextXAlignment.Left
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.fromOffset(16, 0)
title.Parent = top

local closeBtn = Instance.new("TextButton")
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 22
closeBtn.TextColor3 = Color3.fromRGB(230, 230, 235)
closeBtn.BackgroundTransparency = 1
closeBtn.Size = UDim2.fromOffset(40, 40)
closeBtn.Position = UDim2.new(1, -44, 0, 4)
closeBtn.Parent = top

-- Side tabs + content
local side = Instance.new("ScrollingFrame")
side.BackgroundTransparency = 1
side.BorderSizePixel = 0
side.ScrollBarThickness = 0
side.Size = UDim2.new(0, 110, 1, -56)
side.Position = UDim2.fromOffset(6, 50)
side.CanvasSize = UDim2.new(0, 0, 0, 0)
side.AutomaticCanvasSize = Enum.AutomaticSize.Y
side.Parent = main
local sideList = Instance.new("UIListLayout", side)
sideList.Padding = UDim.new(0, 6)
sideList.SortOrder = Enum.SortOrder.LayoutOrder

local contentHost = Instance.new("Frame")
contentHost.BackgroundTransparency = 1
contentHost.Size = UDim2.new(1, -130, 1, -60)
contentHost.Position = UDim2.fromOffset(122, 52)
contentHost.Parent = main

local tabs = {}
local pages = {}
local currentTab = nil

local TAB_ORDER = { "SPEED", "MOVEMENT", "COMBAT", "VISUAL", "SETTINGS", "KEYBINDS", "CONTROL" }

local function makePage(name)
  local page = Instance.new("ScrollingFrame")
  page.Name = name
  page.BackgroundTransparency = 1
  page.BorderSizePixel = 0
  page.ScrollBarThickness = 3
  page.ScrollBarImageColor3 = accent()
  page.Size = UDim2.fromScale(1, 1)
  page.CanvasSize = UDim2.new(0, 0, 0, 0)
  page.AutomaticCanvasSize = Enum.AutomaticSize.Y
  page.Visible = false
  page.Parent = contentHost
  local list = Instance.new("UIListLayout", page)
  list.Padding = UDim.new(0, 7)
  list.SortOrder = Enum.SortOrder.LayoutOrder
  pages[name] = page
  return page
end

local function selectTab(name)
  currentTab = name
  for n, p in pairs(pages) do
    p.Visible = n == name
  end
  for n, b in pairs(tabs) do
    b.TextColor3 = n == name and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 170)
    b.BackgroundColor3 = n == name and Color3.fromRGB(28, 28, 36) or Color3.fromRGB(18, 18, 24)
  end
end

for i, name in ipairs(TAB_ORDER) do
  makePage(name)
  local b = Instance.new("TextButton")
  b.Name = name
  b.LayoutOrder = i
  b.Size = UDim2.new(1, -4, 0, 40)
  b.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
  b.Text = name
  b.Font = Enum.Font.GothamBold
  b.TextSize = 12
  b.TextColor3 = Color3.fromRGB(160, 160, 170)
  b.AutoButtonColor = false
  b.Parent = side
  corner(b, 8)
  stroke(b)
  b.Activated:Connect(function()
    selectTab(name)
  end)
  tabs[name] = b
end

local function section(page, text)
  local l = Instance.new("TextLabel")
  l.BackgroundTransparency = 1
  l.Size = UDim2.new(1, -6, 0, 22)
  l.Font = Enum.Font.GothamBlack
  l.TextSize = 11
  l.TextColor3 = Color3.fromRGB(200, 200, 210)
  l.TextXAlignment = Enum.TextXAlignment.Left
  l.Text = string.upper(text)
  l.Parent = page
  return l
end

local function row(page, name)
  local f = Instance.new("Frame")
  f.Name = name
  f.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
  f.BackgroundTransparency = 0.15
  f.Size = UDim2.new(1, -4, 0, 34)
  f.Parent = page
  corner(f, 8)
  stroke(f)
  local label = Instance.new("TextLabel")
  label.BackgroundTransparency = 1
  label.Text = name
  label.Font = Enum.Font.GothamMedium
  label.TextSize = 13
  label.TextColor3 = Color3.fromRGB(235, 235, 240)
  label.TextXAlignment = Enum.TextXAlignment.Left
  label.Size = UDim2.new(1, -90, 1, 0)
  label.Position = UDim2.fromOffset(12, 0)
  label.Parent = f
  return f, label
end

local toggles = {} -- name -> {set, get, btn}

local function addToggle(page, name, get, set)
  local f = row(page, name)
  local btn = Instance.new("TextButton")
  btn.Size = UDim2.fromOffset(52, 24)
  btn.Position = UDim2.new(1, -62, 0.5, -12)
  btn.Font = Enum.Font.GothamBold
  btn.TextSize = 11
  btn.AutoButtonColor = false
  btn.Parent = f
  corner(btn, 12)

  local function paint()
    local on = get()
    btn.Text = on and "ON" or "OFF"
    btn.BackgroundColor3 = on and accent() or Color3.fromRGB(40, 40, 48)
    btn.TextColor3 = on and Color3.fromRGB(15, 15, 20) or Color3.fromRGB(200, 200, 210)
  end
  paint()
  btn.Activated:Connect(function()
    set(not get())
    paint()
  end)
  toggles[name] = { set = set, get = get, paint = paint }
  return f
end

local function addValue(page, name, get, set, minV, maxV)
  local f = row(page, name)
  local box = Instance.new("TextBox")
  box.Size = UDim2.fromOffset(64, 24)
  box.Position = UDim2.new(1, -74, 0.5, -12)
  box.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
  box.TextColor3 = Color3.fromRGB(240, 240, 245)
  box.Font = Enum.Font.GothamBold
  box.TextSize = 12
  box.Text = tostring(get())
  box.ClearTextOnFocus = false
  box.Parent = f
  corner(box, 6)
  box.FocusLost:Connect(function()
    local n = tonumber(box.Text)
    if n then
      if minV then
        n = math.max(minV, n)
      end
      if maxV then
        n = math.min(maxV, n)
      end
      set(n)
      box.Text = tostring(n)
    else
      box.Text = tostring(get())
    end
  end)
  return f, box
end

local function addMode(page, name, leftLabel, rightLabel, getIsRight, setLeft, setRight)
  local f = row(page, name)
  local left = Instance.new("TextButton")
  left.Size = UDim2.fromOffset(56, 22)
  left.Position = UDim2.new(1, -120, 0.5, -11)
  left.Font = Enum.Font.GothamBold
  left.TextSize = 10
  left.Text = leftLabel
  left.AutoButtonColor = false
  left.Parent = f
  corner(left, 6)
  local right = Instance.new("TextButton")
  right.Size = UDim2.fromOffset(56, 22)
  right.Position = UDim2.new(1, -60, 0.5, -11)
  right.Font = Enum.Font.GothamBold
  right.TextSize = 10
  right.Text = rightLabel
  right.AutoButtonColor = false
  right.Parent = f
  corner(right, 6)
  local function paint()
    local r = getIsRight()
    left.BackgroundColor3 = (not r) and accent() or Color3.fromRGB(36, 36, 44)
    right.BackgroundColor3 = r and accent() or Color3.fromRGB(36, 36, 44)
    left.TextColor3 = (not r) and Color3.fromRGB(15, 15, 20) or Color3.fromRGB(210, 210, 220)
    right.TextColor3 = r and Color3.fromRGB(15, 15, 20) or Color3.fromRGB(210, 210, 220)
  end
  paint()
  left.Activated:Connect(function()
    setLeft()
    paint()
  end)
  right.Activated:Connect(function()
    setRight()
    paint()
  end)
  return f
end

local function addButton(page, name, cb)
  local f = row(page, name)
  local btn = Instance.new("TextButton")
  btn.Size = UDim2.fromOffset(72, 24)
  btn.Position = UDim2.new(1, -82, 0.5, -12)
  btn.BackgroundColor3 = accent()
  btn.TextColor3 = Color3.fromRGB(15, 15, 20)
  btn.Font = Enum.Font.GothamBold
  btn.TextSize = 11
  btn.Text = "RUN"
  btn.AutoButtonColor = false
  btn.Parent = f
  corner(btn, 8)
  btn.Activated:Connect(function()
    pcall(cb)
  end)
  return f
end

----------------------------------------------------------------
-- SPEED
----------------------------------------------------------------
do
  local p = pages.SPEED
  section(p, "Speed Configuration")
  addValue(p, "Normal Speed", function()
    return S.NS
  end, function(v)
    S.NS = v
  end, 0, 500)
  addValue(p, "Carry Speed", function()
    return S.CS
  end, function(v)
    S.CS = v
  end, 0, 500)
  addMode(p, "Speed Mode", "NORMAL", "CARRY", function()
    return S.family == "normal" and S.carry
  end, function()
    S.family = "normal"
    S.carry = false
  end, function()
    S.family = "normal"
    S.carry = true
  end)
  addValue(p, "Lagger Normal Speed", function()
    return S.LG_C
  end, function(v)
    S.LG_C = v
  end, 0, 200)
  addValue(p, "Lagger Carry Speed", function()
    return S.LG_N
  end, function(v)
    S.LG_N = v
  end, 0, 200)
  addMode(p, "Lagger Mode", "LAG NORM", "LAG CARRY", function()
    return S.family == "lagger" and S.carry
  end, function()
    S.family = "lagger"
    S.carry = false
  end, function()
    S.family = "lagger"
    S.carry = true
  end)
  section(p, "Auto Carry")
  addToggle(p, "Auto Carry", function()
    return S.autoCarry
  end, function(v)
    S.autoCarry = v
  end)
  addMode(p, "Auto Carry Mode", "ON STEAL", "NEAR", function()
    return S.autoCarryMode == "WHEN NEAR"
  end, function()
    S.autoCarryMode = "ON STEAL"
  end, function()
    S.autoCarryMode = "WHEN NEAR"
  end)
  addToggle(p, "Auto Carry Speed", function()
    return S.autoCarrySpeed
  end, function(v)
    S.autoCarrySpeed = v
  end)
  addToggle(p, "Auto Carry Enemy Base", function()
    return S.autoCarryEnemyBase
  end, function(v)
    S.autoCarryEnemyBase = v
  end)
  addValue(p, "Enemy Base Range", function()
    return S.enemyBaseRange
  end, function(v)
    S.enemyBaseRange = v
  end, 5, 150)
end

----------------------------------------------------------------
-- MOVEMENT
----------------------------------------------------------------
do
  local p = pages.MOVEMENT
  section(p, "TP Down")
  addButton(p, "TP Down", tpDown)
  addToggle(p, "Auto TP Down", function()
    return S.autoTP
  end, function(v)
    S.autoTP = v
    syncAutoTP()
  end)
  addValue(p, "Auto TP Height", function()
    return S.autoTPHeight
  end, function(v)
    S.autoTPHeight = v
  end, 1, 2000)
  section(p, "Jump")
  addToggle(p, "Infinite Jump", function()
    return S.infJump
  end, function(v)
    S.infJump = v
  end)
  addToggle(p, "Anti Ragdoll", function()
    return S.antiRagdoll
  end, function(v)
    S.antiRagdoll = v
  end)
  section(p, "Bodylock")
  addToggle(p, "Bodylock", function()
    return S.bodylock
  end, function(v)
    S.bodylock = v
    local h = hum()
    if h and not v then
      h.AutoRotate = true
    end
  end)
  addValue(p, "Bodylock Radius", function()
    return S.bodylockRadius
  end, function(v)
    S.bodylockRadius = v
  end, 1, 210)
end

----------------------------------------------------------------
-- COMBAT
----------------------------------------------------------------
do
  local p = pages.COMBAT
  section(p, "Steal")
  addToggle(p, "Auto Steal", function()
    return S.autoSteal
  end, function(v)
    S.autoSteal = v
  end)
  addMode(p, "Steal Mode", "NORMAL", "SEMI", function()
    return S.stealMode == "SEMI"
  end, function()
    S.stealMode = "NORMAL"
  end, function()
    S.stealMode = "SEMI"
  end)
  addValue(p, "Radius", function()
    return S.stealRadius
  end, function(v)
    S.stealRadius = v
  end, 1, 250)
  addValue(p, "SEMI Range", function()
    return S.semiRange
  end, function(v)
    S.semiRange = v
  end, 1, 100)
  addToggle(p, "Ragdoll Steal", function()
    return S.ragdollSteal
  end, function(v)
    S.ragdollSteal = v
  end)
  section(p, "Bat")
  addToggle(p, "Bat Aimbot", function()
    return S.batAimbot
  end, function(v)
    S.batAimbot = v
  end)
  addMode(p, "Bat Aimbot Mode", "DEFAULT", "BYPASS", function()
    return S.batMode == "BYPASS"
  end, function()
    S.batMode = "DEFAULT"
  end, function()
    S.batMode = "BYPASS"
  end)
  addValue(p, "Auto Bat Speed", function()
    return S.aimSpd
  end, function(v)
    S.aimSpd = v
  end, 1, 200)
  addToggle(p, "Auto Swing", function()
    return S.autoSwing
  end, function(v)
    S.autoSwing = v
  end)
  addToggle(p, "Mirror TP", function()
    return S.mirrorTP
  end, function(v)
    S.mirrorTP = v
  end)
  addToggle(p, "TP Bat", function()
    return S.tpBat
  end, function(v)
    S.tpBat = v
  end)
  addMode(p, "TP Bat Mode", "LOW PING", "HIGH PING", function()
    return S.tpBatMode == "HIGH PING"
  end, function()
    S.tpBatMode = "LOW PING"
  end, function()
    S.tpBatMode = "HIGH PING"
  end)
  addToggle(p, "Auto Left", function()
    return S.autoLeft
  end, function(v)
    S.autoLeft = v
  end)
  addToggle(p, "Auto Right", function()
    return S.autoRight
  end, function(v)
    S.autoRight = v
  end)
  addToggle(p, "Match Speed", function()
    return S.matchSpeed
  end, function(v)
    S.matchSpeed = v
  end)
  addToggle(p, "Bat Counter", function()
    return S.batCounter
  end, function(v)
    S.batCounter = v
  end)
  addToggle(p, "Medusa Counter", function()
    return S.medusaCounter
  end, function(v)
    S.medusaCounter = v
  end)
  addToggle(p, "Hard Hit", function()
    return S.hardHit
  end, function(v)
    S.hardHit = v
  end)
  addValue(p, "Hard Hit Range", function()
    return S.hardHitRange
  end, function(v)
    S.hardHitRange = v
  end, 1, 100)
  addToggle(p, "Perfect Hit", function()
    return S.perfectHit
  end, function(v)
    S.perfectHit = v
  end)
  addValue(p, "Perfect Hit Range", function()
    return S.perfectHitRange
  end, function(v)
    S.perfectHitRange = v
  end, 10, 500)
end

----------------------------------------------------------------
-- VISUAL
----------------------------------------------------------------
do
  local p = pages.VISUAL
  section(p, "Players")
  addToggle(p, "ESP", function()
    return S.esp
  end, function(v)
    S.esp = v
  end)
  addToggle(p, "Show Tracer", function()
    return S.showTracer
  end, function(v)
    S.showTracer = v
  end)
  addToggle(p, "Anti TP ESP", function()
    return S.antiTpEsp
  end, function(v)
    S.antiTpEsp = v
  end)
  section(p, "Graphics")
  addToggle(p, "Anti-Lag", function()
    return S.antiLag
  end, function(v)
    S.antiLag = v
  end)
  addToggle(p, "Potato Graphics", function()
    return S.potato
  end, function(v)
    S.potato = v
    if v then
      pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e9
      end)
    end
  end)
  addToggle(p, "FOV Change", function()
    return S.fov
  end, function(v)
    S.fov = v
    if not v and Camera then
      Camera.FieldOfView = 70
    end
  end)
  addValue(p, "FOV Value", function()
    return S.fovVal
  end, function(v)
    S.fovVal = v
  end, 1, 120)
  addToggle(p, "Stretch Res", function()
    return S.stretch
  end, function(v)
    S.stretch = v
  end)
  addMode(p, "Font", "DEFAULT", "PIXEL", function()
    return S.fontMode == "PIXEL"
  end, function()
    S.fontMode = "DEFAULT"
  end, function()
    S.fontMode = "PIXEL"
  end)
end

----------------------------------------------------------------
-- SETTINGS
----------------------------------------------------------------
do
  local p = pages.SETTINGS
  section(p, "Safety")
  addToggle(p, "Safe Mode", function()
    return S.safeMode
  end, function(v)
    S.safeMode = v
  end)
  addToggle(p, "Kick Warning", function()
    return S.kickWarning
  end, function(v)
    S.kickWarning = v
  end)
  section(p, "Interface")
  addValue(p, "UI Scale", function()
    return S.uiScale
  end, function(v)
    S.uiScale = v
    uiScale.Scale = v / 100
  end, 50, 150)
  addValue(p, "Steal Bar Size", function()
    return S.stealBarScale
  end, function(v)
    S.stealBarScale = v
  end, 50, 150)
  addToggle(p, "Circle Buttons", function()
    return S.circleButtons
  end, function(v)
    S.circleButtons = v
  end)
  addToggle(p, "Advanced Lagger Button", function()
    return S.advancedLagger
  end, function(v)
    S.advancedLagger = v
  end)
  section(p, "Theme")
  local themeRow = row(p, "Color Theme")
  local themeBtn = Instance.new("TextButton")
  themeBtn.Size = UDim2.fromOffset(90, 24)
  themeBtn.Position = UDim2.new(1, -100, 0.5, -12)
  themeBtn.Font = Enum.Font.GothamBold
  themeBtn.TextSize = 11
  themeBtn.Text = THEMES[S.themeIdx].name
  themeBtn.BackgroundColor3 = accent()
  themeBtn.TextColor3 = Color3.fromRGB(15, 15, 20)
  themeBtn.AutoButtonColor = false
  themeBtn.Parent = themeRow
  corner(themeBtn, 8)
  themeBtn.Activated:Connect(function()
    S.themeIdx = (S.themeIdx % #THEMES) + 1
    themeBtn.Text = THEMES[S.themeIdx].name
    themeBtn.BackgroundColor3 = accent()
    title.TextColor3 = accent()
  end)

  section(p, "Save")
  addButton(p, "SAVE SETTINGS", function()
    local ok = saveSettings()
    local f = pages.SETTINGS:FindFirstChild("SAVE SETTINGS")
    local lbl = f and f:FindFirstChildWhichIsA("TextLabel")
    if lbl then
      local old = lbl.Text
      lbl.Text = ok and "SAVED ✓" or "SAVE FAIL"
      task.delay(1.2, function()
        if lbl then
          lbl.Text = old
        end
      end)
    end
  end)
  addButton(p, "RESET ALL SETTINGS", function()
    S.NS, S.CS, S.LG_N, S.LG_C = 60, 28, 34, 20
    S.family, S.carry = "normal", false
    S.autoSteal, S.infJump, S.antiRagdoll = true, true, true
    S.batAimbot, S.tpBat, S.esp = false, false, false
    S.themeIdx = 1
    S.uiScale = IS_MOBILE and 70 or 100
    uiScale.Scale = S.uiScale / 100
    title.TextColor3 = accent()
    saveSettings()
    for _, t in pairs(toggles) do
      pcall(t.paint)
    end
  end)
end

----------------------------------------------------------------
-- KEYBINDS (display + simple rebind)
----------------------------------------------------------------
do
  local p = pages.KEYBINDS
  section(p, "Keyboard")
  local order = {
    "Speed Key",
    "Lagger Mode Key",
    "Drop Key",
    "TP Down Key",
    "Insta Reset Key",
    "Bat Aimbot Key",
    "TP Bat Key",
    "Auto Left Key",
    "Auto Right Key",
    "UI Toggle Key",
  }
  for _, name in ipairs(order) do
    local f = row(p, name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(56, 24)
    btn.Position = UDim2.new(1, -66, 0.5, -12)
    btn.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
    btn.TextColor3 = Color3.fromRGB(240, 240, 245)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.Text = S.keys[name] or "NONE"
    btn.AutoButtonColor = false
    btn.Parent = f
    corner(btn, 6)
    btn.Activated:Connect(function()
      btn.Text = "..."
      local c
      c = UIS.InputBegan:Connect(function(input, gp)
        if gp then
          return
        end
        if input.KeyCode ~= Enum.KeyCode.Unknown then
          S.keys[name] = input.KeyCode.Name
          btn.Text = input.KeyCode.Name
          c:Disconnect()
        end
      end)
    end)
  end
end

----------------------------------------------------------------
-- CONTROL (controller note)
----------------------------------------------------------------
do
  local p = pages.CONTROL
  section(p, "Controller")
  local note = Instance.new("TextLabel")
  note.BackgroundTransparency = 1
  note.Size = UDim2.new(1, -8, 0, 80)
  note.Font = Enum.Font.Gotham
  note.TextSize = 13
  note.TextColor3 = Color3.fromRGB(180, 180, 190)
  note.TextWrapped = true
  note.TextXAlignment = Enum.TextXAlignment.Left
  note.TextYAlignment = Enum.TextYAlignment.Top
  note.Text = "Usa los mismos keybinds del teclado mapeados en tu mando desde Roblox.\nLos botones móviles cubren las acciones principales en touch."
  note.Parent = p
end

selectTab("SPEED")

----------------------------------------------------------------
-- Float open button
----------------------------------------------------------------
local float = Instance.new("TextButton")
float.Name = "FloatOpen"
float.Size = UDim2.fromOffset(96, 32)
float.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
float.Text = "OPEN"
float.Font = Enum.Font.GothamBlack
float.TextSize = 13
float.TextColor3 = accent()
float.AutoButtonColor = false
float.Visible = true
float.Parent = gui
corner(float, 16)
stroke(float, accent())
if S.floatPos then
  float.Position = UDim2.new(S.floatPos.xs, S.floatPos.xo or 0, S.floatPos.ys, S.floatPos.yo or 0)
else
  float.Position = UDim2.new(0, 14, 0.4, 0)
end

local function setOpen(open)
  main.Visible = open
  float.Visible = not open
  if open then
    ensureCoreGui()
  end
end
float.Activated:Connect(function()
  setOpen(true)
end)
closeBtn.Activated:Connect(function()
  setOpen(false)
end)

----------------------------------------------------------------
-- Steal bar HUD (simple)
----------------------------------------------------------------
local barGui = Instance.new("ScreenGui")
barGui.Name = "KYRONStealBarHUD"
barGui.ResetOnSpawn = false
barGui.IgnoreGuiInset = true
barGui.DisplayOrder = 4
barGui.Parent = PlayerGui

local bar = Instance.new("Frame")
bar.Name = "StealBar"
bar.Size = UDim2.fromOffset(280, 54)
bar.Position = S.stealBarPos and UDim2.new(S.stealBarPos.xs, S.stealBarPos.xo or 0, S.stealBarPos.ys, S.stealBarPos.yo or 0)
  or UDim2.new(0.5, -140, 1, -70)
bar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bar.BorderSizePixel = 0
bar.Active = true
bar.Parent = barGui
corner(bar, 10)
stroke(bar)

local barScale = Instance.new("UIScale", bar)
barScale.Scale = (S.stealBarScale or 70) / 100

local barFillBg = Instance.new("Frame")
barFillBg.Size = UDim2.new(1, -16, 0, 18)
barFillBg.Position = UDim2.new(0, 8, 1, -26)
barFillBg.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
barFillBg.BorderSizePixel = 0
barFillBg.Parent = bar
corner(barFillBg, 8)

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = accent()
barFill.BorderSizePixel = 0
barFill.Parent = barFillBg
corner(barFill, 8)

local barLabel = Instance.new("TextLabel")
barLabel.BackgroundTransparency = 1
barLabel.Size = UDim2.new(1, -16, 0, 20)
barLabel.Position = UDim2.fromOffset(8, 4)
barLabel.Font = Enum.Font.GothamBold
barLabel.TextSize = 12
barLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
barLabel.TextXAlignment = Enum.TextXAlignment.Left
barLabel.Text = "KYRON  ·  FPS --"
barLabel.Parent = bar

task.spawn(function()
  local frames, t0 = 0, tick()
  while bar.Parent do
    frames += 1
    local now = tick()
    if now - t0 >= 0.5 then
      barLabel.Text = string.format("KYRON  ·  FPS %d", math.floor(frames / (now - t0)))
      frames, t0 = 0, now
    end
    task.wait()
  end
end)

-- Drag steal bar
do
  local dragging, startPos, startInput
  bar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
      dragging = true
      startPos = bar.Position
      startInput = input.Position
    end
  end)
  UIS.InputEnded:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
      dragging = false
      S.stealBarPos = {
        xs = bar.Position.X.Scale,
        xo = bar.Position.X.Offset,
        ys = bar.Position.Y.Scale,
        yo = bar.Position.Y.Offset,
      }
    end
  end)
  UIS.InputChanged:Connect(function(input)
    if not dragging then
      return
    end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
      local d = input.Position - startInput
      bar.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
  end)
end

----------------------------------------------------------------
-- Mobile buttons (only on touch)
----------------------------------------------------------------
local mobileHolder = Instance.new("Frame")
mobileHolder.Name = "MobileButtons"
mobileHolder.BackgroundTransparency = 1
mobileHolder.Size = UDim2.fromScale(1, 1)
mobileHolder.Active = false
mobileHolder.Parent = gui

local mobileBtns = {}
local MOBILE = {
  { "Drop Brainrot", dropBrainrot },
  { "TP Down", tpDown },
  { "Insta Reset", instaReset },
  {
    "Carry Speed",
    function()
      S.family = "normal"
      S.carry = not S.carry
    end,
  },
  {
    "Lagger Mode",
    function()
      if S.family == "lagger" and not S.carry then
        S.family = "normal"
      else
        S.family = "lagger"
        S.carry = false
      end
    end,
  },
  {
    "Bat Aimbot",
    function()
      S.batAimbot = not S.batAimbot
      if toggles["Bat Aimbot"] then
        toggles["Bat Aimbot"].paint()
      end
    end,
  },
  {
    "TP Bat",
    function()
      S.tpBat = not S.tpBat
      if toggles["TP Bat"] then
        toggles["TP Bat"].paint()
      end
    end,
  },
  {
    "Auto Left",
    function()
      S.autoLeft = not S.autoLeft
      if toggles["Auto Left"] then
        toggles["Auto Left"].paint()
      end
    end,
  },
  {
    "Auto Right",
    function()
      S.autoRight = not S.autoRight
      if toggles["Auto Right"] then
        toggles["Auto Right"].paint()
      end
    end,
  },
}

for i, def in ipairs(MOBILE) do
  local name, fn = def[1], def[2]
  local b = Instance.new("TextButton")
  b.Name = name
  b.Size = UDim2.fromOffset(72, 36)
  b.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
  b.BackgroundTransparency = 0.15
  b.Text = name
  b.Font = Enum.Font.GothamBold
  b.TextSize = 10
  b.TextColor3 = Color3.fromRGB(240, 240, 245)
  b.TextWrapped = true
  b.AutoButtonColor = false
  b.Visible = IS_MOBILE
  b.Parent = mobileHolder
  corner(b, S.circleButtons and 18 or 8)
  stroke(b, accent(), 1)
  local col = (i - 1) % 3
  local row = math.floor((i - 1) / 3)
  if S.mobilePos[name] then
    local mp = S.mobilePos[name]
    b.Position = UDim2.new(mp.xs, mp.xo or 0, mp.ys, mp.yo or 0)
  else
    b.Position = UDim2.new(1, -240 + col * 80, 0.55, row * 44)
  end
  b.Activated:Connect(function()
    pcall(fn)
  end)
  -- drag
  local dragging, startPos, startInput
  b.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
      dragging = true
      startPos = b.Position
      startInput = input.Position
    end
  end)
  UIS.InputEnded:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
      dragging = false
      S.mobilePos[name] = {
        xs = b.Position.X.Scale,
        xo = b.Position.X.Offset,
        ys = b.Position.Y.Scale,
        yo = b.Position.Y.Offset,
      }
    end
  end)
  UIS.InputChanged:Connect(function(input)
    if not dragging then
      return
    end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
      local d = input.Position - startInput
      b.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
  end)
  mobileBtns[name] = b
end

----------------------------------------------------------------
-- Keybinds runtime
----------------------------------------------------------------
local ACTIONS = {
  ["Speed Key"] = function()
    S.family = "normal"
    S.carry = not S.carry
  end,
  ["Lagger Mode Key"] = function()
    if S.family == "lagger" then
      S.family = "normal"
      S.carry = false
    else
      S.family = "lagger"
      S.carry = false
    end
  end,
  ["Drop Key"] = dropBrainrot,
  ["TP Down Key"] = tpDown,
  ["Insta Reset Key"] = instaReset,
  ["Bat Aimbot Key"] = function()
    S.batAimbot = not S.batAimbot
    if toggles["Bat Aimbot"] then
      toggles["Bat Aimbot"].paint()
    end
  end,
  ["TP Bat Key"] = function()
    S.tpBat = not S.tpBat
    if toggles["TP Bat"] then
      toggles["TP Bat"].paint()
    end
  end,
  ["Auto Left Key"] = function()
    S.autoLeft = not S.autoLeft
    if toggles["Auto Left"] then
      toggles["Auto Left"].paint()
    end
  end,
  ["Auto Right Key"] = function()
    S.autoRight = not S.autoRight
    if toggles["Auto Right"] then
      toggles["Auto Right"].paint()
    end
  end,
  ["UI Toggle Key"] = function()
    setOpen(not main.Visible)
  end,
}

track(UIS.InputBegan:Connect(function(input, gp)
  if gp or UIS:GetFocusedTextBox() then
    return
  end
  if input.KeyCode == Enum.KeyCode.Unknown then
    return
  end
  local name = input.KeyCode.Name
  for keyName, keyCodeName in pairs(S.keys) do
    if keyCodeName == name and ACTIONS[keyName] then
      pcall(ACTIONS[keyName])
    end
  end
end))

----------------------------------------------------------------
-- Minimal ESP
----------------------------------------------------------------
local espFolder = Instance.new("Folder")
espFolder.Name = "KYRONESP"
espFolder.Parent = gui

local function clearEsp()
  for _, ch in ipairs(espFolder:GetChildren()) do
    ch:Destroy()
  end
end

track(RunService.RenderStepped:Connect(function()
  if not S.esp then
    clearEsp()
    return
  end
  local r = root()
  for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LP and p.Character then
      local hrp = p.Character:FindFirstChild("HumanoidRootPart")
      local h = p.Character:FindFirstChildOfClass("Humanoid")
      if hrp and h and h.Health > 0 and Camera then
        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        local tag = espFolder:FindFirstChild(p.Name)
        if not tag then
          tag = Instance.new("TextLabel")
          tag.Name = p.Name
          tag.BackgroundTransparency = 1
          tag.Size = UDim2.fromOffset(120, 16)
          tag.Font = Enum.Font.GothamBold
          tag.TextSize = 12
          tag.TextColor3 = accent()
          tag.TextStrokeTransparency = 0.5
          tag.Parent = espFolder
        end
        if onScreen and pos.Z > 0 then
          tag.Visible = true
          tag.Position = UDim2.fromOffset(pos.X - 60, pos.Y - 40)
          tag.Text = p.DisplayName
        else
          tag.Visible = false
        end
      end
    end
  end
end))

----------------------------------------------------------------
-- Boot
----------------------------------------------------------------
syncAutoTP()
setOpen(true)
ensureCoreGui()
print("[KYRON CLEAN] Loaded — UI only features. Save with SAVE SETTINGS.")