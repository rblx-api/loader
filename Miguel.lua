local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local HOLD_TIME = 2.5
local MUSIC_URL = "https://files.catbox.moe/zv6rju.mp3"
local MUSIC_VOLUME = 0.6
local CENTER_URL = "https://files.catbox.moe/pbixsi.png"

local SIDE_URLS = {
    "https://files.catbox.moe/kvfski.png",
    "https://files.catbox.moe/l45ooi.png",
    "https://files.catbox.moe/uymycl.jpg",
    "https://files.catbox.moe/0p8fh1.png",
    "https://files.catbox.moe/q76h41.png",
    "https://files.catbox.moe/0y3317.png",
    "https://files.catbox.moe/nd41x0.png",
    "https://files.catbox.moe/8gueb8.png",
}

local CENTER_SIZE, SIDE_SIZE, SLIDE_X = 340, 280, 330

local GUI_NAME = "ThreeImagesGUI"
pcall(function()
    local old = ((gethui and gethui()) or CoreGui):FindFirstChild(GUI_NAME)
    if old then old:Destroy() end
end)
pcall(function()
    local old = CoreGui:FindFirstChild(GUI_NAME)
    if old then old:Destroy() end
end)

local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = (gethui and gethui()) or CoreGui

local FOLDER = "ThreeImagesGUI"

local function download(url)
    local why = "sin respuesta"
    local req = (syn and syn.request) or (http and http.request) or http_request or request
    if req then
        local ok, res = pcall(function() return req({ Url = url, Method = "GET" }) end)
        if ok and res then
            if (res.StatusCode == 200 or res.Success) and res.Body and #res.Body > 100 then
                return res.Body
            end
            why = "HTTP " .. tostring(res.StatusCode)
        else
            why = "request fallo: " .. tostring(res)
        end
    end
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if ok and body and #body > 100 then return body end
    if not ok then why = why .. " / HttpGet: " .. tostring(body) end
    return nil, why
end

local function loadFile(url, name, ext, tries)
    local toAsset = getcustomasset or getsynasset
    if not (writefile and toAsset) then
        return nil, "El executor no soporta writefile/getcustomasset"
    end
    pcall(function()
        if makefolder and isfolder and not isfolder(FOLDER) then makefolder(FOLDER) end
    end)
    local path = FOLDER .. "/" .. name .. "." .. (ext or "png")
    local cached = false
    if isfile then
        local okf, exists = pcall(isfile, path)
        cached = okf and exists
    end
    if not cached then
        local body, why
        for i = 1, (tries or 3) do
            body, why = download(url)
            if body then break end
            if i < (tries or 3) then task.wait(0.5) end
        end
        if not body then return nil, "No se pudo descargar: " .. tostring(why) end
        if not pcall(writefile, path, body) then return nil, "No se pudo guardar el archivo" end
    end
    local oka, asset = pcall(toAsset, path)
    if not oka or not asset or asset == "" then return nil, "getcustomasset fallo" end
    return asset
end

local function tween(obj, t, props, style, dir)
    local tw = TweenService:Create(obj, TweenInfo.new(t, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
    tw:Play()
    return tw
end

local assetOf, errOf, state = {}, {}, {}

local function nameAndExt(url)
    local name = string.match(url, "([^/]+)%.%w+$") or "img"
    local ext = string.lower(string.match(url, "%.(%w+)$") or "png")
    return name, ext
end

-- Marca la imagen como lista apenas se descarga (sin esperar nada mas)
local function fetch(url, tries)
    if state[url] then return end
    state[url] = "loading"
    local name, ext = nameAndExt(url)
    local asset, err = loadFile(url, name, ext, tries)
    assetOf[url] = asset or false
    errOf[url] = err
    state[url] = "done"
    -- precarga en segundo plano (no retrasa nada)
    if asset then
        task.spawn(function()
            local tmp = Instance.new("ImageLabel")
            tmp.Size = UDim2.fromOffset(1, 1)
            tmp.BackgroundTransparency = 1
            tmp.ImageTransparency = 1
            tmp.Image = asset
            tmp.Parent = gui
            local t0 = os.clock()
            while not tmp.IsLoaded and os.clock() - t0 < 3 do task.wait(0.1) end
            tmp:Destroy()
        end)
    end
end

local function waitAsset(url, timeout)
    if not state[url] then task.spawn(fetch, url) end
    local t0 = os.clock()
    while state[url] ~= "done" and os.clock() - t0 < (timeout or 30) and gui.Parent do task.wait(0.05) end
    return assetOf[url], errOf[url]
end

local sides, seen = {}, {}
for _, u in ipairs(SIDE_URLS) do
    if not seen[u] then seen[u] = true; sides[#sides + 1] = u end
end

local music = Instance.new("Sound")
music.Name = "ThreeImagesMusic"
music.Looped = true
music.Volume = MUSIC_VOLUME
music.Parent = gui

gui.Destroying:Connect(function()
    pcall(function() music:Stop() end)
end)

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bg.BackgroundTransparency = 0.4
bg.BorderSizePixel = 0
bg.Parent = gui

local container = Instance.new("Frame")
container.AnchorPoint = Vector2.new(0.5, 0.5)
container.Position = UDim2.new(0.5, 0, 0.5, -20)
container.Size = UDim2.new(0, 980, 0, 360)
container.BackgroundTransparency = 1
container.Parent = gui

do
    local scale = Instance.new("UIScale")
    scale.Parent = container
    local function fit()
        local cam = workspace.CurrentCamera
        if not cam then return end
        local v = cam.ViewportSize
        scale.Scale = math.clamp(math.min(v.X / 1020, (v.Y - 90) / 380), 0.3, 1)
    end
    fit()
    if workspace.CurrentCamera then
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit)
    end
end

local function makeFrame(isCenter)
    local size = isCenter and CENTER_SIZE or SIDE_SIZE

    local frame = Instance.new("CanvasGroup")
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.Size = UDim2.fromOffset(size, size)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    frame.BorderSizePixel = 0
    frame.GroupTransparency = 1
    frame.Visible = isCenter
    frame.ZIndex = isCenter and 3 or 1
    frame.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = isCenter and Color3.fromRGB(170, 90, 255) or Color3.fromRGB(70, 70, 90)
    stroke.Thickness = isCenter and 3 or 1.5
    stroke.Transparency = 1
    stroke.Parent = frame

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(1, -14, 1, -14)
    img.Position = UDim2.new(0, 7, 0, 7)
    img.BackgroundTransparency = 1
    img.Image = ""
    img.ScaleType = Enum.ScaleType.Crop
    img.Parent = frame

    local imgCorner = Instance.new("UICorner")
    imgCorner.CornerRadius = UDim.new(0, 12)
    imgCorner.Parent = img

    local status = Instance.new("TextLabel")
    status.BackgroundTransparency = 1
    status.Size = UDim2.new(1, -20, 1, 0)
    status.Position = UDim2.new(0, 10, 0, 0)
    status.Text = ""
    status.TextColor3 = Color3.fromRGB(235, 100, 90)
    status.Font = Enum.Font.GothamBold
    status.TextSize = 14
    status.TextWrapped = true
    status.ZIndex = 5
    status.Parent = frame

    local pop = Instance.new("UIScale")
    pop.Scale = isCenter and 0.8 or 1
    pop.Parent = frame

    return { frame = frame, img = img, status = status, pop = pop, stroke = stroke }
end

local center = makeFrame(true)
local left = makeFrame(false)
local right = makeFrame(false)


local function moveFrame(f, t, pos, alpha, style, dir)
    local props = { GroupTransparency = alpha }
    if pos then props.Position = pos end
    tween(f.frame, t, props, style, dir)
    tween(f.stroke, t, { Transparency = alpha }, style, dir)
end

local function setImage(f, url)
    f.img.Image = assetOf[url] or ""
    f.status.Text = ""
end

task.spawn(function()
    -- descarga todo en paralelo (el centro primero)
    task.spawn(fetch, CENTER_URL, 3)
    for _, u in ipairs(sides) do task.spawn(fetch, u, 2) end

    -- musica (no bloquea nada)
    task.spawn(function()
        local asset, err = loadFile(MUSIC_URL, "music", "mp3", 3)
        if not asset then
            warn("[ThreeImagesGUI] Musica: " .. tostring(err))
            return
        end
        if not music.Parent then return end
        music.SoundId = asset
        local t0 = os.clock()
        while not music.IsLoaded and os.clock() - t0 < 10 do task.wait(0.1) end
        if music.Parent then music:Play() end
    end)

    -- avisa en consola cuales laterales fallaron (en segundo plano)
    task.spawn(function()
        for _, u in ipairs(sides) do
            waitAsset(u, 40)
            if not assetOf[u] then
                warn("[ThreeImagesGUI] Descartada: " .. u .. " -> " .. tostring(errOf[u]))
            end
        end
    end)

    -- 1) centro: aparece en cuanto baja
    center.frame.Visible = true
    moveFrame(center, 0.5, nil, 0)
    tween(center.pop, 0.6, { Scale = 1 }, Enum.EasingStyle.Back)
    local ca, cerr = waitAsset(CENTER_URL)
    center.img.Image = ca or ""
    if not ca then
        center.status.Text = tostring(cerr or "La imagen no cargo")
    end
    if not gui.Parent then return end
    task.wait(0.3)

    -- lista de laterales que ya cargaron (se actualiza sola en cada vuelta)
    local function readyList()
        local list = {}
        for _, u in ipairs(sides) do
            if assetOf[u] then list[#list + 1] = u end
        end
        return list
    end
    local function allDone()
        for _, u in ipairs(sides) do
            if state[u] ~= "done" then return false end
        end
        return true
    end

    -- 2) y 3) pares en bucle, usando solo las que ya estan listas
    local cursor = 0
    while gui.Parent do
        local valid = readyList()
        if #valid == 0 then
            if allDone() then return end -- ninguna cargo
            task.wait(0.1)
        else
            local a = valid[(cursor % #valid) + 1]
            local b = valid[((cursor + 1) % #valid) + 1]
            cursor = cursor + 2

            setImage(left, a)
            setImage(right, b)

            for _, f in ipairs({ left, right }) do
                f.frame.Position = UDim2.new(0.5, 0, 0.5, 0)
                f.frame.GroupTransparency = 1
                f.stroke.Transparency = 1
                f.frame.Visible = true
            end
            moveFrame(left, 0.8, UDim2.new(0.5, -SLIDE_X, 0.5, 0), 0, Enum.EasingStyle.Quart)
            moveFrame(right, 0.8, UDim2.new(0.5, SLIDE_X, 0.5, 0), 0, Enum.EasingStyle.Quart)
            task.wait(0.8 + HOLD_TIME)
            if not gui.Parent then return end

            moveFrame(left, 0.6, UDim2.new(0.5, 0, 0.5, 0), 1, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            moveFrame(right, 0.6, UDim2.new(0.5, 0, 0.5, 0), 1, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            task.wait(0.7)
            left.frame.Visible = false
            right.frame.Visible = false
        end
    end
end)