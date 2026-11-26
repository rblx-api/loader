---- VISIBLE HUB

if _G.VisibleHubRunning then
    warn("[Visible] Instancia previa detectada. Se recomienda rejoin si hay comportamiento errático.")
end
_G.VisibleHubRunning = false
-- Paleta estilo Ace Duels (gris pizarra, sin tonos morados)
_G.__VisibleAce = {
    card = Color3.fromRGB(13, 16, 20), hover = Color3.fromRGB(22, 25, 30),
    line = Color3.fromRGB(48, 55, 65), dim = Color3.fromRGB(138, 142, 148),
    accent = Color3.fromRGB(104, 116, 132), active = Color3.fromRGB(132, 144, 160),
    pale = Color3.fromRGB(210, 218, 228), tab = Color3.fromRGB(8, 10, 13),
    gradTop = Color3.fromRGB(16, 19, 23), gradBottom = Color3.fromRGB(11, 13, 17),
    control = Color3.fromRGB(18, 21, 26), text = Color3.fromRGB(238, 238, 238),
    panel = Color3.fromRGB(5, 6, 8),
}
_G.__VisibleHubMainOriginalPos = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LP = Players.LocalPlayer
if not LP then
    local _lpConn
    _lpConn = Players.PlayerAdded:Connect(function(p) LP = p end)
    local _t0 = tick()
    while not LP and tick() - _t0 < 15 do task.wait(0.1) end
    if _lpConn then _lpConn:Disconnect() end
end
if not LP then
    warn("[Visible] LocalPlayer no disponible en 15s. Abortando.")
    return
end

local pgui = LP:WaitForChild("PlayerGui", 20)
if not pgui then
    warn("[Visible] PlayerGui no cargó en 20s. Abortando.")
    return
end

local camera = Workspace.CurrentCamera

local SoundService = game:GetService("SoundService")

local mvpFullRedrumSound = nil
local mvpMusicRequest = 0
local mvpMusicRefreshers = {}

local function stopMVPFullRedrum()
    mvpMusicRequest = mvpMusicRequest + 1
    if mvpFullRedrumSound then
        pcall(function() mvpFullRedrumSound:Stop() end)
        pcall(function() mvpFullRedrumSound:Destroy() end)
        mvpFullRedrumSound = nil
    end
end


_G.VisibleHubRunning = true
_G.VisibleHubSession = (_G.VisibleHubSession or 0) + 1
local _mySession = _G.VisibleHubSession

-- ===== VISIBLE STYLE: panel normal (bordes blancos) + tema NAVIDAD + intro de Santa =====
-- (solo apariencia; no toca la lógica de los botones)
_G.VisibleXmasEnabled = false

do
    local TSv = game:GetService("TweenService")
    local RSv = game:GetService("RunService")
    local WHITE = Color3.fromRGB(255, 255, 255)
    local BLACK = Color3.fromRGB(0, 0, 0)
    local RED = Color3.fromRGB(214, 40, 57)

    local BULBS = {
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(34, 170, 90), Color3.fromRGB(130, 80, 40),
        Color3.fromRGB(230, 40, 50), Color3.fromRGB(255, 205, 60), Color3.fromRGB(95, 105, 115),
        Color3.fromRGB(90, 225, 120), Color3.fromRGB(255, 120, 205), Color3.fromRGB(135, 135, 140),
    }

    -- rayas tipo bastón de caramelo (rojo / blanco)
    local candyPoints = {}
    local STRIPES = 8
    for i = 0, STRIPES - 1 do
        local c = (i % 2 == 0) and RED or WHITE
        local t0 = i / STRIPES + (i > 0 and 0.002 or 0)
        local t1 = (i + 1) / STRIPES - (i < STRIPES - 1 and 0.002 or 0)
        table.insert(candyPoints, ColorSequenceKeypoint.new(t0, c))
        table.insert(candyPoints, ColorSequenceKeypoint.new(t1, c))
    end
    local CANDY = ColorSequence.new(candyPoints)

    local STATE = setmetatable({}, {__mode = "k"})

    local function round(o, px)
        local c = Instance.new("UICorner")
        c.CornerRadius = px and UDim.new(0, px) or UDim.new(0.5, 0)
        c.Parent = o
        return c
    end

    local function box(parent, size, pos, color, z, px)
        local f = Instance.new("Frame")
        f.Size = size; f.Position = pos
        f.BackgroundColor3 = color
        f.BorderSizePixel = 0
        f.ZIndex = z or 12
        f.Parent = parent
        if px ~= nil then round(f, px ~= 0 and px or nil) end
        return f
    end

    local BULB_POS = {
        {0.50, 0.00}, {0.88, 0.12}, {1.00, 0.50}, {0.88, 0.88},
        {0.50, 1.00}, {0.12, 0.88}, {0.00, 0.50}, {0.12, 0.12},
    }

    local function decorate(btn)
        if not btn or STATE[btn] then return STATE[btn] end
        local st = {bulbs = {}, shift = math.random(0, #BULBS - 1)}
        STATE[btn] = st

        -- borde principal
        local stroke = Instance.new("UIStroke")
        stroke.Name = "VisibleStroke"
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Color = WHITE
        stroke.Thickness = 1.5
        stroke.Transparency = 0.55
        stroke.Parent = btn
        local grad = Instance.new("UIGradient")
        grad.Name = "CandyGrad"
        grad.Color = CANDY
        grad.Enabled = false
        grad.Parent = stroke
        st.stroke, st.grad = stroke, grad

        -- resplandor (solo activo)
        local glow = Instance.new("Frame")
        glow.Name = "VisibleGlow"
        glow.AnchorPoint = Vector2.new(0.5, 0.5)
        glow.Position = UDim2.fromScale(0.5, 0.5)
        glow.Size = UDim2.new(1, 8, 1, 8)
        glow.BackgroundTransparency = 1
        glow.BorderSizePixel = 0
        glow.ZIndex = 9
        glow.Visible = false
        glow.Parent = btn
        round(glow, 14)
        local gs = Instance.new("UIStroke")
        gs.Color = WHITE; gs.Thickness = 3.2; gs.Transparency = 0.25
        gs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        gs.Parent = glow
        st.glow, st.glowStroke = glow, gs

        -- decoración navideña
        local deco = Instance.new("Frame")
        deco.Name = "XmasDeco"
        deco.Size = UDim2.fromScale(1, 1)
        deco.BackgroundTransparency = 1
        deco.ZIndex = 12
        deco.Visible = false
        deco.Parent = btn
        st.deco = deco

        for i, p in ipairs(BULB_POS) do
            local b = Instance.new("Frame")
            b.Name = "Bulb" .. i
            b.AnchorPoint = Vector2.new(0.5, 0.5)
            b.Size = UDim2.fromOffset(9, 9)
            b.Position = UDim2.fromScale(p[1], p[2])
            b.BackgroundColor3 = BULBS[((i + st.shift) % #BULBS) + 1]
            b.BorderSizePixel = 0
            b.ZIndex = 13
            b.Parent = deco
            round(b)
            local bs = Instance.new("UIStroke")
            bs.Color = Color3.fromRGB(40, 40, 45); bs.Thickness = 1; bs.Transparency = 0.2
            bs.Parent = b
            st.bulbs[i] = b
        end

        return st
    end

    local function style(btn, active)
        if not btn or not btn.Parent then return end
        local st = STATE[btn] or decorate(btn)
        local spec = visibleBtnStyleSpec()
        local corner = btn:FindFirstChildOfClass("UICorner")
        if corner then corner.CornerRadius = UDim.new(0, spec.radius) end
        btn.BackgroundTransparency = spec.trans
        btn.BackgroundColor3 = (active or spec.alwaysGrad) and spec.onBg or Color3.fromRGB(0, 0, 0)
        local g = btn:FindFirstChild("BtnGrad")
        if g then
            g.Rotation = 90
            if spec.alwaysGrad and not active then
                g.Color = ColorSequence.new(spec.offTop, spec.offBot)
            else
                g.Color = ColorSequence.new(spec.onTop, spec.onBot)
            end
            g.Enabled = (active == true) or spec.alwaysGrad == true
        end
        -- brillo superior (solo estilo negro brillante)
        local gloss = btn:FindFirstChild("BtnGloss")
        if spec.gloss and not gloss then
            gloss = Instance.new("Frame")
            gloss.Name = "BtnGloss"
            gloss.Position = UDim2.fromOffset(3, 2)
            gloss.Size = UDim2.new(1, -6, 0.48, 0)
            gloss.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            gloss.BorderSizePixel = 0
            gloss.ZIndex = 10
            gloss.Active = false
            gloss.Parent = btn
            local gc = Instance.new("UICorner"); gc.CornerRadius = UDim.new(0, math.max(spec.radius - 3, 2)); gc.Parent = gloss
            local gg = Instance.new("UIGradient"); gg.Rotation = 90
            gg.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.72), NumberSequenceKeypoint.new(1, 1)})
            gg.Parent = gloss
        end
        if gloss then
            gloss.Visible = (spec.gloss == true) and (active == true or not spec.glossOnlyOn)
            local gcr = gloss:FindFirstChildOfClass("UICorner")
            if gcr then gcr.CornerRadius = UDim.new(0, math.max(spec.radius - 3, 2)) end
        end
        local tint = btn:FindFirstChild("ActiveTint")
        if tint then tint.BackgroundTransparency = 1 end
        local bgImg = btn:FindFirstChild("StealBgImage")
        if bgImg then bgImg.ImageTransparency = 1 end
        local txtCol = active and (spec.txtOn or Color3.fromRGB(14, 14, 16)) or (spec.txtOff or Color3.fromRGB(150, 150, 156))
        local label = btn:FindFirstChild("TextLabel")
        if label then
            label.TextColor3 = txtCol
            label.TextSize = spec.txtSize or 10
            if spec.font then label.Font = spec.font; label.TextWrapped = true; label.TextStrokeTransparency = 1 end
            if btn.Name == "AutoLeft" or btn.Name == "AutoRight" then
                if spec.noGlyph then
                    label.Position = UDim2.fromOffset(4, 0); label.Size = UDim2.new(1, -8, 1, 0)
                else
                    label.Position = UDim2.fromOffset(4, 20); label.Size = UDim2.new(1, -8, 1, -24)
                end
            end
        end
        local glyph = btn:FindFirstChild("Glyph")
        if glyph then glyph.TextColor3 = txtCol; glyph.Visible = not spec.noGlyph end
        local status = btn:FindFirstChild("Status")
        if status then
            status.TextColor3 = txtCol
            status.Text = active and "ON" or "OFF"
        end
        st.deco.Visible = false
        st.grad.Enabled = false
        st.stroke.Color = active and spec.onStroke or spec.offStroke
        st.stroke.Thickness = spec.thick
        st.stroke.Transparency = active and spec.tOn or spec.tOff
        st.glow.Visible = false
        if st.pulse then pcall(function() st.pulse:Cancel() end); st.pulse = nil end
    end
    _G.__VisibleXmasDecorate = decorate
    _G.__VisibleMakeHat = makeHat
    _G.__VisibleBtnStyle = style
    _G.__VisibleXmasApply = function(on)
        _G.VisibleXmasEnabled = false
        for btn in pairs(STATE) do
            if btn.Parent then
                style(btn, btn:GetAttribute("MobActive") == true)
            end
        end
    end

    -- ===== EXTRAS NAVIDEÑOS: panel principal, HUD de Auto Steal, bordes y toggles del panel normal =====
    local EXTRA_STROKES = {}
    local EXTRA_ROWS = setmetatable({}, {__mode = "k"})
    local MAIN_ST, HUD_ST = nil, nil
    local function xmasOn() return _G.VisibleXmasEnabled ~= false end

    local function bulbDot(parent, pos, size, color, z)
        local b = Instance.new("Frame")
        b.AnchorPoint = Vector2.new(0.5, 0.5)
        b.Size = UDim2.fromOffset(size, size)
        b.Position = pos
        b.BackgroundColor3 = color
        b.BorderSizePixel = 0
        b.ZIndex = z
        b.Parent = parent
        round(b)
        local bs = Instance.new("UIStroke")
        bs.Color = Color3.fromRGB(30, 30, 34); bs.Thickness = 1; bs.Transparency = 0.2
        bs.Parent = b
        return b
    end

    local function candyStroke(stroke, xThick, xTrans)
        if not stroke then return nil end
        local old = stroke:FindFirstChild("CandyGrad")
        if old then old:Destroy() end
        local grad = Instance.new("UIGradient")
        grad.Name = "CandyGrad"
        grad.Color = CANDY
        grad.Enabled = false
        grad.Parent = stroke
        local rec = {stroke = stroke, grad = grad, color = stroke.Color, thick = stroke.Thickness,
            trans = stroke.Transparency, xThick = xThick or 2.6, xTrans = xTrans or 0}
        table.insert(EXTRA_STROKES, rec)
        return rec
    end

    local function applyStrokeRec(rec)
        if not (rec and rec.stroke and rec.stroke.Parent) then return false end
        if xmasOn() then
            rec.grad.Enabled = false
            rec.stroke.Color = WHITE
            rec.stroke.Thickness = 0
            rec.stroke.Transparency = 1
        else
            rec.grad.Enabled = false
            rec.stroke.Color = WHITE
            rec.stroke.Thickness = 0
            rec.stroke.Transparency = 1
        end
        return true
    end

    local function makeHat(parent, pos, z, rot)
        local hat = Instance.new("Frame")
        hat.Name = "SantaHat"
        hat.BackgroundTransparency = 1
        hat.Size = UDim2.fromOffset(40, 34)
        hat.Position = pos
        hat.Rotation = rot or -14
        hat.ZIndex = z
        hat.Parent = parent
        box(hat, UDim2.fromOffset(26, 20), UDim2.fromOffset(7, 6), RED, z, 9)
        box(hat, UDim2.fromOffset(18, 14), UDim2.fromOffset(12, -1), Color3.fromRGB(190, 30, 48), z, 7)
        local tip = box(hat, UDim2.fromOffset(15, 13), UDim2.fromOffset(24, 0), RED, z, 6)
        tip.Rotation = 28
        box(hat, UDim2.fromOffset(11, 11), UDim2.fromOffset(31, 3), WHITE, z + 1, 0)
        box(hat, UDim2.fromOffset(38, 11), UDim2.fromOffset(0, 19), WHITE, z, 6)
        return hat
    end

    local MAIN_BULB_POS, HUD_BULB_POS = {}, {}
    for i = 1, 9 do
        local f = i / 10
        table.insert(MAIN_BULB_POS, UDim2.new(f, 0, 0, 3))
        table.insert(MAIN_BULB_POS, UDim2.new(f, 0, 1, -3))
        table.insert(HUD_BULB_POS, UDim2.new(f, 0, 0, 1))
        table.insert(HUD_BULB_POS, UDim2.new(f, 0, 1, -1))
    end
    for i = 1, 8 do
        local f = 0.06 + i * 0.1
        table.insert(MAIN_BULB_POS, UDim2.new(0, 3, f, 0))
        table.insert(MAIN_BULB_POS, UDim2.new(1, -3, f, 0))
    end
    local ROW_BULB_POS = {
        UDim2.new(0.16, 0, 0, 0), UDim2.new(0.5, 0, 0, 0), UDim2.new(0.84, 0, 0, 0),
        UDim2.new(0.16, 0, 1, 0), UDim2.new(0.5, 0, 1, 0), UDim2.new(0.84, 0, 1, 0),
    }

    local function layer(parent, name, z)
        local f = Instance.new("Frame")
        f.Name = name
        f.Size = UDim2.fromScale(1, 1)
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        f.ZIndex = z
        f.Visible = false
        f.Parent = parent
        return f
    end

    -- panel principal: fondo nocturno con nieve + luces en el borde + borde de bastón + gorro
    local function decorateMain(main, border, veil)
        if not main then return end
        if MAIN_ST and MAIN_ST.main == main then return end
        local st = {main = main, veil = veil, bulbs = {}, flakes = {}, shift = math.random(0, #BULBS - 1)}
        MAIN_ST = st
        local corner = main:FindFirstChildOfClass("UICorner")
        local cr = corner and corner.CornerRadius.Offset or 20

        local bgFrame = layer(main, "XmasBg", 1)
        bgFrame.BackgroundTransparency = 0
        bgFrame.BackgroundColor3 = WHITE
        round(bgFrame, cr)
        local g = Instance.new("UIGradient")
        g.Rotation = 90
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(6, 10, 26)),
            ColorSequenceKeypoint.new(0.6, Color3.fromRGB(14, 40, 58)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 52, 38)),
        })
        g.Parent = bgFrame
        for i = 1, 16 do
            local sz = math.random(2, 3)
            local star = Instance.new("Frame")
            star.Size = UDim2.fromOffset(sz, sz)
            star.Position = UDim2.fromScale(math.random(), math.random() * 0.6)
            star.BackgroundColor3 = WHITE
            star.BackgroundTransparency = 0.25 + math.random() * 0.5
            star.BorderSizePixel = 0
            star.Parent = bgFrame
            round(star)
        end
        for i = 0, 4 do
            local m = Instance.new("Frame")
            m.AnchorPoint = Vector2.new(0.5, 1)
            m.Size = UDim2.fromOffset(90, 44)
            m.Position = UDim2.new((i + 0.5) / 5, 0, 1, 14)
            m.BackgroundColor3 = Color3.fromRGB(235, 243, 255)
            m.BackgroundTransparency = 0.3
            m.BorderSizePixel = 0
            m.Parent = bgFrame
            round(m)
        end
        st.bgFrame = bgFrame

        local flakeLayer = layer(main, "XmasSnow", 3)
        for i = 1, 20 do
            local s = math.random(2, 5)
            local f = Instance.new("Frame")
            f.Size = UDim2.fromOffset(s, s)
            f.BackgroundColor3 = WHITE
            f.BackgroundTransparency = 0.15 + math.random() * 0.4
            f.BorderSizePixel = 0
            f.Parent = flakeLayer
            round(f)
            st.flakes[i] = {f = f, x = math.random(), speed = 0.05 + math.random() * 0.07,
                phase = math.random() * 6.28, off = math.random()}
        end
        st.flakeLayer = flakeLayer

        local light = layer(main, "XmasLights", 5)
        for i, p in ipairs(MAIN_BULB_POS) do
            st.bulbs[i] = bulbDot(light, p, 7, BULBS[((i + st.shift) % #BULBS) + 1], 1)
        end
        st.light = light

        st.hat = nil -- sin gorro en los botones/paneles

        local rec = candyStroke(border, 3, 0)
        applyStrokeRec(rec)
    end

    local function refreshMain()
        local st = MAIN_ST
        if not st or not st.main.Parent then return end
        local on = xmasOn()
        -- El fondo normal no se mezcla con Navidad: cada modo tiene su propia apariencia.
        local normalImage = st.main:FindFirstChild("BackgroundImage")
        if normalImage then
            normalImage.Visible = not on
            normalImage.ImageTransparency = (not on and normalImage.Image ~= "") and 0 or 1
        end
        st.bgFrame.Visible = on
        st.bgFrame.BackgroundTransparency = 0
        st.flakeLayer.Visible = on
        st.light.Visible = on
        if st.hat then st.hat.Visible = on end
        if st.veil and st.veil.Parent then st.veil.BackgroundTransparency = 1 end
    end

    -- HUD de Auto Steal: borde de bastón + luces + gorro
    local function decorateHud(pb)
        if not pb then return end
        if HUD_ST and HUD_ST.pb == pb then return end
        local st = {pb = pb, bulbs = {}, shift = math.random(0, #BULBS - 1)}
        HUD_ST = st
        local rec = candyStroke(pb:FindFirstChild("HudStroke"), 0, 1)
        applyStrokeRec(rec)
        local light = layer(pb, "XmasHudLights", 54)
        for i, p in ipairs(HUD_BULB_POS) do
            st.bulbs[i] = bulbDot(light, p, 7, BULBS[((i + st.shift) % #BULBS) + 1], 55)
        end
        st.light = light
        st.hat = nil -- sin gorro en los botones/paneles
        if st.hat then st.hat.Visible = false end
    end

    local function refreshHud()
        local st = HUD_ST
        if not st or not st.pb.Parent then return end
        local on = xmasOn()
        st.light.Visible = on
        if st.hat then st.hat.Visible = on end
    end

    -- filas de toggles del panel normal: mismo estilo que los botones flotantes
    local function decorateRow(row)
        if not row then return nil end
        if EXTRA_ROWS[row] then return EXTRA_ROWS[row] end
        local stroke = row:FindFirstChildOfClass("UIStroke")
        if not stroke then return nil end
        local st = {stroke = stroke, bulbs = {}, shift = math.random(0, #BULBS - 1)}
        EXTRA_ROWS[row] = st
        row:SetAttribute("VisibleToggle", true)

        local grad = Instance.new("UIGradient")
        grad.Name = "CandyGrad"
        grad.Color = CANDY
        grad.Enabled = false
        grad.Parent = stroke
        st.grad = grad

        local tint = Instance.new("Frame")
        tint.Name = "ActiveTint"
        tint.Size = UDim2.fromScale(1, 1)
        tint.BackgroundColor3 = WHITE
        tint.BackgroundTransparency = 1
        tint.BorderSizePixel = 0
        tint.ZIndex = 7
        tint.Parent = row
        round(tint, 12)
        st.tint = tint

        local glow = Instance.new("Frame")
        glow.Name = "VisibleGlow"
        glow.AnchorPoint = Vector2.new(0.5, 0.5)
        glow.Position = UDim2.fromScale(0.5, 0.5)
        glow.Size = UDim2.new(1, 4, 1, 4)
        glow.BackgroundTransparency = 1
        glow.BorderSizePixel = 0
        glow.ZIndex = 6
        glow.Visible = false
        glow.Parent = row
        round(glow, 14)
        local gs = Instance.new("UIStroke")
        gs.Color = WHITE; gs.Thickness = 3; gs.Transparency = 0.25
        gs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        gs.Parent = glow
        st.glow, st.glowStroke = glow, gs

        local light = layer(row, "XmasRowLights", 11)
        for i, p in ipairs(ROW_BULB_POS) do
            st.bulbs[i] = bulbDot(light, p, 6, BULBS[((i + st.shift) % #BULBS) + 1], 1)
        end
        st.light = light
        return st
    end

    local function rowStyle(row, active)
        local st = EXTRA_ROWS[row]
        if not st or not row.Parent then return end
        local xmas = xmasOn()
        local stroke = st.stroke
        -- Las filas también mantienen el mismo tamaño y borde al cambiar de modo.
        local ACE = _G.__VisibleAce
        local corner = row:FindFirstChildOfClass("UICorner")
        if corner then corner.CornerRadius = UDim.new(0, 16) end
        row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        row.BackgroundTransparency = 0.03
        st.light.Visible = false
        if xmas then
            for i, bulb in ipairs(st.bulbs) do
                bulb.BackgroundColor3 = BULBS[((i + st.shift) % #BULBS) + 1]
                local bs = bulb:FindFirstChildOfClass("UIStroke")
                if bs then bs.Color = Color3.fromRGB(30, 30, 34) end
            end
        end
        -- Activación MVP: el estado lo muestra la pastilla ON/OFF, no un borde brillante.
        st.grad.Enabled = false
        stroke.Color = Color3.fromRGB(215, 219, 230)
        stroke.Thickness = 1.2
        stroke.Transparency = 0.6
        local accentBar = row:FindFirstChild("AccentBar")
        if accentBar then accentBar.BackgroundTransparency = active and 0 or 1 end
        st.tint.BackgroundColor3 = BLACK
        st.tint.BackgroundTransparency = 1
        st.glow.Visible = false
        if st.pulse then pcall(function() st.pulse:Cancel() end); st.pulse = nil end
    end

    local function refreshExtras()
        for i = #EXTRA_STROKES, 1, -1 do
            if not applyStrokeRec(EXTRA_STROKES[i]) then table.remove(EXTRA_STROKES, i) end
        end
        refreshMain()
        refreshHud()
        for row in pairs(EXTRA_ROWS) do
            if row.Parent then rowStyle(row, row:GetAttribute("MVPActive") == true) end
        end
    end

    local snowAcc = 0
    local function tickExtra(dt, rot, blink, step)
        for i = #EXTRA_STROKES, 1, -1 do
            local rec = EXTRA_STROKES[i]
            if rec.stroke and rec.stroke.Parent then
                if rec.grad.Enabled then
                    rec.grad.Rotation = rot
                    if blink and rec.stroke.Color ~= WHITE then rec.stroke.Color = WHITE end
                end
            else
                table.remove(EXTRA_STROKES, i)
            end
        end
        local m = MAIN_ST
        if m and m.main.Parent and m.main.Visible and m.light.Visible then
            if blink then
                for i, b in ipairs(m.bulbs) do
                    b.BackgroundColor3 = BULBS[((i + m.shift + step) % #BULBS) + 1]
                end
            end
            snowAcc = snowAcc + dt
            if snowAcc >= 1 / 30 then
                snowAcc = 0
                local t = os.clock()
                for _, fl in ipairs(m.flakes) do
                    local y = ((t * fl.speed + fl.off) % 1.1) - 0.05
                    local x = fl.x + math.sin(t * 0.8 + fl.phase) * 0.025
                    fl.f.Position = UDim2.fromScale(x, y)
                end
            end
        end
        local h = HUD_ST
        if blink and h and h.pb.Parent and h.light.Visible then
            for i, b in ipairs(h.bulbs) do
                b.BackgroundColor3 = BULBS[((i + h.shift + step) % #BULBS) + 1]
            end
        end
        for row, st in pairs(EXTRA_ROWS) do
            local page = row.Parent
            if page and page:IsA("GuiObject") and page.Visible then
                if st.grad.Enabled then st.grad.Rotation = rot end
                if blink and st.light.Visible then
                    for i, b in ipairs(st.bulbs) do
                        b.BackgroundColor3 = BULBS[((i + st.shift + step) % #BULBS) + 1]
                    end
                end
            end
        end
    end

    _G.__VisibleXmasApply = function(on)
        _G.VisibleXmasEnabled = false
        for btn in pairs(STATE) do
            if btn.Parent then
                style(btn, btn:GetAttribute("MobActive") == true)
            end
        end
        refreshExtras()
        if applyMainBackground then pcall(applyMainBackground) end
        if applyBackgroundMode then pcall(applyBackgroundMode, backgroundMode) end
        if applyStealBackground then pcall(applyStealBackground, stealBgIndex) end
        if _G.__VisibleScriptNameHat then _G.__VisibleScriptNameHat.Visible = (_G.VisibleXmasEnabled ~= false) end
        if _G.__VisibleMiniHat then _G.__VisibleMiniHat.Visible = (_G.VisibleXmasEnabled ~= false) end
        if MVPUI.speedValueLabel and MVPUI.speedValueLabel.Parent then
            MVPUI.speedValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end
    _G.__VisibleXmasMain = function(main, border, veil) decorateMain(main, border, veil); refreshMain() end
    _G.__VisibleXmasMainRefresh = refreshMain
    _G.__VisibleXmasHud = function(pb) decorateHud(pb); refreshHud() end
    _G.__VisibleXmasStroke = function(stroke, xThick, xTrans) applyStrokeRec(candyStroke(stroke, xThick, xTrans)) end
    _G.__VisibleXmasRow = function(row)
        local st = decorateRow(row)
        if st then rowStyle(row, row:GetAttribute("MVPActive") == true) end
    end
    _G.__VisibleRowStyle = function(row, active) rowStyle(row, active) end

    -- luces parpadeando + rayas del borde girando
    if _G.__VisibleXmasConn then pcall(function() _G.__VisibleXmasConn:Disconnect() end) end
    local acc = 0
    local step = 0
    _G.__VisibleXmasConn = RSv.Heartbeat:Connect(function(dt)
        if _G.VisibleXmasEnabled == false then return end
        acc = acc + dt
        local rot = (os.clock() * 45) % 360
        local blink = false
        if acc >= 0.5 then acc = 0; step = step + 1; blink = true end
        for btn, st in pairs(STATE) do
            if btn.Parent and st.deco.Visible then
                if st.grad.Enabled then st.grad.Rotation = rot end
                if blink then
                    for i, b in ipairs(st.bulbs) do
                        b.BackgroundColor3 = BULBS[((i + st.shift + step) % #BULBS) + 1]
                    end
                end
            end
        end
        tickExtra(dt, rot, blink, step)
    end)
end

-- ===== EXTRAS v5: granizo en pantalla + bases navideñas + sonido de la intro =====
do
    local function xmasOn() return _G.VisibleXmasEnabled ~= false end
    if _G.VisibleHailEnabled == nil then _G.VisibleHailEnabled = true end

    -- ---------- GRANIZO (cae por toda la pantalla; no bloquea clics) ----------
    local hailGui = nil
    local hail = {}
    local HAIL_COUNT = 70

    local function buildHail()
        pcall(function() local o = pgui:FindFirstChild("VisibleHail"); if o then o:Destroy() end end)
        local g = Instance.new("ScreenGui")
        g.Name = "VisibleHail"
        g.ResetOnSpawn = false
        g.IgnoreGuiInset = true
        g.DisplayOrder = 400
        g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        g.Parent = pgui
        hailGui = g
        hail = {}
        for i = 1, HAIL_COUNT do
            local sz = math.random(3, 7)
            local f = Instance.new("Frame")
            f.Size = UDim2.fromOffset(sz, sz)
            f.BackgroundColor3 = Color3.fromRGB(math.random(210, 245), math.random(232, 250), 255)
            f.BackgroundTransparency = 0.1 + math.random() * 0.3
            f.BorderSizePixel = 0
            f.Active = false
            f.Parent = g
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(1, 0)
            c.Parent = f
            hail[i] = {
                f = f, x = math.random() * 1.15, y = math.random(),
                vy = 0.9 + math.random() * 0.8,          -- fracción de pantalla por segundo (rápido)
                vx = -(0.10 + math.random() * 0.12),     -- cae en diagonal
            }
        end
    end

    if _G.__VisibleHailConn then pcall(function() _G.__VisibleHailConn:Disconnect() end) end
    _G.__VisibleHailConn = RunService.Heartbeat:Connect(function(dt)
        if _mySession ~= _G.VisibleHubSession then
            if _G.__VisibleHailConn then _G.__VisibleHailConn:Disconnect(); _G.__VisibleHailConn = nil end
            if hailGui then pcall(function() hailGui:Destroy() end); hailGui = nil end
            return
        end
        local on = xmasOn() and _G.VisibleHailEnabled ~= false
        if not on then
            if hailGui and hailGui.Enabled then hailGui.Enabled = false end
            return
        end
        if not (hailGui and hailGui.Parent) then buildHail() end
        if not hailGui.Enabled then hailGui.Enabled = true end
        if dt > 0.05 then dt = 0.05 end
        for i = 1, #hail do
            local d = hail[i]
            d.y = d.y + d.vy * dt
            d.x = d.x + d.vx * dt
            if d.y > 1.03 or d.x < -0.06 then
                d.y = -0.04
                d.x = math.random() * 1.15
            end
            d.f.Position = UDim2.fromScale(d.x, d.y)
        end
    end)

    -- ---------- BASES NAVIDEÑAS (solo visual, solo en tu cliente) ----------
    local PLOT_COLORS = {
        Color3.fromRGB(230, 40, 50), Color3.fromRGB(255, 255, 255), Color3.fromRGB(34, 170, 90),
        Color3.fromRGB(255, 205, 60), Color3.fromRGB(90, 160, 255),
    }
    local SNOW_COLOR = Color3.fromRGB(236, 244, 255)
    local decoRoot = nil
    local decorated = setmetatable({}, {__mode = "k"})

    local function getDecoRoot()
        if decoRoot and decoRoot.Parent then return decoRoot end
        pcall(function() local o = Workspace:FindFirstChild("VisibleXmasDeco"); if o then o:Destroy() end end)
        decoRoot = Instance.new("Folder")
        decoRoot.Name = "VisibleXmasDeco"
        decoRoot.Parent = Workspace
        return decoRoot
    end

    local function mkPart(parent, name, size, cf, color, shape, material)
        local p = Instance.new("Part")
        p.Name = name
        p.Anchored = true
        p.CanCollide = false
        p.CanTouch = false
        p.CanQuery = false
        p.CastShadow = false
        p.Size = size
        p.Color = color
        p.Material = material or Enum.Material.SmoothPlastic
        if shape then p.Shape = shape end
        p.CFrame = cf
        p.Parent = parent
        return p
    end

    local function restoreFloors(rec)
        for _, fl in ipairs(rec.floors or {}) do
            if fl.part and fl.part.Parent then
                pcall(function() fl.part.Color = fl.color; fl.part.Material = fl.mat end)
            end
        end
        rec.floors = {}
    end

    local function undecoratePlot(plot, rec)
        restoreFloors(rec)
        if rec.folder then pcall(function() rec.folder:Destroy() end) end
        decorated[plot] = nil
    end

    local function decoratePlot(plot)
        if not plot:IsA("Model") then return end
        local okb, cf, size = pcall(function() return plot:GetBoundingBox() end)
        if not okb or not cf or not size then return end
        local rec = {bulbs = {}, floors = {}}
        decorated[plot] = rec
        local folder = Instance.new("Folder")
        folder.Name = "Plot_" .. plot.Name
        folder.Parent = getDecoRoot()
        rec.folder = folder

        -- suelo nevado (solo piezas grandes y planas directamente dentro de la base)
        for _, d in ipairs(plot:GetChildren()) do
            if d:IsA("BasePart") and d.Size.X > 18 and d.Size.Z > 18 and d.Size.Y < 8 and d.Transparency < 0.9 then
                table.insert(rec.floors, {part = d, color = d.Color, mat = d.Material})
                pcall(function() d.Color = SNOW_COLOR; d.Material = Enum.Material.Snow end)
            end
        end

        -- guirnalda de luces alrededor de la base
        local hx, hz = size.X / 2 - 1, size.Z / 2 - 1
        if hx < 4 or hz < 4 then return end
        local y = -size.Y / 2 + 2.5
        local perimeter = 4 * (hx + hz)
        local step = math.max(5, perimeter / 110)
        local n = 0
        local function bulb(lx, lz)
            n = n + 1
            local p = mkPart(folder, "Bulb", Vector3.new(0.9, 0.9, 0.9), cf * CFrame.new(lx, y, lz),
                PLOT_COLORS[(n % #PLOT_COLORS) + 1], Enum.PartType.Ball, Enum.Material.Neon)
            table.insert(rec.bulbs, p)
        end
        local x = -hx
        while x <= hx do bulb(x, -hz); bulb(x, hz); x = x + step end
        local z = -hz + step
        while z < hz do bulb(-hx, z); bulb(hx, z); z = z + step end

        -- bastones de caramelo en las 4 esquinas
        for _, c in ipairs({{-hx, -hz}, {hx, -hz}, {-hx, hz}, {hx, hz}}) do
            for seg = 0, 6 do
                mkPart(folder, "Cane", Vector3.new(1, 0.75, 0.75),
                    cf * CFrame.new(c[1], -size.Y / 2 + 0.5 + seg, c[2]) * CFrame.Angles(0, 0, math.pi / 2),
                    (seg % 2 == 0) and Color3.fromRGB(220, 35, 50) or Color3.fromRGB(255, 255, 255),
                    Enum.PartType.Cylinder)
            end
            mkPart(folder, "CaneTop", Vector3.new(1.4, 1.4, 1.4),
                cf * CFrame.new(c[1], -size.Y / 2 + 7.8, c[2]), Color3.fromRGB(255, 205, 60),
                Enum.PartType.Ball, Enum.Material.Neon)
        end
    end

    local function clearAllPlots()
        for plot, rec in pairs(decorated) do undecoratePlot(plot, rec) end
        if decoRoot then pcall(function() decoRoot:Destroy() end); decoRoot = nil end
    end

    task.spawn(function()
        local step = 0
        while _mySession == _G.VisibleHubSession do
            local ok = pcall(function()
                if xmasOn() then
                    local plots = Workspace:FindFirstChild("Plots")
                    if plots then
                        for _, plot in ipairs(plots:GetChildren()) do
                            if not decorated[plot] then decoratePlot(plot) end
                        end
                    end
                    step = step + 1
                    for plot, rec in pairs(decorated) do
                        if not plot.Parent then
                            undecoratePlot(plot, rec)
                        else
                            for i, b in ipairs(rec.bulbs) do
                                b.Color = PLOT_COLORS[((i + step) % #PLOT_COLORS) + 1]
                            end
                        end
                    end
                else
                    if next(decorated) ~= nil or decoRoot then clearAllPlots() end
                end
            end)
            task.wait(ok and 0.5 or 2)
        end
        pcall(clearAllPlots)
    end)

    -- ---------- SONIDO DE NAVIDAD EN LA INTRO ----------
    -- Orden: 1) archivo local "visible_xmas_intro.mp3/.ogg" en la carpeta workspace del executor
    --        2) descarga de _G.VisibleXmasIntroSoundUrl (por defecto: "Jingle Bells (Calm)" de Kevin MacLeod, CC BY 3.0)
    --        3) _G.VisibleXmasIntroSoundId (id numérico de Roblox) si lo defines
    local DEFAULT_URL = "https://upload.wikimedia.org/wikipedia/commons/8/8a/Jingle_Bells_%28Calm%29_%28ISRC_USUAN1100188%29.mp3"
    _G.__VisibleXmasIntroSound = function(introGui)
        task.spawn(function()
            local loader = getcustomasset or getsynasset
            local id = nil
            local function looksAudio(data)
                return type(data) == "string" and #data > 2000
                    and (data:sub(1, 3) == "ID3" or data:byte(1) == 0xFF or data:sub(1, 4) == "OggS")
            end
            pcall(function()
                if type(loader) == "function" and type(isfile) == "function" then
                    for _, n in ipairs({"visible_xmas_intro.mp3", "visible_xmas_intro.ogg"}) do
                        if isfile(n) then id = loader(n); return end
                    end
                end
            end)
            if not id then
                pcall(function()
                    assert(type(loader) == "function" and type(writefile) == "function")
                    local data = game:HttpGet(_G.VisibleXmasIntroSoundUrl or DEFAULT_URL)
                    assert(looksAudio(data), "descarga inválida")
                    writefile("visible_xmas_intro.mp3", data)
                    id = loader("visible_xmas_intro.mp3")
                end)
            end
            if not id and _G.VisibleXmasIntroSoundId then
                id = "rbxassetid://" .. tostring(_G.VisibleXmasIntroSoundId)
            end
            if not id then
                warn("[Visible] Sin sonido de intro: pon visible_xmas_intro.mp3 en la carpeta workspace del executor o define _G.VisibleXmasIntroSoundUrl / _G.VisibleXmasIntroSoundId")
                return
            end
            if not (introGui and introGui.Parent) then return end
            local snd = Instance.new("Sound")
            snd.Name = "VisibleXmasIntroSound"
            snd.SoundId = id
            snd.Volume = 0.8
            snd.Looped = false
            snd.Parent = SoundService
            local t0 = tick()
            while not snd.IsLoaded and tick() - t0 < 6 and snd.Parent do task.wait(0.1) end
            snd:Play()
            local startedAt = tick()
            while snd.Parent and introGui.Parent and (snd.IsPlaying or tick() - startedAt < 2) do
                task.wait(0.1)
            end
            if snd.Parent then
                pcall(function()
                    local tw = TS:Create(snd, TweenInfo.new(0.7), {Volume = 0})
                    tw:Play()
                    tw.Completed:Wait()
                end)
                pcall(function() snd:Destroy() end)
            end
        end)
    end
end


-- ===== INTRO DE NAVIDAD VISIBLE: POLO NORTE =====
-- 1) Primero aparece SOLO Santa volando en su trineo sobre la noche oscura.
-- 2) Al aterrizar se revela todo lo demás (árboles, muñecos, regalos, tu personaje).
-- 3) Tu personaje dice en grande "BIENVENIDA A VISIBLE" (con gorro de Santa, nieve y luces).
do
    _G.__VisibleXmasIntro = function(hubGui, isDone, signalDone)
        isDone = isDone or function() return false end
        signalDone = signalDone or function() end
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local Workspace = game:GetService("Workspace")
        local LP = Players.LocalPlayer

        local V3 = Vector3.new
        local V2 = Vector2.new
        local sin, cos, pi, abs, max = math.sin, math.cos, math.pi, math.abs, math.max
        local rnd = math.random
        local CSK = ColorSequenceKeypoint.new
        local function rgb(r, g, b) return Color3.fromRGB(r, g, b) end

        local DURATION = 15.0

        local function clamp01(x) return math.clamp(x, 0, 1) end
        local function lerp(a, b, t) return a + (b - a) * t end
        local function easeOutCubic(x) return 1 - (1 - x) ^ 3 end
        local function easeInOut(x)
            if x < 0.5 then return 4 * x ^ 3 end
            return 1 - ((-2 * x + 2) ^ 3) / 2
        end
        local function easeOutBack(x)
            local c1 = 1.70158
            local c3 = c1 + 1
            return 1 + c3 * (x - 1) ^ 3 + c1 * (x - 1) ^ 2
        end

        local function make(class, parent, props)
            local o = Instance.new(class)
            for k, v in pairs(props or {}) do o[k] = v end
            if parent then o.Parent = parent end
            return o
        end

        local function mountGui(g)
            pcall(function() if syn and syn.protect_gui then syn.protect_gui(g) end end)
            local ok = pcall(function() g.Parent = game:GetService("CoreGui") end)
            if not ok or not g.Parent then
                g.Parent = LP:WaitForChild("PlayerGui")
            end
        end

        -- quitar una intro anterior si existe
        for _, host in ipairs({game:GetService("CoreGui"), LP and LP:FindFirstChildOfClass("PlayerGui")}) do
            if host then
                local old = host:FindFirstChild("VisibleIntro3D")
                if old then pcall(function() old:Destroy() end) end
            end
        end

        -- ---------- paleta / utilidades 3D ----------
        local okM, MAT_SNOW = pcall(function() return Enum.Material.Snow end)
        if not okM or not MAT_SNOW then MAT_SNOW = Enum.Material.SmoothPlastic end
        local SMOOTH = Enum.Material.SmoothPlastic
        local NEON = Enum.Material.Neon
        local SNOW  = rgb(244, 248, 255)
        local RED   = rgb(205, 40, 52)
        local BROWN = rgb(104, 66, 38)
        local COAL  = rgb(28, 28, 34)
        local GOLD  = rgb(255, 208, 70)
        local LIGHT_COLORS = {rgb(255, 70, 80), rgb(255, 210, 80), rgb(90, 180, 255), rgb(110, 255, 150), rgb(255, 140, 200)}
        local VERT = CFrame.Angles(0, 0, pi / 2)
        local NP = {lights = {}}

        -- ---------- constructores de decoración ----------
        local function mk(parent, kind, size, cf, color, material)
            local p = Instance.new("Part")
            p.Anchored = true
            p.CanCollide = false
            p.CanTouch = false
            p.CanQuery = false
            p.CastShadow = false
            p.TopSurface = Enum.SurfaceType.Smooth
            p.BottomSurface = Enum.SurfaceType.Smooth
            if kind == "ball" then
                p.Shape = Enum.PartType.Ball
            elseif kind == "cyl" then
                p.Shape = Enum.PartType.Cylinder
            end
            p.Size = size
            p.Color = color
            p.Material = material or SMOOTH
            p.CFrame = cf
            p.Parent = parent
            return p
        end

        local function vcyl(parent, base, x, y, z, h, d, color, mat)
            return mk(parent, "cyl", V3(h, d, d), base * CFrame.new(x, y, z) * VERT, color, mat)
        end

        local function addLight(p)
            NP.lights[#NP.lights + 1] = {p = p, i = rnd(1, #LIGHT_COLORS)}
        end

        local function newModel(parent, name)
            local m = Instance.new("Model")
            m.Name = name
            m.Parent = parent
            return m
        end

        local function buildTree(parent, base, s)
            local m = newModel(parent, "XmasTree")
            vcyl(m, base, 0, 0.35 * s, 0, 0.7 * s, 0.6 * s, BROWN)
            local G1, G2 = Color3.fromRGB(38, 150, 74), Color3.fromRGB(26, 118, 58)
            for i = 0, 10 do
                local f = i / 10
                local r = (2.1 - f * 1.85) * s
                local y = (0.85 + i * 0.42) * s
                vcyl(m, base, 0, y, 0, 0.5 * s, r * 2, (i % 2 == 0) and G1 or G2)
                vcyl(m, base, 0, y + 0.22 * s, 0, 0.08 * s, r * 1.6, SNOW, MAT_SNOW)
                if i % 2 == 1 then
                    local a = i * 2.4
                    local o = mk(m, "ball", V3(0.28 * s, 0.28 * s, 0.28 * s),
                        base * CFrame.new(cos(a) * r * 0.97, y - 0.08 * s, sin(a) * r * 0.97),
                        LIGHT_COLORS[i % #LIGHT_COLORS + 1], NEON)
                    addLight(o)
                end
            end
            local topY = (0.85 + 10 * 0.42 + 0.55) * s
            local STAR = Color3.fromRGB(255, 214, 70)
            mk(m, "block", V3(0.75 * s, 0.75 * s, 0.2 * s), base * CFrame.new(0, topY, 0), STAR, NEON)
            mk(m, "block", V3(0.75 * s, 0.75 * s, 0.2 * s), base * CFrame.new(0, topY, 0) * CFrame.Angles(0, 0, pi / 4), STAR, NEON)
            return m
        end

        local function buildSnowman(parent, base, u, scarfColor, hat)
            local m = newModel(parent, "Snowman")
            local r1, r2, r3 = 1.3, 0.95, 0.68
            local y1 = r1 - 0.15
            local y2 = y1 + r1 * 0.55 + r2 * 0.62
            local y3 = y2 + r2 * 0.55 + r3 * 0.62
            local function B(kind, sx, sy, sz, x, y, z, color, rot, mat)
                return mk(m, kind, V3(sx * u, sy * u, sz * u), base * CFrame.new(x * u, y * u, z * u) * (rot or CFrame.new()), color, mat)
            end
            B("ball", r1 * 2, r1 * 2, r1 * 2, 0, y1, 0, SNOW, nil, MAT_SNOW)
            B("ball", r2 * 2, r2 * 2, r2 * 2, 0, y2, 0, SNOW, nil, MAT_SNOW)
            B("ball", r3 * 2, r3 * 2, r3 * 2, 0, y3, 0, SNOW, nil, MAT_SNOW)
            for _, ex in ipairs({-0.24, 0.24}) do
                B("ball", 0.13, 0.13, 0.13, ex, y3 + r3 * 0.25, r3 * 0.9, COAL)
            end
            for k = -2, 2 do
                B("ball", 0.07, 0.07, 0.07, k * 0.115, y3 - r3 * 0.2 + abs(k) * 0.03, r3 * 0.92, COAL)
            end
            local FRONT = CFrame.Angles(0, -pi / 2, 0)
            local ORANGE = Color3.fromRGB(255, 130, 30)
            B("cyl", 0.16, 0.17, 0.17, 0, y3 + r3 * 0.02, r3 * 0.95, ORANGE, FRONT)
            B("cyl", 0.16, 0.12, 0.12, 0, y3 + r3 * 0.02, r3 * 0.95 + 0.15, ORANGE, FRONT)
            B("cyl", 0.14, 0.07, 0.07, 0, y3 + r3 * 0.02, r3 * 0.95 + 0.29, ORANGE, FRONT)
            for k = 0, 2 do
                local by = y2 + (0.32 - k * 0.3)
                local bz = math.sqrt(math.max(r2 * r2 - (by - y2) ^ 2, 0.01))
                B("ball", 0.14, 0.14, 0.14, 0, by, bz, COAL)
            end
            local sy = y2 + r2 * 0.78
            B("cyl", 0.2, r2 * 1.39, r2 * 1.39, 0, sy, 0, scarfColor, VERT)
            local tdy, tdx = (sy - 0.32) - y2, 0.3
            local tz = math.sqrt(math.max(r2 * r2 - tdy * tdy - tdx * tdx, 0.05)) + 0.03
            B("block", 0.22, 0.7, 0.09, tdx, sy - 0.32, tz, scarfColor)
            for _, side in ipairs({-1, 1}) do
                B("block", 0.09, 1.15, 0.09, side * (r2 + 0.32), y2 + 0.28, 0, BROWN, CFrame.Angles(0, 0, -side * 0.95))
            end
            local hy = y3 + r3 * 0.86
            if hat == "top" then
                B("cyl", 0.08, 1.15, 1.15, 0, hy, 0, COAL, VERT)
                B("cyl", 0.62, 0.76, 0.76, 0, hy + 0.34, 0, COAL, VERT)
                B("cyl", 0.14, 0.78, 0.78, 0, hy + 0.12, 0, RED, VERT)
            elseif hat == "santa" then
                B("cyl", 0.18, 1.0, 1.0, 0, hy - 0.02, 0, SNOW, VERT)
                B("cyl", 0.22, 0.86, 0.86, 0, hy + 0.16, 0, RED, VERT)
                B("cyl", 0.22, 0.62, 0.62, 0, hy + 0.36, 0, RED, VERT)
                B("cyl", 0.22, 0.38, 0.38, 0, hy + 0.56, 0, RED, VERT)
                B("ball", 0.22, 0.22, 0.22, 0.05, hy + 0.74, 0, SNOW)
            else
                local BLUE = Color3.fromRGB(70, 130, 230)
                B("cyl", 0.2, 1.02, 1.02, 0, hy + 0.02, 0, SNOW, VERT)
                B("cyl", 0.26, 0.9, 0.9, 0, hy + 0.22, 0, BLUE, VERT)
                B("cyl", 0.2, 0.62, 0.62, 0, hy + 0.44, 0, BLUE, VERT)
                B("ball", 0.24, 0.24, 0.24, 0, hy + 0.62, 0, SNOW)
            end
            return m
        end

        local function buildGift(parent, base, s, color, ribbon)
            local g = newModel(parent, "Gift")
            mk(g, "block", V3(s, s, s), base * CFrame.new(0, s / 2, 0), color)
            mk(g, "block", V3(s * 1.03, s * 1.03, s * 0.2), base * CFrame.new(0, s / 2, 0), ribbon)
            mk(g, "block", V3(s * 0.2, s * 1.03, s * 1.03), base * CFrame.new(0, s / 2, 0), ribbon)
            mk(g, "ball", V3(s * 0.32, s * 0.32, s * 0.32), base * CFrame.new(0, s * 1.05, 0), ribbon)
        end

        -- ---------- rig simple ----------
        local function newRig(parent, S)
            local rig = {items = {}, S = S or 1, pivots = {}}
            function rig.pivot(name, v) rig.pivots[name] = v * rig.S end
            function rig.add(group, kind, size, rel, color, mat)
                local s = rig.S
                local p = mk(parent, kind, size * s, CFrame.new(), color, mat)
                rig.items[#rig.items + 1] = {p = p, g = group, rel = CFrame.new(rel.Position * s) * (rel - rel.Position)}
                return p
            end
            function rig.pose(base, rots)
                local joints = {}
                for g, r in pairs(rots or {}) do
                    local pv = rig.pivots[g] or V3()
                    joints[g] = CFrame.new(pv) * r * CFrame.new(-pv)
                end
                for _, it in ipairs(rig.items) do
                    local j = joints[it.g]
                    if j then it.p.CFrame = base * j * it.rel else it.p.CFrame = base * it.rel end
                end
            end
            return rig
        end

        local function buildSanta(parent)
            local R = newRig(parent, 0.85)
            local SKIN, SR, WH, BK = rgb(255, 208, 172), rgb(205, 30, 45), rgb(250, 250, 252), rgb(30, 30, 36)
            R.pivot("legL", V3(-0.38, 2.0, 0)); R.pivot("legR", V3(0.38, 2.0, 0))
            R.pivot("armL", V3(-1.1, 4.1, 0)); R.pivot("armR", V3(1.1, 4.1, 0))
            R.pivot("head", V3(0, 4.5, 0))
            for _, sx in ipairs({-1, 1}) do
                local g = (sx < 0) and "legL" or "legR"
                R.add(g, "block", V3(0.62, 0.5, 1.0), CFrame.new(sx * 0.38, 0.25, -0.12), BK)
                R.add(g, "cyl", V3(1.5, 0.6, 0.6), CFrame.new(sx * 0.38, 1.3, 0) * VERT, SR)
                R.add(g, "cyl", V3(0.22, 0.72, 0.72), CFrame.new(sx * 0.38, 0.62, 0) * VERT, WH)
                local ga = (sx < 0) and "armL" or "armR"
                R.add(ga, "cyl", V3(1.5, 0.62, 0.62), CFrame.new(sx * 1.2, 3.4, 0) * VERT, SR)
                R.add(ga, "cyl", V3(0.24, 0.74, 0.74), CFrame.new(sx * 1.2, 2.75, 0) * VERT, WH)
                R.add(ga, "ball", V3(0.62, 0.62, 0.62), CFrame.new(sx * 1.2, 2.52, 0), BK)
            end
            R.add("body", "ball", V3(2.5, 2.5, 2.5), CFrame.new(0, 3.05, 0), SR)
            R.add("body", "ball", V3(1.9, 1.9, 1.9), CFrame.new(0, 3.95, 0), SR)
            R.add("body", "cyl", V3(0.28, 1.9, 1.9), CFrame.new(0, 2.1, 0) * VERT, WH)
            R.add("body", "cyl", V3(0.34, 2.52, 2.52), CFrame.new(0, 3.0, 0) * VERT, BK)
            R.add("body", "block", V3(0.6, 0.5, 0.14), CFrame.new(0, 3.0, -1.27), GOLD, NEON)
            R.add("body", "ball", V3(1.9, 1.9, 1.9), CFrame.new(-0.1, 3.2, 1.5), rgb(150, 98, 58))
            R.add("body", "block", V3(0.6, 0.6, 0.6), CFrame.new(-0.1, 4.3, 1.5), RED)
            R.add("body", "block", V3(0.65, 0.12, 0.65), CFrame.new(-0.1, 4.3, 1.5), GOLD)
            R.add("head", "ball", V3(1.35, 1.35, 1.35), CFrame.new(0, 4.95, 0), SKIN)
            R.add("head", "ball", V3(0.28, 0.28, 0.28), CFrame.new(0, 4.9, -0.7), rgb(240, 140, 130))
            R.add("head", "ball", V3(1.1, 1.1, 1.1), CFrame.new(0, 4.35, -0.4), WH)
            for _, sx in ipairs({-1, 1}) do
                R.add("head", "ball", V3(0.15, 0.15, 0.15), CFrame.new(sx * 0.26, 5.08, -0.62), BK)
                R.add("head", "block", V3(0.3, 0.07, 0.08), CFrame.new(sx * 0.27, 5.26, -0.62), WH)
                R.add("head", "ball", V3(0.34, 0.34, 0.34), CFrame.new(sx * 0.42, 4.78, -0.55), rgb(255, 150, 150))
                R.add("head", "ball", V3(0.62, 0.62, 0.62), CFrame.new(sx * 0.55, 4.45, -0.35), WH)
                R.add("head", "ball", V3(0.5, 0.5, 0.5), CFrame.new(sx * 0.24, 4.68, -0.68), WH)
            end
            R.add("head", "cyl", V3(0.32, 1.6, 1.6), CFrame.new(0, 5.55, 0) * VERT, WH)
            R.add("head", "cyl", V3(0.5, 1.35, 1.35), CFrame.new(0, 5.9, 0) * VERT, SR)
            R.add("head", "cyl", V3(0.5, 1.05, 1.05), CFrame.new(0.04, 6.35, 0.05) * VERT, SR)
            R.add("head", "cyl", V3(0.45, 0.72, 0.72), CFrame.new(0.1, 6.75, 0.12) * VERT, SR)
            R.add("head", "ball", V3(0.42, 0.42, 0.42), CFrame.new(0.14, 7.1, 0.18), WH)
            return R
        end

        local function buildReindeer(parent, lead)
            local R = newRig(parent, 0.9)
            local BR, BR2 = rgb(142, 94, 58), rgb(196, 150, 104)
            local HORN = rgb(200, 180, 150)
            R.pivot("fl", V3(-0.3, 1.65, -0.85)); R.pivot("fr", V3(0.3, 1.65, -0.85))
            R.pivot("bl", V3(-0.3, 1.65, 0.85)); R.pivot("br", V3(0.3, 1.65, 0.85))
            R.add("body", "block", V3(0.95, 1.0, 2.3), CFrame.new(0, 2.1, 0), BR)
            R.add("body", "block", V3(0.55, 1.1, 0.6), CFrame.new(0, 2.85, -1.1) * CFrame.Angles(-0.5, 0, 0), BR)
            R.add("body", "block", V3(0.62, 0.62, 0.95), CFrame.new(0, 3.45, -1.55), BR)
            R.add("body", "block", V3(0.4, 0.4, 0.45), CFrame.new(0, 3.3, -2.05), BR2)
            R.add("body", "ball", V3(0.32, 0.32, 0.32), CFrame.new(0, 3.38, -2.3), lead and rgb(255, 40, 40) or COAL, lead and NEON or SMOOTH)
            R.add("body", "ball", V3(0.35, 0.35, 0.35), CFrame.new(0, 2.4, 1.2), SNOW)
            R.add("body", "block", V3(1.02, 1.07, 0.16), CFrame.new(0, 2.1, -0.55), RED)
            R.add("body", "ball", V3(0.26, 0.26, 0.26), CFrame.new(0, 1.55, -0.55), GOLD, NEON)
            for _, sx in ipairs({-1, 1}) do
                R.add("body", "block", V3(0.12, 0.4, 0.25), CFrame.new(sx * 0.3, 3.85, -1.35) * CFrame.Angles(0, 0, sx * 0.5), BR)
                R.add("body", "block", V3(0.09, 0.9, 0.09), CFrame.new(sx * 0.25, 4.2, -1.4) * CFrame.Angles(0, 0, -sx * 0.35), HORN)
                R.add("body", "block", V3(0.09, 0.5, 0.09), CFrame.new(sx * 0.5, 4.55, -1.4) * CFrame.Angles(0, 0, -sx * 0.9), HORN)
                for _, fz in ipairs({-1, 1}) do
                    local g = ((sx < 0) and "l" or "r") .. ((fz < 0) and "f" or "b")
                    R.add(g, "cyl", V3(1.5, 0.3, 0.3), CFrame.new(sx * 0.3, 0.85, fz * 0.85) * VERT, BR)
                    R.add(g, "ball", V3(0.34, 0.34, 0.34), CFrame.new(sx * 0.3, 0.15, fz * 0.85), COAL)
                end
            end
            return R
        end

        local function buildSleigh(parent)
            local R = newRig(parent, 1.0)
            local SR = rgb(205, 30, 45)
            R.add("body", "block", V3(1.9, 0.5, 3.6), CFrame.new(0, 0.9, 0), SR)
            R.add("body", "block", V3(0.2, 0.8, 3.4), CFrame.new(-0.95, 1.4, 0), SR)
            R.add("body", "block", V3(0.2, 0.8, 3.4), CFrame.new(0.95, 1.4, 0), SR)
            R.add("body", "block", V3(1.9, 0.8, 0.2), CFrame.new(0, 1.35, -1.7), SR)
            R.add("body", "block", V3(1.9, 1.5, 0.25), CFrame.new(0, 1.7, 1.75), SR)
            R.add("body", "block", V3(1.95, 0.18, 0.3), CFrame.new(0, 2.5, 1.75), GOLD, NEON)
            R.add("body", "block", V3(1.5, 0.25, 1.2), CFrame.new(0, 1.2, 0.5), rgb(30, 110, 60))
            for _, sx in ipairs({-1, 1}) do
                R.add("body", "block", V3(0.14, 0.18, 4.2), CFrame.new(sx * 0.8, 0.4, 0.1), GOLD)
                R.add("body", "block", V3(0.14, 0.18, 0.9), CFrame.new(sx * 0.8, 0.78, -2.15) * CFrame.Angles(0.7, 0, 0), GOLD)
                R.add("body", "block", V3(0.12, 0.5, 0.12), CFrame.new(sx * 0.8, 0.65, 1.2), GOLD)
                R.add("body", "block", V3(0.12, 0.5, 0.12), CFrame.new(sx * 0.8, 0.65, -1.0), GOLD)
            end
            R.add("body", "block", V3(0.9, 0.9, 0.9), CFrame.new(0.4, 1.7, 1.15), rgb(60, 120, 230))
            R.add("body", "block", V3(0.95, 0.14, 0.95), CFrame.new(0.4, 1.7, 1.15), GOLD)
            R.add("body", "block", V3(0.7, 0.7, 0.7), CFrame.new(-0.45, 1.6, 1.0), rgb(40, 170, 90))
            R.add("body", "ball", V3(0.35, 0.35, 0.35), CFrame.new(0.9, 2.3, -1.5), GOLD, NEON)
            return R
        end

        local function buildCane(parent, base, s)
            local m = newModel(parent, "Cane")
            for i = 0, 3 do
                vcyl(m, base, 0, (0.3 + i * 0.6) * s, 0, 0.6 * s, 0.26 * s, (i % 2 == 0) and RED or SNOW)
            end
            mk(m, "cyl", V3(0.7 * s, 0.26 * s, 0.26 * s), base * CFrame.new(0.3 * s, 2.5 * s, 0), SNOW)
            vcyl(m, base, 0.6 * s, 2.35 * s, 0, 0.3 * s, 0.26 * s, RED)
        end

        -- ---------- tu personaje (clon) ----------
        local function buildPlayerModel(parent)
            local char = LP and LP.Character
            local deadline = os.clock() + 3
            while (not char or not char:FindFirstChild("HumanoidRootPart")) and os.clock() < deadline do
                task.wait(0.1)
                char = LP and LP.Character
            end
            local clone
            if char and char:FindFirstChild("HumanoidRootPart") then
                pcall(function()
                    local was = char.Archivable
                    char.Archivable = true
                    clone = char:Clone()
                    char.Archivable = was
                end)
            end
            if clone then
                for _, d in ipairs(clone:GetDescendants()) do
                    if d:IsA("BasePart") then
                        d.Anchored = true
                        d.CanCollide = false
                        d.CanTouch = false
                        d.CanQuery = false
                        d.CastShadow = false
                    elseif d:IsA("LuaSourceContainer") or d:IsA("Humanoid") or d:IsA("Sound") or d:IsA("BillboardGui")
                        or d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Beam") or d:IsA("Highlight") or d:IsA("ForceField") then
                        pcall(function() d:Destroy() end)
                    end
                end
                clone.Name = "IntroPlayer"
                clone.Parent = parent
                local pcallOk = pcall(function() clone:PivotTo(CFrame.new()) end)
                local ok, cf, sz = pcall(function() return clone:GetBoundingBox() end)
                if pcallOk and ok and cf and sz.Y > 1 then
                    return clone, -(cf.Position.Y - sz.Y / 2), sz.Y
                end
                pcall(function() clone:Destroy() end)
            end
            local m = newModel(parent, "IntroPlayer")
            local root = mk(m, "block", V3(0.2, 0.2, 0.2), CFrame.new(0, 2.5, 0), rgb(255, 255, 255))
            root.Transparency = 1
            m.PrimaryPart = root
            local SKIN = rgb(245, 205, 48)
            mk(m, "block", V3(0.8, 2, 0.8), CFrame.new(-0.4, 1, 0), rgb(50, 90, 170))
            mk(m, "block", V3(0.8, 2, 0.8), CFrame.new(0.4, 1, 0), rgb(50, 90, 170))
            mk(m, "block", V3(1.8, 2, 0.9), CFrame.new(0, 3, 0), rgb(40, 150, 90))
            mk(m, "block", V3(0.7, 2, 0.7), CFrame.new(-1.25, 3, 0), SKIN)
            mk(m, "block", V3(0.7, 2, 0.7), CFrame.new(1.25, 3, 0), SKIN)
            mk(m, "block", V3(1.3, 1.3, 1.3), CFrame.new(0, 4.6, 0), SKIN)
            return m, -2.5, 5.3
        end

        -- =====================================================================
        --                              ESCENA
        -- =====================================================================
        local cam0 = Workspace.CurrentCamera
        local vsz = cam0 and cam0.ViewportSize or V2(1280, 720)
        local SW, SH = vsz.X, vsz.Y
        if SW < 100 or SH < 100 then SW, SH = 1280, 720 end

        local gui = make("ScreenGui", nil, {
            Name = "VisibleIntro3D", ResetOnSpawn = false, IgnoreGuiInset = true,
            DisplayOrder = 10000, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        })
        mountGui(gui)

        -- cielo nocturno
        local sky = make("Frame", gui, {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 0, ZIndex = 1, ClipsDescendants = true})
        make("UIGradient", sky, {Rotation = 90, Color = ColorSequence.new({
            CSK(0, rgb(5, 9, 30)), CSK(0.5, rgb(18, 36, 84)), CSK(0.8, rgb(64, 102, 156)), CSK(1, rgb(120, 160, 205))})})

        -- velo oscuro: al inicio SOLO se ve a Santa; luego se descubre el resto
        local veil = make("Frame", gui, {Size = UDim2.fromScale(1, 1), BackgroundColor3 = rgb(5, 9, 30),
            BorderSizePixel = 0, ZIndex = 2})

        local stars = {}
        for i = 1, 55 do
            local sz = rnd(2, 3)
            local f = make("Frame", sky, {Position = UDim2.fromScale(rnd(), rnd() * 0.6), Size = UDim2.fromOffset(sz, sz),
                BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 1})
            make("UICorner", f, {CornerRadius = UDim.new(1, 0)})
            stars[i] = {f = f, ph = rnd() * 6.28, sp = 1 + rnd() * 2}
        end

        local function circle(parent, cx, cy, d, color, transp, z)
            local f = make("Frame", parent, {AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromScale(cx, cy),
                Size = UDim2.fromOffset(d, d), BackgroundColor3 = color, BackgroundTransparency = transp,
                BorderSizePixel = 0, ZIndex = z})
            make("UICorner", f, {CornerRadius = UDim.new(1, 0)})
            return f
        end
        circle(sky, 0.84, 0.2, SH * 0.36, rgb(255, 246, 210), 0.9, 1)
        circle(sky, 0.84, 0.2, SH * 0.25, rgb(255, 246, 210), 0.82, 1)
        local moon = circle(sky, 0.84, 0.2, SH * 0.17, rgb(250, 244, 220), 0, 1)
        circle(moon, 0.35, 0.38, SH * 0.035, rgb(226, 218, 190), 0, 1)
        circle(moon, 0.62, 0.58, SH * 0.05, rgb(230, 222, 196), 0, 1)
        circle(moon, 0.4, 0.72, SH * 0.025, rgb(226, 218, 190), 0, 1)

        local auroras = {}
        for i, d in ipairs({
            {y = 0.02, h = 0.40, c1 = rgb(90, 255, 190), c2 = rgb(70, 200, 255), rot = -7, sp = 0.35},
            {y = 0.10, h = 0.32, c1 = rgb(170, 120, 255), c2 = rgb(80, 255, 200), rot = 5, sp = 0.27},
        }) do
            local a = make("Frame", sky, {AnchorPoint = V2(0.5, 0), Position = UDim2.fromScale(0.5, d.y),
                Size = UDim2.fromScale(1.5, d.h), Rotation = d.rot, BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0, ZIndex = 1})
            make("UIGradient", a, {Rotation = 90, Color = ColorSequence.new(d.c1, d.c2),
                Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.35, 0.7),
                    NumberSequenceKeypoint.new(0.7, 0.85), NumberSequenceKeypoint.new(1, 1)})})
            auroras[i] = {f = a, d = d}
        end

        -- viewport 3D
        local vp = make("ViewportFrame", gui, {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 3,
            Ambient = rgb(125, 138, 184), LightColor = rgb(205, 218, 255), LightDirection = V3(-0.45, -0.75, -0.55)})
        local cam = Instance.new("Camera")
        cam.FieldOfView = 45
        cam.Parent = vp
        vp.CurrentCamera = cam
        local GROUND = -3.2

        local ground = newModel(vp, "Ground")
        do
            mk(ground, "block", V3(120, 2, 60), CFrame.new(0, GROUND - 1, -14), rgb(226, 236, 252), MAT_SNOW)
            local function mound(x, y, z, sx, sy, sz, color)
                local p = mk(ground, "block", V3(sx, sy, sz), CFrame.new(x, y, z), color or SNOW, MAT_SNOW)
                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = Enum.MeshType.Sphere
                mesh.Parent = p
            end
            mound(-12, GROUND + 1.0, -17, 38, 8, 12, rgb(210, 222, 244))
            mound(14, GROUND + 0.6, -19, 42, 9, 12, rgb(206, 218, 242))
            mound(-1, GROUND + 0.2, -12, 30, 5, 9, rgb(222, 232, 250))
            mound(-11, GROUND - 0.1, 3, 14, 2.0, 6)
            mound(12, GROUND - 0.1, 3.5, 14, 2.0, 6)
            mound(0, GROUND - 0.3, 5.5, 26, 1.6, 5)
        end

        local decor = newModel(vp, "Decor")
        for _, tr in ipairs({
            {-12.8, -1.5, 2.0}, {-8.5, -6, 1.8}, {14.2, -5, 2.2}, {6, -9, 1.6}, {-2, -10, 1.4},
            {10.5, -9, 1.8}, {-16, -4, 2.0}, {-4.5, -8, 1.3}, {1.5, -12, 1.5}, {-14, -10, 2.0},
        }) do
            buildTree(decor, CFrame.new(tr[1], GROUND, tr[2]) * CFrame.Angles(0, rnd() * 6.28, 0), tr[3])
        end
        buildSnowman(decor, CFrame.new(-9.8, GROUND, 2.0) * CFrame.Angles(0, 0.5, 0), 1.15, RED, "top")
        buildSnowman(decor, CFrame.new(13.0, GROUND, 2.6) * CFrame.Angles(0, -0.5, 0), 1.2, rgb(40, 160, 90), "santa")
        buildSnowman(decor, CFrame.new(-3.4, GROUND, -6.5) * CFrame.Angles(0, 0.3, 0), 1.3, rgb(255, 190, 60), "beanie")
        buildSnowman(decor, CFrame.new(2.6, GROUND, -7.2) * CFrame.Angles(0, -0.3, 0), 1.2, RED, "top")
        buildGift(decor, CFrame.new(-11.2, GROUND, 0.2) * CFrame.Angles(0, 0.3, 0), 1.6, RED, GOLD)
        buildGift(decor, CFrame.new(-10.2, GROUND, 0.9) * CFrame.Angles(0, -0.4, 0), 1.1, rgb(40, 150, 90), SNOW)
        buildGift(decor, CFrame.new(9.6, GROUND, 3.6) * CFrame.Angles(0, 0.4, 0), 1.4, rgb(70, 130, 230), rgb(255, 120, 150))
        buildGift(decor, CFrame.new(0.6, GROUND, 5.0) * CFrame.Angles(0, 0.2, 0), 1.0, rgb(255, 150, 60), SNOW)
        buildCane(decor, CFrame.new(-7.2, GROUND, 3.2), 1.0)
        buildCane(decor, CFrame.new(11.4, GROUND, 4.6) * CFrame.Angles(0, pi, 0), 1.0)
        buildCane(decor, CFrame.new(-1.6, GROUND, 4.4), 0.9)
        -- más cosas navideñas
        buildGift(decor, CFrame.new(-12.4, GROUND, 1.2) * CFrame.Angles(0, 0.7, 0), 1.3, rgb(150, 70, 200), GOLD)
        buildGift(decor, CFrame.new(-8.6, GROUND, 4.4) * CFrame.Angles(0, -0.2, 0), 1.2, rgb(255, 90, 90), SNOW)
        buildGift(decor, CFrame.new(11.0, GROUND, 4.9) * CFrame.Angles(0, 0.9, 0), 1.0, GOLD, RED)
        buildGift(decor, CFrame.new(14.6, GROUND, 3.4) * CFrame.Angles(0, -0.6, 0), 1.5, rgb(40, 150, 90), GOLD)
        buildGift(decor, CFrame.new(-2.6, GROUND, 6.2) * CFrame.Angles(0, 0.5, 0), 0.9, rgb(70, 130, 230), GOLD)
        buildCane(decor, CFrame.new(-13.4, GROUND, 3.0), 1.1)
        buildCane(decor, CFrame.new(8.2, GROUND, 5.4) * CFrame.Angles(0, pi, 0), 0.9)
        buildCane(decor, CFrame.new(3.8, GROUND, 6.0), 1.0)
        buildSnowman(decor, CFrame.new(-15.5, GROUND, -1.0) * CFrame.Angles(0, 0.6, 0), 1.0, rgb(50, 130, 235), "santa")

        -- Santa, trineo, renos (siempre visibles)
        local santa = buildSanta(vp)
        local sleigh = buildSleigh(vp)
        local deer1 = buildReindeer(vp, true)
        local deer2 = buildReindeer(vp, false)

        local trail = {}
        for i = 1, 16 do
            local p = mk(vp, "ball", V3(0.5, 0.5, 0.5), CFrame.new(0, -50, 0), LIGHT_COLORS[i % #LIGHT_COLORS + 1], NEON)
            trail[i] = {p = p, pos = V3(0, -50, 0)}
        end

        local playerModel, footOff, playerH = buildPlayerModel(vp)
        footOff = footOff or 0
        playerH = playerH or 5

        -- partes que se revelan DESPUÉS de que aparezca Santa
        local REVEAL_T, REVEAL_D = 3.0, 1.4
        local revealParts, revealK = {}, -1
        for _, root in ipairs({ground, decor, playerModel}) do
            if root then
                for _, d in ipairs(root:GetDescendants()) do
                    if d:IsA("BasePart") or d:IsA("Decal") then
                        revealParts[#revealParts + 1] = {p = d, o = d.Transparency}
                    end
                end
            end
        end

        -- ---------- capas 2D encima del 3D ----------
        local fx = make("Frame", gui, {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 5})
        local bokeh = {}
        for i = 1, 14 do
            local d = SH * (0.08 + rnd() * 0.16)
            local colr = ({rgb(255, 200, 120), rgb(255, 120, 120), rgb(120, 255, 170), rgb(140, 190, 255), rgb(255, 160, 220)})[rnd(1, 5)]
            local f = circle(fx, rnd(), rnd(), d, colr, 0.9 + rnd() * 0.07, 5)
            bokeh[i] = {f = f, x = rnd(), y = rnd(), sx = (rnd() - 0.5) * 0.02, sy = (rnd() - 0.5) * 0.015, ph = rnd() * 6.28}
        end
        local flakes = {}
        do
            local sizes = {2, 3, 3, 4, 4, 5, 6, 9}
            for i = 1, 120 do
                local size = sizes[rnd(1, #sizes)]
                local f = make("Frame", fx, {AnchorPoint = V2(0.5, 0.5), Size = UDim2.fromOffset(size, size),
                    BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 6,
                    BackgroundTransparency = (size >= 9) and 0.7 or (0.55 - size * 0.05)})
                make("UICorner", f, {CornerRadius = UDim.new(1, 0)})
                flakes[i] = {f = f, x = rnd(), y = rnd(), sp = 0.06 + size * 0.02 + rnd() * 0.04,
                    amp = 0.006 + rnd() * 0.015, fq = 0.6 + rnd() * 1.4, ph = rnd() * 6.28}
            end
        end

        -- ---------- globos de diálogo ----------
        local ui = make("Frame", gui, {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 20})
        local NAVY = rgb(20, 28, 62)

        local function makeBubble(fill, z)
            local b = {}
            local dark = make("Frame", ui, {AnchorPoint = V2(0.5, 0.5), Rotation = 45, BackgroundColor3 = NAVY,
                BorderSizePixel = 0, ZIndex = z, Visible = false})
            make("UICorner", dark, {CornerRadius = UDim.new(0, 4)})
            local holder = make("Frame", ui, {AnchorPoint = V2(0.5, 0.5), BackgroundTransparency = 1, ZIndex = z + 1, Visible = false})
            local sc = make("UIScale", holder, {Scale = 1})
            local ol = make("Frame", holder, {Size = UDim2.fromScale(1, 1), BackgroundColor3 = NAVY, BorderSizePixel = 0, ZIndex = z + 1})
            make("UICorner", ol, {CornerRadius = UDim.new(0, math.floor(SH * 0.07))})
            local fl = make("Frame", holder, {AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.new(1, -10, 1, -10), BackgroundColor3 = fill, BorderSizePixel = 0, ZIndex = z + 2})
            make("UICorner", fl, {CornerRadius = UDim.new(0, math.floor(SH * 0.06))})
            local tail = make("Frame", ui, {AnchorPoint = V2(0.5, 0.5), Rotation = 45, BackgroundColor3 = fill,
                BorderSizePixel = 0, ZIndex = z + 3, Visible = false})
            make("UICorner", tail, {CornerRadius = UDim.new(0, 3)})
            b.holder, b.fill, b.scale, b.dark, b.tail = holder, fl, sc, dark, tail
            function b.place(cx, cy, w, h, tx)
                holder.Position = UDim2.fromScale(cx, cy)
                holder.Size = UDim2.fromScale(w, h)
                local ts = math.floor(SH * 0.055)
                tail.Size = UDim2.fromOffset(ts, ts)
                dark.Size = UDim2.fromOffset(ts + 10, ts + 10)
                local by = cy + h / 2
                tail.Position = UDim2.fromScale(tx, by)
                dark.Position = UDim2.fromScale(tx, by)
            end
            function b.show(v)
                holder.Visible = v
                dark.Visible = v
                tail.Visible = v
            end
            return b
        end

        -- globo grande (tu personaje)
        local big = makeBubble(rgb(252, 252, 255), 20)
        local line1 = make("TextLabel", big.fill, {AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.26),
            Size = UDim2.fromScale(1, 0.3), BackgroundTransparency = 1, Font = Enum.Font.FredokaOne,
            Text = "¡BIENVENIDA A", TextSize = math.floor(SH * 0.095), TextColor3 = NAVY, ZIndex = 24, MaxVisibleGraphemes = 0})

        -- luces navideñas parpadeando alrededor del globo grande + adornos en las esquinas
        local bulbs = {}
        for row = 0, 1 do
            for i = 0, 13 do
                local b = make("Frame", big.holder, {AnchorPoint = V2(0.5, 0.5),
                    Position = UDim2.fromScale(0.07 + i / 13 * 0.86, row), Size = UDim2.fromOffset(11, 11),
                    BackgroundColor3 = LIGHT_COLORS[i % #LIGHT_COLORS + 1], BorderSizePixel = 0, ZIndex = 28})
                make("UICorner", b, {CornerRadius = UDim.new(1, 0)})
                make("UIStroke", b, {Color = NAVY, Thickness = 1.5})
                bulbs[#bulbs + 1] = b
            end
        end
        for _, o in ipairs({{0, 0, "🎄"}, {1, 0, "⭐"}, {0, 1, "🎁"}, {1, 1, "❄️"}}) do
            make("TextLabel", big.holder, {AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromScale(o[1], o[2]),
                Size = UDim2.fromOffset(SH * 0.1, SH * 0.1), BackgroundTransparency = 1, Text = o[3],
                TextSize = math.floor(SH * 0.075), ZIndex = 30})
        end

        local L = math.floor(math.min(SH * 0.2, SW * 0.08))
        local word = "VISIBLE!"
        local LETTER_COLORS = {rgb(235, 50, 60), rgb(40, 170, 80), rgb(50, 130, 235), rgb(255, 190, 40)}
        local letters = {}

        -- decoración navideña de cada letra: gorro de Santa en la "B", nieve encima del resto
        local function decorate(h, ci, ch)
            if ch == "!" then return end
            if ci == 1 then
                local body = make("Frame", h, {AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromScale(0.42, 0.06),
                    Size = UDim2.fromScale(0.62, 0.34), Rotation = -14, BackgroundColor3 = RED, BorderSizePixel = 0, ZIndex = 27})
                make("UICorner", body, {CornerRadius = UDim.new(0.5, 0)})
                make("UIStroke", body, {Color = NAVY, Thickness = 2})
                local brim = make("Frame", h, {AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.2),
                    Size = UDim2.fromScale(0.82, 0.1), Rotation = -4, BackgroundColor3 = SNOW, BorderSizePixel = 0, ZIndex = 28})
                make("UICorner", brim, {CornerRadius = UDim.new(1, 0)})
                make("UIStroke", brim, {Color = NAVY, Thickness = 2})
                local pom = make("Frame", h, {AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromScale(0.1, -0.06),
                    Size = UDim2.fromOffset(L * 0.17, L * 0.17), BackgroundColor3 = SNOW, BorderSizePixel = 0, ZIndex = 28})
                make("UICorner", pom, {CornerRadius = UDim.new(1, 0)})
                make("UIStroke", pom, {Color = NAVY, Thickness = 2})
            else
                local cap = make("Frame", h, {AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.2),
                    Size = UDim2.fromScale(0.68, 0.1), Rotation = (ci % 2 == 0) and -4 or 4,
                    BackgroundColor3 = SNOW, BorderSizePixel = 0, ZIndex = 27})
                make("UICorner", cap, {CornerRadius = UDim.new(1, 0)})
                make("UIStroke", cap, {Color = NAVY, Thickness = 1.5})
                for k = -1, 1, 2 do
                    local dr = make("Frame", h, {AnchorPoint = V2(0.5, 0), Position = UDim2.fromScale(0.5 + k * 0.17, 0.24),
                        Size = UDim2.fromOffset(L * 0.09, L * 0.1), BackgroundColor3 = SNOW, BorderSizePixel = 0, ZIndex = 27})
                    make("UICorner", dr, {CornerRadius = UDim.new(1, 0)})
                end
            end
        end

        do
            local widths, total = {}, 0
            for i = 1, #word do
                local ch = word:sub(i, i)
                widths[i] = (ch == " ") and L * 0.38 or ((ch == "!") and L * 0.36 or L * 0.64)
                total = total + widths[i]
            end
            local row = make("Frame", big.fill, {AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.68),
                Size = UDim2.fromOffset(total, L * 1.15), BackgroundTransparency = 1, ZIndex = 24})
            local x = 0
            local ci = 0
            for i = 1, #word do
                local ch = word:sub(i, i)
                if ch ~= " " then
                    ci = ci + 1
                    local color = LETTER_COLORS[(ci - 1) % 4 + 1]
                    local h = make("Frame", row, {AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromOffset(x + widths[i] / 2, L * 0.575),
                        Size = UDim2.fromOffset(widths[i] + 10, L * 1.15), BackgroundTransparency = 1, ZIndex = 25, Visible = false})
                    local us = make("UIScale", h, {Scale = 0.01})
                    for k = 4, 1, -1 do
                        make("TextLabel", h, {Size = UDim2.fromScale(1, 1), Position = UDim2.fromOffset(k * L * 0.03, k * L * 0.045),
                            BackgroundTransparency = 1, Text = ch, Font = Enum.Font.FredokaOne, TextSize = L,
                            TextColor3 = color:Lerp(Color3.new(0, 0, 0), 0.5), ZIndex = 25})
                    end
                    local top = make("TextLabel", h, {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = ch,
                        Font = Enum.Font.FredokaOne, TextSize = L, TextColor3 = color, ZIndex = 26})
                    make("UIStroke", top, {Color = NAVY, Thickness = math.max(2, L * 0.05)})
                    decorate(h, ci, ch)
                    letters[#letters + 1] = {h = h, us = us, x = x + widths[i] / 2, idx = #letters}
                end
                x = x + widths[i]
            end
        end

        -- globos pequeños de Santa
        local function makeSantaBubble(text)
            local b = makeBubble(rgb(205, 30, 45), 30)
            local lb = make("TextLabel", b.fill, {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
                Font = Enum.Font.FredokaOne, Text = text, TextColor3 = Color3.new(1, 1, 1), TextScaled = true, ZIndex = 34})
            make("UITextSizeConstraint", lb, {MaxTextSize = math.floor(SH * 0.075), MinTextSize = 8})
            make("UIPadding", lb, {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6)})
            make("UIStroke", lb, {Color = rgb(110, 10, 20), Thickness = 1.5})
            return b
        end
        local santaB1 = makeSantaBubble("¡JO JO JO!")
        local santaB2 = makeSantaBubble("¡FELIZ NAVIDAD VISIBLE!")

        -- confeti
        local confetti = {}
        local function burst(cx, cy, n)
            for i = 1, n do
                local size = rnd(6, 12)
                local f = make("Frame", ui, {AnchorPoint = V2(0.5, 0.5), Position = UDim2.fromScale(cx, cy),
                    Size = UDim2.fromOffset(size, size * (0.5 + rnd())), BackgroundColor3 = LETTER_COLORS[rnd(1, 4)],
                    BorderSizePixel = 0, ZIndex = 40, Rotation = rnd() * 360})
                local ang = rnd() * pi * 2
                local spd = 0.25 + rnd() * 0.55
                confetti[#confetti + 1] = {f = f, x = cx, y = cy, vx = cos(ang) * spd * 0.6, vy = sin(ang) * spd - 0.25,
                    vr = (rnd() - 0.5) * 600, life = 1.8 + rnd() * 0.8, age = 0}
            end
        end

        -- fundido y botón de saltar
        local fade = make("Frame", gui, {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0, ZIndex = 200})
        local skipBtn = make("TextButton", gui, {AnchorPoint = V2(1, 1), Position = UDim2.new(1, -16, 1, -14),
            Size = UDim2.fromOffset(math.floor(SH * 0.3), math.floor(SH * 0.085)), BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 0.45, Text = "SALTAR  ›", TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBold,
            TextSize = math.floor(SH * 0.04), AutoButtonColor = true, ZIndex = 210})
        make("UICorner", skipBtn, {CornerRadius = UDim.new(0, 12)})
        make("UIStroke", skipBtn, {Color = Color3.new(1, 1, 1), Transparency = 0.6, Thickness = 1.2})

        local function proj(p)
            local rel = cam.CFrame:PointToObjectSpace(p)
            local depth = -rel.Z
            if depth < 0.5 then depth = 0.5 end
            local tanY = math.tan(math.rad(cam.FieldOfView / 2))
            local aspect = SW / SH
            return 0.5 + (rel.X / depth / (tanY * aspect)) * 0.5, 0.5 - (rel.Y / depth / tanY) * 0.5
        end

        -- ---------- línea de tiempo ----------
        local T_LAND = 3.7
        local LAND_X, LAND_Z = 9.0, -3.2
        local SANTA_END = V3(3.4, GROUND + 0.1, 0.8)
        local PLAYER_POS = V3(-4.6, GROUND, 1.0)
        local YAW_SANTA = pi / 2 + 0.4
        local YAW_PLAYER = -pi / 2 - 0.4

        local t = 0
        local burst_done = false
        local done = false
        local conn
        local hist, histT = {}, 0

        local function finish()
            if done then return end
            done = true
            if conn then conn:Disconnect() end
            pcall(function() gui:Destroy() end)
            pcall(signalDone)
        end
        skipBtn.Activated:Connect(finish)

        local function step(dt)
            if isDone() then finish() return end
            if dt > 0.1 then dt = 0.1 end
            t = t + dt

            local fa = 0
            if t < 0.8 then fa = 1 - t / 0.8 end
            if t > DURATION - 0.9 then fa = clamp01((t - (DURATION - 0.9)) / 0.9) end
            fade.BackgroundTransparency = 1 - fa

            -- revelado del mundo (después de Santa)
            local rk = clamp01((t - REVEAL_T) / REVEAL_D)
            if rk ~= revealK then
                revealK = rk
                for _, rp in ipairs(revealParts) do
                    rp.p.Transparency = 1 - (1 - rp.o) * rk
                end
                veil.BackgroundTransparency = rk
            end
            for i, b in ipairs(bulbs) do
                b.BackgroundColor3 = LIGHT_COLORS[(math.floor(t * 3 + i) % #LIGHT_COLORS) + 1]
            end

            local zc = lerp(19.5, 16.8, easeInOut(clamp01(t / DURATION)))
            cam.CFrame = CFrame.lookAt(V3(sin(t * 0.3) * 0.7, 3.0, zc), V3(0, 2.2, 0))

            local u = clamp01((t - 0.3) / 3.4)
            local sx = lerp(-26, LAND_X, easeOutCubic(u))
            local sy = GROUND - 0.29 + 9.8 * (1 - u) ^ 2 + sin(t * 3) * 0.15 * (1 - u)
            local pitch = -0.35 * (1 - u)
            local sleighBase = CFrame.new(sx, sy, LAND_Z) * CFrame.Angles(0, -pi / 2, 0) * CFrame.Angles(pitch, 0, 0)
            sleigh.pose(sleighBase, nil)
            local gal = t * 11
            local amp = 0.7 * (1 - u)
            local function deerPose(d, offX, offZ, ph)
                local pos = V3(sx + offX, sy + 0.31, LAND_Z + offZ)
                d.pose(CFrame.new(pos) * CFrame.Angles(0, -pi / 2, 0) * CFrame.Angles(pitch, 0, 0), {
                    fl = CFrame.Angles(sin(gal + ph) * amp, 0, 0), fr = CFrame.Angles(-sin(gal + ph) * amp, 0, 0),
                    bl = CFrame.Angles(-sin(gal + ph) * amp, 0, 0), br = CFrame.Angles(sin(gal + ph) * amp, 0, 0),
                })
            end
            deerPose(deer1, 4.6, -0.9, 0)
            deerPose(deer2, 4.6, 0.9, 1.5)

            histT = histT + dt
            if histT > 0.04 and u < 1 then
                histT = 0
                table.insert(hist, 1, V3(sx - 2.5 + (rnd() - 0.5), sy + 0.6 + (rnd() - 0.5) * 0.6, LAND_Z + (rnd() - 0.5)))
                if #hist > #trail then table.remove(hist) end
            end
            for i, tr in ipairs(trail) do
                local hp = hist[i]
                if hp and u < 1 then
                    local sz = 0.55 * (1 - i / (#trail + 2))
                    tr.p.Size = V3(sz, sz, sz)
                    tr.p.Position = hp
                else
                    tr.p.Position = V3(0, -50, 0)
                end
            end

            -- Santa
            local sPos, sYaw, walkPh, wave, bob = V3(), 0, 0, nil, 0
            if t < T_LAND then
                sPos = V3(sx - 0.4, sy + 1.25, LAND_Z)
                sYaw = -pi / 2
                wave = "R"
            elseif t < 4.4 then
                local k = (t - T_LAND) / 0.7
                local e = easeInOut(k)
                local from = V3(LAND_X - 0.4, GROUND + 0.96, LAND_Z)
                local to = V3(6.6, GROUND + 0.1, -0.6)
                sPos = from:Lerp(to, e) + V3(0, sin(pi * k) * 1.8, 0)
                sYaw = lerp(3 * pi / 2, YAW_SANTA, e)
                wave = "L"
            elseif t < 6.4 then
                local k = (t - 4.4) / 2.0
                local e = easeInOut(k)
                sPos = V3(lerp(6.6, SANTA_END.X, e), GROUND + 0.1, lerp(-0.6, SANTA_END.Z, e))
                sYaw = YAW_SANTA
                walkPh = t * 9
                bob = abs(sin(t * 9)) * 0.12
                wave = "L"
            else
                sPos = SANTA_END
                sYaw = YAW_SANTA
                wave = "L"
                if t < 7.3 then bob = abs(sin((t - 6.4) * 7)) * 0.35 end
                if t > 12.3 and t < 13.6 then bob = abs(sin((t - 12.3) * 6)) * 0.3 end
            end
            local rots = {
                legL = CFrame.Angles(sin(walkPh) * 0.6, 0, 0), legR = CFrame.Angles(-sin(walkPh) * 0.6, 0, 0),
                armL = CFrame.Angles(-sin(walkPh) * 0.5, 0, 0), armR = CFrame.Angles(sin(walkPh) * 0.5, 0, 0),
                head = CFrame.Angles(sin(t * 2) * 0.05, 0, 0),
            }
            if wave == "L" then rots.armL = CFrame.Angles(0, 0, -(2.3 + sin(t * 9) * 0.35)) end
            if wave == "R" then rots.armR = CFrame.Angles(0, 0, (2.3 + sin(t * 9) * 0.35)) end
            santa.pose(CFrame.new(sPos + V3(0, bob, 0)) * CFrame.Angles(0, sYaw, 0), rots)

            -- tu personaje
            local pYaw = pi
            if t > 5.8 then pYaw = lerp(pi, 2 * pi + YAW_PLAYER, easeInOut(clamp01((t - 5.8) / 0.8))) end
            local hop = 0
            if t > 7.4 and t < 12.0 then hop = abs(sin(t * 5)) * 0.28 end
            if t > 6.3 and t < 7.0 then hop = abs(sin((t - 6.3) * 9)) * 0.4 end
            if playerModel then
                pcall(function()
                    playerModel:PivotTo(CFrame.new(PLAYER_POS.X, GROUND + footOff + hop + 0.05, PLAYER_POS.Z) * CFrame.Angles(0, pYaw, 0))
                end)
            end

            for _, l in ipairs(NP.lights) do
                local idx = (math.floor(t * 2.2 + l.i) % #LIGHT_COLORS) + 1
                if l.last ~= idx then
                    l.last = idx
                    l.p.Color = LIGHT_COLORS[idx]
                end
            end

            for _, s in ipairs(stars) do
                s.f.BackgroundTransparency = 0.15 + 0.7 * (0.5 - 0.5 * sin(t * s.sp + s.ph))
            end
            for i, au in ipairs(auroras) do
                au.f.Position = UDim2.fromScale(0.5 + sin(t * au.d.sp + i * 2) * 0.08, au.d.y + sin(t * 0.5 + i) * 0.02)
                au.f.Rotation = au.d.rot + sin(t * 0.4 + i * 1.7) * 3
            end
            for _, bk in ipairs(bokeh) do
                bk.x = (bk.x + bk.sx * dt) % 1
                bk.y = (bk.y + bk.sy * dt) % 1
                bk.f.Position = UDim2.fromScale(bk.x, bk.y + sin(t * 0.6 + bk.ph) * 0.01)
            end
            for _, fl in ipairs(flakes) do
                fl.y = fl.y + fl.sp * dt
                fl.x = fl.x + 0.01 * dt
                if fl.x > 1.03 then fl.x = -0.03 end
                if fl.y > 1.04 then fl.y = -0.04; fl.x = rnd() end
                fl.f.Position = UDim2.fromScale(fl.x + sin(t * fl.fq + fl.ph) * fl.amp, fl.y)
            end

            -- diálogos
            local sHeadX, sHeadY = proj(sPos + V3(0, 7.4, 0))
            sHeadX = math.clamp(sHeadX, 0.18, 0.84)
            local function popScale(b, k)
                b.scale.Scale = math.max(easeOutBack(clamp01(k)), 0.01)
            end

            -- Santa: "¡JO JO JO!" (primero solo, volando; luego otra vez al saludar)
            local b1Start = (t < 3) and 1.0 or 6.2
            if (t >= 1.0 and t < 2.6) or (t >= 6.2 and t < 7.3) then
                santaB1.show(true)
                popScale(santaB1, (t - b1Start) / 0.3)
                santaB1.place(sHeadX + 0.07, math.max(sHeadY - 0.13, 0.1), 0.27, 0.15, sHeadX)
            else
                santaB1.show(false)
            end

            -- Tu personaje: globo grande
            local pHeadX, pHeadY = proj(PLAYER_POS + V3(0, playerH + 1.0, 0))
            if t >= 7.4 and t < 12.0 then
                big.show(true)
                local k = clamp01((t - 7.4) / 0.35)
                local kOut = clamp01((12.0 - t) / 0.25)
                popScale(big, math.min(k, kOut > 0 and 1 or 0))
                if kOut < 1 then big.scale.Scale = math.max(kOut, 0.01) end
                big.place(0.40, 0.27, 0.64, 0.45, math.clamp(pHeadX, 0.16, 0.62))
                local chars = math.floor(math.max(0, t - 7.6) / 0.07)
                line1.MaxVisibleGraphemes = math.min(chars, 13)
                for _, lt in ipairs(letters) do
                    local at = 8.7 + lt.idx * 0.1
                    if t >= at then
                        lt.h.Visible = true
                        local kk = clamp01((t - at) / 0.35)
                        lt.us.Scale = math.max(easeOutBack(kk), 0.01)
                        lt.h.Rotation = (1 - kk) * ((lt.idx % 2 == 0) and -14 or 14)
                        lt.h.Position = UDim2.fromOffset(lt.x, L * 0.575 + sin(t * 5 + lt.idx) * L * 0.03 * kk)
                    end
                end
            else
                big.show(false)
            end
            if not burst_done and t >= 9.7 then
                burst_done = true
                burst(0.40, 0.30, 55)
            end

            -- Santa: despedida
            if t >= 12.3 and t < DURATION - 0.8 then
                santaB2.show(true)
                popScale(santaB2, (t - 12.3) / 0.3)
                santaB2.place(sHeadX, math.max(sHeadY - 0.13, 0.1), 0.42, 0.16, sHeadX)
            else
                santaB2.show(false)
            end

            for i = #confetti, 1, -1 do
                local c = confetti[i]
                c.age = c.age + dt
                if c.age >= c.life then
                    c.f:Destroy()
                    table.remove(confetti, i)
                else
                    c.vy = c.vy + 0.9 * dt
                    c.x = c.x + c.vx * dt
                    c.y = c.y + c.vy * dt
                    c.f.Position = UDim2.fromScale(c.x, c.y)
                    c.f.Rotation = c.f.Rotation + c.vr * dt
                    c.f.BackgroundTransparency = clamp01((c.age - (c.life - 0.5)) / 0.5)
                end
            end

            if t >= DURATION then finish() end
        end

        conn = RunService.RenderStepped:Connect(function(dt)
            local ok, err = pcall(step, dt)
            if not ok then
                warn("[Visible Intro] " .. tostring(err))
                finish()
            end
        end)
    end
end

-- ===== MÚSICA AL EJECUTAR (17.60s, sin GUI) =====
local function playVisibleIntro(onDone)
    onDone = onDone or function() end
    local finished = false
    local INTRO_DURATION = 17.60

    local function finish()
        if finished then return end
        finished = true
        pcall(function()
            local s = game:GetService("SoundService"):FindFirstChild("VisibleIntroSound")
            if s then s:Stop(); s:Destroy() end
        end)
        task.defer(onDone)
    end

    task.spawn(function()
        local url = "https://mp3tourl.com/audio/1794985247563-86093764-154c-4319-bdfd-0c8c6b1d2590.mp3"
        local fname = "A_New_king_of_love.mp3"
        local loader = getcustomasset or getsynasset
        local asset
        pcall(function()
            if type(isfile) == "function" and isfile(fname) and type(loader) == "function" then
                asset = loader(fname)
            elseif type(writefile) == "function" and type(loader) == "function" then
                local data = game:HttpGet(url)
                if type(data) == "string" and #data > 500 then
                    writefile(fname, data)
                    asset = loader(fname)
                end
            end
        end)
        if asset and not _G.__VisibleIntroClosed then
            local snd = Instance.new("Sound")
            snd.Name = "VisibleIntroSound"
            snd.SoundId = asset
            snd.Volume = 0.9
            snd.Looped = true
            snd.Parent = game:GetService("SoundService")
            pcall(function() snd:Play() end)
        end
    end)

    -- Sin opción de saltar: la canción siempre dura los 17.60 segundos
    task.delay(INTRO_DURATION, function()
        finish()
    end)
end

-- ===== INTRO VISIBLE HUB: alas que caen + logo V + letras en onda (de visible_hub_intro.lua) =====
-- La canción (playVisibleIntro) suena mientras la intro está visible. Se cierra con doble toque.
do
    _G.__VisibleIntro = function(onDone)
        local TweenService = game:GetService("TweenService")
        local UserInputService = game:GetService("UserInputService")
        local PlayersSvc = game:GetService("Players")
        local session = _mySession

        -- ====== CONFIGURACIÓN ======
        local TEXTO = "VISIBLE HUB"
        local LOGO_LETRA = "V"
        local AUTO_CERRAR = false   -- true = se cierra sola después de TIEMPO_VISIBLE
        local TIEMPO_VISIBLE = 14   -- segundos (solo si AUTO_CERRAR = true)
        -- ===========================

        pcall(function()
            for _, par in ipairs({game:GetService("CoreGui"), PlayersSvc.LocalPlayer:FindFirstChildOfClass("PlayerGui")}) do
                local old = par and par:FindFirstChild("VisibleHubIntro")
                if old then old:Destroy() end
            end
        end)

        local gui = Instance.new("ScreenGui")
        gui.Name = "VisibleHubIntro"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.DisplayOrder = 999
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
        local okp = pcall(function() gui.Parent = game:GetService("CoreGui") end)
        if not okp or not gui.Parent then gui.Parent = PlayersSvc.LocalPlayer:WaitForChild("PlayerGui") end

        local holder = Instance.new("Frame")
        holder.Name = "Holder"
        holder.AnchorPoint = Vector2.new(0.5, 0.5)
        holder.Position = UDim2.fromScale(0.5, 0.5)
        holder.Size = UDim2.fromOffset(1000, 500)
        holder.BackgroundTransparency = 1
        holder.Parent = gui

        local scale = Instance.new("UIScale")
        scale.Parent = holder
        local function ajustarEscala()
            local cam = workspace.CurrentCamera
            if not cam then return end
            local v = cam.ViewportSize
            scale.Scale = math.min(v.X / 1000, v.Y / 500)
        end
        ajustarEscala()
        local scaleConn
        if workspace.CurrentCamera then
            scaleConn = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(ajustarEscala)
        end

        local function redondear(obj, radio)
            local c = Instance.new("UICorner")
            c.CornerRadius = radio
            c.Parent = obj
        end
        local function borde(obj, color, grosor)
            local s = Instance.new("UIStroke")
            s.Color = color
            s.Thickness = grosor
            s.Parent = obj
            return s
        end

        -- ====== ALAS ======
        local PLUMAS = {
            {300, 140}, {270, 114}, {240, 90}, {210, 68}, {182, 48}, {155, 30}, {128, 14},
        }
        local RAIZ_Y = 200
        local function crearAla(lado)
            local grupo = Instance.new("Frame")
            grupo.Name = lado == -1 and "AlaIzq" or "AlaDer"
            grupo.AnchorPoint = Vector2.new(0.5, 0.5)
            grupo.Size = UDim2.fromOffset(0, 0)
            grupo.Position = UDim2.fromOffset(500 + lado * 60, RAIZ_Y - 450)
            grupo.BackgroundTransparency = 1
            grupo.Parent = holder
            for _, p in ipairs(PLUMAS) do
                local largo = math.sqrt(p[1] ^ 2 + p[2] ^ 2)
                local ang = math.deg(math.atan2(p[2], p[1]))
                local pluma = Instance.new("Frame")
                pluma.BackgroundColor3 = Color3.fromRGB(11, 11, 12)
                pluma.BorderSizePixel = 0
                pluma.Size = UDim2.fromOffset(largo, 24)
                if lado == 1 then
                    pluma.AnchorPoint = Vector2.new(0, 0.5)
                    pluma.Rotation = -ang
                else
                    pluma.AnchorPoint = Vector2.new(1, 0.5)
                    pluma.Rotation = ang
                end
                pluma.Position = UDim2.fromOffset(0, 0)
                redondear(pluma, UDim.new(0.5, 0))
                borde(pluma, Color3.new(1, 1, 1), 3)
                pluma.Parent = grupo
            end
            return grupo
        end
        local alaIzq = crearAla(-1)
        local alaDer = crearAla(1)

        -- ====== LOGO ======
        local logo = Instance.new("Frame")
        logo.Name = "Logo"
        logo.AnchorPoint = Vector2.new(0.5, 0.5)
        logo.Position = UDim2.fromOffset(500, 215)
        logo.Size = UDim2.fromOffset(0, 0)
        logo.Rotation = -135
        logo.BackgroundColor3 = Color3.fromRGB(11, 11, 12)
        logo.BorderSizePixel = 0
        logo.ZIndex = 5
        redondear(logo, UDim.new(0.18, 0))
        borde(logo, Color3.new(1, 1, 1), 5)
        logo.Parent = holder

        local letraLogo = Instance.new("TextLabel")
        letraLogo.AnchorPoint = Vector2.new(0.5, 0.5)
        letraLogo.Position = UDim2.fromScale(0.5, 0.5)
        letraLogo.Size = UDim2.fromScale(1, 1)
        letraLogo.Rotation = -45
        letraLogo.BackgroundTransparency = 1
        letraLogo.Text = LOGO_LETRA
        letraLogo.Font = Enum.Font.GothamBlack
        letraLogo.TextScaled = true
        letraLogo.TextColor3 = Color3.new(1, 1, 1)
        letraLogo.ZIndex = 6
        letraLogo.Parent = logo

        -- ====== TEXTO ======
        local ANCHOS = { I = 36, [" "] = 44 }
        local ANCHO_NORMAL = 72
        local letras = {}
        local total = 0
        for i = 1, #TEXTO do
            local c = TEXTO:sub(i, i)
            total += ANCHOS[c] or ANCHO_NORMAL
        end
        local x = 500 - total / 2
        local TEXTO_Y = 330
        for i = 1, #TEXTO do
            local c = TEXTO:sub(i, i)
            local w = ANCHOS[c] or ANCHO_NORMAL
            if c ~= " " then
                local l = Instance.new("TextLabel")
                l.AnchorPoint = Vector2.new(0, 0.5)
                l.Position = UDim2.fromOffset(x, TEXTO_Y + 90)
                l.Size = UDim2.fromOffset(w, 100)
                l.BackgroundTransparency = 1
                l.Text = c
                l.Font = Enum.Font.GothamBlack
                l.TextSize = 92
                l.TextColor3 = Color3.new(1, 1, 1)
                l.TextStrokeColor3 = Color3.new(0, 0, 0)
                l.TextStrokeTransparency = 0
                l.TextTransparency = 1
                l.Rotation = -15
                l.ZIndex = 7
                l.Parent = holder
                table.insert(letras, { label = l, x = x, w = w })
            end
            x += w
        end

        -- ====== WELCOME ======
        local pill = Instance.new("Frame")
        pill.AnchorPoint = Vector2.new(0.5, 0.5)
        pill.Position = UDim2.fromOffset(500, 445)
        pill.Size = UDim2.fromOffset(250, 38)
        pill.BackgroundColor3 = Color3.fromRGB(11, 11, 12)
        pill.BackgroundTransparency = 1
        redondear(pill, UDim.new(0.5, 0))
        local pillStroke = borde(pill, Color3.fromRGB(70, 70, 70), 1)
        pillStroke.Transparency = 1
        pill.Parent = holder

        local welcome = Instance.new("TextLabel")
        welcome.Size = UDim2.fromScale(1, 1)
        welcome.BackgroundTransparency = 1
        welcome.Text = "W E L C O M E"
        welcome.Font = Enum.Font.GothamMedium
        welcome.TextSize = 13
        welcome.TextColor3 = Color3.new(1, 1, 1)
        welcome.TextTransparency = 1
        welcome.Parent = pill

        -- ====== DESTELLOS ======
        local destellos = {}
        local POS_DESTELLOS = {
            { 240, 130 }, { 70, 250 }, { 800, 110 }, { 920, 280 },
            { 360, 150 }, { 620, 140 }, { 180, 400 }, { 840, 410 },
        }
        for _, p in ipairs(POS_DESTELLOS) do
            local s = Instance.new("TextLabel")
            s.AnchorPoint = Vector2.new(0.5, 0.5)
            s.Position = UDim2.fromOffset(p[1], p[2])
            s.Size = UDim2.fromOffset(30, 30)
            s.BackgroundTransparency = 1
            s.Text = "✦"
            s.TextColor3 = Color3.new(1, 1, 1)
            s.TextSize = 26
            s.TextTransparency = 1
            s.Parent = holder
            table.insert(destellos, s)
        end

        -- ====== CIERRE ======
        local finished, closing = false, false
        local tapConn
        local function finish()
            if finished then return end
            finished = true
            if tapConn then tapConn:Disconnect() end
            if scaleConn then scaleConn:Disconnect() end
            _G.__VisibleIntroClosed = true
            pcall(function()
                local snd = game:GetService("SoundService"):FindFirstChild("VisibleIntroSound")
                if snd then snd:Stop(); snd:Destroy() end
            end)
            pcall(function() gui:Destroy() end)
            if onDone then task.defer(onDone) end
        end
        local function cerrar()
            if closing or finished then return end
            closing = true
            local salida = TweenInfo.new(0.6)
            for _, d in ipairs(gui:GetDescendants()) do
                if d:IsA("TextLabel") then
                    TweenService:Create(d, salida, { TextTransparency = 1, TextStrokeTransparency = 1 }):Play()
                elseif d:IsA("Frame") then
                    TweenService:Create(d, salida, { BackgroundTransparency = 1 }):Play()
                elseif d:IsA("UIStroke") then
                    TweenService:Create(d, salida, { Transparency = 1 }):Play()
                end
            end
            task.delay(0.7, finish)
        end

        -- doble toque / doble clic para cerrar
        do
            local lastTap = -10
            tapConn = UserInputService.InputBegan:Connect(function(input)
                if finished or closing then return end
                local ut = input.UserInputType
                if ut ~= Enum.UserInputType.Touch and ut ~= Enum.UserInputType.MouseButton1 then return end
                local now = tick()
                if now - lastTap <= 0.6 then cerrar() else lastTap = now end
            end)
        end

        -- se descarta si se ejecutó una instancia nueva
        task.spawn(function()
            while not finished do
                if session ~= _G.VisibleHubSession then
                    finished = true
                    if tapConn then tapConn:Disconnect() end
                    if scaleConn then scaleConn:Disconnect() end
                    pcall(function() gui:Destroy() end)
                    return
                end
                task.wait(0.25)
            end
        end)

        -- ====== ANIMACIÓN ======
        local function tween(obj, info, props)
            local t = TweenService:Create(obj, info, props)
            t:Play()
            return t
        end
        local function alive() return not finished and not closing end

        tween(alaIzq, TweenInfo.new(1.1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), { Position = UDim2.fromOffset(440, RAIZ_Y) })
        tween(alaDer, TweenInfo.new(1.1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), { Position = UDim2.fromOffset(560, RAIZ_Y) })

        task.delay(0.7, function()
            if not alive() then return end
            tween(logo, TweenInfo.new(0.9, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(210, 210), Rotation = 45,
            })
        end)

        task.delay(1.4, function()
            if not alive() then return end
            local flap = TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
            tween(alaIzq, flap, { Rotation = 7 })
            tween(alaDer, flap, { Rotation = -7 })
            tween(logo, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                Size = UDim2.fromOffset(222, 222),
            })
        end)

        for i, d in ipairs(letras) do
            task.delay(1.4 + i * 0.09, function()
                if not alive() then return end
                tween(d.label, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Position = UDim2.fromOffset(d.x, TEXTO_Y), TextTransparency = 0, Rotation = 0,
                })
            end)
            task.delay(2.6 + i * 0.12, function()
                if not alive() then return end
                tween(d.label, TweenInfo.new(1.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                    Position = UDim2.fromOffset(d.x, TEXTO_Y - 12),
                })
            end)
        end

        task.delay(2.8, function()
            if not alive() then return end
            local fade = TweenInfo.new(0.8)
            tween(pill, fade, { BackgroundTransparency = 0 })
            tween(pillStroke, fade, { Transparency = 0 })
            tween(welcome, fade, { TextTransparency = 0 })
        end)

        for i, s in ipairs(destellos) do
            task.delay(1.5 + i * 0.15, function()
                if not alive() then return end
                tween(s, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { TextTransparency = 0 })
                tween(s, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), { Rotation = 360 })
            end)
        end

        if AUTO_CERRAR then
            task.delay(TIEMPO_VISIBLE + 2, cerrar)
        end
    end
end

-- La intro aparece PRIMERO; el resto del hub se carga cuando se cierra con doble toque.
do
    local introDone = false
    _G.__VisibleIntroClosed = false
    task.spawn(function()
        pcall(playVisibleIntro)
    end)
    local okIntro = pcall(_G.__VisibleIntro, function() introDone = true end)
    if not okIntro then introDone = true end
    while not introDone and _mySession == _G.VisibleHubSession do
        task.wait(0.05)
    end
end
if _mySession ~= _G.VisibleHubSession then return end

local VISIBLEHUB_LANGUAGE = "en"

local VISIBLEHUB_TRANSLATIONS = {
    es = { ["RESET ALL SETTINGS"]="RESTABLECER TODO", ["SETTINGS RESET"]="AJUSTES RESTABLECIDOS", ["CONFIRM?"]="¿CONFIRMAR?", ["ERROR"]="ERROR", ["RESET"]="RESTABLECER", ["Keybinds"]="TECLAS", ["Carry Mode"]="MODO CARGAR", ["Lagger Mode"]="MODO LAG", ["Auto Left"]="AUTO IZQUIERDA", ["Auto Right"]="AUTO DERECHA", ["Auto Bat"]="AUTO BATE", ["TP Down"]="TP ABAJO", ["Drop Brainrot"]="SOLTAR BRAINROT", ["Hide GUI"]="OCULTAR MENÚ", ["Normal Speed"]="VELOCIDAD NORMAL", ["Carry Speed"]="VELOCIDAD CARGAR", ["Current Mode"]="MODO ACTUAL", ["ACTIVATE"]="ACTIVAR" },
    pt = { ["RESET ALL SETTINGS"]="REDEFINIR TUDO", ["SETTINGS RESET"]="CONFIGURAÇÕES REDEFINIDAS", ["CONFIRM?"]="CONFIRMAR?", ["ERROR"]="ERRO", ["RESET"]="REDEFINIR", ["Keybinds"]="TECLAS", ["Carry Mode"]="MODO CARREGAR", ["Auto Left"]="AUTO ESQUERDA", ["Auto Right"]="AUTO DIREITA", ["Hide GUI"]="OCULTAR MENU", ["Normal Speed"]="VELOCIDADE NORMAL", ["Carry Speed"]="VELOCIDADE CARREGAR", ["ACTIVATE"]="ATIVAR" },
    fr = { ["RESET ALL SETTINGS"]="RÉINITIALISER", ["SETTINGS RESET"]="PARAMÈTRES RÉINITIALISÉS", ["CONFIRM?"]="CONFIRMER ?", ["ERROR"]="ERREUR", ["RESET"]="RÉINITIALISER", ["Keybinds"]="RACCOURCIS", ["Carry Mode"]="MODE PORTER", ["Auto Left"]="AUTO GAUCHE", ["Auto Right"]="AUTO DROITE", ["Hide GUI"]="MASQUER LE MENU", ["Normal Speed"]="VITESSE NORMALE", ["Carry Speed"]="VITESSE PORTER", ["ACTIVATE"]="ACTIVER" },
    de = { ["RESET ALL SETTINGS"]="ALLES ZURÜCKSETZEN", ["SETTINGS RESET"]="EINSTELLUNGEN ZURÜCKGESETZT", ["CONFIRM?"]="BESTÄTIGEN?", ["ERROR"]="FEHLER", ["RESET"]="ZURÜCKSETZEN", ["Keybinds"]="TASTEN", ["Carry Mode"]="TRAGEMODUS", ["Auto Left"]="AUTO LINKS", ["Auto Right"]="AUTO RECHTS", ["Hide GUI"]="MENÜ AUSBLENDEN", ["Normal Speed"]="NORMALE GESCHWINDIGKEIT", ["Carry Speed"]="TRAGEGESCHWINDIGKEIT", ["ACTIVATE"]="AKTIVIEREN" },
}

local function localizeVisibleHubInterface(root)
    local dictionary = VISIBLEHUB_TRANSLATIONS[VISIBLEHUB_LANGUAGE]
    if not dictionary or not root then return end
    for _, object in ipairs(root:GetDescendants()) do
        if object:IsA("TextLabel") or object:IsA("TextButton") then
            local source = object:GetAttribute("VisibleHubSourceText") or object.Text
            object:SetAttribute("VisibleHubSourceText", source)
            local translated = dictionary[source]
            if translated then object.Text = translated end
        end
    end
end

local function visibleHubTranslate(source)
    local dictionary = VISIBLEHUB_TRANSLATIONS[VISIBLEHUB_LANGUAGE]
    return (dictionary and dictionary[source]) or source
end

local _tick          = tick
local _clamp         = math.clamp
local _floor         = math.floor
local _abs           = math.abs
local _huge          = math.huge
local _sqrt          = math.sqrt
local _V3new         = Vector3.new
local _V3zero        = Vector3.zero
local _CFnew         = CFrame.new
local _CFlookAt      = CFrame.lookAt
local _RayParams_new = RaycastParams.new

local _GetPlayersCached
do
    local cache, cacheTime = nil, 0
    _GetPlayersCached = function()
        local now = _tick()
        if cache and now - cacheTime < 0.03 then return cache end
        cache = Players:GetPlayers()
        cacheTime = now
        return cache
    end
end

local function waitForCharReady(char, timeout)
    timeout = timeout or 5
    local deadline = _tick() + timeout
    while (not char) or (not char.Parent)
          or (not char:FindFirstChild("HumanoidRootPart"))
          or (not char:FindFirstChildOfClass("Humanoid")) do
        if _tick() > deadline then return false end
        task.wait(0.05)
    end
    return true
end

NS = 70
CS = 38
LAGGER_SPEED = 30
LAGGER_CARRY_SPEED = 36
MEDUSA_COOLDOWN = 25
BAT_AIMBOT_SPEED = 55
BYPASS_AIMBOT_SPEED = 55
aimbotVersion = 2      -- 1 = Aimbot V1 (dari visible), 2 = Aimbot V2 (Ryzen), 3 = Aimbot V3 (Draku)
batBypassVersion = 1   -- 1 = Aimbot Bypas V1 (dari visible), 2 = Bat Bypas V2 (dari Fira Duel), 3 = Aimbot Bypas V3 (dari Vape)
local State = {
    bypassBatEnabled = false,
    bypassBatSpeed = BYPASS_AIMBOT_SPEED,
}
-- Archivo único de configuración, igual que Clean.
CONFIG_FILE = "VisibleHub_Xmas.json"
BAT_V2_HIT_DIST = 4.5
_isDraggingButton = false

backgroundIndex = 1
-- Pon aquí tus propios IDs (solo el número). "" = sin imagen.
backgroundImages = {"95840824836070", "134365218121900", "94049945480491", "97091481629849", "76690696155277"}
MVPUI = {effects = true, animated = {}, cards = {}, tweens = {}, backgroundRevision = 0}
PERSISTED_TOGGLES = {}
PERSISTED_TOGGLE_SETTERS = {}
PERSISTED_TOGGLE_CALLBACKS = {}

useVenixCarryEngine = false

backgroundImageTransparency = 0
-- true = latar belakang VISIBLE HUB (hitam + garis ungu), false = gambar lama
VISIBLE_BG = true
backgroundMode = "Background 1"
backgroundSelectorLabel = nil
miniBackgroundImage = nil
floatingButtonScale = 1
floatingButtonShape = "rounded"
-- Solo 2 estilos. Ambos circulares, mismo color del estilo 1 original.
-- Estilo 1 = interfaz tipo Puren (sin glyph). Estilo 2 = clasico.
floatingButtonStyle = 1
FLOATING_BUTTON_STYLE_IDS = {1, 2}
FLOATING_BUTTON_STYLE_NAMES = {"Estilo 1", "Estilo 2"}
function visibleBtnStyleSpec()
    local id = tonumber(floatingButtonStyle) or 1
    local base = {radius = 20, trans = 0, offStroke = Color3.fromRGB(70, 74, 84), onStroke = Color3.fromRGB(255, 255, 255),
        thick = 1.4, tOff = 0.2, tOn = 0, onTop = Color3.fromRGB(92, 96, 108), onBot = Color3.fromRGB(8, 8, 10),
        onBg = Color3.fromRGB(255, 255, 255), alwaysGrad = true,
        offTop = Color3.fromRGB(46, 48, 54), offBot = Color3.fromRGB(0, 0, 0),
        txtOn = Color3.fromRGB(255, 255, 255), txtOff = Color3.fromRGB(255, 255, 255),
        gloss = true, noGlyph = true, txtSize = 13, w = 96, h = 62}
    if id == 1 then
        base.noGlyph = true
        base.txtSize = 13
        base.font = Enum.Font.GothamBlack
        base.radius = 24
        base.w, base.h = 84, 74
        base.thick = 1.8
        base.onTop, base.onBot = Color3.fromRGB(34, 34, 38), Color3.fromRGB(0, 0, 0)
        base.offTop, base.offBot = Color3.fromRGB(52, 52, 58), Color3.fromRGB(0, 0, 0)
        base.onStroke, base.offStroke = Color3.fromRGB(255, 255, 255), Color3.fromRGB(86, 88, 96)
        base.tOn, base.tOff = 0, 0.35
    elseif id == 2 then
        -- Estilo 2: circular
        base.radius = 34
        base.w, base.h = 68, 68
        base.txtSize = 11
    end
    return base
end
FLOATING_BUTTON_SHAPES = {"rounded", "circle", "square"}
FLOATING_BUTTON_SHAPE_LABELS = {rounded = "Rounded", circle = "Circle", square = "Square"}
_floatingUIScales = {}

TPBatState = TPBatState or {
    enabled = false,
    connection = nil,
    hitCooldown = false,
    antiDieConnections = {},
}
TPBatState.enabled = false

-- ===== ANTI TEMBUS DINDING =====
-- wallSafeVelocity : kecepatan terbang/kejar dibelokkan menyusur dinding (tidak menembus).
-- wallSafePosition : teleport berhenti sebelum dinding yang menghalangi.
_wallRayParams = RaycastParams.new()
_wallRayParams.FilterType = Enum.RaycastFilterType.Exclude
_wallRayParams.RespectCanCollide = true
_wallFilterAt = 0
function _wallFilter()
    local now = os.clock()
    if now - _wallFilterAt < 0.5 then return end
    _wallFilterAt = now
    local list = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then list[#list + 1] = pl.Character end
    end
    _wallRayParams.FilterDescendantsInstances = list
end

function wallSafeVelocity(root, vel)
    if not root or not root.Parent or vel.Magnitude < 0.5 then return vel end
    _wallFilter()
    local pos = root.Position
    for _ = 1, 3 do
        local mag = vel.Magnitude
        if mag < 0.5 then return Vector3.zero end
        local dir = vel / mag
        local reach = math.clamp(mag * 0.12, 3, 10)
        local hit
        for _, dy in ipairs({0, 1.5, -1.5}) do
            local h = Workspace:Raycast(pos + Vector3.new(0, dy, 0), dir * reach, _wallRayParams)
            if h and (not hit or h.Distance < hit.Distance) then hit = h end
        end
        if not hit then break end
        local n = hit.Normal
        local into = vel:Dot(n)
        if into < 0 then vel = vel - n * into end
    end
    return vel
end

function wallSafePosition(root, targetPos)
    if not root or not root.Parent then return targetPos end
    _wallFilter()
    local from = root.Position
    local delta = targetPos - from
    if delta.Magnitude < 0.1 then return targetPos end
    local hit = Workspace:Raycast(from, delta, _wallRayParams)
    if not hit then return targetPos end
    local stop = hit.Position - delta.Unit * 1.8
    if (stop - from):Dot(delta) < 0 then return from end
    return stop
end

-- ===== BACKGROUND STEAL (dipindahkan dari visible) =====
-- Ganti background di Settings > Automation (paling atas, dekat Auto Steal):
-- gambar ikut tampil di HUD Steal (bar progres) dan di semua tombol floating.
STEAL_BG_IMAGES = {
    { label = "Visual", id = "" },
}
stealBgIndex = 1
stealBgImageTransparency = 0.35
stealBgSelectorLabel = nil
stealBgImageHud = nil
stealBgUpdatePreview = nil
stealHudScale = 1
_stealBgButtonImages = {}

-- ===== Skin & Suara Bat / Medusa (punya Blaxing: Custom Tools + Custom Sounds) =====
_G.AmbitiousCustomToolsEnabled = false
_G.AmbitiousCustomSoundsEnabled = false
_G.AmbitiousCustomToolSkins = _G.AmbitiousCustomToolSkins or { Bat = "Off", Medusa = "Off" }
VISIBLE_SKIN_LABELS = { DiamondSword = "Diamond Sword", Katana = "Katana", Skull = "Skull", GoldenDesertEagle = "Golden Desert Eagle" }
setCustomToolsVisual, setCustomSoundsVisual, setCustomSkinBatLabel, setCustomSkinMedusaLabel = nil, nil, nil, nil
function visibleApplySkinFlags()
    if _G.AmbitiousCustomTools then pcall(_G.AmbitiousCustomTools.setEnabled, _G.AmbitiousCustomToolsEnabled == true) end
    if _G.AmbitiousCustomSounds then pcall(_G.AmbitiousCustomSounds.setEnabled, _G.AmbitiousCustomSoundsEnabled == true) end
end

-- background jendela script (panel utama) ikut gambar background yang dipilih
function applyMainBackground()
    if not (main and main.Parent) then return end
    local veil = main:FindFirstChild("BackgroundVeil")
    if veil then
        veil.Visible = true
        -- velo oscuro suave sobre la imagen de fondo para que no se vea lavada/blanca
        local id = backgroundImages and backgroundImages[backgroundIndex]
        local hasImg = backgroundMode ~= "None" and id ~= nil and tostring(id) ~= ""
        veil.BackgroundTransparency = hasImg and 0.5 or 1
    end
end

-- tombol tab (sidebar) ikut gambar background yang dipilih
function applyTabBackground()
    -- Pestañas sin imagen (solo texto + underline)
    for _, b in ipairs(tabButtons or {}) do
        if b.Parent then
            local im = b:FindFirstChild("TabBgImage")
            local scrim = b:FindFirstChild("TabBgScrim")
            if im then im.Image = ""; im.Visible = false end
            if scrim then scrim.Visible = false end
        end
    end
end

function applyStealBackground(index)
    stealBgIndex = _clamp(_floor(tonumber(index) or 1), 1, #STEAL_BG_IMAGES)
    local cfg = STEAL_BG_IMAGES[stealBgIndex]
    if not cfg then return end
    -- HUD y botones: sin imagen de fondo
    local img = ""
    local trans = 1
    if stealBgImageHud and stealBgImageHud.Parent then
        stealBgImageHud.Image = ""
        stealBgImageHud.ImageTransparency = 1
    end
    -- Botones flotantes: sin imagen de fondo
    for btn, lbl in pairs(_stealBgButtonImages) do
        if btn.Parent and lbl.Parent then
            lbl.Image = ""
            lbl.ImageTransparency = 1
        else
            _stealBgButtonImages[btn] = nil
        end
    end
    if pbFrame and pbFrame.Parent then
        local trk = pbFrame:FindFirstChild("StealProgressTrack")
        if trk then trk.BackgroundTransparency = 1 end
        for _, d in ipairs(pbFrame:GetChildren()) do
            if d:IsA("TextLabel") and d:GetAttribute("StealText") then
                d.TextColor3 = Color3.fromRGB(255, 255, 255)
                d.TextStrokeTransparency = 1
            end
        end
        if progressStatus and progressStatus.Parent then
            progressStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
            progressStatus.TextStrokeTransparency = 1
        end
    end
    if stealBgSelectorLabel then stealBgSelectorLabel.Text = cfg.label end
    if stealBgUpdatePreview then pcall(stealBgUpdatePreview, stealBgIndex) end
    if applyTabBackground then pcall(applyTabBackground) end
    if applyMainBackground then pcall(applyMainBackground) end
end

function applyBackgroundMode(mode)
    if mode == "None" then
        backgroundMode = "None"
    else
        local n = tonumber(string.match(tostring(mode), "^Background%s+(%d+)$")) or backgroundIndex
        backgroundIndex = _clamp(_floor(n), 1, #backgroundImages)
        backgroundMode = "Background " .. backgroundIndex
    end
    MVPUI.backgroundRevision = MVPUI.backgroundRevision + 1
    local revision = MVPUI.backgroundRevision
    if applyMainBackground then task.defer(applyMainBackground) end
    if main then
        main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        main.BackgroundTransparency = 0
        local bg = main:FindFirstChild("BackgroundImage")
        local overlay = main:FindFirstChild("BackgroundIncoming")
        if overlay then overlay:Destroy() end
        if MVPUI.backgroundTween then MVPUI.backgroundTween:Cancel() end
        if bg then
            bg.Visible = true
            local asset = ""
            if backgroundMode ~= "None" and backgroundImages[backgroundIndex] and tostring(backgroundImages[backgroundIndex]) ~= "" then
                asset = "rbxassetid://" .. tostring(backgroundImages[backgroundIndex])
            end
            local opacity = (backgroundMode == "None") and 1 or 0
            if backgroundMode == "None" or not MVPUI.effects or bg.Image == asset then
                bg.Image = asset
                bg.ImageTransparency = opacity
            else
                local incoming = bg:Clone()
                incoming.Name = "BackgroundIncoming"
                incoming.Image = asset
                incoming.ImageTransparency = 1
                incoming.ZIndex = 1
                incoming.Parent = main
                MVPUI.backgroundTween = TS:Create(incoming, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {ImageTransparency = opacity})
                MVPUI.backgroundTween.Completed:Connect(function()
                    if revision == MVPUI.backgroundRevision and bg.Parent then
                        bg.Image = asset
                        bg.ImageTransparency = opacity
                    end
                    if incoming.Parent then incoming:Destroy() end
                end)
                MVPUI.backgroundTween:Play()
            end
        end
    end
    if MVPUI.art and MVPUI.art.Parent then
        MVPUI.art.Image = ""
        MVPUI.art.Visible = false
    end
    if miniBackgroundImage then miniBackgroundImage.Visible = false end
    if backgroundSelectorLabel then backgroundSelectorLabel.Text = backgroundMode end
    if applyMainBackground then pcall(applyMainBackground) end
    for i, card in ipairs(MVPUI.cards) do
        if card.Parent then
            local sel
            if card:GetAttribute("BgNone") then sel = backgroundMode == "None" else sel = backgroundMode ~= "None" and i == backgroundIndex end
            local badge = card:FindFirstChild("Badge")
            if badge then
                badge.BackgroundColor3 = sel and Color3.fromRGB(228, 228, 231) or Color3.fromRGB(0, 0, 0)
                badge.BackgroundTransparency = sel and 0 or 0.35
                local bt = badge:FindFirstChildOfClass("TextLabel")
                if bt then
                    bt.Text = sel and "✓" or (card:GetAttribute("BgNone") and "—" or string.format("%02d", i))
                    bt.TextColor3 = sel and Color3.fromRGB(14, 14, 16) or Color3.fromRGB(255, 255, 255)
                end
            end
        end
    end
end

local COLOR_THEMES = {
    ["Orange"] = Color3.fromRGB(200, 40, 255),
    ["Gray"] = Color3.fromRGB(215, 215, 220),
    ["Red+Purple"] = Color3.fromRGB(255, 25, 40),
    ["Yellow+Black"] = Color3.fromRGB(255, 232, 0),
    ["Green+White"] = Color3.fromRGB(0, 255, 110),
}
-- warna kedua untuk tema dua warna (merah+ungu, kuning+hitam, hijau+putih)
COLOR_THEME_SECONDARY = {
    ["Red+Purple"] = Color3.fromRGB(185, 60, 255),
    ["Yellow+Black"] = Color3.fromRGB(18, 18, 18),
    ["Green+White"] = Color3.fromRGB(255, 255, 255),
}
COLOR_THEME_LABELS = {
    ["Orange"] = "Purple",
    ["Gray"] = "Gray",
    ["Red+Purple"] = "Red + Purple",
    ["Yellow+Black"] = "Yellow + Black",
    ["Green+White"] = "Green + White",
}
COLOR_THEME_ORDER = {"Orange", "Red+Purple", "Yellow+Black", "Green+White", "Gray"}

RIVAL_TITLE_THEMES = {
    ["Orange"] = { top = Color3.fromRGB(245, 225, 255), bottom = Color3.fromRGB(200, 40, 255) },
    ["Blue"]  = { top = Color3.fromRGB(60, 130, 255),  bottom = Color3.fromRGB(210, 220, 235) },
    ["Red"]   = { top = Color3.fromRGB(255, 70, 70),   bottom = Color3.fromRGB(215, 215, 215) },
    ["Green"] = { top = Color3.fromRGB(50, 220, 110),  bottom = Color3.fromRGB(200, 240, 210) },
    ["Black"] = { top = Color3.fromRGB(35, 35, 40),    bottom = Color3.fromRGB(115, 115, 125) },
    ["Gray"]  = { top = Color3.fromRGB(230, 230, 235), bottom = Color3.fromRGB(135, 135, 145) },
    ["Red+Purple"]   = { top = Color3.fromRGB(255, 40, 55),  bottom = Color3.fromRGB(185, 60, 255) },
    ["Yellow+Black"] = { top = Color3.fromRGB(255, 238, 30), bottom = Color3.fromRGB(35, 35, 35) },
    ["Green+White"]  = { top = Color3.fromRGB(0, 255, 110),  bottom = Color3.fromRGB(255, 255, 255) },
}
currentRivalTitleTheme = "Orange"
scriptLogoRef = nil
rivalTitleSelectorLabel = nil

function applyRivalTitleTheme(themeName)
    local t = RIVAL_TITLE_THEMES[themeName]
    if not t then return end
    currentRivalTitleTheme = themeName
    if scriptLogoRef then
        local grad = scriptLogoRef:FindFirstChildOfClass("UIGradient")
        if grad then
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, t.top),
                ColorSequenceKeypoint.new(1, t.bottom),
            })
        end
    end
    if rivalTitleSelectorLabel then
        rivalTitleSelectorLabel.Text = themeName
    end
    if saveAllSettings then pcall(saveAllSettings) end
end

currentColorTheme = "Visible"
selectedColor = Color3.fromRGB(255, 255, 255)

function getThemeColor() return selectedColor end

-- warna kedua tema aktif (nil untuk tema satu warna)
function getThemeSecondary() return COLOR_THEME_SECONDARY[currentColorTheme] end
-- versi secondary yang terbaca di background gelap (hitam -> pakai warna utama)
function getThemeSecondaryReadable()
    local sec = getThemeSecondary()
    if not sec then return nil end
    if (sec.R + sec.G + sec.B) / 3 < 0.25 then return selectedColor end
    return sec
end

function visibleHubGradient(c)
    local sec = (c == selectedColor) and getThemeSecondary() or nil
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.new(1,1,1), 0.55)),
        ColorSequenceKeypoint.new(0.45, c),
        ColorSequenceKeypoint.new(1.00, sec or c:Lerp(Color3.new(0,0,0), 0.35)),
    })
end

function visibleHubGradientSoft(c)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.new(1,1,1), 0.75)),
        ColorSequenceKeypoint.new(0.50, c:Lerp(Color3.new(1,1,1), 0.25)),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.new(0,0,0), 0.15)),
    })
end

function visibleHubGradientDark(c)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.fromRGB(0,0,0), 0.35)),
        ColorSequenceKeypoint.new(0.55, c:Lerp(Color3.fromRGB(0,0,0), 0.65)),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.fromRGB(0,0,0), 0.80)),
    })
end

function applyVisibleHubGradientToLabel(label, c)
    if not label then return end
    local grad = label:FindFirstChildOfClass("UIGradient")
    if not grad then
        grad = Instance.new("UIGradient", label)
    end
    grad.Rotation = 0
    grad.Color = visibleHubGradient(c)
end

local _lastThemeUpdate = 0
local _lastThemeColor = nil

function applyColorTheme(_themeName)
    -- Tema bloqueado de Visible: negro, blanco y Navidad rojo/verde solo en Navidad.
    currentColorTheme = "Visible"
    selectedColor = Color3.fromRGB(255, 255, 255)
    _lastThemeColor = nil
    updateAllUIThemeColors(selectedColor)
end

_paintedThemeColor = COLOR_THEMES["Orange"]

-- ganti semua elemen UI yang masih memakai warna tema lama dengan warna tema baru
function repaintThemeColor(root, old, new)
    if not root or not old or old == new then return end
    for _, d in ipairs(root:GetDescendants()) do
        pcall(function()
            if d:IsA("GuiObject") then
                if d.BackgroundColor3 == old then d.BackgroundColor3 = new end
                if (d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox")) and d.TextColor3 == old then
                    d.TextColor3 = new
                end
                if (d:IsA("ImageLabel") or d:IsA("ImageButton")) and d.ImageColor3 == old then
                    d.ImageColor3 = new
                end
                if d:IsA("ScrollingFrame") and d.ScrollBarImageColor3 == old then
                    d.ScrollBarImageColor3 = new
                end
            elseif d:IsA("UIStroke") and d.Color == old then
                d.Color = new
            end
        end)
    end
end

_uicStroke = nil
_uicAvatarStroke = nil
_uicHandle = nil
_uicLine = nil

-- warna label timer cooldown (di atas kepala) ikut warna tema Misc (sama seperti VISIBLE HUB V2)
function visiblePaintTimerLabel(lbl)
    if not lbl or not lbl.Parent then return end
    pcall(function()
        local K = Color3.new(0, 0, 0)
        local accent = getThemeColor()
        local ice = getThemeSecondaryReadable() or accent
        lbl.TextColor3 = accent
        local g = lbl:FindFirstChildOfClass("UIGradient")
        if g then
            g.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, accent:Lerp(K, 0.25)),
                ColorSequenceKeypoint.new(0.3, accent),
                ColorSequenceKeypoint.new(0.5, ice),
                ColorSequenceKeypoint.new(0.7, accent),
                ColorSequenceKeypoint.new(1, accent:Lerp(K, 0.25)),
            })
        end
    end)
end

function updateAllUIThemeColors(color)
    local now = _tick()
    if color == _lastThemeColor and now - _lastThemeUpdate < 0.1 then return end
    _lastThemeUpdate = now
    _lastThemeColor = color

    do
        local oldColor = _paintedThemeColor
        _paintedThemeColor = color
        if oldColor and oldColor ~= color then
            if gui then repaintThemeColor(gui, oldColor, color) end
            if pbFrame and not (gui and pbFrame:IsDescendantOf(gui)) then repaintThemeColor(pbFrame, oldColor, color) end
        end
    end
    local secColor = getThemeSecondaryReadable()
    if MVPUI.footerStats and MVPUI.footerStats.Parent then
        MVPUI.footerStats.Text = "VISIBLE HUB  /  " .. string.upper("VISIBLE")
        MVPUI.footerStats.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    if progressFill then
        progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        progressFill.BackgroundTransparency = 0
    end
    if pbFrame then
        -- v5: el HUD tiene su propia paleta (negro/blanco o navidad), no usa el color del tema
        if _G.__VisibleHudStyle then pcall(_G.__VisibleHudStyle) end
    end

        if MVPUI.speedValueLabel and MVPUI.speedValueLabel.Parent then
        MVPUI.speedValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    pcall(function()
        local pg = LP:FindFirstChild("PlayerGui")
        local rb = pg and pg:FindFirstChild("RagCountdownBillboard")
        local rl = rb and rb:FindFirstChildWhichIsA("TextLabel", true)
        if rl then visiblePaintTimerLabel(rl) end
    end)

    if _uicStroke then _uicStroke.Color = color end
    if _uicAvatarStroke then _uicAvatarStroke.Color = color end
    if _uicHandle then _uicHandle.TextColor3 = secColor or Color3.fromRGB(200, 100, 255) end
    if _uicLine then _uicLine.BackgroundColor3 = color end

    local function searchAndUpdateText(parent)
        for _, child in ipairs(parent:GetDescendants()) do
            if child:IsA("TextLabel") and child.Name == "SpeedLabel" then
                local blue = Color3.fromRGB(255, 255, 255)
                child.TextColor3 = blue
                local grad = child:FindFirstChildOfClass("UIGradient")
                if grad then
                    grad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0.00, blue),
                        ColorSequenceKeypoint.new(0.30, blue:Lerp(Color3.new(0.15,0.15,0.15), 0.25)),
                        ColorSequenceKeypoint.new(0.50, blue:Lerp(Color3.new(1,1,1), 0.55)),
                        ColorSequenceKeypoint.new(0.70, blue:Lerp(Color3.new(0.15,0.15,0.15), 0.25)),
                        ColorSequenceKeypoint.new(1.00, blue),
                    })
                end
            end
            if child:IsA("UIStroke") then
                if child.Color == Color3.fromRGB(180, 180, 190) then child.Color = color end
            end
        end
    end
    if gui then searchAndUpdateText(gui) end
    if _G.__VisibleRestyleTabs then pcall(_G.__VisibleRestyleTabs) end
    if _G.__VisibleHubRefreshESPTheme then pcall(_G.__VisibleHubRefreshESPTheme, color) end
    if main then
        local titleFrame = main:FindFirstChild("Frame")
        if titleFrame then
            for _, child in ipairs(titleFrame:GetDescendants()) do
                if child:IsA("UIStroke") and child.Color == Color3.fromRGB(180, 180, 190) then
                    child.Color = color
                end
            end
        end
    end
    if main then
        local tl = main:FindFirstChild("TopLight")
        if tl then tl.BackgroundColor3 = color:Lerp(Color3.new(1, 1, 1), 0.15) end
        local mb = main:FindFirstChild("MainBorder")
        if mb and not mb:FindFirstChild("VisibleFlow") then mb.Color = color end
    end
    if colorSelectorLabel then
        colorSelectorLabel.Text = "VISIBLE"
        colorSelectorLabel.TextColor3 = color
    end

    if _G._visibleHubStealSlide then
        _G._visibleHubStealSlide.BackgroundColor3 = color
        local sg = _G._visibleHubStealSlide:FindFirstChildOfClass("UIGradient")
        if sg then sg.Color = visibleHubGradient(color) end
        local ss = _G._visibleHubStealSlide:FindFirstChildOfClass("UIStroke")
        if ss then ss.Color = color end
    end

    if miniBtn then
        
        local stroke = miniBtn:FindFirstChildOfClass("UIStroke")
        if stroke and not stroke:FindFirstChild("VisibleFlow") then stroke.Color = color end
    end

    if MobilePanel then
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") and btn:FindFirstChild("BtnGrad") then
                paintFloatingBtn(btn, btn:GetAttribute("MobActive") == true)
            end
        end
    end
end

local HOMERO_CFG = {
    body = { 10725826963, 86500008, 86500054, 86500036, 86500064, 86500078 },
    aplicarCuerpo = true,
    items = {
        { id = 103227700418, offset = _CFnew(0,0,0) },
        { id = 84952305140948,   offset = _CFnew(0,0,0) },
        { id = 122465238537030,  offset = _CFnew(0,0,0) },
    },
    shirt = nil,
    pants = "rbxassetid://78591690208112",
    skinColor = Color3.fromRGB(234,184,146),
    headColor = Color3.fromRGB(0,0,0),
}

local TAG = "LocalOutfit_"

local function loadObjects(id)
    local ok, res = pcall(function()
        return game:GetObjects("rbxassetid://" .. tostring(id))
    end)
    if ok and typeof(res) == "table" and #res > 0 then return res end
    ok, res = pcall(function()
        return game:GetService("InsertService"):LoadAsset(id)
    end)
    if ok and res then return { res } end
    return nil
end

local function collectParts(objs)
    local out = {}
    for _, o in ipairs(objs) do
        if o:IsA("BasePart") then out[#out + 1] = o end
        for _, d in ipairs(o:GetDescendants()) do
            if d:IsA("BasePart") then out[#out + 1] = d end
        end
    end
    return out
end

local function findAtt(char, name)
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("Attachment") and p.Name == name and p.Parent:IsA("BasePart") then
            return p
        end
    end
end

local function applyBody(char)
    local total = 0
    for _, id in ipairs(HOMERO_CFG.body) do
        local objs = loadObjects(id)
        if objs then
            for _, mp in ipairs(collectParts(objs)) do
                local orig = char:FindFirstChild(mp.Name)
                if orig and orig:IsA("BasePart") then
                    local c = mp:Clone()
                    c.Name = TAG .. "body_" .. mp.Name
                    c.CanCollide = false
                    c.Anchored = false
                    c.Massless = true
                    c.Size = orig.Size
                    c.CFrame = orig.CFrame
                    c.Parent = char
                    local w = Instance.new("WeldConstraint")
                    w.Part0 = orig
                    w.Part1 = c
                    w.Parent = c
                    if orig:GetAttribute("VisibleHubOutfitOriginalTransparency") == nil then
                        orig:SetAttribute("VisibleHubOutfitOriginalTransparency", orig.Transparency)
                    end
                    orig.Transparency = 1
                    total = total + 1
                end
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end
    return total
end

local function attachItem(char, entry)
    local objs = loadObjects(entry.id)
    if not objs then return false end

    local handle
    for _, p in ipairs(collectParts(objs)) do
        if p.Name == "Handle" then handle = p; break end
        if not handle then handle = p end
    end
    if not handle then
        for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        return false
    end

    local H = handle:Clone()
    for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end

    H.Name = TAG .. "item_" .. tostring(entry.id)
    H.CanCollide = false
    H.Anchored = false
    H.Massless = true

    local wrap = H:FindFirstChildWhichIsA("WrapLayer")
    local target, c0, c1

    if wrap then
        target = char:FindFirstChild("UpperTorso")
              or char:FindFirstChild("Torso")
              or char:FindFirstChild("HumanoidRootPart")
        c0 = entry.offset or _CFnew()
        c1 = _CFnew()
    else
        local hAtt = H:FindFirstChildOfClass("Attachment")
        local bAtt = hAtt and findAtt(char, hAtt.Name)
        if bAtt then
            target = bAtt.Parent
            c0 = bAtt.CFrame * (entry.offset or _CFnew())
            c1 = hAtt.CFrame
        else
            target = char:FindFirstChild("Head")
            c0 = entry.offset or _CFnew(0, 1.4, 0)
            c1 = _CFnew()
        end
    end

    if not target then H:Destroy(); return false end

    H.CFrame = target.CFrame * c0 * c1:Inverse()
    H.Parent = char

    local w = Instance.new("Weld")
    w.Part0 = target
    w.Part1 = H
    w.C0 = c0
    w.C1 = c1
    w.Parent = H
    return true
end

function applyHomeroOutfit(char)
    if not char then char = LP.Character end
    if not char then return end
    char:WaitForChild("Humanoid", 10)
    char:WaitForChild("Head", 10)
    task.wait(0.4)

    for _, d in ipairs(char:GetChildren()) do
        if d.Name:sub(1, #TAG) == TAG then pcall(function() d:Destroy() end) end
    end

    if HOMERO_CFG.skinColor then
        local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
        bc.HeadColor3 = HOMERO_CFG.headColor or HOMERO_CFG.skinColor
        bc.TorsoColor3 = HOMERO_CFG.skinColor
        bc.LeftArmColor3, bc.RightArmColor3 = HOMERO_CFG.skinColor, HOMERO_CFG.skinColor
        bc.LeftLegColor3, bc.RightLegColor3 = HOMERO_CFG.skinColor, HOMERO_CFG.skinColor
        bc.Parent = char
    end

    -- Mantener visibles los accesorios originales del avatar.
    -- Antes esta skin ocultaba cada Handle con Transparency = 1 y los accesorios
    -- quedaban desaparecidos incluso después de guardar o cambiar de skin.
    for _, a in ipairs(char:GetChildren()) do
        if a:IsA("Accessory") then
            for _, part in ipairs(a:GetDescendants()) do
                if part:IsA("BasePart") then
                    local original = part:GetAttribute("VisibleHubOriginalTransparency")
                    if original ~= nil then
                        part.Transparency = original
                        part:SetAttribute("VisibleHubOriginalTransparency", nil)
                    end
                    local originalLocal = part:GetAttribute("VisibleHubOriginalLocalTransparency")
                    if originalLocal ~= nil then
                        part.LocalTransparencyModifier = originalLocal
                        part:SetAttribute("VisibleHubOriginalLocalTransparency", nil)
                    end
                end
            end
        end
    end

    if HOMERO_CFG.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"
        s.ShirtTemplate = HOMERO_CFG.shirt
        s.Parent = char
    end
    if HOMERO_CFG.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"
        p.PantsTemplate = HOMERO_CFG.pants
        p.Parent = char
    end
    if HOMERO_CFG.aplicarCuerpo then applyBody(char) end
    for _, e in ipairs(HOMERO_CFG.items) do attachItem(char, e) end
end

local _originalAppearance = nil

local function captureOriginalAppearance(char)
    if not char or _originalAppearance then return end
    local data = {
        bodyColors = nil,
        shirt = nil,
        pants = nil,
        headMesh = nil,
        headTexture = nil,
    }
    local bc = char:FindFirstChildWhichIsA("BodyColors")
    if bc then
        data.bodyColors = {
            head = bc.HeadColor3,
            torso = bc.TorsoColor3,
            leftArm = bc.LeftArmColor3,
            rightArm = bc.RightArmColor3,
            leftLeg = bc.LeftLegColor3,
            rightLeg = bc.RightLegColor3,
        }
    end
    local sh = char:FindFirstChildWhichIsA("Shirt")
    if sh then data.shirt = sh.ShirtTemplate end
    local pa = char:FindFirstChildWhichIsA("Pants")
    if pa then data.pants = pa.PantsTemplate end
    local head = char:FindFirstChild("Head")
    if head then
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if sm and sm.MeshType == Enum.MeshType.FileMesh then
            data.headMesh = sm.MeshId
            data.headTexture = sm.TextureId
        end
    end
    _originalAppearance = data
end

local function clearPreviousOutfitAssets(char)
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child.Name:sub(1, #TAG) == TAG
        or child.Name == "AuFfitAccessory"
        or child.Name == "BubbleSkinChanger_Hair"
        or child.Name:sub(1, 13) == "KawatanSkin_"
        or child.Name == "Korblox_RightLeg" then
            pcall(function() child:Destroy() end)
        elseif child:IsA("CharacterMesh") and child.BodyPart == Enum.BodyPart.Head then
            pcall(function() child:Destroy() end)
        end
    end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local originalTransparency = part:GetAttribute("VisibleHubOutfitOriginalTransparency")
            if originalTransparency ~= nil then
                part.Transparency = originalTransparency
                part:SetAttribute("VisibleHubOutfitOriginalTransparency", nil)
            end
            local originalLocalTransparency = part:GetAttribute("VisibleHubOutfitOriginalLocalTransparency")
            if originalLocalTransparency ~= nil then
                part.LocalTransparencyModifier = originalLocalTransparency
                part:SetAttribute("VisibleHubOutfitOriginalLocalTransparency", nil)
            end
        end
    end
    if _originalAppearance and _originalAppearance.bodyColors then
        local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
        local o = _originalAppearance.bodyColors
        bc.HeadColor3, bc.TorsoColor3 = o.head, o.torso
        bc.LeftArmColor3, bc.RightArmColor3 = o.leftArm, o.rightArm
        bc.LeftLegColor3, bc.RightLegColor3 = o.leftLeg, o.rightLeg
        bc.Parent = char
    end
    local head = char:FindFirstChild("Head")
    if head and head:IsA("MeshPart") and head:GetAttribute("VisibleHubOutfitModifiedMeshPart") then
        pcall(function()
            head.MeshId = head:GetAttribute("VisibleHubOutfitOriginalMeshId") or ""
            head.TextureID = head:GetAttribute("VisibleHubOutfitOriginalTextureId") or ""
        end)
        head:SetAttribute("VisibleHubOutfitModifiedMeshPart", nil)
        head:SetAttribute("VisibleHubOutfitOriginalMeshId", nil)
        head:SetAttribute("VisibleHubOutfitOriginalTextureId", nil)
    elseif head then
        local specialMesh = head:FindFirstChildWhichIsA("SpecialMesh")
        if specialMesh and specialMesh:GetAttribute("VisibleHubOutfitCreatedMesh") then
            specialMesh:Destroy()
        elseif specialMesh and specialMesh:GetAttribute("VisibleHubOutfitModifiedMesh") then
            specialMesh.MeshId = specialMesh:GetAttribute("VisibleHubOutfitOriginalMeshId") or ""
            specialMesh.TextureId = specialMesh:GetAttribute("VisibleHubOutfitOriginalTextureId") or ""
            specialMesh:SetAttribute("VisibleHubOutfitModifiedMesh", nil)
            specialMesh:SetAttribute("VisibleHubOutfitOriginalMeshId", nil)
            specialMesh:SetAttribute("VisibleHubOutfitOriginalTextureId", nil)
        end
    end
end

local function applyNoOutfit(char)
    if not char then char = LP.Character end
    if not char then return end
    for _, d in ipairs(char:GetChildren()) do
        if d.Name:sub(1, #TAG) == TAG then pcall(function() d:Destroy() end) end
    end
    local oldAcc = char:FindFirstChild("AuFfitAccessory")
    if oldAcc then pcall(function() oldAcc:Destroy() end) end
    local oldKorblox = char:FindFirstChild("Korblox_RightLeg")
    if oldKorblox then pcall(function() oldKorblox:Destroy() end) end
    for _, d in ipairs(char:GetChildren()) do
        if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
            pcall(function() d:Destroy() end)
        end
    end
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = 0
        head.CanCollide = true
        head.LocalTransparencyModifier = 0
        local face = head:FindFirstChild("face")
        if face then face.Transparency = 0 end
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if sm then
            if _originalAppearance and _originalAppearance.headMesh then
                sm.MeshId = _originalAppearance.headMesh
                sm.TextureId = _originalAppearance.headTexture or ""
            else
                pcall(function() sm:Destroy() end)
            end
        end
    end
    pcall(function()
        local neck = char:FindFirstChild("Neck")
        if neck then neck.Enabled = true end
    end)
    for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
        local limb = char:FindFirstChild(partName)
        if limb then limb.Transparency = 0 end
    end
    if _originalAppearance and _originalAppearance.bodyColors then
        local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
        local o = _originalAppearance.bodyColors
        bc.HeadColor3 = o.head
        bc.TorsoColor3 = o.torso
        bc.LeftArmColor3 = o.leftArm
        bc.RightArmColor3 = o.rightArm
        bc.LeftLegColor3 = o.leftLeg
        bc.RightLegColor3 = o.rightLeg
        bc.Parent = char
    end
    if _originalAppearance and _originalAppearance.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.ShirtTemplate = _originalAppearance.shirt
        s.Parent = char
    end
    if _originalAppearance and _originalAppearance.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.PantsTemplate = _originalAppearance.pants
        p.Parent = char
    end
    for _, a in ipairs(char:GetChildren()) do
        if a:IsA("Accessory") then
            local h = a:FindFirstChild("Handle")
            if h then h.Transparency = 0 end
        end
    end
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Accessory") then
            for _, part in ipairs(item:GetDescendants()) do
                if part:IsA("BasePart") then
                    local original = part:GetAttribute("VisibleHubOriginalTransparency")
                    if original ~= nil then part.Transparency = original; part:SetAttribute("VisibleHubOriginalTransparency", nil) end
                    local originalLocal = part:GetAttribute("VisibleHubOriginalLocalTransparency")
                    if originalLocal ~= nil then part.LocalTransparencyModifier = originalLocal; part:SetAttribute("VisibleHubOriginalLocalTransparency", nil) end
                end
            end
        elseif item:IsA("Shirt") then
            local original = item:GetAttribute("VisibleHubOriginalTemplate")
            if original ~= nil then item.ShirtTemplate = original; item:SetAttribute("VisibleHubOriginalTemplate", nil) end
        elseif item:IsA("Pants") then
            local original = item:GetAttribute("VisibleHubOriginalTemplate")
            if original ~= nil then item.PantsTemplate = original; item:SetAttribute("VisibleHubOriginalTemplate", nil) end
        elseif item:IsA("ShirtGraphic") then
            local original = item:GetAttribute("VisibleHubOriginalGraphic")
            if original ~= nil then item.Graphic = original; item:SetAttribute("VisibleHubOriginalGraphic", nil) end
        end
    end
end

local OUTFITS = {
    { label = "OFF", customApply = applyNoOutfit },
    { accessory = 10159600649, offset = _V3new(0, 1, -0.2), shirt = "http://www.roblox.com/asset/?id=9683332638", pants = "http://www.roblox.com/asset/?id=93182020184041", headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918 ", korblox = "none", label = "Outfit 1", headlessKorblox = true },
    { accessory = 1744060292, offset = _V3new(0, 1.3, -0.2), shirt = "http://www.roblox.com/asset/?id=9683332638", pants = "http://www.roblox.com/asset/?id=93182020184041", headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918 ", korblox = "none", label = "Outfit 2", headlessKorblox = true },
    { bubbleShirt = 18552805597, bubblePants = 5414143509, bubbleHair = 84008082880128, label = "Outfit 5", headlessKorblox = false },
}
local currentOutfitIndex = 1
local outfitSelectorLabel = nil
local stealSkinSelectorLabel = nil

-- Best Avatars eliminado: stub vacio para no romper referencias (guardado/outfit/reset).
VX7A = { index = 0, labels = {"OFF"}, stop = function() end, apply = function() end, setLabel = function() end }

local function loadObjectsStd(id)
    local ok, res = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(id)) end)
    if ok and typeof(res) == "table" and #res > 0 then return res end
    ok, res = pcall(function() return game:GetService("InsertService"):LoadAsset(id) end)
    if ok and res then return {res} end
    return nil
end
local function resolveBubbleTemplate(id, className, propertyName)
    local fallback = "rbxassetid://" .. tostring(id)
    local ok, objects = pcall(function() return game:GetObjects(fallback) end)
    if ok and objects and objects[1] then
        local item = objects[1]
        local obj = item:IsA(className) and item or item:FindFirstChildWhichIsA(className, true)
        if obj and obj[propertyName] and obj[propertyName] ~= "" then fallback = obj[propertyName] end
        for _, v in ipairs(objects) do pcall(function() v:Destroy() end) end
    end
    return fallback
end
local function addBubbleHair(char, assetId)
    local head = char and char:FindFirstChild("Head")
    if not head then return false end
    local objects = loadObjectsStd(assetId)
    if not objects or not objects[1] then return false end
    local source = objects[1]
    local accessory = source:IsA("Accessory") and source or source:FindFirstChildWhichIsA("Accessory", true)
    if not accessory then
        for _, v in ipairs(objects) do pcall(function() v:Destroy() end) end
        return false
    end
    local hair = accessory:Clone()
    hair.Name = "BubbleSkinChanger_Hair"
    for _, part in ipairs(hair:GetDescendants()) do
        if part:IsA("BasePart") then part.Anchored = false; part.CanCollide = false; part.Massless = true; part.LocalTransparencyModifier = 0 end
    end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local ok = pcall(function() if humanoid then humanoid:AddAccessory(hair) else hair.Parent = char end end)
    if not ok then pcall(function() hair:Destroy() end) end
    if ok and hair.Parent then
        -- Algunos accesorios no traen una unión compatible con el rig actual.
        -- En ese caso Roblox los deja en el personaje pero no se ven; crear una
        -- unión local de respaldo mantiene visible la skin sin eliminarla.
        local handle = hair:FindFirstChild("Handle") or hair:FindFirstChildWhichIsA("BasePart", true)
        if handle then
            handle.Transparency = 0
            handle.LocalTransparencyModifier = 0
            local hasJoint = handle:FindFirstChildWhichIsA("Weld", true)
                or handle:FindFirstChildWhichIsA("WeldConstraint", true)
                or handle:FindFirstChild("AccessoryWeld")
            if not hasJoint then
                local sourceAttachment = handle:FindFirstChildWhichIsA("Attachment")
                local targetAttachment = sourceAttachment and findAtt(char, sourceAttachment.Name)
                local target = targetAttachment and targetAttachment.Parent
                if not target or not target:IsA("BasePart") then
                    target = char:FindFirstChild("Head") or char:FindFirstChild("UpperTorso")
                        or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
                end
                if target and target:IsA("BasePart") then
                    if targetAttachment and sourceAttachment then
                        handle.CFrame = targetAttachment.WorldCFrame * sourceAttachment.CFrame:Inverse()
                    else
                        handle.CFrame = target.CFrame
                    end
                    local weld = Instance.new("WeldConstraint")
                    weld.Name = "VisibleHubSkinAccessoryWeld"
                    weld.Part0 = target
                    weld.Part1 = handle
                    weld.Parent = handle
                end
            end
        end
    end
    for _, v in ipairs(objects) do pcall(function() v:Destroy() end) end
    return ok
end
local function applyHeadlessKorblox(char)
    if not char then return end
    pcall(function() LP.CharacterAvatarType = Enum.AvatarType.R6 end)
    local head = char:FindFirstChild("Head")
    if head then
        if head:GetAttribute("VisibleHubOutfitOriginalTransparency") == nil then
            head:SetAttribute("VisibleHubOutfitOriginalTransparency", head.Transparency)
            head:SetAttribute("VisibleHubOutfitOriginalLocalTransparency", head.LocalTransparencyModifier)
        end
        head.Transparency = 1
        head.CanCollide = false
        head.LocalTransparencyModifier = 1
        local face = head:FindFirstChild("face")
        if face then face.Transparency = 1 end
    end
    pcall(function()
        local neck = char:FindFirstChild("Neck")
        if neck then neck.Enabled = false end
    end)
    -- No ocultar accesorios del avatar: se conservan al aplicar esta skin.
    local rightLegConfig = { id = "rbxassetid://139607718", targetBodyPart = "RightUpperLeg", partsToHide = {"RightUpperLeg", "RightLowerLeg", "RightFoot"}, scale = _V3new(1, 1, 1), offset = _CFnew(0, 0, 0) }
    local targetPart = char:FindFirstChild(rightLegConfig.targetBodyPart)
    if targetPart then
        local oldAsset = char:FindFirstChild("Korblox_RightLeg")
        if oldAsset then oldAsset:Destroy() end
        for _, partName in ipairs(rightLegConfig.partsToHide) do
            local limb = char:FindFirstChild(partName)
            if limb and limb:IsA("BasePart") then
                if limb:GetAttribute("VisibleHubOutfitOriginalTransparency") == nil then
                    limb:SetAttribute("VisibleHubOutfitOriginalTransparency", limb.Transparency)
                end
                limb.Transparency = 1
            end
        end
        local success, objects = pcall(function() return game:GetObjects(rightLegConfig.id) end)
        if success and objects and #objects > 0 then
            local assetModel = objects[1]
            assetModel.Name = "Korblox_RightLeg"
            local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
            if mainMesh then
                mainMesh.Size = mainMesh.Size * rightLegConfig.scale
                mainMesh.CanCollide = false
                mainMesh.CFrame = targetPart.CFrame * rightLegConfig.offset
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = targetPart
                weld.Part1 = mainMesh
                weld.Parent = mainMesh
                assetModel.Parent = char
            end
        end
    end
end

-- ===== SKINS KAWATAN (integradas desde BLODHOUNDS) =====
local KAWATAN_SKINS = {
    { label = "SKIN PURPLE", accessories = {1744060292, 439945661, 1125510, 1029025, 11748356, 8465506143, 11444217173}, clothing = {7424637509, 7689651773} },
    { label = "SKIN BLUE", accessories = {74891470, 16630147, 6346833550, 6594911228, 6594919952, 6823338112, 7097747842}, clothing = {18423061209, 18423154566} },
    { label = "SKIN RED", accessories = {215718515, 439945661, 7183785281}, clothing = {15998365201, 7689651773} },
    { label = "SKIN BLACK", accessories = {10159600649, 439946249, 17798262442, 92482095662016, 139101716417676, 12490213797}, clothing = {18766106994, 13925390578} },
    { label = "SKIN GREEN", accessories = {553970961, 1744060292, 93268856876777}, clothing = {9478068776, 6348682339} },
    { label = "SKIN WHITE", accessories = {74891470, 215718515, 439945661, 1016143686, 1744060292, 10159600649, 89012651581593, 126447390530523}, clothing = {88032876921227, 108259950755140} },
}

local function applyKawatanSkin(char, skin)
    if not char or not skin then return end
    local shirt = Instance.new("Shirt")
    shirt.Name = "KawatanSkin_Shirt"
    shirt.ShirtTemplate = resolveBubbleTemplate(skin.clothing[1], "Shirt", "ShirtTemplate")
    shirt.Parent = char
    local pants = Instance.new("Pants")
    pants.Name = "KawatanSkin_Pants"
    pants.PantsTemplate = resolveBubbleTemplate(skin.clothing[2], "Pants", "PantsTemplate")
    pants.Parent = char
    for _, assetId in ipairs(skin.accessories or {}) do
        pcall(function() addBubbleHair(char, assetId) end)
    end
    pcall(function() applyHeadlessKorblox(char) end)
end

for _, skin in ipairs(KAWATAN_SKINS) do
    local selectedSkin = skin
    table.insert(OUTFITS, {
        label = selectedSkin.label,
        customApply = function(char)
            applyKawatanSkin(char, selectedSkin)
        end,
    })
end

function applyOutfitByIndex(index)
    local cfg = OUTFITS[index]
    if not cfg then return end
    local char = LP.Character
    if not char then return end
    clearPreviousOutfitAssets(char)
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Shirt") then
            if item:GetAttribute("VisibleHubOriginalTemplate") == nil then item:SetAttribute("VisibleHubOriginalTemplate", item.ShirtTemplate) end
            item.ShirtTemplate = ""
        elseif item:IsA("Pants") then
            if item:GetAttribute("VisibleHubOriginalTemplate") == nil then item:SetAttribute("VisibleHubOriginalTemplate", item.PantsTemplate) end
            item.PantsTemplate = ""
        elseif item:IsA("ShirtGraphic") then
            if item:GetAttribute("VisibleHubOriginalGraphic") == nil then item:SetAttribute("VisibleHubOriginalGraphic", item.Graphic) end
            item.Graphic = ""
        end
    end

    if cfg.customApply then
        cfg.customApply(char)
        if outfitSelectorLabel then outfitSelectorLabel.Text = cfg.label end
        if stealSkinSelectorLabel then stealSkinSelectorLabel.Text = cfg.label end
        return
    end
    if cfg.bubbleShirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "BubbleSkinChanger_Shirt"
        s.ShirtTemplate = resolveBubbleTemplate(cfg.bubbleShirt, "Shirt", "ShirtTemplate")
        s.Parent = char
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "BubbleSkinChanger_Pants"
        p.PantsTemplate = resolveBubbleTemplate(cfg.bubblePants, "Pants", "PantsTemplate")
        p.Parent = char
        addBubbleHair(char, cfg.bubbleHair)
        if outfitSelectorLabel then outfitSelectorLabel.Text = cfg.label end
        if stealSkinSelectorLabel then stealSkinSelectorLabel.Text = cfg.label end
        return
    end
    char:WaitForChild("Head", 5)
    local head = char:FindFirstChild("Head")
    if not head then return end
    for _, d in ipairs(char:GetChildren()) do
        if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
            pcall(function() d:Destroy() end)
        end
    end
    local done = false
    if head:IsA("MeshPart") then
        done = pcall(function()
            if not head:GetAttribute("VisibleHubOutfitModifiedMeshPart") then
                head:SetAttribute("VisibleHubOutfitOriginalMeshId", head.MeshId)
                head:SetAttribute("VisibleHubOutfitOriginalTextureId", head.TextureID)
                head:SetAttribute("VisibleHubOutfitModifiedMeshPart", true)
            end
            head.MeshId = cfg.headMesh
            head.TextureID = cfg.headTexture or ""
        end)
    end
    if not done then
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if not sm then
            sm = Instance.new("SpecialMesh")
            sm:SetAttribute("VisibleHubOutfitCreatedMesh", true)
        elseif not sm:GetAttribute("VisibleHubOutfitModifiedMesh") then
            sm:SetAttribute("VisibleHubOutfitOriginalMeshId", sm.MeshId)
            sm:SetAttribute("VisibleHubOutfitOriginalTextureId", sm.TextureId)
            sm:SetAttribute("VisibleHubOutfitModifiedMesh", true)
        end
        sm.Parent = head
        sm.MeshType = Enum.MeshType.FileMesh
        sm.MeshId = cfg.headMesh
        sm.TextureId = cfg.headTexture or ""
    end
    if cfg.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"
        s.ShirtTemplate = cfg.shirt
        s.Parent = char
    end
    if cfg.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"
        p.PantsTemplate = cfg.pants
        p.Parent = char
    end
    local old = char:FindFirstChild("AuFfitAccessory")
    if old then old:Destroy() end
    if cfg.accessory and head then
        local objs = loadObjectsStd(cfg.accessory)
        if objs then
            local handle
            for _, o in ipairs(objs) do
                if o:IsA("BasePart") then handle = o; break end
                local f = o:FindFirstChildWhichIsA("BasePart", true)
                if f then handle = f; break end
            end
            if handle then
                local h = handle:Clone()
                h.Name = "AuFfitAccessory"
                h.CanCollide = false
                h.Anchored = false
                h.Massless = true
                h.Parent = char
                local weld = Instance.new("Weld")
                weld.Part0 = head
                weld.Part1 = h
                weld.C0 = _CFnew(cfg.offset)
                weld.Parent = h
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end
    if cfg.headlessKorblox then
        applyHeadlessKorblox(char)
    else
        if char then
            local head2 = char:FindFirstChild("Head")
            if head2 then
                head2.Transparency = 0
                head2.CanCollide = true
                head2.LocalTransparencyModifier = 0
                local face2 = head2:FindFirstChild("face")
                if face2 then face2.Transparency = 0 end
            end
            pcall(function()
                local neck = char:FindFirstChild("Neck")
                if neck then neck.Enabled = true end
            end)
            for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
                local limb = char:FindFirstChild(partName)
                if limb then limb.Transparency = 0 end
            end
            local oldKorblox = char:FindFirstChild("Korblox_RightLeg")
            if oldKorblox then oldKorblox:Destroy() end
        end
    end
    if outfitSelectorLabel then outfitSelectorLabel.Text = cfg.label end
end

speedMode = false
speedButtonScale = 1
spinEnabled = false
spinReady = false
spinSpeed = 32
spinHeartbeatConn = nil
spinLostAt = 0
setSpinVisual = nil
antiRagdollMode = "off"
antiDieEnabled = false
antiBatEnabled = false
antiFlingEnabled = false
jumpEnabled = false
laggerToggled = false
laggerCarryToggled = false
medusaCounterEnabled = false
batCounterEnabled = false
unwalkEnabled = false
autoLeftEnabled = false
autoRightEnabled = false
autoBatEnabled = false
dropMode = 1
antiLagEnabled = false
removeAccessoriesEnabled = false
stretchEnabled = false
stretchFOV = 120
uiLocked = false
mobileButtonsLocked = false
uiScaleValue = 90
espEnabled = false
espLineEnabled = false

vividGraphicsEnabled = false
_vividEffects = {}
setVividVisual = nil

hideButtonsEnabled = false
setHideButtonsVisual = nil
skipIntroEnabled = false
setSkipIntroVisual = nil

bodyLockEnabled = false
bodyLockRange = 20
bodyLockRangeBox = nil
_bodyLockConn = nil

-- Auto TP Down (dipindahkan dari VISIBLE HUB V2): teleport ke bawah saat di udara & tinggi >= TP Height
autoTPDownEnabled = false
autoTPDownHeight = 20
autoTPDownBox = nil
setAutoTPDownVisual = nil
_autoTPDownThread = nil
_blSuppressCount = 0
_blWasEnabled = false
_blRestoreTimer = nil
_blSmoothRestore = false

savedProgressBarPos = nil
savedButtonPositions = {}
savedMobilePanelPos = nil

neonWeatherEnabled = false
skyTheme = "Off"
skySelectorLabel = nil
_originalLighting = nil
setNeonWeatherVisual = nil


lastMoveDir = _V3zero

local CoreGui = game:GetService("CoreGui")

local InfiniteJump = {
    enabled = false,
    mode = "hold",
    jumpPower = 55,
    minVelocity = 35,
    fallClamp = -120,
    jumpConn = nil,
    heartbeatConn = nil,
    presimConn = nil,
}

local function applyInfJumpBoost(root)
    if not root then return end
    local velocity = root.AssemblyLinearVelocity
    if velocity.Y < InfiniteJump.minVelocity then
        root.AssemblyLinearVelocity = _V3new(velocity.X, InfiniteJump.jumpPower, velocity.Z)
    end
    if velocity.Y < InfiniteJump.fallClamp then
        root.AssemblyLinearVelocity = _V3new(velocity.X, InfiniteJump.fallClamp, velocity.Z)
    end
end

local function onJumpRequest()
    if not InfiniteJump.enabled then return end
    if _G.__VisibleNoJumpActive then return end -- aimbot menyala: loncat diblok
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        pcall(function()
            root.AssemblyLinearVelocity = _V3new(
                root.AssemblyLinearVelocity.X,
                InfiniteJump.jumpPower,
                root.AssemblyLinearVelocity.Z
            )
        end)
    end
end

local function onPreSimulation()
    if not InfiniteJump.enabled then return end
    if _G.__VisibleNoJumpActive then return end -- aimbot menyala: loncat diblok
    if InfiniteJump.mode ~= "hold" then return end
    local char = LP.Character
    if not char then return end
    local hum  = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    local held = UIS:IsKeyDown(Enum.KeyCode.Space)
        or UIS:IsKeyDown(Enum.KeyCode.ButtonA)
        or (hum.Jump == true)

    if held then
        applyInfJumpBoost(root)
    else
        local v = root.AssemblyLinearVelocity
        if v.Y < InfiniteJump.fallClamp then
            root.AssemblyLinearVelocity = _V3new(v.X, InfiniteJump.fallClamp, v.Z)
        end
    end
end

local function connectEvents()
    if InfiniteJump.jumpConn then InfiniteJump.jumpConn:Disconnect() end
    if InfiniteJump.heartbeatConn then InfiniteJump.heartbeatConn:Disconnect() end
    if InfiniteJump.presimConn then InfiniteJump.presimConn:Disconnect() end
    InfiniteJump.jumpConn = UIS.JumpRequest:Connect(onJumpRequest)
    InfiniteJump.presimConn = RunService.PreSimulation:Connect(onPreSimulation)
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
    if InfiniteJump.presimConn then InfiniteJump.presimConn:Disconnect(); InfiniteJump.presimConn = nil end
end

function InfiniteJump.setJumpPower(power)
    power = tonumber(power) or 55
    InfiniteJump.jumpPower = _clamp(power, 10, 200)
end

function InfiniteJump.setMode(mode)
    InfiniteJump.mode = mode == "manual" and "manual" or "hold"
end

function InfiniteJump.isRunning() return InfiniteJump.enabled == true end

InfiniteJump.stop()

function getActiveMoveSpeed()
    -- Mantener sincronizado el motor alternativo con los valores editados en la UI.
    if MVPVenixCarry then
        MVPVenixCarry.normalSpeed = tonumber(NS) or MVPVenixCarry.normalSpeed or 60
        MVPVenixCarry.carrySpeed = tonumber(CS) or MVPVenixCarry.carrySpeed or 38
        MVPVenixCarry.laggerSpeed = tonumber(LAGGER_SPEED) or MVPVenixCarry.laggerSpeed or 30
        MVPVenixCarry.laggerCarrySpeed = tonumber(LAGGER_CARRY_SPEED) or MVPVenixCarry.laggerCarrySpeed or 36
        MVPVenixCarry.speedToggled = speedMode == true
        MVPVenixCarry.laggerMode = laggerCarryToggled and 2 or (laggerToggled and 1 or 0)
    end
    if useVenixCarryEngine and MVPVenixCarry and MVPVenixCarry:isRunning() then
        return tonumber(MVPVenixCarry:getActiveSpeed()) or tonumber(NS) or 60
    end
    if laggerCarryToggled then return tonumber(LAGGER_CARRY_SPEED) or 36
    elseif laggerToggled then return tonumber(LAGGER_SPEED) or 30
    elseif speedMode then return tonumber(CS) or 38
    else return tonumber(NS) or 60 end
end

function getSpeedModeName()
    if useVenixCarryEngine and MVPVenixCarry and MVPVenixCarry.softStealEnabled and MVPVenixCarry.softStealLatched then return "AUTO CARRY" end
    if laggerToggled or laggerCarryToggled then return "LAGGER"
    elseif speedMode then return "CARRY"
    else return "NORMAL" end
end

local _s2VelState = {root = nil, v = _V3zero}
local _velChecked = setmetatable({}, {__mode = "k"})
local _hookedVelParts = {}
local _velocityHook = _G.__MVPVelocityHook or {hooked = false, roots = setmetatable({}, {__mode = "k"})}
_G.__MVPVelocityHook = _velocityHook
local function _hookVelHRP(root)
    if not root then return end
    _s2VelState.root = root
    _velChecked[root] = true
    _velocityHook.roots[root] = true
    if _velocityHook.hooked then return end
    if type(getrawmetatable) ~= "function" or type(setreadonly) ~= "function"
        or type(newcclosure) ~= "function" or type(checkcaller) ~= "function" then return end
    pcall(function()
        local mt = getrawmetatable(root)
        if not mt then return end
        local oldIndex = rawget(mt, "__index")
        if type(oldIndex) ~= "function" and type(oldIndex) ~= "table" then return end
        local function original(obj, key)
            if type(oldIndex) == "function" then return oldIndex(obj, key) end
            return oldIndex[key]
        end
        setreadonly(mt, false)
        mt.__index = newcclosure(function(obj, key)
            if not checkcaller() and _velocityHook.roots[obj]
                and (key == "AssemblyLinearVelocity" or key == "Velocity") then
                local real = original(obj, key)
                if real and real.Magnitude > 20 then return real.Unit * 20 end
                return real
            end
            return original(obj, key)
        end)
        setreadonly(mt, true)
        _velocityHook.hooked = true
    end)
end
local function _setupVelChecked(character)
    _velocityHook.roots = setmetatable({}, {__mode = "k"})
    _velChecked = setmetatable({}, {__mode = "k"})
    if not character then _s2VelState.root = nil; return nil end
    local root = character:WaitForChild("HumanoidRootPart", 5)
    if root then _s2VelState.root = root; _velChecked[root] = true; _velocityHook.roots[root] = true end
    return root
end
if LP.Character then _hookVelHRP(_setupVelChecked(LP.Character)) end
local function _isRagdollState(hum)
    if not hum then return true end
    local state = hum:GetState()
    return hum.PlatformStand or state == Enum.HumanoidStateType.Physics
        or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown
end
local function _applyVelocitySpeed(direction, speed, root)
    if not root or not root.Parent then return end
    if autoBatEnabled or TPBatState.enabled or (_G.__VisibleHubIsBatV2 and _G.__VisibleHubIsBatV2())
        or ((_G.__VisibleAimbotIsOn and _G.__VisibleAimbotIsOn()) or (_G.__VisibleLagIsOn and _G.__VisibleLagIsOn())) then return end
    if type(speed) ~= "number" or speed ~= speed or speed <= 0 or speed == math.huge then return end
    local y = root.AssemblyLinearVelocity.Y
    if direction and direction.Magnitude > 0.05 then
        pcall(function() root:SetNetworkOwner(LP) end)
        local unit = direction.Unit
        root.AssemblyLinearVelocity = _V3new(unit.X * speed, y, unit.Z * speed)
    else
        root.AssemblyLinearVelocity = _V3new(0, y, 0)
    end
    _G.__VisibleHubLiveSpeed = {t = os.clock(), v = speed}
end
function getAutoPathSpeed()
    if laggerCarryToggled or laggerToggled then return LAGGER_SPEED end
    return NS
end

        MVPVenixCarry = {
            normalSpeed = NS,
            carrySpeed = CS,
            laggerSpeed = LAGGER_SPEED,
            laggerCarrySpeed = LAGGER_CARRY_SPEED,
            speedToggled = false,
            laggerMode = 0,
            softStealEnabled = false,
            softStealRadius = 10,
            softStealSpeed = 30,
            softStealLatched = false,
            _isCarrying = false,
            _lastCarryCheck = 0,
            _lvBoost = nil,
            _lvAtt = nil,
            _blockedTime = 0,
            _maxForce = 2200,
            _freeForce = 500,
            _heartbeatConn = nil,
            _softStealScanner = nil,
            _softStealAnimals = {},
            _softStealScanning = false,
            _state = nil,
            _dropInProgress = false,
            _batAimbotToggled = false,
            _rayParams = nil,
            _rayFilter = nil,
            _rayFilterTime = 0,
            isCarrying = function(self)
                local now = _tick()
                if now - (self._lastCarryCheck or 0) < 0.1 then
                    return self._isCarrying
                end
                self._lastCarryCheck = now
                local character = LP.Character
                if not character then
                    self._isCarrying = false
                    return false
                end
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local walkSpeed = humanoid and humanoid.WalkSpeed or 16
                local isCarrying = walkSpeed < 25 and walkSpeed > 0
                local ok, result = pcall(function()
                    return LP:GetAttribute("Stealing")
                end)
                ok = ok and result == true
                local isEnabled = false
                if ok then
                    isEnabled = true
                end
                local ok2, result2 = pcall(function()
                    return character:GetAttribute("Stealing")
                end)
                if ok2 and result2 == true then
                    isEnabled = true
                end
                if not isEnabled then
                    for _, name in ipairs({
                        "Carrying",
                        "IsCarrying",
                        "Grabbed",
                        "Holding",
                        "StealHold",
                        "HasGrab",
                    }) do
                        local instance = character:FindFirstChild(name)
                        if instance then
                            if
                                instance:IsA("BoolValue") and instance.Value
                                or instance:IsA("ObjectValue") and instance.Value
                                or instance:IsA("StringValue") and instance.Value ~= ""
                            then
                                isEnabled = true
                                break
                            end
                        end
                    end
                end
                self._isCarrying = isCarrying or isEnabled
                return self._isCarrying
            end,
            getActiveSpeed = function(self)
                if self._state and (self._state.autoLeftEnabled or self._state.autoRightEnabled) then
                    return self.normalSpeed
                end
                if self.softStealEnabled then
                    local _, distance = self:getNearestSoftStealAnimal(self.softStealRadius)
                    if distance and distance <= self.softStealRadius then
                        self.softStealLatched = true
                        return self.softStealSpeed
                    end
                    if self.softStealLatched and self:isCarrying() then
                        return self.softStealSpeed
                    end
                    self.softStealLatched = false
                end
                if self.laggerMode == 1 then
                    return self.laggerSpeed
                end
                if self.laggerMode == 2 then
                    return self.laggerCarrySpeed
                end
                if self.speedToggled then
                    return self.carrySpeed
                end
                return self.normalSpeed
            end,
            getStatus = function(self)
                if not (self._state and (self._state.autoLeftEnabled or self._state.autoRightEnabled)) then
                    if self.softStealEnabled then
                        local _, distance = self:getNearestSoftStealAnimal(self.softStealRadius)
                        if
                            distance and distance <= self.softStealRadius
                            or self.softStealLatched and self:isCarrying()
                        then
                            return "AUTO CARRY", self.softStealSpeed
                        end
                    end
                    if self.laggerMode == 1 then
                        return "LAGGER", self.laggerSpeed
                    end
                    if self.laggerMode == 2 then
                        return "LAGGER CARRY", self.laggerCarrySpeed
                    end
                    if self.speedToggled then
                        return "CARRY", self.carrySpeed
                    end
                    return "NORMAL", self.normalSpeed
                end
                return "NORMAL", self.normalSpeed
            end,
        }
        do
            local function destroyLV()
                if MVPVenixCarry._lvBoost and MVPVenixCarry._lvBoost.Parent then
                    pcall(function()
                        MVPVenixCarry._lvBoost:Destroy()
                    end)
                end
                if MVPVenixCarry._lvAtt and MVPVenixCarry._lvAtt.Parent then
                    pcall(function()
                        MVPVenixCarry._lvAtt:Destroy()
                    end)
                end
                MVPVenixCarry._lvBoost = nil
                MVPVenixCarry._lvAtt = nil
            end
            local function setupLV(parent)
                if MVPVenixCarry._lvBoost and MVPVenixCarry._lvBoost.Parent == parent then
                    return
                end
                destroyLV()
                local attachment = Instance.new("Attachment")
                attachment.Parent = parent
                local linearVelocity = Instance.new("LinearVelocity")
                linearVelocity.Name = "MVPCarryBoost"
                attachment.Name = "MVPCarryAttachment"
                linearVelocity.Attachment0 = attachment
                linearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
                linearVelocity.PrimaryTangentAxis = _V3new(1, 0, 0)
                linearVelocity.SecondaryTangentAxis = _V3new(0, 0, 1)
                linearVelocity.MaxForce = MVPVenixCarry._maxForce
                linearVelocity.PlaneVelocity = Vector2.zero
                linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
                linearVelocity.Parent = parent
                MVPVenixCarry._lvAtt = attachment
                MVPVenixCarry._lvBoost = linearVelocity
                pcall(function()
                    parent:SetNetworkOwner(LP)
                end)
            end
            MVPVenixCarry.scanSoftStealAnimals = function(self)
                self._softStealAnimals = {}
                local plots = Workspace:FindFirstChild("Plots")
                if not plots then
                    return
                end
                for _, child in ipairs(plots:GetChildren()) do
                    if child:IsA("Model") then
                        local animalPodiums = child:FindFirstChild("AnimalPodiums")
                        if animalPodiums then
                            for _, child2 in ipairs(animalPodiums:GetChildren()) do
                                if child2:IsA("Model") then
                                    local base = child2:FindFirstChild("Base")
                                    base = base and base:FindFirstChild("Spawn")
                                    if base then
                                        table.insert(self._softStealAnimals, {
                                            plot = child.Name,
                                            slot = child2.Name,
                                            worldPosition = base.Position,
                                            uid = child.Name .. "_" .. child2.Name,
                                        })
                                    end
                                end
                            end
                        end
                    end
                end
            end
            MVPVenixCarry.startSoftStealScanner = function(callback)
                if callback._softStealScanner then
                    return
                end
                callback._softStealScanning = true
                callback:scanSoftStealAnimals()
                local accumulator = 0
                callback._softStealScanner = RunService.Heartbeat:Connect(function(dt)
                    accumulator = accumulator + dt
                    if accumulator < 0.2 then return end
                    accumulator = 0
                    if not callback._softStealScanning then
                        return
                    end
                    callback:scanSoftStealAnimals()
                end)
            end
            MVPVenixCarry.stopSoftStealScanner = function(self)
                self._softStealScanning = false
                if self._softStealScanner then
                    self._softStealScanner:Disconnect()
                    self._softStealScanner = nil
                end
            end
            MVPVenixCarry.getNearestSoftStealAnimal = function(self, radius)
                local character = LP.Character
                if character then
                    character = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
                end
                if not character then
                    return nil, _huge
                end
                local softStealAnimals = self._softStealAnimals
                local position = character.Position
                local bestDistance = _huge
                local animals = nil
                for i = 1, #softStealAnimals do
                    local rootPart = softStealAnimals[i]
                    if rootPart.worldPosition then
                        local dx = position.X - rootPart.worldPosition.X
                        local dy = position.Y - rootPart.worldPosition.Y
                        local dz = position.Z - rootPart.worldPosition.Z
                        local distance = _sqrt(dx * dx + dy * dy + dz * dz)
                        if distance < bestDistance then
                            bestDistance = distance
                            animals = rootPart
                        end
                    end
                end
                if radius and bestDistance > radius then
                    return nil, bestDistance
                end
                return animals, bestDistance
            end
            MVPVenixCarry.updateMovement = function(self, deltaTime)
                local character = LP.Character
                if not character then
                    return
                end
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if not humanoidRootPart or not humanoid or humanoid.Health <= 0 then
                    return
                end
                local speed = self:getActiveSpeed()
                local moveDirection = humanoid.MoveDirection
                local moving = moveDirection.Magnitude > 0.1
                local unit = nil
                if moving then
                    if not self._rayParams then
                        self._rayParams = _RayParams_new()
                        self._rayParams.FilterType = Enum.RaycastFilterType.Exclude
                        self._rayFilter = {}
                        self._rayFilterTime = 0
                    end
                    local now = _tick()
                    if now - self._rayFilterTime > 1 then
                        self._rayFilterTime = now
                        local rayFilter = self._rayFilter
                        while #rayFilter > 0 do
                            rayFilter[#rayFilter] = nil
                        end
                        rayFilter[1] = character
                        local plist = _GetPlayersCached()
                        for i = 1, #plist do
                            local p = plist[i]
                            if p.Character then
                                rayFilter[#rayFilter + 1] = p.Character
                            end
                        end
                        self._rayParams.FilterDescendantsInstances = rayFilter
                    else
                        local rayFilter = self._rayFilter
                        local found = false
                        for i = 1, #rayFilter do
                            if rayFilter[i] == character then
                                found = true
                                break
                            end
                        end
                        if not found then
                            rayFilter[1] = character
                            self._rayParams.FilterDescendantsInstances = rayFilter
                        end
                    end
                    local unit2 = _V3new(moveDirection.X, 0, moveDirection.Z).Unit
                    local rayParams = self._rayParams
                    local hit =
                        Workspace:Raycast(humanoidRootPart.Position + _V3new(0, 1, 0), unit2 * 2.5, rayParams)
                    local canCollide = hit and hit.Instance and hit.Instance.CanCollide
                    unit = nil
                    if canCollide then
                        local nf = _V3new(hit.Normal.X, 0, hit.Normal.Z)
                        unit = nil
                        if nf.Magnitude > 0.7 then
                            unit = nf.Unit
                        end
                    end
                end
                local hVelocity =
                    _V3new(humanoidRootPart.AssemblyLinearVelocity.X, 0, humanoidRootPart.AssemblyLinearVelocity.Z)
                local blocked = unit ~= nil or moving and hVelocity.Magnitude < 2
                local _ccNow = _tick()
                if blocked and _ccNow - (self._ccTime or 0) > 0.2 then
                    self._ccTime = _ccNow
                    for _, child in ipairs(character:GetChildren()) do
                        if child:IsA("Model") then
                            for _, descendant in ipairs(child:GetDescendants()) do
                                if descendant:IsA("BasePart") and descendant.CanCollide then
                                    descendant.CanCollide = false
                                end
                            end
                        end
                    end
                    for _, name in ipairs({
                        "Carrying",
                        "IsCarrying",
                        "Grabbed",
                        "Holding",
                        "StealHold",
                        "HasGrab",
                    }) do
                        local instance = character:FindFirstChild(name)
                        if
                            instance
                            and instance:IsA("ObjectValue")
                            and instance.Value
                            and instance.Value:IsA("Model")
                        then
                            for _, descendant in ipairs(instance.Value:GetDescendants()) do
                                if descendant:IsA("BasePart") and descendant.CanCollide then
                                    descendant.CanCollide = false
                                end
                            end
                        end
                    end
                end
                local state = humanoid:GetState()
                if
                    not (
                        state == Enum.HumanoidStateType.Physics
                        or state == Enum.HumanoidStateType.Ragdoll
                        or state == Enum.HumanoidStateType.FallingDown
                        or self._dropInProgress
                        or self._batAimbotToggled
                    )
                then
                    if not MVPVenixCarry._lvBoost or MVPVenixCarry._lvBoost.Parent ~= humanoidRootPart then
                        setupLV(humanoidRootPart)
                    end
                    local lvBoost = MVPVenixCarry._lvBoost
                    if lvBoost then
                        if not lvBoost.Enabled then
                            lvBoost.Enabled = true
                        end
                        if 0.1 < moveDirection.Magnitude then
                            local unit2 = _V3new(moveDirection.X, 0, moveDirection.Z).Unit
                            if unit then
                                local wanted = unit2 * speed
                                local along = wanted - unit * wanted:Dot(unit)
                                if along.Magnitude < 0.5 then
                                    lvBoost.PlaneVelocity = Vector2.zero
                                else
                                    lvBoost.PlaneVelocity = Vector2.new(along.X, along.Z)
                                end
                            else
                                lvBoost.PlaneVelocity = Vector2.new(unit2.X * speed, unit2.Z * speed)
                            end
                        else
                            lvBoost.PlaneVelocity = Vector2.zero
                        end
                        if blocked then
                            self._blockedTime = self._blockedTime + (deltaTime or 0.016)
                        else
                            self._blockedTime = 0
                        end
                        if self._blockedTime > 0.35 then
                            if lvBoost.MaxForce ~= self._freeForce then
                                lvBoost.MaxForce = self._freeForce
                            end
                        elseif lvBoost.MaxForce ~= self._maxForce then
                            lvBoost.MaxForce = self._maxForce
                        end
                    end
                elseif MVPVenixCarry._lvBoost then
                    MVPVenixCarry._lvBoost.PlaneVelocity = Vector2.zero
                    if MVPVenixCarry._lvBoost.Enabled then
                        MVPVenixCarry._lvBoost.Enabled = false
                    end
                end
            end
            MVPVenixCarry.start = function(deltaTime236)
                if deltaTime236._heartbeatConn then
                    return
                end
                deltaTime236._heartbeatConn = RunService.Heartbeat:Connect(function(deltaTime)
                    if _mySession ~= _G.VisibleHubSession then deltaTime236:stop(); return end
                    deltaTime236.normalSpeed = NS
                    deltaTime236.carrySpeed = CS
                    deltaTime236.laggerSpeed = LAGGER_SPEED
                    deltaTime236.laggerCarrySpeed = LAGGER_CARRY_SPEED
                    deltaTime236.speedToggled = speedMode
                    deltaTime236.laggerMode = laggerCarryToggled and 2 or (laggerToggled and 1 or 0)
                    deltaTime236._state = {autoLeftEnabled = autoLeftEnabled, autoRightEnabled = autoRightEnabled}
                    deltaTime236._dropInProgress = dropActive or _G.IsDropping or autoLeftEnabled or autoRightEnabled
                    deltaTime236._batAimbotToggled = autoBatEnabled or TPBatState.enabled
                        or (_G.__VisibleHubIsBatV2 and _G.__VisibleHubIsBatV2())
                        or ((_G.__VisibleAimbotIsOn and _G.__VisibleAimbotIsOn()) or (_G.__VisibleLagIsOn and _G.__VisibleLagIsOn()))
                    deltaTime236:updateMovement(deltaTime)
                end)
                if deltaTime236.softStealEnabled then
                    deltaTime236:startSoftStealScanner()
                end
                print("[CarrySystem] Activado")
            end
            MVPVenixCarry.stop = function(self)
                if self._heartbeatConn then
                    self._heartbeatConn:Disconnect()
                    self._heartbeatConn = nil
                end
                self:stopSoftStealScanner()
                destroyLV()
                self.softStealLatched = false
                print("[CarrySystem] Desactivado")
            end
        end
    MVPVenixCarry.setNormalSpeed = function(self, value)
        self.normalSpeed = _clamp(value, 1, 500)
    end
    MVPVenixCarry.setCarrySpeed = function(self, value)
        self.carrySpeed = _clamp(value, 1, 500)
    end
    MVPVenixCarry.setLaggerSpeed = function(self, value)
        self.laggerSpeed = _clamp(value, 0.1, 500)
    end
    MVPVenixCarry.setLaggerCarrySpeed = function(self, value)
        self.laggerCarrySpeed = _clamp(value, 0.1, 500)
    end
    MVPVenixCarry.setSoftStealSpeed = function(self, value)
        self.softStealSpeed = _clamp(value, 1, 500)
    end
    MVPVenixCarry.setSoftStealRadius = function(self, value)
        self.softStealRadius = _clamp(value, 1, 200)
    end
    MVPVenixCarry.toggleCarryMode = function(self)
        self.speedToggled = not self.speedToggled
    end
    MVPVenixCarry.setLaggerMode = function(self, mode)
        if mode == 0 then
            self.laggerMode = 0
        elseif mode == 1 then
            self.laggerMode = 1
        elseif mode == 2 then
            self.laggerMode = 2
        end
    end
    MVPVenixCarry.toggleLaggerMode = function(self)
        if self.laggerMode == 0 then
            self.laggerMode = 1
        elseif self.laggerMode == 1 then
            self.laggerMode = 2
        else
            self.laggerMode = 0
        end
    end
    MVPVenixCarry.setSoftStealEnabled = function(self, softStealEnabled)
        self.softStealEnabled = softStealEnabled
        if softStealEnabled then
            self:startSoftStealScanner()
        else
            self:stopSoftStealScanner()
            self.softStealLatched = false
        end
    end
    MVPVenixCarry.toggleSoftSteal = function(self)
        self:setSoftStealEnabled(not self.softStealEnabled)
    end
    MVPVenixCarry.isRunning = function(self)
        return self._heartbeatConn ~= nil
    end
    MVPVenixCarry.getCurrentSpeed = function(self)
        return self:getActiveSpeed()
    end

-- ============================================================
-- ANIMATION (dipindahkan persis dari H_yjue: preset animasi "ANIMATION SOURCE" + toggle master "Animaciones").
-- Animation lama VISIBLE HUB (Anim Pack) sudah dihapus dan diganti dengan ini.
-- Preset diterapkan langsung ke script Animate karakter (idle/walk/run/jump/fall/climb/swim),
-- animasi asli disimpan per karakter supaya bisa dikembalikan saat toggle dimatikan.
-- ============================================================
HY_ANIM_NAMES = {"Adidas Sports", "Adidas Community", "Adidas Aura", "Wicked Popular", "Elder", "Zombie", "Mage", "Catwalk Glam", "Astronaut", "Wicked \"Dancing Through Life\"", "Werewolf", "Superhero", "Toy", "No Boundaries", "NFL", "Amazon Unboxed", "Vampire", "Ninja", "Robot", "Levitation", "Stylish", "Bubbly", "Cartoon"}
HY_ANIM_PRESETS = {["Adidas Sports"] = {WalkAnim = 18537392113, RunAnim = 18537384940, JumpAnim = 18537380791, FallAnim = 18537367238, SwimIdle = 18537387180, Swim = 18537389531, Animation1 = 18537376492, Animation2 = 18537371272, ClimbAnim = 18537363391}, ["Adidas Community"] = {WalkAnim = 122150855457006, RunAnim = 82598234841035, JumpAnim = 75290611992385, FallAnim = 98600215928904, SwimIdle = 109346520324160, Swim = 133308483266208, Animation1 = 122257458498464, Animation2 = 102357151005774, ClimbAnim = 88763136693023}, ["Adidas Aura"] = {WalkAnim = 83842218823011, RunAnim = 118320322718866, JumpAnim = 109996626521204, FallAnim = 95603166884636, SwimIdle = 94922130551805, Swim = 134530128383903, Animation1 = 110211186840347, Animation2 = 114191137265065, ClimbAnim = 97824616490448}, ["Wicked Popular"] = {WalkAnim = 92072849924640, RunAnim = 72301599441680, JumpAnim = 104325245285198, FallAnim = 121152442762481, Animation1 = 118832222982049, ClimbAnim = 131326830509784, SwimIdle = 113199415118199, Swim = 99384245425157, Animation2 = 76049494037641}, Elder = {WalkAnim = 10921111375, RunAnim = 10921104374, JumpAnim = 10921107367, FallAnim = 10921105765, SwimIdle = 10921110146, Swim = 10921108971, ClimbAnim = 10921100400, Animation1 = 10921101664, Animation2 = 10921102574}, Zombie = {WalkAnim = 10921355261, RunAnim = 616163682, JumpAnim = 10921351278, FallAnim = 10921350320, SwimIdle = 10921353442, Swim = 10921352344, Animation1 = 10921344533, Animation2 = 10921345304, ClimbAnim = 10921343576}, Mage = {WalkAnim = 10921152678, RunAnim = 10921148209, JumpAnim = 10921149743, FallAnim = 10921148939, SwimIdle = 10921151661, Swim = 10921150788, ClimbAnim = 10921143404, Animation1 = 10921144709, Animation2 = 10921145797}, ["Catwalk Glam"] = {WalkAnim = 109168724482748, RunAnim = 81024476153754, JumpAnim = 116936326516985, FallAnim = 92294537340807, SwimIdle = 98854111361360, Swim = 134591743181628, ClimbAnim = 119377220967554, Animation1 = 133806214992291, Animation2 = 94970088341563}, Astronaut = {WalkAnim = 10921046031, RunAnim = 10921039308, JumpAnim = 10921042494, FallAnim = 10921040576, SwimIdle = 10921045006, Swim = 10921044000, ClimbAnim = 10921032124, Animation1 = 10921034824, Animation2 = 10921036806}, ["Wicked \"Dancing Through Life\""] = {WalkAnim = 73718308412641, RunAnim = 135515454877967, JumpAnim = 78508480717326, FallAnim = 78147885297412, SwimIdle = 129183123083281, Swim = 110657013921774, ClimbAnim = 129447497744818, Animation1 = 92849173543269, Animation2 = 132238900951109}, Werewolf = {WalkAnim = 10921342074, RunAnim = 10921336997, FallAnim = 10921337907, SwimIdle = 10921341319, Swim = 10921340419, ClimbAnim = 10921329322, Animation1 = 10921330408, Animation2 = 10921333667}, Superhero = {WalkAnim = 10921298616, RunAnim = 10921291831, JumpAnim = 10921294559, FallAnim = 10921293373, SwimIdle = 10921297391, Swim = 10921295495, ClimbAnim = 10921286911, Animation1 = 10921288909, Animation2 = 10921290167}, Toy = {WalkAnim = 10921312010, RunAnim = 10921306285, JumpAnim = 10921308158, FallAnim = 10921307241, SwimIdle = 10921310341, Swim = 10921309319, ClimbAnim = 10921300839, Animation1 = 10921301576}, ["No Boundaries"] = {WalkAnim = 18747074203, RunAnim = 18747070484, JumpAnim = 18747069148, FallAnim = 18747062535, SwimIdle = 18747071682, Swim = 18747073181, ClimbAnim = 18747060903, Animation1 = 18747067405, Animation2 = 18747063918}, NFL = {WalkAnim = 110358958299415, RunAnim = 117333533048078, JumpAnim = 119846112151352, FallAnim = 129773241321032, SwimIdle = 79090109939093, Swim = 132697394189921, ClimbAnim = 134630013742019, Animation1 = 92080889861410, Animation2 = 74451233229259}, ["Amazon Unboxed"] = {WalkAnim = 90478085024465, RunAnim = 134824450619865, JumpAnim = 121454505477205, FallAnim = 94788218468396, SwimIdle = 129126268464847, Swim = 105962919001086, ClimbAnim = 121145883950231, Animation1 = 98281136301627}, Vampire = {WalkAnim = 10921326949, RunAnim = 10921320299, JumpAnim = 10921322186, FallAnim = 10921321317, SwimIdle = 10921325443, Swim = 10921324408, ClimbAnim = 10921314188, Animation1 = 10921315373}, Ninja = {RunAnim = 656118852, WalkAnim = 656121766, JumpAnim = 656117878, FallAnim = 656115606, Swim = 656119721, SwimIdle = 656121397, ClimbAnim = 656114359, Idle = {656117400, 656118341, 886742569}}, Robot = {RunAnim = 616091570, WalkAnim = 616095330, JumpAnim = 616090535, FallAnim = 616087089, Swim = 616092998, SwimIdle = 616094091, ClimbAnim = 616086039, Idle = {616088211, 616089559, 885531463}}, Levitation = {RunAnim = 616010382, WalkAnim = 616013216, JumpAnim = 616008936, FallAnim = 616005863, Swim = 616011509, SwimIdle = 616012453, ClimbAnim = 616003713, Idle = {616006778, 616008087, 886862142}}, Stylish = {RunAnim = 616140816, WalkAnim = 616146177, JumpAnim = 616139451, FallAnim = 616134815, Swim = 616143378, SwimIdle = 616144772, ClimbAnim = 616133594, Idle = {616136790, 616138447, 886888594}}, Bubbly = {RunAnim = 910025107, WalkAnim = 910034870, JumpAnim = 910016857, FallAnim = 910001910, Swim = 910028158, SwimIdle = 910030921, ClimbAnim = 909997997, Idle = {910004836, 910009958, 1018536639}}, Cartoon = {RunAnim = 742638842, WalkAnim = 742640026, JumpAnim = 742637942, FallAnim = 742637151, Swim = 742639220, SwimIdle = 742639812, ClimbAnim = 742636889, Idle = {742637544, 742638445, 885477856}}}

hyAnimOn = false
hyAnimPreset = HY_ANIM_NAMES[1]
hyAnimLabel = nil
hyAnimToggleSet = nil
hyAnimOriginals = setmetatable({}, {__mode = "k"})

local function hyAnimId(v)
    if type(v) == "number" then
        return "rbxassetid://" .. tostring(v)
    end
    if type(v) == "string" and string.match(v, "^%d+$") then
        return "rbxassetid://" .. v
    end
    return v
end

-- simpan animasi asli karakter (sama seperti H_yjue, ikut membaca HumanoidDescription)
local function hyAnimCaptureOriginals(char, slots, saved)
    saved = saved or {}
    if next(saved) == nil then
        for key, obj in pairs(slots) do
            if obj then
                saved[key] = obj.AnimationId
            end
        end
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local okDesc, desc = pcall(function()
        return hum and hum:GetAppliedDescription()
    end)
    if okDesc and desc then
        local function fromDesc(slot, prop)
            local id = tonumber(desc[prop])
            if id and id > 0 and slots[slot] then
                saved[slot] = "rbxassetid://" .. tostring(id)
            end
        end
        fromDesc("idle1", "IdleAnimation")
        fromDesc("idle2", "IdleAnimation")
        fromDesc("walk", "WalkAnimation")
        fromDesc("run", "RunAnimation")
        fromDesc("jump", "JumpAnimation")
        fromDesc("fall", "FallAnimation")
        fromDesc("climb", "ClimbAnimation")
        fromDesc("swim", "SwimAnimation")
        fromDesc("swimidle", "SwimAnimation")
    end
    return saved
end

-- terapkan preset (restore = true: kembalikan animasi asli)
function hyAnimApply(name, restore)
    local char = LP.Character
    local animate = char and (char:FindFirstChild("Animate") or char:WaitForChild("Animate", 3))
    if not animate then return false end
    local slots = {
        idle1 = animate:FindFirstChild("idle") and animate.idle:FindFirstChild("Animation1"),
        idle2 = animate:FindFirstChild("idle") and animate.idle:FindFirstChild("Animation2"),
        walk = animate:FindFirstChild("walk") and animate.walk:FindFirstChild("WalkAnim"),
        run = animate:FindFirstChild("run") and animate.run:FindFirstChild("RunAnim"),
        jump = animate:FindFirstChild("jump") and animate.jump:FindFirstChild("JumpAnim"),
        fall = animate:FindFirstChild("fall") and animate.fall:FindFirstChild("FallAnim"),
        climb = animate:FindFirstChild("climb") and animate.climb:FindFirstChild("ClimbAnim"),
        swim = animate:FindFirstChild("swim") and animate.swim:FindFirstChild("Swim"),
        swimidle = animate:FindFirstChild("swimidle") and animate.swimidle:FindFirstChild("SwimIdle"),
    }
    if restore then
        local saved = hyAnimOriginals[char]
        if not saved then return false end
        for slot, id in pairs(saved) do
            if slots[slot] then
                slots[slot].AnimationId = id
            end
        end
    else
        local preset = HY_ANIM_PRESETS[name]
        if not preset then return false end
        hyAnimOriginals[char] = hyAnimCaptureOriginals(char, slots, hyAnimOriginals[char])
        local idle = preset.Idle or {}
        local ids = {
            idle1 = preset.Animation1 or idle[1], idle2 = preset.Animation2 or idle[2],
            walk = preset.WalkAnim, run = preset.RunAnim, jump = preset.JumpAnim, fall = preset.FallAnim,
            climb = preset.ClimbAnim, swim = preset.Swim, swimidle = preset.SwimIdle,
        }
        for slot, id in pairs(ids) do
            if slots[slot] and id then
                slots[slot].AnimationId = hyAnimId(id)
            end
        end
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
            pcall(function() track:Stop(0) end)
        end
    end
    return true
end

-- toggle master "Animaciones": ON = terapkan preset, OFF = kembalikan animasi asli
function hyAnimSetOn(on)
    on = on == true
    hyAnimOn = on
    if on then
        _G.__VisibleAnimPreset = hyAnimPreset
        pcall(hyAnimApply, hyAnimPreset, false)
    else
        pcall(hyAnimApply, nil, true)
    end
    if hyAnimToggleSet then pcall(hyAnimToggleSet, on) end
end

-- tombol < > : ganti preset, otomatis ON dan langsung diterapkan (sama seperti H_yjue)
function hyAnimSelect(direction)
    local idx = 1
    for i, presetName in ipairs(HY_ANIM_NAMES) do
        if presetName == hyAnimPreset then idx = i; break end
    end
    idx = idx + direction
    if idx < 1 then idx = #HY_ANIM_NAMES end
    if idx > #HY_ANIM_NAMES then idx = 1 end
    hyAnimPreset = HY_ANIM_NAMES[idx]
    if hyAnimLabel then pcall(function() hyAnimLabel.Text = tostring(hyAnimPreset) end) end
    hyAnimSetOn(true)
end

-- respawn: terapkan lagi setelah 0.75 detik (sama seperti H_yjue)
LP.CharacterAdded:Connect(function()
    if _mySession ~= _G.VisibleHubSession then return end
    if not hyAnimOn or not hyAnimPreset then return end
    task.wait(0.75)
    if _mySession ~= _G.VisibleHubSession then return end
    pcall(hyAnimApply, hyAnimPreset, false)
end)

DEFAULT_KB = {
    DropBrainrot = {kb = Enum.KeyCode.X, gp = nil},
    AutoLeft     = {kb = Enum.KeyCode.Z, gp = nil},
    AutoRight    = {kb = Enum.KeyCode.C, gp = nil},
    AutoBat      = {kb = Enum.KeyCode.E, gp = nil},
    TPFloor      = {kb = Enum.KeyCode.F, gp = nil},
    GuiHide      = {kb = Enum.KeyCode.LeftControl, gp = nil},
    CarryToggle  = {kb = Enum.KeyCode.Q, gp = nil},
    LaggerMode   = {kb = Enum.KeyCode.R, gp = nil},
    BatV2        = {kb = Enum.KeyCode.V, gp = nil},
    AimbotV2     = {kb = Enum.KeyCode.B, gp = nil},
}

KB = {
    DropBrainrot = {kb = DEFAULT_KB.DropBrainrot.kb, gp = DEFAULT_KB.DropBrainrot.gp},
    AutoLeft     = {kb = DEFAULT_KB.AutoLeft.kb, gp = DEFAULT_KB.AutoLeft.gp},
    AutoRight    = {kb = DEFAULT_KB.AutoRight.kb, gp = DEFAULT_KB.AutoRight.gp},
    AutoBat      = {kb = DEFAULT_KB.AutoBat.kb, gp = DEFAULT_KB.AutoBat.gp},
    TPFloor      = {kb = DEFAULT_KB.TPFloor.kb, gp = DEFAULT_KB.TPFloor.gp},
    GuiHide      = {kb = DEFAULT_KB.GuiHide.kb, gp = DEFAULT_KB.GuiHide.gp},
    CarryToggle  = {kb = DEFAULT_KB.CarryToggle.kb, gp = DEFAULT_KB.CarryToggle.gp},
    LaggerMode   = {kb = DEFAULT_KB.LaggerMode.kb, gp = DEFAULT_KB.LaggerMode.gp},
    BatV2        = {kb = DEFAULT_KB.BatV2.kb, gp = DEFAULT_KB.BatV2.gp},
    AimbotV2     = {kb = DEFAULT_KB.AimbotV2.kb, gp = DEFAULT_KB.AimbotV2.gp},
}

_isResetting = false
-- Durante el arranque algunos módulos inicializan sus valores en false y
-- pueden llamar a saveAllSettings. No sobrescribir la configuración del
-- usuario hasta terminar la restauración final.
_isBootstrapping = true
_lastSavedJSON = nil
_isLoading = false

CONFIG = {
    AUTO_STEAL_ENABLED = false,
    STEAL_RANGE = 61,
    HOLD_MIN = 0.05,
    HOLD_MAX = 0.15,
    ENTRY_DELAY = 0.1,
    COOLDOWN = 0.2,
    PRIME_RANGE = 60,
}

local plots = workspace:FindFirstChild("Plots")
local stealConnection = nil

local Steal = {
    AutoStealEnabled = false,
    StealRadius = CONFIG.STEAL_RANGE,
    StealDuration = 1.3,
    StealDelay = 0.25,
    Data = {}
}

local isStealing = false
local autoStealMode = "90%"
local autoStealVariant = 2
local autoStealGeneration = 0
autoStealStartedAt = 0
autoStealLastActivity = _tick()
autoStealSupervisorConn = nil
local AUTO_STEAL_VARIANT_NAMES = {"80%", "90%"}
local function setAutoStealMode(mode)
    autoStealVariant = 2
    if mode == "V2" then mode = "80" end
    local wanted = tostring(mode):gsub("%%", "")
    for i, name in ipairs(AUTO_STEAL_VARIANT_NAMES) do
        if name:gsub("%%", "") == wanted then autoStealVariant = i; break end
    end
    autoStealMode = AUTO_STEAL_VARIANT_NAMES[autoStealVariant]
end
local function getAutoStealDuration()
    local factors = {0.80, 0.90}
    return Steal.StealDuration * factors[autoStealVariant]
end

local _plotsCache = nil
local _plotsCacheTime = 0
local function getPlotsRoot()
    local now = _tick()
    if _plotsCache and now - _plotsCacheTime < 2 and _plotsCache.Parent then
        return _plotsCache
    end
    _plotsCache = workspace:FindFirstChild("Plots")
    _plotsCacheTime = now
    return _plotsCache
end

local function isMyPlotByName(plotName)
    local plotsRoot = getPlotsRoot()
    if not plotsRoot then return false end
    local plot = plotsRoot:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then
            return yb.Enabled == true
        end
    end
    return false
end

local function findNearestPrompt()
    local char = LP.Character
    if not char then return nil, nil, nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, nil, nil end
    local plotsRoot = getPlotsRoot()
    if not plotsRoot then return nil, nil, nil end
    local nearestPrompt, nearestDist, nearestName = nil, math.huge, nil
    for _, plot in ipairs(plotsRoot:GetChildren()) do
        local isMine = false
        pcall(function() isMine = isMyPlotByName(plot.Name) end)
        if isMine then continue end
        local pods = plot:FindFirstChild("AnimalPodiums")
        if not pods then continue end
        for _, pod in ipairs(pods:GetChildren()) do
            pcall(function()
                local base = pod:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                if spawn then
                    local dist = (spawn.Position - root.Position).Magnitude
                    if dist < nearestDist and dist <= (Steal.StealRadius or 60) then
                        local att = spawn:FindFirstChild("PromptAttachment")
                        if att then
                            for _, child in ipairs(att:GetChildren()) do
                                if child:IsA("ProximityPrompt")
                                    and child.ActionText
                                    and child.ActionText:find("Steal")
                                then
                                    nearestPrompt = child
                                    nearestDist = dist
                                    nearestName = pod.Name
                                    break
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
    return nearestPrompt, nearestName, nearestDist
end

-- EXECUTE STEAL (lógica de Visible Hub)
stealStartTime = nil
stealBarForce = nil
stealBarStatus = nil
normalStealProgress = 0
normalStealPaused = false
function executeSteal(prompt, podName)
    if isStealing then return end
    if not prompt then return end
    if not Steal.Data[prompt] then
        Steal.Data[prompt] = { hold = {}, trigger = {}, ready = true }
        pcall(function()
            if getconnections then
                for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(Steal.Data[prompt].hold, c.Function) end
                end
                for _, c in ipairs(getconnections(prompt.Triggered)) do
                    if c.Function then table.insert(Steal.Data[prompt].trigger, c.Function) end
                end
            end
        end)
    end
    local data = Steal.Data[prompt]
    if not data.ready then return end
    data.ready = false
    isStealing = true
    stealStartTime = tick()
    stealBarForce = nil
    stealBarStatus = nil
    normalStealProgress = 0
    normalStealPaused = false
    pcall(function() getgenv()._AS_StealProgress = 0 end)

    if progressFill then
        progressFill.Size = UDim2.new(0, 0, 1, 0)
    end
    if progressPct then progressPct.Text = "0%" end
    if statusDot and statusDot.Parent then statusDot.BackgroundColor3 = Color3.fromRGB(255, 200, 50) end

    task.spawn(function()
        for _, f in ipairs(data.hold) do task.spawn(f) end
        pcall(function()
            if prompt.InputHoldBegin then prompt:InputHoldBegin() end
        end)

        local startTime = tick()
        local duration = tonumber(Steal.StealDuration) or 1.3
        if duration <= 0 then duration = 1.3 end
        -- Lógica Visible: carga hasta 80% o 90% (según Auto Steal Mode), pausa, espera el podio y completa
        local stopPct = autoStealVariant == 1 and 0.80 or 0.90
        local stopTime = stopPct * duration
        local delayRadius = 9
        local phase2Cap = 2.99

        local function setBar(prog)
            normalStealProgress = prog
            pcall(function() getgenv()._AS_StealProgress = prog end)
            if progressFill then progressFill.Size = UDim2.new(prog, 0, 1, 0) end
            if progressPct then progressPct.Text = math.floor(prog * 100) .. "%" end
        end

        local function promptPos()
            local ok, pos = pcall(function()
                if prompt.Parent and prompt.Parent.Parent and prompt.Parent.Parent:IsA("BasePart") then
                    return prompt.Parent.Parent.Position
                end
                return nil
            end)
            return ok and pos or nil
        end

        local function fireTriggers()
            for _, f in ipairs(data.trigger) do task.spawn(f) end
            pcall(function()
                if fireproximityprompt then fireproximityprompt(prompt) end
            end)
            pcall(function()
                if prompt.InputHoldEnd then prompt:InputHoldEnd() end
            end)
            pcall(function()
                local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                if remote and podName then remote:FireServer(podName) end
            end)
            pcall(function()
                if prompt.Fire then prompt:Fire() end
            end)
        end

        local function abortReady()
            setBar(0)
            data.ready = true
            isStealing = false
            stealStartTime = nil
            normalStealPaused = false
        end

        -- Fase 1: carga hasta stopTime
        while isStealing and Steal.AutoStealEnabled do
            local elapsed = tick() - startTime
            setBar(math.clamp(elapsed / duration, 0, 1))
            if elapsed >= stopTime then break end
            if not prompt.Parent or not prompt.Parent.Parent then break end
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local pos = promptPos()
            if hrp and pos and (hrp.Position - pos).Magnitude > (Steal.StealRadius or 60) then
                break
            end
            task.wait()
        end

        local stopProgress = stopPct
        setBar(stopProgress)
        normalStealPaused = true
        pcall(function() if prompt.InputHoldEnd then prompt:InputHoldEnd() end end)

        -- Fase 2: espera acercarte al podio
        local phase2Timeout = math.max(phase2Cap - stopTime - math.max(duration - stopTime, 0), 0.05)
        local phase2Start = tick()
        while isStealing and Steal.AutoStealEnabled do
            if tick() - phase2Start >= phase2Timeout then
                abortReady()
                task.wait()
                local np, nn = findNearestPrompt()
                if np then executeSteal(np, nn) end
                return
            end
            if not prompt.Parent or not prompt.Parent.Parent then
                abortReady()
                return
            end
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local pos = promptPos()
            if hrp and pos then
                local dist = (hrp.Position - pos).Magnitude
                if dist <= delayRadius then
                    break
                elseif dist > (Steal.StealRadius or 60) then
                    abortReady()
                    return
                end
            end
            task.wait()
        end

        -- Fase 3: completa la barra y dispara
        if isStealing and Steal.AutoStealEnabled then
            normalStealPaused = false
            local fillStart = tick()
            local fillDuration = math.max(duration - stopTime, 0.05)
            while true do
                local fp = math.clamp((tick() - fillStart) / fillDuration, 0, 1)
                setBar(stopProgress + fp * (1 - stopProgress))
                if fp >= 1 then break end
                task.wait()
            end
            fireTriggers()
        end

        setBar(0)
        data.ready = true
        isStealing = false
        stealStartTime = nil
        normalStealPaused = false
        stealBarForce = nil
        stealBarStatus = nil
        if statusDot and statusDot.Parent then statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 120) end
    end)
end

-- START / STOP AUTO STEAL
function startAutoSteal()
    if stealConnection and stealConnection.Connected then return true end
    Steal.StealRadius = CONFIG.STEAL_RANGE
    CONFIG.AUTO_STEAL_ENABLED = true
    Steal.AutoStealEnabled = true
    stealConnection = RunService.Heartbeat:Connect(function()
        if _mySession ~= _G.VisibleHubSession then
            stopAutoSteal()
            return
        end
        if not Steal.AutoStealEnabled or not CONFIG.AUTO_STEAL_ENABLED or isStealing then return end
        local p, n = findNearestPrompt()
        if p then executeSteal(p, n) end
    end)
    return true
end

function stopAutoSteal(clearPreference)
    -- Al apagar el toggle se borra la preferencia; en respawn/limpieza se conserva.
    if clearPreference == nil then clearPreference = true end
    if stealConnection then
        pcall(function() stealConnection:Disconnect() end)
        stealConnection = nil
    end
    isStealing = false
    stealStartTime = nil
    normalStealProgress = 0
    normalStealPaused = false
    stealBarForce = nil
    stealBarStatus = nil
    pcall(function() getgenv()._AS_StealProgress = 0 end)
    Steal.AutoStealEnabled = false
    if clearPreference then CONFIG.AUTO_STEAL_ENABLED = false end
    if progressFill then
        pcall(function()
            TS:Create(progressFill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play()
        end)
    end
    if progressPct then progressPct.Text = "0%" end
    pcall(function() if resetProgressBar then resetProgressBar() end end)
end

medusaStealDelayEnabled = false

medusaDebounce = false
medusaLastUsed = 0
dropActive = false
lastDropTime = 0
lastMoveDir = _V3new(0,0,0)
origFOV = nil
fovEnabled = false
fovValue = 70
customFovConn = nil

_anyKeyListening = false
_aimbotConn = nil
_prevAutoRotate = nil
tpBatConn = nil
tpBatPrevAutoRotate = nil
tpBatHitCD = false
TP_BAT_SWING_CD = 0.08

enemySpeedConn = nil
movementLoop = nil
steppedConn = nil
alConn = nil
arConn = nil
infJumpConn = nil
stretchConn = nil
stretchFovConn = nil
antiLagDescConn = nil
medusaResetConns = {}
dropConnections = {}
enemySpeedLabels = {}
Conns = {autoSteal = nil, batCounter = nil, anchor = {}, progress = nil, autoLeft = nil, autoRight = nil}
keyButtonRefs = {}
progressFill = nil
progressPct = nil
progressStatus = nil
progressTween = nil
pbFrame = nil
stealHud = {value = 0, state = "READY", statsText = "-- FPS  ·  PING: -- MS"}
speedLabel = nil
modeValLbl = nil
normalBox, carryBox, laggerBox, lagger2Box, radInput, batSpeedBox, uiScaleBox = nil, nil, nil, nil, nil, nil, nil
modeSelectBtn, dropModeBtnRef = nil, nil
autoBatSetVisual, autoLeftSetVisual, autoRightSetVisual, setBatCounterVisual, setMedusaVisual = nil, nil, nil, nil, nil
setAntiRagVisual, setUnwalkVisual, setAntiLagVisual, setLockUIVisual, setInstaGrab = nil, nil, nil, nil, nil
infJumpSetVisual = nil
infJumpModeBtn = nil
autoStealModeBtn = nil
setAntiDieVisual = nil
setAntiBatVisual = nil
setAntiFlingVisual = nil
setESPVIsual = nil
setESPLineVisual = nil
mobSetAutoBat, mobSetAutoLeft, mobSetAutoRight, mobSetDropBR, mobSetTpDown, mobSetCarry, mobSetLagger1, mobSetLagger2, mobSetBatV2 = nil, nil, nil, nil, nil, nil, nil, nil, nil
miniBtn, main, gui = nil, nil, nil
MobilePanel = nil
showGui = nil
hideGui = nil
mainUIScale = nil
pbScale = nil
tabButtons = nil
colorSelectorLabel = nil

GAMEPAD_KEYS = {
    [Enum.KeyCode.ButtonA] = true, [Enum.KeyCode.ButtonB] = true,
    [Enum.KeyCode.ButtonX] = true, [Enum.KeyCode.ButtonY] = true,
    [Enum.KeyCode.ButtonL1] = true, [Enum.KeyCode.ButtonR1] = true,
    [Enum.KeyCode.ButtonL2] = true, [Enum.KeyCode.ButtonR2] = true,
    [Enum.KeyCode.ButtonL3] = true, [Enum.KeyCode.ButtonR3] = true,
    [Enum.KeyCode.ButtonStart] = true, [Enum.KeyCode.ButtonSelect] = true,
    [Enum.KeyCode.DPadUp] = true, [Enum.KeyCode.DPadDown] = true,
    [Enum.KeyCode.DPadLeft] = true, [Enum.KeyCode.DPadRight] = true,
}

MOVE_KEYS = {
    [Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true,
    [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true,
    [Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true,
}

BAT_COUNTER_SLAP_LIST = {
    "Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap",
    "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap",
    "Nuclear Slap", "Galaxy Slap", "Glitched Slap"
}

AP = {
    L1 = _V3new(-476.48, -6.28, 92.73),
    L2 = _V3new(-483.12, -4.95, 94.80),
    L_FACE = _V3new(-482.25, -4.96, 92.09),
    R1 = _V3new(-476.16, -6.52, 25.62),
    R2 = _V3new(-483.06, -5.03, 25.48),
    R_FACE = _V3new(-482.06, -6.93, 35.47),
}

function isGamepadInput(inp)
    return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") ~= nil
end

function isBindableInput(inp)
    if not inp or inp.KeyCode == Enum.KeyCode.Unknown then return false end
    if inp.UserInputType == Enum.UserInputType.Keyboard then return true end
    return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode] == true
end

function kbMatch(entry, kc)
    return kc and (kc == entry.kb or (entry.gp and kc == entry.gp))
end

local function isSpinCarrying()
    if MVPVenixCarry and type(MVPVenixCarry.isCarrying) == "function" then
        local ok, result = pcall(function() return MVPVenixCarry:isCarrying() end)
        if ok and result == true then return true end
    end
    local char = LP.Character
    if not char then return false end
    local ok, result = pcall(function() return LP:GetAttribute("Stealing") end)
    if ok and result == true then return true end
    ok, result = pcall(function() return char:GetAttribute("Stealing") end)
    if ok and result == true then return true end
    for _, name in ipairs({"Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab"}) do
        local obj = char:FindFirstChild(name)
        if obj and ((obj:IsA("BoolValue") and obj.Value) or (obj:IsA("ObjectValue") and obj.Value) or (obj:IsA("StringValue") and obj.Value ~= "")) then
            return true
        end
    end
    return false
end

local function stopSpin()
    spinEnabled = false
    spinReady = false
    spinLostAt = 0
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then pcall(function() root.AssemblyAngularVelocity = _V3zero end) end
    if setSpinVisual then pcall(setSpinVisual, false) end
end

spinHeartbeatConn = RunService.Heartbeat:Connect(function()
    if _mySession ~= _G.VisibleHubSession then
        if spinHeartbeatConn then spinHeartbeatConn:Disconnect(); spinHeartbeatConn = nil end
        return
    end
    if not spinEnabled or not spinReady then return end
    if not isSpinCarrying() then
        if spinLostAt == 0 then spinLostAt = _tick() end
        if _tick() - spinLostAt >= 1 then stopSpin() end
        return
    end
    spinLostAt = 0
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then pcall(function() root.AssemblyAngularVelocity = _V3new(0, spinSpeed, 0) end) end
end)

function updateStealProgress(value, state)
    value = _clamp(tonumber(value) or 0, 0, 1)
    state = state or "READY"
    stealHud.value, stealHud.state = value, state
    if value >= 0.999 and state == "COMPLETE" then
        spinReady = true
        spinEnabled = true
        spinLostAt = 0
        if setSpinVisual then pcall(setSpinVisual, true) end
    end
    if progressFill then
        progressFill.Size = UDim2.new(value, 0, 1, 0)
        progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    end
    if progressPct then
        progressPct.Text = (progressPct:GetAttribute("Prefix") or "") .. _floor(value * 100 + 0.5) .. "%"
        progressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
        progressPct.Visible = true
    end
    if progressStatus then
        if state == "READY" or state == "CANCELLED" or state == "" then
            progressStatus.Text = "STEAL"
        elseif state == "APPROACH" then
            progressStatus.Text = "CLOSE"
        elseif state == "COMPLETE" then
            progressStatus.Text = "DONE"
        else
            progressStatus.Text = tostring(state)
        end
        progressStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
        progressStatus.Visible = true
    end
end

function resetProgressBar()
    updateStealProgress(0, "READY")
end

local function doTpDown()
    pcall(function()
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local _, yaw = root.CFrame:ToEulerAnglesYXZ()
        root.CFrame = _CFnew(root.Position.X, -7, root.Position.Z) * CFrame.Angles(0, yaw, 0)
        root.AssemblyLinearVelocity = _V3zero
        root.AssemblyAngularVelocity = _V3zero
    end)
end

_G._VynxRunTPDown = doTpDown
_G._VynxTPDownIsAutoOn = function() return false end

function stopAutoTPDown()
    if _autoTPDownThread then
        pcall(task.cancel, _autoTPDownThread)
        _autoTPDownThread = nil
    end
end

function startAutoTPDown()
    stopAutoTPDown()
    _autoTPDownThread = task.spawn(function()
        while autoTPDownEnabled do
            task.wait(0.1)
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.FloorMaterial == Enum.Material.Air and hrp.Position.Y >= autoTPDownHeight then
                doTpDown()
            end
        end
    end)
end

local AntiRagdollV1 = {}
AntiRagdollV1.__index = AntiRagdollV1

local BOOST_SPEED = 400
local AR_DEFAULT_SPEED = 16

local stateV1 = {
    active = false,
    isBoosting = false,
    cachedChar = nil,
    ragdollConnections = {},
}

local function disconnectAllV1()
    for _, conn in ipairs(stateV1.ragdollConnections) do
        pcall(function() conn:Disconnect() end)
    end
    stateV1.ragdollConnections = {}
end

local function cacheCharacterV1()
    local char = LP.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return false end
    stateV1.cachedChar = { character = char, humanoid = hum, root = root }
    return true
end

local function isRagdolledV1()
    if not stateV1.cachedChar or not stateV1.cachedChar.humanoid then return false end
    local hum = stateV1.cachedChar.humanoid
    local st = hum:GetState()
    local ragdollStates = {
        [Enum.HumanoidStateType.Physics] = true,
        [Enum.HumanoidStateType.Ragdoll] = true,
        [Enum.HumanoidStateType.FallingDown] = true,
    }
    return ragdollStates[st] or false
end

local function forceExitRagdollV1()
    if not stateV1.cachedChar or not stateV1.cachedChar.humanoid or not stateV1.cachedChar.root then return end
    local hum = stateV1.cachedChar.humanoid
    local root = stateV1.cachedChar.root
    pcall(function()
        LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
    end)
    for _, descendant in ipairs(stateV1.cachedChar.character:GetDescendants()) do
        if descendant:IsA("BallSocketConstraint") or
           (descendant:IsA("Attachment") and descendant.Name:find("RagdollAttachment")) then
            descendant:Destroy()
        end
    end
    if not stateV1.isBoosting then
        stateV1.isBoosting = true
        hum.WalkSpeed = BOOST_SPEED
    end
    if hum.Health > 0 then
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end
    root.Anchored = false
end

local function heartbeatLoopV1()
    while stateV1.active do
        task.wait()
        if isRagdolledV1() then
            forceExitRagdollV1()
        elseif stateV1.isBoosting and not isRagdolledV1() then
            stateV1.isBoosting = false
            if stateV1.cachedChar and stateV1.cachedChar.humanoid then
                stateV1.cachedChar.humanoid.WalkSpeed = AR_DEFAULT_SPEED
            end
        end
    end
end

function AntiRagdollV1.start()
    if stateV1.active then return end
    AntiRagdollV1.stop()
    if not cacheCharacterV1() then
        warn("[AntiRagdollV1] No se pudo cachear el personaje")
        return
    end
    stateV1.active = true
    stateV1.isBoosting = false
    local camConn = RunService.RenderStepped:Connect(function()
        local cam = workspace.CurrentCamera
        if cam and stateV1.cachedChar and stateV1.cachedChar.humanoid then
            cam.CameraSubject = stateV1.cachedChar.humanoid
        end
    end)
    table.insert(stateV1.ragdollConnections, camConn)
    local respawnConn = LP.CharacterAdded:Connect(function()
        stateV1.isBoosting = false
        task.wait(0.5)
        cacheCharacterV1()
    end)
    table.insert(stateV1.ragdollConnections, respawnConn)
    task.spawn(heartbeatLoopV1)
    print("[AntiRagdollV1] Activado")
end

function AntiRagdollV1.stop()
    stateV1.active = false
    if stateV1.isBoosting and stateV1.cachedChar and stateV1.cachedChar.humanoid then
        stateV1.cachedChar.humanoid.WalkSpeed = AR_DEFAULT_SPEED
    end
    stateV1.isBoosting = false
    disconnectAllV1()
    stateV1.cachedChar = nil
    print("[AntiRagdollV1] Desactivado")
end

function AntiRagdollV1.isRunning() return stateV1.active end

local AntiRagdollV2 = {
    Enabled = false,
    Connection = nil,
    ResetCooldown = 0,
}

local function startAntiRagdollV2()
    if AntiRagdollV2.Connection then return end
    AntiRagdollV2.Enabled = true
    AntiRagdollV2.Connection = RunService.Heartbeat:Connect(function()
        if not AntiRagdollV2.Enabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end
        if hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return end
        local state = hum:GetState()
        local now = _tick()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown then
            if now - AntiRagdollV2.ResetCooldown > 0.15 then
                AntiRagdollV2.ResetCooldown = now
                pcall(function()
                    if hum:GetState() == Enum.HumanoidStateType.GettingUp then return end
                    if hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return end
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
    if AntiRagdollV1.isRunning() then AntiRagdollV1.stop() end
    if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
    antiRagdollMode = mode
    if mode == "v1" then AntiRagdollV1.start()
    elseif mode == "v2" then startAntiRagdollV2() end
    if _G.updateAntiRagdollUI then _G.updateAntiRagdollUI(mode) end
    saveAllSettings()
end

_antiDieEnabled = false
_antiDieStopped = false
_antiDieSources = { toggle = false, autobat = false }

_antiDie = {
    enabled = false, loop = nil, healthConn = nil, charConn = nil,
    lastHealTime = 0, invincibleUntil = 0,
    config = {
        healthThreshold = 50,
        invincibilityFrames = 0.75,
        fallDamageProtection = false,
        ragdollProtection = true,
        autoRevive = true,
    },
}

function _antiDie.SuperHeal(hum)
    if not hum or not hum.Parent then return end
    local maxHealth = hum.MaxHealth or 100
    if maxHealth <= 0 or maxHealth == math.huge then maxHealth = 100 end
    pcall(function()
        hum.Health = maxHealth
        if hum.MaxHealth < maxHealth then hum.MaxHealth = maxHealth end
    end)
    _antiDie.invincibleUntil = _tick() + _antiDie.config.invincibilityFrames
    _antiDie.lastHealTime = _tick()
    pcall(function()
        local char = hum.Parent
        if not char then return end
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("NumberValue") then
                local name = child.Name:lower()
                if name:find("health") or name:find("hp") or name:find("life") then
                    child.Value = maxHealth
                end
            end
            if child:IsA("BoolValue") and child.Name:lower():find("dead") then
                child.Value = false
            end
        end
    end)
end

function _antiDie.PreventDamage(root, hum)
    if not hum then return end
    if hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
    if _tick() < _antiDie.invincibleUntil then
        if hum.Health < (hum.MaxHealth or 100) then
            hum.Health = hum.MaxHealth or 100
        end
    end
    if _antiDie.config.ragdollProtection then
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown or
           state == Enum.HumanoidStateType.Dead then
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
            _antiDie.SuperHeal(hum)
            if root then
                pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
            end
        end
    end
    if hum.Health <= 0 then
        _antiDie.SuperHeal(hum)
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
        if root then
            pcall(function()
                root.CFrame = CFrame.new(root.Position + Vector3.new(0, 2, 0))
                root.AssemblyLinearVelocity = Vector3.zero
            end)
        end
    end
end

function _antiDie.AutoRevive()
    if not _antiDie.config.autoRevive then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum then return end
    if hum.Health <= 0 then
        _antiDie.SuperHeal(hum)
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
        if root then
            pcall(function()
                root.CFrame = CFrame.new(root.Position + Vector3.new(0, 3, 0))
                root.AssemblyLinearVelocity = Vector3.zero
            end)
        end
    end
end

function _antiDie.AttachHealth(char)
    if _antiDie.healthConn then _antiDie.healthConn:Disconnect(); _antiDie.healthConn = nil end
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then hum = char and char:WaitForChild("Humanoid", 3) end
    if not hum then return end
    _antiDie.healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not _antiDie.enabled then return end
        if hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
        if hum.Health <= 0 then _antiDie.AutoRevive() end
    end)
    if hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
end

function _antiDie.StartEngine()
    if _antiDie.enabled and _antiDie.loop then return end
    _antiDie.enabled = true
    _antiDieEnabled = true
    antiDieEnabled = true
    if _antiDie.loop then _antiDie.loop:Disconnect(); _antiDie.loop = nil end
    if _antiDie.healthConn then _antiDie.healthConn:Disconnect(); _antiDie.healthConn = nil end
    _antiDie.loop = RunService.Heartbeat:Connect(function()
        if not _antiDie.enabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum then return end
        if hum.Health <= 0 then _antiDie.AutoRevive()
        elseif hum.Health <= _antiDie.config.healthThreshold then _antiDie.SuperHeal(hum)
        elseif hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
        _antiDie.PreventDamage(root, hum)
    end)
    if LP.Character then _antiDie.AttachHealth(LP.Character) end
    if _antiDie.charConn then _antiDie.charConn:Disconnect(); _antiDie.charConn = nil end
    _antiDie.charConn = LP.CharacterAdded:Connect(function(char)
        if not _antiDie.enabled then return end
        task.wait(0.05)
        _antiDie.AttachHealth(char)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then _antiDie.SuperHeal(hum) end
    end)
end

function _antiDie.StopEngine()
    _antiDie.enabled = false
    _antiDieEnabled = false
    antiDieEnabled = false
    if _antiDie.loop then _antiDie.loop:Disconnect(); _antiDie.loop = nil end
    if _antiDie.healthConn then _antiDie.healthConn:Disconnect(); _antiDie.healthConn = nil end
    if _antiDie.charConn then _antiDie.charConn:Disconnect(); _antiDie.charConn = nil end
    pcall(function()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        hum.BreakJointsOnDeath = true
        if hum.MaxHealth == math.huge or hum.MaxHealth <= 0 then
            hum.MaxHealth = 100
            hum.Health = math.min(hum.Health, 100)
        end
    end)
end

function _antiDieSetEnabled(enabled)
    enabled = enabled == true
    if enabled == _antiDieEnabled then return end
    if enabled then
        _antiDie.StartEngine()
    else
        _antiDie.StopEngine()
    end
end

function _antiDieRefresh()
    if _antiDieStopped then return end
    local manual = _antiDieSources.toggle
    _antiDieSetEnabled(manual or _antiDieSources.autobat)
end

_G.__CrystalAntiDieSource = function(source, enabled)
    if _antiDieStopped or _antiDieSources[source] == nil then return end
    _antiDieSources[source] = enabled == true
    _antiDieRefresh()
end

_G.__CrystalAntiDieSet = function(enabled)
    _G.__CrystalAntiDieSource("autobat", enabled)
end

_G.__CrystalAntiDieIsEnabled = function() return _antiDieEnabled end
_G.__CrystalAntiDieStop = function()
    _antiDieStopped = true
    _antiDieSources.toggle = false
    _antiDieSources.autobat = false
    _antiDieSetEnabled(false)
end

function activateOnCharacter(char)
    if not _antiDieEnabled then return end
    _antiDie.AttachHealth(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then _antiDie.SuperHeal(hum) end
end

AntiDieModule = {
    enabled = false,
    start = function()
        AntiDieModule.enabled = true
        antiDieEnabled = true
        _antiDieStopped = false
        _G.__CrystalAntiDieSource("toggle", true)
    end,
    stop = function()
        AntiDieModule.enabled = false
        antiDieEnabled = false
        _G.__CrystalAntiDieSource("toggle", false)
    end,
}
_G.AntiDie = AntiDieModule

-- ============================================================
-- ANTI BAT (dipindahkan persis dari Blaxing: spike velocity 10000-20000 melingkar tiap frame,
-- lalu X/Z dikembalikan; kalau aimbot mengirim kecepatan yang diinginkan, itu yang dipakai)
-- ============================================================
do
    local AntiBatConn = nil
    local Speed     = 10000
    local Angle     = 0
    local Direction = 1   -- 1 aumenta, -1 diminuisce

    local function _abStop()
        if AntiBatConn then
            pcall(function() AntiBatConn:Disconnect() end)
            AntiBatConn = nil
        end
        Speed     = 10000
        Angle     = 0
        Direction = 1
        _G._AmbitiousAntiBatDesiredXZ = nil
        _G._AmbitiousAntiBatSpiking = false
    end

    local function _abStart()
        _abStop()
        AntiBatConn = RunService.Heartbeat:Connect(function()
            if _mySession ~= _G.VisibleHubSession then
                if AntiBatConn then pcall(function() AntiBatConn:Disconnect() end); AntiBatConn = nil end
                return
            end
            if not _G.AmbitiousAntiBatEnabled then return end
            local char = LP.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root or not root.Parent then return end

            -- Salva la velocita' originale X e Z
            local origXZ = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)

            -- Speed oscillante tra 10000 e 20000
            Speed = Speed + (50 * Direction)
            if Speed >= 20000 then
                Speed = 20000
                Direction = -1
            elseif Speed <= 10000 then
                Speed = 10000
                Direction = 1
            end

            -- Angolo caotico + raggio variabile
            Angle = Angle + (math.random() * 0.5)
            local radius = Speed + math.random(-5000, 5000)
            local newX = math.cos(Angle) * radius
            local newZ = math.sin(Angle) * radius

            _G._AmbitiousAntiBatSpiking = true
            root.Velocity = Vector3.new(newX, root.Velocity.Y, newZ)

            RunService.RenderStepped:Wait()

            -- Ripristina X e Z: se c'e' una velocita' desiderata (aimbot) si riscrive quella,
            -- altrimenti l'originale.
            if root.Parent then
                local cur = root.Velocity
                local curFlat = Vector3.new(cur.X, 0, cur.Z).Magnitude
                if autoBatEnabled == true and curFlat < 300 then
                    -- Bat Aimbot activo (V1/V2/V3) y ya escribio una velocidad valida en este frame:
                    -- no se pisa con una velocidad vieja, solo se restaura si seguia el spike.
                else
                    local want = _G._AmbitiousAntiBatDesiredXZ
                    if want then
                        root.Velocity = Vector3.new(want.X, root.Velocity.Y, want.Z)
                    else
                        root.Velocity = Vector3.new(origXZ.X, root.Velocity.Y, origXZ.Z)
                    end
                end
            end
            _G._AmbitiousAntiBatSpiking = false
        end)
    end

    _G.AmbitiousAntiBatEnabled = false

    -- Velocidad "limpia" para los Bat Aimbot V2/V3: mientras el Anti Bat esta haciendo el spike,
    -- la velocidad real del HRP es enorme; los aimbots que parten de la velocidad actual (Lerp)
    -- usan esta en vez de la del spike, igual que el V1 que escribe velocidades absolutas.
    _G.__VisibleCleanVel = function(root)
        local v = root.AssemblyLinearVelocity
        if _G._AmbitiousAntiBatSpiking then
            local w = _G._AmbitiousAntiBatDesiredXZ
            return Vector3.new(w and w.X or 0, v.Y, w and w.Z or 0)
        end
        return v
    end
    -- El aimbot publica la velocidad X/Z que acaba de escribir para que el Anti Bat la restaure.
    _G.__VisiblePublishAntiBatVel = function(root)
        if not _G.AmbitiousAntiBatEnabled then return end
        local v = root.AssemblyLinearVelocity
        local flat = Vector3.new(v.X, 0, v.Z)
        if flat.Magnitude < 300 then _G._AmbitiousAntiBatDesiredXZ = flat end
    end

    function stopAntiBat()
        antiBatEnabled = false
        _G.AmbitiousAntiBatEnabled = false
        pcall(_abStop)
    end

    function startAntiBat()
        antiBatEnabled = true
        _G.AmbitiousAntiBatEnabled = true
        pcall(_abStart)
    end

    -- Watchdog permanente: se il flag e' acceso ma il loop non c'e' (errore, respawn,
    -- disconnessione imprevista) lo riavvia da solo.
    task.spawn(function()
        while _mySession == _G.VisibleHubSession do
            task.wait(0.5)
            if _G.AmbitiousAntiBatEnabled then
                if not AntiBatConn then
                    pcall(_abStart)
                end
            elseif AntiBatConn then
                pcall(_abStop)
            end
        end
    end)

    -- Respawn: il vecchio HRP e' morto, si riparte pulito
    LP.CharacterAdded:Connect(function(char)
        task.wait(0.3)
        if _mySession ~= _G.VisibleHubSession then return end
        if _G.AmbitiousAntiBatEnabled then
            pcall(_abStart)
        else
            pcall(_abStop)
        end
    end)
end

setAntiFlingVisual = nil

local _antiFlingState = {
    connection    = nil,
    threshold     = 80,
    spinThreshold = 40,
}
local _ANTI_FLING_DRIVE_GRACE = 0.3

local function _afHubSpeedLive()
    local live = _G.__VisibleHubLiveSpeed
    if type(live) ~= "table" then return false end
    local stamp, speed = tonumber(live.t), tonumber(live.v)
    if not stamp or not speed or speed <= 0 then return false end
    return (os.clock() - stamp) <= _ANTI_FLING_DRIVE_GRACE
end

local function _afOwnMoverActive()
    if autoBatEnabled then return true end
    if autoLeftEnabled or autoRightEnabled then return true end
    if ((_G.__VisibleAimbotIsOn and _G.__VisibleAimbotIsOn()) or (_G.__VisibleLagIsOn and _G.__VisibleLagIsOn())) then return true end
    return false
end

function startAntiFling()
    if _antiFlingState.connection then return end
    antiFlingEnabled = true
    _antiFlingState.connection = RunService.Heartbeat:Connect(function()
        if not antiFlingEnabled then return end
        local character = LP.Character
        if not character then return end
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and (humanoid.Health <= 0 or humanoid.SeatPart) then return end

        if dropActive or _G.IsDropping then return end
        if _afOwnMoverActive() then return end
        if _afHubSpeedLive() then return end

        local velocity = root.AssemblyLinearVelocity
        local flat = Vector3.new(velocity.X, 0, velocity.Z)

        if flat.Magnitude > _antiFlingState.threshold then
            pcall(function()
                root.AssemblyLinearVelocity = Vector3.new(0, velocity.Y, 0)
                root.AssemblyAngularVelocity = Vector3.zero
            end)
            return
        end
        if root.AssemblyAngularVelocity.Magnitude > _antiFlingState.spinThreshold then
            pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
        end
    end)
end

function stopAntiFling()
    antiFlingEnabled = false
    if _antiFlingState.connection then
        _antiFlingState.connection:Disconnect()
        _antiFlingState.connection = nil
    end
end

LP.CharacterAdded:Connect(function()
    task.wait(0.3)
    if antiFlingEnabled then startAntiFling() end
end)

local espEnabled = espEnabled or false
local espActivePlayers = {}
local espLoopConn = nil
local Camera = workspace.CurrentCamera
local GUI2_ESP_COLOR = Color3.fromRGB(139, 72, 246)
local GUI2_ESP_TEXT_STROKE = Color3.fromRGB(48, 16, 92)

local function getESPThemeColors(accent)
    local c = getThemeColor() or accent or Color3.fromRGB(245, 245, 250)
    return c, Color3.fromRGB(0, 0, 0)
end

local function createESP()
    local currentFill, currentLine = getESPThemeColors()
    local esp = {
        Tracer = Drawing and Drawing.new("Line") or nil,
        Highlight = Instance.new("Highlight"),
        Lines = {},
    }
    if esp.Tracer then
        esp.Tracer.Color = currentLine
        esp.Tracer.Thickness = 3
        esp.Tracer.Transparency = 1
        esp.Tracer.ZIndex = 2
    end

    esp.Highlight.Name = "VisibleHubESP_Highlight"
    esp.Highlight.FillColor = currentFill
    esp.Highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
    esp.Highlight.FillTransparency = 0.12
    esp.Highlight.OutlineTransparency = 0.18
    esp.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    local parentGui
    local ok, robGui = pcall(function() return game:GetService("CoreGui"):FindFirstChild("RobloxGui") end)
    if ok and robGui then parentGui = robGui else parentGui = LP:FindFirstChildOfClass("PlayerGui") end
    if not parentGui then parentGui = game:GetService("CoreGui") end
    pcall(function() esp.Highlight.Parent = parentGui end)

    local nameBillboard = Instance.new("BillboardGui")
    nameBillboard.Name = "VisibleHubESP_Name"
    nameBillboard.Size = UDim2.new(0, 170, 0, 28)
    nameBillboard.StudsOffset = Vector3.new(0, 1.3, 0)
    nameBillboard.AlwaysOnTop = true
    nameBillboard.Parent = parentGui

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0, 170, 0, 28)
    nameLabel.AnchorPoint = Vector2.new(0.5, 0)
    nameLabel.Position = UDim2.new(0.5, 0, 0, 2)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = ""
    nameLabel.TextColor3 = getThemeColor()
    nameLabel.TextSize = 15
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.TextYAlignment = Enum.TextYAlignment.Center
    nameLabel.ZIndex = 5
    nameLabel.Parent = nameBillboard

    local nameOutline = Instance.new("UIStroke")
    nameOutline.Color = Color3.fromRGB(0, 0, 0)
    nameOutline.Thickness = 2.2
    nameOutline.Transparency = 0.12
    nameOutline.Parent = nameLabel

    if Drawing then
        for i = 1, 14 do
            local line = Drawing.new("Line")
            line.Color = currentLine
            line.Thickness = 2
            line.Transparency = 1
            line.ZIndex = 3
            table.insert(esp.Lines, line)
        end
    end

    esp.NameTag = nameBillboard
    esp.NameLabel = nameLabel
    esp.NameOutline = nameOutline
    return esp
end

_G.__VisibleHubRefreshESPTheme = function(accent, outlineColor)
    local fillColor, lineColor = getESPThemeColors(accent)
    for _, data in pairs(espActivePlayers) do
        if type(data) == "table" and data.esp then
            local esp = data.esp
            if esp.Tracer then pcall(function() esp.Tracer.Color = lineColor end) end
            if esp.Highlight then
                esp.Highlight.FillColor = fillColor
                esp.Highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
            end
            if esp.NameLabel then
                esp.NameLabel.TextColor3 = getThemeColor()
                esp.NameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            end
            if esp.NameOutline then esp.NameOutline.Color = Color3.fromRGB(0, 0, 0) end
            for _, line in ipairs(esp.Lines or {}) do pcall(function() line.Color = lineColor end) end
        end
    end
end

local function removeESP(plr)
    local data = espActivePlayers[plr]
    if data then
        if data.esp.Tracer then pcall(function() data.esp.Tracer:Remove() end) end
        if data.esp.Highlight then pcall(function() data.esp.Highlight:Destroy() end) end
        if data.esp.NameTag then pcall(function() data.esp.NameTag:Destroy() end) end
        for _, line in ipairs(data.esp.Lines) do
            pcall(function() line:Remove() end)
        end
        espActivePlayers[plr] = nil
    end
end

local function updateESP(plr, esp)
    if not espEnabled then
        if esp.Tracer then esp.Tracer.Visible = false end
        esp.Highlight.Enabled = false
        for _, line in ipairs(esp.Lines) do line.Visible = false end
        if esp.NameTag then esp.NameTag.Enabled = false end
        return
    end

    local character = plr.Character
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    local trackPart = character and (
        character:FindFirstChild("HumanoidRootPart")
        or character.PrimaryPart
        or character:FindFirstChild("UpperTorso")
        or character:FindFirstChild("Torso")
        or character:FindFirstChild("Head")
    )

    if character and trackPart and (not hum or hum.Health > 0) then
        esp.Highlight.Adornee = character
        esp.Highlight.Enabled = espEnabled
        if esp.Tracer then esp.Tracer.Visible = false end
        for _, line in ipairs(esp.Lines) do line.Visible = false end

        if esp.NameTag and esp.NameLabel then
            pcall(function()
                esp.NameTag.Adornee = trackPart
                esp.NameTag.Enabled = espEnabled
                esp.NameLabel.Text = plr.Name or plr.DisplayName or ""
                esp.NameLabel.TextColor3 = getThemeColor()
            end)
        end
    else
        if esp.Tracer then esp.Tracer.Visible = false end
        esp.Highlight.Enabled = false
        esp.Highlight.Adornee = nil
        for _, line in ipairs(esp.Lines) do line.Visible = false end
        if esp.NameTag then esp.NameTag.Enabled = false end
    end
end

local function createESPForPlayer(plr)
    if plr == LP then return end
    if espActivePlayers[plr] and espActivePlayers[plr].esp then
        if espActivePlayers[plr].esp.NameTag then
            pcall(function() espActivePlayers[plr].esp.NameTag.Enabled = espEnabled end)
        end
        return
    end
    removeESP(plr)
    local esp = createESP()
    espActivePlayers[plr] = { esp = esp }
end

local espJoinConn, espLeaveConn
local function enableESP()
    if espEnabled then return end
    espEnabled = true
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP then task.spawn(function() createESPForPlayer(plr) end) end
    end
    local espAccumulator = 0
    if espLoopConn then espLoopConn:Disconnect() end
    espLoopConn = RunService.Heartbeat:Connect(function(dt)
        espAccumulator = espAccumulator + (dt or 0)
        if espAccumulator < 0.15 then return end
        espAccumulator = 0
        for plr, data in pairs(espActivePlayers) do
            if typeof(plr) == "Instance" and plr:IsA("Player") and data and data.esp then
                pcall(function() updateESP(plr, data.esp) end)
            end
        end
    end)
    espJoinConn = Players.PlayerAdded:Connect(function(plr)
        if not espEnabled or plr == LP then return end
        task.wait(0.3)
        createESPForPlayer(plr)
    end)
    espLeaveConn = Players.PlayerRemoving:Connect(function(plr) removeESP(plr) end)
end

local function disableESP()
    espEnabled = false
    if espLoopConn then espLoopConn:Disconnect(); espLoopConn = nil end
    if espJoinConn then pcall(function() espJoinConn:Disconnect() end); espJoinConn = nil end
    if espLeaveConn then pcall(function() espLeaveConn:Disconnect() end); espLeaveConn = nil end
    for plr in pairs(espActivePlayers) do
        if typeof(plr) == "Instance" and plr:IsA("Player") and plr ~= LP then removeESP(plr) end
    end
end

function toggleESP(on)
    if on then enableESP() else disableESP() end
    if setESPVIsual then setESPVIsual(on) end
end

local _espLineGui = nil
local _espLineFrame = nil
local _espLineOutline = nil
local _espLineConn = nil
local _espLineState = { scanElapsed = math.huge, targetRoot = nil }

local function ensureESPLineGui()
    if _espLineGui and _espLineGui.Parent then return end
    _espLineGui = Instance.new("ScreenGui")
    _espLineGui.Name = "VisibleHubESPLine"
    _espLineGui.IgnoreGuiInset = true
    _espLineGui.ResetOnSpawn = false
    _espLineGui.DisplayOrder = 1000
    _espLineGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local okP = pcall(function() _espLineGui.Parent = game:GetService("CoreGui") end)
    if not okP then _espLineGui.Parent = LP:WaitForChild("PlayerGui") end

    _espLineFrame = Instance.new("Frame")
    _espLineFrame.Name = "ESPLine"
    _espLineFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    _espLineFrame.BorderSizePixel = 0
    _espLineFrame.Active = false
    _espLineFrame.Visible = false
    _espLineFrame.BackgroundColor3 = getThemeColor()
    _espLineFrame.ZIndex = 1
    _espLineFrame.Parent = _espLineGui

    _espLineOutline = Instance.new("UIStroke", _espLineFrame)
    _espLineOutline.Color = Color3.fromRGB(255, 255, 255)
    _espLineOutline.Thickness = 0.7
    _espLineOutline.Transparency = 0.45
end

function stopESPLine()
    espLineEnabled = false
    if _espLineConn then _espLineConn:Disconnect(); _espLineConn = nil end
    if _espLineFrame then _espLineFrame.Visible = false end
    _espLineState.targetRoot = nil
    _espLineState.scanElapsed = math.huge
    if _espLineGui and _espLineGui.Parent then
        pcall(function() _espLineGui:Destroy() end)
    end
    _espLineGui = nil
    _espLineFrame = nil
    _espLineOutline = nil
end

function startESPLine()
    espLineEnabled = true
    ensureESPLineGui()
    if _espLineConn then _espLineConn:Disconnect() end
    _espLineState.scanElapsed = math.huge
    _espLineState.targetRoot = nil

    _espLineConn = RunService.RenderStepped:Connect(function(dt)
        if not espLineEnabled then
            if _espLineFrame then _espLineFrame.Visible = false end
            return
        end
        local ok = pcall(function()
            local activeCamera = workspace.CurrentCamera
            local myChar = LP.Character
            local myRoot = myChar and (myChar:FindFirstChild("LowerTorso") or myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
            if not activeCamera or not myRoot then
                if _espLineFrame then _espLineFrame.Visible = false end
                return
            end

            local myPosition = myRoot.Position
            _espLineState.scanElapsed = _espLineState.scanElapsed + (dt or 0)
            local cachedRoot = _espLineState.targetRoot
            local cachedCharacter = cachedRoot and cachedRoot.Parent
            local cachedHumanoid = cachedCharacter and cachedCharacter:FindFirstChildOfClass("Humanoid")
            local cachedValid = cachedRoot and cachedRoot.Parent and (not cachedHumanoid or cachedHumanoid.Health > 0)
            if _espLineState.scanElapsed >= 0.12 or not cachedValid then
                _espLineState.scanElapsed = 0
                local closestRoot, closestDistanceSq = nil, math.huge
                for _, otherPlayer in ipairs(Players:GetPlayers()) do
                    if otherPlayer ~= LP then
                        local character = otherPlayer.Character
                        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                        local root = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("LowerTorso") or character:FindFirstChild("Torso"))
                        if root and root:IsA("BasePart") and (not humanoid or humanoid.Health > 0) then
                            local delta = root.Position - myPosition
                            local distanceSq = delta:Dot(delta)
                            if distanceSq < closestDistanceSq then
                                closestRoot, closestDistanceSq = root, distanceSq
                            end
                        end
                    end
                end
                _espLineState.targetRoot = closestRoot
            end

            local closestRoot = _espLineState.targetRoot
            if not closestRoot or not closestRoot.Parent then
                if _espLineFrame then _espLineFrame.Visible = false end
                return
            end
            local closestPosition = closestRoot.Position

            local from = activeCamera:WorldToViewportPoint(myPosition - Vector3.new(0, myRoot.Size.Y * 0.35, 0))
            local to, targetOnScreen = activeCamera:WorldToViewportPoint(closestPosition)
            local viewport = activeCamera.ViewportSize
            local fromPoint = Vector2.new(from.X, from.Y)
            local targetPoint = Vector2.new(to.X, to.Y)

            if not targetOnScreen or to.Z <= 0 then
                local center = viewport * 0.5
                local direction = targetPoint - center
                if to.Z <= 0 then direction = -direction end
                if direction.Magnitude < 0.001 then direction = Vector2.new(0, -1) end
                local limit = Vector2.new(math.max(8, center.X - 8), math.max(8, center.Y - 8))
                local scaleX = limit.X / math.max(math.abs(direction.X), 0.001)
                local scaleY = limit.Y / math.max(math.abs(direction.Y), 0.001)
                targetPoint = center + direction * math.min(scaleX, scaleY)
            end

            if from.Z <= 0 or fromPoint.X < 0 or fromPoint.X > viewport.X or fromPoint.Y < 0 or fromPoint.Y > viewport.Y then
                fromPoint = Vector2.new(viewport.X * 0.5, viewport.Y - 8)
            end

            local delta = targetPoint - fromPoint
            local midpoint = (fromPoint + targetPoint) * 0.5
            _espLineFrame.Position = UDim2.fromOffset(midpoint.X, midpoint.Y)
            _espLineFrame.Size = UDim2.fromOffset(math.max(delta.Magnitude, 1), 2)
            _espLineFrame.Rotation = math.deg(math.atan2(delta.Y, delta.X))
            _espLineFrame.BackgroundColor3 = getThemeColor()
            _espLineFrame.Visible = true
        end)
        if not ok and _espLineFrame then
            pcall(function() _espLineFrame.Visible = false end)
        end
    end)
end

local _enemySpeedAcc = 0
function updateEnemySpeedLabels()
    _enemySpeedAcc = _enemySpeedAcc + 1
    if _enemySpeedAcc < 6 then return end
    _enemySpeedAcc = 0
    local color = getThemeColor()
    local players = _GetPlayersCached()
    for i = 1, #players do
        local player = players[i]
        if player ~= LP then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local v = hrp.AssemblyLinearVelocity
                local speed = _sqrt(v.X*v.X + v.Z*v.Z)
                local label = enemySpeedLabels[player]
                if not label then
                    local head = char:FindFirstChild("Head")
                    if head then
                        local bb = Instance.new("BillboardGui")
                        bb.Size = UDim2.new(0, 100, 0, 25)
                        bb.StudsOffset = _V3new(0, 5.5, 0)
                        bb.AlwaysOnTop = true
                        bb.Name = "EnemySpeedGui"
                        bb.Parent = head
                        local tl = Instance.new("TextLabel", bb)
                        tl.Size = UDim2.new(1, 0, 1, 0)
                        tl.BackgroundTransparency = 1
                        tl.TextColor3 = Color3.fromRGB(255, 255, 255)
                        tl.Font = Enum.Font.GothamBold
                        tl.TextScaled = true
                        tl.TextStrokeTransparency = 0
                        tl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        enemySpeedLabels[player] = tl
                        label = tl
                    end
                elseif label.Parent and label.Parent.Parent ~= char then
                    local head = char:FindFirstChild("Head")
                    if head then label.Parent.Parent = head end
                end
                if label then
                    label.Text = string.format("%.1f", speed)
                    if label.TextColor3 ~= Color3.fromRGB(255, 255, 255) then label.TextColor3 = Color3.fromRGB(255, 255, 255) end
                end
            else
                local label = enemySpeedLabels[player]
                if label and label.Parent and label.Parent.Parent then label.Parent.Parent = nil end
                enemySpeedLabels[player] = nil
            end
        end
    end
end

function startEnemySpeed()
    if enemySpeedConn then enemySpeedConn:Disconnect() end
    enemySpeedConn = RunService.Heartbeat:Connect(updateEnemySpeedLabels)
end

function stopEnemySpeed()
    if enemySpeedConn then enemySpeedConn:Disconnect(); enemySpeedConn = nil end
end

local function getClosestTargetBody()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local rpos = root.Position
    local closest, minDist = nil, _huge
    local plist = _GetPlayersCached()
    for i = 1, #plist do
        local plr = plist[i]
        if plr ~= LP then
            local c = plr.Character
            if c then
                local tRoot = c:FindFirstChild("HumanoidRootPart")
                if tRoot then
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local dx = tRoot.Position.X - rpos.X
                        local dy = tRoot.Position.Y - rpos.Y
                        local dz = tRoot.Position.Z - rpos.Z
                        local d = dx*dx + dy*dy + dz*dz
                        if d < minDist then minDist = d; closest = tRoot end
                    end
                end
            end
        end
    end
    return closest
end

local function _bodyLockTick()
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local target = getClosestTargetBody()
    if not target then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    local dist = (target.Position - root.Position).Magnitude
    if dist > bodyLockRange then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    if hum.AutoRotate then hum.AutoRotate = false end
    local targetVel = target.AssemblyLinearVelocity
    local speed3 = targetVel.Magnitude
    local predictTime = _clamp(speed3 / 80, 0.08, 0.35)
    local predictedPos = target.Position + targetVel * predictTime
    local targetHead = target.Parent and target.Parent:FindFirstChild("Head")
    local targetHeight = targetHead and targetHead.Position.Y or target.Position.Y
    local myHeight = root.Position.Y + (hum.HipHeight or 0)
    local heightDiff = targetHeight - myHeight
    local verticalCorrection = _clamp(heightDiff * 0.15, -1.5, 1.5)
    local flatTarget = _V3new(predictedPos.X, root.Position.Y + verticalCorrection, predictedPos.Z)
    local toPredict = flatTarget - root.Position
    if toPredict.Magnitude > 0.1 then
        local goalCF = _CFlookAt(root.Position, flatTarget)
        local diffCF = root.CFrame:Inverse() * goalCF
        local _, ry, _ = diffCF:ToEulerAnglesXYZ()
        ry = _clamp(ry, -2.5, 2.5)
        root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(_V3new(0, ry * 42, 0))
    end
end

function startBodyLock()
    if _bodyLockConn then _bodyLockConn:Disconnect() end
    local acc = 0
    _bodyLockConn = RunService.Heartbeat:Connect(function(dt)
        if not bodyLockEnabled then return end
        if _blSuppressCount > 0 then return end
        acc = acc + dt
        if acc < 0.033 then return end
        acc = 0
        _bodyLockTick()
    end)
end

function stopBodyLock()
    if _bodyLockConn then
        _bodyLockConn:Disconnect()
        _bodyLockConn = nil
    end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyAngularVelocity = _V3zero
        root.AssemblyLinearVelocity = _V3new(root.AssemblyLinearVelocity.X, -0.1, root.AssemblyLinearVelocity.Z)
    end
    local hum2 = c and c:FindFirstChildOfClass("Humanoid")
    if hum2 then hum2.AutoRotate = true end
end

function _suppressBodyLock()
    _blSuppressCount = _blSuppressCount + 1
    if _blSuppressCount == 1 and bodyLockEnabled then
        _blWasEnabled = true
        stopBodyLock()
        if bodyLockSetVisual then bodyLockSetVisual(false) end
        if _blRestoreTimer then
            task.cancel(_blRestoreTimer)
            _blRestoreTimer = nil
        end
        _blSmoothRestore = false
    end
end

function _unsuppressBodyLock(delayed)
    if _blSuppressCount > 0 then
        _blSuppressCount = _blSuppressCount - 1
    end
    if _blSuppressCount == 0 and _blWasEnabled then
        _blWasEnabled = false
        if _blRestoreTimer then
            pcall(task.cancel, _blRestoreTimer)
            _blRestoreTimer = nil
        end
        local function restore()
            _blRestoreTimer = nil
            if bodyLockEnabled then
                _blSmoothRestore = true
                startBodyLock()
                if bodyLockSetVisual then bodyLockSetVisual(true) end
                task.delay(0.5, function() _blSmoothRestore = false end)
            end
        end
        if delayed then
            _blRestoreTimer = task.delay(1, restore)
        else
            restore()
        end
    end
end

function setupSpeedIndicator(char)
    -- indicador sobre el personaje: "discord.gg/visiblehub" arriba y "VELOCIDAD - MODO" abajo.
    -- Estilo grueso con contorno oscuro, relleno PLATEADO con brillo que recorre el texto.
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    local root = char:FindFirstChild("HumanoidRootPart") or head
    for _, holder in ipairs({head, root}) do
        for _, name in ipairs({"VisibleSpeedBB", "VisibleHubSpeedIndicator", "VisibleSpeedBB"}) do
            local old = holder:FindFirstChild(name)
            if old then old:Destroy() end
        end
    end
    speedLabel = nil
    local bb = Instance.new("BillboardGui")
    bb.Name = "VisibleSpeedBB"
    bb.Size = UDim2.new(0, 150, 0, 46)
    bb.StudsOffset = Vector3.new(0, 3.9, 0)
    bb.Adornee = root
    bb.AlwaysOnTop = true
    bb.MaxDistance = 90
    bb.ResetOnSpawn = false
    bb.LightInfluence = 0
    -- Siempre visible (ya no depende del Auto Steal)
    bb.Enabled = true
    bb.Parent = root

    local gradients = {}
    local function styleText(lbl)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255) -- el color real lo da el UIGradient
        lbl.Font = Enum.Font.FredokaOne                 -- letra gordita tipo la imagen
        lbl.TextScaled = true
        lbl.TextStrokeTransparency = 1
        lbl.TextXAlignment = Enum.TextXAlignment.Center
        -- contorno grueso gris acero oscuro (equivalente al azul oscuro de la imagen)
        local st = Instance.new("UIStroke")
        st.Color = Color3.fromRGB(38, 42, 52)
        st.Thickness = 2.2
        st.Transparency = 0
        st.LineJoinMode = Enum.LineJoinMode.Round
        st.Parent = lbl
        -- plateado con franja de brillo que se desplaza
        local grad = Instance.new("UIGradient")
        grad.Rotation = 20
        grad.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
        grad.Offset = Vector2.new(-1, 0)
        grad.Parent = lbl
        table.insert(gradients, grad)
    end

    local discord = Instance.new("TextLabel")
    discord.Name = "VisibleDiscord"
    discord.Size = UDim2.new(1, 0, 0.42, 0)
    discord.Position = UDim2.new(0, 0, 0, 0)
    discord.Text = "discord.gg/visiblehub"
    styleText(discord)
    discord.Parent = bb

    local val = Instance.new("TextLabel")
    val.Name = "VisibleSpeedValue"
    val.Size = UDim2.new(1, 0, 0.56, 0)
    val.Position = UDim2.new(0, 0, 0.44, 0)
    val.Text = "0.0 - NORMAL"
    styleText(val)
    val.Parent = bb

    speedLabel = val
    MVPUI.speedValueLabel = val

    if _G.__VisibleSpeedConn then pcall(function() _G.__VisibleSpeedConn:Disconnect() end) end
    _G.__VisibleSpeedConn = RunService.RenderStepped:Connect(function()
        if _mySession ~= _G.VisibleHubSession then
            if _G.__VisibleSpeedConn then pcall(function() _G.__VisibleSpeedConn:Disconnect() end); _G.__VisibleSpeedConn = nil end
            return
        end
        -- si el indicador se perdio (respawn, limpieza de otro modulo), se vuelve a poner
        if not bb.Parent or not bb:IsDescendantOf(game) then
            local curChar = LP.Character
            local curRoot = curChar and curChar:FindFirstChild("HumanoidRootPart")
            if curRoot then
                bb.Adornee = curRoot
                bb.Parent = curRoot
            end
        end
        -- siempre visible, con o sin Auto Steal
        local showSpeed = true
        if bb.Enabled ~= showSpeed then bb.Enabled = showSpeed end
        if not (speedLabel and speedLabel.Parent) then return end
        if not showSpeed then return end

        -- brillo plateado: barrido de izquierda a derecha, con pausa entre pasadas
        local t = (os.clock() % 2.4) / 2.4
        local off = -1 + math.clamp(t / 0.7, 0, 1) * 2
        for _, g in ipairs(gradients) do
            if g.Parent then g.Offset = Vector2.new(off, 0) end
        end

        local okS, active = pcall(getActiveMoveSpeed)
        local shown = (okS and tonumber(active)) or 0
        local okM, modeName = pcall(getSpeedModeName)
        if not okM or type(modeName) ~= "string" then modeName = "NORMAL" end
        local txt = string.format("%.1f - %s", shown, modeName)
        if speedLabel.Text ~= txt then speedLabel.Text = txt end
    end)
end

local unwalkSavedAnimate = nil

function startUnwalk()
    local c = LP.Character
    if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() t:Stop() end) end
    end
    local anim = c:FindFirstChild("Animate")
    if anim then
        unwalkSavedAnimate = anim:Clone()
        anim:Destroy()
    end
end

function stopUnwalk()
    local c = LP.Character
    if c then
        local existing = c:FindFirstChild("Animate")
        if not existing then
            local src = game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterCharacterScripts")
            local starterAnim = src and src:FindFirstChild("Animate")
            if starterAnim then
                starterAnim:Clone().Parent = c
            elseif unwalkSavedAnimate then
                unwalkSavedAnimate:Clone().Parent = c
            end
        end
    end
    unwalkSavedAnimate = nil
end

function refreshSpeedModeLabel()
    if modeValLbl then
        if laggerCarryToggled then modeValLbl.Text = "Lagger Carry"
        elseif laggerToggled then modeValLbl.Text = "Lagger Normal"
        elseif speedMode then modeValLbl.Text = "Carry"
        else modeValLbl.Text = "Normal" end
    end
    if setCarryModeVisual then setCarryModeVisual(speedMode) end
    if setLaggerModeVisual then setLaggerModeVisual(laggerToggled) end
    if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled) end
end

function resetMovementState()
    refreshSpeedModeLabel()
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled) end
    if mobSetLagger2 then mobSetLagger2(laggerCarryToggled) end
    if setLaggerModeVisual then setLaggerModeVisual(laggerToggled) end
    if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled) end
end

function toggleCarryMode()
    if laggerToggled or laggerCarryToggled then
        laggerToggled = false; laggerCarryToggled = false; speedMode = true
    else speedMode = not speedMode end
    resetMovementState()
    if _G.__VisibleHubApplySpeedNow then pcall(_G.__VisibleHubApplySpeedNow) end
end

function toggleLaggerMode()
    if laggerCarryToggled then laggerCarryToggled = false end
    speedMode = false; laggerToggled = not laggerToggled
    resetMovementState()
    if _G.__VisibleHubApplySpeedNow then pcall(_G.__VisibleHubApplySpeedNow) end
end
function toggleLaggerCarryMode()
    if laggerToggled then laggerToggled = false end
    speedMode = false; laggerCarryToggled = not laggerCarryToggled
    resetMovementState()
    if _G.__VisibleHubApplySpeedNow then pcall(_G.__VisibleHubApplySpeedNow) end
end

function toggleLaggerCycle()
    if speedMode then
        speedMode = false
        laggerToggled = true
        laggerCarryToggled = false
    elseif laggerToggled then
        speedMode = false
        laggerToggled = false
        laggerCarryToggled = true
    else
        speedMode = true
        laggerToggled = false
        laggerCarryToggled = false
    end
    resetMovementState()
    if _G.__VisibleHubApplySpeedNow then pcall(_G.__VisibleHubApplySpeedNow) end
end

function stopAutoLeft()
    if alConn then alConn:Disconnect(); alConn = nil end
    alPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(_V3zero, false) end
    end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobSetAutoLeft then mobSetAutoLeft(false) end
    _unsuppressBodyLock(true)
end

function startAutoLeft()
    if autoRightEnabled then
        autoRightEnabled = false
        PERSISTED_TOGGLES["Auto Right"] = false
        stopAutoRight()
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobSetAutoRight then mobSetAutoRight(false) end
    end
    disableAllAimbots()
    _suppressBodyLock()
    if alConn then alConn:Disconnect() end
    alPhase = 1
    alConn = RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd = NS
        if alPhase == 1 then
            local tgt = _V3new(AP.L1.X, root.Position.Y, AP.L1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                alPhase = 2
                local d = AP.L2 - root.Position
                local mv = _V3new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.L1 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif alPhase == 2 then
            local tgt = _V3new(AP.L2.X, root.Position.Y, AP.L2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(_V3zero, false)
                root.AssemblyLinearVelocity = _V3zero
                autoLeftEnabled = false
                if alConn then alConn:Disconnect(); alConn = nil end
                alPhase = 1
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if mobSetAutoLeft then mobSetAutoLeft(false) end
                _unsuppressBodyLock(true)
                local facePos = _V3new(AP.L_FACE.X, root.Position.Y, AP.L_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = _CFnew(root.Position, facePos)
                end
                return
            end
            local d = AP.L2 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end

function stopAutoRight()
    if arConn then arConn:Disconnect(); arConn = nil end
    arPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(_V3zero, false) end
    end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobSetAutoRight then mobSetAutoRight(false) end
    _unsuppressBodyLock(true)
end

function startAutoRight()
    if autoLeftEnabled then
        autoLeftEnabled = false
        PERSISTED_TOGGLES["Auto Left"] = false
        stopAutoLeft()
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobSetAutoLeft then mobSetAutoLeft(false) end
    end
    disableAllAimbots()
    _suppressBodyLock()
    if arConn then arConn:Disconnect() end
    arPhase = 1
    arConn = RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd = NS
        if arPhase == 1 then
            local tgt = _V3new(AP.R1.X, root.Position.Y, AP.R1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                arPhase = 2
                local d = AP.R2 - root.Position
                local mv = _V3new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.R1 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif arPhase == 2 then
            local tgt = _V3new(AP.R2.X, root.Position.Y, AP.R2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(_V3zero, false)
                root.AssemblyLinearVelocity = _V3zero
                autoRightEnabled = false
                if arConn then arConn:Disconnect(); arConn = nil end
                arPhase = 1
                if autoRightSetVisual then autoRightSetVisual(false) end
                if mobSetAutoRight then mobSetAutoRight(false) end
                _unsuppressBodyLock(true)
                local facePos = _V3new(AP.R_FACE.X, root.Position.Y, AP.R_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = _CFnew(root.Position, facePos)
                end
                return
            end
            local d = AP.R2 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end

function getClosestTarget()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local rpos = root.Position
    local closest, minDist = nil, _huge
    local plist = _GetPlayersCached()
    for i = 1, #plist do
        local plr = plist[i]
        if plr ~= LP then
            local c = plr.Character
            if c then
                local tRoot = c:FindFirstChild("HumanoidRootPart")
                if tRoot then
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local dx = tRoot.Position.X - rpos.X
                        local dy = tRoot.Position.Y - rpos.Y
                        local dz = tRoot.Position.Z - rpos.Z
                        local d = dx*dx + dy*dy + dz*dz
                        if d < minDist then minDist = d; closest = tRoot end
                    end
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

do
    -- ===== AIMBOT BYPAS V2 (dipindahkan dari visible: Bat Bypass, kejar dengan prediksi ping) =====
    local BB = {on = false, conn = nil, speed = 60, laggerSpeed = 40, lastPingAt = 0}
    _G.__VisibleBB = BB
    BB.C = {
        ACTIVATE_DISTANCE = 13, MIN_FOLLOW_DISTANCE = 1, PREDICTION_TIME = 0.22, PREDICT_AHEAD = 3,
        MAX_VELOCITY_CHANGE = 150, VELOCITY_SMOOTHING = 0.2, MAX_HORIZONTAL_VELOCITY = 80,
        SERVER_TICKRATE = 1 / 60, MIN_PING = 0.03, MAX_PING = 0.25, ACCEL_WEIGHT = 0.3,
        DIR_CHANGE_TIME = 0.12, QUICK_TURN_MULT = 1.5, GRAVITY = 196.2, AIR_CONTROL = 0.8, MIN_AIRBORNE = 0.08,
    }
    BB.Z = {
        targetPlayer = nil, lastTargetPos = nil, targetVelocity = Vector3.zero, smoothedVelocity = Vector3.zero,
        velocityHistory = {}, accelerationHistory = {}, aerialVelocityHistory = {},
        previousDirection = nil, lastDirectionChangeTime = 0, airborneTime = 0,
        lastActivationTime = 0, currentPing = 0.1, realPingMs = 0,
    }
    function BB.average(history)
        if #history == 0 then return Vector3.zero end
        local total = Vector3.zero
        for _, v in ipairs(history) do total = total + v end
        return total / #history
    end
    function BB.push(history, value, maximum)
        table.insert(history, value)
        if #history > maximum then table.remove(history, 1) end
    end
    function BB.findBat()
        local char = LP.Character
        if not char then return nil end
        local equipped = char:FindFirstChildOfClass("Tool")
        if equipped then
            local n = equipped.Name:lower()
            if n:find("bat", 1, true) or n:find("slap", 1, true) then return equipped end
        end
        local bp = LP:FindFirstChildOfClass("Backpack")
        if bp then
            for _, tool in ipairs(bp:GetChildren()) do
                if tool:IsA("Tool") then
                    local n = tool.Name:lower()
                    if n:find("bat", 1, true) or n:find("slap", 1, true) then return tool end
                end
            end
        end
        return nil
    end
    function BB.reset()
        BB.Z.targetPlayer, BB.Z.lastTargetPos = nil, nil
        BB.Z.targetVelocity, BB.Z.smoothedVelocity = Vector3.zero, Vector3.zero
        BB.Z.velocityHistory, BB.Z.accelerationHistory, BB.Z.aerialVelocityHistory = {}, {}, {}
        BB.Z.previousDirection, BB.Z.airborneTime = nil, 0
    end
    function BB.nearest(root)
        local nearest, nearestDistance = nil, math.huge
        for _, candidate in ipairs(Players:GetPlayers()) do
            if candidate ~= LP and candidate.Character then
                local tRoot = candidate.Character:FindFirstChild("HumanoidRootPart")
                local tHum = candidate.Character:FindFirstChildOfClass("Humanoid")
                if tRoot and tHum and tHum.Health > 0 then
                    local d = (root.Position - tRoot.Position).Magnitude
                    if d < nearestDistance then nearest, nearestDistance = candidate, d end
                end
            end
        end
        return nearest
    end
    function BB.rotate(root, direction)
        if direction.Magnitude < 0.01 then return end
        local axis = root.CFrame.LookVector:Cross(direction.Unit)
        local angle = math.asin(math.clamp(axis.Magnitude, -1, 1))
        root.AssemblyAngularVelocity = axis.Magnitude > 0.01 and axis.Unit * angle * 80 or Vector3.zero
    end
    function BB.samplePing()
        local ok, value = pcall(function()
            return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        if ok and type(value) == "number" then BB.Z.realPingMs = math.floor(value) end
        BB.Z.currentPing = math.clamp(BB.Z.realPingMs / 1000, BB.C.MIN_PING, BB.C.MAX_PING)
    end

    function BB.Stop()
        if not BB.on and not BB.conn then return end
        BB.on = false
        if BB.conn then pcall(function() BB.conn:Disconnect() end); BB.conn = nil end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if hum then hum.AutoRotate = true end
        if root then root.AssemblyAngularVelocity = Vector3.zero end
        BB.reset()
        BB.Z.lastActivationTime = 0
    end

    function BB.Start()
        if BB.conn then return end
        local char = LP.Character
        local hum0 = char and char:FindFirstChildOfClass("Humanoid")
        local root0 = char and char:FindFirstChild("HumanoidRootPart")
        if not hum0 or not root0 then return end
        BB.on = true
        hum0.AutoRotate = false
        local bat0 = BB.findBat()
        if bat0 and bat0.Parent ~= char then pcall(function() hum0:EquipTool(bat0) end) end
        BB.reset()
        BB.conn = RunService.RenderStepped:Connect(function(dt)
            if _mySession ~= _G.VisibleHubSession then BB.Stop(); return end
            if not BB.on then return end
            if tick() - BB.lastPingAt > 0.5 then BB.lastPingAt = tick(); pcall(BB.samplePing) end
            local curChar = LP.Character
            local root = curChar and curChar:FindFirstChild("HumanoidRootPart")
            local hum = curChar and curChar:FindFirstChildOfClass("Humanoid")
            if not root or not hum or hum.Health <= 0 then return end
            hum.AutoRotate = false
            local bat = curChar:FindFirstChildOfClass("Tool") or BB.findBat()
            if bat and bat.Parent ~= curChar then pcall(function() hum:EquipTool(bat) end) end

            BB.Z.targetPlayer = BB.nearest(root)
            local targetChar = BB.Z.targetPlayer and BB.Z.targetPlayer.Character
            local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
            local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
            if not targetRoot or not targetHum or targetHum.Health <= 0 then BB.reset(); return end

            local targetPos = targetRoot.Position
            local safeDt = math.max(dt, 1 / 240)
            if BB.Z.lastTargetPos then
                local rawVel = (targetPos - BB.Z.lastTargetPos) / safeDt
                local velDelta = rawVel - BB.Z.targetVelocity
                if velDelta.Magnitude > BB.C.MAX_VELOCITY_CHANGE then
                    rawVel = BB.Z.targetVelocity + velDelta.Unit * BB.C.MAX_VELOCITY_CHANGE
                end
                local horizontal = Vector3.new(rawVel.X, 0, rawVel.Z)
                if horizontal.Magnitude > BB.C.MAX_HORIZONTAL_VELOCITY then
                    horizontal = horizontal.Unit * BB.C.MAX_HORIZONTAL_VELOCITY
                    rawVel = Vector3.new(horizontal.X, rawVel.Y, horizontal.Z)
                end
                BB.push(BB.Z.accelerationHistory, (rawVel - BB.Z.targetVelocity) / safeDt, 4)
                BB.push(BB.Z.velocityHistory, rawVel, 8)
                BB.Z.targetVelocity = rawVel
                BB.Z.smoothedVelocity = BB.Z.smoothedVelocity:Lerp(rawVel, BB.C.VELOCITY_SMOOTHING)
            end
            BB.Z.lastTargetPos = targetPos

            local airborne = targetHum.FloorMaterial == Enum.Material.Air
            BB.Z.airborneTime = airborne and (BB.Z.airborneTime + safeDt) or 0
            if airborne and BB.Z.airborneTime >= BB.C.MIN_AIRBORNE then
                BB.push(BB.Z.aerialVelocityHistory, BB.Z.targetVelocity, 6)
            elseif not airborne then
                BB.Z.aerialVelocityHistory = {}
            end

            local predVel = BB.Z.smoothedVelocity
            if airborne and #BB.Z.aerialVelocityHistory > 0 then
                local aerial = BB.average(BB.Z.aerialVelocityHistory)
                predVel = Vector3.new(aerial.X, BB.Z.targetVelocity.Y, aerial.Z) * BB.C.AIR_CONTROL
            end

            local quickTurn = false
            local hVel = Vector3.new(BB.Z.targetVelocity.X, 0, BB.Z.targetVelocity.Z)
            if hVel.Magnitude > 5 then
                local dir = hVel.Unit
                if BB.Z.previousDirection and BB.Z.previousDirection:Dot(dir) < 0.5 then
                    quickTurn = tick() - BB.Z.lastDirectionChangeTime < BB.C.DIR_CHANGE_TIME
                    BB.Z.lastDirectionChangeTime = tick()
                end
                BB.Z.previousDirection = dir
            end

            local serverDelay = BB.Z.currentPing + BB.C.SERVER_TICKRATE
            if quickTurn then serverDelay = serverDelay * BB.C.QUICK_TURN_MULT end
            local predicted = targetPos + predVel * serverDelay
            local accel = BB.average(BB.Z.accelerationHistory)
            predicted = predicted + accel * BB.C.ACCEL_WEIGHT * (serverDelay * serverDelay * 0.5)
            local predTime = BB.C.PREDICTION_TIME * 1.1
            if airborne then
                predicted = predicted + predVel * predTime
                predicted = predicted + Vector3.new(0, -0.5 * BB.C.GRAVITY * predTime * predTime, 0)
            else
                predicted = predicted + predVel * predTime
            end
            local flatPred = Vector3.new(predVel.X, 0, predVel.Z)
            if flatPred.Magnitude > 1 then predicted = predicted + flatPred.Unit * BB.C.PREDICT_AHEAD end

            local toTarget = predicted - root.Position
            BB.rotate(root, toTarget)

            if (targetPos - root.Position).Magnitude <= BB.C.ACTIVATE_DISTANCE and tick() - BB.Z.lastActivationTime >= 0 then
                if bat then pcall(function() bat:Activate() end) end
                BB.Z.lastActivationTime = tick()
            end

            -- la velocidad no baja al activar Carry/Lagger
            local speed = BB.speed
            if toTarget.Magnitude > BB.C.MIN_FOLLOW_DISTANCE then
                root.AssemblyLinearVelocity = wallSafeVelocity(root, toTarget.Unit * speed)
            else
                root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y * 0.5, 0)
            end
        end)
    end

    -- ===== satu toggle/tombol Bat Bypass: V1 = Aimbot Bypas V1, V2 = Bat Bypas V2 (versi dipilih lewat batBypassVersion) =====
    local function _lagIsOn() return (_G.__VisibleLagIsOn and _G.__VisibleLagIsOn()) and true or false end
    local function _autoBatEngineOn() return (_G.__VisibleAimbotIsOn and _G.__VisibleAimbotIsOn()) and true or false end

    -- Anti Bat no debe afectar al Bat Aimbot: se publica la velocidad X/Z deseada cada frame
    -- (el Anti Bat la restaura después del spike en vez de pisar la del aimbot).
    _G.__VisibleBatAimbotAntiBat = function(on)
        pcall(function() RunService:UnbindFromRenderStep("VisibleBatAimbotAntiBat") end)
        _G._AmbitiousAntiBatDesiredXZ = nil
        if not on then return end
        pcall(function()
            RunService:BindToRenderStep("VisibleBatAimbotAntiBat", Enum.RenderPriority.Last.Value, function()
                if _mySession ~= _G.VisibleHubSession or not autoBatEnabled then
                    pcall(function() RunService:UnbindFromRenderStep("VisibleBatAimbotAntiBat") end)
                    _G._AmbitiousAntiBatDesiredXZ = nil
                    return
                end
                local c = LP.Character
                local r = c and c:FindFirstChild("HumanoidRootPart")
                if not r then _G._AmbitiousAntiBatDesiredXZ = nil; return end
                local v = r.AssemblyLinearVelocity
                local flat = Vector3.new(v.X, 0, v.Z)
                -- si se ve un spike del Anti Bat (valores enormes) no se toma como velocidad deseada
                _G._AmbitiousAntiBatDesiredXZ = (flat.Magnitude < 300) and flat or nil
            end)
        end)
    end

    startAimbotAdapt = function()
        if _lagIsOn() or BB.on or _autoBatEngineOn() then return end
        State.bypassBatEnabled = true
        if batBypassVersion == 3 or batBypassVersion == 2 then
            -- V2 = Auto Bat V1 (aimbotVersion 1) / V3 = Auto Bat V2 (aimbotVersion 2).
            -- El motor Auto Bat apaga el Bat Bypass al arrancar, así que se baja la bandera mientras arranca.
            aimbotVersion = (batBypassVersion == 2) and 1 or 2
            local wasEnabled = autoBatEnabled
            autoBatEnabled = false
            local okAB = _G.__VisibleAV2Start and _G.__VisibleAV2Start()
            autoBatEnabled = wasEnabled
            if not okAB then State.bypassBatEnabled = false end
        else
            _suppressBodyLock()
            BB.Start()
            if not BB.on then _unsuppressBodyLock(true) end
        end
        pcall(_G.__VisibleBatAimbotAntiBat, true)
    end
    stopAimbotAdapt = function()
        local bbWasOn = BB.on
        State.bypassBatEnabled = false
        pcall(_G.__VisibleBatAimbotAntiBat, false)
        BB.Stop()
        if _G.__VisibleLagStop then pcall(_G.__VisibleLagStop) end
        if _autoBatEngineOn() and _G.__VisibleAV2Stop then pcall(_G.__VisibleAV2Stop) end
        if bbWasOn then _unsuppressBodyLock(true) end
    end
    _G.__VisibleBatVersionName = function(v)
        if v == 3 then return "V3" end
        if v == 2 then return "V2" end
        return "V1"
    end
    _G.__VisibleBatVersionRefresh = function()
        local v = (batBypassVersion == 3 and 3) or (batBypassVersion == 2 and 2) or 1
        if _G.__VisibleBatVersionLabel then pcall(function() _G.__VisibleBatVersionLabel.Text = _G.__VisibleBatVersionName(v) end) end
        if _G.__VisibleBatMobLabel then pcall(function()
            _G.__VisibleBatMobLabel.Text = "BAT\nAIMBOT"
            local g = _G.__VisibleBatMobLabel.Parent and _G.__VisibleBatMobLabel.Parent:FindFirstChild("Glyph")
            if g then g.Text = "V" .. tostring(v) end
        end) end
    end
    _G.__VisibleBatVersionSet = function(v)
        v = tonumber(v)
        v = (v == 3 and 3) or (v == 2 and 2) or 1
        if v == batBypassVersion then _G.__VisibleBatVersionRefresh(); return end
        local wasOn = _lagIsOn() or BB.on or _autoBatEngineOn()
        if wasOn then stopAimbotAdapt() end
        batBypassVersion = v
        if wasOn then startAimbotAdapt() end
        _G.__VisibleBatVersionRefresh()
        if saveAllSettings then pcall(saveAllSettings) end
    end
    _G.__VisibleBatVersionCycle = function()
        _G.__VisibleBatVersionSet(batBypassVersion % 3 + 1)
    end
    _G.__VisibleBBSetSpeed = function(normal, lagger)
        if normal then BB.speed = normal end
        if lagger then BB.laggerSpeed = lagger end
    end
    _G.__VisibleBBRefreshUI = function()
        if _G.__VisibleBBSpeedBox then pcall(function() _G.__VisibleBBSpeedBox.Text = tostring(BB.speed) end) end
        if _G.__VisibleBBLaggerBox then pcall(function() _G.__VisibleBBLaggerBox.Text = tostring(BB.laggerSpeed) end) end
    end
    do
        local pendBB = _G.__VisibleBBPending
        if type(pendBB) == "table" then
            if tonumber(pendBB.speed) and pendBB.speed > 0 then BB.speed = pendBB.speed end
            if tonumber(pendBB.lagger) and pendBB.lagger > 0 then BB.laggerSpeed = pendBB.lagger end
        end
        _G.__VisibleBBRefreshUI()
        _G.__VisibleBatVersionRefresh()
    end
    disableAutoBat = function()
        autoBatEnabled = false
        stopAimbotAdapt()
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
        if saveAllSettings then pcall(saveAllSettings) end
    end
    enableAutoBat = function()
        if _G.__VisibleLagStop then pcall(_G.__VisibleLagStop) end
        if _G.__VisibleHubIsBatV2 and _G.__VisibleHubIsBatV2() then
            _G.__VisibleHubStopBatV2()
            if mobSetBatV2 then mobSetBatV2(false) end
        end
        if autoLeftEnabled then autoLeftEnabled = false; PERSISTED_TOGGLES["Auto Left"] = false; stopAutoLeft() end
        if autoRightEnabled then autoRightEnabled = false; PERSISTED_TOGGLES["Auto Right"] = false; stopAutoRight() end
        autoBatEnabled = true
        startAimbotAdapt()
        if autoBatSetVisual then autoBatSetVisual(true) end
        if mobSetAutoBat then mobSetAutoBat(true) end
        if saveAllSettings then pcall(saveAllSettings) end
    end
end

-- ===== INSTANT RESET (del otro hub): V1 = HipHeight enorme, V2 = fling vertical =====
_G.__VisibleInstantResetVersion = _G.__VisibleInstantResetVersion == "V2" and "V2" or "V1"
_G.__VisibleInstantResetBusy = false
do
    local RS = game:GetService("RunService")
    local Plr = game:GetService("Players").LocalPlayer
    local camConn, camSaved = nil, nil
    local gaveUp = false

    local function lockCam()
        local cam = workspace.CurrentCamera
        if not cam then return end
        if camConn then pcall(function() camConn:Disconnect() end); camConn = nil end
        camSaved = {cframe = cam.CFrame, type = cam.CameraType, subject = cam.CameraSubject}
        cam.CameraType = Enum.CameraType.Scriptable
        camConn = RS.RenderStepped:Connect(function()
            local cur = workspace.CurrentCamera
            if not cur or not camSaved then return end
            if cur.CameraType ~= Enum.CameraType.Scriptable then cur.CameraType = Enum.CameraType.Scriptable end
            cur.CFrame = camSaved.cframe
        end)
    end
    local function unlockCam()
        if camConn then pcall(function() camConn:Disconnect() end); camConn = nil end
        local saved = camSaved
        camSaved = nil
        if not saved then return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        pcall(function()
            local char = Plr.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            cam.CameraType = (saved.type == Enum.CameraType.Scriptable) and Enum.CameraType.Custom or saved.type
            cam.CameraSubject = hum or saved.subject
        end)
    end

    local function resetV1()
        gaveUp = false
        local character = Plr.Character
        if not character then gaveUp = true; return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then gaveUp = true; return end
        local originalHip = humanoid.HipHeight
        local attempts, done = 0, false
        while character and character.Parent and humanoid and humanoid.Health > 0 and Plr.Character == character and attempts < 40 do
            pcall(function()
                humanoid.HipHeight = 1e30
                humanoid.AutoRotate = true
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end)
            if not character.Parent or humanoid.Health <= 0 or Plr.Character ~= character then done = true; break end
            attempts = attempts + 1
            task.wait(0.05)
        end
        if not done and character and character.Parent and humanoid and humanoid.Health > 0 then
            pcall(function() humanoid.Health = 0 end)
            task.wait(0.1)
            if not character.Parent or humanoid.Health <= 0 then done = true end
        end
        if not done then
            gaveUp = true
            if character and character.Parent and humanoid then
                pcall(function()
                    humanoid.HipHeight = originalHip
                    for _, part in ipairs(character:GetChildren()) do
                        if part:IsA("BasePart") then part.CanCollide = true end
                    end
                end)
            end
        end
    end

    local function resetV2()
        gaveUp = false
        local character = Plr.Character
        if not character then gaveUp = true; return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root then gaveUp = true; return end
        local savedPlatform, savedBreak = humanoid.PlatformStand, humanoid.BreakJointsOnDeath
        local BURST, WINDOW, FLING = 500, 0.3, 1e9
        local function applyFling(hum, r)
            hum.BreakJointsOnDeath = true
            hum.PlatformStand = true
            hum:ChangeState(Enum.HumanoidStateType.Physics)
            r.AssemblyAngularVelocity = Vector3.zero
            r.AssemblyLinearVelocity = Vector3.new(0, FLING, 0)
        end
        local function attempt()
            local ch = Plr.Character
            if ch ~= character or not character.Parent then return false end
            local hum = ch:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then return false end
            local r = ch:FindFirstChild("HumanoidRootPart")
            if r then pcall(applyFling, hum, r) end
            return true
        end
        local t0 = os.clock()
        for _ = 1, BURST do if not attempt() then return end end
        while os.clock() - t0 < WINDOW do
            RS.Heartbeat:Wait()
            if not attempt() then return end
        end
        if not character.Parent or Plr.Character ~= character or humanoid.Health <= 0 then return end
        gaveUp = true
        pcall(function()
            humanoid.PlatformStand = savedPlatform
            humanoid.BreakJointsOnDeath = savedBreak
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            root.AssemblyLinearVelocity = Vector3.zero
        end)
    end

    function _G.__VisibleRunInstantReset()
        if _G.__VisibleInstantResetBusy then return end
        _G.__VisibleInstantResetBusy = true
        gaveUp = false
        local oldCharacter = Plr.Character
        lockCam()
        task.spawn(function()
            local ok, err = pcall(function()
                if _G.__VisibleInstantResetVersion == "V2" then resetV2() else resetV1() end
            end)
            if not ok then warn("[Visible Instant Reset] " .. tostring(err)); gaveUp = true end
        end)
        task.spawn(function()
            local deadline = os.clock() + 25
            while os.clock() < deadline do
                if gaveUp then break end
                local ch = Plr.Character
                if ch and ch.Parent and ch ~= oldCharacter then
                    local hum = ch:FindFirstChildOfClass("Humanoid")
                    local root = ch:FindFirstChild("HumanoidRootPart")
                    if hum and root and hum.Health > 0 then break end
                end
                task.wait(0.05)
            end
            unlockCam()
            _G.__VisibleInstantResetBusy = false
        end)
    end
end

function findBat()
    local char = LP.Character
    if not char then return nil end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t = char:FindFirstChild(name)
        if t and t:IsA("Tool") then return t end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
            local t = bp:FindFirstChild(name)
            if t and t:IsA("Tool") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(t) end) end
                return t
            end
        end
    end
    for _, ch in ipairs(char:GetChildren()) do
        if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then
            return ch
        end
    end
    return nil
end

function isBatTool(tool)
    if not tool then return false end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        if tool.Name == name then return true end
    end
    return tool.Name:lower():find("bat") or tool.Name:lower():find("slap")
end

function findBatForCounter()
    local char = LP.Character
    if not char then return nil end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local tool = char:FindFirstChild(name) or (backpack and backpack:FindFirstChild(name))
        if tool then return tool end
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
            return child
        end
    end
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
                return child
            end
        end
    end
    return nil
end

function swingBatForCounter(bat, character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if bat.Parent ~= character and humanoid then
        pcall(function() humanoid:EquipTool(bat) end)
        task.wait(0.05)
    end
    local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end)
        task.wait(0.1)
        pcall(function() remote:FireServer() end)
    else
        pcall(function() bat:Activate() end)
        task.wait(0.1)
        pcall(function() bat:Activate() end)
    end
end

batCounterDebounce = false

function stopBatCounter()
    if Conns.batCounter then
        Conns.batCounter:Disconnect()
        Conns.batCounter = nil
    end
    batCounterDebounce = false
end

function startBatCounter()
    if Conns.batCounter then return end
    Conns.batCounter = RunService.Heartbeat:Connect(function()
        if not batCounterEnabled then return end
        if batCounterDebounce then return end
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
            batCounterDebounce = true
            _suppressBodyLock()
            task.spawn(function()
                task.wait(0.15)
                local bat = findBatForCounter()
                if bat then swingBatForCounter(bat, character) end
                task.wait(0.3)
                batCounterDebounce = false
                _unsuppressBodyLock(true)
            end)
        end
    end)
end

-- ===== Medusa Counter (diambil dari VISIBLE SHIFT LOCK) =====
function findMedusa()
    local c = LP.Character
    if c then
        for _, t in ipairs(c:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                if n:find("medusa") ~= nil or n:find("head") ~= nil or n:find("stone") ~= nil then return t end
            end
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                if n:find("medusa") ~= nil or n:find("head") ~= nil or n:find("stone") ~= nil then return t end
            end
        end
    end
    return nil
end

function useMedusaCounter()
    if medusaDebounce then return end
    if MEDUSA_COOLDOWN > (_tick() - medusaLastUsed) then return end
    local c = LP.Character
    if not c then return end
    medusaDebounce = true
    local med = findMedusa()
    if not med then
        medusaDebounce = false
        return
    end
    if med.Parent ~= c then
        local hum2 = c:FindFirstChildOfClass("Humanoid")
        if hum2 then hum2:EquipTool(med) end
    end
    pcall(function() med:Activate() end)
    medusaLastUsed = _tick()
    medusaDebounce = false
end

function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if part.Anchored and part.Transparency == 1 then
            if medusaCounterEnabled then useMedusaCounter() end
            task.delay(0.2, function()
                if type(unlockMovement) == "function" then
                    pcall(unlockMovement, LP.Character)
                end
            end)
        end
    end)
end

function stopMedusaCounter()
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
end

function setupMedusaCounter(char)
    stopMedusaCounter()
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(Conns.anchor, onAnchorChanged(part))
        end
    end
    table.insert(Conns.anchor, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            table.insert(Conns.anchor, onAnchorChanged(part))
        end
    end))
end

local DROP_ASCEND_DURATION = 0.2
local DROP_ASCEND_SPEED = 150
local _dropConn = nil

function stopDropBrainrot()
    dropActive = false
    if _dropConn then
        _dropConn:Disconnect()
        _dropConn = nil
    end
    for _, t in ipairs(dropConnections) do
        if type(t) == "thread" then pcall(task.cancel, t)
        elseif type(t) == "RBXScriptConnection" then pcall(t.Disconnect, t) end
    end
    dropConnections = {}
    local c = LP.Character
    if c then
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then root.AssemblyLinearVelocity = _V3zero end
    end
    if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
    if mobSetDropBR then mobSetDropBR(false) end
end

function runDropBrainrot()
    if dropActive then return end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    if dropMode == 1 then
        local speedH = 0
        if root then
            local vel = root.AssemblyLinearVelocity
            speedH = _V3new(vel.X, 0, vel.Z).Magnitude
        end
        local cooldown = (speedH > 5) and 0.6 or 0.25
        if _tick() - lastDropTime < cooldown then return end
        lastDropTime = _tick()
        dropActive = true
        if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
        if mobSetDropBR then mobSetDropBR(true) end
        local wasAutoBat = false
        if autoBatEnabled then
            wasAutoBat = true
            disableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(false) end
            if mobSetAutoBat then mobSetAutoBat(false) end
        end
        local function finishDrop(threadRef)
            if threadRef and dropConnections then
                for i = #dropConnections, 1, -1 do
                    if dropConnections[i] == threadRef then
                        table.remove(dropConnections, i)
                        break
                    end
                end
            end
            dropActive = false
            local c = LP.Character
            if c then
                local r = c:FindFirstChild("HumanoidRootPart")
                local h = c:FindFirstChildOfClass("Humanoid")
                if r then
                    r.AssemblyLinearVelocity = _V3zero
                    r.AssemblyAngularVelocity = _V3zero
                    if r.Position.Y < -100 then
                        r.CFrame = _CFnew(r.Position.X, 5, r.Position.Z)
                    end
                    local rp = RaycastParams.new()
                    rp.FilterDescendantsInstances = {c}
                    rp.FilterType = Enum.RaycastFilterType.Exclude
                    local rr = workspace:Raycast(r.Position, _V3new(0, -2000, 0), rp)
                    if rr then
                        local off = (h and h.HipHeight or 2) + (r.Size.Y / 2)
                        r.CFrame = _CFnew(r.Position.X, rr.Position.Y + off, r.Position.Z)
                    end
                    if h and h.Health > 0 then h:ChangeState(Enum.HumanoidStateType.Running) end
                end
            end
            if wasAutoBat then
                enableAutoBat()
                if autoBatSetVisual then autoBatSetVisual(true) end
                if mobSetAutoBat then mobSetAutoBat(true) end
            end
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
        end
        local flingThread = nil
        flingThread = task.spawn(function()
            local startTime = _tick()
            while dropActive and (_tick() - startTime) < 0.25 do
                RunService.Heartbeat:Wait()
                local c = LP.Character
                local r = c and c:FindFirstChild("HumanoidRootPart")
                if not r then break end
                local vel = r.AssemblyLinearVelocity
                vel = _V3new(0, vel.Y, 0)
                r.AssemblyLinearVelocity = vel * 10000 + _V3new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if r and r.Parent then r.AssemblyLinearVelocity = vel end
                RunService.Stepped:Wait()
                if r and r.Parent then r.AssemblyLinearVelocity = vel + _V3new(0, 0.1, 0) end
            end
            finishDrop(flingThread)
        end)
        table.insert(dropConnections, flingThread)
        task.delay(0.35, function()
            if dropActive then finishDrop(flingThread) end
        end)
        return
    end

    if autoBatEnabled then
        autoBatEnabled = false
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
        if stopAimbotAdapt then stopAimbotAdapt() end
    end
    dropActive = true
    if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
    if mobSetDropBR then mobSetDropBR(false) end
    local t0 = _tick()
    if _dropConn then _dropConn:Disconnect() end
    _dropConn = RunService.Heartbeat:Connect(function()
        local r = char and char:FindFirstChild("HumanoidRootPart")
        if not r then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            dropActive = false
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        if _tick() - t0 >= DROP_ASCEND_DURATION then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            local rp = _RayParams_new()
            rp.FilterDescendantsInstances = {char}
            rp.FilterType = Enum.RaycastFilterType.Exclude
            local rr = workspace:Raycast(r.Position, _V3new(0, -2000, 0), rp)
            if rr then
                local hum2 = char:FindFirstChildOfClass("Humanoid")
                local off = ((hum2 and hum2.HipHeight) or 2) + (r.Size.Y / 2)
                r.CFrame = _CFnew(r.Position.X, rr.Position.Y + off, r.Position.Z)
                r.AssemblyLinearVelocity = _V3zero
            end
            dropActive = false
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        r.Velocity = _V3new(r.Velocity.X, DROP_ASCEND_SPEED, r.Velocity.Z)
    end)
end

function executeDropWithToggle(setVisual)
    if dropActive then return end
    task.spawn(function()
        if setVisual then setVisual(true) end
        runDropBrainrot()
        while dropActive do task.wait() end
        task.wait(0.1)
        if setVisual then setVisual(false) end
    end)
end

local _alSaved = setmetatable({}, { __mode = "k" })
local _alDetached = {}
local _alAnimators = setmetatable({}, { __mode = "k" })
local _alStoppedTracks = setmetatable({}, { __mode = "k" })
local _alGeneration = 0
local _alScanCancel = nil
local _alConns = {}
local _alLightOrig = nil
local _alRunning = false

local AL_LOW_FLAGS = {
    {"DFIntClusterSenderMaxJoinBandwidthBps", "2100000000"},
    {"DFIntClusterSenderMaxUpdateBandwidthBps", "2100000000"},
    {"DFIntServerFramesBetweenJoins", "1"},
    {"DFIntRaknetBandwidthInfluxHundredthsPercentageV2", "10000"},
    {"DFIntConnectionMTUSize", "1400"},
    {"FIntRakNetResendBufferArrayLength", "1024"},
    {"DFIntRakNetNakResendDelayMsMax", "1"},
    {"DFIntWaitOnUpdateNetworkLoopEndedMS", "100"},
    {"DFIntWaitOnRecvFromLoopEndedMS", "100"},
    {"DFIntLargePacketQueueSizeCutoffMB", "1000"},
    {"DFIntSendRakNetStatsInterval", "2147483647"},
    {"DFIntRakNetLoopMs", "1"},
    {"DFIntRakNetSelectTimeoutMs", "1"},
    {"DFIntNetworkClusterPacketCacheNumParallelTasks", "8"},
    {"DFIntReplicationDataCacheNumParallelTasks", "8"},
    {"DFIntMegaReplicatorNumParallelTasks", "16"},
    {"DFIntMaxProcessPacketsStepsPerCyclic", "512"},
    {"DFIntMaxProcessPacketsStepsAccumulated", "0"},
    {"DFIntMaxProcessPacketsJobScaling", "1000"},
    {"DFIntClientPacketMaxFrameMicroseconds", "200000"},
    {"DFIntClientPacketExcessMicroseconds", "10000"},
    {"DFIntClientPacketMinMicroseconds", "1"},
    {"DFIntClientPacketMaxDelayMs", "1"},
    {"DFIntMaxWaitTimeBeforeForcePacketProcessMS", "1"},
    {"DFIntMaxFrameBufferSize", "4"},
    {"DFIntBufferCompressionThreshold", "100"},
    {"DFIntOverrideISRReplicatorStepBandwidthBytes", "131072"},
    {"DFIntTaskSchedulerJobInitThreads", "8"},
    {"DFIntTaskSchedulerJobInGameThreads", "8"},
    {"FIntTaskSchedulerAutoThreadLimit", "16"},
    {"FIntTaskSchedulerAsyncTasksMinimumThreadCount", "4"},
    {"DFIntRuntimeConcurrency", "16"},
    {"FIntSimWorldTaskQueueParallelTasks", "20"},
    {"DFIntHttpBatchLimit", "256"},
    {"FIntHttpBatchLimit", "256"},
    {"DFIntHttpCurlConnectionCacheSize", "512"},
    {"FIntDefaultMeshCacheSizeMB", "512"},
    {"DFIntMemCacheMaxCapacityMB", "256"},
    {"DFIntNumAssetsMaxToPreload", "1"},
    {"DFFlagEnableSoundPreloading", "false"},
    {"FFlagSlimContentProvider", "true"},
    {"DFFlagDebugSkipMeshVoxelizer", "true"},
    {"DFFlagTextureQualityOverrideEnabled", "true"},
    {"DFIntTextureQualityOverride", "0"},
    {"FIntDebugTextureManagerSkipMips", "7"},
    {"DFIntDebugLimitMinTextureResolutionWhenSkipMips", "8"},
    {"FFlagTM2SkipMipsForUnstreamable2", "true"},
    {"DFFlagDoNotSkipMipsBasedOnSystemMemoryPS", "true"},
    {"FFlagRenderUseTextureManager224", "false"},
    {"DFIntDebugFRMQualityLevelOverride", "1"},
    {"DFFlagDebugPauseVoxelizer", "true"},
    {"FFlagFastGPULightCulling3", "true"},
    {"FIntRenderLocalLightFadeInMs", "0"},
    {"FIntRenderLocalLightUpdatesMax", "1"},
    {"FIntRenderShadowmapBias", "0"},
    {"FIntSSAOMipLevels", "0"},
    {"FIntDebugForceMSAASamples", "1"},
    {"FIntDebugFRMOptionalMSAALevelOverride", "0"},
    {"FIntRobloxGuiBlurIntensity", "0"},
    {"FIntFRMMinGrassDistance", "0"},
    {"FIntFRMMaxGrassDistance", "0"},
    {"DFFlagCoreScriptTelemetry2", "false"},
    {"DFFlagBrowserTrackerIdTelemetryEnabled", "false"},
    {"FFlagPerfDataOnTelemetryV2", "false"},
    {"FFlagSendRenderFidelityTelemetry2", "false"},
    {"FFlagEnableTelemetryServiceMemoryCPUInfo", "false"},
    {"DFIntTelemetryProfilerHundredthsPercentage", "0"},
    {"FIntTelemetryProfilerFrequency", "0"},
    {"FIntPerformanceTelemetryQueueProcessLimit", "0"},
    {"DFIntContentProviderPreloadHangTelemetryHundredthsPercentage", "0"},
}

local function _alApplyLowFlags()
    local env = (getgenv and getgenv()) or _G
    local setter = rawget(env, "setfflag") or rawget(_G, "set_fflag")
    local getter = rawget(env, "getfflag") or rawget(_G, "get_fflag")
    if type(setter) ~= "function" then return end
    for _, flag in ipairs(AL_LOW_FLAGS) do
        local canSet = true
        if type(getter) == "function" then
            local ok, current = pcall(getter, flag[1])
            canSet = ok and current ~= nil
        end
        if canSet then pcall(setter, flag[1], tostring(flag[2])) end
    end
end

local function _alSaveLighting()
    if _alLightOrig then return end
    _alLightOrig = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        Ambient = Lighting.Ambient,
        GlobalShadows = Lighting.GlobalShadows,
        EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
        FogStart = Lighting.FogStart,
        FogEnd = Lighting.FogEnd,
    }
end

local function _alApplyLowPermanentSettings()
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    pcall(function()
        UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
    end)
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.EnvironmentDiffuseScale = 0.35
        Lighting.EnvironmentSpecularScale = 0.35
        Lighting.FogStart = 0
        Lighting.FogEnd = 1e10
        Lighting.Brightness = math.max(tonumber(Lighting.Brightness) or 2, 2.5)
        local amb = Lighting.Ambient
        local out = Lighting.OutdoorAmbient
        Lighting.Ambient = Color3.fromRGB(math.max(amb.R * 255, 145), math.max(amb.G * 255, 145), math.max(amb.B * 255, 145))
        Lighting.OutdoorAmbient = Color3.fromRGB(math.max(out.R * 255, 155), math.max(out.G * 255, 155), math.max(out.B * 255, 155))
    end)
    pcall(function()
        local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
        if atmosphere then
            atmosphere.Density = 0
            atmosphere.Glare = 0
            atmosphere.Haze = 0
        end
    end)
    pcall(function()
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            terrain.Decoration = false
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
            local clouds = terrain:FindFirstChildOfClass("Clouds")
            if clouds then clouds.Enabled = false end
        end
    end)
end

local function _alChange(object, property, value)
    pcall(function()
        local original = object[property]
        if original == value then return end
        object[property] = value
        local bucket = _alSaved[object]
        if not bucket then bucket = {}; _alSaved[object] = bucket end
        if not bucket[property] then bucket[property] = { value = original } end
    end)
end

local function _alIsProtectedVisual(object)
    local char = LP.Character
    if char and (object == char or object:IsDescendantOf(char)) then return true end
    if object:GetAttribute("_AdaptDuelsSky") == true then return true end
    local parent = object
    while parent and parent ~= workspace do
        if parent:IsA("LayerCollector") or parent:IsA("GuiObject") or parent:IsA("GuiBase2d") then
            return true
        end
        local name = parent.Name or ""
        if name:match("^Crystal") or name:match("^Eclipse") or name:match("^ESP_")
            or name:match("^BloodHounds") or name:match("^VisibleHub") then
            return true
        end
        parent = parent.Parent
    end
    return false
end

-- ===== Anti Lag (el mismo de Visible Hub) =====
_visAL = {brightness = nil, clock = nil, ambient = nil}
function applyAntiLagDerender(obj)
    pcall(function()
        if not obj or not obj.Parent then return end
        if obj:IsA("Sky") or obj:IsA("Atmosphere") or obj:IsA("Clouds") then return end
        if obj:IsA("Accessory") or obj:IsA("Hat") then
            local char = LP.Character
            if char and obj:IsDescendantOf(char) then return end
            pcall(function() obj:Destroy() end)
            return
        end
        if obj:IsA("BasePart") then
            local char = LP.Character
            if char and obj:IsDescendantOf(char) then return end
            local model = obj:FindFirstAncestorOfClass("Model")
            if model and Players:GetPlayerFromCharacter(model) then return end
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
            pcall(function()
                obj.TopSurface = Enum.SurfaceType.Smooth
                obj.BottomSurface = Enum.SurfaceType.Smooth
                obj.FrontSurface = Enum.SurfaceType.Smooth
                obj.BackSurface = Enum.SurfaceType.Smooth
                obj.LeftSurface = Enum.SurfaceType.Smooth
                obj.RightSurface = Enum.SurfaceType.Smooth
            end)
            for _, child in ipairs(obj:GetChildren()) do
                if child:IsA("Decal") or child:IsA("Texture") then
                    child.Transparency = 0.5
                end
            end
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 0.5
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
            or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
            obj.Enabled = false
        end
    end)
end

function enableAntiLag()
    _alRunning = true
    removeAccessoriesEnabled = true
    antiLagEnabled = true
    _visAL.brightness = _visAL.brightness or Lighting.Brightness
    _visAL.clock = _visAL.clock or Lighting.ClockTime
    _visAL.ambient = _visAL.ambient or Lighting.OutdoorAmbient
    pcall(function()
        settings().Rendering.QualityLevel = 1
    end)
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e10
        Lighting.Brightness = 1
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        for _, e in ipairs(Lighting:GetChildren()) do
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect")
                or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                e.Enabled = false
            end
        end
    end)
    pcall(function()
        local t = workspace:FindFirstChildOfClass("Terrain")
        if t then
            t.WaterWaveSize = 0
            t.WaterWaveSpeed = 0
            t.WaterReflectance = 0
            t.WaterTransparency = 0
            t.Decoration = false
        end
    end)
    for _, obj in ipairs(workspace:GetDescendants()) do
        applyAntiLagDerender(obj)
    end
    if antiLagDescConn then pcall(function() antiLagDescConn:Disconnect() end) end
    antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
        if removeAccessoriesEnabled and antiLagEnabled then
            applyAntiLagDerender(obj)
        end
    end)
end

function disableAntiLag()
    _alRunning = false
    removeAccessoriesEnabled = false
    antiLagEnabled = false
    if antiLagDescConn then pcall(function() antiLagDescConn:Disconnect() end); antiLagDescConn = nil end
    pcall(function()
        if _visAL.brightness then Lighting.Brightness = _visAL.brightness end
        if _visAL.clock then Lighting.ClockTime = _visAL.clock end
        if _visAL.ambient then Lighting.OutdoorAmbient = _visAL.ambient end
        Lighting.ExposureCompensation = 0
        Lighting.GlobalShadows = true
        Lighting.EnvironmentDiffuseScale = 1
        Lighting.EnvironmentSpecularScale = 1
    end)
end

function applyStretchFOV(val)
    local cam = workspace.CurrentCamera
    if cam then pcall(function() cam.FieldOfView = val end) end
end

function enableStretch()
    if stretchConn then return end
    stretchEnabled = true
    local cam = workspace.CurrentCamera
    if not cam then return end
    origFOV = cam.FieldOfView or 70
    applyStretchFOV(stretchFOV)
    stretchConn = RunService.RenderStepped:Connect(function()
        if not stretchEnabled then
            stretchConn:Disconnect()
            stretchConn = nil
            return
        end
        local c = workspace.CurrentCamera
        if c then c.CFrame = c.CFrame * _CFnew(0,0,0,1,0,0,0,0.7,0,0,0,1) end
    end)
    if stretchFovConn then stretchFovConn:Disconnect() end
    stretchFovConn = RunService.RenderStepped:Connect(function()
        if stretchEnabled then applyStretchFOV(stretchFOV)
        else stretchFovConn:Disconnect(); stretchFovConn = nil end
    end)
end

function disableStretch()
    stretchEnabled = false
    if stretchConn then stretchConn:Disconnect(); stretchConn = nil end
    if stretchFovConn then stretchFovConn:Disconnect(); stretchFovConn = nil end
    local cam = workspace.CurrentCamera
    if cam then pcall(function() cam.FieldOfView = origFOV or 70 end) end
end

local function saveLightingState()
    if _originalLighting then return end
    _originalLighting = {
        Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
        OutdoorAmbient = Lighting.OutdoorAmbient, GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd, FogStart = Lighting.FogStart,
        FogColor = Lighting.FogColor, Ambient = Lighting.Ambient,
        ColorCorrection = nil, Bloom = nil,
    }
    for _, e in ipairs(Lighting:GetChildren()) do
        if e:IsA("ColorCorrectionEffect") then
            _originalLighting.ColorCorrection = { Enabled = e.Enabled, Brightness = e.Brightness, Contrast = e.Contrast, Saturation = e.Saturation, TintColor = e.TintColor }
        elseif e:IsA("BloomEffect") then
            _originalLighting.Bloom = { Enabled = e.Enabled, Intensity = e.Intensity, Size = e.Size, Threshold = e.Threshold }
        end
    end
end

local function restoreLightingState()
    if not _originalLighting then return end
    local old = _originalLighting
    Lighting.Brightness = old.Brightness
    Lighting.ClockTime = old.ClockTime
    Lighting.OutdoorAmbient = old.OutdoorAmbient
    Lighting.GlobalShadows = old.GlobalShadows
    Lighting.FogEnd = old.FogEnd
    Lighting.FogStart = old.FogStart
    Lighting.FogColor = old.FogColor
    Lighting.Ambient = old.Ambient
    if old.ColorCorrection then
        local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
        if cc then
            cc.Enabled = old.ColorCorrection.Enabled; cc.Brightness = old.ColorCorrection.Brightness
            cc.Contrast = old.ColorCorrection.Contrast; cc.Saturation = old.ColorCorrection.Saturation
            cc.TintColor = old.ColorCorrection.TintColor
        end
    end
    if old.Bloom then
        local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
        if bloom then
            bloom.Enabled = old.Bloom.Enabled; bloom.Intensity = old.Bloom.Intensity
            bloom.Size = old.Bloom.Size; bloom.Threshold = old.Bloom.Threshold
        end
    end
end

SKY_PRESETS_LIST = {"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}

SKY_PRESETS = {
    ["Off"]={kind="off"},
    ["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
    ["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
    ["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
    ["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
    ["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
    ["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
    ["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
    ["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
    ["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
    ["Volcanic"]={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
    ["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
    ["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
    ["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.55,dens=0.55,color={200,150,255}}},
    ["Toxic"]={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
    ["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
    ["Hellscape"]={clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
    ["Heaven"]={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
    ["Storm"]={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
    ["Sunrise"]={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
    ["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
    ["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
    ["Inferno"]={clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
    ["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}

local function _vC3(t) return Color3.fromRGB(t[1], t[2], t[3]) end

function _v4mpClearSky()
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:GetAttribute("_AdaptDuelsSky") then
            pcall(function() child:Destroy() end)
        end
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, child in ipairs(terrain:GetChildren()) do
            if child:GetAttribute("_AdaptDuelsSky") then
                pcall(function() child:Destroy() end)
            end
        end
    end
end

function applyCustomSky(mode)
    _v4mpClearSky()
    local preset = SKY_PRESETS[mode]
    if not preset or preset.kind == "off" then
        Lighting.ClockTime = 14
        Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
        Lighting.Ambient = Color3.fromRGB(127,127,127)
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
        skyTheme = "Off"
        return
    end
    Lighting.FogStart = 0
    Lighting.FogEnd = 100000
    Lighting.FogColor = Color3.fromRGB(200,200,200)
    Lighting.ColorShift_Top = Color3.fromRGB(0,0,0)
    Lighting.ColorShift_Bottom = Color3.fromRGB(0,0,0)
    Lighting.GlobalShadows = true
    Lighting.ClockTime = preset.clock or 14
    Lighting.Brightness = math.max(tonumber(preset.brightness) or 2, 2.5)
    if preset.outAmb then Lighting.OutdoorAmbient = _vC3(preset.outAmb) end
    if preset.ambient then Lighting.Ambient = _vC3(preset.ambient) end
    local amb = Lighting.Ambient
    local out = Lighting.OutdoorAmbient
    Lighting.Ambient = Color3.fromRGB(math.max(amb.R * 255, 135), math.max(amb.G * 255, 135), math.max(amb.B * 255, 135))
    Lighting.OutdoorAmbient = Color3.fromRGB(math.max(out.R * 255, 145), math.max(out.G * 255, 145), math.max(out.B * 255, 145))
    if preset.sky then
        local skyInst = Instance.new("Sky")
        skyInst:SetAttribute("_AdaptDuelsSky", true)
        if preset.sky.stars then skyInst.StarCount = preset.sky.stars end
        if preset.sky.moon then skyInst.MoonAngularSize = preset.sky.moon end
        if preset.sky.sun then skyInst.SunAngularSize = preset.sky.sun end
        if preset.sky.moonTex then skyInst.MoonTextureId = "rbxasset://sky/moon.jpg" end
        skyInst.Parent = Lighting
    end
    if preset.atm then
        local atm = Instance.new("Atmosphere")
        atm:SetAttribute("_AdaptDuelsSky", true)
        atm.Density = preset.atm.dens or 0.3
        atm.Color = _vC3(preset.atm.color)
        atm.Decay = _vC3(preset.atm.decay)
        atm.Glare = preset.atm.glare or 1
        atm.Haze = preset.atm.haze or 1
        atm.Parent = Lighting
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if preset.clouds and terrain then
        local clouds = Instance.new("Clouds")
        clouds:SetAttribute("_AdaptDuelsSky", true)
        clouds.Cover = preset.clouds.cover or 0.5
        clouds.Density = preset.clouds.dens or 0.5
        clouds.Color = _vC3(preset.clouds.color)
        clouds.Parent = terrain
    end
    skyTheme = mode
end

function enableVividGraphics()
    if vividGraphicsEnabled and #_vividEffects > 0 then return end
    vividGraphicsEnabled = true
    for _, eff in ipairs(_vividEffects) do
        pcall(function() eff:Destroy() end)
    end
    _vividEffects = {}
    local color = Instance.new("ColorCorrectionEffect")
    color.Parent = Lighting
    color.Saturation = 0.6; color.Contrast = 0.4; color.Brightness = 0.05
    color.TintColor = Color3.fromRGB(255, 240, 220)
    table.insert(_vividEffects, color)
    local bloom = Instance.new("BloomEffect")
    bloom.Parent = Lighting
    bloom.Intensity = 0.8; bloom.Size = 24; bloom.Threshold = 1
    table.insert(_vividEffects, bloom)
    local atmosphere = Instance.new("Atmosphere")
    atmosphere.Parent = Lighting
    atmosphere.Density = 0.3; atmosphere.Offset = 0.25
    atmosphere.Color = Color3.fromRGB(199, 199, 255)
    atmosphere.Decay = Color3.fromRGB(106, 112, 125)
    atmosphere.Glare = 0.2; atmosphere.Haze = 1
    table.insert(_vividEffects, atmosphere)
    local sun = Instance.new("SunRaysEffect")
    sun.Parent = Lighting
    sun.Intensity = 0.2; sun.Spread = 0.8
    table.insert(_vividEffects, sun)
    local dof = Instance.new("DepthOfFieldEffect")
    dof.Parent = Lighting
    dof.FocusDistance = 25; dof.InFocusRadius = 10
    dof.NearIntensity = 0.2; dof.FarIntensity = 0.4
    table.insert(_vividEffects, dof)
    task.spawn(function()
        while vividGraphicsEnabled and color and color.Parent do
            color.Contrast = 0.35 + math.sin(tick() * 2) * 0.05
            task.wait(0.1)
        end
    end)
end

function disableVividGraphics()
    vividGraphicsEnabled = false
    for _, eff in ipairs(_vividEffects) do
        pcall(function() eff:Destroy() end)
    end
    _vividEffects = {}
end

function toggleVividGraphics(on)
    if on then enableVividGraphics() else disableVividGraphics() end
    saveAllSettings(true)
end

function applyHideButtons(state)
    hideButtonsEnabled = state == true
    if MobilePanel then
        for _, child in ipairs(MobilePanel:GetChildren()) do
            -- Sólo ocultar los botones móviles; no tocar skins, accesorios ni el menú principal.
            if child:IsA("GuiButton") then
                child.Visible = not hideButtonsEnabled
            end
        end
    end
end

function toggleHideButtons(on)
    applyHideButtons(on)
    if setHideButtonsVisual then setHideButtonsVisual(on) end
    saveAllSettings(true)
end

function MVPUI.new(class, parent, props)
    local object = Instance.new(class)
    for key, value in pairs(props or {}) do object[key] = value end
    object.Parent = parent
    return object
end
function MVPUI.round(object, radius)
    local corner = object:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", object)
    corner.CornerRadius = UDim.new(0, radius or 12)
    return corner
end
function MVPUI.stroke(object, color, transparency, thickness)
    return MVPUI.new("UIStroke", object, {Color = color, Transparency = transparency or 0,
        Thickness = thickness or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
end
-- ===== EFEK WARNA MENGALIR: warna lewat-lewat di pinggir & teks mengikuti Theme Color (Settings > Misc) =====
MVPUI.flowItems = MVPUI.flowItems or {}
function MVPUI.flowPalette(readable)
    local c = getThemeColor() or Color3.fromRGB(200, 40, 255)
    local W, K = Color3.new(1, 1, 1), Color3.new(0, 0, 0)
    local sec = readable and getThemeSecondaryReadable() or getThemeSecondary()
    if sec and sec == c then sec = nil end
    local b = sec or c:Lerp(W, 0.65)
    return {c, b, c:Lerp(K, 0.4), b}
end
function MVPUI.flowColorAt(pal, t)
    local n = #pal
    local p = (t % 1) * n
    local i = math.floor(p)
    local f = p - i
    return pal[i % n + 1]:Lerp(pal[(i + 1) % n + 1], f)
end
function MVPUI.flowSequence(readable, phase)
    local pal = MVPUI.flowPalette(readable)
    local pts = {}
    local steps = 8
    for i = 0, steps do
        pts[#pts + 1] = ColorSequenceKeypoint.new(i / steps, MVPUI.flowColorAt(pal, (i / steps) + (phase or 0)))
    end
    return ColorSequence.new(pts)
end
function MVPUI.addFlow(target, kind, speed)
    if not target or not target.Parent then return nil end
    kind = kind or "stroke"
    local old = target:FindFirstChild("VisibleFlow")
    if old then old:Destroy() end
    local grad = Instance.new("UIGradient")
    grad.Name = "VisibleFlow"
    grad.Color = MVPUI.flowSequence(kind == "text", 0)
    grad.Parent = target
    if kind == "text" then target.TextColor3 = Color3.new(1, 1, 1)
    else target.Color = Color3.new(1, 1, 1) end
    table.insert(MVPUI.flowItems, {g = grad, kind = kind, speed = speed or 70, target = target})
    MVPUI.startFlow()
    return grad
end
function MVPUI.startFlow()
    if MVPUI.flowConn then return end
    local acc, t, sig = 0, 0, nil
    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        if _mySession ~= _G.VisibleHubSession then
            conn:Disconnect()
            if MVPUI.flowConn == conn then MVPUI.flowConn = nil end
            return
        end
        acc = acc + dt
        t = t + dt
        if acc < 1 / 30 then return end
        acc = 0
        local newSig = tostring(getThemeColor()) .. "|" .. tostring(currentColorTheme)
        local rebuild = newSig ~= sig
        sig = newSig
        local items = MVPUI.flowItems
        for i = #items, 1, -1 do
            local it = items[i]
            if not (it.g and it.g.Parent and it.target and it.target.Parent) then
                table.remove(items, i)
            elseif it.kind == "text" then
                it.g.Color = MVPUI.flowSequence(true, (t * 0.3) % 1)
            else
                if rebuild then it.g.Color = MVPUI.flowSequence(false, 0) end
                it.g.Rotation = (t * it.speed) % 360
            end
        end
    end)
    MVPUI.flowConn = conn
end

function MVPUI.text(parent, text, position, size, fontSize, color, z)
    local fs = fontSize or 12
    local lbl = MVPUI.new("TextLabel", parent, {Text = text, Position = position, Size = size,
        BackgroundTransparency = 1, TextColor3 = color or Color3.fromRGB(245, 241, 235),
        Font = Enum.Font.GothamMedium, TextSize = fs, ZIndex = z or 8,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.None,
        TextStrokeColor3 = Color3.fromRGB(0, 0, 0), TextStrokeTransparency = 0.6})
    -- teks panjang mengecil otomatis (tidak terpotong), ukuran normal tetap fs
    local tall = size and (size.Y.Scale > 0 or size.Y.Offset >= fs + 6)
    local wide = size and (size.X.Scale > 0 or size.X.Offset > 0)
    if tall and wide then
        lbl.TextScaled = true
        MVPUI.new("UITextSizeConstraint", lbl, {MaxTextSize = fs, MinTextSize = math.max(8, math.floor(fs * 0.7))})
    end
    return lbl
end

-- cek teks yang masih terpotong/keluar kotak, lalu kecilkan otomatis supaya tetap terbaca
function MVPUI.fitTexts(root)
    if not root or not root.Parent then return end
    local sc = (mainUIScale and mainUIScale.Parent and mainUIScale.Scale) or 1
    if sc <= 0 then sc = 1 end
    for _, d in ipairs(root:GetDescendants()) do
        if (d:IsA("TextLabel") or d:IsA("TextButton")) and d.Text ~= "" and not d.TextScaled then
            pcall(function()
                if d.TextTruncate ~= Enum.TextTruncate.None then d.TextTruncate = Enum.TextTruncate.None end
                local a, b = d.AbsoluteSize, d.TextBounds
                if a.X > 4 and a.Y > 4 and d.TextSize >= 9 and (b.X > a.X / sc + 1 or b.Y > a.Y / sc + 1) then
                    local fs = d.TextSize
                    MVPUI.new("UITextSizeConstraint", d, {MaxTextSize = fs, MinTextSize = 8})
                    d.TextScaled = true
                end
            end)
        end
    end
end
-- foto anime (menggantikan foto Sasuke): disimpan sebagai file lalu dipakai lewat getcustomasset
MVPUI.ANIME_FILE = "visible_avatar_v1.jpg"
MVPUI.ANIME_B64 = table.concat({
    "/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAUDBAQEAwUEBAQFBQUGBwwIBwcHBw8LCwkMEQ8SEhEPERETFhwXExQaFRERGCEYGh0dHx8fExciJCIeJBweHx7/",
    "2wBDAQUFBQcGBw4ICA4eFBEUHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh7/wAARCACgAKADASIAAhEBAxEB/8QA",
    "HQAAAQUBAQEBAAAAAAAAAAAABQADBAYIBwIBCf/EAEgQAAIBAwIDBQUEBwUGBQUAAAECAwQFEQAGEiExBxMiQVEUMmFxgUJSYpEIFSMzgqHRQ3KSscEWJDRT",
    "g5MJJ1RzdKKjsuHw/8QAFQEBAQAAAAAAAAAAAAAAAAAAAAH/xAAVEQEBAAAAAAAAAAAAAAAAAAAAAf/aAAwDAQACEQMRAD8A2S0aM6uyKWXPCSOY+WvqoqZ4",
    "VC5OTgYyfXX3TFwq4aGilq5yRHEpZsDJPwA8yegGgbu1wprbSe0VLNzYJGiLxPI56Kq9ST6fM9ATrn/tlddYKi911UiUTTD2cRNlGA5Roh5iRhzJk5oCSVDY",
    "DD4Vk3NdBVXSTgo5YXkZS2EjpB7wB+4x5FusmGP7tAGUNXBfrulwWH2e12uMLTRMvAFdlBGV6DEfAceXEB5HQEqRHhph3xbiZuPhYk8J6555Of5j55Omp5mV",
    "f3pREH3uFVA/yA18FS04ZzyOfdPkPLPxxz+ug11k9tqzQD/hosPV+jk81i+R95vhwj7R0DYketMdY0kqUiHjpogSvEf+aw+pKg9M5PM8hN7rpg8wSaTMUcIX",
    "LE4Z5QAfmOHIPlotVzFhzOqrfphFLXOf+TTS/RJjn8s6CXVOFyqsyqDyVWIA+g0EnqSQCHfwuY28Z5H8/l+eplwn7sFiftcP89Vy61cNNXxRStwrXkxr5DvF",
    "XI+pUH/CNBIrnLf2kn/cb+uhU7EdJZR/1G/rr09SxDRyHEicm+Pofr/XQ+pm64OgjVszDI76X/ut/XQaqmlXJFRUD/rN/XUmul55zoTUzAgjOgYqaufniqqf",
    "++/9dDKqsqh0rKsD/wCQ/wDXXuqlxnQypkzoIdbUTcRPtdUjHzE7/wBdWzsnj3dFUS32wyXe/wANMMXS12q5Fa6GPPKZYJlZJl+QYZyCFODqkXCQFSDgg+Wo",
    "m3ty3jau5aS92Orekr6NuOnmHMH7yOPtKw5EeY/PQbv7M5LRu+xm5be3LQ3RUbu6iOvscCVNLJ5xzRoIyjj0IHqMjV4t23YI2Zq+C1VHLCrFbkiUfPJYn89c",
    "77Parb3a/tWk7QNvzSbc3WiGmqqujx3sMygZhmU+GeLowVwfCwIKnmLhsTddfcLnWbX3RQxW7ctvjEsiQkmnrYCeFamnJ58BPJlPiRuRzlWYLjqvbtpDeamh",
    "sRJFNK/tNZhscUUZGI/4nKg/hDasOo3soFxas4vEYRFjHoxP+ug5/e7hFDQ3msm4e5kmcSqOgpoGMSRj0DMsrfINqFZ1lg25QUcxX2p4/aa5mHJqiT9rID+F",
    "C3P5Kvrpjcq0NRZayNpyKSouVQ1S0OQ4iPeRJFGfvlnLk9EDFmxyBI1EYin9kdV7zh4plQ+GNAfCg+BOficMT10DZqBTW8zOjcKoX4SfEfMZ/EfP4nQ2NTTU",
    "apI3FM7GSZ/vSMcsf9B8ANSrhKJo1HUGRSfiAc/6aFXGqCTQRZOZGbH0UnQKqlwDz1Wr68bp30rYhCvDOfSKTkW/hIVvkDopcKgRU8kpPJFLfkM6DpN+zkVg",
    "Dz4CD54AB/nnQQKqpka0uZf38PhlHo6EcX+WfkRoHvKiN6sksFNUNBOrpUU86DJjdGDAgefLIx5gkacuUr2iWSWQGS1uvDM+ctAoGAxHmqjlnrwgZ93JHC4P",
    "QnjLrNRP9tDxdy3rkdUPXPln0PIIlDcp5gKe5xLT16Eqh4spOvkynzBGDg8/rnXyeoUlhnxDqM8xqDc4o6kvRyHheM97TSAZKqT5eoB5EeYx8DoS887SmOo5",
    "1MS9QfGFJ6qT76H0PMHkefPQT6yUNnQCtnMTklvAfM/Z+fw09VVwj/ekAfeHT6+n1/PQ6tlDoeYII+h0DVVNn56G1MwAOo9azxEcDHhXoAeY+HxHw0Plrk6S",
    "4X8X2f8A9fXQKun64Pz0JmkWRSOepFVKCxxj6aGSvzOCeWg0H+gvf7hZO1aaz1EjJa9x0UwgDHCyVNMQfD+IIzgjrgj4a2derVTVN5s93MX++UMrrFIOvdyp",
    "wyKfwnCNj1RfTWEey22VdX+jxurdNrlMV52XuKnvVulHVcRRiVf7rKASPPgGt/26Z6mgp6iSMxPLErsh6qSAcfTQPMSFJUZOOQzjOq5dYN3XCXuIZLbbKMjD",
    "SJLJLMfXoqhfoc/EasmloOa7islvslwtXtJeohNHWxSs6gLwlEPAqjAUHhYgDmTzJJ56GVM8qukUpJq6xjJNzyUUAZ5/AcKD4kn11aO0Spp562ioZOALRn2+",
    "aRv7MAMqfn4yfgnx1R6SoNVWGvcMBNRxuisMFEdmKqfQ8KgkepOgm1DhE5+XQar91k4rnQfOb/8ADU+vqeoz/wD2dArtOUuNu/ZyMC8gZlHhQGM4LHyycAfH",
    "QN7ilP6rqQDzMZUfXl/roZDMHhaT78kjD/G2nryktcj0kLsuUMrFeoSIGV/zCY/i0IpKk/qynJPMpn65OgdrZBg8+eqPf4Kq0cNVYRAiGUGajl5QuDyPCQMx",
    "nzGARnljnqz1s+Qeeq7fqhBQztI2EVcsc+Q56AZWzGWOKWj4KaRTxiKXmhz1AZegI9OXQ41EraiKQhZAUkHuZ6g/hOvU8ywRKGYGI+6dCbkFYd+iCeMj9pEO",
    "fEPvL8R6efzxoG6+r7j/AIrkh5CXHL6+n+Wh1RIgHFE2FPMY6HTlXlY8RSM0ZGQjnP5E8x9dBu9iw6RKYmDHiXGB88dNUM3WpZE4/Q9ND6iWJ8ZHMjGdOV0h",
    "ZQr9Cw0NnlHdqPTwk6g+yxRAlo3dTnoDoZO4WcrxZyudTZZvCcMdCK4uZY2QFmJ4cKCSc6DYv6AlJT3fY+9rROkcsb3KkaeNxkNGUzgjzzwEa13rBX/h97zp",
    "bR2o3XbVZMsSX+kX2cs3JqiElgvzKNJ+QGt66BaWlpaDk9/mNXd7kHI4Z6qRpfhDCViVf4pCo/ibVdtdV7TAtV4gKilp5/EOf7RWl5/49WztKt4stHeLmnF3",
    "E8EThjzEbCrEko+AIYN/CfTVHqzVUy3Kgo41etouGgiR+jSxju0B+B8H0Og83KoPesoP20X8wTootlet7PLjfKeubvYJlmamUK4eGBjkke8p5yHIxy6g6ply",
    "uKSJLWJIFhxDUgk4AUQsxz6Y4W/LUKq3Lufs/gttZ+rpe0baE8LR1MU1KguVsHCXYLJGBxRFSzLxdQG5rwnQWzs4ShuW5rpbairhjqZrVVwUsTvhpXcBDwZ6",
    "kBW5Dng56a5rbKsyWsR5zPT5DpnnzZsD+RH01eOyK+7JvFPf4Ka/2Wvppq6IUkFc3d+0Igcrg+9HKpY4dc4YEjI56qV5s8tuXdFVSwT9zYLzGsxkfvJTR1Sc",
    "SFmGeLgcA8WTnif10ECeqV4w6tlSMg+ug1UIakGGoAaF3CyD8JIz/LX2aYRVPdggwz5eIg8s9So/zH10Huks9NAwmwGkpy4I6Hwkg/UD8wdBcO0HZ01nDV8C",
    "NJbahfaU4hyRGYK4/wCnLlD6Boj5nHNLhHLA5amfK5yY2PX662NQ/wCzt02vcLZe7hb6VIbhM8D1FRGvAsyLMOTEZUrOylehUkfLLe5NtxUvaBW7Wpb3a3Hs",
    "8tTbZva0eKqVRxLEJAcBiAyjP2lGccWdBSJqksxBDo33W6HQi4OeIOp4ZF6HGfoR5jU6eoVgcHHqCMEH0I8jobVyDHkfy0ESefvEBIK8+YPloXVTcB4B5tn+",
    "WvNfWNDJxKqtH6evqPnrxTwVNy716Clnqlp4WqZxFGWMMS44nbHRRkZPQZ0HnvcoMnTm3rmtq3VaLowBWir4KghhkYSRW/00PJ8AwT11Ytj7Qqt3Um4lpYpD",
    "U2+0zXClx0kMDRmWP4nunZgPgPXQbJ2x2LbIr94X7aN0t0ltuVmqVu22b1a5TTVIoah2dAGHKQwyh0y4JA4PLGtEWGluNFb4qW5XP9ZyxoFNU8KxSSH1YL4c",
    "/IAfDXPOxuui3Nsjs43hnNdJZmpJ3HVl7te8B+HewKfn89dT0C0tLS0Ea6UNLc7bU26uhWalqomhmjboyMMEfkdcfv1FFF2gywPXexGD2KWtuKqGWOfHBTvI",
    "Dy8bJECPQHmBgjs04laJlhdUkI8LMvEB9MjOq3c9n0VRtW72iNi09045Kipm5vLMQMO+PIcKjA5BQAMAaDPl+gqqLcnsdyooKVDNHBPDniRXaolTAz1jZSxG",
    "eZHI+erjbrRa4b/duzy9VVwspttYsu3r1RTd08UM2ZY4C5BXKssgUOCG4GA55Br/AGQW2776k7QtlbxqJkuVqNJBSVksYFREFMjQM332RkI4/tqQc8866vbo",
    "7hLva1Vt+tcdNX1dtnttxjRu8p52jZZYnjJ95OcxAYAjiII9Q4rdf0erLc+1OagvnsB7xYa+inFG1MLgql++h/ZOERgxUsFXJVuXCOl4teyIdq7mv1JRuxs1",
    "ztdPbp6WSRpo6WfErwlWfLGPLFArZI40GcYA7VPbqGeKGKWkgdIHEkIKD9mw6Mv3TzPMep1FprLTLHcUqlWpFwkLTK4yCvCEVefkFUfUk6DInbDsWu2hVe0w",
    "qzbcuLLJQ1PX2GZvEIX9Bn3T0I5dc6Fw2Ko3X2P1d+oYmNftyrkhrYkGW9lkAlDep7uQy/wM3prWQpaavtclDVrFcbZUxcBhq4xJxxn7LE+8PmM/HPPVC7L9",
    "rW/YnaHvO1Wk1CWmqorfcoopX7zuWZqlHRSeZXwcgcnnjnoOZ9n3aLsa2WSOS43mx2qadaUMsVmWrqVkSigSTibmEHEjdR14jz0Z7Vt1dnd+2nar/Z99UNbd",
    "9tXamuEUiV1PT1IgZlSeNO74SOKNicAE5TGr/tzs6ullpa0WC51FLaLvNNVVFqhMaihllJLCJZFaN0KkBo3AwQSrgErql707DRfrTFFfUsl3e3wTR0LNQtb6",
    "uNCmEjdoGdJeEqvCSAfUnJ0HIP0hrPt5N6zXmz7qtFyN4jaRm9pgEgniXi8XcFkZpk6HCEuoyMtz4iaxJz4Gz54IIOtgWLsOTZVmulxoaix2wQtDXLJSQzz1",
    "a+zFXVFnlYBASrliiAnix0HPn3a32RIu5+0+zWWlJkoKel3VaEQc+5fvEqYR8D4iB6xroM6fq+ouNXHQ0VNJVVNQ3DDDEOJ3c9Ao8yfIflrU/Y7UWu4Wex7i",
    "p9vW6soLHSVNvr47HEkU8FPNHiaOso5SHLeFn72N3DHOFHMaoUvZ7Hv3srsO8No2+W0bjp6FFkeLIprnNAeEusgwkNR4AeE4LH6Nol2t7y2i/YjQ7iW2RW7t",
    "Kvbz26tajd6aenCHu6oTqhHGr9Arg/vTj3dBm4wu1FNWxKxpIJli4z6sGKD54Q/lrcX6KXZ0+27jt+mr6MCri29U3K6KwB4JbhLEsMLD1ENK2R6k6oP6P3ZF",
    "BeexTad2utOphue+aatmV15PRwpLEqH4NISPk2tmWGx0VokrqiAyS1VwqDUVVRK3E8rYCqM+SqoVVUcgB65JCvdim04Nl9ntFtyF+9joaisSJiOaxtVSsq/Q",
    "ED6auuviIqLwooUZJwB5k5OvugWlpaWgWmK+oNLTPMKeeoYdI4V4mY+gyQPzIGn9LQcy9jrLB2qWndNwihiO5YntVciNkQSqO9pF4vteFJUJ+84xyI1erlSz",
    "VN6tUqL+ypnlmd/iYygH14yfpquduMdY/ZpcZLYqm6QSU81uz/6paiMwjPll+EfInVm23dYL3YqO606siVMQfgb3o26Mh+KsCp+IOgIaWlpivq4KGnNRUsVj",
    "BALYzjPmfh8dBXaWAUtJFTKciJQgPrjUWjogl6r7owxJUxQU4B8ki4yD9WkY/lqeXV5GCspIOSAckaR1Q7R1T07nhwQRjB01MWlkLseZ668lkHnpGRMddENV",
    "lLDWUctJUrxwzLwSL95T1H10Bnjmp963nclPazX109BTWqkp+NYxIkTySSO7NyWPjmC5554CADkaI7p3BZ9r7brtxX2sWkttDEZJ5TzPwVR5sx5AeZOuAbD7",
    "Z99bw7Q7BYJ7LbbHbNyf7/HVRNI1Ylv754UQEnhViy+8B0JIwTnUV4s/aHR9hnZ7ubblxVJK2zbjqqeitlKWLSJMqTw8T4xFCQzeI5ZuFgo5E64FtGwXftp3",
    "Bvvfe4alHmoLe9bMkCCPvqmQGOmjUD3UDAEnmcJjmTnWprN2NWq/7g7a9tVtNPBbbzVUL0E8uXeKYQNIJQWJJ4ZJPM5IJHQ6q36OOzD2eVd62puqBKK27woY",
    "o6O6MvKOuhLxzUjueQdX42QHHEF5Ek4AaX2xtG2Wbs/tezxGHo6CihpVK+EkxgYcHqG4hxZ8jz1YkBVApYsQMZPU6YtvtgoYRXmFqoKBK0IIRm9QDzAPXHl0",
    "yeupGgWlpaWgWlpaWgWlpaWghXKiiqZIpqkGWGnYTLDwAgyKcq3qSMch68/TFcs077Yks9vuTRQU90VYYwSBwVvCXKZ8+NVYj8SH7w1cNc57erFPuWy7estI",
    "JRPLuOgmEkRIaJIpDLJICPdwiNz9SB56C0Xq1XeOkml2xco6StJaRYq1DNTSOxyeIZDrnp4WAGeh6aD2i7b0klqaG+bbpJZEy6SU0pjSRM8scfEOIDGRxY9D",
    "qb2cX2tutjp6e9d2t4ip42qCgwswIx3qjyBIYEfZYEdMEm7zTJUUuWMishyrRyMjL8iCNBVKy/2q3MRc5Y7VJjiYVQRcAfiUkfz1Pp6qCqjLU1TTTAdSjK2P",
    "njpqHNZKGpn7yvgiuBAwDV08UjD+PgDfmdC9x27Ythtb3S6bfs6xhgvEKCIu7cz1IHQAnJIAAJJGgsBSQnpH/wBsaB743FYdnbbqL/ua6U9vt8PIu0YLSN5R",
    "xr1dz5AfM4HPU4y7jqUHs9rt1sjPutXVRmkx5HuoeX/3Ncx332I7c3NVy7l7R9z7m3JLTIe6pYpI6SmiBPKOGFASCxKr72SSMk9dBxbc1/3n21bdrb7ZLRTC",
    "0w3mGhs1mlpY6hnHCxnqZMqSzKDEpKjC95gc+vR+zne8m697Vdgl21YLDR2Wm/Va10lNEKyKNFB7tJDhFwRlkzjmcYI12PYmxbX2ednkdh27SwWipqAzzzIx",
    "kMBYlpG43JLCNSQueRIGep1wrayUfZtvBbJSWqpuAp6yrnjFXUrLw99CxRZmIyZAAHkwPD3ka8yc6Dv1osVoZY1t26YpjVEuphmVu+KjhJGG8WAuOXTGjB2r",
    "FJTvTT1ffwSfvIpIlZH555qcg8/XWZLzFBcb1VXurpaQXKpdXkqIIFhcFfd4SuCvD5EHPmSTz1GuO7dy00C0K7u3NWS8P7OA3R1bGeruoDBfixJ8hk6DWUFn",
    "jhUL7TJgYA6gD0HXUG8X/bG3wTedzW2gwM4qaxEJ+QLZOsV1dtSrqPbL7V1N3rCQweoqJWjj9AiMxx8zkn11EqFpqbJp6aJD5cCBT+eg2RQ9rXZhUVQpot8W",
    "USE4He1Xdgn4FsA/nq8QTRTwpNBIksTqGR0YFWB6EEdRr86akzzZaorG4T/ZRHhX6nq38vlqxdl3aXuXszrV/UlQKyzPJxVVnqpT3LZ6tC3PuX+Q4T5jz0G9",
    "9LS0tAtLUe5VkNvt1TX1JIhpomlkIGSFUEnA8+Q1T6S+Xa+Xr9U1Rq9s8cYeJGpgZakYyypM2Y+JR7yhSR1BIBOgtV4vFstEKy3Kugplc4QO3ic+ir1Y/AAn",
    "Qo3m83FgLNYpIoSce13MmBcZ6rEAZG+TBPnpumhsdnrnS10Elxu5GJZAxmn6f2kznwD4Ej4DUyeOsleL9ZTIodwfZoCeADPPiY4L/wAh8DoKrs6KafZ9oq4Z",
    "YxX0zVBhmwVRv28gZD1PdsAOWTjCnmVGilP2h7Snp6mC5XmhstwpRiroblUpBNAfiGIDL6OuVYYIOo/ZvF/5Z2WfHvxtL9HdmH+Y163TU26itZuVxtkVxNMy",
    "LTxGBJJGldwiIhceElmAz5dfLQVPcPapSBHp9ibYve/Lg2eA2ynZKJD5cdU4Ef8Ah4vprm+yr9vjtAG5a/ewoaWGC4jbtBa6IK8EE0mBUNxgnvHEXGuckAg4",
    "xnXa5qfdl2BjuV1gs1IRwmmthLykehnYDH8CqfjoPS7YsVhuu1dt7ft60Vvt6T1vdK7MPCOFWOScuzyMSx5nHM8hoLnEojVY1HJQFHyHLTNDDHeL8AcPSWpw",
    "7+jVJGVH8CnP951810PvMtbwsI14E41hgiB8dVK3JQSPdTPM45kBjyA52K00MNrt9LZYZOOQqXmkxgvk5dz6cTH+fw0Ajta3NDtXYlZeVpFrK08FPbaQnHtV",
    "VI4WGP8AulypP4QSeQ1l7a1E0VPJdKqrNdUVJciqbrPxOXln+c0pZ/7giH2ddF/SMu3683lQ7bidvZLdG7ScJwA7rwyyfNYnEKn71RIeseud3i5srihoUj9o",
    "ZAQMeCBOgZgPLyC+eMdASLA1eLk4mNHRcL1bLxHi92FT9t/h6Dq3yyQJUQ0YZQ7PI54pJXOXlb1P+gHIDkNfKmeC2UUxR+JvfkeRvFK55cTEdSeQAHwAHTVd",
    "kmdqvvJF4qvhw7HpCp58P948uX5/GCbdquXmIAC7cgT0X4n+nnoRVTkDm5JxzPrr7WVWAQDoPVVBOeegVZUYB56EVdSefPlpVlQeehNROSeug/VzS0tNVdRT",
    "0lNJU1U8UEEalpJJHCqgHmSeQGgCb8lH6mhoQfHcK2npAPVWkBf/AOgOfpoNa7ZNvJKe8XecQW3vVqKa2074dZFOQ08g58anlwLgKQcltM1G4KPcm9rZR27v",
    "5KW2081xedoyscjMvcxFM82H7SQhscJ4eROvN5jq7DPV7ps0ioEjaa50bnEVSijJkH3ZQB1+0Bg88aC3S1NFaoloqKl45cZSmp1APzPko/ExH10BuCyVEctz",
    "u84dIInmFHCT3KhFLeM8jIeXnhfw+eiuzdy2bdtkS62eoSaGVRxge8p9GHUHy58+RBwQRoBuYtVSU22KVsVV0lKTEdY6RCDO/wBQVjH4pR6HQG9mUBpOz+zW",
    "9l4XhtsCEejCNc/z1U91XCl/2y2/aqqpigpqXju1Wzt1KAx00YA5sWkd3AAP7nVmvm8KGjrZLPaoWvF4jGXpKZgFpxjPFPL7sK/3vEfsq2qVDuvbeyrTW7r3",
    "XeaZnqWMlVeCAkUnCMJT0i+/KijwgICD4mJJJ0FmapuFWrtRUwoaVFLNV3EGMBQMlhFkNjHPLlBqm9lW/LHvnee6Bt+tkuVFYqemoTcGChaqV3ld2jAAAQcI",
    "UHz8uWCcy/pH9v1y3lt2Wz2mGe02S584KdmxUT06tzmmIPIORhYxywrE8WVxfv0J41tNr3TtqgCJfGNv71yclZpFmZyR6QoQD+IEeY0GnbPGlbeJblIQKS38",
    "cMBbo0vSWT5KPAD/AO566atN8gbaNZvOqAp6eaJ6lHl5BKVOLu2b0BUGQ/3jqLvmhucu1m2ltQLDUTQrA074K08THhLtn3jjiOOrEY886zPft5bnvEdV2cVt",
    "dR1dhs8jUdTPTIVFwWKZvez9liEQgcj3MvkRoIlRuOS8T1l6p6aolqrpJ3qPLGVihi5mJWY44j4mdgucvIw0NlkhoaaT9txE5kqJ5Dgu2ObMfLl0HQDAGoYq",
    "wZpamnMnsxAjhUyMwk5+8OInA8hjy5+Y0FulaaicRxsrLxHu1IyHdTzY/gU/m2NB9qppamqDqSh95OIfuQf7QjzkI90H3R9cx55EhiEcfJRnqcknzJPmT66b",
    "kkSBCodmYklnY+J2PUnQurqsk5Og81k7knhYfXQipqXyQca9VdUOeDoRU1AOeeg9VNTk4J0OmmGdN1MpLEg6hTSEdToj9XarcL1F4qbLY6QVtZSFRVzSNwU9",
    "KzLxKrNzLOVIbgUE4IJK5GQF8pZLnd1t0cq3m7RkPJNPHmhtQ6h+691pcHKqxZuhJVes7Y0D2trxBWTJJPBPF7VMOQklMCSyyfVpG+QAHlqqLtam3EafdFwu",
    "Vyt9ZXIlURZ5PYHCsAVSSSPxyYXhBLHy8umip9NUWzb96vck0800gaCigXiElTVukZmlc5wD4pwGY8KLwgZUADQDfc123BtKvprXVQVV2q6apSlo7e4nSiVI",
    "iXkYj97P4kRcgKHkXhHIsbXDTWegNXPHBBE0572qqJfE8hUDxOzZJwFB9OWeuntr0sstmuO7qmPup7jAXhRlw8dKisYVP4iCZD8Xx9kaDG3ZR240fZPtwbZv",
    "dnudxutPIZhPS1IppKZ5DxyQycanjIY+IMCA2eWQSS1f+kbO14bdl1sdbWUNzpYqIfqq5ilKrE7uYJH7svGxMnEwQrx4Ug8PIc07ZoqHcvavuu1q0cN7jukv",
    "scznArOgMDk9HBB4GPXmp+zid+id2ZV+++0CpguMEibctyg3pJI+U3i8FPzHJmZeowVCsQQcaCz339IrcO5aQ2TaVks2x9sUgM1UyoKhgPvMCAsjk9EKnibq",
    "eRI5ZXXWt7R9+m43iW5XGGCIZR5mnq6lFICRLjrJIxC+EALnkAq6/Reh2hsaxURlp9r7attLTplpBb4UVFA6livkPMnXuJaeopZaxaSOzWSJC7yJTiGepQD0",
    "UBo4z6e+34QeYZE7M/0ct0bs3DDuXf0y2WGepHc22BVeofgxhMHKRRIoAOeIgALw51rrs62/tzbdvqrtarbDRUC94tMyrmWZS2ZJmc+J3lcA5J5hY/lr49PU",
    "VHdUfB7HW3NO67tMD2ChTHGoxyDYIUkfbceSDR+SSGor47dTxBaO3KjuqjC95j9nGB6KMOf4NBE3Veotn7GvG5a8oJ4YHqpQTnx4ARPjjwqB5/M6xXPVVFY9",
    "RDUlhLUSGe6SqcZdufcLj0GAcdBnzbXWf0qt8S3DcNJsS2ygpQFK25MOaicjMKN6hAe8I82aL0OuOSzJBSiOMYVQeZOST1JJ8yTzJ9Tqhi9V/hMakpGo8XAO",
    "YHQKvxPQaGLIYlZ5MCRwAVHRFHRB8B/M5Oo7zGSVpnI7tCSpP2m82+QHIfU6GVNe03/Cr3g/5jHCD/U/T89QS6yq5kk6CVlcGyEPF8un56brJGI/avx/DGF/",
    "L+uhdTPqK91FSTnnqDLPk9dMzzfHUR5CSOflpEOyyE556iTSZHM6+SPgddRpHOqP/9k="
})
function MVPUI.getAnimeAsset()
    if MVPUI._animeAsset then return MVPUI._animeAsset end
    local loader = getcustomasset or getsynasset
    if type(loader) ~= "function" or type(writefile) ~= "function" then return nil end
    local exists = false
    if type(isfile) == "function" then
        local ok, r = pcall(isfile, MVPUI.ANIME_FILE)
        exists = ok and r == true
    end
    if not exists then
        local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
        local map = {}
        for i = 1, 64 do map[alphabet:byte(i)] = i - 1 end
        local out, buf, bits = {}, 0, 0
        local src = MVPUI.ANIME_B64
        for i = 1, #src do
            local v = map[src:byte(i)]
            if v then
                buf = buf * 64 + v
                bits = bits + 6
                if bits >= 8 then
                    bits = bits - 8
                    local div = 2 ^ bits
                    out[#out + 1] = string.char(math.floor(buf / div))
                    buf = buf % div
                end
            end
        end
        if not pcall(writefile, MVPUI.ANIME_FILE, table.concat(out)) then return nil end
    end
    local ok, asset = pcall(loader, MVPUI.ANIME_FILE)
    if ok and type(asset) == "string" and asset ~= "" then
        MVPUI._animeAsset = asset
        return asset
    end
    return nil
end
function MVPUI.pumpkin(parent, position, size, z)
    -- (nama fungsi lama dipertahankan) sekarang menampilkan foto Sasuke seperti di intro
    local root = MVPUI.new("Frame", parent, {Name = "Pumpkin", Size = UDim2.fromOffset(size, size),
        Position = position, BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0,
        BorderSizePixel = 0, ZIndex = z, Active = false})
    MVPUI.round(root, math.floor(size * 0.22))
    return root
end
function MVPUI.web(parent, position, size, z)
    local root = MVPUI.new("Frame", parent, {Name = "Web", Position = position,
        Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1, ZIndex = z})
    local function line(x1, y1, x2, y2)
        local dx, dy = x2 - x1, y2 - y1
        MVPUI.new("Frame", root, {Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy), 1),
            Position = UDim2.fromOffset((x1 + x2) / 2, (y1 + y2) / 2), AnchorPoint = Vector2.new(0.5, 0.5),
            Rotation = math.deg(math.atan2(dy, dx)), BackgroundColor3 = Color3.fromRGB(220, 174, 128),
            BackgroundTransparency = 0.84, BorderSizePixel = 0, ZIndex = z})
    end
    for i = 0, 4 do
        local a = math.pi * i / 8
        line(0, 0, math.cos(a) * size, math.sin(a) * size)
    end
    for ring = 1, 3 do
        local r = size * ring / 3
        for i = 0, 3 do
            local a, b = math.pi * i / 8, math.pi * (i + 1) / 8
            line(math.cos(a) * r, math.sin(a) * r, math.cos(b) * r, math.sin(b) * r)
        end
    end
    return root
end
function MVPUI.sectionIcon(parent, name, position, size, color, z)
    local root = MVPUI.new("Frame", parent, {Name = "SectionIcon", Position = position,
        Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1, ZIndex = z})
    local function line(x1, y1, x2, y2, thickness)
        local dx, dy = x2 - x1, y2 - y1
        local ink = MVPUI.new("Frame", root, {Name = "IconInk", AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale((x1 + x2) / 2, (y1 + y2) / 2),
            Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy) * size, thickness or 1.6),
            BackgroundColor3 = color, BorderSizePixel = 0, Rotation = math.deg(math.atan2(dy, dx)), ZIndex = z})
        MVPUI.round(ink, 2)
    end
    local function box(x, y, w, h, radius, solid)
        local object = MVPUI.new("Frame", root, {Name = "IconInk", Position = UDim2.fromScale(x, y),
            Size = UDim2.fromScale(w, h), BackgroundColor3 = color, BackgroundTransparency = solid and 0 or 1,
            BorderSizePixel = 0, ZIndex = z})
        MVPUI.round(object, radius)
        if not solid then MVPUI.stroke(object, color, 0, 1.4) end
        return object
    end
    if name == "Speed" then
        line(0.18, 0.22, 0.44, 0.5); line(0.44, 0.5, 0.18, 0.78)
        line(0.52, 0.22, 0.79, 0.5); line(0.79, 0.5, 0.52, 0.78)
    elseif name == "Custom" then
        line(0.5, 0.1, 0.83, 0.24); line(0.83, 0.24, 0.78, 0.62)
        line(0.78, 0.62, 0.5, 0.88); line(0.5, 0.88, 0.22, 0.62)
        line(0.22, 0.62, 0.17, 0.24); line(0.17, 0.24, 0.5, 0.1)
        line(0.36, 0.47, 0.47, 0.58); line(0.47, 0.58, 0.66, 0.37)
    elseif name == "Visual" then
        box(0.15, 0.15, 0.27, 0.27, 2, false)
        box(0.58, 0.15, 0.27, 0.27, 2, true)
        box(0.15, 0.58, 0.27, 0.27, 2, true)
        box(0.58, 0.58, 0.27, 0.27, 2, false)
    elseif name == "Settings" then
        line(0.5, 0.13, 0.82, 0.3); line(0.82, 0.3, 0.82, 0.77)
        line(0.82, 0.77, 0.18, 0.77); line(0.18, 0.77, 0.18, 0.3)
        line(0.18, 0.3, 0.5, 0.13); line(0.18, 0.3, 0.82, 0.3)
        line(0.5, 0.39, 0.5, 0.67); line(0.37, 0.54, 0.5, 0.67); line(0.63, 0.54, 0.5, 0.67)
    elseif name == "Keybinds" then
        box(0.08, 0.22, 0.84, 0.56, 3, false)
        box(0.2, 0.37, 0.12, 0.12, 1, true)
        box(0.44, 0.37, 0.12, 0.12, 1, true)
        box(0.68, 0.37, 0.12, 0.12, 1, true)
        line(0.29, 0.64, 0.71, 0.64)
    end
    return root
end
function MVPUI.colorSectionIcon(root, color)
    if not root then return end
    for _, object in ipairs(root:GetDescendants()) do
        if object:IsA("Frame") and object.Name == "IconInk" then object.BackgroundColor3 = color end
        if object:IsA("UIStroke") then object.Color = color end
    end
end

function MVPUI.fit()
    if not mainUIScale or not main or not main.Parent then return end
    local cam = Workspace.CurrentCamera
    if not cam then return end
    local viewport = cam.ViewportSize
    local width = 390
    local scale = math.max(0.25, math.min(uiScaleValue / 100 * 0.85, (viewport.X - 24) / width, (viewport.Y - 24) / 430))
    local height = math.min(704, math.floor((viewport.Y - 24) / scale))
    mainUIScale.Scale = scale
    MVPUI.width, MVPUI.height = width, height
    main.Size = UDim2.fromOffset(width, height)
    local size = Vector2.new(width * mainUIScale.Scale, height * mainUIScale.Scale)
    local point = main.AbsolutePosition
    main.Position = UDim2.fromOffset(_clamp(point.X, 8, math.max(8, viewport.X - size.X - 8)),
        _clamp(point.Y, 8, math.max(8, viewport.Y - size.Y - 8)))
    if pbFrame and pbFrame.Parent and MVPUI.hudScale then
        local compact = viewport.X < 600 or viewport.X < viewport.Y * 1.18
        local right = main.Position.X.Offset + size.X + 14
        local room = viewport.X - right - 12
        local baseHudScale = compact and math.min(1, (viewport.X - 24) / 300) or math.clamp(room / 300, 0.65, 1)
        -- La escala base se calcula una sola vez: mover/redimensionar el panel no debe alterar el HUD.
        if MVPUI.hudBaseScale == nil then MVPUI.hudBaseScale = baseHudScale end
        baseHudScale = MVPUI.hudBaseScale
        local hudScale = math.clamp(baseHudScale * (stealHudScale or 1), 0.60, 1.35)
        MVPUI.hudScale.Scale = hudScale
        local hudWidth, hudHeight = 300 * hudScale, 52 * hudScale
        if not savedProgressBarPos and not MVPUI.hudPlaced then
            MVPUI.hudPlaced = true
            if compact then
                pbFrame.Position = UDim2.fromOffset((viewport.X - hudWidth) / 2,
                    math.min(viewport.Y - hudHeight - 12, main.Position.Y.Offset + size.Y + 14))
            else
                pbFrame.Position = UDim2.fromOffset(viewport.X - hudWidth - 12, 16)
            end
        end
        -- Si hay posición guardada/elegida por el usuario, el HUD NO se toca.
    end

end
function MVPUI.effectsLoop(root)
    local state = MVPUI
    if state.effectConn then state.effectConn:Disconnect() end
    local accumulator, elapsed = 0, 0
    local connection
    connection = RunService.Heartbeat:Connect(function(dt)
        if not root.Parent or _mySession ~= _G.VisibleHubSession then
            connection:Disconnect()
            if state.effectConn == connection then state.effectConn = nil end
            return
        end
        accumulator = accumulator + dt
        elapsed = elapsed + dt
        if accumulator < 1 / 24 then return end
        accumulator = 0
        local panel = root:FindFirstChild("Main")
        if not state.effects or not panel or not panel.Visible then return end
        for i, item in ipairs(state.animated) do
            if item.object.Parent then
                item.object.Position = item.position + UDim2.fromOffset(math.sin(elapsed * 0.6 + i) * (item.x or 0),
                    math.sin(elapsed * 1.1 + i) * (item.y or 4))
                if item.rotate then item.object.Rotation = math.sin(elapsed * 0.7 + i) * item.rotate end
            end
        end
        if state.titleGradient and state.titleGradient.Parent then
            state.titleGradient.Offset = Vector2.new(math.sin(elapsed * 0.45) * 0.28, 0)
        end
    end)
    state.effectConn = connection
    root.Destroying:Connect(function()
        connection:Disconnect()
        if state.effectConn == connection then state.effectConn = nil end
        for _, tween in pairs(state.tweens) do pcall(function() tween:Cancel() end) end
        if state.backgroundTween then pcall(function() state.backgroundTween:Cancel() end) end
        state.animated, state.cards, state.tweens = {}, {}, {}
    end)
end

function paintFloatingBtn(button, active)
    if not button or not button.Parent then return end
    if _G.__VisibleBtnStyle then
        local ok = pcall(_G.__VisibleBtnStyle, button, active)
        if ok then return end
    end
    button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    local label = button:FindFirstChild("TextLabel")
    if label then label.TextColor3 = Color3.fromRGB(255, 255, 255) end
end
function applyFloatingButtonShapeTo(button)
    if not button then return end
    local spec0 = visibleBtnStyleSpec()
    local radius = spec0.radius
    if button:IsA("TextButton") then
        button.Size = UDim2.fromOffset(spec0.w or 68, spec0.h or 68)
    end
    local corner = button:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", button)
    corner.CornerRadius = UDim.new(0, spec0.radius or 16)
    for _, childName in ipairs({"StealBgImage", "ActiveTint"}) do
        local child = button:FindFirstChild(childName)
        if child then
            local childCorner = child:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", child)
            childCorner.CornerRadius = UDim.new(0, radius)
        end
    end
end

function applyFloatingButtonShape()
    if not MobilePanel then return end
    for _, button in ipairs(MobilePanel:GetChildren()) do
        if button:IsA("TextButton") then
            applyFloatingButtonShapeTo(button)
            pcall(paintFloatingBtn, button, button:GetAttribute("MobActive") == true)
        end
    end
end

-- Rejilla de 3 columnas del estilo 3 (igual que la imagen de referencia)
function arrangeStyle3Buttons()
    if not MobilePanel then return end
    local layout = {
        AutoBat = {0, 0}, TpDown = {0, 1}, Lagger1 = {0, 2},
        Carry = {1, 0}, DropBR = {1, 1}, Lagger2 = {1, 2},
        AutoRight = {2, 0}, AutoLeft = {2, 1}, InstantReset = {2, 2},
    }
    local cam = Workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(844, 390)
    local sp = visibleBtnStyleSpec()
    local cw, ch = (sp.w + 8) * floatingButtonScale, (sp.h + 8) * floatingButtonScale
    local startX = math.max(8, vp.X - cw * 3 - 12)
    local startY = math.max(70, vp.Y - ch * 4 - 40)
    savedButtonPositions = savedButtonPositions or {}
    for _, btn in ipairs(MobilePanel:GetChildren()) do
        local cell = btn:IsA("TextButton") and layout[btn.Name]
        if cell then
            local x = startX + cell[1] * cw
            local y = startY + cell[2] * ch + (cell[1] == 1 and 0 or 0)
            btn.Position = UDim2.fromOffset(x, y)
            savedButtonPositions[btn.Name] = {X = x, Y = y}
        end
    end
    pcall(saveAllSettings)
end

function setFloatingButtonStyle(id)
    id = tonumber(id)
    if id == 3 or id == 5 then id = 1 end
    if id ~= 1 and id ~= 2 then id = 1 end
    floatingButtonStyle = id
    applyFloatingButtonShape()
    pcall(saveAllSettings)
end

function setFloatingButtonShape(shape)
    if not FLOATING_BUTTON_SHAPE_LABELS[shape] then shape = "rounded" end
    floatingButtonShape = shape
    applyFloatingButtonShape()
end

function applyFloatingButtonScale()
    for _, uiScale in ipairs(_floatingUIScales) do
        if uiScale and uiScale.Parent then
            uiScale.Scale = floatingButtonScale
            -- (sin clamp: los botones pueden quedar fuera de la pantalla)
        end
    end
end

local function drag(f, dragZoneHeight)
    local dn, ds, sp, di = false, nil, nil, nil
    local endConn = nil
    local zone = dragZoneHeight or 99999
    local function stopDrag()
        local wasDragging = dn
        dn = false
        di = nil
        if endConn then
            endConn:Disconnect()
            endConn = nil
        end
        if wasDragging then
            if f == pbFrame then
                local p = f.Position
                savedProgressBarPos = {XScale = p.X.Scale, XOffset = p.X.Offset, YScale = p.Y.Scale, YOffset = p.Y.Offset}
            end
            task.defer(function() pcall(saveAllSettings) end)
        end
    end
    f.InputBegan:Connect(function(i)
        if uiLocked then return end
        if _isDraggingButton then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            local framePos = f.AbsolutePosition
            if i.Position.Y > framePos.Y + zone then return end
            dn = true; ds = i.Position; sp = f.Position
            if endConn then endConn:Disconnect() end
            endConn = i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then stopDrag() end
            end)
        end
    end)
    f.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            stopDrag()
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            stopDrag()
        end
    end)
    f.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end
    end)
    UIS.InputChanged:Connect(function(i)
        if i == di and dn then
            if uiLocked then stopDrag(); return end
            if _isDraggingButton then return end
            if not ds or not sp then return end
            local nX = sp.X.Offset + (i.Position.X - ds.X)
            local nY = sp.Y.Offset + (i.Position.Y - ds.Y)
            f.Position = UDim2.new(sp.X.Scale, nX, sp.Y.Scale, nY)
        end
    end)
end

_G.__VisibleHubSpeedEngine = _G.__VisibleHubSpeedEngine or {}
do
    local function blocked(hum)
        return not hum or hum.Health <= 0 or _isRagdollState(hum) or autoBatEnabled
            or autoLeftEnabled or autoRightEnabled or dropActive or _G.IsDropping
            or TPBatState.enabled or (_G.__VisibleHubIsBatV2 and _G.__VisibleHubIsBatV2())
            or ((_G.__VisibleAimbotIsOn and _G.__VisibleAimbotIsOn()) or (_G.__VisibleLagIsOn and _G.__VisibleLagIsOn()))
    end
    local function applyNow()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root or blocked(hum) then lastMoveDir = _V3zero; return end
        if useVenixCarryEngine then return end
        if _s2VelState.root ~= root then _hookVelHRP(_setupVelChecked(char)) end
        local direction = hum.MoveDirection
        if direction.Magnitude > 0 then lastMoveDir = direction
        else
            direction = nil
            if lastMoveDir.Magnitude > 0 then
                for key in pairs(MOVE_KEYS) do
                    if UIS:IsKeyDown(key) then direction = lastMoveDir; break end
                end
            end
        end
        _applyVelocitySpeed(direction, getActiveMoveSpeed(), root)
    end
    local function stop()
        if _G.__VisibleHubSpeedEngine.conn then _G.__VisibleHubSpeedEngine.conn:Disconnect(); _G.__VisibleHubSpeedEngine.conn = nil end
        MVPVenixCarry:stop()
        lastMoveDir = _V3zero
    end
    local function start()
        stop()
        if useVenixCarryEngine then MVPVenixCarry:start() end
        _G.__VisibleHubSpeedEngine.conn = RunService.RenderStepped:Connect(function()
            if _mySession ~= _G.VisibleHubSession then stop(); return end
            applyNow()
        end)
    end
    _G.__VisibleHubRefreshSpeedEngine = start
    _G.__VisibleHubStopSpeedEngine = stop
    _G.__VisibleHubApplySpeedNow = applyNow
    pcall(start)
    LP.CharacterRemoving:Connect(function() stop(); _s2VelState.root = nil end)
    LP.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if _mySession ~= _G.VisibleHubSession then return end
        _hookVelHRP(_setupVelChecked(char))
        start()
    end)
end

function setupMovementAndIndicators(char)
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end

    local ccAcc = 0
    steppedConn = RunService.Heartbeat:Connect(function(dt)
        ccAcc = ccAcc + dt
        if ccAcc < 0.05 then return end
        ccAcc = 0
        local plist = _GetPlayersCached()
        for i = 1, #plist do
            local p = plist[i]
            if p ~= LP then
                local ch = p.Character
                if ch then
                    local parts = ch:GetChildren()
                    for j = 1, #parts do
                        local part = parts[j]
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end
    end)

    local frameCount, lastStats, statAccumulator = 0, _tick(), 0
    movementLoop = RunService.RenderStepped:Connect(function(dt)
        frameCount = frameCount + 1
        statAccumulator = statAccumulator + dt
        if statAccumulator >= 0.5 then
            local now = _tick()
            local fps = _floor(frameCount / math.max(now - lastStats, 0.01) + 0.5)
            frameCount, statAccumulator, lastStats = 0, 0, now
            local ping
            pcall(function() ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() end)
            if type(ping) ~= "number" then pcall(function() ping = LP:GetNetworkPing() * 1000 end) end
            local pingText = type(ping) == "number" and tostring(_floor(ping + 0.5)) or "--"
            stealHud.statsText = tostring(fps) .. " FPS  ·  PING: " .. pingText .. " MS"
            if stealHud.stats and stealHud.stats.Parent then stealHud.stats.Text = stealHud.statsText end
            if stealHud.mode and stealHud.mode.Parent then stealHud.mode.Text = autoStealMode end
            if stealHud.radius and stealHud.radius.Parent then stealHud.radius.Text = "Radius: " .. tostring(CONFIG.STEAL_RANGE) end
            if stealHud.toggle and stealHud.toggle.Parent then stealHud.toggle.Text = CONFIG.AUTO_STEAL_ENABLED and "ON" or "OFF" end
            if MVPUI.footerStats and MVPUI.footerStats.Parent then MVPUI.footerStats.Text = stealHud.statsText end
        end
        local char2 = LP.Character
        if not char2 then return end
        local hum = char2:FindFirstChildOfClass("Humanoid")
        local hrp = char2:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled then
            if _isRagdollState(hum) then
                lastMoveDir = _V3zero
            else
                local md = hum.MoveDirection
                if md.Magnitude > 0 then
                    lastMoveDir = md
                end
            end
        end
    end)
    pcall(setupSpeedIndicator, char)
    pcall(startEnemySpeed)
end

function toggleLockUI(state)
    if state == nil then uiLocked = not uiLocked else uiLocked = state end
    if setLockUIVisual then setLockUIVisual(uiLocked) end
end

function disableAllAimbots()
    if autoBatEnabled then
        disableAutoBat()
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
    end
end

function stopAllBackgroundTasks()
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    stopEnemySpeed()
    if stretchEnabled then disableStretch() end
    if stretchConn then stretchConn:Disconnect(); stretchConn = nil end
    if stretchFovConn then stretchFovConn:Disconnect(); stretchFovConn = nil end
    if AntiRagdollV1.isRunning() then AntiRagdollV1.stop() end
    if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
    if antiDieEnabled then AntiDieModule.stop() end
    if antiBatEnabled then stopAntiBat() end
    if antiFlingEnabled then stopAntiFling() end
    if stopAutoTPDown then stopAutoTPDown() end
    stopBatCounter()
    if stopBatCounterV2 then stopBatCounterV2() end
    stopMedusaCounter()
    stopAutoSteal()
    disableAutoBat()
    stopAutoLeft()
    stopAutoRight()
    if _G.__VisibleHubStopBatV2 then pcall(_G.__VisibleHubStopBatV2) end
    if _G.__VisibleLagStop then pcall(_G.__VisibleLagStop) end
    if TPBatState and TPBatState.enabled and tpBatSetEnabled then pcall(tpBatSetEnabled, false) end
    if unwalkEnabled then stopUnwalk() end
    if antiLagEnabled then disableAntiLag() end
    if espEnabled then toggleESP(false) end
    if espLineEnabled then stopESPLine() end
    if dropActive then stopDropBrainrot() end
    if bodyLockEnabled then stopBodyLock() end
    _blSuppressCount = 0
    _blWasEnabled = false
    if _blRestoreTimer then pcall(task.cancel, _blRestoreTimer); _blRestoreTimer = nil end
    if _bodyLockConn then _bodyLockConn:Disconnect(); _bodyLockConn = nil end
    for _, t in ipairs(dropConnections) do
        if type(t) == "thread" then pcall(task.cancel, t)
        elseif type(t) == "RBXScriptConnection" then pcall(t.Disconnect, t) end
    end
    dropConnections = {}
    dropActive = false
    alPhase = 1
    arPhase = 1
    lastDropTime = 0
    medusaDebounce = false
    medusaLastUsed = 0
    if _G.__VisibleHubStopSpeedEngine then pcall(_G.__VisibleHubStopSpeedEngine) end
end

local _visibleHubSaveState = {
    lastAt = 0,
    queued = false,
    writing = false,
    dirty = false,
    revision = 0,
    retryCount = 0,
}
local function resolveVisibleHubFileApi()
    local env = (type(getgenv) == "function" and getgenv()) or _G
    local synApi = rawget(env, "syn") or rawget(_G, "syn")
    local readCandidates = {rawget(env, "readfile"), synApi and synApi.readfile, rawget(_G, "readfile")}
    local writeCandidates = {rawget(env, "writefile"), synApi and synApi.writefile, rawget(_G, "writefile")}
    local readFn, writeFn
    for _, fn in ipairs(readCandidates) do if type(fn) == "function" then readFn = fn; break end end
    for _, fn in ipairs(writeCandidates) do if type(fn) == "function" then writeFn = fn; break end end
    return readFn, writeFn
end

local function visibleHubFileExists(path)
    local readFn = resolveVisibleHubFileApi()
    if not readFn then return false end
    local ok, data = pcall(readFn, path)
    return ok and type(data) == "string"
end

function buildConfigTable()
    -- Antes de guardar (NO durante load): reflejar estado real en PERSISTED_TOGGLES.
    -- Durante load no pisar togglePrefs del JSON; aún no se han arrancado las features.
    if not _isLoading and not _restoringToggles then
        local P = PERSISTED_TOGGLES
        if type(P) ~= "table" then P = {}; PERSISTED_TOGGLES = P end
        P["Bat Bypass"] = autoBatEnabled == true
        P["Auto Left"] = autoLeftEnabled == true
        P["Auto Right"] = autoRightEnabled == true
        P["Auto TP Down"] = autoTPDownEnabled == true
        P["Anti Bat"] = antiBatEnabled == true
        P["Anti Fling"] = antiFlingEnabled == true
        P["Anti Die"] = antiDieEnabled == true
        P["Unwalk"] = unwalkEnabled == true
        P["Medusa Counter"] = medusaCounterEnabled == true
        P["Bat Counter"] = batCounterEnabled == true
        P["Bat Counter V2"] = batCounterV2Enabled == true
        P["Infinite Jump"] = (InfiniteJump and InfiniteJump.enabled) == true
        P["Player ESP"] = espEnabled == true
        P["ESP Line"] = espLineEnabled == true
        P["Vivid Graphics"] = vividGraphicsEnabled == true
        P["Anti Lag"] = antiLagEnabled == true
        P["Medusa Steal Delay"] = medusaStealDelayEnabled ~= false
        P["Body Lock"] = bodyLockEnabled == true
        P["Lock UI"] = uiLocked == true
        P["Hide Button"] = hideButtonsEnabled == true
        P["Auto Steal"] = CONFIG and CONFIG.AUTO_STEAL_ENABLED == true
        if MVPVenixCarry then
            P["Auto Carry"] = MVPVenixCarry.softStealEnabled == true
        end
        if _G.__VisibleAimbotIsOn then
            P["Aimbot"] = _G.__VisibleAimbotIsOn() == true
        end
    end
    local config = {
        togglePrefs = PERSISTED_TOGGLES,
        normalSpeed = NS, carrySpeed = CS,
        laggerSpeed1 = LAGGER_SPEED, laggerSpeed2 = LAGGER_CARRY_SPEED,
        stealRadius = CONFIG.STEAL_RANGE,
        holdMin = CONFIG.HOLD_MIN, holdMax = CONFIG.HOLD_MAX, entryDelay = CONFIG.ENTRY_DELAY, cooldown = CONFIG.COOLDOWN, primeRange = CONFIG.PRIME_RANGE,
        antiRagdollMode = antiRagdollMode, antiDieEnabled = antiDieEnabled,
        antiBat = antiBatEnabled,
        antiFling = antiFlingEnabled,
        autoTPDown = autoTPDownEnabled, autoTPDownHeight = autoTPDownHeight,
        autoSteal = CONFIG.AUTO_STEAL_ENABLED,
        autoBat = autoBatEnabled, autoLeft = autoLeftEnabled, autoRight = autoRightEnabled,
        medusaCounter = medusaCounterEnabled, batCounter = batCounterEnabled,
        batCounterV2 = batCounterV2Enabled, unwalkEnabled = unwalkEnabled,
        laggerToggled = laggerToggled, laggerCarryToggled = laggerCarryToggled,
        carryMode = speedMode, batAimbotSpeed = BAT_AIMBOT_SPEED,
        aimbotVersion = aimbotVersion,
        aimbotV3Speed = _G.__VisibleAV3 and _G.__VisibleAV3.speed or 58,
        aimbotV1Speed = _G.VisibleAimbotV1 and _G.VisibleAimbotV1.speed or 60,
        batBypassVer = batBypassVersion,
        bypassV2Speed = _G.__VisibleBB and _G.__VisibleBB.speed or 60,
        bypassV2LaggerSpeed = _G.__VisibleBB and _G.__VisibleBB.laggerSpeed or 40,
        bypassV3Speed = _G.__VisibleBV3 and _G.__VisibleBV3.speed or 60,
        bypassV3LaggerSpeed = _G.__VisibleBV3 and _G.__VisibleBV3.laggerSpeed or 40,
        dropMode = dropMode, stretchEnabled = stretchEnabled, stretchFOV = stretchFOV,
        uiScale = uiScaleValue, animPreset = hyAnimPreset, animOn = hyAnimOn,
        espEnabled = espEnabled,
        espLineEnabled = espLineEnabled,
        vividGraphics = vividGraphicsEnabled,
        hideButtons = hideButtonsEnabled,
        skipIntro = skipIntroEnabled,
        customToolsEnabled = _G.AmbitiousCustomToolsEnabled == true,
        customSoundsEnabled = _G.AmbitiousCustomSoundsEnabled == true,
        customToolSkinBat = _G.AmbitiousCustomToolSkins and _G.AmbitiousCustomToolSkins.Bat or "Off",
        customToolSkinMedusa = _G.AmbitiousCustomToolSkins and _G.AmbitiousCustomToolSkins.Medusa or "Off",
        customSoundBat = _G.VisibleSoundChoice and _G.VisibleSoundChoice.Bat or "Off",
        customSoundMedusa = _G.VisibleSoundChoice and _G.VisibleSoundChoice.Medusa or "Off",
        antiLag = antiLagEnabled,
        skyTheme = skyTheme, mobileButtonPositions = savedButtonPositions,
        dropBrainrotKey = {kb = KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name, gp = KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name},
        autoLeftKey = {kb = KB.AutoLeft.kb and KB.AutoLeft.kb.Name, gp = KB.AutoLeft.gp and KB.AutoLeft.gp.Name},
        autoRightKey = {kb = KB.AutoRight.kb and KB.AutoRight.kb.Name, gp = KB.AutoRight.gp and KB.AutoRight.gp.Name},
        autoBatKey = {kb = KB.AutoBat.kb and KB.AutoBat.kb.Name, gp = KB.AutoBat.gp and KB.AutoBat.gp.Name},
        tpFloorKey = {kb = KB.TPFloor.kb and KB.TPFloor.kb.Name, gp = KB.TPFloor.gp and KB.TPFloor.gp.Name},
        guiHideKey = {kb = KB.GuiHide.kb and KB.GuiHide.kb.Name, gp = KB.GuiHide.gp and KB.GuiHide.gp.Name},
        carryToggleKey = {kb = KB.CarryToggle.kb and KB.CarryToggle.kb.Name, gp = KB.CarryToggle.gp and KB.CarryToggle.gp.Name},
        laggerModeKey = {kb = KB.LaggerMode.kb and KB.LaggerMode.kb.Name, gp = KB.LaggerMode.gp and KB.LaggerMode.gp.Name},
        batV2Key = {kb = KB.BatV2.kb and KB.BatV2.kb.Name, gp = KB.BatV2.gp and KB.BatV2.gp.Name},
        aimbotV2Key = {kb = KB.AimbotV2.kb and KB.AimbotV2.kb.Name, gp = KB.AimbotV2.gp and KB.AimbotV2.gp.Name},
        bxSpeed = _G.VisibleAimbotLagger and _G.VisibleAimbotLagger.speed or tonumber(_G.__VisibleLagPendingSpeed) or 58,
        bxLaggerSpeed = _G.VisibleAimbotLagger and _G.VisibleAimbotLagger.laggerSpeed or tonumber(_G.__VisibleLagPendingLagger) or 40,
        bodyLockEnabled = bodyLockEnabled, bodyLockRange = bodyLockRange,
        aimbotOn = (_G.__VisibleAimbotIsOn and _G.__VisibleAimbotIsOn()) and true or false,
        av2 = _G.VisibleAimbotV2 and {
            mode = _G.VisibleAimbotV2.mode, speed = _G.VisibleAimbotV2.speed, laggerSpeed = _G.VisibleAimbotV2.laggerSpeed,
            abSpeed = _G.VisibleAimbotV2.abSpeed, abLaggerSpeed = _G.VisibleAimbotV2.abLaggerSpeed,
            autoSwing = _G.VisibleAimbotV2.autoSwing,
        } or nil,
        progressBarPos = savedProgressBarPos, lockUI = uiLocked,
        backgroundIndex = backgroundIndex,
        backgroundImageTransparency = backgroundImageTransparency,
        backgroundMode = backgroundMode, instantResetVersion = _G.__VisibleInstantResetVersion, floatingButtonScale = floatingButtonScale,
        floatingButtonShape = floatingButtonShape,
        floatingButtonStyle = floatingButtonStyle,
        spinSpeed = spinSpeed,
        speedButtonScale = speedButtonScale,
        stealHudScale = stealHudScale,
        backgroundEnabled = VISIBLE_BG,
        stealBgIndex = stealBgIndex, stealBgTransparency = stealBgImageTransparency,
        outfitIndex = currentOutfitIndex, vx7AvatarIndex = VX7A.index, themeColor = currentColorTheme,
        rivalTitleTheme = currentRivalTitleTheme,
        infiniteJumpEnabled = InfiniteJump.enabled == true,
        infiniteJumpMode = InfiniteJump.mode == "manual" and "manual" or "hold",
        autoStealMode = autoStealMode,
        useVenixCarryEngine = useVenixCarryEngine,
        softCarry = MVPVenixCarry.softStealEnabled,
        softCarrySpeed = MVPVenixCarry.softStealSpeed,
        softCarryRadius = MVPVenixCarry.softStealRadius,
        uiEffects = MVPUI.effects,
        mobileButtonsLocked = mobileButtonsLocked,
        batV2 = _G.__VisibleHubIsBatV2 and _G.__VisibleHubIsBatV2() or false,
    }
    if main then
        -- Guardar siempre la posición actual; no usar una posición inicial
        -- que pueda sobrescribir el movimiento realizado por el usuario.
        local basePos = main.Position
        config.mainPosition = {
            XScale = basePos.X.Scale,
            XOffset = basePos.X.Offset,
            YScale = basePos.Y.Scale,
            YOffset = basePos.Y.Offset,
        }
    end
    -- progressBarPos ya viene de savedProgressBarPos (se fija al soltar el HUD).
    if MobilePanel then
        config.mobilePanelPos = {XScale = 0, XOffset = 10, YScale = 0, YOffset = 0}
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") then
                savedButtonPositions[btn.Name] = {X = btn.Position.X.Offset, Y = btn.Position.Y.Offset}
            end
        end
        config.mobileButtonPositions = savedButtonPositions
    end
    return config
end

local function scheduleVisibleHubSave(delaySeconds)
    if _visibleHubSaveState.queued then return end
    _visibleHubSaveState.queued = true
    task.delay(delaySeconds or 0.25, function()
        _visibleHubSaveState.queued = false
        if _G.VisibleHubRunning and not _isResetting and not _isLoading then
            pcall(saveAllSettings, true)
        end
    end)
end

function saveAllSettings(force)
    -- Sistema de Clean: un solo JSON, escritura directa y sin una segunda
    -- fuente de verdad para los toggles.
    -- force=true permite guardar aunque estemos en bootstrap/loading (cierre, reset, etc.)
    if not force and (_isResetting or _isLoading or _isBootstrapping) then return true end
    if _restoringToggles then return true end
    local config = buildConfigTable()
    local okEncode, json = pcall(function() return HS:JSONEncode(config) end)
    if not okEncode then return false end
    if (not force) and json == _lastSavedJSON then return true end
    local _, writeFn = resolveVisibleHubFileApi()
    if not writeFn then
        warn("[Visible] writefile no disponible; no se pudo guardar VisibleHub.json")
        return false
    end
    local okWrite = pcall(writeFn, CONFIG_FILE, json)
    if okWrite then
        _lastSavedJSON = json
    else
        warn("[Visible] Fallo al escribir " .. tostring(CONFIG_FILE))
    end
    return okWrite
end

task.spawn(function()
    task.wait(5)
    while _G.VisibleHubRunning do
        task.wait(5)
        if gui and main and not _isLoading then pcall(saveAllSettings) end
    end
end)
pcall(function()
    game:BindToClose(function()
        pcall(saveAllSettings, true)
    end)
end)

do
    local readFn, writeFn = resolveVisibleHubFileApi()
    if readFn and writeFn then
        local legacyPaths = {"MVP.json"}

        local okNew, _ = pcall(readFn, CONFIG_FILE)
        if not okNew then
            for _, oldPath in ipairs(legacyPaths) do
                local okOld, old = pcall(readFn, oldPath)
                if okOld and type(old) == "string" and #old > 0 then
                    pcall(writeFn, CONFIG_FILE, old)
                    warn("[Visible] Config migrada de " .. oldPath .. " a " .. CONFIG_FILE)
                    break
                end
            end
        end
    end
end

function _visibleLoadSettingsInner()
    local readFn = resolveVisibleHubFileApi()
    if not readFn or not visibleHubFileExists(CONFIG_FILE) then return false end
    local success, data = pcall(function() return HS:JSONDecode(readFn(CONFIG_FILE)) end)
    if not success or type(data) ~= "table" then return false end
    _isLoading = true

    if type(data.togglePrefs) == "table" then
        PERSISTED_TOGGLES = data.togglePrefs
    else
        -- Migración de configuraciones antiguas que no tenían togglePrefs.
        PERSISTED_TOGGLES = {
            ["Auto Steal"] = data.autoSteal == true,
            ["Bat Bypass"] = data.autoBat == true or data.batV2 == true,
            ["Auto Bat"] = data.autoBat == true, -- legacy alias
            ["Auto Left"] = data.autoLeft == true,
            ["Auto Right"] = data.autoRight == true,
            ["Anti Die"] = data.antiDieEnabled == true,
            ["Anti Bat"] = data.antiBat == true,
            ["Anti Fling"] = data.antiFling == true,
            ["Auto TP Down"] = data.autoTPDown == true,
            ["Medusa Counter"] = data.medusaCounter == true,
            ["Bat Counter"] = data.batCounter == true,
            ["Bat Counter V2"] = data.batCounterV2 == true,
            ["Unwalk"] = data.unwalkEnabled == true,
            ["Anti Lag"] = data.antiLag == true,
            ["Medusa Steal Delay"] = data.medusaStealDelay ~= false,
            ["Player ESP"] = data.espEnabled == true,
            ["ESP Line"] = data.espLineEnabled == true,
            ["Vivid Graphics"] = data.vividGraphics == true,
            ["Hide Button"] = data.hideButtons == true,
            ["Infinite Jump"] = data.infiniteJumpEnabled == true,
            ["Body Lock"] = data.bodyLockEnabled == true,
            ["Lock UI"] = data.lockUI == true,
        }
    end

    local function num(v, fallback)
        local n = tonumber(v)
        if n == nil or n ~= n or n == math.huge or n == -math.huge then
            return fallback
        end
        return n
    end
    local function boolOr(v, fallback)
        if v == nil then return fallback end
        return v == true
    end

    NS                  = num(data.normalSpeed,       NS)
    CS                  = num(data.carrySpeed,        CS)
    LAGGER_SPEED        = num(data.laggerSpeed1,      LAGGER_SPEED)
    LAGGER_CARRY_SPEED  = num(data.laggerSpeed2,      LAGGER_CARRY_SPEED)
    CONFIG.STEAL_RANGE  = num(data.stealRadius,       CONFIG.STEAL_RANGE)
    CONFIG.HOLD_MIN     = num(data.holdMin,           CONFIG.HOLD_MIN)
    CONFIG.HOLD_MAX     = num(data.holdMax,           CONFIG.HOLD_MAX)
    CONFIG.ENTRY_DELAY  = num(data.entryDelay,        CONFIG.ENTRY_DELAY)
    CONFIG.COOLDOWN     = num(data.cooldown,          CONFIG.COOLDOWN)
    CONFIG.PRIME_RANGE  = num(data.primeRange,        CONFIG.PRIME_RANGE)

    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end

    if num(data.configVersion, 1) >= 2 and data.lockUI ~= nil then
        uiLocked = boolOr(data.lockUI, false)
    else
        uiLocked = false
    end
    mobileButtonsLocked = false
    -- Restaurar también los ajustes visuales que antes no se aplicaban al cargar.
    if data.backgroundEnabled ~= nil then
        VISIBLE_BG = boolOr(data.backgroundEnabled, true)
    end
    stealBgImageTransparency = _clamp(num(data.stealBgTransparency, stealBgImageTransparency), 0, 1)

    if data.antiRagdollMode then
        antiRagdollMode = tostring(data.antiRagdollMode)
    else
        antiRagdollMode = data.antiRagdoll and "v2" or "off"
    end
    antiDieEnabled = boolOr(data.antiDieEnabled, false)
    antiBatEnabled = boolOr(data.antiBat, false)
    antiFlingEnabled = boolOr(data.antiFling, false)
    autoTPDownEnabled = boolOr(data.autoTPDown, false)
    CONFIG.AUTO_STEAL_ENABLED = boolOr(data.autoSteal, false)
    autoBatEnabled = boolOr(data.autoBat, false)
    autoLeftEnabled = boolOr(data.autoLeft, false)
    autoRightEnabled = boolOr(data.autoRight, false)
    setAutoStealMode(data.autoStealMode or "90")
    useVenixCarryEngine = boolOr(data.useVenixCarryEngine, false)
    MVPVenixCarry.softStealSpeed = _clamp(num(data.softCarrySpeed, 30), 1, 500)
    MVPVenixCarry.softStealRadius = _clamp(num(data.softCarryRadius, 10), 1, 200)
    MVPVenixCarry:setSoftStealEnabled(boolOr(data.softCarry, false))
    MVPUI.effects = boolOr(data.uiEffects, MVPUI.effects)
    mobileButtonsLocked = boolOr(data.mobileButtonsLocked, false)
    if _G.__VisibleHubRefreshSpeedEngine then pcall(_G.__VisibleHubRefreshSpeedEngine) end
    InfiniteJump.mode = data.infiniteJumpMode == "manual" and "manual" or "hold"
    InfiniteJump.enabled = boolOr(data.infiniteJumpEnabled, false)
    medusaCounterEnabled = boolOr(data.medusaCounter, false)
    batCounterEnabled = boolOr(data.batCounter, false)
    batCounterV2Enabled = boolOr(data.batCounterV2, false)
    unwalkEnabled = boolOr(data.unwalkEnabled, boolOr(data.unwalk, false))
    antiLagEnabled = boolOr(data.antiLag, false)
    laggerToggled = boolOr(data.laggerToggled, false)
    speedMode = boolOr(data.carryMode, false)
    laggerCarryToggled = boolOr(data.laggerCarryToggled, false)
    uiScaleValue = _clamp(num(data.uiScale, 90), 50, 150)
    if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 * 0.85 end
    if pbScale then pbScale.Scale = uiScaleValue / 100 end
    espEnabled = boolOr(data.espEnabled, false)
    espLineEnabled = boolOr(data.espLineEnabled, false)
    if espEnabled then pcall(toggleESP, true) else pcall(toggleESP, false) end

    vividGraphicsEnabled = boolOr(data.vividGraphics, false)
    hideButtonsEnabled = boolOr(data.hideButtons, false)
    skipIntroEnabled = boolOr(data.skipIntro, false)
    do
        local ctOn = data.customToolsEnabled == true
        local sb, sm = data.customToolSkinBat, data.customToolSkinMedusa
        if not ctOn then sb, sm = "Off", "Off" end
        _G.AmbitiousCustomToolSkins = _G.AmbitiousCustomToolSkins or {}
        _G.AmbitiousCustomToolSkins.Bat = (sb == "Katana" and "Katana") or (sb == "DiamondSword" and "DiamondSword") or "Off"
        _G.AmbitiousCustomToolSkins.Medusa = (sm == "Skull" and "Skull") or (sm == "GoldenDesertEagle" and "GoldenDesertEagle") or "Off"
        _G.AmbitiousCustomToolsEnabled = (_G.AmbitiousCustomToolSkins.Bat ~= "Off") or (_G.AmbitiousCustomToolSkins.Medusa ~= "Off")
        local csOn = data.customSoundsEnabled == true
        _G.VisibleSoundChoice = {
            Bat = (csOn and data.customSoundBat ~= "Off") and "Katana Slash" or "Off",
            Medusa = (csOn and data.customSoundMedusa ~= "Off") and "Gunshot" or "Off",
        }
        _G.AmbitiousCustomSoundsEnabled = (_G.VisibleSoundChoice.Bat ~= "Off") or (_G.VisibleSoundChoice.Medusa ~= "Off")
    end

    TPBatState.enabled = false

    currentColorTheme = "Visible"
    selectedColor = Color3.fromRGB(255, 255, 255)
    task.defer(function() updateAllUIThemeColors(selectedColor) end)

    if data.rivalTitleTheme and RIVAL_TITLE_THEMES[data.rivalTitleTheme] then
        task.defer(function() applyRivalTitleTheme(data.rivalTitleTheme) end)
    end

    skyTheme = data.skyTheme or "Off"
    if skyTheme ~= "Off" then pcall(applyCustomSky, skyTheme) end
    if skySelectorLabel then skySelectorLabel.Text = skyTheme end
    if type(data.animPreset) == "string" and HY_ANIM_PRESETS[data.animPreset] then
        hyAnimPreset = data.animPreset
    else
        hyAnimPreset = HY_ANIM_NAMES[1]
    end
    _G.__VisibleAnimPreset = hyAnimPreset
    if hyAnimLabel then pcall(function() hyAnimLabel.Text = tostring(hyAnimPreset) end) end
    if data.animOn == true then
        task.spawn(function() task.wait(0.5); pcall(hyAnimSetOn, true) end)
    else
        if hyAnimOn then task.spawn(function() pcall(hyAnimSetOn, false) end) end
        hyAnimOn = false
        if hyAnimToggleSet then pcall(hyAnimToggleSet, false) end
    end
    local function lk(e, d)
        if not d then return end
        e.kb = d.kb and Enum.KeyCode[d.kb] or nil
        e.gp = d.gp and Enum.KeyCode[d.gp] or nil
    end
    lk(KB.DropBrainrot, data.dropBrainrotKey)
    lk(KB.AutoLeft, data.autoLeftKey)
    lk(KB.AutoRight, data.autoRightKey)
    lk(KB.AutoBat, data.autoBatKey)
    lk(KB.TPFloor, data.tpFloorKey)
    lk(KB.GuiHide, data.guiHideKey)
    lk(KB.CarryToggle, data.carryToggleKey)
    lk(KB.LaggerMode, data.laggerModeKey)
    lk(KB.BatV2, data.batV2Key)
    lk(KB.AimbotV2, data.aimbotV2Key)
    do
        local ls = tonumber(data.bxSpeed)
        local ll = tonumber(data.bxLaggerSpeed)
        if ls and ls > 0 and ls <= 250 then
            _G.__VisibleLagPendingSpeed = ls
            if _G.VisibleAimbotLagger then _G.VisibleAimbotLagger.speed = ls end
        end
        if ll and ll > 0 and ll <= 250 then
            _G.__VisibleLagPendingLagger = ll
            if _G.VisibleAimbotLagger then _G.VisibleAimbotLagger.laggerSpeed = ll end
        end
        if _G.__VisibleLagRefreshUI then pcall(_G.__VisibleLagRefreshUI) end
    end
    if data.mobileButtonPositions then savedButtonPositions = data.mobileButtonPositions end
    if data.mobilePanelPos then savedMobilePanelPos = data.mobilePanelPos end
    if data.mainPosition and main and type(data.mainPosition) == "table" then
        main.Position = UDim2.new(
            num(data.mainPosition.XScale, 0),
            num(data.mainPosition.XOffset, 20),
            num(data.mainPosition.YScale, 0),
            num(data.mainPosition.YOffset, 2)
        )
    end
    if data.progressBarPos and type(data.progressBarPos) == "table" then
        savedProgressBarPos = data.progressBarPos
    end
    if data.bodyLockEnabled ~= nil then
        bodyLockEnabled = boolOr(data.bodyLockEnabled, false)
        if bodyLockEnabled then
            task.defer(function()
                if bodyLockSetVisual then bodyLockSetVisual(true) end
                startBodyLock()
            end)
        end
    end
    if data.bodyLockRange ~= nil then
        bodyLockRange = _clamp(num(data.bodyLockRange, 20), 5, 200)
        if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    end
    if data.autoTPDownHeight ~= nil then
        autoTPDownHeight = _clamp(num(data.autoTPDownHeight, 20), 5, 100)
        if autoTPDownBox then autoTPDownBox.Text = tostring(autoTPDownHeight) end
    end
    dropMode = num(data.dropMode, 1)
    stretchEnabled = boolOr(data.stretchEnabled, false)
    stretchFOV = num(data.stretchFOV, 120)
    BAT_AIMBOT_SPEED = num(data.batAimbotSpeed, BAT_AIMBOT_SPEED)
    BYPASS_AIMBOT_SPEED = BAT_AIMBOT_SPEED
    if State then State.bypassBatSpeed = BYPASS_AIMBOT_SPEED end
    do
        local av = tonumber(data.aimbotVersion)
        aimbotVersion = (av == 3 and 3) or (av == 1 and 1) or 2
        local sp3 = num(data.aimbotV3Speed, 58)
        _G.__VisibleAV3Pending = {speed = sp3}
        if _G.__VisibleAV3 and sp3 > 0 then _G.__VisibleAV3.speed = sp3 end
        if _G.__VisibleAV3RefreshUI then pcall(_G.__VisibleAV3RefreshUI) end
    end
    do
        local bv = tonumber(data.batBypassVer)
        batBypassVersion = (bv == 3 and 3) or (bv == 2 and 2) or 1
        _G.__VisibleInstantResetVersion = (data.instantResetVersion == "V2") and "V2" or "V1"
    end
    if type(data.av2) == "table" then _G.__VisibleAV2Pending = data.av2 end
    _G.__VisibleAimbotPending = boolOr(data.aimbotOn, false)
    do
        local sp1 = num(data.aimbotV1Speed, 60)
        _G.__VisibleAV1Pending = {speed = sp1}
        if _G.VisibleAimbotV1 and sp1 > 0 then _G.VisibleAimbotV1.speed = sp1 end
        local sp2, sp2l = num(data.bypassV2Speed, 60), num(data.bypassV2LaggerSpeed, 40)
        _G.__VisibleBBPending = {speed = sp2, lagger = sp2l}
        if _G.__VisibleBB then
            if sp2 > 0 then _G.__VisibleBB.speed = sp2 end
            if sp2l > 0 then _G.__VisibleBB.laggerSpeed = sp2l end
        end
        local sp3, sp3l = num(data.bypassV3Speed, 60), num(data.bypassV3LaggerSpeed, 40)
        _G.__VisibleBV3Pending = {speed = sp3, lagger = sp3l}
        if _G.__VisibleBV3 then
            if sp3 > 0 then _G.__VisibleBV3.speed = sp3 end
            if sp3l > 0 then _G.__VisibleBV3.laggerSpeed = sp3l end
        end
        if _G.__VisibleBV3RefreshUI then pcall(_G.__VisibleBV3RefreshUI) end
        if _G.__VisibleAV1RefreshUI then pcall(_G.__VisibleAV1RefreshUI) end
        if _G.__VisibleBBRefreshUI then pcall(_G.__VisibleBBRefreshUI) end
        if _G.__VisibleAimbotVersionRefresh then pcall(_G.__VisibleAimbotVersionRefresh) end
        if _G.__VisibleBatVersionRefresh then pcall(_G.__VisibleBatVersionRefresh) end
    end

    backgroundIndex = _clamp(_floor(num(data.backgroundIndex, 1)), 1, #backgroundImages)
    backgroundImageTransparency = _clamp(num(data.backgroundImageTransparency, 0), 0, 1)

    if data.backgroundMode == "None" then
        backgroundMode = "None"
    else
        local savedN = nil
        if type(data.backgroundMode) == "string" then
            savedN = tonumber(string.match(data.backgroundMode, "^Background%s+(%d+)$"))
        end
        if type(savedN) == "number" and savedN >= 1 and savedN <= #backgroundImages then
            backgroundIndex = savedN
        end
        backgroundMode = "Background " .. backgroundIndex
    end

    floatingButtonScale = _clamp(num(data.floatingButtonScale, 1), 0.5, 2)
    -- Forma fija estilo VISIBLE; ignorar preferencias antiguas de forma.
    floatingButtonShape = "rounded"
    do
        local fs = tonumber(data.floatingButtonStyle)
        floatingButtonStyle = (fs == 1 or fs == 2) and fs or 1
        if MVPUI.buttonStyleLabel and MVPUI.buttonStyleLabel.Parent then
            for i, v in ipairs(FLOATING_BUTTON_STYLE_IDS) do
                if v == floatingButtonStyle then MVPUI.buttonStyleLabel.Text = FLOATING_BUTTON_STYLE_NAMES[i] end
            end
        end
    end
    spinSpeed = _clamp(num(data.spinSpeed, 32), 1, 200)
    speedButtonScale = _clamp(num(data.speedButtonScale, 1), 0.70, 1.40)
    stealHudScale = _clamp(num(data.stealHudScale, 1), 0.70, 1.35)
    -- v5: la imagen elegida se respeta (ya no se fuerza a Visual 1 al cargar)
    stealBgIndex = _clamp(_floor(num(data.stealBgIndex, stealBgIndex or 1)), 1, #STEAL_BG_IMAGES)
    do local _sbt = tonumber(data.stealBgTransparency); if _sbt then stealBgImageTransparency = _clamp(_sbt, 0, 1) end end
    task.defer(function()
        pcall(applyBackgroundMode, backgroundMode)
        pcall(applyStealBackground, stealBgIndex)
        pcall(applyFloatingButtonShape)
        pcall(applyFloatingButtonScale)
        if MVPUI.effectsSetter then pcall(MVPUI.effectsSetter, MVPUI.effects) end
    end)

    if type(data.outfitIndex) == "number"
       and type(OUTFITS) == "table"
       and #OUTFITS > 0
       and data.outfitIndex >= 1
       and data.outfitIndex <= #OUTFITS then
        currentOutfitIndex = data.outfitIndex
        task.defer(function()
            pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
            if outfitSelectorLabel and OUTFITS[currentOutfitIndex] then
                outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label
            end
        end)
    end

    if type(data.vx7AvatarIndex) == "number"
       and data.vx7AvatarIndex >= 1
       and data.vx7AvatarIndex <= #VX7A.labels - 1 then
        local _vx7Saved = data.vx7AvatarIndex
        task.defer(function()
            task.wait(1.5)
            pcall(VX7A.apply, _vx7Saved)
        end)
    end

    if vividGraphicsEnabled then
        task.defer(function() pcall(enableVividGraphics) end)
    else
        task.defer(function() pcall(disableVividGraphics) end)
    end
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    refreshSpeedModeLabel()

    -- Completar PERSISTED_TOGGLES SIN pisar valores ya guardados en togglePrefs.
    -- Solo rellena claves faltantes desde las variables individuales del JSON.
    do
        local P = PERSISTED_TOGGLES
        if type(P) ~= "table" then P = {}; PERSISTED_TOGGLES = P end
        local function fill(name, val)
            if P[name] == nil then
                P[name] = val == true
            end
        end
        fill("Bat Bypass", autoBatEnabled)
        fill("Auto Left", autoLeftEnabled)
        fill("Auto Right", autoRightEnabled)
        fill("Auto TP Down", autoTPDownEnabled)
        fill("Anti Bat", antiBatEnabled)
        fill("Anti Fling", antiFlingEnabled)
        fill("Anti Die", antiDieEnabled)
        fill("Unwalk", unwalkEnabled)
        fill("Medusa Counter", medusaCounterEnabled)
        fill("Bat Counter", batCounterEnabled)
        fill("Bat Counter V2", batCounterV2Enabled)
        fill("Infinite Jump", InfiniteJump.enabled == true)
        fill("Player ESP", espEnabled == true)
        fill("ESP Line", espLineEnabled == true)
        fill("Vivid Graphics", vividGraphicsEnabled == true)
        fill("Anti Lag", antiLagEnabled == true)
        fill("Medusa Steal Delay", medusaStealDelayEnabled ~= false)
        fill("Body Lock", bodyLockEnabled == true)
        fill("Lock UI", uiLocked == true)
        fill("Hide Button", hideButtonsEnabled == true)
        fill("Auto Steal", CONFIG.AUTO_STEAL_ENABLED == true)
        if MVPVenixCarry then
            fill("Auto Carry", MVPVenixCarry.softStealEnabled == true)
        end
        if P["Auto Bat"] == true and P["Bat Bypass"] ~= true then
            P["Bat Bypass"] = true
        end
        if data.aimbotOn == true then
            fill("Aimbot", true)
        end
    end

    _lastSavedJSON = HS:JSONEncode(buildConfigTable())
    _isLoading = false

    return true
end

function loadAllSettings()
    local ok, res = pcall(_visibleLoadSettingsInner)
    _isLoading = false   -- WAJIB: kalau tetap true, semua penyimpanan akan berhenti
    if not ok then
        warn("[Visible Load] error saat memuat setting: " .. tostring(res))
    end
    return ok and res == true
end

function forceResetUI()
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_CARRY_SPEED) end
    if batSpeedBox then batSpeedBox.Text = tostring(BYPASS_AIMBOT_SPEED) end
    if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    if autoTPDownBox then autoTPDownBox.Text = tostring(autoTPDownHeight) end
    local function safeSet(fn, val) if fn then fn(val) end end
    safeSet(autoBatSetVisual, false)
    safeSet(autoLeftSetVisual, false)
    safeSet(autoRightSetVisual, false)
    safeSet(setBatCounterVisual, false)
    safeSet(setBatCounterV2Visual, false)
    safeSet(setMedusaVisual, false)
    safeSet(setUnwalkVisual, false)
    safeSet(setAntiLagVisual, false)
    safeSet(setLockUIVisual, false)
    safeSet(setInstaGrab, false)
    safeSet(setESPVIsual, false)
    safeSet(setESPLineVisual, false)
    safeSet(setVividVisual, false)
    safeSet(setHideButtonsVisual, false)
    safeSet(setCustomToolsVisual, _G.AmbitiousCustomToolsEnabled == true)
    safeSet(setCustomSoundsVisual, _G.AmbitiousCustomSoundsEnabled == true)
    if setCustomSkinBatLabel then setCustomSkinBatLabel(_G.AmbitiousCustomToolSkins.Bat) end
    if setCustomSkinMedusaLabel then setCustomSkinMedusaLabel(_G.AmbitiousCustomToolSkins.Medusa) end
    pcall(visibleApplySkinFlags)
    safeSet(setSkipIntroVisual, false)
    safeSet(bodyLockSetVisual, false)
    safeSet(setAntiDieVisual, false)
    safeSet(setAntiBatVisual, false)
    safeSet(setAntiFlingVisual, false)
    safeSet(setAutoTPDownVisual, false)
    safeSet(setAntiRagVisual, false)
    safeSet(infJumpSetVisual, false)
    if autoStealModeBtn then autoStealModeBtn.Text = autoStealMode end
    if MVPUI.motorLabel then MVPUI.motorLabel.Text = "Direct" end
    if MVPUI.carrySetter then MVPUI.carrySetter(false) end
    if MVPUI.effectsSetter then MVPUI.effectsSetter(MVPUI.effects) end
    if MVPUI.lockButtonsSetter then MVPUI.lockButtonsSetter(false) end
    applyBackgroundMode(backgroundMode)
    pcall(applyStealBackground, stealBgIndex)
    if _G.__VisibleHubRefreshSpeedEngine then pcall(_G.__VisibleHubRefreshSpeedEngine) end
    safeSet(mobSetBatV2, false)
    if _G.__VisibleLagStop then pcall(_G.__VisibleLagStop) end
    if _G.__VisibleHubStopBatV2 then pcall(_G.__VisibleHubStopBatV2) end
    disableVividGraphics()
    applyHideButtons(false)
    if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    safeSet(mobSetAutoBat, false)
    safeSet(mobSetAutoLeft, false)
    safeSet(mobSetAutoRight, false)
    safeSet(mobSetDropBR, false)
    safeSet(mobSetTpDown, false)
    safeSet(mobSetCarry, false)
    safeSet(mobSetLagger1, false)
    safeSet(mobSetLagger2, false)
    refreshSpeedModeLabel()
    updateProgressBarVisibility()
    disableAntiLag()
    if stopAntiBat then stopAntiBat() end
    if stopAntiFling then stopAntiFling() end
    if stopESPLine then stopESPLine() end
    skyTheme = "Off"
    pcall(applyCustomSky, "Off")
    if skySelectorLabel then skySelectorLabel.Text = "Off" end
    if antiDieEnabled then
        AntiDieModule.stop()
        antiDieEnabled = false
    end
    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end
    currentColorTheme = "Visible"
    selectedColor = Color3.fromRGB(255, 255, 255)
    updateAllUIThemeColors(selectedColor)
    if miniBtn then
        local stroke = miniBtn:FindFirstChildOfClass("UIStroke")
        if stroke and not stroke:FindFirstChild("VisibleFlow") then stroke.Color = Color3.fromRGB(42, 43, 47) end
    end
    if MobilePanel then
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") then
                local label = btn:FindFirstChildOfClass("TextLabel")
                if label then
                    local isActive = btn.BackgroundColor3 == selectedColor
                    label.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    end
    saveAllSettings()
end

function resetFloatingPositions()
    if MobilePanel then
        savedButtonPositions = {}
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") and btn.Name then
                local defX, defY = getDefaultButtonPosition(btn.Name)
                btn.Position = UDim2.new(0, defX, 0, defY)
            end
        end
    end
    if pbFrame then
        pbFrame.Position = UDim2.new(1, -332, 0, 18)
        savedProgressBarPos = nil
        MVPUI.hudPlaced = false
    end
    savedMobilePanelPos = nil
    if MVPUI.fit then MVPUI.fit() end
end

function resetToFactoryDefaults()
    _isResetting = true
    local ok, err = pcall(function()
        stopAutoSteal()
        stopSpin()
        stopBatCounter()
        if stopBatCounterV2 then stopBatCounterV2() end
        stopMedusaCounter()
        if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
        if antiDieEnabled then AntiDieModule.stop() end
        if antiBatEnabled and stopAntiBat then stopAntiBat() end
        if antiFlingEnabled and stopAntiFling then stopAntiFling() end
        if stopAutoTPDown then stopAutoTPDown() end
        if _G.__VisibleHubStopBatV2 then pcall(_G.__VisibleHubStopBatV2) end
        stopUnwalk()
        InfiniteJump.stop()
        InfiniteJump.setMode("hold")
        disableAutoBat()
        stopBodyLock()
        if espEnabled then toggleESP(false) end
        if espLineEnabled and stopESPLine then stopESPLine() end
        if stretchEnabled then disableStretch() end
        if antiLagEnabled then disableAntiLag() end
        if vividGraphicsEnabled then disableVividGraphics() end
        if hideButtonsEnabled then applyHideButtons(false) end
        skipIntroEnabled = false
        _G.AmbitiousCustomToolsEnabled = false
        _G.AmbitiousCustomSoundsEnabled = false
        _G.AmbitiousCustomToolSkins = _G.AmbitiousCustomToolSkins or {}
        _G.AmbitiousCustomToolSkins.Bat = "Off"
        _G.AmbitiousCustomToolSkins.Medusa = "Off"
        _G.VisibleSoundChoice = {Bat = "Off", Medusa = "Off"}
        if setCustomSkinBatLabel then setCustomSkinBatLabel("Off") end
        if setCustomSkinMedusaLabel then setCustomSkinMedusaLabel("Off") end
        if setCustomSoundBatLabel then setCustomSoundBatLabel("Off") end
        if setCustomSoundMedusaLabel then setCustomSoundMedusaLabel("Off") end
        if _G.VisibleApplyToolSkinState then pcall(_G.VisibleApplyToolSkinState) end
        if _G.VisibleApplySoundState then pcall(_G.VisibleApplySoundState) end
        pcall(visibleApplySkinFlags)
        if dropActive then stopDropBrainrot() end
        skyTheme = "Off"
        pcall(applyCustomSky, "Off")
        if skySelectorLabel then skySelectorLabel.Text = "Off" end
        if antiDieEnabled then AntiDieModule.stop(); antiDieEnabled = false end
        NS = 70; CS = 38; LAGGER_SPEED = 30; LAGGER_CARRY_SPEED = 36
        CONFIG.STEAL_RANGE = 61
        CONFIG.HOLD_MIN = 0.05
        CONFIG.HOLD_MAX = 0.15
        CONFIG.ENTRY_DELAY = 0.1
        CONFIG.COOLDOWN = 0.2
        CONFIG.PRIME_RANGE = 60
        speedMode = false; laggerToggled = false; laggerCarryToggled = false
        antiRagdollMode = "off"; antiDieEnabled = false
        antiBatEnabled = false
        antiFlingEnabled = false
        autoTPDownEnabled = false; autoTPDownHeight = 20
        medusaCounterEnabled = false; batCounterEnabled = false; batCounterV2Enabled = false
        autoBatEnabled = false; autoLeftEnabled = false; autoRightEnabled = false
        unwalkEnabled = false; antiLagEnabled = false
        uiLocked = false; mobileButtonsLocked = false
        CONFIG.AUTO_STEAL_ENABLED = false
        setAutoStealMode("90")
        useVenixCarryEngine = false
        MVPVenixCarry:stop()
        MVPVenixCarry.softStealEnabled = false
        MVPVenixCarry.softStealSpeed = 30
        MVPVenixCarry.softStealRadius = 10
        MVPUI.effects = true
        if _G._visibleHubStealModeSetter then pcall(_G._visibleHubStealModeSetter, "V1") end
        BAT_AIMBOT_SPEED = 55
        BYPASS_AIMBOT_SPEED = BAT_AIMBOT_SPEED
        if State then State.bypassBatSpeed = BYPASS_AIMBOT_SPEED end
        aimbotVersion = 2
        batBypassVersion = 1
        _G.__VisibleAV3Pending = {speed = 58}
        if _G.__VisibleAV3 then _G.__VisibleAV3.speed = 58 end
        if _G.__VisibleAV3RefreshUI then pcall(_G.__VisibleAV3RefreshUI) end
        _G.__VisibleAV1Pending = {speed = 60}
        _G.__VisibleBBPending = {speed = 60, lagger = 40}
        _G.__VisibleBV3Pending = {speed = 60, lagger = 40}
        _G.__VisibleLagPendingSpeed = 58; _G.__VisibleLagPendingLagger = 40
        if _G.__VisibleLagSetSpeed then _G.__VisibleLagSetSpeed(58, 40) end
        if _G.__VisibleLagRefreshUI then pcall(_G.__VisibleLagRefreshUI) end
        if _G.__VisibleAV1SetSpeed then _G.__VisibleAV1SetSpeed(60) end
        if _G.__VisibleBBSetSpeed then _G.__VisibleBBSetSpeed(60, 40) end
        if _G.__VisibleBV3SetSpeed then _G.__VisibleBV3SetSpeed(60, 40) end
        if _G.__VisibleBV3RefreshUI then pcall(_G.__VisibleBV3RefreshUI) end
        if _G.__VisibleAV1RefreshUI then pcall(_G.__VisibleAV1RefreshUI) end
        if _G.__VisibleBBRefreshUI then pcall(_G.__VisibleBBRefreshUI) end
        if _G.__VisibleAimbotVersionRefresh then pcall(_G.__VisibleAimbotVersionRefresh) end
        if _G.__VisibleBatVersionRefresh then pcall(_G.__VisibleBatVersionRefresh) end
        dropMode = 1; stretchEnabled = false; stretchFOV = 120
        uiScaleValue = 90
        if MVPUI.fit then MVPUI.fit() end
        if pbScale then pbScale.Scale = 1 end
        espEnabled = false; espLineEnabled = false; vividGraphicsEnabled = false; hideButtonsEnabled = false
        bodyLockEnabled = false; bodyLockRange = 20
        backgroundIndex = 1; backgroundImageTransparency = 0; backgroundMode = "Background 1"
        floatingButtonScale = 1
        floatingButtonShape = "rounded"
        floatingButtonStyle = 1
        if MVPUI.buttonStyleLabel and MVPUI.buttonStyleLabel.Parent then MVPUI.buttonStyleLabel.Text = FLOATING_BUTTON_STYLE_NAMES[1] end
        pcall(applyFloatingButtonShape)
        spinSpeed = 32
        speedButtonScale = 1
        stealHudScale = 1
        stealBgIndex = 1
        pcall(applyStealBackground, 1)
        hyAnimPreset = HY_ANIM_NAMES[1]
        if hyAnimLabel then pcall(function() hyAnimLabel.Text = tostring(hyAnimPreset) end) end
        pcall(hyAnimSetOn, false)
        currentOutfitIndex = 1
        pcall(VX7A.stop)
        currentColorTheme = "Visible"; selectedColor = Color3.fromRGB(255, 255, 255)
        currentRivalTitleTheme = "Orange"
        applyRivalTitleTheme("Orange")
        if main then main.Position = UDim2.new(0, 20, 0, 2); _G.__VisibleHubMainOriginalPos = main.Position end
        for key, val in pairs(DEFAULT_KB) do
            if KB[key] then KB[key].kb = val.kb; KB[key].gp = val.gp end
        end
        resetFloatingPositions()
        forceResetUI()
        updateProgressBarVisibility()
        refreshSpeedModeLabel()
        _lastSavedJSON = nil
    end)
    _isResetting = false
    if not ok then warn("[resetToFactoryDefaults]", err) end
    if ok then saveAllSettings(true) end
    return ok
end

function updateProgressBarVisibility()
    if pbFrame then pbFrame.Visible = (CONFIG and CONFIG.AUTO_STEAL_ENABLED == true) or false end
end

function applyShimmerToText(obj, speed, baseColor)
    speed = speed or 0.8
    local color = baseColor or Color3.fromRGB(215, 215, 225)
    local grad = Instance.new("UIGradient", obj)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color),
        ColorSequenceKeypoint.new(0.3, color:Lerp(Color3.new(0.15,0.15,0.15), 0.25)),
        ColorSequenceKeypoint.new(0.5, color:Lerp(Color3.new(1,1,1), 0.55)),
        ColorSequenceKeypoint.new(0.7, color:Lerp(Color3.new(0.15,0.15,0.15), 0.25)),
        ColorSequenceKeypoint.new(1, color),
    })
    grad.Rotation = 45
    grad.Offset = Vector2.new(0,0)
    task.spawn(function()
        local t = 0
        while grad and grad.Parent do
            t = t + 0.05
            grad.Offset = Vector2.new(math.sin(t * speed) * 0.4, 0)
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, color),
                ColorSequenceKeypoint.new(0.30, color:Lerp(Color3.new(0.15,0.15,0.15), 0.25)),
                ColorSequenceKeypoint.new(0.50, color:Lerp(Color3.new(1,1,1), 0.55)),
                ColorSequenceKeypoint.new(0.70, color:Lerp(Color3.new(0.15,0.15,0.15), 0.25)),
                ColorSequenceKeypoint.new(1.00, color),
            })
            task.wait(0.1)
        end
    end)
    return grad
end

function getDefaultButtonPosition(name)
    local map = {AutoBat = 0, DropBR = 1, AutoLeft = 2, AutoRight = 3, TpDown = 4, Carry = 5, Lagger1 = 6, Lagger2 = 7, InstantReset = 8}
    local index = map[name] or 0
    local cam = Workspace.CurrentCamera
    local size = cam and cam.ViewportSize or Vector2.new(844, 390)
    local spacing = 68 * floatingButtonScale + 8
    local startX = math.max(8, size.X - spacing * 2 - 18)
    local startY = math.max(92, size.Y - spacing * 5 - 96)
    return startX + index % 2 * spacing, startY + _floor(index / 2) * spacing
end

local function tpBatDisconnectAntiDie()
    for _, conn in ipairs(TPBatState.antiDieConnections) do
        pcall(function() conn:Disconnect() end)
    end
    TPBatState.antiDieConnections = {}
end

local function tpBatHookAntiDie(character)
    tpBatDisconnectAntiDie()
    if not TPBatState.enabled or not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    pcall(function()
        humanoid.BreakJointsOnDeath = false
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dying, false)
    end)
    local _antiDieCooldown = false
    table.insert(TPBatState.antiDieConnections,
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if _antiDieCooldown then return end
            if TPBatState.enabled and humanoid.Parent and humanoid.Health <= 0 then
                _antiDieCooldown = true
                task.defer(function()
                    pcall(function()
                        if humanoid and humanoid.Parent then
                            humanoid.Health = humanoid.MaxHealth
                            humanoid:ChangeState(Enum.HumanoidStateType.Running)
                        end
                    end)
                    task.wait(0.5)
                    _antiDieCooldown = false
                end)
            end
        end)
    )
end

local function tpBatFindBat()
    local character = LP.Character
    if not character then return nil end
    local function isBat(tool)
        if not tool:IsA("Tool") then return false end
        local name = tool.Name:lower()
        return name:find("bat") ~= nil or name:find("slap") ~= nil
    end
    for _, child in ipairs(character:GetChildren()) do
        if isBat(child) then return child end
    end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    if not backpack then return nil end
    for _, child in ipairs(backpack:GetChildren()) do
        if isBat(child) then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                pcall(function() humanoid:EquipTool(child) end)
            end
            return child
        end
    end
    return nil
end

local function tpBatSwing()
    if TPBatState.hitCooldown then return end
    TPBatState.hitCooldown = true
    pcall(function()
        local bat = tpBatFindBat()
        if not bat then return end
        bat:Activate()
        local ev = bat:FindFirstChildWhichIsA("RemoteEvent", true)
        if ev then pcall(function() ev:FireServer() end) end
    end)
    task.delay(0.05, function()
        TPBatState.hitCooldown = false
    end)
end

local function tpBatTick()
    if not TPBatState.enabled then return end
    local character = LP.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 then return end

    local closestPlayer, closestDistance = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                local distance = (root.Position - targetRoot.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end

    if not closestPlayer or closestDistance > 100 then return end
    local targetRoot = closestPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end

    -- TP suave con Lerp + zerear velocidad en cada frame para no salir volando
    local targetPos = targetRoot.Position + Vector3.new(0, 0.9, 0)
    targetPos = wallSafePosition(root, targetPos) -- berhenti sebelum dinding
    if closestDistance > 5 then
        root.CFrame = CFrame.new(targetPos, targetRoot.Position)
    elseif closestDistance > 2 then
        root.CFrame = CFrame.new(root.Position:Lerp(targetPos, 0.35), targetRoot.Position)
    end

    pcall(function()
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end)

    local cam = workspace.CurrentCamera
    if cam then
        cam.CFrame = CFrame.new(cam.CFrame.Position, targetRoot.Position + Vector3.new(0, 0.5, 0))
    end

    tpBatSwing()
end

function tpBatSetEnabled(value)
    TPBatState.enabled = value == true
    if TPBatState.enabled then
        tpBatHookAntiDie(LP.Character)
        if TPBatState.connection then
            TPBatState.connection:Disconnect()
            TPBatState.connection = nil
        end
        TPBatState.connection = RunService.Heartbeat:Connect(tpBatTick)
    else
        if TPBatState.connection then
            TPBatState.connection:Disconnect()
            TPBatState.connection = nil
        end
        tpBatDisconnectAntiDie()
        local character = LP.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if root then
            pcall(function()
                if root.SetNetworkOwner then root:SetNetworkOwner(LP) end
            end)
        end
    end
end

LP.CharacterAdded:Connect(function(character)
    if TPBatState.enabled then
        task.wait(0.1)
        tpBatHookAntiDie(character)
    end
end)


function buildGui()
    local ROW_BG = Color3.fromRGB(14, 14, 16)
    local ROW_BORDER = Color3.fromRGB(70, 70, 78)
    local WHITE = Color3.fromRGB(255, 255, 255)
    local INP = Color3.fromRGB(18, 21, 26)
    local GUI_W, GUI_H = 390, 704
    local ACE = _G.__VisibleAce
    -- Imágenes de la barra lateral (como en Ace Duels). Cambia los IDs si quieres otra imagen.
    local VISIBLE_SIDE_IMAGE = ""  -- fondo de la barra lateral ("" = sin imagen)
    local VISIBLE_IDENTITY_IMAGE = ""                           -- círculo central ("" = tu avatar)
    -- Logo SOLO del nombre (PNG recortado, sin el icono). Pega aquí su ID: "rbxassetid://123..."
    -- Si queda vacío se usa el nombre en texto con el mismo estilo.
    local NAME_LOGO_IMAGE = ""
    local function makeNameLogo(parent, pos, size, textSize, z, align, anchor, imgPos, imgSize)
        if NAME_LOGO_IMAGE ~= "" then
            local fallback = MVPUI.text(parent, 'VISIBLE HUB', pos, size, textSize, WHITE, z)
            fallback.Name = "NameLogoFallback"
            fallback.AnchorPoint = anchor or Vector2.new(0, 0)
            fallback.Font = Enum.Font.GothamBlack
            fallback.RichText = true
            fallback.TextXAlignment = align or Enum.TextXAlignment.Left
            fallback.TextStrokeTransparency = 1
            local img = MVPUI.new("ImageLabel", parent, {Name = "NameLogo", Position = imgPos or pos, Size = imgSize or size,
                AnchorPoint = anchor or Vector2.new(0, 0), BackgroundTransparency = 1, BorderSizePixel = 0,
                Image = NAME_LOGO_IMAGE, ImageTransparency = 0, ScaleType = Enum.ScaleType.Fit, ZIndex = (z or 5) + 30})
            task.spawn(function()
                task.wait(0.4)
                if img and img.Parent and img.Image ~= "" then
                    local loaded = false
                    pcall(function() loaded = img.IsLoaded end)
                    if loaded then fallback.Visible = false end
                end
            end)
            return img, fallback
        end
        local lbl = MVPUI.text(parent, 'VISIBLE HUB', pos, size, textSize, WHITE, z)
        lbl.Name = "NameLogo"
        lbl.AnchorPoint = anchor or Vector2.new(0, 0)
        lbl.Font = Enum.Font.GothamBlack
        lbl.RichText = true
        lbl.TextXAlignment = align or Enum.TextXAlignment.Left
        lbl.TextStrokeTransparency = 1
        return lbl, lbl
    end
    for _, parent in ipairs({CoreGui, pgui}) do
        for _, name in ipairs({"VisibleHub", "VisibleHubMobilePanel", "VisibleHubSpeedIndicator", "VisibleHubBootErrors"}) do
            pcall(function() local old = parent:FindFirstChild(name); if old then old:Destroy() end end)
        end
    end
    gui = MVPUI.new("ScreenGui", nil, {Name = "VisibleHub", ResetOnSpawn = false,
        IgnoreGuiInset = true, DisplayOrder = 30, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    local ok = pcall(function() gui.Parent = CoreGui end)
    if not ok then gui.Parent = pgui end

    -- Panel principal estilo Ace Duels: ventana oscura con degradado, cabecera con línea y pestañas laterales
    main = MVPUI.new("Frame", gui, {Name = "Main", Size = UDim2.fromOffset(GUI_W, GUI_H),
        Position = UDim2.fromOffset(22, 16),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0,
        BorderSizePixel = 0, ClipsDescendants = true, Active = true})
    MVPUI.round(main, 16)
    MVPUI.new("UIGradient", main, {Name = "MainThemeGradient", Rotation = 135, Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(3, 3, 7)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))})})
    local border = MVPUI.stroke(main, ACE.line, 0.4, 1)
    border.Name = "MainBorder"
    border.Enabled = false
    mainUIScale = MVPUI.new("UIScale", main, {Scale = uiScaleValue / 100 * 0.85})
    local bg = MVPUI.new("ImageLabel", main, {Name = "BackgroundImage", Size = UDim2.fromScale(1, 1),
        Image = "",
        ImageTransparency = 1, BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Crop, ZIndex = 0})
    MVPUI.round(bg, 16)
    local veil = MVPUI.new("Frame", main, {Name = "BackgroundVeil", Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(8, 8, 10), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 2})
    MVPUI.round(veil, 16)

    if _G.__VisibleXmasMain then
        local okx, errx = pcall(_G.__VisibleXmasMain, main, border, veil)
        if not okx then warn("[Visible] Tema navidad (panel): " .. tostring(errx)) end
    end

    -- Estilo "Surf Hub": cielo estrellado negro + borde claro redondeado
    do
        local stars = MVPUI.new("Frame", main, {Name = "VisibleStars", Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 3, ClipsDescendants = true})
        local rng = Random.new(1337)
        for _ = 1, 75 do
            local sz = rng:NextInteger(1, 3)
            local st = MVPUI.new("Frame", stars, {Size = UDim2.fromOffset(sz, sz),
                Position = UDim2.fromScale(rng:NextNumber(), rng:NextNumber()),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.2 + rng:NextNumber() * 0.6, BorderSizePixel = 0})
            MVPUI.round(st, 3)
        end
        local vb = MVPUI.stroke(main, Color3.fromRGB(232, 236, 250), 0.45, 1.5)
        vb.Name = "VisibleBorder"
    end

    local header = MVPUI.new("Frame", main, {Name = "ScriptHeader", Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(1, 0, 0, 68), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 5})
    MVPUI.art = nil
    local _nameObj, _nameText = makeNameLogo(header, UDim2.new(0.5, 0, 0, 8), UDim2.new(1, -150, 0, 36), 30, 5, Enum.TextXAlignment.Center, Vector2.new(0.5, 0), UDim2.new(0.5, 0, 0, 2), UDim2.fromOffset(250, 48))
    pcall(function()
        _nameText.Font = Enum.Font.Fondamento
        _nameText.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
        _nameText.TextStrokeTransparency = 0.78
    end)
    for _, side in ipairs({-1, 1}) do
        MVPUI.new("Frame", header, {Name = "TitleLine", AnchorPoint = Vector2.new(side == -1 and 1 or 0, 0.5),
            Position = UDim2.new(0.5, side * 108, 0, 26), Size = UDim2.fromOffset(40, 1),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 5})
    end
    scriptLogoRef = _nameText
    _G.__VisibleScriptNameHat = nil
    MVPUI.titleGradient = nil
    -- Solo texto VISIBLE HUB (sin cuadro de imagen)
    local headerSub = MVPUI.text(header, "discord.gg/visiblehub   |   Executor", UDim2.new(0.5, 0, 0, 46), UDim2.new(1, -90, 0, 13), 10, Color3.fromRGB(255, 255, 255), 5)
    headerSub.Name = "HeaderSub"
    headerSub.Font = Enum.Font.GothamMedium
    headerSub.TextXAlignment = Enum.TextXAlignment.Center
    headerSub.AnchorPoint = Vector2.new(0.5, 0)
    headerSub.TextTransparency = 0.35
    headerSub.TextStrokeTransparency = 1
    local headerLine = MVPUI.new("Frame", main, {Name = "HeaderLine", Size = UDim2.new(1, -32, 0, 1),
        Position = UDim2.fromOffset(16, 64), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, ZIndex = 5, Visible = false})
    MVPUI.new("UIGradient", headerLine, {Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 76, 86)), ColorSequenceKeypoint.new(0.48, ACE.pale),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 66, 76))}),
        Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 0.85)})})

    local close = MVPUI.new("TextButton", main, {Name = "Close", Size = UDim2.fromOffset(26, 26),
        Position = UDim2.new(1, -34, 0, 15), Text = "-", TextSize = 12, Font = Enum.Font.GothamBold,
        TextColor3 = ACE.text, BackgroundColor3 = Color3.fromRGB(18, 18, 18), BackgroundTransparency = 0,
        BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 18})
    MVPUI.round(close, 7)
    MVPUI.stroke(close, ACE.line, 0.4, 1)
    close.MouseEnter:Connect(function() TS:Create(close, TweenInfo.new(0.16), {BackgroundColor3 = Color3.fromRGB(30, 34, 40)}):Play() end)
    close.MouseLeave:Connect(function() TS:Create(close, TweenInfo.new(0.16), {BackgroundColor3 = Color3.fromRGB(18, 18, 18)}):Play() end)

    miniBtn = MVPUI.new("TextButton", gui, {Name = "MinimizedFrame", Size = UDim2.fromOffset(170, 38),
        Position = UDim2.fromOffset(16, 58), Text = "", BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.02, BorderSizePixel = 0, AutoButtonColor = false, Visible = false, ZIndex = 25})
    MVPUI.round(miniBtn, 22)
    local miniStroke = MVPUI.stroke(miniBtn, Color3.fromRGB(232, 236, 250), 0.45, 1.5)
    local miniOpen = makeNameLogo(miniBtn, UDim2.new(0.5, 0, 0, 5), UDim2.new(1, -24, 0, 24), 17, 28,
        Enum.TextXAlignment.Center, Vector2.new(0.5, 0), UDim2.new(0.5, 0, 0, 3), UDim2.fromOffset(140, 26))
    miniOpen.Name = "ynsyText"
    pcall(function()
        miniOpen.AnchorPoint = Vector2.new(0.5, 0.5)
        miniOpen.Position = UDim2.new(0.5, 0, 0.5, 0)
        miniOpen.Size = UDim2.new(1, -20, 1, -8)
        miniOpen.Font = Enum.Font.Fondamento
        miniOpen.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
        miniOpen.TextStrokeTransparency = 0.78
    end)
    _G.__VisibleMiniHat = nil
    miniBackgroundImage = nil
    local animating, animationId, tween = false, 0, nil
    local function animate(open)
        animationId = animationId + 1
        local thisId = animationId
        if tween then tween:Cancel() end
        animating = true
        main.Visible = true
        miniBtn.Visible = false
        local width, height = MVPUI.width or GUI_W, MVPUI.height or GUI_H
        if open then main.Size = UDim2.fromOffset(width - 10, height - 8) end
        tween = TS:Create(main, TweenInfo.new(MVPUI.effects and 0.23 or 0.01, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Size = UDim2.fromOffset(open and width or width - 10, open and height or height - 8)})
        tween.Completed:Connect(function()
            if thisId ~= animationId or not main.Parent then return end
            animating = false
            main.Visible = open
            miniBtn.Visible = not open
            main.Size = UDim2.fromOffset(width, height)
        end)
        tween:Play()
    end
    showGui = function() animate(true) end
    hideGui = function() animate(false) end
    close.MouseButton1Click:Connect(hideGui)
    miniBtn.MouseButton1Click:Connect(showGui)
    _G.__VisibleHubMainOriginalPos = main.Position
    main:GetPropertyChangedSignal("Position"):Connect(function()
        if not animating then _G.__VisibleHubMainOriginalPos = main.Position end
    end)
    drag(main, 60)

    local discordTag = MVPUI.text(gui, ".gg/visiblehub", UDim2.new(1, -210, 1, -36), UDim2.fromOffset(200, 22), 14,
        Color3.fromRGB(255, 255, 255), 40)
    discordTag.Name = "VisibleDiscordTag"
    discordTag.Font = Enum.Font.GothamBlack
    discordTag.TextXAlignment = Enum.TextXAlignment.Right
    discordTag.TextStrokeTransparency = 0.35

    local SIDE_W = 0
    -- Disposición SIDE de Ace Duels: contenido a la izquierda, pestañas separadas a la derecha
    local contentPanel = MVPUI.new("Frame", main, {Name = "GeneralBackground", Position = UDim2.fromOffset(13, 72),
        Size = UDim2.new(1, -120, 1, -86), BackgroundColor3 = ACE.panel, BackgroundTransparency = 0.6,
        BorderSizePixel = 0, ZIndex = 1})
    MVPUI.round(contentPanel, 10)
    local sidePanel = MVPUI.new("Frame", main, {Name = "SideTabBackground", Position = UDim2.new(1, -101, 0, 72),
        Size = UDim2.new(0, 88, 1, -86), BackgroundColor3 = ACE.panel, BackgroundTransparency = 0.5,
        BorderSizePixel = 0, ZIndex = 5})
    MVPUI.round(sidePanel, 10)
    if VISIBLE_SIDE_IMAGE ~= "" then
        local sideImg = MVPUI.new("ImageLabel", sidePanel, {Name = "SideImage", Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1, Image = VISIBLE_SIDE_IMAGE, ImageTransparency = 0.78,
            ScaleType = Enum.ScaleType.Fit, ZIndex = 6})
        MVPUI.round(sideImg, 10)
    end
    local sideBar = MVPUI.new("Frame", main, {Name = "Navigation", Position = UDim2.new(1, -101, 0, 72),
        Size = UDim2.new(0, 88, 1, -86), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 8})

    local pageHeading = MVPUI.text(main, "01 / SPEED", UDim2.fromOffset(18, 84), UDim2.fromOffset(200, 20), 13,
        Color3.fromRGB(255, 255, 255), 5)
    pageHeading.Font = Enum.Font.GothamBlack
    pageHeading.TextXAlignment = Enum.TextXAlignment.Left
    pageHeading.Visible = false

    local tabContent = MVPUI.new("Frame", main, {Name = "Content", Size = UDim2.new(1, -120, 1, -86),
        Position = UDim2.fromOffset(13, 72), BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 6})
    do
        local pad = Instance.new("UIPadding", tabContent)
        pad.PaddingTop = UDim.new(0, 6); pad.PaddingLeft = UDim.new(0, 6); pad.PaddingBottom = UDim.new(0, 6)
    end

    -- identidad (avatar + nombre) en el centro de la barra lateral
    do
        local identity = MVPUI.new("Frame", sideBar, {Name = "SideIdentity", Position = UDim2.new(0, 0, 0, 128),
            Size = UDim2.new(1, 0, 0, 132), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 9})
        local avatarImg = MVPUI.new("ImageLabel", identity, {AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 0),
            Size = UDim2.fromOffset(72, 72), BackgroundColor3 = Color3.fromRGB(12, 12, 14), BorderSizePixel = 0,
            ScaleType = Enum.ScaleType.Crop, ZIndex = 10})
        MVPUI.round(avatarImg, 36)
        local avStroke = MVPUI.stroke(avatarImg, ACE.active, 0, 2)
        avStroke.Name = "AvatarStroke"
        task.spawn(function()
            local ok, result = pcall(function()
                return Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
            end)
            if avatarImg.Parent then
                avatarImg.Image = (VISIBLE_IDENTITY_IMAGE ~= "" and VISIBLE_IDENTITY_IMAGE) or (ok and result) or ""
            end
        end)
        local nameLbl = MVPUI.new("TextLabel", identity, {Position = UDim2.new(0, 0, 0, 83), Size = UDim2.new(1, 0, 0, 18),
            BackgroundTransparency = 1, Text = LP.DisplayName, TextColor3 = ACE.text, Font = Enum.Font.GothamBold,
            TextSize = 12, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 10})
        MVPUI.new("TextLabel", identity, {Position = UDim2.new(0, 0, 0, 102), Size = UDim2.new(1, 0, 0, 12),
            BackgroundTransparency = 1, Text = "VISIBLE LOADED", TextColor3 = ACE.active, Font = Enum.Font.GothamBold,
            TextSize = 8, ZIndex = 10})
    end
    local tabHighlight = MVPUI.new("Frame", sideBar, {Name = "TabHighlight", Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = ACE.accent, BackgroundTransparency = 0.82,
        BorderSizePixel = 0, ZIndex = 8})
    MVPUI.round(tabHighlight, 7)
    MVPUI.stroke(tabHighlight, ACE.active, 0, 1)

    -- el pie anterior ya no se muestra (la identidad vive en la barra lateral); se conserva por compatibilidad
    local footer = MVPUI.new("Frame", main, {Name = "Footer", Position = UDim2.new(0, 14, 1, -34),
        Size = UDim2.new(1, -28, 0, 25), BackgroundTransparency = 1, ZIndex = 8, Visible = false})
    local avatar = MVPUI.text(footer, string.upper(string.sub(LP.Name, 1, 1)),
        UDim2.fromOffset(2, 6), UDim2.fromOffset(17, 17), 10, WHITE, 9)
    avatar.BackgroundTransparency = 1
    MVPUI.footerStats = MVPUI.text(footer, "VISIBLE HUB", UDim2.new(0.42, 0, 0, 5), UDim2.new(0.58, -3, 0, 18), 9,
        Color3.fromRGB(255, 255, 255), 9)
    MVPUI.footerStats.TextXAlignment = Enum.TextXAlignment.Right

    local tabs = {"Speed", "Custom", "Visuals", "Keybinds"}
    local titles = {"01 / MOVEMENT", "02 / COMBAT", "03 / SETTINGS", "04 / KEYBINDS"}
    local headings = {"MOVEMENT", "COMBAT", "SETTINGS", "KEYBINDS"}
    tabButtons = {}
    local contentPages = {}
    local TAB_ON_TXT, TAB_OFF_TXT = Color3.fromRGB(255, 255, 255), Color3.fromRGB(150, 150, 160)
    local currentTabIndex = 1
    local tabSelectFns = {}
    local tabNameLabel = {Text = headings[1]}
    local function pillStyle(b, on)
        if not (b and b.Parent) then return end
        TS:Create(b, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = on and 0.28 or 0.52}):Play()
        local st = b:FindFirstChild("TabStroke")
        if st then
            st.Color = on and ACE.active or ACE.line
            TS:Create(st, TweenInfo.new(0.16), {Transparency = on and 0.05 or 0.25}):Play()
        end
        local cap = b:FindFirstChild("Caption")
        if cap then
            cap.TextColor3 = on and Color3.fromRGB(255, 255, 255) or ACE.dim
            cap.TextStrokeTransparency = 1
        end
    end
    _G.__VisibleRestyleTabs = function()
        for idx, b in ipairs(tabButtons or {}) do pillStyle(b, idx == currentTabIndex) end
    end

    for i, name in ipairs(tabs) do
        local button = MVPUI.new("TextButton", sideBar, {
            Name = name, Text = "", Size = UDim2.new(1, 0, 0, 30),
            Position = (i <= 2) and UDim2.new(0, 0, 0, (i - 1) * 40) or UDim2.new(0, 0, 0, 276 + ((i - 3) * 40)),
            BackgroundColor3 = Color3.fromRGB(12, 19, 23), BackgroundTransparency = 0.52,
            BorderSizePixel = 0, AutoButtonColor = false, ZIndex = 9, LayoutOrder = i
        })
        MVPUI.round(button, 7)
        local stroke = MVPUI.stroke(button, ACE.line, 0.25, 1)
        stroke.Name = "TabStroke"
        local caption = MVPUI.text(button, headings[i], UDim2.fromOffset(0, 0), UDim2.fromScale(1, 1), 9, ACE.dim, 10)
        caption.Name = "Caption"
        caption.Font = Enum.Font.GothamBold
        caption.TextXAlignment = Enum.TextXAlignment.Center

        local page = MVPUI.new("ScrollingFrame", tabContent, {Name = name, Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
            ScrollBarImageColor3 = ACE.active,
            ScrollBarImageTransparency = 0.2, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(),
            ScrollingDirection = Enum.ScrollingDirection.Y, ClipsDescendants = true, Visible = i == 1, ZIndex = 6})
        MVPUI.new("UIListLayout", page, {Padding = UDim.new(0, 7), SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Center})
        MVPUI.new("UIPadding", page, {PaddingLeft = UDim.new(0, 2), PaddingRight = UDim.new(0, 6),
            PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 18)})
        contentPages[name] = page
        table.insert(tabButtons, button)
        pillStyle(button, i == 1)

        local function select()
            currentTabIndex = i
            for _, p in pairs(contentPages) do p.Visible = false end
            page.Visible = true
            page.Position = UDim2.fromOffset(MVPUI.effects and 8 or 0, 0)
            TS:Create(page, TweenInfo.new(0.18), {Position = UDim2.fromOffset(0, 0)}):Play()
            for _, b in ipairs(tabButtons) do pillStyle(b, b == button) end
            TS:Create(tabHighlight, TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                {Position = button.Position, Size = button.Size}):Play()
            tabNameLabel.Text = headings[i] or titles[i] or name
            pageHeading.Text = titles[i] or headings[i] or name
            if applyTabBackground then pcall(applyTabBackground) end
            task.delay(0.3, function() pcall(MVPUI.fitTexts, gui) end)
        end
        tabSelectFns[i] = select
        button.MouseButton1Click:Connect(select)
        if i == 1 then select() end
    end
    if applyTabBackground then pcall(applyTabBackground) end
    -- Settings y Keybinds quedan debajo de la tarjeta de avatar; Keybinds tiene su propia página
    contentPages["Visual"] = contentPages["Visuals"]
    local pageCounters = {}
    local function getNextOrder(page)
        pageCounters[page] = (pageCounters[page] or 0) + 1
        return pageCounters[page]
    end
    local function mkSect(page, text)
        local row = MVPUI.new("Frame", page, {Name = "Section", Size = UDim2.new(1, -4, 0, 24),
            BackgroundColor3 = Color3.fromRGB(34, 34, 42), BackgroundTransparency = 0.35, BorderSizePixel = 0,
            LayoutOrder = getNextOrder(page), ZIndex = 7})
        MVPUI.round(row, 10)
        local mark = MVPUI.new("Frame", row, {Size = UDim2.fromOffset(2, 12), Position = UDim2.new(0, 10, 0.5, -6),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, ZIndex = 8})
        local label = MVPUI.text(row, text:upper(), UDim2.fromOffset(20, 0), UDim2.new(1, -28, 1, 0),
            9, Color3.fromRGB(240, 242, 248), 8)
        label.Font = Enum.Font.GothamBold
        label.TextStrokeTransparency = 1
        return row
    end
    local ROWHOV_ON, ROWHOV_OFF = 0.3, 0.6
    local function mkRow(page, height)
        local row = MVPUI.new("Frame", page, {Name = "Control", Size = UDim2.new(1, -4, 0, math.max(height or 40, 44)),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.03, BorderSizePixel = 0,
            LayoutOrder = getNextOrder(page), ZIndex = 7, ClipsDescendants = true})
        MVPUI.round(row, 16)
        local stroke = MVPUI.stroke(row, Color3.fromRGB(215, 219, 230), ROWHOV_OFF, 1.2)
        MVPUI.new("UIGradient", row, {Name = "AceRowGradient", Rotation = 90,
            Color = ColorSequence.new(Color3.fromRGB(20, 21, 25), Color3.fromRGB(13, 14, 17)),
            Transparency = NumberSequence.new(0.4)})
        row.MouseEnter:Connect(function()
            if row:GetAttribute("VisibleToggle") then return end
            TS:Create(stroke, TweenInfo.new(0.12), {Transparency = ROWHOV_ON}):Play()
        end)
        row.MouseLeave:Connect(function()
            if row:GetAttribute("VisibleToggle") then return end
            TS:Create(stroke, TweenInfo.new(0.12), {Transparency = ROWHOV_OFF}):Play()
        end)
        return row
    end
    local function mkLabel(row, text)
        local l = MVPUI.text(row, tostring(text), UDim2.fromOffset(14, 0), UDim2.new(0.55, -8, 1, 0), 13, ACE.text, 8)
        l.Font = Enum.Font.GothamMedium
        l.Name = "RowLabel"
        l.TextWrapped = true
        l.TextStrokeTransparency = 1
        local c = l:FindFirstChildOfClass("UITextSizeConstraint")
        if c then c.MinTextSize = 9 end
        return l
    end
    -- lebar label disesuaikan dengan kontrol di sisi kanan baris (kotak / selector / tombol / toggle)
    local function sizeRowLabel(row, controlW)
        local l = row and row:FindFirstChild("RowLabel")
        if l then l.Size = UDim2.new(1, -(14 + controlW + 8), 1, 0) end
    end
    -- Toggle estilo checkbox: caja redondeada azul con palomita blanca
    local function mkPill(row)
        local pill = MVPUI.new("Frame", row, {Name = "Track", Size = UDim2.fromOffset(28, 28),
            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.45,
            BorderSizePixel = 0, ZIndex = 8})
        MVPUI.round(pill, 8)
        MVPUI.new("UIGradient", pill, {Rotation = 90, Color = ColorSequence.new(
            Color3.fromRGB(58, 58, 64), Color3.fromRGB(0, 0, 0))})
        MVPUI.stroke(pill, Color3.fromRGB(240, 240, 246), 0.6, 2)
        local gloss = MVPUI.new("Frame", pill, {Name = "Gloss", Position = UDim2.fromOffset(3, 2),
            Size = UDim2.new(1, -6, 0.46, 0), BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0, ZIndex = 8, Visible = false})
        MVPUI.round(gloss, 6)
        MVPUI.new("UIGradient", gloss, {Rotation = 90, Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.55), NumberSequenceKeypoint.new(1, 1)})})
        local dot = MVPUI.new("TextLabel", pill, {Name = "Check", Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1, Text = "✓", TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.GothamBlack, TextSize = 20, TextTransparency = 1, ZIndex = 9})
        return pill, dot
    end
    local function animPill(pill, dot, on)
        local st = pill:FindFirstChildOfClass("UIStroke")
        TS:Create(pill, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = on and 0 or 0.45}):Play()
        if st then TS:Create(st, TweenInfo.new(0.16), {Transparency = on and 0.1 or 0.6}):Play() end
        local gl = pill:FindFirstChild("Gloss")
        if gl then gl.Visible = on end
        TS:Create(dot, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {TextTransparency = on and 0 or 1}):Play()
    end
    local function mkToggle(page, text, callback, displayText)
        local row = mkRow(page, 46)
        if _G.__VisibleXmasRow then pcall(_G.__VisibleXmasRow, row) end
        local label = mkLabel(row, displayText or text)
        sizeRowLabel(row, 52)
        local pill, dot = mkPill(row)
        local on = false
        PERSISTED_TOGGLE_CALLBACKS[text] = callback
        local function set(value)
            on = value == true
            row:SetAttribute("MVPActive", on)
            animPill(pill, dot, on)
            if _G.__VisibleRowStyle then
                pcall(_G.__VisibleRowStyle, row, on)
            else
                local rs = row:FindFirstChildOfClass("UIStroke")
                if rs then rs.Transparency = on and ROWHOV_ON or ROWHOV_OFF end
            end
        end
        PERSISTED_TOGGLE_SETTERS[text] = set
        local hit = MVPUI.new("TextButton", row, {Name = "ToggleHit", Size = UDim2.fromScale(1, 1), Text = "",
            BackgroundTransparency = 1, AutoButtonColor = false, ZIndex = 10})
        hit.Activated:Connect(function()
            local previous = on
            set(not on)
            local ok, err = pcall(callback, on)
            if not ok then
                set(previous)
                warn("[Visible] " .. text .. ": " .. tostring(err))
            else
                PERSISTED_TOGGLES[text] = on
            end
            task.defer(function() pcall(saveAllSettings, true) end)
        end)
        return set
    end
    MVPUI.styleArrow = function(btn)
        local parent = btn.Parent
        btn.BackgroundTransparency = 1
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = 13
        btn.AutoButtonColor = false
        local oldCorner = btn:FindFirstChildOfClass("UICorner")
        if oldCorner then oldCorner:Destroy() end
        if not parent or parent:FindFirstChild("ArrowBg_" .. btn.Name .. tostring(btn.Position.X.Offset)) then return end
        local bg = MVPUI.new("Frame", nil, {Name = "ArrowBg_" .. btn.Name .. tostring(btn.Position.X.Offset),
            Size = btn.Size, Position = btn.Position, BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0, ZIndex = math.max(btn.ZIndex - 1, 1)})
        MVPUI.round(bg, 8)
        MVPUI.new("UIGradient", bg, {Rotation = 90, Color = ColorSequence.new(
            Color3.fromRGB(58, 58, 64), Color3.fromRGB(0, 0, 0))})
        MVPUI.stroke(bg, Color3.fromRGB(240, 240, 246), 0.25, 1.6)
        bg.Parent = parent
    end
    local function mkSelector(row, default, options, callback)
        sizeRowLabel(row, 164)
        local frame = MVPUI.new("Frame", row, {Name = "Selector", Size = UDim2.fromOffset(144, 28),
            Position = UDim2.new(1, -156, 0.5, -14), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 8})
        local label = MVPUI.text(frame, default, UDim2.fromOffset(32, 0), UDim2.fromOffset(80, 28), 12, WHITE, 9)
        label.Font = Enum.Font.GothamBold
        label.TextWrapped = true
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.TextStrokeTransparency = 1
        do local c = label:FindFirstChildOfClass("UITextSizeConstraint"); if c then c.MinTextSize = 8 end end
        for i, direction in ipairs({-1, 1}) do
            local button = MVPUI.new("TextButton", frame, {Size = UDim2.fromOffset(26, 26),
                Position = UDim2.fromOffset(i == 1 and 0 or 118, 1), BorderSizePixel = 0,
                Text = direction == -1 and "<" or ">", ZIndex = 9})
            MVPUI.styleArrow(button)
            button.MouseButton1Click:Connect(function()
                callback(direction, function(text) label.Text = text end)
                task.defer(function() pcall(saveAllSettings) end)
            end)
        end
        return label
    end
    local function mkBox(row, default, width, xoff, callback)
        local w = math.max(width or 56, 58)
        sizeRowLabel(row, math.max(xoff or 76, w + 14))
        local box = MVPUI.new("TextBox", row, {Size = UDim2.fromOffset(w, 26),
            Position = UDim2.new(1, -math.max(xoff or 76, w + 14), 0.5, -13), Text = tostring(default),
            BackgroundColor3 = ACE.control, BorderSizePixel = 0, Font = Enum.Font.GothamBold, TextSize = 13,
            TextColor3 = Color3.fromRGB(255, 255, 255), ClearTextOnFocus = false, ZIndex = 9})
        MVPUI.round(box, 7)
        local border = MVPUI.stroke(box, ACE.line, 0.5, 1)
        local lastValid = tostring(default)
        box.Focused:Connect(function() border.Color = WHITE; border.Transparency = 0 end)
        box.FocusLost:Connect(function()
            border.Color = ACE.line; border.Transparency = 0.5
            local value = tonumber(box.Text)
            if value and value == value and math.abs(value) < math.huge then
                local ok = pcall(callback, value)
                if ok then lastValid = box.Text else box.Text = lastValid end
            else box.Text = lastValid end
            task.defer(function() pcall(saveAllSettings) end)
        end)
        return box
    end
    local function mkKeyButton(row, entry)
        local function name() return (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None" end
        sizeRowLabel(row, 112)
        local button = MVPUI.new("TextButton", row, {Size = UDim2.fromOffset(100, 26),
            Position = UDim2.new(1, -112, 0.5, -13), Text = name(), BackgroundColor3 = INP,
            TextSize = 11, Font = Enum.Font.GothamBold, TextColor3 = WHITE, BorderSizePixel = 0,
            AutoButtonColor = false, ZIndex = 9})
        MVPUI.round(button, 6)
        MVPUI.stroke(button, ACE.line, 0.5, 1)
        local connection, axisConnection, timeout, listening = nil, nil, nil, false
        local function stop()
            listening = false; _anyKeyListening = false
            if connection then connection:Disconnect(); connection = nil end
            if axisConnection then axisConnection:Disconnect(); axisConnection = nil end
            if timeout then pcall(task.cancel, timeout); timeout = nil end
            button.Text = name(); button.TextColor3 = WHITE
        end
        button.MouseButton1Click:Connect(function()
            if listening then stop(); return end
            if _anyKeyListening then return end
            listening = true; _anyKeyListening = true
            button.Text = "Press a key"; button.TextColor3 = getThemeColor()
            local started = _tick()
            local function accept(input)
                if not listening then return end
                if input.KeyCode == Enum.KeyCode.Escape then stop(); return end
                if not isBindableInput(input) then return end
                local controller = isGamepadInput(input)
                if controller and _tick() - started < 0.2 then return end
                if controller and (input.KeyCode == Enum.KeyCode.ButtonL2 or input.KeyCode == Enum.KeyCode.ButtonR2)
                    and input.Position.Z < 0.55 then return end
                if controller then entry.gp = input.KeyCode; entry.kb = nil
                else entry.kb = input.KeyCode; entry.gp = nil end
                stop(); pcall(saveAllSettings, true)
            end
            connection = UIS.InputBegan:Connect(accept)
            axisConnection = UIS.InputChanged:Connect(accept)
            timeout = task.delay(10, stop)
        end)
        table.insert(keyButtonRefs, {btn = button, entry = entry})
        return button
    end
    local function addKeybindRow(page, text, entry)
        local row = mkRow(page, 46)
        mkLabel(row, text)
        mkKeyButton(row, entry)
    end

    local speedPage = contentPages["Speed"]

    mkSect(speedPage, "Movement Speeds")
    do local row = mkRow(speedPage, 42); mkLabel(row, "Normal Speed"); normalBox = mkBox(row, NS, 50, 56, function(v) if v == v and v > 0 and v < math.huge then NS = v; if MVPVenixCarry then MVPVenixCarry.normalSpeed = v end; if _G.__VisibleHubApplySpeedNow then pcall(_G.__VisibleHubApplySpeedNow) end end end) end
    do local row = mkRow(speedPage, 42); mkLabel(row, "Carry Speed"); carryBox = mkBox(row, CS, 50, 56, function(v) if v == v and v > 0 and v < math.huge then CS = v; if MVPVenixCarry then MVPVenixCarry.carrySpeed = v end; if _G.__VisibleHubApplySpeedNow then pcall(_G.__VisibleHubApplySpeedNow) end end end) end
    do local row = mkRow(speedPage, 42); mkLabel(row, "Lagger Normal Speed"); laggerBox = mkBox(row, LAGGER_SPEED, 50, 56, function(v) if v == v and v > 0 and v < math.huge then LAGGER_SPEED = v; if MVPVenixCarry then MVPVenixCarry.laggerSpeed = v end; if _G.__VisibleHubApplySpeedNow then pcall(_G.__VisibleHubApplySpeedNow) end end end) end
    do local row = mkRow(speedPage, 42); mkLabel(row, "Lagger Carry Speed"); lagger2Box = mkBox(row, LAGGER_CARRY_SPEED, 50, 56, function(v) if v == v and v > 0 and v < math.huge then LAGGER_CARRY_SPEED = v; if MVPVenixCarry then MVPVenixCarry.laggerCarrySpeed = v end; if _G.__VisibleHubApplySpeedNow then pcall(_G.__VisibleHubApplySpeedNow) end end end) end

    mkSect(speedPage, "Speed Engine")
    MVPUI.carrySetter = mkToggle(speedPage, "Auto Carry", function(on)
        MVPVenixCarry:setSoftStealEnabled(on)
        if on then useVenixCarryEngine = true end
        if MVPUI.motorLabel then MVPUI.motorLabel.Text = useVenixCarryEngine and "Carry Boost" or "Direct" end
        if _G.__VisibleHubRefreshSpeedEngine then _G.__VisibleHubRefreshSpeedEngine() end
    end)
    do
        local row = mkRow(speedPage, 46); mkLabel(row, "Auto Carry Speed")
        MVPUI.carrySpeedBox = mkBox(row, MVPVenixCarry.softStealSpeed, 60, 72, function(v)
            MVPVenixCarry:setSoftStealSpeed(v); MVPUI.carrySpeedBox.Text = tostring(MVPVenixCarry.softStealSpeed)
        end)
    end
    do
        local row = mkRow(speedPage, 46); mkLabel(row, "Auto Carry Radius")
        MVPUI.carryRadiusBox = mkBox(row, MVPVenixCarry.softStealRadius, 60, 72, function(v)
            MVPVenixCarry:setSoftStealRadius(v); MVPUI.carryRadiusBox.Text = tostring(MVPVenixCarry.softStealRadius)
        end)
    end
    mkSect(speedPage, "Active Mode")
    do
        local row = mkRow(speedPage, 42)
        mkLabel(row, "Current Mode")
        modeValLbl = Instance.new("TextLabel", row)
        modeValLbl.Size = UDim2.new(0, 110, 1, 0)
        modeValLbl.Position = UDim2.new(1, -118, 0, 0)
        modeValLbl.BackgroundTransparency = 1
        modeValLbl.Text = "Normal"
        modeValLbl.TextColor3 = WHITE
        modeValLbl.Font = Enum.Font.GothamBold
        modeValLbl.TextSize = 12
        modeValLbl.TextXAlignment = Enum.TextXAlignment.Right
        modeValLbl.ZIndex = 8
        local clk = Instance.new("TextButton", row)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 8
        clk.MouseButton1Click:Connect(function() toggleCarryMode() end)
    end

    mkSect(speedPage, "Auto Movement")
    autoLeftSetVisual = mkToggle(speedPage, "Auto Left", function(on)
        autoLeftEnabled = on
        if on then startAutoLeft() else stopAutoLeft() end
        if mobSetAutoLeft then mobSetAutoLeft(on) end
    end)
    autoRightSetVisual = mkToggle(speedPage, "Auto Right", function(on)
        autoRightEnabled = on
        if on then startAutoRight() else stopAutoRight() end
        if mobSetAutoRight then mobSetAutoRight(on) end
    end)

    mkSect(speedPage, "Infinite Jump")
    infJumpSetVisual = mkToggle(speedPage, "Infinite Jump", function(on)
        if on then InfiniteJump.start() else InfiniteJump.stop() end
    end)
    do
        local row = mkRow(speedPage, 42)
        mkLabel(row, "Jump Mode")
        local modeBtn = Instance.new("TextButton", row)
        modeBtn.Size = UDim2.new(0, 100, 0, 32)
        modeBtn.Position = UDim2.new(1, -108, 0.5, -16)
        modeBtn.BackgroundColor3 = INP
        modeBtn.BackgroundTransparency = 0.4
        modeBtn.BorderSizePixel = 0
        modeBtn.Text = "HOLD"
        modeBtn.TextColor3 = WHITE
        modeBtn.Font = Enum.Font.GothamBold
        modeBtn.TextSize = 11
        modeBtn.ZIndex = 8
        Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0, 6)
        infJumpModeBtn = modeBtn
        modeBtn.MouseButton1Click:Connect(function()
            local nextMode = InfiniteJump.mode == "hold" and "manual" or "hold"
            InfiniteJump.setMode(nextMode)
            modeBtn.Text = string.upper(nextMode)
            if InfiniteJump.enabled then InfiniteJump.stop(); InfiniteJump.start() end
            pcall(saveAllSettings, true)
        end)
    end

    -- Ajuste de tamaño para los botones de la pestaña Speed.

    local combatPage = contentPages["Custom"]

    mkSect(combatPage, "Bat Aimbot")
    autoBatSetVisual = mkToggle(combatPage, "Bat Bypass", function(on)
        if on then enableAutoBat() else disableAutoBat() end
        if mobSetAutoBat then mobSetAutoBat(on) end
        pcall(saveAllSettings, true)
    end, "Bat Aimbot")
    do
        local row = mkRow(combatPage, 46)
        mkLabel(row, "Mode")
        local sel = mkSelector(row, _G.__VisibleBatVersionName(batBypassVersion), {"V1", "V2", "V3"}, function(direction, update)
            if _G.__VisibleBatVersionCycle then _G.__VisibleBatVersionCycle() end
            update(_G.__VisibleBatVersionName(batBypassVersion))
        end)
        sel.TextScaled = true
        do local c = sel:FindFirstChildOfClass("UITextSizeConstraint"); if c then c.MaxTextSize = 11; c.MinTextSize = 8 end end
        _G.__VisibleBatVersionLabel = sel
    end
    do
        local irSet
        irSet = mkToggle(combatPage, "Instant Reset", function(on)
            if on then
                if _G.__VisibleRunInstantReset then pcall(_G.__VisibleRunInstantReset) end
                task.delay(0.1, function() if irSet then pcall(irSet, false) end end)
            end
        end)
        local rowV = mkRow(combatPage, 42); mkLabel(rowV, "Instant Reset Version")
        local vb = Instance.new("TextButton", rowV)
        vb.Size = UDim2.fromOffset(70, 26)
        vb.Position = UDim2.new(1, -82, 0.5, -13)
        vb.BackgroundColor3 = Color3.fromRGB(16, 19, 24)
        vb.BorderSizePixel = 0
        vb.Font = Enum.Font.GothamBold
        vb.TextSize = 12
        vb.TextColor3 = Color3.fromRGB(255, 255, 255)
        vb.AutoButtonColor = false
        vb.ZIndex = 8
        Instance.new("UICorner", vb).CornerRadius = UDim.new(0, 6)
        local function refreshV() vb.Text = _G.__VisibleInstantResetVersion end
        refreshV()
        vb.MouseButton1Click:Connect(function()
            _G.__VisibleInstantResetVersion = (_G.__VisibleInstantResetVersion == "V1") and "V2" or "V1"
            refreshV()
            pcall(saveAllSettings, true)
        end)
    end
    do
        local row1 = mkRow(combatPage, 42); mkLabel(row1, "Bat Aimbot Speed")
        _G.__VisibleBypasSpeedBox = mkBox(row1, 60, 50, 56, function(v)
            if v > 0 and v <= 250 then _G.__VisibleApplyBypasSpeed(v, nil) else error("invalid") end
        end)
        local row2 = mkRow(combatPage, 42); mkLabel(row2, "Bat Aimbot Lagger Speed")
        _G.__VisibleBypasLaggerBox = mkBox(row2, 40, 50, 56, function(v)
            if v > 0 and v <= 250 then _G.__VisibleApplyBypasSpeed(nil, v) else error("invalid") end
        end)
    end

    do
        local row = mkRow(combatPage, 42); mkLabel(row, "Bypass V1 Speed")
        _G.__VisibleBBSpeedBox = mkBox(row, 60, 50, 56, function(v)
            if v > 0 and v <= 250 and _G.__VisibleBBSetSpeed then _G.__VisibleBBSetSpeed(v, nil) else error("invalid") end
        end)
    end
    do
        local row = mkRow(combatPage, 42); mkLabel(row, "Bypass V1 Lagger Speed")
        _G.__VisibleBBLaggerBox = mkBox(row, 40, 50, 56, function(v)
            if v > 0 and v <= 250 and _G.__VisibleBBSetSpeed then _G.__VisibleBBSetSpeed(nil, v) else error("invalid") end
        end)
    end
    do
        local row = mkRow(combatPage, 42); mkLabel(row, "Bat Bypas V2 Speed")
        _G.__VisibleLagSpeedBox = mkBox(row, tonumber(_G.__VisibleLagPendingSpeed) or 58, 50, 56, function(v)
            if v > 0 and v <= 250 and _G.__VisibleLagSetSpeed then _G.__VisibleLagSetSpeed(v, nil) else error("invalid") end
        end)
    end
    do
        local row = mkRow(combatPage, 42); mkLabel(row, "Bat Bypas V2 Lagger Speed")
        _G.__VisibleLagLaggerBox = mkBox(row, tonumber(_G.__VisibleLagPendingLagger) or 40, 50, 56, function(v)
            if v > 0 and v <= 250 and _G.__VisibleLagSetSpeed then _G.__VisibleLagSetSpeed(nil, v) else error("invalid") end
        end)
    end
    do
        local row = mkRow(combatPage, 42); mkLabel(row, "Aimbot Bypas V3 Speed")
        _G.__VisibleBV3SpeedBox = mkBox(row, 60, 50, 56, function(v)
            if v > 0 and v <= 250 and _G.__VisibleBV3SetSpeed then _G.__VisibleBV3SetSpeed(v, nil) else error("invalid") end
        end)
    end
    do
        local row = mkRow(combatPage, 42); mkLabel(row, "Aimbot Bypas V3 Lagger Speed")
        _G.__VisibleBV3LaggerBox = mkBox(row, 40, 50, 56, function(v)
            if v > 0 and v <= 250 and _G.__VisibleBV3SetSpeed then _G.__VisibleBV3SetSpeed(nil, v) else error("invalid") end
        end)
    end


    mkSect(combatPage, "Defense")
    setAntiBatVisual = mkToggle(combatPage, "Anti Bat", function(on)
        if on then startAntiBat() else stopAntiBat() end
    end)
    setAntiFlingVisual = mkToggle(combatPage, "Anti Fling", function(on)
        antiFlingEnabled = on
        if on then startAntiFling() else stopAntiFling() end
        saveAllSettings()
    end)
    if setAntiFlingVisual then setAntiFlingVisual(antiFlingEnabled) end
    mkSect(combatPage, "Anti Ragdoll")
    do
        local row = mkRow(combatPage, 46)
        mkLabel(row, "Anti Ragdoll")
        local modes = {"off", "v1", "v2"}
        local label = mkSelector(row, antiRagdollMode:upper(), modes, function(direction, update)
            local index = antiRagdollMode == "v1" and 2 or (antiRagdollMode == "v2" and 3 or 1)
            index = (index - 1 + direction) % #modes + 1
            setAntiRagdollMode(modes[index])
            update(antiRagdollMode:upper())
        end)
        _G.updateAntiRagdollUI = function(mode) label.Text = mode:upper() end
        setAntiRagVisual = function(on) if not on then setAntiRagdollMode("off") end end
    end

    setAntiDieVisual = mkToggle(combatPage, "Anti Die", function(on)
        antiDieEnabled = on
        if on then AntiDieModule.start() else AntiDieModule.stop() end
        saveAllSettings()
    end)
    if setAntiDieVisual then setAntiDieVisual(antiDieEnabled) end

    setUnwalkVisual = mkToggle(combatPage, "Unwalk", function(on)
        unwalkEnabled = on
        if on then startUnwalk() else stopUnwalk() end
    end)

    mkSect(combatPage, "TP Down")
    setAutoTPDownVisual = mkToggle(combatPage, "Auto TP Down", function(on)
        autoTPDownEnabled = on
        if on then startAutoTPDown() else stopAutoTPDown() end
    end)
    if setAutoTPDownVisual then setAutoTPDownVisual(autoTPDownEnabled) end
    do
        local row = mkRow(combatPage, 46)
        mkLabel(row, "TP Height")
        autoTPDownBox = mkBox(row, autoTPDownHeight, 56, 66, function(v)
            if v and v == v then
                autoTPDownHeight = _clamp(_floor(v), 5, 100) -- mentok 5 - 100
            end
            if autoTPDownBox then autoTPDownBox.Text = tostring(autoTPDownHeight) end
        end)
    end

    -- ===== speed dipisah: "Speed Aimbot" (semua Aimbot V1-V4) dan "Speed Aimbot Bypas" (semua Aimbot Bypas V1-V4);
    --       barisnya ada di bawah fitur masing-masing (Bypass Version / Aimbot Version) =====
    do
        local function cl(x, m) return math.min(x, m) end
        _G.__VisibleApplyAimbotSpeed = function(v, l)
            if v then
                pcall(function() if _G.__VisibleAV1SetSpeed then _G.__VisibleAV1SetSpeed(cl(v, 120)) end end)
                pcall(function() if _G.__VisibleAV2SetSpeed then _G.__VisibleAV2SetSpeed(cl(v, 250), nil) end end)
                pcall(function() if _G.__VisibleAV3SetSpeed then _G.__VisibleAV3SetSpeed(cl(v, 200)) end end)
            end
            if l then
                pcall(function() if _G.__VisibleAV2SetSpeed then _G.__VisibleAV2SetSpeed(nil, cl(l, 250)) end end)
            end
        end
        _G.__VisibleApplyBypasSpeed = function(v, l)
            pcall(function() if _G.__VisibleApplyAimbotSpeed then _G.__VisibleApplyAimbotSpeed(v, l) end end)
            if v then
                pcall(function() if _G.__VisibleBBSetSpeed then _G.__VisibleBBSetSpeed(cl(v, 250), nil) end end)
                pcall(function() if _G.__VisibleLagSetSpeed then _G.__VisibleLagSetSpeed(cl(v, 250), nil) end end)
                pcall(function() if _G.__VisibleBV3SetSpeed then _G.__VisibleBV3SetSpeed(cl(v, 250), nil) end end)
            end
            if l then
                pcall(function() if _G.__VisibleBBSetSpeed then _G.__VisibleBBSetSpeed(nil, cl(l, 250)) end end)
                pcall(function() if _G.__VisibleLagSetSpeed then _G.__VisibleLagSetSpeed(nil, cl(l, 250)) end end)
                pcall(function() if _G.__VisibleBV3SetSpeed then _G.__VisibleBV3SetSpeed(nil, cl(l, 250)) end end)
            end
        end
        -- tampilkan nilai yang sedang aktif setelah pengaturan tersimpan selesai dimuat
        task.spawn(function()
            for _, t in ipairs({1.5, 3, 6}) do
                task.wait(t)
                pcall(function()
                    local av = _G.VisibleAimbotV2
                    if av then
                        local anti = av.mode == "Anti Bypass"
                        local n = anti and av.abSpeed or av.speed
                        local l = anti and av.abLaggerSpeed or av.laggerSpeed
                        local b1, b2 = _G.__VisibleAimbotSpeedBox, _G.__VisibleAimbotLaggerBox
                        if b1 and b1.Parent and not b1:IsFocused() and n then b1.Text = tostring(n) end
                        if b2 and b2.Parent and not b2:IsFocused() and l then b2.Text = tostring(l) end
                    end
                    local bb = _G.__VisibleBB
                    if bb then
                        local c1, c2 = _G.__VisibleBypasSpeedBox, _G.__VisibleBypasLaggerBox
                        if c1 and c1.Parent and not c1:IsFocused() and bb.speed then c1.Text = tostring(bb.speed) end
                        if c2 and c2.Parent and not c2:IsFocused() and bb.laggerSpeed then c2.Text = tostring(bb.laggerSpeed) end
                    end
                end)
            end
        end)
    end

    mkSect(combatPage, "Bat Aimbot V3")
    do
        local row = mkRow(combatPage, 42); mkLabel(row, "Aimbot V1 Speed")
        _G.__VisibleAV1SpeedBox = mkBox(row, 60, 50, 56, function(v)
            if v > 0 and v <= 120 and _G.__VisibleAV1SetSpeed then _G.__VisibleAV1SetSpeed(v) else error("invalid") end
        end)
    end
    do
        local row = mkRow(combatPage, 42); mkLabel(row, "Aimbot V3 Speed")
        _G.__VisibleAV3SpeedBox = mkBox(row, 58, 50, 56, function(v)
            if v > 0 and v <= 200 and _G.__VisibleAV3SetSpeed then _G.__VisibleAV3SetSpeed(v) else error("invalid") end
        end)
    end
    do
        local row = mkRow(combatPage, 46)
        mkLabel(row, "V3 Type")
        _G.__VisibleAV2ModeLabel = mkSelector(row, "Normal", {"Normal", "Anti Bypass"}, function(direction, update)
            local av = _G.VisibleAimbotV2
            local nextMode = (av and av.mode == "Anti Bypass") and "Normal" or "Anti Bypass"
            if _G.__VisibleAV2SetMode then _G.__VisibleAV2SetMode(nextMode) end
            update(nextMode)
        end)
    end
    do
        local row = mkRow(combatPage, 42); mkLabel(row, "Aimbot V2 Speed")
        _G.__VisibleAV2SpeedBox = mkBox(row, 58, 50, 56, function(v)
            if v > 0 and v <= 250 then _G.__VisibleAV2SetSpeed(v, nil) else error("invalid") end
        end)
    end
    do
        local row = mkRow(combatPage, 42); mkLabel(row, "Aimbot V2 Lagger Speed")
        _G.__VisibleAV2LaggerBox = mkBox(row, 40, 50, 56, function(v)
            if v > 0 and v <= 250 then _G.__VisibleAV2SetSpeed(nil, v) else error("invalid") end
        end)
    end
    -- kolom speed per-versi disembunyikan (tetap ada di belakang layar); pengaturannya sekarang lewat "Speed Aimbot"
    for _, bx in ipairs({_G.__VisibleBBSpeedBox, _G.__VisibleBBLaggerBox, _G.__VisibleLagSpeedBox, _G.__VisibleLagLaggerBox,
        _G.__VisibleBV3SpeedBox, _G.__VisibleBV3LaggerBox, _G.__VisibleAV1SpeedBox, _G.__VisibleAV3SpeedBox,
        _G.__VisibleAV2SpeedBox, _G.__VisibleAV2LaggerBox}) do
        if bx and bx.Parent then bx.Parent.Visible = false end
    end
    local setAV2AutoSwingVisual = mkToggle(combatPage, "Aimbot V2 Auto Swing", function(on)
        if _G.__VisibleAV2SetAutoSwing then _G.__VisibleAV2SetAutoSwing(on) end
    end, "Auto Bat Swing")
    setAV2AutoSwingVisual(true) -- auto klik default ON (sinkron dengan AV.autoSwing)
    _G.__VisibleAV2AutoSwingSet = setAV2AutoSwingVisual

    -- La interfaz de Spin se retiró del panel de configuración.
    mkSect(combatPage, "Targeting")
    bodyLockSetVisual = mkToggle(combatPage, "Body Lock", function(on)
        bodyLockEnabled = on
        if on then
            if _blSuppressCount == 0 then startBodyLock() end
        else
            stopBodyLock()
        end
    end)
    do
        local row = mkRow(combatPage, 38)
        mkLabel(row, "Body Lock Range")
        bodyLockRangeBox = mkBox(row, bodyLockRange, 50, 56, function(v)
            if v and v > 0 then
                bodyLockRange = _clamp(_floor(v), 5, 200)
                if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
            end
        end)
    end

    mkSect(combatPage, "Counters")
    setBatCounterVisual = mkToggle(combatPage, "Bat Counter", function(on)
        batCounterEnabled = on
        if on then startBatCounter() else stopBatCounter() end
    end)
    setBatCounterV2Visual = mkToggle(combatPage, "Bat Counter V2", function(on)
        batCounterV2Enabled = on
        if on then startBatCounterV2() else stopBatCounterV2() end
    end)
    setMedusaVisual = mkToggle(combatPage, "Medusa Counter", function(on)
        medusaCounterEnabled = on
        if on then
            if LP.Character then setupMedusaCounter(LP.Character) else stopMedusaCounter() end
        else
            stopMedusaCounter()
        end
        if setMedusaVisual then setMedusaVisual(on) end
    end)

    mkSect(combatPage, "Drop")
    dropBrainrotSetVisual = mkToggle(combatPage, "Drop Brainrot", function(on)
        if on then
            executeDropWithToggle(function(v)
                dropBrainrotSetVisual(v)
                if mobSetDropBR then mobSetDropBR(v) end
            end)
        end
    end)
    setDropVisual = dropBrainrotSetVisual
    do
        local row = mkRow(combatPage, 42)
        mkLabel(row, "Drop Mode")
        dropModeBtnRef = mkSelector(row, dropMode == 1 and "Fling" or "Jump Drop", {"Fling", "Jump Drop"}, function(dir, update)
            if dropActive then stopDropBrainrot() end
            dropMode = dropMode == 1 and 2 or 1
            update(dropMode == 1 and "Fling" or "Jump Drop")
        end)
    end

    -- ===================== TAB VISUAL (baru) =====================
    do
    local visualsPage = contentPages["Visuals"]

    mkSect(visualsPage, "Bat & Medusa (Blaxing)")
    -- Skins y sonidos: ya no hay toggle; cada selector tiene "Off" y al moverlo aparecen las opciones.
    local SKIN_OPTS = {Bat = {"Off", "DiamondSword", "Katana"}, Medusa = {"Off", "GoldenDesertEagle", "Skull"}}
    local SKIN_NAMES = {Off = "Off", DiamondSword = "Minecraft Sword", Katana = "Katana",
        GoldenDesertEagle = "Golden Desert Eagle", Skull = "Skull"}
    local SOUND_OPTS = {Bat = {"Off", "Katana Slash"}, Medusa = {"Off", "Gunshot"}}
    _G.AmbitiousCustomToolSkins = _G.AmbitiousCustomToolSkins or {}
    _G.AmbitiousCustomToolSkins.Bat = _G.AmbitiousCustomToolSkins.Bat or "Off"
    _G.AmbitiousCustomToolSkins.Medusa = _G.AmbitiousCustomToolSkins.Medusa or "Off"
    _G.VisibleSoundChoice = _G.VisibleSoundChoice or {Bat = "Off", Medusa = "Off"}
    _G.VisibleApplyToolSkinState = function()
        local sk = _G.AmbitiousCustomToolSkins or {}
        -- El sonido solo se activa cuando hay skin activa (bate -> Katana Slash, medusa -> Gunshot)
        _G.VisibleSoundChoice = {
            Bat = (sk.Bat ~= nil and sk.Bat ~= "Off") and "Katana Slash" or "Off",
            Medusa = (sk.Medusa ~= nil and sk.Medusa ~= "Off") and "Gunshot" or "Off",
        }
        if _G.VisibleApplySoundState then task.defer(_G.VisibleApplySoundState) end
        local off = {Bat = (sk.Bat == nil or sk.Bat == "Off"), Medusa = (sk.Medusa == nil or sk.Medusa == "Off")}
        _G.VisibleToolSkinOff = off
        local anyOn = (not off.Bat) or (not off.Medusa)
        _G.AmbitiousCustomToolsEnabled = anyOn
        if _G.AmbitiousCustomTools then
            pcall(_G.AmbitiousCustomTools.setEnabled, anyOn)
            if anyOn then
                if _G.VisibleToolSkinTeardownOff then pcall(_G.VisibleToolSkinTeardownOff) end
                if _G.AmbitiousSetCustomToolSkin then
                    if not off.Bat then pcall(_G.AmbitiousSetCustomToolSkin, "Bat", sk.Bat) end
                    if not off.Medusa then pcall(_G.AmbitiousSetCustomToolSkin, "Medusa", sk.Medusa) end
                end
                if _G.AmbitiousCustomToolsRecheck then pcall(_G.AmbitiousCustomToolsRecheck) end
            end
        end
    end
    _G.VisibleApplySoundState = function()
        local ch = _G.VisibleSoundChoice or {}
        local off = {Bat = (ch.Bat == nil or ch.Bat == "Off"), Medusa = (ch.Medusa == nil or ch.Medusa == "Off")}
        _G.VisibleSoundOff = off
        local anyOn = (not off.Bat) or (not off.Medusa)
        _G.AmbitiousCustomSoundsEnabled = anyOn
        if _G.AmbitiousCustomSounds then
            pcall(_G.AmbitiousCustomSounds.setEnabled, anyOn)
            if anyOn then
                if _G.VisibleSoundTeardownOff then pcall(_G.VisibleSoundTeardownOff) end
                if _G.VisibleSoundRescan then pcall(_G.VisibleSoundRescan) end
            end
        end
    end
    for _, cat in ipairs({"Bat", "Medusa"}) do
        local opts = SKIN_OPTS[cat]
        local row = mkRow(visualsPage, 46)
        mkLabel(row, cat == "Bat" and "Skin Bat" or "Skin Medusa")
        local lbl = mkSelector(row, SKIN_NAMES[_G.AmbitiousCustomToolSkins[cat]] or "Off", opts, function(dir, update)
            local idx = 1
            local curKey = _G.AmbitiousCustomToolSkins[cat]
            for i, o in ipairs(opts) do if o == curKey then idx = i end end
            idx = ((idx - 1 + dir) % #opts) + 1
            _G.AmbitiousCustomToolSkins[cat] = opts[idx]
            update(SKIN_NAMES[opts[idx]])
            _G.VisibleApplyToolSkinState()
            pcall(saveAllSettings, true)
        end)
        if cat == "Bat" then
            setCustomSkinBatLabel = function(k) if lbl then lbl.Text = SKIN_NAMES[k] or "Off" end end
        else
            setCustomSkinMedusaLabel = function(k) if lbl then lbl.Text = SKIN_NAMES[k] or "Off" end end
        end
    end

    mkSect(visualsPage, "Character")
    do
        local row = mkRow(visualsPage, 46)
        mkLabel(row, "Animation Source")
        hyAnimLabel = mkSelector(row, tostring(hyAnimPreset), HY_ANIM_NAMES, function(direction, update)
            hyAnimSelect(direction)
            update(tostring(hyAnimPreset))
        end)
    end
    hyAnimToggleSet = mkToggle(visualsPage, "Animaciones", function(on)
        hyAnimSetOn(on)
    end)
    hyAnimToggleSet(hyAnimOn)
    do
        local row = mkRow(visualsPage, 42)
        mkLabel(row, "Outfit")
        sizeRowLabel(row, 164)
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 144, 1, 0)
        container.Position = UDim2.new(1, -156, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 26, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.10
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        MVPUI.styleArrow(leftBtn)
        outfitSelectorLabel = Instance.new("TextLabel", container)
        outfitSelectorLabel.Size = UDim2.new(1, -64, 0, 26)
        outfitSelectorLabel.Position = UDim2.new(0, 32, 0.5, -13)
        outfitSelectorLabel.BackgroundTransparency = 1
        outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label
        outfitSelectorLabel.TextColor3 = WHITE
        outfitSelectorLabel.Font = Enum.Font.GothamBold
        outfitSelectorLabel.TextSize = 12
        outfitSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        outfitSelectorLabel.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 26, 0, 26)
        rightBtn.Position = UDim2.new(1, -26, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.10
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        MVPUI.styleArrow(rightBtn)
        local function updateOutfit(direction)
            pcall(VX7A.stop)
            local newIdx = currentOutfitIndex + direction
            if newIdx < 1 then newIdx = #OUTFITS end
            if newIdx > #OUTFITS then newIdx = 1 end
            currentOutfitIndex = newIdx
            pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
            if outfitSelectorLabel then outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label end
            saveAllSettings()
        end
        leftBtn.MouseButton1Click:Connect(function() updateOutfit(-1) end)
        rightBtn.MouseButton1Click:Connect(function() updateOutfit(1) end)
    end


    mkSect(visualsPage, "Effects")
    setVividVisual = mkToggle(visualsPage, "Vivid Graphics", function(on)
        toggleVividGraphics(on)
        if setVividVisual then setVividVisual(on) end
    end)
    if setVividVisual then setVividVisual(vividGraphicsEnabled) end
    do
        local row = mkRow(visualsPage, 42)
        mkLabel(row, "Stretch Rez")
        local stretchPill, stretchDot = mkPill(row, 48)
        local stretchOn = false
        local function setStretch(s)
            stretchOn = s
            animPill(stretchPill, stretchDot, s)
            if s then enableStretch() else disableStretch() end
            stretchEnabled = s
        end
        local stretchClk = Instance.new("TextButton", stretchPill)
        stretchClk.Size = UDim2.new(1,0,1,0)
        stretchClk.BackgroundTransparency = 1
        stretchClk.Text = ""
        stretchClk.AutoButtonColor = false
        stretchClk.ZIndex = 10
        stretchClk.MouseButton1Click:Connect(function() setStretch(not stretchOn) end)
        _G.stretchToggleSetter = setStretch
    end
    setAntiLagVisual = mkToggle(visualsPage, "Anti Lag", function(on)
        if on then enableAntiLag() else disableAntiLag() end
        antiLagEnabled = on == true
        pcall(saveAllSettings, true)
    end)
    do
        local baseTargets={Base=true,PlotSign=true,FriendPanel=true,Cash=true,Laser=true,Decorations=true,Skin=true,Unlock=true,Purchases=true}
        local baseOriginal=setmetatable({},{__mode="k"})
        local baseConn=nil
        local baseXRayEnabled=false
        local function belongsToBase(object)
            local parent=object
            while parent and parent~=Workspace do
                if baseTargets[parent.Name] then return true end
                parent=parent.Parent
            end
            return false
        end
        local function applyBaseXRay(object)
            if not (object:IsA("BasePart") or object:IsA("Decal") or object:IsA("Texture")) or not belongsToBase(object) then return end
            if baseOriginal[object]==nil then baseOriginal[object]=object.Transparency end
            pcall(function() object.Transparency=math.max(baseOriginal[object] or 0,0.5) end)
        end
        local function setBaseXRay(on)
            baseXRayEnabled=on==true
            if baseConn then baseConn:Disconnect(); baseConn=nil end
            if baseXRayEnabled then
                for _,object in ipairs(Workspace:GetDescendants()) do applyBaseXRay(object) end
                baseConn=Workspace.DescendantAdded:Connect(function(object)
                    task.defer(function() if baseXRayEnabled then applyBaseXRay(object) end end)
                end)
            else
                for object,transparency in pairs(baseOriginal) do
                    if object and object.Parent then pcall(function() object.Transparency=transparency end) end
                end
                table.clear(baseOriginal)
            end
        end
        setBaseXRayVisual=mkToggle(visualsPage,"Base X-Ray",setBaseXRay)
    end
    do
        local row = mkRow(visualsPage, 42)
        mkLabel(row, "Sky Theme")
        sizeRowLabel(row, 164)
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 144, 1, 0)
        container.Position = UDim2.new(1, -156, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 26, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.10
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        MVPUI.styleArrow(leftBtn)
        skySelectorLabel = Instance.new("TextLabel", container)
        skySelectorLabel.Size = UDim2.new(1, -64, 0, 26)
        skySelectorLabel.Position = UDim2.new(0, 32, 0.5, -13)
        skySelectorLabel.BackgroundTransparency = 1
        skySelectorLabel.Text = skyTheme
        skySelectorLabel.TextColor3 = WHITE
        skySelectorLabel.Font = Enum.Font.GothamBold
        skySelectorLabel.TextSize = 11
        skySelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        skySelectorLabel.ZIndex = 9
        skySelectorLabel.TextScaled = true
        do
            local c = Instance.new("UITextSizeConstraint", skySelectorLabel)
            c.MaxTextSize = 11
            c.MinTextSize = 7
        end
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 26, 0, 26)
        rightBtn.Position = UDim2.new(1, -26, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.10
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        MVPUI.styleArrow(rightBtn)
        local function updateSkySelector(direction)
            local idx = 1
            for i, name in ipairs(SKY_PRESETS_LIST) do
                if name == skyTheme then idx = i; break end
            end
            local newIdx = idx + direction
            if newIdx < 1 then newIdx = #SKY_PRESETS_LIST end
            if newIdx > #SKY_PRESETS_LIST then newIdx = 1 end
            local name = SKY_PRESETS_LIST[newIdx]
            skyTheme = name
            pcall(applyCustomSky, name)
            if skySelectorLabel then skySelectorLabel.Text = name end
            pcall(saveAllSettings, true)
        end
        leftBtn.MouseButton1Click:Connect(function() updateSkySelector(-1) end)
        rightBtn.MouseButton1Click:Connect(function() updateSkySelector(1) end)
    end


    mkSect(visualsPage, "Overlays")
    setESPVIsual = mkToggle(visualsPage, "Player ESP", function(on) toggleESP(on) end)
    setESPLineVisual = mkToggle(visualsPage, "ESP Line", function(on)
        if on then startESPLine() else stopESPLine() end
    end)

    end

    local visualPage = contentPages["Visual"]

    mkSect(visualPage, "Interface")
    setLockUIVisual = mkToggle(visualPage, "Lock UI", function(on) toggleLockUI(on) end)
    setHideButtonsVisual = mkToggle(visualPage, "Hide Button", function(on) toggleHideButtons(on) end)
    if setHideButtonsVisual then setHideButtonsVisual(hideButtonsEnabled) end

    mkSect(visualPage, "Display")
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "UI Scale")
        uiScaleBox = mkBox(row, uiScaleValue, 50, 56, function(v)
            local n = _clamp(_floor(v+0.5), 50, 150)
            uiScaleValue = n
            if MVPUI.fit then MVPUI.fit() end
            if pbScale then pbScale.Scale = n/100 end
        end)
    end
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Button Scale")
        local box = mkBox(row, _floor(floatingButtonScale * 100), 50, 56, function(v)
            local val = _clamp(v, 50, 200)
            floatingButtonScale = val / 100
            applyFloatingButtonScale()
            saveAllSettings()
        end)
        MVPUI.buttonScaleBox = box
    end
    do
        local row = mkRow(visualPage, 46)
        mkLabel(row, "Button Style")
        local function styleIndex()
            for i, v in ipairs(FLOATING_BUTTON_STYLE_IDS) do
                if v == floatingButtonStyle then return i end
            end
            return 1
        end
        MVPUI.buttonStyleLabel = mkSelector(row, FLOATING_BUTTON_STYLE_NAMES[styleIndex()], FLOATING_BUTTON_STYLE_NAMES, function(direction, update)
            local i = styleIndex() + direction
            if i < 1 then i = #FLOATING_BUTTON_STYLE_IDS elseif i > #FLOATING_BUTTON_STYLE_IDS then i = 1 end
            setFloatingButtonStyle(FLOATING_BUTTON_STYLE_IDS[i])
            update(FLOATING_BUTTON_STYLE_NAMES[i])
        end)
    end

    local configPage = contentPages["Visuals"]

    -- Se conserva una sola forma fija de botón: rounded, estilo VISIBLE.
    floatingButtonShape = "rounded"
    mkSect(configPage, "Automation")

    local mkToggleOrange = mkToggle

    setInstaGrab = mkToggleOrange(configPage, "Auto Steal", function(on)
        CONFIG.AUTO_STEAL_ENABLED = on == true
        if on then pcall(startAutoSteal) else stopAutoSteal() end
        if stealHud.toggle and stealHud.toggle.Parent then stealHud.toggle.Text = on and "ON" or "OFF" end
        updateProgressBarVisibility()
        pcall(saveAllSettings, true)
    end)
    do
        local row = mkRow(configPage, 46)
        mkLabel(row, "Auto Steal Mode")
        autoStealModeBtn = mkSelector(row, autoStealMode, AUTO_STEAL_VARIANT_NAMES, function(direction, update)
            local index = (autoStealVariant - 1 + direction) % #AUTO_STEAL_VARIANT_NAMES + 1
            local enabled = CONFIG.AUTO_STEAL_ENABLED
            if enabled then stopAutoSteal() end
            setAutoStealMode(AUTO_STEAL_VARIANT_NAMES[index])
            update(autoStealMode)
            if enabled then startAutoSteal() end
        end)
    end

    do
        local row = mkRow(configPage, 42)
        mkLabel(row, "Steal Radius")
        radInput = mkBox(row, CONFIG.STEAL_RANGE, 50, 56, function(v)
            if v and v >= 5 and v <= 300 then
                CONFIG.STEAL_RANGE = _floor(v+0.5)
                Steal.StealRadius = CONFIG.STEAL_RANGE
                radInput.Text = tostring(CONFIG.STEAL_RANGE)
                if stealHud.radius and stealHud.radius.Parent then stealHud.radius.Text = "Radius: " .. tostring(CONFIG.STEAL_RANGE) end
                saveAllSettings()
            end
        end)
    end


    mkSect(configPage, "Music")
    do
        local songs = {
            {name="LAGUNAS", artist="Peso Pluma, Jasiel Nuñez", url="https://file.garden/algLafWA1jk8WMfK/LAGUNAS_spotdown.org.mp3", file="FearHubJukebox_01_Lagunas.mp3"},
            {name="Misery Slowed + Reverb", artist="A7AX", url="https://file.garden/algLafWA1jk8WMfK/Misery%20-%20Remix%20Slowed%2BReverb_spotdown.org.mp3", file="FearHubJukebox_02_Misery.mp3"},
            {name="Tusa", artist="KAROL G, Nicki Minaj", url="https://file.garden/algLafWA1jk8WMfK/Tusa_spotdown.org.mp3", file="FearHubJukebox_03_Tusa.mp3"},
            {name="Orula", artist="Victor Mendivil", url="https://files.catbox.moe/v20ko9.mp3", file="FearHubJukebox_04_Orula.mp3"},
            {name="X.O.X.O", artist="Pedro Calderón, D' La Crem", url="https://files.catbox.moe/jghp0f.mp3", file="M4LWAREJukebox_05_XOXO.mp3"},
            {name="Beretta", artist="El De Las R's", url="https://file.garden/algLafWA1jk8WMfK/Beretta%20-%20video%20oficial(MP3_160K).mp3", file="FearHubJukebox_06_Beretta.mp3"},
            {name="Took Her To The O", artist="King Von", url="https://file.garden/algLafWA1jk8WMfK/King%20Von%20-%20Took%20Her%20To%20The%20O%20(Lyrics)(MP3_160K).mp3", file="FearHubJukebox_07_TookHerToTheO.mp3"},
            {name="LAJA - NADIE TA FRIO", artist="LAJA", url="https://file.garden/algLafWA1jk8WMfK/LAJA%20-%20NADIE%20TA%20FRIO%20(Letra)(MP3_160K).mp3", file="FearHubJukebox_08_Laja.mp3"},
            {name="HORA CERO", artist="Myke Towers", url="https://file.garden/algLafWA1jk8WMfK/Myke%20Towers%20-%20HORA%20CERO%20(Lyrics)(MP3_160K).mp3", file="FearHubJukebox_09_HoraCero.mp3"},
            {name="Bling Bling", artist="Grupo Marca Registrada, Octavio Cuadras", url="https://file.garden/algLafWA1jk8WMfK/Bling%20Bling_spotdown.org.mp3", file="FearHubJukebox_10_BlingBling.mp3"},
            {name="Lucid Dreams (Clean)", artist="Juice WRLD", url="https://file.garden/algLafWA1jk8WMfK/Lucid%20Dreams%20-%20Clean%20-%20Juice%20WRLD(MP3_160K).mp3", file="FearHubJukebox_11_LucidDreams.mp3"},
            {name="Un Pacto", artist="Victor Mendivil, El Padrinito Toys", url="https://file.garden/algLafWA1jk8WMfK/Un%20Pacto_spotdown.org.mp3", file="FearHubJukebox_12_UnPacto.mp3"},
            {name="La diabla", artist="Xavi", url="https://file.garden/algLafWA1jk8WMfK/La%20Diabla_spotdown.org.mp3", file="FearHubJukebox_13_LaDiabla.mp3"},
            {name="Kamikaze", artist="Natanael Cano, Uriel Gaxiola, Ganggy, Victor Mendivil", url="https://file.garden/algLafWA1jk8WMfK/Kamikaze%20(feat.%20Victor%20Mendivil)_spotdown.org.mp3", file="FearHubJukebox_14_Kamikaze.mp3"},
            {name="Triple lavada", artist="Esau Ortiz, Luis R Conriquez, Oscar Maydon, Alemán, Victor Mendivil", url="https://file.garden/algLafWA1jk8WMfK/Triple%20Lavada%20%28feat.%20Victor%20Mendivil%29%20-%20Remix_spotdown.org.mp3", file="FearHubJukebox_15_TripleLavada_v3.mp3"},
            {name="Dopamina", artist="Peso Pluma, Tito Double P", url="https://file.garden/algLafWA1jk8WMfK/dopamina_spotdown.org.mp3", file="FearHubJukebox_16_Dopamina.mp3"},
            {name="You", artist="Tiagz, Victor Mendivil", url="https://file.garden/algLafWA1jk8WMfK/You_spotdown.org.mp3", file="FearHubJukebox_17_You.mp3"},
            {name="PRESIDENTE", artist="Gabito Ballesteros, Natanael Cano, Luis R Conriquez, Neton Vega", url="https://file.garden/algLafWA1jk8WMfK/PRESIDENTE_spotdown.org.mp3", file="FearHubJukebox_18_Presidente.mp3"},
            {name="El Drip", artist="Natanael Cano", url="https://file.garden/algLafWA1jk8WMfK/El%20Drip_spotdown.org.mp3", file="FearHubJukebox_19_ElDrip.mp3"},
            {name="Por Mi Zona", artist="La Santa Grifa", url="https://file.garden/algLafWA1jk8WMfK/Por%20Mi%20Zona_spotdown.org.mp3", file="FearHubJukebox_20_PorMiZona.mp3"},
            {name="Cachondos Session #1", artist="Kevin AMF, Victor Mendivil, Dani Flow, Sebastian Esquivel, Eugenio Esquivel, Tiagz, Los Esquivel", url="https://file.garden/algLafWA1jk8WMfK/Cachondos%20Session%20%231%20(feat.%20Sebastian%20Esquivel%2C%20Eugenio%20Esquivel%2C%20Tiagz%20%26%20Los%20Esquivel)_spotdown.org.mp3", file="FearHubJukebox_21_CachondosSession1.mp3"},
            {name="Jacobo Grinberg", artist="Victor Mendivil", url="https://file.garden/algLafWA1jk8WMfK/Jacobo%20Grinberg_spotdown.org.mp3", file="FearHubJukebox_22_JacoboGrinberg.mp3"},
            {name="Punta Cana", artist="Victor Mendivil, Kevin AMF", url="https://file.garden/algLafWA1jk8WMfK/Punta%20Cana_spotdown.org.mp3", file="FearHubJukebox_23_PuntaCana.mp3"},
            {name="King of Watches", artist="Omar Camacho", url="https://file.garden/algLafWA1jk8WMfK/King%20of%20Watches_spotdown.org%202.mp3", file="FearHubJukebox_24_KingOfWatchesOmar.mp3"},
            {name="King of Watches", artist="Victor Mendivil, Neton Vega", url="https://file.garden/algLafWA1jk8WMfK/King%20of%20Watches_spotdown.org.mp3", file="FearHubJukebox_31_KingOfWatchesVictor.mp3"},
            {name="Don Dimadon", artist="Remp, Oscar Maydon, Victor Mendivil, Sintapia", url="https://file.garden/algLafWA1jk8WMfK/Don%20Dimadon_spotdown.org.mp3", file="FearHubJukebox_25_DonDimadon.mp3"},
            {name="Singapur (Remix)", artist="El Alfa, Chencho Corleone, Farruko, Justin Quiles, Myke Towers", url="https://file.garden/algLafWA1jk8WMfK/Singapur%20(Remix)_spotdown.org.mp3", file="FearHubJukebox_26_SingapurRemix.mp3"},
            {name="Without Me", artist="Eminem", url="https://file.garden/algLafWA1jk8WMfK/Without%20Me_spotdown.org.mp3", file="FearHubJukebox_27_WithoutMe.mp3"},
            {name="3 AM", artist="Jimmy Guzman, Omar Camacho", url="https://file.garden/algLafWA1jk8WMfK/3%20AM_spotdown.org.mp3", file="FearHubJukebox_28_3AM.mp3"},
            {name="STARGAZING", artist="Travis Scott", url="https://file.garden/algLafWA1jk8WMfK/STARGAZING_spotdown.org.mp3", file="FearHubJukebox_29_Stargazing.mp3"},
            {name="Gané", artist="Victor Mendivil, Gabito Ballesteros", url="https://file.garden/algLafWA1jk8WMfK/Gane%CC%81_spotdown.org.mp3", file="FearHubJukebox_30_Gane.mp3"},
            {name="Te Lo Doy", artist="Tiagz, El Malilla, El Bogueto", url="https://file.garden/algLafWA1jk8WMfK/Te%20Lo%20Doy_spotdown.org.mp3", file="FearHubJukebox_32_TeLoDoy.mp3"},
            {name="Gramos", artist="Jimmy Guzman", url="https://file.garden/algLafWA1jk8WMfK/Gramos_spotdown.org.mp3", file="FearHubJukebox_33_Gramos.mp3"},
            {name="GOET", artist="Victor Mendivil", url="https://file.garden/algLafWA1jk8WMfK/GOET_spotdown.org.mp3", file="FearHubJukebox_34_GOET.mp3"},
            {name="Mercenarios", artist="Capo, Victor Mendivil", url="https://file.garden/algLafWA1jk8WMfK/Mercenarios_spotdown.org.mp3", file="FearHubJukebox_35_Mercenarios.mp3"},
            {name="Emparejé", artist="Russo, Luis R Conriquez", url="https://file.garden/algLafWA1jk8WMfK/Empareje%CC%81_spotdown.org.mp3", file="FearHubJukebox_36_Empareje.mp3"},
            {name="squabble up", artist="Kendrick Lamar", url="https://file.garden/algLafWA1jk8WMfK/squabble%20up_spotdown.org.mp3", file="FearHubJukebox_37_SquabbleUp.mp3"},
            {name="ROSA PASTEL", artist="Peso Pluma, Jasiel Nuñez", url="https://file.garden/algLafWA1jk8WMfK/ROSA%20PASTEL_spotdown.org.mp3", file="FearHubJukebox_38_RosaPastel.mp3"},
            {name="LUNA", artist="Peso Pluma, Junior H", url="https://file.garden/algLafWA1jk8WMfK/LUNA_spotdown.org.mp3", file="FearHubJukebox_39_Luna.mp3"},
            {name="NUEVA VIDA", artist="Peso Pluma", url="https://file.garden/algLafWA1jk8WMfK/NUEVA%20VIDA_spotdown.org.mp3", file="FearHubJukebox_40_NuevaVida.mp3"},
            {name="Juan Martha", artist="La Original Banda El Limón de Salvador Lizárraga, Julio Preciado", url="https://file.garden/algLafWA1jk8WMfK/Juan%20Martha_spotdown.org.mp3", file="FearHubJukebox_41_JuanMartha.mp3"},
            {name="Rojo Vivo", artist="Jesus Parra", url="https://file.garden/algLafWA1jk8WMfK/Rojo%20Vivo_spotdown.org.mp3", file="FearHubJukebox_42_RojoVivo.mp3"},
            {name="Vuelvo Mejor - Remix", artist="NTG, Arcángel", url="https://file.garden/algLafWA1jk8WMfK/Vuelvo%20Mejor%20-%20Remix_spotdown.org.mp3", file="FearHubJukebox_43_VuelvoMejorRemix.mp3"},
            {name="DEMBOW BÉLICO", artist="Tito Double P, Joel De La P, Luis R Conriquez", url="https://file.garden/algLafWA1jk8WMfK/DEMBOW%20BE%CC%81LICO_spotdown.org.mp3", file="FearHubJukebox_44_DembowBelico.mp3"},
            {name="No Nací Para Caerle Bien", artist="La Santa Grifa", url="https://file.garden/algLafWA1jk8WMfK/No%20Naci%CC%81%20Para%20Caerle%20Bien_spotdown.org.mp3", file="FearHubJukebox_45_NoNaciParaCaerleBien.mp3"},
            {name="Alaska", artist="Victor Mendivil, Hades66", url="https://file.garden/algLafWA1jk8WMfK/Alaska_spotdown.org.mp3", file="FearHubJukebox_46_Alaska.mp3"},
            {name="Tony Montana", artist="Victor Mendivil, Yng Lvcas", url="https://file.garden/algLafWA1jk8WMfK/Tony%20Montana_spotdown.org.mp3", file="FearHubJukebox_47_TonyMontana.mp3"},
            {name="Amnesia", artist="La Santa Grifa", url="https://file.garden/algLafWA1jk8WMfK/Amnesia_spotdown.org.mp3", file="FearHubJukebox_48_Amnesia.mp3"},
            {name="Mal Ejemplo", artist="La Santa Grifa", url="https://file.garden/algLafWA1jk8WMfK/Mal%20Ejemplo_spotdown.org.mp3", file="FearHubJukebox_49_MalEjemplo.mp3"},
            {name="Cholo 2", artist="Victor Mendivil, Eladio Carrion", url="https://file.garden/algLafWA1jk8WMfK/Cholo%202_spotdown.org.mp3", file="FearHubJukebox_50_Cholo2.mp3"},
            {name="OLIVIA LA FLAKA", artist="Natanael Cano, Tito Double P, Victor Mendivil, Ovi", url="https://file.garden/algLafWA1jk8WMfK/SpotiDownloader.com%20-%20OLIVIA%20LA%20FLAKA%20-%20Natanael%20Cano.mp3", file="FearHubJukebox_51_OliviaLaFlaka.mp3"},
            {name="redrum", artist="21 Savage", url="https://file.garden/algLafWA1jk8WMfK/redrum_spotdown.org%202.mp3", file="Visible_Redrum.mp3"},
            {name="Paris Hilton", artist="$HUPE, Victor Mendivil", url="https://file.garden/algLafWA1jk8WMfK/Paris%20Hilton_spotdown.org.mp3", file="Visible_ParisHilton.mp3"},
            {name="Dandy Hats", artist="El Rabbanito", url="https://file.garden/algLafWA1jk8WMfK/Dandy%20Hats_spotdown.org.mp3", file="Visible_DandyHats.mp3"},
            {name="Mi Terre CLN", artist="Fuerza Regida, Juanpa Salazar", url="https://file.garden/algLafWA1jk8WMfK/Mi%20Terre%20CLN_spotdown.org.mp3", file="Visible_MiTerreCLN.mp3"},
            {name="CARNIVAL", artist="Visible", url="https://file.garden/algLafWA1jk8WMfK/CARNIVAL_spotdown.org.mp3", file="MVP_Carnival.mp3"},
            {name="El Black", artist="Visible", url="https://file.garden/algLafWA1jk8WMfK/El%20Black_spotdown.org.mp3", file="MVP_ElBlack.mp3"},
            {name="Me Paseo", artist="Visible", url="https://file.garden/algLafWA1jk8WMfK/Me%20Paseo_spotdown.org.mp3", file="MVP_MePaseo.mp3"},
            {name="Ayo & Rolex", artist="Visible Hub", url="https://litter.catbox.moe/czrqikr2tsdgcpp6.mp3", file="Ayo_Rolex.mp3"},
            {name="A New king of love", artist="Visible Hub", url="https://mp3tourl.com/audio/1794985247563-86093764-154c-4319-bdfd-0c8c6b1d2590.mp3", file="A_New_king_of_love.mp3"},
            {name="Cansada", artist="Visible", url="https://files.manuscdn.com/user_upload_by_module/session_file/310519664041085477/IBfwsNRTmZJnsyV.mp3", file="Cansada.mp3"}
        }
        local openRow=mkRow(configPage,52)
        mkLabel(openRow,"Music Player"); sizeRowLabel(openRow,120)
        local openMusic=MVPUI.new("TextButton",openRow,{Name="OpenVisibleMusic",Size=UDim2.fromOffset(100,32),
            AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-10,0.5,0),
            Text="OPEN",TextSize=12,Font=Enum.Font.GothamBold,TextColor3=Color3.fromRGB(14,14,16),
            BackgroundColor3=Color3.fromRGB(255,255,255),BorderSizePixel=0,AutoButtonColor=false,ZIndex=8})
        MVPUI.round(openMusic,3)
        pcall(function() local old=pgui:FindFirstChild("VisibleVisibleMusic"); if old then old:Destroy() end end)

        -- ===== NUEVO PANEL DE MUSICA (v6): botones cuadrados, texto normal, busqueda online + descarga =====
        local IMG_LOGO="rbxassetid://95840824836070"
        local IMG_COVER="rbxassetid://106655564255273"
        local MusicHttp=game:GetService("HttpService")
        local INDEX_FILE="VisibleMusic_index.json"
        local function rgb(r,g,b) return Color3.fromRGB(r,g,b) end
        local function N(class,parent,props)
            local o=Instance.new(class)
            for k,v in pairs(props or {}) do o[k]=v end
            o.Parent=parent; return o
        end
        local function corner(o,r) Instance.new("UICorner",o).CornerRadius=UDim.new(0,r or 3) end
        local function label(parent,text,x,y,w,ts,col,font,align)
            return N("TextLabel",parent,{BackgroundTransparency=1,Text=text,Position=UDim2.fromOffset(x,y),Size=w,TextSize=ts or 11,TextColor3=col or rgb(240,240,244),Font=font or Enum.Font.Gotham,TextXAlignment=align or Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd})
        end
        local function sqBtn(parent,text,pos,size,bg,fg,ts)
            local b=N("TextButton",parent,{Text=text,Position=pos,Size=size,BackgroundColor3=bg or rgb(30,31,35),TextColor3=fg or rgb(240,240,244),Font=Enum.Font.GothamBold,TextSize=ts or 10,BorderSizePixel=0,AutoButtonColor=true})
            corner(b,3)
            local st=N("UIStroke",b,{Color=rgb(90,92,100),Transparency=.55,Thickness=1})
            return b
        end

        local panel
        local musicGui=N("ScreenGui",pgui,{Name="VisibleVisibleMusic",ResetOnSpawn=false,IgnoreGuiInset=true,DisplayOrder=9990,ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
        panel=N("Frame",musicGui,{Name="VisibleMusicPanel",Size=UDim2.fromOffset(720,440),AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),BackgroundColor3=rgb(12,12,14),BorderSizePixel=0,Visible=false,ClipsDescendants=true})
        local musicPanelScale=N("UIScale",panel,{Scale=.8})
        corner(panel,5)
        N("UIStroke",panel,{Color=rgb(245,245,245),Transparency=.6,Thickness=1.3})

        -- barra lateral
        local side=N("Frame",panel,{Size=UDim2.new(0,166,1,-88),BackgroundColor3=rgb(7,7,9),BorderSizePixel=0})
        local logo=N("ImageLabel",side,{Name="Logo",Size=UDim2.fromOffset(34,34),Position=UDim2.fromOffset(12,12),BackgroundColor3=rgb(24,25,28),BorderSizePixel=0,Image=IMG_LOGO,ScaleType=Enum.ScaleType.Crop})
        corner(logo,3)
        label(side,"VISIBLE Music",54,12,UDim2.new(1,-62,0,34),13,rgb(245,245,248),Enum.Font.GothamBold)
        label(side,"Menu",12,58,UDim2.new(1,-24,0,16),10,rgb(150,153,160),Enum.Font.GothamBold)

        local view="library"; local favorites={}; local playlist={}; local nav={}
        local function makeNav(key,text,y)
            local b=N("TextButton",side,{Name="Nav_"..key,Size=UDim2.new(1,-20,0,32),Position=UDim2.fromOffset(10,y),BackgroundColor3=rgb(7,7,9),BorderSizePixel=0,Text=text,TextColor3=rgb(175,178,185),Font=Enum.Font.GothamBold,TextSize=11,AutoButtonColor=false,TextXAlignment=Enum.TextXAlignment.Left})
            N("UIPadding",b,{PaddingLeft=UDim.new(0,10)})
            corner(b,3)
            nav[key]=b; return b
        end
        local navLibrary=makeNav("library","Library",78)
        local navLiked=makeNav("liked","Liked",114)
        local navPlaylist=makeNav("playlist","Playlist",150)
        local navOnline=makeNav("online","Search Online",186)

        -- zona principal
        local main=N("Frame",panel,{Size=UDim2.new(1,-166,1,-88),Position=UDim2.fromOffset(166,0),BackgroundColor3=rgb(14,14,17),BorderSizePixel=0})
        local header=N("TextButton",main,{Name="MusicDragHandle",Size=UDim2.new(1,-330,0,26),Position=UDim2.fromOffset(18,12),BackgroundTransparency=1,BorderSizePixel=0,Text="Library",TextColor3=rgb(248,248,250),Font=Enum.Font.GothamBold,TextSize=18,TextXAlignment=Enum.TextXAlignment.Left,AutoButtonColor=false,Active=true,Selectable=false,ZIndex=6})
        local info=label(main,"",18,40,UDim2.new(1,-36,0,14),10,rgb(150,153,160))
        local queryBox=N("TextBox",main,{Size=UDim2.new(1,-134,0,30),Position=UDim2.fromOffset(18,60),BackgroundColor3=rgb(24,25,28),BorderSizePixel=0,PlaceholderText="Filter songs",Text="",TextColor3=rgb(245,245,248),PlaceholderColor3=rgb(145,148,155),Font=Enum.Font.Gotham,TextSize=11,ClearTextOnFocus=false,TextXAlignment=Enum.TextXAlignment.Left})
        corner(queryBox,3); N("UIPadding",queryBox,{PaddingLeft=UDim.new(0,8)})
        local searchBtn=sqBtn(main,"Search",UDim2.new(1,-106,0,60),UDim2.fromOffset(88,30),rgb(245,245,245),rgb(10,10,12),11)
        searchBtn.Visible=false
        local list=N("ScrollingFrame",main,{Name="SongList",Size=UDim2.new(1,-24,1,-104),Position=UDim2.fromOffset(12,98),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=rgb(245,245,245),AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new()})
        local layout=N("UIListLayout",list,{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder})

        -- botones de ventana
        local close=sqBtn(panel,"Close",UDim2.new(1,-62,0,8),UDim2.fromOffset(54,26),rgb(30,31,34),nil,10)
        local minimize=sqBtn(panel,"Min",UDim2.new(1,-122,0,8),UDim2.fromOffset(54,26),rgb(30,31,34),nil,10)
        minimize.Name="MinimizeMusic"
        local sizeTag=label(panel,"Size",0,0,UDim2.fromOffset(30,26),10,rgb(190,190,196),Enum.Font.GothamBold,Enum.TextXAlignment.Center)
        sizeTag.Position=UDim2.new(1,-196,0,8); sizeTag.Name="SizeLabel"
        local sizeInput=N("TextBox",panel,{Name="SizeLevel",Size=UDim2.fromOffset(38,26),Position=UDim2.new(1,-164,0,8),BackgroundColor3=rgb(28,28,31),BorderSizePixel=0,Text="3",PlaceholderText="1-10",TextColor3=rgb(245,245,248),Font=Enum.Font.GothamBold,TextSize=11,ClearTextOnFocus=false})
        corner(sizeInput,3)
        local minimized=false; local movedByUser=false; local musicSizeLevel=3
        local function applyMusicSize()
            local camera=workspace.CurrentCamera
            local viewport=camera and camera.ViewportSize or Vector2.new(1280,720)
            local baseW=minimized and 520 or 720; local baseH=minimized and 88 or 440
            local desired=.5+musicSizeLevel*.1
            local maxFit=math.max(.25,math.min(1.5,(viewport.X-20)/baseW,(viewport.Y-20)/baseH))
            musicPanelScale.Scale=math.min(desired,maxFit)
            if movedByUser then
                local current=panel.AbsolutePosition; local w=baseW*musicPanelScale.Scale; local h=baseH*musicPanelScale.Scale
                local cx=math.clamp(current.X+panel.AbsoluteSize.X/2,60-w/2,viewport.X-60+w/2)
                local cy=math.clamp(current.Y+panel.AbsoluteSize.Y/2,60-h/2,viewport.Y-60+h/2)
                panel.Position=UDim2.fromOffset(cx,cy)
            end
        end
        sizeInput.FocusLost:Connect(function()
            local value=tonumber(sizeInput.Text) or musicSizeLevel
            musicSizeLevel=math.clamp(math.floor(value+.5),1,10); sizeInput.Text=tostring(musicSizeLevel); applyMusicSize()
        end)
        local dragInput,dragStart,dragCenter=nil,nil,nil
        local function beginDrag(input)
            if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
            dragInput=input; dragStart=input.Position
            dragCenter=panel.AbsolutePosition+panel.AbsoluteSize/2
            input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragInput=nil end end)
        end
        header.InputBegan:Connect(beginDrag); panel.InputBegan:Connect(beginDrag)
        UIS.InputChanged:Connect(function(input)
            if not dragInput then return end
            if input.UserInputType~=Enum.UserInputType.MouseMovement and input~=dragInput then return end
            local camera=workspace.CurrentCamera; local viewport=camera and camera.ViewportSize or Vector2.new(1280,720)
            local delta=input.Position-dragStart; local half=panel.AbsoluteSize/2
            local keep=60
            panel.Position=UDim2.fromOffset(math.clamp(dragCenter.X+delta.X,keep-half.X,viewport.X-keep+half.X),math.clamp(dragCenter.Y+delta.Y,keep-half.Y,viewport.Y-keep+half.Y))
            movedByUser=true
        end)

        -- reproductor (parte inferior)
        local footer=N("Frame",panel,{Size=UDim2.new(1,0,0,88),Position=UDim2.new(0,0,1,-88),BackgroundColor3=rgb(6,6,8),BorderSizePixel=0})
        N("Frame",footer,{Size=UDim2.new(1,0,0,1),BackgroundColor3=rgb(48,49,54),BorderSizePixel=0})
        local nowCover=N("ImageLabel",footer,{Name="NowPlayingCover",Size=UDim2.fromOffset(52,52),Position=UDim2.fromOffset(16,18),BackgroundColor3=rgb(28,28,31),BorderSizePixel=0,Image=IMG_COVER,ScaleType=Enum.ScaleType.Crop})
        corner(nowCover,3)
        local nowTitle=label(footer,"Choose a song",78,24,UDim2.new(0,190,0,20),12,rgb(245,245,248),Enum.Font.GothamBold)
        local nowArtist=label(footer,"VISIBLE Music",78,46,UDim2.new(0,190,0,18),10,rgb(155,158,165))
        local prev=sqBtn(footer,"Prev",UDim2.new(.5,-84,.5,-16),UDim2.fromOffset(52,32),rgb(24,25,28),nil,11)
        local play=sqBtn(footer,"Play",UDim2.new(.5,-26,.5,-16),UDim2.fromOffset(60,32),rgb(245,245,245),rgb(0,0,0),11)
        local nextBtn=sqBtn(footer,"Next",UDim2.new(.5,40,.5,-16),UDim2.fromOffset(52,32),rgb(24,25,28),nil,11)
        local trackStatus=label(footer,"Select a track",0,0,UDim2.new(0,140,0,20),10,rgb(245,245,245),Enum.Font.GothamBold,Enum.TextXAlignment.Right)
        trackStatus.Position=UDim2.new(1,-154,.5,-10)

        -- biblioteca: canciones incluidas + descargadas
        local saved={}
        pcall(function()
            if type(isfile)=="function" and isfile(INDEX_FILE) then
                local data=MusicHttp:JSONDecode(readfile(INDEX_FILE))
                for _,s in ipairs(data) do
                    if type(s)=="table" and s.file and s.name and (type(isfile)~="function" or isfile(s.file)) then saved[#saved+1]={name=s.name,artist=s.artist or "Unknown",file=s.file,url=s.url} end
                end
            end
        end)
        local function writeIndex()
            pcall(function() if type(writefile)=="function" then writefile(INDEX_FILE,MusicHttp:JSONEncode(saved)) end end)
        end
        local function isSaved(song) for _,s in ipairs(saved) do if s.file==song.file then return true end end return false end
        local onlineResults={}
        local shown={}; local rowRefs={}; local currentIndex=nil; local currentSong=nil
        local refreshPlayer

        local function ensureFile(song)
            assert(type(writefile)=="function" and type(isfile)=="function","file functions unavailable")
            if not isfile(song.file) then
                assert(song.url and song.url~="","no url")
                local data=game:HttpGet(song.url)
                assert(type(data)=="string" and #data>256,"audio download failed")
                writefile(song.file,data)
            end
        end
        local function playItem(index)
            if #shown==0 then return end
            index=math.clamp(index,1,#shown); local song=shown[index]
            local current=mvpFullRedrumSound
            if current and current.Name==song.file and current.Playing then stopMVPFullRedrum(); nowTitle.Text="Choose a song"; nowArtist.Text="VISIBLE Music"; refreshPlayer(); return end
            stopMVPFullRedrum(); currentIndex=index; currentSong=song
            trackStatus.Text="Loading..."; nowTitle.Text=song.name; nowArtist.Text=song.artist
            local token=mvpMusicRequest
            task.spawn(function()
                local ok,err=pcall(function()
                    local loader=getcustomasset or getsynasset
                    assert(type(loader)=="function","custom assets unavailable")
                    ensureFile(song)
                    local asset=loader(song.file); if token~=mvpMusicRequest then return end
                    local sound=Instance.new("Sound"); sound.Name=song.file; sound.SoundId=asset; sound.Volume=.85; sound.Looped=false; sound.Parent=SoundService
                    mvpFullRedrumSound=sound
                    sound.Ended:Connect(function()
                        if mvpFullRedrumSound==sound then
                            mvpFullRedrumSound=nil
                            if currentIndex and currentIndex<#shown and shown[currentIndex]==song then task.defer(function() playItem(currentIndex+1) end) else refreshPlayer() end
                        end
                        sound:Destroy()
                    end)
                    sound:Play()
                end)
                if not ok then trackStatus.Text="Playback error"; warn("[Visible Music] "..tostring(err)) else refreshPlayer() end
            end)
        end

        local function collect()
            local q=string.lower(queryBox.Text or "")
            local out={}
            if view=="online" then return onlineResults end
            local pool={}
            for _,s in ipairs(songs) do pool[#pool+1]=s end
            for _,s in ipairs(saved) do
                local dup=false; for _,p in ipairs(pool) do if p.file==s.file then dup=true break end end
                if not dup then pool[#pool+1]=s end
            end
            for _,s in ipairs(pool) do
                local okView=(view=="library") or (view=="liked" and favorites[s.file]) or (view=="playlist" and playlist[s.file])
                if okView and (q=="" or string.find(string.lower(s.name.." "..s.artist),q,1,true)) then out[#out+1]=s end
            end
            return out
        end

        local render
        local function setInfo(t) info.Text=t or "" end
        render=function()
            for _,r in ipairs(rowRefs) do r.row:Destroy() end
            rowRefs={}; shown=collect()
            header.Text=view=="online" and "Search Online" or view=="liked" and "Liked" or view=="playlist" and "Playlist" or "Library"
            queryBox.PlaceholderText=view=="online" and "Search any song or artist" or "Filter songs"
            queryBox.Size=view=="online" and UDim2.new(1,-134,0,30) or UDim2.new(1,-36,0,30)
            searchBtn.Visible=(view=="online")
            for key,b in pairs(nav) do
                local sel=(key==view)
                b.BackgroundColor3=sel and rgb(30,31,35) or rgb(7,7,9)
                b.TextColor3=sel and rgb(245,245,245) or rgb(175,178,185)
            end
            if view=="online" and #shown==0 then setInfo("Type a name and press Search. Results are 30 second previews that you can save.") end
            for i,song in ipairs(shown) do
                local row=N("Frame",list,{Name="Song_"..i,Size=UDim2.new(1,-5,0,44),BackgroundColor3=rgb(18,19,22),BorderSizePixel=0,LayoutOrder=i})
                corner(row,3)
                N("UIStroke",row,{Color=rgb(62,62,70),Transparency=.72,Thickness=1})
                local nameW=view=="online" and -190 or -260
                label(row,song.name,10,4,UDim2.new(1,nameW,0,20),12,rgb(242,242,246),Enum.Font.GothamBold)
                label(row,song.artist,10,24,UDim2.new(1,nameW,0,16),10,rgb(150,153,160))
                local playB=sqBtn(row,"Play",UDim2.new(1,-66,.5,-14),UDim2.fromOffset(58,28),rgb(245,245,245),rgb(0,0,0),10)
                local item={song=song,row=row,play=playB}
                if view=="online" then
                    local saveB=sqBtn(row,isSaved(song) and "Saved" or "Download",UDim2.new(1,-150,.5,-14),UDim2.fromOffset(78,28),rgb(30,31,35),nil,10)
                    item.save=saveB
                    saveB.MouseButton1Click:Connect(function()
                        if isSaved(song) then return end
                        saveB.Text="..."
                        task.spawn(function()
                            local ok,err=pcall(function() ensureFile(song) end)
                            if ok then
                                saved[#saved+1]={name=song.name,artist=song.artist,file=song.file,url=song.url}; writeIndex()
                                saveB.Text="Saved"; setInfo("Downloaded: "..song.name.." (now in Library)")
                            else saveB.Text="Error"; setInfo("Download failed"); warn("[Visible Music] "..tostring(err)) end
                        end)
                    end)
                else
                    local likeB=sqBtn(row,"Like",UDim2.new(1,-126,.5,-14),UDim2.fromOffset(54,28),rgb(30,31,35),nil,10)
                    local addB=sqBtn(row,"Add",UDim2.new(1,-186,.5,-14),UDim2.fromOffset(54,28),rgb(30,31,35),nil,10)
                    item.like=likeB; item.add=addB
                    likeB.MouseButton1Click:Connect(function() favorites[song.file]=not favorites[song.file]; render() end)
                    addB.MouseButton1Click:Connect(function() playlist[song.file]=not playlist[song.file]; render() end)
                end
                playB.MouseButton1Click:Connect(function() playItem(i) end)
                rowRefs[#rowRefs+1]=item
            end
            refreshPlayer()
        end
        refreshPlayer=function()
            local sound=mvpFullRedrumSound
            local active=sound and sound.Parent and sound.Playing
            play.Text=active and "Pause" or "Play"
            trackStatus.Text=active and "Now playing" or "Select a track"
            if active and currentSong and currentSong.file==sound.Name then nowTitle.Text=currentSong.name; nowArtist.Text=currentSong.artist end
            for _,r in ipairs(rowRefs) do
                local selected=active and sound.Name==r.song.file
                r.play.Text=selected and "Stop" or "Play"
                r.row.BackgroundColor3=selected and rgb(36,36,40) or rgb(18,19,22)
                if r.like then
                    local on=favorites[r.song.file]==true
                    r.like.Text=on and "Liked" or "Like"; r.like.BackgroundColor3=on and rgb(70,70,78) or rgb(30,31,35)
                    local ad=playlist[r.song.file]==true
                    r.add.Text=ad and "Added" or "Add"; r.add.BackgroundColor3=ad and rgb(70,70,78) or rgb(30,31,35)
                end
            end
        end

        -- busqueda online (Deezer: previews mp3 de 30 s)
        local searching=false
        local function doSearch()
            local q=queryBox.Text or ""
            if q:gsub("%s","")=="" or searching then return end
            searching=true; setInfo("Searching..."); searchBtn.Text="..."
            task.spawn(function()
                local ok,res=pcall(function()
                    local raw=game:HttpGet("https://api.deezer.com/search?limit=25&q="..MusicHttp:UrlEncode(q))
                    return MusicHttp:JSONDecode(raw)
                end)
                local results={}
                if ok and type(res)=="table" and type(res.data)=="table" then
                    for _,d in ipairs(res.data) do
                        if d.preview and d.preview~="" then
                            results[#results+1]={name=tostring(d.title or "Unknown"),artist=tostring(d.artist and d.artist.name or "Unknown"),url=d.preview,file="VisibleMusic_dz"..tostring(d.id)..".mp3"}
                        end
                    end
                end
                searching=false; searchBtn.Text="Search"
                onlineResults=results
                if view=="online" then
                    render()
                    setInfo(ok and (#results.." results for \""..q.."\"") or "Search failed (no connection)")
                end
            end)
        end
        searchBtn.MouseButton1Click:Connect(doSearch)
        queryBox.FocusLost:Connect(function(enter) if enter and view=="online" then doSearch() end end)
        queryBox:GetPropertyChangedSignal("Text"):Connect(function() if view~="online" then render() end end)

        local function setView(v) view=v; queryBox.Text=""; setInfo(""); render() end
        navLibrary.MouseButton1Click:Connect(function() setView("library") end)
        navLiked.MouseButton1Click:Connect(function() setView("liked") end)
        navPlaylist.MouseButton1Click:Connect(function() setView("playlist") end)
        navOnline.MouseButton1Click:Connect(function() setView("online") end)

        prev.MouseButton1Click:Connect(function() if currentIndex then playItem(currentIndex-1<1 and #shown or currentIndex-1) end end)
        nextBtn.MouseButton1Click:Connect(function() if currentIndex then playItem(currentIndex%math.max(#shown,1)+1) else playItem(1) end end)
        play.MouseButton1Click:Connect(function()
            local current=mvpFullRedrumSound
            if current and current.Parent then
                if current.Playing then pcall(function() current:Pause() end) else pcall(function() current:Resume() end) end
                refreshPlayer()
            else playItem(currentIndex or 1) end
        end)
        minimize.MouseButton1Click:Connect(function()
            minimized=not minimized
            side.Visible=not minimized; main.Visible=not minimized
            panel.Size=minimized and UDim2.fromOffset(520,88) or UDim2.fromOffset(720,440)
            minimize.Text=minimized and "Max" or "Min"
            task.defer(applyMusicSize)
        end)
        close.MouseButton1Click:Connect(function() panel.Visible=false end)
        openMusic.MouseButton1Click:Connect(function() panel.Visible=not panel.Visible; if panel.Visible then render() end end)
        if workspace.CurrentCamera then workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(applyMusicSize) end
        task.defer(applyMusicSize)
        table.insert(mvpMusicRefreshers,function() if refreshPlayer then refreshPlayer() end end)
        render()
    end
    mkSect(configPage, "Appearance")
    do
        local row = mkRow(configPage, 150)
        local title = MVPUI.text(row, "Background", UDim2.fromOffset(16, 6), UDim2.new(1, -32, 0, 30), 13, Color3.fromRGB(255, 255, 255), 8)
        title.Font = Enum.Font.GothamMedium
        local holder = MVPUI.new("ScrollingFrame", row, {Name = "BgCards", Position = UDim2.fromOffset(10, 40),
            Size = UDim2.new(1, -20, 1, -46), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 8,
            ScrollingDirection = Enum.ScrollingDirection.X, CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.X, ScrollBarThickness = 4,
            ScrollBarImageColor3 = Color3.fromRGB(215, 219, 230), ElasticBehavior = Enum.ElasticBehavior.Always,
            ClipsDescendants = true})
        MVPUI.new("UIListLayout", holder, {FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder})
        for i, asset in ipairs(backgroundImages) do
            local card = MVPUI.new("ImageButton", holder, {Name = "Card" .. i, LayoutOrder = i,
                Size = UDim2.new(0, 140, 1, -10), Image = (tostring(asset) ~= "" and ("rbxassetid://" .. tostring(asset)) or ""),
                ScaleType = Enum.ScaleType.Crop, BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                BorderSizePixel = 0, AutoButtonColor = false, ClipsDescendants = true, ZIndex = 8})
            MVPUI.round(card, 14)
            local badge = MVPUI.new("Frame", card, {Name = "Badge", Size = UDim2.fromOffset(30, 22),
                Position = UDim2.new(0, 8, 1, -30), BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 10})
            MVPUI.round(badge, 8)
            local bt = MVPUI.text(badge, string.format("%02d", i), UDim2.fromScale(0, 0), UDim2.fromScale(1, 1), 11, Color3.fromRGB(255, 255, 255), 11)
            bt.Font = Enum.Font.GothamBold
            bt.TextXAlignment = Enum.TextXAlignment.Center
            bt.TextStrokeTransparency = 1
            card.MouseButton1Click:Connect(function()
                applyBackgroundMode("Background " .. i)
                pcall(saveAllSettings, true)
            end)
            MVPUI.cards[i] = card
        end
        do
            local ni = #backgroundImages + 1
            local noneCard = MVPUI.new("ImageButton", holder, {Name = "CardNone", LayoutOrder = ni,
                Size = UDim2.new(0, 140, 1, -10), Image = "", BackgroundColor3 = Color3.fromRGB(6, 6, 10),
                BorderSizePixel = 0, AutoButtonColor = false, ClipsDescendants = true, ZIndex = 8})
            noneCard:SetAttribute("BgNone", true)
            MVPUI.round(noneCard, 14)
            MVPUI.stroke(noneCard, Color3.fromRGB(215, 219, 230), 0.55, 1.2)
            local nt = MVPUI.text(noneCard, "NONE", UDim2.fromScale(0, 0), UDim2.fromScale(1, 1), 13, Color3.fromRGB(255, 255, 255), 9)
            nt.Font = Enum.Font.GothamBold
            nt.TextXAlignment = Enum.TextXAlignment.Center
            nt.TextStrokeTransparency = 1
            local nbadge = MVPUI.new("Frame", noneCard, {Name = "Badge", Size = UDim2.fromOffset(30, 22),
                Position = UDim2.new(0, 8, 1, -30), BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 10})
            MVPUI.round(nbadge, 8)
            local nbt = MVPUI.text(nbadge, "—", UDim2.fromScale(0, 0), UDim2.fromScale(1, 1), 11, Color3.fromRGB(255, 255, 255), 11)
            nbt.Font = Enum.Font.GothamBold
            nbt.TextXAlignment = Enum.TextXAlignment.Center
            nbt.TextStrokeTransparency = 1
            noneCard.MouseButton1Click:Connect(function()
                applyBackgroundMode("None")
                pcall(saveAllSettings, true)
            end)
            MVPUI.cards[ni] = noneCard
        end
        applyBackgroundMode(backgroundMode)
    end
    mkSect(configPage, "Management")
    local function makeSmallBtn(row, text, textCol, bgCol, strokeCol)
        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(1, -20, 0, 28)
        btn.Position = UDim2.new(0, 10, 0.5, -14)
        btn.BackgroundColor3 = bgCol
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = textCol
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.AutoButtonColor = false
        btn.ZIndex = 8
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local st = Instance.new("UIStroke", btn)
        st.Color = strokeCol
        st.Thickness = 1
        st.Transparency = 0.35
        return btn
    end
    do
        local row = mkRow(configPage, 36)
        local saveBtn = makeSmallBtn(row, "SAVE CONFIG", Color3.fromRGB(230,235,245), Color3.fromRGB(16,19,24), Color3.fromRGB(104, 116, 132))
        saveBtn.MouseButton1Click:Connect(function()
            local ok = saveAllSettings(true)
            saveBtn.Text = ok and "SAVED" or "ERROR"
            task.delay(1.2, function()
                if saveBtn and saveBtn.Parent then saveBtn.Text = "SAVE CONFIG" end
            end)
        end)
    end
    do
        local row = mkRow(configPage, 36)
        local resetPosBtn = makeSmallBtn(row, "RESET POSITIONS", Color3.fromRGB(230,235,245), Color3.fromRGB(16,19,24), Color3.fromRGB(104, 116, 132))
        local resetDebounce = false
        resetPosBtn.MouseButton1Click:Connect(function()
            if resetDebounce then return end
            resetDebounce = true
            resetFloatingPositions()
            resetPosBtn.Text = "RESET"
            task.delay(1.2, function()
                if resetPosBtn and resetPosBtn.Parent then
                    resetPosBtn.Text = "RESET POSITIONS"
                    resetDebounce = false
                end
            end)
        end)
    end
    do
        local row = mkRow(configPage, 36)
        local delBtn = makeSmallBtn(row, "RESET ALL SETTINGS", Color3.fromRGB(255,170,170), Color3.fromRGB(28,10,12), Color3.fromRGB(170,45,60))
        local deleteState = 0
        local delDebounce = false
        delBtn.MouseButton1Click:Connect(function()
            if delDebounce then return end
            if deleteState == 0 then
                deleteState = 1
                delBtn.Text = "CONFIRM?"
                delBtn.BackgroundColor3 = Color3.fromRGB(50,15,20)
                task.delay(2, function()
                    if delBtn and delBtn.Parent and deleteState == 1 then
                        deleteState = 0
                        delBtn.Text = "RESET ALL SETTINGS"
                        delBtn.BackgroundColor3 = Color3.fromRGB(28,10,12)
                    end
                end)
            elseif deleteState == 1 then
                delDebounce = true
                local ok = pcall(resetToFactoryDefaults)
                delBtn.Text = ok and "DONE" or "ERROR"
                deleteState = 0
                task.delay(1.5, function()
                    if delBtn and delBtn.Parent then
                        delBtn.Text = "RESET ALL SETTINGS"
                        delDebounce = false
                    end
                end)
            end
        end)
    end

    local keyPage = contentPages["Keybinds"]
    mkSect(keyPage, "Keybinds")
    mkSect(keyPage, "Movement")
    addKeybindRow(keyPage, "Carry Mode", KB.CarryToggle)
    addKeybindRow(keyPage, "Lagger Mode", KB.LaggerMode)
    addKeybindRow(keyPage, "Auto Left", KB.AutoLeft)
    addKeybindRow(keyPage, "Auto Right", KB.AutoRight)

    mkSect(keyPage, "Combat")
    addKeybindRow(keyPage, "Bat Aimbot", KB.AutoBat)

    mkSect(keyPage, "Utility")
    addKeybindRow(keyPage, "Drop Brainrot", KB.DropBrainrot)
    addKeybindRow(keyPage, "TP Down", KB.TPFloor)
    addKeybindRow(keyPage, "Hide GUI", KB.GuiHide)

    local spacer = Instance.new("Frame", keyPage)
    spacer.Size = UDim2.new(1, 0, 0, 16)
    spacer.BackgroundTransparency = 1
    spacer.LayoutOrder = getNextOrder(keyPage)
    spacer.ZIndex = 7

    -- ===== HUD AUTO STEAL: barra estilo Ace Duels (avatar, porcentaje, FPS/PING y barra de progreso) =====
    do
    local HUD_W, HUD_H = 300, 52
    local COL_WHITE = Color3.fromRGB(255, 255, 255)
    local ACE = _G.__VisibleAce
    local function barGradient()
        return ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 76, 86)),
            ColorSequenceKeypoint.new(0.48, ACE.pale),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 130, 145))})
    end
    pbFrame = MVPUI.new("Frame", gui, {Name = "StealPod", Size = UDim2.fromOffset(HUD_W, HUD_H),
        Position = savedProgressBarPos
            and UDim2.new(tonumber(savedProgressBarPos.XScale) or 0.5, tonumber(savedProgressBarPos.XOffset) or -210,
                tonumber(savedProgressBarPos.YScale) or 0.80, tonumber(savedProgressBarPos.YOffset) or 0)
            or UDim2.new(0.5, -HUD_W / 2, 0, 28), BackgroundColor3 = Color3.fromRGB(3, 3, 5),
        BackgroundTransparency = 0.02, BorderSizePixel = 0, Active = true, ZIndex = 50})
    MVPUI.hudScale = MVPUI.new("UIScale", pbFrame, {Scale = 1})
    Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 14)
    do
        local g = Instance.new("UIGradient", pbFrame)
        g.Name = "StealBarBgGradient"
        g.Rotation = 90
        g.Color = ColorSequence.new(Color3.fromRGB(7, 7, 10), Color3.fromRGB(2, 3, 5))
    end
    local barStroke = Instance.new("UIStroke", pbFrame)
    barStroke.Name = "StealBarStroke"
    barStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    barStroke.Thickness = 1.4
    barStroke.Color = Color3.fromRGB(255, 255, 255)
    barStroke.Transparency = 0.25
    local strokeGrad = Instance.new("UIGradient", barStroke)
    strokeGrad.Color = barGradient()

    -- compat: imagen de fondo del HUD (siempre vacía)
    stealBgImageHud = Instance.new("ImageLabel", pbFrame)
    stealBgImageHud.Name = "StealBackgroundImage"
    stealBgImageHud.Size = UDim2.fromScale(1, 1)
    stealBgImageHud.BackgroundTransparency = 1
    stealBgImageHud.BorderSizePixel = 0
    stealBgImageHud.Image = ""
    stealBgImageHud.ImageTransparency = 1
    stealBgImageHud.ZIndex = 50
    Instance.new("UICorner", stealBgImageHud).CornerRadius = UDim.new(0, 14)

    -- avatar redondo
    local icon = Instance.new("ImageLabel", pbFrame)
    icon.Name = "PlayerStealIcon"
    icon.Size = UDim2.fromOffset(1, 1)
    icon.Position = UDim2.fromOffset(0, 0)
    icon.Visible = false
    icon.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    icon.BorderSizePixel = 0
    icon.ScaleType = Enum.ScaleType.Crop
    icon.ZIndex = 52
    Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)
    do
        local iconStroke = Instance.new("UIStroke", icon)
        iconStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        iconStroke.Color = ACE.active
        iconStroke.Thickness = 1
        iconStroke.Transparency = 0.5
    end
    task.spawn(function()
        local ok, result = pcall(function()
            return Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        end)
        if icon.Parent then icon.Image = (ok and result) or "" end
    end)
    local divider = Instance.new("Frame", pbFrame)
    divider.Name = "IconDivider"
    divider.Size = UDim2.fromOffset(1, 1)
    divider.Position = UDim2.fromOffset(0, 0)
    divider.Visible = false
    divider.BackgroundColor3 = COL_WHITE
    divider.BackgroundTransparency = 0.48
    divider.BorderSizePixel = 0
    divider.ZIndex = 51

    -- partículas flotantes
    for i = 1, 14 do
        local d = Instance.new("Frame", pbFrame)
        d.Name = "StealLane" .. i
        local sz = (i % 5 == 0) and 3 or ((i % 2 == 0) and 2 or 1)
        d.Size = UDim2.fromOffset(sz, sz)
        d.BackgroundColor3 = (i % 2 == 0) and COL_WHITE or ACE.pale
        d.BackgroundTransparency = 0.54 + ((i % 4) * 0.05)
        d.BorderSizePixel = 0
        d.ZIndex = 51
        d:SetAttribute("Lane", i)
        Instance.new("UICorner", d).CornerRadius = UDim.new(1, 0)
    end

    -- porcentaje (compat: progressPct)
    progressPct = Instance.new("TextLabel", pbFrame)
    progressPct.Name = "StealProgressPercent"
    progressPct.Size = UDim2.fromOffset(90, 24)
    progressPct.Position = UDim2.fromOffset(12, 3)
    progressPct.BackgroundTransparency = 1
    progressPct.Text = "0%"
    progressPct.TextColor3 = COL_WHITE
    progressPct.Font = Enum.Font.GothamBlack
    progressPct.TextSize = 20
    progressPct.TextXAlignment = Enum.TextXAlignment.Left
    progressPct.TextYAlignment = Enum.TextYAlignment.Center
    progressPct.ZIndex = 51
    progressPct:SetAttribute("Prefix", "")

    -- título y estadísticas a la derecha
    local bannerLabel = Instance.new("TextLabel", pbFrame)
    bannerLabel.Name = "BannerLabel"
    bannerLabel.Size = UDim2.fromOffset(150, 18)
    bannerLabel.Position = UDim2.new(1, -158, 0, 5)
    bannerLabel.BackgroundTransparency = 1
    bannerLabel.RichText = false
    bannerLabel.Text = "Radius: " .. tostring(CONFIG.STEAL_RANGE or 0)
    bannerLabel.TextColor3 = Color3.fromRGB(220, 220, 225)
    bannerLabel.Font = Enum.Font.GothamMedium
    bannerLabel.TextSize = 14
    bannerLabel.TextXAlignment = Enum.TextXAlignment.Right
    bannerLabel.ZIndex = 51
    stealHud.radius = bannerLabel
    local statsLabel = Instance.new("TextLabel", pbFrame)
    statsLabel.Name = "StealStatsLabel"
    statsLabel.Size = UDim2.fromOffset(180, 14)
    statsLabel.Position = UDim2.fromOffset(12, 26)
    statsLabel.BackgroundTransparency = 1
    statsLabel.RichText = false
    statsLabel.Text = "0FPS · 0ms"
    statsLabel.TextColor3 = Color3.fromRGB(180, 180, 188)
    statsLabel.Font = Enum.Font.GothamMedium
    statsLabel.TextSize = 11
    statsLabel.TextXAlignment = Enum.TextXAlignment.Left
    statsLabel.ZIndex = 51

    statusDot = Instance.new("Frame", pbFrame)
    statusDot.Name = "StatusDot"
    statusDot.Size = UDim2.fromOffset(6, 6)
    statusDot.Position = UDim2.new(1, -17, 0, 11)
    statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    statusDot.BorderSizePixel = 0
    statusDot.ZIndex = 52
    statusDot.Visible = false -- punto verde eliminado (se conserva el objeto por compatibilidad)
    Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

    -- compat: estado (oculto, lo usa updateStealProgress)
    progressStatus = Instance.new("TextLabel", pbFrame)
    progressStatus.Name = "StealProgressStatus"
    progressStatus.Size = UDim2.fromOffset(0, 0)
    progressStatus.BackgroundTransparency = 1
    progressStatus.TextTransparency = 1
    progressStatus.Text = "STEAL"
    progressStatus.ZIndex = 50

    -- pista y relleno de progreso
    local track = Instance.new("Frame", pbFrame)
    track.Name = "StealTrack"
    track.Size = UDim2.new(1, -24, 0, 6)
    track.Position = UDim2.fromOffset(12, 42)
    track.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    track.BorderSizePixel = 0
    track.ZIndex = 51
    track.ClipsDescendants = true
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    progressFill = Instance.new("Frame", track)
    progressFill.Name = "StealProgressFill"
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = COL_WHITE
    progressFill.BackgroundTransparency = 0
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 52
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)
    local fillGrad = Instance.new("UIGradient", progressFill)
    fillGrad.Color = barGradient()

    -- animación: borde giratorio, brillo del relleno y partículas
    task.spawn(function()
        while pbFrame and pbFrame.Parent do
            local showHud = (CONFIG and CONFIG.AUTO_STEAL_ENABLED == true) or false
            if pbFrame.Visible ~= showHud then pbFrame.Visible = showHud end
            strokeGrad.Rotation = (strokeGrad.Rotation + 2) % 360
            fillGrad.Offset = Vector2.new(((tick() * 0.4) % 2) - 1, 0)
            local now = tick()
            for _, child in ipairs(pbFrame:GetChildren()) do
                local lane = child:GetAttribute("Lane")
                if lane then
                    local x = 4 + (((now * (10 + (lane * 1.15))) + (lane * 31)) % (HUD_W - 15))
                    local y = math.clamp((26 + (math.sin((now * (1.15 + (lane * 0.045))) + (lane * 1.7)) * 17))
                        + (math.sin((now * 0.42) + (lane * 2.3)) * 5), 4, 48)
                    child.Position = UDim2.fromOffset(x, y)
                    child.BackgroundTransparency = 0.57 + ((math.sin((now * 2.1) + lane) + 1) * 0.1)
                end
            end
            task.wait(0.03)
        end
    end)

    stealHud.mode = MVPUI.text(pbFrame, autoStealMode, UDim2.fromOffset(0, 0), UDim2.fromOffset(0, 0), 1, Color3.fromRGB(255, 255, 255), 1)
    stealHud.mode.Name = "StealMode"; stealHud.mode.Visible = false
    local _radiusCompat = MVPUI.text(pbFrame, "Radius: " .. tostring(CONFIG.STEAL_RANGE), UDim2.fromOffset(0, 0), UDim2.fromOffset(0, 0), 1, Color3.fromRGB(255, 255, 255), 1)
    _radiusCompat.Name = "StealRadius"; _radiusCompat.Visible = false
    if not stealHud.radius then stealHud.radius = _radiusCompat end
    stealHud.toggle = MVPUI.text(pbFrame, CONFIG.AUTO_STEAL_ENABLED and "ON" or "OFF", UDim2.fromOffset(0, 0), UDim2.fromOffset(0, 0), 1, Color3.fromRGB(255, 255, 255), 1)
    stealHud.toggle.Name = "StealToggle"; stealHud.toggle.Visible = false
    stealHud.stats = MVPUI.text(pbFrame, stealHud.statsText or "", UDim2.fromOffset(0, 0), UDim2.fromOffset(0, 0), 1, Color3.fromRGB(255, 255, 255), 1)
    stealHud.stats.Name = "PerformanceStats"; stealHud.stats.Visible = false

    _G.__VisibleHudStats = function(fps, ping)
        if statsLabel and statsLabel.Parent then
            statsLabel.Text = string.format("%dFPS · %dms", tonumber(fps) or 0, tonumber(ping) or 0)
        end
    end
    _G.__VisibleHudStyle = function()
        if progressFill and progressFill.Parent then progressFill.BackgroundColor3 = COL_WHITE end
        if progressPct and progressPct.Parent then progressPct.TextColor3 = COL_WHITE end
    end
    function setStealStatusText(status)
        if not (progressPct and progressPct.Parent) then return end
        if status == "SEARCHING" then
            if statusDot then statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 120) end
        elseif status == "STEALING" or status == "HOLDING" or status == "CLOSER" then
            if statusDot then statusDot.BackgroundColor3 = Color3.fromRGB(255, 200, 50) end
        elseif status == "STOLE" then
            if statusDot then statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 120) end
        elseif status == "MISSED" then
            progressPct.Text = "MISS"
            if statusDot then statusDot.BackgroundColor3 = Color3.fromRGB(255, 80, 80) end
        end
    end
    function resetProgressBar()
        if progressFill and progressFill.Parent then progressFill.Size = UDim2.new(0, 0, 1, 0) end
        if progressPct then progressPct.Text = "0%" end
        if statusDot then statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 120) end
    end
    end -- fin HUD

    task.spawn(function()
        local last = tick()
        local frames = 0
        local fps = 60
        while pbFrame and pbFrame.Parent do
            frames = frames + 1
            local now = tick()
            if now - last >= 0.5 then
                fps = math.floor(frames / (now - last) + 0.5)
                frames = 0
                last = now
                local ping = 0
                pcall(function()
                    ping = math.floor((game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) + 0.5)
                end)
                if _G.__VisibleHudStats then _G.__VisibleHudStats(fps, ping) end
            end
            task.wait()
        end
    end)

    updateStealProgress(stealHud.value, stealHud.state)
    if applyStealBackground then pcall(applyStealBackground, stealBgIndex) end
    updateStealProgress(stealHud.value, stealHud.state)
    drag(pbFrame)
    MVPUI.fit()
    do
        local viewConnection
        local function followCamera()
            if viewConnection then viewConnection:Disconnect() end
            local cam = Workspace.CurrentCamera
            if cam then viewConnection = cam:GetPropertyChangedSignal("ViewportSize"):Connect(MVPUI.fit) end
            MVPUI.fit()
        end
        local cameraConnection = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(followCamera)
        followCamera()
        gui.Destroying:Connect(function()
            cameraConnection:Disconnect()
            if viewConnection then viewConnection:Disconnect() end
        end)
    end
    -- (efecto de presionar eliminado: los botones y toggles ya no se ponen negros al mantener presionado)
    task.delay(1.2, function() pcall(MVPUI.fitTexts, gui) end)
    MVPUI.effectsLoop(gui)
    task.spawn(function() pcall(function() game:GetService("ContentProvider"):PreloadAsync({bg}) end) end)
end

do
    
    local function findGlobalFunc(...)
        local sources = {}
        pcall(function() if getgenv then table.insert(sources, getgenv()) end end)
        pcall(function() table.insert(sources, _G) end)
        pcall(function() if getfenv then table.insert(sources, getfenv()) end end)
        for i = 1, select("#", ...) do
            local name = select(i, ...)
            for _, env in ipairs(sources) do
                if type(env) == "table" then
                    local ok, val = pcall(function() return env[name] end)
                    if ok and type(val) == "function" then return val end
                end
            end
        end
        return nil
    end

    local setHiddenProp = findGlobalFunc(
        "sethiddenproperty", "set_hidden_property",
        "sethiddenprop", "set_hidden_prop"
    )
    local function setHidden(instance, prop, value)
        if not instance then return false end
        if setHiddenProp then
            local ok = pcall(setHiddenProp, instance, prop, value)
            if ok then return true end
        end
        return false
    end

    local TP = {
        enabled   = false,
        conn      = nil,
        char      = nil,
        h         = nil,
        hrp       = nil,
        cooldown  = false,
        
        batSpeed     = 40,   
        currentVersion = "V1", 
        silentAim    = false,
    }

    local function isBatTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local n = string.lower(tool.Name)
        return n:find("bat", 1, true) ~= nil or n:find("slap", 1, true) ~= nil
    end

    local function getBat()
        local c = LP.Character or TP.char
        if not c then return nil end
        local hum = c:FindFirstChildOfClass("Humanoid")
        for _, ch in ipairs(c:GetChildren()) do
            if isBatTool(ch) then return ch end
        end
        local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
        if bp then
            for _, ch in ipairs(bp:GetChildren()) do
                if isBatTool(ch) then
                    if hum then
                        pcall(function() hum:EquipTool(ch) end)
                    else
                        pcall(function() ch.Parent = c end)
                    end
                    return ch
                end
            end
        end
        return nil
    end

    local function getHitDelay()
        local t = 0.12 - ((TP.batSpeed - 10) / 70) * 0.105
        return math.clamp(t, 0.015, 0.12)
    end

    local function tryHit()
        if TP.cooldown then return end
        TP.cooldown = true
        pcall(function()
            local bat = getBat()
            if not bat then return end
            pcall(function() bat:Activate() end)
            for _, d in ipairs(bat:GetDescendants()) do
                if d:IsA("RemoteEvent") then pcall(function() d:FireServer() end) end
            end
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then pcall(function() ev:FireServer() end) end
        end)
        task.delay(getHitDelay(), function() TP.cooldown = false end)
    end

    local function getClosest()
        local myHrp = TP.hrp
        if not myHrp or not myHrp.Parent then
            local c = LP.Character
            myHrp = c and c:FindFirstChild("HumanoidRootPart")
            TP.hrp = myHrp
        end
        if not myHrp then return nil, math.huge end
        local best, bestDist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local tr  = p.Character:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and tr and tr.Parent then
                    local d = (myHrp.Position - tr.Position).Magnitude
                    if d < bestDist then bestDist = d; best = p end
                end
            end
        end
        return best, bestDist
    end

    local function setupChar(newChar)
        TP.char = newChar
        task.wait(0.1)
        TP.h   = newChar:WaitForChild("Humanoid", 5)
        TP.hrp = newChar:WaitForChild("HumanoidRootPart", 5)
    end

    local function stopBatV2()
        TP.enabled = false
        if TP.conn then TP.conn:Disconnect(); TP.conn = nil end
        TP.char = nil; TP.h = nil; TP.hrp = nil
        TP.cooldown = false
        if _unsuppressBodyLock then pcall(_unsuppressBodyLock, true) end
    end

    local function startBatV2()
        if _G.__VisibleLagStop then pcall(_G.__VisibleLagStop) end
        if autoBatEnabled then disableAutoBat() end
        stopBatV2()
        TP.enabled = true
        TP.char = LP.Character
        if TP.char then
            TP.h   = TP.char:FindFirstChildOfClass("Humanoid")
            TP.hrp = TP.char:FindFirstChild("HumanoidRootPart")
        end
        if _suppressBodyLock then pcall(_suppressBodyLock) end

        TP.conn = RunService.Heartbeat:Connect(function()
            if not TP.enabled then return end
            local c = LP.Character
            if not c then return end
            TP.char = c
            TP.hrp  = c:FindFirstChild("HumanoidRootPart")
            TP.h    = c:FindFirstChildOfClass("Humanoid")
            if not TP.hrp or not TP.h or TP.h.Health <= 0 then return end

            local target, dist = getClosest()
            if not target or not target.Character then return end
            local tr = target.Character:FindFirstChild("HumanoidRootPart")
            if not tr then return end

            setHidden(TP.hrp, "PhysicsRepRootPart", tr)

            local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
            targetPos = wallSafePosition(TP.hrp, targetPos) -- berhenti sebelum dinding
            if dist > 4 then
                TP.hrp.CFrame = CFrame.new(targetPos, tr.Position)
            elseif dist > 1.5 then
                TP.hrp.CFrame = CFrame.new(TP.hrp.Position:Lerp(targetPos, 0.55), tr.Position)
            else
                TP.hrp.CFrame = CFrame.new(targetPos, tr.Position)
            end

            pcall(function() TP.hrp.AssemblyAngularVelocity = Vector3.zero end)

            local cam = workspace.CurrentCamera
            if not TP.silentAim and cam then
                cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position + Vector3.new(0, 0.5, 0))
            end

            if TP.currentVersion == "V1" then
                tryHit()
            end
        end)
    end

    _G.__VisibleHubStartBatV2 = startBatV2
    _G.__VisibleHubStopBatV2  = stopBatV2
    _G.__VisibleHubIsBatV2    = function() return TP.enabled == true end
    _G.__VisibleHubBatV2      = TP

    LP.CharacterAdded:Connect(function(newChar)
        task.wait(0.5)
        setupChar(newChar)
        if TP.enabled then
            startBatV2()
        end
    end)
    if LP.Character then task.spawn(function() setupChar(LP.Character) end) end
end

function createMobilePanel()
    local panel = Instance.new("ScreenGui")
    panel.Name = "VisibleHubMobilePanel"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.IgnoreGuiInset = true
    panel.DisplayOrder = 40
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    local okPanel = pcall(function() panel.Parent = game:GetService("CoreGui") end)
    if not okPanel then panel.Parent = LP:WaitForChild("PlayerGui") end

    local BTN_W, BTN_H = 68, 68
    local buttons = {}
    local buttonNames = {"AutoBat", "DropBR", "AutoLeft", "AutoRight", "TpDown", "Carry", "Lagger1", "Lagger2", "InstantReset"}
    local buttonGlyphs = {DropBR = "↙", AutoLeft = "<", AutoBat = "V1", AutoRight = ">", TpDown = "↓", Carry = "C", Lagger1 = "L1", Lagger2 = "L2"}
    local buttonTexts = {"BAT\nAIMBOT", "DROP\nBR", "AUTO\nLEFT", "AUTO\nRIGHT", "TP\nDOWN", "CARRY\nSPEED", "LAGGER\nNORMAL", "LAGGER\nCARRY", "INSTANT\nRESET"}
    -- loadAllSettings() se ejecuta antes de crear este panel. No borrar aquí
    -- las posiciones que ya fueron restauradas desde el archivo.

    local function createButton(name, text, order, isToggle, callback)
        local btn = MVPUI.new("TextButton", panel, {Name = name, Size = UDim2.fromOffset(BTN_W, BTN_H),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.12, BorderSizePixel = 0, Text = "",
            AutoButtonColor = false, Active = true, ZIndex = 10})
        local saved = savedButtonPositions[name]
        local x, y = getDefaultButtonPosition(name)
        btn.Position = UDim2.fromOffset(saved and tonumber(saved.X) or x, saved and tonumber(saved.Y) or y)
        MVPUI.round(btn, 14)
        MVPUI.new("UIGradient", btn, {Name = "BtnGrad", Rotation = 90,
            Color = ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0))})
        -- Sin borde brillante en los botones flotantes.
        -- gambar background ikut berubah saat background diganti (Visual > Background)
        local bgImg = Instance.new("ImageLabel", btn)
        bgImg.Name = "StealBgImage"
        bgImg.Size = UDim2.new(1, 0, 1, 0)
        bgImg.BackgroundTransparency = 1
        bgImg.BorderSizePixel = 0
        bgImg.ScaleType = Enum.ScaleType.Crop
        bgImg.ZIndex = 10
        Instance.new("UICorner", bgImg).CornerRadius = UDim.new(0, 14)
        do
            local cfgBg = STEAL_BG_IMAGES[stealBgIndex]
            local imgBg = cfgBg and cfgBg.id or ""
            bgImg.Image = ""
            bgImg.ImageTransparency = 1
        end
        _stealBgButtonImages[btn] = bgImg
        -- lapisan warna tipis saat tombol ditekan (warna Misc)
        local tint = Instance.new("Frame", btn)
        tint.Name = "ActiveTint"
        tint.Size = UDim2.new(1, 0, 1, 0)
        tint.BackgroundColor3 = Color3.fromRGB(200, 40, 255)
        tint.BackgroundTransparency = 1
        tint.BorderSizePixel = 0
        tint.ZIndex = 10
        Instance.new("UICorner", tint).CornerRadius = UDim.new(0, 14)
        applyFloatingButtonShapeTo(btn)
        -- Solo las flechas de Left y Right conservan su indicador; el resto no lleva
        if name == "AutoLeft" or name == "AutoRight" then
            local glyph = Instance.new("TextLabel", btn)
            glyph.Name = "Glyph"
            glyph.Position = UDim2.fromOffset(4, 3)
            glyph.Size = UDim2.new(1, -8, 0, 16)
            glyph.BackgroundTransparency = 1
            glyph.Text = buttonGlyphs[name]
            glyph.TextColor3 = Color3.fromRGB(150, 150, 156)
            glyph.Font = Enum.Font.GothamBlack
            glyph.TextSize = 16
            glyph.TextXAlignment = Enum.TextXAlignment.Center
            glyph.TextStrokeTransparency = 1
            glyph.ZIndex = 11
        end
        local label = Instance.new("TextLabel", btn)
        label.Name = "TextLabel"
        label.Position = UDim2.fromOffset(4, 0)
        label.Size = UDim2.new(1, -8, 1, 0)
        if name == "AutoLeft" or name == "AutoRight" then
            label.Position = UDim2.fromOffset(4, 20)
            label.Size = UDim2.new(1, -8, 1, -24)
        end
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(150, 150, 156)
        label.Font = Enum.Font.GothamBlack
        label.TextSize = 10
        label.TextWrapped = true
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.TextStrokeTransparency = 1
        label.ZIndex = 11
        if _G.__VisibleXmasDecorate then pcall(_G.__VisibleXmasDecorate, btn) end
        pcall(paintFloatingBtn, btn, false)
        local scale = MVPUI.new("UIScale", btn, {Scale = floatingButtonScale})
        table.insert(_floatingUIScales, scale)
        local active = false
        local function setActive(value)
            active = value == true
            btn:SetAttribute("MobActive", active)
            paintFloatingBtn(btn, active)
        end
        local pointer, dragStart, origin, moved = nil, nil, nil, 0
        local function clampPosition(pos)
            -- Sin límites: los botones se pueden arrastrar fuera de la pantalla.
            return pos
        end
        local function finish(input)
            if not pointer then return end
            if pointer.UserInputType == Enum.UserInputType.Touch and input ~= pointer then return end
            if pointer.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
            pointer = nil
            MVPUI.activeInput = nil
            _isDraggingButton = false
            TS:Create(scale, TweenInfo.new(0.12), {Scale = floatingButtonScale}):Play()
            if moved < 8 then
                local ok, err = pcall(callback, setActive, active)
                if not ok then warn("[MVP Button] " .. name .. ": " .. tostring(err)) end
            elseif not uiLocked and not mobileButtonsLocked then
                savedButtonPositions[name] = {X = btn.Position.X.Offset, Y = btn.Position.Y.Offset}
            end
            paintFloatingBtn(btn, active)
            pcall(saveAllSettings)
        end
        btn.InputBegan:Connect(function(input)
            if MVPUI.activeInput then return end
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            pointer, dragStart, origin, moved = input, input.Position, btn.Position, 0
            MVPUI.activeInput = input
            _isDraggingButton = true
            TS:Create(scale, TweenInfo.new(0.09), {Scale = floatingButtonScale * 0.95}):Play()
            pcall(function() btn.BackgroundColor3 = Color3.fromRGB(58, 58, 62) end)
        end)
        local moveConn = UIS.InputChanged:Connect(function(input)
            if not pointer then return end
            if pointer.UserInputType == Enum.UserInputType.Touch then
                if input ~= pointer then return end
            elseif input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
            local delta = input.Position - dragStart
            moved = math.max(moved, delta.Magnitude)
            if moved >= 8 and not uiLocked and not mobileButtonsLocked then
                btn.Position = clampPosition(UDim2.fromOffset(origin.X.Offset + delta.X, origin.Y.Offset + delta.Y))
            end
        end)
        local endConn = UIS.InputEnded:Connect(finish)
        btn.InputEnded:Connect(finish)
        btn.Destroying:Connect(function()
            moveConn:Disconnect(); endConn:Disconnect()
            if pointer then MVPUI.activeInput = nil; _isDraggingButton = false end
        end)
        btn.Position = clampPosition(btn.Position)
        buttons[name] = {btn = btn, setActive = setActive, label = label, clampPosition = clampPosition}
        setActive(false)
        return setActive
    end

    for i, name in ipairs(buttonNames) do
        local text = buttonTexts[i]
        local callback
        if name == "DropBR" then
            callback = function(setActive)
                if autoBatEnabled then return end
                setActive(true)
                executeDropWithToggle(function(v)
                    if dropBrainrotSetVisual then dropBrainrotSetVisual(v) end
                end)
                task.delay(0.3, function() setActive(false) end)
            end
        elseif name == "AutoLeft" then
            callback = function(setActive)
                autoLeftEnabled = not autoLeftEnabled
                setActive(autoLeftEnabled)
                if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
                if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
            end
        elseif name == "AutoBat" then
            callback = function(setActive)
                if not autoBatEnabled then enableAutoBat() else disableAutoBat() end
                setActive(autoBatEnabled)
            end
        elseif name == "AutoRight" then
            callback = function(setActive)
                autoRightEnabled = not autoRightEnabled
                setActive(autoRightEnabled)
                if autoRightEnabled then startAutoRight() else stopAutoRight() end
                if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
            end
        elseif name == "TpDown" then
            callback = function(setActive)
                doTpDown()
                setActive(true)
                task.delay(0.2, function() setActive(false) end)
            end
        elseif name == "Carry" then
            callback = function(setActive)
                if not speedMode then
                    speedMode = true; laggerToggled = false; laggerCarryToggled = false; setActive(true)
                    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
                else
                    speedMode = false; setActive(false)
                end
                refreshSpeedModeLabel()
                if _G.__VisibleHubApplySpeedNow then pcall(_G.__VisibleHubApplySpeedNow) end
                refreshSpeedModeLabel()
            end
        elseif name == "Lagger1" then
            callback = function(setActive)
                if speedMode then speedMode = false; if mobSetCarry then mobSetCarry(false) end end
                if not laggerToggled then
                    laggerToggled = true; laggerCarryToggled = false; setActive(true)
                    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
                else
                    laggerToggled = false; setActive(false)
                end
                refreshSpeedModeLabel()
                if _G.__VisibleHubApplySpeedNow then pcall(_G.__VisibleHubApplySpeedNow) end
                refreshSpeedModeLabel()
            end
        elseif name == "Lagger2" then
            callback = function(setActive)
                if speedMode then speedMode = false; if mobSetCarry then mobSetCarry(false) end end
                if not laggerCarryToggled then
                    laggerCarryToggled = true; laggerToggled = false; setActive(true)
                    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                else
                    laggerCarryToggled = false; setActive(false)
                end
                refreshSpeedModeLabel()
                if _G.__VisibleHubApplySpeedNow then pcall(_G.__VisibleHubApplySpeedNow) end
                refreshSpeedModeLabel()
            end
        elseif name == "InstantReset" then
            callback = function(setActive)
                setActive(true)
                if _G.__VisibleRunInstantReset then pcall(_G.__VisibleRunInstantReset) end
                task.delay(0.3, function() setActive(false) end)
            end
        end
        local setActive = createButton(name, text, i-1, true, callback)
        if name == "AutoBat" then mobSetAutoBat = setActive end
        if name == "AutoLeft" then mobSetAutoLeft = setActive end
        if name == "AutoRight" then mobSetAutoRight = setActive end
        if name == "DropBR" then mobSetDropBR = setActive end
        if name == "TpDown" then mobSetTpDown = setActive end
        if name == "Carry" then mobSetCarry = setActive end
        if name == "Lagger1" then mobSetLagger1 = setActive end
        if name == "Lagger2" then mobSetLagger2 = setActive end
        if name == "AutoBat" then
            _G.__VisibleBatMobLabel = buttons[name] and buttons[name].label
            if _G.__VisibleBatVersionRefresh then pcall(_G.__VisibleBatVersionRefresh) end
        end
    end

    if buttons.AutoBat and buttons.AutoBat.setActive then buttons.AutoBat.setActive(autoBatEnabled) end
    if buttons.AutoLeft and buttons.AutoLeft.setActive then buttons.AutoLeft.setActive(autoLeftEnabled) end
    if buttons.AutoRight and buttons.AutoRight.setActive then buttons.AutoRight.setActive(autoRightEnabled) end
    if buttons.Carry and buttons.Carry.setActive then buttons.Carry.setActive(speedMode) end
    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(laggerToggled) end
    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(laggerCarryToggled) end

    -- Aplicar el estado guardado también al crear/recrear el panel móvil.
    applyHideButtons(hideButtonsEnabled)

    local viewportConn
    if Workspace.CurrentCamera then
        viewportConn = Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            for _, entry in pairs(buttons) do entry.btn.Position = entry.clampPosition(entry.btn.Position) end
        end)
    end
    panel.Destroying:Connect(function() if viewportConn then viewportConn:Disconnect() end end)
    return panel
end

batCounterV2Enabled = false
batCounterV2Debounce = false
batCounterV2Conn = nil
batCounterV2HitCooldown = false
BAT_COUNTER_V2_SWING_CD = 0.08
setBatCounterV2Visual = nil

local _batCounterV2OriginalTpState = false
local _batCounterV2SuppressCount = 0
local _lastBatCounterV2Time = 0
local _batCounterV2Cooldown = 0.01

local function isPlayerRagdolled(player)
    if not player or not player.Character then return false end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local state = hum:GetState()
    return state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown
end

local function hasAnimalEquipped(player)
    if not player or not player.Character then return false end
    for _, child in ipairs(player.Character:GetChildren()) do
        if child:IsA("Tool") then
            if child:FindFirstChild("Handle") or child.Name:find("Animal") or child.Name:find("Pet") then return true end
        end
    end
    return false
end

local function getAttackingPlayerWithAnimal()
    local myChar = LP.Character
    if not myChar then return nil end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local closest, minDist = nil, _huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            if not hasAnimalEquipped(plr) then continue end
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - myRoot.Position).Magnitude
                if dist < 12 and dist < minDist then
                    minDist = dist; closest = plr
                end
            end
        end
    end
    return closest
end

local function getBatV2Counter()
    local char = LP.Character
    if not char then return nil end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            local name = child.Name:lower()
            if name:find("bat") or name:find("slap") or name:find("sword") or name:find("knife") then return child end
        end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, child in ipairs(bp:GetChildren()) do
            if child:IsA("Tool") then
                local name = child.Name:lower()
                if name:find("bat") or name:find("slap") or name:find("sword") or name:find("knife") then
                    child.Parent = char
                    return child
                end
            end
        end
    end
    if bp then
        for _, child in ipairs(bp:GetChildren()) do
            if child:IsA("Tool") then child.Parent = char; return child end
        end
    end
    return nil
end

local function tryHitBatCounterV2()
    if batCounterV2HitCooldown then return end
    batCounterV2HitCooldown = true
    pcall(function()
        local bat = getBatV2Counter()
        if bat then
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end
    end)
    task.delay(BAT_COUNTER_V2_SWING_CD, function() batCounterV2HitCooldown = false end)
end

local function executeBatCounterV2()
    local now = _tick()
    if now - (_lastBatCounterV2Time or 0) < (_batCounterV2Cooldown or 0.01) then return end
    if batCounterV2Debounce then return end
    batCounterV2Debounce = true
    _lastBatCounterV2Time = now
    local attacker = getAttackingPlayerWithAnimal()
    if not attacker then batCounterV2Debounce = false; return end
    if isPlayerRagdolled(attacker) then batCounterV2Debounce = false; return end
    if not hasAnimalEquipped(attacker) then batCounterV2Debounce = false; return end
    local function doCounterHit()
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local attChar = attacker.Character
        if not attChar then return end
        local attRoot = attChar:FindFirstChild("HumanoidRootPart")
        if not attRoot then return end
        if not hasAnimalEquipped(attacker) then batCounterV2Debounce = false; return end
        if sethiddenproperty then sethiddenproperty(hrp, "PhysicsRepRootPart", attRoot) end
        local targetPos = attRoot.Position + _V3new(0, 0.9, 0)
        if (hrp.Position - targetPos).Magnitude > 8 then hrp.CFrame = _CFnew(wallSafePosition(hrp, targetPos)) end
        tryHitBatCounterV2()
        task.delay(0.05, function() tryHitBatCounterV2() end)
        task.delay(0.1, function() tryHitBatCounterV2() end)
    end
    doCounterHit()
    task.delay(0.2, function()
        batCounterV2Debounce = false
    end)
end

function stopBatCounterV2()
    if batCounterV2Conn then
        batCounterV2Conn:Disconnect()
        batCounterV2Conn = nil
    end
    batCounterV2Debounce = false
    batCounterV2HitCooldown = false
end

function startBatCounterV2()
    if batCounterV2Conn then return end
    batCounterV2Conn = RunService.Heartbeat:Connect(function()
        if not batCounterV2Enabled then return end
        if batCounterV2Debounce then return end
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then return end
        local state = humanoid:GetState()
        local isBeingAttacked = state == Enum.HumanoidStateType.Physics or
                               state == Enum.HumanoidStateType.Ragdoll or
                               state == Enum.HumanoidStateType.FallingDown or
                               state == Enum.HumanoidStateType.GettingUp or
                               state == Enum.HumanoidStateType.Stunned
        if isBeingAttacked then
            local attacker = getAttackingPlayerWithAnimal()
            if attacker then
                if not isPlayerRagdolled(attacker) then
                    if hasAnimalEquipped(attacker) then
                        executeBatCounterV2()
                    end
                end
            end
        end
    end)
end

function toggleBatCounterV2()
    batCounterV2Enabled = not batCounterV2Enabled
    if batCounterV2Enabled then startBatCounterV2() else stopBatCounterV2() end
    return batCounterV2Enabled
end

function applyPersistedTogglePreferences()
    -- Primero apagar los modos guardados como OFF y después encender los ON;
    -- así se limpian estados viejos antes de restaurar la selección del usuario.
    if type(PERSISTED_TOGGLES) ~= "table" then return end
    -- Mientras se restauran los toggles, los guardados forzados de cada callback no deben
    -- sobrescribir las opciones que todavía no se han encendido.
    _restoringToggles = true
    _restoreToken = (_restoreToken or 0) + 1
    local _tok = _restoreToken
    task.delay(3, function() if _restoreToken == _tok then _restoringToggles = false end end)
    for _, wanted in ipairs({false, true}) do
        for name, value in pairs(PERSISTED_TOGGLES) do
            if value == wanted and name ~= "Drop Brainrot" then
                local setter = PERSISTED_TOGGLE_SETTERS[name]
                local callback = PERSISTED_TOGGLE_CALLBACKS[name]
                if setter then
                    pcall(setter, wanted)
                end
                if callback then
                    local ok, err = pcall(callback, wanted)
                    if not ok then
                        warn("[Visible] apply toggle '" .. tostring(name) .. "': " .. tostring(err))
                    end
                end
            end
        end
    end
end

function updateUIFromLoaded()
    task.wait()
    local function ss(fn, v)
        if fn then pcall(fn, v) end
    end
    pcall(function()
        ss(setCustomToolsVisual, _G.AmbitiousCustomToolsEnabled == true)
        ss(setCustomSoundsVisual, _G.AmbitiousCustomSoundsEnabled == true)
        if setCustomSkinBatLabel then setCustomSkinBatLabel(_G.AmbitiousCustomToolSkins.Bat) end
        if setCustomSkinMedusaLabel then setCustomSkinMedusaLabel(_G.AmbitiousCustomToolSkins.Medusa) end
        if stealSkinSelectorLabel and OUTFITS[currentOutfitIndex] then
            stealSkinSelectorLabel.Text = OUTFITS[currentOutfitIndex].label
        end
        pcall(visibleApplySkinFlags)
        if colorSelectorLabel then
            colorSelectorLabel.Text = COLOR_THEME_LABELS[currentColorTheme] or currentColorTheme
            colorSelectorLabel.TextColor3 = getThemeColor()
        end
        if MVPUI.buttonScaleBox then MVPUI.buttonScaleBox.Text = tostring(_floor(floatingButtonScale * 100)) end
    end)
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_CARRY_SPEED) end
    if batSpeedBox then batSpeedBox.Text = tostring(BYPASS_AIMBOT_SPEED) end
    if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    if infJumpModeBtn then infJumpModeBtn.Text = string.upper(InfiniteJump.mode == "manual" and "manual" or "hold") end
    if autoStealModeBtn then autoStealModeBtn.Text = autoStealMode end
    refreshSpeedModeLabel()

        local savedInfJumpEnabled = InfiniteJump.enabled == true
        InfiniteJump.stop()
    if savedInfJumpEnabled then
        InfiniteJump.start()
        if infJumpSetVisual then infJumpSetVisual(true) end
        elseif infJumpSetVisual then
            infJumpSetVisual(false)
        end

        -- Sincronizar también los toggles principales con los valores cargados.
        -- Antes sólo se actualizaban varios botones móviles, por lo que al guardar
        -- y volver a cargar la configuración el estado visible parecía apagarse.
        ss(autoBatSetVisual, autoBatEnabled)
        ss(autoLeftSetVisual, autoLeftEnabled)
        ss(autoRightSetVisual, autoRightEnabled)
        ss(setAntiBatVisual, antiBatEnabled)
        ss(setAntiFlingVisual, antiFlingEnabled)
        ss(setAntiDieVisual, antiDieEnabled)
        ss(setAutoTPDownVisual, autoTPDownEnabled)
        ss(setUnwalkVisual, unwalkEnabled)
        ss(setBatCounterVisual, batCounterEnabled)
        ss(setBatCounterV2Visual, batCounterV2Enabled)
        ss(setMedusaVisual, medusaCounterEnabled)
        ss(setAntiLagVisual, antiLagEnabled)
        ss(setESPVIsual, espEnabled)
        ss(setESPLineVisual, espLineEnabled)
        ss(setVividVisual, vividGraphicsEnabled)
        ss(setHideButtonsVisual, hideButtonsEnabled)
        ss(setLockUIVisual, uiLocked)

    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end

    if savedProgressBarPos and pbFrame then
        pbFrame.Position = UDim2.new(savedProgressBarPos.XScale or 0.5, savedProgressBarPos.XOffset or -210, savedProgressBarPos.YScale or 0.80, savedProgressBarPos.YOffset or 0)
    end

    applyBackgroundMode(backgroundMode)
    pcall(applyStealBackground, stealBgIndex)
    applyFloatingButtonScale()
    if MVPUI.fit then MVPUI.fit() end
    if MVPUI.motorLabel then MVPUI.motorLabel.Text = useVenixCarryEngine and "Carry Boost" or "Direct" end
    if MVPUI.carrySetter then MVPUI.carrySetter(MVPVenixCarry.softStealEnabled) end
    if MVPUI.carrySpeedBox then MVPUI.carrySpeedBox.Text = tostring(MVPVenixCarry.softStealSpeed) end
    if MVPUI.carryRadiusBox then MVPUI.carryRadiusBox.Text = tostring(MVPVenixCarry.softStealRadius) end
    if MVPUI.effectsSetter then MVPUI.effectsSetter(MVPUI.effects) end
    if MVPUI.lockButtonsSetter then MVPUI.lockButtonsSetter(mobileButtonsLocked) end

    if uiLocked and setLockUIVisual then setLockUIVisual(true) end

    if antiRagdollMode == "v1" or antiRagdollMode == "v2" then
        if _G.updateAntiRagdollUI then _G.updateAntiRagdollUI(antiRagdollMode) end
        setAntiRagdollMode(antiRagdollMode)
    else
        if _G.updateAntiRagdollUI then _G.updateAntiRagdollUI("off") end
    end

    if antiDieEnabled then
        if setAntiDieVisual then setAntiDieVisual(true) end
        AntiDieModule.start()
    else
        if setAntiDieVisual then setAntiDieVisual(false) end
    end

    if antiBatEnabled then
        if setAntiBatVisual then setAntiBatVisual(true) end
        startAntiBat()
    else
        if setAntiBatVisual then setAntiBatVisual(false) end
    end

    if antiFlingEnabled then
        if setAntiFlingVisual then setAntiFlingVisual(true) end
        startAntiFling()
    else
        if setAntiFlingVisual then setAntiFlingVisual(false) end
        stopAntiFling()
    end

    if autoTPDownEnabled then
        if setAutoTPDownVisual then setAutoTPDownVisual(true) end
        startAutoTPDown()
    else
        if setAutoTPDownVisual then setAutoTPDownVisual(false) end
        stopAutoTPDown()
    end

    if CONFIG.AUTO_STEAL_ENABLED and setInstaGrab then
        setInstaGrab(true)
        pcall(startAutoSteal)
    end

    -- El valor cargado no debe quedarse sólo en el aspecto visual del toggle:
    -- también hay que volver a levantar el proceso correspondiente.
    if autoLeftEnabled then
        if autoLeftSetVisual then autoLeftSetVisual(true) end
        pcall(startAutoLeft)
    elseif autoRightEnabled then
        if autoRightSetVisual then autoRightSetVisual(true) end
        pcall(startAutoRight)
    end

    if autoBatEnabled then
        autoBatEnabled = false
        enableAutoBat()
    end

    if medusaCounterEnabled then
        if setMedusaVisual then setMedusaVisual(true) end
        if LP.Character then setupMedusaCounter(LP.Character) end
    else
        if setMedusaVisual then setMedusaVisual(false) end
        stopMedusaCounter()
    end

    if batCounterEnabled and setBatCounterVisual then
        setBatCounterVisual(true)
        startBatCounter()
    end
    if batCounterV2Enabled and setBatCounterV2Visual then
        setBatCounterV2Visual(true)
        startBatCounterV2()
    end
    if unwalkEnabled and setUnwalkVisual then
        setUnwalkVisual(true)
        task.spawn(function() task.wait(0.5); startUnwalk() end)
    end
    if antiLagEnabled then
        if setAntiLagVisual then setAntiLagVisual(true) end
        enableAntiLag()
    else
        if setAntiLagVisual then setAntiLagVisual(false) end
        disableAntiLag()
    end
    if espEnabled then
        toggleESP(true)
        if setESPVIsual then setESPVIsual(true) end
    else
        toggleESP(false)
        if setESPVIsual then setESPVIsual(false) end
    end
    if espLineEnabled then
        if setESPLineVisual then setESPLineVisual(true) end
        startESPLine()
    else
        if setESPLineVisual then setESPLineVisual(false) end
        stopESPLine()
    end

    if vividGraphicsEnabled then
        enableVividGraphics()
        if setVividVisual then setVividVisual(true) end
    else
        disableVividGraphics()
        if setVividVisual then setVividVisual(false) end
    end

    if stretchEnabled then
        enableStretch()
        if _G.stretchToggleSetter then _G.stretchToggleSetter(true) end
    else
        if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    end

    if mobSetAutoBat then mobSetAutoBat(autoBatEnabled) end
    if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
    if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled) end
    if mobSetLagger2 then mobSetLagger2(laggerCarryToggled) end
    if mobSetBatV2 then mobSetBatV2(_G.__VisibleHubIsBatV2 and _G.__VisibleHubIsBatV2() or false) end

    if bodyLockEnabled and bodyLockSetVisual then
        if _blSuppressCount == 0 then
            bodyLockSetVisual(true)
            startBodyLock()
        else
            bodyLockSetVisual(false)
        end
    end

    updateProgressBarVisibility()
    startEnemySpeed()

    toggleLockUI(uiLocked)

    pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
    if outfitSelectorLabel and OUTFITS[currentOutfitIndex] then
        outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label
    end
    pcall(applyPersistedTogglePreferences)
end

local _bootErrors = {}

local function _bootSection(name, fn)
    print("[Visible Boot] Iniciando:", name)
    local ok, err = pcall(fn)
    if not ok then
        print("[Visible Boot] FALLÓ:", name, tostring(err))
        table.insert(_bootErrors, {name = name, err = tostring(err)})
        warn("[Visible Boot] Error en '" .. name .. "': " .. tostring(err))
    else
        print("[Visible Boot] OK:", name)
    end
    return ok
end

_bootSection("buildGui", function()
    buildGui()
end)

if gui and main then
    _bootSection("loadAllSettings", function()
        if loadAllSettings() then
            updateUIFromLoaded()
        end
    end)

    _bootSection("createMobilePanel", function()
        MobilePanel = createMobilePanel()
    end)

    if hideButtonsEnabled then
        _bootSection("applyHideButtons", function()
            applyHideButtons(true)
            if setHideButtonsVisual then setHideButtonsVisual(true) end
        end)
    end

    _bootSection("localizeVisibleHubInterface", function()
        if gui then localizeVisibleHubInterface(gui) end
        if MobilePanel then localizeVisibleHubInterface(MobilePanel) end
    end)

    if LP.Character then
        task.spawn(function()
            task.wait(0.1)
            if waitForCharReady(LP.Character, 5) then
                pcall(function() captureOriginalAppearance(LP.Character) end)
                pcall(function() setupMovementAndIndicators(LP.Character) end)
                if hyAnimOn and hyAnimPreset then
                    pcall(hyAnimApply, hyAnimPreset, false)
                end
                pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
            end
        end)
    end

    -- Los errores de arranque se registran internamente, pero no se muestra
    -- ningún panel rojo con el nombre VISIBLE HUB.
else
    warn("[Visible Boot] Fatal: buildGui falló. El script no puede continuar.")
end

if LP and LP.CharacterAdded then
    pcall(function()
        local _respawnQueue = 0
        LP.CharacterAdded:Connect(function(char)
            pcall(function()
                _respawnQueue = _respawnQueue + 1
                local myId = _respawnQueue

                local resumeSteal = PERSISTED_TOGGLES["Auto Steal"] == true or CONFIG.AUTO_STEAL_ENABLED
                local resumeLeft = PERSISTED_TOGGLES["Auto Left"] == true or autoLeftEnabled
                local resumeRight = PERSISTED_TOGGLES["Auto Right"] == true or autoRightEnabled
                local resumeAutoTPDown = PERSISTED_TOGGLES["Auto TP Down"] == true or autoTPDownEnabled
                local resumeUnwalk = PERSISTED_TOGGLES["Unwalk"] == true or unwalkEnabled
                local resumeInfiniteJump = PERSISTED_TOGGLES["Infinite Jump"] == true or InfiniteJump.enabled == true
                stopAutoSteal(false)
                CONFIG.AUTO_STEAL_ENABLED = resumeSteal
                if stopAutoLeft then stopAutoLeft() end
                if stopAutoRight then stopAutoRight() end
                if stopAutoTPDown then stopAutoTPDown() end
                if stopUnwalk then stopUnwalk() end
                if resumeInfiniteJump then InfiniteJump.stop() end
                if stopBatCounter then stopBatCounter() end
                if stopBatCounterV2 then stopBatCounterV2() end
                if stopMedusaCounter then stopMedusaCounter() end
                if stopUnwalk then stopUnwalk() end
                if stopDropBrainrot then stopDropBrainrot() end
                local resumeBypass = autoBatEnabled
                if autoBatEnabled and disableAutoBat then disableAutoBat() end
                if bodyLockEnabled and stopBodyLock then stopBodyLock() end

                local deadline = _tick() + 5
                while (not char.Parent) or (not char:FindFirstChild("HumanoidRootPart")) or (not char:FindFirstChildOfClass("Humanoid")) do
                    if _tick() > deadline then return end
                    if myId ~= _respawnQueue then return end
                    task.wait(0.05)
                end

                _hookedVelParts = {}
                local _hrpRespawn = _setupVelChecked(char)
                _hookVelHRP(_hrpRespawn)

                if not _originalAppearance then task.defer(function() captureOriginalAppearance(char) end) end
                if setupMovementAndIndicators then setupMovementAndIndicators(char) end
                if resumeBypass then enableAutoBat() end
                if antiRagdollMode == "v1" then
                    AntiRagdollV1.start()
                elseif antiRagdollMode == "v2" then
                    startAntiRagdollV2()
                end
                if antiBatEnabled then startAntiBat() end
                if antiFlingEnabled then startAntiFling() end
                if AntiDieModule.enabled then task.defer(function() activateOnCharacter(char) end) end
                if CONFIG.AUTO_STEAL_ENABLED then pcall(startAutoSteal) end
                if resumeLeft then
                    autoLeftEnabled = true
                    if autoLeftSetVisual then autoLeftSetVisual(true) end
                    pcall(startAutoLeft)
                elseif resumeRight then
                    autoRightEnabled = true
                    if autoRightSetVisual then autoRightSetVisual(true) end
                    pcall(startAutoRight)
                end
                if resumeAutoTPDown then
                    autoTPDownEnabled = true
                    if setAutoTPDownVisual then setAutoTPDownVisual(true) end
                    pcall(startAutoTPDown)
                end
                if resumeUnwalk then
                    unwalkEnabled = true
                    if setUnwalkVisual then setUnwalkVisual(true) end
                    pcall(startUnwalk)
                end
                if resumeInfiniteJump then
                    InfiniteJump.enabled = false
                    pcall(InfiniteJump.start)
                    if infJumpSetVisual then infJumpSetVisual(true) end
                end
                if bodyLockEnabled and _blSuppressCount == 0 then startBodyLock() end

                if medusaCounterEnabled then
                    setupMedusaCounter(char)
                    if setMedusaVisual then setMedusaVisual(true) end
                else
                    stopMedusaCounter()
                    if setMedusaVisual then setMedusaVisual(false) end
                end

                if batCounterEnabled then startBatCounter() end
                if batCounterV2Enabled then startBatCounterV2() end
                if unwalkEnabled then startUnwalk() end

                updateProgressBarVisibility()
                refreshSpeedModeLabel()

                pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
                if outfitSelectorLabel and OUTFITS[currentOutfitIndex] then
                    outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label
                end
                pcall(applyPersistedTogglePreferences)
            end)
        end)
    end)
end

local lastLaggerToggle = 0
local LAGGER_COOLDOWN = 0.3

UIS.InputBegan:Connect(function(input, gpe)
    if _anyKeyListening then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if gpe or UIS:GetFocusedTextBox() then return end
    elseif not isGamepadInput(input) then
        return
    end
    if not isBindableInput(input) then return end

    local kc = input.KeyCode
    if not kc then return end

    if kbMatch(KB.LaggerMode, kc) then
        if _tick() - lastLaggerToggle >= LAGGER_COOLDOWN then
            lastLaggerToggle = _tick()
            toggleLaggerCycle()
        end
        return
    end
    if kbMatch(KB.CarryToggle, kc) then toggleCarryMode(); return end
    if kbMatch(KB.DropBrainrot, kc) then
        if not dropActive then
            if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
            executeDropWithToggle(dropBrainrotSetVisual)
        end
        return
    end
    if kbMatch(KB.TPFloor, kc) then doTpDown(); return end
    if kbMatch(KB.AutoLeft, kc) then
        autoLeftEnabled = not autoLeftEnabled
        if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
        if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
        if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
        return
    end
    if kbMatch(KB.AutoRight, kc) then
        autoRightEnabled = not autoRightEnabled
        if autoRightEnabled then startAutoRight() else stopAutoRight() end
        if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
        if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
        return
    end
    if kbMatch(KB.AutoBat, kc) then
        if not autoBatEnabled then
            enableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(true) end
            if mobSetAutoBat then mobSetAutoBat(true) end
        else
            disableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(false) end
            if mobSetAutoBat then mobSetAutoBat(false) end
        end
        return
    end
    if kbMatch(KB.GuiHide, kc) then
        if main then
            if main.Visible then hideGui() else showGui() end
        end
        return
    end
end)

do 
    local function isHoldingBrainrot()
        local char = LP and LP.Character
        if not char then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and tonumber(hum.WalkSpeed) and hum.WalkSpeed < 25 then return true end
        for _, child in ipairs(char:GetChildren()) do
            local name = tostring(child.Name or ""):lower()
            if (child:IsA("Tool") or child:IsA("Model")) and
               (name:find("brainrot", 1, true) or name:find("animal", 1, true) or
                name:find("carry", 1, true) or name:find("grab", 1, true) or
                name:find("steal", 1, true) or name:find("hold", 1, true)) then
                return true
            end
        end
        return false
    end

end


-- ===== SKIN & SUARA BAT / MEDUSA (dipindahkan persis dari Blaxing: Custom Tools + Custom Sounds) =====
do
    local _Players    = game:GetService("Players")
    local _RunService = game:GetService("RunService")
    local _LP         = _Players.LocalPlayer

    -- Item riconosciuti (Bat / Slap Bat / Medusa's Head)
    local CT_ITEMS = {
        { key = "Bat",    match = function(n) n = n:lower() return n:find("bat") ~= nil or n:find("slap") ~= nil end },
        { key = "Medusa", match = function(n) return n:lower():find("medusa") ~= nil end },
    }

    local function ctMatchItem(inst)
        if not (inst:IsA("Tool") or inst:IsA("Model") or inst:IsA("Accessory") or inst:IsA("BasePart")) then
            return nil
        end
        for _, item in ipairs(CT_ITEMS) do
            if item.match(inst.Name) then return item end
        end
        return nil
    end

    local function isReplicaStuff(d)
        if d.Name == "LocalReplica" then return true end
        return d:FindFirstAncestor("LocalReplica") ~= nil
    end

    -- ------------------------------------------------------------
    -- GESTORE TRASPARENZA CONDIVISO
    -- Evita che Transparent e Custom Tools si sovrascrivano a vicenda.
    -- Ogni modulo "prenota" un valore, vince la priorita' piu' alta,
    -- e il valore originale vero viene letto una sola volta (baseline).
    -- ------------------------------------------------------------
    local CT_Trans = {}
    do
        local PRIORITY = { "custom", "rainbow", "transparent" }
        local baseline = setmetatable({}, { __mode = "k" })
        local claims   = setmetatable({}, { __mode = "k" })
        -- Connessioni GetPropertyChangedSignal("Transparency") per parte:
        -- servono a rimettere subito il valore se il gioco lo sovrascrive
        -- (e' il motivo per cui la bat originale ricompariva sopra la custom).
        local guards   = setmetatable({}, { __mode = "k" })

        function CT_Trans.getBaseline(part)
            local b = baseline[part]
            if b ~= nil then return b end
            local ok, val = pcall(function() return part.Transparency end)
            if not ok then return nil end
            baseline[part] = val
            return val
        end

        local function wantedValue(part)
            local c = claims[part]
            if not c then return nil end
            for _, who in ipairs(PRIORITY) do
                if c[who] ~= nil then return c[who] end
            end
            return nil
        end

        -- Scrive solo se il valore e' davvero diverso: il watchdog dei
        -- Custom Tools richiama claim() sulle stesse parti ogni 0.4s e
        -- senza questo controllo sarebbero centinaia di property write
        -- inutili al secondo.
        local function setIfDifferent(part, v)
            local ok, cur = pcall(function() return part.Transparency end)
            if ok and cur ~= nil and math.abs(cur - v) <= 0.001 then return end
            pcall(function() part.Transparency = v end)
        end

        local function resolve(part)
            local v = wantedValue(part)
            if v ~= nil then
                setIfDifferent(part, v)
                return
            end
            local b = baseline[part]
            if b ~= nil then
                setIfDifferent(part, b)
            end
        end

        -- Riapplica subito il valore prenotato se qualcun altro lo cambia.
        local function armGuard(part)
            if guards[part] then return end
            local ok, conn = pcall(function()
                return part:GetPropertyChangedSignal("Transparency"):Connect(function()
                    local v = wantedValue(part)
                    if v == nil then return end
                    local ok2, cur = pcall(function() return part.Transparency end)
                    if ok2 and cur ~= nil and math.abs(cur - v) > 0.001 then
                        pcall(function() part.Transparency = v end)
                    end
                end)
            end)
            if ok and conn then guards[part] = conn end
        end

        local function disarmGuard(part)
            local conn = guards[part]
            if conn then
                pcall(function() conn:Disconnect() end)
                guards[part] = nil
            end
        end

        -- Rete di sicurezza: se un evento e' andato perso (o la parte e'
        -- stata sostituita) il sweep periodico rimette tutto a posto.
        function CT_Trans.enforce()
            for part, _ in pairs(claims) do
                if part.Parent then
                    local v = wantedValue(part)
                    if v ~= nil then
                        local ok, cur = pcall(function() return part.Transparency end)
                        if ok and cur ~= nil and math.abs(cur - v) > 0.001 then
                            pcall(function() part.Transparency = v end)
                        end
                    end
                end
            end
        end

        function CT_Trans.claim(part, who, value)
            if not part then return end
            if CT_Trans.getBaseline(part) == nil then return end
            local c = claims[part]
            if not c then c = {}; claims[part] = c end
            c[who] = value
            armGuard(part)
            resolve(part)
        end

        function CT_Trans.release(part, who)
            if not part then return end
            local c = claims[part]
            if not c then return end
            c[who] = nil
            if next(c) == nil then
                claims[part] = nil
                disarmGuard(part)
            end
            if part.Parent then resolve(part) end
        end
    end

    -- ------------------------------------------------------------
    -- JANITOR: ogni 10s scarta le entry di oggetti non piu' esistenti,
    -- cosi' le tabelle non crescono in sessioni molto lunghe.
    -- ------------------------------------------------------------
    local CT_JANITORS = {}
    task.spawn(function()
        while true do
            task.wait(10)
            for _, fn in ipairs(CT_JANITORS) do pcall(fn) end
        end
    end)

    -- Sweep trasparenze: 4 volte al secondo rimette i valori prenotati.
    -- Gira solo se almeno uno dei tre moduli e' acceso.
    task.spawn(function()
        while true do
            task.wait(0.25)
            if _G.AmbitiousCustomToolsEnabled == true
            or _G.AmbitiousTransparentToolsEnabled == true
            or _G.AmbitiousRainbowToolsEnabled == true then
                pcall(CT_Trans.enforce)
            end
        end
    end)


    -- ############################################################
    -- ##                     CUSTOM TOOLS                       ##
    -- ## Bat -> Diamond Sword  Medusa's Head -> Golden Desert Eagle ##
    -- ############################################################
    do
        -- Catalogo skin. "cat" e' la categoria di oggetto su cui si applica.
        local ASSETS = {
            DiamondSword      = { cat = "Bat",    label = "Diamond Sword",
                                  mesh = "rbxassetid://8827558932", tex = "rbxassetid://8827558969",
                                  scale = Vector3.new(0.2, 0.2, 0.2),
                                  c0 = CFrame.new(-0.05, -0.1, -0.12) * CFrame.Angles(math.rad(90), math.rad(180), 300),
                                  -- view = distanza della camera nell'anteprima:
                                  -- piu' alta, piu' piccolo appare l'oggetto
                                  view = 4.9 },
            Katana            = { cat = "Bat",    label = "Katana",
                                  mesh = "rbxassetid://13528902482", tex = "rbxassetid://13528902373",
                                  scale = Vector3.new(1.4, 1.4, 1.4),
                                  c0 = CFrame.new(0, 0.6, 0) * CFrame.Angles(math.rad(270), math.rad(180), math.rad(180)),
                                  view = 6.6 },
            Skull             = { cat = "Medusa", label = "Skull",
                                  mesh = "rbxassetid://2050312704", tex = "rbxassetid://2050313393",
                                  scale = Vector3.new(1, 1, 1),
                                  c0 = CFrame.new(0, 0.65, -0.4) * CFrame.Angles(math.rad(330), 0, 0),
                                  view = 4.2 },
            GoldenDesertEagle = { cat = "Medusa", label = "Golden Desert Eagle",
                                  mesh = "rbxassetid://430251413", tex = "rbxassetid://435840335",
                                  scale = Vector3.new(0.01, 0.01, 0.01),
                                  c0 = CFrame.new(0, 0, -0.8) * CFrame.Angles(math.rad(330), math.rad(180), 0),
                                  view = 3.0 },
        }
        _G.AmbitiousCustomToolAssets = ASSETS

        -- Skin attualmente scelta per ogni categoria.
        _G.AmbitiousCustomToolSkins = _G.AmbitiousCustomToolSkins
            or { Bat = "DiamondSword", Medusa = "GoldenDesertEagle" }

        local function skinFor(cat)
            local key = _G.AmbitiousCustomToolSkins[cat]
            if key and ASSETS[key] and ASSETS[key].cat == cat then return key end
            return (cat == "Bat") and "DiamondSword" or "GoldenDesertEagle"
        end

        local enabled       = false
        local tracked       = setmetatable({}, { __mode = "k" })  -- [tool] = { hidden, conns }
        local watchers      = setmetatable({}, { __mode = "k" })
        local pendingHandle = setmetatable({}, { __mode = "k" })  -- [tool] = conn
        local teardown

        local function buildReplica(handle, mode)
            local existing = handle:FindFirstChild("LocalReplica")
            if existing then existing:Destroy() end

            local data = ASSETS[mode] or ASSETS.DiamondSword

            local m = Instance.new("Model")
            m.Name = "LocalReplica"

            local p = Instance.new("Part")
            p.Name        = "MainPart"
            p.CanCollide  = false
            p.CanQuery    = false
            p.CanTouch    = false
            p.Massless    = true
            p.Size        = Vector3.new(1, 1, 1)
            p.Transparency= 0
            p.Anchored    = false
            p.Parent      = m

            local mesh = Instance.new("SpecialMesh")
            mesh.MeshType  = Enum.MeshType.FileMesh
            mesh.MeshId    = data.mesh
            mesh.TextureId = data.tex
            mesh.Parent    = p

            local w = Instance.new("Motor6D")
            w.Part0 = handle
            w.Part1 = p

            -- Scala e impugnatura vengono dal catalogo, non da un if per skin
            mesh.Scale = data.scale
            w.C0 = data.c0

            w.Parent = p
            m.Parent = handle
            return m
        end

        -- Nasconde (NON distrugge) solo la grafica: parti, decal e texture.
        -- Suoni, script e componenti di gioco restano intatti.
        -- Idempotente di proposito: il watchdog lo richiama sulle stesse
        -- parti per ri-prenotare la trasparenza se e' stata persa.
        local function hideNode(entry, d)
            if isReplicaStuff(d) then return end
            if d:IsA("BasePart") or d:IsA("Decal") or d:IsA("Texture") then
                entry.hidden[d] = true
                CT_Trans.claim(d, "custom", 1)
            end
        end

        local function setupTool(tool)
            if tracked[tool] then return end

            local handle = tool:FindFirstChild("Handle")
            if not handle then
                if pendingHandle[tool] then return end
                local c
                c = tool.ChildAdded:Connect(function(child)
                    if child.Name == "Handle" then
                        pcall(function() c:Disconnect() end)
                        pendingHandle[tool] = nil
                        if enabled then setupTool(tool) end
                    end
                end)
                pendingHandle[tool] = c
                return
            end

            local entry = { hidden = {}, conns = {} }
            tracked[tool] = entry

            for _, d in ipairs(tool:GetDescendants()) do hideNode(entry, d) end

            local item = ctMatchItem(tool)
            local mode = skinFor((item and item.key == "Bat") and "Bat" or "Medusa")
            entry.cat = (item and item.key == "Bat") and "Bat" or "Medusa"
            buildReplica(handle, mode)

            table.insert(entry.conns, tool.DescendantAdded:Connect(function(d)
                task.defer(function()
                    if tracked[tool] then hideNode(entry, d) end
                end)
            end))
            table.insert(entry.conns, tool.AncestryChanged:Connect(function(_, parent)
                if not parent then teardown(tool, false) end
            end))
        end

        function teardown(tool, doRestore)
            local entry = tracked[tool]
            if not entry then return end
            for _, conn in ipairs(entry.conns) do pcall(function() conn:Disconnect() end) end

            local handle = tool:FindFirstChild("Handle")
            if handle then
                local rep = handle:FindFirstChild("LocalReplica")
                if rep then pcall(function() rep:Destroy() end) end
            end

            for obj in pairs(entry.hidden) do
                CT_Trans.release(obj, "custom")
            end
            entry.hidden = {}
            tracked[tool] = nil
        end

        local function tryRegister(inst)
            if not enabled then return end
            if inst:IsA("Tool") then
                local item = ctMatchItem(inst)
                if item and not (_G.VisibleToolSkinOff and _G.VisibleToolSkinOff[item.key]) then
                    setupTool(inst)
                end
            end
        end

        local function unwatch(container)
            local conns = watchers[container]
            if not conns then return end
            for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
            watchers[container] = nil
        end

        local function watch(container)
            if not container or watchers[container] then return end
            watchers[container] = { container.ChildAdded:Connect(tryRegister) }
            for _, child in ipairs(container:GetChildren()) do tryRegister(child) end
        end

        local function watchAll()
            watch(_LP:FindFirstChildOfClass("Backpack"))
            watch(_LP.Character)
        end

        _LP.ChildAdded:Connect(function(child)
            if enabled and child:IsA("Backpack") then watch(child) end
        end)

        _LP.CharacterAdded:Connect(function(char)
            for tool in pairs(tracked) do teardown(tool, false) end
            for _, c in pairs(pendingHandle) do pcall(function() c:Disconnect() end) end
            table.clear(pendingHandle)
            -- pulizia totale: il vecchio Character e il vecchio Backpack sono morti
            for container in pairs(watchers) do unwatch(container) end
            if not enabled then return end
            watch(char)
            task.defer(function()
                if enabled then watchAll() end
            end)
        end)

        table.insert(CT_JANITORS, function()
            for tool in pairs(tracked) do
                if not tool.Parent then teardown(tool, false) end
            end
            for tool, c in pairs(pendingHandle) do
                if not tool.Parent then
                    pcall(function() c:Disconnect() end)
                    pendingHandle[tool] = nil
                end
            end
            for container in pairs(watchers) do
                if not container.Parent then unwatch(container) end
            end
        end)

        -- ------------------------------------------------------------
        -- WATCHDOG INTEGRITA'
        -- Copre i due bug segnalati:
        --  1) la replica custom sparisce e resta solo l'arma originale
        --     (tool ri-parentato, Handle sostituito, replica distrutta);
        --  2) l'arma originale ricompare sopra la replica
        --     (trasparenza sovrascritta dal gioco -> ri-nascosta).
        -- ------------------------------------------------------------
        local function rebuildIfNeeded(tool, entry, deep)
            local handle = tool:FindFirstChild("Handle")
            if not handle then return end
            local rep      = handle:FindFirstChild("LocalReplica")
            local mainPart = rep and rep:FindFirstChild("MainPart")
            local motor    = mainPart and mainPart:FindFirstChildOfClass("Motor6D")
            local broken   = (not rep) or (not mainPart) or (not motor) or motor.Part0 ~= handle
            if broken then
                local item = ctMatchItem(tool)
                buildReplica(handle, skinFor((item and item.key == "Bat") and "Bat" or "Medusa"))
            end
            -- Ripassata completa solo se la replica era rotta o su richiesta
            if broken or deep then
                for _, d in ipairs(tool:GetDescendants()) do hideNode(entry, d) end
            end
        end

        -- deep = ripassa anche tutti i descendant dei tool (piu' costoso).
        -- Il giro leggero controlla solo che la replica esista: la
        -- trasparenza e' gia' coperta dai guard + sweep di CT_Trans.
        local function integrityPass(deep)
            if not enabled then return end
            -- ri-aggancia i container (Backpack ricreato, respawn, ecc.)
            watchAll()
            local bp = _LP:FindFirstChildOfClass("Backpack")
            if bp then for _, ch in ipairs(bp:GetChildren()) do tryRegister(ch) end end
            local chr = _LP.Character
            if chr then for _, ch in ipairs(chr:GetChildren()) do tryRegister(ch) end end
            for tool, entry in pairs(tracked) do
                if not tool.Parent then
                    teardown(tool, false)
                else
                    rebuildIfNeeded(tool, entry, deep)
                end
            end
        end

        _G.AmbitiousCustomToolsRecheck = function() pcall(integrityPass, true) end

        -- Cambio skin: aggiorna la scelta e ricostruisce subito le repliche
        -- gia' agganciate, senza dover spegnere e riaccendere il modulo.
        _G.AmbitiousSetCustomToolSkin = function(cat, key)
            if not ASSETS[key] or ASSETS[key].cat ~= cat then return end
            _G.AmbitiousCustomToolSkins[cat] = key
            for tool, entry in pairs(tracked) do
                if tool.Parent and entry.cat == cat then
                    local handle = tool:FindFirstChild("Handle")
                    if handle then pcall(buildReplica, handle, key) end
                end
            end
            if saveAllSettings then pcall(saveAllSettings) end
        end

        task.spawn(function()
            local n = 0
            while true do
                task.wait(0.4)
                if enabled then
                    n = n + 1
                    pcall(integrityPass, (n % 5) == 0)   -- deep ogni 2s
                end
            end
        end)

        -- Riapplica subito quando equipaggi/sganci un'arma, senza aspettare
        -- il giro del watchdog.
        _LP.CharacterAdded:Connect(function()
            task.delay(0.6, function() if enabled then pcall(integrityPass, true) end end)
        end)

        _G.VisibleToolSkinTeardownOff = function()
            local off = _G.VisibleToolSkinOff or {}
            for tool, entry in pairs(tracked) do
                if entry.cat and off[entry.cat] then teardown(tool, true) end
            end
        end

        _G.AmbitiousCustomTools = {
            setEnabled = function(on)
                on = on and true or false
                enabled = on
                _G.AmbitiousCustomToolsEnabled = on
                if on then
                    watchAll()
                    pcall(integrityPass, true)
                else
                    for tool in pairs(tracked) do teardown(tool, true) end
                    for _, c in pairs(pendingHandle) do pcall(function() c:Disconnect() end) end
                    table.clear(pendingHandle)
                    for container in pairs(watchers) do unwatch(container) end
                end
            end,
            isEnabled = function() return enabled end,
        }
    end

    -- ############################################################
    -- ##                    CUSTOM SOUNDS                       ##
    -- ##   Bat -> katana slash      Medusa -> gunshot           ##
    -- ##   Indipendente da Custom Tools: funziona anche da solo ##
    -- ############################################################
    do
        local SOUNDS = {
            Bat    = { id = "rbxassetid://5713085119", skip = 0.2 },
            Medusa = { id = "rbxassetid://3102797479", doublePlay = true, delay = 0.5 },
        }

        -- Un Sound puo' essere agganciato UNA volta sola: senza questo le
        -- connessioni si accumulavano a ogni re-equip (memory leak).
        local hooked = setmetatable({}, { __mode = "k" })

        local enabled       = false
        local tracked       = setmetatable({}, { __mode = "k" })  -- [tool] = { sound, data, conns, muted }
        local watchers      = setmetatable({}, { __mode = "k" })
        local pendingHandle = setmetatable({}, { __mode = "k" })
        local teardown

        local function playCustom(entry)
            local cs = entry.sound
            if not cs or not cs.Parent then return end
            local d = entry.data

            -- cancella un eventuale secondo colpo ancora in coda
            if entry.timer then
                pcall(task.cancel, entry.timer)
                entry.timer = nil
            end

            pcall(function()
                cs:Stop()
                cs.TimePosition = d.skip or 0
                cs.Volume = 1
                cs:Play()
            end)

            if d.doublePlay and d.delay then
                entry.timer = task.delay(d.delay, function()
                    entry.timer = nil
                    if not enabled then return end
                    if cs and cs.Parent then
                        pcall(function()
                            cs:Stop()
                            cs.TimePosition = d.skip or 0
                            cs.Volume = 1
                            cs:Play()
                        end)
                    end
                end)
            end
        end

        -- Silenzia il suono originale e fa partire quello custom
        local function hookSound(entry, snd)
            if not snd:IsA("Sound") then return end
            if snd.Name == "CustomSound" then return end
            if hooked[snd] then return end          -- gia' agganciato: niente doppioni
            if entry.muted[snd] ~= nil then return end

            entry.muted[snd] = snd.Volume
            hooked[snd] = true

            local function trigger()
                if not enabled then return end
                if snd.Playing or snd.TimePosition > 0 then
                    pcall(function()
                        snd.Volume = 0
                        snd:Stop()
                    end)
                    playCustom(entry)
                end
            end

            local c1 = snd:GetPropertyChangedSignal("Playing"):Connect(trigger)
            local c2 = snd:GetPropertyChangedSignal("TimePosition"):Connect(trigger)
            table.insert(entry.conns, c1)
            table.insert(entry.conns, c2)

            -- il Sound viene distrutto: si liberano subito le connessioni
            local c3
            c3 = snd.AncestryChanged:Connect(function(_, parent)
                if parent then return end
                pcall(function() c1:Disconnect() end)
                pcall(function() c2:Disconnect() end)
                pcall(function() c3:Disconnect() end)
                hooked[snd] = nil
                entry.muted[snd] = nil
                if entry.timer then
                    pcall(task.cancel, entry.timer)
                    entry.timer = nil
                end
            end)
            table.insert(entry.conns, c3)

            if snd.Playing then trigger() end
        end

        local function setupTool(tool)
            if tracked[tool] then return end

            local item = ctMatchItem(tool)
            if not item then return end
            if _G.VisibleSoundOff and _G.VisibleSoundOff[item.key] then return end
            local data = SOUNDS[item.key]
            if not data then return end

            local handle = tool:FindFirstChild("Handle")
            if not handle then
                if pendingHandle[tool] then return end
                local c
                c = tool.ChildAdded:Connect(function(child)
                    if child.Name == "Handle" then
                        pcall(function() c:Disconnect() end)
                        pendingHandle[tool] = nil
                        if enabled then setupTool(tool) end
                    end
                end)
                pendingHandle[tool] = c
                return
            end

            local old = handle:FindFirstChild("CustomSound")
            if old then pcall(function() old:Destroy() end) end

            local cs = Instance.new("Sound")
            cs.Name        = "CustomSound"
            cs.SoundId     = data.id
            cs.Volume      = 1
            cs.Looped      = false
            cs.RollOffMode = Enum.RollOffMode.Inverse
            cs.MaxDistance = 1000
            cs.MinDistance = 1000
            cs.Parent      = handle

            local entry = { sound = cs, data = data, conns = {}, muted = {} }
            tracked[tool] = entry

            for _, d in ipairs(tool:GetDescendants()) do hookSound(entry, d) end

            table.insert(entry.conns, tool.DescendantAdded:Connect(function(d)
                if tracked[tool] then hookSound(entry, d) end
            end))
            table.insert(entry.conns, tool.AncestryChanged:Connect(function(_, parent)
                if not parent then teardown(tool) end
            end))
        end

        function teardown(tool)
            local entry = tracked[tool]
            if not entry then return end
            if entry.timer then
                pcall(task.cancel, entry.timer)
                entry.timer = nil
            end
            for _, conn in ipairs(entry.conns) do pcall(function() conn:Disconnect() end) end
            if entry.sound then pcall(function() entry.sound:Destroy() end) end
            for snd, vol in pairs(entry.muted) do
                hooked[snd] = nil
                if snd and snd.Parent then pcall(function() snd.Volume = vol end) end
            end
            tracked[tool] = nil
        end

        local function tryRegister(inst)
            if not enabled then return end
            if inst:IsA("Tool") and ctMatchItem(inst) then setupTool(inst) end
        end

        local function unwatch(container)
            local conns = watchers[container]
            if not conns then return end
            for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
            watchers[container] = nil
        end

        local function watch(container)
            if not container or watchers[container] then return end
            watchers[container] = { container.ChildAdded:Connect(tryRegister) }
            for _, child in ipairs(container:GetChildren()) do tryRegister(child) end
        end

        local function watchAll()
            watch(_LP:FindFirstChildOfClass("Backpack"))
            watch(_LP.Character)
        end

        _LP.ChildAdded:Connect(function(child)
            if enabled and child:IsA("Backpack") then watch(child) end
        end)

        _LP.CharacterAdded:Connect(function(char)
            for tool in pairs(tracked) do teardown(tool) end
            for _, c in pairs(pendingHandle) do pcall(function() c:Disconnect() end) end
            table.clear(pendingHandle)
            for container in pairs(watchers) do unwatch(container) end
            if not enabled then return end
            watch(char)
            task.defer(function()
                if enabled then watchAll() end
            end)
        end)

        table.insert(CT_JANITORS, function()
            for tool in pairs(tracked) do
                if not tool.Parent then teardown(tool) end
            end
            for tool, c in pairs(pendingHandle) do
                if not tool.Parent then
                    pcall(function() c:Disconnect() end)
                    pendingHandle[tool] = nil
                end
            end
            for container in pairs(watchers) do
                if not container.Parent then unwatch(container) end
            end
        end)

        _G.VisibleSoundTeardownOff = function()
            local off = _G.VisibleSoundOff or {}
            for tool in pairs(tracked) do
                local it = ctMatchItem(tool)
                if it and off[it.key] then teardown(tool) end
            end
        end
        _G.VisibleSoundRescan = function()
            if not enabled then return end
            local bp = _LP:FindFirstChildOfClass("Backpack")
            if bp then for _, ch in ipairs(bp:GetChildren()) do tryRegister(ch) end end
            local chr = _LP.Character
            if chr then for _, ch in ipairs(chr:GetChildren()) do tryRegister(ch) end end
        end

        _G.AmbitiousCustomSounds = {
            setEnabled = function(on)
                on = on and true or false
                enabled = on
                _G.AmbitiousCustomSoundsEnabled = on
                if on then
                    watchAll()
                else
                    for tool in pairs(tracked) do teardown(tool) end
                    for _, c in pairs(pendingHandle) do pcall(function() c:Disconnect() end) end
                    table.clear(pendingHandle)
                    for container in pairs(watchers) do unwatch(container) end
                end
            end,
            isEnabled = function() return enabled end,
        }
    end
end

-- ============================================================
-- AIMBOT V2 (dipindahkan dari Ryzen: mode Normal + Anti Bypass)
-- ============================================================
do
    local AV = {
        mode = "Normal", on = false, autoSwing = true,
        swingGap = 0.12, swingRange = 12, nextSwing = 0,
        speed = 58, laggerSpeed = 40, abSpeed = 58, abLaggerSpeed = 40,
        conn = nil, charConn = nil, target = nil, lastScan = 0,
        stickyTarget = nil, stickyUntil = 0, prevAutoRotate = nil, swingCd = false,
    }
    _G.VisibleAimbotV2 = AV
    local STICKY_TIME, STICKY_MAX_DIST = 1.25, 85

    local function isLagger()
        return laggerToggled == true or laggerCarryToggled == true
    end
    local function curSpeed()
        -- la velocidad no baja al activar Carry/Lagger
        if AV.mode == "Anti Bypass" then return AV.abSpeed end
        return AV.speed
    end
    local function findBat()
        local char = LP.Character
        if char then
            for _, t in ipairs(char:GetChildren()) do
                if t:IsA("Tool") then
                    local n = t.Name:lower()
                    if n:find("bat") or n:find("slap") then return t end
                end
            end
        end
        local bp = LP:FindFirstChildOfClass("Backpack")
        if bp then
            for _, t in ipairs(bp:GetChildren()) do
                if t:IsA("Tool") then
                    local n = t.Name:lower()
                    if n:find("bat") or n:find("slap") then return t end
                end
            end
        end
        return nil
    end
    local function closest()
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then return nil, math.huge end
        local best, minDist = nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if tRoot and hum and hum.Health > 0 then
                    local d = (tRoot.Position - root.Position).Magnitude
                    if d < minDist then minDist, best = d, tRoot end
                end
            end
        end
        return best, minDist
    end
    local function stickyValid(root, tRoot)
        if not tRoot or not tRoot.Parent or not root then return false end
        local hum = tRoot.Parent:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return false end
        return (tRoot.Position - root.Position).Magnitude <= STICKY_MAX_DIST
    end
    local function getTarget()
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        local now = tick()
        if AV.stickyTarget and now < AV.stickyUntil and stickyValid(root, AV.stickyTarget) then
            AV.target = AV.stickyTarget
            return AV.stickyTarget
        end
        if now - AV.lastScan <= 0.08 and AV.target and stickyValid(root, AV.target) then
            return AV.target
        end
        AV.lastScan = now
        local c = closest()
        AV.target, AV.stickyTarget, AV.stickyUntil = c, c, now + STICKY_TIME
        return c
    end
    -- klik otomatis: equip bat -> Activate (klik) -> fire remote bat (sama seperti Bat Aimbot V1), ada cooldown
    local function swing()
        local now = tick()
        if now < AV.nextSwing then return end
        AV.nextSwing = now + AV.swingGap
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not hum or hum.Health <= 0 then return end
        local bat = findBat()
        if not bat then return end
        if bat.Parent ~= char then
            pcall(function() hum:EquipTool(bat) end)
        end
        pcall(function() bat:Activate() end)
        local remote = bat:FindFirstChildWhichIsA("RemoteEvent")
        if remote then pcall(function() remote:FireServer() end) end
    end
    -- ===== AIMBOT V1 (dari Zurichi: aimbot Zurichi dipindahkan persis, mesin ada di blok akhir file) =====
    local A1 = {speed = 60}
    -- status ON Aimbot V1 dibaca dari mesin Aimbot Zurichi (blok di akhir file)
    setmetatable(A1, {__index = function(_, k)
        if k == "on" then return (_G.__VisibleA1ZIsOn and _G.__VisibleA1ZIsOn()) and true or false end
    end})
    _G.VisibleAimbotV1 = A1
    local function refreshVisual()
        local on = AV.on or A1.on or ((_G.__VisibleAV3IsOn and _G.__VisibleAV3IsOn()) and true or false)
        if _G.__VisibleAV2SetVisual then pcall(_G.__VisibleAV2SetVisual, on) end
        if _G.__VisibleAV2MobSet then pcall(_G.__VisibleAV2MobSet, on) end
    end

    local function ensureLV(root)
        if AV.lv and AV.lv.Parent and AV.att and AV.att.Parent == root then
            AV.lv.Enabled = true
            return AV.lv
        end
        if AV.lv then pcall(function() AV.lv:Destroy() end) end
        if AV.att then pcall(function() AV.att:Destroy() end) end
        local att = Instance.new("Attachment")
        att.Name = "VisibleAV2Attachment"
        att.Parent = root
        local lv = Instance.new("LinearVelocity")
        lv.Name = "VisibleAV2LinearVelocity"
        lv.Attachment0 = att
        lv.RelativeTo = Enum.ActuatorRelativeTo.World
        lv.ForceLimitMode = Enum.ForceLimitMode.Magnitude
        lv.MaxForce = math.huge
        lv.VectorVelocity = Vector3.zero
        lv.Enabled = true
        lv.Parent = att
        AV.att, AV.lv = att, lv
        return lv
    end
    local function releaseLV()
        if AV.lv then pcall(function() AV.lv:Destroy() end); AV.lv = nil end
        if AV.att then pcall(function() AV.att:Destroy() end); AV.att = nil end
    end

    local function stop()
        AV.on = false
        releaseLV()
        if AV.conn then pcall(function() AV.conn:Disconnect() end); AV.conn = nil end
        if AV.charConn then pcall(function() AV.charConn:Disconnect() end); AV.charConn = nil end
        AV.target, AV.stickyTarget, AV.stickyUntil, AV.swingCd = nil, nil, 0, false
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if root then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
        if hum then
            hum.AutoRotate = (AV.prevAutoRotate == nil) and true or AV.prevAutoRotate
        end
        AV.prevAutoRotate = nil
        refreshVisual()
    end

    -- ===== MODE NORMAL: kode Ryzen persis (lock target sticky, terbang ke target, auto bat/klik) =====
    local function normalStep()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hum or not root then return end
        if hum.Health <= 0 then return end
        -- Ryzen: PlatformStand recovery
        if hum.PlatformStand then pcall(function() hum.PlatformStand = false end) end
        -- Ryzen fling recovery
        pcall(function()
            local lv, av = root.AssemblyLinearVelocity, root.AssemblyAngularVelocity
            -- no confundir el spike del Anti Bat con un fling
            if not _G._AmbitiousAntiBatSpiking and lv.Magnitude > 220 then root.AssemblyLinearVelocity = lv.Unit * 60 end
            if av.Magnitude > 25 then root.AssemblyAngularVelocity = Vector3.zero end
        end)
        -- equip bat
        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target = getTarget()
        if not target then
            hum.AutoRotate = true
            root.AssemblyAngularVelocity = Vector3.zero
            return
        end
        AV.target = target
        hum.AutoRotate = false
        local targetVel = target.AssemblyLinearVelocity or Vector3.zero
        local myPos = root.Position
        local targetPos = target.Position
        local predictPos = targetPos + targetVel * 0.14 + target.CFrame.LookVector * 0.3
        local direction = predictPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0.01 then flatDir = flatDir.Unit else flatDir = Vector3.new(0, 0, 1) end
        local chaseSpeed = curSpeed()
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
        yVel = math.clamp(yVel, -70, 110)
        local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
        root.AssemblyLinearVelocity = _G.__VisibleCleanVel(root):Lerp(desiredVel, 0.8)
        pcall(_G.__VisiblePublishAntiBatVel, root)
        -- Ryzen rotation with CFrame
        local predictedPos = targetPos + targetVel * math.clamp(targetVel.Magnitude / 150, 0.05, 0.2)
        if (predictedPos - myPos).Magnitude > 0.1 then
            local look = Vector3.new(predictedPos.X, myPos.Y, predictedPos.Z)
            root.CFrame = CFrame.new(myPos, look)
            root.AssemblyAngularVelocity = Vector3.zero
        end
        -- auto swing (Ryzen: bat:Activate)
        if AV.autoSwing then
            local bat = char:FindFirstChildOfClass("Tool") or findBat()
            if bat and bat:IsA("Tool") then pcall(function() bat:Activate() end) end
        end
    end

    -- ===== MODE ANTI BYPASS: kode Ryzen persis =====
    local AB = {SPEED = 63, VERT_SPEED = 52, DISTANCE = -2.8, HEIGHT = 4.75, V_OFFSET = 1, MAX_TURN_RATE = 28}
    local function abEnsureBat()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not hum then return nil end
        local equipped = char:FindFirstChildOfClass("Tool")
        if equipped then return equipped end
        local bat = findBat()
        if bat then pcall(function() hum:EquipTool(bat) end) end
        return bat
    end
    local function abTrySwing()
        pcall(function()
            local bat = abEnsureBat()
            if bat and bat:IsA("Tool") then bat:Activate() end
        end)
    end
    local function antiBypassStep()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hum or not root or hum.Health <= 0 then return end
        hum.AutoRotate = false
        abEnsureBat()
        local target, targetDist = closest()
        if not target then
            root.AssemblyAngularVelocity = Vector3.zero
            return
        end
        local aimTargetPos = target.Position + Vector3.new(0, AB.V_OFFSET, 0)
        local look = aimTargetPos - root.Position
        local flatLook = Vector3.new(look.X, 0, look.Z)
        if flatLook.Magnitude > 0.01 then
            local targetYaw = math.deg(math.atan2(-flatLook.X, -flatLook.Z))
            local yawDelta = (targetYaw - root.Orientation.Y + 180) % 360 - 180
            local yawRate = math.clamp(yawDelta * 8, -AB.MAX_TURN_RATE, AB.MAX_TURN_RATE)
            root.AssemblyAngularVelocity = Vector3.new(0, yawRate, 0)
        else
            root.AssemblyAngularVelocity = Vector3.zero
        end
        if look.Magnitude > 0.01 then
            local dir = look.Unit
            local standPos = aimTargetPos - (dir * AB.DISTANCE) + Vector3.new(0, AB.HEIGHT, 0)
            local moveDir = standPos - root.Position
            local hDir = Vector3.new(moveDir.X, 0, moveDir.Z)
            local hVel = hDir.Magnitude > 0.1 and hDir.Unit * AB.SPEED or Vector3.zero
            local vVel = Vector3.new(0, math.clamp(moveDir.Y * 3, -AB.VERT_SPEED, AB.VERT_SPEED), 0)
            root.AssemblyLinearVelocity = hVel + vVel
            pcall(_G.__VisiblePublishAntiBatVel, root)
            if hDir.Magnitude > 0.5 then hum:Move(hDir.Unit, false) end
        end
        if AV.autoSwing and targetDist < 13 then abTrySwing() end
    end

    local function start()
        -- matikan fitur lain yang bentrok
        pcall(function() if autoBatEnabled and disableAutoBat then disableAutoBat() end end)
        pcall(function()
            if bodyLockEnabled then
                bodyLockEnabled = false
                if stopBodyLock then stopBodyLock() end
                if bodyLockSetVisual then bodyLockSetVisual(false) end
            end
        end)
        if AV.conn then pcall(function() AV.conn:Disconnect() end); AV.conn = nil end
        AV.on = true
        AV.target, AV.stickyTarget, AV.stickyUntil, AV.lastScan = nil, nil, 0, 0
        local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum0 and AV.prevAutoRotate == nil then AV.prevAutoRotate = hum0.AutoRotate end
        AV.conn = RunService.Heartbeat:Connect(function()
            if not AV.on then return end
            if AV.mode == "Anti Bypass" then antiBypassStep() else normalStep() end
        end)
        if AV.charConn then pcall(function() AV.charConn:Disconnect() end) end
        AV.charConn = LP.CharacterAdded:Connect(function(char)
            if not AV.on then return end
            task.wait(0.25)
            local root = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 3)
            local hum = char:FindFirstChildOfClass("Humanoid")
            pcall(function()
                if root then
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                end
                if hum then
                    hum.PlatformStand = false
                    hum.AutoRotate = false
                    local bat = findBat()
                    if bat then hum:EquipTool(bat) end
                end
            end)
        end)
        refreshVisual()
        return true
    end

    local function refreshBoxes()
        local n = AV.mode == "Anti Bypass" and AV.abSpeed or AV.speed
        local l = AV.mode == "Anti Bypass" and AV.abLaggerSpeed or AV.laggerSpeed
        if _G.__VisibleAV2SpeedBox then _G.__VisibleAV2SpeedBox.Text = tostring(n) end
        if _G.__VisibleAV2LaggerBox then _G.__VisibleAV2LaggerBox.Text = tostring(l) end
    end

    function A1.stop()
        if _G.__VisibleA1ZStop then pcall(_G.__VisibleA1ZStop) end
        refreshVisual()
    end

    function A1.start()
        local okA1 = _G.__VisibleA1ZStart and _G.__VisibleA1ZStart()
        refreshVisual()
        return okA1 == true
    end

    -- ===== satu toggle/tombol Aimbot untuk V1 dan V2 (versi dipilih lewat aimbotVersion) =====
    function A1.isOn() return AV.on or A1.on or ((_G.__VisibleAV3IsOn and _G.__VisibleAV3IsOn()) and true or false) end
    function A1.startSel()
        pcall(function() if _G.__VisibleLagStop then _G.__VisibleLagStop() end end) -- matikan Bat Bypas V2 (Bat Bypass)
        if aimbotVersion == 3 then
            if AV.on then stop() end
            if A1.on then A1.stop() end
            local okV3 = _G.__VisibleAV3Start and _G.__VisibleAV3Start()
            refreshVisual()
            return okV3 == true
        end
        if _G.__VisibleAV3Stop then pcall(_G.__VisibleAV3Stop) end
        if aimbotVersion == 1 then
            if AV.on then stop() end
            return A1.start()
        end
        if A1.on then A1.stop() end
        return start()
    end
    function A1.stopSel()
        if _G.__VisibleAV3Stop then pcall(_G.__VisibleAV3Stop) end
        if AV.on then stop() end
        if A1.on then A1.stop() end
        refreshVisual()
    end
    _G.__VisibleAV2Start = A1.startSel
    _G.__VisibleAV2Stop = A1.stopSel
    _G.__VisibleAimbotIsOn = A1.isOn
    _G.__VisibleAimbotVersionRefresh = function()
        local v = (aimbotVersion == 3 and 3) or (aimbotVersion == 1 and 1) or 2
        if _G.__VisibleAimbotVersionLabel then pcall(function() _G.__VisibleAimbotVersionLabel.Text = "V" .. v end) end
        if _G.__VisibleAimbotMobLabel then pcall(function()
            _G.__VisibleAimbotMobLabel.Text = "AUTO\nBAT"
            local g = _G.__VisibleAimbotMobLabel.Parent and _G.__VisibleAimbotMobLabel.Parent:FindFirstChild("Glyph")
            if g then g.Text = "V" .. tostring(v) end
        end) end
    end
    _G.__VisibleAimbotVersionSet = function(v)
        v = tonumber(v)
        v = (v == 3 and 3) or (v == 1 and 1) or 2
        if v == aimbotVersion then _G.__VisibleAimbotVersionRefresh(); return end
        local wasOn = A1.isOn()
        if wasOn then A1.stopSel() end
        aimbotVersion = v
        if wasOn then A1.startSel() end
        _G.__VisibleAimbotVersionRefresh()
        refreshVisual()
        if saveAllSettings then pcall(saveAllSettings) end
    end
    _G.__VisibleAimbotVersionCycle = function()
        _G.__VisibleAimbotVersionSet(aimbotVersion % 3 + 1)
    end
    _G.__VisibleAV1SetSpeed = function(v)
        A1.speed = v
        if _G.VisibleAimbotV1Z then _G.VisibleAimbotV1Z.speed = v end
    end
    _G.__VisibleAV1RefreshUI = function()
        if _G.__VisibleAV1SpeedBox then pcall(function() _G.__VisibleAV1SpeedBox.Text = tostring(A1.speed) end) end
    end
    do -- terapkan setelan V1 yang sudah dimuat dari config
        local pend = _G.__VisibleAV1Pending
        if type(pend) == "table" and tonumber(pend.speed) and pend.speed > 0 then A1.speed = pend.speed end
        _G.__VisibleAV1RefreshUI()
        _G.__VisibleAimbotVersionRefresh()
    end
    _G.__VisibleAV2SetMode = function(mode)
        mode = (mode == "Anti Bypass") and "Anti Bypass" or "Normal"
        local wasOn = AV.on
        if wasOn then stop() end
        AV.mode = mode
        refreshBoxes()
        if wasOn then start() end
    end
    _G.__VisibleAV2SetSpeed = function(normal, lagger)
        if AV.mode == "Anti Bypass" then
            if normal then AV.abSpeed = normal end
            if lagger then AV.abLaggerSpeed = lagger end
        else
            if normal then AV.speed = normal end
            if lagger then AV.laggerSpeed = lagger end
        end
    end
    _G.__VisibleAV2SetAutoSwing = function(on) AV.autoSwing = on == true end
    do -- terapkan setelan Aimbot V2 + status ON yang dimuat dari config
        local pend = _G.__VisibleAV2Pending
        if type(pend) == "table" then
            local function sp(v, d) v = tonumber(v); if v and v > 0 and v <= 250 then return v end return d end
            AV.mode = (pend.mode == "Anti Bypass") and "Anti Bypass" or "Normal"
            AV.speed = sp(pend.speed, AV.speed)
            AV.laggerSpeed = sp(pend.laggerSpeed, AV.laggerSpeed)
            AV.abSpeed = sp(pend.abSpeed, AV.abSpeed)
            AV.abLaggerSpeed = sp(pend.abLaggerSpeed, AV.abLaggerSpeed)
            AV.autoSwing = true -- auto klik selalu aktif saat aimbot dipakai
            _G.__VisibleAV2Pending = nil
        end
        pcall(refreshBoxes)
        if _G.__VisibleAV2ModeLabel then pcall(function() _G.__VisibleAV2ModeLabel.Text = AV.mode end) end
        if _G.__VisibleAV2AutoSwingSet then pcall(_G.__VisibleAV2AutoSwingSet, AV.autoSwing) end
        if _G.__VisibleAimbotPending then
            _G.__VisibleAimbotPending = nil
            task.delay(2, function() pcall(A1.startSel) end)
        end
    end
end


-- ============================================================
-- BAT BYPAS V2 (dipindahkan persis dari "Bypass Bat" milik Fira Duel:
-- lock target terdekat, terbang/dorong ke target pakai Velocity + AngularVelocity,
-- bersihkan lock/anti-aim di badan, putar badan ke target, auto klik bat saat dalam jarak 12).
-- Bat Bypas V2 lama (versi Blaxing) sudah dihapus dan diganti dengan ini.
-- ============================================================
xpcall(function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local LP = Player
local LAG = {on = false, speed = 58, laggerSpeed = 40, suppressed = false, target = nil}
_G.VisibleAimbotLagger = LAG
do
    local pend = tonumber(_G.__VisibleLagPendingSpeed)
    if pend and pend > 0 and pend <= 250 then LAG.speed = pend end
    local pendL = tonumber(_G.__VisibleLagPendingLagger)
    if pendL and pendL > 0 and pendL <= 250 then LAG.laggerSpeed = pendL end
end

local lagStop
local circleConnection = nil
local circleSafetyConn = nil

local function getChaseSpeed()
    if laggerToggled == true or laggerCarryToggled == true then
        return tonumber(LAG.laggerSpeed) or 40
    end
    return tonumber(LAG.speed) or 58
end

local ADAPT_BP_ANG = "_AdaptBP_AngV"
local ADAPT_BP_ATT = "_AdaptBP_Att"
local ADAPT_BP_CLEAN = {
    "LockBAV", "LockAngVel", "LockBodyAtt", "BatLock", "LockBAVAtt",
    "AutoBatAtt", "AutoBatAV", "AntiBatDet", "AntiAim", "VelocityLock",
}
local ADAPT_BP_SWING_RANGE = 12

local adaptBP = {
    equipped = false,
    target = nil,
    intendedVelocity = Vector3.zero,
    angularVelocity = nil,
    attachment = nil,
    respawnConn = nil,
}
_G.__VisibleHubBubbleAimbotState = adaptBP

local function adaptBPClean(root)
    if not root then return end
    pcall(function()
        for _, n in ipairs(ADAPT_BP_CLEAN) do
            local c = root:FindFirstChild(n)
            if c then c:Destroy() end
        end
        for _, child in ipairs(root:GetChildren()) do
            if child.Name ~= ADAPT_BP_ANG and child.Name ~= ADAPT_BP_ATT then
                local ln = child.Name:lower()
                if ln:find("lockb") or ln:find("lockangv") or ln:find("batlock")
                   or ln:find("antiaim") or ln:find("velocitylock") then
                    child:Destroy()
                end
            end
        end
    end)
end

local function adaptBPEnsureAngular(parent)
    pcall(function()
        local a = parent:FindFirstChild(ADAPT_BP_ANG); if a then a:Destroy() end
        local b = parent:FindFirstChild(ADAPT_BP_ATT); if b then b:Destroy() end
    end)
    local att = Instance.new("Attachment")
    att.Name = ADAPT_BP_ATT
    att.Parent = parent
    local angV = Instance.new("AngularVelocity")
    angV.Name = ADAPT_BP_ANG
    angV.Attachment0 = att
    angV.RelativeTo = Enum.ActuatorRelativeTo.World
    angV.MaxTorque = math.huge
    angV.AngularVelocity = Vector3.zero
    angV.Parent = parent
    adaptBP.attachment = att
    adaptBP.angularVelocity = angV
end

local function adaptBPRemoveAngular()
    pcall(function()
        if adaptBP.angularVelocity and adaptBP.angularVelocity.Parent then adaptBP.angularVelocity:Destroy() end
    end)
    pcall(function()
        if adaptBP.attachment and adaptBP.attachment.Parent then adaptBP.attachment:Destroy() end
    end)
    adaptBP.angularVelocity = nil
    adaptBP.attachment = nil
end

local function adaptBPFindBat()
    local char = LP.Character
    if not char then return nil end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            local n = child.Name:lower()
            if n:find("bat") or n:find("slap") then return child end
        end
    end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") then
                local n = child.Name:lower()
                if n:find("bat") or n:find("slap") then return child end
            end
        end
    end
    return nil
end

local function adaptBPNearest(fromRoot)
    local best, bestDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local d = (hrp.Position - fromRoot.Position).Magnitude
                if d < bestDist then bestDist = d; best = hrp end
            end
        end
    end
    return best, bestDist
end

local function startCircleCombat()
    if circleConnection then return end
    adaptBP.equipped = false
    adaptBP.target = nil
    adaptBP.intendedVelocity = Vector3.zero

    local c0 = LP.Character
    local r0 = c0 and c0:FindFirstChild("HumanoidRootPart")
    if r0 then
        adaptBPClean(r0)
        adaptBPEnsureAngular(r0)
    end

    circleConnection = RunService.Heartbeat:Connect(function()
        if _mySession ~= _G.VisibleHubSession then
            if circleConnection then circleConnection:Disconnect(); circleConnection = nil end
            return
        end
        if not LAG.on then return end
        local char = LP.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root or not humanoid or humanoid.Health <= 0 then return end

        adaptBPClean(root)
        if not adaptBP.angularVelocity or not adaptBP.angularVelocity.Parent then
            adaptBPEnsureAngular(root)
        end

        if not adaptBP.equipped then
            adaptBP.equipped = true
            if not char:FindFirstChildOfClass("Tool") then
                local b = adaptBPFindBat()
                if b then pcall(function() humanoid:EquipTool(b) end) end
            end
        end

        local target, dist = adaptBPNearest(root)
        if not target then
            adaptBP.target = nil
            LAG.target = nil
            humanoid.AutoRotate = true
            if adaptBP.angularVelocity then adaptBP.angularVelocity.AngularVelocity = Vector3.zero end
            return
        end
        adaptBP.target = target
        LAG.target = target

        local aimPos = target.Position
            + target.CFrame.LookVector * (target.Velocity.Magnitude < 0.1 and 1.5 or 5)
        local delta = aimPos - root.Position
        local flat = Vector3.new(delta.X, 0, delta.Z)
        humanoid.AutoRotate = false

        if delta.Magnitude > 0.01 and flat.Magnitude > 0.01 then
            local curY = root.Orientation.Y
            local yawD = (math.deg(math.atan2(-flat.X, -flat.Z)) - curY + 180) % 360 - 180
            local curX = root.Orientation.X
            local pitchD = (math.deg(math.atan2(delta.Y, flat.Magnitude)) - curX + 180) % 360 - 180
            local rotY = math.clamp(math.rad(yawD) * 40, -28, 28)
            local rotX = math.clamp(math.rad(pitchD) * 40, -28, 28)
            local yawR = math.rad(root.Orientation.Y)
            local fwd = Vector3.new(math.cos(yawR), 0, -math.sin(yawR))
            adaptBP.angularVelocity.AngularVelocity = Vector3.new(0, rotY, 0) + fwd * rotX
        else
            adaptBP.angularVelocity.AngularVelocity = Vector3.zero
        end

        local spd = getChaseSpeed()
        if spd ~= spd or spd <= 0 or spd == math.huge then spd = 58 end

        adaptBP.intendedVelocity =
            (flat.Magnitude > 0.1 and flat.Unit * spd or Vector3.zero)
            + (math.abs(delta.Y) > 0.8
                and Vector3.new(0, math.sign(delta.Y) * spd, 0)
                or Vector3.new(0, -2, 0))
        root.Velocity = adaptBP.intendedVelocity

        if flat.Magnitude > 0.5 then
            pcall(function() humanoid:Move(flat.Unit, false) end)
        end

        if dist <= ADAPT_BP_SWING_RANGE then
            local bat = char:FindFirstChildOfClass("Tool")
            if bat and isBatTool and isBatTool(bat) then
                pcall(function()
                    bat:Activate()
                    local re = bat:FindFirstChildWhichIsA("RemoteEvent")
                    if re then re:FireServer() end
                end)
            end
        end
    end)

    circleSafetyConn = RunService.RenderStepped:Connect(function()
        if not LAG.on then return end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local v = root.Velocity
        if math.abs(v.X) > 350 or math.abs(v.Z) > 350 then
            root.Velocity = adaptBP.intendedVelocity
        end
        adaptBPClean(root)
    end)

    if not adaptBP.respawnConn then
        adaptBP.respawnConn = LP.CharacterAdded:Connect(function(character)
            task.wait(0.5)
            adaptBP.equipped = false
            adaptBP.target = nil
            if LAG.on then
                local root = character:WaitForChild("HumanoidRootPart", 5)
                if root then
                    adaptBPClean(root)
                    adaptBPEnsureAngular(root)
                end
            end
        end)
    end
end

local function stopCircleCombat()
    if circleConnection then
        circleConnection:Disconnect()
        circleConnection = nil
    end
    if circleSafetyConn then
        circleSafetyConn:Disconnect()
        circleSafetyConn = nil
    end
    adaptBP.equipped = false
    adaptBP.target = nil
    LAG.target = nil

    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if root then
        pcall(function() root.Velocity = root.Velocity * 0.3 end)
    end
    if hum then hum.AutoRotate = true end
    if adaptBP.angularVelocity then
        pcall(function() adaptBP.angularVelocity.AngularVelocity = Vector3.zero end)
    end
    adaptBPRemoveAngular()
    if root then
        local a = root:FindFirstChild(ADAPT_BP_ANG); if a then a:Destroy() end
        local at = root:FindFirstChild(ADAPT_BP_ATT); if at then at:Destroy() end
    end
end

-- ===== start / stop untuk Bat Bypas V2 (dipilih lewat selector Bat Bypass) =====
-- (isi lagStop = stopAimbotAdapt milik Fira Duel)
lagStop = function()
    if not LAG.on and not circleConnection then return end
    LAG.on = false
    pcall(stopCircleCombat)
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = (_prevAutoRotate == nil) and true or _prevAutoRotate
        hum.PlatformStand = false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    if root then
        root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
        root.AssemblyAngularVelocity = Vector3.zero
    end
    _prevAutoRotate = nil
    if LAG.suppressed then
        LAG.suppressed = false
        pcall(_unsuppressBodyLock, true)
    end
end

-- (isi lagStart = startAimbotAdapt milik Fira Duel)
local function lagStart(fromBat)
    if LAG.on then return true end
    local char = Player.Character
    if not char or not char:FindFirstChildOfClass("Humanoid") or not char:FindFirstChild("HumanoidRootPart") then
        return false
    end
    -- matikan aimbot / fitur lain yang bentrok
    pcall(function() if _G.__VisibleLagStop then _G.__VisibleLagStop() end end)
    pcall(function() if _G.__VisibleAV2Stop then _G.__VisibleAV2Stop() end end)
    if not fromBat then pcall(function() if autoBatEnabled and disableAutoBat then disableAutoBat() end end) end
    pcall(function()
        if _G.__VisibleHubIsBatV2 and _G.__VisibleHubIsBatV2() then
            _G.__VisibleHubStopBatV2()
            if mobSetBatV2 then mobSetBatV2(false) end
        end
    end)
    pcall(function()
        if autoLeftEnabled then
            autoLeftEnabled = false
            if stopAutoLeft then stopAutoLeft() end
            if autoLeftSetVisual then autoLeftSetVisual(false) end
            if mobSetAutoLeft then mobSetAutoLeft(false) end
        end
        if autoRightEnabled then
            autoRightEnabled = false
            if stopAutoRight then stopAutoRight() end
            if autoRightSetVisual then autoRightSetVisual(false) end
            if mobSetAutoRight then mobSetAutoRight(false) end
        end
    end)
    if not LAG.suppressed then
        LAG.suppressed = true
        pcall(_suppressBodyLock)
    end
    local hum0 = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    if hum0 and _prevAutoRotate == nil then _prevAutoRotate = hum0.AutoRotate end
    LAG.on = true
    startCircleCombat()
    return true
end

_G.__VisibleLagStart = lagStart
_G.__VisibleLagStop = lagStop
_G.__VisibleLagIsOn = function() return LAG.on end
_G.__VisibleLagSetSpeed = function(normal, lagger)
    if normal and normal > 0 then LAG.speed = normal; _G.__VisibleLagPendingSpeed = normal end
    if lagger and lagger > 0 then LAG.laggerSpeed = lagger; _G.__VisibleLagPendingLagger = lagger end
end
_G.__VisibleLagRefreshUI = function()
    if _G.__VisibleLagSpeedBox then pcall(function() _G.__VisibleLagSpeedBox.Text = tostring(LAG.speed) end) end
    if _G.__VisibleLagLaggerBox then pcall(function() _G.__VisibleLagLaggerBox.Text = tostring(LAG.laggerSpeed) end) end
end
pcall(_G.__VisibleLagRefreshUI)
end, function(e) warn("[Visible] Bat Bypas V2 gagal dimuat: " .. tostring(e)) end)


-- ============================================================
-- AIMBOT BYPAS V3 (aimbot "Bat Bypass" milik Vape dipindahkan persis: lock target terdekat,
-- terbang/dorong ke target pakai AssemblyLinearVelocity + prediksi ping, auto klik bat saat dekat)
-- ============================================================
xpcall(function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local V3 = {on = false, conn = nil, speed = 60, laggerSpeed = 40, suppressed = false}
_G.__VisibleBV3 = V3
do
    local pend = _G.__VisibleBV3Pending
    if type(pend) == "table" then
        if tonumber(pend.speed) and pend.speed > 0 then V3.speed = pend.speed end
        if tonumber(pend.lagger) and pend.lagger > 0 then V3.laggerSpeed = pend.lagger end
    end
end

V3.Z = {
    targetPlayer = nil, lastTargetPos = nil, targetVelocity = Vector3.zero, smoothedVelocity = Vector3.zero,
    velocityHistory = {}, accelerationHistory = {}, aerialVelocityHistory = {},
    previousDirection = nil, lastDirectionChangeTime = 0, airborneTime = 0,
    lastActivationTime = 0, currentPing = 0.1, realPingMs = 0,
}
V3.ZCFG = {
    FOLLOW_SPEED = 60,
    ACTIVATE_DISTANCE = 13,
    MIN_FOLLOW_DISTANCE = 1,
    PREDICTION_TIME = 0.22,
    PREDICT_AHEAD = 3,
    MAX_VELOCITY_CHANGE = 150,
    VELOCITY_SMOOTHING = 0.2,
    MAX_HORIZONTAL_VELOCITY = 80,
    SERVER_TICKRATE = 0.016666666666666666,
    MIN_PING_COMPENSATION = 0.03,
    MAX_PING_COMPENSATION = 0.25,
    ACCELERATION_PREDICTION_WEIGHT = 0.3,
    DIRECTION_CHANGE_DETECTION_TIME = 0.12,
    QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
    GRAVITY = 196.2,
    AIR_CONTROL_FACTOR = 0.8,
    MIN_AIRBORNE_TIME = 0.08,
}

local function averageVectors(vectors)
    if #vectors == 0 then return Vector3.zero end
    local sum = Vector3.zero
    for _, entry in ipairs(vectors) do sum += entry end
    return sum / #vectors
end
local function pushBounded(history, entry, maxEntries)
    table.insert(history, entry)
    if #history > maxEntries then table.remove(history, 1) end
end

local function findBat()
    local character = localPlayer.Character
    if not character then return nil end
    local tool = character:FindFirstChildOfClass("Tool")
    if tool then
        local lowercaseText = tool.Name:lower()
        if lowercaseText:find("bat", 1, true) or lowercaseText:find("slap", 1, true) then return tool end
    end
    local backpack = localPlayer:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") then
                local lowercaseText = child.Name:lower()
                if lowercaseText:find("bat", 1, true) or lowercaseText:find("slap", 1, true) then return child end
            end
        end
    end
    return nil
end

local function resetPredictionState()
    local z = V3.Z
    z.targetPlayer = nil
    z.lastTargetPos = nil
    z.targetVelocity = Vector3.zero
    z.smoothedVelocity = Vector3.zero
    z.velocityHistory = {}
    z.accelerationHistory = {}
    z.aerialVelocityHistory = {}
    z.previousDirection = nil
    z.airborneTime = 0
end

local function findClosestPlayer(rootPart)
    local closestDistance = math.huge
    local closestPlayer = nil
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoidRootPart and humanoid and humanoid.Health > 0 then
                local magnitude = (rootPart.Position - humanoidRootPart.Position).Magnitude
                if magnitude < closestDistance then
                    closestDistance = magnitude
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

local function applyAngularAim(rootPart, direction)
    if direction.Magnitude < 0.01 then return end
    local crossVector = rootPart.CFrame.LookVector:Cross(direction.Unit)
    local angle = math.asin(math.clamp(crossVector.Magnitude, -1, 1))
    rootPart.AssemblyAngularVelocity = crossVector.Magnitude > 0.1 and crossVector.Unit * angle * 80 or Vector3.zero
end

local function updatePing()
    local ok, result = pcall(function()
        return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    local z = V3.Z
    if ok and type(result) == "number" then z.realPingMs = math.floor(result) end
    z.currentPing = math.clamp(z.realPingMs / 1000, V3.ZCFG.MIN_PING_COMPENSATION, V3.ZCFG.MAX_PING_COMPENSATION)
end
task.spawn(function()
    while _mySession == _G.VisibleHubSession do
        pcall(updatePing)
        task.wait(0.5)
    end
end)

local function v3Stop()
    if not V3.on and not V3.conn then return end
    local z = V3.Z
    V3.on = false
    if V3.conn then
        pcall(function() V3.conn:Disconnect() end)
        V3.conn = nil
    end
    local character = localPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if humanoid then humanoid.AutoRotate = true end
    if root then root.AssemblyAngularVelocity = Vector3.zero end
    resetPredictionState()
    z.lastActivationTime = 0
    if V3.suppressed then
        V3.suppressed = false
        pcall(_unsuppressBodyLock, true)
    end
end

local function v3Start()
    if V3.conn then return true end
    local character = localPlayer.Character
    local humanoid1387 = character and character:FindFirstChildOfClass("Humanoid")
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not humanoid1387 or not rootPart then return false end

    -- matikan aimbot / fitur lain yang bentrok (sama seperti Bat Bypas V2)
    pcall(function() if _G.__VisibleLagStop then _G.__VisibleLagStop() end end)
    pcall(function() if _G.__VisibleAV2Stop then _G.__VisibleAV2Stop() end end)
    pcall(function()
        if _G.__VisibleHubIsBatV2 and _G.__VisibleHubIsBatV2() then
            _G.__VisibleHubStopBatV2()
            if mobSetBatV2 then mobSetBatV2(false) end
        end
    end)
    pcall(function()
        if autoLeftEnabled then
            autoLeftEnabled = false
            if stopAutoLeft then stopAutoLeft() end
            if autoLeftSetVisual then autoLeftSetVisual(false) end
            if mobSetAutoLeft then mobSetAutoLeft(false) end
        end
        if autoRightEnabled then
            autoRightEnabled = false
            if stopAutoRight then stopAutoRight() end
            if autoRightSetVisual then autoRightSetVisual(false) end
            if mobSetAutoRight then mobSetAutoRight(false) end
        end
    end)
    if not V3.suppressed then
        V3.suppressed = true
        pcall(_suppressBodyLock)
    end

    V3.on = true
    humanoid1387.AutoRotate = false
    local tool = findBat()
    if tool and tool.Parent ~= character then
        pcall(function() humanoid1387:EquipTool(tool) end)
    end
    V3.conn = RunService.RenderStepped:Connect(function(deltaTime)
        if _mySession ~= _G.VisibleHubSession then v3Stop(); return end
        if not V3.on then v3Stop(); return end
        local z = V3.Z
        local zcfg = V3.ZCFG
        zcfg.FOLLOW_SPEED = ((laggerToggled == true or laggerCarryToggled == true) and V3.laggerSpeed or V3.speed)
        local character2 = localPlayer.Character
        local rootPart1394 = character2 and character2:FindFirstChild("HumanoidRootPart")
        local humanoid = character2 and character2:FindFirstChildOfClass("Humanoid")
        if not rootPart1394 or not humanoid or humanoid.Health <= 0 then return end
        humanoid.AutoRotate = false
        rootPart = rootPart1394
        humanoid1387 = humanoid
        tool = character2:FindFirstChildOfClass("Tool") or findBat()
        if tool and tool.Parent ~= character2 then
            pcall(humanoid.EquipTool, humanoid, tool)
        end
        z.targetPlayer = findClosestPlayer(rootPart)
        local character3 = z.targetPlayer and z.targetPlayer.Character
        local rootPart1442 = character3 and character3:FindFirstChild("HumanoidRootPart")
        character3 = character3 and character3:FindFirstChildOfClass("Humanoid")
        if not rootPart1442 or not character3 or character3.Health <= 0 then
            resetPredictionState()
            return
        end
        local position = rootPart1442.Position
        local sampleDeltaTime = math.max(deltaTime, 0.0041666666666666666)
        if z.lastTargetPos then
            local targetVelocity = (position - z.lastTargetPos) / sampleDeltaTime
            local vector = targetVelocity - z.targetVelocity
            if zcfg.MAX_VELOCITY_CHANGE < vector.Magnitude then
                targetVelocity = z.targetVelocity + vector.Unit * zcfg.MAX_VELOCITY_CHANGE
            end
            local vector3 = Vector3.new(targetVelocity.X, 0, targetVelocity.Z)
            if vector3.Magnitude > zcfg.MAX_HORIZONTAL_VELOCITY then
                local vectorH = vector3.Unit * zcfg.MAX_HORIZONTAL_VELOCITY
                targetVelocity = Vector3.new(vectorH.X, targetVelocity.Y, vectorH.Z)
            end
            pushBounded(z.accelerationHistory, (targetVelocity - z.targetVelocity) / sampleDeltaTime, 4)
            pushBounded(z.velocityHistory, targetVelocity, 8)
            z.targetVelocity = targetVelocity
            z.smoothedVelocity = z.smoothedVelocity:Lerp(targetVelocity, zcfg.VELOCITY_SMOOTHING)
        end
        z.lastTargetPos = position
        local isAirborne = character3.FloorMaterial == Enum.Material.Air
        z.airborneTime = isAirborne and z.airborneTime + sampleDeltaTime or 0
        if isAirborne and z.airborneTime >= zcfg.MIN_AIRBORNE_TIME then
            pushBounded(z.aerialVelocityHistory, z.targetVelocity, 6)
        elseif not isAirborne then
            z.aerialVelocityHistory = {}
        end
        local smoothedVelocity = z.smoothedVelocity
        if isAirborne and #z.aerialVelocityHistory > 0 then
            local vectorA = averageVectors(z.aerialVelocityHistory)
            smoothedVelocity = Vector3.new(vectorA.X, z.targetVelocity.Y, vectorA.Z) * zcfg.AIR_CONTROL_FACTOR
        end
        local changedDirectionQuickly = false
        local flatTargetVel = Vector3.new(z.targetVelocity.X, 0, z.targetVelocity.Z)
        if flatTargetVel.Magnitude > 5 then
            local unit = flatTargetVel.Unit
            if z.previousDirection and z.previousDirection:Dot(unit) < 0.5 then
                local lastDirectionChangeTime = z.lastDirectionChangeTime
                changedDirectionQuickly = tick() - lastDirectionChangeTime < zcfg.DIRECTION_CHANGE_DETECTION_TIME
                z.lastDirectionChangeTime = tick()
            end
            z.previousDirection = unit
        end
        local predictionTime = z.currentPing + zcfg.SERVER_TICKRATE
        if changedDirectionQuickly then
            predictionTime *= zcfg.QUICK_DIRECTION_CHANGE_MULTIPLIER
        end
        local accelerationPredictionWeight = zcfg.ACCELERATION_PREDICTION_WEIGHT
        local predictedPosition = position
            + smoothedVelocity * predictionTime
            + averageVectors(z.accelerationHistory)
                * accelerationPredictionWeight
                * predictionTime
                * predictionTime
                * 0.5
        local leadTime = zcfg.PREDICTION_TIME * 1.1
        local leadPosition
        if isAirborne then
            leadPosition = predictedPosition
                + smoothedVelocity * leadTime
                + Vector3.new(0, -0.5 * zcfg.GRAVITY * leadTime * leadTime, 0)
        else
            leadPosition = predictedPosition + smoothedVelocity * leadTime
        end
        local vector4 = Vector3.new(smoothedVelocity.X, 0, smoothedVelocity.Z)
        if vector4.Magnitude > 1 then
            leadPosition += vector4.Unit * zcfg.PREDICT_AHEAD
        end
        local targetDirection = leadPosition - rootPart.Position
        applyAngularAim(rootPart, targetDirection)
        local withinActivationRange = (position - rootPart.Position).Magnitude <= zcfg.ACTIVATE_DISTANCE
        if withinActivationRange then
            local lastActivationTime = z.lastActivationTime
            withinActivationRange = tick() - lastActivationTime >= 0.3
        end
        if withinActivationRange then
            if tool then
                pcall(tool.Activate, tool)
            end
            z.lastActivationTime = tick()
        end
        if zcfg.MIN_FOLLOW_DISTANCE < targetDirection.Magnitude then
            rootPart.AssemblyLinearVelocity = targetDirection.Unit * zcfg.FOLLOW_SPEED
        else
            rootPart.AssemblyLinearVelocity = Vector3.new(0, rootPart.AssemblyLinearVelocity.Y * 0.5, 0)
        end
    end)
    return true
end

-- ===== sambungkan ke sistem Bat Bypass (selector versi) + semua tempat yang sudah memanggil hook V2 =====
local prevLagStop, prevLagIsOn = _G.__VisibleLagStop, _G.__VisibleLagIsOn
_G.__VisibleLagStop = function()
    if prevLagStop then pcall(prevLagStop) end
    v3Stop()
end
_G.__VisibleLagIsOn = function()
    if V3.on then return true end
    return (prevLagIsOn and prevLagIsOn()) and true or false
end
_G.__VisibleBV3Start = v3Start
_G.__VisibleBV3Stop = v3Stop
_G.__VisibleBV3IsOn = function() return V3.on end
_G.__VisibleBV3SetSpeed = function(normal, lagger)
    if normal then V3.speed = normal end
    if lagger then V3.laggerSpeed = lagger end
end
_G.__VisibleBV3RefreshUI = function()
    if _G.__VisibleBV3SpeedBox then pcall(function() _G.__VisibleBV3SpeedBox.Text = tostring(V3.speed) end) end
    if _G.__VisibleBV3LaggerBox then pcall(function() _G.__VisibleBV3LaggerBox.Text = tostring(V3.laggerSpeed) end) end
end
pcall(_G.__VisibleBV3RefreshUI)
end, function(e) warn("[Visible] Aimbot Bypas V3 gagal dimuat: " .. tostring(e)) end)

-- ============================================================
-- AIMBOT V1 (diganti dengan Bat Aimbot V2 milik SleepyDuels dipindahkan persis: lock target
-- terdekat tiap frame, terbang ke target pakai AssemblyLinearVelocity + prediksi posisi + tinggi,
-- putar badan ke target, auto klik bat saat jarak <= 8 stud)
-- ============================================================
xpcall(function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local A1Z = {on = false, speed = 60, suppressed = false}
_G.VisibleAimbotV1Z = A1Z
do
    local pend = _G.VisibleAimbotV1 and tonumber(_G.VisibleAimbotV1.speed)
    if pend and pend >= 1 and pend <= 120 then A1Z.speed = pend end
end

local _v2Conn = nil
local _v2PrevAutoRotate = nil
local _v2Enabled = false

local function v2FindBat()
    local char = Player.Character
    if not char then return nil end
    local names = { "Bat", "Slap", "SlapHand", "Hand", "ClassicBat", "BatTool" }
    for _, name in ipairs(names) do
        local t = char:FindFirstChild(name)
        if t and t:IsA("Tool") then return t end
    end
    local bp = Player:FindFirstChildOfClass("Backpack")
    if bp then
        for _, name in ipairs(names) do
            local t = bp:FindFirstChild(name)
            if t and t:IsA("Tool") then return t end
        end
        for _, ch in ipairs(bp:GetChildren()) do
            if ch:IsA("Tool") then
                local n = string.lower(ch.Name)
                if string.find(n, "bat", 1, true) or string.find(n, "slap", 1, true) then
                    return ch
                end
            end
        end
    end
    for _, ch in ipairs(char:GetChildren()) do
        if ch:IsA("Tool") then
            local n = string.lower(ch.Name)
            if string.find(n, "bat", 1, true) or string.find(n, "slap", 1, true) then
                return ch
            end
        end
    end
    return nil
end

local function v2IsBatTool(tool)
    if not tool then return false end
    local n = string.lower(tool.Name)
    return string.find(n, "bat", 1, true) ~= nil or string.find(n, "slap", 1, true) ~= nil
end

local function v2GetClosestTarget()
    local char = Player.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local rpos = root.Position
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Player then
            local c = plr.Character
            if c then
                local tRoot = c:FindFirstChild("HumanoidRootPart")
                local hum = c:FindFirstChildOfClass("Humanoid")
                if tRoot and hum and hum.Health > 0 then
                    local d = (tRoot.Position - rpos).Magnitude
                    if d < minDist then
                        minDist = d
                        closest = tRoot
                    end
                end
            end
        end
    end
    return closest
end

local function v2TrySwing()
    pcall(function()
        local char = Player.Character
        if not char then return end
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and not v2IsBatTool(currentTool) then return end
        local bat = v2FindBat()
        if not bat then return end
        if bat.Parent ~= char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() hum:EquipTool(bat) end) end
        end
        pcall(function() bat:Activate() end)
    end)
end

local function v2Stop()
    _v2Enabled = false
    if _v2Conn then
        pcall(function() _v2Conn:Disconnect() end)
        _v2Conn = nil
    end
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = (_v2PrevAutoRotate == nil) and true or _v2PrevAutoRotate
        hum.PlatformStand = false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    if root then
        root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
        root.AssemblyAngularVelocity = Vector3.zero
    end
    _v2PrevAutoRotate = nil
end

local function v2Start()
    if _v2Conn then return end
    _v2Enabled = true
    local hum0 = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then
        if _v2PrevAutoRotate == nil then _v2PrevAutoRotate = hum0.AutoRotate end
        hum0.AutoRotate = false
    end
    _v2Conn = RunService.RenderStepped:Connect(function()
        if _mySession ~= _G.VisibleHubSession then
            if _v2Conn then pcall(function() _v2Conn:Disconnect() end); _v2Conn = nil end
            return
        end
        if not _v2Enabled then return end
        if not A1Z.on then return end
        local char = Player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        if not char:FindFirstChildOfClass("Tool") then
            local bat = v2FindBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target = v2GetClosestTarget()
        if not target then return end
        local speed = 58
        pcall(function()
            if tonumber(A1Z.speed) then
                speed = math.clamp(tonumber(A1Z.speed), 1, 120)
            end
        end)
        local targetVel = target.AssemblyLinearVelocity
        local myPos = root.Position
        local targetPos = target.Position
        local predictPos = targetPos + targetVel * 0.14
        predictPos = predictPos + target.CFrame.LookVector * 0.3
        local direction = predictPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0 then
            flatDir = flatDir.Unit
        else
            flatDir = Vector3.new(0, 0, 0)
        end
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then
            yVel = math.max(yVel, 13)
        end
        yVel = math.clamp(yVel, -70, 110)
        local desiredVel = Vector3.new(flatDir.X * speed, yVel, flatDir.Z * speed)
        root.AssemblyLinearVelocity = _G.__VisibleCleanVel(root):Lerp(desiredVel, 0.8)
        pcall(_G.__VisiblePublishAntiBatVel, root)
        local speed3 = targetVel.Magnitude
        local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
        local predictedPos = targetPos + targetVel * predictTime
        local toPredict = predictedPos - myPos
        if toPredict.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, predictedPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5)
            ry = math.clamp(ry, -2.5, 2.5)
            rz = math.clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42))
        end
        local distToTarget = (root.Position - target.Position).Magnitude
        if distToTarget <= 8 then
            v2TrySwing()
        end
    end)
end

-- ===== start / stop untuk Aimbot V1 (tombol, menu, keybind) =====
local function a1zRefreshVisual()
    local av2 = _G.VisibleAimbotV2
    local onNow = A1Z.on or (av2 and av2.on) or false
    if _G.__VisibleAV2SetVisual then pcall(_G.__VisibleAV2SetVisual, onNow) end
    if _G.__VisibleAV2MobSet then pcall(_G.__VisibleAV2MobSet, onNow) end
end

local function a1zStop()
    if not A1Z.on and not _v2Conn then return end
    A1Z.on = false
    v2Stop()
    if A1Z.suppressed then
        A1Z.suppressed = false
        pcall(_unsuppressBodyLock, true)
    end
    a1zRefreshVisual()
end

local function a1zStart(fromBat)
    if A1Z.on then return true end
    local char = Player.Character
    if not char or not char:FindFirstChildOfClass("Humanoid") or not char:FindFirstChild("HumanoidRootPart") then
        return false
    end
    -- matikan aimbot / fitur lain yang bentrok
    if not fromBat then pcall(function() if autoBatEnabled and disableAutoBat then disableAutoBat() end end) end
    pcall(function()
        if _G.__VisibleHubIsBatV2 and _G.__VisibleHubIsBatV2() then
            _G.__VisibleHubStopBatV2()
            if mobSetBatV2 then mobSetBatV2(false) end
        end
    end)
    pcall(function()
        if autoLeftEnabled then
            autoLeftEnabled = false
            if stopAutoLeft then stopAutoLeft() end
            if autoLeftSetVisual then autoLeftSetVisual(false) end
            if mobSetAutoLeft then mobSetAutoLeft(false) end
        end
        if autoRightEnabled then
            autoRightEnabled = false
            if stopAutoRight then stopAutoRight() end
            if autoRightSetVisual then autoRightSetVisual(false) end
            if mobSetAutoRight then mobSetAutoRight(false) end
        end
    end)
    if not A1Z.suppressed then
        A1Z.suppressed = true
        pcall(_suppressBodyLock)
    end
    A1Z.on = true
    v2Start()
    a1zRefreshVisual()
    return true
end

_G.__VisibleA1ZStart = a1zStart
_G.__VisibleA1ZStop = a1zStop
_G.__VisibleA1ZIsOn = function() return A1Z.on end
end, function(e) warn("[Visible] Aimbot V1 gagal dimuat: " .. tostring(e)) end)

-- ============================================================
-- AIMBOT V3 (aimbot "Bat Aimbot" milik Draku dipindahkan persis: lock target terdekat tiap frame,
-- terbang ke target pakai AssemblyLinearVelocity + prediksi gerak + tinggi, putar badan ke target,
-- auto klik bat saat jarak <= 8 stud). Aimbot V3 lama (Grok) sudah dihapus dan diganti dengan ini.
-- ============================================================
xpcall(function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local V3 = {on = false, speed = 58, suppressed = false}
_G.__VisibleAV3 = V3
do
    local pend = _G.__VisibleAV3Pending
    if type(pend) == "table" and tonumber(pend.speed) and pend.speed > 0 then V3.speed = pend.speed end
end

local BAT_COUNTER_SLAP_LIST = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}

local function findBat()
    local char = LP.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
        end
    end
    return nil
end

local function isBatTool(tool)
    if not tool then return false end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        if tool.Name == name then return true end
    end
    return tool.Name:lower():find("bat") or tool.Name:lower():find("slap")
end

local _aimbotConn = nil
local _prevAutoRotate = nil
local _hittingCooldown = false

local function getClosestTarget()
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

local function trySwing()
    if _hittingCooldown then return end
    _hittingCooldown = true
    pcall(function()
        local char = LP.Character
        if not char then return end
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and not isBatTool(currentTool) then
            _hittingCooldown = false
            return
        end
        local bat = findBat()
        if bat then
            if bat.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            pcall(function() bat:Activate() end)
        end
    end)
    task.delay(0.1, function() _hittingCooldown = false end)
    task.delay(0.2, function()
        if _hittingCooldown then _hittingCooldown = false end
    end)
end

local function v3Stop()
    if not V3.on and not _aimbotConn then return end
    V3.on = false
    if _aimbotConn then
        pcall(function() _aimbotConn:Disconnect() end)
        _aimbotConn = nil
    end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = (_prevAutoRotate == nil) and true or _prevAutoRotate
        hum.PlatformStand = false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    if root then
        root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
        root.AssemblyAngularVelocity = Vector3.zero
    end
    _prevAutoRotate = nil
    _hittingCooldown = false
    if V3.suppressed then
        V3.suppressed = false
        pcall(_unsuppressBodyLock, true)
    end
end

local function v3Start()
    if V3.on or _aimbotConn then return true end
    local char0 = LP.Character
    if not char0 or not char0:FindFirstChildOfClass("Humanoid") or not char0:FindFirstChild("HumanoidRootPart") then
        return false
    end
    -- matikan aimbot / fitur lain yang bentrok (sama seperti Aimbot V1/V2)
    pcall(function() if _G.__VisibleLagStop then _G.__VisibleLagStop() end end)
    pcall(function() if autoBatEnabled and disableAutoBat then disableAutoBat() end end)
    pcall(function()
        if _G.__VisibleHubIsBatV2 and _G.__VisibleHubIsBatV2() then
            _G.__VisibleHubStopBatV2()
            if mobSetBatV2 then mobSetBatV2(false) end
        end
    end)
    pcall(function()
        if autoLeftEnabled then
            autoLeftEnabled = false
            if stopAutoLeft then stopAutoLeft() end
            if autoLeftSetVisual then autoLeftSetVisual(false) end
            if mobSetAutoLeft then mobSetAutoLeft(false) end
        end
        if autoRightEnabled then
            autoRightEnabled = false
            if stopAutoRight then stopAutoRight() end
            if autoRightSetVisual then autoRightSetVisual(false) end
            if mobSetAutoRight then mobSetAutoRight(false) end
        end
    end)

    V3.on = true
    if not V3.suppressed then
        V3.suppressed = true
        pcall(_suppressBodyLock)
    end
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then
        if _prevAutoRotate == nil then _prevAutoRotate = hum0.AutoRotate end
        hum0.AutoRotate = false
    end
    _aimbotConn = RunService.RenderStepped:Connect(function()
        if _mySession ~= _G.VisibleHubSession then v3Stop(); return end
        if not V3.on then return end
        local BAT_AIMBOT_SPEED = V3.speed
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target = getClosestTarget()
        if not target then return end
        local targetVel = target.AssemblyLinearVelocity
        local myPos = root.Position
        local targetPos = target.Position
        local predictPos = targetPos + targetVel * 0.14
        predictPos = predictPos + target.CFrame.LookVector * 0.3
        local direction = predictPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0 then flatDir = flatDir.Unit else flatDir = Vector3.new(0,0,0) end
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then
            yVel = math.max(yVel, 13)
        end
        yVel = math.clamp(yVel, -70, 110)
        local desiredVel = Vector3.new(flatDir.X * BAT_AIMBOT_SPEED, yVel, flatDir.Z * BAT_AIMBOT_SPEED)
        root.AssemblyLinearVelocity = _G.__VisibleCleanVel(root):Lerp(desiredVel, 0.8)
        pcall(_G.__VisiblePublishAntiBatVel, root)
        local speed3 = targetVel.Magnitude
        local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
        local predictedPos = targetPos + targetVel * predictTime
        local toPredict = predictedPos - myPos
        if toPredict.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, predictedPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5)
            ry = math.clamp(ry, -2.5, 2.5)
            rz = math.clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(
                Vector3.new(rx * 42, ry * 42, rz * 42)
            )
        end
        local distToTarget = (root.Position - target.Position).Magnitude
        if distToTarget <= 8 then
            trySwing()
        end
    end)
    return true
end

Players.LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if _mySession ~= _G.VisibleHubSession then return end
    if V3.on then
        local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.AutoRotate = false end
    end
end)

_G.__VisibleAV3Start = v3Start
_G.__VisibleAV3Stop = v3Stop
_G.__VisibleAV3IsOn = function() return V3.on end
_G.__VisibleAV3SetSpeed = function(v) V3.speed = v end
_G.__VisibleAV3RefreshUI = function()
    if _G.__VisibleAV3SpeedBox then pcall(function() _G.__VisibleAV3SpeedBox.Text = tostring(V3.speed) end) end
end
pcall(_G.__VisibleAV3RefreshUI)
end, function(e) warn("[Visible] Aimbot V3 gagal dimuat: " .. tostring(e)) end)


-- ============================================================
-- BLOK LONCAT SAAT AIMBOT DIPAKAI: selama Aimbot V1/V2/V3/V4 atau Aimbot Bypas V1/V2/V3/V4 menyala,
-- tombol loncat (Space, tombol A gamepad, tombol loncat HP) tidak berfungsi dan state Jumping dimatikan.
-- Begitu semua aimbot mati, loncat kembali normal (state Jumping dikembalikan seperti semula).
-- ============================================================
xpcall(function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CAS = game:GetService("ContextActionService")
local LP = Players.LocalPlayer
local ACTION = "VisibleNoJump"
local STEP_NAME = "VisibleNoJumpStep"
local bound = false
local appliedHum, priorEnabled = nil, true

local function anyAimbotOn()
    if _G.__VisibleAimbotIsOn and _G.__VisibleAimbotIsOn() then return true end -- Aimbot V1/V2/V3/V4
    if _G.__VisibleLagIsOn and _G.__VisibleLagIsOn() then return true end       -- Bat Bypas V2 (+ Bypas V4)
    local bb = _G.__VisibleBB
    if bb and bb.on then return true end                                  -- Aimbot Bypas V1
    if _G.__VisibleBV3IsOn and _G.__VisibleBV3IsOn() then return true end       -- Aimbot Bypas V3
    if _G.__VisibleBV4IsOn and _G.__VisibleBV4IsOn() then return true end       -- Aimbot Bypas V4
    return false
end

local function bindSink()
    if bound then return end
    local ok = pcall(function()
        CAS:BindActionAtPriority(ACTION, function()
            return Enum.ContextActionResult.Sink
        end, false, Enum.ContextActionPriority.High.Value + 1000,
            Enum.PlayerActions.CharacterJump, Enum.KeyCode.Space, Enum.KeyCode.ButtonA)
    end)
    bound = ok
end

local function unbindSink()
    if not bound then return end
    pcall(function() CAS:UnbindAction(ACTION) end)
    bound = false
end

local function release()
    unbindSink()
    if appliedHum then
        local hum = appliedHum
        appliedHum = nil
        if hum.Parent then
            pcall(function()
                hum.Jump = false
                hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, priorEnabled)
            end)
        end
    end
end

local function step()
    if _mySession ~= _G.VisibleHubSession then
        release()
        _G.__VisibleNoJumpActive = false
        pcall(function() RunService:UnbindFromRenderStep(STEP_NAME) end)
        return
    end
    local on = anyAimbotOn()
    _G.__VisibleNoJumpActive = on
    if not on then
        release()
        return
    end
    bindSink()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if hum ~= appliedHum then
        appliedHum = hum
        local ok, enabled = pcall(function() return hum:GetStateEnabled(Enum.HumanoidStateType.Jumping) end)
        priorEnabled = (not ok) or enabled ~= false
    end
    pcall(function()
        if hum:GetStateEnabled(Enum.HumanoidStateType.Jumping) then
            hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
        end
        if hum.Jump then hum.Jump = false end
    end)
end

pcall(function() RunService:UnbindFromRenderStep(STEP_NAME) end)
RunService:BindToRenderStep(STEP_NAME, Enum.RenderPriority.Last.Value, step)
end, function(e) warn("[Visible] Blok Loncat gagal dimuat: " .. tostring(e)) end)


-- ============================================================
-- COOLDOWN TIMER (dipindahkan persis dari Clean: hitung mundur 2.5 detik di atas kepala
-- saat karakter ragdoll / jatuh, lalu tampil "READY!")
-- ============================================================
xpcall(function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local _V3new = Vector3.new

do
    local _ragCountdownRunning = false
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
        bb.StudsOffset = _V3new(0, 7.0, 0)
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
        lbl.TextStrokeTransparency = 1
        lbl.Text = ""
        lbl.Parent = bb
        local grad = Instance.new("UIGradient", lbl)
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 210)),
            ColorSequenceKeypoint.new(0.3, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.7, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 210)),
        })
        grad.Rotation = 45
        grad.Offset = Vector2.new(0, 0)
        if visiblePaintTimerLabel then visiblePaintTimerLabel(lbl) end
        return bb, lbl
    end

    local function _ragPunch(lbl, text)
        if not (lbl and lbl.Parent) then return end
        lbl.Text = text
    end

    local function _startRagCountdown()
        if _ragCountdownRunning then return end
        _ragCountdownRunning = true
        task.spawn(function()
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
        end)
    end

    if _G.__VisibleV2TimerConn then pcall(function() _G.__VisibleV2TimerConn:Disconnect() end) end
    local _wasRagdolled = false
    local _ragConn
    _ragConn = RunService.Heartbeat:Connect(function()
        if _mySession ~= _G.VisibleHubSession then
            if _ragConn then _ragConn:Disconnect(); _ragConn = nil end
            local oldBb = LP.PlayerGui and LP.PlayerGui:FindFirstChild("RagCountdownBillboard")
            if oldBb then oldBb:Destroy() end
            return
        end
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
    end)
_G.__VisibleV2TimerConn = _ragConn
end
end, function(e) warn("[Visible] Cooldown Timer gagal dimuat: " .. tostring(e)) end)

-- Restauración final: el panel se crea antes que algunos módulos auxiliares.
-- Si se carga sólo al inicio, esos módulos pueden volver a poner sus defaults
-- y el usuario ve los toggles apagados aunque el archivo sí se haya guardado.
task.defer(function()
    -- Espera a que GUI + paneles móviles + módulos de aimbot/bypass terminen de registrarse.
    task.wait(1.5)
    if not _G.VisibleHubRunning or _isResetting then
        _isBootstrapping = false
        return
    end
    local ok, loaded = pcall(loadAllSettings)
    if ok and loaded then
        pcall(updateUIFromLoaded)
        task.wait(0.2)
        -- Aplicar otra vez: los setters/callbacks ya existen tras createMobilePanel + aimbot modules
        pcall(applyPersistedTogglePreferences)
        pcall(function()
            if setCustomSkinBatLabel then setCustomSkinBatLabel((_G.AmbitiousCustomToolSkins or {}).Bat or "Off") end
            if setCustomSkinMedusaLabel then setCustomSkinMedusaLabel((_G.AmbitiousCustomToolSkins or {}).Medusa or "Off") end
            local sc = _G.VisibleSoundChoice or {}
            if setCustomSoundBatLabel then setCustomSoundBatLabel(sc.Bat or "Off") end
            if setCustomSoundMedusaLabel then setCustomSoundMedusaLabel(sc.Medusa or "Off") end
            if _G.VisibleApplyToolSkinState then _G.VisibleApplyToolSkinState() end
            if _G.VisibleApplySoundState then _G.VisibleApplySoundState() end
        end)
        pcall(function()
            -- Refrescar solo visuales sin re-ejecutar lógica pesada dos veces
            if autoBatSetVisual then autoBatSetVisual(autoBatEnabled == true) end
            if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled == true) end
            if autoRightSetVisual then autoRightSetVisual(autoRightEnabled == true) end
            if setAntiBatVisual then setAntiBatVisual(antiBatEnabled == true) end
            if setAntiFlingVisual then setAntiFlingVisual(antiFlingEnabled == true) end
            if setAntiDieVisual then setAntiDieVisual(antiDieEnabled == true) end
            if setAutoTPDownVisual then setAutoTPDownVisual(autoTPDownEnabled == true) end
            if setUnwalkVisual then setUnwalkVisual(unwalkEnabled == true) end
            if setBatCounterVisual then setBatCounterVisual(batCounterEnabled == true) end
            if setBatCounterV2Visual then setBatCounterV2Visual(batCounterV2Enabled == true) end
            if setMedusaVisual then setMedusaVisual(medusaCounterEnabled == true) end
            if setAntiLagVisual then setAntiLagVisual(antiLagEnabled == true) end
            if setESPVIsual then setESPVIsual(espEnabled == true) end
            if setESPLineVisual then setESPLineVisual(espLineEnabled == true) end
            if setVividVisual then setVividVisual(vividGraphicsEnabled == true) end
            if setHideButtonsVisual then setHideButtonsVisual(hideButtonsEnabled == true) end
            if setLockUIVisual then setLockUIVisual(uiLocked == true) end
            if infJumpSetVisual then infJumpSetVisual(InfiniteJump.enabled == true) end
            if _G.__VisibleAV2SetVisual and PERSISTED_TOGGLES["Aimbot"] then
                _G.__VisibleAV2SetVisual(PERSISTED_TOGGLES["Aimbot"] == true)
            end
            if mobSetAutoBat then mobSetAutoBat(autoBatEnabled == true) end
            if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled == true) end
            if mobSetAutoRight then mobSetAutoRight(autoRightEnabled == true) end
        end)
    else
        -- Si no hubo archivo, igual liberar bootstrap
        warn("[Visible] No se pudo cargar VisibleHub.json (¿primera vez o writefile no disponible?)")
    end
    _isBootstrapping = false
    -- No forzar save aquí: evita sobrescribir el JSON del usuario con estado a medias
end)