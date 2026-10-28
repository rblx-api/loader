-- CANDY HUB: intro de 10 segundos. Musica desde 0:00.
if not LPH_OBFUSCATED and type(LPH_NO_VIRTUALIZE) ~= "function" then
    getfenv().LPH_NO_VIRTUALIZE = function(fn) return fn end
end

-- CANDY HUB: drawn candy, a fixed particle pool, and one native animation callback.
do
    if _G.BlessIntro and _G.BlessIntro.Cancel then pcall(_G.BlessIntro.Cancel) end
    if _G.CandyIntro and _G.CandyIntro.Cancel then pcall(_G.CandyIntro.Cancel) end
    local players = game:GetService("Players")
    local run = game:GetService("RunService")
    local input = game:GetService("UserInputService")
    local soundService = game:GetService("SoundService")
    local MUSIC_URL = "https://file.garden/algLafWA1jk8WMfK/Jesse%20Pinkman_spotdown.org.mp3"
    local MUSIC_FILE = "Candy_Jesse.mp3"
    local state = {Active = true, Started = false, Duration = 10, StartAt = 0, AudioPlaying = false}
    local connections, threads, panels = {}, {}, {}
    local overlay, startedAt, music, loading, loadingDots, hint
    local letters, candies, sparkles = {}, {}, {}
    local confetti, ripples, bubbles = {}, {}, {}
    local orbit, orbitZoom, backdrop
    local hero, heroZoom
    local rays, comets = {}, {}
    local IMPACTS = {.2, 1.48, 4.65, 8.35}
    local viewport = Vector2.new(800, 600)
    local scaleObject
    local cream = Color3.fromRGB(255, 250, 241)
    local pink = Color3.fromRGB(255, 91, 163)
    local peach = Color3.fromRGB(255, 174, 114)
    local mint = Color3.fromRGB(106, 235, 218)
    local purple = Color3.fromRGB(184, 147, 255)
    local cherry = Color3.fromRGB(143, 43, 103)
    local palette = {pink, peach, mint, purple}

    local function connect(signal, callback)
        local connection = signal:Connect(callback)
        connections[#connections + 1] = connection
        return connection
    end

    local function finish()
        if not state.Active then return end
        state.Active = false
        state.AudioPlaying = false
        if music then pcall(function() music:Stop(); music:Destroy() end); music = nil end
        for _, connection in ipairs(connections) do pcall(function() connection:Disconnect() end) end
        local current = coroutine.running()
        for _, thread in ipairs(threads) do
            if thread ~= current and coroutine.status(thread) ~= "dead" then pcall(task.cancel, thread) end
        end
        for panel,saved in pairs(panels)do pcall(function() panel.Enabled=saved.enabled end)end
        panels={}
        if overlay then pcall(function() overlay:Destroy() end) end
        connections, threads = {}, {}
        letters, candies, sparkles = {}, {}, {}
        confetti, ripples, bubbles = {}, {}, {}
        rays, comets = {}, {}
    end
    state.Cancel, state.Finish = finish, finish
    _G.CandyIntro = state

    -- Build the hub immediately and reveal its intended panels after the intro.
    state.GetEnabled=function(panel)
        local saved=panels[panel]
        return saved and saved.enabled or (not saved and panel.Enabled) or false
    end
    state.SetEnabled=function(panel,enabled)
        local saved=panels[panel]
        if state.Active and saved then
            saved.enabled=enabled==true
            saved.applying=true;panel.Enabled=false;saved.applying=false
        else panel.Enabled=enabled==true end
    end
    state.Track=function(panel)
        if not state.Active or panels[panel]then return panel end
        local saved={enabled=panel.Enabled,applying=false}
        panels[panel]=saved
        connect(panel:GetPropertyChangedSignal("Enabled"),function()
            if saved.applying or not state.Active or not panel.Enabled then return end
            saved.enabled=true
            saved.applying=true;panel.Enabled=false;saved.applying=false
        end)
        saved.applying=true;panel.Enabled=false;saved.applying=false
        return panel
    end
    _G.BlessIntro=state


    local function begin(withAudio)
        if not state.Active or state.Started then return end
        if withAudio and music then
            local ok = pcall(function()
                music.TimePosition = 0
                music.Volume = .72
                music:Play()
            end)
            state.AudioPlaying = ok
        elseif music then
            pcall(function() music:Stop(); music:Destroy() end)
            music = nil
        end
        state.Started = true
        startedAt = os.clock()
        if loading then loading.Visible = false end
        if hint then hint.Visible = true end
        local endTimer = task.delay(state.Duration, finish)
        threads[#threads + 1] = endTimer
    end

    local make = LPH_NO_VIRTUALIZE(function(className, parent, properties)
        local object = Instance.new(className)
        for key, value in pairs(properties or {}) do object[key] = value end
        object.Parent = parent
        return object
    end)

    local rect = LPH_NO_VIRTUALIZE(function(parent, x, y, width, height, color, radius, rotation, transparency, z)
        local object = make("Frame", parent, {
            AnchorPoint = Vector2.new(.5, .5),
            Position = UDim2.fromOffset(x, y),
            Size = UDim2.fromOffset(width, height),
            BackgroundColor3 = color,
            BackgroundTransparency = transparency or 0,
            BorderSizePixel = 0,
            Rotation = rotation or 0,
            ZIndex = z or 3,
        })
        -- Relative corners stay round when the hero is enlarged or the screen shrinks.
        if radius then
            make("UICorner", object, {CornerRadius = UDim.new(math.min(.5, radius / math.min(width, height)), 0)})
        end
        return object
    end)

    local edge = LPH_NO_VIRTUALIZE(function(object, color, width, alpha)
        return make("UIStroke", object, {
            Color = color,
            Thickness = width,
            Transparency = alpha or 0,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        })
    end)

    local function candyRoot(parent, name, width, height)
        local root = make("Frame", parent, {
            Name = name,
            AnchorPoint = Vector2.new(.5, .5),
            Size = UDim2.fromOffset(width, height),
            BackgroundTransparency = 1,
            Visible = false,
            ZIndex = 3,
        })
        local zoom = make("UIScale", root, {Scale = .001})
        return root, zoom
    end

    local shade = LPH_NO_VIRTUALIZE(function(object, top, middle, bottom, angle)
        object.BackgroundColor3 = Color3.new(1, 1, 1)
        return make("UIGradient", object, {
            Rotation = angle or 90,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, top),
                ColorSequenceKeypoint.new(.42, middle),
                ColorSequenceKeypoint.new(1, bottom),
            }),
        })
    end)

    local gloss = LPH_NO_VIRTUALIZE(function(object, angle)
        return make("UIGradient", object, {
            Rotation = angle or 0,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(.28, .3),
                NumberSequenceKeypoint.new(.5, 0),
                NumberSequenceKeypoint.new(.72, .3),
                NumberSequenceKeypoint.new(1, 1),
            }),
        })
    end)

    local lollipop = LPH_NO_VIRTUALIZE(function(parent, color, detailed)
        local root, zoom = candyRoot(parent, "SpiralLollipop", 100, 132)
        local white = Color3.new(1, 1, 1)
        local dark = color:Lerp(cherry, .5)
        rect(root, 52, 94, 8, 68, cherry, 4, 0, .86)
        local stick = rect(root, 50, 93, 7, 68, cream, 3.5)
        stick.Name = "RoundStick"
        shade(stick, white, cream, Color3.fromRGB(190, 176, 191), 0)
        rect(root, 48.7, 93, 1.2, 63, white, .6, 0, .16)
        rect(root, 52, 43, 76, 76, cherry, 38, 0, .86)
        local depth = rect(root, 51.3, 41.5, 73.5, 73.5, dark, 37)
        depth.Name = "CandyThickness"
        shade(depth, color:Lerp(cream, .28), color, dark, 75)
        local rim = rect(root, 50, 39, 73, 73, cream, 36.5)
        rim.Name = "RoundCandyRim"
        shade(rim, white, cream, color:Lerp(cherry, .18), 68)
        local face = rect(root, 49.5, 38.5, 69.2, 69.2, color, 35)
        face.Name = "GlossyCandyFace"
        shade(face, color:Lerp(cream, .65), color, dark, 65)

        -- Overlapping round capsules form a continuous ribbon, even in close-up.
        local segments = detailed and 112 or 64
        local points = {}
        for i = 0, segments do
            local t = i / segments
            local angle = -1.1 + t * math.pi * 5
            local radius = .5 + t * 29.3
            points[i + 1] = {49.5 + math.cos(angle) * radius, 38.5 + math.sin(angle) * radius, t}
        end
        if detailed then
            for i = 2, #points do
                local a, b = points[i - 1], points[i]
                local dx, dy = b[1] - a[1], b[2] - a[2]
                local width = 2.8 + b[3] * 4.3
                rect(root, (a[1] + b[1]) * .5 + .35, (a[2] + b[2]) * .5 + .75,
                    math.sqrt(dx * dx + dy * dy) + width, width,
                    dark, 5, math.deg(math.atan2(dy, dx)), .72)
            end
        end
        for i = 2, #points do
            local a, b = points[i - 1], points[i]
            local dx, dy = b[1] - a[1], b[2] - a[2]
            local width = 2.3 + b[3] * 4.1
            local light = math.clamp(((a[1] + b[1]) * .5 + (a[2] + b[2]) * .5 - 32) / 104, 0, 1)
            local ribbon = rect(root, (a[1] + b[1]) * .5, (a[2] + b[2]) * .5,
                math.sqrt(dx * dx + dy * dy) + width, width,
                cream:Lerp(color:Lerp(cream, .62), light * .6), 5, math.deg(math.atan2(dy, dx)))
            ribbon.Name = "SmoothSpiral"
        end
        local coating = rect(root, 49.5, 38.5, 67.5, 67.5, white, 34, 0, .94)
        edge(coating, white, detailed and .65 or .8, .64)
        coating.Name = "SugarCoating"
        gloss(coating, 52)
        gloss(rect(root, 39.5, 18.5, 24, 10, white, 5, -26, .33), 0)
        gloss(rect(root, 30.8, 27.8, 4.8, 16, white, 2.4, 28, .28), 90)
        gloss(rect(root, 58, 62, 19, 3.2, color:Lerp(cream, .8), 1.6, -29, .42), 0)
        rect(root, 35, 17, 4.4, 4.4, white, 2.2, 0, .2)
        return root, zoom
    end)

    local bonbon = LPH_NO_VIRTUALIZE(function(parent, color)
        local root, zoom = candyRoot(parent, "WrappedSweet", 82, 54)
        local white, light = Color3.new(1, 1, 1), color:Lerp(cream, .5)
        for _, side in ipairs({-1, 1}) do
            for _, flap in ipairs({-1, 1}) do
                local petal = rect(root, 41 + side * 27, 27 + flap * 5, 21, 13,
                    light, 6.5, side * flap * 28)
                shade(petal, cream, light, color:Lerp(cherry, .15), 80)
            end
            gloss(rect(root, 41 + side * 29, 26, 12, 1.6, white, .8, side * 4, .3))
        end
        rect(root, 42.5, 29.5, 43, 31, cherry, 15.5, 0, .83)
        local middle = rect(root, 41, 27, 44, 31, color, 15.5)
        shade(middle, light, color, color:Lerp(cherry, .46), 75)
        edge(middle, color:Lerp(cream, .66), .85, .22)
        gloss(rect(root, 33, 26, 4, 24, cream, 2, -15, .23), 90)
        gloss(rect(root, 45.5, 26, 4, 24, cream, 2, -15, .23), 90)
        gloss(rect(root, 38, 18.5, 23, 5, white, 2.5, -9, .22))
        return root, zoom
    end)

    local gumdrop = LPH_NO_VIRTUALIZE(function(parent, color)
        local root, zoom = candyRoot(parent, "JellySweet", 54, 44)
        local white = Color3.new(1, 1, 1)
        rect(root, 28.8, 24.5, 36, 27, cherry, 13.5, -23, .84)
        local body = rect(root, 27, 22, 37, 28, color, 14, -23)
        shade(body, color:Lerp(cream, .68), color, color:Lerp(cherry, .38), 60)
        edge(body, color:Lerp(cream, .68), .8, .18)
        gloss(rect(root, 21, 16, 16, 5, white, 2.5, -25, .2))
        rect(root, 17, 18.5, 3, 3, white, 1.5, 0, .2)
        return root, zoom
    end)

    local easeBack = LPH_NO_VIRTUALIZE(function(value)
        local t = math.clamp(value, 0, 1) - 1
        return 1 + 2.45 * t * t * t + 1.45 * t * t
    end)

    local function fit()
        local camera = workspace.CurrentCamera
        if camera then viewport = camera.ViewportSize end
        if scaleObject then
            scaleObject.Scale = math.max(.2, math.min((viewport.X - 24) / 600, (viewport.Y - 60) / 360, 1.1))
        end
    end

    local ok, errorMessage = pcall(function()
        overlay = make("ScreenGui", nil, {
            Name = "CandyIntro",
            ResetOnSpawn = false,
            IgnoreGuiInset = true,
            DisplayOrder = 1000000,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        })
        if syn and syn.protect_gui then pcall(syn.protect_gui, overlay) end
        local attached = false
        if type(gethui) == "function" then
            attached = pcall(function() overlay.Parent = gethui(); assert(overlay.Parent) end)
        end
        if not attached then attached = pcall(function() overlay.Parent = game:GetService("CoreGui") end) end
        if not attached then
            overlay.Parent = players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
            if not overlay.Parent then error("PlayerGui unavailable") end
        end

        backdrop = make("Frame", overlay, {
            Name = "CandyBackdrop", Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.fromRGB(24, 13, 34),
            BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 0,
            Active = false,
        })

        local canvas = make("Frame", overlay, {
            Name = "CandyStage",
            AnchorPoint = Vector2.new(.5, .5),
            Position = UDim2.fromScale(.5, .47),
            Size = UDim2.fromOffset(600, 360),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Active = false,
            ClipsDescendants = false,
        })
        scaleObject = make("UIScale", canvas, {Scale = 1})
        local function watchCamera()
            fit()
            local camera = workspace.CurrentCamera
            if camera then connect(camera:GetPropertyChangedSignal("ViewportSize"), fit) end
        end
        watchCamera()
        connect(workspace:GetPropertyChangedSignal("CurrentCamera"), watchCamera)

        local font = Enum.Font.GothamBlack
        pcall(function() font = Enum.Font.FredokaOne end)
        local function glyph(character, x, y, size, color, delay, index)
            local root, zoom = candyRoot(canvas, "CandyLetter" .. character .. index, 118, 126)
            root.ZIndex = 6
            local common = {
                AnchorPoint = Vector2.new(.5, .5),
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Font = font,
                Text = character,
                TextSize = size,
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center,
                ZIndex = 6,
            }
            local shadow = make("TextLabel", root, common)
            shadow.Name = "CandyShadow"
            shadow.Position = UDim2.new(.5, 1, .5, 6)
            shadow.TextColor3 = cherry
            shadow.TextStrokeColor3 = cherry
            shadow.TextStrokeTransparency = .46
            shadow.TextTransparency = .28
            local depth = make("TextLabel", root, common)
            depth.Name = "CandyDepth"
            depth.Position = UDim2.new(.5, .6, .5, 3.4)
            depth.TextColor3 = color:Lerp(cherry, .42)
            depth.TextStrokeColor3 = color:Lerp(cherry, .42)
            depth.TextStrokeTransparency = .18
            local glow = make("TextLabel", root, common)
            glow.Name = "CandyGlow"
            glow.Position = UDim2.fromScale(.5, .5)
            glow.TextColor3 = color
            glow.TextTransparency = .92
            glow.ZIndex = 5
            local glowStroke = make("UIStroke", glow, {
                Color = color:Lerp(cream, .18), Thickness = size >= 80 and 9 or 6,
                Transparency = .84, ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
            })
            local outline = make("TextLabel", root, common)
            outline.Name = "SugarOutline"
            outline.Position = UDim2.fromScale(.5, .5)
            outline.TextColor3 = cream
            local outlineStroke = make("UIStroke", outline, {
                Color = cream, Thickness = size >= 80 and 2.8 or 2,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
            })
            local face = make("TextLabel", root, common)
            face.Name = "CandyFace"
            face.Position = UDim2.fromScale(.5, .5)
            face.TextColor3 = Color3.fromRGB(255, 255, 255)
            local highlight = color:Lerp(cream, .58)
            make("UIGradient", face, {
                Rotation = 90,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, color:Lerp(cream, .84)),
                    ColorSequenceKeypoint.new(.28, highlight),
                    ColorSequenceKeypoint.new(.5, color:Lerp(cream, .18)),
                    ColorSequenceKeypoint.new(.56, color),
                    ColorSequenceKeypoint.new(1, color:Lerp(cherry, .24)),
                }),
            })
            local shine = make("TextLabel", root, common)
            shine.Name = "SugarShimmer"
            shine.Position = UDim2.fromScale(.5, .5)
            shine.TextColor3 = cream
            shine.ZIndex = 7
            local sweep = make("UIGradient", shine, {
                Rotation = 22,
                Offset = Vector2.new(-1.4, 0),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(.38, 1),
                    NumberSequenceKeypoint.new(.49, .08),
                    NumberSequenceKeypoint.new(.6, 1),
                    NumberSequenceKeypoint.new(1, 1),
                }),
            })
            letters[#letters + 1] = {
                root = root, zoom = zoom, x = x, y = y, delay = delay, index = index,
                face = face, outline = outline, shadow = shadow, depth = depth, stroke = outlineStroke,
                glow = glow, glowStroke = glowStroke, shine = shine, sweep = sweep,
            }
        end

        local title = "CANDY"
        local titleColors = {pink, peach, mint, purple, pink}
        for i = 1, #title do glyph(title:sub(i, i), (i - 3) * 75, -18, 96, titleColors[i], .64 + (i - 1) * .075, i) end
        local subtitle = "HUB"
        local subtitleColors = {mint, pink, purple}
        for i = 1, #subtitle do glyph(subtitle:sub(i, i), (i - 2) * 49, 78, 56, subtitleColors[i], 1.1 + (i - 1) * .07, i + 5) end

        local layout = {
            {"pop", -244, -69, -150, -18, .76, -22, 1},
            {"wrap", -127, -123, -75, -18, .82, 18, 4},
            {"jelly", -22, -137, 0, -18, .95, -12, 2},
            {"pop", 148, -116, 75, -18, .72, 24, 3},
            {"wrap", 253, -36, 150, -18, .84, -16, 1},
            {"jelly", 258, 55, 150, -18, .94, 17, 4},
            {"pop", 183, 127, 48, 78, .67, 28, 2},
            {"wrap", 74, 145, 0, 78, .74, -14, 3},
            {"jelly", -38, 135, -48, 78, .86, 18, 1},
            {"pop", -160, 115, -48, 78, .68, -29, 4},
            {"wrap", -260, 20, -150, -18, .80, 12, 2},
            {"jelly", -255, 105, -75, -18, .90, -19, 3},
        }
        for index, item in ipairs(layout) do
            local factory = item[1] == "pop" and lollipop or item[1] == "wrap" and bonbon or gumdrop
            local root, zoom = factory(canvas, palette[item[8]])
            candies[#candies + 1] = {
                root = root, zoom = zoom, x = item[2], y = item[3], ox = item[4], oy = item[5],
                scale = item[6] * (item[1] == "pop" and .8 or 1), angle = item[7], delay = 1.05 + (index - 1) * .055, index = index,
            }
        end

        for i = 1, 20 do
            local angle = (i - 1) * math.pi * 2 / 20
            local root, zoom = candyRoot(canvas, "SugarSparkle" .. i, 22, 22)
            local color = i % 3 == 0 and palette[(i % 4) + 1] or cream
            if i % 4 == 0 then
                rect(root, 11, 11, 2.4, 18, color, 1.2, 0, .05, 2)
                rect(root, 11, 11, 18, 2.4, color, 1.2, 0, .05, 2)
            else
                rect(root, 11, 11, i % 2 == 0 and 4 or 6, i % 2 == 0 and 9 or 6, color, 2, 25, .08, 2)
            end
            sparkles[#sparkles + 1] = {
                root = root, zoom = zoom, x = math.cos(angle) * (213 + (i % 3) * 13),
                y = math.sin(angle) * (128 + (i % 2) * 12), phase = i * .73,
            }
        end
        -- Each effect is created once and reused throughout the ten-second scene.
        orbit, orbitZoom = candyRoot(canvas, "SugarOrbit", 600, 360)
        orbit.Position = UDim2.fromOffset(300, 180)
        orbit.ZIndex = 1
        local previousX, previousY = 300 + 226, 198
        for i = 1, 56 do
            local angle = i * math.pi * 2 / 56
            local x, y = 300 + math.cos(angle) * 226, 198 + math.sin(angle) * 93
            local dx, dy = x - previousX, y - previousY
            rect(orbit, (x + previousX) * .5, (y + previousY) * .5,
                math.sqrt(dx * dx + dy * dy) + 1, 1.7,
                palette[(math.floor(i / 14) % 4) + 1]:Lerp(cream, .52),
                .85, math.deg(math.atan2(dy, dx)), .64, 1)
            previousX, previousY = x, y
        end
        for i = 1, 5 do
            local root, zoom = candyRoot(canvas, "CandyRipple" .. i, 192, 192)
            root.Position = UDim2.fromOffset(300, 190)
            root.ZIndex = 1
            make("UICorner", root, {CornerRadius = UDim.new(1, 0)})
            local line = edge(root, palette[((i - 1) % 4) + 1]:Lerp(cream, .3), i % 2 == 0 and 3.5 or 2, 1)
            ripples[#ripples + 1] = {root = root, zoom = zoom, line = line, delay = (i - 1) * .075}
        end
        for i = 1, 6 do
            local size = 9 + (i % 3) * 5
            local root, zoom = candyRoot(canvas, "SugarBubble" .. i, size, size)
            root.BackgroundColor3 = palette[(i % 4) + 1]
            root.BackgroundTransparency = .94
            root.ZIndex = 1
            make("UICorner", root, {CornerRadius = UDim.new(1, 0)})
            local rim = edge(root, palette[(i % 4) + 1]:Lerp(cream, .55), 1.1, .45)
            bubbles[#bubbles + 1] = {root = root, zoom = zoom, rim = rim, index = i, phase = i * 1.17}
        end
        for i = 1, 28 do
            local root, zoom = candyRoot(canvas, "CandyConfetti" .. i, 24, 24)
            root.ZIndex = 2
            local color = palette[(i % 4) + 1]:Lerp(cream, .12)
            local pieces = {}
            if i % 5 == 0 then
                pieces[#pieces + 1] = rect(root, 12, 14, 10, 10, color, 1, 45, 0, 2)
                pieces[#pieces + 1] = rect(root, 8.5, 10, 10, 10, color, 5, 0, 0, 2)
                pieces[#pieces + 1] = rect(root, 15.5, 10, 10, 10, color, 5, 0, 0, 2)
            else
                pieces[#pieces + 1] = rect(root, 12, 12, i % 2 == 0 and 4 or 6,
                    i % 2 == 0 and 11 or 6, color, 2, 0, 0, 2)
            end
            local direction = ((i * 37) % 19) / 9 - 1
            confetti[#confetti + 1] = {
                root = root, zoom = zoom, pieces = pieces, index = i,
                x = ((i - 1) % 5 - 2) * 46, y = i % 3 == 0 and 52 or -12,
                vx = direction * 148, vy = -100 - (i % 4) * 29,
                delay = 1.1 + (i % 7) * .09,
            }
        end

        -- A single illustrated hero prop opens the scene and returns for the finale.
        hero, heroZoom = lollipop(canvas, pink, true)
        hero.Name = "CandyHero"
        hero.ZIndex = 8

        for i = 1, 12 do
            local root, zoom = candyRoot(canvas, "SugarRay" .. i, 164, 10)
            root.ZIndex = 1
            local beam = rect(root, 82, 5, 164, i % 3 == 0 and 6 or 3,
                palette[(i % 4) + 1]:Lerp(cream, .52), 3, 0, .08, 1)
            make("UIGradient", beam, {
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(.3, .35),
                    NumberSequenceKeypoint.new(.6, .03),
                    NumberSequenceKeypoint.new(1, 1),
                }),
            })
            rays[#rays + 1] = {root = root, zoom = zoom, beam = beam, angle = (i - 1) * math.pi * 2 / 12}
        end
        for i = 1, 4 do
            local root, zoom = candyRoot(canvas, "ShootingSugar" .. i, 124, 28)
            root.ZIndex = 4
            local color = palette[i]:Lerp(cream, .4)
            local tail = rect(root, 57, 14, 108, 3, color, 1.5, 0, .1, 4)
            make("UIGradient", tail, {
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(.7, .42),
                    NumberSequenceKeypoint.new(1, .05),
                }),
            })
            rect(root, 111, 14, 3, 22, cream, 1.5, 0, 0, 4)
            rect(root, 111, 14, 22, 3, cream, 1.5, 0, 0, 4)
            comets[#comets + 1] = {root = root, zoom = zoom, index = i, delay = .08 + (i - 1) * .12}
        end

        loading = make("Frame", canvas, {
            Name = "CandyLoading", AnchorPoint = Vector2.new(.5, .5),
            Position = UDim2.fromOffset(300, 180), Size = UDim2.fromOffset(210, 76),
            BackgroundTransparency = 1, ZIndex = 8,
        })
        make("TextLabel", loading, {
            Name = "CandyLoadingLabel", Position = UDim2.fromOffset(0, 0),
            Size = UDim2.fromOffset(210, 30), BackgroundTransparency = 1,
            Font = font, Text = "CANDY HUB", TextSize = 23, TextColor3 = cream,
            TextStrokeColor3 = cherry, TextStrokeTransparency = .3, ZIndex = 8,
        })
        loadingDots = {}
        for i = 1, 3 do loadingDots[i] = rect(loading, 80 + (i - 1) * 25, 49, 8, 8, palette[i], 4, 0, 0, 8) end
        hint = make("TextLabel", canvas, {
            Name = "SkipHint",
            AnchorPoint = Vector2.new(.5, .5),
            Position = UDim2.fromOffset(300, 352),
            Size = UDim2.fromOffset(280, 20),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamMedium,
            Text = "DOBLE TOQUE PARA SALTAR",
            TextSize = 10,
            TextColor3 = cream,
            TextTransparency = .34,
            TextStrokeColor3 = cherry,
            TextStrokeTransparency = .35,
            ZIndex = 7,
            Visible = false,
        })

        local lastTap, presses = nil, {}
        connect(input.InputBegan, function(event)
            if event.UserInputType == Enum.UserInputType.Touch or event.UserInputType == Enum.UserInputType.MouseButton1 then
                presses[event] = {position = event.Position, time = os.clock()}
            end
        end)
        connect(input.InputEnded, function(event)
            local press = presses[event]
            presses[event] = nil
            if not press or not state.Active then return end
            local now = os.clock()
            if now - press.time > .35 or (event.Position - press.position).Magnitude > 12 then return end
            if lastTap and now - lastTap <= .4 then finish() else lastTap = now end
        end)

        local elapsedSinceDraw, beat = 0, 0
        connect(run.RenderStepped, LPH_NO_VIRTUALIZE(function(dt)
            if not state.Active then return end
            local now = os.clock()
            if not state.Started then
                for i, dot in ipairs(loadingDots) do
                    dot.Position = UDim2.fromOffset(80 + (i - 1) * 25, 49 + math.sin(now * 5 - i) * 4)
                end
                return
            end
            local elapsed = now - startedAt
            if elapsed >= state.Duration then finish(); return end
            elapsedSinceDraw = elapsedSinceDraw + dt
            if elapsedSinceDraw < 1 / 30 then return end
            elapsedSinceDraw = elapsedSinceDraw % (1 / 30)
            local outro = math.clamp((elapsed - (state.Duration - .8)) / .8, 0, 1)
            local visibility = 1 - outro * outro
            local impactAge = 100
            for _, impactAt in ipairs(IMPACTS) do
                if elapsed >= impactAt then impactAge = math.min(impactAge, elapsed - impactAt) end
            end
            local kick = math.max(0, 1 - impactAge / .38) ^ 2
            local victory = math.sin(math.clamp((elapsed - 7.85) / 1.4, 0, 1) * math.pi) * .08
            backdrop.BackgroundTransparency = 1 - .38 * math.clamp(elapsed / .5, 0, 1) * (1 - outro)
            canvas.Position = UDim2.new(.5, math.sin(impactAge * 66) * kick * 1.4,
                .47, math.cos(impactAge * 71) * kick * 1.1)
            canvas.Rotation = math.sin(elapsed * .8) * .25 + math.sin(impactAge * 55) * kick * .2
            local loudness = music and state.AudioPlaying and (tonumber(music.PlaybackLoudness) or 0) or 0
            local targetBeat = math.clamp(loudness / 430, 0, 1)
            beat = beat + (targetBeat - beat) * .22
            local softPulse = .5 + .5 * math.sin(elapsed * 3.4)
            local glowPulse = math.max(beat, softPulse * .3, kick * .85)
            if music and state.AudioPlaying then music.Volume = .72 * (1 - outro) end
            hero.Visible = false
            if elapsed >= .06 and elapsed < 1.46 then
                local grow = math.clamp((elapsed - .06) / .62, 0, 1)
                local leave = math.clamp((elapsed - .91) / .55, 0, 1)
                local sweep = leave * leave * (3 - 2 * leave)
                hero.Visible = true
                hero.ZIndex = 8
                hero.Position = UDim2.fromOffset(300 + sweep * 228, 208 - sweep * 120)
                hero.Rotation = -24 + grow * 22 + sweep * 32 + math.sin(elapsed * 2.2) * 3
                heroZoom.Scale = math.max(.001, easeBack(grow) * 2.75 * (1 - sweep))
            elseif elapsed >= 7.85 and elapsed < 9.7 then
                local arrive = math.clamp((elapsed - 7.85) / .55, 0, 1)
                hero.Visible = true
                hero.ZIndex = 4
                hero.Position = UDim2.fromOffset(300 + math.sin(elapsed * 2) * 11,
                    77 - (1 - easeBack(arrive)) * 95 - outro * 30)
                hero.Rotation = -13 + math.sin(elapsed * 1.8) * 10 + (1 - arrive) * 32
                heroZoom.Scale = math.max(.001, easeBack(arrive) * 1.2 * visibility * (1 + kick * .06))
            end
            for _, letter in ipairs(letters) do
                local progress = math.clamp((elapsed - letter.delay) / .68, 0, 1)
                local pop = easeBack(progress)
                letter.root.Visible = progress > 0 and visibility > .01
                if letter.root.Visible then
                    local travel = (1 - progress) ^ 2
                    local angle = letter.index * 1.08 + (1 - progress) * 4
                    local float = math.sin(elapsed * 2.1 + letter.index * .8) * (2.5 + glowPulse) * progress
                    local x = letter.x + math.cos(angle) * 330 * travel
                    local y = letter.y + math.sin(angle) * 155 * travel + (1 - pop) * 60 + float
                    local collapse = 1 - outro * outro
                    letter.root.Position = UDim2.fromOffset(300 + x * collapse + math.sin(letter.index + outro * 4) * outro * 13,
                        180 + y * collapse - outro * 38)
                    local sign = letter.index % 2 == 0 and 1 or -1
                    letter.root.Rotation = sign * ((1 - progress) * 110 + math.sin(elapsed * 1.5 + letter.index) * 1.8 + outro * 105)
                    letter.zoom.Scale = math.max(.001, pop * visibility * (1 + glowPulse * .035 + kick * .045 + victory))
                    letter.sweep.Offset = Vector2.new(((elapsed * .39 - letter.index * .045) % 1) * 2.8 - 1.4, 0)
                    letter.glowStroke.Transparency = 1 - (.18 + glowPulse * .3) * (1 - outro)
                    letter.glow.TextTransparency = 1 - (.09 + glowPulse * .09) * (1 - outro)
                    letter.shine.TextTransparency = .03 + .97 * outro
                    if outro > 0 then
                        letter.face.TextTransparency = outro
                        letter.outline.TextTransparency = outro
                        letter.stroke.Transparency = outro
                        letter.shadow.TextTransparency = .28 + .72 * outro
                        letter.shadow.TextStrokeTransparency = .46 + .54 * outro
                        letter.depth.TextTransparency = outro
                        letter.depth.TextStrokeTransparency = .18 + .82 * outro
                    end
                end
            end
            for _, candy in ipairs(candies) do
                local age = elapsed - candy.delay
                local phase = age >= 0 and age % 3.35 or -1
                local visible = phase >= 0 and phase < 3.12 and visibility > .01
                candy.root.Visible = visible
                if visible then
                    local flight = math.clamp(phase / .84, 0, 1)
                    local ease = 1 - (1 - flight) ^ 3
                    local escape = math.clamp((phase - 2.25) / .65, 0, 1)
                    local drift = escape * escape * .75
                    local dx = candy.x - candy.ox
                    local dy = candy.y - candy.oy
                    local x = candy.ox + dx * ease + candy.x * drift + math.sin(elapsed * 1.6 + candy.index) * 8 * ease
                    local y = candy.oy + dy * ease - math.sin(flight * math.pi) * 33 + candy.y * drift
                        + math.sin(elapsed * 1.9 + candy.index * .7) * 8 * ease - outro * 35
                    candy.root.Position = UDim2.fromOffset(300 + x, 180 + y)
                    candy.root.Rotation = candy.angle * ease + (1 - flight) * (candy.index % 2 == 0 and 42 or -42)
                        + math.sin(elapsed * 1.4 + candy.index) * 8 + escape * 48
                    candy.zoom.Scale = math.max(.001, candy.scale * easeBack(flight) * (1 - escape) * visibility * (1 + glowPulse * .075))
                end
            end
            for _, sparkle in ipairs(sparkles) do
                local entrance = math.clamp((elapsed - .4) / .7, 0, 1)
                local pulse = .32 + .68 * math.max(0, math.sin(elapsed * 2.2 + sparkle.phase))
                sparkle.root.Visible = entrance > 0 and visibility > .01
                sparkle.root.Position = UDim2.fromOffset(300 + sparkle.x + math.sin(elapsed + sparkle.phase) * 7,
                    180 + sparkle.y + math.cos(elapsed * 1.3 + sparkle.phase) * 6)
                sparkle.root.Rotation = math.sin(elapsed * .8 + sparkle.phase) * 25
                sparkle.zoom.Scale = math.max(.001, pulse * entrance * visibility * (1 + kick * .4))
            end
            local orbitIn = math.clamp((elapsed - .32) / 1.2, 0, 1)
            orbit.Visible = orbitIn > 0 and visibility > .01
            orbit.Rotation = -18 + math.sin(elapsed * .85) * 14 + outro * 55
            orbitZoom.Scale = math.max(.001, easeBack(orbitIn) * visibility * (1 + glowPulse * .065 + victory))
            for _, ripple in ipairs(ripples) do
                local age = impactAge - ripple.delay
                local progress = math.clamp(age / 1.25, 0, 1)
                ripple.root.Visible = age >= 0 and age < 1.25 and visibility > .01
                ripple.zoom.Scale = .45 + progress * 2.65
                ripple.line.Transparency = 1 - .25 * (1 - progress) * visibility
            end
            for _, bubble in ipairs(bubbles) do
                local entrance = math.clamp((elapsed - .8) / .8, 0, 1)
                local side = bubble.index % 2 == 0 and 1 or -1
                local x = side * (218 + math.sin(elapsed * .7 + bubble.phase) * 36)
                local y = 150 - ((elapsed * 22 + bubble.index * 41) % 300)
                bubble.root.Visible = entrance > 0 and visibility > .01
                bubble.root.Position = UDim2.fromOffset(300 + x, 180 + y)
                bubble.zoom.Scale = math.max(.001, entrance * visibility * (.9 + .16 * math.sin(elapsed + bubble.phase)))
                bubble.rim.Transparency = .5 + .22 * (1 - visibility)
            end
            for _, particle in ipairs(confetti) do
                local age = elapsed - particle.delay
                local phase = age >= 0 and age % 3.2 or -1
                local live = phase >= 0 and phase < 2.08 and visibility > .01
                particle.root.Visible = live
                if live then
                    local fade = math.clamp((phase - 1.28) / .8, 0, 1)
                    local entrance = math.clamp(phase / .14, 0, 1)
                    local surge = elapsed > 7.8 and 1.2 or 1
                    particle.root.Position = UDim2.fromOffset(300 + particle.x + particle.vx * phase * surge,
                        180 + particle.y + particle.vy * phase * surge + 100 * phase * phase)
                    particle.root.Rotation = particle.index * 23 + phase * (particle.index % 2 == 0 and 175 or -175)
                    particle.zoom.Scale = math.max(.001, (.74 + particle.index % 3 * .15) * entrance * visibility)
                    for _, piece in ipairs(particle.pieces) do piece.BackgroundTransparency = .12 + .88 * math.max(fade, outro) end
                end
            end
            for _, ray in ipairs(rays) do
                local progress = math.clamp(impactAge / .9, 0, 1)
                local angle = ray.angle + elapsed * .07
                local power = math.sin(progress * math.pi) ^ .7
                ray.root.Visible = impactAge >= 0 and impactAge < .9 and visibility > .01
                ray.root.Position = UDim2.fromOffset(300 + math.cos(angle) * (95 + progress * 160),
                    188 + math.sin(angle) * (60 + progress * 105))
                ray.root.Rotation = math.deg(angle)
                ray.zoom.Scale = math.max(.001, power * visibility * (1 + victory) * .72)
                ray.beam.BackgroundTransparency = .5 + .5 * progress
            end
            for _, comet in ipairs(comets) do
                local age = elapsed - comet.delay
                local phase = age >= 0 and age % 3.6 or -1
                local p = math.clamp(phase / .95, 0, 1)
                comet.root.Visible = phase >= 0 and phase < .95 and visibility > .01
                if comet.root.Visible then
                    local side = comet.index % 2 == 0 and 1 or -1
                    local startX = side * (340 + comet.index * 10)
                    local endX = -side * 200
                    local startY = -115 + comet.index * 27
                    local endY = 50 + comet.index * 12
                    local x = startX + (endX - startX) * p
                    local y = startY + (endY - startY) * p - math.sin(p * math.pi) * 65
                    local dy = endY - startY - math.cos(p * math.pi) * math.pi * 65
                    comet.root.Position = UDim2.fromOffset(300 + x, 180 + y)
                    comet.root.Rotation = math.deg(math.atan2(dy, endX - startX))
                    comet.zoom.Scale = math.max(.001, math.sin(p * math.pi) * .85 * visibility)
                end
            end
            hint.Visible = elapsed >= 1.45 and outro < .94
            hint.TextTransparency = .34 + .66 * outro
            hint.TextStrokeTransparency = .35 + .65 * outro
        end))

        -- Wait for the MP3 before starting the ten-second scene, including on a cold cache.
        local audioTimeout = task.delay(12, function()
            if state.Active and not state.Started then
                state.AudioError = "Audio loading timeout"
                begin(false)
            end
        end)
        threads[#threads + 1] = audioTimeout
        local audioThread = task.spawn(function()
            local audioOK, audioError = pcall(function()
                local env = type(getgenv) == "function" and getgenv() or _G
                local assetFn = getcustomasset or getsynasset or (syn and (syn.getcustomasset or syn.getsynasset)) or env.getcustomasset or env.getsynasset
                local write = writefile or env.writefile
                local exists = isfile or env.isfile
                if type(assetFn) ~= "function" or type(write) ~= "function" then
                    error("El executor no permite reproducir MP3 locales")
                end
                local cached = false
                if type(exists) == "function" then
                    local ok, value = pcall(exists, MUSIC_FILE)
                    cached = ok and value == true
                end
                if not cached then
                    local body
                    local requestFn = request or http_request or (syn and syn.request) or (fluxus and fluxus.request) or env.request
                    if type(requestFn) == "function" then
                        pcall(function()
                            local response = requestFn({Url = MUSIC_URL, Method = "GET"})
                            local status = response and tonumber(response.StatusCode or response.status_code or response.Status)
                            if response and (not status or status >= 200 and status < 300) then body = response.Body or response.body end
                        end)
                    end
                    if type(body) ~= "string" or #body < 512 then body = game:HttpGet(MUSIC_URL, true) end
                    if not state.Active or state.Started then return end
                    local head = type(body) == "string" and body:sub(1, 256):lower() or ""
                    if type(body) ~= "string" or #body < 512 or head:find("<html", 1, true)
                        or head:find("<!doctype", 1, true) then error("No se pudo descargar la cancion") end
                    local result = write(MUSIC_FILE, body)
                    if result == false then error("No se pudo preparar el audio") end
                end
                if not state.Active or state.Started then return end
                local asset = assetFn(MUSIC_FILE)
                if type(asset) ~= "string" or asset == "" then error("MP3 no compatible con el executor") end
                if not state.Active or state.Started then return end
                music = make("Sound", soundService, {
                    Name = "CandyIntroMusic", SoundId = asset, Volume = .72,
                    Looped = false, PlayOnRemove = false, TimePosition = 0,
                })
                if music.IsLoaded then begin(true); return end
                connect(music.Loaded, function()
                    if state.Active and not state.Started then begin(true) end
                end)
                pcall(function() game:GetService("ContentProvider"):PreloadAsync({music}) end)
                if state.Active and not state.Started and music and music.IsLoaded then begin(true) end
            end)
            if not audioOK and state.Active and not state.Started then
                state.AudioError = tostring(audioError)
                warn("[Candy] " .. state.AudioError)
                begin(false)
            end
        end)
        threads[#threads + 1] = audioThread
    end)
    if not ok then finish(); warn("[Candy] Intro: " .. tostring(errorMessage)) end
end



if _G.KillHubRunning then pcall(function()if _G.KillHub and type(_G.KillHub.StopAll)=="function"then _G.KillHub.StopAll()end end)end _G.KillHubRunning=true local Players=game:GetService("Players")local RunService=game:GetService("RunService")local UIS=game:GetService("UserInputService")local TS=game:GetService("TweenService")local Lighting=game:GetService("Lighting")local HS=game:GetService("HttpService")local ReplicatedStorage=game:GetService("ReplicatedStorage")local LP=Players.LocalPlayer local camera=workspace.CurrentCamera local ContentProvider=game:GetService("ContentProvider")local SoundService=game:GetService("SoundService")local uiVisual
local CONFIG_FILE="Blessvs_Config_v2.json"local CONFIG_BACKUP="Blessvs_Config_v2.bak"local KEYBINDS_FILE="Blessvs_Keybinds_v2.json"local settingsReady=false local savingSettings=false local pendingSave=false local startupConfigLoaded=false local startupConfigSource=nil local uiPreferences={visible=true,tab="Moment",sectionsMode="Selector",sectionsVersion=1,scroll={},mainPosition={XScale=0,XOffset=20,YScale=0,YOffset=2}}local refreshUIPreferences=nil uiVisual={
 backgrounds={"rbxassetid://75705611324733","rbxassetid://79618294276392","rbxassetid://96186971632606"},
 backgroundIndex=3,hideBackgrounds=false,backgroundDarkness=38,wordDarkness=0,
 backgroundColors={Color3.fromRGB(65,170,255),Color3.fromRGB(255,91,169),Color3.fromRGB(255,101,182)},
 backgroundColorIndex=3,
 nameLogos={"rbxassetid://70897673370846","rbxassetid://80239012382507","rbxassetid://96462793057753"},
 nameLogoNames={"Blue","Pink","Candy"},normalNameLogo="rbxassetid://96462793057753",nameLogoIndex=3,
 normalBackgroundIndices={1,2,3},normalBackgroundIndex=3,
 nameColors={Color3.fromRGB(65,170,255),Color3.fromRGB(255,91,169),Color3.fromRGB(255,101,182)},
 nameColorIndex=3,fontName="GothamBold",stealBarFPS=20,fontSelectorLabel=nil,
 fontItems={},tweens=setmetatable({},{__mode="k"}),}do if type(_G.__BlessPerformanceCleanup)=="function"then pcall(_G.__BlessPerformanceCleanup)end _G.__BlessPerformanceCleanup=nil uiVisual.performanceMode=false local state={enabled=false,connections={},effects=setmetatable({},{__mode="k"}),glows=setmetatable({},{__mode="k"}),lastFPS=nil,watched=setmetatable({},{__mode="k"}),}local function finiteNumber(value)return type(value)=="number"and value==value and math.abs(value)<math.huge end local function refreshStatus()if uiVisual.performanceVisual and(state.visualSetter~=uiVisual.performanceVisual or state.visualValue~=uiVisual.performanceMode)then state.visualSetter,state.visualValue=uiVisual.performanceVisual,uiVisual.performanceMode uiVisual.performanceVisual(uiVisual.performanceMode)end local label=state.label if label and label.Parent then label.Parent.Visible=uiVisual.performanceMode local fps=state.lastFPS and tostring(state.lastFPS)or"--"label.Text="FPS "..fps..(state.capApplied and"  •  Target 120"or"  •  Optimized")end end function uiVisual.decorInterval(default)return uiVisual.performanceMode and math.max(default,1/20)or default end function uiVisual.getPerformanceShadowBaseline()if state.enabled then return state.previousShadows end return nil end function uiVisual.updatePerformanceShadowBaseline(value)if state.enabled and type(value)=="boolean"then state.previousShadows=value end end function uiVisual.registerPerformanceGlow(object)if not object or state.glows[object]then return end state.glows[object]={enabled=object.Enabled}if state.enabled then object.Enabled=false end end local function reduceEffect(object)if not state.enabled or state.effects[object]then return end if not(object:IsA("BloomEffect")or object:IsA("BlurEffect")or object:IsA("DepthOfFieldEffect")or object:IsA("SunRaysEffect"))then return end local saved={enabled=object.Enabled}state.effects[object]=saved saved.connection=object:GetPropertyChangedSignal("Enabled"):Connect(function()if state.enabled and object.Enabled then saved.enabled=true object.Enabled=false end end)object.Enabled=false end local function watchEffects(container)if not container or state.watched[container]then return end state.watched[container]=true state.connections[#state.connections+1]=container.DescendantAdded:Connect(function(object)task.defer(function()if state.enabled then pcall(reduceEffect,object)end end)end)for _,object in ipairs(container:GetDescendants())do pcall(reduceEffect,object)end end local function restoreMode()state.enabled=false for _,connection in ipairs(state.connections)do pcall(function()connection:Disconnect()end)end state.connections={}state.watched=setmetatable({},{__mode="k"})for object,saved in pairs(state.effects)do if saved.connection then pcall(function()saved.connection:Disconnect()end)end pcall(function()if not antiLagEnabled and object.Parent and object.Enabled==false then object.Enabled=saved.enabled end end)end state.effects=setmetatable({},{__mode="k"})for object,saved in pairs(state.glows)do pcall(function()if object.Parent and object.Enabled==false then object.Enabled=saved.enabled end end)end if state.settings and state.qualityApplied then pcall(function()if state.settings.SavedQualityLevel==Enum.SavedQualitySetting.QualityLevel1 then state.settings.SavedQualityLevel=state.previousQuality end end)end if state.lighting and state.previousShadows~=nil and not antiLagEnabled then pcall(function()if state.lighting.GlobalShadows==false then state.lighting.GlobalShadows=state.previousShadows end end)end if state.capApplied and state.capSetter and state.capGetter then pcall(function()if state.capGetter()==120 then state.capSetter(state.previousCap)end end)end state.capApplied=false state.capSetter,state.capGetter,state.previousCap=nil,nil,nil state.settings,state.previousQuality,state.qualityApplied=nil,nil,nil state.lighting,state.previousShadows=nil,nil end function uiVisual.setPerformance120(enabled)enabled=enabled==true uiVisual.performanceMode=enabled if state.enabled==enabled then refreshStatus()return end if enabled then state.enabled=true if type(setfpscap)=="function"and type(getfpscap)=="function"then local ok,previous=pcall(getfpscap)if ok and finiteNumber(previous)and previous>=0 then local applied,result=pcall(setfpscap,120)if applied and result~=false then state.capSetter,state.capGetter,state.previousCap=setfpscap,getfpscap,previous state.capApplied=true end end end pcall(function()local settings=UserSettings():GetService("UserGameSettings")local previous=settings.SavedQualityLevel if previous==nil then return end settings.SavedQualityLevel=Enum.SavedQualitySetting.QualityLevel1 state.settings,state.previousQuality,state.qualityApplied=settings,previous,true end)pcall(function()local lighting=game:GetService("Lighting")state.previousShadows=lighting.GlobalShadows state.lighting=lighting lighting.GlobalShadows=false state.connections[#state.connections+1]=lighting:GetPropertyChangedSignal("GlobalShadows"):Connect(function()if state.enabled and lighting.GlobalShadows then lighting.GlobalShadows=false end end)watchEffects(lighting)end)pcall(function()watchEffects(workspace.CurrentCamera)end)state.connections[#state.connections+1]=workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()if state.enabled then pcall(function()watchEffects(workspace.CurrentCamera)end)end end)for object,saved in pairs(state.glows)do pcall(function()if object.Parent then saved.enabled=object.Enabled;object.Enabled=false end end)end else restoreMode()end state.lastFPS=nil refreshStatus()end function uiVisual.bindPerformanceCounter(label)if state.counter then state.counter:Disconnect()end if state.counterDestroy then state.counterDestroy:Disconnect()end state.label=label local frames,elapsed=0,0 state.counter=game:GetService("RunService").RenderStepped:Connect(function(dt)if not uiVisual.performanceMode then frames,elapsed=0,0;return end frames=frames+1 elapsed=elapsed+dt if elapsed>=0.5 then state.lastFPS=math.floor(frames/elapsed+0.5)frames,elapsed=0,0 refreshStatus()end end)state.counterDestroy=label.Destroying:Connect(function()if state.label==label then if state.counter then state.counter:Disconnect();state.counter=nil end state.label=nil end end)refreshStatus()end _G.__BlessPerformanceCleanup=function()uiVisual.setPerformance120(false)if state.counter then state.counter:Disconnect();state.counter=nil end if state.counterDestroy then state.counterDestroy:Disconnect();state.counterDestroy=nil end state.label=nil end end function uiVisual.setStealBarFPS(value)local fps=tonumber(value)if not fps or fps~=fps or math.abs(fps)==math.huge or fps<1 then if uiVisual.stealBarFPSBox and uiVisual.stealBarFPSBox.Parent then uiVisual.stealBarFPSBox.Text=tostring(uiVisual.stealBarFPS)end return false end uiVisual.stealBarFPS=math.floor(fps+0.5)if uiVisual.stealBarFPSBox and uiVisual.stealBarFPSBox.Parent then uiVisual.stealBarFPSBox.Text=tostring(uiVisual.stealBarFPS)end if uiVisual.refreshStealBarFPS then uiVisual.refreshStealBarFPS()end return true end  function uiVisual.isNormalBackground(index)index=tonumber(index)if not index then return false end for _,value in ipairs(uiVisual.normalBackgroundIndices or{})do if value==index then return true end end return false end function uiVisual.getActiveBackgroundIndices()return uiVisual.normalBackgroundIndices end function uiVisual.normalizeWordID(value)
local number=tonumber(value)
if not number or number<1 or number>9007199254740991 or number~=math.floor(number)then return nil end
return string.format("%.0f",number)
end
function uiVisual.setWordOption(index)
index=tonumber(index)
if not index or index~=math.floor(index)or not uiVisual.nameLogos[index]then return false end
uiVisual.nameLogoIndex=index
uiVisual.normalNameLogo=uiVisual.nameLogos[index]
if uiVisual.refreshNameLogo then uiVisual.refreshNameLogo()end
return true
end
function uiVisual.getNameLogoAsset()return uiVisual.normalNameLogo end

function uiVisual.getCurrentNameLogoAsset()return uiVisual.getNameLogoAsset()end local resolvedImageCache={}local function resolveExactImageAsset(asset)if type(asset)~="string"or asset==""then return""end local id=asset:match("(%d+)")if not id then return asset end if not resolvedImageCache[id]then resolvedImageCache[id]="rbxthumb://type=Asset&id="..id.."&w=420&h=420"end return resolvedImageCache[id]end function uiVisual.getLogoColor()
    local darkness=math.clamp(tonumber(uiVisual.wordDarkness)or 0,0,100)/100
    return Color3.new(1,1,1):Lerp(Color3.fromRGB(0,0,0),darkness)
end
function uiVisual.setWordDarkness(value)
    uiVisual.wordDarkness=math.clamp(tonumber(value)or 0,0,100)
    if uiVisual.refreshNameLogo then uiVisual.refreshNameLogo()end
end
function uiVisual.tween(object,properties,duration)
 if not object or not object.Parent then return end
 for key,value in pairs(properties)do
  object[key]=value
 end
end
-- Candy Hub: every theme switches the background, logo and Auto Steal together.
uiVisual.colorNames={"Blue","Pink","Candy"}
uiVisual.colorSelectorLabel=nil
uiVisual.colorThemes={
 {name="Blue",background=uiVisual.backgrounds[1],word=uiVisual.nameLogos[1],autoSteal="rbxassetid://79319791884720",primary=Color3.fromRGB(78,166,212),secondary=Color3.fromRGB(111,202,218)},
 {name="Pink",background=uiVisual.backgrounds[2],word=uiVisual.nameLogos[2],autoSteal="rbxassetid://139615457490121",primary=Color3.fromRGB(221,111,161),secondary=Color3.fromRGB(240,162,192)},
 {name="Candy",background=uiVisual.backgrounds[3],word=uiVisual.nameLogos[3],autoSteal="rbxassetid://117863261045238",primary=Color3.fromRGB(235,120,168),secondary=Color3.fromRGB(97,192,212)},
}
uiVisual.themePalettes=uiVisual.colorThemes
for _,p in ipairs(uiVisual.themePalettes)do
 local white=Color3.new(1,1,1)
 p.light=p.primary:Lerp(white,.34)
 p.mid=p.primary:Lerp(p.secondary,.5):Lerp(Color3.fromRGB(55,56,68),.45)
 p.deep=Color3.fromRGB(16,18,25):Lerp(p.primary,.025)
 p.dark=p.deep
 p.ink=Color3.fromRGB(35,38,49):Lerp(p.primary,.06)
 p.surface=p.deep:Lerp(p.primary,.045)
 p.optionEdge=p.primary:Lerp(white,.24)
 p.inputSurface=p.surface:Lerp(p.primary,.25)
 p.optionGel=ColorSequence.new({
  ColorSequenceKeypoint.new(0,p.primary:Lerp(p.deep,.40)),
  ColorSequenceKeypoint.new(.5,p.primary:Lerp(p.secondary,.45):Lerp(p.deep,.44)),
  ColorSequenceKeypoint.new(1,p.secondary:Lerp(p.deep,.43)),
 })
 p.active=p.primary
 p.outline=p.primary:Lerp(p.deep,.64)
 p.text=Color3.fromRGB(235,239,246)
 p.gel=ColorSequence.new({
  ColorSequenceKeypoint.new(0,p.primary:Lerp(white,.08)),
  ColorSequenceKeypoint.new(.5,p.primary),
  ColorSequenceKeypoint.new(1,p.secondary:Lerp(p.deep,.18)),
 })
 p.toggleGel=ColorSequence.new({
  ColorSequenceKeypoint.new(0,p.primary:Lerp(p.deep,.06)),
  ColorSequenceKeypoint.new(.5,p.primary:Lerp(p.secondary,.4):Lerp(p.deep,.10)),
  ColorSequenceKeypoint.new(1,p.secondary:Lerp(p.deep,.14)),
 })
 p.floatOffGel=ColorSequence.new({
  ColorSequenceKeypoint.new(0,Color3.fromRGB(82,88,102):Lerp(p.primary,.22)),
  ColorSequenceKeypoint.new(1,Color3.fromRGB(64,70,84):Lerp(p.secondary,.22)),
 })
 p.selected=p.toggleGel
 p.searchInk=Color3.fromRGB(62,71,86):Lerp(p.primary,.24)
 p.searchGel=ColorSequence.new({
  ColorSequenceKeypoint.new(0,Color3.fromRGB(70,76,91):Lerp(p.primary,.26)),
  ColorSequenceKeypoint.new(1,Color3.fromRGB(59,71,85):Lerp(p.secondary,.26)),
 })
 p.sugar=ColorSequence.new({
  ColorSequenceKeypoint.new(0,p.surface:Lerp(p.primary,.035)),
  ColorSequenceKeypoint.new(1,p.surface),
 })
 p.offGel=ColorSequence.new({
  ColorSequenceKeypoint.new(0,p.primary:Lerp(p.deep,.58)),
  ColorSequenceKeypoint.new(1,p.secondary:Lerp(p.deep,.62)),
 })
 p.knobGel=ColorSequence.new({
  ColorSequenceKeypoint.new(0,p.primary:Lerp(white,.14)),
  ColorSequenceKeypoint.new(.46,p.primary),
  ColorSequenceKeypoint.new(1,p.primary:Lerp(p.deep,.28)),
 })
 p.floating={offBackground=p.surface,onBackground=p.active,offText=p.text,onText=white,
  offStroke=p.outline,onStroke=p.primary,onGradient=p.selected,offGradient=p.floatOffGel}
end

function uiVisual.selectThemeState(value)
    local index
    if type(value)=="string"then
        for i,name in ipairs(uiVisual.colorNames)do
            if string.lower(name)==string.lower(value)then index=i;break end
        end
    elseif type(value)=="number"and value==math.floor(value)then index=value end
    local theme=index and uiVisual.colorThemes[index]
    if not theme then return false end
    uiVisual.backgroundColorIndex=index
    uiVisual.backgroundIndex=index
    uiVisual.normalBackgroundIndex=index
    uiVisual.nameLogoIndex=index
    uiVisual.nameColorIndex=index
    uiVisual.normalNameLogo=theme.word
    uiVisual.hideBackgrounds=false
    return true
end
function uiVisual.getColorSelectorText()
 return uiVisual.colorNames[uiVisual.backgroundColorIndex]or"Candy"
end
function uiVisual.buildStealDecor(panel,badge) return function() end end
function uiVisual.getThemePalette()local index=math.clamp(math.floor(tonumber(uiVisual.backgroundColorIndex)or 1),1,#uiVisual.themePalettes)return uiVisual.themePalettes[index]or uiVisual.themePalettes[1]end do local ok,items=pcall(function()return Enum.Font:GetEnumItems()end)if ok and type(items)=="table"then for _,item in ipairs(items)do if item and item.Name~="Unknown"then table.insert(uiVisual.fontItems,item)end end end table.sort(uiVisual.fontItems,function(a,b)return string.lower(a.Name)<string.lower(b.Name)end)end function uiVisual.fontDisplayName(fontName)if fontName=="GothamBold"or fontName=="Original"then return"Original"end return tostring(fontName or"Original")end function uiVisual.resolveFont(fontName)if fontName=="Original"then fontName="GothamBold"end if type(fontName)~="string"or fontName==""then return nil end for _,item in ipairs(uiVisual.fontItems)do if item.Name==fontName then return item end end local ok,item=pcall(function()return Enum.Font[fontName]end)if ok and item and item.Name~="Unknown"then return item end return nil end function uiVisual.applyFont(fontName,shouldSave)local font=uiVisual.resolveFont(fontName)or Enum.Font.GothamBold uiVisual.fontName=font.Name if uiVisual.fontSelectorLabel and uiVisual.fontSelectorLabel.Parent then uiVisual.fontSelectorLabel.Text=uiVisual.fontDisplayName(font.Name).."  ▼"uiVisual.fontSelectorLabel.Font=font end local function applyObject(object)if not object or object:GetAttribute("FearFontPreview")==true then return end if object:IsA("TextLabel")or object:IsA("TextButton")or object:IsA("TextBox")then pcall(function()object.Font=font end)end end local seen={}local function applyRoot(root)if not root or seen[root]then return end seen[root]=true applyObject(root)for _,object in ipairs(root:GetDescendants())do applyObject(object)end end applyRoot(gui)applyRoot(MobilePanel)applyRoot(batV2FloatingButton)applyRoot(pbFrame)applyRoot(instaResetFloatingButton)applyRoot(bypassFloatingButton)if speedLabel and speedLabel.Parent then applyObject(speedLabel)end for _,label in pairs(enemySpeedLabels or{})do if label and label.Parent then applyObject(label)end end local char=LP and LP.Character local head=char and char:FindFirstChild("Head")local speedGui=head and(head:FindFirstChild("KillHubSpeedIndicator")or head:FindFirstChild("M4LWARESpeedIndicator"))if speedGui then applyRoot(speedGui)end if shouldSave==true and type(saveAllSettings)=="function"then saveAllSettings()end return true end function uiVisual.getThemeAccent()return uiVisual.getThemePalette().primary end function uiVisual.setBackgroundsHidden(hidden,shouldSave)
uiVisual.hideBackgrounds=hidden==true
if uiVisual.hideBackgroundsVisual then uiVisual.hideBackgroundsVisual(uiVisual.hideBackgrounds)end
if uiVisual.refreshBackground then uiVisual.refreshBackground(false)end
if uiVisual.refreshBackgroundColor then uiVisual.refreshBackgroundColor()end
if uiVisual.applyBackgroundDarkness then uiVisual.applyBackgroundDarkness()end
if shouldSave==true and type(saveAllSettings)=="function"then saveAllSettings()end
end
function uiVisual.getThemeDark(strength)return uiVisual.getThemePalette().deep end function uiVisual.getThemeSoft(strength)
 local p=uiVisual.getThemePalette()
 return p.primary:Lerp(Color3.new(1,1,1),math.clamp(tonumber(strength)or .6,0,1))
end function uiVisual.applyColorTheme(themeName,shouldSave)
    if not uiVisual.selectThemeState(themeName)then return false end
    if uiVisual.syncThemeControls then uiVisual.syncThemeControls()end
    if uiVisual.refreshBackground then uiVisual.refreshBackground()end
    if uiVisual.refreshBackgroundColor then uiVisual.refreshBackgroundColor()end
    if uiVisual.refreshNameLogo then uiVisual.refreshNameLogo()end
    if uiVisual.refreshColorSelector then uiVisual.refreshColorSelector()end
    local roots={main,MobilePanel,batV2FloatingButton,instaResetFloatingButton,bypassFloatingButton,pbFrame,miniBtn}
    for _,root in pairs(roots)do
        if root and root.Parent then uiVisual.refreshTheme(root)end
    end
    if uiVisual.refreshSwitchThemes then uiVisual.refreshSwitchThemes()end
    if uiVisual.refreshSpeedTheme then uiVisual.refreshSpeedTheme()end
    if uiVisual.refreshStealBarTheme then uiVisual.refreshStealBarTheme()end
    if uiVisual.refreshAutoStealSelector then uiVisual.refreshAutoStealSelector()end
    local char=LP and LP.Character
    local head=char and char:FindFirstChild("Head")
    local speedGui=head and(head:FindFirstChild("KillHubSpeedIndicator")or head:FindFirstChild("M4LWARESpeedIndicator"))
    if speedGui then uiVisual.refreshTheme(speedGui)end
    local playerGui=LP and LP:FindFirstChild("PlayerGui")
    local ragGui=playerGui and playerGui:FindFirstChild("RagCountdownBillboard")
    if ragGui then uiVisual.refreshTheme(ragGui)end
    for _,speedText in pairs(enemySpeedLabels or{})do
        if speedText and speedText.Parent then uiVisual.refreshTheme(speedText)end
    end
    if shouldSave~=false and type(saveAllSettings)=="function"then saveAllSettings()end
    return true
end
function uiVisual.startActiveSweep(grad) if grad then grad.Enabled=false end end
-- BLESS: static surfaces and short input animations; no decorative render loop.
-- Lightweight BLESS details: static geometry, no additional frame loop.
function uiVisual.blessTrace(parent,name,size,position,tone,alpha)
    local object=parent:FindFirstChild(name)
    if object then return object end
    object=Instance.new("Frame",parent)
    object.Name=name
    object.Size=size
    object.Position=position
    object.BackgroundColor3=Color3.fromRGB(tone,tone,tone)
    object.BackgroundTransparency=alpha or 0
    object.BorderSizePixel=0
    object.Active=false
    object.ZIndex=parent.ZIndex+1
    object:SetAttribute("FearThemeRole","BlessEtching")
    return object
end

function uiVisual.detailBlessControl(object)
    if object:GetAttribute("BlessDetailed") then return end
    local role=object:GetAttribute("FearThemeRole")
    if role=="BlessOptionRow" then
        object:SetAttribute("BlessDetailed",true)
        uiVisual.blessTrace(object,"BlessCardTrace",UDim2.new(.32,0,0,1),UDim2.fromOffset(12,1),255,.86)
        uiVisual.blessTrace(object,"BlessCardTerminal",UDim2.fromOffset(8,1),UDim2.new(1,-14,1,-2),190,.45)
    elseif role=="ToggleTrack" then
        local knob=object:FindFirstChild("Knob")
        if not knob then return end
        object:SetAttribute("BlessDetailed",true)
        local bus=uiVisual.blessTrace(object,"BlessToggleBus",UDim2.fromOffset(10,2),UDim2.new(0,23,.5,-1),100,.2)
        bus:SetAttribute("BlessSwitchDecoration",true)
        Instance.new("UICorner",bus).CornerRadius=UDim.new(1,0)
        local led=uiVisual.blessTrace(knob,"BlessToggleLED",UDim2.fromOffset(4,4),UDim2.new(.5,-2,.5,-2),24,0)
        led:SetAttribute("BlessSwitchDecoration",true)
        Instance.new("UICorner",led).CornerRadius=UDim.new(1,0)
        uiVisual.paintBlessSwitch(object,nil)
    elseif role=="TabButton" then
        object:SetAttribute("BlessDetailed",true)
        object.TextSize=object.Name:match("Tab$")and 9 or 11
        object.TextYAlignment=Enum.TextYAlignment.Center
        for _,name in ipairs({"BlessTabIcon","BlessTabPadding"})do
            local old=object:FindFirstChild(name)
            if old then old:Destroy()end
        end
    elseif role=="SelectorButton" or role=="InputButton" or role=="BlessInput" then
        object:SetAttribute("BlessDetailed",true)
        uiVisual.blessTrace(object,"BlessInputTrace",UDim2.new(.35,0,0,1),UDim2.new(.325,0,1,-1),230,.76)
    elseif role=="BlessSliderTrack" then
        object:SetAttribute("BlessDetailed",true)
        for index=0,4 do
            uiVisual.blessTrace(object,"BlessTick"..index,UDim2.fromOffset(1,2),UDim2.new(index/4,index==4 and -1 or 0,1,3),160,.48)
        end
    elseif role=="BlessSliderFill" then
        object:SetAttribute("BlessDetailed",true)
        uiVisual.blessGradient(object)
    elseif object.Name=="UIVisualBoundary" then
        object:SetAttribute("BlessDetailed",true)
        for index,corner in ipairs({{0,11,0,13},{1,-22,0,13},{0,11,1,-15},{1,-22,1,-15}}) do
            uiVisual.blessTrace(object,"BlessCornerH"..index,UDim2.fromOffset(11,1),UDim2.new(corner[1],corner[2],corner[3],corner[4]),235,.32)
            uiVisual.blessTrace(object,"BlessCornerV"..index,UDim2.fromOffset(1,6),UDim2.new(corner[1],corner[2]+(corner[1]==1 and 10 or 0),corner[3],corner[4]+(corner[3]==1 and -5 or 0)),235,.32)
        end
    end
end

function uiVisual.blessGradient(object)
    local gradient = object:FindFirstChild("BlessSurface")
    if not gradient then
        gradient = Instance.new("UIGradient", object)
        gradient.Name = "BlessSurface"
        gradient:SetAttribute("BlessTechGradient", true)
    end
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(205,205,205)),
    })
    gradient.Rotation = 90
    gradient.Enabled = true
    return gradient
end

function uiVisual.paintBlessSwitch(track, animate)
    local on = track:GetAttribute("FearToggleOn") == true
    local knob = track:FindFirstChild("Knob")
    track.BackgroundColor3 = on and uiVisual.getThemeAccent() or Color3.fromRGB(8,8,8)
    track.BackgroundTransparency = 0
    local edge = track:FindFirstChild("PillStroke")
    if edge then
        edge.Color = on and uiVisual.getThemeAccent() or Color3.fromRGB(76,76,76)
        edge.Transparency = on and 0.05 or 0.23
    end
    local bus=track:FindFirstChild("BlessToggleBus")
    if bus then
        bus.Position=UDim2.new(0,on and 7 or 23,.5,-1)
        bus.BackgroundColor3=on and Color3.fromRGB(72,72,72) or Color3.fromRGB(110,110,110)
    end
    if not knob then return end
    local led=knob:FindFirstChild("BlessToggleLED")
    if led then led.BackgroundColor3=on and uiVisual.getThemeAccent() or Color3.fromRGB(24,24,24) end
    knob.BackgroundColor3 = on and Color3.fromRGB(12,12,12) or Color3.fromRGB(230,230,230)
    if animate ~= nil then
        local goal = on and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
        uiVisual.blessSwitchTweens = uiVisual.blessSwitchTweens or setmetatable({}, {__mode="k"})
        local old = uiVisual.blessSwitchTweens[knob]
        if old then old:Cancel() end
        if animate and not _isLoading then
            local tween = TS:Create(knob, TweenInfo.new(0.16,Enum.EasingStyle.Quint,Enum.EasingDirection.Out), {Position=goal})
            uiVisual.blessSwitchTweens[knob] = tween
            tween:Play()
        else knob.Position = goal end
    end
end

-- Head text uses the active accent directly; white prevents a second tint.
function uiVisual.styleHeadVisual(object)
    local role = object:GetAttribute("FearThemeRole")
    local isText = object:IsA("TextLabel") and (role=="StealText" or role=="SpeedText" or role=="RagdollCountdown")
    local isSeparator = object:IsA("Frame") and role=="SpeedSeparator"
    local owner = object:IsA("UIGradient") and object.Parent
    local ownerRole = owner and owner:GetAttribute("FearThemeRole")
    local isTextGradient = ownerRole=="StealText" or ownerRole=="SpeedText" or ownerRole=="RagdollCountdown"
    local isLineGradient = ownerRole=="SpeedSeparator"
    if not (isText or isSeparator or isTextGradient or isLineGradient) then return false end

    local accent = uiVisual.getThemeAccent()
    local black = Color3.fromRGB(5,5,9)
    local highlight = accent:Lerp(Color3.new(1,1,1),0.28)
    if isText then
        object.TextColor3 = Color3.new(1,1,1)
        object.TextStrokeColor3 = black:Lerp(accent,0.18)
        object.TextStrokeTransparency = 0.12
    elseif isSeparator then
        object.BackgroundColor3 = Color3.new(1,1,1)
        object.BackgroundTransparency = 0.08
    else
        object.Enabled = true
        object.Offset = Vector2.new(0,0)
        if isTextGradient then
            -- A dark top edge and a narrow highlight give the letters depth.
            object.Rotation = 90
            object.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00,black),
                ColorSequenceKeypoint.new(0.24,accent:Lerp(black,0.35)),
                ColorSequenceKeypoint.new(0.48,accent),
                ColorSequenceKeypoint.new(0.62,highlight),
                ColorSequenceKeypoint.new(1.00,accent:Lerp(black,0.58)),
            })
            object.Transparency = NumberSequence.new(0)
        else
            object.Rotation = 0
            object.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00,black),
                ColorSequenceKeypoint.new(0.30,accent),
                ColorSequenceKeypoint.new(0.50,highlight),
                ColorSequenceKeypoint.new(0.70,accent),
                ColorSequenceKeypoint.new(1.00,black),
            })
            object.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0.00,0.8),
                NumberSequenceKeypoint.new(0.25,0.1),
                NumberSequenceKeypoint.new(0.50,0),
                NumberSequenceKeypoint.new(0.75,0.1),
                NumberSequenceKeypoint.new(1.00,0.8),
            })
        end
    end
    return true
end

-- One paint path for both legacy and modern floating controls.
function uiVisual.styleFloatingVisual(object)
    local role=object:GetAttribute("FearThemeRole")
    local owner=object.Parent
    if object:IsA("UIGradient")and owner and owner:GetAttribute("FearThemeRole")=="FloatingButton"then
        uiVisual.styleFloatingVisual(owner)
        return true
    end
    local isButton=role=="FloatingButton"and object:IsA("GuiObject")
    local isLabel=role=="FloatingLabel"and object:IsA("TextLabel")
    local isEdge=role=="FloatingStroke"and object:IsA("UIStroke")
    if not(isButton or isLabel or isEdge)then return false end
    local control=isButton and object or owner
    local on=control and(control:GetAttribute("FearToggleOn")==true or control:GetAttribute("FearSelected")==true)
    local palette=uiVisual.getThemePalette()
    local accent=palette.primary
    local black=Color3.fromRGB(5,5,8)
    local colors=palette.floating
    if not colors.onGradient then
        colors.onGradient=ColorSequence.new({
            ColorSequenceKeypoint.new(0.00,accent:Lerp(Color3.new(1,1,1),.08)),
            ColorSequenceKeypoint.new(0.34,accent:Lerp(black,.20)),
            ColorSequenceKeypoint.new(0.72,accent:Lerp(black,.52)),
            ColorSequenceKeypoint.new(1.00,black),
        })
        colors.offGradient=ColorSequence.new({
            ColorSequenceKeypoint.new(0.00,black),
            ColorSequenceKeypoint.new(0.50,black:Lerp(accent,.055)),
            ColorSequenceKeypoint.new(1.00,black:Lerp(accent,.18)),
        })
    end
    if isButton then
        object.BackgroundColor3=Color3.new(1,1,1)
        object.BackgroundTransparency=0
        local gradient=object:FindFirstChildOfClass("UIGradient")
        if not gradient then gradient=Instance.new("UIGradient",object);gradient.Name="BtnGrad"end
        gradient:SetAttribute("FearThemeRole","FloatingGradient")
        gradient.Enabled=true
        gradient.Color=on and colors.onGradient or colors.offGradient
        gradient.Transparency=NumberSequence.new(0)
        gradient.Rotation=65
        gradient.Offset=Vector2.new(0,0)
        if object:IsA("TextButton")then object.AutoButtonColor=false end
    elseif isLabel then
        object.TextColor3=on and Color3.new(1,1,1)or accent:Lerp(Color3.new(1,1,1),.22)
        object.TextStrokeColor3=black
        object.TextStrokeTransparency=on and .18 or .45
    else
        object.Color=on and accent:Lerp(Color3.new(1,1,1),.15)or black:Lerp(accent,.4)
        object.Transparency=on and .05 or .2
    end
    return true
end

function uiVisual.refreshTheme(root)
    root = root or main
    if not root or not root.Parent then return end
    local white = uiVisual.getThemeAccent()
    local muted = uiVisual.getThemePalette().mid
    local dark = Color3.fromRGB(8,8,8)
    local edge = uiVisual.getThemeSoft(.75)
    local floatingColors = uiVisual.getThemePalette().floating
    local function active(object)
        return object and (object:GetAttribute("FearToggleOn")==true or object:GetAttribute("FearSelected")==true or object:GetAttribute("FearListening")==true)
    end
    local function darkText(object)
        local parent = object.Parent
        while parent and parent ~= root.Parent do
            local role = parent:GetAttribute("FearThemeRole")
            if role=="FloatingButton" or role=="TabButton" or role=="SelectorButton" then return active(parent) end
            parent = parent.Parent
        end
        return false
    end
    local objects = {root}
    for _,object in ipairs(root:GetDescendants()) do objects[#objects+1]=object end
    for _,object in ipairs(objects) do
        if object:GetAttribute("CandyDecoration")or object:GetAttribute("BlessStealVisual")or(uiVisual.isModernObject and uiVisual.isModernObject(object))then continue end
        local role = object:GetAttribute("FearThemeRole")
        if uiVisual.styleFloatingVisual(object)or uiVisual.styleHeadVisual(object) then
            -- Keep gradients, opaque floating surfaces, and head outlines.
        elseif object:IsA("UIGradient") then
            object.Enabled = object:GetAttribute("BlessTechGradient")==true
        elseif object:IsA("UIStroke") then
            local owner = object.Parent
            local selected = active(object) or active(owner) or object:GetAttribute("FearFocused")==true
            object.Color = role=="FloatingStroke"and(active(owner)and floatingColors.onStroke or floatingColors.offStroke)or(selected and white or edge)
            object.Thickness = 1
            object.Transparency = selected and 0.12 or 0.48
            object.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            if role=="StealGlow" or object.Name=="WindowNeonGlow" then object.Enabled=false end
            if role=="ToggleStroke" and owner then
                object.Color = active(owner) and white or Color3.fromRGB(76,76,76)
                object.Transparency = active(owner) and 0.05 or 0.23
            end
        elseif object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
            object.TextStrokeTransparency = 1
            if object:GetAttribute("BlessPreserveText") then
                -- Switch glyphs have their own contrast and follow their track.
            elseif role=="FloatingLabel"then
                object.TextColor3=active(object.Parent)and floatingColors.onText or floatingColors.offText
            elseif role=="SectionTitle" or role=="BlessMeta" then
                object.TextColor3 = uiVisual.getThemePalette().light
            elseif role=="ToggleLabel" then
                object.TextColor3 = active(object) and white or Color3.fromRGB(205,205,205)
            elseif role=="BlessNumeric" then
                object.TextColor3 = white
                object.Font = Enum.Font.Code
            else object.TextColor3 = darkText(object) and dark or white end
            if object:IsA("TextBox") then
                object.PlaceholderColor3 = Color3.fromRGB(120,120,120)
                if role~="OptionSearch" then
                    object.BackgroundColor3=Color3.fromRGB(7,7,7)
                    object.BackgroundTransparency=0.08
                end
            end
            if role=="FloatingButton" or role=="TabButton" or role=="SelectorButton" or role=="InputButton" or role=="MiniOpenButton" then
                local selected=active(object)
                object.BackgroundColor3=role=="FloatingButton"and(selected and floatingColors.onBackground or floatingColors.offBackground)or(selected and white or Color3.fromRGB(12,12,12))
                object.TextColor3=role=="FloatingButton"and(selected and floatingColors.onText or floatingColors.offText)or(selected and dark or white)
                object.BackgroundTransparency=selected and 0 or 0.08
                object.AutoButtonColor=false
            elseif object:IsA("TextButton") and object.BackgroundTransparency<1 then
                object.BackgroundColor3=Color3.fromRGB(14,14,14)
            end
            if role=="StealPercentText" and progressFill and progressFill.Size.X.Scale>=0.57 then object.TextColor3=dark end
        elseif object:IsA("ImageLabel") or object:IsA("ImageButton") then
            object.ImageColor3=role=="ThemeLogo" and uiVisual.getLogoColor() or Color3.fromRGB(255,255,255)
            if role=="ThemeLogoGlow" or object.Name:find("WordGlow") then object.Visible=false end
        elseif object:IsA("ScrollingFrame") then
            object.ScrollBarImageColor3=uiVisual.getThemePalette().mid
            object.ScrollBarImageTransparency=0.3
        elseif object:IsA("Frame") then
            if role=="BlessTabGlyph" then
                object.BackgroundColor3=active(object.Parent.Parent) and dark or Color3.fromRGB(185,185,185)
            elseif object:GetAttribute("BlessSwitchDecoration") then
                -- Track and thumb indicators follow paintBlessSwitch.
            elseif role=="BlessOptionRow" then
                object.BackgroundColor3=active(object) and Color3.fromRGB(28,28,28) or Color3.fromRGB(16,16,16)
                object.BackgroundTransparency=0.09
            elseif role=="BlessRowStatus" then
                object.BackgroundColor3=active(object.Parent) and white or Color3.fromRGB(84,84,84)
                object.BackgroundTransparency=active(object.Parent) and 0 or 0.35
            elseif role=="BlessTabMarker" then
                object.BackgroundColor3=active(object.Parent) and dark or muted
                object.Visible=active(object.Parent)
            elseif role=="ToggleTrack" then uiVisual.paintBlessSwitch(object,nil)
            elseif object:GetAttribute("BlessSwitchKnob") then
                -- Position belongs to the switch animation.
            elseif role=="SectionLine" then
                object.BackgroundColor3=uiVisual.getThemePalette().mid
                object.BackgroundTransparency=0.58
            elseif role=="BlessSliderTrack" then object.BackgroundColor3=Color3.fromRGB(57,57,57)
            elseif role=="BlessSliderFill" or role=="BlessSliderKnob" then object.BackgroundColor3=white
            elseif role=="StealFill" then object.BackgroundColor3=white
            elseif role=="StealTrack" then object.BackgroundColor3=Color3.fromRGB(23,23,23)
            elseif role=="StealTip" or role=="StealNormalDecor" then object.Visible=false
            elseif role=="FloatingButton" then
                object.BackgroundColor3=active(object)and floatingColors.onBackground or floatingColors.offBackground
                object.BackgroundTransparency=0.04
            elseif role=="StealPanel" or role=="StealBadge" then
                object.BackgroundColor3=dark
                object.BackgroundTransparency=0.04
            elseif role=="ThemeSlide" then object.BackgroundColor3=white
            elseif object.BackgroundTransparency<1 then
                local color=object.BackgroundColor3
                local brightness=(color.R+color.G+color.B)/3
                if brightness<0.38 then
                    object.BackgroundColor3=Color3.fromRGB(10,10,10):Lerp(Color3.fromRGB(38,38,38),math.clamp(brightness*2,0,1))
                else object.BackgroundColor3=Color3.new(brightness,brightness,brightness) end
            end
        end
    end
end

function uiVisual.decorate(root)if uiVisual.candyRefresh then uiVisual.candyRefresh(root)end end
-- Candy Hub: shared static artwork. Existing controls own every action and state.
do
    local white = Color3.fromRGB(255,255,255)
    local cream = Color3.fromRGB(255,248,252)
    local function mark(object, tone)
        object:SetAttribute("CandyDecoration",true)
        if tone then object:SetAttribute("CandyTone",tone) end
        return object
    end
    local function round(object, radius)
        local corner = object:FindFirstChildOfClass("UICorner") or Instance.new("UICorner",object)
        corner.CornerRadius = radius and UDim.new(0,radius) or UDim.new(.5,0)
        mark(corner)
        return corner
    end
    local function piece(parent,name,x,y,w,h,color,angle,alpha,z,tone)
        local object = Instance.new("Frame")
        object.Name = name
        object.AnchorPoint = Vector2.new(.5,.5)
        object.Size = UDim2.fromOffset(w,h)
        object.Position = UDim2.fromOffset(x,y)
        object.Rotation = angle or 0
        object.BackgroundColor3 = color
        object.BackgroundTransparency = alpha or 0
        object.BorderSizePixel = 0
        object.Active = false
        object.ZIndex = z or parent.ZIndex+1
        mark(object,tone)
        round(object)
        object.Parent = parent
        return object
    end
    local function gradient(object,sequence,rotation)
        local g = object:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient",object)
        g.Name = "CandyGlaze"
        g.Enabled = true
        g.Rotation = rotation or 90
        g.Color = sequence
        g.Transparency = NumberSequence.new(0)
        g.Offset = Vector2.new(0,0)
        mark(g)
        return g
    end
    local function edge(object,color,alpha,width)
        local line = object:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke",object)
        line.Color = color
        line.Thickness = width or 1
        line.Transparency = alpha or .2
        line.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        return line
    end

    local textLinks=setmetatable({},{__mode="k"})
    local function clearText(object)
        -- UIGradient also tints a TextButton's own glyphs. A child label keeps
        -- the text crisp over a gel surface, including changing bind labels.
        local label=object:FindFirstChild("CandyButtonLabel")
        if label then object.TextTransparency=1;object.TextStrokeTransparency=1;return end
        if not object:IsA("TextButton")or object.Text==""then return end
        label=Instance.new("TextLabel")
        label.Name="CandyButtonLabel"
        label.Size=UDim2.new(1,-6,1,0)
        label.Position=UDim2.fromOffset(3,0)
        label.BackgroundTransparency=1
        label.BorderSizePixel=0
        label.Active=false
        label.ZIndex=object.ZIndex+1
        mark(label)
        label.Parent=object
        local links={}
        textLinks[object]=links
        for _,key in ipairs({"Text","TextColor3","TextSize","Font","TextWrapped","TextXAlignment","TextYAlignment","TextTruncate","RichText"})do
            label[key]=object[key]
            links[#links+1]=object:GetPropertyChangedSignal(key):Connect(function()
                if label.Parent then label[key]=object[key]end
            end)
        end
        object.TextTransparency=1
        object.TextStrokeTransparency=1
        object.Destroying:Connect(function()
            for _,connection in ipairs(links)do connection:Disconnect()end
            textLinks[object]=nil
        end)
    end

    local motionStates=setmetatable({},{__mode="k"})
    local motionService=game:GetService("TweenService")
    local motionInfo=TweenInfo.new(.24,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
    local function paintMotion(owner,on,profile,goals)
        local p=uiVisual.getThemePalette()
        local state=motionStates[owner]
        local first=not state
        if first then
            state={tweens={}}
            motionStates[owner]=state
            owner.Destroying:Connect(function()
                for _,tween in ipairs(state.tweens)do tween:Cancel()end
                state.tweens={}
                motionStates[owner]=nil
            end)
        end
        local reset=first or state.palette~=p or state.profile~=profile or _isLoading==true
        local changed=state.on~=on
        if not changed and not reset then return end
        for _,tween in ipairs(state.tweens)do tween:Cancel()end
        state.tweens={}
        state.on,state.palette,state.profile=on,p,profile
        for _,goal in ipairs(goals)do
            if changed and not reset then
                local tween=motionService:Create(goal.object,motionInfo,goal.properties)
                state.tweens[#state.tweens+1]=tween
                tween:Play()
            else
                for key,value in pairs(goal.properties)do goal.object[key]=value end
            end
        end
    end

    function uiVisual.paintCandySearch(shell)
        if not shell then return end
        local p=uiVisual.getThemePalette()
        local focused=shell:GetAttribute("CandySearchFocused")==true
        shell.BackgroundColor3=white
        shell.BorderSizePixel=0
        round(shell,10)
        gradient(shell,p.searchGel,0)
        local outline=shell:FindFirstChildOfClass("UIStroke")
        local alpha=outline and outline.Transparency or .6
        outline=edge(shell,p.optionEdge,alpha,1)
        mark(outline)
        paintMotion(shell,focused,"search",{
            {object=shell,properties={BackgroundTransparency=focused and .02 or .08}},
            {object=outline,properties={Transparency=focused and .24 or .6}},
        })
        local box=shell:FindFirstChild("OptionSearch")
        if box then
            box.BackgroundTransparency=1
            box.TextColor3=p.text
            box.PlaceholderColor3=p.text:Lerp(p.searchInk,.26)
            local g=box:FindFirstChildOfClass("UIGradient")
            if g then g.Enabled=false end
            local line=box:FindFirstChildOfClass("UIStroke")
            if line then line.Enabled=false end
        end
        local icon=shell:FindFirstChild("SearchIcon")
        local ring=icon and icon:FindFirstChildOfClass("UIStroke")
        if ring then ring.Color=p.light;ring.Transparency=.14 end
        local handle=shell:FindFirstChild("SearchHandle")
        if handle then handle.BackgroundColor3=p.light end
        local clear=shell:FindFirstChild("OptionSearchClear")
        if clear then
            local hasText=box and box.Text~=""
            clear.BackgroundColor3=p.light
            clear.BackgroundTransparency=clear:GetAttribute("CandySearchHover")==true and .72 or (hasText and .86 or .95)
            round(clear,7)
            local g=clear:FindFirstChildOfClass("UIGradient")
            if g then g.Enabled=false end
            local line=clear:FindFirstChildOfClass("UIStroke")
            if line then line.Enabled=false end
            for _,cross in ipairs(clear:GetChildren())do
                if cross:IsA("Frame")then
                    cross.BackgroundColor3=p.text
                    cross.BackgroundTransparency=hasText and .12 or .35
                end
            end
        end
    end

    function uiVisual.candySurface(object,on,compact)
        local p = uiVisual.getThemePalette()
        local currentColor=object.BackgroundColor3
        local floating=object:GetAttribute("FearThemeRole")=="FloatingButton"
        local isSwitch=object:GetAttribute("BlessSwitchRow")==true or object:GetAttribute("FearToggleOn")~=nil
        object.BackgroundColor3 = white
        object.BackgroundTransparency = isSwitch and (floating and 0 or .08) or (on and .02 or .1)
        object.BorderSizePixel = 0
        local radius=compact and 7 or 8
        if floating then
            local width=object.Size and object.Size.X.Offset or 56
            local baseWidth=tonumber(object:GetAttribute("FearHubBaseWidth"))or 56
            local scale=width>0 and math.clamp(width/math.max(baseWidth,1),.5,1.5)or 1
            local baseCorner=tonumber(object:GetAttribute("FearHubBaseCorner"))or 10
            radius=math.max(5,math.floor(baseCorner*scale+.5))
        end
        round(object,radius)
        gradient(object,floating and p.floatOffGel or (isSwitch and p.toggleGel or (on and p.selected or p.optionGel)),floating and 90 or 0)
        edge(object,on and p.primary or (floating and p.outline or p.optionEdge),on and .3 or .48,1)
        local marker=object:FindFirstChild("CandyStatusMark")
        if marker then marker:Destroy()end
        if object:IsA("TextBox")then
            local g=object:FindFirstChildOfClass("UIGradient")
            if g then g.Enabled=false end
            object.BackgroundColor3=p.inputSurface
        elseif floating then
            -- Fade the candy color over a soft tinted gray, keeping text crisp.
            local surface=object:FindFirstChild("CandyActiveSurface")
            if not surface then
                surface=Instance.new("Frame")
                surface.Name="CandyActiveSurface"
                surface.Size=UDim2.new(1,-2,1,-2)
                surface.Position=UDim2.fromOffset(1,1)
                surface.BackgroundColor3=white
                surface.BackgroundTransparency=1
                surface.BorderSizePixel=0
                surface.Active=false
                mark(surface)
                surface.Parent=object
            end
            surface.ZIndex=object.ZIndex
            round(surface,math.max(4,radius-1))
            gradient(surface,p.toggleGel,0)
            paintMotion(object,on,"floating",{{object=surface,properties={BackgroundTransparency=on and .04 or 1}}})
        elseif isSwitch then
            local level=on and .96 or .65
            local previous=motionStates[object]
            -- Repainting the same state must leave an in-flight tween alone.
            if previous and previous.palette==p and previous.profile=="surface"and not _isLoading then
                object.BackgroundColor3=currentColor
            end
            local goals={
                {object=object,properties={BackgroundColor3=Color3.new(level,level,level)}},
            }
            paintMotion(object,on,"surface",goals)
        end
        if object:IsA("TextButton")then object.AutoButtonColor=false;clearText(object) end
    end

    -- A tiny wrapped sweet is drawn from round shapes, never an emoji.
    function uiVisual.candyBadge(parent,name,size,position,z)
        local old=parent:FindFirstChild(name)
        if old then return old end
        local p=uiVisual.getThemePalette()
        local root=Instance.new("Frame")
        root.Name=name
        root.Size=UDim2.fromOffset(size,size)
        root.Position=position
        root.BackgroundTransparency=1
        root.BorderSizePixel=0
        root.Active=false
        root.ZIndex=z or parent.ZIndex+1
        mark(root)
        root.Parent=parent
        local k=size/24
        for _,side in ipairs({-1,1})do
            piece(root,"Wrapper",(12+side*8.8)*k,12*k,7*k,10*k,p.light,side*24,.1,root.ZIndex,"light")
        end
        local body=piece(root,"Sweet",12*k,12*k,15*k,13*k,white,-13,0,root.ZIndex+1)
        gradient(body,p.gel,75)
        edge(body,white,.3,.6)
        piece(root,"SugarStripe",10.5*k,11.5*k,2*k,10*k,cream,8,.15,root.ZIndex+2)
        piece(root,"SweetShine",11*k,8.4*k,8*k,2.5*k,white,-15,.12,root.ZIndex+3)
        return root
    end

    function uiVisual.candyKnob(knob)
        if knob:GetAttribute("CandyKnob")then return end
        knob:SetAttribute("CandyKnob",true)
        local p=uiVisual.getThemePalette()
        local z=knob.ZIndex+1
        piece(knob,"CandyWrapLeft",.3,7,3.6,7.4,p.light,-22,.18,z,"light")
        piece(knob,"CandyWrapRight",13.7,7,3.6,7.4,p.light,22,.18,z,"light")
        piece(knob,"CandyFoldLeft",1.1,7,1.1,5.8,p.primary,-10,.4,z+1,"primary")
        piece(knob,"CandyFoldRight",12.9,7,1.1,5.8,p.primary,10,.4,z+1,"primary")
        local body=piece(knob,"CandyCore",7,7,11.8,10.8,white,0,0,z+1)
        local glaze=gradient(body,p.knobGel,90)
        glaze:SetAttribute("CandyTone","knobGel")
        mark(edge(body,p.light,.2,.7),"light")
        piece(knob,"CandyStripe",5.6,7,2.1,8,p.primary,24,.32,z+2,"primary")
        piece(knob,"CandyStripe2",9.1,7,1.5,7.8,p.light,24,.48,z+2,"light")
        piece(knob,"CandyReflection",6.5,3.7,6.5,1.5,white,-8,.66,z+3)
        piece(knob,"CandySpecular",3.4,5,1.1,2,white,12,.72,z+3)
    end

    function uiVisual.candySwitch(track)
        local knob=track:FindFirstChild("Knob")
        if not knob then return end
        local p=uiVisual.getThemePalette()
        local on=track:GetAttribute("FearToggleOn")==true
        round(track)
        gradient(track,p.toggleGel,0)
        local level=on and .86 or .5
        paintMotion(track,on,"track",{{object=track,properties={BackgroundColor3=Color3.new(level,level,level),BackgroundTransparency=on and 0 or .06}}})
        edge(track,on and p.primary or p.outline,on and .28 or .42,1)
        knob.BackgroundTransparency=1
        local knobEdge=knob:FindFirstChildOfClass("UIStroke")
        if knobEdge then knobEdge.Enabled=false;mark(knobEdge) end
        uiVisual.candyKnob(knob)
        -- Position remains under paintBlessSwitch, including its cancelable tween.
    end

    function uiVisual.candySkin(object)
        local p=uiVisual.getThemePalette()
        if object:GetAttribute("CandyDecoration")then
            local tone=object:GetAttribute("CandyTone")
            if tone and object:IsA("GuiObject")then
                object.BackgroundColor3=tone=="secondary"and p.secondary or tone=="light"and p.light or p.primary
            elseif object:IsA("UIStroke")and tone then
                object.Color=tone=="light"and p.light or p.primary
            elseif object:IsA("UIGradient")then
                if tone=="knobGel"then object.Color=p.knobGel
                elseif object.Parent and object.Parent.Name=="Sweet"then object.Color=p.gel end
            end
            return
        end
        if object:GetAttribute("BlessStealVisual")then return end
        local role=object:GetAttribute("FearThemeRole")
        if role=="OptionSearchShell"then
            uiVisual.paintCandySearch(object)
            return
        elseif (role=="OptionSearch"or role=="OptionSearchClear")and object.Parent and object.Parent:GetAttribute("FearThemeRole")=="OptionSearchShell"then
            uiVisual.paintCandySearch(object.Parent)
            return
        end
        local on=object:GetAttribute("FearToggleOn")==true or object:GetAttribute("FearSelected")==true or object:GetAttribute("BlessSpeedActive")==true
        if role=="FloatingButton"or role=="FloatingLabel"or role=="FloatingStroke"or role=="FloatingGradient"then
            uiVisual.styleFloatingVisual(object)
            return
        end
        if object:IsA("GuiObject")then
            if role=="SpeedModeName"then
                object.BackgroundTransparency=1
                local selected=object.Parent and object.Parent:GetAttribute("FearSelected")==true
                object.TextColor3=selected and white or p.text
            elseif role=="BlessSwitchTrack"or role=="ToggleTrack"then
                uiVisual.candySwitch(object)
                return
            elseif role=="BlessOptionRow"or role=="SpeedModeRow"or role=="AutoStealHeader"or role=="BlessScriptCard"then
                uiVisual.candySurface(object,on)
                if object:IsA("TextButton")and object.Text~=""then object.TextColor3=on and white or p.text end
            elseif role=="TabButton"or role=="SelectorButton"or role=="InputButton"or role=="MiniOpenButton"or role=="ScriptOpenButton"or role=="AutoStealSettings"or role=="AutoStealMode"or role=="OptionSearchClear"or role=="NeonCloseText"then
                uiVisual.candySurface(object,on,true)
                if object:IsA("TextButton")then object.TextColor3=on and white or p.text end
            elseif role=="CandyThemeCard"then
                uiVisual.candySurface(object,on)
                local line=object:FindFirstChildOfClass("UIStroke")
                if line then line.Thickness=on and 2.2 or 1;line.Color=on and p.light or p.outline;line.Transparency=on and 0 or .55 end
            elseif role=="BlessInput"or object:IsA("TextBox")then
                uiVisual.candySurface(object,false,true)
                object.TextColor3=p.text
                object.PlaceholderColor3=p.text:Lerp(p.inputSurface,.28)
            elseif role=="BlessSliderFill"then
                object.BackgroundColor3=white
                gradient(object,p.gel,0)
                round(object)
            elseif role=="BlessSliderKnob"then
                object.BackgroundColor3=cream
                round(object)
                edge(object,p.primary,.05,1.6)
                uiVisual.candyKnob(object)
            elseif role=="BlessSliderTrack"then
                object.BackgroundColor3=p.mid
                object.BackgroundTransparency=.45
                round(object)
            elseif object:GetAttribute("CandyWindow")or object.Name=="UIVisualBoundary"then
                object.BackgroundColor3=p.deep
                round(object,19)
            elseif object.Name=="BlessBottomSections"or object.Name=="BlessSectionSelector"then
                uiVisual.candySurface(object,false)
            elseif role=="SectionLine"then
                object.BackgroundColor3=p.outline
                object.BackgroundTransparency=.42
            elseif object:IsA("TextButton")and object.BackgroundTransparency<.99 and not role then
                uiVisual.candySurface(object,false,true)
                object.TextColor3=p.text
            end
            if object:IsA("TextLabel")then
                if role=="SectionTitle"or role=="BlessMeta"then
                    object.TextColor3=cream
                    object.TextStrokeColor3=p.deep
                    object.TextStrokeTransparency=.5
                elseif role=="BlessNumeric"or role=="ColorValue"then
                    object.TextColor3=p.text
                elseif role=="ToggleLabel"or role=="RowLabel"or role=="AutoStealTitle"or role=="AccentText"or object.Parent and object.Parent:GetAttribute("FearThemeRole")=="BlessOptionRow"then
                    local enabled=object.Parent:GetAttribute("FearToggleOn")==true
                    object.TextColor3=enabled and white or p.text
                    object.TextStrokeTransparency=1
                elseif role=="ToggleStatus"then
                    local enabled=object.Parent and object.Parent:GetAttribute("FearToggleOn")==true
                    object.Text=enabled and"ON"or"OFF"
                    object.TextColor3=p.text
                end
            end
        elseif object:IsA("UIStroke")and(role=="RowStroke"or role=="SelectorStroke"or role=="InputButtonStroke"or role=="InputStroke")then
            local owner=object.Parent
            local selected=owner and(owner:GetAttribute("FearToggleOn")==true or owner:GetAttribute("FearSelected")==true)
            object.Color=selected and p.primary or p.optionEdge
            object.Transparency=selected and .3 or .48
            object.Thickness=1
        end
    end

    function uiVisual.candyRefresh(root)
        if not root then return end
        uiVisual.candySkin(root)
        for _,object in ipairs(root:GetDescendants())do uiVisual.candySkin(object)end
    end

    -- Floating action buttons keep their labels, binds, drag area and callbacks.
    function uiVisual.styleFloatingVisual(object)
        if object:GetAttribute("CandyDecoration")then return true end
        local role=object:GetAttribute("FearThemeRole")
        local isButton=role=="FloatingButton"and object:IsA("GuiObject")
        local isText=role=="FloatingLabel"and object:IsA("TextLabel")
        local isEdge=role=="FloatingStroke"and object:IsA("UIStroke")
        local isGradient=role=="FloatingGradient"and object:IsA("UIGradient")
        if not(isButton or isText or isEdge or isGradient)then return false end
        local owner=isButton and object or object.Parent
        local p=uiVisual.getThemePalette()
        local on=owner and(owner:GetAttribute("FearToggleOn")==true or owner:GetAttribute("FearSelected")==true)
        if isButton then
            uiVisual.candySurface(object,on)
            object.BackgroundTransparency=0
            local badge=uiVisual.candyBadge(object,"CandyButtonSweet",9,UDim2.new(1,-12,1,-11),object.ZIndex)
            for _,part in ipairs(badge:GetDescendants())do
                if part:IsA("GuiObject")then part.ZIndex=object.ZIndex end
            end
        elseif isText then
            object.TextColor3=on and white or p.text
            object.TextStrokeTransparency=1
        elseif isEdge then
            object.Color=on and p.primary or p.outline
            object.Transparency=on and .28 or .46
            object.Thickness=1
        else
            object.Enabled=true
            object.Color=p.floatOffGel
        end
        return true
    end
end



 local _wf=nil local _rf=nil local _if=nil local function _resolveFS()if not _wf then _wf=writefile or(syn and syn.writefile)or(getgenv and getgenv().writefile)end if not _rf then _rf=readfile or(syn and syn.readfile)or(getgenv and getgenv().readfile)end if not _if then _if=isfile or(syn and syn.isfile)or(getgenv and getgenv().isfile)end end local function _ace_writefile(path,data)_resolveFS()if type(_wf)~="function"then return false end local ok,result=pcall(_wf,path,data)return ok and result~=false end local function _ace_readfile(path)_resolveFS()if type(_rf)=="function"then local ok,r=pcall(_rf,path)if ok then return r end end return nil end local function _ace_isfile(path)_resolveFS()if type(_if)=="function"then local ok,r=pcall(_if,path)if ok then return r end end local r=_ace_readfile(path)return r~=nil and r~=""end local function canSaveConfig()_resolveFS()return type(_wf)=="function"and type(_rf)=="function"end _G.M4ToggleSFX=_G.M4ToggleSFX or{}_G.M4ToggleSFX.url="https://pdftolink.io/file/r2_dXNlcnMvZ3Vlc3QvYTcwZTNkMjItNzJhMS00MTFmLTg3YjQtMGI3MTdmODUyOWIyLm1wMw"_G.M4ToggleSFX.file="M4LWARE_toggle_click.mp3"_G.M4ToggleSFX.asset=nil _G.M4ToggleSFX.busy=false _G.M4ToggleSFX.last=0 function _G.M4ToggleSFXPrepare()local s=_G.M4ToggleSFX if s.asset then return s.asset end if s.busy then local timeout=os.clock()+3 while s.busy and os.clock()<timeout do task.wait(0.03)end return s.asset end s.busy=true _resolveFS()local env=(type(getgenv)=="function"and getgenv())or _G local assetFn=getcustomasset or getsynasset or(syn and(syn.getcustomasset or syn.getsynasset))or(type(env)=="table"and(env.getcustomasset or env.getsynasset))if type(assetFn)~="function"or type(_wf)~="function"then s.busy=false return nil end local exists=false exists=_ace_isfile(s.file)if not exists then local function fetch(url)local body=nil local req=request or http_request or(syn and syn.request)or(fluxus and fluxus.request)if type(req)=="function"then pcall(function()local result=req({Url=url,Method="GET",Headers={["User-Agent"]="Mozilla/5.0"}})if result then body=result.Body or result.body end end)end if type(body)~="string"or body==""then pcall(function()body=game:HttpGet(url,true)end)end return body end local body=fetch(s.url)if type(body)=="string"and#body>0 then local head=body:sub(1,768):lower()if head:find("<html",1,true)or head:find("<!doctype",1,true)or head:find("<audio",1,true)then local page=body:gsub("\\/","/"):gsub("&amp;","&")local direct=page:match([=[<audio[^>]-src=["']([^"']+)["']]=])or page:match([=[<source[^>]-src=["']([^"']+)["']]=])or page:match([=["audioUrl"%s*:%s*"([^"]+)"]=])or page:match([=["fileUrl"%s*:%s*"([^"]+)"]=])or page:match([=["downloadUrl"%s*:%s*"([^"]+)"]=])or page:match([=[(https?://[^"'<>%s]+%.mp3[^"'<>%s]*)]=])if direct then direct=direct:gsub("\\u0026","&")if direct:sub(1,2)=="//"then direct="https:"..direct elseif direct:sub(1,1)=="/"then direct="https://pdftolink.io"..direct end body=fetch(direct)end end end if type(body)=="string"and#body>128 then local lower=body:sub(1,256):lower()if not lower:find("<html",1,true)and not lower:find("<!doctype",1,true)then _ace_writefile(s.file,body)end end end if _ace_isfile(s.file)then local okFile,hasFile=true,true if hasFile then local okAsset,id=pcall(assetFn,s.file)if okAsset and type(id)=="string"and id~=""then s.asset=id end end end s.busy=false return s.asset end function _G.M4ToggleSFXPlay()local s=_G.M4ToggleSFX local now=os.clock()if now-(s.last or 0)<0.06 then return end s.last=now task.spawn(function()local id=_G.M4ToggleSFXPrepare()local sound=Instance.new("Sound")sound.Name="M4LWAREToggleSFX"sound.SoundId=id or"rbxasset://sounds/electronicpingshort.wav"sound.Volume=0.8 sound.Parent=SoundService sound:Play()sound.Ended:Connect(function()pcall(function()sound:Destroy()end)end)task.delay(4,function()if sound and sound.Parent then pcall(function()sound:Destroy()end)end end)end)end task.spawn(function()pcall(_G.M4ToggleSFXPrepare)end)_G.M4ToggleSFXPlay=function()return false end for _,sound in ipairs(SoundService:GetChildren())do if sound:IsA("Sound")and sound.Name=="BLESSHalloweenModeMusic"then pcall(function()sound:Stop()sound:Destroy()end)end end _G.BLESSHalloweenMusic=nil  _G.M4ExtraSFX=_G.M4ExtraSFX or{}_G.M4ExtraSFX.Death={url="https://pdftolink.io/file/r2_dXNlcnMvZ3Vlc3QvOGU2YzczODgtOTA3OC00ZjM2LTk0NTctN2NjMTQxODViZjVhLm1wMw",file="M4LWARE_death_sfx.mp3",asset=nil,busy=false,last=0}function _G.M4ExtraSFXFetch(url)local body=nil local req=request or http_request or(syn and syn.request)or(fluxus and fluxus.request)if type(req)=="function"then pcall(function()local result=req({Url=url,Method="GET",Headers={["User-Agent"]="Mozilla/5.0"}})if result then body=result.Body or result.body end end)end if type(body)~="string"or body==""then pcall(function()body=game:HttpGet(url,true)end)end return body end function _G.M4PrepareExtraSFX(name)local slot=_G.M4ExtraSFX and _G.M4ExtraSFX[name]if not slot then return nil end if slot.asset then return slot.asset end if slot.busy then local timeout=os.clock()+3 while slot.busy and os.clock()<timeout do task.wait(0.03)end return slot.asset end slot.busy=true _resolveFS()local env=(type(getgenv)=="function"and getgenv())or _G local assetFn=getcustomasset or getsynasset or(syn and(syn.getcustomasset or syn.getsynasset))or(type(env)=="table"and(env.getcustomasset or env.getsynasset))if type(assetFn)~="function"or type(_wf)~="function"then slot.busy=false return nil end local exists=false exists=_ace_isfile(slot.file)if exists and type(readfile)=="function"then pcall(function()local cached=readfile(slot.file)local head=type(cached)=="string"and cached:sub(1,512):lower()or""if type(cached)~="string"or#cached<128 or head:find("<html",1,true)or head:find("<!doctype",1,true)then if type(delfile)=="function"then delfile(slot.file)end exists=false end end)end if not exists then local body=_G.M4ExtraSFXFetch(slot.url)if type(body)=="string"and#body>0 then local head=body:sub(1,768):lower()if head:find("<html",1,true)or head:find("<!doctype",1,true)or head:find("<audio",1,true)then local page=body:gsub("\\/","/"):gsub("&amp;","&")local direct=page:match([=[<audio[^>]-src=["']([^"']+)["']]=])or page:match([=[<source[^>]-src=["']([^"']+)["']]=])or page:match([=["audioUrl"%s*:%s*"([^"]+)"]=])or page:match([=["fileUrl"%s*:%s*"([^"]+)"]=])or page:match([=["downloadUrl"%s*:%s*"([^"]+)"]=])or page:match([=[(https?://[^"'<>%s]+%.mp3[^"'<>%s]*)]=])if direct then direct=direct:gsub("\\u0026","&")if direct:sub(1,2)=="//"then direct="https:"..direct elseif direct:sub(1,1)=="/"then direct="https://pdftolink.io"..direct end body=_G.M4ExtraSFXFetch(direct)end end end if type(body)=="string"and#body>128 then local lower=body:sub(1,256):lower()if not lower:find("<html",1,true)and not lower:find("<!doctype",1,true)then _ace_writefile(slot.file,body)end end end if _ace_isfile(slot.file)then local okFile,hasFile=true,true if hasFile then local okAsset,id=pcall(assetFn,slot.file)if okAsset and type(id)=="string"and id~=""then slot.asset=id end end end slot.busy=false return slot.asset end function _G.M4PlayExtraSFX(name,maxDuration)local slot=_G.M4ExtraSFX and _G.M4ExtraSFX[name]if not slot then return false end local now=os.clock()local cooldown=0.35 if now-(slot.last or 0)<cooldown then return false end local id=slot.asset if not id then id=_G.M4PrepareExtraSFX(name)end local customReady=id~=nil local sound=Instance.new("Sound")sound.Name="M4LWARE"..tostring(name).."SFX"sound.SoundId=id or"rbxasset://sounds/electronicpingshort.wav"sound.Volume=1 sound.Looped=false sound.RollOffMode=Enum.RollOffMode.InverseTapered sound.Parent=SoundService local loaded=false pcall(function()game:GetService("ContentProvider"):PreloadAsync({sound})loaded=sound.IsLoaded or sound.TimeLength>0 end)if not loaded then local deadline=os.clock()+1.2 while os.clock()<deadline and sound.Parent and not sound.IsLoaded do task.wait(0.03)end loaded=sound.Parent and(sound.IsLoaded or sound.TimeLength>0)end if not loaded then pcall(function()sound:Destroy()end)return false end slot.last=os.clock()local played=false if name=="Death"then if _G.M4ActiveDeathSound then pcall(function()_G.M4ActiveDeathSound:Stop()end)pcall(function()_G.M4ActiveDeathSound:Destroy()end)_G.M4ActiveDeathSound=nil end _G.M4ActiveDeathSound=sound pcall(function()sound.TimePosition=0 sound:Play()played=true end)if not played then pcall(function()sound:Destroy()end)if _G.M4ActiveDeathSound==sound then _G.M4ActiveDeathSound=nil end return false end local duration=tonumber(maxDuration)or 0.59 local stopAt=os.clock()+duration task.spawn(function()while sound and sound.Parent and os.clock()<stopAt do game:GetService("RunService").Heartbeat:Wait()end if sound then pcall(function()sound:Stop()sound.TimePosition=0 end)pcall(function()sound:Destroy()end)end if _G.M4ActiveDeathSound==sound then _G.M4ActiveDeathSound=nil end end)return true end pcall(function()sound.TimePosition=0 SoundService:PlayLocalSound(sound)played=true end)if not played then pcall(function()sound.TimePosition=0 sound:Play()played=true end)end if not played then pcall(function()sound:Destroy()end)return false end if tonumber(maxDuration)and maxDuration>0 then task.delay(maxDuration,function()if sound and sound.Parent then pcall(function()sound:Stop()end)pcall(function()sound:Destroy()end)end end)else sound.Ended:Connect(function()pcall(function()sound:Destroy()end)end)task.delay(6,function()if sound and sound.Parent then pcall(function()sound:Stop()end)pcall(function()sound:Destroy()end)end end)end return true end task.spawn(function()pcall(_G.M4PrepareExtraSFX,"Death")end)if _G.KillHub and type(_G.KillHub.StopAll)=="function"then pcall(_G.KillHub.StopAll)end if type(stopDropBrainrot)=="function"then pcall(stopDropBrainrot)end _G.KillHub=_G.KillHub or{}_G.KillHub.Connections={aimbot=nil,bypass=nil,autoLeft=nil,autoRight=nil,bodyLock=nil,dropBrainrot=nil,antiRagdoll=nil,ragdollCountdown=nil,infJump=nil,autoTPDown=nil,enemySpeed=nil,movement=nil,speedRender=nil,speedPost=nil,stepped=nil,stretch=nil,stretchFov=nil,antiLagDesc=nil,esp=nil,batCounter=nil,medusa={},steal=nil,progress=nil,}_G.KillHub.Active={autoBat=false,bypass=false,autoLeft=false,autoRight=false,bodyLock=false,antiRagdoll=false,ragdollCountdown=false,antiDie=false,jump=false,medusa=false,batCounter=false,autoTPDown=false,antiLag=false,stretch=false,esp=false,steal=false,}_G.KillHub.SafeModeLocked=false _G.KillHub.OriginalOutfit={shirt=nil,pants=nil}_G.KillHub.OriginalAccessories={}
function uiVisual.getBubbleMovementFlags()
    return speedMode==true,laggerToggled==true,tonumber(laggerLevel)or 1,
        autoBatEnabled==true,batV2Enabled==true,autoLeftEnabled==true,autoRightEnabled==true,
        bypassToggled==true,_G.M4AutoSpeedEnabled==true and _G.M4AutoSpeedMode~="Soft Steal",
        antiDieEnabled==true,autoTPDownEnabled==true,autoTPDownHeight,BAT_V2_SPEED
end
function uiVisual.getMovementSpeeds()
    return NS,CS,
        LAGGER_SPEED_1,LAGGER_SPEED_2
end
function uiVisual.bubbleDropChanged(on)
    dropActive=on==true
    _G.dropActive=dropActive
    if not dropActive then _G.KillHub.Connections.dropBrainrot=nil end
    if dropBrainrotSetVisual then dropBrainrotSetVisual(dropActive)end
    if mobSetDropBR then mobSetDropBR(dropActive)end
end
function uiVisual.stopBubbleConflicts()
    if bypassToggled and stopBypassAimbot then stopBypassAimbot()end
end
-- Bubble engines. Source functions are kept intact inside scoped adapters.
do
    local hostGlobal, hostTask = _G, task
    for _, key in ipairs({"__CandyBubbleCleanup", "__CandyYoutBatCleanup", "__CandyCleanBatCleanup", "__BlessCleanBatCleanup"}) do
        if type(hostGlobal[key]) == "function" then pcall(hostGlobal[key]) end
        hostGlobal[key] = nil
    end
    if type(hostGlobal.__YoutStopSpeedEngine) == "function" then pcall(hostGlobal.__YoutStopSpeedEngine) end
    local api = {alive=true, connections={}, stoppers={}, tasks={}}
    uiVisual.bubble = api
    local K, R, m = Players, UIS, LP
    local FeatureToggles, W, U = {}, {}, {}
    local E = {["Speed Boost"]=false}
    local N = {NormalBoost=59,NormalSteal=29,LaggerBoost=40,LaggerSteal=20,
        DesyncBoost=59,DesyncSteal=29,CypherAimbotApproachSpeed=55,AutoTPDownHeight=20}
    local I = {}
    local _, z, S, g, O, n, J, f = "Normal",59,29,40,false,"v1",false,Vector3.zero
    local o = {
        [Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
        [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true,
    }
    local a, autoplayActive = false, false
    local _cypherStartFollowing, _cypherStop
    local H = {}
    local values = {__BUBBLE_STATE=H,
        __BubbleS2SpeedState=hostGlobal.__CandyBubbleHookState or {hooked=false}}
    hostGlobal.__CandyBubbleHookState=values.__BubbleS2SpeedState
    local _G = setmetatable({}, {
        __index=function(_,key)return values[key]end,
        __newindex=function(_,key,value)
            values[key]=value
            if key=="dropActive" or key=="IsDropping" then
                hostGlobal[key]=value==true
                if key=="dropActive" then uiVisual.bubbleDropChanged(value==true) end
            elseif key=="__speedBoostConn" then
                hostGlobal.KillHub.Connections.speedRender=value
            end
        end,
    })
    local function track(connection)
        local kept, found = {}, false
        for _, previous in ipairs(api.connections) do
            if previous.Connected then
                kept[#kept+1]=previous
                if previous==connection then found=true end
            end
        end
        if api.alive and not found then kept[#kept+1]=connection
        elseif not api.alive then connection:Disconnect() end
        api.connections=kept
        return connection
    end
    _G.__BubbleTrackConn=track
    _G.__BubbleTrackStopper=function(stop)api.stoppers[#api.stoppers+1]=stop end
    local function keepTask(thread)
        local kept,found={},false
        for _, previous in ipairs(api.tasks) do
            if coroutine.status(previous)~="dead" then
                kept[#kept+1]=previous
                if previous==thread then found=true end
            end
        end
        if not found and coroutine.status(thread)~="dead" then kept[#kept+1]=thread end
        api.tasks=kept
        return thread
    end
    local task=setmetatable({
        wait=function(...)keepTask(coroutine.running());return hostTask.wait(...)end,
        spawn=function(fn,...)return keepTask(hostTask.spawn(fn,...))end,
        defer=function(fn,...)return keepTask(hostTask.defer(fn,...))end,
        delay=function(delay,fn,...)return keepTask(hostTask.delay(delay,fn,...))end,
    },{__index=hostTask})
    function api.sync()
        if not api.alive then return end
        local normal,carry,lagger,laggerCarry=uiVisual.getMovementSpeeds()
        N.NormalBoost,N.NormalSteal=normal or 59,carry or 29
        N.LaggerBoost,N.LaggerSteal=lagger or 40,laggerCarry or 20
        z,S,g=N.NormalBoost,N.NormalSteal,N.LaggerBoost
        local carryFlag,laggerFlag,level,normalBat,bypassBat,left,right,tp,autoCarry,antiDie,autoTP,height,batSpeed=uiVisual.getBubbleMovementFlags()
        _=laggerFlag and "Lagger" or "Normal"
        J=laggerFlag
        O=carryFlag or (laggerFlag and level==2)
        E["Carry Speed"]=O
        E["Auto Carry Speed"]=autoCarry
        E.Autoplay=left or right
        E["TP Bat"]=tp
        E.Aimbot=bypassBat
        E["Lagger Aimbot"]=normalBat
        E["Anti Die"]=antiDie
        E["Auto TP Down"]=autoTP
        N.AutoTPDownHeight=height or 20
        N.CypherAimbotApproachSpeed=batSpeed or 55
    end
    local sourceRunService=RunService
    local signals={}
    local c=setmetatable({}, {__index=function(_,key)
        local signal=sourceRunService[key]
        if key~="Heartbeat" and key~="RenderStepped" and key~="PreSimulation" and key~="Stepped" then return signal end
        if not signals[key] then
            signals[key]={
                Connect=function(_,callback)
                    return track(signal:Connect(function(...)
                        if not api.alive then return end
                        api.sync()
                        return callback(...)
                    end))
                end,
                Wait=function()return signal:Wait()end,
            }
        end
        return signals[key]
    end})
    local function ci()
        if uiVisual.stopBubbleConflicts then uiVisual.stopBubbleConflicts() end
    end
    _G.__stopAutoplay=ci
    _G.__deactivateBatExclusive=function()end
    _G.__BubbleAntiDieGuiEnabled=function()return E["Anti Die"]==true end

    do
        local E, s = false, false;
        _G.__BubbleAntiDieGuiEnabled = nil;
        local b, V = {};
        local function F(N, I)
            local P = b[N];
            if P then
                if P.healthConn then
                    pcall(function() P.healthConn:Disconnect(); end);
                end;
                if P.diedConn then
                    pcall(function() P.diedConn:Disconnect(); end);
                end;
                if P.cleanupConn then
                    pcall(function() P.cleanupConn:Disconnect(); end);
                end;
                b[N] = nil;
            end;
            if I and N and N.Parent then
                pcall(function() local I = N:FindFirstChildOfClass("Humanoid"); if I then I.BreakJointsOnDeath = true; I:SetStateEnabled(Enum.HumanoidStateType.Dead, true); end; end);
            end;
        end;
        local function N(I)
            if not I or not I.Parent then
                return;
            end;
            local P = I:FindFirstChildOfClass("Humanoid");
            if not P then
                return;
            end;
            F(I, false);
            P.BreakJointsOnDeath = false;
            P:SetStateEnabled(Enum.HumanoidStateType.Dead, false);
            local k;
            k = {humanoid = P, healthConn = P:GetPropertyChangedSignal("Health"):Connect(function() if E and b[I] == k and P.Health <= 0 then P.Health = P.MaxHealth; end; end), diedConn = P.Died:Connect(function() task.defer(function() if E and b[I] == k and P and P.Parent then P.BreakJointsOnDeath = false; P:SetStateEnabled(Enum.HumanoidStateType.Dead, false); P.Health = P.MaxHealth; end; end); end), cleanupConn = I.AncestryChanged:Connect(function() if not I.Parent then F(I, false); end; end)};
            b[I] = k;
        end;
        local function I(P)
            P = P == true;
            if P == E then
                return;
            end;
            E = P;
            if P then
                local P = V;
                if not P then
                    V = m.CharacterAdded:Connect(function(k) task.wait(0.2); if E and k and k.Parent then N(k); end; end);
                end;
                P = m.Character;
                if P and P.Parent and not b[P] then
                    N(P);
                end;
            else
                for P in pairs(b) do
                    F(P, true);
                end;
            end;
        end;
        local F = {toggle = false, autobat = false};
        local function P()
            if s then
                return;
            end;
            local k = F.toggle;
            I((if _G.__BubbleAntiDieGuiEnabled then _G.__BubbleAntiDieGuiEnabled () == true else k) or F.autobat);
        end;
        function _G.__BubbleAntiDieSource (k, x)
            if s or F[k] == nil then
                return;
            end;
            F[k] = x == true;
            P();
        end;
        function _G.__BubbleAntiDieSet (k)
            _G.__BubbleAntiDieSource ("autobat", k);
        end;
        function _G.__BubbleAntiDieIsEnabled ()
            return E;
        end;
        _G.__BubbleTrackStopper (function() s = true; F.toggle = false; F.autobat = false; I(false); end);
        local F, k = false, I;
        I = function(I)
            k(I);
            if V and not F then
                F = true;
                _G.__BubbleTrackConn (V);
            end;
        end;
        _G.__BubbleTrackConn (c.Heartbeat:Connect(function() if s then return; end; P(); if not E then return; end; local E = m.Character; local s = E and E.Parent and(E:FindFirstChildOfClass("Humanoid")); if not s then return; end; local V = b[E]; if not V or V.humanoid ~= s then N(E); end; if s.BreakJointsOnDeath then s.BreakJointsOnDeath = false; end; if s:GetStateEnabled(Enum.HumanoidStateType.Dead) then s:SetStateEnabled(Enum.HumanoidStateType.Dead, false); end; if s.Health <= 0 then s.Health = s.MaxHealth; end; end));

        api.attachAntiDie=N
    end
    _G.__BubbleAntiDieGuiEnabled=function()return E["Anti Die"]==true end
    function api.setAntiDie(on)
        E["Anti Die"]=on==true
        _G.__BubbleAntiDieSource("toggle",on==true)
    end

    do
                local function Pi()
                    if _ == "Lagger" or J then
                        return N.LaggerBoost or g;
                    elseif _ == "Desync" then
                        return N.DesyncBoost or z;
                    end;
                    for ki, ki in ipairs(I) do
                        if _ == ki.name then
                            return ki.boost;
                        end;
                    end;
                    return N.NormalBoost or z;
                end;

                local function ki()
                    if _ == "Lagger" or J then
                        return N.LaggerSteal or S;
                    elseif _ == "Desync" then
                        return N.DesyncSteal or S;
                    end;
                    for J, J in ipairs(I) do
                        if _ == J.name then
                            return J.steal;
                        end;
                    end;
                    return N.NormalSteal or S;
                end;
                local function J(xi)
                    return O or xi and E["Auto Carry Speed"];
                end;

        do
                    ii = _G.__BubbleSpeedSpoofState;
                    if type(ii) == "table" then
                        ii.enabled = false;
                    end;
                    local xi = _G.__BubbleS2SpeedState;
                    if type(xi) ~= "table" then
                        xi = {hooked = false};
                        _G.__BubbleS2SpeedState = xi;
                    end;
                    xi.enabled = false;
                    xi.root = nil;
                    xi.velChecked = setmetatable({}, {__mode = "k"});
                    local function _i (Li)
                        xi.velChecked = setmetatable({}, {__mode = "k"});
                        if not Li then
                            xi.root = nil;
                            return nil;
                        end;
                        local zi = Li:WaitForChild("HumanoidRootPart", 5);
                        if zi then
                            xi.root = zi;
                            xi.velChecked[zi] = true;
                        end;
                        return zi;
                    end;
                    local function Li(zi)
                        if not zi then
                            return;
                        end;
                        xi.root = zi;
                        xi.velChecked[zi] = true;
                        if xi.hooked then
                            return;
                        end;
                        if type(getrawmetatable) ~= "function" or type(setreadonly) ~= "function" or type(newcclosure) ~= "function" or type(checkcaller) ~= "function" then
                            return;
                        end;
                        pcall(function() local zi = getrawmetatable(game); if not zi then return; end; local Si = rawget(zi, "__index"); if type(Si) ~= "function" and type(Si) ~= "table" then return; end; local gi = newcclosure(function(Oi, ni) local Ji = if type(Si) == "function" then(Si(Oi, ni)) else Si[ni]; if not checkcaller() and xi.velChecked[Oi] and(ni == "AssemblyLinearVelocity" or ni == "Velocity") and typeof(Ji) == "Vector3" and Ji.Magnitude > 20 then return Ji.Unit * 20; end; return Ji; end); setreadonly(zi, false); zi.__index = gi; xi.hooked = true; setreadonly(zi, true); end);
                    end;
                    local function zi()
                        f = Vector3.zero;
                        xi.enabled = false;
                    end;
                    function _G.__BubbleResetSpeedDirection ()
                        f = Vector3.zero;
                        local Si = m.Character;
                        local gi, Oi = Si and(Si:FindFirstChildOfClass("Humanoid")), Si and(Si:FindFirstChild("HumanoidRootPart"));
                        if gi and Oi and gi.MoveDirection.Magnitude <= 0.05 then
                            Oi.AssemblyLinearVelocity = Vector3.new(0, Oi.AssemblyLinearVelocity.Y, 0);
                        end;
                    end;
                    local function Si(gi)
                        if not gi then
                            return true;
                        end;
                        local Oi = gi:GetState();
                        return gi.PlatformStand or Oi == Enum.HumanoidStateType.Physics or Oi == Enum.HumanoidStateType.Ragdoll or Oi == Enum.HumanoidStateType.FallingDown;
                    end;
                    local function gi(Oi)
                        if J(Oi) then
                            return ki();
                        end;
                        return Pi();
                    end;
                    local function J()
                        if _G.__speedBoostConn then
                            _G.__speedBoostConn:Disconnect();
                            _G.__speedBoostConn = nil;
                        end;
                        zi();
                    end;
                    local function Oi(ni, Ji)
                        local fi = m.Character;
                        local oi, qi = fi and(fi:FindFirstChildOfClass("Humanoid")), fi and(fi:FindFirstChild("HumanoidRootPart"));
                        if not oi or not qi or oi.Health <= 0 then
                            return;
                        end;
                        if type(Ji) ~= "number" or Ji ~= Ji or Ji <= 0 or Ji == math.huge then
                            return;
                        end;
                        oi = qi.AssemblyLinearVelocity.Y;
                        if _G._ZurichHub_MovementBlocked == true or _G._BubbleHub_MovementBlocked == true then
                            qi.AssemblyLinearVelocity = Vector3.new(0, math.min(oi, 0), 0);
                            return;
                        end;
                        if ni and ni.Magnitude > 0.05 then
                            pcall(function() if qi.SetNetworkOwner then qi:SetNetworkOwner(m); end; end);
                            fi = ni.Unit;
                            qi.AssemblyLinearVelocity = Vector3.new(fi.X * Ji, oi, fi.Z * Ji);
                        else
                            qi.AssemblyLinearVelocity = Vector3.new(0, oi, 0);
                        end;
                    end;
                    local function ni()
                        J();
                        _G.__speedBoostConn = c.RenderStepped:Connect(function() if not E["Speed Boost"] then return; end; local Ji = m.Character; local fi, oi = Ji and(Ji:FindFirstChildOfClass("Humanoid")), Ji and(Ji:FindFirstChild("HumanoidRootPart")); if not fi or not oi or fi.Health <= 0 then return; end; if E.Autoplay or E["TP Bat"] or E.Aimbot or E["Lagger Aimbot"] or _G.dropActive or _G.IsDropping then zi(); return; end; if Si(fi) then f = Vector3.zero; return; end; if xi.root ~= oi or not xi.velChecked[oi] then f = Vector3.zero; _i (Ji); Li(oi); end; xi.enabled = true; oi = nil; if fi.MoveDirection.Magnitude > 0 then f = fi.MoveDirection; oi = fi.MoveDirection; elseif f.Magnitude > 0 then for Ji in pairs(o) do if R:IsKeyDown(Ji) then oi = f; break; end; end; end; Oi(oi, tonumber((gi(m:GetAttribute("Stealing") == true))) or 16); end);
                    end;
                    local function f()
                        if not E["Speed Boost"] then
                            return;
                        end;
                        local o = m.Character;
                        local Ji = o and(o:FindFirstChildOfClass("Humanoid"));
                        if not Ji or Ji.Health <= 0 or(Si(Ji)) then
                            return;
                        end;
                        Oi(Ji.MoveDirection.Magnitude > 0.05 and Ji.MoveDirection or nil, gi(m:GetAttribute("Stealing") == true));
                    end;
                    local function o()
                        E["Speed Boost"] = true;
                        ni();
                    end;
                    _G.__refreshSpeedBoost = o;
                    _G.__stopSpeedBoost = J;
                    _G.__BubbleTrackStopper (function() E["Speed Boost"] = false; J(); xi.root = nil; _G.__BubbleResetSpeedDirection = nil; end);
                    if m.Character then
                        Li((_i (m.Character)));
                    end;
                    if E["Speed Boost"] then
                        ni();
                    end;
                    _G.__BubbleTrackConn (m.CharacterAdded:Connect(function(Si) task.wait(0.5); zi(); local zi = Si:WaitForChild("HumanoidRootPart", 5); if zi then _i (Si); Li(zi); end; if E["Speed Boost"] then ni(); end; end));
                    _G.__BubbleTrackConn (m.CharacterRemoving:Connect(function() J(); xi.root = nil; xi.velChecked = setmetatable({}, {__mode = "k"}); end));
                    FeatureToggles["Speed Boost"] = nil;
                    W["Speed Boost"] = function()
                        E["Speed Boost"] = true;
                        ni();
                    end;

            api.applyVelocity=Oi
            api.applyNow=f
            api.isRagdoll=Si
            api.getSpeed=function()return gi(m:GetAttribute("Stealing")==true)end
        end
    end
    function api.startSpeed()
        api.sync()
        _G.__refreshSpeedBoost()
        return _G.__speedBoostConn
    end
    function api.stopSpeed()
        E["Speed Boost"]=false
        _G.__stopSpeedBoost()
    end
    function api.speedRunning()return _G.__speedBoostConn~=nil end

    do
                        local J, f, o, Pi = 0, false, 0, true;
                        local function ki()
                            o += 1;
                            f = false;
                        end;
                        _G.__BubbleTrackConn (m.CharacterRemoving:Connect(ki));
                        _G.__BubbleTrackStopper (function() Pi = false; ki(); end);
                        local function xi()
                            if not Pi or _G.dropActive or _G.IsDropping then
                                return;
                            end;
                            local Pi = 0.1 - (os.clock() - J);
                            if Pi > 0 then
                                if not f then
                                    f = true;
                                    local _i, Li = o, m.Character;
                                    task.delay(Pi, function() if _i ~= o or m.Character ~= Li then return; end; f = false; xi(); end);
                                end;
                                return;
                            end;
                            Pi = m.Character;
                            if not Pi then
                                return;
                            end;
                            local f = Pi:FindFirstChild("HumanoidRootPart");
                            if not f then
                                return;
                            end;
                            local o = Pi:FindFirstChildOfClass("Humanoid");
                            if not o or o.Health <= 0 or f.Anchored or o.Sit or o.SeatPart then
                                return;
                            end;
                            J = os.clock();
                            ki();
                            local J, J = f.CFrame:ToEulerAnglesYXZ();
                            pcall(function() f.CFrame = CFrame.new(f.Position.X,- 7, f.Position.Z) * CFrame.Angles(0, J, 0); f.AssemblyLinearVelocity = Vector3.zero; end);
                        end;
                        _G.ExecuteTPDown = xi;
                        FeatureToggles["TP Down"] = xi;

        api.cancelTPDown=ki
                        local J, f, o = 0, false;
                        local Pi = RaycastParams.new();
                        Pi.FilterType = Enum.RaycastFilterType.Exclude;
                        pcall(function() Pi.RespectCanCollide = true; end);
                        W["Auto TP Down"] = function(ki)
                            if not ki then
                                J, f, o = 0, false, nil;
                            end;
                        end;
                        _G.__BubbleTrackConn (c.Heartbeat:Connect(function(ki) if E["Auto TP Down"] ~= true then return; end; if _G.dropActive or _G.IsDropping then J = 0; return; end; J += ki or 0; if J < 0.1 then return; end; J = 0; ki = m.Character; local J, _i = ki and(ki:FindFirstChildOfClass("Humanoid")), ki and(ki:FindFirstChild("HumanoidRootPart")); if not _i or not J or J.Health <= 0 then f, o = false, nil; return; end; if _i ~= o then o, f = _i, false; end; J = math.clamp(tonumber(N.AutoTPDownHeight) or 20, 1, 1000); Pi.FilterDescendantsInstances = {ki}; ki = workspace:Raycast(_i.Position, Vector3.new(0,- 2048, 0), Pi); local o = ki and(math.max(0, _i.Position.Y - ki.Position.Y)) or nil; ki = o ~= nil and o >= J; if ki and not f then f = true; xi(); elseif not ki then f = false; end; end));

        api.autoTPConnection=api.connections[#api.connections]
    end
    function api.tpDown()api.sync();return FeatureToggles["TP Down"]()end
    function api.setAutoTPDown(on)
        E["Auto TP Down"]=on==true
        W["Auto TP Down"](on==true)
    end

    do
                        local J, f = false;
                        local function o()
                            if J then
                                return;
                            end;
                            local Pi = m.Character;
                            if not Pi then
                                return;
                            end;
                            local ki = Pi:FindFirstChild("HumanoidRootPart");
                            if not ki then
                                return;
                            end;
                            if f then
                                f:Disconnect();
                                f = nil;
                            end;
                            local xi = ki.Position.Y;
                            J = true;
                            _G.dropActive = true;
                            _G.IsDropping = true;
                            local ki = tick();
                            f = c.Heartbeat:Connect(function() local _i = Pi and(Pi:FindFirstChild("HumanoidRootPart")); if not _i then f:Disconnect(); f, J = nil, false; _G.dropActive = false; _G.IsDropping = false; return; end; if tick() - ki >= 0.2 then f:Disconnect(); f = nil; local f, f = _i.CFrame:ToEulerAnglesYXZ(); _i.CFrame = CFrame.new(_i.Position.X, xi, _i.Position.Z) * CFrame.Angles(0, f, 0); _i.AssemblyLinearVelocity = Vector3.zero; pcall(function() _i.Velocity = Vector3.zero; end); J = false; _G.dropActive = false; _G.IsDropping = false; return; end; _i.AssemblyLinearVelocity = Vector3.new(_i.AssemblyLinearVelocity.X, 150, _i.AssemblyLinearVelocity.Z); end);
                        end;
                        FeatureToggles.Drop = o;
                        _G.doDrop = o;

        function api.runDrop()
            if J then return false end
            o()
            hostGlobal.KillHub.Connections.dropBrainrot=f
            return J==true
        end
        function api.stopDrop()
            if f then f:Disconnect();f=nil end
            J=false
            _G.dropActive=false
            _G.IsDropping=false
            hostGlobal.KillHub.Connections.dropBrainrot=nil
            local root=m.Character and m.Character:FindFirstChild("HumanoidRootPart")
            if root then root.AssemblyLinearVelocity=Vector3.zero end
        end
    end
    FeatureToggles.Drop=api.runDrop
                    function _G.__checkAndAutoDrop (J)
                        a = true;
                        local function f()
                            a = false;
                        end;
                        if m:GetAttribute("Stealing") then
                            local o = m.Character;
                            if not o then
                                if J then
                                    J();
                                end;
                                f();
                                return;
                            end;
                            local Pi, ki = o:FindFirstChildOfClass("Humanoid"), o:FindFirstChild("HumanoidRootPart");
                            if not Pi or not ki then
                                if J then
                                    J();
                                end;
                                f();
                                return;
                            end;
                            if FeatureToggles.Drop then
                                FeatureToggles.Drop();
                                Pi = tick();
                                while m:GetAttribute("Stealing") and tick() - Pi < 5 do
                                    task.wait();
                                end;
                            end;
                            if J then
                                J();
                            end;
                            f();
                        else
                            if J then
                                J();
                            end;
                            f();
                        end;
                    end;


    do
                                        local i = m;
                                        local function o()
                                            local a = i.Character;
                                            if a then
                                                local Pi = a:FindFirstChildOfClass("Tool");
                                                if Pi then
                                                    local a = Pi.Name:lower();
                                                    if a:find("bat", 1, true) or(a:find("slap", 1, true)) then
                                                        return Pi;
                                                    end;
                                                end;
                                                Pi = i:FindFirstChildOfClass("Backpack");
                                                if Pi then
                                                    for i, a in ipairs(Pi:GetChildren()) do
                                                        if a:IsA("Tool") then
                                                            i = a.Name:lower();
                                                            if i:find("bat", 1, true) or(i:find("slap", 1, true)) then
                                                                return a;
                                                            end;
                                                        end;
                                                    end;
                                                end;
                                            end;
                                            return nil;
                                        end;

                                                pcall(function() local i = workspace:FindFirstChild("PredictionSphere"); if i then i:Destroy(); end; end);
                                                local i, a, Pi = {targetPlayer = nil, lastTargetPos = nil, targetVelocity = Vector3.zero, smoothedVelocity = Vector3.zero, velocityHistory = {}, accelerationHistory = {}, aerialVelocityHistory = {}, verticalVelocityHistory = {}, previousDirection = nil, lastDirectionChangeTime = 0, airborneTime = 0, lastYVelocity = 0, lastJumpTime = 0, lastActivationTime = 0, currentPing = 0.1, realPingMs = 0}, {FOLLOW_SPEED = 55, ACTIVATE_DISTANCE = 13, MIN_FOLLOW_DISTANCE = 1, PREDICTION_TIME = 0.22, PREDICT_AHEAD = 3, MAX_VELOCITY_CHANGE = 150, VELOCITY_SMOOTHING = 0.2, MAX_HORIZONTAL_VELOCITY = 80, SERVER_TICKRATE = 0.016666666666666666, MIN_PING_COMPENSATION = 0.03, MAX_PING_COMPENSATION = 0.25, ACCELERATION_PREDICTION_WEIGHT = 0.3, DIRECTION_CHANGE_DETECTION_TIME = 0.12, QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5, GRAVITY = 196.2, AIR_CONTROL_FACTOR = 0.8, AERIAL_VELOCITY_DECAY = 0.95, MIN_AIRBORNE_TIME = 0.08, FALLING_SPEED_THRESHOLD =- 15};
                                                local function ki(xi)
                                                    if #xi == 0 then
                                                        return Vector3.zero;
                                                    end;
                                                    local _i = Vector3.zero;
                                                    for Li, Li in ipairs(xi) do
                                                        _i += Li;
                                                    end;
                                                    return _i / #xi;
                                                end;
                                                local function xi(_i, Li, zi)
                                                    table.insert(_i, Li);
                                                    if #_i > zi then
                                                        table.remove(_i, 1);
                                                    end;
                                                end;
                                                local function _i ()
                                                    i.targetPlayer = nil;
                                                    i.lastTargetPos = nil;
                                                    i.targetVelocity = Vector3.zero;
                                                    i.smoothedVelocity = Vector3.zero;
                                                    i.velocityHistory = {};
                                                    i.accelerationHistory = {};
                                                    i.aerialVelocityHistory = {};
                                                    i.verticalVelocityHistory = {};
                                                    i.previousDirection = nil;
                                                    i.airborneTime = 0;
                                                    i.lastYVelocity = 0;
                                                end;
                                                local function Li(zi)
                                                    local Si, gi = math.huge;
                                                    for Oi, ni in ipairs(K:GetPlayers()) do
                                                        if ni ~= m and ni.Character then
                                                            local Ji, fi = ni.Character:FindFirstChild("HumanoidRootPart"), ni.Character:FindFirstChildOfClass("Humanoid");
                                                            if Ji and fi and fi.Health > 0 then
                                                                Oi = (zi.Position - Ji.Position).Magnitude;
                                                                if Oi < Si then
                                                                    Si, gi = Oi, ni;
                                                                end;
                                                            end;
                                                        end;
                                                    end;
                                                    return gi;
                                                end;
                                                local function zi(Si, gi)
                                                    if gi.Magnitude < 0.01 then
                                                        return;
                                                    end;
                                                    local Oi = Si.CFrame.LookVector:Cross(gi.Unit);
                                                    gi = math.asin(math.clamp(Oi.Magnitude,- 1, 1));
                                                    Si.AssemblyAngularVelocity = Oi.Magnitude > 0.01 and Oi.Unit * gi * 80 or Vector3.zero;
                                                end;
                                                local function Si()
                                                    local gi, Oi = pcall(function() return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue(); end);
                                                    if gi and type(Oi) == "number" then
                                                        i.realPingMs = math.floor(Oi);
                                                    end;
                                                    i.currentPing = math.clamp(i.realPingMs / 1000, a.MIN_PING_COMPENSATION, a.MAX_PING_COMPENSATION);
                                                end;
                                                task.spawn(function() while _G.__BUBBLE_STATE == H do pcall(Si); task.wait(0.5); end; end);
                                                local function Si()
                                                    if Pi then
                                                        Pi:Disconnect();
                                                        Pi = nil;
                                                    end;
                                                    local gi = m.Character;
                                                    local Oi, ni = gi and(gi:FindFirstChildOfClass("Humanoid")), gi and(gi:FindFirstChild("HumanoidRootPart"));
                                                    if Oi then
                                                        Oi.AutoRotate = true;
                                                    end;
                                                    if ni then
                                                        ni.AssemblyAngularVelocity = Vector3.zero;
                                                    end;
                                                    _i ();
                                                    i.lastActivationTime = 0;
                                                end;
                                                local function gi(Oi)
                                                    Oi = Oi or m.Character;
                                                    local ni, Ji = Oi and(Oi:FindFirstChildOfClass("Humanoid")), Oi and(Oi:FindFirstChild("HumanoidRootPart"));
                                                    if not ni or not Ji then
                                                        return;
                                                    end;
                                                    Si();
                                                    ni.AutoRotate = false;
                                                    local fi = o();
                                                    if fi and fi.Parent ~= Oi then
                                                        pcall(ni.EquipTool, ni, fi);
                                                    end;
                                                    Pi = c.RenderStepped:Connect(function(Pi) if not E.Aimbot then Si(); return; end; local Oi = m.Character; local oi, qi = Oi and(Oi:FindFirstChild("HumanoidRootPart")), Oi and(Oi:FindFirstChildOfClass("Humanoid")); if not oi or not qi or qi.Health <= 0 then return; end; qi.AutoRotate = false; Ji, ni = oi, qi; fi = Oi:FindFirstChildOfClass("Tool") or(o()); if fi and fi.Parent ~= Oi then pcall(qi.EquipTool, qi, fi); end; Oi = nil; if _G.__BubbleTPBatGetMarkerCFrame then oi, qi = pcall(_G.__BubbleTPBatGetMarkerCFrame); Oi = if oi then qi else Oi; end; if Oi then oi = Oi.Position - Ji.Position; if oi.Magnitude > 0.1 then zi(Ji, oi); end; if oi.Magnitude > a.MIN_FOLLOW_DISTANCE then qi = tonumber(N.CypherAimbotApproachSpeed) or a.FOLLOW_SPEED; Ji.AssemblyLinearVelocity = oi.Unit * math.clamp(qi, 1, 120); else Ji.AssemblyLinearVelocity = Vector3.zero; end; return; end; i.targetPlayer = Li(Ji); oi = i.targetPlayer and i.targetPlayer.Character; qi, Oi = oi and(oi:FindFirstChild("HumanoidRootPart")), oi and(oi:FindFirstChildOfClass("Humanoid")); if not qi or not Oi or Oi.Health <= 0 then _i (); return; end; local o, _i = qi.Position, math.max(Pi, 0.004166666666666667); if i.lastTargetPos then oi = (o - i.lastTargetPos) / _i; Pi = oi - i.targetVelocity; oi = if Pi.Magnitude > a.MAX_VELOCITY_CHANGE then i.targetVelocity + Pi.Unit * a.MAX_VELOCITY_CHANGE else oi; qi = Vector3.new(oi.X, 0, oi.Z); if qi.Magnitude > a.MAX_HORIZONTAL_VELOCITY then qi = qi.Unit * a.MAX_HORIZONTAL_VELOCITY; oi = (Vector3.new(qi.X, oi.Y, qi.Z)); end; xi(i.accelerationHistory, (oi - i.targetVelocity) / _i, 4); xi(i.velocityHistory, oi, 8); xi(i.verticalVelocityHistory, oi.Y, 5); i.targetVelocity = oi; i.smoothedVelocity = i.smoothedVelocity:Lerp(oi, a.VELOCITY_SMOOTHING); end; i.lastTargetPos = o; Pi = Oi.FloorMaterial == Enum.Material.Air; i.airborneTime = Pi and i.airborneTime + _i or 0; if Pi and i.airborneTime >= a.MIN_AIRBORNE_TIME then xi(i.aerialVelocityHistory, i.targetVelocity, 6); elseif not Pi then i.aerialVelocityHistory = {}; end; qi = i.smoothedVelocity; if Pi and #i.aerialVelocityHistory > 0 then Oi = ki(i.aerialVelocityHistory); qi = Vector3.new(Oi.X, i.targetVelocity.Y, Oi.Z) * a.AIR_CONTROL_FACTOR; end; _i, Oi = false, Vector3.new(i.targetVelocity.X, 0, i.targetVelocity.Z); if Oi.Magnitude > 5 then oi = Oi.Unit; if i.previousDirection and i.previousDirection:Dot(oi) < 0.5 then _i = tick() - i.lastDirectionChangeTime < a.DIRECTION_CHANGE_DETECTION_TIME; i.lastDirectionChangeTime = tick(); end; i.previousDirection = oi; end; oi = i.currentPing + a.SERVER_TICKRATE; local xi, Li = o + qi * (if _i then oi * a.QUICK_DIRECTION_CHANGE_MULTIPLIER else oi) + ki(i.accelerationHistory) * a.ACCELERATION_PREDICTION_WEIGHT * ((if _i then oi * a.QUICK_DIRECTION_CHANGE_MULTIPLIER else oi) * (if _i then oi * a.QUICK_DIRECTION_CHANGE_MULTIPLIER else oi) * 0.5), a.PREDICTION_TIME * 1.1; xi = if Pi then xi + qi * Li + Vector3.new(0,- 0.5 * a.GRAVITY * Li * Li, 0) else xi + qi * Li; Oi = Vector3.new(qi.X, 0, qi.Z); Pi = (if Oi.Magnitude > 1 then xi + Oi.Unit * a.PREDICT_AHEAD else xi) - Ji.Position; zi(Ji, Pi); if(o - Ji.Position).Magnitude <= a.ACTIVATE_DISTANCE and tick() - i.lastActivationTime >= 0.3 then if fi then pcall(fi.Activate, fi); end; i.lastActivationTime = tick(); end; if Pi.Magnitude > a.MIN_FOLLOW_DISTANCE then qi = math.clamp(tonumber(N.CypherAimbotApproachSpeed) or a.FOLLOW_SPEED, 1, 120); Ji.AssemblyLinearVelocity = Pi.Unit * qi; else Ji.AssemblyLinearVelocity = Vector3.new(0, Ji.AssemblyLinearVelocity.Y * 0.5, 0); end; end);
                                                end;
                                                _cypherStartFollowing = gi;
                                                _cypherStop = Si;
                                                W.Aimbot = function(i)
                                                    if i then
                                                        if _G.__stopSpeedBoost then
                                                            _G.__stopSpeedBoost ();
                                                        end;
                                                        if autoplayActive or E.Autoplay then
                                                            _G.__stopAutoplay ();
                                                        end;
                                                        ci("Aimbot");
                                                        if _G.__deactivateBatExclusive then
                                                            _G.__deactivateBatExclusive ("Aimbot");
                                                        end;
                                                        _G.__checkAndAutoDrop (function() gi(m.Character); end);
                                                    else
                                                        Si();
                                                        if _G.__refreshSpeedBoost then
                                                            _G.__refreshSpeedBoost ();
                                                        end;
                                                    end;
                                                end;
                                                _G.__BubbleTrackStopper (Si);

        api.stopFollowing=Si
    end
    local batStartTask
    function api.startBat()
        api.sync()
        E.Aimbot=true
        if batStartTask then pcall(hostTask.cancel,batStartTask) end
        batStartTask=task.spawn(function()W.Aimbot(true)end)
        return E.Aimbot
    end
    function api.stopBat()
        E.Aimbot=false
        if batStartTask and batStartTask~=coroutine.running() then pcall(hostTask.cancel,batStartTask) end
        batStartTask=nil
        W.Aimbot(false)
    end
    function api.isBatEnabled()return api.alive and E.Aimbot==true end
    function api.setBatSpeed(value)N.CypherAimbotApproachSpeed=math.clamp(tonumber(value)or 55,1,120)end
    function api.stopAll()
        api.stopBat()
        api.stopDrop()
        api.setAutoTPDown(false)
        api.cancelTPDown()
        api.setAntiDie(false)
        api.stopSpeed()
    end
    function api.destroy()
        if not api.alive then return end
        api.stopAll()
        api.alive=false
        values.__BUBBLE_STATE=nil
        for _,stop in ipairs(api.stoppers)do pcall(stop)end
        for _,connection in ipairs(api.connections)do pcall(function()connection:Disconnect()end)end
        for _,thread in ipairs(api.tasks)do
            if thread~=coroutine.running() then pcall(hostTask.cancel,thread)end
        end
        api.tasks,api.connections={},{}
        values.__BubbleS2SpeedState.velChecked=setmetatable({}, {__mode="k"})
    end
    hostGlobal.__CandyBubbleCleanup=api.destroy
end

local CarrySystem
local lastMoveDir=Vector3.zero
do
local NS,CS,LAGGER_SPEED,LAGGER_CARRY_SPEED
local carrySpeedActive,laggerModeEnabled,laggerCarryActive=false,false,false
local function getActiveMoveSpeed()return uiVisual.bubble.getSpeed()end
local _csData = {
    speedToggled = false,
    laggerMode = 0,
    softStealEnabled = false,
    softStealLatched = false,
    _lvBoost = nil,
    _batAimbotToggled = false,
}
CarrySystem = setmetatable({}, {
    __newindex = function(t, k, v)
        _csData[k] = v
        if k == "speedToggled" then
            carrySpeedActive = v and true or false
        elseif k == "laggerMode" then
            if v == 0 then
                laggerModeEnabled = false; laggerCarryActive = false
            elseif v == 1 then
                laggerModeEnabled = true; laggerCarryActive = false; carrySpeedActive = false; _csData.speedToggled = false
            elseif v == 2 then
                laggerModeEnabled = false; laggerCarryActive = true; carrySpeedActive = false; _csData.speedToggled = false
            end
        end
    end,
    __index = _csData,
})

function CarrySystem:getCurrentSpeed() return getActiveMoveSpeed() end
function CarrySystem:getActiveSpeed() return getActiveMoveSpeed() end
function CarrySystem:getStatus()
    if laggerCarryActive then return "LAGGER CARRY", LAGGER_CARRY_SPEED
    elseif laggerModeEnabled then return "LAGGER", LAGGER_SPEED
    elseif carrySpeedActive then return "CARRY", CS
    else return "NORMAL", NS end
end
function CarrySystem:setNormalSpeed(v)
    v = tonumber(v)
    if not v then return NS end
    NS = math.clamp(v, 0.01, 500)
    return NS
end
function CarrySystem:setCarrySpeed(v)
    v = tonumber(v)
    if not v then return CS end
    CS = math.clamp(v, 0.01, 500)
    return CS
end
function CarrySystem:setLaggerSpeed(v)
    v = tonumber(v)
    if not v then return LAGGER_SPEED end
    LAGGER_SPEED = math.clamp(v, 0.01, 500)
    return LAGGER_SPEED
end
function CarrySystem:setLaggerCarrySpeed(v)
    v = tonumber(v)
    if not v then return LAGGER_CARRY_SPEED end
    LAGGER_CARRY_SPEED = math.clamp(v, 0.01, 500)
    return LAGGER_CARRY_SPEED
end
function CarrySystem:setSoftStealSpeed(v) end
function CarrySystem:setSoftStealRadius(v) end
function CarrySystem:setSoftStealEnabled(v) end
function CarrySystem:toggleSoftSteal() end
function CarrySystem:toggleCarryMode() self.speedToggled = not carrySpeedActive end
function CarrySystem:setLaggerMode(mode)
    self.laggerMode = mode
end
function CarrySystem:toggleLaggerMode()
    if self.laggerMode == 0 then self:setLaggerMode(1)
    elseif self.laggerMode == 1 then self:setLaggerMode(2)
    else self:setLaggerMode(0) end
end
function CarrySystem:isRunning() return uiVisual.bubble.speedRunning() end
function CarrySystem:isCarrying() return carrySpeedActive end


function CarrySystem:start()uiVisual.syncMovementSpeeds();uiVisual.bubble.startSpeed()end
function CarrySystem:stop()uiVisual.bubble.stopSpeed()end
function CarrySystem:_applyExactFrame()uiVisual.syncMovementSpeeds();uiVisual.bubble.applyNow()end
function CarrySystem:getStatus()
    local normal,carry,lagger,laggerCarry=uiVisual.getMovementSpeeds()
    if laggerCarryActive then return "LAGGER CARRY",laggerCarry
    elseif laggerModeEnabled then return "LAGGER",lagger
    elseif carrySpeedActive then return "CARRY",carry
    else return "NORMAL",normal end
end
function uiVisual.syncMovementSpeeds()
    local normal,carry,lagger,laggerCarry=uiVisual.getMovementSpeeds()
    CarrySystem:setNormalSpeed(normal or 59);CarrySystem:setCarrySpeed(carry or 29)
    CarrySystem:setLaggerSpeed(lagger or 40);CarrySystem:setLaggerCarrySpeed(laggerCarry or 20)
    local carryFlag,laggerFlag,level=uiVisual.getBubbleMovementFlags()
    CarrySystem.speedToggled=carryFlag and not laggerFlag
    CarrySystem:setLaggerMode(laggerFlag and level or 0)
    uiVisual.bubble.sync()
end
uiVisual.bubbleIsRagdollState=uiVisual.bubble.isRagdoll
_G.__K7_111Velocity=function(root,direction,targetSpeed)
    if not root or not direction then return nil end
    local flat=Vector3.new(direction.X,0,direction.Z)
    if flat.Magnitude<=0 then return nil end
    uiVisual.syncMovementSpeeds()
    uiVisual.bubble.applyVelocity(flat.Unit,tonumber(targetSpeed)or 59)
    return flat.Unit
end
_G.__K7_111VelocityIdle=function(root)
    if not root then return end
    uiVisual.syncMovementSpeeds()
    uiVisual.bubble.applyVelocity(nil,59)
end
end
_G.FearS2Speed = {}
local S2 = _G.FearS2Speed
S2.startMotor = function() uiVisual.syncMovementSpeeds(); CarrySystem:start() end
S2.stopMotor = function() CarrySystem:stop() end
S2.getActiveMoveSpeed = function() uiVisual.syncMovementSpeeds(); return CarrySystem:getActiveSpeed() end
S2.isRagdollState = function(hum)
    return uiVisual.bubbleIsRagdollState(hum)
end
S2.pauseVelocity = function(root)
    local char = LP.Character
    root = root or (char and char:FindFirstChild("HumanoidRootPart"))
    _G.__K7_111VelocityIdle(root)
end
S2.applyVelocitySpeed = function(direction, speed, root)
    local char = LP.Character
    root = root or (char and char:FindFirstChild("HumanoidRootPart"))
    if direction and direction.Magnitude > 0.05 then _G.__K7_111Velocity(root, direction, speed)
    else _G.__K7_111VelocityIdle(root) end
end
_G._RaVeClearSpeedMover = function() lastMoveDir = Vector3.zero; S2.pauseVelocity() end


function _G.KillHub.StopAll()
    if stopDropBrainrot then pcall(stopDropBrainrot)end
    if uiVisual.bubble then pcall(uiVisual.bubble.stopAll)end
    if uiVisual.shutdownYoutAntiRagdollBindings then pcall(uiVisual.shutdownYoutAntiRagdollBindings)end
    if uiVisual.stopAntiRagdollEngines then pcall(uiVisual.stopAntiRagdollEngines) end if _G.KillHub.Connections.speedCharacter then pcall(function()_G.KillHub.Connections.speedCharacter:Disconnect()end)_G.KillHub.Connections.speedCharacter=nil end if _G.__BlessAutoSpin then pcall(_G.__BlessAutoSpin.Shutdown) end if type(_G.KillHub.StopRagdollCountdown)=="function" then pcall(_G.KillHub.StopRagdollCountdown) end if _G.__BlessFloat then pcall(_G.__BlessFloat.disable) end   
    if stopAutoTPDown then pcall(stopAutoTPDown) end
    if type(stopBatCounter) == "function" then pcall(stopBatCounter) end
    if stopJumpMode then pcall(stopJumpMode) end
    if stopBypassAimbot then pcall(stopBypassAimbot) end
    if disableAutoBat then pcall(disableAutoBat) end
if stopBatV2 then pcall(stopBatV2)end if uiVisual.setTronTrail then uiVisual.setTronTrail(false,false)end S2.stopMotor()if stopAutoSteal then pcall(stopAutoSteal)end if uiVisual.setPerformance120 then uiVisual.setPerformance120(false)end for _,conn in pairs(_G.KillHub.Connections)do if type(conn)=="RBXScriptConnection"then pcall(function()conn:Disconnect()end)elseif type(conn)=="table"then for _,c in ipairs(conn)do if type(c)=="RBXScriptConnection"then pcall(function()c:Disconnect()end)end end end end _G.KillHub.Connections.aimbot=nil _G.KillHub.Connections.bypass=nil _G.KillHub.Connections.autoLeft=nil _G.KillHub.Connections.autoRight=nil _G.KillHub.Connections.bodyLock=nil _G.KillHub.Connections.dropBrainrot=nil _G.KillHub.Connections.antiRagdoll=nil _G.KillHub.Connections.ragdollCountdown=nil _G.KillHub.Connections.infJump=nil _G.KillHub.Connections.autoTPDown=nil _G.KillHub.Connections.enemySpeed=nil _G.KillHub.Connections.movement=nil _G.KillHub.Connections.speedRender=nil _G.KillHub.Connections.speedPost=nil _G.KillHub.Connections.stepped=nil _G.KillHub.Connections.stretch=nil _G.KillHub.Connections.stretchFov=nil _G.KillHub.Connections.antiLagDesc=nil _G.KillHub.Connections.esp=nil _G.KillHub.Connections.batCounter=nil _G.KillHub.Connections.medusa={}_G.KillHub.Connections.steal=nil _G.KillHub.Connections.progress=nil _G.KillHub.Active.autoBat=false _G.KillHub.Active.bypass=false _G.KillHub.Active.autoLeft=false _G.KillHub.Active.autoRight=false _G.KillHub.Active.bodyLock=false _G.KillHub.Active.antiRagdoll=false _G.KillHub.Active.ragdollCountdown=false _G.KillHub.Active.antiDie=false _G.KillHub.Active.jump=false _G.KillHub.Active.medusa=false _G.KillHub.Active.batCounter=false _G.KillHub.Active.autoTPDown=false _G.KillHub.Active.antiLag=false _G.KillHub.Active.stretch=false _G.KillHub.Active.esp=false _G.KillHub.Active.steal=false if stopAntiDie then pcall(stopAntiDie)end _G.KillHub.SafeModeLocked=false _blSuppressCount=0 _blWasEnabled=false if _blRestoreTimer then task.cancel(_blRestoreTimer);_blRestoreTimer=nil end end
 NS=59 CS=29 LAGGER_SPEED_1=40 LAGGER_SPEED_2=20 MEDUSA_COOLDOWN=25 BAT_AIMBOT_SPEED=58 BYPASS_AIMBOT_SPEED=58 BAT_V2_SPEED=55 MOBILE_PANEL_WIDTH=128 MOBILE_PANEL_HEIGHT=450 BAT_V2_HIT_DIST=4.5 _isDraggingButton=false speedMode=false antiRagdollEnabled=false antiRagdollMode="off" ragdollCountdownEnabled=false antiDieEnabled=false jumpEnabled=false laggerToggled=false laggerLevel=1 medusaCounterEnabled=false batCounterEnabled=false autoLeftEnabled=false autoRightEnabled=false autoBatEnabled=false aimbotMode="old"batV2Enabled=false bypassToggled=false antiDesyncAutoSwingEnabled=true normalBatAutoSwingEnabled=true normalBatAutoSwingSetVisual=nil _G.AceAntiDesyncAimbotOn=false antiLagEnabled=false removeAccessoriesEnabled=false stretchEnabled=false uiLocked=false editModeEnabled=false uiScaleValue=100 buttonScaleValue=1.0 buttonShapeMode=(tonumber(_G.BlessvsButtonShapeMode)==2 or tonumber(_G.VeoraButtonShapeMode)==2)and 2 or 1 stealBarScaleValue=100 espEnabled=false mikuSkyEnabled=false _G.M4ShinyEnabled=_G.M4ShinyEnabled==true _G.M4AutoSpeedEnabled=_G.M4AutoSpeedEnabled==true _G.BlessAutoSpinEnabled=_G.BlessAutoSpinEnabled==true _G.M4AutoSpeedMode=_G.M4AutoSpeedMode or"On Pick Up"_G.M4AutoSpeedRange=tonumber(_G.M4AutoSpeedRange)or 15 _G.M4RagdollStealEnabled=_G.M4RagdollStealEnabled==true CONFIG={AUTO_STEAL_ENABLED=false,STEAL_RANGE=65,}local Steal={AutoStealEnabled=false,StealRadius=CONFIG.STEAL_RANGE,StealDuration=1.3,StealDelay=0.25,Data={},SemiRadius=10}
local selectedStealMode = "v1"
local _blessBubbleEngine, _cleanStealEngine
local activeStealVersion
local function applyAutoStealMode(mode)
    mode = string.lower(tostring(mode or "v1"))
    if mode == "80" or mode == "85" or mode == "90" then mode = "v2" end
    if mode ~= "v1" and mode ~= "v2" then mode = "v1" end
    selectedStealMode = mode
    Steal.StealRadius = CONFIG.STEAL_RANGE
    if autoStealModeStatusLabel then autoStealModeStatusLabel.Text = string.upper(mode) end
    if Steal.AutoStealEnabled and type(startAutoStealSemi) == "function" then startAutoStealSemi() end
    if uiVisual.refreshAutoStealSelector then uiVisual.refreshAutoStealSelector()end
    return mode
end
do
    if type(_G.__BlessShiStealCleanup) == "function" then pcall(_G.__BlessShiStealCleanup) end
    _G.K7NormalSteal, _G.M4LWARESemiSteal = nil, nil
    _G.__BlessBubbleRagdollBlocked = false
    _G.__BlessBubbleAutoStealState = {isStealing = false}
    local m, c, i = LP, RunService, ReplicatedStorage
    local P = {Radius = CONFIG.STEAL_RANGE, Duration = 1.3}
    local k, E, W, H = selectedStealMode, {["auto steal"] = false}, {}, {alive = true}
    local connections, stoppers = {}, {}
    local walkBatched
    local function mi() end
    local function trackConnection(connection)
        if not H.alive then pcall(function() connection:Disconnect() end); return connection end
        table.insert(connections, connection)
        return connection
    end
    local function trackStopper(stopper)
        if not H.alive then pcall(stopper); return end
        table.insert(stoppers, stopper)
    end
    do
        local E, s = {};
        local function b()
            if s then
                return;
            end;
            s = c.Heartbeat:Connect(function() local V = os.clock() + 8.0E-4; while E[1] and os.clock() < V do local V = E[1]; if V.cancelled or V["continue"] and not V["continue"]() then table.remove(E, 1); else local F = V.pending[#V.pending]; if not F then table.remove(E, 1); else V.pending[#V.pending] = nil; pcall(V.apply, F); local N, I = pcall(function() return F:GetChildren(); end); if N then for F, F in ipairs(I) do V.pending[#V.pending + 1] = F; end; end; if E[2] then table.remove(E, 1); E[#E + 1] = V; end; end; end; end; if not E[1] then s:Disconnect(); s = nil; end; end);
            trackConnection (s);
        end;
        function walkBatched(V, F, N)
            local I = {pending = {}, apply = F, ["continue"] = N, cancelled = false};
            local roots = typeof(V) == "Instance" and {V} or V
for N, P in ipairs(roots or {}) do
                if P then
                    F, N = pcall(function() return P:GetChildren(); end);
                    if F then
                        for V, V in ipairs(N) do
                            I.pending[#I.pending + 1] = V;
                        end;
                    end;
                end;
            end;
            E[#E + 1] = I;
            b();
            return function()
                I.cancelled = true;
            end;
        end;
        trackStopper (function() for b, b in ipairs(E) do b.cancelled = true; end; E = {}; if s then s:Disconnect(); s = nil; end; end);
    end;
                local J, f = 0, {busy = false, data = {}};
                do
                    local o, Pi, ki, xi = m, workspace:FindFirstChild("Plots"), {};
                    -- El mapa puede cargar despues de Bless; la GUI no debe esperarlo.
                    local function resolvePlots()
                        if not Pi or not Pi.Parent then
                            Pi = workspace:FindFirstChild("Plots");
                        end;
                        return Pi;
                    end;
                    local _i, Li, zi, Si = {caches = {}, connections = {}}, {}, {};
local syncData = _i;
                    local gi, Oi, ni, Ji = false, false, {};
                    local fi, oi, qi = 0, {AUTO_STEAL_ENABLED = false, HOLD_MIN = 1.3, HOLD_MAX = 2.6, ENTRY_DELAY = 0.01, COOLDOWN = 0.05, STEAL_RANGE = 6, PRIME_RANGE = math.clamp(tonumber(P.Radius) or 65, 10, 150)}, setmetatable({}, {__mode = "k"});
                    local function Bi(ji)
                        if not ji then
                            return nil;
                        end;
                        local wi = qi[ji];
                        if wi and wi.Parent and(wi:IsA("ProximityPrompt")) and wi.ActionText and(wi.ActionText:find("Steal")) then
                            return wi;
                        end;
                        wi = ji:FindFirstChild("PromptAttachment");
                        for yi, yi in ipairs(wi and(wi:GetChildren()) or(ji:GetDescendants())) do
                            if yi:IsA("ProximityPrompt") and yi.ActionText and(yi.ActionText:find("Steal")) then
                                qi[ji] = yi;
                                return yi;
                            end;
                        end;
                        qi[ji] = nil;
                        return nil;
                    end;
                    local qi, ji = {active = false, startTime = 0, phase = "idle", label = "", lastResult = "", lastResultTime = 0, totalSteals = 0, failedSteals = 0}, _G.__BlessBubbleAutoStealState or {isStealing = false};
                    _G.__BlessBubbleAutoStealState = ji;
                    local function wi(yi)
                        yi = yi == true;
                        if ji.isStealing == yi then
                            return;
                        end;
                        ji.isStealing = yi;
                    end;
                    local function ji()
                        if xi then
                            return true;
                        end;
                        return pcall(function() local yi, Ui = i:WaitForChild("Packages", 10), i:WaitForChild("Datas", 10); if not yi or not Ui then return; end; ki = require(Ui:WaitForChild("Animals")); Ui = yi:WaitForChild("Synchronizer"); xi = {channelFolder = Ui:WaitForChild("Channel"), routeRemote = Ui:WaitForChild("CommunicationRoute"), requestData = Ui:FindFirstChild("RequestData")}; end) and xi ~= nil;
                    end;
                    local function i(yi)
                        if typeof(yi) == "table" then
                            return yi;
                        end;
                        local Ui = {};
                        for ei in string.gmatch(tostring(yi), "[^%.]+") do
                            table.insert(Ui, tonumber(ei) or ei);
                        end;
                        return Ui;
                    end;
                    local function yi(Ui, ei)
                        local ai, Wi, Ti = ei;
                        for ei, ei in ipairs(i(Ui)) do
                            ai, Wi, Ti = ai and ai[ei] or nil, ai, ei;
                        end;
                        return ai, Wi, Ti;
                    end;
                    local function i(Ui, ei)
                        local ai = _i.caches[Ui];
                        if typeof(ai) ~= "table" then
                            return;
                        end;
                        local Ui, Wi, Ti, li = ei[1], ei[2], ei[3], ei[4];
                        local ei, Zi, pi = yi(Ui, ai);
                        if Wi == "Changed" then
                            if Zi ~= nil then
                                Zi[pi] = Ti;
                            end;
                        elseif Wi == "ArrayInsert" then
                            if ei ~= nil then
                                table.insert(ei, li, Ti);
                            end;
                        elseif Wi == "ArrayRemoved" then
                            if ei ~= nil then
                                table.remove(ei, li);
                            end;
                        elseif Wi == "DictionaryInsert" then
                            if ei ~= nil then
                                ei[li] = Ti;
                            end;
                        elseif Wi == "DictionaryRemoved" then
                            if ei ~= nil then
                                ei[li] = nil;
                            end;
                        end;
                    end;
                    local function yi(Ui)
                        if not xi or _i.connections[Ui] then
                            return;
                        end;
                        local ei = tostring(Ui.Name);
                        local plots = resolvePlots();
                        if not plots or not plots:FindFirstChild(ei) then
                            return;
                        end;
                        if xi.requestData and _i.caches[ei] == nil then
                            local ai, Wi = pcall(function() return xi.requestData:InvokeServer(ei); end);
                            _i.caches[ei] = ai and typeof(Wi) == "table" and Wi or {};
                        elseif _i.caches[ei] == nil then
                            _i.caches[ei] = {};
                        end;
                        _i.connections[Ui] = trackConnection(Ui.OnClientEvent:Connect(function(Ui) for ai, ai in ipairs(Ui) do i(ei, ai); end; end));
                    end;
                    local function i(Ui)
                        for ei, ai in pairs(_i.connections) do
                            if tostring(ei.Name) == tostring(Ui) then
                                ai:Disconnect();
                                _i.connections[ei] = nil;
                                _i.caches[tostring(Ui)] = nil;
                                break;
                            end;
                        end;
                    end;
                    local function Ui()
                        if gi then
                            return true;
                        end;
                        if not ji() then
                            return false;
                        end;
                        if not xi or not xi.channelFolder then
                            return false;
                        end;
                        for ji, ji in ipairs(xi.channelFolder:GetChildren()) do
                            if ji:IsA("RemoteEvent") then
                                yi(ji);
                            end;
                        end;
trackConnection(xi.channelFolder.ChildAdded:Connect(function(ji) if ji:IsA("RemoteEvent") then yi(ji); end; end));
trackConnection(xi.routeRemote.OnClientEvent:Connect(function(ji) local plots = resolvePlots(); if not plots then return; end; for ei, ei in ipairs(ji) do local ji, ai = ei[1], tostring(ei[2]); if plots:FindFirstChild(ai) then if ji == "ListenerAdded" then ei = xi.channelFolder:FindFirstChild(ai); if ei and(ei:IsA("RemoteEvent")) then yi(ei); end; elseif ji == "ListenerRemoved" then i(ai); end; end; end; end));
                        gi = true;
                        return true;
                    end;
                    local function i(xi)
                        return _i.caches[xi];
                    end;
                    local function xi(_i)
                        local plots = resolvePlots();
                        local gi = plots and plots:FindFirstChild(_i.plot);
                        local ji = gi and(gi:FindFirstChild("AnimalPodiums"));
                        gi = ji and(ji:FindFirstChild(_i.slot));
                        return gi and gi:GetPivot().Position;
                    end;
                    local function _i (gi)
                        local ji = m.Character;
                        local yi = ji and(ji:FindFirstChild("HumanoidRootPart") or(ji:FindFirstChild("UpperTorso")));
                        if not yi then
                            return math.huge;
                        end;
                        ji = xi(gi);
                        if not ji then
                            return math.huge;
                        end;
                        return(yi.Position - ji).Magnitude;
                    end;
                    local function xi()
                        local Pi = resolvePlots();
                        if not Pi then
                            return {};
                        end;
                        local gi = {};
                        for ji, yi in ipairs(Pi:GetChildren()) do
                            ji = i(yi.Name);
                            local i = ji and ji.AnimalList;
                            if typeof(i) == "table" then
                                for ei, ai in pairs(i) do
                                    if type(ai) == "table" then
                                        ji = ai.Index;
                                        local i = ki[ji];
                                        if i then
                                            table.insert(gi, {name = i.DisplayName or ji, plot = yi.Name, slot = tostring(ei), uid = yi.Name .. "_" .. tostring(ei)});
                                        end;
                                    end;
                                end;
                            end;
                        end;
                        Li = gi;
                        return #Li;
                    end;
                    local function i(ki)
                        if zi[ki] then
                            return;
                        end;
                        local Li, gi, ji = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}, false;
                        if getconnections then
                            gi, ji = pcall(getconnections, ki.PromptButtonHoldBegan);
                        end;
                        if gi and type(ji) == "table" then
                            for yi, yi in ipairs(ji) do
                                if type(yi.Function) == "function" then
                                    table.insert(Li.holdCallbacks, yi.Function);
                                end;
                            end;
                        end;
                        ji, gi = false;
                        if getconnections then
                            ji, gi = pcall(getconnections, ki.Triggered);
                        end;
                        if ji and type(gi) == "table" then
                            for ji, ji in ipairs(gi) do
                                if type(ji.Function) == "function" then
                                    table.insert(Li.triggerCallbacks, ji.Function);
                                end;
                            end;
                        end;
                        if #Li.holdCallbacks > 0 or #Li.triggerCallbacks > 0 then
                            zi[ki] = Li;
                        end;
                    end;
                    local function ki(Li, gi)
                        local ji = zi[Li];
                        if not ji or not ji.ready then
                            return false;
                        end;
                        ji.ready = false;
                        local yi = gi and gi.name or "Animal";
                        qi.active = true;
                        qi.startTime = tick();
                        qi.phase = "holding";
                        qi.label = yi;
                        wi(false);
                        J = 0;
                        local ei = fi;
                        task.spawn(function() oi.HOLD_MIN = P.Duration or oi.HOLD_MIN; oi.HOLD_MAX = oi.HOLD_MIN + 1.3; for ai, ai in ipairs(ji.holdCallbacks) do task.spawn(ai); end; while tick() - qi.startTime < oi.HOLD_MIN do if ei ~= fi then ji.ready = true; return; end; if not oi.AUTO_STEAL_ENABLED or not Li.Parent then break; end; local ai = tick() - qi.startTime; J = math.clamp(ai / oi.HOLD_MAX, 0, 1); task.wait(0.05); end; qi.phase = "waitingRange"; local ai, Wi = gi and _i (gi) <= oi.STEAL_RANGE, false; while ei == fi and oi.AUTO_STEAL_ENABLED and Li.Parent do local Li = tick() - qi.startTime; J = math.clamp(Li / oi.HOLD_MAX, 0, 1); if Li > oi.HOLD_MAX then break; end; if gi and _i (gi) <= oi.STEAL_RANGE then if not ai then task.wait(oi.ENTRY_DELAY); end; for _i, _i in ipairs(ji.triggerCallbacks) do task.spawn(_i); end; Wi = true; break; end; task.wait(0.05); end; if ei ~= fi then ji.ready = true; return; end; if Wi then qi.totalSteals = qi.totalSteals + 1; qi.lastResult = "Stole " .. yi; qi.phase = "success"; wi(true); else qi.failedSteals = qi.failedSteals + 1; qi.lastResult = "Missed window: " .. yi; qi.phase = "failed"; end; qi.active = false; qi.lastResultTime = tick(); J = 1; task.wait(oi.COOLDOWN); J = 0; ji.ready = true; end);
                        return true;
                    end;
                    local function _i (Li, gi)
                        if not Li or not Li.Parent then
                            return false;
                        end;
                        i(Li);
                        return ki(Li, gi);
                    end;
                    local i, ki, Li = {busy = false, active = false, progress = 0, isStealing = false, currentTarget = nil, totalSteals = 0, failedSteals = 0, lastResult = "", generation = 0, phase = "idle", startTime = 0, data = {}}, {RADIUS = 65, HOLD_MIN = 1.3, HOLD_MAX = 2.6, NEAR_TARGET_RANGE = 20, ENTRY_DELAY = 0.3, FIRE_RANGE = 12, COOLDOWN = 0.45}, {prompt = nil, radius = 0, expiresAt = 0};
                    local function gi(ji)
                        local Pi = resolvePlots();
                        if not Pi then return nil; end;
                        local yi = math.max(0, tonumber(ji) or ki.RADIUS);
                        if Li.expiresAt > tick() and Li.radius == yi and Li.prompt and Li.prompt.Parent then
                            return Li.prompt;
                        end;
                        ji = m.Character;
                        local ei = ji and(ji:FindFirstChild("HumanoidRootPart") or(ji:FindFirstChild("UpperTorso")) or(ji:FindFirstChild("Torso")));
                        if not ei then
                            return nil;
                        end;
                        local ai, Wi, Ti = math.huge, yi * yi;
                        for li, Zi in ipairs(Pi:GetChildren()) do
                            ji = Zi:FindFirstChild("PlotSign");
                            li = ji and(ji:FindFirstChild("YourBase"));
                            if Zi:IsA("Model") and not(li and(li:IsA("BillboardGui")) and li.Enabled) then
                                local ji = Zi:FindFirstChild("AnimalPodiums");
                                if ji then
                                    for li, Zi in ipairs(ji:GetChildren()) do
                                        li = Zi:FindFirstChild("Base") and(Zi.Base:FindFirstChild("Spawn"));
                                        if li then
                                            Zi = li.Position - ei.Position;
                                            local ji = Zi:Dot(Zi);
                                            if ji <= Wi and ji < ai then
                                                local ei = Bi(li);
                                                if ei then
                                                    ai, Ti = ji, ei;
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                        Li.prompt = Ti;
                        Li.radius = yi;
                        Li.expiresAt = tick() + 0.12;
                        return Ti;
                    end;
                    function _G.__BlessShiAutoGrabTargetInRadius (Li)
                        return gi(Li or 65) ~= nil;
                    end;
                    local function Li(Bi)
                        local ji = m.Character;
                        local yi = ji and(ji:FindFirstChild("HumanoidRootPart") or(ji:FindFirstChild("UpperTorso")) or(ji:FindFirstChild("Torso")));
                        if not yi then
                            return math.huge;
                        end;
                        ji = Bi.Parent;
                        if ji and ji:IsA("Attachment") then ji = ji.Parent; end;
                            if ji and(ji:IsA("BasePart")) then
                                return(ji.Position - yi.Position).Magnitude;
                            end;
                            local ji, ei = pcall(function() return Bi.Parent and Bi.Parent.WorldPosition; end);
                            if ji and ei then
                                return(ei - yi.Position).Magnitude;
                            end;
                            return math.huge;
                        end;
                        local function Bi(ji)
                            local yi = i.data[ji];
                            if yi then
                                return yi;
                            end;
                            yi = {hold = {}, trigger = {}, ready = true};
                            if getconnections then
                                for ei, ei in ipairs(getconnections(ji.PromptButtonHoldBegan)) do
                                    if ei.Function then
                                        table.insert(yi.hold, ei.Function);
                                    end;
                                end;
                                for ei, ei in ipairs(getconnections(ji.Triggered)) do
                                    if ei.Function then
                                        table.insert(yi.trigger, ei.Function);
                                    end;
                                end;
                            end;
                            i.data[ji] = yi;
                            return yi;
                        end;
                        local function ji(yi, ei)
                            if not yi or not yi.Parent then
                                return false;
                            end;
                            if m:GetAttribute("Stealing") == true then
                                return false;
                            end;
                            local ai = false;
                            for Wi, Wi in ipairs(ei.trigger) do
                                if pcall(Wi) then ai = true; end;
                                end;
                                if not ai and m:GetAttribute("Stealing") ~= true and typeof(fireproximityprompt) == "function" then
    ai = pcall(fireproximityprompt, yi) or ai;
end;
                                    if not ai and m:GetAttribute("Stealing") ~= true then
    return pcall(function() yi:InputHoldBegin(); task.wait(0.05); yi:InputHoldEnd(); end);
end;
return ai;
                                    end;
                                    local function yi(ei)
                                        if i.busy or not ei or not ei.Parent then
                                            return;
                                        end;
                                        if m:GetAttribute("Stealing") == true then
                                            return;
                                        end;
                                        local ai = Bi(ei);
                                        if #ai.trigger == 0 then
                                            i.data[ei] = nil;
                                            ai = Bi(ei);
                                        end;
                                        if not ai.ready then
                                            return;
                                        end;
                                        ai.ready = false;
                                        i.busy = true;
                                        i.active = true;
                                        i.isStealing = true;
                                        i.startTime = tick();
                                        i.progress = 0;
                                        i.phase = "holding";
                                        i.generation = i.generation + 1;
                                        local Bi = i.generation;
                                        wi(true);
task.spawn(function()
    for Wi, Wi in ipairs(ai.hold) do task.spawn(Wi); end;
    local Wi = tick();
    while i.busy and tick() - Wi < ki.HOLD_MIN do
        if Bi ~= i.generation then return; end;
        i.progress = math.clamp((tick() - Wi) / ki.HOLD_MIN, 0, 1);
        J = i.progress;
        task.wait(0.05);
    end;
    if Bi ~= i.generation then return; end;
    i.progress, J, i.phase = 1, 1, "waiting";
    local Ti, li = Li(ei) <= ki.FIRE_RANGE, false;
    while Bi == i.generation and ei.Parent and oi.AUTO_STEAL_ENABLED and m:GetAttribute("Stealing") ~= true do
        i.progress, J = 1, 1;
        local Zi = Li(ei);
        if Zi > ki.NEAR_TARGET_RANGE and tick() - Wi > ki.HOLD_MAX then break; end;
        if Zi <= ki.FIRE_RANGE then
            local canTrigger = true;
            if not Ti then
                task.wait(ki.ENTRY_DELAY);
                if Bi ~= i.generation or not ei.Parent or Li(ei) > ki.FIRE_RANGE then canTrigger = false; end;
            end;
            if canTrigger then
                i.phase = "triggering";
                if ji(ei, ai) then
                    i.totalSteals = i.totalSteals + 1;
                    qi.totalSteals = qi.totalSteals + 1;
                    i.lastResult, qi.lastResult = "[OK] ROBADO!", "Stole";
                    i.isStealing, i.phase, li = true, "success", true;
                    break;
                end;
                i.phase = "waiting";
            end;
        end;
        task.wait(0.05);
    end;
    if Bi ~= i.generation then return; end;
    i.active, i.isStealing, i.busy, ai.ready = false, false, false, true;
    wi(false);
    if not li then
        i.failedSteals = i.failedSteals + 1;
        i.lastResult, i.phase = "[X] FALLO", "failed";
    end;
    i.lastResultTime, qi.lastResultTime = tick(), tick();
    task.wait(ki.COOLDOWN);
    if Bi ~= i.generation then return; end;
    i.progress, J, i.phase = 0, 0, "idle";
end);
                                    end;
                                    local ki, Bi = {busy = false, active = false, progress = 0, paused = false, pauseTime = nil, totalSteals = 0, failedSteals = 0, lastResult = "", generation = 0, phase = "idle", data = {}}, {STEAL_DURATION = 1.3, HOLD_TARGET = 0.8, TRIGGER_RADIUS = 10, PAUSE_TIMEOUT = 1.3, COOLDOWN = 0.05};
                                    local function ji(ei)
                                        local ai = ki.data[ei];
                                        if ai then
                                            return ai;
                                        end;
                                        ai = {hold = {}, trigger = {}, ready = true};
                                        if getconnections then
                                            pcall(function() for Wi, Wi in ipairs(getconnections(ei.PromptButtonHoldBegan)) do if Wi.Function then table.insert(ai.hold, Wi.Function); end; end; for Wi, Wi in ipairs(getconnections(ei.Triggered)) do if Wi.Function then table.insert(ai.trigger, Wi.Function); end; end; end);
                                        end;
                                        ki.data[ei] = ai;
                                        return ai;
                                    end;
                                    local function ei(ai)
                                        if ki.busy or not ai or not ai.Parent then
                                            return;
                                        end;
                                        if m:GetAttribute("Stealing") == true then
                                            return;
                                        end;
                                        local Wi = ji(ai);
                                        if not Wi.ready then
                                            return;
                                        end;
                                        Wi.ready = false;
                                        ki.busy = true;
                                        ki.active = true;
                                        ki.progress = 0;
                                        ki.paused = false;
                                        ki.pauseTime = nil;
                                        ki.phase = "holding";
                                        ki.generation = ki.generation + 1;
                                        local ji, Ti, li, Zi = ki.generation, tick(), true, false;
                                        qi.active = true;
                                        qi.startTime = Ti;
                                        qi.phase = "holding";
                                        J = 0;
                                        wi(true);
                                        task.spawn(function() for pi, pi in ipairs(Wi.hold) do task.spawn(function() pcall(pi); end); end; while ji == ki.generation and oi.AUTO_STEAL_ENABLED and k == "v2" and m:GetAttribute("Stealing") ~= true and ai.Parent do if ki.paused then if Li(ai) <= Bi.TRIGGER_RADIUS then ki.paused = false; ki.pauseTime = nil; ki.phase = "finishing"; Ti = tick() - Bi.HOLD_TARGET * Bi.STEAL_DURATION; else if not ki.pauseTime then ki.pauseTime = tick(); elseif tick() - ki.pauseTime >= Bi.PAUSE_TIMEOUT then break; end; ki.progress = Bi.HOLD_TARGET; J = ki.progress; qi.label = "80%"; task.wait(0.05); end; end; if not ki.paused then local Li = math.clamp((tick() - Ti) / Bi.STEAL_DURATION, 0, 1); ki.progress = Li; J = Li; qi.label = math.floor(Li * 100 + 0.5) .. "%"; if li and Li >= Bi.HOLD_TARGET then li = false; ki.paused = true; ki.pauseTime = tick(); ki.progress = Bi.HOLD_TARGET; J = ki.progress; ki.phase = "waitingRange"; qi.phase = "waitingRange"; elseif Li >= 1 then ki.phase = "triggering"; for Li, Li in ipairs(Wi.trigger) do task.spawn(function() pcall(Li); end); end; Zi = true; break; end; task.wait(0.05); end; end; if ji ~= ki.generation then return; end; ki.active = false; ki.busy = false; ki.paused = false; ki.pauseTime = nil; Wi.ready = true; qi.active = false; qi.lastResultTime = tick(); wi(false); if Zi then ki.totalSteals = ki.totalSteals + 1; ki.lastResult = "Stole"; ki.phase = "success"; qi.totalSteals = qi.totalSteals + 1; qi.lastResult = "Stole"; else ki.failedSteals = ki.failedSteals + 1; ki.lastResult = "Missed window"; ki.phase = "failed"; qi.failedSteals = qi.failedSteals + 1; qi.lastResult = "Missed window"; end; task.wait(Bi.COOLDOWN); if ji == ki.generation then ki.progress = 0; J = 0; ki.phase = "idle"; end; end);
                                    end;
                                    local function Li()
                                        if Si then
                                            return;
                                        end;
                                        local Bi = 0;
                                        Si = c.Heartbeat:Connect(function(ji) Bi = Bi + (ji or 0); if Bi < 0.15 then return; end; Bi = 0; if not oi.AUTO_STEAL_ENABLED then return; end; if m:GetAttribute("Stealing") == true then return; end; if _G.__BlessBubbleRagdollBlocked == true then return; end; if qi.active or f.busy or i.busy or ki.busy then return; end; if k == "v2" then ji = gi(P.Radius); if ji then ei(ji); end; return; end; if k == "v1" then ji = gi(P.Radius); if ji then yi(ji); end; return; end; end);
                                    end;
                                    function _G.__BlessBubbleRunCycle(gi, Bi)
                                        return _i (gi, Bi);
                                    end;
                                    local function _i ()
                                        if ni then
                                            for gi, gi in ipairs(ni) do
                                                pcall(function() gi:Disconnect(); end);
                                            end;
                                        end;
                                        ni = {};
                                        if Ji then
                                            task.cancel(Ji);
                                            Ji = nil;
                                        end;
                                    end;
                                    local function gi(Bi)
                                        _i ();
                                        local _i = Bi and(Bi:FindFirstChildOfClass("Humanoid"));
                                        if not _i then
                                            return;
                                        end;
                                        table.insert(ni, _i:GetPropertyChangedSignal("WalkSpeed"):Connect(function() wi(_i.WalkSpeed < 22); end));
                                        local function _i (ji)
                                            if not ji:IsA("ProximityPrompt") then
                                                return;
                                            end;
                                            table.insert(ni, ji.PromptButtonHoldBegan:Connect(function(yi) if yi ~= o then return; end; wi(true); if Ji then task.cancel(Ji); end; Ji = task.delay(oi.HOLD_MAX + 0.5, function() wi(false); end); end));
                                            table.insert(ni, ji.Triggered:Connect(function(Ji) if Ji ~= o then return; end; task.delay(0.2, function() wi(false); end); end));
                                        end;
                                        table.insert(ni, workspace.DescendantAdded:Connect(function(o) task.defer(_i, o); end));
                                        walkBatched (Pi, _i, function() return Bi.Parent ~= nil; end);
                                    end;
                                    local function o()
                                        if Oi then
                                            return;
                                        end;
                                        Oi = true;
                                        task.spawn(function() if Ui() then if oi.AUTO_STEAL_ENABLED then xi(); end; while H.alive do task.wait(5); if not H.alive then break; end; if oi.AUTO_STEAL_ENABLED then xi(); end; end; end; end);
                                    end;
                                    o();
                                    if m.Character then
                                        task.defer(gi, m.Character);
                                    end;
                                    trackConnection (m.CharacterAdded:Connect(function(Pi) task.wait(0.5); gi(Pi); if E["auto steal"] then oi.AUTO_STEAL_ENABLED = false; if Si then Si:Disconnect(); Si = nil; end; oi.AUTO_STEAL_ENABLED = true; xi(); Li(); end; end));
                                    _G.__BlessBubbleAutoGrab = {GetMode = function() return k; end, SetMode = function(Pi) if Pi ~= "v1" and Pi ~= "v2" then return false; end; k = Pi; mi(); return true; end};
                                    local function Pi()
                                        o();
                                        xi();
                                        oi.AUTO_STEAL_ENABLED = true;
                                        Li();
                                    end;
                                    local function o()
                                        fi = fi + 1;
                                        if Si then
                                            Si:Disconnect();
                                            Si = nil;
                                        end;
                                        oi.AUTO_STEAL_ENABLED = false;
                                        qi.active = false;
                                        qi.phase = "idle";
                                        wi(false);
                                        J, zi = 0, {};
                                        f.busy = false;
                                        f.data = {};
                                        if i then
                                            i.generation = i.generation + 1;
                                            i.busy = false;
                                            i.active = false;
                                            i.isStealing = false;
                                            i.progress = 0;
                                            i.phase = "idle";
                                            i.data = {};
                                        end;
                                        if ki then
                                            ki.generation = ki.generation + 1;
                                            ki.busy = false;
                                            ki.active = false;
                                            ki.paused = false;
                                            ki.pauseTime = nil;
                                            ki.progress = 0;
                                            ki.phase = "idle";
                                            ki.data = {};
                                        end;
                                    end;
                                    local autoStealDisableInternal = o;
                                    trackConnection (m.CharacterRemoving:Connect(o));
                                    trackStopper (o);
local ragdollCheck, resetRagdoll
do
    local generation = 0
    local stateConnection, standConnection, descendantConnection
    local wasRagdolled, cooling, medusaUntil = false, false, 0

    local function isRagdolled(humanoid, state)
        return humanoid.PlatformStand or state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown
    end
    local function hasMedusa(character)
        if not character then return false end
        for _, object in ipairs(character:GetDescendants()) do
            if not object:FindFirstAncestorOfClass("Tool") then
                local name = object.Name:lower()
                if name:find("medusa") or name:find("petrif") or name:find("gorgon") or name:find("stone") then return true end
                for key, value in pairs(object:GetAttributes()) do
                    name = tostring(key):lower()
                    if value and (name:find("medusa") or name:find("petrif") or name:find("gorgon") or name:find("stone")) then return true end
                end
            end
        end
        return false
    end
    resetRagdoll = function()
        generation = generation + 1
        cooling = false
        wasRagdolled = false
        _G.__BlessBubbleRagdollBlocked = false
    end
    local function pauseForRagdoll()
        generation = generation + 1
        local token = generation
        _G.__BlessBubbleRagdollBlocked = true
        cooling = true
        o()
        task.delay(1, function()
            if not H.alive or token ~= generation then return end
            cooling = false
            _G.__BlessBubbleRagdollBlocked = false
            if E["auto steal"] and _G.M4RagdollStealEnabled == true and not oi.AUTO_STEAL_ENABLED then Pi() end
        end)
    end
    local function bindRagdoll(character)
        if stateConnection then stateConnection:Disconnect(); stateConnection = nil end
        if standConnection then standConnection:Disconnect(); standConnection = nil end
        if descendantConnection then descendantConnection:Disconnect(); descendantConnection = nil end
        wasRagdolled, medusaUntil = false, 0
        local humanoid = character and (character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5))
        if not humanoid or not H.alive then return end
        if hasMedusa(character) then medusaUntil = tick() + 5 end
        descendantConnection = character.DescendantAdded:Connect(function(object)
            if object:FindFirstAncestorOfClass("Tool") then return end
            local name = object.Name:lower()
            if name:find("medusa") or name:find("petrif") or name:find("gorgon") or name:find("stone") then medusaUntil = tick() + 5 end
        end)
        local function check(state)
            if not H.alive then return end
            if _G.M4RagdollStealEnabled ~= true then
                if cooling or _G.__BlessBubbleRagdollBlocked then
                    resetRagdoll()
                    if E["auto steal"] and not oi.AUTO_STEAL_ENABLED then Pi() end
                end
                wasRagdolled = false
                return
            end
            if not E["auto steal"] then return end
            if hasMedusa(character) then medusaUntil = tick() + 5 end
            local ragdolled = isRagdolled(humanoid, state)
            if ragdolled and not wasRagdolled then
                wasRagdolled = true
                pauseForRagdoll()
            elseif not ragdolled then
                wasRagdolled = false
                if not cooling then
                    _G.__BlessBubbleRagdollBlocked = false
                    if E["auto steal"] and not oi.AUTO_STEAL_ENABLED then Pi() end
                end
            end
        end
        ragdollCheck = function() check(humanoid:GetState()) end
        stateConnection = humanoid.StateChanged:Connect(function(_, state) check(state) end)
        standConnection = humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(ragdollCheck)
    end
    if m.Character then task.defer(bindRagdoll, m.Character) end
    trackConnection(m.CharacterAdded:Connect(function(character)
        resetRagdoll()
        ragdollCheck = nil
        bindRagdoll(character)
    end))
    trackStopper(function()
        resetRagdoll()
        if stateConnection then stateConnection:Disconnect() end
        if standConnection then standConnection:Disconnect() end
        if descendantConnection then descendantConnection:Disconnect() end
    end)
end
                                    W["auto steal"] = function(i)
                                        if i then
                                            if _G.__BlessBubbleRagdollBlocked ~= true then
                                                Pi();
                                            end;
                                        else
                                            o();
                                        end;
                                    end;
                                    if E["auto steal"] then
                                        Pi();
                                    end;
                                

-- Adaptador: mismos motores de Bubble, conectados al estado y la barra de Bless.
local previousProgress, previousSink, previousRagdoll
trackStopper(_i)
trackConnection(c.Heartbeat:Connect(function()
    if not H.alive then return end
    P.Radius = math.clamp(tonumber(CONFIG.STEAL_RANGE) or 65, 10, 150)
    P.Duration = tonumber(Steal.StealDuration) or 1.3
    if previousRagdoll ~= (_G.M4RagdollStealEnabled == true) then
        previousRagdoll = _G.M4RagdollStealEnabled == true
        if ragdollCheck then ragdollCheck() end
    end
    if selectedStealMode=="v1"then
        local progress = math.clamp(tonumber(J) or 0, 0, 1)
        local sink = uiVisual and uiVisual.setStealProgress
        if sink and (previousProgress ~= progress or previousSink ~= sink) then
            sink(progress)
            previousProgress, previousSink = progress, sink
        end
        _G.KillHub.Connections.steal = Si
    end
end))
_G.__BlessShiAutoStealState = _G.__BlessBubbleAutoStealState
_blessBubbleEngine = {
    SetMode = _G.__BlessBubbleAutoGrab.SetMode,
    SetEnabled = function(enabled)
        E["auto steal"] = enabled == true
        o()
        if not enabled then
            resetRagdoll()
            if uiVisual and uiVisual.setStealProgress then uiVisual.setStealProgress(0) end
        else
            if ragdollCheck then ragdollCheck() end
            if _G.__BlessBubbleRagdollBlocked ~= true then Pi() end
        end
        _G.KillHub.Connections.steal = Si
        return true
    end,
    SetRadius = function(radius)
        radius = tonumber(radius)
        if not radius or radius ~= radius or math.abs(radius) == math.huge then return false end
        CONFIG.STEAL_RANGE = math.clamp(math.floor(radius + 0.5), 10, 150)
        Steal.StealRadius, P.Radius = CONFIG.STEAL_RANGE, CONFIG.STEAL_RANGE
        return true
    end,
    SetRagdollEnabled = function(enabled)
        _G.M4RagdollStealEnabled = enabled == true
        if ragdollCheck then ragdollCheck() end
    end,
    Stop = o,
}
local function cleanupSteal()
    if not H.alive then return end
    E["auto steal"] = false
    o()
    H.alive = false
    for _, stopper in ipairs(stoppers) do pcall(stopper) end
    for _, connection in ipairs(connections) do pcall(function() connection:Disconnect() end) end
    for _, connection in pairs(syncData.connections) do pcall(function() connection:Disconnect() end) end
    syncData.connections, syncData.caches = {}, {}
    _G.KillHub.Connections.steal = nil
    if uiVisual and uiVisual.setStealProgress then uiVisual.setStealProgress(0) end
end
_G.__BlessShiStealCleanup = cleanupSteal

end

end
-- Clean Auto Steal, Normal variant: original hold/trigger algorithm.
do
    local localPlayer=LP
    local getTime,clamp,floor,huge,sqrt=tick,math.clamp,math.floor,math.huge,math.sqrt
    local autoStealConnection,autoStealBusy=nil,false
    local autoStealState={AutoStealEnabled=false,StealRadius=CONFIG.STEAL_RANGE,
        StealDuration=1.3,StealDelay=.25,Data={}}
    local startAutoSteal,stopAutoSteal
    local generation,alive=0,true
    local characterReady=localPlayer.Character~=nil
    local lifecycle={}
    local function isCurrent(token)
        return alive and generation==token and autoStealState.AutoStealEnabled
    end
    local function writeProgress(value)
        if selectedStealMode~="v2"then return end
        if uiVisual and uiVisual.setStealProgress then uiVisual.setStealProgress(value)
        else
            if progressFill then progressFill.Size=UDim2.new(value,0,1,0)end
            if progressPct then progressPct.Text=tostring(floor(value*100)).."%"end
        end
    end
    local function getAutoStealDuration()return autoStealState.StealDuration*.73 end
    local plots,plotsAt
    local function getPlotsRoot()
        local now=getTime()
        if plots and plots.Parent and plotsAt and now-plotsAt<2 then return plots end
        plots=workspace:FindFirstChild("Plots");plotsAt=now
        return plots
    end
    do
        local findNearestPrompt
        do
            local function isMyPlotByName(plotName)
                local plotsRoot = getPlotsRoot()
                if not plotsRoot then
                    return false
                end
                local plot = plotsRoot:FindFirstChild(plotName)
                if not plot then
                    return false
                end
                local sign = plot:FindFirstChild("PlotSign")
                if sign then
                    local yourBase = sign:FindFirstChild("YourBase")
                    if yourBase and yourBase:IsA("BillboardGui") then
                        return yourBase.Enabled == true
                    end
                end
                return false
            end
            findNearestPrompt = function()
                local character = localPlayer.Character
                if not character then
                    return nil, nil
                end
                local root = character:FindFirstChild("HumanoidRootPart")
                if not root then
                    return nil, nil
                end
                local plotsRoot = getPlotsRoot()
                if not plotsRoot then
                    return nil, nil
                end
                local nearestPrompt = nil
                local nearestDistance = huge
                local name = nil
                local position = root.Position
                for _, child in ipairs(plotsRoot:GetChildren()) do
                    if not isMyPlotByName(child.Name) then
                        local pods = child:FindFirstChild("AnimalPodiums")
                        if pods then
                            for _, child2 in ipairs(pods:GetChildren()) do
                                pcall(function()
                                    local spawn_ = child2:FindFirstChild("Base")
                                    spawn_ = spawn_ and spawn_:FindFirstChild("Spawn")
                                    if spawn_ then
                                        local position2 = spawn_.Position
                                        local dx = position2.X - position.X
                                        local dy = position2.Y - position.Y
                                        local dz = position2.Z - position.Z
                                        local distance = sqrt(dx * dx + dy * dy + dz * dz)
                                        if distance < nearestDistance and distance <= autoStealState.StealRadius then
                                            local promptAttachment = spawn_:FindFirstChild("PromptAttachment")
                                            if promptAttachment then
                                                for _, child3 in ipairs(promptAttachment:GetChildren()) do
                                                    if
                                                        child3:IsA("ProximityPrompt")
                                                        and child3.ActionText
                                                        and child3.ActionText:find("Steal")
                                                    then
                                                        nearestPrompt = child3
                                                        nearestDistance = distance
                                                        name = child2.Name
                                                        break
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end)
                            end
                        end
                    end
                end
                return nearestPrompt, name
            end
        end
        local executeSteal = nil
        executeSteal = function(prompt, podName)
            if autoStealBusy then
                return
            end
            if math.random(30) == 1 then
                for k in pairs(autoStealState.Data) do
                    if not k.Parent then
                        autoStealState.Data[k] = nil
                    end
                end
            end
            if not autoStealState.Data[prompt] then
                autoStealState.Data[prompt] = {
                    hold = {},
                    trigger = {},
                    ready = true,
                }
                pcall(function()
                    if getconnections then
                        for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                            if c.Function then
                                table.insert(autoStealState.Data[prompt].hold, c.Function)
                            end
                        end
                        for _, c in ipairs(getconnections(prompt.Triggered)) do
                            if c.Function then
                                table.insert(autoStealState.Data[prompt].trigger, c.Function)
                            end
                        end
                    end
                end)
            end
            local object885 = autoStealState.Data[prompt]
            if not object885.ready then
                return
            end
            object885.ready = false
            autoStealBusy = true
            writeProgress(0)
            local token=generation
            task.spawn(function()
                if not isCurrent(token)then return end
                for _, f in ipairs(object885.hold) do
                    task.spawn(function()if isCurrent(token)then f()end end)
                end
                local startTime = getTime()
                local stealDuration = autoStealState.StealDuration
                local promptFired = getAutoStealDuration()
                while true do
                    if isCurrent(token) then
                        local elapsed = getTime() - startTime
                        if not (promptFired <= elapsed) then
                            local progress = clamp(elapsed / stealDuration, 0, 1)
                            writeProgress(progress)
                            if not (not prompt.Parent or not prompt.Parent.Parent) then
                                local character = localPlayer.Character
                                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                                if
                                    not (
                                        humanoidRootPart
                                        and (humanoidRootPart.Position - prompt.Parent.Parent.Position).Magnitude
                                            > autoStealState.StealRadius
                                    )
                                then
                                    task.wait();if not isCurrent(token)then return end
                                    continue
                                end
                            end
                        end
                    end
                    break
                end
                local stopProgress = clamp(promptFired / stealDuration, 0, 1)
                writeProgress(stopProgress)
                local phase2Timeout = math.max(2.99 - promptFired - math.max(stealDuration - promptFired, 0), 0.05)
                local phase2Start = getTime()
                local exitTo = nil
                while true do
                    if isCurrent(token) then
                        if getTime() - phase2Start >= phase2Timeout then
                            exitTo = 2
                            break
                        elseif not prompt.Parent or not prompt.Parent.Parent then
                            exitTo = 3
                            break
                        else
                            local character = localPlayer.Character
                            character = character and character:FindFirstChild("HumanoidRootPart")
                            if character then
                                local magnitude = (character.Position - prompt.Parent.Parent.Position).Magnitude
                                if magnitude <= 9 then
                                    exitTo = 1
                                    break
                                elseif not (magnitude > autoStealState.StealRadius) then
                                    task.wait();if not isCurrent(token)then return end
                                    continue
                                end
                            else
                                task.wait();if not isCurrent(token)then return end
                                continue
                            end
                        end
                    else
                        exitTo = 1
                        break
                    end
                    break
                end
                if exitTo == 1 then
                    if isCurrent(token) then
                        local fillStart = getTime()
                        local fillDuration = math.max(stealDuration - promptFired, 0.05)
                        while true do
                            local fp = clamp((getTime() - fillStart) / fillDuration, 0, 1)
                            local totalProgress = stopProgress + fp * (1 - stopProgress)
                            writeProgress(totalProgress)
                            if not (fp >= 1 and true) then
                                task.wait();if not isCurrent(token)then return end
                                continue
                            end
                            break
                        end
                        pcall(function()
                            for _, f in ipairs(object885.trigger) do
                                task.spawn(function()if isCurrent(token)then f()end end)
                            end
                            local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                            if remote and podName then
                                remote:FireServer(podName)
                            end
                            if prompt then
                                prompt:Fire()
                            end
                        end)
                    end
                    writeProgress(0)
                    object885.ready = true
                    autoStealBusy = false
                    return
                end
                if exitTo == 2 then
                    writeProgress(0)
                    object885.ready = true
                    autoStealBusy = false
                    task.wait();if not isCurrent(token)then return end
                    local elapsed, progress = findNearestPrompt()
                    if elapsed then
                        executeSteal(elapsed, progress)
                    end
                    return
                end
                if exitTo == 3 then
                    autoStealBusy = false
                    writeProgress(0)
                    object885.ready = true
                    return
                end
                autoStealBusy = false
                writeProgress(0)
                object885.ready = true
            end)
        end
        startAutoSteal = function()
            if autoStealConnection then
                local connected = false
                pcall(function()
                    connected = autoStealConnection.Connected == true
                end)
                if connected then
                    autoStealState.StealRadius = CONFIG.STEAL_RANGE
                    autoStealState.AutoStealEnabled = true
                    CONFIG.AUTO_STEAL_ENABLED = true
                    return true
                end
                pcall(function()
                    autoStealConnection:Disconnect()
                end)
                autoStealConnection = nil
            end
            autoStealState.StealRadius = CONFIG.STEAL_RANGE
            autoStealState.AutoStealEnabled = true
            CONFIG.AUTO_STEAL_ENABLED = true
            autoStealConnection = RunService.Heartbeat:Connect(function()
                if selectedStealMode=="v2"and _G.__BlessShiAutoStealState then
                    _G.__BlessShiAutoStealState.isStealing=autoStealBusy
                end
                if not characterReady or not autoStealState.AutoStealEnabled or autoStealBusy then
                    return
                end
                local p, n = findNearestPrompt()
                if p then
                    executeSteal(p, n)
                end
            end)
            if _G.KillHub and _G.KillHub.Connections then _G.KillHub.Connections.steal=autoStealConnection end
            return true
        end
    end
    stopAutoSteal = function()
        generation=generation+1
        if autoStealConnection then autoStealConnection:Disconnect();autoStealConnection=nil end
        autoStealBusy=false
        autoStealState.AutoStealEnabled=false
        autoStealState.Data={}
        CONFIG.AUTO_STEAL_ENABLED=false
        writeProgress(0)
    end

    lifecycle[#lifecycle+1]=localPlayer.CharacterRemoving:Connect(function()
        characterReady=false
        generation=generation+1
        autoStealBusy=false
        autoStealState.Data={}
        writeProgress(0)
    end)
    lifecycle[#lifecycle+1]=localPlayer.CharacterAdded:Connect(function()
        characterReady=true
    end)
    _cleanStealEngine={
        SetEnabled=function(value)
            if not alive then return false end
            if value==true then return startAutoSteal()end
            stopAutoSteal()
            return true
        end,
        SetRadius=function(value)autoStealState.StealRadius=value end,
        Destroy=function()
            if not alive then return end
            stopAutoSteal();alive=false
            for _,connection in ipairs(lifecycle)do connection:Disconnect()end
        end,
    }
end
-- End Clean Auto Steal adapter.
function startAutoStealSemi()
    local engine=selectedStealMode=="v2"and _cleanStealEngine or _blessBubbleEngine
    if activeStealVersion~=selectedStealMode then
        _cleanStealEngine.SetEnabled(false)
        _blessBubbleEngine.SetEnabled(false)
        activeStealVersion=selectedStealMode
    end
    _blessBubbleEngine.SetRadius(CONFIG.STEAL_RANGE)
    _cleanStealEngine.SetRadius(CONFIG.STEAL_RANGE)
    if selectedStealMode=="v1"then _blessBubbleEngine.SetMode("v1")end
    Steal.AutoStealEnabled,CONFIG.AUTO_STEAL_ENABLED=true,true
    _G.KillHub.Active.steal=true
    if pbFrame then pbFrame.Visible=true end
    return engine.SetEnabled(true)
end
function stopAutoSteal()
    _cleanStealEngine.SetEnabled(false)
    _blessBubbleEngine.SetEnabled(false)
    activeStealVersion=nil
    Steal.AutoStealEnabled,CONFIG.AUTO_STEAL_ENABLED=false,false
    _G.KillHub.Active.steal=false
    if pbFrame then pbFrame.Visible=false end
    _G.KillHub.Connections.steal,_G.KillHub.Connections.progress=nil,nil
end
Steal.SetRadius=function(value)
    if not _blessBubbleEngine.SetRadius(value)then return false end
    _cleanStealEngine.SetRadius(CONFIG.STEAL_RANGE)
    return true
end
Steal.SetRagdollEnabled=_blessBubbleEngine.SetRagdollEnabled
do
    local stopV1=_G.__BlessShiStealCleanup
    _G.__BlessShiStealCleanup=function()
        _cleanStealEngine.Destroy()
        if stopV1 then stopV1()end
    end
end
-- Solo para leer las configuraciones anteriores que guardaban Semi Radius.
Steal.SetSemiRadius = function(value)
    local radius = tonumber(value)
    if not radius or radius ~= radius or math.abs(radius) == math.huge then return false end
    Steal.SemiRadius = math.clamp(math.floor(radius + 0.5), 1, 200)
    return true
end

currentSkyTheme="Off"CANDY_SKY_TAG="KillHubSkyTheme"candyOriginalLighting=nil bodyLockEnabled=false bodyLockRange=20 bodyLockRangeBox=nil _bodyLockConn=nil bodyLockSetVisual=nil _blSuppressCount=0 _blWasEnabled=false _blRestoreTimer=nil _blSmoothRestore=false savedProgressBarPos=nil savedButtonPositions={}savedMobilePanelPos=nil instaResetFloatingPos=nil bypassFloatingPos=nil currentAnimPack="Off"originalTryardAnims=nil tryardHeartbeatConn=nil animSelectorLabel=nil unwalkSavedAnimate=nil local ANIM_PACKS={Tryhard={idle1="rbxassetid://133806214992291",idle2="rbxassetid://94970088341563",walk="rbxassetid://707897309",run="rbxassetid://707861613",jump="rbxassetid://116936326516985",fall="rbxassetid://116936326516985",climb="rbxassetid://116936326516985",swim="rbxassetid://116936326516985",swimidle="rbxassetid://116936326516985",},Crazy={idle1="rbxassetid://133806214992291",idle2="rbxassetid://94970088341563",walk="rbxassetid://134824450619865",run="rbxassetid://134824450619865",jump="rbxassetid://121454505477205",fall="rbxassetid://94788218468396",climb="rbxassetid://121454505477205",swim="rbxassetid://121454505477205",swimidle="rbxassetid://121454505477205",}}local ANIM_PACK_ORDER={{"Off","Off"},{"Unwalk","Unwalk"},{"Tryhard","Tryhard"},{"Crazy","Crazy"}}currentAccessoryPack="Off"accSelectorLabel=nil local function clearAllAccessories(_)end local function applyAccessoryPack(_)currentAccessoryPack="Off"return true end _G.BLESS_HalloweenOutfits={Pumpkin={15120652667,15120688059,15091671280},Witch={5780619218,5780636359,5699752799},Gothic={8293221556,8293305115,10809978313},Vampire={17181412337,8293305115,10809978313},Skeleton={103164540699395,15120688059,109347806614643},Orange={14863781659,15120688059,11328177749},}_G.BLESS_HalloweenCurrent=nil _G.BLESS_HalloweenBusy=false _G.BLESS_HalloweenOriginalWear=_G.BLESS_HalloweenOriginalWear or nil function _G.BLESS_HalloweenSnapshot()if _G.BLESS_HalloweenOriginalWear then return end local player=game:GetService("Players").LocalPlayer local char=player and player.Character if not char then return end local saved={}for _,obj in ipairs(char:GetChildren())do if obj:IsA("Shirt")or obj:IsA("Pants")or obj:IsA("ShirtGraphic")then table.insert(saved,obj:Clone())end end _G.BLESS_HalloweenOriginalWear=saved end function _G.BLESS_HalloweenRemoveInjected()local player=game:GetService("Players").LocalPlayer local char=player and player.Character if not char then return end for _,obj in ipairs(char:GetChildren())do if obj:GetAttribute("BLESSHalloweenOutfit")==true then pcall(function()obj:Destroy()end)end end end function _G.BLESS_HalloweenRestore()local player=game:GetService("Players").LocalPlayer local char=player and player.Character if not char then return false end _G.BLESS_HalloweenRemoveInjected()for _,obj in ipairs(char:GetChildren())do if obj:IsA("Shirt")or obj:IsA("Pants")or obj:IsA("ShirtGraphic")then pcall(function()obj:Destroy()end)end end for _,saved in ipairs(_G.BLESS_HalloweenOriginalWear or{})do pcall(function()saved:Clone().Parent=char end)end _G.BLESS_HalloweenCurrent=nil return true end function _G.BLESS_HalloweenLoadAsset(assetId)local objects=nil local ok,result=pcall(function()return game:GetObjects("rbxassetid://"..tostring(assetId))end)if ok and typeof(result)=="table"and#result>0 then objects=result else local ok2,model=pcall(function()return game:GetService("InsertService"):LoadAsset(tonumber(assetId))end)if ok2 and model then objects={model}end end return objects end function _G.BLESS_HalloweenApplyObject(source,char,hum,assetId)if not source then return 0 end local count=0 local function place(obj)if obj:IsA("Shirt")or obj:IsA("Pants")or obj:IsA("ShirtGraphic")then local clone=obj:Clone()clone.Name="BLESS_Halloween_"..obj.ClassName clone:SetAttribute("BLESSHalloweenOutfit",true)clone.Parent=char count+=1 return end if obj:IsA("Accessory")or obj:IsA("Hat")then local clone=obj:Clone()clone.Name="BLESS_Halloween_"..tostring(assetId)clone:SetAttribute("BLESSHalloweenOutfit",true)local added=false if obj:IsA("Accessory")and hum then added=pcall(function()hum:AddAccessory(clone)end)end if not added then clone.Parent=char end count+=1 return end end place(source)for _,descendant in ipairs(source:GetDescendants())do place(descendant)end return count end function _G.BLESS_HalloweenApply(outfitName,fromRespawn)local ids=_G.BLESS_HalloweenOutfits and _G.BLESS_HalloweenOutfits[outfitName]if type(ids)~="table"then return false end local player=game:GetService("Players").LocalPlayer local char=player and player.Character local hum=char and char:FindFirstChildOfClass("Humanoid")if not char or not hum then return false end if not fromRespawn then _G.BLESS_HalloweenSnapshot()end _G.BLESS_HalloweenRemoveInjected()for _,obj in ipairs(char:GetChildren())do if obj:IsA("Shirt")or obj:IsA("Pants")or obj:IsA("ShirtGraphic")then pcall(function()obj:Destroy()end)end end local applied=0 for _,assetId in ipairs(ids)do local objects=_G.BLESS_HalloweenLoadAsset(assetId)if objects then for _,object in ipairs(objects)do applied+=_G.BLESS_HalloweenApplyObject(object,char,hum,assetId)pcall(function()object:Destroy()end)end end end if applied>0 then _G.BLESS_HalloweenCurrent=outfitName return true end if not fromRespawn then _G.BLESS_HalloweenRestore()end return false end if _G.BLESS_HalloweenRespawnConnection then pcall(function()_G.BLESS_HalloweenRespawnConnection:Disconnect()end)end _G.BLESS_HalloweenRespawnConnection=game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()task.delay(1.1,function()local selected=_G.BLESS_HalloweenCurrent if selected and _G.BLESS_HalloweenOutfits and _G.BLESS_HalloweenOutfits[selected]then pcall(function()_G.BLESS_HalloweenApply(selected,true)end)end end)end)local function isPackAnim(id)for _,pack in pairs(ANIM_PACKS)do for _,v in pairs(pack)do if v==id then return true end end end return false end local function saveOriginalAnims(char)local animate=char:FindFirstChild("Animate")if not animate then return end local function g(obj)return obj and obj.AnimationId or nil end local ids={idle1=g(animate.idle and animate.idle.Animation1),idle2=g(animate.idle and animate.idle.Animation2),walk=g(animate.walk and animate.walk.WalkAnim),run=g(animate.run and animate.run.RunAnim),jump=g(animate.jump and animate.jump.JumpAnim),fall=g(animate.fall and animate.fall.FallAnim),climb=g(animate.climb and animate.climb.ClimbAnim),swim=g(animate.swim and animate.swim.Swim),swimidle=g(animate.swimidle and animate.swimidle.SwimIdle),}if not isPackAnim(ids.walk)then originalTryardAnims=ids end end local function enableUnwalk()if unwalkEnabled then return end unwalkEnabled=true local char=LP.Character local animate=char and char:FindFirstChild("Animate")if animate then if not unwalkSavedAnimate then unwalkSavedAnimate=animate:Clone()end for _,track in ipairs(char.Humanoid:GetPlayingAnimationTracks())do pcall(function()track:Stop(0)end)end animate:Destroy()end end local function disableUnwalk()if not unwalkEnabled then return end unwalkEnabled=false local char=LP.Character if char and not char:FindFirstChild("Animate")and unwalkSavedAnimate then local newAnimate=unwalkSavedAnimate:Clone()newAnimate.Parent=char task.wait()local hum=char:FindFirstChildOfClass("Humanoid")if hum then hum:ChangeState(Enum.HumanoidStateType.Running)end end end local function applyAnimPack(packName)currentAnimPack=packName if animSelectorLabel then animSelectorLabel.Text=packName end if packName=="Unwalk"then disableUnwalk()enableUnwalk()if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect();tryardHeartbeatConn=nil end return end if unwalkEnabled then disableUnwalk()end if packName=="Off"then if originalTryardAnims and LP.Character then local animate=LP.Character:FindFirstChild("Animate")if animate then local function s(obj,id)if obj then obj.AnimationId=id end end s(animate.idle and animate.idle.Animation1,originalTryardAnims.idle1)s(animate.idle and animate.idle.Animation2,originalTryardAnims.idle2)s(animate.walk and animate.walk.WalkAnim,originalTryardAnims.walk)s(animate.run and animate.run.RunAnim,originalTryardAnims.run)s(animate.jump and animate.jump.JumpAnim,originalTryardAnims.jump)s(animate.fall and animate.fall.FallAnim,originalTryardAnims.fall)s(animate.climb and animate.climb.ClimbAnim,originalTryardAnims.climb)s(animate.swim and animate.swim.Swim,originalTryardAnims.swim)s(animate.swimidle and animate.swimidle.SwimIdle,originalTryardAnims.swimidle)end end if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect();tryardHeartbeatConn=nil end return end local pack=ANIM_PACKS[packName]if not pack then return end if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect()end tryardHeartbeatConn=RunService.Heartbeat:Connect(function()local c=LP.Character if not c then return end local animate=c:FindFirstChild("Animate")if not animate then return end local function s(obj,id)if obj then obj.AnimationId=id end end s(animate.idle and animate.idle.Animation1,pack.idle1)s(animate.idle and animate.idle.Animation2,pack.idle2)s(animate.walk and animate.walk.WalkAnim,pack.walk)s(animate.run and animate.run.RunAnim,pack.run)s(animate.jump and animate.jump.JumpAnim,pack.jump)s(animate.fall and animate.fall.FallAnim,pack.fall)s(animate.climb and animate.climb.ClimbAnim,pack.climb)s(animate.swim and animate.swim.Swim,pack.swim)s(animate.swimidle and animate.swimidle.SwimIdle,pack.swimidle)end)end local function startAnimPack(packName)local char=LP.Character if char then saveOriginalAnims(char)applyAnimPack(packName)local hum=char:FindFirstChildOfClass("Humanoid")if hum then for _,track in ipairs(hum:GetPlayingAnimationTracks())do track:Stop(0)end hum:ChangeState(Enum.HumanoidStateType.Running)end else applyAnimPack(packName)end currentAnimPack=packName end local function stopAnimPack()currentAnimPack="Off"if animSelectorLabel then animSelectorLabel.Text="Off"end applyAnimPack("Off")end DEFAULT_KB={DropBrainrot={kb=Enum.KeyCode.X,gp=nil},AutoLeft={kb=Enum.KeyCode.Z,gp=nil},AutoRight={kb=Enum.KeyCode.C,gp=nil},AutoBat={kb=Enum.KeyCode.E,gp=nil},BatV2={kb=nil,gp=nil},TPFloor={kb=Enum.KeyCode.F,gp=nil},CarryToggle={kb=Enum.KeyCode.Q,gp=nil},LaggerMode={kb=Enum.KeyCode.R,gp=nil},InstaReset={kb=Enum.KeyCode.G,gp=nil},Bypass={kb=Enum.KeyCode.N,gp=nil},Float={kb=nil,gp=nil},}KB={DropBrainrot={kb=DEFAULT_KB.DropBrainrot.kb,gp=DEFAULT_KB.DropBrainrot.gp},AutoLeft={kb=DEFAULT_KB.AutoLeft.kb,gp=DEFAULT_KB.AutoLeft.gp},AutoRight={kb=DEFAULT_KB.AutoRight.kb,gp=DEFAULT_KB.AutoRight.gp},AutoBat={kb=DEFAULT_KB.AutoBat.kb,gp=DEFAULT_KB.AutoBat.gp},BatV2={kb=DEFAULT_KB.BatV2.kb,gp=DEFAULT_KB.BatV2.gp},TPFloor={kb=DEFAULT_KB.TPFloor.kb,gp=DEFAULT_KB.TPFloor.gp},CarryToggle={kb=DEFAULT_KB.CarryToggle.kb,gp=DEFAULT_KB.CarryToggle.gp},LaggerMode={kb=DEFAULT_KB.LaggerMode.kb,gp=DEFAULT_KB.LaggerMode.gp},InstaReset={kb=DEFAULT_KB.InstaReset.kb,gp=DEFAULT_KB.InstaReset.gp},Bypass={kb=DEFAULT_KB.Bypass.kb,gp=DEFAULT_KB.Bypass.gp},Float={kb=DEFAULT_KB.Float.kb,gp=DEFAULT_KB.Float.gp},}_isResetting=false _lastSavedJSON=nil _isLoading=false local CANDY_SKY_PRESETS={["BlessHalloween"]={clock=0,brightness=1.45,ambient={80,72,88},outAmb={68,60,78},sky={stars=0,sun=0,moon=0},atm={dens=.08,color={61,42,58},decay={12,8,18},glare=0,haze=.15}},["Off"]={kind="off"},["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},["Volcanic"]={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.5,dens=0.55,color={200,150,255}}},["Toxic"]={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},["Hellscape"]={clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},["Heaven"]={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},["Storm"]={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},["Sunrise"]={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},["Inferno"]={clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},}local CANDY_SKY_ORDER={{"Off","Off"},{"Night","Night"},{"Aurora","Aurora"},{"Sunset","Sunset"},{"Galaxy","Galaxy"},{"Cyber","Cyber"},{"Sakura","Sakura"},{"Pink Night","Pink Night"},{"Blood Moon","Blood Moon"},{"Emerald Dawn","Emerald Dawn"},{"Volcanic","Volcanic"},{"Arctic","Arctic"},{"Midnight Ocean","Midnight Ocean"},{"Vaporwave","Vaporwave"},{"Toxic","Toxic"},{"Solar Eclipse","Solar Eclipse"},{"Hellscape","Hellscape"},{"Heaven","Heaven"},{"Storm","Storm"},{"Sunrise","Sunrise"},{"Deep Space","Deep Space"},{"Lavender Dream","Lavender Dream"},{"Inferno","Inferno"},{"Mint Sky","Mint Sky"}}local function candySaveOriginalLighting()if candyOriginalLighting then return end candyOriginalLighting={ClockTime=Lighting.ClockTime,OutdoorAmbient=Lighting.OutdoorAmbient,Ambient=Lighting.Ambient,Brightness=Lighting.Brightness,FogStart=Lighting.FogStart,FogEnd=Lighting.FogEnd,FogColor=Lighting.FogColor,ColorShift_Top=Lighting.ColorShift_Top,ColorShift_Bottom=Lighting.ColorShift_Bottom,GeographicLatitude=Lighting.GeographicLatitude,GlobalShadows=Lighting.GlobalShadows,LightingChildren={},TerrainChildren={}}for _,child in ipairs(Lighting:GetChildren())do if child:IsA("Sky")or child:IsA("Atmosphere")then table.insert(candyOriginalLighting.LightingChildren,child:Clone())end end local terrain=workspace:FindFirstChildOfClass("Terrain")if terrain then for _,child in ipairs(terrain:GetChildren())do if child:IsA("Clouds")then table.insert(candyOriginalLighting.TerrainChildren,child:Clone())end end end end local function candyClearSky(removeAll)for _,child in ipairs(Lighting:GetChildren())do if child:GetAttribute(CANDY_SKY_TAG)or(removeAll and(child:IsA("Sky")or child:IsA("Atmosphere")))then pcall(function()child:Destroy()end)end end local terrain=workspace:FindFirstChildOfClass("Terrain")if terrain then for _,child in ipairs(terrain:GetChildren())do if child:GetAttribute(CANDY_SKY_TAG)or(removeAll and child:IsA("Clouds"))then pcall(function()child:Destroy()end)end end end end local function candyInstance(className,parent,props)local inst=Instance.new(className)inst:SetAttribute(CANDY_SKY_TAG,true)for k,v in pairs(props or{})do pcall(function()inst[k]=v end)end inst.Parent=parent return inst end local function candyColor(rgb)return Color3.fromRGB(rgb[1],rgb[2],rgb[3])end local function CandyApplyCustomSky(mode)candySaveOriginalLighting()candyClearSky(true)local terrain=workspace:FindFirstChildOfClass("Terrain")local preset=CANDY_SKY_PRESETS[mode]if not preset or preset.kind=="off"then if candyOriginalLighting then for k,v in pairs(candyOriginalLighting)do if k~="LightingChildren"and k~="TerrainChildren"then pcall(function()Lighting[k]=v end)end end for _,child in ipairs(candyOriginalLighting.LightingChildren or{})do child:Clone().Parent=Lighting end local offTerrain=workspace:FindFirstChildOfClass("Terrain")if offTerrain then for _,child in ipairs(candyOriginalLighting.TerrainChildren or{})do child:Clone().Parent=offTerrain end end end currentSkyTheme="Off"return end Lighting.FogStart=0 Lighting.FogEnd=100000 Lighting.FogColor=Color3.fromRGB(200,200,200)Lighting.ColorShift_Top=Color3.fromRGB(0,0,0)Lighting.ColorShift_Bottom=Color3.fromRGB(0,0,0)Lighting.GlobalShadows=true Lighting.ClockTime=preset.clock or 14 Lighting.Brightness=preset.brightness or 2 if preset.outAmb then Lighting.OutdoorAmbient=candyColor(preset.outAmb)end if preset.ambient then Lighting.Ambient=candyColor(preset.ambient)end if preset.sky then local skyProps={}if preset.sky.stars then skyProps.StarCount=preset.sky.stars end if preset.sky.moon then skyProps.MoonAngularSize=preset.sky.moon end if preset.sky.sun then skyProps.SunAngularSize=preset.sky.sun end if preset.sky.moonTex then skyProps.MoonTextureId="rbxasset://sky/moon.jpg"end candyInstance("Sky",Lighting,skyProps)end if preset.atm then candyInstance("Atmosphere",Lighting,{Density=preset.atm.dens or 0.3,Color=candyColor(preset.atm.color),Decay=candyColor(preset.atm.decay),Glare=preset.atm.glare or 1,Haze=preset.atm.haze or 1})end if preset.clouds and terrain then candyInstance("Clouds",terrain,{Cover=preset.clouds.cover or 0.5,Density=preset.clouds.dens or 0.5,Color=candyColor(preset.clouds.color)})end currentSkyTheme=mode end local function setSkyTheme(theme)currentSkyTheme=theme CandyApplyCustomSky(theme) if skySelectorLabel then skySelectorLabel.Text=theme end end local MIKU_SKY_FRAMES={"rbxassetid://21076888","rbxassetid://21076945","rbxassetid://21077007","rbxassetid://21077125","rbxassetid://21077227","rbxassetid://21077345","rbxassetid://21077227","rbxassetid://21077125","rbxassetid://21077007","rbxassetid://21076945",}local mikuSkyObject=nil local mikuSkyThread=nil local mikuStoredSkies={}local function _mikuApplyFrame(sky,asset)if not sky or not sky.Parent then return end sky.SkyboxBk=asset sky.SkyboxDn=asset sky.SkyboxFt=asset sky.SkyboxLf=asset sky.SkyboxRt=asset sky.SkyboxUp=asset end function stopMikuSky()mikuSkyEnabled=false if mikuSkyThread then pcall(task.cancel,mikuSkyThread)mikuSkyThread=nil end if mikuSkyObject then pcall(function()mikuSkyObject:Destroy()end)mikuSkyObject=nil end local oldNamed=Lighting:FindFirstChild("awesome skybox")if oldNamed and oldNamed:IsA("Sky")then pcall(function()oldNamed:Destroy()end)end for _,clone in ipairs(mikuStoredSkies)do if clone then pcall(function()clone:Clone().Parent=Lighting end)pcall(function()clone:Destroy()end)end end mikuStoredSkies={}end function startMikuSky() if mikuSkyThread then mikuSkyEnabled=true return end mikuSkyEnabled=true mikuStoredSkies={}for _,child in ipairs(Lighting:GetChildren())do if child:IsA("Sky")then table.insert(mikuStoredSkies,child:Clone())pcall(function()child:Destroy()end)end end mikuSkyObject=Instance.new("Sky")mikuSkyObject.Name="awesome skybox"mikuSkyObject.Parent=Lighting _mikuApplyFrame(mikuSkyObject,MIKU_SKY_FRAMES[1])mikuSkyThread=task.spawn(function()local index=1 while mikuSkyEnabled do if not mikuSkyObject or not mikuSkyObject.Parent then mikuSkyObject=Instance.new("Sky")mikuSkyObject.Name="awesome skybox"mikuSkyObject.Parent=Lighting end _mikuApplyFrame(mikuSkyObject,MIKU_SKY_FRAMES[index])index=index+1 if index>#MIKU_SKY_FRAMES then index=1 end task.wait(0.1)end mikuSkyThread=nil end)end
if type(_G.__BlessHalloweenScreenCleanup)=="function"then pcall(_G.__BlessHalloweenScreenCleanup)end
_G.__BlessHalloweenScreenCleanup=nil



 medusaDebounce=false medusaLastUsed=0 dropActive=false lastDropTime=0 lastMoveDir=Vector3.new(0,0,0)origFOV=70 local resetCooldown=false local resetThread=nil local currentResetChar=nil local resetSuccessful=false local stopResetSequence=false local cameraLocked=false local lockedCameraCFrame=nil local function instaResetFast()if resetCooldown then return end resetCooldown=true resetSuccessful=false stopResetSequence=false cameraLocked=false local character=LP.Character if not character then resetCooldown=false return end local humanoid=character:FindFirstChildOfClass("Humanoid")if not humanoid then resetCooldown=false return end local camera=workspace.CurrentCamera if camera then lockedCameraCFrame=camera.CFrame cameraLocked=true camera.CFrame=lockedCameraCFrame end currentResetChar=character local isRespawning=false resetThread=task.spawn(function()local attempts=0 local maxAttempts=40 local originalHipHeight=humanoid.HipHeight while character and character.Parent and humanoid and humanoid.Health>0 and not isRespawning and not stopResetSequence do if LP.Character~=character then isRespawning=true break end pcall(function()humanoid.HipHeight=1e30 humanoid.AutoRotate=true local rootPart=character:FindFirstChild("HumanoidRootPart")if rootPart then rootPart.CanCollide=false end for _,part in ipairs(character:GetChildren())do if part:IsA("BasePart")and part.Name~="HumanoidRootPart"then part.CanCollide=false end end end)if not character or not character.Parent or not humanoid or humanoid.Health<=0 or LP.Character~=character then resetSuccessful=true break end attempts=attempts+1 if attempts>=maxAttempts then break end task.wait(0.05)end if not resetSuccessful then if character and character.Parent and humanoid and humanoid.Health>0 and not isRespawning then pcall(function()humanoid.Health=0 end)task.wait(0.1)if not character.Parent or humanoid.Health<=0 then resetSuccessful=true end end end if not resetSuccessful and character and character.Parent and humanoid then pcall(function()humanoid.HipHeight=originalHipHeight local rootPart=character:FindFirstChild("HumanoidRootPart")if rootPart then rootPart.CanCollide=true end for _,part in ipairs(character:GetChildren())do if part:IsA("BasePart")and part.Name~="HumanoidRootPart"then part.CanCollide=true end end end)end cameraLocked=false resetCooldown=false resetThread=nil currentResetChar=nil stopResetSequence=false end)end function instaReset()instaResetFast()end LP.CharacterAdded:Connect(function()stopResetSequence=true if resetThread then task.cancel(resetThread)resetThread=nil end resetCooldown=false currentResetChar=nil cameraLocked=false end)task.spawn(function()local camera=workspace.CurrentCamera while true do task.wait(0.016)if cameraLocked and lockedCameraCFrame and camera then camera.CFrame=lockedCameraCFrame end end end)
_anyKeyListening=false _prevAutoRotate=nil bypassConn=nil enemySpeedConn=nil movementLoop=nil steppedConn=nil alConn=nil arConn=nil holdInfJumpConn=nil autoTPConn=nil stretchConn=nil stretchFovConn=nil antiLagDescConn=nil dropConnections={}enemySpeedLabels={}Conns={autoSteal=nil,batCounter=nil,anchor={},progress=nil,autoLeft=nil,autoRight=nil}keyButtonRefs={}progressFill=nil progressPct=nil autoStealModeStatusLabel=nil progressRadLbl=nil pbFrame=nil speedLabel=nil modeValLbl=nil normalBox,carryBox,laggerBox,lagger2Box,radInput,semiRadInput,autoTPHeightBox,uiScaleBox=nil,nil,nil,nil,nil,nil,nil,nil normalSpeedSetVisual=nil dropModeBtnRef=nil batV2SpeedBox=nil batV2SetVisual=nil setJumpToggleState=nil autoBatSetVisual,autoLeftSetVisual,autoRightSetVisual,setBatCounterVisual,setMedusaVisual=nil,nil,nil,nil,nil aimbotModeSetVisual=nil setAntiRagVisual,setAntiDieVisual,setJumpVisual,setAntiLagVisual,setAutoTPDownVisual,setLockUIVisual,setInstaGrab,bypassSetVisual=nil,nil,nil,nil,nil,nil,nil,nil setRagdollCountdownVisual=nil mikuSkySetVisual=nil setEditModeVisual=nil setESPVIsual=nil mobSetAutoBat,mobSetBatV2,mobSetAutoLeft,mobSetAutoRight,mobSetDropBR,mobSetTpDown,mobSetCarry,mobSetLagger1,mobSetLagger2,mobSetTpBat,mobSetReset=nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil miniBtn,main,gui=nil,nil,nil MobilePanel=nil instaResetFloatingButton=nil bypassFloatingButton=nil showGui=nil hideGui=nil mainUIScale=nil skySelectorLabel=nil animSelectorLabel=nil pbScale=nil stealBarScaleBox=nil function refreshStealBarScale()
 if not pbScale then return end
 local camera=workspace.CurrentCamera
 local view=camera and camera.ViewportSize or Vector2.new(1920,1080)
 local width=pbFrame and pbFrame.Size.X.Offset or 326
 local height=pbFrame and pbFrame.Size.Y.Offset or 58
 local desired=math.clamp((tonumber(stealBarScaleValue)or 100)/100,.5,1.8)
 local scale=math.max(.2,math.min(desired,(view.X-16)/width,(view.Y-16)/height))
 pbScale.Scale=scale
 if pbFrame and pbFrame.Parent then
  local p=pbFrame.Position
  local x=math.clamp(view.X*p.X.Scale+p.X.Offset,0,math.max(0,view.X-width*scale))
  local y=math.clamp(view.Y*p.Y.Scale+p.Y.Offset,0,math.max(0,view.Y-height*scale))
  pbFrame.Position=UDim2.new(p.X.Scale,x-view.X*p.X.Scale,p.Y.Scale,y-view.Y*p.Y.Scale)
 end
end GAMEPAD_KEYS={[Enum.KeyCode.ButtonA]=true,[Enum.KeyCode.ButtonB]=true,[Enum.KeyCode.ButtonX]=true,[Enum.KeyCode.ButtonY]=true,[Enum.KeyCode.ButtonL1]=true,[Enum.KeyCode.ButtonR1]=true,[Enum.KeyCode.ButtonL2]=true,[Enum.KeyCode.ButtonR2]=true,[Enum.KeyCode.ButtonL3]=true,[Enum.KeyCode.ButtonR3]=true,[Enum.KeyCode.ButtonStart]=true,[Enum.KeyCode.ButtonSelect]=true,[Enum.KeyCode.DPadUp]=true,[Enum.KeyCode.DPadDown]=true,[Enum.KeyCode.DPadLeft]=true,[Enum.KeyCode.DPadRight]=true,}MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,[Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true,}local BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}AP={L1=Vector3.new(-476.48,-6.28,92.73),L2=Vector3.new(-483.12,-4.95,94.80),L_FACE=Vector3.new(-482.25,-4.96,92.09),R1=Vector3.new(-476.16,-6.52,25.62),R2=Vector3.new(-483.06,-5.03,25.48),R_FACE=Vector3.new(-482.06,-6.93,35.47),}do if type(_G.BlessMoreButtonsCleanup)=="function"then pcall(_G.BlessMoreButtonsCleanup)end local cas=game:GetService("ContextActionService")local gs=game:GetService("GuiService")local uis=game:GetService("UserInputService")local rs=game:GetService("RunService")local gps=game:GetService("GamepadService")local sg=game:GetService("StarterGui")local savedAvatar local key=Enum.KeyCode.DPadUp local action="BlessMoreButtons"local connections,pressed,saved,savedPads={},{},{},{}local alive,applying,allowNavigation,coreBound,regularBound=true,false,false,false,false local identityGet=getthreadidentity or getidentity local identitySet=setthreadidentity or setidentity local function coreCall(fn)local ok=pcall(fn)if ok then return true end if type(identityGet)~="function"or type(identitySet)~="function"then return false end local read,previous=pcall(identityGet)if not read or type(previous)~="number"then return false end if not pcall(identitySet,8)then pcall(identitySet,previous)return false end ok=pcall(fn)pcall(identitySet,previous)return ok end local function isPad(input)return input and input.UserInputType and input.UserInputType.Name:match("^Gamepad")~=nil end local function restoreNavigation()applying=true for property,value in pairs(saved)do coreCall(function()gs[property]=value end)end for pad,value in pairs(savedPads)do coreCall(function()uis:SetNavigationGamepad(pad,value)end)end applying=false end local function guardNavigation()if applying or not alive or not uiVisual.moreButtons or allowNavigation then return end local menuOpen=false coreCall(function()menuOpen=gs.MenuIsOpen==true end)if menuOpen then return end applying=true for _,property in ipairs({"AutoSelectGuiEnabled","GuiNavigationEnabled","CoreGuiNavigationEnabled"})do coreCall(function()if gs[property]then gs[property]=false end end)end coreCall(function()for _,pad in ipairs(uis:GetConnectedGamepads())do if savedPads[pad]==nil then savedPads[pad]=uis:IsNavigationGamepad(pad)end if uis:IsNavigationGamepad(pad)then uis:SetNavigationGamepad(pad,false)end end end)coreCall(function()if gs.SelectedObject then gs.SelectedObject=nil end end)coreCall(function()if gs.SelectedCoreObject then gs.SelectedCoreObject=nil end end)coreCall(function()if gps.GamepadCursorEnabled then gps:DisableGamepadCursor()end end)if savedAvatar~=nil then coreCall(function()if sg:GetCore("AvatarContextMenuEnabled")then sg:SetCore("AvatarContextMenuEnabled",false)end end)end applying=false end function uiVisual.handleMoreButton(input)if not alive or not isPad(input)or input.KeyCode~=key then return end local pad=input.UserInputType if pressed[pad]then return end pressed[pad]=true if uiVisual.moreButtons then allowNavigation=false guardNavigation()end if _anyKeyListening then local capture=uiVisual.moreButtonsCapture if capture then capture(input)end return end local run=_G.M4LWARE_RunKeybind if type(run)=="function"then run(key)end end function uiVisual.releaseMoreButton(input)if isPad(input)and input.KeyCode==key then pressed[input.UserInputType]=nil end end local function restore()for _,connection in ipairs(connections)do pcall(function()connection:Disconnect()end)end connections={}if coreBound then coreCall(function()cas:UnbindCoreAction(action)end)end if regularBound then pcall(function()cas:UnbindAction(action)end)end coreBound,regularBound=false,false restoreNavigation()if savedAvatar~=nil then coreCall(function()sg:SetCore("AvatarContextMenuEnabled",savedAvatar)end)end savedAvatar=nil saved,pressed,savedPads={},{},{}uiVisual.moreButtonsNativeBlocked=false end uiVisual.moreButtons=false uiVisual.moreButtonsNativeBlocked=false function uiVisual.isMoreButton(candidate)return candidate==key end function uiVisual.setMoreButtons(enabled,shouldSave)if not alive then return end enabled=enabled==true if enabled~=uiVisual.moreButtons then restore()uiVisual.moreButtons=enabled if enabled then allowNavigation=false coreCall(function()local value=sg:GetCore("AvatarContextMenuEnabled")if type(value)=="boolean"then savedAvatar=value end end)for _,property in ipairs({"AutoSelectGuiEnabled","GuiNavigationEnabled","CoreGuiNavigationEnabled"})do coreCall(function()saved[property]=gs[property]connections[#connections+1]=gs:GetPropertyChangedSignal(property):Connect(guardNavigation)end)end guardNavigation()local function observeInput(_,state,input)if alive and uiVisual.moreButtons and isPad(input)and input.KeyCode==key then if state==Enum.UserInputState.Begin then task.defer(function()uiVisual.handleMoreButton(input)end)end end return Enum.ContextActionResult.Pass end coreBound=coreCall(function()cas:BindCoreActionAtPriority(action,observeInput,false,10000,key)end)regularBound=pcall(function()cas:BindActionAtPriority(action,observeInput,false,10000,key)end)connections[#connections+1]=uis.InputBegan:Connect(function(input)if not isPad(input)then return end if input.KeyCode==key then uiVisual.handleMoreButton(input)elseif input.KeyCode==Enum.KeyCode.ButtonSelect or input.KeyCode==Enum.KeyCode.ButtonStart then allowNavigation=true restoreNavigation()end end)connections[#connections+1]=uis.InputEnded:Connect(uiVisual.releaseMoreButton)connections[#connections+1]=uis.GamepadDisconnected:Connect(function(pad)pressed[pad]=nil end)connections[#connections+1]=uis.GamepadConnected:Connect(guardNavigation)connections[#connections+1]=uis.WindowFocusReleased:Connect(function()pressed={}end)for _,property in ipairs({"SelectedObject","SelectedCoreObject"})do coreCall(function()connections[#connections+1]=gs:GetPropertyChangedSignal(property):Connect(guardNavigation)end)end coreCall(function()connections[#connections+1]=gps:GetPropertyChangedSignal("GamepadCursorEnabled"):Connect(guardNavigation)end)local elapsed=0 connections[#connections+1]=rs.Heartbeat:Connect(function(dt)elapsed=elapsed+dt if elapsed<0.05 then return end elapsed=0 guardNavigation()pcall(function()for _,pad in ipairs(uis:GetConnectedGamepads())do if uis:IsGamepadButtonDown(pad,key)then uiVisual.handleMoreButton({UserInputType=pad,KeyCode=key})else pressed[pad]=nil end end end)end)uiVisual.moreButtonsNativeBlocked=true end end if uiVisual.moreButtonsVisual then uiVisual.moreButtonsVisual(enabled)end if shouldSave~=false and saveAllSettings then task.defer(saveAllSettings)end end _G.BlessMoreButtonsCleanup=function()if not alive then return end uiVisual.moreButtons=false restore()alive=false end end function isGamepadInput(inp)return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad")~=nil end function isBindableInput(inp)if not inp or inp.KeyCode==Enum.KeyCode.Unknown then return false end if inp.UserInputType==Enum.UserInputType.Keyboard then return true end return isGamepadInput(inp)and GAMEPAD_KEYS[inp.KeyCode]==true end function kbMatch(entry,kc)return kc and(kc==entry.kb or(entry.gp and kc==entry.gp))end function resetProgressBar()if progressPct then progressPct.Text="0%"end if uiVisual.setStealProgress then uiVisual.setStealProgress(0)end end
do
pcall(function()
    if _G.VX7InfinityJump and type(_G.VX7InfinityJump.Destroy) == "function" then _G.VX7InfinityJump.Destroy() end
end)
local _V3new, _clamp = Vector3.new, math.clamp
local InfiniteJump = { enabled = false, jumpPower = 55, minVelocity = 35, fallClamp = -120, jumpConn = nil, heartbeatConn = nil }

local function applyJump(root)
    if not root then return end
    pcall(function()
        root.Velocity = _V3new(root.Velocity.X, InfiniteJump.jumpPower, root.Velocity.Z)
    end)
end

local function onJumpRequest()
    if not InfiniteJump.enabled then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then applyJump(root) end
end

local function onHeartbeat()
    if not InfiniteJump.enabled then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local jumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true)
    if jumpHeld and root.Velocity.Y < InfiniteJump.minVelocity then
        applyJump(root)
    end
    if root.Velocity.Y < InfiniteJump.fallClamp then
        root.Velocity = _V3new(root.Velocity.X, InfiniteJump.fallClamp, root.Velocity.Z)
    end
end

local function connectEvents()
    if InfiniteJump.jumpConn then InfiniteJump.jumpConn:Disconnect() end
    if InfiniteJump.heartbeatConn then InfiniteJump.heartbeatConn:Disconnect() end
    InfiniteJump.jumpConn = UIS.JumpRequest:Connect(onJumpRequest)
    InfiniteJump.heartbeatConn = RunService.Heartbeat:Connect(onHeartbeat)
end

function InfiniteJump.start()
    if InfiniteJump.enabled then return end
    InfiniteJump.enabled = true
    connectEvents()
end

function InfiniteJump.stop()
    InfiniteJump.enabled = false
    if InfiniteJump.jumpConn then InfiniteJump.jumpConn:Disconnect(); InfiniteJump.jumpConn = nil end
    if InfiniteJump.heartbeatConn then InfiniteJump.heartbeatConn:Disconnect(); InfiniteJump.heartbeatConn = nil end
end

function InfiniteJump.setJumpPower(power)
    power = tonumber(power) or 55
    InfiniteJump.jumpPower = _clamp(power, 10, 200)
end

function InfiniteJump.isRunning() return InfiniteJump.enabled == true end

function startJumpMode()
    jumpEnabled = true
    _G.KillHub.Active.jump = true
    InfiniteJump.start()
    _G.KillHub.Connections.infJump = InfiniteJump.heartbeatConn
    _G.KillHub.Connections.infJumpRequest = InfiniteJump.jumpConn
    if setJumpVisual then setJumpVisual(true) end
end
function stopJumpMode()
    jumpEnabled = false
    _G.KillHub.Active.jump = false
    InfiniteJump.stop()
    _G.KillHub.Connections.infJump = nil
    _G.KillHub.Connections.infJumpRequest = nil
    if setJumpVisual then setJumpVisual(false) end
end
_G._AdaptInfJumpMode = "HOLD"
_G.VX7InfinityJump = {
    SetEnabled = function(on)if on then startJumpMode()else stopJumpMode()end;return jumpEnabled end,
    GetEnabled = function()return jumpEnabled==true end,
    Toggle = function()if jumpEnabled then stopJumpMode()else startJumpMode()end;return jumpEnabled end,
    ClearVelocity = function()end,
    Destroy = stopJumpMode,
}
end
-- Yout anti ragdoll: one toggle, original V2 recovery method.
do
local _tick, _V3zero = tick, Vector3.zero
local AntiRagdollV2 = { Enabled = false, Connection = nil, ResetCooldown = 0 }

local function startAntiRagdollV2()
    if AntiRagdollV2.Connection then return end
    AntiRagdollV2.Enabled = true
    AntiRagdollV2.Connection = RunService.Heartbeat:Connect(function()
        if not AntiRagdollV2.Enabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end
        if dropActive or _G.IsDropping then return end
        local state = hum:GetState()
        local now = _tick()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown then
            if now - AntiRagdollV2.ResetCooldown > 0.15 then
                AntiRagdollV2.ResetCooldown = now
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    root.Velocity = _V3zero
                    root.RotVelocity = _V3zero
                    root.AssemblyLinearVelocity = _V3zero
                    root.AssemblyAngularVelocity = _V3zero
                    for _, obj in ipairs(char:GetDescendants()) do
                        if obj:IsA("Motor6D") then obj.Enabled = true end
                        if obj:IsA("Constraint") then obj.Enabled = true end
                    end
                    workspace.CurrentCamera.CameraSubject = hum
                    local PM = LP.PlayerScripts:FindFirstChild("PlayerModule")
                    if PM then
                        local CM = require(PM:FindFirstChild("ControlModule"))
                        if CM then CM:Enable() end
                    end
                    hum.AutoRotate = true
                    hum.PlatformStand = false
                    hum.Sit = false
                end)
            end
        end
    end)
end

local function stopAntiRagdollV2()
    AntiRagdollV2.Enabled = false
    if AntiRagdollV2.Connection then
        AntiRagdollV2.Connection:Disconnect()
        AntiRagdollV2.Connection = nil
    end
    AntiRagdollV2.ResetCooldown = 0
end

function setAntiRagdollMode(mode)
    if mode == "v2" then
        startAntiRagdollV2()
        antiRagdollMode = "v2"
    else
        stopAntiRagdollV2()
        antiRagdollMode = "off"
    end
    if setAntiRagVisual then setAntiRagVisual(antiRagdollMode == "v2") end
    saveAllSettings()
end

local respawnGeneration, respawnConnection = 0, nil
local function bindRespawn()
    if respawnConnection then return end
    local generation = respawnGeneration
    respawnConnection = LP.CharacterAdded:Connect(function()
        task.wait(0.5)
        if generation ~= respawnGeneration then return end
        if antiRagdollMode == "v2" then
            if AntiRagdollV2.Connection then
                AntiRagdollV2.Connection:Disconnect()
                AntiRagdollV2.Connection = nil
            end
            startAntiRagdollV2()
            _G.KillHub.Connections.antiRagdoll = AntiRagdollV2.Connection
        end
    end)
    _G.KillHub.Connections.antiRagdollCharacter = respawnConnection
end
function uiVisual.stopAntiRagdollEngines()
    stopAntiRagdollV2()
    _G.KillHub.Connections.antiRagdoll = nil
end
function uiVisual.shutdownYoutAntiRagdollBindings()
    respawnGeneration = respawnGeneration + 1
    if respawnConnection then respawnConnection:Disconnect();respawnConnection=nil end
    _G.KillHub.Connections.antiRagdollCharacter = nil
    uiVisual.stopAntiRagdollEngines()
end
function startAntiRagdoll()
    bindRespawn()
    antiRagdollEnabled = true
    _G.KillHub.Active.antiRagdoll = true
    setAntiRagdollMode("v2")
    _G.KillHub.Connections.antiRagdoll = AntiRagdollV2.Connection
end
function stopAntiRagdoll()
    antiRagdollEnabled = false
    _G.KillHub.Active.antiRagdoll = false
    setAntiRagdollMode("off")
    _G.KillHub.Connections.antiRagdoll = nil
end
function setAntiRag(on)
    if on then startAntiRagdoll()else stopAntiRagdoll()end
end
end
-- Ragdoll Countdown (DELUXE)
do
    local _V3new = Vector3.new
    local _ragCountdownRunning = false
    local _ragCountdownThread = nil
    local _wasRagdolled = false
    local function _getRagBillboard()
        local char = LP.Character
        if not char then return nil, nil end
        local head = char:FindFirstChild("Head")
        if not head then return nil, nil end
        local pGui = LP.PlayerGui
        local existing = pGui:FindFirstChild("RagCountdownBillboard")
        if existing then existing:Destroy() end
        local bb = Instance.new("BillboardGui")
        bb.Name = "RagCountdownBillboard"
        bb.Size = UDim2.new(0, 84, 0, 42)
        bb.StudsOffset = _V3new(0, 4.5, 0)
        bb.AlwaysOnTop = true
        bb.Adornee = head
        bb.Parent = pGui
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.AnchorPoint = Vector2.new(0.5, 0.5)
        lbl.Position = UDim2.new(0.5, 0, 0.5, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextScaled = true
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        lbl.TextStrokeTransparency = 0
        lbl.Text = ""
        lbl:SetAttribute("FearThemeRole","RagdollCountdown")
        lbl.Parent = bb
        local grad = Instance.new("UIGradient", lbl)
        grad:SetAttribute("FearThemeRole","BlackAccentGradient")
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.3, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.7, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
        })
        grad.Rotation = 45
        grad.Offset = Vector2.new(0,0)
        uiVisual.refreshTheme(bb)
        return bb, lbl
    end

    local function _ragPunch(lbl, text)
        if not (lbl and lbl.Parent) then return end
        lbl.Text = text
    end

    local function _startRagCountdown()
        if _ragCountdownRunning then return end
        _ragCountdownRunning = true
        _ragCountdownThread = task.spawn(function()
            local bb, lbl = _getRagBillboard()
            if not bb then _ragCountdownRunning = false; return end
            local timeLeft = 2.5
            local step = 0.1
            while timeLeft > 0 and bb.Parent do
                _ragPunch(lbl, string.format("%.1f", timeLeft))
                task.wait(step)
                timeLeft = timeLeft - step
            end
            if bb and bb.Parent then
                _ragPunch(lbl, "READY!")
                task.wait(0.5)
                if bb and bb.Parent then bb:Destroy() end
            end
            _ragCountdownRunning = false
            _ragCountdownThread = nil
        end)
    end

    local function _watchRagdoll()
        local char = LP.Character
        if not char then _wasRagdolled = false; return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then _wasRagdolled = false; return end
        local st = hum:GetState()
        local inRag = st == Enum.HumanoidStateType.Physics
                   or st == Enum.HumanoidStateType.Ragdoll
                   or st == Enum.HumanoidStateType.FallingDown
        if inRag and not _wasRagdolled then
            _wasRagdolled = true
            _startRagCountdown()
        elseif not inRag then
            _wasRagdolled = false
        end
    end

    local function _stopRagCountdown()
        local thread = _ragCountdownThread
        _ragCountdownThread = nil
        if thread then pcall(task.cancel, thread) end
        local pGui = LP:FindFirstChild("PlayerGui")
        local bb = pGui and pGui:FindFirstChild("RagCountdownBillboard")
        if bb then bb:Destroy() end
        _ragCountdownRunning = false
        _wasRagdolled = false
    end

    function setRagdollCountdown(on)
        ragdollCountdownEnabled = on == true
        _G.KillHub.Active.ragdollCountdown = ragdollCountdownEnabled
        local connection = _G.KillHub.Connections.ragdollCountdown
        if ragdollCountdownEnabled then
            if not connection then
                _G.KillHub.Connections.ragdollCountdown = RunService.Heartbeat:Connect(_watchRagdoll)
            end
        else
            if connection then
                connection:Disconnect()
                _G.KillHub.Connections.ragdollCountdown = nil
            end
            _stopRagCountdown()
        end
        if setRagdollCountdownVisual then
            setRagdollCountdownVisual(ragdollCountdownEnabled)
        end
    end

    _G.KillHub.StopRagdollCountdown = function()
        setRagdollCountdown(false)
    end
end

-- Bubble Anti Die; compatibility names preserve Float and Spin ownership.
local FantaAntiDie={enabled=false,humanoid=nil}
local function _activateFantaAntiDie(char)
    if not FantaAntiDie.enabled then return end
    char=char or LP.Character
    if not char then return end
    uiVisual.bubble.attachAntiDie(char)
    FantaAntiDie.humanoid=char:FindFirstChildOfClass("Humanoid")
end
function startAntiDie()
    FantaAntiDie.enabled=true;antiDieEnabled=true
    _G.KillHub.Active.antiDie=true
    uiVisual.bubble.setAntiDie(true)
    if setAntiDieVisual then setAntiDieVisual(true)end
end
function stopAntiDie()
    FantaAntiDie.enabled=false;antiDieEnabled=false
    _G.KillHub.Active.antiDie=false
    uiVisual.bubble.setAntiDie(false)
    FantaAntiDie.humanoid=nil
    if setAntiDieVisual then setAntiDieVisual(false)end
end

mobSetFloat = nil
do
    local old = rawget(_G, "__BlessFloat")
    if type(old) == "table" then
        local wasOn = old.running == true or old.conn ~= nil
        old.running = false
        old.cycleToken = (old.cycleToken or 0) + 1
        if old.thread then pcall(task.cancel, old.thread); old.thread = nil end
        if old.conn then pcall(function() old.conn:Disconnect() end); old.conn = nil end
        if wasOn and type(old.groundTP) == "function" then pcall(old.groundTP) end
        if wasOn and type(old.release) == "function" then pcall(old.release) end
    end
end

_G.__BlessFloat = {
    RISE = 17, RATE = 55, CYCLE = 2.5, PAUSE = 0.5, SAMPLE = 0.08, PIT_MARGIN = 15,
    conn = nil, thread = nil, running = false, locked = false,
    targetY = nil, baseY = nil, baseGround = nil,
    safeValid = false, safeX = 0, safeZ = 0, safeY = 0,
    cycleToken = 0, _params = nil,
}

function _G.__BlessFloat.getHRP()
    local c = LP.Character
    if not c then return nil, nil end
    return c:FindFirstChild("HumanoidRootPart"), c:FindFirstChildOfClass("Humanoid")
end
function _G.__BlessFloat.arm()
    local FLOAT = _G.__BlessFloat
    FLOAT.antiDieOwned = antiDieEnabled ~= true
    if FLOAT.antiDieOwned then
        startAntiDie()
        if LP.Character then pcall(_activateFantaAntiDie, LP.Character) end
    end
end
function _G.__BlessFloat.release()
    local FLOAT = _G.__BlessFloat
    local owned = FLOAT.antiDieOwned == true
    FLOAT.antiDieOwned = false
    if owned then
        local spin = rawget(_G, "__BlessAutoSpin")
        if type(spin) == "table" and spin.running then spin.antiDieOwned = true else stopAntiDie() end
    end
end
function _G.__BlessFloat.findGround(char, hrp)
    local FLOAT = _G.__BlessFloat
    local params = FLOAT._params
    if not params then
        params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.IgnoreWater = true
        pcall(function() params.RespectCanCollide = true end)
        FLOAT._params = params
    end
    local filter = { char }
    local plist = Players:GetPlayers()
    for i = 1, #plist do
        local plr = plist[i]
        if plr ~= LP and plr.Character then filter[#filter + 1] = plr.Character end
    end
    local half = hrp.Size.Y * 0.5
    if half <= 0 then half = 1 end
    local origin = hrp.Position
    local startY = origin.Y - half - 0.1
    for _ = 1, 6 do
        params.FilterDescendantsInstances = filter
        local res = workspace:Raycast(Vector3.new(origin.X, startY, origin.Z), Vector3.new(0, -1000, 0), params)
        if not res then return nil, half end
        local part = res.Instance
        if part and part:IsA("BasePart") and part.CanCollide then
            local model = part:FindFirstAncestorOfClass("Model")
            if not (model and model:FindFirstChildOfClass("Humanoid")) then
                return res.Position.Y, half
            end
        end
        if part then filter[#filter + 1] = part end
        startY = res.Position.Y - 0.05
    end
    return nil, half
end
function _G.__BlessFloat.isSafeGround(g)
    local FLOAT = _G.__BlessFloat
    if not g then return false end
    if FLOAT.baseGround and g < FLOAT.baseGround - FLOAT.PIT_MARGIN then return false end
    return true
end
function _G.__BlessFloat.groundTP()
    local FLOAT = _G.__BlessFloat
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end
    local pos = hrp.Position
    local x, z = pos.X, pos.Z
    local groundY, half
    pcall(function() groundY, half = FLOAT.findGround(char, hrp) end)
    local relocated = false
    if not FLOAT.isSafeGround(groundY) and FLOAT.safeValid then
        x, z, groundY = FLOAT.safeX, FLOAT.safeZ, FLOAT.safeY
        relocated = true
    end
    local targetY
    if groundY then
        half = half or math.max(hrp.Size.Y * 0.5, 1)
        local off = half * 3
        if hum.RigType ~= Enum.HumanoidRigType.R6 then
            off = half + (hum.HipHeight or (half * 2))
        end
        if off ~= off or off < 1 or off > 12 then off = half * 3 end
        targetY = groundY + off + 0.15
    elseif FLOAT.baseY then
        targetY = FLOAT.baseY
    end
    if targetY and targetY == targetY and targetY > -400 then
        pcall(function()
            if not relocated and pos.Y - targetY < 0.5 then
                hrp.AssemblyLinearVelocity = Vector3.zero
                return
            end
            hrp.CFrame = CFrame.new(x, targetY, z) * hrp.CFrame.Rotation
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
    end
end
function _G.__BlessFloat.startLoop()
    local FLOAT = _G.__BlessFloat
    if FLOAT.conn then return end
    FLOAT.locked = false
    FLOAT.targetY = nil
    local char0 = LP.Character
    local root0 = char0 and char0:FindFirstChild("HumanoidRootPart")
    local hum0 = char0 and char0:FindFirstChildOfClass("Humanoid")
    if hum0 then pcall(function() hum0:ChangeState(Enum.HumanoidStateType.Freefall) end) end
    FLOAT.safeValid = false
    FLOAT.baseGround = nil
    if char0 and root0 then
        local ok, g = pcall(FLOAT.findGround, char0, root0)
        if ok and g then
            FLOAT.baseGround = g
            FLOAT.safeX, FLOAT.safeZ, FLOAT.safeY = root0.Position.X, root0.Position.Z, g
            FLOAT.safeValid = true
        end
    end
    local cChar, cRoot, cHum = nil, nil, nil
    local sampleT = 0
    FLOAT.conn = RunService.Heartbeat:Connect(function(dt)
        local char = LP.Character
        if char ~= cChar or not cRoot or not cRoot.Parent then
            cChar = char
            cRoot = char and char:FindFirstChild("HumanoidRootPart") or nil
            cHum  = char and char:FindFirstChildOfClass("Humanoid") or nil
        end
        if not cRoot or not cHum or cHum.Health <= 0 then return end
        local cf  = cRoot.CFrame
        local pos = cf.Position
        local vel = cRoot.AssemblyLinearVelocity
        sampleT = sampleT + dt
        if sampleT >= FLOAT.SAMPLE then
            sampleT = 0
            local ok, g = pcall(FLOAT.findGround, cChar, cRoot)
            if ok and FLOAT.isSafeGround(g) then
                FLOAT.safeX, FLOAT.safeZ, FLOAT.safeY = pos.X, pos.Z, g
                FLOAT.safeValid = true
            elseif ok and FLOAT.safeValid then
                pos = Vector3.new(FLOAT.safeX, pos.Y, FLOAT.safeZ)
                vel = Vector3.new(0, vel.Y, 0)
            end
        end
        if not FLOAT.targetY then
            FLOAT.baseY   = pos.Y
            FLOAT.targetY = pos.Y + FLOAT.RISE
        end
        local y = FLOAT.targetY
        if not FLOAT.locked then
            y = math.min(pos.Y + FLOAT.RATE * dt, FLOAT.targetY)
            if y >= FLOAT.targetY then FLOAT.locked = true end
        end
        cRoot.CFrame = CFrame.new(pos.X, y, pos.Z) * cf.Rotation
        cRoot.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z)
    end)
end
function _G.__BlessFloat.stopLoop(tpDown)
    local FLOAT = _G.__BlessFloat
    if FLOAT.conn then
        pcall(function() FLOAT.conn:Disconnect() end)
        FLOAT.conn = nil
    end
    if tpDown then pcall(FLOAT.groundTP) end
end
function _G.__BlessFloat.waitGrounded(timeout)
    local FLOAT = _G.__BlessFloat
    local deadline = os.clock() + (timeout or 3)
    while os.clock() < deadline do
        if not FLOAT.running then return end
        local hrp, hum = FLOAT.getHRP()
        if not hrp or not hum then return end
        if hum.Health <= 0 then return end
        if hum.FloorMaterial ~= Enum.Material.Air then task.wait(FLOAT.PAUSE); return end
        RunService.Heartbeat:Wait()
    end
end
function _G.__BlessFloat.spawnCycle()
    local FLOAT = _G.__BlessFloat
    if FLOAT.thread then pcall(task.cancel, FLOAT.thread); FLOAT.thread = nil end
    FLOAT.cycleToken = FLOAT.cycleToken + 1
    local token = FLOAT.cycleToken
    FLOAT.thread = task.spawn(function()
        while FLOAT.running and FLOAT.cycleToken == token do
            task.wait(FLOAT.CYCLE)
            if not FLOAT.running or FLOAT.cycleToken ~= token then break end
            FLOAT.stopLoop(true)
            FLOAT.waitGrounded(3)
            if not FLOAT.running or FLOAT.cycleToken ~= token then break end
            FLOAT.startLoop()
        end
    end)
end
function _G.__BlessFloat.enable()
    local FLOAT = _G.__BlessFloat
    if FLOAT.running then return end
    FLOAT.running = true
    FLOAT.arm()
    FLOAT.startLoop()
    FLOAT.spawnCycle()
    if mobSetFloat then pcall(mobSetFloat, true) end
end
function _G.__BlessFloat.disable()
    local FLOAT = _G.__BlessFloat
    if not FLOAT.running then return end
    FLOAT.running = false
    FLOAT.cycleToken = FLOAT.cycleToken + 1
    if FLOAT.thread then pcall(task.cancel, FLOAT.thread); FLOAT.thread = nil end
    FLOAT.stopLoop(true)
    FLOAT.safeValid = false
    FLOAT.baseGround = nil
    FLOAT.release()
    if mobSetFloat then pcall(mobSetFloat, false) end
end
function _G.__BlessFloatToggle()
    local F = _G.__BlessFloat
    if F.running then F.disable() else F.enable() end
    if mobSetFloat then pcall(mobSetFloat, F.running) end
end
function _G.__BlessFloatIsRunning()
    return _G.__BlessFloat.running == true
end

 function forceRestoreBlessAntiDie()if _G.__BlessFloat then _G.__BlessFloat.antiDieOwned=false end antiDieEnabled=true FantaAntiDie.enabled=true _G.KillHub.Active.antiDie=true pcall(startAntiDie)local function applyNow()if not antiDieEnabled or not FantaAntiDie.enabled then return end local char=LP.Character if not char then return end local hum=char:FindFirstChildOfClass("Humanoid")if not hum or hum.Health<=0 then return end pcall(function()hum.BreakJointsOnDeath=false hum:SetStateEnabled(Enum.HumanoidStateType.Dead,false)end)pcall(function()_activateFantaAntiDie(char)end)if setAntiDieVisual then pcall(setAntiDieVisual,true)end end applyNow()task.delay(0.20,applyNow)task.delay(0.55,applyNow)task.delay(1.00,applyNow)end 
autoTPDownHeight = 20
autoTPDownEnabled = false
function startAutoTPDown()
    autoTPDownEnabled=true;_G.KillHub.Active.autoTPDown=true
    uiVisual.bubble.setAutoTPDown(true)
    _G.KillHub.Connections.autoTPDown=uiVisual.bubble.autoTPConnection
    if setAutoTPDownVisual then setAutoTPDownVisual(true)end
end
function stopAutoTPDown()
    autoTPDownEnabled=false;_G.KillHub.Active.autoTPDown=false
    uiVisual.bubble.setAutoTPDown(false)
    uiVisual.bubble.cancelTPDown()
    _G.KillHub.Connections.autoTPDown=nil
    if setAutoTPDownVisual then setAutoTPDownVisual(false)end
end
_G.AceStopAutoTPForAction=function()end
function runTPDown()
    pcall(function()
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        hrp.CFrame = CFrame.new(hrp.Position.X, -7, hrp.Position.Z)
            * CFrame.Angles(0, select(2, hrp.CFrame:ToEulerAnglesYXZ()), 0)
        hrp.AssemblyLinearVelocity = Vector3.zero
    end)
end
_G.FearMirrorTPDownEnabled = false
function setupChar(char)if antiRagdollEnabled then task.wait(0.5)startAntiRagdoll()end end LP.CharacterAdded:Connect(setupChar)if LP.Character then task.spawn(function()setupChar(LP.Character)end)end local espHighlightCache={}local espTracerCache={}local espConn=nil local _espLastRun=0 local function clearESP()for plr in pairs(espHighlightCache)do pcall(function()espHighlightCache[plr]:Destroy()end)end for plr in pairs(espTracerCache)do for _,ln in ipairs(espTracerCache[plr])do pcall(function()ln.Visible=false;ln:Remove()end)end end espHighlightCache={}espTracerCache={}end local function makeESPTracers()if not(Drawing and type(Drawing.new)=="function")then return nil end local SILVER_MOBILE=Color3.fromRGB(196,199,205)local outer=Drawing.new("Line")outer.Color=PINK outer.Thickness=2.2 outer.Transparency=0.90 outer.Visible=false local mid=Drawing.new("Line")mid.Color=PINK mid.Thickness=1.2 mid.Transparency=0.74 mid.Visible=false local core=Drawing.new("Line")core.Color=PINK core.Thickness=0.6 core.Transparency=0.10 core.Visible=false return{outer,mid,core}end local function updateESP()local now=tick()if now-_espLastRun<0.03 then return end _espLastRun=now if not espEnabled then clearESP();return end local myChar=LP.Character local myRoot=myChar and myChar:FindFirstChild("HumanoidRootPart")if not myRoot then return end local myPos=myRoot.Position local myScreenPos,myOnScreen=camera:WorldToViewportPoint(myPos)local myVec=Vector2.new(myScreenPos.X,myScreenPos.Y)local currentPlayers=Players:GetPlayers()local plrSet={}for _,p in ipairs(currentPlayers)do plrSet[p]=true end for plr in pairs(espHighlightCache)do if not plrSet[plr]then pcall(function()espHighlightCache[plr]:Destroy()end)espHighlightCache[plr]=nil end end for plr in pairs(espTracerCache)do if not plrSet[plr]then for _,ln in ipairs(espTracerCache[plr])do pcall(function()ln.Visible=false;ln:Remove()end)end espTracerCache[plr]=nil end end for _,plr in ipairs(currentPlayers)do if plr==LP then continue end local char=plr.Character if not char then if espHighlightCache[plr]then pcall(function()espHighlightCache[plr]:Destroy()end)espHighlightCache[plr]=nil end if espTracerCache[plr]then for _,ln in ipairs(espTracerCache[plr])do pcall(function()ln.Visible=false end)end end continue end local tRoot=char:FindFirstChild("HumanoidRootPart")local tHead=char:FindFirstChild("Head")local tHum=char:FindFirstChildOfClass("Humanoid")local alive=tRoot and tHead and tHum and tHum.Health>0 if alive then local hl=espHighlightCache[plr]if not hl or not hl.Parent or hl.Parent~=char then if hl then pcall(function()hl:Destroy()end)end hl=Instance.new("Highlight")hl.Name="KillHubESP"hl.FillColor=Color3.fromRGB(230,230,230)hl.FillTransparency=0.72 hl.OutlineColor=Color3.fromRGB(230,230,230)hl.OutlineTransparency=0.05 hl.Adornee=char hl.Parent=char espHighlightCache[plr]=hl end local lines=espTracerCache[plr]if not lines then lines=makeESPTracers()espTracerCache[plr]=lines or{}end if lines and#lines>0 then local destPos=tRoot.Position local pos,onScreen=camera:WorldToViewportPoint(destPos)if onScreen and pos.Z>0 and myOnScreen then local tVec=Vector2.new(pos.X,pos.Y)for _,ln in ipairs(lines)do ln.From=myVec ln.To=tVec ln.Visible=true end else for _,ln in ipairs(lines)do ln.Visible=false end end end else if espHighlightCache[plr]then pcall(function()espHighlightCache[plr]:Destroy()end)espHighlightCache[plr]=nil end if espTracerCache[plr]then for _,ln in ipairs(espTracerCache[plr])do pcall(function()ln.Visible=false end)end end end end end local function startESPLoop()if _G.KillHub.Connections.esp then return end _G.KillHub.Active.esp=true _G.KillHub.Connections.esp=RunService.RenderStepped:Connect(updateESP)end local function stopESPLoop()_G.KillHub.Active.esp=false if _G.KillHub.Connections.esp then _G.KillHub.Connections.esp:Disconnect()_G.KillHub.Connections.esp=nil end clearESP()end function toggleESP(on)espEnabled=on if on then startESPLoop()else stopESPLoop()end if setESPVIsual then setESPVIsual(on)end end local function getClosestTarget()local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")if not root then return nil end local myPos=root.Position local closest,minDist=nil,math.huge for _,plr in ipairs(Players:GetPlayers())do if plr~=LP then local char=plr.Character if char then local tRoot=char:FindFirstChild("HumanoidRootPart")local hum=char:FindFirstChildOfClass("Humanoid")if tRoot and hum and hum.Health>0 then local dist=(tRoot.Position-myPos).Magnitude if dist<minDist then minDist=dist closest=tRoot end end end end end return closest end local function getClosestTargetBody()return getClosestTarget()end local function _bodyLockTick() if dropActive or _G.IsDropping then return end local char=LP.Character if not char then return end local root=char:FindFirstChild("HumanoidRootPart")if not root then return end local hum=char:FindFirstChildOfClass("Humanoid")if not hum then return end local target=getClosestTargetBody()if not target then if not hum.AutoRotate then hum.AutoRotate=true end return end local dist=(target.Position-root.Position).Magnitude if dist>bodyLockRange then if not hum.AutoRotate then hum.AutoRotate=true end return end if hum.AutoRotate then hum.AutoRotate=false end local targetVel=target.AssemblyLinearVelocity local speed3=targetVel.Magnitude local predictTime=math.clamp(speed3/80,0.08,0.35)local predictedPos=target.Position+targetVel*predictTime local targetHead=target.Parent and target.Parent:FindFirstChild("Head")local targetHeight=targetHead and targetHead.Position.Y or target.Position.Y local myHeight=root.Position.Y+(hum.HipHeight or 0)local heightDiff=targetHeight-myHeight local verticalCorrection=math.clamp(heightDiff*0.15,-1.5,1.5)local flatTarget=Vector3.new(predictedPos.X,root.Position.Y+verticalCorrection,predictedPos.Z)local toPredict=flatTarget-root.Position if toPredict.Magnitude>0.1 then local goalCF=CFrame.lookAt(root.Position,flatTarget)local diffCF=root.CFrame:Inverse()*goalCF local _,ry,_=diffCF:ToEulerAnglesXYZ()ry=math.clamp(ry,-2.5,2.5)root.AssemblyAngularVelocity=root.CFrame:VectorToWorldSpace(Vector3.new(0,ry*42,0))end end function startBodyLock()if _G.KillHub.Connections.bodyLock then return end bodyLockEnabled=true _G.KillHub.Active.bodyLock=true _G.KillHub.Connections.bodyLock=RunService.RenderStepped:Connect(function()if not bodyLockEnabled then return end if _blSuppressCount>0 then return end _bodyLockTick()end)if bodyLockSetVisual then bodyLockSetVisual(true)end return true end function stopBodyLock()bodyLockEnabled=false _G.KillHub.Active.bodyLock=false if _G.KillHub.Connections.bodyLock then _G.KillHub.Connections.bodyLock:Disconnect()_G.KillHub.Connections.bodyLock=nil end local c=LP.Character local root=c and c:FindFirstChild("HumanoidRootPart")if root then root.AssemblyAngularVelocity=Vector3.zero root.AssemblyLinearVelocity=Vector3.new(root.AssemblyLinearVelocity.X,-0.1,root.AssemblyLinearVelocity.Z)end local hum2=c and c:FindFirstChildOfClass("Humanoid")if hum2 then hum2.AutoRotate=true end if bodyLockSetVisual then bodyLockSetVisual(false)end end function _suppressBodyLock()_blSuppressCount=_blSuppressCount+1 if _blSuppressCount==1 and bodyLockEnabled then _blWasEnabled=true stopBodyLock()bodyLockEnabled=true if bodyLockSetVisual then bodyLockSetVisual(false)end if _blRestoreTimer then task.cancel(_blRestoreTimer)_blRestoreTimer=nil end _blSmoothRestore=false end end function _unsuppressBodyLock(delayed)if _blSuppressCount>0 then _blSuppressCount=_blSuppressCount-1 end if _blSuppressCount==0 and _blWasEnabled then _blWasEnabled=false local function restore()if bodyLockEnabled then _blSmoothRestore=true startBodyLock()if bodyLockSetVisual then bodyLockSetVisual(true)end task.delay(0.5,function()_blSmoothRestore=false end)end _blRestoreTimer=nil end if delayed then _blRestoreTimer=task.delay(1,restore)else restore()end end end function setupSpeedIndicator(char)local head=char:WaitForChild("Head",5)if not head then return end local oldBB=head:FindFirstChild("KillHubSpeedIndicator")if oldBB then oldBB:Destroy()end local bb=Instance.new("BillboardGui",head)bb.Name="KillHubSpeedIndicator"bb.Size=UDim2.new(0,200,0,70)bb.StudsOffset=Vector3.new(0,2.0,0)bb.AlwaysOnTop=true local mainFrame=Instance.new("Frame",bb)mainFrame.Size=UDim2.new(1,0,1,0)mainFrame.BackgroundTransparency=1 local titleLabel=Instance.new("TextLabel",mainFrame)titleLabel.Size=UDim2.new(1,-42,0,22)titleLabel.Position=UDim2.new(0,21,0,0)titleLabel.BackgroundTransparency=1 titleLabel.Text="I LOVE /candy-hub"titleLabel.TextColor3=Color3.fromRGB(255,255,255)titleLabel.Font=Enum.Font.GothamBold titleLabel.TextScaled=false titleLabel.TextSize=16 titleLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)titleLabel.TextStrokeTransparency=0.18 titleLabel.TextXAlignment=Enum.TextXAlignment.Center titleLabel:SetAttribute("FearThemeRole","StealText")local fearHubGradient=Instance.new("UIGradient",titleLabel)fearHubGradient:SetAttribute("FearThemeRole","BlackAccentGradient")fearHubGradient.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(0,0,0)),ColorSequenceKeypoint.new(0.42,Color3.fromRGB(125,125,125)),ColorSequenceKeypoint.new(0.72,Color3.fromRGB(235,235,235)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(255,255,255))})fearHubGradient.Rotation=0 local separator=Instance.new("Frame",mainFrame)separator.Size=UDim2.new(0.5,0,0,2)separator.Position=UDim2.new(0.25,0,0,24)separator.BackgroundColor3=Color3.fromRGB(145,150,160)separator.BackgroundTransparency=0.3 separator.BorderSizePixel=0 separator:SetAttribute("FearThemeRole","SpeedSeparator")local grad=Instance.new("UIGradient",separator)grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(145,150,160)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(198,202,210)),ColorSequenceKeypoint.new(1,Color3.fromRGB(145,150,160))})grad.Rotation=0 speedLabel=Instance.new("TextLabel",mainFrame)speedLabel.Size=UDim2.new(1,0,0,22)speedLabel.Position=UDim2.new(0,0,0,30)speedLabel.BackgroundTransparency=1 speedLabel.Text="NORMAL:"..tostring(NS)speedLabel.TextColor3=Color3.fromRGB(145,150,160)speedLabel.Font=Enum.Font.GothamBold speedLabel.TextScaled=true speedLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)speedLabel.TextStrokeTransparency=0 speedLabel.TextXAlignment=Enum.TextXAlignment.Center speedLabel:SetAttribute("FearThemeRole","SpeedText")local speedTextGradient=Instance.new("UIGradient",speedLabel)speedTextGradient:SetAttribute("FearThemeRole","BlackAccentGradient")uiVisual.refreshTheme(bb)end function updateEnemySpeedLabels()for _,player in ipairs(Players:GetPlayers())do if player~=LP then local char=player.Character if char and char:FindFirstChild("HumanoidRootPart")and char:FindFirstChildOfClass("Humanoid")and char:FindFirstChildOfClass("Humanoid").Health>0 then local hrp=char:FindFirstChild("HumanoidRootPart")local velocity=hrp.AssemblyLinearVelocity local speed=(Vector3.new(velocity.X,0,velocity.Z).Magnitude)local label=enemySpeedLabels[player]if not label then local head=char:FindFirstChild("Head")if head then local bb=Instance.new("BillboardGui",head)bb.Size=UDim2.new(0,100,0,25)bb.StudsOffset=Vector3.new(0,3.5,0)bb.AlwaysOnTop=true bb.Name="EnemySpeedGui"local textLabel=Instance.new("TextLabel",bb)textLabel.Size=UDim2.new(1,0,1,0)textLabel.BackgroundTransparency=1 textLabel.Text=string.format("%.1f",speed)textLabel.TextColor3=Color3.fromRGB(230,230,230)textLabel:SetAttribute("FearThemeRole","SpeedText")local enemyTextGradient=Instance.new("UIGradient",textLabel)enemyTextGradient:SetAttribute("FearThemeRole","BlackAccentGradient")textLabel.Font=Enum.Font.GothamBold textLabel.TextScaled=true textLabel.TextStrokeTransparency=0 textLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)label=textLabel enemySpeedLabels[player]=label uiVisual.refreshTheme(textLabel)end elseif label and label.Parent and label.Parent.Parent~=char then local head=char:FindFirstChild("Head")if head then label.Parent.Parent=head end end if label then label.Text=string.format("%.1f",speed)end else local label=enemySpeedLabels[player]if label and label.Parent and label.Parent.Parent then label.Parent.Parent=nil end enemySpeedLabels[player]=nil end end end for player,label in pairs(enemySpeedLabels)do if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart")then if label and label.Parent and label.Parent.Parent then label.Parent.Parent=nil end enemySpeedLabels[player]=nil end end end function startEnemySpeed()if _G.KillHub.Connections.enemySpeed then return end _G.KillHub.Connections.enemySpeed=RunService.Heartbeat:Connect(function()updateEnemySpeedLabels()end)end function stopEnemySpeed()if _G.KillHub.Connections.enemySpeed then _G.KillHub.Connections.enemySpeed:Disconnect()_G.KillHub.Connections.enemySpeed=nil end end 
local function syncSpeedModeState()
    if laggerToggled then
        speedMode = false
        laggerLevel = (tonumber(laggerLevel) == 2) and 2 or 1
    end
    CarrySystem.speedToggled = speedMode == true
    CarrySystem:setLaggerMode(laggerToggled and laggerLevel or 0)
end
function refreshSpeedModeLabel()if modeValLbl then if laggerToggled then modeValLbl.Text=laggerLevel==1 and"Lagger Normal"or"Lagger Carry"elseif speedMode then modeValLbl.Text="Carry"else modeValLbl.Text="Normal"end end end 
function resetMovementState() uiVisual.syncMovementSpeeds();syncSpeedModeState()refreshSpeedModeLabel()if mobSetCarry then mobSetCarry(speedMode)end if mobSetLagger1 then mobSetLagger1(laggerToggled and laggerLevel==1)end if mobSetLagger2 then mobSetLagger2(laggerToggled and laggerLevel==2)end end
 
function toggleCarryMode()
    if laggerToggled then
        laggerToggled = false
        laggerLevel = 1
        speedMode = true
    else
        speedMode = not speedMode
        if speedMode then
            laggerToggled = false
            laggerLevel = 1
        end
    end
    syncSpeedModeState()
    resetMovementState()
end
 
function toggleLaggerCycle()
    if speedMode then
        speedMode = false
        if mobSetCarry then mobSetCarry(false) end
    end
    if not laggerToggled then
        laggerToggled = true
        laggerLevel = 1
    else
        laggerLevel = (laggerLevel == 1) and 2 or 1
    end
    syncSpeedModeState()
    resetMovementState()
end
 
function stopAutoLeft()
    if _G.KillHub.Connections.autoLeft then
        _G.KillHub.Connections.autoLeft:Disconnect()
        _G.KillHub.Connections.autoLeft = nil
    end
    _G.KillHub.Active.autoLeft = false
    alPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if hum then hum:Move(Vector3.zero, false) end
        if root and _G.__K7_111VelocityIdle then _G.__K7_111VelocityIdle(root) end
    end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobSetAutoLeft then mobSetAutoLeft(false) end
    _unsuppressBodyLock(true)
end

function startAutoLeft()
    if _G.KillHub.Connections.autoLeft then return end
    if autoRightEnabled then
        autoRightEnabled = false
        stopAutoRight()
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobSetAutoRight then mobSetAutoRight(false) end
    end

    disableAllAimbots()
    _suppressBodyLock()
    _G.KillHub.Active.autoLeft = true
    alPhase = 1

    _G.KillHub.Connections.autoLeft = RunService.Heartbeat:Connect(function() if dropActive or _G.IsDropping then return end 
        if not autoLeftEnabled then return end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return end

        local spd = NS

        if alPhase == 1 then
            local tgt = Vector3.new(AP.L1.X, root.Position.Y, AP.L1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                alPhase = 2
                local d = AP.L2 - root.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                _G.__K7_111Velocity(root, mv, spd)
                return
            end

            local d = AP.L1 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            _G.__K7_111Velocity(root, mv, spd)

        elseif alPhase == 2 then
            local tgt = Vector3.new(AP.L2.X, root.Position.Y, AP.L2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
                if _G.__K7_111VelocityIdle then _G.__K7_111VelocityIdle(root) end

                autoLeftEnabled = false
                if _G.KillHub.Connections.autoLeft then
                    _G.KillHub.Connections.autoLeft:Disconnect()
                    _G.KillHub.Connections.autoLeft = nil
                end
                _G.KillHub.Active.autoLeft = false
                alPhase = 1
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if mobSetAutoLeft then mobSetAutoLeft(false) end
                _unsuppressBodyLock(true)

                local facePos = Vector3.new(AP.L_FACE.X, root.Position.Y, AP.L_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = CFrame.new(root.Position, facePos)
                end
                return
            end

            local d = AP.L2 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            _G.__K7_111Velocity(root, mv, spd)
        end
    end)

    if autoLeftSetVisual then autoLeftSetVisual(true) end
    if mobSetAutoLeft then mobSetAutoLeft(true) end
end

function stopAutoRight()
    if _G.KillHub.Connections.autoRight then
        _G.KillHub.Connections.autoRight:Disconnect()
        _G.KillHub.Connections.autoRight = nil
    end
    _G.KillHub.Active.autoRight = false
    arPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if hum then hum:Move(Vector3.zero, false) end
        if root and _G.__K7_111VelocityIdle then _G.__K7_111VelocityIdle(root) end
    end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobSetAutoRight then mobSetAutoRight(false) end
    _unsuppressBodyLock(true)
end

function startAutoRight()
    if _G.KillHub.Connections.autoRight then return end
    if autoLeftEnabled then
        autoLeftEnabled = false
        stopAutoLeft()
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobSetAutoLeft then mobSetAutoLeft(false) end
    end

    disableAllAimbots()
    _suppressBodyLock()
    _G.KillHub.Active.autoRight = true
    arPhase = 1

    _G.KillHub.Connections.autoRight = RunService.Heartbeat:Connect(function() if dropActive or _G.IsDropping then return end 
        if not autoRightEnabled then return end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return end

        local spd = NS

        if arPhase == 1 then
            local tgt = Vector3.new(AP.R1.X, root.Position.Y, AP.R1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                arPhase = 2
                local d = AP.R2 - root.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                _G.__K7_111Velocity(root, mv, spd)
                return
            end

            local d = AP.R1 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            _G.__K7_111Velocity(root, mv, spd)

        elseif arPhase == 2 then
            local tgt = Vector3.new(AP.R2.X, root.Position.Y, AP.R2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
                if _G.__K7_111VelocityIdle then _G.__K7_111VelocityIdle(root) end

                autoRightEnabled = false
                if _G.KillHub.Connections.autoRight then
                    _G.KillHub.Connections.autoRight:Disconnect()
                    _G.KillHub.Connections.autoRight = nil
                end
                _G.KillHub.Active.autoRight = false
                arPhase = 1
                if autoRightSetVisual then autoRightSetVisual(false) end
                if mobSetAutoRight then mobSetAutoRight(false) end
                _unsuppressBodyLock(true)

                local facePos = Vector3.new(AP.R_FACE.X, root.Position.Y, AP.R_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = CFrame.new(root.Position, facePos)
                end
                return
            end

            local d = AP.R2 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            _G.__K7_111Velocity(root, mv, spd)
        end
    end)

    if autoRightSetVisual then autoRightSetVisual(true) end
    if mobSetAutoRight then mobSetAutoRight(true) end
end
;(function()local RT={active=false,previous=nil,conn=nil,spots={},nextScan=0,armed=true,latched=false,held=false,}local function ignoredTool(name)local n=tostring(name or""):lower()return n:find("bat")or n:find("slap")or n:find("medusa")or n:find("head")or n:find("stone")end local function isCarrying(char)if not char then return false end if LP:GetAttribute("Stealing")==true or LP:GetAttribute("AntiKick")==true or char:GetAttribute("Stealing")==true then return true end for _,child in ipairs(char:GetChildren())do if child:IsA("Tool")and not ignoredTool(child.Name)then return true end if child:IsA("Model")then local n=child.Name:lower()if n:find("brainrot")or n:find("animal")or n:find("carry")or n:find("grab")or n:find("steal")or n:find("hold")then return true end end end return false end local function refreshSpeed()resetMovementState()if refreshSpeedModeLabel then pcall(refreshSpeedModeLabel)end if mobSetCarry then pcall(mobSetCarry,speedMode==true)end end local function enableCarry()if RT.active then return end RT.previous={speedMode=speedMode,laggerToggled=laggerToggled,laggerLevel=laggerLevel,}RT.active=true laggerToggled=false laggerLevel=1 speedMode=true refreshSpeed()end local function disableCarry()if not RT.active then return end local prev=RT.previous RT.active=false RT.previous=nil if prev then speedMode=prev.speedMode==true laggerToggled=prev.laggerToggled==true laggerLevel=prev.laggerLevel or 1 else speedMode=false end refreshSpeed()end local function scanSpots()local spots={}local plots=workspace:FindFirstChild("Plots")if plots then for _,plot in ipairs(plots:GetChildren())do local sign=plot:FindFirstChild("PlotSign")local yourBase=sign and sign:FindFirstChild("YourBase")local mine=yourBase and yourBase:IsA("BillboardGui")and yourBase.Enabled==true if not mine then local podiums=plot:FindFirstChild("AnimalPodiums")if podiums then for _,podium in ipairs(podiums:GetChildren())do local base=podium:FindFirstChild("Base")local spawnPart=base and base:FindFirstChild("Spawn")if spawnPart then table.insert(spots,spawnPart.Position)end end end end end end RT.spots=spots end local function inSoftRange(char)local root=char and char:FindFirstChild("HumanoidRootPart")if not root then return false end local now=tick()if now>=RT.nextScan then RT.nextScan=now+0.5 scanSpots()end local range=tonumber(_G.M4AutoSpeedRange)or 15 for _,spot in ipairs(RT.spots)do if(root.Position-spot).Magnitude<=range then return true end end return false end _G.M4AutoSpeedStart=function()if RT.conn then pcall(function()RT.conn:Disconnect()end)RT.conn=nil end RT.conn=RunService.RenderStepped:Connect(function()if _G.M4AutoSpeedEnabled~=true then disableCarry()return end if autoLeftEnabled or autoRightEnabled then disableCarry()speedMode=false laggerToggled=false laggerLevel=1 refreshSpeed()return end local char=LP.Character local hum=char and char:FindFirstChildOfClass("Humanoid")if not char or not hum or hum.Health<=0 then disableCarry()return end if _G.M4AutoSpeedMode=="Soft Steal"then local inRange=inSoftRange(char)local carrying=isCarrying(char)if not inRange then RT.armed=true end if not inRange then RT.latched=false end if inRange and RT.armed and not RT.latched then RT.latched=true RT.held=false enableCarry()end if RT.active then if carrying then RT.held=true elseif RT.held then RT.held=false RT.armed=false RT.latched=false disableCarry()elseif not inRange then disableCarry()end end return end if isCarrying(char)then enableCarry()else disableCarry()end end)return true end _G.M4AutoSpeedStop=function()if RT.conn then pcall(function()RT.conn:Disconnect()end)RT.conn=nil end RT.armed=true RT.latched=false RT.held=false disableCarry()end _G.M4LwareAutoCarrySpeed={Start=_G.M4AutoSpeedStart,Stop=_G.M4AutoSpeedStop,IsCarrying=isCarrying,}end)()
-- BLESS AUTO SPIN: Confuser integrado, solo mientras se carga un brainrot.
do
    local old = rawget(_G, "__BlessAutoSpin")
    if type(old) == "table" and type(old.Shutdown) == "function" then old.Shutdown() end
    local S = {
        enabled = false, running = false, antiDieOwned = false,
        angle = 0, pitch = 0, roll = 0, yawSway = 0,
        time = 0, nextChange = 0, rate = 1, targetRate = 1, direction = 1,
        random = Random.new(), turnsPerSecond = 3,
    }
    _G.__BlessAutoSpin = S
    _G.BlessAutoSpinEnabled = _G.BlessAutoSpinEnabled == true
    local TAU = math.pi * 2
    local RENDER_BIND = "BlessAutoSpin_Rotation"
    local paused = {
        [Enum.HumanoidStateType.Dead] = true,
        [Enum.HumanoidStateType.Seated] = true,
        [Enum.HumanoidStateType.Ragdoll] = true,
        [Enum.HumanoidStateType.FallingDown] = true,
        [Enum.HumanoidStateType.Physics] = true,
        [Enum.HumanoidStateType.Climbing] = true,
        [Enum.HumanoidStateType.Swimming] = true,
    }

    function S.ReleaseRotation(upright)
        local hum, root = S.humanoid, S.root
        if upright and root and root.Parent and hum and hum.Parent
            and hum.Health > 0 and not hum.PlatformStand and not hum.Sit
            and not paused[hum:GetState()] then
            pcall(function()
                root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, S.angle + S.yawSway, 0)
            end)
        end
        if hum and hum.Parent then pcall(function() hum.AutoRotate = S.savedAutoRotate end) end
        S.humanoid, S.root, S.savedAutoRotate = nil, nil, nil
    end

    function S.ArmAntiDie()
        if antiDieEnabled ~= true then
            S.antiDieOwned = true
            startAntiDie()
            if S.character then _activateFantaAntiDie(S.character) end
        end
    end

    function S.Stop()
        S.ReleaseRotation(true)
        S.running, S.character, S.yawRoot = false, nil, nil
        if _G.KillHub and _G.KillHub.Active then _G.KillHub.Active.autoSpin = false end
        local owned = S.antiDieOwned
        S.antiDieOwned = false
        if owned then
            local float = rawget(_G, "__BlessFloat")
            if type(float) == "table" and float.running then
                float.antiDieOwned = true
            else
                stopAntiDie()
            end
        end
    end

    function S.Start(char)
        S.running, S.character, S.yawRoot = true, char, nil
        S.time, S.nextChange = 0, 0
        S.rate, S.targetRate, S.direction = 1, 1, 1
        S.pitch, S.roll, S.yawSway = 0, 0, 0
        S.seed = S.random:NextNumber(-100, 100)
        if _G.KillHub and _G.KillHub.Active then _G.KillHub.Active.autoSpin = true end
        S.ArmAntiDie()
    end

    function S.Rotate(dt)
        if not S.running or LP.Character ~= S.character then return end
        local char = S.character
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end
        if root.Anchored or hum.Sit or hum.PlatformStand or paused[hum:GetState()] then
            S.ReleaseRotation(false)
            return
        end
        if hum ~= S.humanoid then
            S.ReleaseRotation(false)
            S.humanoid, S.savedAutoRotate = hum, hum.AutoRotate
        end
        S.root = root
        if root ~= S.yawRoot then
            local look = root.CFrame.LookVector
            S.angle = math.atan2(-look.X, -look.Z)
            S.yawRoot = root
        end
        hum.AutoRotate = false
        if dt then
            local step = math.clamp(dt, 0, 0.1)
            S.time = S.time + step
            if S.time >= S.nextChange then
                if S.random:NextNumber() < 0.28 then S.direction = -S.direction end
                S.targetRate = S.direction * S.random:NextNumber(0.4, 1.38)
                S.nextChange = S.time + S.random:NextNumber(0.22, 0.48)
            end
            S.rate = S.rate + (S.targetRate - S.rate) * (1 - math.exp(-step * 11))
            S.angle = (S.angle + TAU * S.turnsPerSecond * S.rate * step) % TAU
            local blend = 1 - math.exp(-S.time * 8)
            S.pitch = blend * (math.sin(S.time * 5.1 + S.seed) * math.rad(7)
                + math.sin(S.time * 9.7) * math.rad(2))
            S.roll = blend * (math.sin(S.time * 6.7 + S.seed * 0.5) * math.rad(11)
                + math.sin(S.time * 3.3) * math.rad(4))
            S.yawSway = blend * (math.sin(S.time * 4.3 + S.seed) * math.rad(7)
                + math.sin(S.time * 8.2) * math.rad(2))
        end
        -- Solo orientacion de la raiz real; conserva posicion, caminar y salto.
        root.CFrame = CFrame.new(root.Position)
            * CFrame.Angles(0, S.angle + S.yawSway, 0)
            * CFrame.Angles(S.pitch, 0, S.roll)
    end

    function S.Step(dt)
        if not S.enabled then return end
        local char = LP.Character
        local detector = _G.M4LwareAutoCarrySpeed
        local carrying = false
        if char and detector and type(detector.IsCarrying) == "function" then
            local ok, value = pcall(detector.IsCarrying, char)
            carrying = ok and value == true
        end
        if not carrying or dropActive or _G.IsDropping then
            if S.running then S.Stop() end
            return
        end
        if S.running and S.character ~= char then S.Stop() end
        if not S.running then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            if not hum or hum.Health <= 0 or not root then return end
            S.Start(char)
        end
        S.ArmAntiDie()
        S.Rotate(dt)
    end

    function S.Boot()
        if not S.stepConn then S.stepConn = RunService.PreSimulation:Connect(S.Step) end
        if not S.charConn then S.charConn = LP.CharacterRemoving:Connect(function() S.Stop() end) end
        if not S.renderBound then
            RunService:UnbindFromRenderStep(RENDER_BIND)
            RunService:BindToRenderStep(RENDER_BIND, Enum.RenderPriority.Character.Value + 1, function()
                S.Rotate(nil)
            end)
            S.renderBound = true
        end
    end

    function S.Shutdown()
        S.enabled = false
        S.Stop()
        if S.stepConn then S.stepConn:Disconnect(); S.stepConn = nil end
        if S.charConn then S.charConn:Disconnect(); S.charConn = nil end
        if S.renderBound then RunService:UnbindFromRenderStep(RENDER_BIND); S.renderBound = false end
    end

    function S.SetEnabled(value)
        S.enabled = value == true
        _G.BlessAutoSpinEnabled = S.enabled
        if S.enabled then S.Boot(); S.Step(0) else S.Shutdown() end
        if S.setVisual then S.setVisual(S.enabled) end
    end
end
-- FIN BLESS AUTO SPIN

local function _111FindBat()local char=LP.Character if not char then return nil end for _,tool in ipairs(char:GetChildren())do if tool:IsA("Tool")and(tool.Name:lower():find("bat")or tool.Name:lower():find("slap"))then return tool end end local bp=LP:FindFirstChildOfClass("Backpack")if bp then for _,tool in ipairs(bp:GetChildren())do if tool:IsA("Tool")and(tool.Name:lower():find("bat")or tool.Name:lower():find("slap"))then return tool end end end return nil end local function _111ClosestRoot()local myRoot=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")if not myRoot then return nil end local best,bestDist=nil,math.huge for _,plr in ipairs(Players:GetPlayers())do if plr~=LP and plr.Character then local tr=plr.Character:FindFirstChild("HumanoidRootPart")local th=plr.Character:FindFirstChildOfClass("Humanoid")if tr and th and th.Health>0 then local d=(tr.Position-myRoot.Position).Magnitude if d<bestDist then bestDist=d best=tr end end end end return best end _G.KillHub.BlessAimbotState=_G.KillHub.BlessAimbotState or{hittingCooldown=false,prevAutoRotate=nil,batNames={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}}function _fearBlessGetBat()local char=LP.Character if not char then return nil end for _,name in ipairs(_G.KillHub.BlessAimbotState.batNames)do local t=char:FindFirstChild(name)if t and t:IsA("Tool")then return t end end local bp=LP:FindFirstChildOfClass("Backpack")if bp then for _,name in ipairs(_G.KillHub.BlessAimbotState.batNames)do local t=bp:FindFirstChild(name)if t and t:IsA("Tool")then local hum=char:FindFirstChildOfClass("Humanoid")if hum then pcall(function()hum:EquipTool(t)end)end return t end end end for _,ch in ipairs(char:GetChildren())do if ch:IsA("Tool")and(ch.Name:lower():find("bat")or ch.Name:lower():find("slap"))then return ch end end if bp then for _,ch in ipairs(bp:GetChildren())do if ch:IsA("Tool")and(ch.Name:lower():find("bat")or ch.Name:lower():find("slap"))then local hum=char:FindFirstChildOfClass("Humanoid")if hum then pcall(function()hum:EquipTool(ch)end)end return ch end end end return nil end function _fearBlessTrySwing()if _G.KillHub.BlessAimbotState.hittingCooldown then return end _G.KillHub.BlessAimbotState.hittingCooldown=true pcall(function()local char=LP.Character if char then local bat=_fearBlessGetBat()if bat then if bat.Parent~=char then local hum=char:FindFirstChildOfClass("Humanoid")if hum then pcall(function()hum:EquipTool(bat)end)end end pcall(function()bat:Activate()end)end end end)task.delay(0.35,function()if _G.KillHub and _G.KillHub.BlessAimbotState then _G.KillHub.BlessAimbotState.hittingCooldown=false end end)end function _fearBlessGetClosestPlayerAimbot()local char=LP.Character if not char then return nil,math.huge end local hrp=char:FindFirstChild("HumanoidRootPart")if not hrp then return nil,math.huge end local closest,dist=nil,math.huge for _,p in ipairs(Players:GetPlayers())do if p~=LP and p.Character then local tr=p.Character:FindFirstChild("HumanoidRootPart")local ph=p.Character:FindFirstChildOfClass("Humanoid")if tr and ph and ph.Health>0 then local d=(hrp.Position-tr.Position).Magnitude if d<dist then dist=d;closest=p end end end end return closest,dist end function _fearMessageFindBat()local char=LP.Character if not char then return nil end for _,tool in ipairs(char:GetChildren())do if tool:IsA("Tool")and(tool.Name:lower():find("bat")or tool.Name:lower():find("slap"))then return tool end end return nil end function _fearMessageClosestEnemy()local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")if not root then return nil end local closest,minDist=nil,math.huge for _,plr in ipairs(Players:GetPlayers())do if plr~=LP and plr.Character then local tRoot=plr.Character:FindFirstChild("HumanoidRootPart")local hum=plr.Character:FindFirstChildOfClass("Humanoid")if tRoot and hum and hum.Health>0 then local dist=(tRoot.Position-root.Position).Magnitude if dist<minDist then minDist=dist closest=tRoot end end end end return closest end function _fearGoodFindBat()local c=LP.Character if not c then return nil end local bp=LP:FindFirstChildOfClass("Backpack")for _,ch in ipairs(c:GetChildren())do if ch:IsA("Tool")and(ch.Name:lower():find("bat")or ch.Name:lower():find("slap"))then return ch end end if bp then for _,ch in ipairs(bp:GetChildren())do if ch:IsA("Tool")and(ch.Name:lower():find("bat")or ch.Name:lower():find("slap"))then return ch end end end for _,name in ipairs({"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"})do local t=c:FindFirstChild(name)or(bp and bp:FindFirstChild(name))if t then return t end end return nil end function _fearGoodTargetValid(tc)if not tc or not tc.Parent then return false end local hum=tc:FindFirstChildOfClass("Humanoid")local hrp2=tc:FindFirstChild("HumanoidRootPart")return hum~=nil and hrp2~=nil end function _fearGoodGetTarget(myHRP)_G.FearGoodAimbotState=_G.FearGoodAimbotState or{}local st=_G.FearGoodAimbotState if st.lockedTarget and not _fearGoodTargetValid(st.lockedTarget)then st.lockedTarget=nil end if st.lockedTarget then return st.lockedTarget:FindFirstChild("HumanoidRootPart"),st.lockedTarget end local best,bestDist=nil,math.huge for _,p in ipairs(Players:GetPlayers())do if p~=LP and _fearGoodTargetValid(p.Character)then local tHRP=p.Character:FindFirstChild("HumanoidRootPart")local d=(tHRP.Position-myHRP.Position).Magnitude if d<bestDist then bestDist=d best=p.Character end end end st.lockedTarget=best return best and best:FindFirstChild("HumanoidRootPart"),best end function _fearGoodActivateAntiDie()_G.FearGoodAimbotState=_G.FearGoodAimbotState or{}local st=_G.FearGoodAimbotState st.antiDieConns=st.antiDieConns or{}for _,c in ipairs(st.antiDieConns)do pcall(function()c:Disconnect()end)end st.antiDieConns={}local char=LP.Character local hum=char and char:FindFirstChildOfClass("Humanoid")if not hum then return end hum.BreakJointsOnDeath=false hum:SetStateEnabled(Enum.HumanoidStateType.Dead,false)table.insert(st.antiDieConns,hum:GetPropertyChangedSignal("Health"):Connect(function()if hum.Health<=0 then hum.Health=hum.MaxHealth end end))end function _fearGoodIsHoldingBrainrot()local char=LP.Character if not char then return false end for _,obj in ipairs(char:GetChildren())do if obj:IsA("Tool")then local n=obj.Name:lower()if not n:find("bat")and not n:find("slap")and not n:find("medusa")then return true end end end return false end function _fearGoodDropBrainrot() return runDropBrainrot() end 
function getClosestTargetForAimbot()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = tRoot
                end
            end
        end
    end
    return closest
end

function trySwing()
    pcall(function()
        local char = LP.Character
        if not char then return end
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and not isBatTool(currentTool) then return end
        local bat = findBat()
        if bat then
            if bat.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            pcall(function() bat:Activate() end)
        end
    end)
end

function stopAimbotAdapt()
    if _G.KillHub.Connections.aimbot then
        _G.KillHub.Connections.aimbot:Disconnect()
        _G.KillHub.Connections.aimbot = nil
    end

    _G.KillHub.Active.autoBat = false
    autoBatEnabled = false

    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if root then
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.3
        root.AssemblyAngularVelocity = Vector3.zero
        if _G.__K7_111VelocityIdle then _G.__K7_111VelocityIdle(root) end
    end
    if hum then
        hum.AutoRotate = true
        hum.PlatformStand = false
    end

    _prevAutoRotate = nil
    lastMoveDir = Vector3.zero
    _unsuppressBodyLock(true)

    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
end

function startAimbotAdapt()
    if _G.KillHub.Connections.aimbot then return end

    _suppressBodyLock()
    _G.KillHub.Active.autoBat = true
    autoBatEnabled = true

    local oldTarget = nil
    local oldLastScan = 0

    _G.KillHub.Connections.aimbot = RunService.Heartbeat:Connect(function() if dropActive or _G.IsDropping then return end 
        if not autoBatEnabled then return end

        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not root or not hum or hum.Health <= 0 then return end

        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end

        local now = tick()
        if now - oldLastScan > 0.1 or not oldTarget or not oldTarget.Parent then
            oldLastScan = now
            oldTarget = getClosestTargetForAimbot()
        else
            local th = oldTarget.Parent and oldTarget.Parent:FindFirstChildOfClass("Humanoid")
            if not th or th.Health <= 0 then oldTarget = nil end
        end

        local target = oldTarget
        if not target then
            hum.AutoRotate = true
            root.AssemblyAngularVelocity = Vector3.zero
            return
        end

        hum.AutoRotate = false

        local targetVel = target.AssemblyLinearVelocity
        local myPos = root.Position
        local targetPos = target.Position

        local predictPos = targetPos + targetVel * 0.14 + target.CFrame.LookVector * 0.3
        local direction = predictPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z)

        if flatDir.Magnitude > 0.01 then
            flatDir = flatDir.Unit
        else
            flatDir = Vector3.new(0, 0, 1)
        end

        local chaseSpeed = BAT_AIMBOT_SPEED
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8

        if hum.FloorMaterial ~= Enum.Material.Air then
            yVel = math.max(yVel, 13)
        end
        yVel = math.clamp(yVel, -70, 110)

        local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)

        local predictTime = math.clamp(targetVel.Magnitude / 150, 0.05, 0.2)
        local predictedPos = targetPos + targetVel * predictTime
        if (predictedPos - myPos).Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, predictedPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5)
            ry = math.clamp(ry, -2.5, 2.5)
            rz = math.clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity =
                root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42))
        end

        trySwing()
    end)

    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobSetAutoBat then mobSetAutoBat(true) end
end
 
do
    if type(_G.__BlessBatZCleanup) == "function" then pcall(_G.__BlessBatZCleanup)
    elseif type(_G.__BLESS_RivalStopBatV2) == "function" then pcall(_G.__BLESS_RivalStopBatV2) end
    _G.__BlessBatZCleanup = nil
    _G.__BLESS_RivalStartBatV2 = nil
    _G.__BLESS_RivalStopBatV2 = nil
    _G.__BLESS_RivalIsBatV2 = nil
end
-- Candy Bat Bypass: Kill versions 1 and 2.
local batV2Engine = "Rival"
local batV2RunningEngine = nil
uiVisual.batV2EngineButton = nil
uiVisual.batV2BodySuppressed = false

pcall(function()
    if type(_G.__CandyKillV1BatCleanup) == "function" then
        _G.__CandyKillV1BatCleanup()
    elseif type(_G.__CandyKillV1StopBatV2) == "function" then
        _G.__CandyKillV1StopBatV2()
    end
end)

_G.__CandyKillV1StartBatV2 = nil
_G.__CandyKillV1StopBatV2 = nil
_G.__CandyKillV1IsBatV2 = nil
_G.__CandyKillV1SetBatV2Speed = nil

do
local alive = true
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

local B2 = {
    FOLLOW_SPEED = 55,
    ACTIVATE_DISTANCE = 13,
    MIN_FOLLOW_DISTANCE = 1,
    PREDICTION_TIME = 0.22,
    PREDICT_AHEAD = 3,
    MAX_VELOCITY_CHANGE = 150,
    VELOCITY_SMOOTHING = 0.2,
    MAX_HORIZONTAL_VELOCITY = 80,
    SERVER_TICKRATE = 1/60,
    MIN_PING_COMPENSATION = 0.03,
    MAX_PING_COMPENSATION = 0.25,
    ACCELERATION_PREDICTION_WEIGHT = 0.3,
    DIRECTION_CHANGE_DETECTION_TIME = 0.12,
    QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
    GRAVITY = 196.2,
    AIR_CONTROL_FACTOR = 0.8,
    MIN_AIRBORNE_TIME = 0.08,
    SWING_COOLDOWN = 0.08,
}

local S = {
    enabled = false,
    generation = 0,
    humanoid = nil,
    conn = nil,
    targetPlayer = nil,
    lastTargetPos = nil,
    targetVelocity = Vector3.zero,
    smoothedVelocity = Vector3.zero,
    velocityHistory = {},
    accelerationHistory = {},
    aerialVelocityHistory = {},
    verticalVelocityHistory = {},
    previousDirection = nil,
    lastDirectionChangeTime = 0,
    airborneTime = 0,
    lastActivationTime = 0,
    currentPing = 0.1,
    realPingMs = 0,
    previousAutoRotate = nil,
    swingLocked = false,
    nextSwingAt = 0,
}

local function avg(list)
    if #list == 0 then return Vector3.zero end
    local sum = Vector3.zero
    for _, v in ipairs(list) do sum = sum + v end
    return sum / #list
end

local function push(list, value, maxSize)
    table.insert(list, value)
    if #list > maxSize then table.remove(list, 1) end
end

local function reset()
    S.targetPlayer = nil
    S.lastTargetPos = nil
    S.targetVelocity = Vector3.zero
    S.smoothedVelocity = Vector3.zero
    S.velocityHistory = {}
    S.accelerationHistory = {}
    S.aerialVelocityHistory = {}
    S.verticalVelocityHistory = {}
    S.previousDirection = nil
    S.airborneTime = 0
end

local function findBatV2Tool()
    local char = LP.Character
    if not char then return nil end
    local equipped = char:FindFirstChildOfClass("Tool")
    if equipped then
        local name = equipped.Name:lower()
        if name:find("bat") or name:find("slap") then return equipped end
    end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local name = tool.Name:lower()
                if name:find("bat") or name:find("slap") then return tool end
            end
        end
    end
    return nil
end

local function nearest(myRoot)
    local nearestPlayer, nearestDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local targetHum = player.Character:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHum and targetHum.Health > 0 then
                local dist = (targetRoot.Position - myRoot.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearestPlayer = player
                end
            end
        end
    end
    return nearestPlayer
end

local function face(myRoot, direction)
    if direction.Magnitude < 0.01 then return end
    local cross = myRoot.CFrame.LookVector:Cross(direction.Unit)
    local angle = math.asin(math.clamp(cross.Magnitude, -1, 1))
    myRoot.AssemblyAngularVelocity = cross.Magnitude > 0.01 and cross.Unit * angle * 80 or Vector3.zero
end

local function updatePingV2()
    local ok, ping = pcall(function()
        return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    if ok and type(ping) == "number" then S.realPingMs = math.floor(ping) end
    S.currentPing = math.clamp(S.realPingMs / 1000, B2.MIN_PING_COMPENSATION, B2.MAX_PING_COMPENSATION)
end

local function swing()
    local now = tick()
    if S.swingLocked or now < S.nextSwingAt then return end
    S.swingLocked = true
    local generation = S.generation
    S.nextSwingAt = now + B2.SWING_COOLDOWN
    pcall(function()
        local char = LP.Character
        if not char then return end
        local bat = findBatV2Tool()
        if not bat then return end
        if bat.Parent ~= char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:EquipTool(bat) end
        end
        bat:Activate()
        local remote = bat:FindFirstChildWhichIsA("RemoteEvent")
        if remote then remote:FireServer() end
    end)
    task.delay(B2.SWING_COOLDOWN, function()
        if alive and S.generation == generation then S.swingLocked = false end
    end)
end

local function restoreHumanoid()
    if S.humanoid and S.previousAutoRotate ~= nil then
        pcall(function() S.humanoid.AutoRotate = S.previousAutoRotate end)
    end
    S.humanoid = nil
    S.previousAutoRotate = nil
end

local function trackHumanoid(humanoid)
    if S.humanoid ~= humanoid then
        restoreHumanoid()
        S.humanoid = humanoid
        S.previousAutoRotate = humanoid.AutoRotate
        reset()
    end
    humanoid.AutoRotate = false
end

local function loop(dt)
    if not alive or not S.enabled then return end
    local char = LP.Character
    if not char then return end
    local myRoot = char:FindFirstChild("HumanoidRootPart")
    local myHum = char:FindFirstChildOfClass("Humanoid")
    if not myRoot or not myHum or myHum.Health <= 0 then return end

    trackHumanoid(myHum)
    if not char:FindFirstChildOfClass("Tool") then
        local bat = findBatV2Tool()
        if bat and bat.Parent ~= char then pcall(function() myHum:EquipTool(bat) end) end
    end

    local target = nearest(myRoot)
    if not target or not target.Character then reset(); return end
    local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
    local targetHum = target.Character:FindFirstChildOfClass("Humanoid")
    if not targetRoot or not targetHum or targetHum.Health <= 0 then reset(); return end
    S.targetPlayer = target
    updatePingV2()

    local targetPos = targetRoot.Position
    local dtc = math.max(dt, 1/240)
    if S.lastTargetPos then
        local instantVel = (targetPos - S.lastTargetPos) / dtc
        local accel = instantVel - S.targetVelocity
        if accel.Magnitude > B2.MAX_VELOCITY_CHANGE then
            instantVel = S.targetVelocity + accel.Unit * B2.MAX_VELOCITY_CHANGE
        end
        local horizontalVel = Vector3.new(instantVel.X, 0, instantVel.Z)
        if horizontalVel.Magnitude > B2.MAX_HORIZONTAL_VELOCITY then
            horizontalVel = horizontalVel.Unit * B2.MAX_HORIZONTAL_VELOCITY
            instantVel = Vector3.new(horizontalVel.X, instantVel.Y, horizontalVel.Z)
        end
        push(S.accelerationHistory, (instantVel - S.targetVelocity) / dtc, 4)
        push(S.velocityHistory, instantVel, 8)
        push(S.verticalVelocityHistory, instantVel.Y, 5)
        S.targetVelocity = instantVel
        S.smoothedVelocity = S.smoothedVelocity:Lerp(instantVel, B2.VELOCITY_SMOOTHING)
    end
    S.lastTargetPos = targetPos

    local airborne = targetHum.FloorMaterial == Enum.Material.Air
    S.airborneTime = airborne and (S.airborneTime + dtc) or 0
    if airborne and S.airborneTime >= B2.MIN_AIRBORNE_TIME then
        push(S.aerialVelocityHistory, S.targetVelocity, 6)
    elseif not airborne then
        S.aerialVelocityHistory = {}
    end

    local smoothedVel = S.smoothedVelocity
    if airborne and #S.aerialVelocityHistory > 0 then
        local aerial = avg(S.aerialVelocityHistory)
        smoothedVel = Vector3.new(aerial.X, S.targetVelocity.Y, aerial.Z) * B2.AIR_CONTROL_FACTOR
    end

    local quickTurn = false
    local horizontalTargetVel = Vector3.new(S.targetVelocity.X, 0, S.targetVelocity.Z)
    if horizontalTargetVel.Magnitude > 5 then
        local newDir = horizontalTargetVel.Unit
        if S.previousDirection and S.previousDirection:Dot(newDir) < 0.5 then
            quickTurn = (tick() - S.lastDirectionChangeTime) < B2.DIRECTION_CHANGE_DETECTION_TIME
            S.lastDirectionChangeTime = tick()
        end
        S.previousDirection = newDir
    end

    local serverDelay = S.currentPing + B2.SERVER_TICKRATE
    local adjustedDelay = quickTurn and (serverDelay * B2.QUICK_DIRECTION_CHANGE_MULTIPLIER) or serverDelay
    local avgAccel = avg(S.accelerationHistory)
    local predictedPos = targetPos + smoothedVel * adjustedDelay
        + avgAccel * B2.ACCELERATION_PREDICTION_WEIGHT * (adjustedDelay * adjustedDelay * 0.5)
    local predictionTime = B2.PREDICTION_TIME * 1.1
    if airborne then
        predictedPos = predictedPos + smoothedVel * predictionTime
            + Vector3.new(0, -0.5 * B2.GRAVITY * predictionTime * predictionTime, 0)
    else
        predictedPos = predictedPos + smoothedVel * predictionTime
    end
    local horizSmoothed = Vector3.new(smoothedVel.X, 0, smoothedVel.Z)
    if horizSmoothed.Magnitude > 1 then predictedPos = predictedPos + horizSmoothed.Unit * B2.PREDICT_AHEAD end

    local direction = predictedPos - myRoot.Position
    face(myRoot, direction)
    if (targetPos - myRoot.Position).Magnitude <= B2.ACTIVATE_DISTANCE and tick() - S.lastActivationTime >= 0.3 then
        swing()
        S.lastActivationTime = tick()
    end
    if direction.Magnitude > B2.MIN_FOLLOW_DISTANCE then
        myRoot.AssemblyLinearVelocity = direction.Unit * B2.FOLLOW_SPEED
    else
        local currentVel = myRoot.AssemblyLinearVelocity
        myRoot.AssemblyLinearVelocity = Vector3.new(0, currentVel.Y * 0.5, 0)
    end
end

local function startNewBatV2()
    if not alive or S.enabled then return S.enabled end
    S.enabled = true
    S.generation = S.generation + 1
    S.swingLocked = false
    S.nextSwingAt = 0
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then trackHumanoid(hum) end
    end
    reset()
    S.lastActivationTime = 0
    S.conn = RunService.RenderStepped:Connect(function(dt)
        pcall(loop, dt)
    end)
    return true
end

local function stopNewBatV2()
    local wasEnabled = S.enabled
    S.enabled = false
    S.generation = S.generation + 1
    if S.conn then S.conn:Disconnect(); S.conn = nil end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if wasEnabled and root then
        pcall(function()
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end)
    end
    restoreHumanoid()
    S.swingLocked = false
    S.nextSwingAt = 0
    reset()
    return false
end

_G.__CandyKillV1StartBatV2 = startNewBatV2
_G.__CandyKillV1StopBatV2 = stopNewBatV2
_G.__CandyKillV1IsBatV2 = function() return S.enabled == true end
_G.__CandyKillV1SetBatV2Speed = function(v)
    B2.FOLLOW_SPEED = math.clamp(tonumber(v) or 55, 0.01, 500)
end
_G.__CandyKillV1BatCleanup = function()
    if not alive then return end
    stopNewBatV2()
    alive = false
end
end

do if type(_G.__CandyKillV2BatCleanup)=="function"then pcall(_G.__CandyKillV2BatCleanup)elseif type(_G.__CandyKillV2StopBatV2)=="function"then pcall(_G.__CandyKillV2StopBatV2)end local Players=game:GetService("Players")local RunService=game:GetService("RunService")local LP=Players.LocalPlayer local alive=true local CONFIG={FOLLOW_SPEED=55,ACTIVATE_DISTANCE=13,MIN_FOLLOW_DISTANCE=1,PREDICTION_TIME=0.22,PREDICT_AHEAD=3,MAX_VELOCITY_CHANGE=150,VELOCITY_SMOOTHING=0.2,MAX_HORIZONTAL_VELOCITY=80,SERVER_TICKRATE=1/60,MIN_PING_COMPENSATION=0.03,MAX_PING_COMPENSATION=0.25,ACCELERATION_PREDICTION_WEIGHT=0.3,DIRECTION_CHANGE_DETECTION_TIME=0.12,QUICK_DIRECTION_CHANGE_MULTIPLIER=1.5,GRAVITY=196.2,AIR_CONTROL_FACTOR=0.8,AERIAL_VELOCITY_DECAY=0.95,MIN_AIRBORNE_TIME=0.08,FALLING_SPEED_THRESHOLD=-15,SWING_COOLDOWN=0.08,}local STATE={enabled=false,generation=0,humanoid=nil,conn=nil,targetPlayer=nil,lastTargetPos=nil,targetVelocity=Vector3.zero,smoothedVelocity=Vector3.zero,velocityHistory={},accelerationHistory={},aerialVelocityHistory={},verticalVelocityHistory={},previousDirection=nil,lastDirectionChangeTime=0,airborneTime=0,lastYVelocity=0,lastJumpTime=0,lastActivationTime=0,currentPing=0.1,realPingMs=0,previousAutoRotate=nil,swingLocked=false,nextSwingAt=0,}local function getAverage(list)if#list==0 then return Vector3.zero end local sum=Vector3.zero for _,v in ipairs(list)do sum=sum+v end return sum/#list end local function addToHistory(list,value,maxSize)table.insert(list,value)if#list>maxSize then table.remove(list,1)end end local function resetState()STATE.targetPlayer=nil STATE.lastTargetPos=nil STATE.targetVelocity=Vector3.zero STATE.smoothedVelocity=Vector3.zero STATE.velocityHistory={}STATE.accelerationHistory={}STATE.aerialVelocityHistory={}STATE.verticalVelocityHistory={}STATE.previousDirection=nil STATE.airborneTime=0 STATE.lastYVelocity=0 end local function findBat()local char=LP.Character if not char then return nil end local equipped=char:FindFirstChildOfClass("Tool")if equipped then local name=equipped.Name:lower()if name:find("bat")or name:find("slap")then return equipped end end local backpack=LP:FindFirstChildOfClass("Backpack")if backpack then for _,tool in ipairs(backpack:GetChildren())do if tool:IsA("Tool")then local name=tool.Name:lower()if name:find("bat")or name:find("slap")then return tool end end end end return nil end local function findNearestEnemy(myRoot)local nearest,nearestDist=nil,math.huge for _,player in ipairs(Players:GetPlayers())do if player~=LP and player.Character then local targetRoot=player.Character:FindFirstChild("HumanoidRootPart")local targetHum=player.Character:FindFirstChildOfClass("Humanoid")if targetRoot and targetHum and targetHum.Health>0 then local dist=(targetRoot.Position-myRoot.Position).Magnitude if dist<nearestDist then nearestDist=dist nearest=player end end end end return nearest,nearestDist end local function faceTarget(myRoot,direction)if direction.Magnitude<0.01 then return end local cross=myRoot.CFrame.LookVector:Cross(direction.Unit)local angle=math.asin(math.clamp(cross.Magnitude,-1,1))myRoot.AssemblyAngularVelocity=cross.Magnitude>0.01 and cross.Unit*angle*80 or Vector3.zero end local function updatePing()local ok,ping=pcall(function()return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()end)if ok and type(ping)=="number"then STATE.realPingMs=math.floor(ping)end STATE.currentPing=math.clamp(STATE.realPingMs/1000,CONFIG.MIN_PING_COMPENSATION,CONFIG.MAX_PING_COMPENSATION)end local function swingBat()local now=tick()if STATE.swingLocked or now<STATE.nextSwingAt then return end STATE.swingLocked=true local generation=STATE.generation STATE.nextSwingAt=now+CONFIG.SWING_COOLDOWN pcall(function()local char=LP.Character if not char then return end local bat=findBat()if not bat then return end if bat.Parent~=char then local hum=char:FindFirstChildOfClass("Humanoid")if hum then hum:EquipTool(bat)end end bat:Activate()local remote=bat:FindFirstChildWhichIsA("RemoteEvent")if remote then remote:FireServer()end end)task.delay(CONFIG.SWING_COOLDOWN,function()if STATE.generation==generation then STATE.swingLocked=false end end)end local function restoreHumanoid()if STATE.humanoid and STATE.previousAutoRotate~=nil then pcall(function()STATE.humanoid.AutoRotate=STATE.previousAutoRotate end)end STATE.humanoid=nil STATE.previousAutoRotate=nil end local function trackHumanoid(humanoid)if STATE.humanoid~=humanoid then restoreHumanoid()STATE.humanoid=humanoid STATE.previousAutoRotate=humanoid.AutoRotate resetState()end humanoid.AutoRotate=false end local function aimbotLoop(dt)if not STATE.enabled then return end local char=LP.Character if not char then return end local myRoot=char:FindFirstChild("HumanoidRootPart")local myHum=char:FindFirstChildOfClass("Humanoid")if not myRoot or not myHum or myHum.Health<=0 then return end trackHumanoid(myHum)local equippedTool=char:FindFirstChildOfClass("Tool")if not equippedTool then local bat=findBat()if bat and bat.Parent~=char then pcall(function()myHum:EquipTool(bat)end)end end local target,dist=findNearestEnemy(myRoot)if not target or not target.Character then resetState()return end local targetRoot=target.Character:FindFirstChild("HumanoidRootPart")local targetHum=target.Character:FindFirstChildOfClass("Humanoid")if not targetRoot or not targetHum or targetHum.Health<=0 then resetState()return end if STATE.targetPlayer~=target then resetState()end STATE.targetPlayer=target updatePing()local targetPos=targetRoot.Position local dt_clamped=math.max(dt,1/240)if STATE.lastTargetPos then local instantVel=(targetPos-STATE.lastTargetPos)/dt_clamped local accel=instantVel-STATE.targetVelocity if accel.Magnitude>CONFIG.MAX_VELOCITY_CHANGE then instantVel=STATE.targetVelocity+accel.Unit*CONFIG.MAX_VELOCITY_CHANGE end local horizontalVel=Vector3.new(instantVel.X,0,instantVel.Z)if horizontalVel.Magnitude>CONFIG.MAX_HORIZONTAL_VELOCITY then horizontalVel=horizontalVel.Unit*CONFIG.MAX_HORIZONTAL_VELOCITY instantVel=Vector3.new(horizontalVel.X,instantVel.Y,horizontalVel.Z)end addToHistory(STATE.accelerationHistory,(instantVel-STATE.targetVelocity)/dt_clamped,4)addToHistory(STATE.velocityHistory,instantVel,8)addToHistory(STATE.verticalVelocityHistory,instantVel.Y,5)STATE.targetVelocity=instantVel STATE.smoothedVelocity=STATE.smoothedVelocity:Lerp(instantVel,CONFIG.VELOCITY_SMOOTHING)end STATE.lastTargetPos=targetPos local isAirborne=targetHum.FloorMaterial==Enum.Material.Air STATE.airborneTime=isAirborne and(STATE.airborneTime+dt_clamped)or 0 if isAirborne and STATE.airborneTime>=CONFIG.MIN_AIRBORNE_TIME then addToHistory(STATE.aerialVelocityHistory,STATE.targetVelocity,6)elseif not isAirborne then STATE.aerialVelocityHistory={}end local smoothedVel=STATE.smoothedVelocity if isAirborne and#STATE.aerialVelocityHistory>0 then local avgAerial=getAverage(STATE.aerialVelocityHistory)smoothedVel=Vector3.new(avgAerial.X,STATE.targetVelocity.Y,avgAerial.Z)*CONFIG.AIR_CONTROL_FACTOR end local isQuickTurn=false local horizontalTargetVel=Vector3.new(STATE.targetVelocity.X,0,STATE.targetVelocity.Z)if horizontalTargetVel.Magnitude>5 then local newDir=horizontalTargetVel.Unit if STATE.previousDirection and STATE.previousDirection:Dot(newDir)<0.5 then isQuickTurn=(tick()-STATE.lastDirectionChangeTime)<CONFIG.DIRECTION_CHANGE_DETECTION_TIME STATE.lastDirectionChangeTime=tick()end STATE.previousDirection=newDir end local serverDelay=STATE.currentPing+CONFIG.SERVER_TICKRATE local adjustedDelay=isQuickTurn and(serverDelay*CONFIG.QUICK_DIRECTION_CHANGE_MULTIPLIER)or serverDelay local avgAccel=getAverage(STATE.accelerationHistory)local accelContribution=avgAccel*CONFIG.ACCELERATION_PREDICTION_WEIGHT*(adjustedDelay*adjustedDelay*0.5)local predictedPos=targetPos+smoothedVel*adjustedDelay+accelContribution local predictionTime=CONFIG.PREDICTION_TIME*1.1 if isAirborne then predictedPos=predictedPos+smoothedVel*predictionTime+Vector3.new(0,-0.5*CONFIG.GRAVITY*predictionTime*predictionTime,0)else predictedPos=predictedPos+smoothedVel*predictionTime end local horizSmoothed=Vector3.new(smoothedVel.X,0,smoothedVel.Z)if horizSmoothed.Magnitude>1 then predictedPos=predictedPos+horizSmoothed.Unit*CONFIG.PREDICT_AHEAD end local direction=predictedPos-myRoot.Position faceTarget(myRoot,direction)if(targetPos-myRoot.Position).Magnitude<=CONFIG.ACTIVATE_DISTANCE then if tick()-STATE.lastActivationTime>=0.3 then swingBat()STATE.lastActivationTime=tick()end end if direction.Magnitude>CONFIG.MIN_FOLLOW_DISTANCE then local speed=tonumber(BAT_V2_SPEED)or CONFIG.FOLLOW_SPEED myRoot.AssemblyLinearVelocity=direction.Unit*speed else local currentVel=myRoot.AssemblyLinearVelocity myRoot.AssemblyLinearVelocity=Vector3.new(0,currentVel.Y*0.5,0)end end local function startAimbot()if not alive or STATE.enabled then return STATE.enabled end STATE.enabled=true STATE.generation=STATE.generation+1 STATE.swingLocked=false STATE.nextSwingAt=0 STATE.lastActivationTime=0 resetState()local char=LP.Character local hum=char and char:FindFirstChildOfClass("Humanoid")if hum then trackHumanoid(hum)end STATE.conn=RunService.RenderStepped:Connect(function(dt)if alive then pcall(aimbotLoop,dt)end end)return true end local function stopAimbot()local wasEnabled=STATE.enabled STATE.enabled=false STATE.generation=STATE.generation+1 if STATE.conn then STATE.conn:Disconnect()STATE.conn=nil end if wasEnabled then local char=LP.Character local root=char and char:FindFirstChild("HumanoidRootPart")if root then pcall(function()root.AssemblyLinearVelocity=Vector3.zero root.AssemblyAngularVelocity=Vector3.zero end)end end restoreHumanoid()resetState()STATE.swingLocked=false STATE.nextSwingAt=0 return false end STATE.respawnConn=LP.CharacterAdded:Connect(function()if not alive then return end restoreHumanoid()resetState()STATE.generation=STATE.generation+1 STATE.swingLocked=false STATE.nextSwingAt=0 STATE.lastActivationTime=0 end)_G.__CandyKillV2BatV2State=STATE _G.__CandyKillV2StartBatV2=startAimbot _G.__CandyKillV2StopBatV2=stopAimbot _G.__CandyKillV2IsBatV2=function()return alive and STATE.enabled==true end _G.__CandyKillV2BatCleanup=function()if not alive then return end stopAimbot()alive=false if STATE.respawnConn then STATE.respawnConn:Disconnect()STATE.respawnConn=nil end end end


uiVisual.batV2Engines = {
    Rival = {
        start = _G.__CandyKillV1StartBatV2,
        stop = _G.__CandyKillV1StopBatV2,
        isEnabled = _G.__CandyKillV1IsBatV2,
        setSpeed = _G.__CandyKillV1SetBatV2Speed,
    },
    Bless = {
        start = _G.__CandyKillV2StartBatV2,
        stop = _G.__CandyKillV2StopBatV2,
        isEnabled = _G.__CandyKillV2IsBatV2,
    },
}

function uiVisual.refreshBatV2Engine()
    if uiVisual.batV2EngineButton then
        uiVisual.batV2EngineButton.Text = batV2Engine == "Bless" and "Version 2" or "Version 1"
    end
end

function uiVisual.syncBatV2Speed()
    BAT_V2_SPEED = math.clamp(tonumber(BAT_V2_SPEED) or 55, 1, 120)
    local api = uiVisual.batV2Engines[batV2Engine]
    if api and type(api.setSpeed) == "function" then
        pcall(api.setSpeed, BAT_V2_SPEED)
    end
end

function stopBatV2()
    for _, name in ipairs({"Rival", "Bless"}) do
        local api = uiVisual.batV2Engines[name]
        if api and type(api.stop) == "function" then pcall(api.stop) end
    end
    batV2RunningEngine = nil
    batV2Enabled = false
    _G.KillHub.Active.autoBat = false
    if uiVisual.batV2BodySuppressed then
        uiVisual.batV2BodySuppressed = false
        _unsuppressBodyLock(true)
    end

    if mobSetBatV2 then mobSetBatV2(false) end
    if batV2SetVisual then batV2SetVisual(false) end
end

function startBatV2()
    if bypassToggled then stopBypassAimbot() end
    local api = uiVisual.batV2Engines[batV2Engine]
    if batV2Enabled and batV2RunningEngine == batV2Engine
        and api and type(api.isEnabled) == "function" and api.isEnabled() then
        return true
    end

    if batV2Enabled or batV2RunningEngine then
        stopBatV2()
    end

    if autoBatEnabled or _G.KillHub.Connections.aimbot then
        disableAutoBat()
    end
    if mobSetAutoBat then mobSetAutoBat(false) end
    if autoBatSetVisual then autoBatSetVisual(false) end

    if autoLeftEnabled then
        autoLeftEnabled = false
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        stopAutoLeft()
    end

    if autoRightEnabled then
        autoRightEnabled = false
        if autoRightSetVisual then autoRightSetVisual(false) end
        stopAutoRight()
    end

    if not api or type(api.start) ~= "function" then
        stopBatV2()
        return false
    end

    uiVisual.syncBatV2Speed()

    _suppressBodyLock()
    uiVisual.batV2BodySuppressed = true
    batV2Enabled = true
    autoBatEnabled = false
    batV2RunningEngine = batV2Engine
    _G.KillHub.Active.autoBat = true

    local ok, result = pcall(api.start)
    if ok and result ~= false and type(api.isEnabled) == "function" then
        local checked, enabled = pcall(api.isEnabled)
        ok = checked and enabled == true
    end
    if not ok or result == false then
        stopBatV2()
        return false
    end

    if mobSetBatV2 then mobSetBatV2(true) end
    if batV2SetVisual then batV2SetVisual(true) end
    return true
end

function uiVisual.setBatV2Engine(engine)
    local selected = engine == "Bless" and "Bless" or "Rival"
    if selected == batV2Engine then
        uiVisual.refreshBatV2Engine()
        return true
    end
    local wasEnabled = batV2Enabled
    if wasEnabled or batV2RunningEngine then stopBatV2() end
    batV2Engine = selected
    uiVisual.refreshBatV2Engine()
    if wasEnabled then return startBatV2() end
    return true
end

function disableAutoBat()
    stopAimbotAdapt()
    autoBatEnabled = false
    _G.KillHub.Active.autoBat = false
end

function enableAutoBat()
    if bypassToggled then stopBypassAimbot() end
    if batV2Enabled then stopBatV2() end
    if mobSetBatV2 then mobSetBatV2(false) end
    if autoLeftEnabled then
        autoLeftEnabled = false
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        stopAutoLeft()
    end
    if autoRightEnabled then
        autoRightEnabled = false
        if autoRightSetVisual then autoRightSetVisual(false) end
        stopAutoRight()
    end
    startAimbotAdapt()
end
 function setAimbotMode()aimbotMode="old"end _G.AceStartNormalAimbot=enableAutoBat _G.AceStopNormalAimbot=stopAimbotAdapt
do
    if type(_G.__BLESS_TPBatCleanup) == "function" then pcall(_G.__BLESS_TPBatCleanup)
    elseif type(_G.__BLESS_TPBatStop) == "function" then pcall(_G.__BLESS_TPBatStop) end
    if type(_G.__KillHubNewTPCleanup) == "function" then pcall(_G.__KillHubNewTPCleanup) end
end
do








local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Player = Players.LocalPlayer


_G.__tpBatV2Distance = 1.30       
_G.__blueDotLeftOffset = 1.5      
_G.__blueDotUpOffset = 0.9        


local U = {
    enabled = false,
    heartbeat = nil,
    target = nil,
    samples = {},
    swingLocked = false,
    nextSwingAt = 0,
    previousAutoRotate = nil,
    lastTargetMarker = nil,
    markerLocked = false,
    markerTarget = nil,
    blueDot = nil,
}

local _ = {}




local AntiFling = {
    conn = nil,
    maxSpeed = 100,
    maxAngular = 50,
}

local function startAntiFling()
    if AntiFling.conn then AntiFling.conn:Disconnect() end
    AntiFling.conn = RunService.Heartbeat:Connect(function() if dropActive or _G.IsDropping then return end 
        local char = Player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return end

        local vel = root.AssemblyLinearVelocity
        if vel.Magnitude > AntiFling.maxSpeed then
            root.AssemblyLinearVelocity = vel.Unit * AntiFling.maxSpeed
        end

        local angVel = root.AssemblyAngularVelocity
        if angVel.Magnitude > AntiFling.maxAngular then
            root.AssemblyAngularVelocity = angVel.Unit * AntiFling.maxAngular
        end
    end)
end

startAntiFling()




local function createBlueDot()
    if U.blueDot and U.blueDot.Parent then return U.blueDot end

    local dot = Instance.new("Part")
    dot.Name = "TPBat_BlueDot"
    dot.Shape = Enum.PartType.Ball
    dot.Size = Vector3.new(0.6, 0.6, 0.6)
    dot.Color = Color3.fromRGB(0, 170, 255)
    dot.Material = Enum.Material.Neon
    dot.Anchored = true
    dot.CanCollide = false
    dot.CanTouch = false
    dot.CanQuery = false
    dot.CastShadow = false
    dot.Transparency = 0.1
    dot.Parent = workspace

    
    local hl = Instance.new("Highlight")
    hl.Name = "BlueDotHighlight"
    hl.Adornee = dot
    hl.FillColor = Color3.fromRGB(0, 170, 255)
    hl.FillTransparency = 0.4
    hl.OutlineColor = Color3.fromRGB(150, 220, 255)
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Enabled = true
    hl.Parent = dot

    
    local sphere = Instance.new("SphereHandleAdornment")
    sphere.Name = "BlueDotSphere"
    sphere.Adornee = dot
    sphere.Radius = 0.45
    sphere.Color3 = Color3.fromRGB(0, 170, 255)
    sphere.Transparency = 0.1
    sphere.AlwaysOnTop = true
    sphere.Visible = true
    sphere.ZIndex = 10
    sphere.Parent = dot

    U.blueDot = dot
    return dot
end

local function updateBlueDot(position, lookVector)
    local dot = createBlueDot()
    if not dot then return end
    local flat = lookVector and Vector3.new(lookVector.X, 0, lookVector.Z) or Vector3.new(0, 0, -1)
    if flat.Magnitude < 0.01 then
        flat = Vector3.new(0, 0, -1)
    else
        flat = flat.Unit
    end
    dot.CFrame = CFrame.lookAt(position, position + flat)
    dot.Transparency = 0.1
    dot.Size = Vector3.new(0.6, 0.6, 0.6)
end

local function hideBlueDot()
    if U.blueDot then
        U.blueDot.Transparency = 1
        local hl = U.blueDot:FindFirstChild("BlueDotHighlight")
        if hl then hl.Enabled = false end
        local sp = U.blueDot:FindFirstChild("BlueDotSphere")
        if sp then sp.Visible = false end
    end
end

local function destroyBlueDot()
    if U.blueDot then
        pcall(function() U.blueDot:Destroy() end)
        U.blueDot = nil
    end
end




local function calculateTargetPosition(targetRoot)
    if not targetRoot then return nil, nil end

    local tCF = targetRoot.CFrame
    local tPos = targetRoot.Position

    
    local behind = tCF.LookVector * -_G.__tpBatV2Distance
    
    local left = tCF.RightVector * -_G.__blueDotLeftOffset

    
    local finalPos = tPos + behind + left + Vector3.new(0, _G.__blueDotUpOffset, 0)

    return finalPos, tCF
end




local function getChar()
    local char = Player.Character
    if not char then return nil, nil, nil end
    return char, char:FindFirstChild("HumanoidRootPart"), char:FindFirstChildOfClass("Humanoid")
end

local function isValidVector(v)
    return v ~= nil
        and v.X == v.X and v.Y == v.Y and v.Z == v.Z
        and math.abs(v.X) < 10000000
        and math.abs(v.Y) < 10000000
        and math.abs(v.Z) < 10000000
end

local function buildLookCFrame(fromPos, toPos, fallbackLook, cframeFallback)
    local flat = Vector3.new(toPos.X - fromPos.X, 0, toPos.Z - fromPos.Z)
    if flat.Magnitude > 0.05 then
        return CFrame.lookAt(fromPos, fromPos + flat.Unit)
    end
    flat = fallbackLook and Vector3.new(fallbackLook.X, 0, fallbackLook.Z) or nil
    if flat and flat.Magnitude >= 0.01 then
        return CFrame.lookAt(fromPos, fromPos + flat.Unit)
    end
    if cframeFallback then
        local _, ry = cframeFallback:ToEulerAnglesYXZ()
        return CFrame.new(fromPos) * CFrame.Angles(0, ry, 0)
    end
    return CFrame.new(fromPos)
end

local function isInsideMap(pos)
    return isValidVector(pos)
end




local function updateMarker(markerCF)
    if U.markerLocked then return end
    local target = U.markerTarget
    local tChar = target and target.Parent == Players and target.Character
    local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
    local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
    if not tRoot or not tHum or tHum.Health <= 0 or not isValidVector(tRoot.Position) or isInsideMap(tRoot.Position) then return end
    if not markerCF or not isInsideMap(markerCF.Position) then return end

    local cf = CFrame.new(markerCF.Position.X, -7, markerCF.Position.Z) * markerCF.Rotation
    local marker = U.lastTargetMarker

    if not marker or not marker.Parent then
        marker = Instance.new("Part")
        marker.Name = "TPBat_LastPosition"
        marker.Shape = Enum.PartType.Ball
        marker.Size = Vector3.new(3, 3, 3)
        marker.Color = Color3.fromRGB(220, 30, 45)
        marker.Material = Enum.Material.Neon
        marker.Anchored = true
        marker.CanCollide = false
        marker.CanTouch = false
        marker.CanQuery = false
        marker.CastShadow = false
        marker.Parent = workspace

        local sphere = Instance.new("SphereHandleAdornment")
        sphere.Name = "AlwaysOnTopSphere"
        sphere.Adornee = marker
        sphere.Radius = 1.55
        sphere.Color3 = Color3.fromRGB(235, 40, 55)
        sphere.Transparency = 0.05
        sphere.AlwaysOnTop = true
        sphere.Visible = true
        sphere.ZIndex = 10
        sphere.Parent = marker

        U.lastTargetMarker = marker
    end

    marker.Transparency = 0
    marker.CFrame = cf
    U.markerLocked = true
end

local function hideMarker()
    U.markerLocked = false
    if U.lastTargetMarker then
        pcall(function()
            U.lastTargetMarker.Transparency = 1
            local sp = U.lastTargetMarker:FindFirstChild("AlwaysOnTopSphere")
            if sp then sp.Visible = false end
        end)
    end
end

local function getMarkerCFrame()
    local marker = U.lastTargetMarker
    if U.markerLocked and marker and marker.Parent and marker.Transparency < 1 then
        local target = U.markerTarget
        local tRoot = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if tRoot and isInsideMap(tRoot.Position) then
            hideMarker()
            return nil
        end
        local _, myRoot = getChar()
        if myRoot and marker then
            return buildLookCFrame(myRoot.Position, marker.Position, marker.CFrame.LookVector, myRoot.CFrame)
        end
    end
    return nil
end




local function isValidTarget(p)
    if not p or p.Parent ~= Players or not p.Character then return false end
    local root = p.Character:FindFirstChild("HumanoidRootPart")
    local hum = p.Character:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 or not isValidVector(root.Position) then return false end
    return isInsideMap(root.Position)
end

local function getHistorySample(sample, now)
    if not sample or not sample.history or #sample.history == 0 then return nil end
    local targetTime = now - 0.2
    local best = nil
    for _, entry in ipairs(sample.history) do
        if not (entry.time <= targetTime) then break end
        best = entry
    end
    return best or sample.history[1]
end

local function trackTarget()
    if U.markerLocked then return U.markerTarget end
    local target = U.markerTarget
    local tChar = target and target.Parent == Players and target.Character
    local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
    local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
    local sample = target and U.samples[target]
    if target and target.Parent == Players then
        if tHum and tHum.Health > 0 and (tRoot and isInsideMap(tRoot.Position) or sample and sample.safeCFrame) then
            return target
        end
    end
    return U.markerTarget
end




local sampleElapsed = 0
local sampleInterval = 0.01666

local function sampleLoop()
    local char, myRoot = getChar()
    if not myRoot then return end

    local target = U.markerTarget
    if target and target.Parent == Players then
        local tChar = target.Character
        local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
        local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
        local sample = U.samples[target] or {}
        U.samples[target] = sample

        if tRoot and tHum and tHum.Health > 0 and isValidVector(tRoot.Position) then
            if isInsideMap(tRoot.Position) then
                local now = tick()
                sample.history = sample.history or {}
                table.insert(sample.history, {
                    time = now,
                    safePosition = tRoot.Position,
                    safeCFrame = tRoot.CFrame,
                })
                while sample.history[1] and now - sample.history[1].time > 0.45 do
                    table.remove(sample.history, 1)
                end
                sample.safePosition = tRoot.Position
                sample.safeCFrame = tRoot.CFrame
                hideMarker()
            else
                local entry = getHistorySample(sample, tick())
                updateMarker(entry and entry.safeCFrame or sample.safeCFrame)
            end
        end

        if (tHum and tHum.Health <= 0) or (not tRoot and not sample.safeCFrame) then
            U.markerTarget = nil
            hideMarker()
        else
            return
        end
    end

    local closest, closestDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= Player and isValidTarget(p) then
            local root = p.Character:FindFirstChild("HumanoidRootPart")
            local dist = (root.Position - myRoot.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = p
            end
        end
    end

    if closest then
        U.markerTarget = closest
        local tRoot = closest.Character:FindFirstChild("HumanoidRootPart")
        local sample = U.samples[closest] or {}
        U.samples[closest] = sample
        sample.safePosition = tRoot.Position
        sample.safeCFrame = tRoot.CFrame
        sample.history = {{ time = tick(), safePosition = tRoot.Position, safeCFrame = tRoot.CFrame }}
    end
end




local function findBat()
    local char = Player.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local n = tool.Name:lower()
            if n:find("bat") or n:find("slap") or n:find("hammer") then
                return tool
            end
        end
    end
    local bp = Player:FindFirstChildOfClass("Backpack")
    if bp then
        local hum = char:FindFirstChildOfClass("Humanoid")
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") then
                local n = tool.Name:lower()
                if n:find("bat") or n:find("slap") or n:find("hammer") then
                    if hum then pcall(function() hum:EquipTool(tool) end) end
                    return tool
                end
            end
        end
    end
    return nil
end

local function swing()
    local now = tick()
    if U.swingLocked or now < U.nextSwingAt then return end
    U.swingLocked = true
    U.nextSwingAt = now + 0.0149

    pcall(function()
        local bat = findBat()
        if not bat then return end
        bat:Activate()
        local remote = bat:FindFirstChildWhichIsA("RemoteEvent")
        if remote then remote:FireServer() end
    end)

    task.delay(0.0149, function() U.swingLocked = false end)
end

local function stopMovement(root)
    if not root then return end
    pcall(function()
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end)
end

local function tpToMarker(root)
    local cf = getMarkerCFrame()
    if not cf then return false end
    pcall(function()
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        root.CFrame = cf
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end)
    return true
end




local function updateV2() if dropActive or _G.IsDropping then return end 
    if not U.enabled then return end
    local char, root, hum = getChar()
    if not char or not root or not hum or hum.Health <= 0 then return end

    
    if tpToMarker(root) then swing(); return end

    if U.previousAutoRotate == nil then
        U.previousAutoRotate = hum.AutoRotate
    end
    hum.AutoRotate = false

    local target = trackTarget()
    if not target or not target.Character then
        hideBlueDot()
        return
    end

    local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
    local tHum = target.Character:FindFirstChildOfClass("Humanoid")
    if not tRoot or not tHum or tHum.Health <= 0 or not isValidVector(tRoot.Position) then
        hideBlueDot()
        return
    end

    
    if not isInsideMap(tRoot.Position) then
        local sample = U.samples[target]
        if sample and sample.safeCFrame then
            updateMarker(sample.safeCFrame)
        end
        hideBlueDot()
        if tpToMarker(root) then swing() end
        return
    end

    
    local sample = U.samples[target] or {}
    U.samples[target] = sample
    sample.safeCFrame = tRoot.CFrame
    sample.safePosition = tRoot.Position

    
    local targetPos, tCF = calculateTargetPosition(tRoot)
    if not targetPos then
        hideBlueDot()
        return
    end

    
    updateBlueDot(targetPos, tCF.LookVector)

    
    local cf = buildLookCFrame(targetPos, tRoot.Position, tCF.LookVector, root.CFrame)

    pcall(function()
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        root.CFrame = cf or root.CFrame
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end)

    
    local cam = workspace.CurrentCamera
    if cam then
        pcall(function() cam.CFrame = CFrame.new(cam.CFrame.Position, tRoot.Position) end)
    end

    swing()
end




local function updateLoop()
    if not U.enabled then return end
    updateV2()
end




local sampleConn = RunService.Heartbeat:Connect(function(dt)
    if not U.enabled then return end
    sampleElapsed += dt
    if sampleElapsed < sampleInterval then return end
    sampleElapsed = 0
    pcall(sampleLoop)
end)

local function startTPBat()
    if U.enabled then return end
    U.enabled = true
    U.target = nil
    U.samples = {}
    U.swingLocked = false
    U.nextSwingAt = 0

    local _, root, hum = getChar()
    if root then stopMovement(root) end
    if hum then
        U.previousAutoRotate = hum.AutoRotate
    end

    U.heartbeat = RunService.Heartbeat:Connect(function()
        pcall(updateLoop)
    end)

    task.spawn(function() pcall(updateLoop) end)
end

local function stopTPBat()
    if not U.enabled then return end
    U.enabled = false

    if U.heartbeat then
        U.heartbeat:Disconnect()
        U.heartbeat = nil
    end

    hideMarker()
    hideBlueDot()

    local _, root, hum = getChar()
    if root then stopMovement(root) end
    if hum then
        hum.AutoRotate = U.previousAutoRotate == nil and true or U.previousAutoRotate
        pcall(function()
            hum.PlatformStand = false
            hum.Sit = false
            local st = hum:GetState()
            if st == Enum.HumanoidStateType.Physics
                or st == Enum.HumanoidStateType.Ragdoll
                or st == Enum.HumanoidStateType.FallingDown then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
            local cam = workspace.CurrentCamera
            if cam then cam.CameraSubject = hum end
        end)
    end
    U.previousAutoRotate = nil
    U.markerTarget = nil
end



_G.__KillHubNewTPStart = startTPBat
_G.__KillHubNewTPStop = stopTPBat
_G.__KillHubNewTPIsOn = function() return U.enabled == true end
_G.__KillHubNewTPCleanup = function()
    pcall(stopTPBat)
    if sampleConn then
        pcall(function() sampleConn:Disconnect() end)
        sampleConn = nil
    end
    if AntiFling and AntiFling.conn then
        pcall(function() AntiFling.conn:Disconnect() end)
        AntiFling.conn = nil
    end
    pcall(destroyBlueDot)
    if U.lastTargetMarker then
        pcall(function() U.lastTargetMarker:Destroy() end)
        U.lastTargetMarker = nil
    end
end


end
_G.__BLESS_TPBatStart = _G.__KillHubNewTPStart
_G.__BLESS_TPBatStop = _G.__KillHubNewTPStop
_G.__BLESS_TPBatIsOn = _G.__KillHubNewTPIsOn
_G.__BLESS_TPBatCleanup = _G.__KillHubNewTPCleanup
_G.AceAntiDesyncAimbotOn = false
function startBypassAimbot()
    if bypassToggled and _G.__KillHubNewTPIsOn and _G.__KillHubNewTPIsOn() then
        return true
    end

    disableAllAimbots()

    if autoLeftEnabled then
        autoLeftEnabled = false
        stopAutoLeft()
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobSetAutoLeft then mobSetAutoLeft(false) end
    end

    if autoRightEnabled then
        autoRightEnabled = false
        stopAutoRight()
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobSetAutoRight then mobSetAutoRight(false) end
    end

    if not _G.__KillHubNewTPStart then
        bypassToggled = false
    _G.AceAntiDesyncAimbotOn = false
        if bypassSetVisual then bypassSetVisual(false) end
        if mobSetTpBat then mobSetTpBat(false) end
        if _G.BlessTPBatFloatingSetVisual then _G.BlessTPBatFloatingSetVisual(false) end
        return false
    end

    local ok = pcall(_G.__KillHubNewTPStart)
    if not ok then
        bypassToggled = false
    _G.AceAntiDesyncAimbotOn = false
        if bypassSetVisual then bypassSetVisual(false) end
        if mobSetTpBat then mobSetTpBat(false) end
        if _G.BlessTPBatFloatingSetVisual then _G.BlessTPBatFloatingSetVisual(false) end
        return false
    end

    bypassToggled = true
    _G.AceAntiDesyncAimbotOn = true
    if bypassSetVisual then bypassSetVisual(true) end
    if mobSetTpBat then mobSetTpBat(true) end
    if _G.BlessTPBatFloatingSetVisual then _G.BlessTPBatFloatingSetVisual(true) end
    return true
end

function stopBypassAimbot()
    if _G.__KillHubNewTPStop then
        pcall(_G.__KillHubNewTPStop)
    end
    bypassToggled = false
    _G.AceAntiDesyncAimbotOn = false
    if bypassSetVisual then bypassSetVisual(false) end
    if mobSetTpBat then mobSetTpBat(false) end
    if _G.BlessTPBatFloatingSetVisual then _G.BlessTPBatFloatingSetVisual(false) end
end
function toggleBypass(state)if state==nil then state=not bypassToggled end if state then return startBypassAimbot()end return stopBypassAimbot()end
 function _G.AceStartAntiDesyncAimbot()return startBypassAimbot()end function _G.AceStopAntiDesyncAimbot()return stopBypassAimbot()end function _G.AceToggleAntiDesyncAimbot()return toggleBypass()end function findBat()local char=LP.Character if not char then return nil end for _,tool in ipairs(char:GetChildren())do if tool:IsA("Tool")and(tool.Name:lower():find("bat")or tool.Name:lower():find("slap"))then return tool end end local bp=LP:FindFirstChildOfClass("Backpack")if bp then for _,tool in ipairs(bp:GetChildren())do if tool:IsA("Tool")and(tool.Name:lower():find("bat")or tool.Name:lower():find("slap"))then return tool end end end return nil end function isBatTool(tool)if not tool then return false end for _,name in ipairs(BAT_COUNTER_SLAP_LIST)do if tool.Name==name then return true end end return tool.Name:lower():find("bat")or tool.Name:lower():find("slap")end local batCounterDebounce=false local _bodyLockCounterActive=false local function _faceAttackerFor1s()if _bodyLockCounterActive then return end _bodyLockCounterActive=true local c=LP.Character if not c then _bodyLockCounterActive=false;return end local root=c:FindFirstChild("HumanoidRootPart")if not root then _bodyLockCounterActive=false;return end local hum2=c:FindFirstChildOfClass("Humanoid")if not hum2 then _bodyLockCounterActive=false;return end local target=getClosestTarget()if not target then _bodyLockCounterActive=false;return end hum2.AutoRotate=false local deadline=tick()+1 local fconn fconn=RunService.RenderStepped:Connect(function()if tick()>=deadline then fconn:Disconnect()local c2=LP.Character local hum3=c2 and c2:FindFirstChildOfClass("Humanoid")local root2=c2 and c2:FindFirstChild("HumanoidRootPart")if hum3 then hum3.AutoRotate=true end if root2 then root2.AssemblyAngularVelocity=Vector3.zero end _bodyLockCounterActive=false return end local c2=LP.Character if not c2 then return end local root2=c2:FindFirstChild("HumanoidRootPart")if not root2 then return end local myPos=root2.Position local tgtPos=target.Position+target.AssemblyLinearVelocity*0.1 local toTarget=tgtPos-myPos if toTarget.Magnitude>0.1 then local goalCF=CFrame.lookAt(myPos,tgtPos)local diffCF=root2.CFrame:Inverse()*goalCF local _,ry,_=diffCF:ToEulerAnglesXYZ()ry=math.clamp(ry,-2.5,2.5)root2.AssemblyAngularVelocity=root2.CFrame:VectorToWorldSpace(Vector3.new(0,ry*42,0))end end)end -- Mommy Bat Counter, adapted to Bless's controls and connection lifetime.
uiVisual.batCounterMode = "V1"
do
    local controller = {generation = 0, root = nil, character = nil}

    local function releaseCounterRoot()
        local root = controller.root
        controller.root = nil
        _G.BlessBatCounterV2On = false
        if root and type(sethiddenproperty) == "function" then
            pcall(sethiddenproperty, root, "PhysicsRepRootPart", nil)
        end
    end

    local function cancelCounterSwing()
        controller.generation = controller.generation + 1
        releaseCounterRoot()
        controller.character = nil
        batCounterDebounce = false
    end

    local function findBatForCounter()
        local char = LP.Character
        if not char then return nil end
        local backpack = LP:FindFirstChildOfClass("Backpack")
        for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
            local tool = char:FindFirstChild(name) or (backpack and backpack:FindFirstChild(name))
            if tool then return tool end
        end
        for _, container in ipairs({char, backpack}) do
            for _, tool in ipairs(container:GetChildren()) do
                if tool:IsA("Tool") then
                    local name = tool.Name:lower()
                    if name:find("bat") or name:find("slap") then return tool end
                end
            end
        end
        return nil
    end

    local function getBatCounterTarget()
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then return nil, nil, math.huge end
        local closest, closestPlayer, minDist = nil, nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                local targetHum = player.Character:FindFirstChildOfClass("Humanoid")
                if targetRoot and targetHum and targetHum.Health > 0 then
                    local dist = (targetRoot.Position - root.Position).Magnitude
                    if dist < minDist then
                        closest, closestPlayer, minDist = targetRoot, player, dist
                    end
                end
            end
        end
        return closest, closestPlayer, minDist
    end

    local function swingBatForCounter(bat, char, isCurrent)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if bat.Parent ~= char then
            if hum then pcall(function() hum:EquipTool(bat) end) end
            task.wait(0.05)
        end
        if not isCurrent() then return end
        local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
        if remote and remote:IsA("RemoteEvent") then
            pcall(function() remote:FireServer() end)
            task.wait(0.15)
            if isCurrent() then pcall(function() remote:FireServer() end) end
        else
            pcall(function() bat:Activate() end)
            task.wait(0.15)
            if isCurrent() then pcall(function() bat:Activate() end) end
        end
    end

    function startBatCounter()
        if _G.KillHub.Connections.batCounter or not batCounterEnabled then return end
        _G.KillHub.Connections.batCounter = RunService.Heartbeat:Connect(function()
            if controller.character and controller.character ~= LP.Character then
                cancelCounterSwing()
            end
            if not batCounterEnabled or batCounterDebounce then return end
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then return end
            local state = hum:GetState()
            if state ~= Enum.HumanoidStateType.Physics
                and state ~= Enum.HumanoidStateType.Ragdoll
                and hum.PlatformStand ~= true then return end

            batCounterDebounce = true
            controller.character = char
            local generation = controller.generation
            local mode = uiVisual.batCounterMode
            local function isCurrent()
                return batCounterEnabled and controller.generation == generation
                    and LP.Character == char and hum.Health > 0
            end

            task.spawn(function()
                if not isCurrent() then return end
                pcall(function()
                    local bat = findBatForCounter()
                    if mode == "V2" then
                        _G.BlessBatCounterV2On = true
                        local root = char:FindFirstChild("HumanoidRootPart")
                        local target = getBatCounterTarget()
                        if root and target then
                            controller.root = root
                            pcall(function()
                                if sethiddenproperty then
                                    sethiddenproperty(root, "PhysicsRepRootPart", target)
                                end
                                root.CFrame = CFrame.new(root.Position, target.Position)
                            end)
                        end
                        if bat then
                            if bat.Parent ~= char then
                                pcall(function() hum:EquipTool(bat) end)
                                task.wait(0.05)
                            end
                            for _ = 1, 4 do
                                if not isCurrent() then return end
                                pcall(function() bat:Activate() end)
                                task.wait(0.05)
                            end
                            if not isCurrent() then return end
                            local remote = bat:FindFirstChildWhichIsA("RemoteEvent")
                            if remote then pcall(function() remote:FireServer() end) end
                        end
                        task.wait(0.7)
                    elseif bat then
                        swingBatForCounter(bat, char, isCurrent)
                    end
                end)
                if controller.generation ~= generation then return end
                releaseCounterRoot()
                task.wait(0.5)
                if controller.generation == generation then
                    controller.character = nil
                    batCounterDebounce = false
                end
            end)
        end)
        _G.KillHub.Active.batCounter = true
        if setBatCounterVisual then setBatCounterVisual(true) end
    end

    function stopBatCounter()
        if _G.KillHub.Connections.batCounter then
            _G.KillHub.Connections.batCounter:Disconnect()
            _G.KillHub.Connections.batCounter = nil
        end
        cancelCounterSwing()
        _G.KillHub.Active.batCounter = false
        if setBatCounterVisual then setBatCounterVisual(false) end
    end

    function uiVisual.refreshBatCounterMode()
        if uiVisual.batCounterModeButton then
            uiVisual.batCounterModeButton.Text = uiVisual.batCounterMode
        end
    end

    function uiVisual.setBatCounterMode(mode)
        if mode ~= "V1" and mode ~= "V2" then return end
        if uiVisual.batCounterMode ~= mode then
            stopBatCounter()
            uiVisual.batCounterMode = mode
            if batCounterEnabled then startBatCounter() end
        end
        uiVisual.refreshBatCounterMode()
    end

    function setBatCounterState(state)
        batCounterEnabled = state == true
        if batCounterEnabled then startBatCounter() else stopBatCounter() end
    end
    function toggleBatCounter(state) setBatCounterState(state) end
    if batCounterEnabled then startBatCounter() end
end

function findMedusa()local c=LP.Character if not c then return nil end for _,t in ipairs(c:GetChildren())do if t:IsA("Tool")then local n=t.Name:lower()if n:find("medusa")or n:find("head")or n:find("stone")then return t end end end local bp=LP:FindFirstChild("Backpack")if bp then for _,t in ipairs(bp:GetChildren())do if t:IsA("Tool")then local n=t.Name:lower()if n:find("medusa")or n:find("head")or n:find("stone")then return t end end end end return nil end function useMedusaCounter()if medusaDebounce then return end if tick()-medusaLastUsed<MEDUSA_COOLDOWN then return end local c=LP.Character if not c then return end medusaDebounce=true local med=findMedusa()if not med then medusaDebounce=false;return end if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid")if hum2 then hum2:EquipTool(med)end end pcall(function()med:Activate()end)medusaLastUsed=tick()medusaDebounce=false end function onAnchorChanged(part)return part:GetPropertyChangedSignal("Anchored"):Connect(function()if medusaCounterEnabled and part.Anchored and part.Transparency==1 then useMedusaCounter()end end)end function setupMedusa(char)for _,c in pairs(_G.KillHub.Connections.medusa)do pcall(function()c:Disconnect()end)end _G.KillHub.Connections.medusa={}if not char or not medusaCounterEnabled then return end for _,part in ipairs(char:GetDescendants())do if part:IsA("BasePart")then table.insert(_G.KillHub.Connections.medusa,onAnchorChanged(part))end end table.insert(_G.KillHub.Connections.medusa,char.DescendantAdded:Connect(function(part)if part:IsA("BasePart")then table.insert(_G.KillHub.Connections.medusa,onAnchorChanged(part))end end))end function stopMedusaCounter()for _,c in pairs(_G.KillHub.Connections.medusa)do pcall(function()c:Disconnect()end)end _G.KillHub.Connections.medusa={}_G.KillHub.Active.medusa=false end function setMedusaCounterState(state)medusaCounterEnabled=state if state then _G.KillHub.Active.medusa=true if LP.Character then setupMedusa(LP.Character)else stopMedusaCounter()end if setMedusaVisual then setMedusaVisual(true)end else stopMedusaCounter()if setMedusaVisual then setMedusaVisual(false)end end end
-- Bubble Drop: source ascent and return to the starting height.
dropMode=2
_G.dropActive=false;_G.IsDropping=false
function stopDropBrainrot()uiVisual.bubble.stopDrop()end
function runDropBrainrot(setVisual)
    local started=uiVisual.bubble.runDrop()
    if setVisual then setVisual(dropActive==true)end
    return started
end
function executeDropWithToggle(setVisual)
    if dropActive then return end
    runDropBrainrot(setVisual)
end
_G.doDrop=runDropBrainrot

function applyButtonScale(val)buttonScaleValue=math.clamp(val,0.50,1.50)local scale=buttonScaleValue local function scaleFloatingButton(btn)if not btn or not btn.Parent then return end if not btn:IsA("GuiButton")or btn:GetAttribute("FearHubFloatingButton")~=true then return end local oldScale=btn:FindFirstChild("ButtonScale")if oldScale then oldScale:Destroy()end local baseW=tonumber(btn:GetAttribute("FearHubBaseWidth"))or 56 local baseH=tonumber(btn:GetAttribute("FearHubBaseHeight"))or 56 local baseCorner=tonumber(btn:GetAttribute("FearHubBaseCorner"))or 10 local baseTextSize=tonumber(btn:GetAttribute("FearHubBaseTextSize"))or 10 btn.Size=UDim2.fromOffset(math.max(24,math.floor(baseW*scale+0.5)),math.max(24,math.floor(baseH*scale+0.5)))local corner=btn:FindFirstChildOfClass("UICorner")if corner then corner.CornerRadius=UDim.new(0,math.max(5,math.floor(baseCorner*scale+0.5)))end local lbl=btn:FindFirstChildWhichIsA("TextLabel")if lbl then lbl.TextSize=math.max(7,math.floor(baseTextSize*scale+0.5))end end if MobilePanel then for _,btn in ipairs(MobilePanel:GetChildren())do scaleFloatingButton(btn)end end if batV2FloatingButton and batV2FloatingButton.Parent then local btn=batV2FloatingButton:FindFirstChild("BatV2")scaleFloatingButton(btn)end  if uiVisual.ensureFloatVisible then task.defer(uiVisual.ensureFloatVisible)end end function applyButtonShape(mode)buttonShapeMode=tonumber(mode)==2 and 2 or 1 _G.BlessvsButtonShapeMode=buttonShapeMode _G.VeoraButtonShapeMode=buttonShapeMode local targetH=buttonShapeMode==2 and 34 or 56 local targetCorner=buttonShapeMode==2 and 7 or 10 local targetText=buttonShapeMode==2 and 9 or 10 local function updateOne(btn)if not btn or not btn.Parent or not btn:IsA("GuiButton")then return end if btn:GetAttribute("FearHubFloatingButton")~=true then return end btn:SetAttribute("FearHubBaseWidth",56)btn:SetAttribute("FearHubBaseHeight",targetH)btn:SetAttribute("FearHubBaseCorner",targetCorner)btn:SetAttribute("FearHubBaseTextSize",targetText)end if MobilePanel then for _,child in ipairs(MobilePanel:GetChildren())do updateOne(child)end end if batV2FloatingButton and batV2FloatingButton.Parent then updateOne(batV2FloatingButton:FindFirstChild("BatV2"))end applyButtonScale(buttonScaleValue)if MobilePanel then pcall(function()uiVisual.refreshTheme(MobilePanel)end)end if batV2FloatingButton and batV2FloatingButton.Parent then pcall(function()uiVisual.refreshTheme(batV2FloatingButton)end)end if _G.VeoraShapeRefresh then pcall(_G.VeoraShapeRefresh)end end local defLightBrightness=nil local defLightClock=nil local defLightAmbient=nil local defGlobalShadows=nil local defFogEnd=nil function applyAntiLagDerender(obj)if obj:GetAttribute("BlessSwordGlow")==true then return end pcall(function()if obj:IsA("Accessory")or obj:IsA("Hat")then local localChar=LP and LP.Character if localChar and obj:IsDescendantOf(localChar)then return end obj:Destroy()elseif obj:IsA("BasePart")then obj.Material=Enum.Material.Plastic obj.Reflectance=0 obj.CastShadow=false elseif obj:IsA("Decal")or obj:IsA("Texture")then obj.Transparency=1 elseif obj:IsA("ParticleEmitter")or obj:IsA("Trail")or obj:IsA("Beam")or obj:IsA("Fire")or obj:IsA("Smoke")or obj:IsA("Sparkles")then obj.Enabled=false elseif obj:IsA("AnimationController")or obj:IsA("Animator")then for _,t in ipairs(obj:GetPlayingAnimationTracks())do pcall(function()t:Stop(0)end)end end end)end;(function()local LightingService=game:GetService("Lighting")local state=rawget(_G,"M4LwareShinyGraphics")if type(state)~="table"then state={running=false,originals={},connections={},}_G.M4LwareShinyGraphics=state end local function disconnectAll()for _,connection in ipairs(state.connections or{})do pcall(function()connection:Disconnect()end)end state.connections={}end local function shinePart(object)if not(object and object:IsA("BasePart"))then return end if state.originals[object]==nil then state.originals[object]={Material=object.Material,Reflectance=object.Reflectance,CastShadow=object.CastShadow,}end object.Material=Enum.Material.SmoothPlastic object.Reflectance=0.75 object.CastShadow=false end local function getEffect(className,name)local effect=LightingService:FindFirstChild(name)if effect and not effect:IsA(className)then pcall(function()effect:Destroy()end)effect=nil end if not effect then effect=Instance.new(className)effect.Name=name effect.Parent=LightingService end return effect end local function applyEffects()local bloom=getEffect("BloomEffect","AceShinyBloom")bloom.Intensity=1.6 bloom.Size=52 bloom.Threshold=0.75 bloom.Enabled=true local rays=getEffect("SunRaysEffect","AceShinySunRays")rays.Intensity=0.55 rays.Spread=1 rays.Enabled=true local correction=getEffect("ColorCorrectionEffect","AceShinyColorCorrection")correction.Saturation=0.9 correction.Contrast=0.22 correction.Brightness=0.07 correction.Enabled=true end _G.M4StartShiny=function()_G.M4ShinyEnabled=true if state.running then pcall(applyEffects)return end state.running=true for _,object in ipairs(workspace:GetDescendants())do pcall(shinePart,object)end disconnectAll()state.connections[#state.connections+1]=workspace.DescendantAdded:Connect(function(object)if _G.M4ShinyEnabled==true then pcall(shinePart,object)end end)pcall(applyEffects)end _G.M4StopShiny=function()_G.M4ShinyEnabled=false state.running=false disconnectAll()for object,saved in pairs(state.originals)do pcall(function()if object and object.Parent then object.Material=saved.Material object.Reflectance=saved.Reflectance object.CastShadow=saved.CastShadow end end)end state.originals={}for _,name in ipairs({"AceShinyBloom","AceShinySunRays","AceShinyColorCorrection"})do local effect=LightingService:FindFirstChild(name)if effect then pcall(function()effect:Destroy()end)end end end end)()function enableAntiLag()removeAccessoriesEnabled=true antiLagEnabled=true _G.KillHub.Active.antiLag=true if defLightBrightness==nil then defLightBrightness=Lighting.Brightness defLightClock=Lighting.ClockTime defLightAmbient=Lighting.OutdoorAmbient defGlobalShadows=Lighting.GlobalShadows defFogEnd=Lighting.FogEnd end if uiVisual.performanceMode then local baseline=uiVisual.getPerformanceShadowBaseline()if baseline~=nil then defGlobalShadows=baseline end end Lighting.GlobalShadows=false Lighting.FogEnd=1e10 Lighting.Brightness=0 for _,e in pairs(Lighting:GetChildren())do pcall(function()if e:IsA("BlurEffect")or e:IsA("SunRaysEffect")or e:IsA("ColorCorrectionEffect")or e:IsA("BloomEffect")or e:IsA("DepthOfFieldEffect")then e.Enabled=false end end)end for _,obj in ipairs(workspace:GetDescendants())do applyAntiLagDerender(obj)end if _G.KillHub.Connections.antiLagDesc then _G.KillHub.Connections.antiLagDesc:Disconnect()end _G.KillHub.Connections.antiLagDesc=workspace.DescendantAdded:Connect(function(obj)if removeAccessoriesEnabled then applyAntiLagDerender(obj)end end)if setAntiLagVisual then setAntiLagVisual(true)end end function disableAntiLag()removeAccessoriesEnabled=false antiLagEnabled=false _G.KillHub.Active.antiLag=false if _G.KillHub.Connections.antiLagDesc then _G.KillHub.Connections.antiLagDesc:Disconnect()_G.KillHub.Connections.antiLagDesc=nil end if defLightBrightness~=nil then Lighting.Brightness=defLightBrightness end if defLightClock~=nil then Lighting.ClockTime=defLightClock end if defLightAmbient~=nil then Lighting.OutdoorAmbient=defLightAmbient end if defGlobalShadows~=nil then Lighting.GlobalShadows=defGlobalShadows end if defFogEnd~=nil then Lighting.FogEnd=defFogEnd end for _,e in pairs(Lighting:GetChildren())do pcall(function()if e:IsA("BlurEffect")or e:IsA("SunRaysEffect")or e:IsA("ColorCorrectionEffect")or e:IsA("BloomEffect")or e:IsA("DepthOfFieldEffect")then e.Enabled=true end end)end if uiVisual.performanceMode then uiVisual.updatePerformanceShadowBaseline(defGlobalShadows)end if setAntiLagVisual then setAntiLagVisual(false)end end function applyStretchFOV(val)local cam=workspace.CurrentCamera if cam then pcall(function()cam.FieldOfView=val end)end end function enableStretch()if _G.KillHub.Connections.stretch then return end _G.KillHub.Active.stretch=true stretchEnabled=true local cam=workspace.CurrentCamera if not cam then return end origFOV=cam.FieldOfView or 70 applyStretchFOV(120)_G.KillHub.Connections.stretch=RunService.RenderStepped:Connect(function()if not stretchEnabled then _G.KillHub.Connections.stretch:Disconnect()_G.KillHub.Connections.stretch=nil return end local c=workspace.CurrentCamera if c then c.CFrame=c.CFrame*CFrame.new(0,0,0,1,0,0,0,0.7,0,0,0,1)end end)if _G.KillHub.Connections.stretchFov then _G.KillHub.Connections.stretchFov:Disconnect()end _G.KillHub.Connections.stretchFov=RunService.RenderStepped:Connect(function()if stretchEnabled then applyStretchFOV(120)else _G.KillHub.Connections.stretchFov:Disconnect();_G.KillHub.Connections.stretchFov=nil end end)if _G.stretchToggleSetter then _G.stretchToggleSetter(true)end end function disableStretch()_G.KillHub.Active.stretch=false stretchEnabled=false if _G.KillHub.Connections.stretch then _G.KillHub.Connections.stretch:Disconnect()_G.KillHub.Connections.stretch=nil end if _G.KillHub.Connections.stretchFov then _G.KillHub.Connections.stretchFov:Disconnect()_G.KillHub.Connections.stretchFov=nil end local cam=workspace.CurrentCamera if cam then pcall(function()cam.FieldOfView=origFOV or 70 end)end if _G.stretchToggleSetter then _G.stretchToggleSetter(false)end end local function drag(f)local dn,ds,sp,di=false,nil,nil,nil f.Active=true f.InputBegan:Connect(function(i)if _isDraggingButton then return end if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dn=true ds=i.Position sp=f.Position di=i i.Changed:Connect(function()if i.UserInputState==Enum.UserInputState.End then dn=false di=nil task.defer(saveAllSettings)end end)end end)UIS.InputChanged:Connect(function(i)if not dn or not ds or not sp then return end if _isDraggingButton then return end if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then local nX=sp.X.Offset+(i.Position.X-ds.X)local nY=sp.Y.Offset+(i.Position.Y-ds.Y)f.Position=UDim2.new(sp.X.Scale,nX,sp.Y.Scale,nY)end end)UIS.InputEnded:Connect(function(i)if not dn then return end if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dn=false di=nil task.defer(saveAllSettings)end end)end 
function setupMovementAndIndicators(char)if _G.KillHub.Connections.stepped then _G.KillHub.Connections.stepped:Disconnect()_G.KillHub.Connections.stepped=nil end _G.KillHub.Connections.stepped=RunService.Stepped:Connect(function()for _,p in ipairs(Players:GetPlayers())do if p~=LP and p.Character then for _,part in ipairs(p.Character:GetChildren())do if part:IsA("BasePart")then part.CanCollide=false end end end end end)uiVisual.syncMovementSpeeds();syncSpeedModeState();CarrySystem:stop();CarrySystem:start()if _G.KillHub.Connections.movement then _G.KillHub.Connections.movement:Disconnect()_G.KillHub.Connections.movement=nil end _G.KillHub.Connections.movement=RunService.Heartbeat:Connect(function()uiVisual.syncMovementSpeeds();if speedLabel then if autoLeftEnabled or autoRightEnabled then speedLabel.Text="NORMAL:"..tostring(NS)elseif laggerToggled and laggerLevel==2 then speedLabel.Text="LAGGER CARRY:"..tostring(LAGGER_SPEED_2)elseif laggerToggled then speedLabel.Text="LAGGER NORMAL:"..tostring(LAGGER_SPEED_1)elseif speedMode then speedLabel.Text="CARRY:"..tostring(CS)else speedLabel.Text="NORMAL:"..tostring(NS)end end end)setupSpeedIndicator(char)startEnemySpeed()end
 function toggleLockUI(state)if state==nil then uiLocked=not uiLocked else uiLocked=state end if uiLocked and editModeEnabled then editModeEnabled=false if setEditModeVisual then setEditModeVisual(false)end end if setLockUIVisual then setLockUIVisual(uiLocked)end end function toggleEditMode(state)if state==nil then state=not editModeEnabled end if state and uiLocked then state=false end editModeEnabled=state if setEditModeVisual then setEditModeVisual(editModeEnabled)end end 
function disableAllAimbots()
    if batV2Enabled then stopBatV2() end
    if autoBatEnabled or _G.KillHub.Connections.aimbot then disableAutoBat() end
    if bypassToggled then stopBypassAimbot() end
end
 function stopAllBackgroundTasks()_G.KillHub.StopAll()if mikuSkyEnabled or mikuSkyThread then stopMikuSky()end for _,t in ipairs(dropConnections)do if type(t)=="thread"then pcall(task.cancel,t)elseif type(t)=="RBXScriptConnection"then pcall(t.Disconnect,t)end end dropConnections={}dropActive=false alPhase=1 arPhase=1 lastDropTime=0 medusaDebounce=false medusaLastUsed=0 end _G.FearCosmetics={BatEnabled=false,MedEnabled=false,OriginalTransparency=setmetatable({},{__mode="k"}),OriginalVolume=setmetatable({},{__mode="k"}),BoundTools=setmetatable({},{__mode="k"}),BoundSounds=setmetatable({},{__mode="k"}),WatchedContainers=setmetatable({},{__mode="k"}),LastBat=setmetatable({},{__mode="k"}),LastMed=setmetatable({},{__mode="k"}),LastBatActivate=setmetatable({},{__mode="k"}),BatSwingSound=setmetatable({},{__mode="k"}),BatTag="FearBatMinecraftSkin",MedTag="FearMedPokeballSkin",BatSound="rbxasset://sounds/swordslash.wav",MedSound="rbxasset://sounds/Rocket shot.wav"}function _G.FearCosmetics:IsBat(tool)if not tool or not tool:IsA("Tool")then return false end local n=tool.Name:lower()return n:find("bat",1,true)~=nil or n:find("slap",1,true)~=nil end function _G.FearCosmetics:IsMed(tool)if not tool or not tool:IsA("Tool")then return false end local n=tool.Name:lower()return n:find("medusa",1,true)~=nil or n:find("jellyfish",1,true)~=nil or n:find("jelly",1,true)~=nil end function _G.FearCosmetics:GetHandle(tool)local h=tool:FindFirstChild("Handle")if h and h:IsA("BasePart")then return h end for _,obj in ipairs(tool:GetChildren())do if obj:IsA("BasePart")then return obj end end end function _G.FearCosmetics:Clear(tool,tag)for _,obj in ipairs(tool:GetDescendants())do if obj:GetAttribute(tag)==true then obj:Destroy()end end end function _G.FearCosmetics:Hide(tool,tag)for _,obj in ipairs(tool:GetDescendants())do if obj:IsA("BasePart")and obj:GetAttribute(tag)~=true then if self.OriginalTransparency[obj]==nil then self.OriginalTransparency[obj]=obj.LocalTransparencyModifier end obj.LocalTransparencyModifier=1 end end end function _G.FearCosmetics:Restore(tool,tag)self:Clear(tool,tag)for _,obj in ipairs(tool:GetDescendants())do if obj:IsA("BasePart")and self.OriginalTransparency[obj]~=nil then obj.LocalTransparencyModifier=self.OriginalTransparency[obj]self.OriginalTransparency[obj]=nil end if obj:IsA("Sound")and self.OriginalVolume[obj]~=nil then obj.Volume=self.OriginalVolume[obj]self.OriginalVolume[obj]=nil end end end function _G.FearCosmetics:Part(tool,handle,tag,name,size,offset,color,material,shape)local p=Instance.new("Part")p.Name=name p.Size=size p.Color=color p.Material=material or Enum.Material.SmoothPlastic p.Shape=shape or Enum.PartType.Block p.Anchored=false p.CanCollide=false p.CanTouch=false p.CanQuery=false p.Massless=true p.CastShadow=false p.TopSurface=Enum.SurfaceType.Smooth p.BottomSurface=Enum.SurfaceType.Smooth p.CFrame=handle.CFrame*offset p:SetAttribute(tag,true)p.Parent=tool local w=Instance.new("WeldConstraint")w.Part0=handle w.Part1=p w:SetAttribute(tag,true)w.Parent=p return p end function _G.FearCosmetics:Play(soundId,volume,speed)local s=Instance.new("Sound")s.Name="FearCosmeticSound"s.SoundId=soundId s.Volume=volume or 1 s.PlaybackSpeed=speed or 1 s.Parent=SoundService s:Play()game:GetService("Debris"):AddItem(s,3)end function _G.FearCosmetics:ApplyBat(tool)if not self.BatEnabled or not self:IsBat(tool)then return end local h=self:GetHandle(tool)if not h then return end self:Clear(tool,self.BatTag)self:Hide(tool,self.BatTag)local specs={{"Grip1",Vector3.new(0.26,0.34,0.34),Vector3.new(0,-1.12,0),Enum.Material.SmoothPlastic},{"Grip2",Vector3.new(0.26,0.34,0.34),Vector3.new(0,-0.78,0),Enum.Material.SmoothPlastic},{"Grip3",Vector3.new(0.26,0.34,0.34),Vector3.new(0,-0.44,0),Enum.Material.SmoothPlastic},{"PommelCenter",Vector3.new(0.26,0.30,0.52),Vector3.new(0,-1.48,0),Enum.Material.Neon},{"PommelLeft",Vector3.new(0.26,0.30,0.30),Vector3.new(0,-1.48,-0.40),Enum.Material.Neon},{"PommelRight",Vector3.new(0.26,0.30,0.30),Vector3.new(0,-1.48,0.40),Enum.Material.Neon},{"GuardCenter",Vector3.new(0.26,0.30,1.42),Vector3.new(0,-0.08,0),Enum.Material.Neon},{"GuardLeft",Vector3.new(0.26,0.30,0.34),Vector3.new(0,-0.08,-0.88),Enum.Material.Neon},{"GuardRight",Vector3.new(0.26,0.30,0.34),Vector3.new(0,-0.08,0.88),Enum.Material.Neon},{"GuardLeftStep",Vector3.new(0.26,0.30,0.34),Vector3.new(0,0.20,-0.68),Enum.Material.Neon},{"GuardRightStep",Vector3.new(0.26,0.30,0.34),Vector3.new(0,0.20,0.68),Enum.Material.Neon},{"BladeBase",Vector3.new(0.24,0.40,0.72),Vector3.new(0,0.32,0),Enum.Material.Neon},{"Blade1",Vector3.new(0.24,0.46,0.72),Vector3.new(0,0.73,0),Enum.Material.Neon},{"Blade2",Vector3.new(0.24,0.46,0.72),Vector3.new(0,1.19,0),Enum.Material.Neon},{"Blade3",Vector3.new(0.24,0.46,0.72),Vector3.new(0,1.65,0),Enum.Material.Neon},{"Blade4",Vector3.new(0.24,0.46,0.72),Vector3.new(0,2.11,0),Enum.Material.Neon},{"Blade5",Vector3.new(0.24,0.46,0.72),Vector3.new(0,2.57,0),Enum.Material.Neon},{"TipWide",Vector3.new(0.24,0.34,0.54),Vector3.new(0,2.97,0),Enum.Material.Neon},{"TipMid",Vector3.new(0.24,0.30,0.38),Vector3.new(0,3.29,0),Enum.Material.Neon},{"TipTop",Vector3.new(0.24,0.26,0.22),Vector3.new(0,3.57,0),Enum.Material.Neon}}for i,spec in ipairs(specs)do local hue=(i-1)/#specs local sat=spec[1]:find("Grip")and 0.72 or 0.90 local val=spec[1]:find("Grip")and 0.62 or 1 self:Part(tool,h,self.BatTag,spec[1],spec[2],CFrame.new(spec[3]),Color3.fromHSV(hue,sat,val),spec[4],Enum.PartType.Block)end end function _G.FearCosmetics:ApplyMed(tool)if not self.MedEnabled or not self:IsMed(tool)then return end local h=self:GetHandle(tool)if not h then return end self:Clear(tool,self.MedTag)self:Hide(tool,self.MedTag)self:Part(tool,h,self.MedTag,"PokeballCore",Vector3.new(2.05,2.05,2.05),CFrame.new(),Color3.fromRGB(240,240,240),Enum.Material.SmoothPlastic,Enum.PartType.Ball)self:Part(tool,h,self.MedTag,"PokeballTop",Vector3.new(1.86,1.16,1.86),CFrame.new(0,0.27,0),Color3.fromRGB(205,38,42),Enum.Material.SmoothPlastic,Enum.PartType.Ball)local shine=self:Part(tool,h,self.MedTag,"PokeballShine",Vector3.new(0.56,0.30,0.18),CFrame.new(-0.34,0.52,-0.78)*CFrame.Angles(math.rad(-18),math.rad(18),math.rad(10)),Color3.fromRGB(255,255,255),Enum.Material.Neon,Enum.PartType.Ball)shine.Transparency=0.42 self:Part(tool,h,self.MedTag,"PokeballBand",Vector3.new(0.15,2.08,2.08),CFrame.Angles(0,0,math.rad(90)),Color3.fromRGB(18,18,18),Enum.Material.SmoothPlastic,Enum.PartType.Cylinder)self:Part(tool,h,self.MedTag,"PokeballButtonBase",Vector3.new(0.50,0.50,0.50),CFrame.new(0,0,-1.00),Color3.fromRGB(18,18,18),Enum.Material.SmoothPlastic,Enum.PartType.Ball)self:Part(tool,h,self.MedTag,"PokeballButton",Vector3.new(0.30,0.30,0.30),CFrame.new(0,0,-1.13),Color3.fromRGB(250,250,250),Enum.Material.SmoothPlastic,Enum.PartType.Ball)end function _G.FearCosmetics:IsBatHitSound(sound)local n=tostring(sound.Name or""):lower()return n:find("hit",1,true)~=nil or n:find("impact",1,true)~=nil or n:find("damage",1,true)~=nil or n:find("smack",1,true)~=nil or n:find("bonk",1,true)~=nil or n:find("contact",1,true)~=nil end function _G.FearCosmetics:IsBatSwingSound(sound)local n=tostring(sound.Name or""):lower()return n:find("swing",1,true)~=nil or n:find("whoosh",1,true)~=nil or n:find("swoosh",1,true)~=nil or n:find("slash",1,true)~=nil or n:find("attack",1,true)~=nil end function _G.FearCosmetics:MuteOnlyBatSwing(sound)if self.OriginalVolume[sound]==nil then self.OriginalVolume[sound]=sound.Volume end sound.Volume=0 end function _G.FearCosmetics:BindSound(tool,sound)if not sound or not sound:IsA("Sound")or self.BoundSounds[sound]then return end self.BoundSounds[sound]=true pcall(function()sound.Played:Connect(function()if self:IsBat(tool)and self.BatEnabled then if self:IsBatHitSound(sound)then if self.OriginalVolume[sound]~=nil then sound.Volume=self.OriginalVolume[sound]end return end local now=os.clock()local sinceActivate=now-(self.LastBatActivate[tool]or-100)local knownSwing=self.BatSwingSound[tool]local isSwing=self:IsBatSwingSound(sound)or knownSwing==sound or(knownSwing==nil and sinceActivate>=0 and sinceActivate<=0.13)if isSwing then if knownSwing==nil then self.BatSwingSound[tool]=sound end self:MuteOnlyBatSwing(sound)else if self.OriginalVolume[sound]~=nil then sound.Volume=self.OriginalVolume[sound]end end elseif self:IsMed(tool)and self.MedEnabled then if self.OriginalVolume[sound]==nil then self.OriginalVolume[sound]=sound.Volume end sound.Volume=0 end end)end)if self:IsBat(tool)and self.BatEnabled then if self:IsBatSwingSound(sound)then if self.OriginalVolume[sound]==nil then self.OriginalVolume[sound]=sound.Volume end self.BatSwingSound[tool]=self.BatSwingSound[tool]or sound sound.Volume=0 elseif self:IsBatHitSound(sound)and self.OriginalVolume[sound]~=nil then sound.Volume=self.OriginalVolume[sound]end elseif self:IsMed(tool)and self.MedEnabled then if self.OriginalVolume[sound]==nil then self.OriginalVolume[sound]=sound.Volume end sound.Volume=0 end end function _G.FearCosmetics:BindTool(tool)if not tool or not tool:IsA("Tool")then return end for _,obj in ipairs(tool:GetDescendants())do if obj:IsA("Sound")then self:BindSound(tool,obj)end end if not self.BoundTools[tool]then self.BoundTools[tool]=true if self:IsBat(tool)then tool.Activated:Connect(function()self.LastBatActivate[tool]=os.clock()end)end tool.DescendantAdded:Connect(function(obj)if obj:IsA("Sound")then task.defer(function()if obj.Parent then self:BindSound(tool,obj)end end)end end)end if self.BatEnabled and self:IsBat(tool)then self:ApplyBat(tool)end if self.MedEnabled and self:IsMed(tool)then self:ApplyMed(tool)end end function _G.FearCosmetics:Scan(container)if not container then return end for _,obj in ipairs(container:GetChildren())do if obj:IsA("Tool")then self:BindTool(obj)end end end function _G.FearCosmetics:Watch(container)if not container or self.WatchedContainers[container]then return end self.WatchedContainers[container]=true self:Scan(container)container.ChildAdded:Connect(function(obj)if obj:IsA("Tool")then task.defer(function()self:BindTool(obj)end)end end)end function _G.FearCosmetics:SetBat(on)self.BatEnabled=on==true self:Scan(LP.Character)self:Scan(LP:FindFirstChild("Backpack"))for _,container in ipairs({LP.Character,LP:FindFirstChild("Backpack")})do if container then for _,tool in ipairs(container:GetChildren())do if tool:IsA("Tool")and self:IsBat(tool)then self:BindTool(tool)if self.BatEnabled then self:ApplyBat(tool)for _,obj in ipairs(tool:GetDescendants())do if obj:IsA("Sound")then if self:IsBatSwingSound(obj)then if self.OriginalVolume[obj]==nil then self.OriginalVolume[obj]=obj.Volume end self.BatSwingSound[tool]=self.BatSwingSound[tool]or obj obj.Volume=0 elseif self:IsBatHitSound(obj)and self.OriginalVolume[obj]~=nil then obj.Volume=self.OriginalVolume[obj]end end end local swing=self.BatSwingSound[tool]if swing and swing.Parent then self:MuteOnlyBatSwing(swing)end else self:Restore(tool,self.BatTag)self.BatSwingSound[tool]=nil self.LastBatActivate[tool]=nil end end end end end end function _G.FearCosmetics:SetMed(on)self.MedEnabled=on==true self:Scan(LP.Character)self:Scan(LP:FindFirstChild("Backpack"))for _,container in ipairs({LP.Character,LP:FindFirstChild("Backpack")})do if container then for _,tool in ipairs(container:GetChildren())do if tool:IsA("Tool")and self:IsMed(tool)then self:BindTool(tool)if self.MedEnabled then self:ApplyMed(tool)for _,obj in ipairs(tool:GetDescendants())do if obj:IsA("Sound")then if self.OriginalVolume[obj]==nil then self.OriginalVolume[obj]=obj.Volume end obj.Volume=0 end end else self:Restore(tool,self.MedTag)end end end end end end task.defer(function()local bag=LP:WaitForChild("Backpack")_G.FearCosmetics:Watch(bag)if LP.Character then _G.FearCosmetics:Watch(LP.Character)end LP.CharacterAdded:Connect(function(char)_G.FearCosmetics:Watch(char)end)end)_G.M4ExtrasAPI=(function()local API={}local state=_G.M4Extras or{baseXRayEnabled=false,brainrotXRayEnabled=false,transparentWeapons=false,weaponSkinsEnabled=false,weaponSoundsEnabled=false,rainbowWeaponsEnabled=false,batWeaponSkin="DiamondSword",medWeaponSkin="GoldenDesertEagle",}_G.M4Extras=state if state.baseXRayEnabled==nil then state.baseXRayEnabled=false end if state.brainrotXRayEnabled==nil then state.brainrotXRayEnabled=false end if state.transparentWeapons==nil then state.transparentWeapons=false end if state.weaponSkinsEnabled==nil then state.weaponSkinsEnabled=false end if state.weaponSoundsEnabled==nil then state.weaponSoundsEnabled=false end if state.rainbowWeaponsEnabled==nil then state.rainbowWeaponsEnabled=false end if state.swordGlowEnabled==nil then state.swordGlowEnabled=false end state.batWeaponSkin=state.batWeaponSkin or"DiamondSword"state.medWeaponSkin=state.medWeaponSkin or"GoldenDesertEagle"local toolAssets={Halloween={cat="Bat",label="Halloween",kind="Halloween",mesh="rbxassetid://13528902482"},DiamondSword={cat="Bat",label="Diamond Sword",mesh="rbxassetid://8827558932",tex="rbxassetid://8827558969",scale=Vector3.new(0.2,0.2,0.2),c0=CFrame.new(-0.05,-0.1,-0.12)*CFrame.Angles(math.rad(90),math.rad(180),300)},Katana={cat="Bat",label="Katana",mesh="rbxassetid://13528902482",tex="rbxassetid://13528902373",scale=Vector3.new(1.4,1.4,1.4),c0=CFrame.new(0,0.6,0)*CFrame.Angles(math.rad(270),math.rad(180),math.rad(180))},Sword49={cat="Bat",label="Sword 49",kind="Sword49",id=9108309987,length=4.050,palmInset=0.180,gripSide=-1,pos=Vector3.new(0,0,0),rot=Vector3.new(0,0,75)},Skull={cat="Medusa",label="Skull",mesh="rbxassetid://2050312704",tex="rbxassetid://2050313393",scale=Vector3.new(1,1,1),c0=CFrame.new(0,0.65,-0.4)*CFrame.Angles(math.rad(330),0,0)},GoldenDesertEagle={cat="Medusa",label="Golden Desert Eagle",mesh="rbxassetid://430251413",tex="rbxassetid://435840335",scale=Vector3.new(0.01,0.01,0.01),c0=CFrame.new(0,0,-0.8)*CFrame.Angles(math.rad(330),math.rad(180),0)},KillMinecraft={cat="Bat",label="Minecraft",kind="KillMinecraft"},KillDefault={cat="Bat",label="Default",kind="KillAura"},KillAbyssBlue={cat="Bat",label="Abyss Blue",kind="KillAura",color=Color3.fromRGB(0,40,150)},KillVenomGreen={cat="Bat",label="Venom Green",kind="KillAura",color=Color3.fromRGB(20,255,50)},KillRoyalGold={cat="Bat",label="Royal Gold",kind="KillAura",color=Color3.fromRGB(255,200,0)},KillVelvetRose={cat="Bat",label="Velvet Rose",kind="KillAura",color=Color3.fromRGB(220,20,100)},KillCrimsonNight={cat="Bat",label="Crimson Night",kind="KillAura",color=Color3.fromRGB(90,0,20)},KillRGB={cat="Bat",label="RGB",kind="KillAura",rgb=true},}API.toolAssets=toolAssets API.batSkinOrder={"DiamondSword","Katana","Halloween","Sword49","KillMinecraft","KillDefault","KillAbyssBlue","KillVenomGreen","KillRoyalGold","KillVelvetRose","KillCrimsonNight","KillRGB"}API.medSkinOrder={"GoldenDesertEagle","Skull"}local killSwordTemplate=nil pcall(function()local objects=game:GetObjects("rbxassetid://18566246244")if type(objects)=="table"and#objects>0 then local source=objects[1]local part=source:IsA("BasePart")and source or source:FindFirstChildWhichIsA("BasePart",true)if part then killSwordTemplate=part:Clone()killSwordTemplate.Parent=nil for _,d in ipairs(killSwordTemplate:GetDescendants())do if d:IsA("Sound")or d:IsA("Weld")or d:IsA("WeldConstraint")or d:IsA("Motor6D")then d:Destroy()end end end pcall(function()source:Destroy()end)end end)local function setKillSwordColor(obj,color)if not obj or not color then return end if obj:IsA("BasePart")then obj.Color=color if obj:IsA("UnionOperation")then obj.UsePartColor=true end end local mesh=obj:FindFirstChildWhichIsA("SpecialMesh")if mesh then mesh.VertexColor=Vector3.new(color.R,color.G,color.B)end end local originalVisual=setmetatable({},{__mode="k"})local originalVolume=setmetatable({},{__mode="k"})local soundHooks=setmetatable({},{__mode="k"})local toolSoundWatch=setmetatable({},{__mode="k"})local nativeSoundDebounce=setmetatable({},{__mode="k"})local lastBatActivate=setmetatable({},{__mode="k"})local lastWeaponActivate=setmetatable({},{__mode="k"})local lastSwingSound=setmetatable({},{__mode="k"})local lastMirroredUse=setmetatable({},{__mode="k"})local lastHitSound=setmetatable({},{__mode="k"})local hitWatchConns=setmetatable({},{__mode="k"})local hitWatchPlayerConns=setmetatable({},{__mode="k"})local rainbowOriginal=setmetatable({},{__mode="k"})local rainbowConn=nil local rainbowAcc=0 local function toolCategory(tool)if not tool or not tool:IsA("Tool")then return nil end local n=tool.Name:lower()if n:find("bat",1,true)or n:find("slap",1,true)then return"Bat"end if n:find("medusa",1,true)or n:find("jelly",1,true)then return"Medusa"end return nil end local function getHandle(tool)local h=tool and tool:FindFirstChild("Handle")if h and h:IsA("BasePart")then return h end if tool then for _,d in ipairs(tool:GetChildren())do if d:IsA("BasePart")then return d end end end return nil end local function saveOriginal(obj)if originalVisual[obj]~=nil then return end if obj:IsA("BasePart")then originalVisual[obj]={kind="BasePart",value=obj.LocalTransparencyModifier}elseif obj:IsA("Decal")or obj:IsA("Texture")then originalVisual[obj]={kind="Texture",value=obj.Transparency}end end local function setHidden(obj,hidden)if not(obj:IsA("BasePart")or obj:IsA("Decal")or obj:IsA("Texture"))then return end if obj:FindFirstAncestor("M4LocalReplica")then return end saveOriginal(obj)pcall(function()if obj:IsA("BasePart")then obj.LocalTransparencyModifier=hidden and 1 or(originalVisual[obj]and originalVisual[obj].value or 0)else obj.Transparency=hidden and 1 or(originalVisual[obj]and originalVisual[obj].value or 0)end end)end local function clearReplica(tool)if not tool then return end for _,d in ipairs(tool:GetDescendants())do if d.Name=="M4LocalReplica"then pcall(function()d:Destroy()end)end end end local function buildReplica(tool,key)local data=toolAssets[key]local handle=getHandle(tool)if not data or not handle then return end clearReplica(tool)local model=Instance.new("Model")model.Name="M4LocalReplica"
if data.kind == "Halloween" then
        local part = Instance.new("Part")
        part.Name = "SwordPart"
        part.Size = Vector3.new(1, 1, 1)
        part.Transparency = 0
        part.CanCollide = false
        part.CanTouch = false
        part.CanQuery = false
        part.Massless = true
        part.Anchored = false
        part.Parent = model

        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = data.mesh
        
        mesh.TextureId = ""
        mesh.Scale = Vector3.new(1.4, 1.4, 1.4)
        mesh.Parent = part

        local ORANGE = Color3.fromRGB(255, 140, 0)
        part.Material = Enum.Material.Neon
        part.Color = ORANGE
        part.Reflectance = 0.15
        mesh.VertexColor = Vector3.new(1, 0.55, 0)

        local glow = Instance.new("PointLight")
        glow.Name = "ShelSwordGlow"
        glow.Brightness = 4
        glow.Range = 14
        glow.Color = ORANGE
        glow.Parent = part

        model.PrimaryPart = part
        model.Parent = handle
        part.CFrame = handle.CFrame * (
            CFrame.new(0, 0.6, 0)
            * CFrame.Angles(math.rad(270), math.rad(180), math.rad(180))
        )

        local weld = Instance.new("WeldConstraint")
        weld.Part0 = handle
        weld.Part1 = part
        weld.Parent = part

        model:SetAttribute("M4SkinKey", key)
        part:SetAttribute("BlessSwordGlow", true)
        mesh:SetAttribute("BlessSwordGlow", true)
        glow:SetAttribute("BlessSwordGlow", true)
        return
end
if data.kind=="Sword49"then local char=LP.Character local hand=char and(char:FindFirstChild("RightHand")or char:FindFirstChild("Right Arm")or char:FindFirstChild("RightLowerArm"))if not char or tool.Parent~=char or not hand then model:Destroy()return end local ok,objects=pcall(function()return game:GetObjects("rbxassetid://"..tostring(data.id))end)if not ok or type(objects)~="table"or#objects==0 then model:Destroy()return end local source=objects[1]local swordModel if source:IsA("Model")then swordModel=source else swordModel=Instance.new("Model")swordModel.Name="Sword49Source"if source:IsA("BasePart")then source.Parent=swordModel else for _,child in ipairs(source:GetChildren())do child.Parent=swordModel end pcall(function()source:Destroy()end)end end for _,d in ipairs(swordModel:GetDescendants())do if d:IsA("Script")or d:IsA("LocalScript")or d:IsA("ModuleScript")or d:IsA("Sound")or d:IsA("TouchTransmitter")or d:IsA("ClickDetector")or d:IsA("ProximityPrompt")or d:IsA("BodyMover")or d:IsA("LinearVelocity")or d:IsA("AngularVelocity")or d:IsA("AlignPosition")or d:IsA("AlignOrientation")or d:IsA("Weld")or d:IsA("WeldConstraint")or d:IsA("Motor6D")or d:IsA("JointInstance")or d:IsA("Constraint")then pcall(function()d:Destroy()end)end end local function partsOf(root)local out={}for _,d in ipairs(root:GetDescendants())do if d:IsA("BasePart")then out[#out+1]=d end end return out end local function longestAxis(size)if size.X>=size.Y and size.X>=size.Z then return 1,size.X elseif size.Y>=size.X and size.Y>=size.Z then return 2,size.Y else return 3,size.Z end end local function smallestOtherAxis(size,longAxis)local vals={size.X,size.Y,size.Z}local best,bestVal=nil,math.huge for i=1,3 do if i~=longAxis and vals[i]<bestVal then best=i bestVal=vals[i]end end return best end local function axisVector(cf,axis)if axis==1 then return cf.RightVector end if axis==2 then return cf.UpVector end return-cf.LookVector end local dirs={Vector3.new(1,0,0),Vector3.new(-1,0,0),Vector3.new(0,1,0),Vector3.new(0,-1,0),Vector3.new(0,0,1),Vector3.new(0,0,-1)}local rotations={}for _,x in ipairs(dirs)do for _,y in ipairs(dirs)do if math.abs(x:Dot(y))<0.01 then local z=x:Cross(y)if z.Magnitude>0.9 then rotations[#rotations+1]=CFrame.fromMatrix(Vector3.zero,x,y,z.Unit)end end end end local function bestRotation(longAxis,thinAxis,gripSide)local wantedLong=handle.CFrame.LookVector if gripSide>0 then wantedLong=-wantedLong end local wantedThin=handle.CFrame.UpVector local best,bestScore=CFrame.new(),-math.huge for _,cf in ipairs(rotations)do local longWorld=axisVector(cf,longAxis)local thinWorld=axisVector(cf,thinAxis)local score=longWorld:Dot(wantedLong)*10 score=score+math.abs(thinWorld:Dot(wantedThin))*2 if score>bestScore then bestScore=score best=cf end end return best end local function scaleModel(root,factor)local bbox=root:GetBoundingBox()for _,part in ipairs(partsOf(root))do local rel=bbox:ToObjectSpace(part.CFrame)local rx,ry,rz=rel:ToOrientation()part.Size=Vector3.new(math.max(part.Size.X*factor,0.01),math.max(part.Size.Y*factor,0.01),math.max(part.Size.Z*factor,0.01))part.CFrame=bbox*CFrame.new(rel.Position*factor)*CFrame.Angles(rx,ry,rz)end end local function moveBBox(root,target)local current=root:GetBoundingBox()local delta=target*current:Inverse()for _,part in ipairs(partsOf(root))do part.CFrame=delta*part.CFrame end end local function handGripPoint()local att=hand:FindFirstChild("RightGripAttachment")if att and att:IsA("Attachment")then return att.WorldPosition end for _,d in ipairs(hand:GetDescendants())do if d:IsA("Attachment")and d.Name:lower():find("grip",1,true)then return d.WorldPosition end end if hand:IsA("BasePart")then if hand.Name=="RightHand"then return hand.CFrame:PointToWorldSpace(Vector3.new(0,-0.08,0))end return hand.CFrame:PointToWorldSpace(Vector3.new(0,-hand.Size.Y*0.45,0))end return handle.Position end swordModel.Parent=workspace local bboxCF,bboxSize=swordModel:GetBoundingBox()local longAxis,longLen=longestAxis(bboxSize)local factor=data.length/math.max(longLen,0.01)scaleModel(swordModel,factor)bboxCF,bboxSize=swordModel:GetBoundingBox()longAxis,longLen=longestAxis(bboxSize)local thinAxis=smallestOtherAxis(bboxSize,longAxis)local rot=bestRotation(longAxis,thinAxis,data.gripSide)*CFrame.Angles(math.rad(data.rot.X),math.rad(data.rot.Y),math.rad(data.rot.Z))local minecraftGripCenter=(handle.CFrame*CFrame.new(0,0,0.78)).Position local bladeDirection=handle.CFrame.LookVector if data.gripSide>0 then bladeDirection=-bladeDirection end local manualOffset=handle.CFrame.RightVector*data.pos.X+handle.CFrame.UpVector*data.pos.Y+handle.CFrame.LookVector*data.pos.Z local center=minecraftGripCenter+bladeDirection*(longLen*0.5-data.palmInset)+manualOffset moveBBox(swordModel,CFrame.new(center)*rot)swordModel.Name="M4LocalReplica"swordModel:SetAttribute("M4SkinKey",key)swordModel.Parent=handle for _,part in ipairs(partsOf(swordModel))do part.Anchored=false part.CanCollide=false part.CanTouch=false part.CanQuery=false part.Massless=true local weld=Instance.new("WeldConstraint")weld.Part0=handle weld.Part1=part weld.Parent=part end return end if data.kind=="KillMinecraft"then model.Parent=handle local function addBlock(size,offset,color)local part=Instance.new("Part")part.Name="MainPart"part.Size=size part.Color=color part.Material=Enum.Material.SmoothPlastic part.Anchored=false part.CanCollide=false part.CanTouch=false part.CanQuery=false part.Massless=true part.CastShadow=false part.CFrame=handle.CFrame*offset part.Parent=model local weld=Instance.new("WeldConstraint")weld.Part0=handle weld.Part1=part weld.Parent=part end local cyan=Color3.fromRGB(61,214,205)local light=Color3.fromRGB(112,245,232)local dark=Color3.fromRGB(32,70,68)local grip=Color3.fromRGB(72,47,32)addBlock(Vector3.new(0.34,0.34,1.15),CFrame.new(0,0,-0.42),cyan)addBlock(Vector3.new(0.30,0.30,0.62),CFrame.new(0,0,-1.25),light)addBlock(Vector3.new(0.26,0.26,0.46),CFrame.new(0,0,-1.78),cyan)addBlock(Vector3.new(1.05,0.22,0.24),CFrame.new(0,0,0.25),dark)addBlock(Vector3.new(0.24,0.24,0.82),CFrame.new(0,0,0.78),grip)addBlock(Vector3.new(0.42,0.32,0.25),CFrame.new(0,0,1.30),dark)model:SetAttribute("M4SkinKey",key)return end if data.kind=="KillAura"then if not killSwordTemplate then return end local part=killSwordTemplate:Clone()part.Name="MainPart"part.Anchored=false part.CanCollide=false part.CanTouch=false part.CanQuery=false part.Massless=true for _,d in ipairs(part:GetDescendants())do if d:IsA("Sound")or d:IsA("Weld")or d:IsA("WeldConstraint")or d:IsA("Motor6D")then d:Destroy()end end local temp=Instance.new("Model")part.Parent=temp temp.PrimaryPart=part pcall(function()temp:ScaleTo(2)end)part.Parent=model temp:Destroy()if data.rgb then setKillSwordColor(part,Color3.fromHSV((tick()%3)/3,1,1))elseif data.color then setKillSwordColor(part,data.color)end part.CFrame=handle.CFrame*CFrame.new(-0.02,-0.52,-0.2)*CFrame.Angles(math.rad(45),0,math.rad(5))local weld=Instance.new("WeldConstraint")weld.Part0=handle weld.Part1=part weld.Parent=part model:SetAttribute("M4SkinKey",key)model.Parent=handle return end local part=Instance.new("Part")part.Name="MainPart"part.Size=Vector3.new(1,1,1)part.Anchored=false part.CanCollide=false part.CanTouch=false part.CanQuery=false part.Massless=true part.Parent=model local mesh=Instance.new("SpecialMesh")mesh.MeshType=Enum.MeshType.FileMesh mesh.MeshId=data.mesh mesh.TextureId=data.tex mesh.Scale=data.scale mesh.Parent=part local motor=Instance.new("Motor6D")motor.Part0=handle motor.Part1=part motor.C0=data.c0 motor.Parent=part model:SetAttribute("M4SkinKey",key)model.Parent=handle end local function restoreToolVisual(tool)clearReplica(tool)for _,d in ipairs(tool:GetDescendants())do if originalVisual[d]then setHidden(d,false)end end end local function isBatSwingSound(snd)local n=tostring(snd and snd.Name or""):lower()return n:find("swing",1,true)~=nil or n:find("whoosh",1,true)~=nil or n:find("swoosh",1,true)~=nil or n:find("slash",1,true)~=nil or n:find("attack",1,true)~=nil end local function isBatHitSound(snd)local n=tostring(snd and snd.Name or""):lower()return n:find("hit",1,true)~=nil or n:find("impact",1,true)~=nil or n:find("damage",1,true)~=nil or n:find("smack",1,true)~=nil or n:find("bonk",1,true)~=nil or n:find("contact",1,true)~=nil end local function playWeaponCustom(tool,cat,kind)if not tool or not cat then return end local isHit=(kind=="hit")if isHit and cat=="Bat"then return end if not state.weaponSoundsEnabled then return end local now=os.clock()local bucket=isHit and lastHitSound or lastSwingSound local cooldown=isHit and 0.14 or 0.09 if now-(bucket[tool]or 0)<cooldown then return end bucket[tool]=now local snd=Instance.new("Sound")snd.Name=isHit and"M4WeaponHitCustom"or"M4WeaponSwingCustom"snd.Volume=(cat=="Medusa")and 1.15 or 1.0 snd.Looped=false if cat=="Medusa"then snd.SoundId="rbxassetid://3102797479"snd.PlaybackSpeed=isHit and 1.0 or 1.05 else snd.SoundId="rbxassetid://5713085119"snd.TimePosition=0.2 snd.PlaybackSpeed=isHit and 0.98 or 1.0 end snd.Parent=game:GetService("SoundService")snd:Play()game:GetService("Debris"):AddItem(snd,3)end local function isM4CustomSound(snd)if not snd or not snd:IsA("Sound")then return false end local n=tostring(snd.Name or"")return n=="M4CustomSound"or n=="M4ConfirmedBatHit"or n=="M4WeaponSwingCustom"or n=="M4WeaponHitCustom"or n=="M4LWAREToggleSFX"end local function muteBatNativeSounds(tool)if not tool then return end for _,snd in ipairs(tool:GetDescendants())do if snd:IsA("Sound")and not isM4CustomSound(snd)then if isBatHitSound(snd)then if originalVolume[snd]~=nil then pcall(function()snd.Volume=originalVolume[snd]end)end elseif isBatSwingSound(snd)then if originalVolume[snd]==nil then originalVolume[snd]=snd.Volume end pcall(function()snd.Volume=0 if snd.Playing then snd:Stop()end end)end end end end local function restoreConfirmedHitSounds(tool,targetChar)local function restoreNamed(root)if not root then return end for _,snd in ipairs(root:GetDescendants())do if snd:IsA("Sound")and not isM4CustomSound(snd)and isBatHitSound(snd)then if originalVolume[snd]~=nil then pcall(function()snd.Volume=originalVolume[snd]end)elseif snd.Volume<=0 then pcall(function()snd.Volume=1 end)end end end end restoreNamed(tool)restoreNamed(LP.Character)restoreNamed(targetChar)restoreNamed(game:GetService("SoundService"))end local function playConfirmedBatHit(tool,targetChar)restoreConfirmedHitSounds(tool,targetChar)end local function hookOriginalSound(tool,cat,snd)if not snd or not snd:IsA("Sound")then return end if snd.Name=="M4CustomSound"or snd.Name=="M4ConfirmedBatHit"or snd.Name=="M4WeaponSwingCustom"or snd.Name=="M4WeaponHitCustom"then return end if originalVolume[snd]==nil then originalVolume[snd]=snd.Volume end if soundHooks[snd]then return end local conns={}local function silenceNative()pcall(function()snd.Volume=0 if snd.Playing then snd:Stop()end end)end local function restoreNative()if originalVolume[snd]~=nil then pcall(function()snd.Volume=originalVolume[snd]end)end end local function onPlay()if cat=="Bat"then local activatedAt=lastWeaponActivate[tool]or-100 local elapsed=os.clock()-activatedAt if isBatHitSound(snd)then restoreNative()return end if elapsed>=0 and elapsed<=1.05 then if state.weaponSoundsEnabled and(isBatSwingSound(snd)or elapsed<=0.14)then silenceNative()if lastMirroredUse[tool]~=activatedAt then lastMirroredUse[tool]=activatedAt playWeaponCustom(tool,"Bat","swing")end else restoreNative()end return end restoreNative()return end if not state.weaponSoundsEnabled then restoreNative();return end local activatedAt=lastWeaponActivate[tool]or-100 local elapsed=os.clock()-activatedAt if elapsed<0 or elapsed>1.05 then restoreNative()return end if cat=="Medusa"then silenceNative()if lastMirroredUse[tool]~=activatedAt then lastMirroredUse[tool]=activatedAt playWeaponCustom(tool,"Medusa","swing")end return end restoreNative()end local okPlayed,playedConn=pcall(function()return snd.Played:Connect(onPlay)end)if okPlayed and playedConn then table.insert(conns,playedConn)end table.insert(conns,snd:GetPropertyChangedSignal("Playing"):Connect(function()if snd.Playing then onPlay()end end))table.insert(conns,snd.AncestryChanged:Connect(function(_,parent)if parent then return end for _,c in ipairs(conns)do pcall(function()c:Disconnect()end)end soundHooks[snd]=nil nativeSoundDebounce[snd]=nil originalVolume[snd]=nil end))soundHooks[snd]=conns end local function bindToolSoundWatcher(tool,cat)if toolSoundWatch[tool]then return end local touchConn=nil local lastTouchHit=0 local function bindBatTouch()if cat~="Bat"then return end if touchConn then pcall(function()touchConn:Disconnect()end)touchConn=nil end local handle=getHandle(tool)if not handle then return end pcall(function()handle.CanTouch=true end)touchConn=handle.Touched:Connect(function(part)if not part or not part.Parent then return end local char=part:FindFirstAncestorOfClass("Model")if not char or char==LP.Character then return end local hum=char:FindFirstChildOfClass("Humanoid")if not hum or hum.Health<=0 then return end local targetPlayer=Players:GetPlayerFromCharacter(char)if targetPlayer==LP then return end local activatedAt=lastWeaponActivate[tool]or-100 if os.clock()-activatedAt>1.0 then return end local now=os.clock()if now-lastTouchHit<0.075 then return end lastTouchHit=now playConfirmedBatHit(tool,char)end)end pcall(function()tool.Activated:Connect(function()local now=os.clock()lastWeaponActivate[tool]=now if cat=="Bat"then lastBatActivate[tool]=now bindBatTouch()end end)end)bindBatTouch()toolSoundWatch[tool]=tool.DescendantAdded:Connect(function(d)if cat=="Bat"and d:IsA("BasePart")then task.defer(bindBatTouch)end if d:IsA("Sound")and d.Name~="M4CustomSound"and d.Name~="M4ConfirmedBatHit"and d.Name~="M4WeaponSwingCustom"and d.Name~="M4WeaponHitCustom"then if originalVolume[d]==nil then originalVolume[d]=d.Volume end task.defer(function()if not d.Parent then return end hookOriginalSound(tool,cat,d)end)end end)end local function equippedBat()local char=LP.Character if not char then return nil end for _,obj in ipairs(char:GetChildren())do if obj:IsA("Tool")and toolCategory(obj)=="Bat"then return obj end end return nil end local function bindEnemyHitWatch(plr,char)if plr==LP or not char then return end local hum=char:FindFirstChildOfClass("Humanoid")or char:WaitForChild("Humanoid",5)if not hum then return end if hitWatchConns[hum]then pcall(function()hitWatchConns[hum]:Disconnect()end)end local previous=hum.Health hitWatchConns[hum]=hum.HealthChanged:Connect(function(hp)local damaged=hp<previous-0.01 previous=hp if not damaged then return end local bat=equippedBat()if not bat then return end local myRoot=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")local theirRoot=char:FindFirstChild("HumanoidRootPart")if not myRoot or not theirRoot then return end if(myRoot.Position-theirRoot.Position).Magnitude>14 then return end playConfirmedBatHit(bat,char)end)end local function watchEnemyHits()for _,plr in ipairs(game:GetService("Players"):GetPlayers())do if plr~=LP then if plr.Character then task.defer(bindEnemyHitWatch,plr,plr.Character)end if not hitWatchPlayerConns[plr]then hitWatchPlayerConns[plr]=plr.CharacterAdded:Connect(function(char)task.defer(bindEnemyHitWatch,plr,char)end)end end end if not hitWatchPlayerConns.__added then hitWatchPlayerConns.__added=game:GetService("Players").PlayerAdded:Connect(function(plr)hitWatchPlayerConns[plr]=plr.CharacterAdded:Connect(function(char)task.defer(bindEnemyHitWatch,plr,char)end)if plr.Character then task.defer(bindEnemyHitWatch,plr,plr.Character)end end)end end watchEnemyHits()local killSwordRgbStep=0 local killSwordRgbConnection=game:GetService("RunService").RenderStepped:Connect(function(dt)if uiVisual.performanceMode then killSwordRgbStep=killSwordRgbStep+dt if killSwordRgbStep<1/20 then return end killSwordRgbStep=0 else killSwordRgbStep=0 end if not state.weaponSkinsEnabled or state.batWeaponSkin~="KillRGB"then return end local hue=(tick()%3)/3 local color=Color3.fromHSV(hue,1,1)for _,container in ipairs({LP.Character,LP:FindFirstChildOfClass("Backpack")})do if container then for _,tool in ipairs(container:GetChildren())do if tool:IsA("Tool")and toolCategory(tool)=="Bat"then local handle=getHandle(tool)local replica=handle and handle:FindFirstChild("M4LocalReplica")if replica and replica:GetAttribute("M4SkinKey")=="KillRGB"then for _,obj in ipairs(replica:GetDescendants())do if obj:IsA("BasePart")then setKillSwordColor(obj,color)end end end end end end end end)local function rememberRainbow(obj)if rainbowOriginal[obj]then return end if obj:IsA("BasePart")then rainbowOriginal[obj]={kind="part",Color=obj.Color}elseif obj:IsA("SpecialMesh")then rainbowOriginal[obj]={kind="mesh",VertexColor=obj.VertexColor}elseif obj:IsA("ParticleEmitter")or obj:IsA("Trail")or obj:IsA("Beam")then rainbowOriginal[obj]={kind="sequence",Color=obj.Color}elseif obj:IsA("PointLight")or obj:IsA("SpotLight")or obj:IsA("SurfaceLight")then rainbowOriginal[obj]={kind="color",Color=obj.Color}elseif obj:IsA("Highlight")then rainbowOriginal[obj]={kind="highlight",FillColor=obj.FillColor,OutlineColor=obj.OutlineColor}end end local function restoreRainbow()for obj,info in pairs(rainbowOriginal)do if obj and obj.Parent then pcall(function()if info.kind=="part"then obj.Color=info.Color elseif info.kind=="mesh"then obj.VertexColor=info.VertexColor elseif info.kind=="sequence"then obj.Color=info.Color elseif info.kind=="color"then obj.Color=info.Color elseif info.kind=="highlight"then obj.FillColor=info.FillColor;obj.OutlineColor=info.OutlineColor end end)end end rainbowOriginal=setmetatable({},{__mode="k"})end local function updateRainbow(dt)if not state.rainbowWeaponsEnabled then return end rainbowAcc+=dt if rainbowAcc<uiVisual.decorInterval(1/40)then return end rainbowAcc=0 local baseHue=(tick()*0.35)%1 local index=0 for _,container in ipairs({LP.Character,LP:FindFirstChildOfClass("Backpack")})do if container then for _,tool in ipairs(container:GetChildren())do if tool:IsA("Tool")and toolCategory(tool)then for _,obj in ipairs(tool:GetDescendants())do local eligible=obj:IsA("BasePart")or obj:IsA("SpecialMesh")or obj:IsA("ParticleEmitter")or obj:IsA("Trail")or obj:IsA("Beam")or obj:IsA("PointLight")or obj:IsA("SpotLight")or obj:IsA("SurfaceLight")or obj:IsA("Highlight")if eligible and obj:GetAttribute("BlessSwordGlow")~=true then index+=1 rememberRainbow(obj)local col=Color3.fromHSV((baseHue+(index-1)*0.035)%1,1,1)pcall(function()if obj:IsA("BasePart")then obj.Color=col elseif obj:IsA("SpecialMesh")then obj.VertexColor=Vector3.new(col.R,col.G,col.B)elseif obj:IsA("ParticleEmitter")or obj:IsA("Trail")or obj:IsA("Beam")then obj.Color=ColorSequence.new(col)elseif obj:IsA("Highlight")then obj.FillColor=col;obj.OutlineColor=col else obj.Color=col end end)end end end end end end end if type(_G.__BlessSwordGlowCleanup)=="function"then pcall(_G.__BlessSwordGlowCleanup)end local swordGlowAlive=true local swordGlowEntries={}local swordGlowConnection local swordGlowElapsed=0 local function removeGlow(entry)if entry.light then entry.light.Enabled=false end if entry.attachment then entry.attachment:Destroy()end if entry.floor then entry.floor:Destroy()end end local function makeFloor()local part=Instance.new("Part")part.Name="BlessFloorGlow"part:SetAttribute("BlessSwordGlow",true)part.Size=Vector3.new(7.5,0.03,7.5)part.Transparency=1 part.Anchored=true part.CanCollide=false part.CanTouch=false part.CanQuery=false part.CastShadow=false local surface=Instance.new("SurfaceGui",part)surface.Name="BlessFloorSurface"surface:SetAttribute("BlessSwordGlow",true)surface.Face=Enum.NormalId.Top surface.CanvasSize=Vector2.new(128,128)surface.AlwaysOnTop=false surface.LightInfluence=0 surface.Enabled=false local image=Instance.new("ImageLabel",surface)image.BackgroundTransparency=1 image.Size=UDim2.fromScale(1,1)image.Image="rbxasset://textures/particles/flare_main.dds"image.ImageTransparency=0.57 part.Parent=workspace return part,surface,image end local function refreshSwordGlows()if not swordGlowAlive then return end local accent=uiVisual.getThemeAccent()local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")for replica,entry in pairs(swordGlowEntries)do if not replica.Parent or entry.root~=root or not entry.attachment.Parent or not entry.floor.Parent then removeGlow(entry)swordGlowEntries[replica]=nil else local enabled=state.swordGlowEnabled==true and state.weaponSkinsEnabled==true and entry.tool.Parent==LP.Character entry.light.Enabled=enabled entry.surface.Enabled=false if enabled then entry.attachment.Position=Vector3.new(0,-1.25,0)entry.ray.FilterDescendantsInstances={LP.Character,entry.floor}local hit=workspace:Raycast(root.Position,Vector3.new(0,-9,0),entry.ray)if hit and hit.Normal.Y>0.35 then local normal=hit.Normal local axis=math.abs(normal:Dot(Vector3.new(1,0,0)))<0.95 and Vector3.new(1,0,0)or Vector3.new(0,0,1)local right=axis:Cross(normal).Unit entry.floor.CFrame=CFrame.fromMatrix(hit.Position+normal*0.04,right,normal,right:Cross(normal))entry.surface.Enabled=true end end entry.light.Color=accent entry.image.ImageColor3=accent end end end local function updateSwordGlow(tool,category)if not swordGlowAlive or category~="Bat"then return end local handle=getHandle(tool)local replica=handle and handle:FindFirstChild("M4LocalReplica")if not replica then return end local halo=replica:FindFirstChild("BlessSwordHalo")if halo then halo:Destroy()end local oldLight=replica:FindFirstChild("BlessSwordLight",true)if oldLight then oldLight:Destroy()end local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")local entry=swordGlowEntries[replica]if entry and(entry.root~=root or not entry.attachment.Parent or not entry.floor.Parent)then removeGlow(entry)swordGlowEntries[replica]=nil entry=nil end if state.swordGlowEnabled and root and not entry then local attachment=Instance.new("Attachment")attachment.Name="BlessFloorLight"attachment:SetAttribute("BlessSwordGlow",true)attachment.Parent=root local light=Instance.new("PointLight")light.Name="BlessSwordLight"light:SetAttribute("BlessSwordGlow",true)light.Enabled=false light.Brightness=1.4 light.Range=9 light.Shadows=false light.Parent=attachment local floor,surface,image=makeFloor()local ray=RaycastParams.new()ray.FilterType=Enum.RaycastFilterType.Exclude ray.IgnoreWater=true entry={tool=tool,root=root,attachment=attachment,light=light,floor=floor,surface=surface,image=image,ray=ray}swordGlowEntries[replica]=entry end refreshSwordGlows()end local function setSwordGlowLoop(enabled)if enabled and swordGlowAlive then if not swordGlowConnection then swordGlowElapsed=0 swordGlowConnection=RunService.Heartbeat:Connect(function(dt)swordGlowElapsed=swordGlowElapsed+dt if swordGlowElapsed<0.12 then return end swordGlowElapsed=0 refreshSwordGlows()end)end else if swordGlowConnection then swordGlowConnection:Disconnect()swordGlowConnection=nil end for replica,entry in pairs(swordGlowEntries)do removeGlow(entry)swordGlowEntries[replica]=nil end end refreshSwordGlows()end _G.__BlessSwordGlowCleanup=function()if not swordGlowAlive then return end swordGlowAlive=false if swordGlowConnection then swordGlowConnection:Disconnect()swordGlowConnection=nil end for replica,entry in pairs(swordGlowEntries)do removeGlow(entry)swordGlowEntries[replica]=nil end end local function processTool(tool)local cat=toolCategory(tool)if not cat then return end bindToolSoundWatcher(tool,cat)local hide=state.transparentWeapons or state.weaponSkinsEnabled for _,d in ipairs(tool:GetDescendants())do if d:IsA("BasePart")or d:IsA("Decal")or d:IsA("Texture")then setHidden(d,hide)end if d:IsA("Sound")and d.Name~="M4CustomSound"and d.Name~="M4ConfirmedBatHit"and d.Name~="M4WeaponSwingCustom"and d.Name~="M4WeaponHitCustom"then if originalVolume[d]==nil then originalVolume[d]=d.Volume end hookOriginalSound(tool,cat,d)if not state.weaponSoundsEnabled and cat~="Bat"then pcall(function()d.Volume=originalVolume[d]or d.Volume end)elseif cat=="Bat"then pcall(function()d.Volume=originalVolume[d]or d.Volume end)end end end if state.weaponSkinsEnabled then local key=cat=="Bat"and state.batWeaponSkin or state.medWeaponSkin local h=getHandle(tool)local rep=h and h:FindFirstChild("M4LocalReplica")if not rep or rep:GetAttribute("M4SkinKey")~=key then buildReplica(tool,key)h=getHandle(tool)rep=h and h:FindFirstChild("M4LocalReplica")if rep then rep:SetAttribute("M4SkinKey",key)end end else clearReplica(tool)end updateSwordGlow(tool,cat)end local function scanTools()for _,container in ipairs({LP.Character,LP:FindFirstChildOfClass("Backpack")})do if container then for _,obj in ipairs(container:GetChildren())do if obj:IsA("Tool")then processTool(obj)end end end end end local function refreshTools()scanTools()if not state.transparentWeapons and not state.weaponSkinsEnabled then for _,container in ipairs({LP.Character,LP:FindFirstChildOfClass("Backpack")})do if container then for _,tool in ipairs(container:GetChildren())do if tool:IsA("Tool")then restoreToolVisual(tool)end end end end end if not state.weaponSoundsEnabled then for snd,vol in pairs(originalVolume)do if snd and snd.Parent then local ownerTool=snd:FindFirstAncestorWhichIsA("Tool")if ownerTool and toolCategory(ownerTool)=="Bat"then pcall(function()snd.Volume=0 end)else pcall(function()snd.Volume=vol end)end end end end end function API.setSwordGlow(on)state.swordGlowEnabled=on==true refreshTools()setSwordGlowLoop(state.swordGlowEnabled)if uiVisual.swordGlowVisual then uiVisual.swordGlowVisual(state.swordGlowEnabled)end end function API.setTransparentWeapons(on)state.transparentWeapons=on==true;refreshTools()end function API.setWeaponSkins(on)state.weaponSkinsEnabled=on==true;refreshTools()end function API.setWeaponSounds(on)state.weaponSoundsEnabled=on==true refreshTools()end function API.setRainbowWeapons(on)state.rainbowWeaponsEnabled=on==true if state.rainbowWeaponsEnabled then if not rainbowConn then rainbowConn=game:GetService("RunService").Heartbeat:Connect(updateRainbow)end refreshTools()else if rainbowConn then pcall(function()rainbowConn:Disconnect()end);rainbowConn=nil end restoreRainbow()end end function API.setWeaponSkin(cat,key)local data=toolAssets[key]if not data or data.cat~=cat then return false end if cat=="Bat"then state.batWeaponSkin=key else state.medWeaponSkin=key end refreshTools();return true end local baseTargets={Base=true,PlotSign=true,FriendPanel=true,Cash=true,Laser=true,Decorations=true,Skin=true,Unlock=true,Purchases=true}local baseOriginal=setmetatable({},{__mode="k"})local baseConn=nil local function belongsBase(d)local p=d while p and p~=workspace do if baseTargets[p.Name]then return true end;p=p.Parent end return false end local function baseApply(d)if not(d:IsA("BasePart")or d:IsA("Decal")or d:IsA("Texture"))or not belongsBase(d)then return end if baseOriginal[d]==nil then baseOriginal[d]=d.Transparency end pcall(function()d.Transparency=math.max(baseOriginal[d]or 0,0.5)end)end local function setBaseXRay(on)state.baseXRayEnabled=on==true if baseConn then baseConn:Disconnect();baseConn=nil end if state.baseXRayEnabled then for _,d in ipairs(workspace:GetDescendants())do baseApply(d)end baseConn=workspace.DescendantAdded:Connect(function(d)task.defer(function()if state.baseXRayEnabled then baseApply(d)end end)end)else for d,v in pairs(baseOriginal)do if d and d.Parent then pcall(function()d.Transparency=v end)end end table.clear(baseOriginal)end end API.setBaseXRay=setBaseXRay local animalNames={}local animalOriginal=setmetatable({},{__mode="k"})local animalConn=nil local function loadAnimalNames()table.clear(animalNames)pcall(function()local datas=ReplicatedStorage:FindFirstChild("Datas")local mod=datas and datas:FindFirstChild("Animals")local t=mod and require(mod)if type(t)=="table"then for name in pairs(t)do animalNames[tostring(name)]=true end end end)end local function isAnimalVisual(d)local p=d while p and p~=workspace do if animalNames[p.Name]then return true end;p=p.Parent end return false end local function animalApply(d)if not(d:IsA("BasePart")or d:IsA("Decal")or d:IsA("Texture"))or not isAnimalVisual(d)then return end if animalOriginal[d]==nil then animalOriginal[d]=d.Transparency end pcall(function()d.Transparency=math.max(animalOriginal[d]or 0,0.5)end)end local function setBrainrotXRay(on)state.brainrotXRayEnabled=on==true if animalConn then animalConn:Disconnect();animalConn=nil end if state.brainrotXRayEnabled then loadAnimalNames()for _,d in ipairs(workspace:GetDescendants())do animalApply(d)end animalConn=workspace.DescendantAdded:Connect(function(d)task.defer(function()if state.brainrotXRayEnabled then animalApply(d)end end)end)else for d,v in pairs(animalOriginal)do if d and d.Parent then pcall(function()d.Transparency=v end)end end table.clear(animalOriginal)end end API.setBrainrotXRay=setBrainrotXRay function API.export()return{baseXRayEnabled=state.baseXRayEnabled==true,brainrotXRayEnabled=state.brainrotXRayEnabled==true,transparentWeapons=state.transparentWeapons==true,weaponSkinsEnabled=state.weaponSkinsEnabled==true,weaponSoundsEnabled=state.weaponSoundsEnabled==true,rainbowWeaponsEnabled=state.rainbowWeaponsEnabled==true,swordGlowEnabled=state.swordGlowEnabled==true,batWeaponSkin=state.batWeaponSkin,medWeaponSkin=state.medWeaponSkin,}end function API.import(data)if type(data)~="table"then return end if toolAssets[data.batWeaponSkin]and toolAssets[data.batWeaponSkin].cat=="Bat"then state.batWeaponSkin=data.batWeaponSkin end if toolAssets[data.medWeaponSkin]and toolAssets[data.medWeaponSkin].cat=="Medusa"then state.medWeaponSkin=data.medWeaponSkin end state.transparentWeapons=data.transparentWeapons==true state.weaponSkinsEnabled=data.weaponSkinsEnabled==true state.weaponSoundsEnabled=data.weaponSoundsEnabled==true state.rainbowWeaponsEnabled=data.rainbowWeaponsEnabled==true state.swordGlowEnabled=data.swordGlowEnabled==true setBaseXRay(data.baseXRayEnabled==true)setBrainrotXRay(data.brainrotXRayEnabled==true)API.setSwordGlow(state.swordGlowEnabled)API.setRainbowWeapons(state.rainbowWeaponsEnabled==true)end function API.reset()state.transparentWeapons=false;state.weaponSkinsEnabled=false;state.weaponSoundsEnabled=false;state.rainbowWeaponsEnabled=false state.batWeaponSkin="DiamondSword";state.medWeaponSkin="GoldenDesertEagle"setBaseXRay(false);setBrainrotXRay(false);API.setRainbowWeapons(false);API.setSwordGlow(false)end if state.swordGlowEnabled then API.setSwordGlow(true)end task.spawn(function()while true do task.wait(0.75)pcall(scanTools)end end)LP.CharacterAdded:Connect(function()task.delay(0.8,function()pcall(refreshTools)end)end)return API end)()_G.M4CosmeticsAPI=nil 

 do local previous=_G.__BlessVisualCleanup if type(previous)=="function"then pcall(previous)end local alive=true local floating=setmetatable({},{__mode="k"})local connections={}local floatingNames={KillHubMobilePanel=true,M4LWARE_BatV2_Button=true,InstaResetButton=true,BypassButton=true}uiVisual.hideButtons=false uiVisual.tronTrailEnabled=true pcall(function()local raw=_ace_readfile("BlessHideButtons.json")local data=type(raw)=="string"and HS:JSONDecode(raw)if type(data)=="table"and type(data.hidden)=="boolean"then uiVisual.hideButtons=data.hidden end end)local function connect(signal,callback)local connection=signal:Connect(callback)connections[#connections+1]=connection return connection end function uiVisual.registerFloatingGui(panel)if not alive or not panel or not panel:IsA("ScreenGui")then return end panel:SetAttribute("BlessFloatingGui",true)if floating[panel]==nil then local initialEnabled=panel.Enabled if _G.BlessIntro and _G.BlessIntro.Active then initialEnabled=_G.BlessIntro.GetEnabled(panel)end floating[panel]={enabled=initialEnabled,applying=false}connect(panel:GetPropertyChangedSignal("Enabled"),function()local saved=floating[panel]if not alive or not saved or saved.applying then return end if _G.BlessIntro and _G.BlessIntro.Active and not panel.Enabled then return end if uiVisual.hideButtons and panel.Enabled then saved.enabled=true saved.applying=true panel.Enabled=false saved.applying=false elseif not uiVisual.hideButtons then saved.enabled=panel.Enabled end end)end local saved=floating[panel]saved.applying=true if _G.BlessIntro and _G.BlessIntro.Active then _G.BlessIntro.SetEnabled(panel,not uiVisual.hideButtons and saved.enabled)else panel.Enabled=not uiVisual.hideButtons and saved.enabled end saved.applying=false end local function inspect(object)if not alive or not object then return end local panel=object:IsA("ScreenGui")and object or object:FindFirstAncestorWhichIsA("ScreenGui")if not panel then return end if floatingNames[panel.Name]or panel:GetAttribute("BlessFloatingGui")==true or object:GetAttribute("FearHubFloatingButton")==true or object:GetAttribute("FearThemeRole")=="FloatingButton"then uiVisual.registerFloatingGui(panel)end end local function watch(parent)if not parent then return end connect(parent.DescendantAdded,inspect)for _,object in ipairs(parent:GetChildren())do inspect(object)if object:IsA("ScreenGui")then for _,child in ipairs(object:GetDescendants())do inspect(child)end end end end pcall(function()watch(game:GetService("CoreGui"))end)watch(LP:FindFirstChild("PlayerGui"))connect(LP.ChildAdded,function(child)if child:IsA("PlayerGui")then watch(child)end end)function uiVisual.applyHideButtons()for panel,saved in pairs(floating)do if panel.Parent then saved.applying=true if _G.BlessIntro and _G.BlessIntro.Active then _G.BlessIntro.SetEnabled(panel,not uiVisual.hideButtons and saved.enabled)else panel.Enabled=not uiVisual.hideButtons and saved.enabled end saved.applying=false end end _G.BlessHideButtons=uiVisual.hideButtons end function uiVisual.setHideButtons(enabled,shouldSave)uiVisual.hideButtons=enabled==true uiVisual.applyHideButtons()if uiVisual.hideButtonsVisual then uiVisual.hideButtonsVisual(uiVisual.hideButtons)end if shouldSave~=false and type(saveAllSettings)=="function"then task.defer(saveAllSettings)end end _G.BlessApplyHideButtons=function()uiVisual.setHideButtons(_G.BlessHideButtons==true)end _G.BlessHideButtons=uiVisual.hideButtons local trail={objects={},trails={},moving=false}local heartbeat local function clearTrail()trail.root,trail.humanoid,trail.position,trail.color=nil,nil,nil,nil trail.moving=false for _,object in ipairs(trail.objects)do pcall(function()object:Destroy()end)end trail.objects,trail.trails={},{}end local function buildTrail(root,humanoid)clearTrail()trail.root,trail.humanoid,trail.position=root,humanoid,root.Position for _,object in ipairs(root:GetChildren())do if object:GetAttribute("BlessTronEffect")==true then object:Destroy()end end local layers={{name="Aurora",top=0.90,bottom=-1.10,alpha=0.68,lifetime=0.50},{name="Blade",top=0.12,bottom=-0.12,alpha=0.05,lifetime=0.44},{name="Edge",top=0.045,bottom=-0.045,alpha=0,lifetime=0.36},}for index,layer in ipairs(layers)do local attachments={}for i,height in ipairs({layer.top,layer.bottom})do local attachment=Instance.new("Attachment")attachment.Name="BlessTron"..layer.name..i attachment.Position=Vector3.new(0,height,root.Size.Z*0.5+0.35)attachment:SetAttribute("BlessTronEffect",true)attachment.Parent=root attachments[i]=attachment trail.objects[#trail.objects+1]=attachment end local object=Instance.new("Trail")trail.objects[#trail.objects+1]=object object.Name="BlessTron"..layer.name object:SetAttribute("BlessTronEffect",true)object.Attachment0,object.Attachment1=attachments[1],attachments[2]object.Enabled=false object.FaceCamera=true object.Lifetime=layer.lifetime object.MinLength=0.03 object.MaxLength=28 object.LightEmission=1 object.LightInfluence=0 object.WidthScale=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.35,0.9),NumberSequenceKeypoint.new(0.80,0.32),NumberSequenceKeypoint.new(1,0),})object.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,layer.alpha),NumberSequenceKeypoint.new(0.45,math.min(0.95,layer.alpha+0.13)),NumberSequenceKeypoint.new(0.8,0.83),NumberSequenceKeypoint.new(1,1),})object.Parent=root trail.trails[index]=object end end local function refreshTrailColor()local accent=uiVisual.getThemeAccent()if accent==trail.color then return end trail.color=accent for index,object in ipairs(trail.trails)do local light=accent:Lerp(Color3.new(1,1,1),index==3 and 0.68 or 0.24)object.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,light),ColorSequenceKeypoint.new(0.28,accent),ColorSequenceKeypoint.new(1,accent:Lerp(Color3.new(0,0,0),0.22)),})end end local function stepTrail(dt)if not alive or not uiVisual.tronTrailEnabled then return end local character=LP.Character local root=character and character:FindFirstChild("HumanoidRootPart")local humanoid=character and character:FindFirstChildOfClass("Humanoid")if not root or not humanoid or humanoid.Health<=0 then if trail.root then clearTrail()end return end if trail.root~=root or not trail.trails[1]or not trail.trails[1].Parent then buildTrail(root,humanoid)end refreshTrailColor()local position=root.Position local delta=position-(trail.position or position)trail.position=position local distance=Vector3.new(delta.X,0,delta.Z).Magnitude local teleported=dt<=0 or dt>0.25 or delta.Magnitude>math.max(24,dt*600)local moving=not teleported and distance/math.max(dt,0.001)>2.5 and not humanoid.Sit if teleported then for _,object in ipairs(trail.trails)do object:Clear()end end if trail.moving~=moving then trail.moving=moving for _,object in ipairs(trail.trails)do if moving then object:Clear()end object.Enabled=moving end end end function uiVisual.setTronTrail(enabled,shouldSave)uiVisual.tronTrailEnabled=enabled==true if uiVisual.tronTrailEnabled and alive then if not heartbeat then heartbeat=RunService.Heartbeat:Connect(stepTrail)end else if heartbeat then heartbeat:Disconnect();heartbeat=nil end clearTrail()end if uiVisual.tronTrailVisual then uiVisual.tronTrailVisual(uiVisual.tronTrailEnabled)end if shouldSave~=false and type(saveAllSettings)=="function"then task.defer(saveAllSettings)end end connect(LP.CharacterRemoving,clearTrail)_G.__BlessVisualCleanup=function()if not alive then return end alive=false if heartbeat then heartbeat:Disconnect();heartbeat=nil end clearTrail()for _,connection in ipairs(connections)do connection:Disconnect()end connections={}for panel,saved in pairs(floating)do if panel.Parent then panel.Enabled=saved.enabled end end end function uiVisual.bindVisualLifetime(screen)if screen then connect(screen.Destroying,_G.__BlessVisualCleanup)end end end 
function buildConfigTable()local config={version=7,monochromeVersion=1,colorThemeVersion=2,colorTheme=uiVisual.colorNames[uiVisual.backgroundColorIndex],moreButtons=uiVisual.moreButtons==true,hideButtons=uiVisual.hideButtons==true,tronTrailEnabled=uiVisual.tronTrailEnabled==true,hideBackgrounds=uiVisual.hideBackgrounds==true,backgroundIndex=uiVisual.backgroundIndex,normalBackgroundIndex=uiVisual.normalBackgroundIndex,m4Extras=_G.M4ExtrasAPI and _G.M4ExtrasAPI.export()or nil,backgroundDarkness=uiVisual.backgroundDarkness,wordDarkness=uiVisual.wordDarkness,backgroundColorIndex=uiVisual.backgroundColorIndex,nameLogoIndex=uiVisual.nameLogoIndex,wordImageId=uiVisual.normalNameLogo:match("(%d+)"),nameColorIndex=uiVisual.nameColorIndex,uiFont=uiVisual.fontName,autoLeft=autoLeftEnabled,autoRight=autoRightEnabled,autoBat=autoBatEnabled,batV2=batV2Enabled,batV2Engine=batV2Engine,batV2Speed=BAT_V2_SPEED,dropMode=dropMode, bypass=bypassToggled,autoTPDown=autoTPDownEnabled,mirrorTPDown=_G.FearMirrorTPDownEnabled==true,antiDesyncAutoSwing=antiDesyncAutoSwingEnabled,normalBatAutoSwing=normalBatAutoSwingEnabled,uiPreferences=uiPreferences,progressBarPos=savedProgressBarPos,mobilePanelPos=savedMobilePanelPos,keybinds={},normalSpeed=NS,carrySpeed=CS,m4AutoSpeedEnabled=_G.M4AutoSpeedEnabled==true,autoSpin=_G.BlessAutoSpinEnabled==true,m4AutoSpeedMode=_G.M4AutoSpeedMode,m4AutoSpeedRange=_G.M4AutoSpeedRange,m4RagdollSteal=_G.M4RagdollStealEnabled==true,laggerSpeed1=LAGGER_SPEED_1,laggerSpeed2=LAGGER_SPEED_2,stealRadius=CONFIG.STEAL_RANGE,stealMode=selectedStealMode,semiStealRadius=Steal.SemiRadius,autoTPDownHeight=autoTPDownHeight,antiRagdoll=antiRagdollEnabled,antiRagdollMode=antiRagdollEnabled and "v2"or"off",ragdollCountdown=ragdollCountdownEnabled,antiDie=antiDieEnabled and not (_G.__BlessFloat and _G.__BlessFloat.antiDieOwned==true) and not (_G.__BlessAutoSpin and _G.__BlessAutoSpin.antiDieOwned==true),autoSteal=CONFIG.AUTO_STEAL_ENABLED,jumpEnabled=jumpEnabled,medusaCounter=medusaCounterEnabled,batCounter=batCounterEnabled,batCounterMode=uiVisual.batCounterMode,laggerToggled=laggerToggled,laggerLevel=laggerLevel,carryMode=speedMode,batAimbotSpeed=BAT_AIMBOT_SPEED,bypassSpeed=BYPASS_AIMBOT_SPEED,stretchEnabled=stretchEnabled,uiScale=uiScaleValue,stealBarScale=stealBarScaleValue,stealBarFPS=uiVisual.stealBarFPS,buttonScale=buttonScaleValue,buttonShape=buttonShapeMode,skyTheme=currentSkyTheme,mikuSky=mikuSkyEnabled,animPack=currentAnimPack,espEnabled=espEnabled,antiLag=antiLagEnabled,performance120=uiVisual.performanceMode==true,shinyMode=_G.M4ShinyEnabled==true,mobileButtonPositions=savedButtonPositions,instaResetFloatingPos=instaResetFloatingPos,bypassFloatingPos=bypassFloatingPos,bodyLockEnabled=bodyLockEnabled,bodyLockRange=bodyLockRange,batSkin=_G.FearCosmetics and _G.FearCosmetics.BatEnabled==true,medSkin=_G.FearCosmetics and _G.FearCosmetics.MedEnabled==true,lockUI=uiLocked,editMode=false,}if pbFrame then config.progressBarPos={XScale=pbFrame.Position.X.Scale,XOffset=pbFrame.Position.X.Offset,YScale=pbFrame.Position.Y.Scale,YOffset=pbFrame.Position.Y.Offset}end config.mobilePanelPos=nil for key,entry in pairs(KB)do config.keybinds[key]={kb=entry.kb and entry.kb.Name or false,gp=entry.gp and entry.gp.Name or false}end for key,panel in pairs({instaResetFloatingPos=instaResetFloatingButton,bypassFloatingPos=bypassFloatingButton})do local frame=panel:FindFirstChild("Frame")if frame then config[key]={XScale=frame.Position.X.Scale,XOffset=frame.Position.X.Offset,YScale=frame.Position.Y.Scale,YOffset=frame.Position.Y.Offset}end end return config end
 local function validNumber(value)return type(value)=="number"and value==value and math.abs(value)<math.huge end local function readConfig(path)local raw=_ace_readfile(path)if type(raw)~="string"or raw==""then return nil end local ok,data=pcall(function()return HS:JSONDecode(raw)end)if not ok or type(data)~="table"then return nil end if data.normalSpeed==nil and data.keybinds==nil then return nil end return data,raw end function saveAllSettings()if _isResetting or _isLoading or not settingsReady then return false end if savingSettings then pendingSave=true;return false end if not canSaveConfig()then return false end savingSettings=true local ok,result=pcall(function()local json=HS:JSONEncode(buildConfigTable())if json==_lastSavedJSON then return true end local previous,previousRaw=readConfig(CONFIG_FILE)if previous then _ace_writefile(CONFIG_BACKUP,previousRaw)end for attempt=1,3 do if _ace_writefile(CONFIG_FILE,json)and _ace_readfile(CONFIG_FILE)==json then _lastSavedJSON=json _ace_writefile(CONFIG_BACKUP,json)if uiVisual.notifySaved then task.defer(uiVisual.notifySaved)end return true end if attempt<3 then task.wait(0.05)end end return false end)savingSettings=false if pendingSave then pendingSave=false task.defer(saveAllSettings)end if not ok or not result then warn("[FearHub] Could not save settings.")end return ok and result==true end 
local function applyConfig(data)local function number(key,fallback,low,high)local value=data[key]if not validNumber(value)then return fallback end return math.clamp(value,low,high)end local function boolean(key,fallback)if type(data[key])=="boolean"then return data[key]end return fallback end local function position(value)if type(value)~="table"then return nil end local result={}for _,key in ipairs({"XScale","XOffset","YScale","YOffset"})do if not validNumber(value[key])then return nil end result[key]=value[key]end return result end if type(data.keybinds)=="table"then for key,value in pairs(data.keybinds)do if KB[key]and type(value)=="table"then for _,device in ipairs({"kb","gp"})do local name=value[device]if name==nil or name==false then KB[key][device]=nil elseif type(name)=="string"then local ok,code=pcall(function()return Enum.KeyCode[name]end)if ok and code and code~=Enum.KeyCode.Unknown then KB[key][device]=code end end end end end end NS=number("normalSpeed",NS,0.01,500)CS=number("carrySpeed",CS,0.01,500)_G.M4AutoSpeedEnabled=boolean("m4AutoSpeedEnabled",_G.M4AutoSpeedEnabled==true)_G.BlessAutoSpinEnabled=boolean("autoSpin",_G.BlessAutoSpinEnabled==true)if data.m4AutoSpeedMode=="On Pick Up"or data.m4AutoSpeedMode=="Soft Steal"then _G.M4AutoSpeedMode=data.m4AutoSpeedMode end _G.M4AutoSpeedRange=number("m4AutoSpeedRange",_G.M4AutoSpeedRange or 15,1,100)_G.M4RagdollStealEnabled=boolean("m4RagdollSteal",_G.M4RagdollStealEnabled==true)LAGGER_SPEED_1=number("laggerSpeed1",LAGGER_SPEED_1,0.01,500)LAGGER_SPEED_2=number("laggerSpeed2",LAGGER_SPEED_2,0.01,500)CONFIG.STEAL_RANGE=number("stealRadius",CONFIG.STEAL_RANGE,10,150)Steal.StealRadius=CONFIG.STEAL_RANGE Steal.SetSemiRadius(number("semiStealRadius",Steal.SemiRadius,1,200))local loadedStealMode=type(data.stealMode)=="string"and data.stealMode or"v1"autoTPDownHeight=number("autoTPDownHeight",autoTPDownHeight,1,500)BAT_AIMBOT_SPEED=number("batAimbotSpeed",BAT_AIMBOT_SPEED,0.01,500)BYPASS_AIMBOT_SPEED=number("bypassSpeed",BYPASS_AIMBOT_SPEED,0.01,500)uiVisual.setMoreButtons(boolean("moreButtons",false),false)uiVisual.setHideButtons(boolean("hideButtons",uiVisual.hideButtons),false)uiVisual.setTronTrail(boolean("tronTrailEnabled",uiVisual.tronTrailEnabled),false)local savedTheme=data.colorThemeVersion==2 and data.colorTheme or "Candy"
if not uiVisual.selectThemeState(savedTheme)then uiVisual.selectThemeState("Candy")end
if _G.M4ExtrasAPI and type(data.m4Extras)=="table"then pcall(_G.M4ExtrasAPI.import,data.m4Extras)end
uiVisual.backgroundDarkness=number("backgroundDarkness",uiVisual.backgroundDarkness,0,75)
uiVisual.wordDarkness=number("wordDarkness",0,0,100)
uiVisual.applyColorTheme(uiVisual.colorNames[uiVisual.backgroundColorIndex],false)
if type(data.uiFont)=="string"and uiVisual.resolveFont(data.uiFont)then uiVisual.fontName=data.uiFont end uiScaleValue=number("uiScale",uiScaleValue,50,150)stealBarScaleValue=number("stealBarScale",stealBarScaleValue,50,180)uiVisual.setStealBarFPS(data.stealBarFPS)buttonScaleValue=number("buttonScale",buttonScaleValue,0.5,1.5)buttonShapeMode=math.floor(number("buttonShape",buttonShapeMode,1,2)+0.5)_G.BlessvsButtonShapeMode=buttonShapeMode _G.VeoraButtonShapeMode=buttonShapeMode bodyLockRange=number("bodyLockRange",bodyLockRange,5,200)laggerLevel=math.floor(number("laggerLevel",laggerLevel,1,2))if uiVisual.refreshBackgroundColor then uiVisual.refreshBackgroundColor()end if uiVisual.applyBackgroundDarkness then uiVisual.applyBackgroundDarkness()end if uiVisual.refreshBackgroundDarkness then uiVisual.refreshBackgroundDarkness()end applyAutoStealMode(loadedStealMode)antiDesyncAutoSwingEnabled=boolean("antiDesyncAutoSwing",antiDesyncAutoSwingEnabled)normalBatAutoSwingEnabled=boolean("normalBatAutoSwing",normalBatAutoSwingEnabled)uiLocked=boolean("lockUI",uiLocked)editModeEnabled=false antiRagdollEnabled=boolean("antiRagdoll",antiRagdollEnabled)antiRagdollMode=antiRagdollEnabled and"v2"or"off" ragdollCountdownEnabled=boolean("ragdollCountdown",ragdollCountdownEnabled)antiDieEnabled=boolean("antiDie",antiDieEnabled)CONFIG.AUTO_STEAL_ENABLED=boolean("autoSteal",CONFIG.AUTO_STEAL_ENABLED)jumpEnabled=boolean("jumpEnabled",jumpEnabled)medusaCounterEnabled=boolean("medusaCounter",medusaCounterEnabled)batCounterEnabled=boolean("batCounter",batCounterEnabled) uiVisual.setBatCounterMode(data.batCounterMode=="V2"and"V2"or"V1") antiLagEnabled=boolean("antiLag",antiLagEnabled)uiVisual.setPerformance120(boolean("performance120",uiVisual.performanceMode))_G.M4ShinyEnabled=boolean("shinyMode",_G.M4ShinyEnabled==true)removeAccessoriesEnabled=antiLagEnabled laggerToggled=boolean("laggerToggled",laggerToggled)laggerLevel=math.floor(number("laggerLevel",laggerLevel,1,2))speedMode=boolean("carryMode",speedMode)if laggerToggled then speedMode=false end espEnabled=boolean("espEnabled",espEnabled)stretchEnabled=boolean("stretchEnabled",stretchEnabled)bodyLockEnabled=boolean("bodyLockEnabled",bodyLockEnabled)local savedBatSkin=boolean("batSkin",_G.FearCosmetics and _G.FearCosmetics.BatEnabled==true)local savedMedSkin=boolean("medSkin",_G.FearCosmetics and _G.FearCosmetics.MedEnabled==true)if _G.FearCosmetics then _G.FearCosmetics:SetBat(savedBatSkin)_G.FearCosmetics:SetMed(savedMedSkin)end autoTPDownEnabled=boolean("autoTPDown",autoTPDownEnabled)_G.FearMirrorTPDownEnabled=boolean("mirrorTPDown",_G.FearMirrorTPDownEnabled==true)if _G.FearGoodAimbotState then _G.FearGoodAimbotState.speed=BAT_AIMBOT_SPEED end autoLeftEnabled=boolean("autoLeft",autoLeftEnabled)autoRightEnabled=boolean("autoRight",autoRightEnabled)autoBatEnabled=boolean("autoBat",autoBatEnabled)aimbotMode="old"batV2Enabled=boolean("batV2",batV2Enabled) BAT_V2_SPEED=number("batV2Speed",55,1,120) batV2Engine=data.batV2Engine=="Bless" and "Bless" or "Rival" dropMode=2   bypassToggled=boolean("bypass",bypassToggled)if bypassToggled then autoBatEnabled,batV2Enabled,autoLeftEnabled,autoRightEnabled=false,false,false,false elseif autoLeftEnabled then autoRightEnabled,autoBatEnabled,batV2Enabled=false,false,false elseif autoRightEnabled then autoBatEnabled,batV2Enabled=false,false elseif batV2Enabled then autoBatEnabled=false end if type(data.skyTheme)=="string"and CANDY_SKY_PRESETS[data.skyTheme]then currentSkyTheme=data.skyTheme end mikuSkyEnabled=boolean("mikuSky",mikuSkyEnabled)if type(data.animPack)=="string"and(data.animPack=="Off"or data.animPack=="Unwalk"or ANIM_PACKS[data.animPack])then currentAnimPack=data.animPack end currentAccessoryPack="Off"instaResetFloatingPos=position(data.instaResetFloatingPos)or instaResetFloatingPos bypassFloatingPos=position(data.bypassFloatingPos)or bypassFloatingPos savedProgressBarPos=position(data.progressBarPos)or savedProgressBarPos savedMobilePanelPos=position(data.mobilePanelPos)or savedMobilePanelPos if type(data.mobileButtonPositions)=="table"then savedButtonPositions={}for key,value in pairs(data.mobileButtonPositions)do if type(key)=="string"and type(value)=="table"and validNumber(value.X)and validNumber(value.Y)then savedButtonPositions[key]={Screen=value.Screen==true,XScale=validNumber(value.XScale)and value.XScale or 1,X=value.X,YScale=validNumber(value.YScale)and value.YScale or 0,Y=value.Y}end end end if type(data.uiPreferences)=="table"then local ui=data.uiPreferences if type(ui.visible)=="boolean"then uiPreferences.visible=ui.visible end uiPreferences.sectionsMode=uiVisual.restoreSectionsMode(ui.sectionsMode,ui.sectionsVersion)uiPreferences.sectionsVersion=1 local allowedTabs={Moment=true,Combat=true,Main=true,Visuals=true,Extra=true,Settings=true}if type(ui.tab)=="string"and allowedTabs[ui.tab]then uiPreferences.tab=ui.tab end if type(ui.scroll)=="table"then for key,value in pairs(ui.scroll)do if(allowedTabs[key]or key=="All")and validNumber(value)then uiPreferences.scroll[key]=math.max(0,value)end end end if type(ui.mainPosition)=="table"and validNumber(ui.mainPosition.XScale)and validNumber(ui.mainPosition.XOffset)and validNumber(ui.mainPosition.YScale)and validNumber(ui.mainPosition.YOffset)then uiPreferences.mainPosition={XScale=ui.mainPosition.XScale,XOffset=ui.mainPosition.XOffset,YScale=ui.mainPosition.YScale,YOffset=ui.mainPosition.YOffset}end end if _G.__BlessAutoSpin then _G.__BlessAutoSpin.SetEnabled(_G.BlessAutoSpinEnabled)end end
 function loadAllSettings()local data,raw=readConfig(CONFIG_FILE)local source=nil if data then source="main"else data,raw=readConfig(CONFIG_BACKUP)if data then source="backup"end end if not data then startupConfigLoaded=false startupConfigSource=nil return false end local wasLoading=_isLoading _isLoading=true local ok,err=pcall(applyConfig,data)_isLoading=wasLoading if not ok then startupConfigLoaded=false startupConfigSource=nil warn("[FearHub] Invalid configuration: "..tostring(err))return false end startupConfigLoaded=true startupConfigSource=source _lastSavedJSON=raw if source=="backup"and type(raw)=="string"and raw~=""then for attempt=1,3 do if _ace_writefile(CONFIG_FILE,raw)and _ace_readfile(CONFIG_FILE)==raw then break end if attempt<3 then task.wait(0.05)end end end return true end 
function forceResetUI()   if _G.__BlessFloat then _G.__BlessFloat.disable() end   if dropModeBtnRef then dropModeBtnRef.Text="Bubble" end
    uiVisual.refreshBatV2Engine()
    uiVisual.syncBatV2Speed()
    if batV2SpeedBox then batV2SpeedBox.Text = tostring(BAT_V2_SPEED) end
    if batV2SetVisual then batV2SetVisual(false) end
if normalBox then normalBox.Text=tostring(NS)end if carryBox then carryBox.Text=tostring(CS)end if normalSpeedSetVisual then normalSpeedSetVisual(true)end if radInput then radInput.Text=tostring(CONFIG.STEAL_RANGE)end if semiRadInput then semiRadInput.Text=tostring(Steal.SemiRadius)end if uiVisual.stealBarFPSBox then uiVisual.stealBarFPSBox.Text=tostring(uiVisual.stealBarFPS)end if _G.M4RefreshStealModeOptions then pcall(_G.M4RefreshStealModeOptions)end if _G.M4AutoSpeedModeBtn then _G.M4AutoSpeedModeBtn.Text=tostring(_G.M4AutoSpeedMode)end if _G.M4AutoSpeedRangeBox then _G.M4AutoSpeedRangeBox.Text=tostring(_G.M4AutoSpeedRange)end if _G.M4AutoSpeedSetVisual then _G.M4AutoSpeedSetVisual(_G.M4AutoSpeedEnabled==true)end if _G.M4RagdollStealSetVisual then _G.M4RagdollStealSetVisual(_G.M4RagdollStealEnabled==true)end if laggerBox then laggerBox.Text=tostring(LAGGER_SPEED_1)end if lagger2Box then lagger2Box.Text=tostring(LAGGER_SPEED_2)end if autoTPHeightBox then autoTPHeightBox.Text=tostring(autoTPDownHeight)end if uiScaleBox then uiScaleBox.Text=tostring(uiScaleValue)end if _G.uiScaleValueLabel then _G.uiScaleValueLabel.Text=string.format("%.2f",uiScaleValue/100)end if _G.buttonScaleValueLabel then _G.buttonScaleValueLabel.Text=string.format("%.2f",buttonScaleValue)end applyButtonScale(buttonScaleValue)if bodyLockRangeBox then bodyLockRangeBox.Text=tostring(bodyLockRange)end local function safeSet(fn,val)if fn then fn(val)end end safeSet(autoBatSetVisual,false)aimbotMode="old"safeSet(autoLeftSetVisual,false)safeSet(autoRightSetVisual,false)safeSet(setBatCounterVisual,false)safeSet(setMedusaVisual,false)safeSet(setAntiRagVisual,false)safeSet(setRagdollCountdownVisual,false)safeSet(setAntiDieVisual,false)safeSet(mikuSkySetVisual,false)safeSet(setJumpVisual,false)safeSet(setAntiLagVisual,false)if _G.FearCosmetics then _G.FearCosmetics:SetBat(false)_G.FearCosmetics:SetMed(false)end safeSet(batSkinSetVisual,false)safeSet(medSkinSetVisual,false)safeSet(setAutoTPDownVisual,false)safeSet(_G.FearMirrorTPDownVisual,false)if _G.FearGoodAimbotSpeedBox then _G.FearGoodAimbotSpeedBox.Text=tostring(BAT_AIMBOT_SPEED)end safeSet(setLockUIVisual,false)safeSet(setEditModeVisual,false)safeSet(setInstaGrab,false)safeSet(bypassSetVisual,false)safeSet(setESPVIsual,false)safeSet(bodyLockSetVisual,false)if _G.stretchToggleSetter then _G.stretchToggleSetter(false)end safeSet(mobSetAutoBat,false)safeSet(mobSetBatV2,false)safeSet(mobSetAutoLeft,false)safeSet(mobSetAutoRight,false)safeSet(mobSetDropBR,false)safeSet(mobSetTpDown,false)safeSet(mobSetCarry,false)safeSet(mobSetLagger1,false)safeSet(mobSetLagger2,false)if setJumpToggleState then setJumpToggleState(false)end refreshSpeedModeLabel()updateProgressBarVisibility()if mikuSkyEnabled or mikuSkyThread then stopMikuSky()end setSkyTheme("Off")disableAntiLag()for _,ref in ipairs(keyButtonRefs)do local entry=ref.entry local label=(entry.gp and entry.gp.Name)or(entry.kb and entry.kb.Name)or"None"ref.btn.Text=label end if accSelectorLabel then accSelectorLabel.Text="Off"end currentAccessoryPack="Off"clearAllAccessories(LP.Character)end
 function resetFloatingPositions()if MobilePanel then savedButtonPositions={}local BTN_W,GAP_X=56,8 local PANEL_W=BTN_W*2+GAP_X local anchorX=-PANEL_W-10 for _,btn in ipairs(MobilePanel:GetChildren())do if btn:IsA("TextButton")and btn:GetAttribute("FearHubFloatingButton")==true then local defX,defY=getDefaultButtonPosition(btn.Name)btn.Position=UDim2.new(1,anchorX+defX,0,defY)end end end if instaResetFloatingButton and instaResetFloatingButton:FindFirstChild("Frame")then local btnFrame=instaResetFloatingButton:FindFirstChild("Frame")btnFrame.Position=UDim2.new(1,-MOBILE_PANEL_WIDTH-10,0,MOBILE_PANEL_HEIGHT+10)instaResetFloatingPos=nil end if bypassFloatingButton and bypassFloatingButton:FindFirstChild("Frame")then local btnFrame=bypassFloatingButton:FindFirstChild("Frame")btnFrame.Position=UDim2.new(1,-10-60,0,MOBILE_PANEL_HEIGHT+10)bypassFloatingPos=nil end if pbFrame then pbFrame.Position=UDim2.new(0.5,-163,1,-70)savedProgressBarPos=nil end savedMobilePanelPos=nil instaResetFloatingPos=nil bypassFloatingPos=nil end 
function resetToFactoryDefaults()_isResetting=true stopAllBackgroundTasks()_G.BlessAutoSpinEnabled=false if _G.__BlessAutoSpin then _G.__BlessAutoSpin.SetEnabled(false)end stopAutoSteal()stopAutoTPDown()stopBatCounter()stopMedusaCounter()stopAntiRagdoll()stopAntiDie()stopJumpMode()disableAutoBat()toggleBypass(false)stopBodyLock()if espEnabled then toggleESP(false)end if stretchEnabled then disableStretch()end if antiLagEnabled then disableAntiLag()end uiVisual.setPerformance120(false)uiVisual.setMoreButtons(false,false)uiVisual.setHideButtons(false,false)uiVisual.setTronTrail(false,false)if dropActive then stopDropBrainrot()end NS=59 CS=29 LAGGER_SPEED_1=40 LAGGER_SPEED_2=20 CONFIG.STEAL_RANGE=65 autoTPDownHeight=20 speedMode=false laggerToggled=false laggerLevel=1 antiRagdollEnabled=false antiRagdollMode="off" ragdollCountdownEnabled=false antiDieEnabled=false jumpEnabled=false medusaCounterEnabled=false batCounterEnabled=false autoBatEnabled=false aimbotMode="old"batV2Enabled=false batV2Engine="Rival" BAT_V2_SPEED=55 uiVisual.setBatCounterMode("V1")  autoLeftEnabled=false autoRightEnabled=false antiLagEnabled=false _G.M4ShinyEnabled=false if _G.M4StopShiny then pcall(_G.M4StopShiny)end autoTPDownEnabled=false _G.FearMirrorTPDownEnabled=false uiLocked=false editModeEnabled=false CONFIG.AUTO_STEAL_ENABLED=false BAT_AIMBOT_SPEED=58 BYPASS_AIMBOT_SPEED=58 bypassToggled=false dropMode=2 stretchEnabled=false uiScaleValue=100 stealBarScaleValue=100 uiVisual.setStealBarFPS(20)if _G.__SureApplyResponsiveMainScale then _G.__SureApplyResponsiveMainScale()elseif mainUIScale then mainUIScale.Scale=1 end refreshStealBarScale()buttonScaleValue=1.0 applyButtonScale(1.0)espEnabled=false mikuSkyEnabled=false bodyLockEnabled=false bodyLockRange=20 antiDesyncAutoSwingEnabled=true normalBatAutoSwingEnabled=true if normalBatAutoSwingSetVisual then normalBatAutoSwingSetVisual(true)end Steal.SetSemiRadius(10)applyAutoStealMode("v1")currentAnimPack="Off"stopAnimPack()currentAccessoryPack="Off"clearAllAccessories(LP.Character)if accSelectorLabel then accSelectorLabel.Text="Off"end for key,val in pairs(DEFAULT_KB)do if KB[key]then KB[key].kb=val.kb KB[key].gp=val.gp end end pcall(function()if _ace_isfile(CONFIG_FILE)then local df=delfile or(syn and syn.delfile)or(getgenv and getgenv().delfile)if type(df)=="function"then df(CONFIG_FILE)end end end)resetFloatingPositions()forceResetUI()setSkyTheme("Off")updateProgressBarVisibility()refreshSpeedModeLabel()uiVisual.normalBackgroundIndex=1 uiVisual.backgroundIndex=1 uiVisual.hideBackgrounds=false if uiVisual.hideBackgroundsVisual then uiVisual.hideBackgroundsVisual(false)end uiVisual.backgroundDarkness=38 uiVisual.wordDarkness=0 uiVisual.applyColorTheme("Candy",false) uiVisual.fontName="GothamBold"if uiVisual.applyFont then uiVisual.applyFont(uiVisual.fontName,false)end if uiVisual.refreshBackground then uiVisual.refreshBackground(false)end if uiVisual.refreshBackgroundColor then uiVisual.refreshBackgroundColor()end if uiVisual.refreshNameLogo then uiVisual.refreshNameLogo()end if uiVisual.applyBackgroundDarkness then uiVisual.applyBackgroundDarkness()end if uiVisual.refreshBackgroundDarkness then uiVisual.refreshBackgroundDarkness()end if uiVisual.refreshSkins then uiVisual.refreshSkins()end if uiVisual.refreshSliders then uiVisual.refreshSliders()end uiPreferences.visible=true uiPreferences.tab="Moment"uiPreferences.sectionsMode="Selector" uiPreferences.sectionsVersion=1 uiPreferences.scroll={}uiPreferences.mainPosition={XScale=0,XOffset=20,YScale=0,YOffset=2}if refreshUIPreferences then refreshUIPreferences()end _lastSavedJSON=nil if LP.Character then setupMovementAndIndicators(LP.Character)end _isResetting=false if not saveAllSettings()then error("Could not save reset settings")end end
 function updateProgressBarVisibility()if pbFrame then pbFrame.Visible=CONFIG.AUTO_STEAL_ENABLED end end function applyShimmerToText(obj,speed)speed=speed or 0.8 local grad=Instance.new("UIGradient",obj)grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(145,150,160)),ColorSequenceKeypoint.new(0.3,Color3.fromRGB(182,186,194)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(198,202,210)),ColorSequenceKeypoint.new(0.7,Color3.fromRGB(182,186,194)),ColorSequenceKeypoint.new(1,Color3.fromRGB(145,150,160))})grad.Rotation=45 grad.Offset=Vector2.new(0,0)task.spawn(function()local t=0 while grad and grad.Parent do t=t+0.02 grad.Offset=Vector2.new(math.sin(t*speed)*0.4,0)task.wait(0.04)end end)return grad end function getDefaultButtonPosition(btnName)local BTN_W=56 local BTN_H=56 local GAP_X=8 local GAP_Y=12 local positions={DropBR={0,0},AutoLeft={1,0},AutoBat={0,1},AutoRight={1,1},TpDown={0,2},TpBat={1,2},Lagger1={0,3},Reset={1,3},Carry={0,4},Lagger2={1,4},BatV2={0,5},Float={-1,2},}local p=positions[btnName]or{0,0}return p[1]*(BTN_W+GAP_X),p[2]*(BTN_H+GAP_Y)end
function uiVisual.ensureFloatVisible()
    local button = MobilePanel and MobilePanel:FindFirstChild("Float")
    local camera = workspace.CurrentCamera
    if not button or not camera then return end
    local vp = camera.ViewportSize
    if vp.X <= 0 or vp.Y <= 0 then return end
    local function rect(object)
        local size, position, anchor = object.Size, object.Position, object.AnchorPoint
        local w = size.X.Scale * vp.X + size.X.Offset
        local h = size.Y.Scale * vp.Y + size.Y.Offset
        return {x = position.X.Scale * vp.X + position.X.Offset - w * anchor.X,
            y = position.Y.Scale * vp.Y + position.Y.Offset - h * anchor.Y, w = w, h = h}
    end
    local area = rect(button)
    local obstacles = {}
    for _, panel in pairs({MobilePanel, batV2FloatingButton, instaResetFloatingButton, bypassFloatingButton}) do
        if panel and panel.Parent then
            for _, object in ipairs(panel:GetChildren()) do
                if object ~= button and object:IsA("GuiObject") and object.Visible
                    and object:GetAttribute("FearHubFloatingButton") == true then
                    obstacles[#obstacles + 1] = rect(object)
                end
            end
        end
    end
    if main and main.Visible and main.AbsoluteSize.X < vp.X * .8 then
        obstacles[#obstacles + 1] = {x = main.AbsolutePosition.X, y = main.AbsolutePosition.Y,
            w = main.AbsoluteSize.X, h = main.AbsoluteSize.Y}
    end
    local function free(x, y)
        if x < 8 or y < 12 or x + area.w > vp.X - 8 or y + area.h > vp.Y - 12 then return false end
        if x + area.w > vp.X * .78 and y + area.h > vp.Y * .74 then return false end
        for _, other in ipairs(obstacles) do
            if x < other.x + other.w + 8 and x + area.w + 8 > other.x
                and y < other.y + other.h + 8 and y + area.h + 8 > other.y then return false end
        end
        return true
    end
    if free(area.x, area.y) then return end
    local chosenX, chosenY
    local preferredY = math.floor(vp.Y * .42)
    for column = 0, math.floor(vp.X / math.max(area.w + 10, 1)) do
        local x = vp.X - area.w - 16 - column * (area.w + 10)
        if free(x, preferredY) then chosenX, chosenY = x, preferredY break end
        for y = 20, vp.Y - area.h - 12, math.max(20, math.floor(area.h + 10)) do
            if free(x, y) then chosenX, chosenY = x, y break end
        end
        if chosenX then break end
    end
    if not chosenX then
        chosenX = math.clamp(area.x, 8, math.max(8, vp.X - area.w - 8))
        chosenY = math.clamp(area.y, 12, math.max(12, vp.Y - area.h - 12))
    end
    button.Position = UDim2.fromOffset(chosenX, chosenY)
    savedButtonPositions.Float = {Screen = true, XScale = 0, X = chosenX, YScale = 0, Y = chosenY}
end
 do local function make(class,parent,props)local object=Instance.new(class)for key,value in pairs(props)do object[key]=value end object.Parent=parent return object end function uiVisual.sectionIcon(parent,name,position,size,color,z)local root=make("Frame",parent,{Name="SectionIcon",Position=position,AnchorPoint=Vector2.new(0.5,0),Size=UDim2.fromOffset(size,size),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=z})local function line(x1,y1,x2,y2,thickness)local dx,dy=x2-x1,y2-y1 local ink=make("Frame",root,{Name="IconInk",AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale((x1+x2)/2,(y1+y2)/2),Size=UDim2.fromOffset(math.sqrt(dx*dx+dy*dy)*size,thickness or 1.6),BackgroundColor3=color,BorderSizePixel=0,Rotation=math.deg(math.atan2(dy,dx)),ZIndex=z})make("UICorner",ink,{CornerRadius=UDim.new(0,2)})end local function box(x,y,w,h,radius,solid)local object=make("Frame",root,{Name="IconInk",Position=UDim2.fromScale(x,y),Size=UDim2.fromScale(w,h),BackgroundColor3=color,BackgroundTransparency=solid and 0 or 1,BorderSizePixel=0,ZIndex=z})make("UICorner",object,{CornerRadius=UDim.new(0,radius)})if not solid then make("UIStroke",object,{Color=color,Transparency=0,Thickness=1.4})end return object end if name=="Moment"then line(0.18,0.22,0.44,0.5);line(0.44,0.5,0.18,0.78)line(0.52,0.22,0.79,0.5);line(0.79,0.5,0.52,0.78)elseif name=="Combat"then line(0.5,0.1,0.83,0.24);line(0.83,0.24,0.78,0.62)line(0.78,0.62,0.5,0.88);line(0.5,0.88,0.22,0.62)line(0.22,0.62,0.17,0.24);line(0.17,0.24,0.5,0.1)line(0.36,0.47,0.47,0.58);line(0.47,0.58,0.66,0.37)elseif name=="Visuals"then box(0.15,0.15,0.27,0.27,2,false)box(0.58,0.15,0.27,0.27,2,true)box(0.15,0.58,0.27,0.27,2,true)box(0.58,0.58,0.27,0.27,2,false)elseif name=="Main"then box(0.12,0.3,0.76,0.53,2,false)box(0.34,0.12,0.32,0.18,2,false)line(0.13,0.52,0.87,0.52)box(0.44,0.44,0.12,0.17,1,true)elseif name=="Settings"then line(0.14,0.24,0.86,0.24)line(0.14,0.50,0.86,0.50)line(0.14,0.76,0.86,0.76)box(0.28,0.15,0.13,0.18,2,true)box(0.61,0.41,0.13,0.18,2,true)box(0.35,0.67,0.13,0.18,2,true)end return root end function uiVisual.colorSectionIcon(root,color)if not root then return end for _,object in ipairs(root:GetDescendants())do if object:IsA("Frame")and object.Name=="IconInk"then object.BackgroundColor3=color end if object:IsA("UIStroke")then object.Color=color end end end end 
function uiVisual.bindOptionsIdle(window,screen)
local fade=Instance.new("NumberValue",window)
fade.Name="GuiIdleFade"
fade.Value=0
local entries={}
local seen={}
local connections={}
local held={}
local tween=nil
local tweenTarget=nil
local dead=false
local dimmed=false
local lastActivity=os.clock()
local function isWindowObject(object)
return object==window or object:IsDescendantOf(window)
end
local function write(entry,alpha)
local object=entry.object
if not object.Parent or not isWindowObject(object)then return end
entry.writing=true
entry.last=entry.base+(1-entry.base)*(alpha*entry.weight)
object[entry.property]=entry.last
entry.writing=false
end
local function apply(alpha)
for _,entry in ipairs(entries)do write(entry,alpha)end
end
local function clearEntries()
for _,entry in ipairs(entries)do entry.connection:Disconnect()end
table.clear(entries)
table.clear(seen)
end
local function capture(object,property)
local properties=seen[object]
if not properties then properties={}seen[object]=properties end
if properties[property]then return end
local base=object[property]
if type(base)~="number"then return end
local weight=0.55
-- Fade modern option surfaces, tracks and outlines along with the main window.
-- Keep labels moderately readable during inactivity.
local modern=uiVisual.isModernObject and uiVisual.isModernObject(object)
if modern then
    if property=="BackgroundTransparency" or property=="ImageTransparency" then
        weight=0.82
    elseif property=="Transparency" and object:IsA("UIStroke") then
        weight=0.78
    elseif property=="TextTransparency" or property=="TextStrokeTransparency" then
        weight=0.60
    end
end
if property=="BackgroundTransparency"and(object==window or object.Name=="UIVisualBoundary")then
weight=0.90
end
local entry={object=object,property=property,base=base,weight=weight,writing=false}
properties[property]=true
entry.connection=object:GetPropertyChangedSignal(property):Connect(function()
if dead or entry.writing or not object.Parent then return end
local value=object[property]
if entry.last~=nil and math.abs(value-entry.last)<0.00001 then return end
entry.base=value
if fade.Value>0 then write(entry,fade.Value)end
end)
entries[#entries+1]=entry
if fade.Value>0 then write(entry,fade.Value)end
end
local function captureObject(object)
if not isWindowObject(object)then return end
if object:IsA("GuiObject")then capture(object,"BackgroundTransparency")end
if object:IsA("TextLabel")or object:IsA("TextButton")or object:IsA("TextBox")then
capture(object,"TextTransparency")
capture(object,"TextStrokeTransparency")
elseif object:IsA("ImageLabel")or object:IsA("ImageButton")then
capture(object,"ImageTransparency")
elseif object:IsA("UIStroke")then
capture(object,"Transparency")
end
if object:IsA("ScrollingFrame")then capture(object,"ScrollBarImageTransparency")end
end
local function setFade(target,immediate)
if tween and tweenTarget==target and not immediate then return end
if tween then local old=tween tween=nil tweenTarget=nil old:Cancel()end
if target==1 and #entries==0 then
captureObject(window)
for _,object in ipairs(window:GetDescendants())do captureObject(object)end
end
if immediate or #entries==0 then
fade.Value=target
apply(target)
if target==0 then clearEntries()end
return
end
local current=TS:Create(fade,TweenInfo.new(target==1 and 0.4 or 0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Value=target})
tween=current
tweenTarget=target
local completed
completed=current.Completed:Connect(function(state)
completed:Disconnect()
if tween~=current then return end
tween=nil
tweenTarget=nil
if state==Enum.PlaybackState.Completed and target==0 then apply(0)clearEntries()end
end)
current:Play()
end
local function reset(immediate)
if dead then return end
lastActivity=os.clock()
if dimmed or fade.Value>0 or(immediate==true and #entries>0)then
dimmed=false
setFade(0,immediate==true)
end
end
uiVisual.resetOptionsIdle=reset
local function connect(signal,callback)
connections[#connections+1]=signal:Connect(callback)
end
local function inside(position)
if not position or not window.Parent or not window.Visible then return false end
local origin=window.AbsolutePosition
local size=window.AbsoluteSize
return position.X>=origin.X and position.X<=origin.X+size.X and position.Y>=origin.Y and position.Y<=origin.Y+size.Y
end
local function selectedInside()
local selected=game:GetService("GuiService").SelectedObject
return selected and selected.Parent and selected:IsDescendantOf(window)
end
connect(fade.Changed,apply)
connect(UIS.InputBegan,function(input)
if dead or not window.Visible then return end
local kind=input.UserInputType
if kind==Enum.UserInputType.Touch or kind==Enum.UserInputType.MouseButton1 or kind==Enum.UserInputType.MouseButton2 then
if inside(input.Position)then held[input]=true reset(false)end
elseif kind==Enum.UserInputType.Keyboard then
local focused=UIS:GetFocusedTextBox()
if focused and focused:IsDescendantOf(window)then reset(false)end
elseif selectedInside()then reset(false)end
end)
connect(UIS.InputEnded,function(input)
if held[input]then held[input]=nil reset(false)end
end)
connect(UIS.InputChanged,function(input)
if dead or not window.Visible then return end
if input.UserInputType==Enum.UserInputType.MouseWheel and inside(input.Position)then
reset(false)
elseif held[input]then
reset(false)
elseif input.UserInputType~=Enum.UserInputType.MouseMovement and input.UserInputType~=Enum.UserInputType.Touch and selectedInside()then
reset(false)
end
end)
connect(window:GetPropertyChangedSignal("Visible"),function()
table.clear(held)
reset(true)
end)
connect(window.DescendantAdded,function(object)
if #entries==0 then return end
task.defer(function()
if not dead and #entries>0 and object.Parent then captureObject(object)end
end)
end)
local elapsed=0
connect(RunService.Heartbeat,function(dt)
elapsed=elapsed+dt
if elapsed<0.1 then return end
elapsed=0
if dead or not window.Parent then return end
if not window.Visible or uiVisual.mainAnimating then
lastActivity=os.clock()
return
end
if next(held)then lastActivity=os.clock()return end
if not dimmed and os.clock()-lastActivity>=5 then
dimmed=true
setFade(1,false)
end
end)
connect(screen.Destroying,function()
if dead then return end
dead=true
if tween then local old=tween tween=nil old:Cancel()end
clearEntries()
for _,connection in ipairs(connections)do connection:Disconnect()end
table.clear(connections)
if uiVisual.resetOptionsIdle==reset then uiVisual.resetOptionsIdle=nil end
end)
end

-- Navegacion fija debajo de la palabra: selector, lista y pestanas.
function uiVisual.normalizeSectionsMode(mode)
    if mode == "Off" then return "Off" end
    if mode == "Tabs" or mode == "Bottom" then return "Tabs" end
    return "Selector"
end
function uiVisual.restoreSectionsMode(mode, version)
    if version == 1 then return uiVisual.normalizeSectionsMode(mode) end
    return mode == "Bottom" and "Tabs" or "Selector"
end
function uiVisual.createFlatGroups(page, tabs, names)
    local headings = {}
    local summaries = {
        Moment = "Speed, jumps, movement and teleportation",
        Combat = "Bat, aimbot, counters and defense",
        Main = "Auto Steal, Auto Carry and brainrot",
        Visuals = "Colors, backgrounds, logo, sky, skins, effects and music",
        Settings = "Interface, performance, keybinds and configuration",
    }
    for index, name in ipairs(tabs) do
        local frame = Instance.new("Frame", page)
        frame.Name = "BlessFlatGroup_" .. name
        frame:SetAttribute("BlessLayoutDecoration", true)
        frame:SetAttribute("BlessSearchGroup", true)
        frame:SetAttribute("BlessSearchTitle", names[name] or name)
        frame:SetAttribute("BlessFlatPage", name)
        frame.Size = UDim2.new(1, -4, 0, 60)
        frame.BackgroundTransparency = 1
        frame.BorderSizePixel = 0
        frame.LayoutOrder = index * 10000 - 300
        frame.Visible = false
        frame.ZIndex = 7
        local card = Instance.new("Frame", frame)
        card.Name = "GroupCard"
        card.Size = UDim2.new(1, 0, 1, -8)
        card.Position = UDim2.fromOffset(0, 8)
        card.BackgroundColor3 = Color3.fromRGB(9, 9, 9)
        card.BackgroundTransparency = 0.06
        card.BorderSizePixel = 0
        card.ZIndex = 7
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
        local stroke = Instance.new("UIStroke", card)
        stroke.Color = Color3.fromRGB(54, 54, 54)
        stroke.Thickness = 1
        local title = Instance.new("TextLabel", card)
        title.Name = "GroupTitle"
        title.Size = UDim2.new(1, -110, 0, 22)
        title.Position = UDim2.fromOffset(12, 4)
        title.BackgroundTransparency = 1
        title.Text = string.upper(names[name] or name)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 12
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 8
        local count = Instance.new("TextLabel", card)
        count.Name = "GroupCount"
        count.Size = UDim2.fromOffset(86, 18)
        count.Position = UDim2.new(1, -98, 0, 8)
        count.BackgroundTransparency = 1
        count.Text = ""
        count.Font = Enum.Font.GothamMedium
        count.TextSize = 9
        count.TextColor3 = Color3.fromRGB(160, 160, 160)
        count.TextXAlignment = Enum.TextXAlignment.Right
        count.ZIndex = 8
        local summary = Instance.new("TextLabel", card)
        summary.Name = "GroupSummary"
        summary.Size = UDim2.new(1, -24, 0, 18)
        summary.Position = UDim2.fromOffset(12, 28)
        summary.BackgroundTransparency = 1
        summary.Text = summaries[name] or ""
        summary.Font = Enum.Font.GothamMedium
        summary.TextSize = 9
        summary.TextColor3 = Color3.fromRGB(170, 170, 170)
        summary.TextXAlignment = Enum.TextXAlignment.Left
        summary.TextTruncate = Enum.TextTruncate.AtEnd
        summary.ZIndex = 8
        headings[name] = frame
    end
    return {
        Headings = headings,
        Refresh = function(enabled, counts)
            for name, frame in pairs(headings) do
                local count = counts[name] or 0
                frame.Visible = enabled and count > 0
                frame.GroupCard.GroupCount.Text = tostring(count) .. " OPTIONS"
                uiVisual.refreshTheme(frame)
            end
        end,
    }
end

function uiVisual.createSectionNavigation(mainFrame, rail, tabs, names, preferences, selectSection)
    local connections, items = {}, {}
    local lastSection
    local function connect(signal, callback)
        local connection = signal:Connect(callback)
        connections[#connections + 1] = connection
        return connection
    end
    local function make(class, parent, properties)
        local object = Instance.new(class)
        for key, value in pairs(properties) do object[key] = value end
        object.Parent = parent
        return object
    end
    local function round(object, radius)
        make("UICorner", object, {CornerRadius = UDim.new(0, radius)})
    end
    local function border(object)
        return make("UIStroke", object, {
            Color = Color3.fromRGB(48, 48, 48), Thickness = 1,
            Transparency = 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        })
    end
    local function textButton(parent, name, text, size, position, zIndex)
        local button = make("TextButton", parent, {
            Name = name, Text = text, Size = size, Position = position,
            Font = Enum.Font.GothamBold, TextSize = 13,
            TextColor3 = Color3.fromRGB(248, 248, 248),
            BackgroundColor3 = Color3.fromRGB(8, 8, 8),
            BackgroundTransparency = 0, BorderSizePixel = 0,
            AutoButtonColor = false, Active = true, ZIndex = zIndex,
        })
        button:SetAttribute("NoPressAnimation", true)
        return button
    end

    local selector = make("Frame", rail, {
        Name = "SectionSelector", BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1), ZIndex = 52,
    })
    local previous = textButton(selector, "PreviousSection", "<",
        UDim2.new(0, 38, 1, -8), UDim2.fromOffset(4, 4), 55)
    local nextButton = textButton(selector, "NextSection", ">",
        UDim2.new(0, 38, 1, -8), UDim2.new(1, -42, 0, 4), 55)
    for _, button in ipairs({previous, nextButton}) do
        button.TextSize = 21
        button.Font = Enum.Font.GothamMedium
        round(button, 9)
        border(button)
    end
    local current = textButton(selector, "CurrentSection", "MAIN",
        UDim2.new(1, -100, 1, -8), UDim2.fromOffset(50, 4), 55)
    current.BackgroundTransparency = 1
    current.TextSize = 14
    local indicator = make("TextLabel", current, {
        Name = "OpenIndicator", Text = "v", Font = Enum.Font.GothamMedium,
        TextSize = 9, TextColor3 = Color3.fromRGB(170, 170, 170),
        BackgroundTransparency = 1, Active = false,
        Size = UDim2.fromOffset(12, 12), Position = UDim2.new(1, -12, 0.5, -6),
        ZIndex = 56,
    })
    for _, position in ipairs({UDim2.new(0, 46, 0, 10), UDim2.new(1, -47, 0, 10)}) do
        make("Frame", selector, {
            Size = UDim2.new(0, 1, 1, -20), Position = position,
            BackgroundColor3 = Color3.fromRGB(48, 48, 48), BorderSizePixel = 0,
            ZIndex = 53,
        })
    end

    local dismiss = textButton(mainFrame, "DismissSectionMenu", "",
        UDim2.fromScale(1, 1), UDim2.fromOffset(0, 0), 45)
    dismiss.BackgroundTransparency = 1
    dismiss.Visible = false
    local menu = make("Frame", mainFrame, {
        Name = "SectionMenu", Size = UDim2.new(1, -16, 0, 190),
        Position = UDim2.fromOffset(8, 176),
        BackgroundColor3 = Color3.fromRGB(8, 8, 8),
        BorderSizePixel = 0, BackgroundTransparency = 0,
        Active = true, ClipsDescendants = true, Visible = false, ZIndex = 70,
    })
    round(menu, 12)
    border(menu)
    make("TextLabel", menu, {
        Text = "SECTIONS", Font = Enum.Font.GothamBold, TextSize = 9,
        TextColor3 = Color3.fromRGB(170, 170, 170),
        TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(13, 8), Size = UDim2.new(1, -26, 0, 18),
        Active = false, ZIndex = 72,
    })
    local list = make("Frame", menu, {
        Name = "SectionChoices", Position = UDim2.fromOffset(8, 34),
        Size = UDim2.new(1, -16, 1, -42), BackgroundTransparency = 1, ZIndex = 72,
    })
    make("UIListLayout", list, {
        Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
    })
    local function close()
        menu.Visible, dismiss.Visible = false, false
        indicator.Text = "v"
    end
    local function choose(name)
        close()
        selectSection(name)
    end
    for index, name in ipairs(tabs) do
        local entry = textButton(list, "SectionChoice_" .. name, string.upper(names[name] or name),
            UDim2.new(1, 0, 0, 34), UDim2.fromOffset(0, 0), 74)
        entry.LayoutOrder = index
        entry.TextSize = 11
        entry.TextXAlignment = Enum.TextXAlignment.Left
        entry:SetAttribute("FearThemeRole", "TabButton")
        entry:SetAttribute("FearSelected", false)
        round(entry, 8)
        border(entry)
        make("UIPadding", entry, {PaddingLeft = UDim.new(0, 13)})
        make("TextLabel", entry, {
            Text = ">", Font = Enum.Font.GothamMedium, TextSize = 12,
            TextColor3 = Color3.fromRGB(170, 170, 170),
            Size = UDim2.fromOffset(22, 34), Position = UDim2.new(1, -25, 0, 0),
            BackgroundTransparency = 1, Active = false, ZIndex = 75,
        })
        items[name] = entry
        connect(entry.Activated, function() choose(name) end)
    end
    local function step(direction)
        if preferences.sectionsMode ~= "Selector" then return end
        local index = table.find(tabs, preferences.tab) or 1
        choose(tabs[(index - 1 + direction) % #tabs + 1])
    end
    connect(previous.Activated, function() step(-1) end)
    connect(nextButton.Activated, function() step(1) end)
    connect(current.Activated, function()
        if preferences.sectionsMode ~= "Selector" or not mainFrame.Visible then return end
        local opened = not menu.Visible
        menu.Visible, dismiss.Visible = opened, opened
        indicator.Text = opened and "^" or "v"
    end)
    connect(dismiss.Activated, close)
    connect(mainFrame:GetPropertyChangedSignal("Visible"), function()
        if not mainFrame.Visible then close() end
    end)
    connect(mainFrame.Destroying, function()
        for _, connection in ipairs(connections) do connection:Disconnect() end
        connections = {}
    end)

    local api = {Menu = menu, Selector = selector, Current = current,
        Previous = previous, Next = nextButton, Dismiss = dismiss, Items = items, Close = close}
    function api.Refresh(mode, name, searching)
        selector.Visible = mode == "Selector"
        current.Text = string.upper(names[name] or name)
        local count = 0
        for key, entry in pairs(items) do
            entry.Visible = key ~= name
            if entry.Visible then count = count + 1 end
        end
        local height = 42 + count * 34 + math.max(0, count - 1) * 4
        menu.Size = UDim2.new(1, -16, 0, height)
        menu.AnchorPoint = Vector2.new(0,1)
        menu.Position = UDim2.new(0,8,rail.Position.Y.Scale,rail.Position.Y.Offset-8)
        if mode ~= "Selector" or searching or lastSection ~= name then close() end
        lastSection = name
        uiVisual.refreshTheme(selector)
        uiVisual.refreshTheme(menu)
    end
    return api
end

function buildGui()
-- Control styling is scoped to option rows; the original window stays intact.
local UI_CONFIG={Text=Color3.fromRGB(240,240,240),Accent=Color3.new(1,1,1),Surface=Color3.fromRGB(18,18,18),Surface2=Color3.fromRGB(78,78,78),ActiveSurface=Color3.fromRGB(172,172,172),ActiveText=Color3.fromRGB(12,12,12),Font=Enum.Font.GothamBold,OptionTransparency=.24,ButtonOffTransparency=.72,MobileButtonOffTransparency=0,MobileButtonOnBg=Color3.new(1,1,1),MobileButtonOffBg=Color3.new(0,0,0),MobileButtonOnText=Color3.new(0,0,0),MobileButtonOffText=Color3.new(1,1,1),MobileButtonOffStroke=Color3.new(1,1,1)}
uiVisual.syncThemeControls=function()
 local p=uiVisual.getThemePalette()
 UI_CONFIG.Accent=p.primary
 UI_CONFIG.Text=p.text
 UI_CONFIG.Surface=p.surface
 UI_CONFIG.Surface2=p.outline
 UI_CONFIG.ActiveSurface=p.active
 UI_CONFIG.ActiveText=Color3.new(1,1,1)
 UI_CONFIG.OptionTransparency=.08
 UI_CONFIG.MobileButtonOnBg=p.active
 UI_CONFIG.MobileButtonOffBg=p.surface
 UI_CONFIG.MobileButtonOnText=Color3.new(1,1,1)
 UI_CONFIG.MobileButtonOffText=p.text
 UI_CONFIG.MobileButtonOffStroke=p.outline
 UI_CONFIG.MobileButtonOnStroke=p.light
end
uiVisual.syncThemeControls()
local function new(class,properties,parent)
    local object=Instance.new(class)
    object:SetAttribute("BlessModernControl",true)
    for key,value in pairs(properties)do object[key]=value end
    if parent then object.Parent=parent end
    return object
end
local function corner(parent,radius)return new("UICorner",{CornerRadius=UDim.new(0,radius)},parent)end
local function stroke(parent,color,width,alpha)return new("UIStroke",{Color=color,Thickness=width or 1,Transparency=alpha or 0},parent)end
uiVisual.isModernObject=function(object)
    local node=object
    while node do
        if node:GetAttribute("BlessModernControl")==true then return true end
        node=node.Parent
    end
    return false
end
local function themeObject(object)uiVisual.candySkin(object)end
local legacyRefreshTheme=uiVisual.refreshTheme
uiVisual.refreshTheme=function(root)
 root=root or main
 if not root then return end
 uiVisual.syncThemeControls()
 legacyRefreshTheme(root)
 uiVisual.candyRefresh(root)
end
local legacyTween=uiVisual.tween
uiVisual.tween=function(object, properties, duration)
    if not uiVisual.isModernObject(object)then return legacyTween(object,properties,duration)end
    if object then for key,value in pairs(properties) do object[key]=value end end
end

local legacyPaintSwitch=uiVisual.paintBlessSwitch
local switchTweenService=game:GetService("TweenService")
local switchTweenInfo=TweenInfo.new(.24,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
local switchTweens=setmetatable({},{__mode="k"})
local switchStates=setmetatable({},{__mode="k"})
local function stopSwitchTween(track)
    local running=switchTweens[track]
    if running then for _,tween in ipairs(running)do tween:Cancel()end end
    switchTweens[track]=nil
end
-- BLESS switches: compact, understated dark capsule with a round indicator.
-- Their state is kept in FearToggleOn; existing callbacks and saves remain unchanged.
uiVisual.addSwitchParts=function(track)
    track:SetAttribute("FearThemeRole","BlessSwitchTrack")
    track.BackgroundColor3=Color3.fromRGB(20,20,20)
    track.BackgroundTransparency=.12
    track.BorderSizePixel=0
    if track:IsA("TextButton")then track.Text="";track.AutoButtonColor=false end
    local rounding=corner(track,99)
    rounding.CornerRadius=UDim.new(1,0)
    local edge=stroke(track,Color3.fromRGB(72,72,72),1,.6)
    edge.Name="SwitchEdge"
    local knob=new("Frame",{
        Name="Knob",Size=UDim2.fromOffset(14,14),Position=UDim2.new(0,3,.5,-7),
        BackgroundColor3=Color3.fromRGB(112,112,112),BackgroundTransparency=.1,
        BorderSizePixel=0,ZIndex=track.ZIndex+2,Active=false,
    },track)
    local knobCorner=corner(knob,99)
    knobCorner.CornerRadius=UDim.new(1,0)
    -- A very subtle edge defines the thumb without an ON/OFF label.
    local knobEdge=stroke(knob,Color3.fromRGB(184,184,184),1,.82)
    knobEdge.Name="KnobEdge"
    switchStates[track]=false
    track.Destroying:Connect(function()stopSwitchTween(track);switchStates[track]=nil end)
    uiVisual.candyKnob(knob)
    uiVisual.candySwitch(track)
    return knob,edge
end
uiVisual.paintBlessSwitch=function(track,animate)
    if not uiVisual.isModernObject(track)then return legacyPaintSwitch(track,animate)end
    local knob=track:FindFirstChild("Knob")
    local edge=track:FindFirstChild("SwitchEdge")
    if not knob or not edge then return end
    local on=track:GetAttribute("FearToggleOn")==true
    if track.Parent then track.Parent:SetAttribute("FearToggleOn",on)end
    local changed=switchStates[track]~=on
    switchStates[track]=on
    -- Use real track dimensions so both 38x20 and existing embedded switches align.
    local goalX=on and UDim2.new(1,-17,.5,-7) or UDim2.new(0,3,.5,-7)
    local goals={

        {object=knob,properties={Position=goalX,Rotation=on and 14 or -14}},

    }
    if changed or animate==false then stopSwitchTween(track)end
    if changed and animate and not _isLoading then
        local running={}
        switchTweens[track]=running
        for _,goal in ipairs(goals)do
            local tween=switchTweenService:Create(goal.object,switchTweenInfo,goal.properties)
            running[#running+1]=tween
            tween:Play()
        end
    elseif changed or animate==false or not switchTweens[track]then
        for _,goal in ipairs(goals)do
            for key,value in pairs(goal.properties)do goal.object[key]=value end
        end
    end
    uiVisual.candySwitch(track)
    uiVisual.refreshTheme(track.Parent)
end

uiVisual.refreshSwitchThemes=function()
    for track in pairs(switchStates)do
        if track.Parent then
            stopSwitchTween(track)
            uiVisual.paintBlessSwitch(track,false)
        end
    end
end

local SILVER=Color3.fromRGB(200,200,200)local BG=Color3.fromRGB(5,5,5)local BG2=Color3.fromRGB(11,11,11)local ROW_BG=Color3.fromRGB(16,16,16)local ROW_BORDER=Color3.fromRGB(158,158,158)local WHITE=Color3.fromRGB(249,249,249)local GRAY=Color3.fromRGB(174,174,174)local INP=Color3.fromRGB(13,13,13)local TAB_ACTIVE=Color3.fromRGB(200,200,200)local TAB_INACT=Color3.fromRGB(157,157,157)local SECT_LBL=Color3.fromRGB(221,221,221)local TOGGLE_BG=Color3.fromRGB(19,19,19)local KNOB=Color3.fromRGB(245,245,245)local TRACK_ACTIVE=Color3.fromRGB(174,174,174)local GUI_W,GUI_H=352,600 local old=game:GetService("CoreGui"):FindFirstChild("CandyHub")if old then old:Destroy()end local pg=LP:FindFirstChild("PlayerGui")if pg then local o=pg:FindFirstChild("CandyHub");if o then o:Destroy()end end gui=Instance.new("ScreenGui"); if _G.BlessIntro then _G.BlessIntro.Track(gui) end; gui.Name="CandyHub"do local cleanup=_G.BlessMoreButtonsCleanup gui.Destroying:Connect(function()if cleanup then cleanup()end end)end gui.ResetOnSpawn=false gui.ZIndexBehavior=Enum.ZIndexBehavior.Global gui.DisplayOrder=10 gui.IgnoreGuiInset=true pcall(function()if syn and syn.protect_gui then syn.protect_gui(gui)end end)if not pcall(function()gui.Parent=game:GetService("CoreGui")end)then gui.Parent=LP:WaitForChild("PlayerGui")end main=Instance.new("Frame",gui)main:SetAttribute("CandyWindow",true)main.Name="CandyHubWindow"main.Size=UDim2.new(0,GUI_W,0,GUI_H)local savedMainPos=uiPreferences.mainPosition or{XScale=0,XOffset=20,YScale=0,YOffset=2}main.Position=UDim2.new(savedMainPos.XScale or 0,savedMainPos.XOffset or 20,savedMainPos.YScale or 0,savedMainPos.YOffset or 2)main.Active=true main.BackgroundColor3=BG main.BackgroundTransparency=0 main.BorderSizePixel=0 main.ClipsDescendants=false Instance.new("UICorner",main).CornerRadius=UDim.new(0,14)local uiVisualBoundary=Instance.new("Frame",main)uiVisualBoundary.Name="UIVisualBoundary"uiVisualBoundary.Size=UDim2.fromScale(1,1)uiVisualBoundary.Position=UDim2.fromScale(0,0)uiVisualBoundary.BackgroundColor3=BG uiVisualBoundary.BackgroundTransparency=0 uiVisualBoundary.BorderSizePixel=0 uiVisualBoundary.ZIndex=1 uiVisualBoundary.Active=false uiVisualBoundary.ClipsDescendants=true Instance.new("UICorner",uiVisualBoundary).CornerRadius=UDim.new(0,14)do local glow=Instance.new("UIStroke",uiVisualBoundary)glow.Name="WindowNeonGlow"uiVisual.registerPerformanceGlow(glow)glow.Thickness=2 glow.Transparency=0.9 glow:SetAttribute("FearThemeRole","NeonEdge")local gradient=Instance.new("UIGradient",glow)gradient.Rotation=35 gradient:SetAttribute("FearThemeRole","NeonGradient")uiVisual.neonWindowGradient=gradient end do local edge=Instance.new("UIStroke",uiVisualBoundary)edge.Color=Color3.fromRGB(203,203,203)edge.Transparency=0.42 edge.Thickness=1 edge:SetAttribute("FearThemeRole","NeonEdge")end mainUIScale=Instance.new("UIScale",main)local function applyResponsiveMainScale()if not mainUIScale or not main or not main.Parent then return end local camera=workspace.CurrentCamera local viewport=camera and camera.ViewportSize or Vector2.new(1920,1080)local requestedScale=math.clamp((tonumber(uiScaleValue)or 100)/100,0.50,1.50)local safeMarginX=12 local safeMarginY=12 local activeWidth=GUI_W local activeHeight=GUI_H local fitX=math.max(0.35,(viewport.X-safeMarginX)/activeWidth)local fitY=math.max(0.35,(viewport.Y-safeMarginY)/activeHeight)local effectiveScale=math.min(requestedScale,fitX,fitY)uiVisual.mainTargetScale=effectiveScale if uiVisual.mainAnimating then return end mainUIScale.Scale=effectiveScale local maxX=math.max(0,(viewport.X/effectiveScale)-activeWidth)local maxY=math.max(0,(viewport.Y/effectiveScale)-activeHeight)local x=main.Position.X.Offset local y=main.Position.Y.Offset x=math.clamp(x,0,maxX)y=math.clamp(y,0,maxY)main.Position=UDim2.new(0,x,0,y) if refreshStealBarScale then refreshStealBarScale()end end _G.__SureApplyResponsiveMainScale=applyResponsiveMainScale applyResponsiveMainScale()task.defer(applyResponsiveMainScale)task.delay(0.25,applyResponsiveMainScale)local _sureViewportConn=nil local function hookSureViewport()if _sureViewportConn then _sureViewportConn:Disconnect()_sureViewportConn=nil end local camera=workspace.CurrentCamera if camera then _sureViewportConn=camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()task.defer(applyResponsiveMainScale)end)end end hookSureViewport()workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()hookSureViewport()task.defer(applyResponsiveMainScale)end)do -- Resolve decal IDs to their image texture, with a thumbnail fallback.
local function loadBackgroundAsset(image,asset)
 local serial=(image:GetAttribute("BlessBackgroundLoadSerial")or 0)+1
 image:SetAttribute("BlessBackgroundLoadSerial",serial)
 local function valid()
  return image.Parent~=nil and image:GetAttribute("BlessBackgroundLoadSerial")==serial
 end
 local function preload(uri)
  task.spawn(function()
   if valid()then pcall(function()ContentProvider:PreloadAsync({uri})end)end
  end)
 end
 image.Image=asset
 if asset==""then return end
 preload(asset)
 task.spawn(function()
  if not valid()or image.IsLoaded then return end
  local ok,objects=pcall(function()return game:GetObjects(asset)end)
  if not ok or type(objects)~="table"then return end
  local texture
  for _,object in ipairs(objects)do
   if typeof(object)=="Instance"then
    local candidates={object}
    for _,child in ipairs(object:GetDescendants())do candidates[#candidates+1]=child end
    for _,candidate in ipairs(candidates)do
     if candidate:IsA("Decal")or candidate:IsA("Texture")then
      local readable,value=pcall(function()return candidate.Texture end)
      if readable and type(value)=="string"and value~=""then texture=value;break end
     end
    end
   end
   if texture then break end
  end
  for _,object in ipairs(objects)do pcall(function()object:Destroy()end)end
  if valid()and not image.IsLoaded and texture and texture~=asset then
   image.Image=texture
   preload(texture)
  end
 end)
 task.delay(1.5,function()
  if not valid()or image.IsLoaded then return end
  local fallback=resolveExactImageAsset(asset)
  if fallback~=""and image.Image~=fallback then
   image.Image=fallback
   preload(fallback)
  end
 end)
end

uiVisual.loadPreviewAsset=loadBackgroundAsset
local backgroundImage=Instance.new("ImageLabel",uiVisualBoundary)
backgroundImage.Name="BackgroundImage"
backgroundImage.Size=UDim2.fromScale(1,1)
backgroundImage.BackgroundTransparency=1
backgroundImage.BorderSizePixel=0
backgroundImage.ImageColor3=Color3.new(1,1,1)
backgroundImage.ScaleType=Enum.ScaleType.Crop
backgroundImage.AnchorPoint=Vector2.new(0.5,0.5)
backgroundImage.Position=UDim2.fromScale(0.5,0.5)
backgroundImage.ZIndex=1
backgroundImage:SetAttribute("BlessBackgroundGhost",true)
Instance.new("UICorner",backgroundImage).CornerRadius=UDim.new(0,14)
local shade=Instance.new("Frame",uiVisualBoundary)
shade.Name="BackgroundShade"
shade.Size=UDim2.fromScale(1,1)
shade.BackgroundColor3=Color3.new(0,0,0)
shade.BorderSizePixel=0
shade.ZIndex=4
Instance.new("UICorner",shade).CornerRadius=UDim.new(0,14)
uiVisual.windowFadeAlpha=0
local loadedAsset
uiVisual.applyWindowBackgroundFade=function(value)
    uiVisual.windowFadeAlpha=math.clamp(value or 0,0,1)
    backgroundImage.ImageTransparency=uiVisual.windowFadeAlpha
end
uiVisual.refreshBackground=function()
    local index=math.clamp(math.floor(tonumber(uiVisual.backgroundColorIndex)or 1),1,#uiVisual.backgrounds)
    uiVisual.backgroundIndex=index
    uiVisual.normalBackgroundIndex=index
    uiVisual.hideBackgrounds=false
    local asset=uiVisual.backgrounds[index]
    -- Mostrar el fondo en modo cover: llenar toda la GUI con el menor recorte posible.
    backgroundImage.AnchorPoint=Vector2.new(0.5,0.5)
    backgroundImage.Position=UDim2.fromScale(0.5,0.5)
    backgroundImage.Size=UDim2.fromScale(1,1)
    backgroundImage.ScaleType=Enum.ScaleType.Crop
    backgroundImage.Visible=true
    if loadedAsset~=asset then loadedAsset=asset;loadBackgroundAsset(backgroundImage,asset)end
    uiVisual.applyWindowBackgroundFade(uiVisual.windowFadeAlpha)
    if uiVisual.refreshBackgroundCards then uiVisual.refreshBackgroundCards()end
end
uiVisual.refreshBackgroundColor=function()
    backgroundImage.ImageColor3=Color3.new(1,1,1)
    if uiVisual.refreshBackgroundCards then uiVisual.refreshBackgroundCards()end
    if uiVisual.refreshNameLogo then uiVisual.refreshNameLogo()end
end
uiVisual.applyBackgroundDarkness=function()
    shade.BackgroundTransparency=1-math.clamp(tonumber(uiVisual.backgroundDarkness)or 38,0,75)/100
end
uiVisual.syncAnimatedBackground=nil
uiVisual.fadeAnimatedBackground=nil
uiVisual.refreshBackground()
uiVisual.applyBackgroundDarkness()

end local shadow=Instance.new("Frame",main)shadow.Size=UDim2.new(1,12,1,12)shadow.Position=UDim2.new(0,-6,0,6)shadow.BackgroundColor3=Color3.fromRGB(0,0,0)shadow.BackgroundTransparency=0.9 shadow.BorderSizePixel=0 shadow.ZIndex=2 Instance.new("UICorner",shadow).CornerRadius=UDim.new(0,17)do
local viewport=Instance.new("Frame",main)
viewport.Name="WordViewport"
viewport.Size=UDim2.new(1,-20,0,110)
viewport.Position=UDim2.fromOffset(10,5)
viewport.BackgroundTransparency=1
viewport.BorderSizePixel=0
viewport.ClipsDescendants=true
viewport.ZIndex=18
local word=Instance.new("ImageLabel",viewport)
word.Name="CandyHubWord"
word.Size=UDim2.fromScale(1,1)
word.BackgroundTransparency=1
word.BorderSizePixel=0
word.Image=uiVisual.normalNameLogo
word.ImageColor3=uiVisual.getLogoColor()
word.ScaleType=Enum.ScaleType.Fit
word.ImageTransparency=0
word.ZIndex=19
word:SetAttribute("FearThemeRole","ThemeLogo")
word:SetAttribute("BlessLogoTint",true)
word:SetAttribute("BlessWordLayer",true)
local glows={}
for _,settings in ipairs({})do
local glow=Instance.new("ImageLabel",viewport)
glow.Name="BlessWordGlow"..tostring(#glows+1)
glow.Size=UDim2.new(1,settings[1],1,settings[1])
glow.Position=UDim2.fromOffset(-settings[1]/2,-settings[1]/2)
glow.BackgroundTransparency=1
glow.BorderSizePixel=0
glow.Image=word.Image
glow.ImageColor3=word.ImageColor3
glow.ImageTransparency=settings[2]
glow.ScaleType=word.ScaleType
glow.ZIndex=18
glow.Active=false
glow:SetAttribute("FearThemeRole","ThemeLogo")
glow:SetAttribute("BlessLogoTint",true)
glow:SetAttribute("BlessWordLayer",true)
glows[#glows+1]={image=glow,alpha=settings[2],padding=settings[1]}
end
uiVisual.applyWordFade=function(alpha)
alpha=math.clamp(tonumber(alpha)or 0,0,1)
word.ImageTransparency=alpha
for _,entry in ipairs(glows)do entry.image.ImageTransparency=entry.alpha+(1-entry.alpha)*alpha end
end
uiVisual.resetWordMotion=function()uiVisual.applyWordFade(0)end
uiVisual.nameLogoDisplayAsset=uiVisual.normalNameLogo
uiVisual.nameLogoUsesThumbnail=false
local requestedAsset=uiVisual.normalNameLogo
local requestSerial=0
uiVisual.refreshNameLogo=function()
if uiVisual.wordSelectorButton and uiVisual.wordSelectorButton.Parent then
uiVisual.wordSelectorButton.Text=uiVisual.nameLogoNames[uiVisual.nameLogoIndex]
end
if requestedAsset~=uiVisual.normalNameLogo and uiVisual.loadNameLogo then uiVisual.loadNameLogo()return end
local asset=uiVisual.nameLogoDisplayAsset or uiVisual.normalNameLogo
if word.Image~=asset then word.Image=asset end
-- Fixed geometry for both first render and every subsequent word selection.
-- No thumbnail-dependent enlargement or Crop: loading a preview must not resize the logo.
viewport.Size=UDim2.new(1,-20,0,110)
viewport.Position=UDim2.fromOffset(10,5)
word.AnchorPoint=Vector2.new(0,0)
word.Size=UDim2.fromScale(1,1)
word.Position=UDim2.fromScale(0,0)
word.ScaleType=Enum.ScaleType.Fit
word.ImageColor3=uiVisual.getLogoColor()
for _,entry in ipairs(glows)do
local glow=entry.image
if glow.Image~=asset then glow.Image=asset end
local padding=entry.padding
glow.Size=UDim2.new(word.Size.X.Scale,word.Size.X.Offset+padding,word.Size.Y.Scale,word.Size.Y.Offset+padding)
glow.Position=UDim2.new(word.Position.X.Scale,word.Position.X.Offset-padding/2,word.Position.Y.Scale,word.Position.Y.Offset-padding/2)
glow.ScaleType=word.ScaleType
glow.ImageColor3=word.ImageColor3
end
if uiVisual.refreshMiniLogo then uiVisual.refreshMiniLogo()end
if uiVisual.refreshNameLogoCards then uiVisual.refreshNameLogoCards()end
end
uiVisual.transitionNameLogo=function()uiVisual.refreshNameLogo()end
uiVisual.loadNameLogo=function()
requestSerial=requestSerial+1
local serial=requestSerial
local asset=uiVisual.normalNameLogo
requestedAsset=asset
uiVisual.nameLogoDisplayAsset=asset
uiVisual.nameLogoUsesThumbnail=false
uiVisual.refreshNameLogo()
local function valid()return serial==requestSerial and requestedAsset==asset and word.Parent~=nil and main.Parent~=nil end
local function showThumbnail()
if not valid()or word.IsLoaded then return end
uiVisual.nameLogoDisplayAsset=resolveExactImageAsset(asset)
uiVisual.nameLogoUsesThumbnail=true
uiVisual.refreshNameLogo()
end
task.delay(2,showThumbnail)
task.spawn(function()
if not valid()or word.IsLoaded then return end
local ok,objects=pcall(function()return game:GetObjects(asset)end)
if not ok or type(objects)~="table"then return end
local texture
for _,object in ipairs(objects)do
if typeof(object)=="Instance"then
local candidates={object}
for _,child in ipairs(object:GetDescendants())do candidates[#candidates+1]=child end
for _,candidate in ipairs(candidates)do
if candidate:IsA("Decal")or candidate:IsA("Texture")then
local readable,value=pcall(function()return candidate.Texture end)
if not readable or type(value)~="string"or value==""then readable,value=pcall(function()return candidate.ColorMapContent.Uri end)end
if readable and type(value)=="string"and value~=""then texture=value break end
end
end
end
if texture then break end
end
for _,object in ipairs(objects)do pcall(function()object:Destroy()end)end
if not valid()then return end
if texture and texture~=asset then
uiVisual.nameLogoDisplayAsset=texture
uiVisual.nameLogoUsesThumbnail=false
uiVisual.refreshNameLogo()
task.delay(2,showThumbnail)
elseif not word.IsLoaded then showThumbnail()end
end)
end
uiVisual.loadNameLogo()
end
local closeBtnGlow=Instance.new("TextLabel",main)closeBtnGlow.Name="CloseNeonGlow"closeBtnGlow.Size=UDim2.new(0,29,0,29)closeBtnGlow.Position=UDim2.new(1,-34,0,4)closeBtnGlow.Visible=false closeBtnGlow.BackgroundTransparency=1 closeBtnGlow.BorderSizePixel=0 closeBtnGlow.Text="−"closeBtnGlow.TextColor3=uiVisual.getThemeAccent()closeBtnGlow.TextTransparency=0.42 closeBtnGlow.TextStrokeColor3=uiVisual.getThemeAccent()closeBtnGlow.TextStrokeTransparency=0.02 closeBtnGlow.Font=Enum.Font.GothamBlack closeBtnGlow.TextSize=23 closeBtnGlow.ZIndex=199 closeBtnGlow:SetAttribute("FearThemeRole","NeonCloseGlow")local closeBtn=Instance.new("TextButton",main)closeBtn.Size=UDim2.new(0,27,0,27)closeBtn.Position=UDim2.new(1,-33,0,4)closeBtn.BackgroundColor3=Color3.fromRGB(0,0,0)closeBtn.BackgroundTransparency=0.22 closeBtn.BorderSizePixel=0 closeBtn.Text="−"Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)closeBtn.TextColor3=uiVisual.getThemePalette().light:Lerp(Color3.fromRGB(255,255,255),0.32)closeBtn.TextStrokeColor3=uiVisual.getThemeAccent()closeBtn.TextStrokeTransparency=0.04 closeBtn.Font=Enum.Font.GothamBlack closeBtn.TextSize=20 closeBtn.AutoButtonColor=false closeBtn.ZIndex=200 closeBtn:SetAttribute("FearThemeRole","NeonCloseText")closeBtn.MouseEnter:Connect(function()closeBtn.TextColor3=Color3.fromRGB(255,255,255)closeBtn.TextStrokeColor3=uiVisual.getThemePalette().light closeBtn.TextStrokeTransparency=0 closeBtnGlow.TextTransparency=0.18 end)closeBtn.MouseLeave:Connect(function()local palette=uiVisual.getThemePalette()closeBtn.TextColor3=palette.light:Lerp(Color3.fromRGB(255,255,255),0.32)closeBtn.TextStrokeColor3=uiVisual.getThemeAccent()closeBtn.TextStrokeTransparency=0.04 closeBtnGlow.TextTransparency=0.42 end)local dragHandle=Instance.new("TextButton",main)dragHandle.Name="WindowDragHandle"dragHandle.Size=UDim2.new(1,-54,0,84)dragHandle.Position=UDim2.new(0,0,0,0)dragHandle.BackgroundTransparency=1 dragHandle.BorderSizePixel=0 dragHandle.Text=""dragHandle.AutoButtonColor=false dragHandle.ZIndex=150 local draggingMain=false local dragInputMain=nil local dragStartMain=nil local mainStartPos=nil local function saveMainPosition()uiPreferences.mainPosition={XScale=main.Position.X.Scale,XOffset=main.Position.X.Offset,YScale=main.Position.Y.Scale,YOffset=main.Position.Y.Offset}task.defer(saveAllSettings)end dragHandle.Active=true local function beginMainDrag(input)if uiVisual.mainAnimating or not uiPreferences.visible then return end if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end local tween=uiVisual.tweens[main]if tween then tween:Cancel()end draggingMain=true dragInputMain=input dragStartMain=input.Position mainStartPos=main.Position end dragHandle.InputBegan:Connect(beginMainDrag)UIS.InputChanged:Connect(function(input)if not draggingMain or not dragStartMain or not mainStartPos then return end if input.UserInputType~=Enum.UserInputType.MouseMovement and input.UserInputType~=Enum.UserInputType.Touch then return end local scale=(mainUIScale and tonumber(mainUIScale.Scale))or 1 if scale<=0 then scale=1 end local delta=(input.Position-dragStartMain)/scale local x=mainStartPos.X.Offset+delta.X local y=mainStartPos.Y.Offset+delta.Y local viewport=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920,1080)local maxX=math.max(0,(viewport.X/scale)-GUI_W)local maxY=math.max(0,(viewport.Y/scale)-GUI_H)x=math.clamp(x,0,maxX)y=math.clamp(y,0,maxY)main.Position=UDim2.new(0,x,0,y)end)local function finishMainDrag(input)if not draggingMain then return end if input and dragInputMain and input~=dragInputMain and input.UserInputType~=Enum.UserInputType.MouseButton1 then return end draggingMain=false dragInputMain=nil dragStartMain=nil mainStartPos=nil saveMainPosition()end dragHandle.InputEnded:Connect(finishMainDrag)UIS.InputEnded:Connect(function(input)if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then finishMainDrag(input)end end)miniBtn=Instance.new("TextButton",gui)miniBtn.Size=UDim2.new(0,146,0,44)miniBtn.Position=UDim2.new(0,16,0,58)miniBtn.BackgroundColor3=BG2 miniBtn:SetAttribute("FearThemeRole","MiniOpenButton")miniBtn.BackgroundTransparency=0.04 miniBtn.BorderSizePixel=0 miniBtn.Text=""miniBtn.AutoButtonColor=false miniBtn.ZIndex=20 miniBtn.Visible=false Instance.new("UICorner",miniBtn).CornerRadius=UDim.new(0,9)do local edge=Instance.new("UIStroke",miniBtn)edge:SetAttribute("FearThemeRole","MiniOpenStroke")edge.Color=SILVER edge.Transparency=0.30 edge.Thickness=1.15 end local miniLogoGlow=Instance.new("ImageLabel",miniBtn)miniLogoGlow.Name="SureMiniLogoGlow"miniLogoGlow.AnchorPoint=Vector2.new(0.5,0.5)miniLogoGlow.Size=UDim2.new(1,-12,1,-6)miniLogoGlow.Position=UDim2.new(0.5,0,0.5,1)miniLogoGlow.BackgroundTransparency=1 miniLogoGlow.BorderSizePixel=0 miniLogoGlow.Image=resolveExactImageAsset(uiVisual.getCurrentNameLogoAsset())miniLogoGlow.ImageColor3=Color3.fromRGB(255,255,255)miniLogoGlow.ImageTransparency=0.70 miniLogoGlow.ScaleType=Enum.ScaleType.Fit miniLogoGlow.ZIndex=21 miniLogoGlow:SetAttribute("FearThemeRole","ThemeLogo")local miniGlowGradient=Instance.new("UIGradient",miniLogoGlow)miniGlowGradient:SetAttribute("FearThemeRole","ThemeImageGradient")local miniLogo=Instance.new("ImageLabel",miniBtn)miniLogo.Name="SureMiniLogo"miniLogo.AnchorPoint=Vector2.new(0.5,0.5)miniLogo.Size=UDim2.new(1,-18,1,-10)miniLogo.Position=UDim2.new(0.5,0,0.5,0)miniLogo.BackgroundTransparency=1 miniLogo.BorderSizePixel=0 miniLogo.Image=resolveExactImageAsset(uiVisual.getCurrentNameLogoAsset())miniLogo.ImageColor3=Color3.fromRGB(255,255,255)miniLogo.ImageTransparency=0 miniLogo.ScaleType=Enum.ScaleType.Fit miniLogo.ZIndex=22 miniLogo:SetAttribute("FearThemeRole","ThemeLogo")local miniLogoGradient=Instance.new("UIGradient",miniLogo)miniLogoGradient:SetAttribute("FearThemeRole","ThemeImageGradient")uiVisual.refreshMiniLogo=function()local index=math.clamp(math.floor(tonumber(uiVisual.nameLogoIndex)or 1),1,#uiVisual.nameLogos)local tinted=true
local chosen=uiVisual.getCurrentNameLogoAsset()
local asset=uiVisual.nameLogoDisplayAsset or chosen
miniLogo.Image=asset miniLogoGlow.Image=asset
if uiVisual.colorNames[index]=="Candy"then
 miniLogo.Size=UDim2.new(1,-10,1,-8)
 miniLogo.Position=UDim2.new(0.5,0,0.5,0)
 miniLogoGlow.Size=miniLogo.Size
 miniLogoGlow.Position=miniLogo.Position
 miniLogo.ScaleType=Enum.ScaleType.Fit
else
 miniLogo.Size=UDim2.new(1,-18,1,-10)
 miniLogo.Position=UDim2.new(0.5,0,0.5,0)
 miniLogoGlow.Size=UDim2.new(1,-12,1,-6)
 miniLogoGlow.Position=UDim2.new(0.5,0,0.5,1)
 miniLogo.ScaleType=Enum.ScaleType.Fit
end
miniLogoGlow.ScaleType=miniLogo.ScaleType
miniLogo:SetAttribute("BlessLogoTint",tinted)
miniLogoGlow:SetAttribute("BlessLogoTint",tinted)
miniLogo.ImageColor3=uiVisual.getLogoColor()
miniLogoGlow.ImageColor3=miniLogo.ImageColor3
miniGlowGradient.Enabled=false
local gradient=miniLogo:FindFirstChildOfClass("UIGradient") if gradient then gradient.Enabled=not tinted end end uiVisual.refreshMiniLogo()uiVisual.refreshTheme(miniBtn)local miniDragging=false local miniDragStart=nil local miniStartPos=nil local miniMoved=false local suppressMiniActivateUntil=0 miniBtn.Active=true miniBtn.InputBegan:Connect(function(input)if uiLocked then return end if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end miniDragging=true miniDragStart=input.Position miniStartPos=miniBtn.Position miniMoved=false end)UIS.InputChanged:Connect(function(input)if not miniDragging or uiLocked or not miniDragStart or not miniStartPos then return end if input.UserInputType~=Enum.UserInputType.MouseMovement and input.UserInputType~=Enum.UserInputType.Touch then return end local delta=input.Position-miniDragStart if delta.Magnitude>=6 then miniMoved=true end local viewport=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920,1080)local width=miniBtn.AbsoluteSize.X>0 and miniBtn.AbsoluteSize.X or 146 local height=miniBtn.AbsoluteSize.Y>0 and miniBtn.AbsoluteSize.Y or 44 local x=math.clamp(miniStartPos.X.Offset+delta.X,0,math.max(0,viewport.X-width))local y=math.clamp(miniStartPos.Y.Offset+delta.Y,0,math.max(0,viewport.Y-height))miniBtn.Position=UDim2.new(0,x,0,y)end)local function finishMiniDrag(input)if not miniDragging then return end if input and input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end miniDragging=false miniDragStart=nil miniStartPos=nil if miniMoved then suppressMiniActivateUntil=os.clock()+0.25 end miniMoved=false end miniBtn.InputEnded:Connect(finishMiniDrag)UIS.InputEnded:Connect(function(input)if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then finishMiniDrag(input)end end)local transition=0 local mainMotion={}local motionConnection local fadeEntries={}local windowFade=Instance.new("NumberValue",main)windowFade.Name="WindowFade"windowFade.Value=0 local function applyMainFade(alpha)for _,entry in ipairs(fadeEntries)do local object=entry.object if object.Parent then local current=object[entry.property]if entry.last~=nil and math.abs(current-entry.last)>0.00001 then entry.base=current end local value=entry.base+(1-entry.base)*alpha entry.last=value object[entry.property]=value end end if uiVisual.applyWindowBackgroundFade then uiVisual.applyWindowBackgroundFade(alpha)end if uiVisual.applyWordFade then uiVisual.applyWordFade(alpha)end end local function captureMainFade()if#fadeEntries>0 then return end local objects=main:GetDescendants()objects[#objects+1]=main local function capture(object,property)local value=object[property]if type(value)=="number"then fadeEntries[#fadeEntries+1]={object=object,property=property,base=value}end end for _,object in ipairs(objects)do if not object:GetAttribute("BlessBackgroundGhost")and not object:GetAttribute("BlessWordLayer")then if object:IsA("GuiObject")then capture(object,"BackgroundTransparency")end if object:IsA("TextLabel")or object:IsA("TextButton")or object:IsA("TextBox")then capture(object,"TextTransparency")capture(object,"TextStrokeTransparency")elseif object:IsA("ImageLabel")or object:IsA("ImageButton")then if object.Name~="BackgroundImage"and object.Name~="BackgroundImageNext"then capture(object,"ImageTransparency")end elseif object:IsA("UIStroke")then capture(object,"Transparency")end if object:IsA("ScrollingFrame")then capture(object,"ScrollBarImageTransparency")end end end end local function resetMainFade()windowFade.Value=0 applyMainFade(0)table.clear(fadeEntries)end windowFade.Changed:Connect(applyMainFade)local function cancelMainMotion()transition+=1 if motionConnection then motionConnection:Disconnect()motionConnection=nil end for _,tween in ipairs(mainMotion)do tween:Cancel()end table.clear(mainMotion)uiVisual.mainAnimating=false end local function currentMainRestPosition()local p=uiPreferences.mainPosition or{XScale=0,XOffset=20,YScale=0,YOffset=2}return UDim2.new(p.XScale or 0,p.XOffset or 20,p.YScale or 0,p.YOffset or 2)end local function animateMain(show)local wasVisible=main.Visible cancelMainMotion()if uiVisual.resetOptionsIdle then uiVisual.resetOptionsIdle(true)end captureMainFade()local token=transition local rest=currentMainRestPosition()local folded=UDim2.new(rest.X.Scale,rest.X.Offset+30,rest.Y.Scale,rest.Y.Offset+14)local scale=uiVisual.mainTargetScale or 1 uiPreferences.visible=show uiVisual.mainAnimating=true miniBtn.Visible=false if show and not wasVisible then windowFade.Value=1 main.Position=folded end main.Visible=true local info=TweenInfo.new(show and 0.30 or 0.20,Enum.EasingStyle.Quint,show and Enum.EasingDirection.Out or Enum.EasingDirection.In)mainMotion[1]=TS:Create(main,info,{Position=show and rest or folded})mainMotion[2]=TS:Create(windowFade,info,{Value=show and 0 or 1})motionConnection=mainMotion[2].Completed:Connect(function(state)if token~=transition or state~=Enum.PlaybackState.Completed or not main.Parent then return end if motionConnection then motionConnection:Disconnect()motionConnection=nil end main.Visible=show main.Position=rest mainUIScale.Scale=uiVisual.mainTargetScale or scale miniBtn.Visible=not show uiVisual.mainAnimating=false table.clear(mainMotion)resetMainFade()end)mainMotion[1]:Play()mainMotion[2]:Play()task.defer(saveAllSettings)end showGui=function()if uiPreferences.visible then return end animateMain(true)end hideGui=function()if not uiPreferences.visible then return end animateMain(false)end main.Destroying:Connect(cancelMainMotion)closeBtn.Activated:Connect(hideGui)miniBtn.Activated:Connect(function()if os.clock()<suppressMiniActivateUntil then return end showGui()end)local tabs={"Moment","Combat","Main","Visuals","Settings"}
local tabDisplayNames={Moment="Movement",Combat="Combat",Main="Core",Visuals="Visuals",Settings="Settings"}
if uiPreferences.tab=="Extra"then uiPreferences.tab="Settings";uiPreferences.scroll.Settings=0 end
local contentPages,tabButtons,pageRanks,sectionNav={},{},{}
local railH=42
local rail=Instance.new("Frame",main)
rail.Name="BlessBottomSections"
rail.Size=UDim2.new(1,-16,0,railH)
rail.Position=UDim2.new(0,8,1,-(railH+8))
rail.BackgroundColor3=Color3.fromRGB(9,9,9)
rail.BackgroundTransparency=0.24
rail.BorderSizePixel=0
rail.ZIndex=50
Instance.new("UICorner",rail).CornerRadius=UDim.new(0,12)
local railStroke=Instance.new("UIStroke",rail)
railStroke.Color=Color3.fromRGB(48,48,48)
railStroke.Thickness=1
railStroke.Transparency=0
local tabContent=Instance.new("Frame",main)
tabContent.Name="BlessContent"
tabContent.Position=UDim2.fromOffset(8,126)
tabContent.Size=UDim2.new(1,-16,1,-184)
tabContent.BackgroundTransparency=1
tabContent.ClipsDescendants=true
tabContent.ZIndex=5
local function makePage(name)
local page=Instance.new("ScrollingFrame",tabContent)
page.Name=name.."Page"
page.Size=UDim2.fromScale(1,1)
page.BackgroundTransparency=1
page.BorderSizePixel=0
page.ClipsDescendants=true
page.ScrollBarThickness=2
page.ScrollBarImageTransparency=0.6
page.ScrollBarImageColor3=uiVisual.getThemeAccent()
page.CanvasSize=UDim2.fromOffset(0,0)
page.AutomaticCanvasSize=Enum.AutomaticSize.None
page.ScrollingDirection=Enum.ScrollingDirection.Y
page.ZIndex=6
local layout=Instance.new("UIListLayout",page)
layout.SortOrder=Enum.SortOrder.LayoutOrder
layout.Padding=UDim.new(0,5)
layout.HorizontalAlignment=Enum.HorizontalAlignment.Center
local padding=Instance.new("UIPadding",page)
padding.PaddingLeft=UDim.new(0,3)
padding.PaddingRight=UDim.new(0,5)
padding.PaddingTop=UDim.new(0,2)
padding.PaddingBottom=UDim.new(0,12)
local function updateCanvas()
    if not page.Parent then return end
    local count, height = 0, 14
    for _, row in ipairs(page:GetChildren()) do
        if row:IsA("GuiObject") and row.Visible then
            count = count + 1
            height = height + math.max(0, row.Size.Y.Offset)
        end
    end
    height = height + math.max(0, count - 1) * 5
    local measured = layout.AbsoluteContentSize
    if measured then height = math.max(height, measured.Y + 14) end
    page.CanvasSize = UDim2.fromOffset(0, height)
end
local watched = setmetatable({}, {__mode="k"})
local function watchRow(row)
    if not row:IsA("GuiObject") or watched[row] then return end
    watched[row] = true
    row:GetPropertyChangedSignal("Size"):Connect(updateCanvas)
    row:GetPropertyChangedSignal("Visible"):Connect(updateCanvas)
    row:GetPropertyChangedSignal("LayoutOrder"):Connect(updateCanvas)
end
page.ChildAdded:Connect(function(row) watchRow(row); updateCanvas() end)
page.ChildRemoved:Connect(updateCanvas)
page:GetPropertyChangedSignal("Visible"):Connect(function() updateCanvas(); task.defer(updateCanvas) end)
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
updateCanvas()
contentPages[name]=page
return page
end
local allPage=makePage("All")
local flatGroups=uiVisual.createFlatGroups(allPage,tabs,tabDisplayNames)
local rowOrigins={}
local function rememberRow(row, page, order)
    if not row or not row:IsA("GuiObject") or row:GetAttribute("BlessTopOption") or row:GetAttribute("BlessLayoutDecoration") then return end
    local origin=rowOrigins[row]
    if origin then return origin end
    local name=row:GetAttribute("BlessSourcePage")
    if not contentPages[name] or name=="All" then
        for key, source in pairs(contentPages) do
            if key~="All" and source==page then name=key;break end
        end
    end
    if not contentPages[name] or name=="All" then name="Main" end
    origin={page=name,order=order or row.LayoutOrder}
    rowOrigins[row]=origin
    row:SetAttribute("BlessSourcePage",name)
    row:SetAttribute("BlessSourceOrder",origin.order)
    return origin
end
local layoutChanging,reconcileQueued=false,false
local layoutSerial=0
local function styleTab(button,active)
button:SetAttribute("FearThemeRole","TabButton")
button:SetAttribute("FearSelected",active==true)
uiVisual.refreshTheme(button)
end
local searchQuery=""
local topOptionRows={}
local function registerTopOption(row,order)
    row:SetAttribute("BlessTopOption",true)
    row.LayoutOrder=order
    row.Size=UDim2.new(1,-4,0,row.Size.Y.Offset)
    row.Position=UDim2.fromOffset(0,0)
    topOptionRows[#topOptionRows+1]=row
    return row
end
local function registerMainOption(row,order)
    row:SetAttribute("BlessMainOption",true)
    row:SetAttribute("BlessTopOption",nil)
    row.LayoutOrder=order
    row.Size=UDim2.new(1,-4,0,row.Size.Y.Offset)
    row.Position=UDim2.fromOffset(0,0)
    rowOrigins[row]={page="Moment",order=order}
    row:SetAttribute("BlessSourcePage","Moment")
    row.Parent=contentPages.Moment
    return row
end
local searchShell=Instance.new("Frame",allPage)
searchShell.Name="OptionSearchShell"
searchShell:SetAttribute("FearThemeRole","OptionSearchShell")
searchShell:SetAttribute("BlessModernControl",true)
searchShell:SetAttribute("CandySearchFocused",false)
searchShell.Size=UDim2.new(1,-16,0,34)
searchShell.Position=UDim2.fromOffset(0,0)
searchShell.BackgroundColor3=Color3.new(1,1,1)
searchShell.BackgroundTransparency=.08
searchShell.BorderSizePixel=0
searchShell.ZIndex=12
Instance.new("UICorner",searchShell).CornerRadius=UDim.new(0,10)
local searchStroke=Instance.new("UIStroke",searchShell)
searchStroke.Thickness=1
searchStroke.Transparency=.6
searchStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
local searchIcon=Instance.new("Frame",searchShell)
searchIcon.Name="SearchIcon"
searchIcon.Position=UDim2.fromOffset(12,10)
searchIcon.Size=UDim2.fromOffset(11,11)
searchIcon.BackgroundTransparency=1
searchIcon.BorderSizePixel=0
searchIcon.ZIndex=14
Instance.new("UICorner",searchIcon).CornerRadius=UDim.new(.5,0)
local iconStroke=Instance.new("UIStroke",searchIcon)
iconStroke.Thickness=1.5
iconStroke.Transparency=.14
iconStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
local iconHandle=Instance.new("Frame",searchShell)
iconHandle.Name="SearchHandle"
iconHandle.AnchorPoint=Vector2.new(.5,.5)
iconHandle.Size=UDim2.fromOffset(6,1.5)
iconHandle.Position=UDim2.fromOffset(23,22)
iconHandle.Rotation=45
iconHandle.BackgroundTransparency=.14
iconHandle.BorderSizePixel=0
iconHandle.ZIndex=14
Instance.new("UICorner",iconHandle).CornerRadius=UDim.new(.5,0)
local searchBox=Instance.new("TextBox",searchShell)
searchBox.Name="OptionSearch"
searchBox:SetAttribute("FearThemeRole","OptionSearch")
searchBox.Size=UDim2.new(1,-76,1,0)
searchBox.Position=UDim2.fromOffset(36,0)
searchBox.BackgroundTransparency=1
searchBox.BorderSizePixel=0
searchBox.Text=""
searchBox.PlaceholderText="Search options..."
searchBox.Font=Enum.Font.GothamMedium
searchBox.TextSize=12
searchBox.TextXAlignment=Enum.TextXAlignment.Left
searchBox.TextYAlignment=Enum.TextYAlignment.Center
searchBox.ClearTextOnFocus=false
searchBox.MultiLine=false
searchBox.TextStrokeTransparency=1
searchBox.ZIndex=13
local searchClear=Instance.new("TextButton",searchShell)
searchClear.Name="OptionSearchClear"
searchClear:SetAttribute("FearThemeRole","OptionSearchClear")
searchClear:SetAttribute("NoPressAnimation",true)
searchClear.Size=UDim2.fromOffset(26,26)
searchClear.Position=UDim2.new(1,-31,0,4)
searchClear.BackgroundTransparency=.95
searchClear.BorderSizePixel=0
searchClear.Text=""
searchClear.AutoButtonColor=false
searchClear.ZIndex=14
Instance.new("UICorner",searchClear).CornerRadius=UDim.new(0,7)
for _,rotation in ipairs({45,-45})do
 local line=Instance.new("Frame",searchClear)
 line.AnchorPoint=Vector2.new(.5,.5)
 line.Position=UDim2.fromScale(.5,.5)
 line.Size=UDim2.fromOffset(9,1.4)
 line.Rotation=rotation
 line.BackgroundTransparency=.35
 line.BorderSizePixel=0
 line.ZIndex=15
 Instance.new("UICorner",line).CornerRadius=UDim.new(.5,0)
end
searchBox.Focused:Connect(function()
 searchShell:SetAttribute("CandySearchFocused",true)
 uiVisual.paintCandySearch(searchShell)
end)
searchBox.FocusLost:Connect(function()
 searchShell:SetAttribute("CandySearchFocused",false)
 uiVisual.paintCandySearch(searchShell)
end)
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
 uiVisual.paintCandySearch(searchShell)
end)
searchClear.MouseEnter:Connect(function()
 searchClear:SetAttribute("CandySearchHover",true)
 uiVisual.paintCandySearch(searchShell)
end)
searchClear.MouseLeave:Connect(function()
 searchClear:SetAttribute("CandySearchHover",false)
 uiVisual.paintCandySearch(searchShell)
end)
searchClear.Activated:Connect(function()
 searchBox.Text=""
 searchBox:ReleaseFocus()
end)
uiVisual.paintCandySearch(searchShell)
registerTopOption(searchShell,-1000)
local searchVisibility = setmetatable({}, {__mode = "k"})
local function filterOptions(rows)
    table.sort(rows, function(a, b) return a.LayoutOrder < b.LayoutOrder end)
    if searchQuery == "" then
        for _, row in ipairs(rows) do
            if searchVisibility[row] ~= nil then
                row.Visible = searchVisibility[row]
                searchVisibility[row] = nil
            end
        end
        return
    end
    local words = {}
    for word in searchQuery:gmatch("%S+") do words[#words + 1] = word end
    local aliases = {
        {"speed", "velocidad velocidades"}, {"carry", "carga cargar"},
        {"steal", "robo robar"}, {"word", "palabra logo id"},
        {"background", "fondo color colores"}, {"fondo", "background color colores"},
        {"darkness", "oscuridad brillo opacidad"}, {"reset", "reinicio reiniciar"},
        {"bind", "tecla teclas control"}, {"aimbot", "bate"},
    }
    local function titleFor(row)
        local title = tostring(row:GetAttribute("BlessSearchTitle") or "")
        if not row:GetAttribute("BlessSearchGroup") then
            local labels = {title}
            for _, item in ipairs(row:GetDescendants()) do
                if item:IsA("TextLabel") or item:IsA("TextButton") then
                    local visible = item.Visible ~= false
                    local parent = item.Parent
                    while visible and parent and parent ~= row do
                        if parent:IsA("GuiObject") and parent.Visible == false then visible = false end
                        parent = parent.Parent
                    end
                    if visible then labels[#labels + 1] = item.Text end
                end
            end
            title = table.concat(labels, " ")
        end
        title = string.lower(title)
        for _, alias in ipairs(aliases) do
            if title:find(alias[1], 1, true) then title = title .. " " .. alias[2] end
        end
        return title
    end
    local function matches(title)
        for _, word in ipairs(words) do
            if not title:find(word, 1, true) then return false end
        end
        return true
    end
    local group, section, groupTitle, sectionTitle = nil, nil, "", ""
    local groupHasResult, sectionHasResult = false, false
    local function finishSection()
        if section then section.Visible = searchVisibility[section] and sectionHasResult end
        section, sectionTitle, sectionHasResult = nil, "", false
    end
    local function finishGroup()
        finishSection()
        if group then group.Visible = searchVisibility[group] and groupHasResult end
        group, groupTitle, groupHasResult = nil, "", false
    end
    for _, row in ipairs(rows) do
        if searchVisibility[row] == nil then searchVisibility[row] = row.Visible end
        local title = titleFor(row)
        if row:GetAttribute("BlessSearchGroup") then
            finishGroup()
            group, groupTitle = row, title
        elseif row:GetAttribute("BlessSearchSection") then
            finishSection()
            section, sectionTitle = row, title
        else
            local context = groupTitle .. " " .. sectionTitle .. " " .. title
            row.Visible = searchVisibility[row] and matches(context)
            if row.Visible then groupHasResult, sectionHasResult = true, true end
        end
    end
    finishGroup()
end

local function applyTabLayout()
    if not main.Parent then return end
    layoutChanging = true
    layoutSerial = layoutSerial + 1
    local serial = layoutSerial
    local mode = uiVisual.normalizeSectionsMode(uiPreferences.sectionsMode)
    uiPreferences.sectionsMode = mode
    local hasSections = mode ~= "Off"
    local sectioned = hasSections and searchQuery == ""
    if not contentPages[uiPreferences.tab] or uiPreferences.tab == "All" then uiPreferences.tab = "Moment" end
    rail.Visible = hasSections
    rail.Position = UDim2.new(0,8,1,-(railH+8))
    local contentTop = 126
    local bottomSpace = hasSections and (railH+16)or 8
    tabContent.Position = UDim2.fromOffset(8, contentTop)
    tabContent.Size = UDim2.new(1, -16, 1, -(contentTop + bottomSpace))
    allPage.Visible, allPage.ScrollingEnabled = not sectioned, not sectioned
    local rows, counts, seen = {}, {}, {}
    local function collect(page)
        for _, row in ipairs(page:GetChildren()) do
            if row:IsA("GuiObject") and not row:GetAttribute("BlessTopOption") and not row:GetAttribute("BlessLayoutDecoration") then
                rememberRow(row,page,row:GetAttribute("BlessSourceOrder"))
            end
        end
    end
    for _, name in ipairs(tabs) do
        local page=contentPages[name]
        if page then
            collect(page)
            page.Visible=sectioned and name==uiPreferences.tab
            page.ScrollingEnabled=sectioned
        end
    end
    collect(allPage)
    for row, origin in pairs(rowOrigins) do
        if row.Parent and contentPages[origin.page] and not seen[row] then
            seen[row]=true
            rows[#rows+1]=row
        end
    end
    for _, row in ipairs(rows) do
        local origin = rowOrigins[row]
        if origin and contentPages[origin.page] then
            row.Parent = sectioned and contentPages[origin.page] or allPage
            row.LayoutOrder = sectioned and origin.order or (pageRanks[origin.page] * 10000 + origin.order)
            if not row:GetAttribute("BlessSearchSection")
                and (searchVisibility[row] == true or (searchVisibility[row] == nil and row.Visible)) then
                counts[origin.page] = (counts[origin.page] or 0) + 1
            end
        end
    end
    for index, name in ipairs(tabs) do
        local button = tabButtons[index]
        if button then
            button.Visible = mode == "Tabs"
            button.Size = UDim2.new(1 / #tabs, -6, 1, -10)
            button.Position = UDim2.new((index - 1) / #tabs, 3, 0, 5)
            button.Text = string.upper(tabDisplayNames[name])
            styleTab(button, name == uiPreferences.tab)
        end
    end
    flatGroups.Refresh(not sectioned, counts)
    for _, heading in pairs(flatGroups.Headings) do
        searchVisibility[heading] = nil
        if not sectioned then rows[#rows + 1] = heading end
    end
    filterOptions(rows)
    local topPage = sectioned and contentPages[uiPreferences.tab] or allPage
    for _, row in ipairs(topOptionRows) do row.Parent = topPage; row.Visible = true end
    if sectionNav then sectionNav.Refresh(mode, uiPreferences.tab, searchQuery ~= "") end
    if uiVisual.refreshSectionsMode then uiVisual.refreshSectionsMode() end
    uiVisual.refreshTheme(tabContent)
    layoutChanging = false
    task.spawn(function()
        RunService.Heartbeat:Wait()
        if serial ~= layoutSerial or not main.Parent then return end
        local active = sectioned and contentPages[uiPreferences.tab] or allPage
        local key = sectioned and uiPreferences.tab or "All"
        active.CanvasPosition = Vector2.new(0, (searchQuery ~= "" and 0 or uiPreferences.scroll[key]) or 0)
    end)
end

local function selectSection(name)
    if uiPreferences.sectionsMode == "Off" or not contentPages[name] then return end
    local changed = uiPreferences.tab ~= name or searchQuery ~= ""
    if sectionNav then sectionNav.Close() end
    uiPreferences.tab = name
    searchQuery = ""
    if searchBox.Text ~= "" then searchBox.Text = "" end
    searchBox:ReleaseFocus()
    applyTabLayout()
    if changed and _G.M4ToggleSFXPlay then task.defer(_G.M4ToggleSFXPlay) end
    task.defer(saveAllSettings)
end
local function scrollingPage(page)
    return uiPreferences.sectionsMode ~= "Off" and searchQuery == "" and page or allPage
end
for index, name in ipairs(tabs) do
    pageRanks[name] = index
    local page = makePage(name)
    local button = Instance.new("TextButton", rail)
    button.Name = name .. "Tab"
    button.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    button.BackgroundTransparency = 0
    button.BorderSizePixel = 0
    button.Text = string.upper(tabDisplayNames[name])
    button.TextColor3 = WHITE
    button.Font = Enum.Font.GothamBold
    button.TextSize = 9
    button.AutoButtonColor = false
    button.ZIndex = 54
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", button)
    stroke:SetAttribute("FearThemeRole", "TabStroke")
    stroke.Thickness = 1
    stroke.Transparency = 0
    tabButtons[index] = button
    button.Activated:Connect(function()
        if uiPreferences.sectionsMode ~= "Tabs" then return end
        selectSection(name)
    end)
    page.ChildAdded:Connect(function(child)
        if not child:IsA("GuiObject") or child:GetAttribute("BlessTopOption") or child:GetAttribute("BlessLayoutDecoration") then return end
        if rowOrigins[child] or reconcileQueued then return end
        reconcileQueued=true
        task.defer(function()
            reconcileQueued=false
            if main.Parent then
                rememberRow(child,page,child.LayoutOrder)
                if uiVisual.organizeOptions then uiVisual.organizeOptions()end
                applyTabLayout()
            end
        end)
    end)
end
sectionNav = uiVisual.createSectionNavigation(main, rail, tabs, tabDisplayNames, uiPreferences, selectSection)
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    searchQuery = string.lower(searchBox.Text):match("^%s*(.-)%s*$") or ""
    applyTabLayout()
end)
applyTabLayout()

local pageCounters={}local function getNextOrder(page)if not pageCounters[page]then pageCounters[page]=0 end pageCounters[page]=pageCounters[page]+1 return pageCounters[page]end local function mkSect(page,txt)
local section=Instance.new("Frame",page)
section.Name="Section_"..txt
section:SetAttribute("BlessSearchTitle",txt)
section:SetAttribute("BlessSearchSection",true)
section.Size=UDim2.new(1,-4,0,25)
section.BackgroundTransparency=1
section.BorderSizePixel=0
section.LayoutOrder=getNextOrder(page)
rememberRow(section,page,section.LayoutOrder)
section.ZIndex=7
local label=Instance.new("TextLabel",section)
label.Size=UDim2.new(1,-18,0,19)
label.Position=UDim2.fromOffset(14,1)
label.BackgroundTransparency=1
label.Text=txt:upper()
label:SetAttribute("FearThemeRole","SectionTitle")
label.TextColor3=Color3.fromRGB(135,135,135)
label.Font=Enum.Font.GothamBold
label.TextSize=10
label.TextXAlignment=Enum.TextXAlignment.Left
label.TextTruncate=Enum.TextTruncate.AtEnd
label.TextStrokeTransparency=1
label.ZIndex=8
local line=Instance.new("Frame",section)
line.Name="SectionAccent"
line.Size=UDim2.new(1,-8,0,1)
line.Position=UDim2.new(0,4,1,-2)
line.BackgroundColor3=uiVisual.getThemeAccent()
line.BackgroundTransparency=0.64
line.BorderSizePixel=0
line:SetAttribute("FearThemeRole","SectionLine")
line.ZIndex=8
return section
end
 local function mkRow(page,height)
    local row=new("Frame",{Size=UDim2.new(1,-4,0,math.max(height or 34,34)),BackgroundColor3=UI_CONFIG.Surface,BackgroundTransparency=UI_CONFIG.OptionTransparency,BorderSizePixel=0,LayoutOrder=getNextOrder(page),ZIndex=7},page)
    for _,sourcePage in pairs(contentPages)do
        if page==sourcePage then rememberRow(row,page,row.LayoutOrder);break end
    end
    row:SetAttribute("FearThemeRole","BlessOptionRow")
    corner(row,8)
    local edge=stroke(row,UI_CONFIG.Surface2,1,.4);edge:SetAttribute("FearThemeRole","RowStroke")
    return row
end
 local function mkLabel(row,text)
    row:SetAttribute("BlessSearchTitle",text)
    return new("TextLabel",{Size=UDim2.new(1,-144,1,0),Position=UDim2.fromOffset(12,0),BackgroundTransparency=1,Text=text,TextColor3=UI_CONFIG.Text,Font=UI_CONFIG.Font,TextSize=13,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8},row)
end
 local function mkPill(row,offset)
    row:SetAttribute("BlessSwitchRow",true)
    local track=new("Frame",{
        Name="Track",Size=UDim2.fromOffset(40,20),AnchorPoint=Vector2.new(.5,.5),
        Position=UDim2.new(1,-(offset or 35),.5,0),ZIndex=10,
    },row)
    local knob=uiVisual.addSwitchParts(track)
    return track,knob
end

local function animPill(pill,dot,on)
    on=on==true
    pill:SetAttribute("FearToggleOn",on)
    local row=pill.Parent
    if row then
        row:SetAttribute("FearToggleOn",on)
        local rowStroke=row:FindFirstChildOfClass("UIStroke")
        if rowStroke then
            rowStroke.Color=on and UI_CONFIG.Accent or UI_CONFIG.Surface2
            rowStroke.Thickness=on and 1.25 or 1
            rowStroke.Transparency=on and .08 or .48
        end
    end
    local stroke=pill:FindFirstChild("PillStroke")
    if stroke then stroke:SetAttribute("FearToggleOn",on) end
    uiVisual.paintBlessSwitch(pill,true)
    if row then uiVisual.refreshTheme(row) end
end
 local function mkToggle(page,text,callback)
    local row=new("TextButton",{
        Name="Toggle_"..text,Size=UDim2.new(1,-4,0,34),BackgroundColor3=UI_CONFIG.Surface,
        BackgroundTransparency=UI_CONFIG.OptionTransparency,BorderSizePixel=0,Text="",AutoButtonColor=false,
        LayoutOrder=getNextOrder(page),ZIndex=7,
    },page)
    rememberRow(row,page,row.LayoutOrder)
    row:SetAttribute("FearThemeRole","BlessOptionRow")
    row:SetAttribute("BlessSearchTitle",text)
    corner(row,8)
    local edge=stroke(row,UI_CONFIG.Surface2,1,.4)
    edge:SetAttribute("FearThemeRole","RowStroke")
    local label=mkLabel(row,text)
    label.Size=UDim2.new(1,-76,1,0)
    label:SetAttribute("FearThemeRole","ToggleLabel")
    local pill,dot=mkPill(row,35)
    local on=false
    local function setVisual(value)
        on=value==true
        row:SetAttribute("FearToggleOn",on)
        animPill(pill,dot,on)
    end
    row.Activated:Connect(function()
        setVisual(not on)
        local ok,err=pcall(callback,on)
        if not ok then warn("[Candy Hub] "..text..": "..tostring(err))end
    end)
    setVisual(false)
    return setVisual
end
 local function mkSelector(parent,default,options,callback)
local stacked=parent.Size.Y.Offset>=52
local container=Instance.new("Frame",parent)
container.Size=stacked and UDim2.new(1,-20,0,28)or UDim2.new(0,128,1,0)
container.Position=stacked and UDim2.new(0,10,1,-32)or UDim2.new(1,-136,0,0)
container.BackgroundTransparency=1
container.ZIndex=8
local button=Instance.new("TextButton",container)
button.Name="SelectorValue"
button:SetAttribute("FearThemeRole","SelectorButton")
button.Size=UDim2.new(1,-52,0,24)
button.Position=UDim2.new(0,26,0.5,-12)
button.BackgroundColor3=INP
button.BackgroundTransparency=0.08
button.BorderSizePixel=0
button.Text=default
button.TextColor3=WHITE
button.Font=Enum.Font.GothamMedium
button.TextSize=10
button.TextTruncate=Enum.TextTruncate.AtEnd
button.AutoButtonColor=false
button.ZIndex=9
Instance.new("UICorner",button).CornerRadius=UDim.new(0,6)
local stroke=Instance.new("UIStroke",button)
stroke.Color=uiVisual.getThemeAccent()
stroke.Transparency=0.4
stroke.Thickness=1
stroke:SetAttribute("FearThemeRole","SelectorStroke")
local function choose(direction)
if not callback then return end
local index=table.find(options,button.Text)or 1
local nextIndex=(index-1+direction)%#options+1
callback(button,direction,options[nextIndex])
if _G.M4ToggleSFXPlay then task.defer(_G.M4ToggleSFXPlay)end
end
for _,direction in ipairs({-1,1})do
local arrow=Instance.new("TextButton",container)
arrow.Name=direction<0 and"Previous"or"Next"
arrow.Size=UDim2.new(0,26,1,0)
arrow.Position=direction<0 and UDim2.fromOffset(0,0)or UDim2.new(1,-26,0,0)
arrow.BackgroundTransparency=1
arrow.Text=direction<0 and"<"or">"
arrow.TextColor3=WHITE
arrow.Font=Enum.Font.GothamMedium
arrow.TextSize=14
arrow.AutoButtonColor=false
arrow.ZIndex=10
local plate=Instance.new("Frame",arrow)
plate.Name="BlessArrowPlate"
plate.Size=UDim2.new(1,-4,0,24)
plate.Position=UDim2.new(0,2,.5,-12)
plate.BackgroundColor3=Color3.fromRGB(12,12,12)
plate.BackgroundTransparency=.2
plate.BorderSizePixel=0
plate.Active=false
plate.ZIndex=9
Instance.new("UICorner",plate).CornerRadius=UDim.new(0,5)
local edge=Instance.new("UIStroke",plate)
edge.Color=Color3.fromRGB(70,70,70)
edge.Transparency=.45
edge.Thickness=1
arrow.Activated:Connect(function()choose(direction)end)
end
button.Activated:Connect(function()choose(1)end)
uiVisual.decorate(button)
return button
end
 local function mkBox(parent,default,w,xOff,cb)local tb=Instance.new("TextBox",parent)local bw=w or 50 local xo=math.max(xOff or 56,bw+12)tb.Size=UDim2.new(0,bw,0,22)tb.Position=UDim2.new(1,-xo,0.5,-11)tb.BackgroundColor3=INP tb.BackgroundTransparency=0.08 tb:SetAttribute("FearThemeRole","BlessInput") tb.BorderSizePixel=0 tb.Text=tostring(default)tb.TextColor3=WHITE tb.Font=Enum.Font.GothamMedium tb.TextSize=12 tb.ClearTextOnFocus=false tb.TextXAlignment=Enum.TextXAlignment.Center tb.ZIndex=8 Instance.new("UICorner",tb).CornerRadius=UDim.new(0,6)local bs=Instance.new("UIStroke",tb)bs:SetAttribute("FearThemeRole","InputStroke")bs:SetAttribute("FearFocused",false)bs.Color=ROW_BORDER bs.Thickness=1.2 bs.Transparency=0.55 uiVisual.decorate(tb) tb.Focused:Connect(function()bs:SetAttribute("FearFocused",true)uiVisual.refreshTheme(tb)end)local committedValue=tonumber(default)tb.FocusLost:Connect(function()bs:SetAttribute("FearFocused",false)uiVisual.refreshTheme(tb)if cb then local n=tonumber(tb.Text)if n then local changedValue=committedValue==nil or math.abs(n-committedValue)>0.00001 cb(n)committedValue=tonumber(tb.Text)or n if changedValue and _G.M4ToggleSFXPlay then task.defer(_G.M4ToggleSFXPlay)end else tb.Text=tostring(committedValue or default)end end end)return tb end
 local function mkKeyButton(parent,kbEntry,onChanged)local btn=Instance.new("TextButton",parent)btn.Size=UDim2.new(0,80,0,22)btn.Position=UDim2.new(1,-118,0.5,-11)btn.BackgroundColor3=INP btn:SetAttribute("FearThemeRole","InputButton")btn:SetAttribute("FearListening",false)btn.BackgroundTransparency=0.5 btn.BorderSizePixel=0 local function getLabel()return(kbEntry.gp and kbEntry.gp.Name)or(kbEntry.kb and kbEntry.kb.Name)or"None"end btn.Text=getLabel()btn.TextColor3=WHITE btn.Font=Enum.Font.GothamBlack btn.TextSize=9 btn.ZIndex=8 btn.AutoButtonColor=false Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)local bs=Instance.new("UIStroke",btn)bs:SetAttribute("FearThemeRole","InputButtonStroke")bs.Color=ROW_BORDER bs.Thickness=1 local li=false;local lc;local lc2;local pv=btn.Text;local listenStart=0 local clear=Instance.new("TextButton",parent)clear.Name="ClearBind"clear.Size=UDim2.fromOffset(26,26)clear.Position=UDim2.new(1,-34,0.5,-13)clear.BackgroundColor3=INP clear.BackgroundTransparency=0.5 clear.BorderSizePixel=0 clear.Text="X"clear.TextColor3=WHITE clear.Font=Enum.Font.GothamBold clear.TextSize=11 clear.AutoButtonColor=false clear.ZIndex=9 clear:SetAttribute("FearThemeRole","InputButton")clear:SetAttribute("FearListening",false)Instance.new("UICorner",clear).CornerRadius=UDim.new(0,6)local clearStroke=Instance.new("UIStroke",clear)clearStroke:SetAttribute("FearThemeRole","InputButtonStroke")clearStroke.Color=ROW_BORDER clearStroke.Thickness=1 clear.Activated:Connect(function()if li then li=false;_anyKeyListening=false;uiVisual.moreButtonsCapture=nil end if lc then lc:Disconnect();lc=nil end if lc2 then lc2:Disconnect();lc2=nil end kbEntry.kb=nil kbEntry.gp=nil pv="None"btn.Text=pv btn.TextColor3=WHITE btn:SetAttribute("FearListening",false)uiVisual.refreshTheme(parent)if onChanged then pcall(onChanged,kbEntry,nil)end if _G.M4ToggleSFXPlay then task.defer(_G.M4ToggleSFXPlay)end task.defer(saveAllSettings)end)btn.Activated:Connect(function()if li then li=false;btn:SetAttribute("FearListening",false);_anyKeyListening=false;uiVisual.moreButtonsCapture=nil;if lc then lc:Disconnect();lc=nil end;if lc2 then lc2:Disconnect();lc2=nil end;btn.Text=pv;btn.TextColor3=WHITE;uiVisual.refreshTheme(btn);return end pv=btn.Text;li=true;btn:SetAttribute("FearListening",true);_anyKeyListening=true;listenStart=tick();btn.Text="...";btn.TextColor3=WHITE;uiVisual.refreshTheme(btn)local function capture(inp,forwarded)if not li then return end if not forwarded and uiVisual.moreButtons and isGamepadInput(inp)and uiVisual.isMoreButton(inp.KeyCode)then uiVisual.handleMoreButton(inp)return end if inp.KeyCode==Enum.KeyCode.Escape then li=false;btn:SetAttribute("FearListening",false);_anyKeyListening=false;uiVisual.moreButtonsCapture=nil;if lc then lc:Disconnect();lc=nil end;if lc2 then lc2:Disconnect();lc2=nil end;btn.Text=pv;btn.TextColor3=WHITE;uiVisual.refreshTheme(btn);return end local isGp=isGamepadInput(inp)if isGp and tick()-listenStart<0.15 then return end if not isBindableInput(inp)then return end btn.Text=inp.KeyCode.Name;pv=inp.KeyCode.Name;btn.TextColor3=WHITE li=false;btn:SetAttribute("FearListening",false);_anyKeyListening=false;uiVisual.moreButtonsCapture=nil;if lc then lc:Disconnect();lc=nil end;if lc2 then lc2:Disconnect();lc2=nil end uiVisual.refreshTheme(btn)if isGp then kbEntry.gp=inp.KeyCode;kbEntry.kb=nil else kbEntry.kb=inp.KeyCode;kbEntry.gp=nil end if onChanged then pcall(onChanged,kbEntry,isGp)end if _G.M4ToggleSFXPlay then task.defer(_G.M4ToggleSFXPlay)end task.defer(saveAllSettings)end uiVisual.moreButtonsCapture=function(inp)capture(inp,true)end lc=UIS.InputBegan:Connect(function(inp)capture(inp,false)end)lc2=UIS.InputChanged:Connect(function(inp)if not li or not isGamepadInput(inp)then return end if inp.KeyCode~=Enum.KeyCode.ButtonL2 and inp.KeyCode~=Enum.KeyCode.ButtonR2 then return end if inp.Position.Z<0.45 then return end btn.Text=inp.KeyCode.Name;pv=inp.KeyCode.Name;btn.TextColor3=WHITE li=false;btn:SetAttribute("FearListening",false);_anyKeyListening=false;uiVisual.moreButtonsCapture=nil;if lc then lc:Disconnect();lc=nil end;if lc2 then lc2:Disconnect();lc2=nil end uiVisual.refreshTheme(btn)kbEntry.gp=inp.KeyCode;kbEntry.kb=nil if onChanged then pcall(onChanged,kbEntry,true)end if _G.M4ToggleSFXPlay then task.defer(_G.M4ToggleSFXPlay)end task.defer(saveAllSettings)end)end)table.insert(keyButtonRefs,{btn=btn,entry=kbEntry})return btn end local function addKeybindRow(page,labelText,kbEntry,onChanged)local row=mkRow(page,34)local label=mkLabel(row,labelText)label.Size=UDim2.new(1,-144,1,0)mkKeyButton(row,kbEntry,onChanged)end local sliderRefreshers={}
local function makeScaleSlider(page,label,low,high,step,getValue,applyValue,labelKey,compact)local row=mkRow(page,compact and 50 or 66)local title=mkLabel(row,label)title.Size=UDim2.new(0.7,0,0,compact and 20 or 28)local value=Instance.new("TextLabel",row)value.Size=UDim2.new(0.25,-10,0,compact and 20 or 28)value.Position=UDim2.new(0.75,0,0,0)value.BackgroundTransparency=1 value.TextColor3=WHITE value.Font=Enum.Font.Code value:SetAttribute("FearThemeRole","BlessNumeric") value.TextSize=12 value.TextXAlignment=Enum.TextXAlignment.Right value.ZIndex=9 _G[labelKey]=value local hit=Instance.new("TextButton",row)hit.Name="ScaleSliderTrack"hit:SetAttribute("NoPressAnimation",true)hit.Size=UDim2.new(1,-86,0,30)hit.Position=UDim2.fromOffset(43,compact and 17 or 29)hit.BackgroundTransparency=1 hit.Text=""hit.AutoButtonColor=false hit.ZIndex=9 local track=Instance.new("Frame",hit)track:SetAttribute("FearThemeRole","BlessSliderTrack")track.Size=UDim2.new(1,0,0,5)track.Position=UDim2.new(0,0,0.5,-2)track.BackgroundColor3=Color3.fromRGB(50,50,50)track.BorderSizePixel=0 track.ZIndex=9 Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)local fill=Instance.new("Frame",track)fill:SetAttribute("FearThemeRole","BlessSliderFill")fill.BackgroundColor3=Color3.fromRGB(255,255,255)fill.BorderSizePixel=0 fill.ZIndex=10 Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)local knob=Instance.new("Frame",track)knob:SetAttribute("FearThemeRole","BlessSliderKnob")knob.AnchorPoint=Vector2.new(0.5,0.5)knob.Size=UDim2.fromOffset(13,13)knob.BackgroundColor3=WHITE knob.BorderSizePixel=0 knob.ZIndex=11 Instance.new("UICorner",knob).CornerRadius=UDim.new(0,4)local function refresh()local current=getValue()local ratio=math.clamp((current-low)/(high-low),0,1)value.Text=(labelKey=="wordDarknessValueLabel"or labelKey=="backgroundBrightnessValueLabel")and string.format("%d%%",math.floor(current+0.5))or string.format("%.2f",(labelKey=="uiScaleValueLabel"or labelKey=="stealBarScaleValueLabel")and current/100 or current)fill.Size=UDim2.new(ratio,0,1,0)knob.Position=UDim2.new(ratio,0,0.5,0)end local function setValue(nextValue)local rounded=low+math.floor((nextValue-low)/step+0.5)*step rounded=math.clamp(rounded,low,high)if math.abs(rounded-getValue())>0.00001 then applyValue(rounded)end refresh()end for _,direction in ipairs({-1,1})do local button=Instance.new("TextButton",row)button.Size=UDim2.fromOffset(26,26)button.Position=direction==-1 and UDim2.fromOffset(9,compact and 19 or 31)or UDim2.new(1,-35,0,compact and 19 or 31)button.BackgroundColor3=Color3.fromRGB(28,28,28)button.BorderSizePixel=0 button.Text=direction==-1 and"−"or"+"button.TextColor3=WHITE button.Font=Enum.Font.GothamBold button.TextSize=16 button.ZIndex=10 Instance.new("UICorner",button).CornerRadius=UDim.new(0,7)button.Activated:Connect(function()local beforeValue=getValue()setValue(beforeValue+direction*step)if math.abs(getValue()-beforeValue)>0.00001 and _G.M4ToggleSFXPlay then task.defer(_G.M4ToggleSFXPlay)end saveAllSettings()end)end local dragInput=nil local wasScrolling=true local gestureStart=nil local gestureValueStart=nil local sliderDragging=false local scrollGesture=false local GESTURE_THRESHOLD=7 local function updatePointer(x)if hit.AbsoluteSize.X<=0 then return end local ratio=math.clamp((x-hit.AbsolutePosition.X)/hit.AbsoluteSize.X,0,1)setValue(low+ratio*(high-low))end hit.InputBegan:Connect(function(input)if dragInput then return end if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end dragInput=input gestureStart=input.Position gestureValueStart=getValue()wasScrolling=scrollingPage(row.Parent).ScrollingEnabled sliderDragging=input.UserInputType==Enum.UserInputType.MouseButton1 scrollGesture=false if sliderDragging then scrollingPage(row.Parent).ScrollingEnabled=false knob.Size=UDim2.fromOffset(17,17)updatePointer(input.Position.X)end end)local changed=UIS.InputChanged:Connect(function(input)if not dragInput or scrollGesture then return end local isTouch=dragInput.UserInputType==Enum.UserInputType.Touch and input==dragInput local isMouse=dragInput.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseMovement if not isTouch and not isMouse then return end if isTouch and not sliderDragging and gestureStart then local delta=input.Position-gestureStart if delta.Magnitude>=GESTURE_THRESHOLD then if math.abs(delta.Y)>math.abs(delta.X)then scrollGesture=true dragInput=nil gestureStart=nil scrollingPage(row.Parent).ScrollingEnabled=wasScrolling knob.Size=UDim2.fromOffset(13,13)return end sliderDragging=true scrollingPage(row.Parent).ScrollingEnabled=false knob.Size=UDim2.fromOffset(17,17)end end if sliderDragging then updatePointer(input.Position.X)end end)local ended=UIS.InputEnded:Connect(function(input)if not dragInput then return end if input==dragInput or(dragInput.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseButton1)then if not sliderDragging and gestureStart then updatePointer(input.Position.X)end local changedValue=gestureValueStart~=nil and math.abs(getValue()-gestureValueStart)>0.00001 dragInput=nil gestureStart=nil gestureValueStart=nil sliderDragging=false scrollGesture=false scrollingPage(row.Parent).ScrollingEnabled=wasScrolling knob.Size=UDim2.fromOffset(13,13)if changedValue and _G.M4ToggleSFXPlay then task.defer(_G.M4ToggleSFXPlay)end saveAllSettings()end end)row.Destroying:Connect(function()changed:Disconnect();ended:Disconnect()end)refresh()table.insert(sliderRefreshers,refresh)return row end
do
 local page=contentPages.Visuals
 mkSect(page,"Candy colors")
 local selector=mkRow(page,111)
 selector.Name="ColorSelector"
 selector:SetAttribute("BlessSearchTitle","Color Blue Pink Candy Azul Rosa")
 local caption=new("TextLabel",{Size=UDim2.new(1,-24,0,24),Position=UDim2.fromOffset(12,0),
  BackgroundTransparency=1,Text="Choose your flavor",TextColor3=UI_CONFIG.Text,Font=UI_CONFIG.Font,
  TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8},selector)
 local cards={}
 for index,palette in ipairs(uiVisual.colorThemes)do
  local card=new("TextButton",{Name=palette.name.."CandyTheme",Size=UDim2.new(1/3,-10,0,75),
   Position=UDim2.new((index-1)/3,7,0,28),Text="",AutoButtonColor=false,
   BorderSizePixel=0,ZIndex=9},selector)
  card:SetAttribute("FearThemeRole","CandyThemeCard")
  local image=new("ImageLabel",{Name="FlavorImage",Size=UDim2.new(1,-6,0,43),Position=UDim2.fromOffset(3,3),
   BackgroundTransparency=1,Image=palette.background,ScaleType=Enum.ScaleType.Crop,ZIndex=10},card)
  image:SetAttribute("CandyDecoration",true)
  corner(image,9)
  if uiVisual.loadPreviewAsset then uiVisual.loadPreviewAsset(image,palette.background)end
  local name=new("TextLabel",{Name="FlavorName",Size=UDim2.new(1,-4,0,23),Position=UDim2.fromOffset(2,48),
   BackgroundTransparency=1,Text=palette.name,Font=Enum.Font.GothamBold,TextSize=11,ZIndex=11},card)
  name:SetAttribute("CandyDecoration",true)
  local check=new("TextLabel",{Name="Chosen",Size=UDim2.fromOffset(16,16),Position=UDim2.new(1,-20,0,5),
   BackgroundColor3=palette.primary:Lerp(palette.deep,.2),BackgroundTransparency=.05,Text="✓",TextColor3=Color3.new(1,1,1),
   Font=Enum.Font.GothamBold,TextSize=11,BorderSizePixel=0,ZIndex=12},card)
  check:SetAttribute("CandyDecoration",true)
  corner(check,8)
  card.Activated:Connect(function()
   if uiVisual.backgroundColorIndex~=index then uiVisual.applyColorTheme(index)end
  end)
  cards[index]={button=card,name=name,check=check}
 end
 uiVisual.refreshColorSelector=function()
  for index,entry in ipairs(cards)do
   local selected=uiVisual.backgroundColorIndex==index
   entry.button:SetAttribute("FearSelected",selected)
   entry.check.Visible=selected
   entry.name.TextColor3=selected and Color3.new(1,1,1)or uiVisual.getThemePalette().text
   uiVisual.candySkin(entry.button)
  end
 end
 uiVisual.refreshColorSelector()
    local brightness=makeScaleSlider(page,"Background Brightness",25,100,1,
        function()return 100-math.clamp(tonumber(uiVisual.backgroundDarkness)or 38,0,75)end,
        function(value)
            uiVisual.backgroundDarkness=100-value
            if uiVisual.applyBackgroundDarkness then uiVisual.applyBackgroundDarkness()end
        end,"backgroundBrightnessValueLabel",true)
    brightness.Name="BackgroundDarknessSelector"
    uiVisual.refreshBackgroundDarkness=function()
        if uiVisual.applyBackgroundDarkness then uiVisual.applyBackgroundDarkness()end
        if uiVisual.refreshSliders then uiVisual.refreshSliders()end
    end
    local wordBrightness=makeScaleSlider(page,"Logo Brightness",0,100,1,
        function()return 100-math.clamp(tonumber(uiVisual.wordDarkness)or 0,0,100)end,
        function(value)uiVisual.setWordDarkness(100-value)end,"wordDarknessValueLabel",true)
    wordBrightness.Name="WordDarknessSelector"
end
local momentPage=contentPages["Moment"]mkSect(momentPage,"Speed Settings")do
    local entries={}
    local disposed=false
    local function makeMode(text,normal,carry,setNormal,setCarry,getNormal,getCarry)
        local row=mkRow(momentPage,36)
        row.Name="NormalSpeedRow"
        row:SetAttribute("FearThemeRole","SpeedModeRow")
        uiVisual.candySurface(row,false)
        local edge=row:FindFirstChildOfClass("UIStroke")
        edge.Name="SpeedEdge"
        edge:SetAttribute("FearThemeRole","SpeedModeEdge")
        edge.Color=Color3.fromRGB(112,112,112)
        edge.Thickness=1
        edge.Transparency=.55
        local glow=stroke(row,Color3.new(1,1,1),4,.9)
        glow.Name="SpeedGlow"
        glow.Enabled=false
        local nameButton=new("TextButton",{
            Name="ChooseSpeed",Position=UDim2.fromOffset(12,0),Size=UDim2.new(1,-150,1,0),
            BackgroundTransparency=1,Text=text,Font=UI_CONFIG.Font,TextSize=13,
            TextColor3=UI_CONFIG.Text,TextXAlignment=Enum.TextXAlignment.Left,
            AutoButtonColor=false,ZIndex=9,
        },row)
        nameButton:SetAttribute("FearThemeRole","SpeedModeName")
        local function input(default,x,getValue,setValue)
            local box
            box=mkBox(row,default,44,56,function(value)
                if value>0 and value<=500 then
                    setValue(value)
                    uiVisual.syncMovementSpeeds()
                    saveAllSettings()
                end
                box.Text=tostring(getValue())
            end)
            box.Position=UDim2.new(1,x,.5,-13)
            box.Size=UDim2.fromOffset(44,26)
            box.BackgroundColor3=Color3.new(0,0,0)
            box.BackgroundTransparency=1
            box.Font=UI_CONFIG.Font
            box.TextSize=13
            box.TextColor3=Color3.new(1,1,1)
            local outline=box:FindFirstChildOfClass("UIStroke")
            if outline then outline.Transparency=1 end
            return box
        end
        local first=input(normal,-122,getNormal,setNormal)
        new("TextLabel",{
            Position=UDim2.new(1,-76,.5,-13),Size=UDim2.fromOffset(14,26),
            BackgroundTransparency=1,Text="|",Font=UI_CONFIG.Font,TextSize=13,
            TextColor3=Color3.fromRGB(175,175,175),ZIndex=8,
        },row)
        local second=input(carry,-58,getCarry,setCarry)
        local entry={row=row,button=nameButton,edge=edge,glow=glow}
        entries[#entries+1]=entry
        row.Destroying:Connect(function()entry.disposed=true end)
        return first,second
    end
    normalBox,carryBox=makeMode("Normal speed",NS,CS,
        function(v)NS=v end,function(v)CS=v end,function()return NS end,function()return CS end)
    uiVisual.refreshSpeedTheme=function()
        if disposed then return end
        for _,entry in ipairs(entries)do
            if not entry.disposed then
                local active=true
                entry.row:SetAttribute("BlessSpeedActive",active)
                entry.row:SetAttribute("FearSelected",active)
                uiVisual.candyRefresh(entry.row)
                entry.glow.Enabled=false
            end
        end
    end
    normalSpeedSetVisual=uiVisual.refreshSpeedTheme
    main:GetPropertyChangedSignal("Visible"):Connect(uiVisual.refreshSpeedTheme)
    main.Destroying:Connect(function()
        disposed=true
    end)
    uiVisual.refreshSpeedTheme()
end
  mkSect(momentPage,"Lagger Speeds")do local row=mkRow(momentPage,34)mkLabel(row,"Lagger Normal Speed")laggerBox=mkBox(row,LAGGER_SPEED_1,56,56,function(v)if v>0 and v<=500 then LAGGER_SPEED_1=v end saveAllSettings()end)end do local row=mkRow(momentPage,34)mkLabel(row,"Lagger Carry Speed")lagger2Box=mkBox(row,LAGGER_SPEED_2,56,56,function(v)if v>0 and v<=500 then LAGGER_SPEED_2=v end saveAllSettings()end)end do local row=mkRow(momentPage,34)mkLabel(row,"Current Speed")modeValLbl=Instance.new("TextLabel",row)modeValLbl.Size=UDim2.new(0,120,1,0)modeValLbl.Position=UDim2.new(1,-128,0,0)modeValLbl.BackgroundTransparency=1 modeValLbl.Text="Normal"modeValLbl.TextColor3=GRAY modeValLbl:SetAttribute("FearThemeRole","AccentText")modeValLbl.Font=Enum.Font.GothamBlack modeValLbl.TextSize=10 modeValLbl.TextXAlignment=Enum.TextXAlignment.Right modeValLbl.ZIndex=8 end refreshSpeedModeLabel()mkSect(momentPage,"Auto Carry")
_G.__BlessAutoSpin.setVisual=mkToggle(momentPage,"Auto Spin",function(on)
    _G.__BlessAutoSpin.SetEnabled(on)
    saveAllSettings()
end)
_G.__BlessAutoSpin.setVisual(_G.BlessAutoSpinEnabled==true)
_G.M4AutoSpeedSetVisual=mkToggle(momentPage,"Auto Speed",function(on)_G.M4AutoSpeedEnabled=on==true if _G.M4AutoSpeedEnabled then if _G.M4AutoSpeedStart then pcall(_G.M4AutoSpeedStart)end else if _G.M4AutoSpeedStop then pcall(_G.M4AutoSpeedStop)end end saveAllSettings()end)do local row=mkRow(momentPage,62)local label=mkLabel(row,"Auto Speed Mode")label.Size=UDim2.new(1,-20,0,24)label.Position=UDim2.new(0,10,0,2)_G.M4AutoSpeedModeBtn=mkSelector(row,_G.M4AutoSpeedMode,{"On Pick Up","Soft Steal"},function(btn)_G.M4AutoSpeedMode=_G.M4AutoSpeedMode=="Soft Steal"and"On Pick Up"or"Soft Steal"btn.Text=_G.M4AutoSpeedMode if _G.M4AutoSpeedEnabled and _G.M4AutoSpeedStart then pcall(_G.M4AutoSpeedStart)end saveAllSettings()end)end do local row=mkRow(momentPage,34)mkLabel(row,"Soft Steal Range")_G.M4AutoSpeedRangeBox=mkBox(row,_G.M4AutoSpeedRange,56,56,function(v)if v and v>=1 and v<=100 then _G.M4AutoSpeedRange=v if _G.M4AutoSpeedRangeBox then _G.M4AutoSpeedRangeBox.Text=tostring(_G.M4AutoSpeedRange)end saveAllSettings()end end)end mkSect(momentPage,"Auto Movement")do local row=mkRow(momentPage,30)mkLabel(row,"Infinite Jump")local jumpPill,jumpDot=mkPill(row,35)local jumpOn=false setJumpToggleState=function(state)if jumpOn==state then return end jumpOn=state animPill(jumpPill,jumpDot,state)if state then startJumpMode()else stopJumpMode()end saveAllSettings()end local jumpClk=Instance.new("TextButton",jumpPill)jumpClk.Size=UDim2.new(1,0,1,0)jumpClk.BackgroundTransparency=1 jumpClk.Text=""jumpClk.AutoButtonColor=false jumpClk.ZIndex=jumpPill.ZIndex+3 jumpClk.Activated:Connect(function()if editModeEnabled and not uiLocked then if jumpOn then stopJumpMode()else startJumpMode()end else local nextState=not jumpOn setJumpToggleState(nextState)if _G.M4ToggleSFXPlay then task.defer(_G.M4ToggleSFXPlay)end end end)setJumpVisual=function(state)setJumpToggleState(state)end end autoLeftSetVisual=mkToggle(momentPage,"Auto Left",function(on)autoLeftEnabled=on if on then startAutoLeft()else stopAutoLeft()end if mobSetAutoLeft then mobSetAutoLeft(on)end saveAllSettings()end)autoRightSetVisual=mkToggle(momentPage,"Auto Right",function(on)autoRightEnabled=on if on then startAutoRight()else stopAutoRight()end if mobSetAutoRight then mobSetAutoRight(on)end saveAllSettings()end)mkSect(momentPage,"TP & Reset")dropBrainrotSetVisual=mkToggle(momentPage,"Drop Brainrot",function(on)if on then executeDropWithToggle(function(v)dropBrainrotSetVisual(v)if mobSetDropBR then mobSetDropBR(v)end end)end end)do
    local row=mkRow(momentPage,36)
    mkLabel(row,"Drop Mode")
    dropModeBtnRef=Instance.new("TextLabel",row)
    dropModeBtnRef.Size=UDim2.new(0,80,1,0)
    dropModeBtnRef.Position=UDim2.new(1,-88,0,0)
    dropModeBtnRef.BackgroundTransparency=1
    dropModeBtnRef.Text="Bubble"
    dropModeBtnRef.TextColor3=WHITE
    dropModeBtnRef.Font=Enum.Font.GothamBold
    dropModeBtnRef.TextSize=12
end
do local row=mkRow(momentPage,30)mkLabel(row,"TP Down")local clk=Instance.new("TextButton",row)clk.Size=UDim2.new(0.58,0,1,0)clk.BackgroundTransparency=1 clk.Text=""clk.AutoButtonColor=false clk.ZIndex=8 clk.Activated:Connect(function()runTPDown()end)local actLbl=Instance.new("TextLabel",row)actLbl.Size=UDim2.new(0,70,1,0)actLbl.Position=UDim2.new(1,-78,0,0)actLbl.BackgroundTransparency=1 actLbl.Text="ACTIVATE"actLbl.TextColor3=WHITE actLbl.Font=Enum.Font.GothamBlack actLbl.TextSize=9 actLbl.TextXAlignment=Enum.TextXAlignment.Right actLbl.ZIndex=8 end setAutoTPDownVisual=mkToggle(momentPage,"Auto TP Down",function(on)if on then startAutoTPDown()else stopAutoTPDown()end saveAllSettings()end)do local row=mkRow(momentPage,30)mkLabel(row,"Height Y")autoTPHeightBox=mkBox(row,autoTPDownHeight,50,56,function(v)if v and v>=1 and v<=500 then autoTPDownHeight=v end saveAllSettings()end)end setInstaResetVisual=mkToggle(momentPage,"Insta Reset",function(on)if on then instaReset()if instaResetFloatingButton and instaResetFloatingButton:FindFirstChild("Frame")then local btnFrame=instaResetFloatingButton:FindFirstChild("Frame")local label=btnFrame and btnFrame:FindFirstChild("TextLabel")if btnFrame then btnFrame.BackgroundColor3=Color3.fromRGB(8,8,8) uiVisual.refreshTheme(btnFrame)if label then label.TextColor3=Color3.fromRGB(255,255,255)end task.delay(0.2,function()if btnFrame then btnFrame.BackgroundColor3=Color3.fromRGB(8,8,8) uiVisual.refreshTheme(btnFrame)if label then label.TextColor3=Color3.fromRGB(255,255,255)end end end)end end task.delay(0.3,function()if setInstaResetVisual then setInstaResetVisual(false)end end)end end)if setInstaResetVisual then setInstaResetVisual(false)end local combatPage=contentPages["Combat"]mkSect(combatPage,"Bat & Aimbot")autoBatSetVisual=mkToggle(combatPage,"Bat Aimbot",function(on)if on then enableAutoBat()else disableAutoBat()end if mobSetAutoBat then mobSetAutoBat(on)end saveAllSettings()end)do local row=mkRow(combatPage,42)mkLabel(row,"Bat Aimbot Speed")_G.FearGoodAimbotSpeedBox=mkBox(row,BAT_AIMBOT_SPEED,58,64,function(v)if v then BAT_AIMBOT_SPEED=math.clamp(v,1,500)if _G.FearGoodAimbotSpeedBox then _G.FearGoodAimbotSpeedBox.Text=tostring(BAT_AIMBOT_SPEED)end saveAllSettings()end end)end 
batV2SetVisual = mkToggle(combatPage, "Bat Bypass", function(on)
    if on then startBatV2() else stopBatV2() end
    saveAllSettings()
end)
batV2SetVisual(batV2Enabled)

do
    local row = mkRow(combatPage, 34)
    local label = mkLabel(row, "Bypass Version")
    label.Size = UDim2.new(1, -154, 1, 0)
    uiVisual.batV2EngineButton = mkSelector(row,
        batV2Engine == "Bless" and "Version 2" or "Version 1",
        {"Version 1", "Version 2"}, function(button, direction, version)
            uiVisual.setBatV2Engine(version == "Version 2" and "Bless" or "Rival")
            saveAllSettings()
        end)
    uiVisual.refreshBatV2Engine()
end

do
    local row=mkRow(combatPage,42)
    mkLabel(row,"Bat Bypass Speed")
    batV2SpeedBox=mkBox(row,BAT_V2_SPEED,58,64,function(value)
        BAT_V2_SPEED=math.clamp(value,1,120)
        batV2SpeedBox.Text=tostring(BAT_V2_SPEED)
        uiVisual.syncBatV2Speed()
        saveAllSettings()
    end)
end

bypassSetVisual=mkToggle(combatPage,"TP Bat",function(on)toggleBypass(on)if bypassFloatingButton then local btnFrame=bypassFloatingButton:FindFirstChild("Frame")if btnFrame then local label=btnFrame:FindFirstChild("TextLabel")btnFrame.BackgroundColor3=Color3.fromRGB(8,8,8) uiVisual.refreshTheme(btnFrame)if label then label.TextColor3=Color3.fromRGB(255,255,255)end end end saveAllSettings()end)if bypassSetVisual then bypassSetVisual(bypassToggled)end _G.FearMirrorTPDownVisual=mkToggle(combatPage,"Mirror TP Down",function(on)_G.FearMirrorTPDownEnabled=on==true saveAllSettings()end)if _G.FearMirrorTPDownVisual then _G.FearMirrorTPDownVisual(_G.FearMirrorTPDownEnabled==true)end mkSect(combatPage,"Counters")setBatCounterVisual=mkToggle(combatPage,"Bat Counter",function(on)setBatCounterState(on)saveAllSettings()end)
do
    local row = mkRow(combatPage, 36)
    mkLabel(row, "Counter Mode")
    uiVisual.batCounterModeButton = mkSelector(row, uiVisual.batCounterMode, {"V1", "V2"},
        function(button, direction, mode)
            uiVisual.setBatCounterMode(mode)
            saveAllSettings()
        end)
end
setMedusaVisual=mkToggle(combatPage,"Medusa Counter",function(on)setMedusaCounterState(on);saveAllSettings()end)mkSect(combatPage,"Defense")setAntiRagVisual=mkToggle(combatPage,"Anti Ragdoll",function(on)setAntiRag(on)saveAllSettings()end)

setRagdollCountdownVisual=mkToggle(combatPage,"Ragdoll Countdown",function(on)setRagdollCountdown(on)saveAllSettings()end)setAntiDieVisual=mkToggle(combatPage,"Anti Die",function(on)if _G.__BlessFloat then _G.__BlessFloat.antiDieOwned=false end if _G.__BlessAutoSpin then _G.__BlessAutoSpin.antiDieOwned=false end if on then startAntiDie()else stopAntiDie()end saveAllSettings()end)if setAntiDieVisual then setAntiDieVisual(antiDieEnabled)end bodyLockSetVisual=mkToggle(combatPage,"Body Lock",function(on)bodyLockEnabled=on if on then if _blSuppressCount==0 then startBodyLock()end else stopBodyLock()end saveAllSettings()end)do local row=mkRow(combatPage,30)mkLabel(row,"Body Lock Range")bodyLockRangeBox=mkBox(row,bodyLockRange,50,56,function(v)if v and v>0 then bodyLockRange=math.clamp(math.floor(v),5,200)if bodyLockRangeBox then bodyLockRangeBox.Text=tostring(bodyLockRange)end saveAllSettings()end end)end local mainPage=contentPages["Main"]local visualPage=contentPages["Visuals"]local settingsPage=contentPages["Settings"]_G.VeoraSettingsPage=settingsPage mkSect(mainPage,"Auto Steal")do
    local header=mkRow(mainPage,48)
    header.Name="AutoStealHeader"
    header:SetAttribute("FearThemeRole","AutoStealHeader")
    header:SetAttribute("BlessSearchTitle","Auto Steal")
    header.BackgroundColor3=Color3.fromRGB(9,9,12)
    header.BackgroundTransparency=0
    local title=mkLabel(header,"AUTO STEAL")
    title.Position=UDim2.fromOffset(12,14)
    title.Size=UDim2.new(1,-112,0,20)
    title.TextSize=13
    title:SetAttribute("FearThemeRole","AutoStealTitle")
    local power=new("TextButton",{
        Name="AutoStealPower",Position=UDim2.new(1,-50,.5,-10),Size=UDim2.fromOffset(38,20),
        BackgroundColor3=Color3.fromRGB(21,21,25),BackgroundTransparency=0,
        Text="",Font=UI_CONFIG.Font,TextSize=11,TextColor3=UI_CONFIG.Text,
        AutoButtonColor=false,BorderSizePixel=0,ZIndex=10,
    },header)
    uiVisual.addSwitchParts(power)
    local settingsButton=new("TextButton",{
        Name="AutoStealExpand",Position=UDim2.new(1,-94,.5,-14),Size=UDim2.fromOffset(30,28),
        BackgroundColor3=Color3.fromRGB(19,19,24),BackgroundTransparency=0,
        Text="",Font=UI_CONFIG.Font,TextSize=15,TextColor3=UI_CONFIG.Text,
        AutoButtonColor=false,BorderSizePixel=0,ZIndex=10,
    },header)
    corner(settingsButton,6)
    local settingsEdge=stroke(settingsButton,Color3.fromRGB(65,65,72),1,.25)
    local chevron=new("Frame",{
        Name="SettingsChevron",AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),
        Size=UDim2.fromOffset(14,10),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=11,
    },settingsButton)
    local chevronArms={}
    for index,offset in ipairs({-3,3})do
        local arm=new("Frame",{
            Name="ChevronArm"..index,AnchorPoint=Vector2.new(.5,.5),
            Position=UDim2.new(.5,offset,.5,0),Size=UDim2.fromOffset(8,2),
            BackgroundColor3=UI_CONFIG.Text,BackgroundTransparency=0,BorderSizePixel=0,
            Rotation=index==1 and 45 or -45,ZIndex=12,
        },chevron)
        corner(arm,1)
        chevronArms[index]=arm
    end
    local details=mkRow(mainPage,0)
    details.Name="AutoStealSettings"
    details.Size=UDim2.new(1,-4,0,0)
    details.AutomaticSize=Enum.AutomaticSize.Y
    details.BackgroundColor3=Color3.fromRGB(10,10,13)
    details.BackgroundTransparency=0
    details:SetAttribute("FearThemeRole","AutoStealSettings")
    new("UIPadding",{PaddingTop=UDim.new(0,8),PaddingBottom=UDim.new(0,8),PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8)},details)
    new("UIListLayout",{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder},details)
    local modeRow=new("Frame",{
        Name="AutoStealModeRow",Size=UDim2.new(1,0,0,34),LayoutOrder=0,
        BackgroundTransparency=1,BorderSizePixel=0,ZIndex=8,
    },details)
    local modeButtons={}
    local ragRow
    local function refreshModes()
        local palette=uiVisual.getThemePalette()
        local accent=palette.primary
        title.TextColor3=palette.light
        settingsButton.TextColor3=palette.light
        for _,arm in ipairs(chevronArms)do arm.BackgroundColor3=palette.light end
        for mode,entry in pairs(modeButtons)do
            local selected=mode==selectedStealMode
            entry.button:SetAttribute("FearSelected",selected)
            entry.button.BackgroundColor3=selected and accent:Lerp(Color3.fromRGB(8,8,12),.8)or Color3.fromRGB(15,15,19)
            entry.title.TextColor3=selected and accent or Color3.fromRGB(215,215,225)
            entry.edge.Color=selected and accent or Color3.fromRGB(60,60,70)
            entry.edge.Transparency=selected and .12 or .55
            entry.marker.Visible=selected
            entry.marker.BackgroundColor3=accent
        end
        if ragRow then ragRow.Visible=selectedStealMode=="v1"end
    end
    for index,mode in ipairs({"v1","v2"})do
        local button=new("TextButton",{
            Name="AutoStealMode_"..mode,Position=UDim2.new((index-1)*.5,index==1 and 0 or 3,0,0),
            Size=UDim2.new(.5,-3,1,0),BackgroundColor3=Color3.fromRGB(15,15,19),BackgroundTransparency=0,
            Text="",AutoButtonColor=false,BorderSizePixel=0,ZIndex=10,
        },modeRow)
        button:SetAttribute("FearThemeRole","AutoStealMode")
        corner(button,8)
        local edge=stroke(button,Color3.fromRGB(60,60,70),1,.55)
        local modeTitle=new("TextLabel",{
            Name="VersionTitle",Position=UDim2.fromOffset(0,0),Size=UDim2.new(1,0,1,-3),
            BackgroundTransparency=1,Text=string.upper(mode),Font=UI_CONFIG.Font,TextSize=12,
            TextXAlignment=Enum.TextXAlignment.Center,ZIndex=11,
        },button)
        local marker=new("Frame",{
            Name="ModeIndicator",Position=UDim2.new(0,12,1,-4),Size=UDim2.new(1,-24,0,2),
            BackgroundColor3=UI_CONFIG.Accent,BorderSizePixel=0,ZIndex=11,
        },button)
        corner(marker,1)
        modeButtons[mode]={button=button,title=modeTitle,edge=edge,marker=marker}
        button.Activated:Connect(function()
            if selectedStealMode==mode then return end
            applyAutoStealMode(mode)
            saveAllSettings()
        end)
    end
    uiVisual.refreshAutoStealSelector=refreshModes
    _G.M4RefreshStealModeOptions=refreshModes
    _G.M4StealModeBtn=nil
    local radiusRow=mkRow(details,36)
    radiusRow.Name="AutoStealRadiusRow"
    mkLabel(radiusRow,"Range Radius")
    radInput=mkBox(radiusRow,CONFIG.STEAL_RANGE,64,74,function(value)
        if value>=10 and value<=150 and Steal.SetRadius(value)then saveAllSettings()end
        radInput.Text=tostring(CONFIG.STEAL_RANGE)
    end)
    local fpsRow=mkRow(details,36)
    fpsRow.Name="AutoStealFPSRow"
    mkLabel(fpsRow,"Bar FPS")
    uiVisual.stealBarFPSBox=mkBox(fpsRow,uiVisual.stealBarFPS,64,74,nil)
    uiVisual.stealBarFPSBox.Name="AutoStealFillFPS"
    uiVisual.stealBarFPSBox.FocusLost:Connect(function()
        local previous=uiVisual.stealBarFPS
        if uiVisual.setStealBarFPS(uiVisual.stealBarFPSBox.Text)and uiVisual.stealBarFPS~=previous then saveAllSettings()end
        uiVisual.stealBarFPSBox.Text=tostring(uiVisual.stealBarFPS)
    end)
    ragRow=mkRow(details,36)
    ragRow.Name="AutoStealRagdollRow"
    mkLabel(ragRow,"Ragdoll Steal (V1)")
    local ragToggle=new("TextButton",{
        Name="RagdollStealPower",Position=UDim2.new(1,-54,.5,-10),Size=UDim2.fromOffset(38,20),
        BackgroundColor3=Color3.fromRGB(18,18,18),BackgroundTransparency=0,
        Text="OFF",TextColor3=UI_CONFIG.Text,Font=UI_CONFIG.Font,TextSize=11,
        AutoButtonColor=false,BorderSizePixel=0,ZIndex=10,
    },ragRow)
    uiVisual.addSwitchParts(ragToggle)
    local ragOn=_G.M4RagdollStealEnabled==true
    local function setRagVisual(state)
        ragOn=state==true
        ragToggle:SetAttribute("FearToggleOn",ragOn)
        uiVisual.paintBlessSwitch(ragToggle,true)
    end
    _G.M4RagdollStealSetVisual=setRagVisual
    ragToggle.Activated:Connect(function()
        if editModeEnabled and not uiLocked then return end
        local wanted=not ragOn
        Steal.SetRagdollEnabled(wanted)
        setRagVisual(wanted)
        saveAllSettings()
    end)
    local autoOn=CONFIG.AUTO_STEAL_ENABLED==true and Steal.AutoStealEnabled==true
    local function setAutoVisual(state)
        autoOn=state==true
        power:SetAttribute("FearToggleOn",autoOn)
        uiVisual.paintBlessSwitch(power,true)
    end
    setInstaGrab=setAutoVisual
    power.Activated:Connect(function()
        if editModeEnabled and not uiLocked then return end
        local actual=false
        if not autoOn then
            local ok,result=pcall(startAutoStealSemi)
            actual=ok and result~=false and Steal.AutoStealEnabled==true
        else pcall(stopAutoSteal)end
        CONFIG.AUTO_STEAL_ENABLED=actual
        Steal.AutoStealEnabled=actual
        _G.KillHub.Active.steal=actual
        setAutoVisual(actual)
        updateProgressBarVisibility()
        saveAllSettings()
    end)
    local expanded=false
    settingsButton.Activated:Connect(function()
        expanded=not expanded
        details.Visible=expanded
        chevron.Rotation=expanded and 180 or 0
        settingsEdge.Color=expanded and uiVisual.getThemeAccent()or Color3.fromRGB(65,65,72)
        settingsEdge.Transparency=expanded and .05 or .25
    end)
    details.Visible=false
    refreshModes()
    setRagVisual(ragOn)
    setAutoVisual(autoOn)
end


mkSect(visualPage,"Effects")uiVisual.tronTrailVisual=mkToggle(visualPage,"Tron Trail",function(on)uiVisual.setTronTrail(on)end)uiVisual.tronTrailVisual(uiVisual.tronTrailEnabled==true)

 mkSect(visualPage,"Theme")do local row=mkRow(visualPage,30)mkLabel(row,"Sky Theme")local currentIndex=1 for i,entry in ipairs(CANDY_SKY_ORDER)do if entry[2]==currentSkyTheme then currentIndex=i;break end end local container=Instance.new("Frame",row)container.Size=UDim2.new(0,160,1,0)container.Position=UDim2.new(1,-168,0,0)container.BackgroundTransparency=1 container.ZIndex=8 local leftBtn=Instance.new("TextButton",container)leftBtn.Size=UDim2.new(0,32,0,26)leftBtn.Position=UDim2.new(0,0,0.5,-13)leftBtn.BackgroundColor3=INP leftBtn.BackgroundTransparency=0.18 leftBtn.BorderSizePixel=0 leftBtn.Text="<"leftBtn.TextColor3=WHITE leftBtn.Font=Enum.Font.GothamBlack leftBtn.TextSize=13 leftBtn.AutoButtonColor=false leftBtn.ZIndex=9 Instance.new("UICorner",leftBtn).CornerRadius=UDim.new(0,6)local leftStroke=Instance.new("UIStroke",leftBtn)leftStroke.Color=ROW_BORDER leftStroke.Thickness=1 skySelectorLabel=Instance.new("TextLabel",container)skySelectorLabel.Size=UDim2.new(0,80,0,26)skySelectorLabel.Position=UDim2.new(0.5,-40,0.5,-13)skySelectorLabel.BackgroundTransparency=1 skySelectorLabel.Text=CANDY_SKY_ORDER[currentIndex][2]skySelectorLabel.TextColor3=WHITE skySelectorLabel.Font=Enum.Font.GothamBlack skySelectorLabel.TextSize=12 skySelectorLabel.TextXAlignment=Enum.TextXAlignment.Center skySelectorLabel.ZIndex=9 local rightBtn=Instance.new("TextButton",container)rightBtn.Size=UDim2.new(0,32,0,26)rightBtn.Position=UDim2.new(1,-32,0.5,-13)rightBtn.BackgroundColor3=INP rightBtn.BackgroundTransparency=0.18 rightBtn.BorderSizePixel=0 rightBtn.Text=">"rightBtn.TextColor3=WHITE rightBtn.Font=Enum.Font.GothamBlack rightBtn.TextSize=13 rightBtn.AutoButtonColor=false rightBtn.ZIndex=9 Instance.new("UICorner",rightBtn).CornerRadius=UDim.new(0,6)local rightStroke=Instance.new("UIStroke",rightBtn)rightStroke.Color=ROW_BORDER rightStroke.Thickness=1 local function updateSkySelector(direction)if mikuSkyEnabled then stopMikuSky()if mikuSkySetVisual then mikuSkySetVisual(false)end end local idx=1 for i,entry in ipairs(CANDY_SKY_ORDER)do if entry[2]==currentSkyTheme then idx=i;break end end local newIdx=idx+direction if newIdx<1 then newIdx=#CANDY_SKY_ORDER end if newIdx>#CANDY_SKY_ORDER then newIdx=1 end setSkyTheme(CANDY_SKY_ORDER[newIdx][2])saveAllSettings()end leftBtn.Activated:Connect(function()updateSkySelector(-1)end)rightBtn.Activated:Connect(function()updateSkySelector(1)end)end mikuSkySetVisual=mkToggle(visualPage,"Miku sky",function(on)if on then startMikuSky()else stopMikuSky()end saveAllSettings()end)if mikuSkySetVisual then mikuSkySetVisual(mikuSkyEnabled)end do local collapsedHeight=34 local expandedHeight=196 local row=mkRow(visualPage,collapsedHeight)mkLabel(row,"UI Font")local selectBtn=Instance.new("TextButton",row)selectBtn.Size=UDim2.new(0,148,0,24)selectBtn.Position=UDim2.new(1,-156,0,5)selectBtn.BackgroundColor3=INP selectBtn.BackgroundTransparency=0.12 selectBtn.BorderSizePixel=0 selectBtn.Text=uiVisual.fontDisplayName(uiVisual.fontName).."  ▼"selectBtn.TextColor3=WHITE selectBtn.Font=uiVisual.resolveFont(uiVisual.fontName)or Enum.Font.GothamBold selectBtn.TextSize=9 selectBtn.TextTruncate=Enum.TextTruncate.AtEnd selectBtn.AutoButtonColor=false selectBtn.ZIndex=11 Instance.new("UICorner",selectBtn).CornerRadius=UDim.new(0,7)local selectStroke=Instance.new("UIStroke",selectBtn)selectStroke.Color=ROW_BORDER selectStroke.Thickness=1 selectStroke.Transparency=0.3 local list=Instance.new("ScrollingFrame",row)list.Name="FontList"list.Position=UDim2.new(0,8,0,37)list.Size=UDim2.new(1,-16,0,151)list.BackgroundColor3=Color3.fromRGB(9,9,9)list.BackgroundTransparency=0.05 list.BorderSizePixel=0 list.ScrollBarThickness=3 list.ScrollBarImageColor3=uiVisual.getThemeAccent()list.ScrollingDirection=Enum.ScrollingDirection.Y list.CanvasSize=UDim2.new(0,0,0,0)list.Visible=false list.ZIndex=20 Instance.new("UICorner",list).CornerRadius=UDim.new(0,6)local listStroke=Instance.new("UIStroke",list)listStroke.Color=ROW_BORDER listStroke.Thickness=1 listStroke.Transparency=0.4 local layout=Instance.new("UIListLayout",list)layout.SortOrder=Enum.SortOrder.LayoutOrder layout.Padding=UDim.new(0,3)local padding=Instance.new("UIPadding",list)padding.PaddingTop=UDim.new(0,5)padding.PaddingBottom=UDim.new(0,5)padding.PaddingLeft=UDim.new(0,5)padding.PaddingRight=UDim.new(0,5)local open=false local function setOpen(state)open=state==true list.Visible=open row.Size=UDim2.new(1,-4,0,open and expandedHeight or collapsedHeight)selectBtn.Text=uiVisual.fontDisplayName(uiVisual.fontName)..(open and"  ▲"or"  ▼")end local function addFontOption(displayName,fontItem,order,fontName)local option=Instance.new("TextButton",list)option.Name="Font_"..tostring(fontName or displayName)option.Size=UDim2.new(1,-2,0,25)option.BackgroundColor3=Color3.fromRGB(15,15,15)option.BackgroundTransparency=0.08 option.BorderSizePixel=0 option.Text=displayName option.TextColor3=WHITE option.Font=fontItem option.TextSize=11 option.TextXAlignment=Enum.TextXAlignment.Left option.AutoButtonColor=false option.LayoutOrder=order option.ZIndex=22 option:SetAttribute("FearFontPreview",true)Instance.new("UICorner",option).CornerRadius=UDim.new(0,6)local optionPadding=Instance.new("UIPadding",option)optionPadding.PaddingLeft=UDim.new(0,9)option.Activated:Connect(function()uiVisual.applyFont(fontName or fontItem.Name,true)selectBtn.Font=fontItem setOpen(false)end)return option end addFontOption("Original",Enum.Font.GothamBold,1,"GothamBold")local fontOrder=2 for _,fontItem in ipairs(uiVisual.fontItems)do if fontItem.Name~="GothamBold"then addFontOption(fontItem.Name,fontItem,fontOrder,fontItem.Name)fontOrder+=1 end end layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()list.CanvasSize=UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+10)end)task.defer(function()if list and list.Parent then list.CanvasSize=UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+10)end end)selectBtn.Activated:Connect(function()setOpen(not open)end)uiVisual.fontSelectorLabel=selectBtn setOpen(false)end mkSect(visualPage,"Halloween Outfits")do local row=mkRow(visualPage,80)local outfitCards={}local outfits={{"Pumpkin","PUMPKIN"},{"Witch","WITCH"},{"Gothic","GOTHIC"},{"Vampire","VAMPIRE"},{"Skeleton","SKELETON"},{"Orange","ORANGE"},}local function refreshHalloweenOutfits()for _,card in ipairs(outfitCards)do local active=_G.BLESS_HalloweenCurrent==card.name uiVisual.tween(card.button,{BackgroundColor3=active and Color3.fromRGB(25,25,25)or Color3.fromRGB(16,16,16),BackgroundTransparency=active and 0 or 0.15},0.12)uiVisual.tween(card.stroke,{Color=active and Color3.fromRGB(135,135,135)or Color3.fromRGB(78,78,78),Transparency=active and 0.02 or 0.48,Thickness=active and 1.8 or 1},0.12)card.dot.BackgroundColor3=active and Color3.fromRGB(140,140,140)or Color3.fromRGB(86,86,86)end end for i,data in ipairs(outfits)do local col=(i-1)%3 local line=math.floor((i-1)/3)local button=Instance.new("TextButton",row)button.Size=UDim2.new(1/3,-8,0,31)button.Position=UDim2.new(col/3,4+col*2,0,5+line*36)button.BackgroundColor3=Color3.fromRGB(16,16,16)button.BackgroundTransparency=0.15 button.BorderSizePixel=0 button.Text=""button.AutoButtonColor=false button.ZIndex=9 Instance.new("UICorner",button).CornerRadius=UDim.new(0,7)local stroke=Instance.new("UIStroke",button)stroke.Color=Color3.fromRGB(78,78,78)stroke.Transparency=0.48 stroke.Thickness=1 local dot=Instance.new("Frame",button)dot.Size=UDim2.fromOffset(5,5)dot.Position=UDim2.fromOffset(8,13)dot.BackgroundColor3=Color3.fromRGB(86,86,86)dot.BorderSizePixel=0 dot.ZIndex=10 Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)local label=Instance.new("TextLabel",button)label.Size=UDim2.new(1,-20,1,0)label.Position=UDim2.fromOffset(17,0)label.BackgroundTransparency=1 label.Text=data[2]label.TextColor3=WHITE label.Font=Enum.Font.GothamBlack label.TextSize=data[2]=="SKELETON"and 7 or 8 label.TextXAlignment=Enum.TextXAlignment.Left label.ZIndex=10 outfitCards[#outfitCards+1]={name=data[1],button=button,stroke=stroke,dot=dot}button.Activated:Connect(function()if _G.BLESS_HalloweenBusy then return end local selected=data[1]if _G.BLESS_HalloweenCurrent==selected then _G.BLESS_HalloweenCurrent=nil refreshHalloweenOutfits()task.spawn(function()_G.BLESS_HalloweenBusy=true pcall(_G.BLESS_HalloweenRestore)_G.BLESS_HalloweenBusy=false refreshHalloweenOutfits()end)return end _G.BLESS_HalloweenCurrent=selected refreshHalloweenOutfits()task.spawn(function()_G.BLESS_HalloweenBusy=true local ok,result=pcall(function()return _G.BLESS_HalloweenApply(selected,false)end)_G.BLESS_HalloweenBusy=false if not ok or result~=true then _G.BLESS_HalloweenCurrent=nil end refreshHalloweenOutfits()end)end)end refreshHalloweenOutfits()end mkSect(visualPage,"Weapon Skins")do local skinToggle=mkToggle(visualPage,"Enable Weapon Skins",function(on)if _G.M4ExtrasAPI then _G.M4ExtrasAPI.setWeaponSkins(on)end saveAllSettings()end)if skinToggle and _G.M4Extras then skinToggle(_G.M4Extras.weaponSkinsEnabled==true)end uiVisual.swordGlowVisual=mkToggle(visualPage,"Sword Glow",function(on)if _G.M4ExtrasAPI then _G.M4ExtrasAPI.setSwordGlow(on)end saveAllSettings()end)uiVisual.swordGlowVisual(_G.M4Extras and _G.M4Extras.swordGlowEnabled==true)local function makeWeaponSelector(labelText,cat,order,stateKey)local row=mkRow(visualPage,34)mkLabel(row,labelText)local btn=Instance.new("TextButton",row)btn.Size=UDim2.new(0,146,0,24)btn.Position=UDim2.new(1,-154,0.5,-12)btn.BackgroundColor3=Color3.fromRGB(19,19,19)btn.BorderSizePixel=0 btn.TextColor3=WHITE btn.Font=Enum.Font.GothamBold btn.TextSize=9 btn.AutoButtonColor=false btn.ZIndex=10 Instance.new("UICorner",btn).CornerRadius=UDim.new(0,7)local st=Instance.new("UIStroke",btn);st.Color=WHITE;st.Transparency=0.35 local function refresh()local key=_G.M4Extras and _G.M4Extras[stateKey]or order[1]local def=_G.M4ExtrasAPI and _G.M4ExtrasAPI.toolAssets and _G.M4ExtrasAPI.toolAssets[key]btn.Text=(def and def.label or tostring(key)).."  ↻"end btn.Activated:Connect(function()if not _G.M4ExtrasAPI then return end local current=_G.M4Extras and _G.M4Extras[stateKey]or order[1]local idx=table.find(order,current)or 1 idx=idx%#order+1 _G.M4ExtrasAPI.setWeaponSkin(cat,order[idx])refresh()saveAllSettings()end)refresh()end if _G.M4ExtrasAPI then makeWeaponSelector("Bat Skin","Bat",_G.M4ExtrasAPI.batSkinOrder,"batWeaponSkin")makeWeaponSelector("Medusa Skin","Medusa",_G.M4ExtrasAPI.medSkinOrder,"medWeaponSkin")end local soundToggle=mkToggle(visualPage,"Custom Weapon Sounds",function(on)if _G.M4ExtrasAPI then _G.M4ExtrasAPI.setWeaponSounds(on)end saveAllSettings()end)if soundToggle and _G.M4Extras then soundToggle(_G.M4Extras.weaponSoundsEnabled==true)end end mkSect(visualPage,"X-Ray")local m4BaseXVisual=mkToggle(visualPage,"Base X-Ray",function(on)if _G.M4ExtrasAPI then _G.M4ExtrasAPI.setBaseXRay(on)end saveAllSettings()end)if m4BaseXVisual and _G.M4Extras then m4BaseXVisual(_G.M4Extras.baseXRayEnabled==true)end local m4BrainXVisual=mkToggle(visualPage,"Brainrot X-Ray",function(on)if _G.M4ExtrasAPI then _G.M4ExtrasAPI.setBrainrotXRay(on)end saveAllSettings()end)if m4BrainXVisual and _G.M4Extras then m4BrainXVisual(_G.M4Extras.brainrotXRayEnabled==true)end do local row=mkRow(visualPage,30)mkLabel(row,"Anim Pack")local currentIndex=1 for i,entry in ipairs(ANIM_PACK_ORDER)do if entry[2]==currentAnimPack then currentIndex=i;break end end local container=Instance.new("Frame",row)container.Size=UDim2.new(0,160,1,0)container.Position=UDim2.new(1,-168,0,0)container.BackgroundTransparency=1 container.ZIndex=8 local leftBtn=Instance.new("TextButton",container)leftBtn.Size=UDim2.new(0,32,0,26)leftBtn.Position=UDim2.new(0,0,0.5,-13)leftBtn.BackgroundColor3=INP leftBtn.BackgroundTransparency=0.7 leftBtn.BorderSizePixel=0 leftBtn.Text="<"leftBtn.TextColor3=WHITE leftBtn.Font=Enum.Font.GothamBlack leftBtn.TextSize=13 leftBtn.AutoButtonColor=false leftBtn.ZIndex=9 Instance.new("UICorner",leftBtn).CornerRadius=UDim.new(0,6)local leftStroke=Instance.new("UIStroke",leftBtn)leftStroke.Color=ROW_BORDER leftStroke.Thickness=1 animSelectorLabel=Instance.new("TextLabel",container)animSelectorLabel.Size=UDim2.new(0,80,0,26)animSelectorLabel.Position=UDim2.new(0.5,-40,0.5,-13)animSelectorLabel.BackgroundTransparency=1 animSelectorLabel.Text=ANIM_PACK_ORDER[currentIndex][2]animSelectorLabel.TextColor3=WHITE animSelectorLabel.Font=Enum.Font.GothamBlack animSelectorLabel.TextSize=12 animSelectorLabel.TextXAlignment=Enum.TextXAlignment.Center animSelectorLabel.ZIndex=9 local rightBtn=Instance.new("TextButton",container)rightBtn.Size=UDim2.new(0,32,0,26)rightBtn.Position=UDim2.new(1,-32,0.5,-13)rightBtn.BackgroundColor3=INP rightBtn.BackgroundTransparency=0.7 rightBtn.BorderSizePixel=0 rightBtn.Text=">"rightBtn.TextColor3=WHITE rightBtn.Font=Enum.Font.GothamBlack rightBtn.TextSize=13 rightBtn.AutoButtonColor=false rightBtn.ZIndex=9 Instance.new("UICorner",rightBtn).CornerRadius=UDim.new(0,6)local rightStroke=Instance.new("UIStroke",rightBtn)rightStroke.Color=ROW_BORDER rightStroke.Thickness=1 local function updateAnimSelector(direction)local idx=1 for i,entry in ipairs(ANIM_PACK_ORDER)do if entry[2]==currentAnimPack then idx=i;break end end local newIdx=idx+direction if newIdx<1 then newIdx=#ANIM_PACK_ORDER end if newIdx>#ANIM_PACK_ORDER then newIdx=1 end local packName=ANIM_PACK_ORDER[newIdx][2]if packName=="Off"then stopAnimPack()else startAnimPack(packName)end saveAllSettings()end leftBtn.Activated:Connect(function()updateAnimSelector(-1)end)rightBtn.Activated:Connect(function()updateAnimSelector(1)end)end do mkSect(visualPage,"Performance")uiVisual.performanceVisual=mkToggle(visualPage,"120 FPS Mode",function(on)uiVisual.setPerformance120(on)saveAllSettings()end)local row=mkRow(visualPage,32)row.Name="PerformanceFPS"local label=mkLabel(row,"FPS --")label.Name="RealFPS"label.Size=UDim2.new(1,-20,1,0)label.Font=Enum.Font.GothamMedium label.TextSize=10 label.TextStrokeTransparency=1 label:SetAttribute("FearThemeRole","RowLabel")uiVisual.bindPerformanceCounter(label)end setESPVIsual=mkToggle(visualPage,"Player ESP",function(on)toggleESP(on)saveAllSettings()end)local stretchToggleSetter stretchToggleSetter=mkToggle(visualPage,"Stretch Rez",function(on)if on then enableStretch()else disableStretch()end stretchEnabled=on saveAllSettings()end)_G.stretchToggleSetter=stretchToggleSetter stretchToggleSetter(stretchEnabled)setAntiLagVisual=mkToggle(visualPage,"Anti Lag",function(on)if on then enableAntiLag()else disableAntiLag()end saveAllSettings()end)_G.M4ShinySetVisual=mkToggle(visualPage,"Shiny Mode",function(on)_G.M4ShinyEnabled=on==true if _G.M4ShinyEnabled then if _G.M4StartShiny then pcall(_G.M4StartShiny)end else if _G.M4StopShiny then pcall(_G.M4StopShiny)end end saveAllSettings()end)
mkSect(settingsPage,"Interface")editModeEnabled=false setEditModeVisual=nil uiVisual.hideButtonsVisual=mkToggle(settingsPage,"Hide Buttons",function(on)uiVisual.setHideButtons(on)end)uiVisual.hideButtonsVisual(uiVisual.hideButtons==true)do
    local row = mkRow(settingsPage, 70)
    row.Name = "SectionModeOptions"
    local title = mkLabel(row, "Sections")
    title.Size = UDim2.new(1, -20, 0, 24)
    title.TextSize = 11
    local holder = Instance.new("Frame", row)
    holder.Size = UDim2.new(1, -20, 0, 30)
    holder.Position = UDim2.fromOffset(10, 30)
    holder.BackgroundTransparency = 1
    holder.ZIndex = 9
    local choices = {{"Off", "NO SECTIONS"}, {"Selector", "ARROWS"}, {"Tabs", "TABS"}}
    local buttons = {}
    local function refresh()
        for mode, button in pairs(buttons) do
            button:SetAttribute("FearSelected", uiPreferences.sectionsMode == mode)
            uiVisual.refreshTheme(button)
        end
    end
    for index, choice in ipairs(choices) do
        local mode = choice[1]
        local button = Instance.new("TextButton", holder)
        button.Name = "SectionsMode_" .. mode
        button.Size = UDim2.new(1 / #choices, -5, 1, 0)
        button.Position = UDim2.new((index - 1) / #choices, 2, 0, 0)
        button.BackgroundColor3 = INP
        button.BackgroundTransparency = 0
        button.BorderSizePixel = 0
        button.Text = choice[2]
        button.Font = Enum.Font.GothamBold
        button.TextSize = 9
        button.TextColor3 = WHITE
        button.AutoButtonColor = false
        button.ZIndex = 10
        button:SetAttribute("FearThemeRole", "SelectorButton")
        Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", button)
        stroke:SetAttribute("FearThemeRole", "SelectorStroke")
        stroke.Thickness = 1
        buttons[mode] = button
        button.Activated:Connect(function()
            if uiPreferences.sectionsMode == mode then return end
            uiPreferences.sectionsMode, uiPreferences.sectionsVersion = mode, 1
            if mode ~= "Off" then uiPreferences.tab = "Settings" end
            sectionNav.Close()
            searchQuery = ""
            if searchBox.Text ~= "" then searchBox.Text = "" end
            applyTabLayout()
            refresh()
            saveAllSettings()
            if _G.M4ToggleSFXPlay then task.defer(_G.M4ToggleSFXPlay) end
        end)
    end
    uiVisual.sectionsVisual = nil
    uiVisual.refreshSectionsMode = refresh
    refresh()
end

setLockUIVisual=mkToggle(settingsPage,"Lock UI",function(on)toggleLockUI(on)if on and editModeEnabled then editModeEnabled=false if setEditModeVisual then setEditModeVisual(false)end end saveAllSettings()end)do  makeScaleSlider(settingsPage,"Button Size",0.5,1.5,0.05,function()return buttonScaleValue end,function(value)applyButtonScale(value)end,"buttonScaleValueLabel")makeScaleSlider(settingsPage,"UI Scale",50,150,5,function()return uiScaleValue end,function(value)uiScaleValue=value if _G.__SureApplyResponsiveMainScale then _G.__SureApplyResponsiveMainScale()elseif mainUIScale then mainUIScale.Scale=value/100 end end,"uiScaleValueLabel")makeScaleSlider(settingsPage,"Steal Bar Size",50,180,5,function()return stealBarScaleValue end,function(value)stealBarScaleValue=value refreshStealBarScale()end,"stealBarScaleValueLabel")uiVisual.refreshSliders=function()for _,refresh in ipairs(sliderRefreshers)do refresh()end end end mkSect(settingsPage,"Status")do local row=mkRow(settingsPage,34)mkLabel(row,"Audio Engine")local sfxStatus=Instance.new("TextLabel",row)sfxStatus.Size=UDim2.new(0,128,1,0)sfxStatus.Position=UDim2.new(1,-138,0,0)sfxStatus.BackgroundTransparency=1 sfxStatus.Font=Enum.Font.GothamBlack sfxStatus.TextSize=10 sfxStatus.TextXAlignment=Enum.TextXAlignment.Right sfxStatus.ZIndex=9 sfxStatus:SetAttribute("FearThemeRole","AccentText")task.spawn(function()while sfxStatus and sfxStatus.Parent do local toggleReady=_G.M4ToggleSFX and type(_G.M4ToggleSFX.asset)=="string"and _G.M4ToggleSFX.asset~=""local death=_G.M4ExtraSFX and _G.M4ExtraSFX.Death local deathReady=death and type(death.asset)=="string"and death.asset~=""local busy=(_G.M4ToggleSFX and _G.M4ToggleSFX.busy)or(death and death.busy)if toggleReady and deathReady then sfxStatus.Text="SFX READY"elseif busy then sfxStatus.Text="SFX LOADING"else sfxStatus.Text="SFX FALLBACK"end sfxStatus.TextColor3=uiVisual.getThemePalette().light task.wait(0.5)end end)end mkSect(settingsPage,"Configuration")do local row=mkRow(settingsPage,44)row.Size=UDim2.new(1,0,0,44)local resetUIBtn=Instance.new("TextButton",row)resetUIBtn.Size=UDim2.new(1,-12,0.8,0)resetUIBtn.Position=UDim2.new(0,6,0.1,0)resetUIBtn.BackgroundColor3=Color3.fromRGB(25,25,25)resetUIBtn.BackgroundTransparency=0.18 resetUIBtn.BorderSizePixel=0 resetUIBtn.Text="RESET UI"resetUIBtn.TextColor3=WHITE resetUIBtn.Font=Enum.Font.GothamBlack resetUIBtn.TextSize=12 resetUIBtn.AutoButtonColor=false resetUIBtn.ZIndex=8 resetUIBtn:SetAttribute("FearThemeRole","InputButton")Instance.new("UICorner",resetUIBtn).CornerRadius=UDim.new(0,6)local resetUIStroke=Instance.new("UIStroke",resetUIBtn)resetUIStroke:SetAttribute("FearThemeRole","InputButtonStroke")resetUIStroke.Thickness=1.2 resetUIStroke.Transparency=0.28 local resetUIDebounce=false resetUIBtn.Activated:Connect(function()if resetUIDebounce then return end resetUIDebounce=true resetFloatingPositions()forceResetUI()uiScaleValue=100 stealBarScaleValue=100 buttonScaleValue=1.0 if _G.__SureApplyResponsiveMainScale then _G.__SureApplyResponsiveMainScale()end refreshStealBarScale()applyButtonScale(1.0)saveAllSettings()resetUIBtn.Text="UI RESET ✓"if _G.M4ToggleSFXPlay then task.defer(_G.M4ToggleSFXPlay)end task.delay(1.2,function()if resetUIBtn and resetUIBtn.Parent then resetUIBtn.Text="RESET UI"resetUIDebounce=false end end)end)end do local row=mkRow(settingsPage,44)row.Size=UDim2.new(1,0,0,44)local saveBtn=Instance.new("TextButton",row)saveBtn.Size=UDim2.new(1,-12,0.8,0)saveBtn.Position=UDim2.new(0,6,0.1,0)saveBtn.BackgroundColor3=Color3.fromRGB(32,32,32)saveBtn.BackgroundTransparency=0.5 saveBtn.BorderSizePixel=0 saveBtn.Text="SAVE NOW"saveBtn.TextColor3=WHITE saveBtn.Font=Enum.Font.GothamBold saveBtn.TextSize=13 saveBtn.TextStrokeColor3=Color3.fromRGB(60,60,60)saveBtn.TextStrokeTransparency=0 saveBtn.AutoButtonColor=false saveBtn.ZIndex=8 Instance.new("UICorner",saveBtn).CornerRadius=UDim.new(0,6)local saveStroke=Instance.new("UIStroke",saveBtn)saveStroke.Color=ROW_BORDER saveStroke.Thickness=1.2 saveStroke.Transparency=0.5 saveBtn.Activated:Connect(function()local ok=saveAllSettings()saveBtn.Text=ok and"SAVED ✓"or"ERROR"task.delay(1.2,function()if saveBtn and saveBtn.Parent then saveBtn.Text="SAVE NOW"end end)end)end do local row=mkRow(settingsPage,44)row.Size=UDim2.new(1,0,0,44)local resetPosBtn=Instance.new("TextButton",row)resetPosBtn.Size=UDim2.new(1,-12,0.8,0)resetPosBtn.Position=UDim2.new(0,6,0.1,0)resetPosBtn.BackgroundColor3=Color3.fromRGB(32,32,32)resetPosBtn.BackgroundTransparency=0.5 resetPosBtn.BorderSizePixel=0 resetPosBtn.Text="RESET POSITIONS"resetPosBtn.TextColor3=WHITE resetPosBtn.Font=Enum.Font.GothamBold resetPosBtn.TextSize=13 resetPosBtn.TextStrokeColor3=Color3.fromRGB(60,60,60)resetPosBtn.TextStrokeTransparency=0 resetPosBtn.AutoButtonColor=false resetPosBtn.ZIndex=8 Instance.new("UICorner",resetPosBtn).CornerRadius=UDim.new(0,6)local resetStroke=Instance.new("UIStroke",resetPosBtn)resetStroke.Color=ROW_BORDER resetStroke.Thickness=1.2 resetStroke.Transparency=0.5 local resetDebounce=false resetPosBtn.Activated:Connect(function()if resetDebounce then return end resetDebounce=true resetFloatingPositions()saveAllSettings()resetPosBtn.Text="RESET ✓"task.delay(1.2,function()if resetPosBtn and resetPosBtn.Parent then resetPosBtn.Text="RESET POSITIONS"resetDebounce=false end end)end)end do local row=mkRow(settingsPage,44)row.Size=UDim2.new(1,0,0,44)local delBtn=Instance.new("TextButton",row)delBtn.Size=UDim2.new(1,-12,0.8,0)delBtn.Position=UDim2.new(0,6,0.1,0)delBtn.BackgroundColor3=Color3.fromRGB(77,77,77)delBtn.BackgroundTransparency=0.5 delBtn.BorderSizePixel=0 delBtn.Text="DELETE SETTINGS"delBtn.TextColor3=WHITE delBtn.Font=Enum.Font.GothamBold delBtn.TextSize=13 delBtn.TextStrokeColor3=Color3.fromRGB(60,60,60)delBtn.TextStrokeTransparency=0 delBtn.AutoButtonColor=false delBtn.ZIndex=8 Instance.new("UICorner",delBtn).CornerRadius=UDim.new(0,6)local delStroke=Instance.new("UIStroke",delBtn)delStroke.Color=ROW_BORDER delStroke.Thickness=1.2 delStroke.Transparency=0.5 local deleteState=0 local originalDeleteText="DELETE SETTINGS"local delDebounce=false delBtn.Activated:Connect(function()if delDebounce then return end if deleteState==0 then deleteState=1 delBtn.Text="CONFIRM?"delBtn.BackgroundColor3=Color3.fromRGB(110,110,110)task.delay(2,function()if delBtn and delBtn.Parent and deleteState==1 then deleteState=0 delBtn.Text=originalDeleteText delBtn.BackgroundColor3=Color3.fromRGB(77,77,77)end end)elseif deleteState==1 then delDebounce=true local success=pcall(resetToFactoryDefaults)delBtn.Text=success and"DELETED ✓"or"ERROR"delBtn.BackgroundColor3=Color3.fromRGB(77,77,77)deleteState=0 task.delay(1.5,function()if delBtn and delBtn.Parent then delBtn.Text=originalDeleteText delBtn.BackgroundColor3=Color3.fromRGB(77,77,77)delDebounce=false end end)end end)end local keyPage=settingsPage mkSect(keyPage,"Bind")uiVisual.moreButtonsVisual=mkToggle(keyPage,"More Buttons",function(on)uiVisual.setMoreButtons(on)end)uiVisual.moreButtonsVisual(uiVisual.moreButtons==true)do local note=mkRow(keyPage,32)local text=Instance.new("TextLabel",note)text.Size=UDim2.new(1,-16,1,0)text.Position=UDim2.fromOffset(8,0)text.BackgroundTransparency=1 text.Font=Enum.Font.GothamMedium text.TextSize=10 text.TextWrapped=true text.TextXAlignment=Enum.TextXAlignment.Left text.TextColor3=Color3.fromRGB(174,174,174)text.Text="Use the upper D-pad button as a keybind."text.ZIndex=8 end mkSect(keyPage,"Main")addKeybindRow(keyPage,"Carry Mode",KB.CarryToggle)addKeybindRow(keyPage,"Lagger Mode",KB.LaggerMode)addKeybindRow(keyPage,"Float",KB.Float)addKeybindRow(keyPage,"Auto Left",KB.AutoLeft)addKeybindRow(keyPage,"Auto Right",KB.AutoRight)mkSect(keyPage,"Combat")addKeybindRow(keyPage,"Bat Aimbot",KB.AutoBat)addKeybindRow(keyPage,"Bat Bypass",KB.BatV2)addKeybindRow(keyPage,"TP Bat",KB.Bypass)mkSect(keyPage,"Actions")addKeybindRow(keyPage,"TP Down",KB.TPFloor)addKeybindRow(keyPage,"Drop Brainrot",KB.DropBrainrot)addKeybindRow(keyPage,"Insta Reset",KB.InstaReset)local spacer=Instance.new("Frame",keyPage)spacer.Size=UDim2.new(1,0,0,16)spacer.BackgroundTransparency=1 spacer.LayoutOrder=getNextOrder(keyPage)spacer.ZIndex=7 pcall(function()local oldStealLayer=gui.Parent and gui.Parent:FindFirstChild("FearHubStealBarLayer")if oldStealLayer then oldStealLayer:Destroy()end end)stealBarGui=Instance.new("ScreenGui"); if _G.BlessIntro then _G.BlessIntro.Track(stealBarGui) end; stealBarGui.Name="FearHubStealBarLayer"stealBarGui.ResetOnSpawn=false stealBarGui.IgnoreGuiInset=gui.IgnoreGuiInset stealBarGui.DisplayOrder=math.max(0,gui.DisplayOrder-1)stealBarGui.ZIndexBehavior=gui.ZIndexBehavior pcall(function()if syn and syn.protect_gui then syn.protect_gui(stealBarGui)end end)stealBarGui.Parent=gui.Parent do
    -- Reference layout: image panel, percent at the left, stats at the right.
    pbFrame=Instance.new("Frame",stealBarGui)
    pbFrame.Name="CandyHubAutoStealBar"
    pbFrame.Size=UDim2.fromOffset(326,58)
    pbFrame.Position=UDim2.new(.5,-163,1,-70)
    pbFrame.BackgroundColor3=Color3.fromRGB(13,16,24)
    pbFrame.BackgroundTransparency=0
    pbFrame.BorderSizePixel=0
    pbFrame.Active=true
    pbFrame.ClipsDescendants=true
    pbFrame.Visible=CONFIG.AUTO_STEAL_ENABLED
    pbFrame.ZIndex=10
    pbFrame:SetAttribute("FearThemeRole","StealPanel")
    Instance.new("UICorner",pbFrame).CornerRadius=UDim.new(0,12)
    local outline=Instance.new("UIStroke",pbFrame)
    outline.Thickness=1
    outline.Transparency=.42
    pbScale=Instance.new("UIScale",pbFrame)
    refreshStealBarScale()
    if savedProgressBarPos then
        pbFrame.Position=UDim2.new(savedProgressBarPos.XScale or .5,savedProgressBarPos.XOffset or -163,savedProgressBarPos.YScale or 1,savedProgressBarPos.YOffset or -70)
    end
    refreshStealBarScale()
    local background=Instance.new("ImageLabel",pbFrame)
    background.Name="AutoStealBackground"
    background.Size=UDim2.fromScale(1,1)
    background.BackgroundTransparency=1
    background.BorderSizePixel=0
    background.ImageColor3=Color3.new(1,1,1)
    background.ImageTransparency=.02
    background.ScaleType=Enum.ScaleType.Crop
    background.ZIndex=10
    Instance.new("UICorner",background).CornerRadius=UDim.new(0,12)
    local shade=Instance.new("Frame",pbFrame)
    shade.Name="ImageShade"
    shade.Size=UDim2.fromScale(1,1)
    shade.BackgroundColor3=Color3.fromRGB(9,12,21)
    shade.BackgroundTransparency=.64
    shade.BorderSizePixel=0
    shade.ZIndex=11
    Instance.new("UICorner",shade).CornerRadius=UDim.new(0,12)
    local badge=uiVisual.candyBadge(pbFrame,"AutoStealSweet",20,UDim2.fromOffset(9,9),14)
    local brand=Instance.new("TextLabel",pbFrame)
    brand.Name="CandyBarBrand"
    brand.Size=UDim2.fromOffset(148,17)
    brand.Position=UDim2.fromOffset(37,5)
    brand.BackgroundTransparency=1
    brand.Text="AUTO STEAL"
    brand.TextColor3=Color3.new(1,1,1)
    brand.TextSize=11
    brand.Font=Enum.Font.GothamBold
    brand.TextXAlignment=Enum.TextXAlignment.Left
    brand.ZIndex=14
    local statsLabel=Instance.new("TextLabel",pbFrame)
    statsLabel.Name="PingFPS"
    statsLabel.Position=UDim2.fromOffset(37,23)
    statsLabel.Size=UDim2.fromOffset(180,12)
    statsLabel.BackgroundTransparency=1
    statsLabel.Text="FPS --  PING -- ms"
    statsLabel.TextColor3=Color3.fromRGB(203,213,228)
    statsLabel.Font=Enum.Font.GothamMedium
    statsLabel.TextSize=9
    statsLabel.TextXAlignment=Enum.TextXAlignment.Left
    statsLabel.ZIndex=14
    progressPct=Instance.new("TextLabel",pbFrame)
    progressPct.Name="Percent"
    progressPct.AnchorPoint=Vector2.new(1,0)
    progressPct.Size=UDim2.fromOffset(72,30)
    progressPct.Position=UDim2.new(1,-10,0,6)
    progressPct.BackgroundTransparency=.12
    progressPct.BorderSizePixel=0
    progressPct.Text="0%"
    progressPct.TextColor3=Color3.new(1,1,1)
    progressPct.Font=Enum.Font.GothamBold
    progressPct.TextSize=20
    progressPct.TextXAlignment=Enum.TextXAlignment.Center
    progressPct.ZIndex=14
    Instance.new("UICorner",progressPct).CornerRadius=UDim.new(0,8)
    local percentEdge=Instance.new("UIStroke",progressPct)
    percentEdge.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    percentEdge.Thickness=1
    percentEdge.Transparency=.55
    autoStealModeStatusLabel=nil
    local track=Instance.new("Frame",pbFrame)
    track.Name="ProgressTrack"
    track.Size=UDim2.new(1,-16,0,14)
    track.Position=UDim2.new(0,8,1,-19)
    track.BorderSizePixel=0
    track.ClipsDescendants=true
    track.ZIndex=13
    Instance.new("UICorner",track).CornerRadius=UDim.new(0,7)
    local trackEdge=Instance.new("UIStroke",track)
    trackEdge.Thickness=.7
    trackEdge.Transparency=.5
    progressFill=Instance.new("Frame",track)
    progressFill.Name="FullProgressFill"
    progressFill.Size=UDim2.new(0,0,1,0)
    progressFill.BackgroundColor3=Color3.new(1,1,1)
    progressFill.BackgroundTransparency=0
    progressFill.BorderSizePixel=0
    progressFill.ClipsDescendants=true
    progressFill.ZIndex=14
    Instance.new("UICorner",progressFill).CornerRadius=UDim.new(0,7)
    local fillGradient=Instance.new("UIGradient",progressFill)
    fillGradient.Name="ThemeFillGradient"
    fillGradient.Rotation=0
    fillGradient.Enabled=true
    local fillShine=Instance.new("Frame",progressFill)
    fillShine.Name="CandyFillShine"
    fillShine.Position=UDim2.fromOffset(5,2)
    fillShine.Size=UDim2.new(1,-10,0,1)
    fillShine.BackgroundTransparency=.78
    fillShine.BorderSizePixel=0
    fillShine.Active=false
    fillShine.ZIndex=15
    local bar,fill=pbFrame,progressFill
    local loadedAsset
    local refreshBarTheme
    refreshBarTheme=function()
        if not bar.Parent then return end
        local p=uiVisual.getThemePalette()
        bar.BackgroundColor3=p.deep
        shade.BackgroundColor3=p.deep
        track.BackgroundColor3=p.primary:Lerp(p.deep,.54)
        trackEdge.Color=p.primary
        fillGradient.Color=p.gel
        fillShine.BackgroundColor3=p.light
        outline.Color=p.light
        progressPct.BackgroundColor3=p.inputSurface:Lerp(p.primary,.1)
        progressPct.TextColor3=p.text
        percentEdge.Color=p.primary
        if loadedAsset~=p.autoSteal then
            loadedAsset=p.autoSteal
            uiVisual.loadPreviewAsset(background,loadedAsset)
        end
        uiVisual.candyRefresh(badge)
    end
    uiVisual.refreshStealBarTheme=refreshBarTheme
    local target,drawn,progressStep,drawElapsed=0,0,0,0
    local function draw(elapsed)
        local blend=elapsed and math.min(elapsed/.05,1)or 1
        drawn=drawn+(target-drawn)*blend
        if math.abs(drawn-target)<.00001 then drawn=target end
        fill.Size=UDim2.new(drawn,0,1,0)
        if progressPct and progressPct.Parent==bar then
            progressPct.Text=math.floor(drawn*100).."%"
        end
    end
    local function setProgress(value)
        if not bar.Parent then return end
        value=tonumber(value)
        if not value or value~=value or math.abs(value)==math.huge then value=0 end
        target=math.clamp(value,0,1)
        if(target==0 or target==1 or not bar.Visible)and drawn~=target then
            progressStep,drawElapsed=0,0
            draw()
        end
    end
    local function refreshFPS()
        progressStep,drawElapsed=0,0
        if bar.Parent then draw()end
    end
    uiVisual.setStealProgress=setProgress
    uiVisual.refreshStealBarFPS=refreshFPS
    local statsService=game:GetService("Stats")
    local frames,statsElapsed=0,0
    local connection
    connection=RunService.RenderStepped:Connect(function(dt)
        if not bar.Parent then connection:Disconnect();return end
        frames=frames+1
        statsElapsed=statsElapsed+dt
        if statsElapsed>=.5 then
            local fps=math.floor(frames/statsElapsed+.5)
            frames,statsElapsed=0,0
            local ping
            pcall(function()
                local item=statsService.PerformanceStats and statsService.PerformanceStats.Ping
                if item then ping=tonumber(item:GetValue())end
            end)
            if not ping then pcall(function()ping=tonumber(statsService.Network.ServerStatsItem["Data Ping"]:GetValue())end)end
            statsLabel.Text="FPS "..fps.."  PING "..(ping and tostring(math.floor(ping+.5))or"--").." ms"
        end
        if not bar.Visible then progressStep,drawElapsed=0,0;return end
        progressStep=progressStep+dt
        drawElapsed=drawElapsed+dt
        local interval=1/uiVisual.stealBarFPS
        if progressStep<interval and interval-progressStep>.000000001 then return end
        local elapsed=drawElapsed
        drawElapsed=0
        progressStep=progressStep>=interval and progressStep%interval or 0
        if drawn~=target then draw(elapsed)end
    end)
    bar.Destroying:Connect(function()
        connection:Disconnect()
        if uiVisual.setStealProgress==setProgress then uiVisual.setStealProgress=nil end
        if uiVisual.refreshStealBarFPS==refreshFPS then uiVisual.refreshStealBarFPS=nil end
        if uiVisual.refreshStealBarTheme==refreshBarTheme then uiVisual.refreshStealBarTheme=nil end
    end)
    bar:SetAttribute("BlessStealVisual",true)
    for _,object in ipairs(bar:GetDescendants())do object:SetAttribute("BlessStealVisual",true)end
    refreshBarTheme()
    draw()
    drag(pbFrame)
end
refreshUIPreferences=function()
cancelMainMotion()
if uiVisual.resetOptionsIdle then uiVisual.resetOptionsIdle(true)end
resetMainFade()
if uiVisual.resetWordMotion then uiVisual.resetWordMotion()end
main.Visible=uiPreferences.visible
mainUIScale.Scale=uiVisual.mainTargetScale or 1
local position=uiPreferences.mainPosition or{XScale=0,XOffset=20,YScale=0,YOffset=2}
main.Position=UDim2.new(position.XScale or 0,position.XOffset or 20,position.YScale or 0,position.YOffset or 2)
miniBtn.Visible=not uiPreferences.visible
applyTabLayout()
end
do
    local groups={
        speed={page="Moment",rank=1,title="Speed",items={"NormalSpeedRow","Current Speed"}},
        lagger={page="Moment",rank=2,title="Lagger Speed",items={"Lagger Normal Speed","Lagger Carry Speed"}},
        jump={page="Moment",rank=3,title="Jump",items={"Infinite Jump"}},
        movement={page="Moment",rank=4,title="Auto Movement",items={"Auto Left","Auto Right"}},
        teleport={page="Moment",rank=5,title="Teleport",items={"TP Down","Auto TP Down","Height Y","Mirror TP Down"}},
        reset={page="Moment",rank=6,title="Reset",items={"Insta Reset"}},
        bat={page="Combat",rank=1,title="Bat & Aimbot",items={"Bat Aimbot","Bat Aimbot Speed","Bat Bypass","Bat Bypass Speed","TP Bat"}},
        counters={page="Combat",rank=2,title="Counters",items={"Bat Counter","Counter Mode","Medusa Counter"}},
        defense={page="Combat",rank=3,title="Defense",items={"Anti Die","Anti Ragdoll","Ragdoll Countdown"}},
        body={page="Combat",rank=4,title="Body Lock",items={"Body Lock","Body Lock Range"}},
        steal={page="Main",rank=1,title="Auto Steal",items={"AutoStealHeader","AutoStealSettings"}},
        carry={page="Main",rank=2,title="Auto Carry",items={"Auto Speed","Auto Speed Mode","Soft Steal Range","Auto Spin"}},
        brainrot={page="Main",rank=3,title="Brainrot",items={"Drop Brainrot","Drop Mode"}},
        mainMisc={page="Main",rank=4,title="Tools",items={}},
        backgrounds={page="Visuals",rank=1,title="Color",items={"ColorSelector","BackgroundDarknessSelector","WordDarknessSelector"}},
        sky={page="Visuals",rank=3,title="Sky",items={"Sky Theme","Miku sky"}},
        character={page="Visuals",rank=4,title="Character",items={"Anim Pack"}},
        outfits={page="Visuals",rank=5,title="Outfits",items={}},
        weapons={page="Visuals",rank=6,title="Weapon Skins",items={"Enable Weapon Skins","Bat Skin","Medusa Skin","Sword Glow","Custom Weapon Sounds"}},
        vision={page="Visuals",rank=7,title="Vision",items={"Player ESP","Base X-Ray","Brainrot X-Ray"}},
        effects={page="Visuals",rank=8,title="Effects",items={"Tron Trail","Shiny Mode","Stretch Rez"}},
        interface={page="Settings",rank=1,title="Interface",items={"Sections","UI Font","UI Scale","Button Size","VeoraButtonShapeRow","Hide Buttons","Lock UI","Steal Bar Size"}},
        performance={page="Settings",rank=2,title="Performance",items={"Anti Lag","120 FPS Mode","PerformanceFPS"}},
        controller={page="Settings",rank=3,title="Controller",items={"More Buttons"}},
        bindMovement={page="Settings",rank=4,title="Movement Binds",items={"Carry Mode","Lagger Mode","Float","Auto Left","Auto Right"}},
        bindCombat={page="Settings",rank=5,title="Combat Binds",items={"Bat Aimbot","Bat Bypass","TP Bat"}},
        bindActions={page="Settings",rank=6,title="Action Binds",items={"TP Down","Drop Brainrot","Insta Reset"}},
        status={page="Settings",rank=7,title="Status",items={"Audio Engine"}},
        configuration={page="Settings",rank=8,title="Configuration",items={"SAVE NOW","RESET POSITIONS","RESET UI","DELETE SETTINGS"}},
    }
    local routes={}
    for key,group in pairs(groups)do
        group.positions={}
        for index,title in ipairs(group.items)do
            group.positions[title]=index
            if key~="bindMovement"and key~="bindCombat"and key~="bindActions"then routes[title]=key end
        end
    end
    local defaults={Moment="movement",Combat="defense",Main="mainMisc",Visuals="effects",Settings="interface"}
    local oldSections={
        Moment={['Speed Settings']="speed",['Lagger Speeds']="lagger",['Auto Carry']="carry",['Auto Movement']="movement",['TP & Reset']="teleport"},
        Combat={['Bat & Aimbot']="bat",Counters="counters",Defense="defense"},
        Main={['Auto Steal']="steal",['More Scripts']="tools",Audio="tools"},
        Visuals={Color="backgrounds",Fondos="backgrounds",Word="backgrounds",Theme="sky",['Halloween Outfits']="outfits",['Weapon Skins']="weapons",['X-Ray']="vision",Effects="effects",Performance="performance"},
        Settings={Scripts="tools",Interface="interface",Bind="controller",Main="bindMovement",Combat="bindCombat",Actions="bindActions",Status="status",Configuration="configuration"},
    }
    local headings={}
    local organizing=false
    local function titleFor(row)
        local title=row:GetAttribute("BlessSearchTitle")
        if type(title)=="string"and title~=""then return title end
        for _,child in ipairs(row:GetChildren())do
            if child:IsA("TextLabel")or child:IsA("TextButton")then
                local text=child.Text
                if type(text)=="string"and text~=""then return text end
            end
        end
        return row.Name
    end
    uiVisual.organizeOptions=function()
        if organizing then return end
        organizing=true
        local remove={}
        for _,pageName in ipairs(tabs)do
            local rows={}
            for row,origin in pairs(rowOrigins)do
                if row.Parent and origin.page==pageName and not row:GetAttribute("BlessOrganizedHeading")then rows[#rows+1]=row end
            end
            table.sort(rows,function(a,b)return rowOrigins[a].order<rowOrigins[b].order end)
            local section=""
            for _,row in ipairs(rows)do
                if row:GetAttribute("BlessSearchSection")then
                    section=titleFor(row)
                    remove[#remove+1]=row
                elseif row:GetAttribute("BlessOriginalPage")==nil then
                    row:SetAttribute("BlessOriginalPage",pageName)
                    row:SetAttribute("BlessOriginalSection",section)
                    row:SetAttribute("BlessOriginalOrder",rowOrigins[row].order)
                end
            end
        end
        for _,row in ipairs(remove)do rowOrigins[row]=nil;row:Destroy()end
        local used={}
        remove={}
        for row,origin in pairs(rowOrigins)do
            if row.Parent and not row:GetAttribute("BlessOrganizedHeading")then
                local pageName=row:GetAttribute("BlessOriginalPage")or origin.page
                local section=row:GetAttribute("BlessOriginalSection")or""
                local title=titleFor(row)
                if title=="More adds in next update!!"then
                    remove[#remove+1]=row
                else
                    local key
                    if pageName=="Settings"and(section=="Main"or section=="Combat"or section=="Actions")then
                        key=oldSections.Settings[section]
                    else
                        key=routes[row.Name]or routes[title]or(oldSections[pageName]or{})[section]or defaults[pageName]
                    end
                    local group=groups[key]
                    local position=group.positions[row.Name]or group.positions[title]
                    if not position then position=50+math.clamp((row:GetAttribute("BlessOriginalOrder")or origin.order)%100,0,99)end
                    local order=group.rank*200+10+position
                    origin.page,origin.order=group.page,order
                    row:SetAttribute("BlessSourcePage",group.page)
                    row:SetAttribute("BlessSourceOrder",order)
                    row:SetAttribute("BlessOptionGroup",key)
                    if not row:GetAttribute("BlessSearchTitle")then row:SetAttribute("BlessSearchTitle",title)end
                    used[key]=true
                end
            end
        end
        for _,row in ipairs(remove)do rowOrigins[row]=nil;row:Destroy()end
        for key in pairs(used)do
            local group=groups[key]
            local heading=headings[key]
            if not heading or not heading.Parent then
                heading=mkSect(contentPages[group.page],group.title)
                heading:SetAttribute("BlessOrganizedHeading",true)
                headings[key]=heading
            end
            local order=group.rank*200
            rowOrigins[heading]={page=group.page,order=order}
            heading:SetAttribute("BlessSourcePage",group.page)
            heading:SetAttribute("BlessSourceOrder",order)
        end
        organizing=false
    end
    uiVisual.organizeOptions()
end

refreshUIPreferences()uiVisual.bindVisualLifetime(gui)uiVisual.notifySaved=nil uiVisual.decorate(gui)uiVisual.refreshTheme(main)uiVisual.bindOptionsIdle(main,gui)task.defer(function()RunService.Heartbeat:Wait()for name,page in pairs(contentPages)do page.CanvasPosition=Vector2.new(0,uiPreferences.scroll[name]or 0)page:GetPropertyChangedSignal("CanvasPosition"):Connect(function()if not layoutChanging and searchQuery==""and page.Visible then uiPreferences.scroll[name]=page.CanvasPosition.Y end end)end end)end _fearTouchStartPositions=setmetatable({},{__mode="k"})UIS.InputBegan:Connect(function(input)local t=input.UserInputType if t==Enum.UserInputType.Touch or t==Enum.UserInputType.MouseButton1 then _fearTouchStartPositions[input]=input.Position end end)UIS.InputEnded:Connect(function(input)local t=input.UserInputType if t==Enum.UserInputType.Touch or t==Enum.UserInputType.MouseButton1 then _fearTouchStartPositions[input]=nil end end)function _fearGestureStartedInside(gui,input)if not gui or not gui.Parent or not input then return false end local startPos=_fearTouchStartPositions[input]or input.Position if not startPos then return false end local absPos=gui.AbsolutePosition local absSize=gui.AbsoluteSize return startPos.X>=absPos.X and startPos.X<=absPos.X+absSize.X and startPos.Y>=absPos.Y and startPos.Y<=absPos.Y+absSize.Y end function createMobilePanel()local panel=Instance.new("ScreenGui"); if _G.BlessIntro then _G.BlessIntro.Track(panel) end; panel.Name="KillHubMobilePanel"panel.ResetOnSpawn=false panel.ZIndexBehavior=Enum.ZIndexBehavior.Sibling pcall(function()if syn and syn.protect_gui then syn.protect_gui(panel)end end)if not pcall(function()panel.Parent=game:GetService("CoreGui")end)then panel.Parent=LP:WaitForChild("PlayerGui")end local BTN_W,BTN_H=56,56 local GAP=8 local COLUMNS=2 local ROWS=6 local PANEL_W=BTN_W*COLUMNS+GAP*(COLUMNS-1)local PANEL_H=BTN_H*ROWS+(GAP+4)*(ROWS-1)panel.IgnoreGuiInset=true local anchorX=-PANEL_W-10 local PINK=Color3.fromRGB(198,202,210)local WHITE=Color3.fromRGB(248,248,250)local INACTIVE_BG=Color3.fromRGB(12,12,14)local INACTIVE_TEXT=Color3.fromRGB(150,155,165)local STROKE_COLOR=Color3.fromRGB(145,150,160)local ACTIVE_BG=Color3.fromRGB(198,202,210)local ACTIVE_TEXT=Color3.fromRGB(255,255,255)local buttons={}local buttonNames={"DropBR","AutoLeft","AutoBat","AutoRight","TpDown","TpBat","Lagger1","Reset","Carry","Lagger2","Float"}local buttonTexts={"DROP\nBR","AUTO\nLEFT","BAT\nAIMBOT","AUTO\nRIGHT","TP\nDOWN","TP\nBAT","LAGGER\nNORMAL","RESET","CARRY\nSPD","LAGGER\nCARRY","FLOAT"}local function createButton(name,text,order,isToggle,callback)local btn=Instance.new("TextButton",panel)btn.Name=name btn:SetAttribute("FearHubFloatingButton",true)btn:SetAttribute("FearThemeRole","FloatingButton")btn:SetAttribute("FearToggleOn",false)btn:SetAttribute("FearHubBaseWidth",BTN_W)btn:SetAttribute("FearHubBaseHeight",BTN_H)btn:SetAttribute("FearHubBaseCorner",10)btn:SetAttribute("FearHubBaseTextSize",10)btn.Size=UDim2.new(0,BTN_W,0,BTN_H)btn.BackgroundColor3=Color3.fromRGB(255,255,255)btn.BackgroundTransparency=0 btn.BorderSizePixel=0 btn.Text=""btn.AutoButtonColor=false btn.Active=true btn.Selectable=false btn.Modal=false btn.ZIndex=name=="Float"and 40 or 10 local savedPos=savedButtonPositions[name]if savedPos then if savedPos.Screen==true then btn.Position=UDim2.new(savedPos.XScale or 1,savedPos.X or anchorX,savedPos.YScale or 0,savedPos.Y or 0)else btn.Position=UDim2.new(1,anchorX+(savedPos.X or 0),0,savedPos.Y or 0)end else local defX,defY=getDefaultButtonPosition(name)btn.Position=UDim2.new(1,anchorX+defX,0,defY)end Instance.new("UICorner",btn).CornerRadius=UDim.new(0,14)local bgGrad=Instance.new("UIGradient",btn)bgGrad.Name="BtnGrad"bgGrad.Rotation=90 bgGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(46,46,52)),ColorSequenceKeypoint.new(0.45,Color3.fromRGB(23,23,27)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(6,6,8)),})local stroke=Instance.new("UIStroke",btn)stroke:SetAttribute("FearThemeRole","FloatingStroke")stroke.Color=Color3.fromRGB(120,120,128)stroke.Thickness=1 stroke.Transparency=0.55 stroke.Name="NormalStroke"local label=Instance.new("TextLabel",btn)label.Size=UDim2.new(1,0,1,0)label.BackgroundTransparency=1 label.Text=text label:SetAttribute("FearThemeRole","FloatingLabel")label.TextColor3=Color3.fromRGB(184,187,195)label.Font=Enum.Font.GothamBlack label.TextSize=10 label.TextWrapped=true label.ZIndex=name=="Float"and 41 or 11 local active=false local function setActive(state)active=state==true btn:SetAttribute("FearToggleOn",active)uiVisual.refreshTheme(btn)end local dragging=false local dragStart=nil local startPos=nil local activeInput=nil local startAbsPos=nil local startAbsSize=nil local movedDistance=0 local DRAG_THRESHOLD=5 local function pointInsideStartRect(pos)if not pos or not startAbsPos or not startAbsSize then return false end return pos.X>=startAbsPos.X and pos.X<=startAbsPos.X+startAbsSize.X and pos.Y>=startAbsPos.Y and pos.Y<=startAbsPos.Y+startAbsSize.Y end local function finishButtonGesture(input)if not dragging then return end if activeInput and input and input~=activeInput then return end local releasePos=(input and input.Position)or(activeInput and activeInput.Position)or dragStart local endedInOriginalButton=pointInsideStartRect(releasePos)local movedFar=movedDistance>=DRAG_THRESHOLD if movedFar and not uiLocked then savedButtonPositions[name]={Screen=true,XScale=btn.Position.X.Scale,X=btn.Position.X.Offset,YScale=btn.Position.Y.Scale,Y=btn.Position.Y.Offset}uiVisual.ensureFloatVisible()saveAllSettings()elseif endedInOriginalButton then if callback then local previousSuppress=_G.M4SuppressToggleSFX _G.M4SuppressToggleSFX=true local okCallback,callbackError=pcall(callback,setActive,active)_G.M4SuppressToggleSFX=previousSuppress if not okCallback then warn(callbackError)end end end dragging=false dragStart=nil startPos=nil activeInput=nil startAbsPos=nil startAbsSize=nil movedDistance=0 _isDraggingButton=false end btn.InputBegan:Connect(function(input)if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end if dragging then return end if not _fearGestureStartedInside(btn,input)then return end dragging=true movedDistance=0 dragStart=input.Position startPos=btn.Position startAbsPos=btn.AbsolutePosition startAbsSize=btn.AbsoluteSize activeInput=input _isDraggingButton=not uiLocked local thisInput=input local stateConn stateConn=thisInput.Changed:Connect(function()if thisInput.UserInputState==Enum.UserInputState.End or thisInput.UserInputState==Enum.UserInputState.Cancel then if stateConn then stateConn:Disconnect()stateConn=nil end if dragging and activeInput==thisInput then finishButtonGesture(thisInput)end end end)end)UIS.InputChanged:Connect(function(input)if not dragging or not dragStart or not startPos or not activeInput then return end local pos=nil if activeInput.UserInputType==Enum.UserInputType.Touch then if input.UserInputType~=Enum.UserInputType.Touch then return end pos=activeInput.Position if input.Position then pos=input.Position end elseif activeInput.UserInputType==Enum.UserInputType.MouseButton1 then if input.UserInputType~=Enum.UserInputType.MouseMovement then return end pos=input.Position else return end if not pos then return end local delta=pos-dragStart movedDistance=math.max(movedDistance,delta.Magnitude)if not uiLocked and movedDistance>=DRAG_THRESHOLD then btn.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)end end)UIS.InputEnded:Connect(function(input)if not dragging or not activeInput then return end if activeInput.UserInputType==Enum.UserInputType.Touch and input.UserInputType==Enum.UserInputType.Touch then finishButtonGesture(activeInput)elseif activeInput.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseButton1 then finishButtonGesture(activeInput)end end)buttons[name]={btn=btn,setActive=setActive,label=label}return setActive end for i,name in ipairs(buttonNames)do local text=buttonTexts[i]local callback if name=="DropBR"then callback=function(setActive)executeDropWithToggle(function(v)setActive(v)if dropBrainrotSetVisual then dropBrainrotSetVisual(v)end end)end elseif name=="AutoLeft"then callback=function(setActive)autoLeftEnabled=not autoLeftEnabled setActive(autoLeftEnabled)if autoLeftEnabled then startAutoLeft()else stopAutoLeft()end if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled)end saveAllSettings()end elseif name=="AutoBat"then callback=function(setActive)local desired=not autoBatEnabled setActive(desired)if desired then enableAutoBat()else disableAutoBat()end setActive(autoBatEnabled)saveAllSettings()end elseif name=="BatV2"then callback=function(setActive)if batV2Enabled then stopBatV2()else startBatV2()end setActive(batV2Enabled)saveAllSettings()end elseif name=="Float"then callback=function(setActive)_G.__BlessFloatToggle()setActive(_G.__BlessFloatIsRunning())saveAllSettings()end elseif name=="AutoRight"then callback=function(setActive)autoRightEnabled=not autoRightEnabled setActive(autoRightEnabled)if autoRightEnabled then startAutoRight()else stopAutoRight()end if autoRightSetVisual then autoRightSetVisual(autoRightEnabled)end saveAllSettings()end elseif name=="TpDown"then callback=function(setActive)setActive(true)runTPDown()task.delay(0.2,function()setActive(false)end)end elseif name=="TpBat"then callback=function(setActive)local desired=not bypassToggled setActive(desired)local actual=toggleBypass(desired)setActive(actual==true)saveAllSettings()end elseif name=="Reset"then callback=function(setActive)setActive(true)if setInstaResetVisual then setInstaResetVisual(true)end task.spawn(function()pcall(instaReset)end)task.delay(0.2,function()setActive(false)if setInstaResetVisual then setInstaResetVisual(false)end end)end elseif name=="Carry"then callback=function(setActive)toggleCarryMode()setActive(speedMode)saveAllSettings()end elseif name=="Lagger1"then callback=function(setActive)if speedMode then speedMode=false;if mobSetCarry then mobSetCarry(false)end end if not laggerToggled or laggerLevel~=1 then laggerToggled=true laggerLevel=1 setActive(true)if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false)end else laggerToggled=false laggerLevel=1 setActive(false)end refreshSpeedModeLabel()saveAllSettings()end elseif name=="Lagger2"then callback=function(setActive)if speedMode then speedMode=false;if mobSetCarry then mobSetCarry(false)end end if not laggerToggled or laggerLevel~=2 then laggerToggled=true laggerLevel=2 setActive(true)if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false)end else laggerToggled=false laggerLevel=1 setActive(false)end refreshSpeedModeLabel()saveAllSettings()end end mobSetAutoBat=buttons.AutoBat and buttons.AutoBat.setActive mobSetBatV2=buttons.BatV2 and buttons.BatV2.setActive mobSetAutoLeft=buttons.AutoLeft and buttons.AutoLeft.setActive mobSetAutoRight=buttons.AutoRight and buttons.AutoRight.setActive mobSetDropBR=buttons.DropBR and buttons.DropBR.setActive mobSetTpDown=buttons.TpDown and buttons.TpDown.setActive mobSetCarry=buttons.Carry and buttons.Carry.setActive mobSetLagger1=buttons.Lagger1 and buttons.Lagger1.setActive mobSetLagger2=buttons.Lagger2 and buttons.Lagger2.setActive mobSetTpBat=buttons.TpBat and buttons.TpBat.setActive mobSetReset=buttons.Reset and buttons.Reset.setActive local setActive=createButton(name,text,i-1,true,callback)if name=="AutoBat"then mobSetAutoBat=setActive end if name=="BatV2"then mobSetBatV2=setActive end if name=="AutoLeft"then mobSetAutoLeft=setActive end if name=="AutoRight"then mobSetAutoRight=setActive end if name=="DropBR"then mobSetDropBR=setActive end if name=="TpDown"then mobSetTpDown=setActive end if name=="Carry"then mobSetCarry=setActive end if name=="Lagger1"then mobSetLagger1=setActive end if name=="Lagger2"then mobSetLagger2=setActive end if name=="TpBat"then mobSetTpBat=setActive end if name=="Reset"then mobSetReset=setActive end if name=="Float"then mobSetFloat=setActive end end if buttons.Float then buttons.Float.setActive(_G.__BlessFloatIsRunning())end if buttons.AutoBat and buttons.AutoBat.setActive then buttons.AutoBat.setActive(autoBatEnabled)end if buttons.BatV2 and buttons.BatV2.setActive then buttons.BatV2.setActive(batV2Enabled)end if buttons.AutoLeft and buttons.AutoLeft.setActive then buttons.AutoLeft.setActive(autoLeftEnabled)end if buttons.AutoRight and buttons.AutoRight.setActive then buttons.AutoRight.setActive(autoRightEnabled)end if buttons.Carry and buttons.Carry.setActive then buttons.Carry.setActive(speedMode)end if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(laggerToggled and laggerLevel==1)end if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(laggerToggled and laggerLevel==2)end if buttons.TpBat and buttons.TpBat.setActive then buttons.TpBat.setActive(bypassToggled==true)end if buttons.Reset and buttons.Reset.setActive then buttons.Reset.setActive(false)end savedMobilePanelPos=nil local camera=workspace.CurrentCamera
if camera then
local viewportConn=camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()task.defer(uiVisual.ensureFloatVisible)end)
panel.Destroying:Connect(function()viewportConn:Disconnect()end)
end
task.defer(uiVisual.ensureFloatVisible)
return panel end function createBatV2FloatingButton()pcall(function()for _,parent in ipairs({game:GetService("CoreGui"),LP:FindFirstChild("PlayerGui")})do if parent then local old=parent:FindFirstChild("M4LWARE_BatV2_Button")if old then old:Destroy()end end end end)local panel=Instance.new("ScreenGui"); if _G.BlessIntro then _G.BlessIntro.Track(panel) end; panel.Name="M4LWARE_BatV2_Button"panel.ResetOnSpawn=false panel.IgnoreGuiInset=true panel.DisplayOrder=30 panel.ZIndexBehavior=Enum.ZIndexBehavior.Sibling pcall(function()if syn and syn.protect_gui then syn.protect_gui(panel)end end)if not pcall(function()panel.Parent=game:GetService("CoreGui")end)then panel.Parent=LP:WaitForChild("PlayerGui")end local btn=Instance.new("TextButton",panel)btn.Name="BatV2"btn:SetAttribute("FearHubFloatingButton",true)btn:SetAttribute("FearThemeRole","FloatingButton")btn:SetAttribute("FearToggleOn",batV2Enabled==true)btn:SetAttribute("FearHubBaseWidth",56)btn:SetAttribute("FearHubBaseHeight",56)btn:SetAttribute("FearHubBaseCorner",10)btn:SetAttribute("FearHubBaseTextSize",10)btn.Size=UDim2.new(0,56,0,56)local saved=savedButtonPositions.BatV2Float if saved and saved.Screen==true then btn.Position=UDim2.new(saved.XScale or 1,saved.X or-194,saved.YScale or 0,saved.Y or 68)else btn.Position=UDim2.new(1,-194,0,68)end btn.BackgroundColor3=Color3.fromRGB(255,255,255)btn.BackgroundTransparency=0 btn.BorderSizePixel=0 btn.Text=""btn.AutoButtonColor=false btn.Active=true btn.Selectable=false btn.Modal=false btn.ZIndex=100 Instance.new("UICorner",btn).CornerRadius=UDim.new(0,14)local grad=Instance.new("UIGradient",btn)grad.Name="BtnGrad"grad.Rotation=90 grad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(46,46,52)),ColorSequenceKeypoint.new(0.45,Color3.fromRGB(23,23,27)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(6,6,8))})local stroke=Instance.new("UIStroke",btn)stroke:SetAttribute("FearThemeRole","FloatingStroke")stroke.Color=Color3.fromRGB(120,120,128)stroke.Thickness=1 stroke.Transparency=0.55 local label=Instance.new("TextLabel",btn)label.Size=UDim2.fromScale(1,1)label.BackgroundTransparency=1 label.Text="BAT\nBYPASS"label:SetAttribute("FearThemeRole","FloatingLabel")label.TextColor3=Color3.fromRGB(184,187,195)label.Font=uiVisual.resolveFont(uiVisual.fontName)or Enum.Font.GothamBold label.TextSize=10 label.TextWrapped=true label.ZIndex=101 local function setActive(state)btn:SetAttribute("FearToggleOn",state==true)uiVisual.refreshTheme(btn)end mobSetBatV2=setActive setActive(batV2Enabled)local dragging=false local dragStart=nil local startPos=nil local moved=0 btn.InputBegan:Connect(function(input)if input.UserInputType~=Enum.UserInputType.Touch and input.UserInputType~=Enum.UserInputType.MouseButton1 then return end dragging=true dragStart=input.Position startPos=btn.Position moved=0 end)UIS.InputChanged:Connect(function(input)if not dragging or not dragStart or not startPos then return end if input.UserInputType~=Enum.UserInputType.Touch and input.UserInputType~=Enum.UserInputType.MouseMovement then return end local delta=input.Position-dragStart moved=math.max(moved,delta.Magnitude)if not uiLocked and moved>=5 then btn.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)end end)UIS.InputEnded:Connect(function(input)if not dragging then return end if input.UserInputType~=Enum.UserInputType.Touch and input.UserInputType~=Enum.UserInputType.MouseButton1 then return end dragging=false if moved>=5 and not uiLocked then savedButtonPositions.BatV2Float={Screen=true,XScale=btn.Position.X.Scale,X=btn.Position.X.Offset,YScale=btn.Position.Y.Scale,Y=btn.Position.Y.Offset}saveAllSettings()else local previousSuppress=_G.M4SuppressToggleSFX _G.M4SuppressToggleSFX=true local okToggle,toggleError=pcall(function()if batV2Enabled then stopBatV2()else startBatV2()end setActive(batV2Enabled)saveAllSettings()end)_G.M4SuppressToggleSFX=previousSuppress if not okToggle then warn(toggleError)end end dragStart=nil startPos=nil moved=0 end)uiVisual.decorate(panel)uiVisual.refreshTheme(panel)return panel end function createInstaResetFloatingButton()local ACCENT=Color3.fromRGB(198,202,210)local panel=Instance.new("ScreenGui"); if _G.BlessIntro then _G.BlessIntro.Track(panel) end; panel.Name="InstaResetButton"panel.ResetOnSpawn=false panel.ZIndexBehavior=Enum.ZIndexBehavior.Sibling panel.DisplayOrder=20 pcall(function()if syn and syn.protect_gui then syn.protect_gui(panel)end end)if not pcall(function()panel.Parent=game:GetService("CoreGui")end)then panel.Parent=LP:WaitForChild("PlayerGui")end local btnFrame=Instance.new("Frame",panel)btnFrame.Size=UDim2.new(0,60,0,60)btnFrame.Name="Frame"if instaResetFloatingPos then btnFrame.Position=UDim2.new(instaResetFloatingPos.XScale or 1,instaResetFloatingPos.XOffset or(-MOBILE_PANEL_WIDTH-10),instaResetFloatingPos.YScale or 0,instaResetFloatingPos.YOffset or(MOBILE_PANEL_HEIGHT+10))else btnFrame.Position=UDim2.new(1,-MOBILE_PANEL_WIDTH-10,0,MOBILE_PANEL_HEIGHT+10)end btnFrame.BackgroundColor3=Color3.fromRGB(255,255,255)btnFrame.BackgroundTransparency=0 btnFrame.BorderSizePixel=0 btnFrame.ZIndex=20 btnFrame:SetAttribute("FearThemeRole","FloatingButton")btnFrame:SetAttribute("FearToggleOn",false)Instance.new("UICorner",btnFrame).CornerRadius=UDim.new(0,14)local resetGrad=Instance.new("UIGradient",btnFrame)resetGrad.Name="BtnGrad"resetGrad.Rotation=90 resetGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(46,46,52)),ColorSequenceKeypoint.new(0.45,Color3.fromRGB(23,23,27)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(6,6,8)),})local resetStroke=Instance.new("UIStroke",btnFrame)resetStroke:SetAttribute("FearThemeRole","FloatingStroke")resetStroke.Color=Color3.fromRGB(120,120,128)resetStroke.Thickness=1 resetStroke.Transparency=0.55 local label=Instance.new("TextLabel",btnFrame)label.Size=UDim2.new(1,0,1,0)label.BackgroundTransparency=1 label.Text="RESET"label:SetAttribute("FearThemeRole","FloatingLabel")label.TextColor3=Color3.fromRGB(184,187,195)label.Font=Enum.Font.GothamBlack label.TextSize=12 label.TextWrapped=true label.ZIndex=21 local function setActive(state)btnFrame:SetAttribute("FearToggleOn",state==true)uiVisual.refreshTheme(btnFrame)end uiVisual.refreshTheme(btnFrame)local dragging=false;local hasMoved=false;local dragStart,startPos btnFrame.InputBegan:Connect(function(inp)if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then if not _fearGestureStartedInside(btnFrame,inp)then return end dragging=true;hasMoved=false;dragStart=inp.Position;startPos=btnFrame.Position end end)btnFrame.InputChanged:Connect(function(inp)if not dragging then return end if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then local delta=inp.Position-dragStart if delta.Magnitude>=5 then hasMoved=true end if hasMoved and not uiLocked then btnFrame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)end end end)btnFrame.InputEnded:Connect(function(inp)if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then if dragging then local releasePos=inp.Position local absPos=btnFrame.AbsolutePosition local absSize=btnFrame.AbsoluteSize local endedInside=releasePos.X>=absPos.X and releasePos.X<=absPos.X+absSize.X and releasePos.Y>=absPos.Y and releasePos.Y<=absPos.Y+absSize.Y if(not hasMoved or uiLocked)and endedInside then setActive(true)instaReset()if setInstaResetVisual then setInstaResetVisual(true)end task.delay(0.2,function()if setInstaResetVisual then setInstaResetVisual(false)end setActive(false)end)elseif not uiLocked and hasMoved then instaResetFloatingPos={XScale=btnFrame.Position.X.Scale,XOffset=btnFrame.Position.X.Offset,YScale=btnFrame.Position.Y.Scale,YOffset=btnFrame.Position.Y.Offset}end dragging=false;hasMoved=false task.defer(saveAllSettings)end end end)return panel end function createBypassFloatingButton()local ACCENT=Color3.fromRGB(198,202,210)local panel=Instance.new("ScreenGui"); if _G.BlessIntro then _G.BlessIntro.Track(panel) end; panel.Name="BypassButton"panel.ResetOnSpawn=false panel.ZIndexBehavior=Enum.ZIndexBehavior.Sibling panel.DisplayOrder=21 pcall(function()if syn and syn.protect_gui then syn.protect_gui(panel)end end)if not pcall(function()panel.Parent=game:GetService("CoreGui")end)then panel.Parent=LP:WaitForChild("PlayerGui")end local btnFrame=Instance.new("Frame",panel)btnFrame.Size=UDim2.new(0,60,0,60)btnFrame.Name="Frame"if bypassFloatingPos then btnFrame.Position=UDim2.new(bypassFloatingPos.XScale or 1,bypassFloatingPos.XOffset or(-10-60),bypassFloatingPos.YScale or 0,bypassFloatingPos.YOffset or(MOBILE_PANEL_HEIGHT+10))else btnFrame.Position=UDim2.new(1,-10-60,0,MOBILE_PANEL_HEIGHT+10)end btnFrame.BackgroundColor3=Color3.fromRGB(255,255,255)btnFrame.BackgroundTransparency=0 btnFrame.BorderSizePixel=0 btnFrame.ZIndex=20 btnFrame:SetAttribute("FearThemeRole","FloatingButton")btnFrame:SetAttribute("FearToggleOn",bypassToggled==true)Instance.new("UICorner",btnFrame).CornerRadius=UDim.new(0,14)local bypassGrad=Instance.new("UIGradient",btnFrame)bypassGrad.Name="BtnGrad"bypassGrad.Rotation=90 bypassGrad.Color=ColorSequence.new({ColorSequenceKeypoint.new(0.00,Color3.fromRGB(46,46,52)),ColorSequenceKeypoint.new(0.45,Color3.fromRGB(23,23,27)),ColorSequenceKeypoint.new(1.00,Color3.fromRGB(6,6,8)),})local bypassStroke=Instance.new("UIStroke",btnFrame)bypassStroke:SetAttribute("FearThemeRole","FloatingStroke")bypassStroke.Color=Color3.fromRGB(120,120,128)bypassStroke.Thickness=1 bypassStroke.Transparency=0.55 local label=Instance.new("TextLabel",btnFrame)label.Size=UDim2.new(1,0,1,0)label.BackgroundTransparency=1 label.Text="TP\nBAT"label:SetAttribute("FearThemeRole","FloatingLabel")label.TextColor3=Color3.fromRGB(184,187,195)label.Font=Enum.Font.GothamBlack label.TextSize=11 label.TextWrapped=true label.ZIndex=21 local function setActive(state)btnFrame:SetAttribute("FearToggleOn",state==true)uiVisual.refreshTheme(btnFrame)end uiVisual.refreshTheme(btnFrame)local dragging=false;local hasMoved=false;local dragStart,startPos btnFrame.InputBegan:Connect(function(inp)if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then if not _fearGestureStartedInside(btnFrame,inp)then return end dragging=true;hasMoved=false;dragStart=inp.Position;startPos=btnFrame.Position end end)btnFrame.InputChanged:Connect(function(inp)if not dragging then return end if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then local delta=inp.Position-dragStart if delta.Magnitude>=5 then hasMoved=true end if hasMoved and not uiLocked then btnFrame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)end end end)btnFrame.InputEnded:Connect(function(inp)if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then if dragging then local releasePos=inp.Position local absPos=btnFrame.AbsolutePosition local absSize=btnFrame.AbsoluteSize local endedInside=releasePos.X>=absPos.X and releasePos.X<=absPos.X+absSize.X and releasePos.Y>=absPos.Y and releasePos.Y<=absPos.Y+absSize.Y if(not hasMoved or uiLocked)and endedInside then setActive(not bypassToggled)toggleBypass()elseif not uiLocked and hasMoved then bypassFloatingPos={XScale=btnFrame.Position.X.Scale,XOffset=btnFrame.Position.X.Offset,YScale=btnFrame.Position.Y.Scale,YOffset=btnFrame.Position.Y.Offset}end dragging=false;hasMoved=false task.defer(saveAllSettings)end end end)bypassFloatingButton=panel return panel end function reapplyAllStates()if _G.__BlessAutoSpin then _G.__BlessAutoSpin.SetEnabled(_G.BlessAutoSpinEnabled)end local function apply(label,fn)local ok,err=pcall(fn)if not ok then warn("[FearHub] "..label..": "..tostring(err))end end if mikuSkyEnabled and mikuSkyThread then else apply("Sky",function()setSkyTheme(currentSkyTheme)end)if mikuSkyEnabled then apply("Miku sky",startMikuSky)end end   if ragdollCountdownEnabled then apply("Ragdoll Countdown",function()setRagdollCountdown(true)end)end if antiRagdollEnabled then apply("Anti Ragdoll",function()setAntiRag(true)end)end if antiDieEnabled then apply("Anti Die",startAntiDie)end if jumpEnabled then apply("Infinite Jump",startJumpMode)end if bodyLockEnabled then apply("Body Lock",startBodyLock)end if autoTPDownEnabled then apply("Auto TP Down",startAutoTPDown)end if medusaCounterEnabled then apply("Medusa",function()setMedusaCounterState(true)end)end if batCounterEnabled then apply("Bat Counter",startBatCounter)end if espEnabled then apply("ESP",function()toggleESP(true)end)end if stretchEnabled then apply("Stretch",enableStretch)end if CONFIG.AUTO_STEAL_ENABLED then apply("Auto Steal",startAutoStealSemi)end if _G.M4AutoSpeedEnabled and _G.M4AutoSpeedStart then apply("Auto Speed",_G.M4AutoSpeedStart)end if currentAnimPack~="Off"then apply("Animation",function()startAnimPack(currentAnimPack)end)end if antiLagEnabled then apply("Anti Lag",enableAntiLag)end apply("120 FPS Mode",function()uiVisual.setPerformance120(uiVisual.performanceMode)end)if _G.M4ShinyEnabled and _G.M4StartShiny then apply("Shiny Mode",_G.M4StartShiny)end if bypassToggled then apply("TP Bat",function()toggleBypass(true)end)elseif autoLeftEnabled then apply("Auto Left",startAutoLeft)elseif autoRightEnabled then apply("Auto Right",startAutoRight)elseif batV2Enabled then apply("Bat Bypass",startBatV2)elseif autoBatEnabled then apply("Auto Bat",enableAutoBat)end updateUIFromLoaded()end 
function updateUIFromLoaded()if _G.__BlessAutoSpin and _G.__BlessAutoSpin.setVisual then _G.__BlessAutoSpin.setVisual(_G.BlessAutoSpinEnabled==true)end if uiVisual.hideBackgroundsVisual then uiVisual.hideBackgroundsVisual(uiVisual.hideBackgrounds==true)end if dropModeBtnRef then dropModeBtnRef.Text="Bubble" end  
    uiVisual.refreshBatV2Engine()
    uiVisual.syncBatV2Speed()
    if batV2SpeedBox then batV2SpeedBox.Text = tostring(BAT_V2_SPEED) end
    if batV2SetVisual then batV2SetVisual(batV2Enabled) end
if normalBox then normalBox.Text=tostring(NS)end if carryBox then carryBox.Text=tostring(CS)end if normalSpeedSetVisual then normalSpeedSetVisual(true)end if radInput then radInput.Text=tostring(CONFIG.STEAL_RANGE)end if semiRadInput then semiRadInput.Text=tostring(Steal.SemiRadius)end if uiVisual.stealBarFPSBox then uiVisual.stealBarFPSBox.Text=tostring(uiVisual.stealBarFPS)end if _G.M4RefreshStealModeOptions then pcall(_G.M4RefreshStealModeOptions)end if laggerBox then laggerBox.Text=tostring(LAGGER_SPEED_1)end if lagger2Box then lagger2Box.Text=tostring(LAGGER_SPEED_2)end if autoTPHeightBox then autoTPHeightBox.Text=tostring(autoTPDownHeight)end if uiScaleBox then uiScaleBox.Text=tostring(uiScaleValue)end if _G.__SureApplyResponsiveMainScale then _G.__SureApplyResponsiveMainScale()elseif mainUIScale then mainUIScale.Scale=uiScaleValue/100 end refreshStealBarScale()if _G.uiScaleValueLabel then _G.uiScaleValueLabel.Text=string.format("%.2f",uiScaleValue/100)end if _G.stealBarScaleValueLabel then _G.stealBarScaleValueLabel.Text=string.format("%.2f",stealBarScaleValue/100)end if _G.buttonScaleValueLabel then _G.buttonScaleValueLabel.Text=string.format("%.2f",buttonScaleValue)end applyButtonScale(buttonScaleValue)if bodyLockRangeBox then bodyLockRangeBox.Text=tostring(bodyLockRange)end if _G.FearGoodAimbotSpeedBox then _G.FearGoodAimbotSpeedBox.Text=tostring(BAT_AIMBOT_SPEED)end if _G.FearGoodAimbotState then _G.FearGoodAimbotState.speed=BAT_AIMBOT_SPEED end local function visual(fn,value)if fn then fn(value)end end visual(autoLeftSetVisual,autoLeftEnabled)visual(autoRightSetVisual,autoRightEnabled)visual(autoBatSetVisual,autoBatEnabled)aimbotMode="old"visual(bypassSetVisual,bypassToggled)visual(setLockUIVisual,uiLocked)visual(uiVisual.hideButtonsVisual,uiVisual.hideButtons)visual(uiVisual.tronTrailVisual,uiVisual.tronTrailEnabled)uiVisual.applyHideButtons()editModeEnabled=false visual(setAntiRagVisual,antiRagdollEnabled)visual(setRagdollCountdownVisual,ragdollCountdownEnabled)visual(setAntiDieVisual,antiDieEnabled)visual(mikuSkySetVisual,mikuSkyEnabled)visual(setInstaGrab,CONFIG.AUTO_STEAL_ENABLED)visual(setJumpVisual,jumpEnabled)visual(setMedusaVisual,medusaCounterEnabled)visual(setBatCounterVisual,batCounterEnabled)visual(setAutoTPDownVisual,autoTPDownEnabled)visual(_G.FearMirrorTPDownVisual,_G.FearMirrorTPDownEnabled==true)visual(setInstaResetVisual,false)visual(setAntiLagVisual,antiLagEnabled)visual(_G.M4ShinySetVisual,_G.M4ShinyEnabled==true)visual(setESPVIsual,espEnabled)visual(_G.stretchToggleSetter,stretchEnabled)visual(bodyLockSetVisual,bodyLockEnabled and _blSuppressCount==0)visual(batSkinSetVisual,_G.FearCosmetics and _G.FearCosmetics.BatEnabled==true)visual(medSkinSetVisual,_G.FearCosmetics and _G.FearCosmetics.MedEnabled==true)visual(mobSetAutoBat,autoBatEnabled)visual(mobSetBatV2,batV2Enabled)visual(mobSetAutoLeft,autoLeftEnabled)visual(mobSetAutoRight,autoRightEnabled)visual(mobSetCarry,speedMode)visual(mobSetLagger1,laggerToggled and laggerLevel==1)visual(mobSetLagger2,laggerToggled and laggerLevel==2)for _,ref in ipairs(keyButtonRefs)do ref.btn.Text=(ref.entry.gp and ref.entry.gp.Name)or(ref.entry.kb and ref.entry.kb.Name)or"None"end if uiVisual.refreshSkins then uiVisual.refreshSkins()end if uiVisual.refreshSliders then uiVisual.refreshSliders()end if uiVisual.refreshBackground then uiVisual.refreshBackground(false)end if uiVisual.refreshNameLogo then uiVisual.refreshNameLogo()end if uiVisual.applyFont then uiVisual.applyFont(uiVisual.fontName,false)end if animSelectorLabel then animSelectorLabel.Text=currentAnimPack end if skySelectorLabel then skySelectorLabel.Text=currentSkyTheme end resetMovementState()updateProgressBarVisibility() end
 local function createNameTag()return end _isLoading=true local startupLoadOK=loadAllSettings()buildGui()pcall(function()for _,parent in ipairs({game:GetService("CoreGui"),LP:FindFirstChild("PlayerGui")})do if parent then local oldReset=parent:FindFirstChild("InstaResetButton")if oldReset then oldReset:Destroy()end local oldBypass=parent:FindFirstChild("BypassButton")if oldBypass then oldBypass:Destroy()end end end end)MobilePanel=createMobilePanel()batV2FloatingButton=createBatV2FloatingButton()uiVisual.registerFloatingGui(MobilePanel)uiVisual.registerFloatingGui(batV2FloatingButton)uiVisual.applyHideButtons()instaResetFloatingButton=nil bypassFloatingButton=nil uiVisual.decorate(MobilePanel)uiVisual.refreshTheme(MobilePanel)pcall(function()applyButtonShape(buttonShapeMode)end)pcall(function()local page=_G.VeoraSettingsPage if not page or not page.Parent then return end local oldRow=page:FindFirstChild("VeoraButtonShapeRow")if oldRow then oldRow:Destroy()end local row=Instance.new("Frame",page)row.Name="VeoraButtonShapeRow"row.Size=UDim2.new(1,0,0,42)row.BackgroundColor3=Color3.fromRGB(15,15,18)row.BackgroundTransparency=0.16 row.BorderSizePixel=0 row.LayoutOrder=9990 row.ZIndex=7 Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)local rowStroke=Instance.new("UIStroke",row)rowStroke.Color=Color3.fromRGB(80,82,90)rowStroke.Thickness=1 rowStroke.Transparency=0.45 local label=Instance.new("TextLabel",row)label.Size=UDim2.new(0.46,0,1,0)label.Position=UDim2.new(0,10,0,0)label.BackgroundTransparency=1 label.Text="Button Shape"label.TextColor3=Color3.fromRGB(235,236,240)label.Font=Enum.Font.GothamBold label.TextSize=11 label.TextXAlignment=Enum.TextXAlignment.Left label.ZIndex=8 local holder=Instance.new("Frame",row)holder.Size=UDim2.new(0,142,0,26)holder.Position=UDim2.new(1,-150,0.5,-13)holder.BackgroundTransparency=1 holder.ZIndex=8 local buttons={}local function refreshShapeButtons()for index,shapeButton in ipairs(buttons)do local selected=buttonShapeMode==index shapeButton:SetAttribute("FearSelected",selected)shapeButton.BackgroundColor3=selected and Color3.fromRGB(172,172,172)or Color3.fromRGB(12,12,14)shapeButton.TextColor3=selected and Color3.fromRGB(12,12,12)or Color3.fromRGB(178,181,190)local shapeStroke=shapeButton:FindFirstChildOfClass("UIStroke")if shapeStroke then shapeStroke.Color=selected and uiVisual.getThemeAccent()or Color3.fromRGB(70,72,80)shapeStroke.Transparency=selected and 0.12 or 0.42 end end end _G.VeoraShapeRefresh=refreshShapeButtons for index=1,2 do local shapeIndex=index local shapeButton=Instance.new("TextButton",holder)shapeButton.Name="Shape"..tostring(shapeIndex)shapeButton.Size=UDim2.new(0,68,1,0)shapeButton.Position=UDim2.new(0,(shapeIndex-1)*74,0,0)shapeButton.BackgroundColor3=Color3.fromRGB(12,12,14)shapeButton.BorderSizePixel=0 shapeButton.AutoButtonColor=false shapeButton.Text="SHAPE "..tostring(shapeIndex)shapeButton.TextColor3=Color3.fromRGB(178,181,190)shapeButton.Font=Enum.Font.GothamBlack shapeButton.TextSize=8 shapeButton.ZIndex=9 Instance.new("UICorner",shapeButton).CornerRadius=UDim.new(0,7)local shapeStroke=Instance.new("UIStroke",shapeButton)shapeStroke.Thickness=1 shapeStroke.Transparency=0.42 buttons[shapeIndex]=shapeButton shapeButton.Activated:Connect(function()if buttonShapeMode~=shapeIndex then applyButtonShape(shapeIndex)task.defer(saveAllSettings)if _G.M4ToggleSFXPlay then task.defer(_G.M4ToggleSFXPlay)end end end)end refreshShapeButtons()end)local function restoreCharacter(char)if not char then return end local root=char:WaitForChild("HumanoidRootPart",10)local hum=char:WaitForChild("Humanoid",10)if not root or not hum or LP.Character~=char then return end setupMovementAndIndicators(char)createNameTag()reapplyAllStates()end LP.CharacterAdded:Connect(function(char)local snapshot=buildConfigTable()_isLoading=true local ok,err=pcall(function()stopAutoSteal()stopAutoLeft()stopAutoRight()stopBatCounter()stopMedusaCounter()stopDropBrainrot()if batV2Enabled then stopBatV2()elseif autoBatEnabled then disableAutoBat()end if bypassToggled then stopBypassAimbot()end _G.KillHub.OriginalOutfit={shirt=nil,pants=nil}_G.KillHub.OriginalAccessories={}originalTryardAnims=nil unwalkSavedAnimate=nil applyConfig(snapshot)restoreCharacter(char)end)_isLoading=false if not ok then warn("[FearHub] Respawn: "..tostring(err))end saveAllSettings()end)if _G.M4DeathSFXHealthConn then pcall(function()_G.M4DeathSFXHealthConn:Disconnect()end)end if _G.M4DeathSFXDiedConn then pcall(function()_G.M4DeathSFXDiedConn:Disconnect()end)end if _G.M4DeathMuteConn then pcall(function()_G.M4DeathMuteConn:Disconnect()end)end if _G.M4DeathSFXCharConn then pcall(function()_G.M4DeathSFXCharConn:Disconnect()end)end _G.M4DeathSFXHealthConn=nil _G.M4DeathSFXDiedConn=nil _G.M4DeathMuteConn=nil _G.M4DeathSFXCharConn=nil _G.M4BindDeathSFX=function()return end _G.M4PlayExtraSFX=function()return false end if LP.Character then restoreCharacter(LP.Character)else updateUIFromLoaded()end _isLoading=false settingsReady=true uiVisual.setTronTrail(uiVisual.tronTrailEnabled,false)uiVisual.applyHideButtons()if startupLoadOK and startupConfigLoaded then if startupConfigSource=="backup"then _lastSavedJSON=nil saveAllSettings()end end lastLaggerToggle=0 LAGGER_COOLDOWN=0.3 _G.M4LWARE_RunKeybind=function(kc)if not kc or kc==Enum.KeyCode.Unknown then return end if kbMatch(KB.LaggerMode,kc)then if tick()-lastLaggerToggle>=LAGGER_COOLDOWN then lastLaggerToggle=tick()toggleLaggerCycle()saveAllSettings()end return end if kbMatch(KB.CarryToggle,kc)then toggleCarryMode();saveAllSettings();return end if kbMatch(KB.DropBrainrot,kc)then if not dropActive then if dropBrainrotSetVisual then dropBrainrotSetVisual(true)end executeDropWithToggle(dropBrainrotSetVisual)end return end if kbMatch(KB.TPFloor,kc)then runTPDown();return end if kbMatch(KB.InstaReset,kc)then instaReset();return end if kbMatch(KB.AutoLeft,kc)then autoLeftEnabled=not autoLeftEnabled if autoLeftEnabled then startAutoLeft()else stopAutoLeft()end if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled)end if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled)end saveAllSettings()return end if kbMatch(KB.AutoRight,kc)then autoRightEnabled=not autoRightEnabled if autoRightEnabled then startAutoRight()else stopAutoRight()end if autoRightSetVisual then autoRightSetVisual(autoRightEnabled)end if mobSetAutoRight then mobSetAutoRight(autoRightEnabled)end saveAllSettings()return end if kbMatch(KB.AutoBat,kc)then if not autoBatEnabled then enableAutoBat()if autoBatSetVisual then autoBatSetVisual(true)end if mobSetAutoBat then mobSetAutoBat(true)end else disableAutoBat()if autoBatSetVisual then autoBatSetVisual(false)end if mobSetAutoBat then mobSetAutoBat(false)end end saveAllSettings()return end if kbMatch(KB.BatV2,kc)then if batV2Enabled then stopBatV2()else startBatV2()end saveAllSettings()return end if kbMatch(KB.Bypass,kc)then toggleBypass();saveAllSettings();return end if kbMatch(KB.Float,kc)then _G.__BlessFloatToggle();saveAllSettings();return end end _G.M4LWARE_TriggerHeld=_G.M4LWARE_TriggerHeld or{}UIS.InputEnded:Connect(function(input)uiVisual.releaseMoreButton(input)end)UIS.InputBegan:Connect(function(input,gpe)if uiVisual.moreButtons and isGamepadInput(input)and uiVisual.isMoreButton(input.KeyCode)then uiVisual.handleMoreButton(input)return end if _anyKeyListening then return end if input.UserInputType==Enum.UserInputType.Keyboard then if gpe or UIS:GetFocusedTextBox()then return end elseif not isGamepadInput(input)then return end if not isBindableInput(input)then return end if input.KeyCode==Enum.KeyCode.ButtonL2 or input.KeyCode==Enum.KeyCode.ButtonR2 then _G.M4LWARE_TriggerHeld[input.KeyCode.Name]=true end _G.M4LWARE_RunKeybind(input.KeyCode)end)UIS.InputChanged:Connect(function(input)if _anyKeyListening or not isGamepadInput(input)then return end if input.KeyCode~=Enum.KeyCode.ButtonL2 and input.KeyCode~=Enum.KeyCode.ButtonR2 then return end local z=input.Position.Z local name=input.KeyCode.Name if z>=0.45 then if not _G.M4LWARE_TriggerHeld[name]then _G.M4LWARE_TriggerHeld[name]=true _G.M4LWARE_RunKeybind(input.KeyCode)end elseif z<=0.15 then _G.M4LWARE_TriggerHeld[name]=false end end)UIS.InputEnded:Connect(function(input)if input.KeyCode==Enum.KeyCode.ButtonL2 or input.KeyCode==Enum.KeyCode.ButtonR2 then _G.M4LWARE_TriggerHeld[input.KeyCode.Name]=false end end)task.spawn(function()while task.wait(30)do pcall(function()collectgarbage("collect")if#_G.KillHub.Connections>0 then for k,v in pairs(_G.KillHub.Connections)do if type(v)=="table"and#v==0 then _G.KillHub.Connections[k]=nil end end end if#enemySpeedLabels>30 then for player in pairs(enemySpeedLabels)do if not player or not player.Character then enemySpeedLabels[player]=nil end end end end)end end)task.spawn(function()while task.wait(5)do saveAllSettings()end end)