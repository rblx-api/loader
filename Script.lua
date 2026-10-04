local enumValues, whiteColor, indigoAccentColor, fullCornerRadius, blackColor, cornerRadius6, slateButtonColor, collapsedSize, mutedRedSurfaceColor, cornerRadius7, zeroSize, oliveDisabledColor, fillSize, lightTextColor, navyColor, darkBackgroundColor, cornerRadius5, purpleAccentColor, darkSurfaceColor, redColor, grayColor, sliderFillSize, defaultButtonSize, verticalFillSize, cornerRadius8, centerAnchor, deepNavyColor, goldColor, standardRowSize, cornerRadius10, alertRedColor, lightRedColor, greenColor, cornerRadius4, orangeColor, panelBackgroundColor, violetColor, mediumGrayColor, _cachedStealPrompt, _cachedStealTarget, uiBuildYield
local button1, button2, button3, createEspBillboard, addInlineScaleSlider, selectedPet, segmentCrossesPortal, buildDetourRoute, getMutationRank
local newInstance = Instance.new
local function setProperties(instance, properties)
  local parent = properties.Parent
  properties.Parent = nil
  for propertyName, value in pairs(properties) do
    instance[propertyName] = value
  end
  if parent then
    instance.Parent = parent
  end
  return instance
end
local KEY="R"local L,R,U=game:GetService("Players").LocalPlayer,game:GetService("RunService"),game:GetService("UserInputService")local function run()local c=L.Character local h=c and c:FindFirstChildOfClass("Humanoid")local t=c and c:FindFirstChild("Quantum Cloner")or(L:FindFirstChild("Backpack")and L.Backpack:FindFirstChild("Quantum Cloner"))if not h or not t then return end if t.Parent~=c then h:EquipTool(t)task.wait(0.1)end pcall(function()t:Activate()end)local b=L.PlayerGui:FindFirstChild("TeleportToClone",true)if b and firesignal then local t0=os.clock()repeat b.Visible=true pcall(firesignal,b.MouseButton1Up)R.Heartbeat:Wait()until os.clock()-t0>1 end end local sg=Instance.new("ScreenGui",L.PlayerGui)local b=Instance.new("TextButton",sg)b.Size=UDim2.fromOffset(55,22)b.Position=UDim2.new(0.5,-27,0.5,-11)b.BackgroundColor3=Color3.new(0,0,0)b.Text="R: Cloner"b.TextColor3=Color3.new(1,1,1)b.TextSize=10 b.Font=Enum.Font.GothamBold Instance.new("UICorner",b).CornerRadius=UDim.new(0,5)U.InputBegan:Connect(function(i,gp)if not gp and i.KeyCode==Enum.KeyCode[KEY]then task.spawn(run)end end)local d,st,ps=false,nil,nil b.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=true st=i.Position ps=b.Position end end)U.InputChanged:Connect(function(i)if d and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then local g=i.Position-st b.Position=UDim2.new(ps.X.Scale,ps.X.Offset+g.X,ps.Y.Scale,ps.Y.Offset+g.Y)end end)U.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=false end end)

local spawnLineEnabled = false
local registerCleanupConnection, PlayersService, localPlayer, TeleportService, InputService, RunService, HttpService, ContentProviderService, StarterGuiService
local TweenService, LightingService, TextService, sharedPriorityItems, isAutoPurchaseAllowed, WorkspaceRoot, fileSystemAvailable, earlyUISettings, isMobile, resetCharacterSafely
local espEnabled, espHighlights, espBillboards, trackedESPItems, instantClonerEnabled, selectTargetKey, baseHubVisible, uiVisible, transparentPlotsEnabled, rainbowBeamEnabled
local plotBeam, plotBeamAttachPlayer, createPlotBeam, plotsFolder, toggleClearBase, placeId, jobId
do
  do
    local routeRunService, equipRoutingTools, computeOptimizedRoute, traverseRouteVelocity, applySmoothVelocityRamp, upperFloorThreshold, lowerBasePositions, upperBasePositions, lowerFloorY, findClosestBaseIndex
    local getTargetAnimalPosition, teleportToTarget
    do
      local equipTeleportTool, computeFallbackRoute, suppressCharacterAnimations, moveAlongRoute, stopRootMotion, localPlayer2, lowerFloorRoutes, upperFloorRoutes
      do
        local isPathClear, routePlayersService, localPlayer3, routeIgnoredInstances
        local moveThroughRoute
        do
          local isStrictObstacle, pathClearance, isLooseObstacle, PathfindingService, movementPlayersService, maxVerticalSpeed, waypointArrivalRadius, cardinalDirections
          do
            local netFolder, remoteHashSecret, decodeRemotePath, computeSha256Binary
            do
              do
                local getSynchronizer
                do
                  if not game:IsLoaded() then
                    game.Loaded:Wait()
                  end
                  enumValues = {
                    gothamBoldFont = Enum.Font.GothamBold,
                    gothamBlackFont = Enum.Font.GothamBlack,
                    gothamSemiboldFont = Enum.Font.GothamSemibold,
                    touchInput = Enum.UserInputType.Touch,
                    primaryMouseButton = Enum.UserInputType.MouseButton1,
                    keyboardInput = Enum.UserInputType.Keyboard,
                    mouseMovementInput = Enum.UserInputType.MouseMovement,
                    textAlignLeft = Enum.TextXAlignment.Left,
                    textAlignCenter = Enum.TextXAlignment.Center,
                    textAlignRight = Enum.TextXAlignment.Right,
                    verticalAlignCenter = Enum.TextYAlignment.Center,
                    easingOut = Enum.EasingDirection.Out,
                    easingIn = Enum.EasingDirection.In,
                    quadEasing = Enum.EasingStyle.Quad,
                    backEasing = Enum.EasingStyle.Back,
                    quintEasing = Enum.EasingStyle.Quint,
                    truncateAtEnd = Enum.TextTruncate.AtEnd,
                    layoutOrderSort = Enum.SortOrder.LayoutOrder,
                    excludeRaycastFilter = Enum.RaycastFilterType.Exclude,
                    siblingZIndex = Enum.ZIndexBehavior.Sibling,
                    deadHumanoidState = Enum.HumanoidStateType.Dead,
                    Players = game:GetService("Players"),
                    ReplicatedStorage = game:GetService("ReplicatedStorage"),
                    RunService = game:GetService("RunService"),
                    Workspace = game:GetService("Workspace"),
                    HttpService = game:GetService("HttpService"),
                    TweenService = game:GetService("TweenService"),
                    UserInputService = game:GetService("UserInputService"),
                    TeleportService = game:GetService("TeleportService"),
                    CoreGui = game:GetService("CoreGui"),
                    Lighting = game:GetService("Lighting"),
                    Debris = game:GetService("Debris"),
                    SoundService = game:GetService("SoundService"),
                    PathfindingService = game:GetService("PathfindingService"),
                    TextService = game:GetService("TextService"),
                  }
                  whiteColor = Color3.fromRGB(255, 255, 255)
                  indigoAccentColor = Color3.fromRGB(99, 102, 241)
                  fullCornerRadius = UDim.new(1, 0)
                  blackColor = Color3.fromRGB(0, 0, 0)
                  cornerRadius6 = UDim.new(0, 6)
                  slateButtonColor = Color3.fromRGB(74, 86, 128)
                  collapsedSize = UDim2.new(1, 0, 0, 0)
                  mutedRedSurfaceColor = Color3.fromRGB(60, 40, 50)
                  cornerRadius7 = UDim.new(0, 7)
                  zeroSize = UDim2.new(0, 0, 0, 0)
                  oliveDisabledColor = Color3.fromRGB(80, 80, 60)
                  fillSize = UDim2.new(1, 0, 1, 0)
                  lightTextColor = Color3.fromRGB(220, 220, 230)
                  navyColor = Color3.fromRGB(50, 50, 100)
                  darkBackgroundColor = Color3.fromRGB(12, 12, 18)
                  cornerRadius5 = UDim.new(0, 5)
                  purpleAccentColor = Color3.fromRGB(160, 100, 170)
                  darkSurfaceColor = Color3.fromRGB(30, 30, 35)
                  redColor = Color3.fromRGB(255, 0, 0)
                  grayColor = Color3.fromRGB(150, 150, 150)
                  sliderFillSize = UDim2.new(0.85, 0, 0, 1)
                  defaultButtonSize = UDim2.new(0, 100, 0, 30)
                  verticalFillSize = UDim2.new(0, 0, 1, 0)
                  cornerRadius8 = UDim.new(0, 8)
                  centerAnchor = Vector2.new(0.5, 0.5)
                  deepNavyColor = Color3.fromRGB(8, 8, 16)
                  goldColor = Color3.fromRGB(255, 215, 0)
                  standardRowSize = UDim2.new(1, 0, 0, 34)
                  cornerRadius10 = UDim.new(0, 10)
                  alertRedColor = Color3.fromRGB(255, 50, 50)
                  lightRedColor = Color3.fromRGB(255, 100, 100)
                  greenColor = Color3.fromRGB(100, 255, 100)
                  cornerRadius4 = UDim.new(0, 4)
                  orangeColor = Color3.fromRGB(255, 140, 0)
                  panelBackgroundColor = Color3.fromRGB(25, 25, 35)
                  violetColor = Color3.fromRGB(140, 80, 255)
                  mediumGrayColor = Color3.fromRGB(120, 120, 120)
                  _G._xenHUI = _G._xenHUI
                    or function()
                      local success, callResult = pcall(function()
                        local isConditionMet = gethui or get_hidden_gui or gethiddenui
                        return isConditionMet and isConditionMet()
                      end)
                      if success then
                        success = typeof(callResult) == "Instance"
                      end
                      if success then
                        return callResult
                      end
                      local success2, callResult2 = pcall(function()
                        return cloneref(enumValues.CoreGui)
                      end)
                      if success2 and typeof(callResult2) == "Instance" then
                        return callResult2
                      end
                      return enumValues.CoreGui
                    end
                  do
                    local snapshot = _G
                    local xenN = _G._xenN
                    if not xenN then
                      local function getValue()
                        local randomGenerator = Random.new()
                        local function getValue()
                          local items = {}
                          for i = 1, 16 do
                            items[i] = string.char(randomGenerator:NextInteger(97, 122))
                          end
                          return table.concat(items)
                        end
                        return {
                          tpp = getValue(),
                          tcp = getValue(),
                          mf = getValue(),
                          la = getValue(),
                          is = getValue(),
                          pt = getValue(),
                          tf = getValue(),
                          tla = getValue(),
                        }
                      end
                      xenN = getValue()
                    end
                    snapshot._xenN = xenN
                  end
                end
                task.spawn(function()
                  if not enumValues.Players.LocalPlayer then
                    return
                  end
                  local function onCharacterAdded(character)
                    if
                      not (
                        character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 10)
                      )
                    then
                      return
                    end
                    local function onDescendantAdded(descendant)
                      if descendant:IsA("BasePart") and descendant.Name ~= "__HITBOX" then
                        pcall(function()
                          descendant.CollisionGroup = "Default"
                        end)
                      end
                    end
                    for _, descendant in ipairs(character:GetDescendants()) do
                      onDescendantAdded(descendant)
                    end
                    character.DescendantAdded:Connect(onDescendantAdded)
                  end
                  if enumValues.Players.LocalPlayer.Character then
                    task.spawn(onCharacterAdded, enumValues.Players.LocalPlayer.Character)
                  end
                  enumValues.Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
                end)
                do
                  local packages = enumValues.ReplicatedStorage:WaitForChild("Packages")
                  packages:WaitForChild("Synchronizer")
                  packages:WaitForChild("Net")
                end
                do
                  local state = nil
                  getSynchronizer = function()
                    if state then
                      return state
                    end
                    local success, callResult = pcall(function()
                      return require(enumValues.ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Synchronizer"))
                    end)
                    if success and type(callResult) == "table" then
                      state = callResult
                    end
                    return state
                  end
                end
                local knownSynchronizerChannels, getValue11, getValue2, handleState, findTarget2
                do
                  local items = {}
                  knownSynchronizerChannels = {}
                  local isEnabled = false
                  getValue11 = function(data)
                    if data == nil then
                      return nil
                    end
                    if items[data] then
                      return items[data]
                    end
                    local state13 = getSynchronizer()
                    if not state13 then
                      return nil
                    end
                    local state2 = nil
                    pcall(function()
                      state13:WaitAndCall(data, function(data)
                        state2 = data
                      end)
                    end)
                    if state2 then
                      items[data] = state2
                      knownSynchronizerChannels[data] = true
                    end
                    return state2
                  end
                  getValue2 = function(data)
                    local state = getValue11(data)
                    if not state then
                      return nil
                    end
                    local state2 = rawget(state, "CacheTable")
                    return type(state2) == "table" and state2 or nil
                  end
                  handleState = function()
                    local plots_2 = enumValues.Workspace:FindFirstChild("Plots")
                    if plots_2 then
                      for _, child in ipairs(plots_2:GetChildren()) do
                        knownSynchronizerChannels[child.Name] = true
                      end
                    end
                    if enumValues.Players.LocalPlayer then
                      knownSynchronizerChannels[enumValues.Players.LocalPlayer.Name] = true
                    end
                    for _, item in ipairs({
                      "Cycle",
                      "Events",
                      "ServerLuck",
                    }) do
                      knownSynchronizerChannels[item] = true
                    end
                  end
                  findTarget2 = function()
                    if isEnabled then
                      return
                    end
                    isEnabled = true
                    local state14 = getSynchronizer()
                    if not state14 then
                      return
                    end
                    pcall(function()
                      state14.OnChannelCreated:Connect(function(data)
                        local state15 = rawget(data, "Index")
                        if state15 ~= nil then
                          items[state15] = data
                          knownSynchronizerChannels[state15] = true
                        end
                      end)
                      state14.OnChannelDestroyed:Connect(function(data)
                        local state16 = rawget(data, "Index")
                        if state16 ~= nil then
                          items[state16] = nil
                          knownSynchronizerChannels[state16] = nil
                        end
                      end)
                    end)
                    pcall(function()
                      local plots = enumValues.Workspace:FindFirstChild("Plots")
                      if plots then
                        plots.ChildAdded:Connect(function(child)
                          knownSynchronizerChannels[child.Name] = true
                        end)
                        plots.ChildRemoved:Connect(function(child)
                          knownSynchronizerChannels[child.Name] = nil
                          items[child.Name] = nil
                        end)
                      end
                    end)
                  end
                end
                do
                  local function getValue12()
                    findTarget2()
                    handleState()
                    return knownSynchronizerChannels
                  end
                  _G._xenRawCT = function(data)
                    return getValue2(data)
                  end
                  _G.XenSyncGet = function(data)
                    return getValue11(data)
                  end
                  _G.XenSyncBind = function()
                    return getValue12()
                  end
                  _G.XenSyncAll = function()
                    local items = {}
                    for k in pairs(getValue12()) do
                      local state = getValue11(k)
                      if state then
                        items[k] = state
                      end
                    end
                    return items
                  end
                  local xenSync = {
                    Read = function(data)
                      return getValue2(data)
                    end,
                    Channel = function(data)
                      return getValue11(data)
                    end,
                    Indices = function()
                      local items = {}
                      for k in pairs(getValue12()) do
                        items[#items + 1] = k
                      end
                      return items
                    end,
                    AnimalList = function(data)
                      local animalList = getValue2(data)
                      animalList = animalList and animalList.AnimalList
                      return type(animalList) == "table" and animalList or nil
                    end,
                    Owner = function(data)
                      local owner = getValue2(data)
                      owner = owner and owner.Owner
                      if owner == nil then
                        return nil
                      end
                      local isActive = typeof(owner) == "Instance"
                      local isActive2
                      if isActive then
                        isActive2 = isActive
                      else
                        isActive2 = type(owner) == "table"
                      end
                      if isActive2 then
                        return owner.Name
                      end
                      return tostring(owner)
                    end,
                    Generation = function(data, data2, data3)
                      return _G._xenGen and _G._xenGen(data, data2, data3) or 0
                    end,
                    ChGet = function(data, data2)
                      if not data then
                        return nil
                      end
                      local state = rawget(data, "CacheTable")
                      if type(state) == "table" then
                        return state[data2]
                      end
                      return nil
                    end,
                  }
                  _G.XenChGet = xenSync.ChGet
                  xenSync.ScanAll = function(data)
                    local isConditionMet = data or 0
                    local items = {}
                    for _, item in ipairs(xenSync.Indices()) do
                      local state = getValue2(item)
                      if type(state) == "table" and type(state.AnimalList) == "table" then
                        local owner = state.Owner
                        local name = owner ~= nil
                            and ((typeof(owner) == "Instance" or type(owner) == "table") and owner.Name or tostring(
                              owner
                            ))
                          or nil
                        for k, itemLocal448 in pairs(state.AnimalList) do
                          local index = type(itemLocal448) == "table" and itemLocal448.Index
                          if index then
                            index = not (
                              itemLocal448.Machine
                              and itemLocal448.Machine.Type == "Fuse"
                              and itemLocal448.Machine.Active
                            )
                          end
                          if index then
                            local xenGen = _G._xenGen
                                and _G._xenGen(itemLocal448.Index, itemLocal448.Mutation, itemLocal448.Traits)
                              or 0
                            if isConditionMet <= xenGen then
                              local mutation = itemLocal448.Mutation
                              if mutation == "None" or mutation == "" then
                                mutation = nil
                              end
                              items[#items + 1] = {
                                name = itemLocal448.Index,
                                rawIndex = itemLocal448.Index,
                                value = xenGen,
                                mutation = mutation,
                                traits = itemLocal448.Traits,
                                owner = name,
                                plot = item,
                                slot = tostring(k),
                                uid = tostring(item) .. "_" .. tostring(k),
                              }
                            end
                          end
                        end
                      end
                    end
                    table.sort(items, function(data, data2)
                      return data.value > data2.value
                    end)
                    return items
                  end
                  _G.XenSync = xenSync
                  task.spawn(function()
                    pcall(getValue12)
                  end)
                end
              end
              do
                local genv, xenSigsSet, getValue13
                do
                  local Animals = nil
                  local Mutations = nil
                  local Traits = nil
                  local function findTarget()
                    if Animals then
                      return true
                    end
                    return pcall(function()
                      local datas = enumValues.ReplicatedStorage:WaitForChild("Datas")
                      Animals = require(datas:WaitForChild("Animals"))
                      Mutations = require(datas:WaitForChild("Mutations"))
                      Traits = require(datas:WaitForChild("Traits"))
                    end) and Animals ~= nil
                  end
                  _G._xenGen = function(data, data2, collection)
                    if not findTarget() then
                      return 0
                    end
                    local entry = Animals[data]
                    if not entry then
                      return 0
                    end
                    local generation = entry.Generation or 0
                    local isActive = data2 and data2 ~= "None" and data2 ~= ""
                    local amount = 1
                    if isActive then
                      local entry = Mutations[data2]
                      if entry and entry.Modifier then
                        amount = 1 + entry.Modifier
                      end
                    end
                    local isEnabled = false
                    if type(collection) == "table" then
                      for _, item in pairs(collection) do
                        local entry = Traits[item]
                        if entry then
                          if item == "Sleepy" then
                            isEnabled = true
                          else
                            amount += entry.MultiplierModifier or 0
                          end
                        end
                      end
                    end
                    local calculatedValue = generation * amount
                    if isEnabled then
                      calculatedValue *= 0.5
                    end
                    return math.round(calculatedValue)
                  end
                end
                _G._xenAnimShim = {
                  GetGeneration = function(data, data2, data3, data4)
                    return _G._xenGen(data2, data3, data4)
                  end,
                }
                do
                  local animals = nil
                  local instance21 = nil
                  local mutationSurfaces = nil
                  local function findTarget()
                    if animals then
                      return
                    end
                    pcall(function()
                      local models = enumValues.ReplicatedStorage:FindFirstChild("Models")
                      if models then
                        animals = models:FindFirstChild("Animals")
                        if not animals or #animals:GetChildren() == 0 then
                          local traitsPerAnimal = models:FindFirstChild("TraitsPerAnimal")
                          if traitsPerAnimal then
                            local amount = 0
                            local state17 = nil
                            for _, child in ipairs(traitsPerAnimal:GetChildren()) do
                              local state18 = #child:GetChildren()
                              if amount < state18 then
                                amount = state18
                                state17 = child
                              end
                            end
                            animals = state17
                          end
                        end
                      end
                      local animations = enumValues.ReplicatedStorage:FindFirstChild("Animations")
                      if animations then
                        instance21 = animations:FindFirstChild("Animals") or animations
                      end
                      mutationSurfaces = enumValues.ReplicatedStorage:FindFirstChild("MutationSurfaces")
                    end)
                  end
                  local function checkCondition(instance)
                    local amount = 0
                    for _, descendant in ipairs(instance:GetDescendants()) do
                      if descendant:IsA("BasePart") then
                        amount += 1
                      end
                    end
                    return amount
                  end
                  local function findTarget2(childName)
                    local lowercaseText = childName:lower()
                    local assetCache = enumValues.ReplicatedStorage:FindFirstChild("Controllers")
                      and enumValues.ReplicatedStorage.Controllers:FindFirstChild("AnimalController")
                    assetCache = assetCache and assetCache:FindFirstChild("AssetCache")
                    if not assetCache then
                      return nil
                    end
                    local state = assetCache:FindFirstChild(childName)
                    if state and checkCondition(state) > 0 then
                      return state
                    end
                    for _, child in ipairs(assetCache:GetChildren()) do
                      local isActive = child.Name:lower() == lowercaseText
                      if isActive then
                        isActive = checkCondition(child) > 0
                      end
                      if isActive then
                        return child
                      end
                    end
                    return nil
                  end
                  _G.buildViewport = function(parent, childName, childName2)
                    findTarget()
                    if not animals then
                      return
                    end
                    if not childName or childName == "" then
                      return
                    end
                    local state = findTarget2(childName)
                    if not state then
                      return
                    end
                    local clone = nil
                    pcall(function()
                      clone = state:Clone()
                    end)
                    if not clone then
                      return
                    end
                    local ViewportFrame = newInstance("ViewportFrame")
                    setProperties(ViewportFrame, {
                      Size = fillSize,
                      BackgroundTransparency = 1,
                      LightColor = whiteColor,
                      LightDirection = Vector3.new(-1, -2, -1),
                      Ambient = Color3.fromRGB(180, 180, 180),
                      Parent = parent,
                    })
                    local parent = newInstance("WorldModel")
                    parent.Parent = ViewportFrame
                    for _, descendant in ipairs(clone:GetDescendants()) do
                      pcall(function()
                        if
                          descendant:IsA("BillboardGui")
                          or descendant:IsA("SurfaceGui")
                          or descendant:IsA("ProximityPrompt")
                          or descendant:IsA("Sound")
                          or descendant:IsA("ParticleEmitter")
                          or descendant:IsA("Trail")
                          or descendant:IsA("Beam")
                          or descendant:IsA("Fire")
                          or descendant:IsA("Smoke")
                          or descendant:IsA("Sparkles")
                          or descendant:IsA("Script")
                          or descendant:IsA("LocalScript")
                        then
                          descendant:Destroy()
                        end
                      end)
                    end
                    pcall(function()
                      if clone:IsA("Model") then
                        clone:PivotTo(CFrame.new(0, 0, 0))
                      elseif clone:IsA("BasePart") then
                        clone.CFrame = CFrame.new(0, 0, 0)
                      end
                    end)
                    clone.Parent = parent
                    if clone:IsA("BasePart") then
                      clone.Anchored = true
                      clone.CanCollide = false
                      clone.CastShadow = false
                    end
                    if clone:IsA("Model") and clone.PrimaryPart then
                      clone.PrimaryPart.Anchored = true
                    end
                    for _, descendant in ipairs(clone:GetDescendants()) do
                      if descendant:IsA("BasePart") then
                        descendant.Anchored = true
                        descendant.CanCollide = false
                        descendant.CastShadow = false
                        descendant.Massless = true
                      end
                    end
                    if childName2 and childName2 ~= "" and mutationSurfaces then
                      pcall(function()
                        local instance = mutationSurfaces:FindFirstChild(childName2)
                        if not instance then
                          local lowercaseText = childName2:lower()
                          for _, child in ipairs(mutationSurfaces:GetChildren()) do
                            if
                              child.Name:lower() == lowercaseText or child.Name:lower():find(lowercaseText, 1, true)
                            then
                              instance = child
                              break
                            end
                          end
                        end
                        if instance and instance:IsA("SurfaceAppearance") then
                          local items = {}
                          if clone:IsA("MeshPart") then
                            table.insert(items, clone)
                          end
                          for _, descendant in ipairs(clone:GetDescendants()) do
                            if descendant:IsA("MeshPart") then
                              table.insert(items, descendant)
                            end
                          end
                          for _, item in ipairs(items) do
                            for _, child in ipairs(item:GetChildren()) do
                              if child:IsA("SurfaceAppearance") then
                                child:Destroy()
                              end
                            end
                            instance:Clone().Parent = item
                          end
                        end
                      end)
                    end
                    local cFrame = nil
                    local size = nil
                    pcall(function()
                      if clone:IsA("Model") then
                        local boundingBox, state = clone:GetBoundingBox()
                        cFrame = boundingBox
                        size = state
                      elseif clone:IsA("BasePart") then
                        cFrame = clone.CFrame
                        size = clone.Size
                      end
                    end)
                    if not cFrame then
                      cFrame = CFrame.new
                      cFrame = cFrame(0, 0, 0)
                      size = Vector3.new(4, 4, 4)
                    end
                    local maximumValue = math.max(size.X, size.Y, size.Z)
                    if maximumValue < 0.1 then
                      maximumValue = 4
                    end
                    local unit = Vector3.new(-1, 0.5, -1).Unit
                    local currentCamera = newInstance("Camera")
                    setProperties(currentCamera, {
                      FieldOfView = 50,
                      CFrame = CFrame.new(
                        cFrame.Position + unit * maximumValue * 0.5 / 0.46630765815499858 * 1.2,
                        cFrame.Position
                      ),
                      Parent = ViewportFrame,
                    })
                    ViewportFrame.CurrentCamera = currentCamera
                    if instance21 then
                      pcall(function()
                        local instance22 = instance21:FindFirstChild(childName)
                        if not instance22 then
                          local lowercaseText = childName:lower()
                          for _, child in ipairs(instance21:GetChildren()) do
                            if
                              child.Name:lower() == lowercaseText or child.Name:lower():find(lowercaseText, 1, true)
                            then
                              instance22 = child
                              break
                            end
                          end
                        end
                        local state
                        if instance22 then
                          local idle = instance22:FindFirstChild("Idle") or instance22:FindFirstChild("Walk")
                          if idle then
                            state = idle
                          else
                            state = instance22:GetChildren()[1]
                          end
                        else
                          state = instance22
                        end
                        if not state then
                          return
                        end
                        local animationController = clone:FindFirstChildWhichIsA("AnimationController", true)
                          or newInstance("AnimationController", clone)
                        local tween = (animationController:FindFirstChildOfClass("Animator") or newInstance(
                          "Animator",
                          animationController
                        )):LoadAnimation(state)
                        tween.Looped = true
                        tween:Play(0)
                        if tween.Length > 0 then
                          local length = tween.Length
                          tween.TimePosition = os.clock() % length
                        end
                      end)
                    end
                  end
                end
                pcall(function()
                  enumValues.Players.RespawnTime = 0
                end)
                task.wait(0.1)
                genv = getgenv and getgenv() or _G
                xenSigsSet = {
                  steal = {
                    remote = "f1a4d3a5-b97a-4622-8fd6-232663ff697e",
                    offset = 50,
                    sig1 = "ba10cc43-8b93-4b7d-93b8-e1935730ebe3",
                    sig2 = "ed327974-0c39-423a-b9c7-467b8fdac46d",
                  },
                  buy = {
                    remote = "09e66d0e-a7a7-4ae6-bda3-7e169e20894f",
                    offset = 219,
                    sig1 = "84ff105c-ca6f-487f-a69d-9499001a1af0",
                    sig2 = "f2778935-0b31-401b-b9ef-9b27994fa22c",
                  },
                  ap = {
                    remote = "a434c202-a33e-49b9-80a0-4957c24b60b8",
                    token = "fcec6acb-8d1e-4fa1-8d84-fbe0f52f5f0c",
                  },
                }
                if genv.__xenSigs and genv.__xenSigsPV == game.PlaceVersion then
                  _G.XenSigs = genv.__xenSigs
                else
                  _G.XenSigs = _G.XenSigs or {}
                end
                for k, item in pairs(xenSigsSet) do
                  if not _G.XenSigs[k] then
                    _G.XenSigs[k] = item
                  end
                end
                _G.XenSigsSet = xenSigsSet
                do
                  local function findTarget(data)
                    local instance = enumValues.ReplicatedStorage
                    for match in data:gmatch("[^%.]+") do
                      instance = instance and instance:FindFirstChild(match)
                    end
                    return instance
                  end
                  getValue13 = function(data)
                    local state = findTarget(data)
                    if not state or type(decompile) ~= "function" then
                      return nil
                    end
                    local success, callResult = pcall(decompile, state)
                    if success then
                      success = type(callResult) == "string"
                    end
                    if success then
                      return callResult
                    end
                    return nil
                  end
                end
                do
                  local function getValue14(data)
                    local state = getValue13(data)
                    if not state then
                      return nil
                    end
                    local match = state:match(
                      'Net:RemoteEvent%("([0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]%-[0-9a-f]+%-[0-9a-f]+%-[0-9a-f]+%-[0-9a-f]+)"%)'
                    )
                    if not match then
                      return nil
                    end
                    local items = {}
                    local state2, state3, state4 = state:gmatch(
                      'GetServerTimeNow%(%) %+ (%d+), "([0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]%-[0-9a-f]+%-[0-9a-f]+%-[0-9a-f]+%-[0-9a-f]+)"'
                    )
                    local num = nil
                    for k, item in state2, state3, state4 do
                      num = tonumber(k)
                      items[#items + 1] = item
                    end
                    if not num or #items < 2 then
                      return nil
                    end
                    return {
                      remote = match,
                      offset = num,
                      sig1 = items[1],
                      sig2 = items[2],
                    }
                  end
                  local function getValue2()
                    local state = getValue13("Controllers.ItemController")
                    if not state then
                      return nil
                    end
                    local match, match2 = state:match(
                      'Net:RemoteFunction%("([0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]%-[0-9a-f]+%-[0-9a-f]+%-[0-9a-f]+%-[0-9a-f]+)"%):InvokeServer%("([0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]%-[0-9a-f]+%-[0-9a-f]+%-[0-9a-f]+%-[0-9a-f]+)"'
                    )
                    if not match or not match2 then
                      return nil
                    end
                    return {
                      remote = match,
                      token = match2,
                    }
                  end
                  local function getValue3()
                    local items = {
                      steal = getValue14("Classes.PlotClient.AnimalPrompt"),
                      buy = getValue14("Controllers.AnimalController"),
                      ap = getValue2(),
                    }
                    local xenSigs = {}
                    for k, item in pairs(xenSigsSet) do
                      item = items[k] or item
                      xenSigs[k] = item
                    end
                    _G.XenSigs = xenSigs
                    _G.XenSigsDynamic = {
                      steal = items.steal ~= nil,
                      buy = items.buy ~= nil,
                      ap = items.ap ~= nil,
                    }
                    if items.steal and items.buy and items.ap then
                      genv.__xenSigs = xenSigs
                      genv.__xenSigsPV = game.PlaceVersion
                    end
                    return _G.XenSigs
                  end
                  _G.XenSigsRefresh = function()
                    genv.__xenSigs = nil
                    genv.__xenSigsPV = nil
                    return getValue3()
                  end
                  if not (_G.XenSigs and _G.XenSigs.steal and _G.XenSigs.buy and _G.XenSigs.ap) then
                    task.spawn(function()
                      pcall(getValue3)
                    end)
                  end
                end
              end
              local band, bor, bxor, bnot, rrotate, rshift, lshift
              netFolder = enumValues.ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")
              remoteHashSecret = nil
              decodeRemotePath = function(data)
                local items = {}
                local amount = 1
                for i = 1, #data do
                  local state = data:byte(i)
                  if state == 92 then
                    items[#items + 1] = "/"
                  else
                    local calculatedValue = #items + 1
                    items[calculatedValue] =
                      string.char((state - 32 + game.JobId:byte((amount - 1) % 36 + 1) % 95) % 95 + 32)
                    amount += 1
                  end
                end
                return table.concat(items)
              end
              do
                local snapshot = bit32
                band = snapshot.band
                bor = snapshot.bor
                bxor = snapshot.bxor
                bnot = snapshot.bnot
                rrotate = snapshot.rrotate
                rshift = snapshot.rshift
                lshift = snapshot.lshift
              end
              local items14 = {
                1116352408,
                1899447441,
                3049323471,
                3921009573,
                961987163,
                1508970993,
                2453635748,
                2870763221,
                3624381080,
                310598401,
                607225278,
                1426881987,
                1925078388,
                2162078206,
                2614888103,
                3248222580,
                3835390401,
                4022224774,
                264347078,
                604807628,
                770255983,
                1249150122,
                1555081692,
                1996064986,
                2554220882,
                2821834349,
                2952996808,
                3210313671,
                3336571891,
                3584528711,
                113926993,
                338241895,
                666307205,
                773529912,
                1294757372,
                1396182291,
                1695183700,
                1986661051,
                2177026350,
                2456956037,
                2730485921,
                2820302411,
                3259730800,
                3345764771,
                3516065817,
                3600352804,
                4094571909,
                275423344,
                430227734,
                506948616,
                659060556,
                883997877,
                958139571,
                1322822218,
                1537002063,
                1747873779,
                1955562222,
                2024104815,
                2227730452,
                2361852424,
                2428436474,
                2756734187,
                3204031479,
                3329325298,
              }
              local function getValue(data)
                return band(data, 4294967295)
              end
              computeSha256Binary = function(data)
                local items15 = {
                  1779033703,
                  3144134277,
                  1013904242,
                  2773480762,
                  1359893119,
                  2600822924,
                  528734635,
                  1541459225,
                }
                local state = #data
                local text = data .. ""
                while #text % 64 ~= 56 do
                  text ..= "\0"
                end
                local calculatedValue = state * 8
                local items2 = {}
                for i = 8, 1, -1 do
                  items2[i] = string.char(calculatedValue % 256)
                  calculatedValue = math.floor(calculatedValue / 256)
                end
                local text2 = text .. table.concat(items2)
                for i = 1, #text2, 64 do
                  local items16 = {}
                  for i2 = 0, 15 do
                    local state, state2, state3, state4 = string.byte(text2, i + i2 * 4, i + i2 * 4 + 3)
                    items16[i2] = bor(lshift(state, 24), lshift(state2, 16), lshift(state3, 8), state4)
                  end
                  for i2 = 16, 63 do
                    local entry = items16[i2 - 15]
                    local entry2 = items16[i2 - 2]
                    items16[i2] = getValue(
                      items16[i2 - 16]
                        + bxor(rrotate(entry, 7), rrotate(entry, 18), rshift(entry, 3))
                        + items16[i2 - 7]
                        + bxor(rrotate(entry2, 17), rrotate(entry2, 19), rshift(entry2, 10))
                    )
                  end
                  local entry9 = items15[1]
                  local entry2 = items15[2]
                  local entry3 = items15[3]
                  local entry4 = items15[4]
                  local entry5 = items15[5]
                  local entry6 = items15[6]
                  local entry7 = items15[7]
                  local entry8 = items15[8]
                  for i2 = 0, 63 do
                    local entry10 = items14[i2 + 1]
                    local state = getValue(
                      entry8
                        + bxor(rrotate(entry5, 6), rrotate(entry5, 11), rrotate(entry5, 25))
                        + bxor(band(entry5, entry6), band(bnot(entry5), entry7))
                        + entry10
                        + items16[i2]
                    )
                    local state2 = getValue(
                      bxor(rrotate(entry9, 2), rrotate(entry9, 13), rrotate(entry9, 22))
                        + bxor(band(entry9, entry2), band(entry9, entry3), band(entry2, entry3))
                    )
                    local state3 = getValue(entry4 + state)
                    entry8 = entry7
                    entry4 = entry3
                    entry7 = entry6
                    entry3 = entry2
                    entry6 = entry5
                    entry2 = entry9
                    entry5 = state3
                    entry9 = getValue(state + state2)
                  end
                  items15[1] = getValue(items15[1] + entry9)
                  items15[2] = getValue(items15[2] + entry2)
                  items15[3] = getValue(items15[3] + entry3)
                  items15[4] = getValue(items15[4] + entry4)
                  items15[5] = getValue(items15[5] + entry5)
                  items15[6] = getValue(items15[6] + entry6)
                  items15[7] = getValue(items15[7] + entry7)
                  items15[8] = getValue(items15[8] + entry8)
                end
                local items3 = {}
                for i = 1, 8 do
                  local entry = items15[i]
                  items3[i] = string.char(
                    band(rshift(entry, 24), 255),
                    band(rshift(entry, 16), 255),
                    band(rshift(entry, 8), 255),
                    band(entry, 255)
                  )
                end
                return table.concat(items3)
              end
            end
            do
              local hashOf
              do
                local items = {}
                local function xnSha256(data)
                  local entry = items[data]
                  if entry then
                    return entry
                  end
                  local success, callResult = pcall(computeSha256Binary, data)
                  if not success or type(callResult) ~= "string" then
                    return nil
                  end
                  local text = callResult:gsub(".", function(data)
                    return string.format("%02x", string.byte(data))
                  end)
                  items[data] = text
                  return text
                end
                _G._xnSha256 = xnSha256
                hashOf = function(data)
                  if not remoteHashSecret then
                    return nil
                  end
                  local text = remoteHashSecret .. game.JobId
                  return xnSha256(decodeRemotePath(data) .. text)
                end
              end
              do
                local function getValue()
                  return "36bc48de-ccc6-4666-af4b-7d3bd46d6aa7"
                end
                remoteHashSecret = getValue()
                local items = {}
                local function xenGetRemote(data, data2)
                  local text = data2 == "RemoteFunction" and "RemoteFunction"
                  local text2
                  if text then
                    text2 = text
                  else
                    text2 = data2 == "UnreliableRemoteEvent" and "UnreliableRemoteEvent"
                  end
                  text2 = text2 or "RemoteEvent"
                  if type(data) ~= "string" or data == "" then
                    return nil
                  end
                  local match = data:match("^R[EF]/(.+)$") or data:match("^URE/(.+)$") or data
                  local text4 = text2 .. "|" .. match
                  local entry = items[text4]
                  if entry and entry.Parent then
                    return entry
                  end
                  items[text4] = nil
                  if not remoteHashSecret then
                    remoteHashSecret = getValue()
                  end
                  local state = hashOf(match)
                  if not state then
                    return nil
                  end
                  local isConditionMet = text2 == "RemoteFunction" and {
                    "RF/",
                    "RE/",
                  } or text2 == "UnreliableRemoteEvent" and {
                    "URE/",
                    "RE/",
                  } or {
                    "RE/",
                    "RF/",
                    "URE/",
                  }
                  for _, item in ipairs(isConditionMet) do
                    local state = netFolder:FindFirstChild(item .. state)
                    if state then
                      items[text4] = state
                      return state
                    end
                  end
                  return nil
                end
                _G.XenNet = {
                  RemoteEvent = function(data, data2)
                    return xenGetRemote(data2, "RemoteEvent")
                  end,
                  RemoteFunction = function(data, data2)
                    return xenGetRemote(data2, "RemoteFunction")
                  end,
                  UnreliableRemoteEvent = function(data, data2)
                    return xenGetRemote(data2, "UnreliableRemoteEvent")
                  end,
                }
                _G.XenGetRemote = xenGetRemote
                _G.Resolve = xenGetRemote
                _G.HashOf = hashOf
                _G.NetSecret = function()
                  return remoteHashSecret
                end
                local callback = clonefunction(Instance.new("RemoteEvent").FireServer)
                _G.RawFire = function(data, ...)
                  local state = xenGetRemote(data)
                  if not state then
                    return false
                  end
                  callback(state, ...)
                  return true
                end
                task.spawn(function()
                  while true do
                    task.wait(10)
                    if not (remoteHashSecret and xenGetRemote("RE/UseItem")) then
                      remoteHashSecret = getValue()
                      items = {}
                    end
                  end
                end)
              end
            end
            movementPlayersService = enumValues.Players
            routeRunService = enumValues.RunService
            PathfindingService = enumValues.PathfindingService
            localPlayer2 = movementPlayersService.LocalPlayer
            waypointArrivalRadius = 3
            maxVerticalSpeed = 60
            pathClearance = 20
            equipTeleportTool = function()
              local character = localPlayer2.Character
              local humanoid = character and character:FindFirstChildOfClass("Humanoid")
              if not humanoid then
                return
              end
              local backpack = localPlayer2:FindFirstChild("Backpack")
              local state
              if character then
                state = character:FindFirstChild(_G.TPSpeedItem or "Flying Carpet")
              else
                state = character
              end
              local instance
              if state then
                instance = state
              elseif backpack then
                instance = backpack:FindFirstChild(_G.TPSpeedItem or "Flying Carpet")
              else
                instance = backpack
              end
              if instance and instance:IsA("Tool") and instance.Parent ~= character then
                pcall(function()
                  humanoid:EquipTool(instance)
                end)
              end
            end
            do
              local function findTarget(childName)
                local character = localPlayer2.Character
                local backpack = localPlayer2:FindFirstChild("Backpack")
                return character and character:FindFirstChild(childName)
                  or backpack and backpack:FindFirstChild(childName)
              end
              equipRoutingTools = function()
                local xenNet = _G.XenNet
                local now2 = os.clock()
                while not findTarget("Grapple Hook") and os.clock() - now2 < 5 do
                  routeRunService.Heartbeat:Wait()
                end
                local character = localPlayer2.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                if not character or not humanoid then
                  return nil
                end
                local now3 = os.clock()
                while true do
                  local character2 = localPlayer2.Character
                  if not (character2 and character2:FindFirstChild("Grapple Hook")) then
                    local grappleHook = findTarget("Grapple Hook")
                    local humanoid2 = character2 and character2:FindFirstChildOfClass("Humanoid")
                    if grappleHook and humanoid2 then
                      pcall(function()
                        humanoid2:EquipTool(grappleHook)
                      end)
                    end
                    _G._tuff_RunService.Heartbeat:Wait()
                    if not (os.clock() - now3 > 1) then
                      continue
                    end
                  end
                  break
                end
                task.wait(0.015)
                if xenNet and localPlayer2.Character and localPlayer2.Character:FindFirstChild("Grapple Hook") then
                  pcall(function()
                    local entry = enumValues.ReplicatedStorage
                      :WaitForChild("Packages")
                      :WaitForChild("Net")
                      :GetChildren()[tonumber(_G.XenUseItemIndex) or 208]
                    if entry and entry:IsA("RemoteEvent") then
                      entry:FireServer(0)
                    end
                  end)
                end
                task.wait(0.06)
                local humanoid2 = localPlayer2.Character and localPlayer2.Character:FindFirstChildOfClass("Humanoid")
                if humanoid2 then
                  pcall(function()
                    humanoid2:UnequipTools()
                  end)
                end
                task.wait(0.05)
                local now4 = os.clock()
                while true do
                  equipTeleportTool()
                  local character2 = localPlayer2.Character
                  if character2 then
                    character2 = character2:FindFirstChild(_G.TPSpeedItem or "Flying Carpet")
                  end
                  if not character2 then
                    routeRunService.Heartbeat:Wait()
                    if not (os.clock() - now4 > 1) then
                      continue
                    end
                  end
                  break
                end
              end
            end
            stopRootMotion = function(rootPart)
              if rootPart then
                rootPart.AssemblyLinearVelocity = Vector3.zero
                rootPart.AssemblyAngularVelocity = Vector3.zero
              end
            end
            suppressCharacterAnimations = function()
              local function findTarget(instance)
                if not instance then
                  return
                end
                local humanoid = instance:FindFirstChildOfClass("Humanoid")
                local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
                if animator then
                  local success, callResult = pcall(function()
                    return animator:GetPlayingAnimationTracks()
                  end)
                  if success and callResult then
                    for _, item in ipairs(callResult) do
                      pcall(function()
                        item:Stop(0)
                      end)
                    end
                  end
                end
                local animate = instance:FindFirstChild("Animate")
                if animate then
                  pcall(function()
                    animate.Disabled = true
                  end)
                end
              end
              findTarget(localPlayer2.Character)
              local connection = routeRunService.Heartbeat:Connect(function()
                findTarget(localPlayer2.Character)
              end)
              return function()
                task.spawn(function()
                  local now2 = tick()
                  while true do
                    if tick() - now2 < 30 then
                      if not localPlayer2:GetAttribute("Stealing") then
                        task.wait(0.05)
                        continue
                      end
                      break
                    else
                      break
                    end
                  end
                  if connection then
                    connection:Disconnect()
                  end
                  local character = localPlayer2.Character
                  local isConditionMet = character and character:FindFirstChild("Animate")
                  if isConditionMet then
                    pcall(function()
                      isConditionMet.Disabled = false
                    end)
                  end
                end)
              end
            end
            cardinalDirections = {}
            do
              local vector = Vector3.new(1, 0, 0)
              local vector2 = Vector3.new(-1, 0, 0)
              local vector3 = Vector3.new(0, 0, 1)
              local state = -1
              cardinalDirections[1] = vector
              cardinalDirections[2] = vector2
              cardinalDirections[3] = vector3
              cardinalDirections[4] = Vector3.new(0, 0, state)
            end
            do
              local items = {
                ["structure base home"] = true,
                Wall = true,
                Floor = true,
                ["Roof"] = true,
                PlotSign = true,
              }
              local items2 = {
                DeliveryHitbox = true,
                StealHitbox = true,
                ["Base"] = true,
                AnimalTarget = true,
                Multiplier = true,
                Laser = true,
                Hitbox = true,
                Spawn = true,
                MainRoot = true,
                SecondFloor = true,
                ["ThirdFloor"] = true,
                Slope = true,
              }
              local items3 = {
                ["structure base home"] = true,
                PlotSign = true,
              }
              local function handleState(instance)
                for _, descendant in ipairs(instance:GetDescendants()) do
                  if descendant:IsA("BasePart") and items3[descendant.Name] and not descendant.CanQuery then
                    pcall(function()
                      descendant.CanQuery = true
                    end)
                  end
                end
              end
              task.spawn(function()
                local plots_2 = workspace:WaitForChild("Plots", 10)
                if not plots_2 then
                  return
                end
                pcall(handleState, plots_2)
                plots_2.DescendantAdded:Connect(function(descendant)
                  if descendant:IsA("BasePart") and items3[descendant.Name] and not descendant.CanQuery then
                    pcall(function()
                      descendant.CanQuery = true
                    end)
                  end
                end)
              end)
              isStrictObstacle = function(part)
                if not part then
                  return false
                end
                if items2[part.Name] then
                  return false
                end
                if part.CanCollide then
                  return true
                end
                if items[part.Name] then
                  return true
                end
                local size = part.Size
                if size and math.max(size.X * size.Y, size.X * size.Z, size.Y * size.Z) > 150 then
                  return true
                end
                return false
              end
              isLooseObstacle = function(part)
                if not part then
                  return false
                end
                if items2[part.Name] then
                  return false
                end
                if part.CanCollide then
                  return true
                end
                if items[part.Name] then
                  return true
                end
                local size = part.Size
                if size then
                  size = math.max(size.X * size.Y, size.X * size.Z, size.Y * size.Z) > 30
                end
                if size then
                  return true
                end
                return false
              end
            end
          end
          local state6, findTarget9
          do
            local getValue15, routeGeometry, getValue22
            getValue15 = function(data, data2, data3)
              local isConditionMet = data3 or isStrictObstacle
              local raycastParams = RaycastParams.new()
              raycastParams.FilterType = enumValues.excludeRaycastFilter
              raycastParams.IgnoreWater = true
              local filterDescendantsInstances = {}
              for _, player in ipairs(movementPlayersService:GetPlayers()) do
                if player.Character then
                  filterDescendantsInstances[#filterDescendantsInstances + 1] = player.Character
                end
              end
              for i = 1, 16 do
                raycastParams.FilterDescendantsInstances = filterDescendantsInstances
                local vector = data2 - data
                if vector.Magnitude < 0.05 then
                  return nil
                end
                local hit = workspace:Raycast(data, vector, raycastParams)
                if not hit then
                  return nil
                end
                if isConditionMet(hit.Instance) then
                  return hit
                end
                filterDescendantsInstances[#filterDescendantsInstances + 1] = hit.Instance
                data = hit.Position + vector.Unit * 0.3
              end
              return nil
            end
            routeGeometry = {
              CX0 = -458,
              CX1 = -362,
              CZ0 = -40,
              CZ1 = 125,
              ZN = 205,
              ZS = -95,
              XW = -525,
              XE = -295,
              SPLIT = -410,
            }
            do
              local bases = {}
              local vector = Vector3.new(-476.52, -2, 220.94090270996094)
              local vector2 = Vector3.new(-476.52, -2, 113.41409301757812)
              local vector3 = Vector3.new(-476.52, -2, 6.178487777709961)
              local vector4 = Vector3.new(-476.52, -2, -101.07275390625)
              local vector5 = Vector3.new(-342.66, -2, 221.44737243652344)
              local vector6 = Vector3.new(-342.66, -2, 113.41409301757812)
              local vector7 = Vector3.new(-342.66, -2, 6.249461650848389)
              local state20 = -99.73458862304688
              bases[1] = vector
              bases[2] = vector2
              bases[3] = vector3
              bases[4] = vector4
              bases[5] = vector5
              bases[6] = vector6
              bases[7] = vector7
              bases[8] = Vector3.new(-342.66, -2, state20)
              routeGeometry.BASES = bases
            end
            routeGeometry.inCenter = function(data, data2)
              return data >= routeGeometry.CX0
                and data <= routeGeometry.CX1
                and data2 >= routeGeometry.CZ0
                and data2 <= routeGeometry.CZ1
            end
            routeGeometry.nearestBase = function(vectorLocal455)
              local huge = math.huge
              local state21 = nil
              for i = 1, 8 do
                local vectorLocal456 = routeGeometry.BASES[i]
                local calculatedValue = (vectorLocal455.X - vectorLocal456.X) ^ 2
                  + (vectorLocal455.Z - vectorLocal456.Z) ^ 2
                if calculatedValue < huge then
                  huge = calculatedValue
                  state21 = i
                end
              end
              if not (huge > 4900) then
                return state21
              end
              return nil
            end
            routeGeometry.hitsOtherBase = function(vector, vector2, data, data2)
              local isConditionMet = tonumber(_G.XenRowBoxX) or 26
              local num = tonumber(_G.XenRowBoxZ) or 30
              for i = 0, 24 do
                local calculatedValue = i / 24
                local calculatedValue2 = vector.X + (vector2.X - vector.X) * calculatedValue
                local calculatedValue3 = vector.Z + (vector2.Z - vector.Z) * calculatedValue
                for i2 = 1, 8 do
                  if i2 ~= data and i2 ~= data2 then
                    local vector = routeGeometry.BASES[i2]
                    if
                      math.abs(calculatedValue2 - vector.X) <= isConditionMet
                      and math.abs(calculatedValue3 - vector.Z) <= num
                    then
                      return true
                    end
                  end
                end
              end
              return false
            end
            segmentCrossesPortal = function(vector, vector2)
              if routeGeometry.inCenter(vector.X, vector.Z) or routeGeometry.inCenter(vector2.X, vector2.Z) then
                return true
              end
              for i = 1, 10 do
                local calculatedValue = i / 11
                if
                  routeGeometry.inCenter(
                    vector.X + (vector2.X - vector.X) * calculatedValue,
                    vector.Z + (vector2.Z - vector.Z) * calculatedValue
                  )
                then
                  return true
                end
              end
              return false
            end
            isPathClear = function(data, data2)
              return getValue15(data, data2) == nil and not segmentCrossesPortal(data, data2)
            end
            do
              local function getValue16(data, data2)
                return getValue15(data, data2, isLooseObstacle) == nil
              end
              getValue22 = function(vectorLocal457, vector2Local480)
                if not isPathClear(vectorLocal457, vector2Local480) then
                  return false
                end
                if not getValue16(vectorLocal457, vector2Local480) then
                  return false
                end
                local vector =
                  Vector3.new(vector2Local480.X - vectorLocal457.X, 0, vector2Local480.Z - vectorLocal457.Z)
                if vector.Magnitude < 0.1 then
                  return true
                end
                local unit = Vector3.new(-vector.Z, 0, vector.X).Unit
                for _, item in ipairs({
                  1.5,
                  3,
                  6,
                  9,
                }) do
                  local calculatedValue = unit * item
                  if
                    not (
                      getValue16(vectorLocal457 + calculatedValue, vector2Local480 + calculatedValue)
                      and getValue16(vectorLocal457 - calculatedValue, vector2Local480 - calculatedValue)
                    )
                  then
                    return false
                  end
                end
                local vector2 = Vector3.new(0, 14, 0)
                return getValue16(vectorLocal457 + vector2, vector2Local480 + vector2)
                  and getValue16(vectorLocal457 - vector2, vector2Local480 - vector2)
              end
            end
            do
              local function getValue17(data)
                if #data <= 2 then
                  return data
                end
                local items = {
                  data[1],
                }
                local amount = 1
                while amount < #data do
                  local state = #data
                  while state > amount + 1 and not getValue22(items[#items], data[state]) do
                    state -= 1
                  end
                  items[#items + 1] = data[state]
                  amount = state
                end
                return items
              end
              local function getValue23(data)
                if #data <= 2 then
                  return data
                end
                local snapshot = pathClearance
                local items = {
                  data[1],
                }
                for i = 2, #data - 1 do
                  local entry = data[i]
                  local vector = Vector3.zero
                  for _, item in ipairs(cardinalDirections) do
                    local rootPart = getValue15(entry, entry + item * snapshot, isStrictObstacle)
                    if rootPart then
                      local magnitude = (rootPart.Position - entry).Magnitude
                      if magnitude < snapshot then
                        vector -= item * (snapshot - magnitude)
                      end
                    end
                  end
                  if vector.Magnitude > 0.1 then
                    if 18 < vector.Magnitude then
                      vector = vector.Unit * 18
                    end
                    local calculatedValue = entry + vector
                    if isPathClear(items[#items], calculatedValue) then
                      items[#items + 1] = calculatedValue
                    else
                      items[#items + 1] = entry
                    end
                  else
                    items[#items + 1] = entry
                  end
                end
                items[#items + 1] = data[#data]
                return items
              end
              routeGeometry.centerDetour = function(vectorLocal458, vector2, data)
                local items = {}
                local items2 = {
                  Vector3.new(vectorLocal458.X, data, routeGeometry.ZN),
                  Vector3.new(vector2.X, data, routeGeometry.ZN),
                }
                local items3 = {
                  Vector3.new(vectorLocal458.X, data, routeGeometry.ZS),
                  Vector3.new(vector2.X, data, routeGeometry.ZS),
                }
                local items4 = {
                  Vector3.new(routeGeometry.XW, data, vectorLocal458.Z),
                  Vector3.new(routeGeometry.XW, data, vector2.Z),
                }
                local xe = routeGeometry.XE
                local z = vector2.Z
                local items5 = {
                  Vector3.new(routeGeometry.XE, data, vectorLocal458.Z),
                  Vector3.new(xe, data, z),
                }
                items[1] = items2
                items[2] = items3
                items[3] = items4
                items[4] = items5
                local huge = math.huge
                local state, state2, state3 = ipairs(items)
                local state4 = nil
                for _, item in state, state2, state3 do
                  local entry = item[1]
                  local entry2 = item[2]
                  if
                    getValue22(vectorLocal458, entry)
                    and getValue22(entry, entry2)
                    and getValue22(entry2, vector2)
                  then
                    local calculatedValue = (vectorLocal458 - entry).Magnitude
                      + (entry - entry2).Magnitude
                      + (entry2 - vector2).Magnitude
                    if calculatedValue < huge then
                      state4 = {
                        entry,
                        entry2,
                      }
                      huge = calculatedValue
                    end
                  end
                end
                return state4
              end
              routeGeometry.rowDetour = function(vectorLocal459, vector2Local481, data)
                local state23 = routeGeometry.nearestBase(vectorLocal459)
                local state2 = routeGeometry.nearestBase(vector2Local481)
                if not routeGeometry.hitsOtherBase(vectorLocal459, vector2Local481, state23, state2) then
                  return nil
                end
                local x = routeGeometry.BASES[state2 or 1].X
                local isConditionMet = tonumber(_G.XenRowLane) or 30
                local items = {}
                items[#items + 1] = x < routeGeometry.SPLIT and x - isConditionMet or x + isConditionMet
                local isConditionMet2 = x < routeGeometry.SPLIT and x + isConditionMet or x - isConditionMet
                if not routeGeometry.inCenter(isConditionMet2, (vectorLocal459.Z + vector2Local481.Z) * 0.5) then
                  items[#items + 1] = isConditionMet2
                end
                local huge = math.huge
                local state3 = nil
                for _, item in ipairs(items) do
                  local vector = Vector3.new(item, data, vectorLocal459.Z)
                  local vector2 = Vector3.new(item, data, vector2Local481.Z)
                  if
                    getValue22(vectorLocal459, vector)
                    and getValue22(vector, vector2)
                    and getValue22(vector2, vector2Local481)
                    and not routeGeometry.hitsOtherBase(vector, vector2, state23, state2)
                  then
                    local calculatedValue = (vectorLocal459 - vector).Magnitude
                      + (vector - vector2).Magnitude
                      + (vector2 - vector2Local481).Magnitude
                    if calculatedValue < huge then
                      state3 = {
                        vector,
                        vector2,
                      }
                      huge = calculatedValue
                    end
                  end
                end
                return state3
              end
              buildDetourRoute = function(vector, data)
                local y = vector.Y
                local isActive = segmentCrossesPortal(vector, data) and not getValue22(vector, data)
                local collection = nil
                if isActive then
                  collection = routeGeometry.centerDetour(vector, data, y)
                  if collection and #collection > 0 then
                    vector = collection[#collection]
                  end
                end
                local collection2 = routeGeometry.rowDetour(vector, data, y)
                if not collection and not collection2 then
                  return nil
                end
                local items = {}
                if collection then
                  for _, item in ipairs(collection) do
                    items[#items + 1] = item
                  end
                end
                if collection2 then
                  for _, item in ipairs(collection2) do
                    items[#items + 1] = item
                  end
                end
                items[#items + 1] = data
                return items
              end
              computeFallbackRoute = function(position, tuffCurTarget, data)
                _G._tuff_curTarget = tuffCurTarget
                if getValue22(position, tuffCurTarget) then
                  return {
                    tuffCurTarget,
                  }
                end
                local state = buildDetourRoute(position, tuffCurTarget)
                if state then
                  return state
                end
                local vector2 = data and tuffCurTarget - data * 14 or tuffCurTarget
                local vector = Vector3.new(vector2.X, position.Y, vector2.Z)
                local state2 = PathfindingService:CreatePath({
                  AgentRadius = 12,
                  AgentHeight = 5,
                  AgentCanJump = true,
                  AgentJumpHeight = 10,
                  AgentMaxSlope = 89,
                })
                local items = {
                  position,
                }
                if
                  pcall(function()
                    state2:ComputeAsync(Vector3.new(position.X, position.Y, position.Z), vector)
                  end) and state2.Status == Enum.PathStatus.Success
                then
                  for _, item in ipairs(state2:GetWaypoints()) do
                    if (item.Position - position).Magnitude >= 8 then
                      items[#items + 1] = item.Position + Vector3.new(0, 3, 0)
                      position = item.Position
                    end
                  end
                end
                items[#items + 1] = vector2 + Vector3.new(0, 3, 0)
                local state3 = getValue23(items)
                local state4 = getValue17(state3)
                state4[#state4 + 1] = tuffCurTarget
                return state4
              end
            end
            moveAlongRoute = function(rootPart, collection, data, data2, data3, data4, data5)
              if not rootPart or not rootPart.Parent or #collection == 0 then
                return false
              end
              local isConditionMet = data or 400
              local tpEaseNodes = _G.TPEaseNodes or 2
              local amount = 0
              local state = #collection
              for i = math.max(1, state - tpEaseNodes), state - 1 do
                amount += (collection[i + 1] - collection[i]).Magnitude
              end
              if amount <= 0 then
                amount = 40
              end
              local amount2 = 1
              local isEnabled = false
              local isEnabled2 = false
              local connection = nil
              local function getValue(data)
                if isEnabled then
                  return
                end
                isEnabled = true
                if rootPart and rootPart.Parent then
                  rootPart.AssemblyLinearVelocity = Vector3.zero
                  rootPart.AssemblyAngularVelocity = Vector3.zero
                  if data ~= false then
                    local rotation, rotation2 = rootPart.CFrame:ToEulerAnglesYXZ()
                    rootPart.CFrame = CFrame.new(collection[#collection]) * CFrame.Angles(0, rotation2, 0)
                  end
                end
                if connection then
                  connection:Disconnect()
                end
              end
              local huge = math.huge
              local amount3 = 0
              if data3 then
                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = enumValues.excludeRaycastFilter
                raycastParams.IgnoreWater = true
                local filterDescendantsInstances = {}
                for _, player in ipairs(movementPlayersService:GetPlayers()) do
                  if player.Character then
                    filterDescendantsInstances[#filterDescendantsInstances + 1] = player.Character
                  end
                end
                raycastParams.FilterDescendantsInstances = filterDescendantsInstances
                for i = 1, 3 do
                  local vector2 = collection[amount2]
                  if not vector2 then
                    break
                  end
                  local vector = Vector3.new(vector2.X - rootPart.Position.X, 0, vector2.Z - rootPart.Position.Z)
                  local magnitude = vector.Magnitude
                  if magnitude < 1 then
                    break
                  end
                  local calculatedValue = rootPart.Position + vector.Unit * math.min(20, magnitude)
                  local hit = workspace:Raycast(rootPart.Position, calculatedValue - rootPart.Position, raycastParams)
                  if hit and hit.Instance and hit.Instance.CanCollide then
                    break
                  end
                  rootPart.CFrame = rootPart.CFrame - rootPart.CFrame.Position + calculatedValue
                  rootPart.AssemblyLinearVelocity = Vector3.zero
                  rootPart.AssemblyAngularVelocity = Vector3.zero
                  routeRunService.Heartbeat:Wait()
                  if not rootPart or not rootPart.Parent then
                    return
                  end
                end
              end
              connection = routeRunService.Heartbeat:Connect(function()
                if not rootPart or not rootPart.Parent or isEnabled then
                  if connection then
                    connection:Disconnect()
                  end
                  return
                end
                equipTeleportTool()
                local w = collection[amount2] - rootPart.Position
                local u = w.Magnitude
                if u < waypointArrivalRadius or amount2 < #collection and huge < 12 and u > huge + 0.02 then
                  amount2 += 1
                  if amount2 > #collection then
                    isEnabled2 = true
                    getValue()
                    return
                  end
                  huge, amount3 = math.huge, 0
                  w = collection[amount2] - rootPart.Position
                  u = w.Magnitude
                end
                amount3, huge = if u > huge - 0.05 then amount3 + 1 else 0, u
                if amount3 >= (data5 and 3 or 18) then
                  if data5 then
                    getValue(false)
                  else
                    getValue()
                  end
                  return
                end
                if u >= 0.1 then
                  local u = w.Unit
                  if data2 and w.Y > 5 and amount2 < #collection then
                    local w = rootPart.Parent and (rootPart.Parent:FindFirstChildOfClass("Humanoid"))
                    if w then
                      local t = w:GetState()
                      if t ~= Enum.HumanoidStateType.Jumping and t ~= Enum.HumanoidStateType.Freefall then
                        pcall(function()
                          w:ChangeState(Enum.HumanoidStateType.Jumping)
                        end)
                        pcall(function()
                          w.Jump = true
                        end)
                      end
                    end
                  end
                  local w = nil
                  if data4 and amount2 >= #collection - (tpEaseNodes - 1) then
                    local t = (collection[#collection] - rootPart.Position).Magnitude
                    w = if t < amount then isConditionMet * (0.25 + 0.75 * (t / amount)) else isConditionMet
                  else
                    w = isConditionMet
                  end
                  local t = u.Y * w
                  rootPart.Velocity =
                    Vector3.new(u.X * w, if t > maxVerticalSpeed then maxVerticalSpeed else t, u.Z * w)
                end
              end)
              local position = rootPart.Position
              local amount4 = 0
              for _, item in ipairs(collection) do
                amount4 += (position - item).Magnitude
                position = item
              end
              local calculatedValue = amount4 / math.min(400, isConditionMet) + 2
              local amount5 = 0
              while not isEnabled and amount5 < calculatedValue do
                task.wait(0.05)
                amount5 += 0.05
              end
              data5 = not isEnabled and data5
              if data5 then
                getValue(false)
              else
                getValue()
              end
              stopRootMotion(rootPart)
              return isEnabled2
            end
            routePlayersService = enumValues.Players
            state6 = enumValues.RunService
            localPlayer3 = routePlayersService.LocalPlayer
            _G.XenRouteGetRemote = function(data, data2)
              local xenNet = _G.XenNet
              if not xenNet then
                return nil
              end
              local text = data == "RemoteFunction" and "RemoteFunction"
              local isActive
              if text then
                isActive = text
              else
                isActive = data == "UnreliableRemoteEvent" and "UnreliableRemoteEvent"
              end
              local text2 = isActive or "RemoteEvent"
              local success, callResult = pcall(function()
                return xenNet[text2](xenNet, data2)
              end)
              return success and callResult or nil
            end
            routeIgnoredInstances = {}
            do
              local items = {
                "Flying Carpet",
                "Waverider",
                "Santa's Sleigh",
                "Witch's Broom",
                "Cupid's Wings",
              }
              local function findTarget10(childName)
                local character = localPlayer3.Character
                local backpack = localPlayer3:FindFirstChild("Backpack")
                return character and character:FindFirstChild(childName)
                  or backpack and backpack:FindFirstChild(childName)
              end
              local amount = 0
              findTarget9 = function()
                local character = localPlayer3.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                if not humanoid then
                  return nil
                end
                local tpSpeedItem = _G.TPSpeedItem
                if tpSpeedItem and tpSpeedItem ~= "" then
                  local state = character:FindFirstChild(tpSpeedItem)
                  return tpSpeedItem
                end
                for _, item in ipairs(items) do
                  local instance = character:FindFirstChild(item)
                  if instance and instance:IsA("Tool") then
                    return item
                  end
                end
                local now2 = os.clock()
                if now2 - amount < 0.5 then
                  return nil
                end
                amount = now2
                if tpSpeedItem and tpSpeedItem ~= "" then
                  local instance = findTarget10(tpSpeedItem)
                  if instance and instance:IsA("Tool") then
                    if instance.Parent ~= character then
                      pcall(function()
                        humanoid:EquipTool(instance)
                      end)
                    end
                    return tpSpeedItem
                  end
                end
                for _, item2 in ipairs(items) do
                  local instance = findTarget10(item2)
                  if instance and instance:IsA("Tool") then
                    if instance.Parent ~= character then
                      local function handleState()
                        humanoid:EquipTool(instance)
                      end
                      pcall(handleState)
                    end
                    return item2
                  end
                end
                return nil
              end
            end
          end
          local getValue3
          do
            local isActive = type(getconnections) == "function"
            getValue3 = function()
              local clampedValue = math.clamp(tonumber(_G.XenClimb) or 200, 100, 250)
              if not isActive then
                clampedValue = 55
              end
              return clampedValue
            end
          end
          do
            local function handleState6(rootPart)
              if rootPart then
                rootPart.AssemblyLinearVelocity = Vector3.zero
                rootPart.AssemblyAngularVelocity = Vector3.zero
              end
            end
            moveThroughRoute = function(rootPart, collection, data, data2, data3, data4)
              if not rootPart or not rootPart.Parent or #collection == 0 then
                return
              end
              local amount = 0
              local amount2 = 0
              local position = nil
              local isEnabled = false
              local num = tonumber(_G.XenRerouteMax) or 4
              local isConditionMet = data or _G.XenTPVelocity and math.clamp(_G.XenTPVelocity, 200, 600) or 280
              local amount3 = 1
              local isEnabled2 = false
              local connection = nil
              local function getValue()
                if isEnabled2 then
                  return
                end
                isEnabled2 = true
                if rootPart and rootPart.Parent then
                  rootPart.AssemblyLinearVelocity = Vector3.zero
                  rootPart.AssemblyAngularVelocity = Vector3.zero
                  local rotation, rotation2 = rootPart.CFrame:ToEulerAnglesYXZ()
                  rootPart.CFrame = CFrame.new(collection[#collection]) * CFrame.Angles(0, rotation2, 0)
                end
                if connection then
                  connection:Disconnect()
                end
              end
              local huge = math.huge
              local amount4 = 0
              local now2 = os.clock()
              connection = state6.Heartbeat:Connect(function()
                if not rootPart or not rootPart.Parent or isEnabled2 then
                  if connection then
                    connection:Disconnect()
                  end
                  return
                end
                if _G.XenTPStop then
                  getValue()
                  return
                end
                findTarget9()
                local w = collection[amount3]
                local u = w - rootPart.Position
                local t = u.Magnitude
                local M = os.clock() - now2
                local p = math.floor(M / 0.5)
                local g = if M - p * 0.5 < 0.15 then (math.max(60, isConditionMet - (50 + p * 10))) else isConditionMet
                if amount3 < #collection and t < 26 then
                  M = collection[amount3 + 1] - w
                  g = if t > 0.1 and M.Magnitude > 0.1 and u.Unit:Dot(M.Unit) < 0.9 then (math.min(g, 240)) else g
                end
                if _G.XenTPBrake and amount3 >= #collection then
                  M = math.clamp(tonumber(_G.XenTPBrakeDist) or 7.5, 5, 200)
                  g = if t < M then (math.max(70, g * (t / M))) else g
                end
                local B = g / 60
                if t < math.max(3, math.min(B * 1.25, tonumber(_G.XenTPArriveMax) or 7)) then
                  amount3 += 1
                  if amount3 > #collection then
                    getValue()
                    return
                  end
                  huge, amount4 = math.huge, 0
                  w = collection[amount3]
                  u = w - rootPart.Position
                  t = u.Magnitude
                end
                amount4, huge = if t > huge - 0.05 then amount4 + 1 else 0, t
                if amount4 >= 18 then
                  if amount < num and type(_G._m7_reroute) == "function" then
                    isEnabled, amount4 = true, 0
                    huge = math.huge
                  else
                    getValue()
                    return
                  end
                end
                if
                  not position or (rootPart.Position - position).Magnitude >= (tonumber(_G.XenLookAheadStuds) or 10)
                then
                  position = rootPart.Position
                  if (amount3 < #collection or t > 30) and amount < num and type(_G._m7_clear) == "function" then
                    if not _G._m7_clear(rootPart.Position, w) then
                      amount2 += 1
                      if amount2 >= 2 then
                        isEnabled, amount2 = true, 0
                      end
                    else
                      amount2 = 0
                    end
                  end
                end
                if t >= 0.1 then
                  local w = u.Unit
                  if (data2 or u.Y > 10) and u.Y > 5 and amount3 < #collection then
                    local u = rootPart.Parent and (rootPart.Parent:FindFirstChildOfClass("Humanoid"))
                    if u then
                      M = u:GetState()
                      if M ~= Enum.HumanoidStateType.Jumping and M ~= Enum.HumanoidStateType.Freefall then
                        pcall(function()
                          u:ChangeState(Enum.HumanoidStateType.Jumping)
                        end)
                        pcall(function()
                          u.Jump = true
                        end)
                      end
                    end
                  end
                  p = getValue3()
                  rootPart.Velocity = Vector3.new(
                    w.X * (if w.Y > 0 and w.Y * g > p then p / w.Y else g),
                    w.Y * (if w.Y > 0 and w.Y * g > p then p / w.Y else g),
                    w.Z * (if w.Y > 0 and w.Y * g > p then p / w.Y else g)
                  )
                end
              end)
              local position2 = rootPart.Position
              local amount5 = 0
              for _, item in ipairs(collection) do
                amount5 += (position2 - item).Magnitude
                position2 = item
              end
              local calculatedValue = amount5 / math.min(125, isConditionMet) + 2
              local amount6 = 0
              while not isEnabled2 and amount6 < calculatedValue do
                task.wait(0.05)
                amount6 += 0.05
                if _G.XenTPStop then
                  break
                end
                if not rootPart or not rootPart.Parent then
                  break
                end
                if isEnabled and not isEnabled2 then
                  isEnabled = false
                  local isActive = amount < num
                  if isActive then
                    isActive = type(_G._m7_reroute) == "function"
                  end
                  if isActive then
                    amount += 1
                    local entry = collection[#collection]
                    local success, callResult = pcall(_G._m7_reroute, rootPart.Position, entry, nil, data4)
                    if success and type(callResult) == "table" and #callResult > 0 and not isEnabled2 then
                      if 0.5 < (callResult[#callResult] - entry).Magnitude then
                        callResult[#callResult + 1] = entry
                      end
                      collection = callResult
                      amount3 = 1
                      huge = math.huge
                      amount4 = 0
                      amount2 = 0
                      if
                        #callResult >= 2
                        and type(_G._m7_clear) == "function"
                        and (rootPart.Position - callResult[1]).Magnitude > 8
                        and _G._m7_clear(rootPart.Position, callResult[2])
                      then
                        amount3 = 2
                      end
                      local position3 = rootPart.Position
                      local state, state2, state3 = ipairs(callResult)
                      local amount = 0
                      for _, item in state, state2, state3 do
                        amount += (position3 - item).Magnitude
                        position3 = item
                      end
                      calculatedValue = amount6 + amount / math.min(125, isConditionMet) + 2
                    end
                  end
                end
              end
              getValue()
              handleState6(rootPart)
            end
          end
        end
        local getValue24, m7Clear, getValue32, state24, getValue42, getValue5, getValue6, xenVoxelRoute, xenInCenterZone, xenSegmentCrossesCenter
        local xenFindRowDetour
        do
          local collection7, getValue18
          collection7 = {}
          do
            local vector = Vector3.new(1, 0, 0)
            local vector2 = Vector3.new(-1, 0, 0)
            local vector3 = Vector3.new(0, 0, 1)
            collection7[1] = vector
            collection7[2] = vector2
            collection7[3] = vector3
            collection7[4] = Vector3.new(0, 0, -1)
          end
          do
            local items = {
              ["structure base home"] = true,
              Wall = true,
              Floor = true,
              Roof = true,
            }
            local items2 = {
              DeliveryHitbox = true,
              ["StealHitbox"] = true,
              ["Base"] = true,
              ["AnimalTarget"] = true,
              ["Multiplier"] = true,
              Laser = true,
              ["Hitbox"] = true,
              Spawn = true,
              ["MainRoot"] = true,
              SecondFloor = true,
              ["ThirdFloor"] = true,
              Slope = true,
            }
            getValue18 = function(part)
              if not part then
                return false
              end
              if items2[part.Name] then
                return false
              end
              if part.CanCollide then
                return true
              end
              if items[part.Name] then
                return true
              end
              local size = part.Size
              if size and math.max(size.X * size.Y, size.X * size.Z, size.Y * size.Z) > 150 then
                return true
              end
              return false
            end
            getValue24 = function(part)
              if not part then
                return false
              end
              if items2[part.Name] then
                return false
              end
              if part.CanCollide then
                return true
              end
              if items[part.Name] then
                return true
              end
              local size = part.Size
              if size and math.max(size.X * size.Y, size.X * size.Z, size.Y * size.Z) > 30 then
                return true
              end
              return false
            end
          end
          local getValue25, getValue33, state25, getValue43
          getValue25 = function(data, data2, data3)
            local isConditionMet = data3 or getValue18
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = enumValues.excludeRaycastFilter
            raycastParams.IgnoreWater = true
            local filterDescendantsInstances = {}
            for _, player in ipairs(routePlayersService:GetPlayers()) do
              if player.Character then
                filterDescendantsInstances[#filterDescendantsInstances + 1] = player.Character
              end
            end
            for _, item in ipairs(routeIgnoredInstances) do
              filterDescendantsInstances[#filterDescendantsInstances + 1] = item
            end
            for i = 1, 16 do
              raycastParams.FilterDescendantsInstances = filterDescendantsInstances
              local vector = data2 - data
              if vector.Magnitude < 0.05 then
                return nil
              end
              local hit = workspace:Raycast(data, vector, raycastParams)
              if not hit then
                return nil
              end
              if isConditionMet(hit.Instance) then
                return hit
              end
              filterDescendantsInstances[#filterDescendantsInstances + 1] = hit.Instance
              data = hit.Position + vector.Unit * 0.3
            end
            return nil
          end
          m7Clear = function(data, data2)
            return getValue25(data, data2) == nil
          end
          getValue32 = function(data)
            local amount = 0
            local entry = data[1]
            for i = 2, #data do
              amount += (data[i] - entry).Magnitude
              entry = data[i]
            end
            return amount
          end
          state24 = enumValues.PathfindingService
          getValue33 = function(data, data2)
            return getValue25(data, data2, getValue24) == nil
          end
          state25 = nil
          do
            local function getValue19(data)
              if _G.XenStrictSweep == false then
                return getValue18(data)
              end
              return getValue24(data)
            end
            getValue43 = function(data, data2)
              local raycastParams = RaycastParams.new()
              raycastParams.FilterType = enumValues.excludeRaycastFilter
              raycastParams.IgnoreWater = true
              local filterDescendantsInstances = {}
              for _, player in ipairs(routePlayersService:GetPlayers()) do
                if player.Character then
                  filterDescendantsInstances[#filterDescendantsInstances + 1] = player.Character
                end
              end
              for _, item in ipairs(routeIgnoredInstances) do
                filterDescendantsInstances[#filterDescendantsInstances + 1] = item
              end
              local snapshot = data
              for i = 1, 24 do
                raycastParams.FilterDescendantsInstances = filterDescendantsInstances
                local vector = data2 - snapshot
                if vector.Magnitude < 0.05 then
                  return false
                end
                local state26 = nil
                if
                  not pcall(function()
                    state26 = workspace:Spherecast(snapshot, 4, vector, raycastParams)
                  end)
                then
                  state25 = false
                  return nil
                end
                if not state26 then
                  return false
                end
                if getValue19(state26.Instance) then
                  return true
                end
                filterDescendantsInstances[#filterDescendantsInstances + 1] = state26.Instance
                local calculatedValue = (state26.Distance or 0) - 0.05
                if calculatedValue > 0 then
                  snapshot += vector.Unit * math.min(calculatedValue, vector.Magnitude)
                end
              end
              return true
            end
          end
          do
            local function getValue(data, data2, data3, data4)
              if state25 == nil then
                state25 = pcall(function()
                  workspace:Spherecast(Vector3.new(0, 10000, 0), 1, Vector3.new(0, -1, 0), RaycastParams.new())
                end)
              end
              if not state25 then
                return nil
              end
              local vector = data2 - data
              local magnitude = vector.Magnitude
              if magnitude < 0.1 then
                return false
              end
              local calculatedValue = vector / magnitude
              local calculatedValue2 = data + calculatedValue * math.min(data3 or 6, magnitude * 0.35)
              local calculatedValue3 = data2 - calculatedValue * math.min(data4 or 6, magnitude * 0.4)
              local state = getValue43(calculatedValue2, calculatedValue3)
              if state == nil then
                return nil
              end
              if state then
                return true
              end
              local state2 = getValue43(calculatedValue3, calculatedValue2)
              if state2 == nil then
                return nil
              end
              return state2
            end
            getValue42 = function(vectorLocal460, vector2Local482, data, data2)
              if not m7Clear(vectorLocal460, vector2Local482) then
                return false
              end
              local state = getValue(vectorLocal460, vector2Local482, data, data2)
              if state ~= nil then
                return not state
              end
              local vector = Vector3.new(vector2Local482.X - vectorLocal460.X, 0, vector2Local482.Z - vectorLocal460.Z)
              if vector.Magnitude < 0.1 then
                local vector2 = Vector3.new(16, 0, 0)
                local vector3 = Vector3.new(0, 0, 16)
                return getValue33(vectorLocal460 + vector2, vector2Local482 + vector2)
                  and getValue33(vectorLocal460 - vector2, vector2Local482 - vector2)
                  and getValue33(vectorLocal460 + vector3, vector2Local482 + vector3)
                  and getValue33(vectorLocal460 - vector3, vector2Local482 - vector3)
              end
              local calculatedValue = Vector3.new(-vector.Z, 0, vector.X).Unit * 16
              local vector2 = Vector3.new(0, 16, 0)
              return getValue33(vectorLocal460 + calculatedValue, vector2Local482 + calculatedValue)
                and getValue33(vectorLocal460 - calculatedValue, vector2Local482 - calculatedValue)
                and getValue33(vectorLocal460 + vector2, vector2Local482 + vector2)
                and getValue33(vectorLocal460 - vector2, vector2Local482 - vector2)
            end
          end
          getValue5 = function(data)
            if #data <= 2 then
              return data
            end
            local items = {
              data[1],
            }
            local amount = 1
            local state = #data
            while amount < state do
              local snapshot = state
              while amount + 1 < snapshot do
                if
                  not getValue42(items[#items], data[snapshot], amount == 1 and 6 or 0, snapshot == state and 6 or 0)
                then
                  snapshot -= 1
                  continue
                end
                break
              end
              items[#items + 1] = data[snapshot]
              amount = snapshot
            end
            return items
          end
          getValue6 = function(data)
            if #data <= 2 then
              return data
            end
            local items = {
              data[1],
            }
            for i = 2, #data - 1 do
              local entry = data[i]
              local vector = Vector3.zero
              for _, item in ipairs(collection7) do
                local rootPart = getValue25(entry, entry + item * 8, getValue18)
                if rootPart then
                  local magnitude = (rootPart.Position - entry).Magnitude
                  if magnitude < 8 then
                    vector -= item * (8 - magnitude)
                  end
                end
              end
              local rootPart = getValue25(entry, entry + Vector3.new(0, 8, 0), getValue18)
              if rootPart then
                local magnitude = (rootPart.Position - entry).Magnitude
                if magnitude < 4 then
                  vector += Vector3.new(0, -(4 - magnitude), 0)
                end
              end
              if vector.Magnitude > 0.1 then
                if vector.Magnitude > 12 then
                  vector = vector.Unit * 16
                end
                local calculatedValue = entry + vector
                if m7Clear(items[#items], calculatedValue) then
                  items[#items + 1] = calculatedValue
                else
                  items[#items + 1] = entry
                end
              else
                items[#items + 1] = entry
              end
            end
            items[#items + 1] = data[#data]
            return items
          end
        end
        do
          local floor2, min, max, overlapParams, raycastParams, vectorLocal461, state27, state2, state3, state4
          local state5, state6, state7, getValue20, getValue26
          do
            local sqrt, getValue21, getValue27, getValue3, state, getValue4, getValue5, getValue6
            floor2 = math.floor
            sqrt = math.sqrt
            min = math.min
            max = math.max
            do
              local function getValue28(data)
                return data < 0 and -data or data
              end
              overlapParams = OverlapParams.new()
              overlapParams.FilterType = enumValues.excludeRaycastFilter
              overlapParams.RespectCanCollide = true
              raycastParams = RaycastParams.new()
              raycastParams.FilterType = enumValues.excludeRaycastFilter
              raycastParams.RespectCanCollide = true
              raycastParams.IgnoreWater = true
              vectorLocal461 = nil
              state27 = 0
              state2 = 0
              state3 = 0
              state4 = 4
              state5 = 2.5
              state6 = {}
              state7 = 5
              getValue21 = function(data, data2, data3, data4)
                local calculatedValue = data * 0.5
                return Vector3.new(
                  vectorLocal461.X + data2 * data + calculatedValue,
                  vectorLocal461.Y + data3 * data + calculatedValue,
                  vectorLocal461.Z + data4 * data + calculatedValue
                )
              end
              getValue27 = function(data, data2, data3)
                return data + data2 * 1024 + data3 * 1048576
              end
              getValue3 = function(data, data2, data3)
                if data < 0 or data2 < 0 or data3 < 0 or data >= state27 or data2 >= state2 or data3 >= state3 then
                  return true
                end
                local state = getValue27(data, data2, data3)
                local entry = state6[state]
                if entry ~= nil then
                  return entry
                end
                local calculatedValue = state4 * 0.5
                local calculatedValue2 = vectorLocal461.X + data * state4 + calculatedValue
                local calculatedValue3 = vectorLocal461.Y + data2 * state4 + calculatedValue
                local calculatedValue4 = vectorLocal461.Z + data3 * state4 + calculatedValue
                local calculatedValue5 = state4 + state5
                local isActive = state7 > state4 and state7 or state4
                local isActive2 = #workspace:GetPartBoundsInBox(
                  CFrame.new(calculatedValue2, calculatedValue3 - calculatedValue + isActive * 0.5, calculatedValue4),
                  Vector3.new(calculatedValue5, isActive, calculatedValue5),
                  overlapParams
                ) > 0
                state6[state] = isActive2
                return isActive2
              end
              getValue20 = function(data, data2, data3, data4, data5)
                local vector = data2 - data
                local magnitude = vector.Magnitude
                if magnitude < 0.05 then
                  return true
                end
                if workspace:Raycast(data, vector, raycastParams) then
                  return false
                end
                local isActive = data3 > 1 and data3 or 1
                if
                  workspace:Blockcast(
                    CFrame.new(data),
                    Vector3.new(isActive * 2, data4, isActive * 2),
                    vector,
                    raycastParams
                  ) ~= nil
                then
                  return false
                end
                local state = floor2(magnitude)
                if data5 ~= false and state >= 2 then
                  local calculatedValue = vector / state
                  local vector = Vector3.new(isActive * 2, 3, isActive * 2)
                  for i = 1, state - 1 do
                    if
                      #workspace:GetPartBoundsInBox(CFrame.new(data + calculatedValue * i), vector, overlapParams) > 0
                    then
                      return false
                    end
                  end
                end
                return true
              end
              state = {}
              for i = -1, 1 do
                for i2 = -1, 1 do
                  for i3 = -1, 1 do
                    if i ~= 0 or i2 ~= 0 or i3 ~= 0 then
                      local calculatedValue = (i ~= 0 and 1 or 0) + (i2 ~= 0 and 1 or 0)
                      local isConditionMet = i3 ~= 0 and 1 or 0
                      local calculatedValue2 = i + i2 * 1024 + i3 * 1048576
                      local calculatedValue3 = #state + 1
                      local items = {}
                      local state28 = sqrt(i * i + i2 * i2 + i3 * i3)
                      items[1] = i
                      items[2] = i2
                      items[3] = i3
                      items[4] = state28
                      items[5] = calculatedValue + isConditionMet
                      items[6] = calculatedValue2
                      state[calculatedValue3] = items
                    end
                  end
                end
              end
              getValue4 = function(data, data2, data3, data4)
                if data4[5] < 2 then
                  return true
                end
                if data4[1] ~= 0 and getValue3(data + data4[1], data2, data3) then
                  return false
                end
                if data4[2] ~= 0 and getValue3(data, data2 + data4[2], data3) then
                  return false
                end
                if data4[3] ~= 0 and getValue3(data, data2, data3 + data4[3]) then
                  return false
                end
                return true
              end
              getValue5 = function(data, data2, data3, data4)
                if not getValue3(data2, data3, data4) then
                  return data2, data3, data4
                end
                for i = 1, 16 do
                  for i2 = -i, i do
                    for i3 = -i, i do
                      for i4 = -i, i do
                        if max(getValue28(i2), getValue28(i3), getValue28(i4)) ~= i then
                          continue
                        end
                        local calculatedValue = data2 + i2
                        local calculatedValue2 = data3 + i3
                        local calculatedValue3 = data4 + i4
                        local isActive = not getValue3(calculatedValue, calculatedValue2, calculatedValue3)
                        if isActive then
                          isActive = (getValue21(state4, calculatedValue, calculatedValue2, calculatedValue3) - data).Magnitude
                            <= 8
                        end
                        if isActive then
                          return calculatedValue, calculatedValue2, calculatedValue3
                        end
                      end
                    end
                  end
                end
                return data2, data3, data4
              end
              getValue6 = function(data, data2, data3, data4)
                if not getValue3(data2, data3, data4) then
                  return data2, data3, data4
                end
                for i = 1, 16 do
                  for i2 = -i, i do
                    for i3 = -i, i do
                      for i4 = -i, i do
                        if max(getValue28(i2), getValue28(i3), getValue28(i4)) == i then
                          local calculatedValue = data2 + i2
                          local calculatedValue2 = data3 + i3
                          local calculatedValue3 = data4 + i4
                          if
                            not getValue3(calculatedValue, calculatedValue2, calculatedValue3)
                            and not workspace:Raycast(
                              data,
                              getValue21(state4, calculatedValue, calculatedValue2, calculatedValue3) - data,
                              raycastParams
                            )
                          then
                            return calculatedValue, calculatedValue2, calculatedValue3
                          end
                        end
                      end
                    end
                  end
                end
                return data2, data3, data4
              end
            end
            do
              local function handleState(data, data2, data3)
                local calculatedValue = #data + 1
                local snapshot = data3
                data[calculatedValue] = {
                  data2,
                  snapshot,
                }
                while calculatedValue > 1 do
                  local state = floor2(calculatedValue * 0.5)
                  if not (data[state][1] <= data[calculatedValue][1]) then
                    local entry = data[state]
                    data[state] = data[calculatedValue]
                    data[calculatedValue] = entry
                    calculatedValue = state
                    continue
                  end
                  break
                end
              end
              local function getValue29(data)
                local state = #data
                if state == 0 then
                  return nil
                end
                local entry = data[1]
                data[1] = data[state]
                data[state] = nil
                local calculatedValue9 = state - 1
                local amount = 1
                while true do
                  local calculatedValue10 = amount + amount
                  local calculatedValue2 = amount + amount + 1
                  if not (calculatedValue10 <= calculatedValue9 and data[calculatedValue10][1] < data[amount][1]) then
                    calculatedValue10 = amount
                  end
                  if
                    calculatedValue2 <= calculatedValue9 and data[calculatedValue2][1] < data[calculatedValue10][1]
                  then
                    calculatedValue10 = calculatedValue2
                  end
                  if calculatedValue10 ~= amount then
                    local entry = data[amount]
                    data[amount] = data[calculatedValue10]
                    data[calculatedValue10] = entry
                    amount = calculatedValue10
                    continue
                  end
                  break
                end
                return entry[2]
              end
              getValue26 = function(data, data2, data3, data4, data5)
                local state29, state2, state3 = getValue6(data4, data2.x, data2.y, data2.z)
                local state4, state5, state6 = getValue5(data5, data3.x, data3.y, data3.z)
                local state7 = getValue27(state4, state5, state6)
                local state8 = getValue27(state29, state2, state3)
                local items17 = {
                  [state8] = {
                    x = state29,
                    y = state2,
                    z = state3,
                    g = 0,
                    parent = nil,
                  },
                }
                local items2 = {}
                local items3 = {}
                handleState(items3, 0, state8)
                local function getValue30(data, data2, data3)
                  local calculatedValue = data - state4
                  local calculatedValue2 = data2 - state5
                  local calculatedValue3 = data3 - state6
                  return sqrt(
                    calculatedValue * calculatedValue
                      + calculatedValue2 * calculatedValue2
                      + calculatedValue3 * calculatedValue3
                  )
                end
                local amount = 0
                while #items3 > 0 do
                  local parent2 = getValue29(items3)
                  if items2[parent2] then
                    continue
                  end
                  items2[parent2] = true
                  amount += 1
                  if amount > 300000 then
                    return nil
                  end
                  local parent = items17[parent2]
                  if parent2 == state7 then
                    local items18 = {}
                    while parent do
                      items18[#items18 + 1] = getValue21(data, parent.x, parent.y, parent.z)
                      parent = parent.parent and items17[parent.parent]
                    end
                    local items2 = {}
                    for i = #items18, 1, -1 do
                      items2[#items2 + 1] = items18[i]
                    end
                    return items2
                  end
                  local x = parent.x
                  local y = parent.y
                  local z = parent.z
                  local g = parent.g
                  for _, item in state, nil, nil do
                    local calculatedValue = parent2 + item[6]
                    if not items2[calculatedValue] then
                      local x2 = x + item[1]
                      local y2 = y + item[2]
                      local z2 = z + item[3]
                      if not getValue3(x2, y2, z2) then
                        if getValue4(x, y, z, item) then
                          local g2 = g + item[4]
                          local entry = items17[calculatedValue]
                          if not entry or g2 < entry.g then
                            if entry then
                              entry.g = g2
                              entry.parent = parent2
                              entry.x = x2
                              entry.y = y2
                              entry.z = z2
                            else
                              items17[calculatedValue] = {
                                x = x2,
                                y = y2,
                                z = z2,
                                g = g2,
                                parent = parent2,
                              }
                            end
                            handleState(items3, g2 + 2 * getValue30(x2, y2, z2), calculatedValue)
                          end
                        end
                      end
                    end
                  end
                end
                return nil
              end
            end
          end
          local state8, state9
          do
            local function getValue31(data, data2, data3)
              if not data or #data < 3 then
                return data
              end
              local items = {
                data[1],
              }
              local amount = 2
              local amount2 = 1
              while amount <= #data do
                if not getValue20(data[amount2], data[amount + 1] or data[amount], data2, data3, false) then
                  items[#items + 1] = data[amount]
                  amount2 = amount
                end
                amount += 1
              end
              items[#items + 1] = data[#data]
              return items
            end
            xenVoxelRoute = function(vectorLocal462, vector2)
              local character = localPlayer3.Character
              local filterDescendantsInstances = character and {
                character,
              } or {}
              for _, item in ipairs(routeIgnoredInstances) do
                filterDescendantsInstances[#filterDescendantsInstances + 1] = item
              end
              overlapParams.FilterDescendantsInstances = filterDescendantsInstances
              raycastParams.FilterDescendantsInstances = filterDescendantsInstances
              local isConditionMet = tonumber(_G.XenPathCell) or 4
              local isConditionMet2 = tonumber(_G.XenPathRadius) or 2.5
              local isConditionMet3 = tonumber(_G.XenPathHeight) or 5
              local isConditionMet4 = tonumber(_G.XenPathPad) or 40
              state4 = isConditionMet
              state5 = isConditionMet2
              state7 = isConditionMet3
              table.clear(state6)
              local z = vectorLocal462.Z
              local z2 = vector2.Z
              local calculatedValue = Vector3.new(
                min(vectorLocal462.X, vector2.X),
                min(vectorLocal462.Y, vector2.Y),
                min(z, z2)
              ) - Vector3.new(isConditionMet4, isConditionMet4, isConditionMet4)
              local z3 = vectorLocal462.Z
              local z4 = vector2.Z
              local calculatedValue2 = Vector3.new(
                max(vectorLocal462.X, vector2.X),
                max(vectorLocal462.Y, vector2.Y),
                max(z3, z4)
              ) + Vector3.new(isConditionMet4, isConditionMet4, isConditionMet4)
              vectorLocal461 = calculatedValue
              local vectorLocal463 = calculatedValue2 - calculatedValue
              state27 = floor2(vectorLocal463.X / isConditionMet) + 1
              state2 = floor2(vectorLocal463.Y / isConditionMet) + 1
              state3 = floor2(vectorLocal463.Z / isConditionMet) + 1
              if state27 * state2 * state3 > 200000 then
                return nil
              end
              local state = getValue26(isConditionMet, {
                x = floor2((vectorLocal462.X - vectorLocal461.X) / isConditionMet),
                y = floor2((vectorLocal462.Y - vectorLocal461.Y) / isConditionMet),
                z = floor2((vectorLocal462.Z - vectorLocal461.Z) / isConditionMet),
              }, {
                x = floor2((vector2.X - vectorLocal461.X) / isConditionMet),
                y = floor2((vector2.Y - vectorLocal461.Y) / isConditionMet),
                z = floor2((vector2.Z - vectorLocal461.Z) / isConditionMet),
              }, vectorLocal462, vector2)
              if not state then
                return nil
              end
              local state2 = getValue31(state, isConditionMet2, isConditionMet3)
              if not state2 or #state2 == 0 then
                return nil
              end
              local items = {}
              for i = 2, #state2 do
                items[#items + 1] = state2[i]
              end
              if #items == 0 or (items[#items] - vector2).Magnitude > 0.5 then
                items[#items + 1] = vector2
              end
              return items
            end
          end
          _G.XenVoxelRoute = xenVoxelRoute
          do
            local items = {
              minX = -458,
              maxX = -362,
              minZ = -40,
              maxZ = 185,
            }
            state8 = nil
            state9 = nil
            xenInCenterZone = function(data, data2)
              return data >= items.minX and data <= items.maxX and data2 >= items.minZ and data2 <= items.maxZ
            end
          end
          xenSegmentCrossesCenter = function(vector, vector2)
            if xenInCenterZone(vector.X, vector.Z) or xenInCenterZone(vector2.X, vector2.Z) then
              return true
            end
            for i = 1, 10 do
              local calculatedValue = i / 11
              if
                xenInCenterZone(
                  vector.X + (vector2.X - vector.X) * calculatedValue,
                  vector.Z + (vector2.Z - vector.Z) * calculatedValue
                )
              then
                return true
              end
            end
            return false
          end
          do
            local function getValue()
              return tonumber(_G.XenRowBoxX) or 26
            end
            local function getValue2()
              return tonumber(_G.XenRowBoxZ) or 30
            end
            local function getValue3()
              return tonumber(_G.XenRowLane) or 30
            end
            local function getValue44(vectorLocal464)
              if not state8 then
                return nil
              end
              local huge = math.huge
              local state = nil
              for i = 1, 8 do
                local vectorLocal465 = state8[i]
                local calculatedValue = (vectorLocal464.X - vectorLocal465.X) ^ 2
                  + (vectorLocal464.Z - vectorLocal465.Z) ^ 2
                if calculatedValue < huge then
                  huge = calculatedValue
                  state = i
                end
              end
              if huge > 4900 then
                return nil
              end
              return state
            end
            local function getValue5(vector, vector2, data, data2)
              if not state8 then
                return false
              end
              local state = getValue()
              local state2 = getValue2()
              for i = 0, 24 do
                local calculatedValue = i / 36
                local calculatedValue2 = vector.X + (vector2.X - vector.X) * calculatedValue
                local calculatedValue3 = vector.Z + (vector2.Z - vector.Z) * calculatedValue
                for i2 = 1, 8 do
                  if i2 ~= data and i2 ~= data2 then
                    local vector = state8[i2]
                    if
                      math.abs(calculatedValue2 - vector.X) <= state
                      and math.abs(calculatedValue3 - vector.Z) <= state2
                    then
                      return true
                    end
                  end
                end
              end
              return false
            end
            xenFindRowDetour = function(vectorLocal466, vector2Local483, data)
              if not state8 then
                return nil
              end
              local state = getValue44(vectorLocal466)
              local state2 = getValue44(vector2Local483)
              if not getValue5(vectorLocal466, vector2Local483, state, state2) then
                return nil
              end
              local x = state8[state2 or 1].X
              local state3 = getValue3()
              local state4 = nil
              if not state9 then
                state4 = -410
              end
              local items = {}
              items[#items + 1] = x < state4 and x - state3 or x + state3
              local isConditionMet = x < state4 and x + state3 or x - state3
              if not xenInCenterZone(isConditionMet, (vectorLocal466.Z + vector2Local483.Z) * 0.5) then
                items[#items + 1] = isConditionMet
              end
              local huge = math.huge
              local state5 = nil
              for _, item in ipairs(items) do
                local vector = Vector3.new(item, data, vectorLocal466.Z)
                local vector2 = Vector3.new(item, data, vector2Local483.Z)
                if
                  getValue42(vectorLocal466, vector)
                  and getValue42(vector, vector2)
                  and getValue42(vector2, vector2Local483)
                  and not getValue5(vector, vector2, state, state2)
                then
                  local calculatedValue = (vectorLocal466 - vector).Magnitude
                    + (vector - vector2).Magnitude
                    + (vector2 - vector2Local483).Magnitude
                  if calculatedValue < huge then
                    state5 = {
                      vector,
                      vector2,
                    }
                    huge = calculatedValue
                  end
                end
              end
              return state5
            end
          end
        end
        do
          local function getValue(vector, vector2)
            local state = nil
            local state2
            for i = 0, 40 do
              local calculatedValue = i / 60
              if
                xenInCenterZone(
                  vector.X + (vector2.X - vector.X) * calculatedValue,
                  vector.Z + (vector2.Z - vector.Z) * calculatedValue
                )
              then
                if not state then
                  state = calculatedValue
                  state2 = calculatedValue
                else
                  state2 = calculatedValue
                end
              end
            end
            return state, state2
          end
          local function getValue210(data, data2)
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
            raycastParams.IgnoreWater = true
            local filterDescendantsInstances = {}
            for _, player in ipairs(routePlayersService:GetPlayers()) do
              if player.Character then
                filterDescendantsInstances[#filterDescendantsInstances + 1] = player.Character
              end
            end
            for _, item in ipairs(routeIgnoredInstances) do
              filterDescendantsInstances[#filterDescendantsInstances + 1] = item
            end
            raycastParams.FilterDescendantsInstances = filterDescendantsInstances
            local state30 = nil
            local state2 = nil
            for i = 0, 27 do
              local calculatedValue = i / 28
              local calculatedValue2 = (i + 1) / 28
              if calculatedValue2 > 0.1 and calculatedValue < 0.9 then
                local state31 = data:Lerp(data2, calculatedValue)
                local vector = data:Lerp(data2, calculatedValue2) - state31
                if vector.Magnitude > 0.05 then
                  local hit = workspace:Raycast(state31, vector, raycastParams)
                  if hit and getValue24(hit.Instance) then
                    state30 = state30 or math.max(calculatedValue, 0.1)
                    state2 = math.min(calculatedValue2, 0.9)
                  end
                end
              end
            end
            return state30, state2
          end
          local function xenLocalHopOver(data14, vectorLocal467, data2, data3)
            local isConditionMet = tonumber(_G.XenCenterFly) or 10
            local isConditionMet2 = tonumber(_G.XenHopPad) or 0.12
            local clampedValue = math.clamp(data2 or 0.35, 0.15, 0.85)
            local clampedValue2 = math.clamp(data3 or 0.65, clampedValue + 0.04, 0.96)
            local maximumValue = math.max(0.04, clampedValue - isConditionMet2)
            local minimumValue = math.min(0.94, clampedValue2 + isConditionMet2)
            local function getValue(data15, data2)
              local vectorLocal468 = data14:Lerp(vectorLocal467, data15)
              return Vector3.new(
                vectorLocal468.X,
                data14.Y + (vectorLocal467.Y - data14.Y) * data15 + (data2 or 0),
                vectorLocal468.Z
              )
            end
            local items = {
              data14,
            }
            local function handleState(data)
              if (items[#items] - data).Magnitude > 0.6 then
                items[#items + 1] = data
              end
            end
            handleState(getValue(maximumValue, 0))
            handleState(getValue((maximumValue + clampedValue) * 0.5, isConditionMet * 0.5))
            handleState(getValue(clampedValue, isConditionMet))
            handleState(getValue((clampedValue + clampedValue2) * 0.5, isConditionMet))
            handleState(getValue(clampedValue2, isConditionMet))
            handleState(getValue((clampedValue2 + minimumValue) * 0.5, isConditionMet * 0.5))
            handleState(getValue(minimumValue, 0))
            handleState(vectorLocal467)
            return items
          end
          _G.XenInCenterZone = xenInCenterZone
          _G.XenSegmentCrossesCenter = xenSegmentCrossesCenter
          _G.XenFindRowDetour = xenFindRowDetour
          _G.XenLocalHopOver = xenLocalHopOver
          local function m7ComputeRoute(vectorLocal469, vector2, vector3, data, data2)
            if getValue42(vectorLocal469, vector2) then
              return {
                vector2,
              }
            end
            if xenSegmentCrossesCenter(vectorLocal469, vector2) then
              local state, state2 = getValue(vectorLocal469, vector2)
              local state3, state4 = getValue210(vectorLocal469, vector2)
              local isActive = state and state3 and state4 and state4 >= state
              if isActive then
                isActive = state3 <= (state2 or 1)
              end
              if isActive then
                local maximumValue = math.max(state3, state)
                local minimumValue = math.min(state4, state2 or state4)
                if 0.05 < minimumValue - maximumValue then
                  return xenLocalHopOver(vectorLocal469, vector2, maximumValue, minimumValue)
                end
              end
            end
            local collection8 = xenFindRowDetour(vectorLocal469, vector2, vectorLocal469.Y)
            if collection8 and #collection8 > 0 then
              vectorLocal469 = collection8[#collection8]
            end
            local function getValue(collection9)
              if not collection8 or #collection8 == 0 then
                return collection9
              end
              local items = {}
              for _, item in ipairs(collection8) do
                items[#items + 1] = item
              end
              for _, item2 in ipairs(collection9) do
                items[#items + 1] = item2
              end
              return items
            end
            if getValue42(vectorLocal469, vector2) then
              return (getValue({
                vector2,
              }))
            end
            if data2 then
              local calculatedValue = math.max(vectorLocal469.Y, vector2.Y, 25) + 12
              local items = {
                vectorLocal469,
                Vector3.new(vectorLocal469.X, calculatedValue, vectorLocal469.Z),
                Vector3.new(vector2.X, calculatedValue, vector2.Z),
                vector2,
              }
              local isEnabled = true
              for i = 1, #items - 1 do
                local entry = items[i]
                local entry2 = items[i + 1]
                if (entry - entry2).Magnitude > 0.5 then
                  if not getValue42(entry, entry2, i == 1 and 6 or 0, i == #items - 1 and 6 or 0) then
                    isEnabled = false
                    break
                  end
                end
              end
              if isEnabled then
                return (getValue(items))
              end
            end
            local state = xenVoxelRoute(vectorLocal469, vector2)
            if state and #state > 0 then
              return (getValue(state))
            end
            vector3 = vector3 and vector2 - vector3 * 14 or vector2
            local state2 = nil
            local huge = math.huge
            local function getValue2(data)
              if not data or #data < 2 then
                return
              end
              local state = #data
              for i = 1, state - 1 do
                local entry = data[i]
                local entry2 = data[i + 1]
                if (entry - entry2).Magnitude > 0.5 then
                  if not getValue42(entry, entry2, i == 1 and 6 or 0, i == state - 1 and 6 or 0) then
                    return
                  end
                end
              end
              local state210 = getValue5(data)
              local state3 = getValue32(state210)
              if state3 < huge then
                state2 = state210
                huge = state3
              end
            end
            local vector = Vector3.new(vector3.X - vectorLocal469.X, 0, vector3.Z - vectorLocal469.Z)
            if vector.Magnitude > 0.1 then
              local unit = vector.Unit
              local vector2 = Vector3.new(-unit.Z, 0, unit.X)
              local calculatedValue = (vectorLocal469 + vector3) * 0.5
              for _, item in ipairs({
                12,
                -12,
                36,
                -24,
                38,
                -38,
                56,
                -56,
                76,
                -76,
              }) do
                getValue2({
                  vectorLocal469,
                  calculatedValue + vector2 * item,
                  vector3,
                })
                getValue2({
                  vectorLocal469,
                  vectorLocal469 + vector2 * item,
                  vector3 + vector2 * item,
                  vector3,
                })
              end
            end
            local state3 = nil
            if not state2 then
              local vector2 = Vector3.new(vector3.X, vectorLocal469.Y, vector3.Z)
              local state = state24:CreatePath({
                AgentRadius = 16,
                AgentHeight = 5,
                AgentCanJump = true,
                AgentJumpHeight = 10,
                AgentMaxSlope = 89,
              })
              local items = {
                vectorLocal469,
              }
              if
                pcall(function()
                  state:ComputeAsync(Vector3.new(vectorLocal469.X, vectorLocal469.Y, vectorLocal469.Z), vector2)
                end) and state.Status == Enum.PathStatus.Success
              then
                local position = vectorLocal469
                for _, item in ipairs(state:GetWaypoints()) do
                  if (item.Position - position).Magnitude >= 8 then
                    items[#items + 1] = item.Position + Vector3.new(0, 5, 0)
                    position = item.Position
                  end
                end
              end
              items[#items + 1] = vector3 + Vector3.new(0, 5, 0)
              state3 = getValue6(items)
              getValue2(state3)
            end
            local snapshot = state2
            if not snapshot and m7Clear(vectorLocal469, vector2) then
              snapshot = {
                vector2,
              }
            end
            if not snapshot and state3 then
              snapshot = getValue5(state3)
            end
            snapshot = snapshot or {
              vector2,
            }
            if 0.5 < (snapshot[#snapshot] - vector2).Magnitude then
              snapshot[#snapshot + 1] = vector2
            end
            return (getValue(snapshot))
          end
          _G._m7_clear = m7Clear
          _G._m7_velMoveThrough = moveThroughRoute
          _G._m7_computeRoute = m7ComputeRoute
          _G._m7_reroute = m7ComputeRoute
        end
        computeOptimizedRoute = function(data, data2, data3, data4, data5)
          return _G._m7_computeRoute(data, data2, data3, data4, data5)
        end
        traverseRouteVelocity = function(instance2, data, data2, data3, data4)
          if not instance2 or not instance2.Parent or #data == 0 then
            return false
          end
          _G._m7_velMoveThrough(instance2, data, data2, data3, data4)
          return true
        end
        applySmoothVelocityRamp = function(vectorLocal470, collection, data)
          if #collection == 0 then
            return collection
          end
          local y = vectorLocal470.Y
          local amount = 0
          local vectorLocal471 = vectorLocal470
          for _, item in ipairs(collection) do
            local x = vectorLocal471.X
            amount += (Vector3.new(item.X, 0, item.Z) - Vector3.new(x, 0, vectorLocal471.Z)).Magnitude
            vectorLocal471 = item
          end
          if amount < 0.01 then
            amount = 0.01
          end
          local items = {}
          local amount2 = 0
          for _, item2 in ipairs(collection) do
            local magnitude = (Vector3.new(item2.X, 0, item2.Z) - Vector3.new(vectorLocal470.X, 0, vectorLocal470.Z)).Magnitude
            if magnitude >= 0.01 then
              local maximumValue = math.max(1, math.ceil(magnitude / 30))
              for i = 1, maximumValue do
                local calculatedValue = i / maximumValue
                items[#items + 1] = Vector3.new(
                  vectorLocal470.X + (item2.X - vectorLocal470.X) * calculatedValue,
                  y + (data - y) * (amount2 + magnitude * calculatedValue) / amount,
                  vectorLocal470.Z + (item2.Z - vectorLocal470.Z) * calculatedValue
                )
              end
            else
              items[#items + 1] = item2
            end
            amount2 += magnitude
            vectorLocal470 = item2
          end
          if #items > 0 then
            items[#items] = collection[#collection]
          end
          return items
        end
        _G._tuff_convChase = function(instance, data)
          local character = localPlayer2.Character
          character = character and character:FindFirstChild("HumanoidRootPart")
          if not character then
            return
          end
          local function getValue()
            if instance and instance.Parent then
              local primaryPart = instance.PrimaryPart or instance:FindFirstChildWhichIsA("BasePart")
              if primaryPart then
                return primaryPart.Position + Vector3.new(0, 3, 0)
              end
            end
            return data
          end
          equipRoutingTools()
          local now2 = os.clock()
          while os.clock() - now2 < 12 do
            if not (not character or not character.Parent) then
              local state32 = getValue()
              if state32 then
                local vector = state32 - character.Position
                if not (vector.Magnitude <= 6) then
                  equipTeleportTool()
                  if isPathClear(character.Position, state32) then
                    character.AssemblyLinearVelocity = vector.Unit * (_G.TPTravelSpeed or 400)
                    routeRunService.Heartbeat:Wait()
                  else
                    local state33 = computeOptimizedRoute(character.Position, state32, nil)
                    if not state33 or #state33 == 0 then
                      state33 = {
                        state32,
                      }
                    end
                    local state2 = #state33
                    if state2 > 1 then
                      state2 -= 1
                    end
                    for i = 1, state2 do
                      if not (not character or not character.Parent) then
                        if not isPathClear(character.Position, getValue() or state32) then
                          traverseRouteVelocity(character, {
                            state33[i],
                          }, _G.TPTravelSpeed or 400, true, false)
                          continue
                        end
                      end
                      break
                    end
                  end
                  continue
                end
              end
            end
            break
          end
          if character and character.Parent then
            character.AssemblyLinearVelocity = Vector3.zero
            character.AssemblyAngularVelocity = Vector3.zero
          end
        end
        upperFloorRoutes = {}
        do
          local b = {}
          local items = {
            coord = Vector3.new(-335.725586, 16.850713, -75.668013),
            facing = "NORTH",
          }
          local items2 = {
            coord = Vector3.new(-483, 16.850722, -75.6621),
            facing = "NORTH",
          }
          local items3 = {
            coord = Vector3.new(-487.134918, 16.850713, -17.994154),
            facing = "SOUTH",
          }
          local items4 = {
            coord = Vector3.new(-330.9, 16.850713, -17.994154),
            facing = "SOUTH",
          }
          b[1] = items
          b[2] = items2
          b[3] = items3
          b[4] = items4
          upperFloorRoutes.B = b
        end
        do
          local c2 = {}
          local items = {
            coord = Vector3.new(-330.765381, 16.850713, 31),
            facing = "NORTH",
          }
          local items2 = {
            coord = Vector3.new(-487.9, 16.850713, 31.27243),
            facing = "NORTH",
          }
          local items3 = {
            coord = Vector3.new(-489.077087, 16.850713, 89.030145),
            facing = "SOUTH",
          }
          local items4 = {
            coord = Vector3.new(-330.908936, 16.850713, 89.030145),
            facing = "SOUTH",
          }
          c2[1] = items
          c2[2] = items2
          c2[3] = items3
          c2[4] = items4
          upperFloorRoutes.C = c2
        end
        do
          local d = {}
          local items = {
            coord = Vector3.new(-331.264893, 16.850713, 138.309167),
            facing = "NORTH",
          }
          local items2 = {
            coord = Vector3.new(-487.774933, 16.850713, 138.309167),
            facing = "NORTH",
          }
          local items3 = {
            coord = Vector3.new(-487.774933, 16.850713, 196.122354),
            facing = "SOUTH",
          }
          local items4 = {
            coord = Vector3.new(-330.799133, 16.850713, 196.122354),
            facing = "SOUTH",
          }
          d[1] = items
          d[2] = items2
          d[3] = items3
          d[4] = items4
          upperFloorRoutes.D = d
        end
        lowerFloorRoutes = {}
        do
          local b = {}
          local items = {
            coord = Vector3.new(-335.725586, -3.048217, -74.943137),
            facing = "NORTH",
          }
          local items2 = {
            coord = Vector3.new(-483, -3.048217, -74.943137),
            facing = "NORTH",
          }
          local items3 = {
            coord = Vector3.new(-483.859253, -3.71843, -17.994154),
            facing = "SOUTH",
          }
          local items4 = {
            coord = Vector3.new(-334, -3.048218, -17.994154),
            facing = "SOUTH",
          }
          b[1] = items
          b[2] = items2
          b[3] = items3
          b[4] = items4
          lowerFloorRoutes.B = b
        end
      end
      do
        local c2 = {}
        local items = {
          coord = Vector3.new(-335.985413, -3.048218, 32.151426),
          facing = "NORTH",
        }
        local items2 = {
          coord = Vector3.new(-483.74939, -3.048218, 32.056175),
          facing = "NORTH",
        }
        local items3 = {
          coord = Vector3.new(-483.74939, -3.048218, 88.247003),
          facing = "SOUTH",
        }
        local items4 = {
          coord = Vector3.new(-334, -3.048217, 88.247003),
          facing = "SOUTH",
        }
        c2[1] = items
        c2[2] = items2
        c2[3] = items3
        c2[4] = items4
        lowerFloorRoutes.C = c2
      end
      do
        local d = {}
        local items = {
          coord = Vector3.new(-335.476654, -3.048218, 138.309167),
          facing = "NORTH",
        }
        local items2 = {
          coord = Vector3.new(-483, -3.048218, 138.309167),
          facing = "NORTH",
        }
        local items3 = {
          coord = Vector3.new(-334, -3.048218, 195.402444),
          facing = "SOUTH",
        }
        local items4 = {
          coord = Vector3.new(-483.859253, -3.048218, 195.402444),
          facing = "SOUTH",
        }
        d[1] = items
        d[2] = items2
        d[3] = items3
        d[4] = items4
        lowerFloorRoutes.D = d
      end
      do
        local state34, state211, getValue34, getValue2
        upperFloorThreshold = 7
        state34 = {
          ["La Secret Combinasion"] = true,
          ["La Grande Combinasion"] = true,
        }
        state211 = 3
        lowerBasePositions = {
          Vector3.new(-476.52, -2, 220.94090270996094),
          Vector3.new(-476.52, -2, 113.41409301757812),
          [3] = Vector3.new(-476.52, -2, 6.1784877777099609),
          [4] = Vector3.new(-476.52, -2, -101.07275390625),
          [5] = Vector3.new(-342.66, -2, 221.44737243652344),
          [6] = Vector3.new(-342.66, -2, 113.41409301757812),
          [7] = Vector3.new(-342.66, -2, 6.2494616508483887),
          [8] = Vector3.new(-342.66, -2, -99.73458862304688),
        }
        upperBasePositions = {
          Vector3.new(-479.51, 18, 220.94090270996094),
          [2] = Vector3.new(-479.51, 18, 113.77315521240234),
          [3] = Vector3.new(-479.51, 18, 6.178487777709961),
          [4] = Vector3.new(-479.51, 18, -99.73458862304688),
          [5] = Vector3.new(-339.48, 18, 221.44737243652344),
          [6] = Vector3.new(-339.48, 18, 113.41409301757812),
          [7] = Vector3.new(-339.48, 18, 6.2494616508483887),
          [8] = Vector3.new(-339.48, 18, -99.73458862304688),
        }
        lowerFloorY = -3.048217
        do
          local state = -410
          findClosestBaseIndex = function(vectorLocal472)
            local huge = math.huge
            local amount = 1
            for i = 1, 8 do
              local vectorLocal473 = lowerBasePositions[i]
              local calculatedValue = (vectorLocal472.X - vectorLocal473.X) ^ 2
                + (vectorLocal472.Z - vectorLocal473.Z) ^ 2
              if calculatedValue < huge then
                huge = calculatedValue
                amount = i
              end
            end
            return amount
          end
          getValue34 = function(data, data2, data3)
            local vector = data2 and upperBasePositions[data] or lowerBasePositions[data]
            data2 = data2 and 16.850713 or lowerFloorY
            local z = vector.Z
            return Vector3.new(vector.X, data2, math.clamp(data3 - vector.Z, -18, 18) + z),
              data <= 4 and Vector3.new(-1, 0, 0) or Vector3.new(1, 0, 0)
          end
          getValue2 = function(collection, data)
            local vector = lowerBasePositions[data]
            local isActive = data <= 4
            local items = {}
            for _, item in pairs(collection) do
              for _, item in ipairs(item) do
                if item.coord.X < state == isActive and math.abs(item.coord.Z - vector.Z) < 45 then
                  items[#items + 1] = item
                end
              end
            end
            return items
          end
        end
        do
          local function getValue35(vector, collection)
            local huge = math.huge
            local state35 = nil
            local state2 = nil
            for k, item in pairs(collection) do
              for _, item in ipairs(item) do
                local coord = item.coord
                local state36 = math.sqrt((vector.X - coord.X) ^ 2 + (vector.Z - coord.Z) ^ 2)
                if state36 < huge then
                  huge = state36
                  state35 = item
                  state2 = k
                end
              end
            end
            return state35, state2
          end
          getTargetAnimalPosition = function(childName, data)
            _G._curStealSlot = tonumber(data)
            if not childName or data == nil then
              return nil
            end
            local plots_2 = workspace:FindFirstChild("Plots")
            local isConditionMet = plots_2 and plots_2:FindFirstChild(childName)
            if not isConditionMet then
              return nil
            end
            local animalPodiums = isConditionMet:FindFirstChild("AnimalPodiums")
            if not animalPodiums then
              return nil
            end
            local model = animalPodiums:FindFirstChild(tostring(data))
            if not model then
              return nil
            end
            for _, descendant in ipairs(model:GetDescendants()) do
              if
                descendant:IsA("Model")
                and descendant.Name ~= "Animal"
                and descendant.Name ~= "Base"
                and descendant.Name ~= "Decoration"
              then
                local isEnabled = false
                for _, descendant2 in ipairs(descendant:GetDescendants()) do
                  if descendant2:IsA("MeshPart") then
                    isEnabled = true
                    break
                  end
                end
                if isEnabled then
                  local success, rootPart = pcall(function()
                    return descendant:GetBoundingBox()
                  end)
                  if success then
                    return rootPart.Position
                  end
                end
              end
            end
            local success, rootPart = pcall(function()
              return model:GetPivot()
            end)
            if success then
              return rootPart.Position
            end
            return model.Position
          end
          local function findTarget(childName)
            local isEnabled = false
            pcall(function()
              local plots = workspace:FindFirstChild("Plots")
              plots = plots and plots:FindFirstChild(childName)
              if not plots then
                return
              end
              local laserHitbox = plots:FindFirstChild("LaserHitbox")
              if not laserHitbox then
                isEnabled = true
                return
              end
              local main = laserHitbox:FindFirstChild("Main")
              local isEnabledLocal80
              if main and main:IsA("BasePart") and main.CanCollide then
                isEnabledLocal80 = true
              else
                isEnabledLocal80 = false
                for _, child in ipairs(laserHitbox:GetChildren()) do
                  if child:IsA("BasePart") and child.CanCollide and child.Position.Y <= 8.9 then
                    isEnabledLocal80 = true
                    break
                  end
                end
              end
              isEnabled = not isEnabledLocal80
            end)
            return isEnabled
          end
          local function findTarget2()
            if not _G.XenNet then
              return false
            end
            local character = localPlayer2.Character or localPlayer2.CharacterAdded:Wait()
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if not character or not humanoid then
              return false
            end
            local quantumCloner = localPlayer2:FindFirstChild("Backpack")
                and localPlayer2.Backpack:FindFirstChild("Quantum Cloner")
              or character:FindFirstChild("Quantum Cloner")
            if not quantumCloner then
              return false
            end
            if quantumCloner.Parent == localPlayer2.Backpack then
              pcall(function()
                humanoid:EquipTool(quantumCloner)
              end)
            end
            local isEnabled = false
            if _G._xenFastClone then
              isEnabled = _G._xenFastClone() and true or false
            end
            if _G.ServerPosCloneSwapPending then
              pcall(_G.ServerPosCloneSwapPending)
            end
            return isEnabled
          end
          _G._tuff_mkPlate = function(vector, data, data2)
            if not vector then
              return nil
            end
            local tuffCurPlate = _G._tuff_curPlate
            if tuffCurPlate and tuffCurPlate.Parent then
              pcall(function()
                tuffCurPlate:Destroy()
              end)
            end
            _G._tuff_curPlate = nil
            local character = localPlayer2.Character
            character = character and character:FindFirstChild("HumanoidRootPart")
            local curStealSlot = tonumber(data) or _G._curStealSlot
            local y = vector.Y
            local y2 = character and character.Position.Y or y
            if curStealSlot and curStealSlot >= 19 then
              y2 = tonumber(_G.XenFloor3Y) or 21
            elseif curStealSlot and curStealSlot >= 11 then
              y2 = tonumber(_G.XenFloor2Y) or 6.5
            elseif curStealSlot and curStealSlot >= 1 then
              y2 = -4
            elseif 23.15 < y then
              y2 = tonumber(_G.XenFloor3Y) or 21
            elseif y >= 11 and y <= 23.15 then
              y2 = tonumber(_G.XenFloor2Y) or 6.5
            elseif y >= -6.9 and y <= 8.9 then
              y2 = -4
            end
            local vector = Vector3.new(vector.X, y2, vector.Z)
            local calculatedValue = vector.Y - 3
            local tuffCurPlate2 = newInstance("Part")
            tuffCurPlate2.Name = _G._xenN.tpp
            tuffCurPlate2.Size = Vector3.new(8, 2, 8)
            tuffCurPlate2.Position = Vector3.new(vector.X, calculatedValue - 2, vector.Z)
            tuffCurPlate2.Anchored = true
            tuffCurPlate2.CanCollide = character ~= nil and character.Position.Y > tuffCurPlate2.Position.Y + 0.1
              or false
            tuffCurPlate2.Transparency = 1
            tuffCurPlate2.Material = Enum.Material.SmoothPlastic
            tuffCurPlate2.Parent = workspace
            _G._tuff_curPlate = tuffCurPlate2
            local state = nil
            local connection = nil
            connection = routeRunService.Stepped:Connect(function(time, deltaTime)
              if not tuffCurPlate2 or not tuffCurPlate2.Parent then
                if connection then
                  connection:Disconnect()
                end
                return
              end
              local character2 = localPlayer2.Character
              character2 = character2 and character2:FindFirstChild("HumanoidRootPart")
              if character2 then
                local y3 = character2.Position.Y
                if not state then
                  state = y3
                end
                local calculatedValue = y3 - state
                local isActive = _G.XenPlatePassThrough and y3 <= tuffCurPlate2.Position.Y + 1.1
                local isActive2
                if isActive then
                  local isActive = character2.AssemblyLinearVelocity.Y > 1
                  if isActive then
                    isActive2 = isActive
                  else
                    isActive2 = calculatedValue > 0.2 and calculatedValue < 5
                  end
                else
                  isActive2 = isActive
                end
                if isActive2 then
                  tuffCurPlate2.CanCollide = false
                else
                  tuffCurPlate2.CanCollide = y3 > tuffCurPlate2.Position.Y + 0.1
                end
                local assemblyLinearVelocity = character2.AssemblyLinearVelocity
                deltaTime = deltaTime or 0.016666666666666666
                if
                  assemblyLinearVelocity.Y < 0 and -assemblyLinearVelocity.Y * deltaTime > tuffCurPlate2.Size.Y * 0.5
                then
                  local calculatedValue = tuffCurPlate2.Position.Y + tuffCurPlate2.Size.Y * 0.5
                  if y3 >= calculatedValue + 3 and y3 + assemblyLinearVelocity.Y * deltaTime < calculatedValue + 3 then
                    character2.CFrame = CFrame.new(character2.Position.X, calculatedValue + 3, character2.Position.Z)
                    character2.AssemblyLinearVelocity =
                      Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z)
                  end
                end
                state = y3
              end
            end)
            task.spawn(function()
              local now2 = tick()
              while localPlayer2:GetAttribute("Stealing") and tick() - now2 < 60 do
                if not tuffCurPlate2 or not tuffCurPlate2.Parent then
                  return
                end
                task.wait(0.1)
              end
              local exitTo = nil
              while true do
                if not (tick() - now2 < 60) then
                  exitTo = 1
                  break
                else
                  if not (not tuffCurPlate2 or not tuffCurPlate2.Parent) then
                    if localPlayer2:GetAttribute("Stealing") then
                      exitTo = 1
                      break
                    else
                      task.wait(0.1)
                      continue
                    end
                  end
                  break
                end
              end
              if exitTo == 1 then
                if tuffCurPlate2 and tuffCurPlate2.Parent then
                  tuffCurPlate2:Destroy()
                end
                if _G._tuff_curPlate == tuffCurPlate2 then
                  _G._tuff_curPlate = nil
                end
                return
              end
            end)
            return tuffCurPlate2
          end
          local function tuffGoToBrainrot(vectorLocal474, data, data2)
            if not vectorLocal474 then
              return
            end
            local now2 = os.clock()
            local character, humanoidRootPart, humanoid
            while true do
              character = localPlayer2.Character
              humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
              humanoid = character and character:FindFirstChildOfClass("Humanoid")
              if not (humanoidRootPart and humanoid) then
                routeRunService.Heartbeat:Wait()
                if not (os.clock() - now2 > 3) then
                  continue
                end
              end
              break
            end
            if not humanoidRootPart or not humanoid then
              return
            end
            pcall(function()
              humanoidRootPart.Anchored = false
            end)
            local now3 = os.clock()
            while true do
              equipTeleportTool()
              local parent = humanoidRootPart.Parent
              if parent then
                parent = character:FindFirstChild(_G.TPSpeedItem or "Flying Carpet")
              end
              if not parent then
                routeRunService.Heartbeat:Wait()
                if not (os.clock() - now3 > 1.5) then
                  continue
                end
              end
              break
            end
            task.wait(0.5)
            local character2 = localPlayer2.Character
            humanoidRootPart = character2 and character2:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then
              return
            end
            pcall(function()
              humanoidRootPart.Anchored = false
            end)
            local curStealSlot = tonumber(data2) or _G._curStealSlot
            local amount = 0
            if curStealSlot then
              if curStealSlot >= 19 then
                amount = 3
              elseif curStealSlot >= 11 then
                amount = 2
              elseif curStealSlot >= 1 then
                amount = 1
              end
            end
            local y = humanoidRootPart and humanoidRootPart.Position.Y
            local amount2 = 0
            if y then
              if y >= -6.9 and y <= 8.9 then
                amount2 = 1
              elseif y >= 11 and y <= 23.15 then
                amount2 = 2
              elseif 23.15 < y then
                amount2 = 3
              end
            end
            local isActive = amount > 0 and amount2 > 0 and amount2 < amount
            local isActive2 = (
              vectorLocal474.Y <= 8.9
              or not data
                and _G.ApproachFloor2FromFloor1
                and curStealSlot
                and curStealSlot >= 11
                and curStealSlot <= 18
            )
                and 10
              or 25
            local now4 = os.clock()
            while true do
              local position = humanoidRootPart.Position
              local isEnabled = false
              local plots_2 = workspace:FindFirstChild("Plots")
              if plots_2 then
                for _, child in ipairs(plots_2:GetChildren()) do
                  pcall(function()
                    local position2 = child:GetPivot().Position
                    if
                      math.abs(position.X - position2.X) < isActive2
                      and math.abs(position.Z - position2.Z) < isActive2
                    then
                      isEnabled = true
                    end
                  end)
                  if not isEnabled then
                    continue
                  end
                  break
                end
              end
              if isEnabled then
                break
              else
                routeRunService.Heartbeat:Wait()
                if not (os.clock() - now4 > 1.5) then
                  continue
                end
              end
              break
            end
            local y2 = vectorLocal474.Y
            local y3 = humanoidRootPart.Position.Y
            if curStealSlot and curStealSlot >= 19 then
              y3 = tonumber(_G.XenFloor3Y) or 21
            elseif curStealSlot and curStealSlot >= 11 then
              y3 = tonumber(_G.XenFloor2Y) or 6.5
            elseif curStealSlot and curStealSlot >= 1 then
              y3 = -4
            elseif y2 > 23.15 then
              y3 = tonumber(_G.XenFloor3Y) or 21
            elseif y2 >= 11 and y2 <= 23.15 then
              y3 = tonumber(_G.XenFloor2Y) or 6.5
            elseif y2 >= -6.9 and y2 <= 8.9 then
              y3 = -4
            end
            local vector = Vector3.new(vectorLocal474.X, y3, vectorLocal474.Z)
            _G._tuff_mkPlate(vectorLocal474, data2, data)
            local tuffCurPlate = _G._tuff_curPlate
            if tuffCurPlate and tuffCurPlate.Parent then
              local calculatedValue = tuffCurPlate.Position.Y + tuffCurPlate.Size.Y * 0.5 + 2
              vector = Vector3.new(vectorLocal474.X, calculatedValue, vectorLocal474.Z)
              if
                humanoidRootPart
                and humanoidRootPart.Parent
                and (isActive or humanoidRootPart.Position.Y < calculatedValue - 6)
              then
                pcall(function()
                  humanoidRootPart.CFrame = CFrame.new(vector.X, calculatedValue, vector.Z)
                  humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                  humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                end)
              end
            end
            local state = moveAlongRoute(humanoidRootPart, {
              vector,
            }, 250, true, true, false, true)
            if humanoidRootPart and humanoidRootPart.Parent then
              humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
              humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
            end
            local parent = humanoidRootPart and humanoidRootPart.Parent
            local isEnabled = false
            if parent then
              isEnabled = Vector3.new(vector.X - humanoidRootPart.Position.X, 0, vector.Z - humanoidRootPart.Position.Z).Magnitude
                <= 8
            end
            if not state and not isEnabled then
              return
            end
            local tuffCurPlate2 = _G._tuff_curPlate
            if tuffCurPlate2 and tuffCurPlate2.Parent then
              local calculatedValue = tuffCurPlate2.Position.Y + tuffCurPlate2.Size.Y * 0.5
              local now5 = os.clock()
              while os.clock() - now5 < 2.5 do
                if tuffCurPlate2.Parent then
                  if not localPlayer2:GetAttribute("Stealing") then
                    local character3 = localPlayer2.Character
                    humanoidRootPart = character3 and character3:FindFirstChild("HumanoidRootPart")
                    local isConditionMet = character3 and character3:FindFirstChildOfClass("Humanoid")
                    if not (not humanoidRootPart or not humanoidRootPart.Parent) then
                      if
                        not (
                          isConditionMet
                          and isConditionMet.FloorMaterial ~= Enum.Material.Air
                          and humanoidRootPart.Position.Y > calculatedValue
                        )
                      then
                        if humanoidRootPart.Position.Y < calculatedValue + 2 then
                          humanoidRootPart.CFrame = CFrame.new(vector.X, calculatedValue + 2, vector.Z)
                          humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                          humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                        end
                        routeRunService.Heartbeat:Wait()
                        continue
                      end
                    end
                  end
                end
                break
              end
            end
          end
          _G._tuff_goToBrainrot = tuffGoToBrainrot
          teleportToTarget = function(vectorLocal475, data, data2, data3)
            if not vectorLocal475 then
              return
            end
            local character = localPlayer2.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if not rootPart or not humanoid then
              return
            end
            local y = vectorLocal475.Y
            if data2 and state34[data2] then
              y = vectorLocal475.Y - state211
            end
            local curStealSlot = tonumber(data3) or _G._curStealSlot
            _G._curStealSlot = curStealSlot
            pcall(_G._tuff_mkPlate, vectorLocal475, curStealSlot)
            local isActive = _G.ApproachFloor2FromFloor1 and curStealSlot and curStealSlot >= 11 and curStealSlot <= 18
            local isActive2
            if isActive then
              isActive2 = lowerFloorRoutes
            else
              isActive2 = y > upperFloorThreshold and upperFloorRoutes or lowerFloorRoutes
            end
            local function getValue36()
              return routeRunService.Heartbeat:Connect(function()
                if humanoid and humanoid.Parent then
                  humanoid.Health = humanoid.MaxHealth
                end
              end)
            end
            local callback = suppressCharacterAnimations()
            if (vectorLocal475.Y <= 8.9 or isActive) and data and findTarget(data) and not _G._tuff_forceLocked then
              local connection = getValue36()
              equipRoutingTools()
              stopRootMotion(rootPart)
              local vector = Vector3.new(vectorLocal475.X, -4, vectorLocal475.Z)
              local z = rootPart.Position.Z
              local state, vector2 = getValue34(findClosestBaseIndex(vectorLocal475), false, z)
              if vector2 and vector2.Magnitude > 0.008 and rootPart and rootPart.Parent then
                rootPart.CFrame = CFrame.new(rootPart.Position, rootPart.Position + vector2)
                rootPart.AssemblyAngularVelocity = Vector3.zero
              end
              local collection = computeFallbackRoute(rootPart.Position, vector, vector2)
              if not collection or #collection == 0 then
                collection = {
                  vector,
                }
              end
              local position = rootPart.Position
              local amount = 0
              for _, item in ipairs(collection) do
                amount += (item - position).Magnitude
                position = item
              end
              moveAlongRoute(
                rootPart,
                collection,
                amount < 100 and (tonumber(_G.TPCloseSpeed) or 300) or _G.TPTravelSpeed or 400,
                true,
                true,
                true
              )
              if rootPart and rootPart.Parent then
                rootPart.AssemblyLinearVelocity = Vector3.zero
                rootPart.AssemblyAngularVelocity = Vector3.zero
              end
              connection:Disconnect()
              local amount2 = 0
              if curStealSlot then
                if curStealSlot >= 19 then
                  amount2 = 3
                elseif curStealSlot >= 11 then
                  amount2 = 2
                elseif curStealSlot >= 1 then
                  amount2 = 1
                end
              end
              local y2 = rootPart and rootPart.Parent and rootPart.Position.Y
              local amount3 = 0
              if y2 then
                if y2 >= -6.9 and y2 <= 8.9 then
                  amount3 = 1
                elseif y2 >= 11 and y2 <= 23.15 then
                  amount3 = 2
                elseif y2 > 23.15 then
                  amount3 = 3
                end
              end
              if (isActive or amount2 > 0 and amount3 > 0 and amount3 < amount2) and _G.TPDirectlyToPet then
                pcall(function()
                  tuffGoToBrainrot(vectorLocal475, nil, curStealSlot)
                end)
              end
              callback()
              return
            end
            _G._tuff_stealHold = true
            task.delay(15, function()
              _G._tuff_stealHold = false
            end)
            local state, state212 = getValue35(vectorLocal475, isActive2)
            if not state or not state212 then
              _G._tuff_stealHold = false
              callback()
              return
            end
            local connection2 = getValue36()
            equipRoutingTools()
            stopRootMotion(rootPart)
            if not (state.facing == "NORTH" and Vector3.new(0, 0, -1)) then
              Vector3.new(0, 0, 1)
            end
            local isActive3 = isActive2 == upperFloorRoutes
            local state3 = findClosestBaseIndex(vectorLocal475)
            local coord, vector = getValue34(state3, isActive3, rootPart.Position.Z)
            local magnitude = (rootPart.Position - coord).Magnitude
            for _, item in ipairs(getValue2(isActive2, state3)) do
              local magnitude2 = (rootPart.Position - item.coord).Magnitude
              if magnitude2 < magnitude then
                coord = item.coord
                vector = item.facing == "NORTH" and Vector3.new(0, 0, -1)
                if vector then
                  magnitude = magnitude2
                else
                  vector = Vector3.new(0, 0, 1)
                  magnitude = magnitude2
                end
              end
            end
            local vector2 = coord
            local snapshot = vector
            if rootPart and rootPart.Parent then
              rootPart.CFrame = CFrame.new(rootPart.Position, rootPart.Position + snapshot)
              rootPart.AssemblyAngularVelocity = Vector3.zero
            end
            local isConditionMet = tonumber(_G.StealHoldReleaseStuds) or 20.5
            task.spawn(function()
              while _G._tuff_stealHold do
                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                if
                  humanoidRootPart
                  and humanoidRootPart.Parent
                  and (humanoidRootPart.Position - vector2).Magnitude <= isConditionMet
                then
                  _G._tuff_stealHold = false
                  break
                else
                  _G._tuff_RunService.Heartbeat:Wait()
                end
              end
            end)
            local collection = computeOptimizedRoute(rootPart.Position, vector2, snapshot, nil, true)
            local state4 = applySmoothVelocityRamp(rootPart.Position, collection, vector2.Y)
            if not (not state4 or #state4 == 0) then
              collection = state4
            end
            local position = rootPart.Position
            local amount = 0
            for _, item2 in ipairs(collection) do
              amount += (item2 - position).Magnitude
              position = item2
            end
            traverseRouteVelocity(
              rootPart,
              collection,
              amount < 200 and (tonumber(_G.TPCloseSpeed) or 300) or _G.TPTravelSpeed or 400,
              true,
              true,
              true
            )
            rootPart.CFrame = CFrame.new(vector2, vector2 + snapshot)
            stopRootMotion(rootPart)
            local amount2 = 5
            local connection = nil
            connection = routeRunService.Heartbeat:Connect(function()
              if not rootPart or not rootPart.Parent then
                connection:Disconnect()
                return
              end
              amount2 -= 1
              rootPart.CFrame = CFrame.new(vector2, vector2 + snapshot)
              rootPart.AssemblyLinearVelocity = Vector3.zero
              rootPart.AssemblyAngularVelocity = Vector3.zero
              if amount2 <= 0 then
                connection:Disconnect()
              end
            end)
            for i = 1, 20 do
              task.wait(0.05)
              if humanoid.FloorMaterial == Enum.Material.Air then
                continue
              end
              break
            end
            connection2:Disconnect()
            local amount3 = 0
            for i = 1, 50 do
              local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
              if not (not humanoidRootPart or not humanoidRootPart.Parent) then
                local isActive = (
                  Vector3.new(humanoidRootPart.Position.X, 0, humanoidRootPart.Position.Z)
                  - Vector3.new(vector2.X, 0, vector2.Z)
                ).Magnitude <= 3.5
                if isActive then
                  isActive = math.abs(humanoidRootPart.Position.Y - vector2.Y) <= 4
                end
                if isActive then
                  amount3 += 1
                  if not (amount3 >= 4) then
                    routeRunService.Heartbeat:Wait()
                    continue
                  end
                else
                  pcall(function()
                    humanoidRootPart.CFrame = CFrame.new(vector2, vector2 + snapshot)
                  end)
                  humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                  humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                  amount3 = 0
                  routeRunService.Heartbeat:Wait()
                  continue
                end
              end
              break
            end
            if _G.AutoCloneAfterTP then
              local character2 = localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart")
              local position2 = character2 and character2.Parent and character2.Position or vector2
              local part = newInstance("Part")
              part.Name = _G._xenN.tcp
              part.Size = Vector3.new(16, 1, 16)
              part.Position = Vector3.new(position2.X, position2.Y - 3, position2.Z)
              part.Anchored = true
              part.CanCollide = true
              part.Transparency = 1
              part.Material = Enum.Material.SmoothPlastic
              part.Parent = workspace
              if character2 and character2.Parent then
                character2.AssemblyLinearVelocity = Vector3.zero
                character2.AssemblyAngularVelocity = Vector3.zero
                pcall(function()
                  character2.Anchored = true
                end)
                task.delay(1, function()
                  if character2 and character2.Parent then
                    pcall(function()
                      character2.Anchored = false
                    end)
                  end
                end)
              end
              local connection2 = localPlayer2.CharacterAdded:Connect(function() end)
              _G._tuff_stealHold = false
              pcall(function()
                if _G._xenForceStealTarget then
                  _G._xenForceStealTarget(vectorLocal475, data2)
                end
              end)
              task.wait(_G.LandingDelay or 0.3)
              local state = findTarget2()
              if part then
                pcall(function()
                  part:Destroy()
                end)
                part = nil
              end
              if state then
                task.wait(0.2)
                local isEnabled = false
                local character3 = localPlayer2.Character
                character3 = character3 and character3:FindFirstChild("HumanoidRootPart")
                local plots_2 = workspace:FindFirstChild("Plots")
                if character3 and plots_2 then
                  local isConditionMet = (vectorLocal475.Y <= 8.9 or isActive) and 26 or 25
                  local position3 = character3.Position
                  for _, child in ipairs(plots_2:GetChildren()) do
                    pcall(function()
                      local position4 = child:GetPivot().Position
                      if
                        math.abs(position3.X - position4.X) < isConditionMet
                        and math.abs(position3.Z - position4.Z) < isConditionMet
                      then
                        isEnabled = true
                      end
                    end)
                    if not isEnabled then
                      continue
                    end
                    break
                  end
                end
                if connection2 then
                  connection2:Disconnect()
                end
                if isEnabled and _G.TPDirectlyToPet then
                  tuffGoToBrainrot(vectorLocal475, nil, curStealSlot)
                end
              elseif connection2 then
                connection2:Disconnect()
              end
            end
            callback()
          end
        end
      end
    end
    do
      local xenAnimalsCache, state37, instance, ws, localPlayer2, utils, Synchronizer, Animals
      do
        local config, collection
        do
          local snapshot = _G
          local snapshot2 = _G
          local snapshot3 = _G
          local snapshot4 = _G
          local snapshot5 = _G
          local snapshot6 = _G
          local vector = _G
          local vector2 = _G
          local vector3 = _G
          local snapshot7 = _G
          _G._tuff_doTP = teleportToTarget
          snapshot._tuff_velMoveThrough = traverseRouteVelocity
          snapshot2._tuff_computeRoute = computeOptimizedRoute
          snapshot3._tuff_carpetEngage = equipRoutingTools
          snapshot4._tuff_getClosestBaseIdx = findClosestBaseIndex
          snapshot5._tuff_BASES_LOW = lowerBasePositions
          snapshot6._tuff_BASES_HIGH = upperBasePositions
          vector._tuff_FRONT_Y_LOW = lowerFloorY
          vector2._tuff_FRONT_Y_HIGH = 16.850713
          vector3._tuff_UPPER_Y_THRESHOLD = upperFloorThreshold
          snapshot7._tuff_SPEED = 400
        end
        do
          local rootPart = _G
          local snapshot = _G
          _G._tuff_smoothRamp = applySmoothVelocityRamp
          rootPart._tuff_getPetPosition = getTargetAnimalPosition
          snapshot._tuff_RunService = routeRunService
        end
        do
          local xenMutValid, xenMutColor
          xenMutValid = {}
          xenMutColor = {}
          do
            local success, callResult = pcall(function()
              return require(enumValues.ReplicatedStorage:WaitForChild("Datas"):WaitForChild("Mutations"))
            end)
            if success and type(callResult) == "table" then
              for k, item in pairs(callResult) do
                local text = tostring(k)
                if text == "Yin Yang" then
                  text = "YinYang"
                end
                xenMutValid[text] = true
                if type(item) == "table" and typeof(item.MainColor) == "Color3" then
                  xenMutColor[text] = item.MainColor
                end
              end
            end
          end
          if not next(xenMutValid) then
            for _, item in ipairs({
              "Cursed",
              "Gold",
              "Diamond",
              "YinYang",
              "Rainbow",
              "Lava",
              "Crystal",
              "Bloodrot",
              "Radioactive",
              "Divine",
              "Galaxy",
              "Cyber",
              "Phantom",
              "Candy",
            }) do
              xenMutValid[item] = true
            end
          end
          do
            local snapshot = _G
            _G._xenMutValid = xenMutValid
            snapshot._xenMutColor = xenMutColor
          end
        end
        config = {
          AUTO_STEAL = false,
          RADIUS = 16,
        }
        collection = {}
        do
          local items = {
            min = Vector3.new(-337.448303, -3.898971, -122.228622),
            max = Vector3.new(-328.004578, -3.898971, 242.625626),
          }
          local items2 = {
            min = Vector3.new(-327.25766, -3.899109, -122.228622),
            max = Vector3.new(-320.600891, -3.899109, 242.612259),
          }
          local items3 = {
            min = Vector3.new(-319.783386, -3.89897, -122.227089),
            max = Vector3.new(-312.908325, -3.89897, 242.585617),
          }
          local items4 = {
            min = Vector3.new(-312.445648, -3.899108, -122.389832),
            max = Vector3.new(-305.489899, -3.899108, 242.456818),
          }
          local items5 = {
            min = Vector3.new(-305.037048, -3.898972, -122.230743),
            max = Vector3.new(-293.957489, -3.898972, 242.606873),
          }
          local items6 = {
            min = Vector3.new(-491.448608, -3.898972, -122.253258),
            max = Vector3.new(-481.811737, -3.898972, 242.615005),
          }
          local items7 = {
            min = Vector3.new(-498.971069, -3.898972, -122.382767),
            max = Vector3.new(-491.74884, -3.898972, 242.612061),
          }
          local items8 = {
            min = Vector3.new(-506.436737, -3.898972, -122.411476),
            max = Vector3.new(-506.436737, -3.898972, 242.615982),
          }
          local items9 = {
            min = Vector3.new(-513.783569, -3.898972, -122.223297),
            max = Vector3.new(-513.783569, -3.898972, 242.62709),
          }
          local items10 = {
            min = Vector3.new(-525.236938, -3.898972, -122.223297),
            max = Vector3.new(-514.265015, -3.898972, 242.608932),
          }
          collection[1] = items
          collection[2] = items2
          collection[3] = items3
          collection[4] = items4
          collection[5] = items5
          collection[6] = items6
          collection[7] = items7
          collection[8] = items8
          collection[9] = items9
          collection[10] = items10
        end
        local getValue
        do
          local localPlayer3, state, state2, state3
          localPlayer3 = enumValues.Players.LocalPlayer
          state = {}
          state2 = {}
          state3 = {}
          do
            local amount = 0
            _G.triggerSafePollBoost = function()
              amount = os.clock() + 3
            end
          end
          local state4, findTarget, findTarget2
          state4 = 0.08
          findTarget = function()
            local character = localPlayer3.Character
            return character and character:FindFirstChild("HumanoidRootPart")
          end
          do
            local function getValue(vector)
              for i, item in ipairs(collection) do
                if
                  vector.X >= math.min(item.min.X, item.max.X)
                  and vector.X <= math.max(item.min.X, item.max.X)
                  and vector.Z >= math.min(item.min.Z, item.max.Z)
                  and vector.Z <= math.max(item.min.Z, item.max.Z)
                then
                  return i
                end
              end
            end
            local function checkCondition(instance2)
              local parent = instance2.Parent
              if not parent then
                return
              end
              if parent:IsA("Attachment") and parent.Parent then
                parent = parent.Parent
              end
              if parent:IsA("BasePart") then
                return parent.Position
              end
              if parent:IsA("Model") then
                return parent:GetPivot().Position
              end
            end
            findTarget2 = function(instance, data)
              if not instance or not instance.Parent then
                return false
              end
              if not instance.Enabled then
                return false
              end
              local state = checkCondition(instance)
              if not state then
                return false
              end
              local plots = workspace:FindFirstChild("Plots")
              if plots then
                local model = instance:FindFirstAncestorWhichIsA("Model")
                while model and model.Parent ~= plots do
                  model = model.Parent
                end
                if model then
                  local plotSign = model:FindFirstChild("PlotSign")
                  if plotSign then
                    local surfaceGui = plotSign:FindFirstChildWhichIsA("SurfaceGui", true)
                    surfaceGui = surfaceGui and surfaceGui:FindFirstChildWhichIsA("TextLabel", true)
                    if surfaceGui then
                      local lowercaseText = surfaceGui.Text:lower()
                      local pos = lowercaseText:find(localPlayer3.Name:lower(), 1, true)
                      if not pos then
                        pos = lowercaseText:find((localPlayer3.DisplayName or ""):lower(), 1, true)
                      end
                      if pos then
                        return false
                      end
                    end
                  end
                end
              end
              local state2 = getValue(data)
              local state3 = getValue(state)
              if not state2 or state2 ~= state3 then
                return false
              end
              return (state - data).Magnitude
                <= math.min(
                  config.RADIUS,
                  typeof(instance.MaxActivationDistance) == "number"
                      and instance.MaxActivationDistance > 0
                      and instance.MaxActivationDistance
                    or config.RADIUS
                )
            end
          end
          do
            local function handleState() end
            getValue = function(data)
              if state[data] then
                return
              end
              state[data] = true
              local function getValue()
                if not _G.AutoStealNearestEnabled then
                  return
                end
                local rootPart = findTarget()
                if not rootPart then
                  return
                end
                if findTarget2(data, rootPart.Position) then
                  local now2 = os.clock()
                  local entry = state3[data]
                  if not entry or now2 - entry >= state4 then
                    state3[data] = now2
                    handleState()
                  end
                end
              end
              task.defer(getValue)
              pcall(function()
                data:GetPropertyChangedSignal("Enabled"):Connect(function()
                  if data.Enabled then
                    getValue()
                  end
                end)
              end)
              data.AncestryChanged:Connect(function()
                if not data:IsDescendantOf(workspace) then
                  state[data] = nil
                  state2[data] = nil
                  state3[data] = nil
                end
              end)
            end
          end
        end
        do
          local function findTarget()
            local plots_2 = workspace:FindFirstChild("Plots")
            if not plots_2 then
              return
            end
            for _, child in ipairs(plots_2:GetChildren()) do
              local animalPodiums = child:FindFirstChild("AnimalPodiums")
              if animalPodiums then
                for _, descendant in ipairs(animalPodiums:GetDescendants()) do
                  if descendant:IsA("ProximityPrompt") then
                    getValue(descendant)
                  end
                end
              end
            end
          end
          findTarget()
        end
        workspace.DescendantAdded:Connect(function(descendant)
          if descendant:IsA("ProximityPrompt") and descendant:FindFirstAncestor("AnimalPodiums") then
            getValue(descendant)
          end
        end)
        if _G.XenHubLoaded then
          if _G.XenHubCleanup then
            pcall(_G.XenHubCleanup)
          end
          task.wait(0.1)
        end
        _G.XenHubLoaded = true
        pcall(function()
          local items = {
            Comma = ",",
            Period = ".",
            Semicolon = ";",
            Quote = "'",
            LeftBracket = "[",
            RightBracket = "]",
            Slash = "/",
            BackSlash = "\\",
            Backquote = "`",
            Equals = "=",
            Minus = "-",
            Plus = "+",
            Space = "Space",
            Return = "Enter",
            Tab = "Tab",
            Backspace = "Bksp",
            Delete = "Del",
            Insert = "Ins",
            Home = "Home",
            End = "End",
            PageUp = "PgUp",
            PageDown = "PgDn",
            LeftShift = "LShift",
            RightShift = "RShift",
            LeftControl = "LCtrl",
            RightControl = "RCtrl",
            LeftAlt = "LAlt",
            RightAlt = "RAlt",
            CapsLock = "Caps",
            Escape = "Esc",
            Tilde = "~",
            One = "1",
            Two = "2",
            Three = "3",
            Four = "4",
            Five = "5",
            Six = "6",
            Seven = "7",
            Eight = "8",
            Nine = "9",
            Zero = "0",
          }
          _G._keyDisplay = function(data)
            return items[data] or data
          end
        end)
        if not _G._keyDisplay then
          _G._keyDisplay = function(data)
            return data
          end
        end
        _G.isTeleporting = false
        _G.TPSpeedItem = _G.TPSpeedItem or "Flying Carpet"
        do
          local snapshot = _G
          _G.HighValueSoundEnabled = true
          snapshot.HighValueSoundId = "100173184074904"
        end
        task.spawn(function()
          pcall(function()
            if _G._xenConvDataLoaded then
              return
            end
            local datas = enumValues.ReplicatedStorage:WaitForChild("Datas", 10)
            local shared = enumValues.ReplicatedStorage:WaitForChild("Shared", 10)
            if not datas or not shared then
              return
            end
            _G._xenAnimalsData = require(datas:WaitForChild("Animals", 5))
            _G._xenSharedAnim = _G._xenAnimShim
            _G._xenConvDataLoaded = true
          end)
        end)
        pcall(function()
          local localPlayerTeleportData = enumValues.TeleportService:GetLocalPlayerTeleportData()
          if
            localPlayerTeleportData
            and localPlayerTeleportData.Keybinds
            and localPlayerTeleportData.Keybinds.HighValueSoundEnabled ~= nil
          then
            _G.HighValueSoundEnabled = localPlayerTeleportData.Keybinds.HighValueSoundEnabled
          end
          if
            localPlayerTeleportData
            and localPlayerTeleportData.Keybinds
            and localPlayerTeleportData.Keybinds.HighValueSoundId ~= nil
          then
            _G.HighValueSoundId = localPlayerTeleportData.Keybinds.HighValueSoundId
          end
          if _G.HighValueSoundEnabled == true then
            pcall(function()
              local function loadData(data)
                if not readfile or not isfile then
                  return nil
                end
                if not isfile(data) then
                  return nil
                end
                return enumValues.HttpService:JSONDecode(readfile(data))
              end
              local json = loadData("xendlessKeybinds.json") or loadData("XenHubKeybinds.json")
              if json and json.HighValueSoundEnabled ~= nil then
                _G.HighValueSoundEnabled = json.HighValueSoundEnabled
              end
              if json and json.HighValueSoundId ~= nil then
                _G.HighValueSoundId = json.HighValueSoundId
              end
            end)
          end
        end)
        task.spawn(function()
          task.wait(0.1)
          local isEnabled = false
          local function xenDoJoinScan(data)
            if not data then
              if isEnabled then
                return
              end
              isEnabled = true
            end
            local sharedPriorityItems2 = _G.SHARED_PRIORITY_ITEMS
              or _G._earlyPriorityList
              or {
                "headless horseman",
                "signore carapace",
                "strawberry elephant",
                "meowl",
                "john pork",
                "skibidi toilet",
                "elefanto frigo",
                "arcadragon",
                "griffin",
                "love love bear",
                "antonio",
                "dragon gingerini",
                "kalika bros",
                "dragon aquanini",
                "fishino clownino",
                "moby bros",
                "bumbatron",
                "jelly moby",
                "digi narwhal",
                "la supreme combinasion",
                "kraken",
                "ginger gerat",
                "hydra bunny",
                "s'more serat",
                "grabatron",
                "pancake and syrup",
                "tirilikalika tirilikalako",
                "hydra dragon cannelloni",
                "bunny and eggy",
                "dragon cannelloni",
                "la breakfast combinasion",
                "queen bee",
                "venuspino",
                "dug dug dug",
                "rico dinero",
                "los admins",
                "ketupat bros",
                "duggy bros",
                "la casa boo",
                "foxini lanternini",
                "popcuru and fizzuru",
                "cerberus",
                "rosey and teddy",
                "los hackers",
                "globa steppa",
                "capitano americano",
                "bearito cabinito",
                "spooky and pumpky",
                "reinito sleighito",
                "rubrikiko",
                "cooki and milki",
                "quackini snackini",
                "burguro and fryuro",
                "capitano moby",
                "garama and madundung",
              }
            _G._xenJoinPriorityList = sharedPriorityItems2
            _G.MutationPriority = _G.MutationPriority
              or {
                "Candy",
                "Bloodrot",
                "Phantom",
                "Cyber",
                "Lava",
                "Yin Yang",
                "Galaxy",
                "Radioactive",
                "Cursed",
                "Divine",
                "Crystal",
                "Rainbow",
                "Diamond",
                "Gold",
                "Base",
              }
            local state = nil
            local amount = 0
            local owner = nil
            local traits = nil
            local state2 = nil
            local huge = math.huge
            local state3 = nil
            local amount2 = 0
            local owner2 = nil
            local traits2 = nil
            local state4 = nil
            local amount3 = 0
            local xenMutValid = _G._xenMutValid
              or {
                Cursed = true,
                Gold = true,
                Diamond = true,
                YinYang = true,
                Rainbow = true,
                Lava = true,
                Candy = true,
                Bloodrot = true,
                Radioactive = true,
                Divine = true,
                Galaxy = true,
                Cyber = true,
                Phantom = true,
                Crystal = true,
              }
            local text = enumValues.Players.LocalPlayer
                and enumValues.Players.LocalPlayer.Name
                and enumValues.Players.LocalPlayer.Name:lower()
              or ""
            local calculatedValue = (_G.TPMinValue or 5) * 1000000
            local xenAnimalsCache2 = _G._xenAnimalsCache or {}
            for _, item in ipairs(xenAnimalsCache2) do
              amount3 += 1
              if amount3 % 40 == 0 then
                task.wait()
              end
              if not (item.owner and item.owner:lower() == text) then
                local name = item.name or "Unknown"
                local mutation = item.mutation
                if mutation == "None" or mutation == "" or mutation == "N/A" then
                  mutation = nil
                end
                if mutation == "Yin Yang" then
                  mutation = "YinYang"
                end
                if mutation and not xenMutValid[mutation] then
                  mutation = nil
                end
                local genValue = item.genValue or 0
                local lowercaseText = name:lower()
                for i, itemLocal449 in ipairs(sharedPriorityItems2) do
                  if
                    lowercaseText:find(itemLocal449:lower(), 1, true)
                    and (i < huge or i == huge and getMutationRank(mutation) < getMutationRank(state3))
                  then
                    huge = i
                    state2 = name
                    state3 = mutation
                    amount2 = genValue
                    owner2 = item.owner
                    traits2 = item.traits
                    break
                  end
                end
                if genValue >= calculatedValue and genValue > amount then
                  amount = genValue
                  state = name
                  state4 = mutation
                  owner = item.owner
                  traits = item.traits
                end
              end
            end
            local renderedMovingAnimals = workspace:FindFirstChild("RenderedMovingAnimals")
            if renderedMovingAnimals and _G._xenAnimalsData and _G._xenSharedAnim then
              for _, child in ipairs(renderedMovingAnimals:GetChildren()) do
                pcall(function()
                  if not child:IsA("Model") then
                    return
                  end
                  local player = _G._xenAnimalsData[child.Name]
                  if not player then
                    return
                  end
                  local attribute = child:GetAttribute("Mutation")
                  local text
                  if attribute == "None" or attribute == "" or attribute == "N/A" then
                    text = nil
                  else
                    text = attribute
                  end
                  if text == "Yin Yang" then
                    text = "YinYang"
                  end
                  if text and not xenMutValid[text] then
                    text = nil
                  end
                  local generation = _G._xenSharedAnim:GetGeneration(child.Name, attribute, nil, nil) or 0
                  local displayName = player.DisplayName or child.Name
                  local lowercaseText = displayName:lower()
                  for i, item in ipairs(sharedPriorityItems2) do
                    if
                      lowercaseText:find(item:lower(), 1, true)
                      and (i < huge or i == huge and getMutationRank(text) < getMutationRank(state3))
                    then
                      huge = i
                      state2 = displayName
                      state3 = text
                      amount2 = generation
                      owner2 = nil
                      traits2 = nil
                      break
                    end
                  end
                  if generation >= calculatedValue and generation > amount then
                    amount = generation
                    state = displayName
                    state4 = text
                    owner = nil
                    traits = nil
                  end
                end)
              end
            end
            local name, mut, state5, owner3, traits3
            if state2 then
              name = state2
              mut = state3
              state5 = amount2
              owner3 = owner2
              traits3 = traits2
            else
              name = state
              mut = state4
              state5 = amount
              owner3 = owner
              traits3 = traits
            end
            if data then
              name = data.name
              mut = data.mut
              state5 = data.value
              owner3 = data.owner
              traits3 = data.traits
            end
            if traits3 and next(traits3) and not _G._xenTraitsData then
              pcall(function()
                _G._xenTraitsData = require(enumValues.ReplicatedStorage:WaitForChild("Datas"):WaitForChild("Traits"))
              end)
            end
            local isEnabled = false
            if owner3 then
              pcall(function()
                for _, player in ipairs(enumValues.Players:GetPlayers()) do
                  if player.Name:lower() == tostring(owner3):lower() then
                    if player:GetAttribute("__duels_block_steal") == true then
                      isEnabled = true
                    end
                    break
                  end
                end
              end)
            end
            if name then
              if (data or state2) and _G.HighValueSoundEnabled ~= false then
                pcall(function()
                  local Sound = newInstance("Sound")
                  setProperties(Sound, {
                    SoundId = "rbxassetid://" .. (_G.HighValueSoundId or "100173184074904"),
                    Volume = 1,
                    Parent = enumValues.SoundService,
                  })
                  Sound:Play()
                  enumValues.Debris:AddItem(Sound, 10)
                end)
              end
              local playerGui = enumValues.Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
              if playerGui then
                local teleportMessage = playerGui:FindFirstChild("TeleportMessage")
                if teleportMessage then
                  teleportMessage:Destroy()
                end
                local isActive = enumValues.UserInputService.TouchEnabled
                  and not enumValues.UserInputService.KeyboardEnabled
                  and not enumValues.UserInputService.MouseEnabled
                local function getValue(data)
                  local isConditionMet = data or 0
                  if isConditionMet >= 1e12 then
                    return string.format("%.1fT", isConditionMet / 1e12)
                  end
                  if isConditionMet >= 1e9 then
                    return string.format("%.1fB", isConditionMet / 1e9)
                  end
                  if isConditionMet >= 1000000 then
                    return string.format("%.1fM", isConditionMet / 1000000)
                  end
                  if isConditionMet >= 1000 then
                    return string.format("%.1fK", isConditionMet / 1000)
                  end
                  return tostring(math.floor(isConditionMet))
                end
                local items = {
                  Cursed = alertRedColor,
                  Gold = goldColor,
                  Diamond = Color3.fromRGB(0, 255, 255),
                  YinYang = Color3.fromRGB(220, 220, 220),
                  Rainbow = Color3.fromRGB(255, 100, 200),
                  Lava = Color3.fromRGB(255, 100, 20),
                  Crystal = Color3.fromRGB(228, 175, 242),
                  Candy = Color3.fromRGB(255, 105, 180),
                  Bloodrot = Color3.fromRGB(139, 0, 0),
                  Radioactive = Color3.fromRGB(0, 255, 0),
                  Divine = Color3.fromRGB(255, 255, 150),
                  Galaxy = Color3.fromRGB(155, 50, 255),
                  Cyber = Color3.fromRGB(50, 180, 255),
                  Phantom = grayColor,
                }
                local calculatedValue = (isActive and 8 or 12) + (isActive and 38 or 58) + (isActive and 8 or 14)
                local function getValue2(data, data2)
                  local calculatedValue = #data * data2 * 0.6
                  pcall(function()
                    calculatedValue = enumValues.TextService:GetTextSize(
                      data,
                      data2,
                      enumValues.gothamBoldFont,
                      Vector2.new(10000, 200)
                    ).X
                  end)
                  return calculatedValue
                end
                local state = getValue2(mut and mut .. " " .. name or name, isActive and 14 or 22)
                local isConditionMet = isActive and 14 or 20
                local xenTraitsData = traits3 and _G._xenTraitsData
                local amount = 0
                if xenTraitsData then
                  for _, item in ipairs(traits3) do
                    local entry = _G._xenTraitsData[item]
                    if entry and entry.Icon and entry.Icon ~= "" then
                      amount += 1
                    end
                  end
                end
                local isActive2 = amount > 0
                if isActive2 then
                  isActive2 = amount * (isConditionMet + (isActive and 2 or 3)) + (isActive and 5 or 7)
                end
                isActive2 = isActive2 or 0
                local calculatedValue2 = state + isActive2
                local state2 = getValue2("$" .. getValue(state5) .. "/s", isActive and 10 or 14)
                local clampedValue = math.clamp(
                  calculatedValue
                    + math.max(calculatedValue2, state2)
                    + (isActive and 18 or 30)
                    + (isEnabled and (isActive and 72 or 100) or 0),
                  isActive and 200 or 300,
                  isActive and 380 or 640
                )
                local isConditionMet2 = isActive and 54 or 82
                local ScreenGui = newInstance("ScreenGui")
                setProperties(ScreenGui, {
                  Name = "TeleportMessage",
                  ResetOnSpawn = false,
                  IgnoreGuiInset = true,
                  DisplayOrder = 9999,
                  Parent = playerGui,
                })
                local parentLocal53 = newInstance("Frame")
                setProperties(parentLocal53, {
                  Name = "Card",
                  AnchorPoint = Vector2.new(0.5, 0),
                  Size = UDim2.new(0, clampedValue, 0, isConditionMet2),
                  Position = UDim2.new(0.5, 0, 0, -isConditionMet2 - 20),
                  BackgroundColor3 = Color3.fromRGB(14, 14, 20),
                  BackgroundTransparency = 0.08,
                  BorderSizePixel = 0,
                  Parent = ScreenGui,
                })
                newInstance("UICorner", parentLocal53).CornerRadius = UDim.new(0, isActive and 10 or 14)
                local isConditionMet3 = isActive and 38 or 58
                local parent2 = newInstance("Frame")
                setProperties(parent2, {
                  Size = UDim2.new(0, isConditionMet3, 0, isConditionMet3),
                  Position = UDim2.new(0, isActive and 8 or 12, 0.5, -isConditionMet3 / 2),
                  BackgroundColor3 = Color3.fromRGB(24, 24, 34),
                  BorderSizePixel = 0,
                  Parent = parentLocal53,
                })
                newInstance("UICorner", parent2).CornerRadius = UDim.new(0, isActive and 7 or 10)
                local tweenProperties = {
                  Color = indigoAccentColor,
                  Thickness = 1.5,
                  Transparency = 0.35,
                }
                setProperties(newInstance("UIStroke", parent2), tweenProperties)
                local frame = newInstance("Frame")
                setProperties(frame, {
                  Name = "ViewportHolder",
                  Size = UDim2.new(1, -4, 1, -4),
                  Position = UDim2.new(0, 2, 0, 2),
                  BackgroundTransparency = 1,
                  Parent = parent2,
                })
                pcall(function()
                  if _G.buildViewport then
                    _G.buildViewport(frame, name, mut)
                  end
                end)
                local calculatedValue3 = (isActive and 8 or 12) + isConditionMet3 + (isActive and 8 or 12)
                local isConditionMet4 = isEnabled and (isActive and 70 or 120) or isActive and 12 or 36
                local textLabel = newInstance("TextLabel")
                setProperties(textLabel, {
                  Name = "ItemName",
                  BackgroundTransparency = 1,
                  Position = UDim2.new(0, calculatedValue3, 0, isActive and 8 or 16),
                  Size = UDim2.new(1, -calculatedValue3 - isConditionMet4, 0, isActive and 18 or 28),
                  RichText = true,
                })
                if mut == "Phantom" then
                  local textSize = isActive and 14 or 22
                  local state = getValue2(mut .. " ", textSize)
                  local label = newInstance("TextLabel")
                  setProperties(label, {
                    Name = "ItemMut",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, calculatedValue3, 0, isActive and 8 or 16),
                    Size = UDim2.new(0, state, 0, isActive and 18 or 28),
                    Font = enumValues.gothamBoldFont,
                    TextSize = textSize,
                    TextXAlignment = enumValues.textAlignLeft,
                    TextYAlignment = enumValues.verticalAlignCenter,
                    Text = mut,
                    TextColor3 = whiteColor,
                  })
                  local stroke = newInstance("UIStroke", label)
                  stroke.Color = blackColor
                  stroke.Thickness = 3
                  local gradient = newInstance("UIGradient", label)
                  gradient.Rotation = 90
                  local items = {}
                  local state2 = ColorSequenceKeypoint.new(0, Color3.fromRGB(210, 210, 210))
                  local state3 = ColorSequenceKeypoint.new(0.5, mediumGrayColor)
                  items[1] = state2
                  items[2] = state3
                  items[3] = ColorSequenceKeypoint.new(1, Color3.fromRGB(65, 65, 65))
                  gradient.Color = ColorSequence.new(items)
                  label.Parent = parentLocal53
                  setProperties(textLabel, {
                    Position = UDim2.new(0, calculatedValue3 + state, 0, isActive and 8 or 16),
                    Size = UDim2.new(1, -(calculatedValue3 + state) - isConditionMet4, 0, isActive and 18 or 28),
                    Text = name,
                  })
                elseif mut then
                  local text
                  if mut == "Rainbow" then
                    local items = {
                      "rgb(255,0,0)",
                      "rgb(255,127,0)",
                      "rgb(255,255,0)",
                      "rgb(0,255,0)",
                      "rgb(0,150,255)",
                      "rgb(75,0,255)",
                      "rgb(200,0,255)",
                    }
                    text = ""
                    for i = 1, #mut do
                      text ..= "<font color='" .. items[(i - 1) % #items + 1] .. "'>" .. mut:sub(i, i) .. "</font>"
                    end
                  elseif mut == "Candy" then
                    local state = #mut
                    text = ""
                    for i = 1, state do
                      local isConditionMet = state > 1 and (i - 1) / (state - 1) or 0
                      text ..= "<font color='rgb(" .. math.floor(255 - 55 * isConditionMet) .. "," .. math.floor(
                        190 - 30 * isConditionMet
                      ) .. "," .. math.floor(230 + 25 * isConditionMet) .. ")'>" .. mut:sub(i, i) .. "</font>"
                    end
                  else
                    local color = items[mut] or Color3.fromRGB(160, 120, 255)
                    text = string.format(
                      "<font color='rgb(%d,%d,%d)'>%s</font>",
                      math.floor(color.R * 255 + 0.5),
                      math.floor(color.G * 255 + 0.5),
                      math.floor(color.B * 255 + 0.5),
                      mut
                    )
                  end
                  textLabel.Text = text .. " " .. name
                else
                  textLabel.Text = name
                end
                setProperties(textLabel, {
                  TextColor3 = whiteColor,
                  Font = enumValues.gothamBoldFont,
                  TextSize = isActive and 14 or 22,
                  TextXAlignment = enumValues.textAlignLeft,
                  TextYAlignment = enumValues.verticalAlignCenter,
                  TextTruncate = enumValues.truncateAtEnd,
                  Parent = parentLocal53,
                })
                if amount > 0 and _G._xenTraitsData and traits3 then
                  local calculatedValue = calculatedValue3 + state + (isActive and 5 or 7)
                  local calculatedValue2 = (isActive and 8 or 16)
                    + math.floor(((isActive and 18 or 28) - isConditionMet) / 2)
                  for _, item in ipairs(traits3) do
                    local entry = _G._xenTraitsData[item]
                    if entry and entry.Icon and entry.Icon ~= "" then
                      setProperties(newInstance("ImageLabel"), {
                        Name = "Trait",
                        Size = UDim2.new(0, isConditionMet, 0, isConditionMet),
                        Position = UDim2.new(0, calculatedValue, 0, calculatedValue2),
                        BackgroundTransparency = 1,
                        Image = entry.Icon,
                        ScaleType = Enum.ScaleType.Fit,
                        Parent = parentLocal53,
                      })
                      calculatedValue = calculatedValue + isConditionMet + (isActive and 2 or 3)
                    end
                  end
                end
                setProperties(newInstance("TextLabel"), {
                  Name = "ItemValue",
                  BackgroundTransparency = 1,
                  Position = UDim2.new(0, calculatedValue3, 0, isActive and 28 or 46),
                  Size = UDim2.new(1, -calculatedValue3 - isConditionMet4, 0, isActive and 16 or 18),
                  Text = "$" .. getValue(state5) .. "/s",
                  TextColor3 = Color3.fromRGB(150, 152, 168),
                  Font = enumValues.gothamBoldFont,
                  TextSize = isActive and 10 or 14,
                  TextXAlignment = enumValues.textAlignLeft,
                  TextYAlignment = enumValues.verticalAlignCenter,
                  Parent = parentLocal53,
                })
                if isEnabled then
                  local parentLocal54 = newInstance("Frame")
                  setProperties(parentLocal54, {
                    Name = "Badges",
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, isActive and -8 or -14, 0.5, 0),
                    AutomaticSize = Enum.AutomaticSize.XY,
                    BackgroundTransparency = 1,
                    Parent = parentLocal53,
                  })
                  setProperties(newInstance("UIListLayout", parentLocal54), {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDim.new(0, isActive and 4 or 6),
                  })
                  local function buildInterface(text, backgroundColor3, layoutOrder)
                    local label = newInstance("TextLabel")
                    setProperties(label, {
                      AutomaticSize = Enum.AutomaticSize.X,
                      Size = UDim2.new(0, 0, 0, isActive and 16 or 24),
                      BackgroundColor3 = backgroundColor3,
                      BackgroundTransparency = 0.8,
                      Text = text,
                      TextColor3 = backgroundColor3,
                      Font = enumValues.gothamBoldFont,
                      TextSize = isActive and 9 or 12,
                      LayoutOrder = layoutOrder,
                      Parent = parentLocal54,
                    })
                    local cornerRadius = fullCornerRadius
                    newInstance("UICorner", label).CornerRadius = cornerRadius
                    local uIPadding = newInstance("UIPadding", label)
                    local udim = UDim.new(0, isActive and 7 or 11)
                    local udim2 = UDim.new(0, isActive and 7 or 11)
                    uIPadding.PaddingLeft = udim
                    uIPadding.PaddingRight = udim2
                    setProperties(newInstance("UIStroke", label), {
                      Color = backgroundColor3,
                      Thickness = 1,
                      Transparency = 0.5,
                    })
                  end
                  if isEnabled then
                    buildInterface("IN DUEL", Color3.fromRGB(248, 113, 113), 1)
                  end
                end
                local frame2 = newInstance("Frame")
                setProperties(frame2, {
                  Name = "AccentLine",
                  AnchorPoint = Vector2.new(0, 1),
                  Position = UDim2.new(0, isActive and 8 or 12, 1, isActive and -3 or -5),
                  Size = UDim2.new(1, isActive and -16 or -28, 0, 2),
                  BackgroundColor3 = indigoAccentColor,
                  BorderSizePixel = 0,
                  Parent = parentLocal53,
                })
                enumValues.TweenService
                  :Create(parentLocal53, TweenInfo.new(0.45, enumValues.backEasing, enumValues.easingOut), {
                    Position = UDim2.new(0.5, 0, 0, isActive and 12 or 22),
                  })
                  :Play()
                task.delay(0.45, function()
                  if frame2 and frame2.Parent then
                    enumValues.TweenService
                      :Create(frame2, TweenInfo.new(4, Enum.EasingStyle.Linear), {
                        Size = UDim2.new(0, 0, 0, 2),
                      })
                      :Play()
                  end
                end)
                task.delay(4.45, function()
                  if parentLocal53 and parentLocal53.Parent then
                    local tween = enumValues.TweenService:Create(
                      parentLocal53,
                      TweenInfo.new(0.35, Enum.EasingStyle.Quart, enumValues.easingIn),
                      {
                        Position = UDim2.new(0.5, 0, 0, -isConditionMet2 - 20),
                      }
                    )
                    tween:Play()
                    tween.Completed:Connect(function()
                      if ScreenGui and ScreenGui.Parent then
                        ScreenGui:Destroy()
                      end
                    end)
                  elseif ScreenGui and ScreenGui.Parent then
                    ScreenGui:Destroy()
                  end
                end)
              end
            end
          end
          _G._xenDoJoinScan = xenDoJoinScan
          task.spawn(function()
            _G._xenNotifSuppressUntil = os.clock() + 8
            _G._xenPostScanCallbacks = _G._xenPostScanCallbacks or {}
            local isEnabledLocal548 = false
            local amount = 0
            local getValue = nil
            local function getValue2()
              local snapshot = isEnabledLocal548
              local state
              if isEnabledLocal548 then
                state = snapshot
              else
                state = isEnabled
              end
              if state then
                return
              end
              isEnabledLocal548 = true
              for i = #_G._xenPostScanCallbacks, 1, -1 do
                if _G._xenPostScanCallbacks[i] == getValue then
                  table.remove(_G._xenPostScanCallbacks, i)
                end
              end
              xenDoJoinScan()
            end
            getValue = function()
              if isEnabledLocal548 then
                return
              end
              amount += 1
              local snapshot = amount
              task.delay(0.4, function()
                if snapshot ~= amount then
                  return
                end
                if (_G._xenAnimalsCache and #_G._xenAnimalsCache or 0) > 0 then
                  getValue2()
                end
              end)
            end
            table.insert(_G._xenPostScanCallbacks, getValue)
            task.spawn(function()
              local renderedMovingAnimals = workspace:FindFirstChild("RenderedMovingAnimals")
                or workspace:WaitForChild("RenderedMovingAnimals", 8)
              if not renderedMovingAnimals then
                return
              end
              local isEnabledLocal81 = false
              local function getValue()
                if isEnabledLocal81 or isEnabledLocal548 or isEnabled then
                  return
                end
                isEnabledLocal81 = true
                task.delay(1.5, function()
                  if not (isEnabledLocal548 or isEnabled) then
                    getValue2()
                  end
                end)
              end
              local function onChildAdded(child)
                if isEnabledLocal81 or isEnabledLocal548 or isEnabled then
                  return
                end
                if not (child and child:IsA("Model") and _G._xenAnimalsData and _G._xenSharedAnim) then
                  return
                end
                pcall(function()
                  if not _G._xenAnimalsData[child.Name] then
                    return
                  end
                  if
                    (_G.TPMinValue or 5) * 1000000
                    <= (_G._xenSharedAnim:GetGeneration(child.Name, child:GetAttribute("Mutation"), nil, nil) or 0)
                  then
                    getValue()
                  end
                end)
              end
              for _, child in ipairs(renderedMovingAnimals:GetChildren()) do
                onChildAdded(child)
                if not isEnabledLocal81 then
                  continue
                end
                break
              end
              local connection = renderedMovingAnimals.ChildAdded:Connect(onChildAdded)
              task.delay(4, function()
                if connection then
                  connection:Disconnect()
                end
              end)
            end)
          end)
        end)
        task.spawn(function()
          _G._xenPostScanCallbacks = _G._xenPostScanCallbacks or {}
          local lowercaseText = (enumValues.Players.LocalPlayer and enumValues.Players.LocalPlayer.Name or ""):lower()
          local items = {}
          enumValues.Players.PlayerAdded:Connect(function(player)
            if player ~= enumValues.Players.LocalPlayer then
              items[player.Name:lower()] = true
            end
          end)
          enumValues.Players.PlayerRemoving:Connect(function(player)
            items[player.Name:lower()] = nil
          end)
          table.insert(_G._xenPostScanCallbacks, function(data)
            local xenAnimalsCache2 = _G._xenAnimalsCache
            local xenJoinPriorityList = _G._xenJoinPriorityList
            if not (xenAnimalsCache2 and xenJoinPriorityList) then
              return
            end
            local animalInfo = nil
            local huge = math.huge
            local state = nil
            for _, item in ipairs(xenAnimalsCache2) do
              if item.plot == data and item.owner then
                local lowercaseTextLocal549 = tostring(item.owner):lower()
                if lowercaseTextLocal549 ~= lowercaseText then
                  local lowercaseTextLocal492 = (item.name or ""):lower()
                  for i, itemLocal450 in ipairs(xenJoinPriorityList) do
                    if lowercaseTextLocal492:find(itemLocal450, 1, true) then
                      local isActive = i < huge
                      if not isActive then
                        isActive = i == huge
                        if isActive then
                          isActive = getMutationRank(item.mutation)
                            < getMutationRank(animalInfo and animalInfo.mutation)
                        end
                      end
                      if isActive then
                        animalInfo = item
                        huge = i
                        state = lowercaseTextLocal549
                      end
                      break
                    end
                  end
                end
              end
            end
            if animalInfo and state then
              local entry = items[state]
              items[state] = nil
              local mutation = animalInfo.mutation
              if mutation == "None" or mutation == "" or mutation == "N/A" then
                mutation = nil
              end
              if mutation == "Yin Yang" then
                mutation = "YinYang"
              end
              if _G._xenDoJoinScan and entry then
                _G._xenDoJoinScan({
                  name = animalInfo.name,
                  mut = mutation,
                  value = animalInfo.genValue or 0,
                  owner = animalInfo.owner,
                  traits = animalInfo.traits,
                })
              end
              if
                _G.ContinuousTP
                and _G._tween_runAutoSnipe
                and not enumValues.Players.LocalPlayer:GetAttribute("Stealing")
              then
                local isEnabled = false
                pcall(function()
                  local humanoidRootPart = enumValues.Players.LocalPlayer.Character
                    and enumValues.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                  local plots_2 = workspace:FindFirstChild("Plots")
                  if humanoidRootPart and plots_2 then
                    local position = humanoidRootPart.Position
                    for _, child in ipairs(plots_2:GetChildren()) do
                      local stealHitbox = child:FindFirstChild("StealHitbox")
                      if stealHitbox and stealHitbox:IsA("BasePart") then
                        local vector = stealHitbox.CFrame:PointToObjectSpace(position)
                        local calculatedValue = stealHitbox.Size.X * 0.5
                        local isActive = math.abs(vector.X) <= calculatedValue
                        if isActive then
                          local calculatedValue = stealHitbox.Size.Z * 0.5
                          isActive = math.abs(vector.Z) <= calculatedValue
                        end
                        if isActive then
                          isEnabled = true
                          break
                        end
                      end
                    end
                  end
                end)
                if not isEnabled then
                  task.spawn(function()
                    local isEnabled = false
                    local function getValue()
                      if isEnabled then
                        return false
                      end
                      if not (_G._findAdorneeForEntry and _G._findAdorneeForEntry(animalInfo)) then
                        return false
                      end
                      isEnabled = true
                      local tweenIsManualTP = _G._tween_isManualTP
                      local snapshot = _G
                      local snapshot2 = _G
                      local snapshot3 = _G
                      local pickTarget = _G._pickTarget and _G._pickTarget() or animalInfo
                      snapshot._tween_isManualTP = true
                      snapshot2._tween_overrideTarget = pickTarget
                      snapshot3._tuff_forceLocked = true
                      pcall(_G._tween_runAutoSnipe)
                      local snapshot4 = _G
                      _G._tuff_forceLocked = false
                      snapshot4._tween_isManualTP = tweenIsManualTP
                      return true
                    end
                    if not getValue() then
                      local isConditionMet = workspace:FindFirstChild("Plots")
                        and workspace:FindFirstChild("Plots"):FindFirstChild(animalInfo.plot)
                      if isConditionMet then
                        local connection = nil
                        connection = isConditionMet.DescendantAdded:Connect(function()
                          if getValue() and connection then
                            connection:Disconnect()
                          end
                        end)
                        task.delay(6, function()
                          if connection then
                            connection:Disconnect()
                          end
                        end)
                      end
                    end
                  end)
                end
              end
            end
          end)
        end)
        pcall(function()
          local localPlayerTeleportData = enumValues.TeleportService:GetLocalPlayerTeleportData()
          local function getValue(player)
            if type(player) ~= "table" then
              return
            end
            local function getValue(data, data2)
              if type(data) == "string" then
                if data:match("^MouseButton%d$") then
                  return data
                end
                local success, callResult = pcall(function()
                  return Enum.KeyCode[data]
                end)
                if success and callResult then
                  return callResult
                end
              end
              return data2
            end
            if player.ManualTPKey ~= nil then
              _G.ManualTPKey = getValue(player.ManualTPKey, Enum.KeyCode.T)
            end
            if player.InvisibleStealKey ~= nil then
              _G.INVISIBLE_STEAL_KEY = getValue(player.InvisibleStealKey, Enum.KeyCode.U)
            end
            if player.JobIDKey ~= nil then
              _G.JOBID_KEYBIND = getValue(player.JobIDKey, Enum.KeyCode.K)
            end
            if player.WalkspeedKey ~= nil then
              _G.WALKSPEED_KEY = getValue(player.WalkspeedKey, Enum.KeyCode.V)
            end
            if player.AutoBuyCarpetKey ~= nil then
              _G.AUTO_BUY_CARPET_KEY = getValue(player.AutoBuyCarpetKey, Enum.KeyCode.N)
            end
            if player.OpenMenuKey ~= nil then
              _G.OPEN_MENU_KEY = getValue(player.OpenMenuKey, Enum.KeyCode.LeftControl)
            end
            if player.RagdollSelfKey ~= nil then
              _G.RAGDOLL_SELF_KEY = getValue(player.RagdollSelfKey, Enum.KeyCode.R)
            end
            if player.ResetCharacterKey ~= nil then
              _G.RESET_CHARACTER_KEY = getValue(player.ResetCharacterKey, Enum.KeyCode.X)
            end
            if player.SpeedboostKey ~= nil then
              _G.SPEEDBOOST_KEY = getValue(player.SpeedboostKey, Enum.KeyCode.Q)
            end
            if player.AutoTurretKey ~= nil then
              _G.AUTO_TURRET_KEY = getValue(player.AutoTurretKey, Enum.KeyCode.G)
            end
            if player.FloatKey ~= nil then
              _G.FLOAT_KEY = getValue(player.FloatKey, Enum.KeyCode.B)
            end
            if player.ClickToAPKey ~= nil then
              _G.CLICK_TO_AP_KEY = getValue(player.ClickToAPKey, Enum.KeyCode.Z)
            end
            if player.StealNearestKey ~= nil then
              _G.STEAL_NEAREST_KEY = getValue(player.StealNearestKey, Enum.KeyCode.Unknown)
            end
            if player.SpamBaseOwnerKey ~= nil then
              _G.SPAM_BASE_KEY = getValue(player.SpamBaseOwnerKey, Enum.KeyCode.Unknown)
            end
          end
          if localPlayerTeleportData and localPlayerTeleportData.Keybinds then
            local keybinds = localPlayerTeleportData.Keybinds
            if keybinds.TPSpeedItem then
              _G.TPSpeedItem = keybinds.TPSpeedItem
            end
            if keybinds.TPVelocity ~= nil then
              _G.TPVelocity = math.clamp(tonumber(keybinds.TPVelocity) or 300, 200, 1000)
            end
            if keybinds.TPTravelSpeed ~= nil then
              _G.TPTravelSpeed = math.clamp(tonumber(keybinds.TPTravelSpeed) or 400, 200, 600)
            end
            if keybinds.TPCloseSpeed ~= nil then
              _G.TPCloseSpeed = math.clamp(tonumber(keybinds.TPCloseSpeed) or 300, 200, 600)
            end
            local customPriorityList = keybinds.CustomPriorityList
            if customPriorityList then
              customPriorityList = type(keybinds.CustomPriorityList) == "table"
            end
            if customPriorityList and #keybinds.CustomPriorityList > 0 then
              _G._earlyPriorityList = keybinds.CustomPriorityList
            end
            if
              keybinds.MutationPriority
              and type(keybinds.MutationPriority) == "table"
              and #keybinds.MutationPriority > 0
            then
              local mutationPriority = keybinds.MutationPriority
              local items = {}
              for _, item in ipairs(mutationPriority) do
                items[tostring(item)] = true
              end
              local mutationPriority2 = {}
              for _, item2 in ipairs({
                "Crystal",
                "Bloodrot",
                "Phantom",
                "Cyber",
                "Lava",
                "Yin Yang",
                "Galaxy",
                "Radioactive",
                "Cursed",
                "Divine",
                "Crystal",
                "Rainbow",
                "Diamond",
                "Gold",
                "Base",
              }) do
                if not items[item2] then
                  mutationPriority2[#mutationPriority2 + 1] = item2
                end
              end
              for _, item3 in ipairs(mutationPriority) do
                mutationPriority2[#mutationPriority2 + 1] = item3
              end
              _G.MutationPriority = mutationPriority2
            end
            if keybinds.AutoStealPriorityEnabled ~= nil then
              _G.AutoStealPriorityEnabled = keybinds.AutoStealPriorityEnabled
            end
            if keybinds.AutoStealHighestEnabled ~= nil then
              _G.AutoStealHighestEnabled = keybinds.AutoStealHighestEnabled
            end
            if keybinds.AutoTPEnabled ~= nil then
              _G.AutoTPEnabledFromSave = keybinds.AutoTPEnabled
              _G.autoTPButtonEnabled = keybinds.AutoTPEnabled
            end
            if keybinds.ApproachFloor2FromFloor1 ~= nil then
              _G.ApproachFloor2FromFloor1 = keybinds.ApproachFloor2FromFloor1
            end
            if keybinds.TPMinValue ~= nil then
              _G.TPMinValue = math.clamp(tonumber(keybinds.TPMinValue) or 5, 0, 50)
            end
            if keybinds.TPDelay ~= nil then
              _G.TPDelay = math.clamp(tonumber(keybinds.TPDelay) or 0, 0, 1)
            end
            if keybinds.LandingDelay ~= nil then
              _G.LandingDelay = math.clamp(tonumber(keybinds.LandingDelay) or 0.3, 0.15, 0.75)
            end
            getValue(keybinds)
          else
            local function loadData(data)
              local success, callResult = pcall(function()
                if not readfile or not isfile then
                  return nil
                end
                if not isfile(data) then
                  return nil
                end
                return enumValues.HttpService:JSONDecode(readfile(data))
              end)
              return success and callResult or nil
            end
            local json = loadData("xendlessKeybinds.json") or loadData("XenHubKeybinds.json")
            if json then
              if json.TPSpeedItem then
                _G.TPSpeedItem = json.TPSpeedItem
              end
              if json.TPVelocity ~= nil then
                _G.TPVelocity = math.clamp(tonumber(json.TPVelocity) or 300, 100, 1000)
              end
              if json.TPTravelSpeed ~= nil then
                _G.TPTravelSpeed = math.clamp(tonumber(json.TPTravelSpeed) or 400, 100, 600)
              end
              if json.TPCloseSpeed ~= nil then
                _G.TPCloseSpeed = math.clamp(tonumber(json.TPCloseSpeed) or 300, 200, 600)
              end
              if
                json.CustomPriorityList
                and type(json.CustomPriorityList) == "table"
                and #json.CustomPriorityList > 0
              then
                _G._earlyPriorityList = json.CustomPriorityList
              end
              if json.MutationPriority and type(json.MutationPriority) == "table" and #json.MutationPriority > 0 then
                local mutationPriority = json.MutationPriority
                local items = {}
                for _, item in ipairs(mutationPriority) do
                  items[tostring(item)] = true
                end
                local mutationPriority2 = {}
                for _, item2 in ipairs({
                  "Crystal",
                  "Bloodrot",
                  "Phantom",
                  "Cyber",
                  "Lava",
                  "Yin Yang",
                  "Galaxy",
                  "Radioactive",
                  "Cursed",
                  "Divine",
                  "Candy",
                  "Rainbow",
                  "Diamond",
                  "Gold",
                  "Base",
                }) do
                  if not items[item2] then
                    mutationPriority2[#mutationPriority2 + 1] = item2
                  end
                end
                for _, item3 in ipairs(mutationPriority) do
                  mutationPriority2[#mutationPriority2 + 1] = item3
                end
                _G.MutationPriority = mutationPriority2
              end
              if json.AutoStealPriorityEnabled ~= nil then
                _G.AutoStealPriorityEnabled = json.AutoStealPriorityEnabled
              end
              if json.AutoStealHighestEnabled ~= nil then
                _G.AutoStealHighestEnabled = json.AutoStealHighestEnabled
              end
              if json.AutoTPEnabled ~= nil then
                _G.AutoTPEnabledFromSave = json.AutoTPEnabled
                _G.autoTPButtonEnabled = json.AutoTPEnabled
              end
              if json.ApproachFloor2FromFloor1 ~= nil then
                _G.ApproachFloor2FromFloor1 = json.ApproachFloor2FromFloor1
              end
              if json.TPMinValue ~= nil then
                _G.TPMinValue = math.clamp(tonumber(json.TPMinValue) or 5, 0, 50)
              end
              if json.TPDelay ~= nil then
                _G.TPDelay = math.clamp(tonumber(json.TPDelay) or 0, 0, 1)
              end
              if json.LandingDelay ~= nil then
                _G.LandingDelay = math.clamp(tonumber(json.LandingDelay) or 0.3, 0.15, 0.75)
              end
              getValue(json)
            end
          end
        end)
        _G.TPMode = "tween"
        do
          local sharedPriorityItems2
          if _G._earlyPriorityList and type(_G._earlyPriorityList) == "table" and #_G._earlyPriorityList > 0 then
            sharedPriorityItems2 = {}
            for _, item in ipairs(_G._earlyPriorityList) do
              sharedPriorityItems2[#sharedPriorityItems2 + 1] = item
            end
          else
            sharedPriorityItems2 = {
              "headless horseman",
              "signore carapace",
              "strawberry elephant",
              "meowl",
              "john pork",
              "skibidi toilet",
              "elefanto frigo",
              "arcadragon",
              "griffin",
              "love love bear",
              "antonio",
              "dragon gingerini",
              "kalika bros",
              "dragon aquanini",
              "fishino clownino",
              "moby bros",
              "bumbatron",
              "jelly moby",
              "digi narwhal",
              "la supreme combinasion",
              "kraken",
              "ginger gerat",
              "hydra bunny",
              "s'more serat",
              "grabatron",
              "pancake and syrup",
              "tirilikalika tirilikalako",
              "hydra dragon cannelloni",
              "bunny and eggy",
              "dragon cannelloni",
              "la breakfast combinasion",
              "queen bee",
              "venuspino",
              "dug dug dug",
              "rico dinero",
              "los admins",
              "ketupat bros",
              "duggy bros",
              "la casa boo",
              "foxini lanternini",
              "popcuru and fizzuru",
              "cerberus",
              "rosey and teddy",
              "los hackers",
              "globa steppa",
              "capitano americano",
              "bearito cabinito",
              "spooky and pumpky",
              "reinito sleighito",
              "rubrikiko",
              "cooki and milki",
              "quackini snackini",
              "burguro and fryuro",
              "capitano moby",
              "garama and madundung",
            }
          end
          _G.SHARED_PRIORITY_ITEMS = sharedPriorityItems2
        end
      end
      _G._earlyPriorityList = nil
      xenAnimalsCache = {}
      state37 = {}
      _G._xenAnimalsCache = xenAnimalsCache
      instance = enumValues.Players
      do
        ws = enumValues.Workspace
        localPlayer2 = instance.LocalPlayer
        local packages = enumValues.ReplicatedStorage:WaitForChild("Packages")
        local datas = enumValues.ReplicatedStorage:WaitForChild("Datas")
        enumValues.ReplicatedStorage:WaitForChild("Shared")
        utils = enumValues.ReplicatedStorage:WaitForChild("Utils")
        Synchronizer = require(packages:WaitForChild("Synchronizer"))
        packages:WaitForChild("Synchronizer"):WaitForChild("RequestData")
        Animals = require(datas:WaitForChild("Animals"))
      end
      do
        local NumberUtils, getValue37, getValue2
        do
          local xenAnimShim
          xenAnimShim = _G._xenAnimShim
          NumberUtils = require(utils:WaitForChild("NumberUtils"))
          _G._xenFastClone = function()
            if not enumValues.Players.LocalPlayer then
              _G._xenCloneRemotesFired = false
              return false
            end
            local character = enumValues.Players.LocalPlayer.Character
              or enumValues.Players.LocalPlayer.CharacterAdded:Wait()
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then
              _G._xenCloneRemotesFired = false
              return false
            end
            local quantumCloner = enumValues.Players.LocalPlayer:FindFirstChild("Backpack")
                and enumValues.Players.LocalPlayer.Backpack:FindFirstChild("Quantum Cloner")
              or character:FindFirstChild("Quantum Cloner")
            if not quantumCloner then
              _G._xenCloneRemotesFired = false
              return false
            end
            if quantumCloner.Parent ~= character then
              humanoid:EquipTool(quantumCloner)
              task.wait()
            end
            local xenNet = _G.XenNet
            if not xenNet then
              _G._xenCloneRemotesFired = false
              return false
            end
            local success = pcall(function()
              xenNet:RemoteEvent("UseItem"):FireServer()
            end)
            task.wait(0.05)
            local success2 = pcall(function()
              xenNet:RemoteEvent("QuantumCloner/OnTeleport"):FireServer()
            end)
            if _G.triggerSafePollBoost then
              pcall(_G.triggerSafePollBoost)
            end
            _G._xenCloneRemotesFired = success and success2
            return _G._xenCloneRemotesFired
          end
          do
            local isEnabled = false
            getValue37 = function()
              if isEnabled then
                return
              end
              isEnabled = true
              task.defer(function()
                isEnabled = false
                table.sort(xenAnimalsCache, function(data, data2)
                  return data.genValue > data2.genValue
                end)
              end)
            end
          end
          local items = {}
          getValue2 = function(data, data2, collection)
            local text2 = ""
            if type(collection) == "table" then
              local items = {}
              for _, item in pairs(collection) do
                items[#items + 1] = tostring(item)
              end
              table.sort(items)
              text2 = table.concat(items, ",")
            end
            local text3 = tostring(data) .. "|" .. tostring(data2) .. "|" .. text2
            local entry = items[text3]
            if entry ~= nil then
              return entry
            end
            local success, callResult = pcall(function()
              return xenAnimShim and xenAnimShim:GetGeneration(data, data2, collection, nil)
            end)
            callResult = success and type(callResult) == "number" and callResult > 0 and callResult or 0
            if 0 < callResult then
              items[text3] = callResult
            end
            return callResult
          end
        end
        do
          local function getValue38(collection)
            if not collection then
              return ""
            end
            local items = {}
            local amount = 0
            for k, item in pairs(collection) do
              if type(item) == "table" then
                amount += 1
                local text2 = ""
                if type(item.Traits) == "table" then
                  local items = {}
                  for _, trait in pairs(item.Traits) do
                    items[#items + 1] = tostring(trait)
                  end
                  table.sort(items)
                  text2 = table.concat(items, ",")
                end
                items[amount] = tostring(k)
                  .. "~#~"
                  .. tostring(item.Index)
                  .. "~#~"
                  .. tostring(item.Mutation)
                  .. "~#~"
                  .. text2
              end
            end
            return table.concat(items, "~|~")
          end
          local function findTarget(instance3, collection, instance4)
            pcall(function()
              local state38 = getValue38(collection)
              if state37[instance3.Name] == state38 then
                return
              end
              state37[instance3.Name] = state38
              for i = #xenAnimalsCache, 1, -1 do
                if xenAnimalsCache[i].plot == instance3.Name then
                  table.remove(xenAnimalsCache, i)
                end
              end
              if not instance4 or not instance:FindFirstChild(instance4.Name) then
                return
              end
              local name = instance4.Name or "Unknown"
              if not collection then
                return
              end
              for k, item in pairs(collection) do
                if type(item) == "table" then
                  if not (item.Machine and item.Machine.Type == "Fuse" and item.Machine.Active) then
                    local index = item.Index
                    local player = Animals[item.Index]
                    if player then
                      local mutation = item.Mutation or "None"
                      if mutation == "Yin Yang" then
                        mutation = "YinYang"
                      end
                      local genValue = getValue2(index, item.Mutation, item.Traits)
                      table.insert(xenAnimalsCache, {
                        name = player.DisplayName or index,
                        genText = "$" .. NumberUtils:ToString(genValue) .. "/s",
                        genValue = genValue,
                        mutation = mutation,
                        owner = name,
                        traits = item.Traits,
                        index = item.Index,
                        plot = instance3.Name,
                        slot = tostring(k),
                      })
                    end
                  end
                end
              end
              getValue37()
              if _G._xenPostScanCallbacks then
                for _, xenPostScanCallback in ipairs(_G._xenPostScanCallbacks) do
                  pcall(xenPostScanCallback, instance3.Name)
                end
              end
            end)
          end
          task.spawn(function()
            local plots_2 = ws:WaitForChild("Plots", 8)
            if not plots_2 then
              return
            end
            local items = {}
            for _, child in ipairs(plots_2:GetChildren()) do
              items[child.Name] = child
            end
            plots_2.ChildAdded:Connect(function(child)
              items[child.Name] = child
            end)
            plots_2.ChildRemoved:Connect(function(child)
              items[child.Name] = nil
              state37[child.Name] = nil
              for i = #xenAnimalsCache, 1, -1 do
                if xenAnimalsCache[i].plot == child.Name then
                  table.remove(xenAnimalsCache, i)
                end
              end
            end)
            local obj = setmetatable({}, {
              __mode = "k",
            })
            local function getValue(data, data2)
              if obj[data] then
                return
              end
              obj[data] = true
              local function handleState()
                local state = rawget(data, "CacheTable")
                if type(state) == "table" then
                  pcall(findTarget, data2, state.AnimalList, state.Owner)
                end
              end
              pcall(function()
                data:OnDictionaryInserted({
                  "AnimalList",
                }, handleState)
              end)
              pcall(function()
                data:OnDictionaryRemoved({
                  "AnimalList",
                }, handleState)
              end)
              pcall(function()
                data:OnChanged({
                  "AnimalList",
                }, handleState)
              end)
              pcall(function()
                data:OnChanged({
                  "Owner",
                }, handleState)
              end)
            end
            local function xenScanAndListen()
              local success, callResult = pcall(function()
                return _G.XenSyncAll()
              end)
              if not (success and type(callResult) == "table") then
                return
              end
              for k, item in pairs(callResult) do
                local entry = items[tostring(k)]
                local isActive
                if entry then
                  isActive = type(item) == "table"
                else
                  isActive = entry
                end
                if isActive then
                  local state = rawget(item, "CacheTable")
                  if type(state) == "table" then
                    pcall(findTarget, entry, state.AnimalList, state.Owner)
                  end
                  getValue(item, entry)
                end
              end
            end
            xenScanAndListen()
            _G._xenScanAndListen = xenScanAndListen
            pcall(function()
              Synchronizer.OnChannelCreated:Connect(function()
                task.defer(xenScanAndListen)
              end)
            end)
            local function xenScanConveyor()
              local xenConveyorCache = {}
              local renderedMovingAnimals = workspace:FindFirstChild("RenderedMovingAnimals")
              if renderedMovingAnimals then
                for _, child in ipairs(renderedMovingAnimals:GetChildren()) do
                  if child:IsA("Model") then
                    local player = Animals[child.Name]
                    if player then
                      local primaryPart = child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")
                      if primaryPart then
                        local attribute = child:GetAttribute("Mutation")
                        local mutation = attribute or "None"
                        if mutation == "Yin Yang" then
                          mutation = "YinYang"
                        end
                        local genValue = getValue2(child.Name, attribute, nil)
                        xenConveyorCache[#xenConveyorCache + 1] = {
                          name = player.DisplayName or child.Name,
                          genText = "$" .. NumberUtils:ToString(genValue) .. "/s",
                          genValue = genValue,
                          mutation = mutation,
                          traits = nil,
                          index = child.Name,
                          isCarpetItem = true,
                          rawPosition = primaryPart.Position,
                          model = child,
                        }
                      end
                    end
                  end
                end
              end
              _G._xenConveyorCache = xenConveyorCache
              return xenConveyorCache
            end
            _G._xenScanConveyor = xenScanConveyor
            pcall(xenScanConveyor)
            task.spawn(function()
              while true do
                pcall(xenScanConveyor)
                task.wait(0.5)
              end
            end)
          end)
        end
      end
      do
        local collection, state, state2, state3, createUiElement, findTarget11
        do
          local items = {}
          collection = {}
          state = {}
          state2 = {}
          state3 = {}
          local items2 = {
            Cursed = alertRedColor,
            Gold = goldColor,
            Diamond = Color3.fromRGB(0, 255, 255),
            YinYang = Color3.fromRGB(220, 220, 220),
            Rainbow = Color3.fromRGB(255, 100, 200),
            Lava = Color3.fromRGB(255, 100, 20),
            Crystal = Color3.fromRGB(228, 175, 242),
            Candy = Color3.fromRGB(255, 105, 180),
            Bloodrot = Color3.fromRGB(139, 0, 0),
            Radioactive = Color3.fromRGB(0, 255, 0),
            Divine = Color3.fromRGB(255, 255, 150),
            Galaxy = Color3.fromRGB(155, 50, 255),
            Cyber = Color3.fromRGB(50, 180, 255),
            Phantom = grayColor,
          }
          _G._xenIncomingClearAll = function()
            for k, descendant in pairs(items) do
              pcall(function()
                if descendant and descendant.Parent then
                  descendant:Destroy()
                end
              end)
              items[k] = nil
            end
            if collection then
              for k in pairs(collection) do
                collection[k] = nil
              end
            end
          end
          createUiElement = function(instance, data, data2, data3)
            if not instance or not instance.Parent then
              return
            end
            local animalPodiums = instance:FindFirstChild("AnimalPodiums")
            if not animalPodiums then
              return
            end
            local instance = animalPodiums:FindFirstChild(tostring(data))
            if not instance then
              return
            end
            local base = instance:FindFirstChild("Base")
            local spawn_ = base and base:FindFirstChild("Spawn")
            if not spawn_ or not spawn_:IsA("BasePart") then
              return
            end
            if items[spawn_] then
              pcall(function()
                items[spawn_]:Destroy()
              end)
              items[spawn_] = nil
            end
            local BillboardGui = newInstance("BillboardGui")
            setProperties(BillboardGui, {
              Name = _G._xenN.is,
              Size = UDim2.new(0, 220, 0, 110),
              StudsOffset = Vector3.new(0, 11, 0),
              AlwaysOnTop = true,
              Adornee = spawn_,
              Parent = spawn_,
            })
            items[spawn_] = BillboardGui
            local frame = newInstance("Frame")
            setProperties(frame, {
              Size = fillSize,
              BackgroundColor3 = blackColor,
              BackgroundTransparency = 0.2,
              BorderSizePixel = 0,
              Parent = BillboardGui,
            })
            newInstance("UICorner", frame).CornerRadius = UDim.new(0, 13)
            setProperties(newInstance("UIStroke", frame), {
              Color = Color3.fromRGB(255, 40, 40),
              Thickness = 3,
              Transparency = 0.1,
            })
            setProperties(newInstance("TextLabel", frame), {
              Size = UDim2.new(1, -16, 0, 22),
              Position = UDim2.new(0, 8, 0, 6),
              BackgroundTransparency = 1,
              Text = "INCOMING !",
              Font = enumValues.gothamBoldFont,
              TextSize = 12,
              TextColor3 = Color3.fromRGB(255, 200, 0),
            })
            setProperties(newInstance("TextLabel", frame), {
              Size = UDim2.new(1, -16, 0, 28),
              Position = UDim2.new(0, 8, 0, 32),
              BackgroundTransparency = 1,
              Text = data2 or "Unknown",
              Font = enumValues.gothamBoldFont,
              TextSize = 18,
              TextColor3 = whiteColor,
            })
            if data3 and data3 ~= "None" then
              local text = tostring(data3)
              if text == "Yin Yang" then
                text = "YinYang"
              end
              local color = items2[text] or Color3.fromRGB(200, 100, 255)
              local textLabel = newInstance("TextLabel", frame)
              setProperties(textLabel, {
                Size = UDim2.new(1, -16, 0, 18),
                Position = UDim2.new(0, 8, 0, 64),
                BackgroundTransparency = 1,
                Text = "[" .. tostring(data3) .. "]",
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextColor3 = color,
              })
              if text == "Phantom" then
                textLabel.TextColor3 = whiteColor
                local stroke = newInstance("UIStroke", textLabel)
                stroke.Color = blackColor
                stroke.Thickness = 3
                local gradient = newInstance("UIGradient", textLabel)
                gradient.Rotation = 90
                local items = {}
                local state = ColorSequenceKeypoint.new(0, Color3.fromRGB(210, 210, 210))
                local state2 = ColorSequenceKeypoint.new(0.5, mediumGrayColor)
                items[1] = state
                items[2] = state2
                items[3] = ColorSequenceKeypoint.new(1, Color3.fromRGB(65, 65, 65))
                gradient.Color = ColorSequence.new(items)
              end
              if text == "Candy" then
                textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                local gradient = newInstance("UIGradient", textLabel)
                gradient.Rotation = 0
                gradient.Color = ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 190, 230)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 100, 255)),
                })
              end
            end
            setProperties(newInstance("TextLabel", frame), {
              Size = UDim2.new(1, -16, 0, 20),
              Position = UDim2.new(0, 8, 1, -25),
              BackgroundTransparency = 1,
              Text = "SLOT #" .. tostring(data),
              Font = enumValues.gothamBoldFont,
              TextSize = 14,
              TextColor3 = whiteColor,
            })
          end
          findTarget11 = function(instance, data)
            if not instance then
              return
            end
            local animalPodiums = instance:FindFirstChild("AnimalPodiums")
            if not animalPodiums then
              return
            end
            local base = animalPodiums:FindFirstChild(tostring(data))
            base = base and base:FindFirstChild("Base")
            base = base and base:FindFirstChild("Spawn")
            if base and items[base] then
              pcall(function()
                items[base]:Destroy()
              end)
              items[base] = nil
            end
          end
        end
        local findTarget22, createUiElement2, getState2
        do
          local function findTarget12(instance)
            if not instance then
              return nil
            end
            local state = nil
            pcall(function()
              state = _G.XenSyncGet(instance.Name)
            end)
            if not state then
              return nil
            end
            local isConditionMet = _G.XenChGet(state, "AnimalList") or {}
            local animalPodiums = instance:FindFirstChild("AnimalPodiums")
            if not animalPodiums then
              return nil
            end
            for i = 1, 26 do
              if animalPodiums:FindFirstChild(tostring(i)) then
                if type(isConditionMet[i] or isConditionMet[tostring(i)]) ~= "table" then
                  return i
                end
              end
            end
            return nil
          end
          findTarget22 = function(instance2)
            if not instance2 then
              return nil
            end
            local plots_2 = ws:FindFirstChild("Plots")
            if not plots_2 then
              return nil
            end
            for _, child in ipairs(plots_2:GetChildren()) do
              local animalPodiums = child:FindFirstChild("AnimalPodiums")
              if not (animalPodiums and animalPodiums:FindFirstChild("1")) then
                continue
              end
              local success, callResult = pcall(function()
                return _G.XenSyncGet(child.Name)
              end)
              if success and callResult then
                local instance = _G.XenChGet(callResult, "Owner")
                if instance == instance2 or typeof(instance) == "Instance" and instance.Name == instance2.Name then
                  return child
                end
              end
            end
            return nil
          end
          local function findTarget23(data)
            if not data then
              return nil
            end
            local plots_2 = ws:FindFirstChild("Plots")
            if not plots_2 then
              return nil
            end
            for _, child in ipairs(plots_2:GetChildren()) do
              local success, callResult = pcall(function()
                return _G.XenSyncGet(child.Name)
              end)
              if success and callResult then
                local collection = _G.XenChGet(callResult, "AnimalList")
                if collection then
                  for _, item in pairs(collection) do
                    if type(item) ~= "table" then
                      continue
                    end
                    if item.Index == data or tostring(item.Index) == tostring(data) then
                      return item, child
                    end
                  end
                end
              end
            end
            return nil, nil
          end
          _G._xenLocalStolenSlot = function()
            local attribute = localPlayer2:GetAttribute("StealingIndex")
            if attribute == nil then
              return nil
            end
            local plots = ws:FindFirstChild("Plots")
            if not plots then
              return nil
            end
            local character = localPlayer2.Character
            character = character and character:FindFirstChild("HumanoidRootPart")
            character = character and character.Position
            local huge = math.huge
            local state = nil
            local state2 = nil
            for _, child in ipairs(plots:GetChildren()) do
              local success, callResult = pcall(function()
                return _G.XenSyncGet(child.Name)
              end)
              if success and callResult then
                local collection = _G.XenChGet(callResult, "AnimalList")
                if collection then
                  for k, item in pairs(collection) do
                    if
                      type(item) == "table" and (item.Index == attribute or tostring(item.Index) == tostring(attribute))
                    then
                      local num = tonumber(k)
                      if state == nil then
                        state = num
                      end
                      if character then
                        local animalPodiums = child:FindFirstChild("AnimalPodiums")
                        local isConditionMet = animalPodiums and animalPodiums:FindFirstChild(tostring(k))
                        if isConditionMet then
                          local success, callResult = pcall(function()
                            return isConditionMet:GetPivot().Position
                          end)
                          if success then
                            local magnitude = (callResult - character).Magnitude
                            if magnitude < huge then
                              huge = magnitude
                              state2 = num
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
            return state2 or state
          end
          _G._xenSyncSlotForTarget = function(data, data2)
            if not data or data2 == nil then
              return nil
            end
            local success, callResult = pcall(function()
              return _G.XenSyncGet(data)
            end)
            if not success or not callResult then
              return nil
            end
            local collection = _G.XenChGet(callResult, "AnimalList")
            if not collection then
              return nil
            end
            for k, item in pairs(collection) do
              if type(item) == "table" and (item.Index == data2 or tostring(item.Index) == tostring(data2)) then
                return tonumber(k)
              end
            end
            return nil
          end
          createUiElement2 = function(instance23, data)
            if not _G.AutoIncomingTP then
              return
            end
            if not instance23 or not data then
              return
            end
            local num = tonumber(data) or 0
            if num < 1 or num > 26 then
              return
            end
            local character = localPlayer2.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then
              return
            end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local animalPodiums = instance23:FindFirstChild("AnimalPodiums")
            if not animalPodiums then
              return
            end
            local instance24 = animalPodiums:FindFirstChild(tostring(num))
            if not instance24 then
              return
            end
            local base = instance24:FindFirstChild("Base")
            base = base and base:FindFirstChild("Spawn")
            if not base or not base:IsA("BasePart") then
              return
            end
            local stealHitbox = instance23:FindFirstChild("StealHitbox")
            if stealHitbox and stealHitbox:IsA("BasePart") then
              local position = humanoidRootPart.Position
              local position2 = stealHitbox.Position
              local size = stealHitbox.Size
              local calculatedValue = size.X / 2
              local isActive = math.abs(position.X - position2.X) > calculatedValue
              local isActive2
              if isActive then
                isActive2 = isActive
              else
                local calculatedValue = size.Y / 2
                isActive2 = math.abs(position.Y - position2.Y) > calculatedValue
              end
              if isActive2 or math.abs(position.Z - position2.Z) > size.Z / 2 then
                return
              end
              local promptAttachment = base:FindFirstChild("PromptAttachment")
              local instance2 = nil
              if promptAttachment then
                for _, child in ipairs(promptAttachment:GetChildren()) do
                  if child:IsA("ProximityPrompt") then
                    instance2 = child
                    break
                  end
                end
              end
              if instance2 then
                task.spawn(function()
                  local now2 = tick()
                  while true do
                    if not (tick() - now2 < 2) then
                      break
                    else
                      if instance2.Parent then
                        for i = 1, 5 do
                          pcall(function()
                            fireproximityprompt(instance2, 0)
                          end)
                        end
                        task.wait(0.05)
                        continue
                      end
                      break
                    end
                  end
                end)
              end
              if humanoid then
                if not character:FindFirstChild(_G.TPSpeedItem or "Flying Carpet") then
                  local backpack = localPlayer2:FindFirstChildOfClass("Backpack")
                  if backpack then
                    backpack = backpack:FindFirstChild(_G.TPSpeedItem or "Flying Carpet")
                  end
                  if backpack then
                    pcall(function()
                      humanoid:EquipTool(backpack)
                    end)
                  end
                end
              end
              local position3 = base.Position
              local calculatedValue2 = position3.Y - humanoidRootPart.Position.Y
              humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
              humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
              if calculatedValue2 > 2 then
                local vector2 = Vector3.new(position3.X, position3.Y - 8, position3.Z)
                local part = newInstance("Part")
                setProperties(part, {
                  Name = _G._xenN.tpp,
                  Size = Vector3.new(3, 1, 3),
                  Position = vector2 - Vector3.new(0, 5, 0),
                  Anchored = true,
                  CanCollide = true,
                  Transparency = 1,
                  Parent = workspace,
                })
                enumValues.RunService.Heartbeat:Wait()
                task.spawn(function()
                  local now2 = tick()
                  while true do
                    if not (tick() - now2 < 20) then
                      break
                    else
                      if not localPlayer2:GetAttribute("Stealing") then
                        task.wait(0.1)
                        continue
                      end
                      break
                    end
                  end
                  if part and part.Parent then
                    part:Destroy()
                  end
                end)
                humanoidRootPart.CFrame = CFrame.new(vector2)
              else
                humanoidRootPart.CFrame = CFrame.new(position3)
              end
              return
            end
          end
          getState2 = function(instance)
            if not _G.IncomingSlotPredictor then
              return
            end
            if instance == localPlayer2 then
              return
            end
            if not instance:GetAttribute("Stealing") then
              local entry = collection[instance]
              if entry and entry.plot and entry.slot then
                findTarget11(entry.plot, entry.slot)
              end
              collection[instance] = nil
              return
            end
            local plot = findTarget22(instance)
            if not plot then
              return
            end
            local attribute = instance:GetAttribute("StealingIndex")
            local state = nil
            local state2 = nil
            if attribute then
              state, state2 = findTarget23(attribute)
            end
            if state2 and state2 == plot then
              return
            end
            local slot = findTarget12(plot)
            if not slot then
              return
            end
            local text = "Unknown"
            local mutation = nil
            if attribute then
              text = Animals[attribute]
              text = text and text.DisplayName or tostring(attribute)
              mutation = nil
              if state then
                mutation = state.Mutation
              end
            end
            local entry = collection[instance]
            if entry and (entry.plot ~= plot or entry.slot ~= slot) then
              findTarget11(entry.plot, entry.slot)
            end
            createUiElement(plot, slot, text, mutation, instance.Name)
            collection[instance] = {
              plot = plot,
              slot = slot,
              index = attribute,
            }
            if attribute then
              local entry = state3[plot]
              if type(entry) ~= "table" then
                entry = {}
              end
              entry[attribute] = true
              state3[plot] = entry
            end
          end
        end
        do
          local function getState3(instance)
            if not instance:GetAttribute("Stealing") then
              return
            end
            local state = findTarget22(instance)
            if not state then
              return
            end
            local attribute = instance:GetAttribute("StealingIndex")
            if not attribute then
              return
            end
            local entry = state3[state]
            if type(entry) ~= "table" then
              entry = {}
            end
            entry[attribute] = true
            state3[state] = entry
          end
          local function onPlayerAdded(player)
            if player == localPlayer2 then
              return
            end
            pcall(function()
              player:GetAttributeChangedSignal("Stealing"):Connect(function()
                getState2(player)
                getState3(player)
              end)
              player:GetAttributeChangedSignal("StealingIndex"):Connect(function()
                if player:GetAttribute("Stealing") then
                  getState2(player)
                  getState3(player)
                end
              end)
            end)
            if player:GetAttribute("Stealing") then
              task.spawn(getState2, player)
              getState3(player)
            end
          end
          task.spawn(function()
            for _, player in ipairs(instance:GetPlayers()) do
              onPlayerAdded(player)
            end
            instance.PlayerAdded:Connect(onPlayerAdded)
            instance.PlayerRemoving:Connect(function(player)
              local entry = collection[player]
              if entry and entry.plot and entry.slot then
                findTarget11(entry.plot, entry.slot)
              end
              collection[player] = nil
            end)
          end)
        end
        task.spawn(function()
          local plots_2 = ws:WaitForChild("Plots", 8)
          if not plots_2 then
            return
          end
          local function getValue(instance2)
            if not _G.AutoIncomingTP then
              return
            end
            local success, callResult = pcall(function()
              return _G.XenSyncGet(instance2.Name)
            end)
            if not success or not callResult then
              return
            end
            local collection = nil
            pcall(function()
              collection = _G.XenChGet(callResult, "AnimalList")
            end)
            if type(collection) ~= "table" then
              return
            end
            local instance = nil
            pcall(function()
              instance = _G.XenChGet(callResult, "Owner")
            end)
            local isActive = instance == localPlayer2
            if not isActive then
              isActive = typeof(instance) == "Instance" and instance.Name == localPlayer2.Name
            end
            if isActive then
              local isConditionMet = state[instance2.Name] or {}
              for k, item in pairs(collection) do
                isConditionMet[tostring(k)] = type(item) == "table" or nil
              end
              state[instance2.Name] = isConditionMet
              state2[instance2.Name] = true
              return
            end
            local isConditionMet = state[instance2.Name] or {}
            local entry = state2[instance2.Name]
            local entry2 = state3[instance2]
            for k, item in pairs(collection) do
              local text = tostring(k)
              local isActive = type(item) == "table"
              if isActive and not isConditionMet[text] and entry then
                local index = type(item) == "table" and item.Index
                if entry2 and index and entry2[index] then
                  entry2[index] = nil
                  task.spawn(createUiElement2, instance2, tonumber(text) or k)
                end
              end
              isConditionMet[text] = isActive or nil
            end
            state[instance2.Name] = isConditionMet
            state2[instance2.Name] = true
          end
          local function getState4()
            if not _G.IncomingSlotPredictor then
              return
            end
            for k in pairs(collection) do
              if k and k.Parent and k:GetAttribute("Stealing") then
                task.spawn(getState2, k)
              end
            end
          end
          local function getValue2(instance2)
            local state = nil
            local amount = 0
            while true do
              if not state and amount < 100 then
                local success, callResult = pcall(function()
                  return _G.XenSyncGet(instance2.Name)
                end)
                if success and callResult then
                  state = callResult
                  break
                else
                  amount += 1
                  task.wait(0.05)
                  continue
                end
              end
              break
            end
            if not state then
              return
            end
            local function handleState()
              getValue(instance2)
              getState4()
            end
            pcall(function()
              state:OnDictionaryInserted({
                "AnimalList",
              }, handleState)
            end)
            pcall(function()
              state:OnDictionaryRemoved({
                "AnimalList",
              }, handleState)
            end)
            pcall(function()
              state:OnChanged({
                "AnimalList",
              }, handleState)
            end)
            getValue(instance2)
          end
          for _, child in ipairs(plots_2:GetChildren()) do
            task.spawn(getValue2, child)
          end
          plots_2.ChildAdded:Connect(function(child)
            task.spawn(getValue2, child)
          end)
        end)
      end
    end
    _G.XenPlatformTP = function(rootPart, vectorLocal476, data)
      if not rootPart or not rootPart.Parent or not vectorLocal476 then
        return false
      end
      local calculatedValue = vectorLocal476.Y - rootPart.Position.Y
      rootPart.AssemblyLinearVelocity = Vector3.zero
      rootPart.AssemblyAngularVelocity = Vector3.zero
      if calculatedValue > 2 then
        local vector2 = Vector3.new(vectorLocal476.X, vectorLocal476.Y - 8, vectorLocal476.Z)
        local part = newInstance("Part")
        setProperties(part, {
          Name = _G._xenN.tpp,
          Size = Vector3.new(3, 1, 3),
          Position = vector2 - Vector3.new(0, 5, 0),
          Anchored = true,
          CanCollide = true,
          Transparency = 1,
          Color = _G.BUTTON_GLOW_COLOR or whiteColor,
          Material = Enum.Material.SmoothPlastic,
          Parent = workspace,
        })
        enumValues.RunService.Heartbeat:Wait()
        task.spawn(function()
          local now2 = tick()
          while tick() - now2 < 20 do
            if not enumValues.Players.LocalPlayer:GetAttribute("Stealing") then
              task.wait(0.1)
              continue
            end
            break
          end
          if part and part.Parent then
            part:Destroy()
          end
        end)
        local cframe = CFrame.new(vector2)
        rootPart.AssemblyLinearVelocity = Vector3.zero
        rootPart.CFrame = cframe
        return true
      end
      if data then
        local vector2 = Vector3.new(vectorLocal476.X, rootPart.Position.Y, vectorLocal476.Z)
        rootPart.CFrame = CFrame.new(vector2, vector2 + data)
      else
        rootPart.CFrame = CFrame.new(vectorLocal476)
      end
      rootPart.AssemblyLinearVelocity = Vector3.zero
      rootPart.AssemblyAngularVelocity = Vector3.zero
      return false
    end
    _G.XenCarpetTP = function(rootPart)
      if not rootPart or not rootPart.rawPosition then
        return
      end
      local rootPartLocal496 = enumValues.Players.LocalPlayer.Character
        and enumValues.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if not rootPartLocal496 then
        return
      end
      local connection = nil
      pcall(function()
        local humanoid = enumValues.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
          humanoid.BreakJointsOnDeath = false
          humanoid:SetStateEnabled(enumValues.deadHumanoidState, false)
          humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
          humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
          humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
          connection = enumValues.RunService.Heartbeat:Connect(function()
            if humanoid and humanoid.Parent and humanoid.Health <= 0 then
              humanoid.Health = humanoid.MaxHealth
            end
          end)
        end
      end)
      local vector = Vector3.new(rootPart.rawPosition.X, rootPart.rawPosition.Y + 3, rootPart.rawPosition.Z)
      if _G._tuff_convChase then
        pcall(function()
          _G._tuff_convChase(rootPart.model, vector)
        end)
      end
      if connection then
        connection:Disconnect()
      end
      if rootPartLocal496 and rootPartLocal496.Parent then
        local vector2 = Vector3.new(0, 0, 0)
        local vector3 = Vector3.new(0, 0, 0)
        rootPartLocal496.AssemblyLinearVelocity = vector2
        rootPartLocal496.AssemblyAngularVelocity = vector3
      end
    end
    do
      local vector = Vector3.new(-341, 14, 200)
      local vector2 = Vector3.new(-341, 14, 241)
      local vector3 = Vector3.new(-5.036865, -0.01, 5.19937)
      local vector4 = Vector3.new(-5.603241, -0.01, -4.993957)
      local items = {}
      for i = 0, 3 do
        local vector5 = Vector3.new(vector.X, vector.Y, vector.Z + -107 * i)
        local vector6 = Vector3.new(vector2.X, vector2.Y, vector2.Z + -107 * i)
        table.insert(items, {
          Left = vector5,
          Right = vector6,
          Side = 1,
          SidePos = vector6 + Vector3.new(-vector3.X, vector3.Y, vector3.Z),
          OtherSidePos = vector5 + Vector3.new(-vector4.X, vector4.Y, vector4.Z),
        })
      end
      for i = 0, 3 do
        local vector5 = Vector3.new(vector.X + -137, vector.Y, vector.Z + -107 * i)
        local vector6 = Vector3.new(vector2.X + -137, vector2.Y, vector2.Z + -107 * i)
        table.insert(items, {
          Left = vector5,
          Right = vector6,
          Side = 2,
          SidePos = vector6 + vector3,
          OtherSidePos = vector5 + vector4,
        })
      end
    end
    do
      local ws, localPlayer2, isEnabled, state
      Vector3.new(-411.98956298828125, -5.408802032470703, 169.7320556640625)
      Vector3.new(-408.99603271484375, -5.4088029861450195, -129.7340545654297)
      _G._xenShowNotif = function(text, data, data2)
        task.spawn(function()
          pcall(function()
            local playerGui = enumValues.Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
            if not playerGui then
              return
            end
            local xenNotifSuppressUntil = _G._xenNotifSuppressUntil
            if xenNotifSuppressUntil then
              local xenNotifSuppressUntil2 = _G._xenNotifSuppressUntil
              xenNotifSuppressUntil = os.clock() < xenNotifSuppressUntil2
            end
            if xenNotifSuppressUntil then
              return
            end
            local teleportMessage = playerGui:FindFirstChild("TeleportMessage")
            if teleportMessage then
              teleportMessage:Destroy()
            end
            local isActive = enumValues.UserInputService.TouchEnabled
              and not enumValues.UserInputService.KeyboardEnabled
              and not enumValues.UserInputService.MouseEnabled
            local isConditionMet = isActive and 250 or 420
            local isConditionMet2 = isActive and 44 or 56
            local ScreenGui = newInstance("ScreenGui")
            setProperties(ScreenGui, {
              Name = "TeleportMessage",
              ResetOnSpawn = false,
              IgnoreGuiInset = true,
              DisplayOrder = 9999,
              Parent = playerGui,
            })
            local parent = newInstance("Frame")
            setProperties(parent, {
              AnchorPoint = Vector2.new(0.5, 0),
              Size = UDim2.new(0, isConditionMet, 0, isConditionMet2),
              Position = UDim2.new(0.5, 0, 0, -isConditionMet2 - 20),
              BackgroundColor3 = Color3.fromRGB(14, 14, 20),
              BackgroundTransparency = 0.08,
              BorderSizePixel = 0,
              Parent = ScreenGui,
            })
            newInstance("UICorner", parent).CornerRadius = UDim.new(0, isActive and 10 or 14)
            local stroke = newInstance("UIStroke", parent)
            stroke.Thickness = 1.5
            stroke.Transparency = 0.2
            local gradient = newInstance("UIGradient", stroke)
            local items = {}
            local state = ColorSequenceKeypoint.new(0, indigoAccentColor)
            local state2 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 90, 255))
            local snapshot = indigoAccentColor
            items[1] = state
            items[2] = state2
            items[3] = ColorSequenceKeypoint.new(1, snapshot)
            gradient.Color = ColorSequence.new(items)
            local label = newInstance("TextLabel")
            local tweenProperties = {
              Size = UDim2.new(1, -24, 1, -10),
              Position = UDim2.new(0, 12, 0, 2),
              BackgroundTransparency = 1,
              Text = text,
            }
            local snapshot2 = data
            local color
            if data then
              color = snapshot2
            else
              color = Color3.fromRGB(235, 235, 240)
            end
            tweenProperties.TextColor3 = color
            tweenProperties.Font = enumValues.gothamBoldFont
            tweenProperties.TextSize = isActive and 13 or 18
            tweenProperties.TextXAlignment = enumValues.textAlignCenter
            tweenProperties.TextYAlignment = enumValues.verticalAlignCenter
            tweenProperties.RichText = true
            tweenProperties.TextWrapped = true
            tweenProperties.Parent = parent
            setProperties(label, tweenProperties)
            local frame = newInstance("Frame")
            setProperties(frame, {
              AnchorPoint = Vector2.new(0, 1),
              Position = UDim2.new(0, isActive and 8 or 14, 1, isActive and -3 or -5),
              Size = UDim2.new(1, isActive and -16 or -28, 0, 2),
              BackgroundColor3 = indigoAccentColor,
              BorderSizePixel = 0,
              Parent = parent,
            })
            newInstance("UIGradient", frame).Color = ColorSequence.new({
              ColorSequenceKeypoint.new(0, indigoAccentColor),
              ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 80, 255)),
            })
            enumValues.TweenService
              :Create(parent, TweenInfo.new(0.4, enumValues.backEasing, enumValues.easingOut), {
                Position = UDim2.new(0.5, 0, 0, isActive and 12 or 22),
              })
              :Play()
            local snapshot3 = data2
            local state3
            if data2 then
              state3 = snapshot3
            else
              state3 = 2
            end
            task.delay(0.4, function()
              if frame and frame.Parent then
                enumValues.TweenService
                  :Create(frame, TweenInfo.new(state3, Enum.EasingStyle.Linear), {
                    Size = UDim2.new(0, 0, 0, 2),
                  })
                  :Play()
              end
            end)
            task.delay(0.4 + state3, function()
              if parent and parent.Parent then
                local tween = enumValues.TweenService:Create(
                  parent,
                  TweenInfo.new(0.3, Enum.EasingStyle.Quart, enumValues.easingIn),
                  {
                    Position = UDim2.new(0.5, 0, 0, -isConditionMet2 - 20),
                  }
                )
                tween:Play()
                tween.Completed:Connect(function()
                  if ScreenGui and ScreenGui.Parent then
                    ScreenGui:Destroy()
                  end
                end)
              elseif ScreenGui and ScreenGui.Parent then
                ScreenGui:Destroy()
              end
            end)
          end)
        end)
      end
      _G._xenFormatDetected = function(data, data2)
        if not data or data == "None" then
          return data2 .. " Detected!"
        end
        local items = {
          Cursed = "rgb(255,50,50)",
          Gold = "rgb(255,215,0)",
          Diamond = "rgb(0,255,255)",
          YinYang = "rgb(220,220,220)",
          Rainbow = "rgb(255,100,200)",
          Lava = "rgb(255,100,20)",
          Crystal = "rgb(228,175,242)",
          Candy = "rgb(255,105,180)",
          Bloodrot = "rgb(139,0,0)",
          Radioactive = "rgb(0,255,0)",
          Divine = "rgb(255,255,150)",
          Galaxy = "rgb(155,50,255)",
          Cyber = "rgb(50,180,255)",
          Phantom = "rgb(150,150,150)",
        }
        if data == "Rainbow" then
          local items = {
            "rgb(255,0,0)",
            "rgb(255,127,0)",
            "rgb(255,255,0)",
            "rgb(0,255,0)",
            "rgb(0,150,255)",
            "rgb(75,0,255)",
            "rgb(200,0,255)",
          }
          local state = data:upper()
          local text = ""
          for i = 1, #state do
            text ..= "<font color='" .. items[(i - 1) % #items + 1] .. "'>" .. state:sub(i, i) .. "</font>"
          end
          return text .. " " .. data2 .. " Detected!"
        end
        if data == "Crystal" then
          local state = #data
          local text = ""
          for i = 1, state do
            local isConditionMet = state > 1 and (i - 1) / (state - 1) or 0
            text ..= "<font color='rgb(" .. math.floor(255 - 55 * isConditionMet) .. "," .. math.floor(
              190 - 30 * isConditionMet
            ) .. "," .. math.floor(230 + 25 * isConditionMet) .. ")'>" .. data:sub(i, i) .. "</font>"
          end
          return text .. " " .. data2 .. " Detected!"
        end
        if data == "YinYang" then
          return "<font color='rgb(30,30,30)'>Yin</font> <font color='rgb(255,255,255)'>Yang</font> "
            .. data2
            .. " Detected!"
        end
        local text = "<font color='" .. (items[data] or "rgb(200,100,255)") .. "'>" .. data .. "</font>"
        local text2
        if data == "Phantom" then
          text2 = "<stroke color='#000000' thickness='3'>" .. text .. "</stroke>"
        else
          text2 = text
        end
        return text2 .. " " .. data2 .. " Detected!"
      end
      ws = enumValues.Workspace
      localPlayer2 = enumValues.Players.LocalPlayer
      isEnabled = false
      state = 0
      do
        local items = {}
        local vector = Vector3.new(-342.67, -5.19, 6.61)
        local vector2 = Vector3.new(-342.78, -5.14, -100.56)
        local vector3 = Vector3.new(-342.86, -5.21, 113.28)
        local vector4 = Vector3.new(-476.31, -5.14, 6.68)
        local vector5 = Vector3.new(-476.38, -5.14, -100.28)
        local vector6 = Vector3.new(-476.29, -5.14, 113.63)
        local vector7 = Vector3.new(-342.91, -5.14, 220.21)
        items[1] = vector
        items[2] = vector2
        items[3] = vector3
        items[4] = vector4
        items[5] = vector5
        items[6] = vector6
        items[7] = vector7
        items[8] = Vector3.new(-476.29, -5.14, 221.04)
      end
      local findAdorneeForEntry
      findAdorneeForEntry = function(animalInfo)
        if not animalInfo then
          return nil
        end
        local plots = ws:FindFirstChild("Plots")
        plots = plots and plots:FindFirstChild(animalInfo.plot)
        if not plots then
          return nil
        end
        local animalPodiums = plots:FindFirstChild("AnimalPodiums")
        animalPodiums = animalPodiums and animalPodiums:FindFirstChild(tostring(animalInfo.slot))
        if not animalPodiums then
          return nil
        end
        local base = animalPodiums:FindFirstChild("Base")
        if not base then
          return nil
        end
        local spawn_ = base:FindFirstChild("Spawn")
        if spawn_ then
          return spawn_
        end
        return base:FindFirstChildWhichIsA("BasePart") or base
      end
      _G._findAdorneeForEntry = findAdorneeForEntry
      do
        local function tweenXenTween(rootPart, humanoid, vectorLocal477, vector2)
          if not rootPart or not rootPart.Parent then
            return
          end
          local isActive = vector2 ~= nil and vector2.Magnitude > 0.001
          local platformStand = humanoid and humanoid.PlatformStand or false
          if humanoid then
            pcall(function()
              humanoid.PlatformStand = false
            end)
          end
          if isActive then
            pcall(function()
              rootPart.CFrame = CFrame.new(rootPart.Position, rootPart.Position + vector2)
              rootPart.AssemblyAngularVelocity = Vector3.zero
            end)
          end
          local state = _G._tuff_computeRoute(rootPart.Position, vectorLocal477, isActive and vector2 or nil)
          if not state or #state == 0 then
            state = {
              vectorLocal477,
            }
          end
          local state2 = _G._tuff_smoothRamp(rootPart.Position, state, vectorLocal477.Y)
          if not state2 or #state2 == 0 then
            state2 = state
          end
          _G._tuff_velMoveThrough(rootPart, state2, _G.TPTravelSpeed or _G._tuff_SPEED, true, true)
          if rootPart and rootPart.Parent then
            rootPart.AssemblyLinearVelocity = Vector3.zero
            rootPart.AssemblyAngularVelocity = Vector3.zero
            if isActive then
              pcall(function()
                rootPart.CFrame = CFrame.new(vectorLocal477, vectorLocal477 + vector2)
              end)
            else
              pcall(function()
                local calculatedValue = rootPart.CFrame - rootPart.CFrame.Position
                rootPart.CFrame = CFrame.new(vectorLocal477) * calculatedValue
              end)
            end
          end
          if humanoid then
            pcall(function()
              humanoid.PlatformStand = platformStand
            end)
          end
        end
        local function tweenXenTweenWithMidpoint(rootPart, data, vector, data2)
          if not rootPart or not rootPart.Parent then
            return
          end
          if
            (Vector2.new(vector.X, vector.Z) - Vector2.new(rootPart.Position.X, rootPart.Position.Z)).Magnitude > 200
          then
            tweenXenTween(
              rootPart,
              data,
              Vector3.new((rootPart.Position.X + vector.X) / 2, 45, (rootPart.Position.Z + vector.Z) / 2),
              data2
            )
            if rootPart and rootPart.Parent then
              rootPart.AssemblyLinearVelocity = Vector3.zero
              rootPart.AssemblyAngularVelocity = Vector3.zero
            end
            task.wait(0.05)
          end
          tweenXenTween(rootPart, data, vector, data2)
        end
        local snapshot = _G
        _G._tween_xenTween = tweenXenTween
        snapshot._tween_xenTweenWithMidpoint = tweenXenTweenWithMidpoint
      end
      getMutationRank = function(data)
        local mutationPriority = _G.MutationPriority
        if type(mutationPriority) ~= "table" then
          return 999
        end
        local text = (data == nil or data == "" or data == "None") and "Base" or tostring(data):gsub(" ", "")
        for i = 1, #mutationPriority do
          if tostring(mutationPriority[i]):gsub(" ", "") == text then
            return i
          end
        end
        return 999
      end
      do
        local function pickTarget()
          local xenAnimalsCache = _G._xenAnimalsCache
          local calculatedValue = (_G.TPMinValue or 5) * 1000000
          local sharedPriorityItems2 = _G.SHARED_PRIORITY_ITEMS
          local tweenOverrideTarget = _G._tween_overrideTarget
          _G._tween_overrideTarget = nil
          if tweenOverrideTarget then
            return tweenOverrideTarget
          end
          _G._xenPickStart = _G._xenPickStart or os.clock()
          local isActive = not (xenAnimalsCache and #xenAnimalsCache > 0)
          if not isActive then
            _G._xenPlotLastNonEmpty = os.clock()
          end
          if isActive then
            isActive = _G._xenPlotLastNonEmpty
            if isActive then
              local xenPlotLastNonEmpty = _G._xenPlotLastNonEmpty
              isActive = os.clock() - xenPlotLastNonEmpty < 1
            end
            if not isActive then
              isActive = not _G._xenPlotLastNonEmpty
              if isActive then
                local xenPickStart = _G._xenPickStart
                isActive = os.clock() - xenPickStart < 8
              end
            end
          end
          local isConditionMet = xenAnimalsCache and #xenAnimalsCache or 0
          local isConditionMet2 = xenAnimalsCache and xenAnimalsCache[1]
          local text = ""
          if isConditionMet2 then
            text = tostring(xenAnimalsCache[1].plot)
              .. "_"
              .. tostring(xenAnimalsCache[1].slot)
              .. "_"
              .. tostring(xenAnimalsCache[1].genValue)
          end
          local xenPickLastSig = tostring(isConditionMet) .. "|" .. text
          if _G._xenPickLastSig == xenPickLastSig then
            _G._xenPickStable = (_G._xenPickStable or 0) + 1
          else
            _G._xenPickLastSig = xenPickLastSig
            _G._xenPickStable = 0
          end
          local isActive2 = (_G._xenPickStable or 0) < 3
          local function findTarget()
            local xenPickStart = _G._xenPickStart
            if os.clock() - xenPickStart >= 12 then
              return false
            end
            local plots = workspace:FindFirstChild("Plots")
            if not plots then
              return true
            end
            local children = plots:GetChildren()
            if #children == 0 then
              return true
            end
            local success, callResult = pcall(function()
              return _G.XenSyncAll()
            end)
            local isActive = not success
            local isActive2
            if isActive then
              isActive2 = isActive
            else
              isActive2 = type(callResult) ~= "table"
            end
            if isActive2 then
              return true
            end
            for _, child in ipairs(children) do
              if rawget(callResult, child.Name) == nil then
                return true
              end
            end
            return false
          end
          local selectedPlotAnimal = nil
          local function getValue(data)
            if not sharedPriorityItems2 or not data then
              return nil
            end
            local lowercaseText = tostring(data):lower()
            for i, item in ipairs(sharedPriorityItems2) do
              local find = lowercaseText.find
              local text = tostring(item)
              if find(lowercaseText, text:lower(), 1, true) then
                return i
              end
            end
            return nil
          end
          local isActive3 = xenAnimalsCache and #xenAnimalsCache > 0
          local state2 = nil
          if isActive3 then
            state2 = nil
            if sharedPriorityItems2 then
              state2 = nil
              for i, item in ipairs(sharedPriorityItems2) do
                local lowercaseText = tostring(item):lower()
                for _, item in ipairs(xenAnimalsCache) do
                  local isActive = item
                    and item.name
                    and item.owner ~= localPlayer2.Name
                    and item.genValue
                    and item.genValue >= calculatedValue
                  if isActive then
                    isActive = tostring(item.name):lower():find(lowercaseText, 1, true)
                  end
                  if isActive then
                    if
                      not selectedPlotAnimal
                      or getMutationRank(item.mutation) < getMutationRank(selectedPlotAnimal.mutation)
                    then
                      selectedPlotAnimal = item
                      state2 = i
                    end
                  end
                end
                if not selectedPlotAnimal then
                  continue
                end
                break
              end
            end
            if not selectedPlotAnimal then
              for _, item in ipairs(xenAnimalsCache) do
                if item and item.owner ~= localPlayer2.Name and item.genValue and item.genValue >= calculatedValue then
                  local isActive = not selectedPlotAnimal
                  if not isActive then
                    isActive = (item.genValue or 0) > (selectedPlotAnimal.genValue or 0)
                  end
                  if isActive then
                    selectedPlotAnimal = item
                  end
                end
              end
            end
          end
          local xenConveyorCache = _G._xenConveyorCache
          if type(xenConveyorCache) == "table" then
            local selectedConveyorAnimal = nil
            for _, item in ipairs(xenConveyorCache) do
              local model = item and item.model
              if model and model.Parent and item.genValue and item.genValue >= calculatedValue then
                local primaryPart = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                primaryPart = primaryPart and primaryPart.Position or item.rawPosition
                if primaryPart then
                  local name = item.name
                  local prioRank = getValue(name)
                  local isEnabled
                  if not selectedConveyorAnimal then
                    isEnabled = true
                  elseif
                    prioRank and (not selectedConveyorAnimal._prioRank or prioRank < selectedConveyorAnimal._prioRank)
                  then
                    isEnabled = true
                  elseif
                    selectedConveyorAnimal._prioRank and (not prioRank or prioRank > selectedConveyorAnimal._prioRank)
                  then
                    isEnabled = false
                  else
                    isEnabled = item.genValue > selectedConveyorAnimal.genValue
                  end
                  if isEnabled then
                    selectedConveyorAnimal = {
                      name = name,
                      genValue = item.genValue,
                      mutation = item.mutation,
                      rawPosition = primaryPart,
                      model = model,
                      isCarpetItem = true,
                      _prioRank = prioRank,
                    }
                  end
                end
              end
            end
            if selectedConveyorAnimal then
              local prioRank = selectedConveyorAnimal._prioRank
              local snapshot = state2
              local function getValue()
                if prioRank and (not snapshot or prioRank < snapshot) then
                  return true
                end
                if snapshot and (not prioRank or snapshot < prioRank) then
                  return false
                end
                if prioRank and snapshot and prioRank == snapshot then
                  local state41 = getMutationRank(selectedConveyorAnimal.mutation)
                  local state2 = getMutationRank(selectedPlotAnimal and selectedPlotAnimal.mutation)
                  if state41 ~= state2 then
                    return state41 < state2
                  end
                end
                return (selectedConveyorAnimal.genValue or 0)
                  > (selectedPlotAnimal and selectedPlotAnimal.genValue or 0)
              end
              isActive2 = isActive2 or findTarget()
              if selectedPlotAnimal then
                if getValue() and not isActive2 then
                  selectedPlotAnimal = selectedConveyorAnimal
                end
              elseif not isActive and not isActive2 then
                selectedPlotAnimal = selectedConveyorAnimal
              end
            end
          end
          return selectedPlotAnimal
        end
        _G._pickTarget = pickTarget
        _G._tween_runAutoSnipe = function()
          if isEnabled then
            return
          end
          if os.clock() - state < 2 then
            return
          end
          if not _G._tween_isManualTP and not _G.autoTPButtonEnabled then
            return
          end
          pcall(function()
            local character = localPlayer2.Character
            local backpack = localPlayer2:FindFirstChild("Backpack")
            local isConditionMet = character and character:FindFirstChildOfClass("Humanoid")
            if backpack and isConditionMet and isConditionMet.Parent then
              local tpSpeedItem = _G.TPSpeedItem or "Flying Carpet"
              character = character and character:FindFirstChild(tpSpeedItem)
              if not (character and character:IsA("Tool")) then
                local instance = backpack:FindFirstChild(tpSpeedItem)
                if instance and instance:IsA("Tool") then
                  pcall(function()
                    isConditionMet:EquipTool(instance)
                  end)
                end
              end
            end
          end)
          local rootPart = pickTarget()
          if not rootPart then
            if not _G._tween_isManualTP and _G._xenShowNotif then
              pcall(function()
                _G._xenShowNotif("No valuable brainrots detected", lightRedColor, 2)
              end)
            end
            return
          end
          if not _G._tween_isManualTP and _G._xenShowNotif and _G._xenFormatDetected then
            pcall(function()
              local snapshot = greenColor
              _G._xenShowNotif(_G._xenFormatDetected(rootPart.mutation, rootPart.name), snapshot, 3)
            end)
          end
          if rootPart.isCarpetItem then
            if not _G._tween_isManualTP and _G._xenShowNotif then
              pcall(function()
                _G._xenShowNotif("Carpet: " .. (rootPart.name or "Unknown"), Color3.fromRGB(50, 255, 50), 2)
              end)
            end
            local rawPosition = rootPart.rawPosition
            local character = localPlayer2.Character
            character = character and character:FindFirstChild("HumanoidRootPart")
            if rawPosition and character then
              local vector = Vector3.new(rawPosition.X, rawPosition.Y + 3, rawPosition.Z)
              if _G._tuff_convChase then
                pcall(function()
                  _G._tuff_convChase(rootPart.model, vector)
                end)
              end
              if character and character.Parent then
                character.AssemblyLinearVelocity = Vector3.zero
                character.AssemblyAngularVelocity = Vector3.zero
              end
            end
            state = os.clock()
            return
          end
          local character = localPlayer2.Character
          if character then
            character:FindFirstChild("HumanoidRootPart")
          end
          local humanoid = character and character:FindFirstChildOfClass("Humanoid")
          if not humanoid or not humanoid or humanoid.Health <= 0 then
            return
          end
          isEnabled = true
          _G._tween_isTpMoving = true
          local connection = nil
          local connection2 = nil
          pcall(function()
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
          end)
          pcall(function()
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
          end)
          pcall(function()
            humanoid:SetStateEnabled(enumValues.deadHumanoidState, false)
          end)
          pcall(function()
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
          end)
          pcall(function()
            connection = humanoid.HealthChanged:Connect(function(health)
              if health <= 0 and humanoid.Parent then
                humanoid.Health = humanoid.MaxHealth
              end
            end)
          end)
          pcall(function()
            connection2 = enumValues.RunService.Heartbeat:Connect(function()
              if humanoid and humanoid.Parent and humanoid.Health > 0 then
                humanoid.Health = humanoid.MaxHealth
              end
            end)
          end)
          local function cleanup()
            if connection then
              pcall(function()
                connection:Disconnect()
              end)
            end
            if connection2 then
              pcall(function()
                connection2:Disconnect()
              end)
            end
            pcall(function()
              humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            end)
            pcall(function()
              humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            end)
            pcall(function()
              humanoid:SetStateEnabled(enumValues.deadHumanoidState, true)
            end)
            pcall(function()
              humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
            end)
            isEnabled = false
            _G._tween_isTpMoving = false
            state = os.clock()
          end
          local success, callResult = pcall(function()
            local curStealSlot = tonumber(rootPart.slot) or _G._xenSyncSlotForTarget(rootPart.plot, rootPart.index)
            _G._curStealSlot = curStealSlot
            local position
            if rootPart.plot and curStealSlot then
              position = _G._tuff_getPetPosition(rootPart.plot, curStealSlot)
              if not position then
                return
              end
            else
              local rootPart = findAdorneeForEntry(rootPart)
              if not rootPart then
                return
              end
              position = rootPart.Position
            end
            pcall(function()
              if _G._xenShowStealInfoOnly then
                _G._xenShowStealInfoOnly(rootPart.name, rootPart.genValue)
              end
            end)
            _G._tuff_doTP(position, rootPart.plot, rootPart.name, curStealSlot)
          end)
          if not success then
            warn("[Tween TP] Error:", callResult)
          end
          cleanup()
        end
      end
    end
    do
      local items = {}
      registerCleanupConnection = function(data)
        if data then
          table.insert(items, data)
        end
        return data
      end
      _G.XenHubCleanup = function()
        for _, item in ipairs(items) do
          pcall(function()
            if item and typeof(item) == "RBXScriptConnection" then
              item:Disconnect()
            end
          end)
        end
        items = {}
        pcall(function()
          local playerGui = enumValues.Players.LocalPlayer:FindFirstChild("PlayerGui")
          if playerGui then
            local playerListUI = playerGui:FindFirstChild("PlayerListUI") or _G._xenHUI():FindFirstChild("PlayerListUI")
            if playerListUI then
              playerListUI:Destroy()
            end
            local teleportMessage = playerGui:FindFirstChild("TeleportMessage")
            if teleportMessage then
              teleportMessage:Destroy()
            end
          end
        end)
        local vector = _G
        _G.XenHub_InfJumpActive = nil
        vector.XenHubLoaded = nil
      end
    end
  end
  local playerGui
  do
    local instance25
    do
      local xenSideDown, xenFireSide, xenEndSide
      do
        local state42, state2, state3
        PlayersService = enumValues.Players
        localPlayer = PlayersService.LocalPlayer or PlayersService:WaitForChild("LocalPlayer", 1)
        instance25 = enumValues.ReplicatedStorage
        TeleportService = enumValues.TeleportService
        InputService = enumValues.UserInputService
        RunService = enumValues.RunService
        state42 = enumValues.UserInputService
        state2 = 6
        state3 = {}
        _G._xenIB = function(onInputBegan)
          state3[#state3 + 1] = onInputBegan
          return state42.InputBegan:Connect(onInputBegan)
        end
        do
          local items = {}
          local isEnabled = true
          local now2 = os.clock()
          local xenIB = _G._xenIB
          local function getValue(input)
            local userInputType = input.UserInputType
            local keyCode = input.KeyCode
            return (typeof(userInputType) == "EnumItem" and userInputType.Name or tostring(userInputType))
              .. "/"
              .. (typeof(keyCode) == "EnumItem" and keyCode.Name or tostring(keyCode))
          end
          _G._xenIB = function(data)
            now2 = os.clock()
            if isEnabled then
              local now3 = os.clock()
              local isConditionMet = tonumber(_G.XenEarlyInputMaxAge) or 90
              for _, item in ipairs(items) do
                if now3 - item.t <= isConditionMet then
                  pcall(data, item.i, item.g)
                end
              end
            end
            return xenIB(data)
          end
          state42.InputBegan:Connect(function(input, gameProcessed)
            if not isEnabled then
              return
            end
            local state = getValue(input)
            for _, item in ipairs(items) do
              if item.id == state then
                local now3 = os.clock()
                item.i = input
                item.g = gameProcessed
                item.t = now3
                return
              end
            end
            if #items < 24 then
              items[#items + 1] = {
                id = state,
                i = input,
                g = gameProcessed,
                t = os.clock(),
              }
            end
          end)
          task.spawn(function()
            local now3 = os.clock()
            while true do
              task.wait(1)
              local now4 = os.clock()
              if not (now4 - now3 > 180 or now4 - now3 > 20 and now4 - now2 > 30) then
                continue
              end
              break
            end
            isEnabled = false
            items = {}
          end)
        end
        _G._xenIsMouseBind = function(data)
          return type(data) == "string" and data:match("^MouseButton%d$") ~= nil
        end
        _G._xenBindHit = function(input, data)
          if not (data == nil or input == nil) then
            if type(data) == "string" then
              local userInputType = input.UserInputType
              if userInputType == nil then
                return false
              end
              return (
                type(userInputType) == "table" and userInputType.Name
                or typeof(userInputType) == "EnumItem" and userInputType.Name
                or tostring(userInputType)
              ) == data
            end
            return input.UserInputType == enumValues.keyboardInput and input.KeyCode == data
          end
          return false
        end
        _G._xenResolveBind = function(data, data2)
          if _G._xenIsMouseBind(data) then
            return data
          end
          local success, callResult = pcall(function()
            return Enum.KeyCode[data]
          end)
          if success and callResult then
            return callResult
          end
          return data2
        end
        _G._xenBindName = function(instance2)
          if instance2 == nil then
            return "Unknown"
          end
          if type(instance2) == "string" then
            return instance2
          end
          if typeof(instance2) == "EnumItem" then
            return instance2.Name
          end
          return tostring(instance2)
        end
        _G._xenBindLabel = function(instance)
          if instance == nil then
            return "None"
          end
          if type(instance) == "string" then
            local match = instance:match("^MouseButton(%d)$")
            return match and "MB" .. match or instance
          end
          if instance == Enum.KeyCode.Unknown then
            return "None"
          end
          return instance.Name
        end
        do
          local function getValue(data)
            for _, item in ipairs({
              iskeydown,
              iskeypressed,
            }) do
              if typeof(item) ~= "function" then
                continue
              end
              local success, callResult = pcall(item, data)
              if success and callResult then
                return true
              end
            end
            if typeof(getkeystate) == "function" then
              local success, callResult = pcall(getkeystate, data)
              if success then
                if callResult == true then
                  return true
                end
                local isActive = type(callResult) == "number"
                if isActive then
                  isActive = callResult < 0
                  if not isActive then
                    isActive = bit32
                    if isActive then
                      isActive = bit32.band(callResult, 32768) ~= 0
                    end
                  end
                end
                if isActive then
                  return true
                end
              end
            end
            return false
          end
          xenSideDown = function(data)
            local text = "MouseButton" .. tostring(data)
            local success, callResult = pcall(function()
              return Enum.UserInputType[text]
            end)
            if success and callResult then
              local success, callResult = pcall(function()
                return state42:IsMouseButtonPressed(callResult)
              end)
              if success and callResult then
                return true
              end
            end
            local success2, callResult2 = pcall(function()
              return Enum.KeyCode[text]
            end)
            if success2 and callResult2 then
              local success, callResult = pcall(function()
                return state42:IsKeyDown(callResult2)
              end)
              if success and callResult then
                return true
              end
              if typeof(iskeydown) == "function" then
                local success, callResult = pcall(iskeydown, callResult2)
                if success and callResult then
                  return true
                end
              end
            end
            return getValue(data == 5 and state2 or 5)
          end
        end
        _G._xenSideDown = xenSideDown
        do
          local function getValue(data, userInputState)
            return {
              UserInputType = {
                Name = "MouseButton" .. tostring(data),
                Value = data == 5 and 5 or 4,
              },
              KeyCode = Enum.KeyCode.Unknown,
              UserInputState = userInputState,
              Position = Vector3.new(),
              Delta = Vector3.new(),
              _xenSynthetic = true,
            }
          end
          local function sendRequest(data, payload)
            local success, callResult = pcall(getconnections, data)
            if success and type(callResult) == "table" and #callResult > 0 then
              for _, item in ipairs(callResult) do
                pcall(function()
                  item:Fire(payload, false)
                end)
              end
              return true
            end
            return false
          end
          xenFireSide = function(data)
            local state43 = getValue(data, Enum.UserInputState.Begin)
            if not sendRequest(state42.InputBegan, state43) then
              for i = 1, #state3 do
                pcall(state3[i], state43, false)
              end
            end
          end
          xenEndSide = function(data)
            local state44 = getValue(data, Enum.UserInputState.End)
            sendRequest(state42.InputEnded, state44)
          end
        end
      end
      _G._xenFireSide = xenFireSide
      _G._xenEndSide = xenEndSide
      do
        local isEnabled = false
        local isEnabled2 = false
        enumValues.RunService.Heartbeat:Connect(function()
          if os.clock() < (_G._xenCaptureUntil or 0) then
            local state = xenSideDown(4)
            local state2 = xenSideDown(5)
            isEnabled = state
            isEnabled2 = state2
            return
          end
          local state = xenSideDown(4)
          local state2 = xenSideDown(5)
          if state and not isEnabled then
            xenFireSide(4)
          elseif isEnabled and not state then
            xenEndSide(4)
          end
          if state2 and not isEnabled2 then
            xenFireSide(5)
          elseif isEnabled2 and not state2 then
            xenEndSide(5)
          end
          isEnabled = state
          isEnabled2 = state2
        end)
      end
      task.spawn(function()
        local antiKnockbackEnabled = true
        local isEnabled = false
        local items = {}
        local humanoid = nil
        local rootPart = nil
        local animator = nil
        local vector = Vector3.new(0, 0, 0)
        pcall(function()
          if _G.AntiKnockbackEnabledFromSave ~= nil then
            antiKnockbackEnabled = _G.AntiKnockbackEnabledFromSave
            if not antiKnockbackEnabled then
              isEnabled = true
            end
          elseif readfile and isfile and isfile("antiragdoll_state.txt") then
            if readfile("antiragdoll_state.txt") == "off" then
              antiKnockbackEnabled = false
              isEnabled = true
            else
              antiKnockbackEnabled = true
              isEnabled = false
            end
          end
        end)
        _G.antiKnockbackEnabled = antiKnockbackEnabled
        local function saveData()
          pcall(function()
            _G.antiKnockbackEnabled = antiKnockbackEnabled
            if writefile and _G.saveKeybinds then
              _G.saveKeybinds()
            end
            if writefile then
              writefile("antiragdoll_state.txt", antiKnockbackEnabled and "on" or "off")
            end
          end)
        end
        local instance
        local function findTarget()
          if not instance then
            return false
          end
          local instance26 = instance:FindFirstChild(_G.TPSpeedItem or "Flying Carpet")
          if not instance26 then
            return false
          end
          local humanoidRootPart = instance:FindFirstChild("HumanoidRootPart")
          if humanoidRootPart then
            for _, child in ipairs(humanoidRootPart:GetChildren()) do
              if child:IsA("BodyVelocity") or child:IsA("BodyPosition") or child:IsA("BodyGyro") then
                return true
              end
            end
          end
          for _, child in ipairs(instance26:GetChildren()) do
            if child:IsA("BodyVelocity") or child:IsA("BodyPosition") or child:IsA("BodyGyro") then
              return true
            end
          end
          return false
        end
        local function getValue()
          if not humanoid then
            return false
          end
          local humanoidState = humanoid:GetState()
          if
            humanoidState ~= Enum.HumanoidStateType.Physics
            and humanoidState ~= Enum.HumanoidStateType.Ragdoll
            and humanoidState ~= Enum.HumanoidStateType.FallingDown
            and humanoidState ~= Enum.HumanoidStateType.GettingUp
          then
            return false
          end
          return true
        end
        local function enableFeature()
          pcall(function()
            local playerModule = localPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule", 10)
            require(playerModule):GetControls():Enable()
          end)
        end
        local isEnabled2 = false
        local function createUiElement()
          local localPlayer2 = game:GetService("Players").LocalPlayer
          local character = localPlayer2 and localPlayer2.Character or instance
          if not character then
            return
          end
          local humanoid2 = character:FindFirstChildOfClass("Humanoid")
          if not humanoid2 or humanoid2.RigType ~= Enum.HumanoidRigType.R15 or humanoid2.Health <= 0 then
            return
          end
          for _, item in ipairs({
            {
              "Root",
              "HumanoidRootPart",
              "LowerTorso",
            },
            {
              "Waist",
              "LowerTorso",
              "UpperTorso",
            },
            {
              "Neck",
              "UpperTorso",
              "Head",
            },
            {
              "LeftShoulder",
              "UpperTorso",
              "LeftUpperArm",
            },
            {
              "LeftElbow",
              "LeftUpperArm",
              "LeftLowerArm",
            },
            {
              "LeftWrist",
              "LeftLowerArm",
              "LeftHand",
            },
            {
              "RightShoulder",
              "UpperTorso",
              "RightUpperArm",
            },
            {
              "RightElbow",
              "RightUpperArm",
              "RightLowerArm",
            },
            {
              "RightWrist",
              "RightLowerArm",
              "RightHand",
            },
            {
              "LeftHip",
              "LowerTorso",
              "LeftUpperLeg",
            },
            {
              "LeftKnee",
              "LeftUpperLeg",
              "LeftLowerLeg",
            },
            {
              "LeftAnkle",
              "LeftLowerLeg",
              "LeftFoot",
            },
            {
              "RightHip",
              "LowerTorso",
              "RightUpperLeg",
            },
            {
              "RightKnee",
              "RightUpperLeg",
              "RightLowerLeg",
            },
            {
              "RightAnkle",
              "RightLowerLeg",
              "RightFoot",
            },
          }) do
            local instance = character:FindFirstChild(item[2])
            local parent = character:FindFirstChild(item[3])
            if instance and parent then
              local isEnabled = false
              for _, child in ipairs(parent:GetChildren()) do
                if child:IsA("Motor6D") and child.Name == item[1] then
                  isEnabled = true
                  break
                end
              end
              if not isEnabled then
                local rootPart = instance:FindFirstChild(item[1] .. "RigAttachment")
                local rootPart2 = parent:FindFirstChild(item[1] .. "RigAttachment")
                if rootPart and rootPart2 then
                  for _, child in ipairs(parent:GetChildren()) do
                    if child:IsA("AnimationConstraint") and child.Name == item[1] then
                      pcall(function()
                        child.Enabled = false
                      end)
                    end
                  end
                  pcall(function()
                    local motor6D = Instance.new("Motor6D")
                    local part0 = instance
                    local part1 = parent
                    local cFrame = rootPart.CFrame
                    local cFrame2 = rootPart2.CFrame
                    motor6D.Name = item[1]
                    motor6D.Part0 = part0
                    motor6D.Part1 = part1
                    motor6D.C0 = cFrame
                    motor6D.C1 = cFrame2
                    motor6D.Parent = parent
                  end)
                end
              end
            end
          end
        end
        _G._xenFixRig = function()
          if isEnabled2 then
            return false
          end
          isEnabled2 = true
          local success = pcall(createUiElement)
          isEnabled2 = false
          return success
        end
        local function checkCondition()
          if not instance then
            return
          end
          local state = findTarget()
          local function cleanup(instance)
            for _, child in ipairs(instance:GetChildren()) do
              if
                child:IsA("BallSocketConstraint")
                or child:IsA("NoCollisionConstraint")
                or child:IsA("HingeConstraint")
                or child:IsA("Attachment") and (child.Name == "A" or child.Name == "B")
              then
                child:Destroy()
              elseif child:IsA("BodyVelocity") or child:IsA("BodyPosition") or child:IsA("BodyGyro") then
                if not state then
                  child:Destroy()
                end
              elseif child:IsA("Motor6D") then
                child.Enabled = true
              elseif child:IsA("BasePart") then
                for _, child2 in ipairs(child:GetChildren()) do
                  if
                    child2:IsA("BallSocketConstraint")
                    or child2:IsA("NoCollisionConstraint")
                    or child2:IsA("HingeConstraint")
                    or child2:IsA("Motor6D")
                  then
                    if child2:IsA("Motor6D") then
                      child2.Enabled = true
                    else
                      child2:Destroy()
                    end
                  elseif child2:IsA("Attachment") and (child2.Name == "A" or child2.Name == "B") then
                    child2:Destroy()
                  end
                end
              end
            end
          end
          pcall(function()
            cleanup(instance)
          end)
          if animator then
            for _, item in pairs(animator:GetPlayingAnimationTracks()) do
              local isConditionMet = item.Animation and item.Animation.Name:lower() or ""
              if
                isConditionMet:find("rag")
                or isConditionMet:find("fall")
                or isConditionMet:find("hurt")
                or isConditionMet:find("down")
              then
                item:Stop(0)
              end
            end
          end
        end
        local function handleState(data)
          instance = data
          humanoid = data:WaitForChild("Humanoid", 10)
          rootPart = data:WaitForChild("HumanoidRootPart", 10)
          animator = humanoid:WaitForChild("Animator", 10)
          vector = Vector3.new(0, 0, 0)
        end
        local function cleanup()
          for _, item in pairs(items) do
            pcall(function()
              item:Disconnect()
            end)
          end
          items = {}
        end
        local function findTarget2()
          cleanup()
          table.insert(
            items,
            humanoid.StateChanged:Connect(function()
              if antiKnockbackEnabled and getValue() then
                if not findTarget() then
                  humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
                checkCondition()
                workspace.CurrentCamera.CameraSubject = humanoid
                enableFeature()
              end
            end)
          )
          table.insert(
            items,
            humanoid.StateChanged:Connect(function(old, new)
              if isEnabled2 then
                return
              end
              if
                new == Enum.HumanoidStateType.Running
                or new == Enum.HumanoidStateType.GettingUp
                or new == Enum.HumanoidStateType.Landed
              then
                isEnabled2 = true
                task.defer(function()
                  pcall(createUiElement)
                  isEnabled2 = false
                end)
              end
            end)
          )
          pcall(function()
            local packages = instance25:FindFirstChild("Packages")
            if packages then
              local net = packages:FindFirstChild("Net")
              if net then
                local reCombatServiceApplyImpulse = net:FindFirstChild("RE/CombatService/ApplyImpulse")
                if reCombatServiceApplyImpulse then
                  table.insert(
                    items,
                    reCombatServiceApplyImpulse.OnClientEvent:Connect(function()
                      if antiKnockbackEnabled and getValue() then
                        rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                      end
                    end)
                  )
                end
              end
            end
          end)
          table.insert(
            items,
            instance.DescendantAdded:Connect(function()
              if antiKnockbackEnabled and getValue() then
                checkCondition()
              end
            end)
          )
          table.insert(
            items,
            RunService.Heartbeat:Connect(function()
              if antiKnockbackEnabled and (getValue()) then
                checkCondition()
                local w = rootPart.AssemblyLinearVelocity
                if (w - vector).Magnitude > 40 and w.Magnitude > 25 then
                  rootPart.AssemblyLinearVelocity = w.Unit * math.min(w.Magnitude, 15)
                end
                vector = w
              end
            end)
          )
          enableFeature()
          checkCondition()
        end
        local function handleState2()
          antiKnockbackEnabled = true
          _G.antiKnockbackEnabled = true
          if localPlayer.Character then
            handleState(localPlayer.Character)
            findTarget2()
          end
        end
        local function handleState3()
          antiKnockbackEnabled = false
          _G.antiKnockbackEnabled = false
          cleanup()
        end
        _G.enableAntiKnockback = function()
          handleState2()
          isEnabled = false
          saveData()
        end
        _G.disableAntiKnockback = function()
          handleState3()
          isEnabled = true
          saveData()
        end
        if localPlayer.Character then
          handleState(localPlayer.Character)
          if antiKnockbackEnabled then
            findTarget2()
          end
        end
        localPlayer.CharacterAdded:Connect(function(character)
          cleanup()
          instance = nil
          humanoid = nil
          rootPart = nil
          animator = nil
          local humanoid2 = character:WaitForChild("Humanoid", 10)
          local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 10)
          if not humanoid2 or not humanoidRootPart then
            return
          end
          task.wait(0.2)
          handleState(character)
          if antiKnockbackEnabled or _G.antiKnockbackEnabled then
            antiKnockbackEnabled = true
            _G.antiKnockbackEnabled = true
            findTarget2()
          end
        end)
      end)
      _G.DisableAPOnKawaifu = true
      _G.DisableAPOnFMLY = _G.DisableAPOnFMLY ~= false
      _G.DisableAPOnWNotifier = _G.DisableAPOnWNotifier ~= false
      _G.DisableAPOnBraintopia = _G.DisableAPOnBraintopia ~= false
      do
        local function findTarget()
          local btEspCache = _G._btEspCache
          if btEspCache and btEspCache.Parent then
            return btEspCache
          end
          _G._btEspCache = nil
          local items = {}
          if type(gethui) == "function" then
            local success, callResult = pcall(gethui)
            if success and callResult then
              items[#items + 1] = callResult
            end
          end
          items[#items + 1] = game:GetService("CoreGui")
          local localPlayer2 = game:GetService("Players").LocalPlayer
          if localPlayer2 then
            local playerGui2 = localPlayer2:FindFirstChildOfClass("PlayerGui")
            if playerGui2 then
              items[#items + 1] = playerGui2
            end
          end
          for _, item in ipairs(items) do
            local btEsp = item:FindFirstChild("BtEsp")
            if btEsp then
              _G._btEspCache = btEsp
              return btEsp
            end
          end
          return nil
        end
        _G._isBraintopiaUser = function(player)
          if not player or not player.Character then
            return false
          end
          local instance = findTarget()
          if not instance then
            return false
          end
          local character = player.Character
          for _, child in ipairs(instance:GetChildren()) do
            if child:IsA("Highlight") or child:IsA("BillboardGui") then
              local adornee = child.Adornee
              if adornee then
                adornee = adornee == character or adornee:IsDescendantOf(character)
              end
              if adornee then
                return true
              end
            end
          end
          return false
        end
      end
    end
    _G.getFmlyTag = function()
      return nil
    end
    do
      local function findTarget()
        local items = {
          "w user",
          "wuser",
          "w hub",
          "notifier",
          "wblox",
          "w /",
        }
        local items2 = {}
        local items3 = {}
        local localPlayer2 = game:GetService("Players").LocalPlayer
        localPlayer2 = localPlayer2 and localPlayer2:FindFirstChildOfClass("PlayerGui")
        local CoreGui = nil
        pcall(function()
          CoreGui = game:GetService("CoreGui")
        end)
        for _, item in ipairs({
          localPlayer2,
          CoreGui,
        }) do
          if item then
            pcall(function()
              item.DescendantAdded:Connect(function(descendant)
                if descendant:IsA("BillboardGui") then
                  items2[descendant] = true
                end
              end)
            end)
          end
        end
        task.spawn(function()
          for _, item in ipairs({
            localPlayer2,
            CoreGui,
          }) do
            if item then
              local success, callResult = pcall(function()
                return item:GetDescendants()
              end)
              if success and callResult then
                for i, item in ipairs(callResult) do
                  if item:IsA("BillboardGui") then
                    items2[item] = true
                  end
                  if i % 500 == 0 then
                    task.wait()
                  end
                end
              end
            end
          end
        end)
        local function getValue39(instance2)
          if not instance2 or not instance2.Name then
            return true
          end
          local name = instance2.Name
          if name == "ESPCard" then
            return true
          end
          local xenN = _G._xenN
          if xenN then
            for _, item in pairs(xenN) do
              if name == item then
                return true
              end
            end
          end
          return false
        end
        return function(player)
          if not player then
            return false
          end
          local userId = player.UserId
          local entry = items3[userId]
          if entry and entry.hit then
            return true
          end
          if not player.Character then
            return false
          end
          local isActive
          if entry then
            local t = entry.t
            isActive = os.clock() - t < 3
          else
            isActive = entry
          end
          if isActive then
            return false
          end
          if not entry then
            entry = {}
            items3[userId] = entry
          end
          entry.t = os.clock()
          local character = player.Character
          local name = player.Name
          local displayName = player.DisplayName
          local function getValue40(data)
            if type(data) ~= "string" then
              return false
            end
            local state = data:gsub("^%s+", ""):gsub("%s+$", "")
            if state == "" or #state > 64 or state == name or state == displayName then
              return false
            end
            local lowercaseText = state:lower()
            for _, item in ipairs(items) do
              if lowercaseText:find(item, 1, true) then
                return true
              end
            end
            return false
          end
          local function checkCondition(instance)
            if not instance:IsA("BillboardGui") or not instance.Enabled then
              return false
            end
            if getValue39(instance) then
              return false
            end
            for _, descendant in ipairs(instance:GetDescendants()) do
              if (descendant:IsA("TextLabel") or descendant:IsA("TextBox")) and descendant.Visible ~= false then
                if getValue40(descendant.Text) then
                  return true
                end
              end
            end
            return false
          end
          for _, descendant in ipairs(character:GetDescendants()) do
            if descendant:IsA("BillboardGui") and checkCondition(descendant) then
              entry.hit = true
              return true
            end
          end
          for k in pairs(items2) do
            if k.Parent then
              local adornee = k.Adornee
              if adornee and adornee:IsDescendantOf(character) and checkCondition(k) then
                entry.hit = true
                return true
              end
              continue
            end
            items2[k] = nil
          end
          pcall(function()
            for k, item in pairs(player:GetAttributes()) do
              if typeof(item) == "string" and #item > 0 and #item <= 40 then
                local lowercaseText = k:lower()
                if
                  lowercaseText:find("hub")
                  or lowercaseText:find("script")
                  or lowercaseText:find("joiner")
                  or lowercaseText:find("executor")
                  or lowercaseText:find("tag")
                then
                  if getValue40(item) then
                    entry.hit = true
                  end
                end
              end
            end
          end)
          return entry.hit == true
        end
      end
      _G._isWNotifierUser = findTarget()
    end
    _G._isFMLYUser = function(player)
      if not player then
        return false
      end
      if _G.getFmlyTag then
        if _G.getFmlyTag(player) == "FMLY_GOOD" then
          return true
        end
      end
      if not player.Character then
        return false
      end
      for _, child in ipairs(player.Character:GetChildren()) do
        if child:IsA("BillboardGui") and child.Name:sub(1, 15) == "FMLYDetectorESP" then
          for _, descendant in ipairs(child:GetDescendants()) do
            if descendant:IsA("TextLabel") then
              local textColor3 = descendant.TextColor3
              local isActive = descendant.Text == "GOOD BOY"
              local isActive2
              if isActive then
                isActive2 = isActive
              else
                local isActive = math.abs(textColor3.R * 255 - 255) < 6
                if isActive then
                  isActive = math.abs(textColor3.G * 255 - 255) < 6
                end
                if isActive then
                  isActive2 = math.abs(textColor3.B * 255 - 0) < 6
                else
                  isActive2 = isActive
                end
              end
              if isActive2 then
                return true
              end
            end
          end
        end
      end
      return false
    end
    _G.DisableAPOnSON = false
    _G._xenSONSafe = {}
    _G._isSONUser = function()
      return false
    end
    task.spawn(function()
      while true do
        task.wait(0.25)
        local character = localPlayer.Character
        if character then
          local humanoid = character:FindFirstChildOfClass("Humanoid")
          if not humanoid then
            continue
          end
          if humanoid.BreakJointsOnDeath then
            humanoid.BreakJointsOnDeath = false
          end
          pcall(function()
            humanoid:SetStateEnabled(enumValues.deadHumanoidState, false)
          end)
          if not (humanoid.Health < humanoid.MaxHealth) then
            continue
          end
          pcall(function()
            humanoid.Health = humanoid.MaxHealth
          end)
        end
      end
    end)
    localPlayer.CharacterAdded:Connect(function()
      _G._joinAutoTPDone = false
    end)
    HttpService = enumValues.HttpService
    ContentProviderService = game:GetService("ContentProvider")
    StarterGuiService = game:GetService("StarterGui")
    TweenService = enumValues.TweenService
    LightingService = enumValues.Lighting
    TextService = enumValues.TextService
    sharedPriorityItems = _G.SHARED_PRIORITY_ITEMS
    isAutoPurchaseAllowed = function(player, payload)
      if
        player
        and player ~= localPlayer
        and ({
          galacticq7 = true,
          velvetpal = true,
          zooshuriken04204 = true,
          skullpulse48866 = true,
          tttttxen = true,
          zezzzssoosa1 = true,
          nocticbase27 = true,
          kormochan = true,
          fffhhhllll753951 = true,
          cxydens = true,
        })[player.Name:lower()]
      then
        return false
      end
      if _G.DisableAPOnKawaifu and player and player.Character then
        if player.Character:FindFirstChild("KaWaifu_NeonHighlight") then
          pcall(function()
            local xenPlayerContainer = _G._xenPlayerContainer
            if xenPlayerContainer then
              local instance = xenPlayerContainer:FindFirstChild("PlayerEntry_" .. player.UserId)
              if instance then
                for _, descendant in ipairs(instance:GetDescendants()) do
                  if
                    descendant:IsA("TextLabel")
                    and descendant.Font == enumValues.gothamBoldFont
                    and not descendant.Text:find("^@")
                    and descendant.Name ~= "StealingLabel"
                    and descendant.Name ~= "ReadyLabel"
                    and descendant.Name ~= "BaseOwnerLabel"
                    and descendant.Name ~= "HasAPLabel"
                    and not descendant.Text:find("%[KWFU%]")
                  then
                    descendant.RichText = true
                    descendant.Text = descendant.Text .. '  <font color="rgb(255,105,180)">[KWFU]</font>'
                    break
                  end
                end
              end
            end
          end)
          return false
        end
      end
      if _G.DisableAPOnBraintopia and player and player ~= localPlayer then
        if _G._isBraintopiaUser(player) then
          pcall(function()
            local xenPlayerContainer = _G._xenPlayerContainer
            if xenPlayerContainer then
              local instance = xenPlayerContainer:FindFirstChild("PlayerEntry_" .. player.UserId)
              if instance then
                for _, descendant in ipairs(instance:GetDescendants()) do
                  if
                    descendant:IsA("TextLabel")
                    and descendant.Font == enumValues.gothamBoldFont
                    and not descendant.Text:find("^@")
                    and descendant.Name ~= "StealingLabel"
                    and descendant.Name ~= "ReadyLabel"
                    and descendant.Name ~= "BaseOwnerLabel"
                    and descendant.Name ~= "HasAPLabel"
                    and not descendant.Text:find("%[BT%]")
                  then
                    descendant.RichText = true
                    descendant.Text = descendant.Text .. '  <font color="rgb(170,80,255)">[BT]</font>'
                    break
                  end
                end
              end
            end
          end)
          return false
        end
      end
      if _G.DisableAPOnFMLY and player and player ~= localPlayer then
        if _G._isFMLYUser(player) then
          pcall(function()
            local xenPlayerContainer = _G._xenPlayerContainer
            if xenPlayerContainer then
              local instance = xenPlayerContainer:FindFirstChild("PlayerEntry_" .. player.UserId)
              if instance then
                for _, descendant in ipairs(instance:GetDescendants()) do
                  if
                    descendant:IsA("TextLabel")
                    and descendant.Font == enumValues.gothamBoldFont
                    and not descendant.Text:find("^@")
                    and descendant.Name ~= "StealingLabel"
                    and descendant.Name ~= "ReadyLabel"
                    and descendant.Name ~= "BaseOwnerLabel"
                    and descendant.Name ~= "HasAPLabel"
                    and not descendant.Text:find("%[FMLY%]")
                  then
                    descendant.RichText = true
                    descendant.Text = descendant.Text .. '  <font color="rgb(255,140,0)">[FMLY]</font>'
                    break
                  end
                end
              end
            end
          end)
          return false
        end
      end
      if _G.DisableAPOnSON and player and player ~= localPlayer then
        if _G._isSONUser(player) then
          pcall(function()
            local xenPlayerContainer = _G._xenPlayerContainer
            if xenPlayerContainer then
              local instance = xenPlayerContainer:FindFirstChild("PlayerEntry_" .. player.UserId)
              if instance then
                for _, descendant in ipairs(instance:GetDescendants()) do
                  if
                    descendant:IsA("TextLabel")
                    and descendant.Font == enumValues.gothamBoldFont
                    and not descendant.Text:find("^@")
                    and descendant.Name ~= "StealingLabel"
                    and descendant.Name ~= "ReadyLabel"
                    and descendant.Name ~= "BaseOwnerLabel"
                    and descendant.Name ~= "HasAPLabel"
                    and not descendant.Text:find("%[SON%]")
                  then
                    descendant.RichText = true
                    descendant.Text = descendant.Text .. '  <font color="rgb(30,80,200)">[SON]</font>'
                    break
                  end
                end
              end
            end
          end)
          return false
        end
      end
      if _G.DisableAPOnWNotifier and player and player ~= localPlayer then
        if _G._isWNotifierUser(player) then
          pcall(function()
            local xenPlayerContainer = _G._xenPlayerContainer
            if xenPlayerContainer then
              local instance = xenPlayerContainer:FindFirstChild("PlayerEntry_" .. player.UserId)
              if instance then
                for _, descendant in ipairs(instance:GetDescendants()) do
                  if
                    descendant:IsA("TextLabel")
                    and descendant.Font == enumValues.gothamBoldFont
                    and not descendant.Text:find("^@")
                    and descendant.Name ~= "StealingLabel"
                    and descendant.Name ~= "ReadyLabel"
                    and descendant.Name ~= "BaseOwnerLabel"
                    and descendant.Name ~= "HasAPLabel"
                    and not descendant.Text:find("%[W%]")
                  then
                    descendant.RichText = true
                    descendant.Text = descendant.Text .. '  <font color="rgb(16,185,129)">[W]</font>'
                    break
                  end
                end
              end
            end
          end)
          return false
        end
      end
      if _G.APBlacklistEnabled and _G.APBlacklistNames and player and player ~= localPlayer then
        local lowercaseText = (player.Name or ""):lower()
        for _, apBlacklistName in ipairs(_G.APBlacklistNames) do
          if apBlacklistName == lowercaseText then
            return false
          end
        end
      end
      pcall(function()
        local xenNet = _G.XenNet
        if not xenNet then
          return
        end
        local ap = _G.XenSigs and _G.XenSigs.ap
        if not ap then
          return
        end
        xenNet:RemoteFunction(ap.remote):InvokeServer(ap.token, player, payload)
      end)
      return true
    end
    task.spawn(function()
      task.wait(0.5)
      local animations = instance25:FindFirstChild("Animations")
      if animations then
        local animals = animations:FindFirstChild("Animals")
        if animals then
          local timCheese = animals:FindFirstChild("Tim Cheese")
          if timCheese and timCheese:FindFirstChild("Idle") then
            timCheese.Idle:Destroy()
          end
        end
      end
    end)
    WorkspaceRoot = workspace
    playerGui = localPlayer:FindFirstChild("PlayerGui") or localPlayer:WaitForChild("PlayerGui", 2)
    fileSystemAvailable = pcall(function()
      return writefile and readfile and isfile
    end)
    earlyUISettings = {}
    pcall(function()
      if fileSystemAvailable and isfile and isfile("xendlessKeybinds.json") then
        local decodedData = HttpService:JSONDecode(readfile("xendlessKeybinds.json"))
        setProperties(earlyUISettings, {
          ShowPlayerList = decodedData.ShowPlayerList,
          ShowCommandCooldown = decodedData.ShowCommandCooldown,
          ShowStealPanel = decodedData.ShowStealPanel,
          ShowWalkspeed = decodedData.ShowWalkspeed,
          ShowProximity = decodedData.ShowProximity,
        })
        setProperties(earlyUISettings, {
          PlayerListScale = decodedData.PlayerListScale,
          StealPanelScale = decodedData.StealPanelScale,
          MovementPanelScale = decodedData.MovementPanelScale,
          SelectTargetScale = decodedData.SelectTargetScale,
          RemoteSellScale = decodedData.RemoteSellScale,
          ProximityScale = decodedData.ProximityScale,
          UnlockScale = decodedData.UnlockScale,
          StealProgressScale = decodedData.StealProgressScale,
          CommandCooldownScale = decodedData.CommandCooldownScale,
        })
        local snapshot = earlyUISettings
        local showActions = decodedData.ShowActions
        local actionsScale = decodedData.ActionsScale
        earlyUISettings.ShowActions = showActions
        snapshot.ActionsScale = actionsScale
        _G._earlyUISettings = earlyUISettings
      end
    end)
    pcall(function()
      local json = fileSystemAvailable and isfile and isfile("xendlessKeybinds.json")
      local accessoryRemovalEnabled = true
      if json then
        local decodedData = HttpService:JSONDecode(readfile("xendlessKeybinds.json"))
        if decodedData and decodedData.AccessoryRemovalEnabled ~= nil then
          accessoryRemovalEnabled = decodedData.AccessoryRemovalEnabled
        end
      end
      _G.AccessoryRemovalEnabled = accessoryRemovalEnabled
      local Players = game:GetService("Players")
      local function onDescendantAdded(descendant)
        if not _G.AccessoryRemovalEnabled then
          return
        end
        if descendant:IsA("Accessory") then
          task.defer(function()
            pcall(function()
              descendant:Destroy()
            end)
          end)
        end
      end
      local obj = setmetatable({}, {
        __mode = "k",
      })
      local function xenStripAccessories(character)
        if not _G.AccessoryRemovalEnabled or not character then
          return
        end
        for _, descendant in ipairs(character:GetDescendants()) do
          onDescendantAdded(descendant)
        end
        if not obj[character] then
          obj[character] = true
          character.DescendantAdded:Connect(onDescendantAdded)
        end
      end
      _G._xenStripAccessories = xenStripAccessories
      if accessoryRemovalEnabled then
        local function setupConnections(player)
          if player.Character then
            xenStripAccessories(player.Character)
          end
          player.CharacterAdded:Connect(xenStripAccessories)
        end
        for _, player in ipairs(Players:GetPlayers()) do
          pcall(setupConnections, player)
        end
        Players.PlayerAdded:Connect(function(player)
          pcall(setupConnections, player)
        end)
        for _, descendant in ipairs(WorkspaceRoot:GetDescendants()) do
          if descendant:IsA("Model") and descendant:FindFirstChildOfClass("Humanoid") then
            xenStripAccessories(descendant)
          end
        end
        WorkspaceRoot.DescendantAdded:Connect(function(descendant)
          if not _G.AccessoryRemovalEnabled then
            return
          end
          if descendant:IsA("Accessory") then
            local parent = descendant.Parent
            if parent and parent:FindFirstChildOfClass("Humanoid") then
              onDescendantAdded(descendant)
            end
          elseif descendant:IsA("Model") and descendant:FindFirstChildOfClass("Humanoid") then
            xenStripAccessories(descendant)
          end
        end)
      end
    end)
    _G._xenSetUIScale = function(parent, data)
      if not parent then
        return
      end
      local uiScale = parent:FindFirstChildOfClass("UIScale")
      if not uiScale then
        uiScale = newInstance("UIScale")
        uiScale.Parent = parent
      end
      uiScale.Scale = math.clamp((tonumber(data) or 100) / 100, 0.3, 2)
    end
    do
      local touchEnabled = InputService.TouchEnabled
      if touchEnabled then
        isMobile = not InputService.KeyboardEnabled or not InputService.MouseEnabled
      else
        isMobile = touchEnabled
      end
    end
    task.spawn(function()
      task.wait()
      if not _G.XenHubLoaded then
        return
      end
      if not enumValues.Players.LocalPlayer then
        return
      end
      local function findTarget()
        return enumValues.Players.LocalPlayer.Character
          and enumValues.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      end
      local function getValue(data)
        if not data then
          return 0
        end
        local lowercaseText = string.lower(tostring(data))
        local isConditionMet = tonumber(lowercaseText:match("[%d%.]+")) or 0
        if lowercaseText:find("t") then
          isConditionMet *= 1e12
        elseif lowercaseText:find("b") then
          isConditionMet *= 1e9
        elseif lowercaseText:find("m") then
          isConditionMet *= 1000000
        elseif lowercaseText:find("k") then
          isConditionMet *= 1000
        end
        return isConditionMet
      end
      local function getState()
        local items = {}
        for _, child in ipairs(WorkspaceRoot:GetChildren()) do
          if child:IsA("Model") and child:GetAttribute("Index") ~= nil then
            for _, descendant in ipairs(child:GetDescendants()) do
              pcall(function()
                if descendant:IsA("ProximityPrompt") then
                  local lowercaseText = (descendant.ActionText or ""):lower()
                  if lowercaseText:find("purchase") or lowercaseText:find("buy") or lowercaseText:find("kauf") then
                    local parent = descendant.Parent
                    local worldPosition
                    if parent and parent:IsA("Attachment") then
                      worldPosition = parent.WorldPosition
                    else
                      local isBasePart = parent and parent:IsA("BasePart")
                      worldPosition = nil
                      if isBasePart then
                        worldPosition = parent.Position
                      end
                    end
                    if worldPosition then
                      items[#items + 1] = {
                        prompt = descendant,
                        pos = worldPosition,
                      }
                    end
                  end
                end
              end)
            end
          end
        end
        return items
      end
      local items = {}
      local amount = 0
      local function getValue2()
        local now2 = tick()
        if now2 - amount < 2 and #items > 0 then
          return items
        end
        items = getState()
        amount = now2
        return items
      end
      local function getValue3(data, collection)
        local amount = 20
        local prompt = nil
        for _, item in ipairs(collection) do
          local magnitude = (item.pos - data).Magnitude
          if magnitude < amount then
            prompt = item.prompt
            amount = magnitude
          end
        end
        return prompt
      end
      local function findTarget2()
        local items = {}
        local debris = WorkspaceRoot:FindFirstChild("Debris")
        if not debris then
          return items
        end
        local state = getValue2()
        for _, child in ipairs(debris:GetChildren()) do
          pcall(function()
            if not child:IsA("BasePart") then
              return
            end
            local text = nil
            local genValue = nil
            for _, child2 in ipairs(child:GetChildren()) do
              if child2:IsA("BillboardGui") or child2:IsA("SurfaceGui") then
                for _, descendant in ipairs(child2:GetDescendants()) do
                  if descendant:IsA("TextLabel") then
                    if descendant.Name == "DisplayName" then
                      text = descendant.Text
                    else
                      local isActive = descendant.Name == "Generation"
                      local pos
                      if isActive then
                        pos = (descendant.Text or ""):find("/s")
                      else
                        pos = isActive
                      end
                      if pos then
                        genValue = getValue(descendant.Text)
                      end
                    end
                  end
                end
              end
            end
            if not text or not genValue or genValue <= 0 then
              return
            end
            local prompt = getValue3(child.Position, state)
            if not prompt then
              return
            end
            items[#items + 1] = {
              name = text,
              genValue = genValue,
              part = child,
              position = child.Position,
              prompt = prompt,
            }
          end)
        end
        return items
      end
      local function getValue4()
        local state = -1
        local state2 = nil
        for _, item in ipairs(findTarget2()) do
          if item.genValue > state then
            state = item.genValue
            state2 = item
          end
        end
        return state2
      end
      local state = nil
      local name = nil
      local function getValue5(data)
        if not data or not data.part then
          return
        end
        local name2 = data.name
        local connection = nil
        connection = data.part.AncestryChanged:Connect(function(child, parent)
          if parent then
            return
          end
          if connection then
            connection:Disconnect()
          end
          if not _G.AutoBuyEnabled then
            return
          end
          if name ~= name2 then
            return
          end
          local lowercaseText = name2:lower()
          local isEnabled = false
          local function getValue()
            if isEnabled then
              return
            end
            local xenAnimalsCache = _G._xenAnimalsCache
            if not xenAnimalsCache then
              return
            end
            for _, item in ipairs(xenAnimalsCache) do
              if
                item.owner == enumValues.Players.LocalPlayer.Name
                and item.name
                and item.name:lower() == lowercaseText
              then
                isEnabled = true
                local snapshot = name
                state = nil
                name = nil
                if _G.autoKickEnabled then
                  if _G._xenPSLinkCode then
                    pcall(function()
                      if _G.triggerJoinPS then
                        _G.triggerJoinPS()
                      end
                    end)
                  else
                    _G.KICK_IN_PROGRESS = true
                    enumValues.Players.LocalPlayer:Kick("You have successfully bought " .. (snapshot or "something"))
                    if not isMobile then
                      game:Shutdown()
                    end
                  end
                end
                return
              end
            end
          end
          getValue()
          if isEnabled then
            return
          end
          local connection2 = nil
          local now2 = tick()
          connection2 = enumValues.RunService.Heartbeat:Connect(function()
            if isEnabled then
              if connection2 then
                connection2:Disconnect()
              end
              return
            end
            if tick() - now2 > 5 then
              if connection2 then
                connection2:Disconnect()
              end
              return
            end
            getValue()
          end)
        end)
      end
      local state2 = nil
      local function getValue6()
        return _G.XenSigs and _G.XenSigs.buy
      end
      local function findTarget3()
        if state2 then
          return state2
        end
        local success, callResult = pcall(function()
          local xenNet = _G.XenNet or require(enumValues.ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"))
          local state = getValue6()
          if not state then
            return nil
          end
          return xenNet:RemoteEvent(state.remote)
        end)
        if success and typeof(callResult) == "Instance" then
          state2 = callResult
        end
        return state2
      end
      _G._xenFireBuy = function(instance)
        local remote = findTarget3()
        if not remote or not instance then
          return false
        end
        local attribute = instance:GetAttribute("UID")
        if not attribute then
          local model = instance:FindFirstAncestorWhichIsA("Model")
          attribute = model and model.Name
        end
        if not attribute then
          return false
        end
        local state = getValue6()
        if not state then
          return false
        end
        local offset = state.offset
        local calculatedValue = WorkspaceRoot:GetServerTimeNow() + offset
        pcall(function()
          remote:FireServer(calculatedValue, state.sig1, attribute)
        end)
        pcall(function()
          remote:FireServer(calculatedValue, state.sig2, attribute)
        end)
        return true
      end
      enumValues.RunService.Heartbeat:Connect(function()
        if not _G.AutoBuyEnabled or _G.isTeleporting then
          return
        end
        local abBodyPos = _G._ab_bodyPos
        if not abBodyPos or not abBodyPos.Parent then
          return
        end
        local snapshot = state
        local part = state
        if snapshot then
          part = snapshot.part
        end
        if part and snapshot.part.Parent then
          abBodyPos.Position = snapshot.part.Position + Vector3.new(0, 1, 0)
        end
      end)
      enumValues.RunService.Heartbeat:Connect(function()
        if not _G.AutoBuyEnabled or _G.isTeleporting then
          return
        end
        local snapshot = state
        local prompt = state
        if snapshot then
          prompt = snapshot.prompt
        end
        if prompt and snapshot.prompt.Parent and snapshot.part and snapshot.part.Parent then
          local rootPart = findTarget()
          if rootPart and (rootPart.Position - snapshot.part.Position).Magnitude <= 30 then
            pcall(_G._xenFireBuy, snapshot.prompt)
          end
        end
      end)
      while _G.XenHubLoaded do
        task.wait(0.04)
        if not _G.AutoBuyEnabled then
          if _G._ab_bodyPos then
            pcall(function()
              _G._ab_bodyPos:Destroy()
            end)
            _G._ab_bodyPos = nil
          end
          state = nil
          name = nil
        elseif _G.isTeleporting then
          if _G._ab_bodyPos then
            pcall(function()
              _G._ab_bodyPos:Destroy()
            end)
            _G._ab_bodyPos = nil
          end
        else
          pcall(function()
            local parent = findTarget()
            if not parent then
              return
            end
            if not state or not state.part or not state.part.Parent or not state.prompt or not state.prompt.Parent then
              state = getValue4()
              if state then
                name = state.name
                getValue5(state)
                pcall(function()
                  state.prompt.HoldDuration = 0
                end)
                if _G._ab_enabledConn then
                  pcall(function()
                    _G._ab_enabledConn:Disconnect()
                  end)
                  _G._ab_enabledConn = nil
                end
                local prompt = state.prompt
                _G._ab_enabledConn = prompt:GetPropertyChangedSignal("Enabled"):Connect(function()
                  if prompt and prompt.Parent and _G.AutoBuyEnabled and not _G.isTeleporting then
                    pcall(_G._xenFireBuy, prompt)
                  end
                end)
              end
            end
            local snapshot = state
            if not snapshot or not snapshot.prompt or not snapshot.prompt.Parent then
              if _G._ab_bodyPos then
                pcall(function()
                  _G._ab_bodyPos:Destroy()
                end)
                _G._ab_bodyPos = nil
              end
              return
            end
            if snapshot.part and snapshot.part.Parent then
              snapshot.position = snapshot.part.Position
            end
            if 30 < (parent.Position - snapshot.position).Magnitude then
              if _G._ab_bodyPos then
                pcall(function()
                  _G._ab_bodyPos:Destroy()
                end)
                _G._ab_bodyPos = nil
              end
              return
            end
            local position = snapshot.position + Vector3.new(0, 1, 0)
            if not (_G._ab_bodyPos and _G._ab_bodyPos.Parent == parent) then
              if _G._ab_bodyPos then
                pcall(function()
                  _G._ab_bodyPos:Destroy()
                end)
              end
              _G._ab_bodyPos = newInstance("BodyPosition")
              _G._ab_bodyPos.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
              _G._ab_bodyPos.P = 20000
              _G._ab_bodyPos.D = 1000
              _G._ab_bodyPos.Parent = parent
            end
            _G._ab_bodyPos.Position = position
          end)
        end
      end
    end)
    if InputService.TouchEnabled and not InputService.MouseEnabled then
      isMobile = true
    end
    do
      local snapshot = _G
      local snapshot2 = _G
      local snapshot3 = _G
      local vector = _G
      local snapshot4 = _G
      local snapshot5 = _G
      local vector2 = _G
      local vector3 = _G
      local snapshot6 = _G
      local snapshot7 = _G
      local vector4 = _G
      local snapshot8 = _G
      local snapshot9 = _G
      local vector5 = _G
      local vector6 = _G
      local vector7 = _G
      local vector8 = _G
      local snapshot10 = _G
      local snapshot11 = _G
      local vector9 = _G
      local mobileBtnH = isMobile and 20 or 40
      local mobileTxt = isMobile and 9 or 18
      local cmdFrameW = isMobile and 95 or 195
      local cmdFrameH = isMobile and 160 or 290
      local playerListW = isMobile and 130 or 360
      local playerListH = isMobile and 140 or 389
      local btnFrameW = isMobile and 80 or 160
      local btnFrameH = isMobile and 180 or 360
      local proxW = isMobile and 90 or 180
      local stealW = isMobile and 90 or 220
      local stealH = isMobile and 95 or 237
      local stealYOffset = isMobile and 90 or 374
      local xenhubBarW = isMobile and 295 or 570
      local xenhubBarH = isMobile and 30 or 60
      local xenhubBarY = isMobile and 100 or 135
      local unlockBtnW = isMobile and 30 or 60
      local unlockBtnH = isMobile and 25 or 50
      local unlockBtnY = isMobile and 135 or 200
      snapshot.isMobile = isMobile
      snapshot2.isDraggingUI = false
      snapshot3.MOBILE_BTN_H = mobileBtnH
      vector.MOBILE_TXT = mobileTxt
      snapshot4.CMD_FRAME_W = cmdFrameW
      snapshot5.CMD_FRAME_H = cmdFrameH
      vector2.PLAYER_LIST_W = playerListW
      vector3.PLAYER_LIST_H = playerListH
      snapshot6.BTN_FRAME_W = btnFrameW
      snapshot7.BTN_FRAME_H = btnFrameH
      vector4.PROX_W = proxW
      snapshot8.STEAL_W = stealW
      snapshot9.STEAL_H = stealH
      vector5.STEAL_Y_OFFSET = stealYOffset
      vector6.XENHUB_BAR_W = xenhubBarW
      vector7.XENHUB_BAR_H = xenhubBarH
      vector8.XENHUB_BAR_Y = xenhubBarY
      snapshot10.UNLOCK_BTN_W = unlockBtnW
      snapshot11.UNLOCK_BTN_H = unlockBtnH
      vector9.UNLOCK_BTN_Y = unlockBtnY
    end
    task.spawn(function()
      local parent = _G._xenHUI()
      game.Players.LocalPlayer.PlayerGui.ChildAdded:Connect(function(child)
        local isScreenGui = child:IsA("ScreenGui")
        if isScreenGui then
          isScreenGui = child.Name == "SelectTargetUI"
            or child.Name == "StealProgressGui"
            or child.Name == "PlayerListUI"
            or child.Name == "AutoStealGui"
        end
        if isScreenGui then
          pcall(function()
            child.Parent = parent
          end)
        end
      end)
    end)
    if isMobile then
      do
        local ContextActionService = game:GetService("ContextActionService")
        local function getValue()
          return Enum.ContextActionResult.Sink
        end
        RunService.RenderStepped:Connect(function()
          if _G.isDraggingUI then
            ContextActionService:BindAction(
              "BlockMovement",
              getValue,
              false,
              enumValues.touchInput,
              enumValues.mouseMovementInput,
              enumValues.primaryMouseButton,
              Enum.UserInputType.MouseButton2
            )
          else
            pcall(function()
              ContextActionService:UnbindAction("BlockMovement")
            end)
          end
        end)
      end
    end
    _G.isTeleporting = false
    resetCharacterSafely = function()
      local localPlayer2 = PlayersService.LocalPlayer
      if not localPlayer2 then
        return
      end
      if _G._TpAntiDieLock == true then
        return
      end
      if _G._xenResetBusy then
        return
      end
      local character = localPlayer2.Character
      local humanoid = character and character:FindFirstChildOfClass("Humanoid")
      if not humanoid then
        return
      end
      _G._xenResetBusy = true
      if _G.walkspeedEnabled and _G.toggleWalkspeed then
        pcall(_G.toggleWalkspeed)
      end
      if _G.invisibleStealEnabled and _G.toggleInvisibleSteal then
        pcall(_G.toggleInvisibleSteal)
        pcall(_G.updateMovementPanelInvisVisual, false)
        task.wait(0.15)
      end
      if _G.xenAntiDieOff then
        pcall(_G.xenAntiDieOff)
      end
      pcall(function()
        humanoid.BreakJointsOnDeath = false
      end)
      pcall(function()
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
      end)
      pcall(function()
        humanoid:UnequipTools()
      end)
      local hipHeight = humanoid.HipHeight
      task.spawn(function()
        local isEnabled = false
        local connection = nil
        connection = localPlayer2.CharacterAdded:Connect(function()
          isEnabled = true
          if connection then
            connection:Disconnect()
            connection = nil
          end
        end)
        local amount = 0
        local isEnabled2
        while true do
          local isActive = character
            and character.Parent
            and humanoid
            and humanoid.Health > 0
            and localPlayer2.Character == character
            and amount < 40
          isEnabled2 = false
          if isActive then
            pcall(function()
              humanoid.HipHeight = 1e30
              humanoid.AutoRotate = true
              for _, child in ipairs(character:GetChildren()) do
                if child:IsA("BasePart") then
                  child.CanCollide = false
                end
              end
            end)
            if not character.Parent or humanoid.Health <= 0 or localPlayer2.Character ~= character then
              isEnabled2 = true
              break
            else
              amount += 1
              task.wait(0.05)
              continue
            end
          end
          break
        end
        if not isEnabled2 and character and character.Parent and humanoid then
          pcall(function()
            humanoid.HipHeight = hipHeight
            for _, child in ipairs(character:GetChildren()) do
              if child:IsA("BasePart") then
                child.CanCollide = true
              end
            end
          end)
        end
        local now2 = os.clock()
        while not isEnabled and os.clock() - now2 < 5 do
          task.wait(0.05)
        end
        if connection then
          connection:Disconnect()
          connection = nil
        end
        _G._xenResetBusy = false
        if _G.setupAntiDie then
          pcall(_G.setupAntiDie)
        end
      end)
    end
    task.spawn(function()
      _G.respawn = function(player)
        pcall(function()
          local isEnabled = false
          if gethidden then
            local disabled = Enum.RejectCharacterDeletions.Disabled
            isEnabled = gethidden(WorkspaceRoot, "RejectCharacterDeletions") ~= disabled
          end
          if isEnabled and replicatesignal then
            pcall(function()
              replicatesignal(player.ConnectDiedSignalBackend)
            end)
            task.wait(PlayersService.RespawnTime - 0.1)
            pcall(function()
              replicatesignal(player.Kill)
            end)
          else
            local character = player.Character
            local humanoid = character:FindFirstChildWhichIsA("Humanoid")
            local items = {}
            local backpack = player:FindFirstChild("Backpack")
            for _, child in ipairs(character:GetChildren()) do
              if child:IsA("Tool") then
                table.insert(items, child)
                child.Parent = backpack
              end
            end
            if humanoid then
              humanoid:ChangeState(enumValues.deadHumanoidState)
            end
            character:ClearAllChildren()
            local Model = newInstance("Model")
            Model.Parent = WorkspaceRoot
            player.Character = Model
            task.wait()
            player.Character = character
            Model:Destroy()
          end
        end)
      end
    end)
    task.spawn(function()
      pcall(function()
        local ShakePresets = require(instance25.Shared.ShakePresets)
        if type(ShakePresets) == "table" then
          if ShakePresets.Bump then
            ShakePresets.Bump.Amplitude = 0
          end
          if ShakePresets.BumpS then
            ShakePresets.BumpS.Amplitude = 0
          end
        end
      end)
      pcall(function()
        local function animateInterface()
          pcall(function()
            local currentCamera = WorkspaceRoot.CurrentCamera
            if not currentCamera then
              return
            end
            local fieldOfView = 70
            pcall(function()
              local CameraController = require(instance25.Controllers.CameraController)
              if CameraController and CameraController.GetDefaultFov then
                fieldOfView = CameraController:GetDefaultFov()
              end
            end)
            enumValues.TweenService
              :Create(currentCamera, TweenInfo.new(0), {
                FieldOfView = fieldOfView,
              })
              :Play()
            currentCamera.FieldOfView = fieldOfView
          end)
        end
        local function onChildAdded(child)
          pcall(function()
            local isActive = child:IsA("ColorCorrectionEffect") and child.Name == "DiscoEffect"
            if isActive or child:IsA("BlurEffect") then
              child:Destroy()
              if isActive then
                animateInterface()
              end
            end
          end)
        end
        for _, child in ipairs(enumValues.Lighting:GetChildren()) do
          onChildAdded(child)
        end
        enumValues.Lighting.ChildAdded:Connect(onChildAdded)
      end)
      local net = instance25:FindFirstChild("Packages") and instance25.Packages:FindFirstChild("Net")
      if not (net and getconnections) then
        return
      end
      local getinfo_ = debug.getinfo or getinfo
      local getconstants_ = debug.getconstants or getconstants
      if not getinfo_ then
        return
      end
      local function cleanup()
        pcall(function()
          for _, child in ipairs(net:GetChildren()) do
            if child:IsA("RemoteEvent") then
              local success, callResult = pcall(getconnections, child.OnClientEvent)
              if success and callResult then
                for _, item in ipairs(callResult) do
                  local function_ = item.Function
                  local state = nil
                  local state2 = nil
                  if function_ then
                    state, state2 = pcall(getinfo_, function_)
                  end
                  state = state and state2 and tostring(state2.short_src) or ""
                  local isActive = state:find("BoogieBomb") ~= nil
                    or state:find("CameraShake") ~= nil and not state:find("FakeBrainrot")
                  if not isActive and getconstants_ and function_ then
                    local success, callResult = pcall(getconstants_, function_)
                    if success and type(callResult) == "table" then
                      for _, item in ipairs(callResult) do
                        if item == "Boogie" then
                          isActive = true
                          break
                        end
                      end
                    end
                  end
                  if isActive then
                    pcall(function()
                      if item.Disable then
                        item:Disable()
                      else
                        item:Disconnect()
                      end
                    end)
                  end
                end
              end
            end
          end
        end)
      end
      cleanup()
      pcall(function()
        local itemController = instance25:FindFirstChild("Controllers")
          and instance25.Controllers:FindFirstChild("ItemController")
        if itemController then
          for _, child in ipairs(itemController:GetChildren()) do
            if tostring(child.Name):lower():find("bee") then
              pcall(function()
                child:Destroy()
              end)
            end
          end
          itemController.ChildAdded:Connect(function(child)
            local lowercaseText = tostring(child.Name):lower()
            if lowercaseText:find("boogie") then
              task.defer(cleanup)
            elseif lowercaseText:find("bee") then
              pcall(function()
                child:Destroy()
              end)
            end
          end)
        end
      end)
    end)
  end
  do
    do
      local position, isEnabledLocal82
      do
        local resetPlotBeam
        do
          local plotBeamAttachPlot
          espEnabled = false
          espHighlights = {}
          espBillboards = {}
          _G.trackedESPItems = {}
          trackedESPItems = _G.trackedESPItems
          instantClonerEnabled = false
          selectTargetKey = Enum.KeyCode.C
          baseHubVisible = not isMobile
          uiVisible = true
          transparentPlotsEnabled = false
          position = nil
          isEnabledLocal82 = false
          rainbowBeamEnabled = false
          plotBeam = nil
          plotBeamAttachPlayer = nil
          plotBeamAttachPlot = nil
          do
            local function xenFindMyPlot()
              local plots = WorkspaceRoot:FindFirstChild("Plots")
              if not plots then
                return nil
              end
              if not _G._xenPlotSync then
                pcall(function()
                  _G._xenPlotSync =
                    require(enumValues.ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Synchronizer"))
                end)
              end
              if not _G._xenPlotSync then
                return nil
              end
              for _, child in ipairs(plots:GetChildren()) do
                local isEnabled = false
                pcall(function()
                  local state = _G._xenRawCT(child.Name)
                  if state then
                    local owner = state.Owner
                    if owner then
                      if typeof(owner) == "Instance" and owner:IsA("Player") then
                        isEnabled = owner.UserId == localPlayer.UserId
                      else
                        if type(owner) == "table" and owner.UserId then
                          isEnabled = owner.UserId == localPlayer.UserId
                        elseif typeof(owner) == "Instance" then
                          isEnabled = owner == localPlayer
                        end
                      end
                    end
                  end
                end)
                if isEnabled then
                  return child
                end
              end
              return nil
            end
            _G._xenFindMyPlot = xenFindMyPlot
            createPlotBeam = function()
              if not rainbowBeamEnabled then
                return
              end
              local instance = xenFindMyPlot()
              if not instance or not instance.Parent then
                return
              end
              local character = localPlayer.Character
              if not character or not character.Parent then
                return
              end
              local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
              if not humanoidRootPart or not humanoidRootPart.Parent then
                return
              end
              if plotBeam then
                pcall(function()
                  plotBeam:Destroy()
                end)
              end
              if plotBeamAttachPlayer then
                pcall(function()
                  plotBeamAttachPlayer:Destroy()
                end)
              end
              plotBeamAttachPlayer = humanoidRootPart:FindFirstChild("PlotBeamAttach_Player")
                or newInstance("Attachment")
              setProperties(plotBeamAttachPlayer, {
                Name = "PlotBeamAttach_Player",
                Position = Vector3.new(0, 0, 0),
                Parent = humanoidRootPart,
              })
              local mainRootPart = instance:FindFirstChild("MainRootPart")
                or instance:FindFirstChildWhichIsA("BasePart")
              if not mainRootPart or not mainRootPart.Parent then
                return
              end
              plotBeamAttachPlot = mainRootPart:FindFirstChild("PlotBeamAttach_Plot") or newInstance("Attachment")
              setProperties(plotBeamAttachPlot, {
                Name = "PlotBeamAttach_Plot",
                Position = Vector3.new(0, 5, 0),
                Parent = mainRootPart,
              })
              plotBeam = humanoidRootPart:FindFirstChild("PlotBeam") or newInstance("Beam")
              setProperties(plotBeam, {
                Name = "PlotBeam",
                Attachment0 = plotBeamAttachPlayer,
                Attachment1 = plotBeamAttachPlot,
                FaceCamera = true,
                LightEmission = 2,
                Transparency = NumberSequence.new(0),
                Width0 = 0.7,
                Width1 = 0.7,
                TextureMode = Enum.TextureMode.Wrap,
                TextureSpeed = 0,
                Parent = humanoidRootPart,
              })
            end
          end
          resetPlotBeam = function()
            if plotBeam then
              pcall(function()
                plotBeam:Destroy()
              end)
            end
            if plotBeamAttachPlayer then
              pcall(function()
                plotBeamAttachPlayer:Destroy()
              end)
            end
            if plotBeamAttachPlot then
              pcall(function()
                plotBeamAttachPlot:Destroy()
              end)
            end
            plotBeam = nil
            plotBeamAttachPlayer = nil
            plotBeamAttachPlot = nil
          end
        end
        local snapshot = _G
        _G.createPlotBeam = createPlotBeam
        snapshot.resetPlotBeam = resetPlotBeam
      end
      task.spawn(function()
        local amount = 0
        local amount2 = 0
        local amount3 = 0
        RunService.Heartbeat:Connect(function(w)
          if not rainbowBeamEnabled then
            return
          end
          amount += w
          amount2 += 1
          amount3 += 1
          if amount2 >= 30 then
            amount2 = 0
            if not plotBeam or not plotBeam.Parent or not plotBeamAttachPlayer or not plotBeamAttachPlayer.Parent then
              pcall(function()
                createPlotBeam()
              end)
            end
          end
          if amount3 >= 2 then
            amount3 = 0
            local w = Color3.fromHSV(amount * 0.2 % 1, 1, 1)
            if plotBeam and plotBeam.Parent then
              pcall(function()
                plotBeam.Color = ColorSequence.new(w)
              end)
            end
          end
        end)
      end)
      do
        local function handleState(data)
          if not isEnabledLocal82 then
            local humanoidRootPart = data:WaitForChild("HumanoidRootPart", 10)
            if humanoidRootPart then
              task.wait(0.05)
              position = humanoidRootPart.Position
              isEnabledLocal82 = true
            end
          end
          task.wait(0.05)
          createPlotBeam()
        end
        if localPlayer.Character then
          task.spawn(function()
            handleState(localPlayer.Character)
          end)
        end
        localPlayer.CharacterAdded:Connect(function(character)
          handleState(character)
        end)
      end
    end
    local getValue
    localPlayer.CharacterAdded:Connect(function()
      task.wait(0.05)
      createPlotBeam()
    end)
    do
      local function onChildAdded(child)
        if typeof(child) ~= "Instance" or not child:IsA("Tool") or child.Name ~= "Grapple Hook" then
          return
        end
        if child:FindFirstChild("Handle") then
          return
        end
        setProperties(newInstance("Part"), {
          Name = "Handle",
          Size = Vector3.new(1, 1, 1),
          Transparency = 1,
          CanCollide = false,
          CanQuery = false,
          CanTouch = false,
          Massless = true,
          Parent = child,
        })
      end
      getValue = function(instance)
        if not instance then
          return
        end
        for _, child in ipairs(instance:GetChildren()) do
          onChildAdded(child)
        end
        instance.ChildAdded:Connect(onChildAdded)
      end
    end
    do
      local function handleState()
        getValue(localPlayer:FindFirstChild("Backpack"))
        getValue(localPlayer.Character)
      end
      handleState()
      localPlayer.CharacterAdded:Connect(function()
        task.wait()
        handleState()
      end)
    end
  end
  do
    local state, state2, state3, state4, refreshPlotInfo, findClosestPlotCached, scanDebrisCore
    plotsFolder = WorkspaceRoot:FindFirstChild("Plots")
    if not plotsFolder then
      task.spawn(function()
        plotsFolder = WorkspaceRoot:WaitForChild("Plots", 10)
      end)
    end
    state = {}
    state2 = 0
    state3 = {}
    state4 = 0
    refreshPlotInfo = function()
      local now2 = tick()
      if now2 - state4 < 1 and next(state3) then
        return state3
      end
      local items = {}
      local plots_2 = plotsFolder or WorkspaceRoot:FindFirstChild("Plots")
      if not plots_2 then
        state3 = items
        state4 = now2
        return items
      end
      for _, child in ipairs(plots_2:GetChildren()) do
        local plotSign = child:FindFirstChild("PlotSign")
        if plotSign then
          local position = nil
          pcall(function()
            position = child:GetPivot().Position
          end)
          if not position then
          else
            local surfaceGui = plotSign:FindFirstChildWhichIsA("SurfaceGui", true)
            local isEnabled = false
            local isEnabled2 = false
            if surfaceGui then
              local textLabel = surfaceGui:FindFirstChildWhichIsA("TextLabel", true)
              if textLabel and textLabel.Text then
                local lowercaseText = textLabel.Text:lower()
                local name = localPlayer.Name
                local pos
                if name then
                  pos = lowercaseText:find(localPlayer.Name:lower(), 1, true)
                else
                  pos = name
                end
                pos = pos or localPlayer.DisplayName and lowercaseText:find(localPlayer.DisplayName:lower(), 1, true)
                if pos then
                  isEnabled2 = true
                end
                for _, player in ipairs(PlayersService:GetPlayers()) do
                  if
                    lowercaseText:find(player.Name:lower(), 1, true)
                    or lowercaseText:find(player.DisplayName:lower(), 1, true)
                  then
                    isEnabled = true
                    break
                  end
                end
              end
            end
            items[child] = {
              position = position,
              plotSign = plotSign,
              ownerInGame = isEnabled,
              isMyPlot = isEnabled2,
            }
          end
        end
      end
      state3 = items
      state4 = now2
      return items
    end
    findClosestPlotCached = function(vector, collection)
      local huge = math.huge
      local state = nil
      for k, item in pairs(collection) do
        local calculatedValue = vector.X - item.position.X
        local calculatedValue2 = vector.Z - item.position.Z
        local calculatedValue3 = calculatedValue * calculatedValue + calculatedValue2 * calculatedValue2
        if calculatedValue3 < huge then
          huge = calculatedValue3
          state = k
        end
      end
      return state, huge
    end
    scanDebrisCore = function(data)
      local now2 = tick()
      if not data and now2 - state2 < 0.25 and #state > 0 then
        local entry = state[1]
        if entry and entry.part and entry.part.Parent then
          return state
        end
        state = {}
      end
      local items = {}
      local xenAnimalsCache = _G._xenAnimalsCache
      local plots_2 = WorkspaceRoot:FindFirstChild("Plots")
      local name = nil
      pcall(function()
        name = enumValues.Players.LocalPlayer.Name
      end)
      if xenAnimalsCache and plots_2 then
        for _, item in ipairs(xenAnimalsCache) do
          local closestPlot = plots_2:FindFirstChild(item.plot)
          if closestPlot then
            local animalPodiums = closestPlot:FindFirstChild("AnimalPodiums")
            animalPodiums = animalPodiums and animalPodiums:FindFirstChild(item.slot)
            local base = animalPodiums and animalPodiums:FindFirstChild("Base")
            base = base and base:FindFirstChild("Spawn")
            if base then
              local isEnabled = false
              for _, descendant in ipairs(animalPodiums:GetDescendants()) do
                if descendant:IsA("ProximityPrompt") then
                  isEnabled = true
                  break
                end
              end
              local position = base.Position
              table.insert(items, {
                part = base,
                name = item.name,
                value = item.genValue,
                position = position,
                rawPosition = position,
                mutation = item.mutation,
                traits = item.traits,
                closestPlot = closestPlot,
                isMyPlot = item.owner == name,
                ownerInGame = true,
                plotDist = 0,
                plotSign = closestPlot:FindFirstChild("PlotSign"),
                hasDirectPrompt = isEnabled,
                hasLabels = true,
                isCarpetItem = false,
                slot = item.slot,
                owner = item.owner,
              })
            end
          end
        end
      end
      state = items
      state2 = now2
      return items
    end
    do
      local snapshot = _G
      local snapshot2 = _G
      _G.ScanDebrisCore = scanDebrisCore
      snapshot.RefreshPlotInfo = refreshPlotInfo
      snapshot2.FindClosestPlotCached = findClosestPlotCached
    end
    _G.InvalidateDestrisCoreCache = function()
      state2 = 0
      state = {}
      state4 = 0
      state3 = {}
    end
  end
  do
    local state = nil
    local amount = 0
    _G._xenMyBaseOwnerName = function()
      local now2 = tick()
      if now2 - amount < 0.5 then
        return state
      end
      amount = now2
      local match = nil
      pcall(function()
        local character = localPlayer.Character
        character = character and character:FindFirstChild("HumanoidRootPart")
        local plots_2 = WorkspaceRoot:FindFirstChild("Plots") or WorkspaceRoot:FindFirstChild("plots")
        if not character or not plots_2 then
          return
        end
        local huge = math.huge
        local instance = nil
        for _, child in pairs(plots_2:GetChildren()) do
          local position = nil
          pcall(function()
            position = child:GetPivot().Position
          end)
          if not position then
            local plotSign = child:FindFirstChild("PlotSign")
              or child:FindFirstChild("Base")
              or child:FindFirstChild("Floor")
            if plotSign and plotSign:IsA("BasePart") then
              position = plotSign.Position
            end
          end
          if position then
            local magnitude = (character.Position - position).Magnitude
            if magnitude < huge then
              instance = child
              huge = magnitude
            end
          end
        end
        if not instance then
          return
        end
        local plotSign = instance:FindFirstChild("PlotSign")
        if plotSign then
          local surfaceGui = plotSign:FindFirstChildWhichIsA("SurfaceGui", true)
          if surfaceGui then
            local textLabel = surfaceGui:FindFirstChildWhichIsA("TextLabel", true)
            if textLabel and textLabel.Text then
              match = textLabel.Text:match("([^']+)'s") or textLabel.Text
              match = match:gsub("^%s+", ""):gsub("%s+$", "")
            end
          end
        end
      end)
      state = match
      return match
    end
  end
  do
    local state, state2, state3
    do
      local request_ = syn and syn.request or http_request or request
      state = {}
      state2 = {}
      state3 = {}
      local function handleState(data, data2)
        state[data] = data2
        local entry = state3[data]
        state3[data] = nil
        if entry then
          for _, item in ipairs(entry) do
            pcall(item, data2)
          end
        end
      end
      local getValue = nil
      getValue = function(data, data2)
        if state2[data] or state[data] ~= nil or not request_ then
          return
        end
        state2[data] = true
        task.spawn(function()
          local success, callResult = pcall(request_, {
            Url = "https://inventory.roblox.com/v1/users/" .. data .. "/items/GamePass/1227013099/is-owned",
            Method = "GET",
          })
          state2[data] = nil
          if success and type(callResult) == "table" and callResult.StatusCode == 200 then
            local lowercaseText = tostring(callResult.Body):gsub("%s+", ""):lower()
            if lowercaseText == "true" then
              handleState(data, true)
              return
            end
            if lowercaseText == "false" then
              handleState(data, false)
              return
            end
          end
          if data2 < 3 then
            task.delay(15, function()
              getValue(data, data2 + 1)
            end)
          end
        end)
      end
      _G._xenHasAP = function(player, data)
        if not player then
          if data then
            pcall(data, false)
          end
          return false
        end
        local userId = player.UserId
        local entry = state[userId]
        if entry ~= nil then
          if data then
            pcall(data, entry)
          end
          return entry
        end
        if player:GetAttribute("AdminCommands") == true then
          handleState(userId, true)
          if data then
            pcall(data, true)
          end
          return true
        end
        if data then
          local entry = state3[userId]
          if not entry then
            entry = {}
            state3[userId] = entry
          end
          entry[#entry + 1] = data
        end
        getValue(userId, 0)
        return false
      end
    end
    _G._xenHeldTool = function(player)
      player = player and player.Character
      if not player then
        return nil
      end
      for _, child in ipairs(player:GetChildren()) do
        if child:IsA("Tool") then
          return child.Name, child.TextureId
        end
      end
      return nil
    end
    do
      local items = {}
      local state = nil
      local amount = 0
      _G._xenOnBaseOwnerChanged = function(data)
        items[#items + 1] = data
        pcall(data)
      end
      enumValues.RunService.Heartbeat:Connect(function(deltaTime)
        amount += deltaTime
        if amount < 0.4 then
          return
        end
        amount = 0
        if #items == 0 then
          return
        end
        local xenMyBaseOwnerName = _G._xenMyBaseOwnerName and _G._xenMyBaseOwnerName() or nil
        if xenMyBaseOwnerName == state then
          return
        end
        state = xenMyBaseOwnerName
        for i = #items, 1, -1 do
          local success, callResult = pcall(items[i])
          if not success or callResult == false then
            table.remove(items, i)
          end
        end
      end)
    end
    PlayersService.PlayerRemoving:Connect(function(player)
      local userId = player.UserId
      local snapshot = state2
      local snapshot2 = state3
      state[userId] = nil
      snapshot[userId] = nil
      snapshot2[userId] = nil
    end)
  end
  local obj, collection10, transparencyUpdateId, getValue41, findTarget13
  do
    local collection11, getValue45
    obj = setmetatable({}, {
      __mode = "k",
    })
    collection10 = {}
    transparencyUpdateId = 0
    collection11 = {
      "Base",
      "PlotSign",
      "FriendPanel",
      "Cash",
      "Decorations",
      "Skin",
      "Unlock",
      "Purchases",
    }
    getValue41 = function()
      return math.clamp(tonumber(0.75) or 0.55, 0, 1)
    end
    do
      local function checkCondition(instance, data, data2)
        if not instance then
          return
        end
        if data2 and data2 ~= transparencyUpdateId then
          return
        end
        local function checkCondition(instance)
          local laser = _G.__laser
          if laser and laser.IsLaserObject and laser.IsLaserObject(instance) then
            local getPlotFromObject = laser.GetPlotFromObject and laser.GetPlotFromObject(instance)
            if getPlotFromObject and laser.IsPlotBaseOpen and laser.IsPlotBaseOpen(getPlotFromObject) then
              if laser.SaveLaserOriginal then
                laser.SaveLaserOriginal(instance)
              end
              if laser.HideLaserObject then
                laser.HideLaserObject(instance)
              end
            end
            return
          end
          if instance:IsA("BasePart") then
            if obj[instance] == nil then
              if instance.Transparency == data then
                obj[instance] = 0
              else
                obj[instance] = instance.Transparency
              end
            end
            local entry = obj[instance]
            if entry < 1 then
              local transparency = entry + (1 - entry) * data
              if math.abs(instance.Transparency - transparency) > 0.01 then
                instance.Transparency = transparency
              end
            end
          elseif instance:IsA("TextLabel") or instance:IsA("TextButton") then
            if obj[instance] == nil then
              local textTransparency = instance.TextTransparency
              local backgroundTransparency = instance.BackgroundTransparency
              if textTransparency == data then
                textTransparency = 0
              end
              if backgroundTransparency == data then
                backgroundTransparency = 0
              end
              obj[instance] = {
                text = textTransparency,
                bg = backgroundTransparency,
              }
            end
            local entry = obj[instance]
            if entry.bg < 1 then
              local backgroundTransparency = entry.bg + (1 - entry.bg) * data
              if math.abs(instance.BackgroundTransparency - backgroundTransparency) > 0.01 then
                instance.BackgroundTransparency = backgroundTransparency
              end
            end
          elseif instance:IsA("Frame") or instance:IsA("ScrollingFrame") then
            if obj[instance] == nil then
              if instance.BackgroundTransparency == data then
                obj[instance] = 0
              else
                obj[instance] = instance.BackgroundTransparency
              end
            end
            local entry = obj[instance]
            if entry < 1 then
              local backgroundTransparency = entry + (1 - entry) * data
              if math.abs(instance.BackgroundTransparency - backgroundTransparency) > 0.01 then
                instance.BackgroundTransparency = backgroundTransparency
              end
            end
          elseif instance:IsA("ImageLabel") or instance:IsA("ImageButton") then
            if obj[instance] == nil then
              local imageTransparency = instance.ImageTransparency
              local backgroundTransparency = instance.BackgroundTransparency
              if imageTransparency == data then
                imageTransparency = 0
              end
              if backgroundTransparency == data then
                backgroundTransparency = 0
              end
              obj[instance] = {
                img = imageTransparency,
                bg = backgroundTransparency,
              }
            end
            local entry = obj[instance]
            if entry.img < 1 then
              local imageTransparency = entry.img + (1 - entry.img) * data
              if math.abs(instance.ImageTransparency - imageTransparency) > 0.01 then
                instance.ImageTransparency = imageTransparency
              end
            end
            if entry.bg < 1 then
              local backgroundTransparency = entry.bg + (1 - entry.bg) * data
              if math.abs(instance.BackgroundTransparency - backgroundTransparency) > 0.01 then
                instance.BackgroundTransparency = backgroundTransparency
              end
            end
          end
        end
        checkCondition(instance)
        local descendants = instance:GetDescendants()
        for i, descendant in ipairs(descendants) do
          checkCondition(descendant)
          if i % 300 ~= 0 then
            continue
          end
          task.wait()
          if data2 and data2 ~= transparencyUpdateId then
            return
          end
        end
      end
      getValue45 = function(data, data2, data3)
        if not data then
          return
        end
        if data3 ~= transparencyUpdateId then
          return
        end
        checkCondition(data, data2, data3)
        if data3 ~= transparencyUpdateId then
          return
        end
        collection10[#collection10 + 1] = data.DescendantAdded:Connect(function(descendant)
          if data3 ~= transparencyUpdateId then
            return
          end
          checkCondition(descendant, data2, data3)
        end)
      end
    end
    do
      local function findTarget14(instance, data, data2)
        if not instance then
          return
        end
        if data2 ~= transparencyUpdateId then
          return
        end
        for _, item in ipairs(collection11) do
          if data2 ~= transparencyUpdateId then
            return
          end
          getValue45(instance:FindFirstChild(item), data, data2)
        end
        if data2 ~= transparencyUpdateId then
          return
        end
        collection10[#collection10 + 1] = instance.ChildAdded:Connect(function(child)
          if data2 ~= transparencyUpdateId then
            return
          end
          for _, item in ipairs(collection11) do
            if child.Name == item then
              getValue45(child, data, data2)
              break
            end
          end
        end)
        local animalPodiums = instance:FindFirstChild("AnimalPodiums")
        if animalPodiums then
          local function handleState(instance)
            for _, child in ipairs(instance:GetChildren()) do
              if child.Name == "Claim" then
                getValue45(child, data, data2)
              elseif child.Name == "Base" then
                getValue45(child:FindFirstChild("Decorations"), data, data2)
              elseif child:IsA("Model") and child.Name ~= "Decorations" then
                getValue45(child, data, data2)
              end
            end
          end
          for _, child in ipairs(animalPodiums:GetChildren()) do
            handleState(child)
          end
          collection10[#collection10 + 1] = animalPodiums.ChildAdded:Connect(function(child)
            if data2 ~= transparencyUpdateId then
              return
            end
            task.wait(0.1)
            if data2 ~= transparencyUpdateId then
              return
            end
            handleState(child)
          end)
        end
      end
      findTarget13 = function(data, data2)
        local plots_2 = WorkspaceRoot:FindFirstChild("Plots")
        if not plots_2 then
          return
        end
        for _, child in ipairs(plots_2:GetChildren()) do
          if data2 ~= transparencyUpdateId then
            return
          end
          findTarget14(child, data, data2)
        end
        collection10[#collection10 + 1] = plots_2.ChildAdded:Connect(function(child)
          if data2 ~= transparencyUpdateId then
            return
          end
          task.wait(0.2)
          findTarget14(child, data, data2)
        end)
      end
    end
  end
  do
    local function setClearBase(data)
      transparentPlotsEnabled = data
      for _, item in ipairs(collection10) do
        if typeof(item) == "RBXScriptConnection" then
          item:Disconnect()
        end
      end
      collection10 = {}
      transparencyUpdateId += 1
      local snapshot = transparencyUpdateId
      if data then
        local state46 = getValue41()
        task.spawn(function()
          while snapshot == transparencyUpdateId and not WorkspaceRoot:FindFirstChild("Plots") do
            task.wait()
          end
          if snapshot ~= transparencyUpdateId then
            return
          end
          pcall(findTarget13, state46, snapshot)
        end)
        pcall(function()
          localPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
        end)
      else
        local snapshot = obj
        obj = setmetatable({}, {
          __mode = "k",
        })
        for k, item in pairs(snapshot) do
          pcall(function()
            if k:IsA("BasePart") then
              k.Transparency = item
            elseif k:IsA("TextLabel") or k:IsA("TextButton") then
              k.TextTransparency = item.text
              k.BackgroundTransparency = item.bg
            elseif k:IsA("Frame") or k:IsA("ScrollingFrame") then
              k.BackgroundTransparency = item
            elseif k:IsA("ImageLabel") or k:IsA("ImageButton") then
              k.ImageTransparency = item.img
              k.BackgroundTransparency = item.bg
            end
          end)
        end
        local originalTransparency = _G.OriginalTransparency
        if type(originalTransparency) == "table" then
          for k, item in pairs(originalTransparency) do
            if k and k.Parent and typeof(item) == "table" and item.trans then
              pcall(function()
                k.Transparency = item.trans
              end)
            end
          end
        end
        local laser = _G.__laser
        if laser and laser.RefreshAllPlotLasers then
          pcall(laser.RefreshAllPlotLasers)
        end
      end
    end
    _G.setClearBase = setClearBase
    toggleClearBase = function()
      setClearBase(not transparentPlotsEnabled)
    end
    local isConditionMet = enumValues and enumValues.Players or game:GetService("Players")
    local isEnabled = false
    isConditionMet.PlayerAdded:Connect(function()
      if not transparentPlotsEnabled then
        return
      end
      if isEnabled then
        return
      end
      isEnabled = true
      task.spawn(function()
        task.wait(0.5)
        isEnabled = false
        if transparentPlotsEnabled then
          pcall(setClearBase, true)
        end
      end)
    end)
  end
  task.wait(0.1)
  placeId = game.PlaceId
  jobId = game.JobId
  do
    local playerListUI = playerGui:FindFirstChild("PlayerListUI") or _G._xenHUI():FindFirstChild("PlayerListUI")
    if playerListUI then
      playerListUI:Destroy()
    end
  end
end
local ScreenGui, backgroundColor3, buttonGlowColorLocal502, color, collection3, collection4, rootPart, isEnabled5, removeESP, updateESP
local isEnabled6, resetBrainrotBeam, updateBrainrotBeam, collection5, savePositions, uiLocked_, makeDraggable, ScrollingFrame, parent2, stroke
local createUiElement, bottomRightButtonsFrame, proximityFrame, keybinds, loadData, j2, y, saveKeybinds, handleState2, label
local parent3, isEnabled7, keybinds2, getValue2, handleState3, handleState4, createUiElement2
do
  local TextBox, parentLocal55
  do
    local state47, Highlight, updateLabel, collection12, getValue46, updateLabel22, isEnabledLocal84, featureState, getValue2, parentLocal56
    local textLabel, parent2Local503, proximitySliderFill, parent3Local507
    do
      local state48
      do
        local buildInterface2
        do
          local state49, text, collection, findTarget
          do
            local teleportToHighest
            ScreenGui = newInstance("ScreenGui")
            setProperties(ScreenGui, {
              Name = "PlayerListUI",
              ResetOnSpawn = false,
              Enabled = false,
              Parent = _G._xenHUI(),
            })
            state47 = blackColor
            backgroundColor3 = blackColor
            buttonGlowColorLocal502 = whiteColor
            color = Color3.fromRGB(240, 240, 240)
            state49 = 18
            _G.BUTTON_GLOW_COLOR = buttonGlowColorLocal502
            collection3 = {}
            collection4 = {}
            text = "Black"
            rootPart = newInstance("Frame")
            setProperties(rootPart, {
              Name = "StatsDisplay",
              Size = UDim2.new(0, 1, 0, 1),
              Position = zeroSize,
              BackgroundTransparency = 1,
              Visible = false,
              Parent = ScreenGui,
            })
            isEnabled5 = true
            collection = {}
            do
              local function findTarget15(data)
                local isConditionMet = data or 5
                if not localPlayer then
                  return nil
                end
                local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
                if not character then
                  return nil
                end
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if not humanoidRootPart then
                  local now2 = os.clock()
                  while true do
                    humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    task.wait()
                    if not (humanoidRootPart or os.clock() - now2 > isConditionMet) then
                      continue
                    end
                    break
                  end
                end
                if not humanoidRootPart then
                  return nil
                end
                return character, humanoidRootPart
              end
              local isEnabled = false
              local function findTarget2(data)
                local character = localPlayer.Character
                if not character then
                  return
                end
                local humanoid = character:FindFirstChild("Humanoid")
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if not humanoid or not humanoidRootPart then
                  return
                end
                local speedBoostEnabled = _G.SpeedBoostEnabled
                local walkspeedEnabled = _G.walkspeedEnabled
                if speedBoostEnabled and _G.SpeedBoostEnabled then
                  _G.SpeedBoostEnabled = false
                end
                if walkspeedEnabled and _G.toggleWalkspeed then
                  pcall(_G.toggleWalkspeed)
                end
                local controls =
                  require(localPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls()
                local lookVector = humanoidRootPart.CFrame.LookVector
                controls:Disable()
                local now2 = os.clock()
                local connection = nil
                connection = RunService.RenderStepped:Connect(function()
                  if os.clock() - now2 >= data then
                    connection:Disconnect()
                    humanoid:Move(Vector3.zero, false)
                    controls:Enable()
                    return
                  end
                  humanoid:Move(lookVector, false)
                end)
                task.wait(data + 0.05)
                if speedBoostEnabled then
                  _G.SpeedBoostEnabled = true
                end
                if walkspeedEnabled and _G.toggleWalkspeed then
                  pcall(_G.toggleWalkspeed)
                end
              end
              local function findTarget3()
                if _G.isCloning then
                  return
                end
                _G.isCloning = true
                pcall(function()
                  local character = localPlayer.Character
                  if not character then
                    return
                  end
                  local humanoid = character:FindFirstChildOfClass("Humanoid")
                  if not humanoid then
                    return
                  end
                  local quantumCloner = localPlayer.Backpack:FindFirstChild("Quantum Cloner")
                    or character:FindFirstChild("Quantum Cloner")
                  if not quantumCloner then
                    return
                  end
                  if quantumCloner.Parent == localPlayer.Backpack then
                    humanoid:EquipTool(quantumCloner)
                  end
                  _G._xenFastClone()
                  if _G.ServerPosCloneSwapPending then
                    pcall(_G.ServerPosCloneSwapPending)
                  end
                end)
                task.wait(0.15)
                _G.isCloning = false
              end
              teleportToHighest = function(data)
                local isActive = not data
                if isActive and isEnabled then
                  _G.isTeleporting = false
                  return
                end
                local instance2, rootPart = findTarget15()
                if not instance2 or not instance2.Parent then
                  _G.isTeleporting = false
                  return
                end
                if not rootPart or not rootPart.Parent then
                  _G.isTeleporting = false
                  return
                end
                local amount = 0
                while amount < 0.5 do
                  local debris = WorkspaceRoot:FindFirstChild("Debris")
                  if not (debris and #debris:GetChildren() > 0) then
                    task.wait(0.1)
                    amount += 0.1
                    continue
                  end
                  break
                end
                local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
                if not playerGui then
                  _G.isTeleporting = false
                  return
                end
                local teleportMessage = playerGui:FindFirstChild("TeleportMessage")
                if teleportMessage then
                  teleportMessage:Destroy()
                end
                local rootPart2 = nil
                local items = {
                  Cursed = "rgb(255,50,50)",
                  Gold = "rgb(255,215,0)",
                  Diamond = "rgb(0,255,255)",
                  YinYang = "rgb(220,220,220)",
                  Rainbow = "rgb(255,100,200)",
                  Lava = "rgb(255,100,20)",
                  Crystal = "rgb(228,175,242)",
                  Candy = "rgb(255,105,180)",
                  Bloodrot = "rgb(139,0,0)",
                  Radioactive = "rgb(0,255,0)",
                  Divine = "rgb(255,255,150)",
                  Galaxy = "rgb(155,50,255)",
                  Cyber = "rgb(50,180,255)",
                  Phantom = "rgb(150,150,150)",
                }
                local function getValue(data, data2, data3)
                  if data and data ~= "None" then
                    local text = items[data] or "rgb(200,100,255)"
                    if data == "Rainbow" then
                      local items = {
                        "rgb(255,0,0)",
                        "rgb(255,127,0)",
                        "rgb(255,255,0)",
                        "rgb(0,255,0)",
                        "rgb(0,150,255)",
                        "rgb(75,0,255)",
                        "rgb(200,0,255)",
                      }
                      local state = data:upper()
                      local text = ""
                      for i = 1, #state do
                        text ..= "<font color='" .. items[(i - 1) % #items + 1] .. "'>" .. state:sub(i, i) .. "</font>"
                      end
                      return text .. " " .. data2 .. " Detected!" .. (data3 or "")
                    end
                    if data == "Crystal" then
                      local state = #data
                      local text = ""
                      for i = 1, state do
                        local isConditionMet = state > 1 and (i - 1) / (state - 1) or 0
                        text ..= "<font color='rgb(" .. math.floor(255 - 55 * isConditionMet) .. "," .. math.floor(
                          190 - 30 * isConditionMet
                        ) .. "," .. math.floor(230 + 25 * isConditionMet) .. ")'>" .. data:sub(
                          i,
                          i
                        ) .. "</font>"
                      end
                      return text .. " " .. data2 .. " Detected!" .. (data3 or "")
                    end
                    if data == "YinYang" then
                      data3 = data3 or ""
                      return "<font color='rgb(30,30,30)'>Yin</font> <font color='rgb(255,255,255)'>Yang</font> "
                        .. data2
                        .. " Detected!"
                        .. data3
                    end
                    local text2 = "<font color='" .. text .. "'>" .. data .. "</font>"
                    if data == "Phantom" then
                      text2 = "<stroke color='#000000' thickness='3'>" .. text2 .. "</stroke>"
                    end
                    data3 = data3 or ""
                    return text2 .. " " .. data2 .. " Detected!" .. data3
                  end
                  return data2 .. " Detected!" .. (data3 or "")
                end
                local function buildInterface()
                  if not rootPart2 then
                    rootPart2 = newInstance("TextLabel")
                    setProperties(rootPart2, {
                      Text = "",
                      TextColor3 = greenColor,
                      RichText = true,
                    })
                  end
                end
                local function getValue2()
                  if not rootPart2 then
                    return
                  end
                  if _G._xenShowNotif then
                    pcall(function()
                      _G._xenShowNotif(rootPart2.Text, rootPart2.TextColor3, 3)
                    end)
                  end
                end
                local function handleState() end
                task.wait(0.1)
                local plotSign = nil
                if plotsFolder then
                  plotSign = nil
                  for _, child in ipairs(plotsFolder:GetChildren()) do
                    plotSign = child:FindFirstChild("PlotSign")
                    if plotSign then
                      local surfaceGui = plotSign:FindFirstChildWhichIsA("SurfaceGui", true)
                      if surfaceGui then
                        local textLabel = surfaceGui:FindFirstChildWhichIsA("TextLabel", true)
                        if textLabel and textLabel.Text then
                          local lowercaseText = textLabel.Text:lower()
                          local pos = localPlayer.Name and lowercaseText:find(localPlayer.Name:lower(), 1, true)
                          local displayName
                          if pos then
                            displayName = pos
                          else
                            displayName = localPlayer.DisplayName
                            if displayName then
                              displayName = lowercaseText:find(localPlayer.DisplayName:lower(), 1, true)
                            end
                          end
                          if not displayName then
                            plotSign = nil
                            continue
                          end
                        else
                          plotSign = nil
                          continue
                        end
                      else
                        plotSign = nil
                        continue
                      end
                    else
                      plotSign = nil
                      continue
                    end
                    break
                  end
                end
                local items2 = {}
                local items3 = {}
                local collection = _G.RefreshPlotInfo()
                local parent = plotSign and plotSign.Parent or nil
                if parent then
                  local position = parent:GetPivot().Position
                end
                local collection2 = _G.ScanDebrisCore(true)
                for _, item in ipairs(collection2) do
                  if item.hasLabels then
                    if not item.isMyPlot then
                      if not item.isCarpetItem then
                        if not item.ownerInGame then
                          continue
                        end
                      end
                      if (_G.TPMinValue or 5) * 1000000 <= item.value then
                        table.insert(items3, {
                          value = item.value,
                          name = item.name,
                        })
                      end
                      if (_G.TPMinValue or 5) * 1000000 <= item.value then
                        table.insert(items2, {
                          value = item.value,
                          position = item.position,
                          name = item.name,
                          mutation = item.mutation,
                          priorityLevel = 999,
                          isCarpetItem = item.isCarpetItem,
                          rawPosition = item.rawPosition,
                          part = item.part,
                          slot = item.slot,
                        })
                      end
                    end
                  end
                end
                if not _G._xenConvDataLoaded then
                  _G._xenConvDataLoaded = true
                  local snapshot = _G
                  local xenAnimShim = _G._xenAnimShim
                  _G._xenAnimalsData = require(enumValues.ReplicatedStorage.Datas.Animals)
                  snapshot._xenSharedAnim = xenAnimShim
                end
                local renderedMovingAnimals = WorkspaceRoot:FindFirstChild("RenderedMovingAnimals")
                if renderedMovingAnimals then
                  for _, child in ipairs(renderedMovingAnimals:GetChildren()) do
                    pcall(function()
                      if not child:IsA("Model") then
                        return
                      end
                      local player = _G._xenAnimalsData[child.Name]
                      if not player then
                        return
                      end
                      local attribute = child:GetAttribute("Mutation")
                      local generation = _G._xenSharedAnim:GetGeneration(child.Name, attribute, nil, nil) or 0
                      local primaryPart = child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")
                      local isActive
                      if primaryPart then
                        isActive = generation >= (_G.TPMinValue or 5) * 1000000
                      else
                        isActive = primaryPart
                      end
                      if isActive then
                        local position = primaryPart.Position
                        local displayName = player.DisplayName or child.Name
                        table.insert(items3, {
                          value = generation,
                          name = displayName,
                        })
                        table.insert(items2, {
                          value = generation,
                          position = position - Vector3.new(0, 11, 0),
                          name = displayName,
                          mutation = attribute,
                          priorityLevel = 999,
                          isCarpetItem = true,
                          rawPosition = position,
                          part = primaryPart,
                          model = child,
                        })
                      end
                    end)
                  end
                end
                if #items2 == 0 then
                  buildInterface()
                  local textColor3 = lightRedColor
                  rootPart2.Text = "No valuable brainrots detected"
                  rootPart2.TextColor3 = textColor3
                  getValue2()
                  task.wait(2)
                  handleState()
                  _G.isTeleporting = false
                  return
                end
                table.sort(items2, function(data, data2)
                  return data.value > data2.value
                end)
                local snapshot = sharedPriorityItems
                local function checkCondition(data)
                  local mutation = type(data) == "table" and data.mutation or nil
                  if data.priorityLevel and data.priorityLevel < 999 then
                    return data.priorityLevel + math.min(getMutationRank(mutation), 99) / 1000
                  end
                  if data.name then
                    local lowercaseText = data.name:lower()
                    for i, item in ipairs(snapshot) do
                      if lowercaseText:find(item, 1, true) then
                        return i + math.min(getMutationRank(mutation), 99) / 1000
                      end
                    end
                  end
                  if data.label then
                    local model = data.label:FindFirstAncestorOfClass("Model")
                    if not model then
                      return 999
                    end
                    local lowercaseText = model.Name:lower()
                    for i, item in ipairs(snapshot) do
                      if lowercaseText:find(item, 1, true) then
                        return i + math.min(getMutationRank(mutation), 99) / 1000
                      end
                    end
                    for _, descendant in ipairs(model:GetDescendants()) do
                      if descendant:IsA("TextLabel") and descendant.Text then
                        local lowercaseText = descendant.Text:lower()
                        for i, item in ipairs(snapshot) do
                          if lowercaseText:find(item, 1, true) then
                            return i + math.min(getMutationRank(mutation), 99) / 1000
                          end
                        end
                      end
                    end
                  end
                  return 999
                end
                local function findTarget16(data, rootPart, data2)
                  local num = tonumber(data2)
                  if num then
                    if num >= 19 and num <= 26 then
                      return 3
                    end
                    if num >= 11 and num <= 18 then
                      return 2
                    end
                    if num >= 1 and num <= 10 then
                      return 1
                    end
                  end
                  if rootPart then
                    pcall(function()
                      local plots = WorkspaceRoot:FindFirstChild("Plots")
                      if plots then
                        local huge = math.huge
                        local instance2 = nil
                        for _, child in ipairs(plots:GetChildren()) do
                          local animalPodiums = child:FindFirstChild("AnimalPodiums")
                          if animalPodiums then
                            for _, child2 in ipairs(animalPodiums:GetChildren()) do
                              local success, callResult = pcall(function()
                                return child2:GetPivot().Position
                              end)
                              if success then
                                local magnitude = (rootPart.Position - callResult).Magnitude
                                if magnitude < huge then
                                  instance2 = child2
                                  huge = magnitude
                                end
                              end
                            end
                          end
                        end
                        if instance2 and huge < 15 then
                          local isConditionMet = tonumber(instance2.Name) or 0
                          if isConditionMet >= 19 and isConditionMet <= 26 then
                            return 3
                          end
                          if isConditionMet >= 11 and isConditionMet <= 18 then
                            return 2
                          end
                          if isConditionMet >= 1 and isConditionMet <= 10 then
                            return 1
                          end
                        end
                      end
                    end)
                  end
                  if data >= -6.9 and data <= 8.9 then
                    return 1
                  end
                  if data >= 11 and data <= 23.15 then
                    return 2
                  end
                  if data > 23.15 then
                    return 3
                  end
                  return 0
                end
                local parent2 = _G.SelectedStealTarget
                  and _G.SelectedStealTarget.part
                  and _G.SelectedStealTarget.part.Parent
                local rootPart3 = nil
                local plotSign2 = nil
                local isEnabledLocal85 = false
                if parent2 then
                  if _G.SelectedStealTarget.directPrompt then
                    _G.isTeleporting = false
                    return
                  end
                  local position = _G.SelectedStealTarget.position
                    or _G.SelectedStealTarget.part.Position - Vector3.new(0, 11, 0)
                  local isConditionMet = _G.SelectedStealTarget.value or 0
                  local name = _G.SelectedStealTarget.name or "Unknown"
                  local huge = math.huge
                  plotSign2 = nil
                  for _, item in pairs(collection) do
                    if item.plotSign then
                      local magnitude = (item.plotSign.Position - position).Magnitude
                      if magnitude < huge then
                        plotSign2 = item.plotSign
                        huge = magnitude
                      end
                    end
                  end
                  local isActive = plotSign2 and plotSign2 ~= plotSign
                  rootPart3 = nil
                  isEnabledLocal85 = false
                  if isActive then
                    rootPart3 = {
                      position = position,
                      value = isConditionMet,
                      name = name,
                    }
                    isEnabledLocal85 = true
                  end
                end
                local position = rootPart and rootPart.Position or Vector3.new(0, 0, 0)
                local autoStealPriorityEnabled = _G.AutoStealPriorityEnabled or false
                local amount2 = 999
                local amount3 = 0
                local amount4 = 0
                local bestAutoStealTarget = nil
                local bestTargetPlotSign = nil
                for _, item2 in ipairs(items2) do
                  local position2 = item2.position
                  local huge = math.huge
                  local state, state2, state3 = pairs(collection)
                  local plotSign3 = nil
                  for _, item in state, state2, state3 do
                    if item.plotSign then
                      local magnitude = (item.plotSign.Position - position2).Magnitude
                      if magnitude < huge then
                        plotSign3 = item.plotSign
                        huge = magnitude
                      end
                    end
                  end
                  if plotSign3 and plotSign3 ~= plotSign or item2.isCarpetItem then
                    local candidatePriorityRank = checkCondition(item2)
                    local candidateFloorRank = findTarget16(position2.Y, item2.part, item2.slot)
                    local state3 = item2.value
                    if autoStealPriorityEnabled then
                      if candidatePriorityRank < amount2 then
                        amount2 = candidatePriorityRank
                        amount3 = state3
                        amount4 = candidateFloorRank
                        bestAutoStealTarget = item2
                        bestTargetPlotSign = plotSign3
                      elseif candidatePriorityRank == amount2 then
                        if amount3 < state3 then
                          amount2 = candidatePriorityRank
                          amount3 = state3
                          amount4 = candidateFloorRank
                          bestAutoStealTarget = item2
                          bestTargetPlotSign = plotSign3
                        elseif state3 == amount3 then
                          if amount4 < candidateFloorRank then
                            amount2 = candidatePriorityRank
                            amount3 = state3
                            amount4 = candidateFloorRank
                            bestAutoStealTarget = item2
                            bestTargetPlotSign = plotSign3
                          end
                        end
                      end
                    elseif amount3 < state3 then
                      amount2 = candidatePriorityRank
                      amount3 = state3
                      amount4 = candidateFloorRank
                      bestAutoStealTarget = item2
                      bestTargetPlotSign = plotSign3
                    elseif state3 == amount3 then
                      if candidatePriorityRank < amount2 then
                        amount2 = candidatePriorityRank
                        amount3 = state3
                        amount4 = candidateFloorRank
                        bestAutoStealTarget = item2
                        bestTargetPlotSign = plotSign3
                      elseif candidatePriorityRank == amount2 then
                        if candidateFloorRank > amount4 then
                          amount2 = candidatePriorityRank
                          amount3 = state3
                          amount4 = candidateFloorRank
                          bestAutoStealTarget = item2
                          bestTargetPlotSign = plotSign3
                        end
                      end
                    end
                  end
                end
                if bestAutoStealTarget then
                  _G.AutoTPTargetPosition = bestAutoStealTarget.position
                end
                local part
                if isEnabledLocal85 and rootPart3 and plotSign2 then
                  part = plotSign2
                  amount3 = rootPart3.value
                  _G.AutoTPTargetPosition = rootPart3.position
                else
                  part = bestTargetPlotSign
                  rootPart3 = bestAutoStealTarget
                end
                if rootPart3 and rootPart3.name then
                  setProperties(_G, {
                    CurrentStealingItemName = rootPart3.name,
                    CurrentStealingItemPosition = rootPart3.position,
                    CurrentStealingItemValue = rootPart3.value,
                    CurrentStealingItemHeight = rootPart3.position.Y,
                  })
                else
                  local rootPart = _G
                  local snapshot = _G
                  local snapshot2 = _G
                  _G.CurrentStealingItemName = nil
                  rootPart.CurrentStealingItemPosition = nil
                  snapshot.CurrentStealingItemValue = nil
                  snapshot2.CurrentStealingItemHeight = nil
                end
                if rootPart3 and rootPart3.isCarpetItem and rootPart3.rawPosition then
                  buildInterface()
                  local name = rootPart3.name or "Unknown"
                  local color2 = Color3.fromRGB(50, 255, 50)
                  rootPart2.Text = "Carpet: " .. name
                  rootPart2.TextColor3 = color2
                  getValue2()
                  _G.XenCarpetTP(rootPart3)
                  if not data then
                    isEnabled = true
                  end
                  handleState()
                  _G.isTeleporting = false
                  return
                end
                if not part then
                  buildInterface()
                  if #items2 > 0 then
                    local entry = items2[1]
                    local text = getValue(entry.mutation, entry.name, "")
                    local textColor3 = greenColor
                    rootPart2.Text = text
                    rootPart2.TextColor3 = textColor3
                  else
                    local textColor3 = lightRedColor
                    rootPart2.Text = "No valuable brainrots detected"
                    rootPart2.TextColor3 = textColor3
                  end
                  getValue2()
                  task.wait(2)
                  handleState()
                  _G.isTeleporting = false
                  return
                end
                local isEnabled2 = false
                if part then
                  pcall(function()
                    local surfaceGui = part:FindFirstChildWhichIsA("SurfaceGui", true)
                    if surfaceGui then
                      local textLabel = surfaceGui:FindFirstChildWhichIsA("TextLabel", true)
                      if textLabel and textLabel.Text then
                        local state = (textLabel.Text:match("([^']+)'s") or textLabel.Text)
                          :gsub("^%s+", "")
                          :gsub("%s+$", "")
                        for _, player in ipairs(PlayersService:GetPlayers()) do
                          if player.Name:lower() == state:lower() or player.DisplayName:lower() == state:lower() then
                            if player:GetAttribute("__duels_block_steal") == true then
                              isEnabled2 = true
                            end
                            break
                          end
                        end
                      end
                    end
                  end)
                end
                local text = isEnabled2 and " (Duel)" or ""
                if amount3 < (_G.TPMinValue or 5) * 1000000 then
                  buildInterface()
                  if #items2 > 0 then
                    local entry = items2[1]
                    local text = getValue(entry.mutation, entry.name, text)
                    local textColor3 = greenColor
                    rootPart2.Text = text
                    rootPart2.TextColor3 = textColor3
                  else
                    local textColor3 = lightRedColor
                    rootPart2.Text = "No valuable brainrots detected"
                    rootPart2.TextColor3 = textColor3
                  end
                  getValue2()
                  task.wait(2)
                  handleState()
                  _G.isTeleporting = false
                  return
                end
                if isActive then
                  buildInterface()
                  local text = isEnabled2 and " (Duel)" or ""
                  if isEnabled2 then
                    local position2 = InputService.TouchEnabled
                      and not InputService.KeyboardEnabled
                      and not InputService.MouseEnabled
                    local udim2 = position2 and UDim2.new(0, 260, 0, 45) or UDim2.new(0, 480, 0, 90)
                    position2 = position2 and UDim2.new(0.5, -130, 0.08, 0) or UDim2.new(0.5, -240, 0.08, 0)
                    rootPart2.Size = udim2
                    rootPart2.Position = position2
                  end
                  local textColor3 = greenColor
                  rootPart2.Text = getValue(rootPart3.mutation, rootPart3.name, text)
                  rootPart2.TextColor3 = textColor3
                  getValue2()
                  task.delay(2, handleState)
                end
                local text2 = "Unknown"
                pcall(function()
                  local surfaceGui = part:FindFirstChildWhichIsA("SurfaceGui", true)
                  if surfaceGui then
                    local textLabel = surfaceGui:FindFirstChildWhichIsA("TextLabel", true)
                    if textLabel and textLabel.Text then
                      text2 = textLabel.Text:match("([^']+)'s BASE") or textLabel.Text
                    end
                  end
                end)
                local isEnabled3 = false
                pcall(function()
                  if rootPart then
                    local position2 = rootPart.Position
                    local plots_2 = WorkspaceRoot:FindFirstChild("Plots")
                    if plots_2 then
                      for _, child in ipairs(plots_2:GetChildren()) do
                        pcall(function()
                          local position3 = child:GetPivot().Position
                          if math.abs(position2.X - position3.X) < 22 and math.abs(position2.Z - position3.Z) < 22 then
                            isEnabled3 = true
                          end
                        end)
                        if not isEnabled3 then
                          continue
                        end
                        break
                      end
                    end
                  end
                end)
                if isEnabled3 then
                  _G.isTeleporting = false
                  return
                end
                local position2 = rootPart3.position
                local y2 = rootPart3.position.Y
                local position3 = part.Position
                local cFrame = part.CFrame
                local vector
                if y2 <= 8.9 then
                  local unit = (position3 - position2).Unit
                  local vector2 = Vector3.new(unit.X * 3, 0, unit.Z * 3)
                  vector = Vector3.new(position3.X + vector2.X, -4, position3.Z + vector2.Z + math.random(-5, 5))
                else
                  local calculatedValue = cFrame.LookVector * -2
                  local state = math.random(-10, 10)
                  vector = part.Position + calculatedValue + Vector3.new(0, 6, state)
                end
                if y2 > 8.9 then
                  local part = newInstance("Part")
                  setProperties(part, {
                    Size = Vector3.new(6, 1, 6),
                    Position = Vector3.new(vector.X, position3.Y + 2.5, vector.Z),
                    Anchored = true,
                    CanCollide = true,
                    Transparency = 1,
                    Parent = WorkspaceRoot,
                  })
                  enumValues.Debris:AddItem(part, 8)
                end
                local vector2
                if vector.X <= position2.X then
                  vector2 = Vector3.new(1, 0, 0)
                else
                  vector2 = Vector3.new(-1, 0, 0)
                end
                local instance3
                instance3, rootPart = findTarget15()
                if rootPart then
                  _G.isTeleporting = true
                  pcall(function()
                    local humanoid = instance3:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                      local connection = nil
                      connection = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                        if not _G.isTeleporting then
                          if connection then
                            connection:Disconnect()
                          end
                          return
                        end
                        if humanoid.Health <= 0 then
                          humanoid.Health = humanoid.MaxHealth
                        end
                      end)
                      task.spawn(function()
                        while _G.isTeleporting do
                          task.wait(0.5)
                        end
                        if connection then
                          connection:Disconnect()
                        end
                      end)
                    end
                  end)
                  if not data then
                    isEnabled = true
                  end
                  if data then
                    if _G.SpeedBoostEnabled and _G.toggleSpeedBoost then
                      pcall(_G.toggleSpeedBoost)
                    end
                  end
                  pcall(function()
                    local humanoid = instance3:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                      local tpSpeedItem = _G.TPSpeedItem or "Flying Carpet"
                      local isConditionMet = localPlayer.Backpack:FindFirstChild(tpSpeedItem)
                        or instance3:FindFirstChild(tpSpeedItem)
                      if isConditionMet and isConditionMet.Parent == localPlayer.Backpack then
                        humanoid:EquipTool(isConditionMet)
                      end
                    end
                  end)
                  task.wait(0.01)
                  local connection = nil
                  pcall(function()
                    local humanoid = instance3:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                      humanoid.BreakJointsOnDeath = false
                      humanoid:SetStateEnabled(enumValues.deadHumanoidState, false)
                      humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
                      humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                      humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                      connection = RunService.Heartbeat:Connect(function()
                        if humanoid and humanoid.Parent and humanoid.Health <= 0 then
                          humanoid.Health = humanoid.MaxHealth
                        end
                      end)
                    end
                  end)
                  local tpVelocity = _G.TPVelocity or 300
                  local y3 = rootPart.Position.Y
                  local calculatedValue11 = y3 + 39
                  local now2 = os.clock()
                  local assemblyLinearVelocity = rootPart.AssemblyLinearVelocity
                  local x = assemblyLinearVelocity.X
                  local z = assemblyLinearVelocity.Z
                  while rootPart.Parent do
                    local y4 = rootPart.Position.Y
                    if not (calculatedValue11 <= y4) then
                      local calculatedValue12 = calculatedValue11 - y4
                      rootPart.AssemblyLinearVelocity = Vector3.new(
                        x,
                        calculatedValue12 < 5 and math.min(tpVelocity, calculatedValue12 * 10) or tpVelocity,
                        z
                      )
                      task.wait(0.0015)
                      local y5 = rootPart.Position.Y
                      if calculatedValue11 <= y5 then
                        rootPart.AssemblyLinearVelocity = Vector3.new(x, 0, z)
                        break
                      else
                        if math.abs(y5 - y3) < 0.05 then
                          rootPart.CFrame = rootPart.CFrame + Vector3.new(0, 1, 0)
                        end
                        if os.clock() - now2 > 3 then
                          break
                        else
                          y3 = y5
                          continue
                        end
                      end
                    end
                    break
                  end
                  if rootPart.Parent then
                    if rootPart.Position.Y > calculatedValue11 then
                      local position4 = rootPart.Position
                      rootPart.CFrame = CFrame.new(position4.X, calculatedValue11, position4.Z)
                        * (rootPart.CFrame - rootPart.CFrame.Position)
                    end
                    local assemblyLinearVelocity2 = rootPart.AssemblyLinearVelocity
                    rootPart.AssemblyLinearVelocity =
                      Vector3.new(assemblyLinearVelocity2.X, 0, assemblyLinearVelocity2.Z)
                  end
                  rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                  if connection then
                    connection:Disconnect()
                    connection = nil
                  end
                  rootPart.CFrame = CFrame.lookAt(vector, vector + vector2)
                  pcall(function()
                    local humanoid = instance3:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                      humanoid:Move(vector2, false)
                    end
                  end)
                  _cachedStealPrompt = nil
                  _cachedStealTarget = nil
                  local isEnabled = false
                  pcall(function()
                    local parent3 = part and part.Parent
                    if parent3 then
                      local unlock = parent3:FindFirstChild("Unlock")
                      if not unlock then
                        isEnabled = true
                      else
                        local items = {}
                        for _, child in pairs(unlock:GetChildren()) do
                          local position4 = nil
                          if child:IsA("Model") then
                            pcall(function()
                              position4 = child:GetPivot().Position
                            end)
                          elseif child:IsA("BasePart") then
                            position4 = child.Position
                          end
                          if position4 then
                            table.insert(items, {
                              Object = child,
                              Height = position4.Y,
                            })
                          end
                        end
                        table.sort(items, function(data, data2)
                          return data.Height < data2.Height
                        end)
                        if #items == 0 then
                          isEnabled = true
                        else
                          local instance = items[1].Object
                          local isEnabledLocal86 = false
                          for _, descendant in ipairs(instance:GetDescendants()) do
                            if descendant:IsA("ProximityPrompt") and descendant.Enabled then
                              isEnabledLocal86 = true
                              break
                            end
                          end
                          local state
                          if not isEnabledLocal86 then
                            for _, child in ipairs(instance:GetChildren()) do
                              if child:IsA("ProximityPrompt") and child.Enabled then
                                isEnabledLocal86 = true
                                break
                              end
                            end
                            state = isEnabledLocal86
                          else
                            state = isEnabledLocal86
                          end
                          if not state then
                            isEnabled = true
                          end
                        end
                      end
                    end
                  end)
                  if isEnabled and y2 <= 8.9 then
                    local backpack = localPlayer:FindFirstChild("Backpack")
                    if backpack then
                      local state = backpack:FindFirstChild(_G.TPSpeedItem or "Flying Carpet")
                      if state then
                        local humanoid = instance3:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                          humanoid:EquipTool(state)
                        end
                      end
                    end
                    wait(0.15)
                    local backpack2 = localPlayer:FindFirstChild("Backpack")
                    if backpack2 then
                      local state = backpack2:FindFirstChild(_G.TPSpeedItem or "Flying Carpet")
                      if state then
                        local humanoid = instance3:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                          humanoid:EquipTool(state)
                        end
                      end
                    end
                    if rootPart then
                      local position4 = rootPart.Position
                      local calculatedValue = rootPart.CFrame.LookVector * 50
                      local raycastParams = RaycastParams.new()
                      setProperties(raycastParams, {
                        FilterDescendantsInstances = {
                          instance3,
                        },
                        FilterType = Enum.RaycastFilterType.Blacklist,
                        IgnoreWater = true,
                      })
                      local hit = WorkspaceRoot:Raycast(position4, calculatedValue, raycastParams)
                      if hit then
                        local calculatedValue = hit.Position - rootPart.CFrame.LookVector * 0.5
                        rootPart.AssemblyLinearVelocity = Vector3.zero
                        rootPart.CFrame = CFrame.lookAt(calculatedValue, calculatedValue + rootPart.CFrame.LookVector)
                        rootPart.AssemblyLinearVelocity = Vector3.zero
                      end
                    end
                    task.wait(0.15)
                    pcall(function()
                      local character = localPlayer.Character
                      if not character then
                        return
                      end
                      local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                      local humanoid = character:FindFirstChildOfClass("Humanoid")
                      if not humanoidRootPart or not humanoid then
                        return
                      end
                      local backpack3 = localPlayer:FindFirstChild("Backpack")
                      if backpack3 then
                        local state = backpack3:FindFirstChild(_G.TPSpeedItem or "Flying Carpet")
                        if state then
                          humanoid:EquipTool(state)
                        end
                      end
                      humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                      humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                      humanoidRootPart.CFrame = CFrame.new(position2.X, humanoidRootPart.Position.Y, position2.Z)
                      humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                      humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                    end)
                  else
                    local character = localPlayer.Character
                    local humanoid = character and character:FindFirstChild("Humanoid")
                    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                    humanoid = character and humanoid and humanoidRootPart
                    local isEnabled = false
                    if humanoid then
                      local isActive = (
                        Vector3.new(humanoidRootPart.Position.X, 0, humanoidRootPart.Position.Z)
                        - Vector3.new(position2.X, 0, position2.Z)
                      ).Magnitude <= 50
                      local isEnabledLocal87 = false
                      pcall(function()
                        local raycastParams = RaycastParams.new()
                        local blacklist = Enum.RaycastFilterType.Blacklist
                        raycastParams.FilterDescendantsInstances = {
                          character,
                        }
                        raycastParams.FilterType = blacklist
                        if
                          WorkspaceRoot:Raycast(
                            humanoidRootPart.Position,
                            humanoidRootPart.CFrame.LookVector * 5,
                            raycastParams
                          )
                        then
                          isEnabledLocal87 = true
                        end
                      end)
                      isActive = isEnabledLocal87 and isActive
                      isEnabled = isActive
                    end
                    if isEnabled then
                      if y2 and y2 > 8.9 then
                        local character2 = localPlayer.Character
                        local rootPart = character2 and character2:FindFirstChild("HumanoidRootPart")
                        if rootPart then
                          rootPart.AssemblyLinearVelocity = Vector3.zero
                          task.wait(0.1)
                          rootPart.AssemblyLinearVelocity = Vector3.zero
                        end
                      end
                      findTarget2(0.4)
                      task.wait(_G.LandingDelay or 0.35)
                      local isEnabled = false
                      pcall(function()
                        local character2 = localPlayer.Character
                        local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
                        if humanoidRootPart2 then
                          local raycastParams = RaycastParams.new()
                          local blacklist = Enum.RaycastFilterType.Blacklist
                          raycastParams.FilterDescendantsInstances = {
                            character2,
                          }
                          raycastParams.FilterType = blacklist
                          local hit = WorkspaceRoot:Raycast(
                            humanoidRootPart2.Position,
                            humanoidRootPart2.CFrame.LookVector * 3,
                            raycastParams
                          )
                          if hit then
                            if (humanoidRootPart2.Position - hit.Position).Magnitude <= 3 then
                              isEnabled = true
                            end
                          end
                        end
                      end)
                      if isEnabled then
                        if _G.AutoCloneAfterTP then
                          local position4 = rootPart and rootPart.Position or Vector3.zero
                          findTarget3()
                          while _G.isCloning do
                            task.wait()
                          end
                          local isEnabled = false
                          local calculatedValue = os.clock() + 3
                          local character2 = nil
                          while os.clock() < calculatedValue do
                            character2 = localPlayer.Character
                            if character2 then
                              local humanoidRootPart = character2:FindFirstChild("HumanoidRootPart")
                              if humanoidRootPart and (humanoidRootPart.Position - position4).Magnitude > 0.3 then
                                isEnabled = true
                                break
                              else
                                task.wait()
                              end
                            else
                              task.wait()
                            end
                          end
                          character2 = character2 or localPlayer.CharacterAdded:Wait()
                          local rootPart = character2 and character2:WaitForChild("HumanoidRootPart", 3)
                          local humanoid2 = character2 and character2:WaitForChild("Humanoid", 3)
                          if isEnabled and rootPart and humanoid2 then
                            local isEnabled = false
                            local plots = WorkspaceRoot:FindFirstChild("Plots")
                            if plots then
                              local position5 = rootPart.Position
                              for _, child in ipairs(plots:GetChildren()) do
                                pcall(function()
                                  local position6 = child:GetPivot().Position
                                  local absoluteValue = math.abs(position5.X - position6.X)
                                  local absoluteValue2 = math.abs(position5.Z - position6.Z)
                                  if absoluteValue < 23 and absoluteValue2 < 23 then
                                    isEnabled = true
                                  end
                                end)
                                if not isEnabled then
                                  continue
                                end
                                break
                              end
                            end
                            if isEnabled then
                              task.wait(0.1)
                              pcall(function()
                                local backpack = localPlayer:FindFirstChild("Backpack")
                                if backpack then
                                  local state = backpack:FindFirstChild(_G.TPSpeedItem or "Flying Carpet")
                                  if state then
                                    humanoid2:EquipTool(state)
                                  end
                                end
                              end)
                              rootPart.AssemblyLinearVelocity = Vector3.zero
                              rootPart.AssemblyAngularVelocity = Vector3.zero
                              local tuffGoToBrainrot = _G._tuff_goToBrainrot
                              local tpDirectlyToPet
                              if tuffGoToBrainrot then
                                tpDirectlyToPet = _G.TPDirectlyToPet == nil or _G.TPDirectlyToPet
                              else
                                tpDirectlyToPet = tuffGoToBrainrot
                              end
                              if tpDirectlyToPet then
                                pcall(function()
                                  _G._tuff_goToBrainrot(position2, true)
                                end)
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                  local vector = vector
                  task.spawn(function()
                    task.wait(0.15)
                    local character = localPlayer.Character
                    if not character then
                      return
                    end
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if not humanoidRootPart then
                      return
                    end
                    local position4 = humanoidRootPart.Position
                    local magnitude = (Vector3.new(position4.X, 0, position4.Z) - Vector3.new(vector.X, 0, vector.Z)).Magnitude
                    local magnitude2 = (position4 - Vector3.new(0, 3, 0)).Magnitude
                    local magnitude3 = (position4 - Vector3.new(-381, 27, 86)).Magnitude
                    if magnitude > 30 and (magnitude2 < 50 or magnitude3 < 20) then
                      pcall(function()
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                          humanoid:MoveTo(humanoidRootPart.Position)
                          humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                        end
                      end)
                      task.wait(0.2)
                      for i = 1, 3 do
                        pcall(function()
                          setProperties(humanoidRootPart, {
                            AssemblyLinearVelocity = Vector3.zero,
                            AssemblyAngularVelocity = Vector3.zero,
                            CFrame = CFrame.new(vector),
                          })
                          local rootPart = humanoidRootPart
                          humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                          rootPart.AssemblyAngularVelocity = Vector3.zero
                        end)
                        task.wait(0.15)
                        local position5 = humanoidRootPart.Position
                        if
                          not (
                            (Vector3.new(position5.X, 0, position5.Z) - Vector3.new(vector.X, 0, vector.Z)).Magnitude
                            < 30
                          )
                        then
                          continue
                        end
                        break
                      end
                    end
                  end)
                  local isEnabled2 = false
                  local rootPart = part
                  pcall(function()
                    if rootPart and rootPart.Parent then
                      for _, descendant in pairs(rootPart.Parent:GetDescendants()) do
                        if descendant.Name and descendant.Name:find("Sentry") then
                          isEnabled2 = true
                          break
                        end
                      end
                      if not isEnabled2 then
                        local position4 = rootPart.Position
                        for _, descendant in pairs(WorkspaceRoot:GetDescendants()) do
                          if descendant.Name and descendant.Name:find("Sentry") then
                            local position5 = nil
                            pcall(function()
                              if descendant:IsA("BasePart") then
                                position5 = descendant.Position
                              elseif descendant:IsA("Model") and descendant.PrimaryPart then
                                position5 = descendant.PrimaryPart.Position
                              end
                            end)
                            if position5 and (position5 - position4).Magnitude < 100 then
                              isEnabled2 = true
                              break
                            end
                          end
                        end
                      end
                    end
                  end)
                  task.spawn(function()
                    task.wait(5)
                    _G.isTeleporting = false
                  end)
                  task.delay(3, function() end)
                end
              end
            end
            local rootPart = _G
            _G.TeleportToHighest = teleportToHighest
            rootPart.AutoTPTargetPosition = nil
          end
          task.spawn(function()
            task.wait(0.1)
            local isEnabled = false
            task.spawn(function()
              local now2 = os.clock()
              local state = -1
              local now3 = nil
              while os.clock() - now2 < 3 do
                local isConditionMet = _G._xenAnimalsCache and #_G._xenAnimalsCache or 0
                if isConditionMet ~= state then
                  now3 = os.clock()
                  state = isConditionMet
                end
                if not ((isConditionMet > 0 or os.clock() - now2 >= 1) and now3 and os.clock() - now3 >= 0.15) then
                  task.wait()
                  continue
                end
                break
              end
              isEnabled = true
            end)
            local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 10)
            local humanoid = character:WaitForChild("Humanoid", 10)
            if not humanoidRootPart or not humanoid then
              return
            end
            if not character:IsDescendantOf(WorkspaceRoot) then
              character.AncestryChanged:Wait()
            end
            local none = Enum.HumanoidStateType.None
            if humanoid:GetState() == none then
              humanoid.StateChanged:Wait()
            end
            local autoTPEnabledFromSave = false
            pcall(function()
              if _G.AutoTPEnabledFromSave ~= nil then
                autoTPEnabledFromSave = _G.AutoTPEnabledFromSave
              elseif _G.autoTPButtonEnabled ~= nil then
                autoTPEnabledFromSave = _G.autoTPButtonEnabled
              end
            end)
            if autoTPEnabledFromSave then
              pcall(function()
                local backpack = localPlayer:FindFirstChild("Backpack")
                if backpack then
                  local grappleHook = backpack:FindFirstChild("Grapple Hook")
                  if
                    grappleHook
                    and grappleHook:IsA("Tool")
                    and grappleHook.Parent == backpack
                    and humanoid
                    and humanoid.Health > 0
                  then
                    humanoid:EquipTool(grappleHook)
                  end
                end
              end)
            end
            local isEnabled2 = false
            pcall(function()
              if _G.AutoTPEnabledFromSave ~= nil then
                isEnabled2 = _G.AutoTPEnabledFromSave
              elseif _G.autoTPButtonEnabled ~= nil then
                isEnabled2 = _G.autoTPButtonEnabled
              end
            end)
            if not isEnabled2 then
              return
            end
            if _G._joinAutoTPDone then
              return
            end
            for i = 1, 300 do
              if not _G._tween_runAutoSnipe then
                task.wait(0.05)
                continue
              end
              break
            end
            if not _G._tween_runAutoSnipe then
              return
            end
            if _G._joinAutoTPDone then
              return
            end
            _G._joinAutoTPDone = true
            if (_G.TPDelay or 0) > 0 then
              task.wait(_G.TPDelay)
            end
            if _G._tween_runAutoSnipe then
              local now2 = os.clock()
              while not isEnabled and os.clock() - now2 < 3 do
                task.wait()
              end
              local xenFindMyPlot = nil
              pcall(function()
                xenFindMyPlot = _G._xenFindMyPlot and _G._xenFindMyPlot()
              end)
              if not xenFindMyPlot then
                local BindableEvent = newInstance("BindableEvent")
                local isEnabled = false
                local items = {}
                local function sendRequest()
                  if isEnabled then
                    return
                  end
                  isEnabled = true
                  for _, item in ipairs(items) do
                    pcall(function()
                      item:Disconnect()
                    end)
                  end
                  pcall(function()
                    BindableEvent:Fire()
                  end)
                end
                local function onChildAdded()
                  if isEnabled then
                    return
                  end
                  local xenFindMyPlot2 = nil
                  pcall(function()
                    xenFindMyPlot2 = _G._xenFindMyPlot and _G._xenFindMyPlot()
                  end)
                  if xenFindMyPlot2 then
                    xenFindMyPlot = xenFindMyPlot2
                    sendRequest()
                  end
                end
                local function setupConnections(instance)
                  if instance:IsA("TextLabel") then
                    items[#items + 1] = instance:GetPropertyChangedSignal("Text"):Connect(onChildAdded)
                  end
                end
                pcall(function()
                  local plots = WorkspaceRoot:FindFirstChild("Plots")
                  if plots then
                    items[#items + 1] = plots.DescendantAdded:Connect(function(descendant)
                      setupConnections(descendant)
                      onChildAdded()
                    end)
                    items[#items + 1] = plots.ChildAdded:Connect(onChildAdded)
                    for _, descendant in ipairs(plots:GetDescendants()) do
                      setupConnections(descendant)
                    end
                  else
                    items[#items + 1] = WorkspaceRoot.ChildAdded:Connect(function(child)
                      if child.Name == "Plots" then
                        items[#items + 1] = child.DescendantAdded:Connect(function(descendant)
                          setupConnections(descendant)
                          onChildAdded()
                        end)
                        onChildAdded()
                      end
                    end)
                  end
                end)
                pcall(function()
                  local xenPlotSync = _G._xenPlotSync
                  if xenPlotSync and xenPlotSync.OnChannelCreated and xenPlotSync.OnChannelCreated.Connect then
                    items[#items + 1] = xenPlotSync.OnChannelCreated:Connect(onChildAdded)
                  end
                end)
                task.spawn(function()
                  while not isEnabled do
                    pcall(function()
                      if _G._xenScanAndListen then
                        _G._xenScanAndListen()
                      end
                    end)
                    onChildAdded()
                    if not isEnabled then
                      task.wait(0.1)
                      continue
                    end
                    break
                  end
                end)
                task.delay(15, sendRequest)
                BindableEvent.Event:Wait()
                pcall(function()
                  BindableEvent:Destroy()
                end)
              end
              local calculatedValue = (_G.TPMinValue or 5) * 1000000
              local name = localPlayer.Name
              local function findTarget()
                if _G._tween_overrideTarget then
                  return true
                end
                local