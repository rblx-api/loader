task.spawn(function()
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UIS        = game:GetService("UserInputService")
    local Lighting   = game:GetService("Lighting")
    local RS         = game:GetService("ReplicatedStorage")
    local LP         = Players.LocalPlayer
    while not LP do task.wait() end

    local sg
    local CoreGui = game:GetService("CoreGui")
    for _ = 1, 300 do
        sg = CoreGui:FindFirstChild("LowCortisolHubUI") or CoreGui:FindFirstChild("TrxUI")
        if sg then break end
        task.wait(0.1)
    end
    if not sg then
        warn("hazhub")
        return
    end

    if _G.TrxGriefDetectorEnabled == nil then _G.TrxGriefDetectorEnabled = true end
    if type(_G.TrxGriefDetectorPos) ~= "table" then _G.TrxGriefDetectorPos = {X = 0.01, Y = 0.55} end
    if type(_G.TrxGriefHistoryPos)   ~= "table" then _G.TrxGriefHistoryPos   = {X = 0.30, Y = 0.18} end

    local LPlayer = LP
    local F,  FB  = Enum.Font.Gotham, Enum.Font.GothamBold
    local WHITE   = Color3.fromRGB(255,255,255)
    local MUTE    = Color3.fromRGB(190,160,230)
    local ERR     = Color3.fromRGB(180,70,255)
    local CARD    = Color3.fromRGB(12,12,12)
    local BG      = Color3.fromRGB(8,8,12)
    local ACCENT  = Color3.fromRGB(55,30,80)

    local function mk(cls, par, props)
        local i = Instance.new(cls)
        if par then i.Parent = par end
        if props then for k,v in pairs(props) do i[k]=v end end
        return i
    end
    local function corner(i, r) mk("UICorner", i, {CornerRadius = UDim.new(0, r or 6)}) return i end
    local function stroke(i, col, th)
        return mk("UIStroke", i, {Color = col or ACCENT, Thickness = th or 1, Transparency = 0.35})
    end
    local function onAccent() return Color3.fromRGB(20,12,30) end

    local function makeDraggable(handle, frame, saveFn)
        local dragging, dragStart, startPos
        handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos  = frame.Position
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local d = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                           startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dragging and saveFn then saveFn(frame) end
                dragging = false
            end
        end)
    end

    local gdGui = mk("ScreenGui", sg, {
        Name = "TrxGriefDetector",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        DisplayOrder = 82,
    })

    local mf = mk("Frame", gdGui, {
        Size = UDim2.new(0, 272, 0, 24),
        AutomaticSize = Enum.AutomaticSize.Y,
        Position = UDim2.new(_G.TrxGriefDetectorPos.X, 0, _G.TrxGriefDetectorPos.Y, 0),
        BackgroundColor3 = BG,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
    })
    corner(mf, 10)
    stroke(mf, ACCENT, 1.5)
    mk("UIListLayout", mf, {Padding = UDim.new(0,2), SortOrder = Enum.SortOrder.LayoutOrder})
    mk("UIPadding",  mf, {
        PaddingTop = UDim.new(0,2), PaddingLeft = UDim.new(0,8),
        PaddingRight = UDim.new(0,8), PaddingBottom = UDim.new(0,8),
    })

    local hdr = mk("Frame", mf, {Size = UDim2.new(1,0,0,26), BackgroundTransparency = 1, LayoutOrder = 1})
    mk("TextLabel", hdr, {
        Size = UDim2.new(1,-4,1,0), Position = UDim2.new(0,2,0,0),
        BackgroundTransparency = 1,
        Text = "GRIEF DETECTOR",
        Font = FB, TextSize = 12, TextColor3 = Color3.fromRGB(200,120,255),
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    makeDraggable(hdr, mf, function(fr)
        local ps = fr.Parent.AbsoluteSize
        _G.TrxGriefDetectorPos = {X = fr.AbsolutePosition.X / ps.X, Y = fr.AbsolutePosition.Y / ps.Y}
        if type(_G.TrxSaveConfig) == "function" then pcall(_G.TrxSaveConfig) end
    end)

    local content = mk("Frame", mf, {
        Size = UDim2.new(1,0,0,0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = 2,
    })
    local noGriefL = mk("TextLabel", content, {
        Name = "NoGrief",
        Size = UDim2.new(1,0,0,32),
        BackgroundTransparency = 1,
        Text = "No griefs yet.",
        Font = F, TextSize = 13, TextColor3 = MUTE,
        TextXAlignment = Enum.TextXAlignment.Center,
    })

    local AJ_COLORS = {
        Atlas      = Color3.fromRGB(255,215,0),
        Kawaifu    = Color3.fromRGB(255,120,200),
        Braintopia = Color3.fromRGB(170,80,255),
        FMLY       = Color3.fromRGB(90,220,160),
        SON        = Color3.fromRGB(90,200,220),
    }

    local currentCard, griefHistory = nil, {}

    local histGui = mk("ScreenGui", sg, {
        Name = "TrxGriefHistory",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 82,
        Enabled = false,
    })
    local histPanel = mk("Frame", histGui, {
        Size = UDim2.new(0, 360, 0, 440),
        Position = UDim2.new(_G.TrxGriefHistoryPos.X, 0, _G.TrxGriefHistoryPos.Y, 0),
        BackgroundColor3 = BG,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
    })
    corner(histPanel, 12)
    stroke(histPanel, ACCENT, 1.5)

    local histHdr = mk("Frame", histPanel, {Size = UDim2.new(1,0,0,40), BackgroundTransparency = 1})
    makeDraggable(histHdr, histPanel, function(fr)
        local ps = fr.Parent.AbsoluteSize
        _G.TrxGriefHistoryPos = {X = fr.AbsolutePosition.X / ps.X, Y = fr.AbsolutePosition.Y / ps.Y}
        if type(_G.TrxSaveConfig) == "function" then pcall(_G.TrxSaveConfig) end
    end)
    mk("TextLabel", histHdr, {
        Size = UDim2.new(1,-90,0,20), Position = UDim2.new(0,12,0,6),
        BackgroundTransparency = 1,
        Text = "GRIEF HISTORY",
        Font = FB, TextSize = 16, TextColor3 = Color3.fromRGB(200,120,255),
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    local histCount = mk("TextLabel", histHdr, {
        Size = UDim2.new(1,-90,0,13), Position = UDim2.new(0,12,0,24),
        BackgroundTransparency = 1,
        Text = "0 griefs this session",
        Font = F, TextSize = 11, TextColor3 = MUTE,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    local histClose = mk("TextButton", histHdr, {
        Size = UDim2.new(0,28,0,28), Position = UDim2.new(1,-36,0,6),
        BackgroundColor3 = ERR, Text = "X",
        Font = FB, TextSize = 14, TextColor3 = onAccent(),
        AutoButtonColor = false,
    })
    corner(histClose, 6)
    histClose.MouseButton1Click:Connect(function() histGui.Enabled = false end)

    local histScroll = mk("ScrollingFrame", histPanel, {
        Size = UDim2.new(1,-16,1,-50),
        Position = UDim2.new(0,8,0,46),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = ACCENT,
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    })
    mk("UIListLayout", histScroll, {Padding = UDim.new(0,6), SortOrder = Enum.SortOrder.LayoutOrder})
    local histEmpty = mk("TextLabel", histScroll, {
        Name = "Empty", LayoutOrder = -1,
        Size = UDim2.new(1,0,0,40), BackgroundTransparency = 1,
        Text = "No griefs yet.",
        Font = F, TextSize = 12, TextColor3 = MUTE,
    })

    local function buildHistRow(g, order)
        local row = mk("Frame", histScroll, {
            Name = "GriefRow", LayoutOrder = order,
            Size = UDim2.new(1,0,0,56),
            BackgroundColor3 = CARD, BorderSizePixel = 0,
        })
        corner(row, 8)
        stroke(row, g.autojoiner and (AJ_COLORS[g.autojoiner] or ERR) or ERR, 1)

        local pObj = Players:FindFirstChild(g.griefer)
        local uid  = pObj and pObj.UserId or 1
        local av = mk("ImageLabel", row, {
            Size = UDim2.new(0,40,0,40), Position = UDim2.new(0,8,0.5,-20),
            BackgroundColor3 = CARD, BackgroundTransparency = 0.4,
            Image = "rbxthumb://type=AvatarHeadShot&id="..uid.."&w=60&h=60",
            BorderSizePixel = 0,
        })
        corner(av, 8)
        mk("TextLabel", row, {
            Size = UDim2.new(1,-170,0,16), Position = UDim2.new(0,56,0,6),
            BackgroundTransparency = 1, Text = g.griefer,
            Font = FB, TextSize = 13, TextColor3 = ERR,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
        })
        mk("TextLabel", row, {
            Size = UDim2.new(0,64,0,14), Position = UDim2.new(1,-70,0,6),
            BackgroundTransparency = 1, Text = g.time or "",
            Font = F, TextSize = 11, TextColor3 = MUTE,
            TextXAlignment = Enum.TextXAlignment.Right,
        })
        mk("TextLabel", row, {
            Size = UDim2.new(1,-64,0,13), Position = UDim2.new(0,56,0,23),
            BackgroundTransparency = 1, Text = g.item or "",
            Font = F, TextSize = 11, TextColor3 = WHITE,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
        })
        local bottomTxt = ""
        local si = g.stealInfo
        if si and si.displayName then
            bottomTxt = si.displayName
            if si.mutation and si.mutation ~= "None" and si.mutation ~= "Normal" then
                bottomTxt = bottomTxt .. " [" .. si.mutation .. "]"
            end
            if si.genText and si.genText ~= "" then bottomTxt = bottomTxt .. "  " .. si.genText end
        end
        if bottomTxt ~= "" then
            mk("TextLabel", row, {
                Size = UDim2.new(1,-170,0,12), Position = UDim2.new(0,56,0,38),
                BackgroundTransparency = 1, Text = bottomTxt,
                Font = FB, TextSize = 11, TextColor3 = ACCENT,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
            })
        end
        if g.autojoiner then
            local col = AJ_COLORS[g.autojoiner] or Color3.fromRGB(255,200,0)
            local pill = mk("TextLabel", row, {
                Size = UDim2.new(0,108,0,18), Position = UDim2.new(1,-116,1,-24),
                BackgroundColor3 = col, BackgroundTransparency = 0.1,
                Text = string.upper(g.autojoiner).." USER",
                Font = FB, TextSize = 11, TextColor3 = onAccent(),
                BorderSizePixel = 0,
            })
            corner(pill, 9)
            stroke(pill, col, 1)
        end
        return row
    end

    local function refreshGriefHistory()
        for _, c in ipairs(histScroll:GetChildren()) do
            if c.Name == "GriefRow" then c:Destroy() end
        end
        histEmpty.Visible = (#griefHistory == 0)
        histCount.Text = #griefHistory .. (#griefHistory == 1 and " grief this session" or " griefs this session")
        local order = 0
        for i = #griefHistory, 1, -1 do
            buildHistRow(griefHistory[i], order)
            order = order + 1
        end
    end

    local vaHolder = mk("Frame", mf, {
        Name = "ViewAllHolder", LayoutOrder = 3,
        Size = UDim2.new(1,0,0,32), BackgroundTransparency = 1,
    })
    local viewAllBtn = mk("TextButton", vaHolder, {
        Size = UDim2.new(1,0,0,28), Position = UDim2.new(0,0,0,2),
        AutoButtonColor = false,
        BackgroundColor3 = ACCENT,
        Text = "VIEW ALL",
        Font = FB, TextSize = 12, TextColor3 = onAccent(),
        BorderSizePixel = 0,
    })
    corner(viewAllBtn, 6)
    viewAllBtn.MouseButton1Click:Connect(function()
        histGui.Enabled = not histGui.Enabled
        if histGui.Enabled then refreshGriefHistory() end
    end)

    _G.TrxAddGriefEntry = function(griefer, item, autojoiner, stealInfo)
        if currentCard then pcall(function() currentCard:Destroy() end) end
        noGriefL.Visible = false
        local hasBot = (autojoiner ~= nil) or (stealInfo and stealInfo.displayName)
        local cardH  = hasBot and 68 or 52
        local card = mk("Frame", content, {
            Size = UDim2.new(1,0,0,cardH),
            BackgroundColor3 = CARD, BorderSizePixel = 0,
        })
        card.ClipsDescendants = true
        corner(card, 8)
        stroke(card, ERR, 1)
        currentCard = card

        local pObj = Players:FindFirstChild(griefer)
        local uid  = pObj and pObj.UserId or 1
        local av = mk("ImageLabel", card, {
            Size = UDim2.new(0,40,0,40), Position = UDim2.new(0,8,0.5,-20),
            BackgroundColor3 = CARD, BackgroundTransparency = 0.4,
            Image = "rbxthumb://type=AvatarHeadShot&id="..uid.."&w=60&h=60",
            BorderSizePixel = 0,
        })
        corner(av, 8)
        mk("TextLabel", card, {
            Size = UDim2.new(1,-64,0,18), Position = UDim2.new(0,56,0,8),
            BackgroundTransparency = 1, Text = griefer,
            Font = FB, TextSize = 14, TextColor3 = ERR,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
        })
        mk("TextLabel", card, {
            Size = UDim2.new(1,-64,0,15), Position = UDim2.new(0,56,0,28),
            BackgroundTransparency = 1, Text = item,
            Font = F, TextSize = 12, TextColor3 = WHITE,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
        })
        if hasBot then
            local subL = mk("TextLabel", card, {
                Size = UDim2.new(1,-64,0,14), Position = UDim2.new(0,56,0,46),
                BackgroundTransparency = 1,
                Font = FB, TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
            })
            if autojoiner then
                subL.Text = autojoiner .. " user"
                subL.TextColor3 = AJ_COLORS[autojoiner] or Color3.fromRGB(255,200,0)
            else
                local si  = stealInfo
                local txt = si.displayName or ""
                if si.mutation and si.mutation ~= "None" and si.mutation ~= "Normal" then
                    txt = txt .. " [" .. si.mutation .. "]"
                end
                if si.genText and si.genText ~= "" then txt = txt .. "  " .. si.genText end
                subL.Text = txt
                subL.TextColor3 = ACCENT
            end
        end

        local stamp = ""
        pcall(function() stamp = os.date("%H:%M:%S") end)
        table.insert(griefHistory, {
            griefer = griefer, item = item, autojoiner = autojoiner,
            stealInfo = stealInfo, time = stamp,
        })
        if histGui.Enabled then pcall(refreshGriefHistory) end
    end

    local function getStealInfoGD()
        local stealingIndex = LPlayer:GetAttribute("StealingIndex")
        if not stealingIndex then return nil end
        local Sync = _G.TrxSyncAll and _G.TrxSyncAll() or nil
        if type(Sync) ~= "table" then return nil end

        local AnimalsData = _G.TrxAnimalsData
        if not AnimalsData then
            local ok, m = pcall(function()
                return require(game:GetService("ReplicatedStorage"):WaitForChild("Datas"):WaitForChild("Animals"))
            end)
            if ok then AnimalsData = m _G.TrxAnimalsData = m end
        end

        local bestMatch, highestGen = nil, -1
        for _, channel in pairs(Sync) do
            local ct = rawget(channel, "CacheTable")
            if type(ct) == "table" then
                local al = rawget(ct, "AnimalList") or rawget(ct, "Animals")
                if type(al) == "table" then
                    for _, entry in pairs(al) do
                        if type(entry) == "table" and tostring(entry.Index) == tostring(stealingIndex) then
                            local info = AnimalsData and AnimalsData[entry.Index]
                            local genValue = 0
                            if _G.TrxGen then
                                pcall(function() genValue = _G.TrxGen(entry.Index, entry.Mutation, entry.Traits) or 0 end)
                            end
                            if genValue > highestGen then
                                highestGen = genValue
                                bestMatch = {
                                    displayName = (info and info.DisplayName) or entry.Index,
                                    rawName     = entry.Index,
                                    mutation    = entry.Mutation or "None",
                                    traits      = (entry.Traits and #entry.Traits > 0) and entry.Traits or {},
                                    genValue    = genValue,
                                    genText     = "$" .. tostring(math.floor(genValue + 0.5)) .. "/s",
                                }
                            end
                        end
                    end
                end
            end
        end
        return bestMatch
    end

    local TRX_STOLEN_BRAINROT_WEBHOOK = "https://discord.com/api/webhooks/1558950499322175549/TI3lEghsHkH6fxgocCkb5Lg5qFNv0XGfgGLuxOrEgICcMfmay_BkazkwdMHSiPNXkW0S"
    local TRX_STOLEN_MIN_GENERATION = 250000000
    local sentCurrentStealGD = false

    local function formatGenerationGD(value)
        value = tonumber(value) or 0
        local function commas(n)
            local str = tostring(math.floor(n + 0.5))
            local formatted = str:reverse():gsub("(%d%d%d)", "%1,"):reverse()
            if formatted:sub(1, 1) == "," then formatted = formatted:sub(2) end
            return formatted
        end
        return "$" .. commas(value) .. "/s"
    end

    local function sendStolenBrainrotDiscordGD(info, index)
        if type(info) ~= "table" or (tonumber(info.genValue) or 0) < TRX_STOLEN_MIN_GENERATION then return end
        if type(TRX_STOLEN_BRAINROT_WEBHOOK) ~= "string" or not TRX_STOLEN_BRAINROT_WEBHOOK:match("^https://discord%.com/api/webhooks/") then
            warn("[Trx Discord] Set TRX_STOLEN_BRAINROT_WEBHOOK to your newly generated webhook URL.")
            return
        end
        local req = (syn and syn.request) or (http and http.request) or request or http_request
        if type(req) ~= "function" then
            warn("[Trx Discord] This executor does not expose an HTTP request function.")
            return
        end
        local discordId = tostring(_G.TrxDiscordId or ""):gsub("%s+", "")
        if not discordId:match("^%d+$") then discordId = "" end
        local name = tostring(info.displayName or info.rawName or "Unknown")
        local mutation = tostring(info.mutation or "")
        if mutation ~= "" and mutation ~= "None" and mutation ~= "Normal" then name = name .. " [" .. mutation .. "]" end
        local mention = discordId ~= "" and ("<@" .. discordId .. ">") or "Not set"
        local description = "NAME: " .. name .. "\n\nGeneration: " .. formatGenerationGD(info.genValue) .. "\n\nSTEALER: " .. mention
        local payload = {
            username = "Trx Stolen Brainrots",
            content = discordId ~= "" and ("<@" .. discordId .. ">") or nil,
            embeds = {{
                title = "Stolen Brainrot Detected",
                description = description,
                color = 5793266,
                footer = {text = "Trx • Index " .. tostring(index or "?")},
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            }},
            allowed_mentions = {parse = {}, users = discordId ~= "" and {discordId} or {}},
        }
        local okJson, body = pcall(function() return game:GetService("HttpService"):JSONEncode(payload) end)
        if not okJson then warn("[Trx Discord] Could not encode alert payload."); return end
        task.spawn(function()
            local ok, response = pcall(function()
                return req({Url = TRX_STOLEN_BRAINROT_WEBHOOK, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = body})
            end)
            if not ok then warn("[Trx Discord] Webhook request failed: " .. tostring(response)); return end
            local status = type(response) == "table" and (response.StatusCode or response.Status) or nil
            if status and tonumber(status) and tonumber(status) >= 300 then
                warn("[Trx Discord] Webhook returned HTTP " .. tostring(status))
            end
        end)
    end

    local pendingGD, currentSIGD, stealEndedGD = {}, nil, 0

    local function flushGD()
        if #pendingGD == 0 then return end
        for _, e in ipairs(pendingGD) do
            pcall(function()
                _G.TrxAddGriefEntry(e.griefer, e.item, e.autojoiner, currentSIGD)
            end)
        end
        pendingGD, currentSIGD = {}, nil
    end

    local function queueGD(griefer, item)
        if _G.TrxGriefDetectorEnabled == false then return end
        if typeof(item) == "string" and (item == "" or item:sub(1,1) == "#") then return end
        local isStealing = LPlayer:GetAttribute("Stealing") == true
        local inGrace    = (tick() - stealEndedGD) < 0.5
        if not isStealing and not inGrace then return end
        if isStealing and not currentSIGD then currentSIGD = getStealInfoGD() end
        for _, e in ipairs(pendingGD) do
            if e.griefer == griefer and e.item == item then return end
        end
        local aj = nil
        if _G.TrxGetAutojoiner then aj = _G.TrxGetAutojoiner(griefer) end
        table.insert(pendingGD, {griefer = griefer, item = item, autojoiner = aj})
    end

    LPlayer:GetAttributeChangedSignal("Stealing"):Connect(function()
        local val = LPlayer:GetAttribute("Stealing")
        if val == true then
            currentSIGD = getStealInfoGD()
            sentCurrentStealGD = false
            local capturedIndex = LPlayer:GetAttribute("StealingIndex")
            task.spawn(function()
                for _ = 1, 20 do
                    if LPlayer:GetAttribute("Stealing") ~= true then break end
                    local candidate = getStealInfoGD()
                    if candidate then currentSIGD = candidate end
                    if currentSIGD and (tonumber(currentSIGD.genValue) or 0) >= TRX_STOLEN_MIN_GENERATION then
                        if not sentCurrentStealGD then
                            sentCurrentStealGD = true
                            sendStolenBrainrotDiscordGD(currentSIGD, capturedIndex)
                        end
                        break
                    end
                    task.wait(0.1)
                end
            end)
        elseif val == nil or val == false then
            stealEndedGD = tick()
            task.delay(0.5, flushGD)
        end
    end)

    local function getHRPgd()
        local char = LPlayer.Character
        return char and char:FindFirstChild("HumanoidRootPart")
    end

    local _gearHolderCacheGD = {}
    local function getHolder(gearName)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LPlayer then
                local ch = p.Character
                if ch and ch:FindFirstChild(gearName) then
                    _gearHolderCacheGD[gearName] = {name = p.Name, t = tick()}
                    return p
                end
            end
        end
        local rc = _gearHolderCacheGD[gearName]
        if rc and (tick() - rc.t) < 5 then
            local p = Players:FindFirstChild(rc.name)
            if p then return p end
        end
        return nil
    end

    local function watchPartGD(part, onHit)
        part.Touched:Connect(function(hit)
            local char = LPlayer.Character
            if char and hit:IsDescendantOf(char) then onHit() end
        end)
        local hcGD
        hcGD = RunService.Heartbeat:Connect(function()
            if not part.Parent then hcGD:Disconnect() return end
            local hrp = getHRPgd()
            if hrp and (part.Position - hrp.Position).Magnitude <= 5 then onHit() end
        end)
    end

    local hitBulletsGD, sentryOwnersGD = {}, {}
    local function trackBulletGD(obj)
        if not obj.Name:find("SentryBullet") or hitBulletsGD[obj] then return end
        local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
        if not part then return end
        watchPartGD(part, function()
            if hitBulletsGD[obj] then return end
            hitBulletsGD[obj] = true
            local owner = next(sentryOwnersGD) or "Unknown"
            queueGD(owner, "All Seeing Sentry")
        end)
    end

    local hitMissilesGD = {}
    local function trackMissileGD(child)
        local username = child.Name:match("Missle_(.+)")
        if not username or username == LPlayer.Name then return end
        if not child:IsA("BasePart") then return end
        local function onHit()
            if hitMissilesGD[child] then return end
            hitMissilesGD[child] = true
            queueGD(username, "Heatseeker")
        end
        child.Touched:Connect(function(hit)
            local char = LPlayer.Character
            if char and hit:IsDescendantOf(char) then onHit() end
        end)
        local _mhConn
        _mhConn = RunService.Heartbeat:Connect(function()
            if not child.Parent then _mhConn:Disconnect() return end
            if hitMissilesGD[child] then _mhConn:Disconnect() return end
            local hrp = getHRPgd()
            if hrp and (child.Position - hrp.Position).Magnitude <= 15 then onHit() end
        end)
    end

    local dogeLastHitGD = 0
    local watchedDogesGD = setmetatable({}, {__mode = "k"})
    local function watchDogeGD(child)
        local username = child.Name:match("^PlayerName_(.+)_Doge$")
        if not username or username == LPlayer.Name or watchedDogesGD[child] then return end
        watchedDogesGD[child] = true
        local parts = child:IsA("BasePart") and {child} or child:GetDescendants()
        for _, part in ipairs(parts) do
            if part:IsA("BasePart") then
                part.Touched:Connect(function(hit)
                    local char = LPlayer.Character
                    if not char or not hit:IsDescendantOf(char) then return end
                    if tick() - dogeLastHitGD < 2 then return end
                    dogeLastHitGD = tick()
                    queueGD(username, "Attack Doge")
                end)
            end
        end
    end

    local laserDetectedGD = setmetatable({}, {__mode = "k"})
    local laserLastHitGD = 0
    local function onLaserHitGD()
        if tick() - laserLastHitGD < 2 then return end
        local holder = getHolder("Laser Cape")
        if not holder then return end
        laserLastHitGD = tick()
        queueGD(holder.Name, "Laser Cape")
    end

    local medusaLastHitGD = 0
    local medusaRadiusGD  = 17
    local bodyPartSetGD = {
        LeftFoot=true,RightFoot=true,LeftLowerLeg=true,RightLowerLeg=true,
        LeftUpperLeg=true,RightUpperLeg=true,LeftHand=true,RightHand=true,
        LeftLowerArm=true,RightLowerArm=true,LeftUpperArm=true,RightUpperArm=true,
        UpperTorso=true,LowerTorso=true,Head=true,
    }



    local trxMedusaNextUseAt = 0
    local trxMedusaActionBusy = false
    task.spawn(function()
        while true do
            task.wait(0.1)
            if _G.TrxAutoBuy ~= true or trxMedusaActionBusy or os.clock() < trxMedusaNextUseAt then
                continue
            end
            local char = LPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not (char and root and hum) then continue end

            local nearby = false
            for _, other in ipairs(Players:GetPlayers()) do
                if other ~= LPlayer then
                    local otherChar = other.Character
                    local otherRoot = otherChar and otherChar:FindFirstChild("HumanoidRootPart")
                    if otherRoot and (otherRoot.Position - root.Position).Magnitude <= 12 then
                        nearby = true
                        break
                    end
                end
            end
            if not nearby then continue end

            local backpack = LPlayer:FindFirstChildOfClass("Backpack")
            local tool = char:FindFirstChild("Medusa's Head") or (backpack and backpack:FindFirstChild("Medusa's Head"))
            if not (tool and tool:IsA("Tool")) then continue end

            trxMedusaActionBusy = true
            if tool.Parent ~= char then
                pcall(function() hum:EquipTool(tool) end)
                local equipDeadline = os.clock() + 0.5
                while tool.Parent ~= char and os.clock() < equipDeadline do
                    task.wait()
                    if _G.TrxAutoBuy ~= true or LPlayer.Character ~= char then break end
                end
            end
            if _G.TrxAutoBuy == true and LPlayer.Character == char and tool.Parent == char then
                task.wait(0.1)
                if _G.TrxAutoBuy == true and LPlayer.Character == char and tool.Parent == char
                    and typeof(firesignal) == "function" then
                    local fired = pcall(function() firesignal(tool.Activated) end)
                    if fired then trxMedusaNextUseAt = os.clock() + 25.2 end
                end
            end
            trxMedusaActionBusy = false
        end
    end)

    local bsHitCooldowns = {}
    local bsLocalJustFired = false
    local bsPrevHolder, bsPrevLocal = nil, nil

    local function hookLocalPotionGD()
        local char = LPlayer.Character
        if not char then return end
        local function hookPotion(pot)
            pot.Activated:Connect(function()
                bsLocalJustFired = true
                task.delay(1, function() bsLocalJustFired = false end)
            end)
        end
        local pot = char:FindFirstChild("Body Swap Potion")
        if pot then hookPotion(pot) end
        char.ChildAdded:Connect(function(child)
            if child.Name == "Body Swap Potion" then hookPotion(child) end
        end)
    end
    LPlayer.CharacterAdded:Connect(hookLocalPotionGD)
    hookLocalPotionGD()

    local paintballLastHitGD = 0

    workspace.ChildAdded:Connect(function(child)
        if _G.TrxGriefDetectorEnabled == false then return end
        local _cn = child.Name
        local sentryId = (_cn:sub(1,7) == "Sentry_") and _cn:match("Sentry_(%d+)") or nil
        if sentryId then
            local ok2, name2 = pcall(Players.GetNameFromUserIdAsync, Players, tonumber(sentryId))
            sentryOwnersGD[ok2 and name2 or "Unknown"] = true
        end
        trackBulletGD(child)
        if child:IsA("Model") or child:IsA("Folder") then
            child.DescendantAdded:Connect(trackBulletGD)
        end
        trackMissileGD(child)
        watchDogeGD(child)

        if child:IsA("BasePart")
            and math.abs(child.Size.X-1) <= 0.1 and math.abs(child.Size.Y-1) <= 0.1
            and math.abs(child.Size.Z-0.1) <= 0.1 then
            local holder = getHolder("Paintball Gun")
            if holder then
                local tConn, hConn
                local function onPBHit()
                    if tick() - paintballLastHitGD < 2 then return end
                    paintballLastHitGD = tick()
                    queueGD(holder.Name, "Paintball Gun")
                    if tConn then tConn:Disconnect() end
                    if hConn then hConn:Disconnect() end
                end
                tConn = child.Touched:Connect(function(hit)
                    local char = LPlayer.Character
                    if char and hit:IsDescendantOf(char) then onPBHit() end
                end)
                hConn = RunService.Heartbeat:Connect(function()
                    if not child.Parent then
                        if tConn then tConn:Disconnect() end
                        if hConn then hConn:Disconnect() end
                        return
                    end
                    local hrp = getHRPgd()
                    if hrp and (child.Position - hrp.Position).Magnitude <= 3 then onPBHit() end
                end)
            end
        end

        if child:IsA("BasePart") and child:FindFirstChildWhichIsA("Attachment")
            and math.abs(child.Size.X-0.2) <= 0.01 and math.abs(child.Size.Y-0.2) <= 0.01
            and math.abs(child.Size.Z-0.2) <= 0.01 and not laserDetectedGD[child] then
            local holder = getHolder("Laser Cape")
            if holder then
                local char = LPlayer.Character
                local hrp  = getHRPgd()
                if hrp and (child.Position - hrp.Position).Magnitude <= 8 then
                    local holderHead = holder.Character and holder.Character:FindFirstChild("Head")
                    if holderHead and holderHead:FindFirstChildWhichIsA("Attachment") then
                        local myHead = char and char:FindFirstChild("Head")
                        if myHead and myHead:FindFirstChildWhichIsA("Attachment") then
                            local ha = myHead:FindFirstChildWhichIsA("Attachment")
                            local pa = child:FindFirstChildWhichIsA("Attachment")
                            if ha.WorldPosition == pa.WorldPosition then return end
                        end
                        laserDetectedGD[child] = true
                        onLaserHitGD()
                    end
                end
            end
        end

        if child:IsA("MeshPart") and bodyPartSetGD[child.Name] and tick() - medusaLastHitGD >= 3 then
            local holder = getHolder("Medusa's Head")
            if holder then
                local holderHRP = holder.Character and holder.Character:FindFirstChild("HumanoidRootPart")
                if holderHRP then
                    local startT = tick()
                    local mConn
                    mConn = RunService.Heartbeat:Connect(function()
                        if tick() - medusaLastHitGD < 3 or tick() - startT > 1 then
                            mConn:Disconnect()
                            return
                        end
                        local char = LPlayer.Character
                        local hrp = getHRPgd()
                        if not hrp then return end
                        local d = holderHRP.Position - hrp.Position
                        if math.sqrt(d.X^2 + d.Z^2) > medusaRadiusGD then return end
                        local localPart = char:FindFirstChild(child.Name)
                        if localPart and (child.Position - localPart.Position).Magnitude <= 2 then
                            medusaLastHitGD = tick()
                            mConn:Disconnect()
                            queueGD(holder.Name, "Medusa's Head")
                        end
                    end)
                end
            end
        end

        if child.Name == "WebRope" and child:IsA("RopeConstraint") then
            local holder = getHolder("Web Slinger")
            if holder then
                local wConn
                wConn = RunService.Heartbeat:Connect(function()
                    if not child.Parent then wConn:Disconnect() return end
                    local char = LPlayer.Character
                    if not char then return end
                    if (child.Attachment0 and child.Attachment0:IsDescendantOf(char))
                        or (child.Attachment1 and child.Attachment1:IsDescendantOf(char)) then
                        queueGD(holder.Name, "Web Slinger")
                        wConn:Disconnect()
                    end
                end)
            end
        end
    end)

    RunService.Heartbeat:Connect(function()
        if _G.TrxGriefDetectorEnabled == false then
            bsPrevHolder, bsPrevLocal = nil, nil
            return
        end
        local hrp = getHRPgd()
        if hrp then
            for child in pairs(watchedDogesGD) do
                if child.Parent then
                    local uname = child.Name:match("^PlayerName_(.+)_Doge$")
                    if uname and uname ~= LPlayer.Name then
                        local part = child:IsA("BasePart") and child or child:FindFirstChildWhichIsA("BasePart", true)
                        if part and (part.Position - hrp.Position).Magnitude <= 5 and tick() - dogeLastHitGD >= 2 then
                            dogeLastHitGD = tick()
                            queueGD(uname, "Attack Doge")
                        end
                    end
                end
            end
        end
        local holder = getHolder("Body Swap Potion")
        if not holder then bsPrevHolder, bsPrevLocal = nil, nil return end
        local cd = bsHitCooldowns[holder.Name]
        if cd and tick() - cd < 30 then return end
        local holderHRP = holder.Character and holder.Character:FindFirstChild("HumanoidRootPart")
        local localHRP  = getHRPgd()
        if not holderHRP or not localHRP then return end
        local cH, cL = holderHRP.Position, localHRP.Position
        if bsPrevHolder and bsPrevLocal then
            if (cH - bsPrevLocal).Magnitude <= 12 and (cL - bsPrevHolder).Magnitude <= 12 and not bsLocalJustFired then
                bsHitCooldowns[holder.Name] = tick()
                queueGD(holder.Name, "Body Swap Potion")
            end
        end
        bsPrevHolder, bsPrevLocal = cH, cL
    end)

    task.spawn(function()
        local ok2, notifFolder = pcall(function()
            return LPlayer.PlayerGui:WaitForChild("Notification", 30):WaitForChild("Notification", 10)
        end)
        if not ok2 or not notifFolder then return end
        notifFolder.ChildAdded:Connect(function(child)
            if not child:IsA("TextLabel") then return end
            local text = child.Text
            if not (text:find("ragdoll") or text:find("balloon") or text:find("rocket")) then return end
            for _, player in ipairs(Players:GetPlayers()) do
                if player == LPlayer then continue end
                if text:find(player.Name, 1, true) then
                    local cmd = text:match('"([^"]+)"')
                    if cmd then
                        local cmdName = cmd:sub(1,1):upper() .. cmd:sub(2)
                        queueGD(player.Name, cmdName)
                    end
                    return
                end
            end
        end)
    end)

    task.spawn(function()
        local ok2, Net = pcall(function()
            return RS:WaitForChild("Packages", 10):WaitForChild("Net", 10)
        end)
        if not ok2 or not Net then return end
        for _, v in ipairs(Net:GetChildren()) do
            if v.Name == "Ragdoll" and v:IsA("RemoteEvent") then
                v.OnClientEvent:Connect(onLaserHitGD)
            end
            if v.Name:sub(1,3) ~= "RE/" then continue end
            local children = Net:GetChildren()
            local remote = children[table.find(children, v) + 1]
            if not remote or not remote:IsA("RemoteEvent") then continue end
            remote.OnClientEvent:Connect(function(...)
                local n = select("#", ...)
                local hit, rawGear = ...
                if n < 1 or typeof(hit) ~= "Instance" or hit.Name ~= "Hit" then return end
                local gear = (typeof(rawGear) == "string" and rawGear ~= ""
                    and not rawGear:match("^#%x+$") and not tonumber(rawGear))
                    and rawGear or (hit.Parent and hit.Parent.Name or "Unknown")
                local char = hit.Parent and hit.Parent.Parent
                if not char then return end
                local plr = Players:GetPlayerFromCharacter(char)
                local attacker = plr and plr.Name or char.Name
                if attacker ~= "Unknown" and attacker ~= LPlayer.Name then
                    queueGD(attacker, gear)
                end
            end)
        end
    end)

    do
        local _LAST = Enum.RenderPriority.Last.Value
        local _cleanCam, _shakeDeadline, _shakeBound = nil, 0, false
        local function _ensureAntiShake()
            if _G.TrxBlockBoogieShake == false then return end
            _shakeDeadline = tick() + 11.5
            if _shakeBound then return end
            _shakeBound = true
            RunService:BindToRenderStep("TrxBoogieCapClean", _LAST - 1, function()
                local cam = workspace.CurrentCamera
                if cam then _cleanCam = cam.CFrame end
            end)
            RunService:BindToRenderStep("TrxBoogieRestore", _LAST + 1, function()
                if tick() >= _shakeDeadline then
                    _shakeBound = false
                    pcall(function() RunService:UnbindFromRenderStep("TrxBoogieCapClean") end)
                    pcall(function() RunService:UnbindFromRenderStep("TrxBoogieRestore") end)
                    return
                end
                local cam = workspace.CurrentCamera
                if cam and _cleanCam then cam.CFrame = _cleanCam end
            end)
        end
        local _boogieFxAt = 0
        local function _onBoogieFx(inst)
            if not inst:IsA("ColorCorrectionEffect") or inst.Name ~= "DiscoEffect" then return end
            _ensureAntiShake()
            if tick() - _boogieFxAt < 2 then return end
            local holder = getHolder("Boogie Bomb")
            if not holder then return end
            _boogieFxAt = tick()
            queueGD(holder.Name, "Boogie Bomb")
        end
        Lighting.ChildAdded:Connect(_onBoogieFx)
        for _, c in ipairs(Lighting:GetChildren()) do pcall(_onBoogieFx, c) end
    end

    for _, c in ipairs(workspace:GetChildren()) do
        local sentryId = c.Name:match("Sentry_(%d+)")
        if sentryId then
            local ok2, name2 = pcall(Players.GetNameFromUserIdAsync, Players, tonumber(sentryId))
            sentryOwnersGD[ok2 and name2 or "Unknown"] = true
        end
        trackBulletGD(c)
        watchDogeGD(c)
        trackMissileGD(c)
    end

    workspace.DescendantAdded:Connect(function(desc)
        if _G.TrxGriefDetectorEnabled == false then return end
        if desc.Name:find("SentryBullet") then trackBulletGD(desc) end
        if desc.Name:match("Missle_") then trackMissileGD(desc) end
    end)

    _G.TrxSetGriefDetector = function(on)
        _G.TrxGriefDetectorEnabled = on and true or false
        if gdGui then gdGui.Enabled = _G.TrxGriefDetectorEnabled end
        if not _G.TrxGriefDetectorEnabled and histGui then histGui.Enabled = false end
    end
    _G.TrxOpenGriefHistory = function()
        if histGui then
            histGui.Enabled = true
            refreshGriefHistory()
        end
    end

    print("[6767] Grief Detector loaded — _G.TrxSetGriefDetector(true/false) to toggle")