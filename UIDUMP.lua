print("[1] start")

local BASE_PATH = "NovaCapture/Logged GUI"

if not isfolder("NovaCapture") then
    makefolder("NovaCapture")
end
if not isfolder(BASE_PATH) then
    makefolder(BASE_PATH)
end

local function makeStealer()
    local Player = game:GetService("Players").LocalPlayer
    local function fmt(v)
        local t = typeof(v)
        if t == "string" then return string.format("%q", v) end
        if t == "UDim2" then return string.format("UDim2.new(%s,%s,%s,%s)", v.X.Scale, v.X.Offset, v.Y.Scale, v.Y.Offset) end
        if t == "UDim" then return string.format("UDim.new(%s,%s)", v.Scale, v.Offset) end
        if t == "Color3" then return string.format("Color3.fromRGB(%d,%d,%d)", v.R*255, v.G*255, v.B*255) end
        if t == "Vector2" then return string.format("Vector2.new(%s,%s)", v.X, v.Y) end
        if t == "EnumItem" then return tostring(v) end
        if t == "Instance" then
            if v == workspace then return "workspace" end
            if v == game then return "game" end
            local path = {}
            local p = v
            while p and p ~= game do
                table.insert(path, 1, p.Name)
                p = p.Parent
            end
            return 'game:GetService("'..v.ClassName..'")'..(v.Name ~= v.ClassName and ':FindFirstChild("'..v.Name..'")' or '')
        end
        return tostring(v)
    end

    return function(gui)
        local ids, names = {}, {}
        local code = ""
        local bin = "local a = {\n"
        local all = {gui}
        for _, d in ipairs(gui:GetDescendants()) do table.insert(all, d) end

        for i, inst in ipairs(all) do
            local n = inst.Name:gsub("[^%w]", "_")
            local base = n
            local c = 1
            while names[base] do c += 1; base = n .. "_" .. c end
            names[base] = true
            ids[inst] = base
            bin = bin .. string.format('\t["%s"] = Instance.new("%s"),\n', base, inst.ClassName)
        end
        bin = bin:sub(1, -3) .. "\n}\n\n"

        for i, inst in ipairs(all) do
            local id = ids[inst]
            if inst:IsA("GuiObject") then
                code = code .. string.format('a["%s"].Size = %s\n', id, fmt(inst.Size))
                code = code .. string.format('a["%s"].Position = %s\n', id, fmt(inst.Position))
                code = code .. string.format('a["%s"].AnchorPoint = %s\n', id, fmt(inst.AnchorPoint))
                if inst.BackgroundTransparency ~= 1 then
                    code = code .. string.format('a["%s"].BackgroundColor3 = %s\n', id, fmt(inst.BackgroundColor3))
                    code = code .. string.format('a["%s"].BackgroundTransparency = %s\n', id, tostring(inst.BackgroundTransparency))
                end
                pcall(function()
                    if inst.BorderSizePixel ~= 1 then
                        code = code .. string.format('a["%s"].BorderSizePixel = %d\n', id, inst.BorderSizePixel)
                    end
                end)
                pcall(function()
                    if inst.ZIndex ~= 1 then
                        code = code .. string.format('a["%s"].ZIndex = %d\n', id, inst.ZIndex)
                    end
                end)
                pcall(function() if inst.Visible == false then code = code .. string.format('a["%s"].Visible = false\n', id) end end)
            end

            if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
                code = code .. string.format('a["%s"].Text = %q\n', id, inst.Text)
                code = code .. string.format('a["%s"].TextSize = %d\n', id, inst.TextSize)
                code = code .. string.format('a["%s"].TextColor3 = %s\n', id, fmt(inst.TextColor3))
                code = code .. string.format('a["%s"].Font = Enum.Font.%s\n', id, inst.Font.Name)
                code = code .. string.format('a["%s"].TextXAlignment = Enum.TextXAlignment.%s\n', id, inst.TextXAlignment.Name)
                code = code .. string.format('a["%s"].TextYAlignment = Enum.TextYAlignment.%s\n', id, inst.TextYAlignment.Name)
                if inst.TextWrapped then code = code .. string.format('a["%s"].TextWrapped = true\n', id) end
            end

            if inst:IsA("ImageLabel") or inst:IsA("ImageButton") then
                code = code .. string.format('a["%s"].Image = %q\n', id, inst.Image)
                code = code .. string.format('a["%s"].ImageTransparency = %s\n', id, tostring(inst.ImageTransparency))
                code = code .. string.format('a["%s"].ScaleType = Enum.ScaleType.%s\n', id, inst.ScaleType.Name)
            end

            if inst:IsA("UICorner") then
                code = code .. string.format('a["%s"].CornerRadius = %s\n', id, fmt(inst.CornerRadius))
            end

            if inst:IsA("UIStroke") then
                code = code .. string.format('a["%s"].Color = %s\n', id, fmt(inst.Color))
                code = code .. string.format('a["%s"].Thickness = %s\n', id, tostring(inst.Thickness))
                code = code .. string.format('a["%s"].Transparency = %s\n', id, tostring(inst.Transparency))
            end

            if inst:IsA("UIListLayout") then
                code = code .. string.format('a["%s"].Padding = %s\n', id, fmt(inst.Padding))
                code = code .. string.format('a["%s"].FillDirection = Enum.FillDirection.%s\n', id, inst.FillDirection.Name)
            end

            if inst:IsA("UIGridLayout") then
                code = code .. string.format('a["%s"].CellSize = %s\n', id, fmt(inst.CellSize))
                code = code .. string.format('a["%s"].CellPadding = %s\n', id, fmt(inst.CellPadding))
            end

            code = code .. string.format('a["%s"].Name = %q\n', id, inst.Name)
            if i == 1 then
                code = code .. string.format('a["%s"].Parent = game:GetService("Players").LocalPlayer.PlayerGui\n', id)
            else
                local parentId = ids[inst.Parent]
                if parentId then
                    code = code .. string.format('a["%s"].Parent = a["%s"]\n', id, parentId)
                end
            end
            code = code .. "\n"
        end
        return bin .. code
    end
end

local StealGUI
local ok, err = pcall(function() StealGUI = makeStealer() end)
if not ok then warn("stealer error: " .. tostring(err)) return end
print("[2] stealer ready")

local function log(t) pcall(appendfile, BASE_PATH .. "/logged.txt", t .. "\n") end
pcall(writefile, BASE_PATH .. "/logged.txt", "")

local known = {}
local idx = 0
local fileByGui = {}

local function capture(gui, reason)
    if known[gui] then return end
    known[gui] = true
    idx += 1
    task.wait(1)
    local ok2, code = pcall(StealGUI, gui)
    if ok2 and code and #code > 50 then
        local name = gui.Name:gsub("[^%w]", "_")
        local fname = BASE_PATH .. "/gui_" .. idx .. "_" .. name .. ".lua"
        pcall(writefile, fname, code)
        fileByGui[gui] = fname
        log("[GUI] " .. gui.Name .. " (" .. tostring(reason) .. ") -> " .. fname .. " | " .. #code .. "b")
        print("captured: " .. gui.Name .. " -> " .. fname)
    else
        log("[FAIL] " .. gui.Name)
    end
end

local function reCapture(gui, reason)
    if not known[gui] then return end
    task.wait(0.3)
    local ok2, code = pcall(StealGUI, gui)
    if ok2 and code and #code > 50 then
        local fname = fileByGui[gui] or (BASE_PATH .. "/gui_" .. idx .. "_" .. gui.Name:gsub("[^%w]", "_") .. ".lua")
        pcall(writefile, fname, code)
        log("[UPDATE] " .. gui.Name .. " (" .. tostring(reason) .. ") -> " .. fname .. " | " .. #code .. "b")
        print("updated: " .. gui.Name)
    end
end

local function watchGui(gui)
    local function watchDescendant(obj)
        if not obj then return end
        task.spawn(function() reCapture(gui, "descendant:" .. obj.ClassName) end)
        for _, child in ipairs(obj:GetDescendants()) do
            task.spawn(function() reCapture(gui, "descendant_deep:" .. child.ClassName) end)
        end
    end

    gui.DescendantAdded:Connect(watchDescendant)
    gui.DescendantRemoving:Connect(function(obj)
        task.spawn(function() reCapture(gui, "removed:" .. obj.ClassName) end)
    end)

    for _, obj in ipairs(gui:GetDescendants()) do
        pcall(function()
            if obj:IsA("GuiObject") or obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                obj:GetPropertyChangedSignal("Size"):Connect(function() task.spawn(function() reCapture(gui, "Size") end) end)
                obj:GetPropertyChangedSignal("Position"):Connect(function() task.spawn(function() reCapture(gui, "Position") end) end)
                obj:GetPropertyChangedSignal("Visible"):Connect(function() task.spawn(function() reCapture(gui, "Visible") end) end)
            end
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                obj:GetPropertyChangedSignal("Text"):Connect(function() task.spawn(function() reCapture(gui, "Text") end) end)
                obj:GetPropertyChangedSignal("TextColor3"):Connect(function() task.spawn(function() reCapture(gui, "TextColor3") end) end)
            end
            if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                obj:GetPropertyChangedSignal("Image"):Connect(function() task.spawn(function() reCapture(gui, "Image") end) end)
            end
        end)
    end
end

local function attach(gui, reason)
    task.spawn(function()
        capture(gui, reason)
        watchGui(gui)
    end)
end

pcall(function()
    for _, g in ipairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
        if g:IsA("ScreenGui") then known[g] = true end
    end
end)

pcall(function()
    game.Players.LocalPlayer.PlayerGui.ChildAdded:Connect(function(obj)
        if obj:IsA("ScreenGui") then attach(obj, "PlayerGui") end
    end)
end)

pcall(function()
    game:GetService("CoreGui").ChildAdded:Connect(function(obj)
        if obj:IsA("ScreenGui") then attach(obj, "CoreGui") end
    end)
end)

pcall(function()
    if gethui then
        local h = gethui()
        if h then
            h.ChildAdded:Connect(function(obj)
                if obj:IsA("ScreenGui") then attach(obj, "gethui") end
            end)
        end
    end
end)

pcall(function()
    game.DescendantAdded:Connect(function(obj)
        if obj:IsA("ScreenGui") then
            task.wait(0.5)
            local parent = obj.Parent
            if parent then attach(obj, "dynamic:" .. parent.ClassName) end
        end
    end)
end)

print("[3] watch mode ready")
print("===========================================")