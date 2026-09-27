-- ============================================================
-- ACCESSORY PACK ONLY (version stable)
-- Off / 1 / 2 / 3 / 4
-- ============================================================

print("[Accessory Pack] Script demarre...")

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local InsertService = game:GetService("InsertService")
local LP = Players.LocalPlayer

if not LP then
    print("[Accessory Pack] ERREUR: LocalPlayer introuvable")
    return
end

_G.Lust = _G.Lust or {}
_G.Lust.OriginalOutfit = _G.Lust.OriginalOutfit or {shirt = nil, pants = nil}
_G.Lust.OriginalAccessories = _G.Lust.OriginalAccessories or {}

local ACCESSORY_PACK_ORDER = {
    {"Off", "Off"},
    {"1", "1"},
    {"2", "2"},
    {"3", "3"},
    {"4", "4"},
}
local currentAccessoryPack = "Off"

local BLEED_PACKS = {
    ["1"] = {
        accessory = 306969564,
        offset = Vector3.new(0, 0.3, 0),
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        shirt = "http://www.roblox.com/asset/?id=10632503795",
        pants = "http://www.roblox.com/asset/?id=123161592384863",
        korblox = "right",
    },
    ["2"] = {
        accessory = 1744060292,
        offset = Vector3.new(0, 1.4, -0.2),
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        shirt = "http://www.roblox.com/asset/?id=11526718530",
        pants = "http://www.roblox.com/asset/?id=93710523210027",
        korblox = "right",
    },
    ["3"] = {
        accessory = 112564966849233,
        offset = Vector3.new(0, 0.6, 0),
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        shirt = "http://www.roblox.com/asset/?id=11849088376",
        pants = "http://www.roblox.com/asset/?id=16534673928",
        korblox = "right",
    },
    ["4"] = {
        accessory = 103394571970500, -- hat / face
        offset = Vector3.new(0, 0, 0),
        shirtAccessory = 134287796699657, -- UGC T-Shirt
        pantsId = 16797640288, -- classic pants (numeric)
        pants = "rbxassetid://16797640288",
        korblox = "none",
    },
}

local function saveOriginalOutfit(char)
    if not char then return end
    if _G.Lust.OriginalOutfit.shirt or _G.Lust.OriginalOutfit.pants then return end
    local shirt = char:FindFirstChildWhichIsA("Shirt")
    local pants = char:FindFirstChildWhichIsA("Pants")
    _G.Lust.OriginalOutfit.shirt = shirt and shirt.ShirtTemplate or nil
    _G.Lust.OriginalOutfit.pants = pants and pants.PantsTemplate or nil
end

local function restoreOriginalOutfit(char)
    if not char then return end
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Shirt") or obj:IsA("Pants") then
            obj:Destroy()
        end
    end
    if _G.Lust.OriginalOutfit.shirt then
        local s = Instance.new("Shirt")
        s.ShirtTemplate = _G.Lust.OriginalOutfit.shirt
        s.Parent = char
    end
    if _G.Lust.OriginalOutfit.pants then
        local p = Instance.new("Pants")
        p.PantsTemplate = _G.Lust.OriginalOutfit.pants
        p.Parent = char
    end
end

local function clearAllOutfit(char)
    if not char then return end
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Shirt") or obj:IsA("Pants") then
            obj:Destroy()
        end
    end
end

local function saveOriginalAccessories(char)
    if not char then return end
    if #_G.Lust.OriginalAccessories > 0 then return end
    _G.Lust.OriginalAccessories = {}
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") then
            table.insert(_G.Lust.OriginalAccessories, child:Clone())
        end
    end
end

local function clearAllAccessories(char)
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat")
            or child.Name == "AuFfitAccessory"
            or child.Name == "AuFfitShirtAccessory" then
            child:Destroy()
        end
    end
    for _, partName in ipairs({"Head", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            part.Transparency = 0
        end
    end
end

local function restoreOriginalAccessories(char)
    if not char then return end
    clearAllAccessories(char)
    for _, clone in ipairs(_G.Lust.OriginalAccessories) do
        pcall(function()
            local newAcc = clone:Clone()
            newAcc.Parent = char
        end)
    end
end

local function loadAsset(id)
    local ok, res = pcall(function()
        return game:GetObjects("rbxassetid://" .. tostring(id))
    end)
    if ok and type(res) == "table" and #res > 0 then
        return res
    end
    ok, res = pcall(function()
        return InsertService:LoadAsset(id)
    end)
    if ok and res then
        return {res}
    end
    return nil
end

local function applyBleedOutfit(packName)
    local config = BLEED_PACKS[packName]
    if not config then return false end

    local char = LP.Character
    if not char then return false end

    local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 5)
    if not head then return false end

    -- Head mesh
    if config.headMesh then
        pcall(function()
            if head:IsA("MeshPart") then
                head.MeshId = config.headMesh
                if config.headTexture then head.TextureID = config.headTexture end
            else
                local sm = head:FindFirstChildWhichIsA("SpecialMesh") or Instance.new("SpecialMesh")
                sm.Parent = head
                sm.MeshType = Enum.MeshType.FileMesh
                sm.MeshId = config.headMesh
                sm.TextureId = config.headTexture or ""
            end
        end)
    end

    local hum = char:FindFirstChildOfClass("Humanoid")

    -- Classic shirt
    if config.shirt then
        pcall(function()
            local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
            s.Name = "Shirt"
            s.ShirtTemplate = config.shirt
            s.Parent = char
        end)
    end

    -- Classic pants (plusieurs formats pour maximiser les chances)
    if config.pants or config.pantsId then
        pcall(function()
            local pantsId = config.pantsId
            local template = config.pants
            if not template and pantsId then
                template = "rbxassetid://" .. tostring(pantsId)
            end
            local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
            p.Name = "Pants"
            p.PantsTemplate = template
            p.Parent = char
        end)
        -- Fallback HumanoidDescription
        if hum and config.pantsId then
            pcall(function()
                local desc = hum:GetAppliedDescription()
                desc.Pants = config.pantsId
                hum:ApplyDescriptionClientServer(desc)
            end)
            pcall(function()
                local desc = hum:GetAppliedDescription()
                desc.Pants = config.pantsId
                hum:ApplyDescription(desc)
            end)
        end
    end

    -- UGC shirt / layered clothing
    if config.shirtAccessory then
        local function equipLoaded(obj)
            if not obj then return end
            if obj:IsA("Accessory") or obj:IsA("Hat") then
                obj.Name = "AuFfitShirtAccessory"
                if hum then
                    pcall(function() hum:AddAccessory(obj) end)
                else
                    obj.Parent = char
                end
            elseif obj:IsA("Shirt") then
                obj.Name = "Shirt"
                obj.Parent = char
            elseif obj:IsA("Model") or obj:IsA("Folder") then
                for _, child in ipairs(obj:GetChildren()) do
                    equipLoaded(child)
                end
            end
        end
        pcall(function()
            local objs = loadAsset(config.shirtAccessory)
            if objs then
                for _, obj in ipairs(objs) do
                    equipLoaded(obj)
                end
            end
        end)
        -- Fallback description accessory list
        if hum then
            pcall(function()
                local desc = hum:GetAppliedDescription()
                local accs = desc:GetAccessories(true)
                table.insert(accs, {
                    AccessoryType = Enum.AccessoryType.Jacket,
                    AssetId = config.shirtAccessory,
                    IsLayered = true,
                })
                desc:SetAccessories(accs, true)
                pcall(function() hum:ApplyDescription(desc) end)
                pcall(function() hum:ApplyDescriptionClientServer(desc) end)
            end)
        end
    end

    -- Head accessory
    if config.accessory and head then
        pcall(function()
            local old = char:FindFirstChild("AuFfitAccessory")
            if old then old:Destroy() end
            local objs = loadAsset(config.accessory)
            if not objs then return end
            local handle
            for _, o in ipairs(objs) do
                if o:IsA("BasePart") then
                    handle = o
                    break
                end
                if o:IsA("Accessory") or o:IsA("Hat") then
                    o.Name = "AuFfitAccessory"
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum:AddAccessory(o)
                    else
                        o.Parent = char
                    end
                    return
                end
                local h = o:FindFirstChild("Handle") or o:FindFirstChildWhichIsA("BasePart", true)
                if h then handle = h end
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
                weld.C0 = CFrame.new(config.offset or Vector3.zero)
                weld.Parent = h
            end
            for _, o in ipairs(objs) do
                pcall(function() o:Destroy() end)
            end
        end)
    end

    -- Korblox
    if config.korblox and config.korblox ~= "none" then
        pcall(function()
            local ids = { left = 139607673, right = 139607718 }
            local targets = { left = "LeftUpperLeg", right = "RightUpperLeg" }
            local hides = {
                left = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot"},
                right = {"RightUpperLeg", "RightLowerLeg", "RightFoot"},
            }
            local side = config.korblox
            local targetPart = char:FindFirstChild(targets[side])
            if not targetPart then return end
            for _, partName in ipairs(hides[side]) do
                local limb = char:FindFirstChild(partName)
                if limb and limb:IsA("BasePart") then
                    limb.Transparency = 1
                end
            end
            local objs = loadAsset(ids[side])
            if not objs or #objs == 0 then return end
            local assetModel = objs[1]
            local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
            if not mainMesh then return end
            mainMesh.CanCollide = false
            mainMesh.Massless = true
            mainMesh.CFrame = targetPart.CFrame
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = targetPart
            weld.Part1 = mainMesh
            weld.Parent = mainMesh
            assetModel.Parent = char
        end)
    end

    return true
end

local function applyAccessoryPack(packName)
    local char = LP.Character
    if not char then
        print("[Accessory Pack] Pas de personnage")
        return
    end

    currentAccessoryPack = packName

    if packName == "Off" then
        clearAllAccessories(char)
        restoreOriginalOutfit(char)
        restoreOriginalAccessories(char)
        print("[Accessory Pack] Off applique")
        return
    end

    saveOriginalOutfit(char)
    saveOriginalAccessories(char)
    clearAllOutfit(char)
    clearAllAccessories(char)
    applyBleedOutfit(packName)
    print("[Accessory Pack] Pack " .. tostring(packName) .. " applique")
end

-- ===================== GUI =====================
print("[Accessory Pack] Creation GUI...")

pcall(function()
    local old = LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild("AccessoryPackGUI")
    if old then old:Destroy() end
end)

local parentGui = nil
local okCore = pcall(function()
    parentGui = game:GetService("CoreGui")
end)
if not okCore or not parentGui then
    parentGui = LP:WaitForChild("PlayerGui", 10)
end

if not parentGui then
    print("[Accessory Pack] ERREUR: impossible de trouver un parent GUI")
    return
end

local gui = Instance.new("ScreenGui")
gui.Name = "AccessoryPackGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
gui.Enabled = true

pcall(function()
    if syn and syn.protect_gui then syn.protect_gui(gui) end
end)

local okParent = pcall(function()
    gui.Parent = parentGui
end)
if not okParent then
    gui.Parent = LP:WaitForChild("PlayerGui")
end

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 220, 0, 170)
main.Position = UDim2.new(0.5, -110, 0.5, -85)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.BorderSizePixel = 0
main.Active = true
main.Visible = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(138, 43, 226)
stroke.Thickness = 1.5
stroke.Transparency = 0.3

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 32)
title.BackgroundTransparency = 1
title.Text = "HAVEN HUB"
title.TextColor3 = Color3.fromRGB(138, 43, 226)
title.Font = Enum.Font.GothamBlack
title.TextSize = 14

local currentLabel = Instance.new("TextLabel", main)
currentLabel.Size = UDim2.new(1, -20, 0, 24)
currentLabel.Position = UDim2.new(0, 10, 0, 36)
currentLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
currentLabel.Text = "Off"
currentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
currentLabel.Font = Enum.Font.GothamBold
currentLabel.TextSize = 13
Instance.new("UICorner", currentLabel).CornerRadius = UDim.new(0, 6)

local btnPrev = Instance.new("TextButton", main)
btnPrev.Size = UDim2.new(0, 90, 0, 34)
btnPrev.Position = UDim2.new(0, 10, 0, 70)
btnPrev.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
btnPrev.Text = "<  PREV"
btnPrev.TextColor3 = Color3.fromRGB(138, 43, 226)
btnPrev.Font = Enum.Font.GothamBold
btnPrev.TextSize = 12
btnPrev.BorderSizePixel = 0
btnPrev.AutoButtonColor = false
Instance.new("UICorner", btnPrev).CornerRadius = UDim.new(0, 6)

local btnNext = Instance.new("TextButton", main)
btnNext.Size = UDim2.new(0, 90, 0, 34)
btnNext.Position = UDim2.new(1, -100, 0, 70)
btnNext.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
btnNext.Text = "NEXT  >"
btnNext.TextColor3 = Color3.fromRGB(138, 43, 226)
btnNext.Font = Enum.Font.GothamBold
btnNext.TextSize = 12
btnNext.BorderSizePixel = 0
btnNext.AutoButtonColor = false
Instance.new("UICorner", btnNext).CornerRadius = UDim.new(0, 6)

local btnApply = Instance.new("TextButton", main)
btnApply.Size = UDim2.new(1, -20, 0, 36)
btnApply.Position = UDim2.new(0, 10, 0, 118)
btnApply.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
btnApply.Text = "APPLIQUER"
btnApply.TextColor3 = Color3.fromRGB(255, 255, 255)
btnApply.Font = Enum.Font.GothamBlack
btnApply.TextSize = 13
btnApply.BorderSizePixel = 0
btnApply.AutoButtonColor = false
Instance.new("UICorner", btnApply).CornerRadius = UDim.new(0, 6)

local currentIndex = 1
currentLabel.Text = ACCESSORY_PACK_ORDER[currentIndex][2]

btnPrev.MouseButton1Click:Connect(function()
    currentIndex = currentIndex - 1
    if currentIndex < 1 then currentIndex = #ACCESSORY_PACK_ORDER end
    currentLabel.Text = ACCESSORY_PACK_ORDER[currentIndex][2]
end)

btnNext.MouseButton1Click:Connect(function()
    currentIndex = currentIndex + 1
    if currentIndex > #ACCESSORY_PACK_ORDER then currentIndex = 1 end
    currentLabel.Text = ACCESSORY_PACK_ORDER[currentIndex][2]
end)

btnApply.MouseButton1Click:Connect(function()
    local packName = ACCESSORY_PACK_ORDER[currentIndex][2]
    applyAccessoryPack(packName)
    currentLabel.Text = packName
end)

-- Drag
local dragging, dragStart, startPos = false, nil, nil
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

LP.CharacterAdded:Connect(function()
    task.wait(1)
    if currentAccessoryPack and currentAccessoryPack ~= "Off" then
        applyAccessoryPack(currentAccessoryPack)
    end
end)

print("[Accessory Pack] GUI chargee â€” Off / 1 / 2 / 3 / 4")