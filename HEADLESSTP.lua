-- Headless TP: standalone, source-derived implementation with an embeddable API.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
assert(player, "Headless TP must run on the client")
local config = _G.HeadlessTPConfig or {}
if typeof(_G.__HeadlessTPCleanup) == "function" then
    local ok, message = pcall(_G.__HeadlessTPCleanup)
    if not ok then error("Headless TP could not stop the previous instance: " .. tostring(message)) end
end
local alive = true
local connections, disposers = {}, {}
local state = {
    Nearest = false, InstantSteal = false, StealBoost = false, CarpetSpeed = false,
    InfiniteJump = false, AntiDie = true, LowServer = false,
    PlayerESP = false, BrainrotESP = false, PodiumESP = false, XRay = false,
    ShowNumbers = true, NextBase = false, DropBrainrot = false, Panels = true, HideUI = false,
    FOV = workspace.CurrentCamera and workspace.CurrentCamera.FieldOfView or 70, AutoSave = false, FPSBoost = false, Halloween = false,
}
local defaults = table.clone(state)
local fileName = config.SettingsFile or "HeadlessTP.json"
local function validSetting(key, value)
    if key == "FOV" then return typeof(value) == "number" and value == value and value >= 40 and value <= 120 end
    return defaults[key] ~= nil and typeof(value) == "boolean"
end
if readfile and isfile and isfile(fileName) then
    local ok, saved = pcall(function() return HttpService:JSONDecode(readfile(fileName)) end)
    if ok and typeof(saved) == "table" and saved.AutoSave == true then
        for key, value in pairs(saved) do if validSetting(key, value) then state[key] = value end end
    end
end
for key, value in pairs(config.InitialState or {}) do if validSetting(key, value) then state[key] = value end end
local gui = Instance.new("ScreenGui")
gui.Name = "HeadlessTP"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 30
gui.Parent = config.Parent or player:WaitForChild("PlayerGui")
local function deviceClass()
    if config.DeviceClass == "phone" or config.DeviceClass == "tablet" or config.DeviceClass == "desktop" then return config.DeviceClass end
    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or gui.AbsoluteSize
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
        return math.min(viewport.X, viewport.Y) <= 500 and "phone" or "tablet"
    end
    return "desktop"
end
local function deviceScale() return deviceClass() == "phone" and 0.60 or 1 end
local changed = Instance.new("BindableEvent")
local controller = {Gui = gui, Changed = changed.Event}
local setters = {}
local saveVersion = 0
function controller.Destroy()
    if not alive then return end
    alive = false
    saveVersion += 1
    for _, connection in ipairs(connections) do pcall(function() connection:Disconnect() end) end
    for index = #disposers, 1, -1 do pcall(disposers[index]) end
    table.clear(connections)
    table.clear(disposers)
    gui:Destroy()
    changed:Destroy()
    if _G.__HeadlessTPCleanup == controller.Destroy then _G.__HeadlessTPCleanup = nil end
end
-- Register before feature setup so a subsequent execution can clean up partial setup too.
_G.__HeadlessTPCleanup = controller.Destroy
local destroyingConnection = gui.Destroying:Connect(controller.Destroy)
table.insert(connections, destroyingConnection)
local function save()
    if not writefile then return end
    saveVersion += 1
    local version = saveVersion
    task.delay(0.3, function()
        if not alive or version ~= saveVersion then return end
        local values = state.AutoSave and table.clone(state) or {AutoSave = false}
        if state.AutoSave then values.DropBrainrot = false; values.HideUI = false end
        local ok, message = pcall(function() writefile(fileName, HttpService:JSONEncode(values)) end)
        if not ok then warn("Headless TP settings: " .. tostring(message)) end
    end)
end
function controller.GetState() return table.clone(state) end
function controller.Set(key, value)
    if not alive then return false, "destroyed" end
    if not validSetting(key, value) then return false, "invalid setting" end
    if state[key] == value then return true end
    state[key] = value
    if setters[key] then setters[key](value) end
    changed:Fire(key, state[key])
    save()
    return true
end
local function listen(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(connections, connection)
    return connection
end
local function scope()
    local resources = {}
    local result = {}
    function result.add(resource) table.insert(resources, resource); return resource end
    function result.clear()
        for index = #resources, 1, -1 do
            local resource = resources[index]
            pcall(function()
                if typeof(resource) == "RBXScriptConnection" then resource:Disconnect()
                elseif typeof(resource) == "Instance" then resource:Destroy()
                else resource() end
            end)
        end
        table.clear(resources)
    end
    table.insert(disposers, result.clear)
    return result
end
local function make(class, props, parent)
    local object = Instance.new(class)
    for key, value in pairs(props) do object[key] = value end
    object.Parent = parent
    return object
end
local function round(object, radius)
    make("UICorner", {CornerRadius = UDim.new(0, radius or 10)}, object)
end
local function characterParts()
    local character = player.Character
    return character, character and character:FindFirstChildOfClass("Humanoid"), character and character:FindFirstChild("HumanoidRootPart")
end
local function carrying() return player:GetAttribute("Stealing") == true end
local function plots()
    local folder = workspace:FindFirstChild("Plots")
    return folder and folder:GetChildren() or {}
end
local function ownPlot(plot)
    local owner = plot:GetAttribute("Owner") or plot:GetAttribute("OwnerUserId")
    if owner ~= nil and (tostring(owner) == tostring(player.UserId) or tostring(owner) == player.Name) then return true end
    local sign = plot:FindFirstChild("PlotSign")
    local yourBase = sign and sign:FindFirstChild("YourBase", true)
    if yourBase and yourBase:IsA("GuiObject") and yourBase.Visible then return true end
    local surface = sign and sign:FindFirstChildWhichIsA("SurfaceGui", true)
    local label = surface and surface:FindFirstChildWhichIsA("TextLabel", true)
    if label then
        local name = label.Text:lower()
        return name == player.Name:lower() .. "'s base" or name == player.DisplayName:lower() .. "'s base"
    end
    return false
end
local function inPlot(plot, position)
    local root = plot:FindFirstChild("MainRoot")
    if not root then return false end
    local point = root.CFrame:PointToObjectSpace(position)
    return math.abs(point.X) <= 29 and math.abs(point.Z) <= 36 and point.Y >= -5 and point.Y <= 55
end
local palettes = {
    default = {background = Color3.fromRGB(20,22,32), row = Color3.fromRGB(34,20,54), hover = Color3.fromRGB(46,26,72),
        accent = Color3.fromRGB(124,38,222), dot = Color3.fromRGB(178,73,241), offDot = Color3.fromRGB(95,49,139), border = Color3.fromRGB(143,76,192), text = Color3.fromRGB(240,232,255), muted = Color3.fromRGB(155,120,196),
        floors = {Color3.fromRGB(70,20,130), Color3.fromRGB(110,35,175), Color3.fromRGB(155,55,220)}},
    halloween = {background = Color3.fromRGB(13,9,5), row = Color3.fromRGB(30,18,9), hover = Color3.fromRGB(76,44,16),
        accent = Color3.fromRGB(198,82,8), dot = Color3.fromRGB(255,140,26), offDot = Color3.fromRGB(128,76,30), border = Color3.fromRGB(226,102,12), text = Color3.fromRGB(255,241,218), muted = Color3.fromRGB(186,138,78),
        floors = {Color3.fromRGB(190,74,8), Color3.fromRGB(226,102,12), Color3.fromRGB(255,138,28)}},
}
local palette = palettes[state.Halloween and "halloween" or "default"]
local amber = Color3.fromRGB(255,180,70)
local renderTheme = function() end
local function setTheme()
    palette = palettes[state.Halloween and "halloween" or "default"]
    renderTheme()
end
setters.Halloween = setTheme
local originalFov = workspace.CurrentCamera and workspace.CurrentCamera.FieldOfView or 70
local function setFov()
    if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = state.FOV end
end
setters.FOV = setFov
listen(workspace:GetPropertyChangedSignal("CurrentCamera"), setFov)
table.insert(disposers, function() if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = originalFov end end)

-- Source autograb cycle, without its status UI; both toggles are required.
do
    local promptCache = setmetatable({}, {__mode = "k"})
    local target, held, cycleTimer, version = nil, nil, 0, 0
    local function enabled() return state.Nearest and state.InstantSteal end
    local function endHold()
        local previous = held
        held = nil
        if previous then pcall(function() previous:InputHoldEnd() end) end
    end
    local function nearest(root)
        local winner, minDistance = nil, 2000
        for _, plot in ipairs(plots()) do
            if ownPlot(plot) then continue end
            local podiums = plot:FindFirstChild("AnimalPodiums")
            if not podiums then continue end
            for _, podium in ipairs(podiums:GetChildren()) do
                local base = podium:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                local attachment = spawn and spawn:FindFirstChild("PromptAttachment")
                local prompt = promptCache[podium]
                if not prompt or not prompt.Parent or prompt.Parent ~= attachment or not prompt.Enabled then
                    prompt = nil
                    if attachment then
                        for _, child in ipairs(attachment:GetChildren()) do
                            if child:IsA("ProximityPrompt") and child.Enabled then prompt = child; break end
                        end
                    end
                    promptCache[podium] = prompt
                end
                if prompt and spawn and spawn:IsA("BasePart") then
                    local distance = (spawn.Position - root.Position).Magnitude
                    if distance < minDistance then winner, minDistance = prompt, distance end
                end
            end
        end
        return winner, minDistance
    end
    local function dispatch(prompt, signal)
        if typeof(getconnections) ~= "function" then return false end
        local ok, callbacks = pcall(getconnections, signal)
        if not ok or typeof(callbacks) ~= "table" then return false end
        local run, dispatched = version, false
        for _, connection in ipairs(callbacks) do
            if typeof(connection.Function) == "function" then
                dispatched = true
                task.spawn(function()
                    if alive and enabled() and run == version and target == prompt and prompt.Parent and prompt.Enabled then
                        pcall(connection.Function)
                    end
                end)
            end
        end
        return dispatched
    end
    local function triggerHoldBegan(prompt)
        if dispatch(prompt, prompt.PromptButtonHoldBegan) then return end
        held = prompt
        local ok = pcall(function() prompt:InputHoldBegin() end)
        if not ok then held = nil end
    end
    local function triggerPrompt(prompt)
        if dispatch(prompt, prompt.Triggered) then return end
        pcall(function() prompt:InputHoldEnd() end)
        if held == prompt then held = nil end
    end
    local function reset()
        version += 1
        endHold()
        target, cycleTimer = nil, 0
        table.clear(promptCache)
    end
    listen(RunService.Heartbeat, function(dt)
        if not enabled() then return end
        if carrying() or state.DropBrainrot then reset(); return end
        local _, humanoid, root = characterParts()
        if not root or not humanoid or humanoid.Health <= 0 then reset(); return end
        local prompt, distance = nearest(root)
        if target ~= prompt then
            version += 1
            endHold()
            target, cycleTimer = prompt, 0
        end
        if not prompt then cycleTimer = 0; return end
        cycleTimer += dt
        if cycleTimer >= 2.6 then
            cycleTimer = 0
            triggerHoldBegan(prompt)
        elseif cycleTimer >= 1.3 and distance <= 8 then
            triggerPrompt(prompt)
            if alive and enabled() and target == prompt then triggerHoldBegan(prompt) end
            cycleTimer = 0
        end
    end)
    setters.Nearest, setters.InstantSteal = reset, reset
    table.insert(disposers, reset)
end

-- Steal Boost: source movement delta, active only while carrying, target speed 27.
listen(RunService.Heartbeat, function(dt)
    if not state.StealBoost or not carrying() or state.DropBrainrot then return end
    local _, humanoid, root = characterParts()
    if not humanoid or not root or humanoid.Health <= 0 or root.Anchored then return end
    local direction = humanoid.MoveDirection
    local speed = math.clamp(tonumber(config.StealSpeed) or 27, 5, 29)
    if direction.Magnitude > 0 and speed > humanoid.WalkSpeed then
        root.CFrame += direction * (speed - humanoid.WalkSpeed) * math.min(dt, 0.1)
    end
end)

-- Anti Die: reversible death flags and health/state recovery, including respawns.
do
    local protection = scope()
    local function bind()
        protection.clear()
        if state.DropBrainrot or (not state.AntiDie and not carrying()) then return end
        local _, humanoid = characterParts()
        if not humanoid then return end
        local deathStates = {Enum.HumanoidStateType.Dead, Enum.HumanoidStateType.FallingDown, Enum.HumanoidStateType.Ragdoll}
        local saved = {BreakJointsOnDeath = humanoid.BreakJointsOnDeath, RequiresNeck = humanoid.RequiresNeck, states = {}}
        for _, value in ipairs(deathStates) do
            saved.states[value] = humanoid:GetStateEnabled(value)
            humanoid:SetStateEnabled(value, false)
        end
        humanoid.BreakJointsOnDeath, humanoid.RequiresNeck = false, false
        protection.add(function()
            if humanoid.Parent then
                humanoid.BreakJointsOnDeath, humanoid.RequiresNeck = saved.BreakJointsOnDeath, saved.RequiresNeck
                for value, enabled in pairs(saved.states) do humanoid:SetStateEnabled(value, enabled) end
            end
        end)
        local recovering = false
        local function recover()
            if recovering or not alive or not humanoid.Parent or (not state.AntiDie and not carrying()) then return end
            if humanoid.Health <= 0 then
                recovering = true
                humanoid.Health = humanoid.MaxHealth
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
                recovering = false
            end
        end
        protection.add(humanoid:GetPropertyChangedSignal("Health"):Connect(recover))
        protection.add(humanoid.Died:Connect(recover))
        protection.add(humanoid.StateChanged:Connect(function(_, current)
            if current == Enum.HumanoidStateType.Ragdoll or current == Enum.HumanoidStateType.FallingDown then
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end))
        recover()
    end
    setters.AntiDie = bind
    listen(player:GetAttributeChangedSignal("Stealing"), bind)
    listen(player.CharacterAdded, function(character)
        protection.clear()
        task.spawn(function()
            character:WaitForChild("Humanoid", 10)
            if alive and player.Character == character then bind() end
        end)
    end)
    bind()
end

-- Carpet Speed: horizontal LinearVelocity from Monode, no unrelated flight UI.
do
    local moverScope = scope()
    local mover, moverRoot
    local function clearMover() moverScope.clear(); mover, moverRoot = nil, nil end
    setters.CarpetSpeed = function() if not state.CarpetSpeed then clearMover() end end
    listen(player.CharacterAdded, clearMover)
    listen(RunService.Heartbeat, function()
        if state.DropBrainrot then clearMover(); return end
        if not state.CarpetSpeed then return end
        local character, humanoid, root = characterParts()
        if not root or not humanoid or humanoid.Health <= 0 or root.Anchored then clearMover(); return end
        local carpet = character:FindFirstChild("Flying Carpet")
        if not carpet then
            local backpack = player:FindFirstChildOfClass("Backpack")
            carpet = backpack and backpack:FindFirstChild("Flying Carpet")
            if carpet then humanoid:EquipTool(carpet) end
        end
        if not carpet then clearMover(); return end
        if moverRoot ~= root then
            clearMover()
            local attachment = moverScope.add(make("Attachment", {Name = "HeadlessCarpetAttachment"}, root))
            mover = moverScope.add(make("LinearVelocity", {
                Name = "HeadlessCarpetSpeed", Attachment0 = attachment, RelativeTo = Enum.ActuatorRelativeTo.World,
                VelocityConstraintMode = Enum.VelocityConstraintMode.Vector, ForceLimitMode = Enum.ForceLimitMode.PerAxis,
                MaxAxesForce = Vector3.new(math.huge, 0, math.huge), ForceLimitsEnabled = true,
            }, root))
            moverRoot = root
        end
        local direction = Vector3.new(humanoid.MoveDirection.X, 0, humanoid.MoveDirection.Z)
        mover.VectorVelocity = direction.Magnitude > 0 and direction.Unit * (tonumber(config.CarpetSpeed) or 140) or Vector3.zero
    end)
end

-- Infinite Jump: source impulse calculation and grounded/ragdoll guards.
do
    local lastJump = 0
    listen(UserInputService.JumpRequest, function()
        if not state.InfiniteJump or state.DropBrainrot or UserInputService:GetFocusedTextBox() then return end
        local _, humanoid, root = characterParts()
        if not humanoid or not root or humanoid.Health <= 0 or humanoid.SeatPart or root.Anchored or humanoid.PlatformStand then return end
        if humanoid.FloorMaterial ~= Enum.Material.Air then return end
        local current = humanoid:GetState()
        if current == Enum.HumanoidStateType.Dead or current == Enum.HumanoidStateType.Ragdoll or current == Enum.HumanoidStateType.Physics then return end
        if os.clock() - lastJump < 0.12 then return end
        local velocity = humanoid.UseJumpPower and humanoid.JumpPower or math.sqrt(2 * workspace.Gravity * math.max(0, humanoid.JumpHeight))
        local needed = velocity - root.AssemblyLinearVelocity.Y
        if needed <= 0.5 then return end
        lastJump = os.clock()
        root:ApplyImpulse(Vector3.new(0, root.AssemblyMass * needed, 0))
    end)
end

-- Low Server: prefer one player, then the lowest population of two or fewer.
do
    local version = 0
    local placeId = 96342491571673
    setters.LowServer = function(enabled)
        version += 1
        local run = version
        if not enabled then return end
        task.spawn(function()
            local cursor, seen, best = "", {}, nil
            while true do
                if not alive or run ~= version or not state.LowServer then return end
                local url = "https://games.roblox.com/v1/games/" .. tostring(placeId) .. "/servers/Public?sortOrder=Asc&limit=100"
                if cursor ~= "" then url ..= "&cursor=" .. HttpService:UrlEncode(cursor) end
                local ok, result = pcall(function()
                    local bytes
                    if config.HttpGet then bytes = config.HttpGet(url)
                    elseif request or http_request then
                        local response = (request or http_request)({Url = url, Method = "GET"})
                        assert(response.StatusCode == 200, "Server request failed")
                        bytes = response.Body
                    else bytes = game:HttpGet(url) end
                    return HttpService:JSONDecode(bytes)
                end)
                if not ok or typeof(result) ~= "table" then break end
                for _, server in ipairs(result.data or {}) do
                    if typeof(server.id) == "string" and typeof(server.playing) == "number" and server.playing >= 0 and server.playing <= 2 and server.id ~= game.JobId and server.playing < (server.maxPlayers or math.huge) then
                        if server.playing == 1 then best = server; break end
                        if not best or server.playing < best.playing then best = server end
                    end
                end
                if best and best.playing == 1 then break end
                cursor = result.nextPageCursor or ""
                if cursor == "" or seen[cursor] then break end
                seen[cursor] = true
                task.wait(0.2)
            end
            if not alive or run ~= version or not state.LowServer then return end
            if best then
                local ok, message = pcall(function() TeleportService:TeleportToPlaceInstance(placeId, best.id, player) end)
                if not ok then warn("Headless TP Low Server: " .. tostring(message)); controller.Set("LowServer", false) end
            else
                warn("Headless TP: no low-population server found, or HTTP is unavailable")
                controller.Set("LowServer", false)
            end
        end)
    end
    table.insert(disposers, function() version += 1 end)
    listen(TeleportService.TeleportInitFailed, function(failedPlayer)
        if failedPlayer == player and alive and state.LowServer then controller.Set("LowServer", false) end
    end)
end

-- FPS Boost: source-style reversible materials, shadows, textures and effects.
do
    local saved = setmetatable({}, {__mode = "k"})
    local savedShadows = Lighting.GlobalShadows
    local function write(object, property, value)
        saved[object] = saved[object] or {}
        if saved[object][property] == nil then saved[object][property] = object[property] end
        object[property] = value
    end
    local function optimize(object)
        if object:FindFirstAncestor("HeadlessTPWorld") then return end
        if object:IsA("BasePart") then
            write(object, "Material", Enum.Material.SmoothPlastic)
            write(object, "Reflectance", 0)
            write(object, "CastShadow", false)
        elseif object:IsA("ParticleEmitter") or object:IsA("Beam") or object:IsA("Trail") or object:IsA("Smoke") or object:IsA("Fire") or object:IsA("Sparkles") or object:IsA("Light") or object:IsA("PostEffect") then
            write(object, "Enabled", false)
        elseif object:IsA("Decal") or object:IsA("Texture") then write(object, "Transparency", 1) end
    end
    local function restore()
        Lighting.GlobalShadows = savedShadows
        for object, properties in pairs(saved) do
            if object.Parent then for property, value in pairs(properties) do pcall(function() object[property] = value end) end end
        end
        table.clear(saved)
    end
    setters.FPSBoost = function(enabled)
        if not enabled then restore(); return end
        Lighting.GlobalShadows = false
        for _, object in ipairs(workspace:GetDescendants()) do optimize(object) end
        for _, object in ipairs(Lighting:GetDescendants()) do optimize(object) end
    end
    listen(workspace.DescendantAdded, function(object) if state.FPSBoost then optimize(object) end end)
    listen(Lighting.DescendantAdded, function(object) if state.FPSBoost then optimize(object) end end)
    table.insert(disposers, restore)
end

local HT = {
    alive = true, images = {}, imageChanged = Instance.new("BindableEvent"),
    logoUrl = "https://cdn.discordapp.com/icons/1537207433393475584/449b5c903330de9fe0a568e733dcbb21.png?size=1536",
    bannerUrl = "https://cdn.discordapp.com/banners/1537207433393475584/91582a2f12de430e2b369beaad4a0a8e.webp?size=600",
}
table.insert(disposers, function()
    HT.alive = false
    HT.imageChanged:Destroy()
end)
function HT.bindImage(image, key)
    image.Image = HT.images[key] or ""
    local connection
    connection = HT.imageChanged.Event:Connect(function(changedKey)
        if not image.Parent then connection:Disconnect(); return end
        if changedKey == key then image.Image = HT.images[key] or "" end
    end)
    image.Destroying:Once(function() connection:Disconnect() end)
end
task.spawn(function()
    local overrides = config.Images or _G.HeadlessTPAssets or {}
    for _, item in ipairs({{"logo", HT.logoUrl, "logo.png"}, {"banner", HT.bannerUrl, "banner.webp"}}) do
        if not HT.alive then return end
        local key, url, name = item[1], item[2], item[3]
        local override = overrides[key]
        if override and tostring(override) ~= "" then
            HT.images[key] = tostring(override):match("^%d+$") and "rbxassetid://" .. tostring(override) or tostring(override)
        elseif typeof(getcustomasset) == "function" and typeof(writefile) == "function" and typeof(makefolder) == "function" then
            local ok, result = pcall(function()
                local directory = "HeadlessTPAssets"
                if not (isfolder and isfolder(directory)) then makefolder(directory) end
                local path = directory .. "/" .. name
                if not (isfile and isfile(path)) then
                    local fetch = request or http_request or (syn and syn.request)
                    local bytes
                    if fetch then
                        local response = fetch({Url = url, Method = "GET"})
                        assert(response.StatusCode == 200, "Asset download failed")
                        bytes = response.Body
                    else bytes = game:HttpGet(url) end
                    assert(typeof(bytes) == "string" and #bytes > 0, "Empty asset response")
                    writefile(path, bytes)
                end
                return getcustomasset(path)
            end)
            if ok then HT.images[key] = result else warn("Headless TP " .. key .. ": " .. tostring(result)) end
        else warn("Headless TP: provide a Roblox image asset ID for " .. key) end
        if HT.alive then HT.imageChanged:Fire(key) end
    end
end)

local SLOT_OFFSETS = {
        { 18.500,  1.531, -14.476,  90}, { 18.500,  1.531,  -6.976,  90}, { 18.500,  1.531,   0.524,  90},
        { 18.500,  1.531,   8.024,  90}, { 18.500,  1.531,  15.524,  90},
        {-18.536,  1.531,  15.524, -90}, {-18.536,  1.531,   8.024, -90}, {-18.536,  1.531,   0.524, -90},
        {-18.536,  1.531,  -6.976, -90}, {-18.536,  1.531, -14.476, -90},
        { 18.500, 19.531, -14.476,  90}, { 18.500, 19.531,  -6.976,  90}, { 18.500, 19.531,   0.524,  90},
        { 18.500, 19.531,   8.024,  90}, { 18.500, 19.531,  15.524,  90},
        {-18.380, 19.531, -14.452, -90}, {-18.380, 19.531,  -6.952, -90}, {-18.380, 19.531,   0.548, -90},
        { 18.500, 36.531, -12.476,  90}, { 18.500, 36.531,  -4.976,  90}, { 18.500, 36.531,   2.524,  90},
        { 18.500, 36.531,  10.024,  90}, { 18.500, 36.531,  17.524,  90},
        {-18.472, 36.531, -12.501, -90}, {-18.471, 36.531,  -5.001, -90}, {-18.471, 36.531,   2.499, -90},
        {-18.471, 36.531,   9.999, -90}, {-18.471, 36.531,  17.499, -90},
    }

local BASE_POSITIONS = {
        Vector3.new(-342.439, 10.399, 113.107), Vector3.new(-342.439, 10.465, 6.107),
        Vector3.new(-476.752, 10.465, 114.107), Vector3.new(-476.752, 10.465, 7.107),
        Vector3.new(-342.440, 10.464, 220.107), Vector3.new(-476.752, 10.465, 221.107),
        Vector3.new(-342.439, 10.465,-100.893), Vector3.new(-476.752, 10.465, -99.893),
    }

-- The 28 source offsets are relative to each plot's MainRoot.
local worldScope = scope()
local overlayScope = scope()
local worldFolder = worldScope.add(make("Folder", {Name = "HeadlessTPWorld"}, workspace))
local markers, floors = {}, {}
local nextPlot, nextCF
local nextAnchor = worldScope.add(make("Part", {
    Name = "NextBaseAnchor", Size = Vector3.new(0.1, 0.1, 0.1), Anchored = true,
    CanCollide = false, CanQuery = false, CanTouch = false, Transparency = 1,
}, worldFolder))
local nextBanner = worldScope.add(make("BillboardGui", {
    Name = "NextBaseIndicator", Adornee = nextAnchor, Size = UDim2.fromOffset(290, 184),
    StudsOffset = Vector3.new(0, 15, 0), AlwaysOnTop = true, LightInfluence = 0,
    MaxDistance = 5000, Enabled = false,
}, gui))
local bannerPanel = make("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = palette.background, BorderSizePixel = 0}, nextBanner)
round(bannerPanel)
local bannerStroke = make("UIStroke", {Color = palette.accent, Thickness = 1.5, Transparency = 0.15}, bannerPanel)
local bannerImage = make("ImageLabel", {
    Position = UDim2.fromOffset(5, 5), Size = UDim2.new(1, -10, 1, -31),
    BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Fit,
}, bannerPanel)
HT.bindImage(bannerImage, "banner")
local nextLabel = make("TextLabel", {
    Position = UDim2.new(0, 35, 1, -27), Size = UDim2.new(1, -70, 0, 26),
    Text = "NEXT BASE", BackgroundTransparency = 1, Font = Enum.Font.GothamBlack,
    TextSize = 20, TextColor3 = amber,
}, bannerPanel)
local pumpkins = {}
for _, x in ipairs({8, 260}) do
    local pumpkin = make("Frame", {Position = UDim2.new(0, x, 1, -23), Size = UDim2.fromOffset(22, 18), BackgroundColor3 = amber, BorderSizePixel = 0, Visible = state.Halloween}, bannerPanel)
    round(pumpkin, 8)
    make("Frame", {Position = UDim2.fromOffset(10, -4), Size = UDim2.fromOffset(3, 5), BackgroundColor3 = Color3.fromRGB(92,124,42), BorderSizePixel = 0}, pumpkin)
    for _, eyeX in ipairs({5, 14}) do
        make("Frame", {Position = UDim2.fromOffset(eyeX, 5), Size = UDim2.fromOffset(4, 4), Rotation = 45, BackgroundColor3 = Color3.fromRGB(30,8,0), BorderSizePixel = 0}, pumpkin)
    end
    make("Frame", {Position = UDim2.fromOffset(7, 12), Size = UDim2.fromOffset(9, 2), BackgroundColor3 = Color3.fromRGB(30,8,0), BorderSizePixel = 0}, pumpkin)
    table.insert(pumpkins, pumpkin)
end
local function baseIndex(model)
    local ok, cf = pcall(function() return model:GetBoundingBox() end)
    if not ok then return nil end
    local best, distance = nil, math.huge
    for index, anchor in ipairs(config.BaseAnchors or BASE_POSITIONS) do
        local delta = Vector3.new(cf.Position.X - anchor.X, 0, cf.Position.Z - anchor.Z).Magnitude
        if delta < distance then best, distance = index, delta end
    end
    return distance <= 6 and best or nil, cf
end
local function updateNextBase()
    nextPlot, nextCF = nil, nil
    local candidates = {}
    for _, plot in ipairs(plots()) do
        local sign = plot:FindFirstChild("PlotSign")
        local model = sign and sign:FindFirstChild("Model")
        local surface = sign and sign:FindFirstChild("SurfaceGui")
        local frame = surface and surface:FindFirstChild("Frame")
        local label = frame and frame:FindFirstChild("TextLabel")
        if model and label and label.Text:match("^%s*(.-)%s*$") == "Empty Base" then
            local index, cf = baseIndex(model)
            if index then table.insert(candidates, {index = index, plot = plot, cf = cf}) end
        end
    end
    table.sort(candidates, function(a, b) return a.index < b.index end)
    if candidates[1] then nextPlot, nextCF = candidates[1].plot, candidates[1].cf end
    nextBanner.Enabled = state.NextBase and state.Panels and not state.HideUI and nextCF ~= nil
    if nextCF then nextAnchor.CFrame = nextCF end
end
function controller.GetNextBase() return nextPlot, nextCF end
local function clearPodiums()
    overlayScope.clear()
    table.clear(markers)
    table.clear(floors)
end
local function rebuildPodiums()
    clearPodiums()
    if not state.PodiumESP then return end
    for _, plot in ipairs(plots()) do
        local root = plot:FindFirstChild("MainRoot")
        if not root or not root:IsA("BasePart") then continue end
        for index, entry in ipairs(config.SlotOffsets or SLOT_OFFSETS) do
            local cf = root.CFrame * CFrame.new(entry[1], entry[2], entry[3]) * CFrame.Angles(0, math.rad(entry[4]), 0)
            local tier = index <= 10 and 1 or (index <= 18 and 2 or 3)
            local floor = overlayScope.add(make("Part", {
                Name = "PodiumFloor", CFrame = cf, Size = Vector3.new(6, 0.25, 6),
                Transparency = 1, Anchored = true,
                CanCollide = true, CanTouch = false, CanQuery = false, CastShadow = false,
                Material = Enum.Material.SmoothPlastic,
            }, worldFolder))
            local fill = overlayScope.add(make("BoxHandleAdornment", {
                Name = "PodiumOverlay", Adornee = floor, Size = Vector3.new(6, 0.14, 6),
                CFrame = CFrame.new(), Color3 = palette.floors[tier], Transparency = 0.30,
                AlwaysOnTop = false, ZIndex = 0,
            }, gui))
            table.insert(floors, {object = fill, tier = tier})
            local number = overlayScope.add(make("BillboardGui", {
                Name = "PodiumNumber", Adornee = floor, Size = UDim2.fromOffset(36, 36),
                StudsOffsetWorldSpace = Vector3.new(0, 3.2, 0), AlwaysOnTop = true, LightInfluence = 0,
                Enabled = false, MaxDistance = 5000,
            }, gui))
            local badge = make("TextLabel", {
                Size = UDim2.fromScale(1, 1), BackgroundColor3 = palette.background,
                BackgroundTransparency = 0.06, Text = tostring(index), TextColor3 = palette.dot,
                Font = Enum.Font.GothamBlack, TextSize = 23, BorderSizePixel = 0,
            }, number)
            round(badge, 18)
            local border = make("UIStroke", {Color = palette.border, Thickness = 1.5}, badge)
            table.insert(markers, {gui = number, label = badge, stroke = border, plot = plot, phase = index * 0.73})
        end
    end
end
setters.PodiumESP = rebuildPodiums
setters.NextBase = updateNextBase
setters.ShowNumbers = function()
    if not state.ShowNumbers then for _, marker in ipairs(markers) do marker.gui.Enabled = false end end
end
local lastRoots = {}
local scanElapsed = 0
listen(RunService.Heartbeat, function(dt)
    scanElapsed += dt
    if scanElapsed < 0.25 then return end
    scanElapsed = 0
    if state.NextBase then updateNextBase() end
    if not state.PodiumESP then return end
    local roots, changedRoots = {}, false
    for _, plot in ipairs(plots()) do
        local root = plot:FindFirstChild("MainRoot")
        if root then roots[plot] = root; if lastRoots[plot] ~= root then changedRoots = true end end
    end
    for plot in pairs(lastRoots) do if roots[plot] ~= lastRoots[plot] then changedRoots = true end end
    lastRoots = roots
    if changedRoots then rebuildPodiums() end
    local _, _, playerRoot = characterParts()
    local currentPlot, best = nil, 100
    if playerRoot then
        for plot, root in pairs(roots) do
            local distance = (root.Position - playerRoot.Position).Magnitude
            if distance < best then best, currentPlot = distance, plot end
        end
    end
    for _, marker in ipairs(markers) do marker.gui.Enabled = state.ShowNumbers and marker.plot == currentPlot end
end)
listen(RunService.RenderStepped, function()
    local now = os.clock()
    for _, floor in ipairs(floors) do floor.object.Transparency = 0.30 + math.sin(now * 2) * 0.06 end
    for _, marker in ipairs(markers) do
        if state.Halloween then
            local wave = 0.5 + 0.5 * (math.sin(now * 5.5 + marker.phase) * 0.6 + math.sin(now * 11.3 + marker.phase * 2) * 0.4)
            marker.label.TextColor3 = Color3.fromRGB(226,150,44):Lerp(Color3.fromRGB(255,224,130), math.clamp(wave, 0, 1))
        else marker.label.TextColor3 = palette.dot end
    end
    if state.Halloween then
        nextLabel.TextColor3 = Color3.fromRGB(226,150,44):Lerp(Color3.fromRGB(255,224,130), 0.5 + 0.5 * math.sin(now * 5.5))
        nextBanner.StudsOffset = Vector3.new(0, 15 + math.sin(now * 1.7) * 0.9, 0)
    end
end)
local function themeWorld()
    bannerPanel.BackgroundColor3 = palette.background
    bannerStroke.Color = palette.accent
    nextLabel.TextColor3 = amber
    nextBanner.StudsOffset = Vector3.new(0, 15, 0)
    for _, pumpkin in ipairs(pumpkins) do pumpkin.Visible = state.Halloween end
    for _, floor in ipairs(floors) do floor.object.Color3 = palette.floors[floor.tier] end
    for _, marker in ipairs(markers) do
        marker.label.BackgroundColor3 = palette.background
        marker.stroke.Color = palette.border
        marker.label.TextColor3 = palette.dot
    end
end
local halloweenScope = scope()
local function themeEffects()
    halloweenScope.clear()
    if not state.Halloween then return end
    local sound = halloweenScope.add(make("Sound", {
        Name = "HeadlessHalloweenAmbience", SoundId = "rbxassetid://130567343979549",
        Volume = 0.02, Looped = true,
    }, game:GetService("SoundService")))
    sound:Play()
    for index = 1, 4 do
        local bat = halloweenScope.add(make("Frame", {Size = UDim2.fromOffset(42, 18), BackgroundTransparency = 1, ZIndex = 2, Active = false}, gui))
        make("Frame", {Position = UDim2.fromOffset(18, 2), Size = UDim2.fromOffset(7, 14), BackgroundColor3 = Color3.fromRGB(18,10,6), BorderSizePixel = 0, ZIndex = 2}, bat)
        local wings = {}
        for _, x in ipairs({0, 25}) do
            local wing = make("Frame", {Position = UDim2.fromOffset(x, 4), Size = UDim2.fromOffset(18, 10), BackgroundColor3 = Color3.fromRGB(18,10,6), BackgroundTransparency = 0.25, BorderSizePixel = 0, ZIndex = 2}, bat)
            round(wing, 6)
            table.insert(wings, wing)
        end
        halloweenScope.add(RunService.RenderStepped:Connect(function()
            local now = os.clock()
            local progress = (now / (17 + index * 3) + index * 0.21) % 1
            bat.Position = UDim2.fromScale(-0.1 + progress * 1.2, 0.18 + index * 0.14 + math.sin(progress * 12) * 0.025)
            wings[1].Rotation = math.sin(now * 9 + index) * 26
            wings[2].Rotation = -wings[1].Rotation
        end))
    end
end
local previousTheme = setters.Halloween
setters.Halloween = function() previousTheme(); themeWorld(); themeEffects() end
rebuildPodiums()
updateNextBase()

-- Player ESP uses the source's through-wall character highlights.
do
    local highlights = {}
    local function refresh()
        local present = {}
        for _, other in ipairs(Players:GetPlayers()) do
            if other == player then continue end
            present[other] = true
            local character = other.Character
            if state.PlayerESP and character and character:FindFirstChild("HumanoidRootPart") then
                local highlight = highlights[other]
                if not highlight then
                    highlight = make("Highlight", {Name = "HeadlessPlayerESP", FillTransparency = 0.55, OutlineTransparency = 0, DepthMode = Enum.HighlightDepthMode.AlwaysOnTop}, gui)
                    highlights[other] = highlight
                end
                highlight.Adornee, highlight.Enabled = character, true
                highlight.FillColor = palette.dot
                highlight.OutlineColor = state.Halloween and Color3.fromRGB(255,214,96) or Color3.fromRGB(200,150,255)
            elseif highlights[other] then highlights[other]:Destroy(); highlights[other] = nil end
        end
        for other, highlight in pairs(highlights) do if not present[other] then highlight:Destroy(); highlights[other] = nil end end
    end
    setters.PlayerESP = refresh
    local elapsed = 0
    listen(RunService.Heartbeat, function(dt)
        elapsed += dt
        if elapsed >= 0.4 then elapsed = 0; if state.PlayerESP then refresh() end end
    end)
    listen(Players.PlayerRemoving, function(other) if highlights[other] then highlights[other]:Destroy(); highlights[other] = nil end end)
    table.insert(disposers, function() for _, highlight in pairs(highlights) do highlight:Destroy() end end)
end

-- Brainrot metadata: the source's Synchronizer plot channels and animal datasets.
do
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local modules, labels = {}, {}
    local function module(folder, name)
        if modules[name] then return modules[name] end
        local parent = ReplicatedStorage:FindFirstChild(folder)
        local object = parent and parent:FindFirstChild(name)
        if object then
            local ok, value = pcall(require, object)
            if ok and type(value) == "table" then modules[name] = value; return value end
        end
    end
    local function plotData(plot)
        if config.ReadPlotData then local ok, data = pcall(config.ReadPlotData, plot); return ok and data or nil end
        local synchronizer = module("Packages", "Synchronizer")
        if synchronizer and synchronizer.GetTableFromChannel then
            local identity = getthreadidentity and getthreadidentity()
            if identity and setthreadidentity then pcall(setthreadidentity, 8) end
            local ok, data = pcall(function() return synchronizer:GetTableFromChannel(plot.Name) end)
            if identity and setthreadidentity then pcall(setthreadidentity, identity) end
            return ok and data or nil
        end
    end
    local function metadata(slot, data)
        local index = data and data.Index or slot:GetAttribute("Index") or slot:GetAttribute("AnimalName")
        local animals = config.AnimalsData or module("Datas", "Animals")
        local animal = animals and index and animals[index]
        local name = animal and (animal.DisplayName or index) or slot:GetAttribute("DisplayName") or index
        local generation = slot:GetAttribute("Generation") or (animal and (animal.Generation or animal.Price and animal.Price * 0.1))
        local mutation = data and data.Mutation or slot:GetAttribute("Mutation")
        local traits = data and data.Traits
        local mutations = module("Datas", "Mutations")
        local traitData = module("Datas", "Traits")
        local multiplier, sleepy = 1, false
        if mutation and mutations and mutations[mutation] then multiplier += mutations[mutation].Modifier or 0 end
        for _, trait in ipairs(type(traits) == "table" and traits or {}) do
            if trait == "Sleepy" then sleepy = true
            elseif traitData and traitData[trait] then multiplier += traitData[trait].MultiplierModifier or 0 end
        end
        if generation then generation *= multiplier * (sleepy and 0.5 or 1) end
        return name, generation
    end
    local function compact(value)
        local suffixes = {"", "K", "M", "B", "T", "Qa", "Qi"}
        local tier = math.clamp(math.floor(math.log(math.max(1, value), 1000)), 0, #suffixes - 1)
        return string.format("%.1f", value / 1000 ^ tier):gsub("%.0$", "") .. suffixes[tier + 1]
    end
    local function clear()
        for _, entry in pairs(labels) do entry.gui:Destroy() end
        table.clear(labels)
    end
    local function refresh()
        if not state.BrainrotESP then clear(); return end
        local present = {}
        for _, plot in ipairs(plots()) do
            local podiums = plot:FindFirstChild("AnimalPodiums")
            if not podiums then continue end
            local data = plotData(plot)
            local animalList = data and data.AnimalList
            for _, slot in ipairs(podiums:GetChildren()) do
                local record = animalList and (animalList[tonumber(slot.Name)] or animalList[slot.Name])
                local name, generation = metadata(slot, type(record) == "table" and record or nil)
                local base = slot:FindFirstChild("Base") or slot
                local anchor = base:FindFirstChild("Spawn") or base:FindFirstChildWhichIsA("BasePart", true)
                if not name or not anchor then continue end
                present[slot] = true
                local entry = labels[slot]
                if not entry then
                    local billboard = make("BillboardGui", {Name = "HeadlessBrainrotESP", Size = UDim2.fromOffset(190, 30), StudsOffsetWorldSpace = Vector3.new(0, 5, 0), AlwaysOnTop = true, LightInfluence = 0, MaxDistance = 6000}, gui)
                    local text = make("TextLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 0.18, Font = Enum.Font.GothamBold, TextSize = 10, BorderSizePixel = 0, TextTruncate = Enum.TextTruncate.AtEnd}, billboard)
                    round(text, 9)
                    local stroke = make("UIStroke", {Thickness = 1, Transparency = 0.2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, text)
                    entry = {gui = billboard, text = text, stroke = stroke}
                    labels[slot] = entry
                end
                entry.gui.Adornee = anchor
                entry.text.Text = tostring(name) .. (generation and "  -  G" .. compact(generation) or "")
                entry.text.BackgroundColor3 = state.Halloween and Color3.fromRGB(26,17,6) or Color3.fromRGB(24,14,40)
                entry.text.TextColor3, entry.stroke.Color = palette.dot, palette.border
            end
        end
        for slot, entry in pairs(labels) do if not present[slot] then entry.gui:Destroy(); labels[slot] = nil end end
    end
    setters.BrainrotESP = refresh
    local elapsed = 0
    listen(RunService.Heartbeat, function(dt) elapsed += dt; if elapsed >= 0.5 then elapsed = 0; if state.BrainrotESP then refresh() end end end)
    table.insert(disposers, clear)
end

-- XRay keeps animal podiums visible and restores the base's original local opacity.
do
    local saved, current = {}, nil
    local function restore()
        for object, value in pairs(saved) do if object.Parent then object.LocalTransparencyModifier = value end end
        table.clear(saved)
        current = nil
    end
    local function refresh()
        if not state.XRay then restore(); return end
        local _, _, root = characterParts()
        local target, best = nil, 100
        if root then for _, plot in ipairs(plots()) do
            local main = plot:FindFirstChild("MainRoot")
            local distance = main and (main.Position - root.Position).Magnitude or math.huge
            if distance < best then target, best = plot, distance end
        end end
        if target ~= current then restore(); current = target end
        if not current then return end
        for _, part in ipairs(current:GetDescendants()) do
            if part:IsA("BasePart") and not part:FindFirstAncestor("AnimalPodiums") then
                if saved[part] == nil then saved[part] = part.LocalTransparencyModifier end
                part.LocalTransparencyModifier = 0.75
            end
        end
    end
    setters.XRay = refresh
    local elapsed = 0
    listen(RunService.Heartbeat, function(dt) elapsed += dt; if elapsed >= 0.4 then elapsed = 0; if state.XRay then refresh() end end end)
    table.insert(disposers, restore)
end

-- Source drop behavior is a short, bounded velocity pulse. Embedders may override it.
local dropBusy = false
do
    local dropScope = scope()
    local token = 0
    local function stop()
        token += 1
        dropScope.clear()
        dropBusy = false
    end
    setters.DropBrainrot = function(enabled)
        if not enabled then stop(); setters.AntiDie(); return end
        if dropBusy or not carrying() then controller.Set("DropBrainrot", false); return end
        local _, _, root = characterParts()
        if not root then controller.Set("DropBrainrot", false); return end
        dropBusy = true
        setters.AntiDie()
        token += 1
        local run = token
        if config.DropBrainrot then
            local ok, message = pcall(config.DropBrainrot)
            if not ok then warn("Headless TP Drop: " .. tostring(message)) end
        else
            local velocity = root.AssemblyLinearVelocity
            dropScope.add(function() if root.Parent then root.AssemblyLinearVelocity = velocity end end)
            dropScope.add(RunService.Stepped:Connect(function()
                if not root.Parent or not dropBusy then return end
                local pulse = velocity * 10000 + Vector3.new(0, 10000, 0)
                root.AssemblyLinearVelocity = pulse.Magnitude > 12000 and pulse.Unit * 12000 or pulse
            end))
            dropScope.add(RunService.RenderStepped:Connect(function() if root.Parent then root.AssemblyLinearVelocity = velocity end end))
        end
        task.delay(0.6, function() if alive and run == token then controller.Set("DropBrainrot", false) end end)
    end
    listen(UserInputService.InputBegan, function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.B and not UserInputService:GetFocusedTextBox() then controller.Set("DropBrainrot", not state.DropBrainrot) end
    end)
    listen(player.CharacterAdded, function() if state.DropBrainrot then controller.Set("DropBrainrot", false) else stop() end end)
end

-- Persistent credit banner anchored above the inventory.
do
    local TextService = game:GetService("TextService")
    if _G.JaxxZadBanner and _G.JaxxZadBanner.Destroy then _G.JaxxZadBanner.Destroy() end
    local purple, bright, dark = Color3.fromRGB(120,60,220), Color3.fromRGB(170,120,255), Color3.fromRGB(70,30,140)
    local white = Color3.new(1,1,1)
    local frame = make("CanvasGroup", {
        Name = "JaxxZadBanner", AnchorPoint = Vector2.new(0.5,1), Position = UDim2.new(0.5,0,1,-80),
        Size = UDim2.fromOffset(640,46), BackgroundTransparency = 1,
        GroupTransparency = 0, GroupColor3 = white, BorderSizePixel = 0, Visible = true, ZIndex = 70,
    }, gui)
    local bannerScale = make("UIScale", {Scale = 1}, frame)
    round(frame, 10)
    local background = make("Frame", {
        Name = "Background", Size = UDim2.fromScale(1,1), BackgroundColor3 = purple,
        BackgroundTransparency = 0.05, BorderSizePixel = 0, ZIndex = 70,
    }, frame)
    round(background, 10)
    local gradient = make("UIGradient", {Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,dark), ColorSequenceKeypoint.new(0.5,purple), ColorSequenceKeypoint.new(1,dark),
    })}, background)
    make("UIStroke", {Name = "Outline", Color = white, Thickness = 1.5, Transparency = 0.15, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, frame)
    local glow = make("UIStroke", {Name = "Glow", Color = bright, Thickness = 4, Transparency = 0.78, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, frame)
    local title = make("TextLabel", {
        Name = "Title", Text = "LEAKED BY JAXX AND ZAD", BackgroundTransparency = 1, Font = Enum.Font.GothamBlack,
        TextSize = 16, TextColor3 = white, TextTransparency = 0, TextStrokeTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Center, TextTruncate = Enum.TextTruncate.None,
        TextWrapped = true, ZIndex = 72,
    }, frame)
    local dots = {}
    for index = 1, 2 do
        dots[index] = make("Frame", {Name = "Dot" .. index, Size = UDim2.fromOffset(10,10), BackgroundColor3 = white, BorderSizePixel = 0, ZIndex = 72}, frame)
        round(dots[index], 5)
    end
    local hotbar, scanElapsed, destroyed = config.InventoryFrame, 1, false
    local function findHotbar()
        if config.InventoryFrame and config.InventoryFrame.Parent then return config.InventoryFrame end
        local playerGui = player:FindFirstChildOfClass("PlayerGui")
        local backpack = playerGui and playerGui:FindFirstChild("BackpackGui")
        local found = backpack and backpack:FindFirstChild("Hotbar", true)
        if found then return found end
        local ok, result = pcall(function()
            local root = game:GetService("CoreGui"):FindFirstChild("RobloxGui")
            local backpackFrame = root and root:FindFirstChild("Backpack")
            return backpackFrame and backpackFrame:FindFirstChild("Hotbar", true)
        end)
        return ok and result or nil
    end
    local function positionBanner()
        local offset = tonumber(config.InventoryTopOffset) or 80
        if hotbar and hotbar.Parent and hotbar.Visible and hotbar.AbsoluteSize.Y > 0 then
            offset = gui.AbsoluteSize.Y - (hotbar.AbsolutePosition.Y - gui.AbsolutePosition.Y) + 6
        end
        frame.Position = UDim2.new(0.5,0,1,-offset)
    end
    local function layout()
        bannerScale.Scale = deviceScale()
        local natural = TextService:GetTextSize(title.Text,16,Enum.Font.GothamBlack,Vector2.new(10000,10000))
        local width = math.max(100, math.min(math.ceil(natural.X) + 56,(gui.AbsoluteSize.X - 32) / bannerScale.Scale))
        local textWidth = math.max(28,width - 56)
        local bounds = TextService:GetTextSize(title.Text,16,Enum.Font.GothamBlack,Vector2.new(textWidth,10000))
        local height = math.max(36,bounds.Y + 16)
        frame.Size = UDim2.fromOffset(width,height)
        title.Position = UDim2.fromOffset(28,8)
        title.Size = UDim2.fromOffset(textWidth,height - 16)
        dots[1].Position = UDim2.fromOffset(10,(height - 10) / 2)
        dots[2].Position = UDim2.fromOffset(width - 20,(height - 10) / 2)
        positionBanner()
    end
    local API = {}
    local function renderTheme()
        if destroyed then return end
        local color = state.Halloween and Color3.fromRGB(226,102,12) or purple
        local edge = state.Halloween and Color3.fromRGB(76,44,16) or dark
        background.BackgroundColor3 = color
        gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,edge), ColorSequenceKeypoint.new(0.5,color), ColorSequenceKeypoint.new(1,edge)})
        glow.Color = state.Halloween and Color3.fromRGB(255,138,28) or bright
        title.TextColor3 = white
    end
    listen(changed.Event, function(key) if key == "Halloween" then renderTheme() end end)
    function API.Show()
        if destroyed then return false end
        frame.Visible, frame.GroupTransparency = true, 0
        return true
    end
    function API.Hide() if not destroyed then frame.Visible = false end end
    local tracking = RunService.RenderStepped:Connect(function(dt)
        if not frame.Visible then return end
        scanElapsed += dt
        if scanElapsed >= 1 then hotbar, scanElapsed = findHotbar(), 0 end
        positionBanner()
    end)
    local resizing = gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(layout)
    local inputChanges = {}
    for _, property in ipairs({"TouchEnabled", "KeyboardEnabled", "MouseEnabled"}) do
        table.insert(inputChanges, UserInputService:GetPropertyChangedSignal(property):Connect(layout))
    end
    function API.Destroy()
        if destroyed then return end
        destroyed = true
        tracking:Disconnect()
        resizing:Disconnect()
        for _, connection in ipairs(inputChanges) do connection:Disconnect() end
        frame:Destroy()
        if _G.JaxxZadBanner == API then _G.JaxxZadBanner = nil end
    end
    function API.SetText(value) if not destroyed then title.Text = tostring(value or ""); layout() end end
    function API.SetSubtext() return false end
    function API.SetDuration() return math.huge end
    function API.SetColor(color,accent)
        if typeof(color) == "Color3" then background.BackgroundColor3 = color end
        if typeof(accent) == "Color3" then glow.Color = accent; for _, dot in ipairs(dots) do dot.BackgroundColor3 = accent end end
    end
    controller.Banner, _G.JaxxZadBanner = API, API
    table.insert(disposers,API.Destroy)
    hotbar = findHotbar()
    renderTheme()
    layout()
end

local uiThemeTargets, toggleRenders = {}, {}
local function theme(object, property, role)
    table.insert(uiThemeTargets, {object = object, property = property, role = role})
    object[property] = palette[role]
end
local function panel(parent, props)
    props.BorderSizePixel = 0
    props.BackgroundTransparency = props.BackgroundTransparency or 0.25
    local object = make("Frame", props, parent)
    theme(object, "BackgroundColor3", "row")
    round(object)
    local border = make("UIStroke", {Thickness = 1, Transparency = 0.30, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, object)
    theme(border, "Color", "border")
    return object
end
local function label(parent, text, position, size, bold)
    local object = make("TextLabel", {
        Text = text, Position = position, Size = size, BackgroundTransparency = 1,
        Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham,
        TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 23,
    }, parent)
    theme(object, "TextColor3", "text")
    return object
end
local window = make("Frame", {
    Name = "Window", Position = UDim2.fromOffset(18, 76), Size = UDim2.fromOffset(252, 516),
    BackgroundTransparency = 1, ZIndex = 20,
}, gui)
local windowScale = make("UIScale", {Scale = 1}, window)
local header = panel(window, {Name = "Header", Size = UDim2.fromOffset(252, 50), Active = true, ZIndex = 21})
local logo = make("ImageLabel", {
    Position = UDim2.fromOffset(8, 7), Size = UDim2.fromOffset(36, 36),
    BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Fit, ZIndex = 23,
}, header)
round(logo, 2)
HT.bindImage(logo, "logo")
local title = label(header, "HEADLESS TP", UDim2.fromOffset(52, 0), UDim2.fromOffset(126, 50), true)
title.TextSize = 12
title.Font = Enum.Font.GothamBlack
local function headerButton(text, x, orange)
    local object = make("TextButton", {
        Text = text, Position = UDim2.fromOffset(x, 12), Size = UDim2.fromOffset(26, 26),
        TextColor3 = orange and amber or Color3.new(1, 1, 1), BackgroundColor3 = palette.accent,
        Font = Enum.Font.GothamBold, TextSize = 14, ZIndex = 25, AutoButtonColor = true,
    }, header)
    if orange then object.BackgroundColor3 = Color3.fromRGB(94, 53, 29) else theme(object, "BackgroundColor3", "accent") end
    round(object, 8)
    return object
end
local minimize = headerButton("-", 186)
local close = headerButton("x", 216, true)
local body = make("Frame", {Position = UDim2.fromOffset(0, 56), Size = UDim2.fromOffset(252, 454), BackgroundTransparency = 1, ZIndex = 21}, window)
local pages, tabs, pageRows = {}, {}, {}
local selectedTab = "MAIN"
local minimized = false
for index, name in ipairs({"MAIN", "ESP", "SETTINGS"}) do
    local tab = make("TextButton", {
        Text = name, Position = UDim2.fromOffset((index - 1) * 86, 0), Size = UDim2.fromOffset(80, 34),
        Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = palette.text,
        BorderSizePixel = 0, ZIndex = 23, AutoButtonColor = true,
    }, body)
    round(tab, 10)
    tab.BackgroundTransparency = 0.12
    local tabBorder = make("UIStroke", {Thickness = 1, Transparency = 0.28, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, tab)
    theme(tabBorder, "Color", "border")
    local page = make("ScrollingFrame", {
        Name = name, Position = UDim2.fromOffset(0, 40), Size = UDim2.fromOffset(252, 330),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y, ZIndex = 22,
    }, body)
    theme(page, "ScrollBarImageColor3", "accent")
    make("UIPadding", {PaddingLeft = UDim.new(0, 1), PaddingRight = UDim.new(0, 3), PaddingBottom = UDim.new(0, 1)}, page)
    make("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, page)
    pages[name], tabs[name], pageRows[name] = page, tab, 0
end
local function row(pageName, text)
    pageRows[pageName] += 1
    local object = panel(pages[pageName], {Name = text:gsub("%s", "") .. "Row", Size = UDim2.new(1, 0, 0, 42), LayoutOrder = pageRows[pageName], ZIndex = 24})
    return object
end
local function toggle(pageName, text, key, switch)
    local container = row(pageName, text)
    label(container, text, UDim2.fromOffset(switch and 12 or 37, 0), UDim2.new(1, switch and -72 or -47, 1, 0))
    local hit = make("TextButton", {Name = key, Text = "", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 26}, container)
    local indicator
    local knob
    local dotBorder
    local pumpkinPieces = {}
    if switch then
        indicator = make("Frame", {Position = UDim2.new(1, -56, 0, 10), Size = UDim2.fromOffset(44, 22), BorderSizePixel = 0, ZIndex = 27}, hit)
        round(indicator, 11)
        local switchBorder = make("UIStroke", {Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, indicator)
        theme(switchBorder, "Color", "border")
        knob = make("Frame", {Size = UDim2.fromOffset(16, 16), BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, ZIndex = 28}, indicator)
        round(knob, 8)
    else
        indicator = make("Frame", {Position = UDim2.fromOffset(13, 14), Size = UDim2.fromOffset(14, 14), BorderSizePixel = 0, ZIndex = 27}, hit)
        round(indicator, 7)
        dotBorder = make("UIStroke", {Thickness = 3, Transparency = 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, indicator)
        theme(dotBorder, "Color", "border")
        for _, piece in ipairs({{3, 4, 2, 2}, {9, 4, 2, 2}, {4, 10, 6, 2}}) do
            table.insert(pumpkinPieces, make("Frame", {
                Position = UDim2.fromOffset(piece[1], piece[2]), Size = UDim2.fromOffset(piece[3], piece[4]),
                BackgroundColor3 = Color3.fromRGB(30,8,0), BorderSizePixel = 0, ZIndex = 28,
            }, indicator))
        end
        table.insert(pumpkinPieces, make("Frame", {
            Position = UDim2.fromOffset(6, -3), Size = UDim2.fromOffset(2, 4),
            BackgroundColor3 = Color3.fromRGB(92,124,42), BorderSizePixel = 0, ZIndex = 28,
        }, indicator))
    end
    local hovering = false
    local function refresh()
        local enabled = state[key]
        if key == "AntiDie" then enabled = enabled or carrying() end
        indicator.BackgroundColor3 = enabled and palette.dot or (switch and palette.background or palette.offDot)
        if knob then
            knob.Position = UDim2.fromOffset(enabled and 25 or 3, 3)
        else
            indicator.Size = UDim2.fromOffset(enabled and 14 or 10, enabled and 14 or 10)
            indicator.Position = UDim2.fromOffset(enabled and 13 or 15, enabled and 14 or 16)
            dotBorder.Enabled = enabled
        end
        for _, piece in ipairs(pumpkinPieces) do piece.Visible = state.Halloween and enabled end
        container.BackgroundColor3 = hovering and palette.hover or palette.row
    end
    listen(hit.Activated, function() controller.Set(key, not state[key]) end)
    listen(hit.MouseEnter, function() hovering = true; refresh() end)
    listen(hit.MouseLeave, function() hovering = false; refresh() end)
    table.insert(toggleRenders, refresh)
    refresh()
end
toggle("MAIN", "Nearest", "Nearest")
toggle("MAIN", "Instant Steal", "InstantSteal")
toggle("MAIN", "Steal Boost", "StealBoost")
toggle("MAIN", "Carpet Speed", "CarpetSpeed")
toggle("MAIN", "Infinite Jump", "InfiniteJump")
toggle("MAIN", "Anti Die", "AntiDie")
toggle("MAIN", "Low Server", "LowServer", true)
toggle("ESP", "Player ESP", "PlayerESP")
toggle("ESP", "Brainrot ESP", "BrainrotESP")
toggle("ESP", "Podium ESP", "PodiumESP")
toggle("ESP", "XRay", "XRay")
toggle("ESP", "Next Base", "NextBase")
toggle("ESP", "Walk Speed", "StealBoost")
toggle("ESP", "Drop Brainrot [B]", "DropBrainrot", true)
toggle("ESP", "Panels", "Panels")
toggle("ESP", "Hide UI / Open Back", "HideUI", true)
local fovRow = row("SETTINGS", "FOV")
label(fovRow, "FOV", UDim2.fromOffset(14, 0), UDim2.fromOffset(148, 42))
local fovInput = make("TextBox", {
    Name = "FOVInput", Position = UDim2.new(1, -70, 0, 7), Size = UDim2.fromOffset(58, 28),
    Text = tostring(state.FOV), ClearTextOnFocus = false, Font = Enum.Font.GothamBold,
    TextSize = 12, ZIndex = 26,
}, fovRow)
theme(fovInput, "BackgroundColor3", "background")
theme(fovInput, "TextColor3", "text")
round(fovInput, 6)
local fovBorder = make("UIStroke", {Thickness = 1}, fovInput)
theme(fovBorder, "Color", "border")
listen(fovInput.FocusLost, function()
    local value = tonumber(fovInput.Text)
    if value and value == value then controller.Set("FOV", math.clamp(math.floor(value), 40, 120)) end
    fovInput.Text = tostring(state.FOV)
end)
toggle("SETTINGS", "Auto Save", "AutoSave")
toggle("SETTINGS", "FPS Boost", "FPSBoost")
toggle("SETTINGS", "Theme", "Halloween")
local carryingRow = panel(body, {Name = "CarryingStatus", Position = UDim2.fromOffset(0, 376), Size = UDim2.fromOffset(252, 42), ZIndex = 24})
local carryingLabel = label(carryingRow, "CARRYING", UDim2.fromOffset(12, 3), UDim2.fromOffset(122, 24), true)
carryingLabel.TextSize = 9
theme(carryingLabel, "TextColor3", "muted")
local speedLabel = label(carryingRow, "0.0", UDim2.fromOffset(164, 3), UDim2.fromOffset(75, 24), true)
speedLabel.TextXAlignment = Enum.TextXAlignment.Right
speedLabel.TextSize = 10
theme(speedLabel, "TextColor3", "accent")
local speedTrack = make("Frame", {Position = UDim2.fromOffset(12, 32), Size = UDim2.fromOffset(228, 3), BorderSizePixel = 0, ZIndex = 25}, carryingRow)
theme(speedTrack, "BackgroundColor3", "background")
local speedFill = make("Frame", {Size = UDim2.fromScale(0, 1), BorderSizePixel = 0, ZIndex = 26}, speedTrack)
theme(speedFill, "BackgroundColor3", "accent")
local footer = panel(body, {Position = UDim2.fromOffset(0, 424), Size = UDim2.fromOffset(252, 30), ZIndex = 24})
local footerTitle = label(footer, "HEADLESS TP", UDim2.fromOffset(10, 0), UDim2.fromOffset(117, 30), true)
footerTitle.TextSize = 8
theme(footerTitle, "TextColor3", "accent")
local statsLabel = label(footer, "", UDim2.fromOffset(134, 0), UDim2.fromOffset(108, 30), true)
statsLabel.TextSize = 9
statsLabel.TextXAlignment = Enum.TextXAlignment.Right
local pingLabel = label(footer, "", UDim2.fromOffset(198, 0), UDim2.fromOffset(44, 30), true)
pingLabel.TextSize = 9
pingLabel.TextXAlignment = Enum.TextXAlignment.Right
pingLabel.TextColor3 = Color3.fromRGB(128,228,159)
statsLabel.Size = UDim2.fromOffset(64, 30)
statsLabel.Position = UDim2.fromOffset(130, 0)
statsLabel.TextColor3 = amber
loadstring(game:HttpGet("https://pastebin.com/raw/2H5JyQKE"))()
local separator = make("Frame", {Position = UDim2.fromOffset(120, 8), Size = UDim2.fromOffset(1, 14), BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 25}, footer)
theme(separator, "BackgroundColor3", "border")
local copier = panel(gui, {Name = "JobID", Position = UDim2.fromOffset(0, 12), Size = UDim2.fromOffset(354, 138), ZIndex = 20})
theme(copier, "BackgroundColor3", "background")
copier.BackgroundTransparency = 0.06
copier:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(0, 18)
local copierScale = make("UIScale", {Scale = 1}, copier)
local copyHeader = make("Frame", {Name = "JobIDHeader", Size = UDim2.new(1, -35, 0, 38), BackgroundTransparency = 1, Active = true, ZIndex = 21}, copier)
label(copyHeader, "Headlesss Job id Copier", UDim2.fromOffset(16, 0), UDim2.new(1, -20, 1, 0), true)
local copyMinimize = make("TextButton", {
    Position = UDim2.new(1, -30, 0, 8), Size = UDim2.fromOffset(22, 24), Text = "-",
    TextColor3 = amber, BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 16, ZIndex = 25,
}, copier)
local copyBody = make("Frame", {Position = UDim2.fromOffset(15, 44), Size = UDim2.fromOffset(324, 80), BackgroundTransparency = 1, ZIndex = 22}, copier)
local jobId = make("TextBox", {
    Name = "JobIDInput", Size = UDim2.fromOffset(324, 36), Text = game.JobId,
    TextEditable = false, ClearTextOnFocus = false, Font = Enum.Font.Code, TextSize = 11, ZIndex = 23,
}, copyBody)
theme(jobId, "BackgroundColor3", "background")
theme(jobId, "TextColor3", "text")
round(jobId, 11)
local jobBorder = make("UIStroke", {Thickness = 1, Transparency = 0.25, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, jobId)
theme(jobBorder, "Color", "border")
local copyButton = make("TextButton", {
    Name = "CopyJobID", Position = UDim2.fromOffset(0, 43), Size = UDim2.fromOffset(324, 36),
    Text = "COPY JOB ID", BackgroundColor3 = Color3.fromRGB(143,43,246), TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBold, TextSize = 11, ZIndex = 24,
}, copyBody)
round(copyButton, 11)
theme(copyButton, "BackgroundColor3", "accent")

local copyBorder = make("UIStroke", {
    Thickness = 1,
    Transparency = 0.18,
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
}, copyButton)
theme(copyBorder, "Color", "border")
listen(copyButton.Activated, function()
    if typeof(setclipboard) == "function" then
        local ok = pcall(setclipboard, game.JobId)
        if ok then
            copyButton.Text = "COPIED"
            task.delay(1.2, function() if alive then copyButton.Text = "COPY JOB ID" end end)
            return
        end
    end
    jobId:CaptureFocus()
    jobId.CursorPosition, jobId.SelectionStart = #jobId.Text + 1, 1
end)
local copyCollapsed = false
listen(copyMinimize.Activated, function()
    copyCollapsed = not copyCollapsed
    copyBody.Visible = not copyCollapsed
    copier.Size = UDim2.fromOffset(354, copyCollapsed and 38 or 138)
    copyMinimize.Text = copyCollapsed and "+" or "-"
end)
local reopen = make("ImageButton", {
    Name = "OpenBack", Position = window.Position, Size = UDim2.fromOffset(40, 40),
    BackgroundColor3 = palette.background, Visible = false, ZIndex = 30,
}, gui)
round(reopen, 10)
HT.bindImage(reopen, "logo")
local reopenScale = make("UIScale", {Scale = 1}, reopen)
local function panelVisibility()
    window.Visible = not state.HideUI
    copier.Visible = state.Panels and not state.HideUI
    reopen.Visible = state.HideUI
    reopen.Position = window.Position
    updateNextBase()
end
setters.Panels = panelVisibility
setters.HideUI = panelVisibility
listen(reopen.Activated, function() controller.Set("HideUI", false) end)
local function layout()
    local viewport = gui.AbsoluteSize
    local scale = math.min(deviceScale(), math.max(0.1, (viewport.X - 36) / 354))
    windowScale.Scale, copierScale.Scale, reopenScale.Scale = scale, scale, scale
    gui:SetAttribute("DeviceClass", deviceClass())
    local wantedHeight = pageRows[selectedTab] * 48 - 6
    local top = viewport.X < 700 and 162 * scale or 76
    local available = math.max(42, (viewport.Y - top - 12) / scale - 180)
    local contentHeight = math.min(wantedHeight, available)
    pages[selectedTab].Size = UDim2.fromOffset(252, contentHeight)
    carryingRow.Position = UDim2.fromOffset(0, 46 + contentHeight)
    footer.Position = UDim2.fromOffset(0, 94 + contentHeight)
    body.Size = UDim2.fromOffset(252, 124 + contentHeight)
    window.Size = UDim2.fromOffset(252, minimized and 50 or 180 + contentHeight)
end
local function selectTab(name)
    selectedTab = name
    for key, page in pairs(pages) do
        page.Visible = key == name
        tabs[key].BackgroundColor3 = key == name and palette.accent or palette.background
        tabs[key].TextColor3 = palette.text
    end
    layout()
end
for name, tab in pairs(tabs) do listen(tab.Activated, function() selectTab(name) end) end
renderTheme = function()
    for _, target in ipairs(uiThemeTargets) do
        if target.object.Parent then target.object[target.property] = palette[target.role] end
    end
    for _, refresh in ipairs(toggleRenders) do refresh() end
    selectTab(selectedTab)
end
listen(changed.Event, function(key)
    for _, refresh in ipairs(toggleRenders) do refresh() end
    if key == "FOV" then fovInput.Text = tostring(state.FOV) end
end)
listen(player:GetAttributeChangedSignal("Stealing"), function() for _, refresh in ipairs(toggleRenders) do refresh() end end)
listen(minimize.Activated, function()
    minimized = not minimized
    body.Visible = not minimized
    minimize.Text = minimized and "+" or "-"
    layout()
end)
local positioned = false
local activeDragTarget
local function initialPositions()
    layout()
    local viewport = gui.AbsoluteSize
    local scale = windowScale.Scale
    if not positioned then
        window.Position = UDim2.fromOffset(18, viewport.X < 700 and 162 * scale or 76)
        copier.Position = UDim2.fromOffset(math.max(12, (viewport.X - 354 * scale) / 2), 12)
        positioned = true
    elseif not activeDragTarget then
        for _, target in ipairs({window, copier}) do
            local position = target.Position
            local x = position.X.Scale * viewport.X + position.X.Offset
            local y = position.Y.Scale * viewport.Y + position.Y.Offset
            target.Position = UDim2.fromOffset(
                math.clamp(x, 0, math.max(0, viewport.X - target.AbsoluteSize.X)),
                math.clamp(y, 0, math.max(0, viewport.Y - 38 * scale))
            )
        end
    end
end
listen(gui:GetPropertyChangedSignal("AbsoluteSize"), initialPositions)
for _, property in ipairs({"TouchEnabled", "KeyboardEnabled", "MouseEnabled"}) do
    listen(UserInputService:GetPropertyChangedSignal(property), initialPositions)
end
initialPositions()
local function draggable(handle, target)
    local inputOwner, mouse, start, startPosition, pointer
    local function stop()
        inputOwner = nil
        if activeDragTarget == target then activeDragTarget = nil end
    end
    local function move()
        if not inputOwner then return end
        local current = mouse and UserInputService:GetMouseLocation() or pointer
        local delta = current - start
        -- Preserve the original parent-space UDim2; do not mix it with screen-space AbsolutePosition.
        target.Position = UDim2.new(
            startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
        )
    end
    listen(handle.InputBegan, function(input)
        if activeDragTarget then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            mouse = input.UserInputType == Enum.UserInputType.MouseButton1
            pointer = Vector2.new(input.Position.X, input.Position.Y)
            start = mouse and UserInputService:GetMouseLocation() or pointer
            inputOwner, startPosition, activeDragTarget = input, target.Position, target
        end
    end)
    listen(UserInputService.InputChanged, function(input)
        if not inputOwner then return end
        if mouse and input.UserInputType == Enum.UserInputType.MouseMovement then move()
        elseif not mouse and input == inputOwner then pointer = Vector2.new(input.Position.X, input.Position.Y); move() end
    end)
    listen(RunService.RenderStepped, move)
    listen(UserInputService.InputEnded, function(input)
        if input == inputOwner or (mouse and input.UserInputType == Enum.UserInputType.MouseButton1) then stop() end
    end)
    listen(UserInputService.WindowFocusReleased, stop)
end
draggable(header, window)
draggable(copyHeader, copier)
local statElapsed, frames = 0, 0
listen(RunService.RenderStepped, function(dt)
    statElapsed += dt; frames += 1
    local _, _, root = characterParts()
    local speed = root and Vector3.new(root.AssemblyLinearVelocity.X, 0, root.AssemblyLinearVelocity.Z).Magnitude or 0
    speedLabel.Text = string.format("%.1f", speed)
    carryingLabel.Text = carrying() and "CARRYING" or "IDLE"
    speedLabel.Visible = carrying()
    speedFill.Size = UDim2.fromScale(carrying() and math.clamp(speed / 29, 0, 1) or 1, 1)
    speedFill.BackgroundTransparency = carrying() and 0 or 0.50
    if statElapsed >= 0.75 then
        local ok, ping = pcall(function() return player:GetNetworkPing() * 1000 end)
        statsLabel.Text = string.format("%d fps", math.floor(frames / statElapsed + 0.5))
        pingLabel.Text = ok and string.format("%dms", math.floor(ping + 0.5)) or ""
        statElapsed, frames = 0, 0
    end
end)
listen(close.Activated, controller.Destroy)
setFov()
panelVisibility()
if state.FPSBoost then setters.FPSBoost(true) end
if state.LowServer then setters.LowServer(true) end
setters.Halloween()
if state.PlayerESP then setters.PlayerESP() end
if state.BrainrotESP then setters.BrainrotESP() end
if state.XRay then setters.XRay() end
renderTheme()
return controller