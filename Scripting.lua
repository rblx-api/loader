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
                  getValue39 = function(instance2)
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
              end
            end
          end
        end
      end
    end
  end
end