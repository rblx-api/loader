print("leaked by weekly")

local success, err = pcall(function()
    -- ===== ORIGINAL SCRIPT BEGINS =====
    local cloneref = cloneref or function(object) return object end
    local Players           = cloneref(game:GetService("Players"))
    local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
    local RunService        = cloneref(game:GetService("RunService"))
    local UserInputService  = cloneref(game:GetService("UserInputService"))
    local HttpService       = cloneref(game:GetService("HttpService"))
    local Stats             = cloneref(game:GetService("Stats"))
    local Lighting          = cloneref(game:GetService("Lighting"))
    local Workspace         = cloneref(game:GetService("Workspace"))
    local TweenService      = cloneref(game:GetService("TweenService"))
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    if getgenv and getgenv().StopAura then pcall(getgenv().StopAura) end

    -- CONFIGURATION SYSTEM --
    local CONFIG_FILE = "instinct_code_sniper_config.json"
    local savedConfig = {
        codeSniper = true,
        autoSubmit = true,
        submitAfter = 1,
        spamRedeem = true,
        antiLag = false,
        antiRagdoll = false,
        removeAccessories = false,
        autoBuy = false,
        listenKeybind = "F",
        clearFeedKeybind = "C",
        autoCodeTyped = true,
    }
    pcall(function()
        if type(isfile) == "function" and type(readfile) == "function"
        and isfile(CONFIG_FILE) then
            local decoded = HttpService:JSONDecode(readfile(CONFIG_FILE))
            if type(decoded) == "table" then
                if type(decoded.codeSniper) == "boolean" then savedConfig.codeSniper = decoded.codeSniper end
                if type(decoded.autoSubmit) == "boolean" then savedConfig.autoSubmit = decoded.autoSubmit end
                if type(decoded.submitAfter) == "number" then savedConfig.submitAfter = math.max(1, math.min(10, math.floor(decoded.submitAfter))) end
                if type(decoded.spamRedeem) == "boolean" then savedConfig.spamRedeem = decoded.spamRedeem end
                if type(decoded.antiLag) == "boolean" then savedConfig.antiLag = decoded.antiLag end
                if type(decoded.antiRagdoll) == "boolean" then savedConfig.antiRagdoll = decoded.antiRagdoll end
                if type(decoded.removeAccessories) == "boolean" then savedConfig.removeAccessories = decoded.removeAccessories end
                if type(decoded.autoBuy) == "boolean" then savedConfig.autoBuy = decoded.autoBuy end
                if type(decoded.listenKeybind) == "string" and #decoded.listenKeybind == 1 then
                    savedConfig.listenKeybind = decoded.listenKeybind:upper()
                end
                if type(decoded.clearFeedKeybind) == "string" and #decoded.clearFeedKeybind == 1 then
                    savedConfig.clearFeedKeybind = decoded.clearFeedKeybind:upper()
                end
                if type(decoded.autoCodeTyped) == "boolean" then savedConfig.autoCodeTyped = decoded.autoCodeTyped end
            end
        end
    end)

    local function saveConfig()
        if type(writefile) ~= "function" then return end
        pcall(function()
            writefile(CONFIG_FILE, HttpService:JSONEncode({
                codeSniper = savedConfig.codeSniper,
                autoSubmit = savedConfig.autoSubmit,
                submitAfter = savedConfig.submitAfter,
                spamRedeem = savedConfig.spamRedeem,
                antiLag = savedConfig.antiLag,
                antiRagdoll = savedConfig.antiRagdoll,
                removeAccessories = savedConfig.removeAccessories,
                autoBuy = savedConfig.autoBuy,
                listenKeybind = savedConfig.listenKeybind,
                clearFeedKeybind = savedConfig.clearFeedKeybind,
                autoCodeTyped = savedConfig.autoCodeTyped,
            }))
        end)
    end

    -- STATE VARIABLES --
    local _enabled              = savedConfig.codeSniper
    local _seen                 = {}
    local _focused              = nil
    local _lastBox              = nil
    local _autoAccept           = savedConfig.autoSubmit
    local _submitAfter          = savedConfig.submitAfter
    local _capturedParts        = {}
    local _lastWatchedBox       = nil
    local _boxTextConn          = nil
    local _boxAncestryConn      = nil
    local _boxVisibilityConns   = {}
    local _spamRedeem           = savedConfig.spamRedeem
    local _lastNonBlankBoxText  = ""
    local INSTINCT_CASE_MODE    = "EXACT"
    local INSTINCT_WORD_COUNT   = 1

    local _autoCodeTypedEnabled = savedConfig.autoCodeTyped

    local _programmaticChange = false
    local _manualSubmitDebounce = nil

    local _listenKeybind = savedConfig.listenKeybind or "F"
    local _listenInputConnection = nil
    local _capturingListenKey = false
    local snipeKeyBtn = nil

    local _clearFeedKeybind = savedConfig.clearFeedKeybind or "C"
    local _clearFeedInputConnection = nil
    local _capturingClearFeedKey = false
    local clearFeedKeyBtn = nil

    local _antiLagEnabled = savedConfig.antiLag
    local _antiLagDescendantConn = nil
    local _removeAccessoriesEnabled = savedConfig.removeAccessories
    local _accessoryConnection = nil

    local _antiRagdollEnabled = savedConfig.antiRagdoll
    local _ragdollConnection = nil
    local _ragdollCooldown = 0

    -- ============================================================
    -- DZ AUTO BUY BACKEND (integrated)
    -- ============================================================
    local _autoBuyEnabled = savedConfig.autoBuy
    local _autoBuyActive = false
    local _autoBuyRange = 17
    local _autoBuyKeybind = "K"
    local _autoBuyLockedTarget = nil
    local _autoBuyBodyPos = nil
    local _autoBuyCarpetConn = nil
    local _autoBuyRingPart = nil
    local _autoBuyPurchaseRemote = nil
    local _autoBuyConveyorCache = {}
    local _autoBuyBuyLoop = nil
    local _autoBuyScanLoop = nil
    local _autoBuyRingUpdateConn = nil

    local HOVER_HEIGHT = 5
    local BUY_INTERVAL = 0.08

    local function autoBuyCreateRing()
        if _autoBuyRingPart then _autoBuyRingPart:Destroy() end
        local r = Instance.new("Part")
        r.Name = "DZAutoBuyRing"
        r.Shape = Enum.PartType.Cylinder
        r.Anchored = true
        r.CanCollide = false
        r.CanTouch = false
        r.CanQuery = false
        r.CastShadow = false
        r.Material = Enum.Material.Neon
        r.Transparency = 0.5
        r.Color = Color3.fromRGB(255, 255, 255)
        r.Size = Vector3.new(0.5, _autoBuyRange * 2, _autoBuyRange * 2)
        r.Parent = Workspace
        _autoBuyRingPart = r
    end

    local function autoBuyDestroyRing()
        if _autoBuyRingPart then _autoBuyRingPart:Destroy(); _autoBuyRingPart = nil end
    end

    local function autoBuyEquipCarpet()
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local toolName = "Flying Carpet"
        if not char:FindFirstChild(toolName) then
            local tool = player.Backpack:FindFirstChild(toolName)
            if tool then hum:EquipTool(tool) end
        end
    end

    local function autoBuyStartCarpetLock()
        if _autoBuyCarpetConn then _autoBuyCarpetConn:Disconnect() end
        _autoBuyCarpetConn = RunService.Heartbeat:Connect(function()
            if _autoBuyActive then autoBuyEquipCarpet() end
        end)
        autoBuyEquipCarpet()
    end

    local function autoBuyStopCarpetLock()
        if _autoBuyCarpetConn then _autoBuyCarpetConn:Disconnect(); _autoBuyCarpetConn = nil end
    end

    local function autoBuyEnsureBodyPos(hrp)
        if _autoBuyBodyPos and _autoBuyBodyPos.Parent == hrp then return _autoBuyBodyPos end
        if _autoBuyBodyPos then _autoBuyBodyPos:Destroy() end
        local bp = Instance.new("BodyPosition", hrp)
        bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bp.P = 20000
        bp.D = 1000
        bp.Position = hrp.Position
        _autoBuyBodyPos = bp
        return bp
    end

    local function autoBuyDestroyBodyPos()
        if _autoBuyBodyPos then _autoBuyBodyPos:Destroy(); _autoBuyBodyPos = nil end
    end

    local function autoBuyResolveRemote()
        if _autoBuyPurchaseRemote and _autoBuyPurchaseRemote.Parent then return _autoBuyPurchaseRemote end
        pcall(function()
            local net = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Net")
            if net then
                for _, v in ipairs(net:GetChildren()) do
                    local nl = (v.Name or ""):lower()
                    if nl:find("buy") or nl:find("purchase") or nl:find("acquire") then
                        _autoBuyPurchaseRemote = v; return
                    end
                end
            end
        end)
        return _autoBuyPurchaseRemote
    end

    local function autoBuyFirePurchase(prompt)
        if not prompt or not prompt.Parent or not prompt.Enabled then return end
        pcall(function()
            if fireproximityprompt then fireproximityprompt(prompt) end
        end)
        task.spawn(function()
            local remote = autoBuyResolveRemote()
            if remote then
                pcall(function()
                    if remote:IsA("RemoteFunction") then
                        remote:InvokeServer(prompt.Parent)
                    elseif remote:IsA("RemoteEvent") then
                        remote:FireServer(prompt.Parent)
                    end
                end)
            end
        end)
    end

    local function autoBuyScanConveyor()
        local results = {}
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and obj.Enabled then
                local action = (obj.ActionText or ""):lower()
                if action:find("purchase") or action:find("buy") or action:find("comprar") then
                    local part = obj.Parent
                    if not part then continue end
                    local realPart = part:IsA("Attachment") and part.Parent or part
                    if not (realPart and realPart:IsA("BasePart")) then continue end
                    local model = nil
                    local cur = realPart
                    for _ = 1, 6 do
                        if cur and cur:IsA("Model") then model = cur; break end
                        cur = cur and cur.Parent
                    end
                    local name = "Brainrot"
                    if model then
                        for _, bb in ipairs(model:GetDescendants()) do
                            if bb:IsA("BillboardGui") then
                                for _, lbl in ipairs(bb:GetDescendants()) do
                                    if lbl:IsA("TextLabel") and lbl.Text and lbl.Text ~= "" then
                                        local t = lbl.Text:gsub("<[^>]+>", ""):match("^%s*(.-)%s*$")
                                        if t and #t > 1 and not t:match("^%$") and not t:match("/s$") and not t:match("^[%d%.]+") then
                                            name = t; break
                                        end
                                    end
                                end
                            end
                        end
                    end
                    table.insert(results, {
                        prompt = obj,
                        part = realPart,
                        model = model,
                        name = name,
                    })
                end
            end
        end
        return results
    end

    local function autoBuyRefreshConveyor()
        local ok, found = pcall(autoBuyScanConveyor)
        if ok then _autoBuyConveyorCache = found end
    end

    local function autoBuyUpdate()
        if not _autoBuyActive then
            if _autoBuyLockedTarget then _autoBuyLockedTarget = nil end
            autoBuyDestroyBodyPos()
            autoBuyStopCarpetLock()
            return
        end

        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local radius = _autoBuyRange
        local best = nil
        local bestDist = math.huge
        for _, entry in ipairs(_autoBuyConveyorCache) do
            if entry.prompt and entry.prompt.Parent and entry.prompt.Enabled and entry.part and entry.part.Parent then
                local dist = (hrp.Position - entry.part.Position).Magnitude
                if dist <= radius and dist < bestDist then
                    bestDist = dist
                    best = entry
                end
            end
        end

        if best then
            if not _autoBuyLockedTarget or _autoBuyLockedTarget.prompt ~= best.prompt then
                _autoBuyLockedTarget = best
            end
            local targetPos = best.part.Position + Vector3.new(0, HOVER_HEIGHT, 0)
            local bp = autoBuyEnsureBodyPos(hrp)
            if bp then bp.Position = targetPos end
            autoBuyFirePurchase(best.prompt)
        else
            if _autoBuyLockedTarget then
                _autoBuyLockedTarget = nil
                autoBuyDestroyBodyPos()
            end
        end
    end

    local function autoBuyStart()
        if _autoBuyActive then return end
        _autoBuyActive = true
        savedConfig.autoBuy = true
        saveConfig()
        autoBuyCreateRing()
        autoBuyStartCarpetLock()
        autoBuyRefreshConveyor()
        if not _autoBuyBuyLoop then
            _autoBuyBuyLoop = task.spawn(function()
                while true do
                    task.wait(BUY_INTERVAL)
                    if _autoBuyActive then pcall(autoBuyUpdate) end
                end
            end)
        end
        if not _autoBuyScanLoop then
            _autoBuyScanLoop = task.spawn(function()
                while true do
                    task.wait(0.5)
                    if _autoBuyActive then pcall(autoBuyRefreshConveyor) end
                end
            end)
        end
        if not _autoBuyRingUpdateConn then
            _autoBuyRingUpdateConn = RunService.Heartbeat:Connect(function()
                if not _autoBuyActive then return end
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and _autoBuyRingPart then
                    _autoBuyRingPart.CFrame = hrp.CFrame * CFrame.Angles(0, 0, math.rad(90)) + Vector3.new(0, -2.5, 0)
                    local r = _autoBuyRange
                    if _autoBuyRingPart.Size.Y ~= r * 2 then
                        _autoBuyRingPart.Size = Vector3.new(0.5, r * 2, r * 2)
                    end
                end
            end)
        end
    end

    local function autoBuyStop()
        if not _autoBuyActive then return end
        _autoBuyActive = false
        savedConfig.autoBuy = false
        saveConfig()
        autoBuyDestroyRing()
        autoBuyStopCarpetLock()
        autoBuyDestroyBodyPos()
        _autoBuyLockedTarget = nil
        if _autoBuyBuyLoop then
            task.cancel(_autoBuyBuyLoop)
            _autoBuyBuyLoop = nil
        end
        if _autoBuyScanLoop then
            task.cancel(_autoBuyScanLoop)
            _autoBuyScanLoop = nil
        end
        if _autoBuyRingUpdateConn then
            _autoBuyRingUpdateConn:Disconnect()
            _autoBuyRingUpdateConn = nil
        end
    end

    local function toggleAutoBuy()
        if _autoBuyActive then
            autoBuyStop()
        else
            autoBuyStart()
        end
    end

    UserInputService.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if inp.KeyCode == Enum.KeyCode[_autoBuyKeybind] then
            toggleAutoBuy()
        end
    end)

    player.CharacterAdded:Connect(function()
        if _autoBuyActive then
            task.wait(0.5)
            if _autoBuyActive then
                autoBuyStartCarpetLock()
                autoBuyCreateRing()
            end
        end
    end)

    -- ============================================================
    -- END OF DZ AUTO BUY INTEGRATION
    -- ============================================================

    local getupvalues = (debug and debug.getupvalues) or getupvalues
    local getconns    = getconnections or (debug and debug.getconnections)
    local setupv      = (debug and debug.setupvalue) or setupvalue

    local setStatus, flashCode, appendToBox
    local clearInstinctCapture
    local _lastStatusMsg = nil

    -- ============================================================
    -- ANTI‑LAG LOGIC
    -- ============================================================
    local function processDescendant(obj)
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") then
            obj.Enabled = false
        end
        if obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        end
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
        end
        if _removeAccessoriesEnabled and (obj:IsA("Accessory") or obj:IsA("Hat")) then
            obj:Destroy()
        end
    end

    local function optimizeLighting()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9000000488
        Lighting.Brightness = 1
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or effect:IsA("DepthOfFieldEffect") then
                effect.Enabled = false
            end
        end
        for _, obj in pairs(Workspace:GetDescendants()) do
            processDescendant(obj)
        end
    end

    local function removeAllAccessories()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character then
                for _, obj in ipairs(plr.Character:GetDescendants()) do
                    if obj:IsA("Accessory") or obj:IsA("Hat") then
                        obj:Destroy()
                    end
                end
            end
        end
    end

    local function startAntiLag()
        if _antiLagEnabled then return end
        _antiLagEnabled = true
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        optimizeLighting()
        if _antiLagDescendantConn then _antiLagDescendantConn:Disconnect() end
        _antiLagDescendantConn = Workspace.DescendantAdded:Connect(processDescendant)
        if _removeAccessoriesEnabled then
            removeAllAccessories()
            if not _accessoryConnection then
                _accessoryConnection = Players.PlayerAdded:Connect(function(plr)
                    plr.CharacterAdded:Connect(function(char)
                        task.wait(0.5)
                        if _removeAccessoriesEnabled then
                            for _, obj in ipairs(char:GetDescendants()) do
                                if obj:IsA("Accessory") or obj:IsA("Hat") then
                                    obj:Destroy()
                                end
                            end
                        end
                    end)
                end)
            end
        end
    end

    local function stopAntiLag()
        _antiLagEnabled = false
        if _antiLagDescendantConn then
            _antiLagDescendantConn:Disconnect()
            _antiLagDescendantConn = nil
        end
    end

    local function startRemoveAccessories()
        if _removeAccessoriesEnabled then return end
        _removeAccessoriesEnabled = true
        removeAllAccessories()
        if not _accessoryConnection then
            _accessoryConnection = Players.PlayerAdded:Connect(function(plr)
                plr.CharacterAdded:Connect(function(char)
                    task.wait(0.5)
                    if _removeAccessoriesEnabled then
                        for _, obj in ipairs(char:GetDescendants()) do
                            if obj:IsA("Accessory") or obj:IsA("Hat") then
                                obj:Destroy()
                            end
                        end
                    end
                end)
            end)
        end
        if not _antiLagEnabled then
            if _antiLagDescendantConn then _antiLagDescendantConn:Disconnect() end
            _antiLagDescendantConn = Workspace.DescendantAdded:Connect(processDescendant)
        end
    end

    local function stopRemoveAccessories()
        _removeAccessoriesEnabled = false
        if _accessoryConnection then
            _accessoryConnection:Disconnect()
            _accessoryConnection = nil
        end
        if not _antiLagEnabled and _antiLagDescendantConn then
            _antiLagDescendantConn:Disconnect()
            _antiLagDescendantConn = nil
        end
    end

    -- ============================================================
    -- ANTI‑RAGDOLL LOGIC
    -- ============================================================
    local function forceReset()
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end

        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            root.Velocity = Vector3.zero
            root.RotVelocity = Vector3.zero
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero

            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("Motor6D") then obj.Enabled = true end
                if obj:IsA("Constraint") then obj.Enabled = true end
            end

            workspace.CurrentCamera.CameraSubject = hum

            local PM = player.PlayerScripts:FindFirstChild("PlayerModule")
            if PM then
                local CM = require(PM:FindFirstChild("ControlModule"))
                if CM then CM:Enable() end
            end

            hum.AutoRotate = true
            hum.PlatformStand = false
            hum.Sit = false
        end)
    end

    local function startAntiRagdoll()
        if _ragdollConnection then return end
        _antiRagdollEnabled = true
        _ragdollConnection = RunService.Heartbeat:Connect(function()
            if not _antiRagdollEnabled then return end
            local char = player.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then return end

            local state = hum:GetState()
            local isRagdolled = (state == Enum.HumanoidStateType.Physics or
                                 state == Enum.HumanoidStateType.Ragdoll or
                                 state == Enum.HumanoidStateType.FallingDown)

            if isRagdolled then
                local now = tick()
                if now - _ragdollCooldown > 0.15 then
                    _ragdollCooldown = now
                    forceReset()
                end
            end
        end)
    end

    local function stopAntiRagdoll()
        _antiRagdollEnabled = false
        if _ragdollConnection then
            _ragdollConnection:Disconnect()
            _ragdollConnection = nil
        end
    end

    -- ============================================================
    -- UTILITY & REDEEM LOGIC
    -- ============================================================
    local function isOurGui(instance)
        local p = instance
        for _ = 1, 10 do
            if not p then break end
            if p.Name == "InstinctCodeSniperUI" or p.Name == "SourcesHubRedeemerGui" or p.Name == "InstinctCodeSniperSettingsUI" then return true end
            p = p.Parent
        end
        return false
    end

    local function isVisibleChain(inst)
        local current = inst
        while current do
            if current:IsA("GuiObject") and not current.Visible then return false end
            if current:IsA("ScreenGui") then return current.Enabled end
            current = current.Parent
        end
        return true
    end

    local function findAllTextBoxes(pg)
        local boxes = {}
        for _, gui in ipairs(pg:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Enabled and not isOurGui(gui) then
                for _, d in ipairs(gui:GetDescendants()) do
                    if d:IsA("TextBox") and not isOurGui(d) then
                        boxes[#boxes+1] = d
                    end
                end
            end
        end
        return boxes
    end

    local function findCodeButtons(pg)
        local btns = {}
        for _, gui in ipairs(pg:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Enabled and not isOurGui(gui) then
                for _, d in ipairs(gui:GetDescendants()) do
                    if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) then
                        local n  = d.Name:lower()
                        local pn = (d.Parent and d.Parent.Name or ""):lower()
                        if (n:find("code") or n:find("redeem") or pn:find("code") or pn:find("redeem"))
                            and isVisibleChain(d) then
                            btns[#btns+1] = d
                        end
                    end
                end
            end
        end
        return btns
    end

    local function clickButton(btn)
        if not btn then return false end
        local methods = {}
        methods[#methods+1] = function() btn.MouseButton1Click:Fire() end
        methods[#methods+1] = function() btn.Activated:Fire() end
        if typeof(firesignal) == "function" then
            methods[#methods+1] = function() firesignal(btn.MouseButton1Click) end
            methods[#methods+1] = function() firesignal(btn.Activated) end
        end
        if typeof(getconns) == "function" then
            methods[#methods+1] = function()
                local ok, cs = pcall(getconns, btn.MouseButton1Click)
                if ok and type(cs) == "table" then
                    for _, c in ipairs(cs) do pcall(function() c:Fire() end) end
                end
                local ok2, cs2 = pcall(getconns, btn.Activated)
                if ok2 and type(cs2) == "table" then
                    for _, c in ipairs(cs2) do pcall(function() c:Fire() end) end
                end
            end
        end
        if typeof(fireclick) == "function" then
            methods[#methods+1] = function() fireclick(btn) end
        end
        local anyOk = false
        for _, fn in ipairs(methods) do
            local ok = pcall(fn)
            anyOk = anyOk or ok
        end
        return anyOk
    end

    local function fireBoxFocusLost(box)
        if not box then return false end
        local anyFired = false
        if typeof(firesignal) == "function" then
            local ok = pcall(firesignal, box.FocusLost, true)
            anyFired = anyFired or ok
        end
        if typeof(getconns) == "function" then
            local ok, cs = pcall(getconns, box.FocusLost)
            if ok and type(cs) == "table" then
                for _, c in ipairs(cs) do
                    local fn
                    pcall(function() fn = c.Function end)
                    if fn and typeof(getupvalues) == "function" and typeof(setupv) == "function" then
                        local uOk, ups = pcall(getupvalues, fn)
                        if uOk and type(ups) == "table" then
                            for i, v in pairs(ups) do
                                if type(v) == "boolean" and v == true then
                                    pcall(setupv, fn, i, false)
                                end
                            end
                        end
                    end
                    local fOk = pcall(function()
                        if c.Enabled ~= false then c:Fire(true) end
                    end)
                    anyFired = anyFired or fOk
                end
            end
        end
        return anyFired
    end

    -- NOTE: All spam redeem loops and auto-submit delays below use 0.05s.
    local SPAM_DELAY = 0.05
    local SUBMIT_DELAY = 0.05

    local function typeAndSubmitCode(code)
        local pg = playerGui or player:FindFirstChildOfClass("PlayerGui")
        if not pg then return false, "no PlayerGui" end

        local codesGui = pg:FindFirstChild("Codes")
        if codesGui then
            if codesGui:IsA("ScreenGui") then codesGui.Enabled = true end
            local codesFrame = codesGui:FindFirstChild("Codes") or codesGui
            if codesFrame then
                if codesFrame:IsA("GuiObject") then codesFrame.Visible = true end
                local cur = codesFrame
                while cur and cur ~= codesGui do
                    if cur:IsA("GuiObject") then cur.Visible = true end
                    cur = cur.Parent
                end

                local box = nil
                for _, d in ipairs(codesFrame:GetDescendants()) do
                    if d:IsA("TextBox") and not isOurGui(d) then
                        box = d
                        break
                    end
                end

                local submitBtn = nil
                for _, d in ipairs(codesFrame:GetDescendants()) do
                    if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) then
                        local n = d.Name:lower()
                        local txt = ""
                        pcall(function() txt = d.Text:lower() end)
                        if n:find("submit") or txt:find("submit") or n:find("redeem") or txt:find("redeem") or n:find("claim") or txt:find("confirm") or n:find("enter") then
                            submitBtn = d
                            break
                        end
                    end
                end
                if not submitBtn then
                    for _, d in ipairs(codesFrame:GetDescendants()) do
                        if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) then
                            local n = d.Name:lower()
                            if not n:find("close") and not n:find("x") and not n:find("toggle") then
                                submitBtn = d
                                break
                            end
                        end
                    end
                end

                if box then
                    pcall(function() box.Text = code end)
                    if submitBtn then
                        if _spamRedeem then
                            for i = 1, 17 do
                                clickButton(submitBtn)
                                task.wait(SPAM_DELAY)
                            end
                        else
                            clickButton(submitBtn)
                        end
                    end
                    fireBoxFocusLost(box)
                    return true, "submitted via PlayerGui.Codes"
                end
            end
        end

        local btns = findCodeButtons(pg)
        for _, btn in ipairs(btns) do
            clickButton(btn)
            task.wait(0)
        end

        local box = nil
        local deadline = tick() + 2
        while tick() < deadline do
            local allBoxes = findAllTextBoxes(pg)
            for _, d in ipairs(allBoxes) do
                if isVisibleChain(d) then
                    local n  = d.Name:lower()
                    local pn = (d.Parent and d.Parent.Name or ""):lower()
                    if n:find("code") or pn:find("code") or n:find("redeem") or pn:find("redeem") or n:find("input") or pn:find("textbox") or n:find("enter") then
                        box = d
                        break
                    end
                end
            end
            if not box then
                for _, d in ipairs(allBoxes) do
                    if isVisibleChain(d) then box = d; break end
                end
            end
            if box then break end
            task.wait()
        end

        if not box then return false, "no codebox visible" end

        pcall(function() box.Text = code end)
        local redeemBtn = nil
        local searchNames = {"submit","redeem","claim","confirm","enter","send","apply","ok","use","go","check"}
        local p = box.Parent
        for _ = 1, 8 do
            if not p then break end
            for _, d in ipairs(p:GetDescendants()) do
                if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) and d ~= box then
                    local n = d.Name:lower()
                    local txt = ""
                    pcall(function() txt = d.Text:lower() end)
                    for _, sn in ipairs(searchNames) do
                        if n:find(sn) or txt:find(sn) then
                            if isVisibleChain(d) then
                                redeemBtn = d
                                break
                            end
                        end
                    end
                    if redeemBtn then break end
                end
            end
            if redeemBtn then break end
            p = p.Parent
        end

        if redeemBtn then
            if _spamRedeem then
                for i = 1, 17 do
                    clickButton(redeemBtn)
                    task.wait(SPAM_DELAY)
                end
            else
                clickButton(redeemBtn)
            end
        end
        fireBoxFocusLost(box)

        return true, "submitted via dynamic search"
    end

    local function instinctCodeBox()
        local pg = playerGui
        local allBoxes = findAllTextBoxes(pg)
        for _, box in ipairs(allBoxes) do
            if isVisibleChain(box) then return box end
        end
        return nil
    end

    -- ============================================================
    -- STYLING & HELPER UTILITIES
    -- ============================================================
    local COLORS = {
        Window      = Color3.fromRGB(9, 9, 11),
        Row         = Color3.fromRGB(14, 14, 17),
        Control     = Color3.fromRGB(22, 22, 26),
        Log         = Color3.fromRGB(5, 5, 7),
        Gray        = Color3.fromRGB(34, 34, 40),
        Box         = Color3.fromRGB(14, 14, 18),
        Border      = Color3.fromRGB(40, 40, 46),
        White       = Color3.fromRGB(255, 255, 255),
        Text        = Color3.fromRGB(215, 215, 224),
        Dim         = Color3.fromRGB(112, 112, 122),
        Accent      = Color3.fromRGB(45, 120, 255),
        Blue        = Color3.fromRGB(45, 120, 255),
        VeryLightBlue = Color3.fromRGB(215, 238, 255),
        LightBlue   = Color3.fromRGB(185, 220, 255),
        Green       = Color3.fromRGB(90, 190, 120),
        Red         = Color3.fromRGB(210, 90, 90),
        Purple      = Color3.fromRGB(45, 120, 255),
    }

    local function addCorner(parent, radius)
        local value = Instance.new("UICorner")
        value.CornerRadius = UDim.new(0, radius)
        value.Parent = parent
        return value
    end

    local function addStroke(parent, color, thickness, transparency)
        local value = Instance.new("UIStroke")
        value.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        value.Color = color
        value.Thickness = thickness or 1
        value.Transparency = transparency or 0
        value.Parent = parent
        return value
    end

    local function makeLabel(parent, name, text, size, position, textSize, color, font)
        local label = Instance.new("TextLabel")
        label.Name = name
        label.Size = size
        label.Position = position
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextSize = textSize
        label.TextColor3 = color
        label.Font = font or Enum.Font.GothamMedium
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.Parent = parent
        return label
    end

    local function applyToggleStyle(btn, stroke, state)
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and COLORS.Blue or COLORS.Control
        btn.TextColor3 = state and COLORS.White or COLORS.Dim
        if stroke then
            stroke.Transparency = state and 0.35 or 0.85
        end
    end

    local function setClipboardSafe(text)
        if not text or text == "" then return end
        if setclipboard then
            pcall(function() setclipboard(text) end)
        elseif toclipboard then
            pcall(function() toclipboard(text) end)
        end
    end

    -- CLEANUP OLD GUIS
    pcall(function()
        for _, name in ipairs({"InstinctCodeSniperUI", "InstinctCodeSniperSettingsUI", "AutoTypeCodesUI", "ACEPaste"}) do
            local previous = game.CoreGui:FindFirstChild(name)
            if previous then previous:Destroy() end
        end
    end)
    for _, name in ipairs({"InstinctCodeSniperUI", "InstinctCodeSniperSettingsUI", "AutoTypeCodesUI", "ACEPaste"}) do
        local previous = playerGui:FindFirstChild(name)
        if previous then previous:Destroy() end
    end

    -- ============================================================
    -- MAIN GUI CREATION
    -- ============================================================
    local FULL_HEIGHT = 460
    local HEADER_HEIGHT = 42

    local GUI = Instance.new("ScreenGui")
    GUI.Name = "InstinctCodeSniperUI"
    GUI.ResetOnSpawn = false
    GUI.IgnoreGuiInset = true
    GUI.DisplayOrder = 999
    if not pcall(function() GUI.Parent = game.CoreGui end) then GUI.Parent = playerGui end

    local Window = Instance.new("Frame")
    Window.Name = "Window"
    Window.Size = UDim2.fromOffset(280, FULL_HEIGHT)
    Window.AnchorPoint = Vector2.new(1, 0)
    Window.Position = UDim2.new(1, -8, 0, 8)
    Window.BackgroundColor3 = COLORS.Window
    Window.BackgroundTransparency = 0
    Window.BorderSizePixel = 0
    Window.ClipsDescendants = true
    Window.Parent = GUI
    addCorner(Window, 12)
    addStroke(Window, COLORS.Border, 1, 0.35)

    local InterfaceScale = Instance.new("UIScale")
    InterfaceScale.Name = "InterfaceScale"
    InterfaceScale.Scale = 0.92
    InterfaceScale.Parent = Window

    local viewportConnection
    local function updateInterfaceScale()
        local camera = workspace.CurrentCamera
        if not camera then InterfaceScale.Scale = 0.92; return end
        local viewport = camera.ViewportSize
        local fitScale = math.min((viewport.X - 16) / 280, (viewport.Y - 16) / FULL_HEIGHT)
        if UserInputService.TouchEnabled then
            local mobileTarget = 0.72
            InterfaceScale.Scale = math.max(0.45, math.min(mobileTarget, fitScale))
        else
            InterfaceScale.Scale = 0.92
        end
    end

    local function watchViewport()
        if viewportConnection then viewportConnection:Disconnect(); viewportConnection = nil end
        local camera = workspace.CurrentCamera
        if camera then viewportConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateInterfaceScale) end
        updateInterfaceScale()
    end
    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(watchViewport)
    watchViewport()

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, HEADER_HEIGHT)
    Header.BackgroundTransparency = 1
    Header.Active = true
    Header.ZIndex = 3
    Header.Parent = Window

    local Title = makeLabel(Header, "Title", "INSTINCTS AUTO-CODE", UDim2.fromOffset(200, 30), UDim2.fromOffset(10, 6), 17, COLORS.White, Enum.Font.GothamBold)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 4

    local GearButton = Instance.new("TextButton")
    GearButton.Name = "GearButton"
    GearButton.Size = UDim2.fromOffset(26, 26)
    GearButton.Position = UDim2.new(1, -66, 0, 8)
    GearButton.BackgroundTransparency = 1
    GearButton.Text = "⚙️"
    GearButton.TextSize = 22
    GearButton.TextColor3 = COLORS.White
    GearButton.Font = Enum.Font.GothamBold
    GearButton.ZIndex = 5
    GearButton.Parent = Header

    local MinusButton = Instance.new("TextButton")
    MinusButton.Name = "MinusButton"
    MinusButton.Size = UDim2.fromOffset(20, 20)
    MinusButton.Position = UDim2.new(1, -32, 0, 12)
    MinusButton.BackgroundColor3 = COLORS.Control
    MinusButton.BorderSizePixel = 0
    MinusButton.AutoButtonColor = false
    MinusButton.Text = "—"
    MinusButton.TextSize = 14
    MinusButton.TextColor3 = COLORS.White
    MinusButton.Font = Enum.Font.GothamBold
    MinusButton.ZIndex = 5
    MinusButton.Parent = Header
    addCorner(MinusButton, 4)
    addStroke(MinusButton, COLORS.Border, 1, 0.4)

    local function updateStatusDot() end

    local _minimized = false
    local function setMinimized(state)
        _minimized = state
        Window.Size = UDim2.fromOffset(280, state and HEADER_HEIGHT or FULL_HEIGHT)
    end
    MinusButton.Activated:Connect(function()
        setMinimized(not _minimized)
    end)

    -- ============================================================
    -- CODE BOX SECTION
    -- ============================================================
    local Console, ConsoleOutput, AnswerScroll, updateConsoleCanvas
    local CONSOLE_COLORS = {
        Dim = "rgb(124,127,135)",
        Amber = "rgb(200,200,200)",
        Green = "rgb(105,190,132)",
        Red = "rgb(150,150,150)",
        Cyan = "rgb(180,180,180)",
    }

    local function scrollConsoleToBottom()
        task.defer(function()
            task.wait()
            if not AnswerScroll then return end
            if updateConsoleCanvas then updateConsoleCanvas() end
            local bottom = math.max(0, AnswerScroll.AbsoluteCanvasSize.Y - AnswerScroll.AbsoluteWindowSize.Y)
            AnswerScroll.CanvasPosition = Vector2.new(0, bottom)
        end)
    end

    Console = Instance.new("Frame")
    Console.Name = "Console"
    Console.Size = UDim2.new(1, -20, 0, 142)
    Console.Position = UDim2.fromOffset(10, 46)
    Console.BackgroundColor3 = COLORS.Gray
    Console.BackgroundTransparency = 0
    Console.BorderSizePixel = 0
    Console.ClipsDescendants = true
    Console.ZIndex = 3
    Console.Parent = Window
    addCorner(Console, 8)
    addStroke(Console, COLORS.Border, 1, 0.25)

    local SniperFeedLabel = makeLabel(Console, "SniperFeedLabel", "Sniper Feed", UDim2.new(1, -16, 0, 18), UDim2.fromOffset(8, 6), 14, COLORS.VeryLightBlue, Enum.Font.GothamBold)
    SniperFeedLabel.ZIndex = 4

    local EzSnipingLabel = makeLabel(Console, "EzSnipingLabel", "Ez sniping", UDim2.new(1, -16, 0, 14), UDim2.fromOffset(8, 24), 11, COLORS.Dim, Enum.Font.GothamMedium)
    EzSnipingLabel.ZIndex = 4

    local AnswerBox = Instance.new("Frame")
    AnswerBox.Name = "AnswerBox"
    AnswerBox.Size = UDim2.new(1, -16, 0, 92)
    AnswerBox.Position = UDim2.fromOffset(8, 44)
    AnswerBox.BackgroundColor3 = COLORS.Log
    AnswerBox.BackgroundTransparency = 0
    AnswerBox.BorderSizePixel = 0
    AnswerBox.ClipsDescendants = true
    AnswerBox.ZIndex = 4
    AnswerBox.Parent = Console
    addCorner(AnswerBox, 6)
    addStroke(AnswerBox, COLORS.Border, 1, 0.4)

    local AnswerTitle = makeLabel(AnswerBox, "AnswerTitle", "Answer", UDim2.new(1, -12, 0, 16), UDim2.fromOffset(6, 2), 12, COLORS.Green, Enum.Font.GothamBold)
    AnswerTitle.ZIndex = 5

    local AnswerDivider = Instance.new("Frame")
    AnswerDivider.Name = "AnswerDivider"
    AnswerDivider.Size = UDim2.new(1, -12, 0, 1)
    AnswerDivider.Position = UDim2.fromOffset(6, 20)
    AnswerDivider.BackgroundColor3 = COLORS.Border
    AnswerDivider.BorderSizePixel = 0
    AnswerDivider.ZIndex = 5
    AnswerDivider.Parent = AnswerBox

    AnswerScroll = Instance.new("ScrollingFrame")
    AnswerScroll.Name = "AnswerScroll"
    AnswerScroll.Size = UDim2.new(1, -12, 0, 66)
    AnswerScroll.Position = UDim2.fromOffset(6, 24)
    AnswerScroll.BackgroundTransparency = 1
    AnswerScroll.BorderSizePixel = 0
    AnswerScroll.ClipsDescendants = true
    AnswerScroll.Active = true
    AnswerScroll.ScrollingEnabled = true
    AnswerScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    AnswerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    AnswerScroll.AutomaticCanvasSize = Enum.AutomaticSize.None
    AnswerScroll.ScrollBarThickness = 3
    AnswerScroll.ScrollBarImageColor3 = COLORS.Dim
    AnswerScroll.ZIndex = 5
    AnswerScroll.Parent = AnswerBox

    ConsoleOutput = Instance.new("TextLabel")
    ConsoleOutput.Name = "ConsoleOutput"
    ConsoleOutput.Size = UDim2.new(1, -6, 0, 0)
    ConsoleOutput.AutomaticSize = Enum.AutomaticSize.Y
    ConsoleOutput.Position = UDim2.fromOffset(0, 0)
    ConsoleOutput.BackgroundTransparency = 1
    ConsoleOutput.RichText = true
    ConsoleOutput.Text = ""
    ConsoleOutput.TextSize = 13
    ConsoleOutput.Font = Enum.Font.GothamMedium
    ConsoleOutput.TextColor3 = COLORS.White
    ConsoleOutput.TextXAlignment = Enum.TextXAlignment.Left
    ConsoleOutput.TextYAlignment = Enum.TextYAlignment.Top
    ConsoleOutput.TextWrapped = true
    ConsoleOutput.ZIndex = 6
    ConsoleOutput.Parent = AnswerScroll

    local CONSOLE_BOTTOM_PADDING = 12
    updateConsoleCanvas = function()
        if not AnswerScroll or not ConsoleOutput then return end
        local contentHeight = ConsoleOutput.Position.Y.Offset + ConsoleOutput.AbsoluteSize.Y + CONSOLE_BOTTOM_PADDING
        AnswerScroll.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
    end
    ConsoleOutput:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateConsoleCanvas)
    task.defer(updateConsoleCanvas)

    -- ============================================================
    -- CONTROLS SECTION (boxed)
    -- ============================================================
    local ControlsTitle = makeLabel(Window, "ControlsTitle", "CONTROLS", UDim2.fromOffset(200, 14), UDim2.fromOffset(12, 196), 11, COLORS.Dim, Enum.Font.GothamBold)
    ControlsTitle.ZIndex = 3

    local ControlsBox = Instance.new("Frame")
    ControlsBox.Name = "ControlsBox"
    ControlsBox.Size = UDim2.new(1, -20, 0, 82)
    ControlsBox.Position = UDim2.fromOffset(10, 214)
    ControlsBox.BackgroundColor3 = COLORS.Box
    ControlsBox.BackgroundTransparency = 0
    ControlsBox.BorderSizePixel = 0
    ControlsBox.ZIndex = 2
    ControlsBox.Parent = Window
    addCorner(ControlsBox, 8)
    addStroke(ControlsBox, COLORS.Border, 1, 0.25)

    -- Row 1: Snipe with keybind F
    local snipeRow = Instance.new("Frame")
    snipeRow.Size = UDim2.new(1, -12, 0, 24)
    snipeRow.Position = UDim2.fromOffset(6, 6)
    snipeRow.BackgroundTransparency = 1
    snipeRow.ZIndex = 3
    snipeRow.Parent = ControlsBox
    makeLabel(snipeRow, "Title", "Snipe", UDim2.fromOffset(60, 24), UDim2.fromOffset(2, 0), 14, COLORS.Text, Enum.Font.GothamBold).ZIndex = 4

    snipeKeyBtn = Instance.new("TextButton")
    snipeKeyBtn.Name = "SnipeKeyBtn"
    snipeKeyBtn.Size = UDim2.fromOffset(26, 20)
    snipeKeyBtn.Position = UDim2.fromOffset(52, 2)
    snipeKeyBtn.BackgroundColor3 = COLORS.Control
    snipeKeyBtn.BorderSizePixel = 0
    snipeKeyBtn.AutoButtonColor = false
    snipeKeyBtn.Active = true
    snipeKeyBtn.Text = _listenKeybind
    snipeKeyBtn.TextSize = 11
    snipeKeyBtn.TextColor3 = COLORS.White
    snipeKeyBtn.Font = Enum.Font.GothamBold
    snipeKeyBtn.ZIndex = 5
    snipeKeyBtn.Parent = snipeRow
    addCorner(snipeKeyBtn, 4)
    addStroke(snipeKeyBtn, COLORS.Border, 1, 0.4)

    snipeKeyBtn.Activated:Connect(function()
        if _capturingListenKey then return end
        _capturingListenKey = true
        snipeKeyBtn.Text = "..."
        snipeKeyBtn.TextColor3 = COLORS.Dim
    end)

    local snipeBtn = Instance.new("TextButton")
    snipeBtn.Name = "SnipeBtn"
    snipeBtn.Size = UDim2.fromOffset(42, 20)
    snipeBtn.Position = UDim2.new(1, -48, 0.5, -10)
    snipeBtn.BackgroundColor3 = _enabled and COLORS.Blue or COLORS.Control
    snipeBtn.BorderSizePixel = 0
    snipeBtn.AutoButtonColor = false
    snipeBtn.Active = true
    snipeBtn.Text = _enabled and "ON" or "OFF"
    snipeBtn.TextSize = 11
    snipeBtn.TextColor3 = _enabled and COLORS.White or COLORS.Dim
    snipeBtn.Font = Enum.Font.GothamBold
    snipeBtn.ZIndex = 5
    snipeBtn.Parent = snipeRow
    addCorner(snipeBtn, 4)
    local snipeStroke = addStroke(snipeBtn, COLORS.White, 1, _enabled and 0.35 or 0.85)

    snipeBtn.Activated:Connect(function()
        _enabled = not _enabled
        savedConfig.codeSniper = _enabled
        saveConfig()
        applyToggleStyle(snipeBtn, snipeStroke, _enabled)
        updateStatusDot()
        if _enabled then
            ConsoleOutput.Text = ""
        else
            ConsoleOutput.Text = '<font color="' .. CONSOLE_COLORS.Red .. '">Off</font>'
        end
        task.defer(updateConsoleCanvas)
    end)

    -- Row 2: Clear Feed with keybind C
    local clearRow = Instance.new("Frame")
    clearRow.Size = UDim2.new(1, -12, 0, 24)
    clearRow.Position = UDim2.fromOffset(6, 32)
    clearRow.BackgroundTransparency = 1
    clearRow.ZIndex = 3
    clearRow.Parent = ControlsBox
    makeLabel(clearRow, "Title", "Clear Feed", UDim2.fromOffset(90, 24), UDim2.fromOffset(2, 0), 14, COLORS.Text, Enum.Font.GothamBold).ZIndex = 4

    clearFeedKeyBtn = Instance.new("TextButton")
    clearFeedKeyBtn.Name = "ClearFeedKeyBtn"
    clearFeedKeyBtn.Size = UDim2.fromOffset(26, 20)
    clearFeedKeyBtn.Position = UDim2.fromOffset(84, 2)
    clearFeedKeyBtn.BackgroundColor3 = COLORS.Control
    clearFeedKeyBtn.BorderSizePixel = 0
    clearFeedKeyBtn.AutoButtonColor = false
    clearFeedKeyBtn.Active = true
    clearFeedKeyBtn.Text = _clearFeedKeybind
    clearFeedKeyBtn.TextSize = 11
    clearFeedKeyBtn.TextColor3 = COLORS.White
    clearFeedKeyBtn.Font = Enum.Font.GothamBold
    clearFeedKeyBtn.ZIndex = 5
    clearFeedKeyBtn.Parent = clearRow
    addCorner(clearFeedKeyBtn, 4)
    addStroke(clearFeedKeyBtn, COLORS.Border, 1, 0.4)

    clearFeedKeyBtn.Activated:Connect(function()
        if _capturingClearFeedKey then return end
        _capturingClearFeedKey = true
        clearFeedKeyBtn.Text = "..."
        clearFeedKeyBtn.TextColor3 = COLORS.Dim
    end)

    local clearFeedBtn = Instance.new("TextButton")
    clearFeedBtn.Name = "ClearFeedBtn"
    clearFeedBtn.Size = UDim2.fromOffset(48, 20)
    clearFeedBtn.Position = UDim2.new(1, -54, 0.5, -10)
    clearFeedBtn.BackgroundColor3 = COLORS.Control
    clearFeedBtn.BorderSizePixel = 0
    clearFeedBtn.AutoButtonColor = false
    clearFeedBtn.Active = true
    clearFeedBtn.Text = "CLEAR"
    clearFeedBtn.TextSize = 10
    clearFeedBtn.TextColor3 = COLORS.White
    clearFeedBtn.Font = Enum.Font.GothamBold
    clearFeedBtn.ZIndex = 5
    clearFeedBtn.Parent = clearRow
    addCorner(clearFeedBtn, 4)
    addStroke(clearFeedBtn, COLORS.Border, 1, 0.4)

    local function performClearFeed()
        if _enabled then
            ConsoleOutput.Text = ""
        else
            ConsoleOutput.Text = '<font color="' .. CONSOLE_COLORS.Red .. '">Off</font>'
        end
        task.defer(updateConsoleCanvas)
        _capturedParts = {}
        local box = instinctCodeBox()
        if box then
            _programmaticChange = true
            pcall(function() box.Text = "" end)
            _programmaticChange = false
        end
    end

    clearFeedBtn.Activated:Connect(function()
        clearFeedBtn.BackgroundColor3 = COLORS.Purple
        task.delay(0.15, function()
            if clearFeedBtn and clearFeedBtn.Parent then
                clearFeedBtn.BackgroundColor3 = COLORS.Control
            end
        end)
        performClearFeed()
    end)

    -- Row 3: AutoCopy Typed code
    local autoCodeRow = Instance.new("Frame")
    autoCodeRow.Size = UDim2.new(1, -12, 0, 24)
    autoCodeRow.Position = UDim2.fromOffset(6, 58)
    autoCodeRow.BackgroundTransparency = 1
    autoCodeRow.ZIndex = 3
    autoCodeRow.Parent = ControlsBox
    makeLabel(autoCodeRow, "Title", "AutoCopy Typed code", UDim2.fromOffset(180, 24), UDim2.fromOffset(2, 0), 12, COLORS.Text, Enum.Font.GothamBold).ZIndex = 4

    local autoCodeBtn = Instance.new("TextButton")
    autoCodeBtn.Name = "AutoCodeBtn"
    autoCodeBtn.Size = UDim2.fromOffset(42, 20)
    autoCodeBtn.Position = UDim2.new(1, -48, 0.5, -10)
    autoCodeBtn.BackgroundColor3 = _autoCodeTypedEnabled and COLORS.Blue or COLORS.Control
    autoCodeBtn.BorderSizePixel = 0
    autoCodeBtn.AutoButtonColor = false
    autoCodeBtn.Active = true
    autoCodeBtn.Text = _autoCodeTypedEnabled and "ON" or "OFF"
    autoCodeBtn.TextSize = 11
    autoCodeBtn.TextColor3 = _autoCodeTypedEnabled and COLORS.White or COLORS.Dim
    autoCodeBtn.Font = Enum.Font.GothamBold
    autoCodeBtn.ZIndex = 5
    autoCodeBtn.Parent = autoCodeRow
    addCorner(autoCodeBtn, 4)
    local autoCodeStroke = addStroke(autoCodeBtn, COLORS.White, 1, _autoCodeTypedEnabled and 0.35 or 0.85)

    autoCodeBtn.Activated:Connect(function()
        _autoCodeTypedEnabled = not _autoCodeTypedEnabled
        savedConfig.autoCodeTyped = _autoCodeTypedEnabled
        saveConfig()
        applyToggleStyle(autoCodeBtn, autoCodeStroke, _autoCodeTypedEnabled)
    end)

    -- ============================================================
    -- AA HELPER SECTION (boxed)
    -- ============================================================
    local AAHelperTitle = makeLabel(Window, "AAHelperTitle", "AA HELPER", UDim2.fromOffset(200, 14), UDim2.fromOffset(12, 304), 11, COLORS.Dim, Enum.Font.GothamBold)
    AAHelperTitle.ZIndex = 3

    local AAHelperBox = Instance.new("Frame")
    AAHelperBox.Name = "AAHelperBox"
    AAHelperBox.Size = UDim2.new(1, -20, 0, 88)
    AAHelperBox.Position = UDim2.fromOffset(10, 322)
    AAHelperBox.BackgroundColor3 = COLORS.Box
    AAHelperBox.BackgroundTransparency = 0
    AAHelperBox.BorderSizePixel = 0
    AAHelperBox.ZIndex = 2
    AAHelperBox.Parent = Window
    addCorner(AAHelperBox, 8)
    addStroke(AAHelperBox, COLORS.Border, 1, 0.25)

    local function makeHelperRow(y, labelText, initialState, onToggle)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -12, 0, 24)
        row.Position = UDim2.fromOffset(6, y)
        row.BackgroundTransparency = 1
        row.ZIndex = 3
        row.Parent = AAHelperBox

        makeLabel(row, "Title", labelText, UDim2.fromOffset(160, 24), UDim2.fromOffset(2, 0), 13, COLORS.Text, Enum.Font.GothamBold).ZIndex = 4

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromOffset(42, 20)
        btn.Position = UDim2.new(1, -48, 0.5, -10)
        btn.BackgroundColor3 = initialState and COLORS.Blue or COLORS.Control
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Active = true
        btn.Text = initialState and "ON" or "OFF"
        btn.TextSize = 11
        btn.TextColor3 = initialState and COLORS.White or COLORS.Dim
        btn.Font = Enum.Font.GothamBold
        btn.ZIndex = 5
        btn.Parent = row
        addCorner(btn, 4)
        local stroke = addStroke(btn, COLORS.White, 1, initialState and 0.35 or 0.85)

        local state = initialState
        btn.Activated:Connect(function()
            state = not state
            if onToggle then onToggle(state) end
            applyToggleStyle(btn, stroke, state)
        end)
        return btn, stroke
    end

    makeHelperRow(6, "Auto Buy", _autoBuyActive, function(state)
        if state then autoBuyStart() else autoBuyStop() end
    end)

    makeHelperRow(32, "Anti Lag", _antiLagEnabled, function(state)
        if state then startAntiLag() else stopAntiLag() end
        savedConfig.antiLag = _antiLagEnabled
        saveConfig()
    end)

    makeHelperRow(58, "Anti Ragdoll", _antiRagdollEnabled, function(state)
        if state then startAntiRagdoll() else stopAntiRagdoll() end
        savedConfig.antiRagdoll = _antiRagdollEnabled
        saveConfig()
    end)

    -- ============================================================
    -- KEYBIND HANDLERS (Snipe + Clear Feed)
    -- ============================================================
    local function setupListenKeybind()
        if _listenInputConnection then
            _listenInputConnection:Disconnect()
            _listenInputConnection = nil
        end
        _listenInputConnection = UserInputService.InputBegan:Connect(function(inp, gp)
            if gp then return end
            if UserInputService:GetFocusedTextBox() then return end
            if _capturingListenKey then return end
            if inp.KeyCode == Enum.KeyCode[_listenKeybind] then
                _enabled = not _enabled
                savedConfig.codeSniper = _enabled
                saveConfig()
                applyToggleStyle(snipeBtn, snipeStroke, _enabled)
                updateStatusDot()
                if _enabled then
                    ConsoleOutput.Text = ""
                else
                    ConsoleOutput.Text = '<font color="' .. CONSOLE_COLORS.Red .. '">Off</font>'
                end
                task.defer(updateConsoleCanvas)
            end
        end)
    end

    local function setupClearFeedKeybind()
        if _clearFeedInputConnection then
            _clearFeedInputConnection:Disconnect()
            _clearFeedInputConnection = nil
        end
        _clearFeedInputConnection = UserInputService.InputBegan:Connect(function(inp, gp)
            if gp then return end
            if UserInputService:GetFocusedTextBox() then return end
            if _capturingClearFeedKey then return end
            if inp.KeyCode == Enum.KeyCode[_clearFeedKeybind] then
                performClearFeed()
            end
        end)
    end

    UserInputService.InputBegan:Connect(function(inp, gp)
        if not _capturingListenKey then return end
        if gp then return end
        if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
        local key = inp.KeyCode
        if key == Enum.KeyCode.Unknown then return end
        local keyName = key.Name
        if #keyName == 1 then
            _listenKeybind = keyName:upper()
        else
            _listenKeybind = keyName
        end
        savedConfig.listenKeybind = _listenKeybind
        saveConfig()
        if snipeKeyBtn then
            snipeKeyBtn.Text = _listenKeybind
            snipeKeyBtn.TextColor3 = COLORS.White
        end
        _capturingListenKey = false
        setupListenKeybind()
    end)

    UserInputService.InputBegan:Connect(function(inp, gp)
        if not _capturingClearFeedKey then return end
        if gp then return end
        if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
        local key = inp.KeyCode
        if key == Enum.KeyCode.Unknown then return end
        local keyName = key.Name
        if #keyName == 1 then
            _clearFeedKeybind = keyName:upper()
        else
            _clearFeedKeybind = keyName
        end
        savedConfig.clearFeedKeybind = _clearFeedKeybind
        saveConfig()
        if clearFeedKeyBtn then
            clearFeedKeyBtn.Text = _clearFeedKeybind
            clearFeedKeyBtn.TextColor3 = COLORS.White
        end
        _capturingClearFeedKey = false
        setupClearFeedKeybind()
    end)

    -- ============================================================
    -- GEAR SETTINGS POPUP GUI
    -- ============================================================
    local SettingsGUI = nil

    local function createSettingsUI()
        if SettingsGUI and SettingsGUI.Parent then
            SettingsGUI:Destroy()
            SettingsGUI = nil
            return
        end

        SettingsGUI = Instance.new("ScreenGui")
        SettingsGUI.Name = "InstinctCodeSniperSettingsUI"
        SettingsGUI.ResetOnSpawn = false
        SettingsGUI.IgnoreGuiInset = true
        SettingsGUI.DisplayOrder = 998
        if not pcall(function() SettingsGUI.Parent = game.CoreGui end) then SettingsGUI.Parent = playerGui end

        local SW = Instance.new("Frame")
        SW.Name = "SettingsWindow"
        SW.Size = UDim2.fromOffset(220, 158)
        SW.AnchorPoint = Vector2.new(0.5, 0.5)
        SW.Position = UDim2.new(0.5, 0, 0.5, 0)
        SW.BackgroundColor3 = COLORS.Window
        SW.BackgroundTransparency = 0
        SW.BorderSizePixel = 0
        SW.ClipsDescendants = true
        SW.Parent = SettingsGUI
        addCorner(SW, 12)
        addStroke(SW, COLORS.Border, 1, 0.35)

        local TitleBar = Instance.new("Frame")
        TitleBar.Name = "TitleBar"
        TitleBar.Size = UDim2.new(1, 0, 0, 30)
        TitleBar.BackgroundTransparency = 1
        TitleBar.Active = true
        TitleBar.Parent = SW

        local sTitle = makeLabel(TitleBar, "Title", "SETTINGS", UDim2.new(1, -60, 0, 30), UDim2.fromOffset(10, 0), 14, COLORS.White, Enum.Font.GothamBold)
        sTitle.ZIndex = 2

        local closeBtn = Instance.new("TextButton")
        closeBtn.Name = "CloseBtn"
        closeBtn.Size = UDim2.fromOffset(22, 22)
        closeBtn.Position = UDim2.new(1, -28, 0, 4)
        closeBtn.BackgroundTransparency = 1
        closeBtn.Text = "X"
        closeBtn.TextSize = 14
        closeBtn.TextColor3 = COLORS.Dim
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.ZIndex = 3
        closeBtn.Parent = TitleBar
        closeBtn.Activated:Connect(function() if SettingsGUI then SettingsGUI:Destroy(); SettingsGUI = nil end end)

        -- Spam redeem row
        local spamRow = Instance.new("Frame")
        spamRow.Size = UDim2.new(1, -20, 0, 24)
        spamRow.Position = UDim2.fromOffset(10, 40)
        spamRow.BackgroundTransparency = 1
        spamRow.Parent = SW
        makeLabel(spamRow, "L", "Spam Redeem", UDim2.fromOffset(140, 24), UDim2.fromOffset(6, 0), 13, COLORS.Text, Enum.Font.GothamBold)

        local spamBtn = Instance.new("TextButton")
        spamBtn.Size = UDim2.fromOffset(42, 20)
        spamBtn.Position = UDim2.new(1, -48, 0.5, -10)
        spamBtn.BackgroundColor3 = _spamRedeem and COLORS.Blue or COLORS.Control
        spamBtn.BorderSizePixel = 0
        spamBtn.AutoButtonColor = false
        spamBtn.Text = _spamRedeem and "ON" or "OFF"
        spamBtn.TextSize = 11
        spamBtn.TextColor3 = _spamRedeem and COLORS.White or COLORS.Dim
        spamBtn.Font = Enum.Font.GothamBold
        spamBtn.ZIndex = 5
        spamBtn.Parent = spamRow
        addCorner(spamBtn, 4)
        local spamStroke = addStroke(spamBtn, COLORS.White, 1, _spamRedeem and 0.35 or 0.85)

        spamBtn.Activated:Connect(function()
            _spamRedeem = not _spamRedeem
            savedConfig.spamRedeem = _spamRedeem
            saveConfig()
            applyToggleStyle(spamBtn, spamStroke, _spamRedeem)
        end)

        -- Submit after row
        local submitRow = Instance.new("Frame")
        submitRow.Size = UDim2.new(1, -20, 0, 24)
        submitRow.Position = UDim2.fromOffset(10, 68)
        submitRow.BackgroundTransparency = 1
        submitRow.Parent = SW
        makeLabel(submitRow, "L", "Submit After", UDim2.fromOffset(120, 24), UDim2.fromOffset(6, 0), 13, COLORS.Text, Enum.Font.GothamBold)

        local counterShell = Instance.new("Frame")
        counterShell.Size = UDim2.fromOffset(84, 22)
        counterShell.Position = UDim2.new(1, -92, 0.5, -11)
        counterShell.BackgroundColor3 = COLORS.Log
        counterShell.BorderSizePixel = 0
        counterShell.Parent = submitRow
        addCorner(counterShell, 4)
        addStroke(counterShell, COLORS.Border, 1, 0.5)

        local sMinus = Instance.new("TextButton")
        sMinus.Size = UDim2.fromOffset(20, 20)
        sMinus.Position = UDim2.fromOffset(1, 1)
        sMinus.BackgroundColor3 = COLORS.Control
        sMinus.BorderSizePixel = 0
        sMinus.AutoButtonColor = false
        sMinus.Text = "-"
        sMinus.TextSize = 14
        sMinus.TextColor3 = COLORS.White
        sMinus.Font = Enum.Font.GothamBold
        sMinus.Parent = counterShell
        addCorner(sMinus, 3)

        local sCount = makeLabel(counterShell, "Count", tostring(_submitAfter), UDim2.fromOffset(20, 20), UDim2.fromOffset(32, 1), 14, COLORS.White, Enum.Font.GothamBold)
        sCount.TextXAlignment = Enum.TextXAlignment.Center

        local sPlus = Instance.new("TextButton")
        sPlus.Size = UDim2.fromOffset(20, 20)
        sPlus.Position = UDim2.fromOffset(62, 1)
        sPlus.BackgroundColor3 = COLORS.Control
        sPlus.BorderSizePixel = 0
        sPlus.AutoButtonColor = false
        sPlus.Text = "+"
        sPlus.TextSize = 14
        sPlus.TextColor3 = COLORS.White
        sPlus.Font = Enum.Font.GothamBold
        sPlus.Parent = counterShell
        addCorner(sPlus, 3)

        local lastStep = 0
        local function changeSubmit(delta)
            local now = os.clock()
            if now - lastStep < 0.05 then return end
            lastStep = now
            _submitAfter = math.clamp(_submitAfter + delta, 1, 10)
            savedConfig.submitAfter = _submitAfter
            sCount.Text = tostring(_submitAfter)
            clearInstinctCapture()
            saveConfig()
        end
        sMinus.Activated:Connect(function() changeSubmit(-1) end)
        sPlus.Activated:Connect(function() changeSubmit(1) end)

        -- Leaked credit
        makeLabel(SW, "Leaked", "Leaked by weekly", UDim2.new(1, -20, 0, 16), UDim2.fromOffset(10, 100), 11, COLORS.Text, Enum.Font.GothamBold)
        makeLabel(SW, "LeakedLink", "discord.gg/hgBugxV6WV", UDim2.new(1, -20, 0, 16), UDim2.fromOffset(10, 116), 11, COLORS.LightBlue, Enum.Font.GothamBold)
        makeLabel(SW, "Ver", "v8.0", UDim2.new(1, -20, 0, 16), UDim2.fromOffset(10, 136), 10, COLORS.Dim, Enum.Font.GothamMedium)

        do
            local drag, dInput, dStart, dPos
            TitleBar.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    drag = true
                    dInput = i
                    dStart = Vector2.new(i.Position.X, i.Position.Y)
                    dPos = SW.Position
                    i.Changed:Connect(function()
                        if i.UserInputState == Enum.UserInputState.End or i.UserInputState == Enum.UserInputState.Cancel then
                            drag = false
                            dInput = nil
                        end
                    end)
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if drag and dInput then
                    if (dInput.UserInputType == Enum.UserInputType.MouseButton1 and i.UserInputType == Enum.UserInputType.MouseMovement) or
                       (dInput.UserInputType == Enum.UserInputType.Touch and i == dInput) then
                        local delta = Vector2.new(i.Position.X, i.Position.Y) - dStart
                        SW.Position = UDim2.new(dPos.X.Scale, dPos.X.Offset + delta.X, dPos.Y.Scale, dPos.Y.Offset + delta.Y)
                    end
                end
            end)
        end
    end

    GearButton.Activated:Connect(createSettingsUI)

    -- ============================================================
    -- WINDOW DRAGGING
    -- ============================================================
    do
        local dragging = false
        local activeDragInput
        local dragStart
        local startPosition
        local dragMoved = false
        local DRAG_THRESHOLD = UserInputService.TouchEnabled and 10 or 3

        local function isOverHeaderControl(position)
            local function inBox(absPos, absSize)
                return position.X >= (absPos.X - 6) and position.X <= (absPos.X + absSize.X + 6)
                    and position.Y >= (absPos.Y - 6) and position.Y <= (absPos.Y + absSize.Y + 6)
            end
            return inBox(GearButton.AbsolutePosition, GearButton.AbsoluteSize)
                or inBox(MinusButton.AbsolutePosition, MinusButton.AbsoluteSize)
        end

        local function stopDragging(input)
            if input ~= activeDragInput then return end
            dragging = false
            activeDragInput = nil
            dragStart = nil
            startPosition = nil
        end

        Header.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            if dragging or isOverHeaderControl(input.Position) then return end

            dragging = true
            activeDragInput = input
            dragStart = Vector2.new(input.Position.X, input.Position.Y)
            startPosition = Window.Position
            dragMoved = false

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End or input.UserInputState == Enum.UserInputState.Cancel then
                    stopDragging(input)
                end
            end)
        end)

        UserInputService.InputChanged:Connect(function(input)
            if not dragging or not activeDragInput then return end
            local isTrackedTouch = activeDragInput.UserInputType == Enum.UserInputType.Touch and input == activeDragInput
            local isTrackedMouse = activeDragInput.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseMovement
            if not isTrackedTouch and not isTrackedMouse then return end

            local current = Vector2.new(input.Position.X, input.Position.Y)
            local delta = current - dragStart
            if not dragMoved then
                if delta.Magnitude < DRAG_THRESHOLD then return end
                dragMoved = true
            end

            Window.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end)
    end

    -- ============================================================
    -- REST OF SCRIPT
    -- ============================================================
    local function col3ToRich(col)
        if col == COLORS.Green then return CONSOLE_COLORS.Green end
        if col == COLORS.Red then return CONSOLE_COLORS.Red end
        if col == COLORS.Text then return CONSOLE_COLORS.Amber end
        if col == COLORS.White then return CONSOLE_COLORS.Cyan end
        if col == COLORS.Dim then return CONSOLE_COLORS.Dim end
        return string.format("rgb(%d,%d,%d)", math.floor(col.R * 255 + 0.5), math.floor(col.G * 255 + 0.5), math.floor(col.B * 255 + 0.5))
    end

    function setStatus(msg, col)
        if not ConsoleOutput then return end
        col = col or COLORS.Dim
        local line = '<font color="' .. col3ToRich(col) .. '">' .. tostring(msg) .. "</font>"
        local lines = {}
        for line in ConsoleOutput.Text:gmatch("[^\n]+") do
            table.insert(lines, line)
        end
        if #lines == 0 then
            ConsoleOutput.Text = line
        else
            local newText = lines[1] .. "\n\n" .. line
            ConsoleOutput.Text = newText
        end
        scrollConsoleToBottom()
    end

    function flashCode(code, col)
        if not code or code == "" or code == "—" then return end
        setStatus("[code] -> " .. tostring(code), col or COLORS.White)
    end

    local function resetPasteCounter() _capturedParts = {} end
    clearInstinctCapture = function() _capturedParts = {} end

    local function clearBoxWatchers()
        if _boxTextConn then pcall(function() _boxTextConn:Disconnect() end) end
        if _boxAncestryConn then pcall(function() _boxAncestryConn:Disconnect() end) end
        for _, connection in ipairs(_boxVisibilityConns) do pcall(function() connection:Disconnect() end) end
        _boxTextConn = nil
        _boxAncestryConn = nil
        _boxVisibilityConns = {}
        _lastWatchedBox = nil
        if _manualSubmitDebounce then
            _manualSubmitDebounce:Disconnect()
            _manualSubmitDebounce = nil
        end
    end

    local function watchBoxForBlankReset(box)
        if not box or _lastWatchedBox == box then return end
        clearBoxWatchers()
        _lastWatchedBox = box
        if box.Text ~= "" then _lastNonBlankBoxText = box.Text end

        _boxTextConn = box:GetPropertyChangedSignal("Text"):Connect(function()
            if box.Text == "" then 
                resetPasteCounter()
                _lastNonBlankBoxText = ""
                if _manualSubmitDebounce then
                    _manualSubmitDebounce:Disconnect()
                    _manualSubmitDebounce = nil
                end
            else 
                _lastNonBlankBoxText = box.Text
                -- AutoCopy Typed code: copy anything typed in the code box
                if not _programmaticChange and box.Text ~= "" and _autoCodeTypedEnabled then
                    setClipboardSafe(box.Text)
                end
                if not _programmaticChange and _autoAccept then
                    local words = {}
                    for w in box.Text:gmatch("%S+") do
                        table.insert(words, w)
                    end
                    if #words >= _submitAfter then
                        if _manualSubmitDebounce then
                            _manualSubmitDebounce:Disconnect()
                        end
                        -- Auto submit delay 0.05s
                        _manualSubmitDebounce = task.delay(SUBMIT_DELAY, function()
                            _manualSubmitDebounce = nil
                            if _autoAccept and box and box.Parent and isVisibleChain(box) then
                                local code = box.Text
                                if code ~= "" then
                                    local ok, statusMsg = typeAndSubmitCode(code)
                                    if ok then
                                        setStatus("Code redeemed (" .. code .. ")", COLORS.Green)
                                    else
                                        setStatus("Failed: " .. tostring(statusMsg), COLORS.Red)
                                    end
                                end
                            end
                        end)
                    end
                end
            end
        end)

        _boxAncestryConn = box.AncestryChanged:Connect(function(_, parent)
            if not parent then resetPasteCounter(); clearBoxWatchers() end
        end)
    end

    UserInputService.TextBoxFocused:Connect(function(box)
        if box:IsDescendantOf(GUI) or (SettingsGUI and box:IsDescendantOf(SettingsGUI)) then return end
        if box ~= instinctCodeBox() then return end
        _focused = box
        _lastBox = box
        watchBoxForBlankReset(box)
    end)

    UserInputService.TextBoxFocusReleased:Connect(function(box)
        if box:IsDescendantOf(GUI) or (SettingsGUI and box:IsDescendantOf(SettingsGUI)) then return end
        local codeBox = instinctCodeBox()
        if box ~= codeBox and box ~= _lastBox then return end
        if _focused == box then
            _focused = nil
            if _enabled then
                setStatus((_lastBox and _lastBox.Parent) and "Ready" or "Click code box first", (_lastBox and _lastBox.Parent) and COLORS.Green or COLORS.Dim)
            end
        end
    end)

    function appendToBox(text)
        if not text or text == "" then return end
        if not _enabled then return end
        
        if _lastWatchedBox and not isVisibleChain(_lastWatchedBox) then
            resetPasteCounter()
            clearBoxWatchers()
        end
        local box = instinctCodeBox()
        _capturedParts[#_capturedParts + 1] = text
        local combinedCode = table.concat(_capturedParts)
        local capturedCount = #_capturedParts

        -- AutoCopy Typed code: copy captured code to clipboard when enabled
        if _autoCodeTypedEnabled then
            setClipboardSafe(combinedCode)
        end

        if box then
            _lastBox = box
            watchBoxForBlankReset(box)
            local boxWasFocused = UserInputService:GetFocusedTextBox() == box
            _programmaticChange = true
            box.Text = combinedCode
            _programmaticChange = false
            if boxWasFocused then
                pcall(function()
                    local caretEnd = #combinedCode + 1
                    box.CursorPosition = caretEnd
                    box.SelectionStart = caretEnd
                end)
            end
        else
            setStatus("Captured; opening & searching UI...", COLORS.Text)
        end

        setStatus("Pasted " .. tostring(capturedCount) .. "/" .. tostring(_submitAfter), COLORS.Green)
        flashCode(combinedCode, COLORS.Green)

        if capturedCount >= _submitAfter then
            _capturedParts = {}
            if _autoAccept then
                -- Auto submit delay 0.05s
                task.wait(SUBMIT_DELAY)
                local ok, statusMsg = typeAndSubmitCode(combinedCode)
                if ok then
                    setStatus("Code redeemed (" .. combinedCode .. ")", COLORS.Green)
                else
                    setStatus("Failed: " .. tostring(statusMsg), COLORS.Red)
                end
            end
        end
    end

    -- ============================================================
    -- ANNOUNCEMENT NOTIFICATION LISTENER
    -- ============================================================
    local function resolveNotifyRemote()
        if _G.PhiNotifyRemote then return _G.PhiNotifyRemote end
        local Net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")
        local getinfo = debug and (debug.getinfo or debug.info)
        if getgc and getinfo and getconnections then
            for _, d in ipairs(Net:GetDescendants()) do
                if d:IsA("RemoteEvent") then
                    local ok, cs = pcall(getconnections, d.OnClientEvent)
                    if ok then
                        for _, c in ipairs(cs) do
                            local f, fn = pcall(function() return c.Function end)
                            if f and type(fn) == "function" then
                                local i, info = pcall(getinfo, fn)
                                if i and tostring(info.short_src or info.source or ""):find("NotificationController", 1, true) then
                                    return d
                                end
                            end
                        end
                    end
                end
            end
        end
        return nil
    end

    local function instinctStripRich(text)
        if type(text) ~= "string" then return tostring(text) end
        return (text:gsub("<[^>]->", ""))
    end

    local function instinctTokenize(text)
        local words = {}
        for word in text:gmatch("[%w_]+") do
            words[#words + 1] = word
        end
        return words
    end

    local instinctCollectBuffer = {}
    local function onInstinctAnnouncement(...)
        if not _enabled then return end
        
        local text = instinctStripRich(tostring((...) or ""))
        text = text:match("^%s*(.-)%s*$") or ""
        if text == "" then return end

        if text:find("%s") then return end

        for _, word in ipairs(instinctTokenize(text)) do
            instinctCollectBuffer[#instinctCollectBuffer + 1] = word
        end
        
        local parts = {}
        for index = 1, math.min(#instinctCollectBuffer, INSTINCT_WORD_COUNT) do
            parts[index] = instinctCollectBuffer[index]
        end
        if #instinctCollectBuffer < INSTINCT_WORD_COUNT then return end
        instinctCollectBuffer = {}
        
        local captured = table.concat(parts)
        if captured == "" or _seen[captured] then return end
        _seen[captured] = true
        task.delay(1.25, function() _seen[captured] = nil end)
        appendToBox(captured)
    end

    local instinctNotifyRemote = resolveNotifyRemote()
    local instinctListenConnection
    if instinctNotifyRemote then
        if getgenv then
            local previous = getgenv().InstinctCodeSniperNotifyConnection
            if previous then pcall(function() previous:Disconnect() end) end
        end
        instinctListenConnection = instinctNotifyRemote.OnClientEvent:Connect(function(...)
            pcall(onInstinctAnnouncement, ...)
        end)
        if getgenv then getgenv().InstinctCodeSniperNotifyConnection = instinctListenConnection end
    end

    if getgenv then
        getgenv().StopAura = function()
            if instinctListenConnection then
                pcall(function() instinctListenConnection:Disconnect() end)
                instinctListenConnection = nil
            end
            if getgenv().InstinctCodeSniperNotifyConnection then
                pcall(function() getgenv().InstinctCodeSniperNotifyConnection:Disconnect() end)
                getgenv().InstinctCodeSniperNotifyConnection = nil
            end
            if _listenInputConnection then
                _listenInputConnection:Disconnect()
                _listenInputConnection = nil
            end
            if _clearFeedInputConnection then
                _clearFeedInputConnection:Disconnect()
                _clearFeedInputConnection = nil
            end
            stopAntiLag()
            stopAntiRagdoll()
            stopRemoveAccessories()
            autoBuyStop()
            if GUI then GUI:Destroy() end
            if SettingsGUI then SettingsGUI:Destroy() end
        end
    end

    -- Ensure initial states
    if _antiLagEnabled then startAntiLag() end
    if _antiRagdollEnabled then startAntiRagdoll() end
    if _removeAccessoriesEnabled then startRemoveAccessories() end
    if savedConfig.autoBuy then
        autoBuyStart()
    end
    updateStatusDot()

    setupListenKeybind()
    setupClearFeedKeybind()

    ConsoleOutput.Text = ""
    -- ===== ORIGINAL SCRIPT ENDS =====
end)

if not success then
    warn("Instinct Code Sniper error: " .. tostring(err))
    print("Check the error above. The script may not work in this environment.")
end